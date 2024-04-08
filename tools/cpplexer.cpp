// C++ lexer
// Copyright (C) Florian Negele

// This file is part of the Eigen Compiler Suite.

// The ECS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// The ECS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with the ECS.  If not, see <https://www.gnu.org/licenses/>.

#include "charset.hpp"
#include "cpplexer.hpp"
#include "error.hpp"
#include "format.hpp"
#include "stringpool.hpp"
#include "utilities.hpp"

#include <cctype>
#include <cerrno>
#include <cstdlib>

using namespace ECS;
using namespace CPP;

using Context =
	#include "cpplexercontext.hpp"

static const char*const symbols[] {"end of file",
	#define SYMBOL(symbol, name) name,
	#include "cpp.def"
};

Location::Location (const Source& s, const Position& p) :
	source {&s}, position {p}
{
}

void Location::Emit (const Diagnostics::Type type, Diagnostics& diagnostics, const Message& message) const
{
	assert (source); diagnostics.Emit (type, *source, position, message);
	if (origin) origin->Emit (diagnostics);
}

Location::Origin::Origin (const Model m, const Lexer::Token& n) :
	model {m}, name {n}
{
	if (model == Inclusion) name.location.position = GetPlain (name.location.position);
}

void Location::Origin::Emit (Diagnostics& diagnostics) const
{
	switch (model)
	{
	case Expansion:
		assert (name.symbol == Lexer::Identifier); assert (name.identifier);
		return name.location.Emit (Diagnostics::Note, diagnostics, Format ("in expansion of macro '%0'", *name.identifier));

	case Inclusion:
		assert (IsHeaderName (name.symbol)); assert (name.headerName);
		return name.location.Emit (Diagnostics::Note, diagnostics, Format ("in inclusion of %0", name));

	case Substitution:
		assert (name.symbol == Lexer::Identifier); assert (name.identifier);
		return name.location.Emit (Diagnostics::Note, diagnostics, Format ("in substitution of macro parameter '%0'", *name.identifier));

	default:
		assert (Origin::Unreachable);
	}
}

Lexer::Lexer (Diagnostics& d, StringPool& sp, const Annotations a) :
	diagnostics {d}, stringPool {sp}, annotations {a}
{
}

std::ostream& Lexer::Write (std::ostream& stream, const Character character)
{
	return character >= 128 || !std::isgraph (character) && !std::isspace (character) ? stream << UniversalCharacterName {character} : stream << char (character);
}

std::ostream& Lexer::Write (std::ostream& stream, const BasicToken& token)
{
	switch (token.symbol)
	{
	case Eof: case Comment: case Annotation: case Placemarker: return stream;
	case Newline: return stream << '\n';
	case WhiteSpace: return stream << char (token.character);
	case Identifier: return stream << *token.identifier;
	case BinaryInteger: case OctalInteger: case DecimalInteger: case HexadecimalInteger: case DecimalFloating: case HexadecimalFloating: stream << *token.number; break;
	case NarrowCharacter: WriteString (stream, *token.literal, '\''); break;
	case Char8TCharacter: WriteString (stream << "u8", *token.literal, '\''); break;
	case Char16TCharacter: WriteString (stream << 'u', *token.literal, '\''); break;
	case Char32TCharacter: WriteString (stream << 'U', *token.literal, '\''); break;
	case WideCharacter: WriteString (stream << 'L', *token.literal, '\''); break;
	case NarrowString: case RawNarrowString: WriteString (stream, *token.literal, '"'); break;
	case Char8TString: case RawChar8TString: WriteString (stream << "u8", *token.literal, '"'); break;
	case Char16TString: case RawChar16TString: WriteString (stream << 'u', *token.literal, '"'); break;
	case Char32TString: case RawChar32TString: WriteString (stream << 'U', *token.literal, '"'); break;
	case WideString: case RawWideString: WriteString (stream << 'L', *token.literal, '"'); break;
	case UnknownCharacter: return Write (stream, token.character);
	default: return WriteEnum (stream, token.symbol, symbols);
	}
	assert (IsLiteral (token.symbol));
	return token.suffix ? stream << *token.suffix : stream;
}

bool Lexer::Evaluate (const BasicToken& token, CPP::Float& value)
{
	assert (IsFloating (token.symbol)); auto number = *token.number;
	number.erase (std::remove (number.begin (), number.end (), '\''), number.end ());
	errno = 0; value = std::strtod (number.c_str (), nullptr); return errno != ERANGE;
}

bool Lexer::Evaluate (const BasicToken& token, CPP::Unsigned& value)
{
	assert (IsInteger (token.symbol)); static const int bases[] {2, 8, 10, 16};
	const auto base = bases[token.symbol - FirstInteger]; auto number = *token.number;
	number.erase (std::remove (number.begin (), number.end (), '\''), number.end ());
	errno = 0; value = std::strtoull (number.c_str () + (base == 2) * 2, nullptr, base); return errno != ERANGE;
}

Unsigned Lexer::Evaluate (const BasicToken& token, Charset& charset)
{
	assert (IsCharacter (token.symbol));
	assert (!token.literal->empty ());
	return Evaluate (token.literal->front (), charset);
}

Unsigned Lexer::Evaluate (const WString::value_type character, Charset& charset)
{
	return character < 128 ? charset.Encode (character) : character;
}

const CPP::String* Lexer::Insert (const Symbol symbol) const
{
	return stringPool.Insert (symbols[symbol]);
}

Context::Context (const Lexer& le, std::istream& s, const Location& lo) :
	current {Eof, lo}, location {lo}, lexer {le}, stream {s}
{
}

void Context::EmitError (const Location& location, const Message& message) const
{
	location.Emit (Diagnostics::Error, lexer.diagnostics, message); throw Error {};
}

void Context::SkipCurrent ()
{
	Character character; current.location = location;
	if (ReadSource (character)) current.symbol = ReadSymbol (character);
	else current.symbol = current.symbol == Newline ? Eof : Newline;
}

void Context::ReadHeaderName ()
{
	Character character; current.location = location;
	if (!ReadSource (character)) current.symbol = Eof;
	else if (character == '"') current.symbol = ReadHeaderName ('"');
	else if (character == '<') current.symbol = ReadHeaderName ('>');
	else current.symbol = ReadSymbol (character);
}

void Context::ConvertToIdentifier (BasicToken& token)
{
	if (IsKeyword (token.symbol) || IsAlternative (token.symbol))
		assert (token.identifier), token.symbol = Identifier;
}

void Context::ConvertToKeyword (BasicToken& token)
{
	if (token.symbol == Lexer::Identifier) assert (token.identifier),
		token.symbol = Convert (*token.identifier, FirstKeyword, LastKeyword, Convert (*token.identifier, FirstReservedWord, LastReservedWord, Identifier));
}

Context::State Context::SwitchInput (const State& state)
{
	while (!characters.empty ()) assert (IsBasicSource (characters.back ())), Regress (stream, location.position, char (characters.back ())), characters.pop_back ();
	stream.clear (); const State result {location, stream.rdbuf (state.streambuf)}; location = state.location; return result;
}

Lexer::Symbol Context::ReadSymbol (Character character)
{
	if (commenting)
		if (character != '\n') return ReadMultiLineComment (character);
		else return current.character = character, WhiteSpace;

	switch (character) {
	case '\t': case '\v': case '\r': case '\f': case ' ': current.character = character; return WhiteSpace;
	case '\n': return Newline;
	case '!': return Skip ('=') ? ExclamationMarkEqual : ExclamationMark;
	case '"': return ReadLiteral (character, NarrowString);
	case '#': return Skip ('#') ? DoublePound : Pound;
	case '%': return Skip (':') ? Skip ('%') ? Skip (':') ? DoublePercentColon : (Putback ('%'), PercentColon) : PercentColon : Skip ('>') ? PercentGreater : Skip ('=') ? PercentEqual : Percent;
	case '&': return Skip ('=') ? AmpersandEqual : Skip ('&') ? DoubleAmpersand : Ampersand;
	case '\'': return ReadLiteral (character, NarrowCharacter);
	case '(': return LeftParen;
	case ')': return RightParen;
	case '*': return Skip ('=') ? AsteriskEqual : Asterisk;
	case '+': return Skip ('=') ? PlusEqual : Skip ('+') ? DoublePlus : Plus;
	case ',': return Comma;
	case '-': return Skip ('=') ? MinusEqual : Skip ('-') ? DoubleMinus : Skip ('>') ? Skip ('*') ? ArrowAsterisk : Arrow : Minus;
	case '.': return ReadSource (character) ? character == '*' ? DotAsterisk : character == '.' ? Skip ('.') ? Ellipsis : (Putback ('.'), Dot) : IsDigit (character) ? Putback (character), ReadNumber ('.') : (Putback (character), Dot) : Dot;
	case '/': return Skip ('=') ? SlashEqual : Skip ('/') ? ReadSource (character) ? ReadSingleLineComment (character) : Comment : Skip ('*') ? ReadSource (character) ? ReadMultiLineComment (character) : Comment : Slash;
	case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9': return ReadNumber (character);
	case ':': return Skip ('>') ? ColonGreater : Skip (':') ? DoubleColon : Colon;
	case ';': return Semicolon;
	case '<': return Skip ('%') ? LessPercent : Skip ('=') ? LessEqual : Skip ('<') ? Skip ('=') ? DoubleLessEqual : DoubleLess : Skip (':') ? Skip (':') ? ReadSource (character) ?
		character != ':' && character != '>' ? Putback (character), Putback (':'), Putback (':'), Less : (Putback (character), Putback (':'), LessColon) : (Putback (':'), LessColon) : LessColon : Less;
	case '=': return Skip ('=') ? DoubleEqual : Equal;
	case '>': return Skip ('=') ? GreaterEqual : Skip ('>') ? Skip ('=') ? DoubleGreaterEqual : DoubleGreater : Greater;
	case '?': return QuestionMark;
	case '[': return LeftBracket;
	case ']': return RightBracket;
	case '^': return Skip ('=') ? CaretEqual : Caret;
	case 'A': case 'B': case 'C': case 'D': case 'E': case 'F': case 'G': case 'H': case 'I': case 'J':
	case 'K': case 'L': case 'M': case 'N': case 'O': case 'P': case 'Q': case 'R': case 'S': case 'T':
	case 'U': case 'V': case 'W': case 'X': case 'Y': case 'Z': case 'a': case 'b': case 'c': case 'd':
	case 'e': case 'f': case 'g': case 'h': case 'i': case 'j': case 'k': case 'l': case 'm': case 'n':
	case 'o': case 'p': case 'q': case 'r': case 's': case 't': case 'u': case 'v': case 'w': case 'x':
	case 'y': case 'z': case '_': return ReadIdentifier (character);
	case '{': return LeftBrace;
	case '|': return Skip ('=') ? BarEqual : Skip ('|') ? DoubleBar : Bar;
	case '}': return RightBrace;
	case '~': return Tilde;
	default:
		if (IsUniversal (character) && !IsInitiallyDisallowed (character)) return ReadIdentifier (character);
		current.character = character; return UnknownCharacter;
	}
}

bool Context::ReadPhysical (Character& character)
{
	char physicalCharacter;
	if (!Advance (stream, location.position, physicalCharacter)) return false;
	character = (unsigned char) physicalCharacter;
	if (physicalCharacter != '\r') return true; character = '\n';
	return !stream.good () || stream.peek () != '\n' || Advance (stream, location.position, physicalCharacter);
}

bool Context::Read (Character& character)
{
	if (!characters.empty ()) character = characters.back (), characters.pop_back (), location.position.Advance (character);
	else if (!ReadPhysical (character)) if (commenting) EmitError (location, Format ("%0 ends in partial comment", GetOrigin (location))); else return character = 0, false;
	return true;
}

void Context::Putback (const Character character)
{
	if (character) characters.push_back (character), location.position.Regress (character);
}

bool Context::ReadSource (Character& character)
{
	while (Read (character))
		if (character != '\\') return true;
		else if (!Read (character)) return character = '\\', true;
		else if (character == 'u') return ReadCheckedUniversal (character, 4), true;
		else if (character == 'U') return ReadCheckedUniversal (character, 8), true;
		else if (character != '\n') return Putback (character), character = '\\', true;
	return false;
}

void Context::ReadUniversal (Character& character, Length length)
{
	character = 0; const auto backslash = location;
	for (Character digit = 0; length; --length)
		if (!Read (digit)) EmitError (location, Format ("%0 ends in partial universal character name", GetOrigin (location)));
		else if (IsHexadecimalDigit (digit)) character = character * 16 + GetHexadecimalValue (digit);
		else Putback (digit), EmitError (location, "invalid character in universal character name");
	if (character >= 0xd800 && character <= 0xdfff)
		EmitError (backslash, Format ("value of universal character name '%0' corresponds to surrogate code point", UniversalCharacterName {character}));
	if (character > 0x10ffff)
		EmitError (backslash, Format ("invalid universal character name '%0'", UniversalCharacterName {character}));
}

void Context::ReadCheckedUniversal (Character& character, const Length length)
{
	const auto backslash = location;
	ReadUniversal (character, length);
	if (character <= 0x1f || character >= 0x7f && character <= 0x9f)
		EmitError (backslash, Format ("value of universal character name '%0' corresponds to a control character", UniversalCharacterName {character}));
	if (IsBasicSource (character))
		EmitError (backslash, Format ("value of universal character name '%0' corresponds to a basic source character", UniversalCharacterName {character}));
}

void Context::ReadEscaped (Character& character)
{
	if (character == 'a') character = 0x7;
	else if (character == 'b') character = 0x8;
	else if (character == 'f') character = 0xc;
	else if (character == 'n') character = 0xa;
	else if (character == 'r') character = 0xd;
	else if (character == 't') character = 0x9;
	else if (character == 'v') character = 0xb;
	else if (character == 'u') ReadUniversal (character, 4);
	else if (character == 'U') ReadUniversal (character, 8);
	else if (IsOctalDigit (character)) ReadOctalEscaped (character);
	else if (character == 'x') ReadHexadecimalEscaped (character);
	else if (character != '\'' && character != '"' && character != '?' && character != '\\')
		Putback (character), EmitError (location, "invalid character in escape sequence");
}

void Context::ReadOctalEscaped (Character& character)
{
	character = GetOctalValue (character);
	for (Character length = 1, digit; length != 3 && Read (digit); ++length)
		if (IsOctalDigit (digit)) character = character * 8 + GetOctalValue (digit);
		else {Putback (digit); break;}
}

void Context::ReadHexadecimalEscaped (Character& character)
{
	const auto sequence = location;
	if (!Read (character)) EmitError (location, Format ("%0 ends in partial hexadecimal escape sequence", GetOrigin (location)));
	if (!IsHexadecimalDigit (character)) Putback (character), EmitError (location, "invalid character in hexadecimal escape sequence");
	character = GetHexadecimalValue (character); Length length = character != 0;
	for (Character digit; Read (digit); length += character != 0)
		if (IsHexadecimalDigit (digit)) character = character * 16 + GetHexadecimalValue (digit);
		else {Putback (digit); break;}
	if (length > 8) EmitError (sequence, "overflow in hexadecimal escape sequence");
}

bool Context::Skip (const Character next)
{
	Character character;
	if (!ReadSource (character)) return false;
	if (character == next) return true;
	return Putback (character), false;
}

Lexer::Symbol Context::ReadSingleLineComment (Character character)
{
	std::stringstream stream;
	const auto annotate = lexer.annotations && character == '/' && ReadSource (character);
	do
	{
		if (character == '\f') while (ReadSource (character) && character != '\n')
			if (!IsWhiteSpace (character)) Putback (character), EmitError (location, "encountered non-white-space character after form-feed character");
		if (character == '\v') while (ReadSource (character) && character != '\n')
			if (!IsWhiteSpace (character)) Putback (character), EmitError (location, "encountered non-white-space character after vertical-tab character");
		if (character == '\n') {Putback ('\n'); break;}
		if (annotate) Write (stream, character);
	}
	while (ReadSource (character));
	if (!annotate) return Comment; const auto annotation = Trim (stream);
	return !annotation.empty () ? current.annotation = lexer.stringPool.Insert (annotation), Annotation : Comment;
}

Lexer::Symbol Context::ReadMultiLineComment (Character character)
{
	std::stringstream stream; commenting = true;
	const auto annotate = lexer.annotations && character == '*' && ReadSource (character);
	do
	{
		if (character == '*' && Skip ('/')) {commenting = false; break;}
		if (character == '\n') {Putback ('\n'); break;}
		if (annotate) if (character == '/' && stream.tellp () <= 0) {commenting = false; break;} else Write (stream, character);
	}
	while (ReadSource (character));
	if (!annotate) return Comment; const auto annotation = Trim (stream);
	return !annotation.empty () ? current.annotation = lexer.stringPool.Insert (annotation), Annotation : Comment;
}

Lexer::Symbol Context::ReadHeaderName (Character character)
{
	const auto delimiter = character; const auto symbol = delimiter == '"' ? SourceFile : Header;
	for (String headerName;; headerName.push_back (character))
		if (!Read (character)) EmitError (location, Format ("%0 ends in partial %1", GetOrigin (location), symbol));
		else if (character == '\n') Putback (character), EmitError (location, Format ("new-line character in %0", symbol));
		else if (character == delimiter) return current.headerName = lexer.stringPool.Insert (headerName), symbol;
}

Lexer::Symbol Context::ReadIdentifier (Character character)
{
	std::ostringstream stream; String identifier;
	for (Write (stream, character); ReadSource (character); Write (stream, character))
		if (!IsNondigit (character) && !IsDigit (character) && !IsUniversal (character))
			if (identifier = stream.str (), character != '\'' && character != '"') {Putback (character); break;}
			else if (identifier == "u8") return ReadLiteral (character, character == '"' ? Char8TString : Char8TCharacter);
			else if (identifier == "u") return ReadLiteral (character, character == '"' ? Char16TString : Char16TCharacter);
			else if (identifier == "U") return ReadLiteral (character, character == '"' ? Char32TString : Char32TCharacter);
			else if (identifier == "L") return ReadLiteral (character, character == '"' ? WideString : WideCharacter);
			else if (identifier == "R" && character == '"') return ReadRawLiteral (character, RawNarrowString);
			else if (identifier == "u8R" && character == '"') return ReadRawLiteral (character, RawChar8TString);
			else if (identifier == "uR" && character == '"') return ReadRawLiteral (character, RawChar16TString);
			else if (identifier == "UR" && character == '"') return ReadRawLiteral (character, RawChar32TString);
			else if (identifier == "LR" && character == '"') return ReadRawLiteral (character, RawWideString);
			else {Putback (character); break;}
	if (identifier.empty ()) identifier = stream.str ();
	current.identifier = lexer.stringPool.Insert (identifier);
	return Convert (identifier, FirstAlternative, LastAlternative, Identifier);
}

Lexer::Symbol Context::ReadNumber (Character character)
{
	Character exponent = 0, sign; String number; current.suffix = nullptr;
	auto symbol = character == '0' ? OctalInteger : character == '.' ? DecimalFloating : DecimalInteger;
	static bool (*const validate[6]) (Character) {IsBinaryDigit, IsDigit, IsDigit, IsHexadecimalDigit, IsDigit, IsHexadecimalDigit};
	for (number.push_back (character); ReadSource (character); number.push_back (character))
		if ((exponent ? IsDigit : validate[symbol - FirstInteger]) (character)) continue;
		else if ((character == 'b' || character == 'B') && symbol == OctalInteger && number.size () == 1) symbol = BinaryInteger;
		else if ((character == 'x' || character == 'X') && symbol == OctalInteger && number.size () == 1) symbol = HexadecimalInteger;
		else if (character == '\'' && number.size () > 2u * (symbol == BinaryInteger || symbol == HexadecimalInteger) && number.back () != '\'') continue;
		else if (character == '.' && (symbol == OctalInteger || symbol == DecimalInteger || symbol == HexadecimalInteger) && number.back () != '\'') symbol = symbol == HexadecimalInteger ? HexadecimalFloating : DecimalFloating;
		else if (((character == 'e' || character == 'E') && (symbol == OctalInteger || symbol == DecimalInteger || symbol == DecimalFloating) || (character == 'p' || character == 'P') && (symbol == HexadecimalInteger || symbol == HexadecimalFloating)) && !exponent && number.back () != '\'')
			if (exponent = character, !ReadSource (character)) {character = exponent; break;}
			else if (IsDigit (character)) number.push_back (exponent), symbol = symbol == HexadecimalInteger || symbol == HexadecimalFloating ? HexadecimalFloating : DecimalFloating;
			else if (character != '+' && character != '-') {Putback (character); character = exponent; break;}
			else if (sign = character, !ReadSource (character)) {character = 0; break;}
			else if (IsDigit (character)) number.push_back (exponent), number.push_back (sign), symbol = symbol == HexadecimalInteger || symbol == HexadecimalFloating ? HexadecimalFloating : DecimalFloating;
			else {Putback (character); character = sign; break;}
		else break;
	if (number.back () == '\'') Putback (character), number.pop_back (), character = '\'';
	if ((symbol == BinaryInteger || symbol == HexadecimalInteger) && number.size () == 2) symbol = OctalInteger, Putback (character), character = number.back (), number.pop_back ();
	if (symbol == OctalInteger) if (const auto size = number.find_first_of ("89") + 1) do Putback (character), character = number.back (), number.pop_back (); while (number.size () >= size);
	if (IsNondigit (character) || IsUniversal (character) && !IsInitiallyDisallowed (character)) ReadSuffix (character); else Putback (character);
	current.number = lexer.stringPool.Insert (number); return symbol;
}

Lexer::Symbol Context::ReadLiteral (Character character, const Symbol symbol)
{
	WString literal; current.suffix = nullptr; const auto quote = location;
	for (auto delimiter = character;;)
	{
		if (!Read (character)) EmitError (location, Format ("%0 ends in partial %1", GetOrigin (location), symbol));
		else if (character == '\n') Putback (character), EmitError (location, Format ("encountered new-line character in %0", symbol));
		else if (character == delimiter) if (literal.empty () && IsCharacter (symbol)) EmitError (quote, Format ("empty %0", symbol)); else break;
		else if (character == '\\')
			if (!Read (character)) EmitError (location, Format ("%0 ends in partial escape sequence", GetOrigin (location)));
			else if (character == '\n') continue;
			else ReadEscaped (character);
		literal.push_back (character);
	}
	if (ReadSource (character))
		if (IsNondigit (character) || IsUniversal (character) && !IsInitiallyDisallowed (character)) ReadSuffix (character);
		else Putback (character);
	current.literal = lexer.stringPool.Insert (literal); return symbol;
}

Lexer::Symbol Context::ReadRawLiteral (Character character, const Symbol symbol)
{
	WString delimiter, literal; current.suffix = nullptr; const auto quote = location; delimiter.reserve (20); delimiter.push_back (')');
	for (;;) if (!Read (character)) EmitError (location, Format ("%0 ends in partial raw string delimiter", GetOrigin (location)));
	else if (IsWhiteSpace (character) || character == ')' || character == '\\' || !IsBasicSource (character))
		Putback (character), EmitError (location, "encountered invalid character in raw string delimiter");
	else if (delimiter.size () == 18) EmitError (quote, "raw string delimiter too large");
	else if (character != '(') delimiter.push_back (character); else break;
	for (delimiter.push_back ('"'); literal.size () < delimiter.size () || !std::equal (literal.end () - delimiter.size (), literal.end (), delimiter.begin ()); literal.push_back (character))
		if (!Read (character)) EmitError (location, Format ("%0 ends in partial %1", GetOrigin (location), symbol));
	if (ReadSource (character))
		if (IsNondigit (character) || IsUniversal (character) && !IsInitiallyDisallowed (character)) ReadSuffix (character);
		else Putback (character);
	literal.resize (literal.size () - delimiter.size ()); current.literal = lexer.stringPool.Insert (literal);
	return symbol;
}

void Context::ReadSuffix (Character character)
{
	std::ostringstream stream;
	for (Write (stream, character); ReadSource (character); Write (stream, character))
		if (!IsNondigit (character) && !IsDigit (character) && !IsUniversal (character)) {Putback (character); break;}
	current.suffix = lexer.stringPool.Insert (stream.str ());
}

String Context::Trim (std::istream& stream)
{
	String annotation; for (String word; stream >> word; annotation.append (word)) if (!annotation.empty ()) annotation.push_back (' '); return annotation;
}

Lexer::Symbol Context::Convert (const String& identifier, const Symbol first, const Symbol last, const Symbol def)
{
	const auto symbol = std::lower_bound (symbols + first, symbols + last + 1, identifier);
	return symbol <= symbols + last && *symbol == identifier ? Symbol (symbol - symbols) : def;
}

Context::State::State (const Location& l, std::streambuf*const sb) :
	location {l}, streambuf {sb}
{
	assert (sb);
}

bool Context::IsDigit (const Character character)
{
	return character >= '0' && character <= '9';
}

bool Context::IsNondigit (const Character character)
{
	return character >= 'a' && character <= 'z' || character >= 'A' && character <= 'Z' || character == '_';
}

bool Context::IsUniversal (const Character character)
{
	if (character >= 0x10000 && character < 0xf00000) return character % 0x10000 <= 0xfffd;

	if (character >= 0xf900) return character <= 0xfd3d || character >= 0xfd40 && character <= 0xfdcf ||
		character >= 0xfdf0 && character <= 0xfe44 || character >= 0xfe47 && character <= 0xfffd;

	if (character >= 0x3004) return character <= 0x3007 || character >= 0x3021 && character <= 0x302f ||
		character >= 0x3031 && character <= 0x303f || character >= 0x3040 && character <= 0xd7ff;

	if (character >= 0x200b) return character <= 0x200d || character >= 0x202a && character <= 0x202e ||
		character >= 0x203f && character <= 0x2040 || character == 0x2054 ||
		character >= 0x2060 && character <= 0x206f || character >= 0x2070 && character <= 0x218f ||
		character >= 0x2460 && character <= 0x24ff || character >= 0x2776 && character <= 0x2793 ||
		character >= 0x2c00 && character <= 0x2dff || character >= 0x2e80 && character <= 0x2fff;

	if (character >= 0x0100) return character <= 0x167f || character >= 0x1681 && character <= 0x180d ||
		character >= 0x180f && character <= 0x1fff;

	return character == 0x00a8 || character == 0x00aa || character == 0x00ad || character == 0x00af ||
		character >= 0x00b2 && character <= 0x00b5 || character >= 0x00b7 && character <= 0x00ba ||
		character >= 0x00bc && character <= 0x00be || character >= 0x00c0 && character <= 0x00d6 ||
		character >= 0x00d8 && character <= 0x00f6 || character >= 0x00f8 && character <= 0x00ff;
}

bool Context::IsInitiallyDisallowed (const Character character)
{
	return character >= 0x0300 && character <= 0x036f || character >= 0x1dc0 && character <= 0x1dff ||
		character >= 0x20d0 && character <= 0x20ff || character >= 0xfe20 && character <= 0xfe2f;
}

bool Context::IsWhiteSpace (const Character character)
{
	return character == '\t' || character == '\n' || character == '\v' || character == '\r' || character == '\f' || character == ' ';
}

bool Context::IsBasicSource (const Character character)
{
	return IsWhiteSpace (character) || character >= 0x21 && character <= 0x23 || character >= 0x25 && character <= 0x3f ||
		character >= 0x41 && character <= 0x5f || character >= 0x61 && character <= 0x7e;
}

bool Context::IsBinaryDigit (const Character character)
{
	return character == '0' || character == '1';
}

bool Context::IsOctalDigit (const Character character)
{
	return character >= '0' && character <= '7';
}

bool Context::IsHexadecimalDigit (const Character character)
{
	return character >= '0' && character <= '9' || character >= 'a' && character <= 'f' || character >= 'A' && character <= 'F';
}

Lexer::Character Context::GetOctalValue (const Character character)
{
	assert (IsOctalDigit (character));
	return character - '0';
}

Lexer::Character Context::GetHexadecimalValue (const Character character)
{
	assert (IsHexadecimalDigit (character));
	if (character >= 'a' && character <= 'f') return character - 'a' + 10;
	if (character >= 'A' && character <= 'F') return character - 'A' + 10;
	return character - '0';
}

bool CPP::IsCast (const Lexer::Symbol symbol)
{
	return symbol == Lexer::ConstCast || symbol == Lexer::StaticCast || symbol == Lexer::DynamicCast || symbol == Lexer::ReinterpretCast;
}

bool CPP::IsPound (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Pound || symbol == Lexer::PercentColon;
}

bool CPP::IsValid (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstKeyword && symbol <= Lexer::LastLiteral;
}

bool CPP::IsNumber (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstNumber && symbol <= Lexer::LastNumber;
}

bool CPP::IsString (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstString && symbol <= Lexer::LastString;
}

bool CPP::IsInteger (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstInteger && symbol <= Lexer::LastInteger;
}

bool CPP::IsKeyword (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstKeyword && symbol <= Lexer::LastKeyword;
}

bool CPP::IsReservedWord (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstReservedWord && symbol <= Lexer::LastReservedWord;
}

bool CPP::IsLiteral (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstLiteral && symbol <= Lexer::LastLiteral;
}

bool CPP::IsOperator (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstOperator && symbol <= Lexer::LastOperator;
}

bool CPP::IsAttribute (const Lexer::Symbol symbol)
{
	return symbol == Lexer::DoubleLeftBracket || symbol == Lexer::Alignas;
}

bool CPP::IsCharacter (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstCharacter && symbol <= Lexer::LastCharacter;
}

bool CPP::IsRawString (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstRawString && symbol <= Lexer::LastRawString;
}

bool CPP::IsIdentifier (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Identifier || symbol == Lexer::Operator || symbol == Lexer::Tilde || IsNestedNameSpecifier (symbol);
}

bool CPP::IsAlternative (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstAlternative && symbol <= Lexer::LastAlternative;
}

bool CPP::IsDoubleAmpersand (const Lexer::Symbol symbol)
{
	return symbol == Lexer::DoubleAmpersand || symbol == Lexer::And;
}

bool CPP::IsDoubleBar (const Lexer::Symbol symbol)
{
	return symbol == Lexer::DoubleBar || symbol == Lexer::Or;
}

bool CPP::IsDoublePound (const Lexer::Symbol symbol)
{
	return symbol == Lexer::DoublePound || symbol == Lexer::DoublePercentColon;
}

bool CPP::IsConcatenator (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Concatenator;
}

bool CPP::IsFunctionBody (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Colon || symbol == Lexer::LeftBrace || symbol == Lexer::LessPercent || symbol == Lexer::Try || symbol == Lexer::Equal;
}

bool CPP::IsStorageClass (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Static || symbol == Lexer::ThreadLocal || symbol == Lexer::Extern || symbol == Lexer::Mutable;
}

bool CPP::IsFloating (const Lexer::Symbol symbol)
{
	return symbol == Lexer::DecimalFloating || symbol == Lexer::HexadecimalFloating;
}

bool CPP::IsTypeSpecifier (const Lexer::Symbol symbol)
{
	return IsSimpleTypeSpecifier (symbol) || IsElaboratedTypeSpecifier (symbol) || IsConstVolatileQualifier (symbol);
}

bool CPP::IsUnaryOperator (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Plus || symbol == Lexer::Minus || symbol == Lexer::ExclamationMark || symbol == Lexer::Not || symbol == Lexer::Tilde || symbol == Lexer::Compl;
}

bool CPP::IsAccessSpecifier (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Private || symbol == Lexer::Protected || symbol == Lexer::Public;
}

bool CPP::IsClassKey (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Class || symbol == Lexer::Struct || symbol == Lexer::Union;
}

bool CPP::IsPointerOperator (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Asterisk || symbol == Lexer::Ampersand || symbol == Lexer::Bitand || symbol == Lexer::DoubleAmpersand || symbol == Lexer::And || IsNestedNameSpecifier (symbol);
}

bool CPP::IsFunctionOperator (const Lexer::Symbol symbol)
{
	return symbol >= Lexer::FirstFunctionOperator && symbol <= Lexer::LastFunctionOperator || symbol == Lexer::New || symbol == Lexer::Delete ||
		symbol == Lexer::LeftParen || symbol == Lexer::LeftBracket || symbol == Lexer::LessColon;
}

bool CPP::IsNestedNameSpecifier (const Lexer::Symbol symbol)
{
	return symbol == Lexer::DoubleColon || symbol == Lexer::Identifier || symbol == Lexer::Decltype;
}

bool CPP::IsFunctionSpecifier (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Virtual || symbol == Lexer::Explicit;
}

bool CPP::IsAbstractDeclarator (const Lexer::Symbol symbol)
{
	return IsPointerOperator (symbol) || symbol == Lexer::LeftParen || symbol == Lexer::LeftBracket || symbol == Lexer::LessColon || symbol == Lexer::Ellipsis;
}

bool CPP::IsAssignmentOperator (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Equal || symbol == Lexer::AsteriskEqual || symbol == Lexer::SlashEqual || symbol == Lexer::PercentEqual || symbol == Lexer::PlusEqual ||
		symbol == Lexer::MinusEqual || symbol == Lexer::DoubleGreaterEqual || symbol == Lexer::DoubleLessEqual || symbol == Lexer::AmpersandEqual ||
		symbol == Lexer::AndEq || symbol == Lexer::CaretEqual || symbol == Lexer::XorEq || symbol == Lexer::BarEqual || symbol == Lexer::OrEq;
}

bool CPP::IsReferenceQualifier (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Ampersand || symbol == Lexer::Bitand || symbol == Lexer::DoubleAmpersand || symbol == Lexer::And;
}

bool CPP::IsExpressionDelimiter (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Semicolon || symbol == Lexer::Comma || symbol == Lexer::Colon || symbol == Lexer::RightParen ||
		symbol == Lexer::RightBracket || symbol == Lexer::ColonGreater || symbol == Lexer::RightBrace || symbol == Lexer::PercentGreater;
}

bool CPP::IsSimpleTypeSpecifier (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Char || symbol == Lexer::Char16T || symbol == Lexer::Char32T || symbol == Lexer::WCharT || symbol == Lexer::Bool ||
		symbol == Lexer::Short || symbol == Lexer::Int || symbol == Lexer::Long || symbol == Lexer::Signed || symbol == Lexer::Unsigned ||
		symbol == Lexer::Float || symbol == Lexer::Double || symbol == Lexer::Void || symbol == Lexer::Auto || symbol == Lexer::Decltype;
}

bool CPP::IsDeclarationSpecifier (const Lexer::Symbol symbol)
{
	return IsStorageClass (symbol) || IsFunctionSpecifier (symbol) || IsTypeSpecifier (symbol) ||
		symbol == Lexer::Friend || symbol == Lexer::Typedef || symbol == Lexer::Constexpr || symbol == Lexer::Inline;
}

bool CPP::IsConstVolatileQualifier (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Const || symbol == Lexer::Volatile;
}

bool CPP::IsElaboratedTypeSpecifier (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Class || symbol == Lexer::Struct || symbol == Lexer::Union || symbol == Lexer::Enum;
}

bool CPP::IsHeaderName (const Lexer::Symbol symbol)
{
	return symbol == Lexer::SourceFile || symbol == Lexer::Header;
}

Lexer::Symbol CPP::GetOrigin (const Location& location)
{
	for (auto origin = location.origin; origin; origin = origin->name.location.origin)
		if (origin->model == Location::Origin::Inclusion) return origin->name.symbol;
	return Lexer::SourceFile;
}

Lexer::Symbol CPP::GetString (const Lexer::Symbol symbol)
{
	assert (IsString (symbol));
	return IsRawString (symbol) ? Lexer::Symbol (symbol - Lexer::FirstRawString + Lexer::FirstString) : symbol;
}

Lexer::Symbol CPP::GetPrimary (const Lexer::Symbol symbol)
{
	assert (IsAlternative (symbol));
	static const Lexer::Symbol primaries[] {
		#define ALTERNATIVE(alternative, name, primary) Lexer::primary,
		#include "cpp.def"
	};
	return primaries[symbol - Lexer::FirstAlternative];
}

bool CPP::HasStringSuffix (const Lexer::BasicToken& token)
{
	assert (IsString (token.symbol)); return token.suffix;
}

bool CPP::HasFloatingSuffix (const Lexer::BasicToken& token, bool& isFloat, bool& isLongDouble)
{
	assert (IsFloating (token.symbol)); if (!token.suffix || token.suffix->size () != 1) return false;
	auto character = token.suffix->front (); isFloat = character == 'f' || character == 'F';
	isLongDouble = character == 'l' || character == 'L'; return isFloat || isLongDouble;
}

bool CPP::HasIntegerSuffix (const Lexer::BasicToken& token, bool& isUnsigned, bool& isLong, bool& isLongLong)
{
	assert (IsInteger (token.symbol)); if (!token.suffix) return false;
	isUnsigned = (token.suffix->find ('u') != token.suffix->npos || token.suffix->find ('U') != token.suffix->npos);
	isLongLong = (token.suffix->find ("ll") != token.suffix->npos || token.suffix->find ("LL") != token.suffix->npos);
	isLong = !isLongLong && (token.suffix->find ('l') != token.suffix->npos || token.suffix->find ('L') != token.suffix->npos);
	return token.suffix->size () == String::size_type (isUnsigned + isLong + isLongLong * 2);
}

Lexer::BasicToken::BasicToken (const Symbol s) :
	symbol {s}, character {' '}
{
}

Lexer::BasicToken::BasicToken (const Symbol sy, const String*const n, const String*const su) :
	symbol {sy}, suffix {su}, number {n}
{
	assert (number);
	assert (IsNumber (symbol));
}

Lexer::BasicToken::BasicToken (const Symbol s, const WString*const l) :
	symbol {s}, suffix {nullptr}, literal {l}
{
	assert (literal);
	assert (!IsNumber (symbol));
	assert (IsLiteral (symbol));
}

bool Lexer::BasicToken::operator == (const BasicToken& other) const
{
	if (symbol != other.symbol) return false;
	if (symbol == Lexer::Identifier) return identifier == other.identifier;
	if (IsNumber (symbol)) return number == other.number && suffix == other.suffix;
	if (IsLiteral (symbol)) return literal == other.literal && suffix == other.suffix;
	if (IsHeaderName (symbol)) return headerName == other.headerName;
	if (symbol == Lexer::WhiteSpace || symbol == Lexer::UnknownCharacter) return character == other.character;
	return true;
}

Lexer::Token::Token (const BasicToken& t, const Location& l) :
	BasicToken {t}, location {l}
{
}

std::ostream& CPP::operator << (std::ostream& stream, const Lexer::Symbol symbol)
{
	WriteEnum (stream, symbol, symbols);
	if (IsLiteral (symbol)) stream << " literal";
	return stream;
}

std::ostream& CPP::operator << (std::ostream& stream, const Lexer::BasicToken& token)
{
	if (IsOperator (token.symbol)) return stream << token.symbol << " operator";
	if (IsString (token.symbol) && token.literal->empty ()) stream << "empty ";
	if (IsLiteral (token.symbol) && token.suffix) if (IsString (token.symbol)) stream << "user-defined "; else stream << "suffixed ";
	if (IsNumber (token.symbol)) return stream << token.symbol << ' ' << *token.number;
	if (IsLiteral (token.symbol) && !token.literal->empty () && !IsRawString (token.symbol)) return WriteString (stream << token.symbol << ' ', *token.literal, '\'');
	if (IsReservedWord (token.symbol)) return WriteString (stream << "reserved word ", *token.identifier, '\'');
	if (IsHeaderName (token.symbol)) return WriteString (stream << token.symbol << ' ', *token.headerName, '\'');
	if (token.symbol == Lexer::Identifier) return WriteString (stream << token.symbol << ' ', *token.identifier, '\'');
	if (token.symbol == Lexer::UnknownCharacter) return Lexer::Write (stream << token.symbol << " '", token.character) << '\'';
	return stream << token.symbol;
}

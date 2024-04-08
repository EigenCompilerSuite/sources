// Generic assembly language lexer
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

#include "asmlexer.hpp"
#include "position.hpp"
#include "utilities.hpp"

#include <algorithm>
#include <cassert>
#include <cctype>

using namespace ECS;
using namespace Assembly;

static Lexer::Symbol modes[] {Lexer::Invalid, Lexer::Offset, Lexer::Size, Lexer::Extent, Lexer::Position, Lexer::Index, Lexer::Count};

static const char*const symbols[] {"invalid token", "end of file",
	#define SYMBOL(symbol, name) name,
	#include "assembly.def"
};

Location::Location (const Source& s, const Line l) :
	source {&s}, line {l}
{
	assert (line);
}

void Location::Emit (const Diagnostics::Type type, Diagnostics& diagnostics, const Message& message) const
{
	assert (source); diagnostics.Emit (type, *source, line, message);
}

void Lexer::Scan (std::istream& stream, Token& token) const
{
	char character;
	if (token.symbol == Newline) ++token.location.line;
	while (stream.get (character) && std::isspace (character) && character != '\n')
		if (character == '\r' && stream.good () && stream.peek () != '\n') return void (token.symbol = Newline);
	if (!stream) {token.symbol = Eof; return;}

	switch (character)
	{
	case '=': token.symbol = stream.peek () == '=' && stream.ignore () ? stream.peek () == '=' && stream.ignore () ? Identical : Equal : Invalid; break;
	case '+': token.symbol = Plus; break;
	case '-': token.symbol = Minus; break;
	case '*': token.symbol = Times; break;
	case '/': token.symbol = Slash; break;
	case '%': token.symbol = Modulo; break;
	case '<': token.symbol = stream.peek () == '<' && stream.ignore () ? LeftShift : stream.peek () == '=' && stream.ignore () ? LessEqual : Less; break;
	case '>': token.symbol = stream.peek () == '>' && stream.ignore () ? RightShift : stream.peek () == '=' && stream.ignore () ? GreaterEqual : Greater; break;
	case '!': token.symbol = stream.peek () == '=' && stream.ignore () ? stream.peek () == '=' && stream.ignore () ? Unidentical : Unequal : LogicalNot; break;
	case '~': token.symbol = BitwiseNot; break;
	case '|': token.symbol = stream.peek () == '|' && stream.ignore () ? LogicalOr : BitwiseOr; break;
	case '&': token.symbol = stream.peek () == '&' && stream.ignore () ? LogicalAnd : BitwiseAnd; break;
	case '^': token.symbol = BitwiseXor; break;
	case ',': token.symbol = Comma; break;
	case ':': token.symbol = Colon; break;
	case '\n': token.symbol = Newline; break;
	case ';': while (stream.get (character) && character != '\n'); token.symbol = stream ? Newline : Eof; break;
	case '(': token.symbol = LeftParen; break;
	case ')': token.symbol = RightParen; break;
	case '[': token.symbol = LeftBracket; break;
	case ']': token.symbol = RightBracket; break;
	case '{': token.symbol = LeftBrace; break;
	case '}': token.symbol = RightBrace; break;
	case '\'': token.symbol = ReadString (stream.putback ('\''), token.string, '\'') && !token.string.empty () && token.string.size () <= 8 ? Character : Invalid; break;
	case '"': token.symbol = ReadString (stream.putback ('"'), token.string, '"') ? String : Invalid; break;
	case '@': if (stream.peek () == '"') token.symbol = ReadString (stream, token.string, '"') ? Address : Invalid; else ReadIdentifier (stream, token, Address); break;
	default: if (std::isdigit (character)) ReadNumber (stream, character, token); else ReadIdentifier (stream.putback (character), token, Identifier);
	}
}

Lexer::Symbol Lexer::Convert (const Assembly::Identifier& identifier, const Symbol first, const Symbol last, const Symbol def)
{
	const auto symbol = std::lower_bound (symbols + first, symbols + last + 1, identifier);
	return symbol <= symbols + last && *symbol == identifier ? Symbol (symbol - symbols) : def;
}

void Lexer::ReadIdentifier (std::istream& stream, Token& token, const Symbol symbol)
{
	if (std::isspace (stream.peek ()) || !ECS::ReadIdentifier (stream, token.string, symbol == Address ? IsAddress : IsIdentifier)) token.symbol = Invalid;
	else if (symbol == Identifier) token.symbol = Convert (token.string, FirstDirective, LastDirective, Identifier);
	else token.symbol = symbol;
}

void Lexer::ReadNumber (std::istream& stream, char character, Token& token)
{
	token.string.clear ();

	if (character != '0' || !stream.get (character)) token.symbol = Integer;
	else if (character == 'b' && std::isxdigit (stream.peek ()) && stream.get (character)) token.symbol = BinInteger;
	else if (character == 'o' && std::isxdigit (stream.peek ()) && stream.get (character)) token.symbol = OctInteger;
	else if (character == 'd' && std::isxdigit (stream.peek ()) && stream.get (character)) token.symbol = DecInteger;
	else if (character == 'x' && std::isxdigit (stream.peek ()) && stream.get (character)) token.symbol = HexInteger;
	else if (character == 'h' && std::isxdigit (stream.peek ()) && stream.get (character)) token.symbol = HexInteger;
	else token.symbol = Integer, stream.putback (character), character = '0';

	do if (stream.peek () == '\'' && !std::isxdigit (stream.ignore ().peek ())) stream.putback ('\'');
	while (token.string.push_back (character), stream.get (character) && std::isxdigit (character));

	if (character == 'o')
		if (token.symbol == Integer) token.symbol = OctInteger;
		else stream.putback (character);
	else if (character == 'h')
		if (token.symbol == BinInteger) token.symbol = HexInteger, token.string.insert (0, 1, 'b');
		else if (token.symbol == DecInteger) token.symbol = HexInteger, token.string.insert (0, 1, 'd');
		else if (token.symbol == Integer) token.symbol = HexInteger;
		else stream.putback (character);
	else if (token.symbol != Integer)
		stream.putback (character);
	else if (stream && std::isalnum (character))
	{
		do token.string.push_back (character); while (std::isalnum (stream.peek ()) && stream.get (character));
		token.symbol = Identifier;
	}
	else if (token.string.back () == 'b')
		stream.putback (character), token.symbol = BinInteger, token.string.pop_back ();
	else if (token.string.back () == 'd')
		stream.putback (character), token.symbol = DecInteger, token.string.pop_back ();
	else if (token.string[0] == '0' && token.string.size () > 1)
		stream.putback (character), token.symbol = OctInteger, token.string.erase (0, 1);
	else if (stream && character == '.')
	{
		do token.string.push_back (character); while (std::isdigit (stream.peek ()) && stream.get (character));
		if (stream.peek () == 'e' && stream.get (character))
		{
			token.string.push_back (character);
			if ((stream.peek () == '+' || stream.peek () == '-') && stream.get (character)) token.string.push_back (character);
			while (std::isdigit (stream.peek ()) && stream.get (character)) token.string.push_back (character);
		}
		token.symbol = Real;
	}
	else stream.putback (character);
}

Lexer::Token::Token (const Symbol s, const Location& l) :
	symbol {s}, location {l}
{
}

Object::Patch::Mode Assembly::GetMode (const Lexer::Symbol symbol)
{
	const auto mode = std::find (std::begin (modes) + 1, std::end (modes), symbol);
	return mode != std::end (modes) ? Object::Patch::Mode (mode - std::begin (modes)) : Object::Patch::Absolute;
}

const char* Assembly::GetFunction (const Object::Patch::Mode mode)
{
	return mode != Object::Patch::Absolute ? symbols[modes[mode]] : nullptr;
}

std::ostream& Assembly::operator << (std::ostream& stream, const Lexer::Symbol symbol)
{
	return WriteEnum (stream, symbol, symbols);
}

std::ostream& Assembly::operator << (std::ostream& stream, const Lexer::Token& token)
{
	switch (token.symbol)
	{
	case Lexer::String: case Lexer::Address: case Lexer::Character: case Lexer::Identifier:
		return WriteString (stream << token.symbol << ' ', token.string, '\'');
	case Lexer::Integer: case Lexer::BinInteger: case Lexer::OctInteger: case Lexer::DecInteger: case Lexer::HexInteger: case Lexer::Real:
		return stream << token.symbol << ' ' << token.string;
	default:
		if (token.symbol >= Lexer::FirstDirective && token.symbol <= Lexer::LastDirective) return stream << token.symbol << " directive";
		if (token.symbol >= Lexer::FirstOperator && token.symbol <= Lexer::LastOperator) return stream << token.symbol << " operator";
		return stream << token.symbol;
	}
}

std::ostream& Assembly::WriteDefinition (std::ostream& stream)
{
	return stream << ":\t" << Lexer::Equals << '\t';
}

std::ostream& Assembly::WriteLine (std::ostream& stream, const Line line)
{
	return stream << Lexer::Line << ' ' << line;
}

std::ostream& Assembly::WriteLine (std::ostream& stream, const Line line, const Source& source)
{
	return WriteString (WriteLine (stream, line) << ' ', source, '"');
}

std::ostream& Assembly::WriteIdentifier (std::ostream& stream, const Identifier& identifier)
{
	return !identifier.empty () && !std::isdigit (identifier.front ()) && std::all_of (identifier.begin (), identifier.end (), IsIdentifier) && Lexer::Convert (identifier, Lexer::FirstDirective, Lexer::LastDirective, Lexer::Identifier) == Lexer::Identifier ? stream << identifier : WriteString (stream, identifier, '"');
}

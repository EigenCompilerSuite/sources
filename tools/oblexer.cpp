// Oberon lexer
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

#include "oblexer.hpp"
#include "utilities.hpp"

#include <algorithm>
#include <cassert>
#include <cctype>
#include <cerrno>
#include <cstdlib>
#include <iomanip>

using namespace ECS;
using namespace Oberon;

static const char*const symbols[] {"invalid token", "end of file",
	#define SYMBOL(symbol, name) name,
	#include "oberon.def"
};

Lexer::Lexer (const Annotations a) :
	annotations {a}
{
}

void Lexer::Scan (std::istream& stream, Position& position, Token& token) const
{
	char character; bool annotation = false, annotating = false, skip = false; token.position = position; token.annotation.clear ();

	for (std::streamoff level = 0; Advance (stream, position, character); token.annotation.push_back (character))
		if (character == '(' && stream.peek () == '*' && Advance (stream, position, character)) token.annotation.push_back (character = ' '), annotating = !level++ && annotations && stream.peek () == '*', skip = annotating;
		else if (character == '*' && level && stream.peek () == ')' && Advance (stream, position, character)) token.annotation.push_back (character = ' '), annotating &= --level;
		else if (character == '\n') token.position = position; else if (std::isspace (character)) character = ' ', token.position = position;
		else if (!level) break; else if (!annotating) character = ' '; else if (skip) character = ' ', annotation = true, skip = false;

	if (!annotation) token.annotation.clear ();
	if (!stream) return void (token.symbol = Eof);

	switch (character)
	{
	case '+': token.symbol = Plus; break;
	case '-': token.symbol = Minus; break;
	case '*': token.symbol = Asterisk; break;
	case '/': token.symbol = Slash; break;
	case '~': token.symbol = Not; break;
	case '&': token.symbol = And; break;
	case '.': token.symbol = stream.peek () == '.' && Advance (stream, position, character) ? Range : Dot; break;
	case ',': token.symbol = Comma; break;
	case ';': token.symbol = Semicolon; break;
	case '(': token.symbol = LeftParen; break;
	case ')': token.symbol = RightParen; break;
	case '[': token.symbol = LeftBracket; break;
	case ']': token.symbol = RightBracket; break;
	case '{': token.symbol = LeftBrace; break;
	case '}': token.symbol = RightBrace; break;
	case ':': token.symbol = stream.peek () == '=' && Advance (stream, position, character) ? Assign : Colon; break;
	case '|': token.symbol = Bar; break;
	case '^': token.symbol = Arrow; break;
	case '=': token.symbol = Equal; break;
	case '#': token.symbol = Unequal; break;
	case '<': token.symbol = stream.peek () == '=' && Advance (stream, position, character) ? LessEqual : Less; break;
	case '>': token.symbol = stream.peek () == '=' && Advance (stream, position, character) ? GreaterEqual : Greater; break;
	case '"': case '\'': ReadString (stream, position, character, token); break;
	default:
		if (std::isalpha (character)) ReadIdentifier (stream, position, character, token);
		else if (std::isdigit (character)) ReadNumber (stream, position, character, token);
		else token.symbol = Invalid;
	}
}

void Lexer::ReadString (std::istream& stream, Position& position, const char delimiter, Token& token)
{
	char character; token.string.clear ();
	while (Advance (stream, position, character) && character != delimiter) token.string.push_back (character);
	if (character == delimiter) token.symbol = delimiter == '"' ? DoubleQuotedString : SingleQuotedString;
	else token.symbol = stream ? Invalid : Eof;
}

void Lexer::ReadIdentifier (std::istream& stream, Position& position, char character, Token& token)
{
	token.string.clear ();
	do token.string.push_back (character);
	while ((std::isalnum (stream.peek ()) || stream.peek () == '_') && Advance (stream, position, character));

	const auto index = std::lower_bound (symbols + FirstKeyword, symbols + LastKeyword + 1, token.string);
	if (index <= symbols + LastKeyword && *index == token.string) token.symbol = Lexer::Symbol (index - symbols);
	else token.symbol = Identifier;
}

void Lexer::ReadNumber (std::istream& stream, Position& position, char character, Token& token)
{
	token.string.clear ();
	do token.string.push_back (character), character = stream.peek ();
	while ((std::isxdigit (character) && std::toupper (character) == character || character == '\'' && token.string.back () != '\'') && Advance (stream, position, character));
	if (token.string.back () == '\'') Regress (stream, position, token.string.back ()), token.string.pop_back ();

	if (stream.peek () == 'X' && Advance (stream, position, character))
		token.symbol = Character;
	else if (stream.peek () == 'H' && Advance (stream, position, character))
		token.symbol = HexadecimalInteger;
	else if (stream.peek () == 'O' && Advance (stream, position, character))
		token.symbol = token.string.find_first_not_of ("01234567'") == token.string.npos ? OctalInteger : Invalid;
	else if (token.string.back () == 'B')
		if (token.string.pop_back (), token.string.back () == '\'') Regress (stream, position, token.string.back ()), token.string.pop_back (), token.symbol = Integer;
		else token.symbol = token.string.find_first_not_of ("01'") == token.string.npos ? BinaryInteger : Invalid;
	else if (token.string.find_first_not_of ("0123456789'") != token.string.npos)
		token.symbol = Invalid;
	else if (stream.peek () == '.' && Advance (stream, position, character))
		if (stream.peek () == '.')
		{
			Regress (stream, position, character);
			token.symbol = Integer;
		}
		else
		{
			token.symbol = Real;
			token.string.push_back (character);
			while (std::isdigit (stream.peek ()) && Advance (stream, position, character)) token.string.push_back (character);
			if ((stream.peek () == 'E' || stream.peek () == 'D') && Advance (stream, position, character))
			{
				token.string.push_back (character);
				if ((stream.peek () == '+' || stream.peek () == '-') && Advance (stream, position, character)) token.string.push_back (character);
				if (std::isdigit (stream.peek ()))
					while (std::isdigit (stream.peek ()) && Advance (stream, position, character)) token.string.push_back (character);
				else
					token.symbol = Invalid;
			}
		}
	else
		token.symbol = Integer;
}

bool Lexer::Evaluate (const Literal& literal, Oberon::Real& value)
{
	assert (IsReal (literal.symbol)); auto number = literal.string;
	number.erase (std::remove (number.begin (), number.end (), '\''), number.end ());
	const auto scale = number.find ('D'); if (scale != number.npos) number[scale] = 'E';
	errno = 0; value = std::strtod (number.c_str (), nullptr); return errno != ERANGE;
}

bool Lexer::Evaluate (const Literal& literal, Oberon::Unsigned& value)
{
	assert (IsInteger (literal.symbol)); auto number = literal.string;
	number.erase (std::remove (number.begin (), number.end (), '\''), number.end ());
	const auto base = literal.symbol == BinaryInteger ? 2 : literal.symbol == OctalInteger ? 8 : literal.symbol == HexadecimalInteger || literal.symbol == Character ? 16 : 10;
	errno = 0; value = std::strtoull (number.c_str (), nullptr, base); return errno != ERANGE;
}

Lexer::Token::Token (const Position& p) :
	position {p}
{
}

bool Oberon::IsInteger (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Integer || symbol == Lexer::OctalInteger || symbol == Lexer::BinaryInteger || symbol == Lexer::HexadecimalInteger || symbol == Lexer::Character;
}

bool Oberon::IsReal (const Lexer::Symbol symbol)
{
	return symbol == Lexer::Real;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Lexer::Symbol symbol)
{
	return WriteEnum (stream, symbol, symbols);
}

std::ostream& Oberon::operator << (std::ostream& stream, const Lexer::Literal& literal)
{
	switch (literal.symbol)
	{
	case Lexer::Nil: return stream << literal.symbol;
	case Lexer::Integer: case Lexer::Real: return stream << literal.string;
	case Lexer::BinaryInteger: return stream << literal.string << 'B';
	case Lexer::OctalInteger: return stream << literal.string << 'O';
	case Lexer::HexadecimalInteger: return stream << literal.string << 'H';
	case Lexer::Character: return stream << literal.string << 'X';
	case Lexer::SingleQuotedString: return stream << '\'' << literal.string << '\'';
	case Lexer::DoubleQuotedString: return stream << '"' << literal.string << '"';
	default: assert (Lexer::UnreachableLiteral);
	}
}

std::ostream& Oberon::operator << (std::ostream& stream, const Lexer::Token& token)
{
	switch (token.symbol)
	{
	case Lexer::Div: case Lexer::In: case Lexer::Is: case Lexer::Or: case Lexer::Mod:
	case Lexer::Plus: case Lexer::Minus: case Lexer::Asterisk: case Lexer::Slash:
	case Lexer::Not: case Lexer::And: case Lexer::Assign: case Lexer::Arrow:
	case Lexer::Equal: case Lexer::Unequal: case Lexer::Less: case Lexer::Greater:
	case Lexer::LessEqual: case Lexer::GreaterEqual: case Lexer::Range:
		return stream << "operator " << token.symbol;
	case Lexer::Identifier: case Lexer::SingleQuotedString:
		return WriteString (stream << token.symbol << ' ', token.string, '\'');
	case Lexer::DoubleQuotedString:
		return WriteString (stream << token.symbol << ' ', token.string, '\"');
	default:
		return stream << token.symbol;
	}
}

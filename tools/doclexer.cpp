// Generic documentation lexer
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

#include "doclexer.hpp"
#include "utilities.hpp"

#include <algorithm>
#include <cctype>
#include <istream>
#include <ostream>

using namespace ECS;
using namespace Documentation;

static const char*const symbols[] {"invalid token", "end of file",
	#define SYMBOL(symbol, name) name,
	#include "documentation.def"
};

void Lexer::Scan (std::istream& stream, Position& position, Token& token) const
{
	char character; token.position = position; token.literal.clear ();
	if (!Advance (stream, position, character)) {token.symbol = Eof; return;}

	if (token.symbol == CodeBegin)
	{
		Literal::size_type tail = 0;
		do
		{
			token.literal.push_back (character);
			if (token.literal.size () >= 3) if (std::equal (token.literal.begin () + tail, token.literal.end (), symbols[CodeEnd])) break; else ++tail;
		}
		while (Advance (stream, position, character));
		token.symbol = stream ? CodeEnd : Invalid;
		while (tail && std::isspace (token.literal[tail - 1])) --tail;
		token.literal.erase (tail);
		return;
	}

	switch (character)
	{
	case '\t': token.symbol = Tab; break;
	case '\n': token.symbol = Newline; break;
	case '\r': token.symbol = !stream.good () || stream.peek () != '\n' || Advance (stream, position, character) ? Newline : Eof; break;
	case ' ': token.symbol = Space; break;
	case '|': token.symbol = stream.good () && stream.peek () == '=' && Advance (stream, position, character) ? Header : Pipe; break;
	case '/': ReadCharacter (stream, position, character, 2, 2, token, Italic); break;
	case '[': ReadCharacter (stream, position, character, 2, 2, token, LinkBegin); break;
	case ']': ReadCharacter (stream, position, character, 2, 2, token, LinkEnd); break;
	case '=': ReadCharacter (stream, position, character, 1, 3, token, Heading); break;
	case '#': ReadCharacter (stream, position, character, 1, 3, token, Number); break;
	case '*': ReadCharacter (stream, position, character, 1, 3, token, Bullet); if (token.count == 2) token.symbol = Bold; break;
	case '-': ReadCharacter (stream, position, character, 4, 4, token, Line); break;
	case '{': ReadCharacter (stream, position, character, 3, 3, token, CodeBegin); break;
	case '}': ReadCharacter (stream, position, character, 3, 3, token, CodeEnd); break;
	case '<': ReadCharacter (stream, position, character, 2, 2, token, LabelBegin); break;
	case '>': ReadCharacter (stream, position, character, 2, 2, token, LabelEnd); break;
	case '\\': ReadCharacter (stream, position, character, 2, 2, token, LineBreak); break;
	case '@': ReadCharacter (stream, position, character, 1, 10, token, Article); break;
	default: if (std::isgraph (character)) ReadLiteral (Regress (stream, position, character), position, token, String); else token.symbol = Invalid;
	}
}

void Lexer::ReadCharacter (std::istream& stream, Position& position, const char character, const Count min, const Count max, Token& token, const Symbol result) const
{
	token.count = 1; for (char ignore; stream && stream.peek () == character; ++token.count) Advance (stream, position, ignore);
	if (token.count >= min && token.count <= max) token.symbol = result;
	else token.literal.assign (token.count, character), ReadLiteral (stream, position, token, String);
}

void Lexer::ReadLiteral (std::istream& stream, Position& position, Token& token, Symbol result) const
{
	token.symbol = result;
	for (char character = stream.peek (), ignore; stream.good () && std::isgraph (character) && character != '/' && character != '*' && character != '<' && character != '>' && character != '[' && character != ']' && character != '{' && character != '}' && character != '|' && character != '\\'; character = char (Advance (stream, position, ignore).peek ()))
		if (token.literal.push_back (character), token.literal.find ("http:") == 0 || token.literal.find ("https:") == 0) return ReadURL (Advance (stream, position, ignore), position, token);
}

void Lexer::ReadURL (std::istream& stream, Position& position, Token& token) const
{
	token.symbol = URL; for (char character = stream.peek (), ignore; stream.good () && !std::isspace (character) && character != ']' && character != '|'; character = char (Advance (stream, position, ignore).peek ())) token.literal.push_back (character);
}

Lexer::Token::Token (const Position& p) :
	symbol {Eof}, position {p}
{
}

std::ostream& Documentation::operator << (std::ostream& stream, const Lexer::Symbol symbol)
{
	return WriteEnum (stream, symbol, symbols);
}

std::ostream& Documentation::operator << (std::ostream& stream, const Lexer::Token& token)
{
	switch (token.symbol)
	{
	case Lexer::Article: case Lexer::Heading: case Lexer::Number: case Lexer::Bullet:
		for (auto count = token.count; count; --count) stream << token.symbol; return stream;
	case Lexer::String:
		return stream << token.symbol << " '" << token.literal << '\'';
	default:
		return stream << token.symbol;
	}
}

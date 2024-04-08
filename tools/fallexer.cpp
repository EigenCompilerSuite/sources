// FALSE lexer
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

#include "fallexer.hpp"
#include "utilities.hpp"

#include <algorithm>
#include <cctype>

using namespace ECS;
using namespace FALSE;

const char symbols[] {'\0',
	#define SYMBOL(symbol, character) character,
	#include "false.def"
};

void Lexer::Scan (std::istream& stream, Position& position, Token& token) const
{
	token.position = position; token.string.clear ();

	char character; auto comment = false;
	while (Advance (stream, position, character))
		if (std::isspace (character)) token.position = position;
		else if (character == '{' && !comment) comment = true;
		else if (character == '}' && comment) comment = false, token.position = position;
		else if (!comment) break;

	if (!stream) token.symbol = comment ? Invalid : Eof;
	else if (std::isdigit (character))
	{
		token.integer = character - '0';
		while (stream && std::isdigit (stream.peek ()) && Advance (stream, position, character)) token.integer = token.integer * 10 + character - '0';
		token.symbol = token.integer <= 320000 ? Integer : Invalid;
	}
	else if (character == symbols[Character] && Advance (stream, position, character) && std::isprint (character)) token.symbol = Character, token.character = character;
	else if (character >= 'a' && character <= 'z') token.symbol = Variable, token.character = character;
	else if (character == symbols[String])
	{
		while (Advance (stream, position, character) && character != symbols[String]) token.string.push_back (character);
		if (!stream) token.symbol = Invalid;
		else if (Advance (stream, position, character) && character == symbols[ExternalVariable]) token.symbol = token.string.empty () ? Invalid : ExternalVariable;
		else if (stream && character == symbols[ExternalFunction]) token.symbol = token.string.empty () ? Invalid : ExternalFunction;
		else if (stream && character == symbols[Assembly]) token.symbol = Assembly;
		else Regress (stream, position, character), token.symbol = String;
	}
	else token.symbol = Symbol (std::find (symbols, symbols + Invalid, character) - symbols);
}

Lexer::Token::Token (const Position& p) :
	symbol {Invalid}, position {p}
{
}

std::ostream& FALSE::operator << (std::ostream& stream, const Lexer::Symbol symbol)
{
	return WriteEnum (stream, symbol, symbols);
}

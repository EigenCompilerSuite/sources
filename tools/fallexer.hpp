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

#ifndef ECS_FALSE_LEXER_HEADER_INCLUDED
#define ECS_FALSE_LEXER_HEADER_INCLUDED

#include "position.hpp"

#include <vector>

namespace ECS::FALSE
{
	class Lexer;

	using Character = char;
	using Integer = int;
}

class ECS::FALSE::Lexer
{
public:
	enum Symbol {Eof,
		#define SYMBOL(symbol, name) symbol,
		#include "false.def"
		Unreachable = 0
	};

	struct Token;

	void Scan (std::istream&, Position&, Token&) const;
};

struct ECS::FALSE::Lexer::Token
{
	Symbol symbol;
	Position position;
	std::string string;

	union
	{
		FALSE::Integer integer;
		FALSE::Character character;
		std::vector<Token>* function;
	};

	explicit Token (const Position&);
};

namespace ECS::FALSE
{
	std::ostream& operator << (std::ostream&, Lexer::Symbol);
}

#endif // ECS_FALSE_LEXER_HEADER_INCLUDED

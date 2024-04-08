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

#ifndef ECS_DOCUMENTATION_LEXER_HEADER_INCLUDED
#define ECS_DOCUMENTATION_LEXER_HEADER_INCLUDED

#include "position.hpp"

namespace ECS::Documentation
{
	class Lexer;
}

class ECS::Documentation::Lexer
{
public:
	enum Symbol {Invalid, Eof,
		#define SYMBOL(symbol, name) symbol,
		#include "documentation.def"
	};

	struct Token;

	using Count = std::size_t;
	using Literal = std::string;

	void Scan (std::istream&, Position&, Token&) const;

private:
	void ReadURL (std::istream&, Position&, Token&) const;
	void ReadLiteral (std::istream&, Position&, Token&, Symbol) const;
	void ReadCharacter (std::istream&, Position&, char, Count, Count, Token&, Symbol) const;
};

struct ECS::Documentation::Lexer::Token
{
	Symbol symbol;
	Position position;
	Count count;
	Literal literal;

	explicit Token (const Position&);
};

namespace ECS::Documentation
{
	std::ostream& operator << (std::ostream&, const Lexer::Token&);
	std::ostream& operator << (std::ostream&, Lexer::Symbol);
}

#endif // ECS_DOCUMENTATION_LEXER_HEADER_INCLUDED

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

#ifndef ECS_OBERON_LEXER_HEADER_INCLUDED
#define ECS_OBERON_LEXER_HEADER_INCLUDED

#include "position.hpp"

#include <cstdint>

namespace ECS::Oberon
{
	class Lexer;

	using Any = void*;
	using Boolean = bool;
	using Byte = unsigned;
	using Character = unsigned char;
	using Real = double;
	using Signed = std::int64_t;
	using Size = std::size_t;
	using String = std::string;
	using Unsigned = std::uint64_t;
}

class ECS::Oberon::Lexer
{
public:
	enum Symbol {Invalid, Eof,
		#define SYMBOL(symbol, name) symbol,
		#include "oberon.def"
		FirstKeyword = Array, LastKeyword = With, UnreachableLiteral = 0, UnreachableOperator = 0,
	};

	struct Literal;
	struct Token;

	using Annotations = bool;

	explicit Lexer (Annotations);

	void Scan (std::istream&, Position&, Token&) const;

	static bool Evaluate (const Literal&, Oberon::Real&);
	static bool Evaluate (const Literal&, Oberon::Unsigned&);

private:
	const Annotations annotations;

	static void ReadIdentifier (std::istream&, Position&, char, Token&);
	static void ReadNumber (std::istream&, Position&, char, Token&);
	static void ReadString (std::istream&, Position&, char, Token&);
};

struct ECS::Oberon::Lexer::Literal
{
	Symbol symbol;
	String string;
};

struct ECS::Oberon::Lexer::Token : Literal
{
	Position position;
	String annotation;

	explicit Token (const Position&);
};

namespace ECS::Oberon
{
	std::ostream& operator << (std::ostream&, Lexer::Symbol);
	std::ostream& operator << (std::ostream&, const Lexer::Literal&);
	std::ostream& operator << (std::ostream&, const Lexer::Token&);

	bool IsInteger (Lexer::Symbol);
	bool IsReal (Lexer::Symbol);
}

#endif // ECS_OBERON_LEXER_HEADER_INCLUDED

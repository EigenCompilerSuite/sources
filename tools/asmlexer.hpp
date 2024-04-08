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

#ifndef ECS_ASSEMBLY_LEXER_HEADER_INCLUDED
#define ECS_ASSEMBLY_LEXER_HEADER_INCLUDED

#include "diagnostics.hpp"
#include "object.hpp"

#include <iosfwd>

namespace ECS
{
	using Line = std::streamoff;
}

namespace ECS::Assembly
{
	class Lexer;

	struct Location;

	using Identifier = std::string;
	using String = std::string;

	std::ostream& WriteDefinition (std::ostream&);
	std::ostream& WriteIdentifier (std::ostream&, const Identifier&);
	std::ostream& WriteLine (std::ostream&, Line);
	std::ostream& WriteLine (std::ostream&, Line, const Source&);
}

struct ECS::Assembly::Location
{
	const Source* source;
	Line line;

	Location (const Source&, Line);

	void Emit (Diagnostics::Type, Diagnostics&, const Message&) const;
};

class ECS::Assembly::Lexer
{
public:
	enum Symbol {Invalid, Eof,
		#define SYMBOL(symbol, name) symbol,
		#include "assembly.def"
		FirstDirective = Define, LastDirective = Type,
		FirstFunction = Count, LastFunction = Size,
		FirstOperator = Plus, LastOperator = LogicalAnd,
	};

	struct Token;

	void Scan (std::istream&, Token&) const;

	static Symbol Convert (const Assembly::Identifier&, Symbol, Symbol, Symbol);

private:
	static void ReadNumber (std::istream&, char, Token&);
	static void ReadIdentifier (std::istream&, Token&, Symbol);
};

struct ECS::Assembly::Lexer::Token
{
	Symbol symbol;
	Location location;
	Assembly::String string;

	Token (Symbol, const Location&);
};

namespace ECS::Assembly
{
	auto GetMode (Lexer::Symbol) -> Object::Patch::Mode;
	auto GetFunction (Object::Patch::Mode) -> const char*;

	std::ostream& operator << (std::ostream&, const Lexer::Token&);
	std::ostream& operator << (std::ostream&, Lexer::Symbol);
}

#endif // ECS_ASSEMBLY_LEXER_HEADER_INCLUDED

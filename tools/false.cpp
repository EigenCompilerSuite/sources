// FALSE representation
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

#include "false.hpp"

#include <ostream>

using namespace ECS;
using namespace FALSE;

Program::Program (const Source& s) :
	source {s}
{
}

std::ostream& FALSE::operator << (std::ostream& stream, const Element& element)
{
	switch (element.symbol)
	{
	case Lexer::Integer: return stream << element.integer;
	case Lexer::Character: return stream << Lexer::Character << element.character;
	case Lexer::Variable: return stream << element.character;
	case Lexer::String: return stream << Lexer::String << element.string << Lexer::String;
	case Lexer::ExternalVariable: case Lexer::ExternalFunction: case Lexer::Assembly: return stream << Lexer::String << element.string << Lexer::String << element.symbol;
	default: return stream << element.symbol;
	}
}

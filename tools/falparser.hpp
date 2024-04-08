// FALSE parser
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

#ifndef ECS_FALSE_PARSER_HEADER_INCLUDED
#define ECS_FALSE_PARSER_HEADER_INCLUDED

#include <iosfwd>

namespace ECS
{
	class Diagnostics;
	class Position;
}

namespace ECS::FALSE
{
	class Parser;

	struct Program;
}

class ECS::FALSE::Parser
{
public:
	explicit Parser (Diagnostics&);

	void Parse (std::istream&, const Position&, Program&) const;

private:
	Diagnostics& diagnostics;

	void EmitError [[noreturn]] (const Program&, const Position&, const char*) const;
};

#endif // ECS_FALSE_PARSER_HEADER_INCLUDED

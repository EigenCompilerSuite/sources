// Generic assembly language parser
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

#ifndef ECS_ASSEMBLY_PARSER_HEADER_INCLUDED
#define ECS_ASSEMBLY_PARSER_HEADER_INCLUDED

#include <iosfwd>
#include <string>
#include <vector>

namespace ECS
{
	class Diagnostics;
	class StringPool;

	using Line = std::streamoff;
	using Source = std::string;
}

namespace ECS::Assembly
{
	class Parser;

	struct Instruction;
	struct Program;

	using Instructions = std::vector<Instruction>;
}

class ECS::Assembly::Parser
{
public:
	using SpecialSections = bool;

	Parser (Diagnostics&, StringPool&, SpecialSections);

	void Parse (std::istream&, Line, Program&) const;
	void Parse (std::istream&, const Source&, Line, Instructions&) const;

private:
	class Context;

	Diagnostics& diagnostics;
	StringPool& stringPool;
	const SpecialSections specialSections;
};

#endif // ECS_ASSEMBLY_PARSER_HEADER_INCLUDED

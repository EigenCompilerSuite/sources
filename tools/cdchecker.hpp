// Intermediate code semantic checker
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

#ifndef ECS_CODE_CHECKER_HEADER_INCLUDED
#define ECS_CODE_CHECKER_HEADER_INCLUDED

#include "asmchecker.hpp"

#include <list>
#include <vector>

namespace ECS::Code
{
	class Checker;
	class Platform;

	struct Section;
	struct Type;

	using Sections = std::list<Section>;
}

namespace ECS::Assembly
{
	struct Instruction;
	struct Program;
	struct Section;

	using Instructions = std::vector<Instruction>;
}

class ECS::Code::Checker : Assembly::Checker
{
public:
	Checker (Diagnostics&, Charset&, Platform&);

	void Check (const Assembly::Program&, Sections&) const;
	void Check (const Assembly::Instructions&, Section&) const;

private:
	class Context;

	Platform& platform;

	void Check (const Assembly::Section&, Sections&) const;
};

#endif // ECS_CODE_CHECKER_HEADER_INCLUDED

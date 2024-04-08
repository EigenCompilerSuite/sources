// FALSE interpreter
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

#ifndef ECS_FALSE_INTERPRETER_HEADER_INCLUDED
#define ECS_FALSE_INTERPRETER_HEADER_INCLUDED

#include <list>

namespace ECS
{
	class Diagnostics;
	class Environment;
}

namespace ECS::FALSE
{
	class Interpreter;

	struct Program;

	using Integer = int;
	using Programs = std::list<Program>;
}

class ECS::FALSE::Interpreter
{
public:
	explicit Interpreter (Diagnostics&);

	Integer Execute (const Program&, Environment&) const;
	Integer Execute (const Programs&, Environment&) const;

private:
	class Context;

	struct Value;

	Diagnostics& diagnostics;
};

#endif // ECS_FALSE_INTERPRETER_HEADER_INCLUDED

// Intermediate code interpreter
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

#ifndef ECS_CODE_INTERPRETER_HEADER_INCLUDED
#define ECS_CODE_INTERPRETER_HEADER_INCLUDED

#include "asmparser.hpp"
#include "cdchecker.hpp"
#include "code.hpp"

namespace ECS
{
	class Environment;
}

namespace ECS::Code
{
	class Interpreter;
}

class ECS::Code::Interpreter
{
public:
	Interpreter (Diagnostics&, StringPool&, Charset&, Platform&);

	Signed::Value Execute (const Sections&, Environment&) const;

private:
	class Context;
	class Segment;
	class Thread;

	struct ProgramCounter;
	struct Reference;
	struct Value;

	Diagnostics& diagnostics;
	Platform& platform;
	Assembly::Parser parser;
	Checker checker;
};

#endif // ECS_CODE_INTERPRETER_HEADER_INCLUDED

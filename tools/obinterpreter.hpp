// Oberon interpreter
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

#ifndef ECS_OBERON_INTERPRETER_HEADER_INCLUDED
#define ECS_OBERON_INTERPRETER_HEADER_INCLUDED

#include <cstdint>
#include <list>

namespace ECS
{
	class Charset;
	class Diagnostics;
	class Environment;
}

namespace ECS::Oberon
{
	class Interpreter;
	class Platform;

	struct Module;

	using Modules = std::list<Module>;
	using Signed = std::int64_t;
}

class ECS::Oberon::Interpreter
{
public:
	Interpreter (Diagnostics&, Charset&, Platform&);

	Signed Execute (const Modules&, Environment&) const;

protected:
	class Evaluator;

	Diagnostics& diagnostics;
	Charset& charset;
	Platform& platform;

private:
	class Context;
};

#endif // ECS_OBERON_INTERPRETER_HEADER_INCLUDED

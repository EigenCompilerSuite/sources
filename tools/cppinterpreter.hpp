// C++ interpreter
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

#ifndef ECS_CPP_INTERPRETER_HEADER_INCLUDED
#define ECS_CPP_INTERPRETER_HEADER_INCLUDED

#include <cstdint>
#include <list>
#include <string>

namespace ECS
{
	class Diagnostics;
	class Environment;
	class StringPool;

	using Source = std::string;
}

namespace ECS::CPP
{
	class Interpreter;
	class Platform;

	struct Array;
	struct TranslationUnit;

	using Signed = std::int64_t;
	using TranslationUnits = std::list<TranslationUnit>;
}

class ECS::CPP::Interpreter
{
public:
	Interpreter (Diagnostics&, StringPool&, Platform&);

	Signed Execute (const TranslationUnits&, const Source&, Environment&, Array&) const;

protected:
	class Evaluator;
	class Executor;

	Diagnostics& diagnostics;
	StringPool& stringPool;
	Platform& platform;

private:
	class Context;
	class MainThread;
	class Thread;
};

#endif // ECS_CPP_INTERPRETER_HEADER_INCLUDED

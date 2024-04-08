// C++ semantic checker
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

#ifndef ECS_CPP_CHECKER_HEADER_INCLUDED
#define ECS_CPP_CHECKER_HEADER_INCLUDED

#include "cpp.hpp"
#include "cppinterpreter.hpp"

namespace ECS::CPP
{
	class Checker;
}

class ECS::CPP::Checker : Interpreter
{
protected:
	class Context;

	Checker (Diagnostics&, StringPool&, Charset&, Platform&);

	const Type size, difference;
	const Unsigned defaultNewAlignment;

private:
	Charset& charset;

	const String *const main, *const func, *const final, *const override, *const std;
};

#endif // ECS_CPP_CHECKER_HEADER_INCLUDED

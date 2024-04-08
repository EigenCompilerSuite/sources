// Generic intermediate code emitter
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

#ifndef ECS_CODE_EMITTER_HEADER_INCLUDED
#define ECS_CODE_EMITTER_HEADER_INCLUDED

#include "asmparser.hpp"
#include "cdchecker.hpp"
#include "code.hpp"

namespace ECS
{
	class Position;
}

namespace ECS::Code
{
	class Emitter;

	template <typename String> Section::Name GetName (const String&);
}

class ECS::Code::Emitter
{
public:
	Emitter (Diagnostics&, StringPool&, Charset&, Platform&);

protected:
	class Context;

	Diagnostics& diagnostics;
	Charset& charset;
	Platform& platform;
	const Reg stackPointer, framePointer, linkRegister;

private:
	Assembly::Parser parser;
	Checker checker;
};

#endif // ECS_CODE_EMITTER_HEADER_INCLUDED

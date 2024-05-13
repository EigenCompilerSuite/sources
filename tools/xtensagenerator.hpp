// Xtensa machine code generator
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

#ifndef ECS_XTENSA_GENERATOR_HEADER_INCLUDED
#define ECS_XTENSA_GENERATOR_HEADER_INCLUDED

#include "asmgenerator.hpp"
#include "xtensaassembler.hpp"

namespace ECS::Xtensa
{
	enum Options {
		Const16 = 0x1, CodeDensity = 0x2, Loop = 0x4, Multiply16 = 0x8, Multiply32 = 0x10, Multiply64 = 0x20, Divide32 = 0x40, SinglePrecision = 0x80, DoublePrecision = 0x100,
		ESP32 = CodeDensity | Loop | Multiply16 | Multiply32 | Divide32 | SinglePrecision,
	};

	class Generator;
}

class ECS::Xtensa::Generator : public Assembly::Generator
{
public:
	Generator (Diagnostics&, StringPool&, Charset&, Options);

private:
	class Context;

	Assembler assembler;
	const Options options;

	void Process (const Code::Sections&, Object::Binaries&, Debugging::Information&, std::ostream&) const override;
};

#endif // ECS_XTENSA_GENERATOR_HEADER_INCLUDED

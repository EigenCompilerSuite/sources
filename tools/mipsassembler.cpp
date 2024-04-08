// MIPS assembler
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

#include "mips.hpp"
#include "mipsassembler.hpp"
#include "utilities.hpp"

using namespace ECS;
using namespace MIPS;

Assembler::Assembler (Diagnostics& d, Charset& c, const Architecture architecture, const Endianness endianness) :
	Assembly::Assembler {d, c, 4, 1, endianness, architecture}
{
}

bool Assembler::Validate (const BitMode bitmode) const
{
	return bitmode == MIPS32 || bitmode == MIPS64;
}

Assembler::Size Assembler::GetDisplacement (const Size size, const BitMode) const
{
	return size;
}

Assembler::Size Assembler::ParseInstruction (std::istream& stream, const BitMode bitmode, State&) const
{
	Instruction instruction;
	return stream >> instruction && IsValid (instruction, Architecture (bitmode)) ? 4 : 0;
}

Assembler::Size Assembler::EmitInstruction (std::istream& stream, const BitMode bitmode, const Endianness endianness, const Span<Byte> bytes, Object::Patch& patch, State&) const
{
	Instruction instruction;
	const Size size = stream >> instruction && IsValid (instruction, Architecture (bitmode)) ? 4 : 0;
	if (size && size <= bytes.size ()) instruction.Emit (bytes, endianness), instruction.Adjust (patch, endianness);
	return size;
}

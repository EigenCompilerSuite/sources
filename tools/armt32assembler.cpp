// ARM T32 assembler
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

#include "armt32.hpp"
#include "armt32assembler.hpp"
#include "utilities.hpp"

using namespace ECS;
using namespace ARM;
using namespace T32;

Assembler::Assembler (Diagnostics& d, Charset& c) :
	A32::Assembler {d, c, 2, 2, 1, Endianness::Little, 16}
{
}

bool Assembler::Validate (const BitMode bitmode) const
{
	return bitmode == 16 || bitmode == 32;
}

Assembler::Size Assembler::GetDisplacement (const Size size, const BitMode bitmode) const
{
	if (bitmode == 32) return A32::Assembler::GetDisplacement (size, bitmode);
	return 4;
}

Assembler::Size Assembler::ParseInstruction (std::istream& stream, const BitMode bitmode, State& state) const
{
	if (bitmode == 32) return A32::Assembler::ParseInstruction (stream, bitmode, state);
	Instruction instruction {ConditionCode (state)};
	return stream >> instruction && IsValid (instruction) ? state = GetConditionCode (instruction), GetSize (instruction) : 0;
}

Assembler::Size Assembler::EmitInstruction (std::istream& stream, const BitMode bitmode, const Endianness endianness, const Span<Byte> bytes, Object::Patch& patch, State& state) const
{
	if (bitmode == 32) return A32::Assembler::EmitInstruction (stream, bitmode, endianness, bytes, patch, state);
	Instruction instruction {ConditionCode (state)};
	const Size size = stream >> instruction && IsValid (instruction) ? state = GetConditionCode (instruction), GetSize (instruction) : 0;
	if (size && size <= bytes.size ()) instruction.Emit (bytes), instruction.Adjust (patch);
	return size;
}

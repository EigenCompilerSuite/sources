// AVR assembler
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

#include "assembly.hpp"
#include "avr.hpp"
#include "avrassembler.hpp"
#include "utilities.hpp"

using namespace ECS;
using namespace AVR;

Assembler::Assembler (Diagnostics& d, Charset& c) :
	Assembly::Assembler {d, c, 2, 1, Endianness::Big, 0}
{
}

Assembler::Size Assembler::GetDisplacement (const Size size, const BitMode) const
{
	return size;
}

bool Assembler::GetDefinition (const Assembly::Identifier& identifier, Assembly::Expression& value) const
{
	using Assembly::Expression;
	if (identifier == "RXL") return value = {Expression::Identifier, "r26"}, true;
	if (identifier == "RXH") return value = {Expression::Identifier, "r27"}, true;
	if (identifier == "RYL") return value = {Expression::Identifier, "r28"}, true;
	if (identifier == "RYH") return value = {Expression::Identifier, "r29"}, true;
	if (identifier == "RZL") return value = {Expression::Identifier, "r30"}, true;
	if (identifier == "RZH") return value = {Expression::Identifier, "r31"}, true;
	if (identifier == "SPL") return value = {Expression::Number, SPL}, true;
	if (identifier == "SPH") return value = {Expression::Number, SPH}, true;
	return false;
}

Assembler::Size Assembler::ParseInstruction (std::istream& stream, const BitMode, State&) const
{
	Instruction instruction;
	return stream >> instruction && IsValid (instruction) ? GetSize (instruction) : 0;
}

Assembler::Size Assembler::EmitInstruction (std::istream& stream, const BitMode, const Endianness, const Span<Byte> bytes, Object::Patch& patch, State&) const
{
	Instruction instruction;
	const Size size = stream >> instruction && IsValid (instruction) ? GetSize (instruction) : 0;
	if (size && size <= bytes.size ()) instruction.Emit (bytes), instruction.Adjust (patch);
	return size;
}

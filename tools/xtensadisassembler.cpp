// Xtensa disassembler
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

#include "utilities.hpp"
#include "xtensa.hpp"
#include "xtensadisassembler.hpp"

using namespace ECS;
using namespace Xtensa;

Disassembler::Disassembler (Charset& c) :
	Assembly::Disassembler {c, 1, 3}
{
}

Disassembler::Size Disassembler::ListInstruction (const Span<const Byte> bytes, std::ostream& stream, State&) const
{
	const Instruction instruction {bytes};
	const Size size = IsValid (instruction) ? GetSize (instruction) : 0;
	if (size) Write (stream, {bytes.begin (), size}) << instruction;
	return size;
}

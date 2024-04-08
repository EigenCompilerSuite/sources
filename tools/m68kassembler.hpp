// M68000 assembler
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

#ifndef ECS_M68K_ASSEMBLER_HEADER_INCLUDED
#define ECS_M68K_ASSEMBLER_HEADER_INCLUDED

#include "asmassembler.hpp"

namespace ECS::M68K
{
	class Assembler;
}

class ECS::M68K::Assembler : public Assembly::Assembler
{
public:
	Assembler (Diagnostics&, Charset&);

private:
	Size GetDisplacement (Size, BitMode) const override;
	Size ParseInstruction (std::istream&, BitMode, State&) const override;
	Size EmitInstruction (std::istream&, BitMode, Endianness, Span<Byte>, Object::Patch&, State&) const override;
};

#endif // ECS_M68K_ASSEMBLER_HEADER_INCLUDED

// Generic assembler
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

#ifndef ECS_ASSEMBLY_ASSEMBLER_HEADER_INCLUDED
#define ECS_ASSEMBLY_ASSEMBLER_HEADER_INCLUDED

#include "asmchecker.hpp"

#include <cstdint>
#include <iosfwd>
#include <list>
#include <string>
#include <vector>

namespace ECS
{
	enum class Endianness;

	template <typename> class Span;

	using Byte = std::uint8_t;
}

namespace ECS::Assembly
{
	class Assembler;

	struct Expression;
	struct Instruction;
	struct Program;
	struct Section;

	using Identifier = std::string;
	using Instructions = std::vector<Instruction>;
}

namespace ECS::Object
{
	struct Binary;
	struct Patch;

	using Binaries = std::list<Binary>;
}

class ECS::Assembly::Assembler : Checker
{
public:
	virtual ~Assembler () = default;

	void Assemble (const Program&, Object::Binaries&) const;
	void Assemble (const Instructions&, Object::Binary&) const;

protected:
	using BitMode = unsigned;
	using CodeAlignment = std::size_t;
	using DataAlignment = std::size_t;
	using Size = std::size_t;
	using State = unsigned;

	Assembler (Diagnostics&, Charset&, CodeAlignment, DataAlignment, Endianness, BitMode);

private:
	class Context;

	const CodeAlignment codeAlignment;
	const DataAlignment dataAlignment;
	const Endianness endianness;
	const BitMode bitmode;

	void Align (Object::Binary&) const;
	void Assemble (const Section&, Object::Binaries&) const;

	virtual bool Validate (BitMode) const {return false;}
	virtual Size GetDisplacement (Size, BitMode) const {return 0;}
	virtual bool GetDefinition (const Identifier&, Expression&) const {return false;}

	virtual Size ParseInstruction (std::istream&, BitMode, State&) const = 0;
	virtual Size EmitInstruction (std::istream&, BitMode, Endianness, Span<Byte>, Object::Patch&, State&) const = 0;

	friend class Generator;
};

#endif // ECS_ASSEMBLY_ASSEMBLER_HEADER_INCLUDED

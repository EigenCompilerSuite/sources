// Generic disassembler
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

#ifndef ECS_ASSEMBLY_DISASSEMBLER_HEADER_INCLUDED
#define ECS_ASSEMBLY_DISASSEMBLER_HEADER_INCLUDED

#include <cstddef>
#include <cstdint>
#include <iosfwd>
#include <list>

namespace ECS
{
	class Charset;

	template <typename> class Span;

	using Byte = std::uint8_t;
}

namespace ECS::Assembly
{
	class Disassembler;
}

namespace ECS::Object
{
	struct Binary;

	using Binaries = std::list<Binary>;
}

class ECS::Assembly::Disassembler
{
public:
	virtual ~Disassembler () = default;

	void Disassemble (Span<const Byte>, std::ostream&) const;
	void Disassemble (const Object::Binaries&, std::ostream&) const;

protected:
	using Alignment = std::size_t;
	using Size = std::size_t;
	using State = unsigned;

	Disassembler (Charset&, Alignment, Size);

	std::ostream& Write (std::ostream&, Span<const Byte>) const;

private:
	class Context;

	struct Alias;
	struct Reference;

	Charset& charset;
	const Alignment alignment;
	const Size maximum;

	std::ostream& Pad (std::ostream&, Size) const;
	void Write (std::ostream&, const Reference&) const;
	void Write (std::ostream&, const Alias&, Size) const;

	virtual Size ListInstruction (Span<const Byte>, std::ostream&, State&) const = 0;
};

#endif // ECS_ASSEMBLY_DISASSEMBLER_HEADER_INCLUDED

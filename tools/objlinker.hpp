// Object file linker
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

#ifndef ECS_OBJECT_LINKER_HEADER_INCLUDED
#define ECS_OBJECT_LINKER_HEADER_INCLUDED

#include "objmap.hpp"
#include "rangeset.hpp"

namespace ECS
{
	class Charset;
	class Diagnostics;
}

namespace ECS::Object
{
	class Linker;

	struct Arrangement;
	struct ByteArrangement;
	struct MappedByteArrangement;

	auto GetContents (const Binary::Name&, const Binaries&, Charset&, const char* = nullptr) -> std::string;
	auto WriteBinary (std::ostream&, const Bytes&) -> std::ostream&;
}

class ECS::Object::Linker
{
public:
	explicit Linker (Diagnostics&);

	void Combine (Binaries&) const;
	void Link (const Binaries&, Arrangement&) const;
	void Link (const Binaries&, Arrangement&, Arrangement&) const;
	void Link (const Binaries&, Arrangement&, Arrangement&, Arrangement&) const;

private:
	class Context;

	struct Block;
	struct Reference;

	Diagnostics& diagnostics;
};

struct ECS::Object::Arrangement
{
	virtual ~Arrangement () = default;
	virtual Span<Byte> Designate (Offset, Size) = 0;
	virtual Offset Allocate (const Binary&, Size) = 0;
};

struct ECS::Object::ByteArrangement : Arrangement
{
	Bytes bytes;
	Section::Origin origin = 0;

protected:
	Offset Allocate (const Binary&, Size) override;

private:
	Offset placement = 0;
	RangeSet<Offset> layout;

	Offset NextFit (Size, Binary::Alignment) const;

	Span<Byte> Designate (Offset, Size) override;
};

struct ECS::Object::MappedByteArrangement : ByteArrangement
{
	Map map;

private:
	Offset Allocate (const Binary&, Size) override;
};

#endif // ECS_OBJECT_LINKER_HEADER_INCLUDED

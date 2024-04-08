// Intel HEX file representation
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

#ifndef ECS_OBJECT_HEXFILE_HEADER_INCLUDED
#define ECS_OBJECT_HEXFILE_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>
#include <vector>

namespace ECS
{
	using Byte = std::uint8_t;
}

namespace ECS::Object
{
	struct HexFile;

	using Bytes = std::vector<Byte>;
	using Offset = std::size_t;

	std::ostream& operator << (std::ostream&, const HexFile&);
}

struct ECS::Object::HexFile
{
	struct Record;

	using Displacement = std::size_t;
	using RecordLength = std::size_t;

	std::vector<Record> records;

	HexFile (const Bytes&, Displacement, RecordLength = 16);
};

struct ECS::Object::HexFile::Record
{
	enum Type {Data = 0, EndOfFile = 1, ExtendedLinearAddress = 4};

	Type type;
	Offset offset;
	Bytes bytes;

	explicit Record (Type, Offset = 0);

	Byte GetChecksum () const;
};

namespace ECS::Object
{
	std::ostream& operator << (std::ostream&, const HexFile::Record&);
}

#endif // ECS_OBJECT_HEXFILE_HEADER_INCLUDED

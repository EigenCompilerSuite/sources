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

#include "objhexfile.hpp"
#include "utilities.hpp"

#include <cassert>
#include <numeric>

using namespace ECS;
using namespace Object;

HexFile::HexFile (const Bytes& bytes, const Displacement displacement, const RecordLength maxLength)
{
	assert (maxLength > 0 && maxLength <= 255);

	for (Offset offset = 0, size = bytes.size (); offset != size;)
	{
		const auto address = (offset + displacement) % 0x10000;
		const auto extendedAddress = (offset + displacement) / 0x10000;
		if ((address == 0 || offset == 0) && extendedAddress != 0)
			records.emplace_back (Record::ExtendedLinearAddress, 0),
			records.back ().bytes.push_back (extendedAddress / 0x100),
			records.back ().bytes.push_back (extendedAddress % 0x100);
		records.emplace_back (Record::Data, address);
		const auto nextOffset = std::min (offset + std::min (maxLength, 0x10000 - address), size);
		records.back ().bytes.assign (bytes.begin () + offset, bytes.begin () + nextOffset);
		offset = nextOffset;
	}

	records.emplace_back (Record::EndOfFile, 0);
}

HexFile::Record::Record (const Type t, const Offset o) :
	type {t}, offset {o}
{
}

Byte HexFile::Record::GetChecksum () const
{
	assert (bytes.size () <= 255);
	return 0x100 - std::accumulate (bytes.begin (), bytes.end (), bytes.size () + offset / 0x100 + offset + type) & 0xff;
}

std::ostream& Object::operator << (std::ostream& stream, const HexFile& hexfile)
{
	for (auto& record: hexfile.records) stream << record;
	return stream;
}

std::ostream& Object::operator << (std::ostream& stream, const HexFile::Record& record)
{
	assert (record.bytes.size () <= 255);
	const auto flags = stream.setf (stream.uppercase);
	WriteByte (stream << ':', record.bytes.size ());
	WriteByte (stream, record.offset / 0x100);
	WriteByte (stream, record.offset);
	WriteByte (stream, record.type);
	WriteBytes (stream, record.bytes);
	WriteByte (stream, record.GetChecksum ()) << '\n';
	stream.flags (flags); return stream;
}

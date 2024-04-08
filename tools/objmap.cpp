// Object map representation
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

#include "objmap.hpp"
#include "utilities.hpp"

using namespace ECS;
using namespace Object;

MapEntry::MapEntry (const Offset o) :
	offset {o}
{
}

MapEntry::MapEntry (const Offset o, const Binary& b) :
	offset {o}, type {b.type}, name {b.name}, size {b.bytes.size ()}, binary {&b}
{
}

bool MapEntry::Covers (const Binary& binary) const
{
	return type == binary.type && size == binary.bytes.size () && name == binary.name;
}

std::istream& Object::operator >> (std::istream& stream, Map& map)
{
	for (MapEntry entry; stream.good () && stream >> std::ws && stream.good () && stream >> entry;) map.insert (entry);
	return stream;
}

std::ostream& Object::operator << (std::ostream& stream, const Map& map)
{
	for (auto& entry: map) stream << entry; return stream;
}

std::istream& Object::operator >> (std::istream& stream, MapEntry& entry)
{
	return ReadString (ReadOffset (stream, entry.offset) >> entry.type, entry.name, '"') >> entry.size;
}

std::ostream& Object::operator << (std::ostream& stream, const MapEntry& entry)
{
	return WriteString (WriteOffset (stream, entry.offset) << '\t' << entry.type << ' ', entry.name, '"') << ' ' << entry.size << '\n';
}

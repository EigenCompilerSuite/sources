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

#ifndef ECS_OBJECT_MAP_HEADER_INCLUDED
#define ECS_OBJECT_MAP_HEADER_INCLUDED

#include "object.hpp"

#include <set>

namespace ECS::Object
{
	struct MapEntry;

	using Map = std::multiset<MapEntry>;

	bool operator < (const MapEntry&, const MapEntry&);

	std::istream& operator >> (std::istream&, Map&);
	std::istream& operator >> (std::istream&, MapEntry&);
	std::ostream& operator << (std::ostream&, const Map&);
	std::ostream& operator << (std::ostream&, const MapEntry&);
}

struct ECS::Object::MapEntry
{
	Offset offset = 0;
	Binary::Type type = Binary::Code;
	Binary::Name name;
	Size size = 0;
	const Binary* binary = nullptr;

	MapEntry () = default;
	explicit MapEntry (Offset);
	MapEntry (Offset, const Binary&);

	bool Covers (const Binary&) const;
};

inline bool ECS::Object::operator < (const MapEntry& a, const MapEntry& b)
{
	return a.offset < b.offset;
}

#endif // ECS_OBJECT_MAP_HEADER_INCLUDED

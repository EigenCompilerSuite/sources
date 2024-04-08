// Map and object file search tool driver
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

#include "driver.hpp"
#include "objmap.hpp"
#include "utilities.hpp"

using namespace ECS;

static Object::Map map;
static Object::Binaries binaries;
static StreamDiagnostics diagnostics {std::cerr};

static void Read (std::istream& stream, const Source& source, const Position&)
{
	if (stream.good () && stream >> std::ws && stream.good () && std::isdigit (stream.peek ())) stream >> map; else stream >> binaries;
	if (!stream) throw InvalidInput {source, "invalid map or object file"};
}

static void Search (const Source& target)
{
	Object::Offset address;
	if (!ReadOffset (std::cin, address) || std::cin.good () && std::cin >> std::ws && !std::cin.eof ()) throw ProcessFailed {"invalid input"};
	auto entry = map.upper_bound (Object::MapEntry {address}); if (entry != map.begin ()) --entry;
	if (entry == map.end () || address < entry->offset || address > entry->offset + entry->size) throw ProcessFailed {"unmapped address"};
	diagnostics.Emit (Diagnostics::Note, "mapsearch", {}, Format ("offset %0 in %1 section '%2'", address - entry->offset, entry->type, entry->name));
	if (binaries.empty ()) return; File file {target, ".msr"}; for (auto& binary: binaries) if (entry->Covers (binary)) file << binary;
}

int main (int argc, char* argv[])
{
	return Drive (Read, "mapsearch", argc, argv, diagnostics, Search);
}

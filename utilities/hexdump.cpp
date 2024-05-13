// Binary file viewer
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

#include "system.hpp"

#include <array>
#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <vector>

struct Entry
{
	std::string type, name;
	unsigned long address, size;
};

std::istream& operator >> (std::istream& stream, Entry& entry)
{
	return stream >> std::hex >> entry.address >> entry.type >> std::quoted (entry.name) >> std::dec >> entry.size;
}

int main (const int argc, char*const argv[])
try
{
	if (argc != 2 && argc != 3) return std::cerr << "Usage: hexdump binary-file [map-file]\n", EXIT_FAILURE;

	std::ifstream binary {argv[1], binary.binary};
	if (!binary.is_open ()) return std::cerr << "hexdump: error: failed to open binary file '" << argv[1] << "'\n", EXIT_FAILURE;

	std::vector<Entry> entries;

	if (argc == 3)
	{
		std::ifstream map {argv[2]};
		if (!map.is_open ()) return std::cerr << "hexdump: error: failed to open map file '" << argv[2] << "'\n", EXIT_FAILURE;
		while (map.good () && map >> std::ws && map.good ()) map >> entries.emplace_back ();
		if (!map) return std::cerr << "hexdump: error: failed to read map file '" << argv[2] << "'\n", EXIT_FAILURE;
		std::sort (entries.begin (), entries.end (), [] (Entry& first, Entry& second) {return first.address < second.address;});
	}

	auto current = entries.begin (), entry = current;
	auto address = current != entries.end () ? current->address : 0;

	static constexpr std::array colors {sys::red, sys::green, sys::yellow, sys::blue, sys::purple, sys::cyan};

	do
	{
		std::cout << std::hex << std::setw (8) << std::setfill ('0') << address;

		char bytes[16]; binary.read (bytes, sizeof bytes);
		for (auto byte = bytes, end = bytes + binary.gcount (); byte != end; ++byte, ++address)
		{
			if ((byte - bytes) % 8 == 0) std::cout << ' ';
			while (current != entries.end () && current->address + current->size <= address) ++current;
			std::cout << ' ' << (current != entries.end () && address - current->address < current->size ? colors[(current - entries.begin ()) % colors.size ()] : sys::standard) << std::setw (2) << (*byte & 0xff);
		}

		std::cout << sys::standard;
		for (; entry != entries.end () && (entry->address < address || !binary.gcount ()); ++entry)
			std::cout << ' ' << ' ' << colors[(entry - entries.begin ()) % colors.size ()] << entry->type << ' ' << std::quoted (entry->name) << ' ' << std::dec << entry->size << sys::standard;
		std::cout << '\n';
	}
	while (binary.gcount ());
}
catch (const std::length_error&)
{
	return std::cerr << "hexdump: fatal error: out of memory\n", EXIT_FAILURE;
}
catch (const std::bad_alloc&)
{
	return std::cerr << "hexdump: fatal error: out of memory\n", EXIT_FAILURE;
}

// C++ source file dependency walker
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

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <set>
#include <stdexcept>
#include <string>

using Filename = std::string;
using Filenames = std::set<Filename>;
using Macro = std::string;
using Macros = std::set<Macro>;

static void Process (const Filename&, Filenames&, Macros&);

static void Process (std::istream& stream, Filenames& includes, Macros& macros, bool active)
{
	for (std::string identifier; stream >> identifier;)
		if (identifier == "//")
			while (stream && stream.peek () != '\n') stream.ignore ();
		else if (identifier == "#if")
			Process (stream, includes, macros, active && stream >> identifier && identifier == "defined" && stream >> identifier && macros.find (identifier) != macros.end ());
		else if (identifier == "#ifdef")
			Process (stream, includes, macros, active && stream >> identifier && macros.find (identifier) != macros.end ());
		else if (identifier == "#ifndef")
			Process (stream, includes, macros, active && stream >> identifier && macros.find (identifier) == macros.end ());
		else if (identifier == "#elif")
			active = !active && stream >> identifier && identifier == "defined" && stream >> identifier && macros.find (identifier) != macros.end ();
		else if (identifier == "#else")
			active = !active;
		else if (identifier == "#endif")
			return;
		else if (active && identifier == "#define" && stream >> identifier)
			macros.insert (identifier);
		else if (active && identifier == "#undef" && stream >> identifier)
			macros.erase (identifier);
		else if (active && identifier == "#include" && stream >> identifier && identifier.size () > 2 && identifier[0] == '"' && identifier[identifier.size () - 1] == '"')
			if (identifier.erase (0, 1).pop_back (), includes.insert (identifier).second) Process (identifier, includes, macros);
}

static void Process (const Filename& filename, Filenames& includes, Macros& macros)
{
	std::ifstream file {filename};
	if (!file.is_open ()) throw filename;
	Process (file, includes, macros, true);
}

static void Print (const char*const prefix, const Filename& filename, const Filenames& includes)
{
	const auto pos = filename.rfind ('.');
	std::cout << "$(addprefix $(" << prefix << "), " << (pos != filename.npos ? Filename {filename, 0, pos} : filename) << "$(O): " << filename;
	for (auto& include: includes) std::cout << ' ' << include;
	std::cout << ")\n";
}

int main (int argc, char* argv[])
try
{
	if (argc < 3)
		return std::cerr << "Usage: depwalk prefix file...\n", EXIT_FAILURE;

	for (auto argument = argv + 2; *argument; ++argument)
	{
		Filenames includes, macros;
		Process (*argument, includes, macros);
		Print (argv[1], *argument, includes);
	}
}
catch (const Filename& filename)
{
	return std::cerr << "depwalk: error: failed to open '" << filename << "'\n", EXIT_FAILURE;
}
catch (const std::length_error&)
{
	return std::cerr << "depwalk: fatal error: out of memory\n", EXIT_FAILURE;
}
catch (const std::bad_alloc&)
{
	return std::cerr << "depwalk: fatal error: out of memory\n", EXIT_FAILURE;
}

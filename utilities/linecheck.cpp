// Text line checker
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

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iostream>

static bool Process (const char* source, std::istream& stream)
{
	auto error = false;
	std::streamoff emptylines = 0, line = 1, spaces = 0, chars = 0;

	for (char character, previous = 0; stream.get (character); previous = character)
		if (character == '\n')
		{
			if (spaces && spaces == chars)
				std::cerr << source << ": line " << line << " consists exclusively of white space\n", error = true;
			else if (spaces && std::isspace (previous))
				std::cerr << source << ": line " << line << " ends with white space\n", error = true;
			if (chars) emptylines = 0; else if (emptylines++)
				std::cerr << source << ": line " << line << " duplicates an empty line\n", error = true;
			++line; spaces = 0; chars = 0;
		}
		else if (std::isspace (character))
		{
			if (spaces && std::isspace (previous) && character != previous)
				std::cerr << source << ": line " << line << " uses inconsistent white space\n", error = true;
			++spaces; ++chars;
		}
		else
			++chars;

	if (chars)
		std::cerr << source << ": last line is not empty\n", error = true;
	else if (emptylines)
		std::cerr << source << ": last line duplicates an empty line\n", error = true;

	return error;
}

static bool ProcessFile (const char*const filename)
{
	std::ifstream file {filename};
	if (!file.is_open ()) return std::cerr << "linecheck: error: failed to open '" << filename << "'\n", true;
	return Process (filename, file);
}

int main (int argc, char* argv[])
{
	if (argc < 2) return Process ("stdin", std::cin) ? EXIT_FAILURE : EXIT_SUCCESS;
	if (std::count_if (argv + 1, argv + argc, ProcessFile)) return EXIT_FAILURE;
}

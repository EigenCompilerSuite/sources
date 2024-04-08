// POSIX system interface
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

#include <cstring>
#include <iostream>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>

const char sys::path_separator {'/'};
const char sys::program_extension[] {""};

bool sys::path_exists (const std::string& path)
{
	struct stat buffer;
	return !stat (path.c_str (), &buffer);
}

bool sys::change_mode (const std::string& path)
{
	return !chmod (path.c_str (), S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);
}

bool sys::set_variable (const char*const name, const std::string& value)
{
	return !setenv (name, value.c_str (), true);
}

std::string sys::get_variable (const char*const name)
{
	if (const auto variable = getenv (name)) return variable; return {};
}

int sys::execute (const std::string& command)
{
	auto line = command; std::vector<char*> arguments;
	for (auto character = &line.front (); *character;) if (*character == ' ') *character = 0, ++character;
		else if (*character != '"') {arguments.push_back (character); do ++character; while (*character && *character != ' ');}
		else {arguments.push_back (++character); while (*character && *character != '"') ++character; if (*character) *character = 0, ++character;}
	arguments.push_back (nullptr); int status = EXIT_FAILURE; const auto pid = fork ();
	if (pid == 0) execvp (arguments.front (), arguments.data ()), exit (status); if (pid != -1) waitpid (pid, &status, 0);
	if (WIFSIGNALED (status)) std::cerr << strsignal (WTERMSIG (status)) << '\n'; return status;
}

std::ostream& sys::blue (std::ostream& stream) {return stream << "\033[34;1m";}
std::ostream& sys::cyan (std::ostream& stream) {return stream << "\033[36;1m";}
std::ostream& sys::green (std::ostream& stream) {return stream << "\033[32;1m";}
std::ostream& sys::purple (std::ostream& stream) {return stream << "\033[35;1m";}
std::ostream& sys::red (std::ostream& stream) {return stream << "\033[31;1m";}
std::ostream& sys::standard (std::ostream& stream) {return stream << "\033[0m";}
std::ostream& sys::white (std::ostream& stream) {return stream << "\033[37;1m";}
std::ostream& sys::yellow (std::ostream& stream) {return stream << "\033[33;1m";}

// Linux system interface
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

#include <climits>
#include <cstring>
#include <sys/utsname.h>
#include <unistd.h>

const char* sys::get_name ()
{
	struct utsname name;
	if (uname (&name)) return nullptr;
	if (!std::strcmp (name.machine, "i686")) return "amd32linux";
	if (!std::strcmp (name.machine, "x86_64")) return "amd64linux";
	if (!std::strcmp (name.machine, "armv7l")) return "arma32linux";
	if (!std::strcmp (name.machine, "armv8l")) return "arma32linux";
	if (!std::strcmp (name.machine, "aarch64")) return "arma64linux";
	if (!std::strcmp (name.machine, "mips")) return "mips32linux";
	return nullptr;
}

std::string sys::get_program_path ()
{
	char buffer[PATH_MAX];
	const auto size = readlink ("/proc/self/exe", buffer, sizeof buffer);
	return {buffer, size >= 0 ? std::size_t (size) : 0};
}

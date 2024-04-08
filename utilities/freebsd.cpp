// FreeBSD system interface
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

#include <limits.h>
#include <sys/sysctl.h>

const char* sys::get_name ()
{
	return nullptr;
}

std::string sys::get_program_path ()
{
	char buffer[PATH_MAX]; std::size_t length = sizeof buffer;
	static const int name[4] {CTL_KERN, KERN_PROC, KERN_PROC_PATHNAME, -1};
	return {buffer, !sysctl (name, 4, buffer, &length, nullptr, 0) && length ? length - 1 : 0};
}

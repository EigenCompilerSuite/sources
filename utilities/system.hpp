// Generic system interface
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

#ifndef ECS_SYSTEM_HEADER_INCLUDED
#define ECS_SYSTEM_HEADER_INCLUDED

#include <iosfwd>
#include <string>

namespace sys
{
	extern const char path_separator;
	extern const char program_extension[];

	auto change_mode (const std::string&) -> bool;
	auto get_name () -> const char*;
	auto get_program_path () -> std::string;
	auto get_variable (const char*) -> std::string;
	auto path_exists (const std::string&) -> bool;
	auto set_variable (const char*, const std::string&) -> bool;
	auto execute (const std::string&) -> int;

	std::ostream& blue (std::ostream&);
	std::ostream& cyan (std::ostream&);
	std::ostream& green (std::ostream&);
	std::ostream& purple (std::ostream&);
	std::ostream& red (std::ostream&);
	std::ostream& standard (std::ostream&);
	std::ostream& white (std::ostream&);
	std::ostream& yellow (std::ostream&);
}

#endif // ECS_SYSTEM_HEADER_INCLUDED

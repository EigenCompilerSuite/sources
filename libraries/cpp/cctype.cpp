// Standard C++ <cctype> header
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

// Under Section 7 of the GNU General Public License version 3,
// the copyright holder grants you additional permissions to use
// this file as described in the ECS Runtime Support Exception.

// You should have received a copy of the GNU General Public License
// and a copy of the ECS Runtime Support Exception along with
// the ECS.  If not, see <https://www.gnu.org/licenses/>.

#include "cctype"

using namespace std;

// standard isalnum function

int std::isalnum (const int c) noexcept
{
	return c >= '0' && c <= '9' || c >= 'A' && c <= 'Z' || c >= 'a' && c <= 'z';
}

// standard isalpha function

int std::isalpha (const int c) noexcept
{
	return c >= 'A' && c <= 'Z' || c >= 'a' && c <= 'z';
}

// standard isblank function

int std::isblank (const int c) noexcept
{
	return c == ' ' || c == '\t';
}

// standard iscntrl function

int std::iscntrl (const int c) noexcept
{
	return c >= '\x0' && c <= '\x1f' || c == '\x7f';
}

// standard isdigit function

int std::isdigit (const int c) noexcept
{
	return c >= '0' && c <= '9';
}

// standard isgraph function

int std::isgraph (const int c) noexcept
{
	return c >= '!' && c <= '~';
}

// standard islower function

int std::islower (const int c) noexcept
{
	return c >= 'a' && c <= 'z';
}

// standard isprint function

int std::isprint (const int c) noexcept
{
	return c >= ' ' && c <= '~';
}

// standard ispunct function

int std::ispunct (const int c) noexcept
{
	return c >= '!' && c <= '/' || c >= ':' && c <= '@' || c >= '[' && c <= '`' || c >= '{' && c <= '~';
}

// standard isspace function

int std::isspace (const int c) noexcept
{
	return c >= '\t' && c <= '\r';
}

// standard isupper function

int std::isupper (const int c) noexcept
{
	return c >= 'A' && c <= 'Z';
}

// standard isxdigit function

int std::isxdigit (const int c) noexcept
{
	return c >= '0' && c <= '9' || c >= 'A' && c <= 'F' || c >= 'a' && c <= 'f';
}

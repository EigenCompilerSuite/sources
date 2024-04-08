// Standard C++ <cassert> header
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

#include "cassert"
#include "cstdio"
#include "cstdlib"

using namespace std;

// extended fail function

void std::_fail (const char*const source, const size_t position, const char*const function, const char*const expression) noexcept
{
	fputs (source, stderr);
	fputc (':', stderr);
	if (position >= 10) fputc (char (position / 10 + '0'), stderr);
	fputc (char (position % 10 + '0'), stderr);
	fputs (": error: assertion '", stderr);
	fputs (expression, stderr);
	fputs ("' in function '", stderr);
	fputs (function, stderr);
	fputs ("' failed\n", stderr);
	abort ();
}

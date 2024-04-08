// Standard C <stdio.h> header
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

#ifndef ECS_C_STDIO_HEADER_INCLUDED
#define ECS_C_STDIO_HEADER_INCLUDED

[[deprecated ("this header is deprecated, use <cstdio> instead")]];

#include "cstdio"

using std::FILE;
using std::fgetc;
using std::fputc;
using std::fputs;
using std::getchar;
using std::printf;
using std::putchar;
using std::puts;
using std::remove;
using std::rename;
using std::size_t;
using std::stderr;
using std::stdin;
using std::stdout;

#endif // ECS_C_STDIO_HEADER_INCLUDED

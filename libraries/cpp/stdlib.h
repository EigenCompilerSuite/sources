// Standard C <stdlib.h> header
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

#ifndef ECS_C_STDLIB_HEADER_INCLUDED
#define ECS_C_STDLIB_HEADER_INCLUDED

[[deprecated ("this header is deprecated, use <cstdlib> instead")]];

#include "cstdlib"

using std::_Exit;
using std::abort;
using std::abs;
using std::aligned_alloc;
using std::at_exit;
using std::at_quick_exit;
using std::atof;
using std::atoi;
using std::atol;
using std::atoll;
using std::bsearch;
using std::calloc;
using std::div;
using std::div_t;
using std::exit;
using std::free;
using std::getenv;
using std::labs;
using std::labs;
using std::ldiv;
using std::ldiv_t;
using std::llabs;
using std::llabs;
using std::lldiv;
using std::lldiv_t;
using std::malloc;
using std::mblen;
using std::mbstowcs;
using std::mbtowc;
using std::qsort;
using std::quick_exit;
using std::rand;
using std::realloc;
using std::realloc;
using std::size_t;
using std::srand;
using std::strtod;
using std::strtof;
using std::strtol;
using std::strtold;
using std::strtoll;
using std::strtoul;
using std::strtoull;
using std::system;
using std::wcstombs;
using std::wctomb;

#endif // ECS_C_STDLIB_HEADER_INCLUDED

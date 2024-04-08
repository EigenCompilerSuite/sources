// Standard C <math.h> header
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

#ifndef ECS_C_MATH_HEADER_INCLUDED
#define ECS_C_MATH_HEADER_INCLUDED

[[deprecated ("this header is deprecated, use <cmath> instead")]];

#include "cmath"

using std::copysign;
using std::copysignf;
using std::copysignl;
using std::cos;
using std::floor;
using std::floorf;
using std::floorl;
using std::cosf;
using std::cosl;
using std::fabs;
using std::fabsf;
using std::fabsl;
using std::fma;
using std::fmaf;
using std::fmal;
using std::fmax;
using std::fmaxf;
using std::fmaxl;
using std::fmin;
using std::fminf;
using std::fminl;
using std::isfinite;
using std::isinf;
using std::isnan;
using std::isnormal;
using std::signbit;
using std::sin;
using std::sinf;
using std::sinl;
using std::sqrt;
using std::sqrtf;
using std::sqrtl;
using std::tan;
using std::tanf;
using std::tanl;

#endif // ECS_C_MATH_HEADER_INCLUDED

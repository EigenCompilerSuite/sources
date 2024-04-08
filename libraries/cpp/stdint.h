// Standard C <stdint.h> header
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

#ifndef ECS_C_STDINT_HEADER_INCLUDED
#define ECS_C_STDINT_HEADER_INCLUDED

[[deprecated ("this header is deprecated, use <cstdint> instead")]];

#include "cstdint"

using std::int16_t;
using std::int32_t;
using std::int64_t;
using std::int8_t;
using std::int_fast16_t;
using std::int_fast32_t;
using std::int_fast64_t;
using std::int_fast8_t;
using std::int_least16_t;
using std::int_least32_t;
using std::int_least64_t;
using std::int_least8_t;
using std::uint16_t;
using std::uint32_t;
using std::uint64_t;
using std::uint8_t;
using std::uint_fast16_t;
using std::uint_fast32_t;
using std::uint_fast64_t;
using std::uint_fast8_t;
using std::uint_least16_t;
using std::uint_least32_t;
using std::uint_least64_t;
using std::uint_least8_t;

#endif // ECS_C_STDINT_HEADER_INCLUDED

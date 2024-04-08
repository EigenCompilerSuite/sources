// Standard IEEE 754 floating-point conversions
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

#ifndef ECS_IEEE_HEADER_INCLUDED
#define ECS_IEEE_HEADER_INCLUDED

#include <cstdint>

namespace ECS
{
	using Bits = unsigned;
}

namespace ECS::IEEE
{
	template <Bits, Bits, typename, typename> struct Precision;

	using DoublePrecision = Precision<11, 52, std::uint64_t, double>;
	using SinglePrecision = Precision<8, 23, std::uint32_t, float>;
}

template <ECS::Bits Exponent, ECS::Bits Significant, typename Unsigned, typename Float>
struct ECS::IEEE::Precision
{
	static Float Decode (Unsigned) noexcept;
	static Unsigned Encode (Float) noexcept;

	static_assert (sizeof (Float) * 8 == Exponent + Significant + 1);
	static_assert (sizeof (Unsigned) * 8 == Exponent + Significant + 1);
};

#include <cmath>

template <ECS::Bits Exponent, ECS::Bits Significant, typename Unsigned, typename Float>
Float ECS::IEEE::Precision<Exponent, Significant, Unsigned, Float>::Decode (Unsigned value) noexcept
{
	return reinterpret_cast<Float&> (value);
}

template <ECS::Bits Exponent, ECS::Bits Significant, typename Unsigned, typename Float>
Unsigned ECS::IEEE::Precision<Exponent, Significant, Unsigned, Float>::Encode (Float value) noexcept
{
	if (std::isinf (value)) return ~(Unsigned (!std::signbit (value)) << Exponent) << Significant;
	if (std::isnan (value)) return ~(Unsigned (!std::signbit (value)) << Exponent + 1) << Significant - 1;
	if (value == 0) return 0; Unsigned result = 0; signed exponent = 0;
	if (value < 0) value = -value, result = 1 << Exponent;
	while (value < 1) value *= 2, --exponent; while (value >= 2) value /= 2, ++exponent;
	result |= exponent + ((1 << (Exponent - 1)) - 1); value -= 1;
	for (Bits i = 0; i != Significant; ++i) if (result <<= 1, (value *= 2) >= 1) value -= 1, result |= 1;
	return result;
}

#endif // ECS_IEEE_HEADER_INCLUDED

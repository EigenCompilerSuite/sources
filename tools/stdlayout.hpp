// Standard type layout
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

#ifndef ECS_STANDARDLAYOUT_HEADER_INCLUDED
#define ECS_STANDARDLAYOUT_HEADER_INCLUDED

#include "layout.hpp"

namespace ECS
{
	class StandardLayout;
}

class ECS::StandardLayout : public Layout
{
public:
	constexpr StandardLayout ();

private:
	template <typename Default, typename... Variants>
	struct Variant
	{
		static constexpr auto size = sizeof (Default);
		static constexpr auto minimum = alignof (Default) < Variant<Variants...>::minimum ? alignof (Default) : Variant<Variants...>::minimum;
		static constexpr auto maximum = alignof (Default) > Variant<Variants...>::maximum ? alignof (Default) : Variant<Variants...>::maximum;

		static constexpr Type type {size, minimum, maximum};
	};

	template <typename Default>
	struct Variant<Default>
	{
		static constexpr auto size = sizeof (Default);
		static constexpr auto alignment = alignof (Default);
		static constexpr auto minimum = alignment;
		static constexpr auto maximum = alignment;

		static constexpr Type type {size, alignment};
	};

	using Float = Variant<double, float, long double>;
	using Function = Variant<void(*)()>;
	using Integer = Variant<int, char, short, long, long long>;
	using Pointer = Variant<void*>;
	using Stack = Variant<long long, long double, void*, void(*)()>;
};

template <typename Default, typename... Variants>
constexpr ECS::Layout::Type ECS::StandardLayout::Variant<Default, Variants...>::type;

template <typename Default>
constexpr ECS::Layout::Type ECS::StandardLayout::Variant<Default>::type;

constexpr ECS::StandardLayout::StandardLayout () :
	Layout {Integer::type, Float::type, Pointer::type, Function::type, {0, Stack::maximum, Stack::maximum}, true}
{
}

#endif // ECS_STANDARDLAYOUT_HEADER_INCLUDED

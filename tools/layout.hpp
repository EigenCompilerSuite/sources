// Generic type layout
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

#ifndef ECS_LAYOUT_HEADER_INCLUDED
#define ECS_LAYOUT_HEADER_INCLUDED

#include <cstddef>

namespace ECS
{
	class Layout;
}

class ECS::Layout
{
public:
	struct Alignment
	{
		std::size_t minimum, maximum;

		constexpr std::size_t operator () (std::size_t) const;
	};

	struct Type
	{
		std::size_t size;
		Alignment alignment;

		constexpr Type (std::size_t);
		constexpr Type (std::size_t, std::size_t);
		constexpr Type (std::size_t, std::size_t, std::size_t);
	};

	using CallStack = bool;
	using Float = Type;
	using Function = Type;
	using Integer = Type;
	using Pointer = Type;
	using Stack = Type;

	const Integer integer;
	const Float float_;
	const Pointer pointer;
	const Function function;
	const Stack stack;
	const CallStack callStack;

	constexpr Layout (const Integer&, const Float&, const Pointer&, const Function&, const Stack&, CallStack);
};

constexpr ECS::Layout::Layout (const Integer& i, const Float& fl, const Pointer& p, const Function& fu, const Stack& s, const CallStack cs) :
	integer {i}, float_ {fl}, pointer {p}, function {fu}, stack {s}, callStack {cs}
{
}

constexpr std::size_t ECS::Layout::Alignment::operator () (const std::size_t size) const
{
	return size < minimum ? minimum : size > maximum ? maximum : size;
}

constexpr ECS::Layout::Type::Type (const std::size_t s) :
	size {s}, alignment {s, s}
{
}

constexpr ECS::Layout::Type::Type (const std::size_t s, const std::size_t a) :
	Type {s, a, a}
{
}

constexpr ECS::Layout::Type::Type (const std::size_t s, const std::size_t minimum, const std::size_t maximum) :
	size {s}, alignment {minimum, maximum}
{
}

#endif // ECS_LAYOUT_HEADER_INCLUDED

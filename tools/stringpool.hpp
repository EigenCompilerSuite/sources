// Generic string pool
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

#ifndef ECS_STRINGPOOL_HEADER_INCLUDED
#define ECS_STRINGPOOL_HEADER_INCLUDED

#include <string>
#include <string_view>
#include <unordered_set>

namespace ECS
{
	class StringPool;
}

class ECS::StringPool
{
public:
	StringPool () = default;
	StringPool (StringPool&&) = default;
	StringPool& operator = (StringPool&&) = default;

	const std::string* Insert (std::string_view);
	const std::u32string* Insert (std::u32string_view);

private:
	std::unordered_set<std::string> strings;
	std::unordered_set<std::u32string> u32strings;
};

inline const std::string* ECS::StringPool::Insert (const std::string_view string)
{
	return &*strings.emplace (string).first;
}

inline const std::u32string* ECS::StringPool::Insert (const std::u32string_view string)
{
	return &*u32strings.emplace (string).first;
}

#endif // ECS_STRINGPOOL_HEADER_INCLUDED

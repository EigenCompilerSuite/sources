// Generic text formatting
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

#ifndef ECS_FORMAT_HEADER_INCLUDED
#define ECS_FORMAT_HEADER_INCLUDED

#include <iosfwd>
#include <string>

namespace ECS
{
	template <typename... Values> std::string Format (const char*, const Values&...);

	template <typename Value> std::ostream& WriteFormatted (std::ostream&, const Value&);
	template <typename Value> std::ostream& WriteFormatted (int, std::ostream&, const Value&);
	template <typename Value, typename... Values> std::ostream& WriteFormatted (int, std::ostream&, const Value&, const Values&...);
}

#include <cassert>
#include <sstream>

template <typename Value>
inline std::ostream& ECS::WriteFormatted (std::ostream& stream, const Value& value)
{
	return stream << value;
}

template <typename Value>
inline std::ostream& ECS::WriteFormatted (const int index, std::ostream& stream, const Value& value)
{
	assert (!index); return WriteFormatted (stream, value);
}

template <typename Value, typename... Values>
inline std::ostream& ECS::WriteFormatted (const int index, std::ostream& stream, const Value& value, const Values&... values)
{
	return index ? WriteFormatted (index - 1, stream, values...) : WriteFormatted (stream, value);
}

template <typename... Values>
std::string ECS::Format (const char* string, const Values&... values)
{
	assert (string); static_assert (sizeof... (values) < 10); std::ostringstream stream;
	for (; *string; ++string) if (*string == '%' && *++string != '%') WriteFormatted (*string - '0', stream, values...); else stream.put (*string);
	return stream.str ();
}

#endif // ECS_FORMAT_HEADER_INCLUDED

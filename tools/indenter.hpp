// Generic indenter
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

#ifndef ECS_INDENTER_HEADER_INCLUDED
#define ECS_INDENTER_HEADER_INCLUDED

#include <cstddef>
#include <iosfwd>

namespace ECS
{
	template <typename, typename> class BasicIndenter;

	using Indenter = BasicIndenter<std::ostream, char>;
	using WIndenter = BasicIndenter<std::wostream, wchar_t>;
}

template <typename Stream, typename Value>
class ECS::BasicIndenter
{
public:
	explicit BasicIndenter (const Value& = '\t', std::size_t = 0);

	Stream& Increase (Stream&);
	Stream& Decrease (Stream&);

	Stream& Indent (Stream&) const;

private:
	const Value value;
	std::size_t indentation;
};

template <typename Stream, typename Value>
inline ECS::BasicIndenter<Stream, Value>::BasicIndenter (const Value& v, const std::size_t i) :
	value {v}, indentation {i}
{
}

template <typename Stream, typename Value>
inline Stream& ECS::BasicIndenter<Stream, Value>::Increase (Stream& stream)
{
	return ++indentation, stream;
}

template <typename Stream, typename Value>
inline Stream& ECS::BasicIndenter<Stream, Value>::Decrease (Stream& stream)
{
	return --indentation, stream;
}

template <typename Stream, typename Value>
Stream& ECS::BasicIndenter<Stream, Value>::Indent (Stream& stream) const
{
	for (auto indent = indentation; indent; --indent) stream << value; return stream;
}

#endif // ECS_INDENTER_HEADER_INCLUDED

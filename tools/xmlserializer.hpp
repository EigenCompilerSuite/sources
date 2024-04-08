// Generic XML serializer
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

#ifndef ECS_XML_SERIALIZER_HEADER_INCLUDED
#define ECS_XML_SERIALIZER_HEADER_INCLUDED

#include "xml.hpp"

namespace ECS
{
	class Position;
}

namespace ECS::XML
{
	class Serializer;

	template <typename Value> std::ostream& WriteSerialized (std::ostream&, const Value&);
}

class ECS::XML::Serializer
{
public:
	Serializer (Document&, const char*, const char*);

	void Open (const char*);
	void Close ();

	void Attribute (const Position&);
	void Attribute (const char*, bool);
	void Attribute (const char*, const char*);
	void Attribute (const char*, const String&);
	template <typename Value> void Attribute (const char*, const Value&);

	void Write (const String&);
	template <typename Value> void Write (const Value&);
	template <typename C, typename T> void Write (const std::basic_string<C, T>&);

private:
	Element* element;
	std::vector<Element*> stack;
};

#include <sstream>

template <typename Value>
inline std::ostream& ECS::XML::WriteSerialized (std::ostream& stream, const Value& value)
{
	return stream << value;
}

template <typename Value>
void ECS::XML::Serializer::Attribute (const char*const name, const Value& value)
{
	std::ostringstream stream; WriteSerialized (stream, value); element->attributes.emplace_back (name, stream.str ());
}

template <typename Value>
void ECS::XML::Serializer::Write (const Value& value)
{
	std::ostringstream stream; WriteSerialized (stream, value); Write (stream.str ());
}

template <typename C, typename T>
void ECS::XML::Serializer::Write (const std::basic_string<C, T>& value)
{
	element->text.append (value.begin (), value.end ());
}

#endif // ECS_XML_SERIALIZER_HEADER_INCLUDED

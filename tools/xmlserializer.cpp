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

#include "position.hpp"
#include "xmlserializer.hpp"

#include <cassert>

using namespace ECS;
using namespace XML;

Serializer::Serializer (Document& document, const char*const name, const char*const definition) :
	element {&document.root}
{
	document.definition = definition;
	element->name = name;
}

void Serializer::Open (const char*const name)
{
	stack.push_back (element);
	element = &element->children.emplace_back (name);
}

void Serializer::Close ()
{
	assert (!stack.empty ());
	element = stack.back ();
	stack.pop_back ();
}

void Serializer::Attribute (const Position& position)
{
	Attribute ("line", GetLine (position));
	Attribute ("column", GetColumn (position));
}

void Serializer::Attribute (const char*const name, const bool value)
{
	Attribute (name, value ? "true" : "false");
}

void Serializer::Attribute (const char*const name, const char*const value)
{
	element->attributes.emplace_back (name, value);
}

void Serializer::Attribute (const char*const name, const String& value)
{
	element->attributes.emplace_back (name, value);
}

void Serializer::Write (const String& string)
{
	element->text.append (string);
}

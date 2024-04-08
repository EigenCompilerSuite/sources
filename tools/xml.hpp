// XML document representation
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

#ifndef ECS_XML_HEADER_INCLUDED
#define ECS_XML_HEADER_INCLUDED

#include <string>
#include <vector>

namespace ECS::XML
{
	struct Attribute;
	struct Document;
	struct Element;

	using Attributes = std::vector<Attribute>;
	using Elements = std::vector<Element>;
	using String = std::string;
}

struct ECS::XML::Attribute
{
	String name, value;

	Attribute (const char*, const char*);
	Attribute (const char*, const String&);
};

struct ECS::XML::Element
{
	String name, text;
	Elements children;
	Attributes attributes;

	Element () = default;
	explicit Element (const char*);
};

struct ECS::XML::Document
{
	String definition;
	Element root;
};

#endif // ECS_XML_HEADER_INCLUDED

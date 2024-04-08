// FALSE serializer
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

#include "false.hpp"
#include "falserializer.hpp"
#include "xmlserializer.hpp"

using namespace ECS;
using namespace FALSE;

void Serializer::Serialize (const Program& program, XML::Document& document) const
{
	XML::Serializer serializer {document, "program", "false"}; Serialize (program, serializer);
}

void Serializer::Serialize (const Program& program, XML::Serializer& serializer) const
{
	serializer.Attribute ("source", program.source);
	Serialize (program.main, serializer);
}

void Serializer::Serialize (const Function& function, XML::Serializer& serializer) const
{
	for (auto& element: function) Serialize (element, serializer);
}

void Serializer::Serialize (const Element& element, XML::Serializer& serializer) const
{
	serializer.Open ("element");
	switch (element.symbol)
	{
	case Lexer::Flush: serializer.Attribute ("symbol", "flush"); break;
	case Lexer::Select: serializer.Attribute ("symbol", "select"); break;
	case Lexer::BeginFunction: serializer.Attribute ("symbol", "function"); Serialize (*element.function, serializer); break;
	case Lexer::Integer: serializer.Attribute ("symbol", "integer"); serializer.Write (element.integer); break;
	case Lexer::Character: serializer.Attribute ("symbol", "character"); serializer.Write (element.character); break;
	case Lexer::Variable: serializer.Attribute ("symbol", "variable"); serializer.Write (element.integer); break;
	case Lexer::String: serializer.Attribute ("symbol", "string"); serializer.Write (element.string); break;
	case Lexer::ExternalVariable: serializer.Attribute ("symbol", "external variable"); serializer.Write (element.string); break;
	case Lexer::ExternalFunction: serializer.Attribute ("symbol", "external function"); serializer.Write (element.string); break;
	case Lexer::Assembly: serializer.Attribute ("symbol", "assembly"); serializer.Write (element.string); break;
	default: serializer.Attribute ("symbol", element.symbol);
	}
	serializer.Attribute (element.position);
	serializer.Close ();
}

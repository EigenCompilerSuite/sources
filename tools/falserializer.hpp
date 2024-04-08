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

#ifndef ECS_FALSE_SERIALIZER_HEADER_INCLUDED
#define ECS_FALSE_SERIALIZER_HEADER_INCLUDED

#include "fallexer.hpp"

namespace ECS::FALSE
{
	class Serializer;

	struct Program;

	using Element = Lexer::Token;
	using Function = std::vector<Element>;
}

namespace ECS::XML
{
	class Serializer;

	struct Document;
}

class ECS::FALSE::Serializer
{
public:
	void Serialize (const Program&, XML::Document&) const;

private:
	void Serialize (const Element&, XML::Serializer&) const;
	void Serialize (const Program&, XML::Serializer&) const;
	void Serialize (const Function&, XML::Serializer&) const;
};

#endif // ECS_FALSE_SERIALIZER_HEADER_INCLUDED

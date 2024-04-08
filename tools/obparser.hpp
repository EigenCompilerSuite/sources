// Oberon parser
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

#ifndef ECS_OBERON_PARSER_HEADER_INCLUDED
#define ECS_OBERON_PARSER_HEADER_INCLUDED

#include <iosfwd>

namespace ECS
{
	class Diagnostics;
	class Position;
}

namespace ECS::Oberon
{
	class Parser;

	struct Module;
}

class ECS::Oberon::Parser
{
public:
	using Annotations = bool;

	Parser (Diagnostics&, Annotations);

	void Parse (std::istream&, const Position&, Module&) const;

private:
	class Context;

	Diagnostics& diagnostics;
	const Annotations annotations;
};

#endif // ECS_OBERON_PARSER_HEADER_INCLUDED

// Oberon generic documentation extractor
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

#ifndef ECS_OBERON_EXTRACTOR_HEADER_INCLUDED
#define ECS_OBERON_EXTRACTOR_HEADER_INCLUDED

namespace ECS
{
	class Diagnostics;
}

namespace ECS::Oberon
{
	class Extractor;

	struct Module;
}

namespace ECS::Documentation
{
	struct Document;
}

class ECS::Oberon::Extractor
{
public:
	explicit Extractor (Diagnostics&);

	void Extract (const Module&, Documentation::Document&) const;

private:
	class Context;

	Diagnostics& diagnostics;
};

#endif // ECS_OBERON_EXTRACTOR_HEADER_INCLUDED

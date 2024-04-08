// Generic documentation semantic checker
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

#ifndef ECS_DOCUMENTATION_CHECKER_HEADER_INCLUDED
#define ECS_DOCUMENTATION_CHECKER_HEADER_INCLUDED

#include <list>

namespace ECS
{
	class Diagnostics;
}

namespace ECS::Documentation
{
	class Checker;

	struct Document;

	using Documents = std::list<Document>;
}

class ECS::Documentation::Checker
{
public:
	explicit Checker (Diagnostics&);

	void Check (Documents&) const;

private:
	class Context;

	Diagnostics& diagnostics;
};

#endif // ECS_DOCUMENTATION_CHECKER_HEADER_INCLUDED

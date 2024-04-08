// Intermediate code optimizer
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

#ifndef ECS_CODE_OPTIMIZER_HEADER_INCLUDED
#define ECS_CODE_OPTIMIZER_HEADER_INCLUDED

#include <list>

namespace ECS
{
	class Diagnostics;
}

namespace ECS::Code
{
	class Optimizer;
	class Platform;

	struct Section;

	using Sections = std::list<Section>;
}

class ECS::Code::Optimizer
{
public:
	explicit Optimizer (Platform&);

	void Optimize (Sections&) const;
	void Optimize (Section&, const Sections&) const;

private:
	class Context;

	Platform& platform;
};

#endif // ECS_CODE_OPTIMIZER_HEADER_INCLUDED

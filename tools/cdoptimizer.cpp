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

#include "cdoptimizer.hpp"
#include "code.hpp"

using namespace ECS;
using namespace Code;

using Context = class Optimizer::Context
{
public:
	Context (const Optimizer&, const Sections&);

	void Optimize (Section&);

private:
	const Optimizer& optimizer;
	const Sections& sections;
};

Optimizer::Optimizer (Platform& p) :
	platform {p}
{
}

void Optimizer::Optimize (Sections& sections) const
{
	for (auto& section: sections) Optimize (section, sections);
}

void Optimizer::Optimize (Section& section, const Sections& sections) const
{
	if (!IsCode (section.type) || section.instructions.empty ()) return;
	Context {*this, sections}.Optimize (section);
}

Context::Context (const Optimizer& o, const Sections& s) :
	optimizer {o}, sections {s}
{
}

void Context::Optimize (Section& section)
{
	assert (!section.instructions.empty ());
}

// Oberon intermediate code emitter
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

#ifndef ECS_OBERON_EMITTER_HEADER_INCLUDED
#define ECS_OBERON_EMITTER_HEADER_INCLUDED

#include "cdemitter.hpp"

namespace ECS::Oberon
{
	class Emitter;
	class Platform;

	struct Module;
}

class ECS::Oberon::Emitter : public Code::Emitter
{
public:
	Emitter (Diagnostics&, StringPool&, Charset&, Code::Platform&, Platform&);

	void Emit (const Module&, Code::Sections&) const;

private:
	class Context;

	struct Cache;

	Platform& platform;

	void Emit (const Module&, Cache&, Code::Sections&) const;
};

#endif // ECS_OBERON_EMITTER_HEADER_INCLUDED

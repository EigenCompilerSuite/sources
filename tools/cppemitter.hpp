// C++ intermediate code emitter
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

#ifndef ECS_CPP_EMITTER_HEADER_INCLUDED
#define ECS_CPP_EMITTER_HEADER_INCLUDED

#include "cdemitter.hpp"

namespace ECS::CPP
{
	class Emitter;
	class Platform;

	struct TranslationUnit;
}

class ECS::CPP::Emitter : public Code::Emitter
{
public:
	Emitter (Diagnostics&, StringPool&, Charset&, Code::Platform&, Platform&);

	void Emit (const TranslationUnit&, Code::Sections&) const;

private:
	class Context;

	Platform& platform;
};

#endif // ECS_CPP_EMITTER_HEADER_INCLUDED

// Generic machine code generator
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

#ifndef ECS_ASSEMBLY_GENERATOR_HEADER_INCLUDED
#define ECS_ASSEMBLY_GENERATOR_HEADER_INCLUDED

#include "asmparser.hpp"
#include "asmprinter.hpp"
#include "code.hpp"
#include "layout.hpp"

namespace ECS::Assembly
{
	class Assembler;
	class Generator;
}

namespace ECS::Debugging
{
	struct Information;
}

class ECS::Assembly::Generator
{
public:
	Layout layout;
	Code::Platform platform;

	virtual ~Generator () = default;

	void Generate (const Code::Sections&, const Source&, Object::Binaries&, Debugging::Information&, std::ostream&) const;

protected:
	class Context;

	using HasLinkRegister = bool;
	using Name = const char*;
	using Target = const char*;

	Generator (Diagnostics&, StringPool&, Assembler&, Target, Name, const Layout&, HasLinkRegister);

private:
	Assembler& assembler;
	const Target target;
	const Name name;

	Parser parser;
	Printer printer;

	virtual void Process (const Code::Sections&, Object::Binaries&, Debugging::Information&, std::ostream&) const = 0;
};

#endif // ECS_ASSEMBLY_GENERATOR_HEADER_INCLUDED

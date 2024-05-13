// Generic assembly language semantic checker context
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

#ifndef ECS_ASSEMBLY_CHECKER_CONTEXT_HEADER_INCLUDED
#define ECS_ASSEMBLY_CHECKER_CONTEXT_HEADER_INCLUDED

#include "asmchecker.hpp"
#include "assembly.hpp"

#include <map>

class ECS::Assembly::Checker::Context
{
public:
	void Process (const Instructions&);

protected:
	struct Link;

	using Inlined = bool;
	using InstructionAlignment = std::size_t;
	using Origin = std::size_t;
	using SectionAlignment = std::size_t;
	using Size = std::size_t;
	using Value = std::int64_t;

	Charset& charset;
	const InstructionAlignment instructionAlignment;
	const SectionAlignment sectionAlignment;
	const Inlined inlined;

	Size offset;
	bool parsing = true;
	const Location* location;

	Context (const Checker&, Object::Section&, Origin, InstructionAlignment, SectionAlignment, Inlined);

	void EmitError [[noreturn]] (const Message&) const;

	bool GetString (const Expression&, String&) const;
	bool GetIdentifier (const Expression&, Identifier&) const;

	virtual bool GetValue (const Expression&, Value&) const;
	virtual bool GetDefinition (const Identifier&, Expression&) const;

	virtual void Reset ();
	virtual void Reserve (Size);
	virtual void ProcessDirective (const Instruction&);

private:
	enum Conditional {Including, IncludingElse, Skipping, Ignoring, IgnoringElse};

	Diagnostics& diagnostics;
	Object::Section& section;
	const Origin origin;

	Size* size;
	Conditional conditional = Including;
	std::vector<Size> sizes;
	std::vector<Conditional> conditionals;
	std::map<Identifier, Expression> definitions;

	void Label (const Instruction&);
	void Process (const Instruction&);
	void Assemble (const Instruction&);

	void ProcessAlignmentDirective (const Expression&) const;
	void ProcessGroupDirective (const Expression&) const;
	void ProcessOriginDirective (const Expression&) const;
	void ProcessTraceDirective (const Expression&) const;

	bool Evaluate (const Expression&) const;
	bool GetOffset (const Expression&, Value&) const;
	void CheckDefinition (const Identifier&, const Expression&);

	bool Compare (const Expression&, const Expression&) const;
	bool Compare (const Expressions&, const Expressions&) const;

	std::ostream& Rewrite (std::ostream&, const Expression&) const;
	std::ostream& Rewrite (std::ostream&, const Expression&, Link&) const;

	virtual Size GetDisplacement (Size) const = 0;
	virtual bool GetLink (const Expression&, Link&) const = 0;
	virtual Size AssembleInstruction (std::istream&, const Link&) = 0;
};

struct ECS::Assembly::Checker::Context::Link
{
	Object::Section::Name name;
	Object::Patch::Mode mode = Object::Patch::Absolute;
	Object::Patch::Displacement displacement = 0;
	Object::Patch::Scale scale = 0;
};

#endif // ECS_ASSEMBLY_CHECKER_CONTEXT_HEADER_INCLUDED

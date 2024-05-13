// Intermediate code semantic checker
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

#include "asmcheckercontext.hpp"
#include "cdchecker.hpp"
#include "code.hpp"
#include "error.hpp"
#include "format.hpp"

using namespace ECS;
using namespace Code;

using Context = class Checker::Context : public Assembly::Checker::Context
{
public:
	Context (const Code::Checker&, Section&, Inlined);

private:
	Section& section;
	Platform& platform;

	Size size;
	std::vector<const Instruction*> declarations;
	bool location, sectionLocation, type, sectionType;

	void Patch (Type&) const;
	bool Check (Instruction&);

	void Reset () override;
	Size GetDisplacement (Size) const override;
	Size AssembleInstruction (std::istream&, const Link&) override;
	bool GetLink (const Assembly::Expression&, Link&) const override;
	bool GetDefinition (const Assembly::Identifier&, Assembly::Expression&) const override;

	static Assembly::Expression Evaluate (Type::Size);
	static Assembly::Expression Evaluate (const Type&);
};

Checker::Checker (Diagnostics& d, Charset& c, Platform& p) :
	Assembly::Checker {d, c}, platform {p}
{
}

void Checker::Check (const Assembly::Program& program, Sections& sections) const
{
	Batch (program.sections, [this, &sections] (const Assembly::Section& section) {Check (section, sections);});
}

void Checker::Check (const Assembly::Instructions& instructions, Section& section) const
{
	Context {*this, section, true}.Process (instructions);
}

void Checker::Check (const Assembly::Section& section, Sections& sections) const
{
	Context {*this, IsAssembly (section) ? sections.emplace_back () : sections.emplace_back (section.type, section.name), IsAssembly (section)}.Process (section.instructions);
}

Context::Context (const Code::Checker& c, Section& s, const Inlined i) :
	Assembly::Checker::Context {c, s, s.instructions.size (), 1, 1, i}, section {s}, platform {c.platform}
{
}

void Context::Patch (Type& type) const
{
	if (type.model == Type::Pointer) type.size = platform.pointer.size;
	else if (type.model == Type::Function) type.size = platform.function.size;
}

bool Context::Check (Instruction& instruction)
{
	instruction.line = Assembly::Checker::Context::location->line;
	Patch (instruction.operand1.type); Patch (instruction.operand2.type); Patch (instruction.operand3.type);
	if (parsing) return IsValid (instruction);

	if (instruction.mnemonic == Instruction::DEF)
		if (!platform.IsAligned (size, instruction.operand1.type)) EmitError ("misaligned datum definition");
		else if (!platform.IsAligned (section, instruction.operand1.type)) EmitError (Format ("misaligned %0 section", section.type));
		else size += instruction.operand1.type.size;
	else if (instruction.mnemonic == Instruction::RES)
		size += instruction.operand1.size;

	if (IsLocating (instruction.mnemonic))
		if (location) location = false; else if (!sectionLocation) sectionLocation = true; else EmitError ("invalid source code location");
	if (IsLocated (instruction.mnemonic))
		if (!location && sectionLocation || IsType (section.type) && !sectionLocation) location = true; else EmitError ("missing source code location");
	if (IsTyping (instruction.mnemonic))
		if (type) type = false; else if (!sectionType) sectionType = true;
		else if (declarations.empty () || declarations.back ()->mnemonic != Instruction::FUNC) EmitError ("invalid type declaration");
	if (IsTyped (instruction.mnemonic))
		if (!type && sectionType) type = true; else EmitError ("missing type declaration");

	if (IsDeclaring (instruction.mnemonic)) declarations.push_back (&instruction);
	if (instruction.mnemonic == Instruction::FIELD) if (declarations.empty () || declarations.back ()->mnemonic != Instruction::REC) EmitError ("invalid field declaration");
	if (instruction.mnemonic == Instruction::VALUE) if (declarations.empty () || declarations.back ()->mnemonic != Instruction::ENUM) EmitError ("invalid enumerator declaration");
	while (!declarations.empty () && &instruction - declarations.back () >= declarations.back ()->operand1.offset) declarations.pop_back ();

	return IsValid (instruction, section, platform);
}

void Context::Reset ()
{
	Assembly::Checker::Context::Reset ();
	if (!parsing && location && (!IsType (section.type) || sectionLocation)) EmitError ("missing source code location");
	if (!parsing && (type || IsType (section.type) && !sectionType)) EmitError ("missing type declaration");
	size = 0; declarations.clear (); location = type = false; sectionLocation = sectionType = inlined;
}

Context::Size Context::GetDisplacement (const Size) const
{
	return 1;
}

bool Context::GetLink (const Assembly::Expression&, Link& link) const
{
	assert (link.name.empty ());
	return false;
}

Context::Size Context::AssembleInstruction (std::istream& stream, const Link&)
{
	if (parsing) section.instructions.emplace_back ();
	auto& instruction = section.instructions[offset];
	return stream >> instruction && Check (instruction);
}

bool Context::GetDefinition (const Assembly::Identifier& identifier, Assembly::Expression& value) const
{
	if (identifier == "int") return value = Evaluate (platform.integer), true;
	if (identifier == "flt") return value = Evaluate (platform.float_), true;
	if (identifier == "intsize") return value = Evaluate (platform.integer.size), true;
	if (identifier == "fltsize") return value = Evaluate (platform.float_.size), true;
	if (identifier == "ptrsize") return value = Evaluate (platform.pointer.size), true;
	if (identifier == "funsize") return value = Evaluate (platform.function.size), true;
	if (identifier == "retsize") return value = Evaluate (platform.return_.size), true;
	if (identifier == "lnksize") return value = Evaluate (platform.link.size), true;
	if (identifier == "intalign") return value = Evaluate (platform.GetStackSize (platform.integer)), true;
	if (identifier == "fltalign") return value = Evaluate (platform.GetStackSize (platform.float_)), true;
	if (identifier == "ptralign") return value = Evaluate (platform.GetStackSize (platform.pointer)), true;
	if (identifier == "funalign") return value = Evaluate (platform.GetStackSize (platform.function)), true;
	if (identifier == "retalign") return value = Evaluate (platform.GetStackSize (platform.return_)), true;
	if (identifier == "stackdisp") return value = Evaluate (platform.stackDisplacement), true;
	if (identifier == "file") return value = {Assembly::Expression::String, *Assembly::Checker::Context::location->source}, true;
	if (identifier == "line") return value = {Assembly::Expression::Number, Assembly::Expression::Value (Assembly::Checker::Context::location->line)}, true;
	return Assembly::Checker::Context::GetDefinition (identifier, value);
}

Assembly::Expression Context::Evaluate (const Type::Size size)
{
	return {Assembly::Expression::Number, size};
}

Assembly::Expression Context::Evaluate (const Type& type)
{
	std::ostringstream stream; stream << type;
	return {Assembly::Expression::Identifier, stream.str ()};
}

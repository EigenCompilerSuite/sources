// Generic assembler
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

#include "asmassembler.hpp"
#include "asmcheckercontext.hpp"
#include "charset.hpp"
#include "error.hpp"
#include "format.hpp"
#include "utilities.hpp"

#include <algorithm>
#include <filesystem>
#include <fstream>

using namespace ECS;
using namespace Object;
using namespace Assembly;

using Context = class Assembler::Context : public Checker::Context
{
public:
	Context (const Assembler&, Binary&, Inlined);

private:
	const Assembler& assembler;
	Binary& binary;
	Endianness endianness;
	BitMode bitmode;
	State state;

	void ProcessAliasDirective (const Expression&);
	void ProcessAlignDirective (const Expression&);
	void ProcessBitModeDirective (const Expression&);
	void ProcessDataDirective (const Expression&, Size, const char*);
	void ProcessDataDirective (const Expressions&, Size, const char*);
	void ProcessEmbedDirective (const Expression&);
	void ProcessPadDirective (const Expression&);
	void ProcessRequireDirective (const Expression&);
	void ProcessReserveDirective (const Expression&);

	void EmitData (const Value, Size, const char*);

	void Reset () override;
	void Reserve (Size) override;
	Size GetDisplacement (Size) const override;
	void ProcessDirective (const Instruction&) override;
	bool GetLink (const Expression&, Link&) const override;
	bool GetValue (const Expression&, Value&) const override;
	Size AssembleInstruction (std::istream&, const Link&) override;
	bool GetDefinition (const Identifier&, Expression&) const override;
};

Assembler::Assembler (Diagnostics& d, Charset& c, const InstructionAlignment ia, const CodeAlignment ca, const DataAlignment da, const Endianness e, const BitMode bm) :
	Checker {d, c}, instructionAlignment {ia}, codeAlignment {ca}, dataAlignment {da}, endianness {e}, bitmode {bm}
{
	assert (IsPowerOfTwo (instructionAlignment)); assert (IsPowerOfTwo (codeAlignment)); assert (IsPowerOfTwo (dataAlignment)); assert (codeAlignment >= instructionAlignment);
}

void Assembler::Align (Binary& binary) const
{
	const auto alignment = IsCode (binary.type) ? codeAlignment : dataAlignment;
	if (!binary.fixed && alignment > binary.alignment) binary.alignment = alignment;
	assert ((binary.fixed ? binary.origin : binary.alignment) % alignment == 0);
}

void Assembler::Assemble (const Program& program, Binaries& binaries) const
{
	Batch (program.sections, [this, &binaries] (const Section& section) {Assemble (section, binaries);});
}

void Assembler::Assemble (const Instructions& instructions, Binary& binary) const
{
	Context {*this, binary, true}.Process (instructions);
}

void Assembler::Assemble (const Section& section, Binaries& binaries) const
{
	Context {*this, binaries.emplace_back (section), false}.Process (section.instructions); Align (binaries.back ());
}

Context::Context (const Assembler& a, Binary& b, const Inlined i) :
	Checker::Context {a, b, b.bytes.size (), a.instructionAlignment, IsCode (b.type) ? a.codeAlignment : a.dataAlignment, i},
	assembler {a}, binary {b}, endianness {assembler.endianness}, bitmode {assembler.bitmode}
{
}

void Context::ProcessDirective (const Instruction& instruction)
{
	switch (instruction.directive)
	{
	case Lexer::Alias:
		assert (instruction.operands.size () == 1);
		return ProcessAliasDirective (instruction.operands.front ());

	case Lexer::Reserve:
		assert (instruction.operands.size () == 1);
		return ProcessReserveDirective (instruction.operands.front ());

	case Lexer::Byte:
		return ProcessDataDirective (instruction.operands, 1, "byte");

	case Lexer::DByte:
		return ProcessDataDirective (instruction.operands, 2, "double byte");

	case Lexer::TByte:
		return ProcessDataDirective (instruction.operands, 3, "triple byte");

	case Lexer::QByte:
		return ProcessDataDirective (instruction.operands, 4, "quadruple byte");

	case Lexer::OByte:
		return ProcessDataDirective (instruction.operands, 8, "octuple byte");

	case Lexer::BitMode:
		if (!assembler.Validate (bitmode)) break;
		assert (instruction.operands.size () == 1);
		return ProcessBitModeDirective (instruction.operands.front ());

	case Lexer::Align:
		assert (instruction.operands.size () == 1);
		return ProcessAlignDirective (instruction.operands.front ());

	case Lexer::Pad:
		assert (instruction.operands.size () == 1);
		return ProcessPadDirective (instruction.operands.front ());

	case Lexer::Require:
		assert (instruction.operands.size () == 1);
		return ProcessRequireDirective (instruction.operands.front ());

	case Lexer::Embed:
		assert (instruction.operands.size () == 1);
		return ProcessEmbedDirective (instruction.operands.front ());

	case Lexer::Little:
		assert (instruction.operands.empty ());
		endianness = Endianness::Little;
		return;

	case Lexer::Big:
		assert (instruction.operands.empty ());
		endianness = Endianness::Big;
		return;
	}

	Checker::Context::ProcessDirective (instruction);
}

void Context::ProcessReserveDirective (const Expression& expression)
{
	Value value; if (!GetValue (expression, value) || value < 0 || value >= 0x10000000) EmitError ("invalid data reservation");
	Reserve (value);
}

void Context::ProcessPadDirective (const Expression& expression)
{
	Value value; if (!GetValue (expression, value) || value < 0 || value >= 0x10000000 || Size (value) < offset) EmitError ("invalid padding");
	Reserve (Size (value) - offset);
}

void Context::ProcessAlignDirective (const Expression& expression)
{
	Value value; if (!GetValue (expression, value) || value <= 0 || value >= 0x10000000 || !IsPowerOfTwo (value)) EmitError ("invalid data alignment");
	Reserve (ECS::Align (offset, Size (value)) - offset);
}

void Context::Reset ()
{
	Checker::Context::Reset (); state = 0;
	if (!inlined) endianness = assembler.endianness, bitmode = assembler.bitmode;
	else if (endianness != assembler.endianness) EmitError ("original endianness mode not restored");
	else if (bitmode != assembler.bitmode) EmitError ("original bit mode not restored");
}

void Context::Reserve (const Size size)
{
	Checker::Context::Reserve (size);
	binary.bytes.resize (std::max (offset, binary.bytes.size ()));
}

void Context::EmitData (const Value value, const Size size, const char*const type)
{
	if (!TruncatesPreserving<std::uint64_t> (value, size * 8) && !TruncatesPreserving<std::int64_t> (value, size * 8)) EmitError (Format ("invalid %0 value", type));
	Reserve (size); if (!parsing) Pattern {size, endianness}.Patch (value, {binary.bytes.data () + offset - size, size});
}

void Context::ProcessDataDirective (const Expressions& expressions, const Size size, const char*const type)
{
	assert (!expressions.empty ());
	Batch (expressions, [this, size, type] (const Expression& expression) {ProcessDataDirective (expression, size, type);});
}

void Context::ProcessDataDirective (const Expression& expression, const Size size, const char*const type)
{
	Value value; if (GetValue (expression, value)) return EmitData (value, size, type);
	String string; if (GetString (expression, string)) return Batch (string, [this, size, type] (const String::value_type character) {EmitData (charset.Encode (character), size, type);});
	Link link; if (!GetLink (expression, link)) EmitError ("invalid data value");
	Patch patch {offset, link.mode, link.displacement, link.scale}; Reserve (size);
	if (!parsing) patch.pattern = {size, endianness}, binary.AddLink (link.name, patch);
}

bool Context::GetLink (const Expression& expression, Link& link) const
{
	assert (link.name.empty ());

	switch (expression.model)
	{
	case Expression::Label:
	case Expression::Number:
	case Expression::Character:
	case Expression::String:
	case Expression::Identity:
	case Expression::NullaryOperation:
	case Expression::UnaryOperation:
	case Expression::PostfixOperation:
		return false;

	case Expression::Address:
		link.name = expression.string;
		return true;

	case Expression::Identifier:
	{
		Expression definition;
		return GetDefinition (expression.string, definition) && GetLink (definition, link);
	}

	case Expression::BinaryOperation:
	{
		assert (expression.operands.size () == 2);
		if (!GetLink (expression.operands.front (), link)) return false;
		Value value; if (!GetValue (expression.operands.back (), value) || Patch::Displacement (value) != value) EmitError ("invalid address modifier");
		if (expression.operation == Lexer::Plus && !link.scale) return link.displacement += value, true;
		if (expression.operation == Lexer::Minus && !link.scale) return link.displacement -= value, true;
		if (expression.operation == Lexer::RightShift && value >= 0) return link.scale += value, true;
		return false;
	}

	case Expression::FunctionalOperation:
		assert (expression.operands.size () == 1);
		if (!GetLink (expression.operands.front (), link) || link.mode != Patch::Absolute || link.displacement || link.scale) return false;
		link.mode = GetMode (expression.operation);
		return link.mode != Patch::Absolute;

	case Expression::Parenthesized:
		return IsParenthesized (expression) && GetLink (expression.operands.front (), link);

	default:
		assert (Expression::Unreachable);
	}
}

bool Context::GetValue (const Expression& expression, Value& value) const
{
	switch (expression.model)
	{
	case Expression::Label:
	case Expression::Number:
	case Expression::String:
	case Expression::Address:
	case Expression::Identity:
	case Expression::Identifier:
	case Expression::UnaryOperation:
	case Expression::BinaryOperation:
	case Expression::PostfixOperation:
	case Expression::FunctionalOperation:
	case Expression::Parenthesized:
		return Checker::Context::GetValue (expression, value);

	case Expression::Character:
	{
		const auto size = expression.string.size (); assert (size >= 1 && size <= 8); value = 0;
		for (String::size_type index = 0; index != size; ++index) value = value * 0x100 + charset.Encode (expression.string[endianness == Endianness::Big ? index : size - index - 1]);
		return true;
	}

	case Expression::NullaryOperation:
		assert (expression.operands.empty ());

		switch (expression.operation) {
		case Lexer::BitMode: return value = bitmode, assembler.Validate (bitmode);
		case Lexer::Little: return value = endianness == Endianness::Little, true;
		case Lexer::Big: return value = endianness == Endianness::Big, true;
		default: return Checker::Context::GetValue (expression, value);
		}

	default:
		assert (Expression::Unreachable);
	}
}

void Context::ProcessBitModeDirective (const Expression& expression)
{
	Value value; if (!GetValue (expression, value) || value <= 0 || value > 256 || !assembler.Validate (value)) EmitError ("invalid bit mode");
	bitmode = value; state = 0;
}

void Context::ProcessAliasDirective (const Expression& expression)
{
	Identifier identifier; if (!GetIdentifier (expression, identifier) || identifier == binary.name) EmitError ("invalid alias name");
	if (std::find_if (binary.aliases.begin (), binary.aliases.end (), [&identifier] (const Alias& alias) {return alias.name == identifier;}) != binary.aliases.end ()) EmitError ("duplicated alias name");
	if (!parsing) binary.aliases.emplace_back (identifier, offset);
}

void Context::ProcessRequireDirective (const Expression& expression)
{
	Identifier identifier; if (!GetIdentifier (expression, identifier)) EmitError ("invalid name requirement");
	if (!parsing && !binary.AddRequirement (identifier)) EmitError ("duplicated name requirement");
}

void Context::ProcessEmbedDirective (const Expression& expression)
{
	String string; if (!GetString (expression, string)) EmitError ("invalid filename");
	std::ifstream file; if (std::error_code error; !std::filesystem::is_directory (string, error)) file.open (string, file.binary | file.ate);
	if (!file.is_open ()) EmitError (Format ("failed to open binary file '%0'", string));
	const Size size = file.tellg (); if (file) Reserve (size);
	if (!parsing && file.seekg (0)) file.read (reinterpret_cast<char*> (binary.bytes.data () + offset - size), size);
	if (!file) EmitError (Format ("failed to read binary file '%0'", string));
}

Context::Size Context::GetDisplacement (const Size size) const
{
	return assembler.GetDisplacement (size, bitmode);
}

Context::Size Context::AssembleInstruction (std::istream& stream, const Link& link)
{
	if (parsing) return assembler.ParseInstruction (stream, bitmode, state); Patch patch {offset, link.mode, link.displacement, link.scale};
	const auto size = assembler.EmitInstruction (stream, bitmode, endianness, {binary.bytes.data () + offset, binary.bytes.size () - offset}, patch, state);
	if (!link.name.empty ()) if (IsEmpty (patch.pattern)) EmitError ("invalid address operand"); else binary.AddLink (link.name, patch);
	return size;
}

bool Context::GetDefinition (const Identifier& identifier, Expression& value) const
{
	return assembler.GetDefinition (identifier, value) || Checker::Context::GetDefinition (identifier, value);
}

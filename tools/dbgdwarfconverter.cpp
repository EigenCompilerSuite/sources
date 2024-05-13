// DWARF debugging information converter
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

#include "dbgconvertercontext.hpp"
#include "dbgdwarfconverter.hpp"
#include "format.hpp"
#include "ieee.hpp"
#include "utilities.hpp"

#include <cassert>
#include <filesystem>
#include <map>

using namespace ECS;
using namespace Debugging;

using Context = class DWARFConverter::Context : public Converter::Context
{
public:
	Context (const Converter&, const Information&, const Source&, Object::Binaries&);

	void Convert ();

private:
	enum {LineBase = -4, LineRange = 12, OpcodeBase = 13};
	enum class Attribute {Sentinel = 0x0, Location = 0x2, Name = 0x3, ByteSize = 0xb, DataBitSize = 0xd, StatementList = 0x10, LowPC = 0x11, HighPC = 0x12, CompDir = 0x1b, ConstantValue = 0x1c, LowerBound = 0x22, Count = 0x37, DataMemberLocation = 0x38, DeclarationColumn = 0x39, DeclarationFile = 0x3a, DeclarationLine = 0x3b, Encoding = 0x3e, External = 0x3f, Type = 0x49, DataBitOffset = 0x6b};
	enum class BaseType {Float = 0x4, Signed = 0x5, Unsigned = 0x7};
	enum class ExtendedOpcode {EndSequence = 0x1, SetAddress = 0x2};
	enum class Form {Sentinel = 0x0, Address = 0x1, String = 0x8, Data1 = 0xb, SignedData = 0xd, UnsignedData = 0xf, ReferenceAddress = 0x10, SectionOffset = 0x17, ExpressionLocation = 0x18, FlagPresent = 0x19};
	enum class Opcode {Copy = 0x1, AdvancePC = 0x2, AdvanceLine = 0x3, SetFile = 0x4, SetColumn = 0x5};
	enum class Operation {Address = 0x3, Register = 0x90, RegisterBase = 0x92};
	enum class Tag {ArrayType = 0x1, EnumerationType = 0x4, FormalParameter = 0x5, LexicalBlock = 0xb, Member = 0xd, PointerType = 0xf, ReferenceType = 0x10, CompileUnit = 0x11, StructureType = 0x13, SubroutineType = 0x15, TypeDefinition = 0x16, Inheritance = 0x1c, SubrangeType = 0x21, BaseType = 0x24, Constant = 0x27, Enumerator = 0x28, Subprogram = 0x2e, Variable = 0x34, UnspecifiedType = 0x3b};

	struct LineNumberProgram;
	struct Platform;

	using Abbreviation = const char*;
	using Directory = std::filesystem::path;
	using Platforms = std::map<Name, Platform>;
	using RegisterName = unsigned;
	using Registers = std::map<Register, RegisterName>;

	const Platform& platform;
	const Binary::Name compilationUnit, lineNumberProgram;

	Binary* abbreviation = nullptr;
	std::vector<Abbreviation> abbreviations;

	using Converter::Context::Emit;
	void Emit (Abbreviation, const Binary::Name&);
	void Emit (Attribute, Form);
	void Emit (Attribute, Form, const Binary::Name&, Patch::Mode, Patch::Displacement);
	void Emit (Attribute, Value::Signed);
	void Emit (const Breakpoint&, LineNumberProgram&);
	void Emit (const Entry&);
	void Emit (const Entry&, const Block&);
	void Emit (const Entry&, const Lifetime&);
	void Emit (const Entry&, LineNumberProgram&);
	void Emit (const Enumerator&);
	void Emit (const Field&);
	void Emit (const Offset, const Location&, LineNumberProgram&);
	void Emit (const Symbol&);
	void Emit (const Type&, const Entry*);
	void Emit (ExtendedOpcode);
	void Emit (ExtendedOpcode, const Binary::Name&);
	void Emit (Opcode);
	void Emit (Operation);

	void EmitEntry (Abbreviation, const Binary::Name&, Tag, bool);
	void EmitEntry (Abbreviation, Tag, bool);
	void EmitEntry (Abbreviation, Tag, bool, const Entry*);

	void EmitAttribute (BaseType);
	void EmitAttribute (const Directory&);
	void EmitAttribute (const Entry&);
	void EmitAttribute (const Location&);
	void EmitAttribute (const Name&);
	void EmitAttribute (const Symbol&);
	void EmitAttribute (const Type&);
	void EmitAttribute (const Value&);
	void EmitAttribute (Debugging::Size);

	void EmitLocation (const Binary::Name&, Size);
	void EmitLocation (const Register&);
	void EmitLocation (const Register&, Symbol::Displacement);

	void EmitAttributeSentinel ();
	void EmitCompilationUnit ();
	void EmitLineNumberProgram ();
	void EmitEntrySentinel ();

	void Encode (Value::Signed);
	void Encode (Value::Unsigned);

	RegisterName Lookup (const Register&) const;
	const Platform& Lookup (const Target&) const;

	bool IsEmpty (const Block& block) const;
	bool IsParameter (const Symbol& symbol) const;

	static const Binary::Name DebugAbbreviation;
	static const Binary::Name DebugInformation;
	static const Binary::Name DebugLine;

	static const Platforms platforms;
	static const Registers amd32, amd64, arm32, arm64, xtensa;
};

struct Context::Platform
{
	const Registers& registers;
	RegisterName framePointer;
};

struct Context::LineNumberProgram
{
	Value::Unsigned address = 0, file = 1, line = 1, column = 0;
};

const Object::Binary::Name Context::DebugAbbreviation = "_debug_abbrev_";
const Object::Binary::Name Context::DebugInformation = "_debug_info_";
const Object::Binary::Name Context::DebugLine = "_debug_line_";

const Context::Platforms Context::platforms {
	{"amd32", {amd32, 5}},
	{"amd64", {amd64, 6}},
	{"arma32", {arm32, 11}},
	{"arma64", {arm64, 29}},
	{"armt32", {arm32, 11}},
	{"xtensa", {arm32, 15}},
};

const Context::Registers Context::amd32 {
	{"al", 0}, {"cl", 1}, {"dl", 2}, {"bl", 3},
	{"ax", 0}, {"cx", 1}, {"dx", 2}, {"bx", 3}, {"sp", 4}, {"bp", 5}, {"si", 6}, {"di", 7},
	{"eax", 0}, {"ecx", 1}, {"edx", 2}, {"ebx", 3}, {"esp", 4}, {"ebp", 5}, {"esi", 6}, {"edi", 7},
	{"st0", 11}, {"st1", 12}, {"st2", 13}, {"st3", 14}, {"st4", 15}, {"st5", 16}, {"st6", 17}, {"st7", 18},
	{"xmm0", 21}, {"xmm1", 22}, {"xmm2", 23}, {"xmm3", 24}, {"xmm4", 25}, {"xmm5", 26}, {"xmm6", 27}, {"xmm7", 28},
	{"mmx0", 29}, {"mmx1", 30}, {"mmx2", 31}, {"mmx3", 32}, {"mmx4", 33}, {"mmx5", 34}, {"mmx6", 35}, {"mmx7", 36},
};

const Context::Registers Context::amd64 {
	{"al", 0}, {"dl", 1}, {"cl", 2}, {"bl", 3}, {"sil", 4}, {"dil", 5}, {"bpl", 6}, {"spl", 7}, {"r8b", 8}, {"r9b", 9}, {"r10b", 10}, {"r11b", 11}, {"r12b", 12}, {"r13b", 13}, {"r14b", 14}, {"r15b", 15},
	{"ax", 0}, {"dx", 1}, {"cx", 2}, {"bx", 3}, {"si", 4}, {"di", 5}, {"bp", 6}, {"sp", 7}, {"r8w", 8}, {"r9w", 9}, {"r10w", 10}, {"r11w", 11}, {"r12w", 12}, {"r13w", 13}, {"r14w", 14}, {"r15w", 15},
	{"eax", 0}, {"edx", 1}, {"ecx", 2}, {"ebx", 3}, {"esi", 4}, {"edi", 5}, {"ebp", 6}, {"esp", 7}, {"r8d", 8}, {"r9d", 9}, {"r10d", 10}, {"r11d", 11}, {"r12d", 12}, {"r13d", 13}, {"r14d", 14}, {"r15d", 15},
	{"rax", 0}, {"rdx", 1}, {"rcx", 2}, {"rbx", 3}, {"rsi", 4}, {"rdi", 5}, {"rbp", 6}, {"rsp", 7}, {"r8", 8}, {"r9", 9}, {"r10", 10}, {"r11", 11}, {"r12", 12}, {"r13", 13}, {"r14", 14}, {"r15", 15},
	{"mmx0", 17}, {"mmx1", 18}, {"mmx2", 19}, {"mmx3", 20}, {"mmx4", 21}, {"mmx5", 22}, {"mmx6", 23}, {"mmx7", 24}, {"mmx8", 25}, {"mmx9", 26}, {"mmx10", 27}, {"mmx11", 28}, {"mmx12", 29}, {"mmx13", 30}, {"mmx14", 31}, {"mmx15", 32},
	{"st0", 33}, {"st1", 34}, {"st2", 35}, {"st3", 36}, {"st4", 37}, {"st5", 38}, {"st6", 39}, {"st7", 40},
	{"xmm0", 41}, {"xmm1", 42}, {"xmm2", 43}, {"xmm3", 44}, {"xmm4", 45}, {"xmm5", 46}, {"xmm6", 47}, {"xmm7", 48},
};

const Context::Registers Context::arm32 {
	{"r0", 0}, {"r1", 1}, {"r2", 2}, {"r3", 3}, {"r4", 4}, {"r5", 5}, {"r6", 6}, {"r7", 7}, {"r8", 8}, {"r9", 9}, {"r10", 10}, {"r11", 11}, {"r12", 12}, {"r13", 13}, {"r14", 14}, {"r15", 15}, {"sp", 13}, {"lr", 14}, {"pc", 15},
	{"s0", 64}, {"s1", 65}, {"s2", 66}, {"s3", 67}, {"s4", 68}, {"s5", 69}, {"s6", 70}, {"s7", 71}, {"s8", 72}, {"s9", 73}, {"s10", 74}, {"s11", 75}, {"s12", 76}, {"s13", 77}, {"s14", 78}, {"s15", 79},
	{"s16", 80}, {"s17", 81}, {"s18", 82}, {"s19", 83}, {"s20", 84}, {"s21", 85}, {"s22", 86}, {"s23", 87}, {"s24", 88}, {"s25", 89}, {"s26", 90}, {"s27", 91}, {"s28", 92}, {"s29", 93}, {"s30", 94}, {"s31", 95},
	{"d0", 256}, {"d1", 257}, {"d2", 258}, {"d3", 259}, {"d4", 260}, {"d5", 261}, {"d6", 262}, {"d7", 263}, {"d8", 264}, {"d9", 265}, {"d10", 266}, {"d11", 267}, {"d12", 268}, {"d13", 269}, {"d14", 270}, {"d15", 271},
	{"d16", 272}, {"d17", 273}, {"d18", 274}, {"d19", 275}, {"d20", 276}, {"d21", 277}, {"d22", 278}, {"d23", 279}, {"d24", 280}, {"d25", 281}, {"d26", 282}, {"d27", 283}, {"d28", 284}, {"d29", 285}, {"d30", 286}, {"d31", 287},
};

const Context::Registers Context::arm64 {
	{"b0", 0}, {"b1", 1}, {"b2", 2}, {"b3", 3}, {"b4", 4}, {"b5", 5}, {"b6", 6}, {"b7", 7}, {"b8", 8}, {"b9", 9}, {"b10", 10}, {"b11", 11}, {"b12", 12}, {"b13", 13}, {"b14", 14}, {"b15", 15},
	{"b16", 16}, {"b17", 17}, {"b18", 18}, {"b19", 19}, {"b20", 20}, {"b21", 21}, {"b22", 22}, {"b23", 23}, {"b24", 24}, {"b25", 25}, {"b26", 26}, {"b27", 27}, {"b28", 28}, {"b29", 29}, {"b30", 30},
	{"h0", 0}, {"h1", 1}, {"h2", 2}, {"h3", 3}, {"h4", 4}, {"h5", 5}, {"h6", 6}, {"h7", 7}, {"h8", 8}, {"h9", 9}, {"h10", 10}, {"h11", 11}, {"h12", 12}, {"h13", 13}, {"h14", 14}, {"h15", 15},
	{"h16", 16}, {"h17", 17}, {"h18", 18}, {"h19", 19}, {"h20", 20}, {"h21", 21}, {"h22", 22}, {"h23", 23}, {"h24", 24}, {"h25", 25}, {"h26", 26}, {"h27", 27}, {"h28", 28}, {"h29", 29}, {"h30", 30},
	{"w0", 0}, {"w1", 1}, {"w2", 2}, {"w3", 3}, {"w4", 4}, {"w5", 5}, {"w6", 6}, {"w7", 7}, {"w8", 8}, {"w9", 9}, {"w10", 10}, {"w11", 11}, {"w12", 12}, {"w13", 13}, {"w14", 14}, {"w15", 15},
	{"w16", 16}, {"w17", 17}, {"w18", 18}, {"w19", 19}, {"w20", 20}, {"w21", 21}, {"w22", 22}, {"w23", 23}, {"w24", 24}, {"w25", 25}, {"w26", 26}, {"w27", 27}, {"w28", 28}, {"w29", 29}, {"w30", 30}, {"wsp", 31},
	{"x0", 0}, {"x1", 1}, {"x2", 2}, {"x3", 3}, {"x4", 4}, {"x5", 5}, {"x6", 6}, {"x7", 7}, {"x8", 8}, {"x9", 9}, {"x10", 10}, {"x11", 11}, {"x12", 12}, {"x13", 13}, {"x14", 14}, {"x15", 15},
	{"x16", 16}, {"x17", 17}, {"x18", 18}, {"x19", 19}, {"x20", 20}, {"x21", 21}, {"x22", 22}, {"x23", 23}, {"x24", 24}, {"x25", 25}, {"x26", 26}, {"x27", 27}, {"x28", 28}, {"x29", 29}, {"x30", 30}, {"sp", 31},
	{"s0", 64}, {"s1", 65}, {"s2", 66}, {"s3", 67}, {"s4", 68}, {"s5", 69}, {"s6", 70}, {"s7", 71}, {"s8", 72}, {"s9", 73}, {"s10", 74}, {"s11", 75}, {"s12", 76}, {"s13", 77}, {"s14", 78}, {"s15", 79},
	{"s16", 80}, {"s17", 81}, {"s18", 82}, {"s19", 83}, {"s20", 84}, {"s21", 85}, {"s22", 86}, {"s23", 87}, {"s24", 88}, {"s25", 89}, {"s26", 90}, {"s27", 91}, {"s28", 92}, {"s29", 93}, {"s30", 94},
	{"d0", 64}, {"d1", 65}, {"d2", 66}, {"d3", 67}, {"d4", 68}, {"d5", 69}, {"d6", 70}, {"d7", 71}, {"d8", 72}, {"d9", 73}, {"d10", 74}, {"d11", 75}, {"d12", 76}, {"d13", 77}, {"d14", 78}, {"d15", 79},
	{"d16", 80}, {"d17", 81}, {"d18", 82}, {"d19", 83}, {"d20", 84}, {"d21", 85}, {"d22", 86}, {"d23", 87}, {"d24", 88}, {"d25", 89}, {"d26", 90}, {"d27", 91}, {"d28", 92}, {"d29", 93}, {"d30", 94},
};

const Context::Registers Context::xtensa {
	{"a0", 0}, {"a1", 1}, {"a2", 2}, {"a3", 3}, {"a4", 4}, {"a5", 5}, {"a6", 6}, {"a7", 7}, {"a8", 8}, {"a9", 9}, {"a10", 10}, {"a11", 11}, {"a12", 12}, {"a13", 13}, {"a14", 14}, {"a15", 15}, {"sp", 1},
};

void DWARFConverter::Process (const Information& information, const Source& source, Object::Binaries& binaries) const
{
	Context {*this, information, source, binaries}.Convert ();
}

Context::Context (const Converter& c, const Information& i, const Source& s, Object::Binaries& b) :
	Converter::Context {c, i, s, b}, platform {Lookup (i.target)}, compilationUnit {DebugInformation + "unit_" + information.sources.front () + '_'}, lineNumberProgram {DebugLine + "program_" + information.sources.front ()}
{
	assert (!information.sources.empty ());
}

void Context::Convert ()
{
	EmitCompilationUnit ();
	EmitLineNumberProgram ();
}

void Context::EmitCompilationUnit ()
{
	Begin (compilationUnit + "header", true);
	Group (DebugInformation + "section");
	Require (DebugInformation + "header");
	Emit (compilationUnit + "sentinel", Patch::Relative, -3, QByte);
	Emit (4, DByte); Emit (0, QByte); Emit (information.target.pointer, Byte);

	EmitEntry ("compilation", Tag::CompileUnit, true);
	EmitAttribute (information.sources.front ());
	std::error_code error; EmitAttribute (std::filesystem::current_path (error));
	Emit (Attribute::StatementList, Form::SectionOffset, lineNumberProgram, Patch::Position, 0);
	EmitAttributeSentinel ();

	for (auto& entry: information.entries) Emit (entry);

	Begin (compilationUnit + "sentinel"); Group (DebugInformation + "section"); EmitEntrySentinel ();
	Begin (DebugAbbreviation + "sentinel"); Group (DebugAbbreviation + "section_end"); Require (DebugAbbreviation + "header"); EmitEntrySentinel ();
}

void Context::Emit (const Entry& entry)
{
	switch (entry.model)
	{
	case Entry::Code:
		EmitEntry ("code", entry.name, Tag::Subprogram, true);
		EmitAttribute (entry);
		EmitAttribute (entry.type);
		Emit (Attribute::LowPC, Form::Address, entry.name, Patch::Absolute, 0);
		Emit (Attribute::HighPC, Form::Address, entry.name, Patch::Extent, 0);
		Emit (Attribute::External, Form::FlagPresent);
		EmitAttributeSentinel ();
		for (auto& symbol: entry.symbols) if (IsParameter (symbol)) Emit (symbol);
		Emit (entry, Block {entry});
		EmitEntrySentinel ();
		break;

	case Entry::Data:
		EmitEntry ("data", entry.name, Tag::Variable, false);
		EmitAttribute (entry);
		EmitAttribute (entry.type);
		EmitLocation (entry.name, Size (information.target.pointer));
		Emit (Attribute::External, Form::FlagPresent);
		EmitAttributeSentinel ();
		break;

	case Entry::Type:
		Emit ("type", entry.name);
		Emit (entry.type, &entry);
		break;

	default:
		assert (Entry::Unreachable);
	}
}

void Context::Emit (const Entry& entry, const Block& block)
{
	for (auto symbol: block.symbols) if (!IsParameter (*symbol)) Emit (*symbol);
	for (auto& block_: block.blocks) if (IsEmpty (block_)) Emit (entry, block_); else Emit (entry, block_.lifetime), Emit (entry, block_), EmitEntrySentinel ();
}

void Context::Emit (const Entry& entry, const Lifetime& lifetime)
{
	EmitEntry ("block", Tag::LexicalBlock, true);
	Emit (Attribute::LowPC, Form::Address, entry.name, Patch::Absolute, lifetime.begin);
	Emit (Attribute::HighPC, Form::Address, entry.name, Patch::Absolute, lifetime.end);
	EmitAttributeSentinel ();
}

void Context::Emit (const Symbol& symbol)
{
	switch (symbol.model)
	{
	case Symbol::Constant:
		if (IsResult (symbol)) break;
		EmitEntry ("constant", Tag::Constant, false);
		EmitAttribute (symbol);
		EmitAttribute (symbol.value);
		EmitAttributeSentinel ();
		break;

	case Symbol::Register:
		if (IsResult (symbol)) break;
		EmitEntry ("register", Tag::Variable, false);
		EmitAttribute (symbol);
		EmitLocation (symbol.register_);
		EmitAttributeSentinel ();
		break;

	case Symbol::Variable:
		if (IsResult (symbol)) break;
		if (IsParameter (symbol)) EmitEntry ("parameter", Tag::FormalParameter, false); else EmitEntry ("variable", Tag::Variable, false);
		EmitAttribute (symbol);
		if (IsAlias (symbol)) EmitLocation (symbol.register_, Size (information.target.pointer)); else EmitLocation (symbol.register_, symbol.displacement);
		EmitAttributeSentinel ();
		break;

	default:
		assert (Symbol::Unreachable);
	}
}

void Context::EmitAttribute (const Value& value)
{
	switch (value.model)
	{
	case Type::Signed:
		Emit (Attribute::ConstantValue, value.signed_);
		break;

	case Type::Unsigned:
		Emit (Attribute::ConstantValue, value.unsigned_);
		break;

	case Type::Float:
		Emit (Attribute::ConstantValue, IEEE::SinglePrecision::Encode (value.float_));
		break;

	default:
		assert (Type::Unreachable);
	}
}

void Context::EmitAttribute (const Type& type)
{
	const auto name = DebugInformation + "type_" + (IsName (type) ? type.name : Format ("(%0)", type)); Emit (Attribute::Type, Form::ReferenceAddress, name, Patch::Position, 0);
	if (IsName (type)) if (IsDefined (name)) return; else for (auto& entry: information.entries) if (IsType (entry) && entry.name == type.name) return;
	const auto previous = current, abbreviation = this->abbreviation; Begin (name, false, IsName (type)); Group (DebugInformation + "section"); Emit (type, nullptr); current = previous; this->abbreviation = abbreviation;
}

void Context::Emit (const Type& type, const Entry*const entry)
{
	switch (type.model)
	{
	case Type::Void:
		EmitEntry ("alias_named_void_type", Tag::UnspecifiedType, false, entry);
		EmitAttributeSentinel ();
		break;

	case Type::Name:
		EmitEntry ("alias_named_type", entry ? Tag::TypeDefinition : Tag::StructureType, false, entry);
		if (entry) EmitAttribute (type); else EmitAttribute (type.name);
		EmitAttributeSentinel ();
		break;

	case Type::Signed:
	case Type::Unsigned:
	case Type::Float:
		EmitEntry ("alias_named_base_type", Tag::BaseType, false, entry);
		EmitAttribute (type.model == Type::Signed ? BaseType::Signed : type.model == Type::Unsigned ? BaseType::Unsigned : BaseType::Float);
		EmitAttribute (type.size);
		EmitAttributeSentinel ();
		break;

	case Type::Array:
		assert (type.subtypes.size () == 1);
		EmitEntry ("alias_named_array_type", Tag::ArrayType, true, entry);
		EmitAttribute (type.subtypes.front ());
		EmitAttributeSentinel ();

		if (type.size) EmitEntry ("array_range", Tag::SubrangeType, false), Emit (Attribute::Count, type.size); else EmitEntry ("open_array_range", Tag::SubrangeType, false);
		Emit (Attribute::LowerBound, type.index);
		EmitAttributeSentinel ();
		EmitEntrySentinel ();
		break;

	case Type::Record:
		EmitEntry ("alias_named_record_type", Tag::StructureType, true, entry);
		EmitAttribute (type.size);
		EmitAttributeSentinel ();
		for (auto& field: type.fields) Emit (field);
		EmitEntrySentinel ();
		break;

	case Type::Pointer:
		assert (type.subtypes.size () == 1);
		EmitEntry ("alias_named_pointer_type", Tag::PointerType, false, entry);
		EmitAttribute (information.target.pointer);
		EmitAttribute (type.subtypes.front ());
		EmitAttributeSentinel ();
		break;

	case Type::Reference:
		assert (type.subtypes.size () == 1);
		EmitEntry ("alias_named_reference_type", Tag::ReferenceType, false, entry);
		EmitAttribute (information.target.pointer);
		EmitAttribute (type.subtypes.front ());
		EmitAttributeSentinel ();
		break;

	case Type::Function:
		assert (type.subtypes.size () >= 1);
		EmitEntry ("alias_named_function_type", Tag::SubroutineType, true, entry);
		EmitAttribute (type.subtypes.front ());
		EmitAttributeSentinel ();
		for (auto& subtype: type.subtypes) if (!IsFirst (subtype, type.subtypes)) EmitEntry ("parameter_type", Tag::FormalParameter, false), EmitAttribute (subtype), EmitAttributeSentinel ();
		EmitEntrySentinel ();
		break;

	case Type::Enumeration:
		assert (type.subtypes.size () == 1);
		EmitEntry ("alias_named_enumeration_type", Tag::EnumerationType, true, entry);
		EmitAttribute (type.subtypes.front ());
		EmitAttributeSentinel ();
		for (auto& enumerator: type.enumerators) Emit (enumerator);
		EmitEntrySentinel ();
		break;

	default:
		assert (Type::Unreachable);
	}
}

void Context::Emit (const Field& field)
{
	EmitEntry (IsBase (field) ? "base" : IsBitField (field) ? "bit_field" : IsValid (field.location) ? "field" : "member", IsBase (field) ? Tag::Inheritance : Tag::Member, false);
	if (!IsBase (field)) EmitAttribute (field.name);
	if (IsValid (field.location)) EmitAttribute (field.location);
	EmitAttribute (field.type);
	Emit (Attribute::DataMemberLocation, field.offset);
	if (IsBitField (field)) Emit (Attribute::DataBitOffset, CountTrailingZeros (field.mask)), Emit (Attribute::DataBitSize, CountOnes (field.mask));
	EmitAttributeSentinel ();
}

void Context::Emit (const Enumerator& enumerator)
{
	EmitEntry (IsValid (enumerator.location) ? "enumerator" : "value", Tag::Enumerator, false);
	EmitAttribute (enumerator.name);
	if (IsValid (enumerator.location)) EmitAttribute (enumerator.location);
	EmitAttribute (enumerator.value);
	EmitAttributeSentinel ();
}

void Context::Emit (const Abbreviation abbreviation, const Binary::Name& name)
{
	assert (abbreviation); Begin (DebugInformation + abbreviation + '_' + name, true); Group (DebugInformation + "section");
}

void Context::EmitEntry (const Abbreviation abbreviation, const Tag tag, const bool hasChildren)
{
	assert (abbreviation); const auto name = DebugAbbreviation + abbreviation; Emit (name, Patch::Index, 1, Byte);
	if (!InsertUnique (abbreviation, abbreviations)) return void (this->abbreviation = nullptr);
	const auto previous = current; Begin (name); Group (DebugAbbreviation + "section"); Require (DebugAbbreviation + "sentinel");
	Emit (name, Patch::Index, 1, Byte); Emit (Value::Unsigned (tag), Byte); Emit (hasChildren, Byte); this->abbreviation = current; current = previous;
}

void Context::EmitEntry (const Abbreviation abbreviation, const Tag tag, const bool hasChildren, const Entry* entry)
{
	if (!entry) EmitEntry (abbreviation + 12, tag, hasChildren);
	else if (!IsValid (entry->location)) EmitEntry (abbreviation + 6, tag, hasChildren), EmitAttribute (entry->name);
	else EmitEntry (abbreviation, tag, hasChildren), EmitAttribute (*entry);
}

void Context::EmitEntry (const Abbreviation abbreviation, const Binary::Name& name, const Tag tag, const bool hasChildren)
{
	Emit (abbreviation, name); EmitEntry (abbreviation, tag, hasChildren);
}

void Context::EmitEntrySentinel ()
{
	Emit (0, Byte);
}

void Context::Emit (const Attribute attribute, const Form form)
{
	if (!abbreviation) return; const auto previous = current; current = abbreviation;
	Emit (Value::Unsigned (attribute), Byte); Emit (Value::Unsigned (form), Byte); abbreviation = current; current = previous;
}

void Context::Emit (const Attribute attribute, const Form form, const Binary::Name& name, const Patch::Mode mode, const Patch::Displacement displacement)
{
	Emit (attribute, form); Emit (name, mode, displacement, form == Form::Address ? Size (information.target.pointer) : QByte);
}

void Context::Emit (const Attribute attribute, const Value::Signed value)
{
	Emit (attribute, Form::SignedData); Encode (value);
}

void Context::EmitAttribute (const Debugging::Size size)
{
	Emit (Attribute::ByteSize, Form::UnsignedData); Encode (Value::Unsigned (size));
}

void Context::EmitAttribute (const BaseType baseType)
{
	Emit (Attribute::Encoding, Form::Data1); Emit (Value::Unsigned (baseType), Byte);
}

void Context::EmitAttribute (const Name& string)
{
	Emit (Attribute::Name, Form::String); Emit (string, Byte); Emit (0, Byte);
}

void Context::EmitAttribute (const Directory& directory)
{
	Emit (Attribute::CompDir, Form::String); Emit (directory.string (), Byte); Emit (0, Byte);
}

void Context::EmitAttribute (const Location& location)
{
	assert (IsValid (location));
	Emit (Attribute::DeclarationFile, location.index + 1);
	Emit (Attribute::DeclarationLine, location.line);
	Emit (Attribute::DeclarationColumn, location.column);
}

void Context::EmitAttribute (const Symbol& symbol)
{
	EmitAttribute (symbol.name);
	EmitAttribute (symbol.location);
	EmitAttribute (symbol.type);
}

void Context::EmitAttribute (const Entry& entry)
{
	EmitAttribute (entry.name);
	EmitAttribute (entry.location);
}

void Context::EmitAttributeSentinel ()
{
	Emit (Attribute::Sentinel, Form::Sentinel);
}

void Context::Emit (const Operation operation)
{
	Emit (Value::Unsigned (operation), Byte);
}

void Context::EmitLineNumberProgram ()
{
	static const ECS::Byte opcodes[OpcodeBase - 1] {0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1};

	Begin (lineNumberProgram);
	Group (DebugLine + "section"); Require (DebugLine + "header");
	const auto unitLength = Emit (QByte); Emit (4, DByte);
	const auto headerLength = Emit (QByte); Emit (1, Byte); Emit (1, Byte); Emit (1, Byte);
	Emit (LineBase, Byte); Emit (LineRange, Byte); Emit (OpcodeBase, Byte);
	for (auto length: opcodes) Emit (length, Byte); Emit (0, Byte);
	for (auto& source: information.sources) Emit (source, Byte), Emit (0, QByte); Emit (0, Byte);
	Fixup (headerLength, QByte);

	LineNumberProgram program;
	for (auto& entry: information.entries) Emit (entry, program);
	Emit (ExtendedOpcode::EndSequence); Fixup (unitLength, QByte);
}

void Context::Emit (const Entry& entry, LineNumberProgram& program)
{
	if (!IsCode (entry)) return;
	Emit (ExtendedOpcode::SetAddress, entry.name);
	program.address = 0; Emit (0, entry.location, program);
	for (auto& breakpoint: entry.breakpoints) Emit (breakpoint, program);
	Emit (Opcode::AdvancePC); Encode (entry.size - program.address);
}

void Context::Emit (const Breakpoint& breakpoint, LineNumberProgram& program)
{
	Emit (breakpoint.offset, breakpoint.location, program);
}

void Context::Emit (const Offset offset, const Location& location, LineNumberProgram& program)
{
	const auto file = location.index + 1;
	const auto addressDelta = offset - program.address;
	const auto lineDelta = Value::Signed (location.line) - Value::Signed (program.line);
	const auto column = file == program.file && !lineDelta ? Value::Unsigned (location.column) : 0;
	if (file != program.file) Emit (Opcode::SetFile), Encode (program.file = file);
	if (column != program.column) Emit (Opcode::SetColumn), Encode (program.column = column);
	program.address += addressDelta; program.line += lineDelta;
	const auto opcode = addressDelta * LineRange + (lineDelta - LineBase) % LineRange + OpcodeBase;
	if (lineDelta >= LineBase && lineDelta < LineBase + LineRange && opcode < 255) return Emit (Opcode (opcode));
	if (addressDelta) Emit (Opcode::AdvancePC), Encode (addressDelta); if (lineDelta) Emit (Opcode::AdvanceLine), Encode (lineDelta); Emit (Opcode::Copy);
}

void Context::Emit (const Opcode opcode)
{
	Emit (Value::Unsigned (opcode), Byte);
}

void Context::Emit (const ExtendedOpcode opcode)
{
	Emit (0, Byte); Emit (1, Byte); Emit (Value::Unsigned (opcode), Byte);
}

void Context::Emit (const ExtendedOpcode opcode, const Binary::Name& name)
{
	Emit (0, Byte); const auto length = Emit (Byte); Emit (Value::Unsigned (opcode), Byte); Emit (name, Patch::Absolute, 0, Size (information.target.pointer)); Fixup (length, Byte);
}

void Context::Encode (Value::Unsigned value)
{
	Value::Unsigned byte; do {byte = value & 0x7f; value >>= 7; if (value != 0) byte |= 0x80; Emit (byte, Byte);} while (byte & 0x80);
}

void Context::Encode (Value::Signed value)
{
	Value::Unsigned byte; do {byte = value & 0x7f; value >>= 7; if ((value != 0 || byte & 0x40) && (value != -1 || !(byte & 0x40))) byte |= 0x80; Emit (byte, Byte);} while (byte & 0x80);
}

void Context::EmitLocation (const Binary::Name& name, const Size size)
{
	Emit (Attribute::Location, Form::ExpressionLocation); const auto length = Emit (Byte); Emit (Operation::Address); Emit (name, Patch::Absolute, 0, size); Fixup (length, Byte);
}

void Context::EmitLocation (const Register& name)
{
	Emit (Attribute::Location, Form::ExpressionLocation); const auto length = Emit (Byte); Emit (Operation::Register); Encode (Value::Unsigned (Lookup (name))); Fixup (length, Byte);
}

void Context::EmitLocation (const Register& name, const Symbol::Displacement displacement)
{
	Emit (Attribute::Location, Form::ExpressionLocation); const auto length = Emit (Byte); Emit (Operation::RegisterBase); Encode (Value::Unsigned (Lookup (name))); Encode (displacement); Fixup (length, Byte);
}

Context::RegisterName Context::Lookup (const Register& name) const
{
	const auto result = platform.registers.find (name);
	if (result == platform.registers.end ()) EmitError (Format ("unknown register '%0'", name));
	return result->second;
}

const Context::Platform& Context::Lookup (const Target& target) const
{
	const auto result = platforms.find (target.name);
	if (result == platforms.end ()) EmitError (Format ("unsupported target '%0'", target.name));
	return result->second;
}

bool Context::IsParameter (const Symbol& symbol) const
{
	return IsVariable (symbol) && symbol.displacement > 0 && Lookup (symbol.register_) == platform.framePointer || IsAlias (symbol);
}

bool Context::IsEmpty (const Block& block) const
{
	for (auto symbol: block.symbols) if (!IsParameter (*symbol) && !IsResult (*symbol)) return false; return true;
}

// Intermediate code representation
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

#include "asmlexer.hpp"
#include "code.hpp"
#include "ieee.hpp"
#include "layout.hpp"
#include "utilities.hpp"

#include <algorithm>
#include <cctype>
#include <cstdlib>

using namespace ECS;
using namespace Code;

static const char*const models[] {nullptr, "s", "u", "f", "ptr", "fun"};
static const char*const registers[] {"res", "sp", "fp", "lnk"};

static const struct {Operand::Class class1, class2, class3;} table[] {
	#define INSTR(name, mnem, class1, class2, class3, ...) {Operand::class1, Operand::class2, Operand::class3},
	#include "code.def"
};

static const char*const mnemonics[] {
	#define INSTR(name, mnem, class1, class2, class3, ...) #name,
	#include "code.def"
};

Operand::Operand (const Code::Size s) :
	model {Size}, size {s}
{
}

Operand::Operand (const Code::Offset o) :
	model {Offset}, offset {o}
{
}

Operand::Operand (const Code::String& s) :
	model {String}, address {s}
{
}

Operand::Operand (const Code::Type& t) :
	model {Type}, type {t}
{
}

Operand::Operand (const Model m, const Code::Type& t) :
	model {m}, type {t}
{
}

Operand::Operand (const Model m, const Code::Type& t, const Section::Name& a) :
	model {m}, type {t}, address {a}
{
}

bool Operand::IsInstanceOf (const Class class_) const
{
	return ((2 << model) & class_) && (class_ != Reg || model == Register && IsUser (register_) && !displacement) ||
		class_ == Pointer && type.model == Type::Pointer || class_ == Function && type.model == Type::Function;
}

bool Operand::Uses (const Code::Register r) const
{
	assert (r != RVoid);
	return (model == Register || model == Address || model == Memory) && register_ == r;
}

Imm::Imm (const Code::Type& t, const Signed::Value imm) :
	Operand {Immediate, t}
{
	switch (type.model)
	{
	case Type::Signed: simm = imm; break;
	case Type::Unsigned: uimm = Unsigned::Value (imm); break;
	case Type::Float: fimm = Float::Value (imm); break;
	case Type::Pointer: ptrimm = Pointer::Value (imm); break;
	case Type::Function: funimm = Function::Value (imm); break;
	default: assert (Type::Unreachable);
	}
}

Reg::Reg (const Code::Type& t, const Code::Register r, const Displacement d) :
	Operand {Register, t}
{
	assert (r != RVoid);
	register_ = r; displacement = d;
}

Adr::Adr (const Code::Type& t, const Section::Name& a, const Displacement d) :
	Operand {Address, t, a}
{
	assert (!address.empty ());
	register_ = RVoid; displacement = d;
}

Adr::Adr (const Code::Type& t, const Section::Name& a, const Code::Register r, const Displacement d) :
	Operand {Address, t, a}
{
	assert (!address.empty ());
	register_ = r; displacement = d;
}

Mem::Mem (const Code::Type& t, const Pointer::Value p, const Strict s) :
	Operand {Memory, t}
{
	register_ = RVoid; ptrimm = p; strict = s;
}

Mem::Mem (const Code::Type& t, const Operand& operand, const Displacement d, const Strict s) :
	Operand {Memory, t, operand.address}
{
	assert (IsValid (operand)); assert (!IsMemory (operand)); assert (IsPointer (operand.type));
	if (operand.model == Immediate) register_ = RVoid, ptrimm = operand.ptrimm + d;
	else register_ = operand.register_, displacement = operand.displacement + d;
	strict = s;
}

Mem::Mem (const Code::Type& t, const Section::Name& a, const Displacement d, const Strict s) :
	Operand {Memory, t, a}
{
	assert (!address.empty ());
	register_ = RVoid; displacement = d; strict = s;
}

Mem::Mem (const Code::Type& t, const Code::Register r, const Displacement d, const Strict s) :
	Operand {Memory, t}
{
	assert (r != RVoid);
	register_ = r; displacement = d; strict = s;
}

Mem::Mem (const Code::Type& t, const Section::Name& a, const Code::Register r, const Displacement d, const Strict s) :
	Operand {Memory, t, a}
{
	assert (!address.empty () || r != RVoid);
	register_ = r; displacement = d; strict = s;
}

Size Instruction::Uses (const Register register_) const
{
	return operand1.Uses (register_) + operand2.Uses (register_) + operand3.Uses (register_) + (register_ == RRes && (mnemonic == ALIAS || mnemonic == CALL));
}

Platform::Platform (Layout& l, const HasLinkRegister hasLinkRegister) :
	integer (l.integer.size), float_ (l.float_.size), pointer (l.pointer.size), function (l.function.size), return_ (l.callStack ? l.function.size : 0), link (hasLinkRegister ? l.function.size : 0), stackDisplacement (l.stack.size), layout {l}
{
}

bool Platform::IsAligned (const Size offset, const Type& type) const
{
	return offset % GetAlignment (type) == 0;
}

bool Platform::IsAligned (const Section& section, const Type& type) const
{
	return !IsData (section.type) || IsAligned (section.fixed ? section.origin : section.alignment ? section.alignment : 1, type);
}

bool Platform::IsStackAligned (const Size size) const
{
	return size % layout.stack.alignment.minimum == 0;
}

Type::Size Platform::GetAlignment (const Type& type) const
{
	assert (type.model != Type::Void);
	const Layout::Type*const types[] {nullptr, &layout.integer, &layout.integer, &layout.float_, &layout.pointer, &layout.function};
	return types[type.model]->alignment (type.size);
}

Type::Size Platform::GetStackSize (const Type& type) const
{
	return Align (type.size, GetStackAlignment (type));
}

Type::Size Platform::GetStackAlignment (const Type& type) const
{
	return std::max (GetAlignment (type), Type::Size (layout.stack.alignment (type.size)));
}

bool Code::IsGeneral (const Register register_)
{
	return register_ >= R0 && register_ < GeneralRegisters;
}

bool Code::IsUser (const Register register_)
{
	return register_ >= R0 && register_ < UserRegisters;
}

bool Code::IsValid (const Type& type)
{
	switch (type.model)
	{
	case Type::Void:
		return type.size == 0;
	case Type::Signed: case Type::Unsigned:
		return type.size == 1 || type.size == 2 || type.size == 4 || type.size == 8;
	case Type::Float:
		return type.size == 4 || type.size == 8;
	case Type::Pointer: case Type::Function:
		return type.size >= 1 && type.size <= 4 || type.size == 8;
	default:
		assert (Type::Unreachable);
	}
}

bool Code::IsPointer (const Type& type)
{
	return type.model == Type::Pointer;
}

bool Code::IsAddress (const Type& type)
{
	return type.model == Type::Pointer || type.model == Type::Function;
}

bool Code::IsFloat (const Operand& operand)
{
	return operand.type.model == Type::Float;
}

bool Code::IsVoid (const Operand& operand)
{
	return operand.model == Operand::Void;
}

bool Code::HasType (const Operand& operand)
{
	return operand.model >= Operand::Immediate;
}

bool Code::IsSize (const Operand& operand)
{
	return operand.model == Operand::Size;
}

bool Code::IsOffset (const Operand& operand)
{
	return operand.model == Operand::Offset;
}

bool Code::IsString (const Operand& operand)
{
	return operand.model == Operand::String;
}

bool Code::IsMemory (const Operand& operand)
{
	return operand.model == Operand::Memory;
}

bool Code::IsStrict (const Operand& operand)
{
	return operand.model == Operand::Memory && operand.strict;
}

bool Code::IsSigned (const Operand& operand)
{
	return operand.type.model == Type::Signed;
}

bool Code::IsAddress (const Operand& operand)
{
	return operand.model == Operand::Address && operand.register_ == RVoid;
}

bool Code::IsRegister (const Operand& operand)
{
	return operand.model == Operand::Register && !operand.displacement;
}

bool Code::HasRegister (const Operand& operand)
{
	return operand.model >= Operand::Register && operand.register_ != RVoid;
}

bool Code::IsStackPointer (const Operand& operand)
{
	return operand.model == Operand::Register && operand.register_ == RSP;
}

bool Code::IsFramePointer (const Operand& operand)
{
	return operand.model == Operand::Register && operand.register_ == RFP;
}

bool Code::IsImmediate (const Operand& operand)
{
	return operand.model == Operand::Immediate;
}

bool Code::IsValid (const Operand& operand)
{
	if (!IsValid (operand.type)) return false;

	switch (operand.model)
	{
	case Operand::Void: case Operand::Size: case Operand::Offset: case Operand::String:
		return operand.type.model == Type::Void;

	case Operand::Type:
		return operand.type.model != Type::Void;

	case Operand::Immediate:
		switch (operand.type.model)
		{
		case Type::Signed: return TruncatesPreserving (operand.simm, operand.type.size * 8);
		case Type::Unsigned: return TruncatesPreserving (operand.uimm, operand.type.size * 8);
		case Type::Float: return TruncatesPreserving (operand.fimm, operand.type.size * 8);
		case Type::Pointer: return TruncatesPreserving (operand.ptrimm, operand.type.size * 8);
		case Type::Function: return TruncatesPreserving (operand.funimm, operand.type.size * 8);
		default: assert (Type::Unreachable);
		}
	case Operand::Register:
		return operand.type.model != Type::Void && operand.register_ != RVoid && (!operand.displacement || IsPointer (operand.type)) && (operand.register_ != RLink || operand.type.model == Type::Function);
	case Operand::Address:
		return IsAddress (operand.type) && !operand.address.empty () && (operand.register_ == RVoid && !operand.displacement || IsPointer (operand.type));
	case Operand::Memory:
		return operand.type.model != Type::Void && operand.register_ != RLink;
	default:
		assert (Operand::Unreachable);
	}
}

bool Code::IsValid (const Instruction& i)
{
	const auto& entry = table[i.mnemonic];
	return IsValid (i.operand1) && i.operand1.IsInstanceOf (entry.class1) && IsValid (i.operand2) &&
		i.operand2.IsInstanceOf (entry.class2) && IsValid (i.operand3) && i.operand3.IsInstanceOf (entry.class3) &&
		(!HasType (i.operand1) || !HasType (i.operand2) || i.operand1.type == i.operand2.type || i.mnemonic == Instruction::CONV) &&
		(!HasType (i.operand2) || !HasType (i.operand3) || i.operand2.type == i.operand3.type || i.mnemonic == Instruction::FILL) &&
		(entry.class1 != Operand::RegMem || i.operand1.model != Operand::Register || i.operand1.displacement == 0) &&
		(i.mnemonic != Instruction::CONV || (!IsAddress (i.operand1.type) || !IsFloat (i.operand2)) && (!IsFloat (i.operand1) || !IsAddress (i.operand2.type))) &&
		(i.mnemonic != Instruction::ASM && i.mnemonic != Instruction::LOC || i.operand2.size > 0) &&
		(i.mnemonic != Instruction::SYM || IsImmediate (i.operand3) || IsRegister (i.operand3) && i.operand3.displacement == 0 || i.operand3.address.empty () && i.operand3.register_ != RVoid || !i.operand3.address.empty () && i.operand3.register_ == RVoid && i.operand3.displacement == 0);
}

bool Code::IsValid (const Operand& operand, const Section& section, const Platform& platform)
{
	return !HasRegister (operand) || IsCode (section.type) && (platform.link.size || operand.register_ != RLink);
}

bool Code::IsValid (const Instruction& i, const Section& section, const Platform& platform)
{
	return IsValid (i) && IsValid (i.operand1, section, platform) && IsValid (i.operand2, section, platform) && IsValid (i.operand3, section, platform) &&
		(i.operand1.model != Operand::Offset || i.operand1.offset >= &section.instructions.front () - &i - 1 && i.operand1.offset <= &section.instructions.back () - &i) &&
		(!IsAssembly (section) || IsAssembly (i.mnemonic)) && (!IsCode (section.type) || IsCode (i.mnemonic)) && (!IsData (section.type) || IsData (i.mnemonic)) && (!IsType (section.type) || IsType (i.mnemonic)) &&
		(i.mnemonic != Instruction::CALL || platform.IsStackAligned (i.operand2.size)) && (i.mnemonic != Instruction::ENTER || platform.IsStackAligned (i.operand1.size));
}

bool Code::IsModifying (const Instruction& instruction)
{
	return table[instruction.mnemonic].class1 == Operand::RegMem;
}

bool Code::IsAssembly (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::ASM;
}

bool Code::IsCode (const Instruction::Mnemonic mnemonic)
{
	return mnemonic != Instruction::DEF && mnemonic != Instruction::RES;
}

bool Code::IsData (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::ALIAS || mnemonic == Instruction::REQ || mnemonic == Instruction::DEF || mnemonic == Instruction::RES || mnemonic == Instruction::LOC || mnemonic == Instruction::FIELD || mnemonic == Instruction::VALUE || IsTyping (mnemonic);
}

bool Code::IsType (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::LOC || mnemonic == Instruction::FIELD || mnemonic == Instruction::VALUE || IsTyping (mnemonic);
}

bool Code::IsBranching (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::BR || mnemonic == Instruction::BREQ || mnemonic == Instruction::BRNE || mnemonic == Instruction::BRLT || mnemonic == Instruction::BRGE;
}

bool Code::IsDeclaring (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::REC || mnemonic == Instruction::FUNC || mnemonic == Instruction::ENUM;
}

bool Code::IsLocated (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::BREAK || mnemonic == Instruction::SYM || mnemonic == Instruction::FIELD || mnemonic == Instruction::VALUE;
}

bool Code::IsLocating (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::LOC;
}

bool Code::IsSink (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::RET || mnemonic == Instruction::BR || mnemonic == Instruction::JUMP || mnemonic == Instruction::TRAP;
}

bool Code::IsTyped (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::SYM || mnemonic == Instruction::FIELD || mnemonic == Instruction::ARRAY || mnemonic == Instruction::PTR || mnemonic == Instruction::REF || mnemonic == Instruction::FUNC || mnemonic == Instruction::ENUM;
}

bool Code::IsTyping (const Instruction::Mnemonic mnemonic)
{
	return mnemonic == Instruction::VOID || mnemonic == Instruction::TYPE || mnemonic == Instruction::ARRAY || mnemonic == Instruction::REC || mnemonic == Instruction::PTR || mnemonic == Instruction::REF || mnemonic == Instruction::FUNC || mnemonic == Instruction::ENUM;
}

bool Code::HasDefinitions (const Section& section)
{
	for (auto& instruction: section.instructions) if (instruction.mnemonic == Instruction::DEF && !IsZero (instruction.operand1)) return true; return false;
}

Register Code::GetRegister (const Operand& operand)
{
	assert (HasRegister (operand)); return operand.register_;
}

Register Code::GetModifiedRegister (const Instruction& i)
{
	if (i.mnemonic == Instruction::ALIAS || i.mnemonic == Instruction::CALL) return RRes;
	if (IsModifying (i) && IsRegister (i.operand1)) return i.operand1.register_;
	return RVoid;
}

Type Code::GetModifiedRegisterType (const Instruction& instruction)
{
	if (instruction.mnemonic == Instruction::ALIAS) return Unsigned {1};
	if (instruction.mnemonic == Instruction::CALL) return Unsigned {1};
	if (IsModifying (instruction)) return instruction.operand1.type;
	return {};
}

bool Code::IsZero (const Operand& operand)
{
	if (!IsImmediate (operand)) return false;
	switch (operand.type.model)
	{
	case Type::Signed: return !operand.simm;
	case Type::Unsigned: return !operand.uimm;
	case Type::Float: return !operand.fimm;
	case Type::Pointer: return !operand.ptrimm;
	case Type::Function: return !operand.funimm;
	default: assert (Type::Unreachable);
	}
}

bool Code::IsOne (const Operand& operand)
{
	if (!IsImmediate (operand)) return false;
	switch (operand.type.model)
	{
	case Type::Signed: return operand.simm == 1;
	case Type::Unsigned: return operand.uimm == 1;
	case Type::Float: return operand.fimm == 1;
	case Type::Pointer: return operand.ptrimm == 1;
	case Type::Function: return operand.funimm == 1;
	default: assert (Type::Unreachable);
	}
}

bool Code::IsMinusOne (const Operand& operand)
{
	if (!IsImmediate (operand)) return false;
	switch (operand.type.model)
	{
	case Type::Signed: return operand.simm == -1;
	case Type::Unsigned: case Type::Pointer: case Type::Function: return false;
	case Type::Float: return operand.fimm == 1;
	default: assert (Type::Unreachable);
	}
}

bool Code::IsFull (const Operand& operand)
{
	if (!IsImmediate (operand)) return false;
	switch (operand.type.model)
	{
	case Type::Signed: return !Truncate (~operand.simm, operand.type.size * 8);
	case Type::Unsigned: return !Truncate (~operand.uimm, operand.type.size * 8);
	case Type::Pointer: return !Truncate (~operand.ptrimm, operand.type.size * 8);
	case Type::Function: return !Truncate (~operand.funimm, operand.type.size * 8);
	default: assert (Type::Unreachable);
	}
}

bool Code::IsNegative (const Operand& operand)
{
	if (!IsImmediate (operand)) return false;
	switch (operand.type.model)
	{
	case Type::Signed: return operand.simm < 0;
	case Type::Unsigned: case Type::Pointer: case Type::Function: return false;
	case Type::Float: return operand.fimm < 0;
	default: assert (Type::Unreachable);
	}
}

Unsigned::Value Code::Convert (const Operand& operand)
{
	assert (operand.model == Operand::Immediate);
	switch (operand.type.model)
	{
	case Type::Signed: return Truncate (Unsigned::Value (operand.simm), operand.type.size * 8);
	case Type::Unsigned: return Truncate (Unsigned::Value (operand.uimm), operand.type.size * 8);
	case Type::Float: return operand.type.size == 4 ? IEEE::SinglePrecision::Encode (operand.fimm) : IEEE::DoublePrecision::Encode (operand.fimm);
	case Type::Pointer: return Truncate (Unsigned::Value (operand.ptrimm), operand.type.size * 8);
	case Type::Function: return Truncate (Unsigned::Value (operand.funimm), operand.type.size * 8);
	default: assert (Type::Unreachable);
	}
}

void Code::DefineSymbol (const String& name, const Operand& operand, std::ostream& assembly)
{
	Assembly::WriteDefinition (Assembly::WriteIdentifier (assembly, name));
	if (IsMemory (operand)) assembly << operand.displacement << '\n';
	else if (!IsImmediate (operand)) assembly << operand.register_ << '\n';
	else if (IsSigned (operand)) assembly << operand.simm << '\n';
	else if (IsFloat (operand)) assembly << operand.fimm << '\n';
	else assembly << Convert (operand) << '\n';
}

bool Code::operator == (const Type& a, const Type& b)
{
	return a.model == b.model && a.size == b.size;
}

bool Code::operator == (const Operand& a, const Operand& b)
{
	if (a.model != b.model || a.type != b.type) return false;

	switch (a.model)
	{
	case Operand::Void:
		return true;
	case Operand::Size:
		return a.size == b.size;
	case Operand::Offset:
		return a.offset == b.offset;
	case Operand::String:
		return a.address == b.address;
	case Operand::Immediate:
		if (a.type.model == Type::Signed) return a.simm == b.simm;
		if (a.type.model == Type::Unsigned) return a.uimm == b.uimm;
		if (a.type.model == Type::Float) return a.fimm == b.fimm;
		if (a.type.model == Type::Pointer) return a.ptrimm == b.ptrimm;
		if (a.type.model == Type::Function) return a.funimm == b.funimm;
		return false;
	case Operand::Register:
		return a.register_ == b.register_ && a.displacement == b.displacement;
	case Operand::Address:
		return a.address == b.address && a.register_ == b.register_ && a.displacement == b.displacement;
	case Operand::Memory:
		return a.address == b.address && a.register_ == b.register_ && a.displacement == b.displacement && a.strict == b.strict;
	default:
		assert (Operand::Unreachable);
	}
}

bool Code::operator == (const Instruction& a, const Instruction& b)
{
	return a.mnemonic == b.mnemonic && a.operand1 == b.operand1 && a.operand2 == b.operand2 && a.operand3 == b.operand3;
}

bool Code::operator == (const Section& a, const Section& b)
{
	return a.type == b.type && a.name == b.name && a.required == b.required && a.duplicable == b.duplicable && a.replaceable == b.replaceable && a.instructions == b.instructions;
}

std::istream& Code::operator >> (std::istream& stream, Register& register_)
{
	if (stream >> std::ws && stream.get () != '$') stream.setstate (stream.failbit);
	if (std::isalpha (stream.peek ()) && ReadEnum (stream, register_, registers, IsAlpha)) return register_ = Register (register_ + RRes), stream;
	return ReadPrefixedValue (stream.putback ('$'), register_, "$", R0, RMax);
}

std::ostream& Code::operator << (std::ostream& stream, const Register register_)
{
	if (!IsGeneral (register_)) return WriteEnum (stream << '$', register_ - RRes, registers);
	return WritePrefixedValue (stream, register_, "$", R0);
}

std::istream& Code::operator >> (std::istream& stream, Type& type)
{
	Type::Model model; if (!ReadEnum (stream, model, models, IsAlpha)) return stream;
	if (model == Type::Pointer || model == Type::Function) return type = {model, 1}, stream;
	const auto flags = stream.setf (stream.dec, stream.basefield | stream.skipws);
	Type::Size size; if (std::isdigit (stream.peek ()) && stream >> size) type = {model, size}; else stream.setstate (stream.failbit);
	stream.flags (flags); return stream;
}

std::ostream& Code::operator << (std::ostream& stream, const Type& type)
{
	assert (type.model != Type::Void); WriteEnum (stream, type.model, models);
	if (type.model == Type::Pointer || type.model == Type::Function) return stream;
	const auto flags = stream.setf (stream.dec, stream.basefield); stream << type.size;
	stream.flags (flags); return stream;
}

std::istream& Code::operator >> (std::istream& stream, Operand& operand)
{
	Type type; Section::Name address; Register register_ = RVoid;
	union {Size size; Offset offset; Signed::Value simm; Unsigned::Value uimm; Float::Value fimm; Pointer::Value ptrimm; Function::Value funimm; Displacement displacement;};
	const auto flags = stream.setf ({}, stream.skipws); displacement = 0;
	if (stream >> std::ws && std::isdigit (stream.peek ()) && stream >> size) operand = size;
	else if ((stream.peek () == '+' || stream.peek () == '-') && stream >> offset) operand = offset;
	else if (stream.peek () == '"' && ReadString (stream, address, '"')) operand = address;
	else if (stream >> type && (!stream.good () || stream >> std::ws && !stream.good ())) operand = type;
	else if (stream.peek () == '@')
	{
		if (stream.ignore ().peek () == '"') ReadString (stream, address, '"'); else ReadIdentifier (stream, address, ECS::IsAddress);
		if (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '+') if (stream.ignore () >> std::ws && stream.peek () == '$') stream >> register_; else stream.putback ('+');
		if (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '+') stream.ignore () >> displacement;
		else if (stream.good () && stream.peek () == '-') stream.ignore () >> displacement, displacement = -displacement;
		if (stream && type.model) operand = Adr {type, address, register_, displacement};
	}
	else if (stream.peek () == '$')
	{
		stream >> register_;
		if (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '+') stream.ignore () >> displacement;
		else if (stream.good () && stream.peek () == '-') stream.ignore () >> displacement, displacement = -displacement;
		if (stream) operand = Reg {type, register_, displacement};
	}
	else if (stream.peek () == '[')
	{
		if (stream.ignore () >> std::ws && stream.peek () == '@')
			if (stream.ignore ().peek () == '"') ReadString (stream, address, '"'); else ReadIdentifier (stream, address, ECS::IsAddress);
		else if (stream.peek () == '$') stream >> register_; else stream >> ptrimm;
		if (!address.empty () && stream >> std::ws && stream.peek () == '+') if (stream.ignore () >> std::ws && stream.peek () == '$') stream >> register_; else stream.putback ('+');
		if (!address.empty () || register_ != RVoid) if (stream >> std::ws && stream.peek () == '+') stream.ignore () >> displacement;
		else if (stream.peek () == '-') stream.ignore () >> displacement, displacement = -displacement;
		if (stream >> std::ws && stream.get () != ']') stream.setstate (stream.failbit);
		const auto strict = stream.good () && stream >> std::ws && stream.good () && stream.peek () == '!' && stream.ignore ();
		if (stream) operand = address.empty () && register_ == RVoid ? Mem {type, ptrimm, strict} : Mem {type, address, register_, displacement, strict};
	}
	else if (stream.peek () != '+' && stream.peek () != '-' && !std::isdigit (stream.peek ())) operand = type;
	else if (type.model == Type::Signed && stream >> simm) operand = SImm (type, simm);
	else if (type.model == Type::Unsigned && stream >> std::ws && stream.peek () != '-' && stream >> uimm) operand = UImm (type, uimm);
	else if (type.model == Type::Float && ReadFloat (stream, fimm, std::strtod)) operand = FImm (type, fimm);
	else if (type.model == Type::Pointer && stream >> std::ws && stream.peek () != '-' && stream >> ptrimm) operand = PtrImm (type, ptrimm);
	else if (type.model == Type::Function && stream >> std::ws && stream.peek () != '-' && stream >> funimm) operand = FunImm (type, funimm);
	stream.flags (flags); return stream;
}

std::ostream& Code::operator << (std::ostream& stream, const Operand& operand)
{
	if (HasType (operand)) stream << operand.type << ' ';

	const auto precision = stream.precision (20);
	const auto flags = stream.flags (stream.dec);

	switch (operand.model)
	{
	case Operand::Size:
		stream << operand.size; break;
	case Operand::Offset:
		if (operand.offset < 0) stream << '-' << -operand.offset; else stream << '+' << operand.offset; break;
	case Operand::String:
		WriteString (stream, operand.address, '"'); break;
	case Operand::Type:
		stream << operand.type; break;
	case Operand::Immediate:
		if (operand.type.model == Type::Signed) stream << operand.simm;
		else if (operand.type.model == Type::Unsigned) stream << operand.uimm;
		else if (operand.type.model == Type::Float) stream << operand.fimm;
		else if (operand.type.model == Type::Pointer) stream << operand.ptrimm;
		else if (operand.type.model == Type::Function) stream << operand.funimm;
		break;
	case Operand::Memory:
		stream << '[';
	case Operand::Register:
	case Operand::Address:
		if (!operand.address.empty ()) WriteAddress (stream, nullptr, operand.address, 0, 0);
		if (!operand.address.empty () && operand.register_ != RVoid) stream << " + ";
		if (operand.register_ != RVoid) stream << operand.register_;
		if (operand.address.empty () && operand.register_ == RVoid) stream << operand.ptrimm;
		else if (operand.displacement > 0) stream << " + " << operand.displacement;
		else if (operand.displacement < 0) stream << " - " << -operand.displacement;
		if (operand.model == Operand::Memory) if (stream << ']', operand.strict) stream << '!';
		break;
	default:
		assert (Operand::Unreachable);
	}

	stream.precision (precision); stream.flags (flags); return stream;
}

std::istream& Code::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic;
	Operand operand1, operand2, operand3;

	if (stream >> mnemonic && stream.good () && stream >> std::ws && stream.good ())
		if (stream >> operand1 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
			if (stream >> operand2 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
				stream >> operand3;

	if (stream) instruction = {mnemonic, operand1, operand2, operand3};
	return stream;
}

std::ostream& Code::operator << (std::ostream& stream, const Instruction& instruction)
{
	if (stream << instruction.mnemonic && instruction.operand1.model)
		if (stream << '\t' << instruction.operand1 && instruction.operand2.model)
			if (stream << ", " << instruction.operand2 && instruction.operand3.model)
				stream << ", " << instruction.operand3;
	return stream;
}

std::istream& Code::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, mnemonics, IsAlpha);
}

std::ostream& Code::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, mnemonics);
}

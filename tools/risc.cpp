// RISC instruction set representation
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

#include "object.hpp"
#include "risc.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace RISC;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type type1, type2, type3;
};

constexpr const Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, mask, type1, type2, type3) \
		{Instruction::mnem, code, mask, Operand::type1, Operand::type2, Operand::type3},
	#include "risc.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "risc.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::first {table}, Instruction::last {table, 0};

Operand::Operand (const RISC::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const RISC::Register r) :
	model {Register}, register_ {r}
{
}

Opcode Operand::Encode (const Type type) const
{
	switch (type)
	{
	case Ra: return Opcode (register_) << 24;
	case Rb: return Opcode (register_) << 20;
	case Rc: return Opcode (register_);
	case Imm: return Opcode (immediate & 0x1000ffff);
	case Dsp: return Opcode (immediate & 0xfffff);
	case Off: return Opcode (immediate >> 2 & 0xffffff);
	default: return 0;
	}
}

void Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case Ra: model = Register; register_ = RISC::Register (opcode >> 24 & 0xf); break;
	case Rb: model = Register; register_ = RISC::Register (opcode >> 20 & 0xf); break;
	case Rc: model = Register; register_ = RISC::Register (opcode & 0xf); break;
	case Imm: model = Immediate; immediate = RISC::Immediate (opcode << 3 & 0x80000000) >> 15 | RISC::Immediate (opcode & 0xffff); break;
	case Dsp: model = Immediate; immediate = RISC::Immediate (opcode & 0xfffff) << 12 >> 12; break;
	case Off: model = Immediate; immediate = RISC::Immediate (opcode & 0xffffff) << 8 >> 6; break;
	default: model = Empty;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case Ra: case Rb: case Rc: return model == Register;
	case Imm: return model == Immediate && immediate >= -65536 && immediate < 65536;
	case Dsp: return model == Immediate && immediate >= -524288 && immediate < 524288;
	case Off: return model == Immediate && immediate >= -33554432 && immediate < 33554432 && immediate % 4 == 0;
	default: return model == Empty;
	}
}

Instruction::Instruction (const Span<const Byte> bytes)
{
	if (bytes.size () < 4) return;
	const auto opcode = Opcode (bytes[0]) | Opcode (bytes[1]) << 8 | Opcode (bytes[2]) << 16 | Opcode (bytes[3]) << 24;
	for (auto& entry: table)
		if ((opcode & entry.mask) == entry.opcode)
			{operand1.Decode (opcode, entry.type1); operand2.Decode (opcode, entry.type2); operand3.Decode (opcode, entry.type3); this->entry = &entry; return;}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o1, const Operand& o2, const Operand& o3) :
	operand1 {o1}, operand2 {o2}, operand3 {o3}
{
	for (auto& entry: Span<const Entry> {first[mnemonic], last[mnemonic]})
		if (operand1.IsCompatibleWith (entry.type1) && operand2.IsCompatibleWith (entry.type2) && operand3.IsCompatibleWith (entry.type3))
			{this->entry = &entry; return;}
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); assert (bytes.size () >= 4);
	const auto opcode = entry->opcode | operand1.Encode (entry->type1) | operand2.Encode (entry->type2) | operand3.Encode (entry->type3);
	bytes[0] = opcode; bytes[1] = opcode >> 8; bytes[2] = opcode >> 16; bytes[3] = opcode >> 24;
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	if (entry->type1 != Operand::Off && (entry->type2 != Operand::Imm || operand2.model != Operand::Immediate) && entry->type3 != Operand::Dsp && (entry->type3 != Operand::Imm || operand3.model != Operand::Immediate)) return;
	if (entry->type1 == Operand::Off && patch.mode == Object::Patch::Absolute) patch.scale += 2, patch.displacement -= 4, patch.mode = Object::Patch::Relative;
	patch.pattern = {2, Endianness::Little}; if (entry->type3 == Operand::Dsp) patch.pattern += {2, 0xf}; else if (entry->type1 == Operand::Off) patch.pattern += {2, 0xff};
}

Register RISC::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

std::istream& RISC::operator >> (std::istream& stream, Register& register_)
{
	return ReadPrefixedValue (stream, register_, "r", R0, R15);
}

std::ostream& RISC::operator << (std::ostream& stream, const Register register_)
{
	return WritePrefixedValue (stream, register_, "r", R0);
}

std::istream& RISC::operator >> (std::istream& stream, Operand& operand)
{
	union {Immediate immediate; Register register_;};
	if (stream >> std::ws && stream.peek () == 'r' && stream >> register_) operand = register_;
	else if (stream >> immediate) operand = immediate;
	return stream;
}

std::ostream& RISC::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	default: return stream;
	}
}

std::istream& RISC::operator >> (std::istream& stream, Instruction& instruction)
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

std::ostream& RISC::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ", " << instruction.operand2 && !IsEmpty (instruction.operand3))
				stream << ", " << instruction.operand3;
	return stream;
}

std::istream& RISC::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsAlnum);
}

std::ostream& RISC::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

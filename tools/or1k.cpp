// OpenRISC 1000 instruction set representation
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
#include "or1k.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace OR1K;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type type1, type2, type3;
	Class class_;
};

constexpr const Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, mask, type1, type2, type3, class) \
		{Instruction::mnem, code, mask, Operand::type1, Operand::type2, Operand::type3, Instruction::Class::class},
	#include "or1k.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "or1k.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::lookup {table};

Operand::Operand (const OR1K::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const OR1K::Register r) :
	model {Register}, register_ {r}
{
}

Operand::Operand (const OR1K::Immediate i, const OR1K::Register r) :
	model {Memory}, immediate {i}, register_ {r}
{
}

void Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case I: model = Immediate; immediate = OR1K::Immediate (opcode) << 16 >> 16; break;
	case IRA: model = Memory; immediate = OR1K::Immediate (opcode) << 16 >> 16; register_ = OR1K::Register (R0 + (opcode >> 16 & 0x1f)); break;
	case IRA_: model = Memory; immediate = OR1K::Immediate (opcode >> 10 & 0xf800 | opcode & 0x7ff) << 16 >> 16; register_ = OR1K::Register (R0 + (opcode >> 16 & 0x1f)); break;
	case K: model = Immediate; immediate = OR1K::Immediate (opcode & 0xffff); break;
	case K_: model = Immediate; immediate = OR1K::Immediate (opcode >> 10 & 0xf800 | opcode & 0x7ff); break;
	case L: model = Immediate; immediate = OR1K::Immediate (opcode & 0x3f); break;
	case N: model = Immediate; immediate = OR1K::Immediate (opcode) << 6 >> 4; break;
	case RA: model = Register; register_ = OR1K::Register (R0 + (opcode >> 16 & 0x1f)); break;
	case RB: model = Register; register_ = OR1K::Register (R0 + (opcode >> 11 & 0x1f)); break;
	case RD: model = Register; register_ = OR1K::Register (R0 + (opcode >> 21 & 0x1f)); break;
	default: model = Empty;
	}
}

Opcode Operand::Encode (const Type type) const
{
	switch (type)
	{
	case I: case K: return Opcode (immediate & 0xffff);
	case IRA: return Opcode (immediate & 0xffff) | Opcode (register_ - R0) << 16;
	case IRA_: return Opcode (immediate & 0xf800) << 10 | Opcode (immediate & 0x7ff) | Opcode (register_ - R0) << 16;
	case K_: return Opcode (immediate & 0xf800) << 10 | Opcode (immediate & 0x7ff);
	case L: return Opcode (immediate & 0x3f);
	case N: return Opcode (immediate & 0xffffffc) >> 2;
	case RA: return Opcode (register_ - R0) << 16;
	case RB: return Opcode (register_ - R0) << 11;
	case RD: return Opcode (register_ - R0) << 21;
	default: return 0;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case I: return model == Immediate && immediate >= -32768 && immediate <= 32767;
	case IRA: case IRA_: return model == Memory && immediate >= -32768 && immediate <= 32767;
	case K: case K_: return model == Immediate && immediate >= 0 && immediate <= 65535;
	case L: return model == Immediate && immediate >= 0 && immediate <= 63;
	case N: return model == Immediate && immediate >= -134217728 && immediate <= 134217724 && immediate % 4 == 0;
	case RA: case RB: case RD: return model == Register;
	default: return model == Empty;
	}
}

Instruction::Instruction (const Span<const Byte> bytes)
{
	if (bytes.size () < 4) return;
	const auto opcode = Opcode (bytes[0]) << 24 | Opcode (bytes[1]) << 16 | Opcode (bytes[2]) << 8 | Opcode (bytes[3]);
	for (auto& entry: table)
		if ((opcode & entry.mask) == entry.opcode)
		{
			operand1.Decode (opcode, entry.type1);
			operand2.Decode (opcode, entry.type2);
			operand3.Decode (opcode, entry.type3);
			this->entry = &entry; return;
		}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o1, const Operand& o2, const Operand& o3) :
	entry {lookup[mnemonic]}, operand1 {o1}, operand2 {o2}, operand3 {o3}
{
	if (!operand1.IsCompatibleWith (entry->type1) || !operand2.IsCompatibleWith (entry->type2) || !operand3.IsCompatibleWith (entry->type3)) entry = nullptr;
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); assert (bytes.size () >= 4);
	const auto opcode = entry->opcode | operand1.Encode (entry->type1) | operand2.Encode (entry->type2) | operand3.Encode (entry->type3);
	bytes[0] = opcode >> 24; bytes[1] = opcode >> 16; bytes[2] = opcode >> 8; bytes[3] = opcode;
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	if (entry->type2 == Operand::K || entry->type3 == Operand::K) patch.offset += 2, patch.pattern = {2, Endianness::Big};
	else if (entry->type1 == Operand::N) patch.scale += 2, patch.pattern = {{3, 0xff}, {2, 0xff}, {1, 0xff}, {0, 0x03}};
	if (entry->type1 == Operand::N && patch.mode == Object::Patch::Absolute) patch.mode = Object::Patch::Relative;
}

Register OR1K::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

std::istream& OR1K::operator >> (std::istream& stream, Register& register_)
{
	return ReadPrefixedValue (stream, register_, "r", R0, R31);
}

std::ostream& OR1K::operator << (std::ostream& stream, const Register register_)
{
	return WritePrefixedValue (stream, register_, "r", R0);
}

std::istream& OR1K::operator >> (std::istream& stream, Operand& operand)
{
	Register register_; Immediate immediate;
	if (stream >> std::ws && stream.peek () == 'r' && stream >> register_) operand = register_;
	else if (stream >> immediate)
		if (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '(')
			if (stream.ignore () >> register_ >> std::ws && stream.get () == ')') operand = {immediate, register_};
			else stream.setstate (stream.failbit);
		else operand = immediate;
	return stream;
}

std::ostream& OR1K::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	case Operand::Memory: return stream << operand.immediate << " (" << operand.register_ << ')';
	default: return stream;
	}
}

std::istream& OR1K::operator >> (std::istream& stream, Instruction& instruction)
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

std::ostream& OR1K::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ", " << instruction.operand2 && !IsEmpty (instruction.operand3))
				stream << ", " << instruction.operand3;
	return stream;
}

std::istream& OR1K::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsIdentifier);
}

std::ostream& OR1K::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

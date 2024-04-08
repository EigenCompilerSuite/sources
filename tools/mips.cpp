// MIPS instruction set representation
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

#include "mips.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace MIPS;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type type1, type2, type3, type4;
	Architecture architecture;
};

constexpr Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, mask, type1, type2, type3, type4, architecture) \
		{Instruction::mnem, code, mask, Operand::type1, Operand::type2, Operand::type3, Operand::type4, architecture},
	#include "mips.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "mips.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::lookup {table};

Operand::Operand (const MIPS::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const MIPS::Register r) :
	model {Register}, register_ {r}
{
}

void Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case R11: model = Register; register_ = MIPS::Register (R0 + (opcode >> 11 & 0x1f)); break;
	case R16: model = Register; register_ = MIPS::Register (R0 + (opcode >> 16 & 0x1f)); break;
	case R21: case R21LS: model = Register; register_ = MIPS::Register (R0 + (opcode >> 21 & 0x1f)); break;
	case F6: model = Register; register_ = MIPS::Register (F0 + (opcode >> 6 & 0x1f)); break;
	case F11: model = Register; register_ = MIPS::Register (F0 + (opcode >> 11 & 0x1f)); break;
	case F16: model = Register; register_ = MIPS::Register (F0 + (opcode >> 16 & 0x1f)); break;
	case F21: model = Register; register_ = MIPS::Register (F0 + (opcode >> 21 & 0x1f)); break;
	case S016: model = Immediate; immediate = MIPS::Immediate (opcode) << 16 >> 16; break;
	case S016T4: model = Immediate; immediate = MIPS::Immediate (opcode) << 16 >> 14; break;
	case U03: model = Immediate; immediate = MIPS::Immediate (opcode & 0x7); break;
	case U016: model = Immediate; immediate = MIPS::Immediate (opcode & 0xffff); break;
	case U026T4: model = Immediate; immediate = MIPS::Immediate (opcode & 0x3ffffff) * 4; break;
	case U65: model = Immediate; immediate = MIPS::Immediate (opcode >> 6 & 0x1f); break;
	case U65M32: model = Immediate; immediate = MIPS::Immediate (opcode >> 6 & 0x1f) + 32; break;
	case U83: model = Immediate; immediate = MIPS::Immediate (opcode >> 8 & 0x7); break;
	case U115: model = Immediate; immediate = MIPS::Immediate (opcode >> 11 & 0x1f); break;
	case U115M1: model = Immediate; immediate = MIPS::Immediate (opcode >> 11 & 0x1f) + 1; break;
	case U115M33: model = Immediate; immediate = MIPS::Immediate (opcode >> 11 & 0x1f) + 33; break;
	case U165: model = Immediate; immediate = MIPS::Immediate (opcode >> 16 & 0x1f); break;
	case U183: model = Immediate; immediate = MIPS::Immediate (opcode >> 18 & 0x7); break;
	default: model = Empty;
	}
}

Opcode Operand::Encode (const Type type) const
{
	switch (type)
	{
	case R11: return Opcode (register_ - R0) << 11;
	case R16: return Opcode (register_ - R0) << 16;
	case R21: case R21LS: return Opcode (register_ - R0) << 21;
	case F6: return Opcode (register_ - F0) << 6;
	case F11: return Opcode (register_ - F0) << 11;
	case F16: return Opcode (register_ - F0) << 16;
	case F21: return Opcode (register_ - F0) << 21;
	case S016: return Opcode (immediate & 0xffff);
	case S016T4: return Opcode (immediate / 4 & 0xffff);
	case U03: case U016: return Opcode (immediate);
	case U026T4: return Opcode (immediate / 4);
	case U65: return Opcode (immediate) << 6;
	case U65M32: return Opcode (immediate - 32) << 6;
	case U83: return Opcode (immediate) << 8;
	case U115: return Opcode (immediate) << 11;
	case U115M1: return Opcode (immediate - 1) << 11;
	case U115M33: return Opcode (immediate - 33) << 11;
	case U165: return Opcode (immediate) << 16;
	case U183: return Opcode (immediate) << 18;
	default: return 0;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case R11: case R16: case R21: case R21LS: return model == Register && register_ >= R0 && register_ <= R31;
	case F6: case F11: case F16: case F21: return model == Register && register_ >= F0 && register_ <= F31;
	case S016: return model == Immediate && IsValid (immediate);
	case S016T4: return model == Immediate && immediate >= -131072 && immediate < 131072 && immediate % 4 == 0;
	case U03: case U83: case U183: return model == Immediate && immediate >= 0 && immediate < 8;
	case U016: return model == Immediate && immediate >= 0 && immediate < 65536;
	case U026T4: return model == Immediate && immediate >= 0 && immediate < 268435456 && immediate % 4 == 0;
	case U65: case U115: case U165: return model == Immediate && immediate >= 0 && immediate < 32;
	case U65M32: return model == Immediate && immediate >= 32 && immediate < 64;
	case U115M1: return model == Immediate && immediate > 0 && immediate <= 32;
	case U115M33: return model == Immediate && immediate > 32 && immediate <= 64;
	default: return model == Empty;
	}
}

Instruction::Instruction (const Span<const Byte> bytes, const Endianness endianness)
{
	if (bytes.size () < 4) return;
	const auto opcode = endianness == Endianness::Big ? Opcode (bytes[0]) << 24 | Opcode (bytes[1]) << 16 | Opcode (bytes[2]) << 8 | Opcode (bytes[3]) : Opcode (bytes[0]) | Opcode (bytes[1]) << 8 | Opcode (bytes[2]) << 16 | Opcode (bytes[3]) << 24;
	for (auto& entry: table)
		if ((opcode & entry.mask) == entry.opcode)
		{
			operand1.Decode (opcode, entry.type1);
			operand2.Decode (opcode, entry.type2);
			operand3.Decode (opcode, entry.type3);
			operand4.Decode (opcode, entry.type4);
			this->entry = &entry; return;
		}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o1, const Operand& o2, const Operand& o3, const Operand& o4) :
	entry {lookup[mnemonic]}, operand1 {o1}, operand2 {o2}, operand3 {o3}, operand4 {o4}
{
	if (!operand1.IsCompatibleWith (entry->type1) || !operand2.IsCompatibleWith (entry->type2) ||
		!operand3.IsCompatibleWith (entry->type3) || !operand4.IsCompatibleWith (entry->type4)) entry = nullptr;
}

void Instruction::Emit (const Span<Byte> bytes, const Endianness endianness) const
{
	assert (entry); assert (bytes.size () >= 4);
	const auto opcode = entry->opcode | operand1.Encode (entry->type1) | operand2.Encode (entry->type2) | operand3.Encode (entry->type3) | operand4.Encode (entry->type4);
	if (endianness == Endianness::Big) bytes[0] = opcode >> 24, bytes[1] = opcode >> 16, bytes[2] = opcode >> 8, bytes[3] = opcode;
	else bytes[0] = opcode, bytes[1] = opcode >> 8, bytes[2] = opcode >> 16, bytes[3] = opcode >> 24;
}

void Instruction::Adjust (Object::Patch& patch, const Endianness endianness) const
{
	assert (entry);
	if (entry->type2 == Operand::S016 || entry->type2 == Operand::U016 || entry->type3 == Operand::S016 || entry->type3 == Operand::U016) patch.pattern = {2, endianness};
	if (!IsEmpty (patch.pattern) && endianness == Endianness::Big) patch.offset += 2;
}

bool Instruction::IsLoadStore (const Mnemonic mnemonic)
{
	return lookup[mnemonic]->type3 == Operand::R21LS;
}

bool MIPS::IsValid (const Instruction& instruction, const Architecture architecture)
{
	return instruction.entry && architecture >= instruction.entry->architecture;
}

Register MIPS::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

std::istream& MIPS::operator >> (std::istream& stream, Register& register_)
{
	if (stream >> std::ws && stream.peek () == 'f') return ReadPrefixedValue (stream, register_, "f", F0, F31);
	return ReadPrefixedValue (stream, register_, "r", R0, R31);
}

std::ostream& MIPS::operator << (std::ostream& stream, const Register register_)
{
	if (register_ >= F0 && register_ <= F31) return WritePrefixedValue (stream, register_, "f", F0);
	return WritePrefixedValue (stream, register_, "r", R0);
}

std::istream& MIPS::operator >> (std::istream& stream, Operand& operand)
{
	union {Immediate immediate; Register register_;};
	if (stream >> std::ws && std::isalpha (stream.peek ()) && stream >> register_) operand = register_;
	else if (stream >> immediate) operand = immediate;
	return stream;
}

std::ostream& MIPS::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	default: return stream;
	}
}

std::istream& MIPS::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic;
	Operand operand1, operand2, operand3, operand4;

	if (stream >> mnemonic && stream.good () && stream >> std::ws && stream.good ())
		if (stream >> operand1 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
			if (stream >> operand2 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == (Instruction::IsLoadStore (mnemonic) ? '(' : ',') && stream.ignore ())
				if (stream >> operand3 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
					stream >> operand4;

	if (stream && Instruction::IsLoadStore (mnemonic) && stream >> std::ws && stream.get () != ')') stream.setstate (stream.failbit);
	if (stream) instruction = {mnemonic, operand1, operand2, operand3, operand4};
	return stream;
}

std::ostream& MIPS::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ", " << instruction.operand2 && !IsEmpty (instruction.operand3))
				if (stream << (Instruction::IsLoadStore (instruction.entry->mnemonic) ? " (" : ", ") << instruction.operand3 && !IsEmpty (instruction.operand4))
					stream << ", " << instruction.operand4;
	if (Instruction::IsLoadStore (instruction.entry->mnemonic)) stream << ')';
	return stream;
}

std::istream& MIPS::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsDotted);
}

std::ostream& MIPS::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

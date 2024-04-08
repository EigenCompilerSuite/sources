// PowerPC instruction set representation
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
#include "ppc.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace PowerPC;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type type1, type2, type3, type4, type5;
	Architecture architecture;
};

constexpr Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, mask, type1, type2, type3, type4, type5, architecture) \
		{Instruction::mnem, code, mask, Operand::type1, Operand::type2, Operand::type3, Operand::type4, Operand::type5, Architecture (architecture)},
	#include "ppc.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "ppc.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::lookup {table};

Operand::Operand (const PowerPC::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const PowerPC::Register r) :
	model {Register}, register_ {r}
{
}

void Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case BD: model = Immediate; immediate = PowerPC::Immediate (opcode & 0xfffc) << 16 >> 16; break;
	case BH: model = Immediate; immediate = PowerPC::Immediate (opcode >> 11 & 0x3); break;
	case BI: case CRBA: model = Immediate; immediate = PowerPC::Immediate (opcode >> 16 & 0x1f); break;
	case BO: case CRBD: case TO: model = Immediate; immediate = PowerPC::Immediate (opcode >> 21 & 0x1f); break;
	case CRBB: case NB: case SH: model = Immediate; immediate = PowerPC::Immediate (opcode >> 11 & 0x1f); break;
	case CRFD: model = Immediate; immediate = PowerPC::Immediate (opcode >> 23 & 0x7); break;
	case CRFS: model = Immediate; immediate = PowerPC::Immediate (opcode >> 18 & 0x7); break;
	case CRM: model = Immediate; immediate = PowerPC::Immediate (opcode >> 12 & 0xff); break;
	case D: case DS: case SIMM: model = Immediate; immediate = PowerPC::Immediate (opcode) << 16 >> 16; break;
	case FM: model = Immediate; immediate = PowerPC::Immediate (opcode >> 17 & 0xff); break;
	case FRA: model = Register; register_ = PowerPC::Register (FR0 + (opcode >> 16 & 0x1f)); break;
	case FRB: model = Register; register_ = PowerPC::Register (FR0 + (opcode >> 11 & 0x1f)); break;
	case FRC: model = Register; register_ = PowerPC::Register (FR0 + (opcode >> 6 & 0x1f)); break;
	case FRD: case FRS: model = Register; register_ = PowerPC::Register (FR0 + (opcode >> 21 & 0x1f)); break;
	case IMM: model = Immediate; immediate = PowerPC::Immediate (opcode >> 12 & 0xf); break;
	case L9: case TH: model = Immediate; immediate = PowerPC::Immediate (opcode >> 21 & 0x3); break;
	case L10: model = Immediate; immediate = PowerPC::Immediate (opcode >> 21 & 0x1); break;
	case L15: model = Immediate; immediate = PowerPC::Immediate (opcode >> 16 & 0x1); break;
	case LI: case LA: model = Immediate; immediate = PowerPC::Immediate (opcode & 0x3fffffc) << 6 >> 6; break;
	case MB: model = Immediate; immediate = PowerPC::Immediate (opcode >> 6 & 0x1f); break;
	case MBD: case MED: model = Immediate; immediate = PowerPC::Immediate (opcode >> 6 & 0x1f | opcode & 0x20); break;
	case ME: model = Immediate; immediate = PowerPC::Immediate (opcode >> 1 & 0x1f); break;
	case RA: model = Register; register_ = PowerPC::Register (R0 + (opcode >> 16 & 0x1f)); break;
	case RB: case RBS: model = Register; register_ = PowerPC::Register (R0 + (opcode >> 11 & 0x1f)); break;
	case RD: case RS: model = Register; register_ = PowerPC::Register (R0 + (opcode >> 21 & 0x1f)); break;
	case SIMMN: model = Immediate; immediate = -PowerPC::Immediate (opcode) << 16 >> 16; break;
	case SHD: model = Immediate; immediate = PowerPC::Immediate (opcode >> 11 & 0x1f | opcode << 4 & 0x20); break;
	case SPR: case TBR: model = Immediate; immediate = PowerPC::Immediate (opcode >> 16 & 0x1f | opcode >> 6 & 0x3e0); break;
	case SR: model = Immediate; immediate = PowerPC::Immediate (opcode >> 16 & 0xf); break;
	case UIMM: model = Immediate; immediate = PowerPC::Immediate (opcode & 0xffff); break;
	default: model = Empty;
	}
}

Opcode Operand::Encode (const Type type) const
{
	switch (type)
	{
	case BD: return Opcode (immediate & 0xfffc);
	case BH: case CRBB: case NB: case SH: return Opcode (immediate) << 11;
	case BI: case CRBA: case SR: case L15: return Opcode (immediate) << 16;
	case BO: case CRBD: case L9: case L10: case TH: case TO: return Opcode (immediate) << 21;
	case CRFD: return Opcode (immediate) << 23;
	case CRFS: return Opcode (immediate) << 18;
	case CRM: case IMM: return Opcode (immediate) << 12;
	case D: case DS: case SIMM: case UIMM: return Opcode (immediate & 0xffff);
	case FM: return Opcode (immediate) << 17;
	case FRA: return Opcode (register_ - FR0) << 16;
	case FRB: return Opcode (register_ - FR0) << 11;
	case FRC: return Opcode (register_ - FR0) << 6;
	case FRD: case FRS: return Opcode (register_ - FR0) << 21;
	case LI: case LA: return Opcode (immediate & 0x3fffffc);
	case MB: return Opcode (immediate) << 6;
	case MBD: case MED: return Opcode (immediate & 0x1f) << 6 | Opcode (immediate & 0x20);
	case ME: return Opcode (immediate) << 1;
	case RA: return Opcode (register_ - R0) << 16;
	case RB: return Opcode (register_ - R0) << 11;
	case RBS: return Opcode (register_ - R0) << 11 | Opcode (register_ - R0) << 21;
	case RD: case RS: return Opcode (register_ - R0) << 21;
	case SIMMN: return Opcode (-immediate & 0xffff);
	case SHD: return Opcode (immediate & 0x1f) << 11 | Opcode (immediate & 0x20) >> 4;
	case SPR: case TBR: return Opcode (immediate & 0x1f) << 16 | Opcode (immediate & 0x3e0) << 6;
	default: return 0;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case BD: case DS: return model == Immediate && immediate >= -32768 && immediate < 32768 && immediate % 4 == 0;
	case BH: case L9: case TH: return model == Immediate && immediate >= 0 && immediate < 4;
	case BI: case BO: case CRBA: case CRBB: case CRBD: case MB: case ME: case NB: case SH: case TO: return model == Immediate && immediate >= 0 && immediate < 32;
	case CRFD: case CRFS: return model == Immediate && immediate >= 0 && immediate < 8;
	case CRM: case FM: return model == Immediate && immediate >= 0 && immediate < 256;
	case D: case SIMM: case SIMMN: return model == Immediate && immediate >= -32768 && immediate < 32768;
	case FRA: case FRB: case FRC: case FRD: case FRS: return model == Register && register_ >= FR0 && register_ <= FR31;
	case IMM: case SR: return model == Immediate && immediate >= 0 && immediate < 16;
	case L10: case L15: return model == Immediate && immediate >= 0 && immediate < 2;
	case LI: case LA: return model == Immediate && immediate >= -33554432 && immediate < 33554432 && immediate % 4 == 0;
	case MBD: case MED: case SHD: return model == Immediate && immediate >= 0 && immediate < 64;
	case RA: case RB: case RBS: case RD: case RS: return model == Register && register_ >= R0 && register_ <= R31;
	case SPR: case TBR: return model == Immediate && immediate >= 0 && immediate < 1024;
	case UIMM: return model == Immediate && immediate >= 0 && immediate < 65536;
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
			operand4.Decode (opcode, entry.type4);
			operand5.Decode (opcode, entry.type5);
			this->entry = &entry; return;
		}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o1, const Operand& o2, const Operand& o3, const Operand& o4, const Operand& o5) :
	entry {lookup[mnemonic]}, operand1 {o1}, operand2 {o2}, operand3 {o3}, operand4 {o4}, operand5 {o5}
{
	if (!operand1.IsCompatibleWith (entry->type1) || !operand2.IsCompatibleWith (entry->type2) ||
		!operand3.IsCompatibleWith (entry->type3) || !operand4.IsCompatibleWith (entry->type4) || !operand5.IsCompatibleWith (entry->type5)) entry = nullptr;
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); assert (bytes.size () >= 4);
	const auto opcode = entry->opcode | operand1.Encode (entry->type1) | operand2.Encode (entry->type2) |
		operand3.Encode (entry->type3) | operand4.Encode (entry->type4) | operand5.Encode (entry->type5);
	bytes[0] = opcode >> 24; bytes[1] = opcode >> 16; bytes[2] = opcode >> 8; bytes[3] = opcode;
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	if (entry->type2 == Operand::SIMM || entry->type2 == Operand::UIMM || entry->type3 == Operand::SIMM || entry->type3 == Operand::UIMM) patch.offset += 2, patch.pattern = {{1, 0xff}, {0, 0xff}};
	if (entry->type1 == Operand::LI || entry->type1 == Operand::LA) patch.scale += 2, patch.pattern = {{3, 0xfc}, {2, 0xff}, {1, 0xff}, {0, 0x03}};
	if (entry->type1 == Operand::LI && patch.mode == Object::Patch::Absolute) patch.mode = Object::Patch::Relative;
}

bool Instruction::IsLoadStore (const Mnemonic mnemonic)
{
	return lookup[mnemonic]->type2 == Operand::D || lookup[mnemonic]->type2 == Operand::DS;
}

bool PowerPC::IsValid (const Instruction& instruction, const Architecture architecture)
{
	return instruction.entry && instruction.entry->architecture & architecture;
}

Register PowerPC::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

std::istream& PowerPC::operator >> (std::istream& stream, Register& register_)
{
	if (stream >> std::ws && stream.peek () == 'f') return ReadPrefixedValue (stream, register_, "fr", FR0, FR31);
	return ReadPrefixedValue (stream, register_, "r", R0, R31);
}

std::ostream& PowerPC::operator << (std::ostream& stream, const Register register_)
{
	if (register_ >= FR0 && register_ <= FR31) return WritePrefixedValue (stream, register_, "fr", FR0);
	return WritePrefixedValue (stream, register_, "r", R0);
}

std::istream& PowerPC::operator >> (std::istream& stream, Operand& operand)
{
	union {Immediate immediate; Register register_;};
	if (stream >> std::ws && std::isalpha (stream.peek ()) && stream >> register_) operand = register_;
	else if (stream >> immediate) operand = immediate;
	return stream;
}

std::ostream& PowerPC::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	default: return stream;
	}
}

std::istream& PowerPC::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic;
	Operand operand1, operand2, operand3, operand4, operand5;

	if (stream >> mnemonic && stream.good () && stream >> std::ws && stream.good ())
		if (stream >> operand1 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
			if (stream >> operand2 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == (Instruction::IsLoadStore (mnemonic) ? '(' : ',') && stream.ignore ())
				if (stream >> operand3 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
					if (stream >> operand4 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
						stream >> operand5;

	if (stream && Instruction::IsLoadStore (mnemonic) && stream >> std::ws && stream.get () != ')') stream.setstate (stream.failbit);
	if (stream) instruction = {mnemonic, operand1, operand2, operand3, operand4, operand5};
	return stream;
}

std::ostream& PowerPC::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ", " << instruction.operand2 && !IsEmpty (instruction.operand3))
				if (stream << (Instruction::IsLoadStore (instruction.entry->mnemonic) ? " (" : ", ") << instruction.operand3 && !IsEmpty (instruction.operand4))
					if (stream << ", " << instruction.operand4 && !IsEmpty (instruction.operand5))
						stream << ", " << instruction.operand5;

	if (Instruction::IsLoadStore (instruction.entry->mnemonic)) stream << ')';
	return stream;
}

std::istream& PowerPC::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsDotted);
}

std::ostream& PowerPC::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

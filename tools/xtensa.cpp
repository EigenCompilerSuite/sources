// Xtensa instruction set representation
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
#include "utilities.hpp"
#include "xtensa.hpp"
#include <cassert>

using namespace ECS;
using namespace Xtensa;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type type1, type2, type3, type4;
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "xtensa.def"
};

constexpr Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, mask, type1, type2, type3, type4) \
		{Instruction::mnem, code, mask, Operand::type1, Operand::type2, Operand::type3, Operand::type4},
	#include "xtensa.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::lookup {table};

const Immediate Operand::b4const[16] = {-1, 1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 16, 32, 64, 128, 256};
const Immediate Operand::b4constu[16] = {32768, 65536, 2, 3, 4, 5, 6, 7, 8, 10, 12, 16, 32, 64, 128, 256};

Operand::Operand (const Xtensa::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const Xtensa::Register r) :
	model {Register}, register_ {r}
{
}

void Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case A4: model = Register; register_ = Xtensa::Register (A0 + (opcode >> 4 & 0xf)); break;
	case A48: model = Register; register_ = Xtensa::Register (A0 + (opcode >> 4 & 0xf)); if (Xtensa::Register (A0 + (opcode >> 8 & 0xf)) != register_) model = Empty; break;
	case A8: model = Register; register_ = Xtensa::Register (A0 + (opcode >> 8 & 0xf)); break;
	case A12: model = Register; register_ = Xtensa::Register (A0 + (opcode >> 12 & 0xf)); break;
	case B4: model = Register; register_ = Xtensa::Register (B0 + (opcode >> 4 & 0xf)); break;
	case B8: model = Register; register_ = Xtensa::Register (B0 + (opcode >> 8 & 0xf)); break;
	case B12: model = Register; register_ = Xtensa::Register (B0 + (opcode >> 12 & 0xf)); break;
	case F4: model = Register; register_ = Xtensa::Register (F0 + (opcode >> 4 & 0xf)); break;
	case F8: model = Register; register_ = Xtensa::Register (F0 + (opcode >> 8 & 0xf)); break;
	case F12: model = Register; register_ = Xtensa::Register (F0 + (opcode >> 12 & 0xf)); break;
	case M6H: model = Register; register_ = Xtensa::Register (M2 + (opcode >> 6 & 0x1)); break;
	case M12: model = Register; register_ = Xtensa::Register (M0 + (opcode >> 12 & 0x3)); break;
	case M14L: model = Register; register_ = Xtensa::Register (M0 + (opcode >> 14 & 0x1)); break;
	case O412S2: model = Immediate; immediate = (Xtensa::Immediate (opcode >> 12 & 0xf) << 2) - 64; break;
	case O168Z2: model = Immediate; immediate = (Xtensa::Immediate (opcode >> 8 & 0xffff) << 2) - 262144; break;
	case S44: model = Immediate; immediate = Xtensa::Immediate (opcode) << 24 >> 28; break;
	case S44N: model = Immediate; immediate = Xtensa::Immediate (opcode >> 4 & 0xf); if (immediate == 0) immediate = -1; break;
	case S412B: model = Immediate; immediate = b4const[opcode >> 12 & 0xf]; break;
	case S7124: model = Immediate; immediate = Xtensa::Immediate (opcode >> 12 & 0xf | opcode >> 0 & 0x70); if (immediate >= 96) immediate -= 128; break;
	case S816: model = Immediate; immediate = Xtensa::Immediate (opcode) << 8 >> 24; break;
	case S816D4: model = Immediate; immediate = (Xtensa::Immediate (opcode) << 8 >> 24) + 4; break;
	case S816S8: model = Immediate; immediate = (Xtensa::Immediate (opcode) << 8 >> 24) << 8; break;
	case S1212D4: model = Immediate; immediate = (Xtensa::Immediate (opcode) << 8 >> 20) + 4; break;
	case S12168: model = Immediate; immediate = Xtensa::Immediate (opcode >> 16 & 0xff | opcode >> 0 & 0xf00) << 20 >> 20; break;
	case S186D4: model = Immediate; immediate = (Xtensa::Immediate (opcode) << 8 >> 14) + 4; break;
	case S186Z2D4: model = Immediate; immediate = ((Xtensa::Immediate (opcode) << 8 >> 14) << 2) + 4; break;
	case U44: model = Immediate; immediate = Xtensa::Immediate (opcode >> 4 & 0xf); break;
	case U44D7: model = Immediate; immediate = Xtensa::Immediate (opcode >> 4 & 0xf) + 7; break;
	case U48: model = Immediate; immediate = Xtensa::Immediate (opcode >> 8 & 0xf); break;
	case U412BU: model = Immediate; immediate = b4constu[opcode >> 12 & 0xf]; break;
	case U412S2: model = Immediate; immediate = Xtensa::Immediate (opcode >> 12 & 0xf) << 2; break;
	case U420D1: model = Immediate; immediate = Xtensa::Immediate (opcode >> 20 & 0xf) + 1; break;
	case U420S4: model = Immediate; immediate = Xtensa::Immediate (opcode >> 20 & 0xf) << 4; break;
	case U5412: model = Immediate; immediate = Xtensa::Immediate (opcode >> 4 & 0xf | opcode >> 8 & 0x10); break;
	case U5420N: model = Immediate; immediate = 32 - Xtensa::Immediate (opcode >> 4 & 0xf | opcode >> 16 & 0x10); break;
	case U584: model = Immediate; immediate = Xtensa::Immediate (opcode >> 8 & 0xf | opcode >> 0 & 0x10); break;
	case U5816: model = Immediate; immediate = Xtensa::Immediate (opcode >> 8 & 0xf | opcode >> 12 & 0x10); break;
	case U5820: model = Immediate; immediate = Xtensa::Immediate (opcode >> 8 & 0xf | opcode >> 16 & 0x10); break;
	case U6124D4: model = Immediate; immediate = Xtensa::Immediate (opcode >> 12 & 0xf | opcode >> 0 & 0x30) + 4; break;
	case U84: model = Immediate; immediate = Xtensa::Immediate (opcode >> 4 & 0xff); break;
	case U88: model = Immediate; immediate = Xtensa::Immediate (opcode >> 8 & 0xff); break;
	case U816: model = Immediate; immediate = Xtensa::Immediate (opcode >> 16 & 0xff); break;
	case U816D4: model = Immediate; immediate = Xtensa::Immediate (opcode >> 16 & 0xff) + 4; break;
	case U816S1: model = Immediate; immediate = Xtensa::Immediate (opcode >> 16 & 0xff) << 1; break;
	case U816S2: model = Immediate; immediate = Xtensa::Immediate (opcode >> 16 & 0xff) << 2; break;
	case U816S3: model = Immediate; immediate = Xtensa::Immediate (opcode >> 16 & 0xff) << 3; break;
	case U1212S3: model = Immediate; immediate = Xtensa::Immediate (opcode >> 12 & 0xfff) << 3; break;
	case U168: model = Immediate; immediate = Xtensa::Immediate (opcode >> 8 & 0xffff); break;
	default: model = Empty;
	}
}

Opcode Operand::Encode (const Type type) const
{
	switch (type)
	{
	case A4: return Opcode (register_ - A0) << 4;
	case A48: return Opcode (register_ - A0) << 4 | Opcode (register_ - A0) << 8;
	case A8: return Opcode (register_ - A0) << 8;
	case A12: return Opcode (register_ - A0) << 12;
	case B4: return Opcode (register_ - B0) << 4;
	case B8: return Opcode (register_ - B0) << 8;
	case B12: return Opcode (register_ - B0) << 12;
	case F4: return Opcode (register_ - F0) << 4;
	case F8: return Opcode (register_ - F0) << 8;
	case F12: return Opcode (register_ - F0) << 12;
	case M6H: return Opcode (register_ - M2) << 6;
	case M12: return Opcode (register_ - M0) << 12;
	case M14L: return Opcode (register_ - M0) << 14;
	case O412S2: return Opcode (immediate + 64 >> 2 & 0xf) << 12;
	case O168Z2: return Opcode (immediate + 262144 >> 2 & 0xffff) << 8;
	case S44: return Opcode (immediate & 0xf) << 4;
	case S44N: return Opcode (immediate == -1 ? 0 : immediate & 0xf) << 4;
	case S412B: return Opcode (std::find (b4const, b4const + 16, immediate) - b4const) << 12;
	case S7124: return Opcode (immediate & 0xf) << 12 | Opcode (immediate & 0x70) << 0;
	case S816: return Opcode (immediate & 0xff) << 16;
	case S816D4: return Opcode (immediate - 4 & 0xff) << 16;
	case S816S8: return Opcode (immediate >> 8 & 0xff) << 16;
	case S1212D4: return Opcode (immediate - 4 & 0xfff) << 12;
	case S12168: return Opcode (immediate & 0xff) << 16 | Opcode (immediate & 0xf00) << 0;
	case S186D4: return Opcode (immediate - 4 & 0x3ffff) << 6;
	case S186Z2D4: return Opcode (immediate - 4 >> 2 & 0x3ffff) << 6;
	case U44: return Opcode (immediate & 0xf) << 4;
	case U44D7: return Opcode (immediate - 7 & 0xf) << 4;
	case U48: return Opcode (immediate & 0xf) << 8;
	case U412BU: return Opcode (std::find (b4constu, b4constu + 16, immediate) - b4constu) << 12;
	case U412S2: return Opcode (immediate >> 2 & 0xf) << 12;
	case U420D1: return Opcode (immediate - 1 & 0xf) << 20;
	case U420S4: return Opcode (immediate >> 4 & 0xf) << 20;
	case U5412: return Opcode (immediate & 0xf) << 4 | Opcode (immediate & 0x10) << 8;
	case U5420N: return Opcode (32 - immediate & 0xf) << 4 | Opcode (32 - immediate & 0x10) << 16;
	case U584: return Opcode (immediate & 0xf) << 8 | Opcode (immediate & 0x10) << 0;
	case U5816: return Opcode (immediate & 0xf) << 8 | Opcode (immediate & 0x10) << 12;
	case U5820: return Opcode (immediate & 0xf) << 8 | Opcode (immediate & 0x10) << 16;
	case U6124D4: return Opcode (immediate - 4 & 0xf) << 12 | Opcode (immediate - 4 & 0x30) << 0;
	case U84: return Opcode (immediate & 0xff) << 4;
	case U88: return Opcode (immediate & 0xff) << 8;
	case U816: return Opcode (immediate & 0xff) << 16;
	case U816D4: return Opcode (immediate - 4 & 0xff) << 16;
	case U816S1: return Opcode (immediate >> 1 & 0xff) << 16;
	case U816S2: return Opcode (immediate >> 2 & 0xff) << 16;
	case U816S3: return Opcode (immediate >> 3 & 0xff) << 16;
	case U1212S3: return Opcode (immediate >> 3 & 0xfff) << 12;
	case U168: return Opcode (immediate & 0xffff) << 8;
	default: return 0;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case A4: case A48: case A8: case A12: return model == Register && register_ >= A0 && register_ <= A15;
	case B4: case B8: case B12: return model == Register && register_ >= B0 && register_ <= B15;
	case F4: case F8: case F12: return model == Register && register_ >= F0 && register_ <= F15;
	case M6H: return model == Register && register_ >= M2 && register_ <= M3;
	case M12: return model == Register && register_ >= M0 && register_ <= M3;
	case M14L: return model == Register && register_ >= M0 && register_ <= M1;
	case O412S2: return model == Immediate && immediate >= -64 && immediate <= -4 && immediate % 4 == 0;
	case O168Z2: return model == Immediate && (immediate >= -262144 && immediate <= -4 || immediate == 0);
	case S44: return model == Immediate && immediate >= -8 && immediate <= 7;
	case S44N: return model == Immediate && (immediate == -1 || immediate >= 1 && immediate <= 15);
	case S412B: return model == Immediate && std::find (b4const, b4const + 16, immediate) != b4const + 16;
	case S7124: return model == Immediate && immediate >= -32 && immediate <= 95;
	case S816: return model == Immediate && immediate >= -128 && immediate <= 127;
	case S816D4: return model == Immediate && immediate >= -124 && immediate <= 131;
	case S816S8: return model == Immediate && immediate >= -32768 && immediate <= 32512 && immediate % 256 == 0;
	case S1212D4: return model == Immediate && immediate >= -2044 && immediate <= 2051;
	case S12168: return model == Immediate && immediate >= -2048 && immediate <= 2047;
	case S186D4: return model == Immediate && immediate >= -131068 && immediate <= 131075;
	case S186Z2D4: return model == Immediate && immediate >= -524284 && immediate <= 524288;
	case U44: case U48: return model == Immediate && immediate >= 0 && immediate <= 15;
	case U44D7: return model == Immediate && immediate >= 7 && immediate <= 22;
	case U412BU: return model == Immediate && std::find (b4constu, b4constu + 16, immediate) != b4constu + 16;
	case U412S2: return model == Immediate && immediate >= 0 && immediate <= 60 && immediate % 4 == 0;
	case U420D1: return model == Immediate && immediate >= 1 && immediate <= 16;
	case U420S4: return model == Immediate && immediate >= 0 && immediate <= 240 && immediate % 16 == 0;
	case U5412: case U584: case U5816: case U5820: return model == Immediate && immediate >= 0 && immediate <= 31;
	case U5420N: return model == Immediate && immediate >= 1 && immediate <= 31;
	case U6124D4: return model == Immediate && (immediate >= 4 && immediate <= 67 || immediate == 0);
	case U84: case U88: case U816: return model == Immediate && immediate >= 0 && immediate <= 255;
	case U816D4: return model == Immediate && (immediate >= 4 && immediate <= 259 || immediate == 0);
	case U816S1: return model == Immediate && immediate >= 0 && immediate <= 510 && immediate % 2 == 0;
	case U816S2: return model == Immediate && immediate >= 0 && immediate <= 1020 && immediate % 4 == 0;
	case U816S3: return model == Immediate && immediate >= 0 && immediate <= 2040 && immediate % 8 == 0;
	case U1212S3: return model == Immediate && immediate >= 0 && immediate <= 32760 && immediate % 8 == 0;
	case U168: return model == Immediate && immediate >= 0 && immediate <= 65535;
	default: return model == Empty;
	}
}

Instruction::Instruction (const Span<const Byte> bytes)
{
	if (bytes.size () < 2 || !IsDense (bytes[0]) && bytes.size () < 3) return;
	const auto opcode = Opcode (bytes[0]) | Opcode (bytes[1]) << 8 | Opcode (!IsDense (bytes[0]) ? bytes[2] : 0) << 16;
	for (auto& entry: table) if ((opcode & entry.mask) == entry.opcode) {operand1.Decode (opcode, entry.type1); operand2.Decode (opcode, entry.type2); operand3.Decode (opcode, entry.type3); operand4.Decode (opcode, entry.type4); this->entry = &entry; return;}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o1, const Operand& o2, const Operand& o3, const Operand& o4) :
	entry {lookup[mnemonic]}, operand1 {o1}, operand2 {o2}, operand3 {o3}, operand4 {o4}
{
	if (!operand1.IsCompatibleWith (entry->type1) || !operand2.IsCompatibleWith (entry->type2) || !operand3.IsCompatibleWith (entry->type3) || !operand4.IsCompatibleWith (entry->type4) || (entry->mnemonic == DEPBITS || entry->mnemonic == EXTUI) && operand3.immediate + operand4.immediate > 32) entry = nullptr;
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); assert (bytes.size () >= GetSize (*this));
	const auto opcode = entry->opcode | operand1.Encode (entry->type1) | operand2.Encode (entry->type2) | operand3.Encode (entry->type3) | operand4.Encode (entry->type4);
	bytes[0] = opcode; bytes[1] = opcode >> 8; if (!IsDense (opcode)) bytes[2] = opcode >> 16;
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	if (entry->type1 == Operand::S186D4) if (patch.pattern = {{0, 0xc0}, {1, 0xff}, {2, 0xff}}, patch.mode == Object::Patch::Absolute) patch.mode = Object::Patch::Relative, patch.displacement -= 4;
	if (entry->type1 == Operand::S186Z2D4) if (patch.pattern = {{0, 0xc0}, {1, 0xff}, {2, 0xff}}, patch.mode == Object::Patch::Absolute) patch.mode = Object::Patch::Relative, patch.displacement -= 4, patch.scale += 2;
	if (entry->type2 == Operand::U168) patch.offset += 1, patch.pattern = {{0, 0xff}, {1, 0xff}};
}

bool Instruction::IsDense (const Opcode opcode)
{
	return opcode & 0x8 && (opcode & 0xf) != 0xe;
}

std::size_t Xtensa::GetSize (const Instruction& instruction)
{
	assert (instruction.entry); return Instruction::IsDense (instruction.entry->opcode) ? 2 : 3;
}

Register Xtensa::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

std::istream& Xtensa::operator >> (std::istream& stream, Register& register_)
{
	if (char c = 0; stream >> std::ws && stream.get (c) && c == 's' && stream.peek () == 'p') return register_ = SP, stream.ignore ();
	else if (c == 'b') return ReadPrefixedValue (stream.putback (c), register_, "b", B0, B15);
	else if (c == 'f') return ReadPrefixedValue (stream.putback (c), register_, "f", F0, F15);
	else if (c == 'm') return ReadPrefixedValue (stream.putback (c), register_, "m", M0, M3);
	else return ReadPrefixedValue (stream.putback (c), register_, "a", A0, A15);
}

std::ostream& Xtensa::operator << (std::ostream& stream, const Register register_)
{
	if (register_ == SP) return stream << "sp";
	else if (register_ >= B0 && register_ <= B15) return WritePrefixedValue (stream, register_, "b", B0);
	else if (register_ >= F0 && register_ <= F15) return WritePrefixedValue (stream, register_, "f", F0);
	else if (register_ >= M0 && register_ <= M3) return WritePrefixedValue (stream, register_, "m", M0);
	else return WritePrefixedValue (stream, register_, "a", A0);
}

std::istream& Xtensa::operator >> (std::istream& stream, Operand& operand)
{
	union {Immediate immediate; Register register_;};
	if (stream >> std::ws && std::isalpha (stream.peek ()) && stream >> register_) operand = register_;
	else if (stream >> immediate) operand = immediate;
	return stream;
}

std::ostream& Xtensa::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	default: return stream;
	}
}

std::istream& Xtensa::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic;
	Operand operand1, operand2, operand3, operand4;

	if (stream >> mnemonic && stream.good () && stream >> std::ws && stream.good ())
		if (stream >> operand1 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
			if (stream >> operand2 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
				if (stream >> operand3 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
					stream >> operand4;

	if (stream) instruction = {mnemonic, operand1, operand2, operand3, operand4};
	return stream;
}

std::ostream& Xtensa::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ", " << instruction.operand2 && !IsEmpty (instruction.operand3))
				if (stream << ", " << instruction.operand3 && !IsEmpty (instruction.operand4))
					stream << ", " << instruction.operand4;

	return stream;
}

std::istream& Xtensa::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsDotted);
}

std::ostream& Xtensa::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

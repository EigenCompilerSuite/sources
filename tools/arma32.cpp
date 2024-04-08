// ARM A32 instruction set representation
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

#include "arma32.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>
#include <cstring>

using namespace ECS;
using namespace ARM;
using namespace A32;

struct A32::Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type types[9];

	bool Match (const std::string&, ConditionCode&) const;
};

constexpr A32::Instruction::Entry A32::Instruction::table[] {
	#define INSTR(mnem, code, mask, type0, type1, type2, type3, type4, type5, type6, type7, type8) \
		{Instruction::mnem, code, mask, {Operand::type0, Operand::type1, Operand::type2, Operand::type3, Operand::type4, Operand::type5, Operand::type6, Operand::type7, Operand::type8}},
	#include "arma32.def"
};

const char*const A32::Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "arma32.def"
};

constexpr Lookup<A32::Instruction::Entry, A32::Instruction::Mnemonic> A32::Instruction::first {table}, A32::Instruction::last {table, 0};

A32::Operand::Operand (const ARM::Immediate i) :
	model {Immediate}, immediate {i}
{
}

A32::Operand::Operand (const ARM::Register r) :
	model {Register}, register_ {r}
{
}

A32::Operand::Operand (const ARM::RegisterList r) :
	model {RegisterList}, registerSet {r}
{
}

A32::Operand::Operand (const ARM::DoubleRegisterList r) :
	model {DoubleRegisterList}, registerSet {r}
{
}

A32::Operand::Operand (const ARM::SingleRegisterList r) :
	model {SingleRegisterList}, registerSet {r}
{
}

A32::Operand::Operand (const ARM::ShiftMode s) :
	model {ShiftMode}, shiftmode {s}
{
}

A32::Operand::Operand (const ARM::ConditionCode c) :
	model {ConditionCode}, code {c}
{
}

A32::Operand::Operand (const ARM::Coprocessor c) :
	model {Coprocessor}, coprocessor {c}
{
}

A32::Operand::Operand (const ARM::CoprocessorRegister r) :
	model {CoprocessorRegister}, coregister {r}
{
}

A32::Operand::Operand (const A32::CoprocessorOption c) :
	model {CoprocessorOption}, cooption {c}
{
}

A32::Operand::Operand (const char c) :
	model {Character}, character {c}
{
}

A32::Operand::Operand (const Model m, const ARM::Register r) :
	model {m}, register_ {r}
{
}

bool A32::Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case I03812: model = Immediate; immediate = ARM::Immediate (opcode & 0xf | opcode >> 4 & 0xfff0); break;
	case I04: model = Immediate; immediate = ARM::Immediate (opcode & 0xf); break;
	case I05: model = Immediate; immediate = ARM::Immediate (opcode & 0x1f); break;
	case I08R84: model = Immediate; immediate = ARM::Immediate (RotateRight (opcode & 0xff, (opcode >> 8 & 0xf) * 2)); break;
	case I024: model = Immediate; immediate = ARM::Immediate (opcode & 0xffffff); break;
	case I44: model = Immediate; immediate = ARM::Immediate (opcode >> 4 & 0xf); break;
	case I53: model = Immediate; immediate = ARM::Immediate (opcode >> 5 & 0x7); break;
	case I75: case I75W1: model = Immediate; immediate = ARM::Immediate (opcode >> 7 & 0x1f); break;
	case I75M32: model = Immediate; immediate = ARM::Immediate (opcode >> 7 & 0x1f); if (!immediate) immediate = 32; break;
	case I204: model = Immediate; immediate = ARM::Immediate (opcode >> 20 & 0xf); break;
	case I213: model = Immediate; immediate = ARM::Immediate (opcode >> 21 & 0x7); break;
	case O08T4U: model = Immediate; immediate = ARM::Immediate (opcode & 0xff) * 4; if (!(opcode >> 23 & 1)) immediate = -immediate; break;
	case O08HU: model = Immediate; immediate = ARM::Immediate (opcode >> 4 & 0xf0 | opcode & 0xf); if (!(opcode >> 23 & 1)) immediate = -immediate; break;
	case O012U: model = Immediate; immediate = ARM::Immediate (opcode & 0xfff); if (!(opcode >> 23 & 1)) immediate = -immediate; break;
	case O024T4: model = Immediate; immediate = ARM::Immediate (opcode << 8) >> 6; break;
	case R0: model = Register; register_ = ARM::Register (ARM::R0 + (opcode & 0xf)); break;
	case R0U: model = (opcode >> 23 & 1 ? Register : NegativeRegister); register_ = ARM::Register (ARM::R0 + (opcode & 0xf)); break;
	case R8: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 8 & 0xf)); break;
	case R12: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 12 & 0xf)); break;
	case R16: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); break;
	case RL0: case RL0SPC: case RL0WPC: model = RegisterList; registerSet = RegisterSet (opcode & 0xffff); break;
	case DRL12: model = DoubleRegisterList; registerSet = RegisterSet (1 << (opcode & 0xff) / 2) - 1 << (opcode >> 12 & 0xf); break;
	case SRL12: model = SingleRegisterList; registerSet = (opcode & 0xff) < 32 ? RegisterSet (1 << (opcode & 0xff)) - 1 << (opcode >> 11 & 0x1e | opcode >> 22 & 0x1) : 0; break;
	case D0: model = Register; register_ = ARM::Register (ARM::D0 + (opcode & 0xf)); break;
	case D12: model = Register; register_ = ARM::Register (ARM::D0 + (opcode >> 12 & 0xf)); break;
	case D16: model = Register; register_ = ARM::Register (ARM::D0 + (opcode >> 16 & 0xf)); break;
	case S0: model = Register; register_ = ARM::Register (ARM::S0 + (opcode << 1 & 0x1e | opcode >> 5 & 0x1)); break;
	case S12: model = Register; register_ = ARM::Register (ARM::S0 + (opcode >> 11 & 0x1e | opcode >> 22 & 0x1)); break;
	case S16: model = Register; register_ = ARM::Register (ARM::S0 + (opcode >> 15 & 0x1e | opcode >> 7 & 0x1)); break;
	case S5: case S5R: model = ShiftMode; shiftmode = ARM::ShiftMode (opcode >> 5 & 0x3); break;
	case SLSL: model = ShiftMode; shiftmode = LSL; break;
	case SROR: model = ShiftMode; shiftmode = ROR; break;
	case SRRX: model = ShiftMode; shiftmode = RRX; break;
	case CC28: model = ConditionCode; code = GetConditionCode (opcode >> 28 & 0xf); break;
	case C8: model = Coprocessor; coprocessor = ARM::Coprocessor (opcode >> 8 & 0xf); break;
	case CR0: model = CoprocessorRegister; coregister = ARM::CoprocessorRegister (opcode & 0xf); break;
	case CR12: model = CoprocessorRegister; coregister = ARM::CoprocessorRegister (opcode >> 12 & 0xf); break;
	case CR16: model = CoprocessorRegister; coregister = ARM::CoprocessorRegister (opcode >> 16 & 0xf); break;
	case CO0: model = CoprocessorOption; cooption = A32::CoprocessorOption (opcode & 0xff); break;
	case CLB: model = Character; character = '['; break;
	case CRB: model = Character; character = ']'; break;
	case CUP: model = Character; character = '!'; break;
	case CAR: model = Character; character = '^'; break;
	default: model = Empty;
	}

	return IsCompatibleWith (type);
}

Opcode A32::Operand::Encode (const Type type) const
{
	switch (type)
	{
	case I03812: return Opcode (immediate & 0xf) | Opcode (immediate >> 4) << 8;
	case I04: case I05: case I024: return Opcode (immediate);
	case I08R84: {const auto rotation = GetRotation (immediate); return RotateLeft (Opcode (immediate), rotation * 2) | Opcode (rotation) << 8;}
	case I44: return Opcode (immediate) << 4;
	case I53: return Opcode (immediate) << 5;
	case I75: case I75W1: return Opcode (immediate) << 7;
	case I75M32: return Opcode (immediate % 32) << 7;
	case I204: return Opcode (immediate) << 20;
	case I213: return Opcode (immediate) << 21;
	case O08T4U: return Opcode (std::abs (immediate >> 2) & 0xff) | Opcode (immediate >= 0) << 23;
	case O08HU: return Opcode (std::abs (immediate) & 0xf) | Opcode (std::abs (immediate << 4) & 0xf00) | Opcode (immediate >= 0) << 23;
	case O012U: return Opcode (std::abs (immediate) & 0xfff) | Opcode (immediate >= 0) << 23;
	case O024T4: return Opcode ((immediate >> 2) & 0xffffff);
	case R0: return Opcode (register_ - ARM::R0);
	case R0U: return Opcode (register_ - ARM::R0) | Opcode (model != NegativeRegister) << 23;
	case R8: return Opcode (register_ - ARM::R0) << 8;
	case R12: return Opcode (register_ - ARM::R0) << 12;
	case R16: return Opcode (register_ - ARM::R0) << 16;
	case RL0: case RL0SPC: case RL0WPC: return Opcode (registerSet);
	case DRL12: return Opcode (CountTrailingZeros (registerSet)) << 12 | Opcode (CountOnes (registerSet) * 2);
	case SRL12: return Opcode (CountTrailingZeros (registerSet)) << 11 & 0xf000 | Opcode (CountTrailingZeros (registerSet)) << 22 & 0x400000 | Opcode (CountOnes (registerSet));
	case D0: return Opcode (register_ - ARM::D0);
	case D12: return Opcode (register_ - ARM::D0) << 12;
	case D16: return Opcode (register_ - ARM::D0) << 16;
	case S0: return Opcode (register_ - ARM::S0 >> 1 & 0xf) | Opcode (register_ - ARM::S0) << 5 & 0x20;
	case S12: return Opcode (register_ - ARM::S0) << 11 & 0xf000 | Opcode (register_ - ARM::S0) << 22 & 0x400000;
	case S16: return Opcode (register_ - ARM::S0) << 15 & 0xf0000 | Opcode (register_ - ARM::S0) << 7 & 0x80;
	case S5: case S5R: return Opcode (shiftmode) << 5;
	case CC28: return Opcode (GetValue (code)) << 28;
	case C8: return Opcode (coprocessor) << 8;
	case CR0: return Opcode (coregister);
	case CR12: return Opcode (coregister) << 12;
	case CR16: return Opcode (coregister) << 16;
	case CO0: return Opcode (cooption);
	default: return 0;
	}
}

bool A32::Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case I03812: return model == Immediate && immediate >= 0 && immediate < 65536;
	case I04: case I44: case I204: return model == Immediate && immediate >= 0 && immediate < 16;
	case I05: case I75: return model == Immediate && immediate >= 0 && immediate < 32;
	case I08R84: return model == Immediate && GetRotation (immediate) != 16;
	case I024: return model == Immediate && immediate >= 0 && immediate < 16777216;
	case I53: case I213: return model == Immediate && immediate >= 0 && immediate < 8;
	case I75W1: return model == Immediate && immediate > 0 && immediate < 32;
	case I75M32: return model == Immediate && immediate > 0 && immediate <= 32;
	case O08T4U: return model == Immediate && immediate > -1024 && immediate < 1024 && immediate % 4 == 0;
	case O08HU: return model == Immediate && immediate > -256 && immediate < 256;
	case O012U: return model == Immediate && immediate > -4096 && immediate < 4096;
	case O024T4: return model == Immediate && immediate >= -33554432 && immediate < 33554432 && immediate % 4 == 0;
	case R0: case R8: case R12: case R16: return model == Register && register_ >= ARM::R0 && register_ <= R15;
	case R0U: return (model == Register || model == NegativeRegister) && register_ >= ARM::R0 && register_ <= R15;
	case RL0: return model == RegisterList;
	case RL0SPC: return model == RegisterList && !(registerSet & 0x8000);
	case RL0WPC: return model == RegisterList && (registerSet & 0x8000);
	case DRL12: return model == DoubleRegisterList && registerSet && CountOnes ((registerSet >> CountTrailingZeros (registerSet)) + 1) == 1;
	case SRL12: return model == SingleRegisterList && registerSet && CountOnes ((registerSet >> CountTrailingZeros (registerSet)) + 1) <= 1;
	case D0: case D12: case D16: return model == Register && register_ >= ARM::D0 && register_ <= D15;
	case S0: case S12: case S16: return model == Register && register_ >= ARM::S0 && register_ <= S31;
	case S5: return model == ShiftMode && shiftmode != RRX;
	case S5R: return model == ShiftMode && shiftmode >= LSR && shiftmode <= ASR;
	case SLSL: return model == ShiftMode && shiftmode == LSL;
	case SROR: return model == ShiftMode && shiftmode == ROR;
	case SRRX: return model == ShiftMode && shiftmode == RRX;
	case CC28: return model == ConditionCode && code != NV;
	case C8: return model == Coprocessor;
	case CR0: case CR12: case CR16: return model == CoprocessorRegister;
	case CO0: return model == CoprocessorOption;
	case CLB: return model == Character && character == '[';
	case CRB: return model == Character && character == ']';
	case CUP: return model == Character && character == '!';
	case CAR: return model == Character && character == '^';
	default: return model == Empty;
	}
}

A32::Instruction::Instruction (const Span<const Byte> bytes)
{
	if (bytes.size () < 4) return;
	const auto opcode = Opcode (bytes[0]) | Opcode (bytes[1]) << 8 | Opcode (bytes[2]) << 16 | Opcode (bytes[3]) << 24;
	for (auto& entry: table) if ((opcode & entry.mask) == entry.opcode)
		for (auto& operand: operands) if (!operand.Decode (opcode, entry.types[GetIndex (operand, operands)])) break;
			else if (IsLast (operand, operands)) {this->entry = &entry; return;}
}

A32::Instruction::Instruction (const Mnemonic mnemonic, const Operand& o0, const Operand& o1, const Operand& o2, const Operand& o3,
	const Operand& o4, const Operand& o5, const Operand& o6, const Operand& o7, const Operand& o8) :
	operands {o0, o1, o2, o3, o4, o5, o6, o7, o8}
{
	for (auto& entry: Span<const Entry> {first[mnemonic], last[mnemonic]})
		for (auto& operand: operands) if (!operand.IsCompatibleWith (entry.types[GetIndex (operand, operands)])) break;
			else if (IsLast (operand, operands)) {this->entry = &entry; return;}
}

void A32::Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); assert (bytes.size () >= 4); auto opcode = entry->opcode;
	for (auto& operand: operands) opcode |= operand.Encode (entry->types[GetIndex (operand, operands)]);
	bytes[0] = opcode; bytes[1] = opcode >> 8; bytes[2] = opcode >> 16; bytes[3] = opcode >> 24;
}

void A32::Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry); if (entry->types[0] != Operand::O024T4 && entry->types[1] != Operand::O024T4) return;
	if (patch.mode == Object::Patch::Absolute) patch.displacement -= 8, patch.scale = 2, patch.mode = Object::Patch::Relative;
	patch.pattern = {3, Endianness::Little};
}

bool A32::IsSeparator (const Operand& operand)
{
	return operand.model == Operand::ShiftMode && operand.shiftmode != RRX || operand.model == Operand::Character && operand.character == '[';
}

bool A32::IsSeparated (const Operand& operand)
{
	return operand.model == Operand::Character && operand.character == '[';
}

bool A32::NeedsSeparator (const Operand& operand)
{
	return operand.model != Operand::Character || operand.character != ']' && operand.character != '!' && operand.character != '^';
}

Immediate A32::GetRotation (const Immediate value)
{
	unsigned rotation = 0; for (Opcode mask = value; mask >= 256 && rotation != 16; mask = RotateLeft (mask, 2)) ++rotation; return rotation;
}

Register A32::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

A32::Operand A32::operator - (const Register register_)
{
	return {Operand::NegativeRegister, register_};
}

std::istream& A32::operator >> (std::istream& stream, CoprocessorOption& option)
{
	unsigned value;
	if (stream >> std::ws && stream.get () == '{' && stream >> value >> std::ws && value < 256 && stream.get () == '}') option = CoprocessorOption (value);
	else stream.setstate (stream.failbit); return stream;
}

std::ostream& A32::operator << (std::ostream& stream, const CoprocessorOption option)
{
	return stream << '{' << unsigned (option) << '}';
}

std::istream& A32::operator >> (std::istream& stream, Operand& operand)
{
	char c = 0, d; std::uint32_t value; Register register_;
	RegisterList registerList; ShiftMode shiftmode; ConditionCode code;
	Coprocessor coprocessor; CoprocessorRegister coregister; CoprocessorOption cooption;
	DoubleRegisterList doubleRegisterList; SingleRegisterList singleRegisterList;
	if (stream >> c && c == '[' || c == ']' || c == '!' || c == '^') return operand = c, stream;
	if (std::isdigit (stream.peek ()))
		if ((c == 'r' || c == 'd' || c == 's') && stream.putback (c) && stream >> register_) return operand = register_, stream;
		else if (c == 'p' && stream.putback ('p') && stream >> coprocessor) return operand = coprocessor, stream;
		else if (c == 'c' && stream.putback ('c') && stream >> coregister) return operand = coregister, stream;
		else if (c == '{' && stream.putback ('{') && stream >> cooption) return operand = cooption, stream;
	if (std::isalpha (c) && std::isalpha (stream.peek ()) && stream.get (d))
		if (c == 's' && d == 'p') operand = SP; else if (c == 'l' && d == 'r') operand = LR; else if (c == 'p' && d == 'c') operand = PC;
		else if (stream.good () && std::isalpha (stream.peek ())) if (stream.putback (d).putback (c) >> shiftmode) operand = shiftmode; else;
		else if (stream.putback (d).putback (c) >> code) operand = code; else;
	else if (c == '{' && stream >> std::ws)
		if (stream.peek () == 'd' && stream.putback ('{') >> doubleRegisterList) operand = doubleRegisterList;
		else if (stream.peek () == 's' && stream.putback ('{') >> singleRegisterList) operand = singleRegisterList;
		else if (stream.putback ('{') >> registerList) operand = registerList; else stream.setstate (stream.failbit);
	else if (c == '+' && stream >> std::ws)
		if (std::isalpha (stream.peek ()) && stream >> register_) operand = register_; else if (stream >> value) operand = Immediate (value); else return stream;
	else if (c == '-' && stream >> std::ws)
		if (std::isalpha (stream.peek ()) && stream >> register_) operand = -register_; else if (stream >> value) operand = -Immediate (value); else return stream;
	else if (stream.putback (c) >> value) operand = Immediate (value); return stream;
}

std::ostream& A32::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	case Operand::NegativeRegister: return stream << '-' << operand.register_;
	case Operand::RegisterList: return stream << RegisterList {operand.registerSet};
	case Operand::DoubleRegisterList: return stream << DoubleRegisterList {operand.registerSet};
	case Operand::SingleRegisterList: return stream << SingleRegisterList {operand.registerSet};
	case Operand::ShiftMode: return stream << operand.shiftmode;
	case Operand::ConditionCode: return stream << operand.code;
	case Operand::Coprocessor: return stream << operand.coprocessor;
	case Operand::CoprocessorRegister: return stream << operand.coregister;
	case Operand::CoprocessorOption: return stream << operand.cooption;
	case Operand::Character: return stream << operand.character;
	default: return stream;
	}
}

std::istream& A32::operator >> (std::istream& stream, Instruction& instruction)
{
	std::string identifier; if (!(stream >> identifier)) return stream;

	auto mnemonic = Instruction::FirstMnemonic; ConditionCode code;
	for (; mnemonic != Instruction::LastMnemonic; mnemonic = Instruction::Mnemonic (mnemonic + 1))
	{
		const auto length = std::strlen (Instruction::mnemonics[mnemonic]);
		if (identifier.size () < length || identifier.compare (0, length, Instruction::mnemonics[mnemonic])) continue;
		if (identifier.size () == length + (HasConditionCode (identifier, length, code) && code) * 2) break;
	}

	if (mnemonic == Instruction::LastMnemonic) stream.setstate (stream.failbit);

	std::size_t index = 0; std::array<Operand, 9> operands;
	if (stream && code) operands[index++] = code;
	if (stream.good () && stream >> std::ws && stream.good ())
		while (index != 9 && stream >> operands[index] && stream.good () && stream >> std::ws && stream.good () && (!NeedsSeparator (char (stream.peek ())) || IsSeparator (operands[index]) || stream.peek () == ',' && stream.ignore ())) ++index;

	if (stream) instruction = {mnemonic, operands[0], operands[1], operands[2], operands[3], operands[4], operands[5], operands[6], operands[7], operands[8]};

	return stream;
}

std::ostream& A32::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);

	std::size_t index = 0;
	WriteEnum (stream, instruction.entry->mnemonic, Instruction::mnemonics);
	if (instruction.entry->types[index] == Operand::CC28) stream << instruction.operands[index++];

	for (auto first = true; index != 9 && !IsEmpty (instruction.operands[index]); stream << instruction.operands[index++])
		if (NeedsSeparator (instruction.operands[index]))
			if (index && IsSeparator (instruction.operands[index - 1])) IsSeparated (instruction.operands[index - 1]) ? stream : stream << ' ';
			else if (first) first = false, stream << '\t'; else stream << ", ";

	return stream;
}

std::ostream& A32::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

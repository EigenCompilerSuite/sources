// AVR instruction set representation
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

#include "avr.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace AVR;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type type1, type2;
	Opcode mask1, mask2;
};

const unsigned char Operand::bits[] {
	#define TYPE(type, bits) bits,
	#include "avr.def"
};

constexpr Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, mask, type1, mask1, type2, mask2) \
		{Instruction::mnem, code, mask, Operand::type1, Operand::type2, mask1, mask2},
	#include "avr.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "avr.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::first {table}, Instruction::last {table, 0};

Operand::Operand (const Type t) :
	type {t}
{
}

Operand::Operand (const signed s) :
	type {SImm12}, simm {s}
{
}

Operand::Operand (const unsigned i) :
	type {Imm22}, imm {i}
{
}

Operand::Operand (const Register r) :
	type {R}, register_ {r}
{
}

RegisterPair::RegisterPair (const Register r) :
	Operand {Rp}
{
	assert (r % 2 == 0);
	register_ = r;
}

Y::Y (const unsigned i) :
	Operand {YImm}
{
	imm = i;
}

Z::Z (const unsigned i) :
	Operand {ZImm}
{
	imm = i;
}

Operand::Operand (const Type t, const Value value) :
	type {t}
{
	switch (type)
	{
	case Imm3: case Imm5: case Imm6: case Imm8: case Imm16: case Imm22: case YImm: case ZImm:
		assert (value < 1u << bits[type]);
		imm = value; break;
	case SImm7: case SImm12:
		assert (value < 1u << bits[type]);
		simm = (value >= 1u << (bits[type] - 1) ? value - (1 << (bits[type])) : value) << 1; break;
	case R:
		assert (value < 32);
		register_ = Register (value); break;
	case R16: case R1623:
		assert (value < 16);
		register_ = Register (value + 16); break;
	case Rp:
		assert (value < 16);
		register_ = Register (value * 2); break;
	case Rp24:
		assert (value < 4);
		register_ = Register (value * 2 + 24); break;
	}
}

void Operand::Convert (const Type t)
{
	assert (IsCompatibleWith (t));
	type = t;
}

bool Operand::IsCompatibleWith (const Type t) const
{
	switch (type)
	{
	case Imm3: case Imm5: case Imm6: case Imm8: case Imm16: case Imm22:
		return (t == Imm3 || t == Imm5 || t == Imm6 || t == Imm8 || t == Imm16 || t == Imm22) && imm < (1u << bits[t]) ||
			(t == SImm7 || t == SImm12) && imm < (1u << (bits[t] - 1));
	case SImm7: case SImm12:
		return (t == Imm3 || t == Imm5 || t == Imm6 || t == Imm8 || t == Imm16 || t == Imm22) && simm >= 0 && simm < (1 << bits[t]) ||
			(t == SImm7 || t == SImm12) && simm >= signed (-1u << bits[t]) && simm < signed (1u << bits[t]);
	case R: case R16: case R1623:
		return t == R || t == R16 && register_ >= 16 || t == R1623 && register_ >= 16 && register_ < 24;
	case Operand::Rp: case Operand::Rp24:
		return t == Rp || t == Rp24 && register_ >= 24;
	case YImm: case ZImm:
		return t == type && imm < (1u << bits[t]);
	default:
		return t == type;
	}
}

Operand::Value Operand::GetValue () const
{
	Value value;

	switch (type)
	{
	case Imm3: case Imm5: case Imm6: case Imm8: case Imm16: case Imm22: case YImm: case ZImm:
		value = imm; break;
	case SImm7: case SImm12:
		value = simm < 0 ? (1 << (bits[type])) + (simm >> 1) : simm >> 1; break;
	case R:
		value = register_; break;
	case R16: case R1623:
		value = register_ - 16; break;
	case Rp:
		value = register_ / 2; break;
	case Rp24:
		value = (register_ - 24) / 2; break;
	default:
		value = 0;
	}

	assert (value < (1u << bits[type]));
	return value;
}

Instruction::Instruction (const Span<const Byte> bytes)
{
	auto byte = bytes.begin ();
	for (Opcode opcode = 0, mask = 0xffff; mask; opcode <<= 16, mask <<= 16)
	{
		if (byte == bytes.end ()) break;
		opcode |= *byte++;

		if (byte == bytes.end ()) break;
		opcode |= *byte++ << 8;

		for (auto& entry: table)
			if (entry.mask & mask && (opcode & entry.mask) == entry.opcode)
			{
				operand1 = {entry.type1, DecodeBits (opcode, entry.mask1)};
				if (entry.mask2 && !entry.type2 && operand1.GetValue () != Operand {entry.type1, DecodeBits (opcode, entry.mask2)}.GetValue ()) continue;
				operand2 = {entry.type2, DecodeBits (opcode, entry.mask2)};
				this->entry = &entry; return;
			}
	}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o1, const Operand& o2)
{
	for (auto& entry: Span<const Entry> {first[mnemonic], last[mnemonic]})
		if (o1.IsCompatibleWith (entry.type1) && o2.IsCompatibleWith (entry.type2))
		{
			operand1 = o1; operand1.Convert (entry.type1);
			operand2 = o2; operand2.Convert (entry.type2);
			this->entry = &entry; return;
		}
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); const auto size = GetSize (*this); assert (bytes.size () >= size);
	auto opcode = entry->opcode | EncodeBits (operand1.GetValue (), entry->mask1) | EncodeBits ((entry->mask2 && !entry->type2 ? operand1 : operand2).GetValue (), entry->mask2);
	if (entry->mnemonic == CBR) opcode ^= entry->mask2;
	if (size == 4) bytes[0] = opcode >> 16, bytes[1] = opcode >> 24;
	bytes[size - 2] = opcode; bytes[size - 1] = opcode >> 8;
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry); auto size = GetSize (*this); Opcode mask;
	if (entry->type1 == Operand::Imm16 || entry->type1 == Operand::Imm22 || entry->type1 == Operand::SImm12) mask = entry->mask1;
	else if (entry->type2 == Operand::Imm8 || entry->type2 == Operand::Imm16) mask = entry->mask2; else return;
	if (entry->type1 == Operand::Imm22 && patch.mode == Object::Patch::Absolute) patch.scale += 1;
	if (entry->type1 == Operand::SImm12 && patch.mode == Object::Patch::Absolute) patch.displacement -= GetSize (*this), patch.scale += 1, patch.mode = Object::Patch::Relative;
	if (size == 4 && mask >> 16 == 0) patch.offset += 2, size -= 2;
	patch.pattern = {{Byte (size - 2), Byte (mask)}, {Byte (size - 1), Byte (mask >> 8)}};
	if (size == 4) patch.pattern += {0, Byte (mask >> 16)}, patch.pattern += {1, Byte (mask >> 24)};
}

bool AVR::IsRegisterPair (const Register low, const Register high)
{
	return low % 2 == 0 && high == low + 1;
}

std::size_t AVR::GetSize (const Instruction& instruction)
{
	assert (instruction.entry);
	return instruction.entry->mask >> 16 ? 4 : 2;
}

std::istream& AVR::operator >> (std::istream& stream, Register& register_)
{
	return ReadPrefixedValue (stream, register_, "r", R0, R31);
}

std::ostream& AVR::operator << (std::ostream& stream, const Register register_)
{
	return WritePrefixedValue (stream, register_, "r", R0);
}

std::istream& AVR::operator >> (std::istream& stream, Operand& operand)
{
	char character;
	if (!(stream >> character)) return stream;

	signed simm; unsigned imm;
	Register register_, low;

	switch (character)
	{
	case 'r':
		stream.putback (character);
		if (stream >> register_) operand = register_;
		if (stream.good () && stream.peek () == ':' && stream.get (character) >> low)
			if (IsRegisterPair (low, register_)) operand = RegisterPair {low}; else stream.setstate (stream.failbit);
		return stream;

	case '-':
		if (stream.good () && stream.peek () == 'X' && stream.get (character)) operand = Operand::Xd;
		else if (stream.good () && stream.peek () == 'Y' && stream.get (character)) operand = Operand::Yd;
		else if (stream.good () && stream.peek () == 'Z' && stream.get (character)) operand = Operand::Zd;
		else if (stream.putback (character) >> simm) operand = simm;
		return stream;

	case 'X':
		operand = stream.good () && stream.peek () == '+' && stream.get (character) ? Operand::Xi : Operand::X;
		return stream;

	case 'Y': case 'Z':
		if (stream.good () && stream.peek () == '+' && stream.ignore ())
			if (stream.good () && stream >> std::ws && stream.good () && std::isdigit (stream.peek ()) && stream >> imm) if (character == 'Y') operand = Y {imm}; else operand = Z {imm};
			else operand = character == 'Y' ? Operand::Yi : Operand::Zi;
		else operand = character == 'Y' ? Operand::Y : Operand::Z;
		return stream;

	default:
		if (stream.putback (character) >> imm) operand = imm;
		return stream;
	}
}

std::ostream& AVR::operator << (std::ostream& stream, const Operand& operand)
{
	const auto flags = stream.flags ();
	switch (operand.type)
	{
	case Operand::Imm3: case Operand::Imm5: case Operand::Imm6:
	case Operand::Imm8: case Operand::Imm16: case Operand::Imm22:
		return stream << operand.imm;
	case Operand::SImm7: case Operand::SImm12:
		stream << std::showpos << operand.simm; stream.flags (flags); return stream;
	case Operand::R: case Operand::R16: case Operand::R1623:
		return stream << operand.register_;
	case Operand::Rp: case Operand::Rp24:
		return stream << Register (operand.register_ + 1) << ':' << operand.register_;
	case Operand::Xd:
		stream << '-';
	case Operand::X: case Operand::Xi:
		stream << 'X';
		if (operand.type == Operand::Xi) stream << '+';
		return stream;
	case Operand::Yd:
		stream << '-';
	case Operand::Y: case Operand::Yi: case Operand::YImm:
		stream << 'Y' << std::dec << std::noshowpos;
		if (operand.type == Operand::Yi) stream << '+';
		else if (operand.type == Operand::YImm) stream << '+' << operand.imm;
		stream.flags (flags); return stream;
	case Operand::Zd:
		stream << '-';
	case Operand::Z: case Operand::Zi: case Operand::ZImm:
		stream << 'Z' << std::dec << std::noshowpos;
		if (operand.type == Operand::Zi) stream << '+';
		else if (operand.type == Operand::ZImm) stream << '+' << operand.imm;
		stream.flags (flags); return stream;
	default:
		return stream;
	}
}

std::istream& AVR::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic;
	Operand operand1, operand2;

	if (stream >> mnemonic && stream.good () && stream >> std::ws && stream.good ())
		if (stream >> operand1 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
			stream >> operand2;

	if (stream) instruction = {mnemonic, operand1, operand2};
	return stream;
}

std::ostream& AVR::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			stream << ", " << instruction.operand2;
	return stream;
}

std::istream& AVR::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsAlpha);
}

std::ostream& AVR::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

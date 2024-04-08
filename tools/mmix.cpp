// MMIX instruction set representation
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

#include "mmix.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace MMIX;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Byte opcode;
	Format format;
};

constexpr Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, opcode, format) \
		{Instruction::mnem, opcode, format},
	#include "mmix.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "mmix.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::lookup {table};

Operand::Operand (const MMIX::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const MMIX::Register r) :
	model {Register}, register_ {r}
{
}

Instruction::Instruction (const Span<const Byte> bytes)
{
	if (bytes.size () < 4) return;
	for (entry = std::begin (table); entry != std::end (table); ++entry) if (entry->opcode == bytes[0]) break;
	switch (entry->format)
	{
	case RXRYRZ: case RXRYRIZ: operand1 = Register (bytes[1]); operand2 = Register (bytes[2]); operand3 = Register (bytes[3]); break;
	case RXRYIZ: operand1 = Register (bytes[1]); operand2 = Register (bytes[2]); operand3 = Immediate (bytes[3]); break;
	case RXIYRZ: case RXIYRIZ: operand1 = Register (bytes[1]); operand2 = Immediate (bytes[2]); operand3 = Register (bytes[3]); break;
	case RXIYIZ: operand1 = Register (bytes[1]); operand2 = Immediate (bytes[2]); operand3 = Immediate (bytes[3]); break;
	case RXIYZ: operand1 = Register (bytes[1]); operand2 = Immediate (bytes[2]) << 8 | Immediate (bytes[3]); break;
	case RXIZ: operand1 = Register (bytes[1]); operand2 = Immediate (bytes[3]); break;
	case RXDYZ: operand1 = Register (bytes[1]); operand2 = Immediate (bytes[2]) << 10 | Immediate (bytes[3]) << 2; break;
	case RX: operand1 = Register (bytes[1]); break;
	case IXRYRIZ: operand1 = Immediate (bytes[1]); operand2 = Register (bytes[2]); operand3 = Register (bytes[3]); break;
	case IXRYIZ: operand1 = Immediate (bytes[1]); operand2 = Register (bytes[2]); operand3 = Immediate (bytes[3]); break;
	case IXIYIZ: operand1 = Immediate (bytes[1]); operand2 = Immediate (bytes[2]); operand3 = Immediate (bytes[3]); break;
	case IXRIZ: operand1 = Immediate (bytes[1]); operand2 = Register (bytes[3]); break;
	case IXIZ: operand1 = Immediate (bytes[1]); operand2 = Immediate (bytes[3]); break;
	case IZ: operand1 = Immediate (bytes[3]); break;
	case DXYZ: operand1 = Immediate (bytes[1]) << 18 | Immediate (bytes[2]) << 10 | Immediate (bytes[3]) << 2; break;
	}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o1, const Operand& o2, const Operand& o3) :
	entry {lookup[mnemonic]}, operand1 {o1}, operand2 {o2}, operand3 {o3}
{
	switch (entry->format)
	{
	case RXRYRZ: if (IsR (operand1) && IsR (operand2) && IsR (operand3)) return; break;
	case RXRYRIZ: if (IsR (operand1) && IsR (operand2) && (IsR (operand3) || IsI1 (operand3))) return; break;
	case RXRYIZ: if (IsR (operand1) && IsR (operand2) && IsI1 (operand3)) return; break;
	case RXIYRZ: if (IsR (operand1) && IsI1 (operand2) && IsR (operand3)) return; break;
	case RXIYRIZ: if (IsR (operand1) && IsI1 (operand2) && (IsR (operand3) || IsI1 (operand3))) return; break;
	case RXIYIZ: if (IsR (operand1) && IsI1 (operand2) && IsI1 (operand3)) return; break;
	case RXIYZ: if (IsR (operand1) && IsI2 (operand2) && IsEmpty (operand3)) return; break;
	case RXIZ: if (IsR (operand1) && IsI1 (operand2) && IsEmpty (operand3)) return; break;
	case RXDYZ: if (IsR (operand1) && IsD2 (operand2) && IsEmpty (operand3)) return; break;
	case RX: if (IsR (operand1) && IsEmpty (operand2) && IsEmpty (operand3)) return; break;
	case IXRYRIZ: if (IsI1 (operand1) && IsR (operand2) && (IsR (operand3) || IsI1 (operand3))) return; break;
	case IXRYIZ: if (IsI1 (operand1) && IsR (operand2) && IsI1 (operand3)) return; break;
	case IXIYIZ: if (IsI1 (operand1) && IsI1 (operand2) && IsI1 (operand3)) return; break;
	case IXRIZ: if (IsI1 (operand1) && (IsR (operand2) || IsI1 (operand2)) && IsEmpty (operand3)) return; break;
	case IXIZ: if (IsI1 (operand1) && IsI1 (operand2) && IsEmpty (operand3)) return; break;
	case IZ: if (IsI1 (operand1) && IsEmpty (operand2) && IsEmpty (operand3)) return; break;
	case DXYZ: if (IsD3 (operand1) && IsEmpty (operand2) && IsEmpty (operand3)) return; break;
	}
	entry = nullptr;
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry);
	assert (bytes.size () >= 4);
	bytes[0] = entry->opcode;
	switch (entry->format)
	{
	case RXRYRZ: bytes[1] = operand1.register_; bytes[2] = operand2.register_; bytes[3] = operand3.register_; break;
	case RXRYRIZ: bytes[0] |= operand3.model == Operand::Immediate; bytes[1] = operand1.register_; bytes[2] = operand2.register_; bytes[3] = operand3.model == Operand::Register ? operand3.register_ : operand3.immediate; break;
	case RXRYIZ: bytes[1] = operand1.register_; bytes[2] = operand2.register_; bytes[3] = operand3.immediate; break;
	case RXIYRZ: bytes[1] = operand1.register_; bytes[2] = operand2.immediate; bytes[3] = operand3.register_; break;
	case RXIYRIZ: bytes[0] |= operand3.model == Operand::Immediate; bytes[1] = operand1.register_; bytes[2] = operand2.immediate; bytes[3] = operand3.model == Operand::Register ? operand3.register_ : operand3.immediate; break;
	case RXIYIZ: bytes[1] = operand1.register_; bytes[2] = operand2.immediate; bytes[3] = operand3.immediate; break;
	case RXIYZ: bytes[1] = operand1.register_; bytes[2] = operand2.immediate >> 8; bytes[3] = operand2.immediate; break;
	case RXIZ: bytes[1] = operand1.register_; bytes[2] = 0; bytes[3] = operand2.immediate; break;
	case RXDYZ: bytes[0] ^= operand2.immediate < 0; bytes[1] = operand1.register_; bytes[2] = operand2.immediate >> 10; bytes[3] = operand2.immediate >> 2; break;
	case RX: bytes[1] = operand1.register_; bytes[2] = 0; bytes[3] = 0; break;
	case IXRYRIZ: bytes[0] |= operand3.model == Operand::Immediate; bytes[1] = operand1.immediate; bytes[2] = operand2.register_; bytes[3] = operand3.model == Operand::Register ? operand3.register_ : operand3.immediate; break;
	case IXRYIZ: bytes[1] = operand1.immediate; bytes[2] = operand2.register_; bytes[3] = operand3.immediate; break;
	case IXIYIZ: bytes[1] = operand1.immediate; bytes[2] = operand2.immediate; bytes[3] = operand3.immediate; break;
	case IXRIZ: bytes[1] = operand1.immediate; bytes[2] = 0; bytes[3] = operand2.model == Operand::Register ? operand2.register_ : operand2.immediate; break;
	case IXIZ: bytes[1] = operand1.immediate; bytes[2] = 0; bytes[3] = operand2.immediate; break;
	case IZ: bytes[1] = 0; bytes[2] = 0; bytes[3] = operand1.immediate; break;
	case DXYZ: bytes[0] ^= operand1.immediate < 0; bytes[1] = operand1.immediate >> 18; bytes[2] = operand1.immediate >> 10; bytes[3] = operand1.immediate >> 2; break;
	}
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	switch (entry->format)
	{
	case RXIYZ: patch.offset += 2; patch.pattern = {{1, 0xff}, {0, 0xff}}; break;
	case RXDYZ: patch.scale += 2; patch.pattern = {{3, 0xff}, {2, 0xff}, {0, 0x01}}; patch.mode = Object::Patch::Relative; break;
	case DXYZ: patch.scale += 2; patch.pattern = {{3, 0xff}, {2, 0xff}, {1, 0xff}, {0, 0x01}}; patch.mode = Object::Patch::Relative; break;
	}
}

bool Instruction::IsR (const Operand& operand)
{
	return operand.model == Operand::Register;
}

bool Instruction::IsI1 (const Operand& operand)
{
	return operand.model == Operand::Immediate && operand.immediate >= 0 && operand.immediate < 256;
}

bool Instruction::IsI2 (const Operand& operand)
{
	return operand.model == Operand::Immediate && operand.immediate >= 0 && operand.immediate < 65536;
}

bool Instruction::IsD2 (const Operand& operand)
{
	return operand.model == Operand::Immediate && operand.immediate >= -262144 && operand.immediate < 262144 && operand.immediate % 4 == 0;
}

bool Instruction::IsD3 (const Operand& operand)
{
	return operand.model == Operand::Immediate && operand.immediate >= -67108864 && operand.immediate < 67108864 && operand.immediate % 4 == 0;
}

std::istream& MMIX::operator >> (std::istream& stream, Register& register_)
{
	return ReadPrefixedValue (stream, register_, "$", R0, R255);
}

std::ostream& MMIX::operator << (std::ostream& stream, const Register register_)
{
	return WritePrefixedValue (stream, register_, "$", R0);
}

std::istream& MMIX::operator >> (std::istream& stream, Operand& operand)
{
	union {Immediate immediate; Register register_;};
	if (stream >> std::ws && stream.peek () == '$' && stream >> register_) operand = register_;
	else if (stream >> immediate) operand = immediate;
	return stream;
}

std::ostream& MMIX::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	default: return stream;
	}
}

std::istream& MMIX::operator >> (std::istream& stream, Instruction& instruction)
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

std::ostream& MMIX::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ", " << instruction.operand2 && !IsEmpty (instruction.operand3))
				stream << ", " << instruction.operand3;
	return stream;
}

std::istream& MMIX::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsAlnum);
}

std::ostream& MMIX::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

// MicroBlaze instruction set representation
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

#include "mibl.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace MicroBlaze;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type type1, type2, type3;
};

constexpr const Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, mask, type1, type2, type3) \
		{Instruction::mnem, code, mask, Operand::type1, Operand::type2, Operand::type3},
	#include "mibl.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "mibl.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::lookup {table};

Operand::Operand (const MicroBlaze::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const MicroBlaze::Interface i) :
	model {Interface}, interface {i}
{
}

Operand::Operand (const MicroBlaze::Register r) :
	model {Register}, register_ {r}
{
}

Operand::Operand (const MicroBlaze::SpecialRegister sr) :
	model {SpecialRegister}, sregister {sr}
{
}

void Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case RA: model = Register; register_ = MicroBlaze::Register (R0 + (opcode >> 16 & 0x1f)); break;
	case RB: model = Register; register_ = MicroBlaze::Register (R0 + (opcode >> 11 & 0x1f)); break;
	case RD: model = Register; register_ = MicroBlaze::Register (R0 + (opcode >> 21 & 0x1f)); break;
	case RS: case RT: model = SpecialRegister; sregister = MicroBlaze::SpecialRegister (opcode & 0x3fff); break;
	case U5: model = Immediate; immediate = MicroBlaze::Immediate (opcode & 0x1f); break;
	case U521: model = Immediate; immediate = MicroBlaze::Immediate (opcode >> 21 & 0x1f); break;
	case U15: model = Immediate; immediate = MicroBlaze::Immediate (opcode & 0x7fff); break;
	case S16: case O16: model = Immediate; immediate = MicroBlaze::Immediate (opcode) << 16 >> 16; break;
	case FSL: model = Interface; interface = MicroBlaze::Interface (opcode & 0xf); break;
	default: model = Empty;
	}
}

Opcode Operand::Encode (const Type type) const
{
	switch (type)
	{
	case RA: return Opcode (register_ - R0) << 16;
	case RB: return Opcode (register_ - R0) << 11;
	case RD: return Opcode (register_ - R0) << 21;
	case RS: case RT: return Opcode (sregister) & 0x3fff;
	case U5: return Opcode (immediate) & 0x1f;
	case U521: return Opcode (immediate) & 0x1f << 21;
	case U15: return Opcode (immediate) & 0x7fff;
	case S16: case O16: return Opcode (immediate) & 0xffff;
	case FSL: return Opcode (interface);
	default: return 0;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case RA: case RB: case RD: return model == Register;
	case RS: return model == SpecialRegister;
	case RT: return model == SpecialRegister && sregister != RPC && sregister != REAR && sregister != RESR && sregister != RBTR && sregister != REDR && sregister < RPVR0;
	case U5: case U521: return model == Immediate && immediate >= 0 && immediate <= 31;
	case U15: return model == Immediate && immediate >= 0 && immediate <= 32767;
	case S16: case O16: return model == Immediate && immediate >= -32768 && immediate <= 32767;
	case FSL: return model == Interface;
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
	if (entry->type1 == Operand::S16 || entry->type1 == Operand::O16 || entry->type2 == Operand::S16 || entry->type3 == Operand::S16) patch.offset += 2, patch.pattern = {2, Endianness::Big};
	if (entry->type1 == Operand::O16 || entry->type2 == Operand::O16) if (patch.mode == Object::Patch::Absolute) patch.displacement += 2, patch.mode = Object::Patch::Relative;
}

Register MicroBlaze::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

std::istream& MicroBlaze::operator >> (std::istream& stream, Register& register_)
{
	return ReadPrefixedValue (stream, register_, "r", R0, R31);
}

std::ostream& MicroBlaze::operator << (std::ostream& stream, const Register register_)
{
	return WritePrefixedValue (stream, register_, "r", R0);
}

std::istream& MicroBlaze::operator >> (std::istream& stream, Interface& interface)
{
	return ReadPrefixedValue (stream, interface, "rfsl", FSL0, FSL15);
}

std::ostream& MicroBlaze::operator << (std::ostream& stream, const Interface interface)
{
	return WritePrefixedValue (stream, interface, "rfsl", FSL0);
}

std::istream& MicroBlaze::operator >> (std::istream& stream, Operand& operand)
{
	union {Register register_; Immediate immediate; Interface interface; SpecialRegister sregister;};
	if (stream >> std::ws && stream.peek () == 'r' && stream.ignore ())
		if (std::isdigit (stream.peek ()) && stream.putback ('r') >> register_) operand = register_;
		else if (stream.peek () == 'f' && stream.ignore ())
			if (stream.peek () == 's' && stream.ignore ())
				if (stream.peek () == 'l' && stream.putback ('s').putback ('f').putback ('r') >> interface) operand = interface;
				else if (stream.putback ('s').putback ('f').putback ('r') >> sregister) operand = sregister; else;
			else if (stream.putback ('f').putback ('r') >> sregister) operand = sregister; else;
		else if (stream.putback ('r') >> sregister) operand = sregister; else;
	else if (stream >> immediate) operand = immediate;
	return stream;
}

std::ostream& MicroBlaze::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	case Operand::Interface: return stream << operand.interface;
	case Operand::SpecialRegister: return stream << operand.sregister;
	default: return stream;
	}
}

std::istream& MicroBlaze::operator >> (std::istream& stream, Instruction& instruction)
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

std::ostream& MicroBlaze::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ", " << instruction.operand2 && !IsEmpty (instruction.operand3))
				stream << ", " << instruction.operand3;
	return stream;
}

std::istream& MicroBlaze::operator >> (std::istream& stream, SpecialRegister& sregister)
{
	std::string identifier; if (ReadIdentifier (stream, identifier, IsAlnum))
	#define SREG(reg, name, number) if (identifier == #name) return sregister = reg, stream;
	#include "mibl.def"
	stream.setstate (stream.failbit); return stream;
}

std::ostream& MicroBlaze::operator << (std::ostream& stream, const SpecialRegister sregister)
{
	#define SREG(reg, name, number) if (sregister == reg) return stream << #name;
	#include "mibl.def"
	stream.setstate (stream.failbit); return stream;
}

std::istream& MicroBlaze::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsDotted);
}

std::ostream& MicroBlaze::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

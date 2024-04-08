// ARM instruction set representation
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

#include "arm.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace ARM;

static const char*const shiftmodes[] {"lsl", "lsr", "asr", "ror", "rrx"};
static const char*const qualifiers[] {"", ".n", ".w"};
static const char*const codes[] {"", "al", "cc", "cs", "eq", "ge", "gt", "hi", "hs", "le", "lo", "ls", "lt", "mi", "ne", "nv", "pl", "vc", "vs"};
static const char*const operations[] {"ish", "ishld", "ishst", "ld", "nsh", "nshld", "nshst", "osh", "oshld", "oshst", "st", "sy"};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "arm.def"
};

const char*const Instruction::suffixes[] {"",
	#define SUFFIX(name, suffix) #name,
	#include "arm.def"
};

static const Byte conditionCodes[] {0xe, 0xe, 0x3, 0x2, 0x0, 0xa, 0xc, 0x8, 0x2, 0xd, 0x3, 0x9, 0xb, 0x4, 0x1, 0xf, 0x5, 0x7, 0x6};
static const Byte barrierOperations[] {0xb, 0x9, 0xa, 0xd, 0x7, 0x5, 0x6, 0x3, 0x1, 0x2, 0xe, 0xf};

Operand::Operand (const ARM::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const ARM::Register r, const WriteBack wb) :
	model {Register}, register_ {r}, writeBack {wb}
{
}

Operand::Operand (const ARM::ShiftMode m, const ARM::Register r) :
	model {ShiftedRegister}, register_ {r}, mode {m}
{
}

Operand::Operand (const ARM::RegisterList r) :
	model {RegisterList}, registerSet {r}
{
}

Operand::Operand (const ARM::DoubleRegisterList r) :
	model {DoubleRegisterList}, registerSet {r}
{
}

Operand::Operand (const ARM::SingleRegisterList r) :
	model {SingleRegisterList}, registerSet {r}
{
}

Operand::Operand (const ARM::Register r, const ARM::Immediate i, const WriteBack wb) :
	model {Memory}, register_ {r}, immediate {i}, writeBack {wb}
{
}

Operand::Operand (const ARM::Register r, const ARM::Register i, const ARM::Immediate s) :
	model {MemoryIndex}, register_ {r}, index {i}, shift {s}
{
}

Operand::Operand (const ARM::ConditionCode c) :
	model {ConditionCode}, code {c}
{
}

Operand::Operand (const ARM::InterruptMask m) :
	model {InterruptMask}, mask {m}
{
}

Operand::Operand (const ARM::BarrierOperation o) :
	model {BarrierOperation}, operation {o}
{
}

Operand::Operand (const ARM::ShiftMode m, const ARM::Immediate s) :
	model {ShiftMode}, mode {m}, shift {s}
{
}

Operand::Operand (const ARM::Coprocessor c) :
	model {Coprocessor}, coprocessor {c}
{
}

Operand::Operand (const ARM::CoprocessorRegister r) :
	model {CoprocessorRegister}, coregister {r}
{
}

std::istream& Instruction::Read (std::istream& stream, Mnemonic& mnemonic, ConditionCode& code, Qualifier& qualifier, Suffix& suffix)
{
	std::string identifier; if (!ReadIdentifier (stream, identifier, IsDotted)) return stream; const auto dot = identifier.find ('.');
	if (dot == identifier.npos || !FindEnum (identifier.substr (dot, 2), qualifier, qualifiers)) qualifier = Default;
	if (dot == identifier.npos) suffix = None; else if (!FindSortedEnum (identifier.substr (qualifier ? dot + 2 : dot), suffix, suffixes)) return stream.setstate (stream.failbit), stream;
	if (dot != identifier.npos && !FindSortedEnum (identifier.substr (qualifier ? dot + 2 : dot), suffix, suffixes)) return stream.setstate (stream.failbit), stream;
	if (dot != identifier.npos) identifier.resize (dot);
	if (FindSortedEnum (identifier, mnemonic, mnemonics)) code = No;
	else if (identifier.size () < 3 || !FindEnum (identifier.substr (identifier.size () - 2), code, codes)) stream.setstate (stream.failbit);
	else if (identifier.resize (identifier.size () - 2), !FindSortedEnum (identifier, mnemonic, mnemonics)) stream.setstate (stream.failbit);
	return stream;
}

std::ostream& Instruction::Write (std::ostream& stream, const Mnemonic mnemonic, const ConditionCode code, const Qualifier qualifier, const Suffix suffix)
{
	stream << mnemonic; if (code) stream << code; if (qualifier) stream << qualifier; if (suffix) stream << suffix; return stream;
}

bool ARM::HasConditionCode (const std::string& identifier, const std::string::size_type position, ConditionCode& code)
{
	assert (identifier.size () >= position);
	for (auto& name: codes) if (!identifier.compare (position, 2, name)) return code = ConditionCode (&name - codes), true;
	return false;
}

Byte ARM::GetValue (const ConditionCode code)
{
	return conditionCodes[code];
}

ConditionCode ARM::GetConditionCode (const Byte value)
{
	return ConditionCode (std::find (std::begin (conditionCodes) + 1, std::end (conditionCodes), value) - std::begin (conditionCodes));
}

Byte ARM::GetValue (const BarrierOperation operation)
{
	return barrierOperations[operation];
}

BarrierOperation ARM::GetBarrierOperation (const Byte value)
{
	return BarrierOperation (std::find (std::begin (barrierOperations), std::end (barrierOperations), value) - std::begin (barrierOperations));
}

Register ARM::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

std::istream& ARM::operator >> (std::istream& stream, ShiftMode& shiftmode)
{
	return ReadEnum (stream, shiftmode, shiftmodes, IsAlpha);
}

std::ostream& ARM::operator << (std::ostream& stream, const ShiftMode shiftmode)
{
	return WriteEnum (stream, shiftmode, shiftmodes);
}

std::istream& ARM::operator >> (std::istream& stream, ConditionCode& code)
{
	return ReadSortedEnum (stream, code, codes, IsAlpha);
}

std::ostream& ARM::operator << (std::ostream& stream, const ConditionCode code)
{
	return WriteEnum (stream, code, codes);
}

std::istream& ARM::operator >> (std::istream& stream, BarrierOperation& operation)
{
	return ReadSortedEnum (stream, operation, operations, IsAlpha);
}

std::ostream& ARM::operator << (std::ostream& stream, const BarrierOperation operation)
{
	return WriteEnum (stream, operation, operations);
}

std::istream& ARM::operator >> (std::istream& stream, InterruptMask& mask)
{
	mask = {};
	for (char c; stream.good () && stream >> std::ws && stream.good () && stream.get (c);)
		if (c == 'a') mask = InterruptMask (mask | A);
		else if (c == 'i') mask = InterruptMask (mask | I);
		else if (c == 'f') mask = InterruptMask (mask | F);
		else return stream.putback (c);
	return stream;
}

std::ostream& ARM::operator << (std::ostream& stream, const InterruptMask mask)
{
	if (mask & A) stream << 'a'; if (mask & I) stream << 'i'; if (mask & F) stream << 'f'; return stream;
}

std::ostream& ARM::operator << (std::ostream& stream, const Qualifier qualifier)
{
	return WriteEnum (stream, qualifier, qualifiers);
}

std::istream& ARM::operator >> (std::istream& stream, Register& register_)
{
	char c = 0; if (stream >> std::ws && stream.get (c) && c == 's' && stream.peek () == 'p') return register_ = SP, stream.ignore ();
	if (c == 'l' && stream.get () == 'r') return register_ = LR, stream;
	if (c == 'p' && stream.get () == 'c') return register_ = PC, stream;
	if (c == 'd') return ReadPrefixedValue (stream.putback (c), register_, "d", D0, D31);
	if (c == 's') return ReadPrefixedValue (stream.putback (c), register_, "s", S0, S31);
	if (c == 'q') return ReadPrefixedValue (stream.putback (c), register_, "q", Q0, Q15);
	return ReadPrefixedValue (stream.putback (c), register_, "r", R0, R15);
}

std::ostream& ARM::operator << (std::ostream& stream, const Register register_)
{
	if (register_ == SP) return stream << "sp"; if (register_ == LR) return stream << "lr"; if (register_ == PC) return stream << "pc";
	if (register_ >= Q0) return WritePrefixedValue (stream, register_, "q", Q0);
	if (register_ >= S0) return WritePrefixedValue (stream, register_, "s", S0);
	if (register_ >= D0) return WritePrefixedValue (stream, register_, "d", D0);
	return WritePrefixedValue (stream, register_, "r", R0);
}

std::istream& ARM::operator >> (std::istream& stream, Coprocessor& coprocessor)
{
	return ReadPrefixedValue (stream, coprocessor, "p", P0, P15);
}

std::ostream& ARM::operator << (std::ostream& stream, const Coprocessor coprocessor)
{
	return WritePrefixedValue (stream, coprocessor, "p", P0);
}

std::istream& BasicList::Read (std::istream& stream, const Register first, const Register last)
{
	if (stream >> std::ws && stream.get () != '{') stream.setstate (stream.failbit); Register register_;
	if (stream >> std::ws && stream.peek () != '}') do if (stream >> register_ && register_ >= first && register_ <= last) registerSet |= 1 << register_ - first;
	else stream.setstate (stream.failbit); while (stream >> std::ws && stream.peek () == ',' && stream.get ());
	if (stream >> std::ws && stream.get () != '}') stream.setstate (stream.failbit); return stream;
}

std::ostream& BasicList::Write (std::ostream& stream, const Register first, const Register last) const
{
	stream << '{'; auto separator = false; for (Register register_ = first; register_ <= last; register_ = Register (register_ + 1))
		if (registerSet >> register_ - first & 1) if (separator) stream << ", " << register_; else stream << register_, separator = true;
	return stream << '}';
}

std::istream& ARM::operator >> (std::istream& stream, CoprocessorRegister& register_)
{
	return ReadPrefixedValue (stream, register_, "c", C0, C15);
}

std::ostream& ARM::operator << (std::ostream& stream, CoprocessorRegister register_)
{
	return WritePrefixedValue (stream, register_, "c", C0);
}

std::istream& ARM::operator >> (std::istream& stream, Operand& operand)
{
	char peek[4] {}; stream >> std::ws; stream.get (peek, sizeof peek); for (auto c: Reverse {peek}) if (c) stream.putback (c);
	ShiftMode mode; ConditionCode code; Immediate immediate; std::uint32_t value; Register register_; RegisterList registerList; DoubleRegisterList doubleRegisterList;
	SingleRegisterList singleRegisterList; InterruptMask mask; BarrierOperation barrier; Coprocessor coprocessor; CoprocessorRegister coregister;
	if (peek[0] == '[' && stream.ignore () >> std::ws)
	{
		Register index; bool shifted = false; stream >> register_ >> std::ws;
		if (stream.peek () == ',' && stream.ignore () >> std::ws)
			if (!std::isalpha (stream.peek ())) stream >> immediate >> std::ws;
			else if (stream >> index >> std::ws && stream.peek () == ',' && stream.ignore () >> std::ws)
				if (stream.peek () == 'l' && stream >> mode && mode == LSL) stream >> immediate >> std::ws, shifted = true; else stream.setstate (stream.failbit);
			else immediate = 0, shifted = true;
		else immediate = 0, shifted = false;
		if (stream.get () != ']') stream.setstate (stream.failbit);
		else if (shifted) operand = {register_, index, immediate};
		else operand = {register_, immediate, stream >> std::ws && stream.good () && stream.peek () == '!' && stream.ignore ()};
	}
	else if ((peek[0] == 'l' && peek[1] == 's' && (peek[2] == 'l' || peek[2] == 'r') || peek[0] == 'a' && peek[1] == 's' || peek[0] == 'r' && (peek[1] == 'o' || peek[1] == 'r')))
		if (stream >> mode) if (mode == RRX) operand = mode;
		else if (stream >> std::ws && std::isalpha (stream.peek ()) && stream >> register_) operand = {mode, register_};
		else if (stream >> value) operand = {mode, Immediate (value)}; else; else;
	else if ((peek[0] == 'a' && peek[1] == 'l' || peek[0] == 'c' && (peek[1] == 'c' || peek[1] == 's') || peek[0] == 'e' || peek[0] == 'g' || peek[0] == 'h' || peek[0] == 'l' && peek[1] != 'd' && peek[1] != 'r' || peek[0] == 'm' || peek[0] == 'n' && peek[1] != 's' || peek[0] == 'p' && peek[1] == 'l' || peek[0] == 'v') && stream >> code) operand = code;
	else if ((peek[0] == 'a' || peek[0] == 'i' && peek[1] != 's' || peek[0] == 'f') && stream >> mask) operand = mask;
	else if ((peek[0] == 'i' || peek[0] == 'l' && peek[1] == 'd' || peek[0] == 'n' || peek[0] == 'o' || peek[0] == 's' && (peek[1] == 't' || peek[1] == 'y')) && stream >> barrier) operand = barrier;
	else if (peek[0] == 'p' && peek[1] != 'c' && stream >> coprocessor) operand = coprocessor;
	else if (peek[0] == 'c' && stream >> coregister) operand = coregister;
	else if (std::isalpha (peek[0]) && stream >> register_) operand = {register_, stream.good () && stream >> std::ws && stream.good () && stream.peek () == '!' && stream.ignore ()};
	else if (peek[0] == '{' && stream.ignore () >> std::ws)
		if (stream.peek () == 'd' && stream.putback ('{') >> doubleRegisterList) operand = doubleRegisterList;
		else if (stream.peek () == 's' && stream.putback ('{') >> singleRegisterList) operand = singleRegisterList;
		else if (stream.putback ('{') >> registerList) operand = registerList; else;
	else if (peek[0] == '+' && stream.ignore () >> value) operand = +Immediate (value);
	else if (peek[0] == '-' && stream.ignore () >> value) operand = -Immediate (value);
	else if (stream >> value) operand = Immediate (value);
	return stream;
}

std::ostream& ARM::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: stream << operand.register_; if (operand.writeBack) stream << '!'; return stream;
	case Operand::ShiftedRegister: return stream << operand.mode << ' ' << operand.register_;
	case Operand::RegisterList: return stream << RegisterList {operand.registerSet};
	case Operand::DoubleRegisterList: return stream << DoubleRegisterList {operand.registerSet};
	case Operand::SingleRegisterList: return stream << SingleRegisterList {operand.registerSet};
	case Operand::Memory: stream << '[' << operand.register_; if (operand.immediate || operand.writeBack) stream << ", " << operand.immediate; stream << ']'; if (operand.writeBack) stream << '!'; return stream;
	case Operand::MemoryIndex: stream << '[' << operand.register_ << ", " << operand.index; if (operand.shift) stream << ", " << LSL << ' ' << operand.shift; stream << ']'; return stream;
	case Operand::ShiftMode: stream << operand.mode; if (operand.mode != RRX) stream << ' ' << operand.shift; return stream;
	case Operand::ConditionCode: return stream << operand.code;
	case Operand::InterruptMask: return stream << operand.mask;
	case Operand::BarrierOperation: return stream << operand.operation;
	case Operand::Coprocessor: return stream << operand.coprocessor;
	case Operand::CoprocessorRegister: return stream << operand.coregister;
	default: return stream;
	}
}

std::ostream& ARM::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

std::ostream& ARM::operator << (std::ostream& stream, const Suffix suffix)
{
	return WriteEnum (stream, suffix, Instruction::suffixes);
}

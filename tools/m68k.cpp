// M68000 instruction set representation
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

#include "m68k.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace M68K;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Operand::Size size;
	Opcode opcode, mask;
	Operand::Type type1, type2;
};

const char*const Operand::registers[] {"sp", "usp", "pc", "sr", "ccr"};

constexpr Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, size, code, mask, type1, type2) \
		{M68K::Instruction::mnem, Operand::size, code, mask, Operand::type1, Operand::type2},
	#include "m68k.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "m68k.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::first {table}, Instruction::last {table, 0};

Operand::Operand (const M68K::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const M68K::Register r) :
	model {Register}, register_ {r}
{
}

Operand::Operand (const M68K::Immediate i, const Size s) :
	model {Absolute}, immediate {i}, size {s}
{
	assert (size);
}

Operand::Operand (const M68K::Immediate i, const M68K::Register r) :
	model {Memory}, immediate {i}, register_ {r}
{
}

Operand::Operand (const M68K::Immediate im, const M68K::Register r, const M68K::Register in, const Size s) :
	model {Index}, immediate {im}, register_ {r}, index {in}, size {s}
{
	assert (size);
}

Operand::Operand (const Model m, const M68K::Register r) :
	model {m}, register_ {r}
{
}

Operand Operand::operator + () const
{
	assert (model == Memory && !immediate); return {Increment, register_};
}

Operand Operand::operator - () const
{
	assert (model == Memory && !immediate); return {Decrement, register_};
}

Operand Operand::operator [] (const M68K::Immediate i) const
{
	assert (model == Register); return {i, register_};
}

bool Operand::Decode (const Opcode opcode, const Type type, const Span<const ECS::Byte> bytes)
{
	switch (type)
	{
	case IB: model = Immediate; return Decode (immediate, Byte, bytes);
	case IW: case DW: model = Immediate; return Decode (immediate, Word, bytes);
	case IL: model = Immediate; return Decode (immediate, Long, bytes);
	case I04: model = Immediate; immediate = (M68K::Immediate (opcode) & 0xf); return true;
	case I08: case DB: model = Immediate; immediate = (M68K::Immediate (opcode) << 24 >> 24); return true;
	case I9: model = Immediate; immediate = M68K::Immediate (opcode >> 9 & 0x7); if (!immediate) immediate = 8; return true;
	case RD0: model = Register; register_ = M68K::Register (D0 + (opcode & 0x7)); return true;
	case RD9: model = Register; register_ = M68K::Register (D0 + (opcode >> 9 & 0x7)); return true;
	case RA0: model = Register; register_ = M68K::Register (A0 + (opcode & 0x7)); return true;
	case RA9: model = Register; register_ = M68K::Register (A0 + (opcode >> 9 & 0x7)); return true;
	case RA0d: model = Decrement; register_ = M68K::Register (A0 + (opcode & 0x7)); return true;
	case RA9d: model = Decrement; register_ = M68K::Register (A0 + (opcode >> 9 & 0x7)); return true;
	case RA0i: model = Increment; register_ = M68K::Register (A0 + (opcode & 0x7)); return true;
	case RA9i: model = Increment; register_ = M68K::Register (A0 + (opcode >> 9 & 0x7)); return true;
	case RA0m: model = Memory; register_ = M68K::Register (A0 + (opcode & 0x7)); return Decode (immediate, Word, bytes);
	case EA0B: case EA0Bd: case EA0Ba: case EA0Bda: case EA0Bma: return DecodeEffectiveAddress (Byte, opcode, 3, 0, bytes);
	case EA0W: case EA0Wd: case EA0Wa: case EA0Wda: case EA0Wma: return DecodeEffectiveAddress (Word, opcode, 3, 0, bytes);
	case EA0L: case EA0Ld: case EA0Lc: case EA0La: case EA0Lda: case EA0Lma: return DecodeEffectiveAddress (Long, opcode, 3, 0, bytes);
	case EA6Bda: return DecodeEffectiveAddress (Byte, opcode, 6, 9, bytes);
	case EA6Wda: return DecodeEffectiveAddress (Word, opcode, 6, 9, bytes);
	case EA6Lda: return DecodeEffectiveAddress (Long, opcode, 6, 9, bytes);
	case USP: model = Register; register_ = M68K::Register::USP; return true;
	case SR: model = Register; register_ = M68K::Register::SR; return true;
	case CCR: model = Register; register_ = M68K::Register::CCR; return true;
	default: model = Empty; return true;
	}
}

Opcode Operand::Encode (const Type type, const Span<ECS::Byte> bytes) const
{
	switch (type)
	{
	case IB: return Encode (immediate, Byte, bytes), 0;
	case IW: case DW: return Encode (immediate, Word, bytes), 0;
	case IL: return Encode (immediate, Long, bytes), 0;
	case I04: return Opcode (immediate & 0xf);
	case I08: case DB: return Opcode (immediate & 0xff);
	case I9: return Opcode (immediate % 8) << 9;
	case RD0: return Opcode (register_ - D0);
	case RD9: return Opcode (register_ - D0) << 9;
	case RA0: case RA0d: case RA0i: return Opcode (register_ - A0);
	case RA9: case RA9d: case RA9i: return Opcode (register_ - A0) << 9;
	case RA0m: return Encode (immediate, Word, bytes), Opcode (register_ - A0);
	case EA0B: case EA0Bd: case EA0Ba: case EA0Bda: case EA0Bma: return EncodeEffectiveAddress (Byte, 3, 0, bytes);
	case EA0W: case EA0Wd: case EA0Wa: case EA0Wda: case EA0Wma: return EncodeEffectiveAddress (Word, 3, 0, bytes);
	case EA0L: case EA0Ld: case EA0Lc: case EA0La: case EA0Lda: case EA0Lma: return EncodeEffectiveAddress (Long, 3, 0, bytes);
	case EA6Bda: return EncodeEffectiveAddress (Byte, 6, 9, bytes);
	case EA6Wda: return EncodeEffectiveAddress (Word, 6, 9, bytes);
	case EA6Lda: return EncodeEffectiveAddress (Long, 6, 9, bytes);
	default: return 0;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case IB: case I08: return model == Immediate && immediate >= -128 && immediate <= 255;
	case IW: return model == Immediate && immediate >= -32768 && immediate <= 65535;
	case IL: return model == Immediate;
	case I04: return model == Immediate && immediate >= 0 && immediate <= 15;
	case I9: return model == Immediate && immediate >= 1 && immediate <= 8;
	case DB: return model == Immediate && immediate >= -128 && immediate <= 127 && immediate != 0;
	case DW: return model == Immediate && immediate >= -32768 && immediate <= 32767;
	case RD0: case RD9: return model == Register && register_ >= D0 && register_ <= D7;
	case RA0: case RA9: return model == Register && register_ >= A0 && register_ <= A7;
	case RA0d: case RA9d: return model == Decrement && register_ >= A0 && register_ <= A7;
	case RA0i: case RA9i: return model == Increment && register_ >= A0 && register_ <= A7;
	case RA0m: return model == Memory && immediate >= -32768 && immediate <= 32767 && register_ >= A0 && register_ <= A7;
	case EA0B: return IsCompatibleWithEffectiveAddress (Byte, All);
	case EA0W: return IsCompatibleWithEffectiveAddress (Word, All);
	case EA0L: return IsCompatibleWithEffectiveAddress (Long, All);
	case EA0Bd: return IsCompatibleWithEffectiveAddress (Byte, Data);
	case EA0Wd: return IsCompatibleWithEffectiveAddress (Word, Data);
	case EA0Ld: return IsCompatibleWithEffectiveAddress (Long, Data);
	case EA0Lc: return IsCompatibleWithEffectiveAddress (Long, Control);
	case EA0Ba: return IsCompatibleWithEffectiveAddress (Byte, Alterable);
	case EA0Wa: return IsCompatibleWithEffectiveAddress (Word, Alterable);
	case EA0La: return IsCompatibleWithEffectiveAddress (Long, Alterable);
	case EA0Bda: case EA6Bda: return IsCompatibleWithEffectiveAddress (Byte, DataAlterable);
	case EA0Wda: case EA6Wda: return IsCompatibleWithEffectiveAddress (Word, DataAlterable);
	case EA0Lda: case EA6Lda: return IsCompatibleWithEffectiveAddress (Long, DataAlterable);
	case EA0Bma: return IsCompatibleWithEffectiveAddress (Byte, MemoryAlterable);
	case EA0Wma: return IsCompatibleWithEffectiveAddress (Word, MemoryAlterable);
	case EA0Lma: return IsCompatibleWithEffectiveAddress (Long, MemoryAlterable);
	case USP: return model == Register && register_ == M68K::Register::USP;
	case SR: return model == Register && register_ == M68K::Register::SR;
	case CCR: return model == Register && register_ == M68K::Register::CCR;
	default: return model == Empty;
	}
}

std::size_t Operand::GetSize (const Type type) const
{
	switch (type)
	{
	case IB: case IW: case DW: case RA0m: return 2;
	case IL: return 4;
	case EA0B: case EA0Bd: case EA0Ba: case EA0Bda: case EA0Bma: case EA6Bda: return GetEffectiveAddressSize (Byte);
	case EA0W: case EA0Wd: case EA0Wa: case EA0Wda: case EA0Wma: case EA6Wda: return GetEffectiveAddressSize (Word);
	case EA0L: case EA0Ld: case EA0Lc: case EA0La: case EA0Lda: case EA0Lma: case EA6Lda: return GetEffectiveAddressSize (Long);
	default: return 0;
	}
}

void Operand::Adjust (Object::Patch& patch, const Object::Offset offset) const
{
	if (model != Absolute) return; patch.offset += offset;
	patch.pattern = {size == Word ? 2u : 4u, Endianness::Big};
}

bool Operand::DecodeEffectiveAddress (const Size size, const Opcode opcode, const BitPosition modepos, const BitPosition regpos, const Span<const ECS::Byte> bytes)
{
	switch (opcode >> modepos & 0x7)
	{
	case 0: model = Register; register_ = M68K::Register (D0 + (opcode >> regpos & 0x7)); return true;
	case 1: model = Register; register_ = M68K::Register (A0 + (opcode >> regpos & 0x7)); return true;
	case 2: model = Memory; immediate = 0; register_ = M68K::Register (A0 + (opcode >> regpos & 0x7)); return true;
	case 3: model = Increment; register_ = M68K::Register (A0 + (opcode >> regpos & 0x7)); return true;
	case 4: model = Decrement; register_ = M68K::Register (A0 + (opcode >> regpos & 0x7)); return true;
	case 5: model = Memory; register_ = M68K::Register (A0 + (opcode >> regpos & 0x7)); return Decode (immediate, Word, bytes);
	case 6: model = Index; register_ = M68K::Register (A0 + (opcode >> regpos & 0x7)); index = M68K::Register (D0 + (bytes[0] >> 4 & 0xf));
		this->size = bytes[0] >> 3 & 1 ? Long : Word; return Decode (immediate, Byte, bytes);
	case 7: switch (opcode >> regpos & 0x7) {
		case 0: model = Absolute; return Decode (immediate, this->size = Word, bytes);
		case 1: model = Absolute; return Decode (immediate, this->size = Long, bytes);
		case 2: model = Memory; register_ = PC; return Decode (immediate, Word, bytes);
		case 3: model = Index; register_ = PC; index = M68K::Register (D0 + (bytes[0] >> 4 & 0xf));
			this->size = bytes[0] >> 3 & 1 ? Long : Word; return Decode (immediate, Byte, bytes);
		case 4: model = Immediate; return Decode (immediate, size, bytes);
		default: return false;}
	default: return false;
	}
}

Opcode Operand::EncodeEffectiveAddress (const Size size, const BitPosition modepos, const BitPosition regpos, const Span<ECS::Byte> bytes) const
{
	switch (model)
	{
	case Immediate: Encode (immediate, size, bytes); return Opcode (7 << modepos | 4 << regpos);
	case Register: return register_ >= A0 && register_ <= A7 ? Opcode (1 << modepos | register_ - A0 << regpos) : Opcode (0 << modepos | register_ - D0 << regpos);
	case Memory: if (!immediate && register_ != PC) return Opcode (2 << modepos | register_ - A0 << regpos);
		Encode (immediate, Word, bytes); return Opcode (register_ == PC ? 7 << modepos | 2 << regpos : 5 << modepos | register_ - A0 << regpos);
	case Increment: return Opcode (3 << modepos | register_ - A0 << regpos);
	case Decrement: return Opcode (4 << modepos | register_ - A0 << regpos);
	case Index: Encode (immediate, Byte, bytes); bytes[0] = index - D0 << 4 | (this->size == Long) << 3;
		return Opcode (register_ == PC ? 7 << modepos | 3 << regpos : 6 << modepos | register_ - A0 << regpos);
	case Absolute: Encode (immediate, this->size, bytes); return Opcode (7 << modepos | (this->size == Long ? 1 : 0) << regpos);
	default: return 0;
	}
}

bool Operand::IsCompatibleWithEffectiveAddress (const Size size, const Modes modes) const
{
	switch (model)
	{
	case Immediate: if (!(modes & ImmediateData)) return false;
		if (size == Byte) return immediate >= -128 && immediate <= 255;
		if (size == Word) return immediate >= -32768 && immediate <= 65535;
		return true;
	case Register: return modes & DirectData && register_ >= D0 && register_ <= D7 || modes & DirectAddress && register_ >= A0 && register_ <= A7;
	case Memory: if (!immediate && register_ != PC) return modes & IndirectAddress && register_ >= A0 && register_ <= A7;
		if (register_ == PC) return modes & DisplacedProgramCounter && immediate >= -32768 && immediate <= 32767;
		return modes & DisplacedAddress && immediate >= -32768 && immediate <= 32767 && register_ >= A0 && register_ <= A7;
	case Increment: return modes & IncrementedAddress && register_ >= A0 && register_ <= A7;
	case Decrement: return modes & DecrementedAddress && register_ >= A0 && register_ <= A7;
	case Index: if (register_ == PC) return modes & DisplacedProgramCounter && immediate >= -128 && immediate <= 127 && index >= D0 && index <= A7 && this->size != Byte;
		return modes & DisplacedAddress && immediate >= -128 && immediate <= 127 && register_ >= A0 && register_ <= A7 && index >= D0 && index <= A7 && this->size != Byte;
	case Absolute: return modes & AbsoluteAddress && (this->size == Word && immediate >= -32768 && immediate <= 65535 || this->size == Long);
	default: return false;
	}
}

std::size_t Operand::GetEffectiveAddressSize (const Size size) const
{
	switch (model)
	{
	case Immediate: return size == Long ? 4 : 2;
	case Memory: return immediate || register_ == PC ? 2 : 0;
	case Index: return 2;
	case Absolute: return this->size == Long ? 4 : 2;
	default: return 0;
	}
}

void Operand::Encode (const M68K::Immediate immediate, const Size size, const Span<ECS::Byte> bytes)
{
	switch (size)
	{
	case Byte: assert (bytes.size () >= 2); bytes[0] = 0; bytes[1] = immediate; break;
	case Word: assert (bytes.size () >= 2); bytes[0] = immediate >> 8; bytes[1] = immediate; break;
	case Long: assert (bytes.size () >= 4); bytes[0] = immediate >> 24; bytes[1] = immediate >> 16; bytes[2] = immediate >> 8; bytes[3] = immediate; break;
	default: assert (Size::None);
	}
}

bool Operand::Decode (M68K::Immediate& immediate, const Size size, const Span<const ECS::Byte> bytes)
{
	switch (size)
	{
	case Byte: if (bytes.size () < 2) return false; immediate = M68K::Immediate (bytes[1] << 24) >> 24; return true;
	case Word: if (bytes.size () < 2) return false; immediate = (M68K::Immediate (bytes[0]) << 24 | M68K::Immediate (bytes[1]) << 16) >> 16; return true;
	case Long: if (bytes.size () < 4) return false; immediate = M68K::Immediate (bytes[0]) << 24 | M68K::Immediate (bytes[1]) << 16 | M68K::Immediate (bytes[2]) << 8 | M68K::Immediate (bytes[3]); return true;
	default: assert (Size::None);
	}
}

Instruction::Instruction (const Span<const Byte> bytes)
{
	if (bytes.size () < 2) return;
	const auto opcode = Opcode (bytes[0]) << 8 | Opcode (bytes[1]);
	for (auto& entry: table)
		if ((opcode & entry.mask) == entry.opcode)
		{
			if (!operand1.Decode (opcode, entry.type1, {bytes.begin () + 2, bytes.end ()})) return;
			const auto size = operand1.GetSize (entry.type1) + 2; if (bytes.size () < size) return;
			if (!operand2.Decode (opcode, entry.type2, {bytes.begin () + size, bytes.end ()})) return;
			this->entry = &entry; return;
		}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand::Size size, const Operand& o1, const Operand& o2) :
	operand1 {o1}, operand2 {o2}
{
	for (auto& entry: Span<const Entry> {first[mnemonic], last[mnemonic]})
		if (entry.size == size && operand1.IsCompatibleWith (entry.type1) && operand2.IsCompatibleWith (entry.type2))
			{this->entry = &entry; return;}
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); const auto size = operand1.GetSize (entry->type1) + 2; assert (bytes.size () >= size);
	const auto opcode = entry->opcode | operand1.Encode (entry->type1, {bytes.begin () + 2, bytes.end ()}) | operand2.Encode (entry->type2, {bytes.begin () + size, bytes.end ()});
	bytes[0] = opcode >> 8; bytes[1] = opcode;
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry); assert (IsEmpty (patch.pattern));
	operand2.Adjust (patch, operand1.GetSize (entry->type1) + 2);
	if (IsEmpty (patch.pattern)) operand1.Adjust (patch, 2);
}

std::size_t M68K::GetSize (const Instruction& instruction)
{
	assert (instruction.entry);
	return instruction.operand1.GetSize (instruction.entry->type1) + instruction.operand2.GetSize (instruction.entry->type2) + 2;
}

Register M68K::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register || operand.model == Operand::Memory || operand.model == Operand::Index); return operand.register_;
}

Instruction M68K::Optimize (const Instruction& instruction)
{
	assert (instruction.entry);
	const auto mnemonic = instruction.entry->mnemonic;
	auto &operand1 = instruction.operand1, &operand2 = instruction.operand2;
	if (mnemonic == Instruction::MOVE && operand1.model == Operand::Register && operand2.model == Operand::Register && operand1.register_ == operand2.register_) return {};
	if (mnemonic == Instruction::MOVE && operand1.model == Operand::Immediate)
		if (!operand1.immediate) return CLR {instruction.entry->size, operand2};
		else if (operand2.model == Operand::Register && operand1.immediate >= -128 && operand1.immediate <= 127) return MOVEQ {operand1, operand2};
	if ((mnemonic == Instruction::ADD || mnemonic == Instruction::ADDA) && operand1.model == Operand::Immediate || mnemonic == Instruction::ADDI)
		if (operand1.immediate >= 1 && operand1.immediate <= 8) return ADDQ {instruction.entry->size, operand1, operand2};
	if ((mnemonic == Instruction::SUB || mnemonic == Instruction::SUBA) && operand1.model == Operand::Immediate || mnemonic == Instruction::SUBI)
		if (operand1.immediate >= 1 && operand1.immediate <= 8) return SUBQ {instruction.entry->size, operand1, operand2};
	return instruction;
}

std::istream& M68K::operator >> (std::istream& stream, Operand::Size& size)
{
	if (stream >> std::ws && stream.get () != '.') stream.setstate (stream.failbit);
	else if (stream.peek () == 'b' && stream.ignore ()) size = Operand::Byte;
	else if (stream.peek () == 'w' && stream.ignore ()) size = Operand::Word;
	else if (stream.peek () == 'l' && stream.ignore ()) size = Operand::Long;
	else stream.setstate (stream.failbit); return stream;
}

std::ostream& M68K::operator << (std::ostream& stream, const Operand::Size size)
{
	assert (size); stream << '.';
	if (size == Operand::Byte) stream << 'b'; else if (size == Operand::Word) stream << 'w';
	else if (size == Operand::Long) stream << 'l'; return stream;
}

std::istream& M68K::operator >> (std::istream& stream, Register& register_)
{
	if (stream >> std::ws && stream.peek () == 'd') return ReadPrefixedValue (stream, register_, "d", D0, D7);
	if (stream.peek () == 'a') return ReadPrefixedValue (stream, register_, "a", A0, A7);
	if (ReadEnum (stream, register_, Operand::registers, IsAlpha)) register_ = Register (register_ + SP);
	return stream;
}

std::ostream& M68K::operator << (std::ostream& stream, const Register register_)
{
	if (register_ >= D0 && register_ <= D7) return WritePrefixedValue (stream, register_, "d", D0);
	if (register_ >= A0 && register_ <= A6) return WritePrefixedValue (stream, register_, "a", A0);
	return WriteEnum (stream, register_ - SP, Operand::registers);
}

std::istream& M68K::operator >> (std::istream& stream, Operand& operand)
{
	Immediate immediate; Register register_; bool decrement, increment;
	stream >> std::ws; decrement = stream.peek () == '-' && stream.ignore ();
	if (!decrement && std::isalpha (stream.peek ()) && stream >> register_) operand = register_;
	else if (stream >> std::ws && stream.peek () == '(' && stream.ignore ())
	{
		Register index; Operand::Size size;
		const auto displacement = !decrement && stream >> std::ws && !std::isalpha (stream.peek ()) && stream >> immediate;
		if (!displacement) immediate = 0, stream >> std::ws >> register_;
		else if (stream >> std::ws && stream.peek () == ',' && stream.ignore ()) stream >> register_; else register_ = SR;
		if (register_ != SR && stream >> std::ws && stream.peek () == ',' && stream.ignore ()) stream >> index >> size; else index = SR;
		if (stream >> std::ws && stream.get () != ')') stream.setstate (stream.failbit);
		if (register_ == SR) stream >> size; else if (index == SR) size = Operand::None;
		increment = !displacement && !decrement && stream.good () && stream >> std::ws && stream.good () && stream.peek () == '+' && stream.ignore ();
		if (!stream) return stream; if (index != SR) operand = {immediate, register_, index, size};
		else if (register_ != SR) operand = {immediate, register_}; else operand = {immediate, size};
		if (increment) operand = +operand; else if (decrement) operand = -operand;
	}
	else if (stream >> immediate) operand = decrement ? -immediate : immediate;
	return stream;
}

std::ostream& M68K::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Register: return stream << operand.register_;
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Memory: stream << '('; if (operand.immediate || operand.register_ == PC) stream << operand.immediate << ", "; return stream << operand.register_ << ')';
	case Operand::Increment: return stream << '(' << operand.register_ << ")+";
	case Operand::Decrement: return stream << "-(" << operand.register_ << ')';
	case Operand::Index: return stream << '(' << operand.immediate << ", " << operand.register_ << ", " << operand.index << operand.size << ')';
	case Operand::Absolute: return stream << '(' << operand.immediate << ')' << operand.size;
	default: return stream;
	}
}

std::istream& M68K::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic; Operand::Size size;
	if (stream >> mnemonic && stream.peek () == '.') stream >> size; else size = Operand::None;

	Operand operand1, operand2;
	if (stream && stream.good () && stream >> std::ws && stream.good ())
		if (stream >> operand1 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
			stream >> operand2;

	if (stream) instruction = {mnemonic, size, operand1, operand2};
	return stream;
}

std::ostream& M68K::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	stream << instruction.entry->mnemonic; if (instruction.entry->size) stream << instruction.entry->size;
	if (!IsEmpty (instruction.operand1) && stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2)) stream << ", " << instruction.operand2;
	return stream;
}

std::istream& M68K::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsAlnum);
}

std::ostream& M68K::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

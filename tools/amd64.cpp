// AMD64 instruction set representation
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

#include "amd64.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <bitset>
#include <cassert>
#include <cctype>
#include <utility>

using namespace ECS;
using namespace AMD64;

const char*const Operand::sizes[] {"byte", "word", "dword", "qword", "oword", "hword"};

const char*const Operand::registers[] {nullptr,
	#define REG(reg, name) #name,
	#include "amd64.def"
};

using Format = class Operand::Format
{
public:
	explicit Format (OperatingMode);

	std::size_t Decode (Span<const ECS::Byte>, Instruction&);
	std::size_t Encode (const Instruction&, ECS::Byte*, Instruction::Fixup&);

private:
	enum Type : std::uint8_t {none,
		#define TYPE(type) type,
		#include "amd64.def"
	};

	enum Code : std::uint8_t {no,
		#define CODE(code) code,
		#include "amd64.def"
	};

	enum Flags : std::uint32_t {
		#define FLAG(flag, value) flag = value,
		#include "amd64.def"
		DefaultSizeMask = O16 | O32 | O64, HasMem = FAR << 1, HasMOffset = HasMem << 1,
		HasReg = HasMOffset << 1, HasRV = HasReg << 1, HasModRM = HasReg | HasRV, HasCR = HasRV << 1, HasDR = HasCR << 1,
		HasCB = HasDR << 1, HasCD = HasCB << 1, HasCW = HasCD << 1, HasC = HasCB | HasCD | HasCW,
		HasIB = HasCW << 1, HasIW = HasIB << 1, HasID = HasIW << 1, HasIQ = HasID << 1, HasIS = HasIQ << 1,
	};

	enum Prefix {Void,
		#define PREFIX(prefix, byte) prefix,
		#include "amd64.def"
		Count, FirstLegacyPrefix = OS, LastLegacyPrefix = REPNE, FirstREXPrefix = REXB, LastREXPrefix = REXW,
	};

	struct Entry;

	using Exprefix = std::uint16_t;
	using Opcode = std::uint32_t;
	using Register = AMD64::Register;

	const OperatingMode mode;

	Register segment = RVoid;
	Bits operandSize, addressSize;
	std::bitset<Count> prefixes;
	Exprefix exprefix;
	Opcode opcode;
	const Entry* entry;
	unsigned vvvv, mod, reg, rm;
	unsigned scale, index, base;
	AMD64::Immediate immediate, displacement;

	std::size_t CountImmediateBytes () const;
	std::size_t CountDisplacementBytes () const;

	bool Segment (Register);

	Operand Decode (Type) const;
	bool Encode (const Operand&, Type);

	Operand ModMem (Size) const;
	Operand ModRM (Register, Size) const;
	bool ModRM (const Operand&, Register);

	Register ModReg (Register) const;
	bool ModReg (const Operand&, Register);

	bool Base (Register, Register, Prefix);
	Register Base (Register, unsigned, Prefix) const;
	bool Base (Register, Register, unsigned&, Prefix);

	static const Entry table[];
	static const ECS::Byte prefixBytes[];
	static const Register base16[], index16[];
	static const Lookup<Entry, Instruction::Mnemonic> first, last;

	static bool IsHigh (Register);

	static bool Match (Flags, OperatingMode);
	static bool Match (Type, const Operand&);
	static bool Match (Register, const Operand&);
	static bool Match (Model, Size, const Operand&);
	static bool Match (const Entry&, const Format&);
	static bool Match (const Entry&, const Instruction&);
	static bool Match (Register, Register, const Operand&);
};

struct Format::Entry
{
	Opcode opcode;
	Instruction::Mnemonic mnemonic;
	Type type1, type2, type3, type4;
	Code code1, code2;
	Flags flags;
	Exprefix exprefix;
	ECS::Byte suffix;
};

const char*const Instruction::prefixes[] {nullptr, "lock", "rep", "repne"};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "amd64.def"
};

const Register Format::base16[8] {BX, BX, BP, BP, SI, DI, BP, BX};
const Register Format::index16[8] {SI, DI, SI, DI, RVoid, RVoid, RVoid, RVoid};

constexpr Format::Entry Format::table[] {
	#define INSTR(mnem, type1, type2, type3, type4, exprefix, opcode, code1, code2, suffix, flags) \
		{opcode, Instruction::mnem, type1, type2, type3, type4, code1, code2, \
		Flags (flags | HASTYPE (type1, type2, type3, type4, mem, mem256) * HasMem | HASTYPE (type1, type2, type3, type4, moffset, moffset) * HasMOffset | \
		HASTYPE (type1, type2, type3, type4, cr, cr) * HasCR | HASTYPE (type1, type2, type3, type4, dr, dr) * HasDR | \
		HASCODE (code1, code2, r, r) * HasReg | HASCODE (code1, code2, r0, r7) * HasRV | \
		HASCODE (code1, code2, cb, cb) * HasCB | HASCODE (code1, code2, cw, cw) * HasCW | HASCODE (code1, code2, cd, cd) * HasCD | \
		HASCODE (code1, code2, ib, ib) * HasIB | HASCODE (code1, code2, iw, iw) * HasIW | HASCODE (code1, code2, id, id) * HasID | \
		HASCODE (code1, code2, iq, iq) * HasIQ | HASCODE (code1, code2, is, is) * HasIS), exprefix, suffix},
	#define HASCODE(code1, code2, first, last) (code1 >= first && code1 <= last || code2 >= first && code2 <= last)
	#define HASTYPE(type1, type2, type3, type4, first, last) (type1 >= first && type1 <= last || type2 >= first && type2 <= last || type3 >= first && type3 <= last || type4 >= first && type4 <= last)
	#include "amd64.def"
	#undef HASCODE
	#undef HASTYPE
};

const Byte Format::prefixBytes[] {0,
	#define PREFIX(prefix, byte) byte,
	#include "amd64.def"
};

constexpr Lookup<Format::Entry, Instruction::Mnemonic> Format::first {table}, Format::last {table, 0};

Operand::Operand (const AMD64::Register r) :
	model {Register}, register_ {r}
{
}

Operand::Operand (const AMD64::Immediate i, const Size s) :
	model {Immediate}, size {s}, immediate {i}
{
}

Operand::Operand (const Size si, const Segment se, const AMD64::Register r, const Index in, const Scale sc, const AMD64::Immediate im) :
	model {Memory}, size {si}, segment {se}, register_ {r}, index {in}, scale {sc}, immediate {im}
{
	assert (!segment || segment >= ES && segment <= GS);
}

Mem::Mem (const AMD64::Immediate i, const Size si, const Segment se) :
	Operand {si, se, RVoid, RVoid, 0, i}
{
}

Mem::Mem (const AMD64::Register r, const Index in, const Scale sc, const AMD64::Immediate im, const Size si, const Segment se) :
	Operand {si, se, r, in, sc, im}
{
}

Mem::Mem (const AMD64::Register r, const AMD64::Immediate i, const Size si, const Segment se) :
	Operand {si, se, r, RVoid, 0, i}
{
}

Instruction::Instruction (const OperatingMode m) :
	mode {m}
{
}

Instruction::Instruction (const OperatingMode m, const Span<const Byte> bytes) :
	mode {m}, size {Format {mode}.Decode (bytes, *this)}
{
	assert (size <= sizeof code);
	std::copy_n (bytes.begin (), size, code);
}

Instruction::Instruction (const OperatingMode om, const Prefix p, const Mnemonic m, const Operand& o1, const Operand& o2, const Operand& o3, const Operand& o4) :
	mode {om}, prefix {p}, mnemonic {m}, operand1 {o1}, operand2 {o2}, operand3 {o3}, operand4 {o4}, size {Format {mode}.Encode (*this, code, fixup)}
{
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (size); assert (bytes.size () >= size);
	std::copy_n (code, size, bytes.begin ());
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (size); if (!fixup.size) return; patch.offset += fixup.offset; patch.pattern = {fixup.size, Endianness::Little};
	if (fixup.relative && patch.mode == Object::Patch::Absolute) patch.displacement -= size - fixup.offset, patch.mode = Object::Patch::Relative;
}

Format::Format (const OperatingMode m) :
	mode {m}
{
}

std::size_t Format::Decode (const Span<const ECS::Byte> bytes, Instruction& instruction)
{
	std::size_t size = 0;
	auto byte = bytes.begin ();

	for (auto prefix = FirstLegacyPrefix; byte != bytes.end () && prefix <= LastLegacyPrefix;)
		for (prefix = FirstLegacyPrefix; prefix <= LastLegacyPrefix; prefix = Prefix (prefix + 1))
		{
			if (*byte != prefixBytes[prefix]) continue; if (prefixes[prefix]) return 0;
			if (prefix >= (mode == LongMode ? FS : ES) && prefix <= GS) segment = Register (prefix - ES + AMD64::ES);
			prefixes.set (prefix); ++size; ++byte; break;
		}

	if (byte != bytes.end () && *byte == prefixBytes[VEX2])
	{
		prefixes.set (VEX); ++size; ++byte;
		exprefix = 0x0100 | (*byte & 0x07); vvvv = (~*byte & 0x78) >> 3; ++size; ++byte;
	}
	else if (byte + 3 <= bytes.end () && (*byte == prefixBytes[XOP] && (byte[1] & 0x1f) >= 8 || *byte == prefixBytes[VEX]))
	{
		prefixes.set (*byte == prefixBytes[VEX] ? VEX : XOP); ++size; ++byte;

		for (auto prefix = FirstREXPrefix; prefix <= LastREXPrefix; prefix = Prefix (prefix + 1))
			if (!(*byte >> 5 & prefixBytes[prefix])) prefixes.set (prefix);

		exprefix = (*byte & 0x1f) << 8; ++size; ++byte;
		exprefix |= (*byte & 0x87); vvvv = (~*byte & 0x78) >> 3; ++size; ++byte;
	}
	else if (byte != bytes.end () && mode == LongMode && (*byte & 0xf0) == 0x40)
	{
		for (auto prefix = FirstREXPrefix; prefix <= LastREXPrefix; prefix = Prefix (prefix + 1))
			if (*byte & 0x0f & prefixBytes[prefix]) prefixes.set (prefix);
		++size, ++byte; prefixes.set (REX);
	}

	addressSize = prefixes[AS] ? mode == ProtectedMode ? 16u : 32u : mode;
	operandSize = mode == LongMode && prefixes[REXW] ? 64 : prefixes[OS] == (mode == RealMode) ? 32 : 16;

	if (byte != bytes.end ()) ++size, opcode = *byte++; else return 0;
	if (byte != bytes.end () && (opcode == 0x0f || opcode >= 0xd8 && opcode <= 0xdf && (*byte & 0xc0) == 0xc0) && !prefixes[XOP] && !prefixes[VEX]) ++size, opcode = (opcode << 8) + *byte++;
	if (byte != bytes.end () && (opcode == 0x0f38 || opcode == 0x0f3a)) ++size, opcode = (opcode << 8) + *byte++;

	const auto modrm = byte != bytes.end () ? *byte : 0;
	mod = (modrm & 0xc0) >> 6; reg = (modrm & 0x38) >> 3; rm = modrm & 0x07;

	entry = std::begin (table);
	while (entry != std::end (table) && !Match (*entry, *this)) ++entry;
	if (entry == std::end (table)) return 0;

	if (entry->flags & HasModRM) if (byte != bytes.end ()) ++size, ++byte; else return 0;
	else if (entry->code1 == rv) mod = 0, reg = opcode & 0x07, rm = 0;
	else mod = 0, reg = 0, rm = 0;

	ECS::Byte sib = 0;
	if (addressSize != 16 && mod != 3 && rm == 4)
		if (byte != bytes.end ()) ++size, sib = *byte++; else return 0;
	scale = (sib & 0xc0) >> 6; index = (sib & 0x38) >> 3; base = sib & 0x07;

	auto count = CountDisplacementBytes (); if (byte + count > bytes.end ()) return 0;
	displacement = 0; instruction.fixup = {size, count, (entry->flags & HasC) && !(entry->flags & FAR) || mode == LongMode && mod == 0 && rm == 5};
	for (std::size_t i = 0; i != count; ++i) displacement |= (++size, AMD64::Immediate (*byte++)) << (i * 8);
	if (count != 0 && count != 8 && displacement & (AMD64::Immediate (1) << (count * 8 - 1))) for (auto i = count; i != 8; ++i) displacement |= AMD64::Immediate (0xff) << (i * 8);

	count = CountImmediateBytes (); if (byte + count > bytes.end ()) return 0;
	immediate = 0; if (!instruction.fixup.size) instruction.fixup = {size, count, false};
	for (std::size_t i = 0; i != count; ++i) immediate |= (++size, AMD64::Immediate (*byte++)) << (i * 8);

	if (entry->flags & SFX)
	{
		if (byte != bytes.end ()) entry = std::begin (table); else return 0;
		while (entry != std::end (table) && (entry->suffix != *byte || !Match (*entry, *this))) ++entry;
		if (entry == std::end (table)) return 0; ++size, ++byte;
	}

	if (prefixes[LOCK] && !(entry->flags & PF0)) instruction.prefix = Instruction::Locked;
	else if (prefixes[REP] && !(entry->flags & PF3)) instruction.prefix = Instruction::Rep;
	else if (prefixes[REPNE] && !(entry->flags & PF2)) instruction.prefix = Instruction::Repne;
	else instruction.prefix = Instruction::NoPrefix;
	instruction.mnemonic = entry->mnemonic;
	instruction.operand1 = Decode (entry->type1);
	instruction.operand2 = Decode (entry->type2);
	instruction.operand3 = Decode (entry->type3);
	instruction.operand4 = Decode (entry->type4);
	return size;
}

std::size_t Format::Encode (const Instruction& instruction, ECS::Byte* code, Instruction::Fixup& fixup)
{
	std::size_t size = 0;

	entry = first[instruction.mnemonic]; const auto sentinel = last[instruction.mnemonic];
	while (entry != sentinel && !Match (*entry, instruction)) ++entry;
	if (entry == sentinel) return 0;

	operandSize = addressSize = 0;
	mod = reg = rm = vvvv = scale = index = base = 0;
	if (!Encode (instruction.operand1, entry->type1)) return 0;
	if (!Encode (instruction.operand2, entry->type2)) return 0;
	if (!Encode (instruction.operand3, entry->type3)) return 0;
	if (!Encode (instruction.operand4, entry->type4)) return 0;

	if (prefixes[REX]) if (IsHigh (instruction.operand1.register_) || IsHigh (instruction.operand2.register_)) return 0;

	if (entry->flags & HasRV) reg = entry->code1 - r0;
	if (!operandSize) operandSize = entry->flags & DefaultSizeMask;

	if (operandSize && operandSize != (mode == LongMode ? 32u : mode))
		if (operandSize != 64) prefixes.set (OS, (entry->flags & DefaultSizeMask) == operandSize);
		else if (!(entry->flags & D64)) prefixes.set (REX).set (REXW);
		else if (mode != LongMode) return 0;

	if (prefixes[REX] && mode != LongMode) return 0;

	if (addressSize && addressSize != mode)
		if (addressSize == 64) return false; else prefixes.set (AS);

	if (segment) prefixes.set (segment - AMD64::ES + ES);

	switch (instruction.prefix)
	{
	case Instruction::Locked: prefixes.set (LOCK); break;
	case Instruction::Rep: prefixes.set (REP); break;
	case Instruction::Repne: prefixes.set (REPNE); break;
	}

	if (entry->flags & P66) prefixes.set (OS);
	if (entry->flags & PF0) prefixes.set (LOCK);
	if (entry->flags & PF2) prefixes.set (REPNE);
	if (entry->flags & PF3) prefixes.set (REP);
	if (entry->flags & PXOP) prefixes.set (XOP);
	if (entry->flags & PVEX) prefixes.set (VEX);

	for (auto prefix = FirstLegacyPrefix; prefix <= LastLegacyPrefix; prefix = Prefix (prefix + 1))
		if (prefixes[prefix]) ++size, *code++ = prefixBytes[prefix];

	if (prefixes[VEX] && !prefixes[REXB] && !prefixes[REXX] && !prefixes[REXR] && (entry->exprefix & 0x1f80) == 0x0100)
	{
		++size, *code++ = prefixBytes[VEX2];
		++size, *code++ = entry->exprefix | ~vvvv << 3 & 0x78;
	}
	else if (prefixes[XOP] || prefixes[VEX])
	{
		++size, *code++ = prefixBytes[prefixes[VEX] ? VEX : XOP];

		*code = entry->exprefix >> 8 & 0x1f;

		for (auto prefix = FirstREXPrefix; prefix <= LastREXPrefix; prefix = Prefix (prefix + 1))
			if (!prefixes[prefix]) *code |= prefixBytes[prefix] << 5;

		++size, ++code, ++size;
		*code++ = entry->exprefix | ~vvvv << 3 & 0x78;
	}
	else if (prefixes[REX])
	{
		*code = prefixBytes[REX];
		for (auto prefix = FirstREXPrefix; prefix <= LastREXPrefix; prefix = Prefix (prefix + 1))
			if (prefixes[prefix]) *code |= prefixBytes[prefix];
		++size; ++code;
	}

	if (entry->opcode >= 0x10000) ++size, *code++ = entry->opcode >> 16;
	if (entry->opcode >= 0x100) ++size, *code++ = entry->opcode >> 8;
	++size, *code++ = entry->code1 == rv ? entry->opcode | reg : entry->opcode;

	if (entry->flags & HasModRM)
		++size, *code++ = mod << 6 | reg << 3 | rm;

	if (addressSize != 16 && mod != 3 && rm == 4)
		++size, *code++ = scale << 6 | index << 3 | base;

	auto count = CountDisplacementBytes (); fixup = {size, count, (entry->flags & HasC) && !(entry->flags & FAR) || mode == LongMode && mod == 0 && rm == 5};
	for (std::size_t i = 0; i != count; ++i) ++size, *code++ = displacement >> (i * 8);

	count = CountImmediateBytes (); if (!fixup.size) fixup = {size, count, false};
	for (std::size_t i = 0; i != count; ++i) ++size, *code++ = immediate >> (i * 8);

	if (entry->flags & SFX) ++size, *code++ = entry->suffix;

	return size;
}

std::size_t Format::CountImmediateBytes () const
{
	if (entry->flags & HasIB) return 1;
	if (entry->flags & HasIW) return 2;
	if (entry->flags & HasID) return 4;
	if (entry->flags & HasIQ) return 8;
	if (entry->flags & HasIS) return 1;
	return 0;
}

std::size_t Format::CountDisplacementBytes () const
{
	if (addressSize == 16 && mod == 0 && rm == 6) return 2;
	if (addressSize != 16 && mod == 0 && (rm == 4 && base == 5 || rm == 5)) return 4;
	if (mod == 1) return 1;
	if (mod == 2) return addressSize == 16 ? 2 : 4;
	if (entry->flags & HasMOffset) return addressSize >> 3;
	if (entry->flags & HasCB) return 1;
	if (entry->flags & HasCW) return 2;
	if (entry->flags & HasCD) return 4;
	return 0;
}

Operand Format::Decode (const Type type) const
{
	switch (type)
	{
	case one: return 1;
	case imm8: case imm16: case imm32: case imm64: return immediate;
	case simm8: return Truncate (immediate, 8);
	case simm16: return Truncate (immediate, 16);
	case simm32: return Truncate (immediate, 32);
	case rel8off: case rel16off: case rel32off: return displacement;
	case moffset: return Mem {displacement, Default, segment};
	case al: return AL;
	case cl: return CL;
	case ax: return AX;
	case dx: return DX;
	case eax: return EAX;
	case ecx: return ECX;
	case rax: return RAX;
	case es: return AMD64::ES;
	case cs: return AMD64::CS;
	case ss: return AMD64::SS;
	case ds: return AMD64::DS;
	case fs: return AMD64::FS;
	case gs: return AMD64::GS;
	case cr8: return AMD64::CR8;
	case reg8: return ModReg (AL);
	case reg16: return ModReg (AX);
	case reg32: return ModReg (EAX);
	case reg32vvvv: return Register (EAX + vvvv);
	case reg64: return ModReg (RAX);
	case reg64vvvv: return Register (RAX + vvvv);
	case mmx: return ModReg (MMX0);
	case xmm: return ModReg (XMM0);
	case ximm: return Register (XMM0 + (immediate >> 4));
	case xvvvv: return Register (XMM0 + vvvv);
	case ymm: return ModReg (YMM0);
	case yimm: return Register (YMM0 + (immediate >> 4));
	case yvvvv: return Register (YMM0 + vvvv);
	case segreg: return ModReg (AMD64::ES);
	case cr: return ModReg (CR0);
	case dr: return ModReg (DR0);
	case st0: return ST0;
	case sti: return ModReg (ST0);
	case mem: return ModMem (Default);
	case mem16: return ModMem (Word);
	case mem32: return ModMem (DWord);
	case mem64: return ModMem (QWord);
	case mem128: return ModMem (OWord);
	case mem256: return ModMem (HWord);
	case regmem8: return ModRM (AL, Byte);
	case regmem16: case reg16rm: return ModRM (AX, Word);
	case regmem32: case reg32rm: return ModRM (EAX, DWord);
	case regmem64: case reg64rm: return ModRM (RAX, QWord);
	case mmxmem32: return ModRM (MMX0, DWord);
	case mmxmem64: return ModRM (MMX0, QWord);
	case xmmmem8: return ModRM (XMM0, Byte);
	case xmmmem16: return ModRM (XMM0, Word);
	case xmmmem32: return ModRM (XMM0, DWord);
	case xmmmem64: return ModRM (XMM0, QWord);
	case xmmmem128: return ModRM (XMM0, OWord);
	case ymmmem128: return ModRM (YMM0, OWord);
	case ymmmem256: return ModRM (YMM0, HWord);
	default: return {};
	}
}

bool Format::Encode (const Operand& operand, const Type type)
{
	switch (type)
	{
	case imm8: immediate = operand.immediate; return true;
	case imm16: if (!operandSize && !(entry->flags & HasC)) operandSize = 16; immediate = operand.immediate; return true;
	case imm32: if (!operandSize && !(entry->flags & HasC)) operandSize = 32; immediate = operand.immediate; return true;
	case imm64: if (!operandSize) operandSize = 64; immediate = operand.immediate; return true;
	case simm8: immediate = operand.immediate; return true;
	case simm16: if (!operandSize) operandSize = 16; immediate = operand.immediate; return true;
	case simm32: if (!operandSize) operandSize = 32; immediate = operand.immediate; return true;
	case moffset: addressSize = mode; displacement = operand.immediate; return Segment (operand.segment) && TruncatesPreserving (displacement, addressSize);
	case ax: case dx: if (!operandSize) operandSize = 16; return true;
	case eax: case ecx: if (!operandSize) operandSize = 32; return true;
	case rax: if (!operandSize) operandSize = 64; return true;
	case rel8off: displacement = operand.immediate; return true;
	case rel16off: if (!operandSize && !(entry->flags & HasIB)) operandSize = 16; displacement = operand.immediate; return true;
	case rel32off: if (!operandSize) operandSize = 32; displacement = operand.immediate; return true;
	case reg8: return ModReg (operand, AL);
	case reg16: if (!operandSize) operandSize = 16; return ModReg (operand, AX);
	case reg32: if (!operandSize) operandSize = 32; return ModReg (operand, EAX);
	case reg32vvvv: if (!operandSize) operandSize = 32; vvvv = operand.register_ - EAX; return Base (operand.register_, R8D, REX);
	case reg64: if (!operandSize) operandSize = 64; return ModReg (operand, RAX);
	case reg64vvvv: if (!operandSize) operandSize = 64; vvvv = operand.register_ - RAX; return Base (operand.register_, R8, REX);
	case mmx: return ModReg (operand, MMX0);
	case xmm: return ModReg (operand, XMM0);
	case ximm: immediate = (operand.register_ - XMM0) << 4; return Base (operand.register_, XMM8, REX);
	case xvvvv: vvvv = operand.register_ - XMM0; return Base (operand.register_, XMM8, REX);
	case ymm: return ModReg (operand, YMM0);
	case yimm: immediate = (operand.register_ - YMM0) << 4; return Base (operand.register_, YMM8, REX);
	case yvvvv: vvvv = operand.register_ - YMM0; return Base (operand.register_, YMM8, REX);
	case segreg: return ModReg (operand, AMD64::ES);
	case cr: return ModReg (operand, CR0);
	case dr: return ModReg (operand, DR0);
	case sti: return ModReg (operand, ST0);
	case mem: case mem16: case mem32: case mem64: case mem128: case mem256: case regmem8: return ModRM (operand, AL);
	case regmem16: case reg16rm: if (!operandSize) operandSize = 16; return ModRM (operand, AX);
	case regmem32: case reg32rm: if (!operandSize) operandSize = 32; return ModRM (operand, EAX);
	case regmem64: case reg64rm: if (!operandSize) operandSize = 64; return ModRM (operand, RAX);
	case mmxmem32: case mmxmem64: return ModRM (operand, MMX0);
	case xmmmem8: case xmmmem16: case xmmmem32: case xmmmem64: case xmmmem128: return ModRM (operand, XMM0);
	case ymmmem128: case ymmmem256: return ModRM (operand, YMM0);
	default: return true;
	}
}

bool Format::Segment (const Register register_)
{
	segment = register_;
	return !register_ || register_ >= (mode == LongMode ? AMD64::FS : AMD64::ES);
}

Operand Format::ModRM (Register basereg, const Size size) const
{
	if (mod == 3 || entry->flags & (HasCR | HasDR)) return Base (basereg, rm, REXB);
	return ModMem (size);
}

Operand Format::ModMem (const Size size) const
{
	assert (mod != 3);

	if (addressSize == 16) if (mod == 0 && rm == 6) return Mem {displacement, size, segment};
	else return Mem {base16[rm], index16[rm], 1, displacement, size, segment};

	const auto basereg = addressSize == 64 ? RAX : EAX;

	if (mod == 0 && rm == 5) return Mem {mode == LongMode ? addressSize == 64 ? RIP : EIP : RVoid, displacement, size, segment};
	if (rm != 4) return Mem {Base (basereg, rm, REXB), displacement, size, segment};

	return Mem {base != 5 || mod ? Base (basereg, base, REXB) : RVoid,
		index != 4 || prefixes[REXX] ? Base (basereg, index, REXX) : RVoid, 1u << scale, displacement, size, segment};
}

bool Format::ModRM (const Operand& operand, const Register basereg)
{
	if (operand.model == Model::Register) return mod = 3, Base (operand.register_, basereg, rm, REXB);
	assert (operand.model == Memory);

	if (!Segment (operand.segment)) return false;

	if (operand.index)
		if (operand.scale == 1) scale = 0;
		else if (operand.scale == 2) scale = 1;
		else if (operand.scale == 4) scale = 2;
		else if (operand.scale == 8) scale = 3;
		else return false;

	displacement = operand.immediate;

	if (mode == RealMode && !operand.register_ && !operand.index)
		return addressSize = 16, mod = 0, rm = 6, TruncatesPreserving<std::uint64_t> (operand.immediate, addressSize);

	if (mode != LongMode && operand.register_ >= AX && operand.register_ <= DI)
	{
		for (rm = 0; rm != 8 && (operand.register_ != base16[rm] || operand.index != index16[rm]); ++rm);
		if (rm == 8) return false; addressSize = 16;

		if (operand.immediate || operand.register_ == BP)
			if (TruncatesPreserving (operand.immediate, 8)) mod = 1;
			else if (TruncatesPreserving (operand.immediate, 16)) mod = 2;
			else return false;

		return !operand.index || operand.scale == 1;
	}

	if (operand.register_ >= EAX && operand.register_ <= R15D)
		if (Base (operand.register_, EAX, rm, REXB)) addressSize = 32; else return false;
	else if (operand.register_ >= RAX && operand.register_ <= R15)
		if (Base (operand.register_, RAX, rm, REXB)) addressSize = 64; else return false;
	else if (mode == LongMode && (operand.register_ == EIP || operand.register_ == RIP))
		return addressSize = operand.register_ == RIP ? 64 : 32, mod = 0, rm = 5, !operand.index;
	else if (operand.register_) return false;

	if (operand.index >= EAX && operand.index <= R15D && operand.index != ESP)
		if ((!operand.register_ || addressSize == 32) && Base (operand.index, EAX, index, REXX)) addressSize = 32; else return false;
	else if (operand.index >= RAX && operand.index <= R15 && operand.index != RSP)
		if ((!operand.register_ || addressSize == 64) && Base (operand.index, RAX, index, REXX)) addressSize = 64; else return false;
	else if (operand.index) return false; else index = 4;

	if (operand.immediate)
		if (TruncatesPreserving (operand.immediate, 8)) mod = operand.register_ ? 1 : 0;
		else if (TruncatesPreserving (operand.immediate, 32)) mod = operand.register_ ? 2 : 0;
		else if (!operand.register_ && !operand.index && TruncatesPreserving<std::uint64_t> (operand.immediate, 32)) mod = 0;
		else return false;
	else if (operand.register_ == EBP || operand.register_ == RBP || operand.register_ == R13D || operand.register_ == R13)
		mod = 1;

	if (operand.register_ == ESP || operand.register_ == RSP || operand.register_ == R12D || operand.register_ == R12)
		base = 4, rm = 4;
	else if (operand.index)
		base = operand.register_ ? rm : 5, rm = 4;
	else if (!operand.register_)
		rm = mode == LongMode ? 4 : 5, index = 4, base = 5;

	return true;
}

Register Format::ModReg (const Register basereg) const
{
	if (basereg == AMD64::ES || basereg == ST0) return Register (basereg + reg);
	return Base (basereg, reg, entry->code1 == rv ? REXB : REXR);
}

bool Format::ModReg (const Operand& operand, const Register basereg)
{
	return Base (operand.register_, basereg, reg, entry->code1 == rv ? REXB : REXR);
}

Register Format::Base (const Register basereg, const unsigned index, const Prefix prefix) const
{
	const auto register_ = Register (basereg + prefixes[prefix] * 8 + index);
	if (IsHigh (register_) && prefixes[REX]) return Register (register_ - AH + SPL);
	return register_;
}

bool Format::Base (const Register register_, const Register prefixReg, const Prefix prefix)
{
	if (register_ >= prefixReg) if (mode == LongMode) prefixes.set (prefix); else return false;
	return true;
}

bool Format::Base (const Register register_, const Register basereg, unsigned& index, const Prefix prefix)
{
	index = register_ - basereg;
	if (register_ >= SPL && register_ <= DIL) if (mode == LongMode) prefixes.set (REX), index -= SPL - AH; else return false;
	if (index >= 8) if (mode == LongMode) prefixes.set (REX).set (prefix), index -= 8; else return false;
	return true;
}

bool Format::Match (const Flags flags, const OperatingMode mode)
{
	if ((flags & I16) && mode == RealMode) return false;
	if ((flags & I32) && mode == ProtectedMode) return false;
	if ((flags & I64) && mode == LongMode) return false;
	return true;
}

bool Format::Match (const Register register_, const Operand& operand)
{
	return operand.model == Model::Register && operand.register_ == register_;
}

bool Format::Match (const Register first, const Register last, const Operand& operand)
{
	return operand.model == Model::Register && operand.register_ >= first && operand.register_ <= last;
}

bool Format::Match (const Model model, const Size size, const Operand& operand)
{
	return operand.model == model && (!operand.size || operand.size == size);
}

bool Format::Match (const Type type, const Operand& operand)
{
	switch (type)
	{
	case none: return operand.model == Empty;
	case one: return Match (Immediate, Byte, operand) && operand.immediate == 1;
	case imm8: return Match (Immediate, Byte, operand) && operand.immediate >= -128 && operand.immediate < 256;
	case imm16: return Match (Immediate, Word, operand) && operand.immediate >= -32768 && operand.immediate < 65536;
	case imm32: return Match (Immediate, DWord, operand) && operand.immediate >= -AMD64::Immediate (2147483648) && operand.immediate < AMD64::Immediate (4294967296);
	case imm64: return Match (Immediate, QWord, operand);
	case simm8: case rel8off: return Match (Immediate, Byte, operand) && operand.immediate >= -128 && operand.immediate < 128;
	case simm16: case rel16off: return Match (Immediate, Word, operand) && operand.immediate >= -32768 && operand.immediate < 32768;
	case simm32: case rel32off: return Match (Immediate, DWord, operand) && operand.immediate >= -AMD64::Immediate (2147483648) && operand.immediate < AMD64::Immediate (2147483648);
	case moffset: return operand.model == Memory && !operand.register_ && !operand.index;
	case al: return Match (AL, operand);
	case cl: return Match (CL, operand);
	case ax: return Match (AX, operand);
	case dx: return Match (DX, operand);
	case eax: return Match (EAX, operand);
	case ecx: return Match (ECX, operand);
	case rax: return Match (RAX, operand);
	case es: return Match (AMD64::ES, operand);
	case cs: return Match (AMD64::CS, operand);
	case ss: return Match (AMD64::SS, operand);
	case ds: return Match (AMD64::DS, operand);
	case fs: return Match (AMD64::FS, operand);
	case gs: return Match (AMD64::GS, operand);
	case cr8: return Match (CR8, operand);
	case regmem8: if (Match (Memory, Byte, operand)) return true;
	case reg8: return Match (AL, R15B, operand) || Match (SPL, DIL, operand);
	case regmem16: if (Match (Memory, Word, operand)) return true;
	case reg16: case reg16rm: return Match (AX, R15W, operand);
	case regmem32: if (Match (Memory, DWord, operand)) return true;
	case reg32: case reg32rm: case reg32vvvv: return Match (EAX, R15D, operand);
	case regmem64: if (Match (Memory, QWord, operand)) return true;
	case reg64: case reg64rm: case reg64vvvv: return Match (RAX, R15, operand);
	case mmxmem32: return Match (MMX0, MMX15, operand) || Match (Memory, DWord, operand);
	case mmxmem64: if (Match (Memory, QWord, operand)) return true;
	case mmx: return Match (MMX0, MMX15, operand);
	case xmmmem8: return Match (XMM0, XMM15, operand) || Match (Memory, Byte, operand);
	case xmmmem16: return Match (XMM0, XMM15, operand) || Match (Memory, Word, operand);
	case xmmmem32: return Match (XMM0, XMM15, operand) || Match (Memory, DWord, operand);
	case xmmmem64: return Match (XMM0, XMM15, operand) || Match (Memory, QWord, operand);
	case xmmmem128: if (Match (Memory, OWord, operand)) return true;
	case xmm: case ximm: case xvvvv: return Match (XMM0, XMM15, operand);
	case ymmmem128: return Match (YMM0, YMM15, operand) || Match (Memory, OWord, operand);
	case ymmmem256: if (Match (Memory, HWord, operand)) return true;
	case ymm: case yimm: case yvvvv: return Match (YMM0, YMM15, operand);
	case segreg: return Match (AMD64::ES, AMD64::GS, operand);
	case cr: return Match (CR0, CR15, operand);
	case dr: return Match (DR0, DR15, operand);
	case st0: return Match (ST0, operand);
	case sti: return Match (ST0, ST7, operand);
	case mem: return Match (Memory, Default, operand);
	case mem16: return Match (Memory, Word, operand);
	case mem32: return Match (Memory, DWord, operand);
	case mem64: return Match (Memory, QWord, operand);
	case mem128: return Match (Memory, OWord, operand);
	case mem256: return Match (Memory, HWord, operand);
	default: return false;
	}
}

bool Format::Match (const Entry& entry, const Instruction& instruction)
{
	if (!Match (entry.flags, instruction.mode)) return false;
	if (instruction.prefix == Instruction::Locked && !(entry.flags & PLOCK)) return false;
	if (instruction.prefix == Instruction::Rep && !(entry.flags & PREP)) return false;
	if (instruction.prefix == Instruction::Repne && !(entry.flags & PREPNE)) return false;
	return Match (entry.type1, instruction.operand1) && Match (entry.type2, instruction.operand2) && Match (entry.type3, instruction.operand3) && Match (entry.type4, instruction.operand4);
}

bool Format::Match (const Entry& entry, const Format& format)
{
	if (!Match (entry.flags, format.mode)) return false;
	if (entry.mnemonic == Instruction::NOP && entry.type1 == none && format.prefixes.any ()) return false;
	if (format.prefixes[LOCK] ? !(entry.flags & (PLOCK | PF0)) : entry.flags & PF0) return false;
	if (format.prefixes[REP] ? !(entry.flags & (PREP | PF3)) : entry.flags & PF3) return false;
	if (format.prefixes[REPNE] ? !(entry.flags & (PREPNE | PF2)) : entry.flags & PF2) return false;
	if (format.prefixes[XOP] ? !(entry.flags & PXOP) : entry.flags & PXOP) return false;
	if (format.prefixes[VEX] ? !(entry.flags & PVEX) : entry.flags & PVEX) return false;
	if (entry.opcode != (entry.code1 == rv ? format.opcode & ~0x7 : format.opcode)) return false;
	if (entry.flags & (PXOP | PVEX) && (entry.exprefix & 0x1f87) != (format.exprefix & 0x1f87)) return false;
	if ((entry.flags & HasMem) && format.mod == 3) return false;
	if ((entry.flags & HasRV) && format.reg != unsigned (entry.code1 - r0)) return false;
	if ((entry.flags & P66) && !format.prefixes[OS]) return false;
	if ((entry.flags & D64) && format.mode == LongMode) return true;
	return !(entry.flags & DefaultSizeMask) || entry.flags & DefaultSizeMask & format.operandSize;
}

bool Format::IsHigh (const Register register_)
{
	return register_ >= AH && register_ <= BH;
}

std::size_t AMD64::GetSize (const Instruction& instruction)
{
	assert (instruction.size); return instruction.size;
}

std::istream& AMD64::operator >> (std::istream& stream, Register& register_)
{
	return ReadEnum (stream, register_, Operand::registers, IsAlnum);
}

std::ostream& AMD64::operator << (std::ostream& stream, const Register register_)
{
	assert (register_);
	return WriteEnum (stream, register_, Operand::registers);
}

std::ostream& AMD64::operator << (std::ostream& stream, Operand::Size size)
{
	if (size) for (auto element: Operand::sizes) if (size == 1) return stream << element; else size = Operand::Size (size >> 1); return stream;
}

std::istream& AMD64::operator >> (std::istream& stream, Operand& operand)
{
	Register register_ = RVoid; std::string identifier; Operand::Size size = Operand::Default;
	Immediate immediate = 0; std::uint64_t value = 0;

	if (stream >> std::ws && std::isalpha (stream.peek ()) && ReadIdentifier (stream, identifier, IsAlnum))
		if (FindEnum (identifier, size, Operand::sizes)) identifier.clear (), size = Operand::Size (1 << size);

	if (!identifier.empty ())
		if (!size && FindEnum (identifier, register_, Operand::registers)) operand = register_; else stream.setstate (stream.failbit);
	else if (stream >> std::ws && stream.peek () == '[' && stream.ignore ())
	{
		Register segment = RVoid, index = RVoid; Operand::Scale scale = 0;
		if (stream >> std::ws && std::isalpha (stream.peek ()) && stream >> register_) if (stream >> std::ws && stream.peek () == ':' && register_ >= ES && register_ <= GS) stream.ignore (), segment = register_, register_ = RVoid;
		if (segment && stream >> std::ws && std::isalpha (stream.peek ())) stream >> register_;
		if (register_ && stream >> std::ws && stream.peek () == '+' && stream.ignore () >> std::ws && std::isalpha (stream.peek ())) stream >> index, scale = 1;
		if (register_ && stream >> std::ws && stream.peek () == '*' && stream.ignore () >> scale) if (!index && scale != 1) std::swap (register_, index);
		if (!register_ && !index || stream >> std::ws && stream.peek () == '+' || stream.peek () == '-' || std::isdigit (stream.peek ())) stream >> immediate;
		if (stream >> std::ws && stream.get () == ']') operand = Mem {register_, index, scale, immediate, size, segment}; else stream.setstate (stream.failbit);
	}
	else if (stream.peek () == '-' && stream >> immediate) operand = {immediate, size};
	else if (stream >> value) operand = {Immediate (value), size};
	return stream;
}

std::ostream& AMD64::operator << (std::ostream& stream, const Operand& operand)
{
	if (operand.size) stream << operand.size << ' ';

	switch (operand.model)
	{
	case Operand::Immediate:
		return stream << operand.immediate;
	case Operand::Register:
		return stream << operand.register_;
	case Operand::Memory:
		stream << '[';
		if (operand.segment) stream << operand.segment << ':';
		if (operand.register_) stream << operand.register_;
		if (operand.register_ && operand.index && operand.scale) stream << " + ";
		if (operand.index && operand.scale) if (operand.scale == 1) stream << operand.index; else stream << operand.index << " * " << operand.scale;
		if (!operand.register_ && (!operand.index || !operand.scale)) stream << operand.immediate;
		else if (operand.immediate > 0 || operand.register_ == EIP || operand.register_ == RIP) stream << " + " << operand.immediate;
		else if (operand.immediate < 0) stream << " - " << -operand.immediate;
		return stream << ']';
	default:
		return stream;
	}
}

std::istream& AMD64::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Prefix prefix;
	Instruction::Mnemonic mnemonic;
	Operand operand1, operand2, operand3, operand4;

	std::string identifier;
	if (ReadIdentifier (stream, identifier, IsAlnum) && FindEnum (identifier, prefix, Instruction::prefixes)) ReadIdentifier (stream, identifier, IsAlnum); else prefix = Instruction::NoPrefix;
	if (!FindSortedEnum (identifier, mnemonic, Instruction::mnemonics)) stream.setstate (stream.failbit);

	if (stream.good () && stream >> std::ws && stream.good ())
		if (stream >> operand1 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
			if (stream >> operand2 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
				if (stream >> operand3 && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ())
					stream >> operand4;

	if (stream) instruction = {instruction.mode, prefix, mnemonic, operand1, operand2, operand3, operand4};
	return stream;
}

std::ostream& AMD64::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.size);

	if (instruction.prefix) stream << instruction.prefix << ' ';

	if (stream << instruction.mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ", " << instruction.operand2 && !IsEmpty (instruction.operand3))
				if (stream << ", " << instruction.operand3 && !IsEmpty (instruction.operand4))
					stream << ", " << instruction.operand4;

	return stream;
}

std::ostream& AMD64::operator << (std::ostream& stream, Instruction::Prefix prefix)
{
	assert (prefix);
	return WriteEnum (stream, prefix, Instruction::prefixes);
}

std::ostream& AMD64::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

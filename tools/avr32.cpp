// AVR32 instruction set representation
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

#include "avr32.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace AVR32;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type types[5];
};

const char Operand::parts[] {'b', 'l', 'u', 't'};
const char*const Operand::parameters[] {"COH"};

constexpr Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, mask, type0, type1, type2, type3, type4) \
		{AVR32::Instruction::mnem, code, mask, Operand::type0, Operand::type1, Operand::type2, Operand::type3, Operand::type4},
	#include "avr32.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "avr32.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::first {table}, Instruction::last {table, 0};

Operand::Operand (const AVR32::Immediate i) :
	model {Immediate}, immediate {i}
{
}

Operand::Operand (const AVR32::Register r) :
	model {Register}, register_ {r}
{
}

Operand::Operand (const Shift s, const AVR32::Register r) :
	model {LeftShiftRegister}, register_ {r}, shift {s}
{
}

Operand::Operand (const AVR32::Register r, const Shift s) :
	model {RightShiftRegister}, register_ {r}, shift {s}
{
}

Operand::Operand (const AVR32::Register r, const Part p) :
	model {PartialRegister}, register_ {r}, part {p}
{
}

Operand::Operand (const AVR32::Register p, const bool) :
	model {IncrementedPointer}, pointer {p}
{
}

Operand::Operand (const bool, const AVR32::Register p) :
	model {DecrementedPointer}, pointer {p}
{
}

Operand::Operand (const AVR32::Register p, const AVR32::Immediate i) :
	model {DisplacedPointer}, pointer {p}, immediate {i}
{
}

Operand::Operand (const AVR32::Register p, const AVR32::Register r, const Shift s) :
	model {LeftShiftRegisterPointer}, pointer {p}, register_ {r}, shift {s}
{
}

Operand::Operand (const AVR32::Coprocessor c) :
	model {Coprocessor}, coprocessor {c}
{
}

Operand::Operand (const AVR32::CoprocessorRegister c) :
	model {CoprocessorRegister}, cpregister {c}
{
}

Operand::Operand (const AVR32::Parameter p) :
	model {Parameter}, parameter {p}
{
}

void Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case RSP: model = Register; register_ = SP; break;
	case R0: case R0D: model = Register; register_ = AVR32::Register (opcode & 0xf); break;
	case R1D: model = Register; register_ = AVR32::Register (opcode & 0xe); break;
	case R9: model = Register; register_ = AVR32::Register (opcode >> 9 & 0xf); break;
	case R16: model = Register; register_ = AVR32::Register (opcode >> 16 & 0xf); break;
	case R16D: model = Register; register_ = AVR32::Register (opcode >> 16 & 0xe); break;
	case R16L42: model = LeftShiftRegister; register_ = AVR32::Register (opcode >> 16 & 0xf); shift = AVR32::Immediate (opcode >> 4 & 0x3); break;
	case R16L45: model = LeftShiftRegister; register_ = AVR32::Register (opcode >> 16 & 0xf); shift = AVR32::Immediate (opcode >> 4 & 0x1f); break;
	case R16R05: model = RightShiftRegister; register_ = AVR32::Register (opcode >> 16 & 0xf); shift = AVR32::Immediate (opcode & 0x1f); break;
	case R16R45: model = RightShiftRegister; register_ = AVR32::Register (opcode >> 16 & 0xf); shift = AVR32::Immediate (opcode >> 4 & 0x1f); break;
	case R16P41: model = PartialRegister; register_ = AVR32::Register (opcode >> 16 & 0xf); part = opcode & 0x10 ? T : B; break;
	case R16P121: model = PartialRegister; register_ = AVR32::Register (opcode >> 16 & 0xf); part = opcode & 0x1000 ? T : B; break;
	case R16P122: model = PartialRegister; register_ = AVR32::Register (opcode >> 16 & 0xf); part = Part (opcode >> 12 & 0x3); break;
	case R25: model = Register; register_ = AVR32::Register (opcode >> 25 & 0xf); break;
	case R25P41: model = PartialRegister; register_ = AVR32::Register (opcode >> 25 & 0xf); part = opcode & 0x10 ? T : B; break;
	case R25P51: model = PartialRegister; register_ = AVR32::Register (opcode >> 25 & 0xf); part = opcode & 0x20 ? T : B; break;
	case R25P131: model = PartialRegister; register_ = AVR32::Register (opcode >> 25 & 0xf); part = opcode & 0x2000 ? T : B; break;
	case U05: model = Immediate; immediate = AVR32::Immediate (opcode & 0x1f); break;
	case U08: model = Immediate; immediate = AVR32::Immediate (opcode & 0xff); break;
	case U08T4: model = Immediate; immediate = AVR32::Immediate (opcode & 0xff) * 4; break;
	case U016: model = Immediate; immediate = AVR32::Immediate (opcode & 0xffff); break;
	case U4194: model = Immediate; immediate = AVR32::Immediate ((opcode >> 4) & 0x1 | opcode >> 8 & 0x1e); break;
	case U45: model = Immediate; immediate = AVR32::Immediate (opcode >> 4 & 0x1f); break;
	case U48T4: model = Immediate; immediate = AVR32::Immediate (opcode >> 4 & 0xff) * 4; break;
	case U55: model = Immediate; immediate = AVR32::Immediate (opcode >> 5 & 0x1f); break;
	case U115: model = Immediate; immediate = AVR32::Immediate (opcode >> 11 & 0x1f); break;
	case U155: model = Immediate; immediate = AVR32::Immediate (opcode >> 15 & 0x1f); break;
	case U163: model = Immediate; immediate = AVR32::Immediate (opcode >> 16 & 0x7); break;
	case U164: model = Immediate; immediate = AVR32::Immediate (opcode >> 16 & 0xf); break;
	case S08: model = Immediate; immediate = AVR32::Immediate (opcode) << 24 >> 24; break;
	case S015T4: model = Immediate; immediate = AVR32::Immediate (opcode) << 17 >> 15; break;
	case S016: model = Immediate; immediate = AVR32::Immediate (opcode) << 16 >> 16; break;
	case S01620254: model = Immediate; immediate = AVR32::Immediate (opcode & 0xffff | opcode >> 4 & 0x10000 | opcode >> 8 & 0x1e0000) << 11 >> 11; break;
	case S01620254T2: model = Immediate; immediate = AVR32::Immediate (opcode & 0xffff | opcode >> 4 & 0x10000 | opcode >> 8 & 0x1e0000) << 11 >> 10; break;
	case S43WZ: model = Immediate; immediate = AVR32::Immediate (opcode & 0x70) << 25 >> 29; immediate += immediate >= 0; break;
	case S46: model = Immediate; immediate = AVR32::Immediate (opcode & 0x3f0) << 22 >> 26; break;
	case S48: model = Immediate; immediate = AVR32::Immediate (opcode & 0xff0) << 20 >> 24; break;
	case S48T2: model = Immediate; immediate = AVR32::Immediate (opcode & 0xff0) << 20 >> 23; break;
	case S48T4: model = Immediate; immediate = AVR32::Immediate (opcode & 0xff0) << 20 >> 22; break;
	case P0U48T4: model = DisplacedPointer; pointer = AVR32::Register (opcode & 0xf); immediate = AVR32::Immediate (opcode >> 4 & 0xff) * 4; break;
	case P0L8S42: model = LeftShiftRegisterPointer; pointer = AVR32::Register (opcode & 0xf); register_ = AVR32::Register (opcode >> 8 & 0xf); shift = AVR32::Immediate (opcode >> 4 & 0x3); break;
	case P9I: model = IncrementedPointer; pointer = AVR32::Register (opcode >> 9 & 0xf); break;
	case P9D: model = DecrementedPointer; pointer = AVR32::Register (opcode >> 9 & 0xf); break;
	case P9U43: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 9 & 0xf); immediate = AVR32::Immediate (opcode >> 4 & 0x7); break;
	case P9U43T2: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 9 & 0xf); immediate = AVR32::Immediate (opcode >> 4 & 0x7) * 2; break;
	case P9U44T4: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 9 & 0xf); immediate = AVR32::Immediate (opcode >> 4 & 0xf) * 4; break;
	case P9U45T4: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 9 & 0xf); immediate = AVR32::Immediate (opcode >> 4 & 0x1f) * 4; break;
	case P16D: model = DecrementedPointer; pointer = AVR32::Register (opcode >> 16 & 0xf); break;
	case P16U08T4: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 16 & 0xf); immediate = AVR32::Immediate (opcode & 0xff) * 4; break;
	case P16U08124T4: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 16 & 0xf); immediate = AVR32::Immediate (opcode & 0xff | opcode >> 4 & 0xf00) * 4; break;
	case P16S011: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 16 & 0xf); immediate = AVR32::Immediate (opcode & 0x7ff) << 21 >> 21; break;
	case P16S016: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 16 & 0xf); immediate = AVR32::Immediate (opcode & 0xffff) << 16 >> 16; break;
	case P16S016T4: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 16 & 0xf); immediate = AVR32::Immediate (opcode & 0xffff) << 16 >> 14; break;
	case P16L0S42: model = LeftShiftRegisterPointer; pointer = AVR32::Register (opcode >> 16 & 0xf); register_ = AVR32::Register (opcode & 0xf); shift = AVR32::Immediate (opcode >> 4 & 0x3); break;
	case P25U09: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 25 & 0xf); immediate = AVR32::Immediate (opcode & 0x1ff); break;
	case P25U09T2: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 25 & 0xf); immediate = AVR32::Immediate (opcode & 0x1ff) * 2; break;
	case P25U09T4: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 25 & 0xf); immediate = AVR32::Immediate (opcode & 0x1ff) * 4; break;
	case P25S012: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 25 & 0xf); immediate = AVR32::Immediate (opcode & 0xffff) << 20 >> 20; break;
	case P25S012T2: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 25 & 0xf); immediate = AVR32::Immediate (opcode & 0xffff) << 20 >> 19; break;
	case P25S012T4: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 25 & 0xf); immediate = AVR32::Immediate (opcode & 0xffff) << 20 >> 18; break;
	case P25S016: model = DisplacedPointer; pointer = AVR32::Register (opcode >> 25 & 0xf); immediate = AVR32::Immediate (opcode & 0xffff) << 16 >> 16; break;
	case P25L16S42: model = LeftShiftRegisterPointer; pointer = AVR32::Register (opcode >> 25 & 0xf); register_ = AVR32::Register (opcode >> 16 & 0xf); shift = AVR32::Immediate (opcode >> 4 & 0x3); break;
	case PPCU47T4: model = DisplacedPointer; pointer = PC; immediate = AVR32::Immediate (opcode >> 4 & 0x7f) * 4; break;
	case PPCS01620254T2: model = DisplacedPointer; pointer = PC; immediate = AVR32::Immediate (opcode & 0xffff | opcode >> 4 & 0x10000 | opcode >> 8 & 0x1e0000) << 11 >> 10; break;
	case PPCS4802T2: model = DisplacedPointer; pointer = PC; immediate = AVR32::Immediate (opcode >> 4 & 0xff | opcode << 8 & 0x300) << 22 >> 21; break;
	case PSPU47T4: model = DisplacedPointer; pointer = SP; immediate = AVR32::Immediate (opcode >> 4 & 0x7f) << 22 >> 21; break;
	case CP13: model = Coprocessor; coprocessor = AVR32::Coprocessor (opcode >> 13 & 0x7); break;
	case CR0: model = CoprocessorRegister; cpregister = AVR32::CoprocessorRegister (opcode & 0xf); break;
	case CR4: model = CoprocessorRegister; cpregister = AVR32::CoprocessorRegister (opcode >> 4 & 0xf); break;
	case CR8: model = CoprocessorRegister; cpregister = AVR32::CoprocessorRegister (opcode >> 8 & 0xf); break;
	case CR9D: model = CoprocessorRegister; cpregister = AVR32::CoprocessorRegister (opcode >> 8 & 0xe); break;
	case COP: model = Immediate; immediate = AVR32::Immediate (opcode >> 12 & 0x1 | opcode >> 15 & 0x1e | opcode >> 20 & 0x60); break;
	case COH: model = Parameter; parameter = AVR32::COH; break;
	default: model = Empty;
	}
}

Opcode Operand::Encode (const Type type) const
{
	switch (type)
	{
	case R0: case R0D: case R1D: return Opcode (register_);
	case R9: return Opcode (register_) << 9;
	case R16: case R16D: return Opcode (register_) << 16;
	case R16L42: case R16L45: case R16R45: return Opcode (register_) << 16 | Opcode (model == Register ? 0 : shift) << 4;
	case R16R05: return Opcode (register_) << 16 | Opcode (model == Register ? 0 : shift);
	case R16P41: return Opcode (register_) << 16 | Opcode (part & 0x1) << 4;
	case R16P121: return Opcode (register_) << 16 | Opcode (part & 0x1) << 12;
	case R16P122: return Opcode (register_) << 16 | Opcode (part) << 12;
	case R25: return Opcode (register_) << 25;
	case R25P41: return Opcode (register_) << 25 | Opcode (part & 0x1) << 4;
	case R25P51: return Opcode (register_) << 25 | Opcode (part & 0x1) << 5;
	case R25P131: return Opcode (register_) << 25 | Opcode (part & 0x1) << 13;
	case U05: case U08: case U016: return Opcode (immediate);
	case U08T4: return Opcode (immediate / 4);
	case U4194: return Opcode (immediate & 0x1) << 4 | Opcode (immediate & 0x1e) << 8;
	case U45: return Opcode (immediate) << 4;
	case U48T4: return Opcode (immediate / 4) << 4;
	case U55: return Opcode (immediate) << 5;
	case U115: return Opcode (immediate) << 11;
	case U155: return Opcode (immediate) << 15;
	case U163: case U164: return Opcode (immediate) << 16;
	case S08: return Opcode (immediate & 0xff);
	case S015T4: return Opcode (immediate / 4 & 0x7fff);
	case S016: return Opcode (immediate & 0xffff);
	case S01620254: return Opcode (immediate & 0xffff) | Opcode (immediate & 0x10000) << 4 | Opcode (immediate & 0x1e0000) << 8;
	case S01620254T2: case PPCS01620254T2: return Opcode (immediate / 2 & 0xffff) | Opcode (immediate / 2 & 0x10000) << 4 | Opcode (immediate / 2 & 0x1e0000) << 8;
	case S43WZ: return Opcode ((immediate > 0 ? immediate - 1 : immediate) & 0x7) << 4;
	case S46: return Opcode (immediate & 0x3f) << 4;
	case S48: return Opcode (immediate & 0xff) << 4;
	case S48T2: return Opcode (immediate / 2 & 0xff) << 4;
	case S48T4: return Opcode (immediate / 4 & 0xff) << 4;
	case P0U48T4: return Opcode (pointer) | Opcode (immediate / 4) << 4;
	case P0L8S42: return Opcode (pointer) | Opcode (register_) << 8 | Opcode (shift) << 4;
	case P9I: case P9D: return Opcode (pointer) << 9;
	case P9U43: return Opcode (pointer) << 9 | Opcode (immediate) << 4;
	case P9U43T2: return Opcode (pointer) << 9 | Opcode (immediate / 2) << 4;
	case P9U44T4: case P9U45T4: return Opcode (pointer) << 9 | Opcode (immediate / 4) << 4;
	case P16D: return Opcode (pointer) << 16;
	case P16U08T4: return Opcode (pointer) << 16 | Opcode (immediate / 4);
	case P16U08124T4: return Opcode (pointer) << 16 | Opcode (immediate / 4 & 0xff) | Opcode (immediate / 4 & 0xf00) << 4;
	case P16S011: return Opcode (pointer) << 16 | Opcode (immediate & 0x7ff);
	case P16S016: return Opcode (pointer) << 16 | Opcode (immediate & 0xffff);
	case P16S016T4: return Opcode (pointer) << 16 | Opcode (immediate & 0xffff);
	case P16L0S42: return Opcode (pointer) << 16 | Opcode (register_) | Opcode (shift) << 4;
	case P25U09: return Opcode (pointer) << 25 | Opcode (immediate);
	case P25U09T2: return Opcode (pointer) << 25 | Opcode (immediate / 2);
	case P25U09T4: return Opcode (pointer) << 25 | Opcode (immediate / 4);
	case P25S012: return Opcode (pointer) << 25 | Opcode (immediate & 0xfff);
	case P25S012T2: return Opcode (pointer) << 25 | Opcode (immediate / 2 & 0xfff);
	case P25S012T4: return Opcode (pointer) << 25 | Opcode (immediate / 4 & 0xfff);
	case P25S016: return Opcode (pointer) << 25 | Opcode (immediate & 0xffff);
	case P25L16S42: return Opcode (pointer) << 25 | Opcode (register_) << 16 | Opcode (shift) << 4;
	case PPCU47T4: case PSPU47T4: return Opcode (immediate / 4) << 4;
	case PPCS4802T2: return Opcode (immediate / 2 & 0xff) << 4 | Opcode (immediate / 2 & 0x300) >> 8;
	case CP13: return Opcode (coprocessor) << 13;
	case CR0: return Opcode (cpregister);
	case CR4: return Opcode (cpregister) << 4;
	case CR8: case CR9D: return Opcode (cpregister) << 8;
	case COP: return Opcode (immediate & 0x1) << 12 | Opcode (immediate & 0x1e) << 15 | Opcode (immediate & 0x60) << 20;
	default: return 0;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case RSP: return model == Register && register_ == SP;
	case R0: case R9: case R16: case R25: return model == Register;
	case R0D: case R1D: case R16D: return model == Register && register_ % 2 == 0;
	case R16L42: return model == Register || model == LeftShiftRegister && shift <= 3;
	case R16L45: return model == Register || model == LeftShiftRegister && shift <= 31;
	case R16R05: case R16R45: return model == Register || model == RightShiftRegister && shift <= 31;
	case R16P41: case R16P121: case R25P41: case R25P51: case R25P131: return model == PartialRegister && (part == B || part == T);
	case R16P122: return model == PartialRegister;
	case U05: case U4194: case U45: case U55: case U115: case U155: return model == Immediate && immediate >= 0 && immediate <= 31;
	case U08: return model == Immediate && immediate >= 0 && immediate <= 255;
	case U08T4: case U48T4: return model == Immediate && immediate >= 0 && immediate <= 1020 && immediate % 4 == 0;
	case U016: return model == Immediate && immediate >= 0 && immediate <= 65535;
	case U163: return model == Immediate && immediate >= 0 && immediate <= 7;
	case U164: return model == Immediate && immediate >= 0 && immediate <= 15;
	case S08: case S48: return model == Immediate && immediate >= -128 && immediate <= 127;
	case S016: return model == Immediate && immediate >= -32768 && immediate <= 32767;
	case S015T4: return model == Immediate && immediate >= -65536 && immediate <= 65532 && immediate % 4 == 0;
	case S01620254: return model == Immediate && immediate >= -1048576 && immediate <= 1048575;
	case S01620254T2: return model == Immediate && immediate >= -2097152 && immediate <= 2097150 && immediate % 2 == 0;
	case S43WZ: return model == Immediate && immediate >= -4 && immediate <= 4 && immediate != 0;
	case S46: return model == Immediate && immediate >= -32 && immediate <= 31;
	case S48T2: return model == Immediate && immediate >= -256 && immediate <= 254 && immediate % 2 == 0;
	case S48T4: return model == Immediate && immediate >= -512 && immediate <= 508 && immediate % 4 == 0;
	case P0U48T4: case P16U08T4: return model == DisplacedPointer && immediate >= 0 && immediate <= 1020 && immediate % 4 == 0;
	case P0L8S42: case P16L0S42: case P25L16S42: return model == LeftShiftRegisterPointer && shift <= 3;
	case P9I: return model == IncrementedPointer;
	case P9D: case P16D: return model == DecrementedPointer;
	case P9U43: return model == DisplacedPointer && immediate >= 0 && immediate <= 7;
	case P9U43T2: return model == DisplacedPointer && immediate >= 0 && immediate <= 14 && immediate % 2 == 0;
	case P9U44T4: return model == DisplacedPointer && immediate >= 0 && immediate <= 60 && immediate % 4 == 0;
	case P9U45T4: return model == DisplacedPointer && immediate >= 0 && immediate <= 124 && immediate % 4 == 0;
	case P16U08124T4: return model == DisplacedPointer && immediate >= 0 && immediate <= 16380 && immediate % 4 == 0;
	case P16S011: return model == DisplacedPointer && immediate >= -1024 && immediate <= 1023;
	case P16S016: case P25S016: return model == DisplacedPointer && immediate >= -32768 && immediate <= 32767;
	case P16S016T4: return model == DisplacedPointer && immediate >= -131072 && immediate <= 131068 && immediate % 4 == 0;
	case P25U09: return model == DisplacedPointer && immediate >= 0 && immediate <= 511;
	case P25U09T2: return model == DisplacedPointer && immediate >= 0 && immediate <= 1022 && immediate % 2 == 0;
	case P25U09T4: return model == DisplacedPointer && immediate >= 0 && immediate <= 2044 && immediate % 4 == 0;
	case P25S012: return model == DisplacedPointer && immediate >= -2048 && immediate <= 2047;
	case P25S012T2: return model == DisplacedPointer && immediate >= -4096 && immediate <= 4094 && immediate % 2 == 0;
	case P25S012T4: return model == DisplacedPointer && immediate >= -8192 && immediate <= 8188 && immediate % 4 == 0;
	case PPCU47T4: return (model == Immediate || model == DisplacedPointer && pointer == PC) && immediate >= 0 && immediate <= 508 && immediate % 4 == 0;
	case PPCS01620254T2: return (model == Immediate || model == DisplacedPointer && pointer == PC) && immediate >= -2097152 && immediate <= 2097150 && immediate % 2 == 0;
	case PPCS4802T2: return (model == Immediate || model == DisplacedPointer && pointer == PC) && immediate >= -1024 && immediate <= 1022 && immediate % 2 == 0;
	case PSPU47T4: return model == DisplacedPointer && pointer == SP && immediate >= 0 && immediate <= 508 && immediate % 4 == 0;
	case CP13: return model == Coprocessor;
	case CR0: case CR4: case CR8: return model == CoprocessorRegister;
	case CR9D: return model == CoprocessorRegister && cpregister % 2 == 0;
	case COP: return model == Immediate && immediate >= 0 && immediate <= 127;
	case COH: return model == Parameter && parameter == AVR32::COH;
	default: return model == Empty;
	}
}

Instruction::Instruction (const Span<const Byte> bytes)
{
	auto byte = bytes.begin ();
	for (Opcode opcode = 0, mask = 0xffff; mask; opcode <<= 16, mask <<= 16)
	{
		if (byte == bytes.end ()) break;
		opcode |= *byte++ << 8;

		if (byte == bytes.end ()) break;
		opcode |= *byte++;

		for (auto& entry: table)
			if ((opcode & entry.mask) == entry.opcode && entry.mask & mask)
			{
				for (auto& operand: operands) operand.Decode (opcode, entry.types[GetIndex (operand, operands)]);
				this->entry = &entry;
			}
	}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o0, const Operand& o1, const Operand& o2, const Operand& o3, const Operand& o4) :
	operands {o0, o1, o2, o3, o4}
{
	for (auto& entry: Span<const Entry> {first[mnemonic], last[mnemonic]})
		for (auto& operand: operands) if (!operand.IsCompatibleWith (entry.types[GetIndex (operand, operands)])) break;
			else if (IsLast (operand, operands)) {this->entry = &entry; return;}
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); const auto size = GetSize (*this); assert (bytes.size () >= size); auto opcode = entry->opcode;
	for (auto& operand: operands) opcode |= operand.Encode (entry->types[GetIndex (operand, operands)]);
	if (size == 4) bytes[0] = opcode >> 24, bytes[1] = opcode >> 16;
	bytes[size - 2] = opcode >> 8; bytes[size - 1] = opcode;
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	if (entry->types[1] == Operand::S016 || entry->types[1] == Operand::U016) patch.offset += 2, patch.pattern = {2, Endianness::Big};
}

std::size_t AVR32::GetSize (const Instruction& instruction)
{
	assert (instruction.entry);
	return instruction.entry->mask >> 16 ? 4 : 2;
}

Register AVR32::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

Instruction AVR32::ExtendBranch (const Instruction& instruction)
{
	assert (instruction.entry); Instruction result = instruction;
	if (result.entry->mnemonic == Instruction::RJMP) result.entry = Instruction::first[Instruction::BRAL];
	else if (result.entry->types[0] == Operand::S48T2) ++result.entry;
	assert (result.entry->types[0] == Operand::S01620254T2);
	return result;
}

std::istream& AVR32::operator >> (std::istream& stream, Register& register_)
{
	char c = 0; if (stream >> std::ws && stream.get (c) && c == 's' && stream.get () == 'p') return register_ = SP, stream;
	if (c == 'l' && stream.get () == 'r') return register_ = LR, stream;
	if (c == 'p' && stream.get () == 'c') return register_ = PC, stream;
	return ReadPrefixedValue (stream.putback (c), register_, "r", R0, R15);
}

std::ostream& AVR32::operator << (std::ostream& stream, const Register register_)
{
	if (register_ == SP) return stream << "sp"; if (register_ == LR) return stream << "lr"; if (register_ == PC) return stream << "pc";
	return WritePrefixedValue (stream, register_, "r", R0);
}

std::istream& AVR32::operator >> (std::istream& stream, Coprocessor& coprocessor)
{
	return ReadPrefixedValue (stream, coprocessor, "cp", CP0, CP7);
}

std::ostream& AVR32::operator << (std::ostream& stream, const Coprocessor coprocessor)
{
	return WritePrefixedValue (stream, coprocessor, "cp", CP0);
}

std::istream& AVR32::operator >> (std::istream& stream, CoprocessorRegister& cpregister)
{
	return ReadPrefixedValue (stream, cpregister, "cr", CR0, CR15);
}

std::ostream& AVR32::operator << (std::ostream& stream, const CoprocessorRegister cpregister)
{
	return WritePrefixedValue (stream, cpregister, "cr", CR0);
}

std::istream& AVR32::operator >> (std::istream& stream, Part& part)
{
	return ReadEnum (stream, part, Operand::parts);
}

std::ostream& AVR32::operator << (std::ostream& stream, const Part part)
{
	return WriteEnum (stream, part, Operand::parts);
}

std::istream& AVR32::operator >> (std::istream& stream, Parameter& parameter)
{
	return ReadEnum (stream, parameter, Operand::parameters, IsAlpha);
}

std::ostream& AVR32::operator << (std::ostream& stream, const Parameter parameter)
{
	return WriteEnum (stream, parameter, Operand::parameters);
}

std::istream& AVR32::operator >> (std::istream& stream, Operand& operand)
{
	union {Register register_; Coprocessor coprocessor; CoprocessorRegister cpregister;};
	union {Immediate immediate; Shift shift; Part part; Parameter parameter;}; Register pointer;
	if (stream >> std::ws && (stream.peek () == 'r' || stream.peek () == 's' || stream.peek () == 'l' || stream.peek () == 'p') && stream >> register_)
		if (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '<')
			if (stream.ignore ().get () == '<' && stream >> shift) operand = {shift, register_}; else stream.setstate (stream.failbit);
		else if (stream.good () && stream.peek () == '>')
			if (stream.ignore ().get () == '>' && stream >> shift) operand = {register_, shift}; else stream.setstate (stream.failbit);
		else if (stream.good () && stream.peek () == ':')
			if (stream.ignore () >> part) operand = {register_, part}; else stream.setstate (stream.failbit);
		else if (stream.good () && stream.peek () == '+')
			if (stream.ignore ().get () == '+') operand = {register_, false}; else stream.setstate (stream.failbit);
		else if (stream.good () && stream.peek () == '[')
			if (stream.ignore () && (stream.peek () == 'r' || stream.peek () == 's' || stream.peek () == 'l' || stream.peek () == 'p') && stream >> pointer)
				if (stream >> std::ws && stream.peek () == '<')
					if (stream.ignore ().get () == '<' && stream >> shift >> std::ws && stream.get () == ']') operand = {register_, pointer, shift}; else stream.setstate (stream.failbit);
				else if (stream.get () == ']') operand = {register_, pointer, 0}; else stream.setstate (stream.failbit);
			else if (stream >> immediate >> std::ws && stream.get () == ']') operand = {register_, immediate}; else stream.setstate (stream.failbit);
		else operand = register_;
	else if (stream.peek () == '-')
		if (stream.ignore ().peek () == '-' && stream.ignore () >> register_) operand = {false, register_};
		else if (stream >> immediate) operand = -immediate;
		else stream.setstate (stream.failbit);
	else if (stream.peek () == 'c')
		if (stream.ignore ().peek () == 'p' && stream.putback ('c') >> coprocessor) operand = coprocessor;
		else if (stream.peek () == 'r' && stream.putback ('c') >> cpregister) operand = cpregister;
		else stream.setstate (stream.failbit);
	else if (std::isalpha (stream.peek ()) && stream >> parameter) operand = parameter;
	else if (stream >> immediate) operand = immediate;
	return stream;
}

std::ostream& AVR32::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::Register: return stream << operand.register_;
	case Operand::LeftShiftRegister: stream << operand.register_; if (operand.shift) stream << " << " << operand.shift; return stream;
	case Operand::RightShiftRegister: stream << operand.register_; if (operand.shift) stream << " >> " << operand.shift; return stream;
	case Operand::PartialRegister: return stream << operand.register_ << ':' << operand.part;
	case Operand::IncrementedPointer: return stream << operand.pointer << "++";
	case Operand::DecrementedPointer: return stream << "--" << operand.pointer;
	case Operand::DisplacedPointer: return stream << operand.pointer << '[' << operand.immediate << ']';
	case Operand::LeftShiftRegisterPointer: stream << operand.pointer << '[' << operand.register_;
		if (operand.shift) stream << " << " << operand.shift; return stream << ']';
	case Operand::Coprocessor: return stream << operand.coprocessor;
	case Operand::CoprocessorRegister: return stream << operand.cpregister;
	case Operand::Parameter: return stream << operand.parameter;
	default: return stream;
	}
}

std::istream& AVR32::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic; std::array<Operand, 5> operands;
	if (stream >> mnemonic && stream.good () && stream >> std::ws && stream.good ())
		for (auto& operand: operands) if (stream >> operand && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ()) continue; else break;
	if (stream) instruction = {mnemonic, operands[0], operands[1], operands[2], operands[3], operands[4]};
	return stream;
}

std::ostream& AVR32::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry); stream << instruction.entry->mnemonic;
	for (auto& operand: instruction.operands) if (IsEmpty (operand)) break; else (IsFirst (operand, instruction.operands) ? stream << '\t' : stream << ", ") << operand;
	return stream;
}

std::istream& AVR32::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsDotted);
}

std::ostream& AVR32::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

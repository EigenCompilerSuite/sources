// ARM T32 instruction set representation
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

#include "armt32.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace ARM;
using namespace T32;

struct T32::Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type types[6];
	Flags flags;

	Opcode Encode (ConditionCode) const;
	ConditionCode Decode (Opcode, ConditionCode) const;
};

constexpr T32::Instruction::Entry T32::Instruction::table[] {
	#define INSTR(mnem, code, mask, type0, type1, type2, type3, type4, type5, flags) \
		{Instruction::mnem, code, mask, {Operand::type0, Operand::type1, Operand::type2, Operand::type3, Operand::type4, Operand::type5}, Flags (flags)},
	#include "armt32.def"
};

constexpr Lookup<T32::Instruction::Entry, T32::Instruction::Mnemonic> T32::Instruction::first {table}, T32::Instruction::last {table, 0};

bool T32::Operand::Decode (const Opcode opcode, const Type type)
{
	switch (type)
	{
	case I04: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xf); break;
	case I04D: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xf) + 1; break;
	case I05: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0x1f); break;
	case I05D: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0x1f) + 1; break;
	case I05P: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0x1f) - this[-1].immediate + 1; break;
	case I05W: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0x1f) + 1; break;
	case I06: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0x3f); break;
	case I07T4: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0x7f) * 4; break;
	case I08: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xff); break;
	case I08T4: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xff) * 4; break;
	case I012: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xff | opcode >> 4 & 0x700 | opcode >> 15 & 0x800); break;
	case I012N: model = Immediate; immediate = -ARM::Immediate (opcode >> 0 & 0xff | opcode >> 4 & 0x700 | opcode >> 15 & 0x800); break;
	case I0162: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xfff | opcode >> 4 & 0xf000); break;
	case I0164: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xff | opcode >> 4 & 0x700 | opcode >> 15 & 0x800 | opcode >> 4 & 0xf000); break;
	case I31: model = Immediate; immediate = ARM::Immediate (opcode >> 3 & 0x1); break;
	case I36T2: model = Immediate; immediate = ARM::Immediate (opcode >> 3 & 0x1f | opcode >> 4 & 0x20) * 2; break;
	case I44: model = Immediate; immediate = ARM::Immediate (opcode >> 4 & 0xf); break;
	case I53: model = Immediate; immediate = ARM::Immediate (opcode >> 5 & 0x7); break;
	case I63: model = Immediate; immediate = ARM::Immediate (opcode >> 6 & 0x7); break;
	case I65O: model = Immediate; immediate = ARM::Immediate (opcode >> 6 & 0x1f); break;
	case I65M: model = Immediate; immediate = (ARM::Immediate (opcode >> 6 & 0x1f) + 31) % 32 + 1; break;
	case I612: case I612O: model = Immediate; immediate = ARM::Immediate (opcode >> 6 & 0x3 | opcode >> 10 & 0x1c); break;
	case I612M: model = Immediate; immediate = (ARM::Immediate (opcode >> 6 & 0x3 | opcode >> 10 & 0x1c) + 31) % 32 + 1; break;
	case I164: model = Immediate; immediate = ARM::Immediate (opcode >> 16 & 0xf); break;
	case I213: model = Immediate; immediate = ARM::Immediate (opcode >> 21 & 0x7); break;
	case IC: model = Immediate; immediate = Decode (opcode); break;
	case I0: model = Immediate; immediate = 0; break;
	case O08: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xff) << 24 >> 23; break;
	case O099: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xff); if (!(opcode >> 9 & 1)) immediate = -immediate; break;
	case O0992: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xff) * 2; if (!(opcode >> 23 & 1)) immediate = -immediate; break;
	case O0923: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xff) * 4; if (!(opcode >> 23 & 1)) immediate = -immediate; break;
	case O011: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0x7ff) << 21 >> 20; break;
	case O012: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0xfff); if (!(opcode >> 23 & 1)) immediate = -immediate; break;
	case O020: model = Immediate; immediate = ARM::Immediate (opcode >> 0 & 0x7ff | opcode >> 5 & 0x1f800 | opcode << 4 & 0x20000 | opcode << 7 & 0x40000 | opcode >> 7 & 0x80000) << 12 >> 11; break;
	case O024: case O024H: {model = Immediate; const auto s = opcode >> 26 & 0x1; immediate = ARM::Immediate (opcode >> 0 & 0x7ff | opcode >> 5 & 0x1ff800 | (opcode >> 11 ^ ~s) << 21 & 0x200000 | (opcode >> 13 ^ ~s) << 22 & 0x400000 | s << 23) << 8 >> 7; break;}
	case R08: if ((opcode >> 0 & 0xf) != (opcode >> 8 & 0xf)) return false;
	case R0: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 0 & 0xf)); writeBack = false; break;
	case R03N: if ((opcode >> 0 & 0x7) != (opcode >> 3 & 0x7)) return false;
	case R0N: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 0 & 0x7)); writeBack = false; break;
	case R07: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 0 & 0x7 | opcode >> 4 & 0x8)); writeBack = false; break;
	case R3: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 3 & 0xf)); writeBack = false; break;
	case R3N: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 3 & 0x7)); writeBack = false; break;
	case R6N: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 6 & 0x7)); writeBack = false; break;
	case R816: if ((opcode >> 8 & 0xf) != (opcode >> 16 & 0xf)) return false;
	case R8: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 8 & 0xf)); writeBack = false; break;
	case R8WN: case R8N: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 8 & 0x7)); writeBack = type == R8WN; break;
	case R8NW: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 8 & 0x7)); writeBack = !(this[1].model == RegisterList && this[1].registerSet & 1 << register_); break;
	case R12: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 12 & 0xf)); writeBack = false; break;
	case R016: if ((opcode >> 0 & 0xf) != (opcode >> 16 & 0xf)) return false;
	case R16: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); writeBack = false; break;
	case R16W: model = Register; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); writeBack = (opcode >> 21 & 1); break;
	case RSP: model = Register; register_ = ARM::SP; writeBack = false; break;
	case RSPW: model = Register; register_ = ARM::SP; writeBack = (opcode >> 21 & 1); break;
	case RLR: model = Register; register_ = ARM::LR; writeBack = false; break;
	case RPC: model = Register; register_ = ARM::PC; writeBack = false; break;
	case D0: model = Register; register_ = ARM::Register (ARM::D0 + (opcode >> 0 & 0xf | opcode >> 1 & 0x10)); writeBack = false; break;
	case D1216: if ((opcode >> 12 & 0xf) != (opcode >> 16 & 0xf) || (opcode >> 22 & 0x1) != (opcode >> 7 & 0x1)) return false;
	case D12: model = Register; register_ = ARM::Register (ARM::D0 + (opcode >> 12 & 0xf | opcode >> 18 & 0x10)); writeBack = false; break;
	case D16: model = Register; register_ = ARM::Register (ARM::D0 + (opcode >> 16 & 0xf | opcode >> 3 & 0x10)); writeBack = false; break;
	case S0: model = Register; register_ = ARM::Register (ARM::S0 + (opcode >> 5 & 0x1 | opcode << 1 & 0x1e)); writeBack = false; break;
	case S1216: if ((opcode >> 12 & 0xf) != (opcode >> 16 & 0xf) || (opcode >> 22 & 0x1) != (opcode >> 7 & 0x1)) return false;
	case S12: model = Register; register_ = ARM::Register (ARM::S0 + (opcode >> 22 & 0x1 | opcode >> 11 & 0x1e)); writeBack = false; break;
	case S16: model = Register; register_ = ARM::Register (ARM::S0 + (opcode >> 7 & 0x1 | opcode >> 15 & 0x1e)); writeBack = false; break;
	case Q0: model = Register; register_ = ARM::Register (ARM::Q0 + (opcode >> 1 & 0x7 | opcode >> 2 & 0x8)); writeBack = false; break;
	case Q1216: if ((opcode >> 12 & 0xf) != (opcode >> 16 & 0xf) || (opcode >> 22 & 0x1) != (opcode >> 7 & 0x1)) return false;
	case Q12: model = Register; register_ = ARM::Register (ARM::Q0 + (opcode >> 13 & 0x7 | opcode >> 19 & 0x8)); writeBack = false; break;
	case Q16: model = Register; register_ = ARM::Register (ARM::Q0 + (opcode >> 17 & 0x7 | opcode >> 4 & 0x8)); writeBack = false; break;
	case SR0: model = ShiftedRegister; register_ = ARM::Register (ARM::R0 + (opcode >> 0 & 0xf)); mode = ARM::ShiftMode (ARM::LSL + (opcode >> 21 & 0x3)); break;
	case LSL3: case LSR3: case ASR3: case ROR3: model = ShiftedRegister; register_ = ARM::Register (ARM::R0 + (opcode >> 3 & 0x7)); mode = ARM::ShiftMode (type - LSL3); break;
	case RL08: model = RegisterList; registerSet = RegisterSet (opcode >> 0 & 0xff); break;
	case RL08P: model = RegisterList; registerSet = RegisterSet (opcode >> 0 & 0xff | opcode << 7 & 0x8000); break;
	case RL016: model = RegisterList; registerSet = RegisterSet (opcode >> 0 & 0xffff); break;
	case RL12: model = RegisterList; registerSet = RegisterSet (1 << (opcode >> 12 & 0xf)); break;
	case DRL: model = DoubleRegisterList; registerSet = RegisterSet ((1 << (opcode & 0xff) / 2) - 1) << RegisterSet (opcode >> 12 & 0xf | opcode >> 18 & 0x10); break;
	case SRL: model = SingleRegisterList; registerSet = RegisterSet ((1 << (opcode & 0xff) / 1) - 1) << RegisterSet (opcode >> 22 & 0x1 | opcode >> 11 & 0x1e); break;
	case M3N6B: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 3 & 0x7)); immediate = ARM::Immediate (opcode >> 6 & 0x1f) * 1; writeBack = false; break;
	case M3N6H: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 3 & 0x7)); immediate = ARM::Immediate (opcode >> 6 & 0x1f) * 2; writeBack = false; break;
	case M3N6W: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 3 & 0x7)); immediate = ARM::Immediate (opcode >> 6 & 0x1f) * 4; writeBack = false; break;
	case M16: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); immediate = 0; writeBack = false; break;
	case M168B: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); immediate = ARM::Immediate (opcode >> 0 & 0xff) * 1; writeBack = false; break;
	case M168N: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); immediate = ARM::Immediate (opcode >> 0 & 0xff) * -1; writeBack = false; break;
	case M168W: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); immediate = ARM::Immediate (opcode >> 0 & 0xff) * 4; writeBack = false; break;
	case M169: case M1694: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); immediate = ARM::Immediate (opcode >> 0 & 0xff) * 4; if (!(opcode >> 23 & 1)) immediate = -immediate; writeBack = (type == M1694); break;
	case M1692: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); immediate = ARM::Immediate (opcode >> 0 & 0xff) * 2; if (!(opcode >> 23 & 1)) immediate = -immediate; writeBack = false; break;
	case M169W: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); immediate = ARM::Immediate (opcode >> 0 & 0xff); if (!(opcode >> 9 & 1)) immediate = -immediate; writeBack = true; break;
	case M1612: model = Memory; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); immediate = ARM::Immediate (opcode >> 0 & 0xfff); writeBack = false; break;
	case MPC9: model = Memory; register_ = ARM::PC; immediate = ARM::Immediate (opcode >> 0 & 0xff) * 4; if (!(opcode >> 23 & 1)) immediate = -immediate; writeBack = false; break;
	case MSP8: model = Memory; register_ = ARM::SP; immediate = ARM::Immediate (opcode >> 0 & 0xff) * 4; writeBack = false; break;
	case MI36N: model = MemoryIndex; register_ = ARM::Register (ARM::R0 + (opcode >> 3 & 0x7)); index = ARM::Register (ARM::R0 + (opcode >> 6 & 0x7)); shift = 0; break;
	case MI160: model = MemoryIndex; register_ = ARM::Register (ARM::R0 + (opcode >> 16 & 0xf)); index = ARM::Register (ARM::R0 + (opcode >> 0 & 0xf)); shift = ARM::Immediate (opcode >> 4 & 0x3); break;
	case S611: model = ShiftMode; mode = ARM::ShiftMode (ARM::LSL + (opcode >> 11 & 0x3)); shift = (ARM::Immediate (opcode >> 6 & 0x1f) + 31) % 32 + 1; break;
	case S612: model = ShiftMode; mode = ARM::ShiftMode (ARM::LSL + (opcode >> 4 & 0x3)); shift = (ARM::Immediate (opcode >> 6 & 0x3 | opcode >> 10 & 0x1c) + 31) % 32 + 1; break;
	case SLSL6: model = ShiftMode; mode = ARM::LSL; shift = ARM::Immediate (opcode >> 6 & 0x3 | opcode >> 10 & 0x1c); break;
	case SASR6: model = ShiftMode; mode = ARM::ASR; shift = (ARM::Immediate (opcode >> 6 & 0x3 | opcode >> 10 & 0x1c) + 31) % 32 + 1; break;
	case SROR4: model = ShiftMode; mode = ARM::ROR; shift = ARM::Immediate (opcode >> 4 & 0x3) * 8; break;
	case SRRX: model = ShiftMode; mode = ARM::RRX; shift = 0; break;
	case CC: model = ConditionCode; code = ARM::GetConditionCode (opcode >> 4 & 0xf); break;
	case IM0: model = InterruptMask; mask = ARM::InterruptMask (opcode >> 0 & 0xf); break;
	case IM5: model = InterruptMask; mask = ARM::InterruptMask (opcode >> 5 & 0xf); break;
	case BO0: case BO0SY: model = BarrierOperation; operation = ARM::GetBarrierOperation (opcode >> 0 & 0xf); break;
	case P81: model = Coprocessor; coprocessor = ARM::Coprocessor (ARM::P14 + (opcode >> 8 & 0x1)); break;
	case P14: model = Coprocessor; coprocessor = ARM::P14; break;
	case C0: model = CoprocessorRegister; coregister = ARM::CoprocessorRegister (ARM::C0 + (opcode >> 0 & 0xf)); break;
	case C16: model = CoprocessorRegister; coregister = ARM::CoprocessorRegister (ARM::C0 + (opcode >> 16 & 0xf)); break;
	case C5: model = CoprocessorRegister; coregister = ARM::C5; break;
	default: model = Empty;
	}

	return IsCompatibleWith (type);
}

Opcode T32::Operand::Encode (const Type type) const
{
	switch (type)
	{
	case I04: return Opcode (immediate & 0xf) << 0;
	case I04D: return Opcode (immediate - 1 & 0xf) << 0;
	case I05: return Opcode (immediate & 0x1f) << 0;
	case I05W: case I05D: return Opcode (immediate - 1 & 0x1f) << 0;
	case I05P: return Opcode (immediate + this[-1].immediate - 1 & 0x1f) << 0;
	case I06: return Opcode (immediate & 0x3f) << 0;
	case I07T4: return Opcode (immediate / 4 & 0x7f) << 0;
	case I08: return Opcode (immediate & 0xff) << 0;
	case I08T4: return Opcode (immediate / 4 & 0xff) << 0;
	case I012: return Opcode (immediate & 0xff) << 0 | Opcode (immediate & 0x700) << 4 | Opcode (immediate & 0x800) << 15;
	case I012N: return Opcode (-immediate & 0xff) << 0 | Opcode (-immediate & 0x700) << 4 | Opcode (-immediate & 0x800) << 15;
	case I31: return Opcode (immediate & 0x1) << 3;
	case I36T2: return Opcode (immediate / 2 & 0x1f) << 3 | Opcode (immediate / 2 & 0x20) << 4;
	case I0162: return Opcode (immediate & 0xfff) << 0 | Opcode (immediate & 0xf000) << 4;
	case I0164: return Opcode (immediate & 0xff) << 0 | Opcode (immediate & 0x700) << 4 | Opcode (immediate & 0x800) << 15 | Opcode (immediate & 0xf000) << 4;
	case I44: return Opcode (immediate & 0xf) << 4;
	case I53: return Opcode (immediate & 0x7) << 5;
	case I63: return Opcode (immediate & 0x7) << 6;
	case I65O: case I65M: return Opcode (immediate & 0x1f) << 6;
	case I612: case I612O: case I612M: return Opcode (immediate & 0x3) << 6 | Opcode (immediate & 0x1c) << 10;
	case I164: return Opcode (immediate & 0xf) << 16;
	case I213: return Opcode (immediate & 0x7) << 21;
	case IC: return Encode (immediate);
	case O08: return Opcode (immediate / 2 & 0xff) << 0;
	case O099: return Opcode ((immediate < 0 ? -immediate : immediate) & 0xff) << 0 | Opcode (immediate >= 0) << 9;
	case O0992: return Opcode ((immediate < 0 ? -immediate : immediate) / 2 & 0xff) << 0 | Opcode (immediate >= 0) << 23;
	case O0923: return Opcode ((immediate < 0 ? -immediate : immediate) / 4 & 0xff) << 0 | Opcode (immediate >= 0) << 23;
	case O011: return Opcode (immediate / 2 & 0x7ff) << 0;
	case O012: return Opcode ((immediate < 0 ? -immediate : immediate) & 0xfff) << 0 | Opcode (immediate >= 0) << 23;
	case O020: return Opcode (immediate / 2 & 0x7ff) << 0 | Opcode (immediate / 2 & 0x1f800) << 5 | Opcode (immediate / 2 & 0x20000) >> 4 | Opcode (immediate / 2 & 0x40000) >> 7 | Opcode (immediate / 2 & 0x80000) << 7;
	case O024: case O024H: {const auto s = Opcode (immediate / 2 & 0x800000) >> 23; return Opcode (immediate / 2 & 0x7ff) << 0 | Opcode (immediate / 2 & 0x1ff800) << 5 | (Opcode (immediate / 2 & 0x200000) >> 21 ^ ~s & 0x1) << 11 | (Opcode (immediate / 2 & 0x400000) >> 22 ^ ~s & 0x1) << 13 | s << 26;}
	case R0: case R0N: return Opcode (register_ - ARM::R0) << 0;
	case R03N: return Opcode (register_ - ARM::R0) << 0 | Opcode (register_ - ARM::R0) << 3;
	case R3: case R3N: case LSL3: case LSR3: case ASR3: case ROR3: return Opcode (register_ - ARM::R0) << 3;
	case R07: return (Opcode (register_ - ARM::R0) & 0x7) << 0 | (Opcode (register_ - ARM::R0) & 0x8) << 4;
	case R08: return Opcode (register_ - ARM::R0) << 0 | Opcode (register_ - ARM::R0) << 8;
	case R016: return Opcode (register_ - ARM::R0) << 0 | Opcode (register_ - ARM::R0) << 16;
	case R6N: return Opcode (register_ - ARM::R0) << 6;
	case R8: case R8N: case R8WN: case R8NW: return Opcode (register_ - ARM::R0) << 8;
	case R816: return Opcode (register_ - ARM::R0) << 8 | Opcode (register_ - ARM::R0) << 16;
	case R12: return Opcode (register_ - ARM::R0) << 12;
	case R16: case M16: return Opcode (register_ - ARM::R0) << 16;
	case R16W: return Opcode (register_ - ARM::R0) << 16 | Opcode (writeBack) << 21;
	case RSPW: return Opcode (writeBack) << 21;
	case D0: return (Opcode (register_ - ARM::D0) & 0xf) << 0 | (Opcode (register_ - ARM::D0) & 0x10) << 1;
	case D12: return (Opcode (register_ - ARM::D0) & 0xf) << 12 | (Opcode (register_ - ARM::D0) & 0x10) << 18;
	case D1216: return (Opcode (register_ - ARM::D0) & 0xf) << 12 | (Opcode (register_ - ARM::D0) & 0x10) << 18 | (Opcode (register_ - ARM::D0) & 0xf) << 16 | (Opcode (register_ - ARM::D0) & 0x10) << 3;
	case D16: return (Opcode (register_ - ARM::D0) & 0xf) << 16 | (Opcode (register_ - ARM::D0) & 0x10) << 3;
	case S0: return (Opcode (register_ - ARM::S0) & 0x1) << 5 | (Opcode (register_ - ARM::S0) & 0x1e) >> 1;
	case S12: return (Opcode (register_ - ARM::S0) & 0x1) << 22 | (Opcode (register_ - ARM::S0) & 0x1e) << 11;
	case S1216: return (Opcode (register_ - ARM::S0) & 0x1) << 22 | (Opcode (register_ - ARM::S0) & 0x1e) << 11 | (Opcode (register_ - ARM::S0) & 0x1) << 7 | (Opcode (register_ - ARM::S0) & 0x1e) << 15;
	case S16: return (Opcode (register_ - ARM::S0) & 0x1) << 7 | (Opcode (register_ - ARM::S0) & 0x1e) << 15;
	case Q0: return (Opcode (register_ - ARM::Q0) * 2 & 0xe) << 0 | (Opcode (register_ - ARM::Q0) * 2 & 0x10) << 1;
	case Q12: return (Opcode (register_ - ARM::Q0) * 2 & 0xe) << 12 | (Opcode (register_ - ARM::Q0) * 2 & 0x10) << 18;
	case Q1216: return (Opcode (register_ - ARM::Q0) * 2 & 0xe) << 12 | (Opcode (register_ - ARM::Q0) * 2 & 0x10) << 18 | (Opcode (register_ - ARM::Q0) * 2 & 0xe) << 16 | (Opcode (register_ - ARM::Q0) * 2 & 0x10) << 3;
	case Q16: return (Opcode (register_ - ARM::Q0) * 2 & 0xe) << 16 | (Opcode (register_ - ARM::Q0) * 2 & 0x10) << 3;
	case SR0: return Opcode (register_ - ARM::R0) << 0 | Opcode (mode - ARM::LSL) << 21;
	case RL08: return Opcode (registerSet & 0xff) << 0;
	case RL08P: return Opcode (registerSet & 0xff) << 0 | Opcode (registerSet & 0x8000) >> 7;
	case RL016: return Opcode (registerSet & 0xffff) << 0;
	case RL12: return Opcode (CountOnes (registerSet - 1)) << 12;
	case DRL: return Opcode (CountTrailingZeros (registerSet) & 0xf) << 12 | Opcode (CountTrailingZeros (registerSet) & 0x10) << 18 | Opcode (CountOnes (registerSet) * 2);
	case SRL: return Opcode (CountTrailingZeros (registerSet) & 0x1) << 22 | Opcode (CountTrailingZeros (registerSet) & 0x1e) << 11 | Opcode (CountOnes (registerSet) * 1);
	case M3N6B: return Opcode (register_ - ARM::R0) << 3 | Opcode (immediate / 1 & 0x1f) << 6;
	case M3N6H: return Opcode (register_ - ARM::R0) << 3 | Opcode (immediate / 2 & 0x1f) << 6;
	case M3N6W: return Opcode (register_ - ARM::R0) << 3 | Opcode (immediate / 4 & 0x1f) << 6;
	case M168B: return Opcode (register_ - ARM::R0) << 16 | Opcode (immediate / 1 & 0xff) << 0;
	case M168N: return Opcode (register_ - ARM::R0) << 16 | Opcode (immediate / -1 & 0xff) << 0;
	case M168W: return Opcode (register_ - ARM::R0) << 16 | Opcode (immediate / 4 & 0xff) << 0;
	case M169: case M1694: return Opcode (register_ - ARM::R0) << 16 | Opcode ((immediate < 0 ? -immediate : immediate) / 4 & 0xff) << 0 | Opcode (immediate >= 0) << 23;
	case M1692: return Opcode (register_ - ARM::R0) << 16 | Opcode ((immediate < 0 ? -immediate : immediate) / 2 & 0xff) << 0 | Opcode (immediate >= 0) << 23;
	case M169W: return Opcode (register_ - ARM::R0) << 16 | Opcode ((immediate < 0 ? -immediate : immediate) & 0xff) << 0 | Opcode (immediate >= 0) << 9;
	case M1612: return Opcode (register_ - ARM::R0) << 16 | Opcode (immediate & 0xfff) << 0;
	case MPC9: return Opcode ((immediate < 0 ? -immediate : immediate) / 4 & 0xff) << 0 | Opcode (immediate >= 0) << 23;
	case MSP8: return Opcode (immediate / 4 & 0xff) << 0;
	case MI36N: return Opcode (register_ - ARM::R0) << 3 | Opcode (index - ARM::R0) << 6;
	case MI160: return Opcode (register_ - ARM::R0) << 16 | Opcode (index - ARM::R0) << 0 | Opcode (shift & 0x3) << 4;
	case S611: return Opcode (mode - ARM::LSL) << 11 | Opcode (shift & 0x1f) << 6;
	case S612: return Opcode (mode - ARM::LSL) << 4 | Opcode (shift & 0x3) << 6 | Opcode (shift & 0x1c) << 10;
	case SLSL6: case SASR6: return Opcode (shift & 0x3) << 6 | Opcode (shift & 0x1c) << 10;
	case SROR4: return Opcode (shift / 8 & 0x3) << 4;
	case CC: return Opcode (GetValue (code)) << 4;
	case IM0: return Opcode (mask & 0x7) << 0;
	case IM5: return Opcode (mask & 0x7) << 5;
	case BO0: case BO0SY: return Opcode (GetValue (operation)) << 0;
	case P81: return Opcode (coprocessor - ARM::C14 & 1) << 8;
	case C0: return Opcode (coregister - ARM::C0) << 0;
	case C16: return Opcode (coregister - ARM::C0) << 16;
	default: return 0;
	}
}

bool T32::Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case I04: case I44: case I164: return model == Immediate && immediate >= 0 && immediate <= 15;
	case I04D: return model == Immediate && immediate >= 1 && immediate <= 16;
	case I05: case I612: return model == Immediate && immediate >= 0 && immediate <= 31;
	case I05D: case I65M: case I612M: return model == Immediate && immediate >= 1 && immediate <= 32;
	case I05P: case I05W: return model == Immediate && this[-1].model == Immediate && immediate >= 1 && immediate <= 32 - this[-1].immediate;
	case I06: return model == Immediate && immediate >= 0 && immediate <= 63;
	case I07T4: return model == Immediate && immediate >= 0 && immediate <= 508 && immediate % 4 == 0;
	case I08: return model == Immediate && immediate >= 0 && immediate <= 255;
	case I08T4: return model == Immediate && immediate >= 0 && immediate <= 1020 && immediate % 4 == 0;
	case I012: return model == Immediate && immediate >= 0 && immediate <= 4095;
	case I012N: return model == Immediate && immediate >= -4095 && immediate <= -1;
	case I0162: case I0164: return model == Immediate && immediate >= 0 && immediate <= 65535;
	case I31: return model == Immediate && immediate >= 0 && immediate <= 1;
	case I36T2: return model == Immediate && immediate >= 0 && immediate <= 126 && immediate % 2 == 0;
	case I53: case I63: case I213: return model == Immediate && immediate >= 0 && immediate <= 7;
	case I65O: case I612O: return model == Immediate && immediate >= 1 && immediate <= 31;
	case IC: return model == Immediate && IsValid (immediate);
	case I0: return model == Immediate && immediate == 0;
	case O08: return model == Immediate && immediate >= -256 && immediate <= +254 && immediate % 2 == 0;
	case O099: return model == Immediate && immediate >= -255 && immediate <= +255;
	case O0992: return model == Immediate && immediate >= -510 && immediate <= +510 && immediate % 2 == 0;
	case O0923: return model == Immediate && immediate >= -1020 && immediate <= +1020 && immediate % 4 == 0;
	case O011: return model == Immediate && immediate >= -2048 && immediate <= +2046 && immediate % 2 == 0;
	case O012: return model == Immediate && immediate >= -4095 && immediate <= +4095;
	case O020: return model == Immediate && immediate >= -1048576 && immediate <= +1048574 && immediate % 2 == 0;
	case O024: return model == Immediate && immediate >= -16777216 && immediate <= +16777214 && immediate % 2 == 0;
	case O024H: return model == Immediate && immediate >= -16777216 && immediate <= +16777212 && immediate % 4 == 0;
	case R0: case R07: case R08: case R016: case R3: case R8: case R816: case R12: case R16: return model == Register && register_ >= ARM::R0 && register_ <= ARM::R15 && !writeBack;
	case R0N: case R03N: case R3N: case R6N: case R8N: return model == Register && register_ >= ARM::R0 && register_ <= ARM::R7 && !writeBack;
	case R8WN: return model == Register && register_ >= ARM::R0 && register_ <= ARM::R7 && writeBack;
	case R8NW: return model == Register && register_ >= ARM::R0 && register_ <= ARM::R7 && writeBack != (this[1].model == RegisterList && this[1].registerSet & 1 << register_);
	case R16W: return model == Register && register_ >= ARM::R0 && register_ <= ARM::R15;
	case RSP: return model == Register && register_ == ARM::SP && !writeBack;
	case RSPW: return model == Register && register_ == ARM::SP;
	case RLR: return model == Register && register_ == ARM::LR && !writeBack;
	case RPC: return model == Register && register_ == ARM::PC && !writeBack;
	case D0: case D12: case D1216: case D16: return model == Register && register_ >= ARM::D0 && register_ <= ARM::D31 && !writeBack;
	case S0: case S12: case S1216: case S16: return model == Register && register_ >= ARM::S0 && register_ <= ARM::S31 && !writeBack;
	case Q0: case Q12: case Q1216: case Q16: return model == Register && register_ >= ARM::Q0 && register_ <= ARM::Q15 && !writeBack;
	case SR0: return model == ShiftedRegister && register_ >= ARM::R0 && register_ <= ARM::R15 && mode >= ARM::LSL && mode <= ARM::ROR;
	case LSL3: case LSR3: case ASR3: case ROR3: return model == ShiftedRegister && register_ >= ARM::R0 && register_ <= ARM::R7 && mode == ARM::ShiftMode (type - LSL3);
	case RL08: return model == RegisterList && (registerSet & 0xff) == registerSet;
	case RL08P: return model == RegisterList && (registerSet & 0x80ff) == registerSet;
	case RL016: return model == RegisterList && (registerSet & 0xffff) == registerSet;
	case RL12: return model == RegisterList && (registerSet & 0xffff) == registerSet && IsPowerOfTwo (registerSet);
	case DRL: return model == DoubleRegisterList && IsPowerOfTwo ((registerSet >> CountTrailingZeros (registerSet)) + 1) && CountOnes (registerSet) <= 16;
	case SRL: return model == SingleRegisterList && IsPowerOfTwo ((registerSet >> CountTrailingZeros (registerSet)) + 1);
	case M3N6B: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R7 && immediate >= 0 && immediate <= 31 && immediate % 1 == 0 && !writeBack;
	case M3N6H: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R7 && immediate >= 0 && immediate <= 62 && immediate % 2 == 0 && !writeBack;
	case M3N6W: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R7 && immediate >= 0 && immediate <= 124 && immediate % 4 == 0 && !writeBack;
	case M16: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R15 && !immediate && !writeBack;
	case M168B: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R15 && immediate >= 0 && immediate <= 255 && !writeBack;
	case M168N: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R15 && immediate >= -255 && immediate <= 0 && !writeBack;
	case M168W: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R15 && immediate >= 0 && immediate <= 1020 && immediate % 4 == 0 && !writeBack;
	case M169: case M1694: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R15 && immediate >= -1020 && immediate <= +1020 && immediate % 4 == 0 && writeBack == (type == M1694);
	case M1692: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R15 && immediate >= -510 && immediate <= +510 && immediate % 2 == 0 && !writeBack;
	case M169W: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R15 && immediate >= -255 && immediate <= +255 && writeBack;
	case M1612: return model == Memory && register_ >= ARM::R0 && register_ <= ARM::R15 && immediate >= 0 && immediate <= 4095 && !writeBack;
	case MPC9: return model == Memory && register_ == ARM::PC && immediate >= -1020 && immediate <= +1020 && immediate % 4 == 0 && !writeBack;
	case MSP8: return model == Memory && register_ == ARM::SP && immediate >= 0 && immediate <= 1020 && immediate % 4 == 0 && !writeBack;
	case MI36N: return model == MemoryIndex && register_ >= ARM::R0 && register_ <= ARM::R7 && index >= ARM::R0 && index <= ARM::R7 && !shift;
	case MI160: return model == MemoryIndex && register_ >= ARM::R0 && register_ <= ARM::R15 && index >= ARM::R0 && index <= ARM::R15 && shift >= 0 && shift <= 3;
	case S611: return model == ShiftMode && mode >= ARM::LSL && mode <= ARM::ASR && shift >= 1 && shift <= 31 + (mode == ARM::LSR || mode == ARM::ASR);
	case S612: return model == ShiftMode && mode >= ARM::LSL && mode <= ARM::ROR && shift >= 1 && shift <= 31 + (mode == ARM::LSR || mode == ARM::ASR);
	case SLSL6: return model == ShiftMode && mode == ARM::LSL && shift >= 1 && shift <= 31;
	case SASR6: return model == ShiftMode && mode == ARM::ASR && shift >= 1 && shift <= 32;
	case SROR4: return model == ShiftMode && mode == ARM::ROR && shift >= 0 && shift <= 24 && shift % 8 == 0;
	case SRRX: return model == ShiftMode && mode == ARM::RRX && shift == 0;
	case CC: return model == ConditionCode;
	case IM0: case IM5: return model == InterruptMask;
	case BO0: return model == BarrierOperation;
	case BO0SY: return model == BarrierOperation && operation == ARM::SY;
	case P81: return model == Coprocessor && coprocessor >= ARM::P14 && coprocessor <= ARM::P15;
	case P14: return model == Coprocessor && coprocessor == ARM::P14;
	case C0: case C16: return model == CoprocessorRegister && coregister >= ARM::C0 && coregister <= ARM::C15;
	case C5: return model == CoprocessorRegister && coregister == ARM::C5;
	default: return model == Empty;
	}
}

Immediate T32::Operand::Decode (const Opcode opcode)
{
	const auto code = opcode >> 23 & 0x8 | opcode >> 12 & 0x7, mask = opcode & 0xff;
	if (code == 0) return mask;
	if (code == 1) return mask << 16 | mask;
	if (code == 2) return mask << 24 | mask << 8;
	if (code == 3) return mask << 24 | mask << 16 | mask << 8 | mask;
	return (mask | 0x80) << 32 - (code << 1) - (mask >> 7);
}

Opcode T32::Operand::Encode (const ARM::Immediate immediate)
{
	Opcode mask = immediate;
	if ((mask & 0xff) == mask) return mask;
	if ((mask & 0xff00ff) == mask && mask >> 16 == (mask & 0xff)) return 0x1000 | mask & 0xff;
	if ((mask & 0xff00ff00) == mask && mask >> 16 == (mask & 0xff00)) return 0x2000 | mask >> 8 & 0xff;
	if ((mask >> 8 & 0xff) == (mask & 0xff) && mask >> 16 == (mask & 0xffff)) return 0x3000 | mask & 0xff;
	Opcode code = 31; while ((mask & 0x1fe) != mask) if (mask & 1 || (mask >>= 1) == 0 || --code == 7) return 0x100;
	return (code & 0x10) << 22 | (code & 0xe) << 11 | (code & 1) << 7 | (mask & 0xfe) >> 1;
}

T32::Instruction::Instruction (const ConditionCode c) :
	code {c}
{
}

T32::Instruction::Instruction (const Span<const Byte> bytes, const ConditionCode code)
{
	if (bytes.size () < 2) return; const auto wide = bytes[1] >> 3 >= 29; if (wide && bytes.size () < 4) return;
	const auto opcode = wide ? Opcode (bytes[0]) << 16 | Opcode (bytes[1]) << 24 | Opcode (bytes[2]) | Opcode (bytes[3]) << 8 : Opcode (bytes[0]) | Opcode (bytes[1]) << 8;
	for (auto& entry: table) if ((opcode & entry.mask) == entry.opcode && entry.mask >> 31 == wide)
		for (auto& operand: operands) if (!operand.Decode (opcode, entry.types[GetIndex (operand, operands)])) break;
			else if (!IsLast (operand, operands)) continue;
			else if (code && entry.flags & O || entry.flags & R && !code && entry.mnemonic != B) break;
			else if (entry.Decode (opcode, No) == AL || entry.Decode (opcode, No) == NV) break;
			else if (entry.types[0] == Operand::R8NW && !operands[0].Decode (opcode, Operand::R8NW)) break;
			else {this->entry = &entry; this->code = entry.Decode (opcode, code); return;}
}

T32::Instruction::Instruction (const Mnemonic mnemonic, const Operand& o0, const Operand& o1, const Operand& o2, const Operand& o3, const Operand& o4, const Operand& o5) :
	Instruction {mnemonic, No, Default, None, No, o0, o1, o2, o3, o4, o5}
{
}

T32::Instruction::Instruction (const Mnemonic mnemonic, const ConditionCode code, const Qualifier qualifier, const Suffix suffix, const ConditionCode previous, const Operand& o0, const Operand& o1, const Operand& o2, const Operand& o3, const Operand& o4, const Operand& o5) :
	operands {o0, o1, o2, o3, o4, o5}
{
	for (auto& entry: Span<const Entry> {first[mnemonic], last[mnemonic]})
		for (auto& operand: operands) if (!operand.IsCompatibleWith (entry.types[GetIndex (operand, operands)])) break;
			else if (!IsLast (operand, operands)) continue;
			else if (code && !(entry.flags & (C | R)) || entry.flags & R && !code) break;
			else if (qualifier && (!(entry.flags & (Q | W)) || qualifier != (entry.mask >> 16 ? Wide : Narrow))) break;
			else if (suffix != Suffix (entry.flags & S)) break;
			else if (entry.flags & W && qualifier != Wide) break;
			else if (entry.flags & I && (!previous || code != previous) || previous && entry.flags & O) break;
			else if (entry.types[0] == entry.types[1] && operands[0].Encode (entry.types[0]) != operands[1].Encode (entry.types[1])) break;
			else if (entry.types[0] == entry.types[2] && operands[0].Encode (entry.types[0]) != operands[2].Encode (entry.types[2])) break;
			else {this->entry = &entry; this->code = code; return;}
}

void T32::Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); assert (bytes.size () >= 2); auto opcode = entry->opcode | entry->Encode (code);
	for (auto& operand: operands) opcode |= operand.Encode (entry->types[GetIndex (operand, operands)]);
	if (entry->mask >> 16) bytes[0] = opcode >> 16, bytes[1] = opcode >> 24, bytes[2] = opcode, bytes[3] = opcode >> 8; else bytes[0] = opcode, bytes[1] = opcode >> 8;
}

void T32::Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	if (patch.mode == Object::Patch::Absolute && entry->types[0] == Operand::O024) patch.displacement -= 4, patch.scale = 1, patch.mode = Object::Patch::Relative;
	if (entry->types[0] == Operand::O024) patch.pattern = {{2, 0xff}, {3, 0x7}, {0, 0xff}, {1, 0x3}, {1, 0x4}};
	if (entry->types[1] == Operand::I0164) patch.pattern = {{2, 0xff}, {3, 0x70}, {1, 0x04}, {0, 0x0f}};
}

ConditionCode T32::Instruction::Entry::Decode (const Opcode opcode, const ConditionCode code) const
{
	return mnemonic == B && flags == (R | O | Q) ? ARM::GetConditionCode (opcode >> (mask >> 16 ? 22 : 8) & 0xf) : code;
}

Opcode T32::Instruction::Entry::Encode (const ConditionCode code) const
{
	return mnemonic == B && flags == (R | O | Q) ? GetValue (code) << (mask >> 16 ? 22 : 8) : 0;
}

bool T32::IsValid (const Immediate immediate)
{
	return !(Operand::Encode (immediate) & 0x100);
}

std::size_t T32::GetSize (const Instruction& instruction)
{
	assert (instruction.entry);
	return instruction.entry->mask >> 16 ? 4 : 2;
}

ConditionCode T32::GetConditionCode (const Instruction& instruction)
{
	assert (instruction.entry);
	return instruction.entry->mnemonic == Instruction::IT ? instruction.operands[0].code : No;
}

std::istream& T32::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic; ConditionCode code; Qualifier qualifier; Suffix suffix; std::array<Operand, 6> operands;
	if (Instruction::Read (stream, mnemonic, code, qualifier, suffix)) if (stream.good () && stream >> std::ws && stream.good ())
		for (auto& operand: operands) if (stream >> operand && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ()) continue; else break;
	if (stream) instruction = {mnemonic, code, qualifier, suffix, instruction.code, operands[0], operands[1], operands[2], operands[3], operands[4], operands[5]};
	return stream;
}

std::ostream& T32::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry); Instruction::Write (stream, instruction.entry->mnemonic, instruction.code, instruction.entry->flags & Instruction::W ? Wide : Default, Suffix (instruction.entry->flags & Instruction::S));
	for (auto& operand: instruction.operands) if (IsEmpty (operand)) break; else (IsFirst (operand, instruction.operands) ? stream << '\t' : stream << ", ") << operand;
	return stream;
}

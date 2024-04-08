// ARM A64 instruction set representation
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

#include "arma64.hpp"
#include "object.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace ARM;
using namespace A64;

struct A64::Instruction::Entry
{
	Mnemonic mnemonic;
	Opcode opcode, mask;
	Operand::Type types[5];
};

const Opcode A64::Operand::codes[] {
	#define SYMBOL(name, symbol, code, group) code,
	#include "arma64.def"
};

const Opcode A64::Operand::masks[] {
	#define GROUP(group, mask) mask,
	#include "arma64.def"
};

const A64::Operand::Type A64::Operand::groups[] {
	#define SYMBOL(name, symbol, code, group) group,
	#include "arma64.def"
};

const char*const A64::Operand::symbols[] {
	#define SYMBOL(name, symbol, code, group) #name,
	#include "arma64.def"
};

const char*const A64::Operand::widths[] {"b", "h", "s", "d"};
const char*const A64::Operand::registers[] {"wsp", "sp", "wzr", "xzr"};
const char*const A64::Operand::formats[] {"2h", "8b", "4h", "2s", "1d", "16b", "8h", "4s", "2d", "1q"};
const char*const A64::Operand::extensions[] {"uxtb", "uxth", "uxtw", "uxtx", "sxtb", "sxth", "sxtw", "sxtx"};

constexpr A64::Instruction::Entry A64::Instruction::table[] {
	#define INSTR(mnem, code, mask, type0, type1, type2, type3, type4) \
		{Instruction::mnem, code, mask, {Operand::type0, Operand::type1, Operand::type2, Operand::type3, Operand::type4}},
	#include "arma64.def"
};

const char*const A64::Instruction::mnemonics[] {
	#define MNEM(name, mnem, ...) #name,
	#include "arma64.def"
};

constexpr Lookup<A64::Instruction::Entry, A64::Instruction::Mnemonic> A64::Instruction::first {table}, A64::Instruction::last {table, 0};

A64::Operand::Operand (const A64::Immediate i) :
	model {Immediate}, immediate {i}
{
}

A64::Operand::Operand (const ARM::FloatImmediate fi) :
	model {FloatImmediate}, floatImmediate {fi}
{
}

A64::Operand::Operand (const A64::Register r) :
	model {Register}, register_ {r}
{
}

A64::Operand::Operand (const A64::Register r, const Format f) :
	model {Vector}, register_ {r}, format {f}
{
	assert (register_ >= V0 && register_ <= V31);
}

A64::Operand::Operand (const A64::Register r, const Format f, const Size s) :
	model {VectorSet}, register_ {r}, size {s}, format {f}
{
	assert (register_ >= V0 && register_ <= V31);
	assert (size >= 1 && size <= 4);
}

A64::Operand::Operand (const A64::Register r, const Width w, const A64::Immediate i) :
	model {Element}, register_ {r}, immediate {i}, width {w}
{
	assert (register_ >= V0 && register_ <= V31);
}

A64::Operand::Operand (const A64::Register r, const Width w, const Size s, const A64::Immediate i) :
	model {ElementSet}, register_ {r}, size {s}, immediate {i}, width {w}
{
	assert (register_ >= V0 && register_ <= V31);
	assert (size >= 1 && size <= 4);
}

A64::Operand::Operand (const A64::Register r, const A64::Immediate i, const Preindexed p) :
	model {Memory}, register_ {r}, immediate {i}, preindexed {p}
{
}

A64::Operand::Operand (const A64::Register r, const A64::Register in, const A64::Immediate im) :
	model {ShiftedIndex}, register_ {r}, index {in}, immediate {im}
{
}

A64::Operand::Operand (const A64::Register r, const A64::Register in, const A64::Extension e, const A64::Immediate im) :
	model {ExtendedIndex}, register_ {r}, index {in}, immediate {im}, extension {e}
{
}

A64::Operand::Operand (const ARM::ShiftMode sm, const A64::Immediate i) :
	model {Shift}, immediate {i}, shiftmode {sm}
{
}

A64::Operand::Operand (const A64::Extension e, const A64::Immediate i) :
	model {Extension}, immediate {i}, extension {e}
{
}

A64::Operand::Operand (const ARM::ConditionCode c) :
	model {ConditionCode}, code {c}
{
}

A64::Operand::Operand (const ARM::CoprocessorRegister cr) :
	model {CoprocessorRegister}, coregister {cr}
{
}

A64::Operand::Operand (const A64::Symbol s) :
	model {Symbol}, symbol {s}
{
}

bool A64::Operand::Decode (const Opcode opcode, const Type type)
{
	if (type < Groups) return model = Symbol, Decode (opcode, type, symbol);

	switch (type)
	{
	case I0: model = Immediate; immediate = 0; break;
	case I1: case I2: case I4: case I8: case I16: case I32: case I64: model = Immediate; immediate = 1 << (type - I1); break;
	case I3: case I6: case I12: case I24: case I48: model = Immediate; immediate = 3 << (type - I3); break;
	case U4: model = Immediate; immediate = A64::Immediate (opcode >> 8 & 0xf); break;
	case U5: case U6: model = Immediate; immediate = A64::Immediate (opcode >> 16 & 0x3f); break;
	case U5ND: if ((opcode >> 16 & 0x1f) != (opcode >> 10 & 0x1f) + 1) return false;
	case U5N: model = Immediate; immediate = -A64::Immediate (opcode >> 16) & 0x1f; break;
	case U5P: model = Immediate; immediate = A64::Immediate (opcode & 0x1f); break;
	case U5S: case U6S: model = Immediate; immediate = A64::Immediate (opcode >> 10 & 0x3f); break;
	case U5SD: case U6SD: model = Immediate; immediate = A64::Immediate (opcode >> 10 & 0x3f) + 1; break;
	case U5SS: case U6SS: model = Immediate; immediate = A64::Immediate (opcode >> 10 & 0x3f) - this[-1].immediate + 1; break;
	case U6ND: if ((opcode >> 16 & 0x3f) != (opcode >> 10 & 0x3f) + 1) return false;
	case U6N: model = Immediate; immediate = -A64::Immediate (opcode >> 16) & 0x3f; break;
	case U7H: model = Immediate; immediate = A64::Immediate (opcode >> 5 & 0x3f); break;
	case U8: model = Immediate; immediate = A64::Immediate (opcode >> 5 & 0x1f) | A64::Immediate (opcode >> 16 & 0x7) << 5; break;
	case U12: model = Immediate; immediate = A64::Immediate (opcode >> 10 & 0xfff); break;
	case U16: model = Immediate; immediate = A64::Immediate (opcode >> 5 & 0xffff); break;
	case U16I: model = Immediate; immediate = ~A64::Immediate (opcode >> 5 & 0xffff); break;
	case UDB: case UQB: model = Immediate; immediate = A64::Immediate (opcode >> 11 & 0xf); break;
	case S7W: model = Immediate; immediate = A64::Immediate (opcode >> 15) << 57 >> 55; break;
	case S7X: model = Immediate; immediate = A64::Immediate (opcode >> 15) << 57 >> 54; break;
	case S7Q: model = Immediate; immediate = A64::Immediate (opcode >> 15) << 57 >> 53; break;
	case S9: model = Immediate; immediate = A64::Immediate (opcode) << 43 >> 55; break;
	case S21: model = Immediate; immediate = A64::Immediate (opcode >> 29 & 0x3) | A64::Immediate (opcode >> 5) << 45 >> 43; break;
	case S21P: model = Immediate; immediate = A64::Immediate (opcode >> 29 & 0x3) << 12 | A64::Immediate (opcode >> 5) << 45 >> 31; break;
	case O14: model = Immediate; immediate = A64::Immediate (opcode >> 5) << 50 >> 48; break;
	case O19: model = Immediate; immediate = A64::Immediate (opcode >> 5) << 45 >> 43; break;
	case O26: model = Immediate; immediate = A64::Immediate (opcode) << 38 >> 36; break;
	case BW: model = Immediate; immediate = A64::Immediate (opcode >> 19 & 0x1f); break;
	case BX: model = Immediate; immediate = A64::Immediate (opcode >> 19 & 0x1f) | A64::Immediate (opcode >> 31 & 0x1) << 5; break;
	case FBW: case FBX: model = Immediate; immediate = 64 - A64::Immediate (opcode >> 10 & 0x3f); break;
	case FBB: case FBH: case FBS: case FBD: model = Immediate; immediate = (1 << type - FBB + 3) - A64::Immediate (opcode >> 16 & (1 << type - FBB + 3) - 1); break;
	case FDB: case FDH: case FDS: case FDD: model = Immediate; immediate = A64::Immediate (opcode >> 16 & (1 << type - FDB + 3) - 1); break;
	case IW: model = Immediate; immediate = Decode (opcode >> 10 & 0xfff, 32); break;
	case IX: model = Immediate; immediate = Decode (opcode >> 10 & 0x1fff, 64); break;
	case NZCV: model = Immediate; immediate = A64::Immediate (opcode & 0xf); break;
	case OP1: model = Immediate; immediate = A64::Immediate (opcode >> 16 & 0x7); break;
	case OP2: model = Immediate; immediate = A64::Immediate (opcode >> 5 & 0x7); break;
	case R11: model = Immediate; immediate = A64::Immediate (opcode >> 11 & 0x3) * 90; break;
	case R12: model = Immediate; immediate = A64::Immediate (opcode >> 12 & 0x1 ? 270 : 90); break;
	case R13: model = Immediate; immediate = A64::Immediate (opcode >> 13 & 0x3) * 90; break;
	case FZ: model = FloatImmediate; floatImmediate = 0; break;
	case F5: model = FloatImmediate; floatImmediate = Decode (opcode >> 5 & 0x1f | (opcode >> 16 & 0x7) << 5); break;
	case F13: model = FloatImmediate; floatImmediate = Decode (opcode >> 13 & 0xff); break;
	case Wa: case Wt2: model = Register; register_ = A64::Register (W0 + (opcode >> 10 & 0x1f)); break;
	case Wd: case Wt: model = Register; register_ = A64::Register (W0 + (opcode & 0x1f)); break;
	case WdSP: model = Register; register_ = A64::Register (W0 + (opcode & 0x1f)); if (register_ == WZR) register_ = WSP; break;
	case Wm: case Ws: model = Register; register_ = A64::Register (W0 + (opcode >> 16 & 0x1f)); break;
	case Wnm: case WnmZ: if ((opcode >> 5 & 0x1f) != (opcode >> 16 & 0x1f)) return false;
	case Wn: case WnNZ: model = Register; register_ = A64::Register (W0 + (opcode >> 5 & 0x1f)); break;
	case WnSP: model = Register; register_ = A64::Register (W0 + (opcode >> 5 & 0x1f)); if (register_ == WZR) register_ = WSP; break;
	case WsP: model = Register; register_ = A64::Register (W0 + (opcode >> 16 & 0x1f) + 1); break;
	case WtP: model = Register; register_ = A64::Register (W0 + (opcode & 0x1f) + 1); break;
	case Xa: case Xt2: model = Register; register_ = A64::Register (X0 + (opcode >> 10 & 0x1f)); break;
	case Xd: case Xt: model = Register; register_ = A64::Register (X0 + (opcode & 0x1f)); break;
	case XdSP: model = Register; register_ = A64::Register (X0 + (opcode & 0x1f)); if (register_ == XZR) register_ = SP; break;
	case Xm: case XmNZ: case Xs: model = Register; register_ = A64::Register (X0 + (opcode >> 16 & 0x1f)); break;
	case XmSP: model = Register; register_ = A64::Register (X0 + (opcode >> 16 & 0x1f)); if (register_ == XZR) register_ = SP; break;
	case Xnm: case XnmZ: if ((opcode >> 5 & 0x1f) != (opcode >> 16 & 0x1f)) return false;
	case Xn: case XnNZ: model = Register; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); break;
	case XnSP: model = Register; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; break;
	case XsP: model = Register; register_ = A64::Register (X0 + (opcode >> 16 & 0x1f) + 1); break;
	case XtP: model = Register; register_ = A64::Register (X0 + (opcode & 0x1f) + 1); break;
	case Bd: case Bt: model = Register; register_ = A64::Register (B0 + (opcode & 0x1f)); break;
	case Bm: model = Register; register_ = A64::Register (B0 + (opcode >> 16 & 0x1f)); break;
	case Bn: model = Register; register_ = A64::Register (B0 + (opcode >> 5 & 0x1f)); break;
	case Ha: model = Register; register_ = A64::Register (H0 + (opcode >> 10 & 0x1f)); break;
	case Hd: case Ht: model = Register; register_ = A64::Register (H0 + (opcode & 0x1f)); break;
	case Hm: model = Register; register_ = A64::Register (H0 + (opcode >> 16 & 0x1f)); break;
	case Hn: model = Register; register_ = A64::Register (H0 + (opcode >> 5 & 0x1f)); break;
	case Sa: case St2: model = Register; register_ = A64::Register (S0 + (opcode >> 10 & 0x1f)); break;
	case Sd: case St: model = Register; register_ = A64::Register (S0 + (opcode & 0x1f)); break;
	case Sm: model = Register; register_ = A64::Register (S0 + (opcode >> 16 & 0x1f)); break;
	case Sn: model = Register; register_ = A64::Register (S0 + (opcode >> 5 & 0x1f)); break;
	case Da: case Dt2: model = Register; register_ = A64::Register (D0 + (opcode >> 10 & 0x1f)); break;
	case Dd: case Dt: model = Register; register_ = A64::Register (D0 + (opcode & 0x1f)); break;
	case Dm: model = Register; register_ = A64::Register (D0 + (opcode >> 16 & 0x1f)); break;
	case Dn: model = Register; register_ = A64::Register (D0 + (opcode >> 5 & 0x1f)); break;
	case Qd: case Qt: model = Register; register_ = A64::Register (Q0 + (opcode & 0x1f)); break;
	case Qn: model = Register; register_ = A64::Register (Q0 + (opcode >> 5 & 0x1f)); break;
	case Qt2: model = Register; register_ = A64::Register (Q0 + (opcode >> 10 & 0x1f)); break;
	case V1DB: case V1DH: case V1DS: case V1DD: case V1QB: case V1QH: case V1QS: case V1QD:
	case V2DB: case V2DH: case V2DS: case V2DD: case V2QB: case V2QH: case V2QS: case V2QD:
	case V3DB: case V3DH: case V3DS: case V3DD: case V3QB: case V3QH: case V3QS: case V3QD:
	case V4DB: case V4DH: case V4DS: case V4DD: case V4QB: case V4QH: case V4QS: case V4QD: model = VectorSet; register_ = A64::Register (V0 + (opcode & 0x1f)); size = (type - V1DB) / 8u + 1u; format = Format (F8B + (type - V1DB) % 8u); break;
	case W1QB: case W2QB: case W3QB: case W4QB: model = VectorSet; register_ = A64::Register (V0 + (opcode >> 5 & 0x1f)); size = type - W1QB + 1u; format = F16B; break;
	case VaSH: case VaDB: case VaDH: case VaDS: case VaDD: case VaQB: case VaQH: case VaQS: case VaQD: case VaQQ: model = Vector; register_ = A64::Register (V0 + (opcode >> 10 & 0x1f)); format = Format (type - VaSH); break;
	case VdSH: case VdDB: case VdDH: case VdDS: case VdDD: case VdQB: case VdQH: case VdQS: case VdQD: case VdQQ: model = Vector; register_ = A64::Register (V0 + (opcode & 0x1f)); format = Format (type - VdSH); break;
	case VmSH: case VmDB: case VmDH: case VmDS: case VmDD: case VmQB: case VmQH: case VmQS: case VmQD: case VmQQ: model = Vector; register_ = A64::Register (V0 + (opcode >> 16 & 0x1f)); format = Format (type - VmSH); break;
	case VnSH: case VnDB: case VnDH: case VnDS: case VnDD: case VnQB: case VnQH: case VnQS: case VnQD: case VnQQ: model = Vector; register_ = A64::Register (V0 + (opcode >> 5 & 0x1f)); format = Format (type - VnSH); break;
	case VoSH: case VoDB: case VoDH: case VoDS: case VoDD: case VoQB: case VoQH: case VoQS: case VoQD: case VoQQ: if ((opcode >> 5 & 0x1f) != (opcode >> 16 & 0x1f)) return false; model = Vector; register_ = A64::Register (V0 + (opcode >> 5 & 0x1f)); format = Format (type - VoSH); break;
	case E1B: case E1H: case E1S: case E1D: case E2B: case E2H: case E2S: case E2D: case E3B: case E3H: case E3S: case E3D: case E4B: case E4H: case E4S: case E4D:
		model = ElementSet; register_ = A64::Register (V0 + (opcode & 0x1f)); size = (type - E1B) / 4u + 1u; width = Width ((type - E1B) % 4u); immediate = (A64::Immediate (opcode >> 10 & 0x7) | A64::Immediate (opcode >> 30 & 0x1) << 3) >> width; break;
	case EdB: case EdH: case EdS: case EdD: model = Element; register_ = A64::Register (V0 + (opcode & 0x1f)); width = Width (type - EdB); immediate = A64::Immediate (opcode >> 17 + width & 0xf >> width); break;
	case EdD0: model = Element; register_ = A64::Register (V0 + (opcode & 0x1f)); width = WD; immediate = 1; break;
	case EnD0: model = Element; register_ = A64::Register (V0 + (opcode >> 5 & 0x1f)); width = WD; immediate = 1; break;
	case EnS1: case EnD1: model = Element; register_ = A64::Register (V0 + (opcode >> 5 & 0x1f)); width = Width (WS + type - EnS1); immediate = A64::Immediate (opcode >> 19 + width - WS & 3 >> width - WS); break;
	case EnB4: case EnH4: case EnS4: case EnD4: model = Element; register_ = A64::Register (V0 + (opcode >> 5 & 0x1f)); width = Width (type - EnB4); immediate = A64::Immediate (opcode >> 11 + width & 0xf >> width); break;
	case EnB5: case EnH5: case EnS5: case EnD5: model = Element; register_ = A64::Register (V0 + (opcode >> 5 & 0x1f)); width = Width (type - EnB5); immediate = A64::Immediate (opcode >> 17 + width & 0xf >> width); break;
	case EmH1: model = Element; register_ = A64::Register (V0 + (opcode >> 16 & 0x1f)); width = WH; immediate = A64::Immediate (opcode >> 21 & 0x1); break;
	case EmS1: case EmD1: model = Element; register_ = A64::Register (V0 + (opcode >> 16 & 0x1f)); width = Width (WS + type - EmS1); immediate = A64::Immediate (opcode >> 11 & 0x1); break;
	case EmB2: case EmH2: case EmS2: model = Element; register_ = A64::Register (V0 + (opcode >> 16 & 0x1f)); width = Width (WB + type - EmB2); immediate = A64::Immediate (opcode >> 21 & 0x1) | A64::Immediate (opcode >> 11 & 0x1) << 1; break;
	case EmH3: model = Element; register_ = A64::Register (V0 + (opcode >> 16 & 0xf)); width = WH; immediate = A64::Immediate (opcode >> 20 & 0x3) | A64::Immediate (opcode >> 11 & 0x1) << 2; break;
	case EmSI: model = Element; register_ = A64::Register (V0 + (opcode >> 16 & 0x1f)); width = WS; immediate = A64::Immediate (opcode >> 12 & 0x3); break;
	case MZ: model = Memory; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; immediate = 0; preindexed = false; break;
	case M7W: case M7WP: model = Memory; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; immediate = A64::Immediate (opcode >> 15) << 57 >> 55; preindexed = type == M7WP; break;
	case M7X: case M7XP: model = Memory; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; immediate = A64::Immediate (opcode >> 15) << 57 >> 54; preindexed = type == M7XP; break;
	case M7Q: case M7QP: model = Memory; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; immediate = A64::Immediate (opcode >> 15) << 57 >> 53; preindexed = type == M7QP; break;
	case M9B: case M9BP: model = Memory; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; immediate = A64::Immediate (opcode) << 43 >> 55; preindexed = type == M9BP; break;
	case M9X: case M9XP: model = Memory; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; immediate = A64::Immediate (opcode >> 12 & 0x1ff) << 3 | A64::Immediate (opcode >> 22) << 63 >> 51; preindexed = type == M9XP; break;
	case M12B: case M12H: case M12W: case M12X: case M12Q: model = Memory; register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; immediate = A64::Immediate (opcode >> 10 & 0xfff) << type - M12B; preindexed = false; break;
	case ShW: case ShWR: case ShX: case ShXR: model = Shift; shiftmode = ARM::ShiftMode (opcode >> 22 & 0x3); immediate = A64::Immediate (opcode >> 10 & 0x3f); break;
	case MSEB: case MSEH: case MSEW: case MSEX: case MSEQ: model = (opcode >> 13 & 0x7) == 3 ? ShiftedIndex : ExtendedIndex; if (model == ExtendedIndex) extension = A64::Extension (opcode >> 13 & 0x7);
		register_ = A64::Register (X0 + (opcode >> 5 & 0x1f)); if (register_ == XZR) register_ = SP; immediate = A64::Immediate (opcode >> 12 & 0x1) * (type - MSEB);
		index = A64::Register ((model == ShiftedIndex || model == ExtendedIndex && extension == SEXTX ? X0 : W0) + (opcode >> 16 & 0x1f)); break;
	case Ext: model = Extension; extension = A64::Extension (opcode >> 13 & 0x7); immediate = A64::Immediate (opcode >> 10 & 0x3); break;
	case LI: model = Shift; shiftmode = ARM::LSL; immediate = A64::Immediate (opcode >> 22 & 0x1) * 12; break;
	case LE: model = Shift; shiftmode = ARM::LSL; immediate = A64::Immediate (opcode >> 10 & 0x3); break;
	case LBH: case LBS: model = Shift; shiftmode = ARM::LSL; immediate = A64::Immediate (opcode >> 13 & 0x3) << 3; break;
	case LW: case LX: model = Shift; shiftmode = ARM::LSL; immediate = A64::Immediate (opcode >> 21 & 0x3) << 4; break;
	case CC: model = ConditionCode; code = GetConditionCode (opcode >> 12 & 0xf); break;
	case CCI: model = ConditionCode; code = GetConditionCode (opcode >> 12 & 0xf ^ 0x1); break;
	case Cm: model = CoprocessorRegister; coregister = ARM::CoprocessorRegister (opcode >> 8 & 0xf); break;
	case Cn: model = CoprocessorRegister; coregister = ARM::CoprocessorRegister (opcode >> 12 & 0xf); break;
	default: model = Empty;
	}

	return IsCompatibleWith (type);
}

Opcode A64::Operand::Encode (const Type type) const
{
	if (type < Groups) return codes[symbol];

	switch (type)
	{
	case U4: return Opcode (immediate) << 8;
	case U5: case U6: case OP1: return Opcode (immediate) << 16;
	case U5N: return Opcode (-immediate & 0x1f) << 16;
	case U5ND: return Opcode (-immediate & 0x1f) << 16 | Opcode (31 - immediate) << 10;
	case U5P: case NZCV: return Opcode (immediate);
	case U5S: case U6S: case U12: return Opcode (immediate) << 10;
	case U5SD: case U6SD: return Opcode (immediate - 1) << 10;
	case U5SS: case U6SS: return Opcode (immediate + this[-1].immediate - 1) << 10;
	case U6N: return Opcode (-immediate & 0x3f) << 16;
	case U6ND: return Opcode (-immediate & 0x3f) << 16 | Opcode (63 - immediate) << 10;
	case U7H: case U16: case OP2: return Opcode (immediate) << 5;
	case U8: return Opcode (immediate & 0x1f) << 5 | Opcode (immediate >> 5 & 0x7) << 16;
	case U16I: return Opcode (~immediate & 0xffff) << 5;
	case UDB: case UQB: return Opcode (immediate) << 11;
	case S7W: return Opcode (immediate >> 2 & 0x7f) << 15;
	case S7X: return Opcode (immediate >> 3 & 0x7f) << 15;
	case S7Q: return Opcode (immediate >> 4 & 0x7f) << 15;
	case S9: return Opcode (immediate & 0x1ff) << 12;
	case S21: return Opcode (immediate & 0x3) << 29 | Opcode (immediate >> 2 & 0x7ffff) << 5;
	case S21P: return Opcode (immediate >> 12 & 0x3) << 29 | Opcode (immediate >> 14 & 0x7ffff) << 5;
	case O14: return Opcode (immediate >> 2 & 0x3fff) << 5;
	case O19: return Opcode (immediate >> 2 & 0x7ffff) << 5;
	case O26: return Opcode (immediate >> 2 & 0x3ffffff);
	case BW: return Opcode (immediate) << 19;
	case BX: return Opcode (immediate & 0x1f) << 19 | Opcode (immediate >> 5 & 0x1) << 31;
	case FBW: case FBX: return Opcode (64 - immediate) << 10;
	case FBB: case FBH: case FBS: case FBD: return Opcode ((1 << type - FBB + 3) - immediate) << 16;
	case FDB: case FDH: case FDS: case FDD: return Opcode (immediate) << 16;
	case IW: return Encode (immediate, 32) << 10;
	case IX: return Encode (immediate, 64) << 10;
	case R11: return Opcode (immediate / 90 << 11);
	case R12: return Opcode (immediate == 270) << 12;
	case R13: return Opcode (immediate / 90 << 13);
	case F5: {const auto opcode = Encode (floatImmediate); return (opcode & 0x1f) << 5 | (opcode >> 5 & 0x7) << 16;}
	case F13: return Encode (floatImmediate) << 13;
	case Wa: case Wt2: return Opcode (register_ - W0) << 10;
	case Wd: case Wt: return Opcode (register_ - W0);
	case WdSP: return Opcode ((register_ == WSP ? WZR : register_) - W0);
	case Wm: case Ws: return Opcode (register_ - W0) << 16;
	case Wn: case WnNZ: return Opcode (register_ - W0) << 5;
	case Wnm: case WnmZ: return Opcode (register_ - W0) << 5 | Opcode (register_ - W0) << 16;
	case WnSP: return Opcode ((register_ == WSP ? WZR : register_) - W0) << 5;
	case Xa: case Xt2: return Opcode (register_ - X0) << 10;
	case Xd: case Xt: return Opcode (register_ - X0);
	case XdSP: return Opcode ((register_ == SP ? XZR : register_) - X0);
	case Xm: case XmNZ: case Xs: return Opcode (register_ - X0) << 16;
	case XmSP: return Opcode ((register_ == SP ? XZR : register_) - X0) << 16;
	case Xn: case XnNZ: return Opcode (register_ - X0) << 5;
	case Xnm: case XnmZ: return Opcode (register_ - X0) << 5 | Opcode (register_ - X0) << 16;
	case XnSP: case MZ: return Opcode ((register_ == SP ? XZR : register_) - X0) << 5;
	case Bd: case Bt: return Opcode (register_ - B0);
	case Bm: return Opcode (register_ - B0) << 16;
	case Bn: return Opcode (register_ - B0) << 5;
	case Ha: return Opcode (register_ - H0) << 10;
	case Hd: case Ht: return Opcode (register_ - H0);
	case Hm: return Opcode (register_ - H0) << 16;
	case Hn: return Opcode (register_ - H0) << 5;
	case Sa: case St2: return Opcode (register_ - S0) << 10;
	case Sd: case St: return Opcode (register_ - S0);
	case Sm: return Opcode (register_ - S0) << 16;
	case Sn: return Opcode (register_ - S0) << 5;
	case Da: case Dt2: return Opcode (register_ - D0) << 10;
	case Dd: case Dt: return Opcode (register_ - D0);
	case Dm: return Opcode (register_ - D0) << 16;
	case Dn: return Opcode (register_ - D0) << 5;
	case Qd: case Qt: return Opcode (register_ - Q0);
	case Qn: return Opcode (register_ - Q0) << 5;
	case Qt2: return Opcode (register_ - Q0) << 10;
	case W1QB: case W2QB: case W3QB: case W4QB: return Opcode (register_ - V0) << 5;
	case V1DB: case V1DH: case V1DS: case V1DD: case V1QB: case V1QH: case V1QS: case V1QD:
	case V2DB: case V2DH: case V2DS: case V2DD: case V2QB: case V2QH: case V2QS: case V2QD:
	case V3DB: case V3DH: case V3DS: case V3DD: case V3QB: case V3QH: case V3QS: case V3QD:
	case V4DB: case V4DH: case V4DS: case V4DD: case V4QB: case V4QH: case V4QS: case V4QD:
	case VdSH: case VdDB: case VdDH: case VdDS: case VdDD: case VdQB: case VdQH: case VdQS: case VdQD: case VdQQ: return Opcode (register_ - V0);
	case VaSH: case VaDB: case VaDH: case VaDS: case VaDD: case VaQB: case VaQH: case VaQS: case VaQD: case VaQQ: return Opcode (register_ - V0) << 10;
	case VmSH: case VmDB: case VmDH: case VmDS: case VmDD: case VmQB: case VmQH: case VmQS: case VmQD: case VmQQ: return Opcode (register_ - V0) << 16;
	case VnSH: case VnDB: case VnDH: case VnDS: case VnDD: case VnQB: case VnQH: case VnQS: case VnQD: case VnQQ: return Opcode (register_ - V0) << 5;
	case VoSH: case VoDB: case VoDH: case VoDS: case VoDD: case VoQB: case VoQH: case VoQS: case VoQD: case VoQQ: return Opcode (register_ - V0) << 5 | Opcode (register_ - V0) << 16;
	case E1B: case E1H: case E1S: case E1D: case E2B: case E2H: case E2S: case E2D: case E3B: case E3H: case E3S: case E3D: case E4B: case E4H: case E4S: case E4D:
		return Opcode (register_ - V0) | Opcode (immediate << width & 0x7) << 10 | Opcode (immediate << width >> 3 & 0x1) << 30;
	case EdB: case EdH: case EdS: case EdD: return Opcode (register_ - V0) | Opcode (immediate << 17 + width);
	case EdD0: return Opcode (register_ - V0);
	case EnD0: return Opcode (register_ - V0) << 5;
	case EnS1: case EnD1: return Opcode (register_ - V0) << 5 | Opcode (immediate << 19 + width - WS);
	case EnB4: case EnH4: case EnS4: case EnD4: return Opcode (register_ - V0) << 5 | Opcode (immediate << 11 + width);
	case EnB5: case EnH5: case EnS5: case EnD5: return Opcode (register_ - V0) << 5 | Opcode (immediate << 17 + width);
	case EmH1: return Opcode (register_ - V0) << 16 | Opcode (immediate & 0x1) << 21;
	case EmS1: case EmD1: return Opcode (register_ - V0) << 16 | Opcode (immediate & 0x1) << 11;
	case EmB2: case EmH2: case EmS2: return Opcode (register_ - V0) << 16 | Opcode (immediate & 0x1) << 21 | Opcode (immediate >> 1 & 0x1) << 11;
	case EmH3: return Opcode (register_ - V0) << 16 | Opcode (immediate & 0x3) << 20 | Opcode (immediate >> 2 & 0x1) << 11;
	case EmSI: return Opcode (register_ - V0) << 16 | Opcode (immediate & 0x3) << 12;
	case M7W: case M7WP: return Opcode ((register_ == SP ? XZR : register_) - X0) << 5 | Opcode (immediate >> 2 & 0x7f) << 15;
	case M7X: case M7XP: return Opcode ((register_ == SP ? XZR : register_) - X0) << 5 | Opcode (immediate >> 3 & 0x7f) << 15;
	case M7Q: case M7QP: return Opcode ((register_ == SP ? XZR : register_) - X0) << 5 | Opcode (immediate >> 4 & 0x7f) << 15;
	case M9B: case M9BP: return Opcode ((register_ == SP ? XZR : register_) - X0) << 5 | Opcode (immediate & 0x1ff) << 12;
	case M9X: case M9XP: return Opcode ((register_ == SP ? XZR : register_) - X0) << 5 | Opcode (immediate >> 3 & 0x1ff) << 12 | Opcode (immediate >> 12 & 0x1) << 22;
	case M12B: case M12H: case M12W: case M12X: case M12Q: return Opcode ((register_ == SP ? XZR : register_) - X0) << 5 | Opcode (immediate >> type - M12B & 0xfff) << 10;
	case MSEB: case MSEH: case MSEW: case MSEX: case MSEQ: return Opcode ((register_ == SP ? XZR : register_) - X0) << 5 | Opcode (index - (model == ShiftedIndex || model == ExtendedIndex && extension == SEXTX ? X0 : W0)) << 16 |
		Opcode (model == ShiftedIndex ? 3 : extension) << 13 | Opcode (type != MSEB ? immediate / (type - MSEB) & 1 : 0) << 12;
	case ShW: case ShWR: case ShX: case ShXR: return Opcode (shiftmode) << 22 | Opcode (immediate) << 10;
	case LI: return Opcode (immediate / 12) << 22;
	case LE: return Opcode (immediate) << 10;
	case LBH: case LBS: return Opcode (immediate >> 3) << 13;
	case LW: case LX: return Opcode (immediate >> 4) << 21;
	case Ext: return Opcode (extension) << 13 | Opcode (immediate) << 10;
	case CC: return Opcode (GetValue (code)) << 12;
	case CCI: return Opcode (GetValue (code) ^ 0x1) << 12;
	case Cm: return Opcode (coregister) << 8;
	case Cn: return Opcode (coregister) << 12;
	default: return 0;
	}
}

bool A64::Operand::IsCompatibleWith (const Type type) const
{
	if (type < Groups) return model == Symbol && groups[symbol] == type;

	switch (type)
	{
	case I0: return model == Immediate && immediate == 0;
	case I1: case I2: case I4: case I8: case I16: case I32: case I64: return model == Immediate && immediate == 1 << (type - I1);
	case I3: case I6: case I12: case I24: case I48: return model == Immediate && immediate == 3 << (type - I3);
	case U4: case UQB: case NZCV: return model == Immediate && immediate >= 0 && immediate <= 15;
	case U5: case U5N: case U5ND: case U5S: case BW: return model == Immediate && immediate >= 0 && immediate <= 31;
	case U5P: return model == Immediate && (immediate >= 6 && immediate <= 7 || immediate >= 14 && immediate <= 15 || immediate >= 22 && immediate <= 31);
	case U5SD: case FBW: return model == Immediate && immediate >= 1 && immediate <= 32;
	case U5SS: return model == Immediate && immediate >= 1 && immediate <= 32 - this[-1].immediate;
	case U6: case U6N: case U6ND: case U6S: case BX: return model == Immediate && immediate >= 0 && immediate <= 63;
	case U6SD: case FBX: return model == Immediate && immediate >= 1 && immediate <= 64;
	case U6SS: return model == Immediate && immediate >= 1 && immediate <= 64 - this[-1].immediate;
	case U7H: return model == Immediate && immediate >= 6 && immediate <= 127 && immediate != 16 && immediate != 17;
	case U8: return model == Immediate && immediate >= 0 && immediate <= 255;
	case U12: return model == Immediate && immediate >= 0 && immediate <= 4095;
	case U16: return model == Immediate && immediate >= 0 && immediate <= 65535;
	case U16I: return model == Immediate && ~immediate >= 0 && ~immediate <= 65535;
	case UDB: return model == Immediate && immediate >= 0 && immediate <= 7;
	case S7W: return model == Immediate && immediate >= -256 && immediate <= 252 && immediate % 4 == 0;
	case S7X: return model == Immediate && immediate >= -512 && immediate <= 504 && immediate % 8 == 0;
	case S7Q: return model == Immediate && immediate >= -1024 && immediate <= 1008 && immediate % 16 == 0;
	case S9: return model == Immediate && immediate >= -256 && immediate <= 255;
	case S21: return model == Immediate && immediate >= -1048576 && immediate <= 1048575;
	case S21P: return model == Immediate && immediate >= -4294967296 && immediate <= 4294963200 && immediate % 4096 == 0;
	case O14: return model == Immediate && immediate >= -32768 && immediate <= 32767 && immediate % 4 == 0;
	case O19: return model == Immediate && immediate >= -1048576 && immediate <= 1048572 && immediate % 4 == 0;
	case O26: return model == Immediate && immediate >= -134217728 && immediate <= 134217724 && immediate % 4 == 0;
	case FBB: case FBH: case FBS: case FBD: return model == Immediate && immediate >= 1 && immediate <= 1 << type - FBB + 3;
	case FDB: case FDH: case FDS: case FDD: return model == Immediate && immediate >= 0 && immediate <= (1 << type - FDB + 3) - 1;
	case IW: return model == Immediate && IsValid (immediate, 32);
	case IX: return model == Immediate && IsValid (immediate, 64);
	case OP1: case OP2: return model == Immediate && immediate >= 0 && immediate <= 7;
	case R11: case R13: return model == Immediate && immediate >= 0 && immediate <= 270 && immediate % 90 == 0;
	case R12: return model == Immediate && (immediate == 90 || immediate == 270);
	case FZ: return model == FloatImmediate && floatImmediate == 0;
	case F5: case F13: return model == FloatImmediate && IsValid (floatImmediate);
	case Wa: case Wd: case Wm: case Wn: case Wnm: case Ws: case Wt: case Wt2: return model == Register && register_ >= W0 && register_ <= WZR;
	case Xa: case Xd: case Xm: case Xn: case Xnm: case Xs: case Xt: case Xt2: return model == Register && register_ >= X0 && register_ <= XZR;
	case WnmZ: case WnNZ: return model == Register && register_ >= W0 && register_ <= W30;
	case XnmZ: case XmNZ: case XnNZ: return model == Register && register_ >= X0 && register_ <= X30;
	case WdSP: case WnSP: return model == Register && (register_ >= W0 && register_ <= W30 || register_ == WSP);
	case XdSP: case XmSP: case XnSP: return model == Register && (register_ >= X0 && register_ <= X30 || register_ == SP);
	case WsP: case WtP: return model == Register && register_ >= W0 && register_ <= WZR && register_ == this[-1].register_ + 1;
	case XsP: case XtP: return model == Register && register_ >= X0 && register_ <= XZR && register_ == this[-1].register_ + 1;
	case Bd: case Bm: case Bn: case Bt: return model == Register && register_ >= B0 && register_ <= B31;
	case Ha: case Hd: case Hm: case Hn: case Ht: return model == Register && register_ >= H0 && register_ <= H31;
	case Sa: case Sd: case Sm: case Sn: case St: case St2: return model == Register && register_ >= S0 && register_ <= S31;
	case Da: case Dd: case Dm: case Dn: case Dt: case Dt2: return model == Register && register_ >= D0 && register_ <= D31;
	case Qd: case Qn: case Qt: case Qt2: return model == Register && register_ >= Q0 && register_ <= Q31;
	case V1DB: case V1DH: case V1DS: case V1DD: case V1QB: case V1QH: case V1QS: case V1QD:
	case V2DB: case V2DH: case V2DS: case V2DD: case V2QB: case V2QH: case V2QS: case V2QD:
	case V3DB: case V3DH: case V3DS: case V3DD: case V3QB: case V3QH: case V3QS: case V3QD:
	case V4DB: case V4DH: case V4DS: case V4DD: case V4QB: case V4QH: case V4QS: case V4QD:
		return model == VectorSet && size == (type - V1DB) / 8u + 1u && format == F8B + (type - V1DB) % 8u;
	case W1QB: case W2QB: case W3QB: case W4QB: return model == VectorSet && size == type - W1QB + 1u && format == F16B;
	case VaSH: case VaDB: case VaDH: case VaDS: case VaDD: case VaQB: case VaQH: case VaQS: case VaQD: case VaQQ: return model == Vector && format == type - VaSH;
	case VdSH: case VdDB: case VdDH: case VdDS: case VdDD: case VdQB: case VdQH: case VdQS: case VdQD: case VdQQ: return model == Vector && format == type - VdSH;
	case VmSH: case VmDB: case VmDH: case VmDS: case VmDD: case VmQB: case VmQH: case VmQS: case VmQD: case VmQQ: return model == Vector && format == type - VmSH;
	case VnSH: case VnDB: case VnDH: case VnDS: case VnDD: case VnQB: case VnQH: case VnQS: case VnQD: case VnQQ: return model == Vector && format == type - VnSH;
	case VoSH: case VoDB: case VoDH: case VoDS: case VoDD: case VoQB: case VoQH: case VoQS: case VoQD: case VoQQ: return model == Vector && format == type - VoSH;
	case E1B: case E1H: case E1S: case E1D: case E2B: case E2H: case E2S: case E2D: case E3B: case E3H: case E3S: case E3D: case E4B: case E4H: case E4S: case E4D:
		return model == ElementSet && size == (type - E1B) / 4u + 1u && width == (type - E1B) % 4u && immediate >= 0 && immediate <= 15 >> width;
	case EdB: case EdH: case EdS: case EdD: return model == Element && width == type - EdB && immediate >= 0 && immediate <= 15 >> width;
	case EdD0: case EnD0: return model == Element && width == WD && immediate == 1;
	case EnS1: case EnD1: return model == Element && width == WS + (type - EnS1) && immediate >= 0 && immediate <= 3 >> width - WS;
	case EnB4: case EnH4: case EnS4: case EnD4: return model == Element && width == type - EnB4 && immediate >= 0 && immediate <= 15 >> width;
	case EnB5: case EnH5: case EnS5: case EnD5: return model == Element && width == type - EnB5 && immediate >= 0 && immediate <= 15 >> width;
	case EmH1: case EmS1: case EmD1: return model == Element && width == WH + (type - EmH1) && immediate >= 0 && immediate <= 1;
	case EmB2: case EmH2: case EmS2: return model == Element && width == WB + (type - EmB2) && immediate >= 0 && immediate <= 3;
	case EmH3: return model == Element && register_ <= V15 && width == WH && immediate >= 0 && immediate <= 7;
	case EmSI: return model == Element && width == WS && immediate >= 0 && immediate <= 3;
	case MZ: return model == Memory && (register_ >= X0 && register_ <= X30 || register_ == SP) && immediate == 0 && !preindexed;
	case M7W: case M7WP: return model == Memory && (register_ >= X0 && register_ <= X30 || register_ == SP) && immediate >= -256 && immediate <= 252 && immediate % 4 == 0 && preindexed == (type == M7WP);
	case M7X: case M7XP: return model == Memory && (register_ >= X0 && register_ <= X30 || register_ == SP) && immediate >= -512 && immediate <= 504 && immediate % 8 == 0 && preindexed == (type == M7XP);
	case M7Q: case M7QP: return model == Memory && (register_ >= X0 && register_ <= X30 || register_ == SP) && immediate >= -1024 && immediate <= 1008 && immediate % 16 == 0 && preindexed == (type == M7QP);
	case M9B: case M9BP: return model == Memory && (register_ >= X0 && register_ <= X30 || register_ == SP) && immediate >= -256 && immediate <= 255 && preindexed == (type == M9BP);
	case M9X: case M9XP: return model == Memory && (register_ >= X0 && register_ <= X30 || register_ == SP) && immediate >= -4096 && immediate <= 4088 && immediate % 8 == 0 && preindexed == (type == M9XP);
	case M12B: case M12H: case M12W: case M12X: case M12Q: return model == Memory && (register_ >= X0 && register_ <= X30 || register_ == SP) && immediate >= 0 && immediate <= 4095 << type - M12B && immediate % (1 << type - M12B) == 0 && !preindexed;
	case MSEB: case MSEH: case MSEW: case MSEX: case MSEQ: return ((model == ShiftedIndex || model == ExtendedIndex && extension == SEXTX) && index >= X0 && index <= XZR || model == ExtendedIndex &&
		(extension == UEXTW || extension == SEXTW) && index >= W0 && index <= WZR) && (register_ >= X0 && register_ <= X30 || register_ == SP) && (immediate == 0 || immediate == type - MSEB);
	case ShW: return model == Shift && shiftmode <= ARM::ASR && immediate >= 0 && immediate <= 31;
	case ShWR: return model == Shift && shiftmode <= ARM::ROR && immediate >= 0 && immediate <= 31;
	case ShX: return model == Shift && shiftmode <= ARM::ASR && immediate >= 0 && immediate <= 63;
	case ShXR: return model == Shift && shiftmode <= ARM::ROR && immediate >= 0 && immediate <= 63;
	case LI: return model == Shift && shiftmode == ARM::LSL && (immediate == 0 || immediate == 12);
	case LE: return model == Shift && shiftmode == ARM::LSL && immediate >= 0 && immediate <= 4;
	case LBH: case LBS: return model == Shift && shiftmode == ARM::LSL && immediate >= 0 && immediate < 16 << type - LBH && immediate % 8 == 0;
	case LW: case LX: return model == Shift && shiftmode == ARM::LSL && immediate >= 0 && immediate < 32 << type - LW && immediate % 16 == 0;
	case Ext: return model == Extension && immediate >= 0 && immediate <= 4;
	case CC: return model == ConditionCode;
	case CCI: return model == ConditionCode && code != AL && code != NV;
	case Cm: case Cn: return model == CoprocessorRegister;
	default: return model == Empty;
	}
}

Mask A64::Operand::Decode (const Opcode immediate, const Bits bits)
{
	Bits size = 1; for (auto imms = immediate >> 6 & 0x40 | ~immediate & 0x3f; imms; imms >>= 1) size *= 2;
	Bits length = (immediate & (size - 1)) + 1;
	Mask mask = (Mask (1) << length) - 1;
	while (size < bits) mask |= mask << size, size *= 2;
	Bits rotation = immediate >> 6 & 0x3f;
	return mask >> rotation | mask << 64 - rotation >> 64 - bits;
}

Opcode A64::Operand::Encode (Mask mask, const Bits bits)
{
	if (bits != 64 && mask >> bits) return Invalid;
	Bits rotation = 0; while (rotation != bits && (!(mask & 1) || mask >> bits - 1)) mask = mask << 65 - bits >> bits | mask << 64 - bits >> 63, ++rotation;
	Bits length = 0; while (mask & 1) mask >>= 1, ++length;
	Bits size = mask ? length : bits; while (mask && !(mask & 1)) mask >>= 1, ++size;
	if (!IsPowerOfTwo (size) || rotation >= size || size != bits && !(mask >> bits - 2 * size + length - 1)) return Invalid;
	for (auto pattern = (Mask (1) << length) - 1 << 64 - size; mask; mask >>= size) if ((mask << 64 - size) != pattern) return Invalid;
	return size >> 6 << 12 | ~(size - 1) << 1 & 0x3f | length - 1 | rotation << 6;
}

bool A64::Operand::Decode (const Opcode opcode, const Type type, A64::Symbol& symbol)
{
	assert (type < Groups); const auto mask = opcode & masks[type];
	for (auto& code: codes) if (code == mask && groups[&code - codes] == type) return symbol = A64::Symbol (&code - codes), true;
	return false;
}

FloatImmediate A64::Operand::Decode (Opcode opcode)
{
	ARM::FloatImmediate value = 0;
	for (Bits i = 0; i != 4; ++i) value += opcode & 1, value /= 2, opcode >>= 1;
	signed exponent = (opcode & 0x7 ^ 0x4) - 3; value += 1;
	while (exponent < 0) value /= 2, ++exponent; while (exponent > 0) value *= 2, --exponent;
	if (opcode & 0x8) value = -value;
	return value;
}

Opcode A64::Operand::Encode (ARM::FloatImmediate value)
{
	if (value == 0) return Invalid;
	Opcode opcode = 0; signed exponent = 0;
	if (value < 0) value = -value, opcode= 0x8;
	while (value < 1) value *= 2, --exponent; while (value >= 2) value /= 2, ++exponent;
	if (exponent < -3 || exponent > 4) return Invalid;
	opcode |= exponent + 3 & 0x7 ^ 0x4; value -= 1;
	for (Bits i = 0; i != 4; ++i) if (opcode <<= 1, (value *= 2) >= 1) value -= 1, opcode |= 1;
	if (value != 0) return Invalid;
	return opcode;
}

A64::Instruction::Instruction (const Span<const Byte> bytes)
{
	if (bytes.size () < 4) return;
	const auto opcode = Opcode (bytes[0]) | Opcode (bytes[1]) << 8 | Opcode (bytes[2]) << 16 | Opcode (bytes[3]) << 24;
	for (auto& entry: table) if ((opcode & entry.mask) == entry.opcode)
		for (auto& operand: operands) if (!operand.Decode (opcode, entry.types[GetIndex (operand, operands)])) break;
			else if (IsLast (operand, operands)) {this->entry = &entry; return;}
}

A64::Instruction::Instruction (const Mnemonic mnemonic, const Operand& o0, const Operand& o1, const Operand& o2, const Operand& o3, const Operand& o4) :
	operands {o0, o1, o2, o3, o4}
{
	for (auto& entry: Span<const Entry> {first[mnemonic], last[mnemonic]})
		for (auto& operand: operands) if (!operand.IsCompatibleWith (entry.types[GetIndex (operand, operands)])) break;
			else if (IsLast (operand, operands)) {this->entry = &entry; return;}
}

void A64::Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); assert (bytes.size () >= 4); auto opcode = entry->opcode;
	for (auto& operand: operands) opcode |= operand.Encode (entry->types[GetIndex (operand, operands)]);
	bytes[0] = opcode; bytes[1] = opcode >> 8; bytes[2] = opcode >> 16; bytes[3] = opcode >> 24;
}

void A64::Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	if (entry->types[1] == Operand::U16) patch.pattern = {{0, 0xe0}, {1, 0xff}, {2, 0x1f}};
	else if (entry->types[1] == Operand::S21) patch.pattern = {{3, 0x60}, {0, 0xe0}, {1, 0xff}, {2, 0xff}};
	else if (entry->types[0] == Operand::O19 || entry->types[1] == Operand::O19) patch.scale += 2, patch.pattern = {{0, 0xe0}, {1, 0xff}, {2, 0xff}};
	else if (entry->types[0] == Operand::O26) patch.scale += 2, patch.pattern = {{0, 0xff}, {1, 0xff}, {2, 0xff}, {3, 0x03}};
	if (!IsEmpty (patch.pattern) && patch.mode == Object::Patch::Absolute && entry->types[1] != Operand::U16) patch.mode = Object::Patch::Relative;
}

bool A64::IsValid (const Mask mask, const Bits bits)
{
	return Operand::Encode (mask, bits) != Operand::Invalid;
}

bool A64::IsValid (const FloatImmediate floatImmediate)
{
	return Operand::Encode (floatImmediate) != Operand::Invalid;
}

A64::Register A64::GetRegister (const Operand& operand)
{
	assert (operand.model == Operand::Register); return operand.register_;
}

std::istream& A64::operator >> (std::istream& stream, Register& register_)
{
	char c = 0; if (stream >> std::ws && stream.get (c) && std::isdigit (stream.peek ()))
		if (c == 'w') ReadPrefixedValue (stream.putback (c), register_, "w", W0, W30);
		else if (c == 'x') ReadPrefixedValue (stream.putback (c), register_, "x", X0, X30);
		else if (c == 'b') ReadPrefixedValue (stream.putback (c), register_, "b", B0, B31);
		else if (c == 'h') ReadPrefixedValue (stream.putback (c), register_, "h", H0, H31);
		else if (c == 's') ReadPrefixedValue (stream.putback (c), register_, "s", S0, S31);
		else if (c == 'd') ReadPrefixedValue (stream.putback (c), register_, "d", D0, D31);
		else if (c == 'q') ReadPrefixedValue (stream.putback (c), register_, "q", Q0, Q31);
		else if (c == 'v') ReadPrefixedValue (stream.putback (c), register_, "v", V0, V31);
		else stream.putback (c).setstate (stream.failbit);
	else if (ReadEnum (stream.putback (c), register_, Operand::registers, IsAlpha))
		register_ = register_ == 2 ? WZR : register_ == 3 ? XZR : Register (register_ + WSP);
	return stream;
}

std::ostream& A64::operator << (std::ostream& stream, const Register register_)
{
	if (register_ >= W0 && register_ <= W30) return WritePrefixedValue (stream, register_, "w", W0);
	if (register_ == WZR) return WriteEnum (stream, 2, Operand::registers);
	if (register_ >= X0 && register_ <= X30) return WritePrefixedValue (stream, register_, "x", X0);
	if (register_ == XZR) return WriteEnum (stream, 3, Operand::registers);
	if (register_ >= B0 && register_ <= B31) return WritePrefixedValue (stream, register_, "b", B0);
	if (register_ >= H0 && register_ <= H31) return WritePrefixedValue (stream, register_, "h", H0);
	if (register_ >= S0 && register_ <= S31) return WritePrefixedValue (stream, register_, "s", S0);
	if (register_ >= D0 && register_ <= D31) return WritePrefixedValue (stream, register_, "d", D0);
	if (register_ >= Q0 && register_ <= Q31) return WritePrefixedValue (stream, register_, "q", Q0);
	if (register_ >= V0 && register_ <= V31) return WritePrefixedValue (stream, register_, "v", V0);
	return WriteEnum (stream, register_ - WSP, Operand::registers);
}

std::istream& A64::operator >> (std::istream& stream, Format& format)
{
	return ReadEnum (stream, format, Operand::formats, IsAlnum);
}

std::ostream& A64::operator << (std::ostream& stream, const Format format)
{
	return WriteEnum (stream, format, Operand::formats);
}

std::istream& A64::operator >> (std::istream& stream, Width& width)
{
	return ReadEnum (stream, width, Operand::widths, IsAlnum);
}

std::ostream& A64::operator << (std::ostream& stream, const Width width)
{
	return WriteEnum (stream, width, Operand::widths);
}

std::istream& A64::operator >> (std::istream& stream, Symbol& symbol)
{
	return ReadSortedEnum (stream, symbol, Operand::symbols, IsIdentifier);
}

std::ostream& A64::operator << (std::ostream& stream, const Symbol symbol)
{
	return WriteEnum (stream, symbol, Operand::symbols);
}

std::istream& A64::operator >> (std::istream& stream, Extension& extension)
{
	return ReadEnum (stream, extension, Operand::extensions, IsAlpha);
}

std::ostream& A64::operator << (std::ostream& stream, const Extension extension)
{
	return WriteEnum (stream, extension, Operand::extensions);
}

std::istream& A64::operator >> (std::istream& stream, Operand& operand)
{
	char peek[5] {}; stream >> std::ws; stream.get (peek, sizeof peek); for (auto c: Reverse {peek}) if (c) stream.putback (c);
	Register register_; Immediate immediate; FloatImmediate floatImmediate; union {Width width; Format format; ShiftMode shiftmode; Extension extension; ConditionCode code; CoprocessorRegister coregister; Symbol symbol;};
	if (std::isdigit (peek[0]) || peek[0] == '+' || peek[0] == '-')
		if (stream >> immediate) if (stream.good () && stream.peek () == '.') if (stream >> floatImmediate) operand = immediate < 0 ? immediate - floatImmediate : immediate + floatImmediate; else; else operand = immediate; else;
	else if (peek[0] == 'b' || peek[0] == 'd' && std::isdigit (peek[1]) || peek[0] == 'h' && std::isdigit (peek[1]) || peek[0] == 'q' || peek[0] == 's' && (std::isdigit (peek[1]) && peek[2] != 'e' && (peek[2] != '2' || peek[3] != 'e') || peek[1] == 'p' && peek[2] != 's' && peek[2] != '_') || peek[0] == 'w' || peek[0] == 'x' && (std::isdigit (peek[1]) || peek[1] == 'z'))
		if (stream >> register_) operand = register_; else;
	else if (peek[0] == 'v' && std::isdigit (peek[1]))
		if (stream >> register_ && stream.get () == '.')
			if (std::isdigit (stream.peek ())) if (stream >> format) operand = {register_, format}; else;
			else if (stream >> width >> std::ws && stream.get () == '[' && stream >> immediate >> std::ws && stream.get () == ']') operand = {register_, width, immediate}; else;
		else;
	else if (peek[0] == '[' && stream.ignore ())
	{
		Register index; bool shifted = false, extended = false; stream >> register_;
		if (stream >> std::ws && stream.peek () == ',' && stream.ignore ())
			if (stream >> std::ws && !std::isalpha (stream.peek ())) stream >> immediate;
			else if (stream >> index >> std::ws && stream.peek () == ',' && stream.ignore ())
				if (stream.peek () == 'l' && stream >> shiftmode) if (shiftmode == ShiftMode::LSL) stream >> immediate, shifted = true; else stream.setstate (stream.failbit);
				else if (stream >> extension >> std::ws && stream.peek () != ']') stream >> immediate, extended = true; else immediate = 0, extended = true;
			else immediate = 0, shifted = true;
		else immediate = 0;
		if (stream >> std::ws && stream.get () != ']') stream.setstate (stream.failbit);
		else if (shifted) operand = {register_, index, immediate};
		else if (extended) operand = {register_, index, extension, immediate};
		else operand = {register_, immediate, stream && stream.good () && stream >> std::ws && stream.good () && stream.peek () == '!' && stream.ignore ()};
	}
	else if (peek[0] == '{' && stream.ignore ())
	{
		Operand::Size size = 1; Register nextRegister; bool vector; Width nextWidth; Format nextFormat;
		if (stream >> register_ && register_ >= V0 && register_ <= V31 && stream.get () == '.')
			if (vector = std::isdigit (stream.peek ())) stream >> format; else stream >> width; else stream.setstate (stream.failbit);
		while (size < 4 && stream >> std::ws && stream.peek () == ',' && stream.ignore () >> nextRegister)
			if (nextRegister == V0 + (register_ - V0 + size) % 32 && stream.get () == '.' && (vector ? stream >> nextFormat && nextFormat == format : stream >> nextWidth && nextWidth == width)) ++size; else stream.setstate (stream.failbit);
		if (stream.get () != '}') stream.setstate (stream.failbit);
		else if (vector) operand = {register_, format, size};
		else if (stream >> std::ws && stream.get () == '[' && stream >> immediate >> std::ws && stream.get () == ']') operand = {register_, width, size, immediate}; else stream.setstate (stream.failbit);
	}
	else if (peek[0] == 'a' && peek[1] == 's' && peek[2] != 'i'|| peek[0] == 'l' && peek[1] == 's' || peek[0] == 'r' && peek[1] == 'o')
		if (stream >> shiftmode) if (stream.good () && stream >> std::ws && stream.good () && std::isdigit (stream.peek ()) && stream >> immediate) operand = {shiftmode, immediate}; else operand = shiftmode; else;
	else if (peek[0] == 's' && peek[1] == 'x' || peek[0] == 'u' && peek[1] == 'x')
		if (stream >> extension) if (stream.good () && stream >> std::ws && stream.good () && std::isdigit (stream.peek ()) && stream >> immediate) operand = {extension, immediate}; else operand = extension; else;
	else if (peek[0] == 'a' && peek[1] == 'l' && peek[2] != 'l' || peek[0] == 'c' && (peek[1] == 'c' || peek[1] == 's') && !std::isalpha (peek[2]) || peek[0] == 'e' && peek[1] == 'q' || peek[0] == 'g' ||
		peek[0] == 'h' && (peek[1] == 'i' || peek[1] == 's' && peek[2] != 't') || peek[0] == 'l' && (peek[1] == 'e' || peek[1] == 'o' && peek[2] != 'r' || peek[1] == 's' || peek[1] == 't') ||
		peek[0] == 'm' && peek[1] == 'i' && peek[2] != 'd' || peek[0] == 'n' && (peek[1] == 'e' || peek[1] == 'v') || peek[0] == 'p' && peek[1] == 'l' && peek[2] != 'd' && peek[2] != 'i' || peek[0] == 'v' && (peek[1] == 'c' || peek[1] == 's'))
			if (stream >> code) operand = code; else;
	else if (peek[0] == 'c' && std::isdigit (peek[1]))
		if (stream >> coregister) operand = coregister; else;
	else if (stream >> symbol) operand = symbol;
	return stream;
}

std::ostream& A64::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Immediate: return stream << operand.immediate;
	case Operand::FloatImmediate: return stream << std::showpoint << operand.floatImmediate;
	case Operand::Register: return stream << operand.register_;
	case Operand::Vector: return stream << operand.register_ << '.' << operand.format;
	case Operand::VectorSet: stream << '{'; for (Operand::Size index = 0; index != operand.size; ++index) (index ? stream << ", " : stream) << Register (V0 + (operand.register_ - V0 + index) % 32) << '.' << operand.format; return stream << '}';
	case Operand::Element: return stream << operand.register_ << '.' << operand.width << '[' << operand.immediate << ']';
	case Operand::ElementSet: stream << '{'; for (Operand::Size index = 0; index != operand.size; ++index) (index ? stream << ", " : stream) << Register (V0 + (operand.register_ - V0 + index) % 32) << '.' << operand.width; return stream << "}[" << operand.immediate << ']';
	case Operand::Memory: stream << '[' << operand.register_; if (operand.immediate || operand.preindexed) stream << ", " << operand.immediate; stream << ']'; if (operand.preindexed) stream << '!'; return stream;
	case Operand::ShiftedIndex: stream << '[' << operand.register_ << ", " << operand.index; if (operand.immediate) stream << ", " << ShiftMode::LSL << ' ' << operand.immediate; return stream << ']';
	case Operand::ExtendedIndex: stream << '[' << operand.register_ << ", " << operand.index << ", " << operand.extension; if (operand.immediate) stream << ' ' << operand.immediate; return stream << ']';
	case Operand::Shift: return stream << operand.shiftmode << ' ' << operand.immediate;
	case Operand::Extension: stream << operand.extension; if (operand.immediate) stream << ' ' << operand.immediate; return stream;
	case Operand::ConditionCode: return stream << operand.code;
	case Operand::CoprocessorRegister: return stream << operand.coregister;
	case Operand::Symbol: return stream << operand.symbol;
	default: return stream;
	}
}

std::istream& A64::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic; std::array<Operand, 5> operands;
	if (stream >> mnemonic && stream.good () && stream >> std::ws && stream.good ())
		for (auto& operand: operands) if (stream >> operand && stream.good () && stream >> std::ws && stream.good () && stream.peek () == ',' && stream.ignore ()) continue; else break;
	if (stream) instruction = {mnemonic, operands[0], operands[1], operands[2], operands[3], operands[4]};
	return stream;
}

std::ostream& A64::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry); stream << instruction.entry->mnemonic;
	for (auto& operand: instruction.operands) if (IsEmpty (operand)) break; else (IsFirst (operand, instruction.operands) ? stream << '\t' : stream << ", ") << operand;
	return stream;
}

std::istream& A64::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsDotted);
}

std::ostream& A64::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

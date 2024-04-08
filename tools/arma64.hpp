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

#ifndef ECS_ARM_A64_HEADER_INCLUDED
#define ECS_ARM_A64_HEADER_INCLUDED

#include "arm.hpp"

#include <array>

namespace ECS
{
	using Bits = unsigned;
}

namespace ECS::ARM::A64
{
	enum Register
	{
		W0, W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, W11, W12, W13, W14, W15,
		W16, W17, W18, W19, W20, W21, W22, W23, W24, W25, W26, W27, W28, W29, W30, WZR,
		X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15,
		X16, X17, X18, X19, X20, X21, X22, X23, X24, X25, X26, X27, X28, X29, X30, XZR,
		B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15,
		B16, B17, B18, B19, B20, B21, B22, B23, B24, B25, B26, B27, B28, B29, B30, B31,
		H0, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12, H13, H14, H15,
		H16, H17, H18, H19, H20, H21, H22, H23, H24, H25, H26, H27, H28, H29, H30, H31,
		S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15,
		S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31,
		D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15,
		D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31,
		Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15,
		Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31,
		V0, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15,
		V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V26, V27, V28, V29, V30, V31,
		WSP, SP,
	};

	enum Extension {UEXTB, UEXTH, UEXTW, UEXTX, SEXTB, SEXTH, SEXTW, SEXTX};
	enum Format {F2H, F8B, F4H, F2S, F1D, F16B, F8H, F4S, F2D, F1Q};
	enum Width {WB, WH, WS, WD};

	enum Symbol {
		#define SYMBOL(name, symbol, code, group) symbol,
		#include "arma64.def"
	};

	class Instruction;
	class Operand;

	using Immediate = std::int64_t;
	using Mask = std::uint64_t;

	bool IsEmpty (const Operand&);
	bool IsValid (const Instruction&);
	bool IsValid (FloatImmediate);
	bool IsValid (Mask, Bits);

	auto GetRegister (const Operand&) -> Register;

	std::istream& operator >> (std::istream&, Extension&);
	std::istream& operator >> (std::istream&, Format&);
	std::istream& operator >> (std::istream&, Instruction&);
	std::istream& operator >> (std::istream&, Operand&);
	std::istream& operator >> (std::istream&, Register&);
	std::istream& operator >> (std::istream&, Symbol&);
	std::istream& operator >> (std::istream&, Width&);
	std::ostream& operator << (std::ostream&, const Instruction&);
	std::ostream& operator << (std::ostream&, const Operand&);
	std::ostream& operator << (std::ostream&, Format);
	std::ostream& operator << (std::ostream&, Extension);
	std::ostream& operator << (std::ostream&, Register);
	std::ostream& operator << (std::ostream&, Symbol);
	std::ostream& operator << (std::ostream&, Width);
}

class ECS::ARM::A64::Operand
{
public:
	using Preindexed = bool;
	using Size = unsigned;

	Operand () = default;
	Operand (A64::Symbol);
	Operand (A64::Register);
	Operand (A64::Immediate);
	Operand (ARM::ConditionCode);
	Operand (ARM::FloatImmediate);
	Operand (A64::Register, Format);
	Operand (ARM::CoprocessorRegister);
	Operand (A64::Register, Format, Size);
	Operand (ARM::ShiftMode, A64::Immediate = 0);
	Operand (A64::Extension, A64::Immediate = 0);
	Operand (A64::Register, Width, A64::Immediate);
	Operand (A64::Register, Width, Size, A64::Immediate);
	Operand (A64::Register, A64::Immediate, Preindexed = false);
	Operand (A64::Register, A64::Register, A64::Immediate = 0);
	Operand (A64::Register, A64::Register, A64::Extension, A64::Immediate = 0);

private:
	enum Model {Empty, Immediate, FloatImmediate, Register, Vector, VectorSet, Element, ElementSet, Memory, ShiftedIndex, ExtendedIndex, Shift, Extension, ConditionCode, CoprocessorRegister, Symbol};

	enum Type {
		#define GROUP(group, mask) group,
		#include "arma64.def"
		Groups, Void,
		#define TYPE(type) type,
		#include "arma64.def"
	};

	Model model = Empty;
	A64::Register register_;

	union
	{
		A64::Register index;
		Size size;
	};

	union
	{
		A64::Immediate immediate;
		ARM::FloatImmediate floatImmediate;
	};

	union
	{
		Width width;
		Format format;
		Preindexed preindexed;
		ARM::ShiftMode shiftmode;
		A64::Extension extension;
		ARM::ConditionCode code;
		ARM::CoprocessorRegister coregister;
		A64::Symbol symbol;
	};

	Opcode Encode (Type) const;
	bool Decode (Opcode, Type);
	bool IsCompatibleWith (Type) const;

	static const Type groups[];
	static const Opcode codes[];
	static const Opcode masks[];
	static const char*const widths[];
	static const char*const formats[];
	static const char*const symbols[];
	static const char*const registers[];
	static const char*const extensions[];

	static constexpr Opcode Invalid = -1;

	static Mask Decode (Opcode, Bits);
	static Opcode Encode (Mask, Bits);
	static Opcode Encode (ARM::FloatImmediate);
	static ARM::FloatImmediate Decode (Opcode);
	static bool Decode (Opcode, Type, A64::Symbol&);

	friend class Instruction;
	friend bool IsValid (Mask, Bits);
	friend bool IsEmpty (const Operand&);
	friend bool IsValid (ARM::FloatImmediate);
	friend A64::Register GetRegister (const Operand&);
	friend std::istream& operator >> (std::istream&, A64::Extension&);
	friend std::istream& operator >> (std::istream&, A64::Format&);
	friend std::istream& operator >> (std::istream&, A64::Register&);
	friend std::istream& operator >> (std::istream&, A64::Symbol&);
	friend std::istream& operator >> (std::istream&, A64::Width&);
	friend std::ostream& operator << (std::ostream&, A64::Extension);
	friend std::ostream& operator << (std::ostream&, A64::Format);
	friend std::ostream& operator << (std::ostream&, A64::Register);
	friend std::ostream& operator << (std::ostream&, A64::Symbol);
	friend std::ostream& operator << (std::ostream&, A64::Width);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::ARM::A64::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "arma64.def"
		Count,
	};

	Instruction () = default;
	explicit Instruction (Span<const Byte>);
	Instruction (Mnemonic, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {});

	void Emit (Span<Byte>) const;
	void Adjust (Object::Patch&) const;

private:
	struct Entry;

	const Entry* entry = nullptr;
	std::array<Operand, 5> operands;

	static const Entry table[];
	static const char*const mnemonics[];
	static const Lookup<Entry, Mnemonic> first, last;

	friend bool IsValid (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::ARM::A64
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "arma64.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::ARM::A64::Instruction::Mnemonic>
struct ECS::ARM::A64::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::ARM::A64::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::ARM::A64::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::ARM::A64::Instruction::Mnemonic m>
inline ECS::ARM::A64::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op0, const Operand& op1, const Operand& op2, const Operand& op3, const Operand& op4) :
	Instruction {m, op0, op1, op2, op3, op4}
{
}

#endif // ECS_ARM_A64_HEADER_INCLUDED

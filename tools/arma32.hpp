// ARM A32 instruction set representation
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

#ifndef ECS_ARM_A32_HEADER_INCLUDED
#define ECS_ARM_A32_HEADER_INCLUDED

#include "arm.hpp"

#include <array>

namespace ECS::ARM::A32
{
	enum CoprocessorOption : std::uint8_t {};

	class Instruction;
	class Operand;

	bool IsEmpty (const Operand&);
	bool IsSeparated (const Operand&);
	bool IsSeparator (const Operand&);
	bool IsValid (const Instruction&);
	bool NeedsSeparator (const Operand&);

	auto GetRegister (const Operand&) -> Register;
	auto GetRotation (Immediate) -> Immediate;
	auto operator - (Register) -> Operand;

	std::istream& operator >> (std::istream&, CoprocessorOption&);
	std::istream& operator >> (std::istream&, Instruction&);
	std::istream& operator >> (std::istream&, Operand&);
	std::ostream& operator << (std::ostream&, CoprocessorOption);
	std::ostream& operator << (std::ostream&, const Instruction&);
	std::ostream& operator << (std::ostream&, const Operand&);
}

class ECS::ARM::A32::Operand
{
public:
	Operand (char);
	Operand () = default;
	Operand (ARM::Register);
	Operand (ARM::Immediate);
	Operand (ARM::ShiftMode);
	Operand (ARM::Coprocessor);
	Operand (ARM::RegisterList);
	Operand (ARM::ConditionCode);
	Operand (A32::CoprocessorOption);
	Operand (ARM::SingleRegisterList);
	Operand (ARM::DoubleRegisterList);
	Operand (ARM::CoprocessorRegister);

private:
	enum Model {Empty, Immediate, Register, NegativeRegister, RegisterList, DoubleRegisterList, SingleRegisterList,
		ShiftMode, ConditionCode, Coprocessor, CoprocessorRegister, CoprocessorOption, Character};

	enum Type {Void,
		#define TYPE(type) type,
		#include "arma32.def"
	};

	Model model = Empty;

	union
	{
		ARM::Immediate immediate;
		ARM::Register register_;
		ARM::RegisterSet registerSet;
		ARM::ShiftMode shiftmode;
		ARM::ConditionCode code;
		ARM::Coprocessor coprocessor;
		ARM::CoprocessorRegister coregister;
		A32::CoprocessorOption cooption;
		char character;
	};

	Operand (Model, ARM::Register);

	bool Decode (Opcode, Type);
	Opcode Encode (Type) const;
	bool IsCompatibleWith (Type) const;

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend bool IsSeparator (const Operand&);
	friend bool IsSeparated (const Operand&);
	friend Operand operator - (ARM::Register);
	friend bool NeedsSeparator (const Operand&);
	friend ARM::Register GetRegister (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

class ECS::ARM::A32::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "arma32.def"
		LastMnemonic, FirstMnemonic = 0, Count = LastMnemonic - FirstMnemonic
	};

	Instruction () = default;
	explicit Instruction (Span<const Byte>);
	Instruction (Mnemonic, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {},
		const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {});

	void Emit (Span<Byte>) const;
	void Adjust (Object::Patch&) const;

private:
	struct Entry;

	const Entry* entry = nullptr;
	std::array<Operand, 9> operands;

	static const Entry table[];
	static const char*const mnemonics[];
	static const Lookup<Entry, Mnemonic> first, last;

	friend bool IsValid (const Instruction&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::istream& operator >> (std::istream&, Instruction&);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::ARM::A32
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "arma32.def"

	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::ARM::A32::Instruction::Mnemonic>
struct ECS::ARM::A32::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {},
		const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::ARM::A32::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::ARM::A32::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::ARM::A32::Instruction::Mnemonic m>
inline ECS::ARM::A32::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op0, const Operand& op1, const Operand& op2, const Operand& op3,
	const Operand& op4, const Operand& op5, const Operand& op6, const Operand& op7, const Operand& op8) :
	Instruction {m, op0, op1, op2, op3, op4, op5, op6, op7, op8}
{
}

#endif // ECS_ARM_A32_HEADER_INCLUDED

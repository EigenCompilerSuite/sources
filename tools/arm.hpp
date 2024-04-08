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

#ifndef ECS_ARM_HEADER_INCLUDED
#define ECS_ARM_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>
#include <string>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::ARM
{
	enum ConditionCode {No, AL, CC, CS, EQ, GE, GT, HI, HS, LE, LO, LS, LT, MI, NE, NV, PL, VC, VS};

	enum Suffix {None,
		#define SUFFIX(name, suffix) suffix,
		#include "arm.def"
	};

	enum Qualifier {Default, Narrow, Wide};

	enum ShiftMode {LSL, LSR, ASR, ROR, RRX};

	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
		SP = R13, LR = R14, PC = R15,
		D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15,
		D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31,
		S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15,
		S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31,
		Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15,
	};

	enum Coprocessor {P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15};

	enum CoprocessorRegister {C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15};

	enum BarrierOperation {ISH, ISHLD, ISHST, LD, NSH, NSHLD, NSHST, OSH, OSHLD, OSHST, ST, SY};

	enum InterruptMask {A = 0x4, I = 0x2, F = 0x1};

	class BasicList;
	class Instruction;
	class Operand;

	template <Register, Register> class List;

	using DoubleRegisterList = List<D0, D31>;
	using FloatImmediate = double;
	using Immediate = std::int32_t;
	using Opcode = std::uint32_t;
	using RegisterList = List<R0, R15>;
	using RegisterSet = std::uint32_t;
	using SingleRegisterList = List<S0, S31>;

	bool HasConditionCode (const std::string&, std::string::size_type, ConditionCode&);
	bool IsEmpty (const Operand&);

	auto GetBarrierOperation (Byte) -> BarrierOperation;
	auto GetConditionCode (Byte) -> ConditionCode;
	auto GetRegister (const Operand&) -> Register;
	auto GetValue (BarrierOperation) -> Byte;
	auto GetValue (ConditionCode) -> Byte;

	std::istream& operator >> (std::istream&, BarrierOperation&);
	std::istream& operator >> (std::istream&, ConditionCode&);
	std::istream& operator >> (std::istream&, Coprocessor&);
	std::istream& operator >> (std::istream&, CoprocessorRegister&);
	std::istream& operator >> (std::istream&, InterruptMask&);
	std::istream& operator >> (std::istream&, Operand&);
	std::istream& operator >> (std::istream&, Register&);
	std::istream& operator >> (std::istream&, ShiftMode&);
	std::ostream& operator << (std::ostream&, BarrierOperation);
	std::ostream& operator << (std::ostream&, ConditionCode);
	std::ostream& operator << (std::ostream&, const Operand&);
	std::ostream& operator << (std::ostream&, Coprocessor);
	std::ostream& operator << (std::ostream&, CoprocessorRegister);
	std::ostream& operator << (std::ostream&, InterruptMask);
	std::ostream& operator << (std::ostream&, Qualifier);
	std::ostream& operator << (std::ostream&, Register);
	std::ostream& operator << (std::ostream&, ShiftMode);
	std::ostream& operator << (std::ostream&, Suffix);

	template <Register First, Register Last> std::istream& operator >> (std::istream&, List<First, Last>&);
	template <Register First, Register Last> std::ostream& operator << (std::ostream&, List<First, Last>);
}

namespace ECS::Object
{
	struct Patch;
}

class ECS::ARM::Operand
{
public:
	using WriteBack = bool;

	Operand () = default;
	Operand (ARM::Immediate);
	Operand (ARM::RegisterList);
	Operand (ARM::Coprocessor);
	Operand (ARM::ConditionCode);
	Operand (ARM::InterruptMask);
	Operand (ARM::BarrierOperation);
	Operand (ARM::DoubleRegisterList);
	Operand (ARM::SingleRegisterList);
	Operand (ARM::CoprocessorRegister);
	Operand (ARM::ShiftMode, ARM::Register);
	Operand (ARM::Register, WriteBack = false);
	Operand (ARM::ShiftMode, ARM::Immediate = 0);
	Operand (ARM::Register, ARM::Immediate, WriteBack = false);
	Operand (ARM::Register, ARM::Register, ARM::Immediate = 0);

protected:
	enum Model {Empty, Immediate, Register, ShiftedRegister, RegisterList, DoubleRegisterList, SingleRegisterList, Memory, MemoryIndex, ShiftMode, ConditionCode, InterruptMask, BarrierOperation, Coprocessor, CoprocessorRegister};

	Model model = Empty;

	union
	{
		ARM::Register register_;
		ARM::RegisterSet registerSet;
		ARM::ConditionCode code;
		ARM::InterruptMask mask;
		ARM::BarrierOperation operation;
		ARM::Coprocessor coprocessor;
		ARM::CoprocessorRegister coregister;
	};

	union
	{
		ARM::Immediate immediate;
		ARM::Register index;
		ARM::ShiftMode mode;
	};

	union {
		WriteBack writeBack;
		ARM::Immediate shift;
	};

	friend bool IsEmpty (const Operand&);
	friend ARM::Register GetRegister (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::ARM::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "arm.def"
		Count,
	};

protected:
	enum Flags {
		#define FLAG(flag, value) flag = value,
		#include "arm.def"
	};

	static std::istream& Read (std::istream&, Mnemonic&, ConditionCode&, Qualifier&, Suffix&);
	static std::ostream& Write (std::ostream&, Mnemonic, ConditionCode, Qualifier, Suffix);

private:
	static const char*const mnemonics[];
	static const char*const suffixes[];

	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::istream& operator >> (std::istream&, Suffix&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, Suffix);
};

class ECS::ARM::BasicList
{
public:
	explicit BasicList (RegisterSet = 0);

	explicit operator RegisterSet () const;

protected:
	std::istream& Read (std::istream&, Register, Register);
	std::ostream& Write (std::ostream&, Register, Register) const;

private:
	RegisterSet registerSet;
};

template <ECS::ARM::Register, ECS::ARM::Register>
class ECS::ARM::List : public BasicList
{
public:
	List () = default;
	explicit List (Register);
	using BasicList::BasicList;

private:
	friend std::istream& operator >> <> (std::istream&, List&);
	friend std::ostream& operator << <> (std::ostream&, List);
};

namespace ECS::ARM
{
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

inline ECS::ARM::BasicList::BasicList (const RegisterSet s) :
	registerSet {s}
{
}

inline ECS::ARM::BasicList::operator RegisterSet () const
{
	return registerSet;
}

template <ECS::ARM::Register First, ECS::ARM::Register Last>
inline ECS::ARM::List<First, Last>::List (const Register register_) :
	BasicList {1u << RegisterSet (register_ - First)}
{
}

inline bool ECS::ARM::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

template <ECS::ARM::Register First, ECS::ARM::Register Last>
inline std::istream& ECS::ARM::operator >> (std::istream& stream, List<First, Last>& registerList)
{
	return registerList.Read (stream, First, Last);
}

template <ECS::ARM::Register First, ECS::ARM::Register Last>
inline std::ostream& ECS::ARM::operator << (std::ostream& stream, const List<First, Last> registerList)
{
	return registerList.Write (stream, First, Last);
}

#endif // ECS_ARM_HEADER_INCLUDED

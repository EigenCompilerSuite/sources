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

#ifndef ECS_AVR32_HEADER_INCLUDED
#define ECS_AVR32_HEADER_INCLUDED

#include <array>
#include <cstddef>
#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::AVR32
{
	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7,
		R8, R9, R10, R11, R12, R13, R14, R15,
		SP = R13, LR = R14, PC = R15,
	};

	enum Coprocessor
	{
		CP0, CP1, CP2, CP3, CP4, CP5, CP6, CP7,
	};

	enum CoprocessorRegister
	{
		CR0, CR1, CR2, CR3, CR4, CR5, CR6, CR7,
		CR8, CR9, CR10, CR11, CR12, CR13, CR14, CR15,
	};

	enum Parameter {COH};
	enum Part {B, L, U, T};

	class Instruction;
	class Operand;

	using Immediate = std::int32_t;
	using Opcode = std::uint32_t;
	using Shift = std::uint32_t;

	bool IsEmpty (const Operand&);
	bool IsValid (const Instruction&);

	auto ExtendBranch (const Instruction&) -> Instruction;
	auto GetRegister (const Operand&) -> Register;
	auto GetSize (const Instruction&) -> std::size_t;

	std::istream& operator >> (std::istream&, Coprocessor&);
	std::istream& operator >> (std::istream&, CoprocessorRegister&);
	std::istream& operator >> (std::istream&, Instruction&);
	std::istream& operator >> (std::istream&, Operand&);
	std::istream& operator >> (std::istream&, Parameter&);
	std::istream& operator >> (std::istream&, Part&);
	std::istream& operator >> (std::istream&, Register&);
	std::ostream& operator << (std::ostream&, const Instruction&);
	std::ostream& operator << (std::ostream&, const Operand&);
	std::ostream& operator << (std::ostream&, Coprocessor);
	std::ostream& operator << (std::ostream&, CoprocessorRegister);
	std::ostream& operator << (std::ostream&, Parameter);
	std::ostream& operator << (std::ostream&, Part);
	std::ostream& operator << (std::ostream&, Register);
}

namespace ECS::Object
{
	struct Patch;
}

class ECS::AVR32::Operand
{
public:
	Operand () = default;
	Operand (AVR32::Register);
	Operand (AVR32::Immediate);
	Operand (AVR32::Parameter);
	Operand (AVR32::Coprocessor);
	Operand (AVR32::Register, Part);
	Operand (AVR32::Register, bool);
	Operand (bool, AVR32::Register);
	Operand (Shift, AVR32::Register);
	Operand (AVR32::Register, Shift);
	Operand (AVR32::CoprocessorRegister);
	Operand (AVR32::Register, AVR32::Immediate);
	Operand (AVR32::Register, AVR32::Register, Shift);

private:
	enum Model {Empty, Immediate, Register, LeftShiftRegister, RightShiftRegister, PartialRegister,
		IncrementedPointer, DecrementedPointer, DisplacedPointer, LeftShiftRegisterPointer,
		Coprocessor, CoprocessorRegister, Parameter};

	enum Type {Void,
		#define TYPE(type) type,
		#include "avr32.def"
	};

	Model model = Empty;
	AVR32::Register pointer;

	union
	{
		AVR32::Register register_;
		AVR32::Coprocessor coprocessor;
		AVR32::CoprocessorRegister cpregister;
	};

	union
	{
		Part part;
		Shift shift;
		AVR32::Immediate immediate;
		AVR32::Parameter parameter;
	};

	void Decode (Opcode, Type);
	Opcode Encode (Type) const;
	bool IsCompatibleWith (Type) const;

	static const char parts[];
	static const char*const parameters[];

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend AVR32::Register GetRegister (const Operand&);
	friend Instruction ExtendBranch (const Instruction&);
	friend std::istream& operator >> (std::istream&, Part&);
	friend std::istream& operator >> (std::istream&, AVR32::Parameter&);
	friend std::ostream& operator << (std::ostream&, Part);
	friend std::ostream& operator << (std::ostream&, const Operand&);
	friend std::ostream& operator << (std::ostream&, AVR32::Parameter);
};

class ECS::AVR32::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "avr32.def"
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
	friend std::size_t GetSize (const Instruction&);
	friend Instruction ExtendBranch (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::AVR32
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "avr32.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::AVR32::Instruction::Mnemonic>
struct ECS::AVR32::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::AVR32::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::AVR32::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::AVR32::Instruction::Mnemonic m>
inline ECS::AVR32::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op0, const Operand& op1, const Operand& op2, const Operand& op3, const Operand& op4) :
	Instruction {m, op0, op1, op2, op3, op4}
{
}

#endif // ECS_AVR32_HEADER_INCLUDED

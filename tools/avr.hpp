// AVR instruction set representation
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

#ifndef ECS_AVR_HEADER_INCLUDED
#define ECS_AVR_HEADER_INCLUDED

#include <cstddef>
#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::AVR
{
	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7,
		R8, R9, R10, R11, R12, R13, R14, R15,
		R16, R17, R18, R19, R20, R21, R22, R23,
		R24, R25, R26, R27, R28, R29, R30, R31,
		RXL = R26, RXH = R27, RYL = R28, RYH = R29, RZL = R30, RZH = R31,
	};

	enum IORegister {SPL = 0x3d, SPH = 0x3e, SREG = 0x3f};

	class Instruction;
	class Operand;

	struct RegisterPair;
	struct Y;
	struct Z;

	using Opcode = std::uint32_t;

	bool IsEmpty (const Operand&);
	bool IsRegisterPair (Register, Register);
	bool IsValid (const Instruction&);

	auto GetSize (const Instruction&) -> std::size_t;

	std::istream& operator >> (std::istream&, Instruction&);
	std::istream& operator >> (std::istream&, Operand&);
	std::istream& operator >> (std::istream&, Register&);
	std::ostream& operator << (std::ostream&, const Instruction&);
	std::ostream& operator << (std::ostream&, const Operand&);
	std::ostream& operator << (std::ostream&, Register);
}

namespace ECS::Object
{
	struct Patch;
}

class ECS::AVR::Operand
{
public:
	enum Type {
		#define TYPE(type, bits) type,
		#include "avr.def"
	};

	Operand (Type);
	Operand (signed);
	Operand (unsigned);
	Operand (Register);
	Operand () = default;

protected:
	Type type = None;

	union
	{
		signed simm;
		unsigned imm;
		Register register_;
	};

private:
	using Value = std::uint32_t;

	Operand (Type, Value);

	void Convert (Type);
	Value GetValue () const;
	bool IsCompatibleWith (Type) const;

	static const unsigned char bits[];

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

struct ECS::AVR::RegisterPair : Operand
{
	explicit RegisterPair (Register);
};

struct ECS::AVR::Y : Operand
{
	explicit Y (unsigned);
};

struct ECS::AVR::Z : Operand
{
	explicit Z (unsigned);
};

class ECS::AVR::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "avr.def"
		Count,
	};

	Instruction () = default;
	explicit Instruction (Span<const Byte>);
	Instruction (Mnemonic, const Operand& = {}, const Operand& = {});

	void Emit (Span<Byte>) const;
	void Adjust (Object::Patch&) const;

private:
	struct Entry;

	const Entry* entry = nullptr;
	Operand operand1, operand2;

	static const Entry table[];
	static const char*const mnemonics[];
	static const Lookup<Entry, Mnemonic> first, last;

	friend bool IsValid (const Instruction&);
	friend std::size_t GetSize (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::AVR
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "avr.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::AVR::Instruction::Mnemonic>
struct ECS::AVR::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {});
};

inline bool ECS::AVR::IsEmpty (const Operand& operand)
{
	return operand.type == Operand::None;
}

inline bool ECS::AVR::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::AVR::Instruction::Mnemonic m>
inline ECS::AVR::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2) :
	Instruction {m, op1, op2}
{
}

#endif // ECS_AVR_HEADER_INCLUDED

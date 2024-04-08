// OpenRISC 1000 instruction set representation
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

#ifndef ECS_OR1K_HEADER_INCLUDED
#define ECS_OR1K_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::OR1K
{
	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
		R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31,
	};

	class Instruction;
	class Operand;

	using Immediate = std::int32_t;
	using Opcode = std::uint32_t;

	bool IsEmpty (const Operand&);
	bool IsValid (const Instruction&);

	auto GetRegister (const Operand&) -> Register;

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

class ECS::OR1K::Operand
{
public:
	Operand () = default;
	Operand (OR1K::Register);
	Operand (OR1K::Immediate);
	Operand (OR1K::Immediate, OR1K::Register);

private:
	enum Model {Empty, Immediate, Register, Memory};

	enum Type {Void,
		#define TYPE(type) type,
		#include "or1k.def"
	};

	Model model = Empty;
	OR1K::Immediate immediate;
	OR1K::Register register_;

	void Decode (Opcode, Type);
	Opcode Encode (Type) const;
	bool IsCompatibleWith (Type) const;

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend OR1K::Register GetRegister (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::OR1K::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "or1k.def"
		Count,
	};

	Instruction () = default;
	explicit Instruction (Span<const Byte>);
	Instruction (Mnemonic, const Operand& = {}, const Operand& = {}, const Operand& = {});

	void Emit (Span<Byte>) const;
	void Adjust (Object::Patch&) const;

private:
	enum class Class {
		#define CLASS(class) class,
		#include "or1k.def"
	};

	struct Entry;

	const Entry* entry = nullptr;
	Operand operand1, operand2, operand3;

	static const Entry table[];
	static const char*const mnemonics[];
	static const Lookup<Entry, Mnemonic> lookup;

	friend bool IsValid (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::OR1K
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "or1k.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::OR1K::Instruction::Mnemonic>
struct ECS::OR1K::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::OR1K::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::OR1K::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::OR1K::Instruction::Mnemonic m>
inline ECS::OR1K::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2, const Operand& op3) :
	Instruction {m, op1, op2, op3}
{
}

#endif // ECS_OR1K_HEADER_INCLUDED

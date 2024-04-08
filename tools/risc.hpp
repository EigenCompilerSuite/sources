// RISC instruction set representation
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

#ifndef ECS_RISC_HEADER_INCLUDED
#define ECS_RISC_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::RISC
{
	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7,
		R8, R9, R10, R11, R12, R13, R14, R15,
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

class ECS::RISC::Operand
{
public:
	Operand () = default;
	Operand (RISC::Register);
	Operand (RISC::Immediate);

private:
	enum Model {Empty, Immediate, Register};

	enum Type {Void,
		#define TYPE(type) type,
		#include "risc.def"
	};

	Model model = Empty;

	union
	{
		RISC::Immediate immediate;
		RISC::Register register_;
	};

	Opcode Encode (Type) const;
	void Decode (Opcode, Type);
	bool IsCompatibleWith (Type) const;

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend RISC::Register GetRegister (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::RISC::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "risc.def"
		Count,
	};

	Instruction () = default;
	explicit Instruction (Span<const Byte>);
	Instruction (Mnemonic, const Operand& = {}, const Operand& = {}, const Operand& = {});

	void Emit (Span<Byte>) const;
	void Adjust (Object::Patch&) const;

private:
	struct Entry;

	const Entry* entry = nullptr;
	Operand operand1, operand2, operand3;

	static const Entry table[];
	static const char*const mnemonics[];
	static const Lookup<Entry, Mnemonic> first, last;

	friend bool IsValid (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::RISC
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "risc.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::RISC::Instruction::Mnemonic>
struct ECS::RISC::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::RISC::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::RISC::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::RISC::Instruction::Mnemonic m>
inline ECS::RISC::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2, const Operand& op3) :
	Instruction {m, op1, op2, op3}
{
}

#endif // ECS_RISC_HEADER_INCLUDED

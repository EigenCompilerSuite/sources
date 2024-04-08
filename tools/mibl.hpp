// MicroBlaze instruction set representation
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

#ifndef ECS_MICROBLAZE_HEADER_INCLUDED
#define ECS_MICROBLAZE_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::MicroBlaze
{
	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
		R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31,
	};

	enum Interface
	{
		FSL0, FSL1, FSL2, FSL3, FSL4, FSL5, FSL6, FSL7, FSL8, FSL9, FSL10, FSL11, FSL12, FSL13, FSL14, FSL15,
	};

	enum SpecialRegister {
		#define SREG(reg, name, number) reg = number,
		#include "mibl.def"
	};

	class Instruction;
	class Operand;

	using Immediate = std::int32_t;
	using Opcode = std::uint32_t;

	bool IsEmpty (const Operand&);
	bool IsValid (const Instruction&);

	auto GetRegister (const Operand&) -> Register;

	std::istream& operator >> (std::istream&, Instruction&);
	std::istream& operator >> (std::istream&, Interface&);
	std::istream& operator >> (std::istream&, Operand&);
	std::istream& operator >> (std::istream&, Register&);
	std::istream& operator >> (std::istream&, SpecialRegister&);
	std::ostream& operator << (std::ostream&, const Instruction&);
	std::ostream& operator << (std::ostream&, const Operand&);
	std::ostream& operator << (std::ostream&, Interface);
	std::ostream& operator << (std::ostream&, Register);
	std::ostream& operator << (std::ostream&, SpecialRegister);
}

namespace ECS::Object
{
	struct Patch;
}

class ECS::MicroBlaze::Operand
{
public:
	Operand () = default;
	Operand (MicroBlaze::Register);
	Operand (MicroBlaze::Immediate);
	Operand (MicroBlaze::Interface);
	Operand (MicroBlaze::SpecialRegister);

private:
	enum Model {Empty, Immediate, Register, Interface, SpecialRegister};

	enum Type {Void,
		#define TYPE(type) type,
		#include "mibl.def"
	};

	Model model = Empty;

	union
	{
		MicroBlaze::Immediate immediate;
		MicroBlaze::Register register_;
		MicroBlaze::Interface interface;
		MicroBlaze::SpecialRegister sregister;
	};

	void Decode (Opcode, Type);
	Opcode Encode (Type) const;
	bool IsCompatibleWith (Type) const;

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend MicroBlaze::Register GetRegister (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::MicroBlaze::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "mibl.def"
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
	static const Lookup<Entry, Mnemonic> lookup;

	friend bool IsValid (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::MicroBlaze
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "mibl.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::MicroBlaze::Instruction::Mnemonic>
struct ECS::MicroBlaze::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::MicroBlaze::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::MicroBlaze::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::MicroBlaze::Instruction::Mnemonic m>
inline ECS::MicroBlaze::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2, const Operand& op3) :
	Instruction {m, op1, op2, op3}
{
}

#endif // ECS_MICROBLAZE_HEADER_INCLUDED

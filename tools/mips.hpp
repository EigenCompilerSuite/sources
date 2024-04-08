// MIPS instruction set representation
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

#ifndef ECS_MIPS_HEADER_INCLUDED
#define ECS_MIPS_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>

namespace ECS
{
	enum class Endianness;

	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::MIPS
{
	enum Architecture : unsigned {MIPS32 = 32, MIPS64 = 64};

	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
		R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31,
		F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15,
		F16, F17, F18, F19, F20, F21, F22, F23, F24, F25, F26, F27, F28, F29, F30, F31,
	};

	class Instruction;
	class Operand;

	using Immediate = std::int32_t;
	using Opcode = std::uint32_t;

	bool IsEmpty (const Operand&);
	bool IsValid (const Instruction&, Architecture);
	bool IsValid (Immediate);

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

class ECS::MIPS::Operand
{
public:
	Operand () = default;
	Operand (MIPS::Register);
	Operand (MIPS::Immediate);

private:
	enum Type {Void,
		#define TYPE(type) type,
		#include "mips.def"
	};

	enum Model {Empty, Immediate, Register};

	Model model = Empty;

	union
	{
		MIPS::Immediate immediate;
		MIPS::Register register_;
	};

	void Decode (Opcode, Type);
	Opcode Encode (Type) const;
	bool IsCompatibleWith (Type) const;

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend MIPS::Register GetRegister (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::MIPS::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "mips.def"
		Count,
	};

	Instruction () = default;
	Instruction (Span<const Byte>, Endianness);
	Instruction (Mnemonic, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {});

	void Emit (Span<Byte>, Endianness) const;
	void Adjust (Object::Patch&, Endianness) const;

private:
	struct Entry;

	const Entry* entry = nullptr;
	Operand operand1, operand2, operand3, operand4;

	static const Entry table[];
	static const char*const mnemonics[];
	static const Lookup<Entry, Mnemonic> lookup;

	static bool IsLoadStore (Mnemonic);

	friend bool IsValid (const Instruction&, Architecture);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::istream& operator >> (std::istream&, Instruction&);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::MIPS
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "mips.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::MIPS::Instruction::Mnemonic>
struct ECS::MIPS::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::MIPS::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::MIPS::IsValid (const Immediate immediate)
{
	return immediate >= -32768 && immediate < 32768;
}

template <ECS::MIPS::Instruction::Mnemonic m>
inline ECS::MIPS::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2, const Operand& op3, const Operand& op4) :
	Instruction {m, op1, op2, op3, op4}
{
}

#endif // ECS_MIPS_HEADER_INCLUDED

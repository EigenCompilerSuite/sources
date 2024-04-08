// PowerPC instruction set representation
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

#ifndef ECS_POWERPC_HEADER_INCLUDED
#define ECS_POWERPC_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::PowerPC
{
	enum Architecture : unsigned {PPC32 = 32, PPC64 = 64};

	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
		R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31,
		FR0, FR1, FR2, FR3, FR4, FR5, FR6, FR7, FR8, FR9, FR10, FR11, FR12, FR13, FR14, FR15,
		FR16, FR17, FR18, FR19, FR20, FR21, FR22, FR23, FR24, FR25, FR26, FR27, FR28, FR29, FR30, FR31,
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

class ECS::PowerPC::Operand
{
public:
	Operand () = default;
	Operand (PowerPC::Register);
	Operand (PowerPC::Immediate);

private:
	enum Model {Empty, Immediate, Register};

	enum Type {Void,
		#define TYPE(type) type,
		#include "ppc.def"
	};

	Model model = Empty;

	union
	{
		PowerPC::Immediate immediate;
		PowerPC::Register register_;
	};

	void Decode (Opcode, Type);
	Opcode Encode (Type) const;
	bool IsCompatibleWith (Type) const;

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend PowerPC::Register GetRegister (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::PowerPC::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "ppc.def"
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
	Operand operand1, operand2, operand3, operand4, operand5;

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

namespace ECS::PowerPC
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "ppc.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::PowerPC::Instruction::Mnemonic>
struct ECS::PowerPC::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::PowerPC::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::PowerPC::IsValid (const Immediate immediate)
{
	return immediate >= -32768 && immediate < 32768;
}

template <ECS::PowerPC::Instruction::Mnemonic m>
inline ECS::PowerPC::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2, const Operand& op3, const Operand& op4, const Operand& op5) :
	Instruction {m, op1, op2, op3, op4, op5}
{
}

#endif // ECS_POWERPC_HEADER_INCLUDED

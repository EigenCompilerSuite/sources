// M68000 instruction set representation
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

#ifndef ECS_M68K_HEADER_INCLUDED
#define ECS_M68K_HEADER_INCLUDED

#include <cstddef>
#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::M68K
{
	enum Register
	{
		D0, D1, D2, D3, D4, D5, D6, D7,
		A0, A1, A2, A3, A4, A5, A6, A7,
		SP = A7, USP, PC, SR, CCR,
	};

	class Instruction;
	class Operand;

	using Immediate = std::int32_t;
	using Opcode = std::uint16_t;

	bool IsEmpty (const Operand&);
	bool IsValid (const Instruction&);

	auto GetRegister (const Operand&) -> Register;
	auto GetSize (const Instruction&) -> std::size_t;
	auto Optimize (const Instruction&) -> Instruction;

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

	using Offset = std::size_t;
}

class ECS::M68K::Operand
{
public:
	enum Size {None, Byte, Word, Long};

	Operand () = default;
	Operand (M68K::Register);
	Operand (M68K::Immediate);
	Operand (M68K::Immediate, Size);
	Operand (M68K::Immediate, M68K::Register);
	Operand (M68K::Immediate, M68K::Register, M68K::Register, Size);

	Operand operator + () const;
	Operand operator - () const;
	Operand operator [] (M68K::Immediate) const;

private:
	enum Model {Empty, Immediate, Register, Memory, Increment, Decrement, Index, Absolute};

	enum Modes {
		DirectData = 0x1, DirectAddress = 0x2, IndirectAddress = 0x4, IncrementedAddress = 0x8, DecrementedAddress = 0x10, DisplacedAddress = 0x20, DisplacedProgramCounter = 0x40, AbsoluteAddress = 0x80, ImmediateData = 0x100,
		All = DirectData | DirectAddress | IndirectAddress | IncrementedAddress | DecrementedAddress | DisplacedAddress | DisplacedProgramCounter | AbsoluteAddress | ImmediateData,
		Data = DirectData | IndirectAddress | IncrementedAddress | DecrementedAddress | DisplacedAddress | DisplacedProgramCounter | AbsoluteAddress | ImmediateData,
		Control = IndirectAddress | DisplacedAddress | DisplacedProgramCounter | AbsoluteAddress,
		Alterable = DirectData | DirectAddress | IndirectAddress | IncrementedAddress | DecrementedAddress | DisplacedAddress | AbsoluteAddress,
		DataAlterable = DirectData | IndirectAddress | IncrementedAddress | DecrementedAddress | DisplacedAddress | AbsoluteAddress,
		MemoryAlterable = IndirectAddress | IncrementedAddress | DecrementedAddress | DisplacedAddress | AbsoluteAddress,
	};

	enum Type {
		#define TYPE(type) type,
		#include "m68k.def"
	};

	using BitPosition = unsigned;

	Model model = Empty;
	M68K::Immediate immediate;
	M68K::Register register_, index;
	Size size;

	Operand (Model, M68K::Register);

	std::size_t GetSize (Type) const;
	bool IsCompatibleWith (Type) const;
	Opcode Encode (Type, Span<ECS::Byte>) const;
	bool Decode (Opcode, Type, Span<const ECS::Byte>);
	void Adjust (Object::Patch&, Object::Offset) const;

	std::size_t GetEffectiveAddressSize (Size) const;
	bool IsCompatibleWithEffectiveAddress (Size, Modes) const;
	Opcode EncodeEffectiveAddress (Size, BitPosition, BitPosition, Span<ECS::Byte>) const;
	bool DecodeEffectiveAddress (Size, Opcode, BitPosition, BitPosition, Span<const ECS::Byte>);

	static const char*const registers[];

	static void Encode (M68K::Immediate, Size, Span<ECS::Byte>);
	static bool Decode (M68K::Immediate&, Size, Span<const ECS::Byte>);

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend std::size_t GetSize (const Instruction&);
	friend Instruction Optimize (const Instruction&);
	friend M68K::Register GetRegister (const Operand&);
	friend std::istream& operator >> (std::istream&, M68K::Register&);
	friend std::ostream& operator << (std::ostream&, M68K::Register);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::M68K::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "m68k.def"
		Count,
	};

	Instruction () = default;
	explicit Instruction (Span<const Byte>);
	Instruction (Mnemonic, const Operand& = {}, const Operand& = {});
	Instruction (Mnemonic, Operand::Size, const Operand& = {}, const Operand& = {});

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
	friend Instruction Optimize (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::M68K
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "m68k.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::istream& operator >> (std::istream&, Operand::Size&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
	std::ostream& operator << (std::ostream&, Operand::Size);
}

template <ECS::M68K::Instruction::Mnemonic>
struct ECS::M68K::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {});
	explicit InstructionMnemonic (Operand::Size, const Operand& = {}, const Operand& = {});
};

inline bool ECS::M68K::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::M68K::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

inline ECS::M68K::Instruction::Instruction (const Mnemonic mnemonic, const Operand& op1, const Operand& op2) :
	Instruction {mnemonic, Operand::None, op1, op2}
{
}

template <ECS::M68K::Instruction::Mnemonic m>
inline ECS::M68K::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2) :
	Instruction {m, op1, op2}
{
}

template <ECS::M68K::Instruction::Mnemonic m>
inline ECS::M68K::InstructionMnemonic<m>::InstructionMnemonic (const Operand::Size s, const Operand& op1, const Operand& op2) :
	Instruction {m, s, op1, op2}
{
}

#endif // ECS_M68K_HEADER_INCLUDED

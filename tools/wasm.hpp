// WebAssembly instruction set representation
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

#ifndef ECS_WASM_HEADER_INCLUDED
#define ECS_WASM_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::WebAssembly
{
	enum class TypeCode {
		#define TYPECODE(name, code, value) code,
		#include "wasm.def"
	};

	class Instruction;
	class Operand;

	using Float = double;
	using Integer = std::int64_t;

	bool IsEmpty (const Operand&);
	bool IsValid (const Instruction&);

	auto GetSize (const Instruction&) -> std::size_t;

	std::istream& operator >> (std::istream&, Instruction&);
	std::istream& operator >> (std::istream&, Operand&);
	std::istream& operator >> (std::istream&, TypeCode&);
	std::ostream& operator << (std::ostream&, const Instruction&);
	std::ostream& operator << (std::ostream&, const Operand&);
	std::ostream& operator << (std::ostream&, TypeCode);
}

namespace ECS::Object
{
	struct Patch;
}

class ECS::WebAssembly::Operand
{
public:
	Operand () = default;
	Operand (WebAssembly::Float);
	Operand (WebAssembly::Integer);
	Operand (WebAssembly::TypeCode);

private:
	enum Model {Empty, Float, Integer, TypeCode};

	enum Type {Void,
		#define TYPE(type) type,
		#include "wasm.def"
	};

	using Signed = std::int64_t;
	using Unsigned = std::uint64_t;

	Model model = Empty;

	union
	{
		WebAssembly::Float float_;
		WebAssembly::Integer integer;
		WebAssembly::TypeCode typeCode;
	};

	std::size_t GetSize (Type) const;
	bool IsCompatibleWith (Type) const;
	void Encode (Type, Byte*&, Byte*) const;
	bool Decode (const Byte*&, const Byte*, Type);

	static std::size_t GetSize (Signed);
	static std::size_t GetSize (Unsigned);

	static void Encode (Byte, Byte*&, Byte*);
	static void Encode (Signed, Byte*&, Byte*);
	static void Encode (Unsigned, Byte*&, Byte*, int = 1);
	static void Encode (WebAssembly::Float, Byte*&, Byte*, std::size_t);
	static void Encode (WebAssembly::TypeCode, Byte*&, Byte*);

	static bool Decode (const Byte*&, const Byte*, Byte&);
	static bool Decode (const Byte*&, const Byte*, Signed&);
	static bool Decode (const Byte*&, const Byte*, Unsigned&);
	static bool Decode (const Byte*&, const Byte*, WebAssembly::Float&, std::size_t);
	static bool Decode (const Byte*&, const Byte*, WebAssembly::TypeCode&);

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::WebAssembly::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem) mnem,
		#include "wasm.def"
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
	std::size_t size;

	static const Entry table[];
	static const char*const mnemonics[];
	static const Lookup<Entry, Mnemonic> first, last;

	friend bool IsValid (const Instruction&);
	friend size_t GetSize (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::WebAssembly
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "wasm.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::WebAssembly::Instruction::Mnemonic>
struct ECS::WebAssembly::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::WebAssembly::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::WebAssembly::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::WebAssembly::Instruction::Mnemonic m>
inline ECS::WebAssembly::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2, const Operand& op3) :
	Instruction {m, op1, op2, op3}
{
}

#endif // ECS_WASM_HEADER_INCLUDED

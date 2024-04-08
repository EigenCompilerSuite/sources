// Intermediate code representation
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

#ifndef ECS_CODE_HEADER_INCLUDED
#define ECS_CODE_HEADER_INCLUDED

#include "object.hpp"

namespace ECS
{
	class Layout;

	using Line = std::streamoff;
}

namespace ECS::Code
{
	enum Register {R0, R1, R2, R3, RMax = 7, RRes, RSP, RFP, RLink, RVoid, GeneralRegisters = RMax + 1, UserRegisters = RRes + 1, Registers = RLink + 1};

	class Platform;

	struct Adr;
	struct Imm;
	struct Instruction;
	struct Mem;
	struct Operand;
	struct Reg;
	struct Section;
	struct Type;

	using Displacement = std::int64_t;
	using Instructions = std::vector<Instruction>;
	using Offset = Instructions::difference_type;
	using Sections = std::list<Section>;
	using Size = Instructions::size_type;
	using String = std::string;

	bool HasDefinitions (const Section&);
	bool HasRegister (const Operand&);
	bool HasType (const Operand&);
	bool IsAddress (const Operand&);
	bool IsAddress (const Type&);
	bool IsFloat (const Operand&);
	bool IsFramePointer (const Operand&);
	bool IsFull (const Operand&);
	bool IsGeneral (Register);
	bool IsImmediate (const Operand&);
	bool IsMemory (const Operand&);
	bool IsMinusOne (const Operand&);
	bool IsModifying (const Instruction&);
	bool IsNegative (const Operand&);
	bool IsOffset (const Operand&);
	bool IsOne (const Operand&);
	bool IsPointer (const Type&);
	bool IsRegister (const Operand&);
	bool IsSigned (const Operand&);
	bool IsSize (const Operand&);
	bool IsStackPointer (const Operand&);
	bool IsStrict (const Operand&);
	bool IsString (const Operand&);
	bool IsUser (Register);
	bool IsValid (const Instruction&);
	bool IsValid (const Instruction&, const Section&, const Platform&);
	bool IsValid (const Operand&);
	bool IsValid (const Operand&, const Section&, const Platform&);
	bool IsValid (const Type&);
	bool IsVoid (const Operand&);
	bool IsZero (const Operand&);

	auto GetModifiedRegister (const Instruction&) -> Register;
	auto GetModifiedRegisterType (const Instruction&) -> Type;
	auto GetRegister (const Operand&) -> Register;

	void DefineSymbol (const String&, const Operand&, std::ostream&);

	bool operator == (const Instruction&, const Instruction&);
	bool operator != (const Instruction&, const Instruction&);
	bool operator == (const Operand&, const Operand&);
	bool operator != (const Operand&, const Operand&);
	bool operator == (const Section&, const Section&);
	bool operator == (const Type&, const Type&);
	bool operator != (const Type&, const Type&);

	std::istream& operator >> (std::istream&, Instruction&);
	std::istream& operator >> (std::istream&, Operand&);
	std::istream& operator >> (std::istream&, Register&);
	std::istream& operator >> (std::istream&, Type&);
	std::ostream& operator << (std::ostream&, const Instruction&);
	std::ostream& operator << (std::ostream&, const Operand&);
	std::ostream& operator << (std::ostream&, const Type&);
	std::ostream& operator << (std::ostream&, Register);
}

struct ECS::Code::Type
{
	enum Model {Void, Signed, Unsigned, Float, Pointer, Function, Unreachable = 0};

	using Size = unsigned;

	Model model = Void;
	Size size = 0;

	constexpr Type () = default;
	constexpr Type (Model, Size);
};

namespace ECS::Code
{
	template <Type::Model, typename> struct TypeModel;

	using Float = TypeModel<Type::Float, double>;
	using Function = TypeModel<Type::Function, std::uint64_t>;
	using Pointer = TypeModel<Type::Pointer, std::uint64_t>;
	using Signed = TypeModel<Type::Signed, std::int64_t>;
	using Unsigned = TypeModel<Type::Unsigned, std::uint64_t>;
}

template <ECS::Code::Type::Model M, typename V>
struct ECS::Code::TypeModel : Type
{
	using Value = V;

	static constexpr auto Model = M;

	explicit constexpr TypeModel (Size);
};

struct ECS::Code::Operand
{
	enum Model {Void, Size, Offset, String, Type, Immediate, Register, Address, Memory, Unreachable = 0};

	enum Class {Pointer = 0, Function = 1, None = 2 << Void,
		#define CLASS(class, model1, model2, model3, model4) class = (2 << model1 | 2 << model2 | 2 << model3 | 2 << model4) & ~None,
		#include "code.def"
	};

	using Strict = bool;

	Model model = Void;
	Code::Type type;
	Code::Register register_;
	Object::Section::Name address;
	Strict strict;

	union
	{
		Code::Size size;
		Code::Offset offset;
		Signed::Value simm;
		Unsigned::Value uimm;
		Float::Value fimm;
		Pointer::Value ptrimm;
		Function::Value funimm;
		Displacement displacement;
	};

	Operand () = default;
	Operand (Code::Size);
	Operand (Code::Offset);
	Operand (const Code::String&);
	Operand (const Code::Type&);

	bool IsInstanceOf (Class) const;
	bool Uses (Code::Register) const;

protected:
	Operand (Model, const Code::Type&);
	Operand (Model, const Code::Type&, const Object::Section::Name&);
};

namespace ECS::Code
{
	template <typename TM, typename TM::Value (Operand::*)> struct ImmediateModel;

	using FImm = ImmediateModel<Float, &Operand::fimm>;
	using FunImm = ImmediateModel<Function, &Operand::funimm>;
	using PtrImm = ImmediateModel<Pointer, &Operand::ptrimm>;
	using SImm = ImmediateModel<Signed, &Operand::simm>;
	using UImm = ImmediateModel<Unsigned, &Operand::uimm>;

	Unsigned::Value Convert (const Operand&);
}

struct ECS::Code::Imm : Operand
{
	Imm (const Code::Type&, const Signed::Value);
};

template <typename TM, typename TM::Value (ECS::Code::Operand::*)>
struct ECS::Code::ImmediateModel : Operand
{
	using Value = typename TM::Value;

	ImmediateModel (const Code::Type&, Value);
};

struct ECS::Code::Reg : Operand
{
	Reg (const Code::Type&, Code::Register, Displacement = 0);
};

struct ECS::Code::Adr : Operand
{
	Adr (const Code::Type&, const Object::Section::Name&, Displacement = 0);
	Adr (const Code::Type&, const Object::Section::Name&, Code::Register, Displacement = 0);
};

struct ECS::Code::Mem : Operand
{
	Mem (const Code::Type&, Pointer::Value, Strict = false);
	Mem (const Code::Type&, Code::Register, Displacement = 0, Strict = false);
	Mem (const Code::Type&, const Operand&, Displacement = 0, Strict = false);
	Mem (const Code::Type&, const Object::Section::Name&, Displacement = 0, Strict = false);
	Mem (const Code::Type&, const Object::Section::Name&, Code::Register, Displacement = 0, Strict = false);
};

struct ECS::Code::Instruction
{
	enum Mnemonic {
		#define INSTR(name, mnem, class1, class2, class3, ...) mnem,
		#include "code.def"
		Unreachable = 0,
	};

	Mnemonic mnemonic = NOP;
	String comment; Line line = 0;
	Operand operand1, operand2, operand3;

	Instruction () = default;
	explicit Instruction (const Mnemonic m) : mnemonic {m} {}
	Instruction (const Mnemonic m, const Operand& o1) : mnemonic {m}, operand1 {o1} {}
	Instruction (const Mnemonic m, const Operand& o1, const Operand& o2) : mnemonic {m}, operand1 {o1}, operand2 {o2} {}
	Instruction (const Mnemonic m, const Operand& o1, const Operand& o2, const Operand& o3) : mnemonic {m}, operand1 {o1}, operand2 {o2}, operand3 {o3} {}

	Size Uses (Register) const;
};

namespace ECS::Code
{
	template <Instruction::Mnemonic, Size> struct InstructionMnemonic;
	template <Instruction::Mnemonic m> struct InstructionMnemonic<m, 0>;
	template <Instruction::Mnemonic m> struct InstructionMnemonic<m, 1>;
	template <Instruction::Mnemonic m> struct InstructionMnemonic<m, 2>;
	template <Instruction::Mnemonic m> struct InstructionMnemonic<m, 3>;

	#define INSTR(name, mnem, class1, class2, class3, ...) \
		using mnem = InstructionMnemonic<Instruction::mnem, (Operand::class1 != Operand::None) + (Operand::class2 != Operand::None) + (Operand::class3 != Operand::None)>;
	#include "code.def"

	bool IsAssembly (Instruction::Mnemonic);
	bool IsCode (Instruction::Mnemonic);
	bool IsData (Instruction::Mnemonic);
	bool IsType (Instruction::Mnemonic);

	bool IsBranching (Instruction::Mnemonic);
	bool IsDeclaring (Instruction::Mnemonic);
	bool IsLocated (Instruction::Mnemonic);
	bool IsLocating (Instruction::Mnemonic);
	bool IsSink (Instruction::Mnemonic);
	bool IsTyped (Instruction::Mnemonic);
	bool IsTyping (Instruction::Mnemonic);

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::Code::Instruction::Mnemonic m>
struct ECS::Code::InstructionMnemonic<m, 0> : Instruction
{
	InstructionMnemonic () : Instruction {m} {}
};

template <ECS::Code::Instruction::Mnemonic m>
struct ECS::Code::InstructionMnemonic<m, 1> : Instruction
{
	explicit InstructionMnemonic (const Operand& o1) : Instruction {m, o1} {}
};

template <ECS::Code::Instruction::Mnemonic m>
struct ECS::Code::InstructionMnemonic<m, 2> : Instruction
{
	InstructionMnemonic (const Operand& o1, const Operand& o2) : Instruction {m, o1, o2} {}
};

template <ECS::Code::Instruction::Mnemonic m>
struct ECS::Code::InstructionMnemonic<m, 3> : Instruction
{
	InstructionMnemonic (const Operand& o1, const Operand& o2, const Operand& o3) : Instruction {m, o1, o2, o3} {}
};

struct ECS::Code::Section : Object::Section
{
	String comment;
	Instructions instructions;

	using Object::Section::Section;
};

class ECS::Code::Platform
{
public:
	using HasLinkRegister = bool;
	using StackDisplacement = unsigned;

	const Signed integer;
	const Float float_;
	const Pointer pointer;
	const Function function, return_, link;
	const StackDisplacement stackDisplacement;

	explicit Platform (Layout&, HasLinkRegister = true);

	bool IsStackAligned (Size) const;
	bool IsAligned (Size, const Type&) const;
	bool IsAligned (const Section&, const Type&) const;

	Type::Size GetAlignment (const Type&) const;
	Type::Size GetStackSize (const Type&) const;
	Type::Size GetStackAlignment (const Type&) const;

private:
	Layout& layout;
};

#include <cassert>

inline bool ECS::Code::operator != (const Type& a, const Type& b)
{
	return !(a == b);
}

inline bool ECS::Code::operator != (const Operand& a, const Operand& b)
{
	return !(a == b);
}

inline bool ECS::Code::operator != (const Instruction& a, const Instruction& b)
{
	return !(a == b);
}

constexpr ECS::Code::Type::Type (const Model m, const Size s) :
	model {m}, size {s}
{
	assert (model != Void);
}

template <ECS::Code::Type::Model M, typename V>
constexpr ECS::Code::TypeModel<M, V>::TypeModel (const Size s) :
	Type {M, s}
{
}

template <typename TM, typename TM::Value (ECS::Code::Operand::*immediate)>
ECS::Code::ImmediateModel<TM, immediate>::ImmediateModel (const Code::Type& t, const Value i) :
	Operand {Immediate, t}
{
	assert (type.model == TM::Model);
	this->*immediate = i;
}

#endif // ECS_CODE_HEADER_INCLUDED

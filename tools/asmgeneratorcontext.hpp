// Generic machine code generator context
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

#ifndef ECS_ASSEMBLY_GENERATOR_CONTEXT_HEADER_INCLUDED
#define ECS_ASSEMBLY_GENERATOR_CONTEXT_HEADER_INCLUDED

#include "asmgenerator.hpp"
#include "asmlexer.hpp"
#include "debugging.hpp"
#include "utilities.hpp"

#include <ostream>

class ECS::Assembly::Generator::Context
{
public:
	void Process (const Code::Sections&);

protected:
	class Label;
	class LocalLabel;

	struct RegisterShortage final {};

	using FixupCode = std::size_t;
	using InitializeData = bool;
	using Part = std::size_t;
	using Suffix = char;
	using Types = std::vector<Code::Type>;

	std::ostream& listing;
	const Generator& generator;
	const Endianness endianness;

	Context (const Generator&, Object::Binaries&, Debugging::Information&, std::ostream&, InitializeData);

	auto AddAlias (const Code::Section::Name&) -> void;
	auto AddAlignment (Code::Section::Alignment) -> void;
	auto AddFixup (const Label&, FixupCode, Code::Size) -> void;
	auto AddLink (const Object::Section::Name&, Object::Patch&) -> void;
	auto AddSection (Code::Section::Type, const Code::Section::Name&, Code::Section::Required, Code::Section::Duplicable, Code::Section::Replaceable) -> void;
	auto Align (Code::Section::Alignment) -> void;
	auto CreateLabel () -> LocalLabel;
	auto DefineGlobal (const Code::Operand&) -> Code::Section::Name;
	auto DefineLocal (const Code::Operand&, Code::Size, Code::Size) -> Label;
	auto DisplaceStackPointer (const Code::Operand&, Code::Displacement) -> Code::Operand;
	auto GetAddress (const Code::Instruction&) const -> Code::Operand;
	auto GetBranchOffset (const Label&, Code::Offset) const -> Code::Offset;
	auto GetLabel (const Code::Offset) const -> Label;
	auto GetOffset (const Byte*) const -> Code::Offset;
	auto GetPreviousInstruction () const -> const Code::Instruction*;
	auto IsLastUseOf (Code::Register) const -> bool;
	auto Require (const Object::Section::Name&) -> void;
	auto Reserve (Code::Size) -> Span<Byte>;
	auto SetGroup (const Object::Section::Name&) ->void;

private:
	struct InstructionFixup;
	struct LocalDefinition;
	struct TypeDeclaration;

	Object::Binaries& binaries;
	Debugging::Information& information;
	const InitializeData initializeData;

	Object::Binary* binary;
	Debugging::Entry* entry;
	const Code::Section* section;
	Code::Size currentInstruction;
	std::vector<Code::Size> labels;
	Lexer::Symbol currentDirective;
	Code::Sections globalDefinitions;
	std::vector<Debugging::Type*> types;
	std::vector<InstructionFixup> fixups;
	Debugging::Location* location = nullptr;
	std::vector<Debugging::Symbol*> symbols;
	Code::Size uses[Code::UserRegisters] {};
	Code::Size fixes[Code::UserRegisters] {};
	std::vector<TypeDeclaration> declarations;
	Code::Type registerTypes[Code::UserRegisters];
	std::list<LocalDefinition> pendingDefinitions, appliedDefinitions;

	void EmitError [[noreturn]] (const Message&) const;

	void Process (const Code::Section&);
	void Initialize (const Code::Section&);

	void Define (const Code::Operand&);
	void Define (Code::Unsigned::Value, const Code::Type::Size);
	void Define (const Object::Section::Name&, Object::Patch::Mode, const Object::Patch::Displacement, Object::Patch::Scale, const Code::Type::Size);

	void Fix (Code::Register);
	void Unfix (Code::Register);
	void Check (const Code::Operand&) const;
	void AcquireRegister (const Code::Instruction&);
	void Acquire (Code::Register, const Types&, Code::Size);
	void Acquire (Code::Register, const Code::Type&, const Code::Instruction&);
	void ReleaseRegisters (const Code::Instruction&);
	void Release (Code::Register, Code::Size);

	void Apply (LocalDefinition&);
	void Emit (const Code::Instruction&);
	void List (const Code::Instruction&);
	void Encode (const Code::Instruction&);
	Code::Size Push (const Code::Operand&);
	void Assemble (const Code::Instruction&);
	void ApplyLocalDefinitions (Code::Offset);
	void Assemble (const Source&, Line, const Code::String&);
	void AssembleInline (const Source&, Line, const Code::String&);
	void AddType (Code::Register, const Code::Operand&, Types&) const;

	void AddEntry (Debugging::Entry::Model);
	void AddTypeableEntry (Debugging::Entry::Model);

	void Declare (Debugging::Symbol&&);
	void Undeclare (Debugging::Symbol&);
	void Declare (Code::Offset, const Code::String&, const Code::Operand&);

	void Define (const Debugging::Symbol&, std::ostream&);
	Debugging::Name GetRegisterName (const Code::Operand&);
	const Code::Instruction& GetDeclaration (const Debugging::Symbol&) const;
	void DefineRegister (const Code::Operand&, const Debugging::Name&, std::ostream&);
	void DefineRegister (const Code::Operand&, const Debugging::Name&, Part, std::ostream&);

	Debugging::Index Insert (const Source&);
	Debugging::Type& Declare (Debugging::Type&&);

	virtual auto Acquire (Code::Register, const Types&) -> void {}
	virtual auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void {}
	virtual auto Generate (const Code::Instruction&) -> void = 0;
	virtual auto GetAddress (const Code::Operand& operand) const -> Code::Section::Name {return operand.address;}
	virtual auto GetPatchMode (const Code::Type&) const -> Object::Patch::Mode {return Object::Patch::Absolute;}
	virtual auto GetPatchScale (const Code::Type&) const -> Object::Patch::Scale {return 0;}
	virtual auto GetRegisterParts (const Code::Operand&) const -> Part {return 1;}
	virtual auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix {return 0;}
	virtual auto IsSupported (const Code::Instruction&) const -> bool {return true;}
	virtual auto Postprocess (const Code::Section&) -> void {}
	virtual auto Preprocess (const Code::Instruction&) -> void {}
	virtual auto Preprocess (const Code::Section&) -> void {}
	virtual auto Release (Code::Register) -> void {}
	virtual auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& = 0;

	static Debugging::Type GetType (const Code::Operand&);
	static Debugging::Value GetValue (const Code::Operand&);

	static std::ostream& WriteValue (std::ostream&, const Debugging::Value&);

	friend std::ostream& operator << (std::ostream&, const Label&);
};

class ECS::Assembly::Generator::Context::Label
{
public:
	Label () = default;

protected:
	Code::Size index = 0;

	explicit Label (Code::Size);

	friend class Context;
	friend std::ostream& operator << (std::ostream& stream, const Label& label) {return stream << '.' << label.index;}
};

class ECS::Assembly::Generator::Context::LocalLabel : public Label
{
public:
	~LocalLabel ();
	LocalLabel (LocalLabel&&) noexcept;

	void operator () ();

private:
	Context* context = nullptr;

	LocalLabel (Context&, Code::Size);

	friend class Context;
};

struct ECS::Assembly::Generator::Context::LocalDefinition
{
	Code::Size limit;
	LocalLabel label;
	Code::Operand value;

	LocalDefinition (Code::Size, Context&, const Code::Operand&);
};

struct ECS::Assembly::Generator::Context::InstructionFixup
{
	Code::Size offset;
	Code::Size index;
	FixupCode code;
	Code::Size size;

	InstructionFixup (Code::Size, Code::Size, FixupCode, Code::Size);
};

struct ECS::Assembly::Generator::Context::TypeDeclaration
{
	Code::Size extent;
	Debugging::Type* type;

	TypeDeclaration (Code::Size, Debugging::Type&);
};

#endif // ECS_ASSEMBLY_GENERATOR_CONTEXT_HEADER_INCLUDED

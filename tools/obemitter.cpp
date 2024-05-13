// Oberon intermediate code emitter
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

#include "cdemittercontext.hpp"
#include "error.hpp"
#include "obemitter.hpp"
#include "oberon.hpp"
#include "strdiagnostics.hpp"

using namespace ECS;
using namespace Code;
using namespace Oberon;

struct Oberon::Emitter::Cache
{
	std::vector<const Module*> modules;
	std::vector<String> strings;
	std::vector<const Declaration*> types;
};

using Context = class Oberon::Emitter::Context : Code::Emitter::Context
{
public:
	Context (const Oberon::Emitter&, const Module&, Cache&, Sections&);

	void Emit ();

private:
	enum TrapNumber {Assert, Case, Index, TypeGuard, With};
	enum DescriptorLayout {ProcedureTableOffset = 0, RecordSizeOffset = 0, ExtensionLevelOffset = 1, TypeTableOffset = 2};

	struct Array {SmartOperand address, length;};
	struct Complex {SmartOperand real, imag;};
	struct Record {SmartOperand address, descriptor;};
	struct TypeBound {SmartOperand procedure; Record record;};

	using ProcedureTable = std::vector<const Declaration*>;
	using TypeTable = std::vector<const Type*>;

	const Oberon::Emitter& emitter;
	const Module& module;
	const Section::Name name;
	Cache& cache;

	Label loop, epilogue, end;
	const Scope* currentScope;

	void EmitFatalError [[noreturn]] (const Module&, const Position&, const Message&) const;

	using Code::Emitter::Context::Comment;
	template <typename... Values> void Comment (const Position&, const Values&...);

	using Code::Emitter::Context::Begin;
	void Begin (const Declaration&);

	void Emit (const Body&);
	void Emit (const Body&, const Scope&);
	void Emit (const Declaration&);
	void Emit (const Declarations&);
	void Emit (const Elsif&, const Label&);
	void Emit (const Expression&, const Operand&, const Label&);
	void Emit (const Guard&, const Label&, bool);
	void Emit (const Statement&);
	void Emit (const Statements&);
	void Emit (const Type&);
	void EmitTypeDescriptor (const Type&);

	void Initialize (const Declaration&);
	void Initialize (const Module&);
	void Initialize (const Operand&, Size&, Size&);
	void Initialize (const Scope&);
	void Initialize (const Type&, Size&, Size&);

	using Code::Emitter::Context::DeclareRecord;
	void Declare (const Declaration&);
	void Declare (const Declarations&);
	void Declare (const Signature&);
	void Declare (const Type&);
	void DeclareCanonical (const Declaration&);
	void DeclareCanonical (const Type&);
	void DeclareParameter (const Declaration&);
	void DeclareRecord (const Type&);

	Operand Evaluate (const Value&, const Expression&);
	Operand Designate (const Value&, const Expression&);
	SmartOperand Evaluate (const Expression&, Hint = RVoid);
	SmartOperand Designate (const Expression&);
	SmartOperand Designate (const Declaration&);
	SmartOperand DesignateObject (const Declaration&);
	SmartOperand DesignateExternal (const Declaration&);
	SmartOperand DesignateArgument (const Expression&, Size);
	SmartOperand EvaluateArgument (const Expression&, Size, Hint = RVoid);
	SmartOperand EvaluateArgument (const Expression&, Size, const Operand&);
	SmartOperand EvaluateCall (const Expression&, const Operand&);
	SmartOperand EvaluateElement (const Expression&, const Code::Type&, Hint);
	SmartOperand EvaluateRange (const Expression&, const Code::Type&, Hint);
	SmartOperand EvaluateBoolean (const Expression&, Hint);
	SmartOperand EvaluatePointer (const Expression&, Hint = RVoid);
	Complex EvaluateComplex (const Expression&);
	Complex EvaluateComplex (const Value&, const Expression&);
	Array DesignateArray (const Expression&);
	Array DesignateArray (const Declaration&);
	Array DesignateArray (const Value&, const Expression&);
	Array DesignateIndex (const Expression&);
	Array DereferenceArray (const Expression&);
	Record DesignateRecord (const Expression&);
	Record DesignateRecord (const Declaration&);
	Record DereferenceRecord (const Expression&);
	SmartOperand EvaluateDescriptor (const Expression&);
	SmartOperand DereferenceDescriptor (const Expression&);
	SmartOperand DereferenceDescriptor (const Operand&, const Type&);
	SmartOperand DesignateDescriptor (const Declaration&);
	TypeBound EvaluateTypeBound (const Expression&);
	Operand Evaluate (const Type&);

	SmartOperand CallAbs (const Complex&);
	#define FUNCTION(scope, procedure, name) SmartOperand Call##procedure (const Expression&, Hint);
	#define PROCEDURE(scope, procedure, name) void Call##procedure (const Expression&);
	#include "oberon.def"

	using Code::Emitter::Context::Push;
	Size Push (const Expression&, const Declaration&);
	void PushArray (const Expression&, const Declaration&);
	void PushByteArray (const Expression&);
	void PushLength (const Operand&, const Type&, const Type&);
	void PushRecord (const Expression&, const Declaration&);
	void PushScalar (const Expression&, const Declaration&);
	void PushStructured (const Expression&, const Declaration&);

	void Assign (const Expression&, const Expression&);
	void AssignComplex (SmartOperand&&, const Expression&);
	void AssignRecord (const Expression&, const Expression&);
	void AssignStructured (SmartOperand&&, const Expression&, const Type&);
	void AssignVariablePointer (SmartOperand&&, const Expression&, const Type&);

	void CopyOpenArray (const Declaration&);
	SmartOperand GetArraySize (const Type&, const Operand&);

	void BranchConditional (const Expression&, bool, const Label&);
	void BranchConditional (const Operand&, const Type&, bool, const Label&);

	void Compare (const Complex&, const Complex&, const bool, const Label&);
	void CompareString (void (Context::*) (const Label&, const Operand&, const Operand&), const Expression&, const Expression&, const Label&);

	Section::Name GetName (const Declaration&) const;
	Section::Name GetName (const Module&) const;
	Section::Name GetName (const QualifiedIdentifier&) const;
	Section::Name GetName (const Scope&) const;
	Section::Name GetName (const Type&) const;

	Section::Name GetCanonicalName (const Declaration&) const;
	Section::Name GetCanonicalName (const Type&) const;

	Code::Type GetType (const Type&) const;
	Code::Type::Size GetSize (const Operand&) const;

	SmartOperand GetFramePointer (const Scope&);
	SmartOperand GetResult (const Scope&);

	void Populate (TypeTable&, ProcedureTable&, const Type&);
};

Oberon::Emitter::Emitter (Diagnostics& d, StringPool& sp, Charset& c, Code::Platform& cp, Platform& p) :
	Code::Emitter {d, sp, c, cp}, platform {p}
{
}

void Oberon::Emitter::Emit (const Module& module, Sections& sections) const
{
	if (IsGeneric (module) && !IsParameterized (module)) return;
	Cache cache; Emit (module, cache, sections);
}

void Oberon::Emitter::Emit (const Module& module, Cache& cache, Sections& sections) const
{
	for (auto& declaration: module.declarations) if (IsImport (declaration) && IsModule (*declaration.import.scope))
		if (const auto module = declaration.import.scope->module) if (IsParameterized (*module) && InsertUnique (module, cache.modules)) Emit (*module, cache, sections);
	Context {*this, module, cache, sections}.Emit ();
}

Context::Context (const Oberon::Emitter& e, const Module& m, Cache& c, Sections& s) :
	Code::Emitter::Context {e, s}, emitter {e}, module {m}, name {GetName (module)}, cache {c}
{
}

void Context::EmitFatalError (const Module& module, const Position& position, const Message& message) const
{
	emitter.diagnostics.Emit (Diagnostics::FatalError, module.source, position, message); throw Error {};
}

template <typename... Values>
void Context::Comment (const Position& position, const Values&... values)
{
	if (IsParameterized (module)) Comment (module.source, position, values...); else Code::Emitter::Context::Comment (position, values...);
}

Section::Name Context::GetName (const Declaration& declaration) const
{
	if (IsGlobal (*declaration.scope) && !declaration.scope->identifier) return declaration.name.string;
	return GetName (*declaration.scope) + '.' + declaration.name.string;
}

Section::Name Context::GetName (const Scope& scope) const
{
	switch (scope.model)
	{
	case Scope::Global:
		assert (scope.identifier);
		return GetName (*scope.identifier);

	case Scope::Module:
		return scope.module == &module ? name : GetName (*scope.module);

	case Scope::Procedure:
		return GetName (*scope.procedure);

	case Scope::Record:
		return GetName (*scope.record);

	default:
		assert (Scope::Unreachable);
	}
}

Section::Name Context::GetName (const QualifiedIdentifier& identifier) const
{
	assert (identifier.name); return identifier.parent ? GetName (*identifier.parent) + ':' + identifier.name->string : identifier.name->string;
}

Section::Name Context::GetName (const Module& module) const
{
	if (!IsParameterized (module)) return GetName (module.identifier);
	std::ostringstream stream; stream << GetName (module.identifier) << Lexer::LeftParen;
	for (auto& expression: *module.expressions) if (IsFirst (expression, *module.expressions) ? stream : stream << Lexer::Comma, IsType (expression))
		stream << GetCanonicalName (*expression.type); else stream << expression.value;
	stream << Lexer::RightParen; return stream.str ();
}

Section::Name Context::GetName (const Type& type) const
{
	if (IsAlias (type)) return GetName (*type.identifier->declaration); assert (IsRecord (type));
	if (type.record.declaration) return GetName (*type.record.declaration);
	return name + "._record" + std::to_string (module.GetIndex (type));
}

Section::Name Context::GetCanonicalName (const Declaration& declaration) const
{
	assert (IsType (declaration));
	return IsAlias (*declaration.type) && declaration.type->identifier->declaration != &declaration ? GetCanonicalName (*declaration.type) : GetName (declaration);
}

Section::Name Context::GetCanonicalName (const Type& type) const
{
	assert (IsAlias (type)); return GetCanonicalName (*type.identifier->declaration);
}

Code::Type::Size Context::GetSize (const Operand& operand) const
{
	return IsMemory (operand) && !IsUser (operand.register_) ? platform.GetStackSize (operand.type) : operand.type.size;
}

Code::Type Context::GetType (const Type& type) const
{
	switch (type.model)
	{
	case Type::Boolean:
	case Type::Character:
	case Type::Unsigned:
	case Type::Set:
	case Type::Byte:
		return Code::Unsigned (type.basic.size);
	case Type::Signed:
		return Code::Signed (type.signed_.size);
	case Type::Real:
	case Type::Complex:
		return Code::Float (type.basic.size);
	case Type::Any:
	case Type::Pointer:
		return platform.pointer;
	case Type::Procedure:
		return platform.function;
	default:
		assert (Type::Unreachable);
	}
}

void Context::Emit ()
{
	Emit (module.parameters); Emit (module.declarations);
	for (auto& type: module.anonymousTypes) Emit (*type);
	if (module.body) Emit (*module.body);
}

void Context::Emit (const Body& body)
{
	assert (&body == module.body); Comment (body.begin.position, Lexer::Begin);
	Begin (Section::Code, IsTerminating (body) ? name + "._body" : Section::EntryPoint, 0, false, IsGeneric (module));
	Locate (module.source, body.begin.position); DeclareVoid (); Emit (body, *module.scope); if (IsTerminating (body)) Initialize (module); else InsertUnique (nullptr, cache.modules);
	if (InsertUnique (nullptr, cache.modules)) Begin (Section::Code, Section::EntryPoint, 0, false, true, true), Push (SImm {platform.integer, 0}), Call (Adr {platform.function, "_Exit"}, 0);
}

void Context::Emit (const Declarations& declarations)
{
	for (auto& declaration: declarations) Emit (declaration);
}

void Context::Emit (const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		if (IsModule (*declaration.import.scope)) Comment (declaration.position, declaration), Initialize (declaration);
		break;

	case Declaration::Constant:
		break;

	case Declaration::Type:
		if (IsRecord (declaration)) return Emit (*declaration.type); if (!InsertUnique (&declaration, cache.types)) break;
		Comment (declaration.position, declaration); Begin (Section::TypeSection, GetName (declaration), 0, false, IsGeneric (module)); Locate (module.source, declaration.name.position);
		if (IsGenericParameter (declaration)) DeclareCanonical (*declaration.type); else Declare (*declaration.type);
		break;

	case Declaration::Variable:
	{
		if (IsProcedure (*declaration.scope) || IsForward (declaration)) break;
		Comment (declaration.position, declaration); Begin (declaration); Locate (module.source, declaration.name.position); Declare (*declaration.variable.type);
		Size size = 0, offset = 0; Initialize (*declaration.variable.type, size, offset); Reserve (size - offset);
		break;
	}

	case Declaration::Procedure:
		if (IsAbstract (declaration) || IsForward (declaration)) break;
		Comment (declaration.position, declaration); Begin (declaration); Locate (module.source, declaration.position);
		if (declaration.procedure.signature.result) Declare (*declaration.procedure.signature.result); else DeclareVoid ();
		if (declaration.procedure.body) Emit (*declaration.procedure.body, *declaration.procedure.signature.scope);
		else if (platform.link.size) Jump (emitter.linkRegister); else Return ();
		if (declaration.procedure.declarations && declaration.procedure.body) Emit (*declaration.procedure.declarations);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::Begin (const Declaration& declaration)
{
	assert (IsStorage (declaration));
	auto& section = Begin (IsProcedure (declaration) ? Section::Code : Section::Data, GetName (declaration), IsVariable (declaration) ? emitter.platform.GetAlignment (declaration) : 0, false, IsGeneric (module));
	if (IsExternal (declaration)) if (IsString (declaration.storage.external->value)) Alias (*declaration.storage.external->value.string); else section.fixed = true, section.origin = declaration.storage.external->value.unsigned_;
}

void Context::Initialize (const Declaration& declaration)
{
	assert (IsImport (declaration)); assert (IsModule (*declaration.import.scope));
	const auto& module = *declaration.import.scope->module; if (!InsertUnique (&module, cache.modules)) return;
	for (auto& declaration: module.declarations) if (IsImport (declaration) && IsModule (*declaration.import.scope)) Initialize (declaration);
	if (module.body && IsTerminating (*module.body)) Initialize (module);
}

void Context::Initialize (const Module& module)
{
	assert (module.body); assert (IsTerminating (*module.body)); const auto name = GetName (*module.scope);
	Begin (Section::InitCode, name + "._call", 0, true, true); Call (Adr {platform.function, name + "._body"}, 0);
}

void Context::Initialize (const Scope& scope)
{
	assert (IsProcedure (scope)); const auto& procedure = scope.procedure->procedure;
	if (NeedsInitialization (scope)) Fill (Subtract (emitter.framePointer, scope.size - platform.stackDisplacement), PtrImm {platform.pointer, scope.size / platform.pointer.size}, PtrImm {platform.pointer, 0});
	if (procedure.result && NeedsInitialization (*procedure.result->variable.type)) Fill (Designate (*procedure.result), PtrImm {platform.pointer, emitter.platform.GetSize (*procedure.result) / platform.pointer.size}, PtrImm {platform.pointer, 0});
	if (procedure.signature.receiver) Declare (*procedure.signature.receiver);
	if (procedure.signature.parameters) Declare (*procedure.signature.parameters);
	if (procedure.declarations) Declare (*procedure.declarations);
}

void Context::Initialize (const Type& type, Size& size, Size& offset)
{
	switch (type.model)
	{
	case Type::Complex:
		Initialize (Imm {GetType (type), 0}, size, offset);
		Initialize (Imm {GetType (type), 0}, size, offset);
		break;

	case Type::Array:
		assert (!IsOpenArray (type));
		for (Signed index = 0; index != type.array.length->value.signed_; ++index) Initialize (*type.array.elementType, size, offset);
		break;

	case Type::Record:
		if (type.record.baseType) Initialize (*type.record.baseType, size, offset);
		if (type.record.declarations) for (auto& declaration: *type.record.declarations) Initialize (*declaration.variable.type, size, offset);
		break;

	case Type::Pointer:
		Initialize (PtrImm {platform.pointer, 0}, size, offset); if (!IsVariablePointer (type)) break;
		for (auto baseType = type.pointer.baseType; IsOpenArray (*baseType); baseType = baseType->array.elementType) Initialize (SImm {GetType (emitter.platform.globalLengthType), 0}, size, offset);
		if (HasDynamicType (*type.pointer.baseType)) Initialize (PtrImm {platform.pointer, 0}, size, offset);
		break;

	default:
		assert (IsScalar (type));
		Initialize (Imm {GetType (type), 0}, size, offset);
	}
}

void Context::Initialize (const Operand& operand, Size& size, Size& offset)
{
	size = Align (size, Size (platform.GetAlignment (operand.type))); Reserve (size - offset); Define (operand); offset = size += operand.type.size;
}

void Context::Emit (const Body& body, const Scope& scope)
{
	Comment ("function prologue");
	if (platform.link.size && (IsProcedure (scope) || IsTerminating (body))) Push (emitter.linkRegister);
	epilogue = CreateLabel (); end = CreateLabel (); currentScope = &scope;
	if (scope.size || IsProcedure (scope)) Enter (scope.size);
	if (IsProcedure (scope)) Initialize (scope);
	Emit (body.statements); epilogue ();
	if (!IsTerminating (body)) return end ();
	Comment ("function epilogue");
	if (IsReachable (body)) Break (module.source, body.end.position);
	if (scope.size || IsProcedure (scope)) Leave ();
	end (); Return ();
}

void Context::Emit (const Type& type)
{
	assert (IsRecord (type)); assert (!IsAlias (type)); if (!NeedsTypeDescriptor (type) && IsAnonymous (type)) return;
	if (type.record.declaration) Comment (type.record.declaration->position, *type.record.declaration); else Comment (type.position, type); if (NeedsTypeDescriptor (type)) EmitTypeDescriptor (type);
	if (!IsAnonymous (type)) Begin (Section::TypeSection, GetName (type), 0, false, IsGeneric (module)), Locate (module.source, type.record.declaration ? type.record.declaration->name.position : type.position), DeclareRecord (type);
}

void Context::EmitTypeDescriptor (const Type& type)
{
	assert (IsRecord (type)); assert (!IsAlias (type)); assert (NeedsTypeDescriptor (type)); const auto name = GetName (type);
	if (IsAbstract (type)) return Begin (Section::Const, name, 0, false, IsGeneric (module)), Reserve (1);
	Begin (Section::Const, type.record.procedures ? name + "._descriptor" : name, std::max (platform.GetAlignment (platform.pointer), platform.GetAlignment (platform.function)), false, IsGeneric (module));
	TypeTable typeTable (type.record.extensionLevel + 1); ProcedureTable procedureTable (type.record.procedures); Populate (typeTable, procedureTable, type);
	Comment ("procedure table"); for (auto procedure: Reverse {procedureTable}) assert (procedure), Define (Designate (*procedure));
	if (type.record.procedures) Alias (name);
	Comment ("record size"); Define (SImm (GetType (emitter.platform.globalLengthType), emitter.platform.GetSize (type)));
	Comment ("extension level"); Define (SImm (GetType (emitter.platform.globalLengthType), type.record.extensionLevel));
	Comment ("type table"); for (auto type: typeTable) Define (type ? Evaluate (*type) : PtrImm {platform.pointer, 0});
}

void Context::Populate (TypeTable& typeTable, ProcedureTable& procedureTable, const Type& type)
{
	assert (IsRecord (type)); assert (!IsAlias (type));
	if (type.record.baseType) Populate (typeTable, procedureTable, *type.record.baseType->record.declaration->type);
	for (auto& object: type.record.scope->objects) if (IsTypeBound (*object.second) && !IsAbstract (*object.second) && (!IsFinal (*object.second) || object.second->procedure.definition)) procedureTable[object.second->procedure.index - 1] = object.second;
	typeTable[type.record.extensionLevel] = &type;
}

void Context::Declare (const Declarations& declarations)
{
	for (auto& declaration: declarations) if (!IsType (declaration)) Declare (declaration);
}

void Context::Declare (const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
	case Declaration::Procedure:
		break;

	case Declaration::Constant:
		if (!IsBasic (*declaration.constant.expression->type)) break; Comment (declaration.position, declaration);
		DeclareSymbol (end, declaration.name.string, Evaluate (*declaration.constant.expression));
		Locate (module.source, declaration.name.position); Declare (*declaration.constant.expression->type);
		break;

	case Declaration::Type:
	{
		const auto name = GetName (declaration); DeclareType (name); if (!IsGlobal (*declaration.scope) || !InsertUnique (&declaration, cache.types)) break;
		const RestoreState restore {*this}; Begin (Section::TypeSection, name, 0, false, IsGeneric (module)); auto end = CreateLabel ();
		if (IsBoolean (*declaration.type)) DeclareEnumeration (end), DeclareType (GetType (*declaration.type)), DeclareEnumerator (GetName (emitter.platform.globalFalse), Evaluate (emitter.platform.globalFalseExpression)), DeclareEnumerator (GetName (emitter.platform.globalTrue), Evaluate (emitter.platform.globalTrueExpression));
		else if (IsComplex (*declaration.type)) DeclareRecord (end, emitter.platform.GetSize (*declaration.type)), DeclareField ("real", 0, SImm {platform.integer, 0}), Declare (emitter.platform.GetReal (declaration)), DeclareField ("imag", GetType (*declaration.type).size, SImm {platform.integer, 0}), Declare (emitter.platform.GetReal (declaration));
		else if (IsAny (*declaration.type)) DeclarePointer (), DeclareVoid ();
		else if (IsValid (*declaration.type)) DeclareType (GetType (*declaration.type));
		else DeclareVoid (); end ();
		break;
	}

	case Declaration::Variable:
		if (IsModule (*declaration.scope)) break; Comment (declaration.position, declaration);
		if (IsRecord (*declaration.scope)) DeclareField (declaration.name.string, declaration.variable.offset, SImm {platform.integer, 0});
		else if (&declaration == declaration.scope->procedure->procedure.result) DeclareSymbol (end, declaration.name.string, Designate (declaration)), DeclareReference ();
		else DeclareSymbol (end, declaration.name.string, MakeMemory (platform.pointer, Designate (declaration)));
		Locate (module.source, declaration.name.position); Declare (*declaration.variable.type);
		break;

	case Declaration::Parameter:
		Comment (declaration.position, declaration);
		DeclareSymbol (end, declaration.name.string, MakeMemory (platform.pointer, DesignateObject (declaration))); Locate (module.source, declaration.name.position); DeclareParameter (declaration);
		if (IsOpenArray (*declaration.parameter.type) && !IsVariableParameter (declaration) && !IsReadOnlyParameter (declaration)) CopyOpenArray (declaration);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::DeclareParameter (const Declaration& declaration)
{
	assert (IsParameter (declaration));
	if (IsVariableParameter (declaration) || IsOpenArray (*declaration.parameter.type) || IsStructured (*declaration.parameter.type) && IsReadOnlyParameter (declaration)) DeclareReference ();
	Declare (*declaration.parameter.type);
}

void Context::Declare (const Type& type)
{
	if (IsAlias (type)) return Declare (*type.identifier->declaration);

	switch (type.model)
	{
	case Type::Array:
		DeclareArray (0, IsOpenArray (type) ? 0 : type.array.length->value.signed_);
		return Declare (*type.array.elementType);

	case Type::Record:
		return DeclareRecord (type);

	case Type::Pointer:
		return DeclarePointer (), Declare (*type.pointer.baseType);

	case Type::Procedure:
		return DeclarePointer (), Declare (type.procedure.signature);

	default:
		assert (Type::Unreachable);
	}
}

void Context::DeclareRecord (const Type& type)
{
	assert (IsRecord (type)); auto extent = CreateLabel (); DeclareRecord (extent, emitter.platform.GetSize (type));
	if (type.record.baseType) Comment (type.record.baseType->position, type), DeclareField ({}, 0, SImm {platform.integer, 0}), Locate (module.source, type.record.baseType->position), Declare (*type.record.baseType);
	if (type.record.declarations) for (auto& declaration: *type.record.declarations) Declare (declaration); extent ();
}

void Context::Declare (const Signature& signature)
{
	auto extent = CreateLabel (); DeclareFunction (extent);
	if (signature.result) Declare (*signature.result); else DeclareVoid ();
	if (signature.receiver) DeclareParameter (*signature.receiver);
	if (signature.parameters) for (auto& declaration: *signature.parameters) DeclareParameter (declaration);
	extent ();
}

void Context::DeclareCanonical (const Declaration& declaration)
{
	assert (IsType (declaration));
	if (IsAlias (*declaration.type) && declaration.type->identifier->declaration != &declaration) DeclareCanonical (*declaration.type); else Declare (*declaration.type);
}

void Context::DeclareCanonical (const Type& type)
{
	assert (IsAlias (type)); DeclareCanonical (*type.identifier->declaration);
}

Context::SmartOperand Context::EvaluateBoolean (const Expression& expression, const Hint hint)
{
	assert (!IsConstant (expression));
	auto skip = CreateLabel (); BranchConditional (expression, false, skip);
	return Set (skip, Evaluate (true, expression), Evaluate (false, expression), hint);
}

void Context::BranchConditional (const Expression& expression, const bool value, const Label& label)
{
	assert (IsBoolean (*expression.type));
	if (IsConstant (expression)) if (expression.value.boolean == value) return Branch (label); else return;

	switch (expression.model)
	{
	case Expression::Call:
	case Expression::Index:
	case Expression::Selector:
	case Expression::Identifier:
		return (this->*equal[!value]) (label, Evaluate (expression), Evaluate (false, expression));

	case Expression::Unary:
		switch (expression.unary.operator_)
		{
		case Lexer::Not:
			return BranchConditional (*expression.unary.operand, !value, label);
		default:
			assert (Lexer::UnreachableOperator);
		}

	case Expression::Binary:
	{
		switch (expression.binary.operator_)
		{
		case Lexer::Or:
		{
			auto skip = CreateLabel ();
			BranchConditional (*expression.binary.left, true, value ? label : skip);
			if (!IsTrue (*expression.binary.left)) BranchConditional (*expression.binary.right, value, label);
			return skip ();
		}
		case Lexer::And:
		{
			auto skip = CreateLabel ();
			BranchConditional (*expression.binary.left, false, value ? skip : label);
			if (!IsFalse (*expression.binary.left)) BranchConditional (*expression.binary.right, value, label);
			return skip ();
		}
		case Lexer::Equal:
			if (IsComplex (*expression.binary.left->type)) return Compare (EvaluateComplex (*expression.binary.left), EvaluateComplex (*expression.binary.right), value, label);
			if (IsStringable (*expression.binary.left->type)) return CompareString (equal[value], *expression.binary.left, *expression.binary.right, label); break;
		case Lexer::Unequal:
			if (IsComplex (*expression.binary.left->type)) return Compare (EvaluateComplex (*expression.binary.left), EvaluateComplex (*expression.binary.right), !value, label);
			if (IsStringable (*expression.binary.left->type)) return CompareString (equal[!value], *expression.binary.left, *expression.binary.right, label); break;
		case Lexer::Less:
			if (IsStringable (*expression.binary.left->type)) return CompareString (less[value], *expression.binary.left, *expression.binary.right, label); break;
		case Lexer::LessEqual:
			if (IsStringable (*expression.binary.left->type)) return CompareString (less[!value], *expression.binary.right, *expression.binary.left, label); break;
		case Lexer::Greater:
			if (IsStringable (*expression.binary.left->type)) return CompareString (less[value], *expression.binary.right, *expression.binary.left, label); break;
		case Lexer::GreaterEqual:
			if (IsStringable (*expression.binary.left->type)) return CompareString (less[!value], *expression.binary.left, *expression.binary.right, label); break;
		case Lexer::In:
			return (this->*equal[!value]) (label, Evaluate (expression), Evaluate (false, expression));
		case Lexer::Is:
			if (IsPointer (*expression.binary.left->type) || IsAny (*expression.binary.left->type)) return BranchConditional (DereferenceDescriptor (*expression.binary.left), *expression.binary.right->type->pointer.baseType, value, label);
			return BranchConditional (EvaluateDescriptor (*expression.binary.left), *expression.binary.right->type, value, label);
		}

		auto left = Evaluate (*expression.binary.left); SaveRegister (left);
		auto right = Evaluate (*expression.binary.right); RestoreRegister (left);

		switch (expression.binary.operator_)
		{
		case Lexer::Equal:
			return (this->*equal[value]) (label, left, right);
		case Lexer::Unequal:
			return (this->*equal[!value]) (label, left, right);
		case Lexer::Less:
			return (this->*less[value]) (label, left, right);
		case Lexer::LessEqual:
			return (this->*less[!value]) (label, right, left);
		case Lexer::Greater:
			return (this->*less[value]) (label, right, left);
		case Lexer::GreaterEqual:
			return (this->*less[!value]) (label, left, right);
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Conversion:
		return (this->*equal[!value]) (label, Evaluate (*expression.conversion.expression), Evaluate (false, *expression.conversion.expression));

	case Expression::Parenthesized:
		return BranchConditional (*expression.parenthesized.expression, value, label);

	default:
		assert (Expression::Unreachable);
	}
}

void Context::BranchConditional (const Operand& descriptor, const Type& type, const bool value, const Label& label)
{
	auto pointer = IsMemory (descriptor) || type.record.extensionLevel ? MakeRegister (descriptor) : descriptor; auto skip = CreateLabel ();
	if (type.record.extensionLevel) (this->*less[true]) (value ? skip : label, MakeMemory (GetType (emitter.platform.globalLengthType), pointer, ExtensionLevelOffset * platform.pointer.size), SImm (GetType (emitter.platform.globalLengthType), type.record.extensionLevel));
	(this->*equal[value]) (label, MakeMemory (platform.pointer, pointer, (TypeTableOffset + type.record.extensionLevel) * platform.pointer.size), Evaluate (type)); skip ();
}

void Context::Compare (const Complex& left, const Complex& right, const bool value, const Label& label)
{
	auto skip = CreateLabel (); (this->*equal[false]) (value ? skip : label, left.real, right.real); (this->*equal[value]) (label, left.imag, right.imag); skip ();
}

void Context::CompareString (void (Context::*const branch) (const Label&, const Operand&, const Operand&), const Expression& left, const Expression& right, const Label& label)
{
	const RestoreRegisterState restore {*this}; auto arguments = Push (Designate (right)); arguments += Push (Designate (left));
	(this->*branch) (label, Call (platform.integer, Adr {platform.function, "strcmp"}, arguments), SImm {platform.integer, 0});
}

void Context::Emit (const Statement& statement)
{
	if (!IsReachable (statement)) return;
	if (IsProcedureCall (statement) && statement.procedureCall.designator->CallsCode (emitter.platform)) Comment (statement.position, *statement.procedureCall.designator->call.designator); else Comment (statement.position, statement);
	Break (module.source, statement.position);

	switch (statement.model)
	{
	case Statement::If:
	{
		auto skip = CreateLabel (), end = CreateLabel ();
		BranchConditional (*statement.if_.condition, false, skip);
		Emit (*statement.if_.thenPart); Branch (end); skip ();
		if (statement.if_.elsifs) for (auto& elsif: *statement.if_.elsifs) Emit (elsif, end);
		if (statement.if_.elsePart) Emit (*statement.if_.elsePart);
		return end ();
	}

	case Statement::For:
	{
		const auto type = GetType (*statement.for_.variable->type);
		const auto temp = IsConstant (*statement.for_.end) ? Evaluate (*statement.for_.end) : MakeMemory (type, emitter.framePointer, platform.stackDisplacement - Displacement (statement.for_.temporary));
		if (!IsConstant (*statement.for_.end)) Move (temp, Evaluate (*statement.for_.end));
		const auto variable = MakeMemory (type, Designate (*statement.for_.variable)); Move (variable, Evaluate (*statement.for_.begin));
		const auto step = statement.for_.step ? Evaluate (*statement.for_.step) : Imm (type, 1);
		auto begin = CreateLabel (), end = CreateLabel (); begin ();
		if (IsNegative (step)) BranchLessThan (end, variable, temp); else BranchLessThan (end, temp, variable);
		Emit (*statement.for_.statements); Comment (statement.for_.variable->position, Lexer::By, ' ', statement.for_.step ? statement.for_.step->value : Signed (1));
		Break (module.source, statement.for_.variable->position); Add (variable, variable, step); Branch (begin);
		return end ();
	}

	case Statement::Case:
	{
		auto value = MakeRegister (Evaluate (*statement.case_.expression)); std::vector<Label> labels; auto else_ = CreateLabel (), end = CreateLabel ();
		if (statement.case_.cases) for (auto count = statement.case_.cases->size (); count; --count) labels.push_back (CreateLabel ());
		if (statement.case_.cases) for (auto& case_: *statement.case_.cases) for (auto& label: case_.labels) Emit (label, value, labels[GetIndex (case_, *statement.case_.cases)]);
		value = {}; if (statement.case_.elsePart) Branch (else_); else Trap (Case);
		if (statement.case_.cases) for (auto& case_: *statement.case_.cases) labels[GetIndex (case_, *statement.case_.cases)] (), Emit (case_.statements), Branch (end);
		else_ (); if (statement.case_.elsePart) Emit (*statement.case_.elsePart);
		return end ();
	}

	case Statement::Exit:
		return Branch (loop);

	case Statement::Loop:
	{
		auto begin = CreateLabel (), end = CreateLabel (); loop.swap (end);
		begin (); Emit (*statement.loop.statements); Branch (begin); loop.swap (end);
		return end ();
	}

	case Statement::With:
	{
		auto end = CreateLabel (); for (auto& guard: *statement.with.guards) Emit (guard, end, IsFirst (guard, *statement.with.guards));
		if (statement.with.elsePart) Emit (*statement.with.elsePart); else Trap (With);
		return end ();
	}

	case Statement::While:
	{
		auto begin = CreateLabel (), skip = CreateLabel (); begin ();
		BranchConditional (*statement.while_.condition, false, skip);
		Emit (*statement.while_.statements);
		Branch (begin);
		return skip ();
	}

	case Statement::Repeat:
	{
		auto begin = CreateLabel (); begin (); Emit (*statement.repeat.statements);
		Comment (statement.repeat.condition->position, Lexer::Until, ' ', *statement.repeat.condition);
		Break (module.source, statement.repeat.condition->position);
		return BranchConditional (*statement.repeat.condition, false, begin);
	}

	case Statement::Return:
		if (IsProcedure (*currentScope)) if (const auto result = currentScope->procedure->procedure.signature.result)
			if (IsStructured (*result)) AssignStructured (GetResult (*currentScope), *statement.return_.expression, *result);
			else Move (Reg {GetType (*result), RRes}, Evaluate (*statement.return_.expression, RRes));
		return Branch (epilogue);

	case Statement::Assignment:
		return Assign (*statement.assignment.designator, *statement.assignment.expression);

	case Statement::ProcedureCall:
	{
		const auto& expression = *statement.procedureCall.designator, designator = *expression.call.designator;
		if (IsConstant (designator)) if (const auto procedure = designator.value.procedure) if (!IsPredeclared (*procedure));
			#define FUNCTION(scope, procedure_, name)
			#define PROCEDURE(scope, procedure_, name) else if (procedure == &emitter.platform.scope##procedure_) return Call##procedure_ (expression);
			#include "oberon.def"
		return void (EvaluateCall (*statement.procedureCall.designator, {}));
	}

	default:
		assert (Statement::Unreachable);
	}
}

void Context::Emit (const Statements& statements)
{
	for (auto& statement: statements) Emit (statement);
}

void Context::Assign (const Expression& designator, const Expression& expression)
{
	if (IsRecord (*designator.type)) return AssignRecord (designator, expression);
	if (IsStructured (*designator.type)) return AssignStructured (Designate (designator), expression, *designator.type);
	auto target = Designate (designator); SaveRegister (target); auto source = Evaluate (expression); RestoreRegister (target); Move (MakeMemory (source.type, target), source);
}

void Context::AssignRecord (const Expression& designator, const Expression& expression)
{
	auto target = DesignateRecord (designator); auto skip = CreateLabel ();
	if (HasDynamicType (designator)) BranchEqual (skip, target.descriptor, Evaluate (*designator.type)), Trap (TypeGuard);
	skip (); AssignStructured (std::move (target.address), expression, *designator.type);
}

void Context::AssignStructured (SmartOperand&& target, const Expression& expression, const Type& type)
{
	if (IsParenthesized (expression)) return AssignStructured (std::move (target), *expression.parenthesized.expression, type);
	if (IsCall (expression) && expression.Calls (emitter.platform.globalPtr)) return AssignVariablePointer (std::move (target), GetArgument (expression, 0), type);
	if (IsCall (expression) && !expression.Calls (emitter.platform.systemVal)) return void (EvaluateCall (expression, target));
	if (IsEmptyString (expression.value)) return Move (MakeMemory (GetType (*type.array.elementType), target), UImm {GetType (*type.array.elementType), emitter.charset.Encode (0)});
	if (IsString (expression.value)) return Copy (target, Designate (expression), PtrImm {platform.pointer, expression.value.string->size () + 1});
	if (IsNil (expression.value)) return Move (MakeMemory (platform.pointer, target), Evaluate (expression));
	if (IsComplex (type)) return AssignComplex (std::move (target), expression);
	if (IsVariablePointer (type)) return AssignVariablePointer (std::move (target), expression, type);
	SaveRegister (target); auto source = Designate (expression); RestoreRegister (target);
	Copy (target, source, PtrImm {platform.pointer, emitter.platform.GetSize (type)});
}

void Context::AssignComplex (SmartOperand&& target, const Expression& expression)
{
	SaveRegister (target); auto source = EvaluateComplex (expression); RestoreRegister (target);
	Move (MakeMemory (source.real.type, target), source.real); Move (MakeMemory (source.imag.type, target, source.real.type.size), source.imag);
}

void Context::AssignVariablePointer (SmartOperand&& target, const Expression& expression, const Type& type)
{
	if (IsArray (*type.pointer.baseType))
	{
		SaveRegister (target); auto source = IsPointer (*expression.type) ? DereferenceArray (expression) : DesignateArray (expression); RestoreRegister (target);
		Move (MakeMemory (platform.pointer, target), source.address); Displace (target, platform.pointer.size);
		for (auto designatorType = type.pointer.baseType, expressionType = expression.type; IsOpenArray (*designatorType); designatorType = designatorType->array.elementType, expressionType = expressionType->array.elementType, Displace (target, source.length.type.size))
			if (IsOpenArray (*expressionType)) Move (MakeMemory (source.length.type, target), source.length), Displace (source.length, source.length.type.size);
			else Move (MakeMemory (source.length.type, target), Evaluate (*expressionType->array.length));
	}
	else if (IsRecord (*type.pointer.baseType))
	{
		SaveRegister (target); auto source = IsPointer (*expression.type) ? DereferenceRecord (expression) : DesignateRecord (expression); RestoreRegister (target);
		Move (MakeMemory (platform.pointer, target), source.address); Displace (target, platform.pointer.size); Move (MakeMemory (source.descriptor.type, target), source.descriptor);
	}
}

Operand Context::Evaluate (const Value& value, const Expression& expression)
{
	switch (value.model)
	{
	case Type::Boolean:
		return Imm (GetType (*expression.type), value.boolean);
	case Type::Character:
		return UImm (GetType (*expression.type), emitter.charset.Encode (value.character));
	case Type::Signed:
		return SImm (GetType (*expression.type), value.signed_);
	case Type::Unsigned:
		return UImm (GetType (*expression.type), value.unsigned_);
	case Type::Real:
		return FImm (GetType (*expression.type), value.real);
	case Type::Set:
		return UImm (GetType (*expression.type), value.set.mask);
	case Type::Byte:
		return UImm (GetType (*expression.type), value.byte);
	case Type::Any:
	case Type::Pointer:
		assert (!value.pointer);
		return PtrImm {platform.pointer, 0};
	case Type::Nil:
		return PtrImm {platform.pointer, 0};
	case Type::Procedure:
		if (!value.procedure) return FunImm {platform.function, 0};
		return Designate (*value.procedure);
	default:
		assert (Type::Unreachable);
	}
}

Context::SmartOperand Context::Evaluate (const Expression& expression, const Hint hint)
try
{
	if (IsConstant (expression)) return Evaluate (expression.value, expression);

	switch (expression.model)
	{
	case Expression::Set:
	{
		SmartOperand value = UImm {GetType (*expression.type), 0};
		if (expression.set.elements) for (auto& element: *expression.set.elements)
			value = Or (value, IsRange (element) ? EvaluateRange (element, value.type, Reuse (hint, value)) : EvaluateElement (element, value.type, Reuse (hint, value)), Reuse (hint, value));
		return value;
	}

	case Expression::Call:
	{
		const auto& designator = *expression.call.designator;
		if (IsConstant (designator)) if (const auto procedure = designator.value.procedure) if (!IsPredeclared (*procedure));
			#define FUNCTION(scope, procedure_, name) else if (procedure == &emitter.platform.scope##procedure_) return Call##procedure_ (expression, hint);
			#include "oberon.def"
		return EvaluateCall (expression, {});
	}

	case Expression::Index:
	case Expression::Selector:
	case Expression::Identifier:
	case Expression::Dereference:
		return MakeMemory (GetType (*expression.type), Designate (expression));

	case Expression::Unary:
	{
		auto value = Evaluate (*expression.unary.operand, hint);

		switch (expression.unary.operator_)
		{
		case Lexer::Plus:
			return value;
		case Lexer::Minus:
			return IsSet (*expression.type) ? Complement (value, hint) : Negate (value, hint);
		case Lexer::Not:
			return ExclusiveOr (value, Evaluate (true, expression), hint);
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Binary:
	{
		if (IsBoolean (*expression.type) && expression.binary.operator_ != Lexer::In) return EvaluateBoolean (expression, hint);

		auto left = Evaluate (*expression.binary.left, hint); SaveRegister (left);
		auto right = Evaluate (*expression.binary.right, Reuse (hint, left)); RestoreRegister (left);

		switch (expression.binary.operator_)
		{
		case Lexer::Plus:
			return IsSet (*expression.type) ? Or (left, right, hint) : Add (left, right, hint);
		case Lexer::Minus:
			return IsSet (*expression.type) ? And (left, Complement (right, Reuse (hint, left)), hint) : Subtract (left, right, hint);
		case Lexer::Asterisk:
			return IsSet (*expression.type) ? And (left, right, hint) : Multiply (left, right, hint);
		case Lexer::Slash:
			if (IsSet (*expression.type)) return ExclusiveOr (left, right, hint);
		case Lexer::Div:
			return Divide (left, right, hint);
		case Lexer::Mod:
			return Modulo (left, right, hint);
		case Lexer::In:
			return Convert (GetType (*expression.type), And (ShiftRight (right, Convert (right.type, left, hint), hint), UImm {right.type, 1}));
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Promotion:
		return Convert (GetType (*expression.type), Evaluate (*expression.promotion.expression, hint), hint);

	case Expression::TypeGuard:
	{
		assert (IsPointer (*expression.type));
		auto record = DereferenceRecord (*expression.typeGuard.designator); auto skip = CreateLabel ();
		BranchConditional (record.descriptor, *expression.type->pointer.baseType, true, skip);
		Trap (TypeGuard); skip (); return record.address;
	}

	case Expression::Conversion:
		if (IsBoolean (*expression.type) && !IsBoolean (*expression.conversion.expression->type)) return EvaluateBoolean (expression, hint);
		return Convert (GetType (*expression.type), Evaluate (*expression.conversion.expression, hint), hint);

	case Expression::Parenthesized:
		return Evaluate (*expression.parenthesized.expression, hint);

	default:
		assert (Expression::Unreachable);
	}
}
catch (const RegisterShortage&)
{
	EmitFatalError (module, expression.position, "register shortage");
}

Context::Complex Context::EvaluateComplex (const Value& value, const Expression& expression)
{
	assert (IsComplex (value)); const auto type = GetType (*expression.type);
	return {FImm {type, value.complex.real}, FImm {type, value.complex.imag}};
}

Context::Complex Context::EvaluateComplex (const Expression& expression)
try
{
	assert (IsComplex (*expression.type));
	if (IsConstant (expression)) return EvaluateComplex (expression.value, expression);

	switch (expression.model)
	{
	case Expression::Index:
	case Expression::Selector:
	case Expression::Identifier:
	case Expression::Dereference:
	{
		auto designator = Protect (Designate (expression)); const auto type = GetType (*expression.type);
		return {MakeMemory (type, designator), MakeMemory (type, designator, type.size)};
	}

	case Expression::Unary:
	{
		auto value = EvaluateComplex (*expression.unary.operand);

		switch (expression.unary.operator_)
		{
		case Lexer::Plus:
			return value;
		case Lexer::Minus:
			return {Negate (value.real), Negate (value.imag)};
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Binary:
	{
		auto left = EvaluateComplex (*expression.binary.left); SaveRegisters (left.real, left.imag);
		auto right = EvaluateComplex (*expression.binary.right); RestoreRegisters (left.real, left.imag);

		switch (expression.binary.operator_)
		{
		case Lexer::Plus:
			return {Add (left.real, right.real), Add (left.imag, right.imag)};
		case Lexer::Minus:
			return {Subtract (left.real, right.real), Subtract (left.imag, right.imag)};
		case Lexer::Asterisk:
		{
			left.real = Protect (left.real); left.imag = Protect (left.imag); right.real = Protect (right.real); right.imag = Protect (right.imag);
			auto real = Subtract (Multiply (left.real, right.real), Multiply (left.imag, right.imag));
			auto imag = Add (Multiply (Deprotect (left.real), Deprotect (right.imag)), Multiply (Deprotect (left.imag), Deprotect (right.real)));
			return {real, imag};
		}
		case Lexer::Slash:
		{
			left.real = Protect (left.real); right.real = Protect (right.real); left.imag = Protect (left.imag); right.imag = Protect (right.imag);
			auto real = Add (Multiply (left.real, right.real), Multiply (left.imag, right.imag));
			auto imag = Subtract (Multiply (Deprotect (left.imag), right.real), Multiply (Deprotect (left.real), right.imag)); left.real = {}; left.imag = {};
			const auto divisor = Add (Multiply (right.real, Deprotect (right.real)), Multiply (right.imag, Deprotect (right.imag)));
			return {Divide (real, divisor), Divide (imag, divisor)};
		}
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Promotion:
	{
		const auto type = GetType (*expression.type);
		if (!IsComplex (*expression.promotion.expression->type)) return {Convert (type, Evaluate (*expression.promotion.expression)), FImm {type, 0}};
		auto value = EvaluateComplex (*expression.promotion.expression);
		return {Convert (type, value.real), Convert (type, value.imag)};
	}

	case Expression::Conversion:
	{
		const auto type = GetType (*expression.type);
		if (!IsComplex (*expression.conversion.expression->type)) return {Convert (type, Evaluate (*expression.conversion.expression)), FImm {type, 0}};
		auto value = EvaluateComplex (*expression.conversion.expression);
		return {Convert (type, value.real), Convert (type, value.imag)};
	}

	case Expression::Parenthesized:
		return EvaluateComplex (*expression.parenthesized.expression);

	default:
		assert (Expression::Unreachable);
	}
}
catch (const RegisterShortage&)
{
	EmitFatalError (module, expression.position, "register shortage");
}

Context::SmartOperand Context::EvaluateElement (const Expression& expression, const Code::Type& type, const Hint hint)
{
	return ShiftLeft (UImm {type, 1}, Convert (type, Evaluate (expression, hint), hint));
}

Context::SmartOperand Context::EvaluateRange (const Expression& expression, const Code::Type& type, const Hint hint)
{
	assert (IsRange (expression));
	auto lower = Evaluate (*expression.binary.left, hint); SaveRegister (lower);
	auto upper = Evaluate (*expression.binary.right, Reuse (hint, lower)); RestoreRegister (lower);
	return And (ShiftLeft (Complement (UImm {type, 0}), Convert (type, lower)), Complement (ShiftLeft (Complement (UImm {type, 1}), Convert (type, upper))), hint);
}

Context::SmartOperand Context::EvaluatePointer (const Expression& expression, const Hint hint)
{
	switch (expression.model)
	{
	case Expression::Call:
		if (expression.Calls (emitter.platform.systemAdr)) return DesignateArgument (expression, 0);
		if (expression.Calls (emitter.platform.systemVal)) return Convert (platform.pointer, EvaluateArgument (expression, 1, hint), hint);
		break;

	case Expression::Index:
	case Expression::Unary:
	case Expression::Selector:
	case Expression::Promotion:
	case Expression::Conversion:
	case Expression::Identifier:
	case Expression::Parenthesized:
		break;

	case Expression::Binary:
	{
		if (expression.binary.operator_ != Lexer::Plus && expression.binary.operator_ != Lexer::Minus) break;

		auto left = EvaluatePointer (*expression.binary.left, hint); SaveRegister (left);
		auto right = EvaluatePointer (*expression.binary.right, Reuse (hint, left)); RestoreRegister (left);

		switch (expression.binary.operator_)
		{
		case Lexer::Plus:
			return Add (left, right, hint);
		case Lexer::Minus:
			return Subtract (left, right, hint);
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	default:
		assert (Expression::Unreachable);
	}

	return Convert (platform.pointer, Evaluate (expression, hint), hint);
}

Context::SmartOperand Context::EvaluateCall (const Expression& expression, const Operand& result)
{
	assert (IsCall (expression)); const RestoreRegisterState restore {*this}; const auto& designator = *expression.call.designator; Size arguments = 0;
	if (expression.call.arguments) for (auto& argument: Reverse {*expression.call.arguments}) arguments += Push (argument, GetParameter (expression, argument));
	if (IsStructured (*expression.type)) arguments += Push (Add (result, IsStackPointer (result) * arguments));
	if (const auto parent = designator.type->procedure.signature.parent) arguments += Push (GetFramePointer (*parent->procedure.signature.scope));
	const auto bound = IsTypeBound (*designator.type) ? EvaluateTypeBound (designator) : TypeBound {Evaluate (designator)};
	if (!IsVoid (bound.record.descriptor) && NeedsTypeDescriptor (*designator.type->procedure.signature.receiver)) arguments += Push (bound.record.descriptor);
	if (!IsVoid (bound.record.address)) arguments += Push (bound.record.address);
	if (!IsScalar (*expression.type)) return Call (bound.procedure, arguments), result;
	return Call (GetType (*expression.type), bound.procedure, arguments);
}

Size Context::Push (const Expression& argument, const Declaration& declaration)
{
	assert (IsParameter (declaration));
	const auto size = emitter.platform.GetSize (declaration);
	if (IsVariableOpenByteArrayParameter (declaration)) PushByteArray (argument);
	else if (IsStructured (*declaration.parameter.type) && !IsOpenArray (*declaration.parameter.type) && !IsVariableParameter (declaration) && !IsReadOnlyParameter (declaration)) PushStructured (argument, declaration);
	else if (IsArray (*declaration.parameter.type)) PushArray (argument, declaration);
	else if (IsRecord (*declaration.parameter.type)) PushRecord (argument, declaration);
	else PushScalar (argument, declaration);
	return size;
}

void Context::PushByteArray (const Expression& argument)
{
	if (IsOpenArray (*argument.type)) {auto array = DesignateArray (argument); Push (GetArraySize (*argument.type, array.length)); Push (array.address);}
	else if (HasDynamicType (argument)) {const auto record = DesignateRecord (argument); Push (MakeMemory (GetType (emitter.platform.globalLengthType), record.descriptor, RecordSizeOffset * platform.pointer.size)); Push (record.address);}
	else Push (SImm (GetType (emitter.platform.globalLengthType), emitter.platform.GetSize (*argument.type))), Push (Designate (argument));
}

void Context::PushArray (const Expression& argument, const Declaration& declaration)
{
	if (!IsOpenArray (*declaration.parameter.type) && !IsVariableParameter (declaration) && !IsReadOnlyParameter (declaration)) return PushStructured (argument, declaration);
	const auto array = DesignateArray (argument); if (IsOpenArray (*declaration.parameter.type)) PushLength (array.length, *declaration.parameter.type, *argument.type); Push (array.address);
}

void Context::PushLength (const Operand& length, const Type& parameter, const Type& argument)
{
	assert (IsOpenArray (parameter));
	if (IsOpenArray (*parameter.array.elementType))
		PushLength (IsOpenArray (*argument.array.elementType) ? Displace (length, GetSize (length)) : Evaluate (*argument.array.elementType->array.length), *parameter.array.elementType, *argument.array.elementType);
	Push (length);
}

void Context::PushRecord (const Expression& argument, const Declaration& declaration)
{
	const auto record = DesignateRecord (argument); if (NeedsTypeDescriptor (declaration)) Push (record.descriptor); Push (record.address);
}

void Context::PushStructured (const Expression& argument, const Declaration& declaration)
{
	Push (emitter.platform.GetSize (declaration)); AssignStructured (Add (emitter.stackPointer, platform.stackDisplacement), argument, *declaration.parameter.type);
}

void Context::PushScalar (const Expression& argument, const Declaration& declaration)
{
	Push (IsVariableParameter (declaration) ? Designate (argument) : Evaluate (argument));
}

Context::SmartOperand Context::GetArraySize (const Type& type, const Operand& length)
{
	if (!IsOpenArray (type)) return SImm (GetType (emitter.platform.globalLengthType), emitter.platform.GetSize (type));
	return Multiply (GetArraySize (*type.array.elementType, Displace (length, GetSize (length))), length);
}

void Context::CopyOpenArray (const Declaration& declaration)
{
	assert (IsParameter (declaration)); assert (IsOpenArray (*declaration.parameter.type));
	const auto array = DesignateArray (declaration); const auto size = Convert (platform.pointer, GetArraySize (*declaration.parameter.type, array.length));
	Subtract (emitter.stackPointer, emitter.stackPointer, size); Increment (emitter.stackPointer, platform.stackDisplacement);
	And (emitter.stackPointer, emitter.stackPointer, Convert (platform.pointer, Negate (SImm (Code::Signed {platform.pointer.size}, platform.GetStackAlignment (platform.pointer)))));
	Copy (emitter.stackPointer, array.address, size); Move (array.address, emitter.stackPointer); Decrement (emitter.stackPointer, platform.stackDisplacement);
}

Context::SmartOperand Context::DesignateArgument (const Expression& expression, const Size index)
{
	return Designate (GetArgument (expression, index));
}

Context::SmartOperand Context::EvaluateArgument (const Expression& expression, const Size index, const Hint hint)
{
	return Evaluate (GetArgument (expression, index), hint);
}

Context::SmartOperand Context::EvaluateArgument (const Expression& expression, const Size index, const Operand& defaultValue)
{
	if (const auto argument = GetOptionalArgument (expression, index)) return Evaluate (*argument); return defaultValue;
}

Context::SmartOperand Context::CallAbs (const Expression& expression, const Hint hint)
{
	auto& argument = GetArgument (expression, 0);
	if (IsComplex (*argument.type)) return CallAbs (EvaluateComplex (argument));
	auto skip = CreateLabel ();
	auto result = MakeRegister (Evaluate (argument, hint), hint);
	BranchGreaterEqual (skip, result, Imm {result.type, 0});
	Negate (result, result); skip (); return result;
}

Context::SmartOperand Context::CallAbs (const Complex& value)
{
	const RestoreRegisterState restore {*this};
	return Call (value.real.type, Adr {platform.function, value.real.type.size == 8 ? "sqrtl" : "sqrtf"}, Push (Add (Multiply (value.real, value.real), Multiply (value.imag, value.imag))));
}

Context::SmartOperand Context::CallAdr (const Expression& expression, const Hint hint)
{
	return Convert (GetType (*expression.type), DesignateArgument (expression, 0), hint);
}

Context::SmartOperand Context::CallAsh (const Expression& expression, const Hint hint)
{
	auto value = EvaluateArgument (expression, 0, hint); SaveRegister (value); auto shift = EvaluateArgument (expression, 1); RestoreRegister (value);
	const auto type = expression.Calls (emitter.platform.systemLsh) ? Code::Unsigned {value.type.size} : value.type;
	if (IsImmediate (shift)) return IsNegative (shift) ? Convert (value.type, ShiftRight (Convert (type, value), Imm {type, -shift.simm}, hint)) : ShiftLeft (value, Imm {value.type, shift.simm}, hint);
	if (!IsSigned (shift)) return ShiftLeft (value, Convert (value.type, shift), hint);
	auto skip = CreateLabel (), end = CreateLabel (); shift = MakeRegister (shift); BranchLessThan (skip, shift, Imm {shift.type, 0});
	auto result = ShiftLeft (value, Convert (value.type, shift), hint); Fix (result); Branch (end); skip ();
	Move (result, Convert (value.type, ShiftRight (Convert (type, value), Convert (type, Negate (shift)), GetRegister (result)))); end (); Unfix (result); return result;
}

Context::SmartOperand Context::CallBit (const Expression& expression, const Hint hint)
{
	const auto type = GetType (*expression.type); const auto bits = PtrImm {platform.pointer, type.size * 8};
	auto index = Convert (platform.pointer, EvaluateArgument (expression, 1)); SaveRegister (index);
	auto address = Convert (platform.pointer, EvaluateArgument (expression, 0, hint), hint); RestoreRegister (index); if (IsMemory (index)) index = MakeRegister (index);
	auto byte = Add (address, Divide (Protect (index), bits)), bit = Modulo (Convert (type, index), UImm {type, type.size * 8});
	return And (ShiftRight (MakeMemory (type, byte), bit), UImm {type, 1});
}

Context::SmartOperand Context::CallCap (const Expression& expression, const Hint hint)
{
	const RestoreRegisterState restore {*this};
	return Convert (GetType (*expression.type), Call (platform.integer, Adr {platform.function, "toupper"}, Push (Convert (platform.integer, EvaluateArgument (expression, 0)))), hint);
}

Context::SmartOperand Context::CallChr (const Expression& expression, const Hint hint)
{
	return Convert (GetType (*expression.type), EvaluateArgument (expression, 0, hint), hint);
}

Context::SmartOperand Context::CallEntier (const Expression& expression, const Hint)
{
	const RestoreRegisterState restore {*this}; auto argument = EvaluateArgument (expression, 0);
	return Convert (GetType (*expression.type), Call (argument.type, Adr {platform.function, argument.type.size == 8 ? "floorl" : "floorf"}, Push (argument)));
}

Context::SmartOperand Context::CallIm (const Expression& expression, const Hint)
{
	return EvaluateComplex (GetArgument (expression, 0)).imag;
}

Context::SmartOperand Context::CallLen (const Expression& expression, const Hint)
{
	auto length = DesignateArray (GetArgument (expression, 0)).length;
	if (const auto dimension = GetOptionalArgument (expression, 1)) Displace (length, GetSize (length) * dimension->value.signed_);
	return Deprotect (length);
}

Context::SmartOperand Context::CallLong (const Expression& expression, const Hint hint)
{
	return Convert (GetType (*expression.type), EvaluateArgument (expression, 0, hint), hint);
}

Context::SmartOperand Context::CallLsh (const Expression& expression, const Hint hint)
{
	return CallAsh (expression, hint);
}

Context::SmartOperand Context::CallMax (const Expression& expression, const Hint)
{
	return Evaluate (expression.value, expression);
}

Context::SmartOperand Context::CallMin (const Expression& expression, const Hint)
{
	return Evaluate (expression.value, expression);
}

Context::SmartOperand Context::CallOdd (const Expression& expression, const Hint hint)
{
	return And (Convert (GetType (*expression.type), EvaluateArgument (expression, 0, hint), hint), Evaluate (true, expression));
}

Context::SmartOperand Context::CallOrd (const Expression& expression, const Hint hint)
{
	return Convert (GetType (*expression.type), EvaluateArgument (expression, 0, hint), hint);
}

Context::SmartOperand Context::CallPtr (const Expression& expression, const Hint)
{
	return DesignateArgument (expression, 0);
}

Context::SmartOperand Context::CallRe (const Expression& expression, const Hint)
{
	return EvaluateComplex (GetArgument (expression, 0)).real;
}

Context::SmartOperand Context::CallRot (const Expression& expression, const Hint hint)
{
	const UImm mask {Code::Unsigned (expression.type->integer.size), expression.type->integer.size * 8 - 1};
	auto value = Convert (mask.type, EvaluateArgument (expression, 0, hint), hint); SaveRegister (value);
	auto shift = Convert (mask.type, EvaluateArgument (expression, 1, Reuse (hint, value))); RestoreRegister (value);
	auto left = ShiftLeft (Protect (value), And (Protect (shift), mask)), right = ShiftRight (value, And (Subtract (UImm {mask.type, mask.uimm + 1}, shift), mask));
	return Convert (GetType (*expression.type), Or (left, right, hint));
}

Context::SmartOperand Context::CallSel (const Expression& expression, const Hint hint)
{
	const auto &condition = GetArgument (expression, 0);
	if (IsTrue (condition)) return EvaluateArgument (expression, 1, hint);
	if (IsFalse (condition)) return EvaluateArgument (expression, 2, hint);
	auto skip = CreateLabel (), end = CreateLabel (); BranchConditional (condition, false, skip);
	auto result = MakeRegister (EvaluateArgument (expression, 1, hint), hint); Fix (result); Branch (end); skip ();
	Move (result, EvaluateArgument (expression, 2, GetRegister (result))); Unfix (result); end (); return result;
}

Context::SmartOperand Context::CallShort (const Expression& expression, const Hint hint)
{
	return Convert (GetType (*expression.type), EvaluateArgument (expression, 0, hint), hint);
}

Context::SmartOperand Context::CallSize (const Expression& expression, const Hint)
{
	return Evaluate (expression.value, expression);
}

Context::SmartOperand Context::CallVal (const Expression& expression, const Hint hint)
{
	const auto& argument = GetArgument (expression, 1);
	if (!IsScalar (*argument.type)) return IsScalar (*expression.type) ? MakeMemory (GetType (*expression.type), Designate (argument)) : Designate (argument);
	if (IsCall (argument) && argument.Calls (emitter.platform.systemAdr)) return Convert (GetType (*expression.type), DesignateArgument (argument, 0), hint);
	if (IsReal (*argument.type) == IsReal (*expression.type)) return Convert (GetType (*expression.type), Evaluate (argument, hint), hint);
	const auto size = Push (Evaluate (argument)); auto result = Move (MakeMemory (GetType (*expression.type), emitter.stackPointer, platform.stackDisplacement), hint);
	Increment (emitter.stackPointer, size); return result;
}

void Context::CallAssert (const Expression& expression)
{
	const auto& condition = GetArgument (expression, 0); if (IsConstant (condition)) return;
	auto skip = CreateLabel (); BranchConditional (condition, true, skip);
	if (const auto argument = GetOptionalArgument (expression, 1)) Push (Evaluate (*argument)), Call (Adr {platform.function, "_Exit"}, 0);
	else Trap (Assert); skip ();
}

void Context::CallCopy (const Expression& expression)
{
	const auto& sourceExpression = GetArgument (expression, 0), targetExpression = GetArgument (expression, 1);
	assert (IsArray (*targetExpression.type)); const auto character = GetType (*targetExpression.type->array.elementType);
	if (IsString (sourceExpression.value) && sourceExpression.value.string->empty ()) return Move (MakeMemory (character, Designate (targetExpression)), UImm {character, emitter.charset.Encode (0)});
	auto source = DesignateArray (sourceExpression); SaveRegisters (source.address, source.length);
	auto target = DesignateArray (targetExpression); RestoreRegisters (source.address, source.length);
	const auto length = Convert (platform.pointer, Minimize (source.length, target.length)); Copy (target.address, source.address, length);
	if (!IsString (*sourceExpression.type) || !IsImmediate (length) || Pointer::Value (source.length.simm) > length.ptrimm) Move (MakeMemory (character, Add (target.address, length), -1), UImm {character, emitter.charset.Encode (0)});
}

void Context::CallDec (const Expression& expression)
{
	const auto type = GetType (*GetArgument (expression, 0).type);
	auto variable = DesignateArgument (expression, 0); SaveRegister (variable);
	auto increment = EvaluateArgument (expression, 1, Imm {type, 1}); RestoreRegister (variable);
	variable = MakeMemory (type, variable); Subtract (variable, variable, increment);
}

void Context::CallDispose (const Expression& expression)
{
	const auto& argument = GetArgument (expression, 0); const auto variable = MakeRegister (Designate (argument));
	const auto size = Push (Subtract (Protect (MakeMemory (platform.pointer, variable)), (NeedsTypeDescriptor (*argument.type->pointer.baseType) + CountOpenDimensions (*argument.type->pointer.baseType)) * platform.pointer.size));
	Move (MakeMemory (platform.pointer, variable), PtrImm {platform.pointer, 0}); Call (Adr {platform.function, "free"}, size);
}

void Context::CallExcl (const Expression& expression)
{
	const auto type = GetType (*GetArgument (expression, 0).type);
	auto variable = DesignateArgument (expression, 0); SaveRegister (variable);
	auto element = EvaluateArgument (expression, 1); RestoreRegister (variable);
	variable = MakeMemory (type, variable); And (variable, variable, Complement (ShiftLeft (UImm {type, 1}, Convert (type, element))));
}

void Context::CallHalt (const Expression& expression)
{
	Push (EvaluateArgument (expression, 0)); Call (Adr {platform.function, "_Exit"}, 0);
}

void Context::CallIgnore (const Expression& expression)
{
	const auto& operand = GetArgument (expression, 0);
	if (IsVariable (operand) || IsStructured (*operand.type)) Designate (operand); else if (!IsConstant (operand)) Evaluate (operand);
}

void Context::CallInc (const Expression& expression)
{
	const auto type = GetType (*GetArgument (expression, 0).type);
	auto variable = DesignateArgument (expression, 0); SaveRegister (variable);
	auto increment = EvaluateArgument (expression, 1, Imm {type, 1}); RestoreRegister (variable);
	variable = MakeMemory (type, variable); Add (variable, variable, increment);
}

void Context::CallIncl (const Expression& expression)
{
	const auto type = GetType (*GetArgument (expression, 0).type);
	auto variable = DesignateArgument (expression, 0); SaveRegister (variable);
	auto element = EvaluateArgument (expression, 1); RestoreRegister (variable);
	variable = MakeMemory (type, variable); Or (variable, variable, ShiftLeft (UImm {type, 1}, Convert (type, element)));
}

void Context::CallNew (const Expression& expression)
{
	const auto& type = *GetArgument (expression, 0).type->pointer.baseType;

	switch (type.model)
	{
	case Type::Array:
	{
		auto base = &type; while (IsOpenArray (*base)) base = base->array.elementType;
		SmartOperand size = SImm (GetType (emitter.platform.globalLengthType), emitter.platform.GetSize (*base));
		if (NeedsInitialization (type)) assert (size.simm % platform.pointer.size == 0), size = Divide (size, SImm {size.type, platform.pointer.size});
		for (auto& argument: *expression.call.arguments) if (IsConstant (argument) && !IsFirst (argument, *expression.call.arguments)) size = Multiply (size, Evaluate (argument));
		for (auto& argument: Reverse {*expression.call.arguments}) if (!IsConstant (argument) && !IsFirst (argument, *expression.call.arguments))
			{auto length = MakeRegister (Evaluate (argument)); Push (length); size = Multiply (size, length);}
		size = Convert (GetType (emitter.platform.systemAddressType), size); if (NeedsInitialization (type) && !IsImmediate (size)) Push (size);
		if (NeedsInitialization (type)) size = Multiply (size, UImm {size.type, platform.pointer.size});
		const auto displacement = (expression.call.arguments->size () - 1) * platform.pointer.size;
		auto pointer = Call (platform.pointer, Adr {platform.function, "malloc"}, Push (Add (size, UImm {size.type, displacement})));
		if (NeedsInitialization (type)) size = IsImmediate (size) ? Divide (size, UImm {size.type, platform.pointer.size}) : Pop (size.type); auto skip = CreateLabel ();
		if (IsOpenArray (type) && IsImmediate (size) || NeedsInitialization (type) && !IsOpenArray (type)) BranchEqual (skip, pointer, PtrImm {platform.pointer, 0});
		for (auto& argument: *expression.call.arguments) if (!IsFirst (argument, *expression.call.arguments))
			{auto length = IsConstant (argument) ? Evaluate (argument) : Pop (GetType (emitter.platform.globalLengthType)); auto next = CreateLabel ();
			if (!IsImmediate (size)) BranchEqual (IsLast (argument, *expression.call.arguments) ? skip : next, pointer, PtrImm {platform.pointer, 0}); Move (MakeMemory (GetType (emitter.platform.globalLengthType), pointer, (GetIndex (argument, *expression.call.arguments) - 1) * platform.pointer.size), length); next ();}
		Increment (pointer, displacement);
		if (NeedsInitialization (type)) Fill (pointer, Convert (platform.pointer, size), PtrImm {platform.pointer, 0});
		skip (); SaveRegister (pointer); auto variable = DesignateArgument (expression, 0); RestoreRegister (pointer);
		return Move (MakeMemory (platform.pointer, variable), pointer);
	}

	case Type::Record:
	{
		auto pointer = Call (platform.pointer, Adr {platform.function, "malloc"}, Push (UImm {GetType (emitter.platform.systemAddressType), emitter.platform.GetSize (type) + platform.pointer.size * NeedsTypeDescriptor (type)}));
		auto skip = CreateLabel (); if (NeedsTypeDescriptor (type) || NeedsInitialization (type)) BranchEqual (skip, pointer, PtrImm {platform.pointer, 0});
		if (NeedsTypeDescriptor (type)) Move (MakeMemory (platform.pointer, pointer), Evaluate (type)), Increment (pointer, platform.pointer.size);
		if (NeedsInitialization (type)) Fill (pointer, PtrImm {platform.pointer, emitter.platform.GetSize (type) / platform.pointer.size}, PtrImm {platform.pointer, 0});
		skip (); SaveRegister (pointer); auto variable = DesignateArgument (expression, 0); RestoreRegister (pointer);
		return Move (MakeMemory (platform.pointer, variable), pointer);
	}

	default:
		assert (Type::Unreachable);
	}
}

void Context::CallTrace (const Expression& expression)
{
	const auto& argument = GetArgument (expression, 0); std::ostringstream stream;
	EmitMessage (stream, Diagnostics::Note, module.source, argument.position);
	if (IsLiteral (argument)) stream << argument; else stream << '\'' << argument << "' = ";
	const auto string = DesignateArray (stream.str (), expression); auto arguments = Push (string.length);
	Call (Adr {platform.function, "OBL:Out.String"}, Push (string.address) + arguments);

	if (!IsLiteral (argument)) switch (argument.type->model)
	{
	case Type::Boolean:
		Call (Adr {platform.function, "OBL:Out.Boolean"}, Push (Evaluate (argument))); break;
	case Type::Character:
		Call (Adr {platform.function, "OBL:Out.Char"}, Push (Evaluate (argument))); break;
	case Type::Signed:
		Call (Adr {platform.function, "OBL:Out.Signed"}, Push (Convert (GetType (emitter.platform.globalSigned64Type), Evaluate (argument)))); break;
	case Type::Unsigned:
		if (argument.type->Names (emitter.platform.systemAddressType)) Call (Adr {platform.function, "OBL:Out.Address"}, Push (Evaluate (argument)));
		else Call (Adr {platform.function, "OBL:Out.Unsigned"}, Push (Convert (GetType (emitter.platform.globalUnsigned64Type), Evaluate (argument)))); break;
	case Type::Real:
		arguments = Push (SImm {platform.integer, 5}); Call (Adr {platform.function, "OBL:Out.Real"}, Push (Convert (GetType (emitter.platform.globalLongRealType), Evaluate (argument))) + arguments); break;
	case Type::Complex:
	{
		arguments = Push (SImm {platform.integer, 5}); auto complex = EvaluateComplex (argument);
		const auto type = GetType (emitter.platform.globalLongComplexType); const auto size = platform.GetStackSize (type); arguments += Push (size * 2);
		Convert (MakeMemory (type, emitter.stackPointer), complex.real); Convert (MakeMemory (type, emitter.stackPointer, size), complex.imag);
		Call (Adr {platform.function, "OBL:Out.Complex"}, arguments); break;
	}
	case Type::Set:
		Call (Adr {platform.function, "OBL:Out.Set"}, Push (Convert (GetType (emitter.platform.globalSet64Type), Evaluate (argument)))); break;
	case Type::Byte:
		Call (Adr {platform.function, "OBL:Out.Byte"}, Push (Convert (GetType (emitter.platform.globalCharacterType), Evaluate (argument)))); break;
	case Type::Any:
	case Type::Nil:
	case Type::Pointer:
	case Type::Procedure:
		Call (Adr {platform.function, "OBL:Out.Address"}, Push (Convert (GetType (emitter.platform.systemAddressType), Evaluate (argument)))); break;
	case Type::String:
	case Type::Array:
	{
		const auto array = DesignateArray (argument); arguments = Push (array.length);
		Call (Adr {platform.function, "OBL:Out.String"}, Push (array.address) + arguments); break;
	}
	default:
		assert (Type::Unreachable);
	}

	Call (Adr {platform.function, "OBL:Out.Ln"}, 0);
}

void Context::CallAsm (const Expression& expression)
{
	const auto& code = GetArgument (expression, 0);
	Assemble (module.source, GetLine (code.position), *code.value.string);
}

void Context::CallCode (const Expression& expression)
{
	const auto& code = GetArgument (expression, 0);
	AssembleInlineCode (module.source, GetLine (code.position), *code.value.string);
}

void Context::CallGet (const Expression& expression)
{
	auto source = EvaluatePointer (GetArgument (expression, 0)); SaveRegister (source);
	auto target = DesignateArgument (expression, 1); RestoreRegister (source);
	const auto type = GetType (*GetArgument (expression, 1).type);
	Move (MakeMemory (type, target), MakeMemory (type, source));
}

void Context::CallMove (const Expression& expression)
{
	auto source = EvaluatePointer (GetArgument (expression, 0)); SaveRegister (source);
	auto target = EvaluatePointer (GetArgument (expression, 1)); SaveRegister (target);
	auto size = EvaluatePointer (GetArgument (expression, 2)); RestoreRegister (target); RestoreRegister (source); Copy (target, source, size);
}

void Context::CallPut (const Expression& expression)
{
	auto target = EvaluatePointer (GetArgument (expression, 0)); SaveRegister (target);
	auto source = EvaluateArgument (expression, 1); RestoreRegister (target);
	Move (MakeMemory (source.type, target), source);
}

void Context::CallSystemDispose (const Expression& expression)
{
	const auto variable = MakeRegister (DesignateArgument (expression, 0)); const auto size = Push (MakeMemory (platform.pointer, variable));
	Move (MakeMemory (platform.pointer, variable), PtrImm {platform.pointer, 0}); Call (Adr {platform.function, "free"}, size);
}

void Context::CallSystemNew (const Expression& expression)
{
	auto pointer = Call (platform.pointer, Adr {platform.function, "malloc"}, Push (Convert (GetType (emitter.platform.systemAddressType), EvaluateArgument (expression, 1)))); SaveRegister (pointer);
	auto variable = DesignateArgument (expression, 0); RestoreRegister (pointer); Move (MakeMemory (platform.pointer, variable), pointer);
}

Context::SmartOperand Context::Designate (const Expression& expression)
{
	if (IsConstant (expression)) return Designate (expression.value, expression);

	switch (expression.model)
	{
	case Expression::Call:
		if (expression.Calls (emitter.platform.globalPtr)) return DesignateArgument (expression, 0);
		if (expression.Calls (emitter.platform.systemVal)) return DesignateArgument (expression, 1);
		return EvaluateCall (expression, Add (emitter.framePointer, platform.stackDisplacement - Displacement (expression.call.temporary)));

	case Expression::Index:
		return DesignateIndex (expression).address;

	case Expression::Selector:
		return Add (Designate (*expression.selector.designator), expression.selector.declaration->variable.offset);

	case Expression::TypeGuard:
	{
		if (!IsPointer (*expression.type)) return DesignateRecord (expression).address;
		auto pointer = Protect (MakeRegister (Designate (*expression.typeGuard.designator))); auto skip = CreateLabel ();
		BranchConditional (DereferenceDescriptor (MakeMemory (platform.pointer, pointer), *expression.typeGuard.designator->type), *expression.type->pointer.baseType, true, skip);
		Trap (TypeGuard); skip (); return Deprotect (pointer);
	}

	case Expression::Identifier:
		return Designate (*expression.identifier.declaration);

	case Expression::Dereference:
		return Evaluate (*expression.dereference.expression);

	case Expression::Parenthesized:
		return Designate (*expression.parenthesized.expression);

	default:
		assert (Expression::Unreachable);
	}
}

Operand Context::Designate (const Value& value, const Expression& expression)
{
	assert (IsString (value)); const auto name = Code::GetName (*value.string);
	if (!InsertUnique (*value.string, cache.strings)) return Adr {platform.pointer, name};
	const RestoreState restoreState {*this}; Comment (expression.position, expression);
	Begin (Section::Const, name, emitter.platform.GetAlignment (emitter.platform.globalCharacterType), false, true);
	Define (*value.string, GetType (emitter.platform.globalCharacterType)); return Adr {platform.pointer, name};
}

Context::SmartOperand Context::Designate (const Declaration& declaration)
{
	if (IsExternal (declaration)) return DesignateExternal (declaration);

	switch (declaration.model)
	{
	case Declaration::Variable:
		if (IsModule (*declaration.scope)) return Adr {platform.pointer, GetName (declaration)};
		return DesignateObject (declaration);

	case Declaration::Procedure:
		return Adr {platform.function, GetName (declaration)};

	case Declaration::Parameter:
		if (IsVariableParameter (declaration) || IsOpenArray (*declaration.parameter.type) || IsStructured (*declaration.parameter.type) && IsReadOnlyParameter (declaration)) return MakeMemory (platform.pointer, DesignateObject (declaration));
		return DesignateObject (declaration);

	default:
		assert (Declaration::Unreachable);
	}
}

Context::SmartOperand Context::DesignateExternal (const Declaration& declaration)
{
	assert (IsExternal (declaration)); assert (IsConstant (*declaration.storage.external));
	const auto type = IsProcedure (declaration) ? Code::Type {platform.function} : Code::Type {platform.pointer};
	if (IsString (declaration.storage.external->value)) return Adr {type, *declaration.storage.external->value.string};
	return Imm (type, declaration.storage.external->value.unsigned_);
}

Context::Array Context::DesignateIndex (const Expression& expression)
{
	assert (IsIndex (expression)); auto skip = CreateLabel ();
	auto array = DesignateArray (*expression.index.designator); SaveRegisters (array.address, array.length);
	const auto index = Convert (array.address.type, Evaluate (*expression.index.expression)); RestoreRegisters (array.address, array.length);
	if (!IsImmediate (array.length) || !IsImmediate (index) && array.length.simm < ECS::ShiftRight (std::numeric_limits<Signed>::max (), (sizeof (Signed) - array.length.type.size) * 8))
		if (!IsZero (index)) BranchLessThan (skip, index, Convert (index.type, array.length)), Trap (Index);
	if (IsOpenArray (*expression.type)) Displace (array.length, GetSize (array.length)); skip ();
	return {Add (array.address, Multiply (index, Convert (platform.pointer, GetArraySize (*expression.type, array.length)))), array.length};
}

Context::SmartOperand Context::DesignateObject (const Declaration& declaration)
{
	assert (IsObject (declaration)); assert (IsProcedure (*declaration.scope));
	if (&declaration == declaration.scope->procedure->procedure.result) return GetResult (*declaration.scope);
	const auto displacement = IsVariable (declaration) ? -Displacement (declaration.variable.offset) : Displacement (platform.GetStackSize (platform.pointer) + platform.GetStackSize (platform.return_) + declaration.parameter.offset);
	return Add (GetFramePointer (*declaration.scope), displacement + platform.stackDisplacement);
}

Context::Array Context::DesignateArray (const Expression& expression)
{
	if (IsConstant (expression)) return DesignateArray (expression.value, expression);

	assert (IsArray (*expression.type));
	if (!IsOpenArray (*expression.type)) return {Designate (expression), Evaluate (*expression.type->array.length)};

	switch (expression.model)
	{
	case Expression::Index:
		return DesignateIndex (expression);

	case Expression::Identifier:
		return DesignateArray (*expression.identifier.declaration);

	case Expression::Dereference:
		return DereferenceArray (*expression.dereference.expression);

	case Expression::Parenthesized:
		return DesignateArray (*expression.parenthesized.expression);

	default:
		assert (Expression::Unreachable);
	}
}

Context::Array Context::DesignateArray (const Value& value, const Expression& expression)
{
	assert (IsString (value)); return {Designate (value, expression), SImm (GetType (emitter.platform.globalLengthType), value.string->size () + 1)};
}

Context::Array Context::DesignateArray (const Declaration& declaration)
{
	assert (IsObject (declaration)); assert (IsOpenArray (*declaration.object.type));
	return {Designate (declaration), MakeMemory (GetType (emitter.platform.globalLengthType), DesignateObject (declaration), platform.GetStackSize (platform.pointer))};
}

Context::Array Context::DereferenceArray (const Expression& expression)
{
	if (IsVariablePointer (*expression.type)) {const auto pointer = MakeRegister (Designate (expression)); return {MakeMemory (platform.pointer, pointer), Protect (MakeMemory (GetType (emitter.platform.globalLengthType), pointer, platform.pointer.size))};}
	auto pointer = MakeRegister (Evaluate (expression)); return {pointer, Protect (MakeMemory (GetType (emitter.platform.globalLengthType), pointer, -Displacement (CountDimensions (*expression.type->pointer.baseType) * platform.pointer.size)))};
}

Operand Context::Evaluate (const Type& type)
{
	assert (IsRecord (type)); return Adr {platform.pointer, IsAlias (type) ? GetCanonicalName (type) : GetName (type)};
}

Context::SmartOperand Context::EvaluateDescriptor (const Expression& expression)
{
	assert (IsRecord (*expression.type));

	switch (expression.model)
	{
	case Expression::Call:
	case Expression::Index:
	case Expression::Selector:
		return Evaluate (*expression.type);

	case Expression::TypeGuard:
	{
		auto descriptor = EvaluateDescriptor (*expression.typeGuard.designator); auto skip = CreateLabel ();
		BranchConditional (descriptor, *expression.type, true, skip);
		Trap (TypeGuard); skip (); return descriptor;
	}

	case Expression::Identifier:
		return DesignateDescriptor (*expression.identifier.declaration);

	case Expression::Dereference:
		return DereferenceDescriptor (*expression.dereference.expression);

	case Expression::Parenthesized:
		return EvaluateDescriptor (*expression.parenthesized.expression);

	default:
		assert (Expression::Unreachable);
	}
}

Context::Record Context::DesignateRecord (const Expression& expression)
{
	assert (IsRecord (*expression.type));

	switch (expression.model)
	{
	case Expression::Call:
	case Expression::Index:
	case Expression::Selector:
		return {Designate (expression), EvaluateDescriptor (expression)};

	case Expression::TypeGuard:
	{
		auto record = DesignateRecord (*expression.typeGuard.designator); auto skip = CreateLabel ();
		BranchConditional (record.descriptor, *expression.type, true, skip);
		Trap (TypeGuard); skip (); return record;
	}

	case Expression::Identifier:
		return DesignateRecord (*expression.identifier.declaration);

	case Expression::Dereference:
		return DereferenceRecord (*expression.dereference.expression);

	case Expression::Parenthesized:
		return DesignateRecord (*expression.parenthesized.expression);

	default:
		assert (Expression::Unreachable);
	}
}

Context::Record Context::DesignateRecord (const Declaration& declaration)
{
	return {Designate (declaration), DesignateDescriptor (declaration)};
}

Context::SmartOperand Context::DesignateDescriptor (const Declaration& declaration)
{
	assert (IsObject (declaration)); assert (IsRecord (*declaration.object.type));
	if (!HasDynamicType (declaration)) return Evaluate (*declaration.object.type);
	return MakeMemory (platform.pointer, DesignateObject (declaration), platform.GetStackSize (platform.pointer));
}

Context::Record Context::DereferenceRecord (const Expression& expression)
{
	if (!IsAny (*expression.type) && !HasDynamicType (*expression.type->pointer.baseType)) return {Evaluate (expression), DereferenceDescriptor (expression)};
	if (IsVariablePointer (*expression.type)) {const auto pointer = MakeRegister (Designate (expression)); return {MakeMemory (platform.pointer, pointer), Protect (MakeMemory (platform.pointer, pointer, platform.pointer.size))};}
	const auto pointer = MakeRegister (Evaluate (expression)); return {pointer, Protect (MakeMemory (platform.pointer, pointer, -Displacement (platform.pointer.size)))};
}

Context::SmartOperand Context::DereferenceDescriptor (const Expression& expression)
{
	if (!IsAny (*expression.type) && !HasDynamicType (*expression.type->pointer.baseType)) return Evaluate (*expression.type->pointer.baseType);
	return DereferenceDescriptor (IsVariablePointer (*expression.type) ? Designate (expression) : Evaluate (expression), *expression.type);
}

Context::SmartOperand Context::DereferenceDescriptor (const Operand& operand, const Type& type)
{
	if (!IsAny (type) && !HasDynamicType (*type.pointer.baseType)) return Evaluate (*type.pointer.baseType);
	if (IsVariablePointer (type)) return MakeMemory (platform.pointer, operand, platform.pointer.size);
	return MakeMemory (platform.pointer, operand, -Displacement (platform.pointer.size));
}

Context::SmartOperand Context::GetFramePointer (const Scope& scope)
{
	assert (IsProcedure (scope)); SmartOperand framePointer = emitter.framePointer;
	for (auto container = currentScope; container != &scope; container = container->parent)
		framePointer = MakeMemory (platform.pointer, framePointer, platform.GetStackSize (platform.pointer) + platform.GetStackSize (platform.return_) + platform.stackDisplacement);
	return framePointer;
}

Context::SmartOperand Context::GetResult (const Scope& scope)
{
	const auto pointer = platform.GetStackSize (platform.pointer), return_ = platform.GetStackSize (platform.return_);
	assert (IsProcedure (scope)); const auto& signature = scope.procedure->procedure.signature; assert (signature.result); assert (IsStructured (*signature.result));
	return MakeMemory (platform.pointer, emitter.framePointer, pointer + return_ + (signature.receiver || signature.parent) * pointer + (signature.receiver && NeedsTypeDescriptor (*signature.receiver)) * pointer + platform.stackDisplacement);
}

Context::TypeBound Context::EvaluateTypeBound (const Expression& expression)
{
	assert (IsTypeBound (*expression.type));

	switch (expression.model)
	{
	case Expression::Super:
	{
		assert (IsProcedure (*expression.super.declaration)); const auto& designator = *expression.super.designator->selector.designator;
		return {Designate (*expression.super.declaration), IsPointer (*designator.type) ? DereferenceRecord (designator) : DesignateRecord (designator)};
	}

	case Expression::Selector:
	{
		assert (IsProcedure (*expression.selector.declaration)); const auto& designator = *expression.selector.designator;
		const auto record = IsPointer (*designator.type) ? DereferenceRecord (designator) : DesignateRecord (designator);
		if (!HasDynamicType (designator) || IsFinal (*expression.selector.declaration)) return {Designate (*expression.selector.declaration), record};
		const auto address = record.address, descriptor = MakeRegister (record.descriptor);
		return {MakeMemory (platform.function, descriptor, ProcedureTableOffset * platform.function.size - Displacement (expression.selector.declaration->procedure.index) * platform.function.size), {address, descriptor}};
	}

	default:
		assert (Expression::Unreachable);
	}
}

void Context::Emit (const Expression& expression, const Operand& value, const Label& label)
{
	if (!IsRange (expression)) return BranchEqual (label, value, Evaluate (expression));
	auto skip = CreateLabel (); BranchLessThan (skip, value, Evaluate (*expression.binary.left)); BranchGreaterEqual (label, Evaluate (*expression.binary.right), value); skip ();
}

void Context::Emit (const Elsif& elsif, const Label& end)
{
	auto skip = CreateLabel ();
	Comment (elsif.position, elsif); Break (module.source, elsif.position);
	BranchConditional (elsif.condition, false, skip);
	Emit (elsif.statements); Branch (end); skip ();
}

void Context::Emit (const Guard& guard, const Label& end, const bool first)
{
	auto skip = CreateLabel (); if (!first) Comment (guard.position, guard), Break (module.source, guard.position);
	if (IsPointer (guard.type)) BranchConditional (DereferenceDescriptor (guard.expression), *guard.type.pointer.baseType, false, skip);
	else BranchConditional (EvaluateDescriptor (guard.expression), guard.type, false, skip);
	Emit (guard.statements); Branch (end); skip ();
}

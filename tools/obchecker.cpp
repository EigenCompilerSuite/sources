// Oberon semantic checker
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

#include "diagnostics.hpp"
#include "error.hpp"
#include "format.hpp"
#include "obchecker.hpp"
#include "obevaluator.hpp"
#include "utilities.hpp"

#include <algorithm>
#include <cassert>
#include <filesystem>
#include <fstream>

using namespace ECS;
using namespace Oberon;

using Context = class Checker::Context : Evaluator
{
public:
	Context (Checker&, Module&, const Context*);

	void Check ();

private:
	struct VariableGuard {const VariableGuard* previous; const Declaration* declaration; Type* type;};

	Checker& checker;
	Module& module;
	const Context*const import;

	Body* currentBody = nullptr;
	Scope* currentScope = nullptr;
	Statement* currentLoop = nullptr;
	const Type* previousType = nullptr;
	const VariableGuard* variableGuard = nullptr;
	std::vector<Type*> pointerTypes;
	std::vector<Type*> recordResultTypes;
	std::vector<Type*> recordElementTypes;
	std::vector<Declaration*> recordObjects;
	std::vector<Statement*> recordAssignments;
	std::vector<Expression*> recordAllocations;
	std::vector<Expression*> typeBoundExpressions;

	void Check (Declaration&);
	void CheckExternal (Declaration&);
	void CheckReceiver (Declaration&);

	void FinalizeCheck (Declaration&);
	void FinalizeCheck (Expression&);
	void FinalizeCheck (Type&);
	void FinalizeChecks ();

	Size Reserve (const Type&, Scope&);
	void Reserve (Declaration&);
	void Reserve (Declarations&);
	void Reserve (Scope&);
	void Reserve (Signature&);

	void Declare (Declaration&, Scope&);

	void Check (Body&);
	void Check (Case&, Labels&, Type&);
	void Check (Declarations&);
	void Check (Expression&, Labels&, Type&);
	void Check (Guard&, const Guards&);
	void Check (Signature&);
	void Check (Statement&);
	void Check (Statements&);

	void Check (QualifiedIdentifier&);
	void CheckType (QualifiedIdentifier&);

	void Check (Type&);
	void CheckPointer (Type&);
	void CheckPointerTypes ();
	void CheckResult (Type&);

	Declaration& Lookup (const Identifier&);
	void LookupImport (const Scope&, const Position&);

	void Check (Expression&);
	void Check (Expression&, Type&, void (Context::*) (Expression&) = &Context::Check);
	void Check (Expression&, bool (*) (const Type&), void (Context::*) (Expression&) = &Context::Check);
	void CheckArgument (Expression&, const Declaration&);
	void CheckCall (Expression&);
	void CheckCondition (Expression&);
	void CheckConstant (Expression&);
	void CheckDereference (Expression&);
	void CheckDesignator (Expression&);
	void CheckElement (Expression&, const Type&);
	void CheckGuard (const Expression&, const Type&);
	void CheckLength (Expression&);
	void CheckModifiable (Expression&);
	void CheckModuleSelector (Expression&);
	void CheckRange (Expression&, const Type&);
	void CheckReal (Expression&, bool (*) (const Type&));
	void CheckStatus (Expression&);
	void CheckType (Expression&);
	void CheckValue (Expression&);
	void CheckVariable (Expression&);

	void CheckArguments (Expression&, Size);
	#define PROCEDURE(scope, procedure, name) void Check##procedure (Expression&);
	#include "oberon.def"

	void FoldConstant (Expression&);
	void Set (Expression&, const Value&);
	void EvaluateIf (bool, Expression&);
	void Model (Expression&, Expression::Model);
	void Attribute (Expression&, Type&, bool = false, bool = false);

	void Promote (Expression&, Type&);
	void Promote (Expression&, Expression&);
	void Dereference (Expression&);

	void Warn (const Body&);
	void Warn (const Declaration&);
	void Warn (const Declarations&);
	void Warn (const Statement&, bool);
	void Warn (const Statements&, bool);
	void Warn (const Type&);

	void CheckReachability (Body&);
	void CheckReachability (Declaration&);
	void CheckReachability (Declarations&);
	bool CheckReachability (Statement&, bool);
	bool CheckReachability (Statements&, bool);
	void CheckReachability (Type&);

	Value Evaluate (const Expression&) override;
	Value Call (const Declaration&, const Expression&, Object*) override;

	void EmitWarning (const Position&, const Message&) const;
	void EmitError [[noreturn]] (const Position&, const Message&) const override;
	void EmitError [[noreturn]] (const Position&, const Message&, const Type&) const;
	void EmitError [[noreturn]] (const Position&, const Message&, const Declaration&) const;
};

Checker::Checker (Diagnostics& d, Charset& c, Platform& p, const SymbolFiles sf) :
	Interpreter {d, c, p},symbolFiles {sf}, importDirectory {std::getenv ("ECSIMPORT")}, parser {diagnostics, false}, printer {true}
{
}

void Checker::EmitFatalError (const Source& source, const Message& message) const
{
	diagnostics.Emit (Diagnostics::FatalError, source, {}, message); throw Error {};
}

void Checker::Check (Module& module)
{
	Remove (module.identifier); Context {*this, module, nullptr}.Check ();
	cache.erase (std::remove (cache.begin (), cache.end (), nullptr), cache.end ());
	modules.erase (std::remove (modules.begin (), modules.end (), nullptr), modules.end ());
	if (symbolFiles) Export (module); else modules.push_back (&module);
}

Scope& Checker::Import (const QualifiedIdentifier& identifier, Expressions*const expressions, const Context& context)
{
	if (const auto scope = platform.GetScope (identifier)) return *scope;
	if (!expressions) for (auto module: modules) if (module && !IsParameterized (*module) && module->identifier == identifier) return *module->scope; else;
	else for (auto module: modules) if (module && IsParameterized (*module) && module->identifier == identifier && *module->expressions == *expressions) return *module->scope;
	for (auto module: modules) if (module && IsGeneric (*module) && !IsParameterized (*module) && module->identifier == identifier) return *Parameterize (*module, expressions, context).scope;
	if (symbolFiles) return *Parameterize (Import (identifier, context), expressions, context).scope; EmitFatalError (identifier.name->string, "unknown module");
}

Module& Checker::Parameterize (Module& module, Expressions*const expressions, const Context& context)
{
	if (!IsGeneric (module) || IsParameterized (module) || !expressions) return module;
	try {return Insert (std::make_unique<Module> (module, *expressions), context);}
	catch (...) {diagnostics.Emit (Diagnostics::Note, module.source, module.identifier.name->position, Format ("while parameterizing generic module '%0'", module.identifier));
		if (module.definitions->size () == expressions->size ()) for (auto& definition: *module.definitions) diagnostics.Emit (Diagnostics::Note, module.source, definition.position, Format ("with parameter '%0' = %1", definition.name, (*expressions)[GetIndex (definition, *module.definitions)].value)); throw;}
}

Module& Checker::Import (const QualifiedIdentifier& identifier, const Context& context)
{
	const auto filename = GetFilename (identifier) + ".sym"; auto source = filename; std::ifstream file;
	if (std::error_code error; !std::filesystem::is_directory (source, error)) file.open (source, file.binary);
	if (std::error_code error; !file.is_open () && importDirectory && !std::filesystem::is_directory (source = importDirectory + filename, error)) file.open (source, file.binary);
	if (!file.is_open ()) EmitFatalError (filename, "failed to open symbol file");
	auto module = std::make_unique<Module> (source);
	parser.Parse (file, {1, 1}, *module); file.close ();
	if (!file) EmitFatalError (source, "failed to read symbol file");
	return Insert (std::move (module), context);
}

void Checker::Export (const Module& module) const
{
	const auto filename = GetFilename (module.identifier) + ".sym";
	if (filename == module.source) return; std::ofstream file {filename};
	if (!file.is_open ()) EmitFatalError (filename, "failed to open symbol file");
	printer.Print (module, file << "(* interface of module " << module.identifier << " *)\n");
	file.close (); if (!file) std::filesystem::remove (filename), EmitFatalError (filename, "failed to write symbol file");
}

Module& Checker::Insert (std::unique_ptr<Module> module, const Context& context)
{
	Context {*this, *module, &context}.Check ();
	modules.push_back (module.get ()); cache.push_back (std::move (module)); return *cache.back ();
}

void Checker::Remove (const QualifiedIdentifier& identifier)
{
	for (auto& module: modules) if (module && module->identifier == identifier) module = nullptr;
	for (auto& module: cache) if (module && module->Imports (identifier)) Remove (module->identifier), module.reset ();
	for (auto& module: cache) if (module && module->identifier == identifier && &identifier != &module->identifier) module.reset ();
}

Context::Context (Checker& c, Module& m, const Context*const i) :
	Evaluator {c}, checker {c}, module {m}, import {i}
{
}

void Context::EmitError (const Position& position, const Message& message) const
{
	checker.diagnostics.Emit (Diagnostics::Error, module.source, position, message); throw Error {};
}

void Context::EmitError (const Position& position, const Message& message, const Type& type) const
{
	assert (IsAbstract (type)); assert (!IsAnonymous (type)); checker.diagnostics.Emit (Diagnostics::Error, module.source, position, message);
	if (type.record.isAbstract) checker.diagnostics.Emit (Diagnostics::Note, GetModule (*type.record.declaration->scope).source, type.record.declaration->position, "declared here as abstract");
	for (auto& object: type.record.scope->objects) if (IsAbstract (*object.second)) checker.diagnostics.Emit (Diagnostics::Note, GetModule (*object.second->scope).source, object.second->position, Format ("with abstract %0", *object.second));
	for (auto baseType = type.record.baseType; baseType; baseType = baseType->record.baseType) for (auto& object: baseType->record.scope->objects)
		if (IsAbstract (*type.record.scope->Lookup (object.second->name, module))) checker.diagnostics.Emit (Diagnostics::Note, GetModule (*object.second->scope).source, object.second->position, Format ("with abstract %0 of base %1", *object.second, *baseType));
	throw Error {};
}

void Context::EmitError (const Position& position, const Message& message, const Declaration& declaration) const
{
	checker.diagnostics.Emit (Diagnostics::Error, module.source, position, message);
	checker.diagnostics.Emit (Diagnostics::Note, GetModule (*declaration.scope).source, declaration.position, Format ("declared here as %0", declaration)); throw Error {};
}

void Context::EmitWarning (const Position& position, const Message& message) const
{
	checker.diagnostics.Emit (Diagnostics::Warning, module.source, position, message);
}

void Context::Check ()
{
	if (checker.platform.GetScope (module.identifier)) EmitError (module.identifier.name->position, Format ("reserved module '%0'", module.identifier));
	for (auto& declaration: module.declarations) if (!IsImport (declaration)) break; else declaration.import.identifier.name = declaration.import.alias ? declaration.import.alias : &declaration.name;
	module.Create (module.scope, module, checker.platform.global); currentScope = module.scope;
	if (IsGeneric (module) && !IsParameterized (module) && (import || !checker.symbolFiles)) return;
	if (IsGeneric (module)) if (!IsParameterized (module)) for (auto& definition: module.parameters.reserve (module.definitions->size ()), *module.definitions)
		Declare (module.parameters.emplace_back (definition, checker.platform.globalGenericType), *currentScope);
	else if (module.definitions->size () != module.expressions->size ()) EmitError (module.identifier.name->position, "mismatched number of parameters");
	else for (auto& expression: module.parameters.reserve (module.expressions->size ()), *module.expressions)
		Declare (module.parameters.emplace_back ((*module.definitions)[GetIndex (expression, *module.expressions)], expression), *currentScope);
	Check (module.declarations); CheckPointerTypes (); if (module.body) Check (*module.body); FinalizeChecks (); Reserve (module.declarations); Reserve (*module.scope);
	if (CheckReachability (module.parameters), CheckReachability (module.declarations), module.body) CheckReachability (*module.body);
	if (!import) if (Warn (module.parameters), Warn (module.declarations), module.body) Warn (*module.body);
}

void Context::Check (Declarations& declarations)
{
	const Restore restore {previousType, nullptr};
	Batch (declarations, [this] (Declaration& declaration) {Check (declaration);});
	Batch (declarations, [this] (Declaration& declaration) {FinalizeCheck (declaration);});
}

void Context::Check (Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
	{
		if (declaration.import.expressions) for (auto& expression: *declaration.import.expressions) CheckConstant (expression); const auto& identifier = declaration.import.identifier;
		for (const Context* context = this; context; context = context->import) if (context->module.identifier == identifier) EmitError (identifier.name->position, Format ("module '%0' imports itself", identifier));
		try {declaration.import.scope = &checker.Import (identifier, declaration.import.expressions, *this);}
		catch (...) {checker.diagnostics.Emit (Diagnostics::Note, module.source, identifier.name->position, Format ("while importing module '%0'", identifier)); throw;} const auto& scope = *declaration.import.scope;
		if (IsModule (scope) && scope.module->identifier != identifier) EmitError (identifier.name->position, Format ("identifier '%0' does not match '%1'", identifier, scope.module->identifier));
		if (declaration.import.expressions && (!IsModule (scope) || !IsGeneric (*scope.module))) EmitError (identifier.name->position, Format ("parameterizing non-generic module '%0'", identifier));
		if (!declaration.import.expressions && IsModule (scope) && IsGeneric (*scope.module)) EmitError (identifier.name->position, Format ("missing parameters for generic module '%0'", identifier));
		return Declare (declaration, *currentScope);
	}

	case Declaration::Constant:
		assert (declaration.constant.expression);
		CheckConstant (*declaration.constant.expression);
		return Declare (declaration, *currentScope);

	case Declaration::Type:
		assert (declaration.type);
		if (IsPointer (*declaration.type) || IsProcedure (*declaration.type)) Declare (declaration, *currentScope), Check (*declaration.type);
		else Check (*declaration.type), Declare (declaration, *currentScope);
		if (IsRecord (declaration)) declaration.type->record.declaration = &declaration;
		return;

	case Declaration::Variable:
		assert (declaration.variable.type);
		if (declaration.variable.isForward) declaration.variable.definition = nullptr;
		if (declaration.variable.type != previousType) Check (*declaration.variable.type), previousType = declaration.variable.type;
		if (IsOpenArray (*declaration.variable.type)) EmitError (declaration.position, "variable of open array type");
		if (IsAnonymous (*declaration.variable.type)) InsertUnique (declaration.variable.type, module.anonymousTypes);
		if (IsExternal (declaration)) CheckExternal (declaration);
		if (IsRecord (*declaration.variable.type)) recordObjects.push_back (&declaration);
		return Declare (declaration, *currentScope);

	case Declaration::Procedure:
	{
		CheckPointerTypes ();
		declaration.procedure.index = 0;
		declaration.procedure.result = nullptr;
		auto& signature = declaration.procedure.signature;
		module.Create (signature.scope, signature, *currentScope);
		signature.parent = IsProcedure (*currentScope) ? currentScope->procedure : nullptr;
		module.Create (declaration.procedure.type, signature);
		if (IsExternal (declaration)) CheckExternal (declaration);
		if (declaration.procedure.isForward) declaration.procedure.definition = nullptr;
		const Restore restoreScope {currentScope, signature.scope}; Check (signature); CheckPointerTypes ();
		if (declaration.procedure.isAbstract && !signature.receiver) EmitError (declaration.position, "abstract non-type-bound procedure");
		if (declaration.procedure.isFinal && !signature.receiver) EmitError (declaration.position, "final non-type-bound procedure");
		if (signature.receiver && IsLocal (*signature.scope->parent)) EmitError (declaration.position, "local type-bound procedure");
		Declare (declaration, !signature.receiver ? *signature.scope->parent : IsRecordPointer (*signature.receiver->parameter.type) ? *signature.receiver->parameter.type->pointer.baseType->record.scope : *signature.receiver->parameter.type->record.scope);
		signature.scope->model = Scope::Procedure; signature.scope->procedure = &declaration;
		if (declaration.procedure.isAbstract || declaration.procedure.isForward) return;
		if (declaration.procedure.declarations) Check (*declaration.procedure.declarations), CheckPointerTypes ();
		if (declaration.procedure.body) Check (*declaration.procedure.body);
		return;
	}

	case Declaration::Parameter:
		assert (declaration.parameter.type); assert (IsSignature (*currentScope));
		if (declaration.parameter.type != previousType) Check (*declaration.parameter.type), previousType = declaration.parameter.type;
		if (IsAnonymous (*declaration.parameter.type)) InsertUnique (declaration.parameter.type, module.anonymousTypes);
		if (!IsVariableParameter (declaration) && IsRecord (*declaration.parameter.type)) recordObjects.push_back (&declaration);
		return Declare (declaration, *currentScope);

	default:
		assert (Declaration::Unreachable);
	}
}

Size Context::Reserve (const Type& type, Scope& scope)
{
	assert (IsProcedure (scope) || IsModule (scope));
	const auto alignment = checker.platform.GetStackAlignment (type); scope.alignment = std::max (scope.alignment, alignment);
	return scope.size = Align (scope.size, alignment) + checker.platform.GetSize (type);
}

void Context::Reserve (Declaration& declaration)
{
	if (IsAbstract (declaration) || IsForward (declaration)) return; if (IsProcedure (declaration)) return Reserve (declaration.procedure.signature);
	if (!IsObject (declaration)) return; auto& scope = *declaration.scope; declaration.object.index = scope.count++;
	if (IsModule (scope) || IsProcedure (scope) && &declaration == scope.procedure->procedure.result) return;
	const auto alignment = checker.platform.GetAlignment (declaration), offset = Align (scope.size, alignment);
	scope.size = offset + checker.platform.GetSize (declaration); scope.alignment = std::max (scope.alignment, alignment);
	declaration.object.offset = IsVariable (declaration) && IsProcedure (scope) ? scope.alignment = std::max (scope.alignment, checker.platform.GetStackAlignment (*declaration.variable.type)), scope.size : offset;
	if (IsVariable (declaration)) scope.needsInitialization |= NeedsInitialization (*declaration.variable.type);
}

void Context::Reserve (Declarations& declarations)
{
	for (auto& declaration: declarations) Reserve (declaration);
}

void Context::Reserve (Scope& scope)
{
	scope.size = Align (scope.size, scope.alignment);
}

void Context::Reserve (Signature& signature)
{
	auto& scope = *signature.scope; assert (IsProcedure (scope));
	if (const auto declarations = scope.procedure->procedure.declarations) Reserve (*declarations); Reserve (scope);
	const Restore restoreSize {scope.size, 0}, restoreCount {scope.count, 0}, restoreAlignment {scope.alignment, 1};
	if (signature.receiver) Reserve (*signature.receiver);
	if (signature.parent) Reserve (checker.platform.systemPointerType, scope);
	if (signature.result && IsStructured (*signature.result)) Reserve (checker.platform.systemPointerType, scope);
	if (signature.parameters) Reserve (*signature.parameters);
}

void Context::CheckReceiver (Declaration& declaration)
{
	assert (IsParameter (declaration)); Check (declaration); const auto& type = *declaration.parameter.type;
	if (!IsRecord (type) && !IsRecordPointer (type)) EmitError (type.position, Format ("%0 of %1", declaration, type));
	if (IsVariableParameter (declaration) != IsRecord (type)) EmitError (declaration.position, Format ("%0 of %1 type", declaration, type.model));
	const auto scope = IsRecordPointer (type) ? type.pointer.baseType->record.scope : type.record.scope; assert (scope);
	if (!scope->BelongsTo (module)) EmitError (declaration.position, Format ("record type of %0 not declared in same module", declaration));
}

void Context::CheckExternal (Declaration& declaration)
{
	assert (IsExternal (declaration)); auto& expression = *declaration.storage.external;
	if (!IsModule (*currentScope)) EmitError (declaration.position, "non-global external declaration");
	CheckConstant (expression); LookupImport (checker.platform.system, expression.position); if (IsGeneric (expression) || IsString (*expression.type)) return;
	if (!expression.IsExpressionCompatibleWith (checker.platform.systemAddressType)) EmitError (expression.position, Format ("external address '%0' of %1", expression, *expression.type));
	Promote (expression, checker.platform.systemAddressType);
	if (expression.value.unsigned_ % checker.platform.GetAlignment (*declaration.storage.type)) EmitError (expression.position, Format ("misaligned address '%0' for %1", expression, *declaration.storage.type));
}

void Context::FinalizeCheck (Type& type)
{
	assert (IsRecord (type)); assert (!IsAlias (type)); assert (!type.record.procedures);
	if (const auto baseType = type.record.baseType) if (IsRecord (*baseType)) type.record.procedures = baseType->record.declaration->type->record.procedures, type.record.abstractions = baseType->record.declaration->type->record.abstractions;
	for (auto& object: type.record.scope->objects) if (!IsUndefined (*object.second)) FinalizeCheck (*object.second);
	if (IsFinal (type) && IsAbstract (type)) EmitError (type.position, "final abstract record type");
}

void Context::FinalizeCheck (Declaration& declaration)
{
	if (IsRecord (declaration)) return FinalizeCheck (*declaration.type);
	if (IsUndefined (declaration)) EmitError (declaration.position, "undefined forward declaration");
	if (IsForward (declaration) && declaration.storage.definition || !IsTypeBound (declaration) || declaration.procedure.index) return;
	auto& type = *declaration.scope->record; assert (!IsAlias (type)); const auto baseType = declaration.scope->record->record.baseType;
	const auto definition = declaration.procedure.definition = baseType && IsRecord (*baseType) ? baseType->record.scope->Lookup (declaration.name, module) : nullptr;
	type.record.procedures += !IsFinal (declaration) && !definition; declaration.procedure.index = definition ? definition->procedure.index : type.record.procedures;
	type.record.abstractions += IsAbstract (declaration); if (!definition) return; type.record.abstractions -= IsAbstract (*definition);
	if (!declaration.procedure.signature.Matches (definition->procedure.signature)) EmitError (declaration.position, "mismatched formal parameters");
	if (IsAbstract (declaration) && !IsAbstract (*definition)) EmitError (declaration.position, "invalid abstraction");
	if (IsFinal (*definition)) EmitError (declaration.position, "redefining final procedure");
	if (IsExported (*definition) && IsExported (*declaration.procedure.signature.receiver->parameter.type->identifier->declaration) && !IsExported (declaration)) EmitError (declaration.position, "mismatched export");
}

void Context::FinalizeCheck (Expression& expression)
{
	if (IsCall (expression)) return FinalizeCheck (*expression.call.designator);
	if (IsSelector (expression)) if (const auto type = expression.selector.designator->type) return --expression.selector.declaration->uses,
		expression.selector.declaration = (IsPointer (*type) ? type->pointer.baseType : type)->record.scope->Lookup (*expression.selector.identifier, module), void (++expression.selector.declaration->uses);
	assert (IsSuper (expression)); assert (expression.super.designator); assert (IsSelector (*expression.super.designator));
	const auto declaration = expression.super.designator->selector.declaration; assert (declaration);
	assert (IsTypeBound (*declaration)); expression.super.declaration = declaration->procedure.definition;
	if (!expression.super.declaration) EmitError (expression.position, Format ("denoting undefined %0", *declaration));
	if (IsAbstract (*expression.super.declaration)) EmitError (expression.position, Format ("denoting abstract %0", *expression.super.declaration));
	--declaration->uses; ++expression.super.declaration->uses;
}

void Context::FinalizeChecks ()
{
	for (auto type: module.anonymousTypes) FinalizeCheck (*type);
	for (auto expression: typeBoundExpressions) FinalizeCheck (*expression);
	for (auto type: recordResultTypes) if (IsAbstract (*type)) EmitError (type->position, Format ("abstract %0 as result type", *type), *type);
	for (auto type: recordElementTypes) if (IsAbstract (*type)) EmitError (type->position, Format ("abstract %0 as array element type", *type), *type);
	for (auto declaration: recordObjects) if (IsAbstract (*declaration->object.type)) EmitError (declaration->position, Format ("%0 of abstract %1", *declaration, *declaration->object.type), *declaration->object.type);
	for (auto expression: recordAllocations) if (IsAbstract (*expression->type->pointer.baseType)) EmitError (expression->position, Format ("allocating abstract %0", *expression->type->pointer.baseType), *expression->type->pointer.baseType);
	for (auto statement: recordAssignments) if (IsAbstract (*statement->assignment.designator->type)) EmitError (statement->position, Format ("assigning to variable of abstract %0", *statement->assignment.designator->type), *statement->assignment.designator->type);
}

void Context::Declare (Declaration& declaration, Scope& scope)
{
	declaration.scope = &scope;
	if (const auto previous = scope.Lookup (declaration.name, module))
		if (IsProcedure (declaration) && previous->scope != &scope) scope.objects.insert ({declaration.name.string, &declaration});
		else if (!IsForward (*previous)) EmitError (declaration.name.position, Format ("redeclaration of identifier '%0'", declaration.name), *previous);
		else if (!previous->IsIdenticalTo (declaration)) EmitError (declaration.position, "unidentical forward declaration", *previous);
		else scope.objects[declaration.name.string] = previous->storage.definition = &declaration, declaration.uses = previous->uses;
	else scope.objects.insert ({declaration.name.string, &declaration});
	if (IsExported (declaration) && IsLocal (scope)) EmitError (declaration.position, Format ("exporting local %0", declaration));
}

void Context::Check (Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Set:
	{
		if (expression.set.identifier) CheckType (*expression.set.identifier);
		auto& type = expression.set.identifier ? *expression.set.identifier->type : checker.platform.globalSet64Type;
		if (!IsSet (type) && !IsGeneric (type)) EmitError (expression.position, Format ("set constructor using %0 type", type.model));
		if (expression.set.elements) for (auto& element: *expression.set.elements) if (IsRange (element)) CheckRange (element, type); else CheckElement (element, type);
		return Attribute (expression, expression.set.identifier ? type : checker.platform.globalSetType);
	}

	case Expression::Call:
		assert (expression.call.designator);
		CheckDesignator (*expression.call.designator);
		return CheckCall (expression);

	case Expression::Index:
	{
		assert (expression.index.designator); assert (expression.index.expression);
		auto& designator = *expression.index.designator; CheckDesignator (designator); if (IsDereferencable (*designator.type)) Dereference (designator);
		auto& index = *expression.index.expression; Check (index, checker.platform.globalLengthType);
		if (IsGeneric (designator)) return Attribute (expression, checker.platform.globalGenericType, true, IsReadOnly (designator));
		if (!IsArray (*designator.type)) EmitError (expression.position, Format ("index applied on %0 type", designator.type->model));
		if (IsConstant (index) && !IsGeneric (index) && (index.value.signed_ < 0 || !IsOpenArray (*designator.type) && index.value.signed_ >= designator.type->array.length->value.signed_))
			EmitError (index.position, Format ("invalid constant array element index '%0'", index));
		return Attribute (expression, *designator.type->array.elementType, true, IsReadOnly (designator));
	}

	case Expression::Unary:
	{
		assert (expression.unary.operand);
		auto& operand = *expression.unary.operand;

		CheckValue (operand);
		if (IsGeneric (operand)) return Attribute (expression, IsBoolean (expression.unary.operator_) ? checker.platform.globalBooleanType : checker.platform.globalGenericType);
		auto& type = *operand.type;

		switch (expression.unary.operator_)
		{
		case Lexer::Plus:
			if (IsArithmetic (type)) return Attribute (expression, type);
			break;
		case Lexer::Minus:
			if (IsArithmetic (type) && !IsUnsigned (type)) return Attribute (expression, type);
			break;
		case Lexer::Not:
			if (IsBoolean (type)) return Attribute (expression, checker.platform.globalBooleanType);
			break;
		default:
			assert (Lexer::UnreachableOperator);
		}

		EmitError (expression.position, Format ("applying unary %0 on %1 type", expression.unary.operator_, type.model));
	}

	case Expression::Binary:
	{
		assert (expression.binary.left); assert (expression.binary.right);
		auto &left = *expression.binary.left, &right = *expression.binary.right;

		switch (expression.binary.operator_)
		{
		case Lexer::Slash: CheckReal (left, IsArithmetic); CheckReal (right, IsArithmetic); break;
		case Lexer::In: CheckValue (right); CheckElement (left, IsSet (*right.type) ? *right.type : checker.platform.globalSetType); break;
		case Lexer::Is: Check (left); CheckType (right); break;
		default: CheckValue (left); CheckValue (right);
		}

		if (IsGeneric (left) || IsGeneric (right)) return Attribute (expression, IsBoolean (expression.binary.operator_) ? checker.platform.globalBooleanType : checker.platform.globalGenericType);
		if (!IsType (left) && !IsType (right)) Promote (left, right);
		auto &leftType = *left.type, &rightType = *right.type;

		switch (expression.binary.operator_)
		{
		case Lexer::Plus:
		case Lexer::Minus:
		case Lexer::Asterisk:
		case Lexer::Slash:
			if (IsNumeric (leftType) && IsNumeric (rightType)) return Attribute (expression, leftType);
			if (IsSet (leftType) && IsSet (rightType)) return Attribute (expression, leftType);
			break;
		case Lexer::Div:
		case Lexer::Mod:
			if (IsInteger (leftType) && IsInteger (rightType)) return Attribute (expression, leftType);
			break;
		case Lexer::Or:
		case Lexer::And:
			if (IsBoolean (leftType) && IsBoolean (rightType)) return Attribute (expression, checker.platform.globalBooleanType);
			break;
		case Lexer::Equal:
		case Lexer::Unequal:
			if (left.IsExpressionCompatibleWith (rightType) || right.IsExpressionCompatibleWith (leftType)) return Attribute (expression, checker.platform.globalBooleanType);
		case Lexer::Less:
		case Lexer::LessEqual:
		case Lexer::Greater:
		case Lexer::GreaterEqual:
			if (IsCharacter (leftType) && IsCharacter (rightType)) return Attribute (expression, checker.platform.globalBooleanType);
			if (IsSimple (leftType) && IsSimple (rightType)) return Attribute (expression, checker.platform.globalBooleanType);
			if (IsStringable (leftType) && IsStringable (rightType)) return Attribute (expression, checker.platform.globalBooleanType);
			break;
		case Lexer::In:
			if (IsInteger (leftType) && IsSet (rightType)) return Attribute (expression, checker.platform.globalBooleanType);
			break;
		case Lexer::Is:
			if (!IsType (left)) CheckGuard (left, rightType);
			return Attribute (expression, checker.platform.globalBooleanType);
		default:
			assert (Lexer::UnreachableOperator);
		}

		if (leftType.model == rightType.model) EmitError (expression.position, Format ("applying binary %0 on incompatible %1 types", expression.binary.operator_, leftType.model));
		EmitError (expression.position, Format ("applying binary %0 on %1 and %2 types", expression.binary.operator_, leftType.model, rightType.model));
	}

	case Expression::Literal:
		assert (expression.literal);

		switch (expression.literal->symbol)
		{
		case Lexer::Nil:
			Set (expression, nullptr);
			return Attribute (expression, checker.platform.globalNilType);
		case Lexer::Integer: case Lexer::BinaryInteger: case Lexer::HexadecimalInteger:
		{
			Unsigned value;
			if (!Lexer::Evaluate (*expression.literal, value))
				EmitError (expression.position, Format ("%0 cannot be represented by an integer type", *expression.literal));
			if (Signed (value) >= 0) Set (expression, Signed (value)); else Set (expression, value);
			return Attribute (expression, checker.platform.GetType (value));
		}
		case Lexer::Real:
		{
			Real value;
			if (!Lexer::Evaluate (*expression.literal, value))
				EmitError (expression.position, Format ("%0 cannot be represented by a real type", *expression.literal));
			Set (expression, value);
			return Attribute (expression, checker.platform.GetType (value));
		}
		case Lexer::Character:
		{
			Unsigned value;
			if (!Lexer::Evaluate (*expression.literal, value) || !TruncatesPreserving (value, checker.platform.globalCharacterType.character.size * 8))
				EmitError (expression.position, Format ("%0 cannot be represented by a character type", *expression.literal));
			Set (expression, Character (value));
			return Attribute (expression, checker.platform.globalCharacterType);
		}
		case Lexer::SingleQuotedString: case Lexer::DoubleQuotedString:
			Set (expression, expression.literal->string);
			return Attribute (expression, checker.platform.globalStringType);
		default:
			assert (Lexer::UnreachableLiteral);
		}

	case Expression::Selector:
	{
		assert (expression.selector.designator); assert (expression.selector.identifier);
		auto& designator = *expression.selector.designator; CheckDesignator (designator);
		if (IsGeneric (designator)) return Attribute (expression, checker.platform.globalGenericType);
		if (IsModule (designator.value)) return CheckModuleSelector (expression);
		auto& type = IsPointer (*designator.type) ? *designator.type->pointer.baseType : *designator.type;
		if (!IsRecord (type)) EmitError (designator.position, Format ("'%0' does not denote a record", designator));
		const auto declaration = expression.selector.declaration = type.record.scope->Lookup (*expression.selector.identifier, module);
		if (!declaration) for (auto baseType = type.record.baseType; baseType; baseType = baseType->record.baseType) if (IsGeneric (*baseType)) return Attribute (expression, checker.platform.globalGenericType);
		if (!declaration) EmitError (expression.selector.identifier->position, Format ("undeclared field '%0' in %1", *expression.selector.identifier, type)); ++declaration->uses;
		if (IsProcedure (*declaration)) if (const auto receiver = declaration->procedure.signature.receiver)
			if (IsDereferencable (*designator.type) && IsRecord (*receiver->parameter.type)) Dereference (designator);
			else if (!designator.type->Extends (*receiver->parameter.type)) EmitError (designator.position, Format ("using '%0' of %1 as %2", designator, *designator.type, *receiver));
			else if (IsReadOnly (designator) && !IsReadOnlyParameter (*receiver) && IsRecord (*receiver->parameter.type)) EmitError (designator.position, Format ("using read-only '%0' for %1 of %2", designator, *receiver, *declaration));
		if (IsTypeBound (*declaration) && declaration->scope != type.record.scope && type.record.scope->parent == module.scope) typeBoundExpressions.push_back (&expression);
		if (IsProcedure (*declaration)) return Attribute (expression, *declaration->procedure.type);
		assert (IsVariable (*declaration)); if (IsDereferencable (*designator.type)) Dereference (designator);
		return Attribute (expression, *declaration->variable.type, true, IsReadOnly (designator) || IsReadOnly (*declaration, module));
	}

	case Expression::TypeGuard:
		assert (expression.typeGuard.designator); assert (expression.typeGuard.identifier);
		CheckType (*expression.typeGuard.identifier); CheckGuard (*expression.typeGuard.designator, *expression.typeGuard.identifier->type);
		return Attribute (expression, *expression.typeGuard.identifier->type, IsVariable (*expression.typeGuard.designator) && !IsPointer (*expression.typeGuard.identifier->type), IsReadOnly (*expression.typeGuard.designator));

	case Expression::Conversion:
		assert (expression.conversion.designator); assert (IsType (*expression.conversion.designator)); assert (expression.conversion.expression);
		Check (*expression.conversion.expression, IsBasic, &Context::CheckValue);
		return Attribute (expression, *expression.conversion.designator->type);

	case Expression::Identifier:
	{
		Check (expression.identifier); auto& declaration = *expression.identifier.declaration;
		if (IsImport (declaration)) return Attribute (expression, checker.platform.globalModuleType);
		if (IsConstant (declaration)) return Attribute (expression, *declaration.constant.expression->type);
		if (IsType (declaration)) return module.Create (expression.type, expression.position, expression.identifier), Check (*expression.type), Attribute (expression, *expression.type);
		if (IsProcedure (declaration)) return Attribute (expression, *declaration.procedure.type);
		if (!IsObject (declaration)) EmitError (expression.position, Format ("identifier '%0' does not name a variable", expression.identifier));
		auto type = declaration.object.type; for (auto guard = variableGuard; guard; guard = guard->previous) if (guard->declaration == &declaration) {type = guard->type; break;}
		return Attribute (expression, *type, true, IsReadOnly (declaration, module));
	}

	case Expression::Dereference:
	{
		assert (expression.dereference.expression);
		auto& reference = *expression.dereference.expression; CheckDesignator (reference);
		if (IsSelector (reference) && IsProcedure (*reference.selector.declaration) && IsReceiver (*reference.selector.designator))
			return Model (expression, Expression::Super), expression.super.designator = &reference, typeBoundExpressions.push_back (&expression), Attribute (expression, *reference.selector.declaration->procedure.type);
		return CheckDereference (expression);
	}

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		Check (*expression.parenthesized.expression);
		return Attribute (expression, *expression.parenthesized.expression->type, IsVariable (*expression.parenthesized.expression), IsReadOnly (*expression.parenthesized.expression));

	default:
		assert (Expression::Unreachable);
	}
}

void Context::CheckModuleSelector (Expression& expression)
{
	assert (IsSelector (expression)); assert (expression.selector.designator);
	auto& designator = *expression.selector.designator; assert (IsIdentifier (designator)); assert (IsModule (designator.value));
	expression.model = Expression::Identifier; expression.identifier.name = expression.selector.identifier; expression.identifier.parent = &designator.identifier; Check (expression);
}

void Context::Model (Expression& expression, const Expression::Model model)
{
	expression.model = model; expression.value = {};
}

void Context::Set (Expression& expression, const Value& value)
{
	assert (IsValid (value)); expression.value = value;
}

void Context::EvaluateIf (const bool condition, Expression& expression)
{
	assert (!IsConstant (expression));
	if (condition) Set (expression, Evaluator::Evaluate (expression));
}

void Context::Attribute (Expression& expression, Type& type, const bool isVariable, const bool isReadOnly)
{
	expression.type = &type; expression.isVariable = isVariable; expression.isReadOnly = isReadOnly; FoldConstant (expression);
	if (IsConstant (expression) && !IsType (expression) && IsArithmetic (type))
		if (IsExplicitlyTyped (expression)) expression.value = Truncate (expression.value, *expression.type);
		else if (expression.type = &checker.platform.GetType (expression.value), expression.type->IsSameAs (type)) expression.type = &type;
}

void Context::FoldConstant (Expression& expression)
{
	if (IsGeneric (expression)) return Set (expression, *expression.type);

	switch (expression.model)
	{
	case Expression::Set:
		if (expression.set.elements && IsGeneric (*expression.set.elements)) return Set (expression, checker.platform.globalGenericType);
		return EvaluateIf (!expression.set.elements || IsConstant (*expression.set.elements), expression);

	case Expression::Call:
	{
		assert (expression.call.designator);
		if (expression.call.arguments && IsGeneric (*expression.call.arguments)) return Set (expression, checker.platform.globalGenericType);
		const auto& designator = *expression.call.designator; const auto array = GetOptionalArgument (expression, 0), dimension = GetOptionalArgument (expression, 1);
		return EvaluateIf (IsValid (*expression.type) && IsConstant (designator) && designator.value.procedure && IsPredeclared (*designator.value.procedure) && designator.value.procedure != &checker.platform.systemBit && designator.value.procedure != &checker.platform.systemVal &&
			expression.call.arguments && (IsConstant (*expression.call.arguments) || designator.value.procedure == &checker.platform.globalLen && !IsOpenArray (GetArray (*array->type, dimension ? dimension->value.signed_ : 0))), expression);
	}

	case Expression::Index:
	case Expression::Super:
	case Expression::Selector:
	case Expression::TypeGuard:
	case Expression::Dereference:
		return assert (!IsConstant (expression));

	case Expression::Unary:
		assert (expression.unary.operand);
		if (IsGeneric (*expression.unary.operand)) return Set (expression, checker.platform.globalGenericType);
		return EvaluateIf (IsConstant (*expression.unary.operand), expression);

	case Expression::Binary:
		assert (expression.binary.left); assert (expression.binary.right);
		if (expression.binary.operator_ == Lexer::Or && IsTrue (*expression.binary.left) || expression.binary.operator_ == Lexer::And && IsFalse (*expression.binary.left)) return Set (expression, expression.binary.left->value);
		if (IsGeneric (*expression.binary.left) || IsGeneric (*expression.binary.right)) return Set (expression, checker.platform.globalGenericType);
		return EvaluateIf (IsConstant (*expression.binary.left) && IsConstant (*expression.binary.right), expression);

	case Expression::Literal:
		return assert (IsConstant (expression));

	case Expression::Promotion:
		assert (expression.promotion.expression);
		if (IsString (*expression.type)) return Set (expression, module.Create<String> (String (1, expression.promotion.expression->value.character)));
		return EvaluateIf (IsConstant (*expression.promotion.expression), expression);

	case Expression::Conversion:
		assert (expression.conversion.expression);
		if (IsGeneric (*expression.conversion.expression)) return Set (expression, checker.platform.globalGenericType);
		return EvaluateIf (IsConstant (*expression.conversion.expression), expression);

	case Expression::Identifier:
		assert (expression.identifier.declaration);
		if (IsImport (*expression.identifier.declaration)) return Set (expression, *expression.identifier.declaration);
		if (IsType (*expression.identifier.declaration)) return Set (expression, expression.type == &checker.platform.globalProcedureType ? *expression.identifier.declaration->type : *expression.type);
		return EvaluateIf (IsConstant (*expression.identifier.declaration) || IsProcedure (*expression.identifier.declaration), expression);

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return EvaluateIf (IsConstant (*expression.parenthesized.expression), expression);

	default:
		assert (Expression::Unreachable);
	}
}

Value Context::Evaluate (const Expression& expression)
{
	assert (IsConstant (expression)); return expression.value;
}

Value Context::Call (const Declaration&, const Expression& expression, Object*const)
{
	EmitError (expression.position, "calling procedure");
}

void Context::CheckCondition (Expression& expression)
{
	CheckValue (expression); if (IsGeneric (expression)) return;
	if (!IsBoolean (*expression.type)) EmitError (expression.position, Format ("conditional expression of %0 type", expression.type->model));
}

void Context::CheckConstant (Expression& expression)
{
	Check (expression);
	if (!IsConstant (expression)) EmitError (expression.position, Format ("expression '%0' is not constant", expression));
}

void Context::CheckLength (Expression& expression)
{
	CheckConstant (expression);
	if (IsSigned (expression.value) && expression.value < Signed (0)) EmitError (expression.position, "negative array length");
	if (IsZero (expression.value)) EmitError (expression.position, "invalid array length");
}

void Context::CheckElement (Expression& expression, const Type& type)
{
	Check (expression, IsInteger, &Context::CheckValue); if (IsGeneric (expression) || IsGeneric (type)) return; assert (IsSet (type));
	if (IsConstant (expression) && (IsSigned (*expression.type) ? expression.value.signed_ : expression.value.unsigned_) >= Unsigned (type.set.size * 8)) EmitError (expression.position, "constant set element exceeding valid range");
}

void Context::Dereference (Expression& expression)
{
	assert (IsDereferencable (*expression.type)); module.Create (expression.dereference.expression, expression);
	Model (expression, Expression::Dereference); CheckDereference (expression);
}

void Context::CheckDereference (Expression& expression)
{
	assert (IsDereference (expression)); assert (expression.dereference.expression); auto& type = *expression.dereference.expression->type;
	if (IsGeneric (type)) return Attribute (expression, checker.platform.globalGenericType, true, false);
	if (!IsDereferencable (type)) EmitError (expression.position, Format ("dereferencing %0 type", type.model));
	Attribute (expression, *type.pointer.baseType, true, type.pointer.isReadOnly);
}

void Context::CheckDesignator (Expression& expression)
{
	Check (expression);
	if (IsCall (expression) && !expression.Calls (checker.platform.systemVal)) EmitError (expression.position, Format ("invalid designator '%0'", expression));
}

void Context::CheckVariable (Expression& expression)
{
	CheckValue (expression); if (IsGeneric (expression)) return;
	if (!IsVariable (expression)) EmitError (expression.position, Format ("expression '%0' does not denote a variable", expression));
}

void Context::CheckModifiable (Expression& expression)
{
	CheckVariable (expression);
	if (IsReadOnly (expression)) EmitError (expression.position, Format ("expression '%0' is read-only", expression));
}

void Context::CheckReal (Expression& expression, bool (*const predicate) (const Type&))
{
	Check (expression, predicate, &Context::CheckValue); if (IsGeneric (expression)) return;
	if (IsInteger (*expression.type)) Promote (expression, checker.platform.globalReal32Type);
}

void Context::Check (Expression& expression, Type& type, void (Context::*const check) (Expression&))
{
	(this->*check) (expression); if (IsGeneric (expression) || IsGeneric (type)) return;
	if (!expression.IsExpressionCompatibleWith (type)) EmitError (expression.position, Format ("expression '%0' of %1", expression, *expression.type));
	Promote (expression, type);
}

void Context::Check (Expression& expression, bool (*const predicate) (const Type&), void (Context::*const check) (Expression&))
{
	(this->*check) (expression); if (IsGeneric (expression)) return;
	if (!predicate (*expression.type)) EmitError (expression.position, Format ("expression '%0' of %1", expression, *expression.type));
}

void Context::CheckStatus (Expression& expression)
{
	Check (expression, checker.platform.globalIntegerType, &Context::CheckConstant); if (IsGeneric (expression)) return;
	if (expression.value.signed_ < 0 || expression.value.signed_ > 255) EmitError (expression.position, Format ("invalid status number '%0'", expression));
}

void Context::CheckType (Expression& expression)
{
	Check (expression); if (IsGeneric (expression)) return;
	if (!IsType (expression)) EmitError (expression.position, Format ("expression '%0' does not denote a type", expression));
}

void Context::CheckValue (Expression& expression)
{
	Check (expression); if (IsGeneric (expression)) return;
	if (IsType (expression)) EmitError (expression.position, Format ("expression '%0' denotes a type", expression));
}

void Context::CheckRange (Expression& expression, const Type& type)
{
	assert (IsRange (expression)); assert (expression.binary.left); assert (expression.binary.right);
	CheckElement (*expression.binary.left, type); CheckElement (*expression.binary.right, type);
}

void Context::CheckGuard (const Expression& expression, const Type& type)
{
	if (!IsRecord (type) && !IsRecordPointer (type)) EmitError (type.position, Format ("type guard of %0", type));
	if (!HasDynamicType (expression)) EmitError (expression.position, Format ("expression '%0' does not have a dynamic type", expression));
	if (!type.Extends (*expression.type) && !IsAny (*expression.type)) EmitError (type.position, Format ("%0 does not extend '%1' of %2", type, expression, *expression.type));
}

void Context::CheckCall (Expression& expression)
{
	assert (IsCall (expression)); assert (expression.call.designator); auto& designator = *expression.call.designator;
	if (IsType (designator) && IsBasic (*designator.type)) return CheckArguments (expression, 1), expression.conversion.expression = &GetArgument (expression, 0), Model (expression, Expression::Conversion), expression.conversion.designator = &designator, Check (expression);
	if (IsTypeGuardCall (expression) && IsVariable (designator) && !IsProcedure (*designator.type)) return expression.typeGuard.identifier = &GetArgument (expression, 0), Model (expression, Expression::TypeGuard), expression.typeGuard.designator = &designator, Check (expression);
	if (IsGeneric (designator) && expression.call.arguments) Batch (*expression.call.arguments, [this] (Expression& argument) {Check (argument);});
	if (IsGeneric (designator)) return Attribute (expression, checker.platform.globalGenericType);
	if (!IsProcedure (*designator.type) || IsType (designator)) EmitError (expression.position, Format ("calling %0 type", designator.type->model));
	if (IsConstant (designator)) if (const auto procedure = designator.value.procedure) if (!IsPredeclared (*procedure));
		#define PROCEDURE(scope, procedure_, name) else if (procedure == &checker.platform.scope##procedure_) return Check##procedure_ (expression);
		#include "oberon.def"
	const auto& signature = designator.type->procedure.signature; CheckArguments (expression, signature.parameters ? signature.parameters->size () : 0);
	if (expression.call.arguments) Batch (*expression.call.arguments, [this, &expression] (Expression& argument) {CheckArgument (argument, GetParameter (expression, argument));});
	if (!signature.result) Attribute (expression, checker.platform.globalVoidType); else if (!IsStructured (*signature.result)) Attribute (expression, *signature.result);
	else expression.call.temporary = Reserve (*signature.result, *currentScope), Attribute (expression, *signature.result, true);
}

void Context::CheckArgument (Expression& argument, const Declaration& declaration)
{
	assert (IsParameter (declaration)); CheckValue (argument); if (IsGeneric (argument) || IsGeneric (*declaration.parameter.type)) return;
	if (!argument.IsParameterCompatibleWith (declaration)) EmitError (argument.position, Format ("argument '%0' of %1 incompatible with %2 of %3", argument, *argument.type, declaration, *declaration.parameter.type));
	if (!IsVariableParameter (declaration)) Promote (argument, *declaration.parameter.type);
}

void Context::CheckArguments (Expression& expression, const Size size)
{
	assert (IsCall (expression));
	if ((expression.call.arguments ? expression.call.arguments->size () : 0) != size) EmitError (expression.position, "mismatched number of arguments");
}

void Context::CheckAbs (Expression& expression)
{
	CheckArguments (expression, 1); auto& argument = GetArgument (expression, 0);
	Check (argument, IsNumeric); Attribute (expression, IsComplex (*argument.type) ? checker.platform.GetReal (argument.type->complex.size) : *argument.type);
}

void Context::CheckAdr (Expression& expression)
{
	CheckArguments (expression, 1); CheckVariable (GetArgument (expression, 0));
	Attribute (expression, checker.platform.systemAddressType);
}

void Context::CheckAsh (Expression& expression)
{
	CheckArguments (expression, 2); auto& argument = GetArgument (expression, 0); Check (argument, IsInteger);
	auto& shift = GetArgument (expression, 1); Check (shift, IsInteger); if (IsGeneric (argument) || IsGeneric (shift)) return Attribute (expression, *argument.type);
	const auto size = checker.platform.GetSize (*shift.type); if (checker.platform.GetSize (*argument.type) < size) Promote (argument, IsSigned (*argument.type) ? checker.platform.GetSigned (size) : checker.platform.GetUnsigned (size));
	Attribute (expression, *argument.type);
}

void Context::CheckAsm (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), IsString);
	Attribute (expression, checker.platform.globalVoidType); if (!IsProcedure (*currentScope)) return;
	for (auto object: currentScope->objects) if (IsAssembly (*object.second)) ++object.second->uses;
}

void Context::CheckAssert (Expression& expression)
{
	const auto number = GetOptionalArgument (expression, 1); CheckArguments (expression, number ? 2 : 1);
	auto& condition = GetArgument (expression, 0); CheckCondition (condition); if (number) CheckStatus (*number);
	if (IsFalse (condition)) EmitError (condition.position, Format ("static assertion '%0' failed", condition));
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckBit (Expression& expression)
{
	CheckArguments (expression, 2);
	Check (GetArgument (expression, 0), checker.platform.systemAddressType);
	Check (GetArgument (expression, 1), checker.platform.globalLengthType);
	Attribute (expression, checker.platform.globalBooleanType);
}

void Context::CheckCap (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), checker.platform.globalCharacterType);
	Attribute (expression, checker.platform.globalCharacterType);
}

void Context::CheckChr (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), IsInteger);
	Attribute (expression, checker.platform.globalCharacterType);
}

void Context::CheckCode (Expression& expression)
{
	CheckAsm (expression);
}

void Context::CheckCopy (Expression& expression)
{
	CheckArguments (expression, 2); auto& target = GetArgument (expression, 1);
	Check (target, IsCharacterArray, &Context::CheckModifiable);
	Check (GetArgument (expression, 0), IsStringable);
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckDec (Expression& expression)
{
	CheckInc (expression);
}

void Context::CheckDispose (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), IsPointer, &Context::CheckModifiable);
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckEntier (Expression& expression)
{
	CheckArguments (expression, 1); CheckReal (GetArgument (expression, 0), IsSimple);
	Attribute (expression, checker.platform.globalLongIntegerType);
}

void Context::CheckExcl (Expression& expression)
{
	CheckIncl (expression);
}

void Context::CheckGet (Expression& expression)
{
	CheckArguments (expression, 2); Check (GetArgument (expression, 0), checker.platform.systemAddressType);
	Check (GetArgument (expression, 1), IsScalar, &Context::CheckModifiable); Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckHalt (Expression& expression)
{
	CheckArguments (expression, 1); CheckStatus (GetArgument (expression, 0));
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckIgnore (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), IsValid);
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckIm (Expression& expression)
{
	CheckRe (expression);
}

void Context::CheckInc (Expression& expression)
{
	const auto increment = GetOptionalArgument (expression, 1); CheckArguments (expression, increment ? 2 : 1);
	auto& argument = GetArgument (expression, 0); Check (argument, IsInteger, &Context::CheckModifiable);
	if (increment) Check (*increment, *argument.type); Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckIncl (Expression& expression)
{
	CheckArguments (expression, 2); auto& argument = GetArgument (expression, 0); Check (argument, IsSet, &Context::CheckModifiable);
	CheckElement (GetArgument (expression, 1), *argument.type); Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckLen (Expression& expression)
{
	const auto dimension = GetOptionalArgument (expression, 1); CheckArguments (expression, dimension ? 2 : 1);
	auto& array = GetArgument (expression, 0); Check (array, IsArray); if (IsGeneric (array) || !dimension) return Attribute (expression, checker.platform.globalLengthType);
	Check (*dimension, checker.platform.globalLengthType, &Context::CheckConstant); if (IsGeneric (*dimension)) return Attribute (expression, checker.platform.globalLengthType);
	if (dimension->value.signed_ < 0 || Size (dimension->value.signed_) >= CountDimensions (*array.type)) EmitError (dimension->position, "invalid array dimension");
	return Attribute (expression, checker.platform.globalLengthType);
}

void Context::CheckLong (Expression& expression)
{
	CheckArguments (expression, 1); auto& argument = GetArgument (expression, 0); Check (argument, IsNumeric); if (IsGeneric (argument)) return Attribute (expression, checker.platform.globalGenericType);
	const auto size = checker.platform.GetSize (*argument.type); if (size == 8) EmitError (expression.position, Format ("applying '%0' on %1", expression, *argument.type));
	if (IsSigned (*argument.type)) return Attribute (expression, checker.platform.GetSigned (size * 2));
	if (IsUnsigned (*argument.type)) return Attribute (expression, checker.platform.GetUnsigned (size * 2));
	if (IsReal (*argument.type)) return Attribute (expression, checker.platform.GetReal (size * 2));
	if (IsComplex (*argument.type)) return Attribute (expression, checker.platform.GetComplex (size * 2));
	assert (Type::Unreachable);
}

void Context::CheckLsh (Expression& expression)
{
	CheckAsh (expression);
}

void Context::CheckMax (Expression& expression)
{
	CheckArguments (expression, 1); auto& argument = GetArgument (expression, 0);
	Check (argument, IsBasic, &Context::CheckType); auto& type = *argument.type;
	Attribute (expression, IsSet (type) ? checker.platform.globalIntegerType : type);
}

void Context::CheckMin (Expression& expression)
{
	CheckMax (expression);
}

void Context::CheckMove (Expression& expression)
{
	CheckArguments (expression, 3);
	Check (GetArgument (expression, 0), checker.platform.systemAddressType);
	Check (GetArgument (expression, 1), checker.platform.systemAddressType);
	Check (GetArgument (expression, 2), checker.platform.globalLengthType);
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckNew (Expression& expression)
{
	if (!expression.call.arguments) CheckArguments (expression, 1);
	auto& argument = GetArgument (expression, 0); Check (argument, IsPointer, &Context::CheckModifiable);
	CheckArguments (expression, CountOpenDimensions (*argument.type->pointer.baseType) + 1);
	for (auto& length: *expression.call.arguments) if (&length != &argument) Check (length, checker.platform.globalLengthType);
	if (IsRecord (*argument.type->pointer.baseType)) recordAllocations.push_back (&argument);
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckOdd (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), IsInteger);
	Attribute (expression, checker.platform.globalBooleanType);
}

void Context::CheckOrd (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), checker.platform.globalCharacterType);
	Attribute (expression, checker.platform.globalIntegerType);
}

void Context::CheckPtr (Expression& expression)
{
	CheckArguments (expression, 1); auto& argument = GetArgument (expression, 0); CheckVariable (argument);
	Attribute (expression, module.Create<Type> (*argument.type, IsReadOnly (argument)));
}

void Context::CheckPut (Expression& expression)
{
	CheckArguments (expression, 2); Check (GetArgument (expression, 0), checker.platform.systemAddressType);
	Check (GetArgument (expression, 1), IsScalar); Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckRe (Expression& expression)
{
	CheckArguments (expression, 1); auto& argument = GetArgument (expression, 0); Check (argument, IsComplex);
	Attribute (expression, checker.platform.GetReal (argument.type->complex.size));
}

void Context::CheckRot (Expression& expression)
{
	CheckAsh (expression);
}

void Context::CheckSel (Expression& expression)
{
	CheckArguments (expression, 3); auto &condition = GetArgument (expression, 0), &trueArgument = GetArgument (expression, 1), &falseArgument = GetArgument (expression, 2);
	CheckCondition (condition); if (IsConstant (condition)) Check (trueArgument, IsSelectable), Check (falseArgument, IsSelectable); else Check (trueArgument, IsScalar), Check (falseArgument, IsScalar);
	Promote (trueArgument, falseArgument); if (!trueArgument.type->IsSameAs (*falseArgument.type)) EmitError (trueArgument.position, "incompatible binary selection arguments"); Attribute (expression, *trueArgument.type);
}

void Context::CheckShort (Expression& expression)
{
	CheckArguments (expression, 1); auto& argument = GetArgument (expression, 0); Check (argument, IsNumeric); if (IsGeneric (argument)) return Attribute (expression, checker.platform.globalGenericType);
	const auto size = checker.platform.GetSize (*argument.type); if (size == (IsInteger (*argument.type) ? 1 : 4)) EmitError (expression.position, Format ("applying '%0' on %1", expression, *argument.type));
	if (IsSigned (*argument.type)) return Attribute (expression, checker.platform.GetSigned (size / 2));
	if (IsUnsigned (*argument.type)) return Attribute (expression, checker.platform.GetUnsigned (size / 2));
	if (IsReal (*argument.type)) return Attribute (expression, checker.platform.GetReal (size / 2));
	if (IsComplex (*argument.type)) return Attribute (expression, checker.platform.GetComplex (size / 2));
	assert (Type::Unreachable);
}

void Context::CheckSize (Expression& expression)
{
	CheckArguments (expression, 1); CheckType (GetArgument (expression, 0));
	Attribute (expression, checker.platform.globalLengthType);
}

void Context::CheckSystemDispose (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), IsAllocatable, &Context::CheckModifiable);
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckSystemNew (Expression& expression)
{
	CheckArguments (expression, 2); Check (GetArgument (expression, 0), IsAllocatable, &Context::CheckModifiable);
	Check (GetArgument (expression, 1), checker.platform.globalLengthType);
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckTrace (Expression& expression)
{
	CheckArguments (expression, 1); Check (GetArgument (expression, 0), IsTraceable);
	Attribute (expression, checker.platform.globalVoidType);
}

void Context::CheckVal (Expression& expression)
{
	CheckArguments (expression, 2); auto& name = GetArgument (expression, 0); CheckType (name); auto& argument = GetArgument (expression, 1); Check (argument);
	if (!IsGeneric (name) && !IsGeneric (argument) && (IsOpenArray (*name.type) || !IsVariable (argument) && !IsScalar (*name.type))) EmitError (name.position, "invalid type interpretation");
	Attribute (expression, *name.type, IsVariable (argument), IsReadOnly (argument));
}

void Context::Promote (Expression& expression, Type& type)
{
	if (expression.type->IsEqualTo (type) || !IsCharacter (*expression.type) && !IsCharacter (type) && !IsByte (type) && !IsAny (type) && !IsArithmetic (*expression.type) && !IsNil (*expression.type) || IsVariablePointer (type)) return;
	module.Create (expression.promotion.expression, expression); Model (expression, Expression::Promotion); return Attribute (expression, type);
}

void Context::Promote (Expression& first, Expression& second)
{
	if (first.IsExpressionCompatibleWith (*second.type)) Promote (first, *second.type);
	else if (second.IsExpressionCompatibleWith (*first.type)) Promote (second, *first.type);
}

void Context::Check (Type& type)
{
	switch (type.model)
	{
	case Type::Array:
		assert (type.array.elementType);
		Check (*type.array.elementType);
		if (type.array.length) Check (*type.array.length, checker.platform.globalLengthType, &Context::CheckLength);
		if (IsOpenArray (*type.array.elementType) && !IsOpenArray (type)) EmitError (type.array.elementType->position, "open array as array element type");
		if (IsAnonymous (*type.array.elementType)) module.anonymousTypes.push_back (type.array.elementType);
		if (IsRecord (*type.array.elementType)) recordElementTypes.push_back (type.array.elementType);
		break;

	case Type::Record:
	{
		module.Create (type.record.scope, type, *currentScope);
		type.record.declaration = nullptr; type.record.isReachable = false;
		type.record.level = type.record.procedures = type.record.abstractions = 0;

		if (type.record.baseType)
		{
			Check (*type.record.baseType);
			if (IsFinal (*type.record.baseType)) EmitError (type.record.baseType->position, Format ("extending final %0", *type.record.baseType));
			if (IsRecord (*type.record.baseType)) type.record.scope->size = type.record.baseType->record.scope->size, type.record.scope->count = type.record.baseType->record.scope->count,
				type.record.scope->alignment = type.record.baseType->record.scope->alignment, type.record.scope->needsInitialization = type.record.baseType->record.scope->needsInitialization,
				type.record.level = type.record.baseType->record.level + 1;
			else if (!IsGeneric (*type.record.baseType)) EmitError (type.record.baseType->position, Format ("%0 as record base type", type.record.baseType->model));
		}

		const Restore restoreScope {currentScope, type.record.scope};
		if (type.record.declarations) Check (*type.record.declarations), Reserve (*type.record.declarations), Reserve (*currentScope);
		break;
	}

	case Type::Pointer:
		assert (type.pointer.baseType);
		if (IsIdentifier (*type.pointer.baseType) && !type.pointer.isVariable) pointerTypes.push_back (&type);
		else Check (*type.pointer.baseType), CheckPointer (type);
		break;

	case Type::Procedure:
	{
		module.Create (type.procedure.signature.scope, type.procedure.signature, *currentScope);
		const Restore restoreScope {currentScope, type.procedure.signature.scope};
		type.procedure.signature.receiver = type.procedure.signature.parent = nullptr; Check (type.procedure.signature);
		break;
	}

	case Type::Identifier:
	{
		assert (type.identifier); const auto position = type.position; const auto identifier = type.identifier; Check (*identifier);
		if (IsType (*identifier->declaration)) type = *identifier->declaration->type;
		else if (IsConstant (*identifier->declaration) && IsType (*identifier->declaration->constant.expression)) type = *identifier->declaration->constant.expression->type;
		else EmitError (position, Format ("identifier '%0' does not name a type", *identifier));
		type.position = position; type.identifier = identifier;
		break;
	}

	default:
		assert (Type::Unreachable);
	}
}

void Context::CheckResult (Type& type)
{
	Check (type);
	if (IsOpenArray (type)) EmitError (type.position, "open array as result type");
	if (IsRecord (type)) recordResultTypes.push_back (&type);
}

void Context::CheckPointer (Type& type)
{
	assert (IsPointer (type)); if (IsIdentifier (*type.pointer.baseType)) Check (*type.pointer.baseType); if (IsGeneric (*type.pointer.baseType)) return;
	if (!IsVariablePointer (type) && !IsArray (*type.pointer.baseType) && !IsRecord (*type.pointer.baseType)) EmitError (type.position, Format ("pointer to %0 type", type.pointer.baseType->model));
	if (IsAnonymous (*type.pointer.baseType)) module.anonymousTypes.push_back (type.pointer.baseType);
}

void Context::CheckPointerTypes ()
{
	for (std::vector<Type*> types; !pointerTypes.empty (); types.clear ())
		types.swap (pointerTypes), Batch (types, [this] (Type*const type) {CheckPointer (*type);});
}

void Context::Check (Signature& signature)
{
	assert (currentScope == signature.scope);
	if (signature.receiver) CheckReceiver (*signature.receiver);
	if (signature.parameters) Check (*signature.parameters);
	if (signature.result) CheckResult (*signature.result);
}

void Context::Check (QualifiedIdentifier& identifier)
{
	assert (identifier.name);
	if (!IsQualified (identifier)) return void (identifier.declaration = &Lookup (*identifier.name)); Check (*identifier.parent); auto& declaration = *identifier.parent->declaration;
	if (IsConstant (declaration) && IsGeneric (*declaration.constant.expression) || IsType (declaration) && IsGeneric (*declaration.type)) return void (identifier.declaration = &declaration);
	if (!IsModule (declaration)) EmitError (identifier.parent->name->position, Format ("identifier '%0' does not name a module", *identifier.parent));
	const auto& scope = *(IsConstant (declaration) ? *declaration.constant.expression->value.module : declaration).import.scope; identifier.declaration = scope.Lookup (*identifier.name, module);
	if (!identifier.declaration) EmitError (identifier.name->position, Format ("undeclared identifier '%0' in module '%1'", *identifier.name, scope)); ++identifier.declaration->uses;
}

void Context::CheckType (QualifiedIdentifier& identifier)
{
	Check (identifier);
	if (!IsType (*identifier.declaration)) EmitError (identifier.name->position, Format ("identifier '%0' does not denote a type", identifier));
}

void Context::LookupImport (const Scope& scope, const Position& position)
{
	assert (IsGlobal (scope));
	if (const auto import = module.scope->LookupImport (scope)) ++import->uses; else EmitError (position, Format ("module '%0' not imported", *scope.identifier));
}

Declaration& Context::Lookup (const Identifier& identifier)
{
	for (auto scope = currentScope; scope; scope = scope->parent)
		if (const auto declaration = scope->Lookup (identifier, module)) return ++declaration->uses, *declaration;
	EmitError (identifier.position, Format ("undeclared identifier '%0'", identifier));
}

void Context::Check (Body& body)
{
	Check (body.statements);
	body.isReachable = body.statements.empty () || !IsEmptyLoop (body.statements.front ());
}

void Context::Check (Statements& statements)
{
	auto size = currentScope->size;
	Batch (statements, [this, reset = size, &size] (Statement& statement) {currentScope->size = reset; Check (statement); size = std::max (size, currentScope->size);});
	currentScope->size = size;
}

void Context::Check (Statement& statement)
{
	switch (statement.model)
	{
	case Statement::If:
	{
		assert (statement.if_.condition); assert (statement.if_.thenPart);
		CheckCondition (*statement.if_.condition); Check (*statement.if_.thenPart);
		if (statement.if_.elsifs) for (auto& elsif: *statement.if_.elsifs) CheckCondition (elsif.condition), Check (elsif.statements);
		if (statement.if_.elsePart) Check (*statement.if_.elsePart);
		break;
	}

	case Statement::For:
	{
		assert (statement.for_.variable); assert (statement.for_.begin); assert (statement.for_.end);
		auto& variable = *statement.for_.variable; Check (variable, IsInteger, &Context::CheckModifiable);
		auto& begin = *statement.for_.begin; Check (begin, *variable.type);
		auto& end = *statement.for_.end; Check (end, *variable.type);
		if (const auto step = statement.for_.step) if (Check (*step, *variable.type, &Context::CheckConstant), IsZero (step->value))
			EmitError (step->position, Format ("invalid step value '%0'", *step));
		if (!IsConstant (end)) statement.for_.temporary = Reserve (*variable.type, *currentScope);
		Check (*statement.for_.statements);
		break;
	}

	case Statement::Case:
	{
		assert (statement.case_.expression); auto& expression = *statement.case_.expression; Check (expression); module.Create (statement.case_.labels);
		if (!IsGeneric (expression)) if (expression.IsExpressionCompatibleWith (checker.platform.globalCharacterType)) Promote (expression, checker.platform.globalCharacterType);
		else if (!IsInteger (*expression.type)) EmitError (expression.position, Format ("case expression '%0' of %1", expression, *expression.type));
		if (statement.case_.cases) for (auto& case_: *statement.case_.cases) Check (case_, *statement.case_.labels, *expression.type);
		if (statement.case_.elsePart) Check (*statement.case_.elsePart);
		break;
	}

	case Statement::Exit:
		if (!currentLoop) EmitError (statement.position, "unbounded exit statement");
		statement.exit.statement = currentLoop;
		break;

	case Statement::Loop:
	{
		assert (statement.loop.statements);
		const Restore restoreLoop {currentLoop, &statement};
		Check (*statement.loop.statements);
		break;
	}

	case Statement::With:
		assert (statement.with.guards);
		for (auto& guard: *statement.with.guards) Check (guard, *statement.with.guards);
		if (statement.with.elsePart) Check (*statement.with.elsePart);
		break;

	case Statement::While:
		assert (statement.while_.condition); assert (statement.while_.statements);
		CheckCondition (*statement.while_.condition); Check (*statement.while_.statements);
		break;

	case Statement::Repeat:
		assert (statement.repeat.statements); assert (statement.repeat.condition);
		Check (*statement.repeat.statements); CheckCondition (*statement.repeat.condition);
		break;

	case Statement::Return:
		if (const auto expression = statement.return_.expression)
			if (!IsProcedure (*currentScope)) EmitError (expression->position, "invalid result value");
			else if (const auto type = currentScope->procedure->procedure.signature.result)
				if (Check (*expression), IsGeneric (*expression) || IsGeneric (*type)) break;
				else if (!expression->IsAssignmentCompatibleWith (*type)) EmitError (expression->position, "incompatible result value");
				else if (IsStructured (*type) && !currentScope->procedure->procedure.result) currentScope->procedure->procedure.result = GetVariable (*expression);
				else Promote (*expression, *type);
			else EmitError (statement.position, "leaving proper procedure with result value");
		else if (IsProcedure (*currentScope) && currentScope->procedure->procedure.signature.result)
			EmitError (statement.position, "leaving function procedure without result value");
		break;

	case Statement::Assignment:
	{
		assert (statement.assignment.designator); assert (statement.assignment.expression);
		auto& variable = *statement.assignment.designator; CheckModifiable (variable);
		auto& expression = *statement.assignment.expression; CheckValue (expression);
		if (IsGeneric (*variable.type) || IsGeneric (expression)) break;
		if (expression.IsAssignmentCompatibleWith (*variable.type)) Promote (expression, *variable.type);
		else EmitError (expression.position, Format ("assigning '%0' of %1 to variable of %2", expression, *expression.type, *variable.type));
		if (IsRecord (*variable.type)) recordAssignments.push_back (&statement);
		break;
	}

	case Statement::ProcedureCall:
	{
		assert (statement.procedureCall.designator);
		auto& designator = *statement.procedureCall.designator; Check (designator);
		if (!IsCall (designator)) module.Create (designator.call.designator, designator), Model (designator, Expression::Call), designator.call.arguments = nullptr, CheckCall (designator);
		if (IsValid (*designator.type) && !IsGeneric (designator)) EmitError (designator.position, "calling function procedure");
		break;
	}

	default:
		assert (Statement::Unreachable);
	}
}

void Context::Check (Case& case_, Labels& labels, Type& type)
{
	for (auto& label: case_.labels) Check (label, labels, type);
	Check (case_.statements);
}

void Context::Check (Guard& guard, const Guards& guards)
{
	Check (guard.expression); Check (guard.type); if (IsGeneric (guard.expression) || IsGeneric (guard.type)) return;
	CheckGuard (guard.expression, guard.type); assert (IsObject (guard.expression)); auto& variable = *guard.expression.identifier.declaration;
	if (IsRecord (*variable.scope)) EmitError (guard.expression.position, "invalid guard variable");
	for (auto& previous: guards) if (&previous == &guard) break; else if (previous.expression.identifier.declaration == &variable && guard.type.Extends (previous.type)) EmitError (guard.type.position, "unreachable type guard");
	const VariableGuard current {variableGuard, &variable, &guard.type};
	const Restore restore {variableGuard, &current}; Check (guard.statements);
}

void Context::Check (Expression& expression, Labels& labels, Type& type)
{
	if (IsRange (expression)) Check (*expression.binary.left, type, &Context::CheckConstant), Check (*expression.binary.right, type, &Context::CheckConstant); else Check (expression, type, &Context::CheckConstant);
	if (IsGeneric (expression)) return; const auto range = GetRange (expression); if (range.lower > range.upper) EmitError (expression.position, "empty case label range");
	if (labels[range]) EmitError (expression.position, "duplicated case labels"); labels.insert (range);
}

void Context::Warn (const Declarations& declarations)
{
	for (auto& declaration: declarations) Warn (declaration);
}

void Context::Warn (const Declaration& declaration)
{
	if (IsForward (declaration)) return;
	if (!IsUsed (declaration) && !IsExported (declaration) && !IsRedefined (declaration)) EmitWarning (declaration.position, Format ("unused %0", declaration));
	if (IsExported (declaration) && !IsReachable (*declaration.scope)) EmitWarning (declaration.position, Format ("exporting unreachable %0", declaration));

	switch (declaration.model)
	{
	case Declaration::Import:
		if (IsModule (*declaration.import.scope) && declaration.import.scope->module->body && !IsTerminating (*declaration.import.scope->module->body))
			EmitWarning (declaration.position, Format ("importing non-terminating module '%0'", declaration.import.scope->module->identifier));
		break;

	case Declaration::Constant:
		break;

	case Declaration::Type:
		Warn (*declaration.type);
		break;

	case Declaration::Variable:
	case Declaration::Parameter:
		Warn (*declaration.object.type);
		break;

	case Declaration::Procedure:
		if (IsAbstract (declaration)) break;
		if (declaration.procedure.signature.receiver) Warn (*declaration.procedure.signature.receiver);
		if (declaration.procedure.signature.parameters) Warn (*declaration.procedure.signature.parameters);
		if (declaration.procedure.signature.result) Warn (*declaration.procedure.signature.result);
		if (declaration.procedure.declarations) Warn (*declaration.procedure.declarations);
		if (declaration.procedure.body) Warn (*declaration.procedure.body);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::Warn (const Type& type)
{
	if (IsAlias (type)) return;

	switch (type.model)
	{
	case Type::Array:
		Warn (*type.array.elementType);
		break;

	case Type::Record:
		if (type.record.declarations) Warn (*type.record.declarations);
		break;

	case Type::Pointer:
		Warn (*type.pointer.baseType);
		break;
	}
}

void Context::Warn (const Body& body)
{
	Warn (body.statements, true);
}

void Context::Warn (const Statements& statements, bool isReachable)
{
	for (auto& statement: statements) Warn (statement, isReachable), isReachable = IsReachable (statement);
}

void Context::Warn (const Statement& statement, const bool isReachable)
{
	if (!IsReachable (statement) && isReachable) EmitWarning (statement.position, "unreachable statement");

	switch (statement.model)
	{
	case Statement::If:
		Warn (*statement.if_.thenPart, isReachable);
		if (statement.if_.elsifs) for (auto& elsif: *statement.if_.elsifs) Warn (elsif.statements, isReachable);
		if (statement.if_.elsePart) Warn (*statement.if_.elsePart, isReachable);
		break;

	case Statement::For:
		return Warn (*statement.for_.statements, isReachable);

	case Statement::Case:
		if (statement.case_.cases) for (auto& case_: *statement.case_.cases) Warn (case_.statements, isReachable);
		if (statement.case_.elsePart) Warn (*statement.case_.elsePart, isReachable);
		return;

	case Statement::Loop:
		return Warn (*statement.loop.statements, isReachable);

	case Statement::With:
		for (auto& guard: *statement.with.guards) Warn (guard.statements, isReachable);
		if (statement.with.elsePart) Warn (*statement.with.elsePart, isReachable);
		return;

	case Statement::While:
		return Warn (*statement.while_.statements, isReachable);

	case Statement::Repeat:
		return Warn (*statement.repeat.statements, isReachable);

	}
}

void Context::CheckReachability (Declarations& declarations)
{
	for (auto& declaration: declarations) CheckReachability (declaration);
}

void Context::CheckReachability (Declaration& declaration)
{
	if (IsForward (declaration)) return;

	switch (declaration.model)
	{
	case Declaration::Import:
	case Declaration::Constant:
	case Declaration::Parameter:
		break;

	case Declaration::Type:
		if (IsExported (declaration)) CheckReachability (*declaration.type);
		break;

	case Declaration::Variable:
		if (IsExported (declaration)) CheckReachability (*declaration.variable.type);
		break;

	case Declaration::Procedure:
		if (IsAbstract (declaration)) return;
		if (declaration.procedure.declarations) CheckReachability (*declaration.procedure.declarations);
		if (declaration.procedure.body) CheckReachability (*declaration.procedure.body);
		if (OmitsResultValue (declaration) && !import) EmitError (declaration.position, "function procedure omits result value");
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::CheckReachability (Type& type)
{
	switch (type.model)
	{
	case Type::Array:
		return CheckReachability (*type.array.elementType);

	case Type::Record:
		if (IsAlias (type)) return CheckReachability (*type.identifier->declaration->type);
		if (type.record.isReachable) return; type.record.isReachable = true;
		if (type.record.baseType) CheckReachability (*type.record.baseType);
		if (type.record.declarations) for (auto& declaration: *type.record.declarations) CheckReachability (declaration);
		return;

	case Type::Pointer:
		return CheckReachability (*type.pointer.baseType);
	}
}

void Context::CheckReachability (Body& body)
{
	currentBody = &body; body.isReachable = CheckReachability (body.statements, true);
}

bool Context::CheckReachability (Statements& statements, bool isReachable)
{
	for (auto& statement: statements) isReachable = CheckReachability (statement, isReachable);
	return isReachable;
}

bool Context::CheckReachability (Statement& statement, const bool isReachable)
{
	statement.isReachable = isReachable;

	switch (statement.model)
	{
	case Statement::If:
	{
		auto result = CheckReachability (*statement.if_.thenPart, isReachable && !IsFalse (*statement.if_.condition)), condition = IsTrue (*statement.if_.condition);
		if (statement.if_.elsifs) for (auto& elsif: *statement.if_.elsifs) result |= CheckReachability (elsif.statements, isReachable && !IsFalse (elsif.condition) && !condition), condition |= IsTrue (elsif.condition);
		result |= statement.if_.elsePart ? CheckReachability (*statement.if_.elsePart, isReachable && !condition) : isReachable && !condition;
		return result;
	}

	case Statement::For:
		CheckReachability (*statement.for_.statements, isReachable && (!IsConstant (*statement.for_.begin) || IsGeneric (*statement.for_.begin) || !IsConstant (*statement.for_.end) || IsGeneric (*statement.for_.end) ||
			(statement.for_.step && IsSigned (statement.for_.step->value) && statement.for_.step->value.signed_ < 0 ? statement.for_.begin->value >= statement.for_.end->value : statement.for_.begin->value <= statement.for_.end->value)));
		return isReachable;

	case Statement::Case:
	{
		auto result = false;
		if (statement.case_.cases) for (auto& case_: *statement.case_.cases) result |= CheckReachability (case_.statements, isReachable);
		if (statement.case_.elsePart) result |= CheckReachability (*statement.case_.elsePart, isReachable);
		else result |= isReachable && (!IsConstant (*statement.case_.expression) || statement.case_.labels->operator [] (statement.case_.expression->value));
		return result;
	}

	case Statement::Exit:
		statement.exit.statement->loop.isExiting |= isReachable;
		return false;

	case Statement::Loop:
		statement.loop.isExiting = false;
		CheckReachability (*statement.loop.statements, isReachable);
		return statement.loop.isExiting;

	case Statement::With:
	{
		auto result = false;
		for (auto& guard: *statement.with.guards) result |= CheckReachability (guard.statements, isReachable);
		if (statement.with.elsePart) result |= CheckReachability (*statement.with.elsePart, isReachable);
		return result;
	}

	case Statement::While:
		CheckReachability (*statement.while_.statements, isReachable && !IsFalse (*statement.while_.condition));
		return isReachable && !IsTrue (*statement.while_.condition);

	case Statement::Repeat:
		return CheckReachability (*statement.repeat.statements, isReachable) && !IsFalse (*statement.repeat.condition);

	case Statement::Return:
		currentBody->hasReturn |= isReachable;
		return false;

	case Statement::Assignment:
		return isReachable;

	case Statement::ProcedureCall:
	{
		auto& expression = *statement.procedureCall.designator;
		if (expression.CallsCode (checker.platform)) return currentBody->hasCode = statement.isReachable = true;
		return isReachable && !expression.Calls (checker.platform.globalHalt) && IsTerminating (expression, *currentBody);
	}

	default:
		assert (Statement::Unreachable);
	}
}

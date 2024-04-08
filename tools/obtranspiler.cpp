// Oberon transpiler
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

#include "indenter.hpp"
#include "oberon.hpp"
#include "obtranspiler.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace Oberon;

using Context = class Transpiler::Context : Indenter
{
public:
	Context (const Transpiler&, const Module&);

	std::ostream& Define (std::ostream&);
	std::ostream& Declare (std::ostream&);

private:
	const Transpiler& transpiler;
	const Module& module;
	Scope* currentScope = nullptr;
	std::vector<const Module*> definitions;
	std::vector<const Declaration*> procedures;

	std::ostream& DefineBody (std::ostream&);

	std::ostream& BeginBlock (std::ostream&);
	std::ostream& EndBlock (std::ostream&, char = 0);

	std::ostream& IncludeHeader (std::ostream&, const Module&);
	std::ostream& IncludeHeader (std::ostream&, const Source&);

	std::ostream& Print (std::ostream&, const Case&);
	std::ostream& Print (std::ostream&, const Declaration&);
	std::ostream& Print (std::ostream&, const Definitions&);
	std::ostream& Print (std::ostream&, const Elsif&);
	std::ostream& Print (std::ostream&, const Identifier&);
	std::ostream& Print (std::ostream&, const Identifier&, const Scope&);
	std::ostream& Print (std::ostream&, const Module&);
	std::ostream& Print (std::ostream&, const QualifiedIdentifier&);
	std::ostream& Print (std::ostream&, const Scope&);
	std::ostream& Print (std::ostream&, const Statement&);
	std::ostream& Print (std::ostream&, const Statements&);
	std::ostream& Print (std::ostream&, const Value&, const Type&);
	std::ostream& Print (std::ostream&, const Type*);
	std::ostream& Print (std::ostream&, const Type&, const Declaration* = nullptr, bool = false, bool = false, bool = false);
	std::ostream& Print (std::ostream&, const Signature&);
	std::ostream& PrintNamespace (std::ostream&, const QualifiedIdentifier&);

	std::ostream& Print (std::ostream&, const Expression&);
	std::ostream& PrintBasic (std::ostream&, const Expression&);
	std::ostream& PrintGuard (std::ostream&, const Expression&, const Type&, bool);
	std::ostream& PrintLabel (std::ostream&, const Expression&);
	std::ostream& PrintLabel (std::ostream&, const Value&, const Type&);

	std::ostream& Define (std::ostream&, const Declaration&);
	std::ostream& Define (std::ostream&, const Declarations&);
	std::ostream& Define (std::ostream&, const Module&);
	std::ostream& Define (std::ostream&, const Type&);

	std::ostream& Declare (std::ostream&, const Declaration&);
	std::ostream& Declare (std::ostream&, const Declarations&);
	std::ostream& Declare (std::ostream&, const Type&);

	std::ostream& Construct (std::ostream&, const Type&);

	static String GetIncludeGuard (const QualifiedIdentifier&);
	static bool IsSelfReferencing (const Declaration&);
	static bool References (const Type&, const Declaration&);
};

Transpiler::Transpiler (Platform& p) :
	platform {p}
{
}

void Transpiler::Transpile (const Module& module, std::ostream& source, std::ostream& header) const
{
	Context {*this, module}.Define (source);
	Context {*this, module}.Declare (header);
}

Context::Context (const Transpiler& t, const Module& m) :
	transpiler {t}, module {m}
{
}

std::ostream& Context::BeginBlock (std::ostream& stream)
{
	return Increase (Indent (stream) << "{\n");
}

std::ostream& Context::EndBlock (std::ostream& stream, const char separator)
{
	Indent (Decrease (stream)) << '}'; if (separator) stream << separator; return stream << '\n';
}

std::ostream& Context::IncludeHeader (std::ostream& stream, const Module& module)
{
	return IncludeHeader (stream, GetFilename (module.identifier));
}

std::ostream& Context::IncludeHeader (std::ostream& stream, const Source& filename)
{
	return Indent (stream) << "#include \"" << filename << ".hpp\"\n";
}

std::ostream& Context::Print (std::ostream& stream, const Identifier& identifier)
{
	if (identifier.string == "char" || identifier.string == "public" || identifier.string == "private" || identifier.string == "enum" || identifier.string == "true" || identifier.string == "false") stream << '_';
	return stream << identifier;
}

std::ostream& Context::Print (std::ostream& stream, const Identifier& identifier, const Scope& scope)
{
	if (IsModule (scope) && scope.module->identifier.name->string == identifier.string) return stream << '_' << identifier;
	return Print (stream, identifier);
}

std::ostream& Context::Print (std::ostream& stream, const Definitions& definitions)
{
	Indent (stream) << "template <";
	for (auto& definition: definitions) Print ((IsFirst (definition, definitions) ? stream : stream << ", ") << "typename _", definition.name);
	return stream << ">\n";
}

std::ostream& Context::Print (std::ostream& stream, const Declaration& declaration)
{
	if (IsGenericParameter (declaration) && declaration.scope == module.scope) return stream << '_' << declaration.name;
	if (IsExternal (declaration) && IsString (declaration.storage.external->value) && !declaration.storage.external->value.string->empty ()) return stream << *declaration.storage.external->value.string;
	if (IsGlobal (*declaration.scope) && !declaration.scope->identifier || IsProcedure (*declaration.scope) || IsParameter (declaration) || declaration.scope == currentScope) return Print (stream, declaration.name, *declaration.scope);
	return Print (Print (stream, *declaration.scope) << "::", declaration.name, *declaration.scope);
}

std::ostream& Context::Print (std::ostream& stream, const Scope& scope)
{
	switch (scope.model)
	{
	case Scope::Global:
		return scope.identifier ? PrintNamespace (stream, *scope.identifier) : stream;

	case Scope::Module:
		return Print (stream, *scope.module);

	case Scope::Record:
		if (scope.record->record.declaration) return Print (stream, *scope.record->record.declaration);
		if (module.scope != currentScope) Print (stream, *module.scope) << "::";
		return stream << "__record" << module.GetIndex (*scope.record);

	default:
		assert (Scope::Unreachable);
	}
}

std::ostream& Context::PrintNamespace (std::ostream& stream, const QualifiedIdentifier& identifier)
{
	assert (identifier.name); if (identifier.parent && (!module.identifier.parent || *identifier.parent != *module.identifier.parent)) stream << *identifier.parent << "::"; return stream << *identifier.name;
}

std::ostream& Context::Print (std::ostream& stream, const Module& module)
{
	PrintNamespace (stream, module.identifier); if (!IsGeneric (module)) return stream; stream << '<';
	if (!IsParameterized (module)) for (auto& definition: *module.definitions) Print ((IsFirst (definition, *module.definitions) ? stream : stream << ", ") << '_', definition.name);
	else for (auto& expression: *module.expressions) if (IsModule (expression.value)) Print (IsFirst (expression, *module.expressions) ? stream : stream << ", ", expression.value, *expression.type);
		else if (IsType (expression) && IsIdentifier (expression)) Print (IsFirst (expression, *module.expressions) ? stream : stream << ", ", *expression.identifier.declaration);
		else Print (Print ((IsFirst (expression, *module.expressions) ? stream : stream << ", ") << "Oberon::ValueType<", *expression.type) << ", ", expression.value, *expression.type) << '>';
	return stream << '>';
}

std::ostream& Context::Print (std::ostream& stream, const QualifiedIdentifier& identifier)
{
	if (identifier.parent) Print (stream, *identifier.declaration->scope) << "::";
	return Print (stream, *identifier.name, *identifier.declaration->scope);
}

std::ostream& Context::Print (std::ostream& stream, const Type* type)
{
	return type ? Print (stream, *type) : stream << "void";
}

std::ostream& Context::Print (std::ostream& stream, const Type& type, const Declaration*const declaration, const bool reference, const bool constant, const bool selfReferencing)
{
	if (declaration) for (auto scope = IsAlias (type) ? type.identifier->declaration->scope : IsRecord (type) ? type.record.scope : nullptr; scope && scope != currentScope; scope = scope->parent)
		if (IsModule (*scope) && IsGeneric (*scope->module) && !IsParameterized (*scope->module)) stream << "typename ";

	if (IsAlias (type) && !selfReferencing)
		Print (constant ? stream << "const " : stream, *type.identifier->declaration);
	else switch (type.model)
	{
	case Type::Array:
		if (constant) stream << "const ";
		Print (stream << "Oberon::Array<", *type.array.elementType) << '>';
		break;

	case Type::Record:
		if (constant) stream << "const ";
		Print (stream, *type.record.scope);
		break;

	case Type::Pointer:
		if (type.pointer.isReadOnly) stream << "const ";
		Print (stream, *type.pointer.baseType) << '*';
		if (constant) stream << "const";
		break;

	case Type::Procedure:
		Print (stream, type.procedure.signature.result) << " (*";
		if (constant) stream << "const";
		break;

	default:
		assert (Type::Unreachable);
	}

	if (reference) stream << '&';
	if (declaration) Print (stream << ' ', *declaration);
	if (IsAlias (type) && !selfReferencing) return stream;

	switch (type.model)
	{
	case Type::Array:
	case Type::Record:
	case Type::Pointer:
		return stream;

	case Type::Procedure:
		return Print (stream << ") ", type.procedure.signature);

	default:
		assert (Type::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Signature& signature)
{
	stream << '('; if (signature.parameters) for (auto& declaration: *signature.parameters) Declare (IsFirst (declaration, *signature.parameters) ? stream : stream << ", ", declaration);
	stream << ')'; if (signature.receiver && signature.receiver->parameter.isReadOnly && IsRecord (*signature.receiver->parameter.type)) stream << " const"; return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Value& value, const Type& type)
{
	switch (value.model)
	{
	case Type::Boolean:
		return stream << (value.boolean ? "true" : "false");

	case Type::Character:
		if (!std::isprint (value.character)) return stream << "'\\x" << std::hex << unsigned (value.character) << std::dec << '\'';
		if (value.character == '\'') return stream << "'\\''";
		return stream << '\'' << value.character << '\'';

	case Type::Signed:
	case Type::Unsigned:
	case Type::Byte:
		return stream << value;

	case Type::Real:
		if (std::signbit (value.real)) stream << '-';
		if (std::isinf (value.real)) return stream << "INFINITY";
		if (std::isnan (value.real)) return stream << "NAN";
		return stream << std::abs (value.real);

	case Type::Complex:
		return Print (Print (Print (stream, type) << " (", value.complex.real, type) << ", ", value.complex.imag, type) << ')';

	case Type::Set:
		return Print (stream, type) << " {" << value.set.mask << '}';

	case Type::Any:
		assert (!value.any);
		return stream << "nullptr";

	case Type::String:
		return WriteString (stream, *value.string, '"');

	case Type::Nil:
		return stream << "nullptr";

	case Type::Pointer:
		assert (!value.pointer);
		return stream << "nullptr";

	case Type::Procedure:
		return value.procedure ? Print (stream, *value.procedure) : stream << "nullptr";

	case Type::Module:
		return Print (stream, *value.module->import.scope);

	case Type::Identifier:
		return Print (stream, *value.type);

	default:
		assert (Type::Unreachable);
	}
}

std::ostream& Context::DefineBody (std::ostream& stream)
{
	BeginBlock (Print (Indent (stream) << "void ", module) << "::__body ()\n");
	Indent (Indent (stream) << "static bool called = false;\n") << "if (called) return; called = true;\n\n";
	for (auto& declaration: module.declarations) if (IsImport (declaration) && IsModule (*declaration.import.scope)) Print (Indent (stream), *declaration.import.scope->module) << "::__body ();\n\n";
	if (module.body) Print (stream, module.body->statements);
	return EndBlock (stream);
}

std::ostream& Context::Define (std::ostream& stream)
{
	Indent (stream) << "// definitions of module " << module.identifier << " generated from " << module.source << "\n\n";
	IncludeHeader (stream, module); if (IsGeneric (module)) return stream;

	if (module.identifier.parent) PrintNamespace (Indent (stream << '\n') << "using namespace ", *module.identifier.parent) << ";\n";

	Define (stream << '\n', module);
	for (auto& declaration: module.declarations) if (!IsType (declaration)) Define (stream, declaration);

	Print (Indent (stream) << "static Oberon::Module module {", *module.identifier.name) << "::__body};\n\n";

	return DefineBody (stream);
}

std::ostream& Context::Declare (std::ostream& stream)
{
	Indent (stream) << "// declarations of module " << module.identifier << " generated from " << module.source << "\n\n";

	const auto includeGuard = GetIncludeGuard (module.identifier);
	Indent (stream) << "#ifndef " << includeGuard << "\n#define " << includeGuard << "\n\n";

	IncludeHeader (stream, "obcpprun");
	for (auto& declaration: module.declarations) if (IsImport (declaration) && IsModule (*declaration.import.scope)) IncludeHeader (stream, *declaration.import.scope->module);
	stream << '\n';

	if (module.identifier.parent) BeginBlock (PrintNamespace (Indent (stream) << "namespace ", *module.identifier.parent) << '\n');

	if (IsGeneric (module)) Print (stream, *module.definitions);
	BeginBlock (Print (Indent (stream) << "struct ", *module.identifier.name) << '\n');

	currentScope = module.scope;
	if (IsGeneric (module)) for (auto& definition: *module.definitions) Print (Print (Indent (stream) << "using ", definition.name) << " = _", definition.name) << ";\n";
	for (auto type: module.anonymousTypes) Declare (stream, *type);
	if (!module.anonymousTypes.empty ()) stream << '\n';
	Declare (stream, module.declarations);
	currentScope = nullptr;

	EndBlock (Indent (stream) << "static void __body ();\n", ';') << '\n';

	for (auto type: module.anonymousTypes) if (!type->record.baseType) Define (stream, *type);
	for (auto& declaration: module.declarations) if (IsRecord (declaration)) Define (stream, *declaration.type);
	for (auto type: module.anonymousTypes) if (type->record.baseType) Define (stream, *type);

	if (IsGeneric (module)) for (auto& declaration: module.declarations) if (!IsType (declaration)) Define (stream, declaration);

	if (IsGeneric (module)) DefineBody (Print (stream, *module.definitions));

	if (module.identifier.parent) EndBlock (stream) << '\n';

	return Indent (stream) << "#endif // " << includeGuard << '\n';
}

std::ostream& Context::Define (std::ostream& stream, const Module& module)
{
	if (!InsertUnique (&module, definitions)) return stream;
	for (auto& declaration: module.declarations) if (IsImport (declaration) && IsModule (*declaration.import.scope)) Define (stream, *declaration.import.scope->module);
	return IsParameterized (module) ? Print (Indent (stream) << "template struct ", module) << ";\n\n" : stream;
}

std::ostream& Context::Define (std::ostream& stream, const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		return stream;

	case Declaration::Constant:
		if (IsIdentifier (*declaration.constant.expression) && IsPredeclared (*declaration.constant.expression->identifier.declaration)) return stream;
		if (IsModule (declaration.constant.expression->value) || IsType (declaration.constant.expression->value)) return stream;
		if (IsModule (*declaration.scope) && IsGeneric (*declaration.scope->module)) Print (stream, *declaration.scope->module->definitions);
		return Print (Print (Indent (stream), *declaration.constant.expression->type, &declaration, false, true) << " = ", *declaration.constant.expression) << ";\n\n";

	case Declaration::Type:
		return IsRecord (declaration) ? Define (stream, *declaration.type) : Declare (stream, declaration);

	case Declaration::Variable:
		if (IsForward (declaration)) return stream;
		if (IsModule (*declaration.scope) && IsGeneric (*declaration.scope->module)) Print (stream, *declaration.scope->module->definitions);
		Print (Indent (stream), *declaration.variable.type, &declaration);
		if (IsPointer (*declaration.variable.type)) stream << " = nullptr";
		if (IsArray (*declaration.variable.type)) Construct (Print (stream << " {", *declaration.variable.type->array.length) << ", ", *declaration.variable.type->array.elementType) << '}';
		return stream << ";\n\n";

	case Declaration::Procedure:
	{
		if (declaration.procedure.signature.parent) for (auto definition = &declaration; definition; definition = definition->procedure.definition)
			if (IsForward (*definition)) continue; else if (!InsertUnique (definition, procedures)) break;
			else Print (Print (Print (Indent (stream) << "std::function<", declaration.procedure.signature.result), declaration.procedure.signature) << "> ", declaration) << ";\n\n";
		if (IsAbstract (declaration) || IsForward (declaration)) return stream;
		if (IsGeneric (module)) Print (stream, *module.definitions); Indent (stream);
		if (declaration.procedure.signature.parent) Print (stream, declaration) << " = [&]";
		else Print (Print (stream, declaration.procedure.signature.result) << ' ', declaration);
		BeginBlock (Print (stream << ' ', declaration.procedure.signature) << '\n');
		if (declaration.procedure.declarations) Define (stream, *declaration.procedure.declarations);
		if (declaration.procedure.body) Print (stream, declaration.procedure.body->statements);
		return EndBlock (stream, declaration.procedure.signature.parent ? ';' : 0) << '\n';
	}

	default:
		assert (Declaration::Unreachable);
	}
}

std::ostream& Context::Define (std::ostream& stream, const Declarations& declarations)
{
	for (auto& declaration: declarations) if (IsRecord (declaration)) Define (stream, declaration);
	for (auto& declaration: declarations) if (!IsRecord (declaration)) Define (stream, declaration);
	return stream;
}

std::ostream& Context::Define (std::ostream& stream, const Type& type)
{
	assert (IsRecord (type)); assert (!IsAlias (type));
	if (IsGeneric (module)) Print (stream, *module.definitions);
	Print (Indent (stream) << "struct ", type);
	if (IsFinal (type)) stream << " final";
	if (type.record.baseType) Print (stream << " : ", *type.record.baseType);
	BeginBlock (stream << '\n'); currentScope = type.record.scope;
	if (type.record.declarations) for (auto& declaration: *type.record.declarations) Define (stream, declaration);
	for (auto& object: type.record.scope->objects) if (IsProcedure (*object.second)) Declare (stream, *object.second);
	if (HasDynamicType (type) && !type.record.baseType) currentScope = currentScope->parent, Print (Indent (stream) << "virtual ~", type) << " () = default;\n";
	currentScope = nullptr; return EndBlock (stream, ';') << '\n';
}

std::ostream& Context::Declare (std::ostream& stream, const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		return stream;

	case Declaration::Constant:
		if (IsIdentifier (*declaration.constant.expression) && IsPredeclared (*declaration.constant.expression->identifier.declaration)) return stream; Indent (stream);
		if (IsModule (declaration.constant.expression->value) || IsType (declaration.constant.expression->value)) return Print (Print (stream << "using ", declaration.name) << " = ", *declaration.constant.expression) << ";\n";
		if (IsModule (*declaration.scope)) stream << "static ";
		return Print (stream, *declaration.constant.expression->type, &declaration, false, true) << ";\n";

	case Declaration::Type:
		if (IsRecord (declaration)) return Declare (stream, *declaration.type);
		Print (Indent (stream) << "using ", declaration) << " = ";
		return (IsSelfReferencing (declaration) ? stream << (IsProcedure (*declaration.type) ? "void(*)()" : "void*") : Print (stream, *declaration.type)) << ";\n";

	case Declaration::Variable:
		if (IsForward (declaration)) return stream;
		Indent (stream); if (IsModule (*declaration.scope)) stream << "static ";
		return Print (stream, *declaration.variable.type, &declaration) << ";\n";

	case Declaration::Procedure:
		if (IsForward (declaration) || declaration.scope != currentScope) return stream;
		Indent (stream); if (IsModule (*declaration.scope)) stream << "static ";
		if (IsTypeBound (declaration) && !IsFinal (declaration) && !declaration.procedure.definition) stream << "virtual ";
		Print (Print (Print (stream, declaration.procedure.signature.result) << ' ', declaration) << ' ', declaration.procedure.signature);
		if (IsFinal (declaration) && !IsFinal (*declaration.procedure.signature.receiver->parameter.type) && declaration.procedure.definition) stream << " final";
		if (IsTypeBound (declaration) && declaration.procedure.definition) stream << " override"; if (IsAbstract (declaration)) stream << " = 0";
		return stream << ";\n";

	case Declaration::Parameter:
		if (!IsVariableOpenByteArrayParameter (declaration)) return Print (stream, *declaration.parameter.type, &declaration, declaration.parameter.isVariable || (IsArray (*declaration.parameter.type) || IsRecord (*declaration.parameter.type)) && declaration.parameter.isReadOnly, declaration.parameter.isReadOnly);
		stream << "Oberon::Span<"; if (declaration.parameter.isReadOnly) stream << "const "; return Print (stream << "SYSTEM::BYTE> ", declaration.name);

	default:
		assert (Declaration::Unreachable);
	}
}

std::ostream& Context::Declare (std::ostream& stream, const Declarations& declarations)
{
	for (auto& declaration: declarations) if (IsRecord (declaration)) Declare (stream, declaration);
	for (auto& declaration: declarations) if (!IsRecord (declaration)) Declare (stream, declaration);
	return stream;
}

std::ostream& Context::Declare (std::ostream& stream, const Type& type)
{
	assert (IsRecord (type)); assert (!IsAlias (type));
	return Print (Indent (stream) << "struct ", type) << ";\n";
}

std::ostream& Context::Construct (std::ostream& stream, const Type& type)
{
	if (IsPointer (type)) return stream << "nullptr"; Print (stream, type) << " {";
	if (IsArray (type)) Construct (Print (stream, *type.array.length) << ", ", *type.array.elementType);
	return stream << '}';
}

std::ostream& Context::Print (std::ostream& stream, const Statements& statements)
{
	for (auto& statement: statements) Print (stream, statement); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Statement& statement)
{
	switch (statement.model)
	{
	case Statement::If:
		EndBlock (Print (BeginBlock (Print (Indent (stream) << "if (", *statement.if_.condition) << ")\n"), *statement.if_.thenPart));
		if (statement.if_.elsifs) for (auto& elsif: *statement.if_.elsifs) Print (stream, elsif);
		if (statement.if_.elsePart) EndBlock (Print (BeginBlock (Indent (stream) << "else\n"), *statement.if_.elsePart));
		return stream;

	case Statement::For:
		Indent (stream) << "for ("; if (!IsConstant (*statement.for_.end)) Print (stream << "const auto _end = ", *statement.for_.end) << ", _temp = ";
		Print (Print (Print (stream, *statement.for_.variable) << " = ", *statement.for_.begin) << "; ", *statement.for_.variable) << (statement.for_.step && IsSigned (*statement.for_.step->type) && statement.for_.step->value.signed_ < 0 ? " >= " : " <= ");
		if (IsConstant (*statement.for_.end)) Print (stream, *statement.for_.end); else stream << "_end";
		return EndBlock (Print (BeginBlock ((statement.for_.step ? Print (Print (stream << "; ", *statement.for_.variable) << " += ", *statement.for_.step) : Print (stream << "; ++", *statement.for_.variable)) << ")\n"), *statement.for_.statements));

	case Statement::Case:
		BeginBlock (Print (Indent (stream) << "switch (", *statement.case_.expression) << ")\n");
		if (statement.case_.cases) for (auto& case_: *statement.case_.cases) Print (stream, case_);
		Increase (Indent (Decrease (stream)) << "default:\n");
		return EndBlock (statement.case_.elsePart ? Indent (Print (stream, *statement.case_.elsePart)) << "break;\n" : Indent (stream) << "std::abort ();\n");

	case Statement::Exit:
		return Indent (stream) << "break;\n";

	case Statement::Loop:
		return EndBlock (Print (BeginBlock (Indent (stream) << "for (;;)\n"), *statement.loop.statements));

	case Statement::With:
		for (auto& guard: *statement.with.guards) EndBlock (Print (BeginBlock (PrintGuard ((IsFirst (guard, *statement.with.guards) ? Indent (stream) : Indent (stream) << "else ") << "if (", guard.expression, guard.type, true) << ")\n"), guard.statements));
		return statement.with.elsePart ? EndBlock (Print (BeginBlock (Indent (stream) << "else\n"), *statement.with.elsePart)) : Indent (stream) << "else std::abort ();\n";

	case Statement::While:
		return EndBlock (Print (BeginBlock (Print (Indent (stream) << "while (", *statement.while_.condition) << ")\n"), *statement.while_.statements));

	case Statement::Repeat:
		return Print (Indent (EndBlock (Print (BeginBlock (Indent (stream) << "do\n"), *statement.while_.statements))) << "while (!(", *statement.while_.condition) << "));\n";

	case Statement::Return:
		Indent (stream) << "return";
		if (statement.return_.expression) Print (stream << ' ', *statement.return_.expression);
		return stream << ";\n";

	case Statement::Assignment:
		if (IsRecord (*statement.assignment.designator->type) && HasDynamicType (*statement.assignment.designator))
			return Print (Print (Indent (stream) << "Oberon::Assign (", *statement.assignment.designator) << ", ", *statement.assignment.expression) << ");\n";
		return Print (Print (Indent (stream), *statement.assignment.designator) << " = ", *statement.assignment.expression) << ";\n";

	case Statement::ProcedureCall:
		return Print (Indent (stream), *statement.procedureCall.designator) << ";\n";

	default:
		assert (Statement::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Elsif& elsif)
{
	return EndBlock (Print (BeginBlock (Print (Indent (stream) << "else if (", elsif.condition) << ")\n"), elsif.statements));
}

std::ostream& Context::Print (std::ostream& stream, const Case& case_)
{
	for (auto& label: case_.labels) PrintLabel (stream, label);
	return Indent (Print (stream, case_.statements)) << "break;\n";
}

std::ostream& Context::Print (std::ostream& stream, const Expression& expression)
{
	if ((IsIdentifier (expression) || IsSelector (expression)) && IsAlias (*expression.type) && IsSelfReferencing (*expression.type->identifier->declaration))
		return PrintBasic (Print (stream << "reinterpret_cast<", *expression.type, nullptr, false, false, true) << "> (", expression) << ')';
	if (IsObject (expression) && expression.type != expression.identifier.declaration->object.type) return PrintGuard (stream, expression, *expression.type, false);
	return PrintBasic (stream, expression);
}

std::ostream& Context::PrintLabel (std::ostream& stream, const Expression& expression)
{
	const auto range = GetRange (expression);
	for (auto value = range.lower; value != range.upper; ++value) PrintLabel (stream, value, *expression.type);
	return PrintLabel (stream, range.upper, *expression.type);
}

std::ostream& Context::PrintLabel (std::ostream& stream, const Value& value, const Type& type)
{
	return Increase (Print (Indent (Decrease (stream)) << "case ", value, type) << ":\n");
}

std::ostream& Context::PrintBasic (std::ostream& stream, const Expression& expression)
{
	if (IsConstant (expression) && !IsGeneric (expression)) return Print (stream, expression.value, *expression.type);

	switch (expression.model)
	{
	case Expression::Set:
		Print (stream << '(', *expression.type) << " {}";
		if (expression.set.elements) for (auto& element: *expression.set.elements)
			if (IsRange (element)) Print (Print (Print (stream << " + ", *expression.type) << " (", *element.binary.left) << ", ", *element.binary.right) << ')';
			else Print (Print (stream << " + ", *expression.type) << " (1 << ", element) << ')';
		return stream << ')';

	case Expression::Call:
		if (expression.CallsCode (transpiler.platform)) return Print (stream << "asm (", GetArgument (expression, 0)) << ')';
		if (expression.Calls (transpiler.platform.systemVal)) return Print (Print (stream << "SYSTEM::VAL<", *GetArgument (expression, 0).type) << "> (", GetArgument (expression, 1)) << ')';
		if (expression.Calls (transpiler.platform.globalSel)) return Print (Print (Print (stream << '(', GetArgument (expression, 0)) << " ? ", GetArgument (expression, 1)) << " : ", GetArgument (expression, 2)) << ')';
		if (IsType (*expression.call.designator) && IsIdentifier (*expression.call.designator)) Print (stream, expression.call.designator->identifier); else Print (stream, *expression.call.designator); stream << " (";
		if (expression.call.arguments) for (auto& argument: *expression.call.arguments) PrintBasic (IsFirst (argument, *expression.call.arguments) ? stream : stream << ", ", argument);
		if (expression.Calls (transpiler.platform.globalNew)) for (auto type = GetArgument (expression, 0).type->pointer.baseType; IsArray (*type); type = type->array.elementType) if (!IsOpenArray (*type)) Print (stream << ", ", *type->array.length);
		return stream << ')';

	case Expression::Index:
		return Print (Print (stream, *expression.index.designator) << '[', *expression.index.expression) << ']';

	case Expression::Super:
		return Print (stream << "this->", *expression.super.declaration);

	case Expression::Unary:
	{
		const auto& operand = *expression.unary.operand;

		switch (expression.unary.operator_)
		{
		case Lexer::Plus:
			return Print (stream << '+', operand);
		case Lexer::Minus:
			return Print (stream << '-', operand);
		case Lexer::Not:
			return Print (stream << '!', operand);
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Binary:
	{
		const auto& left = *expression.binary.left;
		const auto& right = *expression.binary.right;

		switch (expression.binary.operator_)
		{
		case Lexer::Plus:
			return Print (Print (stream, left) << " + ", right);
		case Lexer::Minus:
			return Print (Print (stream, left) << " - ", right);
		case Lexer::Asterisk:
			return Print (Print (stream, left) << " * ", right);
		case Lexer::Slash:
		case Lexer::Div:
			return Print (Print (stream, left) << " / ", right);
		case Lexer::Mod:
			return Print (Print (stream, left) << " % ", right);
		case Lexer::And:
			return Print (Print (stream << '(', left) << " && ", right) << ')';
		case Lexer::Or:
			return Print (Print (stream << '(', left) << " || ", right) << ')';
		case Lexer::Equal:
			return Print (Print (stream, left) << " == ", right);
		case Lexer::Unequal:
			return Print (Print (stream, left) << " != ", right);
		case Lexer::Less:
			return Print (Print (stream, left) << " < ", right);
		case Lexer::LessEqual:
			return Print (Print (stream, left) << " <= ", right);
		case Lexer::Greater:
			return Print (Print (stream, left) << " > ", right);
		case Lexer::GreaterEqual:
			return Print (Print (stream, left) << " >= ", right);
		case Lexer::In:
			return Print (Print (stream, right) << '[', left) << ']';
		case Lexer::Is:
			return PrintGuard (stream, left, *right.type, true);
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Selector:
		if (IsReceiver (*expression.selector.designator)) stream << "this->";
		else if (IsDereference (*expression.selector.designator)) Print (stream, *expression.selector.designator->dereference.expression) << "->";
		else if (IsPointer (*expression.selector.designator->type)) Print (stream, *expression.selector.designator) << "->";
		else if (IsIdentifier (*expression.selector.designator) && IsGenericParameter (*expression.selector.designator->identifier.declaration)) Print (stream, expression.selector.designator->identifier) << "::";
		else Print (stream, *expression.selector.designator) << '.';
		return Print (stream, *expression.selector.identifier);

	case Expression::Promotion:
		if (IsInteger (*expression.promotion.expression->type) && IsReal (*expression.type))
			return Print (Print (stream, *expression.type) << " (", *expression.promotion.expression) << ')';
		return Print (stream, *expression.promotion.expression);

	case Expression::TypeGuard:
		return PrintGuard (stream, *expression.typeGuard.designator, *expression.type, false);

	case Expression::Conversion:
		return Print (Print (stream, expression.conversion.designator->identifier) << " (", *expression.conversion.expression) << ')';

	case Expression::Identifier:
		if (IsReceiver (*expression.identifier.declaration)) return stream << (IsRecord (*expression.type) ? "(*this)" : "this");
		if (IsGenericParameter (*expression.identifier.declaration)) return Print (stream, expression.identifier) << "::Value";
		return Print (stream, expression.identifier);

	case Expression::Dereference:
		return Print (stream << "(*", *expression.dereference.expression) << ')';

	case Expression::Parenthesized:
		return Print (stream << '(', *expression.parenthesized.expression) << ')';

	default:
		assert (Expression::Unreachable);
	}
}

std::ostream& Context::PrintGuard (std::ostream& stream, const Expression& expression, const Type& type, const bool pointer)
{
	return PrintBasic (Print (stream << "dynamic_cast<", type, nullptr, IsRecord (type) && !pointer, IsReadOnly (expression)) << (IsRecord (type) && pointer ? "*> (&" : "> ("), expression) << ')';
}

String Context::GetIncludeGuard (const QualifiedIdentifier& identifier)
{
	assert (identifier.name); return Uppercase (identifier.name->string + "_header_included");
}

bool Context::IsSelfReferencing (const Declaration& declaration)
{
	return IsType (declaration) && !IsPredeclared (declaration) && References (*declaration.type, declaration);
}

bool Context::References (const Type& type, const Declaration& declaration)
{
	if (IsAlias (type)) return type.identifier->declaration == &declaration;

	switch (type.model)
	{
	case Type::Array: return References (*type.array.elementType, declaration);
	case Type::Record: return false;
	case Type::Pointer: return References (*type.pointer.baseType, declaration);
	case Type::Procedure: if (type.procedure.signature.parameters) for (auto& parameter: *type.procedure.signature.parameters) if (References (*parameter.parameter.type, declaration)) return true;
		return type.procedure.signature.result && References (*type.procedure.signature.result, declaration);
	default: assert (Type::Unreachable);
	}
}

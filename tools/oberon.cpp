// Oberon representation
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

#include "layout.hpp"
#include "oberon.hpp"
#include "utilities.hpp"

#include <cassert>
#include <iomanip>

using namespace ECS;
using namespace Oberon;

Identifier::Identifier (const char*const s) :
	string {s}
{
}

bool QualifiedIdentifier::operator == (const QualifiedIdentifier& other) const
{
	assert (name); assert (other.name); return name->string == other.name->string && (!parent && !other.parent || parent && other.parent && *parent == *other.parent);
}

bool Signature::Matches (const Signature& signature) const
{
	return (!receiver && !signature.receiver || receiver && signature.receiver && receiver->parameter.isVariable == signature.receiver->parameter.isVariable && receiver->parameter.isReadOnly == signature.receiver->parameter.isReadOnly) &&
		parent == signature.parent && (parameters ? parameters->size () : 0) == (signature.parameters ? signature.parameters->size () : 0) &&
		(!parameters || !signature.parameters || std::equal (parameters->begin (), parameters->end (), signature.parameters->begin (), signature.parameters->end (), [] (const Declaration& left, const Declaration& right) {return left.Matches (right);})) &&
		(!result && !signature.result || result && signature.result && result->IsSameAs (*signature.result));
}

bool Signature::IsIdenticalTo (const Signature& signature) const
{
	return Matches (signature) && (!receiver && !signature.receiver || receiver && signature.receiver && receiver->Matches (*signature.receiver));
}

Type::Type (Type& type, const bool isReadOnly) :
	model {Pointer}, identifier {nullptr}, pointer {&type, true, isReadOnly}
{
}

Type::Type (const Signature& signature) :
	model {Procedure}, identifier {nullptr}, procedure {signature}
{
}

Type::Type (const Position& p, QualifiedIdentifier& i) :
	model {Identifier}, position {p}, identifier {&i}
{
}

Type::Type (const Model m, const Size size, QualifiedIdentifier& i) :
	model {m}, identifier {&i}
{
	assert (identifier->declaration); auto& declaration = *identifier->declaration;
	assert (IsType (declaration)); assert (declaration.scope); assert (IsGlobal (*declaration.scope));
	if (size) basic.size = size; else declaration.scope->objects.erase (declaration.name.string);
}

bool Type::Names (const Type& type) const
{
	return identifier && (this == &type || identifier->declaration->type != this && identifier->declaration->type->Names (type));
}

bool Type::IsSameAs (const Type& type) const
{
	return identifier && type.identifier && (identifier->declaration == type.identifier->declaration || identifier->declaration->type != this && identifier->declaration->type->IsSameAs (type) || type.identifier->declaration->type != &type && type.identifier->declaration->type->IsSameAs (*this)) || &type == this && !IsOpenArray (type);
}

bool Type::IsEqualTo (const Type& type) const
{
	return IsSameAs (type) || IsOpenArray (*this) && IsOpenArray (type) && array.elementType->IsEqualTo (*type.array.elementType) || IsProcedure (*this) && IsProcedure (type) && procedure.signature.Matches (type.procedure.signature);
}

bool Type::Includes (const Type& type) const
{
	assert (IsArithmetic (type));
	switch (model)
	{
	case Signed: return IsSigned (type) && signed_.size >= type.signed_.size || IsUnsigned (type) && signed_.size > type.unsigned_.size;
	case Unsigned: return IsInteger (type) && unsigned_.size >= type.integer.size;
	case Real: return IsInteger (type) || IsReal (type) && real.size >= type.real.size;
	case Complex: return IsInteger (type) || IsReal (type) && complex.size >= type.real.size || IsComplex (type) && complex.size >= type.complex.size;
	case Set: return IsSet (type) && set.size >= type.set.size;
	default: assert (Unreachable);
	}
}

bool Type::Extends (const Type& type) const
{
	return IsSameAs (type) || IsRecord (*this) && IsRecord (type) && record.baseType && record.baseType->Extends (type) || IsPointer (*this) && IsPointer (type) && pointer.baseType->Extends (*type.pointer.baseType);
}

bool Type::IsArrayCompatibleWith (const Type& type) const
{
	return IsSameAs (type) || IsArray (*this) && IsOpenArray (type) && array.elementType->IsArrayCompatibleWith (*type.array.elementType);
}

void Type::Initialize (Objects& objects, const bool initialize) const
{
	assert (model == Record);
	if (record.baseType) record.baseType->Initialize (objects, initialize);
	if (record.declarations) Object::Initialize (objects, *record.declarations, initialize);
}

Complex Complex::operator + () const
{
	return {+real, +imag};
}

Complex Complex::operator - () const
{
	return {-real, -imag};
}

Complex Complex::operator + (const Complex other) const
{
	return {real + other.real, imag + other.imag};
}

Complex Complex::operator - (const Complex other) const
{
	return {real - other.real, imag - other.imag};
}

Complex Complex::operator * (const Complex other) const
{
	return {real * other.real - imag * other.imag, real * other.imag + imag * other.real};
}

Complex Complex::operator / (const Complex other) const
{
	const auto divisor = other.real * other.real + other.imag * other.imag; assert (divisor);
	return {(real * other.real + imag * other.imag) / divisor, (imag * other.real - real * other.imag) / divisor};
}

bool Complex::operator == (const Complex other) const
{
	return real == other.real && imag == other.imag;
}

Set Set::operator + () const
{
	return {mask};
}

Set Set::operator - () const
{
	return {~mask};
}

Set Set::operator + (const Set other) const
{
	return {mask | other.mask};
}

Set Set::operator - (const Set other) const
{
	return {mask & ~other.mask};
}

Set Set::operator * (const Set other) const
{
	return {mask & other.mask};
}

Set Set::operator / (const Set other) const
{
	return {mask ^ other.mask};
}

bool Set::operator == (const Set other) const
{
	return mask == other.mask;
}

Set& Set::operator += (const Range range)
{
	mask |= Convert (range); return *this;
}

Set& Set::operator += (const Element element)
{
	mask |= Convert (element); return *this;
}

Set& Set::operator -= (const Element element)
{
	mask &= ~Convert (element); return *this;
}

bool Set::operator [] (const Element element) const
{
	return mask & Convert (element);
}

Set::Mask Set::Convert (const Element element)
{
	return ShiftLeft (Mask {1}, element);
}

Set::Mask Set::Convert (const Range range)
{
	return ShiftLeft (~Mask {0}, range.lower) & ~ShiftLeft (~Mask {1}, range.upper);
}

Value::Value (const Boolean b) :
	model {Type::Boolean}, boolean {b}
{
}

Value::Value (const Character c) :
	model {Type::Character}, character {c}
{
}

Value::Value (const Signed s) :
	model {Type::Signed}, signed_ {s}
{
}

Value::Value (const Unsigned u) :
	model {Type::Unsigned}, unsigned_ {u}
{
}

Value::Value (const Real r) :
	model {Type::Real}, real {r}
{
}

Value::Value (const Complex c) :
	model {Type::Complex}, complex {c}
{
}

Value::Value (const Set s) :
	model {Type::Set}, set {s}
{
}

Value::Value (const Byte b) :
	model {Type::Byte}, byte {b}
{
}

Value::Value (const Any a) :
	model {Type::Any}, any {a}
{
}

Value::Value (const String& s) :
	model {Type::String}, string {&s}
{
}

Value::Value (std::nullptr_t) :
	model {Type::Nil}
{
}

Value::Value (Object*const p) :
	model {Type::Pointer}, pointer {p}
{
}

Value::Value (const Declaration* declaration) :
	model {Type::Procedure}, procedure {declaration}
{
	if (declaration) assert (IsProcedure (*declaration));
}

Value::Value (Declaration& declaration) :
	model {Type::Module}, module {&declaration}
{
	assert (IsImport (declaration));
}

Value::Value (Type& t) :
	model {Type::Identifier}, type {&t}
{
}

Value& Value::operator ++ ()
{
	switch (model)
	{
	case Type::Character: return ++character, *this;
	case Type::Signed: return ++signed_, *this;
	case Type::Unsigned: return ++unsigned_, *this;
	default: assert (Type::Unreachable);
	}
}

bool Value::operator == (const Value& other) const
{
	assert (other.model == model);

	switch (model)
	{
	case Type::Boolean: return boolean == other.boolean;
	case Type::Character: return character == other.character;
	case Type::Signed: return signed_ == other.signed_;
	case Type::Unsigned: return unsigned_ == other.unsigned_;
	case Type::Real: return real == other.real;
	case Type::Complex: return complex == other.complex;
	case Type::Set: return set == other.set;
	case Type::Byte: return byte == other.byte;
	case Type::Any: return any == other.any;
	case Type::String: return *string == *other.string;
	case Type::Nil: return true;
	case Type::Pointer: return pointer == other.pointer;
	case Type::Procedure: return procedure == other.procedure;
	case Type::Module: return module->import.scope == other.module->import.scope;
	case Type::Identifier: return type->IsSameAs (*other.type) && !IsGeneric (*type);
	default: assert (Type::Unreachable);
	}
}

bool Value::operator < (const Value& other) const
{
	assert (other.model == model);

	switch (model)
	{
	case Type::Character: return character < other.character;
	case Type::Signed: return signed_ < other.signed_;
	case Type::Unsigned: return unsigned_ < other.unsigned_;
	case Type::Real: return real < other.real;
	case Type::Byte: return byte < other.byte;
	default: assert (Type::Unreachable);
	}
}

Object::Object (const Value& value) :
	Value {value}
{
	switch (model)
	{
	case Type::String:
		model = Type::Array; elements.resize (value.string->size () + 1); array = &elements; operator = (*value.string);
		break;

	case Type::Array:
		elements = *array; array = &elements;
		break;

	case Type::Record:
		elements = *record.fields; record.fields = &elements;
		break;
	}
}

Object::Object (const Type& type, const bool initialize)
{
	if (!initialize && !NeedsInitialization (type) && !IsArray (type) && !IsRecord (type)) return;

	model = type.model;

	switch (model)
	{
	case Type::Boolean:
		boolean = false;
		break;

	case Type::Character:
		character = 0;
		break;

	case Type::Signed:
		signed_ = 0;
		break;

	case Type::Unsigned:
		unsigned_ = 0;
		break;

	case Type::Real:
		real = 0;
		break;

	case Type::Complex:
		complex.real = 0;
		complex.imag = 0;
		break;

	case Type::Set:
		set.mask = 0;
		break;

	case Type::Byte:
		byte = 0;
		break;

	case Type::Any:
		any = nullptr;
		break;

	case Type::Array:
		assert (type.array.length); array = &elements; elements.reserve (type.array.length->value.signed_);
		for (auto length = type.array.length->value.signed_; length; --length) elements.emplace_back (*type.array.elementType, initialize);
		break;

	case Type::Record:
		record.type = &type; record.fields = &elements;
		type.Initialize (elements, initialize);
		break;

	case Type::Pointer:
		pointer = nullptr;
		break;

	case Type::Procedure:
		procedure = nullptr;
		break;

	default:
		assert (Type::Unreachable);
	}
}

Object::Object (const Size size, const String& string) :
	Object {size, Object {}}
{
	operator = (string);
}

Object::Object (const Size size, const Object& value) :
	elements {size, value}
{
	model = Type::Array; array = &elements;
}

void Object::Initialize (Objects& objects, const Declarations& declarations, const bool initialize)
{
	for (auto& declaration: declarations) if (IsVariable (declaration)) objects.emplace_back (*declaration.variable.type, initialize);
}

Object& Object::operator = (const Value& value)
{
	switch (model)
	{
	case Type::Array:
		if (IsString (value)) return operator = (*value.string);
		return elements = *value.array, *this;

	case Type::Record:
		assert (value.record.fields->size () >= elements.size ());
		return elements.assign (value.record.fields->begin (), value.record.fields->begin () + elements.size ()), *this;

	default:
		return Value::operator = (value), *this;
	}
}

Object& Object::operator = (const String& string)
{
	const Size length = std::min (string.size (), elements.size () - 1);
	for (Size index = 0; index != length; ++index) elements[index] = Character (string[index]);
	elements[length] = Character {0}; return *this;
}

Scope::Scope (QualifiedIdentifier*const i) :
	model {Global}, identifier {i}
{
}

Scope::Scope (struct Module& m, Scope& p) :
	model {Module}, parent {&p}, module {&m}
{
	assert (IsGlobal (*parent));
}

Scope::Scope (struct Signature& s, Scope& p) :
	model {Signature}, parent {&p}, signature {&s}
{
}

Scope::Scope (Type& type, Scope& p) :
	model {Record}, parent {&p}, record {&type}
{
	assert (IsRecord (type));
}

void Scope::Initialize (Objects& objects, const bool initialize) const
{
	objects.reserve (count);

	switch (model)
	{
	case Module:
		Object::Initialize (objects, module->declarations, initialize);
		break;

	case Procedure:
		if (procedure->procedure.declarations) Object::Initialize (objects, *procedure->procedure.declarations, initialize);
		break;

	case Record:
		record->Initialize (objects, initialize);
		break;

	default:
		assert (Unreachable);
	}
}

Declaration* Scope::LookupImport (const Scope& scope) const
{
	assert (model == Module);
	for (auto& object: objects) if (IsImport (*object.second) && object.second->import.scope == &scope) return object.second;
	return nullptr;
}

Declaration* Scope::Lookup (const Identifier& identifier, const struct Module& module) const
{
	if (const auto object = objects.find (identifier.string); object != objects.end () && IsVisible (*object->second, module)) return object->second;
	if (model == Record && record->record.baseType && IsRecord (*record->record.baseType)) return record->record.baseType->record.scope->Lookup (identifier, module);
	return nullptr;
}

bool Scope::BelongsTo (const struct Module& module) const
{
	for (auto scope = this; scope; scope = scope->parent) if (scope == module.scope) return true; return false;
}

Expression::Expression (Type& t, const Value& v) :
	model {Unreachable}, type {&t}, value {v}
{
}

bool Expression::operator == (const Expression& other) const
{
	return value.model == other.value.model && value == other.value;
}

bool Expression::Calls (const Declaration& declaration) const
{
	assert (IsCall (*this)); assert (IsProcedure (declaration));
	return IsConstant (*call.designator) && call.designator->value.procedure == &declaration;
}

bool Expression::CallsCode (const Platform& platform) const
{
	return Calls (platform.systemAsm) || Calls (platform.systemCode);
}

bool Expression::IsAssignmentCompatibleWith (const Type& other) const
{
	switch (type->model)
	{
	case Type::Void:
	case Type::Real:
	case Type::Complex:
	case Type::Byte:
	case Type::Any:
	case Type::Nil:
	case Type::Procedure:
	case Type::Module:
	case Type::Identifier:
		return IsExpressionCompatibleWith (other);
	case Type::Boolean:
	case Type::Character:
	case Type::Signed:
	case Type::Unsigned:
	case Type::Set:
		return IsByte (other) && type->basic.size == other.byte.size || IsExpressionCompatibleWith (other);
	case Type::String:
		return (IsCharacter (other) || IsByte (other)) && value.string->size () == 1 || IsCharacterArray (other) && !IsOpenArray (other) && value.string->size () < Oberon::Unsigned (other.array.length->value.signed_);
	case Type::Array:
		return type->IsSameAs (other);
	case Type::Record:
		return type->Extends (other);
	case Type::Pointer:
		return IsAny (other) && !type->pointer.isReadOnly || IsExpressionCompatibleWith (other) && (other.pointer.isReadOnly || !type->pointer.isReadOnly);
	default:
		assert (Unreachable);
	}
}

bool Expression::IsParameterCompatibleWith (const Declaration& declaration) const
{
	assert (IsParameter (declaration));
	if (IsVariableParameter (declaration) && !IsReadOnlyParameter (declaration) && IsReadOnly (*this)) return false;
	if (IsOpenArray (*declaration.parameter.type)) return type->IsArrayCompatibleWith (*declaration.parameter.type) || IsVariableOpenByteArrayParameter (declaration) && IsVariable (*this) || !IsVariableParameter (declaration) && IsCharacterArray (*declaration.parameter.type) && IsString (*type);
	if (!IsVariableParameter (declaration)) return IsAssignmentCompatibleWith (*declaration.parameter.type) && (!IsString (*type) || !IsReadOnlyParameter (declaration) || !IsCharacterArray (*declaration.parameter.type) || IsOpenArray (*declaration.parameter.type) || value.string->size () == Oberon::Unsigned (declaration.parameter.type->array.length->value.signed_)); else if (!IsVariable (*this)) return false;
	if (IsByte (*declaration.parameter.type)) return IsAssignmentCompatibleWith (*declaration.parameter.type);
	if (IsRecord (*type)) return type->Extends (*declaration.parameter.type);
	return type->IsSameAs (*declaration.parameter.type);
}

bool Expression::IsExpressionCompatibleWith (const Type& other) const
{
	switch (type->model)
	{
	case Type::Void:
	case Type::Record:
	case Type::Identifier:
		return false;
	case Type::Boolean:
	case Type::Byte:
	case Type::Any:
	case Type::Module:
		return type->IsSameAs (other);
	case Type::Character:
		return type->IsSameAs (other) || IsStringable (other) && IsValid (value);
	case Type::Signed:
	case Type::Unsigned:
	case Type::Real:
	case Type::Complex:
		return IsNumeric (other) && other.Includes (*type);
	case Type::Set:
		return IsSet (other) && other.Includes (*type);
	case Type::String:
		return IsCharacter (other) && IsValid (value) && value.string->size () == 1 || IsCharacterArray (other);
	case Type::Nil:
		return IsAny (other) || IsNil (other) || IsDereferencable (other) || IsProcedure (other);
	case Type::Array:
		return IsCharacter (*type->array.elementType) && IsCharacterArray (other);
	case Type::Pointer:
		return type->pointer.isVariable == other.pointer.isVariable && (type->Extends (other) || IsVariablePointer (*type) && IsVariablePointer (other) && IsOpenArray (*other.pointer.baseType) && type->pointer.baseType->IsArrayCompatibleWith (*other.pointer.baseType));
	case Type::Procedure:
		return IsProcedure (other) && type->procedure.signature.Matches (other.procedure.signature);
	default:
		assert (Unreachable);
	}
}

Definition::Definition (const char*const n, const bool e) :
	name {n}, isExported {e}
{
}

Declaration::Declaration (const Model m, const char*const n, Scope& s) :
	Definition {n, true}, model {m}, scope {&s}
{
	s.objects[name.string] = this;
}

Declaration::Declaration (const Definition& d, struct Type& t) :
	Definition {d}, model {Type}, type {&t}
{
	assert (IsGeneric (*type));
}

Declaration::Declaration (const Definition& d, Expression& expression) :
	Definition {d}, model {IsType (expression) ? Type : Constant}
{
	assert (IsConstant (expression)); if (IsType (expression)) type = expression.type; else constant.expression = &expression;
}

bool Declaration::IsIdenticalTo (const Declaration& declaration) const
{
	assert (IsStorage (declaration));
	if (model != declaration.model || isExported != declaration.isExported || storage.external && (!declaration.storage.external || *storage.external != *declaration.storage.external)) return false;
	return IsVariable (declaration) && variable.isReadOnly == declaration.variable.isReadOnly && variable.type->IsSameAs (*declaration.variable.type) ||
		IsProcedure (declaration) && procedure.isAbstract == declaration.procedure.isAbstract && procedure.isFinal == declaration.procedure.isFinal && procedure.signature.IsIdenticalTo (declaration.procedure.signature);
}

bool Declaration::Matches (const Declaration& declaration) const
{
	assert (IsParameter (*this)); assert (IsParameter (declaration));
	return parameter.isVariable == declaration.parameter.isVariable && parameter.isReadOnly == declaration.parameter.isReadOnly && parameter.type->IsEqualTo (*declaration.parameter.type);
}

Module::Module (const Source& s) :
	source {s}, expressions {nullptr}
{
}

Module::Module (const Module& module, Expressions& e) :
	source {module.source}, identifier {module.identifier}, definitions {module.definitions}, expressions {&e}, declarations {module.declarations}, body {module.body}
{
	Copy (identifier); Copy (definitions); Copy (expressions); Copy (declarations); Copy (body);
	if (expressions) for (auto& expression: *expressions) if (IsString (expression.value)) Create (expression.value.string, *expression.value.string);
		else if (IsType (expression)) assert (IsAlias (*expression.type)), Create (expression.type, IsGenericParameter (*expression.type->identifier->declaration) ? *expression.type->identifier->declaration->type : *expression.type), Copy (expression.type->identifier), expression.value.type = expression.type;
}

template <typename Structure>
void Module::Copy (Structure*& structure)
{
	if (structure) Create (structure, *structure), Copy (*structure);
}

template <typename Structure>
void Module::Copy (std::vector<Structure>& structures)
{
	for (auto& structure: structures) Copy (structure);
}

void Module::Copy (Body& body)
{
	Copy (body.statements);
}

void Module::Copy (QualifiedIdentifier& identifier)
{
	Copy (identifier.name); if (identifier.parent) Copy (identifier.parent);
}

void Module::Copy (Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		return Copy (declaration.import.expressions);

	case Declaration::Constant:
		return Copy (declaration.constant.expression);

	case Declaration::Type:
		return Copy (declaration.type);

	case Declaration::Variable:
		return Copy (declaration.variable.external);

	case Declaration::Procedure:
		return Copy (declaration.procedure.external), Copy (declaration.procedure.signature), Copy (declaration.procedure.declarations), Copy (declaration.procedure.body);

	case Declaration::Parameter:
		return;

	default:
		assert (Declaration::Unreachable);
	}
}

void Module::Copy (Declarations& declarations)
{
	Type *previous = nullptr, *current = nullptr;
	for (auto& declaration: declarations)
		if (Copy (declaration), !IsObject (declaration)) previous = nullptr;
		else if (declaration.object.type == previous) declaration.object.type = current;
		else previous = declaration.object.type, Copy (declaration.object.type), current = declaration.object.type;
}

void Module::Copy (Case& case_)
{
	Copy (case_.labels); Copy (case_.statements);
}

void Module::Copy (Elsif& elsif)
{
	Copy (elsif.condition); Copy (elsif.statements);
}

void Module::Copy (Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Set:
		return Copy (expression.set.identifier), Copy (expression.set.elements);

	case Expression::Call:
		return Copy (expression.call.designator), Copy (expression.call.arguments);

	case Expression::Index:
		return Copy (expression.index.designator), Copy (expression.index.expression);

	case Expression::Unary:
		return Copy (expression.unary.operand);

	case Expression::Binary:
		return Copy (expression.binary.left), Copy (expression.binary.right);

	case Expression::Literal:
		return;

	case Expression::Selector:
		return Copy (expression.selector.designator);

	case Expression::Promotion:
	case Expression::Dereference:
	case Expression::Parenthesized:
		return Copy (expression.promotion.expression);

	case Expression::Identifier:
		return Copy (expression.identifier);

	default:
		assert (Expression::Unreachable);
	}
}

void Module::Copy (Guard& guard)
{
	Copy (guard.expression); Copy (guard.type); Copy (guard.statements);
}

void Module::Copy (Signature& signature)
{
	Copy (signature.receiver); if (signature.receiver) Copy (signature.receiver->type); Copy (signature.parameters); Copy (signature.result);
}

void Module::Copy (Statement& statement)
{
	switch (statement.model)
	{
	case Statement::If:
		return Copy (statement.if_.condition), Copy (statement.if_.thenPart), Copy (statement.if_.elsifs), Copy (statement.if_.elsePart);

	case Statement::For:
		return Copy (statement.for_.variable), Copy (statement.for_.begin), Copy (statement.for_.end), Copy (statement.for_.step), Copy (statement.for_.statements);

	case Statement::Case:
		return Copy (statement.case_.expression), Copy (statement.case_.cases), Copy (statement.case_.elsePart);

	case Statement::Exit:
		return;

	case Statement::Loop:
		return Copy (statement.loop.statements);

	case Statement::With:
		return Copy (statement.with.guards), Copy (statement.with.elsePart);

	case Statement::While:
	case Statement::Repeat:
		return Copy (statement.while_.condition), Copy (statement.while_.statements);

	case Statement::Return:
		return Copy (statement.return_.expression);

	case Statement::Assignment:
		return Copy (statement.assignment.designator), Copy (statement.assignment.expression);

	case Statement::ProcedureCall:
		return Copy (statement.procedureCall.designator);

	default:
		assert (Statement::Unreachable);
	}
}

void Module::Copy (Type& type)
{
	switch (type.model)
	{
	case Type::Array:
		return Copy (type.array.length), Copy (type.array.elementType);

	case Type::Record:
		return Copy (type.record.baseType), Copy (type.record.declarations);

	case Type::Pointer:
		return Copy (type.pointer.baseType);

	case Type::Procedure:
		return Copy (type.procedure.signature);

	case Type::Identifier:
		return Copy (type.identifier);

	default:
		assert (Type::Unreachable);
	}
}

Size Module::GetIndex (const Type& type) const
{
	assert (IsAnonymous (type));
	return std::find (anonymousTypes.begin (), anonymousTypes.end (), &type) - anonymousTypes.begin ();
}

bool Module::Imports (const QualifiedIdentifier& identifier) const
{
	for (auto& declaration: declarations) if (!IsImport (declaration)) break; else if (declaration.import.identifier == identifier) return true;
	if (!IsGeneric (*this) || IsParameterized (*this)) for (auto& declaration: declarations) if (!IsImport (declaration)) break; else if (IsModule (*declaration.import.scope) && declaration.import.scope->module->Imports (identifier)) return true;
	return false;
}

Platform::Platform (Layout& l) :
	layout {l}, global {nullptr}, system {&systemIdentifier},
	#define DECLARATION(model, scope, declaration, name) scope##declaration {Declaration::model, name, scope},
	#include "oberon.def"
	#define TYPE(scope, type, name_, model, size) scope##type##Identifier {&scope##type.name, scope.identifier, &scope##type}, scope##type##Type {Type::model, size, scope##type##Identifier},
	#include "oberon.def"
	#define CONSTANT(scope, constant, name, type, value) scope##constant##Expression {global##type##Type, value},
	#include "oberon.def"
	systemName {"SYSTEM"}, systemIdentifier {&systemName}
{
	globalProcedureType.procedure.signature = {}; globalProcedureType.procedure.signature.parent = &globalProcedure;
	#define CONSTANT(scope, constant_, name, type, value) InitializeConstant (scope##constant_, scope##constant_##Expression);
	#define TYPE(scope, type_, name, model, size) InitializeType (scope##type_, scope##type_##Type);
	#define PROCEDURE(scope, procedure_, name) InitializeProcedure (scope##procedure_);
	#include "oberon.def"
}

void Platform::InitializeConstant (Declaration& declaration, Expression& expression)
{
	assert (IsConstant (declaration)); assert (IsConstant (expression));
	declaration.constant.expression = &expression;
}

void Platform::InitializeType (Declaration& declaration, Type& type)
{
	assert (IsType (declaration)); assert (IsAlias (type));
	declaration.type = &GetCanonical (type); type.identifier->declaration = &declaration;
}

void Platform::InitializeProcedure (Declaration& declaration)
{
	assert (IsProcedure (declaration));
	declaration.procedure.type = &globalProcedureType; declaration.procedure.external = nullptr; declaration.procedure.isForward = false;
}

Size Platform::GetSize (const Type& type) const
{
	switch (type.model)
	{
	case Type::Boolean:
	case Type::Character:
	case Type::Signed:
	case Type::Unsigned:
	case Type::Real:
	case Type::Set:
	case Type::Byte:
	case Type::Any:
		return type.basic.size;

	case Type::Complex:
		return type.complex.size * 2;

	case Type::Array:
		assert (type.array.length);
		return GetSize (*type.array.elementType) * type.array.length->value.signed_;

	case Type::Record:
		return std::max<Size> (type.record.scope->size, 1);

	case Type::Pointer:
	{
		if (!IsVariablePointer (type)) return layout.pointer.size;
		const auto alignment = GetAlignment (type); auto size = Align (GetSize (systemPointerType), alignment);
		for (auto baseType = type.pointer.baseType; IsOpenArray (*baseType); baseType = baseType->array.elementType) size = Align (size + GetSize (globalLengthType), alignment);
		if (NeedsTypeDescriptor (*type.pointer.baseType)) size = Align (size + GetSize (systemPointerType), alignment); return size;
	}

	case Type::Procedure:
		return layout.function.size;

	case Type::Generic:
		return 1;

	default:
		assert (Type::Unreachable);
	}
}

Alignment Platform::GetAlignment (const Type& type) const
{
	switch (type.model)
	{
	case Type::Boolean:
	case Type::Character:
	case Type::Unsigned:
	case Type::Signed:
	case Type::Set:
	case Type::Byte:
		return layout.integer.alignment (type.basic.size);

	case Type::Real:
	case Type::Complex:
		return layout.float_.alignment (type.basic.size);

	case Type::Any:
	case Type::Pointer:
		if (!IsVariablePointer (type) || !IsOpenArray (*type.pointer.baseType)) return layout.pointer.alignment (layout.pointer.size);
		return std::max (layout.pointer.alignment (layout.pointer.size), layout.integer.alignment (layout.pointer.size));

	case Type::Array:
		return GetAlignment (*type.array.elementType);

	case Type::Record:
		return type.record.scope->alignment;

	case Type::Procedure:
		return layout.function.alignment (layout.function.size);

	case Type::Generic:
		return 1;

	default:
		assert (Type::Unreachable);
	}
}

Alignment Platform::GetStackAlignment (const Type& type) const
{
	return layout.stack.alignment (GetSize (type));
}

Size Platform::GetSize (const Declaration& declaration) const
{
	assert (IsObject (declaration)); auto type = declaration.object.type; const auto alignment = GetAlignment (declaration);
	auto size = Align (GetSize (IsVariableParameter (declaration) || IsOpenArray (*type) || IsStructured (*type) && IsReadOnlyParameter (declaration) ? systemPointerType : *type), alignment);
	if (NeedsTypeDescriptor (declaration)) size = Align (size + GetSize (systemPointerType), alignment);
	while (IsOpenArray (*type)) type = type->array.elementType, size = Align (size + GetSize (globalLengthType), alignment);
	return size;
}

Alignment Platform::GetAlignment (const Declaration& declaration) const
{
	assert (IsObject (declaration));
	const auto& type = IsVariableParameter (declaration) || IsOpenArray (*declaration.object.type) ? systemPointerType : *declaration.object.type;
	auto alignment = GetAlignment (type); if (IsOpenArray (*declaration.object.type)) alignment = std::max (alignment, GetAlignment (globalLengthType));
	if (IsParameter (declaration)) alignment = std::max (alignment, GetStackAlignment (type)); return alignment;
}

Type& Platform::GetSigned (const Size size)
{
	if (size == 1) return globalSigned8Type;
	if (size == 2) return globalSigned16Type;
	if (size == 4) return globalSigned32Type;
	if (size == 8) return globalSigned64Type;
	assert (Type::Unreachable);
}

Type& Platform::GetUnsigned (const Size size)
{
	if (size == 1) return globalUnsigned8Type;
	if (size == 2) return globalUnsigned16Type;
	if (size == 4) return globalUnsigned32Type;
	if (size == 8) return globalUnsigned64Type;
	assert (Type::Unreachable);
}

Type& Platform::GetReal (const Size size)
{
	if (size == 4) return globalReal32Type;
	if (size == 8) return globalReal64Type;
	assert (Type::Unreachable);
}

Type& Platform::GetComplex (const Size size)
{
	if (size == 4) return globalComplex32Type;
	if (size == 8) return globalComplex64Type;
	assert (Type::Unreachable);
}

Type& Platform::GetSet (const Size size)
{
	if (size == 1) return globalSet8Type;
	if (size == 2) return globalSet16Type;
	if (size == 4) return globalSet32Type;
	if (size == 8) return globalSet64Type;
	assert (Type::Unreachable);
}

Type& Platform::GetCanonical (Type& type)
{
	if (IsSigned (type)) return GetSigned (type.signed_.size);
	if (IsUnsigned (type)) return GetUnsigned (type.unsigned_.size);
	if (IsReal (type)) return GetReal (type.real.size);
	if (IsComplex (type)) return GetComplex (type.complex.size);
	if (IsSet (type)) return GetSet (type.set.size);
	return type;
}

Type& Platform::GetComplex (const Type& type)
{
	assert (IsReal (type)); assert (IsAlias (type));
	return GetComplex (*type.identifier->declaration);
}

Type& Platform::GetComplex (const Declaration& declaration)
{
	assert (IsType (declaration));
	if (&declaration == &globalReal) return globalComplexType;
	if (&declaration == &globalShortReal) return globalShortComplexType;
	if (&declaration == &globalLongReal) return globalLongComplexType;
	if (&declaration == &globalReal32) return globalComplex32Type;
	if (&declaration == &globalReal64) return globalComplex64Type;
	return GetComplex (*declaration.type);
}

Type& Platform::GetReal (const Type& type)
{
	assert (IsComplex (type)); assert (IsAlias (type));
	return GetReal (*type.identifier->declaration);
}

Type& Platform::GetReal (const Declaration& declaration)
{
	assert (IsType (declaration));
	if (&declaration == &globalComplex) return globalRealType;
	if (&declaration == &globalShortComplex) return globalShortRealType;
	if (&declaration == &globalLongComplex) return globalLongRealType;
	if (&declaration == &globalComplex32) return globalReal32Type;
	if (&declaration == &globalComplex64) return globalReal64Type;
	return GetReal (*declaration.type);
}

Type& Platform::GetType (const Signed value)
{
	if (TruncatesPreserving (value, 8)) return globalSigned8Type;
	if (TruncatesPreserving (value, 16)) return globalSigned16Type;
	if (TruncatesPreserving (value, 32)) return globalSigned32Type;
	return globalSigned64Type;
}

Type& Platform::GetType (const Unsigned value)
{
	if (TruncatesPreserving (value, 8)) return globalUnsigned8Type;
	if (TruncatesPreserving (value, 16)) return globalUnsigned16Type;
	if (TruncatesPreserving (value, 32)) return globalUnsigned32Type;
	return globalUnsigned64Type;
}

Type& Platform::GetType (const Real value)
{
	if (TruncatesPreserving (value, 32)) return globalReal32Type;
	return globalReal64Type;
}

Type& Platform::GetType (const Complex value)
{
	if (TruncatesPreserving (value.real, 32) && TruncatesPreserving (value.imag, 32)) return globalComplex32Type;
	return globalComplex64Type;
}

Type& Platform::GetType (const Set value)
{
	if (TruncatesPreserving (value.mask, 8)) return globalSet8Type;
	if (TruncatesPreserving (value.mask, 16)) return globalSet16Type;
	if (TruncatesPreserving (value.mask, 32)) return globalSet32Type;
	return globalSet64Type;
}

Type& Platform::GetType (const Value& value)
{
	switch (value.model)
	{
	case Type::Signed: return GetType (value.signed_);
	case Type::Unsigned: return GetType (value.unsigned_);
	case Type::Real: return GetType (value.real);
	case Type::Complex: return GetType (value.complex);
	case Type::Set: return GetType (value.set);
	default: assert (Type::Unreachable);
	}
}

Scope* Platform::GetScope (const QualifiedIdentifier& identifier)
{
	if (identifier == systemIdentifier) return &system;
	return nullptr;
}

bool Oberon::IsQualified (const QualifiedIdentifier& identifier)
{
	return identifier.parent;
}

bool Oberon::IsCall (const Expression& expression)
{
	return expression.model == Expression::Call;
}

bool Oberon::IsLiteral (const Expression& expression)
{
	return expression.model == Expression::Literal;
}

bool Oberon::IsSelector (const Expression& expression)
{
	return expression.model == Expression::Selector;
}

bool Oberon::IsIndex (const Expression& expression)
{
	return expression.model == Expression::Index;
}

bool Oberon::IsSuper (const Expression& expression)
{
	return expression.model == Expression::Super;
}

bool Oberon::IsExplicitlyTyped (const Expression& expression)
{
	if (IsParenthesized (expression)) return IsExplicitlyTyped (*expression.parenthesized.expression);
	if (IsIdentifier (expression) && IsConstant (*expression.identifier.declaration)) return IsExplicitlyTyped (*expression.identifier.declaration->constant.expression);
	return expression.model == Expression::Set && expression.set.identifier || expression.model == Expression::Promotion || expression.model == Expression::Conversion;
}

bool Oberon::IsDereference (const Expression& expression)
{
	return expression.model == Expression::Dereference;
}

bool Oberon::IsConstant (const Expression& expression)
{
	return IsValid (expression.value) || IsRange (expression) && IsConstant (*expression.binary.left) && IsConstant (*expression.binary.right);
}

bool Oberon::IsVariable (const Expression& expression)
{
	return expression.isVariable;
}

bool Oberon::IsObject (const Expression& expression)
{
	return IsIdentifier (expression) && IsObject (*expression.identifier.declaration);
}

bool Oberon::IsRange (const Expression& expression)
{
	return expression.model == Expression::Binary && expression.binary.operator_ == Lexer::Range;
}

bool Oberon::IsFalse (const Expression& expression)
{
	return IsBoolean (expression.value) && !expression.value.boolean;
}

bool Oberon::IsTrue (const Expression& expression)
{
	return IsBoolean (expression.value) && expression.value.boolean;
}

bool Oberon::IsReceiver (const Expression& expression)
{
	return IsIdentifier (expression) && IsReceiver (*expression.identifier.declaration);
}

bool Oberon::IsConstant (const Expressions& expressions)
{
	for (auto& expression: expressions) if (!IsConstant (expression)) return false; return true;
}

bool Oberon::IsPromotion (const Expression& expression)
{
	return expression.model == Expression::Promotion;
}

bool Oberon::IsIdentifier (const Expression& expression)
{
	return expression.model == Expression::Identifier;
}

bool Oberon::IsQualified (const Expression& expression)
{
	return IsIdentifier (expression) || IsSelector (expression) && IsQualified (*expression.selector.designator);
}

bool Oberon::IsParenthesized (const Expression& expression)
{
	return expression.model == Expression::Parenthesized;
}

bool Oberon::IsReadOnly (const Expression& expression)
{
	return expression.isReadOnly;
}

bool Oberon::IsType (const Expression& expression)
{
	return IsType (expression.value);
}

bool Oberon::IsTypeGuardCall (const Expression& expression)
{
	return IsCall (expression) && expression.call.arguments && expression.call.arguments->size () == 1 && IsQualified (expression.call.arguments->front ());
}

bool Oberon::IsGeneric (const Expression& expression)
{
	return IsRange (expression) ? IsGeneric (*expression.binary.left) || IsGeneric (*expression.binary.right) : IsGeneric (*expression.type) || IsGeneric (expression.value);
}

bool Oberon::IsGeneric (const Expressions& expressions)
{
	for (auto& expression: expressions) if (IsGeneric (expression)) return true; return false;
}

bool Oberon::IsTerminating (const Expression& expression, const Body& body)
{
	return IsCall (expression) && (!IsConstant (*expression.call.designator) || expression.call.designator->value.procedure && IsTerminating (*expression.call.designator->value.procedure, body));
}

bool Oberon::HasDynamicType (const Expression& expression)
{
	return IsObject (expression) && HasDynamicType (*expression.identifier.declaration) || IsParenthesized (expression) && HasDynamicType (*expression.parenthesized.expression) ||
		IsDereference (expression) && HasDynamicType (*expression.type) || IsRecordPointer (*expression.type) && HasDynamicType (*expression.type->pointer.baseType) || IsAny (*expression.type);
}

bool Oberon::HasDynamicType (const Declaration& declaration)
{
	return IsVariableParameter (declaration) && HasDynamicType (*declaration.parameter.type);
}

bool Oberon::HasDynamicType (const Type& type)
{
	return IsRecord (type) && !IsFinal (type);
}

bool Oberon::NeedsTypeDescriptor (const Type& type)
{
	return HasDynamicType (type) || IsRecord (type) && type.record.baseType && NeedsTypeDescriptor (*type.record.baseType);
}

bool Oberon::NeedsTypeDescriptor (const Declaration& declaration)
{
	return HasDynamicType (declaration) || IsReceiver (declaration) && IsRecord (*declaration.parameter.type) && IsProcedure (*declaration.scope) && IsRedefined (*declaration.scope->procedure);
}

bool Oberon::IsRedefined (const Declaration& declaration)
{
	if (IsForward (declaration)) return !IsUndefined (declaration) && IsRedefined (*declaration.procedure.definition);
	return IsTypeBound (declaration) && declaration.procedure.definition;
}

bool Oberon::IsImport (const Declaration& declaration)
{
	return declaration.model == Declaration::Import;
}

bool Oberon::IsValid (const Value& value)
{
	return value.model != Type::Void;
}

bool Oberon::IsBoolean (const Value& value)
{
	return value.model == Type::Boolean;
}

bool Oberon::IsSigned (const Value& value)
{
	return value.model == Type::Signed;
}

bool Oberon::IsUnsigned (const Value& value)
{
	return value.model == Type::Unsigned;
}

bool Oberon::IsComplex (const Value& value)
{
	return value.model == Type::Complex;
}

bool Oberon::IsSet (const Value& value)
{
	return value.model == Type::Set;
}

bool Oberon::IsAny (const Value& value)
{
	return value.model == Type::Any;
}

bool Oberon::IsString (const Value& value)
{
	return value.model == Type::String;
}

bool Oberon::IsEmptyString (const Value& value)
{
	return IsString (value) && value.string->empty ();
}

bool Oberon::IsNil (const Value& value)
{
	return value.model == Type::Nil;
}

bool Oberon::IsRecord (const Value& value)
{
	return value.model == Type::Record;
}

bool Oberon::IsPointer (const Value& value)
{
	return value.model == Type::Pointer;
}

bool Oberon::IsProcedure (const Value& value)
{
	return value.model == Type::Procedure;
}

bool Oberon::IsModule (const Value& value)
{
	return value.model == Type::Module;
}

bool Oberon::IsType (const Value& value)
{
	return value.model == Type::Identifier;
}

bool Oberon::IsZero (const Value& value)
{
	switch (value.model)
	{
	case Type::Signed: return !value.signed_;
	case Type::Unsigned: return !value.unsigned_;
	case Type::Real: return !value.real;
	case Type::Complex: return !value.complex.real && !value.complex.imag;
	default: return false;
	}
}

bool Oberon::IsGeneric (const Value& value)
{
	return IsType (value) && IsGeneric (*value.type);
}

bool Oberon::IsGlobal (const Scope& scope)
{
	return scope.model == Scope::Global;
}

bool Oberon::IsModule (const Scope& scope)
{
	return scope.model == Scope::Module;
}

bool Oberon::IsSignature (const Scope& scope)
{
	return scope.model == Scope::Signature;
}

bool Oberon::IsProcedure (const Scope& scope)
{
	return scope.model == Scope::Procedure;
}

bool Oberon::IsRecord (const Scope& scope)
{
	return scope.model == Scope::Record;
}

bool Oberon::IsLocal (const Scope& scope)
{
	return IsProcedure (scope) || IsSignature (scope) || IsRecord (scope) && IsLocal (*scope.parent);
}

bool Oberon::IsReachable (const Scope& scope)
{
	return IsModule (scope) || IsRecord (scope) && IsReachable (*scope.record);
}

bool Oberon::IsExported (const Definition& definition)
{
	return definition.isExported;
}

bool Oberon::IsAssembly (const Declaration& declaration)
{
	return IsConstant (declaration) && IsBasic (*declaration.constant.expression->type) || IsObject (declaration);
}

bool Oberon::IsUsed (const Declaration& declaration)
{
	return declaration.uses;
}

bool Oberon::IsConstant (const Declaration& declaration)
{
	return declaration.model == Declaration::Constant;
}

bool Oberon::IsParameter (const Declaration& declaration)
{
	return declaration.model == Declaration::Parameter;
}

bool Oberon::IsVariableParameter (const Declaration& declaration)
{
	return IsParameter (declaration) && declaration.parameter.isVariable;
}

bool Oberon::IsVariableOpenByteArrayParameter (const Declaration& declaration)
{
	return IsVariableParameter (declaration) && IsOpenArray (*declaration.parameter.type) && IsByte (*declaration.parameter.type->array.elementType);
}

bool Oberon::IsReadOnlyParameter (const Declaration& declaration)
{
	return IsParameter (declaration) && declaration.parameter.isReadOnly;
}

bool Oberon::IsReceiver (const Declaration& declaration)
{
	return IsSignature (*declaration.scope) && declaration.scope->signature->receiver == &declaration || IsProcedure (*declaration.scope) && declaration.scope->procedure->procedure.signature.receiver == &declaration;
}

bool Oberon::IsVariable (const Declaration& declaration)
{
	return declaration.model == Declaration::Variable;
}

bool Oberon::IsVisible (const Declaration& declaration, const Module& module)
{
	return IsExported (declaration) || declaration.scope->BelongsTo (module);
}

bool Oberon::IsReadOnly (const Declaration& declaration, const Module& module)
{
	return IsVariable (declaration) && declaration.variable.isReadOnly && !declaration.scope->BelongsTo (module) || IsReadOnlyParameter (declaration);
}

bool Oberon::IsField (const Declaration& declaration)
{
	return IsVariable (declaration) && IsRecord (*declaration.scope);
}

bool Oberon::IsProcedure (const Declaration& declaration)
{
	return declaration.model == Declaration::Procedure;
}

bool Oberon::IsForward (const Declaration& declaration)
{
	return IsStorage (declaration) && declaration.storage.isForward;
}

bool Oberon::IsUndefined (const Declaration& declaration)
{
	return IsForward (declaration) && !declaration.storage.definition && !declaration.storage.external;
}

bool Oberon::IsAbstract (const Declaration& declaration)
{
	return IsProcedure (declaration) && declaration.procedure.isAbstract;
}

bool Oberon::IsFinal (const Declaration& declaration)
{
	return IsTypeBound (declaration) && (declaration.procedure.isFinal || IsFinal (*declaration.procedure.signature.receiver->parameter.type));
}

bool Oberon::IsTypeBound (const Declaration& declaration)
{
	return IsProcedure (declaration) && declaration.procedure.signature.receiver;
}

bool Oberon::IsTerminating (const Declaration& declaration, const Body& body)
{
	return !IsProcedure (declaration) || IsPredeclared (declaration) || IsAbstract (declaration) || IsForward (declaration) || !declaration.procedure.body || declaration.procedure.body == &body || IsTerminating (*declaration.procedure.body);
}

bool Oberon::IsType (const Declaration& declaration)
{
	return declaration.model == Declaration::Type;
}

bool Oberon::IsRecord (const Declaration& declaration)
{
	return IsType (declaration) && IsRecord (*declaration.type) && !IsAlias (*declaration.type);
}

bool Oberon::IsProcedureType (const Declaration& declaration)
{
	return IsType (declaration) && IsProcedure (*declaration.type) && !IsAlias (*declaration.type);
}

bool Oberon::IsPredeclared (const Declaration& declaration)
{
	return IsGlobal (*declaration.scope);
}

bool Oberon::IsStorage (const Declaration& declaration)
{
	return IsVariable (declaration) || IsProcedure (declaration);
}

bool Oberon::IsExternal (const Declaration& declaration)
{
	return IsStorage (declaration) && declaration.storage.external;
}

bool Oberon::IsObject (const Declaration& declaration)
{
	return IsVariable (declaration) || IsParameter (declaration);
}

bool Oberon::IsModule (const Declaration& declaration)
{
	return IsImport (declaration) || IsConstant (declaration) && IsModule (declaration.constant.expression->value);
}

bool Oberon::IsGenericParameter (const Declaration& declaration)
{
	return IsModule (*declaration.scope) && IsGeneric (*declaration.scope->module) && IsMember (declaration, declaration.scope->module->parameters);
}

bool Oberon::IsValid (const Type& type)
{
	return type.model != Type::Void;
}

bool Oberon::IsNil (const Type& type)
{
	return type.model == Type::Nil;
}

bool Oberon::IsBoolean (const Type& type)
{
	return type.model == Type::Boolean;
}

bool Oberon::IsCharacter (const Type& type)
{
	return type.model == Type::Character;
}

bool Oberon::IsSigned (const Type& type)
{
	return type.model == Type::Signed;
}

bool Oberon::IsUnsigned (const Type& type)
{
	return type.model == Type::Unsigned;
}

bool Oberon::IsByte (const Type& type)
{
	return type.model == Type::Byte;
}

bool Oberon::IsAny (const Type& type)
{
	return type.model == Type::Any;
}

bool Oberon::IsInteger (const Type& type)
{
	return type.model == Type::Signed || type.model == Type::Unsigned;
}

bool Oberon::IsReal (const Type& type)
{
	return type.model == Type::Real;
}

bool Oberon::IsSimple (const Type& type)
{
	return IsInteger (type) || IsReal (type);
}

bool Oberon::IsComplex (const Type& type)
{
	return type.model == Type::Complex;
}

bool Oberon::IsNumeric (const Type& type)
{
	return IsSimple (type) || IsComplex (type);
}

bool Oberon::IsSet (const Type& type)
{
	return type.model == Type::Set;
}

bool Oberon::IsArithmetic (const Type& type)
{
	return IsNumeric (type) || IsSet (type);
}

bool Oberon::IsString (const Type& type)
{
	return type.model == Type::String;
}

bool Oberon::IsBasic (const Type& type)
{
	return type.model >= Type::Boolean && type.model <= Type::Byte;
}

bool Oberon::IsArray (const Type& type)
{
	return type.model == Type::Array;
}

bool Oberon::IsCharacterArray (const Type& type)
{
	return IsArray (type) && IsCharacter (*type.array.elementType);
}

bool Oberon::IsStringable (const Type& type)
{
	return IsString (type) || IsCharacterArray (type);
}

bool Oberon::IsRecord (const Type& type)
{
	return type.model == Type::Record;
}

bool Oberon::IsAbstract (const Type& type)
{
	return IsRecord (type) && type.record.isAbstract;
}

bool Oberon::IsFinal (const Type& type)
{
	return IsRecord (type) && type.record.isFinal || IsAnonymous (type) || IsPointer (type) && IsFinal (*type.pointer.baseType);
}

bool Oberon::IsAnonymous (const Type& type)
{
	return IsRecord (type) && !type.record.declaration;
}

bool Oberon::IsStructured (const Type& type)
{
	return IsComplex (type) || IsArray (type) || IsRecord (type) || IsVariablePointer (type) && (IsOpenArray (*type.pointer.baseType) || HasDynamicType (*type.pointer.baseType));
}

bool Oberon::IsPointer (const Type& type)
{
	return type.model == Type::Pointer;
}

bool Oberon::IsRecordPointer (const Type& type)
{
	return IsPointer (type) && IsRecord (*type.pointer.baseType);
}

bool Oberon::IsVariablePointer (const Type& type)
{
	return IsPointer (type) && type.pointer.isVariable;
}

bool Oberon::IsProcedure (const Type& type)
{
	return type.model == Type::Procedure;
}

bool Oberon::IsTypeBound (const Type& type)
{
	return IsProcedure (type) && type.procedure.signature.receiver;
}

bool Oberon::IsOpenArray (const Type& type)
{
	return IsArray (type) && !type.array.length;
}

bool Oberon::IsDereferencable (const Type& type)
{
	return IsPointer (type);
}

bool Oberon::IsGeneric (const Type& type)
{
	return type.model == Type::Generic;
}

bool Oberon::IsIdentifier (const Type& type)
{
	return type.model == Type::Identifier;
}

bool Oberon::IsAlias (const Type& type)
{
	return type.identifier;
}

bool Oberon::IsScalar (const Type& type)
{
	return IsBasic (type) && !IsComplex (type) || IsAny (type) || IsNil (type) || IsPointer (type) && !IsStructured (type) || IsProcedure (type) && !IsTypeBound (type);
}

bool Oberon::IsAllocatable (const Type& type)
{
	return IsPointer (type) || IsAny (type);
}

bool Oberon::IsSelectable (const Type& type)
{
	return IsScalar (type) || IsString (type);
}

bool Oberon::IsTraceable (const Type& type)
{
	return IsBasic (type) || IsStringable (type) || IsAny (type) || IsNil (type) || IsPointer (type)|| IsProcedure (type);
}

bool Oberon::IsReachable (const Type& type)
{
	return IsRecord (type) && (type.record.isReachable || type.record.baseType && IsReachable (*type.record.baseType));
}

bool Oberon::IsEmptyLoop (const Statement& statement)
{
	return statement.model == Statement::Loop && statement.loop.statements->empty ();
}

bool Oberon::IsProcedureCall (const Statement& statement)
{
	return statement.model == Statement::ProcedureCall;
}

bool Oberon::IsReachable (const Statement& statement)
{
	return statement.isReachable;
}

bool Oberon::IsReachable (const Body& body)
{
	return body.isReachable;
}

bool Oberon::IsTerminating (const Body& body)
{
	return body.isReachable || body.hasReturn || body.hasCode;
}

bool Oberon::IsGeneric (const Module& module)
{
	return module.definitions;
}

bool Oberon::IsParameterized (const Module& module)
{
	return module.expressions;
}

bool Oberon::IsBoolean (const Operator operator_)
{
	return operator_ == Lexer::In || operator_ == Lexer::Is || operator_ == Lexer::Or || operator_ == Lexer::Not || operator_ == Lexer::And || operator_ == Lexer::Equal || operator_ == Lexer::Unequal || operator_ == Lexer::Less || operator_ == Lexer::Greater || operator_ == Lexer::LessEqual || operator_ == Lexer::GreaterEqual;
}

bool Oberon::NeedsInitialization (const Type& type)
{
	return IsAny (type) || IsArray (type) && NeedsInitialization (*type.array.elementType) || IsRecord (type) && NeedsInitialization (*type.record.scope) || IsDereferencable (type);
}

bool Oberon::NeedsInitialization (const Scope& scope)
{
	return scope.needsInitialization;
}

bool Oberon::OmitsResultValue (const Declaration& declaration)
{
	assert (IsProcedure (declaration));
	return declaration.procedure.signature.result && (!declaration.procedure.body || declaration.procedure.body->isReachable && !declaration.procedure.body->hasCode);
}

Source Oberon::GetFilename (const QualifiedIdentifier& identifier)
{
	assert (identifier.name); return identifier.parent ? GetFilename (*identifier.parent) + '.' + Lowercase (identifier.name->string) : Lowercase (identifier.name->string);
}

Module& Oberon::GetModule (const Scope& scope)
{
	assert (!IsGlobal (scope)); if (IsModule (scope)) return *scope.module;
	assert (scope.parent); return GetModule (*scope.parent);
}

Expression& Oberon::GetArgument (const Expression& expression, const Size index)
{
	assert (IsCall (expression)); assert (expression.call.arguments);
	auto& arguments = *expression.call.arguments; assert (index < arguments.size ());
	return arguments[index];
}

Expression* Oberon::GetOptionalArgument (const Expression& expression, const Size index)
{
	assert (IsCall (expression));
	return expression.call.arguments && index < expression.call.arguments->size () ? &GetArgument (expression, index) : nullptr;
}

Declaration& Oberon::GetParameter (const Expression& expression, const Expression& argument)
{
	assert (IsCall (expression)); assert (expression.call.arguments); const auto index = GetIndex (argument, *expression.call.arguments);
	assert (index < expression.call.arguments->size ()); return expression.call.designator->type->procedure.signature.parameters->operator [] (index);
}

Range<Value> Oberon::GetRange (const Expression& expression)
{
	assert (IsConstant (expression)); if (!IsRange (expression)) return expression.value;
	return {expression.binary.left->value, expression.binary.right->value};
}

Declaration* Oberon::GetVariable (const Expression& expression)
{
	if (IsParenthesized (expression)) return GetVariable (*expression.parenthesized.expression);
	return IsIdentifier (expression) && IsVariable (*expression.identifier.declaration) ? expression.identifier.declaration : nullptr;
}

const Type& Oberon::GetArray (const Type& type, Size dimension)
{
	auto array = &type; while (dimension && IsArray (*array)) --dimension, array = array->array.elementType; assert (!dimension); assert (IsArray (*array)); return *array;
}

Size Oberon::CountDimensions (const Type& type)
{
	Size count = 0; auto array = &type; while (IsArray (*array)) ++count, array = array->array.elementType; return count;
}

Size Oberon::CountOpenDimensions (const Type& type)
{
	Size count = 0; auto array = &type; while (IsOpenArray (*array)) ++count, array = array->array.elementType; return count;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Type& type)
{
	if (IsAlias (type)) return stream << *type.identifier;

	switch (type.model)
	{
	case Type::Array:
		stream << Lexer::Array << ' ';
		if (type.array.length) stream << *type.array.length << ' ';
		return stream << Lexer::Of << ' ' << *type.array.elementType;

	case Type::Record:
		stream << Lexer::Record;
		if (type.record.isAbstract) stream << Lexer::Asterisk; else if (type.record.isFinal) stream << Lexer::Minus;
		if (type.record.baseType) stream << ' ' << Lexer::LeftParen << *type.record.baseType << Lexer::RightParen;
		return stream;

	case Type::Pointer:
		assert (type.pointer.baseType);
		stream << Lexer::Pointer << ' ' << Lexer::To << ' ';
		if (type.pointer.isVariable) stream << Lexer::Var << ' ';
		if (type.pointer.isReadOnly) stream << Lexer::Minus << ' ';
		return stream << *type.pointer.baseType;

	case Type::Procedure:
		return stream << Lexer::Procedure << type.procedure.signature;

	default:
		assert (Type::Unreachable);
	}
}

std::ostream& Oberon::operator << (std::ostream& stream, const Type::Model model)
{
	switch (model)
	{
	case Type::Void: return stream << "void";
	case Type::Boolean: return stream << "boolean";
	case Type::Character: return stream << "character";
	case Type::Signed: return stream << "signed integer";
	case Type::Unsigned: return stream << "unsigned integer";
	case Type::Real: return stream << "real";
	case Type::Complex: return stream << "complex";
	case Type::Set: return stream << "set";
	case Type::Byte: return stream << "byte";
	case Type::Any: return stream << "any pointer";
	case Type::String: return stream << "string";
	case Type::Nil: return stream << "nil";
	case Type::Array: return stream << "array";
	case Type::Record: return stream << "record";
	case Type::Pointer: return stream << "pointer";
	case Type::Procedure: return stream << "procedure";
	case Type::Module: return stream << "module";
	case Type::Generic: return stream << "generic";
	case Type::Identifier: return stream << "identifier";
	default: assert (Type::Unreachable);
	}
}

std::ostream& Oberon::WriteFormatted (std::ostream& stream, const Type& type)
{
	if (IsString (type) || IsNil (type)) return stream << type.model << " type";
	if (IsProcedure (type) && type.procedure.signature.parent && IsPredeclared (*type.procedure.signature.parent)) return stream << "predeclared procedure type";
	if (IsAlias (type)) return stream << type.model << " type '" << *type.identifier << '\'';

	switch (type.model)
	{
	case Type::Array:
		assert (type.array.elementType);
		if (!type.array.length) stream << "open "; stream << "array type";
		if (type.array.length) if (IsGeneric (*type.array.length)) stream << " of generic length"; else stream << " of length " << type.array.length->value.signed_;
		return WriteFormatted (stream << " with elements of ", *type.array.elementType);

	case Type::Record:
		return stream << "anonymous record type";

	case Type::Pointer:
		assert (type.pointer.baseType);
		stream << "pointer to ";
		if (type.pointer.isReadOnly) stream << "read-only ";
		if (type.pointer.isVariable) stream << "variable of ";
		return WriteFormatted (stream, *type.pointer.baseType);

	case Type::Procedure:
		if (type.procedure.signature.receiver) stream << "type-bound ";
		if (type.procedure.signature.parent) stream << "nested ";
		return stream << "procedure type";

	default:
		assert (Type::Unreachable);
	}
}

std::ostream& Oberon::WriteSerialized (std::ostream& stream, const Type& type)
{
	return IsAlias (type) ? WriteQualified (stream, *type.identifier->declaration) : stream << type;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		stream << Lexer::Import << ' ' << declaration.name;
		if (declaration.import.alias) stream << ' ' << Lexer::Assign << ' ' << *declaration.import.alias;
		if (declaration.import.expressions) stream << ' ' << Lexer::LeftParen << *declaration.import.expressions << Lexer::RightParen;
		if (declaration.import.identifier.parent) stream << ' ' << Lexer::In << ' ' << *declaration.import.identifier.parent;
		return stream << Lexer::Semicolon;

	case Declaration::Constant:
		stream << Lexer::Const << ' ' << declaration.name;
		if (declaration.isExported) stream << Lexer::Asterisk;
		return stream << ' ' << Lexer::Equal << ' ' << *declaration.constant.expression << Lexer::Semicolon;

	case Declaration::Type:
		stream << Lexer::Type << ' ' << declaration.name;
		if (declaration.isExported) stream << Lexer::Asterisk;
		return stream << ' ' << Lexer::Equal << ' ' << *declaration.type << Lexer::Semicolon;

	case Declaration::Variable:
		stream << Lexer::Var << ' ' << declaration.name;
		if (declaration.variable.isReadOnly) stream << Lexer::Minus; else if (declaration.isExported) stream << Lexer::Asterisk;
		if (declaration.variable.external) stream << ' ' << Lexer::LeftBracket << *declaration.variable.external << Lexer::RightBracket;
		return stream << Lexer::Colon << ' ' << *declaration.variable.type << Lexer::Semicolon;

	case Declaration::Procedure:
		stream << Lexer::Procedure;
		if (declaration.procedure.isAbstract) stream << Lexer::Asterisk; else if (declaration.procedure.isFinal) stream << Lexer::Minus;
		if (declaration.procedure.isForward) stream << ' ' << Lexer::Arrow;
		if (declaration.procedure.signature.receiver) stream << ' ' << Lexer::LeftParen << *declaration.procedure.signature.receiver << Lexer::RightParen;
		stream << ' ' << declaration.name; if (declaration.isExported) stream << Lexer::Asterisk;
		if (declaration.procedure.external) stream << ' ' << Lexer::LeftBracket << *declaration.procedure.external << Lexer::RightBracket;
		return stream << declaration.procedure.signature << Lexer::Semicolon;

	case Declaration::Parameter:
		if (declaration.parameter.isVariable) stream << Lexer::Var << ' ';
		stream << declaration.name;
		if (declaration.parameter.isReadOnly) stream << Lexer::Minus;
		return stream << Lexer::Colon << ' ' << *declaration.parameter.type;

	default:
		assert (Declaration::Unreachable);
	}
}

std::ostream& Oberon::operator << (std::ostream& stream, const Declaration::Model model)
{
	switch (model)
	{
	case Declaration::Import: return stream << "import";
	case Declaration::Constant: return stream << "constant";
	case Declaration::Type: return stream << "type";
	case Declaration::Variable: return stream << "variable";
	case Declaration::Procedure: return stream << "procedure";
	case Declaration::Parameter: return stream << "parameter";
	default: assert (Declaration::Unreachable);
	}
}

std::ostream& Oberon::WriteFormatted (std::ostream& stream, const Declaration& declaration)
{
	if (IsVariableParameter (declaration)) stream << "variable ";
	else if (IsParameter (declaration)) stream << "value ";
	if (IsReceiver (declaration)) stream << "receiver";
	else if (IsGenericParameter (declaration)) stream << "generic parameter";
	else if (IsTypeBound (declaration)) stream << "type-bound procedure";
	else if (IsField (declaration)) stream << "field";
	else stream << declaration.model;
	return stream << " '" << declaration.name << '\'';
}

std::ostream& Oberon::WriteQualified (std::ostream& stream, const Declaration& declaration)
{
	if (IsType (declaration) && IsAlias (*declaration.type) && !IsPredeclared (declaration) && !IsGenericParameter (declaration)) return WriteQualified (stream, *declaration.type->identifier->declaration);
	if (!IsGlobal (*declaration.scope) || declaration.scope->identifier) WriteQualified (stream, *declaration.scope) << Lexer::Dot; return stream << declaration.name;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Declarations& declarations)
{
	for (auto& declaration: declarations) (IsFirst (declaration, declarations) ? stream : stream << Lexer::Semicolon << ' ') << declaration; return stream;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Signature& signature)
{
	if (signature.parameters) stream << ' ' << Lexer::LeftParen << *signature.parameters << Lexer::RightParen;
	if (signature.result) stream << Lexer::Colon << ' ' << *signature.result;
	return stream;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Value& value)
{
	switch (value.model)
	{
	case Type::Boolean:
		return stream << (value.boolean ? "TRUE" : "FALSE");

	case Type::Character:
	{
		if (std::isprint (value.character)) return value.character == '\'' ? stream << "\"'\"" : stream << '\'' << value.character << '\'';
		const auto flags = stream.setf (stream.hex | stream.uppercase, stream.basefield | stream.uppercase);
		stream << unsigned (value.character) << 'X'; stream.flags (flags); return stream;
	}

	case Type::Signed:
		return stream << value.signed_;

	case Type::Unsigned:
		return stream << value.unsigned_;

	case Type::Real:
	{
		if (std::signbit (value.real)) stream << '-';
		if (std::isinf (value.real)) return stream << "INF";
		if (std::isnan (value.real)) return stream << "NAN";
		const auto flags = stream.setf (stream.floatfield | stream.uppercase, stream.uppercase);
		stream << std::abs (value.real); stream.flags (flags); return stream;
	}

	case Type::Complex:
		if (value.complex.real) stream << Value {value.complex.real};
		if (value.complex.real && value.complex.imag) stream << ' ' << (value.complex.imag < 0 ? Lexer::Minus : Lexer::Plus) << ' ';
		if (value.complex.imag && value.complex.imag != 1) stream << Value {value.complex.real ? std::abs (value.complex.imag) : value.complex.imag} << ' ' << Lexer::Asterisk << ' ';
		if (value.complex.imag) stream << 'I';
		return stream;

	case Type::Set:
		stream << Lexer::LeftBrace;
		for (Set::Element element = 0, comma = 0; element != sizeof (Set::Element) * 8; ++element)
			if (value.set[element]) (comma ? stream << Lexer::Comma << ' ' : stream) << element, comma = true;
		return stream << Lexer::RightBrace;

	case Type::Byte:
		return stream << value.byte;

	case Type::Any:
	case Type::Pointer:
	{
		if (!value.pointer) return stream << Lexer::Nil;
		const auto flags = stream.setf (stream.hex | stream.uppercase | stream.right, stream.basefield | stream.uppercase | stream.adjustfield);
		stream.width (std::numeric_limits<std::uintptr_t>::digits / 4);
		stream.fill ('0'); stream << reinterpret_cast<uintptr_t> (value.pointer); stream.flags (flags); return stream;
	}

	case Type::String:
		return stream << std::quoted (*value.string, value.string->find ('"') == value.string->npos ? '"' : '\'');

	case Type::Nil:
		return stream << Lexer::Nil;

	case Type::Procedure:
		if (!value.procedure) return stream << Lexer::Nil;
		return WriteQualified (stream, *value.procedure);

	case Type::Module:
		assert (value.module); assert (value.module->import.scope);
		return WriteQualified (stream, *value.module->import.scope);

	case Type::Identifier:
		assert (value.type); assert (IsAlias (*value.type));
		return WriteQualified (stream, *value.type->identifier->declaration);

	default:
		assert (Type::Unreachable);
	}
}

std::ostream& Oberon::operator << (std::ostream& stream, const Scope& scope)
{
	if (IsGlobal (scope)) return stream << *scope.identifier;
	assert (IsModule (scope)); return stream << scope.module->identifier;
}

std::ostream& Oberon::WriteQualified (std::ostream& stream, const Scope& scope)
{
	switch (scope.model)
	{
	case Scope::Global:
		assert (scope.identifier);
		return WriteQualified (stream, *scope.identifier);

	case Scope::Module:
		assert (scope.module);
		WriteQualified (stream, scope.module->identifier); if (!IsParameterized (*scope.module)) return stream; stream << Lexer::LeftParen;
		for (auto& expression: *scope.module->expressions) (IsFirst (expression, *scope.module->expressions) ? stream : stream << Lexer::Comma) << expression.value;
		return stream << Lexer::RightParen;

	case Scope::Procedure:
		assert (scope.procedure);
		return WriteQualified (stream, *scope.procedure);

	case Scope::Record:
		assert (scope.record); assert (scope.record->record.declaration);
		return WriteQualified (stream, *scope.record->record.declaration);

	default:
		assert (Scope::Unreachable);
	}
}

std::ostream& Oberon::operator << (std::ostream& stream, const Definition& definition)
{
	stream << definition.name; if (definition.isExported) stream << Lexer::Asterisk; return stream;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Definitions& definitions)
{
	for (auto& definition: definitions) (IsFirst (definition, definitions) ? stream : stream << Lexer::Comma << ' ') << definition; return stream;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Elsif& elsif)
{
	return stream << Lexer::Elsif << ' ' << elsif.condition << ' ' << Lexer::Then;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Identifier& identifier)
{
	return stream << identifier.string;
}

std::ostream& Oberon::WriteQualified (std::ostream& stream, const QualifiedIdentifier& identifier)
{
	assert (identifier.name); if (identifier.parent) stream << *identifier.parent << Lexer::Colon; return stream << *identifier.name;
}

std::ostream& Oberon::operator << (std::ostream& stream, const QualifiedIdentifier& identifier)
{
	if (identifier.parent) stream << *identifier.parent << Lexer::Dot; return stream << *identifier.name;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Guard& guard)
{
	return stream << guard.expression << ' ' << Lexer::Colon << ' ' << guard.type << ' ' << Lexer::Do;
}

std::ostream& Oberon::operator << (std::ostream& stream, const Statement& statement)
{
	switch (statement.model)
	{
	case Statement::If:
		assert (statement.if_.condition);
		return stream << Lexer::If << ' ' << *statement.if_.condition << ' ' << Lexer::Then;

	case Statement::For:
		assert (statement.for_.variable); assert (statement.for_.begin); assert (statement.for_.end);
		stream << Lexer::For << ' ' << *statement.for_.variable << ' ' << Lexer::Assign << ' ' << *statement.for_.begin << ' ' << Lexer::To << ' ' << *statement.for_.end;
		if (statement.for_.step) stream << ' ' << Lexer::By << ' ' << *statement.for_.step;
		return stream << ' ' << Lexer::Do;

	case Statement::Case:
		assert (statement.case_.expression);
		return stream << Lexer::Case << ' ' << *statement.case_.expression << ' ' << Lexer::Of;

	case Statement::Exit:
		return stream << Lexer::Exit;

	case Statement::Loop:
		return stream << Lexer::Loop;

	case Statement::With:
		assert (statement.with.guards); assert (!statement.with.guards->empty ());
		return stream << Lexer::With << ' ' << statement.with.guards->front ();

	case Statement::While:
		assert (statement.while_.condition);
		return stream << Lexer::While << ' ' << *statement.while_.condition << ' ' << Lexer::Do;

	case Statement::Repeat:
		assert (statement.repeat.condition);
		return stream << Lexer::Repeat;

	case Statement::Return:
		stream << Lexer::Return;
		if (statement.return_.expression) stream << ' ' << *statement.return_.expression;
		return stream;

	case Statement::Assignment:
		assert (statement.assignment.designator); assert (statement.assignment.expression);
		return stream << *statement.assignment.designator << ' ' << Lexer::Assign << ' ' << *statement.assignment.expression;

	case Statement::ProcedureCall:
		assert (statement.procedureCall.designator);
		return stream << (IsCall (*statement.procedureCall.designator) && !statement.procedureCall.designator->call.arguments ? *statement.procedureCall.designator->call.designator : *statement.procedureCall.designator);

	default:
		assert (Statement::Unreachable);
	}
}

std::ostream& Oberon::operator << (std::ostream& stream, const Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Set:
		if (expression.set.identifier) stream << *expression.set.identifier << ' ';
		stream << Lexer::LeftBrace;
		if (expression.set.elements) stream << *expression.set.elements;
		return stream << Lexer::RightBrace;

	case Expression::Call:
		assert (expression.call.designator);
		stream << *expression.call.designator << ' ' << Lexer::LeftParen;
		if (expression.call.arguments) stream << *expression.call.arguments;
		return stream << Lexer::RightParen;

	case Expression::Index:
		assert (expression.index.designator); assert (expression.index.expression);
		return stream << *expression.index.designator << Lexer::LeftBracket << *expression.index.expression << Lexer::RightBracket;

	case Expression::Super:
		assert (expression.super.designator);
		return stream << *expression.super.designator << Lexer::Arrow;

	case Expression::Unary:
		assert (expression.unary.operand);
		return stream << expression.unary.operator_ << *expression.unary.operand;

	case Expression::Binary:
		assert (expression.binary.left); assert (expression.binary.right);
		return stream << *expression.binary.left << ' ' << expression.binary.operator_ << ' ' << *expression.binary.right;

	case Expression::Literal:
		assert (expression.literal);
		return stream << *expression.literal;

	case Expression::Selector:
		assert (expression.selector.designator); assert (expression.selector.identifier);
		return stream << *expression.selector.designator << Lexer::Dot << *expression.selector.identifier;

	case Expression::Promotion:
		assert (expression.promotion.expression);
		return stream << *expression.promotion.expression;

	case Expression::TypeGuard:
		assert (expression.typeGuard.designator); assert (expression.typeGuard.identifier);
		return stream << *expression.typeGuard.designator << Lexer::LeftParen << *expression.typeGuard.identifier << Lexer::RightParen;

	case Expression::Conversion:
		assert (expression.conversion.identifier); assert (expression.conversion.expression);
		return stream << *expression.conversion.identifier << ' ' << Lexer::LeftParen << *expression.conversion.expression << Lexer::RightParen;

	case Expression::Identifier:
		return stream << expression.identifier;

	case Expression::Dereference:
		assert (expression.dereference.expression);
		return stream << *expression.dereference.expression << Lexer::Arrow;

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return stream << Lexer::LeftParen << *expression.parenthesized.expression << Lexer::RightParen;

	default:
		assert (Expression::Unreachable);
	}
}

std::ostream& Oberon::operator << (std::ostream& stream, const Expressions& expressions)
{
	for (auto& expression: expressions) (IsFirst (expression, expressions) ? stream : stream << Lexer::Comma << ' ') << expression; return stream;
}

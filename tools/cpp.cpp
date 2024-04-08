// C++ representation
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

#include "cpp.hpp"
#include "layout.hpp"
#include "utilities.hpp"

#include <cassert>
#include <chrono>
#include <cstddef>
#include <random>
#include <sstream>

using namespace ECS;
using namespace CPP;

static const char*const languageLinkages[] {"C++", "C", "Oberon"};

Platform::Platform (Layout& l) :
	layout {l}, sizes {
		#define TYPEMODEL(model, type, size) size,
		#include "cpp.def"
	}, alignments {
		#define TYPEMODEL(model, type, size) layout.type.alignment (size),
		#include "cpp.def"
	}
{
	assert (sizes[Short] <= sizes[Integer]); assert (sizes[Integer] <= sizes[Long]);
	assert (sizes[Float] <= sizes[Double]); assert (sizes[Double] <= sizes[LongDouble]);
}

Bits Platform::GetBits (const Type& type) const
{
	return Bits (sizes[GetModel (type)]) * 8;
}

Size Platform::GetSize (const Type& type) const
{
	assert (IsComplete (type));
	if (IsReference (type)) return sizes[Pointer];

	switch (type.model)
	{
	case Type::Class:
		return type.class_->bytes;

	case Type::Array:
		assert (type.array.bound);
		return Align (std::max (GetSize (*type.array.elementType), Size (1)), GetAlignment (*type.array.elementType)) * type.array.bound;

	default:
		return sizes[GetModel (type)];
	}
}

Alignment Platform::GetAlignment (const Type& type) const
{
	assert (IsComplete (type) || IsArray (type));
	if (IsReference (type)) return alignments[Pointer];

	switch (type.model)
	{
	case Type::Class:
		return type.class_->alignment.value;

	case Type::Enumeration:
		return type.enumeration->alignment.value;

	case Type::Array:
		return GetAlignment (*type.array.elementType);

	case Type::Function:
		return alignments[FunctionPointer];

	default:
		return alignments[GetModel (type)];
	}
}

Alignment Platform::GetStackAlignment (const Type& type) const
{
	return std::max (GetAlignment (type), layout.stack.alignment (GetSize (type)));
}

Type Platform::GetSigned (const Type& type) const
{
	assert (CPP::IsFundamental (type));
	static const Type::Model models[] {Type::Boolean, Type::SignedCharacter, Type::ShortInteger, Type::Integer, Type::LongInteger, Type::LongLongInteger};
	return models[GetIntegerModel (sizes[GetModel (type)])];
}

Type Platform::GetUnsigned (const Type& type) const
{
	assert (CPP::IsFundamental (type));
	static const Type::Model models[] {Type::Boolean, Type::UnsignedCharacter, Type::UnsignedShortInteger, Type::UnsignedInteger, Type::UnsignedLongInteger, Type::UnsignedLongLongInteger};
	return models[GetIntegerModel (sizes[GetModel (type)])];
}

IntegerConversionRank Platform::GetRank (const Type& type) const
{
	assert (IsIntegral (type)); return GetModel (type);
}

bool Platform::IsFundamental (const Alignment alignment) const
{
	return alignment <= layout.integer.alignment.maximum || alignment <= layout.float_.alignment.maximum || alignment <= layout.pointer.alignment.maximum || alignment <= layout.function.alignment.maximum;
}

Platform::Model Platform::GetIntegerModel (const Size size) const
{
	if (size == sizes[Character]) return Character;
	if (size == sizes[Short]) return Short;
	if (size == sizes[Long]) return Long;
	if (size == sizes[LongLong]) return LongLong;
	assert (size == sizes[Integer]); return Integer;
}

Platform::Model Platform::GetModel (const Type& type) const
{
	assert (!IsReference (type));

	switch (type.model)
	{
	case Type::Character:
	case Type::SignedCharacter:
	case Type::UnsignedCharacter:
		return Character;

	case Type::Character16:
		return Short;

	case Type::Character32:
	case Type::WideCharacter:
		return Long;

	case Type::ShortInteger:
	case Type::UnsignedShortInteger:
		return Short;

	case Type::Integer:
	case Type::UnsignedInteger:
		return Integer;

	case Type::LongInteger:
	case Type::UnsignedLongInteger:
		return Long;

	case Type::LongLongInteger:
	case Type::UnsignedLongLongInteger:
		return LongLong;

	case Type::Boolean:
		return Boolean;

	case Type::Float:
		return Float;

	case Type::Double:
		return Double;

	case Type::LongDouble:
		return LongDouble;

	case Type::NullPointer:
	case Type::MemberPointer:
		return Pointer;

	case Type::Enumeration:
		return GetModel (type.enumeration->underlyingType);

	case Type::Pointer:
		return IsFunction (*type.pointer.baseType) ? FunctionPointer : Pointer;

	default:
		assert (Type::Unreachable);
	}
}

Name::Name (const String*const i) :
	model {Identifier}, identifier {i}
{
	assert (identifier);
}

Name::Name (const struct Identifier& identifier)
{
	switch (identifier.model)
	{
	case Identifier::Name:
		model = Identifier; this->identifier = identifier.name.identifier;
		break;

	case Identifier::Template:
		new (this) Name {*identifier.template_.identifier};
		templateArguments = identifier.template_.arguments;
		break;

	case Identifier::Destructor:
		model = Destructor; destructor = identifier.destructor.type;
		break;

	case Identifier::LiteralOperator:
		model = Literal; suffixIdentifier = identifier.literalOperator.suffixIdentifier;
		break;

	case Identifier::OperatorFunction:
		model = Operator; operator_ = identifier.operatorFunction.operator_;
		if (IsAlternative (operator_.symbol)) operator_.symbol = GetPrimary (operator_.symbol);
		break;

	case Identifier::ConversionFunction:
		assert (identifier.conversionFunction.typeIdentifier);
		model = Conversion; conversion = &identifier.conversionFunction.typeIdentifier->type;
		break;

	default:
		assert (Identifier::Unreachable);
	}
}

bool Name::operator < (const Name& other) const
{
	if (model != other.model) return model < other.model;
	if (!templateArguments != !other.templateArguments) return other.templateArguments;
	if (templateArguments && *templateArguments != *other.templateArguments) return *templateArguments < *other.templateArguments;

	switch (model)
	{
	case Literal:
		return CompareOrdered (suffixIdentifier, other.suffixIdentifier);

	case Operator:
		return operator_ < other.operator_;

	case Conversion:
		assert (conversion); assert (other.conversion);
		return *conversion < *other.conversion;

	case Destructor:
		return CompareOrdered (destructor, other.destructor);

	case Identifier:
		return CompareOrdered (identifier, other.identifier);

	default:
		assert (Name::Unreachable);
	}
}

bool Name::operator == (const Name& other) const
{
	if (model != other.model) return false;

	switch (model)
	{
	case Literal:
		return suffixIdentifier == other.suffixIdentifier;

	case Operator:
		return operator_ == other.operator_;

	case Conversion:
		assert (conversion); assert (other.conversion);
		return *conversion == *other.conversion;

	case Destructor:
		return destructor == other.destructor;

	case Identifier:
		return identifier == other.identifier;

	default:
		assert (Name::Unreachable);
	}
}

bool Name::operator == (const String*const string) const
{
	assert (string);
	return model == Identifier && identifier == string;
}

Type::Type (const Model m) :
	model {m}
{
}

Type::Type (const Type*const baseType) :
	model {Pointer}, pointer {baseType}
{
	assert (baseType);
}

Type::Type (const Type*const baseType, const struct Class*const class_) :
	model {MemberPointer}, memberPointer {baseType, class_}
{
	assert (baseType); assert (class_);
}

Type::Type (struct Array& a) :
	Type {a.elementType, a.values.size ()}
{
}

Type::Type (const Type& type, const CPP::Unsigned bound) :
	model {Array}, array {&type, bound}
{
}

Type::Type (struct Class& c) :
	model {Class}, class_ {&c}
{
}

Type::Type (struct Class& c, const ConstVolatileQualifiers& q) :
	model {Class}, qualifiers {q}, class_ {&c}
{
}

Type::Type (struct Enumeration& e) :
	model {Enumeration}, enumeration {&e}
{
}

Type::Type (Type& returnType, Types& parameterTypes, const LanguageLinkage linkage) :
	model {Function}, function {&returnType, &parameterTypes, linkage, {false, false}, {Lexer::Eof}, false, false}
{
}

bool Type::operator < (const Type& other) const
{
	if (model != other.model) return model < other.model;
	if (reference != other.reference) return reference < other.reference;
	if (qualifiers != other.qualifiers) return qualifiers < other.qualifiers;

	switch (model)
	{
	case Class:
		return CompareOrdered (class_, other.class_);

	case Enumeration:
		return CompareOrdered (enumeration, other.enumeration);

	case Array:
		if (array.bound != other.array.bound) return array.bound < other.array.bound;
		return *array.elementType < *other.array.elementType;

	case Function:
		if (function.variadic != other.function.variadic) return other.function.variadic;
		if (function.noexcept_ != other.function.noexcept_) return other.function.noexcept_;
		if (function.linkage != other.function.linkage) return function.linkage < other.function.linkage;
		if (*function.returnType != *other.function.returnType) return *function.returnType < *other.function.returnType;
		if (function.constVolatileQualifiers != other.function.constVolatileQualifiers) return function.constVolatileQualifiers < other.function.constVolatileQualifiers;
		if (function.referenceQualifier != other.function.referenceQualifier) return function.referenceQualifier < other.function.referenceQualifier;
		return *function.parameterTypes < *other.function.parameterTypes;

	case Pointer:
		return *pointer.baseType < *other.pointer.baseType;

	case MemberPointer:
		if (memberPointer.class_ != other.memberPointer.class_) return CompareOrdered (memberPointer.class_, other.memberPointer.class_);
		return *memberPointer.baseType < *other.memberPointer.baseType;

	default:
		return false;
	}
}

bool Type::operator == (const Type& other) const
{
	if (model != other.model || reference != other.reference || qualifiers != other.qualifiers) return false;

	switch (model)
	{
	case Class:
		return class_ == other.class_;

	case Enumeration:
		return enumeration == other.enumeration;

	case Array:
		return array.bound == other.array.bound && *array.elementType == *other.array.elementType;

	case Function:
		return function.linkage == other.function.linkage && *function.returnType == *other.function.returnType && *function.parameterTypes == *other.function.parameterTypes &&
			function.constVolatileQualifiers == other.function.constVolatileQualifiers && function.referenceQualifier == other.function.referenceQualifier &&
			function.variadic == other.function.variadic && function.noexcept_ == other.function.noexcept_;

	case Pointer:
		return *pointer.baseType == *other.pointer.baseType;

	case MemberPointer:
		return *memberPointer.baseType == *other.memberPointer.baseType && memberPointer.class_ == other.memberPointer.class_;

	default:
		return true;
	}
}

bool Type::IsReferenceRelatedTo (const Type& type) const
{
	return RemoveQualifiers (*this) == RemoveQualifiers (type);
}

bool Type::IsReferenceCompatibleWith (const Type& type) const
{
	return IsReferenceRelatedTo (type) && !type.qualifiers.AreMoreQualifiedThan (qualifiers);
}

AlignmentSpecification& AlignmentSpecification::operator &= (const Alignment alignment)
{
	if (alignment > value) value = alignment;
	return *this;
}

Class::Class (Scope& es, const ClassKey& k, Entity*const e, const Size i, Platform& platform) :
	scope {Scope::Class, &es}, key {k}, entity {e}, index {i}, alignment {platform.GetAlignment (Type::Character)}
{
	assert (!entity != !index); scope.class_ = this;
	if (entity) scope.symbolTable.emplace (entity->name, entity);
}

Label::Label (const Size i) :
	index {i}
{
}

Scope::Scope (const Model m, Scope*const es) :
	model {m}, enclosingScope {es}
{
}

void Scope::Use (struct Namespace& namespace_)
{
	assert (!IsGlobal (namespace_));
	InsertUnique (&namespace_.scope, usingNamespaces);
}

void Scope::AddInline (struct Namespace& namespace_)
{
	assert (IsInline (namespace_));
	InsertUnique (&namespace_.scope, inlineNamespaces);
}

bool Scope::Contains (const Scope& scope) const
{
	for (auto enclosingScope = scope.enclosingScope; enclosingScope; enclosingScope = enclosingScope->enclosingScope)
		if (enclosingScope == this) return true;
	return false;
}

void Scope::Lookup (const Name& name, Entities& entities) const
{
	const auto range = symbolTable.equal_range (name);
	for (auto entity = range.first; entity != range.second; ++entity) InsertUnique (entity->second, entities);
}

bool Scope::LookupQualified (const Name& name, Entities& entities) const
{
	Scopes searchedScopes;
	return LookupQualified (name, entities, searchedScopes);
}

bool Scope::LookupQualified (const Name& name, Entities& entities, Scopes& searchedScopes) const
{
	if (!InsertUnique (this, searchedScopes)) return false;
	const auto previousSize = entities.size (); Lookup (name, entities);
	for (auto namespace_: inlineNamespaces) namespace_->LookupQualified (name, entities, searchedScopes);
	if (entities.size () != previousSize) return true;
	for (auto namespace_: usingNamespaces) namespace_->LookupQualified (name, entities, searchedScopes);
	return entities.size () != previousSize;
}

bool Scope::LookupUnqualified (const Name& name, Entities& entities) const
{
	Scopes searchedScopes;
	return LookupUnqualified (name, *this, entities, searchedScopes);
}

bool Scope::LookupUnqualified (const Name& name, const Scope& nearestScope, Entities& entities, Scopes& searchedScopes) const
{
	if (!InsertUnique (this, searchedScopes)) return false;
	const auto previousSize = entities.size (); Lookup (name, entities);
	for (auto namespace_: inlineNamespaces) namespace_->LookupUnqualified (name, nearestScope, entities, searchedScopes);
	for (auto namespace_: usingNamespaces) if (nearestScope.Contains (*namespace_)) namespace_->LookupUnqualified (name, nearestScope, entities, searchedScopes);
	for (auto enclosingScope = this->enclosingScope; entities.size () == previousSize && enclosingScope; enclosingScope = enclosingScope->enclosingScope)
	{
		enclosingScope->LookupUnqualified (name, *enclosingScope, entities, searchedScopes);
		for (auto namespace_: usingNamespaces) if (enclosingScope->Contains (*namespace_)) namespace_->LookupUnqualified (name, *enclosingScope, entities, searchedScopes);
	}
	return entities.size () != previousSize;
}

Array::Array (const Type& et) :
	elementType {et}
{
}

Array::Array (std::initializer_list<Value> v) :
	values {v}
{
}

Value::Value (const CPP::Float f) :
	model {Float}, float_ {f}
{
}

Value::Value (const CPP::Signed s) :
	model {Signed}, signed_ {s}
{
}

Value::Value (const CPP::Boolean b) :
	model {Boolean}, boolean {b}
{
}

Value::Value (const CPP::Unsigned u) :
	model {Unsigned}, unsigned_ {u}
{
}

Value::Value (const Entity& entity) :
	model {Reference}, reference {&entity, nullptr, nullptr, 0}
{
}

Value::Value (Array& array) :
	model {Reference}, reference {nullptr, nullptr, &array, 0}
{
}

Value::Value (const std::nullptr_t, const CPP::Signed offset) :
	model {Pointer}, pointer {nullptr, nullptr, nullptr, offset}
{
}

Value::Value (const struct Reference& p, const CPP::Signed offset) :
	model {Pointer}, pointer {p}
{
	pointer.offset = offset;
}

Value::Value (const Storage*const mp) :
	model {MemberPointer}, memberPointer {mp}
{
	assert (memberPointer); assert (IsMember (*memberPointer->entity));
}

bool Value::operator < (const Value& other) const
{
	switch (model)
	{
	case Value::Float:
		return float_ < other.float_;

	case Value::Signed:
		return signed_ < other.signed_;

	case Value::Boolean:
		return boolean < other.boolean;

	case Value::Unsigned:
		return unsigned_ < other.unsigned_;

	default:
		assert (Value::Unreachable);
	}
}

bool Value::operator == (const Value& other) const
{
	switch (model)
	{
	case Value::Float:
		return float_ == other.float_;

	case Value::Signed:
		return signed_ == other.signed_;

	case Value::Boolean:
		return boolean == other.boolean;

	case Value::Pointer:
		return pointer == other.pointer;

	case Value::Unsigned:
		return unsigned_ == other.unsigned_;

	default:
		assert (Value::Unreachable);
	}
}

bool Value::Represents (const Value& value) const
{
	using CPP::Float, CPP::Signed, CPP::Unsigned;

	switch (model)
	{
	case Value::Float:
		switch (value.model) {
		case Value::Float: return float_ == Float (value.float_);
		case Value::Signed: return float_ == Float (value.signed_);
		case Value::Boolean: return float_ == Float (value.boolean);
		case Value::Unsigned: return float_ == Float (value.unsigned_);
		default: assert (Value::Unreachable);
		}

	case Value::Signed:
		switch (value.model) {
		case Value::Float: return signed_ == Signed (value.float_);
		case Value::Signed: return signed_ == Signed (value.signed_);
		case Value::Boolean: return signed_ == Signed (value.boolean);
		case Value::Unsigned: return signed_ == Signed (value.unsigned_);
		default: assert (Value::Unreachable);
		}

	case Value::Unsigned:
		switch (value.model) {
		case Value::Float: return unsigned_ == Unsigned (value.float_);
		case Value::Signed: return unsigned_ == Unsigned (value.signed_);
		case Value::Boolean: return unsigned_ == Unsigned (value.boolean);
		case Value::Unsigned: return unsigned_ == Unsigned (value.unsigned_);
		default: assert (Value::Unreachable);
		}

	default:
		assert (Value::Unreachable);
	}
}

Reference::operator bool () const
{
	return entity || value || array || offset;
}

bool Reference::operator == (const Reference& other) const
{
	return entity == other.entity && value == other.value && array == other.array && offset == other.offset;
}

Entity::Entity (const Model m, const Name& n, const Location& l, Scope& es) :
	model {m}, name {n}, location {l}, enclosingScope {&es}, alias {nullptr}
{
}

bool Entity::Hides (const Entity& entity) const
{
	return Hides (entity.model, IsAlias (entity) ? *entity.alias : IsFunction (entity) ? entity.function->type : Type {});
}

bool Entity::Hides (const Model model, const Type& type) const
{
	switch (this->model)
	{
	case Alias:
	case Label:
	case Namespace:
	case NamespaceAlias:
		return false;

	case Class:
		assert (class_);
		return model == Alias && type == *class_ || model == Function || model == Variable || model == Parameter || model == Enumerator;

	case Function:
		assert (function);
		return model == Class || model == Function && type != function->type || model == Enumeration;

	case Variable:
	case Parameter:
	case Enumerator:
		return model == Class || model == Enumeration;

	case Enumeration:
		assert (enumeration);
		return model == Alias && type == *enumeration || model == Function || model == Variable || model == Parameter || model == Enumerator;

	default:
		assert (Entity::Unreachable);
	}
}

Storage::Storage (const Type& t, Entity& e, const LanguageLinkage l, Platform& platform) :
	type {t}, entity {&e}, linkage {l}, alignment {platform.GetAlignment (type)}
{
}

Storage::Storage (const Type& t, Entity& e, const LanguageLinkage l, const DeclarationSpecifiers& specifiers, Platform& platform) :
	type {t}, entity {&e}, linkage {l}, alignment {platform.GetAlignment (IsDependent (type) || IsPlaceholder (type) || IsIncomplete (type) && !IsArray (type) ? Type::Character : type)},
	isConstexpr {IsConstexpr (specifiers)}, isStatic {IsStatic (specifiers)}, isInline {IsInline (specifiers)}
{
}

bool ClassKey::operator == (const ClassKey& other) const
{
	return symbol == other.symbol;
}

Function::Function (const Type& t, Entity& e, Platform& platform) :
	Storage {t, e, t.function.linkage, platform}
{
	assert (IsFunction (type));
}

Function::Function (const Type& t, Entity& e, const LanguageLinkage l, const DeclarationSpecifiers& specifiers, const bool im, Platform& platform) :
	Storage {t, e, l, specifiers, platform}, isMain {im}
{
	assert (IsFunction (type));
}

bool Operator::operator < (const Operator& other) const
{
	if (symbol != other.symbol) return symbol < other.symbol;
	return !bracketed && other.bracketed;
}

bool Operator::operator == (const Operator& other) const
{
	return symbol == other.symbol && bracketed == other.bracketed;
}

Variable::Variable (const Type& t, Entity& e, const LanguageLinkage l, Platform& platform) :
	Storage {t, e, l, platform}
{
}

Variable::Variable (const Type& t, Entity& e, const LanguageLinkage l, const DeclarationSpecifiers& specifiers, Platform& platform) :
	Storage {t, e, l, specifiers, platform}, isThreadLocal {IsThreadLocal (specifiers)}
{
}

Namespace::Namespace (Scope*const es, const bool ii, Entity*const e, const Size i) :
	scope {Scope::Namespace, es}, isInline {ii}, entity {e}, index {i}
{
	assert (!entity || !index);
	scope.namespace_ = this;
}

Statement::Statement (StatementBlock& eb) :
	enclosingBlock {&eb}
{
}

Enumerator::Enumerator (Entity& e) :
	entity {&e}
{
}

Expression::Expression (struct Identifier& i) :
	model {Identifier}, location {i.location}
{
	identifier.identifier = &i;
}

Identifier::Identifier (const Location& l, const String*const identifier) :
	model {Name}, location {l}, nestedNameSpecifier {nullptr}
{
	assert (identifier); name.identifier = identifier;
}

Enumeration::Enumeration (Scope& es, const EnumKey& k, Entity*const e, const Size i, const Type& type, Platform& platform) :
	scope {Scope::Enumeration, &es}, key {k}, entity {e}, index {i}, alignment {platform.GetAlignment (IsUndefined (type) ? Type::Character : type)}, underlyingType {type}
{
	assert (!entity != !index); scope.enumeration = this;
}

StringLiteral::StringLiteral (const Location& l, const Lexer::Symbol s, const WString*const literal) :
	location {l}, symbol {s}, tokens {{{symbol, literal}, l}}
{
	assert (IsString (symbol));
}

bool StringLiteral::operator < (const StringLiteral& other) const
{
	if (symbol != other.symbol) return symbol < other.symbol;
	if (tokens.size () != other.tokens.size ()) return tokens.size () < other.tokens.size ();
	auto otherToken = other.tokens.begin (); for (auto& token: tokens) if (token.literal != otherToken->literal) return CompareOrdered (token.literal, otherToken->literal); else ++otherToken;
	return CompareOrdered (suffix, other.suffix);
}

TranslationUnit::TranslationUnit (const Source& s) :
	source {s}, global {nullptr, false, nullptr, std::mt19937 (std::chrono::high_resolution_clock::now ().time_since_epoch ().count ()) ()}
{
}

ReferenceQualifier::operator bool () const
{
	return symbol;
}

bool ReferenceQualifier::operator < (const ReferenceQualifier& other) const
{
	return symbol < other.symbol;
}

bool ReferenceQualifier::operator == (const ReferenceQualifier& other) const
{
	return symbol == other.symbol;
}

bool ConstVolatileQualifiers::AreMoreQualifiedThan (const ConstVolatileQualifiers& other) const
{
	return isConst + isVolatile > other.isConst + other.isVolatile;
}

ConstVolatileQualifiers::operator bool () const
{
	return isConst || isVolatile;
}

bool ConstVolatileQualifiers::operator < (const ConstVolatileQualifiers& other) const
{
	if (isConst != other.isConst) return other.isConst;
	if (isVolatile != other.isVolatile) return other.isVolatile;
	return false;
}

bool ConstVolatileQualifiers::operator == (const ConstVolatileQualifiers& other) const
{
	return isConst == other.isConst && isVolatile == other.isVolatile;
}

ConstVolatileQualifiers& ConstVolatileQualifiers::operator |= (const ConstVolatileQualifiers& other)
{
	isConst |= other.isConst; isVolatile |= other.isVolatile; return *this;
}

bool TemplateArgument::operator == (const TemplateArgument& other) const
{
	if (model != other.model) return false;

	switch (model)
	{
	case Expression:
		return expression->value == other.expression->value;

	case TypeIdentifier:
		return typeIdentifier->type == other.typeIdentifier->type;

	default:
		assert (TemplateArgument::Unreachable);
	}
}

bool TemplateArgument::operator < (const TemplateArgument& other) const
{
	if (model != other.model) return model < other.model;

	switch (model)
	{
	case Expression:
		return expression->value < other.expression->value;

	case TypeIdentifier:
		return typeIdentifier->type < other.typeIdentifier->type;

	default:
		assert (TemplateArgument::Unreachable);
	}
}

bool CPP::IsAuto (const Type& type)
{
	return type.model == Type::Auto;
}

bool CPP::IsVoid (const Type& type)
{
	return type.model == Type::Void;
}

bool CPP::IsArray (const Type& type)
{
	return type.model == Type::Array;
}

bool CPP::IsClass (const Type& type)
{
	return type.model == Type::Class;
}

bool CPP::IsConst (const Type& type)
{
	return type.qualifiers.isConst || IsArray (type) && IsConst (*type.array.elementType);
}

bool CPP::IsScope (const Type& type)
{
	return type.model == Type::Class || type.model == Type::Enumeration;
}

bool CPP::IsZero (const Value& value)
{
	return IsSigned (value) && value.signed_ == 0 || IsUnsigned (value) && value.unsigned_ == 0;
}

bool CPP::IsBlock (const Scope& scope)
{
	return scope.model == Scope::Block;
}

bool CPP::IsClass (const Scope& scope)
{
	return scope.model == Scope::Class;
}

bool CPP::IsLocal (const Entity& entity)
{
	return IsParameter (entity) || IsVariable (entity) && !HasStaticStorageDuration (*entity.variable);
}

bool CPP::IsLocal (const Scope& scope)
{
	return scope.model == Scope::Block || scope.model == Scope::Function || scope.model == Scope::FunctionPrototype;
}

bool CPP::IsLocal (const Class& class_)
{
	return IsLocal (*class_.scope.enclosingScope) || IsClass (*class_.scope.enclosingScope) && IsLocal (*class_.scope.enclosingScope->class_);
}

bool CPP::IsLocalReference (const Value& value, const Function& function)
{
	return (IsPointer (value) || IsReference (value)) && value.reference.entity && IsLocal (*value.reference.entity) && function.scope->Contains (*value.reference.entity->enclosingScope);
}

bool CPP::IsObject (const Type& type)
{
	return !IsFunction (type) && !IsReference (type) && !IsVoid (type);
}

bool CPP::IsType (const Entity& entity)
{
	return entity.model == Entity::Alias || entity.model == Entity::Class || entity.model == Entity::Enumeration;
}

bool CPP::IsUnion (const Class& class_)
{
	return IsUnion (class_.key);
}

bool CPP::IsUnion (const ClassKey& key)
{
	return key.symbol == Lexer::Union;
}

bool CPP::IsUnion (const Type& type)
{
	return IsClass (type) && IsUnion (*type.class_);
}

bool CPP::IsUsed (const Entity& entity)
{
	return entity.uses;
}

bool CPP::IsValid (const Value& value)
{
	return value.model != Value::Invalid;
}

bool CPP::IsFloat (const Value& value)
{
	return value.model == Value::Float;
}

bool CPP::IsSigned (const Value& value)
{
	return value.model == Value::Signed;
}

bool CPP::IsBoolean (const Value& value)
{
	return value.model == Value::Boolean;
}

bool CPP::IsPointer (const Value& value)
{
	return value.model == Value::Pointer;
}

bool CPP::IsUnsigned (const Value& value)
{
	return value.model == Value::Unsigned;
}

bool CPP::IsReference (const Value& value)
{
	return value.model == Value::Reference;
}

bool CPP::HasType (const Entity& entity)
{
	return IsStorage (entity) || IsParameter (entity) || IsEnumerator (entity);
}

bool CPP::IsAlias (const Entity& entity)
{
	return entity.model == Entity::Alias;
}

bool CPP::IsAliased (const Type& type)
{
	return type.alias;
}

bool CPP::IsBoolean (const Type& type)
{
	return type.model == Type::Boolean;
}

bool CPP::IsClass (const Entity& entity)
{
	return entity.model == Entity::Class;
}

bool CPP::IsDefined (const Entity& entity)
{
	return entity.isDefined;
}

bool CPP::IsGlobal (const Scope& scope)
{
	return IsNamespace (scope) && IsGlobal (*scope.namespace_);
}

bool CPP::IsGlobal (const Namespace& namespace_)
{
	return !namespace_.scope.enclosingScope;
}

bool CPP::IsIf (const Statement& statement)
{
	return statement.model == Statement::If;
}

bool CPP::IsLabel (const Entity& entity)
{
	return entity.model == Entity::Label;
}

bool CPP::IsPointer (const Type& type)
{
	return type.model == Type::Pointer;
}

bool CPP::IsScope (const Entity& entity)
{
	return IsAlias (entity) && IsScope (*entity.alias) || IsClass (entity) || IsNamespace (entity) || IsEnumeration (entity);
}

bool CPP::IsComplete (const Type& type)
{
	if (IsReference (type)) return true;

	switch (type.model)
	{
	case Type::Void: return false;
	case Type::Class: return type.class_->isComplete;
	case Type::Enumeration: return !IsUndefined (type.enumeration->underlyingType);
	case Type::Array: return type.array.bound && IsComplete (*type.array.elementType);
	default: return true;
	}
}

bool CPP::IsFunction (const Type& type)
{
	return type.model == Type::Function;
}

bool CPP::IsIntegral (const Type& type)
{
	return type.model == Type::Boolean || type.model == Type::Character || type.model == Type::Character16 ||
		type.model == Type::Character32 || type.model == Type::WideCharacter || IsSignedInteger (type) || IsUnsignedInteger (type);
}

bool CPP::IsLValue (const Entity& entity)
{
	return IsFunction (entity) || IsVariable (entity) || IsParameter (entity);
}

bool CPP::IsMain (const Function& function)
{
	return function.isMain;
}

bool CPP::IsMember (const Entity& entity)
{
	return IsClass (*entity.enclosingScope);
}

bool CPP::IsRegister (const Type& type)
{
	return (IsFundamental (type) || IsPointer (type)) && !IsVolatile (type) && !IsReference (type);
}

bool CPP::IsUnnamed (const Class& class_)
{
	return !class_.entity || IsAlias (*class_.entity);
}

bool CPP::IsUnnamed (const Namespace& namespace_)
{
	return !namespace_.entity;
}

bool CPP::IsVolatile (const Type& type)
{
	return type.qualifiers.isVolatile || IsArray (type) && IsVolatile (*type.array.elementType);
}

bool CPP::IsCharacter (const Type& type)
{
	return type.model >= Type::FirstCharacter && type.model <= Type::LastCharacter;
}

bool CPP::IsDecltyped (const Type& type)
{
	return type.specifier;
}

bool CPP::IsDependent (const Type& type)
{
	return type.model == Type::Dependent;
}

bool CPP::IsFunction (const Scope& scope)
{
	return scope.model == Scope::Function;
}

bool CPP::IsReference (const Type& type)
{
	return type.reference != Type::None;
}

bool CPP::IsScoped (const EnumKey& key)
{
	return key.symbol != Lexer::Enum;
}

bool CPP::IsStatic (const Storage& storage)
{
	return storage.isStatic;
}

bool CPP::IsStorage (const Entity& entity)
{
	return entity.model == Entity::Function || entity.model == Entity::Variable;
}

bool CPP::IsUndefined (const Type& type)
{
	return type.model == Type::Undefined;
}

bool CPP::IsArithmetic (const Type& type)
{
	return IsIntegral (type) || IsFloatingPoint (type);
}

bool CPP::IsAsm (const Declaration& declaration)
{
	return declaration.model == Declaration::Asm;
}

bool CPP::IsBitField (const Entity& entity)
{
	return IsVariable (entity) && IsBitField (*entity.variable);
}

bool CPP::IsDependent (const Value& value)
{
	return value.model == Value::Dependent;
}

bool CPP::IsFunction (const Entity& entity)
{
	return entity.model == Entity::Function;
}

bool CPP::IsName (const Declarator& declarator)
{
	return declarator.model == Declarator::Name;
}

bool CPP::IsIdentifier (const Name& name)
{
	return name.model == Name::Identifier;
}

bool CPP::IsName (const Identifier& identifier)
{
	return identifier.model == Identifier::Name;
}

bool CPP::IsNamespace (const Scope& scope)
{
	return scope.model == Scope::Namespace;
}

bool CPP::IsTemplate (const Entity& entity)
{
	return entity.templateParameters;
}

bool CPP::IsTemplate (const Function& function)
{
	return IsTemplate (*function.entity);
}

bool CPP::IsTemplate (const Declaration& declaration)
{
	return declaration.model == Declaration::Template;
}

bool CPP::IsExplicitInstantiation (const Declaration& declaration)
{
	return declaration.model == Declaration::ExplicitInstantiation;
}

bool CPP::IsTrue (const Expression& expression)
{
	return IsBoolean (expression.value) && expression.value.boolean;
}

bool CPP::IsVariable (const Entity& entity)
{
	return entity.model == Entity::Variable;
}

bool CPP::HasScope (const Statement& statement)
{
	return statement.model == Statement::If || statement.model == Statement::For || statement.model == Statement::While || statement.model == Statement::Switch;
}

bool CPP::IsEnumeration (const Type& type)
{
	return type.model == Type::Enumeration;
}

bool CPP::IsDeleted (const Function& function)
{
	return function.isDeleted;
}

bool CPP::IsDefaulted (const Function& function)
{
	return function.isDefaulted;
}

bool CPP::IsFalse (const Expression& expression)
{
	return IsBoolean (expression.value) && !expression.value.boolean;
}

bool CPP::IsFundamental (const Type& type)
{
	return type.model >= Type::FirstFundamental && type.model <= Type::LastFundamental;
}

bool CPP::IsInline (const Namespace& namespace_)
{
	return namespace_.isInline;
}

bool CPP::IsNamespace (const Entity& entity)
{
	return entity.model == Entity::Namespace || entity.model == Entity::NamespaceAlias;
}

bool CPP::IsNullPointer (const Type& type)
{
	return type.model == Type::NullPointer;
}

bool CPP::IsParameter (const Entity& entity)
{
	return entity.model == Entity::Parameter;
}

bool CPP::IsPlaceholder (const Type& type)
{
	switch (type.model)
	{
	case Type::Auto:
		return true;

	case Type::Array:
		return IsPlaceholder (*type.array.elementType);

	case Type::Pointer:
		return IsPlaceholder (*type.pointer.baseType);

	case Type::Function:
		return IsPlaceholder (*type.function.returnType);

	default:
		return false;
	}
}

bool CPP::IsSwitch (const Statement& statement)
{
	return statement.model == Statement::Switch;
}

bool CPP::IsUnqualified (const Type& type)
{
	return !type.qualifiers;
}

bool CPP::IsUnscoped (const EnumKey& key)
{
	return key.symbol == Lexer::Enum;
}

bool CPP::IsSimple (const Declaration& declaration)
{
	return declaration.model == Declaration::Simple;
}

bool CPP::IsBasic (const Declaration& declaration)
{
	return declaration.model == Declaration::Member || declaration.model == Declaration::Simple || declaration.model == Declaration::FunctionDefinition;
}

bool CPP::IsBinary (const Expression& expression)
{
	return expression.model == Expression::Binary;
}

bool CPP::IsBitField (const Variable& variable)
{
	return variable.length;
}

bool CPP::IsConstant (const Variable& variable)
{
	return IsConstexpr (variable) || IsConst (variable.type) && !IsVolatile (variable.type) && IsValid (variable.value);
}

bool CPP::IsEnumeration (const Scope& scope)
{
	return scope.model == Scope::Enumeration;
}

bool CPP::IsEnumerator (const Entity& entity)
{
	return entity.model == Entity::Enumerator;
}

bool CPP::IsLabeled (const Statement& statement)
{
	return statement.model == Statement::Case || statement.model == Statement::Label || statement.model == Statement::Default;
}

bool CPP::IsSwitchLabel (const Statement& statement)
{
	return statement.model == Statement::Case || statement.model == Statement::Default;
}

bool CPP::IsLValue (const Expression& expression)
{
	return expression.category == ValueCategory::LValue;
}

bool CPP::IsNodiscard (const Attribute& attribute)
{
	return attribute.model == Attribute::Nodiscard;
}

bool CPP::IsNodiscard (const Type& type)
{
	return (IsClass (type) && type.class_->isNodisard || IsEnumeration (type) && type.enumeration->isNodisard) && !IsReference (type);
}

bool CPP::IsNodiscard (const Function& function)
{
	return function.isNodisard || IsNodiscard (*function.type.function.returnType);
}

bool CPP::IsNodiscardCall (const Expression& expression)
{
	if (IsNodiscard (expression.type)) return true;
	if (IsVoid (expression.type) || !HasSideEffects (expression)) return false;

	switch (expression.model)
	{
	case Expression::Comma:
		return IsNodiscardCall (*expression.comma.left) || IsNodiscardCall (*expression.comma.right);

	case Expression::Prefix:
	case Expression::Postfix:
	case Expression::Assignment:
		return false;

	case Expression::Conditional:
		return IsNodiscardCall (*expression.conditional.left) || IsNodiscardCall (*expression.conditional.right);

	case Expression::FunctionCall:
		return expression.functionCall.function && IsNodiscard (*expression.functionCall.function);

	case Expression::Parenthesized:
		return IsNodiscardCall (*expression.parenthesized.expression);

	case Expression::InlinedFunctionCall:
		return IsNodiscardCall (*expression.inlinedFunctionCall.expression);

	default:
		assert (Expression::Unreachable);
	}
}

bool CPP::IsNoreturn (const Attribute& attribute)
{
	return attribute.model == Attribute::Noreturn;
}

bool CPP::IsNoreturn (const Declaration& declaration)
{
	return IsAsm (declaration) && declaration.asm_.noreturn_;
}

bool CPP::IsNoreturn (const Function& function)
{
	return function.isNoreturn;
}

bool CPP::IsRegister (const Variable& variable)
{
	return variable.isRegister;
}

bool CPP::IsRegister (const Parameter& parameter)
{
	return parameter.isRegister;
}

bool CPP::IsRegister (const Entity& entity)
{
	return IsVariable (entity) && IsRegister (*entity.variable) || IsParameter (entity) && IsRegister (*entity.parameter->parameter);
}

bool CPP::IsUnboundArray (const Type& type)
{
	return IsArray (type) && !type.array.bound;
}

bool CPP::IsUnnamedClass (const Type& type)
{
	return type.model == Type::Class && IsUnnamed (*type.class_);
}

bool CPP::IsAbstractClass (const Type& type)
{
	return IsClass (type) && type.class_->isAbstract;
}

bool CPP::IsAccess (const Declaration& declaration)
{
	return declaration.model == Declaration::Access;
}

bool CPP::IsExtern (const Declaration& declaration)
{
	return IsBasic (declaration) && IsExtern (*declaration.basic.specifiers);
}

bool CPP::IsEnumeration (const Entity& entity)
{
	return entity.model == Entity::Enumeration;
}

bool CPP::IsFloatingPoint (const Type& type)
{
	return type.model == Type::Float || type.model == Type::Double || type.model == Type::LongDouble;
}

bool CPP::IsGLValue (const Expression& expression)
{
	return expression.category != ValueCategory::PRValue;
}

bool CPP::IsMember (const Declaration& declaration)
{
	return declaration.model == Declaration::Member;
}

bool CPP::IsMemberPointer (const Type& type)
{
	return type.model == Type::MemberPointer;
}

bool CPP::IsPredefined (const Entity& entity)
{
	return entity.isPredefined;
}

bool CPP::IsPRValue (const Expression& expression)
{
	return expression.category == ValueCategory::PRValue;
}

bool CPP::IsReplaceable (const Entity& entity)
{
	return IsStorage (entity) && entity.storage->replaceable;
}

bool CPP::IsReturning (const Function& function)
{
	return function.isReturning;
}

bool CPP::IsScoped (const Enumeration& enumeration)
{
	return IsScoped (enumeration.key);
}

bool CPP::IsSignedInteger (const Type& type)
{
	return type.model == Type::SignedCharacter || type.model == Type::ShortInteger || type.model == Type::Integer ||
		type.model == Type::LongInteger || type.model == Type::LongLongInteger;
}

bool CPP::IsBitField (const Expression& expression)
{
	return expression.isBitField;
}

bool CPP::IsCharacterArray (const Type& type)
{
	return IsArray (type) && IsCharacter (*type.array.elementType);
}

bool CPP::IsClass (const TypeSpecifier& specifier)
{
	return specifier.model == TypeSpecifier::Class;
}

bool CPP::IsConstant (const Expression& expression)
{
	return IsValid (expression.value);
}

bool CPP::IsEmpty (const StringLiteral& literal)
{
	assert (!literal.tokens.empty ()); for (auto& token: literal.tokens) if (!token.literal->empty ()) return false; return true;
}

bool CPP::IsFunction (const Declarator& declarator)
{
	return declarator.model == Declarator::Function;
}

bool CPP::IsIteration (const Statement& statement)
{
	return statement.model == Statement::Do || statement.model == Statement::For || statement.model == Statement::While;
}

bool CPP::IsMainFunction (const Entity& entity)
{
	return IsFunction (entity) && IsMain (*entity.function);
}

bool CPP::IsReachable (const Statement& statement)
{
	return statement.isReachable;
}

bool CPP::IsNull (const Statement& statement)
{
	return statement.model == Statement::Null;
}

bool CPP::IsFallthrough (const Statement& statement)
{
	return IsNull (statement) && statement.null.fallthrough;
}

bool CPP::IsFallthrough (const Attribute& attribute)
{
	return attribute.model == Attribute::Fallthrough;
}

bool CPP::HasLikelihood (const Statement& statement)
{
	return statement.likelihood;
}

bool CPP::IsLikelihood (const Attribute& attribute)
{
	return attribute.model == Attribute::Likely || attribute.model == Attribute::Unlikely;
}

bool CPP::IsMaybeUnused (const Attribute& attribute)
{
	return attribute.model == Attribute::MaybeUnused;
}

bool CPP::IsMaybeUnused (const Entity& entity)
{
	return entity.maybeUnused;
}

bool CPP::IsStaticMember (const Entity& entity)
{
	return IsMember (entity) && IsStorage (entity) && IsStatic (*entity.storage);
}

bool CPP::IsUnnamed (const Enumeration& enumeration)
{
	return !enumeration.entity || IsAlias (*enumeration.entity);
}

bool CPP::HasRationale (const Attribute& attribute)
{
	assert (IsDeprecated (attribute));
	return attribute.deprecated.stringLiteral && !IsEmpty (*attribute.deprecated.stringLiteral);
}

bool CPP::HasReturnType (const Function& function)
{
	assert (IsFunction (function.type));
	return !IsVoid (*function.type.function.returnType);
}

bool CPP::IsConstructor (const Function& function)
{
	const auto& enclosingScope = *function.entity->enclosingScope;
	return IsClass (enclosingScope) && enclosingScope.class_->entity && enclosingScope.class_->entity->name == function.entity->name;
}

bool CPP::IsDependent (const Expression& expression)
{
	return IsDependent (expression.type) || IsDependent (expression.value);
}

bool CPP::IsDeprecated (const Attribute& attribute)
{
	return attribute.model == Attribute::Deprecated;
}

bool CPP::IsCode (const Attribute& attribute)
{
	return attribute.model == Attribute::Code;
}

bool CPP::IsFunctionPointer (const Type& type)
{
	return IsPointer (type) && IsFunction (*type.pointer.baseType);
}

bool CPP::IsMemberFunctionPointer (const Type& type)
{
	return IsMemberPointer (type) && IsFunction (*type.memberPointer.baseType);
}

bool CPP::IsNamedNamespace (const Scope& scope)
{
	return scope.model == Scope::Namespace && scope.namespace_->entity;
}

bool CPP::IsLValueReference (const Type& type)
{
	return type.reference == Type::LValue;
}

bool CPP::IsQualified (const Identifier& identifier)
{
	return identifier.nestedNameSpecifier;
}

bool CPP::IsStaticStorage (const Entity& entity)
{
	return IsFunction (entity) || IsVariable (entity) && HasStaticStorageDuration (*entity.variable);
}

bool CPP::IsUnscoped (const Enumeration& enumeration)
{
	return IsUnscoped (enumeration.key);
}

bool CPP::IsUnsignedInteger (const Type& type)
{
	return type.model == Type::UnsignedCharacter || type.model == Type::UnsignedShortInteger || type.model == Type::UnsignedInteger ||
		type.model == Type::UnsignedLongInteger || type.model == Type::UnsignedLongLongInteger;
}

bool CPP::IsLongInteger (const Type& type)
{
	return type.model == Type::LongInteger || type.model == Type::UnsignedLongInteger;
}

bool CPP::IsLongLongInteger (const Type& type)
{
	return type.model == Type::LongLongInteger || type.model == Type::UnsignedLongLongInteger;
}

bool CPP::IsFloat (const Type& type)
{
	return type.model == Type::Float;
}

bool CPP::IsDouble (const Type& type)
{
	return type.model == Type::Double;
}

bool CPP::IsLongDouble (const Type& type)
{
	return type.model == Type::LongDouble;
}

bool CPP::IsCondition (const Declaration& declaration)
{
	return declaration.model == Declaration::Condition;
}

bool CPP::IsDeclaration (const Statement& statement)
{
	return statement.model == Statement::Declaration;
}

bool CPP::IsIdentifier (const Expression& expression)
{
	return expression.model == Expression::Identifier;
}

bool CPP::IsModifiable (const Expression& expression)
{
	return !IsConst (expression.type) && !IsFunction (expression.type);
}

bool CPP::IsUnspecified (const Attribute& attribute)
{
	return attribute.model == Attribute::Unspecified;
}

bool CPP::IsNonStaticMember (const Entity& entity)
{
	return IsMember (entity) && IsStorage (entity) && !IsStatic (*entity.storage);
}

bool CPP::IsQualifiedFunction (const Type& type)
{
	return IsFunction (type) && (type.function.constVolatileQualifiers || type.function.referenceQualifier);
}

bool CPP::IsScopedEnumeration (const Type& type)
{
	return IsEnumeration (type) && IsScoped (*type.enumeration);
}

bool CPP::IsUnqualified (const Identifier& identifier)
{
	return !identifier.nestedNameSpecifier;
}

bool CPP::BeginsWithPlus (const Expression& expression)
{
	return expression.model == Expression::Conversion && BeginsWithPlus (*expression.conversion.expression) ||
		expression.model == Expression::Unary && expression.unary.operator_.symbol == Lexer::Plus || expression.model == Expression::Prefix && expression.prefix.operator_.symbol == Lexer::DoublePlus;
}

bool CPP::HasSideEffects (const Expression& expression)
{
	return expression.hasSideEffects;
}

bool CPP::HasSideEffects (const Initializer& initializer)
{
	for (auto& expression: initializer.expressions) if (HasSideEffects (expression)) return true; return false;
}

bool CPP::IsPotentiallyThrowing (const Expression& expression)
{
	return expression.isPotentiallyThrowing;
}

bool CPP::IsNonThrowing (const NoexceptSpecifier& specifier)
{
	return specifier.throw_ || !specifier.expression || !IsFalse (*specifier.expression);
}

bool CPP::IsFunctionPrototype (const Scope& scope)
{
	return scope.model == Scope::FunctionPrototype;
}

bool CPP::IsUnnamedEnumeration (const Type& type)
{
	return IsEnumeration (type) && IsUnnamed (*type.enumeration);
}

bool CPP::BeginsWithMinus (const Expression& expression)
{
	return expression.model == Expression::Conversion && BeginsWithMinus (*expression.conversion.expression) ||
		expression.model == Expression::Unary && expression.unary.operator_.symbol == Lexer::Minus || expression.model == Expression::Prefix && expression.prefix.operator_.symbol == Lexer::DoubleMinus;
}

bool CPP::IsParenthesized (const Declarator& declarator)
{
	return declarator.model == Declarator::Parenthesized;
}

bool CPP::IsExiting (const FunctionBody& body)
{
	return body.isExiting;
}

bool CPP::IsExiting (const StatementBlock& block)
{
	return block.isExiting;
}

bool CPP::IsStringLiteral (const Expression& expression)
{
	return expression.model == Expression::StringLiteral;
}

bool CPP::IsUnscopedEnumeration (const Type& type)
{
	return IsEnumeration (type) && IsUnscoped (*type.enumeration);
}

bool CPP::IsDeclaration (const TypeSpecifier& specifier)
{
	return specifier.model == TypeSpecifier::Enum && (specifier.enum_.head.identifier || specifier.enum_.enumerators) || specifier.model == TypeSpecifier::Class && specifier.class_.head.identifier;
}

bool CPP::IsIntegerLiteral (const Expression& expression)
{
	return expression.model == Expression::Literal && IsInteger (expression.literal.token.symbol);
}

bool CPP::IsInlinedFunctionCall (const Expression& expression)
{
	return expression.model == Expression::InlinedFunctionCall;
}

bool CPP::IsPureSpecifier (const Initializer& initializer)
{
	return initializer.assignment && !initializer.braced && initializer.expressions.size () == 1 && IsIntegerLiteral (initializer.expressions.front ()) && IsZero (initializer.expressions.front ().value);
}

bool CPP::IsType (const DeclarationSpecifier& specifier)
{
	return specifier.model == DeclarationSpecifier::Type;
}

bool CPP::IsVoid (const ParameterDeclaration& declaration)
{
	return !declaration.attributes && declaration.specifiers.size () == 1 && IsVoid (declaration.specifiers.type) &&
		IsUnqualified (declaration.specifiers.type) && !declaration.declarator && !declaration.initializer;
}

bool CPP::RequiresType (const TypeSpecifiers& specifiers)
{
	return IsUndefined (specifiers.type);
}

bool CPP::IsVoid (const ParameterDeclarations& declarations)
{
	return !declarations.isPacked && declarations.size () == 1 && IsVoid (declarations.front ());
}

bool CPP::RequiresReturnValue (const Function& function)
{
	return HasReturnType (function) && !IsMain (function);
}

bool CPP::HasInitializer (const InitDeclarator& declarator)
{
	return declarator.initializer;
}

bool CPP::IsCarriesDependency (const Attribute& attribute)
{
	return attribute.model == Attribute::CarriesDependency;
}

bool CPP::IsRegister (const Attribute& attribute)
{
	return attribute.model == Attribute::Register;
}

bool CPP::IsExtern (const DeclarationSpecifier& specifier)
{
	return IsStorageClass (specifier) && specifier.storageClass.specifier == Lexer::Extern;
}

bool CPP::IsFriend (const DeclarationSpecifier& specifier)
{
	return specifier.model == DeclarationSpecifier::Friend;
}

bool CPP::IsStatic (const DeclarationSpecifier& specifier)
{
	return IsStorageClass (specifier) && specifier.storageClass.specifier == Lexer::Static;
}

bool CPP::IsAlignment (const AttributeSpecifier& specifier)
{
	return specifier.model != AttributeSpecifier::Attributes;
}

bool CPP::IsExtern (const DeclarationSpecifiers& specifiers)
{
	return specifiers.storageClass == Lexer::Extern;
}

bool CPP::IsInline (const DeclarationSpecifiers& specifiers)
{
	return specifiers.isInline;
}

bool CPP::IsInline (const Entity& entity)
{
	return IsStorage (entity) && IsInline (*entity.storage);
}

bool CPP::IsInline (const Storage& storage)
{
	return storage.isInline;
}

bool CPP::IsInline (const Scope& scope)
{
	for (auto enclosingScope = scope.enclosingScope; enclosingScope; enclosingScope = enclosingScope->enclosingScope)
		if (IsFunction (*enclosingScope)) return IsInline (*enclosingScope->function);
	return false;
}

bool CPP::IsInlineable (const Function& function)
{
	return IsInline (function) && function.body;
}

bool CPP::IsFunctionCall (const Expression& expression)
{
	return expression.model == Expression::FunctionCall;
}

bool CPP::IsParenthesizedName (const Declarator& declarator)
{
	if (!IsParenthesized (declarator)) return IsName (declarator);
	assert (declarator.parenthesized.declarator); return IsParenthesizedName (*declarator.parenthesized.declarator);
}

bool CPP::IsStatic (const DeclarationSpecifiers& specifiers)
{
	return specifiers.storageClass == Lexer::Static;
}

bool CPP::IsTypedef (const DeclarationSpecifier& specifier)
{
	return specifier.model == DeclarationSpecifier::Typedef;
}

bool CPP::IsDefinition (const TypeSpecifier& specifier)
{
	return specifier.model == TypeSpecifier::Enum && specifier.enum_.isDefinition || specifier.model == TypeSpecifier::Class && specifier.class_.isDefinition;
}

bool CPP::IsConversionFunction (const Identifier& identifier)
{
	return identifier.model == Identifier::ConversionFunction;
}

bool CPP::IsFunction (const DeclarationSpecifier& specifier)
{
	return specifier.model == DeclarationSpecifier::Function;
}

bool CPP::IsFunctionDefinition (const Declarator& declarator)
{
	switch (declarator.model)
	{
	case Declarator::Name: return false;
	case Declarator::Array: return declarator.array.declarator && IsFunctionDefinition (*declarator.array.declarator);
	case Declarator::Pointer: return declarator.pointer.declarator && IsFunctionDefinition (*declarator.pointer.declarator);
	case Declarator::Function: return declarator.function.declarator && (IsParenthesizedName (*declarator.function.declarator) || IsFunctionDefinition (*declarator.function.declarator));
	case Declarator::Reference: return declarator.reference.declarator && IsFunctionDefinition (*declarator.reference.declarator);
	case Declarator::MemberPointer: return declarator.memberPointer.declarator && IsFunctionDefinition (*declarator.memberPointer.declarator);
	case Declarator::Parenthesized: assert (declarator.parenthesized.declarator); return IsFunctionDefinition (*declarator.parenthesized.declarator);
	default: assert (Declarator::Unreachable);
	}
}

bool CPP::IsParenthesizedArray (const Declarator& declarator)
{
	if (declarator.model != Declarator::Parenthesized) return declarator.model == Declarator::Array;
	assert (declarator.parenthesized.declarator); return IsParenthesizedArray (*declarator.parenthesized.declarator);
}

bool CPP::IsTypedef (const DeclarationSpecifiers& specifiers)
{
	return specifiers.isTypedef;
}

bool CPP::IsNoreturnCall (const Expressions& expressions)
{
	for (auto& expression: expressions) if (IsNoreturnCall (expression)) return true; return false;
}

bool CPP::IsNoreturnCall (const Expression& expression)
{
	if (!IsVoid (expression.type)) return false;

	switch (expression.model)
	{
	case Expression::Comma:
		return IsNoreturnCall (*expression.comma.left) || IsNoreturnCall (*expression.comma.right);

	case Expression::Throw:
		return true;

	case Expression::Conditional:
		if (IsTrue (*expression.conditional.condition)) return IsNoreturnCall (*expression.conditional.left);
		if (IsFalse (*expression.conditional.condition)) return IsNoreturnCall (*expression.conditional.right);
		return IsNoreturnCall (*expression.conditional.left) && IsNoreturnCall (*expression.conditional.right);

	case Expression::FunctionCall:
		return expression.functionCall.function && IsNoreturn (*expression.functionCall.function);

	case Expression::Parenthesized:
		return IsNoreturnCall (*expression.parenthesized.expression);

	case Expression::ConstructorCall:
		return IsNoreturnCall (*expression.constructorCall.expressions);

	case Expression::InlinedFunctionCall:
		return IsNoreturnCall (*expression.inlinedFunctionCall.expression);

	default:
		assert (Expression::Unreachable);
	}
}

bool CPP::HasStaticStorageDuration (const Variable& variable)
{
	return IsNamespace (*variable.entity->enclosingScope) || IsStatic (variable);
}

bool CPP::HasAutomaticStorageDuration (const Variable& variable)
{
	return IsLocal (*variable.entity->enclosingScope) && !IsStatic (variable);
}

bool CPP::IsConstexpr (const Storage& storage)
{
	return storage.isConstexpr;
}

bool CPP::IsAddressof (const Expression& expression)
{
	return expression.model == Expression::Addressof;
}

bool CPP::IsMemberAccess (const Expression& expression)
{
	return expression.model == Expression::MemberAccess;
}

bool CPP::IsConstexpr (const DeclarationSpecifier& specifier)
{
	return specifier.model == DeclarationSpecifier::Constexpr;
}

bool CPP::IsFunctionDefinition (const Declaration& declaration)
{
	return declaration.model == Declaration::FunctionDefinition;
}

bool CPP::IsNullPointerConstant (const Expression& expression)
{
	return IsIntegerLiteral (expression) && IsZero (expression.value) || IsPRValue (expression) && IsNullPointer (expression.type);
}

bool CPP::IsNoreturnCall (const Initializer& initializer)
{
	return IsNoreturnCall (initializer.expressions);
}

bool CPP::IsConstexpr (const DeclarationSpecifiers& specifiers)
{
	return specifiers.isConstexpr;
}

bool CPP::IsParenthesizedFunction (const Declarator& declarator)
{
	if (declarator.model != Declarator::Parenthesized) return declarator.model == Declarator::Function;
	assert (declarator.parenthesized.declarator); return IsParenthesizedFunction (*declarator.parenthesized.declarator);
}

bool CPP::RequiresType (const DeclarationSpecifiers& specifiers)
{
	return IsUndefined (specifiers.type);
}

bool CPP::IsDeclaration (const DeclarationSpecifiers& specifiers)
{
	for (auto& specifier: specifiers) if (IsType (specifier) && IsDeclaration (*specifier.type.specifier)) return true; return false;
}

bool CPP::IsStorageClass (const DeclarationSpecifier& specifier)
{
	return specifier.model == DeclarationSpecifier::StorageClass;
}

bool CPP::IsThreadLocal (const DeclarationSpecifiers& specifiers)
{
	return specifiers.isThreadLocal;
}

bool CPP::IsTypeDefinition (const DeclarationSpecifier& specifier)
{
	return IsType (specifier) && IsDefinition (*specifier.type.specifier);
}

bool CPP::IsNoreturnCall (const MemberInitializers& initializers)
{
	for (auto& member: initializers) if (IsNoreturnCall (member.initializer)) return true; return false;
}

bool CPP::IsExternLinkageSpecification (const Declaration& declaration)
{
	return declaration.model == Declaration::LinkageSpecification && declaration.linkageSpecification.declaration;
}

bool CPP::IsNarrowingConversion (const Expression& expression, Platform& platform)
{
	assert (expression.model == Expression::Conversion);
	const auto& source = *expression.conversion.expression;

	switch (expression.conversion.model)
	{
	case Conversion::Integral:
		return platform.GetSize (source.type) > platform.GetSize (expression.type) && (!IsValid (source.value) || !expression.value.Represents (source.value));

	case Conversion::FloatingPoint:
		return platform.GetSize (source.type) > platform.GetSize (expression.type) &&
			(!IsValid (source.value) || !TruncatesPreserving (source.value.float_, platform.GetBits (expression.type)));

	case Conversion::FloatingIntegral:
		return IsFloatingPoint (source.type) || !IsValid (source.value) || !expression.value.Represents (source.value);

	default:
		return false;
	}
}

bool CPP::HasInternalLinkage (const Entity& entity)
{
	return IsNamespace (*entity.enclosingScope) && (IsStorage (entity) && IsStatic (*entity.storage) || HasInternalLinkage (*entity.enclosingScope->namespace_));
}

bool CPP::HasInternalLinkage (const Namespace& namespace_)
{
	return !IsGlobal (namespace_) && (IsUnnamed (namespace_) || HasInternalLinkage (*namespace_.scope.enclosingScope->namespace_));
}

Type CPP::GetType (const Entity& entity)
{
	switch (entity.model)
	{
	case Entity::Alias: return *entity.alias;
	case Entity::Class: return *entity.class_;
	case Entity::Function: return entity.function->type;
	case Entity::Variable: return entity.variable->type;
	case Entity::Parameter: return entity.parameter->type;
	case Entity::Enumerator: return entity.enumerator->type;
	case Entity::Enumeration: return *entity.enumeration;
	default: assert (Entity::Unreachable);
	}
}

String CPP::GetName (const Array& array)
{
	if (array.stringLiteral) return GetName (*array.stringLiteral);
	std::ostringstream stream;
	stream << "_array_" << array.index;
	return stream.str ();
}

Scope& CPP::GetScope (const Type& type)
{
	switch (type.model)
	{
	case Type::Class: return type.class_->scope;
	case Type::Enumeration: return type.enumeration->scope;
	default: assert (Type::Unreachable);
	}
}

String CPP::GetName (const Type& type)
{
	std::ostringstream stream;
	if (IsAliased (type) && IsAlias (*type.alias)) WriteQualified (stream, *type.alias); else stream << type;
	return stream.str ();
}

String CPP::GetName (const Entity& entity)
{
	std::ostringstream stream;

	switch (entity.model)
	{
	case Entity::Label:
		assert (IsFunction (*entity.enclosingScope));
		WriteQualified (stream, entity, HasInternalLinkage (*entity.enclosingScope->function->entity));
		break;

	case Entity::Function:
	case Entity::Variable:
		if (entity.storage->alias && !IsDefined (entity))
			stream << *entity.storage->alias;
		else if (entity.storage->linkage == LanguageLinkage::C || IsMainFunction (entity) || IsVariable (entity) && IsRegister (*entity.variable))
			stream << entity.name;
		else if (entity.storage->linkage == LanguageLinkage::Oberon)
			assert (IsNamedNamespace (*entity.enclosingScope)),
			stream << entity.enclosingScope->namespace_->entity->name << '.' << entity.name;
		else
			WriteQualified (stream, entity, HasInternalLinkage (entity));
		break;

	case Entity::Parameter:
		stream << entity.name;
		break;

	default:
		assert (Entity::Unreachable);
	}

	return stream.str ();
}

Scope& CPP::GetScope (const Entity& entity)
{
	switch (entity.model)
	{
	case Entity::Alias: return GetScope (*entity.alias);
	case Entity::Class: return entity.class_->scope;
	case Entity::Namespace: case Entity::NamespaceAlias: return entity.namespace_->scope;
	case Entity::Enumeration: return entity.enumeration->scope;
	default: assert (Entity::Unreachable);
	}
}

Class* CPP::GetEnclosingClass (const Scope& scope)
{
	for (auto enclosingScope = &scope; enclosingScope; enclosingScope = enclosingScope->enclosingScope)
		if (IsClass (*enclosingScope)) return enclosingScope->class_;
	return nullptr;
}

Type CPP::RemoveReference (const Type& type)
{
	auto result = type; result.reference = Type::None; return result;
}

Size CPP::GetSize (const StringLiteral& literal)
{
	Size size = 1; for (auto& token: literal.tokens) assert (IsString (token.symbol)), size += token.literal->size (); return size;
}

Type CPP::RemoveQualifiers (const Type& type)
{
	auto result = type; Discard (result.qualifiers); return result;
}

Type CPP::RemoveExceptionSpecification (const Type& type)
{
	assert (IsFunction (type));
	auto result = type; result.function.noexcept_ = false; return result;
}

String CPP::GetName (const StringLiteral& literal)
{
	std::ostringstream stream;
	switch (literal.symbol) {
	case Lexer::NarrowString: break;
	case Lexer::Char8TString: stream << "u8"; break;
	case Lexer::Char16TString: stream << 'u'; break;
	case Lexer::Char32TString: stream << 'U'; break;
	case Lexer::WideString: stream << 'L'; break;
	default: assert (Lexer::UnreachableLiteral);
	}
	stream << '$';
	for (auto& token: literal.tokens) WriteEscaped (stream, *token.literal, '?');
	return stream.str ();
}

void CPP::Discard (ConstVolatileQualifiers& qualifiers)
{
	qualifiers.isConst = false; qualifiers.isVolatile = false;
}

String CPP::Concatenate (const StringLiteral& literal)
{
	assert (!literal.tokens.empty ()); std::ostringstream stream;
	for (auto& token: literal.tokens) assert (!HasStringSuffix (token)), WriteEscaped (stream, *token.literal, '\'');
	return stream.str ();
}

const Declarator& CPP::GetName (const Declarator& declarator)
{
	switch (declarator.model)
	{
	case Declarator::Name: return declarator;
	case Declarator::Pointer: assert (declarator.pointer.declarator); return GetName (*declarator.pointer.declarator);
	case Declarator::Function: assert (declarator.function.declarator); return GetName (*declarator.function.declarator);
	case Declarator::Reference: assert (declarator.reference.declarator); return GetName (*declarator.reference.declarator);
	case Declarator::MemberPointer: assert (declarator.memberPointer.declarator); return GetName (*declarator.memberPointer.declarator);
	default: assert (Declarator::Unreachable);
	}
}

Statement* CPP::GetPrevious (const Statement& statement)
{
	assert (statement.enclosingBlock); auto iterator = statement.iterator;
	return iterator != statement.enclosingBlock->statements.begin () ? &*--iterator : nullptr;
}

Statement* CPP::GetNext (const Statement& statement)
{
	assert (statement.enclosingBlock); auto iterator = statement.iterator;
	return ++iterator != statement.enclosingBlock->statements.end () ? &*iterator : nullptr;
}

Statement* CPP::GetEnclosing (const Statement& statement)
{
	assert (statement.enclosingBlock);
	return statement.enclosingBlock->enclosingStatement;
}

Statement* CPP::GetEnclosingSwitch (const Statement& statement)
{
	auto enclosingStatement = GetEnclosing (statement);
	while (enclosingStatement && !IsSwitch (*enclosingStatement)) enclosingStatement = GetEnclosing (*enclosingStatement);
	return enclosingStatement;
}

Statement* CPP::GetEnclosingBreakable (const Statement& statement)
{
	auto enclosingStatement = GetEnclosing (statement);
	while (enclosingStatement && !IsIteration (*enclosingStatement) && !IsSwitch (*enclosingStatement)) enclosingStatement = GetEnclosing (*enclosingStatement);
	return enclosingStatement;
}

Statement* CPP::GetEnclosingIteration (const Statement& statement)
{
	auto enclosingStatement = GetEnclosing (statement);
	while (enclosingStatement && !IsIteration (*enclosingStatement)) enclosingStatement = GetEnclosing (*enclosingStatement);
	return enclosingStatement;
}

Value CPP::ConvertToPointer (const Value& value)
{
	assert (IsReference (value)); auto result = value; result.model = Value::Pointer; return result;
}

Value CPP::ConvertToReference (const Value& value)
{
	assert (IsPointer (value)); auto result = value; result.model = Value::Reference; return result;
}

bool CPP::FindLanguageLinkage (const String& string, LanguageLinkage& linkage)
{
	return FindEnum (string, linkage, languageLinkages);
}

bool CPP::FindPredicate (const String& string, Predicate& predicate)
{
	static const char*const typetraits[] {
		#define TYPETRAIT(predicate, name) name,
		#include "cpp.def"
	};

	static const Predicate predicates[] {
		#define TYPETRAIT(predicate, name) predicate,
		#include "cpp.def"
	};

	std::size_t typetrait;
	if (!FindSortedEnum (string, typetrait, typetraits)) return false;
	return predicate = predicates[typetrait], true;
}

std::ostream& CPP::operator << (std::ostream& stream, const Name& name)
{
	switch (name.model)
	{
	case Name::Literal:
		return stream << Lexer::Operator << "\"\"" << *name.suffixIdentifier;

	case Name::Operator:
		stream << Lexer::Operator;
		if (name.operator_.symbol == Lexer::New || name.operator_.symbol == Lexer::Delete) stream << ' ';
		return stream << name.operator_;

	case Name::Conversion:
		return stream << Lexer::Operator << ' ' << *name.conversion;

	case Name::Destructor:
		assert (name.destructor);
		return stream << Lexer::Tilde << name.destructor->class_->entity->name;

	case Name::Identifier:
		return stream << *name.identifier;

	default:
		assert (Name::Unreachable);
	}
}

std::ostream& CPP::operator << (std::ostream& stream, const Type& type)
{
	return WriteSuffixed (WritePrefixed (stream, type), type);
}

std::ostream& CPP::WriteFormatted (std::ostream& stream, const Type& type)
{
	if (!IsAliased (type) || !IsAlias (*type.alias) || IsUnnamedClass (type) || IsUnnamedEnumeration (type)) return stream << '\'' << type << '\'';
	return WriteQualified (stream << '\'', *type.alias) << "' (alias for '" << type << "')";
}

std::ostream& CPP::WritePrefixed (std::ostream& stream, const Type& type)
{
	if (type.qualifiers && type.model != Type::Pointer) stream << type.qualifiers << ' ';

	switch (type.model)
	{
	case Type::Character:
		return stream << Lexer::Char;

	case Type::SignedCharacter:
		return stream << Lexer::Signed << ' ' << Lexer::Char;

	case Type::UnsignedCharacter:
		return stream << Lexer::Unsigned << ' ' << Lexer::Char;

	case Type::WideCharacter:
		return stream << Lexer::WCharT;

	case Type::Character16:
		return stream << Lexer::Char16T;

	case Type::Character32:
		return stream << Lexer::Char32T;

	case Type::Signed:
		return stream << Lexer::Signed;

	case Type::Unsigned:
		return stream << Lexer::Unsigned;

	case Type::Short:
		return stream << Lexer::Short;

	case Type::SignedShort:
		return stream << Lexer::Signed << ' ' << Lexer::Short;

	case Type::UnsignedShort:
		return stream << Lexer::Unsigned << ' ' << Lexer::Short;

	case Type::ShortInteger:
		return stream << Lexer::Short << ' ' << Lexer::Int;

	case Type::SignedShortInteger:
		return stream << Lexer::Signed << ' ' << Lexer::Short << ' ' << Lexer::Int;

	case Type::UnsignedShortInteger:
		return stream << Lexer::Unsigned << ' ' << Lexer::Short << ' ' << Lexer::Int;

	case Type::Integer:
		return stream << Lexer::Int;

	case Type::SignedInteger:
		return stream << Lexer::Signed << ' ' << Lexer::Int;

	case Type::UnsignedInteger:
		return stream << Lexer::Unsigned << ' ' << Lexer::Int;

	case Type::Long:
		return stream << Lexer::Long;

	case Type::SignedLong:
		return stream << Lexer::Signed << ' ' << Lexer::Long;

	case Type::UnsignedLong:
		return stream << Lexer::Unsigned << ' ' << Lexer::Long;

	case Type::LongInteger:
		return stream << Lexer::Long << ' ' << Lexer::Int;

	case Type::SignedLongInteger:
		return stream << Lexer::Signed << ' ' << Lexer::Long << ' ' << Lexer::Int;

	case Type::UnsignedLongInteger:
		return stream << Lexer::Unsigned << ' ' << Lexer::Long << ' ' << Lexer::Int;

	case Type::LongLong:
		return stream << Lexer::Long << ' ' << Lexer::Long;

	case Type::SignedLongLong:
		return stream << Lexer::Signed << ' ' << Lexer::Long << ' ' << Lexer::Long;

	case Type::UnsignedLongLong:
		return stream << Lexer::Unsigned << ' ' << Lexer::Long << ' ' << Lexer::Long;

	case Type::LongLongInteger:
		return stream << Lexer::Long << ' ' << Lexer::Long << ' ' << Lexer::Int;

	case Type::SignedLongLongInteger:
		return stream << Lexer::Signed << ' ' << Lexer::Long << ' ' << Lexer::Long << ' ' << Lexer::Int;

	case Type::UnsignedLongLongInteger:
		return stream << Lexer::Unsigned << ' ' << Lexer::Long << ' ' << Lexer::Long << ' ' << Lexer::Int;

	case Type::Boolean:
		return stream << Lexer::Bool;

	case Type::Float:
		return stream << Lexer::Float;

	case Type::Double:
		return stream << Lexer::Double;

	case Type::LongDouble:
		return stream << Lexer::Long << ' ' << Lexer::Double;

	case Type::NullPointer:
		return stream << "std" << Lexer::DoubleColon << Lexer::Nullptr << "_t";

	case Type::Void:
		return stream << Lexer::Void;

	case Type::Auto:
		return stream << Lexer::Auto;

	case Type::Class:
		assert (type.class_);
		return type.class_->entity ? WriteQualified (stream, *type.class_->entity) : stream << type.class_->scope;

	case Type::Enumeration:
		assert (type.enumeration);
		return type.enumeration->entity ? WriteQualified (stream, *type.enumeration->entity) : stream << type.enumeration->scope;

	case Type::Array:
		assert (type.array.elementType);
		return WritePrefixed (stream, *type.array.elementType);

	case Type::Function:
		assert (type.function.returnType);
		if (type.function.linkage == LanguageLinkage::C) stream << Lexer::Extern << " \"" << type.function.linkage << "\" ";
		WritePrefixed (stream, *type.function.returnType);
		if (type.reference) stream << Lexer::LeftParen;
		return stream;

	case Type::Pointer:
		assert (type.pointer.baseType);
		WritePrefixed (stream, *type.pointer.baseType);
		if (IsArray (*type.pointer.baseType) || IsFunction (*type.pointer.baseType)) stream << Lexer::LeftParen;
		return stream << Lexer::Asterisk << type.qualifiers;

	case Type::MemberPointer:
		assert (type.memberPointer.baseType); assert (type.memberPointer.class_);
		WritePrefixed (stream, type.memberPointer.baseType) << ' ';
		if (IsArray (*type.memberPointer.baseType) || IsFunction (*type.memberPointer.baseType)) stream << Lexer::LeftParen;
		return WriteQualified (stream, type.memberPointer.class_->scope) << Lexer::Asterisk << type.qualifiers;

	case Type::Alias:
		assert (type.alias);
		return WriteQualified (stream, *type.alias);

	case Type::Decltype:
		return stream << Lexer::Decltype << ' ' << Lexer::LeftParen << Lexer::Ellipsis << Lexer::RightParen;

	default:
		assert (Type::Unreachable);
	}
}

std::ostream& CPP::WriteSuffixed (std::ostream& stream, const Type& type)
{
	if (type.reference == Type::LValue) stream << Lexer::Ampersand;
	else if (type.reference == Type::RValue) stream << Lexer::DoubleAmpersand;

	switch (type.model)
	{
	case Type::Array:
		assert (type.array.elementType);
		stream << Lexer::LeftBracket; if (type.array.bound) stream << type.array.bound;
		return WriteSuffixed (stream << Lexer::RightBracket, *type.array.elementType);

	case Type::Function:
		assert (type.function.returnType);
		assert (type.function.parameterTypes);
		if (type.reference) stream << Lexer::RightParen;
		stream << Lexer::LeftParen << *type.function.parameterTypes;
		if (type.function.variadic) (!type.function.parameterTypes->empty () ? stream << Lexer::Comma : stream) << Lexer::Ellipsis;
		stream << Lexer::RightParen;
		if (type.function.constVolatileQualifiers) stream << ' ' << type.function.constVolatileQualifiers;
		if (type.function.referenceQualifier) stream << ' ' << type.function.referenceQualifier;
		if (type.function.noexcept_) stream << ' ' << Lexer::Noexcept;
		return WriteSuffixed (stream, *type.function.returnType);

	case Type::Pointer:
		assert (type.pointer.baseType);
		if (IsArray (*type.pointer.baseType) || IsFunction (*type.pointer.baseType)) stream << Lexer::RightParen;
		return WriteSuffixed (stream, *type.pointer.baseType);

	case Type::MemberPointer:
		assert (type.memberPointer.baseType); assert (type.memberPointer.class_);
		if (IsArray (*type.memberPointer.baseType) || IsFunction (*type.memberPointer.baseType)) stream << Lexer::RightParen;
		return WriteSuffixed (stream, *type.memberPointer.baseType);

	default:
		return stream;
	}
}

std::ostream& CPP::operator << (std::ostream& stream, const Scope& scope)
{
	switch (scope.model)
	{
	case Scope::Block:
		return stream << *scope.enclosingScope;

	case Scope::Class:
		if (IsUnnamed (*scope.class_)) stream << "unnamed " << scope.class_->key;
		else return stream << *scope.class_->entity;
		break;

	case Scope::Function:
		return stream << *scope.function->entity;

	case Scope::Namespace:
		if (IsGlobal (*scope.namespace_)) return stream << "global " << Lexer::Namespace;
		else if (IsUnnamed (*scope.namespace_)) stream << "unnamed " << Lexer::Namespace;
		else return stream << *scope.namespace_->entity;
		break;

	case Scope::Enumeration:
		if (IsUnnamed (*scope.enumeration)) stream << "unnamed " << Lexer::Enum;
		else return stream << *scope.enumeration->entity;
		break;

	default:
		assert (Scope::Unreachable);
	}

	assert (scope.enclosingScope);
	return stream << " in " << *scope.enclosingScope;
}

std::ostream& CPP::WriteQualified (std::ostream& stream, const Scope& scope, const bool internal)
{
	switch (scope.model)
	{
	case Scope::Block:
		assert (scope.enclosingScope);
		WriteQualified (stream, *scope.enclosingScope, internal);
		break;

	case Scope::Class:
		if (scope.class_->entity) WriteQualified (stream, *scope.class_->entity, internal);
		else WriteQualified (stream, *scope.enclosingScope, internal) << Lexer::LeftBrace << scope.class_->key << scope.class_->index << Lexer::RightBrace;
		break;

	case Scope::Function:
		assert (scope.function->entity);
		return WriteQualified (stream, *scope.function->entity, internal);

	case Scope::Namespace:
		if (scope.namespace_->entity) WriteQualified (stream, *scope.namespace_->entity, internal);
		else if (scope.enclosingScope) WriteQualified (stream, *scope.enclosingScope, internal) << Lexer::LeftBrace << Lexer::Namespace << scope.namespace_->index << Lexer::RightBrace;
		else if (internal) stream << Lexer::LeftBrace << std::hex << scope.namespace_->index << std::dec << Lexer::RightBrace;
		else return stream;
		break;

	case Scope::Enumeration:
		if (scope.enumeration->entity) WriteQualified (stream, *scope.enumeration->entity, internal);
		else WriteQualified (stream, *scope.enclosingScope, internal) << Lexer::LeftBrace << Lexer::Enum << scope.enumeration->index << Lexer::RightBrace;
		break;

	default:
		assert (Scope::Unreachable);
	}

	return stream << Lexer::DoubleColon;
}

std::ostream& CPP::operator << (std::ostream& stream, const Types& types)
{
	for (auto& type: types) (IsFirst (type, types) ? stream : stream << Lexer::Comma) << type; return stream;
}

std::ostream& CPP::operator << (std::ostream& stream, const Entity& entity)
{
	switch (entity.model)
	{
	case Entity::Alias:
		stream << "type alias";
		break;

	case Entity::Class:
		stream << entity.class_->key;
		break;

	case Entity::Label:
		stream << "label";
		break;

	case Entity::Function:
		stream << (IsMember (entity) ? "member function" : "function");
		break;

	case Entity::Variable:
		stream << (IsMember (entity) ? "data member" : "variable");
		break;

	case Entity::Namespace:
		stream << Lexer::Namespace;
		break;

	case Entity::Parameter:
		stream << "parameter";
		break;

	case Entity::Enumerator:
	{
		stream << "enumerator '";
		auto& enumeration = *entity.enclosingScope->enumeration;
		if (!IsLocal (*enumeration.scope.enclosingScope)) WriteQualified (stream, enumeration.scope);
		else if (!IsUnnamed (enumeration)) WriteUnqualified (stream, *enumeration.entity) << Lexer::DoubleColon;
		return WriteUnqualified (stream, entity) << '\'';
	}

	case Entity::Enumeration:
		stream << Lexer::Enum;
		break;

	case Entity::NamespaceAlias:
		stream << Lexer::Namespace << " alias";
		break;

	default:
		assert (Entity::Unreachable);
	}

	if (IsLocal (*entity.enclosingScope)) return WriteUnqualified (stream << " '", entity) << '\'';
	return WriteQualified (stream << " '", entity) << '\'';
}

std::ostream& CPP::WriteQualified (std::ostream& stream, const Entity& entity, const bool internal)
{
	return WriteUnqualified (WriteQualified (stream, *entity.enclosingScope, internal), entity);
}

std::ostream& CPP::WriteSerialized (std::ostream& stream, const Entity& entity)
{
	return IsLocal (entity) ? WriteUnqualified (stream, entity) : WriteQualified (stream, entity);
}

std::ostream& CPP::WriteUnqualified (std::ostream& stream, const Entity& entity)
{
	return entity.model == Entity::Function && entity.function ? stream << entity.name << Lexer::LeftParen << *entity.function->type.function.parameterTypes <<
		Lexer::RightParen << entity.function->type.function.constVolatileQualifiers << entity.function->type.function.referenceQualifier : stream << entity.name;
}

std::ostream& CPP::operator << (std::ostream& stream, const EnumKey& key)
{
	if (key.symbol != Lexer::Enum) stream << Lexer::Enum << ' '; return stream << key.symbol;
}

std::ostream& CPP::operator << (std::ostream& stream, const ClassKey& key)
{
	return stream << key.symbol;
}

std::ostream& CPP::operator << (std::ostream& stream, const Operator& operator_)
{
	stream << operator_.symbol;
	if (operator_.symbol == Lexer::LeftParen) stream << Lexer::RightParen;
	else if (operator_.symbol == Lexer::LeftBracket) stream << Lexer::RightBracket;
	else if (operator_.bracketed) stream << Lexer::LeftBracket << Lexer::RightBracket;
	return stream;
}

std::ostream& CPP::operator << (std::ostream& stream, const StringLiteral& literal)
{
	switch (literal.symbol) {
	case Lexer::NarrowString: break;
	case Lexer::Char8TString: stream << "u8"; break;
	case Lexer::Char16TString: stream << 'u'; break;
	case Lexer::Char32TString: stream << 'U'; break;
	case Lexer::WideString: stream << 'L'; break;
	default: assert (Lexer::UnreachableLiteral);
	}
	stream << '"'; for (auto& token: literal.tokens) assert (IsString (token.symbol)), WriteEscaped (stream, *token.literal, '"'); stream << '"';
	if (literal.suffix) stream << *literal.suffix;
	return stream;
}

std::ostream& CPP::operator << (std::ostream& stream, const LanguageLinkage linkage)
{
	return WriteEnum (stream, linkage, languageLinkages);
}

std::ostream& CPP::operator << (std::ostream& stream, const CaptureDefault default_)
{
	static const Lexer::Symbol defaults[] {Lexer::Equal, Lexer::Ampersand};
	return WriteEnum (stream, default_, defaults);
}

std::ostream& CPP::operator << (std::ostream& stream, const AccessSpecifier& specifier)
{
	return stream << specifier.symbol;
}

std::ostream& CPP::operator << (std::ostream& stream, const Reference& reference)
{
	if (reference.entity) return IsLocal (*reference.entity) ? WriteUnqualified (stream, *reference.entity) : WriteQualified (stream, *reference.entity);
	if (reference.value) return stream << *reference.value; if (reference.array) return stream << *reference.array; return stream;
}

std::ostream& CPP::operator << (std::ostream& stream, const Value& value)
{
	switch (value.model)
	{
	case Value::Float:
		return stream << value.float_;

	case Value::Signed:
		return stream << value.signed_;

	case Value::Boolean:
		return stream << (value.boolean ? Lexer::True : Lexer::False);

	case Value::Pointer:
		if (!value.pointer.entity && !value.pointer.value && !value.pointer.array) if (!value.pointer.offset) return stream << Lexer::Nullptr;
		else {const auto flags = stream.setf (stream.hex | stream.showbase, stream.basefield | stream.showbase | stream.uppercase); stream << value.pointer.offset; stream.flags (flags); return stream;}
		if ((!value.pointer.entity || !IsArray (GetType (*value.pointer.entity))) && !value.pointer.array) stream << Lexer::Ampersand; stream << value.pointer;
		if (value.pointer.offset > 0) stream << " + " << value.pointer.offset; else if (value.pointer.offset < 0) stream << " - " << -value.pointer.offset;
		return stream;

	case Value::Unsigned:
		return stream << value.unsigned_;

	case Value::Reference:
		stream << value.reference;
		if (value.reference.offset) stream << Lexer::LeftBracket << value.reference.offset << Lexer::RightBracket;
		return stream;

	case Value::MemberPointer:
		return WriteQualified (stream << Lexer::Ampersand, *value.memberPointer->entity);

	default:
		assert (Value::Unreachable);
	}
}

std::ostream& CPP::operator << (std::ostream& stream, const Array& array)
{
	if (array.stringLiteral) return stream << *array.stringLiteral; stream << Lexer::LeftBrace;
	for (auto& value: array.values) (IsFirst (value, array.values) ? stream : stream << Lexer::Comma << ' ') << value;
	return stream << Lexer::RightBrace;
}

std::ostream& CPP::operator << (std::ostream& stream, const ValueCategory category)
{
	static const char*const categories[] {"lvalue", "xvalue", "prvalue"};
	return WriteEnum (stream, category, categories);
}

std::ostream& CPP::operator << (std::ostream& stream, const Conversion conversion)
{
	static const char*const conversions[] {"boolean", "pointer", "integral", "null pointer", "floating-point", "qualification", "array-to-pointer", "lvalue-to-rvalue",
		"function pointer", "floating-integral", "function-to-pointer", "integral promotion", "null member pointer", "floating-point promotion"};
	return WriteEnum (stream, conversion, conversions);
}

std::ostream& CPP::operator << (std::ostream& stream, const TypeParameterKey& key)
{
	return stream << key.symbol;
}

std::ostream& CPP::operator << (std::ostream& stream, const VirtualSpecifiers& specifiers)
{
	if (specifiers.final) stream << "final";
	if (specifiers.final && specifiers.override) stream << ' ';
	if (specifiers.override) stream << "override";
	return stream;
}

std::ostream& CPP::operator << (std::ostream& stream, const ReferenceQualifier& qualifier)
{
	if (qualifier.symbol) stream << qualifier.symbol; return stream;
}

std::ostream& CPP::operator << (std::ostream& stream, const ConstVolatileQualifiers& qualifiers)
{
	if (qualifiers.isConst) stream << Lexer::Const;
	if (qualifiers.isConst && qualifiers.isVolatile) stream << ' ';
	if (qualifiers.isVolatile) stream << Lexer::Volatile;
	return stream;
}

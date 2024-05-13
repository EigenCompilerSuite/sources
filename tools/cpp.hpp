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

#ifndef ECS_CPP_HEADER_INCLUDED
#define ECS_CPP_HEADER_INCLUDED

#include "cpplexer.hpp"
#include "structurepool.hpp"

#include <list>
#include <map>

namespace ECS
{
	class Layout;

	using Bits = unsigned;
}

namespace ECS::CPP
{
	enum class CaptureDefault {ByValue, ByReference};
	enum class Conversion {Boolean, Pointer, Integral, NullPointer, FloatingPoint, Qualification, ArrayToPointer, LValueToRValue,
		FunctionPointer, FloatingIntegral, FunctionToPointer, IntegralPromotion, NullMemberPointer, FloatingPointPromotion};
	enum class LanguageLinkage {CPP, C, Oberon};
	enum class ValueCategory {LValue, XValue, PRValue};

	class Platform;

	struct AccessSpecifier;
	struct AlignmentSpecification;
	struct Array;
	struct Attribute;
	struct AttributeSpecifier;
	struct BaseSpecifier;
	struct Capture;
	struct Class;
	struct ClassHead;
	struct ClassKey;
	struct Condition;
	struct ConstVolatileQualifiers;
	struct Declaration;
	struct DeclarationSpecifier;
	struct DeclarationSpecifiers;
	struct Declarator;
	struct DecltypeSpecifier;
	struct Deprecation;
	struct Entity;
	struct Enumeration;
	struct Enumerator;
	struct EnumeratorDefinition;
	struct EnumHead;
	struct EnumKey;
	struct ExceptionDeclaration;
	struct ExceptionHandler;
	struct Expression;
	struct Function;
	struct FunctionBody;
	struct FunctionPrototype;
	struct Identifier;
	struct InitDeclarator;
	struct Initializer;
	struct Label;
	struct LambdaDeclarator;
	struct MemberDeclarator;
	struct MemberInitializer;
	struct Name;
	struct Namespace;
	struct NestedNameSpecifier;
	struct NoexceptSpecifier;
	struct Operator;
	struct Parameter;
	struct ParameterDeclaration;
	struct Reference;
	struct ReferenceQualifier;
	struct Scope;
	struct Statement;
	struct StatementBlock;
	struct Storage;
	struct StringLiteral;
	struct Substatement;
	struct TemplateArgument;
	struct TemplateParameter;
	struct TranslationUnit;
	struct Type;
	struct TypeIdentifier;
	struct TypeParameterKey;
	struct TypeSpecifier;
	struct TypeSpecifiers;
	struct UsingDeclarator;
	struct Value;
	struct Variable;
	struct VirtualSpecifiers;

	template <typename> struct List;
	template <typename> struct Packed;
	template <typename> struct Sequence;

	using Alignment = Size;
	using Attributes = List<Packed<Attribute>>;
	using AttributeSpecifiers = Sequence<AttributeSpecifier>;
	using BaseSpecifiers = List<Packed<BaseSpecifier>>;
	using Captures = List<Packed<Capture>>;
	using CaseTable = std::map<Signed, const Statement*>;
	using Declarations = Sequence<Declaration>;
	using Entities = std::vector<Entity*>;
	using EnumeratorDefinitions = List<EnumeratorDefinition>;
	using ExceptionHandlers = Sequence<ExceptionHandler>;
	using Expressions = List<Expression>;
	using InitDeclarators = List<InitDeclarator>;
	using IntegerConversionRank = Size;
	using MemberDeclarators = List<MemberDeclarator>;
	using MemberInitializers = List<Packed<MemberInitializer>>;
	using ParameterDeclarations = Packed<List<ParameterDeclaration>>;
	using Parameters = std::vector<Parameter>;
	using Predicate = bool (*) (const Type&);
	using Statements = Sequence<Statement>;
	using SymbolTable = std::multimap<Name, Entity*>;
	using TemplateArguments = List<Packed<TemplateArgument>>;
	using TemplateParameters = List<TemplateParameter>;
	using Types = std::vector<Type>;
	using UsingDeclarators = List<Packed<UsingDeclarator>>;
	using Values = std::vector<Value>;

	bool BeginsWithMinus (const Expression&);
	bool BeginsWithPlus (const Expression&);
	bool HasAutomaticStorageDuration (const Variable&);
	bool HasInitializer (const InitDeclarator&);
	bool HasInternalLinkage (const Entity&);
	bool HasInternalLinkage (const Namespace&);
	bool HasLikelihood (const Statement&);
	bool HasRationale (const Attribute&);
	bool HasReturnType (const Function&);
	bool HasScope (const Statement&);
	bool HasSideEffects (const Expression&);
	bool HasSideEffects (const Initializer&);
	bool HasStaticStorageDuration (const Variable&);
	bool HasType (const Entity&);
	bool IsAbstractClass (const Type&);
	bool IsAccess (const Declaration&);
	bool IsAddressof (const Expression&);
	bool IsAlias (const Entity&);
	bool IsAliased (const Type&);
	bool IsAlignment (const AttributeSpecifier&);
	bool IsArithmetic (const Type&);
	bool IsArray (const Type&);
	bool IsAsm (const Declaration&);
	bool IsAuto (const Type&);
	bool IsBasic (const Declaration&);
	bool IsBinary (const Expression&);
	bool IsBitField (const Entity&);
	bool IsBitField (const Expression&);
	bool IsBitField (const Variable&);
	bool IsBlock (const Scope&);
	bool IsBoolean (const Type&);
	bool IsBoolean (const Value&);
	bool IsCarriesDependency (const Attribute&);
	bool IsCharacter (const Type&);
	bool IsCharacterArray (const Type&);
	bool IsClass (const Entity&);
	bool IsClass (const Scope&);
	bool IsClass (const Type&);
	bool IsClass (const TypeSpecifier&);
	bool IsCode (const Attribute&);
	bool IsComplete (const Type&);
	bool IsCondition (const Declaration&);
	bool IsConst (const Type&);
	bool IsConstant (const Expression&);
	bool IsConstant (const Variable&);
	bool IsConstexpr (const DeclarationSpecifier&);
	bool IsConstexpr (const DeclarationSpecifiers&);
	bool IsConstexpr (const Storage&);
	bool IsConstructor (const Function&);
	bool IsConversionFunction (const Identifier&);
	bool IsDeclaration (const DeclarationSpecifiers&);
	bool IsDeclaration (const Statement&);
	bool IsDeclaration (const TypeSpecifier&);
	bool IsDecltyped (const Type&);
	bool IsDefaulted (const Function&);
	bool IsDefined (const Entity&);
	bool IsDefinition (const TypeSpecifier&);
	bool IsDeleted (const Function&);
	bool IsDependent (const Expression&);
	bool IsDependent (const Type&);
	bool IsDependent (const Value&);
	bool IsDeprecated (const Attribute&);
	bool IsDouble (const Type&);
	bool IsEmpty (const StringLiteral&);
	bool IsEnumeration (const Entity&);
	bool IsEnumeration (const Scope&);
	bool IsEnumeration (const Type&);
	bool IsEnumerator (const Entity&);
	bool IsExiting (const FunctionBody&);
	bool IsExiting (const StatementBlock&);
	bool IsExplicitInstantiation (const Declaration&);
	bool IsExtern (const Declaration&);
	bool IsExtern (const DeclarationSpecifier&);
	bool IsExtern (const DeclarationSpecifiers&);
	bool IsExternLinkageSpecification (const Declaration&);
	bool IsFallthrough (const Attribute&);
	bool IsFallthrough (const Statement&);
	bool IsFalse (const Expression&);
	bool IsFloat (const Type&);
	bool IsFloat (const Value&);
	bool IsFloatingPoint (const Type&);
	bool IsFriend (const DeclarationSpecifier&);
	bool IsFunction (const DeclarationSpecifier&);
	bool IsFunction (const Declarator&);
	bool IsFunction (const Entity&);
	bool IsFunction (const Scope&);
	bool IsFunction (const Type&);
	bool IsFunctionCall (const Expression&);
	bool IsFunctionDefinition (const Declaration&);
	bool IsFunctionDefinition (const Declarator&);
	bool IsFunctionPointer (const Type&);
	bool IsFunctionPrototype (const Scope&);
	bool IsFundamental (const Type&);
	bool IsGLValue (const Expression&);
	bool IsGlobal (const Namespace&);
	bool IsGlobal (const Scope&);
	bool IsIdentifier (const Expression&);
	bool IsIdentifier (const Name&);
	bool IsIf (const Statement&);
	bool IsIncomplete (const Type&);
	bool IsInline (const DeclarationSpecifiers&);
	bool IsInline (const Entity&);
	bool IsInline (const Namespace&);
	bool IsInline (const Scope&);
	bool IsInline (const Storage&);
	bool IsInlineable (const Function&);
	bool IsInlinedFunctionCall (const Expression&);
	bool IsIntegerLiteral (const Expression&);
	bool IsIntegral (const Type&);
	bool IsIteration (const Statement&);
	bool IsLValue (const Entity&);
	bool IsLValue (const Expression&);
	bool IsLValueReference (const Type&);
	bool IsLabel (const Entity&);
	bool IsLabeled (const Statement&);
	bool IsLikelihood (const Attribute&);
	bool IsLocal (const Class&);
	bool IsLocal (const Entity&);
	bool IsLocal (const Scope&);
	bool IsLocalReference (const Value&, const Function&);
	bool IsLongDouble (const Type&);
	bool IsLongInteger (const Type&);
	bool IsLongLongInteger (const Type&);
	bool IsMain (const Function&);
	bool IsMainFunction (const Entity&);
	bool IsMaybeUnused (const Attribute&);
	bool IsMaybeUnused (const Entity&);
	bool IsMember (const Declaration&);
	bool IsMember (const Entity&);
	bool IsMemberAccess (const Expression&);
	bool IsMemberFunctionPointer (const Type&);
	bool IsMemberPointer (const Type&);
	bool IsModifiable (const Expression&);
	bool IsName (const Declarator&);
	bool IsName (const Identifier&);
	bool IsNamedNamespace (const Scope&);
	bool IsNamespace (const Entity&);
	bool IsNamespace (const Scope&);
	bool IsNarrowingConversion (const Expression&, Platform&);
	bool IsNodiscard (const Attribute&);
	bool IsNodiscard (const Function&);
	bool IsNodiscard (const Type&);
	bool IsNodiscardCall (const Expression&);
	bool IsNonStaticMember (const Entity&);
	bool IsNonThrowing (const NoexceptSpecifier&);
	bool IsNoreturn (const Attribute&);
	bool IsNoreturn (const Declaration&);
	bool IsNoreturn (const Function&);
	bool IsNoreturnCall (const Expression&);
	bool IsNoreturnCall (const Expressions&);
	bool IsNoreturnCall (const Initializer&);
	bool IsNoreturnCall (const MemberInitializers&);
	bool IsNull (const Statement&);
	bool IsNullPointer (const Type&);
	bool IsNullPointerConstant (const Expression&);
	bool IsObject (const Type&);
	bool IsPRValue (const Expression&);
	bool IsParameter (const Entity&);
	bool IsParenthesized (const Declarator&);
	bool IsParenthesizedArray (const Declarator&);
	bool IsParenthesizedFunction (const Declarator&);
	bool IsParenthesizedName (const Declarator&);
	bool IsPlaceholder (const Type&);
	bool IsPointer (const Type&);
	bool IsPointer (const Value&);
	bool IsPotentiallyThrowing (const Expression&);
	bool IsPredefined (const Entity&);
	bool IsPureSpecifier (const Initializer&);
	bool IsQualified (const Identifier&);
	bool IsQualifiedFunction (const Type&);
	bool IsReachable (const Statement&);
	bool IsReference (const Type&);
	bool IsReference (const Value&);
	bool IsRegister (const Attribute&);
	bool IsRegister (const Entity&);
	bool IsRegister (const Parameter&);
	bool IsRegister (const Type&);
	bool IsRegister (const Variable&);
	bool IsReplaceable (const Entity&);
	bool IsReturning (const Function&);
	bool IsScope (const Entity&);
	bool IsScope (const Type&);
	bool IsScoped (const EnumKey&);
	bool IsScoped (const Enumeration&);
	bool IsScopedEnumeration (const Type&);
	bool IsSigned (const Value&);
	bool IsSignedInteger (const Type&);
	bool IsSimple (const Declaration&);
	bool IsStatic (const DeclarationSpecifier&);
	bool IsStatic (const DeclarationSpecifiers&);
	bool IsStatic (const Storage&);
	bool IsStaticMember (const Entity&);
	bool IsStaticStorage (const Entity&);
	bool IsStorage (const Entity&);
	bool IsStorageClass (const DeclarationSpecifier&);
	bool IsStringLiteral (const Expression&);
	bool IsSwitch (const Statement&);
	bool IsSwitchLabel (const Statement&);
	bool IsTemplate (const Declaration&);
	bool IsTemplate (const Entity&);
	bool IsTemplate (const Function&);
	bool IsThreadLocal (const DeclarationSpecifiers&);
	bool IsTrue (const Expression&);
	bool IsType (const DeclarationSpecifier&);
	bool IsType (const Entity&);
	bool IsTypeDefinition (const DeclarationSpecifier&);
	bool IsTypedef (const DeclarationSpecifier&);
	bool IsTypedef (const DeclarationSpecifiers&);
	bool IsUnboundArray (const Type&);
	bool IsUndefined (const Type&);
	bool IsUnion (const Class&);
	bool IsUnion (const ClassKey&);
	bool IsUnion (const Type&);
	bool IsUnnamed (const Class&);
	bool IsUnnamed (const Enumeration&);
	bool IsUnnamed (const Namespace&);
	bool IsUnnamedClass (const Type&);
	bool IsUnnamedEnumeration (const Type&);
	bool IsUnqualified (const Identifier&);
	bool IsUnqualified (const Type&);
	bool IsUnscoped (const EnumKey&);
	bool IsUnscoped (const Enumeration&);
	bool IsUnscopedEnumeration (const Type&);
	bool IsUnsigned (const Value&);
	bool IsUnsignedInteger (const Type&);
	bool IsUnspecified (const Attribute&);
	bool IsUsed (const Entity&);
	bool IsValid (const Value&);
	bool IsVariable (const Entity&);
	bool IsVoid (const ParameterDeclaration&);
	bool IsVoid (const ParameterDeclarations&);
	bool IsVoid (const Type&);
	bool IsVolatile (const Type&);
	bool IsZero (const Value&);
	bool RequiresReturnValue (const Function&);
	bool RequiresType (const DeclarationSpecifiers&);
	bool RequiresType (const TypeSpecifiers&);

	void Discard (ConstVolatileQualifiers&);

	Statement* GetEnclosingBreakable (const Statement&);
	Statement* GetEnclosing (const Statement&);
	Statement* GetEnclosingIteration (const Statement&);
	Statement* GetEnclosingSwitch (const Statement&);
	Statement* GetNext (const Statement&);
	Statement* GetPrevious (const Statement&);

	auto Concatenate (const StringLiteral&) -> String;
	auto ConvertToPointer (const Value&) -> Value;
	auto ConvertToReference (const Value&) -> Value;
	auto FindLanguageLinkage (const String&, LanguageLinkage&) -> bool;
	auto FindPredicate (const String&, Predicate&) -> bool;
	auto GetEnclosingClass (const Scope&) -> Class*;
	auto GetName (const Array&) -> String;
	auto GetName (const Declarator&) -> const Declarator&;
	auto GetName (const Entity&) -> String;
	auto GetName (const StringLiteral&) -> String;
	auto GetName (const Type&) -> String;
	auto GetScope (const Entity&) -> Scope&;
	auto GetScope (const Type&) -> Scope&;
	auto GetSize (const StringLiteral&) -> Size;
	auto GetType (const Entity&) -> Type;
	auto RemoveExceptionSpecification (const Type&) -> Type;
	auto RemoveQualifiers (const Type&) -> Type;
	auto RemoveReference (const Type&) -> Type;

	std::ostream& operator << (std::ostream&, CaptureDefault);
	std::ostream& operator << (std::ostream&, const AccessSpecifier&);
	std::ostream& operator << (std::ostream&, const Array&);
	std::ostream& operator << (std::ostream&, const ClassKey&);
	std::ostream& operator << (std::ostream&, const ConstVolatileQualifiers&);
	std::ostream& operator << (std::ostream&, const Entity&);
	std::ostream& operator << (std::ostream&, const EnumKey&);
	std::ostream& operator << (std::ostream&, const Name&);
	std::ostream& operator << (std::ostream&, const Operator&);
	std::ostream& operator << (std::ostream&, const Reference&);
	std::ostream& operator << (std::ostream&, const ReferenceQualifier&);
	std::ostream& operator << (std::ostream&, const Scope&);
	std::ostream& operator << (std::ostream&, const StringLiteral&);
	std::ostream& operator << (std::ostream&, const Type&);
	std::ostream& operator << (std::ostream&, const TypeParameterKey&);
	std::ostream& operator << (std::ostream&, const Types&);
	std::ostream& operator << (std::ostream&, const Value&);
	std::ostream& operator << (std::ostream&, const VirtualSpecifiers&);
	std::ostream& operator << (std::ostream&, Conversion);
	std::ostream& operator << (std::ostream&, LanguageLinkage);
	std::ostream& operator << (std::ostream&, ValueCategory);

	std::ostream& WriteFormatted (std::ostream&, const Type&);
	std::ostream& WritePrefixed (std::ostream&, const Type&);
	std::ostream& WriteQualified (std::ostream&, const Entity&, bool = false, Lexer::Symbol = Lexer::DoubleColon, Lexer::Symbol = Lexer::DoubleColon);
	std::ostream& WriteQualified (std::ostream&, const Scope&, bool = false, Lexer::Symbol = Lexer::DoubleColon, Lexer::Symbol = Lexer::DoubleColon);
	std::ostream& WriteSerialized (std::ostream&, const Entity&);
	std::ostream& WriteSuffixed (std::ostream&, const Type&);
	std::ostream& WriteUnqualified (std::ostream&, const Entity&);
}

class ECS::CPP::Platform
{
public:
	explicit Platform (Layout&);

	Bits GetBits (const Type&) const;
	Size GetSize (const Type&) const;
	Alignment GetAlignment (const Type&) const;
	Alignment GetStackAlignment (const Type&) const;

	Type GetSigned (const Type&) const;
	Type GetUnsigned (const Type&) const;
	IntegerConversionRank GetRank (const Type&) const;

	bool IsFundamental (Alignment) const;

private:
	enum Model : IntegerConversionRank {
		#define TYPEMODEL(model, type, size) model,
		#include "cpp.def"
		Count
	};

	Layout& layout;
	const Size sizes[Count];
	const Alignment alignments[Count];

	Model GetIntegerModel (Size) const;
	Model GetModel (const Type&) const;
};

template <typename Structure>
struct ECS::CPP::List : std::list<Structure>
{
};

template <typename Structure>
struct ECS::CPP::Packed : Structure
{
	bool isPacked;
};

template <typename Structure>
struct ECS::CPP::Sequence : std::list<Structure>
{
};

struct ECS::CPP::Operator
{
	Lexer::Symbol symbol;
	bool bracketed;

	bool operator < (const Operator&) const;
	bool operator == (const Operator&) const;
};

struct ECS::CPP::Name
{
	enum Model {Literal, Operator, Conversion, Destructor, Identifier, Unreachable = 0};

	Model model;
	const TemplateArguments* templateArguments = nullptr;

	union
	{
		const String* suffixIdentifier;
		struct Operator operator_;
		const Type* conversion;
		const Type* destructor;
		const String* identifier;
	};

	explicit Name (const String*);
	explicit Name (const struct Identifier&);

	bool operator < (const Name&) const;
	bool operator == (const Name&) const;
	bool operator == (const String*) const;
};

struct ECS::CPP::DecltypeSpecifier
{
	Expression* expression;
};

struct ECS::CPP::ReferenceQualifier
{
	Lexer::Symbol symbol;

	explicit operator bool () const;
	bool operator < (const ReferenceQualifier&) const;
	bool operator == (const ReferenceQualifier&) const;
	bool operator != (const ReferenceQualifier&) const;
};

struct ECS::CPP::ConstVolatileQualifiers
{
	bool isConst, isVolatile;

	bool AreMoreQualifiedThan (const ConstVolatileQualifiers&) const;

	explicit operator bool () const;
	bool operator < (const ConstVolatileQualifiers&) const;
	bool operator == (const ConstVolatileQualifiers&) const;
	bool operator != (const ConstVolatileQualifiers&) const;

	ConstVolatileQualifiers& operator |= (const ConstVolatileQualifiers&);
};

struct ECS::CPP::Type
{
	enum Reference {None, LValue, RValue};
	enum Model {Undefined, Character, SignedCharacter, UnsignedCharacter, Character16, Character32, WideCharacter,
		Signed, Unsigned, Short, SignedShort, UnsignedShort, ShortInteger, SignedShortInteger, UnsignedShortInteger,
		Integer, SignedInteger, UnsignedInteger, Long, SignedLong, UnsignedLong, LongInteger, SignedLongInteger, UnsignedLongInteger,
		LongLong, SignedLongLong, UnsignedLongLong, LongLongInteger, SignedLongLongInteger, UnsignedLongLongInteger,
		Boolean, Float, Double, LongDouble, NullPointer, Void, Auto, Class, Enumeration, Array, Function, Pointer, MemberPointer, Alias, Decltype, Dependent,
		FirstCharacter = Character, LastCharacter = WideCharacter, FirstFundamental = Character, LastFundamental = NullPointer, Unreachable = 0};

	Model model = Undefined;
	Reference reference = None;
	const Entity* alias = nullptr;
	const DecltypeSpecifier* specifier = nullptr;
	ConstVolatileQualifiers qualifiers {false, false};

	union
	{
		struct Class* class_;
		struct Enumeration* enumeration;
		struct {const Type* elementType; CPP::Unsigned bound;} array;
		struct {const Type* returnType; Types* parameterTypes; LanguageLinkage linkage; ConstVolatileQualifiers constVolatileQualifiers; ReferenceQualifier referenceQualifier; bool variadic, noexcept_;} function;
		struct {const Type* baseType;} pointer;
		struct {const Type* baseType; const struct Class* class_;} memberPointer;
		struct {DecltypeSpecifier specifier;} decltype_;
	};

	Type (Model);
	Type () = default;
	Type (const Type*);
	Type (struct Array&);
	Type (struct Class&);
	Type (struct Enumeration&);
	Type (const Type&, CPP::Unsigned);
	Type (Type&, Types&, LanguageLinkage);
	Type (const Type*, const struct Class*);
	Type (struct Class&, const ConstVolatileQualifiers&);

	bool operator < (const Type&) const;
	bool operator == (const Type&) const;
	bool operator != (const Type&) const;

	bool IsReferenceRelatedTo (const Type&) const;
	bool IsReferenceCompatibleWith (const Type&) const;
};

struct ECS::CPP::Reference
{
	const Entity* entity; Value* value; Array* array;
	CPP::Signed offset;

	explicit operator bool () const;
	bool operator == (const Reference&) const;
};

struct ECS::CPP::Value
{
	enum Model {Invalid, Float, Signed, Boolean, Pointer, Unsigned, Dependent, Reference, MemberPointer, Unreachable = 0};

	Model model = Invalid;

	union
	{
		CPP::Float float_;
		CPP::Signed signed_;
		CPP::Boolean boolean;
		struct Reference pointer, reference;
		CPP::Unsigned unsigned_;
		const Storage* memberPointer;
	};

	Value (Array&);
	Value () = default;
	Value (CPP::Float);
	Value (CPP::Signed);
	Value (CPP::Boolean);
	Value (CPP::Unsigned);
	Value (const Entity&);
	Value (const Storage*);
	Value (std::nullptr_t, CPP::Signed = 0);
	Value (const struct Reference&, CPP::Signed);

	bool operator < (const Value&) const;
	bool operator > (const Value&) const;
	bool operator <= (const Value&) const;
	bool operator >= (const Value&) const;
	bool operator == (const Value&) const;
	bool operator != (const Value&) const;

	bool Represents (const Value&) const;
};

struct ECS::CPP::Array
{
	Values values;
	Size index = 0;
	Type elementType;
	const StringLiteral* stringLiteral = nullptr;

	explicit Array (const Type&);
	explicit Array (std::initializer_list<Value>);
};

struct ECS::CPP::Scope
{
	enum Model {Block, Class, Function, Namespace, Enumeration, FunctionPrototype, TemplateParameter, Unreachable = 0};

	Model model;
	Entities variables;
	Scope* enclosingScope;
	SymbolTable symbolTable;
	Size namespaces = 0, classes = 0, enumerations = 0;

	union
	{
		struct {Size bytes, variables, registers;} block;
		struct Class* class_;
		struct Function* function;
		struct Namespace* namespace_;
		struct Enumeration* enumeration;
	};

	Scope (Model, Scope*);
	Scope (const Scope&) = delete;
	Scope& operator = (const Scope&) = delete;

	void Use (struct Namespace&);
	bool Contains (const Scope&) const;
	void AddInline (struct Namespace&);
	bool LookupQualified (const Name&, Entities&) const;
	bool LookupUnqualified (const Name&, Entities&) const;

private:
	using Scopes = std::vector<const Scope*>;

	Scopes inlineNamespaces, usingNamespaces;

	void Lookup (const Name&, Entities&) const;
	bool LookupQualified (const Name&, Entities&, Scopes&) const;
	bool LookupUnqualified (const Name&, const Scope&, Entities&, Scopes&) const;
};

struct ECS::CPP::ClassKey
{
	Lexer::Symbol symbol;

	bool operator == (const ClassKey&) const;
	bool operator != (const ClassKey&) const;
};

struct ECS::CPP::Deprecation
{
	const Attribute* attribute = nullptr;
};

struct ECS::CPP::AlignmentSpecification
{
	Alignment value;
	const AttributeSpecifier* specifier = nullptr;

	AlignmentSpecification& operator &= (Alignment);
};

struct ECS::CPP::Class
{
	Scope scope;
	ClassKey key;
	Bits position = 0;
	Deprecation deprecation;
	Entity* entity; Size index;
	Size offset = 0, bytes = 0;
	AlignmentSpecification alignment;
	const Variable* firstDataMember = nullptr;
	bool isComplete = false, isAbstract = false, isNodisard = false;
	Function *defaultConstructor = nullptr, *destructor = nullptr;
	Function *copyConstructor = nullptr, *copyAssignment = nullptr;
	Function *moveConstructor = nullptr, *moveAssignment = nullptr;

	Class (Scope&, const ClassKey&, Entity*, Size, Platform&);
};

struct ECS::CPP::Label
{
	Size index;
	bool isAssembled = false;
	const Statement* statement;

	explicit Label (Size);
};

struct ECS::CPP::Entity
{
	enum Model {Alias, Class, Label, Function, Variable, Namespace, Parameter, Enumerator, Enumeration, NamespaceAlias, Unreachable = 0};

	Model model;
	Name name;
	Size uses = 0;
	Location location;
	Scope* enclosingScope;
	Deprecation deprecation;
	const TemplateParameters* templateParameters = nullptr;
	bool isDefined = false, isPredefined = false, maybeUnused = false;

	union
	{
		struct Type* alias;
		struct Class* class_;
		struct Label* label;
		struct Storage* storage;
		struct Function* function;
		struct Variable* variable;
		struct Namespace* namespace_;
		struct ParameterDeclaration* parameter;
		struct Enumerator* enumerator;
		struct Enumeration* enumeration;
	};

	Entity (Model, const Name&, const Location&, Scope&);

	bool Hides (const Entity&) const;
	bool Hides (Model, const Type&) const;
};

struct ECS::CPP::Capture
{
	bool byReference;
	Identifier* identifier;
	Initializer* initializer;
};

struct ECS::CPP::EnumKey
{
	Lexer::Symbol symbol;
};

struct ECS::CPP::Storage
{
	Type type;
	Entity* entity;
	LanguageLinkage linkage;
	AlignmentSpecification alignment;
	const Expression* origin = nullptr;
	const String *alias = nullptr, *group = nullptr;
	bool isConstexpr = false, isStatic = false, isInline = false, duplicable = false, replaceable = false, required = false;

	Storage (const Type&, Entity&, LanguageLinkage, Platform&);
	Storage (const Type&, Entity&, LanguageLinkage, const DeclarationSpecifiers&, Platform&);
};

struct ECS::CPP::EnumHead
{
	EnumKey key;
	AttributeSpecifiers* attributes;
	Identifier* identifier;
	TypeSpecifiers* base;
	Enumeration* enumeration;
};

struct ECS::CPP::Function : Storage
{
	Parameters parameters;
	Scope* scope = nullptr;
	Variable* func = nullptr;
	FunctionBody* body = nullptr;
	const FunctionPrototype* prototype = nullptr;
	bool isMain = false, isNoreturn = false, carriesDependency = false, isReturning = false, isPureVirtual = false, isDeleted = false, isDefaulted = false, isNodisard = false;
	Size declarations = 0, bytes = 0, variables = 0, registers = 0, labels = 0;

	Function (const Type&, Entity&, Platform&);
	Function (const Type&, Entity&, LanguageLinkage, const DeclarationSpecifiers&, bool, Platform&);
};

struct ECS::CPP::Variable : Storage
{
	Value value;
	Bits position = 0, length = 0;
	Size offset = 0, index = 0, register_ = 0;
	bool isRegister = false, isThreadLocal = false;

	Variable (const Type&, Entity&, LanguageLinkage, Platform&);
	Variable (const Type&, Entity&, LanguageLinkage, const DeclarationSpecifiers&, Platform&);
};

struct ECS::CPP::Attribute
{
	enum Model {Unspecified,
		#define ATTRIBUTE(attribute, name) attribute,
		#include "cpp.def"
		Count, Unreachable = 0,
	};

	Model model;
	Location location;
	Identifier *namespace_, *name;

	union
	{
		struct {Lexer::Tokens* tokens;} unspecified;
		struct {StringLiteral* stringLiteral;} deprecated, nodiscard, alias, group;
		struct {Expression* expression;} origin;
	};
};

struct ECS::CPP::ClassHead
{
	ClassKey key;
	AttributeSpecifiers* attributes;
	Identifier* identifier;
	bool isFinal;
	BaseSpecifiers* baseSpecifiers;
	Class* class_;
};

struct ECS::CPP::Condition
{
	Expression* expression;
	Declaration* declaration;
};

struct ECS::CPP::Namespace
{
	Scope scope;
	bool isInline;
	Deprecation deprecation;
	Entity* entity; Size index;
	Namespace* unnamed = nullptr;

	Namespace (Scope*, bool, Entity*, Size);
};

struct ECS::CPP::Parameter
{
	Size offset = 0, index = 0, register_ = 0;
	const ParameterDeclaration* declaration = nullptr;
	bool isRegister = false, carriesDependency = false;
};

struct ECS::CPP::Statement
{
	enum Model {Do, If, For, Try, Case, Goto, Null, Break, Label, While, Return, Switch, Default, Compound, Continue, CoReturn, Expression, Declaration, Unreachable = 0};

	Model model;
	Location location;
	AttributeSpecifiers* attributes;
	const Attribute* likelihood = nullptr;
	StatementBlock* enclosingBlock = nullptr;
	bool isReachable, breaks, continues;
	Statements::iterator iterator;

	union
	{
		Scope* scope;
		struct {Substatement* statement; struct Expression* condition;} do_;
		struct {Scope* scope; bool isConstexpr; Condition condition; Substatement *statement, *elseStatement;} if_;
		struct {Scope* scope; Statement* initStatement; Condition* condition; struct Expression* expression; Substatement* statement;} for_;
		struct {StatementBlock* block; ExceptionHandlers* handlers;} try_;
		struct {struct Expression* label; Size index;} case_;
		struct {Identifier* identifier; Entity* entity;} goto_, label;
		struct {const Attribute* fallthrough;} null;
		struct {Scope* scope; Condition condition; Substatement* statement;} while_;
		struct {struct Expression* expression;} return_, coReturn;
		struct {Scope* scope; Condition condition; Substatement* statement; CaseTable* caseTable; const Statement* defaultLabel;} switch_;
		struct {StatementBlock* block;} compound;
		struct Expression* expression;
		struct Declaration* declaration;
	};

	Statement () = default;
	explicit Statement (StatementBlock&);
};

struct ECS::CPP::Declarator
{
	enum Model {Name, Array, Pointer, Function, Reference, MemberPointer, Parenthesized, Unreachable = 0};

	Model model;
	Location location;
	Type type;

	union
	{
		struct {bool isPacked; Identifier* identifier; AttributeSpecifiers* attributes; Entity* entity;} name;
		struct {Declarator* declarator; Expression* expression; AttributeSpecifiers* attributes;} array;
		struct {AttributeSpecifiers* attributes; ConstVolatileQualifiers* qualifiers; Declarator* declarator;} pointer;
		struct {Declarator* declarator; FunctionPrototype *prototype;} function;
		struct {bool isRValue; AttributeSpecifiers* attributes; Declarator* declarator;} reference;
		struct {NestedNameSpecifier* specifier; AttributeSpecifiers* attributes; ConstVolatileQualifiers* qualifiers; Declarator* declarator;} memberPointer;
		struct {Declarator* declarator;} parenthesized;
	};
};

struct ECS::CPP::Enumerator
{
	Type type;
	Value value;
	Entity* entity;
	Deprecation deprecation;

	explicit Enumerator (Entity&);
};

struct ECS::CPP::Identifier
{
	enum Model {Name, Template, Destructor, LiteralOperator, OperatorFunction, ConversionFunction, Unreachable = 0};

	Model model;
	Location location;
	NestedNameSpecifier* nestedNameSpecifier;

	union
	{
		struct {const String* identifier;} name;
		struct {Identifier* identifier; TemplateArguments* arguments;} template_;
		struct {TypeSpecifier* specifier; const Type* type;} destructor;
		struct {Operator operator_;} operatorFunction;
		struct {const String* suffixIdentifier;} literalOperator;
		struct {TypeIdentifier* typeIdentifier;} conversionFunction;
	};

	Identifier () = default;
	Identifier (const Location&, const String*);
};

struct ECS::CPP::NestedNameSpecifier
{
	enum Model {Name, Global, Decltype, Unreachable = 0};

	Model model;
	Location location;
	Scope* scope;

	union
	{
		struct {Identifier* identifier; bool isTemplate;} name;
		struct {DecltypeSpecifier specifier;} decltype_;
	};
};

struct ECS::CPP::Expression
{
	enum Model {New, This, Cast, Comma, Throw, Unary, Braced, Binary, Delete, Lambda, Prefix, Alignof, Literal, Postfix, Noexcept, Addressof, ConstCast, Subscript, Typetrait, Assignment,
		Conversion, Identifier, SizeofPack, SizeofType, StaticCast, TypeidType, Conditional, DynamicCast, Indirection, FunctionCall, MemberAccess, Parenthesized, StringLiteral,
		ConstructorCall, ReinterpretCast, SizeofExpression, TypeidExpression, MemberIndirection, InlinedFunctionCall, BracedConstructorCall, Unreachable = 0, UnreachableConversion = 0};

	Model model;
	Location location;
	Type type;
	Value value;
	ValueCategory category;
	bool hasSideEffects, isPotentiallyThrowing, isBitField;

	union
	{
		struct {bool qualified; Expressions* placement; bool parenthesized; TypeIdentifier* typeIdentifier; Initializer* initializer;} new_;
		struct {Lexer::Symbol symbol; TypeIdentifier* typeIdentifier; Expression* expression;} cast;
		struct {Expression* left; Expression* right;} comma;
		struct {Expression* expression;} throw_, noexcept_, addressof, indirection, parenthesized, sizeofExpression, typeidExpression;
		struct {Operator operator_; Expression* operand;} unary;
		struct {Expressions* expressions;} braced;
		struct {Expression* left; Operator operator_; Expression* right;} binary, assignment;
		struct {bool qualified, bracketed; Expression* expression;} delete_;
		struct {CaptureDefault* default_; Captures* captures; LambdaDeclarator* declarator; StatementBlock* block;} lambda;
		struct {Operator operator_; Expression* expression;} prefix, postfix;
		struct {TypeIdentifier* typeIdentifier;} alignof_, sizeofType, typeidType;
		struct {Lexer::BasicToken token;} literal;
		struct {Expression *left, *right, *array, *index;} subscript;
		struct {struct StringLiteral* stringLiteral; TypeIdentifier* typeIdentifier; Predicate predicate;} typetrait;
		struct {Expression* expression; enum Conversion model;} conversion;
		struct {struct Identifier* identifier; Entity* entity;} identifier;
		struct {struct Identifier* identifier;} sizeofPack;
		struct {Expression *condition, *left, *right;} conditional;
		struct {Expression* expression; Expressions* arguments; Function* function; bool isConstexpr;} functionCall;
		struct {Expression* expression; Lexer::Symbol symbol; bool isTemplate; struct Identifier* identifier; Entity* entity;} memberAccess;
		struct StringLiteral* stringLiteral;
		struct {TypeSpecifier* specifier; Expressions* expressions;} constructorCall;
		struct {Expression* expression; Lexer::Symbol symbol; Expression* member;} memberIndirection;
		struct {Expression* expression; Scope* scope; FunctionBody* body;} inlinedFunctionCall;
		struct {TypeSpecifier* specifier; Expression* expression;} bracedConstructorCall;
	};

	Expression () = default;
	explicit Expression (struct Identifier&);
};

struct ECS::CPP::AccessSpecifier
{
	Lexer::Symbol symbol;
};

struct ECS::CPP::Declaration
{
	enum Model {Asm, Alias, Empty, Using, Access, Member, Simple, Template, Attribute, Condition, OpaqueEnum, UsingDirective, StaticAssertion,
		FunctionDefinition, NamespaceDefinition, LinkageSpecification, ExplicitInstantiation, ExplicitSpecialization, NamespaceAliasDefinition, Unreachable = 0};

	Model model;
	Location location;

	union
	{
		struct {AttributeSpecifiers* attributes; DeclarationSpecifiers* specifiers;} basic;
		struct {AttributeSpecifiers* attributes; StringLiteral* stringLiteral; const struct Attribute *code, *noreturn_; Entities* entities;} asm_;
		struct {Identifier* identifier; AttributeSpecifiers* attributes; TypeIdentifier* typeIdentifier; Entity* entity;} alias;
		struct {UsingDeclarators* declarators;} using_;
		struct {AccessSpecifier specifier;} access;
		struct {AttributeSpecifiers* attributes; DeclarationSpecifiers* specifiers; MemberDeclarators* declarators;} member;
		struct {AttributeSpecifiers* attributes; DeclarationSpecifiers* specifiers; InitDeclarators* declarators;} simple;
		struct {TemplateParameters* parameters; Declaration* declaration; Scope* scope;} template_;
		struct {AttributeSpecifiers* specifiers;} attribute;
		struct {AttributeSpecifiers* attributes; DeclarationSpecifiers* specifiers; Declarator* declarator; Initializer* initializer; Entity* entity;} condition;
		struct {EnumHead head;} opaqueEnum;
		struct {AttributeSpecifiers* attributes; Identifier* identifier; Namespace* namespace_;} usingDirective;
		struct {Expression* expression; StringLiteral* stringLiteral;} staticAssertion;
		struct {AttributeSpecifiers* attributes; DeclarationSpecifiers* specifiers; Declarator* declarator; VirtualSpecifiers* virtualSpecifiers; Lexer::Tokens* inlinedBody; FunctionBody* body; Entity* entity;} functionDefinition;
		struct {bool isInline; AttributeSpecifiers* attributes; Identifier* identifier; Declarations* body; Namespace* namespace_;} namespaceDefinition;
		struct {StringLiteral* stringLiteral; Declaration* declaration; Declarations* declarations; LanguageLinkage linkage;} linkageSpecification;
		struct {bool isExtern; Declaration* declaration;} explicitInstantiation;
		struct {Declaration* declaration;} explicitSpecialization;
		struct {Identifier* identifier; Identifier* name; Namespace* namespace_;} namespaceAliasDefinition;
	};
};

struct ECS::CPP::Enumeration
{
	Scope scope;
	EnumKey key;
	Deprecation deprecation;
	Entity* entity; Size index;
	AlignmentSpecification alignment;
	const Enumerator* previousEnumerator = nullptr;
	bool isNodisard = false;
	Type underlyingType;

	Enumeration (Scope&, const EnumKey&, Entity*, Size, const Type&, Platform&);
};

struct ECS::CPP::Initializer
{
	Location location;
	Expressions expressions;
	bool assignment = false, braced = false;
};

struct ECS::CPP::FunctionBody
{
	enum Model {Try, Delete, Default, Regular, Unreachable = 0};

	Model model;
	Location location;
	bool isExiting;

	union
	{
		struct {MemberInitializers* initializers; StatementBlock* block; ExceptionHandlers* handlers;} try_;
		struct {MemberInitializers* initializers; StatementBlock* block;} regular;
	};
};

struct ECS::CPP::StatementBlock
{
	Statements statements;
	Statement* enclosingStatement;
	Scope* scope;
	bool isExiting;
};

struct ECS::CPP::Substatement : StatementBlock
{
	Location location;
	AttributeSpecifiers* attributes;
	bool isCompound;
};

struct ECS::CPP::StringLiteral
{
	Location location;
	Lexer::Symbol symbol;
	Lexer::Tokens tokens;
	const String* suffix = nullptr;

	StringLiteral () = default;
	StringLiteral (const Location&, Lexer::Symbol, const WString*);

	bool operator < (const StringLiteral&) const;
};

struct ECS::CPP::TypeSpecifier
{
	enum Model {Enum, Class, Simple, Decltype, Typename, TypeName, ConstVolatileQualifier, Unreachable = 0};

	Model model;
	Location location;

	union
	{
		struct {EnumHead head; EnumeratorDefinitions* enumerators; bool isDefinition;} enum_;
		struct {ClassHead head; Declarations* members; bool isDefinition;} class_;
		struct {Lexer::Symbol type;} simple;
		struct {DecltypeSpecifier specifier;} decltype_;
		struct {Identifier* identifier; const Entity* entity;} typename_, typeName;
		struct {Lexer::Symbol qualifier;} constVolatile;
	};
};

struct ECS::CPP::BaseSpecifier
{
	AttributeSpecifiers* attributes;
	bool isVirtual;
	AccessSpecifier* accessSpecifier;
	TypeSpecifier typeSpecifier;
};

struct ECS::CPP::InitDeclarator
{
	Declarator* declarator;
	Initializer* initializer;
	const DeclarationSpecifiers* specifiers;
	Entity* entity = nullptr;
	bool isDeclaration;
};

struct ECS::CPP::TypeSpecifiers : Sequence<TypeSpecifier>
{
	AttributeSpecifiers* attributes;
	Type type;
};

struct ECS::CPP::TypeIdentifier
{
	TypeSpecifiers specifiers;
	Declarator* declarator;
	Type type;
};

struct ECS::CPP::TranslationUnit : StructurePool
{
	Source source;
	Declarations declarations;
	Namespace global;
	std::map<Name, Entity*> globals;
	std::map<StringLiteral, Array> stringLiterals;

	explicit TranslationUnit (const Source&);
};

struct ECS::CPP::UsingDeclarator
{
	bool isTypename;
	Identifier identifier;
};

struct ECS::CPP::LambdaDeclarator
{
	ParameterDeclarations parameterDeclarations;
	DeclarationSpecifiers* specifiers;
	NoexceptSpecifier* noexceptSpecifier;
	AttributeSpecifiers* attributes;
	TypeIdentifier* trailingReturnType;
};

struct ECS::CPP::MemberDeclarator : InitDeclarator
{
	VirtualSpecifiers* virtualSpecifiers;
	Lexer::Tokens inlinedInitializer;
	Expression* expression;
};

struct ECS::CPP::TemplateArgument
{
	enum Model {Expression, TypeIdentifier, Unreachable = 0};

	Model model;
	Location location;

	union
	{
		struct Expression* expression;
		struct TypeIdentifier* typeIdentifier;
	};

	bool operator < (const TemplateArgument&) const;
	bool operator == (const TemplateArgument&) const;
};

struct ECS::CPP::FunctionPrototype
{
	ParameterDeclarations parameterDeclarations;
	ConstVolatileQualifiers* constVolatileQualifiers;
	ReferenceQualifier* referenceQualifier;
	NoexceptSpecifier* noexceptSpecifier;
	AttributeSpecifiers* attributes;
	TypeIdentifier* trailingReturnType;
	Scope* scope = nullptr;
};

struct ECS::CPP::MemberInitializer
{
	TypeSpecifier specifier;
	Initializer initializer;
};

struct ECS::CPP::TypeParameterKey
{
	Lexer::Symbol symbol;
};

struct ECS::CPP::TemplateParameter
{
	enum Model {Type, Template, Declaration, Unreachable = 0};

	Model model;
	Location location;

	union
	{
		struct {TypeParameterKey key; bool isPacked; Identifier* identifier; TypeIdentifier* default_;} type;
		struct {TemplateParameters* parameters; TypeParameterKey key; bool isPacked; Identifier* identifier; Identifier* default_;} template_;
		struct ParameterDeclaration* declaration;
	};
};

struct ECS::CPP::VirtualSpecifiers
{
	bool final = false, override = false;
};

struct ECS::CPP::AttributeSpecifier
{
	enum Model {Attributes, AlignasType, AlignasExpression, Unreachable = 0};

	Model model;
	Location location;
	Alignment alignment;

	union
	{
		struct {Identifier* usingPrefix; CPP::Attributes* list;} attributes;
		struct {Packed<TypeIdentifier>* typeIdentifier;} alignasType;
		struct {Packed<Expression>* expression;} alignasExpression;
	};
};

struct ECS::CPP::DeclarationSpecifier
{
	enum Model {Type, Friend, Inline, Typedef, Function, Constexpr, StorageClass, Unreachable = 0};

	Model model;
	Location location;

	union
	{
		struct {TypeSpecifier* specifier;} type;
		struct {Lexer::Symbol specifier;} function, storageClass;
	};
};

struct ECS::CPP::EnumeratorDefinition
{
	Identifier identifier;
	AttributeSpecifiers* attributes;
	Expression* expression;
	Enumerator* enumerator;
};

struct ECS::CPP::DeclarationSpecifiers : Sequence<DeclarationSpecifier>
{
	AttributeSpecifiers* attributes = nullptr;
	Lexer::Symbol storageClass = Lexer::Eof; bool isThreadLocal = false;
	bool isVirtual = false, isExplicit = false;
	bool isFriend = false, isTypedef = false, isConstexpr = false, isInline = false;
	Type type;
};

struct ECS::CPP::ExceptionDeclaration
{
	AttributeSpecifiers* attributes;
	TypeSpecifiers specifiers;
	Declarator* declarator;
};

struct ECS::CPP::ExceptionHandler
{
	ExceptionDeclaration declaration;
	StatementBlock block;
};

struct ECS::CPP::ParameterDeclaration
{
	Location location;
	AttributeSpecifiers* attributes;
	DeclarationSpecifiers specifiers;
	Declarator* declarator;
	Expression* initializer;
	Type type;
	Entity* entity = nullptr;
	Parameter* parameter = nullptr;
	const Attribute* carriesDependency = nullptr;
	const Attribute* maybeUnused = nullptr;
	const Attribute* register_ = nullptr;
};

struct ECS::CPP::NoexceptSpecifier
{
	Location location;
	Expression* expression;
	bool throw_;
};

inline bool ECS::CPP::IsIncomplete (const Type& type)
{
	return !IsComplete (type);
}

inline bool ECS::CPP::Type::operator != (const Type& other) const
{
	return !(*this == other);
}

inline bool ECS::CPP::Value::operator != (const Value& other) const
{
	return !(*this == other);
}

inline bool ECS::CPP::Value::operator > (const Value& other) const
{
	return other < *this;
}

inline bool ECS::CPP::Value::operator <= (const Value& other) const
{
	return !(other < *this);
}

inline bool ECS::CPP::Value::operator >= (const Value& other) const
{
	return !(*this < other);
}

inline bool ECS::CPP::ClassKey::operator != (const ClassKey& other) const
{
	return !(*this == other);
}

inline bool ECS::CPP::ReferenceQualifier::operator != (const ReferenceQualifier& other) const
{
	return !(*this == other);
}

inline bool ECS::CPP::ConstVolatileQualifiers::operator != (const ConstVolatileQualifiers& other) const
{
	return !(*this == other);
}

#endif // ECS_CPP_HEADER_INCLUDED

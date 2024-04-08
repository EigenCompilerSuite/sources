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

#ifndef ECS_OBERON_HEADER_INCLUDED
#define ECS_OBERON_HEADER_INCLUDED

#include "oblexer.hpp"
#include "rangeset.hpp"
#include "structurepool.hpp"

#include <map>
#include <vector>

namespace ECS
{
	class Layout;
}

namespace ECS::Oberon
{
	class Platform;

	struct Annotation;
	struct Body;
	struct Case;
	struct Complex;
	struct Declaration;
	struct Definition;
	struct Elsif;
	struct Expression;
	struct Guard;
	struct Identifier;
	struct Module;
	struct Object;
	struct QualifiedIdentifier;
	struct Scope;
	struct Set;
	struct Signature;
	struct Statement;
	struct Type;
	struct Value;

	using Alignment = Size;
	using Cases = std::vector<Case>;
	using Declarations = std::vector<Declaration>;
	using Definitions = std::vector<Definition>;
	using Elsifs = std::vector<Elsif>;
	using Expressions = std::vector<Expression>;
	using Guards = std::vector<Guard>;
	using Labels = RangeSet<Value>;
	using Objects = std::vector<Object>;
	using Operator = Lexer::Symbol;
	using Statements = std::vector<Statement>;

	bool HasDynamicType (const Declaration&);
	bool HasDynamicType (const Expression&);
	bool HasDynamicType (const Type&);
	bool IsAbstract (const Declaration&);
	bool IsAbstract (const Type&);
	bool IsAlias (const Type&);
	bool IsAllocatable (const Type&);
	bool IsAnonymous (const Type&);
	bool IsAny (const Type&);
	bool IsAny (const Value&);
	bool IsArithmetic (const Type&);
	bool IsArray (const Type&);
	bool IsAssembly (const Declaration&);
	bool IsBasic (const Type&);
	bool IsBoolean (Operator);
	bool IsBoolean (const Type&);
	bool IsBoolean (const Value&);
	bool IsByte (const Type&);
	bool IsCall (const Expression&);
	bool IsCharacter (const Type&);
	bool IsCharacterArray (const Type&);
	bool IsComplex (const Type&);
	bool IsComplex (const Value&);
	bool IsConstant (const Declaration&);
	bool IsConstant (const Expression&);
	bool IsConstant (const Expressions&);
	bool IsDereferencable (const Type&);
	bool IsDereference (const Expression&);
	bool IsEmptyLoop (const Statement&);
	bool IsEmptyString (const Value&);
	bool IsExplicitlyTyped (const Expression&);
	bool IsExported (const Definition&);
	bool IsExternal (const Declaration&);
	bool IsFalse (const Expression&);
	bool IsField (const Declaration&);
	bool IsFinal (const Declaration&);
	bool IsFinal (const Type&);
	bool IsForward (const Declaration&);
	bool IsGeneric (const Expression&);
	bool IsGeneric (const Expressions&);
	bool IsGeneric (const Module&);
	bool IsGeneric (const Type&);
	bool IsGeneric (const Value&);
	bool IsGenericParameter (const Declaration&);
	bool IsGlobal (const Scope&);
	bool IsIdentifier (const Expression&);
	bool IsIdentifier (const Type&);
	bool IsImport (const Declaration&);
	bool IsIndex (const Expression&);
	bool IsInteger (const Type&);
	bool IsLiteral (const Expression&);
	bool IsLocal (const Scope&);
	bool IsModule (const Declaration&);
	bool IsModule (const Scope&);
	bool IsModule (const Value&);
	bool IsNil (const Type&);
	bool IsNil (const Value&);
	bool IsNumeric (const Type&);
	bool IsObject (const Declaration&);
	bool IsObject (const Expression&);
	bool IsOpenArray (const Type&);
	bool IsParameter (const Declaration&);
	bool IsParameterized (const Module&);
	bool IsParenthesized (const Expression&);
	bool IsPointer (const Type&);
	bool IsPointer (const Value&);
	bool IsPredeclared (const Declaration&);
	bool IsProcedure (const Declaration&);
	bool IsProcedure (const Scope&);
	bool IsProcedure (const Type&);
	bool IsProcedure (const Value&);
	bool IsProcedureCall (const Statement&);
	bool IsProcedureType (const Declaration&);
	bool IsPromotion (const Expression&);
	bool IsQualified (const Expression&);
	bool IsQualified (const QualifiedIdentifier&);
	bool IsRange (const Expression&);
	bool IsReachable (const Body&);
	bool IsReachable (const Scope&);
	bool IsReachable (const Statement&);
	bool IsReadOnly (const Declaration&, const Module&);
	bool IsReadOnly (const Expression&);
	bool IsReadOnlyParameter (const Declaration&);
	bool IsReal (const Type&);
	bool IsReceiver (const Declaration&);
	bool IsReceiver (const Expression&);
	bool IsRecord (const Declaration&);
	bool IsRecord (const Scope&);
	bool IsRecord (const Type&);
	bool IsRecord (const Value&);
	bool IsRecordPointer (const Type&);
	bool IsRedefined (const Declaration&);
	bool IsScalar (const Type&);
	bool IsSelectable (const Type&);
	bool IsSelector (const Expression&);
	bool IsSet (const Type&);
	bool IsSet (const Value&);
	bool IsSignature (const Scope&);
	bool IsSigned (const Type&);
	bool IsSigned (const Value&);
	bool IsSimple (const Type&);
	bool IsStorage (const Declaration&);
	bool IsString (const Type&);
	bool IsString (const Value&);
	bool IsStringable (const Type&);
	bool IsStructured (const Type&);
	bool IsSuper (const Expression&);
	bool IsTerminating (const Body&);
	bool IsTerminating (const Declaration&, const Body&);
	bool IsTerminating (const Expression&, const Body&);
	bool IsTraceable (const Type&);
	bool IsTrue (const Expression&);
	bool IsType (const Declaration&);
	bool IsType (const Expression&);
	bool IsType (const Value&);
	bool IsTypeBound (const Declaration&);
	bool IsTypeBound (const Type&);
	bool IsTypeGuardCall (const Expression&);
	bool IsUndefined (const Declaration&);
	bool IsUnsigned (const Type&);
	bool IsUnsigned (const Value&);
	bool IsUsed (const Declaration&);
	bool IsValid (const Type&);
	bool IsValid (const Value&);
	bool IsVariable (const Declaration&);
	bool IsVariable (const Expression&);
	bool IsVariableOpenByteArrayParameter (const Declaration&);
	bool IsVariableParameter (const Declaration&);
	bool IsVariablePointer (const Type&);
	bool IsVisible (const Declaration&, const Module&);
	bool IsZero (const Value&);
	bool NeedsInitialization (const Scope&);
	bool NeedsInitialization (const Type&);
	bool NeedsTypeDescriptor (const Declaration&);
	bool NeedsTypeDescriptor (const Type&);
	bool OmitsResultValue (const Declaration&);

	auto CountDimensions (const Type&) -> Size;
	auto CountOpenDimensions (const Type&) -> Size;
	auto GetArgument (const Expression&, Size) -> Expression&;
	auto GetArray (const Type&, Size) -> const Type&;
	auto GetFilename (const QualifiedIdentifier&) -> Source;
	auto GetModule (const Scope&) -> Module&;
	auto GetOptionalArgument (const Expression&, Size) -> Expression*;
	auto GetParameter (const Expression&, const Expression&) -> Declaration&;
	auto GetRange (const Expression&) -> Range<Value>;
	auto GetVariable (const Expression&) -> Declaration*;

	std::ostream& operator << (std::ostream&, const Complex&);
	std::ostream& operator << (std::ostream&, const Declaration&);
	std::ostream& operator << (std::ostream&, const Declarations&);
	std::ostream& operator << (std::ostream&, const Definition&);
	std::ostream& operator << (std::ostream&, const Definitions&);
	std::ostream& operator << (std::ostream&, const Elsif&);
	std::ostream& operator << (std::ostream&, const Expression&);
	std::ostream& operator << (std::ostream&, const Expressions&);
	std::ostream& operator << (std::ostream&, const Guard&);
	std::ostream& operator << (std::ostream&, const Identifier&);
	std::ostream& operator << (std::ostream&, const QualifiedIdentifier&);
	std::ostream& operator << (std::ostream&, const Scope&);
	std::ostream& operator << (std::ostream&, const Signature&);
	std::ostream& operator << (std::ostream&, const Statement&);
	std::ostream& operator << (std::ostream&, const Type&);
	std::ostream& operator << (std::ostream&, const Value&);

	std::ostream& WriteFormatted (std::ostream&, const Declaration&);
	std::ostream& WriteFormatted (std::ostream&, const Type&);
	std::ostream& WriteQualified (std::ostream&, const Declaration&);
	std::ostream& WriteQualified (std::ostream&, const QualifiedIdentifier&);
	std::ostream& WriteQualified (std::ostream&, const Scope&);
	std::ostream& WriteSerialized (std::ostream&, const Type&);
}

struct ECS::Oberon::Annotation
{
	Position position;
	String string;
};

struct ECS::Oberon::Identifier
{
	Position position;
	String string;

	Identifier () = default;
	explicit Identifier (const char*);
};

struct ECS::Oberon::QualifiedIdentifier
{
	Identifier* name;
	QualifiedIdentifier* parent;
	Declaration* declaration;

	bool operator == (const QualifiedIdentifier&) const;
	bool operator != (const QualifiedIdentifier&) const;
};

struct ECS::Oberon::Signature
{
	Declaration* receiver;
	Declarations* parameters;
	Type* result;
	Scope* scope;
	Declaration* parent;

	bool Matches (const Signature&) const;
	bool IsIdenticalTo (const Signature&) const;
};

struct ECS::Oberon::Type
{
	enum Model {Void, Boolean, Character, Signed, Unsigned, Real, Complex, Set, Byte, Any, String, Nil, Array, Record, Pointer, Procedure, Module, Generic, Identifier, Unreachable = 0};

	Model model;
	Position position;
	QualifiedIdentifier* identifier;

	union
	{
		struct {Size size;} boolean, character, signed_, unsigned_, integer, real, complex, set, basic, byte, any;
		struct {Expression* length; Type* elementType;} array;
		struct {Type* baseType; Declarations* declarations; Scope* scope; Declaration* declaration; Size level, procedures, abstractions; bool isAbstract, isFinal, isReachable;} record;
		struct {Type* baseType; bool isVariable, isReadOnly;} pointer;
		struct {Signature signature;} procedure;
	};

	Type () = default;
	Type (Type&, bool);
	explicit Type (const Signature&);
	Type (Model, Size, QualifiedIdentifier&);
	Type (const Position&, QualifiedIdentifier&);

	bool Extends (const Type&) const;
	bool Includes (const Type&) const;
	bool IsArrayCompatibleWith (const Type&) const;
	bool IsEqualTo (const Type&) const;
	bool IsSameAs (const Type&) const;
	bool Names (const Type&) const;

	void Initialize (Objects&, bool) const;
};

struct ECS::Oberon::Complex
{
	Real real, imag;

	Complex operator + () const;
	Complex operator - () const;

	Complex operator + (Complex) const;
	Complex operator - (Complex) const;
	Complex operator * (Complex) const;
	Complex operator / (Complex) const;

	bool operator == (Complex) const;
	bool operator != (Complex) const;
};

struct ECS::Oberon::Set
{
	using Element = Unsigned;
	using Mask = Unsigned;

	struct Range {Element lower, upper;};

	Mask mask;

	Set operator + () const;
	Set operator - () const;

	Set operator + (Set) const;
	Set operator - (Set) const;
	Set operator * (Set) const;
	Set operator / (Set) const;

	bool operator == (Set) const;
	bool operator != (Set) const;

	Set& operator += (Range);
	Set& operator += (Element);
	Set& operator -= (Element);

	bool operator [] (Element) const;

	static Mask Convert (Element);
	static Mask Convert (Range);
};

struct ECS::Oberon::Value
{
	Type::Model model = Type::Void;

	union
	{
		Boolean boolean;
		Character character;
		Signed signed_;
		Unsigned unsigned_;
		Real real;
		Complex complex;
		Set set;
		Byte byte;
		Any any;
		const String* string;
		Objects* array;
		struct {const Type* type; Objects* fields;} record;
		Object* pointer;
		const Declaration* procedure;
		Declaration* module;
		Type* type;
	};

	Value () = default;
	Value (Boolean);
	Value (Character);
	Value (Signed);
	Value (Unsigned);
	Value (Real);
	Value (Complex);
	Value (Set);
	Value (Byte);
	Value (Any);
	Value (const String&);
	Value (std::nullptr_t);
	Value (Object*);
	Value (const Declaration*);
	Value (Declaration&);
	Value (Type&);

	Value& operator ++ ();

	bool operator < (const Value&) const;
	bool operator > (const Value&) const;
	bool operator <= (const Value&) const;
	bool operator >= (const Value&) const;
	bool operator == (const Value&) const;
	bool operator != (const Value&) const;
};

struct ECS::Oberon::Object : Value
{
	Objects elements;

	Object () = default;
	Object (const Value&);
	explicit Object (const Type&, bool);
	explicit Object (Size, const String&);
	explicit Object (Size, const Object&);

	Object& operator = (const Value&);
	Object& operator = (const String&);

	static void Initialize (Objects&, const Declarations&, bool);
};

struct ECS::Oberon::Scope
{
	enum Model {Global, Module, Signature, Procedure, Record, Unreachable = 0};

	Model model;
	Scope* parent = nullptr;
	Size size = 0, count = 0, alignment = 1;
	std::map<String, Declaration*> objects;
	bool needsInitialization = false;

	union
	{
		QualifiedIdentifier* identifier;
		struct Module* module;
		struct Signature* signature;
		Declaration* procedure;
		Type* record;
	};

	Scope (QualifiedIdentifier*);
	Scope (struct Module&, Scope&);
	Scope (struct Signature&, Scope&);
	Scope (Type&, Scope&);

	void Initialize (Objects&, bool) const;

	Declaration* Lookup (const Identifier&, const struct Module&) const;
	Declaration* LookupImport (const Scope&) const;

	bool BelongsTo (const struct Module&) const;
};

struct ECS::Oberon::Expression
{
	enum Model {Set, Call, Index, Super, Unary, Binary, Literal, Selector, Promotion, TypeGuard, Conversion, Identifier, Dereference, Parenthesized, Unreachable = 0};

	Model model;
	Position position;
	Type* type;
	Value value;
	bool isVariable, isReadOnly;

	union
	{
		struct {Expression* identifier; Expressions* elements;} set;
		struct {Expression* designator; Expressions* arguments; Size temporary;} call;
		struct {Expression* designator; Expression* expression;} index, conversion;
		struct {Expression* designator; Declaration* declaration;} super;
		struct {Operator operator_; Expression* operand;} unary;
		struct {Expression* left; Operator operator_; Expression* right;} binary;
		struct Lexer::Literal* literal;
		struct {Expression* designator; struct Identifier* identifier; Declaration* declaration;} selector;
		struct {Expression* expression;} promotion, dereference, parenthesized;
		struct {Expression* designator; Expression* identifier;} typeGuard;
		struct QualifiedIdentifier identifier;
	};

	Expression () = default;
	Expression (Type&, const Value&);

	bool operator == (const Expression&) const;
	bool operator != (const Expression&) const;

	bool Calls (const Declaration&) const;
	bool CallsCode (const Platform&) const;
	bool IsAssignmentCompatibleWith (const Type&) const;
	bool IsExpressionCompatibleWith (const Type&) const;
	bool IsParameterCompatibleWith (const Declaration&) const;
};

struct ECS::Oberon::Definition
{
	Position position;
	Identifier name;
	bool isExported = false;

	Definition () = default;
	Definition (const char*, bool);
};

struct ECS::Oberon::Declaration : Definition
{
	enum Model {Import, Constant, Type, Variable, Procedure, Parameter, Unreachable = 0};

	Model model;
	Annotation annotation;
	Scope* scope;
	Size uses = 0;

	union
	{
		struct {Identifier* alias; Expressions* expressions; QualifiedIdentifier identifier; Scope* scope;} import;
		struct {Expression* expression;} constant;
		struct Type* type;
		struct {struct Type* type; Size index, offset; Expression* external; Declaration* definition; bool isForward, isReadOnly;} variable;
		struct {struct Type* type; Size index, offset; Expression* external; Declaration* definition; bool isForward, isAbstract, isFinal; Signature signature; Declarations* declarations; Body* body; Declaration* result;} procedure;
		struct {struct Type* type; Size index, offset; Expression* external; Declaration* definition; bool isForward;} storage;
		struct {struct Type* type; Size index, offset; bool isVariable, isReadOnly;} parameter;
		struct {struct Type* type; Size index, offset;} object;
	};

	Declaration () = default;
	Declaration (Model, const char*, Scope&);
	Declaration (const Definition&, Expression&);
	Declaration (const Definition&, struct Type&);

	bool IsIdenticalTo (const Declaration&) const;
	bool Matches (const Declaration&) const;
};

struct ECS::Oberon::Statement
{
	enum Model {If, For, Case, Exit, Loop, With, While, Repeat, Return, Assignment, ProcedureCall, Unreachable = 0};

	Model model;
	Position position;
	bool isReachable;

	union
	{
		struct {Expression* condition; Statements* thenPart; Elsifs* elsifs; Statements* elsePart;} if_;
		struct {Expression* variable; Expression* begin; Expression* end; Expression* step; Statements* statements; Size temporary;} for_;
		struct {Expression* expression; Cases* cases; Statements* elsePart; Labels* labels;} case_;
		struct {Statement* statement;} exit;
		struct {Statements* statements; bool isExiting;} loop;
		struct {Guards* guards; Statements* elsePart;} with;
		struct {Expression* condition; Statements* statements;} while_, repeat;
		struct {Expression* expression;} return_;
		struct {Expression* designator; Expression* expression;} assignment;
		struct {Expression* designator;} procedureCall;
	};
};

struct ECS::Oberon::Elsif
{
	Position position;
	Expression condition;
	Statements statements;
};

struct ECS::Oberon::Case
{
	Expressions labels;
	Statements statements;
};

struct ECS::Oberon::Guard
{
	Position position;
	Expression expression;
	Type type;
	Statements statements;
};

struct ECS::Oberon::Body
{
	struct {Position position;} begin, end;
	Statements statements;
	bool isReachable, hasReturn = false, hasCode = false;
};

struct ECS::Oberon::Module : StructurePool
{
	Source source;
	QualifiedIdentifier identifier;
	Definitions* definitions;
	Expressions* expressions;
	Declarations parameters, declarations;
	Body* body;
	Annotation annotation, documentation;
	std::vector<Type*> anonymousTypes;
	Scope* scope;

	explicit Module (const Source&);
	Module (const Module&, Expressions&);

	Size GetIndex (const Type&) const;
	bool Imports (const QualifiedIdentifier&) const;

private:
	void Copy (Body&);
	void Copy (Case&);
	void Copy (Declaration&);
	void Copy (Declarations&);
	void Copy (Definition&) {}
	void Copy (Elsif&);
	void Copy (Expression&);
	void Copy (Guard&);
	void Copy (Identifier&) {}
	void Copy (QualifiedIdentifier&);
	void Copy (Signature&);
	void Copy (Statement&);
	void Copy (Type&);

	template <typename Structure> void Copy (Structure*&);
	template <typename Structure> void Copy (std::vector<Structure>&);
};

class ECS::Oberon::Platform
{
	Layout& layout;

public:
	Scope global, system;
	#define DECLARATION(model, scope, declaration, name) Declaration scope##declaration;
	#include "oberon.def"
	#define TYPE(scope, type, name, model, size) QualifiedIdentifier scope##type##Identifier; Type scope##type##Type;
	#include "oberon.def"
	#define CONSTANT(scope, constant, name, type, value) Expression scope##constant##Expression;
	#include "oberon.def"

	explicit Platform (Layout&);

	Size GetSize (const Type&) const;
	Size GetSize (const Declaration&) const;

	Alignment GetAlignment (const Type&) const;
	Alignment GetStackAlignment (const Type&) const;
	Alignment GetAlignment (const Declaration&) const;

	Type& GetCanonical (Type&);

	Type& GetComplex (Size);
	Type& GetReal (Size);
	Type& GetSet (Size);
	Type& GetSigned (Size);
	Type& GetUnsigned (Size);

	Type& GetType (Complex);
	Type& GetType (Real);
	Type& GetType (Set);
	Type& GetType (Signed);
	Type& GetType (Unsigned);
	Type& GetType (const Value&);

	Scope* GetScope (const QualifiedIdentifier&);

private:
	Identifier systemName;
	QualifiedIdentifier systemIdentifier;

	void InitializeConstant (Declaration&, Expression&);
	void InitializeType (Declaration&, Type&);
	void InitializeProcedure (Declaration&);
};

namespace ECS::Oberon
{
	std::ostream& operator << (std::ostream&, Type::Model);
	std::ostream& operator << (std::ostream&, Declaration::Model);
}

inline bool ECS::Oberon::Complex::operator != (const Complex other) const
{
	return !(*this == other);
}

inline bool ECS::Oberon::Set::operator != (const Set other) const
{
	return !(*this == other);
}

inline bool ECS::Oberon::Value::operator != (const Value& other) const
{
	return !(*this == other);
}

inline bool ECS::Oberon::Value::operator > (const Value& other) const
{
	return other < *this;
}

inline bool ECS::Oberon::Value::operator <= (const Value& other) const
{
	return !(other < *this);
}

inline bool ECS::Oberon::Value::operator >= (const Value& other) const
{
	return !(*this < other);
}

inline bool ECS::Oberon::Expression::operator != (const Expression& other) const
{
	return !(*this == other);
}

inline bool ECS::Oberon::QualifiedIdentifier::operator != (const QualifiedIdentifier& other) const
{
	return !(*this == other);
}

#endif // ECS_OBERON_HEADER_INCLUDED

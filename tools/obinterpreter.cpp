// Oberon interpreter
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

#include "charset.hpp"
#include "environment.hpp"
#include "error.hpp"
#include "format.hpp"
#include "oberon.hpp"
#include "obinterpreter.hpp"
#include "strdiagnostics.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cmath>
#include <new>
#include <unordered_map>

using namespace ECS;
using namespace Oberon;

using Evaluator =
	#include "obevaluator.hpp"

using Context = class Interpreter::Context : Evaluator
{
public:
	~Context ();
	Context (const Interpreter&, const Modules&, Environment&);

	Signed Execute ();

private:
	struct Exit final {};
	struct Return final {};
	struct StackFrame;

	Environment& environment;
	StackFrame* current = nullptr;
	std::vector<Object*> allocations;
	std::vector<const Module*> modules;
	std::map<const Module*, Objects> variables;

	void Initialize (const Module&);

	void Execute (const Body&);
	void Execute (const Module&);
	void Execute (const Statement&);
	void Execute (const Statements&);

	void EmitError [[noreturn]] (const Position&, const Message&) const override;
	void EmitError [[noreturn]] (const Position&, const Message&, const Value&) const;

	Object& Designate (const Expression&);
	Object& Designate (const Declaration&);
	Object& Designate (const Declaration&, Objects&);
	Object& DesignateArgument (const Expression&, Size);

	Value EvaluateTypeBound (const Expression&);

	#define FUNCTION(scope, function, name)
	#define PROCEDURE(scope, procedure, name) void Call##procedure (const Expression&);
	#define DEFINITION(definition, name, result, first, second) Value Call##definition (const Expression&);
	#include "oberon.def"

	Value CallLen (const Expression&);
	Object Allocate (const Type&, const Expression&, Size);

	void CheckExternal (const Declaration&);
	void CheckSignature (const Declaration&, const Type&, const Type&, const Type&);

	void Increment (const Expression&, const Value&);
	void Decrement (const Expression&, const Value&);

	using Evaluator::Evaluate;
	Value Evaluate (const Expression&) override;
	Value CallExternal (const Declaration&, const Expression&) override;
	Value Call (const Declaration&, const Expression&, Object*) override;
	Value CallPredeclared (const Declaration&, const Expression&) override;
};

struct Context::StackFrame
{
	StackFrame*const previous = nullptr;
	const Scope& scope;
	const Size depth = 0;
	Objects parameters, variables;
	Value result;

	explicit StackFrame (const Module&);
	StackFrame (StackFrame&, const Scope&);
};

Interpreter::Interpreter (Diagnostics& d, Charset& c, Platform& p) :
	diagnostics {d}, charset {c}, platform {p}
{
}

Signed Interpreter::Execute (const Modules& modules, Environment& environment) const
{
	return Context {*this, modules, environment}.Execute ();
}

Evaluator::Evaluator (const Interpreter& i) :
	interpreter {i}
{
}

Value Evaluator::Evaluate (const Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Set:
	{
		Set value {};
		if (expression.set.elements) for (auto& element: *expression.set.elements)
			if (IsRange (element)) value += EvaluateRange (element, *expression.type); else value += EvaluateElement (element, *expression.type);
		return value;
	}

	case Expression::Call:
	{
		assert (expression.call.designator);
		auto value = Evaluate (*expression.call.designator);
		if (!value.procedure) EmitError (expression.position, "invalid procedure call");
		while (IsForward (*value.procedure) && value.procedure->procedure.definition) value.procedure = value.procedure->procedure.definition;
		if (IsPredeclared (*value.procedure)) return CallPredeclared (*value.procedure, expression);
		if (IsExternal (*value.procedure) && IsForward (*value.procedure)) return CallExternal (*value.procedure, expression);
		return Call (*value.procedure, expression, nullptr);
	}

	case Expression::Unary:
	{
		assert (expression.unary.operand);
		const auto value = Evaluate (*expression.unary.operand);

		switch (expression.unary.operator_)
		{
		case Lexer::Plus:
			switch (value.model)
			{
			case Type::Signed: return +value.signed_;
			case Type::Unsigned: return +value.unsigned_;
			case Type::Real: return +value.real;
			case Type::Complex: return +value.complex;
			case Type::Set: return +value.set;
			default: assert (Type::Unreachable);
			}
		case Lexer::Minus:
			switch (value.model)
			{
			case Type::Signed: return -value.signed_;
			case Type::Real: return -value.real;
			case Type::Complex: return -value.complex;
			case Type::Set: return Set {ECS::Truncate ((-value.set).mask, expression.type->set.size * 8)};
			default: assert (Type::Unreachable);
			}
		case Lexer::Not:
			switch (value.model)
			{
			case Type::Boolean: return !value.boolean;
			default: assert (Type::Unreachable);
			}
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Binary:
	{
		assert (expression.binary.left); assert (expression.binary.right);

		switch (expression.binary.operator_)
		{
		case Lexer::Or:
			return Evaluate (*expression.binary.left).boolean || Evaluate (*expression.binary.right).boolean;
		case Lexer::And:
			return Evaluate (*expression.binary.left).boolean && Evaluate (*expression.binary.right).boolean;
		case Lexer::Equal:
			if (IsStringable (*expression.binary.left->type)) return EvaluateString (*expression.binary.left) == EvaluateString (*expression.binary.right); break;
		case Lexer::Unequal:
			if (IsStringable (*expression.binary.left->type)) return EvaluateString (*expression.binary.left) != EvaluateString (*expression.binary.right); break;
		case Lexer::Less:
			if (IsStringable (*expression.binary.left->type)) return EvaluateString (*expression.binary.left) < EvaluateString (*expression.binary.right); break;
		case Lexer::LessEqual:
			if (IsStringable (*expression.binary.left->type)) return EvaluateString (*expression.binary.left) <= EvaluateString (*expression.binary.right); break;
		case Lexer::Greater:
			if (IsStringable (*expression.binary.left->type)) return EvaluateString (*expression.binary.left) > EvaluateString (*expression.binary.right); break;
		case Lexer::GreaterEqual:
			if (IsStringable (*expression.binary.left->type)) return EvaluateString (*expression.binary.left) >= EvaluateString (*expression.binary.right); break;
		}

		const auto left = Evaluate (*expression.binary.left), right = Evaluate (*expression.binary.right);

		switch (expression.binary.operator_)
		{
		case Lexer::Plus:
			switch (left.model)
			{
			case Type::Signed: return left.signed_ + right.signed_;
			case Type::Unsigned: return left.unsigned_ + right.unsigned_;
			case Type::Real: return left.real + right.real;
			case Type::Complex: return left.complex + right.complex;
			case Type::Set: return left.set + right.set;
			default: assert (Type::Unreachable);
			}
		case Lexer::Minus:
			switch (left.model)
			{
			case Type::Signed: return left.signed_ - right.signed_;
			case Type::Unsigned: return left.unsigned_ - right.unsigned_;
			case Type::Real: return left.real - right.real;
			case Type::Complex: return left.complex - right.complex;
			case Type::Set: return left.set - right.set;
			default: assert (Type::Unreachable);
			}
		case Lexer::Asterisk:
			switch (left.model)
			{
			case Type::Signed: return left.signed_ * right.signed_;
			case Type::Unsigned: return left.unsigned_ * right.unsigned_;
			case Type::Real: return left.real * right.real;
			case Type::Complex: return left.complex * right.complex;
			case Type::Set: return left.set * right.set;
			default: assert (Type::Unreachable);
			}
		case Lexer::Slash:
			if (IsZero (right)) EmitError (expression.position, "division by zero");
			switch (left.model)
			{
			case Type::Real: return left.real / right.real;
			case Type::Complex: return left.complex / right.complex;
			case Type::Set: return left.set / right.set;
			default: assert (Type::Unreachable);
			}
		case Lexer::Div:
			if (IsZero (right)) EmitError (expression.position, "integer division by zero");
			switch (left.model)
			{
			case Type::Signed: return left.signed_ / right.signed_;
			case Type::Unsigned: return left.unsigned_ / right.unsigned_;
			default: assert (Type::Unreachable);
			}
		case Lexer::Mod:
			if (IsZero (right)) EmitError (expression.position, "modulo by zero");
			switch (left.model)
			{
			case Type::Signed: return left.signed_ % right.signed_;
			case Type::Unsigned: return left.unsigned_ % right.unsigned_;
			default: assert (Type::Unreachable);
			}
		case Lexer::Equal:
			return left == right;
		case Lexer::Unequal:
			return left != right;
		case Lexer::Less:
			return left < right;
		case Lexer::LessEqual:
			return left <= right;
		case Lexer::Greater:
			return left > right;
		case Lexer::GreaterEqual:
			return left >= right;
		case Lexer::In:
			return right.set[IsSigned (left) ? left.signed_ : left.unsigned_];
		case Lexer::Is:
			if (IsType (left)) return left.type->IsSameAs (*right.type);
			if (IsAny (left)) EmitError (expression.position, "type test on any pointer");
			if (IsPointer (left)) return Dereference (left, *expression.binary.left).record.type->Extends (*right.type->pointer.baseType);
			return left.record.type->Extends (*right.type);
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Promotion:
	{
		assert (expression.promotion.expression);
		const auto value = Evaluate (*expression.promotion.expression);

		switch (expression.type->model)
		{
		case Type::Character:
			assert (IsString (value));
			assert (value.string->size () == 1);
			return Character (value.string->front ());
		case Type::Signed:
			switch (value.model)
			{
			case Type::Signed: return Signed (value.signed_);
			case Type::Unsigned: return Signed (value.unsigned_);
			default: assert (Type::Unreachable);
			}
		case Type::Unsigned:
			switch (value.model)
			{
			case Type::Signed: return Unsigned (value.signed_);
			case Type::Unsigned: return Unsigned (value.unsigned_);
			default: assert (Type::Unreachable);
			}
		case Type::Real:
			switch (value.model)
			{
			case Type::Signed: return Real (value.signed_);
			case Type::Unsigned: return Real (value.unsigned_);
			case Type::Real: return Real (value.real);
			default: assert (Type::Unreachable);
			}
		case Type::Complex:
			switch (value.model)
			{
			case Type::Signed: return Complex {Real (value.signed_)};
			case Type::Unsigned: return Complex {Real (value.unsigned_)};
			case Type::Real: return Complex {Real (value.real)};
			case Type::Complex: return Complex {Real (value.complex.real), Real (value.complex.imag)};
			default: assert (Type::Unreachable);
			}
		case Type::Set:
			assert (IsSet (value));
			return value.set;
		case Type::Byte:
			switch (value.model)
			{
			case Type::Character: return Byte (value.character);
			case Type::Signed: return Byte (value.signed_);
			case Type::Unsigned: return Byte (value.unsigned_);
			case Type::String: assert (value.string->size () == 1); return Byte (value.string->front ());
			default: assert (Type::Unreachable);
			}
		case Type::Any:
			switch (value.model)
			{
			case Type::Nil: return Any {nullptr};
			case Type::Pointer: return Any {value.pointer};
			default: assert (Type::Unreachable);
			}
		case Type::Pointer:
			assert (IsNil (value));
			return static_cast<Object*> (nullptr);
		case Type::Procedure:
			assert (IsNil (value));
			return static_cast<const Declaration*> (nullptr);
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Conversion:
	{
		assert (expression.conversion.expression);
		const auto value = Evaluate (*expression.conversion.expression);

		switch (expression.type->model)
		{
		case Type::Boolean: return Convert<Boolean, Boolean> (value);
		case Type::Character: return Convert<Character, Signed> (value);
		case Type::Signed: return Convert<Signed, Signed> (value);
		case Type::Unsigned: return Convert<Unsigned, Signed> (value);
		case Type::Real: return Convert<Real, Real> (value);
		case Type::Complex: return IsComplex (value) ? value : Complex {Convert<Real, Real> (value), 0};
		case Type::Set: return Set {Convert<Unsigned, Signed> (value)};
		case Type::Byte: return Convert<Byte, Signed> (value);
		default: assert (Type::Unreachable);
		}
	}

	case Expression::Identifier:
	{
		assert (expression.identifier.declaration);
		const auto& declaration = *expression.identifier.declaration;

		switch (declaration.model)
		{
		case Declaration::Constant:
			return declaration.constant.expression->value;
		case Declaration::Procedure:
			return &declaration;
		default:
			assert (Declaration::Unreachable);
		}
	}

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return Evaluate (*expression.parenthesized.expression);

	default:
		assert (Expression::Unreachable);
	}
}

Value Evaluator::Evaluate (Object& variable, const Expression& expression)
{
	if (!IsValid (variable)) EmitError (expression.position, Format ("variable '%0' not initialized", expression));
	return variable;
}

String Evaluator::EvaluateString (const Expression& expression)
{
	const auto value = Evaluate (expression);

	switch (value.model)
	{
	case Type::String:
		return *value.string;

	case Type::Array:
	{
		assert (value.array); String string;
		for (auto& element: *value.array) if (const auto character = Evaluate (element, expression).character) string.push_back (character); else return string;
		EmitError (expression.position, "missing character array terminator");
	}

	default:
		assert (Type::Unreachable);
	}
}

Object& Evaluator::Dereference (const Value& value, const Expression& expression)
{
	assert (IsPointer (value));
	if (!value.pointer) EmitError (expression.position, "dereferencing nil pointer");
	if (!IsValid (*value.pointer)) EmitError (expression.position, "dereferencing disposed pointer");
	return *value.pointer;
}

Set::Element Evaluator::EvaluateElement (const Expression& expression, const Type& type)
{
	assert (IsSet (type)); const auto element = Evaluate (expression);
	return IsSigned (element) ? element.signed_ : element.unsigned_;
}

Set::Range Evaluator::EvaluateRange (const Expression& expression, const Type& type)
{
	assert (IsRange (expression));
	return {EvaluateElement (*expression.binary.left, type), EvaluateElement (*expression.binary.right, type)};
}

template <typename Basic, typename Real>
Basic Evaluator::Convert (const Value& value)
{
	switch (value.model)
	{
	case Type::Boolean: return Basic (value.boolean);
	case Type::Character: return Basic (value.character);
	case Type::Signed: return Basic (value.signed_);
	case Type::Unsigned: return Basic (value.unsigned_);
	case Type::Real: return Basic (Real (value.real));
	case Type::Set: return Basic (value.set.mask);
	case Type::Byte: return Basic (value.byte);
	default: assert (Type::Unreachable);
	}
}

Value Evaluator::EvaluateArgument (const Expression& expression, const Size index)
{
	return Evaluate (GetArgument (expression, index));
}

Value Evaluator::EvaluateArgument (const Expression& expression, const Size index, const Value& defaultValue)
{
	if (const auto argument = GetOptionalArgument (expression, index)) return Evaluate (*argument); return defaultValue;
}

Value Evaluator::CallPredeclared (const Declaration& declaration, const Expression& expression)
{
	#define FUNCTION(scope, function, name) if (&declaration == &interpreter.platform.scope##function) return Call##function (expression);
	#include "oberon.def"
	assert (Declaration::Unreachable);
}

Value Evaluator::CallAbs (const Expression& expression)
{
	const auto value = EvaluateArgument (expression, 0);
	switch (value.model)
	{
	case Type::Signed: return value.signed_ < 0 ? -value.signed_ : value.signed_;
	case Type::Unsigned: return value.unsigned_;
	case Type::Real: return value.real < 0 ? -value.real : value.real;
	case Type::Complex: return std::sqrt (value.complex.real * value.complex.real + value.complex.imag * value.complex.imag);
	default: assert (Type::Unreachable);
	}
}

Value Evaluator::CallAdr (const Expression& expression)
{
	EmitError (expression.position, "memory address");
}

Value Evaluator::CallBit (const Expression& expression)
{
	EmitError (expression.position, "memory bit");
}

Value Evaluator::CallAsh (const Expression& expression)
{
	const auto value = EvaluateArgument (expression, 0), shift = EvaluateArgument (expression, 1);
	const auto amount = IsSigned (shift) ? shift.signed_ : Signed (shift.unsigned_);
	const auto logical = expression.Calls (interpreter.platform.systemLsh);
	switch (value.model)
	{
	case Type::Signed: return amount < 0 ? logical ? Signed (ShiftRight (ECS::Truncate (Unsigned (value.signed_), expression.type->signed_.size * 8), -amount)) : ShiftRight (value.signed_, -amount) : ShiftLeft (value.signed_, amount);
	case Type::Unsigned: return amount < 0 ? ShiftRight (value.unsigned_, -amount) : ShiftLeft (value.unsigned_, amount);
	default: assert (Type::Unreachable);
	}
}

Value Evaluator::CallCap (const Expression& expression)
{
	return Character (std::toupper (EvaluateArgument (expression, 0).character));
}

Value Evaluator::CallChr (const Expression& expression)
{
	const auto value = EvaluateArgument (expression, 0);
	switch (value.model)
	{
	case Type::Signed: return Character (interpreter.charset.Decode (value.signed_));
	case Type::Unsigned: return Character (interpreter.charset.Decode (value.unsigned_));
	default: assert (Type::Unreachable);
	}
}

Value Evaluator::CallEntier (const Expression& expression)
{
	return Signed (std::floor (EvaluateArgument (expression, 0).real));
}

Value Evaluator::CallIm (const Expression& expression)
{
	return EvaluateArgument (expression, 0).complex.imag;
}

Value Evaluator::CallLen (const Expression& expression)
{
	const auto& type = GetArray (*GetArgument (expression, 0).type, EvaluateArgument (expression, 1, Signed (0)).signed_);
	assert (!IsOpenArray (type)); return type.array.length->value;
}

Value Evaluator::CallLong (const Expression& expression)
{
	return EvaluateArgument (expression, 0);
}

Value Evaluator::CallLsh (const Expression& expression)
{
	return CallAsh (expression);
}

Value Evaluator::CallMax (const Expression& expression)
{
	const auto& type = *GetArgument (expression, 0).type;
	switch (type.model)
	{
	case Type::Boolean: return std::numeric_limits<Boolean>::max ();
	case Type::Character: return std::numeric_limits<Character>::max ();
	case Type::Signed: return ShiftRight (std::numeric_limits<Signed>::max (), (sizeof (Signed) - type.signed_.size) * 8);
	case Type::Unsigned: return ShiftRight (std::numeric_limits<Unsigned>::max (), (sizeof (Unsigned) - type.unsigned_.size) * 8);
	case Type::Real: return Truncate (std::numeric_limits<Real>::max (), type);
	case Type::Complex: return Truncate (Complex {std::numeric_limits<Real>::max (), std::numeric_limits<Real>::max ()}, type);
	case Type::Set: return Signed (type.set.size * 8 - 1);
	default: assert (Type::Unreachable);
	}
}

Value Evaluator::CallMin (const Expression& expression)
{
	const auto& type = *GetArgument (expression, 0).type;
	switch (type.model)
	{
	case Type::Boolean: return std::numeric_limits<Boolean>::min ();
	case Type::Character: return std::numeric_limits<Character>::min ();
	case Type::Signed: return ShiftRight (std::numeric_limits<Signed>::min (), (sizeof (Signed) - type.signed_.size) * 8);
	case Type::Unsigned: return ShiftRight (std::numeric_limits<Unsigned>::min (), (sizeof (Unsigned) - type.unsigned_.size) * 8);
	case Type::Real: return Truncate (std::numeric_limits<Real>::min (), type);
	case Type::Complex: return Truncate (Complex {std::numeric_limits<Real>::min (), std::numeric_limits<Real>::min ()}, type);
	case Type::Set: return Signed (0);
	default: assert (Type::Unreachable);
	}
}

Value Evaluator::CallOdd (const Expression& expression)
{
	const auto value = EvaluateArgument (expression, 0);
	switch (value.model)
	{
	case Type::Signed: return (value.signed_ & 1) == 1;
	case Type::Unsigned: return (value.unsigned_ & 1) == 1;
	default: assert (Type::Unreachable);
	}
}

Value Evaluator::CallOrd (const Expression& expression)
{
	return Signed {interpreter.charset.Encode (EvaluateArgument (expression, 0).character)};
}

Value Evaluator::CallPtr (const Expression& expression)
{
	EmitError (expression.position, "variable pointer");
}

Value Evaluator::CallRe (const Expression& expression)
{
	return EvaluateArgument (expression, 0).complex.real;
}

Value Evaluator::CallRot (const Expression& expression)
{
	const auto value = EvaluateArgument (expression, 0), shift = EvaluateArgument (expression, 1);
	const auto bits = interpreter.platform.GetSize (*expression.type) * 8;
	const auto amount = (IsSigned (shift) ? Unsigned (shift.signed_) : shift.unsigned_) & (bits - 1);
	const auto mask = IsSigned (value) ? ECS::Truncate (Unsigned (value.signed_), bits) : value.unsigned_;
	const auto result = mask << amount | mask >> bits - amount;
	return Truncate (IsSigned (value) ? Value {Signed (result)} : result, *expression.type);
}

Value Evaluator::CallSel (const Expression& expression)
{
	return EvaluateArgument (expression, 0).boolean ? EvaluateArgument (expression, 1) : EvaluateArgument (expression, 2);
}

Value Evaluator::CallShort (const Expression& expression)
{
	return Truncate (EvaluateArgument (expression, 0), *expression.type);
}

Value Evaluator::CallSize (const Expression& expression)
{
	return Signed (interpreter.platform.GetSize (*GetArgument (expression, 0).type));
}

Value Evaluator::CallVal (const Expression& expression)
{
	EmitError (expression.position, "type interpretation");
}

Value Evaluator::CallExternal (const Declaration&, const Expression& expression)
{
	EmitError (expression.position, "calling external procedure");
}

Value Evaluator::Truncate (const Value& value, const Type& type)
{
	using ECS::Truncate;
	switch (value.model)
	{
	case Type::Signed: return Truncate (value.signed_, type.signed_.size * 8);
	case Type::Unsigned: return Truncate (value.unsigned_, type.unsigned_.size * 8);
	case Type::Real: return Truncate (value.real, type.real.size * 8);
	case Type::Complex: return Complex {Truncate (value.complex.real, type.complex.size * 8), Truncate (value.complex.imag, type.complex.size * 8)};
	case Type::Set: return Set {Truncate (value.set.mask, type.set.size * 8)};
	default: return value;
	}
}

Context::Context (const Interpreter& i, const Modules& modules, Environment& e) :
	Evaluator {i}, environment {e}
{
	for (auto& module: modules) if (!IsGeneric (module) || IsParameterized (module)) Initialize (module);
}

Context::~Context ()
{
	for (auto allocation: allocations) delete allocation;
}

void Context::Initialize (const Module& module)
{
	for (auto& declaration: module.declarations) if (IsImport (declaration) && IsModule (*declaration.import.scope)) Initialize (*declaration.import.scope->module);
	if (InsertUnique (&module, modules)) module.scope->Initialize (variables[&module], true);
}

Signed Context::Execute ()
{
	try {for (auto module: modules) Execute (*module);} catch (const Signed status) {return status;} return 0;
}

void Context::Execute (const Module& module)
{
	StackFrame stackFrame {module}; const Restore restoreStackFrame {current, &stackFrame};
	for (auto& declaration: module.declarations) if (IsProcedure (declaration) && IsExternal (declaration) && !IsForward (declaration)) CheckExternal (declaration);
	if (module.body) Execute (*module.body);
}

void Context::Execute (const Body& body)
{
	try {Execute (body.statements);} catch (const Return&) {}
}

void Context::Execute (const Statement& statement)
{
	switch (statement.model)
	{
	case Statement::If:
		if (Evaluate (*statement.if_.condition).boolean) return Execute (*statement.if_.thenPart);
		if (statement.if_.elsifs) for (auto& elsif: *statement.if_.elsifs) if (Evaluate (elsif.condition).boolean) return Execute (elsif.statements);
		if (statement.if_.elsePart) return Execute (*statement.if_.elsePart);
		break;

	case Statement::For:
	{
		const auto temp = Evaluate (*statement.for_.end); auto& variable = Designate (*statement.for_.variable);
		const auto step = statement.for_.step ? Evaluate (*statement.for_.step) : IsSigned (variable) ? Signed {1} : Unsigned {1}; variable = Evaluate (*statement.for_.begin);
		while (IsSigned (step) && step.signed_ < 0 ? variable >= temp : variable <= temp) Execute (*statement.for_.statements), Increment (*statement.for_.variable, step);
		break;
	}

	case Statement::Case:
	{
		const auto value = Evaluate (*statement.case_.expression);
		if (statement.case_.cases) for (auto& case_: *statement.case_.cases) for (auto& label: case_.labels) if (GetRange (label)[value]) return Execute (case_.statements);
		if (statement.case_.elsePart) return Execute (*statement.case_.elsePart);
		EmitError (statement.position, "unmatched case label");
	}

	case Statement::Exit:
		throw Exit {};

	case Statement::Loop:
		try {while (true) Execute (*statement.loop.statements);} catch (const Exit&) {}
		break;

	case Statement::With:
		for (auto& guard: *statement.with.guards)
			if (IsAny (*guard.expression.type)) EmitError (guard.position, "any pointer guard");
			else if (IsPointer (guard.type) && Dereference (Evaluate (guard.expression), guard.expression).record.type->Extends (*guard.type.pointer.baseType)) return Execute (guard.statements);
			else if (IsRecord (guard.type) && Designate (guard.expression).record.type->Extends (guard.type)) return Execute (guard.statements);
		if (statement.with.elsePart) return Execute (*statement.with.elsePart);
		EmitError (statement.position, "unsatisifed type test");

	case Statement::While:
		while (Evaluate (*statement.while_.condition).boolean) Execute (*statement.while_.statements);
		break;

	case Statement::Return:
		if (statement.return_.expression) current->result = Evaluate (*statement.return_.expression);
		throw Return {};

	case Statement::Repeat:
		do Execute (*statement.repeat.statements); while (!Evaluate (*statement.repeat.condition).boolean);
		break;

	case Statement::Assignment:
	{
		auto& designator = Designate (*statement.assignment.designator);
		if (IsRecord (designator) && HasDynamicType (*statement.assignment.designator) && !designator.record.type->IsSameAs (*statement.assignment.designator->type))
			EmitError (statement.position, Format ("expression '%0' of %1 has dynamic %2", *statement.assignment.designator, *statement.assignment.designator->type, *designator.record.type));
		designator = Evaluate (*statement.assignment.expression);
		break;
	}

	case Statement::ProcedureCall:
		Evaluate (*statement.procedureCall.designator);
		break;

	default:
		assert (Statement::Unreachable);
	}
}

void Context::Execute (const Statements& statements)
{
	for (auto& statement: statements) Execute (statement);
}

void Context::EmitError (const Position& position, const Message& message) const
{
	interpreter.diagnostics.Emit (Diagnostics::Error, GetModule (current->scope).source, position, message); throw Error {};
}

void Context::EmitError (const Position& position, const Message& message, const Value& status) const
{
	assert (IsSigned (status)); try {EmitError (position, message);} catch (const Error&) {} throw status.signed_;
}

void Context::Increment (const Expression& expression, const Value& increment)
{
	auto& variable = Designate (expression); auto value = Evaluate (variable, expression);
	if (IsSigned (value)) value.signed_ += increment.signed_; else value.unsigned_ += increment.unsigned_;
	variable = Truncate (value, *expression.type);
}

void Context::Decrement (const Expression& expression, const Value& decrement)
{
	auto& variable = Designate (expression); auto value = Evaluate (variable, expression);
	if (IsSigned (value)) value.signed_ -= decrement.signed_; else value.unsigned_ -= decrement.unsigned_;
	variable = Truncate (value, *expression.type);
}

Object& Context::Designate (const Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Index:
	{
		auto& array = Designate (*expression.index.designator).elements;
		const auto index = Evaluate (*expression.index.expression).signed_;
		if (index >= 0 & index < Signed (array.size ())) return array[index];
		EmitError (expression.index.expression->position, Format ("invalid array element index '%0'", *expression.index.expression));
	}

	case Expression::Selector:
		return Designate (*expression.selector.declaration, Designate (*expression.selector.designator).elements);

	case Expression::TypeGuard:
	{
		assert (expression.typeGuard.designator);
		auto& variable = Designate (*expression.typeGuard.designator);
		if (IsAny (variable)) EmitError (expression.position, "type guard on any pointer");
		if (!variable.record.type->Extends (*expression.type)) EmitError (expression.position, "type guard failed");
		return variable;
	}

	case Expression::Identifier:
		if (IsExternal (*expression.identifier.declaration) && IsUndefined (*expression.identifier.declaration)) EmitError (expression.position, "accessing external variable");
		return Designate (*expression.identifier.declaration);

	case Expression::Dereference:
		return Dereference (Evaluate (*expression.dereference.expression), expression);

	default:
		assert (Expression::Unreachable);
	}
}

Object& Context::Designate (const Declaration& declaration)
{
	assert (!IsUndefined (declaration));
	if (IsModule (*declaration.scope)) return Designate (declaration, variables[declaration.scope->module]);
	auto stackFrame = current; while (stackFrame && &stackFrame->scope != declaration.scope) stackFrame = stackFrame->previous; assert (stackFrame);
	if (IsVariableParameter (declaration)) return *Designate (declaration, stackFrame->parameters).pointer;
	if (IsParameter (declaration)) return Designate (declaration, stackFrame->parameters);
	return Designate (declaration, stackFrame->variables);
}

Object& Context::Designate (const Declaration& declaration, Objects& objects)
{
	assert (IsObject (declaration));
	assert (declaration.object.index < objects.size ());
	return objects[declaration.object.index];
}

Value Context::Evaluate (const Expression& expression)
{
	if (IsConstant (expression)) return expression.value;

	switch (expression.model)
	{
	case Expression::Set:
	case Expression::Promotion:
	case Expression::Conversion:
	case Expression::Parenthesized:
		return Evaluator::Evaluate (expression);

	case Expression::Call:
		if (IsTypeBound (*expression.call.designator->type)) return EvaluateTypeBound (expression);
		return Evaluator::Evaluate (expression);

	case Expression::Index:
	case Expression::Selector:
	case Expression::Identifier:
	case Expression::Dereference:
		return Evaluate (Designate (expression), expression);

	case Expression::Unary:
	case Expression::Binary:
		return Truncate (Evaluator::Evaluate (expression), *expression.type);

	case Expression::TypeGuard:
	{
		auto value = Evaluate (*expression.typeGuard.designator);
		if (IsAny (value)) EmitError (expression.position, "type guard on any pointer");
		if (!Dereference (value, *expression.typeGuard.designator).record.type->Extends (*expression.type->pointer.baseType)) EmitError (expression.position, "type guard failed");
		return value;
	}

	default:
		assert (Expression::Unreachable);
	}
}

Object& Context::DesignateArgument (const Expression& expression, const Size index)
{
	return Designate (GetArgument (expression, index));
}

Value Context::EvaluateTypeBound (const Expression& expression)
{
	assert (IsCall (expression)); const auto& designator = *expression.call.designator; assert (IsTypeBound (*designator.type));
	const auto& receiver = IsSuper (designator) ? *designator.super.designator->selector.designator : *designator.selector.designator;
	auto& variable = IsPointer (*receiver.type) ? Dereference (Evaluate (receiver), receiver) : Designate (receiver);
	auto declaration = IsSuper (designator) ? designator.super.declaration : variable.record.type->record.scope->Lookup (*designator.selector.identifier, GetModule (current->scope));
	assert (declaration); return Call (*declaration, expression, &variable);
}

Value Context::Call (const Declaration& declaration, const Expression& expression, Object*const receiver)
{
	assert (IsProcedure (declaration)); assert (!IsForward (declaration));
	auto& signature = declaration.procedure.signature; StackFrame stackFrame {*current, *signature.scope};
	if (stackFrame.depth > 512) EmitError (expression.position, "excessive procedure activation nesting");
	stackFrame.parameters.reserve ((signature.parameters ? signature.parameters->size () : 0) + (signature.receiver ? 1 : 0));
	if (signature.receiver) assert (receiver), stackFrame.parameters.emplace_back (receiver); else assert (!receiver);
	if (expression.call.arguments) for (auto& argument: *expression.call.arguments)
		if (IsVariableOpenByteArrayParameter (GetParameter (expression, argument))) EmitError (argument.position, "variable open byte array argument");
		else if (IsVariableParameter (GetParameter (expression, argument))) stackFrame.parameters.emplace_back (&Designate (argument));
		else if (!IsString (*argument.type)) stackFrame.parameters.emplace_back (Evaluate (argument));
		else if (const auto length = GetParameter (expression, argument).type->array.length) stackFrame.parameters.emplace_back (length->value.signed_, EvaluateString (argument));
		else stackFrame.parameters.emplace_back (Evaluate (argument));
	const Restore restoreStackFrame {current, &stackFrame};
	if (declaration.procedure.body) Execute (*declaration.procedure.body);
	if (signature.result && !IsValid (stackFrame.result)) EmitError (declaration.position, "no result value");
	return stackFrame.result;
}

Value Context::CallPredeclared (const Declaration& declaration, const Expression& expression)
{
	#define FUNCTION(scope, procedure_, name)
	#define PROCEDURE(scope, procedure_, name) if (&declaration == &interpreter.platform.scope##procedure_) return Call##procedure_ (expression), Value {};
	#include "oberon.def"
	if (&declaration == &interpreter.platform.globalLen) return CallLen (expression);
	return Evaluator::CallPredeclared (declaration, expression);
}

void Context::CallAsm (const Expression& expression)
{
	if (!GetArgument (expression, 0).value.string->empty ()) EmitError (expression.position, "inline assembly code");
}

void Context::CallAssert (const Expression& expression)
{
	auto& condition = GetArgument (expression, 0);
	if (!Evaluate (condition).boolean) EmitError (condition.position, Format ("assertion '%0' failed", condition), EvaluateArgument (expression, 1, Signed {1}));
}

void Context::CallCode (const Expression& expression)
{
	if (!GetArgument (expression, 0).value.string->empty ()) EmitError (expression.position, "inline intermediate code");
}

void Context::CallCopy (const Expression& expression)
{
	DesignateArgument (expression, 1) = EvaluateString (GetArgument (expression, 0));
}

void Context::CallDec (const Expression& expression)
{
	Decrement (GetArgument (expression, 0), EvaluateArgument (expression, 1, IsSigned (*expression.type) ? Signed {1} : Unsigned {1}));
}

void Context::CallDispose (const Expression& expression)
{
	auto& argument = GetArgument (expression, 0); auto& variable = Designate (argument);
	Dereference (variable, argument).model = Type::Void; variable.pointer = nullptr;
}

void Context::CallExcl (const Expression& expression)
{
	DesignateArgument (expression, 0).set -= EvaluateElement (GetArgument (expression, 1), *GetArgument (expression, 0).type);
}

void Context::CallGet (const Expression& expression)
{
	if (expression.type) EmitError (expression.position, "memory read");
}

void Context::CallHalt (const Expression& expression)
{
	if (expression.type) EmitError (expression.position, "halt", EvaluateArgument (expression, 0));
}

void Context::CallIgnore (const Expression& expression)
{
	const auto& operand = GetArgument (expression, 0);
	if (IsVariable (operand)) Designate (operand); else Evaluate (operand);
}

void Context::CallInc (const Expression& expression)
{
	Increment (GetArgument (expression, 0), EvaluateArgument (expression, 1, IsSigned (*expression.type) ? Signed {1} : Unsigned {1}));
}

void Context::CallIncl (const Expression& expression)
{
	DesignateArgument (expression, 0).set += EvaluateElement (GetArgument (expression, 1), *GetArgument (expression, 0).type);
}

Value Context::CallLen (const Expression& expression)
{
	auto variable = &DesignateArgument (expression, 0);
	for (auto dimension = EvaluateArgument (expression, 1, Signed {0}).signed_; dimension; --dimension) variable = &variable->elements.front ();
	return Signed (variable->elements.size ());
}

void Context::CallMove (const Expression& expression)
{
	if (expression.type) EmitError (expression.position, "memory copy");
}

void Context::CallNew (const Expression& expression)
{
	allocations.push_back (new (std::nothrow) Object {Allocate (*GetArgument (expression, 0).type->pointer.baseType, expression, 1)});
	DesignateArgument (expression, 0) = allocations.back ();
}

void Context::CallPut (const Expression& expression)
{
	if (expression.type) EmitError (expression.position, "memory write");
}

void Context::CallSystemDispose (const Expression& expression)
{
	if (expression.type) EmitError (expression.position, "memory deallocation");
}

void Context::CallSystemNew (const Expression& expression)
{
	if (expression.type) EmitError (expression.position, "memory allocation");
}

void Context::CallTrace (const Expression& expression)
{
	const auto& argument = GetArgument (expression, 0); std::ostringstream stream;
	EmitMessage (stream, Diagnostics::Note, GetModule (current->scope).source, argument.position);
	if (IsLiteral (argument)) stream << argument; else stream << '\'' << argument << "' = " << (IsStringable (*argument.type) ? EvaluateString (argument) : Evaluate (argument));
	stream << '\n'; environment.Fputs (stream.str (), environment.stdout_);
}

Object Context::Allocate (const Type& type, const Expression& expression, const Size index)
{
	if (!IsOpenArray (type)) return Object {type, false};
	const auto length = EvaluateArgument (expression, index).signed_;
	if (length <= 0 || Signed (Size (length)) != length) EmitError (expression.position, "invalid open array length");
	return Object {Size (length), Allocate (*type.array.elementType, expression, index + 1)};
}

void Context::CheckExternal (const Declaration& declaration)
{
	assert (IsProcedure (declaration)); assert (IsExternal (declaration));
	if (!IsString (*declaration.procedure.external->type)) return;
	const auto& name = *declaration.procedure.external->value.string;
	#define DEFINITION(definition, name_, result, first, second) if (name == name_) return CheckSignature (declaration, interpreter.platform.result, interpreter.platform.first, interpreter.platform.second);
	#include "oberon.def"
}

void Context::CheckSignature (const Declaration& declaration, const Type& result, const Type& first, const Type& second)
{
	assert (IsProcedure (declaration)); assert (IsExternal (declaration)); auto& signature = declaration.procedure.signature;
	if (Size (IsValid (first) + IsValid (second)) != (signature.parameters ? signature.parameters->size () : 0)) EmitError (declaration.position, "invalid number of parameters");
	if (IsValid (first) && !first.IsSameAs (*signature.parameters->front ().parameter.type) && !signature.parameters->front ().parameter.isVariable) EmitError (declaration.position, "invalid first parameter type");
	if (IsValid (second) && !second.IsSameAs (*signature.parameters->back ().parameter.type) && !signature.parameters->back ().parameter.isVariable) EmitError (declaration.position, "invalid second parameter type");
	if (IsValid (result) && !result.IsSameAs (*signature.result)) EmitError (declaration.position, "invalid result type");
}

Value Context::CallExternal (const Declaration& declaration, const Expression& expression)
{
	assert (IsProcedure (declaration)); assert (declaration.procedure.external);
	if (!IsString (*declaration.procedure.external->type)) return Evaluator::CallExternal (declaration, expression);
	const auto& name = *declaration.procedure.external->value.string;
	#define DEFINITION(definition, name_, result, first, second) if (name == name_) return Call##definition (expression);
	#include "oberon.def"
	return Evaluator::CallExternal (declaration, expression);
}

Value Context::CallGetchar (const Expression&)
{
	return Signed (environment.Getchar ());
}

Value Context::CallPutchar (const Expression& expression)
{
	return Signed (environment.Putchar (EvaluateArgument (expression, 0).signed_));
}

Context::StackFrame::StackFrame (const Module& module) :
	scope {*module.scope}
{
}

Context::StackFrame::StackFrame (StackFrame& p, const Scope& s) :
	previous {&p}, scope {s}, depth {previous->depth + 1}
{
	scope.Initialize (variables, false);
}

// C++ interpreter
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
#include "cppinterpreter.hpp"
#include "cppprinter.hpp"
#include "environment.hpp"
#include "error.hpp"
#include "format.hpp"
#include "stringpool.hpp"
#include "utilities.hpp"

#include <unordered_map>

using namespace ECS;
using namespace CPP;

using Evaluator =
	#include "cppevaluator.hpp"

using Executor =
	#include "cppexecutor.hpp"

using StackFrame = struct Executor::StackFrame
{
	StackFrame*const previous;
	const Function& function;
	Values variables, parameters;
	Value returnValue;
	const Size depth;

	StackFrame (StackFrame*, const Function&, Values&&);
};

using Instruction = struct Executor::Instruction
{
	using Phase = Instruction (Executor::*) (const Statement&);

	const Statement* statement;
	Phase phase;

	Instruction (const StatementBlock&);
	Instruction (const Statement&, Phase);
};

using Thread = class Interpreter::Thread : protected Executor
{
public:
	explicit Thread (Context&);

	void Join ();
	void Start (const Function&, Values&&);

protected:
	Context& context;

	Value Call (const Function&, Values&&, const Location&) override;

private:
	template <typename Definition> Definition& Designate (const Entity&, std::unordered_map<String, Definition>&);

	Value& Designate (const Entity&) override;
};

using MainThread = class Interpreter::MainThread : Thread
{
public:
	using Thread::Thread;

	Signed Start (Array&);

private:
	const Function* main = nullptr;

	void CallMain [[noreturn]] (Array&);

	bool Define (const Function&);
	void Define (const Variable&);
	void Define (const Statement&);
	void Define (const Declaration&);
	void Define (const Declarations&);
	void Define (const FunctionBody&);
	void Define (const InitDeclarator&);
	void Define (const StatementBlock&);
	void Define (const TranslationUnit&);
	bool Define (const Variable&, const Value&);
};

using Context = class Interpreter::Context
{
public:
	const Interpreter& interpreter;
	TranslationUnit translationUnit;
	const TranslationUnits& translationUnits;
	std::unordered_map<String, Value> variables;
	std::unordered_map<String, const Function*> functions;

	Context (const Interpreter&, const TranslationUnits&, const Source&, Environment&);

	const Function* abort; void Abort [[noreturn]] ();
	const Function* exit; void Exit [[noreturn]] (const Value&);
	const Function* fputc; Value Fputc (const Value&, const Value&);
	const Function* getchar; Value Getchar ();
	const Function* putchar; Value Putchar (const Value&);

private:
	Environment& environment;

	Namespace& DefineNamespace (const char*, Scope&);
	Entity& Define (Entity::Model, const char*, Scope&);
	Function& DefineFunction (const char*, const Type&, Scope&);
	Variable& DefineVariable (const char*, const Type&, LanguageLinkage, const Value&, Scope&);
};

Interpreter::Interpreter (Diagnostics& d, StringPool& sp, Platform& p) :
	diagnostics {d}, stringPool {sp}, platform {p}
{
}

Signed Interpreter::Execute (const TranslationUnits& translationUnits, const Source& source, Environment& environment, Array& arguments) const
{
	Context context {*this, translationUnits, source, environment};
	return MainThread {context}.Start (arguments);
}

Evaluator::Evaluator (const Interpreter& i) :
	interpreter {i}
{
}

void Evaluator::EmitError (const Location& location, const Message& message) const
{
	location.Emit (Diagnostics::Error, interpreter.diagnostics, message); throw Error {};
}

template <typename Value>
inline Value Evaluator::Truncate (const Value value, const Expression& expression)
{
	return ECS::Truncate (value, interpreter.platform.GetBits (expression.type));
}

Signed Evaluator::Truncate (const Signed value, const Expression& expression)
{
	const auto result = Truncate<Signed> (value, expression);
	if (result != value) throw UndefinedBehavior {expression.location, Format ("expression '%0' truncates value", expression)};
	return result;
}

Value Evaluator::Evaluate (const Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Comma:
		assert (expression.comma.left); assert (expression.comma.right);
		return Evaluate (*expression.comma.left), Evaluate (*expression.comma.right);

	case Expression::Unary:
	{
		assert (expression.unary.operand);
		const auto value = Evaluate (*expression.unary.operand);

		switch (expression.unary.operator_.symbol)
		{
		case Lexer::Plus:
			switch (value.model) {
			case Value::Float: return Truncate (+value.float_, expression);
			case Value::Signed: return Truncate (+value.signed_, expression);
			case Value::Pointer: return {value.pointer, +value.pointer.offset};
			case Value::Unsigned: return Truncate (+value.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::Minus:
			switch (value.model) {
			case Value::Float: return Truncate (-value.float_, expression);
			case Value::Signed: return Truncate (-value.signed_, expression);
			case Value::Unsigned: return Truncate (-value.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::ExclamationMark: case Lexer::Not:
			assert (IsBoolean (value));
			return !value.boolean;
		case Lexer::Tilde: case Lexer::Compl:
			switch (value.model) {
			case Value::Signed: return Truncate (~value.signed_, expression);
			case Value::Unsigned: return Truncate (~value.unsigned_, expression);
			default: assert (Value::Unreachable);
			}

		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Binary:
	{
		assert (expression.binary.left);
		assert (expression.binary.right);

		const auto left = Evaluate (*expression.binary.left);

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::DoubleAmpersand: case Lexer::And:
			assert (IsBoolean (left));
			if (!left.boolean) return left.boolean;
			break;
		case Lexer::DoubleBar: case Lexer::Or:
			assert (IsBoolean (left));
			if (left.boolean) return left.boolean;
			break;
		}

		const auto right = Evaluate (*expression.binary.right);

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::Plus:
			if (IsPointer (left)) return {left.pointer, Truncate (left.pointer.offset + right.signed_, *expression.binary.right)};
			if (IsPointer (right)) return {right.pointer, Truncate (right.pointer.offset + left.signed_, *expression.binary.left)};
			break;
		case Lexer::Minus:
			if (IsPointer (right))
				if (right.pointer.entity == left.pointer.entity && left.pointer.value == right.pointer.value && left.pointer.array == right.pointer.array) return left.pointer.offset - right.pointer.offset;
				else throw UndefinedBehavior {expression.location, "invalid pointer subtraction"};
			if (IsPointer (left)) return {left.pointer, Truncate (left.pointer.offset - right.signed_, *expression.binary.right)};
			break;
		}

		assert (left.model == right.model);

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::Plus:
			switch (left.model) {
			case Value::Float: return Truncate (left.float_ + right.float_, expression);
			case Value::Signed: return Truncate (left.signed_ + right.signed_, expression);
			case Value::Unsigned: return Truncate (left.unsigned_ + right.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::Minus:
			switch (left.model) {
			case Value::Float: return Truncate (left.float_ - right.float_, expression);
			case Value::Signed: return Truncate (left.signed_ - right.signed_, expression);
			case Value::Unsigned: return Truncate (left.unsigned_ - right.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::Asterisk:
			switch (left.model) {
			case Value::Float: return Truncate (left.float_ * right.float_, expression);
			case Value::Signed: return Truncate (left.signed_ * right.signed_, expression);
			case Value::Unsigned: return Truncate (left.unsigned_ * right.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::Slash:
			if (IsZero (right)) throw UndefinedBehavior {expression.location, "division by zero"};

			switch (left.model) {
			case Value::Float: return Truncate (left.float_ / right.float_, expression);
			case Value::Signed: return Truncate (left.signed_ / right.signed_, expression);
			case Value::Unsigned: return Truncate (left.unsigned_ / right.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::Percent:
			if (IsZero (right)) throw UndefinedBehavior {expression.location, "modulo by zero"};

			switch (left.model) {
			case Value::Signed: return Truncate (left.signed_ % right.signed_, expression);
			case Value::Unsigned: return Truncate (left.unsigned_ % right.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::DoubleLess:
			switch (left.model) {
			case Value::Signed: return Truncate (ShiftLeft (left.signed_, right.signed_), expression);
			case Value::Unsigned: return Truncate (ShiftLeft (left.unsigned_, right.unsigned_), expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::DoubleGreater:
			switch (left.model) {
			case Value::Signed: return Truncate (ShiftRight (left.signed_, right.signed_), expression);
			case Value::Unsigned: return Truncate (ShiftRight (left.unsigned_, right.unsigned_), expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::DoubleEqual:
			return left == right;
		case Lexer::ExclamationMarkEqual: case Lexer::NotEq:
			return left != right;
		case Lexer::Less:
			return left < right;
		case Lexer::Greater:
			return left > right;
		case Lexer::LessEqual:
			return left <= right;
		case Lexer::GreaterEqual:
			return left >= right;
		case Lexer::DoubleAmpersand: case Lexer::And:
		case Lexer::DoubleBar: case Lexer::Or:
			assert (IsBoolean (right));
			return right;
		case Lexer::Ampersand: case Lexer::Bitand:
			switch (left.model) {
			case Value::Signed: return Truncate (left.signed_ & right.signed_, expression);
			case Value::Unsigned: return Truncate (left.unsigned_ & right.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::Caret: case Lexer::Xor:
			switch (left.model) {
			case Value::Signed: return Truncate (left.signed_ ^ right.signed_, expression);
			case Value::Unsigned: return Truncate (left.unsigned_ ^ right.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Lexer::Bar: case Lexer::Bitor:
			switch (left.model) {
			case Value::Signed: return Truncate (left.signed_ | right.signed_, expression);
			case Value::Unsigned: return Truncate (left.unsigned_ | right.unsigned_, expression);
			default: assert (Value::Unreachable);
			}

		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Prefix:
	{
		assert (expression.prefix.expression);
		const auto value = Evaluate (*expression.prefix.expression);
		auto& reference = Designate (value, *expression.prefix.expression);
		const auto decrement = expression.prefix.operator_.symbol == Lexer::DoubleMinus;
		Increment (reference, decrement, expression);
		return value;
	}

	case Expression::Postfix:
	{
		assert (expression.postfix.expression);
		auto& reference = Designate (Evaluate (*expression.postfix.expression), *expression.postfix.expression);
		const auto decrement = expression.postfix.operator_.symbol == Lexer::DoubleMinus;
		const auto value = reference; Increment (reference, decrement, expression);
		return value;
	}

	case Expression::Addressof:
		assert (expression.addressof.expression);
		return ConvertToPointer (Evaluate (*expression.addressof.expression));

	case Expression::Subscript:
	{
		assert (expression.subscript.array); assert (expression.subscript.index);
		auto array = Evaluate (*expression.subscript.array);
		const auto index = Evaluate (*expression.subscript.index);
		array.reference.offset += index.signed_;
		return array;
	}

	case Expression::Assignment:
	{
		assert (expression.assignment.left);
		assert (expression.assignment.right);
		const auto left = Evaluate (*expression.assignment.left);
		const auto right = Evaluate (*expression.assignment.right);
		auto& result = Designate (left, *expression.assignment.left);

		switch (expression.assignment.operator_.symbol)
		{
		case Lexer::Equal:
			result = right;
			break;
		case Lexer::PlusEqual:
			switch (result.model) {
			case Value::Float: result.float_ = Truncate (result.float_ + right.float_, expression); break;
			case Value::Signed: result.signed_ = Truncate (result.signed_ + right.signed_, expression); break;
			case Value::Pointer: result.pointer.offset = Truncate (result.pointer.offset + right.signed_, *expression.assignment.right); break;
			case Value::Unsigned: result.unsigned_ = Truncate (result.unsigned_ + right.unsigned_, expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::MinusEqual:
			switch (result.model) {
			case Value::Float: result.float_ = Truncate (result.float_ - right.float_, expression); break;
			case Value::Signed: result.signed_ = Truncate (result.signed_ - right.signed_, expression); break;
			case Value::Pointer: result.pointer.offset = Truncate (result.pointer.offset - right.signed_, *expression.assignment.right); break;
			case Value::Unsigned: result.unsigned_ = Truncate (result.unsigned_ - right.unsigned_, expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::AsteriskEqual:
			switch (result.model) {
			case Value::Float: result.float_ = Truncate (result.float_ * right.float_, expression); break;
			case Value::Signed: result.signed_ = Truncate (result.signed_ * right.signed_, expression); break;
			case Value::Unsigned: result.unsigned_ = Truncate (result.unsigned_ * right.unsigned_, expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::SlashEqual:
			if (IsZero (right)) throw UndefinedBehavior {expression.location, "division by zero"};

			switch (result.model) {
			case Value::Float: result.float_ = Truncate (result.float_ / right.float_, expression); break;
			case Value::Signed: result.signed_ = Truncate (result.signed_ / right.signed_, expression); break;
			case Value::Unsigned: result.unsigned_ = Truncate (result.unsigned_ / right.unsigned_, expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::PercentEqual:
			if (IsZero (right)) throw UndefinedBehavior {expression.location, "modulo by zero"};

			switch (result.model) {
			case Value::Signed: result.signed_ = Truncate (result.signed_ % right.signed_, expression); break;
			case Value::Unsigned: result.unsigned_ = Truncate (result.unsigned_ % right.unsigned_, expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::DoubleLessEqual:
			switch (result.model) {
			case Value::Signed: result.signed_ = Truncate (ShiftLeft (result.signed_, right.signed_), expression); break;
			case Value::Unsigned: result.unsigned_ = Truncate (ShiftLeft (result.unsigned_, right.unsigned_), expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::DoubleGreaterEqual:
			switch (result.model) {
			case Value::Signed: result.signed_ = Truncate (ShiftRight (result.signed_, right.signed_), expression); break;
			case Value::Unsigned: result.unsigned_ = Truncate (ShiftRight (result.unsigned_, right.unsigned_), expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::AmpersandEqual: case Lexer::AndEq:
			switch (result.model) {
			case Value::Signed: result.signed_ = Truncate (result.signed_ & right.signed_, expression); break;
			case Value::Unsigned: result.unsigned_ = Truncate (result.unsigned_ & right.unsigned_, expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::CaretEqual: case Lexer::XorEq:
			switch (result.model) {
			case Value::Signed: result.signed_ = Truncate (result.signed_ ^ right.signed_, expression); break;
			case Value::Unsigned: result.unsigned_ = Truncate (result.unsigned_ ^ right.unsigned_, expression); break;
			default: assert (Value::Unreachable);
			} break;
		case Lexer::BarEqual: case Lexer::OrEq:
			switch (result.model) {
			case Value::Signed: result.signed_ = Truncate (result.signed_ | right.signed_, expression); break;
			case Value::Unsigned: result.unsigned_ = Truncate (result.unsigned_ | right.unsigned_, expression); break;
			default: assert (Value::Unreachable);
			} break;

		default:
			assert (Lexer::UnreachableOperator);
		}

		return left;
	}

	case Expression::Conversion:
	{
		assert (expression.conversion.expression);
		const auto value = Evaluate (*expression.conversion.expression);

		switch (expression.conversion.model)
		{
		case Conversion::Boolean:
			switch (value.model) {
			case Value::Float: return Boolean (value.float_);
			case Value::Signed: return Boolean (value.signed_);
			case Value::Pointer: return Boolean (value.pointer);
			case Value::Unsigned: return Boolean (value.unsigned_);
			case Value::Reference: return Boolean (value.reference);
			default: assert (Value::Unreachable);
			}
		case Conversion::Pointer:
			assert (IsPointer (expression.type));
			return value;
		case Conversion::Integral:
			switch (value.model) {
			case Value::Signed: if (IsSignedInteger (expression.type)) return Truncate<Signed> (value.signed_, expression); else return Truncate<Unsigned> (value.signed_, expression);
			case Value::Boolean: if (IsSignedInteger (expression.type)) return Signed (value.boolean); else return Unsigned (value.boolean);
			case Value::Unsigned: if (IsSignedInteger (expression.type)) return Truncate<Signed> (value.unsigned_, expression); else return Truncate<Unsigned> (value.unsigned_, expression);
			default: assert (Value::Unreachable);
			}
		case Conversion::NullPointer:
			return nullptr;
		case Conversion::Qualification:
			assert (IsPointer (expression.type) || IsMemberPointer (expression.type));
			return value;
		case Conversion::FloatingPoint:
		case Conversion::FloatingPointPromotion:
			assert (IsFloat (value));
			return Truncate (value.float_, expression);
		case Conversion::ArrayToPointer:
			return ConvertToPointer (value);
		case Conversion::LValueToRValue:
			return Designate (value, *expression.conversion.expression);
		case Conversion::FunctionPointer:
			assert (IsFunctionPointer (expression.type) || IsMemberFunctionPointer (expression.type));
			return value;
		case Conversion::FloatingIntegral:
			switch (value.model) {
			case Value::Float: if (IsSignedInteger (expression.type)) return Truncate (Signed (value.float_), expression); else return Truncate (Unsigned (Signed (value.float_)), expression);
			case Value::Signed: return Truncate (Float (value.signed_), expression);
			case Value::Boolean: return Float (value.boolean);
			case Value::Unsigned: return Truncate (Float (value.unsigned_), expression);
			default: assert (Value::Unreachable);
			}
		case Conversion::FunctionToPointer:
			assert (IsReference (value)); assert (value.reference.entity);
			return value;
		case Conversion::IntegralPromotion:
			switch (value.model) {
			case Value::Signed: if (IsSignedInteger (expression.type)) return Signed (value.signed_); else return Unsigned (value.signed_);
			case Value::Boolean: if (IsSignedInteger (expression.type)) return Signed (value.boolean); else return Unsigned (value.boolean);
			case Value::Unsigned: if (IsSignedInteger (expression.type)) return Signed (value.unsigned_); else return Unsigned (value.unsigned_);
			default: assert (Value::Unreachable);
			}
		case Conversion::NullMemberPointer:
			return nullptr;

		default:
			assert (Expression::UnreachableConversion);
		}
	}

	case Expression::Conditional:
	{
		assert (expression.conditional.left);
		assert (expression.conditional.right);
		assert (expression.conditional.condition);
		const auto value = Evaluate (*expression.conditional.condition); assert (IsBoolean (value));
		return value.boolean ? Evaluate (*expression.conditional.left) : Evaluate (*expression.conditional.right);
	}

	case Expression::Indirection:
		assert (expression.indirection.expression);
		return ConvertToReference (Evaluate (*expression.indirection.expression));

	case Expression::FunctionCall:
	{
		assert (expression.functionCall.expression); Values arguments;
		if (expression.functionCall.arguments) for (auto& argument: *expression.functionCall.arguments) arguments.push_back (Evaluate (argument));
		const auto value = Evaluate (*expression.functionCall.expression); assert (IsReference (value)); assert (value.reference.entity);
		assert (IsFunction (*value.reference.entity)); return Call (*value.reference.entity->function, std::move (arguments), expression.location);
	}

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return Evaluate (*expression.parenthesized.expression);

	case Expression::ConstructorCall:
		assert (expression.constructorCall.expressions);
		if (!IsVoid (expression.type)) return Evaluate (expression.constructorCall.expressions->front ());
		for (auto& argument: *expression.constructorCall.expressions) Evaluate (argument);
		return {};

	case Expression::InlinedFunctionCall:
		assert (expression.inlinedFunctionCall.expression);
		return Evaluate (*expression.inlinedFunctionCall.expression);

	default:
		assert (Expression::Unreachable);
	}
}

void Evaluator::Increment (Value& value, const bool decrement, const Expression& expression)
{
	switch (value.model) {
	case Value::Signed: value.signed_ = Truncate (decrement ? value.signed_ - 1 : value.signed_ + 1, expression); break;
	case Value::Pointer: value.pointer.offset = Truncate (decrement ? value.pointer.offset - 1 : value.pointer.offset + 1, expression); break;
	case Value::Unsigned: value.unsigned_ = Truncate (decrement ? value.unsigned_ - 1 : value.unsigned_ + 1, expression); break;
	default: assert (Value::Unreachable);
	}
}

Value& Evaluator::Designate (const Value& value, const Expression& expression, Signed offset)
{
	assert (IsReference (value)); offset += value.reference.offset;
	if (value.reference.entity) return Dereference (Designate (*value.reference.entity), expression, offset);
	if (value.reference.value) if (!offset) return Dereference (*value.reference.value, expression);
		else throw UndefinedBehavior {expression.location, Format ("invalid element access '%0'", expression)};
	if (value.reference.array) if (Unsigned (offset) < value.reference.array->values.size ()) return value.reference.array->values[offset];
		else throw UndefinedBehavior {expression.location, Format ("array element access '%0' out of bounds", expression)};
	throw UndefinedBehavior {expression.location, Format (offset ? "invalid pointer value '%0'" : "dereferencing null pointer '%0'", expression)};
}

Value& Evaluator::Dereference (Value& value, const Expression& expression, const Signed offset)
{
	return IsReference (value) ? Designate (value, expression, offset) : value;
}

Executor::Executor (const Interpreter& i, TranslationUnit& tu) :
	Evaluator {i}, translationUnit {tu}
{
}

void Executor::Initialize (const Variable& variable, const Initializer& initializer)
{
	assert (!initializer.expressions.empty ()); const auto& expression = initializer.expressions.front (); auto& value = Designate (*variable.entity);
	if (IsCharacterArray (variable.type) && IsStringLiteral (expression)) return StringInitialize (value, variable.type, expression);
	if (IsConstant (expression) && !HasSideEffects (expression)) return void (value = expression.value);
	if (HasStaticStorageDuration (variable)) ZeroInitialize (value, variable.type); value = Evaluate (expression);
}

void Executor::ZeroInitialize (const Variable& variable)
{
	ZeroInitialize (Designate (*variable.entity), variable.type);
}

void Executor::ZeroInitialize (Value& value, const Type& type)
{
	assert (!IsValid (value));

	switch (type.model)
	{
	case Type::Character: case Type::UnsignedCharacter: case Type::Character16: case Type::Character32: case Type::WideCharacter:
	case Type::UnsignedShortInteger: case Type::UnsignedInteger: case Type::UnsignedLongInteger: case Type::UnsignedLongLongInteger:
		value = Unsigned {0};
		break;

	case Type::SignedCharacter:
	case Type::ShortInteger: case Type::Integer: case Type::LongInteger: case Type::LongLongInteger:
		value = Signed {0};
		break;

	case Type::Boolean:
		value = false;
		break;

	case Type::Float: case Type::Double: case Type::LongDouble:
		value = Float (0);
		break;

	case Type::NullPointer:
	case Type::Pointer:
	case Type::MemberPointer:
		value = nullptr;
		break;

	case Type::Enumeration:
		if (IsSignedInteger (type.enumeration->underlyingType)) value = Signed {0}; else value = Unsigned {0};
		break;

	case Type::Array:
	{
		auto& array = translationUnit.Create<Array> (*type.array.elementType); value = array;
		while (array.values.size () != type.array.bound) ZeroInitialize (array.values.emplace_back (), array.elementType);
		break;
	}

	default:
		assert (Type::Unreachable);
	}
}

void Executor::DefaultInitialize (const Variable& variable)
{
	DefaultInitialize (Designate (*variable.entity), variable.type);
}

void Executor::DefaultInitialize (Value& value, const Type& type)
{
	assert (!IsValid (value)); if (!IsArray (type)) return;
	auto& array = translationUnit.Create<Array> (*type.array.elementType); value = array; array.values.resize (type.array.bound);
}

void Executor::StringInitialize (Value& value, const Type& type, const Expression& expression)
{
	assert (IsCharacterArray (type)); assert (IsReference (expression.value)); auto& array = *expression.value.reference.array; value = array;
	while (array.values.size () != type.array.bound) ZeroInitialize (array.values.emplace_back (), *type.array.elementType);
}

Value Executor::Evaluate (const Condition& condition)
{
	if (condition.declaration) Execute (*condition.declaration);
	assert (condition.expression); return Evaluate (*condition.expression);
}

Value Executor::Evaluate (const Expression& expression)
{
	return IsConstant (expression) && !HasSideEffects (expression) ? expression.value : Evaluator::Evaluate (expression);
}

Value& Executor::Designate (const Entity& entity)
{
	switch (entity.model)
	{
	case Entity::Variable:
		if (HasStaticStorageDuration (*entity.variable)) return entity.variable->value;
		assert (current); assert (entity.variable->index < current->variables.size ());
		return current->variables[entity.variable->index];

	case Entity::Parameter:
		assert (current); assert (entity.parameter->parameter->index < current->parameters.size ());
		return current->parameters[entity.parameter->parameter->index];

	default:
		assert (Entity::Unreachable);
	}
}

Value Executor::Call (const Function& function, Values&& parameters, const Location& location)
{
	assert (function.body); StackFrame stackFrame {current, function, std::move (parameters)};
	if (stackFrame.depth > 512) throw UndefinedBehavior {location, "excessive function call nesting"};
	const Restore restoreStackFrame {current, &stackFrame}; Execute (*function.body);
	if (RequiresReturnValue (function) && !IsValid (stackFrame.returnValue)) throw UndefinedBehavior {location, "invalid return value"};
	return stackFrame.returnValue;
}

void Executor::Execute (const FunctionBody& body)
{
	switch (body.model)
	{
	case FunctionBody::Regular:
		assert (body.regular.block);
		Execute (*body.regular.block);
		break;

	default:
		assert (FunctionBody::Unreachable);
	}
}

void Executor::Execute (const Instruction& instruction)
{
	for (auto current = instruction; current.statement && current.phase;)
		current = (this->*current.phase) (*current.statement);
}

Instruction Executor::Execute (const Statement& statement)
{
	switch (statement.model)
	{
	case Statement::Do:
		assert (statement.do_.statement);
		return *statement.do_.statement;

	case Statement::If:
		assert (statement.if_.statement);
		if (Evaluate (statement.if_.condition).boolean) return *statement.if_.statement;
		if (statement.if_.elseStatement) return *statement.if_.elseStatement;
		return {statement, &Executor::Advance};

	case Statement::For:
		assert (statement.for_.initStatement); Execute (*statement.for_.initStatement); assert (statement.for_.statement);
		if (!statement.for_.condition || Evaluate (*statement.for_.condition).boolean) return *statement.for_.statement;
		return {statement, &Executor::Advance};

	case Statement::Case:
	case Statement::Null:
	case Statement::Label:
	case Statement::Default:
		return {statement, &Executor::Advance};

	case Statement::Goto:
		assert (statement.goto_.entity);
		assert (IsLabel (*statement.goto_.entity));
		return {*statement.goto_.entity->label->statement, &Executor::Advance};

	case Statement::Break:
		return {*GetEnclosingBreakable (statement), &Executor::Advance};

	case Statement::While:
		return {statement, &Executor::Continue};

	case Statement::Switch:
	{
		assert (statement.switch_.statement); assert (statement.switch_.caseTable);
		const auto label = statement.switch_.caseTable->find (Evaluate (statement.switch_.condition).signed_);
		if (label != statement.switch_.caseTable->end ()) return {*label->second, &Executor::Advance};
		if (statement.switch_.defaultLabel) return {*statement.switch_.defaultLabel, &Executor::Advance};
		return {statement, &Executor::Advance};
	}

	case Statement::Return:
		assert (current); if (statement.return_.expression) current->returnValue = Evaluate (*statement.return_.expression);
		if (IsLocalReference (current->returnValue, current->function)) throw UndefinedBehavior {statement.location, Format ("returning reference to local %0", *current->returnValue.reference.entity)};
		return {statement, nullptr};

	case Statement::Compound:
		assert (statement.compound.block);
		return *statement.compound.block;

	case Statement::Continue:
		return {*GetEnclosingIteration (statement), &Executor::Continue};

	case Statement::Expression:
		assert (statement.expression);
		Evaluate (*statement.expression);
		return {statement, &Executor::Advance};

	case Statement::Declaration:
		assert (statement.declaration);
		Execute (*statement.declaration);
		return {statement, &Executor::Advance};

	default:
		assert (Statement::Unreachable);
	}
}

Instruction Executor::Continue (const Statement& statement)
{
	switch (statement.model)
	{
	case Statement::Do:
		assert (statement.do_.condition); assert (statement.do_.statement);
		if (Evaluate (*statement.do_.condition).boolean) return *statement.do_.statement;
		return {statement, &Executor::Advance};

	case Statement::For:
		assert (statement.for_.statement);
		if (statement.for_.expression) Evaluate (*statement.for_.expression);
		if (!statement.for_.condition || Evaluate (*statement.for_.condition).boolean) return *statement.for_.statement;
		return {statement, &Executor::Advance};

	case Statement::While:
		assert (statement.while_.statement);
		if (Evaluate (statement.while_.condition).boolean) return *statement.while_.statement;
		return {statement, &Executor::Advance};

	default:
		assert (Statement::Unreachable);
	}
}

Instruction Executor::Advance (const Statement& statement)
{
	if (const auto next = GetNext (statement)) return {*next, &Executor::Execute};
	if (const auto enclosing = GetEnclosing (statement)) return {*enclosing, IsIteration (*enclosing) ? &Executor::Continue : &Executor::Advance};
	return {statement, nullptr};
}

void Executor::Execute (const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Asm:
		EmitError (declaration.location, "executing asm declaration");

	case Declaration::Alias:
	case Declaration::Empty:
	case Declaration::Using:
	case Declaration::Template:
	case Declaration::Attribute:
	case Declaration::OpaqueEnum:
	case Declaration::UsingDirective:
	case Declaration::StaticAssertion:
	case Declaration::NamespaceAliasDefinition:
		break;

	case Declaration::Simple:
		if (declaration.simple.declarators)
			for (auto& declarator: *declaration.simple.declarators) Execute (declarator);
		break;

	case Declaration::Condition:
		assert (declaration.condition.entity); assert (declaration.condition.initializer);
		Initialize (*declaration.condition.entity->variable, *declaration.condition.initializer);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Executor::Execute (const InitDeclarator& declarator)
{
	assert (declarator.entity); if (declarator.isDeclaration) return;
	assert (IsVariable (*declarator.entity)); const auto& variable = *declarator.entity->variable;
	if (HasStaticStorageDuration (variable)) return; assert (IsBlock (*variable.entity->enclosingScope));
	if (HasInitializer (declarator)) Initialize (variable, *declarator.initializer); else DefaultInitialize (variable);
}

StackFrame::StackFrame (StackFrame*const pr, const Function& f, Values&& pa) :
	previous {pr}, function {f}, variables (function.variables), parameters {std::move (pa)}, depth {previous ? previous->depth + 1 : 1}
{
}

Instruction::Instruction (const Statement& s, const Phase p) :
	statement {&s}, phase {p}
{
}

Instruction::Instruction (const StatementBlock& block)
{
	if (!block.statements.empty ()) statement = &block.statements.front (), phase = &Executor::Execute;
	else statement = block.enclosingStatement, phase = statement && IsIteration (*statement) ? &Executor::Continue : &Executor::Advance;
}

Thread::Thread (Context& c) :
	Executor {c.interpreter, c.translationUnit}, context {c}
{
}

void Thread::Start (const Function& function, Values&& arguments)
{
	Call (function, std::move (arguments), function.entity->location);
}

void Thread::Join ()
{
}

template <typename Definition>
Definition& Thread::Designate (const Entity& entity, std::unordered_map<String, Definition>& definitions)
{
	const auto iterator = definitions.find (GetName (entity));
	if (iterator != definitions.end ()) return iterator->second;
	EmitError (entity.location, Format ("missing definition for %0", entity));
}

Value& Thread::Designate (const Entity& entity)
{
	return IsVariable (entity) && HasStaticStorageDuration (*entity.variable) ? Designate (entity, context.variables) : Executor::Designate (entity);
}

Value Thread::Call (const Function& function, Values&& arguments, const Location& location)
{
	const auto definition = Designate (*function.entity, context.functions);
	if (definition == context.abort) context.Abort ();
	if (definition == context.exit) assert (arguments.size () >= 1), context.Exit (arguments[0]);
	if (definition == context.fputc) return assert (arguments.size () >= 2), context.Fputc (arguments[0], arguments[1]);
	if (definition == context.getchar) return context.Getchar ();
	if (definition == context.putchar) return assert (arguments.size () >= 1), context.Putchar (arguments[0]);
	return Executor::Call (*definition, std::move (arguments), location);
}

Signed MainThread::Start (Array& arguments)
{
	try {CallMain (arguments);} catch (const Signed status) {return status;}
	catch (const UndefinedBehavior& error) {EmitError (error.location, error.message);}
}

void MainThread::CallMain (Array& arguments)
{
	for (auto& translationUnit: context.translationUnits) Define (translationUnit);
	if (!main) EmitError ({context.translationUnit.source, {}}, "missing main function"); assert (IsMain (*main));
	assert (!arguments.values.empty ()); for (auto& argument: arguments.values) assert (IsPointer (argument));
	const auto result = Call (*main, {Signed (arguments.values.size () - 1), ConvertToPointer (arguments)}, main->entity->location);
	context.Exit (IsValid (result) ? result : Signed {0});
}

void MainThread::Define (const TranslationUnit& translationUnit)
{
	Define (translationUnit.declarations);
}

void MainThread::Define (const Declarations& declarations)
{
	for (auto& declaration: declarations) Define (declaration);
}

void MainThread::Define (const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Asm:
		EmitError (declaration.location, "executing asm declaration");

	case Declaration::Alias:
	case Declaration::Empty:
	case Declaration::Using:
	case Declaration::Template:
	case Declaration::Attribute:
	case Declaration::OpaqueEnum:
	case Declaration::UsingDirective:
	case Declaration::StaticAssertion:
	case Declaration::NamespaceAliasDefinition:
		break;

	case Declaration::Simple:
		if (declaration.simple.declarators)
			for (auto& declarator: *declaration.simple.declarators) Define (declarator);
		break;

	case Declaration::FunctionDefinition:
	{
		assert (declaration.functionDefinition.entity); assert (declaration.functionDefinition.entity->function);
		const auto& function = *declaration.functionDefinition.entity->function;
		if (Define (function)) Define (*function.func), Define (*function.body);
		if (IsMain (function)) main = &function;
		break;
	}

	case Declaration::NamespaceDefinition:
		if (declaration.namespaceDefinition.body) Define (*declaration.namespaceDefinition.body);
		break;

	case Declaration::LinkageSpecification:
		if (declaration.linkageSpecification.declaration) Define (*declaration.linkageSpecification.declaration);
		else if (declaration.linkageSpecification.declarations) Define (*declaration.linkageSpecification.declarations);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void MainThread::Define (const FunctionBody& body)
{
	switch (body.model)
	{
	case FunctionBody::Regular:
		assert (body.regular.block);
		return Define (*body.regular.block);

	default:
		assert (FunctionBody::Unreachable);
	}
}

void MainThread::Define (const StatementBlock& block)
{
	for (auto& statement: block.statements) Define (statement);
}

void MainThread::Define (const Statement& statement)
{
	switch (statement.model)
	{
	case Statement::Do:
		assert (statement.do_.statement);
		Define (*statement.do_.statement);
		break;

	case Statement::If:
		assert (statement.if_.statement);
		Define (*statement.if_.statement);
		if (statement.if_.elseStatement) Define (*statement.if_.elseStatement);
		break;

	case Statement::For:
		assert (statement.for_.initStatement); assert (statement.for_.statement);
		Define (*statement.for_.initStatement); Define (*statement.for_.statement);
		break;

	case Statement::Case:
	case Statement::Goto:
	case Statement::Null:
	case Statement::Break:
	case Statement::Label:
	case Statement::Return:
	case Statement::Default:
	case Statement::Continue:
	case Statement::Expression:
		break;

	case Statement::While:
		assert (statement.while_.statement);
		Define (*statement.while_.statement);
		break;

	case Statement::Switch:
		assert (statement.switch_.statement);
		Define (*statement.switch_.statement);
		break;

	case Statement::Compound:
		assert (statement.compound.block);
		Define (*statement.compound.block);
		break;

	case Statement::Declaration:
		assert (statement.declaration);
		Define (*statement.declaration);
		break;

	default:
		assert (Statement::Unreachable);
	}
}

void MainThread::Define (const InitDeclarator& declarator)
{
	assert (declarator.entity); if (declarator.isDeclaration) return;
	assert (IsVariable (*declarator.entity)); const auto& variable = *declarator.entity->variable;
	if (!HasStaticStorageDuration (variable) || !Define (variable, {})) return;
	if (HasInitializer (declarator)) Initialize (variable, *declarator.initializer); else ZeroInitialize (variable);
}

bool MainThread::Define (const Function& function)
{
	assert (function.body); const auto& entity = *function.entity;
	if (context.variables.find (GetName (entity)) != context.variables.end ()) EmitError (entity.location, Format ("%0 already defined as variable", entity));
	if (context.functions.emplace (GetName (entity), &function).second) return true;
	if (IsInline (function) || IsReplaceable (entity)) return false;
	EmitError (entity.location, Format ("redefinition of %0", entity));
}

bool MainThread::Define (const Variable& variable, const Value& value)
{
	const auto& entity = *variable.entity;
	if (context.functions.find (GetName (entity)) != context.functions.end ()) EmitError (entity.location, Format ("%0 already defined as function", entity));
	if (context.variables.emplace (GetName (entity), value).second) return true;
	if (IsInline (variable) || IsReplaceable (entity)) return false;
	EmitError (entity.location, Format ("redefinition of %0", entity));
}

void MainThread::Define (const Variable& variable)
{
	assert (IsPredefined (*variable.entity)); assert (IsValid (variable.value));
	if (IsUsed (*variable.entity)) Define (variable, variable.value);
}

Context::Context (const Interpreter& i, const TranslationUnits& tu, const Source& s, Environment& e) :
	interpreter {i}, translationUnit {s}, translationUnits {tu}, environment {e}
{
	static Type integer {Type::Integer}, void_ {Type::Void}, voidPointer {&void_};
	static Types voidParameter {}, integerParameter {integer};
	auto& std = DefineNamespace ("std", translationUnit.global.scope);
	#define DefineStandardFunction(name, type, types) DefineStandardFunctionAlias (name, name, type, types)
	#define DefineStandardFunctionAlias(name, alias, type, types) name = &DefineFunction (#alias, {type, types, LanguageLinkage::C}, std.scope);
	DefineStandardFunction (abort, void_, voidParameter);
	DefineStandardFunctionAlias (exit, _Exit, void_, integerParameter);
	DefineStandardFunction (fputc, integer, integerParameter);
	DefineStandardFunction (getchar, integer, voidParameter);
	DefineStandardFunction (putchar, integer, integerParameter);
	#undef DefineStandardFunction
	#undef DefineStandardFunctionAlias
	#define DefineStandardVariable(name, type, ...) DefineVariable (#name, type, LanguageLinkage::C, __VA_ARGS__, std.scope);
	DefineStandardVariable (stderr, voidPointer, {nullptr, 2});
	DefineStandardVariable (stdin, voidPointer, {nullptr, 0});
	DefineStandardVariable (stdout, voidPointer, {nullptr, 1});
	#undef DefineStandardVariable
}

void Context::Abort ()
{
	Exit (Signed {1});
}

void Context::Exit (const Value& status)
{
	assert (IsSigned (status)); throw status.signed_;
}

Value Context::Fputc (const Value& character, const Value& stream)
{
	assert (IsSigned (character)); assert (IsPointer (stream));
	return Signed (stream.pointer.value ? -1 : environment.Fputc (character.signed_, stream.pointer.offset));
}

Value Context::Getchar ()
{
	return Signed (environment.Getchar ());
}

Value Context::Putchar (const Value& character)
{
	assert (IsSigned (character));
	return Signed (environment.Putchar (character.signed_));
}

Entity& Context::Define (const Entity::Model model, const char*const identifier, Scope& scope)
{
	auto& entity = translationUnit.Create<Entity> (model, Name {interpreter.stringPool.Insert (identifier)}, Location {translationUnit.source, {}}, scope);
	assert (IsNamespace (scope)); scope.symbolTable.emplace (entity.name, &entity); return entity;
}

Namespace& Context::DefineNamespace (const char*const identifier, Scope& scope)
{
	auto& entity = Define (Entity::Namespace, identifier, scope);
	translationUnit.Create (entity.namespace_, &scope, false, &entity, 0u); return *entity.namespace_;
}

Function& Context::DefineFunction (const char*const identifier, const Type& type, Scope& scope)
{
	assert (IsFunction (type));
	auto& entity = Define (Entity::Function, identifier, scope);
	translationUnit.Create (entity.function, type, entity, interpreter.platform);
	functions.emplace (GetName (entity), entity.function); return *entity.function;
}

Variable& Context::DefineVariable (const char*const identifier, const Type& type, const LanguageLinkage linkage, const Value& value, Scope& scope)
{
	auto& entity = Define (Entity::Variable, identifier, scope);
	translationUnit.Create (entity.variable, type, entity, linkage, interpreter.platform);
	variables.emplace (GetName (entity), value); return *entity.variable;
}

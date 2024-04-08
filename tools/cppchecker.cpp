// C++ semantic checker
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

#include "cppchecker.hpp"
#include "cppexecutor.hpp"
#include "cppprinter.hpp"
#include "error.hpp"
#include "format.hpp"
#include "stringpool.hpp"
#include "utilities.hpp"

using namespace ECS;
using namespace CPP;

using Context =
	#include "cppcheckercontext.hpp"

struct Context::Expansion
{
	std::map<const ParameterDeclaration*, const Variable*> map;
};

Checker::Checker (Diagnostics& d, StringPool& sp, Charset& c, Platform& p) :
	Interpreter {d, sp, p}, size {platform.GetUnsigned (Type::NullPointer)}, difference {platform.GetSigned (Type::NullPointer)},
	defaultNewAlignment {platform.GetSize (size)}, charset {c}, main {stringPool.Insert ("main")}, func {stringPool.Insert ("__func__")},
	final {stringPool.Insert ("final")}, override {stringPool.Insert ("override")}, std {stringPool.Insert ("std")}
{
}

Context::Context (const Checker& c, TranslationUnit& tu) :
	Evaluator {c}, translationUnit {tu}, checker {c}, currentScope {&translationUnit.global.scope}
{
}

void Context::EmitNote (const Location& location, const Message& message) const
{
	location.Emit (Diagnostics::Note, checker.diagnostics, message);
}

void Context::EmitWarning (const Location& location, const Message& message) const
{
	location.Emit (Diagnostics::Warning, checker.diagnostics, message);
}

void Context::EmitError (const Location& location, const Message& message) const
{
	location.Emit (Diagnostics::Error, checker.diagnostics, message); throw Error {};
}

void Context::EmitErrorNote (const Location& location, const Message& message) const
{
	location.Emit (Diagnostics::Error, checker.diagnostics, message);
}

void Context::EmitWarning (const Location& location, const Message& message, const Location& declaration) const
{
	EmitWarning (location, message); EmitNote (declaration, "declared here");
}

void Context::EmitError (const Location& location, const Message& message, const Location& declaration) const
{
	EmitErrorNote (location, message); EmitNote (declaration, "declared here"); throw Error {};
}

void Context::EmitError (const bool warnOnly, const Location& location, const Message& message) const
{
	if (warnOnly) EmitWarning (location, message); else EmitError (location, message);
}

void Context::EmitError (const bool warnOnly, const Location& location, const Message& message, const Location& declaration) const
{
	if (warnOnly) EmitWarning (location, message, declaration); else EmitError (location, message, declaration);
}

void Context::FinalizeChecks ()
{
	for (auto& inlineUse: inlineUses)
		if (!IsDefined (inlineUse.entity)) EmitError (inlineUse.location, Format ("using undefined inline %0", inlineUse.entity), inlineUse.entity.location);
}

void Context::Check (Expression& expression)
{
	switch (expression.model)
	{
	case Expression::New:
	{
		assert (expression.new_.typeIdentifier);
		const auto& type = expression.new_.typeIdentifier->type;
		if (!IsObject (type) || IsIncomplete (type)) EmitError (expression.location, Format ("allocating object of type %0", type));
		return Classify (expression, IsArray (type) ? type.array.elementType : &type, ValueCategory::PRValue, true, true, false);
	}

	case Expression::Cast:
		assert (expression.cast.expression);
		ConvertPRValue (*expression.cast.expression, expression.cast.expression->type);
		return Classify (expression, expression.cast.typeIdentifier->type, ValueCategory::PRValue, HasSideEffects (*expression.cast.expression), IsPotentiallyThrowing (*expression.cast.expression), false);

	case Expression::This:
		if (!enclosingMemberDeclarators.empty ())
			if (!IsNonStaticMember (*enclosingMemberDeclarators.back ()->entity)) EmitError (expression.location, Format ("using '%0' in initializer of static member", expression));
			else return Classify (expression, &translationUnit.Create<Type> (*currentScope->class_), ValueCategory::PRValue, false, false, false);
		if (!currentFunction || !IsNonStaticMember (*currentFunction->entity)) EmitError (expression.location, Format ("using '%0' outside non-static member function", expression));
		return Classify (expression, &translationUnit.Create<Type> (*currentFunction->entity->enclosingScope->class_, currentFunction->type.function.constVolatileQualifiers), ValueCategory::PRValue, false, false, false);

	case Expression::Comma:
		assert (expression.comma.left);
		assert (expression.comma.right);
		CheckDiscarded (*expression.comma.left);
		return Classify (expression, expression.comma.right->type, expression.comma.right->category, HasSideEffects (*expression.comma.left) || HasSideEffects (*expression.comma.right), IsPotentiallyThrowing (*expression.comma.left) || IsPotentiallyThrowing (*expression.comma.right), IsBitField (*expression.comma.right));

	case Expression::Throw:
		return Classify (expression, Type::Void, ValueCategory::PRValue, true, true, false);

	case Expression::Unary:
	{
		assert (expression.unary.operand);
		auto& operand = *expression.unary.operand;
		ConvertPRValue (operand, operand.type);

		switch (expression.unary.operator_.symbol)
		{
		case Lexer::Plus:
			if (!IsArithmetic (operand.type) && !IsUnscopedEnumeration (operand.type) && !IsPointer (operand.type))
				EmitError (expression.location, Format ("'%0' applied on %1", expression, operand.type));
			if (IsIntegral (operand.type) || IsEnumeration (operand.type)) PromoteIntegral (operand, Type::Integer);
			return Classify (expression, operand.type, ValueCategory::PRValue, HasSideEffects (operand), IsPotentiallyThrowing (operand), false);

		case Lexer::Minus:
			if (!IsArithmetic (operand.type) && !IsUnscopedEnumeration (operand.type))
				EmitError (expression.location, Format ("'%0' applied on %1", expression, operand.type));
			if (IsIntegral (operand.type) || IsEnumeration (operand.type)) PromoteIntegral (operand, Type::Integer);
			return Classify (expression, operand.type, ValueCategory::PRValue, HasSideEffects (operand), IsPotentiallyThrowing (operand), false);

		case Lexer::ExclamationMark: case Lexer::Not:
			Convert (operand, Type::Boolean);
			return Classify (expression, Type::Boolean, ValueCategory::PRValue, HasSideEffects (operand), IsPotentiallyThrowing (operand), false);

		case Lexer::Tilde: case Lexer::Compl:
			if (!IsIntegral (operand.type) && !IsUnscopedEnumeration (operand.type))
				EmitError (expression.location, Format ("'%0' applied on %1", expression, operand.type));
			PromoteIntegral (operand, Type::Integer);
			return Classify (expression, operand.type, ValueCategory::PRValue, HasSideEffects (operand), IsPotentiallyThrowing (operand), false);

		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Binary:
	{
		assert (expression.binary.left);
		assert (expression.binary.right);

		auto& left = *expression.binary.left;
		auto& right = *expression.binary.right;
		ConvertPRValue (left, left.type); ConvertPRValue (right, right.type);

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::Plus:
			if (IsPointer (left.type))
				if (!IsObject (*left.type.pointer.baseType) || IsIncomplete (*left.type.pointer.baseType)) EmitError (expression.location, Format ("using invalid pointer type %0 in binary expression '%1'", left.type, expression));
				else if (!IsIntegral (right.type) && !IsUnscopedEnumeration (right.type)) EmitError (expression.location, Format ("incompatible operand types %0 and %1 for binary expression '%2'", left.type, right.type, expression));
				else return Convert (right, checker.difference), Classify (expression, left.type, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);
			if (IsPointer (right.type))
				if (!IsObject (*right.type.pointer.baseType) || IsIncomplete (*right.type.pointer.baseType)) EmitError (expression.location, Format ("using invalid pointer type %0 in binary expression '%1'", right.type, expression));
				else if (!IsIntegral (left.type) && !IsUnscopedEnumeration (left.type)) EmitError (expression.location, Format ("incompatible operand types %0 and %1 for binary expression '%2'", left.type, right.type, expression));
				else return Convert (left, checker.difference), Classify (expression, right.type, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);
			ConvertArithmetic (expression);
			return Classify (expression, left.type, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);

		case Lexer::Minus:
			if (IsPointer (right.type))
				if (!IsObject (*right.type.pointer.baseType) || IsIncomplete (*right.type.pointer.baseType)) EmitError (expression.location, Format ("using invalid pointer type %0 in binary expression '%1'", right.type, expression));
				else if (!IsPointer (left.type) || RemoveQualifiers (*left.type.pointer.baseType) != RemoveQualifiers (*right.type.pointer.baseType)) EmitError (expression.location, Format ("incompatible operand types %0 and %1 for binary expression '%2'", left.type, right.type, expression));
				else return Classify (expression, checker.difference, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);
			if (IsPointer (left.type))
				if (!IsObject (*left.type.pointer.baseType) || IsIncomplete (*left.type.pointer.baseType)) EmitError (expression.location, Format ("using invalid pointer type %0 in binary expression '%1'", left.type, expression));
				else if (!IsIntegral (right.type) && !IsUnscopedEnumeration (right.type)) EmitError (expression.location, Format ("incompatible operand types %0 and %1 for binary expression '%2'", left.type, right.type, expression));
				else return Convert (right, checker.difference), Classify (expression, left.type, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);
			ConvertArithmetic (expression);
			return Classify (expression, left.type, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);

		case Lexer::Asterisk: case Lexer::Slash:
			ConvertArithmetic (expression);
			return Classify (expression, left.type, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);

		case Lexer::Percent:
		case Lexer::DoubleLess: case Lexer::DoubleGreater:
		case Lexer::Ampersand: case Lexer::Bitand:
		case Lexer::Caret: case Lexer::Xor:
		case Lexer::Bar: case Lexer::Bitor:
			ConvertArithmetic (expression);
			if (!IsIntegral (left.type) && !IsUnscopedEnumeration (left.type) || !IsIntegral (right.type) && !IsUnscopedEnumeration (right.type))
				EmitError (expression.location, Format ("incompatible operand types %0 and %1 for binary expression '%2'", left.type, right.type, expression));
			return Classify (expression, left.type, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);

		case Lexer::DoubleEqual:
		case Lexer::ExclamationMarkEqual: case Lexer::NotEq:
			if (IsPointer (left.type) || IsPointer (right.type)) ConvertPointer (left, right.type), ConvertPointer (right, left.type);
			ConvertArithmetic (expression);
			return Classify (expression, Type::Boolean, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);

		case Lexer::Less: case Lexer::Greater:
		case Lexer::LessEqual: case Lexer::GreaterEqual:
			ConvertArithmetic (expression);
			return Classify (expression, Type::Boolean, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);

		case Lexer::DoubleAmpersand: case Lexer::And:
			Convert (left, Type::Boolean); Convert (right, Type::Boolean);
			return Classify (expression, Type::Boolean, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right) && !IsFalse (left), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);

		case Lexer::DoubleBar: case Lexer::Or:
			Convert (left, Type::Boolean); Convert (right, Type::Boolean);
			return Classify (expression, Type::Boolean, ValueCategory::PRValue, HasSideEffects (left) || HasSideEffects (right) && !IsTrue (left), IsPotentiallyThrowing (left) || IsPotentiallyThrowing (right), false);

		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Prefix:
		assert (expression.prefix.expression);
		CheckIncrement (*expression.prefix.expression, expression.prefix.operator_);
		return Classify (expression, expression.prefix.expression->type, ValueCategory::LValue, true, IsPotentiallyThrowing (*expression.prefix.expression), IsBitField (*expression.prefix.expression));

	case Expression::Alignof:
		assert (expression.alignof_.typeIdentifier);
		CheckAlignment (expression.alignof_.typeIdentifier->type, expression.location);
		return Classify (expression, checker.size, ValueCategory::PRValue, false, false, false);

	case Expression::Literal:
		switch (expression.literal.token.symbol)
		{
		case Lexer::Nullptr:
			Assign (expression, nullptr);
			return Classify (expression, Type::NullPointer, ValueCategory::PRValue, false, false, false);

		case Lexer::True: case Lexer::False:
			Assign (expression, expression.literal.token.symbol == Lexer::True);
			return Classify (expression, Type::Boolean, ValueCategory::PRValue, false, false, false);

		case Lexer::BinaryInteger: case Lexer::OctalInteger: case Lexer::DecimalInteger: case Lexer::HexadecimalInteger:
		{
			bool isUnsigned, isLong, isLongLong; Unsigned value;
			if (!HasIntegerSuffix (expression.literal.token, isUnsigned, isLong, isLongLong))
				isUnsigned = isLong = isLongLong = false;
			if (!Lexer::Evaluate (expression.literal.token, value))
				EmitError (expression.location, Format ("%0 cannot be represented by any integral type", expression.literal.token));

			Type type;
			if (!isUnsigned && !isLong && !isLongLong && TruncatesPreserving<Signed> (value, checker.platform.GetBits (Type::Integer)))
				type = Type::Integer;
			else if ((isUnsigned || expression.literal.token.symbol != Lexer::DecimalInteger) && !isLong && !isLongLong && TruncatesPreserving<Unsigned> (value, checker.platform.GetBits (Type::UnsignedInteger)))
				type = Type::UnsignedInteger;
			else if (!isUnsigned && !isLongLong && TruncatesPreserving<Signed> (value, checker.platform.GetBits (Type::LongInteger)))
				type = Type::LongInteger;
			else if ((isUnsigned || expression.literal.token.symbol != Lexer::DecimalInteger) && !isLongLong && TruncatesPreserving<Unsigned> (value, checker.platform.GetBits (Type::UnsignedLongInteger)))
				type = Type::UnsignedLongInteger;
			else if (!isUnsigned && TruncatesPreserving<Signed> (value, checker.platform.GetBits (Type::LongLongInteger)))
				type = Type::LongLongInteger;
			else if (TruncatesPreserving<Unsigned> (value, checker.platform.GetBits (Type::UnsignedLongLongInteger)))
				type = Type::UnsignedLongLongInteger;
			else
				EmitError (expression.location, Format ("%0 cannot be represented by type '%1'", expression.literal.token, Type::UnsignedLongLongInteger));

			Assign (expression, IsSignedInteger (type) ? Signed (value) : Value {value});
			return Classify (expression, type, ValueCategory::PRValue, false, false, false);
		}

		case Lexer::DecimalFloating: case Lexer::HexadecimalFloating:
		{
			bool isFloat, isLongDouble; Float value;
			if (!HasFloatingSuffix (expression.literal.token, isFloat, isLongDouble))
				isFloat = isLongDouble = false;
			if (!Lexer::Evaluate (expression.literal.token, value))
				EmitError (expression.location, Format ("%0 cannot be represented by any floating-point type", expression.literal.token));

			const Type type {isFloat ? Type::Float : isLongDouble ? Type::LongDouble : Type::Double};
			if (!TruncatesPreserving (value, checker.platform.GetBits (type)))
				EmitError (expression.location, Format ("%0 cannot be represented by type '%1'", expression.literal.token, type));

			Assign (expression, value);
			return Classify (expression, type, ValueCategory::PRValue, false, false, false);
		}

		case Lexer::NarrowCharacter: case Lexer::Char8TCharacter: case Lexer::Char16TCharacter: case Lexer::Char32TCharacter: case Lexer::WideCharacter:
		{
			if (expression.literal.token.literal->size () > 1) EmitError (expression.literal.token.symbol == Lexer::NarrowCharacter || expression.literal.token.symbol == Lexer::WideCharacter,
				expression.location, Format ("%0 containing multiple characters", expression.literal.token));

			Type type;
			if (expression.literal.token.symbol == Lexer::Char16TCharacter) type = Type::Character16;
			else if (expression.literal.token.symbol == Lexer::Char32TCharacter) type = Type::Character32;
			else if (expression.literal.token.symbol == Lexer::WideCharacter) type = Type::WideCharacter;
			else type = expression.literal.token.literal->size () > 1 ? Type::Integer : Type::Character;

			const auto value = Lexer::Evaluate (expression.literal.token, checker.charset);
			if (!TruncatesPreserving (value, expression.literal.token.symbol == Lexer::Char8TCharacter ? 7 : checker.platform.GetBits (type)))
				EmitError (expression.location, Format ("%0 cannot be represented by type '%1'", expression.literal.token, type));

			Assign (expression, IsSignedInteger (type) ? Signed (value) : Value {value});
			return Classify (expression, type, ValueCategory::PRValue, false, false, false);
		}

		default:
			assert (Lexer::UnreachableLiteral);
		}

	case Expression::Postfix:
		assert (expression.postfix.expression);
		CheckIncrement (*expression.postfix.expression, expression.postfix.operator_);
		return Classify (expression, expression.postfix.expression->type, ValueCategory::PRValue, true, IsPotentiallyThrowing (*expression.postfix.expression), false);

	case Expression::Noexcept:
		return Classify (expression, Type::Boolean, ValueCategory::PRValue, false, false, false);

	case Expression::Addressof:
	{
		assert (expression.addressof.expression); const auto& operand = *expression.addressof.expression;
		if (IsBitField (operand)) EmitError (expression.location, Format ("taking address of bit-field '%0'", operand));
		if (IsIdentifier (operand) && IsQualified (*operand.identifier.identifier) && IsNonStaticMember (*operand.identifier.entity))
			return Classify (expression, {&operand.identifier.entity->storage->type, operand.identifier.entity->enclosingScope->class_}, ValueCategory::PRValue, false, false, false);
		if (!IsLValue (operand)) EmitError (expression.location, Format ("expression '%0' is not addressable", operand));
		return Classify (expression, &operand.type, ValueCategory::PRValue, HasSideEffects (operand), IsPotentiallyThrowing (operand), false);
	}

	case Expression::Subscript:
	{
		assert (expression.subscript.left);
		assert (expression.subscript.right);

		if (IsArray (expression.subscript.left->type) || IsPointer (expression.subscript.left->type))
			expression.subscript.array = expression.subscript.left, expression.subscript.index = expression.subscript.right;
		else if (IsArray (expression.subscript.right->type) || IsPointer (expression.subscript.right->type))
			expression.subscript.array = expression.subscript.right, expression.subscript.index = expression.subscript.left;
		else
			EmitError (expression.location, Format ("subscript expression '%0' applied on type %1", expression, expression.subscript.left->type));

		if (!IsIntegral (expression.subscript.index->type) && !IsUnscopedEnumeration (expression.subscript.index->type))
			EmitError (expression.location, Format ("subscript expression '%0' using index of type %1", expression, expression.subscript.index->type));
		Convert (*expression.subscript.index, checker.difference);

		const auto& type = expression.subscript.array->type;
		return Classify (expression, IsArray (type) ? *type.array.elementType : *type.pointer.baseType, !IsArray (type) || IsLValue (*expression.subscript.array) ? ValueCategory::LValue : ValueCategory::XValue,
			HasSideEffects (*expression.subscript.left) || HasSideEffects (*expression.subscript.right), IsPotentiallyThrowing (*expression.subscript.left) || IsPotentiallyThrowing (*expression.subscript.right), false);
	}

	case Expression::Typetrait:
	{
		assert (expression.typetrait.stringLiteral);
		const auto typetrait = Concatenate (*expression.typetrait.stringLiteral);
		if (!FindPredicate (typetrait, expression.typetrait.predicate)) EmitError (expression.typetrait.stringLiteral->location, Format ("invalid type trait '%0'", typetrait));
		return Classify (expression, Type::Boolean, ValueCategory::PRValue, false, false, false);
	}

	case Expression::Assignment:
		assert (expression.assignment.left);
		assert (expression.assignment.right);
		if (!IsLValue (*expression.assignment.left))
			EmitError (expression.location, Format ("expression '%0' is not assignable", *expression.assignment.left));
		if (!IsModifiable (*expression.assignment.left))
			EmitError (expression.location, Format ("expression '%0' is not modifiable", *expression.assignment.left));
		if (!IsDependent (*expression.assignment.right) && !IsDependent (*expression.assignment.left)) Convert (*expression.assignment.right, expression.assignment.left->type);
		return Classify (expression, expression.assignment.left->type, ValueCategory::LValue, true, IsPotentiallyThrowing (*expression.assignment.left) || IsPotentiallyThrowing (*expression.assignment.right), IsBitField (*expression.assignment.left));

	case Expression::Identifier:
		assert (expression.identifier.identifier);
		expression.identifier.entity = &Use (Lookup (*expression.identifier.identifier, {}), expression.location);
		if (!HasType (*expression.identifier.entity)) EmitError (expression.location, Format ("invalid use of %0", *expression.identifier.entity));
		return Classify (expression, CPP::GetType (*expression.identifier.entity), IsLValue (*expression.identifier.entity) ? ValueCategory::LValue : ValueCategory::PRValue, false, false, IsBitField (*expression.identifier.entity));

	case Expression::SizeofType:
		assert (expression.sizeofType.typeIdentifier);
		CheckSize (expression.sizeofType.typeIdentifier->type, expression.location);
		return Classify (expression, checker.size, ValueCategory::PRValue, false, false, false);

	case Expression::Conditional:
		assert (expression.conditional.left);
		assert (expression.conditional.right);
		assert (expression.conditional.condition);
		Convert (*expression.conditional.condition, Type::Boolean);
		Convert (*expression.conditional.right, RemoveQualifiers (expression.conditional.left->type));
		Convert (*expression.conditional.left, RemoveQualifiers (expression.conditional.right->type));
		return Classify (expression, expression.conditional.left->type, ValueCategory::PRValue, HasSideEffects (*expression.conditional.condition) ||
			HasSideEffects (*expression.conditional.left) && !IsFalse (*expression.conditional.condition) || HasSideEffects (*expression.conditional.right) && !IsTrue (*expression.conditional.condition),
			IsPotentiallyThrowing (*expression.conditional.condition) || IsPotentiallyThrowing (*expression.conditional.left) || IsPotentiallyThrowing (*expression.conditional.right), IsBitField (*expression.conditional.left) || IsBitField (*expression.conditional.right));

	case Expression::Indirection:
	{
		assert (expression.indirection.expression);
		auto& type = expression.indirection.expression->type;
		ConvertPRValue (*expression.indirection.expression, IsArray (type) ? &type : type);
		if (!IsPointer (type)) EmitError (expression.location, Format ("indirection '%0' applied on type %1", expression, type));
		if (!IsObject (*type.pointer.baseType) && !IsFunction (*type.pointer.baseType)) EmitError (expression.location, Format ("indirection '%0' applied on pointer to %1", expression, *type.pointer.baseType));
		return Classify (expression, *type.pointer.baseType, ValueCategory::LValue, HasSideEffects (*expression.indirection.expression), IsPotentiallyThrowing (*expression.indirection.expression), false);
	}

	case Expression::FunctionCall:
	{
		assert (expression.functionCall.expression);
		const auto& function = *expression.functionCall.expression;
		const auto& type = IsPointer (function.type) ? *function.type.pointer.baseType : function.type;
		if (!IsFunction (type)) EmitError (function.location, Format ("calling expression '%0' of type %1", function, type));
		expression.functionCall.function = IsIdentifier (function) && IsFunction (*function.identifier.entity) ? function.identifier.entity->function : nullptr;
		expression.functionCall.isConstexpr = expression.functionCall.function && IsConstexpr (*expression.functionCall.function) && expression.functionCall.function->body;
		const auto parameters = type.function.parameterTypes->size (), arguments = expression.functionCall.arguments ? expression.functionCall.arguments->size () : 0;
		if (arguments < parameters) EmitError (function.location, Format ("missing arguments for call of '%0'", function));
		if (arguments > parameters && !type.function.variadic) EmitError (function.location, Format ("too many arguments for call of '%0'", function));
		auto parameter = type.function.parameterTypes->begin (); if (expression.functionCall.arguments) for (auto& argument: *expression.functionCall.arguments)
			if (parameter != type.function.parameterTypes->end ()) Convert (argument, *parameter), ++parameter, expression.functionCall.isConstexpr &= IsConstant (argument);
		Classify (expression, *type.function.returnType, IsReference (*type.function.returnType) ? ValueCategory::LValue : ValueCategory::PRValue, !expression.functionCall.isConstexpr, IsPotentiallyThrowing (*expression.functionCall.expression) || !type.function.noexcept_, false);
		if (expression.functionCall.function && IsInlineable (*expression.functionCall.function)) ExpandFunctionCall (expression);
		return;
	}

	case Expression::MemberAccess:
	{
		assert (expression.memberAccess.expression); assert (expression.memberAccess.identifier);
		const auto type = expression.memberAccess.expression->type;
		if (!IsClass (type)) EmitError (expression.memberAccess.expression->location, Format ("member access on '%0' of type %1", *expression.memberAccess.expression, type));
		if (IsIncomplete (type)) EmitError (expression.location, Format ("member access on incomplete type %0", type));
		Entities entities; if (!type.class_->scope.LookupQualified (Name {*expression.memberAccess.identifier}, entities))
			EmitError (expression.memberAccess.identifier->location, Format ("identifier '%0' undeclared in %1", *expression.memberAccess.identifier, type.class_->scope));
		assert (entities.size () == 1); expression.memberAccess.entity = entities.front ();
		return Classify (expression, expression.memberAccess.entity->variable->type, expression.memberAccess.expression->category, HasSideEffects (*expression.memberAccess.expression), IsPotentiallyThrowing (*expression.memberAccess.expression), IsBitField (*expression.memberAccess.entity));
	}

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return Classify (expression, expression.parenthesized.expression->type, expression.parenthesized.expression->category, HasSideEffects (*expression.parenthesized.expression), IsPotentiallyThrowing (*expression.parenthesized.expression), IsBitField (*expression.parenthesized.expression));

	case Expression::StringLiteral:
	{
		assert (expression.stringLiteral);
		assert (!expression.stringLiteral->tokens.empty ());

		Type type;
		switch (expression.stringLiteral->symbol) {
		case Lexer::NarrowString: case Lexer::Char8TString: type = Type::Character; break;
		case Lexer::Char16TString: type = Type::Character16; break;
		case Lexer::Char32TString: type = Type::Character32; break;
		case Lexer::WideString: type = Type::WideCharacter; break;
		default: assert (Lexer::UnreachableLiteral);
		}

		Assign (expression, Insert (*expression.stringLiteral, type));
		return Classify (expression, *expression.value.reference.array, ValueCategory::LValue, false, false, false);
	}

	case Expression::ConstructorCall:
	{
		assert (expression.constructorCall.specifier);
		assert (expression.constructorCall.expressions);
		assert (expression.constructorCall.expressions->size () == 1);
		Type type; Combine (*expression.constructorCall.specifier, type); Normalize (type);
		if (!IsVoid (type)) Convert (expression.constructorCall.expressions->front (), type, false);
		return Classify (expression, type, ValueCategory::PRValue, false, false, false);
	}

	case Expression::SizeofExpression:
		assert (expression.sizeofExpression.expression);
		CheckSize (expression.sizeofExpression.expression->type, expression.location);
		if (IsBitField (*expression.sizeofExpression.expression)) EmitError (expression.location, "requesting size of bit-field");
		return Classify (expression, checker.size, ValueCategory::PRValue, false, false, false);

	case Expression::MemberIndirection:
		assert (expression.memberIndirection.expression); assert (expression.memberIndirection.member);
		return Classify (expression, *expression.memberIndirection.member->type.memberPointer.baseType, ValueCategory::LValue, HasSideEffects (*expression.memberIndirection.expression), IsPotentiallyThrowing (*expression.memberIndirection.expression), IsBitField (*expression.memberIndirection.member));

	default:
		assert (Expression::Unreachable);
	}
}

inline void Context::Invalidate (Expression& expression)
{
	expression.value = {};
}

inline void Context::Assign (Expression& expression, const Value& value)
{
	expression.value = value;
}

void Context::Classify (Expression& expression, const Type& type, const ValueCategory category, const bool hasSideEffects, const bool isPotentiallyThrowing, const bool isBitField)
{
	expression.type = type; expression.category = category; expression.hasSideEffects = hasSideEffects; expression.isPotentiallyThrowing = isPotentiallyThrowing;
	expression.isBitField = isBitField; if (IsPRValue (expression) && !IsClass (expression.type) && !IsArray (expression.type)) Discard (expression.type.qualifiers);
	try {FoldConstant (expression);} catch (const UndefinedBehavior& error) {EmitWarning (expression.location, "expression not folded due to undefined behavior");
	EmitNote (error.location, error.message); expression.hasSideEffects = true; Invalidate (expression);}
}

void Context::EvaluateIf (const bool condition, Expression& expression)
{
	if (condition) Assign (expression, Evaluator::Evaluate (expression)); else Invalidate (expression);
}

void Context::FoldConstant (Expression& expression)
{
	switch (expression.model)
	{
	case Expression::New:
	case Expression::Cast:
	case Expression::This:
	case Expression::Throw:
	case Expression::Postfix:
	case Expression::Indirection:
	case Expression::MemberAccess:
	case Expression::ConstructorCall:
	case Expression::MemberIndirection:
	case Expression::InlinedFunctionCall:
		return Invalidate (expression);

	case Expression::Comma:
		assert (expression.comma.right);
		return Assign (expression, expression.comma.right->value);

	case Expression::Unary:
		assert (expression.unary.operand);
		return EvaluateIf (IsConstant (*expression.unary.operand), expression);

	case Expression::Binary:
		assert (expression.binary.left); assert (expression.binary.right);
		return EvaluateIf (IsConstant (*expression.binary.left) && IsConstant (*expression.binary.right) || IsDoubleAmpersand (expression.binary.operator_.symbol) && IsFalse (*expression.binary.left) || IsDoubleBar (expression.binary.operator_.symbol) && IsTrue (*expression.binary.left), expression);

	case Expression::Prefix:
		assert (expression.prefix.expression);
		return Assign (expression, expression.prefix.expression->value);

	case Expression::Alignof:
		assert (expression.alignof_.typeIdentifier);
		return Assign (expression, Unsigned (GetAlignment (expression.alignof_.typeIdentifier->type)));

	case Expression::Literal:
	case Expression::StringLiteral:
		return assert (IsConstant (expression));

	case Expression::Noexcept:
		assert (expression.noexcept_.expression);
		return Assign (expression, !IsPotentiallyThrowing (*expression.noexcept_.expression));

	case Expression::Addressof:
	{
		assert (expression.addressof.expression);
		const auto& operand = *expression.addressof.expression;
		return EvaluateIf (IsConstant (operand) && IsGLValue (operand) && IsStaticStorage (*operand.value.reference.entity), expression);
	}

	case Expression::Subscript:
		assert (expression.subscript.array); assert (expression.subscript.index);
		return EvaluateIf (IsConstant (*expression.subscript.array) && IsConstant (*expression.subscript.index), expression);

	case Expression::Typetrait:
		assert (expression.typetrait.typeIdentifier); assert (expression.typetrait.predicate);
		return Assign (expression, expression.typetrait.predicate (expression.typetrait.typeIdentifier->type));

	case Expression::Assignment:
		assert (expression.assignment.left);
		return Assign (expression, expression.assignment.left->value);

	case Expression::Conversion:
	{
		assert (expression.conversion.expression);
		const auto& operand = *expression.conversion.expression;

		switch (expression.conversion.model)
		{
		case Conversion::Boolean:
			if (IsAddressof (operand)) return Assign (expression, true);

		case Conversion::Pointer:
		case Conversion::Integral:
		case Conversion::NullPointer:
		case Conversion::Qualification:
		case Conversion::FloatingPoint:
		case Conversion::ArrayToPointer:
		case Conversion::FunctionPointer:
		case Conversion::FloatingIntegral:
		case Conversion::FunctionToPointer:
		case Conversion::IntegralPromotion:
		case Conversion::FloatingPointPromotion:
			return EvaluateIf (IsConstant (operand), expression);

		case Conversion::LValueToRValue:
			return EvaluateIf (IsConstant (operand) && !IsVolatile (operand.type) && IsGLValue (operand) && (IsIntegral (operand.type) || IsEnumeration (operand.type)) &&
				IsVariable (*operand.value.reference.entity) && IsConstant (*operand.value.reference.entity->variable), expression);

		default:
			assert (Expression::UnreachableConversion);
		}
	}

	case Expression::Identifier:
		assert (expression.identifier.entity);
		if (IsEnumerator (*expression.identifier.entity)) return Assign (expression, expression.identifier.entity->enumerator->value);
		return Assign (expression, *expression.identifier.entity);

	case Expression::SizeofType:
		assert (expression.sizeofType.typeIdentifier);
		return Assign (expression, GetSize (expression.sizeofType.typeIdentifier->type));

	case Expression::Conditional:
		assert (expression.conditional.left);
		assert (expression.conditional.right);
		assert (expression.conditional.condition);
		return EvaluateIf (IsConstant (*expression.conditional.condition) && IsConstant (*expression.conditional.left) && IsConstant (*expression.conditional.right), expression);

	case Expression::FunctionCall:
		return EvaluateIf (expression.functionCall.isConstexpr, expression);

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return Assign (expression, expression.parenthesized.expression->value);

	case Expression::SizeofExpression:
		assert (expression.sizeofExpression.expression);
		return Assign (expression, GetSize (expression.sizeofExpression.expression->type));

	default:
		assert (Expression::Unreachable);
	}
}

Value Context::Evaluate (const Expression& expression)
{
	assert (IsConstant (expression)); return expression.value;
}

Value& Context::Designate (const Entity& entity)
{
	assert (IsVariable (entity)); return entity.variable->value;
}

Value Context::Call (const Function& function, Values&& values, const Location& location)
{
	assert (IsConstexpr (function));
	return Executor {checker, translationUnit}.Call (function, std::move (values), location);
}

Unsigned Context::GetSize (const Type& type) const
{
	if (IsReference (type)) return GetSize (RemoveReference (type));
	if (IsClass (type)) return Align (std::max (checker.platform.GetSize (type), Size (1)), checker.platform.GetAlignment (type));
	return checker.platform.GetSize (type);
}

Alignment Context::GetAlignment (const Type& type) const
{
	if (IsReference (type)) return GetAlignment (RemoveReference (type));
	return checker.platform.GetAlignment (type);
}

void Context::CheckAlignment (const Type& type, const Location& location)
{
	if (IsIncomplete (type) || IsReference (type) && IsIncomplete (RemoveReference (type)))
		EmitError (location, Format ("requesting alignment of incomplete type %0", type));
	if (IsFunction (type)) EmitError (location, Format ("requesting alignment of function type %0", type));
}

void Context::CheckSize (const Type& type, const Location& location)
{
	if (IsFunction (type)) EmitError (location, Format ("requesting size of function type %0", type));
	if (IsIncomplete (type)) EmitError (location, Format ("requesting size of incomplete type %0", type));
}

Array& Context::Insert (const StringLiteral& literal, const Type& type)
{
	const auto iterator = translationUnit.stringLiterals.find (literal);
	if (iterator != translationUnit.stringLiterals.end ()) return iterator->second;
	auto& result = *translationUnit.stringLiterals.emplace (std::piecewise_construct, std::forward_as_tuple (literal), std::forward_as_tuple (type)).first;
	const auto bits = checker.platform.GetBits (type);
	auto& array = result.second; array.values.reserve (CPP::GetSize (literal));
	for (auto& token: literal.tokens) for (auto character: *token.literal)
		if (array.values.emplace_back (ECS::Truncate (Lexer::Evaluate (character, checker.charset), bits)).unsigned_ != Unsigned (character))
			EmitWarning (token.location, Format ("character %0 in %1 cannot be represented by type %2", UniversalCharacterName {character}, token, type));
	array.values.emplace_back (Unsigned {0}); array.elementType.qualifiers.isConst = true; array.stringLiteral = &result.first; return array;
}

void Context::CheckConstant (const Expression& expression)
{
	if (!IsConstant (expression) && !IsDependent (expression))
		EmitError (expression.location, Format ("expression '%0' is not constant", expression));
}

void Context::CheckDiscarded (const Expression& expression)
{
	if (!HasSideEffects (expression) && !IsVoid (expression.type)) EmitWarning (expression.location, Format ("expression '%0' has no effect", expression));
	if (IsNodiscardCall (expression)) EmitWarning (expression.location, Format ("discarding return value of nodiscard call expression '%0'", expression));
}

void Context::CheckIncrement (const Expression& expression, const Operator& operator_)
{
	if (!IsLValue (expression))
		EmitError (expression.location, Format ("expression '%0' is not assignable", expression));
	if (!IsModifiable (expression))
		EmitError (expression.location, Format ("expression '%0' is not modifiable", expression));
	if (!IsArithmetic (expression.type) && !IsPointer (expression.type) || IsBoolean (expression.type))
		EmitError (expression.location, Format ("applying %0 operator on type %1", operator_, expression.type));
}

void Context::EnterBlock (Scope& scope)
{
	assert (IsBlock (scope));
	scope.block.bytes = bytes; scope.block.variables = variables; scope.block.registers = registers;
	currentScope = &scope;
}

void Context::LeaveBlock (Scope& scope)
{
	assert (IsBlock (scope)); assert (currentScope == &scope); WarnAboutUnusedEntities (scope);
	if (currentFunction && variables > currentFunction->variables) currentFunction->bytes = bytes, currentFunction->variables = variables;
	if (currentFunction && registers > currentFunction->registers) currentFunction->registers = registers;
	bytes = scope.block.bytes; variables = scope.block.variables; registers = scope.block.registers;
	currentScope = currentScope->enclosingScope;
}

void Context::Enter (Statement& statement)
{
	enclosingStatement = &statement;
	if (HasScope (statement)) translationUnit.Create (statement.scope, Scope::Block, currentScope), EnterBlock (*statement.scope);
}

void Context::Check (Statement& statement)
{
	if (statement.enclosingBlock) statement.iterator = --statement.enclosingBlock->statements.end ();

	switch (statement.model)
	{
	case Statement::Do:
		assert (statement.do_.condition);
		Convert (*statement.do_.condition, Type::Boolean);
		break;

	case Statement::If:
		assert (statement.if_.condition.expression);
		Convert (*statement.if_.condition.expression, Type::Boolean);
		break;

	case Statement::For:
		if (statement.for_.condition) Convert (*statement.for_.condition->expression, Type::Boolean);
		if (statement.for_.expression) CheckDiscarded (*statement.for_.expression);
		break;

	case Statement::Try:
	case Statement::Compound:
		break;

	case Statement::Case:
	{
		assert (statement.case_.label);
		CheckConstant (*statement.case_.label);
		const auto switchStatement = GetEnclosingSwitch (statement);
		if (!switchStatement) EmitError (statement.location, "case label outside switch statement");
		ConvertConstant (*statement.case_.label, switchStatement->switch_.condition.expression->type);
		statement.case_.index = switchStatement->switch_.caseTable->size ();
		const auto result = switchStatement->switch_.caseTable->emplace (statement.case_.label->value.signed_, &statement);
		if (!result.second) EmitError (statement.case_.label->location, "duplicated case label", result.first->second->case_.label->location);
		break;
	}

	case Statement::Goto:
		assert (statement.goto_.identifier);
		statement.goto_.entity = &Use (DeclareLabel (*statement.goto_.identifier), statement.goto_.identifier->location);
		break;

	case Statement::Null:
		statement.null.fallthrough = nullptr;
		break;

	case Statement::Break:
		if (!GetEnclosingBreakable (statement)) EmitError (statement.location, "break statement outside iteration or switch statement");
		break;

	case Statement::Label:
		assert (statement.label.identifier);
		statement.label.entity = &DefineLabel (*statement.label.identifier, statement);
		break;

	case Statement::While:
		assert (statement.while_.condition.expression);
		Convert (*statement.while_.condition.expression, Type::Boolean);
		break;

	case Statement::Return:
		assert (currentFunction);
		if (statement.return_.expression)
			Convert (*statement.return_.expression, *currentFunction->type.function.returnType);
		else if (HasReturnType (*currentFunction))
			EmitError (statement.location, "missing return value");
		if (IsNoreturn (*currentFunction))
			EmitWarning (statement.location, "return statement in a function that should not return");
		if (statement.return_.expression && IsConstant (*statement.return_.expression) && IsLocalReference (statement.return_.expression->value, *currentFunction))
			EmitWarning (statement.location, Format ("returning reference to local %0", *statement.return_.expression->value.reference.entity));
		break;

	case Statement::Switch:
		assert (statement.switch_.condition.expression);
		if (!IsIntegral (statement.switch_.condition.expression->type) && !IsEnumeration (statement.switch_.condition.expression->type))
			EmitError (statement.switch_.condition.expression->location, Format ("switch condition of type %0", statement.switch_.condition.expression->type));
		Convert (*statement.switch_.condition.expression, IsScopedEnumeration (statement.switch_.condition.expression->type) ? statement.switch_.condition.expression->type : Type::Integer);
		if (IsConstant (*statement.switch_.condition.expression)) EmitWarning (statement.switch_.condition.expression->location, "constant switch condition");
		translationUnit.Create (statement.switch_.caseTable); statement.switch_.defaultLabel = nullptr;
		break;

	case Statement::Default:
	{
		const auto switchStatement = GetEnclosingSwitch (statement);
		if (!switchStatement) EmitError (statement.location, "default label outside switch statement");
		if (switchStatement->switch_.defaultLabel) EmitError (statement.location, "duplicated default label", switchStatement->switch_.defaultLabel->location);
		switchStatement->switch_.defaultLabel = &statement;
		break;
	}

	case Statement::Continue:
		if (!GetEnclosingIteration (statement)) EmitError (statement.location, "continue statement outside iteration statement");
		break;

	case Statement::Expression:
		assert (statement.expression);
		CheckDiscarded (*statement.expression);
		break;

	case Statement::Declaration:
		assert (statement.declaration); assert (!statement.attributes);
		if (IsAsm (*statement.declaration)) asmDeclarations.push_back (&statement);
		break;

	default:
		assert (Statement::Unreachable);
	}

	if (statement.attributes) Apply (*statement.attributes, statement);
}

void Context::Check (Substatement& statement)
{
	if (statement.attributes) assert (statement.isCompound), Apply (*statement.attributes, statement);
}

void Context::Leave (Statement& statement)
{
	enclosingStatement = statement.enclosingBlock->enclosingStatement;
	if (HasScope (statement)) assert (statement.scope), LeaveBlock (*statement.scope);
}

void Context::Enter (StatementBlock& block)
{
	block.enclosingStatement = enclosingStatement;
	if (!enclosingStatement) return void (block.scope = currentScope);
	translationUnit.Create (block.scope, Scope::Block, currentScope);
	if (enclosingStatement && HasScope (*enclosingStatement)) block.scope->symbolTable = currentScope->symbolTable;
	EnterBlock (*block.scope);
}

void Context::Leave (StatementBlock& block)
{
	if (!block.enclosingStatement) return assert (block.scope == currentScope);
	assert (block.scope); LeaveBlock (*block.scope);
}

void Context::Check (Condition& condition)
{
	assert (condition.declaration);
	assert (condition.declaration->condition.declarator);
	translationUnit.Create (condition.expression, *GetName (*condition.declaration->condition.declarator).name.identifier);
	Check (*condition.expression);
}

void Context::Check (FunctionBody& body)
{
	assert (currentFunction);

	switch (body.model)
	{
	case FunctionBody::Try:
	case FunctionBody::Regular:
		assert (currentFunction);
		if (body.regular.initializers && !IsConstructor (*currentFunction)) EmitError (body.location, Format ("using constructor initializer in %0", *currentFunction->entity));
		break;

	case FunctionBody::Delete:
		if (currentFunction->declarations != 1) EmitError (body.location, Format ("deleting %0 after first declaration", *currentFunction->entity));
		currentFunction->isDeleted = currentFunction->isInline = true;
		break;

	case FunctionBody::Default:
		currentFunction->isDefaulted = true;
		break;

	default:
		assert (FunctionBody::Unreachable);
	}
}

Entity& Context::PredefineStaticArray (const Identifier& identifier, const String& string)
{
	auto& array = Insert ({identifier.location, Lexer::NarrowString, checker.stringPool.Insert (WString {string.begin (), string.end ()})}, Type::Character);
	auto& entity = Declare (Entity::Variable, identifier, {}, *currentScope); assert (!entity.variable);
	auto& variable = translationUnit.Create<Variable> (array, entity, LanguageLinkage::CPP, checker.platform);
	entity.variable = &variable; variable.value = array; variable.isStatic = true;
	return Predefine (entity, identifier.location);
}

void Context::Enter (Declaration& declaration)
{
	enclosingDeclarations.push_back (&declaration);

	switch (declaration.model)
	{
	case Declaration::Member:
	case Declaration::Simple:
	case Declaration::ExplicitInstantiation:
		break;

	case Declaration::Template:
		translationUnit.Create (declaration.template_.scope, Scope::TemplateParameter, currentScope);
		currentScope = declaration.template_.scope;
		break;

	case Declaration::FunctionDefinition:
		assert (declaration.functionDefinition.entity);
		assert (declaration.functionDefinition.declarator);
		assert (IsFunctionDefinition (*declaration.functionDefinition.declarator));
		enclosingFunctions.push_back (currentFunction);
		currentFunction = declaration.functionDefinition.entity->function;
		assert (currentFunction->prototype);
		bytes = variables = registers = 0;
		if (!IsTemplate (*currentFunction)) ReserveSpace (currentFunction->parameters);
		translationUnit.Create (currentFunction->scope, Scope::Function, declaration.functionDefinition.entity->enclosingScope);
		currentFunction->scope->function = currentFunction;
		enclosingScopes.push_back (currentScope);
		currentScope = currentFunction->prototype->scope;
		assert (IsFunctionPrototype (*currentScope));
		currentScope->model = Scope::Block;
		currentScope->enclosingScope = currentFunction->scope;
		EnterBlock (*currentScope);
		if (!IsTemplate (*currentFunction)) currentFunction->func = PredefineStaticArray ({currentFunction->entity->location, checker.func}, GetName (*currentFunction->entity)).variable;
		break;

	case Declaration::NamespaceDefinition:
		assert (declaration.namespaceDefinition.namespace_);
		currentScope = &declaration.namespaceDefinition.namespace_->scope;
		break;

	case Declaration::LinkageSpecification:
		enclosingLinkages.push_back (currentLinkage);
		currentLinkage = declaration.linkageSpecification.linkage;
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::Check (Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Asm:
		declaration.asm_.code = declaration.asm_.noreturn_ = nullptr; declaration.asm_.entities = nullptr;
		if (declaration.asm_.attributes) Apply (*declaration.asm_.attributes, declaration);
		for (auto scope = currentScope; IsBlock (*scope); scope = scope->enclosingScope)
			for (auto& entity: scope->symbolTable) Assemble (*entity.second, declaration);
		break;

	case Declaration::Alias:
		declaration.alias.entity = &DeclareAlias (declaration.alias.typeIdentifier->type, *declaration.alias.identifier, {});
		if (declaration.alias.attributes) Apply (*declaration.alias.attributes, *declaration.alias.entity);
		break;

	case Declaration::Empty:
		EmitWarning (declaration.location, "empty declaration");
		break;

	case Declaration::Using:
	case Declaration::Member:
		break;

	case Declaration::Simple:
		assert (declaration.simple.specifiers);
		if (declaration.simple.declarators) break;
		if (IsTypedef (*declaration.simple.specifiers)) EmitError (declaration.location, "type definition without a declarator");
		if (!IsDeclaration (*declaration.simple.specifiers)) EmitError (declaration.location, "declaration does not declare anything");
		break;

	case Declaration::Template:
		assert (currentScope == declaration.template_.scope);
		currentScope = currentScope->enclosingScope;
		break;

	case Declaration::Attribute:
		assert (declaration.attribute.specifiers);
		Apply (*declaration.attribute.specifiers, translationUnit);
		break;

	case Declaration::Condition:
		assert (declaration.condition.specifiers); assert (declaration.condition.declarator);
		for (auto& specifier: *declaration.condition.specifiers)
			if (IsTypeDefinition (specifier)) EmitError (specifier.location, "type definition in condition");
			else if (!IsType (specifier) && !IsConstexpr (specifier)) EmitError (specifier.location, Format ("%0 specifier in condition declaration", specifier));
		declaration.condition.entity = Check (*declaration.condition.declarator, *declaration.condition.specifiers, &Context::DeclareVariable).name.entity;
		if (IsParenthesizedFunction (*declaration.condition.declarator)) EmitError (declaration.condition.declarator->location, "declarator of condition specifies function");
		if (IsParenthesizedArray (*declaration.condition.declarator)) EmitError (declaration.condition.declarator->location, "declarator of condition specifies array");
		Define (*declaration.condition.entity, declaration.condition.declarator->location);
		break;

	case Declaration::OpaqueEnum:
		assert (declaration.opaqueEnum.head.identifier);
		assert (declaration.opaqueEnum.head.enumeration);
		assert (IsUnqualified (*declaration.opaqueEnum.head.identifier));
		if (IsUnscoped (*declaration.opaqueEnum.head.enumeration) && !declaration.opaqueEnum.head.base)
			EmitError (declaration.opaqueEnum.head.identifier->location, Format ("missing underlying type in declaration of %0", *declaration.opaqueEnum.head.enumeration->entity));
		CheckFundamental (declaration.opaqueEnum.head.enumeration->alignment);
		break;

	case Declaration::UsingDirective:
		assert (declaration.usingDirective.identifier);
		declaration.usingDirective.namespace_ = &LookupNamespace (*declaration.usingDirective.identifier);
		if (declaration.usingDirective.attributes) Apply (*declaration.usingDirective.attributes, declaration);
		currentScope->Use (*declaration.usingDirective.namespace_);
		break;

	case Declaration::StaticAssertion:
		assert (declaration.staticAssertion.expression);
		if (IsDependent (*declaration.staticAssertion.expression)) break;
		Convert (*declaration.staticAssertion.expression, Type::Boolean);
		CheckConstant (*declaration.staticAssertion.expression);
		if (declaration.staticAssertion.expression->value.boolean) break;
		if (declaration.staticAssertion.stringLiteral && !IsEmpty (*declaration.staticAssertion.stringLiteral)) EmitError (declaration.location, Concatenate (*declaration.staticAssertion.stringLiteral));
		else EmitError (declaration.staticAssertion.expression->location, Format ("static assertion '%0' failed", *declaration.staticAssertion.expression));

	case Declaration::FunctionDefinition:
		assert (declaration.functionDefinition.declarator);
		declaration.functionDefinition.entity = Check (*declaration.functionDefinition.declarator, *declaration.functionDefinition.specifiers, &Context::DefineFunction).name.entity;
		if (declaration.functionDefinition.attributes) Apply (*declaration.functionDefinition.attributes, *declaration.functionDefinition.entity);
		if (IsBlock (*currentScope)) EmitError (declaration.functionDefinition.entity->location, Format ("definition of %0 in block scope", *declaration.functionDefinition.entity));
		break;

	case Declaration::NamespaceDefinition:
		if (!declaration.namespaceDefinition.identifier) declaration.namespaceDefinition.namespace_ = &DefineNamespace (declaration.namespaceDefinition.isInline, declaration.location);
		else declaration.namespaceDefinition.namespace_ = &DefineNamespace (declaration.namespaceDefinition.isInline, *declaration.namespaceDefinition.identifier);
		if (declaration.namespaceDefinition.attributes) Apply (*declaration.namespaceDefinition.attributes, *declaration.namespaceDefinition.namespace_);
		break;

	case Declaration::LinkageSpecification:
	{
		assert (declaration.linkageSpecification.stringLiteral);
		const auto linkage = Concatenate (*declaration.linkageSpecification.stringLiteral);
		if (!FindLanguageLinkage (linkage, declaration.linkageSpecification.linkage)) EmitError (declaration.linkageSpecification.stringLiteral->location, Format ("unsupported language linkage '%0'", linkage));
		break;
	}

	case Declaration::ExplicitInstantiation:
		assert (declaration.explicitInstantiation.declaration);
		if (IsFunctionDefinition (*declaration.explicitInstantiation.declaration)) EmitError (declaration.explicitInstantiation.declaration->location, "explicit instantiation of function definition");
		assert (IsSimple (*declaration.explicitInstantiation.declaration));
		break;

	case Declaration::ExplicitSpecialization:
		break;

	case Declaration::NamespaceAliasDefinition:
		assert (declaration.namespaceAliasDefinition.name);
		assert (declaration.namespaceAliasDefinition.identifier);
		declaration.namespaceAliasDefinition.namespace_ = &LookupNamespace (*declaration.namespaceAliasDefinition.name);
		DefineNamespaceAlias (*declaration.namespaceAliasDefinition.identifier, *declaration.namespaceAliasDefinition.namespace_);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::FinalizeCheck (Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Condition:
		assert (declaration.condition.initializer);
		assert (declaration.condition.entity); assert (declaration.condition.entity->variable);
		Check (*declaration.condition.initializer, *declaration.condition.entity->variable);
		if (declaration.condition.attributes) Apply (*declaration.condition.attributes, *declaration.condition.entity);
		declaration.condition.entity->enclosingScope->variables.push_back (declaration.condition.entity);
		ReserveBlockSpace (*declaration.condition.entity->variable);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::Leave (Declaration& declaration)
{
	assert (!enclosingDeclarations.empty ());
	assert (enclosingDeclarations.back () == &declaration);
	enclosingDeclarations.pop_back ();

	switch (declaration.model)
	{
	case Declaration::Member:
	case Declaration::Simple:
	case Declaration::ExplicitInstantiation:
		break;

	case Declaration::Template:
		break;

	case Declaration::FunctionDefinition:
		assert (!enclosingFunctions.empty ());
		assert (declaration.functionDefinition.body);
		currentFunction->body = declaration.functionDefinition.body;
		LeaveBlock (*currentScope);
		assert (!enclosingScopes.empty ());
		assert (currentScope == currentFunction->scope);
		for (auto& entry: currentScope->symbolTable) CheckLabel (*entry.second);
		for (auto& statement: asmDeclarations) for (Scope* scope = currentScope; scope; scope = scope->enclosingScope)
			for (auto& entry: scope->symbolTable) Assemble (*entry.second, *statement->declaration);
		if (CheckReachability (*declaration.functionDefinition.body))
			if (IsNoreturn (*currentFunction) && !IsReturning (*currentFunction)) EmitWarning (currentFunction->entity->location, "flowing off the end of a function that should not return");
			else if (RequiresReturnValue (*currentFunction)) EmitWarning (currentFunction->entity->location, "not all control paths return a value"); else;
		else if (!IsReturning (*currentFunction) && !IsNoreturn (*currentFunction) && !IsMain (*currentFunction) && !IsDeleted (*currentFunction) && !IsDefaulted (*currentFunction))
			EmitNote (currentFunction->entity->location, Format ("%0 qualifies for noreturn attribute", *currentFunction->entity));
		WarnAboutUnusedEntities (*currentScope);
		currentScope = enclosingScopes.back (); enclosingScopes.pop_back ();
		currentFunction = enclosingFunctions.back (); enclosingFunctions.pop_back ();
		asmDeclarations.clear ();
		break;

	case Declaration::NamespaceDefinition:
		assert (declaration.namespaceDefinition.namespace_);
		assert (currentScope == &declaration.namespaceDefinition.namespace_->scope);
		currentScope = currentScope->enclosingScope;
		break;

	case Declaration::LinkageSpecification:
		assert (!enclosingLinkages.empty ());
		assert (currentLinkage == declaration.linkageSpecification.linkage);
		if (declaration.linkageSpecification.declaration && IsBasic (*declaration.linkageSpecification.declaration))
			for (auto& specifier: *declaration.linkageSpecification.declaration->basic.specifiers)
				if (IsStorageClass (specifier)) EmitError (specifier.location, Format ("%0 specifier in linkage specification", specifier));
		currentLinkage = enclosingLinkages.back (); enclosingLinkages.pop_back ();
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::Check (UsingDeclarator& declarator)
{
	for (auto entity: Lookup (declarator.identifier)) Redeclare (*entity, *currentScope, declarator.identifier.location);
}

void Context::Assemble (Entity& entity, Declaration& declaration)
{
	assert (IsAsm (declaration));
	if (IsPredefined (entity) || IsAlias (entity) || IsClass (entity) || IsFunction (entity) || IsNamespace (entity)) return;
	if (!declaration.asm_.entities) translationUnit.Create (declaration.asm_.entities);
	for (auto& other: *declaration.asm_.entities) if (entity.name == other->name) return;
	declaration.asm_.entities->push_back (&Use (entity, declaration.location));
	if (IsEnumeration (entity)) for (auto& entry: entity.enumeration->scope.symbolTable) Use (*entry.second, declaration.location);
	if (IsLabel (entity)) entity.label->isAssembled = true;
}

void Context::Check (DeclarationSpecifier& specifier, DeclarationSpecifiers& specifiers)
{
	switch (specifier.model)
	{
	case DeclarationSpecifier::Type:
		assert (specifier.type.specifier);
		return Combine (*specifier.type.specifier, specifiers.type);

	case DeclarationSpecifier::Friend:
		return Set (specifiers.isFriend, specifier);

	case DeclarationSpecifier::Inline:
		return Set (specifiers.isInline, specifier);

	case DeclarationSpecifier::Typedef:
		return Set (specifiers.isTypedef, specifier);

	case DeclarationSpecifier::Function:
		assert (IsFunctionSpecifier (specifier.function.specifier));
		return Set (specifier.function.specifier == Lexer::Virtual ? specifiers.isVirtual : specifiers.isExplicit, specifier);

	case DeclarationSpecifier::Constexpr:
		return Set (specifiers.isConstexpr, specifier);

	case DeclarationSpecifier::StorageClass:
		assert (IsStorageClass (specifier.storageClass.specifier));

		switch (specifier.storageClass.specifier)
		{
		case Lexer::Mutable: if (IsThreadLocal (specifiers)) break;
		case Lexer::Static: case Lexer::Extern: if (!specifiers.storageClass) return void (specifiers.storageClass = specifier.storageClass.specifier); break;
		case Lexer::ThreadLocal: if (specifiers.storageClass != Lexer::Mutable) return Set (specifiers.isThreadLocal, specifier); break;
		default: assert (DeclarationSpecifier::Unreachable);
		}

		EmitError (specifier.location, Format ("combining storage class specifiers %0 and %1", specifiers.storageClass ? specifiers.storageClass : Lexer::ThreadLocal, specifier));

	default:
		assert (DeclarationSpecifier::Unreachable);
	}
}

void Context::Set (bool& flag, const DeclarationSpecifier& specifier)
{
	if (flag) EmitError (specifier.location, Format ("duplicated %0 specifier", specifier)); else flag = true;
}

void Context::Check (DeclarationSpecifiers& specifiers)
{
	if (RequiresType (specifiers)) specifiers.type = Type::Void; Normalize (specifiers.type);
	if (specifiers.attributes) Apply (*specifiers.attributes, specifiers.type);
}

void Context::Normalize (Type& type)
{
	switch (type.model)
	{
	case Type::Character: case Type::SignedCharacter: case Type::UnsignedCharacter: case Type::Character16: case Type::Character32: case Type::WideCharacter:
	case Type::ShortInteger: case Type::UnsignedShortInteger: case Type::Integer: case Type::UnsignedInteger: case Type::LongInteger: case Type::UnsignedLongInteger: case Type::LongLongInteger: case Type::UnsignedLongLongInteger:
	case Type::Boolean: case Type::Float: case Type::Double: case Type::LongDouble: case Type::NullPointer: case Type::Void: case Type::Auto:
	case Type::Class: case Type::Enumeration: case Type::Pointer: case Type::MemberPointer: case Type::Dependent:
		break;

	case Type::Signed: case Type::SignedInteger:
		type.model = Type::Integer; break;

	case Type::Unsigned:
		type.model = Type::UnsignedInteger; break;

	case Type::Short: case Type::SignedShort: case Type::SignedShortInteger:
		type.model = Type::ShortInteger; break;

	case Type::UnsignedShort:
		type.model = Type::UnsignedShortInteger; break;

	case Type::Long: case Type::SignedLong: case Type::SignedLongInteger:
		type.model = Type::LongInteger; break;

	case Type::UnsignedLong:
		type.model = Type::UnsignedLongInteger; break;

	case Type::LongLong: case Type::SignedLongLong: case Type::SignedLongLongInteger:
		type.model = Type::LongLongInteger; break;

	case Type::UnsignedLongLong:
		type.model = Type::UnsignedLongLongInteger; break;

	case Type::Array:
		assert (type.array.elementType);
		if (type.qualifiers) {auto elementType = *type.array.elementType; elementType.qualifiers |= type.qualifiers; Normalize (elementType); translationUnit.Create (type.array.elementType, elementType); Discard (type.qualifiers);}
		break;

	case Type::Alias:
	{
		assert (type.alias);
		const auto alias = type.alias; const auto qualifiers = type.qualifiers; type = CPP::GetType (*alias);
		type.alias = alias; if (!IsReference (type)) type.qualifiers |= qualifiers; Normalize (type); break;
	}

	case Type::Decltype:
	{
		assert (type.decltype_.specifier.expression);
		const auto qualifiers = type.qualifiers; type = type.decltype_.specifier.expression->type;
		type.specifier = &type.decltype_.specifier; if (!IsReference (type)) type.qualifiers |= qualifiers; Normalize (type); break;
	}

	case Type::Function:
		Discard (type.qualifiers); break;

	default:
		assert (Type::Unreachable);
	}
}

void Context::Check (EnumHead& head)
{
	assert (IsUnscoped (head.key) || head.identifier); Type underlyingType;
	if (head.base) if (IsIntegral (head.base->type)) underlyingType = head.base->type, Discard (underlyingType.qualifiers);
	else EmitError (head.base->front ().location, Format ("invalid underlying enumeration type %0", head.base->type));
	else if (IsScoped (head.key)) underlyingType = Type::Integer;
	if (head.identifier) head.enumeration = DeclareEnumeration (head.key, *head.identifier, underlyingType).enumeration;
	else translationUnit.Create (head.enumeration, *currentScope, head.key, nullptr, ++currentScope->enumerations, underlyingType, checker.platform);
	if (head.attributes) Apply (*head.attributes, *head.enumeration);
}

void Context::Check (ClassHead& head)
{
	if (head.identifier) head.class_ = DeclareClass (head.key, *head.identifier).class_;
	else translationUnit.Create (head.class_, *currentScope, head.key, nullptr, ++currentScope->classes, checker.platform);
	if (head.attributes) Apply (*head.attributes, *head.class_);
}

void Context::Enter (TypeSpecifier& specifier)
{
	switch (specifier.model)
	{
	case TypeSpecifier::Enum:
		assert (specifier.enum_.head.enumeration);
		enclosingScopes.push_back (currentScope);
		currentScope = &specifier.enum_.head.enumeration->scope;
		break;

	case TypeSpecifier::Class:
		assert (specifier.class_.head.class_);
		enclosingScopes.push_back (currentScope);
		currentScope = &specifier.class_.head.class_->scope;
		break;

	default:
		assert (TypeSpecifier::Unreachable);
	}
}

void Context::Leave (TypeSpecifier& specifier)
{
	switch (specifier.model)
	{
	case TypeSpecifier::Enum:
	{
		assert (!enclosingScopes.empty ());
		assert (specifier.enum_.head.enumeration); auto& enumeration = *specifier.enum_.head.enumeration;
		assert (currentScope == &enumeration.scope); currentScope = enclosingScopes.back (); enclosingScopes.pop_back ();
		if (specifier.enum_.enumerators) for (auto& definition: *specifier.enum_.enumerators) definition.enumerator->type = enumeration;
		if (IsUndefined (enumeration.underlyingType)) enumeration.underlyingType = Type::Integer, enumeration.alignment.value = checker.platform.GetAlignment (enumeration.underlyingType);
		if (specifier.enum_.isDefinition && enumeration.entity) Define (*enumeration.entity, specifier.enum_.head.identifier->location);
		CheckFundamental (enumeration.alignment);
		break;
	}

	case TypeSpecifier::Class:
	{
		assert (!enclosingScopes.empty ());
		assert (specifier.class_.head.class_); auto& class_ = *specifier.class_.head.class_;
		assert (currentScope == &class_.scope); currentScope = enclosingScopes.back (); enclosingScopes.pop_back ();
		if (specifier.class_.isDefinition && class_.entity) Define (*class_.entity, specifier.class_.head.identifier->location);
		if (specifier.class_.isDefinition) class_.isComplete = true;
		CheckFundamental (class_.alignment);
		break;
	}

	default:
		assert (TypeSpecifier::Unreachable);
	}
}

void Context::Check (TypeSpecifier& specifier, TypeSpecifiers& specifiers)
{
	Combine (specifier, specifiers.type);
}

void Context::Check (TypeSpecifiers& specifiers)
{
	Normalize (specifiers.type);
	if (specifiers.attributes) Apply (*specifiers.attributes, specifiers.type);
}

void Context::Combine (TypeSpecifier& specifier, Type& type)
{
	assert (!IsReference (type));

	switch (specifier.model)
	{
	case TypeSpecifier::Enum:
		assert (specifier.enum_.head.enumeration); if (!IsUndefined (type)) break;
		type.model = Type::Enumeration; type.enumeration = specifier.enum_.head.enumeration;
		return;

	case TypeSpecifier::Class:
		assert (specifier.class_.head.class_); if (!IsUndefined (type)) break;
		type.model = Type::Class; type.class_ = specifier.class_.head.class_;
		return;

	case TypeSpecifier::Simple:
		switch (specifier.simple.type)
		{
		case Lexer::Char:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Character; return;
			case Type::Signed: type.model = Type::SignedCharacter; return;
			case Type::Unsigned: type.model = Type::UnsignedCharacter; return;
			} break;
		case Lexer::Char16T:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Character16; return;
			} break;
		case Lexer::Char32T:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Character32; return;
			} break;
		case Lexer::WCharT:
			switch (type.model) {
			case Type::Undefined: type.model = Type::WideCharacter; return;
			} break;
		case Lexer::Bool:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Boolean; return;
			} break;
		case Lexer::Short:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Short; return;
			case Type::Signed: type.model = Type::SignedShort; return;
			case Type::Unsigned: type.model = Type::UnsignedShort; return;
			case Type::Integer: type.model = Type::ShortInteger; return;
			case Type::SignedInteger: type.model = Type::SignedShortInteger; return;
			case Type::UnsignedInteger: type.model = Type::UnsignedShortInteger; return;
			} break;
		case Lexer::Int:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Integer; return;
			case Type::Signed: type.model = Type::SignedInteger; return;
			case Type::Unsigned: type.model = Type::UnsignedInteger; return;
			case Type::Short: type.model = Type::ShortInteger; return;
			case Type::SignedShort: type.model = Type::SignedShortInteger; return;
			case Type::UnsignedShort: type.model = Type::UnsignedShortInteger; return;
			case Type::Long: type.model = Type::LongInteger; return;
			case Type::SignedLong: type.model = Type::SignedLongInteger; return;
			case Type::UnsignedLong: type.model = Type::UnsignedLongInteger; return;
			case Type::LongLong: type.model = Type::LongLongInteger; return;
			case Type::SignedLongLong: type.model = Type::SignedLongLongInteger; return;
			case Type::UnsignedLongLong: type.model = Type::UnsignedLongLongInteger; return;
			} break;
		case Lexer::Long:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Long; return;
			case Type::Signed: type.model = Type::SignedLong; return;
			case Type::Unsigned: type.model = Type::UnsignedLong; return;
			case Type::Integer: type.model = Type::LongInteger; return;
			case Type::SignedInteger: type.model = Type::SignedLongInteger; return;
			case Type::UnsignedInteger: type.model = Type::UnsignedLongInteger; return;
			case Type::Long: type.model = Type::LongLong; return;
			case Type::SignedLong: type.model = Type::SignedLongLong; return;
			case Type::UnsignedLong: type.model = Type::UnsignedLongLong; return;
			case Type::LongInteger: type.model = Type::LongLongInteger; return;
			case Type::SignedLongInteger: type.model = Type::SignedLongLongInteger; return;
			case Type::UnsignedLongInteger: type.model = Type::UnsignedLongLongInteger; return;
			case Type::Double: type.model = Type::LongDouble; return;
			} break;
		case Lexer::Signed:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Signed; return;
			case Type::Character: type.model = Type::SignedCharacter; return;
			case Type::Short: type.model = Type::SignedShort; return;
			case Type::ShortInteger: type.model = Type::SignedShortInteger; return;
			case Type::Integer: type.model = Type::SignedInteger; return;
			case Type::Long: type.model = Type::SignedLong; return;
			case Type::LongInteger: type.model = Type::SignedLongInteger; return;
			case Type::LongLong: type.model = Type::SignedLongLong; return;
			case Type::LongLongInteger: type.model = Type::SignedLongLongInteger; return;
			} break;
		case Lexer::Unsigned:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Unsigned; return;
			case Type::Character: type.model = Type::UnsignedCharacter; return;
			case Type::Short: type.model = Type::UnsignedShort; return;
			case Type::ShortInteger: type.model = Type::UnsignedShortInteger; return;
			case Type::Integer: type.model = Type::UnsignedInteger; return;
			case Type::Long: type.model = Type::UnsignedLong; return;
			case Type::LongInteger: type.model = Type::UnsignedLongInteger; return;
			case Type::LongLong: type.model = Type::UnsignedLongLong; return;
			case Type::LongLongInteger: type.model = Type::UnsignedLongLongInteger; return;
			} break;
		case Lexer::Float:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Float; return;
			} break;
		case Lexer::Double:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Double; return;
			case Type::Long: type.model = Type::LongDouble; return;
			} break;
		case Lexer::Void:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Void; return;
			} break;
		case Lexer::Auto:
			switch (type.model) {
			case Type::Undefined: type.model = Type::Auto; return;
			} break;
		default:
			assert (Type::Unreachable);
		}
		break;

	case TypeSpecifier::Decltype:
		if (!IsUndefined (type)) break;
		type.model = Type::Decltype; type.decltype_.specifier = specifier.decltype_.specifier;
		return;

	case TypeSpecifier::TypeName:
		assert (specifier.typeName.identifier); if (!IsUndefined (type)) break;
		specifier.typeName.entity = &LookupType (*specifier.typeName.identifier);
		type.model = Type::Alias; type.alias = specifier.typeName.entity;
		return;

	case TypeSpecifier::ConstVolatileQualifier:
		Check (type.qualifiers, specifier.constVolatile.qualifier, specifier.location);
		if (!IsUndefined (type)) EmitNote (specifier.location, Format ("using %0 specifier as suffix for type", specifier));
		return;

	default:
		assert (TypeSpecifier::Unreachable);
	}

	EmitError (specifier.location, Format ("invalid combination of %0 specifier with type '%1'", specifier, type));
}

Type Context::GetType (TypeSpecifier& specifier)
{
	Type type; Combine (specifier, type); Normalize (type); return type;
}

void Context::Check (EnumeratorDefinition& definition)
{
	auto& entity = DefineEnumerator (definition.identifier); definition.enumerator = entity.enumerator;
	auto& enumeration = *entity.enclosingScope->enumeration; auto& enumerator = *entity.enumerator;
	if (definition.attributes) Apply (*definition.attributes, enumerator);

	if (definition.expression)
	{
		CheckConstant (*definition.expression);
		if (!IsUndefined (enumeration.underlyingType)) ConvertConstant (*definition.expression, enumeration.underlyingType);
		else if (IsIntegral (definition.expression->type)) enumerator.type = definition.expression->type;
		else if (IsUnscopedEnumeration (definition.expression->type)) enumerator.type = definition.expression->type.enumeration->underlyingType;
		else EmitError (definition.expression->location, Format ("value '%0' for %1 of type %2", *definition.expression, entity, definition.expression->type));
		enumerator.value = definition.expression->value;
	}
	else if (enumeration.previousEnumerator)
	{
		enumerator.type = enumeration.previousEnumerator->type; enumerator.value = enumeration.previousEnumerator->value;
		if (IsSignedInteger (enumerator.type) ? enumerator.value.signed_ == std::numeric_limits<Signed>::max () : enumerator.value.unsigned_ == std::numeric_limits<Unsigned>::max ())
			EmitError (definition.identifier.location, Format ("value of %0 cannot be represented by any integral type", entity));
		if (IsSignedInteger (enumerator.type)) ++enumerator.value.signed_; else ++enumerator.value.unsigned_;
	}
	else
	{
		if (!IsUndefined (enumeration.underlyingType)) enumerator.type = enumeration.underlyingType; else enumerator.type = Type::Integer;
		if (IsUnsignedInteger (enumerator.type)) enumerator.value = Unsigned {0}; else enumerator.value = Signed {0};
	}

	enumeration.previousEnumerator = &enumerator;
}

void Context::Check (Attribute& attribute)
{
	switch (attribute.model)
	{
	case Attribute::Unspecified:
		EmitWarning (attribute.location, Format ("ignoring unspecified attribute '%0'", attribute));
		break;

	case Attribute::CarriesDependency:
	case Attribute::Deprecated:
	case Attribute::Fallthrough:
	case Attribute::Likely:
	case Attribute::MaybeUnused:
	case Attribute::Nodiscard:
	case Attribute::Noreturn:
	case Attribute::NoUniqueAddress:
	case Attribute::Unlikely:
	case Attribute::Code:
	case Attribute::Duplicable:
	case Attribute::Register:
	case Attribute::Replaceable:
	case Attribute::Required:
		break;

	case Attribute::Alias:
		assert (attribute.alias.stringLiteral);
		if (IsEmpty (*attribute.alias.stringLiteral)) EmitError (attribute.alias.stringLiteral->location, "empty alias name");
		break;

	case Attribute::Group:
		assert (attribute.group.stringLiteral);
		if (IsEmpty (*attribute.group.stringLiteral)) EmitError (attribute.group.stringLiteral->location, "empty group name");
		break;

	case Attribute::Origin:
		assert (attribute.origin.expression);
		CheckConstant (*attribute.origin.expression);
		ConvertConstant (*attribute.origin.expression, checker.size);
		break;

	default:
		assert (Attribute::Unreachable);
	}
}

void Context::Check (Attributes& attributes)
{
	bool appeared[Attribute::Count] {};
	for (auto& attribute: attributes)
		if (attribute.isPacked) EmitError (attribute.location, Format ("attribute '%0' used as pack expansion", attribute));
		else if (appeared[attribute.model] && !IsUnspecified (attribute)) EmitError (attribute.location, Format ("attribute '%0' appears multiple times in attribute list", attribute));
		else appeared[attribute.model] = true;
}

void Context::Check (AttributeSpecifier& specifier)
{
	switch (specifier.model)
	{
	case AttributeSpecifier::AlignasType:
		assert (specifier.alignasType.typeIdentifier);
		CheckAlignment (specifier.alignasType.typeIdentifier->type, specifier.location);
		specifier.alignment = GetAlignment (specifier.alignasType.typeIdentifier->type);
		break;

	case AttributeSpecifier::AlignasExpression:
	{
		assert (specifier.alignasExpression.expression);
		auto& expression = *specifier.alignasExpression.expression;
		CheckConstant (expression); ConvertConstant (expression, checker.difference);
		if (!IsPowerOfTwo (expression.value.signed_)) EmitError (expression.location, Format ("alignment '%0' is not a positive power of two", expression));
		specifier.alignment = expression.value.signed_;
		break;
	}

	default:
		assert (AttributeSpecifier::Unreachable);
	}
}

void Context::ApplyInvalid (const AttributeSpecifier& specifier)
{
	EmitError (specifier.location, Format ("invalid application of attribute specifier '%0'", specifier));
}

template <typename Structure>
inline void Context::Apply (const AttributeSpecifier& specifier, Structure&)
{
	ApplyInvalid (specifier);
}

void Context::Apply (const AttributeSpecifier& specifier, Entity& entity)
{
	if (IsClass (entity)) Apply (specifier, *entity.class_);
	else if (IsEnumeration (entity)) Apply (specifier, *entity.enumeration);
	else if (IsVariable (entity) && !IsRegister (*entity.variable)) Apply (specifier, *entity.variable);
	else ApplyInvalid (specifier);
}

inline void Context::Apply (const AttributeSpecifier& specifier, Class& class_)
{
	if (IsAlignment (specifier)) Apply (specifier, class_.alignment);
	else ApplyInvalid (specifier);
}

inline void Context::Apply (const AttributeSpecifier& specifier, Variable& variable)
{
	if (IsAlignment (specifier) && !IsBitField (variable)) Apply (specifier, variable.alignment);
	else ApplyInvalid (specifier);
}

inline void Context::Apply (const AttributeSpecifier& specifier, Enumeration& enumeration)
{
	if (IsAlignment (specifier)) Apply (specifier, enumeration.alignment);
	else ApplyInvalid (specifier);
}

inline void Context::Apply (const AttributeSpecifier& specifier, AlignmentSpecification& alignment)
{
	assert (IsAlignment (specifier));
	if (!alignment.specifier || alignment.specifier->alignment <= specifier.alignment) alignment.specifier = &specifier;
}

template <typename Structure>
void Context::Apply (const AttributeSpecifiers& specifiers, Structure& structure)
{
	for (auto& specifier: specifiers)
		if (IsAlignment (specifier)) Apply (specifier, structure);
		else if (specifier.attributes.list) for (auto& attribute: *specifier.attributes.list) if (!IsUnspecified (attribute)) Apply (attribute, structure);
}

void Context::ApplyInvalid (const Attribute& attribute)
{
	EmitError (attribute.location, Format ("invalid application of attribute '%0'", attribute));
}

template <typename Structure>
inline void Context::Apply (const Attribute& attribute, Structure&)
{
	ApplyInvalid (attribute);
}

void Context::Apply (const Attribute& attribute, Entity& entity)
{
	switch (attribute.model)
	{
	case Attribute::CarriesDependency:
		if (IsParameter (entity)) return;
		if (!IsFunction (entity)) ApplyInvalid (attribute);
		if (!entity.function->carriesDependency && entity.function->declarations != 1)
			EmitError (attribute.location, Format ("applying attribute '%0' to %1 after its first declaration", attribute, entity), entity.location);
		entity.function->carriesDependency = true;
		return;

	case Attribute::Deprecated:
		return Apply (attribute, entity.deprecation);

	case Attribute::Fallthrough:
	case Attribute::Likely:
	case Attribute::NoUniqueAddress:
	case Attribute::Unlikely:
	case Attribute::Code:
		ApplyInvalid (attribute);

	case Attribute::MaybeUnused:
		if (IsParameter (entity)) return;
		if (!IsClass (entity) && !IsAlias (entity) && (!IsVariable (entity) || IsStaticMember (entity)) && !IsFunction (entity) && !IsEnumeration (entity) && !IsEnumerator (entity)) ApplyInvalid (attribute);
		entity.maybeUnused = true;
		return;

	case Attribute::Nodiscard:
		if (!IsFunction (entity)) ApplyInvalid (attribute);
		entity.function->isNodisard = true;
		return;

	case Attribute::Noreturn:
		if (!IsFunction (entity)) ApplyInvalid (attribute);
		if (!entity.function->isNoreturn && entity.function->declarations != 1)
			EmitError (attribute.location, Format ("applying attribute '%0' to %1 after its first declaration", attribute, entity), entity.location);
		if (HasReturnType (*entity.function) && !IsMain (*entity.function))
			EmitWarning (attribute.location, Format ("applying '%0' attribute to %1 with return type %2", attribute, entity, *entity.function->type.function.returnType));
		entity.function->isNoreturn = true;
		return;

	case Attribute::Alias:
	{
		if (!IsStaticStorage (entity)) ApplyInvalid (attribute);
		assert (attribute.alias.stringLiteral);
		const auto alias = checker.stringPool.Insert (Concatenate (*attribute.alias.stringLiteral));
		if (!entity.storage->alias) entity.storage->alias = alias; else if (alias != entity.storage->alias)
			EmitError (attribute.location, Format ("alias name of %0 already specified as '%1'", entity, *entity.storage->alias));
		if (IsDefined (entity) && GetName (entity) == *alias) EmitError (attribute.location, Format ("duplicated alias name of %0", entity));
		return;
	}

	case Attribute::Duplicable:
		if (!IsStaticStorage (entity)) ApplyInvalid (attribute);
		entity.storage->duplicable = true;
		return;

	case Attribute::Group:
	{
		assert (attribute.group.stringLiteral);
		if (!IsStaticStorage (entity)) ApplyInvalid (attribute);
		const auto group = checker.stringPool.Insert (Concatenate (*attribute.group.stringLiteral));
		if (!entity.storage->group) entity.storage->group = group; else if (group != entity.storage->group)
			EmitError (attribute.location, Format ("group name of %0 already specified as '%1'", entity, *entity.storage->group));
		return;
	}

	case Attribute::Origin:
		if (!IsStaticStorage (entity)) ApplyInvalid (attribute);
		assert (attribute.origin.expression); assert (IsConstant (*attribute.origin.expression));
		if (!entity.storage->origin) entity.storage->origin = attribute.origin.expression;
		else if (attribute.origin.expression->value.unsigned_ != entity.storage->origin->value.unsigned_)
			EmitError (attribute.origin.expression->location, Format ("inconsistent origin of %0", entity), entity.storage->origin->location);
		return;

	case Attribute::Register:
		if (IsParameter (entity)) return;
		if (!IsVariable (entity) || !IsBlock (*entity.enclosingScope) || IsStatic (*entity.variable)) ApplyInvalid (attribute);
		entity.variable->isRegister = true;
		return;

	case Attribute::Replaceable:
		if (!IsStaticStorage (entity)) ApplyInvalid (attribute);
		entity.storage->replaceable = true;
		return;

	case Attribute::Required:
		if (!IsStaticStorage (entity)) ApplyInvalid (attribute);
		entity.storage->required = true;
		return;

	default:
		assert (Attribute::Unreachable);
	}
}

void Context::Apply (const Attribute& attribute, Declaration& declaration)
{
	if (IsCode (attribute) && IsAsm (declaration)) declaration.asm_.code = &attribute;
	else if (IsNoreturn (attribute) && IsAsm (declaration) && currentFunction) declaration.asm_.noreturn_ = &attribute;
	else ApplyInvalid (attribute);
}

void Context::Apply (const Attribute& attribute, ParameterDeclaration& declaration)
{
	if (IsCarriesDependency (attribute)) declaration.carriesDependency = &attribute;
	else if (IsMaybeUnused (attribute)) declaration.maybeUnused = &attribute;
	else if (IsRegister (attribute)) declaration.register_ = &attribute;
	else ApplyInvalid (attribute);
}

void Context::Apply (const Attribute& attribute, Statement& statement)
{
	if (IsFallthrough (attribute) && IsNull (statement))
		if (!GetEnclosingSwitch (statement)) EmitError (attribute.location, "fallthrough statement outside switch statement");
		else statement.null.fallthrough = &attribute;
	else if (IsLikelihood (attribute))
		if (HasLikelihood (statement) && statement.likelihood->model != attribute.model) EmitError (attribute.location, "contradicting statement likelihood");
		else statement.likelihood = &attribute;
	else ApplyInvalid (attribute);
}

void Context::Apply (const Attribute& attribute, Class& class_)
{
	if (IsDeprecated (attribute)) Apply (attribute, class_.deprecation);
	else if (IsMaybeUnused (attribute)) if (class_.entity) Apply (attribute, *class_.entity); else;
	else if (IsNodiscard (attribute)) class_.isNodisard = true;
	else ApplyInvalid (attribute);
}

void Context::Apply (const Attribute& attribute, Enumerator& enumerator)
{
	if (IsDeprecated (attribute)) Apply (attribute, enumerator.deprecation);
	else if (IsMaybeUnused (attribute)) Apply (attribute, *enumerator.entity);
	else ApplyInvalid (attribute);
}

void Context::Apply (const Attribute& attribute, Namespace& namespace_)
{
	if (IsDeprecated (attribute)) Apply (attribute, namespace_.deprecation);
	else ApplyInvalid (attribute);
}

void Context::Apply (const Attribute& attribute, Enumeration& enumeration)
{
	if (IsDeprecated (attribute)) Apply (attribute, enumeration.deprecation);
	else if (IsMaybeUnused (attribute)) if (enumeration.entity) Apply (attribute, *enumeration.entity); else;
	else if (IsNodiscard (attribute)) enumeration.isNodisard = true;
	else ApplyInvalid (attribute);
}

void Context::Apply (const Attribute& attribute, TranslationUnit&)
{
	if (!IsDeprecated (attribute)) ApplyInvalid (attribute);
	else if (GetOrigin (attribute.location) != Lexer::SourceFile)
		EmitWarning (attribute.location, HasRationale (attribute) ? Concatenate (*attribute.deprecated.stringLiteral) : Format ("deprecated %0", GetOrigin (attribute.location)));
}

void Context::Apply (const Attribute& attribute, Deprecation& deprecation)
{
	assert (IsDeprecated (attribute));
	if (!deprecation.attribute || !HasRationale (*deprecation.attribute) && HasRationale (attribute)) deprecation.attribute = &attribute;
	else if (HasRationale (attribute)) EmitWarning (attribute.location, "ignoring rationale for deprecation");
}

void Context::Enter (Declarator&)
{
	enclosingScopes.push_back (currentScope);
}

void Context::Check (Declarator& declarator)
{
	assert (IsName (declarator)); assert (!enclosingScopes.empty ());
	if (declarator.name.identifier && IsQualified (*declarator.name.identifier)) currentScope = declarator.name.identifier->nestedNameSpecifier->scope;
}

void Context::Leave (Declarator&)
{
	assert (!enclosingScopes.empty ());
	currentScope = enclosingScopes.back (); enclosingScopes.pop_back ();
}

void Context::Check (InitDeclarator& declarator)
{
	assert (!enclosingDeclarations.empty ()); const auto& declaration = *enclosingDeclarations.back ();
	assert (IsBasic (declaration)); assert (declaration.basic.specifiers); declarator.specifiers = declaration.basic.specifiers;
	if (declarator.declarator) declarator.entity = Check (*declarator.declarator, *declarator.specifiers, &Context::Declare).name.entity;
}

void Context::FinalizeCheck (InitDeclarator& declarator)
{
	assert (declarator.entity); assert (!enclosingDeclarations.empty ());
	const auto& declaration = *enclosingDeclarations.back (); assert (IsBasic (declaration));
	if (declaration.basic.attributes) Apply (*declaration.basic.attributes, *declarator.entity);
	if (HasInitializer (declarator) && !IsVariable (*declarator.entity)) EmitError (declarator.initializer->location, Format ("initializing %0", *declarator.entity));
	const auto enclosingDeclaration = enclosingDeclarations.size () >= 2 ? enclosingDeclarations[enclosingDeclarations.size () - 2] : nullptr;
	const auto isExtern = IsExtern (declaration) || enclosingDeclaration && IsExternLinkageSpecification (*enclosingDeclaration);
	declarator.isDeclaration = IsTypedef (*declarator.specifiers) || IsFunction (*declarator.entity) || (isExtern && !HasInitializer (declarator));
	if (declarator.isDeclaration || enclosingDeclaration && IsExplicitInstantiation (*enclosingDeclaration)) return;
	assert (IsVariable (*declarator.entity)); Define (*declarator.entity, declarator.declarator->location);
	if (HasInitializer (declarator)) Check (*declarator.initializer, *declarator.entity->variable);
	else if (IsReference (declarator.entity->variable->type)) EmitError (declarator.declarator->location, Format ("missing initializer for %0 of type %1", *declarator.entity, declarator.entity->variable->type));
	if (HasStaticStorageDuration (*declarator.entity->variable)) CheckExtended (declarator.entity->variable->alignment); else CheckFundamental (declarator.entity->variable->alignment);
	if (isExtern) EmitWarning (declarator.declarator->location, Format ("defining %0 although it is declared extern", *declarator.entity));
	if (IsBlock (*currentScope)) ReserveBlockSpace (*declarator.entity->variable);
	declarator.entity->enclosingScope->variables.push_back (declarator.entity);
}

void Context::Enter (MemberDeclarator& declarator)
{
	enclosingMemberDeclarators.push_back (&declarator);
}

void Context::Leave (MemberDeclarator& declarator)
{
	assert (!enclosingMemberDeclarators.empty ());
	assert (enclosingMemberDeclarators.back () == &declarator);
	enclosingMemberDeclarators.pop_back ();
}

void Context::FinalizeCheck (MemberDeclarator& declarator)
{
	assert (!enclosingDeclarations.empty ()); const auto& declaration = *enclosingDeclarations.back (); assert (IsBasic (declaration));
	if (declaration.basic.attributes && !declarator.declarator) Apply (*declaration.basic.attributes, declarator);
	if (declarator.expression)
	{
		ConvertConstant (*declarator.expression, checker.difference);
		const auto type = declarator.declarator ? CPP::GetType (*declarator.entity) : declarator.specifiers->type;
		if (IsStatic (*declarator.specifiers)) EmitError (declarator.expression->location, "static member bit-field");
		if (!IsIntegral (type) && !IsEnumeration (type)) EmitError (declarator.expression->location, Format ("bit-field of type %0", type));
		if (declarator.expression->value.signed_ < (declarator.declarator ? 1 : 0)) EmitError (declarator.expression->location, Format ("invalid length '%0' of bit-field", *declarator.expression));
		if (!declarator.declarator) return declarator.expression->value.signed_ ? ReserveClassSpace (declarator.expression->value.signed_, type, checker.platform.GetAlignment (type)) : ReserveClassSpace (checker.platform.GetAlignment (type));
		assert (declarator.entity); assert (IsVariable (*declarator.entity)); declarator.entity->variable->length = declarator.expression->value.signed_;
		if (const auto attributes = GetName (*declarator.declarator).name.attributes) Apply (*attributes, *declarator.entity);
	}
	assert (declarator.entity); if (declaration.basic.attributes) Apply (*declaration.basic.attributes, *declarator.entity);
	if (HasInitializer (declarator) && IsFunction (*declarator.entity) && IsPureSpecifier (*declarator.initializer)) currentScope->class_->isAbstract = declarator.entity->function->isPureVirtual = true;
	else if (HasInitializer (declarator) && !IsVariable (*declarator.entity)) EmitError (declarator.initializer->location, Format ("initializing %0", *declarator.entity));
	declarator.isDeclaration = IsTypedef (*declarator.specifiers) || IsFunction (*declarator.entity) || IsVariable (*declarator.entity) && IsStaticMember (*declarator.entity) && !IsInline (*declarator.entity);
	if (declarator.isDeclaration) return; assert (IsVariable (*declarator.entity)); Define (*declarator.entity, declarator.declarator->location);
	if (HasInitializer (declarator)) Check (*declarator.initializer, *declarator.entity->variable);
	if (HasStaticStorageDuration (*declarator.entity->variable)) CheckExtended (declarator.entity->variable->alignment); else CheckFundamental (declarator.entity->variable->alignment);
	declarator.entity->enclosingScope->variables.push_back (declarator.entity);
	ReserveClassSpace (*declarator.entity->variable);
}

void Context::Check (Initializer& initializer, Variable& variable)
{
	if (initializer.expressions.empty ()) return; auto& expression = initializer.expressions.front ();
	if (IsPlaceholder (variable.type)) ConvertPRValue (expression, expression.type), variable.type = expression.type, variable.alignment &= checker.platform.GetAlignment (variable.type);
	else if (IsCharacterArray (variable.type) && IsStringLiteral (expression)) StringInitialize (variable.type, expression);
	else if (IsLValueReference (variable.type) && IsLValue (expression))
		if (RemoveReference (variable.type).IsReferenceCompatibleWith (expression.type));
		else EmitError (initializer.location, Format ("initializing reference of type %0 with incompatible type %1", variable.type, expression.type));
	else if (IsClass (variable.type) && IsUnion (*variable.type.class_))
		if (variable.type.class_->firstDataMember) Convert (expression, RemoveQualifiers (variable.type.class_->firstDataMember->type));
		else EmitError (initializer.location, "initializing empty union type");
	else Convert (expression, RemoveQualifiers (variable.type));
	if (IsConstant (expression)) variable.value = expression.value;
}

void Context::StringInitialize (Type& type, const Expression& expression)
{
	assert (IsCharacterArray (type)); assert (IsStringLiteral (expression)); assert (IsCharacterArray (expression.type));
	if (RemoveQualifiers (*type.array.elementType) != RemoveQualifiers (*expression.type.array.elementType))
		EmitError (expression.location, Format ("initializing %0 with string literal of type %1", type, expression.type));
	if (IsUnboundArray (type)) type.array.bound = CPP::GetSize (*expression.stringLiteral);
	else if (type.array.bound < CPP::GetSize (*expression.stringLiteral)) EmitError (expression.location, "more initializers than array elements");
}

void Context::Check (ParameterDeclaration& declaration)
{
	for (auto& specifier: declaration.specifiers)
		if (IsTypeDefinition (specifier)) EmitError (specifier.location, "type definition in parameter declaration");
		else if (!IsType (specifier)) EmitError (specifier.location, Format ("%0 specifier in parameter declaration", specifier));
	if (!declaration.declarator) return void (declaration.type = declaration.specifiers.type);
	const auto& declarator = Check (*declaration.declarator, declaration.specifiers, &Context::DefineParameter);
	declaration.location = declarator.location; declaration.type = declarator.type; declaration.entity = declarator.name.entity;
	if (declaration.entity) declaration.entity->parameter = &declaration;
	if (declarator.name.attributes) Apply (*declarator.name.attributes, declaration);
}

void Context::FinalizeCheck (ParameterDeclaration& declaration)
{
	if (IsQualifiedFunction (declaration.type)) EmitError (declaration.location, Format ("parameter declaration of type %0", declaration.type));
	AdjustParameter (declaration.type);
	if (declaration.attributes) Apply (*declaration.attributes, declaration);
	if (declaration.initializer) Convert (*declaration.initializer, declaration.type);
}

void Context::AdjustParameter (Type& type)
{
	if (IsArray (type) && !IsReference (type)) type = type.array.elementType;
	if (IsFunction (type) && !IsReference (type)) type = &translationUnit.Create<Type> (type);
}

void Context::TransformParameter (Type& type)
{
	if (!IsReference (type)) Discard (type.qualifiers);
}

void Context::Check (ParameterDeclarations& declarations)
{
	if (IsVoid (declarations)) declarations.clear ();
	for (auto& declaration: declarations) if (IsVoid (declaration.type)) EmitError (declaration.location, Format ("parameter of type %0", declaration.type));
}

void Context::Check (TypeIdentifier& identifier)
{
	if (!identifier.declarator) identifier.type = identifier.specifiers.type;
	else identifier.type = Check (*identifier.declarator, identifier.specifiers.type, {}, nullptr).type;
}

Entity& Context::Declare (const Type& type, const Identifier& identifier, const DeclarationSpecifiers& specifiers)
{
	if (IsTypedef (specifiers)) return DeclareAlias (type, identifier, specifiers);
	if (IsFunction (type) && !IsReference (type)) return DeclareFunction (type, identifier, specifiers);
	return DeclareVariable (type, identifier, specifiers);
}

Declarator& Context::Check (Declarator& declarator, const DeclarationSpecifiers& specifiers, Entity& (Context::*const declare) (const Type&, const Identifier&, const DeclarationSpecifiers&))
{
	return Check (declarator, specifiers.type, specifiers, declare);
}

Declarator& Context::Check (Declarator& declarator, const Type& type, const DeclarationSpecifiers& specifiers, Entity& (Context::*const declare) (const Type&, const Identifier&, const DeclarationSpecifiers&))
{
	switch (declarator.model)
	{
	case Declarator::Name:
		assert (declare);
		declarator.type = type;
		declarator.name.entity = declarator.name.identifier ? &(this->*declare) (type, *declarator.name.identifier, specifiers) : nullptr;
		if (declarator.name.attributes) assert (declarator.name.entity), Apply (*declarator.name.attributes, *declarator.name.entity);
		break;

	case Declarator::Array:
		if (IsAuto (type)) EmitError (declarator.location, Format ("array declarator containing '%0'", type));
		if (IsReference (type) || IsVoid (type) || IsFunction (type)) EmitError (declarator.location, Format ("invalid array element type %0", type));
		if (IsAbstractClass (type)) EmitError (declarator.location, Format ("array element of abstract class type %0", type));
		if (IsUnboundArray (type)) EmitError (declarator.location, Format ("array of unbound array type %0", type));
		if (declarator.array.expression) CheckConstant (*declarator.array.expression), ConvertConstant (*declarator.array.expression, checker.difference);
		if (declarator.array.expression && declarator.array.expression->value.signed_ <= 0) EmitError (declarator.array.expression->location, Format ("invalid array bound '%0'", *declarator.array.expression));
		declarator.type = {translationUnit.Create<Type> (type), declarator.array.expression ? Unsigned (declarator.array.expression->value.signed_) : 0};
		if (declarator.array.attributes) Apply (*declarator.array.attributes, declarator.type);
		if (declarator.array.declarator) return Check (*declarator.array.declarator, declarator.type, specifiers, declare);
		break;

	case Declarator::Pointer:
		if (IsReference (type) || IsQualifiedFunction (type)) EmitError (declarator.location, Format ("pointer declarator of type %0", type));
		declarator.type = &translationUnit.Create<Type> (type);
		if (declarator.pointer.qualifiers) declarator.type.qualifiers = *declarator.pointer.qualifiers;
		if (declarator.pointer.attributes) Apply (*declarator.pointer.attributes, declarator.type);
		if (declarator.pointer.declarator) return Check (*declarator.pointer.declarator, declarator.type, specifiers, declare);
		break;

	case Declarator::Function:
	{
		assert (declarator.function.prototype);
		auto& prototype = *declarator.function.prototype;
		for (auto& specifier: specifiers) if (IsTypeDefinition (specifier)) EmitError (specifier.location, "type definition in return type");
		if (prototype.trailingReturnType && !(IsAuto (type) && IsUnqualified (type)))
			EmitError (declarator.location, Format ("function with trailing return type specifies return type %0 instead of 'auto'", type));
		auto& returnType = prototype.trailingReturnType ? prototype.trailingReturnType->type : type;
		if (IsArray (returnType) && !IsReference (returnType) || IsFunction (returnType) && !IsReference (returnType))
			EmitError (declarator.location, Format ("invalid return type %0", returnType));
		declarator.type = {translationUnit.Create<Type> (returnType), translationUnit.Create<Types> (), currentLinkage};
		if (declarator.function.prototype->constVolatileQualifiers) declarator.type.function.constVolatileQualifiers = *declarator.function.prototype->constVolatileQualifiers;
		if (declarator.function.prototype->referenceQualifier) declarator.type.function.referenceQualifier = *declarator.function.prototype->referenceQualifier;
		if (IsAlternative (declarator.type.function.referenceQualifier.symbol)) declarator.type.function.referenceQualifier.symbol = GetPrimary (declarator.type.function.referenceQualifier.symbol);
		for (auto& declaration: prototype.parameterDeclarations) declarator.type.function.parameterTypes->push_back (declaration.type), TransformParameter (declarator.type.function.parameterTypes->back ());
		declarator.type.function.variadic = prototype.parameterDeclarations.isPacked;
		declarator.type.function.noexcept_ = prototype.noexceptSpecifier && IsNonThrowing (*prototype.noexceptSpecifier);
		if (prototype.attributes) Apply (*prototype.attributes, declarator.type);
		if (!declarator.function.declarator) return CheckFunctionType (prototype), declarator;
		auto& result = Check (*declarator.function.declarator, declarator.type, specifiers, declare);
		if (IsParenthesizedName (*declarator.function.declarator) && result.name.entity && IsFunction (*result.name.entity))
			Check (prototype, *result.name.entity->function, declare == &Context::DefineFunction); else CheckFunctionType (prototype);
		return result;
	}

	case Declarator::Reference:
		if (IsVoid (type) || IsReference (type) && !IsAliased (type) && !IsDecltyped (type) || IsQualifiedFunction (type))
			EmitError (declarator.location, Format ("reference declarator of type %0", type));
		declarator.type = type; declarator.type.alias = nullptr;
		if (!IsLValueReference (type)) declarator.type.reference = declarator.reference.isRValue ? Type::RValue : Type::LValue;
		if (declarator.reference.attributes) Apply (*declarator.reference.attributes, declarator.type);
		if (declarator.reference.declarator) return Check (*declarator.reference.declarator, declarator.type, specifiers, declare);
		break;

	case Declarator::MemberPointer:
	{
		assert (declarator.memberPointer.specifier);
		const auto& scope = *declarator.memberPointer.specifier->scope;
		if (!IsClass (scope)) EmitError (declarator.memberPointer.specifier->location, Format ("%0 does not denote a class", scope));
		if (IsReference (type) || IsVoid (type)) EmitError (declarator.location, Format ("member pointer declarator of type %0", type));
		declarator.type = {&translationUnit.Create<Type> (type), scope.class_};
		if (declarator.memberPointer.qualifiers) declarator.type.qualifiers = *declarator.memberPointer.qualifiers;
		if (declarator.memberPointer.attributes) Apply (*declarator.memberPointer.attributes, declarator.type);
		if (declarator.memberPointer.declarator) return Check (*declarator.memberPointer.declarator, declarator.type, specifiers, declare);
		break;
	}

	case Declarator::Parenthesized:
		declarator.type = type;
		assert (declarator.parenthesized.declarator);
		return Check (*declarator.parenthesized.declarator, declarator.type, specifiers, declare);

	default:
		assert (Declarator::Unreachable);
	}

	return declarator;
}

void Context::Check (FunctionPrototype& prototype, Function& function, const bool isDefinition)
{
	if (!function.prototype) function.parameters.resize (prototype.parameterDeclarations.size ());
	assert (function.parameters.size () == prototype.parameterDeclarations.size ());
	auto parameter = function.parameters.begin (); for (auto& declaration: prototype.parameterDeclarations) Check (*parameter, declaration), ++parameter;
	if (!function.prototype || isDefinition) function.prototype = &prototype;
}

void Context::Check (Parameter& parameter, ParameterDeclaration& declaration)
{
	if (declaration.carriesDependency && !parameter.carriesDependency)
		if (!parameter.declaration) parameter.carriesDependency = true;
		else EmitError (declaration.carriesDependency->location, Format ("applying attribute '%0' after first parameter declaration", *declaration.carriesDependency), parameter.declaration->location);
	if (declaration.maybeUnused && declaration.entity) declaration.entity->maybeUnused = true;
	if (declaration.register_) parameter.isRegister = true;
	if (!parameter.declaration) parameter.declaration = &declaration;
	declaration.parameter = &parameter;
}

void Context::CheckFunctionType (const FunctionPrototype& prototype)
{
	for (auto& declaration: prototype.parameterDeclarations)
		if (declaration.carriesDependency) ApplyInvalid (*declaration.carriesDependency);
		else if (declaration.register_) ApplyInvalid (*declaration.register_);
}

void Context::Enter (FunctionPrototype& prototype)
{
	if (!prototype.scope) translationUnit.Create (prototype.scope, Scope::FunctionPrototype, currentScope);
	currentScope = prototype.scope;
}

void Context::Leave (FunctionPrototype& prototype)
{
	assert (currentScope == prototype.scope);
	currentScope = currentScope->enclosingScope;
}

void Context::Check (NoexceptSpecifier& specifier)
{
	if (!specifier.throw_ && specifier.expression) Convert (*specifier.expression, Type::Boolean), CheckConstant (*specifier.expression);
}

void Context::Check (VirtualSpecifiers& specifiers, const Lexer::Token& token)
{
	assert (IsVirtualSpecifier (token));
	if (IsFinal (token) && !specifiers.final) specifiers.final = true;
	else if (IsOverride (token) && !specifiers.override) specifiers.override = true;
	else EmitError (token.location, Format ("duplicated %0 specifier", *token.identifier));
}

void Context::Check (ConstVolatileQualifiers& qualifiers, const Lexer::Token& token)
{
	Check (qualifiers, token.symbol, token.location);
}

void Context::Check (ConstVolatileQualifiers& qualifiers, const Lexer::Symbol symbol, const Location& location)
{
	assert (IsConstVolatileQualifier (symbol));
	if (symbol == Lexer::Const && !qualifiers.isConst) qualifiers.isConst = true;
	else if (symbol == Lexer::Volatile && !qualifiers.isVolatile) qualifiers.isVolatile = true;
	else EmitError (location, Format ("duplicated %0 qualifier", symbol));
}

void Context::Check (Identifier& identifier)
{
	switch (identifier.model)
	{
	case Identifier::Template:
	{
		assert (identifier.template_.identifier);
		auto& entity = Lookup (*identifier.template_.identifier, {});
		if (!IsTemplate (entity)) EmitError (identifier.template_.identifier->location, Format ("identifier '%0' does not name a template", *identifier.template_.identifier));
		entity.enclosingScope->symbolTable.emplace (Name {identifier}, &entity);
		break;
	}

	case Identifier::Destructor:
		assert (identifier.destructor.specifier);
		translationUnit.Create (identifier.destructor.type, GetType (*identifier.destructor.specifier));
		if (!IsClass (*identifier.destructor.type)) EmitError (identifier.location, Format ("identifier '%0' does not name a class", *identifier.destructor.specifier));
		break;

	default:
		assert (Identifier::Unreachable);
	}
}

void Context::Check (NestedNameSpecifier& specifier)
{
	switch (specifier.model)
	{
	case NestedNameSpecifier::Name:
		assert (specifier.name.identifier);
		specifier.scope = &LookupScope (*specifier.name.identifier);
		break;

	case NestedNameSpecifier::Global:
		specifier.scope = &translationUnit.global.scope;
		break;

	default:
		assert (NestedNameSpecifier::Unreachable);
	}
}

void Context::Check (TemplateArgument& argument)
{
	switch (argument.model)
	{
	case TemplateArgument::Expression:
		assert (argument.expression);
		CheckConstant (*argument.expression);
		break;

	case TemplateArgument::TypeIdentifier:
		break;

	default:
		assert (TemplateArgument::Unreachable);
	}
}

void Context::Check (TemplateParameter& parameter)
{
	switch (parameter.model)
	{
	case TemplateParameter::Type:
		if (parameter.type.identifier) DeclareAlias (Type::Dependent, *parameter.type.identifier, {});
		break;

	default:
		assert (TemplateParameter::Unreachable);
	}
}

Entity& Context::Use (Entity& entity, const Location& location) const
{
	if (IsClass (entity)) Use (entity.class_->deprecation, location);
	else if (IsNamespace (entity)) Use (entity.namespace_->deprecation, location);
	else if (IsEnumeration (entity)) Use (entity.enumeration->deprecation, location);
	else if (IsEnumerator (entity)) Use (entity.enumerator->deprecation, location), Use (entity.enclosingScope->enumeration->deprecation, location);
	else if (IsAlias (entity) && IsClass (*entity.alias)) Use (entity.alias->class_->deprecation, location);
	else if (IsAlias (entity) && IsEnumeration (*entity.alias)) Use (entity.alias->enumeration->deprecation, location);
	else if (IsFunction (entity) && IsDeleted (*entity.function)) EmitError (location, Format ("using deleted %0", entity));
	else if (IsMainFunction (entity)) EmitError (location, Format ("using %0", entity));
	else Use (entity.deprecation, location);
	if (IsVariable (entity) && HasAutomaticStorageDuration (*entity.variable))
		if (const auto class_ = GetEnclosingClass (*currentScope)) if (IsLocal (*class_)) EmitError (location, Format ("using %0 in local %1", entity, class_->scope));
	if (IsInline (entity) && !IsDefined (entity)) inlineUses.push_back ({entity, location});
	++entity.uses; return entity;
}

void Context::Use (Deprecation& deprecation, const Location& location) const
{
	if (!deprecation.attribute) return;
	if (HasRationale (*deprecation.attribute)) EmitWarning (location, Concatenate (*deprecation.attribute->deprecated.stringLiteral));
	else EmitWarning (location, "using deprecated entity", deprecation.attribute->location);
}

void Context::WarnAboutUnusedEntities (const Scope& scope) const
{
	for (auto& entry: scope.symbolTable)
		if (!IsUsed (*entry.second) && !IsMaybeUnused (*entry.second)) EmitWarning (entry.second->location, Format ("%0 never used", *entry.second));
		else if (IsEnumeration (*entry.second) && IsScoped (*entry.second->enumeration)) WarnAboutUnusedEntities (entry.second->enumeration->scope);
}

void Context::CheckExtended (AlignmentSpecification& alignment)
{
	if (!alignment.specifier) return;
	if (alignment.specifier->alignment >= alignment.value) alignment.value = alignment.specifier->alignment;
	else EmitError (alignment.specifier->location, Format ("requesting less strict alignment '%0'", alignment.specifier->alignment));
}

void Context::CheckFundamental (AlignmentSpecification& alignment)
{
	if (!alignment.specifier) return;
	if (checker.platform.IsFundamental (alignment.specifier->alignment)) CheckExtended (alignment);
	else EmitError (alignment.specifier->location, Format ("requesting unsupported extended alignment '%0'", alignment.specifier->alignment));
}

Declarator* Context::DisambiguateEllipsis (ParameterDeclarations& declarations) const
{
	return !declarations.empty () && declarations.back ().declarator ? DisambiguateEllipsis (*declarations.back ().declarator) : nullptr;
}

Declarator* Context::DisambiguateEllipsis (Declarator& declarator) const
{
	switch (declarator.model)
	{
	case Declarator::Name: return declarator.name.isPacked && !declarator.name.identifier ? &declarator : nullptr;
	case Declarator::Array: case Declarator::Function: case Declarator::Parenthesized: return nullptr;
	case Declarator::Pointer: return declarator.pointer.declarator ? DisambiguateEllipsis (*declarator.pointer.declarator) : nullptr;
	case Declarator::Reference: return declarator.reference.declarator ? DisambiguateEllipsis (*declarator.reference.declarator) : nullptr;
	case Declarator::MemberPointer: return declarator.memberPointer.declarator ? DisambiguateEllipsis (*declarator.memberPointer.declarator) : nullptr;
	default: assert (Declarator::Unreachable);
	}
}

bool Context::IsFinal (const Lexer::BasicToken& token) const
{
	return token.symbol == Lexer::Identifier && token.identifier == checker.final;
}

bool Context::IsOverride (const Lexer::BasicToken& token) const
{
	return token.symbol == Lexer::Identifier && token.identifier == checker.override;
}

bool Context::IsVirtualSpecifier (const Lexer::BasicToken& token) const
{
	return IsFinal (token) || IsOverride (token);
}

bool Context::IsTypeName (const Identifier& identifier) const
{
	for (auto entity: Search (identifier)) if (IsType (*entity)) return true; return false;
}

bool Context::IsScopeName (const Identifier& identifier) const
{
	for (auto entity: Search (identifier)) if (IsScope (*entity)) return true; return false;
}

bool Context::IsTemplateName (const Identifier& identifier) const
{
	for (auto entity: Search (identifier)) if (IsTemplate (*entity)) return true; return false;
}

Entities Context::Search (const Identifier& identifier) const
{
	Entities entities; const Name name {identifier};
	if (IsUnqualified (identifier)) LookupUnqualified (name, entities);
	else identifier.nestedNameSpecifier->scope->LookupQualified (name, entities);
	return entities;
}

bool Context::LookupUnqualified (const Name& name, Entities& entities) const
{
	assert (currentScope); if (currentScope->LookupUnqualified (name, entities)) return true;
	for (auto& declaration: enclosingDeclarations) if (IsTemplate (*declaration) && declaration->template_.scope->LookupUnqualified (name, entities)) return true;
	return false;
}

Entities Context::Lookup (const Identifier& identifier) const
{
	Entities entities; const Name name {identifier};
	if (IsUnqualified (identifier) && !LookupUnqualified (name, entities))
		EmitError (identifier.location, Format ("undeclared identifier '%0'", name));
	else if (IsQualified (identifier) && !identifier.nestedNameSpecifier->scope->LookupQualified (name, entities))
		EmitError (identifier.location, Format ("identifier '%0' undeclared in %1", name, *identifier.nestedNameSpecifier->scope));
	return entities;
}

Entity& Context::Lookup (const Identifier& identifier, const Type& type) const
{
	const auto entities = Lookup (identifier);
	if (IsFunction (type)) for (auto entity: entities) if (IsFunction (*entity) && entity->function->type == type) return *entity;
	if (entities.size () == 1) return *entities.front (); EmitErrorNote (identifier.location, Format ("identifier '%0' is ambiguous", identifier));
	for (auto entity: entities) EmitNote (entity->location, Format ("candidate is %0 in %1", *entity, *entity->enclosingScope)); throw Error {};
}

Entity& Context::LookupType (const Identifier& identifier) const
{
	const auto entities = Lookup (identifier);
	for (auto entity: entities) if (!IsType (*entity)) EmitError (identifier.location, Format ("identifier '%0' does not name a type", identifier));
	for (auto entity: entities) if (IsAlias (*entity)) return Use (*entity, identifier.location);
	for (auto entity: entities) if (IsType (*entity)) return Use (*entity, identifier.location);
	assert (Type::Unreachable);
}

Scope& Context::LookupScope (const Identifier& identifier) const
{
	for (auto entity: Lookup (identifier)) if (IsScope (*entity)) return GetScope (Use (*entity, identifier.location));
	EmitError (identifier.location, Format ("identifier '%0' does not name a scope", identifier));
}

Namespace& Context::LookupNamespace (const Identifier& identifier) const
{
	for (auto entity: Lookup (identifier)) if (IsNamespace (*entity)) return *Use (*entity, identifier.location).namespace_;
	EmitError (identifier.location, Format ("identifier '%0' does not name a namespace", identifier));
}

Entity& Context::LookupStandard (const Name& name, const Location& location, const char*const header) const
{
	Entities entities; translationUnit.global.scope.LookupQualified (Name {checker.std}, entities);
	Namespace* std = nullptr; for (auto entity: entities) if (IsNamespace (*entity)) std = Use (*entity, location).namespace_;
	entities.clear (); if (std && std->scope.LookupQualified (name, entities) && entities.size () == 1) return Use (*entities.front (), location);
	EmitError (location, Format ("header <%0> not included", header));
}

Entity& Context::Insert (const Entity::Model model, const Identifier& identifier, const Type& type, Scope& scope)
{
	const Name name {identifier}; const auto range = scope.symbolTable.equal_range (name);
	for (auto iterator = range.first; iterator != range.second; ++iterator) if (!iterator->second->Hides (model, type)) return *iterator->second;
	const auto global = currentLinkage == LanguageLinkage::C && (model == Entity::Function || model == Entity::Variable) && IsNamespace (scope) ? &translationUnit.globals[name] : nullptr;
	auto& entity = global && *global ? **global : translationUnit.Create<Entity> (model, name, identifier.location, scope);
	for (auto declaration: Reverse {enclosingDeclarations}) {if (IsTemplate (*declaration)) entity.templateParameters = declaration->template_.parameters; if (!IsBasic (*declaration)) break;}
	scope.symbolTable.emplace_hint (range.second, name, &entity); if (global) *global = &entity; return entity;
}

Entity& Context::Declare (const Entity::Model model, const Identifier& identifier, const Type& type, Scope& scope)
{
	auto& entity = IsQualified (identifier) ? Lookup (identifier, type) : Insert (model, identifier, type, scope);
	if (IsPredefined (entity)) EmitError (identifier.location, Format ("redeclaration of predefined %0", entity));
	if (entity.model != model) EmitError (identifier.location, Format ("identifier '%0' already used for %1", identifier, entity), entity.location);
	if (!IsIdentifier (entity.name) && !IsFunction (entity)) EmitError (entity.location, Format ("%0 has invalid name", entity));
	return entity;
}

Entity& Context::Define (Entity& entity, const Location& location)
{
	if (IsDefined (entity)) EmitError (location, Format ("redefinition of %0", entity), entity.location);
	entity.isDefined = true; entity.location = location; return entity;
}

Entity& Context::Predefine (Entity& entity, const Location& location)
{
	Define (entity, location); entity.isPredefined = true; entity.maybeUnused = true; return entity;
}

Entity& Context::DeclareLabel (const Identifier& identifier)
{
	assert (IsName (identifier)); assert (currentFunction);
	auto& entity = Insert (Entity::Label, identifier, {}, *currentFunction->scope);
	if (!entity.label) translationUnit.Create (entity.label, currentFunction->labels++);
	return entity;
}

Entity& Context::DefineLabel (const Identifier& identifier, const Statement& statement)
{
	auto& entity = Define (DeclareLabel (identifier), identifier.location);
	assert (IsLabel (entity)); entity.label->statement = &statement; return entity;
}

void Context::CheckLabel (const Entity& entity)
{
	assert (IsLabel (entity));
	if (!IsDefined (entity)) EmitError (entity.location, Format ("jump to undefined %0", entity));
}

Entity& Context::Redeclare (Entity& entity, Scope& scope, const Location& location)
{
	if (entity.enclosingScope == &scope) return entity;
	const auto range = scope.symbolTable.equal_range (entity.name);
	for (auto iterator = range.first; iterator != range.second; ++iterator)
		if (iterator->second == &entity) return entity; else if (!iterator->second->Hides (entity))
			EmitError (location, Format ("redeclaration of %0 in %1 conflicts with %2", entity, scope, *iterator->second), iterator->second->location);
	return *scope.symbolTable.emplace_hint (range.second, entity.name, &entity)->second;
}

Entity& Context::DeclareAlias (const Type& type, const Identifier& identifier, const DeclarationSpecifiers& specifiers)
{
	if (IsQualified (identifier)) EmitError (identifier.location, Format ("qualified identifier '%0' in alias type declaration", identifier));
	auto& entity = Declare (Entity::Alias, identifier, type, *currentScope);
	for (auto& specifier: specifiers) if (!IsType (specifier) && !IsTypedef (specifier))
		EmitError (specifier.location, Format ("%0 specifier in declaration of %1", specifier, entity));
	if (IsClass (type) && !type.class_->entity) type.class_->entity = &entity; else if (IsEnumeration (type) && !type.enumeration->entity) type.enumeration->entity = &entity;
	if (!entity.alias) return translationUnit.Create (entity.alias, type), entity;
	if (type != *entity.alias) EmitError (identifier.location, Format ("inconsistent type in redeclaration of %0 declared as %1", entity, *entity.alias), entity.location);
	if (IsClass (*currentScope) && IsAliased (type) && type.alias == &entity) EmitError (identifier.location, Format ("redefinition of %0 in class scope", entity));
	return entity;
}

Entity& Context::DeclareFunction (const Type& type, const Identifier& identifier, const DeclarationSpecifiers& specifiers)
{
	auto& entity = Declare (Entity::Function, identifier, type, *currentScope);
	for (auto& specifier: specifiers) if (IsStorageClass (specifier) && !IsStatic (specifier) && !IsExtern (specifier) || IsTypedef (specifier))
		EmitError (specifier.location, Format ("%0 specifier in declaration of %1", specifier, entity));
	if (IsExtern (specifiers) && IsClass (*currentScope)) EmitError (identifier.location, Format ("declaration of extern %0", entity));
	if (IsStatic (specifiers) && IsBlock (*currentScope)) EmitError (identifier.location, Format ("declaration of static %0 in block scope", entity));
	if (IsInline (specifiers) && IsBlock (*currentScope)) EmitError (identifier.location, Format ("declaration of inline %0 in block scope", entity));
	if (IsQualifiedFunction (type) && (!IsMember (entity) || IsStatic (specifiers))) EmitError (identifier.location, Format ("declaration of %0 of type %1", entity, type));
	Function function {type, entity, currentLinkage, specifiers, IsGlobal (*entity.enclosingScope) && entity.name == checker.main, checker.platform};
	if (IsConversionFunction (identifier)) function.type.function.returnType = &identifier.conversionFunction.typeIdentifier->type;
	if (IsMain (function)) CheckMain (function, identifier); CheckLanguageLinkage (function, entity, identifier);
	if (!entity.function) return translationUnit.Create (entity.function, function), ++entity.function->declarations, entity;
	if (enclosingLinkages.empty ()) function.linkage = entity.function->linkage, function.type.function.linkage = entity.function->type.function.linkage;
	CheckConsistency (function, entity, identifier);
	return ++entity.function->declarations, entity;
}

Entity& Context::DefineFunction (const Type& type, const Identifier& identifier, const DeclarationSpecifiers& specifiers)
{
	return Define (DeclareFunction (type, identifier, specifiers), identifier.location);
}

Entity& Context::DeclareVariable (const Type& type, const Identifier& identifier, const DeclarationSpecifiers& specifiers)
{
	auto& entity = Declare (Entity::Variable, identifier, {}, *currentScope);
	for (auto& specifier: specifiers) if (IsFunction (specifier) || IsFriend (specifier) || IsTypedef (specifier))
		EmitError (specifier.location, Format ("%0 specifier in declaration of %1", specifier, entity));
	if (IsExtern (specifiers) && IsClass (*currentScope)) EmitError (identifier.location, Format ("declaration of extern %0", entity));
	if (IsInline (specifiers) && IsBlock (*currentScope)) EmitError (identifier.location, Format ("declaration of inline %0 in block scope", entity));
	if (IsInline (specifiers) && IsClass (*currentScope) && !IsStatic (specifiers)) EmitError (identifier.location, Format ("declaration of inline %0", entity));
	if (IsStatic (specifiers) && IsClass (*currentScope) && IsLocal (*currentScope->class_)) EmitError (identifier.location, Format ("declaration of static %0 in local %1", entity, *currentScope));
	Variable variable {type, entity, currentLinkage, specifiers, checker.platform};
	if (IsVoid (variable.type)) EmitError (identifier.location, Format ("%0 of type '%1'", entity, variable.type));
	CheckLanguageLinkage (variable, entity, identifier);
	if (!entity.variable) return translationUnit.Create (entity.variable, variable), entity;
	if (variable.isThreadLocal != entity.variable->isThreadLocal) EmitError (identifier.location, Format ("inconsistent thread locality in redeclaration of %0", entity), entity.location);
	CheckConsistency (variable, entity, identifier);
	return entity;
}

Entity& Context::DefineParameter (const Type&, const Identifier& identifier, const DeclarationSpecifiers&)
{
	assert (IsFunctionPrototype (*currentScope));
	return Define (Declare (Entity::Parameter, identifier, {}, *currentScope), identifier.location);
}

Namespace& Context::DefineNamespace (const bool isInline, const Location& location)
{
	assert (IsNamespace (*currentScope));
	if (!currentScope->namespace_->unnamed) translationUnit.Create (currentScope->namespace_->unnamed, currentScope, isInline, nullptr, ++currentScope->namespaces);
	return Define (*currentScope->namespace_->unnamed, isInline, location);
}

Namespace& Context::DefineNamespace (const bool isInline, const Identifier& identifier)
{
	assert (IsNamespace (*currentScope));
	auto& entity = Declare (Entity::Namespace, identifier, {}, *currentScope);
	if (!entity.namespace_) translationUnit.Create (entity.namespace_, currentScope, isInline, &entity, 0u);
	if (!IsDefined (entity)) Define (entity, identifier.location);
	return Define (*entity.namespace_, isInline, identifier.location);
}

Namespace& Context::Define (Namespace& namespace_, const bool isInline, const Location& location)
{
	assert (!IsGlobal (namespace_));
	if (isInline && !IsInline (namespace_)) EmitError (location, "inline extension of non-inline namespace");
	if (isInline) namespace_.scope.enclosingScope->AddInline (namespace_); return namespace_;
}

void Context::DefineNamespaceAlias (const Identifier& identifier, Namespace& namespace_)
{
	assert (IsUnqualified (identifier));
	auto& entity = Declare (Entity::NamespaceAlias, identifier, {}, *currentScope);
	if (entity.namespace_ != &namespace_) Define (entity, identifier.location);
	if (!entity.namespace_) entity.namespace_ = &namespace_;
}

Entity& Context::DeclareClass (const ClassKey& key, const Identifier& identifier)
{
	auto& entity = Declare (Entity::Class, identifier, {}, IsFunctionPrototype (*currentScope) ? *currentScope->enclosingScope : *currentScope);
	if (!entity.class_) return translationUnit.Create (entity.class_, *currentScope, key, &entity, 0u, checker.platform), entity;
	if (key != entity.class_->key) EmitError (IsUnion (key) == IsUnion (*entity.class_), identifier.location, Format ("using '%0' in redeclaration of %1", key, entity), entity.location);
	return entity;
}

Entity& Context::DeclareEnumeration (const EnumKey& key, const Identifier& identifier, const Type& underlyingType)
{
	auto& entity = Declare (Entity::Enumeration, identifier, {}, IsFunctionPrototype (*currentScope) ? *currentScope->enclosingScope : *currentScope);
	if (!entity.enumeration) return translationUnit.Create (entity.enumeration, *currentScope, key, &entity, 0u, underlyingType, checker.platform), entity;
	if (IsUnscoped (key) && IsScoped (*entity.enumeration)) EmitError (identifier.location, Format ("unscoped redeclaration of scoped %0", entity), entity.location);
	if (IsScoped (key) && IsUnscoped (*entity.enumeration)) EmitError (identifier.location, Format ("scoped redeclaration of unscoped %0", entity), entity.location);
	if (IsQualified (identifier)) if (!IsNamespace (*currentScope) || !currentScope->Contains (*entity.enclosingScope)) EmitError (identifier.location, Format ("redaclaration of %0 not in enclosing namespace", entity));
	else if (identifier.nestedNameSpecifier->scope != entity.enclosingScope) EmitError (identifier.location, Format ("indirect redaclaration of %0 in %1", entity, *identifier.nestedNameSpecifier->scope));
	if (underlyingType != entity.enumeration->underlyingType) EmitError (identifier.location, Format ("redeclaration of %0 with different underlying type", entity));
	return entity;
}

Entity& Context::DefineEnumerator (const Identifier& identifier)
{
	assert (IsEnumeration (*currentScope)); assert (IsUnqualified (identifier));
	auto& entity = Define (Declare (Entity::Enumerator, identifier, {}, *currentScope), identifier.location);
	if (IsUnscoped (*currentScope->enumeration)) Redeclare (entity, *currentScope->enclosingScope, identifier.location);
	assert (!entity.enumerator); translationUnit.Create (entity.enumerator, entity); return entity;
}

void Context::CheckConsistency (const Storage& storage, Entity& entity, const Identifier& identifier)
{
	assert (IsStorage (entity));
	if (storage.linkage != entity.storage->linkage) EmitError (identifier.location, Format ("inconsistent language linkage in redeclaration of %0", entity), entity.location);
	if (storage.type != entity.storage->type) EmitError (identifier.location, Format ("inconsistent type in redeclaration of %0", entity), entity.location);
	if (storage.isConstexpr != entity.storage->isConstexpr) EmitError (identifier.location, Format ("inconsistent constexpr specifier in redeclaration of %0", entity), entity.location);
	if (storage.isInline && !entity.storage->isInline && IsDefined (entity)) EmitError (identifier.location, Format ("declaring %0 as inline after its definition", entity), entity.location);
	entity.storage->isInline |= storage.isInline;
}

void Context::CheckLanguageLinkage (const Storage& storage, const Entity& entity, const Identifier& identifier)
{
	if (storage.linkage == LanguageLinkage::Oberon && !IsNamedNamespace (*entity.enclosingScope))
		EmitError (identifier.location, Format ("%0 with %1 linkage is not member of a named namespace", entity, storage.linkage));
}

void Context::CheckMain (const Function& function, const Identifier& identifier)
{
	assert (IsMain (function)); const auto& returnType = *function.type.function.returnType;
	if (returnType.model != Type::Integer) EmitError (identifier.location, Format ("%0 function returns %1", identifier, returnType));
	const auto parameters = function.type.function.parameterTypes->size (); if (!parameters) return;
	if (parameters != 2) EmitError (identifier.location, Format ("%0 function has invalid number of parameters", identifier));
	const auto& first = function.type.function.parameterTypes->front ();
	if (first.model != Type::Integer) EmitError (identifier.location, Format ("first parameter of %0 function has type %1", identifier, first));
	const auto& second = function.type.function.parameterTypes->back ();
	if (!IsPointer (second) || !IsPointer (*second.pointer.baseType) || second.pointer.baseType->pointer.baseType->model != Type::Character)
		EmitError (identifier.location, Format ("second parameter of %0 function has type %1", identifier, second));
}

bool Context::CheckReachability (FunctionBody& body)
{
	switch (body.model)
	{
	case FunctionBody::Try:
		assert (body.try_.block); assert (body.try_.handlers);
		return body.isExiting = CheckReachability (*body.try_.block, *body.try_.handlers, !body.try_.initializers || !IsNoreturnCall (*body.try_.initializers));

	case FunctionBody::Delete:
		return body.isExiting = false;

	case FunctionBody::Default:
		return body.isExiting = true;

	case FunctionBody::Regular:
		assert (body.regular.block);
		return body.isExiting = CheckReachability (*body.regular.block, !body.regular.initializers || !IsNoreturnCall (*body.regular.initializers), true);

	default:
		assert (FunctionBody::Unreachable);
	}
}

bool Context::CheckReachability (StatementBlock& block, bool isReachable, bool warn)
{
	for (auto& statement: block.statements)
	{
		isReachable = CheckReachability (statement, isReachable);
		if (!warn) warn = IsReachable (statement);
		else if (!IsReachable (statement) && !IsLabeled (statement)) EmitWarning (statement.location, "unreachable statement"), warn = false;
	}
	if (block.enclosingStatement && IsIteration (*block.enclosingStatement) && block.enclosingStatement->continues) isReachable = true;
	return block.isExiting = isReachable;
}

bool Context::CheckReachability (Statement& statement, bool isReachable)
{
	switch (statement.model)
	{
	case Statement::Case:
	{
		assert (statement.case_.label);
		const auto switchStatement = GetEnclosingSwitch (statement); assert (switchStatement);
		assert (switchStatement->switch_.condition.expression); assert (switchStatement->switch_.caseTable);
		if (isReachable) if (const auto previous = GetPrevious (statement)) if (IsReachable (*previous) && !IsFallthrough (*previous))
			EmitWarning (statement.location, "case label reachable from previous statement", previous->location);
		if (IsReachable (*switchStatement)) if (!IsConstant (*switchStatement->switch_.condition.expression) ||
			statement.case_.label->value.signed_ == switchStatement->switch_.condition.expression->value.signed_) isReachable = true;
		else if (!isReachable) EmitWarning (statement.location, "unreachable case label");
		break;
	}

	case Statement::Label:
		assert (statement.label.entity);
		if (IsUsed (*statement.label.entity)) isReachable = true;
		break;

	case Statement::Default:
	{
		const auto switchStatement = GetEnclosingSwitch (statement); assert (switchStatement);
		assert (switchStatement->switch_.condition.expression); assert (switchStatement->switch_.caseTable);
		if (isReachable) if (const auto previous = GetPrevious (statement)) if (IsReachable (*previous) && !IsFallthrough (*previous))
			EmitWarning (statement.location, "default label reachable from previous statement", previous->location);
		if (IsReachable (*switchStatement)) if (!IsConstant (*switchStatement->switch_.condition.expression) ||
			switchStatement->switch_.caseTable->find (switchStatement->switch_.condition.expression->value.signed_) == switchStatement->switch_.caseTable->end ()) isReachable = true;
		else if (!isReachable) EmitWarning (statement.location, "unreachable default label");
		break;
	}

	case Statement::Declaration:
		assert (statement.declaration);
		if (IsAsm (*statement.declaration)) isReachable = true;
		break;
	}

	statement.isReachable = isReachable;

	switch (statement.model)
	{
	case Statement::Do:
		assert (statement.do_.statement); assert (statement.do_.condition); statement.breaks = statement.continues = false;
		statement.isReachable |= CheckReachability (*statement.do_.statement, isReachable, isReachable) && !IsFalse (*statement.do_.condition);
		if (statement.isReachable && !isReachable) CheckReachability (*statement.do_.statement, true, true);
		return statement.isReachable && !IsTrue (*statement.do_.condition) || statement.breaks;

	case Statement::If:
		assert (statement.if_.condition.expression); assert (statement.if_.statement);
		return CheckReachability (*statement.if_.statement, isReachable && !IsFalse (*statement.if_.condition.expression), isReachable) |
			(statement.if_.elseStatement ? CheckReachability (*statement.if_.elseStatement, isReachable && !IsTrue (*statement.if_.condition.expression), isReachable) :
				isReachable && !IsTrue (*statement.if_.condition.expression));

	case Statement::For:
		statement.breaks = statement.continues = false;
		assert (statement.for_.initStatement); assert (statement.for_.statement);
		isReachable = CheckReachability (*statement.for_.initStatement, isReachable);
		statement.isReachable |= CheckReachability (*statement.for_.statement, isReachable && (!statement.for_.condition || !IsFalse (*statement.for_.condition->expression)), isReachable);
		if (statement.isReachable && !isReachable) CheckReachability (*statement.for_.statement, !statement.for_.condition || !IsFalse (*statement.for_.condition->expression), true);
		return statement.isReachable && statement.for_.condition && !IsTrue (*statement.for_.condition->expression) || statement.breaks;

	case Statement::Try:
		assert (statement.try_.block); assert (statement.try_.handlers);
		return CheckReachability (*statement.try_.block, *statement.try_.handlers, isReachable);

	case Statement::Case:
	case Statement::Label:
	case Statement::Default:
		return isReachable;

	case Statement::Goto:
		return false;

	case Statement::Null:
		if (IsFallthrough (statement))
			if (const auto next = GetNext (statement)) if (!IsSwitchLabel (*next)) EmitError (next->location, "invalid statement after fallthrough statement", statement.null.fallthrough->location); else;
			else EmitError (statement.location, "missing case or default label after fallthrough statement");
		return isReachable;

	case Statement::Break:
		if (isReachable) GetEnclosingBreakable (statement)->breaks = true;
		return false;

	case Statement::While:
		assert (statement.while_.condition.expression); assert (statement.while_.statement); statement.breaks = statement.continues = false;
		statement.isReachable |= CheckReachability (*statement.while_.statement, isReachable && !IsFalse (*statement.while_.condition.expression), isReachable);
		if (statement.isReachable && !isReachable) CheckReachability (*statement.while_.statement, !IsFalse (*statement.while_.condition.expression), true);
		return statement.isReachable && !IsTrue (*statement.while_.condition.expression) || statement.breaks;

	case Statement::Return:
		assert (currentFunction);
		if (isReachable) currentFunction->isReturning |= !statement.return_.expression || !IsNoreturnCall (*statement.return_.expression);
		return false;

	case Statement::Switch:
		assert (statement.switch_.condition.expression); assert (statement.switch_.statement); assert (statement.switch_.caseTable); statement.breaks = false;
		return CheckReachability (*statement.switch_.statement, false, isReachable) || !statement.switch_.defaultLabel && (!IsConstant (*statement.switch_.condition.expression) ||
			statement.switch_.caseTable->find (statement.switch_.condition.expression->value.signed_) == statement.switch_.caseTable->end ()) || statement.breaks;

	case Statement::Compound:
		assert (statement.compound.block);
		return CheckReachability (*statement.compound.block, isReachable, isReachable);

	case Statement::Continue:
		if (isReachable) GetEnclosingIteration (statement)->continues = true;
		return false;

	case Statement::Expression:
		assert (statement.expression);
		return isReachable && !IsNoreturnCall (*statement.expression);

	case Statement::Declaration:
		assert (statement.declaration);
		return isReachable && !IsNoreturn (*statement.declaration);

	default:
		assert (Statement::Unreachable);
	}
}

bool Context::CheckReachability (StatementBlock& block, ExceptionHandlers& handlers, const bool isReachable)
{
	auto isExiting = CheckReachability (block, isReachable, isReachable);
	for (auto& handler: handlers) isExiting |= CheckReachability (handler.block, isReachable, isReachable);
	return isExiting;
}

void Context::ReserveBlockSpace (Variable& variable)
{
	if (IsStatic (variable)) return;
	assert (currentFunction); currentFunction->alignment &= variable.alignment.value;
	currentFunction->alignment &= checker.platform.GetStackAlignment (variable.type);
	if (IsRegister (variable)) ReserveRegisterSpace (variable.register_, variable.type, variable.entity->location);
	bytes = Align (bytes, variable.alignment.value) + checker.platform.GetSize (variable.type);
	variable.offset = bytes; variable.index = variables++;
}

void Context::ReserveClassSpace (Variable& variable)
{
	if (IsStatic (variable)) return; assert (IsClass (*currentScope)); auto& class_ = *currentScope->class_;
	if (IsBitField (variable)) ReserveClassSpace (variable.length, variable.type, variable.alignment.value), variable.offset = class_.offset, variable.position = class_.position - variable.length;
	else ReserveClassSpace (variable.alignment.value), variable.offset = class_.offset, class_.bytes = std::max (class_.bytes, variable.offset + checker.platform.GetSize (variable.type));
	if (!IsUnion (class_) && !IsBitField (variable)) class_.offset = class_.bytes, class_.position = 0;
	if (!class_.firstDataMember) class_.firstDataMember = &variable;
	class_.alignment &= variable.alignment.value;
}

void Context::ReserveClassSpace (const Bits length, const Type& type, const Alignment alignment)
{
	assert (IsClass (*currentScope)); auto& class_ = *currentScope->class_; const auto bits = checker.platform.GetBits (type);
	if (Align (class_.offset, alignment) != class_.offset || class_.position % bits + length > bits) class_.position = Align (class_.position, bits), ReserveClassSpace (alignment);
	class_.bytes = std::max (class_.bytes, class_.offset + Align (class_.position + length, bits) / bits * checker.platform.GetSize (type));
	if (!IsUnion (class_)) class_.position += length;
}

void Context::ReserveClassSpace (const Alignment alignment)
{
	assert (IsClass (*currentScope)); auto& class_ = *currentScope->class_;
	if (!IsUnion (class_)) class_.offset = Align (class_.offset + (class_.position + 7) / 8, alignment), class_.position = 0;
}

void Context::ReserveSpace (Parameters& parameters)
{
	Size offset = 0, index = 0;
	for (auto& parameter: parameters)
	{
		if (IsRegister (parameter)) ReserveRegisterSpace (parameter.register_, parameter.declaration->type, parameter.declaration->location);
		offset = Align (offset, checker.platform.GetStackAlignment (parameter.declaration->type));
		parameter.offset = offset; parameter.index = index; ++index;
		offset += checker.platform.GetSize (parameter.declaration->type);
	}
}

void Context::ReserveRegisterSpace (Size& register_, const Type& type, const Location& location)
{
	register_ = registers;
	if (++registers > 4) EmitError (location, "excessive register allocation");
	if (!IsRegister (type)) EmitError (location, Format ("invalid register type %0", type));
}

void Context::ConvertArithmetic (Expression& expression)
{
	assert (IsBinary (expression));
	auto &left = *expression.binary.left, &right = *expression.binary.right;
	if (!ConvertArithmetic (left, right.type) & !ConvertArithmetic (right, left.type))
		EmitError (expression.location, Format ("incompatible operand types %0 and %1 for binary expression '%2'", left.type, right.type, expression));
	if (IsIntegral (left.type) && IsIntegral (right.type) && IsSignedInteger (left.type) != IsSignedInteger (right.type))
		ConvertIntegral (left, checker.platform.GetUnsigned (IsSignedInteger (left.type) ? left.type : right.type), true, true), ConvertIntegral (right, left.type, true, true);
}

bool Context::ConvertArithmetic (Expression& expression, const Type& type)
{
	ConvertPRValue (expression, type);
	if (expression.type == type) return true;
	if (IsScopedEnumeration (type)) return false;
	if (IsLongDouble (type)) return ConvertStandard (expression, type, true, true);
	if (IsDouble (type)) return !IsLongDouble (expression.type) && ConvertStandard (expression, type, true, true);
	if (IsFloat (type)) return !IsDouble (expression.type) && !IsLongDouble (expression.type) && ConvertStandard (expression, type, true, true);
	if (!IsIntegral (type)) return false; PromoteIntegral (expression, type);
	if (!IsIntegral (expression.type)) return false; if (expression.type == type) return true;
	if (IsSignedInteger (expression.type) == IsSignedInteger (type))
		return checker.platform.GetRank (expression.type) < checker.platform.GetRank (type) ? ConvertIntegral (expression, type, true, true) : false;
	if (IsUnsignedInteger (type) && checker.platform.GetRank (type) >= checker.platform.GetRank (expression.type)) return ConvertIntegral (expression, type, true, true);
	if (IsSignedInteger (type) && checker.platform.GetSize (type) > checker.platform.GetSize (expression.type)) return ConvertIntegral (expression, type, true, true);
	return true;
}

void Context::Convert (Expression& expression, const Type& type, const bool implicit)
{
	if (!ConvertStandard (expression, type, true, implicit))
		EmitError (expression.location, Format ("failed to convert expression '%0' from type %1 to type %2", expression, expression.type, type));
}

void Context::ConvertConstant (Expression& expression, const Type& type)
{
	assert (IsConstant (expression));
	ConvertPRValue (expression, type); CheckConstant (expression);
	PromoteIntegral (expression, type) || ConvertIntegral (expression, type, false, true) || ConvertBoolean (expression, type);
	if (expression.type != type) EmitError (expression.location, Format ("failed to convert constant expression '%0' to type %1", expression, type));
}

bool Context::ConvertStandard (Expression& expression, const Type& type, const bool allowNarrowing, const bool implicit)
{
	ConvertPRValue (expression, type);
	PromoteIntegral (expression, type) || PromoteFloatingPoint (expression, type) || ConvertIntegral (expression, type, allowNarrowing, implicit) || ConvertFloatingPoint (expression, type) ||
		ConvertFloatingIntegral (expression, type, allowNarrowing, implicit) || ConvertPointer (expression, type) || ConvertMemberPointer (expression, type) || ConvertBoolean (expression, type);
	ConvertFunctionPointer (expression, type);
	ConvertQualification (expression, type);
	return expression.type == type;
}

void Context::ConvertPRValue (Expression& expression, const Type& type)
{
	ConvertLValueToRValue (expression, type) || ConvertArrayToPointer (expression, type) || ConvertFunctionToPointer (expression, type);
}

bool Context::ConvertLValueToRValue (Expression& expression, const Type& type)
{
	if (IsGLValue (expression) && !IsFunction (expression.type) && !IsArray (expression.type) && !IsReference (type))
		return Apply (Conversion::LValueToRValue, expression, expression.type, ValueCategory::PRValue);
	return false;
}

bool Context::ConvertArrayToPointer (Expression& expression, const Type& type)
{
	if (IsArray (expression.type) && (IsArray (type) || IsPointer (type) || IsBoolean (type)))
		return Apply (Conversion::ArrayToPointer, expression, expression.type.array.elementType, ValueCategory::PRValue);
	return false;
}

bool Context::ConvertFunctionToPointer (Expression& expression, const Type& type)
{
	if (IsFunction (expression.type) && (IsPointer (type) || IsBoolean (type)))
		return Apply (Conversion::FunctionToPointer, expression, &translationUnit.Create<Type> (expression.type), ValueCategory::PRValue);
	return false;
}

bool Context::ConvertQualification (Expression& expression, const Type& type)
{
	if (IsPRValue (expression) && IsPointer (expression.type) && IsPointer (type) && RemoveQualifiers (*expression.type.pointer.baseType) == RemoveQualifiers (*type.pointer.baseType) &&
		type.pointer.baseType->qualifiers.AreMoreQualifiedThan (expression.type.pointer.baseType->qualifiers))
		return Apply (Conversion::Qualification, expression, type, ValueCategory::PRValue);
	if (IsPRValue (expression) && IsMemberPointer (expression.type) && IsMemberPointer (type) && RemoveQualifiers (*expression.type.memberPointer.baseType) == RemoveQualifiers (*type.memberPointer.baseType) &&
		type.memberPointer.baseType->qualifiers.AreMoreQualifiedThan (expression.type.memberPointer.baseType->qualifiers))
		return Apply (Conversion::Qualification, expression, type, ValueCategory::PRValue);
	return false;
}

bool Context::PromoteIntegral (Expression& expression, const Type& type)
{
	if (type.model == Type::Integer && IsPRValue (expression) && IsBoolean (expression.type))
		return Apply (Conversion::IntegralPromotion, expression, type, ValueCategory::PRValue);
	if (IsIntegral (type) && !IsBoolean (type) && IsPRValue (expression) && IsUnscopedEnumeration (expression.type))
		return Apply (Conversion::IntegralPromotion, expression, type, ValueCategory::PRValue);
	return false;
}

bool Context::PromoteFloatingPoint (Expression& expression, const Type& type)
{
	if (type.model == Type::Double && IsPRValue (expression) && expression.type.model == Type::Float)
		return Apply (Conversion::FloatingPointPromotion, expression, type, ValueCategory::PRValue);
	return false;
}

bool Context::ConvertIntegral (Expression& expression, const Type& type, const bool allowNarrowing, const bool implicit)
{
	if (IsIntegral (type) && IsPRValue (expression) && (IsIntegral (expression.type) || IsUnscopedEnumeration (expression.type)))
		return Apply (IsBoolean (type) ? Conversion::Boolean : Conversion::Integral, expression, type, ValueCategory::PRValue, allowNarrowing, implicit);
	return false;
}

bool Context::ConvertFloatingPoint (Expression& expression, const Type& type)
{
	if (IsFloatingPoint (type) && IsPRValue (expression) && IsFloatingPoint (expression.type))
		return Apply (Conversion::FloatingPoint, expression, type, ValueCategory::PRValue);
	return false;
}

bool Context::ConvertFloatingIntegral (Expression& expression, const Type& type, const bool allowNarrowing, const bool implicit)
{
	if (IsIntegral (type) && IsPRValue (expression) && IsFloatingPoint (expression.type))
		return Apply (IsBoolean (type) ? Conversion::Boolean : Conversion::FloatingIntegral, expression, type, ValueCategory::PRValue, allowNarrowing, implicit);
	if (IsFloatingPoint (type) && IsPRValue (expression) && (IsIntegral (expression.type) || IsUnscopedEnumeration (expression.type)))
		return Apply (Conversion::FloatingIntegral, expression, type, ValueCategory::PRValue, allowNarrowing, implicit);
	return false;
}

bool Context::ConvertPointer (Expression& expression, const Type& type)
{
	if (IsPointer (type) && IsNullPointerConstant (expression))
		return Apply (Conversion::NullPointer, expression, type, ValueCategory::PRValue);
	if (IsPointer (type) && IsVoid (*type.pointer.baseType) && IsPointer (expression.type) && !IsVoid (*expression.type.pointer.baseType))
		return Apply (Conversion::Pointer, expression, type, ValueCategory::PRValue);
	return false;
}

bool Context::ConvertMemberPointer (Expression& expression, const Type& type)
{
	if (IsMemberPointer (type) && IsNullPointerConstant (expression))
		return Apply (Conversion::NullMemberPointer, expression, type, ValueCategory::PRValue);
	return false;
}

bool Context::ConvertFunctionPointer (Expression& expression, const Type& type)
{
	if (IsFunctionPointer (type) && IsPRValue (expression) && IsFunctionPointer (expression.type) && expression.type.pointer.baseType->function.noexcept_ && !type.pointer.baseType->function.noexcept_ &&
		RemoveExceptionSpecification (*expression.type.pointer.baseType) == *type.pointer.baseType)
		return Apply (Conversion::FunctionPointer, expression, type, ValueCategory::PRValue);
	if (IsMemberFunctionPointer (type) && IsPRValue (expression) && IsMemberFunctionPointer (expression.type) && expression.type.memberPointer.baseType->function.noexcept_ && !type.memberPointer.baseType->function.noexcept_ &&
		expression.type.memberPointer.class_ == type.memberPointer.class_ && RemoveExceptionSpecification (*expression.type.pointer.baseType) == *type.pointer.baseType)
		return Apply (Conversion::FunctionPointer, expression, type, ValueCategory::PRValue);
	return false;
}

bool Context::ConvertBoolean (Expression& expression, const Type& type)
{
	if (IsBoolean (type) && IsPRValue (expression) && (IsArithmetic (expression.type) || IsPointer (expression.type) || IsNullPointer (expression.type)))
		return Apply (Conversion::Boolean, expression, type, ValueCategory::PRValue);
	return false;
}

bool Context::Apply (const Conversion conversion, Expression& expression, const Type& type, const ValueCategory category, const bool allowNarrowing, const bool implicit)
{
	if (expression.type == type && expression.category == category) return false;
	if (conversion == Conversion::NullPointer && !IsNullPointer (expression.type))
		EmitWarning (expression.location, Format ("using '%0' as null pointer constant", expression));
	translationUnit.Create (expression.conversion.expression, expression);
	expression.model = Expression::Conversion; expression.conversion.model = conversion;
	Classify (expression, type, category, HasSideEffects (*expression.conversion.expression), IsPotentiallyThrowing (*expression.conversion.expression), false);
	if (IsNarrowingConversion (expression, checker.platform) && implicit) EmitError (allowNarrowing, expression.location, Format ("implicit conversion of '%0' from %1 to %2 is narrowing", *expression.conversion.expression, expression.conversion.expression->type, type));
	return true;
}

void Context::ExpandFunctionCall (Expression& expression)
{
	assert (IsFunctionCall (expression)); assert (expression.functionCall.function);
	auto& function = *expression.functionCall.function; assert (IsInlineable (function));
	const auto arguments = expression.functionCall.arguments;
	translationUnit.Create (expression.inlinedFunctionCall.expression, expression);
	expression.model = Expression::InlinedFunctionCall; expression.inlinedFunctionCall.body = function.body;
	Expansion expansion; const Restore restoreExpansion {currentExpansion, &expansion};
	translationUnit.Create (expression.inlinedFunctionCall.scope, Scope::Block, currentScope); EnterBlock (*expression.inlinedFunctionCall.scope);
	auto declaration = function.prototype->parameterDeclarations.begin (); if (arguments) for (auto& argument: *arguments) Map (*declaration, argument), ++declaration;
	Expand (expression.inlinedFunctionCall.body); LeaveBlock (*expression.inlinedFunctionCall.scope);
}

void Context::Map (const ParameterDeclaration& declaration, const Expression& argument)
{
	if (!declaration.entity) return; assert (declaration.declarator);
	auto& entity = Predefine (Declare (Entity::Variable, *GetName (*declaration.declarator).name.identifier, {}, *currentScope), declaration.location);
	translationUnit.Create (entity.variable, declaration.type, entity, LanguageLinkage::CPP, declaration.specifiers, checker.platform);
	entity.uses = declaration.entity->uses; entity.variable->value = argument.value; ReserveBlockSpace (*entity.variable);
	currentExpansion->map.emplace (&declaration, entity.variable);
}

Entity* Context::MapExpandedParameter (const Entity& entity)
{
	assert (currentExpansion); if (!IsParameter (entity)) return nullptr;
	const auto result = currentExpansion->map.find (entity.parameter);
	return result != currentExpansion->map.end () ? result->second->entity : nullptr;
}

template <typename Structure>
void Context::Expand (Structure*& structure)
{
	if (structure) translationUnit.Create (structure, *structure), Expand (*structure);
}

template <typename Structure>
void Context::Expand (List<Structure>& list)
{
	for (auto& structure: list) Expand (structure);
}

void Context::Expand (FunctionBody& body)
{
	switch (body.model)
	{
	case FunctionBody::Regular:
		Expand (body.regular.block);
		break;

	default:
		assert (FunctionBody::Unreachable);
	}
}

void Context::Expand (StatementBlock& block)
{
	for (auto& statement: block.statements) Expand (statement);
}

void Context::Expand (Statement& statement)
{
	switch (statement.model)
	{
	case Statement::Do:
		return Expand (statement.do_.statement), Expand (statement.do_.condition);

	case Statement::If:
		return Expand (statement.if_.condition), Expand (statement.if_.statement), Expand (statement.if_.elseStatement);

	case Statement::For:
		return Expand (statement.for_.initStatement), Expand (statement.for_.condition), Expand (statement.for_.expression), Expand (statement.for_.statement);

	case Statement::Case:
	case Statement::Null:
	case Statement::Default:
	case Statement::Continue:
		return;

	case Statement::While:
		return Expand (statement.while_.condition), Expand (statement.while_.statement);

	case Statement::Return:
		return Expand (statement.return_.expression);

	case Statement::Switch:
		return Expand (statement.switch_.condition), Expand (statement.switch_.statement);

	case Statement::Compound:
		return Expand (statement.compound.block);

	case Statement::Expression:
		return Expand (statement.expression);

	case Statement::Declaration:
		return Expand (statement.declaration);

	default:
		assert (Statement::Unreachable);
	}
}

void Context::Expand (Condition& condition)
{
	Expand (condition.declaration); Expand (condition.expression);
}

void Context::Expand (Expression& expression)
{
	switch (expression.model)
	{
	case Expression::New:
	case Expression::Alignof:
	case Expression::Literal:
	case Expression::Noexcept:
	case Expression::Typetrait:
	case Expression::SizeofPack:
	case Expression::SizeofType:
	case Expression::StringLiteral:
	case Expression::SizeofExpression:
		break;

	case Expression::Cast:
	case Expression::ConstCast:
	case Expression::StaticCast:
	case Expression::DynamicCast:
	case Expression::ReinterpretCast:
		Expand (expression.cast.expression);
		break;

	case Expression::Comma:
		Expand (expression.comma.left); Expand (expression.comma.right);
		break;

	case Expression::Throw:
		Expand (expression.throw_.expression);
		break;

	case Expression::Unary:
		Expand (expression.unary.operand);
		break;

	case Expression::Braced:
		Expand (expression.braced.expressions);
		break;

	case Expression::Binary:
		Expand (expression.binary.left); Expand (expression.binary.right);
		break;

	case Expression::Prefix:
		Expand (expression.prefix.expression);
		break;

	case Expression::Delete:
		Expand (expression.delete_.expression);
		break;

	case Expression::Postfix:
		Expand (expression.postfix.expression);
		break;

	case Expression::Addressof:
		Expand (expression.addressof.expression);
		break;

	case Expression::Subscript:
		Expand (expression.subscript.left); Expand (expression.subscript.right);
		break;

	case Expression::Assignment:
		Expand (expression.assignment.left); Expand (expression.assignment.right);
		break;

	case Expression::Conversion:
		Expand (expression.conversion.expression);
		if (expression.conversion.model == Conversion::LValueToRValue && IsPRValue (*expression.conversion.expression))
			expression = *expression.conversion.expression;
		break;

	case Expression::Identifier:
		assert (expression.identifier.entity);
		if (const auto variable = MapExpandedParameter (*expression.identifier.entity)) expression.identifier.entity = variable;
		break;

	case Expression::Conditional:
		Expand (expression.conditional.left); Expand (expression.conditional.right); Expand (expression.conditional.condition);
		break;

	case Expression::Indirection:
		Expand (expression.indirection.expression);
		break;

	case Expression::FunctionCall:
		Expand (expression.functionCall.expression);
		Expand (expression.functionCall.arguments);
		break;

	case Expression::MemberAccess:
		Expand (expression.memberAccess.expression);
		break;

	case Expression::Parenthesized:
		Expand (expression.parenthesized.expression);
		break;

	case Expression::InlinedFunctionCall:
		Expand (expression.inlinedFunctionCall.body);
		break;

	default:
		assert (Expression::Unreachable);
	}

	try {FoldConstant (expression);} catch (const UndefinedBehavior&) {Invalidate (expression);}
}

void Context::Expand (Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Asm:
		Expand (declaration.asm_.entities);
		break;

	case Declaration::Alias:
	case Declaration::OpaqueEnum:
	case Declaration::UsingDirective:
	case Declaration::StaticAssertion:
	case Declaration::NamespaceAliasDefinition:
		break;

	case Declaration::Simple:
		Enter (declaration);
		Expand (declaration.simple.declarators);
		Leave (declaration);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::Expand (Entities& entities)
{
	for (auto& entity: entities) if (const auto variable = MapExpandedParameter (*entity)) entity = variable;
}

void Context::Expand (InitDeclarator& declarator)
{
	Expand (declarator.initializer);
	Check (declarator); FinalizeCheck (declarator);
}

void Context::Expand (Initializer& initializer)
{
	Expand (initializer.expressions);
}

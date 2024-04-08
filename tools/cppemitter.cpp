// C++ intermediate code emitter
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

#include "asmlexer.hpp"
#include "cdemittercontext.hpp"
#include "cpp.hpp"
#include "cppemitter.hpp"
#include "cppprinter.hpp"
#include "error.hpp"

#include <sstream>
#include <unordered_set>

using namespace ECS;
using namespace CPP;
using namespace Code;

using Context = class CPP::Emitter::Context : public Code::Emitter::Context
{
public:
	Context (const CPP::Emitter&, const TranslationUnit&, Sections&);

	void Emit ();

private:
	struct BitField {SmartOperand value, scale, mask;};
	struct FunctionDesignator {SmartOperand function, object;};

	const CPP::Emitter& emitter;
	const TranslationUnit& translationUnit;

	bool inlining = false;
	std::vector<SmartOperand> registers;
	std::vector<Label> labels, caseLabels;
	std::unordered_set<const Array*> arrays;
	const Function* currentFunction = nullptr;
	Label epilogue, breakLabel, continueLabel;

	using Code::Emitter::Context::Comment;
	template <typename Structure> void Comment (const Location&, const Structure&);

	void Emit (const Array&);
	void Emit (const CaseTable&, const Condition&);
	void Emit (const Declaration&);
	void Emit (const Declarations&);
	void Emit (const DeclarationSpecifier&);
	void Emit (const DeclarationSpecifiers&);
	void Emit (const Function&);
	void Emit (const FunctionBody&, const Operand&);
	void Emit (const InitDeclarator&);
	void Emit (const Statement&, const Operand&);
	void Emit (const StatementBlock&, const Operand&);
	void Emit (const TypeSpecifier&);
	void Emit (const Variable&);

	using Code::Emitter::Context::Leave;
	using Code::Emitter::Context::Convert;
	void Leave (const Scope&);
	Operand Evaluate (const Entity&);
	Operand Evaluate (const Function&);
	Operand Evaluate (const Variable&);
	Operand Evaluate (const Parameter&);
	void EvaluateDiscarded (const Expression&);
	Operand Evaluate (const Value&, const Type&);
	Operand EvaluateNonRegister (const Parameter&);
	void Evaluate (const FunctionBody&, const Operand&);
	SmartOperand Designate (const Operand&, const Type&);
	SmartOperand EvaluateBoolean (const Expression&, Hint);
	SmartOperand Evaluate (const Expression&, Hint = RVoid);
	SmartOperand Convert (const Expression&, const Type&, Hint);
	FunctionDesignator EvaluateFunction (const Expression&, Hint);
	void BranchConditional (const Condition&, bool, const Label&);
	void BranchConditional (const Expression&, bool, const Label&);
	SmartOperand SubtractPointer (const Expression&, const Expression&, Hint);
	SmartOperand IncrementPointer (const Expression&, const Operator&, const Expression&, Hint);

	BitField EvaluateBitField (const Expression&, Hint);
	SmartOperand Read (const BitField&, const Type&, Hint);
	void Write (const BitField&, const Operand&, const Type&);
	BitField EvaluateBitField (const Expression&, const Entity&, Hint);

	void Assign (const Operand&, const Operator&, const Operand&, const Type&);
	void Increment (void (Context::*) (const Operand&, const Operand&, const Operand&), const Operand&, const Operand&, const Type&);

	void Advance (Size&, const Type&);
	void ZeroInitialize (const Type&, Size&);
	void DefaultInitialize (const Variable&);
	void DefaultInitialize (const Parameter&);
	void Initialize (const Variable&, const Expression&);
	void Initialize (const Variable&, const Initializer&);
	void StringInitialize (const Type&, const Value&, Size&);
	void Initialize (const Variable&, const Initializer&, Size&);
	void StringInitialize (const Operand&, const Type&, const Expression&);

	using Code::Emitter::Context::Push;
	void Push (const Expressions&, Size&);

	void Break (const Location&);
	void Locate (const Location&);

	void Declare (const Entity&);
	void Declare (const Type&);

	Code::Type GetType (const Type&);

	using Code::Emitter::Context::AcquireRegister;
	void ReleaseRegister (const Operand&);
	SmartOperand& AccessRegister (const Operand&);
	void AcquireRegister (const Operand&, const Type&);

	using Code::Emitter::Context::Begin;
	void Begin (Section::Type, const Section::Name&, const Storage&);

	using Code::Emitter::Context::Assemble;
	void Assemble (const Declaration&);
	void Assemble (const Entity&, std::ostream&);
	void Assemble (const Enumeration&, std::ostream&);
	void Assemble (const Lexer::Token&, const Location&, std::ostream&);
};

CPP::Emitter::Emitter (Diagnostics& d, StringPool& sp, Charset& c, Code::Platform& cp, Platform& p) :
	Code::Emitter {d, sp, c, cp}, platform {p}
{
}

void CPP::Emitter::Emit (const TranslationUnit& translationUnit, Sections& sections) const
{
	Context {*this, translationUnit, sections}.Emit ();
}

Context::Context (const CPP::Emitter& e, const TranslationUnit& tu, Sections& s) :
	Code::Emitter::Context {e, s}, emitter {e}, translationUnit {tu}, arrays {translationUnit.stringLiterals.size ()}
{
}

template <typename Structure>
void Context::Comment (const Location& location, const Structure& structure)
{
	if (inlining) return;
	if (location.source == &translationUnit.source) Comment (location.position, structure); else Comment (*location.source, location.position, structure);
}

void Context::Emit ()
{
	Emit (translationUnit.declarations);
}

Context::SmartOperand Context::Evaluate (const Expression& expression, const Hint hint)
try
{
	if (IsConstant (expression) && !HasSideEffects (expression))
		return Evaluate (expression.value, expression.type);

	switch (expression.model)
	{
	case Expression::Cast:
		assert (expression.cast.expression);
		return Convert (*expression.cast.expression, expression.type, hint);

	case Expression::Comma:
		assert (expression.comma.left); assert (expression.comma.right);
		return EvaluateDiscarded (*expression.comma.left), Evaluate (*expression.comma.right, hint);

	case Expression::Unary:
	{
		assert (expression.unary.operand);
		auto value = Evaluate (*expression.unary.operand, hint);

		switch (expression.unary.operator_.symbol)
		{
		case Lexer::Plus:
			return value;
		case Lexer::Minus:
			return Negate (value, hint);
		case Lexer::ExclamationMark: case Lexer::Not:
			return ExclusiveOr (value, UImm {value.type, 1}, hint);
		case Lexer::Tilde: case Lexer::Compl:
			return Complement (value, hint);
		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Binary:
	{
		assert (expression.binary.left);
		assert (expression.binary.right);

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::Plus:
			if (IsPointer (expression.binary.left->type)) return IncrementPointer (*expression.binary.left, expression.binary.operator_, *expression.binary.right, hint);
			if (IsPointer (expression.binary.right->type)) return IncrementPointer (*expression.binary.right, expression.binary.operator_, *expression.binary.left, hint);
			break;
		case Lexer::Minus:
			if (IsPointer (expression.binary.right->type)) return SubtractPointer (*expression.binary.left, *expression.binary.right, hint);
			if (IsPointer (expression.binary.left->type)) return IncrementPointer (*expression.binary.left, expression.binary.operator_, *expression.binary.right, hint);
			break;
		case Lexer::DoubleEqual:
		case Lexer::ExclamationMarkEqual: case Lexer::NotEq:
		case Lexer::Less:
		case Lexer::Greater:
		case Lexer::LessEqual:
		case Lexer::GreaterEqual:
		case Lexer::DoubleAmpersand: case Lexer::And:
		case Lexer::DoubleBar: case Lexer::Or:
			return EvaluateBoolean (expression, hint);
		}

		auto left = Evaluate (*expression.binary.left, hint);
		if (expression.binary.operator_.symbol == Lexer::DoubleLess || expression.binary.operator_.symbol == Lexer::DoubleGreater) left = MakeRegister (left, hint);
		auto right = Evaluate (*expression.binary.right, Reuse (hint, left));

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::Plus:
			return Add (left, right, hint);
		case Lexer::Minus:
			return Subtract (left, right, hint);
		case Lexer::Asterisk:
			return Multiply (left, right, hint);
		case Lexer::Slash:
			return Divide (left, right, hint);
		case Lexer::Percent:
			return Modulo (left, right, hint);
		case Lexer::DoubleLess:
			return ShiftLeft (left, right, hint);
		case Lexer::DoubleGreater:
			return ShiftRight (left, right, hint);
		case Lexer::Ampersand: case Lexer::Bitand:
			return And (left, right, hint);
		case Lexer::Caret: case Lexer::Xor:
			return ExclusiveOr (left, right, hint);
		case Lexer::Bar: case Lexer::Bitor:
			return Or (left, right, hint);

		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Prefix:
	{
		assert (expression.prefix.expression);
		auto result = Evaluate (*expression.prefix.expression, hint);
		auto value = Designate (result, expression.prefix.expression->type);
		Increment (add[expression.prefix.operator_.symbol == Lexer::DoublePlus], value, Imm {value.type, 1}, expression.prefix.expression->type);
		return result;
	}

	case Expression::Postfix:
	{
		assert (expression.postfix.expression);
		auto value = Designate (Evaluate (*expression.postfix.expression), expression.postfix.expression->type);
		auto result = Move (value, hint);
		Increment (add[expression.postfix.operator_.symbol == Lexer::DoublePlus], value, Imm {value.type, 1}, expression.postfix.expression->type);
		return result;
	}

	case Expression::Addressof:
		assert (expression.addressof.expression);
		return Evaluate (*expression.addressof.expression, hint);

	case Expression::Subscript:
		assert (expression.subscript.array); assert (expression.subscript.index);
		return IncrementPointer (*expression.subscript.array, {Lexer::Plus}, *expression.subscript.index, hint);

	case Expression::Assignment:
	{
		if (IsBitField (expression)) return EvaluateBitField (expression, hint).value;
		assert (expression.assignment.left);
		assert (expression.assignment.right);
		auto result = Evaluate (*expression.assignment.left, hint);
		auto designator = Designate (result, expression.type);
		Assign (designator, expression.assignment.operator_, Evaluate (*expression.assignment.right, Reuse (hint, result)), expression.type);
		return result;
	}

	case Expression::Conversion:
		assert (expression.conversion.expression);

		switch (expression.conversion.model)
		{
		case Conversion::Boolean:
			return EvaluateBoolean (expression, hint);
		case Conversion::Pointer:
		case Conversion::Integral:
		case Conversion::FloatingPoint:
		case Conversion::Qualification:
		case Conversion::FloatingIntegral:
		case Conversion::IntegralPromotion:
		case Conversion::FloatingPointPromotion:
			return Convert (*expression.conversion.expression, expression.type, hint);
		case Conversion::ArrayToPointer:
		case Conversion::FunctionPointer:
			return Evaluate (*expression.conversion.expression, hint);
		case Conversion::LValueToRValue:
			if (IsBitField (*expression.conversion.expression)) return Read (EvaluateBitField (*expression.conversion.expression, hint), expression.conversion.expression->type, hint);
			return Designate (Evaluate (*expression.conversion.expression, hint), expression.conversion.expression->type);

		default:
			assert (Expression::UnreachableConversion);
		}

	case Expression::Conditional:
	{
		assert (expression.conditional.left);
		assert (expression.conditional.right);
		assert (expression.conditional.condition);
		if (IsTrue (*expression.conditional.condition)) return Evaluate (*expression.conditional.left, hint);
		if (IsFalse (*expression.conditional.condition)) return Evaluate (*expression.conditional.right, hint);
		auto skip = CreateLabel (), end = CreateLabel ();
		BranchConditional (*expression.conditional.condition, false, skip);
		auto result = MakeRegister (Evaluate (*expression.conditional.left, hint), hint); Fix (result); Branch (end); skip ();
		Move (result, Evaluate (*expression.conditional.right, hint)); Unfix (result); end (); return result;
	}

	case Expression::Indirection:
		assert (expression.indirection.expression);
		return Evaluate (*expression.indirection.expression, hint);

	case Expression::FunctionCall:
	{
		assert (expression.functionCall.expression); Size size = 0;
		if (expression.functionCall.arguments) Push (*expression.functionCall.arguments, size);
		auto designator = EvaluateFunction (*expression.functionCall.expression, hint);
		if (!IsVoid (designator.object)) Push (designator.object);
		if (IsPointer (expression.functionCall.expression->type)) designator.function = Designate (designator.function, expression.functionCall.expression->type);
		return Call (IsVoid (expression.type) ? Code::Type {} : GetType (expression.type), designator.function, IsNoreturnCall (expression) ? 0 : size);
	}

	case Expression::MemberAccess:
		assert (expression.memberAccess.expression);
		assert (IsVariable (*expression.memberAccess.entity));
		return Add (Evaluate (*expression.memberAccess.expression, hint), expression.memberAccess.entity->variable->offset);

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return Evaluate (*expression.parenthesized.expression, hint);

	case Expression::ConstructorCall:
		assert (expression.constructorCall.expressions);
		assert (expression.constructorCall.expressions->size () == 1);
		return Evaluate (expression.constructorCall.expressions->front (), hint);

	case Expression::InlinedFunctionCall:
	{
		assert (expression.inlinedFunctionCall.body);
		assert (IsFunctionCall (*expression.inlinedFunctionCall.expression));
		const auto& functionCall = expression.inlinedFunctionCall.expression->functionCall;
		auto declaration = functionCall.function->prototype->parameterDeclarations.begin ();
		if (functionCall.arguments) for (auto& argument: *functionCall.arguments)
			if (!declaration->entity) EvaluateDiscarded (argument), ++declaration;
			else Initialize (*expression.inlinedFunctionCall.scope->symbolTable.find (declaration->entity->name)->second->variable, argument), ++declaration;
		auto result = AcquireRegister (GetType (expression.type), hint);
		Evaluate (*expression.inlinedFunctionCall.body, result);
		return result;
	}

	default:
		assert (Expression::Unreachable);
	}
}
catch (const RegisterShortage&)
{
	expression.location.Emit (Diagnostics::FatalError, emitter.diagnostics, "register shortage"); throw Error {};
}

void Context::EvaluateDiscarded (const Expression& expression)
{
	if (!HasSideEffects (expression)) return;

	switch (expression.model)
	{
	case Expression::Comma:
		assert (expression.comma.left); assert (expression.comma.right);
		return EvaluateDiscarded (*expression.comma.left), EvaluateDiscarded (*expression.comma.right);

	case Expression::Unary:
		assert (expression.unary.operand);
		return EvaluateDiscarded (*expression.unary.operand);

	case Expression::Binary:
		assert (expression.binary.left);
		assert (expression.binary.right);

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::DoubleAmpersand: case Lexer::And:
		{
			if (IsFalse (*expression.binary.left)) return; auto skip = CreateLabel ();
			if (!HasSideEffects (*expression.binary.right)) EvaluateDiscarded (*expression.binary.left);
			else BranchConditional (*expression.binary.left, false, skip), EvaluateDiscarded (*expression.binary.right);
			return skip ();
		}
		case Lexer::DoubleBar: case Lexer::Or:
		{
			if (IsTrue (*expression.binary.left)) return; auto skip = CreateLabel ();
			if (!HasSideEffects (*expression.binary.right)) EvaluateDiscarded (*expression.binary.left);
			else BranchConditional (*expression.binary.left, false, skip), EvaluateDiscarded (*expression.binary.right);
			return skip ();
		}
		}

		return EvaluateDiscarded (*expression.binary.left), EvaluateDiscarded (*expression.binary.right);

	case Expression::Prefix:
	case Expression::Postfix:
	{
		assert (expression.prefix.expression);
		auto value = Designate (Evaluate (*expression.prefix.expression), expression.prefix.expression->type);
		return Increment (add[expression.prefix.operator_.symbol == Lexer::DoublePlus], value, Imm {value.type, 1}, expression.prefix.expression->type);
	}

	case Expression::Assignment:
	case Expression::FunctionCall:
		return void (Evaluate (expression));

	case Expression::Addressof:
		assert (expression.addressof.expression);
		return EvaluateDiscarded (*expression.addressof.expression);

	case Expression::Conversion:
		assert (expression.conversion.expression);
		return EvaluateDiscarded (*expression.conversion.expression);

	case Expression::Indirection:
		assert (expression.indirection.expression);
		return EvaluateDiscarded (*expression.indirection.expression);

	case Expression::Conditional:
	{
		assert (expression.conditional.left);
		assert (expression.conditional.right);
		assert (expression.conditional.condition);
		if (IsTrue (*expression.conditional.condition)) return EvaluateDiscarded (*expression.conditional.left);
		if (IsFalse (*expression.conditional.condition)) return EvaluateDiscarded (*expression.conditional.right);
		if (!HasSideEffects (*expression.conditional.left) && !HasSideEffects (*expression.conditional.right))
			return EvaluateDiscarded (*expression.conditional.condition);
		auto skip = CreateLabel (), end = CreateLabel ();
		if (!HasSideEffects (*expression.conditional.left))
			BranchConditional (*expression.conditional.condition, true, end),
			EvaluateDiscarded (*expression.conditional.right), skip ();
		else if (!HasSideEffects (*expression.conditional.right))
			BranchConditional (*expression.conditional.condition, false, end),
			EvaluateDiscarded (*expression.conditional.left), skip ();
		else BranchConditional (*expression.conditional.condition, false, skip),
			EvaluateDiscarded (*expression.conditional.left), Branch (end), skip (),
			EvaluateDiscarded (*expression.conditional.right);
		return end ();
	}

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return EvaluateDiscarded (*expression.parenthesized.expression);

	case Expression::InlinedFunctionCall:
		assert (expression.inlinedFunctionCall.body);
		return Evaluate (*expression.inlinedFunctionCall.body, {});

	default:
		assert (Expression::Unreachable);
	}
}

Context::SmartOperand Context::EvaluateBoolean (const Expression& expression, const Hint hint)
{
	assert (!IsConstant (expression));
	auto skip = CreateLabel (); BranchConditional (expression, false, skip);
	return Set (skip, Evaluate (true, expression.type), Evaluate (false, expression.type), hint);
}

Context::FunctionDesignator Context::EvaluateFunction (const Expression& expression, const Hint hint)
{
	if (IsMemberAccess (expression) && IsFunction (*expression.memberAccess.entity))
		if (IsStaticMember (*expression.memberAccess.entity)) {EvaluateDiscarded (*expression.memberAccess.expression); return {Evaluate (*expression.memberAccess.entity), {}};}
		else return {Evaluate (*expression.memberAccess.entity), Evaluate (*expression.memberAccess.expression, hint)};
	return {Evaluate (expression, hint), {}};
}

Context::BitField Context::EvaluateBitField (const Expression& expression, const Hint hint)
{
	assert (IsBitField (expression));

	switch (expression.model)
	{
	case Expression::Comma:
		assert (expression.comma.left); assert (expression.comma.right);
		return EvaluateDiscarded (*expression.comma.left), EvaluateBitField (*expression.comma.right, hint);

	case Expression::Assignment:
	{
		assert (expression.assignment.left);
		assert (expression.assignment.right);
		auto result = EvaluateBitField (*expression.assignment.left, hint);
		if (expression.assignment.operator_.symbol == Lexer::Equal) return Write (result, Evaluate (*expression.assignment.right, Reuse (hint, result.value)), expression.type), result;
		auto designator = Read (result, expression.type, hint);
		Assign (designator, expression.assignment.operator_, Evaluate (*expression.assignment.right, Reuse (hint, result.value)), expression.type);
		Write (result, designator, expression.type);
		return result;
	}

	case Expression::Identifier:
		assert (expression.identifier.entity);
		return EvaluateBitField (expression, *expression.identifier.entity, hint);

	case Expression::Conditional:
	{
		assert (expression.conditional.left);
		assert (expression.conditional.right);
		assert (expression.conditional.condition);
		if (IsTrue (*expression.conditional.condition)) return EvaluateBitField (*expression.conditional.left, hint);
		if (IsFalse (*expression.conditional.condition)) return EvaluateBitField (*expression.conditional.right, hint);
		auto skip = CreateLabel (), end = CreateLabel ();
		BranchConditional (*expression.conditional.condition, false, skip);
		auto result = EvaluateBitField (*expression.conditional.left, hint);
		result.value = MakeRegister (result.value, hint); result.scale = MakeRegister (result.scale); result.mask = MakeRegister (result.mask);
		Fix (result.value); Fix (result.scale); Fix (result.mask); Branch (end); skip ();
		auto right = EvaluateBitField (*expression.conditional.right, hint);
		Move (result.value, right.value); Move (result.scale, right.scale); Move (result.mask, right.mask);
		Unfix (result.value); Unfix (result.scale); Unfix (result.mask); end (); return result;
	}

	case Expression::MemberAccess:
		assert (expression.memberAccess.entity);
		return EvaluateBitField (expression, *expression.memberAccess.entity, hint);

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return EvaluateBitField (*expression.parenthesized.expression, hint);

	default:
		assert (Expression::Unreachable);
	}
}

Context::BitField Context::EvaluateBitField (const Expression& expression, const Entity& entity, const Hint hint)
{
	assert (IsBitField (entity));
	const auto bits = emitter.platform.GetBits (expression.type), position = entity.variable->position % bits;
	const Imm scale {GetType (expression.type), position}; const auto length = IsBoolean (expression.type) ? 1 : std::min (entity.variable->length, bits - position);
	return {Add (Evaluate (expression, hint), entity.variable->position / bits), scale, Imm {scale.type, (Code::Signed::Value (1) << length) - 1 << position}};
}

Context::SmartOperand Context::Read (const BitField& bitField, const Type& type, const Hint hint)
{
	auto value = Designate (bitField.value, type);
	return ShiftRight (And (value, bitField.mask, hint), bitField.scale, hint);
}

void Context::Write (const BitField& bitField, const Operand& value, const Type& type)
{
	auto designator = Designate (bitField.value, type);
	auto mask = And (ShiftLeft (value, bitField.scale), bitField.mask);
	Or (designator, mask, And (designator, Complement (bitField.mask)));
}

void Context::Assign (const Operand& designator, const Operator& operator_, const Operand& value, const Type& type)
{
	switch (operator_.symbol)
	{
	case Lexer::Equal:
		return Move (designator, value);

	case Lexer::PlusEqual:
		return Increment (&Context::Add, designator, value, type);

	case Lexer::MinusEqual:
		return Increment (&Context::Subtract, designator, value, type);

	case Lexer::AsteriskEqual:
		return Multiply (designator, designator, value);

	case Lexer::SlashEqual:
		return Divide (designator, designator, value);

	case Lexer::PercentEqual:
		return Modulo (designator, designator, value);

	case Lexer::DoubleLessEqual:
		return ShiftLeft (designator, designator, value);

	case Lexer::DoubleGreaterEqual:
		return ShiftRight (designator, designator, value);

	case Lexer::AmpersandEqual: case Lexer::AndEq:
		return And (designator, designator, value);

	case Lexer::CaretEqual: case Lexer::XorEq:
		return ExclusiveOr (designator, designator, value);

	case Lexer::BarEqual: case Lexer::OrEq:
		return Or (designator, designator, value);

	default:
		assert (Lexer::UnreachableOperator);
	}
}

void Context::Increment (void (Context::*const operation) (const Operand&, const Operand&, const Operand&), const Operand& designator, const Operand& value, const Type& type)
{
	if (!IsPointer (type)) return (this->*operation) (designator, designator, value);
	(this->*operation) (designator, designator, Multiply (value, PtrImm {value.type, emitter.platform.GetSize (*type.pointer.baseType)}));
}

Context::SmartOperand Context::Convert (const Expression& expression, const Type& type, const Hint hint)
{
	return Convert (GetType (type), Evaluate (expression, hint), hint);
}

Context::SmartOperand Context::IncrementPointer (const Expression& base, const Operator& operator_, const Expression& increment, const Hint hint)
{
	auto array = Evaluate (base, hint), index = Evaluate (increment, Reuse (hint, array));
	const auto size = emitter.platform.GetSize (IsArray (base.type) ? *base.type.array.elementType : IsPointer (base.type) ? *base.type.pointer.baseType : base.type);
	const auto displacement = Convert (array.type, Multiply (index, SImm {index.type, Signed (size)}, hint), hint);
	return operator_.symbol == Lexer::Plus ? Add (array, displacement, hint) : Subtract (array, displacement, hint);
}

Context::SmartOperand Context::SubtractPointer (const Expression& left, const Expression& right, const Hint hint)
{
	auto first = Evaluate (left, hint), second = Evaluate (right, Reuse (hint, first));
	auto difference = Convert (Code::Signed {platform.pointer.size}, Subtract (first, second, hint), hint);
	return Divide (difference, Imm {difference.type, Signed (emitter.platform.GetSize (*left.type.pointer.baseType))}, hint);
}

void Context::Evaluate (const FunctionBody& body, const Operand& result)
{
	auto skip = CreateLabel (); epilogue.swap (skip);
	const Restore restoreInlining {inlining, true};
	Emit (body, result); epilogue.swap (skip); skip ();
}

void Context::BranchConditional (const Condition& condition, const bool value, const Label& label)
{
	assert (condition.expression);
	if (condition.declaration) Emit (*condition.declaration);
	BranchConditional (*condition.expression, value, label);
}

void Context::BranchConditional (const Expression& expression, const bool value, const Label& label)
{
	assert (IsBoolean (expression.type));

	if (IsConstant (expression) && !HasSideEffects (expression))
		if (expression.value.boolean == value) return Branch (label); else return;

	switch (expression.model)
	{
	case Expression::Comma:
		assert (expression.comma.left); assert (expression.comma.right);
		return EvaluateDiscarded (*expression.comma.left), BranchConditional (*expression.comma.right, value, label);

	case Expression::Unary:
	{
		assert (expression.unary.operand);

		switch (expression.unary.operator_.symbol)
		{
		case Lexer::ExclamationMark: case Lexer::Not:
			return BranchConditional (*expression.unary.operand, !value, label);

		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Binary:
	{
		assert (expression.binary.left);
		assert (expression.binary.right);

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::DoubleAmpersand: case Lexer::And:
		{
			if (IsFalse (*expression.binary.left)) return value ? Branch (label) : void ();
			auto skip = CreateLabel ();
			BranchConditional (*expression.binary.left, false, value ? skip : label);
			BranchConditional (*expression.binary.right, value, label);
			return skip ();
		}
		case Lexer::DoubleBar: case Lexer::Or:
		{
			if (IsTrue (*expression.binary.left)) return value ? Branch (label) : void ();
			auto skip = CreateLabel ();
			BranchConditional (*expression.binary.left, true, value ? label : skip);
			BranchConditional (*expression.binary.right, value, label);
			return skip ();
		}
		}

		auto left = Evaluate (*expression.binary.left);
		auto right = Evaluate (*expression.binary.right);

		switch (expression.binary.operator_.symbol)
		{
		case Lexer::DoubleEqual:
			return (this->*equal[value]) (label, left, right);
		case Lexer::ExclamationMarkEqual: case Lexer::NotEq:
			return (this->*equal[!value]) (label, left, right);
		case Lexer::Less:
			return (this->*less[value]) (label, left, right);
		case Lexer::Greater:
			return (this->*less[value]) (label, right, left);
		case Lexer::LessEqual:
			return (this->*less[!value]) (label, right, left);
		case Lexer::GreaterEqual:
			return (this->*less[!value]) (label, left, right);

		default:
			assert (Lexer::UnreachableOperator);
		}
	}

	case Expression::Conversion:
		assert (expression.conversion.expression);

		switch (expression.conversion.model)
		{
		case Conversion::LValueToRValue:
			return (this->*equal[!value]) (label, Evaluate (expression), UImm {GetType (expression.type), 0});
		case Conversion::Boolean:
			return (this->*equal[!value]) (label, Evaluate (*expression.conversion.expression), Imm {GetType (expression.conversion.expression->type), 0});

		default:
			assert (Expression::UnreachableConversion);
		}

	case Expression::Conditional:
	{
		assert (expression.conditional.left);
		assert (expression.conditional.right);
		assert (expression.conditional.condition);
		if (IsTrue (*expression.conditional.condition)) return BranchConditional (*expression.conditional.left, value, label);
		if (IsFalse (*expression.conditional.condition)) return BranchConditional (*expression.conditional.right, value, label);
		auto skip = CreateLabel (), end = CreateLabel ();
		BranchConditional (*expression.conditional.condition, false, skip);
		BranchConditional (*expression.conditional.left, value, label); Branch (end); skip ();
		BranchConditional (*expression.conditional.right, value, label);
		return end ();
	}

	case Expression::FunctionCall:
		return (this->*equal[!value]) (label, Evaluate (expression), UImm {GetType (expression.type), 0});

	case Expression::Parenthesized:
		assert (expression.parenthesized.expression);
		return BranchConditional (*expression.parenthesized.expression, value, label);

	default:
		assert (Expression::Unreachable);
	}
}

Operand Context::Evaluate (const Value& value, const Type& type)
{
	switch (value.model)
	{
	case Value::Float:
		return FImm {GetType (type), value.float_};

	case Value::Signed:
		return SImm {GetType (type), value.signed_};

	case Value::Boolean:
		return UImm {GetType (type), value.boolean};

	case Value::Pointer:
	case Value::Reference:
	{
		if (value.pointer.entity && !value.pointer.offset) return Evaluate (*value.pointer.entity);
		const auto displacement = value.pointer.offset * emitter.platform.GetSize (IsPointer (type) ? *type.pointer.baseType : type);
		if (value.pointer.entity) return Add (Evaluate (*value.pointer.entity), displacement);
		if (value.pointer.value) return Add (Evaluate (*value.pointer.value, *type.pointer.baseType), displacement);
		if (!value.pointer.array) return PtrImm {platform.pointer, Pointer::Value (displacement)};
		if (arrays.insert (value.pointer.array).second) Emit (*value.pointer.array);
		return Adr {platform.pointer, GetName (*value.pointer.array)};
	}

	case Value::Unsigned:
		return UImm {GetType (type), value.unsigned_};

	default:
		assert (Value::Unreachable);
	}
}

Operand Context::Evaluate (const Entity& entity)
{
	switch (entity.model)
	{
	case Entity::Label:
		return Adr {platform.function, GetName (entity)};

	case Entity::Function:
		return Evaluate (*entity.function);

	case Entity::Variable:
		return Evaluate (*entity.variable);

	case Entity::Parameter:
		return Evaluate (*entity.parameter->parameter);

	case Entity::Enumerator:
		return Evaluate (entity.enumerator->value, entity.enumerator->type);

	default:
		assert (Entity::Unreachable);
	}
}

Operand Context::Evaluate (const Function& function)
{
	if (function.origin) return FunImm {platform.function, function.origin->value.unsigned_};
	return Adr {platform.function, GetName (*function.entity)};
}

Operand Context::Evaluate (const Variable& variable)
{
	if (IsRegister (variable)) return variable.register_;
	if (variable.origin) return PtrImm {platform.pointer, variable.origin->value.unsigned_};
	if (HasStaticStorageDuration (variable)) return Adr {platform.pointer, GetName (*variable.entity)};
	return Add (emitter.framePointer, platform.stackDisplacement - Displacement (variable.offset));
}

Operand Context::Evaluate (const Parameter& parameter)
{
	if (IsRegister (parameter)) return parameter.register_;
	return EvaluateNonRegister (parameter);
}

Operand Context::EvaluateNonRegister (const Parameter& parameter)
{
	assert (currentFunction);
	if (IsMain (*currentFunction)) return Adr {platform.pointer, IsPointer (parameter.declaration->type) ? "_argv" : "_argc"};
	return Add (emitter.framePointer, platform.GetStackSize (platform.pointer) + platform.GetStackSize (platform.return_) + Displacement (parameter.offset) + platform.stackDisplacement);
}

Context::SmartOperand Context::Designate (const Operand& operand, const Type& type)
{
	if (IsSize (operand)) return Protect (AccessRegister (operand));
	return MakeMemory (GetType (type), operand, 0, IsVolatile (type));
}

void Context::Push (const Expressions& arguments, Size& size)
{
	for (auto& argument: Reverse {arguments}) size += Push (Evaluate (argument));
}

void Context::Break (const Location& location)
{
	Code::Emitter::Context::Break (*location.source, location.position);
}

void Context::Locate (const Location& location)
{
	Code::Emitter::Context::Locate (*location.source, location.position);
}

Code::Type Context::GetType (const Type& type)
{
	if (IsReference (type)) return platform.pointer;

	switch (type.model)
	{
	case Type::Character:
	case Type::UnsignedCharacter:
	case Type::Character16:
	case Type::Character32:
	case Type::WideCharacter:
	case Type::UnsignedShortInteger:
	case Type::UnsignedInteger:
	case Type::UnsignedLongInteger:
	case Type::UnsignedLongLongInteger:
	case Type::Boolean:
		return Code::Unsigned (emitter.platform.GetSize (type));

	case Type::SignedCharacter:
	case Type::ShortInteger:
	case Type::Integer:
	case Type::LongInteger:
	case Type::LongLongInteger:
		return Code::Signed (emitter.platform.GetSize (type));

	case Type::Float:
	case Type::Double:
	case Type::LongDouble:
		return Code::Float (emitter.platform.GetSize (type));

	case Type::NullPointer:
	case Type::MemberPointer:
		return Code::Pointer (emitter.platform.GetSize (type));

	case Type::Pointer:
		if (IsFunction (*type.pointer.baseType)) return Code::Function (emitter.platform.GetSize (type));
		return Code::Pointer (emitter.platform.GetSize (type));

	case Type::Enumeration:
		return GetType (type.enumeration->underlyingType);

	case Type::Function:
		return Code::Function (emitter.platform.GetSize (type));

	default:
		assert (Type::Unreachable);
	}
}

Context::SmartOperand& Context::AccessRegister (const Operand& operand)
{
	assert (IsSize (operand));
	assert (operand.size < registers.size ());
	return registers[operand.size];
}

void Context::AcquireRegister (const Operand& operand, const Type& type)
{
	Fix (AccessRegister (operand) = AcquireRegister (GetType (type)));
}

void Context::ReleaseRegister (const Operand& operand)
{
	Unfix (AccessRegister (operand));
}

void Context::Emit (const Statement& statement, const Operand& result)
{
	switch (statement.model)
	{
	case Statement::Do:
	{
		assert (statement.do_.statement); assert (statement.do_.condition);
		auto begin = CreateLabel (), skip = CreateLabel (), end = CreateLabel (); begin ();
		breakLabel.swap (end); continueLabel.swap (skip); Emit (*statement.do_.statement, result); breakLabel.swap (end); continueLabel.swap (skip); skip ();
		if (IsExiting (*statement.do_.statement)) Comment (statement.location, statement), BranchConditional (*statement.do_.condition, true, begin); end ();
		break;
	}

	case Statement::If:
	{
		auto skip = CreateLabel (), end = CreateLabel ();
		assert (statement.if_.condition.expression); assert (statement.if_.statement);
		if (IsReachable (statement) && !IsFalse (*statement.if_.condition.expression))
			Comment (statement.location, statement), BranchConditional (statement.if_.condition, false, skip);
		Emit (*statement.if_.statement, result); if (IsExiting (*statement.if_.statement)) Branch (end); skip ();
		if (statement.if_.elseStatement) Emit (*statement.if_.elseStatement, result); end (); Leave (*statement.scope);
		break;
	}

	case Statement::For:
	{
		assert (statement.for_.statement); assert (statement.for_.initStatement);
		auto begin = CreateLabel (), first = CreateLabel (), skip = CreateLabel (), end = CreateLabel ();
		if (IsReachable (statement))
		{
			Emit (*statement.for_.initStatement, {});
			if (statement.for_.condition && !IsTrue (*statement.for_.condition->expression)) Branch (first);
		}
		begin (); breakLabel.swap (end); continueLabel.swap (skip);
		Emit (*statement.for_.statement, result); breakLabel.swap (end); continueLabel.swap (skip);
		if (IsExiting (*statement.for_.statement))
		{
			Comment (statement.location, statement); skip ();
			if (statement.for_.expression) EvaluateDiscarded (*statement.for_.expression);
			first (); if (!statement.for_.condition) Branch (begin);
			else BranchConditional (*statement.for_.condition, true, begin);
		}
		else first (), skip (); Leave (*statement.scope); end ();
		break;
	}

	case Statement::Case:
		assert (statement.case_.index < caseLabels.size ());
		caseLabels[statement.case_.index] ();
		break;

	case Statement::Goto:
		assert (statement.goto_.entity);
		assert (statement.goto_.entity->label);
		assert (statement.goto_.entity->label->index < labels.size ());
		if (!IsReachable (statement)) break;
		Comment (statement.location, statement); Branch (labels[statement.goto_.entity->label->index]);
		break;

	case Statement::Null:
		break;

	case Statement::Break:
		if (!IsReachable (statement)) break;
		Comment (statement.location, statement); Branch (breakLabel);
		break;

	case Statement::Label:
		assert (statement.label.entity);
		assert (statement.label.entity->label);
		assert (statement.label.entity->label->index < labels.size ());
		labels[statement.label.entity->label->index] ();
		if (statement.label.entity->label->isAssembled) Comment (statement.location, statement), Alias (GetName (*statement.label.entity));
		break;

	case Statement::While:
	{
		auto begin = CreateLabel (), first = CreateLabel (), end = CreateLabel ();
		assert (statement.while_.condition.expression); assert (statement.while_.statement);
		if (IsReachable (statement) && !IsTrue (*statement.while_.condition.expression)) Branch (first); begin ();
		breakLabel.swap (end); continueLabel.swap (first); Emit (*statement.while_.statement, result); breakLabel.swap (end); continueLabel.swap (first); first ();
		if (IsExiting (*statement.while_.statement) && !IsFalse (*statement.while_.condition.expression)) Comment (statement.location, statement), BranchConditional (statement.while_.condition, true, begin);
		Leave (*statement.scope); end ();
		break;
	}

	case Statement::Return:
		if (!IsReachable (statement)) break;
		Comment (statement.location, statement);
		if (statement.return_.expression)
			if (!HasType (result) || IsVoid (statement.return_.expression->type)) EvaluateDiscarded (*statement.return_.expression);
			else Move (result, Evaluate (*statement.return_.expression, Reuse (result)));
		Branch (epilogue);
		break;

	case Statement::Switch:
	{
		assert (statement.switch_.caseTable); assert (statement.switch_.statement);
		decltype (caseLabels) labels; labels.reserve (statement.switch_.caseTable->size () + 1);
		for (auto count = statement.switch_.caseTable->size () + 1; count; --count) labels.push_back (CreateLabel ()); caseLabels.swap (labels);
		if (IsReachable (statement)) Comment (statement.location, statement), Emit (*statement.switch_.caseTable, statement.switch_.condition);
		auto end = CreateLabel (); breakLabel.swap (end); Emit (*statement.switch_.statement, result); breakLabel.swap (end); Leave (*statement.scope);
		caseLabels.swap (labels); if (!statement.switch_.defaultLabel) labels.back () (); end ();
		break;
	}

	case Statement::Default:
		assert (!caseLabels.empty ());
		caseLabels.back () ();
		break;

	case Statement::Compound:
		assert (statement.compound.block);
		Emit (*statement.compound.block, result);
		break;

	case Statement::Continue:
		if (!IsReachable (statement)) break;
		Comment (statement.location, statement); Branch (continueLabel);
		break;

	case Statement::Expression:
		assert (statement.expression);
		if (!IsReachable (statement) || !HasSideEffects (*statement.expression)) break;
		Comment (statement.location, statement); EvaluateDiscarded (*statement.expression);
		break;

	case Statement::Declaration:
		assert (statement.declaration);
		if (!IsReachable (statement)) break;
		Emit (*statement.declaration);
		break;

	default:
		assert (Statement::Unreachable);
	}
}

void Context::Emit (const CaseTable& caseTable, const Condition& condition)
{
	assert (condition.expression); if (condition.declaration) Emit (*condition.declaration);
	if (IsConstant (*condition.expression)) {const auto label = caseTable.find (condition.expression->value.signed_);
		return Branch (label != caseTable.end () ? caseLabels[label->second->case_.index] : caseLabels.back ());}
	auto value = MakeRegister (Evaluate (*condition.expression));
	for (auto& label: caseTable) BranchEqual (caseLabels[label.second->case_.index], value, Imm {value.type, label.first});
	Branch (caseLabels.back ());
}

void Context::Emit (const StatementBlock& block, const Operand& result)
{
	assert (block.scope);
	for (auto& statement: block.statements) Emit (statement, result);
	Leave (*block.scope);
}

void Context::Emit (const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Asm:
		Assemble (declaration);
		break;

	case Declaration::Alias:
	case Declaration::Empty:
	case Declaration::Using:
	case Declaration::Access:
	case Declaration::Template:
	case Declaration::Attribute:
	case Declaration::OpaqueEnum:
	case Declaration::UsingDirective:
	case Declaration::StaticAssertion:
	case Declaration::ExplicitInstantiation:
	case Declaration::ExplicitSpecialization:
	case Declaration::NamespaceAliasDefinition:
		break;

	case Declaration::Member:
		assert (declaration.member.specifiers);
		Emit (*declaration.member.specifiers);
		break;

	case Declaration::Simple:
		assert (declaration.simple.specifiers);
		Emit (*declaration.simple.specifiers);
		if (declaration.simple.declarators)
			for (auto& declarator: *declaration.simple.declarators) Emit (declarator);
		break;

	case Declaration::Condition:
		assert (declaration.condition.entity); assert (declaration.condition.initializer);
		Initialize (*declaration.condition.entity->variable, *declaration.condition.initializer);
		break;

	case Declaration::FunctionDefinition:
		assert (declaration.functionDefinition.body);
		assert (declaration.functionDefinition.entity);
		assert (IsFunction (*declaration.functionDefinition.entity));
		if (IsDeleted (*declaration.functionDefinition.entity->function)) break;
		Comment (declaration.location, declaration);
		Emit (*declaration.functionDefinition.entity->function->func);
		Emit (*declaration.functionDefinition.entity->function);
		break;

	case Declaration::NamespaceDefinition:
		if (declaration.namespaceDefinition.body) Emit (*declaration.namespaceDefinition.body);
		break;

	case Declaration::LinkageSpecification:
		if (declaration.linkageSpecification.declaration) Emit (*declaration.linkageSpecification.declaration);
		else if (declaration.linkageSpecification.declarations) Emit (*declaration.linkageSpecification.declarations);
		break;

	default:
		assert (Declaration::Unreachable);
	}
}

void Context::Emit (const Declarations& declarations)
{
	for (auto& declaration: declarations) Emit (declaration);
}

void Context::Leave (const Scope& scope)
{
	for (auto entity: scope.variables) if (IsRegister (*entity)) ReleaseRegister (Evaluate (*entity));
}

void Context::Emit (const DeclarationSpecifiers& specifiers)
{
	for (auto& specifier: specifiers) Emit (specifier);
}

void Context::Emit (const DeclarationSpecifier& specifier)
{
	if (IsType (specifier)) Emit (*specifier.type.specifier);
}

void Context::Emit (const TypeSpecifier& specifier)
{
	if (IsClass (specifier) && specifier.class_.members) Emit (*specifier.class_.members);
}

void Context::Emit (const Function& function)
{
	assert (function.body); const auto& body = *function.body;
	Begin (Section::Code, GetName (*function.entity), function); Locate (function.entity->location); DeclareVoid ();
	registers.resize (function.registers); labels.reserve (function.labels);
	const Restore restoreFunction {currentFunction, &function};
	for (auto count = function.labels; count; --count) labels.push_back (CreateLabel ());
	const auto frameSize = Align (function.bytes, function.alignment.value);
	if (!IsMain (function) || frameSize) Comment ("function prologue");
	if (platform.link.size && !IsMain (function)) Push (emitter.linkRegister);
	if (!IsMain (function) || frameSize) Enter (frameSize);
	auto epilogue = CreateLabel (); epilogue.swap (this->epilogue);
	for (auto& parameter: function.parameters) DefaultInitialize (parameter);
	if (IsVoid (*function.type.function.returnType)) Emit (body, {});
	else Emit (body, Reg {GetType (*function.type.function.returnType), RRes});
	Comment ("function epilogue"); epilogue.swap (this->epilogue);
	for (auto& parameter: function.parameters) if (IsRegister (parameter)) ReleaseRegister (Evaluate (parameter));
	if (!IsExiting (body) && !IsReturning (function) || IsNoreturn (function)) return epilogue ();
	if (IsMain (function) && IsExiting (body)) Move (Reg {platform.integer, RRes}, SImm {platform.integer, 0});
	epilogue (); if (!IsMain (function)) if (frameSize) Leave (), Return (); else Pop (emitter.framePointer), Return ();
	else Push (Reg {platform.integer, RRes}), Call (Adr {platform.function, "exit"}, 0);
	labels.clear (); registers.clear ();
}

void Context::Emit (const FunctionBody& body, const Operand& result)
{
	switch (body.model)
	{
	case FunctionBody::Default:
		return;

	case FunctionBody::Regular:
		assert (body.regular.block);
		return Emit (*body.regular.block, result);

	default:
		assert (FunctionBody::Unreachable);
	}
}

void Context::Emit (const InitDeclarator& declarator)
{
	assert (declarator.entity); if (declarator.isDeclaration) return;
	assert (IsVariable (*declarator.entity)); const auto& variable = *declarator.entity->variable;
	if (!HasStaticStorageDuration (variable)) if (!HasInitializer (declarator)) return DefaultInitialize (variable);
		else return Comment (declarator.declarator->location, declarator), Initialize (variable, *declarator.initializer);
	const RestoreState restoreState {*this}; Comment (declarator.declarator->location, declarator);
	Begin (IsConstant (variable) ? Section::Const : Section::Data, GetName (*declarator.entity), variable); Size offset = 0;
	if (HasInitializer (declarator)) Initialize (variable, *declarator.initializer, offset); else ZeroInitialize (variable.type, offset);
	Reserve (emitter.platform.GetSize (variable.type) - offset);
}

void Context::Emit (const Variable& variable)
{
	assert (IsPredefined (*variable.entity)); assert (IsValid (variable.value)); if (!IsUsed (*variable.entity)) return;
	Begin (Section::Const, GetName (*variable.entity), variable); Size offset = 0;
	StringInitialize (variable.type, variable.value, offset);
}

void Context::Advance (Size& offset, const Type& type)
{
	const auto alignedOffset = Align (offset, emitter.platform.GetAlignment (type));
	Reserve (alignedOffset - offset); offset = alignedOffset + emitter.platform.GetSize (type);
}

void Context::DefaultInitialize (const Variable& variable)
{
	if (IsRegister (variable)) AcquireRegister (Evaluate (variable), variable.type);
	Declare (*variable.entity);
}

void Context::DefaultInitialize (const Parameter& parameter)
{
	if (IsRegister (parameter)) AcquireRegister (Evaluate (parameter), parameter.declaration->type);
	if (parameter.declaration->entity) Declare (*parameter.declaration->entity);
	if (IsRegister (parameter)) Move (AccessRegister (Evaluate (parameter)), Designate (EvaluateNonRegister (parameter), parameter.declaration->type));
}

void Context::Initialize (const Variable& variable, const Initializer& initializer)
{
	if (IsRegister (variable)) DefaultInitialize (variable);
	assert (!initializer.expressions.empty ()); Initialize (variable, initializer.expressions.front ());
}

void Context::Initialize (const Variable& variable, const Expression& expression)
{
	if (HasAutomaticStorageDuration (variable) && !IsUsed (*variable.entity)) return EvaluateDiscarded (expression); const auto operand = Evaluate (variable);
	if (IsRegister (variable)) Move (Designate (operand, variable.type), Evaluate (expression, GetRegister (Designate (operand, variable.type))));
	else if (IsCharacterArray (variable.type) && IsStringLiteral (expression)) StringInitialize (operand, variable.type, expression);
	else if (IsClass (variable.type) && IsUnion (*variable.type.class_)) Move (Designate (operand, variable.type.class_->firstDataMember->type), Evaluate (expression));
	else Move (Designate (operand, variable.type), Evaluate (expression));
}

void Context::Initialize (const Variable& variable, const Initializer& initializer, Size& offset)
{
	if (initializer.expressions.empty ()) return ZeroInitialize (variable.type, offset); const auto& expression = initializer.expressions.front ();
	if (IsCharacterArray (variable.type) && IsStringLiteral (expression)) return StringInitialize (variable.type, expression.value, offset);
	if (IsConstant (expression) && !HasSideEffects (expression)) return Advance (offset, expression.type), Define (Evaluate (expression.value, expression.type));
	ZeroInitialize (variable.type, offset); const auto sectionName = GetName (*variable.entity) + '='; Require (sectionName);
	const RestoreState restoreState {*this}; Begin (Section::InitData, sectionName, 0, HasSideEffects (initializer)); Initialize (variable, initializer);
}

void Context::ZeroInitialize (const Type& type, Size& offset)
{
	if (IsReference (type)) Advance (offset, type), Reserve (emitter.platform.GetSize (type));
	else if (IsArray (type)) for (auto size = type.array.bound; size; --size) ZeroInitialize (*type.array.elementType, offset);
	else if (IsClass (type)) for (auto entity: type.class_->scope.variables) if (IsStaticMember (*entity)) continue; else ZeroInitialize (entity->variable->type, offset);
	else Advance (offset, type), Define (Imm {GetType (type), 0});
}

void Context::StringInitialize (const Type& type, const Value& value, Size& offset)
{
	assert (IsCharacterArray (type)); assert (IsReference (value)); const auto& array = *value.reference.array;
	for (auto& value: array.values) Advance (offset, array.elementType), Define (Evaluate (value, array.elementType));
	for (auto size = type.array.bound - array.values.size (); size; --size) ZeroInitialize (array.elementType, offset);
}

void Context::StringInitialize (const Operand& operand, const Type& type, const Expression& expression)
{
	assert (IsCharacterArray (type)); assert (IsReference (expression.value));
	const auto size = emitter.platform.GetSize (*type.array.elementType) * expression.value.reference.array->values.size ();
	Copy (operand, Evaluate (expression.value, expression.type), PtrImm {platform.pointer, size});
	Fill (Add (operand, size), PtrImm {platform.pointer, type.array.bound - expression.value.reference.array->values.size ()}, UImm {GetType (*type.array.elementType), 0});
}

void Context::Emit (const Array& array)
{
	assert (array.stringLiteral); const RestoreState restoreState {*this}; Comment (array.stringLiteral->location, *array.stringLiteral);
	Begin (Section::Const, GetName (array), emitter.platform.GetAlignment (array.elementType), false, true);
	for (auto& value: array.values) Define (Evaluate (value, array.elementType));
}

void Context::Begin (const Section::Type type, const Section::Name& name, const Storage& storage)
{
	auto& section = Begin (type, name, IsData (type) ? storage.alignment.value : 0, storage.required, storage.duplicable || IsInline (storage) || IsInline (*storage.entity->enclosingScope), storage.replaceable);
	if (storage.origin) section.fixed = true, section.origin = storage.origin->value.unsigned_;
	if (storage.group) assert (!storage.group->empty ()), section.group = *storage.group;
	if (storage.alias) assert (!storage.alias->empty ()), Alias (*storage.alias);
}

void Context::Declare (const Entity& entity)
{
	assert (IsLocal (entity));
	DeclareSymbol (epilogue, GetName (entity), IsRegister (entity) ? AccessRegister (Evaluate (entity)) : MakeMemory (platform.pointer, Evaluate (entity)));
	Locate (entity.location); Declare (CPP::GetType (entity));
}

void Context::Declare (const Type& type)
{
	DeclareType (GetName (type));
}

void Context::Assemble (const Declaration& declaration)
{
	assert (IsAsm (declaration)); std::ostringstream assembly; auto previous = &declaration.location;
	assert (declaration.asm_.stringLiteral); assert (!declaration.asm_.stringLiteral->tokens.empty ());
	if (declaration.asm_.entities) for (auto entity: *declaration.asm_.entities) Assemble (*entity, assembly);
	if (assembly.tellp ()) Assembly::WriteLine (assembly, GetLine (declaration.location.position)) << '\n';
	for (auto& token: declaration.asm_.stringLiteral->tokens) if (!token.literal->empty ()) Assemble (token, *previous, assembly), previous = &token.location;
	if (!currentFunction && !declaration.asm_.code) BeginAssembly (); Comment (declaration.location, declaration);
	if (!declaration.asm_.code) Assemble (*declaration.location.source, GetLine (declaration.location.position), assembly.str ());
	else if (currentFunction) AssembleInlineCode (*declaration.location.source, GetLine (declaration.location.position), assembly.str ());
	else AssembleCode (*declaration.location.source, GetLine (declaration.location.position), assembly.str ());
}

void Context::Assemble (const Entity& entity, std::ostream& assembly)
{
	if (IsEnumeration (entity)) return Assemble (*entity.enumeration, assembly); if (IsRegister (entity)) return;
	const auto value = IsVariable (entity) && IsConstant (*entity.variable) && !IsVolatile (entity.variable->type) && IsRegister (entity.variable->type) ? Evaluate (entity.variable->value, entity.variable->type) : Evaluate (entity);
	Assembly::WriteDefinition (WriteUnqualified (assembly, entity));
	if (IsImmediate (value)) (IsSigned (value) ? assembly << value.simm : assembly << value.uimm) << '\n';
	else if (IsAddress (value)) WriteAddress (assembly, nullptr, value.address, value.displacement, 0) << '\n';
	else assert (IsFramePointer (value)), assembly << value.displacement << '\n';
}

void Context::Assemble (const Enumeration& enumeration, std::ostream& assembly)
{
	assert (!IsUnnamed (enumeration));
	for (auto entry: enumeration.scope.symbolTable) Assemble (*entry.second, WriteUnqualified (assembly, *enumeration.entity) << Lexer::DoubleColon);
}

void Context::Assemble (const Lexer::Token& token, const Location& previous, std::ostream& assembly)
{
	assert (IsString (token.symbol)); assert (!token.literal->empty ());
	if (token.location.source != previous.source) Assembly::WriteLine (assembly << ' ', GetLine (token.location.position), *token.location.source) << ' ';
	else if (GetLine (token.location.position) != GetLine (previous.position)) Assembly::WriteLine (assembly << ' ', GetLine (token.location.position)) << ' ';
	for (auto character: *token.literal)
		if (character != '\n' || IsRawString (token.symbol)) Lexer::Write (assembly, character);
		else Assembly::WriteLine (assembly << '\n', GetLine (token.location.position)) << '\n';
}

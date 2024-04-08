// C++ pretty printer
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
#include "cppprinter.hpp"
#include "indenter.hpp"
#include "utilities.hpp"

#include <cassert>
#include <ostream>

using namespace ECS;
using namespace CPP;

using Context = class Printer::Context : Indenter
{
public:
	explicit Context (bool);

	std::ostream& Print (std::ostream&, const Attribute&);
	std::ostream& Print (std::ostream&, const AttributeSpecifier&);
	std::ostream& Print (std::ostream&, const Declaration&);
	std::ostream& Print (std::ostream&, const DeclarationSpecifier&);
	std::ostream& Print (std::ostream&, const Expression&);
	std::ostream& Print (std::ostream&, const Identifier&);
	std::ostream& Print (std::ostream&, const Statement&);
	std::ostream& Print (std::ostream&, const TranslationUnit&);
	std::ostream& Print (std::ostream&, const TypeSpecifier&);

	std::ostream& PrintSpecified (std::ostream&, const InitDeclarator&);

private:
	unsigned single;
	const bool compact;

	std::ostream& Multi (std::ostream&);
	std::ostream& Single (std::ostream&);

	std::ostream& Increase (std::ostream&);
	std::ostream& Decrease (std::ostream&);

	std::ostream& Line (std::ostream&) const;
	std::ostream& Space (std::ostream&) const;
	std::ostream& Indent (std::ostream&) const;
	std::ostream& WhiteSpace (std::ostream&) const;

	std::ostream& Print (std::ostream&, const BaseSpecifier&);
	std::ostream& Print (std::ostream&, const Capture&);
	std::ostream& Print (std::ostream&, const ClassHead&);
	std::ostream& Print (std::ostream&, const Condition&);
	std::ostream& Print (std::ostream&, const Declarations&);
	std::ostream& Print (std::ostream&, const DeclarationSpecifiers&);
	std::ostream& Print (std::ostream&, const Declarator&);
	std::ostream& Print (std::ostream&, const DecltypeSpecifier&);
	std::ostream& Print (std::ostream&, const EnumeratorDefinition&);
	std::ostream& Print (std::ostream&, const EnumHead&);
	std::ostream& Print (std::ostream&, const ExceptionDeclaration&);
	std::ostream& Print (std::ostream&, const ExceptionHandler&);
	std::ostream& Print (std::ostream&, const ExceptionHandlers&);
	std::ostream& Print (std::ostream&, const FunctionBody&);
	std::ostream& Print (std::ostream&, const FunctionPrototype&);
	std::ostream& Print (std::ostream&, const InitDeclarator&);
	std::ostream& Print (std::ostream&, const Initializer&);
	std::ostream& Print (std::ostream&, const LambdaDeclarator&);
	std::ostream& Print (std::ostream&, const MemberDeclarator&);
	std::ostream& Print (std::ostream&, const MemberInitializer&);
	std::ostream& Print (std::ostream&, const NestedNameSpecifier&);
	std::ostream& Print (std::ostream&, const NoexceptSpecifier&);
	std::ostream& Print (std::ostream&, const ParameterDeclaration&);
	std::ostream& Print (std::ostream&, const ParameterDeclarations&);
	std::ostream& Print (std::ostream&, const StatementBlock&);
	std::ostream& Print (std::ostream&, const Statements&);
	std::ostream& Print (std::ostream&, const Substatement&);
	std::ostream& Print (std::ostream&, const TemplateArgument&);
	std::ostream& Print (std::ostream&, const TemplateParameter&);
	std::ostream& Print (std::ostream&, const TypeIdentifier&);
	std::ostream& Print (std::ostream&, const TypeSpecifiers&);
	std::ostream& Print (std::ostream&, const UsingDeclarator&);

	std::ostream& PrintIf (std::ostream&, const Statement&);
	std::ostream& PrintIndented (std::ostream&, const Declarations&);

	template <typename Structure> std::ostream& Print (std::ostream&, const List<Structure>&);
	template <typename Structure> std::ostream& Print (std::ostream&, const Packed<Structure>&);
	template <typename Structure> std::ostream& Print (std::ostream&, const Sequence<Structure>&);
};

void Printer::Print (const TranslationUnit& translationUnit, std::ostream& stream) const
{
	Context {false}.Print (stream, translationUnit);
}

Context::Context (const bool c) :
	single {c}, compact {c}
{
}

std::ostream& Context::Print (std::ostream& stream, const TranslationUnit& translationUnit)
{
	return Print (stream, translationUnit.declarations);
}

std::ostream& Context::Single (std::ostream& stream)
{
	return ++single, stream;
}

std::ostream& Context::Multi (std::ostream& stream)
{
	return --single, stream;
}

std::ostream& Context::Increase (std::ostream& stream)
{
	return single ? stream : Indenter::Increase (stream);
}

std::ostream& Context::Decrease (std::ostream& stream)
{
	return single ? stream : Indenter::Decrease (stream);
}

std::ostream& Context::Line (std::ostream& stream) const
{
	return single ? stream : stream << '\n';
}

std::ostream& Context::Space (std::ostream& stream) const
{
	return single ? stream << ' ' : stream << '\n';
}

std::ostream& Context::Indent (std::ostream& stream) const
{
	return single ? stream : Indenter::Indent (stream);
}

std::ostream& Context::WhiteSpace (std::ostream& stream) const
{
	return single ? stream << ' ' : Indenter::Indent (stream);
}

template <typename Structure>
std::ostream& Context::Print (std::ostream& stream, const List<Structure>& list)
{
	for (auto& structure: list) Print (IsFirst (structure, list) ? stream : stream << Lexer::Comma << ' ', structure); return stream;
}

template <typename Structure>
std::ostream& Context::Print (std::ostream& stream, const Packed<Structure>& structure)
{
	Print (stream, static_cast<const Structure&> (structure)); if (structure.isPacked) stream << Lexer::Ellipsis; return stream;
}

template <typename Structure>
std::ostream& Context::Print (std::ostream& stream, const Sequence<Structure>& sequence)
{
	for (auto& structure: sequence) Print (IsFirst (structure, sequence) ? stream : stream << ' ', structure); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Capture& capture)
{
	if (capture.byReference) stream << Lexer::Ampersand;
	if (capture.identifier) Print (stream, *capture.identifier); else stream << Lexer::This;
	if (capture.initializer) Print (stream << ' ', *capture.initializer);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const EnumHead& head)
{
	stream << head.key;
	if (head.attributes) Print (stream << ' ', *head.attributes);
	if (head.identifier) Print (stream << ' ', *head.identifier);
	if (head.base) Print (stream << ' ' << Lexer::Colon << ' ', *head.base);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Attribute& attribute)
{
	if (attribute.namespace_) Print (stream, *attribute.namespace_) << Lexer::DoubleColon;
	assert (attribute.name); Print (stream, *attribute.name); if (compact) return stream;

	switch (attribute.model)
	{
	case Attribute::Unspecified:
		if (!attribute.unspecified.tokens) return stream; stream << ' ' << Lexer::LeftParen;
		for (auto& token: *attribute.unspecified.tokens) Lexer::Write (IsFirst (token, *attribute.unspecified.tokens) ? stream : stream << ' ', token);
		return stream << Lexer::RightParen;

	case Attribute::CarriesDependency:
	case Attribute::Fallthrough:
	case Attribute::Likely:
	case Attribute::MaybeUnused:
	case Attribute::Noreturn:
	case Attribute::NoUniqueAddress:
	case Attribute::Unlikely:
	case Attribute::Code:
	case Attribute::Duplicable:
	case Attribute::Register:
	case Attribute::Replaceable:
	case Attribute::Required:
		return stream;

	case Attribute::Deprecated:
	case Attribute::Nodiscard:
	case Attribute::Alias:
	case Attribute::Group:
		if (attribute.deprecated.stringLiteral) stream << ' ' << Lexer::LeftParen << *attribute.deprecated.stringLiteral << Lexer::RightParen;
		return stream;

	case Attribute::Origin:
		return Print (stream << ' ' << Lexer::LeftParen, *attribute.origin.expression) << Lexer::RightParen;

	default:
		assert (Attribute::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const ClassHead& head)
{
	stream << head.key;
	if (head.attributes) Print (stream << ' ', *head.attributes);
	if (head.identifier) Print (stream << ' ', *head.identifier);
	if (head.isFinal) stream << " final";
	if (head.baseSpecifiers) Print (stream << ' ' << Lexer::Colon << ' ', *head.baseSpecifiers);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Condition& condition)
{
	return condition.declaration ? Print (stream, *condition.declaration) : Print (stream, *condition.expression);
}

std::ostream& Context::Print (std::ostream& stream, const Statement& statement)
{
	if (IsLabeled (statement)) Decrease (stream);
	if (!IsDeclaration (statement)) Indent (stream);
	if (statement.attributes && !IsIf (statement)) Print (stream, *statement.attributes) << ' ';

	switch (statement.model)
	{
	case Statement::Do:
		if (!compact) Indent (Print (Space (stream << Lexer::Do), *statement.do_.statement));
		return Line (Print (stream << Lexer::While << ' ' << Lexer::LeftParen, *statement.do_.condition) << Lexer::RightParen << Lexer::Semicolon);

	case Statement::If:
		return PrintIf (stream, statement);

	case Statement::For:
		Multi (Print (Single (stream << Lexer::For << ' ' << Lexer::LeftParen), *statement.for_.initStatement));
		if (statement.for_.condition) Print (stream << ' ', *statement.for_.condition); stream << Lexer::Semicolon;
		if (statement.for_.expression) Print (stream << ' ', *statement.for_.expression);
		return Print (Space (stream << Lexer::RightParen), *statement.for_.statement);

	case Statement::Try:
		return Print (Print (Indent (Line (stream << Lexer::Try)), *statement.try_.block), *statement.try_.handlers);

	case Statement::Case:
		return Line (Increase (Print (stream << Lexer::Case << ' ', *statement.case_.label) << Lexer::Colon));

	case Statement::Goto:
		return Line (Print (stream << Lexer::Goto << ' ', *statement.goto_.identifier) << Lexer::Semicolon);

	case Statement::Null:
		return Line (stream << Lexer::Semicolon);

	case Statement::Break:
		return Line (stream << Lexer::Break << Lexer::Semicolon);

	case Statement::Label:
		return Line (Increase (Print (stream, *statement.label.identifier) << Lexer::Colon));

	case Statement::While:
		return Print (Space (Print (stream << Lexer::While << ' ' << Lexer::LeftParen, statement.while_.condition) << Lexer::RightParen), *statement.while_.statement);

	case Statement::Return:
		stream << Lexer::Return;
		if (statement.return_.expression) Print (stream << ' ', *statement.return_.expression);
		return Line (stream << Lexer::Semicolon);

	case Statement::Switch:
		return Print (Space (Print (stream << Lexer::Switch << ' ' << Lexer::LeftParen, statement.switch_.condition) << Lexer::RightParen), *statement.switch_.statement);

	case Statement::Default:
		return Line (Increase (stream << Lexer::Default << Lexer::Colon));

	case Statement::Compound:
		return Print (stream, *statement.compound.block);

	case Statement::Continue:
		return Line (stream << Lexer::Continue << Lexer::Semicolon);

	case Statement::CoReturn:
		stream << Lexer::CoReturn;
		if (statement.coReturn.expression) Print (stream << ' ', *statement.coReturn.expression);
		return Line (stream << Lexer::Semicolon);

	case Statement::Expression:
		return Line (Print (stream, *statement.expression) << Lexer::Semicolon);

	case Statement::Declaration:
		return Print (stream, *statement.declaration);

	default:
		assert (Statement::Unreachable);
	}
}

std::ostream& Context::PrintIf (std::ostream& stream, const Statement& statement)
{
	assert (IsIf (statement)); if (statement.attributes) Print (stream, *statement.attributes) << ' ';
	stream << Lexer::If; if (statement.if_.isConstexpr) stream << ' ' << Lexer::Constexpr;
	Space (Print (stream << ' ' << Lexer::LeftParen, statement.if_.condition) << Lexer::RightParen);
	Print (stream, *statement.if_.statement); if (compact || !statement.if_.elseStatement) return stream; WhiteSpace (stream) << Lexer::Else;
	if (statement.if_.elseStatement->statements.size () == 1 && IsIf (statement.if_.elseStatement->statements.front ())) return PrintIf (stream << ' ', statement.if_.elseStatement->statements.front ());
	return Print (Space (stream), *statement.if_.elseStatement);
}

std::ostream& Context::Print (std::ostream& stream, const Declarator& declarator)
{
	switch (declarator.model)
	{
	case Declarator::Name:
		if (declarator.name.isPacked) stream << Lexer::Ellipsis;
		if (declarator.name.identifier) Print (stream, *declarator.name.identifier);
		if (declarator.name.attributes) Print (stream << ' ', *declarator.name.attributes);
		return stream;

	case Declarator::Array:
		if (declarator.array.declarator) Print (stream, *declarator.array.declarator);
		stream << Lexer::LeftBracket;
		if (declarator.array.expression) Print (stream, *declarator.array.expression);
		stream << Lexer::RightBracket;
		if (declarator.array.attributes) Print (stream << ' ', *declarator.array.attributes);
		return stream;

	case Declarator::Pointer:
		stream << Lexer::Asterisk;
		if (declarator.pointer.attributes) Print (stream << ' ', *declarator.pointer.attributes);
		if (declarator.pointer.qualifiers) stream << ' ' << *declarator.pointer.qualifiers;
		if (declarator.pointer.declarator) Print (declarator.pointer.attributes || declarator.pointer.qualifiers ? stream << ' ' : stream, *declarator.pointer.declarator);
		return stream;

	case Declarator::Function:
		if (declarator.function.declarator) Print (stream, *declarator.function.declarator) << ' ';
		return Print (stream, *declarator.function.prototype);

	case Declarator::Reference:
		stream << (declarator.reference.isRValue ? Lexer::DoubleAmpersand : Lexer::Ampersand);
		if (declarator.reference.attributes) Print (stream << ' ', *declarator.reference.attributes);
		if (declarator.reference.declarator) Print (declarator.reference.attributes ? stream << ' ' : stream, *declarator.reference.declarator);
		return stream;

	case Declarator::MemberPointer:
		Print (stream, *declarator.memberPointer.specifier) << Lexer::Asterisk;
		if (declarator.memberPointer.attributes) Print (stream << ' ', *declarator.memberPointer.attributes);
		if (declarator.memberPointer.qualifiers) stream << ' ' << *declarator.memberPointer.qualifiers << ' ';
		if (declarator.memberPointer.declarator) Print (declarator.memberPointer.attributes || declarator.memberPointer.qualifiers ? stream << ' ' : stream, *declarator.memberPointer.declarator);
		return stream;

	case Declarator::Parenthesized:
		return Print (stream << Lexer::LeftParen, *declarator.parenthesized.declarator) << Lexer::RightParen;

	default:
		assert (Declarator::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Expression& expression)
{
	switch (expression.model)
	{
	case Expression::New:
		if (expression.new_.qualified) stream << Lexer::DoubleColon; stream << Lexer::New << ' ';
		if (expression.new_.placement) Print (stream << Lexer::LeftParen, *expression.new_.placement) << Lexer::RightParen << ' ';
		if (expression.new_.parenthesized) Print (stream << Lexer::LeftParen, *expression.new_.typeIdentifier) << Lexer::RightParen; else Print (stream, *expression.new_.typeIdentifier);
		if (expression.new_.initializer) Print (stream << ' ', *expression.new_.initializer);
		return stream;

	case Expression::Cast:
		return Print (Print (stream << Lexer::LeftParen, *expression.cast.typeIdentifier) << Lexer::RightParen << ' ', *expression.cast.expression);

	case Expression::This:
		return stream << Lexer::This;

	case Expression::Comma:
		return Print (Print (stream, *expression.comma.left) << Lexer::Comma << ' ', *expression.comma.right);

	case Expression::Throw:
		stream << Lexer::Throw;
		if (expression.throw_.expression) Print (stream << ' ', *expression.throw_.expression);
		return stream;

	case Expression::Unary:
		stream << expression.unary.operator_;
		if (IsAlternative (expression.unary.operator_.symbol) || BeginsWithPlus (expression) && BeginsWithPlus (*expression.unary.operand) || BeginsWithMinus (expression) && BeginsWithMinus (*expression.unary.operand)) stream << ' ';
		return Print (stream, *expression.unary.operand);

	case Expression::Braced:
		stream << Lexer::LeftBrace;
		if (expression.braced.expressions) Print (stream, *expression.braced.expressions);
		return stream << Lexer::RightBrace;

	case Expression::Binary:
		return Print (Print (stream, *expression.binary.left) << ' ' << expression.binary.operator_ << ' ', *expression.binary.right);

	case Expression::Delete:
		if (expression.delete_.qualified) stream << Lexer::DoubleColon;
		stream << Lexer::Delete;
		if (expression.delete_.bracketed) stream << ' ' << Lexer::LeftBracket << Lexer::RightBracket;
		return Print (stream << ' ', *expression.delete_.expression);

	case Expression::Lambda:
		stream << Lexer::LeftBracket;
		if (expression.lambda.default_) stream << *expression.lambda.default_;
		if (expression.lambda.default_ && expression.lambda.captures) stream << Lexer::Comma << ' ';
		if (expression.lambda.captures) Print (stream, *expression.lambda.captures);
		stream << Lexer::RightBracket;
		if (expression.lambda.declarator) Print (stream << ' ', *expression.lambda.declarator);
		return compact ? stream : Multi (Print (Single (stream << ' '), *expression.lambda.block));

	case Expression::Prefix:
		return Print (stream << expression.prefix.operator_, *expression.prefix.expression);

	case Expression::Alignof:
		return Print (stream << Lexer::Alignof << ' ' << Lexer::LeftParen, *expression.alignof_.typeIdentifier) << Lexer::RightParen;

	case Expression::Literal:
		return Lexer::Write (stream, expression.literal.token);

	case Expression::Postfix:
		return Print (stream, *expression.postfix.expression) << expression.postfix.operator_;

	case Expression::Noexcept:
		return Print (stream << Lexer::Noexcept << ' ' << Lexer::LeftParen, *expression.noexcept_.expression) << Lexer::RightParen;

	case Expression::Addressof:
		return Print (stream << Lexer::Ampersand, *expression.addressof.expression);

	case Expression::ConstCast:
	case Expression::StaticCast:
	case Expression::DynamicCast:
	case Expression::ReinterpretCast:
		return Print (Print (stream << expression.cast.symbol << Lexer::Less, *expression.cast.typeIdentifier) <<
			Lexer::Greater << ' ' << Lexer::LeftParen, *expression.cast.expression) << Lexer::RightParen;

	case Expression::Subscript:
		return Print (Print (stream, *expression.subscript.left) << Lexer::LeftBracket, *expression.subscript.right) << Lexer::RightBracket;

	case Expression::Typetrait:
		return Print (stream << Lexer::Typetrait << ' ' << *expression.typetrait.stringLiteral << ' ' << Lexer::LeftParen, *expression.typetrait.typeIdentifier) << Lexer::RightParen;

	case Expression::Assignment:
		return Print (Print (stream, *expression.assignment.left) << ' ' << expression.assignment.operator_ << ' ', *expression.assignment.right);

	case Expression::Conversion:
		return Print (stream, *expression.conversion.expression);

	case Expression::Identifier:
		return Print (stream, *expression.identifier.identifier);

	case Expression::SizeofPack:
		return Print (stream << Lexer::Sizeof << Lexer::Ellipsis << ' ' << Lexer::LeftParen, *expression.sizeofPack.identifier) << Lexer::RightParen;

	case Expression::SizeofType:
		return Print (stream << Lexer::Sizeof << ' ' << Lexer::LeftParen, *expression.sizeofType.typeIdentifier) << Lexer::RightParen;

	case Expression::TypeidType:
		return Print (stream << Lexer::Typeid << ' ' << Lexer::LeftParen, *expression.typeidType.typeIdentifier) << Lexer::RightParen;

	case Expression::Conditional:
		return Print (Print (Print (stream, *expression.conditional.condition) << ' ' << Lexer::QuestionMark << ' ',
			*expression.conditional.left) << ' ' << Lexer::Colon << ' ', *expression.conditional.right);

	case Expression::Indirection:
		return Print (stream << Lexer::Asterisk, *expression.indirection.expression);

	case Expression::FunctionCall:
		Print (stream, *expression.functionCall.expression) << ' ' << Lexer::LeftParen;
		if (expression.functionCall.arguments) Print (stream, *expression.functionCall.arguments);
		return stream << Lexer::RightParen;

	case Expression::MemberAccess:
		Print (stream, *expression.memberAccess.expression) << expression.memberAccess.symbol;
		if (expression.memberAccess.isTemplate) stream << Lexer::Template << ' ';
		return Print (stream, *expression.memberAccess.identifier);

	case Expression::Parenthesized:
		return Print (stream << Lexer::LeftParen, *expression.parenthesized.expression) << Lexer::RightParen;

	case Expression::StringLiteral:
		return stream << *expression.stringLiteral;

	case Expression::ConstructorCall:
		Print (stream, *expression.constructorCall.specifier) << ' ' << Lexer::LeftParen;
		if (expression.constructorCall.expressions) Print (stream, *expression.constructorCall.expressions);
		return stream << Lexer::RightParen;

	case Expression::SizeofExpression:
		return Print (stream << Lexer::Sizeof << ' ', *expression.sizeofExpression.expression);

	case Expression::TypeidExpression:
		return Print (stream << Lexer::Typeid << ' ' << Lexer::LeftParen, *expression.typeidExpression.expression) << Lexer::RightParen;

	case Expression::MemberIndirection:
		return Print (Print (stream, *expression.memberIndirection.expression) << expression.memberIndirection.symbol, *expression.memberIndirection.member);

	case Expression::InlinedFunctionCall:
		return Print (stream, *expression.inlinedFunctionCall.expression);

	case Expression::BracedConstructorCall:
		return Print (Print (stream, *expression.bracedConstructorCall.specifier) << ' ', *expression.bracedConstructorCall.expression);

	default:
		assert (Expression::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Identifier& identifier)
{
	if (identifier.nestedNameSpecifier) Print (stream, *identifier.nestedNameSpecifier);

	switch (identifier.model)
	{
	case Identifier::Name:
		return stream << *identifier.name.identifier;

	case Identifier::Template:
		Print (stream, *identifier.template_.identifier) << Lexer::Less;
		if (identifier.template_.arguments) Print (stream, *identifier.template_.arguments);
		return stream << Lexer::Greater;

	case Identifier::Destructor:
		return Print (stream << Lexer::Tilde, *identifier.destructor.specifier);

	case Identifier::LiteralOperator:
		return stream << Lexer::Operator << " \"\" " << *identifier.literalOperator.suffixIdentifier;

	case Identifier::OperatorFunction:
		return stream << Lexer::Operator << ' ' << identifier.operatorFunction.operator_;

	case Identifier::ConversionFunction:
		return Print (stream << Lexer::Operator << ' ', *identifier.conversionFunction.typeIdentifier);

	default:
		assert (Identifier::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const NestedNameSpecifier& specifier)
{
	switch (specifier.model)
	{
	case NestedNameSpecifier::Name:
		Print (stream, *specifier.name.identifier) << Lexer::DoubleColon;
		if (specifier.name.isTemplate) stream << Lexer::Template << ' ';
		return stream;

	case NestedNameSpecifier::Global:
		return stream << Lexer::DoubleColon;

	case NestedNameSpecifier::Decltype:
		return Print (stream, specifier.decltype_.specifier) << Lexer::DoubleColon;

	default:
		assert (NestedNameSpecifier::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Statements& statements)
{
	for (auto& statement: statements) Print (IsFirst (statement, statements) ? stream : Space (stream), statement); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Declaration& declaration)
{
	if (!IsCondition (declaration) && !IsAccess (declaration)) Indent (stream);

	switch (declaration.model)
	{
	case Declaration::Asm:
		if (declaration.asm_.attributes) Print (stream, *declaration.asm_.attributes) << ' ';
		stream << Lexer::Asm << ' ' << Lexer::LeftParen;
		if (compact) stream << Lexer::Ellipsis; else stream << *declaration.asm_.stringLiteral;
		return Line (stream << Lexer::RightParen << Lexer::Semicolon);

	case Declaration::Alias:
		Print (stream << Lexer::Using << ' ', *declaration.alias.identifier) << ' ';
		if (declaration.alias.attributes) Print (stream, *declaration.alias.attributes) << ' ';
		return Line (Print (stream << Lexer::Equal << ' ', *declaration.alias.typeIdentifier) << Lexer::Semicolon);

	case Declaration::Empty:
		return Line (stream << Lexer::Semicolon);

	case Declaration::Using:
		return Line (Print (stream << Lexer::Using << ' ', *declaration.using_.declarators) << Lexer::Semicolon);

	case Declaration::Access:
		return Increase (Indent (Decrease (stream)) << declaration.access.specifier << Lexer::Colon);

	case Declaration::Member:
		if (declaration.member.attributes) Print (stream, *declaration.member.attributes) << ' '; Print (stream, *declaration.member.specifiers);
		if (declaration.member.declarators) Print (declaration.simple.specifiers->empty () ? stream : stream << ' ', *declaration.member.declarators);
		return Line (stream << Lexer::Semicolon);

	case Declaration::Simple:
		if (declaration.simple.attributes) Print (stream, *declaration.simple.attributes) << ' '; Print (stream, *declaration.simple.specifiers);
		if (declaration.simple.declarators) Print (declaration.simple.specifiers->empty () ? stream : stream << ' ', *declaration.simple.declarators);
		return Line (stream << Lexer::Semicolon);

	case Declaration::Template:
		Print (stream << Lexer::Template << ' ' << Lexer::Less, *declaration.template_.parameters) << Lexer::Greater;
		return compact ? stream : Print (Line (stream), *declaration.template_.declaration);

	case Declaration::Attribute:
		return Line (Print (stream, *declaration.attribute.specifiers) << Lexer::Semicolon);

	case Declaration::Condition:
		if (declaration.condition.attributes) Print (stream, *declaration.condition.attributes) << ' ';
		return Print (Print (Print (stream, *declaration.condition.specifiers) << ' ', *declaration.condition.declarator) << ' ', *declaration.condition.initializer);

	case Declaration::OpaqueEnum:
		return Line (Print (stream, declaration.opaqueEnum.head) << Lexer::Semicolon);

	case Declaration::UsingDirective:
		if (declaration.usingDirective.attributes) Print (stream, *declaration.usingDirective.attributes) << ' ';
		return Line (Print (stream << Lexer::Using << ' ' << Lexer::Namespace << ' ', *declaration.usingDirective.identifier) << Lexer::Semicolon);

	case Declaration::StaticAssertion:
		Print (stream << Lexer::StaticAssert << ' ' << Lexer::LeftParen, *declaration.staticAssertion.expression);
		if (declaration.staticAssertion.stringLiteral) stream << Lexer::Comma << ' ' << *declaration.staticAssertion.stringLiteral;
		return Line (stream << Lexer::RightParen << Lexer::Semicolon);

	case Declaration::FunctionDefinition:
		if (declaration.functionDefinition.attributes) Print (stream, *declaration.functionDefinition.attributes) << ' ';
		if (!declaration.functionDefinition.specifiers->empty ()) Print (stream, *declaration.functionDefinition.specifiers) << ' ';
		Print (stream, *declaration.functionDefinition.declarator);
		if (declaration.functionDefinition.virtualSpecifiers) stream << ' ' << *declaration.functionDefinition.virtualSpecifiers;
		return compact ? stream : Print (stream, *declaration.functionDefinition.body);

	case Declaration::NamespaceDefinition:
		if (declaration.namespaceDefinition.isInline) stream << Lexer::Inline << ' '; stream << Lexer::Namespace;
		if (declaration.namespaceDefinition.attributes) Print (stream << ' ', *declaration.namespaceDefinition.attributes);
		if (declaration.namespaceDefinition.identifier) Print (stream << ' ', *declaration.namespaceDefinition.identifier);
		return compact ? stream : Line (declaration.namespaceDefinition.body ? PrintIndented (Space (stream), *declaration.namespaceDefinition.body) : stream << ' ' << Lexer::LeftBrace << Lexer::RightBrace);

	case Declaration::LinkageSpecification:
		stream << Lexer::Extern << ' ' << *declaration.linkageSpecification.stringLiteral; if (compact) return stream;
		if (declaration.linkageSpecification.declaration) return Decrease (Print (Increase (Space (stream)), *declaration.linkageSpecification.declaration));
		return Line (declaration.linkageSpecification.declarations ? PrintIndented (Space (stream), *declaration.linkageSpecification.declarations) : stream << ' ' << Lexer::LeftBrace << Lexer::RightBrace);

	case Declaration::ExplicitInstantiation:
		if (declaration.explicitInstantiation.isExtern) stream << Lexer::Extern << ' ';
		return Line (Multi (Print (Single (stream << Lexer::Template << ' '), *declaration.explicitInstantiation.declaration)));

	case Declaration::ExplicitSpecialization:
		return Print (Space (stream << Lexer::Template << ' ' << Lexer::Less << Lexer::Greater), *declaration.explicitSpecialization.declaration);

	case Declaration::NamespaceAliasDefinition:
		return Line (Print (Print (stream << Lexer::Namespace << ' ', *declaration.namespaceAliasDefinition.identifier) << ' ' << Lexer::Equal << ' ', *declaration.namespaceAliasDefinition.name) << Lexer::Semicolon);

	default:
		assert (Declaration::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const UsingDeclarator& declarator)
{
	if (declarator.isTypename) stream << Lexer::Typename << ' ';
	return Print (stream, declarator.identifier);
}

std::ostream& Context::Print (std::ostream& stream, const Initializer& initializer)
{
	if (initializer.assignment) stream << Lexer::Equal << ' ';
	if (initializer.braced) return Print (stream << Lexer::LeftBrace, initializer.expressions) << Lexer::RightBrace;
	if (!initializer.assignment) return Print (stream << Lexer::LeftParen, initializer.expressions) << Lexer::RightParen;
	return Print (stream, initializer.expressions);
}

std::ostream& Context::Print (std::ostream& stream, const Declarations& declarations)
{
	for (auto& declaration: declarations) Print (IsFirst (declaration, declarations) ? stream : Space (stream), declaration); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const FunctionBody& body)
{
	switch (body.model)
	{
	case FunctionBody::Try:
		Indent (Line (stream)) << Lexer::Try;
		if (body.try_.initializers) Print (stream << ' ' << Lexer::Colon << ' ', *body.try_.initializers);
		return Print (Print (Indent (Line (stream)), *body.try_.block), *body.try_.handlers);

	case FunctionBody::Delete:
		return Line (stream << ' ' << Lexer::Equal << ' ' << Lexer::Delete << Lexer::Semicolon);

	case FunctionBody::Default:
		return Line (stream << ' ' << Lexer::Equal << ' ' << Lexer::Default << Lexer::Semicolon);

	case FunctionBody::Regular:
		if (body.regular.initializers) Decrease (Print (Indent (Increase (Line (stream << ' ' << Lexer::Colon))), *body.regular.initializers));
		return Print (Indent (Line (stream)), *body.regular.block);

	default:
		assert (FunctionBody::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const BaseSpecifier& specifier)
{
	if (specifier.attributes) Print (stream, *specifier.attributes) << ' ';
	if (specifier.isVirtual) stream << Lexer::Virtual << ' ';
	if (specifier.accessSpecifier) stream << *specifier.accessSpecifier << ' ';
	return Print (stream, specifier.typeSpecifier);
}

std::ostream& Context::Print (std::ostream& stream, const TypeSpecifier& specifier)
{
	switch (specifier.model)
	{
	case TypeSpecifier::Enum:
		Print (stream, specifier.enum_.head);
		if (compact || !specifier.enum_.isDefinition) return stream;
		stream << ' ' << Lexer::LeftBrace;
		if (specifier.enum_.enumerators) Print (stream, *specifier.enum_.enumerators);
		return stream << Lexer::RightBrace;

	case TypeSpecifier::Class:
		Print (stream, specifier.class_.head);
		if (compact || !specifier.class_.isDefinition) return stream;
		return specifier.class_.members ? PrintIndented (Space (stream), *specifier.class_.members) : stream << ' ' << Lexer::LeftBrace << Lexer::RightBrace;

	case TypeSpecifier::Simple:
		return stream << specifier.simple.type;

	case TypeSpecifier::Decltype:
		return Print (stream, specifier.decltype_.specifier);

	case TypeSpecifier::Typename:
		return Print (stream << Lexer::Typename << ' ', *specifier.typename_.identifier);

	case TypeSpecifier::TypeName:
		return Print (stream, *specifier.typeName.identifier);

	case TypeSpecifier::ConstVolatileQualifier:
		return stream << specifier.constVolatile.qualifier;

	default:
		assert (TypeSpecifier::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const InitDeclarator& declarator)
{
	Print (stream, *declarator.declarator);
	if (declarator.initializer) Print (stream << ' ', *declarator.initializer);
	return stream;
}

std::ostream& Context::PrintSpecified (std::ostream& stream, const InitDeclarator& declarator)
{
	if (!declarator.specifiers->empty ()) Print (stream, *declarator.specifiers) << ' ';
	return Print (stream, declarator);
}

std::ostream& Context::Print (std::ostream& stream, const StatementBlock& block)
{
	return Line (Indent (Decrease (Print (Increase (Line (stream << Lexer::LeftBrace)), block.statements))) << Lexer::RightBrace);
}

std::ostream& Context::PrintIndented (std::ostream& stream, const Declarations& declarations)
{
	return Indent (Decrease (Print (Increase (Line (Indent (stream) << Lexer::LeftBrace)), declarations))) << Lexer::RightBrace;
}

std::ostream& Context::Print (std::ostream& stream, const Substatement& statement)
{
	return compact ? stream : statement.isCompound ? Print (statement.attributes ? Print (Indent (stream), *statement.attributes) << ' ' : Indent (stream), static_cast<const StatementBlock&> (statement)) : Decrease (Print (Increase (stream), statement.statements));
}

std::ostream& Context::Print (std::ostream& stream, const TypeIdentifier& identifier)
{
	Print (stream, identifier.specifiers);
	if (identifier.declarator) Print (stream << ' ', *identifier.declarator);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const TypeSpecifiers& specifiers)
{
	Print<TypeSpecifier> (stream, specifiers);
	if (specifiers.attributes) Print (stream << ' ', *specifiers.attributes);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const ExceptionHandler& handler)
{
	return Print (Indent (Line (Print (Indent (stream) << Lexer::Catch << ' ' << Lexer::LeftParen, handler.declaration) << Lexer::RightParen)), handler.block);
}

std::ostream& Context::Print (std::ostream& stream, const LambdaDeclarator& declarator)
{
	Print (stream << Lexer::LeftParen, declarator.parameterDeclarations) << Lexer::RightParen;
	if (declarator.specifiers) Print (stream << ' ', *declarator.specifiers);
	if (declarator.noexceptSpecifier) Print (stream << ' ', *declarator.noexceptSpecifier);
	if (declarator.attributes) Print (stream << ' ', *declarator.attributes);
	if (declarator.trailingReturnType) Print (stream << ' ' << Lexer::Arrow << ' ', *declarator.trailingReturnType);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const MemberDeclarator& declarator)
{
	if (declarator.declarator) Print (stream, *declarator.declarator);
	if (declarator.virtualSpecifiers) stream << ' ' << *declarator.virtualSpecifiers;
	if (declarator.initializer) Print (stream << ' ', *declarator.initializer);
	if (declarator.expression) Print ((declarator.declarator ? stream << ' ' : stream) << Lexer::Colon << ' ', *declarator.expression);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const TemplateArgument& argument)
{
	switch (argument.model)
	{
	case TemplateArgument::Expression:
		return Print (stream, *argument.expression);

	case TemplateArgument::TypeIdentifier:
		return Print (stream, *argument.typeIdentifier);

	default:
		assert (TemplateArgument::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const DecltypeSpecifier& specifier)
{
	stream << Lexer::Decltype << ' ' << Lexer::LeftParen;
	if (specifier.expression) Print (stream, *specifier.expression); else stream << Lexer::Auto;
	return stream << Lexer::RightParen;
}

std::ostream& Context::Print (std::ostream& stream, const ExceptionHandlers& handlers)
{
	if (!compact) for (auto& handler: handlers) Print (IsFirst (handler, handlers) ? stream : Space (stream), handler); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const FunctionPrototype& prototype)
{
	Print (stream << Lexer::LeftParen, prototype.parameterDeclarations) << Lexer::RightParen;
	if (prototype.constVolatileQualifiers) stream << ' ' << *prototype.constVolatileQualifiers;
	if (prototype.referenceQualifier) stream << ' ' << *prototype.referenceQualifier;
	if (prototype.noexceptSpecifier) Print (stream << ' ', *prototype.noexceptSpecifier);
	if (prototype.attributes) Print (stream << ' ', *prototype.attributes);
	if (prototype.trailingReturnType) Print (stream << ' ' << Lexer::Arrow << ' ', *prototype.trailingReturnType);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const MemberInitializer& initializer)
{
	return Print (Print (stream, initializer.specifier) << ' ', initializer.initializer);
}

std::ostream& Context::Print (std::ostream& stream, const NoexceptSpecifier& specifier)
{
	if (specifier.throw_) return stream << Lexer::Throw << ' ' << Lexer::LeftParen << Lexer::RightParen;
	stream << Lexer::Noexcept; if (specifier.expression) Print (stream << ' ' << Lexer::LeftParen, *specifier.expression) << Lexer::RightParen;
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const TemplateParameter& parameter)
{
	switch (parameter.model)
	{
	case TemplateParameter::Type:
		stream << parameter.type.key;
		if (parameter.type.isPacked) stream << Lexer::Ellipsis;
		if (parameter.type.identifier) Print (stream << ' ', *parameter.type.identifier);
		if (parameter.type.default_) Print (stream << ' ' << Lexer::Equal << ' ', *parameter.type.default_);
		return stream;

	case TemplateParameter::Template:
		Print (stream << Lexer::Template << ' ' << Lexer::Less, *parameter.template_.parameters) << Lexer::Greater << ' ' << parameter.template_.key;
		if (parameter.template_.identifier) Print (stream << ' ', *parameter.template_.identifier);
		if (parameter.template_.default_) Print (stream << ' ' << Lexer::Equal << ' ', *parameter.template_.default_);
		return stream;

	case TemplateParameter::Declaration:
		return Print (stream, *parameter.declaration);

	default:
		assert (TemplateParameter::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const AttributeSpecifier& specifier)
{
	switch (specifier.model)
	{
	case AttributeSpecifier::Attributes:
		stream << Lexer::LeftBracket << Lexer::LeftBracket;
		if (specifier.attributes.usingPrefix) Print (stream << Lexer::Using << ' ', *specifier.attributes.usingPrefix) << Lexer::Colon << ' ';
		if (specifier.attributes.list) Print (stream, *specifier.attributes.list);
		return stream << Lexer::RightBracket << Lexer::RightBracket;

	case AttributeSpecifier::AlignasType:
		return Print (stream << Lexer::Alignas << ' ' << Lexer::LeftParen, *specifier.alignasType.typeIdentifier) << Lexer::RightParen;

	case AttributeSpecifier::AlignasExpression:
		return Print (stream << Lexer::Alignas << ' ' << Lexer::LeftParen, *specifier.alignasExpression.expression) << Lexer::RightParen;

	default:
		assert (AttributeSpecifier::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const DeclarationSpecifier& specifier)
{
	switch (specifier.model)
	{
	case DeclarationSpecifier::Type:
		return Print (stream, *specifier.type.specifier);

	case DeclarationSpecifier::Friend:
		return stream << Lexer::Friend;

	case DeclarationSpecifier::Inline:
		return stream << Lexer::Inline;

	case DeclarationSpecifier::Typedef:
		return stream << Lexer::Typedef;

	case DeclarationSpecifier::Function:
		return stream << specifier.function.specifier;

	case DeclarationSpecifier::Constexpr:
		return stream << Lexer::Constexpr;

	case DeclarationSpecifier::StorageClass:
		return stream << specifier.storageClass.specifier;

	default:
		assert (DeclarationSpecifier::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const EnumeratorDefinition& enumerator)
{
	Print (stream, enumerator.identifier);
	if (enumerator.attributes) Print (stream << ' ', *enumerator.attributes);
	if (enumerator.expression) Print (stream << ' ' << Lexer::Equal << ' ', *enumerator.expression);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const ExceptionDeclaration& declaration)
{
	if (declaration.attributes) Print (stream, *declaration.attributes) << ' ';
	if (declaration.specifiers.empty ()) stream << Lexer::Ellipsis; else Print (stream, declaration.specifiers);
	if (declaration.declarator) Print (stream << ' ', *declaration.declarator);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const ParameterDeclaration& declaration)
{
	if (declaration.attributes) Print (stream, *declaration.attributes) << ' ';
	Print (stream, declaration.specifiers);
	if (declaration.declarator) Print (stream << ' ', *declaration.declarator);
	if (declaration.initializer) Print (stream << ' ' << Lexer::Equal << ' ', *declaration.initializer);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const DeclarationSpecifiers& specifiers)
{
	Print<DeclarationSpecifier> (stream, specifiers);
	if (specifiers.attributes) Print (stream << ' ', *specifiers.attributes); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const ParameterDeclarations& declarations)
{
	Print<ParameterDeclaration> (stream, declarations);
	return declarations.isPacked ? (!declarations.empty () ? stream << Lexer::Comma << ' ' : stream) << Lexer::Ellipsis : stream;
}

std::ostream& CPP::operator << (std::ostream& stream, const Attribute& attribute)
{
	return Context {true}.Print (stream, attribute);
}

std::ostream& CPP::operator << (std::ostream& stream, const Statement& statement)
{
	return Context {true}.Print (stream, statement);
}

std::ostream& CPP::operator << (std::ostream& stream, const Expression& expression)
{
	return Context {true}.Print (stream, expression);
}

std::ostream& CPP::operator << (std::ostream& stream, const Identifier& identifier)
{
	return Context {true}.Print (stream, identifier);
}

std::ostream& CPP::operator << (std::ostream& stream, const Declaration& declaration)
{
	return Context {true}.Print (stream, declaration);
}

std::ostream& CPP::operator << (std::ostream& stream, const TypeSpecifier& specifier)
{
	return Context {true}.Print (stream, specifier);
}

std::ostream& CPP::operator << (std::ostream& stream, const InitDeclarator& declarator)
{
	return Context {true}.PrintSpecified (stream, declarator);
}

std::ostream& CPP::operator << (std::ostream& stream, const AttributeSpecifier& specifier)
{
	return Context {true}.Print (stream, specifier);
}

std::ostream& CPP::operator << (std::ostream& stream, const DeclarationSpecifier& specifier)
{
	return Context {true}.Print (stream, specifier);
}

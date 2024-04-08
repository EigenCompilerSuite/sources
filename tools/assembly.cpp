// Generic assembly language representation
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

#include "assembly.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace Assembly;

Program::Program (const Source& s) :
	source {s}
{
}

Expression::Expression (const Model m, const Value v) :
	model {m}, value {v}
{
}

Expression::Expression (const Model m, const Assembly::String& s) :
	model {m}, string {s}
{
}

Instruction::Instruction (const Location& l) :
	location {l}
{
}

bool Assembly::IsConditional (const Directive directive)
{
	return directive == Lexer::If || directive == Lexer::Elif || directive == Lexer::Else || directive == Lexer::Endif;
}

bool Assembly::IsLabel (const Expression& expression)
{
	return expression.model == Expression::Label;
}

bool Assembly::IsNumber (const Expression& expression)
{
	return expression.model == Expression::Number;
}

bool Assembly::IsString (const Expression& expression)
{
	return expression.model == Expression::String;
}

bool Assembly::IsIdentifier (const Expression& expression)
{
	return expression.model == Expression::Identifier;
}

bool Assembly::IsGroup (const Expression& expression)
{
	return expression.model == Expression::NullaryOperation && expression.operation == Lexer::Group;
}

bool Assembly::IsIdentity (const Expression& expression)
{
	return expression.model == Expression::UnaryOperation && expression.operation == Lexer::Plus;
}

bool Assembly::IsParenthesized (const Expression& expression)
{
	return expression.model == Expression::Parenthesized && expression.parenthesis == Lexer::LeftParen && expression.operands.size () == 1;
}

std::ostream& Assembly::operator << (std::ostream& stream, const Expressions& expressions)
{
	for (auto& expression: expressions) (expression.separated ? stream << Lexer::Comma << ' ' : IsFirst (expression, expressions) ? stream : stream << ' ') << expression;
	return stream;
}

std::ostream& Assembly::operator << (std::ostream& stream, const Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Label:
	case Expression::Number:
		return stream << expression.value;

	case Expression::Character:
		return WriteString (stream, expression.string, '\'');

	case Expression::String:
		return WriteString (stream, expression.string, '"');

	case Expression::Address:
		return WriteAddress (stream, nullptr, expression.string, 0, 0);

	case Expression::Identity:
	case Expression::Identifier:
		return stream << expression.string;

	case Expression::NullaryOperation:
		assert (expression.operands.empty ());
		return stream << expression.operation;

	case Expression::UnaryOperation:
		assert (expression.operands.size () == 1);
		return stream << expression.operation << expression.operands.front ();

	case Expression::BinaryOperation:
		assert (expression.operands.size () == 2);
		return stream << expression.operands.front () << expression.operation << expression.operands.back ();

	case Expression::PostfixOperation:
		assert (expression.operands.size () == 1);
		return stream << expression.operands.front () << expression.operation;

	case Expression::FunctionalOperation:
		assert (expression.operands.size () == 1);
		return stream << expression.operation << Lexer::LeftParen << expression.operands.front () << Lexer::RightParen;

	case Expression::Parenthesized:
		return stream << expression.parenthesis << expression.operands << Lexer::Symbol (expression.parenthesis + 1);

	default:
		assert (Expression::Unreachable);
	}
}

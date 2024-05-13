// Oberon pretty printer
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

#include "indenter.hpp"
#include "oberon.hpp"
#include "obprinter.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace Oberon;

using Context = class Printer::Context : Indenter
{
public:
	explicit Context (Interface);

	std::ostream& Print (std::ostream&, const Module&);

private:
	using Declarator = std::ostream& (Context::*) (std::ostream&, const Declaration&);

	const Interface interface;

	std::ostream& Begin (std::ostream&, const Declaration&);
	std::ostream& Conclude (std::ostream&, const Declaration&);
	std::ostream& Continue (std::ostream&, const Declaration&);

	std::ostream& BeginField (std::ostream&, const Declaration&);
	std::ostream& ConcludeField (std::ostream&, const Declaration&);

	std::ostream& Print (std::ostream&, const Body&, bool);
	std::ostream& Print (std::ostream&, const Case&);
	std::ostream& Print (std::ostream&, const Cases&);
	std::ostream& Print (std::ostream&, const Declaration&);
	std::ostream& Print (std::ostream&, const Declaration&, const Declaration*);
	std::ostream& Print (std::ostream&, const Declarations&, Declarator = &Context::Begin, Declarator = &Context::Continue, Declarator = &Context::Conclude);
	std::ostream& Print (std::ostream&, const Elsif&);
	std::ostream& Print (std::ostream&, const Elsifs&);
	std::ostream& Print (std::ostream&, const Guard&);
	std::ostream& Print (std::ostream&, const Guards&);
	std::ostream& Print (std::ostream&, const Signature&);
	std::ostream& Print (std::ostream&, const Statement&);
	std::ostream& Print (std::ostream&, const Statements&);
	std::ostream& Print (std::ostream&, const Type&);
};

Printer::Printer (const Interface i) :
	interface {i}
{
}

void Printer::Print (const Module& module, std::ostream& stream) const
{
	Context {interface && !IsGeneric (module)}.Print (stream, module);
}

Context::Context (const Interface i) :
	interface {i}
{
}

std::ostream& Context::Print (std::ostream& stream, const Module& module)
{
	Indent (stream) << Lexer::Module << ' ' << *module.identifier.name;
	if (module.definitions) stream << ' ' << Lexer::LeftParen << *module.definitions << Lexer::RightParen;
	if (module.identifier.parent) stream << ' ' << Lexer::In << ' ' << *module.identifier.parent;
	Print (stream << Lexer::Semicolon << "\n\n", module.declarations);
	if (module.body) Print (stream, *module.body, true);
	return Indent (stream) << Lexer::End << ' ' << *module.identifier.name << Lexer::Dot << '\n';
}

std::ostream& Context::Print (std::ostream& stream, const Declarations& declarations, const Declarator begin, const Declarator continue_, const Declarator conclude)
{
	if (declarations.empty ()) return stream;
	auto declaration = declarations.begin (); Print ((this->*begin) (stream, *declaration), *declaration, nullptr);
	for (auto previous = &*declaration; ++declaration != declarations.end (); ++previous)
		if (previous->model == declaration->model) Print ((this->*continue_) (stream, *declaration), *declaration, previous);
		else Print ((this->*begin) ((this->*conclude) (stream, *previous), *declaration), *declaration, previous);
	return (this->*conclude) (stream, declarations.back ());
}

std::ostream& Context::Begin (std::ostream& stream, const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		return Indent (stream) << Lexer::Import << ' ';

	case Declaration::Constant:
		return Increase (Indent (stream) << Lexer::Const << '\n');

	case Declaration::Type:
		return Increase (Indent (stream) << Lexer::Type << '\n');

	case Declaration::Variable:
		return Increase (Indent (stream) << Lexer::Var << '\n');

	case Declaration::Procedure:
		return Increase (stream);

	case Declaration::Parameter:
		if (declaration.parameter.isVariable) stream << Lexer::Var << ' ';
		return stream;

	default:
		assert (Declaration::Unreachable);
	};
}

std::ostream& Context::Continue (std::ostream& stream, const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		return stream << Lexer::Comma << ' ';

	case Declaration::Constant:
	case Declaration::Type:
	case Declaration::Variable:
	case Declaration::Parameter:
		return stream;

	case Declaration::Procedure:
		return stream << '\n';

	default:
		assert (Declaration::Unreachable);
	};
}

std::ostream& Context::Conclude (std::ostream& stream, const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		return stream << Lexer::Semicolon << "\n\n";

	case Declaration::Constant:
	case Declaration::Type:
		return Decrease (stream << '\n');

	case Declaration::Variable:
		return Decrease (Print (stream << Lexer::Colon << ' ', *declaration.variable.type) << Lexer::Semicolon << "\n\n");

	case Declaration::Procedure:
		return Decrease (stream << '\n');

	case Declaration::Parameter:
		return Print (stream << Lexer::Colon << ' ', *declaration.parameter.type);

	default:
		assert (Declaration::Unreachable);
	};
}

std::ostream& Context::Print (std::ostream& stream, const Declaration& declaration, const Declaration* previous)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		stream << declaration.name;
		if (declaration.import.alias) stream << ' ' << Lexer::Assign << ' ' << *declaration.import.alias;
		if (declaration.import.expressions) stream << ' ' << Lexer::LeftParen << *declaration.import.expressions << Lexer::RightParen;
		if (declaration.import.identifier.parent) stream << ' ' << Lexer::In << ' ' << *declaration.import.identifier.parent;
		return stream;

	case Declaration::Constant:
		Indent (stream) << declaration.name;
		if (declaration.isExported) stream << Lexer::Asterisk;
		return stream << ' ' << Lexer::Equal << ' ' << *declaration.constant.expression << Lexer::Semicolon << '\n';

	case Declaration::Type:
		Indent (stream) << declaration.name;
		if (declaration.isExported) stream << Lexer::Asterisk;
		return Print (stream << ' ' << Lexer::Equal << ' ', *declaration.type) << Lexer::Semicolon << '\n';

	case Declaration::Variable:
		if (!previous || !IsVariable (*previous)) Indent (stream);
		else if (previous->variable.type == declaration.variable.type && previous->variable.isForward == declaration.variable.isForward) stream << Lexer::Comma << ' ';
		else Indent (Print (stream << Lexer::Colon << ' ', *previous->variable.type) << Lexer::Semicolon << '\n');
		if (declaration.variable.isForward && (!previous || !IsVariable (*previous) || previous->variable.type != declaration.variable.type)) stream << Lexer::Arrow;
		stream << declaration.name;
		if (declaration.variable.isReadOnly) stream << Lexer::Minus; else if (declaration.isExported) stream << Lexer::Asterisk;
		if (declaration.variable.external) stream << ' ' << Lexer::LeftBracket << *declaration.variable.external << Lexer::RightBracket;
		return stream;

	case Declaration::Procedure:
		Indent (stream) << Lexer::Procedure;
		if (declaration.procedure.isAbstract) stream << Lexer::Asterisk; else if (declaration.procedure.isFinal) stream << Lexer::Minus;
		if (declaration.procedure.isForward) stream << ' ' << Lexer::Arrow;
		if (declaration.procedure.signature.receiver) Print (stream << ' ' << Lexer::LeftParen, *declaration.procedure.signature.receiver) << Lexer::RightParen;
		stream << ' ' << declaration.name; if (declaration.isExported) stream << Lexer::Asterisk;
		if (declaration.procedure.external) stream << ' ' << Lexer::LeftBracket << *declaration.procedure.external << Lexer::RightBracket;
		Print (stream, declaration.procedure.signature) << Lexer::Semicolon << '\n';
		if (declaration.procedure.isAbstract || declaration.procedure.isForward) return stream;
		if (declaration.procedure.declarations && !interface) Print (stream, *declaration.procedure.declarations);
		if (declaration.procedure.body) Print (stream, *declaration.procedure.body, false);
		return Indent (stream) << Lexer::End << ' ' << declaration.name << Lexer::Semicolon << '\n';

	case Declaration::Parameter:
		if (previous) if (previous->parameter.type == declaration.parameter.type) stream << Lexer::Comma << ' ';
		else Begin (Conclude (stream, *previous) << Lexer::Semicolon << ' ', declaration);
		stream << declaration.name;
		if (declaration.parameter.isReadOnly) stream << Lexer::Minus;
		return stream;

	default:
		assert (Declaration::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Declaration& declaration)
{
	return Conclude (Print (Begin (stream, declaration), declaration, nullptr), declaration);
}

std::ostream& Context::Print (std::ostream& stream, const Type& type)
{
	if (IsAlias (type)) return stream << *type.identifier;

	switch (type.model)
	{
	case Type::Array:
		stream << Lexer::Array << ' ';
		if (type.array.length) stream << *type.array.length << ' ';
		return Print (stream << Lexer::Of << ' ', *type.array.elementType);

	case Type::Record:
		stream << Lexer::Record;
		if (type.record.isAbstract) stream << Lexer::Asterisk; else if (type.record.isFinal) stream << Lexer::Minus;
		if (type.record.baseType) Print (stream << ' ' << Lexer::LeftParen, *type.record.baseType) << Lexer::RightParen;
		return (type.record.declarations ? Indent (Print (stream << '\n', *type.record.declarations, &Context::BeginField, &Context::Continue, &Context::ConcludeField)) : stream << ' ') << Lexer::End;

	case Type::Pointer:
		stream << Lexer::Pointer << ' ' << Lexer::To << ' ';
		if (type.pointer.isVariable) stream << Lexer::Var << ' ';
		if (type.pointer.isReadOnly) stream << Lexer::Minus << ' ';
		return Print (stream, *type.pointer.baseType);

	case Type::Procedure:
		return Print (stream << Lexer::Procedure, type.procedure.signature);

	default:
		assert (Type::Unreachable);
	}
}

std::ostream& Context::BeginField (std::ostream& stream, const Declaration& declaration)
{
	assert (IsVariable (declaration));
	return Increase (stream);
}

std::ostream& Context::ConcludeField (std::ostream& stream, const Declaration& declaration)
{
	assert (IsVariable (declaration));
	return Decrease (Print (stream << Lexer::Colon << ' ', *declaration.variable.type) << Lexer::Semicolon << '\n');
}

std::ostream& Context::Print (std::ostream& stream, const Signature& signature)
{
	if (signature.parameters && !signature.parameters->empty () || signature.result) stream << ' ' << Lexer::LeftParen;
	if (signature.parameters) Print (stream, *signature.parameters);
	if (signature.parameters && !signature.parameters->empty () || signature.result) stream << Lexer::RightParen;
	if (signature.result) Print (stream << Lexer::Colon << ' ', *signature.result);
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Body& body, const bool required)
{
	if (!interface) return Print (Indent (stream) << Lexer::Begin << '\n', body.statements);
	if (!IsTerminating (body)) return Indent (stream) << Lexer::Begin << ' ' << Lexer::Loop << ' ' << Lexer::End << Lexer::Semicolon << '\n';
	if (required) return Indent (stream) << Lexer::Begin << '\n'; return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Statements& statements)
{
	Increase (stream); for (auto& statement: statements) Print (stream, statement); return Decrease (stream);
}

std::ostream& Context::Print (std::ostream& stream, const Statement& statement)
{
	switch (statement.model)
	{
	case Statement::If:
		Print (Indent (stream) << statement << '\n', *statement.if_.thenPart);
		if (statement.if_.elsifs) Print (stream, *statement.if_.elsifs);
		if (statement.if_.elsePart) Print (Indent (stream) << Lexer::Else << '\n', *statement.if_.elsePart);
		return Indent (stream) << Lexer::End << Lexer::Semicolon << '\n';

	case Statement::For:
		return Indent (Print (Indent (stream) << statement << '\n', *statement.for_.statements)) << Lexer::End << Lexer::Semicolon << '\n';

	case Statement::Case:
		Indent (stream) << statement << '\n';
		if (statement.case_.cases) Print (stream, *statement.case_.cases);
		if (statement.case_.elsePart) Print (Indent (stream) << Lexer::Else << '\n', *statement.case_.elsePart);
		return Indent (stream) << Lexer::End << Lexer::Semicolon << '\n';

	case Statement::Exit:
	case Statement::Return:
	case Statement::Assignment:
	case Statement::ProcedureCall:
		return Indent (stream) << statement << Lexer::Semicolon << '\n';

	case Statement::Loop:
		return Indent (Print (Indent (stream) << statement << '\n', *statement.loop.statements)) << Lexer::End << Lexer::Semicolon << '\n';

	case Statement::With:
		Print (Indent (stream) << Lexer::With << ' ', *statement.with.guards);
		if (statement.with.elsePart) Print (Indent (stream) << Lexer::Else << '\n', *statement.with.elsePart);
		return Indent (stream) << Lexer::End << Lexer::Semicolon << '\n';

	case Statement::While:
		return Indent (Print (Indent (stream) << statement << '\n', *statement.while_.statements)) << Lexer::End << Lexer::Semicolon << '\n';

	case Statement::Repeat:
		return Indent (Print (Indent (stream) << statement << '\n', *statement.repeat.statements)) << Lexer::Until << ' ' << *statement.repeat.condition << Lexer::Semicolon << '\n';

	default:
		assert (Statement::Unreachable);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Elsifs& elsifs)
{
	for (auto& elsif: elsifs) Print (stream, elsif); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Elsif& elsif)
{
	return Print (Indent (stream) << elsif << '\n', elsif.statements);
}

std::ostream& Context::Print (std::ostream& stream, const Cases& cases)
{
	for (auto& case_: cases) Print (stream, case_); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Case& case_)
{
	return Print (Indent (stream) << Lexer::Bar << ' ' << case_.labels << Lexer::Colon << '\n', case_.statements);
}

std::ostream& Context::Print (std::ostream& stream, const Guards& guards)
{
	for (auto& guard: guards) Print (IsFirst (guard, guards) ? stream : Indent (stream) << Lexer::Bar << ' ', guard); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Guard& guard)
{
	return Print (stream << guard << '\n', guard.statements);
}

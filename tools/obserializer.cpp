// Oberon serializer
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

#include "oberon.hpp"
#include "obserializer.hpp"
#include "xmlserializer.hpp"

#include <cassert>

using namespace ECS;
using namespace Oberon;

using Context = class Serializer::Context : XML::Serializer
{
public:
	explicit Context (XML::Document&, const Module&);

	void Serialize ();

private:
	const Module& module;

	void Serialize (const Annotation&);
	void Serialize (const Body&);
	void Serialize (const Case&);
	void Serialize (const Declaration&);
	void Serialize (const Elsif&);
	void Serialize (const Guard&);
	void Serialize (const Identifier&, const Type&);
	void Serialize (const Module&);
	void Serialize (const Signature&);
	void Serialize (const Statement&);
	void Serialize (const Type&);

	void Serialize (const Expression&);
	void SerializeRange (const Expression&);

	using XML::Serializer::Attribute;
	void Attribute (const Identifier&);
	void Attribute (const Type&);
	void Attribute (const Value&);

	template <typename Structure> void Serialize (const std::vector<Structure>&);
};

void Serializer::Serialize (const Module& module, XML::Document& document) const
{
	Context {document, module}.Serialize ();
}

Context::Context (XML::Document& document, const Module& m) :
	XML::Serializer {document, "module", "oberon"}, module {m}
{
}

void Context::Serialize ()
{
	Serialize (module);
}

void Context::Serialize (const Module& module)
{
	Attribute (*module.identifier.name);
	if (module.identifier.parent) Attribute ("package", *module.identifier.parent);
	Attribute ("source", module.source);
	Serialize (module.annotation);
	Serialize (module.documentation);
	Serialize (module.parameters);
	Serialize (module.declarations);
	if (module.body) Serialize (*module.body);
}

template <typename Structure>
void Context::Serialize (const std::vector<Structure>& container)
{
	for (auto& structure: container) Serialize (structure);
}

void Context::Serialize (const Annotation& annotation)
{
	if (annotation.string.empty ()) return;
	Open ("annotation");
	Attribute (annotation.position);
	Write (annotation.string);
	Close ();
}

void Context::Serialize (const Body& body)
{
	Open ("body");
	Attribute (body.begin.position);
	Serialize (body.statements);
	Close ();
}

void Context::Serialize (const Declaration& declaration)
{
	switch (declaration.model)
	{
	case Declaration::Import:
		Open ("import");
		Attribute (declaration.name);
		if (declaration.import.alias) Attribute ("alias", *declaration.import.alias);
		if (declaration.import.identifier.parent) Attribute ("package", *declaration.import.identifier.parent);
		if (declaration.import.expressions) Serialize (*declaration.import.expressions);
		if (IsModule (*declaration.import.scope) && IsParameterized (*declaration.import.scope->module)) Open ("module"), Serialize (*declaration.import.scope->module), Close ();
		break;

	case Declaration::Constant:
		Open ("constant");
		Attribute (declaration.name);
		Attribute ("exported", declaration.isExported);
		Serialize (declaration.annotation);
		Serialize (*declaration.constant.expression);
		break;

	case Declaration::Type:
		Open ("type");
		Attribute (declaration.name);
		Attribute ("exported", declaration.isExported);
		Attribute (*declaration.type);
		Serialize (declaration.annotation);
		Serialize (*declaration.type);
		break;

	case Declaration::Variable:
		Open ("variable");
		Attribute (declaration.name);
		Attribute ("exported", declaration.isExported);
		Attribute ("read-only", declaration.variable.isReadOnly);
		if (!IsField (declaration)) Attribute ("forward", declaration.variable.isForward);
		if (IsExternal (declaration)) Attribute ("external", declaration.variable.external->value);
		Attribute (*declaration.variable.type);
		Serialize (declaration.annotation);
		if (IsExternal (declaration)) Serialize (*declaration.variable.external);
		Serialize (*declaration.variable.type);
		break;

	case Declaration::Procedure:
		Open ("procedure");
		Attribute (declaration.name);
		Attribute ("exported", declaration.isExported);
		if (IsTypeBound (declaration)) Attribute ("abstract", declaration.procedure.isAbstract), Attribute ("final", declaration.procedure.isFinal);
		Attribute ("forward", declaration.procedure.isForward);
		if (IsExternal (declaration)) Attribute ("external", declaration.procedure.external->value);
		Serialize (declaration.annotation);
		if (IsExternal (declaration)) Serialize (*declaration.procedure.external);
		if (declaration.procedure.signature.receiver) Attribute ("receiver", *declaration.procedure.signature.receiver->parameter.type), Serialize (*declaration.procedure.signature.receiver);
		Serialize (declaration.procedure.signature);
		if (declaration.procedure.isAbstract || declaration.procedure.isForward) break;
		if (declaration.procedure.declarations) Serialize (*declaration.procedure.declarations);
		if (declaration.procedure.body) Serialize (*declaration.procedure.body);
		break;

	case Declaration::Parameter:
		Open ("parameter");
		Attribute (declaration.name);
		Attribute ("variable", declaration.parameter.isVariable);
		Attribute ("read-only", declaration.parameter.isReadOnly);
		Attribute (*declaration.parameter.type);
		Serialize (*declaration.parameter.type);
		break;

	default:
		assert (Declaration::Unreachable);
	}

	Close ();
}

void Context::Serialize (const Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Set:
		Open ("set");
		if (expression.set.elements) for (auto& element: *expression.set.elements)
			if (IsRange (element)) SerializeRange (element); else Serialize (element);
		break;

	case Expression::Call:
		Open ("call");
		Serialize (*expression.call.designator);
		if (expression.call.arguments) Serialize (*expression.call.arguments);
		break;

	case Expression::Index:
		Open ("index");
		Serialize (*expression.index.designator);
		Serialize (*expression.index.expression);
		break;

	case Expression::Super:
		Open ("super");
		Serialize (*expression.super.designator);
		break;

	case Expression::Unary:
		Open ("unary");
		Attribute ("operator", expression.unary.operator_);
		Serialize (*expression.unary.operand);
		break;

	case Expression::Binary:
		Open ("binary");
		Attribute ("operator", expression.binary.operator_);
		Serialize (*expression.binary.left);
		Serialize (*expression.binary.right);
		break;

	case Expression::Literal:
		Open ("literal");
		Write (*expression.literal);
		break;

	case Expression::Selector:
		Open ("selector");
		Serialize (*expression.selector.designator);
		Serialize (*expression.selector.identifier, *expression.type);
		break;

	case Expression::Promotion:
		Open ("promotion");
		Serialize (*expression.promotion.expression);
		break;

	case Expression::TypeGuard:
		Open ("type-guard");
		Serialize (*expression.typeGuard.designator);
		Serialize (*expression.typeGuard.identifier);
		break;

	case Expression::Conversion:
		Open ("conversion");
		Serialize (*expression.conversion.designator);
		Serialize (*expression.conversion.expression);
		break;

	case Expression::Identifier:
		Open ("identifier");
		Write (expression.identifier);
		break;

	case Expression::Dereference:
		Open ("dereference");
		Serialize (*expression.dereference.expression);
		break;

	case Expression::Parenthesized:
		Open ("parenthesized");
		Serialize (*expression.parenthesized.expression);
		break;

	default:
		assert (Expression::Unreachable);
	};

	Attribute (*expression.type);
	if (IsConstant (expression)) Attribute (expression.value);
	Attribute (expression.position);
	Close ();
}

void Context::SerializeRange (const Expression& expression)
{
	assert (IsRange (expression));
	Open ("range"); Attribute (expression.position);
	if (IsConstant (*expression.binary.left)) Attribute ("lower", expression.binary.left->value);
	if (IsConstant (*expression.binary.right)) Attribute ("upper", expression.binary.right->value);
	Serialize (*expression.binary.left); Serialize (*expression.binary.right);
	Close ();
}

void Context::Serialize (const Identifier& identifier, const Type& type)
{
	Open ("identifier");
	Attribute (type);
	Attribute (identifier.position);
	Write (identifier);
	Close ();
}

void Context::Serialize (const Type& type)
{
	if (IsAlias (type)) return;

	switch (type.model)
	{
	case Type::Array:
		Open ("array");
		if (type.array.length) Attribute ("length", type.array.length->value), Serialize (*type.array.length);
		Attribute ("elementType", *type.array.elementType);
		Serialize (*type.array.elementType);
		break;

	case Type::Record:
		Open ("record");
		Attribute ("abstract", type.record.isAbstract);
		Attribute ("final", type.record.isFinal);
		if (type.record.baseType) Serialize (*type.record.baseType);
		if (type.record.declarations) Serialize (*type.record.declarations);
		break;

	case Type::Pointer:
		Open ("pointer");
		Attribute ("variable", type.pointer.isVariable);
		Attribute ("read-only", type.pointer.isReadOnly);
		Attribute ("baseType", *type.pointer.baseType);
		Serialize (*type.pointer.baseType);
		break;

	case Type::Procedure:
		Open ("procedure-type");
		Serialize (type.procedure.signature);
		break;

	default:
		assert (Type::Unreachable);
	}

	Close ();
}

void Context::Serialize (const Signature& signature)
{
	if (signature.parameters) Serialize (*signature.parameters);
	if (signature.result) Serialize (*signature.result);
}

void Context::Serialize (const Statement& statement)
{
	switch (statement.model)
	{
	case Statement::If:
		Open ("if");
		Serialize (*statement.if_.condition);
		Open ("then"); Serialize (*statement.if_.thenPart); Close ();
		if (statement.if_.elsifs) Serialize (*statement.if_.elsifs);
		if (statement.if_.elsePart) Open ("else"), Serialize (*statement.if_.elsePart), Close ();
		break;

	case Statement::For:
		Open ("for");
		Serialize (*statement.for_.variable);
		Serialize (*statement.for_.begin);
		Serialize (*statement.for_.end);
		if (statement.for_.step) Serialize (*statement.for_.step);
		Serialize (*statement.for_.statements);
		break;

	case Statement::Case:
		Open ("case");
		Serialize (*statement.case_.expression);
		if (statement.case_.cases) Serialize (*statement.case_.cases);
		if (statement.case_.elsePart) Open ("else"), Serialize (*statement.case_.elsePart), Close ();
		break;

	case Statement::Exit:
		Open ("exit");
		break;

	case Statement::Loop:
		Open ("loop");
		Serialize (*statement.loop.statements);
		break;

	case Statement::With:
		Open ("with");
		Serialize (*statement.with.guards);
		if (statement.with.elsePart) Open ("else"), Serialize (*statement.with.elsePart), Close ();
		break;

	case Statement::While:
		Open ("while");
		Serialize (*statement.while_.condition);
		Serialize (*statement.while_.statements);
		break;

	case Statement::Repeat:
		Open ("repeat");
		Serialize (*statement.repeat.statements);
		Serialize (*statement.repeat.condition);
		break;

	case Statement::Return:
		Open ("return");
		if (statement.return_.expression) Serialize (*statement.return_.expression);
		break;

	case Statement::Assignment:
		Open ("assignment");
		Serialize (*statement.assignment.designator);
		Serialize (*statement.assignment.expression);
		break;

	case Statement::ProcedureCall:
		Open ("procedure-call");
		Serialize (*statement.procedureCall.designator->call.designator);
		if (const auto arguments = statement.procedureCall.designator->call.arguments) Serialize (*arguments);
		break;

	default:
		assert (Statement::Unreachable);
	}

	Attribute (statement.position);
	Close ();
}

void Context::Serialize (const Elsif& elsif)
{
	Open ("elsif");
	Attribute (elsif.position);
	Serialize (elsif.statements);
	Close ();
}

void Context::Serialize (const Case& case_)
{
	Open ("case-label");
	for (auto& label: case_.labels) if (IsRange (label)) SerializeRange (label); else Serialize (label);
	Serialize (case_.statements);
	Close ();
}

void Context::Serialize (const Guard& guard)
{
	Open ("guard");
	Attribute (guard.position);
	Serialize (guard.type);
	Serialize (guard.statements);
	Close ();
}

void Context::Attribute (const Value& value)
{
	Attribute ("value", value);
}

void Context::Attribute (const Identifier& identifier)
{
	Attribute ("name", identifier.string);
	Attribute (identifier.position);
}

void Context::Attribute (const Type& type)
{
	Attribute ("type", type);
}

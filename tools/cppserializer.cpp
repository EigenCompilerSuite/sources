// C++ serializer
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
#include "cppserializer.hpp"
#include "xmlserializer.hpp"

#include <cassert>

using namespace ECS;
using namespace CPP;

using Context = class Serializer::Context : XML::Serializer
{
public:
	Context (XML::Document&, const TranslationUnit&);

	void Serialize ();

private:
	const TranslationUnit& translationUnit;

	void Serialize (const AccessSpecifier&);
	void Serialize (const AttributeSpecifier&);
	void Serialize (const AttributeSpecifiers&);
	void Serialize (const BaseSpecifier&);
	void Serialize (const BaseSpecifiers&);
	void Serialize (const Capture&);
	void Serialize (const Captures&);
	void Serialize (const ClassHead&);
	void Serialize (const ClassKey&);
	void Serialize (const Condition&);
	void Serialize (const ConstVolatileQualifiers&);
	void Serialize (const Declaration&);
	void Serialize (const Declarations&);
	void Serialize (const DeclarationSpecifier&);
	void Serialize (const DeclarationSpecifiers&);
	void Serialize (const Declarator&);
	void Serialize (const DecltypeSpecifier&);
	void Serialize (const EnumeratorDefinition&);
	void Serialize (const EnumeratorDefinitions&);
	void Serialize (const EnumHead&);
	void Serialize (const EnumKey&);
	void Serialize (const ExceptionDeclaration&);
	void Serialize (const ExceptionHandler&);
	void Serialize (const ExceptionHandlers&);
	void Serialize (const Expression&);
	void Serialize (const Expressions&);
	void Serialize (const FunctionBody&);
	void Serialize (const FunctionPrototype&);
	void Serialize (const Identifier&);
	void Serialize (const InitDeclarator&);
	void Serialize (const InitDeclarators&);
	void Serialize (const Initializer&);
	void Serialize (const LambdaDeclarator&);
	void Serialize (const Lexer::Symbol);
	void Serialize (const Lexer::Token&);
	void Serialize (const MemberDeclarator&);
	void Serialize (const MemberDeclarators&);
	void Serialize (const MemberInitializer&);
	void Serialize (const MemberInitializers&);
	void Serialize (const NestedNameSpecifier&);
	void Serialize (const NoexceptSpecifier&);
	void Serialize (const Operator&);
	void Serialize (const ParameterDeclaration&);
	void Serialize (const ParameterDeclarations&);
	void Serialize (const ReferenceQualifier&);
	void Serialize (const Statement&);
	void Serialize (const StatementBlock&);
	void Serialize (const Statements&);
	void Serialize (const StringLiteral&);
	void Serialize (const struct Attribute&);
	void Serialize (const Substatement&);
	void Serialize (const TemplateArgument&);
	void Serialize (const TemplateArguments&);
	void Serialize (const TemplateParameter&);
	void Serialize (const TemplateParameters&);
	void Serialize (const TypeIdentifier&);
	void Serialize (const TypeParameterKey&);
	void Serialize (const TypeSpecifier&);
	void Serialize (const TypeSpecifiers&);
	void Serialize (const UsingDeclarator&);
	void Serialize (const UsingDeclarators&);
	void Serialize (const VirtualSpecifiers&);

	void SerializeEnumBase (const TypeSpecifiers&);
	void SerializeInitializer (const Expressions&);
	void SerializeStringLiteral (const Lexer::Token&);
	void SerializeUnqualified (const Identifier&);

	using XML::Serializer::Attribute;
	void Attribute (const Entity&);
	void Attribute (const Location&);

	template <typename Structure> void Serialize (const Packed<Structure>&);
};

void Serializer::Serialize (const TranslationUnit& translationUnit, XML::Document& document) const
{
	Context {document, translationUnit}.Serialize ();
}

Context::Context (XML::Document& document, const TranslationUnit& tu) :
	XML::Serializer {document, "translation-unit", "cpp"}, translationUnit {tu}
{
}

template <typename Structure>
void Context::Serialize (const Packed<Structure>& structure)
{
	Serialize (static_cast<const Structure&> (structure));
	if (structure.isPacked) Serialize (Lexer::Ellipsis);
}

void Context::Serialize ()
{
	Attribute ("source", translationUnit.source);
	if (!translationUnit.declarations.empty ()) Serialize (translationUnit.declarations);
}

void Context::Serialize (const Declarations& declarations)
{
	Open ("declaration-seq");
	for (auto& declaration: declarations) Serialize (declaration);
	Close ();
}

void Context::Serialize (const Declaration& declaration)
{
	Open ("declaration");
	Attribute (declaration.location);

	switch (declaration.model)
	{
	case Declaration::Asm:
		Open ("asm-definition");
		if (declaration.asm_.attributes) Serialize (*declaration.asm_.attributes);
		Serialize (*declaration.asm_.stringLiteral);
		Close ();
		break;

	case Declaration::Alias:
		Open ("alias-declaration");
		Serialize (*declaration.alias.identifier);
		if (declaration.alias.attributes) Serialize (*declaration.alias.attributes);
		Serialize (*declaration.alias.typeIdentifier);
		Attribute (*declaration.alias.entity);
		Attribute ("type", declaration.alias.typeIdentifier->type);
		Close ();
		break;

	case Declaration::Empty:
		Open ("empty-declaration");
		Close ();
		break;

	case Declaration::Using:
		Open ("using-declaration");
		Serialize (*declaration.using_.declarators);
		Close ();
		break;

	case Declaration::Access:
		Open ("member-specification");
		Serialize (declaration.access.specifier);
		Close ();
		break;

	case Declaration::Member:
		Open ("member-declaration");
		if (declaration.member.attributes) Serialize (*declaration.member.attributes);
		if (!declaration.simple.specifiers->empty ()) Serialize (*declaration.member.specifiers);
		if (declaration.member.declarators) Serialize (*declaration.member.declarators);
		Close ();
		break;

	case Declaration::Simple:
		Open ("simple-declaration");
		if (declaration.simple.attributes) Serialize (*declaration.simple.attributes);
		if (!declaration.simple.specifiers->empty ()) Serialize (*declaration.simple.specifiers);
		if (declaration.simple.declarators) Serialize (*declaration.simple.declarators);
		Close ();
		break;

	case Declaration::Template:
		Open ("template-declaration");
		Serialize (*declaration.template_.parameters);
		Serialize (*declaration.template_.declaration);
		Close ();
		break;

	case Declaration::Attribute:
		Open ("attribute-declaration");
		Serialize (*declaration.attribute.specifiers);
		Close ();
		break;

	case Declaration::Condition:
		Open ("condition-declaration");
		if (declaration.condition.attributes) Serialize (*declaration.condition.attributes);
		Serialize (*declaration.condition.specifiers);
		Serialize (*declaration.condition.declarator);
		Serialize (*declaration.condition.initializer);
		Close ();
		break;

	case Declaration::OpaqueEnum:
		Open ("opaque-enum-declaration");
		Attribute (*declaration.opaqueEnum.head.enumeration->entity);
		Serialize (declaration.opaqueEnum.head.key);
		if (declaration.opaqueEnum.head.attributes) Serialize (*declaration.opaqueEnum.head.attributes);
		Serialize (*declaration.opaqueEnum.head.identifier);
		if (declaration.opaqueEnum.head.base) SerializeEnumBase (*declaration.opaqueEnum.head.base);
		Close ();
		break;

	case Declaration::UsingDirective:
		Open ("using-directive");
		Attribute (*declaration.usingDirective.namespace_->entity);
		if (declaration.usingDirective.attributes) Serialize (*declaration.usingDirective.attributes);
		Serialize (*declaration.usingDirective.identifier);
		Close ();
		break;

	case Declaration::StaticAssertion:
		Open ("static_assert-declaration");
		Serialize (*declaration.staticAssertion.expression);
		if (declaration.staticAssertion.stringLiteral) Serialize (*declaration.staticAssertion.stringLiteral);
		Close ();
		break;

	case Declaration::FunctionDefinition:
		Open ("function-definition");
		Attribute (*declaration.functionDefinition.entity);
		if (declaration.functionDefinition.attributes) Serialize (*declaration.functionDefinition.attributes);
		if (!declaration.functionDefinition.specifiers->empty ()) Serialize (*declaration.functionDefinition.specifiers);
		Serialize (*declaration.functionDefinition.declarator);
		if (declaration.functionDefinition.virtualSpecifiers) Serialize (*declaration.functionDefinition.virtualSpecifiers);
		Serialize (*declaration.functionDefinition.body);
		Close ();
		break;

	case Declaration::NamespaceDefinition:
		Open ("namespace-definition");
		if (declaration.namespaceDefinition.namespace_->entity) Attribute (*declaration.namespaceDefinition.namespace_->entity);
		if (declaration.namespaceDefinition.isInline) Serialize (Lexer::Inline);
		if (declaration.namespaceDefinition.attributes) Serialize (*declaration.namespaceDefinition.attributes);
		if (declaration.namespaceDefinition.identifier) Serialize (*declaration.namespaceDefinition.identifier);
		if (declaration.namespaceDefinition.body) Serialize (*declaration.namespaceDefinition.body);
		Close ();
		break;

	case Declaration::LinkageSpecification:
		Open ("linkage-specification");
		Serialize (*declaration.linkageSpecification.stringLiteral);
		if (declaration.linkageSpecification.declaration) Serialize (*declaration.linkageSpecification.declaration);
		else if (declaration.linkageSpecification.declarations) Serialize (*declaration.linkageSpecification.declarations);
		Close ();
		break;

	case Declaration::ExplicitInstantiation:
		Open ("explicit-instantiation");
		if (declaration.explicitInstantiation.isExtern) Serialize (Lexer::Extern);
		Serialize (*declaration.explicitInstantiation.declaration);
		Close ();
		break;

	case Declaration::ExplicitSpecialization:
		Open ("explicit-specialization");
		Serialize (*declaration.explicitSpecialization.declaration);
		Close ();
		break;

	case Declaration::NamespaceAliasDefinition:
		Open ("namespace-alias-definition");
		Attribute (*declaration.namespaceAliasDefinition.namespace_->entity);
		Serialize (*declaration.namespaceAliasDefinition.identifier);
		Serialize (*declaration.namespaceAliasDefinition.name);
		Close ();
		break;

	default:
		assert (Declaration::Unreachable);
	}

	Close ();
}

void Context::Serialize (const UsingDeclarators& declarators)
{
	Open ("using-declarator-list");
	for (auto& declarator: declarators) Serialize (declarator);
	Close ();
}

void Context::Serialize (const UsingDeclarator& declarator)
{
	Open ("using-declarator");
	if (declarator.isTypename) Serialize (Lexer::Typename);
	Serialize (declarator.identifier);
	Close ();
}

void Context::Serialize (const DeclarationSpecifier& specifier)
{
	Open ("decl-specifier");
	Attribute (specifier.location);

	switch (specifier.model)
	{
	case DeclarationSpecifier::Type:
		Serialize (*specifier.type.specifier);
		break;

	case DeclarationSpecifier::Friend:
		Serialize (Lexer::Friend);
		break;

	case DeclarationSpecifier::Inline:
		Serialize (Lexer::Inline);
		break;

	case DeclarationSpecifier::Typedef:
		Serialize (Lexer::Typedef);
		break;

	case DeclarationSpecifier::Constexpr:
		Serialize (Lexer::Constexpr);
		break;

	case DeclarationSpecifier::Function:
		Open ("function-specifier");
		Serialize (specifier.function.specifier);
		Close ();
		break;

	case DeclarationSpecifier::StorageClass:
		Open ("storage-class-specifier");
		Serialize (specifier.storageClass.specifier);
		Close ();
		break;

	default:
		assert (DeclarationSpecifier::Unreachable);
	}

	Close ();
}

void Context::Serialize (const DeclarationSpecifiers& specifiers)
{
	Open ("decl-specifier-seq");
	Attribute ("type", specifiers.type);
	for (auto& specifier: specifiers) Serialize (specifier);
	Close ();
}

void Context::Serialize (const Identifier& identifier)
{
	if (IsQualified (identifier)) Serialize (*identifier.nestedNameSpecifier);
	SerializeUnqualified (identifier);
}

void Context::SerializeUnqualified (const Identifier& identifier)
{
	switch (identifier.model)
	{
	case Identifier::Name:
		Open ("identifier");
		Attribute (identifier.location);
		Write (*identifier.name.identifier);
		Close ();
		break;

	case Identifier::Template:
		Open ("template-id");
		Serialize (*identifier.template_.identifier);
		if (identifier.template_.arguments) Serialize (*identifier.template_.arguments);
		Close ();
		break;

	case Identifier::Destructor:
		Open ("destructor-id");
		Attribute ("type", *identifier.destructor.type);
		Serialize (*identifier.destructor.specifier);
		Close ();
		break;

	case Identifier::LiteralOperator:
		Open ("literal-operator-id"); Open ("identifier");
		Attribute (identifier.location);
		Write (*identifier.literalOperator.suffixIdentifier);
		Close (); Close ();
		break;

	case Identifier::OperatorFunction:
		Open ("operator-function-id");
		Serialize (identifier.operatorFunction.operator_);
		Close ();
		break;

	case Identifier::ConversionFunction:
		Open ("conversion-function-id");
		Serialize (*identifier.conversionFunction.typeIdentifier);
		Close ();
		break;

	default:
		assert (Identifier::Unreachable);
	}
}

void Context::Serialize (const NestedNameSpecifier& specifier)
{
	Open ("nested-name-specifier");
	Attribute (specifier.location);
	Attribute ("scope", *specifier.scope);

	switch (specifier.model)
	{
	case NestedNameSpecifier::Name:
		if (IsQualified (*specifier.name.identifier)) Serialize (*specifier.name.identifier->nestedNameSpecifier);
		SerializeUnqualified (*specifier.name.identifier);
		break;

	case NestedNameSpecifier::Global:
		Serialize (Lexer::DoubleColon);
		break;

	case NestedNameSpecifier::Decltype:
		Serialize (specifier.decltype_.specifier);
		break;

	default:
		assert (Identifier::Unreachable);
	}

	Close ();
}

void Context::Serialize (const AttributeSpecifiers& specifiers)
{
	Open ("attribute-specifier-seq");
	for (auto& specifier: specifiers) Serialize (specifier);
	Close ();
}

void Context::Serialize (const AttributeSpecifier& specifier)
{
	Open ("attribute-specifier");
	Attribute (specifier.location);

	switch (specifier.model)
	{
	case AttributeSpecifier::Attributes:
		if (specifier.attributes.usingPrefix) Open ("attribute-using-prefix"), Serialize (*specifier.attributes.usingPrefix), Close ();
		Open ("attribute-list");
		if (specifier.attributes.list) for (auto& attribute: *specifier.attributes.list) Serialize (attribute);
		Close ();
		break;

	case AttributeSpecifier::AlignasType:
		Open ("alignment-specifier");
		Attribute ("alignment", specifier.alignment);
		Serialize (*specifier.alignasType.typeIdentifier);
		Close ();
		break;

	case AttributeSpecifier::AlignasExpression:
		Open ("alignment-specifier");
		Attribute ("alignment", specifier.alignment);
		Serialize (*specifier.alignasExpression.expression);
		Close ();
		break;

	default:
		assert (AttributeSpecifier::Unreachable);
	}

	Close ();
}

void Context::Serialize (const EnumHead& head)
{
	Open ("enum-head");
	Serialize (head.key);
	if (head.attributes) Serialize (*head.attributes);
	if (head.identifier) Serialize (*head.identifier);
	if (head.base) SerializeEnumBase (*head.base);
	Close ();
}

void Context::Serialize (const EnumKey& key)
{
	Open ("enum-key");
	Attribute ("scoped", IsScoped (key));
	Serialize (key.symbol);
	Close ();
}

void Context::Serialize (const ClassHead& head)
{
	Open ("class-head");
	Serialize (head.key);
	if (head.attributes) Serialize (*head.attributes);
	if (head.identifier) Serialize (*head.identifier);
	if (head.isFinal) Open ("class-virt-specifier"), Open ("final"), Close (), Close ();
	if (head.baseSpecifiers) Serialize (*head.baseSpecifiers);
	Close ();
}

void Context::Serialize (const ClassKey& key)
{
	Open ("class-key");
	Serialize (key.symbol);
	Close ();
}

void Context::Serialize (const BaseSpecifiers& specifiers)
{
	Open ("base-clause");
	Open ("base-specifier-list");
	for (auto& specifier: specifiers) Serialize (specifier);
	Close (); Close ();
}

void Context::Serialize (const BaseSpecifier& specifier)
{
	Open ("base-specifier");
	if (specifier.attributes) Serialize (*specifier.attributes);
	if (specifier.isVirtual) Serialize (Lexer::Virtual);
	if (specifier.accessSpecifier) Serialize (*specifier.accessSpecifier);
	Serialize (specifier.typeSpecifier);
	Close ();
}

void Context::Serialize (const AccessSpecifier& specifier)
{
	Open ("access-specifier");
	Serialize (specifier.symbol);
	Close ();
}

void Context::Serialize (const MemberDeclarators& declarators)
{
	Open ("member-declarator-list");
	for (auto& declarator: declarators) Serialize (declarator);
	Close ();
}

void Context::Serialize (const MemberDeclarator& declarator)
{
	Open ("member-declarator");
	if (declarator.declarator) Serialize (*declarator.declarator);
	if (declarator.virtualSpecifiers) Serialize (*declarator.virtualSpecifiers);
	if (declarator.initializer) Serialize (*declarator.initializer);
	if (declarator.expression) Serialize (*declarator.expression);
	Close ();
}

void Context::Serialize (const InitDeclarators& declarators)
{
	Open ("init-declarator-list");
	for (auto& declarator: declarators) Serialize (declarator);
	Close ();
}

void Context::Serialize (const InitDeclarator& declarator)
{
	Open ("init-declarator");
	if (declarator.entity) Attribute (*declarator.entity);
	Serialize (*declarator.declarator);
	if (declarator.initializer) Serialize (*declarator.initializer);
	Close ();
}

void Context::Serialize (const Declarator& declarator)
{
	Open ("declarator");
	Attribute (declarator.location);
	Attribute ("type", declarator.type);

	switch (declarator.model)
	{
	case Declarator::Name:
		Open ("declarator-id");
		if (declarator.name.isPacked) Serialize (Lexer::Ellipsis);
		if (declarator.name.identifier) Open ("id-expression"), Attribute (*declarator.name.entity), Serialize (*declarator.name.identifier), Close ();
		if (declarator.name.attributes) Serialize (*declarator.name.attributes);
		Close ();
		break;

	case Declarator::Array:
		Open ("array-declarator");
		if (declarator.array.declarator) Serialize (*declarator.array.declarator);
		if (declarator.array.expression) Serialize (*declarator.array.expression);
		Close ();
		break;

	case Declarator::Pointer:
		Open ("ptr-declarator"); Open ("ptr-operator"); Serialize (Lexer::Asterisk);
		if (declarator.pointer.attributes) Serialize (*declarator.pointer.attributes);
		if (declarator.pointer.qualifiers) Serialize (*declarator.pointer.qualifiers);
		Close ();
		if (declarator.pointer.declarator) Serialize (*declarator.pointer.declarator);
		Close ();
		break;

	case Declarator::Function:
		Open ("function-declarator");
		if (declarator.function.declarator) Serialize (*declarator.function.declarator);
		Serialize (*declarator.function.prototype);
		Close ();
		break;

	case Declarator::Reference:
		Open ("ptr-declarator"); Open ("ptr-operator");
		Serialize (declarator.reference.isRValue ? Lexer::DoubleAmpersand : Lexer::Ampersand);
		if (declarator.reference.attributes) Serialize (*declarator.reference.attributes);
		Close ();
		if (declarator.reference.declarator) Serialize (*declarator.reference.declarator);
		Close ();
		break;

	case Declarator::MemberPointer:
		Open ("ptr-declarator"); Open ("ptr-operator");
		Serialize (*declarator.memberPointer.specifier);
		Serialize (Lexer::Asterisk);
		if (declarator.memberPointer.attributes) Serialize (*declarator.memberPointer.attributes);
		if (declarator.memberPointer.qualifiers) Serialize (*declarator.memberPointer.qualifiers);
		Close ();
		if (declarator.memberPointer.declarator) Serialize (*declarator.memberPointer.declarator);
		Close ();
		break;

	case Declarator::Parenthesized:
		Open ("parenthesized-declarator");
		Serialize (*declarator.parenthesized.declarator);
		Close ();
		break;

	default:
		assert (Declarator::Unreachable);
	}

	Close ();
}

void Context::Serialize (const FunctionPrototype& prototype)
{
	Open ("parameters-and-qualifiers");
	Serialize (prototype.parameterDeclarations);
	if (prototype.constVolatileQualifiers) Serialize (*prototype.constVolatileQualifiers);
	if (prototype.referenceQualifier) Serialize (*prototype.referenceQualifier);
	if (prototype.noexceptSpecifier) Serialize (*prototype.noexceptSpecifier);
	if (prototype.attributes) Serialize (*prototype.attributes);
	Close ();
	if (prototype.trailingReturnType) Open ("trailing-return-type"), Serialize (*prototype.trailingReturnType), Close ();
}

void Context::Serialize (const ParameterDeclarations& declarations)
{
	Open ("parameter-declaration-clause");
	if (!declarations.empty ()) Open ("parameter-declaration-list");
	for (auto& declaration: declarations) Serialize (declaration);
	if (!declarations.empty ()) Close ();
	if (declarations.isPacked) Serialize (Lexer::Ellipsis);
	Close ();
}

void Context::Serialize (const ParameterDeclaration& declaration)
{
	Open ("parameter-declaration");
	Attribute (declaration.location);
	Attribute ("type", declaration.type);
	if (declaration.entity) Attribute (*declaration.entity);
	if (declaration.attributes) Serialize (*declaration.attributes);
	Serialize (declaration.specifiers);
	if (declaration.declarator) Serialize (*declaration.declarator);
	if (declaration.initializer) Serialize (*declaration.initializer);
	Close ();
}

void Context::Serialize (const ReferenceQualifier& qualifier)
{
	Open ("ref-qualifier");
	Serialize (qualifier.symbol);
	Close ();
}

void Context::Serialize (const ConstVolatileQualifiers& qualifiers)
{
	Open ("cv-qualifier-seq");
	if (qualifiers.isConst) Open ("cv-qualifier"), Serialize (Lexer::Const), Close ();
	if (qualifiers.isVolatile) Open ("cv-qualifier"), Serialize (Lexer::Volatile), Close ();
	Close ();
}

void Context::Serialize (const VirtualSpecifiers& specifiers)
{
	Open ("virt-specifier-seq");
	if (specifiers.final) Open ("virt-specifier"), Open ("final"), Close (), Close ();
	if (specifiers.override) Open ("virt-specifier"), Open ("override"), Close (), Close ();
	Close ();
}

void Context::Serialize (const FunctionBody& body)
{
	Open ("function-body");
	Attribute (body.location);

	switch (body.model)
	{
	case FunctionBody::Try:
		Open ("function-try-block");
		if (body.try_.initializers) Serialize (*body.try_.initializers);
		Serialize (*body.try_.block);
		Serialize (*body.try_.handlers);
		Close ();
		break;

	case FunctionBody::Delete:
		Serialize (Lexer::Delete);
		break;

	case FunctionBody::Default:
		Serialize (Lexer::Default);
		break;

	case FunctionBody::Regular:
		if (body.regular.initializers) Serialize (*body.regular.initializers);
		Serialize (*body.regular.block);
		break;

	default:
		assert (FunctionBody::Unreachable);
	}

	Close ();
}

void Context::Serialize (const MemberInitializers& initializers)
{
	Open ("ctor-initializer");
	Open ("mem-initializer-list");
	for (auto& initializer: initializers) Serialize (initializer);
	Close (); Close ();
}

void Context::Serialize (const MemberInitializer& initializer)
{
	Open ("mem-initializer");
	Serialize (initializer.specifier);
	Serialize (initializer.initializer);
	Close ();
}

void Context::Serialize (const StatementBlock& block)
{
	Open ("compound-statement");
	if (!block.statements.empty ()) Open ("statement-seq"), Serialize (block.statements), Close ();
	Close ();
}

void Context::Serialize (const Statements& statements)
{
	Size labeledStatements = 0;
	for (auto& statement: statements)
		if (Serialize (statement), IsLabeled (statement)) ++labeledStatements;
		else while (labeledStatements) Close (), Close (), --labeledStatements;
}

void Context::Serialize (const Substatement& statement)
{
	if (!statement.isCompound) return Serialize (statement.statements);
	Open ("statement");
	Attribute (statement.location);
	if (statement.attributes) Serialize (*statement.attributes);
	Serialize (static_cast<const StatementBlock&> (statement));
	Close ();
}

void Context::Serialize (const Statement& statement)
{
	Open ("statement");
	Attribute (statement.location);
	if (HasLikelihood (statement)) Attribute ("likelihood", *statement.likelihood->name->name.identifier);
	if (statement.attributes) Serialize (*statement.attributes);

	switch (statement.model)
	{
	case Statement::Do:
		Open ("do-statement");
		Serialize (*statement.do_.statement);
		Serialize (*statement.do_.condition);
		Close ();
		break;

	case Statement::If:
		Open ("if-statement");
		if (statement.if_.isConstexpr) Serialize (Lexer::Constexpr);
		Serialize (statement.if_.condition);
		Serialize (*statement.if_.statement);
		if (statement.if_.elseStatement) Serialize (*statement.if_.elseStatement);
		Close ();
		break;

	case Statement::For:
		Open ("for-statement");
		Serialize (*statement.for_.initStatement);
		if (statement.for_.condition) Serialize (*statement.for_.condition);
		if (statement.for_.expression) Serialize (*statement.for_.expression);
		Serialize (*statement.for_.statement);
		Close ();
		break;

	case Statement::Try:
		Open ("try-block");
		Serialize (*statement.try_.block);
		Serialize (*statement.try_.handlers);
		Close ();
		break;

	case Statement::Case:
		Open ("case-statement");
		Serialize (*statement.case_.label);
		return;

	case Statement::Goto:
		Open ("goto-statement");
		Serialize (*statement.goto_.identifier);
		Close ();
		break;

	case Statement::Null:
		Open ("expression-statement");
		Close ();
		break;

	case Statement::Break:
		Open ("break-statement");
		Close ();
		break;

	case Statement::Label:
		Open ("labeled-statement");
		Serialize (*statement.label.identifier);
		return;

	case Statement::While:
		Open ("while-statement");
		Serialize (statement.while_.condition);
		Serialize (*statement.while_.statement);
		Close ();
		break;

	case Statement::Return:
		Open ("return-statement");
		if (statement.return_.expression) Serialize (*statement.return_.expression);
		Close ();
		break;

	case Statement::Switch:
		Open ("switch-statement");
		Serialize (statement.switch_.condition);
		Serialize (*statement.switch_.statement);
		Close ();
		break;

	case Statement::Default:
		Open ("default-statement");
		return;

	case Statement::Compound:
		Serialize (*statement.compound.block);
		break;

	case Statement::Continue:
		Open ("continue-statement");
		Close ();
		break;

	case Statement::CoReturn:
		Open ("coroutine-return-statement");
		if (statement.coReturn.expression) Serialize (*statement.coReturn.expression);
		Close ();
		break;

	case Statement::Expression:
		Open ("expression-statement");
		Serialize (*statement.expression);
		Close ();
		break;

	case Statement::Declaration:
		Open ("declaration-statement");
		Serialize (*statement.declaration);
		Close ();
		break;

	default:
		assert (Statement::Unreachable);
	}

	Close ();
}

void Context::Serialize (const Condition& condition)
{
	Open ("condition");
	if (condition.declaration) Serialize (*condition.declaration); else Serialize (*condition.expression);
	Close ();
}

void Context::Serialize (const Initializer& initializer)
{
	Open ("initializer");
	Attribute (initializer.location);

	if (initializer.assignment) Open ("equal-initializer");
	else if (initializer.braced) Open ("brace-initializer");
	else Open ("parenthesized-initializer");

	if (initializer.braced) SerializeInitializer (initializer.expressions);
	else if (initializer.assignment) Serialize (initializer.expressions.front ());
	else if (!initializer.expressions.empty ()) Serialize (initializer.expressions);

	Close (); Close ();
}

void Context::SerializeInitializer (const Expressions& expressions)
{
	Open ("initializer-clause");
	for (auto& expression: expressions) Serialize (expression);
	Close ();
}

void Context::Serialize (const TypeIdentifier& identifier)
{
	Open ("type-id");
	if (!IsDependent (identifier.type)) Attribute ("type", identifier.type);
	Serialize (identifier.specifiers);
	if (identifier.declarator) Serialize (*identifier.declarator);
	Close ();
}

void Context::Serialize (const Lexer::Symbol symbol)
{
	switch (symbol)
	{
	case Lexer::Ellipsis: Open ("ellipsis"); break;
	case Lexer::DoubleColon: Open ("global"); break;
	case Lexer::Ampersand: case Lexer::Bitand: Open ("lvalue-reference"); break;
	case Lexer::DoubleAmpersand: case Lexer::And: Open ("rvalue-reference"); break;
	case Lexer::Asterisk: Open ("pointer"); break;
	default: std::ostringstream stream; stream << symbol; Open (stream.str ().c_str ());
	}
	Close ();
}

void Context::Serialize (const Lexer::Token& token)
{
	std::ostringstream stream; Lexer::Write (stream, token);
	Open ("token"); Attribute (token.location); Write (stream.str ()); Close ();
}

void Context::Serialize (const TypeSpecifiers& specifiers)
{
	Open ("type-specifier-seq");
	if (!IsDependent (specifiers.type)) Attribute ("type", specifiers.type);
	for (auto& specifier: specifiers) Serialize (specifier);
	if (specifiers.attributes) Serialize (*specifiers.attributes);
	Close ();
}

void Context::SerializeEnumBase (const TypeSpecifiers& specifiers)
{
	Open ("enum-base");
	Attribute ("type", specifiers.type);
	Serialize (specifiers);
	Close ();
}

void Context::Serialize (const TypeSpecifier& specifier)
{
	Open ("type-specifier");
	Attribute (specifier.location);

	switch (specifier.model)
	{
	case TypeSpecifier::Enum:
		Open ("enum-specifier");
		Attribute ("elaborated", !specifier.enum_.isDefinition);
		Serialize (specifier.enum_.head);
		if (specifier.enum_.enumerators) Serialize (*specifier.enum_.enumerators);
		Close ();
		break;

	case TypeSpecifier::Class:
		Open ("class-specifier");
		Attribute ("elaborated", !specifier.class_.isDefinition);
		Serialize (specifier.class_.head);
		if (specifier.class_.members) Serialize (*specifier.class_.members);
		Close ();
		break;

	case TypeSpecifier::Simple:
		Open ("simple-type-specifier");
		Serialize (specifier.simple.type);
		Close ();
		break;

	case TypeSpecifier::Decltype:
		Open ("simple-type-specifier");
		Serialize (specifier.decltype_.specifier);
		Close ();
		break;

	case TypeSpecifier::Typename:
		Open ("typename-specifier");
		Serialize (*specifier.typename_.identifier);
		Close ();
		break;

	case TypeSpecifier::TypeName:
		Open ("simple-type-specifier"); Open ("type-name");
		Serialize (*specifier.typeName.identifier);
		Close (); Close ();
		break;

	case TypeSpecifier::ConstVolatileQualifier:
		Open ("cv-qualifier");
		Serialize (specifier.constVolatile.qualifier);
		Close ();
		break;

	default:
		assert (TypeSpecifier::Unreachable);
	}

	Close ();
}

void Context::Serialize (const DecltypeSpecifier& specifier)
{
	Open ("decltype-specifier");
	if (specifier.expression) Serialize (*specifier.expression); else Serialize (Lexer::Auto);
	Close ();
}

void Context::Serialize (const EnumeratorDefinition& definition)
{
	Open ("enumerator-definition");
	Attribute (*definition.enumerator->entity);
	Attribute ("value", definition.enumerator->value);
	Serialize (definition.identifier);
	if (definition.attributes) Serialize (*definition.attributes);
	if (definition.expression) Serialize (*definition.expression);
	Close ();
}

void Context::Serialize (const EnumeratorDefinitions& definitions)
{
	Open ("enumerator-list");
	for (auto& definition: definitions) Serialize (definition);
	Close ();
}

void Context::Serialize (const struct Attribute& attribute)
{
	Open ("attribute");
	if (attribute.namespace_) Open ("attribute-scoped-token"), Serialize (*attribute.namespace_); else Open ("attribute-token");
	Serialize (*attribute.name); Close ();

	switch (attribute.model)
	{
	case Attribute::Unspecified:
		if (!attribute.unspecified.tokens) break;
		Open ("attribute-argument-clause");
		for (auto& token: *attribute.unspecified.tokens) Serialize (token);
		Close ();
		break;

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
		break;

	case Attribute::Deprecated:
	case Attribute::Nodiscard:
	case Attribute::Alias:
	case Attribute::Group:
		if (!attribute.deprecated.stringLiteral) break;
		Open ("attribute-argument-clause");
		Serialize (*attribute.deprecated.stringLiteral);
		Close ();
		break;

	case Attribute::Origin:
		Open ("attribute-argument-clause");
		Serialize (*attribute.origin.expression);
		Close ();
		break;

	default:
		assert (Attribute::Unreachable);
	}

	Close ();
}

void Context::Serialize (const NoexceptSpecifier& noexceptSpecifier)
{
	Open ("noexcept-specifier");
	Attribute (noexceptSpecifier.location);
	if (noexceptSpecifier.expression) Serialize (*noexceptSpecifier.expression);
	if (noexceptSpecifier.throw_) Serialize (Lexer::Throw);
	Close ();
}

void Context::Serialize (const Expression& expression)
{
	if (IsInlinedFunctionCall (expression)) return Serialize (*expression.inlinedFunctionCall.expression);

	Open ("expression");
	Attribute (expression.location);
	Attribute ("type", expression.type);
	Attribute ("category", expression.category);
	if (IsConstant (expression)) Attribute ("value", expression.value);

	switch (expression.model)
	{
	case Expression::New:
		Open ("new-expression");
		if (expression.new_.qualified) Serialize (Lexer::DoubleColon);
		if (expression.new_.placement) Serialize (*expression.new_.placement);
		Serialize (*expression.new_.typeIdentifier);
		if (expression.new_.initializer) Serialize (*expression.new_.initializer);
		Close ();
		break;

	case Expression::Cast:
		Open ("cast-expression");
		Serialize (*expression.cast.typeIdentifier);
		Serialize (*expression.cast.expression);
		Close ();
		break;

	case Expression::This:
		Open ("this");
		Close ();
		break;

	case Expression::Comma:
		Open ("binary-expression");
		Serialize (*expression.comma.left);
		Serialize (Operator {Lexer::Comma, false});
		Serialize (*expression.comma.right);
		Close ();
		break;

	case Expression::Throw:
		Open ("throw-expression");
		if (expression.throw_.expression) Serialize (*expression.throw_.expression);
		Close ();
		break;

	case Expression::Unary:
		Open ("unary-expression");
		Serialize (expression.unary.operator_);
		Serialize (*expression.unary.operand);
		Close ();
		break;

	case Expression::Binary:
		Open ("binary-expression");
		Serialize (*expression.binary.left);
		Serialize (expression.binary.operator_);
		Serialize (*expression.binary.right);
		Close ();
		break;

	case Expression::Delete:
		Open ("delete-expression");
		if (expression.delete_.qualified) Serialize (Lexer::DoubleColon);
		if (expression.delete_.expression) Serialize (*expression.delete_.expression);
		Close ();
		break;

	case Expression::Lambda:
		Open ("lambda-expression");
		Open ("lambda-capture");
		if (expression.lambda.default_) Open ("capture-default"), Write (*expression.lambda.default_), Close ();
		if (expression.lambda.captures) Serialize (*expression.lambda.captures);
		Close ();
		if (expression.lambda.declarator) Serialize (*expression.lambda.declarator);
		Serialize (*expression.lambda.block);
		Close ();
		break;

	case Expression::Prefix:
		Open ("prefix-expression");
		Serialize (expression.prefix.operator_);
		Serialize (*expression.prefix.expression);
		Close ();
		break;

	case Expression::Alignof:
		Open ("alignof-expression");
		Serialize (*expression.alignof_.typeIdentifier);
		Close ();
		break;

	case Expression::Literal:
	{
		std::ostringstream stream; Lexer::Write (stream, expression.literal.token);
		Open ("literal"); if (IsLiteral (expression.literal.token.symbol) && expression.literal.token.suffix) Attribute ("suffix", *expression.literal.token.suffix); Write (stream.str ()); Close ();
		break;
	}

	case Expression::Postfix:
		Open ("postfix-expression");
		Serialize (*expression.postfix.expression);
		Serialize (expression.postfix.operator_);
		Close ();
		break;

	case Expression::Noexcept:
		Open ("noexcept-expression");
		Serialize (*expression.noexcept_.expression);
		Close ();
		break;

	case Expression::Addressof:
		Open ("unary-expression");
		Serialize (Operator {Lexer::Ampersand, false});
		Serialize (*expression.addressof.expression);
		Close ();
		break;

	case Expression::ConstCast:
		Open ("const-cast-expression");
		Serialize (*expression.cast.typeIdentifier);
		Serialize (*expression.cast.expression);
		Close ();
		break;

	case Expression::Subscript:
		Open ("subscript-expression");
		Serialize (*expression.subscript.left);
		Serialize (*expression.subscript.right);
		Close ();
		break;

	case Expression::Typetrait:
		Open ("typetrait-expression");
		Serialize (*expression.typetrait.stringLiteral);
		Serialize (*expression.typetrait.typeIdentifier);
		Close ();
		break;

	case Expression::Assignment:
		Open ("binary-expression");
		Serialize (*expression.assignment.left);
		Serialize (expression.assignment.operator_);
		Serialize (*expression.assignment.right);
		Close ();
		break;

	case Expression::Conversion:
		Open ("conversion-expression");
		Attribute ("conversion", expression.conversion.model);
		Serialize (*expression.conversion.expression);
		Close ();
		break;

	case Expression::Identifier:
		Open ("id-expression");
		Attribute (*expression.identifier.entity);
		Serialize (*expression.identifier.identifier);
		Close ();
		break;

	case Expression::SizeofPack:
		Open ("sizeof-expression");
		Serialize (*expression.sizeofPack.identifier);
		Close ();
		break;

	case Expression::SizeofType:
		Open ("sizeof-expression");
		Serialize (*expression.sizeofType.typeIdentifier);
		Close ();
		break;

	case Expression::StaticCast:
		Open ("static-cast-expression");
		Serialize (*expression.cast.typeIdentifier);
		Serialize (*expression.cast.expression);
		Close ();
		break;

	case Expression::TypeidType:
		Open ("typeid-expression");
		Serialize (*expression.typeidType.typeIdentifier);
		Close ();
		break;

	case Expression::Conditional:
		Open ("conditional-expression");
		Serialize (*expression.conditional.condition);
		Serialize (*expression.conditional.left);
		Serialize (*expression.conditional.right);
		Close ();
		break;

	case Expression::DynamicCast:
		Open ("dynamic-cast-expression");
		Serialize (*expression.cast.typeIdentifier);
		Serialize (*expression.cast.expression);
		Close ();
		break;

	case Expression::Indirection:
		Open ("unary-expression");
		Serialize (Operator {Lexer::Asterisk, false});
		Serialize (*expression.indirection.expression);
		Close ();
		break;

	case Expression::FunctionCall:
		Open ("function-call");
		if (expression.functionCall.function) Attribute (*expression.functionCall.function->entity);
		Serialize (*expression.functionCall.expression);
		if (expression.functionCall.arguments) Serialize (*expression.functionCall.arguments);
		Close ();
		break;

	case Expression::MemberAccess:
		Open ("member-access");
		Attribute (*expression.memberAccess.entity);
		Serialize (*expression.memberAccess.expression);
		Open ("operator"); Write (expression.memberAccess.symbol); Close ();
		if (expression.memberAccess.isTemplate) Serialize (Lexer::Template);
		Serialize (*expression.memberAccess.identifier);
		Close ();
		break;

	case Expression::Parenthesized:
		Open ("parenthesized-expression");
		Serialize (*expression.parenthesized.expression);
		Close ();
		break;

	case Expression::StringLiteral:
		Serialize (*expression.stringLiteral);
		break;

	case Expression::ConstructorCall:
		Open ("constructor-call");
		Serialize (*expression.constructorCall.specifier);
		if (expression.constructorCall.expressions) Serialize (*expression.constructorCall.expressions);
		Close ();
		break;

	case Expression::ReinterpretCast:
		Open ("reinterpret-cast-expression");
		Serialize (*expression.cast.typeIdentifier);
		Serialize (*expression.cast.expression);
		Close ();
		break;

	case Expression::SizeofExpression:
		Open ("sizeof-expression");
		Serialize (*expression.sizeofExpression.expression);
		Close ();
		break;

	case Expression::TypeidExpression:
		Open ("typeid-expression");
		Serialize (*expression.typeidExpression.expression);
		Close ();
		break;

	case Expression::MemberIndirection:
		Open ("pm-expression");
		Serialize (*expression.memberIndirection.expression);
		Open ("operator"); Write (expression.memberIndirection.symbol); Close ();
		Serialize (*expression.memberIndirection.member);
		Close ();
		break;

	case Expression::BracedConstructorCall:
		Open ("braced-constructor-call");
		Serialize (*expression.bracedConstructorCall.specifier);
		Serialize (*expression.bracedConstructorCall.expression);
		Close ();
		break;

	default:
		assert (Expression::Unreachable);
	}

	Close ();
}

void Context::Serialize (const Captures& captures)
{
	Open ("capture-list");
	for (auto& capture: captures) Serialize (capture);
	Close ();
}

void Context::Serialize (const Capture& capture)
{
	Open ("capture");
	if (capture.byReference) Serialize (Lexer::Ampersand);
	if (capture.identifier) Serialize (*capture.identifier); else Serialize (Lexer::This);
	if (capture.initializer) Serialize (*capture.initializer);
	Close ();
}

void Context::Serialize (const LambdaDeclarator& declarator)
{
	Open ("lambda-declarator");
	Serialize (declarator.parameterDeclarations);
	if (declarator.specifiers) Serialize (*declarator.specifiers);
	if (declarator.noexceptSpecifier) Serialize (*declarator.noexceptSpecifier);
	if (declarator.attributes) Serialize (*declarator.attributes);
	if (declarator.trailingReturnType) Open ("trailing-return-type"), Serialize (*declarator.trailingReturnType), Close ();
	Close ();
}

void Context::Serialize (const Expressions& expressions)
{
	Open ("expression-list");
	for (auto& expression: expressions) Serialize (expression);
	Close ();
}

void Context::Serialize (const Operator& operator_)
{
	Open ("operator");
	Write (operator_);
	Close ();
}

void Context::Serialize (const StringLiteral& literal)
{
	for (auto& token: literal.tokens) SerializeStringLiteral (token);
}

void Context::SerializeStringLiteral (const Lexer::Token& token)
{
	Open ("string-literal");
	Attribute (token.location);
	std::ostringstream stream;
	for (auto character: *token.literal) Lexer::Write (stream, character);
	Write (stream.str ());
	Close ();
}

void Context::Serialize (const TemplateParameters& parameters)
{
	Open ("template-parameter-list");
	for (auto& parameter: parameters) Serialize (parameter);
	Close ();
}

void Context::Serialize (const TemplateParameter& parameter)
{
	Open ("template-parameter");
	Attribute (parameter.location);

	switch (parameter.model)
	{
	case TemplateParameter::Type:
		Open ("type-parameter");
		Serialize (parameter.type.key);
		if (parameter.type.isPacked) Serialize (Lexer::Ellipsis);
		if (parameter.type.identifier) Serialize (*parameter.type.identifier);
		if (parameter.type.default_) Serialize (*parameter.type.default_);
		Close ();
		break;

	case TemplateParameter::Template:
		Open ("type-parameter");
		Serialize (Lexer::Template);
		Serialize (*parameter.template_.parameters);
		Serialize (parameter.template_.key);
		if (parameter.template_.identifier) Serialize (*parameter.template_.identifier);
		if (parameter.template_.default_) Serialize (*parameter.template_.default_);
		Close ();
		break;

	case TemplateParameter::Declaration:
		Serialize (*parameter.declaration);
		break;

	default:
		assert (TemplateParameter::Unreachable);
	}

	Close ();
}

void Context::Serialize (const TypeParameterKey& key)
{
	Open ("type-parameter-key");
	Serialize (key.symbol);
	Close ();
}

void Context::Serialize (const TemplateArguments& arguments)
{
	Open ("template-argument-list");
	for (auto& argument: arguments) Serialize (argument);
	Close ();
}

void Context::Serialize (const TemplateArgument& argument)
{
	Open ("template-argument");
	Attribute (argument.location);

	switch (argument.model)
	{
	case TemplateArgument::Expression:
		Serialize (*argument.expression);
		break;

	case TemplateArgument::TypeIdentifier:
		Serialize (*argument.typeIdentifier);
		break;

	default:
		assert (TemplateArgument::Unreachable);
	}

	Close ();
}

void Context::Serialize (const ExceptionHandlers& handlers)
{
	Open ("handler-seq");
	for (auto& handler: handlers) Serialize (handler);
	Close ();
}

void Context::Serialize (const ExceptionHandler& handler)
{
	Open ("handler");
	Serialize (handler.declaration);
	Serialize (handler.block);
	Close ();
}

void Context::Serialize (const ExceptionDeclaration& declaration)
{
	Open ("exception-declaration");
	if (declaration.attributes) Serialize (*declaration.attributes);
	if (declaration.specifiers.empty ()) Serialize (Lexer::Ellipsis); else Serialize (declaration.specifiers);
	if (declaration.declarator) Serialize (*declaration.declarator);
	Close ();
}

void Context::Attribute (const Entity& entity)
{
	Attribute ("entity", entity);
}

void Context::Attribute (const Location& location)
{
	if (location.source != &translationUnit.source) Attribute ("source", *location.source);
	Attribute (location.position);
}

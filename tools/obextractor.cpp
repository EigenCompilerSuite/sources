// Oberon generic documentation extractor
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

#include "docextractor.hpp"
#include "indenter.hpp"
#include "oberon.hpp"
#include "obextractor.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace Oberon;
using namespace Documentation;

using Context = class Oberon::Extractor::Context : Documentation::Extractor, BasicIndenter<Text, TextStyle>
{
public:
	Context (const Oberon::Extractor&, const Module&, Document&);

	void Extract ();

private:
	const Module& module;
	std::vector<const Module*> imports;
	std::map<Text, std::vector<const Declaration*>> topics;
	Tags moduleTags;

	void Extract (const Declaration&, Level);
	void Extract (const Type&, const Scope&);

	Article& Write (Article&, const Declaration&, const Declaration&, Tags&);
	Article& Write (Article&, const Signature&, Tags&);
	Text& Write (Text&, const Declaration&, const Declaration*);
	Text& Write (Text&, const Declaration&, const Scope*);
	Text& Write (Text&, const Declarations&);
	Text& Write (Text&, const Expression&);
	Text& Write (Text&, const QualifiedIdentifier&);
	Text& Write (Text&, const QualifiedIdentifier&, const Scope*);
	Text& Write (Text&, const Scope&, const Scope*);
	Text& Write (Text&, const Signature&, const Declaration*);
	Text& Write (Text&, const Type&, bool);
	Text& Write (Text&, const Type&);
	Text& Write (Text&, const Value&);
	void Write (Text&, const Signature&, const Declaration&, Article&, Tags&);

	void Import (Article&);
	Text& Define (Article&);
	Text& Comment (Text&, const Type&);
	Article& Summarize (Article&, const Scope&);

	void End (Article&, Tags&);
	Article& Begin (Article&, const Module&, Tags&);
	Article& Begin (Article&, const Word&, const char*, const Oberon::Annotation&, Tags&);
	Text& Begin (Article&, const Declaration&, const char*, const char*, Tags&);

	static constexpr auto TopicTag = "topic";
	static constexpr auto ResultTag = "result";
	static constexpr auto RemarksTag = "remarks";

	static bool IsDeclaration (const Expression&);

	static Word GetName (const Declaration&, bool);
	static Word GetName (const Declaration&, const Declaration&);
	static Word GetName (const QualifiedIdentifier&, bool);
	static Word GetName (const Scope&, bool);
};

Oberon::Extractor::Extractor (Diagnostics& d) :
	diagnostics {d}
{
}

void Oberon::Extractor::Extract (const Module& module, Document& document) const
{
	Context {*this, module, document}.Extract ();
}

Context::Context (const Oberon::Extractor& e, const Module& m, Document& d) :
	Extractor {e.diagnostics, d}, BasicIndenter {Tab, 1}, module {m}
{
}

void Context::Extract ()
{
	Merge (module.documentation.string, module.source, module.documentation.position);
	End (Summarize (Begin (Add ({1, GetName (*module.scope, true)}), module, moduleTags), *module.scope), moduleTags);
}

void Context::Extract (const Declaration& declaration, const Level level)
{
	if (!IsExported (declaration)) return;

	auto& article = Add ({level + 1, GetName (declaration, true)}); Tags tags;

	switch (declaration.model)
	{
	case Declaration::Constant:
		Comment (Begin (article, declaration, "Constant", "Constants", tags) << Lexer::Const << Space << declaration.name.string << Lexer::Asterisk << Space << Lexer::Equal << Space, *declaration.constant.expression->type) << Lexer::Semicolon;
		break;

	case Declaration::Type:
		if (IsRecord (declaration))
			Write (Begin (article, declaration, "Record Type", "Types", tags) << Lexer::Type << Space << declaration.name.string << Lexer::Asterisk << Space << Lexer::Equal << Space, *declaration.type, true) << Lexer::Semicolon, Summarize (article, *declaration.type->record.scope);
		else if (IsProcedureType (declaration))
			Write (Begin (Write (article, declaration.type->procedure.signature, tags), declaration, "Procedure Type", "Types", tags) << Lexer::Type << Space << declaration.name.string << Lexer::Asterisk << Space << Lexer::Equal << Space << Lexer::Procedure, declaration.type->procedure.signature, declaration, article, tags);
		else if (IsGenericParameter (declaration))
			Comment (Begin (article, declaration, "Parameter", "Parameters", moduleTags) << declaration.name.string << Lexer::Asterisk << Space << Lexer::Equal << Space, *declaration.type) << Lexer::Semicolon;
		else
			Write (Begin (article, declaration, "Type Alias", "Types", tags) << Lexer::Type << Space << declaration.name.string << Lexer::Asterisk << Space << Lexer::Equal << Space, *declaration.type) << Lexer::Semicolon;
		break;

	case Declaration::Variable:
	{
		auto& text = IsField (declaration) ? Begin (article, declaration, "Field", "Fields", tags) : Begin (article, declaration, "Variable", "Variables", tags) << Lexer::Var << Space;
		Write (text << declaration.name.string << (declaration.variable.isReadOnly ? Lexer::Minus : Lexer::Asterisk) << Lexer::Colon << Space, *declaration.variable.type) << Lexer::Semicolon;
		break;
	}

	case Declaration::Procedure:
	{
		auto& text = Begin (Write (article, declaration.procedure.signature, tags), declaration, "Procedure", "Procedures", tags) << Lexer::Procedure;
		if (IsAbstract (declaration)) text << Lexer::Asterisk; else if (IsFinal (declaration)) text << Lexer::Minus;
		if (declaration.procedure.signature.receiver) Write (text << Space << Lexer::LeftParen, *declaration.procedure.signature.receiver, &declaration) << Lexer::RightParen;
		Write (text << Space << declaration.name.string << Lexer::Asterisk, declaration.procedure.signature, declaration, article, tags);
		break;
	}

	default:
		assert (Declaration::Unreachable);
	}

	End (article, tags);
}

Text& Context::Write (Text& text, const Scope& scope, const Scope*const sentinel)
{
	if (IsGlobal (scope)) return Write (text, *scope.identifier);
	if (IsProcedure (scope)) return Write (text, *scope.procedure, sentinel);
	if (IsRecord (scope)) return assert (scope.record->record.declaration), Write (text, *scope.record->record.declaration, sentinel);
	assert (IsModule (scope)); if (scope.module != &module) InsertUnique (scope.module, imports);
	text << TextElement {WeakLink, GetName (scope.module->identifier, true), scope.module->identifier.name->string}; if (!IsParameterized (*scope.module)) return text; text << Lexer::LeftParen;
	if (IsParameterized (*scope.module)) for (auto& expression: *scope.module->expressions) Write (IsFirst (expression, *scope.module->expressions) ? text : text << Lexer::Comma, expression);
	return text << Lexer::RightParen;
}

Text& Context::Write (Text& text, const Declaration& declaration, const Scope*const sentinel)
{
	if (IsImport (declaration)) return Write (text, *declaration.import.scope, sentinel);
	if (IsType (declaration) && !IsExported (declaration) && IsReachable (*declaration.type)) return Write (text, *declaration.type->record.baseType->identifier, sentinel);
	if (declaration.scope != sentinel) Write (text, *declaration.scope, sentinel) << Lexer::Dot;
	return IsExported (declaration) ? text << TextElement {WeakLink, GetName (declaration, true), declaration.name.string} : text << declaration.name.string;
}

Text& Context::Write (Text& text, const Declarations& declarations)
{
	for (auto& declaration: declarations) if (Write (IsFirst (declaration, declarations) ? text : text << Lexer::Comma << Space, declaration, declaration.scope), IsExported (declaration)) text << Lexer::Asterisk; return text;
}

Text& Context::Write (Text& text, const QualifiedIdentifier& identifier)
{
	assert (identifier.name); if (identifier.parent) Write (text, *identifier.parent) << Lexer::Dot; return text << identifier.name->string;
}

Text& Context::Write (Text& text, const QualifiedIdentifier& identifier, const Scope*const sentinel)
{
	return IsPredeclared (*identifier.declaration) ? Write (text, identifier) : Write (text, *identifier.declaration, sentinel);
}

Text& Context::Write (Text& text, const Type& type)
{
	if (IsAlias (type)) return Write (text, *type.identifier, module.scope);

	switch (type.model)
	{
	case Type::Array:
		text << Lexer::Array << Space;
		if (type.array.length) if (IsDeclaration (*type.array.length)) Write (text, *type.array.length) << Space; else Comment (text, *type.array.length->type) << Space;
		return Write (text << Lexer::Of << Space, *type.array.elementType);

	case Type::Record:
		return Write (text, type, false);

	case Type::Pointer:
		text << Lexer::Pointer << Space << Lexer::To << Space;
		if (type.pointer.isVariable) text << Lexer::Var << Space;
		if (type.pointer.isReadOnly) text << Lexer::Minus << Space;
		return Write (text, *type.pointer.baseType);

	case Type::Procedure:
		return Write (text << Lexer::Procedure, type.procedure.signature, nullptr);

	default:
		assert (Type::Unreachable);
	}
}

Text& Context::Comment (Text& text, const Type& type)
{
	return Write (text << Lexer::LeftParen << Lexer::Asterisk << Space, type) << Space << Lexer::Asterisk << Lexer::RightParen;
}

Text& Context::Write (Text& text, const Expression& expression)
{
	if (IsPromotion (expression)) return Write (text, *expression.promotion.expression);
	if (IsIdentifier (expression) && IsExported (*expression.identifier.declaration)) return Write (text, expression.identifier, module.scope);
	if (IsParenthesized (expression)) return Write (text, *expression.parenthesized.expression);
	return Write (text, expression.value);
}

bool Context::IsDeclaration (const Expression& expression)
{
	if (IsPromotion (expression)) return IsDeclaration (*expression.promotion.expression);
	if (IsIdentifier (expression)) return IsExported (*expression.identifier.declaration);
	if (IsParenthesized (expression)) return IsDeclaration (*expression.parenthesized.expression);
	return false;
}

Text& Context::Write (Text& text, const Value& value)
{
	if (IsProcedure (value)) return Write (text, *value.procedure, module.scope);
	if (IsModule (value)) return Write (text, *value.module, module.scope);
	if (IsType (value)) return Write (text, *value.type);
	return text << value;
}

Text& Context::Write (Text& text, const Type& type, const bool linkVariables)
{
	assert (IsRecord (type)); Increase (text) << Lexer::Record; auto hasVariables = false;
	if (IsAbstract (type)) text << Lexer::Asterisk; else if (IsFinal (type)) text << Lexer::Minus;
	if (type.record.baseType) Write (text << Space << Lexer::LeftParen, *type.record.baseType) << Lexer::RightParen;
	if (type.record.declarations) for (auto& declaration: *type.record.declarations)
	{
		if (!IsExported (declaration)) continue; Indent (text << LineBreak);
		if (linkVariables) Write (text, declaration, declaration.scope); else text << declaration.name.string; hasVariables = true;
		Write (text << (declaration.variable.isReadOnly ? Lexer::Minus : Lexer::Asterisk) << Lexer::Colon << Space, *declaration.variable.type) << Lexer::Semicolon;
	}
	Decrease (text);
	return hasVariables ? Indent (text << LineBreak) << Lexer::End : text << Space << Lexer::End;
}

Text& Context::Write (Text& text, const Signature& signature, const Declaration*const procedure)
{
	if ((!signature.parameters || signature.parameters->empty ()) && !signature.result) return text;
	Increase (text << Space << Lexer::LeftParen);
	if (signature.parameters) for (auto& parameter: *signature.parameters)
	{
		if (!IsFirst (parameter, *signature.parameters)) text << Lexer::Semicolon;
		if (procedure) Indent (text << LineBreak); else if (!IsFirst (parameter, *signature.parameters)) text << Space;
		Write (text, parameter, procedure);
	}
	Decrease (text);
	if (procedure && signature.parameters && !signature.parameters->empty ()) Indent (text << LineBreak); text << Lexer::RightParen;
	if (signature.result) Write (text << Lexer::Colon << Space, *signature.result); return text;
}

Article& Context::Write (Article& article, const Signature& signature, Tags& tags)
{
	if (signature.result) tags[0][ResultTag];
	if (signature.receiver) tags[1][signature.receiver->name.string];
	if (signature.parameters) for (auto& parameter: *signature.parameters) tags[1][parameter.name.string];
	return article;
}

void Context::Write (Text& text, const Signature& signature, const Declaration& procedure, Article& article, Tags& tags)
{
	Write (text, signature, &procedure) << Lexer::Semicolon;
	if (signature.receiver) Write (article, *signature.receiver, procedure, tags);
	if (signature.parameters) for (auto& parameter: *signature.parameters) Write (article, parameter, procedure, tags);
	if (signature.result && !tags[0][ResultTag].empty ()) article.paragraphs << Paragraph {Heading, 2} << Space << "Result", article << tags[0][ResultTag];
}

Text& Context::Write (Text& text, const Declaration& declaration, const Declaration*const procedure)
{
	assert (IsParameter (declaration));
	if (declaration.parameter.isVariable) text << Lexer::Var << Space;
	if (procedure) text << TextElement {WeakLink, GetName (declaration, *procedure), declaration.name.string}; else text << declaration.name.string;
	if (declaration.parameter.isReadOnly) text << Lexer::Minus;
	return Write (text << Lexer::Colon << Space, *declaration.parameter.type);
}

Article& Context::Write (Article& article, const Declaration& declaration, const Declaration& procedure, Tags& tags)
{
	assert (IsParameter (declaration)); auto& annotation = tags[1][declaration.name.string];
	if (!annotation.empty ()) article.paragraphs << Paragraph {Heading, 2} << TextElement {Label, GetName (declaration, procedure)} << declaration.name.string << Space << "Parameter", article << annotation;
	return article;
}

Article& Context::Summarize (Article& article, const Scope& scope)
{
	decltype (this->topics) topics; topics.swap (this->topics);
	if (IsRecord (scope) && scope.record->record.baseType) Extract (*scope.record->record.baseType, scope);
	for (auto& object: scope.objects) Extract (*object.second, article.level);
	topics.swap (this->topics); if (IsModule (scope) && !imports.empty ()) Import (article);
	if (topics.empty ()) return article; article.paragraphs << Heading << "Interface"; auto& table = article.paragraphs << Table;
	for (auto& topic: topics) for (auto declaration: topic.second) {auto& row = table << Row;
		if (declaration == topic.second.front ()) row << Header << topic.first << " (" << topic.second.size () << ')'; else row << Cell;
		Write (row << Cell << Code, *declaration, declaration->scope->parent);}
	return article;
}

void Context::Import (Article& article)
{
	assert (!imports.empty ()); article.paragraphs << Heading << "Imports";
	std::sort (imports.begin (), imports.end (), [] (const Module*const first, const Module*const second) {return first->identifier.name->string < second->identifier.name->string;});
	for (auto& import: imports) if (auto& text = Write (Indent (article.paragraphs << TextBlock << Code) << Lexer::Import << Space, *import->scope, nullptr); import->identifier.parent) Write (text << Space << Lexer::In << Space, *import->identifier.parent) << Lexer::Semicolon; else text << Lexer::Semicolon;
}

void Context::Extract (const Type& type, const Scope& scope)
{
	if (IsGeneric (type)) return; assert (IsRecord (type)); if (type.record.baseType) Extract (*type.record.baseType, scope); Text text; Write (text << "From " << Code, type); auto& topic = topics[text];
	for (auto& object: type.record.scope->objects) if (IsExported (*object.second) && scope.Lookup (object.second->name, module) == object.second) topic.push_back (object.second);
	if (IsAlias (type) && IsExported (*type.identifier->declaration)) topics[{{Default, "Base Types"}}].push_back (type.identifier->declaration);
}

Word Context::GetName (const Declaration& declaration, const bool package)
{
	assert (!IsParameter (declaration)); return GetName (*declaration.scope, package) + '.' + declaration.name.string;
}

Word Context::GetName (const Declaration& declaration, const Declaration& procedure)
{
	assert (IsParameter (declaration)); return GetName (procedure, true) + '.' + declaration.name.string;
}

Word Context::GetName (const QualifiedIdentifier& identifier, const bool package)
{
	assert (identifier.name); return package && identifier.parent ? GetName (*identifier.parent, package) + ':' + identifier.name->string : identifier.name->string;
}

Word Context::GetName (const Scope& scope, const bool package)
{
	if (IsGlobal (scope)) return GetName (*scope.identifier, package);
	if (IsModule (scope)) return GetName (scope.module->identifier, package);
	if (IsProcedure (scope)) return GetName (*scope.procedure, package);
	assert (IsRecord (scope)); assert (scope.record->record.declaration);
	return GetName (*scope.record->record.declaration, package);
}

Text& Context::Begin (Article& article, const Declaration& declaration, const char*const type, const char*const category, Tags& tags)
{
	auto& topic = tags[0][TopicTag]; Begin (article, GetName (declaration, false), type, declaration.annotation, tags);
	for (auto& paragraph: topic) if (!IsFirst (paragraph, topic)) EmitWarning (module.source, paragraph.position, "ignoring paragraph");
	topics[topic.empty () ? Text {{Default, category}} : topic.front ().text].push_back (&declaration);
	if (IsGenericParameter (declaration)) article << tags[1][declaration.name.string];
	return Define (article);
}

Text& Context::Define (Article& article)
{
	return article.paragraphs << Heading << "Definition", Indent (article.paragraphs << TextBlock << Code);
}

Article& Context::Begin (Article& article, const Module& module, Tags& tags)
{
	if (IsGeneric (module)) for (auto& definition: *module.definitions) if (IsExported (definition)) tags[1][definition.name.string];
	auto& text = Define (Begin (article, module.identifier.name->string, "Module", module.annotation, tags)) << Lexer::Module << Space << module.identifier.name->string;
	if (IsGeneric (module)) Write (text << Lexer::LeftParen, module.parameters) << Lexer::RightParen;
	if (module.identifier.parent) Write (text << Space << Lexer::In << Space, *module.identifier.parent);
	return text << Lexer::Semicolon, article;
}

Article& Context::Begin (Article& article, const Word& name, const char*const type, const Oberon::Annotation& annotation, Tags& tags)
{
	article.title << TextElement {Code, name} << Space << type; tags[0][RemarksTag];
	Merge (article, annotation.string, module.source, annotation.position, tags); return article;
}

void Context::End (Article& article, Tags& tags)
{
	auto& remarks = tags[0][RemarksTag];
	if (!remarks.empty ()) article.paragraphs << Heading << "Remarks", article << remarks;
}

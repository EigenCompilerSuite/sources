// Oberon parser
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

#include "diagnostics.hpp"
#include "error.hpp"
#include "format.hpp"
#include "oberon.hpp"
#include "obparser.hpp"
#include "utilities.hpp"

using namespace ECS;
using namespace Oberon;

using Context = class Parser::Context
{
public:
	Context (const Parser&, std::istream&, const Position&, Module&);

	void Parse ();

private:
	const Parser& parser;
	std::istream& stream;
	Position position, annotation;
	Module& module;
	Lexer lexer;
	Lexer::Token current;
	Annotation cache;

	void EmitWarning (const Position&, const Message&) const;
	void EmitError [[noreturn]] (const Lexer::Token&, const Message&) const;
	void EmitError [[noreturn]] (const Lexer::Token&, const Message&, const Position&) const;

	void SkipCurrent ();
	bool Skip (Lexer::Symbol);
	void Match (const Identifier&);
	void Expect (Lexer::Symbol) const;
	bool IsCurrent (Lexer::Symbol) const;

	template <typename Structure> void Locate (Structure&);
	template <typename Structure> void Model (Structure&, typename Structure::Model);
	template <typename Structure> void Parse (Structure*&, void (Context::*) (Structure&) = &Context::Parse);
	template <typename Structure> void ParseIf (bool, Structure*&, void (Context::*) (Structure&) = &Context::Parse);

	void Parse (Body&);
	void Parse (Case&);
	void Parse (Cases&);
	void Parse (Definition&);
	void Parse (Definitions&);
	void Parse (Elsif&);
	void Parse (Elsifs&);
	void Parse (Guard&);
	void Parse (Guards&);
	void Parse (Identifier&);
	void Parse (Lexer::Symbol);
	void Parse (Signature&);
	void Parse (Statements&);

	void Parse (QualifiedIdentifier&);
	void ParseIdentifier (QualifiedIdentifier&);

	void Parse (Annotation&);
	void ParseCached (Annotation&);

	void Parse (Declarations&);
	void ParseConstant (Declarations&);
	void ParseField (Declarations&);
	void ParseImport (Declarations&);
	void ParseParameter (Declarations&);
	void ParseParameterList (Declarations&);
	void ParseProcedure (Declarations&);
	void ParseType (Declarations&);
	void ParseVariable (Declarations&);
	void ParseVariableList (Declarations&, bool);

	void ParseConstant (Declaration&);
	void ParseImport (Declaration&, QualifiedIdentifier*);
	void ParseParameter (Declaration&);
	void ParseProcedure (Declaration&);
	void ParseReceiver (Declaration&);
	void ParseType (Declaration&);
	void ParseVariable (Declaration&);

	void Parse (Type&);
	void ParseArray (Type&);
	void ParseIdentifier (Type&);
	void ParsePointer (Type&);
	void ParseProcedure (Type&);
	void ParseQualified (Type&);
	void ParseRecord (Type&);
	void ParseStaticArray (Type&);

	void Parse (Statement&);
	void ParseCase (Statement&);
	void ParseExit (Statement&);
	void ParseFor (Statement&);
	void ParseIf (Statement&);
	void ParseLoop (Statement&);
	void ParseProcedureCall (Statement&);
	void ParseRepeat (Statement&);
	void ParseReturn (Statement&);
	void ParseWhile (Statement&);
	void ParseWith (Statement&);

	void Parse (Expression&);
	void ParseBinary (Expression&, void (Context::*) (Expression&));
	void ParseCall (Expression&);
	void ParseDereference (Expression&);
	void ParseDesignator (Expression&);
	void ParseFactor (Expression&);
	void ParseIdentifier (Expression&);
	void ParseIndex (Expression&);
	void ParseLiteral (Expression&);
	void ParseParenthesized (Expression&);
	void ParseQualified (Expression&);
	void ParseRange (Expression&);
	void ParseSelector (Expression&);
	void ParseSet (Expression&);
	void ParseSimple (Expression&);
	void ParseTerm (Expression&);
	void ParseUnary (Expression&, void (Context::*) (Expression&));

	void Parse (Expressions&);
	void ParseRange (Expressions&);

	template <typename Structure> static void Reset (Structure*&);
};

Parser::Parser (Diagnostics& d, const Annotations a) :
	diagnostics {d}, annotations {a}
{
}

void Parser::Parse (std::istream& stream, const Position& position, Module& module) const
{
	Context {*this, stream, position, module}.Parse ();
}

Context::Context (const Parser& p, std::istream& s, const Position& pos, Module& m) :
	parser {p}, stream {s}, position {pos}, module {m}, lexer {parser.annotations}, current {pos}
{
	SkipCurrent ();
}

void Context::EmitError (const Lexer::Token& token, const Message& message) const
{
	parser.diagnostics.Emit (Diagnostics::Error, module.source, token.position, message); throw Error {};
}

void Context::EmitError (const Lexer::Token& token, const Message& message, const Position& declaration) const
{
	parser.diagnostics.Emit (Diagnostics::Error, module.source, token.position, message); parser.diagnostics.Emit (Diagnostics::Note, module.source, declaration, "declared here"); throw Error {};
}

void Context::EmitWarning (const Position& position, const Message& message) const
{
	parser.diagnostics.Emit (Diagnostics::Warning, module.source, position, message);
}

void Context::SkipCurrent ()
{
	if (!current.annotation.empty ()) EmitWarning (annotation, "ignoring annotation");
	annotation = position; lexer.Scan (stream, position, current);
}

bool Context::IsCurrent (const Lexer::Symbol symbol) const
{
	return current.symbol == symbol;
}

bool Context::Skip (const Lexer::Symbol symbol)
{
	if (!IsCurrent (symbol)) return false; SkipCurrent (); return true;
}

void Context::Expect (const Lexer::Symbol symbol) const
{
	if (!IsCurrent (symbol)) EmitError (current, Format ("encountered %0 instead of %1", current, symbol));
}

void Context::Match (const Identifier& name)
{
	Expect (Lexer::Identifier);
	if (current.string != name.string) EmitError (current, Format ("identifier '%0' does not match '%1'", current.string, name), name.position);
	SkipCurrent ();
}

void Context::Parse (Identifier& identifier)
{
	Expect (Lexer::Identifier); identifier.string.swap (current.string); Locate (identifier); SkipCurrent ();
}

void Context::Parse (Definition& definition)
{
	Locate (definition); Parse (definition.name); definition.isExported = Skip (Lexer::Asterisk);
}

void Context::Parse (Definitions& definitions)
{
	do Parse (definitions.emplace_back ()); while (Skip (Lexer::Comma));
}

void Context::Parse (QualifiedIdentifier& identifier)
{
	ParseIdentifier (identifier);
	while (Skip (Lexer::Dot)) module.Create (identifier.parent, identifier), Parse (identifier.name);
}

void Context::ParseIdentifier (QualifiedIdentifier& identifier)
{
	Parse (identifier.name); Reset (identifier.parent);
}

void Context::Parse (Annotation& annotation)
{
	if (!current.annotation.empty () && annotation.string.empty ()) annotation.string.swap (current.annotation), annotation.position = this->annotation;
}

void Context::ParseCached (Annotation& annotation)
{
	if (!cache.string.empty ()) annotation.string.swap (cache.string), annotation.position = cache.position; else Parse (annotation);
}

void Context::Parse (const Lexer::Symbol symbol)
{
	Expect (symbol); SkipCurrent ();
}

template <typename Structure>
inline void Context::Reset (Structure*& structure)
{
	structure = nullptr;
}

template <typename Structure>
void Context::Parse (Structure*& structure, void (Context::*const parse) (Structure&))
{
	module.Create (structure); (this->*parse) (*structure);
}

template <typename Structure>
inline void Context::ParseIf (const bool condition, Structure*& structure, void (Context::*const parse) (Structure&))
{
	if (condition) Parse (structure, parse); else Reset (structure);
}

template <typename Structure>
inline void Context::Locate (Structure& structure)
{
	structure.position = current.position;
}

template <typename Structure>
inline void Context::Model (Structure& structure, const typename Structure::Model model)
{
	structure.model = model; Locate (structure);
}

void Context::Parse ()
{
	Parse (module.annotation);
	Parse (Lexer::Module); Parse (module.identifier.name);
	ParseIf (Skip (Lexer::LeftParen), module.definitions);
	if (module.definitions) Parse (Lexer::RightParen);
	ParseIf (Skip (Lexer::In), module.identifier.parent); Parse (Lexer::Semicolon);
	while (IsCurrent (Lexer::Import) || IsCurrent (Lexer::In)) ParseImport (module.declarations);
	Parse (module.declarations); ParseIf (IsCurrent (Lexer::Begin), module.body);
	Parse (Lexer::End); Match (*module.identifier.name); Expect (Lexer::Dot);
	if (parser.annotations) SkipCurrent (), Parse (module.documentation);
}

void Context::ParseImport (Declarations& declarations)
{
	QualifiedIdentifier* package; ParseIf (Skip (Lexer::In), package); Parse (Lexer::Import);
	do ParseImport (declarations.emplace_back (), package); while (Skip (Lexer::Comma));
	Parse (Lexer::Semicolon);
}

void Context::ParseImport (Declaration& declaration, QualifiedIdentifier* package)
{
	Model (declaration, Declaration::Import); Parse (declaration.name); ParseIf (Skip (Lexer::Assign), declaration.import.alias);
	ParseIf (Skip (Lexer::LeftParen), declaration.import.expressions); if (declaration.import.expressions) Parse (Lexer::RightParen);
	if (!package) ParseIf (Skip (Lexer::In), package); declaration.import.identifier.parent = package;
}

void Context::Parse (Declarations& declarations)
{
	while (IsCurrent (Lexer::Const) || IsCurrent (Lexer::Type) || IsCurrent (Lexer::Var))
		if (IsCurrent (Lexer::Const)) ParseConstant (declarations);
		else if (IsCurrent (Lexer::Type)) ParseType (declarations);
		else if (IsCurrent (Lexer::Var)) ParseVariable (declarations);
	ParseProcedure (declarations);
}

void Context::ParseConstant (Declarations& declarations)
{
	Parse (cache); Parse (Lexer::Const);
	while (IsCurrent (Lexer::Identifier)) ParseConstant (declarations.emplace_back ());
}

void Context::ParseConstant (Declaration& declaration)
{
	Model (declaration, Declaration::Constant); ParseCached (declaration.annotation); Parse (declaration.name);
	declaration.isExported = Skip (Lexer::Asterisk); Parse (Lexer::Equal); Parse (declaration.constant.expression); Parse (Lexer::Semicolon);
}

void Context::ParseType (Declarations& declarations)
{
	Parse (cache); Parse (Lexer::Type);
	while (IsCurrent (Lexer::Identifier)) ParseType (declarations.emplace_back ());
}

void Context::ParseType (Declaration& declaration)
{
	Model (declaration, Declaration::Type); ParseCached (declaration.annotation); Parse (declaration.name);
	declaration.isExported = Skip (Lexer::Asterisk); Parse (Lexer::Equal); Parse (declaration.type); Parse (Lexer::Semicolon);
}

void Context::ParseVariable (Declarations& declarations)
{
	Parse (cache); Parse (Lexer::Var);
	while (IsCurrent (Lexer::Identifier) || IsCurrent (Lexer::Arrow)) ParseVariableList (declarations, Skip (Lexer::Arrow)), Parse (Lexer::Semicolon);
}

void Context::ParseVariableList (Declarations& declarations, const bool isForward)
{
	const auto offset = declarations.size (); do ParseVariable (declarations.emplace_back ()); while (Skip (Lexer::Comma)); Parse (Lexer::Colon); Type* type; Parse (type);
	for (auto declaration = declarations.begin () + offset; declaration != declarations.end (); ++declaration) declaration->variable.type = type, declaration->variable.isForward = isForward;
}

void Context::ParseVariable (Declaration& declaration)
{
	Model (declaration, Declaration::Variable); ParseCached (declaration.annotation); Parse (declaration.name);
	declaration.variable.isReadOnly = Skip (Lexer::Minus); declaration.isExported = declaration.variable.isReadOnly || Skip (Lexer::Asterisk);
	ParseIf (Skip (Lexer::LeftBracket), declaration.variable.external); if (declaration.variable.external) Parse (Lexer::RightBracket); Reset (declaration.variable.type);
}

void Context::ParseProcedure (Declarations& declarations)
{
	while (IsCurrent (Lexer::Procedure)) ParseProcedure (declarations.emplace_back ());
}

void Context::ParseProcedure (Declaration& declaration)
{
	Model (declaration, Declaration::Procedure); Parse (declaration.annotation); Parse (Lexer::Procedure);
	declaration.procedure.isAbstract = Skip (Lexer::Asterisk); declaration.procedure.isFinal = !declaration.procedure.isAbstract && Skip (Lexer::Minus);
	declaration.procedure.isForward = Skip (Lexer::Arrow); ParseIf (IsCurrent (Lexer::LeftParen), declaration.procedure.signature.receiver, &Context::ParseReceiver); Parse (declaration.name);
	declaration.isExported = Skip (Lexer::Asterisk); ParseIf (Skip (Lexer::LeftBracket), declaration.procedure.external); if (declaration.procedure.external) Parse (Lexer::RightBracket);
	Parse (declaration.procedure.signature); Parse (Lexer::Semicolon); if (declaration.procedure.isAbstract || declaration.procedure.isForward) return;
	ParseIf (!IsCurrent (Lexer::Begin) && !IsCurrent (Lexer::End), declaration.procedure.declarations);
	ParseIf (IsCurrent (Lexer::Begin), declaration.procedure.body);
	Parse (Lexer::End); Match (declaration.name); Parse (Lexer::Semicolon);
}

void Context::Parse (Signature& signature)
{
	ParseIf (IsCurrent (Lexer::LeftParen), signature.parameters, &Context::ParseParameter);
	ParseIf (signature.parameters && Skip (Lexer::Colon), signature.result);
}

void Context::ParseParameter (Declarations& declarations)
{
	Parse (Lexer::LeftParen);
	if (!IsCurrent (Lexer::RightParen)) do ParseParameterList (declarations); while (Skip (Lexer::Semicolon));
	Parse (Lexer::RightParen);
}

void Context::ParseParameterList (Declarations& declarations)
{
	const auto isVariable = Skip (Lexer::Var); do ParseParameter (declarations.emplace_back ()); while (Skip (Lexer::Comma)); Parse (Lexer::Colon); Type* type; Parse (type);
	for (auto& declaration: Reverse {declarations}) if (IsParameter (declaration) && !declaration.parameter.type) declaration.parameter.type = type, declaration.parameter.isVariable = isVariable; else break;
}

void Context::ParseParameter (Declaration& declaration)
{
	Model (declaration, Declaration::Parameter); Parse (declaration.name); declaration.parameter.isReadOnly = Skip (Lexer::Minus); Reset (declaration.parameter.type);
}

void Context::ParseReceiver (Declaration& declaration)
{
	Parse (Lexer::LeftParen); declaration.parameter.isVariable = Skip (Lexer::Var); ParseParameter (declaration);
	Parse (Lexer::Colon); Parse (declaration.parameter.type, &Context::ParseIdentifier); Parse (Lexer::RightParen);
}

void Context::Parse (Type& type)
{
	if (IsCurrent (Lexer::Array)) ParseArray (type);
	else if (IsCurrent (Lexer::Record)) ParseRecord (type);
	else if (IsCurrent (Lexer::Pointer)) ParsePointer (type);
	else if (IsCurrent (Lexer::Procedure)) ParseProcedure (type);
	else ParseQualified (type);
}

void Context::ParseArray (Type& type)
{
	Model (type, Type::Array); Parse (Lexer::Array);
	if (Skip (Lexer::Of)) Reset (type.array.length), Parse (type.array.elementType); else ParseStaticArray (type);
}

void Context::ParseStaticArray (Type& type)
{
	Model (type, Type::Array); Parse (type.array.length);
	if (Skip (Lexer::Comma)) Parse (type.array.elementType, &Context::ParseStaticArray); else Parse (Lexer::Of), Parse (type.array.elementType);
}

void Context::ParseRecord (Type& type)
{
	Model (type, Type::Record); Parse (Lexer::Record); type.record.isAbstract = Skip (Lexer::Asterisk); type.record.isFinal = !type.record.isAbstract && Skip (Lexer::Minus);
	ParseIf (Skip (Lexer::LeftParen), type.record.baseType, &Context::ParseQualified); if (type.record.baseType) Parse (Lexer::RightParen);
	ParseIf (!IsCurrent (Lexer::End), type.record.declarations, &Context::ParseField); Parse (Lexer::End);
}

void Context::ParseField (Declarations& declarations)
{
	do if (!IsCurrent (Lexer::Semicolon) && !IsCurrent (Lexer::End)) ParseVariableList (declarations, false); while (Skip (Lexer::Semicolon));
}

void Context::ParsePointer (Type& type)
{
	Model (type, Type::Pointer); Parse (Lexer::Pointer); Parse (Lexer::To); type.pointer.isVariable = Skip (Lexer::Var); type.pointer.isReadOnly = Skip (Lexer::Minus); Parse (type.pointer.baseType);
}

void Context::ParseProcedure (Type& type)
{
	Model (type, Type::Procedure); Parse (Lexer::Procedure); Parse (type.procedure.signature);
}

void Context::ParseQualified (Type& type)
{
	Model (type, Type::Identifier); Parse (type.identifier);
}

void Context::ParseIdentifier (Type& type)
{
	Model (type, Type::Identifier); Parse (type.identifier, &Context::ParseIdentifier);
}

void Context::Parse (Body& body)
{
	Locate (body.begin); Parse (Lexer::Begin); Parse (body.statements); Locate (body.end);
}

void Context::Parse (Statements& statements)
{
	do if (!IsCurrent (Lexer::Semicolon) && !IsCurrent (Lexer::End) && !IsCurrent (Lexer::Elsif) && !IsCurrent (Lexer::Else) && !IsCurrent (Lexer::Bar) && !IsCurrent (Lexer::Until)) Parse (statements.emplace_back ()); while (Skip (Lexer::Semicolon));
}

void Context::Parse (Statement& statement)
{
	if (IsCurrent (Lexer::If)) ParseIf (statement);
	else if (IsCurrent (Lexer::Case)) ParseCase (statement);
	else if (IsCurrent (Lexer::While)) ParseWhile (statement);
	else if (IsCurrent (Lexer::Repeat)) ParseRepeat (statement);
	else if (IsCurrent (Lexer::For)) ParseFor (statement);
	else if (IsCurrent (Lexer::Loop)) ParseLoop (statement);
	else if (IsCurrent (Lexer::With)) ParseWith (statement);
	else if (IsCurrent (Lexer::Exit)) ParseExit (statement);
	else if (IsCurrent (Lexer::Return)) ParseReturn (statement);
	else ParseProcedureCall (statement);
}

void Context::ParseIf (Statement& statement)
{
	Model (statement, Statement::If); Parse (Lexer::If); Parse (statement.if_.condition); Parse (Lexer::Then); Parse (statement.if_.thenPart);
	ParseIf (IsCurrent (Lexer::Elsif), statement.if_.elsifs); ParseIf (Skip (Lexer::Else), statement.if_.elsePart); Parse (Lexer::End);
}

void Context::Parse (Elsifs& elsifs)
{
	do Parse (elsifs.emplace_back ()); while (IsCurrent (Lexer::Elsif));
}

void Context::Parse (Elsif& elsif)
{
	Locate (elsif); Parse (Lexer::Elsif); Parse (elsif.condition); Parse (Lexer::Then); Parse (elsif.statements);
}

void Context::ParseCase (Statement& statement)
{
	Model (statement, Statement::Case); Parse (Lexer::Case); Parse (statement.case_.expression); Parse (Lexer::Of);
	ParseIf (!IsCurrent (Lexer::Else) && !IsCurrent (Lexer::End), statement.case_.cases);
	ParseIf (Skip (Lexer::Else), statement.case_.elsePart); Parse (Lexer::End);
}

void Context::Parse (Cases& cases)
{
	do if (!IsCurrent (Lexer::Bar) && !IsCurrent (Lexer::Else) && !IsCurrent (Lexer::End)) Parse (cases.emplace_back ()); while (Skip (Lexer::Bar));
}

void Context::Parse (Case& case_)
{
	ParseRange (case_.labels); Parse (Lexer::Colon); Parse (case_.statements);
}

void Context::ParseWhile (Statement& statement)
{
	Model (statement, Statement::While); Parse (Lexer::While); Parse (statement.while_.condition); Parse (Lexer::Do); Parse (statement.while_.statements); Parse (Lexer::End);
}

void Context::ParseRepeat (Statement& statement)
{
	Model (statement, Statement::Repeat); Parse (Lexer::Repeat); Parse (statement.repeat.statements); Parse (Lexer::Until); Parse (statement.repeat.condition);
}

void Context::ParseFor (Statement& statement)
{
	Model (statement, Statement::For); Parse (Lexer::For); Parse (statement.for_.variable, &Context::ParseIdentifier); Parse (Lexer::Assign); Parse (statement.for_.begin);
	Parse (Lexer::To); Parse (statement.for_.end); ParseIf (Skip (Lexer::By), statement.for_.step); Parse (Lexer::Do); Parse (statement.for_.statements); Parse (Lexer::End);
}

void Context::ParseLoop (Statement& statement)
{
	Model (statement, Statement::Loop); Parse (Lexer::Loop); Parse (statement.loop.statements); Parse (Lexer::End);
}

void Context::ParseWith (Statement& statement)
{
	Model (statement, Statement::With); Parse (Lexer::With); Parse (statement.with.guards); ParseIf (Skip (Lexer::Else), statement.with.elsePart); Parse (Lexer::End);
}

void Context::Parse (Guards& guards)
{
	do Parse (guards.emplace_back ()); while (Skip (Lexer::Bar));
}

void Context::Parse (Guard& guard)
{
	Locate (guard); ParseQualified (guard.expression); Parse (Lexer::Colon); ParseQualified (guard.type); Parse (Lexer::Do); Parse (guard.statements);
}

void Context::ParseExit (Statement& statement)
{
	Model (statement, Statement::Exit); Parse (Lexer::Exit);
}

void Context::ParseReturn (Statement& statement)
{
	Model (statement, Statement::Return); Parse (Lexer::Return);
	ParseIf (!IsCurrent (Lexer::Semicolon) && !IsCurrent (Lexer::End) && !IsCurrent (Lexer::Elsif) && !IsCurrent (Lexer::Else) && !IsCurrent (Lexer::Bar) && !IsCurrent (Lexer::Until), statement.return_.expression);
}

void Context::ParseProcedureCall (Statement& statement)
{
	Model (statement, Statement::ProcedureCall); Parse (statement.procedureCall.designator, &Context::ParseDesignator);
	if (Skip (Lexer::Assign)) statement.model = Statement::Assignment, Parse (statement.assignment.expression);
}

void Context::Parse (Expression& expression)
{
	ParseSimple (expression);
	if (IsCurrent (Lexer::Equal) || IsCurrent (Lexer::Unequal) || IsCurrent (Lexer::Less) || IsCurrent (Lexer::LessEqual) ||
		IsCurrent (Lexer::Greater) || IsCurrent (Lexer::GreaterEqual) || IsCurrent (Lexer::In) || IsCurrent (Lexer::Is)) ParseBinary (expression, &Context::ParseSimple);
}

void Context::ParseSimple (Expression& expression)
{
	if (IsCurrent (Lexer::Plus) || IsCurrent (Lexer::Minus)) ParseUnary (expression, &Context::ParseTerm); else ParseTerm (expression);
	while (IsCurrent (Lexer::Plus) || IsCurrent (Lexer::Minus) || IsCurrent (Lexer::Or)) ParseBinary (expression, &Context::ParseTerm);
}

void Context::ParseTerm (Expression& expression)
{
	ParseFactor (expression);
	while (IsCurrent (Lexer::Asterisk) || IsCurrent (Lexer::Slash) || IsCurrent (Lexer::Div) || IsCurrent (Lexer::Mod) || IsCurrent (Lexer::And)) ParseBinary (expression, &Context::ParseFactor);
}

void Context::ParseFactor (Expression& expression)
{
	if (IsCurrent (Lexer::Integer) || IsCurrent (Lexer::BinaryInteger) || IsCurrent (Lexer::HexadecimalInteger) || IsCurrent (Lexer::Real)) ParseLiteral (expression);
	else if (IsCurrent (Lexer::Character) || IsCurrent (Lexer::SingleQuotedString) || IsCurrent (Lexer::DoubleQuotedString)) ParseLiteral (expression);
	else if (IsCurrent (Lexer::Nil)) ParseLiteral (expression);
	else if (IsCurrent (Lexer::LeftBrace)) Reset (expression.set.identifier), ParseSet (expression);
	else if (IsCurrent (Lexer::LeftParen)) ParseParenthesized (expression);
	else if (IsCurrent (Lexer::Not)) ParseUnary (expression, &Context::ParseFactor);
	else ParseDesignator (expression);
	if (IsCurrent (Lexer::LeftBrace) && IsQualified (expression)) module.Create (expression.set.identifier, expression), ParseSet (expression);
}

void Context::ParseLiteral (Expression& expression)
{
	Model (expression, Expression::Literal); module.Create (expression.literal, current); SkipCurrent ();
}

void Context::ParseParenthesized (Expression& expression)
{
	Model (expression, Expression::Parenthesized); Parse (Lexer::LeftParen); Parse (expression.parenthesized.expression); Parse (Lexer::RightParen);
}

void Context::ParseSet (Expression& expression)
{
	Model (expression, Expression::Set); Parse (Lexer::LeftBrace);
	ParseIf (!IsCurrent (Lexer::RightBrace), expression.set.elements, &Context::ParseRange); Parse (Lexer::RightBrace);
}

void Context::ParseRange (Expressions& expressions)
{
	do ParseRange (expressions.emplace_back ()); while (Skip (Lexer::Comma));
}

void Context::ParseRange (Expression& expression)
{
	Parse (expression); if (IsCurrent (Lexer::Range)) ParseBinary (expression, &Context::Parse);
}

void Context::ParseDesignator (Expression& expression)
{
	ParseQualified (expression);
	while (IsCurrent (Lexer::Dot) || IsCurrent (Lexer::LeftBracket) || IsCurrent (Lexer::Arrow) || IsCurrent (Lexer::LeftParen))
		if (IsCurrent (Lexer::Dot)) ParseSelector (expression);
		else if (IsCurrent (Lexer::LeftBracket)) ParseIndex (expression);
		else if (IsCurrent (Lexer::Arrow)) ParseDereference (expression);
		else if (IsCall (expression) && !IsTypeGuardCall (expression)) break;
		else ParseCall (expression);
}

void Context::ParseQualified (Expression& expression)
{
	ParseIdentifier (expression);
	if (IsCurrent (Lexer::Dot)) ParseSelector (expression);
}

void Context::ParseIdentifier (Expression& expression)
{
	Model (expression, Expression::Identifier); ParseIdentifier (expression.identifier);
}

void Context::ParseSelector (Expression& expression)
{
	module.Create (expression.selector.designator, expression); Model (expression, Expression::Selector); Parse (Lexer::Dot); Parse (expression.selector.identifier);
}

void Context::ParseIndex (Expression& expression)
{
	Parse (Lexer::LeftBracket); do module.Create (expression.index.designator, expression), Model (expression, Expression::Index),
	Parse (expression.index.expression); while (Skip (Lexer::Comma)); Parse (Lexer::RightBracket);
}

void Context::ParseDereference (Expression& expression)
{
	module.Create (expression.dereference.expression, expression); Model (expression, Expression::Dereference); Parse (Lexer::Arrow);
}

void Context::ParseCall (Expression& expression)
{
	module.Create (expression.call.designator, expression); Model (expression, Expression::Call);
	Parse (Lexer::LeftParen); ParseIf (!IsCurrent (Lexer::RightParen), expression.call.arguments); Parse (Lexer::RightParen);
}

void Context::Parse (Expressions& expressions)
{
	do Parse (expressions.emplace_back ()); while (Skip (Lexer::Comma));
}

void Context::ParseUnary (Expression& expression, void (Context::*const parse) (Expression&))
{
	Model (expression, Expression::Unary); expression.unary.operator_ = current.symbol; SkipCurrent (); Parse (expression.unary.operand, parse);
}

void Context::ParseBinary (Expression& expression, void (Context::*const parse) (Expression&))
{
	module.Create (expression.binary.left, expression); Model (expression, Expression::Binary);
	expression.binary.operator_ = current.symbol; SkipCurrent (); Parse (expression.binary.right, parse);
}

// Generic assembly language parser
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

#include "asmparser.hpp"
#include "assembly.hpp"
#include "error.hpp"
#include "format.hpp"
#include "stringpool.hpp"

#include <array>
#include <cctype>
#include <cerrno>
#include <map>

using namespace ECS;
using namespace Assembly;

using Context = class Parser::Context
{
public:
	Context (const Parser&, std::istream&, const Source&, Line);

	void Parse (Sections&);
	void Parse (Instructions&);

private:
	using Base = int;
	using Tokens = std::list<Lexer::Token>;
	using Macros = std::map<Identifier, Tokens>;
	using Operand = std::vector<Lexer::Token>;
	using Operands = std::array<Operand, 11>;

	const Parser& parser;
	std::istream& stream;
	Lexer lexer;
	Macros macros;
	Tokens tokens;
	Lexer::Token current;

	void EmitError [[noreturn]] (const Lexer::Token&, const Message&) const;

	void SkipCurrent ();
	bool SkipWhiteSpace ();
	void Expect (Lexer::Symbol) const;

	bool IsSection (Directive) const;
	bool IsCurrent (Lexer::Symbol) const;
	bool IsRecursive (const Lexer::Token&, Macros::const_iterator) const;

	void RepeatCode ();
	void DefineMacro ();
	bool ExpandMacro ();
	void UndefineMacro ();
	void Parse (Operand&, Lexer::Symbol);
	void Expand (Lexer::Token&, const Operands&);
	void Expand (const Tokens&, const Operands&, Tokens::const_iterator);

	void Parse (Section&);
	void Parse (Instruction&);
	void Parse (Lexer::Symbol);
	void ParseLineDirective ();
	void Parse (Section::Name&);
	void ParseAssembly (Section&);
	void ParseSection (Instructions&);
	void Parse (Section&, Section::Type);
	void ParseDirective (Instruction&, void (Context::*) (Expressions&) = nullptr);

	void Parse (Expressions&);
	void ParseSingle (Expressions&);
	void ParseOptional (Expressions&);
	void Parse (Expressions&, Lexer::Symbol);

	void Parse (Expression&);
	void ParseAnd (Expression&);
	void ParseShift (Expression&);
	void ParseUnary (Expression&);
	void ParseNullary (Expression&);
	void ParsePostfix (Expression&);
	void ParsePrimary (Expression&);
	void ParseAdditive (Expression&);
	void ParseEquality (Expression&);
	void ParseIdentical (Expression&);
	void ParseLogicalOr (Expression&);
	void ParseLogicalAnd (Expression&);
	void ParseRelational (Expression&);
	void ParseExclusiveOr (Expression&);
	void ParseInclusiveOr (Expression&);
	void ParseNumber (Expression&, Base);
	void ParseParenthesized (Expression&);
	void ParseMultiplicative (Expression&);
	void ParseLiteral (Expression&, Expression::Model);
	void ParseFunctional (Expression&, Expression::Operation);
	void ParseBinary (Expression&, void (Context::*) (Expression&));

	Expression::Value Evaluate (const Lexer::Token&, Base) const;

	static const Operand* GetOperand (const String&, String::size_type, const Operands&);
};

Parser::Parser (Diagnostics& d, StringPool& sp, const SpecialSections ss) :
	diagnostics {d}, stringPool {sp}, specialSections {ss}
{
}

void Parser::Parse (std::istream& stream, const Line line, Program& program) const
{
	Context {*this, stream, program.source, line}.Parse (program.sections);
}

void Parser::Parse (std::istream& stream, const Source& source, const Line line, Instructions& instructions) const
{
	Context {*this, stream, source, line}.Parse (instructions);
}

Context::Context (const Parser& p, std::istream& s, const Source& source, const Line line) :
	parser {p}, stream {s}, current {Lexer::Invalid, {source, line}}
{
	SkipCurrent ();
}

void Context::EmitError (const Lexer::Token& token, const Message& message) const
{
	token.location.Emit (Diagnostics::Error, parser.diagnostics, message); throw Error {};
}

void Context::SkipCurrent ()
{
	if (tokens.empty ()) lexer.Scan (stream, current);
	else current = tokens.front (), tokens.pop_front ();
	if (IsCurrent (Lexer::Line)) ParseLineDirective ();
}

bool Context::SkipWhiteSpace ()
{
	while (!IsCurrent (Lexer::Eof) && !IsCurrent (Lexer::End))
		if (IsCurrent (Lexer::Newline)) SkipCurrent ();
		else if (IsCurrent (Lexer::Repeat)) RepeatCode ();
		else if (IsCurrent (Lexer::Define)) DefineMacro ();
		else if (IsCurrent (Lexer::Undef)) UndefineMacro ();
		else if (IsCurrent (Lexer::Identifier) && ExpandMacro ()) continue;
		else return true;
	return false;
}

bool Context::IsCurrent (const Lexer::Symbol symbol) const
{
	return current.symbol == symbol;
}

void Context::Expect (const Lexer::Symbol symbol) const
{
	if (!IsCurrent (symbol)) EmitError (current, Format ("encountered %0 instead of %1", current, symbol));
}

void Context::Parse (const Lexer::Symbol symbol)
{
	Expect (symbol); SkipCurrent ();
}

void Context::Parse (Sections& sections)
{
	if (SkipWhiteSpace () && !IsSection (current.symbol) && sections.empty ()) ParseSection (sections.emplace_back (Section::Code, Section::EntryPoint).instructions);
	while (SkipWhiteSpace ()) Parse (sections.emplace_back ());
}

void Context::Parse (Instructions& instructions)
{
	while (SkipWhiteSpace ()) Parse (instructions.emplace_back (current.location));
}

void Context::ParseSection (Instructions& instructions)
{
	while (SkipWhiteSpace () && !IsSection (current.symbol)) Parse (instructions.emplace_back (current.location));
}

void Context::DefineMacro ()
{
	Parse (Lexer::Define); Expect (Lexer::Identifier);
	const auto result = macros.emplace (current.string, Tokens {});
	if (!result.second) EmitError (current, Format ("duplicated macro '%0'", current.string));
	SkipCurrent (); if (!IsCurrent (Lexer::Eof)) Parse (Lexer::Newline);
	for (auto& macro = result.first->second; !IsCurrent (Lexer::Enddef) && !IsCurrent (Lexer::Define) && !IsCurrent (Lexer::Undef) && !IsCurrent (Lexer::Repeat); macro.push_back (current), SkipCurrent ())
		while (!IsCurrent (Lexer::Newline)) if (IsCurrent (Lexer::Eof)) Expect (Lexer::Enddef);
			else if (!IsRecursive (current, result.first)) macro.push_back (current), SkipCurrent ();
			else EmitError (current, Format ("recursive invocation of macro '%0'", current.string));
	Parse (Lexer::Enddef); if (!IsCurrent (Lexer::Eof)) Parse (Lexer::Newline);
}

void Context::UndefineMacro ()
{
	Parse (Lexer::Undef); Expect (Lexer::Identifier);
	if (!macros.erase (current.string)) EmitError (current, Format ("undefined macro '%0'", current.string));
	SkipCurrent (); if (!IsCurrent (Lexer::Eof)) Parse (Lexer::Newline);
}

bool Context::ExpandMacro ()
{
	Expect (Lexer::Identifier); const auto macro = macros.find (current.string); if (macro == macros.end ()) return false;
	Operands operands {{{{Lexer::Integer, current.location}}}}; operands[0][0].string = std::to_string (current.location.line); SkipCurrent ();
	for (auto operand = &operands[1]; !IsCurrent (Lexer::Newline) && !IsCurrent (Lexer::Eof);)
		if (!IsCurrent (Lexer::Comma)) Parse (*operand, Lexer::Comma);
		else if (operand != &operands.back ()) SkipCurrent (), ++operand;
		else EmitError (current, "too many operands in macro invocation");
	if (!IsCurrent (Lexer::Eof)) Expect (Lexer::Newline); tokens.push_front (current);
	Expand (macro->second, operands, tokens.begin ()); SkipCurrent (); return true;
}

void Context::Parse (Operand& operand, const Lexer::Symbol sentinel)
{
	for (Lexer::Symbol parenthesis; !IsCurrent (Lexer::Newline) && !IsCurrent (Lexer::Eof) && !IsCurrent (sentinel); operand.push_back (current), SkipCurrent ())
		if (IsCurrent (Lexer::LeftParen) || IsCurrent (Lexer::LeftBracket) || IsCurrent (Lexer::LeftBrace))
			parenthesis = Lexer::Symbol (current.symbol + 1), operand.push_back (current), SkipCurrent (), Parse (operand, parenthesis), Expect (parenthesis);
}

void Context::RepeatCode ()
{
	Parse (Lexer::Repeat); Expect (Lexer::Integer);
	const auto repetitions = Evaluate (current, 10); if (repetitions > 65536) EmitError (current, "invalid number of repetitions");
	Operands operands {{{current}}}; SkipCurrent (); if (!IsCurrent (Lexer::Eof)) Parse (Lexer::Newline); Tokens code;
	for (; !IsCurrent (Lexer::Endrep) && !IsCurrent (Lexer::Repeat) && !IsCurrent (Lexer::Define) && !IsCurrent (Lexer::Undef); code.push_back (current), SkipCurrent ())
		while (!IsCurrent (Lexer::Newline)) if (IsCurrent (Lexer::Eof)) Expect (Lexer::Endrep); else code.push_back (current), SkipCurrent ();
	Parse (Lexer::Endrep); if (!IsCurrent (Lexer::Eof)) Expect (Lexer::Newline);
	tokens.push_front (current); const auto position = tokens.begin ();
	for (Expression::Value value = 0; value < repetitions; ++value)
		operands[0][0].string = std::to_string (value), Expand (code, operands, position);
	SkipCurrent ();
}

void Context::Expand (const Tokens& tokens, const Operands& operands, const Tokens::const_iterator position)
{
	for (auto& token: tokens)
		switch (token.symbol)
		{
		case Lexer::Identifier: if (token.string.size () == 2) if (const auto operand = GetOperand (token.string, 0, operands)) {this->tokens.insert (position, operand->begin (), operand->end ()); break;}
		case Lexer::String: case Lexer::Address: case Lexer::Character: Expand (*this->tokens.insert (position, token), operands); break;
		default: this->tokens.insert (position, token);
		}
}

void Context::Expand (Lexer::Token& token, const Operands& operands)
{
	for (auto position = token.string.find ('#'); position != token.string.npos; position = token.string.find ('#', position))
		if (const auto operand = GetOperand (token.string, position, operands))
			if (operand->size () != 1) if (operand->empty ()) token.string.erase (position, 2); else EmitError (token, Format ("compound operand replacement in %0", token));
			else if (operand->front ().symbol == Lexer::Identifier || operand->front ().symbol == Lexer::Integer) token.string.replace (position, 2, operand->front ().string), position += operand->front ().string.size ();
			else EmitError (token, Format ("invalid replacement of %0 within %1", operand->front (), token));
		else ++position;
}

bool Context::IsRecursive (const Lexer::Token& token, const Macros::const_iterator macro) const
{
	if (token.symbol != Lexer::Identifier) return false;
	const auto iterator = macros.find (token.string); if (iterator == macro) return true;
	if (iterator != macros.end ()) for (auto& token: iterator->second) if (IsRecursive (token, macro)) return true;
	return false;
}

const Context::Operand* Context::GetOperand (const String& string, String::size_type position, const Operands& operands)
{
	if (string[position] == '#' && ++position != string.size ()) if (string[position] == '#') return &operands[0]; else if (std::isdigit (string[position])) return &operands[string[position] - '0' + 1]; return nullptr;
}

bool Context::IsSection (const Directive directive) const
{
	return directive == Lexer::Code || directive == Lexer::InitCode || directive == Lexer::InitData || directive == Lexer::Data || directive == Lexer::Const ||
		directive == Lexer::Header || directive == Lexer::Trailer || (directive == Lexer::Type || directive == Lexer::Assembly) && parser.specialSections;
}

void Context::Parse (Section& section)
{
	if (IsCurrent (Lexer::Code)) Parse (section, Section::Code);
	else if (IsCurrent (Lexer::InitCode)) Parse (section, Section::InitCode);
	else if (IsCurrent (Lexer::InitData)) Parse (section, Section::InitData);
	else if (IsCurrent (Lexer::Data)) Parse (section, Section::Data);
	else if (IsCurrent (Lexer::Const)) Parse (section, Section::Const);
	else if (IsCurrent (Lexer::Header)) Parse (section, Section::Header);
	else if (IsCurrent (Lexer::Trailer)) Parse (section, Section::Trailer);
	else if (IsCurrent (Lexer::Type) && parser.specialSections) Parse (section, Section::TypeSection);
	else if (IsCurrent (Lexer::Assembly) && parser.specialSections) SkipCurrent (), ParseAssembly (section);
	else EmitError (current, Format ("encountered %0 instead of section creation directive", current));
}

void Context::Parse (Section& section, const Section::Type type)
{
	assert (IsSection (current.symbol)); SkipCurrent ();
	section.type = type; Parse (section.name); ParseAssembly (section);
}

void Context::Parse (Section::Name& name)
{
	if (!IsCurrent (Lexer::String)) Expect (Lexer::Identifier);
	if (!Object::IsValid (current.string)) EmitError (current, "invalid section name");
	name.swap (current.string); SkipCurrent ();
}

void Context::ParseAssembly (Section& section)
{
	if (!IsCurrent (Lexer::Eof)) Parse (Lexer::Newline); ParseSection (section.instructions);
}

void Context::Parse (Instruction& instruction)
{
	if (IsCurrent (Lexer::Trace))
		return ParseDirective (instruction, &Context::ParseOptional);
	if (IsCurrent (Lexer::Assert) || IsCurrent (Lexer::Alignment) || IsCurrent (Lexer::Origin) || IsCurrent (Lexer::Align) ||
		IsCurrent (Lexer::Pad) || IsCurrent (Lexer::BitMode) || IsCurrent (Lexer::If) || IsCurrent (Lexer::Elif) ||
		IsCurrent (Lexer::Alias) || IsCurrent (Lexer::Require) || IsCurrent (Lexer::Group))
		return ParseDirective (instruction, &Context::ParseSingle);
	if (IsCurrent (Lexer::Required) || IsCurrent (Lexer::Duplicable) || IsCurrent (Lexer::Replaceable) || IsCurrent (Lexer::Else) ||
		IsCurrent (Lexer::Endif) || IsCurrent (Lexer::Little) || IsCurrent (Lexer::Big))
		return ParseDirective (instruction);

	if (IsCurrent (Lexer::Identifier)) instruction.mnemonic.swap (current.string), SkipCurrent ();
	if (IsCurrent (Lexer::Colon) && !instruction.mnemonic.empty ()) instruction.label.swap (instruction.mnemonic), SkipCurrent ();
	if (!instruction.label.empty ()) while (IsCurrent (Lexer::Identifier) && ExpandMacro ());

	if (instruction.mnemonic.empty ())
		if (IsCurrent (Lexer::Identifier))
			instruction.mnemonic.swap (current.string), SkipCurrent ();
		else if (IsCurrent (Lexer::Equals) && instruction.label.empty ())
			EmitError (current, "unlabeled constant definition");
		else if (IsCurrent (Lexer::Reserve) || IsCurrent (Lexer::Equals) || IsCurrent (Lexer::Embed))
			return ParseDirective (instruction, &Context::ParseSingle);
		else if (IsCurrent (Lexer::Byte) || IsCurrent (Lexer::DByte) || IsCurrent (Lexer::TByte) || IsCurrent (Lexer::QByte) || IsCurrent (Lexer::OByte))
			return ParseDirective (instruction, &Context::Parse);
		else if (!IsCurrent (Lexer::Newline) && !IsCurrent (Lexer::Eof))
			EmitError (current, Format ("encountered %0 instead of instruction", current));

	instruction.directive = Lexer::Invalid;
	Parse (instruction.operands, Lexer::Newline);
	if (!IsCurrent (Lexer::Eof)) Parse (Lexer::Newline);
}

void Context::ParseLineDirective ()
{
	Parse (Lexer::Line); Expect (Lexer::Integer); const auto line = Evaluate (current, 10);
	if (!line || line > 2147483647) EmitError (current, Format ("invalid line number '%0'", line)); current.location.line = line;
	SkipCurrent (); if (IsCurrent (Lexer::String)) current.location.source = parser.stringPool.Insert (current.string), SkipCurrent ();
	current.location.line -= IsCurrent (Lexer::Newline);
}

void Context::ParseDirective (Instruction& instruction, void (Context::*const parse) (Expressions&))
{
	instruction.directive = current.symbol; SkipCurrent ();
	if (parse) (this->*parse) (instruction.operands);
	if (!IsCurrent (Lexer::Eof)) Parse (Lexer::Newline);
}

void Context::ParseSingle (Expressions& operands)
{
	Parse (operands.emplace_back ());
}

void Context::ParseOptional (Expressions& operands)
{
	if (!IsCurrent (Lexer::Newline) && !IsCurrent (Lexer::Eof)) Parse (operands);
}

void Context::Parse (Expressions& operands)
{
	for (ParseSingle (operands); IsCurrent (Lexer::Comma); operands.back ().separated = true) SkipCurrent (), ParseSingle (operands);
}

void Context::Parse (Expressions& operands, const Lexer::Symbol sentinel)
{
	while (!IsCurrent (sentinel) && !IsCurrent (Lexer::Newline) && !IsCurrent (Lexer::Eof)) Parse (operands);
}

void Context::Parse (Expression& expression)
{
	ParseLogicalOr (expression);
	while (IsCurrent (Lexer::Colon)) ParseBinary (expression, &Context::ParseLogicalOr);
}

void Context::ParseLogicalOr (Expression& expression)
{
	ParseLogicalAnd (expression);
	while (IsCurrent (Lexer::LogicalOr)) ParseBinary (expression, &Context::ParseLogicalAnd);
}

void Context::ParseLogicalAnd (Expression& expression)
{
	ParseInclusiveOr (expression);
	while (IsCurrent (Lexer::LogicalAnd)) ParseBinary (expression, &Context::ParseInclusiveOr);
}

void Context::ParseInclusiveOr (Expression& expression)
{
	ParseExclusiveOr (expression);
	while (IsCurrent (Lexer::BitwiseOr)) ParseBinary (expression, &Context::ParseExclusiveOr);
}

void Context::ParseExclusiveOr (Expression& expression)
{
	ParseAnd (expression);
	while (IsCurrent (Lexer::BitwiseXor)) ParseBinary (expression, &Context::ParseAnd);
}

void Context::ParseAnd (Expression& expression)
{
	ParseIdentical (expression);
	while (IsCurrent (Lexer::BitwiseAnd)) ParseBinary (expression, &Context::ParseIdentical);
}

void Context::ParseIdentical (Expression& expression)
{
	ParseEquality (expression);
	while (IsCurrent (Lexer::Identical) || IsCurrent (Lexer::Unidentical)) ParseBinary (expression, &Context::ParseEquality);
}

void Context::ParseEquality (Expression& expression)
{
	ParseRelational (expression);
	while (IsCurrent (Lexer::Equal) || IsCurrent (Lexer::Unequal)) ParseBinary (expression, &Context::ParseRelational);
}

void Context::ParseRelational (Expression& expression)
{
	ParseShift (expression);
	while (IsCurrent (Lexer::Less) || IsCurrent (Lexer::LessEqual) || IsCurrent (Lexer::Greater) || IsCurrent (Lexer::GreaterEqual)) ParseBinary (expression, &Context::ParseShift);
}

void Context::ParseShift (Expression& expression)
{
	ParseAdditive (expression);
	while (IsCurrent (Lexer::LeftShift) || IsCurrent (Lexer::RightShift)) ParseBinary (expression, &Context::ParseAdditive);
}

void Context::ParseAdditive (Expression& expression)
{
	ParseMultiplicative (expression);
	if (IsCurrent (Lexer::Plus)) ParseBinary (expression, &Context::ParseAdditive);
	while (IsCurrent (Lexer::Plus) || IsCurrent (Lexer::Minus)) ParseBinary (expression, &Context::ParseMultiplicative);
}

void Context::ParseMultiplicative (Expression& expression)
{
	ParseUnary (expression);
	while (IsCurrent (Lexer::Times) || IsCurrent (Lexer::Slash) || IsCurrent (Lexer::Modulo)) ParseBinary (expression, &Context::ParseUnary);
}

void Context::ParseBinary (Expression& expression, void (Context::*const parse) (Expression&))
{
	Expression operand {std::move (expression)}; expression.model = Expression::BinaryOperation; expression.operation = current.symbol; expression.string.clear ();
	expression.operands.clear (); expression.operands.push_back (std::move (operand)); SkipCurrent (); (this->*parse) (expression.operands.emplace_back ());
}

void Context::ParseUnary (Expression& expression)
{
	if (!IsCurrent (Lexer::LogicalNot) && !IsCurrent (Lexer::BitwiseNot) && !IsCurrent (Lexer::Plus) && !IsCurrent (Lexer::Minus)) return ParsePrimary (expression), ParsePostfix (expression);
	expression.model = Expression::UnaryOperation; expression.operation = current.symbol; SkipCurrent (); ParseUnary (expression.operands.emplace_back ());
}

void Context::ParsePostfix (Expression& expression)
{
	if (!IsCurrent (Lexer::LogicalNot) && !IsCurrent (Lexer::BitwiseXor) && !IsCurrent (Lexer::Plus) && !IsCurrent (Lexer::Minus)) return; const auto token = current; SkipCurrent ();
	if (!IsCurrent (token.symbol) && !IsCurrent (Lexer::Comma) && !IsCurrent (Lexer::Newline) && !IsCurrent (Lexer::Eof)) return tokens.push_front (current), void (current = token);
	Expression operand {std::move (expression)}; expression.model = Expression::PostfixOperation; expression.operation = token.symbol; expression.string.clear ();
	expression.operands.clear (); expression.operands.push_back (std::move (operand)); ParsePostfix (expression);
}

void Context::ParsePrimary (Expression& expression)
{
	if (IsCurrent (Lexer::Integer) || IsCurrent (Lexer::DecInteger))
		ParseNumber (expression, 10);
	else if (IsCurrent (Lexer::BinInteger))
		ParseNumber (expression, 2);
	else if (IsCurrent (Lexer::OctInteger))
		ParseNumber (expression, 8);
	else if (IsCurrent (Lexer::HexInteger))
		ParseNumber (expression, 16);
	else if (IsCurrent (Lexer::Character))
		ParseLiteral (expression, Expression::Character);
	else if (IsCurrent (Lexer::String))
		ParseLiteral (expression, Expression::String);
	else if (IsCurrent (Lexer::Address))
		ParseLiteral (expression, Expression::Address);
	else if (IsCurrent (Lexer::Real))
		ParseLiteral (expression, Expression::Identity);
	else if (IsCurrent (Lexer::Identifier))
	{
		ParseLiteral (expression, Expression::Identifier);
		if (IsCurrent (Lexer::LeftParen)) if (const auto operation = Lexer::Convert (expression.string, Lexer::FirstFunction, Lexer::LastFunction, Lexer::Invalid)) ParseFunctional (expression, operation);
	}
	else if (IsCurrent (Lexer::LeftParen) || IsCurrent (Lexer::LeftBracket) || IsCurrent (Lexer::LeftBrace))
		ParseParenthesized (expression);
	else if (IsCurrent (Lexer::Alignment) || IsCurrent (Lexer::Origin) || IsCurrent (Lexer::Group) ||
		IsCurrent (Lexer::Required) || IsCurrent (Lexer::Duplicable) || IsCurrent (Lexer::Replaceable) ||
		IsCurrent (Lexer::Little) || IsCurrent (Lexer::Big) || IsCurrent (Lexer::BitMode))
		ParseNullary (expression);
	else
		EmitError (current, Format ("encountered %0 instead of expression", current));
}

void Context::ParseNumber (Expression& expression, const Base base)
{
	expression.model = Expression::Number; expression.value = Evaluate (current, base); SkipCurrent ();
}

void Context::ParseLiteral (Expression& expression, const Expression::Model model)
{
	expression.model = model; expression.string.swap (current.string); SkipCurrent ();
}

void Context::ParseFunctional (Expression& expression, const Expression::Operation operation)
{
	expression.model = Expression::FunctionalOperation; expression.operation = operation;
	Parse (Lexer::LeftParen); ParseSingle (expression.operands); Parse (Lexer::RightParen);
}

void Context::ParseParenthesized (Expression& expression)
{
	expression.model = Expression::Parenthesized; expression.parenthesis = current.symbol; SkipCurrent ();
	const auto sentinel = Lexer::Symbol (expression.parenthesis + 1); Parse (expression.operands, sentinel); Parse (sentinel);
}

void Context::ParseNullary (Expression& expression)
{
	expression.model = Expression::NullaryOperation; expression.operation = current.symbol; SkipCurrent ();
}

Expression::Value Context::Evaluate (const Lexer::Token& literal, const Base base) const
{
	assert (!literal.string.empty ()); const auto begin = literal.string.c_str ();
	errno = 0; char* end; const auto value = std::strtoull (begin, &end, base);
	if (errno != ERANGE && end == begin + literal.string.size ()) return value;
	EmitError (literal, Format ("invalid %0 literal '%1'", literal.symbol, literal.string));
}

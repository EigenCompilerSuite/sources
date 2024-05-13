// Generic assembly language semantic checker
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

#include "asmchecker.hpp"
#include "assembly.hpp"
#include "charset.hpp"
#include "error.hpp"
#include "format.hpp"
#include "utilities.hpp"

#include <map>

using namespace ECS;
using namespace Assembly;

using Context =
	#include "asmcheckercontext.hpp"

Checker::Checker (Diagnostics& d, Charset& c) :
	diagnostics {d}, charset {c}
{
}

Context::Context (const Checker& c, Object::Section& s, const Origin o, const InstructionAlignment ia, const SectionAlignment sa, const Inlined i) :
	charset {c.charset}, instructionAlignment {ia}, sectionAlignment {sa}, inlined {i}, diagnostics {c.diagnostics}, section {s}, origin {o}
{
	assert (IsPowerOfTwo (instructionAlignment)); assert (IsPowerOfTwo (sectionAlignment));
}

void Context::EmitError (const Message& message) const
{
	location->Emit (Diagnostics::Error, diagnostics, message); throw Error {};
}

void Context::Process (const Instructions& instructions)
{
	sizes.resize (instructions.size ()); Reset ();
	Batch (instructions, [this] (const Instruction& instruction) {Label (instruction);});
	if (!conditionals.empty ()) EmitError (Format ("missing %0 directive", Lexer::Endif));
	Batch (instructions, [this] (const Instruction& instruction) {Process (instruction);});
	assert (conditionals.empty ()); Reset (); parsing = false;
	Batch (instructions, [this] (const Instruction& instruction) {Process (instruction);});
	assert (conditionals.empty ()); Reset ();
}

void Context::Label (const Instruction& instruction)
{
	location = &instruction.location;
	if (IsConditional (instruction.directive)) return ProcessDirective (instruction);
	if (instruction.label.empty () || conditional != Including && conditional != IncludingElse) return;
	if (instruction.directive == Lexer::Equals) CheckDefinition (instruction.label, instruction.operands.front ());

	if (const auto definition = definitions.find (instruction.label); definition == definitions.end ())
		if (Expression value; GetDefinition (instruction.label, value)) EmitError (Format ("reserved label '%0'", instruction.label));
		else definitions.emplace (instruction.label, instruction.directive == Lexer::Equals ? instruction.operands.front () : Expression {Expression::Label, 0});
	else if (instruction.directive != Lexer::Equals || !Compare (definition->second, instruction.operands.front ()))
		EmitError (Format ("duplicated label '%0'", instruction.label));
}

void Context::Process (const Instruction& instruction)
{
	const auto origin = offset; location = &instruction.location;

	if (parsing && !instruction.label.empty () && instruction.directive != Lexer::Equals)
		definitions[instruction.label].value = offset;

	if (conditional == Including || conditional == IncludingElse)
		if (instruction.directive) ProcessDirective (instruction);
		else if (offset % instructionAlignment) EmitError ("misaligned instruction");
		else if (!instruction.mnemonic.empty ()) Assemble (instruction); else;
	else if (IsConditional (instruction.directive)) ProcessDirective (instruction);

	if (parsing) *size++ = offset - origin;
	else if (offset - origin != *size++) EmitError ("resized instruction");
}

void Context::Reset ()
{
	assert (conditional == Including); offset = origin; size = sizes.data ();
}

void Context::Reserve (const Size size)
{
	offset += size;
}

void Context::ProcessDirective (const Instruction& instruction)
{
	switch (instruction.directive)
	{
	case Lexer::Alignment:
		if (inlined) break;
		assert (instruction.operands.size () == 1);
		return ProcessAlignmentDirective (instruction.operands.front ());

	case Lexer::Assert:
		assert (instruction.operands.size () == 1);
		if (!parsing && !Evaluate (instruction.operands.front ()))
			EmitError (Format ("static assertion '%0' failed", instruction.operands.front ()));
		return;

	case Lexer::Equals:
		assert (!instruction.label.empty ());
		assert (instruction.operands.size () == 1);
		return;

	case Lexer::Required:
		if (inlined) break;
		assert (instruction.operands.empty ());
		if (parsing && section.required) EmitError ("section already marked as required");
		section.required = true;
		return;

	case Lexer::Duplicable:
		if (inlined) break;
		assert (instruction.operands.empty ());
		if (parsing && section.duplicable) EmitError ("section already marked as duplicable");
		section.duplicable = true;
		return;

	case Lexer::Replaceable:
		if (inlined) break;
		assert (instruction.operands.empty ());
		if (parsing && section.replaceable) EmitError ("section already marked as replaceable");
		section.replaceable = true;
		return;

	case Lexer::Origin:
		if (inlined) break;
		assert (instruction.operands.size () == 1);
		return ProcessOriginDirective (instruction.operands.front ());

	case Lexer::Group:
		if (inlined) break;
		assert (instruction.operands.size () == 1);
		return ProcessGroupDirective (instruction.operands.front ());

	case Lexer::Trace:
		if (parsing) return;
		if (!instruction.operands.empty ()) for (auto& operand: instruction.operands) ProcessTraceDirective (operand);
		else for (auto& definition: definitions) ProcessTraceDirective ({Expression::Identifier, definition.first});
		return;

	case Lexer::If:
		conditionals.push_back (conditional);
		assert (instruction.operands.size () == 1);
		if (conditional != Including && conditional != IncludingElse) conditional = Ignoring;
		else conditional = Evaluate (instruction.operands.front ()) ? Including : Skipping;
		return;

	case Lexer::Elif:
		assert (instruction.operands.size () == 1);
		switch (conditional)
		{
		case Including: if (conditionals.empty ()) break; conditional = Ignoring; return;
		case Skipping: conditional = Evaluate (instruction.operands.front ()) ? Including : Skipping; return;
		case Ignoring: return;
		}
		break;

	case Lexer::Else:
		switch (conditional)
		{
		case Including: if (conditionals.empty ()) break;
		case Ignoring: conditional = IgnoringElse; return;
		case Skipping: conditional = IncludingElse; return;
		}
		break;

	case Lexer::Endif:
		if (conditionals.empty ()) break;
		conditional = conditionals.back ();
		return conditionals.pop_back ();
	}

	EmitError (Format ("illegal %0 directive", instruction.directive));
}

bool Context::GetIdentifier (const Expression& expression, Identifier& identifier) const
{
	if (IsString (expression)) return identifier = expression.string, true;
	if (IsGroup (expression)) return identifier = section.group, parsing || !section.group.empty ();
	if (IsParenthesized (expression)) return GetIdentifier (expression.operands.front (), identifier);
	if (!IsIdentifier (expression)) return false; Expression definition;
	if (GetDefinition (expression.string, definition)) return GetIdentifier (definition, identifier);
	return identifier = expression.string, true;
}

bool Context::GetString (const Expression& expression, String& string) const
{
	if (!IsIdentifier (expression)) return GetIdentifier (expression, string);
	Expression definition; return GetDefinition (expression.string, definition) && GetString (definition, string);
}

void Context::ProcessAlignmentDirective (const Expression& expression) const
{
	if (section.fixed) EmitError ("aligning fixed section");
	if (parsing && section.alignment) EmitError ("section alignment already defined");
	Value value; if (!GetValue (expression, value) || value <= 0 || value >= 0x10000000 || !IsPowerOfTwo (value) || value % sectionAlignment) EmitError ("invalid section alignment");
	if (!parsing && section.alignment != Section::Alignment (value)) EmitError ("modified section alignment");
	section.alignment = value;
}

void Context::ProcessOriginDirective (const Expression& expression) const
{
	if (!section.fixed && section.alignment) EmitError ("fixing aligned section");
	if (parsing && section.fixed) EmitError ("section origin already defined");
	Value value; if (!GetValue (expression, value) || value < 0 || value > 0xc0000000 || value % sectionAlignment) EmitError ("invalid section origin");
	if (!parsing && section.origin != Section::Origin (value)) EmitError ("modified section origin");
	section.fixed = true; section.origin = value;
}

void Context::ProcessGroupDirective (const Expression& expression) const
{
	if (parsing && !section.group.empty ()) EmitError ("section group already defined");
	Identifier identifier; if (!GetIdentifier (expression, identifier) || identifier.empty ()) EmitError ("invalid section group");
	if (!parsing && section.group != identifier) EmitError ("modified section group");
	section.group = identifier;
}

void Context::CheckDefinition (const Identifier& identifier, const Expression& expression)
{
	switch (expression.model)
	{
	case Expression::Label:
	case Expression::Number:
	case Expression::Character:
	case Expression::String:
	case Expression::Address:
	case Expression::Identity:
	case Expression::NullaryOperation:
		break;

	case Expression::Identifier:
		if (expression.string == identifier) definitions.erase (identifier), EmitError (Format ("recursive definition of '%0'", identifier));
		if (Expression definition; GetDefinition (expression.string, definition)) CheckDefinition (identifier, definition);
		break;

	case Expression::UnaryOperation:
	case Expression::BinaryOperation:
	case Expression::PostfixOperation:
	case Expression::FunctionalOperation:
	case Expression::Parenthesized:
		for (auto& operand: expression.operands) CheckDefinition (identifier, operand);
		break;

	default:
		assert (Expression::Unreachable);
	}
}

void Context::Assemble (const Instruction& instruction)
{
	std::stringstream stream; stream << instruction.mnemonic;
	const std::streamoff mnemonic = stream.tellp (); Link link;
	for (auto& operand: instruction.operands)
	{
		if (operand.separated) stream << Lexer::Comma; stream << ' ';
		if (Value value; GetOffset (operand, value)) stream << std::showpos << value << std::noshowpos;
		else if (IsIdentity (operand)) assert (!operand.operands.empty ()), Rewrite (stream << operand.operation, operand.operands.front ());
		else if (link.name.empty ()) Rewrite (stream, operand, link); else Rewrite (stream, operand);
	}

	const auto size = AssembleInstruction (stream, link);
	if (!stream || stream.good () && stream >> std::ws && !stream.eof ())
		EmitError ((stream.clear (), stream.tellg () <= mnemonic) ? Format ("invalid mnemonic '%0'", instruction.mnemonic) : Format ("invalid operand in '%0'", stream.str ()));
	if (size == 0) EmitError (Format ("invalid instruction '%0'", stream.str ()));
	Reserve (size);
}

void Context::ProcessTraceDirective (const Expression& expression) const
{
	std::ostringstream stream; Rewrite (IsString (expression) ? stream : stream << '\'' << expression << "' = ", expression);
	location->Emit (Diagnostics::Note, diagnostics, stream.str ());
}

bool Context::GetDefinition (const Identifier& identifier, Expression& expression) const
{
	const auto definition = definitions.find (identifier);
	if (definition != definitions.end ()) return expression = definition->second, true;
	return false;
}

bool Context::Compare (const Expression& left, const Expression& right) const
{
	Expression definition;
	if (IsIdentifier (left) && GetDefinition (left.string, definition)) return Compare (definition, right);
	if (IsIdentifier (right) && GetDefinition (right.string, definition)) return Compare (left, definition);

	if (left.model != right.model || left.separated != right.separated) return false;

	switch (left.model)
	{
	case Expression::Label:
	case Expression::Number:
		return left.value == right.value;

	case Expression::Character:
	case Expression::String:
	case Expression::Address:
	case Expression::Identity:
	case Expression::Identifier:
		return left.string == right.string;

	case Expression::NullaryOperation:
	case Expression::UnaryOperation:
	case Expression::BinaryOperation:
	case Expression::PostfixOperation:
	case Expression::FunctionalOperation:
		return left.operation == right.operation && Compare (left.operands, right.operands);

	case Expression::Parenthesized:
		return left.parenthesis == right.parenthesis && Compare (left.operands, right.operands);

	default:
		assert (Expression::Unreachable);
	}
}

bool Context::Compare (const Expressions& left, const Expressions& right) const
{
	return std::equal (left.begin (), left.end (), right.begin (), right.end (), [this] (const Expression& left, const Expression& right) {return Compare (left, right);});
}

std::ostream& Context::Rewrite (std::ostream& stream, const Expression& expression, Link& link) const
{
	assert (link.name.empty ());

	switch (expression.model)
	{
	case Expression::Label:
	case Expression::Number:
	case Expression::Character:
	case Expression::String:
	case Expression::Address:
	case Expression::Identity:
	case Expression::Identifier:
	case Expression::UnaryOperation:
	case Expression::NullaryOperation:
	case Expression::PostfixOperation:
	case Expression::FunctionalOperation:
		break;

	case Expression::BinaryOperation:
		assert (expression.operands.size () == 2);
		if (!IsIdentifier (expression.operands.front ())) break;
		if (!GetLink (expression.operands.back (), link)) return Rewrite (stream, expression);
		return stream << expression.operands.front () << expression.operation << 0;

	case Expression::Parenthesized:
		if (expression.operands.size () != 1) return Rewrite (stream, expression);
		return Rewrite (stream << expression.parenthesis, expression.operands.front (), link) << Lexer::Symbol (expression.parenthesis + 1);

	default:
		assert (Expression::Unreachable);
	}

	return GetLink (expression, link) ? stream << 0 : Rewrite (stream, expression);
}

std::ostream& Context::Rewrite (std::ostream& stream, const Expression& expression) const
{
	if (IsNumber (expression)) return stream << expression.value; Expression definition;
	if (IsIdentifier (expression)) return GetDefinition (expression.string, definition) ? Rewrite (stream, definition) : stream << expression;
	if (!IsParenthesized (expression) && GetString (expression, definition.string)) return WriteString (stream, definition.string, '"'); Value value;
	if (GetValue (expression, value)) return stream << value;

	switch (expression.model)
	{
	case Expression::Address:
	case Expression::Identity:
	case Expression::NullaryOperation:
		return stream << expression;

	case Expression::UnaryOperation:
		assert (expression.operands.size () == 1);
		return Rewrite (stream << expression.operation, expression.operands.front ());

	case Expression::BinaryOperation:
		assert (expression.operands.size () == 2);
		return Rewrite (Rewrite (stream, expression.operands.front ()) << expression.operation, expression.operands.back ());

	case Expression::PostfixOperation:
		assert (expression.operands.size () == 1);
		return Rewrite (stream, expression.operands.front ()) << expression.operation;

	case Expression::FunctionalOperation:
		assert (expression.operands.size () == 1);
		return Rewrite (stream << expression.operation << Lexer::LeftParen, expression.operands.front ()) << Lexer::RightParen;

	case Expression::Parenthesized:
		stream << expression.parenthesis;
		for (auto& operand: expression.operands) Rewrite (operand.separated ? stream << Lexer::Comma : IsFirst (operand, expression.operands) ? stream : stream << ' ', operand);
		return stream << Lexer::Symbol (expression.parenthesis + 1);

	default:
		assert (Expression::Unreachable);
	}
}

bool Context::Evaluate (const Expression& expression) const
{
	Value value; if (!GetValue (expression, value)) EmitError ("invalid condition"); return value;
}

bool Context::GetValue (const Expression& expression, Value& value) const
{
	switch (expression.model)
	{
	case Expression::Label:
	case Expression::Number:
		return value = expression.value, true;

	case Expression::Character:
		assert (!expression.string.empty ());
		return value = charset.Encode (expression.string[0]), true;

	case Expression::String:
	case Expression::Address:
	case Expression::Identity:
	case Expression::PostfixOperation:
		return false;

	case Expression::Identifier:
	{
		Expression definition;
		return GetDefinition (expression.string, definition) && GetValue (definition, value);
	}

	case Expression::NullaryOperation:
		assert (expression.operands.empty ());

		switch (expression.operation) {
		case Lexer::Alignment: return value = !section.fixed ? section.alignment : 0, parsing || !section.fixed && section.alignment;
		case Lexer::Origin: return value = section.fixed ? section.origin : 0, parsing || section.fixed;
		case Lexer::Required: return value = section.required, true;
		case Lexer::Duplicable: return value = section.duplicable, true;
		case Lexer::Replaceable: return value = section.replaceable, true;
		default: return false;
		}

	case Expression::UnaryOperation:
		assert (expression.operands.size () == 1);
		if (!GetValue (expression.operands.front (), value)) return false;

		switch (expression.operation) {
		case Lexer::LogicalNot: return value = !value, true;
		case Lexer::BitwiseNot: return value = ~value, true;
		case Lexer::Plus: return value = +value, true;
		case Lexer::Minus: return value = -value, true;
		default: return false;
		}

	case Expression::BinaryOperation:
	{
		assert (expression.operands.size () == 2);
		if (expression.operation == Lexer::Identical) return value = Compare (expression.operands.front (), expression.operands.back ()), true;
		if (expression.operation == Lexer::Unidentical) return value = !Compare (expression.operands.front (), expression.operands.back ()), true;

		Value left; if (!GetValue (expression.operands.front (), left)) return false;
		if (expression.operation == Lexer::LogicalOr && left) return value = true, true;
		if (expression.operation == Lexer::LogicalAnd && !left) return value = false, true;
		Value right; if (!GetValue (expression.operands.back (), right)) return false;

		switch (expression.operation) {
		case Lexer::Times: return value = left * right, true;
		case Lexer::Slash: return right ? value = left / right, true : false;
		case Lexer::Modulo: return right ? value = left % right, true : false;
		case Lexer::Plus: return value = left + right, true;
		case Lexer::Minus: return value = parsing && right > left ? 0 : left - right, true;
		case Lexer::LeftShift: return value = ShiftLeft (left, right), true;
		case Lexer::RightShift: return value = ShiftRight (left, right), true;
		case Lexer::Less: return value = left < right, true;
		case Lexer::LessEqual: return value = left <= right, true;
		case Lexer::Greater: return value = left > right, true;
		case Lexer::GreaterEqual: return value = left >= right, true;
		case Lexer::Equal: return value = left == right, true;
		case Lexer::Unequal: return value = left != right, true;
		case Lexer::BitwiseAnd: return value = left & right, true;
		case Lexer::BitwiseXor: return value = left ^ right, true;
		case Lexer::BitwiseOr: return value = left | right, true;
		case Lexer::LogicalOr: return value = left || right, true;
		case Lexer::LogicalAnd: return value = left && right, true;
		default: return false;
		}
	}

	case Expression::FunctionalOperation:
		assert (expression.operands.size () == 1);

		switch (expression.operation) {
		case Lexer::Offset: return GetOffset (expression.operands.front (), value);
		default: return false;
		}

	case Expression::Parenthesized:
		return IsParenthesized (expression) && GetValue (expression.operands.front (), value);

	default:
		assert (Expression::Unreachable);
	}
}

bool Context::GetOffset (const Expression& expression, Value& value) const
{
	if (IsLabel (expression)) return value = (expression.value - offset) * !parsing - GetDisplacement (*size), true;
	if (IsParenthesized (expression)) return GetOffset (expression.operands.front (), value); Expression definition;
	return IsIdentifier (expression) && GetDefinition (expression.string, definition) && GetOffset (definition, value);
}

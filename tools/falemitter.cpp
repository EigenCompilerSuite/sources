// FALSE intermediate code emitter
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

#include "cdemittercontext.hpp"
#include "falemitter.hpp"
#include "false.hpp"

#include <set>

using namespace ECS;
using namespace Code;
using namespace FALSE;

using Context = class FALSE::Emitter::Context : Code::Emitter::Context
{
public:
	Context (const FALSE::Emitter&, const Program&, Sections&);

	void Emit ();

private:
	const Emitter& emitter;
	const Program& program;

	bool variables[26] {};
	std::set<std::string> strings;
	Function::size_type function = 0;

	void Save (const Operand&);
	SmartOperand Restore ();

	void Emit (const Element&);
	void Emit (const Function&);
	void EmitBinary (SmartOperand (Context::*) (const Operand&, const Operand&, Hint));
	void EmitComparison (void (Context::*) (const Label&, const Operand&, const Operand&));

	Section::Name DefineFunction (const Element&);
	Section::Name DefineString (const Element&);
	Section::Name DefineVariable (const Element&);
};

void FALSE::Emitter::Emit (const Program& program, Sections& sections) const
{
	Context {*this, program, sections}.Emit ();
}

Context::Context (const FALSE::Emitter& e, const Program& p, Sections& s) :
	Code::Emitter::Context {e, s}, emitter {e}, program {p}
{
}

void Context::Emit ()
{
	Begin (Section::Code, Section::EntryPoint);

	Comment ("reserve temporary address space");
	Enter (platform.GetStackSize (platform.pointer) * 32);

	Comment ("push termination code");
	Push (PtrImm {platform.pointer, 0});

	Emit (program.main);

	Comment ("use stack top as termination code");
	Convert (MakeMemory (platform.integer, emitter.stackPointer, platform.stackDisplacement), MakeMemory (platform.pointer, emitter.stackPointer, platform.stackDisplacement));
	Call (Adr {platform.function, "_Exit"}, 0);
}

void Context::Emit (const FALSE::Function& function)
{
	for (auto& element: function) Emit (element);
}

void Context::Emit (const Element& element)
{
	if (element.string.find ('\n') != element.string.npos) Comment (element.position, element.symbol); else Comment (element.position, element);

	switch (element.symbol)
	{
	case Lexer::Assign: {auto address = Pop (platform.pointer); Move (MakeMemory (platform.pointer, address), Pop (platform.pointer)); break;}
	case Lexer::Call: Push (Call (platform.pointer, Pop (platform.function), 0)); break;
	case Lexer::If: {auto function = Pop (platform.function); auto skip = CreateLabel (); BranchEqual (skip, Pop (platform.pointer), PtrImm {platform.pointer, false}); Push (Call (platform.pointer, function, 0)); skip (); break;}
	case Lexer::While: {Save (Pop (platform.function)); Save (Pop (platform.function)); auto begin = CreateLabel (), end = CreateLabel (); begin ();
		BranchEqual (end, Call (platform.pointer, MakeMemory (platform.function, emitter.framePointer, platform.stackDisplacement), 0), PtrImm {platform.pointer, false});
		Push (Call (platform.pointer, MakeMemory (platform.function, emitter.framePointer, platform.GetStackSize (platform.function) + platform.stackDisplacement), 0));
		Branch (begin); end (); Increment (emitter.framePointer, platform.GetStackAlignment (platform.function) * 2); break;}
	case Lexer::Write: Pop (platform.pointer); break;
	case Lexer::Put: Call (Adr {platform.function, "putchar"}, Push (Convert (platform.integer, Pop (platform.pointer)))); break;
	case Lexer::Get: Push (Convert (platform.pointer, Call (platform.integer, Adr {platform.function, "getchar"}, 0))); break;
	case Lexer::Flush: Call (Adr {platform.function, "fflush"}, Push (MakeMemory (platform.pointer, Adr {platform.pointer, "stdout"}))); break;
	case Lexer::Dereference: Push (MakeMemory (platform.pointer, Pop (platform.pointer))); break;
	case Lexer::BeginFunction: Push (Adr {platform.function, DefineFunction (element)}); break;
	case Lexer::Negate: Push (Convert (platform.pointer, Negate (Convert (platform.integer, Pop (platform.pointer))))); break;
	case Lexer::Add: {auto value2 = Pop (platform.pointer), value1 = Pop (platform.pointer); Push (Add (value1, value2)); break;}
	case Lexer::Subtract: {auto value2 = Pop (platform.pointer), value1 = Pop (platform.pointer); Push (Subtract (value1, value2)); break;}
	case Lexer::Multiply: EmitBinary (&Context::Multiply); break;
	case Lexer::Divide: EmitBinary (&Context::Divide); break;
	case Lexer::Not: Push (Convert (platform.pointer, And (Complement (Convert (platform.integer, Pop (platform.pointer))), SImm {platform.integer, 1}))); break;
	case Lexer::And: EmitBinary (&Context::And); break;
	case Lexer::Or: EmitBinary (&Context::Or); break;
	case Lexer::Equal: EmitComparison (&Context::BranchNotEqual); break;
	case Lexer::Greater: EmitComparison (&Context::BranchLessThan); break;
	case Lexer::Duplicate: Push (MakeMemory (platform.pointer, emitter.stackPointer, platform.stackDisplacement)); break;
	case Lexer::Delete: Increment (emitter.stackPointer, platform.GetStackSize (platform.pointer)); break;
	case Lexer::Swap: {auto value2 = Pop (platform.pointer), value1 = Pop (platform.pointer); Push (value2); Push (value1); break;}
	case Lexer::Rotate: {auto value3 = Pop (platform.pointer), value2 = Pop (platform.pointer), value1 = Pop (platform.pointer); Push (value2); Push (value3); Push (value1); break;}
	case Lexer::Select: Push (MakeMemory (platform.pointer, Add (Multiply (Pop (platform.pointer), PtrImm {platform.pointer, platform.GetStackSize (platform.pointer)}), emitter.stackPointer), platform.stackDisplacement)); break;
	case Lexer::Integer: Push (PtrImm {platform.pointer, Truncate (Pointer::Value (element.integer), platform.pointer.size * 8)}); break;
	case Lexer::Character: Push (PtrImm {platform.pointer, emitter.charset.Encode (element.character)}); break;
	case Lexer::Variable: Push (Adr {platform.pointer, DefineVariable (element)}); break;
	case Lexer::String: Call (Adr {platform.function, "puts"}, Push (Adr {platform.pointer, DefineString (element)})); break;
	case Lexer::ExternalVariable: Push (Adr {platform.pointer, element.string}); break;
	case Lexer::ExternalFunction: Push (Adr {platform.function, element.string}); break;
	case Lexer::Assembly: Assemble (program.source, GetLine (element.position), element.string); break;
	default: assert (Lexer::Unreachable);
	}
}

void Context::EmitBinary (SmartOperand (Context::*const operation) (const Operand&, const Operand&, Hint))
{
	auto value2 = Convert (platform.integer, Pop (platform.pointer));
	auto value1 = Convert (platform.integer, Pop (platform.pointer));
	Push (Convert (platform.pointer, (this->*operation) (value1, value2, RVoid)));
}

void Context::EmitComparison (void (Context::*const branch) (const Label&, const Operand&, const Operand&))
{
	auto skip = CreateLabel (), end = CreateLabel ();
	auto value2 = Convert (platform.integer, Pop (platform.pointer));
	auto value1 = Convert (platform.integer, Pop (platform.pointer));
	(this->*branch) (skip, value1, value2);
	Push (PtrImm {platform.pointer, true}); Branch (end); skip ();
	Push (PtrImm {platform.pointer, false}); end ();
}

void Context::Save (const Operand& operand)
{
	Decrement (emitter.framePointer, platform.GetStackSize (operand.type));
	Move (MakeMemory (operand.type, emitter.framePointer, platform.stackDisplacement), operand);
}

Context::SmartOperand Context::Restore ()
{
	auto result = MakeRegister (MakeMemory (platform.function, emitter.framePointer, platform.stackDisplacement));
	Increment (emitter.framePointer, platform.GetStackSize (platform.function));
	return result;
}

Section::Name Context::DefineFunction (const Element& element)
{
	const RestoreState restoreState {*this}; Comment (element.position, element);
	const auto& section = Begin (Section::Code, "function" + std::to_string (function++));

	if (platform.return_.size) Comment ("save return address"), Save (platform.link.size ? emitter.linkRegister : Pop (platform.return_));

	Emit (*element.function);

	Comment ("return stack top");
	Pop (Reg {platform.pointer, RRes});
	if (platform.return_.size) Jump (Restore ()); else Return ();
	return section.name;
}

Section::Name Context::DefineVariable (const Element& element)
{
	const Section::Name name {element.character}; if (variables[element.character - 'a']) return name;
	const RestoreState restoreState {*this}; Comment (element.position, element);
	Begin (Section::Data, name, platform.GetAlignment (platform.pointer));
	Reserve (platform.pointer.size); variables[element.character - 'a'] = true; return name;
}

Section::Name Context::DefineString (const Element& element)
{
	const auto name = GetName (element.string); if (!strings.insert (element.string).second) return name;
	const RestoreState restoreState {*this}; Comment (element.position, element);
	Begin (Section::Const, name, platform.GetAlignment (Unsigned {1}), false, true);
	Define (element.string, Unsigned {1}); return name;
}

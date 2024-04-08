// Generic intermediate code emitter
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
#include "cdemitter.hpp"

#include <functional>

using namespace ECS;
using namespace Code;

using Context =
	#include "cdemittercontext.hpp"

template <typename Value>
struct Context::LeftShift
{
	Value operator () (const Value value1, const Value value2) {return ECS::ShiftLeft (value1, value2);}
};

template <typename Value>
struct Context::RightShift
{
	Value operator () (const Value value1, const Value value2) {return ECS::ShiftRight (value1, value2);}
};

void (Context::*const Context::add[]) (const Operand&, const Operand&, const Operand&) {&Context::Subtract, &Context::Add};
void (Context::*const Context::equal[]) (const Label&, const Operand&, const Operand&) {&Context::BranchNotEqual, &Context::BranchEqual};
void (Context::*const Context::less[]) (const Label&, const Operand&, const Operand&) {&Context::BranchGreaterEqual, &Context::BranchLessThan};

Emitter::Emitter (Diagnostics& d, StringPool& sp, Charset& c, Platform& p) :
	diagnostics {d}, charset {c}, platform {p}, stackPointer {p.pointer, RSP}, framePointer {p.pointer, RFP}, linkRegister {p.link, RLink}, parser {d, sp, true}, checker {d, c, p}
{
}

Context::Context (const Emitter& e, Sections& s) :
	platform {e.platform}, sections {s}, emitter {e}
{
}

Section& Context::Begin (const Section::Type type, const Section::Name& name, const Section::Alignment alignment, const Section::Required required, const Section::Duplicable duplicable, const Section::Replaceable replaceable)
{
	current->section = &sections.emplace_back (type, name, alignment, required, duplicable, replaceable);
	if (!current->comment.empty ()) current->comment.swap (current->section->comment); return *current->section;
}

Section& Context::BeginAssembly ()
{
	if (current->section && IsAssembly (*current->section)) return *current->section;
	current->section = &sections.emplace_back ();
	if (!current->comment.empty ()) current->comment.swap (current->section->comment); return *current->section;
}

void Context::Alias (const Section::Name& name)
{
	Emit (ALIAS {name});
}

void Context::Require (const Section::Name& name)
{
	Emit (REQ {name});
}

void Context::Define (const Operand& value)
{
	Emit (DEF {value});
}

void Context::Reserve (const Size size)
{
	if (!size) return; auto& instructions = current->section->instructions;
	if (!instructions.empty () && instructions.back ().mnemonic == Instruction::RES) instructions.back ().operand1.size += size; else Emit (RES {size});
}

void Context::Move (const Operand& target, const Operand& source)
{
	if (target == source) return;
	if (IsRegister (target) && HasRegister (source) && target.register_ == source.register_ && !IsAddress (source) && !IsMemory (source))
		if (source.displacement < 0) return Decrement (target, -source.displacement); else return Increment (target, source.displacement);
	Emit (MOV {target, source});
}

Context::SmartOperand Context::Move (const Operand& value, const Hint hint)
{
	auto result = AcquireRegister (value.type, hint); Move (result, value); return result;
}

void Context::Convert (const Operand& target, const Operand& source)
{
	if (target.type == source.type) return Move (target, source);
	if (IsImmediate (source)) return Move (target, Evaluate (source, target.type));
	Emit (CONV {target, source});
}

Context::SmartOperand Context::Convert (const Type& type, const Operand& value, const Hint hint)
{
	if (IsImmediate (value)) return Evaluate (value, type);
	auto result = ReuseRegister (value, type, hint); Convert (result, value); return result;
}

void Context::Copy (const Operand& target, const Operand& source, const Operand& size)
{
	if (target == source || IsZero (size)) return;
	Emit (COPY {target, source, size});
}

void Context::Fill (const Operand& target, const Operand& size, const Operand& value)
{
	if (!IsImmediate (size) || size.ptrimm > 2) return Emit (FILL {target, size, value});
	auto destination = MakeRegister (target); for (PtrImm::Value index = 0; index != size.ptrimm; ++index) Move (MakeMemory (value.type, destination, index * value.type.size), value);
}

void Context::Negate (const Operand& target, const Operand& value)
{
	Emit (Instruction::NEG, Evaluate<std::negate>, target, value);
}

Context::SmartOperand Context::Negate (const Operand& value, const Hint hint)
{
	return Apply (Instruction::NEG, Evaluate<std::negate>, value, hint);
}

void Context::Add (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value1) || IsZero (value2)) return Move (target, Add (value1, value2));
	if (IsNegative (value1) && !IsNegative (Negate (value1))) return Subtract (target, value2, Negate (value1));
	if (IsNegative (value2) && !IsNegative (Negate (value2))) return Subtract (target, value1, Negate (value2));
	Emit (Instruction::ADD, Evaluate<std::plus>, target, value1, value2);
}

Context::SmartOperand Context::Add (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value1)) return {current->uses, value2};
	if (IsZero (value2)) return {current->uses, value1};
	if (IsImmediate (value1) && IsPointer (value1.type)) return Add (value2, value1.ptrimm);
	if (IsImmediate (value2) && IsPointer (value2.type)) return Add (value1, value2.ptrimm);
	if (IsNegative (value1) && !IsNegative (Negate (value1))) return Subtract (value2, Negate (value1));
	if (IsNegative (value2) && !IsNegative (Negate (value2))) return Subtract (value1, Negate (value2));
	if (IsAddress (value1) && IsRegister (value2)) return {current->uses, Adr {value1.type, value1.address, value2.register_, value1.displacement}};
	if (IsAddress (value2) && IsRegister (value1)) return {current->uses, Adr {value2.type, value2.address, value1.register_, value2.displacement}};
	return Apply (Instruction::ADD, Evaluate<std::plus>, value1, value2, hint);
}

void Context::Subtract (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value1)) return Negate (target, value2);
	if (IsZero (value2) || value1 == value2) return Move (target, Subtract (value1, value2));
	if (IsNegative (value2) && !IsNegative (Negate (value2))) return Add (target, value1, Negate (value2));
	Emit (Instruction::SUB, Evaluate<std::minus>, target, value1, value2);
}

Context::SmartOperand Context::Subtract (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value1)) return Negate (value2);
	if (IsZero (value2)) return {current->uses, value1};
	if (value1 == value2) return Imm {value1.type, 0};
	if (IsImmediate (value2) && IsPointer (value2.type)) return Subtract (value1, value2.ptrimm);
	if (IsNegative (value2) && !IsNegative (Negate (value2))) return Add (value1, Negate (value2));
	return Apply (Instruction::SUB, Evaluate<std::minus>, value1, value2, hint);
}

void Context::Multiply (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value1) || IsOne (value1) || IsZero (value2) || IsOne (value2)) return Move (target, Multiply (value1, value2));
	if (IsMinusOne (value1)) return Negate (target, value2);
	if (IsMinusOne (value2)) return Negate (target, value1);
	Emit (Instruction::MUL, Evaluate<std::multiplies>, target, value1, value2);
}

Context::SmartOperand Context::Multiply (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value1)) return {current->uses, value1};
	if (IsOne (value1)) return {current->uses, value2};
	if (IsMinusOne (value1)) return Negate (value2);
	if (IsZero (value2)) return {current->uses, value2};
	if (IsOne (value2)) return {current->uses, value1};
	if (IsMinusOne (value2)) return Negate (value1);
	return Apply (Instruction::MUL, Evaluate<std::multiplies>, value1, value2, hint);
}

void Context::Divide (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value1) || IsOne (value2) || value1 == value2) return Move (target, Divide (value1, value2));
	if (IsMinusOne (value2)) return Negate (target, value1);
	Emit (Instruction::DIV, Evaluate<std::divides>, target, value1, value2);
}

Context::SmartOperand Context::Divide (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value1)) return {current->uses, value1};
	if (IsOne (value2)) return {current->uses, value1};
	if (IsMinusOne (value2)) return Negate (value1);
	if (value1 == value2) return Imm {value1.type, 1};
	return Apply (Instruction::DIV, Evaluate<std::divides>, value1, value2, hint);
}

void Context::Modulo (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value1) || IsOne (value2) || value1 == value2) return Move (target, Modulo (value1, value2));
	Emit (Instruction::MOD, EvaluateIntegral<std::modulus>, target, value1, value2);
}

Context::SmartOperand Context::Modulo (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value1)) return {current->uses, value1};
	if (IsOne (value2)) return Imm {value1.type, 0};
	if (value1 == value2) return {current->uses, value1};
	return Apply (Instruction::MOD, EvaluateIntegral<std::modulus>, value1, value2, hint);
}

void Context::Complement (const Operand& target, const Operand& value)
{
	Emit (Instruction::NOT, EvaluateIntegral<std::bit_not>, target, value);
}

Context::SmartOperand Context::Complement (const Operand& value, const Hint hint)
{
	return Apply (Instruction::NOT, EvaluateIntegral<std::bit_not>, value, hint);
}

void Context::And (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value1) || IsFull (value1) || IsZero (value2) || IsFull (value2) || value1 == value2) return Move (target, And (value1, value2));
	Emit (Instruction::AND, EvaluateIntegral<std::bit_and>, target, value1, value2);
}

Context::SmartOperand Context::And (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value1) || IsFull (value2)) return {current->uses, value1};
	if (IsZero (value2) || IsFull (value1)) return {current->uses, value2};
	if (value1 == value2) return {current->uses, value1};
	return Apply (Instruction::AND, EvaluateIntegral<std::bit_and>, value1, value2, hint);
}

void Context::Or (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value1) || IsFull (value1) || IsZero (value2) || IsFull (value2) || value1 == value2) return Move (target, Or (value1, value2));
	Emit (Instruction::OR, EvaluateIntegral<std::bit_or>, target, value1, value2);
}

Context::SmartOperand Context::Or (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value1) || IsFull (value2)) return {current->uses, value2};
	if (IsZero (value2) || IsFull (value1)) return {current->uses, value1};
	if (value1 == value2) return {current->uses, value1};
	return Apply (Instruction::OR, EvaluateIntegral<std::bit_or>, value1, value2, hint);
}

void Context::ExclusiveOr (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value1) || IsZero (value2) || value1 == value2) return Move (target, ExclusiveOr (value1, value2));
	Emit (Instruction::XOR, EvaluateIntegral<std::bit_xor>, target, value1, value2);
}

Context::SmartOperand Context::ExclusiveOr (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value1)) return {current->uses, value2};
	if (IsZero (value2)) return {current->uses, value1};
	if (value1 == value2) return Imm {value1.type, 0};
	return Apply (Instruction::XOR, EvaluateIntegral<std::bit_xor>, value1, value2, hint);
}

void Context::ShiftLeft (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value2)) return Move (target, ShiftLeft (value1, value2));
	Emit (Instruction::LSH, EvaluateIntegral<LeftShift>, target, value1, value2);
}

Context::SmartOperand Context::ShiftLeft (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value2)) return {current->uses, value1};
	return Apply (Instruction::LSH, EvaluateIntegral<LeftShift>, value1, value2, hint);
}

void Context::ShiftRight (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (IsZero (value2)) return Move (target, ShiftRight (value1, value2));
	Emit (Instruction::RSH, EvaluateIntegral<RightShift>, target, value1, value2);
}

Context::SmartOperand Context::ShiftRight (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsZero (value2)) return {current->uses, value1};
	return Apply (Instruction::RSH, EvaluateIntegral<RightShift>, value1, value2, hint);
}

void Context::SaveRegister (SmartOperand& operand)
{
	if (HasRegister (operand) && IsUser (operand.register_)) current->savedRegisters.push_back (&operand);
}

void Context::Save (SmartOperand& operand)
{
	assert (HasRegister (operand)); assert (IsUser (operand.register_)); if (operand.saved) return;
	Push (IsMemory (operand) ? Reg {platform.pointer, operand.register_} : Reg {operand.type, operand.register_}); operand.saved = true;
}

void Context::RestoreRegister (SmartOperand& operand)
{
	if (!HasRegister (operand) || !IsUser (operand.register_)) return; assert (!current->savedRegisters.empty ());
	assert (current->savedRegisters.back () == &operand); current->savedRegisters.pop_back (); if (!operand.saved) return;
	operand.ReplaceRegister (IsMemory (operand) ? Pop (platform.pointer) : Pop (operand.type)); operand.saved = false;
}

void Context::SaveRegisters (SmartOperand& first, SmartOperand& second)
{
	SaveRegister (first); if (!HaveSameUserRegister (first, second)) SaveRegister (second);
}

void Context::RestoreRegisters (SmartOperand& first, SmartOperand& second)
{
	if (HaveSameUserRegister (first, second)) RestoreRegister (first), second.ReplaceRegister (first); else RestoreRegister (second), RestoreRegister (first);
}

Size Context::Push (const Size size)
{
	assert (platform.IsStackAligned (size)); Decrement (emitter.stackPointer, size); return size;
}

Size Context::Push (const Operand& operand)
{
	Emit (PUSH {operand}); return platform.GetStackSize (operand.type);
}

void Context::Pop (const Operand& target)
{
	Emit (POP {target});
}

Context::SmartOperand Context::Pop (const Type& type, const Hint hint)
{
	auto result = AcquireRegister (type, hint); Pop (result); return result;
}

void Context::Call (const Operand& target, const Size size)
{
	Emit (CALL {target, size});
}

Context::SmartOperand Context::Call (const Type& type, const Operand& target, const Size size)
{
	Call (target, size); return {current->uses, Reg {type, RRes}};
}

void Context::Return ()
{
	Emit (RET {});
}

void Context::Enter (const Size size)
{
	Emit (ENTER {size});
}

void Context::Leave ()
{
	Emit (LEAVE {});
}

Context::Label Context::CreateLabel ()
{
	assert (current->section); return Label {*current->section};
}

void Context::Branch (const Label& label)
{
	Branch (Instruction::BR, nullptr, label);
}

void Context::BranchEqual (const Label& label, const Operand& value1, const Operand& value2)
{
	if (value1 == value2) return Branch (label);
	Branch (Instruction::BREQ, Compare<std::equal_to>, label, value1, value2);
}

void Context::BranchNotEqual (const Label& label, const Operand& value1, const Operand& value2)
{
	if (value1 == value2) return;
	Branch (Instruction::BRNE, Compare<std::not_equal_to>, label, value1, value2);
}

void Context::BranchLessThan (const Label& label, const Operand& value1, const Operand& value2)
{
	Branch (Instruction::BRLT, Compare<std::less>, label, value1, value2);
}

void Context::BranchGreaterEqual (const Label& label, const Operand& value1, const Operand& value2)
{
	Branch (Instruction::BRGE, Compare<std::greater_equal>, label, value1, value2);
}

void Context::Jump (const Operand& target)
{
	Emit (JUMP {target});
}

void Context::Locate (const Source& source, const Position& position)
{
	Emit (LOC {source, Size (GetLine (position)), Size (GetColumn (position))});
}

void Context::Break (const Source& source, const Position& position)
{
	Emit (BREAK {}); Locate (source, position);
}

void Context::Trap (const Size code)
{
	Emit (TRAP {code});
}

void Context::DeclareSymbol (const Label& lifetime, const String& name, const Operand& value)
{
	Patch (Instruction::SYM, lifetime, name, value);
}

void Context::DeclareField (const String& name, const Size offset, const Operand& mask)
{
	Emit (FIELD {name, offset, mask});
}

void Context::DeclareEnumerator (const String& name, const Operand& value)
{
	Emit (VALUE {name, value});
}

void Context::DeclareVoid ()
{
	Emit (VOID {});
}

void Context::DeclareType (const Operand& operand)
{
	Emit (TYPE {operand});
}

void Context::DeclareArray (const Size index, const Size size)
{
	Emit (ARRAY {index, size});
}

void Context::DeclareRecord (const Label& extent, const Size size)
{
	Patch (Instruction::REC, extent, size);
}

void Context::DeclarePointer ()
{
	Emit (PTR {});
}

void Context::DeclareReference ()
{
	Emit (REF {});
}

void Context::DeclareFunction (const Label& extent)
{
	Patch (Instruction::FUNC, extent);
}

void Context::DeclareEnumeration (const Label& extent)
{
	Patch (Instruction::ENUM, extent);
}

void Context::Assemble (const String& source, const Size line, const String& code)
{
	Emit (ASM {source, line, code});
}

void Context::AssembleCode (const String& source, const Size line, const String& code)
{
	std::istringstream assembly {code}; Assembly::Program program {source};
	emitter.parser.Parse (assembly, line, program);
	Sections assembledSections;
	emitter.checker.Check (program, assembledSections);
	if (!current->comment.empty () && !assembledSections.empty ()) current->comment.swap (assembledSections.front ().comment);
	sections.splice (sections.end (), assembledSections);
	current->section = &sections.back ();
}

void Context::AssembleInlineCode (const String& source, const Size line, const String& code)
{
	assert (current->section); std::stringstream assembly;
	for (auto& instruction: current->section->instructions) if (IsSymbolDeclaration (instruction)) DefineSymbol (instruction.operand2.address, instruction.operand3, assembly);
	if (assembly.tellp ()) Assembly::WriteLine (assembly, line) << '\n';
	Assembly::Instructions instructions; assembly << code;
	emitter.parser.Parse (assembly, source, line, instructions);
	const auto size = current->section->instructions.size ();
	emitter.checker.Check (instructions, *current->section);
	if (!current->comment.empty () && current->section->instructions.size () > size) current->comment.swap (current->section->instructions[size].comment);
}

void Context::Fix (const Operand& operand)
{
	assert (IsRegister (operand)); if (!IsUser (operand.register_)) return;
	if (!current->fixes[operand.register_]++) Emit (FIX {operand});
}

void Context::Unfix (const Operand& operand)
{
	assert (IsRegister (operand)); if (!IsUser (operand.register_)) return; assert (current->fixes[operand.register_]);
	if (!--current->fixes[operand.register_]) Emit (UNFIX {operand});
}

Context::SmartOperand Context::Protect (const Operand& operand)
{
	return {current->protections, operand};
}

Context::SmartOperand Context::Deprotect (const Operand& operand)
{
	return {current->uses, operand};
}

Context::SmartOperand Context::MakeRegister (const Operand& operand, const Hint hint)
{
	if (IsRegister (operand)) return {current->uses, operand};
	auto register_ = ReuseRegister (operand, operand.type, hint); Move (register_, operand); return register_;
}

Context::SmartOperand Context::MakeMemory (const Type& type, const Operand& operand, const Displacement displacement, const Operand::Strict strict)
{
	return {current->uses, Mem {type, IsMemory (operand) ? MakeRegister (operand) : operand, displacement, strict}};
}

Context::SmartOperand Context::AcquireRegister (const Type& type, const Hint hint)
{
	if (hint != RVoid) return {current->uses, Reg {type, hint}};
	auto register_ = R0; while (register_ <= RMax && (current->uses[register_] || current->protections[register_])) register_ = Register (register_ + 1);
	if (register_ > RMax) throw RegisterShortage {}; return {current->uses, Reg {type, register_}};
}

Context::SmartOperand Context::ReuseRegister (const Operand& operand, const Type& type, const Hint hint)
{
	if (hint != RVoid) return {current->uses, Reg {type, hint}};
	if (HasRegister (operand) && IsUser (operand.register_) && !current->protections[operand.register_]) return {current->uses, Reg {type, operand.register_}};
	return AcquireRegister (type);
}

Context::SmartOperand Context::ReuseRegister (const Operand& operand1, const Operand& operand2, const Hint hint)
{
	assert (operand1.type == operand2.type);
	if (hint != RVoid) return {current->uses, Reg {operand1.type, hint}};
	if (HasRegister (operand1) && IsUser (operand1.register_) && !current->protections[operand1.register_]) return {current->uses, Reg {operand1.type, operand1.register_}};
	if (HasRegister (operand2) && IsUser (operand2.register_) && !current->protections[operand2.register_]) return {current->uses, Reg {operand1.type, operand2.register_}};
	return AcquireRegister (operand1.type);
}

Context::Hint Context::Reuse (const Operand& operand)
{
	return HasRegister (operand) ? operand.register_ : RVoid;
}

Context::Hint Context::Reuse (const Hint hint, const Operand& operand)
{
	return Reuse (operand) != hint ? hint : RVoid;
}

void Context::Increment (const Operand& target, const Pointer::Value value)
{
	Add (target, target, PtrImm {platform.pointer, value});
}

void Context::Decrement (const Operand& target, const Pointer::Value value)
{
	Subtract (target, target, PtrImm {platform.pointer, value});
}

void Context::Displace (SmartOperand& operand, const Displacement displacement)
{
	assert (IsMemory (operand) || IsPointer (operand.type));
	if (IsImmediate (operand)) operand.ptrimm = Truncate (operand.ptrimm + displacement, operand.type.size * 8);
	else operand.displacement = Truncate (operand.displacement + displacement, platform.pointer.size * 8);
}

Context::SmartOperand Context::Displace (const Operand& operand, const Displacement displacement)
{
	SmartOperand result {current->uses, operand}; Displace (result, displacement); return result;
}

Context::SmartOperand Context::Add (const Operand& operand, const Displacement displacement)
{
	return Displace (IsMemory (operand) && displacement ? MakeRegister (operand) : operand, displacement);
}

Context::SmartOperand Context::Subtract (const Operand& operand, const Displacement displacement)
{
	return Displace (IsMemory (operand) && displacement ? MakeRegister (operand) : operand, -displacement);
}

Context::SmartOperand Context::Set (Label& skip, const Operand& value1, const Operand& value2, const Hint hint)
{
	assert (value1.type == value2.type); auto end = CreateLabel ();
	auto result = MakeRegister (value1, hint); Fix (result); Branch (end); skip ();
	Move (result, value2); Unfix (result); end (); return result;
}

Context::SmartOperand Context::Minimize (const Operand& value1, const Operand& value2, const Hint hint)
{
	if (IsImmediate (value1) && IsImmediate (value2)) return Compare<std::less> (value1, value2) ? value1 : value2;
	auto skip = CreateLabel (); auto result = Move (value1, hint), value = Move (value2, hint);
	Fix (result); BranchLessThan (skip, result, value); Move (result, value); Unfix (result); skip (); return result;
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction)); assert (current->section);
	current->section->instructions.push_back (instruction);
	if (!current->comment.empty ()) current->comment.swap (current->section->instructions.back ().comment);
}

void Context::Emit (const Instruction::Mnemonic mnemonic, Operand (*const evaluate) (const Operand&), const Operand& target, const Operand& value)
{
	if (IsImmediate (value)) return Move (target, evaluate (value));
	Emit ({mnemonic, target, value});
}

void Context::Emit (const Instruction::Mnemonic mnemonic, Operand (*const evaluate) (const Operand&, const Operand&), const Operand& target, const Operand& value1, const Operand& value2)
{
	assert (value1.type == value2.type);
	if (IsImmediate (value1) && IsImmediate (value2)) return Move (target, evaluate (value1, value2));
	Emit ({mnemonic, target, value1, value2});
}

Context::SmartOperand Context::Apply (const Instruction::Mnemonic mnemonic, Operand (*const evaluate) (const Operand&), const Operand& value, const Hint hint)
{
	if (IsImmediate (value)) return evaluate (value);
	auto result = ReuseRegister (value, value.type, hint); Emit (mnemonic, evaluate, result, value); return result;
}

Context::SmartOperand Context::Apply (const Instruction::Mnemonic mnemonic, Operand (*const evaluate) (const Operand&, const Operand&), const Operand& value1, const Operand& value2, const Hint hint)
{
	assert (value1.type == value2.type);
	if (IsImmediate (value1) && IsImmediate (value2)) return evaluate (value1, value2);
	auto result = ReuseRegister (value1, value2, hint); Emit (mnemonic, evaluate, result, value1, value2); return result;
}

void Context::Branch (const Instruction::Mnemonic mnemonic, bool (*const compare) (const Operand&, const Operand&), const Label& label, const Operand& value1, const Operand& value2)
{
	assert (value1.type == value2.type); assert (label.section == current->section);
	if (IsImmediate (value1) && IsImmediate (value2)) if (compare (value1, value2)) return Branch (label); else return;
	Patch (mnemonic, label, value1, value2);
}

void Context::Patch (const Instruction::Mnemonic mnemonic, const Label& label, const Operand& value1, const Operand& value2)
{
	const Offset offset = label.offset == Label::Unknown ? label.fixups.push_back (current->section->instructions.size ()), Indeterminate : label.offset - current->section->instructions.size () - 1;
	Emit ({mnemonic, offset, value1, value2});
}

Operand Context::Evaluate (const Operand& value, const Type& type)
{
	switch (type.model)
	{
	case Type::Signed: return Evaluate<SImm, Signed::Value> (value, type);
	case Type::Unsigned: return Evaluate<UImm, Signed::Value> (value, type);
	case Type::Float: return Evaluate<FImm, Float::Value> (value, type);
	case Type::Pointer: return Evaluate<PtrImm, Signed::Value> (value, type);
	case Type::Function: return Evaluate<FunImm, Signed::Value> (value, type);
	default: assert (Type::Unreachable);
	}
}

template <typename Immediate, typename FloatConversion>
Operand Context::Evaluate (const Operand& value, const Type& type)
{
	switch (value.type.model)
	{
	case Type::Signed: return Immediate {type, Truncate<typename Immediate::Value> (value.simm, type.size * 8)};
	case Type::Unsigned: return Immediate {type, Truncate<typename Immediate::Value> (value.uimm, type.size * 8)};
	case Type::Float: return Immediate {type, Truncate<typename Immediate::Value> (FloatConversion (value.fimm), type.size * 8)};
	case Type::Pointer: return Immediate {type, Truncate<typename Immediate::Value> (value.ptrimm, type.size * 8)};
	case Type::Function: return Immediate {type, Truncate<typename Immediate::Value> (value.funimm, type.size * 8)};
	default: assert (Type::Unreachable);
	}
}

template <template <typename> class Unary>
Operand Context::Evaluate (const Operand& value)
{
	if (value.type.model != Type::Float) return EvaluateIntegral<Unary> (value);
	return FImm {value.type, Truncate (Unary<Float::Value> {} (value.fimm), value.type.size * 8)};
}

template <template <typename> class Unary>
Operand Context::EvaluateIntegral (const Operand& value)
{
	switch (value.type.model)
	{
	case Type::Signed: return SImm {value.type, Truncate (Unary<Signed::Value> {} (value.simm), value.type.size * 8)};
	case Type::Unsigned: return UImm {value.type, Truncate (Unary<Unsigned::Value> {} (value.uimm), value.type.size * 8)};
	default: assert (Type::Unreachable);
	}
}

template <template <typename> class Binary>
Operand Context::Evaluate (const Operand& value1, const Operand& value2)
{
	if (value1.type.model != Type::Float) return EvaluateIntegral<Binary> (value1, value2);
	return FImm {value1.type, Truncate (Binary<Float::Value> {} (value1.fimm, value2.fimm), value1.type.size * 8)};
}

template <template <typename> class Binary>
Operand Context::EvaluateIntegral (const Operand& value1, const Operand& value2)
{
	switch (value1.type.model)
	{
	case Type::Signed: return SImm {value1.type, Truncate (Binary<Signed::Value> {} (value1.simm, value2.simm), value1.type.size * 8)};
	case Type::Unsigned: return UImm {value1.type, Truncate (Binary<Unsigned::Value> {} (value1.uimm, value2.uimm), value1.type.size * 8)};
	case Type::Pointer: return PtrImm {value1.type, Truncate (Binary<Pointer::Value> {} (value1.ptrimm, value2.ptrimm), value1.type.size * 8)};
	default: assert (Type::Unreachable);
	}
}

template <template <typename> class Binary>
bool Context::Compare (const Operand& value1, const Operand& value2)
{
	switch (value1.type.model)
	{
	case Type::Signed: return Binary<Signed::Value> {} (value1.simm, value2.simm);
	case Type::Unsigned: return Binary<Unsigned::Value> {} (value1.uimm, value2.uimm);
	case Type::Float: return Binary<Float::Value> {} (value1.fimm, value2.fimm);
	case Type::Pointer: return Binary<Pointer::Value> {} (value1.ptrimm, value2.ptrimm);
	case Type::Function: return Binary<Function::Value> {} (value1.funimm, value2.funimm);
	default: assert (Type::Unreachable);
	}
}

bool Context::IsSymbolDeclaration (const Instruction& instruction)
{
	return instruction.mnemonic == Instruction::SYM && instruction.operand1.offset == Indeterminate;
}

bool Context::HaveSameUserRegister (const Operand& first, const Operand& second)
{
	return HasRegister (first) && HasRegister (second) && first.register_ == second.register_ && IsUser (first.register_);
}

Context::SmartOperand::SmartOperand (const Operand& operand) :
	Operand {operand}
{
	assert (!HasRegister (operand) || !IsUser (operand.register_));
}

Context::SmartOperand::SmartOperand (State::Counters& c, const Operand& operand) :
	Operand {operand}
{
	if (HasRegister (operand) && IsUser (operand.register_)) counters = &c, ++(*counters)[register_];
}

Context::SmartOperand::SmartOperand (const SmartOperand& operand) :
	Operand {operand}, counters {operand.counters}
{
	if (counters) ++(*counters)[register_];
}

Context::SmartOperand::SmartOperand (SmartOperand&& operand) noexcept :
	Operand {std::move (operand)}, counters {operand.counters}
{
	operand.counters = nullptr;
}

Context::SmartOperand::~SmartOperand ()
{
	if (counters) --(*counters)[register_];
}

Context::SmartOperand& Context::SmartOperand::operator = (const SmartOperand& operand)
{
	auto copy = operand; swap (copy); return *this;
}

Context::SmartOperand& Context::SmartOperand::operator = (SmartOperand&& operand) noexcept
{
	swap (operand); return *this;
}

void Context::SmartOperand::ReplaceRegister (const SmartOperand& other)
{
	assert (HasRegister (*this)); assert (HasRegister (other));
	if (counters) --(*counters)[register_]; register_ = other.register_; if (counters) ++(*counters)[register_];
}

void Context::SmartOperand::swap (SmartOperand& other)
{
	std::swap<Operand> (*this, other); std::swap (counters, other.counters);
}

Context::Label::Label (Section& s) :
	section {&s}
{
}

Context::Label::Label (Label&& label) noexcept :
	offset {label.offset}, section {label.section}, fixups {std::move (label.fixups)}
{
	label.section = nullptr;
}

Context::Label::~Label ()
{
	if (section && !std::uncaught_exceptions ()) assert (offset != Unknown), assert (fixups.empty ());
}

Context::Label& Context::Label::operator = (Label&& label) noexcept
{
	swap (label); return *this;
}

void Context::Label::swap (Label& other)
{
	std::swap (offset, other.offset);
	std::swap (section, other.section);
	fixups.swap (other.fixups);
}

void Context::Label::operator () ()
{
	assert (section); assert (offset == Unknown);
	offset = section->instructions.size ();
	for (auto& fixup: fixups) Patch (fixup); fixups.clear ();
}

void Context::Label::Patch (const Offset offset) const
{
	assert (offset < section->instructions.size ());
	auto& instruction = section->instructions[offset];
	assert (IsOffset (instruction.operand1));
	instruction.operand1.offset = this->offset - offset - 1;
	if (!IsBranching (instruction.mnemonic) || instruction.operand1.offset) return; instruction = NOP {};
	if (offset && section->instructions[offset - 1].mnemonic == Instruction::BREAK) section->instructions[offset - 1] = NOP {};
}

Context::RestoreState::RestoreState (Context& c) :
	context {c}, previous {c.current}
{
	context.current = &state;
}

Context::RestoreState::~RestoreState ()
{
	context.current = previous;
}

Context::RestoreRegisterState::RestoreRegisterState (Context& c) :
	context {c}
{
	savedRegisters.swap (context.current->savedRegisters);
	for (auto operand: savedRegisters) context.Save (*operand);
}

Context::RestoreRegisterState::~RestoreRegisterState ()
{
	savedRegisters.swap (context.current->savedRegisters);
}

// Intermediate code interpreter
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
#include "cdinterpreter.hpp"
#include "environment.hpp"
#include "error.hpp"
#include "format.hpp"
#include "position.hpp"
#include "utilities.hpp"

#include <algorithm>
#include <cmath>
#include <map>
#include <set>
#include <stdexcept>
#include <utility>

using namespace ECS;
using namespace Code;

struct Interpreter::Value
{
	Type type;
	Segment* segment = nullptr;

	union
	{
		Signed::Value simm;
		Unsigned::Value uimm;
		Float::Value fimm;
		Pointer::Value ptrimm;
		Function::Value funimm;
		Displacement displacement;
	};

	Value ();
	Value (const Operand&);
	Value (const Type&, Segment*, Displacement);
	Value (const Type&, const Reference&, Displacement);

	Value& ConvertTo (const Type&);
	template <typename Immediate, typename> Immediate Convert (const Type&) const;

	bool operator < (const Value&) const;
	bool operator == (const Value&) const;

	Value operator - () const;
	Value operator ~ () const;

	Value& operator += (const Value&);
	Value& operator -= (const Value&);
	Value& operator *= (const Value&);
	Value& operator /= (const Value&);
	Value& operator %= (const Value&);

	Value& operator &= (const Value&);
	Value& operator |= (const Value&);
	Value& operator ^= (const Value&);

	Value& operator <<= (const Value&);
	Value& operator >>= (const Value&);
};

struct Interpreter::Reference
{
	Segment* segment;
	Offset offset;

	Reference (Segment*, Offset);
};

struct Interpreter::ProgramCounter
{
	const Section* section = nullptr;
	Size offset = 0;

	ProgramCounter () = default;
	ProgramCounter (const Section&, Size = 0);
};

using Segment = class Interpreter::Segment
{
public:
	const Section* section = nullptr;

	explicit Segment (Size);
	explicit Segment (const Section&);

	void Reserve (Size);
	void Define (Size, const Value&);

	Pointer::Value GetAddress (Displacement) const;
	Value& Designate (Displacement, const Type&, const Platform&);
	Value Evaluate (Displacement, const Type&, const Platform&) const;

	void Fill (Displacement, Size, const Value&);
	void Copy (Displacement, const Segment&, Displacement, Size);

private:
	std::vector<Value> data;

	Size Validate (Displacement, Size) const;
};

using Thread = class Interpreter::Thread
{
public:
	explicit Thread (Context&);

	bool Execute ();
	void Execute (const Section&);

	void Push (const Value&);

	Value GetArgument (Displacement, const Type&) const;

private:
	Context& context;

	Segment stack;
	ProgramCounter pc;
	Segment environment;
	Sections inlinedSections;
	Value registers[Registers];
	std::vector<ProgramCounter> counters;

	void EmitError [[noreturn]] (const Message&) const;

	Value& Designate (const Operand&);
	Value Evaluate (const Operand&) const;
	Value Address (const Type&, const Operand&) const;

	bool Execute (const Instruction&);

	void Return ();
	Value Pop (const Type&);
	void Call (const Value&);
	void Jump (const Value&);
	void ExecuteStandardFunction ();
	void Assemble (const Source&, Line, const String&);
	void Copy (const Value&, const Value&, const Value&);
	void Fill (const Value&, const Value&, const Value&);

	bool IsSymbolDeclaration (const Instruction&) const;

	static constexpr Displacement StackSize = 10000;
};

using Context = class Interpreter::Context
{
public:
	const Interpreter& interpreter;
	Platform& platform;

	Context (const Interpreter&, const Sections&, Environment&);

	Reference Find (const Section::Name&) const;
	Reference Find (const Section::Name&, const ProgramCounter&) const;
	Reference Find (const Type&, const Section::Name&, const ProgramCounter&) const;
	Value Address (const Type&, const Operand&, const ProgramCounter&) const;

	void Execute [[noreturn]] ();
	void CreateThread (const Section&, const Value&);
	bool Call (const Section&, const Thread&, Value&);

	void Deallocate (Segment*);
	Segment& Add (const Section&);
	void Check (const Segment*) const;
	Segment* Allocate (Pointer::Value);
	Size Validate (const Value&) const;

	void EmitError [[noreturn]] (const ProgramCounter&, const Message&) const;

private:
	Environment& environment;

	std::list<Thread> threads;
	std::list<Segment> segments;
	Sections sections, assembledSections;
	mutable std::set<Section::Name> unresolved;
	std::map<Section::Name, Reference> directory;
	Segment &abort, &exit, &fflush, &floor, &fputc, &free, &getchar, &malloc, &putchar;

	bool IsRequired (const Section::Name&) const;

	void CreateMainThread ();
	void InitializeData (Segment&);
	void InitializeNames (Segment&);
	void Replace (Segment&, const Reference&);
	void Execute (const Segment&, Section::Type);
	void Assemble (const Instruction&, const Section&);

	void AddAssembly (const Section&);
	void Add (const Section::Name&, Segment&, Offset);
	Segment& AddVariable (const Section::Name&, const Type&);
	Segment& AddFunction (const Section::Name&);

	void AddVariable (const Section::Name&, const Value&);
	void AddVariable (const Section::Name&, const String&);
};

Interpreter::Interpreter (Diagnostics& d, StringPool& sp, Charset& c, Platform& p) :
	diagnostics {d}, platform {p}, parser {d, sp, false}, checker {d, c, p}
{
	assert (platform.return_.size || platform.link.size);
}

Signed::Value Interpreter::Execute (const Sections& sections, Environment& environment) const
{
	try {Context {*this, sections, environment}.Execute ();} catch (const Signed::Value status) {return status;}
}

Interpreter::Value::Value () :
	displacement {0}
{
}

Interpreter::Value::Value (const Type& t, Segment*const s, const Displacement d) :
	type {t}, segment {s}, displacement {d}
{
	assert (IsAddress (type));
}

Interpreter::Value::Value (const Type& t, const Reference& reference, const Displacement d) :
	type {t}, segment {reference.segment}, displacement {reference.offset + d}
{
	assert (segment);
	assert (IsAddress (type));
}

Interpreter::Value::Value (const Operand& operand) :
	type {operand.type}
{
	assert (operand.address.empty () && !HasRegister (operand));

	switch (type.model)
	{
	case Type::Signed: simm = operand.simm; break;
	case Type::Unsigned: uimm = operand.uimm; break;
	case Type::Float: fimm = operand.fimm; break;
	case Type::Pointer: ptrimm = operand.ptrimm; break;
	case Type::Function: funimm = operand.funimm; break;
	default: assert (Type::Unreachable);
	}
}

Interpreter::Value& Interpreter::Value::ConvertTo (const Type& type)
{
	switch (type.model)
	{
	case Type::Signed: simm = Convert<Signed::Value, Signed::Value> (type); break;
	case Type::Unsigned: uimm = Convert<Unsigned::Value, Signed::Value> (type); break;
	case Type::Float: fimm = Convert<Float::Value, Float::Value> (type); break;
	case Type::Pointer: ptrimm = Convert<Pointer::Value, Signed::Value> (type); break;
	case Type::Function: funimm = Convert<Function::Value, Signed::Value> (type); break;
	default: assert (Type::Unreachable);
	}
	this->type = type; return *this;
}

template <typename Immediate, typename FloatConversion>
Immediate Interpreter::Value::Convert (const Type& type) const
{
	switch (this->type.model)
	{
	case Type::Signed: return Truncate<Immediate> (simm, type.size * 8);
	case Type::Unsigned: return Truncate<Immediate> (uimm, type.size * 8);
	case Type::Float: return Truncate<Immediate> (FloatConversion (fimm), type.size * 8);
	case Type::Pointer: return Truncate<Immediate> (segment ? segment->GetAddress (displacement) : ptrimm, type.size * 8);
	case Type::Function: return Truncate<Immediate> (segment ? segment->GetAddress (displacement) : funimm, type.size * 8);
	default: assert (Type::Unreachable);
	}
}

bool Interpreter::Value::operator == (const Value& other) const
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: return simm == other.simm;
	case Type::Unsigned: return uimm == other.uimm;
	case Type::Float: return fimm == other.fimm;
	case Type::Pointer: if (segment) return segment == other.segment && displacement == other.displacement; return !other.segment && ptrimm == other.ptrimm;
	case Type::Function: if (segment) return segment == other.segment && displacement == other.displacement; return !other.segment && funimm == other.funimm;
	default: throw type;
	}
}

bool Interpreter::Value::operator < (const Value& other) const
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: return simm < other.simm;
	case Type::Unsigned: return uimm < other.uimm;
	case Type::Float: return fimm < other.fimm;
	case Type::Pointer: if (segment == other.segment) if (segment) return displacement < other.displacement; else return ptrimm < other.ptrimm;
		if (segment && other.segment) return segment->GetAddress (displacement) < other.segment->GetAddress (other.displacement); throw other;
	case Type::Function: if (segment == other.segment) if (segment) return displacement < other.displacement; else return funimm < other.funimm;
		if (segment && other.segment) return segment->GetAddress (displacement) < other.segment->GetAddress (other.displacement); throw other;
	default: throw type;
	}
}

Interpreter::Value Interpreter::Value::operator - () const
{
	switch (type.model)
	{
	case Type::Signed: return SImm (type, Truncate (-simm, type.size * 8));
	case Type::Unsigned: return UImm (type, Truncate (-uimm, type.size * 8));
	case Type::Float: return FImm (type, Truncate (-fimm, type.size * 8));
	default: throw type;
	}
}

Interpreter::Value Interpreter::Value::operator ~ () const
{
	switch (type.model)
	{
	case Type::Signed: return SImm (type, Truncate (~simm, type.size * 8));
	case Type::Unsigned: return UImm (type, Truncate (~uimm, type.size * 8));
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator += (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: simm = Truncate (simm + other.simm, type.size * 8); return *this;
	case Type::Unsigned: uimm = Truncate (uimm + other.uimm, type.size * 8); return *this;
	case Type::Float: fimm = Truncate (fimm + other.fimm, type.size * 8); return *this;
	case Type::Pointer: if (segment && other.segment) throw other; if (other.segment) segment = other.segment, displacement = Truncate (Displacement (ptrimm), type.size * 8) + other.displacement; else displacement += Truncate (Displacement (other.ptrimm), type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator -= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: simm = Truncate (simm - other.simm, type.size * 8); return *this;
	case Type::Unsigned: uimm = Truncate (uimm - other.uimm, type.size * 8); return *this;
	case Type::Float: fimm = Truncate (fimm - other.fimm, type.size * 8); return *this;
	case Type::Pointer: if (segment != other.segment && other.segment) throw other; if (other.segment) segment = nullptr, ptrimm = Truncate (Pointer::Value (displacement - other.displacement), type.size * 8); else displacement -= Truncate (Displacement (other.ptrimm), type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator *= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: simm = Truncate (simm * other.simm, type.size * 8); return *this;
	case Type::Unsigned: uimm = Truncate (uimm * other.uimm, type.size * 8); return *this;
	case Type::Float: fimm = Truncate (fimm * other.fimm, type.size * 8); return *this;
	case Type::Pointer: if (segment || other.segment) throw other; ptrimm = Truncate (ptrimm * other.ptrimm, type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator /= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: if (other.simm == 0) throw other; simm = Truncate (simm / other.simm, type.size * 8); return *this;
	case Type::Unsigned: if (other.uimm == 0) throw other; uimm = Truncate (uimm / other.uimm, type.size * 8); return *this;
	case Type::Float: if (other.fimm == 0) throw other; fimm = Truncate (fimm / other.fimm, type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator %= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: if (other.simm == 0) throw other; simm = Truncate (simm % other.simm, type.size * 8); return *this;
	case Type::Unsigned: if (other.uimm == 0) throw other; uimm = Truncate (uimm % other.uimm, type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator |= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: simm = Truncate (simm | other.simm, type.size * 8); return *this;
	case Type::Unsigned: uimm = Truncate (uimm | other.uimm, type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator &= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: simm = Truncate (simm & other.simm, type.size * 8); return *this;
	case Type::Unsigned: uimm = Truncate (uimm & other.uimm, type.size * 8); return *this;
	case Type::Pointer: if (other.segment) throw other; if (segment) displacement = Truncate (displacement & Displacement (other.ptrimm), type.size * 8); else ptrimm = Truncate (ptrimm & other.ptrimm, type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator ^= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: simm = Truncate (simm ^ other.simm, type.size * 8); return *this;
	case Type::Unsigned: uimm = Truncate (uimm ^ other.uimm, type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator <<= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: if (other.simm < 0 || other.simm >= Signed::Value (type.size * 8)) throw other; simm = Truncate (ShiftLeft (simm, other.simm), type.size * 8); return *this;
	case Type::Unsigned: if (other.uimm >= Unsigned::Value (type.size * 8)) throw other; uimm = Truncate (ShiftLeft (uimm, other.uimm), type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Value& Interpreter::Value::operator >>= (const Value& other)
{
	if (type != other.type) throw type;
	switch (type.model)
	{
	case Type::Signed: if (other.simm < 0 || other.simm >= Signed::Value (type.size * 8)) throw other; simm = Truncate (ShiftRight (simm, other.simm), type.size * 8); return *this;
	case Type::Unsigned: if (other.uimm >= Unsigned::Value (type.size * 8)) throw other; uimm = Truncate (ShiftRight (uimm, other.uimm), type.size * 8); return *this;
	default: throw type;
	}
}

Interpreter::Reference::Reference (Segment*const s, const Offset o) :
	segment {s}, offset {o}
{
}

Interpreter::ProgramCounter::ProgramCounter (const Section& s, const Size o) :
	section {&s}, offset {o}
{
}

Segment::Segment (const Size size) :
	data {size}
{
}

Segment::Segment (const Section& s) :
	section {&s}
{
}

Interpreter::Value& Segment::Designate (const Displacement displacement, const Type& type, const Platform& platform)
{
	auto size = type.size;
	if (section && section->type != Section::Data) throw section;
	const auto index = Validate (displacement, size);
	if (!platform.IsAligned (index, type)) throw index;
	while (--size) data[index + size] = {};
	return data[index];
}

Interpreter::Value Segment::Evaluate (const Displacement displacement, const Type& type, const Platform& platform) const
{
	auto size = type.size;
	if (section && !IsData (section->type)) throw section;
	const auto index = Validate (displacement, size);
	if (!platform.IsAligned (index, type)) throw index;
	if (data[index].type != type) throw type;
	while (--size) if (data[index + size].type.model != Type::Void) throw type;
	return data[index];
}

Pointer::Value Segment::GetAddress (const Displacement displacement) const
{
	if (section && !IsData (section->type))
		if (displacement < 0 && displacement >= Displacement (section->instructions.size ())) throw this;
		else return Pointer::Value (&section->instructions[Size (displacement)]);
	return reinterpret_cast<Pointer::Value> (data.data ()) + Validate (displacement, 0);
}

void Segment::Copy (const Displacement displacement, const Segment& source, const Displacement sourceDisplacement, const Size size)
{
	std::copy_n (source.data.begin () + source.Validate (sourceDisplacement, size), size, data.begin () + Validate (displacement, size));
}

void Segment::Fill (const Displacement displacement, Size size, const Value& value)
{
	const auto typeSize = value.type.size;
	auto index = Validate (displacement, size);
	for (size *= typeSize; size; ++index, --size) data[index] = size % typeSize ? Value {} : value;
}

Size Segment::Validate (const Displacement displacement, const Size size) const
{
	if (displacement < 0 || displacement > Displacement (data.size ()) || Size (displacement + size) > data.size ()) throw this;
	return Size (displacement);
}

void Segment::Reserve (const Size size)
{
	assert (!section || IsData (section->type));
	data.resize (data.size () + size);
}

void Segment::Define (const Size offset, const Value& value)
{
	assert (!section || IsData (section->type));
	if (offset + value.type.size > data.size ()) data.resize (offset + value.type.size);
	data[offset] = value;
}

Thread::Thread (Context& c) :
	context {c}, stack {StackSize}, environment {0}
{
	registers[RSP] = registers[RFP] = {context.platform.pointer, &stack, StackSize - context.platform.stackDisplacement};
}

void Thread::EmitError (const Message& message) const
{
	context.EmitError (pc, message);
}

void Thread::Execute (const Section& section)
{
	counters.push_back (pc);
	pc = section;
}

bool Thread::Execute ()
{
	while (pc.offset == pc.section->instructions.size ())
		if (!inlinedSections.empty () && pc.section == &inlinedSections.back ())
		{
			assert (!counters.empty ());
			context.Deallocate (context.Find (pc.section->name).segment);
			pc = counters.back (); counters.pop_back (); inlinedSections.pop_back (); ++pc.offset;
		}
		else if (pc.section->type == Section::Code)
			EmitError (Format ("reached end of %0 section", pc.section->type));
		else
			assert (!counters.empty ()), pc = counters.back (), counters.pop_back ();

	try
	{
		if (Execute (pc.section->instructions[pc.offset])) ++pc.offset;
	}
	catch (const Type&)
	{
		EmitError ("inconsistent operand type");
	}
	catch (const Value&)
	{
		EmitError ("invalid operand");
	}
	catch (const Section*const section)
	{
		EmitError (Format ("accessing %0 section", section->type));
	}
	catch (const Segment*const segment)
	{
		EmitError (segment == &stack ? "stack overflow" : "invalid address");
	}
	catch (const Size)
	{
		EmitError ("misaligned access");
	}

	return false;
}

bool Thread::Execute (const Instruction& instruction)
{
	assert (IsValid (instruction, *pc.section, context.platform));

	switch (instruction.mnemonic)
	{
	case Instruction::ALIAS:
	case Instruction::REQ:
	case Instruction::NOP:
	case Instruction::FIX:
	case Instruction::UNFIX:
	case Instruction::LOC:
	case Instruction::BREAK:
	case Instruction::SYM:
	case Instruction::FIELD:
	case Instruction::VALUE:
	case Instruction::VOID:
	case Instruction::TYPE:
	case Instruction::ARRAY:
	case Instruction::REC:
	case Instruction::PTR:
	case Instruction::REF:
	case Instruction::FUNC:
	case Instruction::ENUM:
		break;

	case Instruction::MOV:
		Designate (instruction.operand1) = Evaluate (instruction.operand2);
		break;

	case Instruction::CONV:
		Designate (instruction.operand1) = Evaluate (instruction.operand2).ConvertTo (instruction.operand1.type);
		break;

	case Instruction::COPY:
		Copy (Evaluate (instruction.operand1), Evaluate (instruction.operand2), Evaluate (instruction.operand3));
		break;

	case Instruction::FILL:
		Fill (Evaluate (instruction.operand1), Evaluate (instruction.operand2), Evaluate (instruction.operand3));
		break;

	case Instruction::NEG:
		Designate (instruction.operand1) = -Evaluate (instruction.operand2);
		break;

	case Instruction::ADD:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) += Evaluate (instruction.operand3);
		break;

	case Instruction::SUB:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) -= Evaluate (instruction.operand3);
		break;

	case Instruction::MUL:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) *= Evaluate (instruction.operand3);
		break;

	case Instruction::DIV:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) /= Evaluate (instruction.operand3);
		break;

	case Instruction::MOD:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) %= Evaluate (instruction.operand3);
		break;

	case Instruction::NOT:
		Designate (instruction.operand1) = ~Evaluate (instruction.operand2);
		break;

	case Instruction::AND:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) &= Evaluate (instruction.operand3);
		break;

	case Instruction::OR:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) |= Evaluate (instruction.operand3);
		break;

	case Instruction::XOR:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) ^= Evaluate (instruction.operand3);
		break;

	case Instruction::LSH:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) <<= Evaluate (instruction.operand3);
		break;

	case Instruction::RSH:
		Designate (instruction.operand1) = Evaluate (instruction.operand2) >>= Evaluate (instruction.operand3);
		break;

	case Instruction::PUSH:
		Push (Evaluate (instruction.operand1));
		break;

	case Instruction::POP:
		Designate (instruction.operand1) = Pop (instruction.operand1.type);
		break;

	case Instruction::CALL:
		Call (Evaluate (instruction.operand1));
		return false;

	case Instruction::RET:
		Return ();
		return false;

	case Instruction::ENTER:
		Push (registers[RFP]); registers[RFP] = registers[RSP]; registers[RSP].displacement -= instruction.operand1.size;
		break;

	case Instruction::LEAVE:
		registers[RSP] = registers[RFP]; registers[RFP] = Pop (context.platform.pointer);
		break;

	case Instruction::BR:
		pc.offset += instruction.operand1.offset;
		break;

	case Instruction::BREQ:
		if (Evaluate (instruction.operand2) == Evaluate (instruction.operand3)) pc.offset += instruction.operand1.offset;
		break;

	case Instruction::BRNE:
		if (!(Evaluate (instruction.operand2) == Evaluate (instruction.operand3))) pc.offset += instruction.operand1.offset;
		break;

	case Instruction::BRLT:
		if (Evaluate (instruction.operand2) < Evaluate (instruction.operand3)) pc.offset += instruction.operand1.offset;
		break;

	case Instruction::BRGE:
		if (!(Evaluate (instruction.operand2) < Evaluate (instruction.operand3))) pc.offset += instruction.operand1.offset;
		break;

	case Instruction::JUMP:
		Jump (Evaluate (instruction.operand1));
		return false;

	case Instruction::ASM:
		Assemble (instruction.operand1.address, instruction.operand2.size, instruction.operand3.address);
		return false;

	case Instruction::TRAP:
		EmitError (Format ("trap %0", instruction.operand1.size));

	default:
		assert (Instruction::Unreachable);
	}

	return true;
}

Interpreter::Value& Thread::Designate (const Operand& operand)
{
	if (IsRegister (operand)) return registers[operand.register_];
	assert (IsMemory (operand)); const auto address = Address (context.platform.pointer, operand);
	return address.segment->Designate (address.displacement, operand.type, context.platform);
}

Interpreter::Value Thread::Address (const Type& type, const Operand& operand) const
{
	auto address = operand.address.empty () ? Imm (type, operand.ptrimm) : context.Address (type, operand, pc);
	if (operand.register_ != RVoid) address += registers[operand.register_]; if (!address.segment) throw address.segment; return address;
}

Interpreter::Value Thread::Evaluate (const Operand& operand) const
{
	Value value;
	switch (operand.model)
	{
	case Operand::Immediate:
		value = operand; break;
	case Operand::Register:
		value = registers[operand.register_];
		if (operand.type == context.platform.pointer) value += PtrImm (operand.type, operand.displacement);
		break;
	case Operand::Address:
		value = context.Address (operand.type, operand, pc);
		if (operand.register_ != RVoid) value += registers[operand.register_];
		break;
	case Operand::Memory:
		value = Address (context.platform.pointer, operand);
		value = value.segment->Evaluate (value.displacement, operand.type, context.platform);
		break;
	default:
		assert (Operand::Unreachable);
	}
	if (value.type != operand.type) throw value.type;
	return value;
}

void Thread::Push (const Value& value)
{
	context.Check (registers[RSP].segment);
	registers[RSP].displacement -= context.platform.GetStackSize (value.type);
	registers[RSP].segment->Designate (registers[RSP].displacement + context.platform.stackDisplacement, value.type, context.platform) = value;
}

Interpreter::Value Thread::Pop (const Type& type)
{
	context.Check (registers[RSP].segment);
	const auto displacement = registers[RSP].displacement + context.platform.stackDisplacement;
	registers[RSP].displacement += context.platform.GetStackSize (type);
	return registers[RSP].segment->Evaluate (displacement, type, context.platform);
}

Interpreter::Value Thread::GetArgument (const Displacement displacement, const Type& type) const
{
	context.Check (registers[RSP].segment);
	return registers[RSP].segment->Evaluate (registers[RSP].displacement + !context.platform.link.size * context.platform.GetStackSize (context.platform.return_) + context.platform.stackDisplacement + displacement, type, context.platform);
}

void Thread::Call (const Value& target)
{
	context.Check (registers[RSP].segment);
	context.Check (target.segment);
	if (!target.segment->section || target.displacement) throw target.segment;
	if (target.segment->section->type != Section::Code) EmitError (Format ("calling %0 section", target.segment->section->type));
	if (pc.section) registers[RLink] = {context.platform.function, context.Find (pc.section->name), Displacement (pc.offset + 1)};
	if (!context.platform.link.size && pc.section) Push (registers[RLink]);
	pc = *target.segment->section;
	std::fill (registers, registers + GeneralRegisters, Value {});
	ExecuteStandardFunction ();
}

void Thread::ExecuteStandardFunction ()
{
	if (context.Call (*pc.section, *this, registers[RRes]))
		if (!pc.section) return; else if (context.platform.link.size) Jump (registers[RLink]); else Return ();
	else if (pc.offset && pc.section->instructions[pc.offset - 1].mnemonic == Instruction::CALL)
		registers[RSP].displacement += pc.section->instructions[pc.offset - 1].operand2.size;
}

void Thread::Return ()
{
	context.Check (registers[RSP].segment);
	while (!inlinedSections.empty () && pc.section == &inlinedSections.back ())
	{
		assert (!counters.empty ());
		context.Deallocate (context.Find (pc.section->name).segment);
		pc = counters.back (); counters.pop_back (); inlinedSections.pop_back ();
	}
	std::fill (registers, registers + GeneralRegisters, Value {});
	const auto address = Pop (context.platform.return_);
	context.Check (address.segment);
	if (!address.segment->section || !IsCode (address.segment->section->type) || address.displacement < 0 || address.displacement > Displacement (address.segment->section->instructions.size ()))
		EmitError ("invalid return address");
	pc = {*address.segment->section, Size (address.displacement)};
	ExecuteStandardFunction ();
}

void Thread::Jump (const Value& target)
{
	context.Check (target.segment);
	if (!target.segment->section || target.displacement > Displacement (target.segment->section->instructions.size ())) throw target.segment;
	if (!IsCode (target.segment->section->type)) EmitError (Format ("jumping into %0 section", target.segment->section->type));
	pc = {*target.segment->section, Size (target.displacement)};
	ExecuteStandardFunction ();
}

void Thread::Copy (const Value& target, const Value& source, const Value& size)
{
	context.Check (target.segment);
	context.Check (source.segment);
	target.segment->Copy (target.displacement, *source.segment, source.displacement, context.Validate (size));
}

void Thread::Fill (const Value& target, const Value& size, const Value& value)
{
	context.Check (target.segment);
	target.segment->Fill (target.displacement, context.Validate (size), value);
}

void Thread::Assemble (const Source& source, const Line line, const String& code)
{
	std::stringstream assembly;
	for (auto& instruction: pc.section->instructions) if (IsSymbolDeclaration (instruction)) DefineSymbol (instruction.operand2.address, instruction.operand3, assembly);
	if (assembly.tellp ()) Assembly::WriteLine (assembly, line) << '\n';
	Assembly::Instructions instructions; assembly << code;
	context.interpreter.parser.Parse (assembly, source, line, instructions);
	inlinedSections.emplace_back (Section::Code, pc.section->name + "_asm");
	context.interpreter.checker.Check (instructions, inlinedSections.back ());
	context.Add (inlinedSections.back ()); Execute (inlinedSections.back ());
}

bool Thread::IsSymbolDeclaration (const Instruction& instruction) const
{
	if (instruction.mnemonic != Instruction::SYM) return false;
	const auto offset = GetIndex (instruction, pc.section->instructions);
	return pc.offset >= offset && pc.offset <= offset + instruction.operand1.offset;
}

Context::Context (const Interpreter& i, const Sections& sections, Environment& e) :
	interpreter {i}, platform {i.platform}, environment {e}, abort {AddFunction ("abort")}, exit {AddFunction ("_Exit")}, fflush (AddFunction ("fflush")), floor {AddFunction ("floor")},
	fputc {AddFunction ("fputc")}, free {AddFunction ("free")}, getchar {AddFunction ("getchar")}, malloc {AddFunction ("malloc")}, putchar {AddFunction ("putchar")}
{
	AddVariable ("_argc", SImm {platform.integer, 0});
	const auto argv = Allocate (0); argv->Define (0, PtrImm {platform.pointer, 0});
	AddVariable ("_argv", {platform.pointer, argv, 0});
	AddVariable ("_environment", "Intermediate code interpreter");
	AddVariable ("stdin", {platform.pointer, nullptr, 0});
	AddVariable ("stdout", {platform.pointer, nullptr, 1});
	AddVariable ("stderr", {platform.pointer, nullptr, 2});
	Batch (sections, [this] (const Section& section) {if (IsAssembly (section)) AddAssembly (section); else if (!IsType (section.type)) Add (section);});
	Batch (assembledSections, [this] (const Section& section) {if (!IsType (section.type)) Add (section);});
	segments.sort ([] (const Segment& a, const Segment& b) {return a.section && b.section && a.section->group < b.section->group;});
	for (auto& segment: segments) InitializeNames (segment); CreateMainThread ();
	Batch (segments, [this] (Segment& segment) {InitializeData (segment);});
}

void Context::EmitError (const ProgramCounter& pc, const Message& message) const
{
	assert (pc.section);
	interpreter.diagnostics.Emit (Diagnostics::Error, pc.section->name, pc.offset + 1, message); throw Error {};
}

Segment* Context::Allocate (const Pointer::Value size)
{
	try {segments.emplace_back (size);}
	catch (const std::bad_alloc&) {return nullptr;}
	catch (const std::length_error&) {return nullptr;}
	return &segments.back ();
}

void Context::Deallocate (Segment*const segment)
{
	assert (segment);
	const auto iterator = std::find_if (segments.begin (), segments.end (), [segment] (const Segment& s) {return &s == segment;});
	if (iterator == segments.end ()) throw segment;
	if (segment->section) directory.erase (segment->section->name);
	segments.erase (iterator);
}

void Context::Check (const Segment*const segment) const
{
	if (!segment) throw segment;
}

Size Context::Validate (const Value& size) const
{
	assert (size.type == platform.pointer);
	if (size.segment) throw size.segment;
	if (size.ptrimm > segments.max_size ()) throw size;
	return Size (size.ptrimm);
}

Segment& Context::Add (const Section& section)
{
	assert (!IsAssembly (section)); assert (!IsType (section.type));
	auto& segment = segments.emplace_back (section); Add (section.name, segment, 0); return segment;
}

void Context::AddAssembly (const Section& section)
{
	assert (IsAssembly (section));
	Batch (section.instructions, [this, &section] (const Instruction& instruction) {Assemble (instruction, section);});
}

void Context::Assemble (const Instruction& instruction, const Section& section)
{
	assert (IsValid (instruction, section, interpreter.platform));
	Assembly::Program program {instruction.operand1.address};
	std::istringstream assembly {instruction.operand3.address};
	interpreter.parser.Parse (assembly, instruction.operand2.size, program);
	interpreter.checker.Check (program, assembledSections);
}

void Context::Add (const Section::Name& name, Segment& segment, const Offset offset)
{
	assert (!name.empty ());

	const auto result = directory.insert (std::make_pair (name, Reference {&segment, offset}));

	if (result.second) return; auto& reference = result.first->second;
	if (segment.section->replaceable && !reference.segment->section->replaceable)
		Replace (segment, reference);
	else if (reference.segment->section->replaceable && !segment.section->replaceable)
		Replace (*reference.segment, reference), reference.segment = &segment, reference.offset = offset;
	else if (segment.section->duplicable || reference.segment->section->duplicable)
		if (*segment.section == *reference.segment->section && reference.segment != &segment) Replace (segment, reference);
		else interpreter.diagnostics.Emit (Diagnostics::Error, name, {}, "unequal duplicate"), throw Error {};
	else interpreter.diagnostics.Emit (Diagnostics::Error, name, {}, "duplicated section"), throw Error {};
}

void Context::Replace (Segment& segment, const Reference& reference)
{
	assert (segment.section); auto iterator = directory.find (segment.section->name);
	if (iterator != directory.end () && &iterator->second != &reference) directory.erase (iterator);
	for (auto& instruction: segment.section->instructions) if (instruction.mnemonic == Instruction::ALIAS)
		if (iterator = directory.find (instruction.operand1.address), iterator != directory.end () && &iterator->second != &reference) directory.erase (iterator);
	segment.section = nullptr;
}

void Context::InitializeNames (Segment& segment)
{
	if (!segment.section) return;

	Size offset = 0, increment = IsCode (segment.section->type);
	for (auto& instruction: segment.section->instructions)
		switch (instruction.mnemonic)
		{
		case Instruction::ALIAS: Add (instruction.operand1.address, segment, offset); offset += increment; break;
		case Instruction::REQ: Find (instruction.operand1.address, {*segment.section, offset}); offset += increment; break;
		case Instruction::DEF: offset += instruction.operand1.type.size; break;
		case Instruction::RES: offset += instruction.operand1.size; break;
		default: offset += increment;
		}
}

void Context::InitializeData (Segment& segment)
{
	if (!segment.section || !IsData (segment.section->type)) return;

	Size offset = 0;
	for (auto& instruction: segment.section->instructions)
	{
		assert (IsValid (instruction, *segment.section, platform));

		switch (instruction.mnemonic)
		{
		case Instruction::ALIAS:
		case Instruction::REQ:
		case Instruction::LOC:
		case Instruction::FIELD:
		case Instruction::VALUE:
		case Instruction::VOID:
		case Instruction::TYPE:
		case Instruction::ARRAY:
		case Instruction::REC:
		case Instruction::PTR:
		case Instruction::REF:
		case Instruction::FUNC:
		case Instruction::ENUM:
			break;

		case Instruction::DEF:
			assert (platform.IsAligned (offset, instruction.operand1.type));
			assert (platform.IsAligned (*segment.section, instruction.operand1.type));
			if (!IsAddress (instruction.operand1)) segment.Define (offset, instruction.operand1);
			else segment.Define (offset, Address (instruction.operand1.type, instruction.operand1, {*segment.section, offset}));
			offset += instruction.operand1.type.size;
			break;

		case Instruction::RES:
			segment.Reserve (instruction.operand1.size);
			offset += instruction.operand1.size;
			break;

		default:
			assert (Instruction::Unreachable);
		}
	}
}

bool Context::IsRequired (const Section::Name& name) const
{
	Section::Name::size_type begin = 0;
	for (auto next = name.find ('?'); next != name.npos; begin = next + 1, next = name.find ('?', begin))
		if (directory.find (name.substr (begin, next - begin)) != directory.end ()) return true;
	return begin == 0;
}

Interpreter::Reference Context::Find (const Section::Name& name) const
{
	const auto entry = directory.find (name);
	return entry != directory.end () ? entry->second : Reference {nullptr, 0};
}

Interpreter::Reference Context::Find (const Section::Name& name, const ProgramCounter& pc) const
{
	const auto result = Find (name);
	if (!result.segment) if (unresolved.insert (name).second) EmitError (pc, Format ("unresolved symbol '%0'", name)); else throw Error {};
	return result;
}

Interpreter::Reference Context::Find (const Type& type, const Section::Name& name, const ProgramCounter& pc) const
{
	const auto strippedName = Object::StripConditionals (name, IsRequired (name));
	if (strippedName.empty ()) return {nullptr, 0}; const auto result = Find (strippedName, pc);
	if (result.segment->section && !(type.model == Type::Function ? IsCode (result.segment->section->type) : IsData (result.segment->section->type)))
		EmitError (pc, Format ("referencing %0 section using %1 type", result.segment->section ? result.segment->section->type : Section::Data, type));
	return result;
}

Interpreter::Value Context::Address (const Type& type, const Operand& operand, const ProgramCounter& pc) const
{
	assert (!operand.address.empty ()); const auto reference = Find (type, operand.address, pc);
	return reference.segment ? Value {type, reference.segment, reference.offset + operand.displacement} : Imm (type, operand.displacement);
}

void Context::Execute ()
{
	while (true) for (auto thread = threads.begin (); thread != threads.end ();) if (thread->Execute ()) thread = threads.erase (thread), assert (!threads.empty ());
}

void Context::CreateThread (const Section& section, const Value& address)
{
	assert (address.type == platform.pointer);
	if (!IsCode (section.type)) interpreter.diagnostics.Emit (Diagnostics::Error, section.name, {}, Format ("executing %0 section", section.type)), throw Error {};
	auto& thread = threads.emplace_back (*this); thread.Push (address); thread.Execute (section);
}

void Context::CreateMainThread ()
{
	auto& thread = threads.emplace_back (*this); const auto entryPoint = Find (Section::EntryPoint);
	if (!entryPoint.segment || !entryPoint.segment->section) interpreter.diagnostics.Emit (Diagnostics::Error, Section::EntryPoint, {}, "missing entry point"), throw Error {};
	else if (entryPoint.offset || !IsEntryPoint (*entryPoint.segment->section)) EmitError (*entryPoint.segment->section, "invalid entry point");
	else thread.Execute (*entryPoint.segment->section);
	for (auto& segment: Reverse {segments}) Execute (segment, Section::InitCode);
	for (auto& segment: Reverse {segments}) Execute (segment, Section::InitData);
}

void Context::Execute (const Segment& segment, const Section::Type type)
{
	if (segment.section && segment.section->type == type && IsRequired (segment.section->name)) threads.back ().Execute (*segment.section);
}

Segment& Context::AddVariable (const Section::Name& name, const Type& type)
{
	return Add (sections.emplace_back (Section::Data, name, platform.GetAlignment (type)));
}

void Context::AddVariable (const Section::Name& name, const Value& value)
{
	AddVariable (name, value.type).Define (0, value);
}

void Context::AddVariable (const Section::Name& name, const String& string)
{
	const Unsigned type {1}; auto& segment = AddVariable (name, type);
	for (auto& character: string) segment.Define (GetIndex (character, string), UImm (type, character));
	segment.Define (string.size (), UImm (type, 0));
}

Segment& Context::AddFunction (const Section::Name& name)
{
	return Add (sections.emplace_back (Section::Code, name));
}

bool Context::Call (const Section& function, const Thread& thread, Value& result)
{
	if (&function == abort.section)
		throw Error {};
	else if (&function == exit.section)
		throw thread.GetArgument (0, platform.integer).simm;
	else if (&function == fflush.section)
		result = SImm {platform.integer, environment.Fflush (thread.GetArgument (0, platform.pointer).ptrimm)};
	else if (&function == floor.section)
		result = FImm {platform.float_, std::floor (thread.GetArgument (0, platform.float_).fimm)};
	else if (&function == fputc.section)
		result = SImm {platform.integer, environment.Fputc (thread.GetArgument (0, platform.integer).simm, thread.GetArgument (platform.GetStackSize (platform.integer), platform.pointer).ptrimm)};
	else if (&function == free.section)
	{
		const auto address = thread.GetArgument (0, platform.pointer);
		if (!address.segment && address.ptrimm || address.segment && (address.displacement || address.segment->section)) throw address.segment;
		if (address.segment) Deallocate (address.segment);
		result = {};
	}
	else if (&function == getchar.section)
		result = SImm {platform.integer, environment.Getchar ()};
	else if (&function == malloc.section)
		result = {platform.pointer, Allocate (thread.GetArgument (0, Unsigned {platform.pointer.size}).uimm), 0};
	else if (&function == putchar.section)
		result = SImm {platform.integer, environment.Putchar (thread.GetArgument (0, platform.integer).simm)};
	else return false;

	return true;
}

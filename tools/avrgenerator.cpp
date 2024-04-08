// AVR machine code generator
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

#include "asmgeneratorcontext.hpp"
#include "avr.hpp"
#include "avrgenerator.hpp"

#include <bitset>

using namespace ECS;
using namespace AVR;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const AVR::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	class SmartOperand;

	using Index = unsigned;
	using RegisterSet = std::vector<Register>;

	const ProgramMemorySize programMemorySize;

	Label repeat;
	int reservedValue;
	bool nextredundant;
	Register repeatCounter;
	const Code::Reg rsp, rfp;
	std::bitset<32> acquired;
	RegisterSet registers[Code::Registers];

	void Invalidate (Register);
	void Emit (const Instruction&);
	void Move (Register, Register);
	void MoveWord (Register, Register);
	void EmitLoad (Register, Byte, bool = false);
	void Emit (Instruction::Mnemonic, const Operand&, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);

	Register Acquire ();
	void Acquire (Register);
	void Release (Register);
	void Release (const RegisterSet&);
	void Acquire (Register&, Register&);
	void Acquire (RegisterSet&, Code::Type::Size);
	void Acquire (RegisterSet&, Code::Type::Size, Register);

	bool IsRequired (Index, Index, const SmartOperand&, const SmartOperand* = nullptr, const SmartOperand* = nullptr);

	void Pop (const SmartOperand&);
	void Push (const SmartOperand&);
	void Neg (const SmartOperand&, const SmartOperand&);
	void Not (const SmartOperand&, const SmartOperand&);
	void Move (const SmartOperand&, const SmartOperand&);
	void Compare (const SmartOperand&, const SmartOperand&);
	void Decrement (const SmartOperand&, const SmartOperand&);
	void Increment (const SmartOperand&, const SmartOperand&);
	void Move (const SmartOperand&, const SmartOperand&, Index);
	void Or (const SmartOperand&, const SmartOperand&, const SmartOperand&);
	void Add (const SmartOperand&, const SmartOperand&, const SmartOperand&);
	void And (const SmartOperand&, const SmartOperand&, const SmartOperand&);
	void Mul (const SmartOperand&, const SmartOperand&, const SmartOperand&);
	void Sub (const SmartOperand&, const SmartOperand&, const SmartOperand&);
	void Xor (const SmartOperand&, const SmartOperand&, const SmartOperand&);
	void Branch (const SmartOperand&, Instruction::Mnemonic, Code::Size = 0);
	void Branch (const Code::Operand&, Instruction::Mnemonic, Code::Size = 0);
	void Copy (const SmartOperand&, const SmartOperand&, const SmartOperand&);
	void Convert (const SmartOperand&, const SmartOperand&, const Code::Type&);
	void Fill (const SmartOperand&, const SmartOperand&, const SmartOperand&, const Code::Type&);
	void Shift (const SmartOperand&, const SmartOperand&, const SmartOperand&, Instruction::Mnemonic, Instruction::Mnemonic);

	void Branch (const Label&, Instruction::Mnemonic = Instruction::RJMP);
	void Branch (const Label&, Instruction::Mnemonic, Instruction::Mnemonic);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto GetPatchScale (const Code::Type&) const -> Object::Patch::Scale override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static const Operand immediatePatch;
	static constexpr Register Reserved = R16, RResL = R0, RFPL = R24, RFPH = R25;
};

using SmartOperand = class Context::SmartOperand
{
public:
	enum Mode {Preserve, Increment, Decrement, Default = Decrement};
	enum Model {Immediate, Register, IORegister, Address, Index};

	Model model;
	Code::Type::Size size;
	const AVR::Register index;
	AVR::IORegister ioregister;

	SmartOperand (Context&, const Code::Type&, AVR::Register = Reserved, bool = false);
	SmartOperand (Context&, const Code::Operand&, AVR::Register = Reserved);
	~SmartOperand ();

	Byte Extract (Context::Index) const;
	bool IsConstant (Context::Index) const;
	bool IsRegisterPair (Context::Index) const;
	AVR::Register Select (Context::Index) const;
	AVR::Register Load (Context::Index, Mode = Default) const;
	void Load (AVR::Register, Context::Index, Mode = Default) const;
	void Store (AVR::Register, Context::Index, Mode = Default) const;

	bool operator == (const SmartOperand&) const;
	bool operator != (const SmartOperand&) const;

private:
	bool release;
	RegisterSet set;
	Context& context;
	Code::Unsigned::Value imm;
	const Code::Operand* address;
	mutable AVR::Register temporary;

	Operand::Type GetIndex (Mode) const;
};

const Operand Context::immediatePatch {0};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c, const ProgramMemorySize pms) :
	Assembly::Generator {d, sp, assembler, "avr", "AVR", {{2, 1, 1}, {4, 1, 1}, {2, 1}, {2, 1}, {1, 1, 1}, true}, false}, assembler {d, c}, programMemorySize {pms}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const AVR::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, true}, programMemorySize {g.programMemorySize}, rsp {g.platform.pointer, Code::RSP}, rfp {g.platform.pointer, Code::RFP}
{
	acquired.set (RXL).set (RXH).set (RYL).set (RYH).set (RZL).set (RZH).set (Reserved);
	Acquire (registers[Code::RFP], 2, RFPL);
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction));
	instruction.Emit (Reserve (GetSize (instruction)));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Invalidate (const Register register_)
{
	if (register_ == Reserved) reservedValue = -1;
}

void Context::Move (const Register target, const Register source)
{
	Invalidate (target);
	if (target != source) Emit (MOV {target, source});
}

void Context::MoveWord (const Register target, const Register source)
{
	Invalidate (target);
	if (target != source) Emit (MOVW {RegisterPair {target}, RegisterPair {source}});
}

void Context::EmitLoad (const Register register_, const Byte value, const bool useLDI)
{
	if (register_ == Reserved) if (value == reservedValue) return; else reservedValue = value;
	if (value == 0 && !useLDI) return Emit (CLR {register_});
	if (register_ >= R16 && value == 255 && !useLDI) return Emit (SER {register_});
	if (register_ >= R16) return Emit (LDI {register_, value});
	EmitLoad (Reserved, value, useLDI); Move (register_, Reserved);
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand& operand1, const Operand& operand2, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	assert (!address.empty ());
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	const Instruction instruction {mnemonic, operand1, operand2};
	assert (IsValid (instruction)); instruction.Adjust (patch); AddLink (address, patch);
	instruction.Emit (Reserve (GetSize (instruction))); if (!listing) return;
	listing << '\t' << mnemonic << '\t'; if (&operand1 != &immediatePatch) listing << operand1 << ", ";
	WriteAddress (listing, nullptr, address, displacement, scale);
	if (&operand2 != &immediatePatch && !IsEmpty (operand2)) listing << ", " << operand2; listing << '\n';
}

Register Context::Acquire ()
{
	auto register_ = R31; while (register_ != R0 && acquired.test (register_)) register_ = Register (register_ - 1);
	if (register_ == R0) throw RegisterShortage {}; Acquire (register_); return register_;
}

void Context::Acquire (Register& low, Register& high)
{
	Register register_ = R30;
	while (register_ != R0 && (acquired.test (register_) || acquired.test (register_ + 1))) register_ = Register (register_ - 2);
	if (register_ == R0) high = Acquire (), low = Acquire ();
	else Acquire (low = register_), Acquire (high = Register (register_ + 1));
}

void Context::Acquire (const Register register_)
{
	assert (!acquired.test (register_));
	acquired.flip (register_);
}

void Context::Release (const Register register_)
{
	assert (acquired.test (register_));
	acquired.flip (register_);
}

void Context::Acquire (RegisterSet& set, Code::Type::Size size)
{
	set.resize (size); if (size % 2) do set[--size] = Acquire (); while (size);
	else do size -= 2, Acquire (set[size], set[size + 1]); while (size);
}

void Context::Acquire (RegisterSet& set, const Code::Type::Size size, Register register_)
{
	set.clear (); set.reserve (size); for (; set.size () != size; set.push_back (register_), register_ = Register (register_ + 1)) if (!acquired[register_]) Acquire (register_);
}

void Context::Release (const RegisterSet& set)
{
	for (auto register_: set) Release (register_);
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	Code::Type::Size size = 0;
	for (auto& type: types) size = std::max (size, type.size);
	if (register_ == Code::RRes) Acquire (registers[register_], size, RResL); else Acquire (registers[register_], size);
}

void Context::Release (const Code::Register register_)
{
	Release (registers[register_]);
}

bool Context::IsRequired (const Index index, const Index requiredIndex, const SmartOperand& item1, const SmartOperand*const item2, const SmartOperand*const item3)
{
	if (index == 0) nextredundant = true, repeatCounter = Reserved;
	if (index < requiredIndex) return true;
	if (repeatCounter != Reserved && nextredundant) Emit (DEC {repeatCounter}), Branch (repeat, Instruction::BRNE), Release (repeatCounter), nextredundant = false;
	if (repeatCounter != Reserved) return false;
	for (Index i = index; nextredundant && i != item1.size; ++i)
		if (!item1.IsConstant (i) || item2 && !item2->IsConstant (i) || item3 && !item3->IsConstant (i)) nextredundant = false;
	if (nextredundant && index + 2 < item1.size) {EmitLoad (repeatCounter = Acquire (), Byte (item1.size - index)); auto label = CreateLabel (); label (), repeat = label;}
	nextredundant = true; return true;
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
	case Code::Instruction::PUSH:
	case Code::Instruction::POP:
		return true;

	case Code::Instruction::MUL:
		return instruction.operand1.type.size <= 2;

	case Code::Instruction::DIV:
	case Code::Instruction::MOD:
	case Code::Instruction::TRAP:
		return false;

	default:
		return instruction.operand1.type.model != Code::Type::Float && instruction.operand2.type.model != Code::Type::Float;
	}
}

void Context::Generate (const Code::Instruction& instruction)
{
	assert (IsSupported (instruction));

	Invalidate (Reserved);

	if (IsAddress (instruction.operand1))
		if (instruction.mnemonic == Code::Instruction::JUMP) return Branch (instruction.operand1, programMemorySize <= 8 * 1024 ? Instruction::RJMP : Instruction::JMP);
		else if (instruction.mnemonic == Code::Instruction::CALL) return Branch (instruction.operand1, programMemorySize <= 8 * 1024 ? Instruction::RCALL : Instruction::CALL, instruction.operand2.size);

	const SmartOperand operand1 {*this, instruction.operand1, RXL};
	const SmartOperand operand2 {*this, instruction.operand2, RYL};
	const SmartOperand operand3 {*this, instruction.operand3, RZL};

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
		Move (operand1, operand2);
		break;

	case Code::Instruction::CONV:
		Convert (operand1, operand2, instruction.operand2.type);
		break;

	case Code::Instruction::COPY:
		Copy (operand1, operand2, operand3);
		break;

	case Code::Instruction::FILL:
		Fill (operand1, operand2, operand3, instruction.operand3.type);
		break;

	case Code::Instruction::NEG:
		Neg (operand1, operand2);
		break;

	case Code::Instruction::ADD:
		if (instruction.operand1 == instruction.operand2) Increment (operand1, operand3); else Add (operand1, operand2, operand3);
		break;

	case Code::Instruction::SUB:
		if (instruction.operand1 == instruction.operand2) Decrement (operand1, operand3); else Sub (operand1, operand2, operand3);
		break;

	case Code::Instruction::MUL:
		Mul (operand1, operand2, operand3);
		break;

	case Code::Instruction::NOT:
		Not (operand1, operand2);
		break;

	case Code::Instruction::AND:
		And (operand1, operand2, operand3);
		break;

	case Code::Instruction::OR:
		Or (operand1, operand2, operand3);
		break;

	case Code::Instruction::XOR:
		Xor (operand1, operand2, operand3);
		break;

	case Code::Instruction::LSH:
		Shift (operand1, operand2, operand3, Instruction::LSL, Instruction::ROL);
		break;

	case Code::Instruction::RSH:
		Shift (operand1, operand2, operand3, instruction.operand1.type.model == Code::Type::Signed ? Instruction::ASR : Instruction::LSR, Instruction::ROR);
		break;

	case Code::Instruction::PUSH:
		Push (operand1);
		break;

	case Code::Instruction::POP:
		Pop (operand1);
		break;

	case Code::Instruction::CALL:
		Branch (operand1, Instruction::ICALL, instruction.operand2.size);
		break;

	case Code::Instruction::RET:
		Emit (RET {});
		break;

	case Code::Instruction::ENTER:
		Push ({*this, rfp});
		Move ({*this, rfp}, {*this, rsp});
		if (instruction.operand1.size) Decrement ({*this, rsp}, {*this, Code::PtrImm (generator.platform.pointer, instruction.operand1.size)});
		break;

	case Code::Instruction::LEAVE:
		Move ({*this, rsp}, {*this, rfp});
		Pop ({*this, rfp});
		break;

	case Code::Instruction::BR:
		Branch (GetLabel (instruction.operand1.offset));
		break;

	case Code::Instruction::BREQ:
		Compare (operand2, operand3);
		Branch (GetLabel (instruction.operand1.offset), Instruction::BREQ, Instruction::BRNE);
		break;

	case Code::Instruction::BRNE:
		Compare (operand2, operand3);
		Branch (GetLabel (instruction.operand1.offset), Instruction::BRNE, Instruction::BREQ);
		break;

	case Code::Instruction::BRLT:
		Compare (operand2, operand3);
		if (instruction.operand2.type.model == Code::Type::Signed)
			Branch (GetLabel (instruction.operand1.offset), Instruction::BRLT, Instruction::BRGE);
		else
			Branch (GetLabel (instruction.operand1.offset), Instruction::BRLO, Instruction::BRSH);
		break;

	case Code::Instruction::BRGE:
		Compare (operand2, operand3);
		if (instruction.operand2.type.model == Code::Type::Signed)
			Branch (GetLabel (instruction.operand1.offset), Instruction::BRGE, Instruction::BRLT);
		else
			Branch (GetLabel (instruction.operand1.offset), Instruction::BRSH, Instruction::BRLO);
		break;

	case Code::Instruction::JUMP:
		Branch (operand1, Instruction::IJMP);
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const SmartOperand& target, const SmartOperand& source)
{
	assert (target.size <= source.size);

	if (source.model == SmartOperand::Index && target.model == SmartOperand::Register && source.index == target.Select (0))
	{
		const SmartOperand temporary {*this, generator.platform.pointer};
		return Move (temporary, source), Move (target, temporary);
	}

	for (Index index = 0; index != target.size && IsRequired (index, 0, target, &source); ++index)
		Move (target, source, index);
}

void Context::Move (const SmartOperand& target, const SmartOperand& source, const Index index)
{
	if (target.IsRegisterPair (index) && source.IsRegisterPair (index))
		MoveWord (target.Select (index), source.Select (index));
	else if (index && target.IsRegisterPair (index - 1) && source.IsRegisterPair (index - 1));
	else if (target.model == SmartOperand::Register) source.Load (target.Select (index), index);
	else target.Store (source.Load (index), index);
}

void Context::Convert (const SmartOperand& target, const SmartOperand& source, const Code::Type& type)
{
	if (target.size <= source.size) return Move (target, source);

	Index index = 0;
	for (; index != source.size - 1; ++index) Move (target, source, index);

	if (type.model == Code::Type::Signed)
	{
		source.Load (Reserved, index);
		target.Store (Reserved, index);
		Emit (ORI {Reserved, 127});
		Emit (SBRS {Reserved, 7});
	}
	else
		Move (target, source, index);

	Emit (CLR {Reserved});
	while (++index != target.size) target.Store (Reserved, index);
}

void Context::Copy (const SmartOperand& target, const SmartOperand& source, const SmartOperand& size)
{
	const SmartOperand start {*this, generator.platform.pointer, RXL}; Move (start, target);
	Move ({*this, generator.platform.pointer, RYL}, source);
	const SmartOperand end {*this, generator.platform.pointer, RZL}; Move (end, size);
	Increment (end, start); auto begin = CreateLabel (); begin (); Compare (start, end);
	Branch (GetLabel (0), Instruction::BREQ); Emit (LD {Reserved, Operand::Yi});
	Emit (ST {Operand::Xi, Reserved}); Branch (begin);
}

void Context::Fill (const SmartOperand& target, const SmartOperand& size, const SmartOperand& value, const Code::Type& type)
{
	const SmartOperand start {*this, generator.platform.pointer, RXL}; Move (start, target);
	const SmartOperand end {*this, generator.platform.pointer, RYL}; Move (end, size);
	auto begin = CreateLabel (); begin (); if (value.model == SmartOperand::Index) Emit (SBIW {RegisterPair {RZL}, value.size});
	Compare (end, {*this, Code::PtrImm (generator.platform.pointer, 0)}); Branch (GetLabel (0), Instruction::BREQ);
	for (Index index = type.size; index;) --index, Emit (ST {Operand::Xi, value.Load (index, SmartOperand::Increment)});
	Emit (SBIW {RegisterPair {RYL}, 1}); Branch (begin);
}

void Context::Increment (const SmartOperand& target, const SmartOperand& value)
{
	if (target.IsRegisterPair (0) && target.Select (0) >= R24 && value.model == SmartOperand::Immediate && value.Extract (0) <= 63 && value.Extract (1) == 0)
		return Emit (ADIW {RegisterPair {target.Select (0)}, value.Extract (0)});

	if (target.model == SmartOperand::IORegister && target.ioregister == SPL && target.size == 2 && value.model == SmartOperand::Immediate && value.Extract (0) <= 4 && value.Extract (1) == 0)
	{
		for (unsigned i = value.Extract (0); i; --i) Emit (POP {Reserved}); return Invalidate (Reserved);
	}

	for (Index index = 0; index != target.size && IsRequired (index, 1, target, &value); ++index)
	{
		const auto register_ = target.Load (index, SmartOperand::Decrement);
		if (value.model == SmartOperand::Immediate && register_ >= R16)
			Emit ({index ? Instruction::SBCI : Instruction::SUBI, register_, Byte (0xff - value.Extract (index) + (index == 0))});
		else
			Emit ({index ? Instruction::ADC : Instruction::ADD, register_, value.Load (index)});
		target.Store (register_, index, SmartOperand::Preserve);
	}
}

void Context::Decrement (const SmartOperand& target, const SmartOperand& value)
{
	if (target.IsRegisterPair (0) && target.Select (0) >= R24 && value.model == SmartOperand::Immediate && value.Extract (0) <= 63 && value.Extract (1) == 0)
		return Emit (SBIW {RegisterPair {target.Select (0)}, value.Extract (0)});

	if (target.model == SmartOperand::IORegister && target.ioregister == SPL && target.size == 2 && value.model == SmartOperand::Immediate && value.Extract (0) <= 4 && value.Extract (1) == 0)
	{
		for (unsigned i = value.Extract (0); i; --i) Emit (PUSH {Reserved}); return;
	}

	for (Index index = 0; index != target.size && IsRequired (index, 1, target, &value); ++index)
	{
		const auto register_ = target.Load (index, SmartOperand::Decrement);
		if (value.model == SmartOperand::Immediate && register_ >= R16)
			Emit ({index ? Instruction::SBCI : Instruction::SUBI, register_, value.Extract (index)});
		else
			Emit ({index ? Instruction::SBC : Instruction::SUB, register_, value.Load (index)});
		target.Store (register_, index, SmartOperand::Preserve);
	}
}

void Context::Push (const SmartOperand& value)
{
	if (value.size == 1) return Emit (PUSH {value.Load (0)});

	for (Index index = 0; index != value.size && (value.model != SmartOperand::Index || IsRequired (index, 0, value)); ++index)
		Emit (PUSH {value.Load (index, SmartOperand::Decrement)});
}

void Context::Pop (const SmartOperand& target)
{
	if (target.model == SmartOperand::Index)
		Decrement ({*this, generator.platform.pointer, target.index}, {*this, Code::PtrImm (generator.platform.pointer, target.size)});

	for (Index index = target.size; index && IsRequired (target.size - index, 0, target);)
		if (target.model == SmartOperand::Register) Emit (POP {target.Select (--index)});
		else Emit (POP {Reserved}), target.Store (Reserved, --index, SmartOperand::Increment);
}

void Context::Neg (const SmartOperand& target, const SmartOperand& value)
{
	RegisterSet set {value.size};

	for (Index index = 0; index != value.size; ++index)
		value.Load (set[index] = target.model == SmartOperand::Register ? target.Select (index) : Acquire (), index);

	for (Index index = 1; index != value.size; ++index)
		Emit (COM {set[index]});

	Emit (NEG {set[0]});

	for (Index index = 1; index != value.size; ++index)
		if (set[index] >= R16) Emit (SBCI {set[index], 255});
		else EmitLoad (Reserved, 255), Emit (SBC {set[index], Reserved});

	for (Index index = 0; index != value.size; ++index)
		target.Store (set[index], index);

	if (target.model != SmartOperand::Register) Release (set);
}

void Context::Add (const SmartOperand& target, const SmartOperand& value1, const SmartOperand& value2)
{
	if (target.model == SmartOperand::Register && value2 == target && value1 != value2) return Add (target, value2, value1);

	for (Index index = 0; index != target.size && IsRequired (index, 1, target, &value1, &value2); ++index)
	{
		const auto register_ = target.model == SmartOperand::Register ? target.Select (index) : Acquire ();
		value1.Load (register_, index);
		Emit ({index ? Instruction::ADC : Instruction::ADD, register_, value2.Load (index)});
		if (target.model != SmartOperand::Register) target.Store (register_, index), Release (register_);
	}
}

void Context::Sub (const SmartOperand& target, const SmartOperand& value1, const SmartOperand& value2)
{
	for (Index index = 0; index != target.size && IsRequired (index, 1, target, &value1, &value2); ++index)
	{
		const auto register_ = target.model == SmartOperand::Register && value2 != target ? target.Select (index) : Acquire ();
		value1.Load (register_, index);
		Emit ({index ? Instruction::SBC : Instruction::SUB, register_, value2.Load (index)});
		if (target.model != SmartOperand::Register || value2 == target) target.Store (register_, index), Release (register_);
	}
}

void Context::Mul (const SmartOperand& target, const SmartOperand& value1, const SmartOperand& value2)
{
	if (value1.model == SmartOperand::Immediate && value1.size <= 2 && IsPowerOfTwo (value1.Extract (0)) && value1.Extract (0) <= 4 && !value1.Extract (1))
		return Shift (target, value2, {*this, Code::UImm (Code::Unsigned {value1.size}, CountOnes (value1.Extract (0) - 1u))}, Instruction::LSL, Instruction::ROL);
	if (value2.model == SmartOperand::Immediate && value2.size <= 2 && IsPowerOfTwo (value2.Extract (0)) && value2.Extract (0) <= 4 && !value2.Extract (1))
		return Shift (target, value1, {*this, Code::UImm (Code::Unsigned {value2.size}, CountOnes (value2.Extract (0) - 1u))}, Instruction::LSL, Instruction::ROL);

	const auto disjunctTarget = target.model != SmartOperand::Register || target.Select (0) != R0;
	const auto disjunctValues = value1.model != SmartOperand::Register || value2.model != SmartOperand::Register || value1.Select (0) != value2.Select (0);
	const auto disjunctValue1 = target.size == 1 || target.model != SmartOperand::Register || value1.model != SmartOperand::Register || target.Select (0) != value1.Select (0);
	const auto disjunctValue2 = target.size == 1 || target.model != SmartOperand::Register || value2.model != SmartOperand::Register || target.Select (0) != value2.Select (0);

	if (disjunctTarget)
	{
		if (acquired[R0]) Emit (PUSH {R0});
		if (acquired[R1] && target.size != 1) Emit (PUSH {R1});
	}

	RegisterSet res, temporary1, temporary2;
	for (Index index = 0; index != target.size; ++index)
	{
		res.push_back (target.model == SmartOperand::Register && target.Select (0) != R0 ? target.Select (index) : Acquire ());
		temporary1.push_back (value1.model == SmartOperand::Register && value1.Select (0) != R0 && disjunctValue1 ? value1.Select (index) : Acquire ());
		if (value1.model != SmartOperand::Immediate || value1.Extract (index)) value1.Load (temporary1[index], index);
		temporary2.push_back (value2.model == SmartOperand::Register && value2.Select (0) != R0 && disjunctValue2 && disjunctValues ? value2.Select (index) : Acquire ());
		if (value2.model != SmartOperand::Immediate || value2.Extract (index)) value2.Load (temporary2[index], index);
	}

	for (Index index1 = 0; index1 != target.size; ++index1)
	{
		if (value1.model == SmartOperand::Immediate && value1.Extract (index1) == 0) continue;

		for (Index index2 = 0; index2 != target.size - index1; ++index2)
		{
			if (value2.model == SmartOperand::Immediate && value2.Extract (index2) == 0) continue;

			Emit (MUL {temporary1[index1], temporary2[index2]});

			for (Index index = index1 + index2; index != target.size; ++index)
				if (index1 == 0 && index2 == 0)
					if (index == 0 && target.size != 1 && target.IsRegisterPair (0) && disjunctTarget) MoveWord (target.Select (0), R0);
					else if (index == 1 && target.size != 1 && target.IsRegisterPair (0) && disjunctTarget) continue;
					else if (index == 0 && disjunctTarget) target.Store (R0, 0);
					else if (index < 2) Move (res[index], Register (index));
					else EmitLoad (res[index], 0);
				else if (index == index1 + index2) Emit (ADD {res[index], R0});
				else if (index == index1 + index2 + 1) Emit (ADC {res[index], R1});
				else EmitLoad (Reserved, 0), Emit (ADC {res[index], Reserved});
		}
	}

	for (Index index = disjunctTarget; index != target.size; ++index)
		target.Store (res[index], index);

	if (disjunctTarget)
	{
		if (acquired[R1] && target.size != 1) Emit (POP {R1});
		if (acquired[R0]) Emit (POP {R0});
	}

	if (target.model != SmartOperand::Register || target.Select (0) == R0) Release (res);
	if (value1.model != SmartOperand::Register || value1.Select (0) == R0 || !disjunctValue1) Release (temporary1);
	if (value2.model != SmartOperand::Register || value2.Select (0) == R0 || !disjunctValue2 || !disjunctValues) Release (temporary2);
}

void Context::Not (const SmartOperand& target, const SmartOperand& value)
{
	for (Index index = 0; index != target.size && IsRequired (index, 0, target, &value); ++index)
	{
		const auto register_ = target.model == SmartOperand::Register ? target.Select (index) : Acquire ();
		value.Load (register_, index);
		Emit (COM {register_});
		if (target.model != SmartOperand::Register) target.Store (register_, index), Release (register_);
	}
}

void Context::And (const SmartOperand& target, const SmartOperand& value1, const SmartOperand& value2)
{
	if (value1.model == SmartOperand::Immediate && value2.model != SmartOperand::Immediate) return And (target, value2, value1);
	if (target.model == SmartOperand::Register && value2 == target && value1 != value2) return And (target, value2, value1);

	for (Index index = 0; index != target.size && IsRequired (index, 0, target, &value1, &value2); ++index)
	{
		const auto register_ = target.model == SmartOperand::Register ? target.Select (index) : Acquire ();
		value1.Load (register_, index);
		if (value2.model == SmartOperand::Immediate && register_ >= R16) Emit (ANDI {register_, value2.Extract (index)}); else Emit (AND {register_, value2.Load (index)});
		if (target.model != SmartOperand::Register) target.Store (register_, index), Release (register_);
	}
}

void Context::Or (const SmartOperand& target, const SmartOperand& value1, const SmartOperand& value2)
{
	if (value1.model == SmartOperand::Immediate && value2.model != SmartOperand::Immediate) return Or (target, value2, value1);
	if (target.model == SmartOperand::Register && value2 == target && value1 != value2) return Or (target, value2, value1);

	for (Index index = 0; index != target.size && IsRequired (index, 0, target, &value1, &value2); ++index)
	{
		const auto register_ = target.model == SmartOperand::Register ? target.Select (index) : Acquire ();
		value1.Load (register_, index);
		if (value2.model == SmartOperand::Immediate && register_ >= R16) Emit (ORI {register_, value2.Extract (index)}); else Emit (OR {register_, value2.Load (index)});
		if (target.model != SmartOperand::Register) target.Store (register_, index), Release (register_);
	}
}

void Context::Xor (const SmartOperand& target, const SmartOperand& value1, const SmartOperand& value2)
{
	if (target.model == SmartOperand::Register && value2 == target && value1 != value2) return Xor (target, value2, value1);

	for (Index index = 0; index != target.size && IsRequired (index, 0, target, &value1, &value2); ++index)
	{
		const auto register_ = target.model == SmartOperand::Register ? target.Select (index) : Acquire ();
		value1.Load (register_, index);
		Emit (EOR {register_, value2.Load (index)});
		if (target.model != SmartOperand::Register) target.Store (register_, index), Release (register_);
	}
}

void Context::Shift (const SmartOperand& target, const SmartOperand& value, const SmartOperand& count, const Instruction::Mnemonic shift, const Instruction::Mnemonic rotate)
{
	RegisterSet set {value.size};
	auto counter = Acquire ();
	auto begin = CreateLabel (), end = CreateLabel ();

	const auto unroll = count.model == SmartOperand::Immediate && count.Extract (0) * value.size <= 4;
	if (!unroll) count.Load (counter, 0);

	for (Index index = 0; index != value.size; ++index)
		value.Load (set[index] = target.model == SmartOperand::Register ? target.Select (index) : Acquire (), index);

	if (!unroll && count.model != SmartOperand::Immediate) Emit (TST {counter}), Branch (target.model == SmartOperand::Register ? GetLabel (0) : end, Instruction::BREQ);

	begin ();
	for (Index repeat = unroll ? count.Extract (0) : 1; repeat; --repeat)
		for (Index index = 0; index != value.size; ++index)
			Emit ({index ? rotate : shift, set[rotate == Instruction::ROR ? value.size - index - 1 : index]});

	if (!unroll) Emit (DEC {counter}), Branch (begin, Instruction::BRNE);
	Release (counter);

	end ();
	if (target.model == SmartOperand::Register) return;

	for (Index index = 0; index != value.size; ++index)
		target.Store (set[index], index);
	Release (set);
}

void Context::Compare (const SmartOperand& value1, const SmartOperand& value2)
{
	for (Index index = 0; index != value1.size; ++index)
	{
		const auto register_ = value1.model == SmartOperand::Register ? value1.Select (index) : Acquire ();
		if (value1.model == SmartOperand::Immediate) EmitLoad (register_, value1.Extract (index), true); else value1.Load (register_, index);
		const auto compare = index ? Instruction::CPC : Instruction::CP;
		if (value2.model == SmartOperand::Immediate && register_ >= R16 && compare == Instruction::CP) Emit (CPI {register_, value2.Extract (index)});
		else if (value2.model == SmartOperand::Immediate) EmitLoad (Reserved, value2.Extract (index), true), Emit ({compare, register_, Reserved});
		else Emit ({compare, register_, value2.Load (index)});
		if (value1.model != SmartOperand::Register) Release (register_);
	}
}

void Context::Branch (const Code::Operand& target, const Instruction::Mnemonic mnemonic, const Code::Size size)
{
	assert (IsAddress (target)); Emit (mnemonic, immediatePatch, {}, target.address, target.displacement, 0);
	if (size) Increment ({*this, rsp}, {*this, Code::PtrImm (generator.platform.pointer, size)});
}

void Context::Branch (const SmartOperand& target, const Instruction::Mnemonic mnemonic, const Code::Size size)
{
	const SmartOperand address {*this, generator.platform.pointer, RZL}; Move (address, target); Emit ({mnemonic});
	if (size) Increment ({*this, rsp}, {*this, Code::PtrImm (generator.platform.pointer, size)});
}

void Context::Branch (const Label& label, const Instruction::Mnemonic mnemonic)
{
	AddFixup (label, mnemonic, 2); if (listing) listing << '\t' << mnemonic << '\t' << label << '\n';
}

void Context::Branch (const Label& label, const Instruction::Mnemonic trueMnemonic, const Instruction::Mnemonic falseMnemonic)
{
	const auto offset = GetBranchOffset (label, 2);
	if (offset <= 0 && offset >= -126) return Branch (label, trueMnemonic);
	Emit ({falseMnemonic, 2}); Branch (label);
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const Instruction instruction {Instruction::Mnemonic (code), signed (target - bytes.end ())};
	assert (IsValid (instruction)); assert (GetSize (instruction) == bytes.size ()); instruction.Emit (bytes);
}

Context::Part Context::GetRegisterParts (const Code::Operand& operand) const
{
	return operand.register_ == Code::RSP ? 0 : operand.type.size;
}

Context::Suffix Context::GetRegisterSuffix (const Code::Operand& operand, const Part part) const
{
	return operand.type.size > 1 ? part + '0' : 0;
}

Object::Patch::Scale Context::GetPatchScale (const Code::Type& type) const
{
	return type.model == Code::Type::Function;
}

std::ostream& Context::WriteRegister (std::ostream& stream, const Code::Operand& operand, const Part part)
{
	return stream << registers[operand.register_][part];
}

SmartOperand::SmartOperand (Context& c, const Code::Type& type, const AVR::Register i, const bool indexed) :
	model {indexed ? Index : Register}, size {type.size}, index {i}, release {i == Reserved}, context {c}, temporary {Reserved}
{
	if (model == Register) if (release) context.Acquire (set, size); else context.Acquire (set, size, index);
}

SmartOperand::SmartOperand (Context& c, const Code::Operand& operand, const AVR::Register i) :
	model {Register}, size {operand.type.size}, index {i}, release {false}, context {c}, temporary {Reserved}
{
	const auto type = IsMemory (operand) ? context.generator.platform.pointer : operand.type;
	const auto displacement = operand.displacement + (IsMemory (operand)) * size;
	const auto scale = context.GetPatchScale (type);

	switch (operand.model)
	{
	case Code::Operand::Void: case Code::Operand::Size: case Code::Operand::Offset: case Code::Operand::String: return;
	case Code::Operand::Immediate: imm = Code::Convert (operand) >> scale; model = Immediate; return;
	case Code::Operand::Address: assert (IsAddress (type)); break;
	case Code::Operand::Register: if (displacement) break;
		if (operand.register_ == Code::RSP) ioregister = SPL, model = IORegister;
		else set = context.registers[operand.register_]; return;
	case Code::Operand::Memory: if (operand.register_ != Code::RVoid || size > 1) break;
		address = &operand; model = Address; return;
	default: assert (Code::Operand::Unreachable);
	}

	if (index && type.size <= context.generator.platform.pointer.size) context.Acquire (set, size = type.size, index);
	else context.Acquire (set, size), release = true;

	if (!operand.address.empty ())
	{
		assert (set.size () == 2); assert (set[0] >= R16); assert (set[1] >= R16);
		context.Emit (Instruction::LDI, set[0], immediatePatch, operand.address, displacement, scale);
		context.Emit (Instruction::LDI, set[1], immediatePatch, operand.address, displacement, scale + 8);
	}

	if (operand.register_ != Code::RVoid)
		if (operand.address.empty ()) context.Move (*this, {context, Code::Reg {type, operand.register_}});
		else context.Increment (*this, {context, Code::Reg {type, operand.register_}});

	if (operand.address.empty ())
		if (operand.register_ == Code::RVoid)
			context.EmitLoad (set[0], Byte (operand.ptrimm >> scale)), context.EmitLoad (set[1], Byte (operand.ptrimm >> (scale + 8)));
		else if (displacement > 0 && displacement < 64 && set.size () == 2 && AVR::IsRegisterPair (set[0], set[1]) && set[0] >= R24)
			context.Emit (ADIW {RegisterPair {set[0]}, Byte (displacement)});
		else if (displacement > 0)
			context.Increment (*this, {context, Code::PtrImm (type, displacement)});
		else if (displacement < 0)
			context.Decrement (*this, {context, Code::PtrImm (type, -displacement)});

	if (IsMemory (operand)) model = Index, size = operand.type.size;
}

SmartOperand::~SmartOperand ()
{
	if (release) context.Release (set);
	if (temporary != Reserved) context.Release (temporary);
}

Byte SmartOperand::Extract (const Context::Index index) const
{
	assert (model == Immediate); return imm >> index * 8;
}

Register SmartOperand::Select (const Context::Index index) const
{
	assert (model == Register);
	assert (index < set.size ());
	return set[index];
}

Operand::Type SmartOperand::GetIndex (const Mode mode) const
{
	if (mode == Increment) return index == RXL ? Operand::Xi : index == RYL ? Operand::Yi : Operand::Zi;
	if (mode == Decrement) return index == RXL ? Operand::Xd : index == RYL ? Operand::Yd : Operand::Zd;
	return index == RXL ? Operand::X : index == RYL ? Operand::Y : Operand::Z;
}

Register SmartOperand::Load (const Context::Index index, const Mode mode) const
{
	if (temporary != Reserved) context.Release (temporary), temporary = Reserved;
	if (model == Register) return Select (index);
	if (model == Immediate) return Load (temporary, index, mode), temporary;
	return Load (temporary = context.Acquire (), index, mode), temporary;
}

void SmartOperand::Load (const AVR::Register register_, const Context::Index index, const Mode mode) const
{
	if (model == IORegister) context.Invalidate (register_), context.Emit (IN {register_, ioregister + index});
	else if (model == Immediate) context.EmitLoad (register_, Extract (index));
	else if (model == Address) context.Invalidate (register_), address->address.empty () ? context.Emit (LDS {register_, unsigned (address->displacement)}) : context.Emit (Instruction::LDS, register_, immediatePatch, address->address, address->displacement, 0);
	else if (model == Index) context.Invalidate (register_), context.Emit (LD {register_, GetIndex (mode)});
	else context.Move (register_, Select (index));
}

void SmartOperand::Store (const AVR::Register register_, const Context::Index index, const Mode mode) const
{
	if (model == IORegister) context.Emit (OUT {ioregister + index, register_});
	else if (model == Address) address->address.empty () ? context.Emit (STS {unsigned (address->displacement), register_}) : context.Emit (Instruction::STS, immediatePatch, register_, address->address, address->displacement, 0);
	else if (model == Index) context.Emit (ST {GetIndex (mode), register_});
	else context.Move (Select (index), register_);
}

bool SmartOperand::IsConstant (Context::Index index) const
{
	if (model != Immediate) return model == Index;
	const auto value = Extract (index);
	while (++index != size && Extract (index) == value);
	return index == size;
}

bool SmartOperand::IsRegisterPair (const Context::Index index) const
{
	return model == Register && index + 1 < set.size () && AVR::IsRegisterPair (set[index], set[index + 1]);
}

bool SmartOperand::operator == (const SmartOperand& other) const
{
	return model == other.model && Select (0) == other.Select (0);
}

bool SmartOperand::operator != (const SmartOperand& other) const
{
	return !(*this == other);
}

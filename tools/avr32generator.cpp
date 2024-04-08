// AVR32 machine code generator
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
#include "avr32.hpp"
#include "avr32generator.hpp"

using namespace ECS;
using namespace AVR32;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const AVR32::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	enum Index {Low, High};

	class SmartOperand;

	bool acquired[16] {};
	Register registers[2][Code::Registers];

	void Acquire (Register);
	void Release (Register);

	Register GetFree (Index) const;
	Register Select (const Code::Operand&, Index) const;
	Immediate Extract (const Code::Operand&, Index) const;

	SmartOperand Acquire (Index);
	SmartOperand Load (const Code::Operand&, Index);
	SmartOperand Acquire (const Code::Operand&, Index);

	void Load (const Operand&, const Code::Operand&, Index);
	void Store (const Operand&, const Code::Operand&, Index);
	void Access (void (Context::*) (const Operand&, const Code::Operand&, const Operand&), const Operand&, const Code::Operand&, Index);
	void Load (const Operand&, const Code::Operand&, const Operand&);
	void Store (const Operand&, const Code::Operand&, const Operand&);

	void Emit (const Instruction&);

	void Load (const Operand&, Immediate);
	void Load (const Operand&, const Code::Section::Name&, Code::Displacement);
	void Load (Instruction::Mnemonic, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);

	void Pop (const Code::Operand&, Index);
	void Push (const Code::Operand&, Index);
	void Branch (Instruction::Mnemonic, Code::Offset);
	void Branch (Instruction::Mnemonic, const Label&);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void Convert (const Code::Operand&, const Code::Operand&, Index);
	void Compare (const Code::Operand&, const Code::Operand&, Index);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, Index);
	void Shift (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void Divide (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index, Index);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static bool IsComplex (const Code::Operand&);
	static Instruction::Mnemonic GetLoadMnemonic (const Code::Operand&);
	static Instruction::Mnemonic GetStoreMnemonic (const Code::Operand&);
	static Instruction::Mnemonic GetCompareMnemonic (const Code::Operand&);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (SmartOperand&&) noexcept;
	SmartOperand (Context&, AVR32::Register);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c) :
	Assembly::Generator {d, sp, assembler, "avr32", "AVR32", {{4, 1, 8}, {4, 4, 8}, 4, 4, {0, 4, 8}, true}, true}, assembler {d, c}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const AVR32::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, true}
{
	for (auto& set: registers) for (auto& register_: set) register_ = R15;
	Acquire (registers[Low][Code::RSP] = SP);
	Acquire (registers[Low][Code::RFP] = R12);
	Acquire (registers[Low][Code::RLink] = LR);
	Acquire (PC);
}

void Context::Acquire (const Register register_)
{
	assert (!acquired[register_]); acquired[register_] = true;
}

void Context::Release (const Register register_)
{
	assert (acquired[register_]); acquired[register_] = false;
}

Register Context::GetFree (const Index index) const
{
	auto register_ = R2; while (register_ != R15 && (acquired[register_] || (index == High && (register_ % 2 != 0 || acquired[register_ + 1])))) register_ = Register (register_ + 1);
	if (register_ == R15) throw RegisterShortage {}; return register_;
}

Immediate Context::Extract (const Code::Operand& operand, const Index index) const
{
	assert (IsImmediate (operand)); return Immediate (Code::Convert (operand) >> index * 32);
}

Register Context::Select (const Code::Operand& operand, const Index index) const
{
	assert (IsRegister (operand)); return registers[index][operand.register_];
}

SmartOperand Context::Acquire (const Index index)
{
	return {*this, GetFree (index)};
}

SmartOperand Context::Load (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index);
	auto result = Acquire (index); Load (result, operand, index); return result;
}

SmartOperand Context::Acquire (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index); return Acquire (index);
}

void Context::Load (const Operand& register_, const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		Load (register_, Extract (operand, index));
		break;

	case Code::Operand::Address:
		Load (register_, operand.address, operand.displacement);
		if (operand.register_ != Code::RVoid) Emit (ADD {register_, registers[index][operand.register_]});
		break;

	case Code::Operand::Register:
		if (GetRegister (register_) != registers[index][operand.register_] || operand.displacement)
			Emit (MOV {register_, registers[index][operand.register_]});
		if (operand.displacement) Emit (SUB {register_, Immediate (-operand.displacement)});
		break;

	case Code::Operand::Memory:
		Access (&Context::Load, register_, operand, index);
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Store (const Operand& register_, const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Register:
		if (GetRegister (register_) != registers[index][operand.register_])
			Emit (MOV {registers[index][operand.register_], register_});
		break;

	case Code::Operand::Memory:
		Access (&Context::Store, register_, operand, index);
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Access (void (Context::*const access) (const Operand&, const Code::Operand&, const Operand&), const Operand& register_, const Code::Operand& operand, const Index index)
{
	assert (IsMemory (operand));
	const auto displacement = operand.displacement + index * 4;
	if (operand.address.empty () && operand.register_ != Code::RVoid && displacement >= -32768 && displacement <= 32767)
		return (this->*access) (register_, operand, {registers[Low][operand.register_], Immediate (displacement)});

	const auto base = Acquire (Low);
	if (operand.address.empty ()) Load (base, Immediate (displacement)); else Load (base, operand.address, displacement);
	(this->*access) (register_, operand, operand.register_ != Code::RVoid ? Operand {registers[Low][operand.register_], GetRegister (base), 0} : Operand {GetRegister (base), 0});
}

void Context::Load (const Operand& register_, const Code::Operand& operand, const Operand& base)
{
	Emit ({GetLoadMnemonic (operand), register_, base});
}

void Context::Store (const Operand& register_, const Code::Operand& operand, const Operand& base)
{
	Emit ({GetStoreMnemonic (operand), base, register_});
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction));
	instruction.Emit (Reserve (GetSize (instruction)));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Load (const Operand& register_, const Immediate immediate)
{
	if (immediate >= -1048576 && immediate <= 1048575) Emit (MOV {register_, immediate});
	else Emit (MOVL {register_, immediate & 0xffff}), Emit (ORH {register_, (immediate >> 16) & 0xffff});
}

void Context::Load (const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement)
{
	Load (Instruction::MOVL, register_, address, displacement, 0);
	Load (Instruction::ORH, register_, address, displacement, 16);
}

void Context::Load (const Instruction::Mnemonic mnemonic, const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, register_, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (GetSize (instruction)));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << register_ << ", ", nullptr, address, displacement, scale) << '\n';
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	assert (registers[Low][register_] == R15); assert (registers[High][register_] == R15); Index index = Low;
	for (auto& type: types) if (type.size == 8) index = High;
	Acquire (registers[Low][register_] = (register_ == Code::RRes ? R0 : GetFree (index))); if (index == High) Acquire (registers[High][register_] = Register (registers[Low][register_] + 1));
}

void Context::Release (const Code::Register register_)
{
	assert (registers[Low][register_] != R15); Release (registers[Low][register_]); registers[Low][register_] = R15;
	if (registers[High][register_] != R15) Release (registers[High][register_]), registers[High][register_] = R15;
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	switch (instruction.mnemonic)
	{
	case Code::Instruction::CONV:
	case Code::Instruction::ADD:
	case Code::Instruction::SUB:
	case Code::Instruction::BRLT:
	case Code::Instruction::BRGE:
		return instruction.operand1.type.model != Code::Type::Float;

	case Code::Instruction::NEG:
	case Code::Instruction::MUL:
	case Code::Instruction::DIV:
	case Code::Instruction::MOD:
	case Code::Instruction::LSH:
	case Code::Instruction::RSH:
		return instruction.operand1.type.model != Code::Type::Float && instruction.operand1.type.size <= 4;

	default:
		return true;
	}
}

void Context::Generate (const Code::Instruction& instruction)
{
	assert (IsSupported (instruction));

	auto& operand1 = instruction.operand1;
	auto& operand2 = instruction.operand2;
	auto& operand3 = instruction.operand3;

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
		Move (operand1, operand2, Low);
		if (IsComplex (operand1)) Move (operand1, operand2, High);
		break;

	case Code::Instruction::CONV:
		Convert (operand1, operand2, Low);
		if (IsComplex (operand1)) Convert (operand1, operand2, High);
		break;

	case Code::Instruction::COPY:
		Copy (operand1, operand2, operand3);
		break;

	case Code::Instruction::FILL:
		Fill (operand1, operand2, operand3);
		break;

	case Code::Instruction::NEG:
		Operation (Instruction::NEG, operand1, operand2, Low);
		break;

	case Code::Instruction::ADD:
		Operation (Instruction::ADD, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::ADC, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::SUB:
		Operation (Instruction::SUB, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::SBC, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::MUL:
		Operation (Instruction::MUL, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::DIV:
		Divide (IsSigned (operand1) ? Instruction::DIVS : Instruction::DIVU, operand1, operand2, operand3, Low, Low);
		break;

	case Code::Instruction::MOD:
		Divide (IsSigned (operand1) ? Instruction::DIVS : Instruction::DIVU, operand1, operand2, operand3, Low, High);
		break;

	case Code::Instruction::NOT:
		Operation (Instruction::COM, operand1, operand2, Low);
		if (IsComplex (operand1)) Operation (Instruction::COM, operand1, operand2, High);
		break;

	case Code::Instruction::AND:
		Operation (Instruction::AND, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::AND, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::OR:
		Operation (Instruction::OR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::OR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::XOR:
		Operation (Instruction::EOR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::EOR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::LSH:
		Shift (Instruction::LSL, operand1, operand2, operand3);
		break;

	case Code::Instruction::RSH:
		Shift (IsSigned (operand1) ? Instruction::ASR : Instruction::LSR, operand1, operand2, operand3);
		break;

	case Code::Instruction::PUSH:
		if (IsComplex (operand1)) Push (operand1, High);
		Push (operand1, Low);
		break;

	case Code::Instruction::POP:
		Pop (operand1, Low);
		if (IsComplex (operand1)) Pop (operand1, High);
		break;

	case Code::Instruction::CALL:
		Emit (ICALL {Load (operand1, Low)});
		if (operand2.size) Emit (SUB {SP, -Immediate (operand2.size)});
		break;

	case Code::Instruction::RET:
		Emit (LDW {PC, {SP, false}});
		break;

	case Code::Instruction::ENTER:
		Emit (STW {{false, SP}, R11}); Emit (MOV {R11, SP});
		if (operand1.size) Emit (SUB {SP, Immediate (operand1.size)});
		break;

	case Code::Instruction::LEAVE:
		Emit (MOV {SP, R11}); Emit (LDW {R11, {SP, false}});
		break;

	case Code::Instruction::BR:
		Branch (Instruction::RJMP, operand1.offset);
		break;

	case Code::Instruction::BREQ:
		if (IsComplex (operand2)) Compare (operand2, operand3, High), Branch (Instruction::BRNE, 0);
		Compare (operand2, operand3, Low), Branch (Instruction::BREQ, operand1.offset);
		break;

	case Code::Instruction::BRNE:
		if (IsComplex (operand2)) Compare (operand2, operand3, High), Branch (Instruction::BREQ, operand1.offset);
		Compare (operand2, operand3, Low), Branch (Instruction::BRNE, operand1.offset);
		break;

	case Code::Instruction::BRLT:
		if (IsComplex (operand2)) Compare (operand2, operand3, High), Branch (IsSigned (operand2) ? Instruction::BRLT : Instruction::BRLO, operand1.offset), Branch (IsSigned (operand2) ? Instruction::BRGT : Instruction::BRHI, 0);
		Compare (operand2, operand3, Low), Branch (IsSigned (operand2) ? Instruction::BRLT : Instruction::BRLO, operand1.offset);
		break;

	case Code::Instruction::BRGE:
		if (IsComplex (operand2)) Compare (operand2, operand3, High), Branch (IsSigned (operand2) ? Instruction::BRGT : Instruction::BRHI, operand1.offset), Branch (IsSigned (operand2) ? Instruction::BRLT : Instruction::BRLO, 0);
		Compare (operand2, operand3, Low), Branch (IsSigned (operand2) ? Instruction::BRGT : Instruction::BRHI, operand1.offset);
		break;

	case Code::Instruction::JUMP:
		if (IsRegister (operand1) || IsMemory (operand1)) Load (PC, operand1, Low);
		else Emit (MOV {PC, Load (operand1, Low)});
		break;

	case Code::Instruction::TRAP:
		Emit (BREAKPOINT {});
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const Code::Operand& target, const Code::Operand& source, const Index index)
{
	if (IsRegister (target)) Load (Select (target, index), source, index);
	else Store (Load (source, index), target, index);
}

void Context::Convert (const Code::Operand& target, const Code::Operand& source, const Index index)
{
	if (target.type.size == source.type.size) return Move (target, source, index);
	const auto result = Acquire (target, index);

	if (IsSigned (source))
		if (index && !IsComplex (source)) Emit (ASR {result, IsRegister (target) ? Select (target, Low) : GetRegister (result), 31});
		else if (source.type.size >= 4) Load (result, source, index);
		else Load (result, source, index), Emit (LSL {result, Immediate (32 - source.type.size * 8)}), Emit ({IsSigned (target) ? Instruction::ASR : Instruction::LSR, result, Immediate (32 - source.type.size * 8)});
	else if (index) Emit (MOV {result, 0});
	else Load (result, source, Low); Store (result, target, index);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	const auto begin = Acquire (Low); Load (begin, target, Low);
	const auto end = Acquire (Low); Emit (ADD {end, begin, Load (size, Low)});
	const auto origin = Load (source, Low); auto loop = CreateLabel (); loop (); Emit (CPW {begin, end});
	const auto temporary = Acquire (Low); Branch (Instruction::BREQ, 0); Emit (LDUB {temporary, {GetRegister (begin), false}});
	Emit (STB {{GetRegister (origin), false}, temporary}); Branch (Instruction::RJMP, loop);
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto mnemonic = IsComplex (value) ? Instruction::STD : GetStoreMnemonic (value);
	const auto begin = Load (target, Low), end = Load (size, Low);
	Emit (ADD {end, begin, {AVR32::Shift (CountOnes (value.type.size - 1)), GetRegister (end)}});
	const auto data = Load (value, Low); auto loop = CreateLabel (); loop (); Emit (CPW {begin, end});
	Branch (Instruction::BREQ, 0); Emit ({mnemonic, {GetRegister (begin), false}, data}); Branch (Instruction::RJMP, loop);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value, const Index index)
{
	const auto result = Acquire (target, index); Load (result, value, index); Emit ({mnemonic, result}); Store (result, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto result = Acquire (target, index); Load (result, value1, index);
	if (mnemonic == Instruction::ADC || mnemonic == Instruction::SBC) Emit ({mnemonic, result, result, Load (value2, index)});
	else Emit ({mnemonic, result, Load (value2, index)}); Store (result, target, index);
}

void Context::Divide (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index, const Index result)
{
	const auto dividend = Load (value1, index), divisor = Load (value2, index);
	if (IsRegister (target) && Select (target, index) % 2 == 0 && !acquired[Select (target, index) + 1] && result == index)
		return Emit ({mnemonic, Select (target, result), dividend, divisor});
	const auto temporary = Acquire (High); Emit ({mnemonic, temporary, dividend, divisor});
	Store (Register (GetRegister (temporary) + result), target, index);
}

void Context::Shift (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto result = Acquire (target, Low);
	if (IsImmediate (value2) && Extract (value2, Low) < 32) return Load (result, value1, Low), Emit ({mnemonic, result, Extract (value2, Low)});
	const auto value = Load (value1, Low); Emit ({mnemonic, result, value, Load (value2, Low)}); Store (result, target, Low);
}

void Context::Push (const Code::Operand& value, const Index index)
{
	const auto result = Load (value, index);
	if (value.type.size >= 4) Emit (STW {{false, SP}, result});
	else Emit (SUB {SP, 4}), Emit ({GetStoreMnemonic (value), {SP, 0}, result});
}

void Context::Pop (const Code::Operand& target, const Index index)
{
	const auto result = Acquire (target, index);
	if (target.type.size >= 4) Emit (LDW {result, {SP, false}});
	else Emit ({GetLoadMnemonic (target), result, {SP, 0}}), Emit (SUB {SP, -4});
	Store (result, target, index);
}

void Context::Compare (const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto comparand = Load (value1, index);
	const auto mnemonic = GetCompareMnemonic (value1);
	if (mnemonic == Instruction::CPW && IsImmediate (value2) && Extract (value2, index) >= -1048576 && Extract (value2, index) <= 1048575)
		return Emit ({mnemonic, comparand, Extract (value2, index)});
	Emit ({mnemonic, comparand, Load (value2, index)});
}

void Context::Branch (Instruction::Mnemonic mnemonic, const Code::Offset offset)
{
	Branch (mnemonic, GetLabel (offset));
}

void Context::Branch (Instruction::Mnemonic mnemonic, const Label& label)
{
	const auto immediate = Immediate (GetBranchOffset (label, 4));
	if (immediate <= 0) return Emit ({mnemonic, immediate});
	if (mnemonic == Instruction::RJMP) mnemonic = Instruction::BRAL;
	AddFixup (label, mnemonic, 4); if (listing) listing << '\t' << mnemonic << '\t' << label << '\n';
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const auto instruction = ExtendBranch ({Instruction::Mnemonic (code), Immediate (target - bytes.begin ())});
	assert (GetSize (instruction) == bytes.size ()); instruction.Emit (bytes);
}

Context::Part Context::GetRegisterParts (const Code::Operand& operand) const
{
	return IsComplex (operand) + 1;
}

Context::Suffix Context::GetRegisterSuffix (const Code::Operand& operand, const Part part) const
{
	return IsComplex (operand) ? part == High ? 'h' : 'l' : 0;
}

std::ostream& Context::WriteRegister (std::ostream& stream, const Code::Operand& operand, const Part part)
{
	return stream << registers[part][operand.register_];
}

bool Context::IsComplex (const Code::Operand& operand)
{
	return operand.type.size == 8;
}

Instruction::Mnemonic Context::GetLoadMnemonic (const Code::Operand& operand)
{
	switch (operand.type.size)
	{
	case 1: return IsSigned (operand) ? Instruction::LDSB : Instruction::LDUB;
	case 2: return IsSigned (operand) ? Instruction::LDSH : Instruction::LDUH;
	case 4: case 8: return Instruction::LDW;
	default: assert (Code::Type::Unreachable);
	}
}

Instruction::Mnemonic Context::GetStoreMnemonic (const Code::Operand& operand)
{
	switch (operand.type.size)
	{
	case 1: return Instruction::STB;
	case 2: return Instruction::STH;
	case 4: case 8: return Instruction::STW;
	default: assert (Code::Type::Unreachable);
	}
}

Instruction::Mnemonic Context::GetCompareMnemonic (const Code::Operand& operand)
{
	switch (operand.type.size)
	{
	case 1: return Instruction::CPB;
	case 2: return Instruction::CPH;
	case 4: case 8: return Instruction::CPW;
	default: assert (Code::Type::Unreachable);
	}
}

SmartOperand::SmartOperand (Context& c, const AVR32::Register register_) :
	Operand {register_}, context {&c}
{
	context->Acquire (register_);
}

SmartOperand::SmartOperand (SmartOperand&& operand) noexcept :
	Operand {std::move (operand)}, context {operand.context}
{
	operand.context = nullptr;
}

SmartOperand::~SmartOperand ()
{
	if (context) context->Release (GetRegister (*this));
}

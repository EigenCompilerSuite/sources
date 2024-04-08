// ARM A32 machine code generator
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

#include "arma32.hpp"
#include "arma32generator.hpp"
#include "armgeneratorcontext.hpp"

using namespace ECS;
using namespace ARM;
using namespace A32;

using Context = class A32::Generator::Context : public ARM::Generator::Context
{
public:
	using ARM::Generator::Context::Context;

private:
	class SmartOperand;

	using ARM::Generator::Context::Acquire;
	using ARM::Generator::Context::Release;

	SmartOperand Acquire (const Code::Type&, Index);
	SmartOperand Load (const Code::Operand&, Index);
	SmartOperand Acquire (const Code::Operand&, Index);
	SmartOperand Evaluate (const Code::Operand&, Index);

	void Load (const Operand&, const Code::Operand&, Index);
	void Store (const Operand&, const Code::Operand&, Index);
	void Access (Instruction::Mnemonic, const Operand&, const Code::Operand&, Index);

	Instruction::Mnemonic GetLoadMnemonic (const Code::Type&) const;
	Instruction::Mnemonic GetStoreMnemonic (const Code::Type&) const;

	void Emit (const Instruction&);
	void EmitMove (Register, Register);
	void Emit (Instruction::Mnemonic, const Code::Operand&);

	void Extend (const Operand&, const Code::Type&);
	void Load (const Operand&, const Code::Operand&);
	void Load (const Operand&, Immediate, const Code::Type&);
	void AddDisplacement (const Operand&, const Operand&, Code::Displacement);

	void PopFloat (const Code::Operand&);
	void PushFloat (const Code::Operand&);
	void Pop (const Code::Operand&, Index);
	void Push (const Code::Operand&, Index);
	void Branch (ConditionCode, Code::Offset);
	void Branch (ConditionCode, const Label&);
	void Branch (Instruction::Mnemonic, const Code::Operand&);
	void Convert (const Code::Operand&, const Code::Operand&);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void CompareFloat (const Code::Operand&, const Code::Operand&);
	void Compare (const Code::Operand&, const Code::Operand&, Index);
	void ConvertToFloat (const Code::Operand&, const Code::Operand&);
	void ConvertFromFloat (const Code::Operand&, const Code::Operand&);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void FillFloat (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Divide (const Code::Operand&, const Code::Operand&, const Code::Operand&, bool);
	void MultiplyComplex (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Shift (ShiftMode, const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, Index);
	void OperationFloat (Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void OperationFloat (Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);

	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (SmartOperand&&) noexcept;
	SmartOperand (Context&, ARM::Register, const Code::Type&);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

A32::Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c, const FloatingPointExtension fpe) :
	ARM::Generator {d, sp, assembler, "arma32", "ARM A32", fpe}, assembler {d, c}
{
}

void A32::Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

SmartOperand Context::Acquire (const Code::Type& type, const Index index)
{
	return {*this, GetFree (index), type};
}

SmartOperand Context::Load (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index);
	auto result = Acquire (operand.type, index); Load (result, operand, index); return result;
}

SmartOperand Context::Acquire (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index); return Acquire (operand.type, index);
}

SmartOperand Context::Evaluate (const Code::Operand& operand, const Index index)
{
	if (IsImmediate (operand) && GetRotation (Extract (operand, index)) != 16 && (!IsNegative (operand) || GetSize (operand) >= 4)) return Extract (operand, index); return Load (operand, index);
}

void Context::Load (const Operand& register_, const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		if (IsFloat (operand) && floatingPointExtension) Load (register_, operand);
		else Load (register_, Extract (operand, index), operand.type);
		break;

	case Code::Operand::Address:
		if (operand.register_ == Code::RVoid) Load (register_, Code::Adr {generator.platform.pointer, operand.address});
		else if (registers[Low][operand.register_] == GetRegister (register_)) Emit (ADD {register_, register_, Load (Code::Adr {generator.platform.pointer, operand.address}, Low)});
		else Load (register_, Code::Adr {generator.platform.pointer, operand.address}), Emit (ADD {register_, register_, registers[Low][operand.register_]});
		if (operand.displacement) AddDisplacement (register_, register_, operand.displacement);
		break;

	case Code::Operand::Register:
		EmitMove (GetRegister (register_), Translate (registers[index][operand.register_], operand.type));
		if (operand.displacement) AddDisplacement (register_, register_, operand.displacement);
		break;

	case Code::Operand::Memory:
		Access (GetLoadMnemonic (operand.type), register_, operand, index);
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
		EmitMove (Translate (registers[index][operand.register_], operand.type), GetRegister (register_));
		break;

	case Code::Operand::Memory:
		Access (GetStoreMnemonic (operand.type), register_, operand, index);
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Access (const Instruction::Mnemonic mnemonic, const Operand& register_, const Code::Operand& operand, const Index index)
{
	assert (IsMemory (operand));
	const auto displacement = (!operand.address.empty () || operand.register_ != Code::RVoid ? operand.displacement : 0) + (index * 4 % 8);

	const auto isValidDisplacement = displacement > -256 && displacement < 256 ||
		(mnemonic == Instruction::LDR || mnemonic == Instruction::LDRB || mnemonic == Instruction::STR || mnemonic == Instruction::STRB) && displacement > -4096 && displacement < 4096;

	if (operand.address.empty () && operand.register_ != Code::RVoid && isValidDisplacement)
		return Emit ({mnemonic, register_, '[', registers[Low][operand.register_], Immediate (displacement), ']'});

	const auto address = Acquire (generator.platform.pointer, Low);

	if (operand.address.empty ()) if (operand.register_ != Code::RVoid) AddDisplacement (address, registers[Low][operand.register_], displacement); else Load (address, Immediate (operand.ptrimm), generator.platform.pointer);
	else if (Load (address, Code::Adr {generator.platform.pointer, operand.address}), !isValidDisplacement) AddDisplacement (address, address, displacement);

	if (operand.register_ != Code::RVoid && !displacement)
		if (mnemonic == Instruction::FLDS || mnemonic == Instruction::FLDD || mnemonic == Instruction::FSTS || mnemonic == Instruction::FSTD) Emit (ADD {address, address, registers[Low][operand.register_]});
		else return Emit ({mnemonic, register_, '[', address, registers[Low][operand.register_], ']'});
	Emit ({mnemonic, register_, '[', address, Immediate (isValidDisplacement ? displacement : 0), ']'});
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction));
	instruction.Emit (Reserve (4));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Code::Operand& operand)
{
	const Instruction instruction {mnemonic, Immediate (0), {}}; assert (IsValid (instruction));
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (operand.displacement), 0};
	instruction.Adjust (patch); AddLink (operand.address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t', nullptr, operand.address, operand.displacement, 0) << '\n';
}

void Context::EmitMove (const Register target, const Register source)
{
	if (target != source) Emit ({target >= S0 ? Instruction::FMOVS : target >= D0 ? Instruction::FMOVD : Instruction::MOV, target, source});
}

void Context::Extend (const Operand& register_, const Code::Type& type)
{
	if (type.size == 1) Emit ({type.model == Code::Type::Signed ? Instruction::SXTB : Instruction::UXTB, register_, register_});
	else if (type.size == 2) Emit ({type.model == Code::Type::Signed ? Instruction::SXTH : Instruction::UXTH, register_, register_});
}

void Context::Load (const Operand& register_, const Immediate immediate, const Code::Type& type)
{
	if (GetRotation (immediate) != 16) Emit (MOV {register_, immediate});
	else if (GetRotation (-immediate) != 16) Emit (MOV {register_, -immediate}), Emit (RSB {register_, register_, Immediate (0)});
	else return Load (register_, Code::Imm (type.size == 8 ? Code::Unsigned {4} : type, immediate));
	if (type.model == Code::Type::Signed && !TruncatesPreserving (immediate, type.size * 8)) Extend (register_, type);
}

void Context::Load (const Operand& register_, const Code::Operand& operand)
{
	const auto mnemonic = GetLoadMnemonic (operand.type);
	const auto offset = mnemonic == Instruction::LDR || mnemonic == Instruction::LDRB ? 4096 - 52 : mnemonic == Instruction::FLDD || mnemonic == Instruction::FLDS ? 1024 - 52 : 256 - 52;
	const auto label = DefineLocal (operand, offset, offset); AddFixup (label, mnemonic << 6 | GetRegister (register_), 4);
	if (listing) listing << '\t' << mnemonic << '\t' << register_ << ", [" << PC << ", " << Assembly::Lexer::Offset << " (" << label << ")]\n";
}

void Context::AddDisplacement (const Operand& address, const Operand& base, const Code::Displacement displacement)
{
	if (GetRotation (Immediate (displacement)) != 16) Emit (ADD {address, base, Immediate (displacement)});
	else if (GetRotation (Immediate (-displacement)) != 16) Emit (SUB {address, base, Immediate (-displacement)});
	else Emit (ADD {address, base, Load (Code::PtrImm (generator.platform.pointer, displacement), Low)});
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
		if (IsFloat (operand1) && floatingPointExtension) Move (operand1, operand2, Float);
		else if (IsComplex (operand1)) Move (operand1, operand2, Low), Move (operand1, operand2, High);
		else Move (operand1, operand2, Low);
		break;

	case Code::Instruction::CONV:
		if (IsFloat (operand1)) ConvertToFloat (operand1, operand2);
		else if (IsFloat (operand2)) ConvertFromFloat (operand1, operand2);
		else Convert (operand1, operand2);
		break;

	case Code::Instruction::COPY:
		Copy (operand1, operand2, operand3);
		break;

	case Code::Instruction::FILL:
		if (IsFloat (operand3) && floatingPointExtension) FillFloat (operand1, operand2, operand3);
		else Fill (operand1, operand2, operand3);
		break;

	case Code::Instruction::NEG:
		if (IsFloat (operand1)) OperationFloat (Instruction::FNEGS, Instruction::FNEGD, operand1, operand2);
		else if (IsComplex (operand1)) Operation (Instruction::RSBS, operand1, operand2, Code::Imm (operand1.type, 0), Low), Operation (Instruction::RSC, operand1, operand2, Code::Imm (operand1.type, 0), High);
		else Operation (Instruction::RSB, operand1, operand2, Code::Imm (operand1.type, 0), Low);
		break;

	case Code::Instruction::ADD:
		if (IsFloat (operand1)) OperationFloat (Instruction::FADDS, Instruction::FADDD, operand1, operand2, operand3);
		else if (IsComplex (operand1)) Operation (Instruction::ADDS, operand1, operand2, operand3, Low), Operation (Instruction::ADC, operand1, operand2, operand3, High);
		else Operation (Instruction::ADD, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::SUB:
		if (IsFloat (operand1)) OperationFloat (Instruction::FSUBS, Instruction::FSUBD, operand1, operand2, operand3);
		else if (IsComplex (operand1)) Operation (Instruction::SUBS, operand1, operand2, operand3, Low), Operation (Instruction::SBC, operand1, operand2, operand3, High);
		else Operation (Instruction::SUB, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MUL:
		if (IsFloat (operand1)) OperationFloat (Instruction::FMULS, Instruction::FMULD, operand1, operand2, operand3);
		else if (IsComplex (operand1)) MultiplyComplex (operand1, operand2, operand3);
		else if (IsImmediate (operand3) && IsPowerOfTwo (Extract (operand3, Low)))
			Shift (LSL, operand1, operand2, Code::Imm (operand3.type, CountOnes (Extract (operand3, Low) - 1)));
		else if (IsImmediate (operand2) && IsPowerOfTwo (Extract (operand2, Low)))
			Shift (LSL, operand1, operand3, Code::Imm (operand2.type, CountOnes (Extract (operand2, Low) - 1)));
		else Operation (Instruction::MUL, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::DIV:
		if (IsFloat (operand1)) OperationFloat (Instruction::FDIVS, Instruction::FDIVD, operand1, operand2, operand3);
		else if (IsImmediate (operand3) && IsPowerOfTwo (Extract (operand3, Low)))
			Shift (IsSigned (operand1) ? ASR : LSR, operand1, operand2, Code::Imm (operand3.type, CountOnes (Extract (operand3, Low) - 1)));
		else Divide (operand1, operand2, operand3, false);
		break;

	case Code::Instruction::MOD:
		if (IsImmediate (operand3) && IsPowerOfTwo (Extract (operand3, Low)))
			Operation (Instruction::AND, operand1, operand2, Code::Imm (operand3.type, Extract (operand3, Low) - 1), Low);
		else Divide (operand1, operand2, operand3, true);
		break;

	case Code::Instruction::NOT:
		Operation (Instruction::MVN, operand1, operand2, Low);
		if (IsComplex (operand1)) Operation (Instruction::MVN, operand1, operand2, High);
		break;

	case Code::Instruction::AND:
		Operation (Instruction::AND, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::AND, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::OR:
		Operation (Instruction::ORR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::ORR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::XOR:
		Operation (Instruction::EOR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::EOR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::LSH:
		Shift (LSL, operand1, operand2, operand3);
		break;

	case Code::Instruction::RSH:
		Shift (IsSigned (operand1) ? ASR : LSR, operand1, operand2, operand3);
		break;

	case Code::Instruction::PUSH:
		if (IsFloat (operand1) && floatingPointExtension) PushFloat (operand1);
		else if (IsComplex (operand1)) Push (operand1, High), Push (operand1, Low);
		else Push (operand1, Low);
		break;

	case Code::Instruction::POP:
		if (IsFloat (operand1) && floatingPointExtension) PopFloat (operand1);
		else if (IsComplex (operand1)) Pop (operand1, Low), Pop (operand1, High);
		else Pop (operand1, Low);
		break;

	case Code::Instruction::CALL:
		if (IsAddress (operand1)) Emit (Instruction::BL, operand1); else Branch (Instruction::BLX, operand1);
		if (operand2.size) Emit (ADD {SP, SP, Evaluate (Code::PtrImm (generator.platform.pointer, operand2.size), Low)});
		break;

	case Code::Instruction::RET:
		Emit (LDMIA {SP, '!', RegisterList {PC}});
		break;

	case Code::Instruction::ENTER:
		Emit (STMDB {SP, '!', RegisterList {R11}}); Emit (MOV {R11, SP});
		if (operand1.size) Emit (SUB {SP, SP, Evaluate (Code::PtrImm (generator.platform.pointer, operand1.size), Low)});
		break;

	case Code::Instruction::LEAVE:
		Emit (MOV {SP, R11}); Emit (LDMIA {SP, '!', RegisterList {R11}});
		break;

	case Code::Instruction::BR:
		Branch (AL, operand1.offset);
		break;

	case Code::Instruction::BREQ:
		if (IsFloat (operand2)) CompareFloat (operand2, operand3);
		else if (IsComplex (operand2)) Compare (operand2, operand3, High), Branch (NE, 0), Compare (operand2, operand3, Low);
		else Compare (operand2, operand3, Low); Branch (EQ, operand1.offset);
		break;

	case Code::Instruction::BRNE:
		if (IsFloat (operand2)) CompareFloat (operand2, operand3);
		else if (IsComplex (operand2)) Compare (operand2, operand3, High), Branch (NE, operand1.offset), Compare (operand2, operand3, Low);
		else Compare (operand2, operand3, Low); Branch (NE, operand1.offset);
		break;

	case Code::Instruction::BRLT:
		if (IsFloat (operand2)) CompareFloat (operand2, operand3);
		else if (IsComplex (operand2)) Compare (operand2, operand3, High), Branch (IsSigned (operand2) ? LT : LO, operand1.offset), Branch (IsSigned (operand2) ? GT : HI, 0), Compare (operand2, operand3, Low);
		else Compare (operand2, operand3, Low); Branch (IsFloat (operand2) || IsSigned (operand2) && !IsComplex (operand2) ? LT : LO, operand1.offset);
		break;

	case Code::Instruction::BRGE:
		if (IsFloat (operand2)) CompareFloat (operand2, operand3);
		else if (IsComplex (operand2)) Compare (operand2, operand3, High), Branch (IsSigned (operand2) ? GT : HI, operand1.offset), Branch (IsSigned (operand2) ? LT : LO, 0), Compare (operand2, operand3, Low);
		else Compare (operand2, operand3, Low); Branch (IsFloat (operand2) || IsSigned (operand2) && !IsComplex (operand2) ? GE : HS, operand1.offset);
		break;

	case Code::Instruction::JUMP:
		if (IsAddress (operand1)) Emit (Instruction::B, operand1); else Branch (Instruction::BX, operand1);
		break;

	case Code::Instruction::TRAP:
		Emit (HLT {Immediate (operand1.size & 65535)});
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

void Context::Convert (const Code::Operand& target, const Code::Operand& source)
{
	const auto result = Load (source, Low); Extend (result, target.type); Store (result, target, Low);
	if (!IsComplex (target)) return; if (IsComplex (source)) return Move (target, source, High);
	const auto high = Acquire (target, High); if (IsSigned (source)) Emit (MOV {high, result, ASR, Immediate (31)}); else Emit (MOV {high, Immediate (0)}); Store (high, target, High);
}

void Context::ConvertToFloat (const Code::Operand& target, const Code::Operand& source)
{
	if (target.type == source.type) return Move (target, source, Float); const auto result = Acquire (target, Float);
	const auto single = IsComplex (target) ? Translate (GetRegister (result), Code::Float {4}) : GetRegister (result);
	if (IsFloat (source)) Emit ({IsComplex (target) ? Instruction::FCVTDS : Instruction::FCVTSD, result, Load (source, Float)});
	else Emit (FMSR {single, Load (source, Low)}), Emit ({IsComplex (target) ? IsSigned (source) ? Instruction::FSITOD : Instruction::FUITOD : IsSigned (source) ? Instruction::FSITOS : Instruction::FUITOS, result, single});
	Store (result, target, Float);
}

void Context::ConvertFromFloat (const Code::Operand& target, const Code::Operand& source)
{
	const auto single = Acquire (Code::Float {4}, Float), result = Acquire (target, Low);
	Emit ({IsComplex (source) ? Instruction::FTOSIZD : Instruction::FTOSIZS, single, Load (source, Float)});
	Emit (FMRS {result, single}); Extend (result, target.type); Store (result, target, Low); if (!IsComplex (target)) return;
	const auto high = Acquire (target, High); Emit (MOV {high, result, ASR, Immediate (31)}); Store (high, target, High);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	const auto targetAddress = Acquire (generator.platform.pointer, Low); Load (targetAddress, target, Low);
	const auto sourceAddress = Acquire (generator.platform.pointer, Low); Load (sourceAddress, source, Low);
	const auto count = Acquire (generator.platform.pointer, Low); Load (count, size, Low);
	if (!IsImmediate (size)) Emit (CMP {count, Immediate (0)}), Branch (EQ, 0);
	auto begin = CreateLabel (); begin (); const auto value = Acquire (generator.platform.integer, Low);
	const Immediate increment = IsImmediate (size) ? Extract (size, Low) % 4 == 0 ? 4 : Extract (size, Low) % 2 == 0 ? 2 : 1 : 1;
	Emit ({GetLoadMnemonic (Code::Unsigned (increment)), value, '[', sourceAddress, ']', increment});
	Emit ({GetStoreMnemonic (Code::Unsigned (increment)), value, '[', targetAddress, ']', increment});
	Emit (SUBS {count, count, increment}); Branch (NE, begin);
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto count = Acquire (generator.platform.pointer, Low); Load (count, size, Low);
	if (!IsImmediate (size)) Emit (CMP {count, Immediate (0)}), Branch (EQ, 0);
	const auto targetAddress = Acquire (generator.platform.pointer, Low); Load (targetAddress, target, Low);
	const auto low = Load (value, Low), high = IsComplex (value) ? Load (value, High) : R0; auto begin = CreateLabel (); begin ();
	Emit ({GetStoreMnemonic (value.type), low, '[', targetAddress, ']', Immediate (GetSize (value))});
	if (IsComplex (value)) Emit (STR {high, '[', targetAddress, Immediate (-4), ']'});
	Emit (SUBS {count, count, Immediate (1)}); Branch (NE, begin);
}

void Context::FillFloat (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto count = Acquire (generator.platform.pointer, Low); Load (count, size, Low);
	if (!IsImmediate (size)) Emit (CMP {count, Immediate (0)}), Branch (EQ, 0);
	const auto targetAddress = Acquire (generator.platform.pointer, Low); Load (targetAddress, target, Low);
	const auto result = Load (value, Float); auto begin = CreateLabel (); begin ();
	Emit ({GetStoreMnemonic (value.type), result, '[', targetAddress, ']'});
	Emit (ADD {targetAddress, targetAddress, Immediate (GetSize (value))});
	Emit (SUBS {count, count, Immediate (1)}); Branch (NE, begin);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value, const Index index)
{
	const auto result = Acquire (target, index); Emit ({mnemonic, result, Evaluate (value, index)}); Store (result, target, index);
}

void Context::OperationFloat (const Instruction::Mnemonic singleMnemonic, const Instruction::Mnemonic doubleMnemonic, const Code::Operand& target, const Code::Operand& value)
{
	const auto result = Acquire (target, Float); Emit ({IsComplex (target) ? doubleMnemonic : singleMnemonic, result, Load (value, Float)}); Store (result, target, Float);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	if (IsImmediate (value1) && !IsImmediate (value2) && GetRotation (Extract (value1, index)) != 16)
		return Operation (mnemonic == Instruction::SUB ? Instruction::RSB : mnemonic == Instruction::SUBS ? Instruction::RSBS : mnemonic == Instruction::SBC ? Instruction::RSC : mnemonic, target, value2, value1, index);
	if (mnemonic == Instruction::AND && IsImmediate (value2) && GetRotation (~Extract (value2, index)) != 16)
		return Operation (Instruction::BIC, target, value1, Code::Imm (value2.type, ~Extract (value2, index)), index);
	const auto value = mnemonic != Instruction::MUL ? Evaluate (value2, index) : Load (value2, index);
	const auto result = Acquire (target, index); Emit ({mnemonic, result, Load (value1, index), value}); Store (result, target, index);
}

void Context::OperationFloat (const Instruction::Mnemonic singleMnemonic, const Instruction::Mnemonic doubleMnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto value = Load (value2, Float), result = Acquire (target, Float);
	Emit ({IsComplex (target) ? doubleMnemonic : singleMnemonic, result, Load (value1, Float), value});
	Store (result, target, Float);
}

void Context::MultiplyComplex (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto value1Low = Load (value1, Low), value1High = Load (value1, High);
	const auto value2Low = Load (value2, Low), value2High = Load (value2, High);
	const auto resultLow = Acquire (target, Low), resultHigh = Acquire (target, High);
	Emit (UMULL {resultLow, resultHigh, value1Low, value2Low});
	Emit ({Instruction::MLA, resultHigh, value1Low, value2High, resultHigh});
	Emit ({Instruction::MLA, resultHigh, value1High, value2Low, resultHigh});
	Store (resultLow, target, Low); Store (resultHigh, target, High);
}

void Context::Divide (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const bool modulo)
{
	const auto value1Low = Load (value1, Low), double1 = Acquire (generator.platform.float_, Float), value2Low = Load (value2, Low), double2 = Acquire (generator.platform.float_, Float);
	const auto value1Float = Translate (GetRegister (double1), Code::Float {4}), value2Float = Translate (GetRegister (double2), Code::Float {4});
	Emit (FMSR {value1Float, value1Low}); Emit (FMSR {value2Float, value2Low});
	if (IsSigned (target)) Emit (FSITOD {double1, value1Float}), Emit (FSITOD {double2, value2Float});
	else Emit (FUITOD {double1, value1Float}), Emit (FUITOD {double2, value2Float}); Emit (FDIVD {double1, double1, double2});
	if (IsSigned (target)) Emit (FTOSIZD {value1Float, double1}); else Emit (FTOUIZD {value1Float, double1});
	const auto result = Acquire (target, Low); if (!modulo) Emit (FMRS {result, value1Float});
	else {const auto multiple = Acquire (target.type, Low); Emit (FMRS {multiple, value1Float}); Emit (MUL {multiple, multiple, value2Low}); Emit (SUB {result, value1Low, multiple});}
	Store (result, target, Low);
}

void Context::Shift (const ShiftMode shiftMode, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto value = IsImmediate (value2) && Extract (value2, Low) < 32 ? Extract (value2, Low) : Load (value2, Low);
	const auto result = Acquire (target, Low); Emit (MOV {result, Load (value1, Low), shiftMode, value}); Store (result, target, Low);
}

void Context::Push (const Code::Operand& value, const Index index)
{
	Emit (STMDB {SP, '!', RegisterList {GetRegister (Load (value, index))}});
}

void Context::PushFloat (const Code::Operand& value)
{
	const auto result = Load (value, Float);
	if (IsComplex (value)) Emit (FSTMDBD {SP, '!', DoubleRegisterList {GetRegister (result)}}); else Emit (FSTMDBS {SP, '!', SingleRegisterList {GetRegister (result)}});
}

void Context::Pop (const Code::Operand& target, const Index index)
{
	const auto result = Acquire (target, index); Emit (LDMIA {SP, '!', RegisterList {GetRegister (result)}}); Store (result, target, index);
}

void Context::PopFloat (const Code::Operand& target)
{
	const auto result = Acquire (target, Float);
	if (IsComplex (target)) Emit (FLDMIAD {SP, '!', DoubleRegisterList {GetRegister (result)}}); else Emit (FLDMIAS {SP, '!', SingleRegisterList {GetRegister (result)}});
	Store (result, target, Float);
}

void Context::Compare (const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto left = Load (value1, index), right = Evaluate (value2, index);
	if (IsRegister (value1)) Extend (left, value1.type); if (IsRegister (value2)) Extend (right, value2.type); Emit (CMP {left, right});
}

void Context::CompareFloat (const Code::Operand& value1, const Code::Operand& value2)
{
	const auto left = Load (value1, Float); Emit ({IsComplex (value1) ? Instruction::FCMPD : Instruction::FCMPS, left, Load (value2, Float)}); Emit (FMSTAT {});
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Code::Operand& target)
{
	const auto address = Load (target, Low); Emit ({mnemonic, address});
}

void Context::Branch (const ConditionCode code, const Code::Offset offset)
{
	Branch (code, GetLabel (offset));
}

void Context::Branch (const ConditionCode code, const Label& label)
{
	AddFixup (label, Instruction::B << 6 | code, 4);
	if (listing) listing << '\t' << Instruction::B << code << '\t' << label << '\n';
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const auto offset = Immediate (target - bytes.begin () - 8); const auto mnemonic = Instruction::Mnemonic (code >> 6);
	if (mnemonic == Instruction::B) Instruction {mnemonic, ConditionCode (code & 0x3f), offset}.Emit (bytes);
	else Instruction {mnemonic, Register (code & 0x3f), '[', PC, offset, ']'}.Emit (bytes);
}

A32::Instruction::Mnemonic Context::GetLoadMnemonic (const Code::Type& type) const
{
	switch (type.size)
	{
	case 1: return type.model == Code::Type::Signed ? Instruction::LDRSB : Instruction::LDRB;
	case 2: return type.model == Code::Type::Signed ? Instruction::LDRSH : Instruction::LDRH;
	case 4: return floatingPointExtension && type.model == Code::Type::Float ? Instruction::FLDS : Instruction::LDR;
	case 8: return floatingPointExtension && type.model == Code::Type::Float ? Instruction::FLDD : Instruction::LDR;
	default: assert (Code::Type::Unreachable);
	}
}

A32::Instruction::Mnemonic Context::GetStoreMnemonic (const Code::Type& type) const
{
	switch (type.size)
	{
	case 1: return Instruction::STRB;
	case 2: return Instruction::STRH;
	case 4: return floatingPointExtension && type.model == Code::Type::Float ? Instruction::FSTS : Instruction::STR;
	case 8: return floatingPointExtension && type.model == Code::Type::Float ? Instruction::FSTD : Instruction::STR;
	default: assert (Code::Type::Unreachable);
	}
}

SmartOperand::SmartOperand (Context& c, const ARM::Register register_, const Code::Type& type) :
	Operand {c.Translate (register_, type)}, context {&c}
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
	if (context) context->Release (TranslateBack (GetRegister (*this)));
}

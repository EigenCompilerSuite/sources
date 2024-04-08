// MIPS machine code generator
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
#include "mips.hpp"
#include "mipsgenerator.hpp"

using namespace ECS;
using namespace MIPS;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const MIPS::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	enum Index {Low, High, Float};

	class SmartOperand;

	const Architecture architecture;
	const FloatSupport floatSupport;
	const FullAddressSpace fullAddressSpace;

	bool acquired[64] {};
	Register registers[3][Code::Registers];

	void Acquire (Register);
	void Release (Register);

	Register GetFree (Index) const;
	Register Select (const Code::Operand&, Index) const;
	Immediate Extract (const Code::Operand&, Index) const;

	SmartOperand Acquire (Index);
	SmartOperand Load (const Code::Operand&, Index);
	SmartOperand Acquire (const Code::Operand&, Index);

	void Truncate (const Operand&, const Code::Type&);
	void Load (const Operand&, const Code::Operand&, Index);
	void Store (const Operand&, const Code::Operand&, Index);
	void Access (Instruction::Mnemonic, const Operand&, const Code::Operand&, Index);

	void Emit (const Instruction&);
	bool IsComplex (const Code::Operand&) const;

	void Load (const Operand&, const Code::Section::Name&, Code::Displacement);
	void Load (Instruction::Mnemonic, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);

	void Jump (Instruction::Mnemonic, const Code::Operand&);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void Pop (Instruction::Mnemonic, const Code::Operand&, Index);
	void Push (Instruction::Mnemonic, const Code::Operand&, Index);
	void Branch (Instruction::Mnemonic, const Label&, Register, Register);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, Index);
	void Branch (Instruction::Mnemonic, const Label&, const Code::Operand&, const Code::Operand&, Index);
	void CompareAndBranch (Instruction::Mnemonic, Code::Offset, const Code::Operand&, const Code::Operand&);
	void CompareAndBranch (Instruction::Mnemonic, Instruction::Mnemonic, Code::Offset, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void SpecialOperation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Instruction::Mnemonic);
	void ShiftOperation (Instruction::Mnemonic, Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static bool IsDoublePrecision (const Code::Operand&);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (SmartOperand&&) noexcept;
	SmartOperand (Context&, MIPS::Register);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c, const Architecture a, const Endianness e, const FloatSupport fs, const FullAddressSpace fas) :
	Assembly::Generator {d, sp, assembler, "mips", "MIPS", {{4, 1, 8}, {fs ? 8u : 4u, 4, 8}, fas ? 8u : 4u, fas ? 8u : 4u, {0, fas ? 8u : 4u, 8}, true}, true},
	assembler {d, c, a, e}, architecture {a}, floatSupport {fs}, fullAddressSpace {fas}
{
	assert (fullAddressSpace || a != MIPS64);
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const MIPS::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}, architecture {g.architecture}, floatSupport {g.floatSupport}, fullAddressSpace {g.fullAddressSpace}
{
	for (auto& set: registers) for (auto& register_: set) register_ = R0;
	Acquire (registers[Low][Code::RSP] = R29); Acquire (registers[Low][Code::RFP] = R30); Acquire (registers[Low][Code::RLink] = R31);
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
	auto register_ = (index == Float ? F2 : R4); while (register_ % 32 && acquired[register_]) register_ = Register (register_ + (index == Float) + 1);
	if (register_ % 32 == 0) throw RegisterShortage {}; return register_;
}

Register Context::Select (const Code::Operand& operand, const Index index) const
{
	assert (IsRegister (operand)); return registers[index][operand.register_];
}

Immediate Context::Extract (const Code::Operand& operand, const Index index) const
{
	assert (IsImmediate (operand)); return IsSigned (operand) ? Immediate (operand.simm >> index * 32 % 64) : Immediate (Code::Convert (operand) >> index * 32 % 64);
}

SmartOperand Context::Acquire (const Index index)
{
	return {*this, GetFree (index)};
}

SmartOperand Context::Load (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index);
	if (IsImmediate (operand) && index != Float && !Extract (operand, index)) return R0;
	auto result = Acquire (index); Load (result, operand, index); return result;
}

SmartOperand Context::Acquire (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index); return Acquire (index);
}

void Context::Truncate (const Operand& register_, const Code::Type& type)
{
	if (type.model == Code::Type::Signed) return;
	if (type.size == 1) Emit ({Instruction::ANDI, register_, register_, 0xff});
	else if (type.size == 2) Emit ({Instruction::ANDI, register_, register_, 0xffff});
}

void Context::Load (const Operand& register_, const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
	{
		const auto temporary = Acquire (Low);
		if (IsFloat (operand) && floatSupport && index == Float)
			Load (temporary, DefineGlobal (operand), 0),
			Emit ({IsDoublePrecision (operand) ? Instruction::LDC1 : Instruction::LWC1, register_, 0, temporary});
		else if (IsValid (Extract (operand, index)))
			Emit ({IsDoublePrecision (operand) && architecture == MIPS64 ? Instruction::DADDIU : Instruction::ADDIU, register_, R0, Extract (operand, index)});
		else if (IsDoublePrecision (operand) && architecture == MIPS64)
			Load (temporary, DefineGlobal (operand), 0), Emit (LD {register_, 0, temporary});
		else Emit (LUI {register_, Extract (operand, index) >> 16}), Emit (ORI {register_, register_, Extract (operand, index) & 0xffff});
		break;
	}

	case Code::Operand::Address:
		if (operand.register_ == Code::RVoid) Load (register_, operand.address, operand.displacement);
		else if (registers[Low][operand.register_] == GetRegister (register_)) Emit (ADDU {register_, register_, Load (Code::Adr {generator.platform.pointer, operand.address, operand.displacement}, Low)});
		else Load (register_, operand.address, operand.displacement), Emit (ADDU {register_, register_, registers[Low][operand.register_]});
		break;

	case Code::Operand::Register:
		if (GetRegister (register_) != registers[index][operand.register_] || operand.displacement)
			if (IsFloat (operand) && floatSupport) Emit ({IsDoublePrecision (operand) ? Instruction::MOVD : Instruction::MOVS, register_, registers[index][operand.register_]});
			else Emit ({IsDoublePrecision (operand) && architecture == MIPS64 ? Instruction::DADDIU : Instruction::ADDIU, register_, registers[index][operand.register_], Immediate (operand.displacement)});
		break;

	case Code::Operand::Memory:
		if (IsFloat (operand) && floatSupport)
			return Access (IsDoublePrecision (operand) ? Instruction::LDC1 : Instruction::LWC1, register_, operand, index);

		switch (operand.type.size)
		{
		case 1: Access (IsSigned (operand) ? Instruction::LB : Instruction::LBU, register_, operand, index); break;
		case 2: Access (IsSigned (operand) ? Instruction::LH : Instruction::LHU, register_, operand, index); break;
		case 4: Access (IsSigned (operand) || architecture != MIPS64 ? Instruction::LW : Instruction::LWU, register_, operand, index); break;
		case 8: Access (architecture == MIPS64 ? Instruction::LD : Instruction::LW, register_, operand, index); break;
		default: assert (Code::Type::Unreachable);
		}
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
			if (IsFloat (operand) && floatSupport) Emit ({IsDoublePrecision (operand) ? Instruction::MOVD : Instruction::MOVS, registers[index][operand.register_], register_});
			else Emit ({IsDoublePrecision (operand) && architecture == MIPS64 ? Instruction::DADDU : Instruction::ADDU, registers[index][operand.register_], register_, R0});
		break;

	case Code::Operand::Memory:
		if (IsFloat (operand) && floatSupport)
			return Access (IsDoublePrecision (operand) ? Instruction::SDC1 : Instruction::SWC1, register_, operand, index);

		switch (operand.type.size)
		{
		case 1: Access (Instruction::SB, register_, operand, index); break;
		case 2: Access (Instruction::SH, register_, operand, index); break;
		case 4: Access (Instruction::SW, register_, operand, index); break;
		case 8: Access (architecture == MIPS64 ? Instruction::SD : Instruction::SW, register_, operand, index); break;
		default: assert (Code::Type::Unreachable);
		}
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Access (const Instruction::Mnemonic mnemonic, const Operand& register_, const Code::Operand& operand, const Index index)
{
	assert (IsMemory (operand));
	if (operand.address.empty ())
		if (operand.register_ != Code::RVoid) return Emit ({mnemonic, register_, Immediate (operand.displacement + index * 4 % 8), registers[Low][operand.register_]});
		else if (IsValid (Immediate (operand.ptrimm + index * 4 % 8))) return Emit ({mnemonic, register_, Immediate (operand.ptrimm + index * 4 % 8), R0});
	const auto base = Acquire (Low);
	if (!operand.address.empty ()) Load (base, operand.address, operand.displacement + index * 4 % 8);
	else Emit (LUI {base, Immediate (operand.ptrimm + index * 4 % 8) >> 16}), Emit (ORI {base, base, Immediate (operand.ptrimm + index * 4 % 8) & 0xffff});
	if (operand.register_ != Code::RVoid) Emit (ADDU {base, base, registers[index][operand.register_]});
	Emit ({mnemonic, register_, 0, base});
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction, architecture));
	instruction.Emit (Reserve (4), endianness);
	if (listing) listing << '\t' << instruction << '\n';
}

bool Context::IsComplex (const Code::Operand& operand) const
{
	assert (!IsFloat (operand)); return IsDoublePrecision (operand) && architecture != MIPS64;
}

void Context::Load (const Instruction::Mnemonic mnemonic, const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, register_, mnemonic == Instruction::LUI ? Operand {0} : register_, mnemonic != Instruction::LUI ? Operand {0} : Operand {}};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch, endianness); AddLink (address, patch); instruction.Emit (Reserve (4), endianness);
	if (!listing) return; listing << '\t' << mnemonic << '\t' << register_ << ", ";
	if (mnemonic != Instruction::LUI) listing << register_ << ", ";
	WriteAddress (listing, nullptr, address, displacement, scale) << '\n';
}

void Context::Load (const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement)
{
	Load (Instruction::LUI, register_, address, displacement, 16); Load (Instruction::ORI, register_, address, displacement, 0);
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	auto high = false, floating = false;
	for (auto& type: types) if (type.model == Code::Type::Float && floatSupport) floating = true; else if (type.size == 8) high = true;
	assert (!registers[Low][register_]); Acquire (registers[Low][register_] = (register_ == Code::RRes ? R2 : GetFree (Low)));
	assert (!registers[High][register_]); if (high) Acquire (registers[High][register_] = (register_ == Code::RRes ? R3 : GetFree (High)));
	assert (!registers[Float][register_]); if (floating) Acquire (registers[Float][register_] = (register_ == Code::RRes ? F0 : GetFree (Float)));
}

void Context::Release (const Code::Register register_)
{
	assert (registers[Low][register_]); Release (registers[Low][register_]); registers[Low][register_] = R0;
	if (registers[High][register_]) Release (registers[High][register_]), registers[High][register_] = R0;
	if (registers[Float][register_]) Release (registers[Float][register_]), registers[Float][register_] = R0;
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
	case Code::Instruction::COPY:
	case Code::Instruction::FILL:
	case Code::Instruction::NOT:
	case Code::Instruction::AND:
	case Code::Instruction::OR:
	case Code::Instruction::XOR:
	case Code::Instruction::PUSH:
	case Code::Instruction::POP:
	case Code::Instruction::BR:
	case Code::Instruction::TRAP:
		return true;

	case Code::Instruction::CONV:
		return false;

	case Code::Instruction::BREQ:
	case Code::Instruction::BRNE:
		return !IsFloat (instruction.operand2) || floatSupport;

	default:
		if (IsFloat (instruction.operand1) || IsFloat (instruction.operand2)) return floatSupport;
		return architecture == MIPS64 || !IsDoublePrecision (instruction.operand1) && !IsDoublePrecision (instruction.operand2);
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
		if (IsFloat (operand1)) Operation (IsDoublePrecision (operand1) ? Instruction::MOVD : Instruction::MOVS, operand1, operand2, Float);
		else if (IsComplex (operand1)) Move (operand1, operand2, Low), Move (operand1, operand2, High);
		else Move (operand1, operand2, Low);
		break;

	case Code::Instruction::COPY:
		Copy (operand1, operand2, operand3);
		break;

	case Code::Instruction::FILL:
		Fill (operand1, operand2, operand3);
		break;

	case Code::Instruction::NEG:
		if (IsFloat (operand1)) Operation (IsDoublePrecision (operand1) ? Instruction::NEGD : Instruction::NEGS, operand1, operand2, Float);
		else Operation (IsDoublePrecision (operand1) ? Instruction::DSUBU : Instruction::SUBU, operand1, operand2, Low);
		break;

	case Code::Instruction::ADD:
		if (IsFloat (operand1)) Operation (IsDoublePrecision (operand1) ? Instruction::ADDD : Instruction::ADDS, Instruction::NOP, operand1, operand2, operand3, Float);
		else if (IsDoublePrecision (operand1) && architecture == MIPS64) Operation (Instruction::DADDU, Instruction::DADDIU, operand1, operand2, operand3, Low);
		else Operation (Instruction::ADDU, Instruction::ADDIU, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::SUB:
		if (IsFloat (operand1)) Operation (IsDoublePrecision (operand1) ? Instruction::SUBD : Instruction::SUBS, Instruction::NOP, operand1, operand2, operand3, Float);
		else if (IsDoublePrecision (operand1) && architecture == MIPS64) Operation (Instruction::DSUBU, Instruction::DADDIU, operand1, operand2, operand3, Low);
		else Operation (Instruction::SUBU, Instruction::ADDIU, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MUL:
		if (IsFloat (operand1)) Operation (IsDoublePrecision (operand1) ? Instruction::MULD : Instruction::MULS, Instruction::NOP, operand1, operand2, operand3, Float);
		else if (IsSigned (operand1)) SpecialOperation (IsDoublePrecision (operand1) ? Instruction::DMULT : Instruction::MULT, operand1, operand2, operand3, Instruction::MFLO);
		else SpecialOperation (IsDoublePrecision (operand1) ? Instruction::DMULTU : Instruction::MULTU, operand1, operand2, operand3, Instruction::MFLO);
		break;

	case Code::Instruction::DIV:
		if (IsFloat (operand1)) Operation (IsDoublePrecision (operand1) ? Instruction::DIVD : Instruction::DIVS, Instruction::NOP, operand1, operand2, operand3, Float);
		else if (IsSigned (operand1)) SpecialOperation (IsDoublePrecision (operand1) ? Instruction::DDIV : Instruction::DIV, operand1, operand2, operand3, Instruction::MFLO);
		else SpecialOperation (IsDoublePrecision (operand1) ? Instruction::DDIVU : Instruction::DIVU, operand1, operand2, operand3, Instruction::MFLO);
		break;

	case Code::Instruction::MOD:
		if (IsSigned (operand1)) SpecialOperation (IsDoublePrecision (operand1) ? Instruction::DDIV : Instruction::DIV, operand1, operand2, operand3, Instruction::MFHI);
		else SpecialOperation (IsDoublePrecision (operand1) ? Instruction::DDIVU : Instruction::DIVU, operand1, operand2, operand3, Instruction::MFHI);
		break;

	case Code::Instruction::NOT:
		Operation (Instruction::NOR, operand1, operand2, Low);
		if (IsComplex (operand1)) Operation (Instruction::NOR, operand1, operand2, High);
		break;

	case Code::Instruction::AND:
		Operation (Instruction::AND, Instruction::ANDI, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::AND, Instruction::ANDI, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::OR:
		Operation (Instruction::OR, Instruction::ORI, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::OR, Instruction::ORI, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::XOR:
		Operation (Instruction::XOR, Instruction::XORI, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::XOR, Instruction::XORI, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::LSH:
		if (IsDoublePrecision (operand1)) ShiftOperation (Instruction::DSLLV, Instruction::DSLL, Instruction::DSLL32, operand1, operand2, operand3);
		else ShiftOperation (Instruction::SLLV, Instruction::SLL, Instruction::NOP, operand1, operand2, operand3);
		break;

	case Code::Instruction::RSH:
		if (IsSigned (operand1) && IsDoublePrecision (operand1)) ShiftOperation (Instruction::DSRAV, Instruction::DSRA, Instruction::DSRA32, operand1, operand2, operand3);
		else if (IsSigned (operand1)) ShiftOperation (Instruction::SRAV, Instruction::SRA, Instruction::NOP, operand1, operand2, operand3);
		else if (IsDoublePrecision (operand1)) ShiftOperation (Instruction::DSRLV, Instruction::DSRL, Instruction::DSRL32, operand1, operand2, operand3);
		else ShiftOperation (Instruction::SRLV, Instruction::SRL, Instruction::NOP, operand1, operand2, operand3);
		break;

	case Code::Instruction::PUSH:
		Emit ({fullAddressSpace ? Instruction::DADDIU : Instruction::ADDIU, R29, R29, -Immediate (IsDoublePrecision (operand1) ? 8 : 4)});
		if (IsFloat (operand1)) Push (IsDoublePrecision (operand1) ? Instruction::SDC1 : Instruction::SWC1, operand1, Float);
		else if (IsComplex (operand1)) Push (Instruction::SW, operand1, Low), Push (Instruction::SW, operand1, High);
		else Push (IsDoublePrecision (operand1) ? Instruction::SD : Instruction::SW, operand1, Low);
		break;

	case Code::Instruction::POP:
		if (IsFloat (operand1)) Pop (IsDoublePrecision (operand1) ? Instruction::LDC1 : Instruction::LWC1, operand1, Float);
		else if (IsComplex (operand1)) Pop (Instruction::LW, operand1, Low), Pop (Instruction::LW, operand1, High);
		else Pop (IsDoublePrecision (operand1) ? Instruction::LD : Instruction::LW, operand1, Low);
		Emit ({fullAddressSpace ? Instruction::DADDIU : Instruction::ADDIU, R29, R29, Immediate (IsDoublePrecision (operand1) ? 8 : 4)});
		break;

	case Code::Instruction::CALL:
		Jump (Instruction::JALR, operand1);
		if (operand2.size) Emit ({fullAddressSpace ? Instruction::DADDIU : Instruction::ADDIU, R29, R29, Immediate (operand2.size)});
		break;

	case Code::Instruction::RET:
		Emit ({fullAddressSpace ? Instruction::LD : Instruction::LW, R31, 0, R29}); Emit (JR {R31});
		Emit ({fullAddressSpace ? Instruction::DADDIU : Instruction::ADDIU, R29, R29, Immediate (fullAddressSpace ? 8 : 4)});
		break;

	case Code::Instruction::ENTER:
		if (fullAddressSpace) Emit (SD {R30, -8, R29}), Emit (DADDIU {R30, R29, -8}), Emit (DADDIU {R29, R29, -Immediate (operand1.size + 8)});
		else Emit (SW {R30, -4, R29}), Emit (ADDIU {R30, R29, -4}), Emit (ADDIU {R29, R29, -Immediate (operand1.size + 4)});
		break;

	case Code::Instruction::LEAVE:
		if (fullAddressSpace) Emit (DADDIU {R29, R30, 8}), Emit (LD {R30, -8, R29});
		else Emit (ADDIU {R29, R30, 4}), Emit (LW {R30, -4, R29});
		break;

	case Code::Instruction::BR:
		Branch (Instruction::B, GetLabel (operand1.offset), R0, R0);
		break;

	case Code::Instruction::BREQ:
		if (IsFloat (operand2)) CompareAndBranch (IsDoublePrecision (operand2) ? Instruction::CEQD : Instruction::CEQS, Instruction::BC1T, operand1.offset, operand2, operand3);
		else if (IsComplex (operand2)) Branch (Instruction::BNE, GetLabel (0), operand2, operand3, High), Branch (Instruction::BEQ, GetLabel (operand1.offset), operand2, operand3, Low);
		else Branch (Instruction::BEQ, GetLabel (operand1.offset), operand2, operand3, Low);
		break;

	case Code::Instruction::BRNE:
		if (IsFloat (operand2)) CompareAndBranch (IsDoublePrecision (operand2) ? Instruction::CEQD : Instruction::CEQS, Instruction::BC1F, operand1.offset, operand2, operand3);
		else if (IsComplex (operand2)) Branch (Instruction::BEQ, GetLabel (0), operand2, operand3, High), Branch (Instruction::BNE, GetLabel (operand1.offset), operand2, operand3, Low);
		else Branch (Instruction::BNE, GetLabel (operand1.offset), operand2, operand3, Low);
		break;

	case Code::Instruction::BRLT:
		if (IsFloat (operand2)) CompareAndBranch (IsDoublePrecision (operand2) ? Instruction::COLTD : Instruction::COLTS, Instruction::BC1T, operand1.offset, operand2, operand3);
		else CompareAndBranch (Instruction::BLTZ, operand1.offset, operand2, operand3);
		break;

	case Code::Instruction::BRGE:
		if (IsFloat (operand2)) CompareAndBranch (IsDoublePrecision (operand2) ? Instruction::CULTD : Instruction::CULTS, Instruction::BC1F, operand1.offset, operand2, operand3);
		else CompareAndBranch (Instruction::BGEZ, operand1.offset, operand2, operand3);
		break;

	case Code::Instruction::JUMP:
		Jump (Instruction::JR, operand1);
		break;

	case Code::Instruction::TRAP:
		Emit (BREAK {});
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const Code::Operand& target, const Code::Operand& value, const Index index)
{
	if (IsRegister (target)) Load (Select (target, index), value, index);
	else Store (Load (value, index), target, index);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	const auto targetAddress = Acquire (Low); Load (targetAddress, target, Low);
	const auto sourceAddress = Acquire (Low); Load (sourceAddress, source, Low);
	const auto count = Acquire (Low); Load (count, size, Low);
	if (!IsImmediate (size)) Branch (Instruction::BEQ, GetLabel (0), GetRegister (count), R0);
	auto begin = CreateLabel (); begin (); const auto value = Acquire (Low);
	const Immediate increment = IsImmediate (size) ? Extract (size, Low) % 4 == 0 ? 4 : Extract (size, Low) % 2 == 0 ? 2 : 1 : 1;
	Emit ({increment == 1 ? Instruction::LB : increment == 2 ? Instruction::LH : Instruction::LW, value, 0, sourceAddress});
	Emit ({increment == 1 ? Instruction::SB : increment == 2 ? Instruction::SH : Instruction::SW, value, 0, targetAddress});
	Emit (ADDI {targetAddress, targetAddress, increment}); Emit (ADDI {sourceAddress, sourceAddress, increment}); Emit (ADDI {count, count, -increment});
	Branch (Instruction::BNE, begin, GetRegister (count), R0);
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto count = Acquire (Low); Load (count, size, Low);
	if (!IsImmediate (size)) Branch (Instruction::BEQ, GetLabel (0), GetRegister (count), R0);
	const auto targetAddress = Acquire (Low); Load (targetAddress, target, Low);
	const auto low = Load (value, Low), high = IsDoublePrecision (value) ? Load (value, High) : R0; auto begin = CreateLabel (); begin ();
	Emit ({value.type.size == 1 ? Instruction::SB : value.type.size == 2 ? Instruction::SH : Instruction::SW, low, 0, targetAddress});
	if (IsDoublePrecision (value)) Emit (SW {high, 4, targetAddress}); Emit (ADDI {targetAddress, targetAddress, Immediate (value.type.size)});
	Emit (ADDI {count, count, -1}); Branch (Instruction::BNE, begin, GetRegister (count), R0);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value, const Index index)
{
	const auto result = Acquire (target, index);
	if (mnemonic == Instruction::SUBU || mnemonic == Instruction::DSUBU || mnemonic == Instruction::NOR)
		Emit ({mnemonic, result, R0, Load (value, index)});
	else Emit ({mnemonic, result, Load (value, index)}); Store (result, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Instruction::Mnemonic immediate, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto result = Acquire (target, index), value = Load (value1, index);
	if ((immediate == Instruction::ANDI || immediate == Instruction::ORI || immediate == Instruction::XORI) && IsImmediate (value2) && Extract (value2, index) >= 0 && Extract (value2, index) < 65536)
		Emit ({immediate, result, value, Extract (value2, index)});
	else if ((immediate == Instruction::ADDIU || immediate == Instruction::DADDIU) && IsImmediate (value2) && IsValid (Extract (value2, index)))
		Emit ({immediate, result, value, mnemonic == Instruction::SUBU || mnemonic == Instruction::DSUBU ? -Extract (value2, index) : Extract (value2, index)});
	else Emit ({mnemonic, result, value, Load (value2, index)}); Store (result, target, index);
}

void Context::SpecialOperation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Instruction::Mnemonic move)
{
	const auto result = Acquire (target, Low), value = Load (value1, Low);
	Emit ({mnemonic, value, Load (value2, Low)}); Emit ({move, result}); Store (result, target, Low);
}

void Context::ShiftOperation (const Instruction::Mnemonic mnemonic, const Instruction::Mnemonic immediate, const Instruction::Mnemonic immediate32, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto shift = IsImmediate (value2) ? Extract (value2, Low) : 64;
	const auto result = Acquire (target, Low), value = Load (value1, Low);
	if (shift >= 0 && shift < 32) Emit ({immediate, result, value, shift});
	else if (immediate32 != Instruction::NOP && shift >= 32 && shift < 63) Emit ({immediate32, result, value, shift});
	else Emit ({mnemonic, result, value, Load (value2, Low)}); Store (result, target, Low);
}

void Context::Push (const Instruction::Mnemonic mnemonic, const Code::Operand& value, const Index index)
{
	Emit ({mnemonic, Load (value, index), index * 4 % 8, R29});
}

void Context::Pop (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Index index)
{
	const auto result = Acquire (target, index); Emit ({mnemonic, result, index * 4 % 8, R29}); Store (result, target, index);
}

void Context::CompareAndBranch (const Instruction::Mnemonic mnemonic, const Code::Offset offset, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto temporary = Acquire (Low), value = Load (value1, Low);
	Emit ({IsDoublePrecision (value1) ? Instruction::DSUBU : Instruction::SUBU, temporary, value, Load (value2, Low)});
	Branch (mnemonic, GetLabel (offset), GetRegister (temporary), R0);
}

void Context::CompareAndBranch (const Instruction::Mnemonic compare, const Instruction::Mnemonic branch, const Code::Offset offset, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto value = Load (value1, Float); Emit ({compare, 0, value, Load (value2, Float)}); Branch (branch, GetLabel (offset), R0, R0);
}

void Context::Jump (const Instruction::Mnemonic mnemonic, const Code::Operand& target)
{
	const auto address = Load (target, Low);
	if (mnemonic == Instruction::Instruction::JALR) Emit ({mnemonic, R31, address}); else Emit ({mnemonic, address}); Emit (NOP {});
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Label& label, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto left = Load (value1, index); if (IsRegister (value1)) Truncate (left, value1.type);
	const auto right = Load (value2, index); if (IsRegister (value2)) Truncate (right, value2.type);
	Branch (mnemonic, label, GetRegister (left), GetRegister (right));
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Label& label, const Register register1, const Register register2)
{
	AddFixup (label, (mnemonic << 10) + (register1 << 5) + register2, 4);
	if (listing) switch (mnemonic)
	{
	case Instruction::B: listing << '\t' << mnemonic << '\t' << label << '\n'; break;
	case Instruction::BC1T: case Instruction::BC1F: listing << '\t' << mnemonic << '\t' << Immediate (register1) << ", " << label << '\n'; break;
	case Instruction::BEQ: case Instruction::BNE: listing << '\t' << mnemonic << '\t' << register1 << ", " << register2 << ", " << label << '\n'; break;
	default: listing << '\t' << mnemonic << '\t' << register1 << ", " << label << '\n';
	}
	Emit (NOP {});
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const auto offset = Immediate (target - bytes.end ());
	const auto mnemonic = Instruction::Mnemonic (code >> 10);
	const auto register1 = Register ((code >> 5) % 32), register2 = Register (code % 32);
	switch (mnemonic)
	{
	case Instruction::B: B {offset}.Emit (bytes, endianness); break;
	case Instruction::BC1T: case Instruction::BC1F: Instruction {mnemonic, Immediate (register1), offset}.Emit (bytes, endianness); break;
	case Instruction::BEQ: case Instruction::BNE: Instruction {mnemonic, register1, register2, offset}.Emit (bytes, endianness); break;
	default: Instruction {mnemonic, register1, offset}.Emit (bytes, endianness);
	}
}

Context::Part Context::GetRegisterParts (const Code::Operand& operand) const
{
	return (!IsFloat (operand) && IsComplex (operand)) + 1;
}

Context::Suffix Context::GetRegisterSuffix (const Code::Operand& operand, const Part part) const
{
	return !IsFloat (operand) && IsComplex (operand) ? part == High ? 'h' : 'l' : 0;
}

std::ostream& Context::WriteRegister (std::ostream& stream, const Code::Operand& operand, const Part part)
{
	return stream << registers[IsFloat (operand) ? Float : Index (part)][operand.register_];
}

bool Context::IsDoublePrecision (const Code::Operand& operand)
{
	return operand.type.size == 8;
}

SmartOperand::SmartOperand (Context& c, const MIPS::Register register_) :
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

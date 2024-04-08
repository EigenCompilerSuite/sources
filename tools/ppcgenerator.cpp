// PowerPC machine code generator
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
#include "ppc.hpp"
#include "ppcgenerator.hpp"

using namespace ECS;
using namespace PowerPC;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const PowerPC::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	enum Index {Low, High, Float};

	class SmartOperand;

	const Architecture architecture;
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

	void Load (const Operand&, const Code::Operand&, Index);
	void Store (const Operand&, const Code::Operand&, Index);
	void Access (Instruction::Mnemonic, const Operand&, const Code::Operand&, Index);

	void Emit (const Instruction&);

	void Load (const Operand&, const Code::Section::Name&, Code::Displacement);
	void Load (Instruction::Mnemonic, const Operand&, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);

	void Branch (Instruction::Mnemonic, Code::Offset);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, Index);
	void Operation (Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	bool IsComplex (const Code::Operand&) const;
	static bool IsDoublePrecision (const Code::Operand&);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (SmartOperand&&) noexcept;
	SmartOperand (Context&, PowerPC::Register);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c, const Architecture a, const FullAddressSpace fas) :
	Assembly::Generator {d, sp, assembler, "ppc", "PowerPC", {{4, 1, 8}, {4, 4, 8}, a == PPC64 && fas ? 8u : 4u, a == PPC64 && fas ? 8u : 4u, {0, a == PPC64 && fas ? 8u : 4u, 8}, true}, false},
	assembler {d, c, a}, architecture {a}, fullAddressSpace {fas}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const PowerPC::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}, architecture {g.architecture}, fullAddressSpace {g.fullAddressSpace}
{
	for (auto& set: registers) for (auto& register_: set) register_ = R0;
	Acquire (registers[Low][Code::RSP] = R29); Acquire (registers[Low][Code::RFP] = R30); Acquire (R31);
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
	auto register_ = (index == Float ? FR1 : R4); while (register_ % 32 && acquired[register_]) register_ = Register (register_ + 1);
	if (register_ % 32 == 0) throw RegisterShortage {}; return register_;
}

Register Context::Select (const Code::Operand& operand, const Index index) const
{
	assert (IsRegister (operand)); return registers[index][operand.register_];
}

Immediate Context::Extract (const Code::Operand& operand, const Index index) const
{
	assert (IsImmediate (operand)); return Immediate (Code::Convert (operand) >> index * 32 % 64);
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
		if (IsFloat (operand)) Emit ({IsDoublePrecision (operand) ? Instruction::LFD : Instruction::LFS, register_, 0, Load (Code::Adr {generator.platform.pointer, DefineGlobal (operand)}, Low)});
		else if (IsSigned (operand) && index == Low && TruncatesPreserving (operand.simm, 16)) Emit (LI {register_, Immediate (operand.simm)});
		else Emit (LI {register_, std::int16_t (Extract (operand, index))}), Emit (ORIS {register_, register_, std::uint16_t (Extract (operand, index) >> 16)});
		break;

	case Code::Operand::Address:
		Load (register_, operand.address, operand.displacement);
		if (operand.register_ != Code::RVoid) Emit (ADD {register_, register_, registers[index][operand.register_]});
		break;

	case Code::Operand::Register:
		if (GetRegister (register_) != registers[index][operand.register_] || operand.displacement)
			Emit ({IsFloat (operand) ? Instruction::FMR : Instruction::MR, register_, registers[index][operand.register_]});
		break;

	case Code::Operand::Memory:
		if (IsFloat (operand)) return Access (IsDoublePrecision (operand) ? Instruction::LFD : Instruction::LFS, register_, operand, index);

		switch (operand.type.size)
		{
		case 1: Access (Instruction::LBZ, register_, operand, index); if (IsSigned (operand)) Emit (EXTSB {register_, register_}); break;
		case 2: Access (IsSigned (operand) ? Instruction::LHA : Instruction::LHZ, register_, operand, index); break;
		case 4: Access (IsSigned (operand) && architecture == PPC64 ? Instruction::LWA : Instruction::LWZ, register_, operand, index); break;
		case 8: Access (architecture == PPC64 ? Instruction::LD : Instruction::LWZ, register_, operand, index); break;
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
			Emit ({IsFloat (operand) ? Instruction::FMR : Instruction::MR, registers[index][operand.register_], register_});
		break;

	case Code::Operand::Memory:
		if (IsFloat (operand)) return Access (IsDoublePrecision (operand) ? Instruction::STFD : Instruction::STFS, register_, operand, index);

		switch (operand.type.size)
		{
		case 1: Access (Instruction::STB, register_, operand, index); break;
		case 2: Access (Instruction::STH, register_, operand, index); break;
		case 4: Access (Instruction::STW, register_, operand, index); break;
		case 8: Access (architecture == PPC64 ? Instruction::STD : Instruction::STW, register_, operand, index); break;
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
	if (operand.address.empty () && operand.register_ != Code::RVoid) return Emit ({mnemonic, register_, Immediate (operand.displacement + index * 4 % 8), registers[Low][operand.register_]});
	auto base = Acquire (Low);
	if (!operand.address.empty ()) Load (base, operand.address, operand.displacement + index * 4 % 8);
	else Emit (LI {register_, Immediate (operand.ptrimm + index * 4 % 8) & 0xffff}), Emit (ORIS {register_, register_, Immediate (operand.ptrimm + index * 4 % 8) >> 16 & 0xffff});
	if (operand.register_ != Code::RVoid) Emit (ADD {base, base, registers[index][operand.register_]});
	Emit ({mnemonic, register_, 0, base});
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction, architecture));
	instruction.Emit (Reserve (4));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Load (const Instruction::Mnemonic mnemonic, const Operand& register_, const Operand& operand, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, register_, operand, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (!listing) return; listing << '\t' << mnemonic << '\t' << register_ << ", " << operand << ", ";
	WriteAddress (listing, nullptr, address, displacement, scale) << '\n';
}

void Context::Load (const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement)
{
	Load (Instruction::ADDI, register_, R0, address, displacement, 0), Load (Instruction::ORIS, register_, register_, address, displacement, 16);
	if (architecture == PPC64 && fullAddressSpace)
		Emit (RLDICL {register_, register_, 32, 32}), Load (Instruction::ADDI, register_, register_, address, displacement, 32), Load (Instruction::ADDIS, register_, register_, address, displacement, 48);
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	auto high = false, floating = false;
	for (auto& type: types) if (type.model == Code::Type::Float) floating = true; else if (type.size == 8) high = true;
	assert (!registers[Low][register_]); Acquire (registers[Low][register_] = (register_ == Code::RRes ? R2 : GetFree (Low)));
	assert (!registers[High][register_]); if (high) Acquire (registers[High][register_] = (register_ == Code::RRes ? R3 : GetFree (High)));
	assert (!registers[Float][register_]); if (floating) Acquire (registers[Float][register_] = (register_ == Code::RRes ? FR0 : GetFree (Float)));
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
	case Code::Instruction::NOT:
	case Code::Instruction::AND:
	case Code::Instruction::OR:
	case Code::Instruction::XOR:
	case Code::Instruction::PUSH:
	case Code::Instruction::POP:
		return true;

	case Code::Instruction::CONV:
	case Code::Instruction::COPY:
	case Code::Instruction::FILL:
	case Code::Instruction::TRAP:
		return false;

	default:
		return architecture == PPC64 || instruction.operand1.type.size != 8 && instruction.operand2.type.size != 8;
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
		if (IsFloat (operand1)) Move (operand1, operand2, Float);
		else if (IsComplex (operand1)) Move (operand1, operand2, Low), Move (operand1, operand2, High);
		else Move (operand1, operand2, Low);
		break;

	case Code::Instruction::NEG:
		if (IsFloat (operand1)) Operation (Instruction::FNEG, operand1, operand2, Float);
		else Operation (Instruction::NEG, operand1, operand2, Low);
		break;

	case Code::Instruction::ADD:
		if (IsFloat (operand1)) Operation (Instruction::FADD, Instruction::NOP, operand1, operand2, operand3, Float);
		else Operation (Instruction::ADD, Instruction::ADDI, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::SUB:
		if (IsFloat (operand1)) Operation (Instruction::FSUB, Instruction::NOP, operand1, operand2, operand3, Float);
		else Operation (Instruction::SUB, Instruction::SUBI, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MUL:
		if (IsFloat (operand1)) Operation (Instruction::FMUL, Instruction::NOP, operand1, operand2, operand3, Float);
		else Operation (Instruction::MULLW, Instruction::MULLI, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::DIV:
		if (IsFloat (operand1)) Operation (Instruction::FDIV, Instruction::NOP, operand1, operand2, operand3, Float);
		else Operation (Instruction::DIVW, Instruction::NOP, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MOD:
		break;

	case Code::Instruction::NOT:
		Operation (Instruction::NOT, operand1, operand2, Low);
		if (IsComplex (operand1)) Operation (Instruction::NOT, operand1, operand2, High);
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
	case Code::Instruction::RSH:
	case Code::Instruction::PUSH:
	case Code::Instruction::POP:
	case Code::Instruction::CALL:
	case Code::Instruction::RET:
	case Code::Instruction::ENTER:
	case Code::Instruction::LEAVE:
		break;

	case Code::Instruction::BR:
		Branch (Instruction::B, operand1.offset);
		break;

	case Code::Instruction::BREQ:
	case Code::Instruction::BRNE:
	case Code::Instruction::BRLT:
	case Code::Instruction::BRGE:
	case Code::Instruction::JUMP:
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const Code::Operand& target, const Code::Operand& value, const Index index)
{
	if (IsRegister (value)) return Store (Select (value, index), target, index);
	const auto result = Acquire (target, index); Load (result, value, index); Store (result, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value, const Index index)
{
	const auto result = Acquire (target, index); Emit ({mnemonic, result, Load (value, index)}); Store (result, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Instruction::Mnemonic immediate, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto result = Acquire (target, index); Load (result, value1, index);
	if ((immediate == Instruction::ANDI || immediate == Instruction::ORI || immediate == Instruction::XORI) && IsImmediate (value2) && Extract (value2, index) >= 0 && Extract (value2, index) < 65536)
		Emit ({immediate, result, result, Extract (value2, index)});
	else if ((immediate == Instruction::ADDI || immediate == Instruction::SUBI || immediate == Instruction::MULLI) && IsImmediate (value2) && Extract (value2, index) >= -32768 && Extract (value2, index) < 32767)
		Emit ({immediate, result, result, Extract (value2, index)});
	else Emit ({mnemonic, result, result, Load (value2, index)}); Store (result, target, index);
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Code::Offset offset)
{
	const auto label = GetLabel (offset); AddFixup (label, mnemonic, 4);
	if (listing) listing << '\t' << mnemonic << '\t' << label << '\n';
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	Instruction {Instruction::Mnemonic (code), Immediate (target - bytes.begin ())}.Emit (bytes);
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

bool Context::IsComplex (const Code::Operand& operand) const
{
	assert (!IsFloat (operand)); return IsDoublePrecision (operand) && architecture != PPC64;
}

bool Context::IsDoublePrecision (const Code::Operand& operand)
{
	return operand.type.size == 8;
}

SmartOperand::SmartOperand (Context& c, const PowerPC::Register register_) :
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

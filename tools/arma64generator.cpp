// ARM A64 machine code generator
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

#include "arma64.hpp"
#include "arma64generator.hpp"
#include "asmgeneratorcontext.hpp"

using namespace ECS;
using namespace ARM;
using namespace A64;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const A64::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	class SmartOperand;

	const FullAddressSpace fullAddressSpace;

	bool acquired[29] {};
	Register registers[Code::Registers];

	void Acquire (Register);
	void Release (Register);

	Register GetFree () const;
	Register Select (const Code::Operand&) const;
	Immediate Extract (const Code::Operand&) const;

	SmartOperand Acquire (const Code::Type&);
	SmartOperand Acquire (const Code::Operand&);
	SmartOperand Load (const Code::Operand&);
	SmartOperand Load (Immediate, const Code::Type&);
	SmartOperand Load (const Code::Section::Name&, Code::Displacement);

	void Load (const Operand&, const Code::Operand&);
	void Store (const Operand&, const Code::Operand&);
	void Access (Instruction::Mnemonic, const Operand&, const Code::Operand&);

	void Emit (const Instruction&);
	void Emit (Instruction::Mnemonic, const Code::Section::Name&);
	void Emit (Instruction::Mnemonic, const Operand&, const Code::Section::Name&, Code::Displacement);
	void Emit (Instruction::Mnemonic, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale, const Operand&);
	void Emit (const Instruction&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);

	void Displace (const Operand&, Immediate);
	void Move (const Operand&, const Operand&);
	void Extend (const Operand&, const Code::Type&);
	void Load (const Operand&, Immediate, const Code::Type&);
	void Load (const Operand&, const Code::Section::Name&, Code::Displacement);

	void Pop (const Code::Operand&);
	void Push (const Code::Operand&);
	void Branch (Code::Offset, Instruction::Mnemonic);
	void Branch (const Label&, Instruction::Mnemonic);
	void Move (const Code::Operand&, const Code::Operand&);
	void Branch (Instruction::Mnemonic, const Code::Operand&);
	void Compare (const Code::Operand&, const Code::Operand&);
	void Convert (const Code::Operand&, const Code::Operand&);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Modulo (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static bool IsValidUnsigned (Immediate);
	static bool IsRegister (const Code::Operand&);
	static bool IsValidDisplacement (Immediate, const Code::Type&);
	static Register TranslateBack (Register);
	static Register Translate (Register, const Code::Type&);
	static Register Translate (const Operand&, const Code::Type&);
	static Instruction::Mnemonic GetLoadMnemonic (const Code::Type&);
	static Instruction::Mnemonic GetStoreMnemonic (const Code::Type&);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (SmartOperand&&) noexcept;
	SmartOperand (Context&, A64::Register, const Code::Type&);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c, const FullAddressSpace fas) :
	Assembly::Generator {d, sp, assembler, "arma64", "ARM A64", {{4, 1, 8}, {8, 4, 8}, 8, 8, {0, 16, 16}, true}, true}, assembler {d, c}, fullAddressSpace {fas}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const A64::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}, fullAddressSpace {g.fullAddressSpace}
{
	for (auto& register_: registers) register_ = XZR;
	registers[Code::RSP] = SP; registers[Code::RFP] = X29; registers[Code::RLink] = X30;
}

void Context::Acquire (const Register register_)
{
	assert (register_ < X29); assert (!acquired[register_ - X0]); acquired[register_ - X0] = true;
}

void Context::Release (const Register register_)
{
	assert (register_ < X29); assert (acquired[register_ - X0]); acquired[register_ - X0] = false;
}

A64::Register Context::GetFree () const
{
	auto register_ = X1; while (register_ != X29 && acquired[register_ - X0]) register_ = Register (register_ + 1);
	if (register_ == X29) throw RegisterShortage {}; return register_;
}

A64::Register Context::Select (const Code::Operand& operand) const
{
	assert (IsRegister (operand)); return Translate (registers[operand.register_], operand.type);
}

A64::Immediate Context::Extract (const Code::Operand& operand) const
{
	assert (IsImmediate (operand)); return Immediate (Code::Convert (operand));
}

SmartOperand Context::Acquire (const Code::Type& type)
{
	return {*this, GetFree (), type};
}

SmartOperand Context::Acquire (const Code::Operand& operand)
{
	if (IsRegister (operand)) return Select (operand); return Acquire (operand.type);
}

SmartOperand Context::Load (const Code::Operand& operand)
{
	if (IsRegister (operand)) return Select (operand);
	if (IsImmediate (operand) && !IsFloat (operand) && !Extract (operand)) return Translate (XZR, operand.type);
	auto result = Acquire (operand.type); Load (result, operand); return result;
}

SmartOperand Context::Load (const Immediate immediate, const Code::Type& type)
{
	if (!immediate && type.model != Code::Type::Float) return Translate (XZR, type);
	auto result = Acquire (type); Load (result, immediate, type); return result;
}

SmartOperand Context::Load (const Code::Section::Name& address, const Code::Displacement displacement)
{
	auto result = Acquire (generator.platform.pointer); Load (result, address, displacement); return result;
}

void Context::Load (const Operand& register_, const Code::Operand& operand)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		if (IsSigned (operand)) Load (register_, operand.simm, operand.type);
		else if (!IsFloat (operand)) Load (register_, Code::Convert (operand), operand.type);
		else if (!operand.fimm) Emit (FMOV {register_, operand.type.size == 8 ? XZR : WZR});
		else if (IsValid (operand.fimm)) Emit (FMOV {register_, operand.fimm});
		else Emit (FMOV {register_, Load (Code::Convert (operand), Code::Unsigned {operand.type.size})});
		break;

	case Code::Operand::Register:
		Move (register_, Translate (registers[operand.register_], operand.type));
		Displace (register_, operand.displacement);
		break;

	case Code::Operand::Address:
		if (operand.register_ != Code::RVoid && registers[operand.register_] == GetRegister (register_))
			return Emit (ADD {register_, register_, Load (operand.address, operand.displacement)});
		Load (register_, operand.address, operand.displacement);
		if (operand.register_ != Code::RVoid) Emit (ADD {register_, registers[operand.register_], register_});
		break;

	case Code::Operand::Memory:
		Access (GetLoadMnemonic (operand.type), register_, operand);
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Store (const Operand& register_, const Code::Operand& operand)
{
	switch (operand.model)
	{
	case Code::Operand::Register:
		Move (Translate (registers[operand.register_], operand.type), register_);
		break;

	case Code::Operand::Memory:
		Access (GetStoreMnemonic (operand.type), register_, operand);
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Access (const Instruction::Mnemonic mnemonic, const Operand& register_, const Code::Operand& operand)
{
	if (operand.address.empty ())
		if (operand.register_ == Code::RVoid) Emit ({mnemonic, register_, {GetRegister (Load (operand.ptrimm, generator.platform.pointer)), 0}});
		else if (IsValidDisplacement (operand.displacement, operand.type)) Emit ({mnemonic, register_, {registers[operand.register_], operand.displacement}});
		else Emit ({mnemonic, register_, {registers[operand.register_], GetRegister (Load (operand.displacement, generator.platform.pointer))}});
	else if (operand.register_ == Code::RVoid && mnemonic == Instruction::LDR && !fullAddressSpace) Emit (mnemonic, register_, operand.address, operand.displacement);
	else if (operand.register_ == Code::RVoid) Emit ({mnemonic, register_, {GetRegister (Load (operand.address, operand.displacement)), 0}});
	else Emit ({mnemonic, register_, {registers[operand.register_], GetRegister (Load (operand.address, operand.displacement))}});
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction)); instruction.Emit (Reserve (4));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Code::Section::Name& address)
{
	Emit ({mnemonic, Immediate {0}}, address, 0, 0);
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t', nullptr, address, 0, 0) << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand& operand1, const Code::Section::Name& address, const Code::Displacement displacement)
{
	Emit ({mnemonic, operand1, Immediate {0}}, address, displacement, 0);
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << operand1 << ", ", nullptr, address, displacement, 0) << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand& operand1, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale, const Operand& operand2)
{
	Emit ({mnemonic, operand1, Immediate {0}, operand2}, address, displacement, scale);
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << operand1 << ", ", nullptr, address, displacement, scale) << ", " << operand2 << '\n';
}

void Context::Emit (const Instruction& instruction, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	assert (IsValid (instruction));
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
}

void Context::Displace (const Operand& register_, const Immediate immediate)
{
	if (!immediate) return;
	if (IsValidUnsigned (immediate)) return Emit (ADD {register_, register_, immediate});
	if (IsValidUnsigned (-immediate)) return Emit (SUB {register_, register_, -immediate});
	Emit (ADD {register_, register_, Load (immediate, generator.platform.pointer)});
}

void Context::Move (const Operand& target, const Operand& source)
{
	const auto from = GetRegister (source), to = GetRegister (target); if (to == from) return;
	Emit ({from >= S0 && from <= S31 || from >= D0 && from <= D31 ? Instruction::FMOV : Instruction::MOV, to, from});
}

void Context::Extend (const Operand& register_, const Code::Type& type)
{
	if (type.size == 1) return Emit ({type.model == Code::Type::Signed ? Instruction::SXTB : Instruction::UXTB, register_, register_});
	if (type.size == 2) return Emit ({type.model == Code::Type::Signed ? Instruction::SXTH : Instruction::UXTH, register_, register_});
}

void Context::Load (const Operand& register_, Immediate immediate, const Code::Type& type)
{
	if (immediate >= -65536 && immediate <= 65535) return Emit (MOV {register_, immediate});
	if (IsValid (immediate, type.size == 8 ? 64 : 32)) return Emit (MOV {register_, immediate});
	auto mov = Instruction::MOVZ; for (Immediate shift = 0; immediate && shift != type.size * 8; shift += 16, immediate >>= 16)
		if (immediate & 0xffff) Emit ({mov, register_, immediate & 0xffff, {ARM::LSL, shift}}), mov = Instruction::MOVK;
}

void Context::Load (const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement)
{
	if (!fullAddressSpace) return Emit (Instruction::ADR, register_, address, displacement);
	for (Immediate shift = 0; shift != 64; shift += 16) Emit (shift ? Instruction::MOVK : Instruction::MOVZ, register_, address, displacement, shift, {ARM::LSL, shift});
}

void Context::Acquire (const Code::Register register_, const Types&)
{
	assert (registers[register_] == XZR); Acquire (registers[register_] = (register_ == Code::RRes ? X0 : GetFree ()));
}

void Context::Release (const Code::Register register_)
{
	assert (registers[register_] != XZR); Release (registers[register_]); registers[register_] = XZR;
}

void Context::Generate (const Code::Instruction& instruction)
{
	auto& operand1 = instruction.operand1;
	auto& operand2 = instruction.operand2;
	auto& operand3 = instruction.operand3;

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
		Move (operand1, operand2);
		break;

	case Code::Instruction::CONV:
		Convert (operand1, operand2);
		break;

	case Code::Instruction::COPY:
		Copy (operand1, operand2, operand3);
		break;

	case Code::Instruction::FILL:
		Fill (operand1, operand2, operand3);
		break;

	case Code::Instruction::NEG:
		Operation (IsFloat (operand1) ? Instruction::FNEG : Instruction::NEG, operand1, operand2);
		break;

	case Code::Instruction::ADD:
		Operation (IsFloat (operand1) ? Instruction::FADD : Instruction::ADD, operand1, operand2, operand3);
		break;

	case Code::Instruction::SUB:
		Operation (IsFloat (operand1) ? Instruction::FSUB : Instruction::SUB, operand1, operand2, operand3);
		break;

	case Code::Instruction::MUL:
		Operation (IsFloat (operand1) ? Instruction::FMUL : Instruction::MUL, operand1, operand2, operand3);
		break;

	case Code::Instruction::DIV:
		Operation (IsFloat (operand1) ? Instruction::FDIV : IsSigned (operand1) ? Instruction::SDIV : Instruction::UDIV, operand1, operand2, operand3);
		break;

	case Code::Instruction::MOD:
		Modulo (operand1, operand2, operand3);
		break;

	case Code::Instruction::NOT:
		Operation (Instruction::MVN, operand1, operand2);
		break;

	case Code::Instruction::AND:
		Operation (Instruction::AND, operand1, operand2, operand3);
		break;

	case Code::Instruction::OR:
		Operation (Instruction::ORR, operand1, operand2, operand3);
		break;

	case Code::Instruction::XOR:
		Operation (Instruction::EOR, operand1, operand2, operand3);
		break;

	case Code::Instruction::LSH:
		Operation (Instruction::LSL, operand1, operand2, operand3);
		break;

	case Code::Instruction::RSH:
		Operation (IsSigned (operand1) ? Instruction::ASR : Instruction::LSR, operand1, operand2, operand3);
		break;

	case Code::Instruction::PUSH:
		Push (operand1);
		break;

	case Code::Instruction::POP:
		Pop (operand1);
		break;

	case Code::Instruction::CALL:
		if (IsAddress (operand1) && !fullAddressSpace) Emit (Instruction::BL, operand1.address);
		else Branch (Instruction::BLR, operand1);
		Displace (SP, operand2.size);
		break;

	case Code::Instruction::RET:
		Emit (LDR {X30, {SP, 0}, Immediate {16}});
		Emit (RET {});
		break;

	case Code::Instruction::ENTER:
		Emit (STR {X29, {SP, -16, true}}); Emit (MOV {X29, SP});
		Displace (SP, -operand1.size);
		break;

	case Code::Instruction::LEAVE:
		Emit (MOV {SP, X29});
		Emit (LDR {X29, {SP, 0}, Immediate {16}});
		break;

	case Code::Instruction::BR:
		Branch (operand1.offset, Instruction::B);
		break;

	case Code::Instruction::BREQ:
		Compare (operand2, operand3);
		Branch (operand1.offset, Instruction::BEQ);
		break;

	case Code::Instruction::BRNE:
		Compare (operand2, operand3);
		Branch (operand1.offset, Instruction::BNE);
		break;

	case Code::Instruction::BRLT:
		Compare (operand2, operand3);
		Branch (operand1.offset, IsSigned (operand2) ? Instruction::BLT : Instruction::BLO);
		break;

	case Code::Instruction::BRGE:
		Compare (operand2, operand3);
		Branch (operand1.offset, IsSigned (operand2) ? Instruction::BGE : Instruction::BHS);
		break;

	case Code::Instruction::JUMP:
		if (IsRegister (operand1) && operand1.register_ == Code::RLink) Emit (RET {});
		else if (IsAddress (operand1) && !fullAddressSpace) Emit (Instruction::B, operand1.address);
		else Branch (Instruction::BR, operand1);
		break;

	case Code::Instruction::TRAP:
		Emit (HLT {Immediate (operand1.size & 65535)});
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const Code::Operand& target, const Code::Operand& source)
{
	if (IsRegister (target)) Load (Select (target), source);
	else Store (Load (source), target);
}

void Context::Convert (const Code::Operand& target, const Code::Operand& source)
{
	if (target.type == source.type) return Move (target, source); const auto value = Load (source), result = Acquire (target);
	if (IsFloat (target)) Emit ({IsFloat (source) ? Instruction::FCVT : IsSigned (source) ? Instruction::SCVTF : Instruction::UCVTF, result, value});
	else if (IsFloat (source)) Emit ({Instruction::FCVTZS, result, value}), Extend (result, target.type);
	else if (target.type.size == 1) Emit ({IsSigned (target) ? Instruction::SXTB : Instruction::UXTB, result, Translate (value, target.type)});
	else if (target.type.size == 2) Emit ({IsSigned (target) ? Instruction::SXTH : Instruction::UXTH, result, Translate (value, target.type)});
	else if (target.type.size == 8 && source.type.size != 8 && IsSigned (source)) Emit (SXTW {result, value});
	else Move (result, Translate (value, target.type)); Store (result, target);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	const auto targetAddress = Acquire (generator.platform.pointer); Load (targetAddress, target);
	const auto sourceAddress = Acquire (generator.platform.pointer); Load (sourceAddress, source);
	const auto count = Acquire (generator.platform.pointer); Load (count, size);
	if (!IsImmediate (size)) Emit (CMP {count, Immediate {0}}), Branch (0, Instruction::BEQ);
	auto begin = CreateLabel (); begin (); const auto value = Acquire (generator.platform.integer);
	const Code::Unsigned element {IsImmediate (size) ? Extract (size) % 4 == 0 ? 4u : Extract (size) % 2 == 0 ? 2u : 1u : 1u};
	Emit ({GetLoadMnemonic (element), value, {GetRegister (sourceAddress), 0}, Immediate {element.size}});
	Emit ({GetStoreMnemonic (element), value, {GetRegister (targetAddress), 0}, Immediate {element.size}});
	Emit (SUBS {count, count, Immediate {element.size}}); Branch (begin, Instruction::BNE);
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto count = Acquire (generator.platform.pointer); Load (count, size);
	if (!IsImmediate (size)) Emit (CMP {count, Immediate {0}}), Branch (0, Instruction::BEQ);
	const auto targetAddress = Acquire (generator.platform.pointer); Load (targetAddress, target);
	const auto result = Load (value); auto begin = CreateLabel (); begin ();
	Emit ({GetStoreMnemonic (value.type), result, {GetRegister (targetAddress), 0}, Immediate (value.type.size)});
	Emit (SUBS {count, count, Immediate {1}}); Branch (begin, Instruction::BNE);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value)
{
	const auto result = Acquire (target); Emit ({mnemonic, result, Load (value)}); Store (result, target);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto value = Load (value1), result = Acquire (target); Emit ({mnemonic, result, value, Load (value2)}); Store (result, target);
}

void Context::Modulo (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto dividend = Load (value1), divisor = Load (value2), result = Acquire (target), temporary = Acquire (target.type);
	Emit ({IsSigned (target) ? Instruction::SDIV : Instruction::UDIV, result, dividend, divisor});
	Emit (MUL {temporary, result, divisor}); Emit (SUB {result, dividend, temporary}); Store (result, target);
}

void Context::Push (const Code::Operand& value)
{
	Emit ({GetStoreMnemonic (value.type), Load (value), {SP, -16, true}});
}

void Context::Pop (const Code::Operand& target)
{
	const auto result = Acquire (target); Emit ({GetLoadMnemonic (target.type), result, {SP, 0}, Immediate {16}}); Store (result, target);
}

void Context::Compare (const Code::Operand& value1, const Code::Operand& value2)
{
	const auto left = Load (value1); if (IsRegister (value1)) Extend (left, value1.type);
	if (IsFloat (value1)) return Emit (FCMP {left, Load (value2)});
	if (IsImmediate (value2) && TranslateBack (GetRegister (left)) != XZR && !IsNegative (value2) && IsValidUnsigned (Extract (value2))) return Emit (CMP {left, Extract (value2)});
	const auto right = Load (value2); if (IsRegister (value2)) Extend (right, value2.type); Emit (CMP {left, right});
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Code::Operand& target)
{
	Emit ({mnemonic, Load (target)});
}

void Context::Branch (const Code::Offset offset, const Instruction::Mnemonic mnemonic)
{
	Branch (GetLabel (offset), mnemonic);
}

void Context::Branch (const Label& label, const Instruction::Mnemonic mnemonic)
{
	AddFixup (label, mnemonic, 4);
	if (listing) listing << '\t' << mnemonic << '\t' << label << '\n';
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	Instruction {Instruction::Mnemonic (code), Immediate (target - bytes.begin ())}.Emit (bytes);
}

std::ostream& Context::WriteRegister (std::ostream& stream, const Code::Operand& operand, const Part)
{
	return stream << Translate (registers[operand.register_], operand.type);
}

bool Context::IsValidUnsigned (const Immediate immediate)
{
	return immediate >= 0 && immediate <= 4095;
}

bool Context::IsValidDisplacement (const Immediate immediate, const Code::Type& type)
{
	return immediate >= 0 && immediate <= 4095 << type.size - 1 && immediate % type.size == 0;
}

bool Context::IsRegister (const Code::Operand& operand)
{
	return Code::IsRegister (operand) && operand.register_ != Code::RSP;
}

A64::Register Context::Translate (const Operand& register_, const Code::Type& type)
{
	return Translate (TranslateBack (GetRegister (register_)), type);
}

A64::Register Context::Translate (const Register register_, const Code::Type& type)
{
	const auto base = type.model == Code::Type::Float ? type.size == 8 ? D0 : S0 : type.size == 8 ? X0 : W0;
	assert (base % 32 == 0); return Register (register_ - X0 + base);
}

A64::Register Context::TranslateBack (const Register register_)
{
	return Register (X0 + register_ % 32);
}

A64::Instruction::Mnemonic Context::GetLoadMnemonic (const Code::Type& type)
{
	if (type.size == 1) return type.model == Code::Type::Signed ? Instruction::LDRSB : Instruction::LDRB;
	if (type.size == 2) return type.model == Code::Type::Signed ? Instruction::LDRSH : Instruction::LDRH;
	return Instruction::LDR;
}

A64::Instruction::Mnemonic Context::GetStoreMnemonic (const Code::Type& type)
{
	if (type.size == 1) return Instruction::STRB;
	if (type.size == 2) return Instruction::STRH;
	return Instruction::STR;
}

SmartOperand::SmartOperand (Context& c, const A64::Register register_, const Code::Type& type) :
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

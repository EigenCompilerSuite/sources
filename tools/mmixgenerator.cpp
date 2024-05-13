// MMIX machine code generator
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
#include "ieee.hpp"
#include "mmix.hpp"
#include "mmixgenerator.hpp"

using namespace ECS;
using namespace MMIX;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const MMIX::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	const FullAddressSpace fullAddressSpace;

	bool acquired[256] {};
	Register registers[Code::Registers];

	Register Acquire ();
	void Acquire (Register);
	void Release (Register&);

	void Emit (const Instruction&);
	void Emit (Instruction::Mnemonic, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);
	void Emit (Instruction::Mnemonic, Register, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);

	void Truncate (Register, Register, const Code::Type&);
	void Displace (Register, Register, Instruction::Mnemonic, Code::Unsigned::Value);

	void Load (Register, Code::Unsigned::Value);
	void Load (Register, const Code::Section::Name&, Code::Displacement);

	Register Select (const Code::Operand&);
	void Load (Register, const Code::Operand&);
	void Store (Register, const Code::Operand&);
	void Access (Instruction::Mnemonic, Register, const Code::Operand&);

	void Branch (Instruction::Mnemonic, const Label&);
	void Move (const Code::Operand&, const Code::Operand&);
	void Convert (const Code::Operand&, const Code::Operand&);
	void Branch (Instruction::Mnemonic, Register, const Label&);
	void Convert (Register, Register, const Code::Type&, const Code::Type&);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Divide (const Code::Operand&, const Code::Operand&, const Code::Operand&, bool);
	void Operation (Instruction::Mnemonic, Register, const Code::Operand&, const Code::Operand&);
	void CompareAndBranch (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Label&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static Code::Unsigned::Value Extract (const Code::Operand&);
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c, const FullAddressSpace fas) :
	Assembly::Generator {d, sp, assembler, "mmix", "MMIX", {{4, 1, 8}, {8, 4, 8}, 8, 8, {0, 8, 8}, true}, false}, assembler {d, c}, fullAddressSpace {fas}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const MMIX::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}, fullAddressSpace {g.fullAddressSpace}
{
	for (auto& register_: registers) register_ = R255;
	Acquire (R254); Acquire (R255); Acquire (registers[Code::RSP] = R1); Acquire (registers[Code::RFP] = R2);
}

Register Context::Acquire ()
{
	auto register_ = R3; while (register_ != R255 && acquired[register_]) register_ = Register (register_ + 1);
	if (register_ == R255) throw RegisterShortage {}; Acquire (register_); return register_;
}

void Context::Acquire (const Register register_)
{
	assert (!acquired[register_]); acquired[register_] = true;
}

void Context::Release (Register& register_)
{
	assert (acquired[register_]); acquired[register_] = false; register_ = R255;
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction)); instruction.Emit (Reserve (4));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t', nullptr, address, displacement, scale) << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Register register_, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, register_, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << register_ << ", ", nullptr, address, displacement, scale) << '\n';
}

void Context::Truncate (const Register target, const Register source, const Code::Type& type)
{
	if (type.model == Code::Type::Float || type.size == 8) return;
	const Immediate bits = 64 - type.size * 8; Emit (SLU {target, source, bits});
	if (type.model == Code::Type::Signed) Emit (SR {target, target, bits}); else Emit (SRU {target, target, bits});
}

void Context::Displace (const Register target, const Register source, const Instruction::Mnemonic mnemonic, const Code::Unsigned::Value value)
{
	if (!value && source == target) return;
	if (value < 256) return Emit ({mnemonic, target, source, Immediate (value)});
	auto temporary = Acquire (); Load (temporary, value); Emit ({mnemonic, target, source, temporary}); Release (temporary);
}

void Context::Load (const Register register_, Code::Unsigned::Value value)
{
	auto set = false;
	if (value & 0xffff) Emit ({Instruction::SETL, register_, Immediate (value & 0xffff)}), set = true; value >>= 16;
	if (value & 0xffff) Emit ({set ? Instruction::ORML : Instruction::SETML, register_, Immediate (value & 0xffff)}), set = true; value >>= 16;
	if (value & 0xffff) Emit ({set ? Instruction::ORMH : Instruction::SETMH, register_, Immediate (value & 0xffff)}), set = true; value >>= 16;
	if (value & 0xffff) Emit ({set ? Instruction::ORH : Instruction::SETH, register_, Immediate (value & 0xffff)}), set = true; value >>= 16;
	if (!set) Emit ({Instruction::SETL, register_, Immediate (value)});
}

void Context::Load (const Register register_, const Code::Section::Name& address, const Code::Displacement displacement)
{
	Emit (Instruction::SETL, register_, address, displacement, 0);
	Emit (Instruction::ORML, register_, address, displacement, 16);
	if (!fullAddressSpace) return;
	Emit (Instruction::ORMH, register_, address, displacement, 32);
	Emit (Instruction::ORH, register_, address, displacement, 48);
}

Code::Unsigned::Value Context::Extract (const Code::Operand& operand)
{
	assert (IsImmediate (operand));
	switch (operand.type.model)
	{
	case Code::Type::Signed: return operand.simm;
	case Code::Type::Unsigned: return operand.uimm;
	case Code::Type::Float: return IEEE::DoublePrecision::Encode (operand.fimm);
	case Code::Type::Pointer: return operand.ptrimm;
	case Code::Type::Function: return operand.funimm;
	default: assert (Code::Type::Unreachable);
	}
}

Register Context::Select (const Code::Operand& operand)
{
	assert (IsRegister (operand)); return registers[operand.register_];
}

void Context::Load (const Register register_, const Code::Operand& operand)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		Load (register_, Extract (operand));
		break;

	case Code::Operand::Address:
		if (operand.register_ == Code::RVoid) Load (register_, operand.address, operand.displacement);
		else if (register_ != registers[operand.register_]) Load (register_, operand.address, operand.displacement), Emit (ADDU {register_, register_, registers[operand.register_]});
		else {auto temporary = Acquire (); Load (temporary, operand.address, operand.displacement); Emit (ADDU {register_, register_, temporary}); Release (temporary);}
		break;

	case Code::Operand::Register:
		if (register_ == registers[operand.register_] && !operand.displacement) break;
		if (operand.displacement < 0) Displace (register_, registers[operand.register_], Instruction::SUBU, -operand.displacement);
		else Displace (register_, registers[operand.register_], Instruction::ADDU, operand.displacement);
		break;

	case Code::Operand::Memory:
		switch (operand.type.size)
		{
		case 1: Access (IsSigned (operand) ? Instruction::LDB : Instruction::LDBU, register_, operand); break;
		case 2: Access (IsSigned (operand) ? Instruction::LDW : Instruction::LDWU, register_, operand); break;
		case 4: Access (IsSigned (operand) ? Instruction::LDT : IsFloat (operand) ? Instruction::LDSF : Instruction::LDTU, register_, operand); break;
		case 8: Access (IsSigned (operand) ? Instruction::LDO : Instruction::LDOU, register_, operand); break;
		default: assert (Code::Type::Unreachable);
		}
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Store (const Register register_, const Code::Operand& operand)
{
	switch (operand.model)
	{
	case Code::Operand::Register:
		if (register_ != registers[operand.register_]) Emit (OR {registers[operand.register_], register_, 0});
		break;

	case Code::Operand::Memory:
		switch (operand.type.size)
		{
		case 1: Access (IsSigned (operand) ? Instruction::STB : Instruction::STBU, register_, operand); break;
		case 2: Access (IsSigned (operand) ? Instruction::STW : Instruction::STWU, register_, operand); break;
		case 4: Access (IsSigned (operand) ? Instruction::STT : IsFloat (operand) ? Instruction::STSF : Instruction::STTU, register_, operand); break;
		case 8: Access (IsSigned (operand) ? Instruction::STO : Instruction::STOU, register_, operand); break;
		default: assert (Code::Type::Unreachable);
		}
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Access (const Instruction::Mnemonic mnemonic, const Register register_, const Code::Operand& operand)
{
	assert (IsMemory (operand));
	if (operand.address.empty () && operand.register_ != Code::RVoid && operand.displacement >= 0 && operand.displacement < 256)
		return Emit ({mnemonic, register_, registers[operand.register_], Immediate (operand.displacement)});
	auto base = Acquire ();
	if (!operand.address.empty ()) Load (base, operand.address, operand.displacement);
	else if (operand.register_ != Code::RVoid && operand.displacement > -256 && operand.displacement < 0) Emit (SUBU {base, registers[operand.register_], Immediate (-operand.displacement)});
	else if (operand.register_ != Code::RVoid && operand.displacement < 0) Load (base, -operand.displacement), Emit (SUBU {base, registers[operand.register_], base});
	else Load (base, operand.displacement);
	if (operand.register_ == Code::RVoid || operand.displacement <= 0 && operand.address.empty ()) Emit ({mnemonic, register_, base, 0});
	else Emit ({mnemonic, register_, base, registers[operand.register_]});
	Release (base);
}

void Context::Acquire (const Code::Register register_, const Types&)
{
	assert (registers[register_] == R255); if (register_ == Code::RRes) Acquire (registers[register_] = R0); else registers[register_] = Acquire ();
}

void Context::Release (const Code::Register register_)
{
	assert (registers[register_] != R255); Release (registers[register_]);
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
		if (IsFloat (operand1)) Operation (Instruction::FSUB, operand1, Code::Imm (operand1.type, 0), operand2);
		else Operation (Instruction::SUBU, operand1, Code::Imm (operand1.type, 0), operand2);
		break;

	case Code::Instruction::ADD:
		if (IsFloat (operand1)) Operation (Instruction::FADD, operand1, operand2, operand3);
		else Operation (Instruction::ADDU, operand1, operand2, operand3);
		break;

	case Code::Instruction::SUB:
		if (IsFloat (operand1)) Operation (Instruction::FSUB, operand1, operand2, operand3);
		else Operation (Instruction::SUBU, operand1, operand2, operand3);
		break;

	case Code::Instruction::MUL:
		if (IsFloat (operand1)) Operation (Instruction::FMUL, operand1, operand2, operand3);
		else if (IsSigned (operand1)) Operation (Instruction::MUL, operand1, operand2, operand3);
		else Operation (Instruction::MULU, operand1, operand2, operand3);
		break;

	case Code::Instruction::DIV:
		if (IsFloat (operand1)) Operation (Instruction::FDIV, operand1, operand2, operand3);
		else Divide (operand1, operand2, operand3, false);
		break;

	case Code::Instruction::MOD:
		Divide (operand1, operand2, operand3, true);
		break;

	case Code::Instruction::NOT:
		Operation (Instruction::NOR, operand1, operand2, Code::Imm (operand1.type, 0));
		break;

	case Code::Instruction::AND:
		Operation (Instruction::AND, operand1, operand2, operand3);
		break;

	case Code::Instruction::OR:
		Operation (Instruction::OR, operand1, operand2, operand3);
		break;

	case Code::Instruction::XOR:
		Operation (Instruction::XOR, operand1, operand2, operand3);
		break;

	case Code::Instruction::LSH:
		Operation (Instruction::SLU, operand1, operand2, operand3);
		break;

	case Code::Instruction::RSH:
		if (IsSigned (operand1)) Operation (Instruction::SR, operand1, operand2, operand3);
		else Operation (Instruction::SRU, operand1, operand2, operand3);
		break;

	case Code::Instruction::PUSH:
		if (operand1.Uses (Code::RSP)) Load (R255, operand1);
		Emit (SUBU {registers[Code::RSP], registers[Code::RSP], Immediate (generator.platform.GetStackAlignment (operand1.type))});
		if (operand1.Uses (Code::RSP)) Store (R255, Code::Mem {operand1.type, Code::RSP});
		else Move (Code::Mem {operand1.type, Code::RSP}, operand1);
		break;

	case Code::Instruction::POP:
		Move (operand1, Code::Mem {operand1.type, Code::RSP});
		Emit (ADDU {registers[Code::RSP], registers[Code::RSP], Immediate (generator.platform.GetStackAlignment (operand1.type))});
		break;

	case Code::Instruction::CALL:
		if (!IsRegister (operand1) && (!IsAddress (operand1) || fullAddressSpace)) Load (R254, operand1);
		Emit (GETA {R255, 16});
		Emit (SUBU {registers[Code::RSP], registers[Code::RSP], 8});
		Emit (STOU {R255, registers[Code::RSP], 0});
		if (IsRegister (operand1)) Emit (GO {R255, Select (operand1), 0});
		else if (IsAddress (operand1) && !fullAddressSpace) Emit (Instruction::JMP, operand1.address, operand1.displacement, 0);
		else Emit (GO {R255, R254, 0});
		Displace (registers[Code::RSP], registers[Code::RSP], Instruction::ADDU, operand2.size);
		break;

	case Code::Instruction::RET:
		Emit (LDOU {R255, registers[Code::RSP], 0});
		Emit (ADDU {registers[Code::RSP], registers[Code::RSP], 8});
		Emit (GO {R255, R255, 0});
		break;

	case Code::Instruction::ENTER:
		Emit (SUBU {registers[Code::RSP], registers[Code::RSP], 8});
		Emit (STOU {registers[Code::RFP], registers[Code::RSP], 0});
		Emit (OR {registers[Code::RFP], registers[Code::RSP], 0});
		Displace (registers[Code::RSP], registers[Code::RSP], Instruction::SUBU, operand1.size);
		break;

	case Code::Instruction::LEAVE:
		Emit (OR {registers[Code::RSP], registers[Code::RFP], 0});
		Emit (LDOU {registers[Code::RFP], registers[Code::RSP], 0});
		Emit (ADDU {registers[Code::RSP], registers[Code::RSP], 8});
		break;

	case Code::Instruction::BR:
		Branch (Instruction::JMP, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BREQ:
		CompareAndBranch (Instruction::BZ, operand2, operand3, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BRNE:
		CompareAndBranch (Instruction::BNZ, operand2, operand3, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BRLT:
		CompareAndBranch (Instruction::BN, operand2, operand3, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BRGE:
		CompareAndBranch (Instruction::BNN, operand2, operand3, GetLabel (operand1.offset));
		break;

	case Code::Instruction::JUMP:
		if (IsRegister (operand1)) Emit (GO {R255, Select (operand1), 0});
		else if (IsAddress (operand1) && !fullAddressSpace) Emit (Instruction::JMP, operand1.address, operand1.displacement, 0);
		else Load (R255, operand1), Emit (GO {R255, R255, 0});
		break;

	case Code::Instruction::TRAP:
		Emit (SETL {R255, 1});
		Emit (TRAP {0, 0, 0});
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const Code::Operand& target, const Code::Operand& source)
{
	if (IsRegister (target)) Load (Select (target), source);
	else if (IsRegister (source)) Store (Select (source), target);
	else Load (R255, source), Store (R255, target);
}

void Context::Convert (const Code::Operand& target, const Code::Operand& source)
{
	if (IsRegister (target))
		if (IsRegister (source)) Convert (Select (target), Select (source), target.type, source.type);
		else Load (R255, source), Convert (Select (target), R255, target.type, source.type);
	else if (IsRegister (source)) Convert (R255, Select (source), target.type, source.type), Store (R255, target);
	else Load (R255, source), Convert (R255, R255, target.type, source.type), Store (R255, target);
}

void Context::Convert (const Register target, const Register source, const Code::Type& targetType, const Code::Type& sourceType)
{
	if (targetType.model == Code::Type::Float)
		if (sourceType.model == Code::Type::Signed) Emit ({targetType.size == 4 ? Instruction::SFLOT : Instruction::FLOT, target, 1, source});
		else if (sourceType.model == Code::Type::Float) if (source != target) Emit (ORI {target, source, 0}); else;
		else Emit ({targetType.size == 4 ? Instruction::SFLOTU : Instruction::FLOTU, target, 1, source});
	else if (sourceType.model == Code::Type::Float)
		Emit (FIX {target, 1, source}), Truncate (target, target, targetType);
	else if (targetType.size != 8)
		Truncate (target, source, targetType);
	else if (target != source)
		Emit (ORI {target, source, 0});
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	if (IsZero (size)) return;
	auto targetReg = Acquire (), sourceReg = Acquire (), sizeReg = Acquire (), temporary = Acquire ();
	Load (sizeReg, size); if (!IsImmediate (size)) Branch (Instruction::BZ, sizeReg, GetLabel (0));
	Load (targetReg, target); Load (sourceReg, source); auto repeat = CreateLabel (); repeat ();
	Emit (LDBU {temporary, sourceReg, 0});
	Emit (STBU {temporary, targetReg, 0});
	Emit (ADDU {targetReg, targetReg, 1});
	Emit (ADDU {sourceReg, sourceReg, 1});
	Emit (SUBU {sizeReg, sizeReg, 1});
	Branch (Instruction::BNZ, sizeReg, repeat);
	Release (targetReg); Release (sourceReg); Release (temporary);
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	if (IsZero (size)) return;
	auto targetReg = Acquire (), sizeReg = Acquire (), valueReg = IsRegister (value) ? Select (value) : Acquire ();
	Load (sizeReg, size); if (!IsImmediate (size)) Branch (Instruction::BZ, sizeReg, GetLabel (0));
	Load (targetReg, target); if (!IsRegister (value)) Load (valueReg, value); auto repeat = CreateLabel (); repeat ();
	switch (value.type.size)
	{
	case 1: Emit ({IsSigned (value) ? Instruction::STB : Instruction::STBU, valueReg, targetReg, 0}); break;
	case 2: Emit ({IsSigned (value) ? Instruction::STW : Instruction::STWU, valueReg, targetReg, 0}); break;
	case 4: Emit ({IsSigned (value) ? Instruction::STT : IsFloat (value) ? Instruction::STSF : Instruction::STTU, valueReg, targetReg, 0}); break;
	case 8: Emit ({IsSigned (value) ? Instruction::STO : Instruction::STOU, valueReg, targetReg, 0}); break;
	default: assert (Code::Type::Unreachable);
	}
	Emit (ADDU {targetReg, targetReg, Immediate (value.type.size)});
	Emit (SUBU {sizeReg, sizeReg, 1});
	Branch (Instruction::BNZ, sizeReg, repeat);
	Release (targetReg); Release (sizeReg); if (!IsRegister (value)) Release (valueReg);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Register result, const Code::Operand& value1, const Code::Operand& value2)
{
	if (IsImmediate (value2) && !IsFloat (value2) && Extract (value2) < 256)
		if (IsRegister (value1)) Emit ({mnemonic, result, Select (value1), Immediate (Extract (value2))});
		else Load (R255, value1), Emit ({mnemonic, result, R255, Immediate (Extract (value2))});
	else if (IsRegister (value1))
		if (IsRegister (value2)) Emit ({mnemonic, result, Select (value1), Select (value2)});
		else Load (R255, value2), Emit ({mnemonic, result, Select (value1), R255});
	else if (IsRegister (value2))
		Load (R255, value1), Emit ({mnemonic, result, R255, Select (value2)});
	else
		Load (R254, value1), Load (R255, value2), Emit ({mnemonic, result, R254, R255});
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	if (IsRegister (target)) Operation (mnemonic, Select (target), value1, value2), Truncate (Select (target), Select (target), target.type);
	else Operation (mnemonic, R255, value1, value2), Truncate (R255, R255, target.type), Store (R255, target);
}

void Context::Divide (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const bool remainder)
{
	const auto result = IsRegister (target) ? Select (target) : R252; if (IsSigned (target)) Emit (SETL {R253, 1}); Load (R254, value1); Load (R255, value2);
	if (IsSigned (value1)) {auto skip = CreateLabel (); Emit (CMP {result, R254, 0}); Branch (Instruction::BNN, result, skip); Emit (NEG {R253, 0, R253}); Emit (NEG {R254, 0, R254}); skip ();}
	if (IsSigned (value2)) {auto skip = CreateLabel (); Emit (CMP {result, R255, 0}); Branch (Instruction::BNN, result, skip); if (!remainder) Emit (NEG {R253, 0, R253}); Emit (NEG {R255, 0, R255}); skip ();}
	Emit ({IsSigned (target) ? Instruction::DIV : Instruction::DIVU, result, R254, R255}); if (remainder) Emit (GET {result, Immediate (RR)}); if (IsSigned (target)) Emit (MUL {result, result, R253});
	if (!remainder) Truncate (result, result, target.type); Store (result, target);
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Label& label)
{
	AddFixup (label, mnemonic * 256, 4);
	if (listing) listing << '\t' << mnemonic << '\t' << label << '\n';
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Register register_, const Label& label)
{
	AddFixup (label, mnemonic * 256 + register_, 4);
	if (listing) listing << '\t' << mnemonic << '\t' << register_ << ", " << label << '\n';
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const auto register_ = Register (code % 256);
	const auto mnemonic = Instruction::Mnemonic (code / 256);
	const auto immediate = Immediate (target - bytes.begin ());
	if (mnemonic == Instruction::JMP) Instruction {mnemonic, immediate}.Emit (bytes);
	else Instruction {mnemonic, register_, immediate}.Emit (bytes);
}

std::ostream& Context::WriteRegister (std::ostream& stream, const Code::Operand& operand, const Part)
{
	return stream << registers[operand.register_];
}

void Context::CompareAndBranch (const Instruction::Mnemonic mnemonic, const Code::Operand& value1, const Code::Operand& value2, const Label& label)
{
	if (IsImmediate (value2) && !IsFloat (value2) && Extract (value2) == 0)
		if (IsRegister (value1)) return Branch (mnemonic, Select (value1), label);
		else return Load (R255, value1), Branch (mnemonic, R255, label);

	if (IsFloat (value1)) Operation (Instruction::FCMP, R255, value1, value2);
	else if (IsSigned (value1)) Operation (Instruction::CMP, R255, value1, value2);
	else Operation (Instruction::CMPU, R255, value1, value2);
	Branch (mnemonic, R255, label);
}

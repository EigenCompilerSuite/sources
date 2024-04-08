// MicroBlaze machine code generator
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
#include "mibl.hpp"
#include "miblgenerator.hpp"

using namespace ECS;
using namespace MicroBlaze;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const MicroBlaze::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	enum Index {Low, High};

	class SmartOperand;

	bool acquired[32] {};
	Register registers[2][Code::Registers];

	void Acquire (Register);
	void Release (Register);

	Register GetFree () const;
	Register Select (const Code::Operand&, Index) const;
	Immediate Extract (const Code::Operand&, Index) const;

	SmartOperand Acquire ();
	SmartOperand Load (const Code::Operand&, Index);
	SmartOperand Acquire (const Code::Operand&, Index);

	void Load (const Operand&, const Code::Operand&, Index);
	void Store (const Operand&, const Code::Operand&, Index);
	void Access (Instruction::Mnemonic, const Operand&, const Code::Operand&, Index);

	void Emit (const Instruction&);
	void Emit (Instruction::Mnemonic, const Operand&, const Operand&, Immediate);

	void Load (const Code::Section::Name&, Code::Displacement);
	void Load (Instruction::Mnemonic, const Operand&, const Operand&, const Code::Section::Name&, Code::Displacement);

	void Branch (Code::Offset);
	void Move (const Code::Operand&, const Code::Operand&, Index);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static bool IsComplex (const Code::Operand&);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (SmartOperand&&) noexcept;
	SmartOperand (Context&, MicroBlaze::Register);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c) :
	Assembly::Generator {d, sp, assembler, "mibl", "MicroBlaze", {{4, 1, 4}, {4, 4, 4}, 4, 4, {0, 4, 4}, true}, true}, assembler {d, c}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const MicroBlaze::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}
{
	for (auto& set: registers) for (auto& register_: set) register_ = R0;
	Acquire (R0); Acquire (R14); Acquire (R16); Acquire (registers[Low][Code::RSP] = R1); Acquire (registers[Low][Code::RFP] = R2); Acquire (registers[Low][Code::RLink] = R15);
}

void Context::Acquire (const Register register_)
{
	assert (!acquired[register_]); acquired[register_] = true;
}

void Context::Release (const Register register_)
{
	assert (acquired[register_]); acquired[register_] = false;
}

Register Context::GetFree () const
{
	auto register_ = R5; while (register_ != R31 && acquired[register_]) register_ = Register (register_ + 1);
	if (register_ == R31) throw RegisterShortage {}; return register_;
}

Immediate Context::Extract (const Code::Operand& operand, const Index index) const
{
	assert (IsImmediate (operand)); return Immediate (Code::Convert (operand) >> index * 32);
}

Register Context::Select (const Code::Operand& operand, const Index index) const
{
	assert (IsRegister (operand)); return registers[index][operand.register_];
}

SmartOperand Context::Acquire ()
{
	return {*this, GetFree ()};
}

SmartOperand Context::Load (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index);
	auto result = Acquire (); Load (result, operand, index); return result;
}

SmartOperand Context::Acquire (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index); return Acquire ();
}

void Context::Load (const Operand& register_, const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		Emit (Instruction::ADDI, register_, R0, Extract (operand, index));
		break;

	case Code::Operand::Address:
		Load (operand.address, operand.displacement);
		Load (Instruction::ADDI, register_, operand.register_ != Code::RVoid ? registers[Low][operand.register_] : R0, operand.address, operand.displacement);
		break;

	case Code::Operand::Register:
		if (GetRegister (register_) != registers[index][operand.register_] || operand.displacement)
			Emit (Instruction::ADDI, register_, registers[index][operand.register_], Immediate (operand.displacement));
		break;

	case Code::Operand::Memory:
		switch (operand.type.size)
		{
		case 1: Access (Instruction::LBUI, register_, operand, index); if (IsSigned (operand)) Emit (SEXT8 {register_, register_}); break;
		case 2: Access (Instruction::LHUI, register_, operand, index); if (IsSigned (operand)) Emit (SEXT16 {register_, register_}); break;
		case 4: case 8: Access (Instruction::LWI, register_, operand, index); break;
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
			Emit (Instruction::ADD, registers[index][operand.register_], register_, R0);
		break;

	case Code::Operand::Memory:
		switch (operand.type.size)
		{
		case 1: Access (Instruction::SBI, register_, operand, index); break;
		case 2: Access (Instruction::SHI, register_, operand, index); break;
		case 4: case 8: Access (Instruction::SWI, register_, operand, index); break;
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
	if (operand.address.empty ()) Emit (mnemonic, register_, operand.register_ != Code::RVoid ? registers[Low][operand.register_] : R0, Immediate (operand.displacement + index * 4));
	else Load (operand.address, operand.displacement + index * 4), Load (mnemonic, register_, operand.register_ != Code::RVoid ? registers[Low][operand.register_] : R0, operand.address, operand.displacement + index * 4);
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction)); instruction.Emit (Reserve (4));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand& register1, const Operand& register2, const Immediate immediate)
{
	if (immediate < -0x8000 || immediate > 0x7fff) Emit (IMM {immediate >> 16});
	Emit ({mnemonic, register1, register2, immediate << 16 >> 16});
}

void Context::Load (const Code::Section::Name& address, const Code::Displacement displacement)
{
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), 16};
	const IMM instruction {0}; instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << Instruction::IMM << '\t', nullptr, address, displacement, 16) << '\n';
}

void Context::Load (const Instruction::Mnemonic mnemonic, const Operand& register1, const Operand& register2, const Code::Section::Name& address, const Code::Displacement displacement)
{
	const Instruction instruction {mnemonic, register1, register2, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), 0};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << register1 << ", " << register2 << ", ", nullptr, address, displacement, 0) << '\n';
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	auto high = false;
	for (auto& type: types) if (type.size == 8) high = true;
	assert (!registers[Low][register_]); Acquire (registers[Low][register_] = (register_ == Code::RRes ? R3 : GetFree ()));
	assert (!registers[High][register_]); if (high) Acquire (registers[High][register_] = (register_ == Code::RRes ? R4 : GetFree ()));
}

void Context::Release (const Code::Register register_)
{
	assert (registers[Low][register_]); Release (registers[Low][register_]); registers[Low][register_] = R0;
	if (registers[High][register_]) Release (registers[High][register_]), registers[High][register_] = R0;
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
	case Code::Instruction::PUSH:
	case Code::Instruction::POP:
	case Code::Instruction::CALL:
	case Code::Instruction::BR:
	case Code::Instruction::JUMP:
	case Code::Instruction::TRAP:
		return true;

	default:
		return !IsFloat (instruction.operand1) && !IsFloat (instruction.operand2);
	}
}

void Context::Generate (const Code::Instruction& instruction)
{
	assert (IsSupported (instruction));

	auto& operand1 = instruction.operand1;
	auto& operand2 = instruction.operand2;

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
		Move (operand1, operand2, Low);
		if (IsComplex (operand1)) Move (operand1, operand2, High);
		break;

	case Code::Instruction::CONV:
	case Code::Instruction::COPY:
	case Code::Instruction::FILL:
	case Code::Instruction::NEG:
	case Code::Instruction::ADD:
	case Code::Instruction::SUB:
	case Code::Instruction::MUL:
	case Code::Instruction::DIV:
	case Code::Instruction::MOD:
	case Code::Instruction::NOT:
	case Code::Instruction::AND:
	case Code::Instruction::OR:
	case Code::Instruction::XOR:
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
		Branch (operand1.offset);
		break;

	case Code::Instruction::BREQ:
	case Code::Instruction::BRNE:
	case Code::Instruction::BRLT:
	case Code::Instruction::BRGE:
	case Code::Instruction::JUMP:
	case Code::Instruction::TRAP:
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const Code::Operand& target, const Code::Operand& value, const Index index)
{
	if (IsRegister (target)) return Load (Select (target, index), value, index);
	const auto result = Acquire (value, index); Load (result, value, index); Store (result, target, index);
}

void Context::Branch (const Code::Offset offset)
{
	const auto label = GetLabel (offset); AddFixup (label, Instruction::BRI << 5, 4);
	if (listing) listing << '\t' << Instruction::BRI << '\t' << label << '\n';
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const auto mnemonic = Instruction::Mnemonic (code >> 5); const auto offset = Immediate (target - bytes.begin ());
	(mnemonic == Instruction::BRI ? BRI {offset} : Instruction {mnemonic, Register (code % 32), offset}).Emit (bytes);
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

SmartOperand::SmartOperand (Context& c, const MicroBlaze::Register register_) :
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

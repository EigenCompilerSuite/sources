// RISC machine code generator
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
#include "risc.hpp"
#include "riscgenerator.hpp"

using namespace ECS;
using namespace RISC;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const RISC::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	enum Index {Low, High};

	class SmartOperand;

	bool acquired[16] {};
	Register registers[2][Code::Registers];

	void Acquire (Register);
	void Release (Register);

	Register GetFree () const;
	Register Select (const Code::Operand&, Index) const;
	Immediate Extract (const Code::Operand&, Index) const;

	SmartOperand Acquire ();
	SmartOperand Acquire (const Code::Type&, Index);
	SmartOperand Load (const Code::Operand&, Index);
	SmartOperand Acquire (const Code::Operand&, Index);
	SmartOperand ExtractShifted (const Code::Operand&, Index);

	void Load (const Operand&, const Code::Operand&, Index);
	void Store (const Operand&, const Code::Operand&, Index);
	void Access (void (Context::*) (const Operand&, const Operand&, Immediate, const Code::Type&), const Operand&, const Code::Operand&, Index);

	void Emit (const Instruction&);
	void Emit (Instruction::Mnemonic, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);
	void Emit (Instruction::Mnemonic, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);
	void Emit (Instruction::Mnemonic, const Operand&, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);

	void Truncate (const Operand&, const Operand&, const Code::Type&);
	void Load (const Operand&, const Operand&, Immediate, const Code::Type&);
	void Store (const Operand&, const Operand&, Immediate, const Code::Type&);

	void Move (const Operand&, Immediate);
	void Move (const Operand&, const Code::Section::Name&, Code::Displacement);

	void Branch (Instruction::Mnemonic, const Label&);
	void Branch (Instruction::Mnemonic, const Code::Operand&);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void Convert (const Code::Operand&, const Code::Operand&, Index);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void CompareAndBranch (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Label&);
	void Operation (Instruction::Mnemonic, const Operand&, const Code::Operand&, const Code::Operand&, Index);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void TruncatedOperation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);

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
	SmartOperand (Context&, RISC::Register);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c) :
	Assembly::Generator {d, sp, assembler, "risc", "RISC", {{4, 1, 4}, {4, 4, 4}, 4, 4, {0, 4, 4}, true}, true}, assembler {d, c}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const RISC::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}
{
	for (auto& set: registers) for (auto& register_: set) register_ = R15;
	Acquire (registers[Low][Code::RSP] = R14); Acquire (registers[Low][Code::RFP] = R13); Acquire (registers[Low][Code::RLink] = R15);
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
	auto register_ = R2; while (register_ != R15 && acquired[register_]) register_ = Register (register_ + 1);
	if (register_ == R15) throw RegisterShortage {}; return register_;
}

Register Context::Select (const Code::Operand& operand, const Index index) const
{
	assert (IsRegister (operand)); return registers[index][operand.register_];
}

Immediate Context::Extract (const Code::Operand& operand, const Index index) const
{
	assert (IsImmediate (operand));
	return IsSigned (operand) ? Immediate (operand.simm >> index * 32) : Immediate (Code::Convert (operand) >> index * 32);
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
		Move (register_, Extract (operand, index));
		break;

	case Code::Operand::Address:
		Move (register_, operand.address, operand.displacement);
		if (operand.register_ != Code::RVoid) Emit (ADD {register_, register_, registers[Low][operand.register_]});
		break;

	case Code::Operand::Register:
		if (GetRegister (register_) == registers[index][operand.register_]) break;
		if (operand.displacement > 0) Emit (ADD {register_, registers[Low][operand.register_], Immediate (operand.displacement)});
		else if (operand.displacement < 0) Emit (SUB {register_, registers[Low][operand.register_], -Immediate (operand.displacement)});
		else Emit (MOV {register_, registers[Low][operand.register_]});
		break;

	case Code::Operand::Memory:
		Access (&Context::Load, register_, operand, index);
		if (IsSigned (operand)) Truncate (register_, register_, operand.type);
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
		if (GetRegister (register_) == registers[index][operand.register_]) break;
		Emit (MOV {registers[Low][operand.register_], register_});
		break;

	case Code::Operand::Memory:
		Access (&Context::Store, register_, operand, index);
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Access (void (Context::*const access) (const Operand&, const Operand&, Immediate, const Code::Type&), const Operand& register_, const Code::Operand& operand, const Index index)
{
	assert (IsMemory (operand));

	if (operand.address.empty () && operand.register_ != Code::RVoid)
		return (this->*access) (register_, registers[Low][operand.register_], Immediate (operand.displacement + index * 4), operand.type);

	const auto base = Acquire ();
	if (operand.address.empty ()) Move (base, Immediate (operand.displacement));
	else Move (base, operand.address, operand.displacement + index * 4);
	if (operand.register_ != Code::RVoid) Emit (ADD {base, base, registers[Low][operand.register_]});
	(this->*access) (register_, base, 0, operand.type);
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

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand& target, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, target, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << target << ", ", nullptr, address, displacement, scale) << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand& target, const Operand& operand, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, target, operand, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << target << ", " << operand << ", ", nullptr, address, displacement, scale) << '\n';
}

void Context::Truncate (const Operand& target, const Operand& source, const Code::Type& type)
{
	if (type.size >= 4) return;
	if (type.model != Code::Type::Signed) Emit (AND {target, source, Immediate (1 << type.size * 8) - 1});
	else Emit (LSL {target, source, Immediate (32 - type.size * 8)}), Emit (ASR {target, target, Immediate (32 - type.size * 8)});
}

void Context::Move (const Operand& register_, const Immediate value)
{
	if (value > -0x10000 && value < 0x10000) return Emit (MOV {register_, value});
	Emit (MVS {register_, value >> 16 & 0xffff});
	if (value & 0xffff) Emit (IOR {register_, register_, value & 0xffff});
}

void Context::Move (const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement)
{
	Emit (Instruction::MVS, register_, address, displacement, 16);
	Emit (Instruction::IOR, register_, register_, address, displacement, 0);
}

void Context::Load (const Operand& register_, const Operand& base, const Immediate offset, const Code::Type& type)
{
	if (type.size >= 4) return Emit (LD {register_, base, offset});
	if (type.size == 1) return Emit (LDB {register_, base, offset});
	Emit (LDB {register_, base, offset + 1}); Emit (LSL {register_, register_, 8});
	const auto temporary = Acquire (); Emit (LDB {temporary, base, offset}); Emit (IOR {register_, register_, temporary});
}

void Context::Store (const Operand& register_, const Operand& base, const Immediate offset, const Code::Type& type)
{
	if (type.size >= 4) return Emit (ST {register_, base, offset});
	if (type.size == 1) return Emit (STB {register_, base, offset});
	Emit (ROR {register_, register_, 8}); Emit (STB {register_, base, offset + 1});
	Emit (ROR {register_, register_, 24}); Emit (STB {register_, base, offset});
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	assert (registers[Low][register_] == R15); assert (registers[High][register_] == R15);
	Acquire (registers[Low][register_] = (register_ == Code::RRes ? R0 : GetFree ()));
	if (std::find_if (types.begin (), types.end (), [] (const Code::Type& type) {return type.size == 8;}) != types.end ())
		Acquire (registers[High][register_] = (register_ == Code::RRes ? R1 : GetFree ()));
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
		return !IsFloat (instruction.operand1) && !IsFloat (instruction.operand2);

	case Code::Instruction::NEG:
	case Code::Instruction::ADD:
	case Code::Instruction::SUB:
	case Code::Instruction::MUL:
	case Code::Instruction::DIV:
	case Code::Instruction::MOD:
	case Code::Instruction::LSH:
	case Code::Instruction::RSH:
	case Code::Instruction::BREQ:
	case Code::Instruction::BRNE:
	case Code::Instruction::BRLT:
	case Code::Instruction::BRGE:
		return !IsComplex (instruction.operand2);

	case Code::Instruction::TRAP:
		return false;

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
		TruncatedOperation (IsFloat (operand1) ? Instruction::FSB : Instruction::SUB, operand1, Code::Imm (operand1.type, 0), operand2, Low);
		break;

	case Code::Instruction::ADD:
		TruncatedOperation (IsFloat (operand1) ? Instruction::FAD : Instruction::ADD, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::SUB:
		TruncatedOperation (IsFloat (operand1) ? Instruction::FSB : Instruction::SUB, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MUL:
		TruncatedOperation (IsFloat (operand1) ? Instruction::FML : IsSigned (operand1) ? Instruction::MUL : Instruction::MLU, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::DIV:
		Operation (IsFloat (operand1) ? Instruction::FDV : Instruction::DIV, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MOD:
		Operation (Instruction::DIV, Operand {R15}, operand2, operand3, Low);
		if (IsRegister (operand1)) Emit (MVH {Select (operand1, Low)});
		else Emit (MVH {R15}), Store (R15, operand1, Low);
		break;

	case Code::Instruction::NOT:
		Operation (Instruction::XOR, operand1, operand2, Code::Imm (operand1.type, -1), Low);
		if (IsComplex (operand1)) Operation (Instruction::XOR, operand1, operand2, Code::Imm (operand1.type, -1), High);
		break;

	case Code::Instruction::AND:
		Operation (Instruction::AND, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::AND, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::OR:
		Operation (Instruction::IOR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::IOR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::XOR:
		Operation (Instruction::XOR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::XOR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::LSH:
		TruncatedOperation (Instruction::LSL, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::RSH:
		Operation (Instruction::ASR, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::PUSH:
		if (!IsComplex (operand1)) Emit (ST {Load (operand1, Low), R14, -4}), Emit (SUB {R14, R14, 4});
		else Emit (ST {Load (operand1, Low), R14, -8}), Emit (ST {Load (operand1, High), R14, -4}), Emit (SUB {R14, R14, 8});
		break;

	case Code::Instruction::POP:
	{
		const auto result = Acquire (operand1, Low);
		Emit (ADD {R14, R14, 4}), Emit (LD {result, R14, -4});
		Store (result, operand1, Low);
		break;
	}

	case Code::Instruction::CALL:
		if (!IsAddress (operand1)) Branch (Instruction::BL, operand1);
		else Emit (Instruction::BL, operand1.address, operand1.displacement, 0);
		if (operand2.size) Emit (ADD {R14, R14, Immediate (operand2.size)});
		break;

	case Code::Instruction::RET:
		Emit (LD {R15, R14, 0});
		Emit (ADD {R14, R14, 4});
		Emit (B {R15});
		break;

	case Code::Instruction::ENTER:
		Emit (ST {R13, R14, -4});
		Emit (SUB {R13, R14, 4});
		Emit (SUB {R14, R14, Immediate (4 + operand1.size)});
		break;

	case Code::Instruction::LEAVE:
		Emit (ADD {R14, R13, 4});
		Emit (LD {R13, R14, -4});
		break;

	case Code::Instruction::BR:
		Branch (Instruction::B, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BREQ:
		CompareAndBranch (Instruction::BEQ, operand2, operand3, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BRNE:
		CompareAndBranch (Instruction::BNE, operand2, operand3, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BRLT:
		CompareAndBranch (IsSigned (operand2) || IsFloat (operand2) ? Instruction::BLT : Instruction::BCS, operand2, operand3, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BRGE:
		CompareAndBranch (IsSigned (operand2) || IsFloat (operand2) ? Instruction::BGE : Instruction::BCC, operand2, operand3, GetLabel (operand1.offset));
		break;

	case Code::Instruction::JUMP:
		if (!IsAddress (operand1)) Branch (Instruction::B, operand1);
		else Emit (Instruction::B, operand1.address, operand1.displacement, 0);
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
	if (target.type.size == source.type.size) Move (target, source, index);
	else if (index && !IsComplex (source)) Emit (ASR {Acquire (target, High), Acquire (target, Low), 31});
	else if (target.type.size < 4 && IsRegister (target)) Truncate (Acquire (target, Low), Load (source, Low), target.type), Store (Acquire (target, Low), target, Low);
	else Move (target, source, index);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	const auto sourceAddress = Acquire (); Load (sourceAddress, source, Low);
	const auto targetAddress = Acquire (); Load (targetAddress, target, Low);
	const auto count = Acquire (); Load (count, size, Low);
	if (!IsImmediate (size)) Emit (SUB {R15, count, 0}), Branch (Instruction::BEQ, GetLabel (0));
	auto begin = CreateLabel (); begin (); Emit (LDB {R15, sourceAddress, 0}); Emit (STB {R15, targetAddress, 0});
	Emit (ADD {sourceAddress, sourceAddress, 1}); Emit (ADD {targetAddress, targetAddress, 1});
	Emit (SUB {count, count, 1}); Branch (Instruction::BNE, begin);
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto count = Acquire (); Load (count, size, Low);
	if (!IsImmediate (size)) Emit (SUB {R15, count, 0}), Branch (Instruction::BEQ, GetLabel (0));
	const auto targetAddress = Acquire (); Load (targetAddress, target, Low);
	const auto low = Acquire (), high = Acquire (); Load (low, value, Low); if (IsComplex (value)) Load (high, value, High);
	auto begin = CreateLabel (); begin (); Store (low, targetAddress, 0, value.type);
	if (IsComplex (value)) Store (high, targetAddress, 4, value.type);
	Emit (ADD {targetAddress, targetAddress, Immediate (value.type.size)});
	Emit (SUB {count, count, 1}); Branch (Instruction::BNE, begin);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto value = !IsFloat (value2) && IsImmediate (value2) && Extract (value2, index) > -0x10000 && Extract (value2, index) < 0x10000 ? Extract (value2, index) : Load (value2, index);
	Emit ({mnemonic, target, Load (value1, index), value});
	if (mnemonic == Instruction::ASR && !IsSigned (value1)) Emit (LSL {target, target, value}), Emit (ROR {target, target, value});
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto result = Acquire (target, index); Operation (mnemonic, result, value1, value2, index); Store (result, target, index);
}

void Context::TruncatedOperation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto result = Acquire (target, index);
	Operation (mnemonic, result, value1, value2, index);
	Truncate (result, result, target.type); Store (result, target, index);
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Code::Operand& target)
{
	Emit ({mnemonic, Load (target, Low)});
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Label& label)
{
	AddFixup (label, mnemonic, 4);
	if (listing) listing << '\t' << mnemonic << '\t' << label << '\n';
}

void Context::CompareAndBranch (Instruction::Mnemonic mnemonic, const Code::Operand& value1, const Code::Operand& value2, const Label& label)
{
	Operation (IsFloat (value1) ? Instruction::FSB : Instruction::SUB, Operand {R15}, value1, value2, Low); Branch (mnemonic, label);
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	Instruction (Instruction::Mnemonic (code), Immediate (target - bytes.end ())).Emit (bytes);
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

SmartOperand::SmartOperand (Context& c, const RISC::Register register_) :
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

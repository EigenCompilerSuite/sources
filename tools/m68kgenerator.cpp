// M68000 machine code generator
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
#include "m68k.hpp"
#include "m68kgenerator.hpp"

using namespace ECS;
using namespace M68K;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const M68K::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	enum Index {Low, High, Address, Data = Low};

	class SmartOperand;

	bool acquired[16] {};
	Register registers[3][Code::Registers];

	void Acquire (Register);
	void Release (Register);

	Register GetFree (Index) const;
	Register Select (const Code::Operand&, Index) const;
	Immediate Extract (const Code::Operand&, Index) const;

	SmartOperand Acquire (Index);
	SmartOperand GetAddress (const Code::Operand&);
	SmartOperand Load (const Code::Operand&, Index);
	SmartOperand Reuse (const Code::Operand&, Index);
	SmartOperand Access (const Code::Operand&, Index);

	void Load (const SmartOperand&, const Code::Operand&, Index);
	void Store (const SmartOperand&, const Code::Operand&, Index);

	void Emit (const Instruction&);
	void Emit (Instruction::Mnemonic, Operand::Size, const SmartOperand&, const SmartOperand&);

	void Pop (const Code::Operand&, Index);
	void Push (const Code::Operand&, Index);
	void Branch (Code::Offset, Instruction::Mnemonic);
	void Branch (const Label&, Instruction::Mnemonic);
	void Jump (Instruction::Mnemonic, const Code::Operand&);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void Convert (const Code::Operand&, const Code::Operand&, Index);
	void Copy (const Code::Operand&, const Code::Operand&, Immediate);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Multiply (const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, Index);
	void Divide (const Code::Operand&, const Code::Operand&, const Code::Operand&, Index, bool);
	void Shift (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void CompareAndBranch (Code::Offset, const Code::Operand&, const Code::Operand&, Instruction::Mnemonic, Index);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void OperationAddress (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void OperationX (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void Operation (Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void OperationAddress (Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static bool IsFixup (const Code::Operand&);
	static bool IsComplex (const Code::Operand&);
	static Operand::Size GetSize (const Code::Operand&);
	static void Write (std::ostream&, const SmartOperand&);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (const Operand&);
	SmartOperand (SmartOperand&&) noexcept;
	~SmartOperand ();

private:
	Context* context = nullptr;
	Code::Section::Name address;
	Code::Displacement displacement;

	SmartOperand (Context&, const Operand&);
	SmartOperand (const Code::Section::Name&, Code::Displacement);

	friend SmartOperand Context::Acquire (Index);
	friend SmartOperand Context::GetAddress (const Code::Operand&);
	friend void Context::Write (std::ostream&, const SmartOperand&);
	friend SmartOperand Context::Load (const Code::Operand&, Index);
	friend SmartOperand Context::Access (const Code::Operand&, Index);
	friend void Context::Emit (Instruction::Mnemonic, Operand::Size, const SmartOperand&, const SmartOperand&);
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c) :
	Assembly::Generator {d, sp, assembler, "m68k", "M68000", {{2, 1, 2}, {4, 2, 2}, {4, 2}, {4, 2}, {0, 2, 2}, true}, false}, assembler {d, c}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const M68K::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}
{
	for (auto& set: registers) for (auto& register_: set) register_ = SR;
	Acquire (registers[Address][Code::RSP] = A7); Acquire (registers[Address][Code::RFP] = A6);
}

void Context::Acquire (const Register register_)
{
	assert (register_ >= D0 && register_ <= A7);
	assert (!acquired[register_ - D0]); acquired[register_ - D0] = true;
}

void Context::Release (const Register register_)
{
	assert (register_ >= D0 && register_ <= A7);
	assert (acquired[register_ - D0]); acquired[register_ - D0] = false;
}

Register Context::GetFree (const Index index) const
{
	auto register_ = index == Address ? A1 : D2, sentinel = index == Address ? A5 : A0;
	while (register_ != sentinel && acquired[register_ - D0]) register_ = Register (register_ + 1);
	if (register_ == sentinel) throw RegisterShortage {}; return register_;
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

SmartOperand Context::Reuse (const Code::Operand& operand, const Index index)
{
	return IsRegister (operand) ? Select (operand, index) : Load (operand, index);
}

SmartOperand Context::Load (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand) && IsLastUseOf (operand.register_)) return Select (operand, index);
	auto source = Access (operand, index); if (!IsImmediate (operand) && !IsRegister (operand) && !IsMemory (operand)) return source;
	auto result = source.context ? GetRegister (source) : SmartOperand {*this, GetFree (index)};
	Emit (IsAddress (operand.type) ? Instruction::MOVEA : Instruction::MOVE, GetSize (operand), source, result); return result;
}

void Context::Load (const SmartOperand& register_, const Code::Operand& operand, const Index index)
{
	Emit (IsAddress (operand.type) ? Instruction::MOVEA : Instruction::MOVE, GetSize (operand), Access (operand, index), register_);
}

void Context::Store (const SmartOperand& register_, const Code::Operand& operand, const Index index)
{
	Emit (IsAddress (operand.type) && IsRegister (operand) ? Instruction::MOVEA : Instruction::MOVE, GetSize (operand), register_, Access (operand, index));
}

SmartOperand Context::Access (const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		return Extract (operand, index);

	case Code::Operand::Register:
		if (!operand.displacement) return Select (operand, index);
		if (IsLastUseOf (operand.register_)) return Emit (Instruction::LEA, Operand::None, GetAddress (operand), registers[Address][operand.register_]), registers[Address][operand.register_];

	case Code::Operand::Address:
	{
		assert (index == Address); SmartOperand result {*this, GetFree (Address)};
		Emit (Instruction::LEA, Operand::None, GetAddress (operand), result); return result;
	}

	case Code::Operand::Memory:
	{
		if (operand.address.empty ())
			if (operand.register_ == Code::RVoid) return {Immediate (operand.displacement + index * 4 % 8), Operand::Long};
			else return {Immediate (operand.displacement + index * 4 % 8), registers[Address][operand.register_]};
		if (operand.register_ == Code::RVoid) return {operand.address, operand.displacement + index * 4 % 8};
		SmartOperand result {*this, {0, GetFree (Address), registers[Address][operand.register_], Operand::Long}};
		Emit (Instruction::LEA, Operand::None, {operand.address, operand.displacement}, GetRegister (result));
		return result;
	}

	default:
		assert (Code::Operand::Unreachable);
	}
}

SmartOperand Context::GetAddress (const Code::Operand& operand)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		return {Extract (operand, Address), Operand::Long};

	case Code::Operand::Register:
		return {Immediate (operand.displacement), registers[Address][operand.register_]};

	case Code::Operand::Address:
	{
		if (operand.register_ == Code::RVoid) return {operand.address, operand.displacement};
		SmartOperand result {*this, {0, GetFree (Address), registers[Address][operand.register_], Operand::Long}};
		Emit (Instruction::LEA, Operand::None, {operand.address, operand.displacement}, GetRegister (result));
		return result;
	}

	case Code::Operand::Memory:
	{
		SmartOperand result {*this, {0, GetFree (Address)}};
		Emit (Instruction::MOVEA, Operand::Long, Access (operand, Address), GetRegister (result));
		return result;
	}

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Emit (const Instruction& instruction)
{
	auto optimized = Optimize (instruction);
	if (!IsValid (optimized)) return;
	optimized.Emit (Reserve (M68K::GetSize (optimized)));
	if (listing) listing << '\t' << optimized << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand::Size size, const SmartOperand& operand1, const SmartOperand& operand2)
{
	const Instruction instruction {mnemonic, size, operand1, operand2};
	if (operand1.address.empty () && operand2.address.empty ()) return Emit (instruction);
	assert (IsValid (instruction)); assert (operand1.address.empty () || operand2.address.empty ());
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (!operand1.address.empty () ? operand1.displacement : operand2.displacement), 0};
	instruction.Adjust (patch); AddLink (!operand1.address.empty () ? operand1.address : operand2.address, patch);
	instruction.Emit (Reserve (M68K::GetSize (instruction))); if (!listing) return; listing << '\t' << mnemonic; if (size) listing << size;
	Write (listing << '\t', operand1); if (!IsEmpty (operand2)) Write (listing << ", ", operand2); listing << '\n';
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	static const Register res[] {D0, D1, A0}; bool acquire[3] {};
	for (auto& type: types) if (IsAddress (type)) acquire[Address] = true; else if (type.size == 8) acquire[Low] = true, acquire[High] = true; else acquire[Data] = true;
	for (auto& set: registers) if (assert (set[register_] == SR), acquire[&set - registers]) Acquire (set[register_] = (register_ == Code::RRes ? res[&set - registers] : GetFree (Index (&set - registers))));
}

void Context::Release (const Code::Register register_)
{
	for (auto& set: registers) if (set[register_] != SR) Release (set[register_]), set[register_] = SR;
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	auto& operand1 = instruction.operand1;
	auto& operand2 = instruction.operand2;
	auto& operand3 = instruction.operand3;

	switch (instruction.mnemonic)
	{
	case Code::Instruction::CONV:
		return !IsComplex (operand1) && !IsFloat (operand1) && !IsComplex (operand2) && !IsFloat (operand2);

	case Code::Instruction::NEG:
	case Code::Instruction::ADD:
	case Code::Instruction::SUB:
	case Code::Instruction::BRLT:
	case Code::Instruction::BRGE:
		return !IsFloat (operand2);

	case Code::Instruction::MUL:
		if (operand1.type.size == 4 && !IsFloat (operand1))
			return IsImmediate (operand2) && IsPowerOfTwo (Extract (operand2, Data)) || IsImmediate (operand3) && IsPowerOfTwo (Extract (operand3, Data));
		return operand1.type.size < 4 && !IsFloat (operand1);

	case Code::Instruction::DIV:
	case Code::Instruction::MOD:
		if (operand1.type.size == 4 && !IsFloat (operand1))
			return IsImmediate (operand3) && IsPowerOfTwo (Extract (operand3, Data));
		return operand1.type.size < 4 && !IsFloat (operand1);

	case Code::Instruction::LSH:
	case Code::Instruction::RSH:
		return !IsComplex (operand2) && !IsFloat (operand2);

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
		if (IsAddress (operand1.type)) Move (operand1, operand2, Address);
		else if (IsComplex (operand1)) Move (operand1, operand2, Low), Move (operand1, operand2, High);
		else Move (operand1, operand2, Data);
		break;

	case Code::Instruction::CONV:
		if (IsAddress (operand1.type)) Convert (operand1, operand2, Address);
		else Convert (operand1, operand2, Data);
		break;

	case Code::Instruction::COPY:
		Copy (operand1, operand2, operand3);
		break;

	case Code::Instruction::FILL:
		Fill (operand1, operand2, operand3);
		break;

	case Code::Instruction::NEG:
		if (IsComplex (operand1)) Operation (Instruction::NEG, operand1, operand2, Low), Operation (Instruction::NEGX, operand1, operand2, High);
		else Operation (Instruction::NEG, operand1, operand2, Data);
		break;

	case Code::Instruction::ADD:
		if (IsAddress (operand1.type)) Operation (Instruction::ADDA, operand1, operand2, operand3, Address);
		else if (IsComplex (operand1)) Operation (Instruction::ADD, Instruction::ADDI, operand1, operand2, operand3, Low), OperationX (Instruction::ADDX, operand1, operand2, operand3, High);
		else Operation (Instruction::ADD, Instruction::ADDI, operand1, operand2, operand3, Data);
		break;

	case Code::Instruction::SUB:
		if (IsAddress (operand1.type)) Operation (Instruction::SUBA, operand1, operand2, operand3, Address);
		else if (IsComplex (operand1)) Operation (Instruction::SUB, Instruction::SUBI, operand1, operand2, operand3, Low), OperationX (Instruction::SUBX, operand1, operand2, operand3, High);
		else Operation (Instruction::SUB, Instruction::SUBI, operand1, operand2, operand3, Data);
		break;

	case Code::Instruction::MUL:
		if (IsAddress (operand1.type)) Multiply (operand1, operand2, operand3, Address);
		else Multiply (operand1, operand2, operand3, Data);
		break;

	case Code::Instruction::DIV:
		if (IsAddress (operand1.type)) Divide (operand1, operand2, operand3, Address, false);
		else Divide (operand1, operand2, operand3, Data, false);
		break;

	case Code::Instruction::MOD:
		if (IsAddress (operand1.type)) Divide (operand1, operand2, operand3, Address, true);
		else Divide (operand1, operand2, operand3, Data, true);
		break;

	case Code::Instruction::NOT:
		if (IsComplex (operand1)) Operation (Instruction::NOT, operand1, operand2, Low), Operation (Instruction::NOT, operand1, operand2, High);
		else Operation (Instruction::NOT, operand1, operand2, Data);
		break;

	case Code::Instruction::AND:
		if (IsAddress (operand1.type)) OperationAddress (Instruction::AND, Instruction::ANDI, operand1, operand2, operand3);
		else if (IsComplex (operand1)) Operation (Instruction::AND, Instruction::ANDI, operand1, operand2, operand3, Low), Operation (Instruction::AND, Instruction::ANDI, operand1, operand2, operand3, High);
		else Operation (Instruction::AND, Instruction::ANDI, operand1, operand2, operand3, Data);
		break;

	case Code::Instruction::OR:
		if (IsComplex (operand1)) Operation (Instruction::OR, Instruction::ORI, operand1, operand2, operand3, Low), Operation (Instruction::OR, Instruction::ORI, operand1, operand2, operand3, High);
		else Operation (Instruction::OR, Instruction::ORI, operand1, operand2, operand3, Data);
		break;

	case Code::Instruction::XOR:
		if (IsComplex (operand1)) Operation (Instruction::EOR, Instruction::EORI, operand1, operand2, operand3, Low), Operation (Instruction::EOR, Instruction::EORI, operand1, operand2, operand3, High);
		else Operation (Instruction::EOR, Instruction::EORI, operand1, operand2, operand3, Data);
		break;

	case Code::Instruction::LSH:
		Shift (IsSigned (operand1) ? Instruction::ASL : Instruction::LSL, operand1, operand2, operand3, Data);
		break;

	case Code::Instruction::RSH:
		Shift (IsSigned (operand1) ? Instruction::ASR : Instruction::LSR, operand1, operand2, operand3, Data);
		break;

	case Code::Instruction::PUSH:
		if (IsAddress (operand1.type)) Push (operand1, Address);
		else if (IsComplex (operand1)) Push (operand1, High), Push (operand1, Low);
		else Push (operand1, Data);
		break;

	case Code::Instruction::POP:
		if (IsAddress (operand1.type)) Pop (operand1, Address);
		else if (IsComplex (operand1)) Pop (operand1, Low), Pop (operand1, High);
		else Pop (operand1, Data);
		break;

	case Code::Instruction::CALL:
		Jump (Instruction::JSR, operand1);
		if (operand2.size > 8) Emit (LEA {{Immediate (operand2.size), SP}, SP});
		else if (operand2.size > 0) Emit (ADDQ {Operand::Long, Immediate (operand2.size), SP});
		break;

	case Code::Instruction::RET:
		Emit (RTS {});
		break;

	case Code::Instruction::ENTER:
		Emit (LINK {registers[Address][Code::RFP], -Immediate (operand1.size)});
		break;

	case Code::Instruction::LEAVE:
		Emit (UNLK {registers[Address][Code::RFP]});
		break;

	case Code::Instruction::BR:
		Branch (operand1.offset, Instruction::BRA);
		break;

	case Code::Instruction::BREQ:
		if (IsAddress (operand2.type)) CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BEQ, Address);
		else if (IsComplex (operand2)) CompareAndBranch (0, operand2, operand3, Instruction::BNE, High), CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BEQ, Low);
		else CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BEQ, Data);
		break;

	case Code::Instruction::BRNE:
		if (IsAddress (operand2.type)) CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BNE, Address);
		else if (IsComplex (operand2)) CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BNE, High), CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BNE, Low);
		else CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BNE, Data);
		break;

	case Code::Instruction::BRLT:
		if (IsAddress (operand2.type)) CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BLO, Address);
		else if (IsComplex (operand2)) CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) ? Instruction::BLT : Instruction::BLO, High),
			Branch (0, IsSigned (operand2) ? Instruction::BGT : Instruction::BHI), CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) ? Instruction::BLT : Instruction::BLO, Low);
		else CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) ? Instruction::BLT : Instruction::BLO, Data);
		break;

	case Code::Instruction::BRGE:
		if (IsAddress (operand2.type)) CompareAndBranch (operand1.offset, operand2, operand3, Instruction::BHS, Address);
		else if (IsComplex (operand2)) CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) ? Instruction::BGT : Instruction::BHI, High),
			Branch (0, IsSigned (operand2) ? Instruction::BLT : Instruction::BLO), CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) ? Instruction::BGE : Instruction::BHS, Low);
		else CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) ? Instruction::BGE : Instruction::BHS, Data);
		break;

	case Code::Instruction::JUMP:
		Jump (Instruction::JMP, operand1);
		break;

	case Code::Instruction::TRAP:
		Emit (ILLEGAL {});
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const Code::Operand& target, const Code::Operand& source, const Index index)
{
	if (IsRegister (target) && IsAddress (target.type))
		if (IsMemory (source)) return Emit (Instruction::MOVEA, Operand::Long, Access (source, index), Select (target, index));
		else return Emit (Instruction::LEA, Operand::None, GetAddress (source), Select (target, index));
	const auto sourceOperand = IsFixup (target) && IsFixup (source) ? Reuse (source, index) : Access (source, index);
	Emit (Instruction::MOVE, GetSize (target), sourceOperand, Access (target, index));
}

void Context::Convert (const Code::Operand& target, const Code::Operand& source, const Index index)
{
	const auto sourceSize = GetSize (source), targetSize = GetSize (target);
	const auto register_ = IsRegister (target) && !IsAddress (target.type) ? Select (target, index) : Acquire (Data);
	if (!IsSigned (target) && sourceSize < targetSize && sourceSize < Operand::Long) Emit (CLR {targetSize, register_});
	Emit (Instruction::MOVE, GetSize (source), Access (source, IsAddress (source.type) ? Address : Low), register_);
	if (IsSigned (target) && sourceSize < targetSize)
		if (targetSize == Operand::Word || sourceSize == Operand::Word) Emit (EXT {targetSize, register_});
		else if (targetSize == Operand::Long) Emit (EXT {Operand::Word, register_}), Emit (EXT {targetSize, register_});
	if (!IsRegister (target) || IsAddress (target.type)) Store (register_, target, index);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	if (IsImmediate (size) && size.ptrimm <= (size.ptrimm % 2 ? 8 : 32)) return Copy (target, source, Extract (size, Address));
	const auto sizeOperand = Load (size, Address); auto loop = CreateLabel ();
	Emit (CMPA {Operand::Long, 0, sizeOperand}); Branch (GetLabel (0), Instruction::BEQ);
	const auto sourceOperand = Load (source, Address), targetOperand = Load (target, Address); loop ();
	Emit (MOVE {Operand::Byte, +sourceOperand[0], +targetOperand[0]}); Emit (SUBQ {Operand::Long, 1, sizeOperand});
	Branch (loop, Instruction::BNE);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, Immediate size)
{
	if (!size) return;
	const auto sourceOperand = size > 4 ? Load (source, Address) : Reuse (source, Address);
	const auto targetOperand = size > 4 ? Load (target, Address) : Reuse (target, Address);
	if (size % 2) while (size > 1) Emit (MOVE {Operand::Byte, +sourceOperand[0], +targetOperand[0]}), --size;
	else while (size > 4) Emit (MOVE {Operand::Long, +sourceOperand[0], +targetOperand[0]}), size -= 4;
	if (size >= 4) Emit (MOVE {Operand::Long, sourceOperand[0], targetOperand[0]}), size -= 4;
	if (size >= 2) Emit (MOVE {Operand::Word, sourceOperand[0], targetOperand[0]}), size -= 2;
	if (size >= 1) Emit (MOVE {Operand::Byte, sourceOperand[0], targetOperand[0]}), size -= 1;
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto sourceOperand = Load (target, Address), sizeOperand = Load (size, Address);
	if (!IsImmediate (size)) Emit (CMPA {Operand::Long, 0, sizeOperand}), Branch (GetLabel (0), Instruction::BEQ);
	const auto valueOperand = Reuse (value, IsAddress (value.type) ? Address : IsComplex (value) ? Low : Data);
	const auto highOperand = IsComplex (value) ? Reuse (value, High) : SmartOperand {};
	auto loop = CreateLabel (); loop (); Emit (MOVE {GetSize (value), valueOperand, +sourceOperand[0]});
	if (IsComplex (value)) Emit (MOVE {GetSize (value), highOperand, +sourceOperand[0]});
	Emit (SUBQ {Operand::Long, 1, sizeOperand}); Branch (loop, Instruction::BNE);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value, const Index index)
{
	if (target == value) return Emit (mnemonic, GetSize (target), Access (target, index), {});
	if (IsRegister (target)) return Load (Select (target, index), value, index), Emit ({mnemonic, GetSize (target), Select (target, index)});
	const auto register_ = Load (value, index); Emit ({mnemonic, GetSize (target), register_}); Store (register_, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	if (target == value1)
		if (IsRegister (target) && mnemonic != Instruction::EOR) return Emit (mnemonic, GetSize (target), Access (value2, index), Select (target, index));
		else if (!IsAddress (target.type)) return Emit (mnemonic, GetSize (target), Reuse (value2, index), Access (target, index));
	if (IsRegister (target) && !value2.Uses (target.register_)) return Load (Select (target, index), value1, index), Emit (mnemonic, GetSize (target), mnemonic == Instruction::EOR ? Reuse (value2, index) : Access (value2, index), Select (target, index));
	const auto register_ = Load (value1, index); Emit (mnemonic, GetSize (value1), mnemonic == Instruction::EOR ? Reuse (value2, index) : Access (value2, index), register_); Store (register_, target, index);
}

void Context::OperationX (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	if (IsRegister (target))
		if (target == value1) return Emit (mnemonic, GetSize (target), Reuse (value2, index), Select (target, index));
		else return Load (Select (target, index), value1, index), Emit ({mnemonic, GetSize (target), Reuse (value2, index), Select (target, index)});
	const auto register_ = Load (value1, index); Emit ({mnemonic, GetSize (value1), Reuse (value2, index), register_}); Store (register_, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Instruction::Mnemonic immediate, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	if (!IsImmediate (value2)) return Operation (mnemonic, target, value1, value2, index);
	if (target == value1) return Emit (immediate, GetSize (value1), Extract (value2, index), Access (target, index));
	if (IsRegister (target)) return Load (Select (target, index), value1, index), Emit ({immediate, GetSize (target), Extract (value2, index), Select (target, index)});
	const auto register_ = Load (value1, index); Emit ({immediate, GetSize (value1), Extract (value2, index), register_}); Store (register_, target, index);
}

void Context::OperationAddress (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto register_ = Acquire (Data), value = Acquire (Data); Emit (Instruction::MOVE, Operand::Long, Access (value1, Address), register_);
	Emit (Instruction::MOVE, Operand::Long, Access (value2, Address), value); Emit (mnemonic, mnemonic == Instruction::MULU ? Operand::None : Operand::Long, value, register_); Store (register_, target, Address);
}

void Context::OperationAddress (const Instruction::Mnemonic mnemonic, const Instruction::Mnemonic immediate, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	if (!IsImmediate (value2)) return OperationAddress (mnemonic, target, value1, value2);
	const auto register_ = Acquire (Data); Emit (Instruction::MOVE, Operand::Long, Access (value1, Address), register_);
	Emit (immediate, Operand::Long, Extract (value2, Address), register_); Store (register_, target, Address);
}

void Context::Multiply (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	if (IsRegister (value2) && !IsRegister (value1)) return Multiply (target, value2, value1, index);
	if (IsImmediate (value2) && IsPowerOfTwo (Extract (value2, index))) return Shift (IsSigned (target) ? Instruction::ASL : Instruction::LSL, target, value1, Code::Imm (target.type, CountOnes (Extract (value2, index) - 1ul)), index);
	const auto size = GetSize (target); const auto register_ = IsRegister (target) ? Select (target, index) : Acquire (Data);
	if (!IsSigned (target) && size == Operand::Byte) Emit (CLR {size, register_}); Emit (Instruction::MOVE, size, Access (value1, index), register_);
	if (IsSigned (target) && size == Operand::Byte) Emit (EXT {Operand::Word, register_});
	Emit (IsSigned (target) ? Instruction::MULS : Instruction::MULU, Operand::None, Access (value2, index), register_);
	if (!IsRegister (target)) Store (register_, target, index);
}

void Context::Divide (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index, const bool remainder)
{
	if (IsImmediate (value2) && IsPowerOfTwo (Extract (value2, index)))
		if (remainder) return Operation (Instruction::AND, Instruction::ANDI, target, value1, Code::Imm (target.type, Extract (value2, index) - 1), index);
		else return Shift (IsSigned (target) ? Instruction::ASR : Instruction::LSR, target, value1, Code::Imm (target.type, CountOnes (Extract (value2, index) - 1ul)), index);
	const auto size = GetSize (target); const auto register_ = IsRegister (target) ? Select (target, index) : Acquire (Data);
	if (!IsSigned (target) && size == Operand::Byte) Emit (CLR {size, register_}); Emit (Instruction::MOVE, size, Access (value1, index), register_);
	if (IsSigned (target)) if (size == Operand::Byte) Emit (EXT {Operand::Word, register_}), Emit (EXT {Operand::Long, register_}); else Emit (EXT {Operand::Long, register_});
	Emit (IsSigned (target) ? Instruction::DIVS : Instruction::DIVU, Operand::None, Access (value2, index), register_); if (remainder) Emit (SWAP {register_});
	if (!IsRegister (target)) Store (register_, target, index);
}

void Context::Shift (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	if (IsZero (value2)) return Move (target, value1, index);
	if (index == Address) return OperationAddress (mnemonic, mnemonic, target, value1, value2);
	const auto shift = IsImmediate (value2) && Extract (value2, index) >= 1 && Extract (value2, index) <= 8 ? Extract (value2, index) : Reuse (value2, index);
	if (IsRegister (target) && !value2.Uses (target.register_)) return Load (Select (target, index), value1, index), Emit ({mnemonic, GetSize (target), shift, Select (target, index)});
	const auto register_ = Load (value1, index); Emit ({mnemonic, GetSize (value1), shift, register_}); Store (register_, target, index);
}

void Context::Push (const Code::Operand& value, const Index index)
{
	if (IsAddress (value.type) && !IsMemory (value)) return Emit (Instruction::PEA, Operand::None, GetAddress (value), {});
	Emit (Instruction::MOVE, GetSize (value), Access (value, index), -Operand {0, SP});
}

void Context::Pop (const Code::Operand& target, const Index index)
{
	Emit (IsAddress (target.type) && IsRegister (target) ? Instruction::MOVEA : Instruction::MOVE, GetSize (target), +Operand {0, SP}, Access (target, index));
}

void Context::Jump (const Instruction::Mnemonic mnemonic, const Code::Operand& target)
{
	Emit (mnemonic, Operand::None, GetAddress (target), {});
}

void Context::Branch (const Code::Offset offset, const Instruction::Mnemonic mnemonic)
{
	Branch (GetLabel (offset), mnemonic);
}

void Context::CompareAndBranch (const Code::Offset offset, const Code::Operand& value1, const Code::Operand& value2, const Instruction::Mnemonic mnemonic, const Index index)
{
	if (IsImmediate (value1) && !IsImmediate (value2) && (mnemonic == Instruction::BEQ || mnemonic == Instruction::BNE)) return CompareAndBranch (offset, value2, value1, mnemonic, index);
	if (!IsAddress (value1.type) && IsImmediate (value2)) return Emit (Instruction::CMPI, GetSize (value1), Extract (value2, index), Access (value1, index)), Branch (offset, mnemonic);
	const auto register_ = IsRegister (value1) ? Select (value1, index) : Load (value1, index); Emit (IsAddress (value1.type) ? Instruction::CMPA : Instruction::CMP, GetSize (value1), Access (value2, index), register_); Branch (offset, mnemonic);
}

void Context::Branch (const Label& label, const Instruction::Mnemonic mnemonic)
{
	AddFixup (label, mnemonic, 4); if (listing) listing << '\t' << mnemonic << Operand::Word << '\t' << label << '\n';
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const Instruction instruction {Instruction::Mnemonic (code), Operand::Word, Immediate (target - bytes.begin () - 2)};
	assert (M68K::GetSize (instruction) == bytes.size ()); instruction.Emit (bytes);
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
	return stream << registers[IsAddress (operand.type) ? Address : Index (part)][operand.register_];
}

bool Context::IsFixup (const Code::Operand& operand)
{
	return (IsMemory (operand) || IsAddress (operand)) && !operand.address.empty () && operand.register_ == Code::RVoid;
}

bool Context::IsComplex (const Code::Operand& operand)
{
	return operand.type.size == 8;
}

Operand::Size Context::GetSize (const Code::Operand& operand)
{
	if (operand.type.size == 1) return Operand::Byte;
	if (operand.type.size == 2) return Operand::Word;
	return Operand::Long;
}

void Context::Write (std::ostream& stream, const SmartOperand& operand)
{
	if (operand.address.empty ()) stream << operand;
	else WriteAddress (stream << '(', nullptr, operand.address, operand.displacement, 0) << ')' << Operand::Long;
}

SmartOperand::SmartOperand (const Operand& o) :
	Operand {o}
{
}

SmartOperand::SmartOperand (Context& c, const Operand& o) :
	Operand {o}, context {&c}
{
	context->Acquire (GetRegister (*this));
}

SmartOperand::SmartOperand (const Code::Section::Name& a, const Code::Displacement d) :
	Operand {0, Operand::Long}, address {a}, displacement {d}
{
	assert (!address.empty ());
}

SmartOperand::SmartOperand (SmartOperand&& operand) noexcept :
	Operand {std::move (operand)}, context {operand.context}, address {std::move (operand.address)}, displacement {operand.displacement}
{
	operand.context = nullptr;
}

SmartOperand::~SmartOperand ()
{
	if (context) context->Release (GetRegister (*this));
}

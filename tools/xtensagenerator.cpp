// Xtensa machine code generator
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
#include "xtensa.hpp"
#include "xtensagenerator.hpp"

using namespace ECS;
using namespace Xtensa;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const Xtensa::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	enum Index {Low, High, Float};

	class SmartOperand;

	const Options options;

	bool acquired[48] {};
	Register registers[3][Code::Registers];

	void Acquire (Register);
	void Release (Register);
	Register GetFree (Index) const;

	Register Select (const Code::Operand&, Index) const;
	Immediate Extract (const Code::Operand&, Index) const;

	SmartOperand Acquire (Index);
	SmartOperand Load (const Code::Operand&, Index);
	SmartOperand Load (const Code::Section::Name&, Code::Displacement);
	SmartOperand LoadExtended (const Code::Operand&, Index);
	SmartOperand Acquire (const Code::Operand&, Index);

	void Emit (const Instruction&);
	void Emit (Instruction::Mnemonic, const Label&, Register = {}, Register = {});

	void Move (const Operand&, Immediate);
	void Move (const Operand&, const Operand&);
	void Move (const Operand&, const Code::Section::Name&, Code::Displacement);
	void Move (const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);
	void MoveFloat (bool, const Operand&, const Operand&);
	void MoveFloat (bool, const Operand&, const Code::Operand&);
	void Add (const Operand&, const Operand&, Immediate);
	void Add (const Operand&, const Operand&, const Operand&);
	void Push (const Operand&);
	void Pop (const Operand&);

	void Extend (const Operand&, const Code::Type&);
	void Load (const Operand&, const Code::Operand&, Index);
	void Store (const Operand&, const Code::Operand&, Index);
	void Access (const Instruction::Mnemonic, const Operand&, const Code::Operand&, Index);

	void Define (const Code::Instruction&);
	void Define (const Code::Operand&);
	void Define (const Code::Operand&, Index);
	void Define (Immediate);

	using Assembly::Generator::Context::DefineLocal;
	Label DefineLocal (Immediate);
	Label DefineLocal (const Code::Section::Name&, Code::Displacement);

	void AlignCode (Code::Offset);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void Convert (const Code::Operand&, const Code::Operand&);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Negate (const Code::Operand&, const Code::Operand&);
	void Add (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Subtract (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Multiply (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, Index);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void Not (const Code::Operand&, const Code::Operand&, Index);
	void Shift (Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void Pop (const Code::Operand&);
	void Push (const Code::Operand&);
	void Branch (Instruction::Mnemonic, Instruction::Mnemonic, Code::Offset, Register, Register = {});
	void CompareAndBranch (Instruction::Mnemonic, Instruction::Mnemonic, Code::Offset, const Code::Operand&, const Code::Operand&);
	void CompareAndBranch (Instruction::Mnemonic, Instruction::Mnemonic, Code::Offset, const Code::Operand&, const Code::Operand&, Index);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Postprocess (const Code::Section&) -> void override;
	auto Preprocess (const Code::Section&) -> void override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	bool IsFloat (const Code::Operand&) const;
	bool IsComplex (const Code::Operand&) const;
	static bool IsDoublePrecision (const Code::Operand&);
	static Instruction::Mnemonic GetLoadMnemonic (Code::Type::Size, bool, bool);
	static Instruction::Mnemonic GetStoreMnemonic (Code::Type::Size, bool);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (SmartOperand&&) noexcept;
	SmartOperand (Context&, Xtensa::Register);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c, const Options o) :
	Assembly::Generator {d, sp, assembler, "xtensa", "Xtensa", {{4, 1, 8}, {4, 4, o & DoublePrecision ? 8u : 4u}, 4, 4, {0, 4, 8}, true}, true},
	assembler {d, c}, options {o}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const Xtensa::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}, options {g.options}
{
	for (auto& set: registers) for (auto& register_: set) register_ = A0;
	Acquire (registers[Low][Code::RSP] = SP); Acquire (registers[Low][Code::RFP] = A15); Acquire (registers[Low][Code::RLink] = A0);
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
	auto register_ = (index == Float ? F1 : A4); while (register_ % 16 && acquired[register_]) register_ = Register (register_ + 1);
	if (register_ % 16 == 0) throw RegisterShortage {}; return register_;
}

Register Context::Select (const Code::Operand& operand, const Index index) const
{
	assert (IsRegister (operand)); return registers[index][operand.register_];
}

Immediate Context::Extract (const Code::Operand& operand, const Index index) const
{
	assert (IsImmediate (operand)); return IsSigned (operand) ? Immediate (operand.simm >> index * 32) : Immediate (Code::Convert (operand) >> index * 32);
}

SmartOperand Context::Acquire (const Index index)
{
	return {*this, GetFree (index)};
}

void Context::Extend (const Operand& register_, const Code::Type& type)
{
	if (!IsFloat (type) && type.size < 4)
		if (IsSigned (type)) Emit (SEXT {register_, register_, Immediate (type.size * 8 - 1)});
		else Emit (EXTUI {register_, register_, 0, Immediate (type.size * 8)});
}

SmartOperand Context::Load (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index);
	auto result = Acquire (index); Load (result, operand, index); return result;
}

SmartOperand Context::Load (const Code::Section::Name& address, const Code::Displacement displacement)
{
	auto result = Acquire (Low); Move (result, address, displacement); return result;
}

SmartOperand Context::LoadExtended (const Code::Operand& operand, const Index index)
{
	auto result = Load (operand, index); if (IsRegister (operand)) Extend (result, operand.type); return result;
}

SmartOperand Context::Acquire (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand)) return Select (operand, index); return Acquire (index);
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction));
	instruction.Emit (Reserve (GetSize (instruction)));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Label& label, const Register register1, const Register register2)
{
	AddFixup (label, mnemonic << 12 | register1 << 6 | register2 << 0, 3); if (!listing) return;
	listing << '\t' << mnemonic << '\t'; if (register1) listing << register1 << ", "; if (register2) listing << register2 << ", "; listing << label << '\n';
}

void Context::Move (const Operand& target, const Operand& value)
{
	if (GetRegister (target) == GetRegister (value)) return;
	if (options & CodeDensity) return Emit (MOVN {target, value});
	Emit (MOV {target, value});
}

void Context::Move (const Operand& target, const Immediate immediate)
{
	if (options & Const16) return Emit (CONST16 {target, immediate >> 0 & 0xffff}), Emit (CONST16 {target, immediate >> 16 & 0xffff});
	if (options & CodeDensity && immediate > -32 && immediate <= 95) return Emit (MOVIN {target, immediate});
	if (immediate >= -2048 && immediate <= 2047) return Emit (MOVI {target, immediate});
	Emit (Instruction::L32R, DefineLocal (immediate), GetRegister (target));
}

void Context::Move (const Operand& target, const Code::Section::Name& address, const Code::Displacement displacement)
{
	if (!(options & Const16)) return Emit (Instruction::L32R, DefineLocal (address, displacement), GetRegister (target));
	Move (target, address, displacement, 16); Move (target, address, displacement, 0);
}

void Context::Move (const Operand& target, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const CONST16 instruction {target, 0}; Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (GetSize (instruction)));
	if (listing) WriteAddress (listing << '\t' << Instruction::CONST16 << '\t' << target << ", ", nullptr, address, displacement, scale) << '\n';
}

void Context::MoveFloat (const bool doublePrecision, const Operand& target, const Operand& value)
{
	if (GetRegister (target) == GetRegister (value)) return;
	Emit ({doublePrecision ? Instruction::MOVD : Instruction::MOVS, target, value});
}

void Context::MoveFloat (const bool doublePrecision, const Operand& target, const Code::Operand& value)
{
	if (value.fimm == 0 || value.fimm == 1 || value.fimm == 2 || value.fimm == 0.5) return Emit ({doublePrecision ? Instruction::CONSTD : Instruction::CONSTS, target, value.fimm == 0.5 ? 3 : Immediate (value.fimm)});
	const auto low = Acquire (Low), high = Acquire (High); Move (low, Extract (value, Low)); if (doublePrecision) Move (high, Extract (value, High)), Emit (WFRD {target, high, low}); else Emit (WFR {target, low});
}

void Context::Add (const Operand& target, const Operand& value1, const Operand& value2)
{
	if (options & CodeDensity) return Emit (ADDN {target, value1, value2});
	Emit (ADD {target, value1, value2});
}

void Context::Add (const Operand& target, const Operand& value, const Immediate immediate)
{
	if (!immediate) return Move (target, value);
	if (options & CodeDensity && immediate >= -1 && immediate <= 15) return Emit (ADDIN {target, value, immediate});
	else if (immediate >= -128 && immediate <= 127) return Emit (ADDI {target, value, immediate});
	const auto register_ = Acquire (Low); Move (register_, immediate); Add (target, value, register_);
}

void Context::Push (const Operand& value)
{
	const auto pointer = GetRegister (value) == SP ? Acquire (Low) : SP;
	Add (pointer, SP, -4); Emit (S32I {value, pointer, 0}); Move (SP, pointer);
}

void Context::Pop (const Operand& target)
{
	Emit (L32I {target, SP, 0}); Add (SP, SP, 4);
}

void Context::Load (const Operand& register_, const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		if (IsFloat (operand)) return MoveFloat (IsDoublePrecision (operand), register_, operand);
		return Move (register_, Extract (operand, index));

	case Code::Operand::Address:
		if (!HasRegister (operand)) return Move (register_, operand.address, operand.displacement);
		return Add (register_,  registers[index][operand.register_], Load (operand.address, operand.displacement));

	case Code::Operand::Register:
		if (IsFloat (operand)) return MoveFloat (IsDoublePrecision (operand), register_, Operand {registers[index][operand.register_]});
		return Add (register_, registers[index][operand.register_], operand.displacement);

	case Code::Operand::Memory:
		Access (GetLoadMnemonic (operand.type.size, IsFloat (operand), IsSigned (operand)), register_, operand, index);
		if (IsSigned (operand) && operand.type.size == 1) Extend (register_, operand.type);
		return;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Store (const Operand& register_, const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Register:
		if (IsFloat (operand)) return MoveFloat (IsDoublePrecision (operand), registers[index][operand.register_], register_);
		return Move (registers[index][operand.register_], register_);

	case Code::Operand::Memory:
		return Access (GetStoreMnemonic (operand.type.size, IsFloat (operand)), register_, operand, index);

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Access (const Instruction::Mnemonic mnemonic, const Operand& register_, const Code::Operand& operand, const Index index)
{
	assert (IsMemory (operand)); const Immediate offset = index * 4 % 8, size = operand.type.size - offset, displacement = operand.displacement + offset;
	if (operand.address.empty () && operand.register_ != Code::RVoid && displacement >= 0 && displacement <= 255 * size && displacement % size == 0) return Emit ({mnemonic, register_, registers[Low][operand.register_], displacement});
	const auto address = Acquire (Low); if (operand.address.empty ()) Move (address, displacement - offset); else Move (address, operand.address, displacement - offset);
	if (operand.register_ != Code::RVoid) Add (address, address, Operand {registers[Low][operand.register_]}); Emit ({mnemonic, register_, address, offset});
}

void Context::Define (const Code::Instruction& instruction)
{
	if (!IsSupported (instruction)) Define (GetAddress (instruction));
	Define (instruction.operand1); Define (instruction.operand2); Define (instruction.operand3);
}

void Context::Define (const Code::Operand& operand)
{
	if (!HasType (operand)) return;
	if (IsFloat (operand)) Define (operand, Float);
	else if (IsComplex (operand)) Define (operand, Low), Define (operand, High);
	else Define (operand, Low);
}

void Context::Define (const Code::Operand& operand, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		if (IsFloat (operand)) if (operand.fimm == 0 || operand.fimm == 1 || operand.fimm == 2 || operand.fimm == 0.5) return; else return Define (Extract (operand, Low)), Define (Extract (operand, High));
		return Define (Extract (operand, index));

	case Code::Operand::Address:
		return void (DefineLocal (operand.address, operand.displacement));

	case Code::Operand::Register:
		return Define (operand.displacement);

	case Code::Operand::Memory:
		if (operand.address.empty ()) return Define (operand.displacement);
		return void (DefineLocal (operand.address, operand.displacement));

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Define (const Immediate immediate)
{
	if (immediate >= -2048 && immediate <= 2047) return;
	DefineLocal (immediate);
}

Context::Label Context::DefineLocal (const Immediate immediate)
{
	return DefineLocal (Code::SImm (generator.platform.integer, immediate), 0, 262144);
}

Context::Label Context::DefineLocal (const Code::Section::Name& address, const Code::Displacement displacement)
{
	return DefineLocal (Code::Adr {generator.platform.pointer, address, displacement}, 0, 262144);
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	auto high = false, float_ = false;
	for (auto& type: types) if (type.model == Code::Type::Float && options & (type.size == 8 ? DoublePrecision : SinglePrecision)) float_ = true; else if (type.size == 8) high = true;
	assert (!registers[Low][register_]); Acquire (registers[Low][register_] = (register_ == Code::RRes ? A2 : GetFree (Low)));
	assert (!registers[High][register_]); if (high) Acquire (registers[High][register_] = (register_ == Code::RRes ? A3 : GetFree (High)));
	assert (!registers[Float][register_]); if (float_) Acquire (registers[Float][register_] = (register_ == Code::RRes ? F0 : GetFree (Float)));
}

void Context::Release (const Code::Register register_)
{
	assert (registers[Low][register_]); Release (registers[Low][register_]); registers[Low][register_] = A0;
	if (registers[High][register_]) Release (registers[High][register_]), registers[High][register_] = A0;
	if (registers[Float][register_]) Release (registers[Float][register_]), registers[Float][register_] = A0;
}

void Context::Preprocess (const Code::Section& section)
{
	if (options & Const16) return;
	if (IsCode (section.type)) for (auto& instruction: section.instructions) Define (instruction);
}

void Context::Postprocess (const Code::Section& section)
{
	if (IsExecutable (section)) AlignCode (0);
}

void Context::AlignCode (const Code::Offset padding)
{
	while (const auto offset = (GetOffset (Reserve (0).begin ()) + padding) % 4) if (offset == 2 && options & CodeDensity) Emit (NOPN {}); else Emit (NOP {});
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	switch (instruction.mnemonic)
	{
	case Code::Instruction::CONV:
		return instruction.operand1.type == instruction.operand2.type ||
			(!Code::IsFloat (instruction.operand1) || IsFloat (instruction.operand1) && !IsComplex (instruction.operand2)) &&
			(!Code::IsFloat (instruction.operand2) || IsFloat (instruction.operand2) && !IsComplex (instruction.operand1));

	case Code::Instruction::NEG:
	case Code::Instruction::ADD:
	case Code::Instruction::SUB:
	case Code::Instruction::BREQ:
	case Code::Instruction::BRNE:
	case Code::Instruction::BRLT:
	case Code::Instruction::BRGE:
		return !Code::IsFloat (instruction.operand2) || IsFloat (instruction.operand2);

	case Code::Instruction::MUL:
		return Code::IsFloat (instruction.operand1) ? IsFloat (instruction.operand1) : IsComplex (instruction.operand1) ? options & Multiply64 : options & Multiply32;

	case Code::Instruction::DIV:
	case Code::Instruction::MOD:
		return !IsComplex (instruction.operand1) && !Code::IsFloat (instruction.operand1) && options & Divide32;

	case Code::Instruction::LSH:
	case Code::Instruction::RSH:
		return !IsComplex (instruction.operand1);

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
		if (IsFloat (operand1)) Move (operand1, operand2, Float);
		else if (IsComplex (operand1)) Move (operand1, operand2, Low), Move (operand1, operand2, High);
		else Move (operand1, operand2, Low);
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
		Negate (operand1, operand2);
		break;

	case Code::Instruction::ADD:
		Add (operand1, operand2, operand3);
		break;

	case Code::Instruction::SUB:
		Subtract (operand1, operand2, operand3);
		break;

	case Code::Instruction::MUL:
		Multiply (operand1, operand2, operand3);
		break;

	case Code::Instruction::DIV:
		Operation (IsSigned (operand1) ? Instruction::QUOS : Instruction::QUOU, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MOD:
		Operation (IsSigned (operand1) ? Instruction::REMS : Instruction::REMU, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::NOT:
		if (IsComplex (operand1)) Not (operand1, operand2, Low), Not (operand1, operand2, High);
		else Not (operand1, operand2, Low);
		break;

	case Code::Instruction::AND:
		if (IsComplex (operand1)) Operation (Instruction::AND, operand1, operand2, operand3, Low), Operation (Instruction::AND, operand1, operand2, operand3, High);
		else Operation (Instruction::AND, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::OR:
		if (IsComplex (operand1)) Operation (Instruction::OR, operand1, operand2, operand3, Low), Operation (Instruction::OR, operand1, operand2, operand3, High);
		else Operation (Instruction::OR, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::XOR:
		if (IsComplex (operand1)) Operation (Instruction::XOR, operand1, operand2, operand3, Low), Operation (Instruction::XOR, operand1, operand2, operand3, High);
		else Operation (Instruction::XOR, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::LSH:
		Shift (Instruction::SLL, Instruction::SLLI, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::RSH:
		Shift (IsSigned (operand1) ? Instruction::SRA : Instruction::SRL, IsSigned (operand1) ? Instruction::SRAI : Instruction::SRLI, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::PUSH:
		Push (operand1);
		break;

	case Code::Instruction::POP:
		Pop (operand1);
		break;

	case Code::Instruction::CALL:
		Emit (CALLX0 {Load (operand1, Low)});
		Add (SP, SP, operand2.size);
		break;

	case Code::Instruction::RET:
		Pop (Operand {A0});
		Emit (RET {});
		break;

	case Code::Instruction::ENTER:
		Push (Operand {A15});
		Move (A15, Operand {SP});
		Add (SP, SP, -Immediate (operand1.size));
		break;

	case Code::Instruction::LEAVE:
		Move (SP, Operand {A15});
		Pop (Operand {A15});
		break;

	case Code::Instruction::BR:
		Emit (Instruction::J, GetLabel (operand1.offset));
		break;

	case Code::Instruction::BREQ:
		if (IsFloat (operand2)) CompareAndBranch (IsDoublePrecision (operand2) ? Instruction::OEQD : Instruction::OEQS, Instruction::BT, operand1.offset, operand2, operand3);
		else if (IsComplex (operand2)) CompareAndBranch (Instruction::BNE, Instruction::BEQ, 0, operand2, operand3, High), CompareAndBranch (Instruction::BEQ, Instruction::BNE, operand1.offset, operand2, operand3, Low);
		else CompareAndBranch (Instruction::BEQ, Instruction::BNE, operand1.offset, operand2, operand3, Low);
		break;

	case Code::Instruction::BRNE:
		if (IsFloat (operand2)) CompareAndBranch (IsDoublePrecision (operand2) ? Instruction::OEQD : Instruction::OEQS, Instruction::BF, operand1.offset, operand2, operand3);
		else if (IsComplex (operand2)) CompareAndBranch (Instruction::BNE, Instruction::BEQ, operand1.offset, operand2, operand3, High), CompareAndBranch (Instruction::BNE, Instruction::BEQ, operand1.offset, operand2, operand3, Low);
		else CompareAndBranch (Instruction::BNE, Instruction::BEQ, operand1.offset, operand2, operand3, Low);
		break;

	case Code::Instruction::BRLT:
		if (IsFloat (operand2)) CompareAndBranch (IsDoublePrecision (operand2) ? Instruction::OLTD : Instruction::OLTS, Instruction::BT, operand1.offset, operand2, operand3);
		else if (IsComplex (operand2)) CompareAndBranch (IsSigned (operand2) ? Instruction::BLT : Instruction::BLTU, IsSigned (operand2) ? Instruction::BGE : Instruction::BGEU, operand1.offset, operand2, operand3, High), CompareAndBranch (Instruction::Instruction::BLTU, Instruction::BGEU, operand1.offset, operand2, operand3, Low);
		else CompareAndBranch (IsSigned (operand2) ? Instruction::BLT : Instruction::BLTU, IsSigned (operand2) ? Instruction::BGE : Instruction::BGEU, operand1.offset, operand2, operand3, Low);
		break;

	case Code::Instruction::BRGE:
		if (IsFloat (operand2)) CompareAndBranch (IsDoublePrecision (operand2) ? Instruction::OLTD : Instruction::OLTS, Instruction::BF, operand1.offset, operand2, operand3);
		else if (IsComplex (operand2)) CompareAndBranch (IsSigned (operand2) ? Instruction::BLT : Instruction::BLTU, IsSigned (operand2) ? Instruction::BGE : Instruction::BGEU, operand1.offset, operand3, operand2, High), CompareAndBranch (Instruction::Instruction::BGEU, Instruction::BLTU, operand1.offset, operand2, operand3, Low);
		else CompareAndBranch (IsSigned (operand2) ? Instruction::BGE : Instruction::BGEU, IsSigned (operand2) ? Instruction::BLT : Instruction::BLTU, operand1.offset, operand2, operand3, Low);
		break;

	case Code::Instruction::JUMP:
		Emit (JX {Load (operand1, Low)});
		break;

	case Code::Instruction::TRAP:
		Emit (ILL {});
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

void Context::Convert (const Code::Operand& target, const Code::Operand& value)
{
	const auto result = Acquire (target, IsFloat (target) ? Float : Low);

	if (IsFloat (target))
		if (target.type == value.type) MoveFloat (IsDoublePrecision (target), result, Load (value, Float));
		else if (IsFloat (value)) Emit ({IsDoublePrecision (target) ? Instruction::CVTDS : Instruction::CVTSD, result, Load (value, Float)});
		else if (IsSigned (value)) Emit ({IsDoublePrecision (target) ? Instruction::FLOATD : Instruction::FLOATS, result, Load (value, Low), 0});
		else Emit ({IsDoublePrecision (target) ? Instruction::UFLOATD : Instruction::UFLOATS, result, Load (value, Low), 0});
	else if (IsFloat (value))
		if (IsSigned (target)) Emit ({IsDoublePrecision (value) ? Instruction::TRUNCD : Instruction::TRUNCS, result, Load (value, Float), 0});
		else Emit ({IsDoublePrecision (value) ? Instruction::UTRUNCD : Instruction::UTRUNCS, result, Load (value, Float), 0});
	else
		Load (result, value, Low);

	Extend (result, target.type); Store (result, target, IsFloat (target) ? Float : Low);
	if (!IsComplex (target)) return; if (IsComplex (value)) return Move (target, value, High);
	const auto resultHigh = Acquire (target, High); if (IsSigned (value)) Emit (SRAI {resultHigh, result, 31}); else Move (resultHigh, 0); Store (resultHigh, target, High);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	if (IsZero (size)) return; const auto count = Acquire (Low); Load (count, size, Low);
	if (!IsImmediate (size) && !(options & Loop)) Emit (Instruction::BEQZ, GetLabel (0), GetRegister (count));
	const auto sourceAddress = Acquire (Low), targetAddress = Acquire (Low), value = Acquire (Low); Load (sourceAddress, source, Low); Load (targetAddress, target, Low);
	if (options & Loop) AlignCode (1), Emit (Instruction::LOOPGTZ, GetLabel (0), GetRegister (count)); else Add (count, count, targetAddress);
	auto loop = CreateLabel (); loop (); Emit (L8UI {value, sourceAddress, 0}); Emit (S8I {value, targetAddress, 0}); Add (sourceAddress, sourceAddress, 1); Add (targetAddress, targetAddress, 1);
	if (!(options & Loop)) Emit (Instruction::BNE, loop, GetRegister (targetAddress), GetRegister (count));
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	if (IsZero (size)) return; const auto count = Acquire (Low); Load (count, size, Low);
	if (!IsImmediate (size) && !(options & Loop)) Emit (Instruction::BEQZ, GetLabel (0), GetRegister (count));
	if (value.type.size != 1 && !(options & Loop)) Emit (SLLI {count, count, Immediate (CountTrailingZeros (value.type.size))});
	const auto targetAddress = Acquire (Low), valueLow = Acquire (IsFloat (value) ? Float : Low), valueHigh = Acquire (High); Load (targetAddress, target, Low);
	Load (valueLow, value, IsFloat (value) ? Float : Low); if (IsComplex (value)) Load (valueHigh, value, High);
	if (options & Loop) AlignCode (1), Emit (Instruction::LOOPGTZ, GetLabel (0), GetRegister (count)); else Add (count, count, targetAddress);
	auto loop = CreateLabel (); loop (); Emit ({GetStoreMnemonic (value.type.size, IsFloat (value)), valueLow, targetAddress, 0});
	if (IsComplex (value)) Emit ({GetStoreMnemonic (value.type.size, false), valueHigh, targetAddress, 4}); Add (targetAddress, targetAddress, value.type.size);
	if (!(options & Loop)) Emit (Instruction::BNE, loop, GetRegister (targetAddress), GetRegister (count));
}

void Context::Negate (const Code::Operand& target, const Code::Operand& value)
{
	if (IsFloat (target)) return Operation (IsDoublePrecision (target) ? Instruction::NEGD : Instruction::NEGS, target, value, Float);
	if (!IsComplex (target)) return Operation (Instruction::NEG, target, value, Low);
	const auto resultLow = Acquire (Low), resultHigh = Acquire (High), valueLow = Acquire (Low);
	Load (valueLow, value, Low); Emit (NEG {resultLow, valueLow}); Emit (NEG {resultHigh, Load (value, High)});
	auto skip = CreateLabel (); Emit (Instruction::BEQZ, skip, GetRegister (valueLow)); Emit (ADDI {resultHigh, resultHigh, -1});
	skip (); Store (resultLow, target, Low); Store (resultHigh, target, High);
}

void Context::Add (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	if (IsFloat (target)) return Operation (IsDoublePrecision (target) ? Instruction::ADDD : Instruction::ADDS, target, value1, value2, Float);
	if (!IsComplex (target)) return Operation (Instruction::ADD, target, value1, value2, Low);
	const auto resultLow = Acquire (Low), resultHigh = Acquire (High), value2Low = Acquire (Low);
	Load (value2Low, value2, Low); Emit (ADD {resultLow, Load (value1, Low), value2Low}); Emit (ADD {resultHigh, Load (value1, High), Load (value2, High)});
	auto skip = CreateLabel (); Emit (Instruction::BGEU, skip, GetRegister (resultLow), GetRegister (value2Low)); Emit (ADDI {resultHigh, resultHigh, 1});
	skip (); Store (resultLow, target, Low); Store (resultHigh, target, High);
}

void Context::Subtract (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	if (IsFloat (target)) return Operation (IsDoublePrecision (target) ? Instruction::SUBD : Instruction::SUBS, target, value1, value2, Float);
	if (!IsComplex (target)) return Operation (Instruction::SUB, target, value1, value2, Low);
	const auto resultLow = Acquire (Low), resultHigh = Acquire (High), value1Low = Acquire (Low), value2Low = Acquire (Low);
	Load (value1Low, value1, Low); Load (value2Low, value2, Low); Emit (SUB {resultLow, value1Low, value2Low}); Emit (SUB {resultHigh, Load (value1, High), Load (value2, High)});
	auto skip = CreateLabel (); Emit (Instruction::BGEU, skip, GetRegister (value1Low), GetRegister (value2Low)); Emit (ADDI {resultHigh, resultHigh, -1});
	skip (); Store (resultLow, target, Low); Store (resultHigh, target, High);
}

void Context::Multiply (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	if (IsFloat (target)) return Operation (IsDoublePrecision (target) ? Instruction::MULD : Instruction::MULS, target, value1, value2, Float);
	if (!IsComplex (target)) return Operation (Instruction::MULL, target, value1, value2, Low);
	const auto resultLow = Acquire (Low), resultHigh = Acquire (High), value1Low = Acquire (Low), value2Low = Acquire (Low), temporary = Acquire (Low);
	Load (value1Low, value1, Low); Load (value2Low, value2, Low); Emit (MULL {resultLow, value1Low, value2Low}); Emit ({IsSigned (target) ? Instruction::MULSH : Instruction::MULUH, resultHigh, value1Low, value2Low});
	Emit (MULL {temporary, value1Low, Load (value2, High)}); Emit (ADD {resultHigh, resultHigh, temporary}); Emit (MULL {temporary, Load (value1, High), value2Low}); Emit (ADD {resultHigh, resultHigh, temporary});
	Store (resultLow, target, Low); Store (resultHigh, target, High);
}

void Context::Not (const Code::Operand& target, const Code::Operand& value, const Index index)
{
	const auto result = Acquire (target, index), mask = Acquire (index); Emit (MOVI {mask, -1}); Emit (XOR {result, mask, Load (value, index)}); Store (result, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value, const Index index)
{
	const auto result = Acquire (target, index); Emit ({mnemonic, result, Load (value, index)}); Store (result, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto result = Acquire (target, index), value = Load (value1, index); Emit ({mnemonic, result, value, Load (value2, index)}); Store (result, target, index);
}

void Context::Shift (const Instruction::Mnemonic mnemonic, const Instruction::Mnemonic immediate, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto result = Acquire (target, index);
	if (IsImmediate (value2)) if (const Immediate shift = Extract (value2, index); shift >= 0 && shift <= 31)
		if (shift == 0) return Load (result, value1, index), Store (result, target, index);
		else if (immediate == Instruction::SRLI && shift >= 16 && shift <= 31) return Emit (EXTUI {result, Load (value1, index), shift, 32 - shift}), Store (result, target, index);
		else return Emit ({immediate, result, Load (value1, index), shift}), Store (result, target, index);
	Emit ({mnemonic == Instruction::SLL ? Instruction::SSL : Instruction::SSR, Load (value2, index)}); Emit ({mnemonic, result, Load (value1, index)}); Store (result, target, index);
}

void Context::Push (const Code::Operand& value)
{
	const auto pointer = value.Uses (Code::RSP) ? Acquire (Low) : SP; Add (pointer, SP, -Immediate (generator.platform.GetStackSize (value.type)));
	if (IsComplex (value)) Emit ({GetStoreMnemonic (value.type.size, false), Load (value, High), pointer, 4});
	Emit ({GetStoreMnemonic (value.type.size, IsFloat (value)), Load (value, IsFloat (value) ? Float : Low), pointer, 0});
	Move (Operand {SP}, pointer);
}

void Context::Pop (const Code::Operand& target)
{
	const auto result = Acquire (target, IsFloat (target) ? Float : Low);
	Emit ({GetLoadMnemonic (target.type.size, IsFloat (target), IsSigned (target)), result, SP, 0});
	if (IsSigned (target) && target.type.size == 1) Extend (result, target.type); Store (result, target, IsFloat (target) ? Float : Low);
	if (IsComplex (target)) {const auto result = Acquire (target, High); Emit ({GetLoadMnemonic (target.type.size, false, IsSigned (target)), result, SP, 4}); Store (result, target, High);}
	Add (SP, SP, generator.platform.GetStackSize (target.type));
}

void Context::CompareAndBranch (const Instruction::Mnemonic branch, const Instruction::Mnemonic reverse, const Code::Offset offset, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto comparand1 = LoadExtended (value1, index), comparand2 = LoadExtended (value2, index); Branch (branch, reverse, offset, GetRegister (comparand1), GetRegister (comparand2));
	if (index == High && branch != Instruction::BNE) Branch (Instruction::BNE, Instruction::BEQ, 0, GetRegister (comparand1), GetRegister (comparand2));
}

void Context::CompareAndBranch (const Instruction::Mnemonic compare, const Instruction::Mnemonic branch, const Code::Offset offset, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto value = Load (value1, Float); Emit ({compare, B0, value, Load (value2, Float)});
	Branch (branch, branch == Instruction::BT ? Instruction::BF : Instruction::BT, offset, B0);
}

void Context::Branch (const Instruction::Mnemonic branch, const Instruction::Mnemonic reverse, const Code::Offset offset, const Register register1, const Register register2)
{
	const auto label = GetLabel (offset); if (offset >= -2 && offset <= 2 || GetBranchOffset (label, -125) >= -124) return Emit (branch, label, register1, register2);
	auto skip = CreateLabel (); Emit (reverse, skip, register1, register2); Emit (Instruction::J, label); skip ();
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const auto mnemonic = Instruction::Mnemonic (code >> 12);
	const auto register1 = Register (code >> 6 & 0x3f), register2 = Register (code >> 0 & 0x3f);
	const auto immediate = Immediate (target - bytes.begin ());
	if (!register1) Instruction {mnemonic, immediate}.Emit (bytes);
	else if (!register2) Instruction {mnemonic, register1, immediate}.Emit (bytes);
	else Instruction {mnemonic, register1, register2, immediate}.Emit (bytes);
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
	return stream << registers[IsFloat (operand) ? Float : Index (part)][operand.register_];
}

bool Context::IsComplex (const Code::Operand& operand) const
{
	return operand.type.size == 8 && !IsFloat (operand);
}

bool Context::IsFloat (const Code::Operand& operand) const
{
	return Code::IsFloat (operand) && options & (IsDoublePrecision (operand) ? DoublePrecision : SinglePrecision);
}

bool Context::IsDoublePrecision (const Code::Operand& operand)
{
	assert (Code::IsFloat (operand)); return operand.type.size == 8;
}

Instruction::Mnemonic Context::GetLoadMnemonic (const Code::Type::Size size, const bool float_, const bool signed_)
{
	if (size == 1) return Instruction::L8UI;
	if (size == 2) return signed_ ? Instruction::L16SI : Instruction::L16UI;
	if (size == 8) return float_ ? Instruction::LDI : Instruction::L32I;
	return float_ ? Instruction::LSI : Instruction::L32I;
}

Instruction::Mnemonic Context::GetStoreMnemonic (const Code::Type::Size size, const bool float_)
{
	if (size == 1) return Instruction::S8I;
	if (size == 2) return Instruction::S16I;
	if (size == 8) return float_ ? Instruction::SDI : Instruction::S32I;
	return float_ ? Instruction::SSI : Instruction::S32I;
}

SmartOperand::SmartOperand (Context& c, const Xtensa::Register register_) :
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

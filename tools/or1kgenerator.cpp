// OpenRISC 1000 machine code generator
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
#include "or1k.hpp"
#include "or1kgenerator.hpp"

using namespace ECS;
using namespace OR1K;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const OR1K::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

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
	void Access (const Operand&, const Code::Operand&, Index);
	void Access (const Code::Operand&, const Operand&, Index);

	void Emit (const Instruction&);
	void Emit (Instruction::Mnemonic, const Code::Section::Name&, Code::Displacement);
	void Emit (Instruction::Mnemonic, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);
	void Emit (Instruction::Mnemonic, const Operand&, const Operand&, const Code::Section::Name&, Code::Displacement, Object::Patch::Scale);

	void Load (const Operand&, Immediate);
	void Load (const Operand&, const Code::Section::Name&, Code::Displacement);

	void Pop (const Code::Operand&, Index);
	void Push (const Code::Operand&, Index);
	void Branch (Instruction::Mnemonic, Code::Offset);
	void Jump (Instruction::Mnemonic, const Code::Operand&);
	void Convert (const Code::Operand&, const Code::Operand&);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void Branch (Instruction::Mnemonic, const Label&, const Instruction&);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Compare (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, Index);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static bool IsOperand (Immediate);
	static bool IsComplex (const Code::Operand&);
	static Instruction::Mnemonic GetLoadMnemonic (const Code::Type&);
	static Instruction::Mnemonic GetStoreMnemonic (const Code::Type&);
	static Instruction::Mnemonic GetImmediate (Instruction::Mnemonic);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (SmartOperand&&) noexcept;
	SmartOperand (Context&, OR1K::Register);
	~SmartOperand ();

private:
	Context* context = nullptr;
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c) :
	Assembly::Generator {d, sp, assembler, "or1k", "OpenRISC 1000", {{4, 1, 4}, {4, 4, 4}, 4, 4, {0, 4, 4}, true}, true}, assembler {d, c}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const OR1K::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}
{
	Acquire (R0);
	for (auto& set: registers) for (auto& register_: set) register_ = R0;
	Acquire (registers[Low][Code::RSP] = R1); Acquire (registers[Low][Code::RFP] = R2); Acquire (registers[Low][Code::RLink] = R9);
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
	auto register_ = R3; while (register_ != R31 && acquired[register_]) register_ = Register (register_ + 1);
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
	if (IsImmediate (operand) && !Extract (operand, index)) return R0;
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
		Load (register_, Extract (operand, index));
		break;

	case Code::Operand::Address:
		Load (register_, operand.address, operand.displacement);
		if (operand.register_ != Code::RVoid) Emit (LADD {register_, register_, registers[Low][operand.register_]});
		break;

	case Code::Operand::Register:
		if (GetRegister (register_) == registers[index][operand.register_] && !operand.displacement) break;
		if (!operand.displacement) Emit (LADD {register_, R0, registers[index][operand.register_]});
		else if (IsOperand (operand.displacement)) Emit (LADDI {register_, registers[index][operand.register_], Immediate (operand.displacement)});
		else Load (register_, operand.displacement), Emit (LADD {register_, register_, registers[index][operand.register_]});
		break;

	case Code::Operand::Memory:
		Access (register_, operand, index);
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
			Emit (LADD {registers[index][operand.register_], register_, R0});
		break;

	case Code::Operand::Memory:
		Access (operand, register_, index);
		break;

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Access (const Operand& register_, const Code::Operand& operand, const Index index)
{
	assert (IsMemory (operand));
	if (operand.address.empty () && IsOperand (operand.displacement)) return Emit ({GetLoadMnemonic (operand.type), register_, {Immediate (operand.displacement), operand.register_ != Code::RVoid ? registers[Low][operand.register_] : R0}});
	auto base = Acquire (); if (operand.address.empty ()) Load (base, operand.displacement); else Load (base, operand.address, operand.displacement + index * 4);
	if (operand.register_ != Code::RVoid) Emit (LADD {base, base, registers[index][operand.register_]}); Emit ({GetLoadMnemonic (operand.type), register_, {0, GetRegister (base)}});
}

void Context::Access (const Code::Operand& operand, const Operand& register_, const Index index)
{
	assert (IsMemory (operand));
	if (operand.address.empty () && IsOperand (operand.displacement)) return Emit ({GetStoreMnemonic (operand.type), {Immediate (operand.displacement), operand.register_ != Code::RVoid ? registers[Low][operand.register_] : R0}, register_});
	auto base = Acquire (); if (operand.address.empty ()) Load (base, operand.displacement); else Load (base, operand.address, operand.displacement + index * 4);
	if (operand.register_ != Code::RVoid) Emit (LADD {base, base, registers[index][operand.register_]}); Emit ({GetStoreMnemonic (operand.type), {0, GetRegister (base)}, register_});
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction)); instruction.Emit (Reserve (4));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Load (const Operand& register_, Immediate immediate)
{
	if (IsOperand (immediate)) return Emit (LADDI {register_, R0, immediate});
	Emit (LMOVHI {register_, immediate >> 16 & 0xffff}); immediate &= 0xffff;
	if (immediate) Emit (LORI {register_, register_, immediate});
}

void Context::Load (const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement)
{
	Emit (Instruction::LMOVHI, register_, address, displacement, 16);
	Emit (Instruction::LORI, register_, register_, address, displacement, 0);
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Code::Section::Name& address, const Code::Displacement displacement)
{
	const Instruction instruction {mnemonic, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), 0};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t', nullptr, address, displacement, 0) << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand& register_, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, register_, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << register_ << ", ", nullptr, address, displacement, scale) << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const Operand& register1, const Operand& register2, const Code::Section::Name& address, const Code::Displacement displacement, const Object::Patch::Scale scale)
{
	const Instruction instruction {mnemonic, register1, register2, 0};
	Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (displacement), scale};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (4));
	if (listing) WriteAddress (listing << '\t' << mnemonic << '\t' << register1 << ", " << register2 << ", ", nullptr, address, displacement, scale) << '\n';
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	auto high = false; for (auto& type: types) if (type.size == 8) high = true;
	assert (!registers[Low][register_]); Acquire (registers[Low][register_] = (register_ == Code::RRes ? R11 : GetFree ()));
	assert (!registers[High][register_]); if (high) Acquire (registers[High][register_] = (register_ == Code::RRes ? R12 : GetFree ()));
}

void Context::Release (const Code::Register register_)
{
	assert (registers[Low][register_]); Release (registers[Low][register_]); registers[Low][register_] = R0;
	if (registers[High][register_]) Release (registers[High][register_]), registers[High][register_] = R0;
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	auto& operand1 = instruction.operand1;
	auto& operand2 = instruction.operand2;
	auto& operand3 = instruction.operand3;

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
	case Code::Instruction::PUSH:
	case Code::Instruction::POP:
	case Code::Instruction::TRAP:
		return true;

	case Code::Instruction::NEG:
	case Code::Instruction::LSH:
	case Code::Instruction::RSH:
		return !IsComplex (operand1);

	case Code::Instruction::MOD:
		return IsImmediate (operand3) && IsPowerOfTwo (Code::Convert (operand3));

	default:
		return (!IsFloat (operand1) || !IsComplex (operand1)) && (!IsFloat (operand2) || !IsComplex (operand2));
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
		Convert (operand1, operand2);
		break;

	case Code::Instruction::COPY:
		Copy (operand1, operand2, operand3);
		break;

	case Code::Instruction::FILL:
		Fill (operand1, operand2, operand3);
		break;

	case Code::Instruction::NEG:
		if (IsFloat (operand1)) Operation (Instruction::LFSUBS, operand1, Code::Imm {operand1.type, 0}, operand2, Low);
		else Operation (Instruction::LSUB, operand1, Code::Imm {operand1.type, 0}, operand2, Low);
		break;

	case Code::Instruction::ADD:
		if (IsFloat (operand1)) Operation (Instruction::LFADDS, operand1, operand2, operand3, Low);
		else if (IsComplex (operand1)) Operation (Instruction::LADD, operand1, operand2, operand3, Low), Operation (Instruction::LADDC, operand1, operand2, operand3, High);
		else Operation (Instruction::LADD, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::SUB:
		if (IsFloat (operand1)) Operation (Instruction::LFSUBS, operand1, operand2, operand3, Low);
		else Operation (Instruction::LSUB, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MUL:
		if (IsFloat (operand1)) Operation (Instruction::LFMULS, operand1, operand2, operand3, Low);
		else Operation (Instruction::LMUL, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::DIV:
		if (IsFloat (operand1)) Operation (Instruction::LFDIVS, operand1, operand2, operand3, Low);
		else Operation (Instruction::LDIV, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::MOD:
		Operation (Instruction::LAND, operand1, operand2, Code::Imm (operand3.type, Extract (operand3, Low) - 1), Low);
		if (IsComplex (operand1)) Operation (Instruction::LAND, operand1, operand2, Code::Imm (operand3.type, Extract (operand3, High) - 1), High);
		break;

	case Code::Instruction::NOT:
		Operation (Instruction::LXOR, operand1, operand2, Code::Imm {operand1.type, -1}, Low);
		if (IsComplex (operand1)) Operation (Instruction::LXOR, operand1, operand2, Code::Imm {operand1.type, -1}, High);
		break;

	case Code::Instruction::AND:
		Operation (Instruction::LAND, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::LAND, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::OR:
		Operation (Instruction::LOR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::LOR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::XOR:
		Operation (Instruction::LXOR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::LXOR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::LSH:
		Operation (Instruction::LSLL, operand1, operand2, operand3, Low);
		break;

	case Code::Instruction::RSH:
		Operation (IsSigned (operand1) ? Instruction::LSRA : Instruction::LSRL, operand1, operand2, operand3, Low);
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
		if (IsAddress (operand1)) Emit (Instruction::LJAL, operand1.address, operand1.displacement);
		else Jump (Instruction::LJALR, operand1); Emit (LNOP {0});
		if (operand2.size) Emit (LADDI {R1, R1, Immediate (operand2.size)});
		break;

	case Code::Instruction::RET:
		Emit (LLWZ {R9, {0, R1}}); Emit (LJR {R9}); Emit (LADDI {R1, R1, 4});
		break;

	case Code::Instruction::ENTER:
		Emit (LADDI {R1, R1, -4}); Emit (LSW {{0, R1}, R2}); Emit (LADD {R2, R0, R1});
		if (operand1.size) Emit (LADDI {R1, R1, -Immediate (operand1.size)});
		break;

	case Code::Instruction::LEAVE:
		Emit (LADD {R1, R0, R2}); Emit (LLWZ {R2, {0, R1}}); Emit (LADDI {R1, R1, 4});
		break;

	case Code::Instruction::BR:
		Branch (Instruction::LJ, operand1.offset);
		break;

	case Code::Instruction::BREQ:
		if (IsFloat (operand2)) Compare (Instruction::LFSFEQS, operand2, operand3, Low);
		else if (IsComplex (operand2)) Compare (Instruction::LSFEQ, operand2, operand3, High), Branch (Instruction::LBNF, 0), Compare (Instruction::LSFEQ, operand2, operand3, Low);
		else Compare (Instruction::LSFEQ, operand2, operand3, Low); Branch (Instruction::LBF, operand1.offset);
		break;

	case Code::Instruction::BRNE:
		if (IsFloat (operand2)) Compare (Instruction::LFSFNES, operand2, operand3, Low);
		else if (IsComplex (operand2)) Compare (Instruction::LSFNE, operand2, operand3, High), Branch (Instruction::LBNF, 0), Compare (Instruction::LSFNE, operand2, operand3, Low);
		else Compare (Instruction::LSFNE, operand2, operand3, Low); Branch (Instruction::LBF, operand1.offset);
		break;

	case Code::Instruction::BRLT:
		if (IsFloat (operand2)) Compare (Instruction::LFSFLTS, operand2, operand3, Low);
		else if (IsComplex (operand2)) Compare (IsSigned (operand2) ? Instruction::LSFLTS : Instruction::LSFLTU, operand2, operand3, High), Branch (Instruction::LBNF, 0), Compare (Instruction::LSFLTU, operand2, operand3, Low);
		else Compare (IsSigned (operand2) ? Instruction::LSFLTS : Instruction::LSFLTU, operand2, operand3, Low); Branch (Instruction::LBF, operand1.offset);
		break;

	case Code::Instruction::BRGE:
		if (IsFloat (operand2)) Compare (Instruction::LFSFGES, operand2, operand3, Low);
		else if (IsComplex (operand2)) Compare (IsSigned (operand2) ? Instruction::LSFGES : Instruction::LSFGEU, operand2, operand3, High), Branch (Instruction::LBNF, 0), Compare (Instruction::LSFGEU, operand2, operand3, Low);
		else Compare (IsSigned (operand2) ? Instruction::LSFGES : Instruction::LSFGEU, operand2, operand3, Low); Branch (Instruction::LBF, operand1.offset);
		break;

	case Code::Instruction::JUMP:
		if (IsAddress (operand1)) Emit (Instruction::LJ, operand1.address, operand1.displacement);
		else Jump (Instruction::LJR, operand1); Emit (LNOP {0});
		break;

	case Code::Instruction::TRAP:
		Emit (LTRAP {0});
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

void Context::Convert (const Code::Operand& target, const Code::Operand& value)
{
	const auto result = Acquire (target, Low); Load (result, value, Low);
	if (IsFloat (target) && !IsFloat (value)) Emit (LFITOFS {result, result});
	if (!IsFloat (target) && IsFloat (value)) Emit (LFFTOIS {result, result});
	if (target.type.size == 1) Emit ({IsSigned (value) ? Instruction::LEXTBS : Instruction::LEXTBZ, result, result});
	if (target.type.size == 2) Emit ({IsSigned (value) ? Instruction::LEXTHS : Instruction::LEXTHZ, result, result});
	Store (result, target, Low); if (!IsComplex (target)) return; const auto high = Acquire (target, High);
	if (IsComplex (value)) Load (high, value, High); else if (IsSigned (target)) Emit (LSRAI {high, result, 31}); else Emit (LADD {high, R0, R0});
	Store (high, target, High);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	const auto targetAddress = Acquire (); Load (targetAddress, target, Low);
	const auto sourceAddress = Acquire (); Load (sourceAddress, source, Low);
	const auto count = Acquire (); Load (count, size, Low);
	if (!IsImmediate (size)) if (!IsImmediate (size)) Emit (LSFEQI {count, 0}), Branch (Instruction::LBF, 0);
	auto begin = CreateLabel (); begin (); const auto value = Acquire ();
	const Code::Type::Size increment = IsImmediate (size) ? Extract (size, Low) % 4 == 0 ? 4 : Extract (size, Low) % 2 == 0 ? 2 : 1 : 1;
	Emit ({GetLoadMnemonic (Code::Unsigned {increment}), value, {0, GetRegister (sourceAddress)}});
	Emit ({GetStoreMnemonic (Code::Unsigned {increment}), {0, GetRegister (targetAddress)}, value});
	Emit (LADDI {count, count, -Immediate (increment)}); Emit (LSFEQI {count, 0}); Branch (Instruction::LBF, begin, LNOP {0});
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto count = Acquire (); Load (count, size, Low); if (!IsImmediate (size)) Emit (LSFEQI {count, 0}), Branch (Instruction::LBF, 0);
	const auto address = Acquire (), low = Load (value, Low), high = IsComplex (value) ? Load (value, High) : R0; Load (address, target, Low);
	auto begin = CreateLabel (); begin (); Emit ({GetStoreMnemonic (value.type), {0, GetRegister (address)}, low});
	if (IsComplex (value)) Emit ({GetStoreMnemonic (value.type), {4, GetRegister (address)}, high});
	Emit (LADDI {count, count, -1}); Emit (LSFEQI {count, 0}); Branch (Instruction::LBF, begin, LADDI {address, address, Immediate (value.type.size)});
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto value = Load (value1, index), result = Acquire (target, index);
	if (IsImmediate (value2) && IsOperand (Extract (value2, index)))
		if (const auto immediate = GetImmediate (mnemonic)) return Emit ({immediate, result, value, Extract (value2, index)}), Store (result, target, index);
	Emit ({mnemonic, result, value, Load (value2, index)}); Store (result, target, index);
}

void Context::Push (const Code::Operand& value, const Index index)
{
	Emit ({GetStoreMnemonic (value.type), {-4, R1}, Load (value, index)}); Emit (LADDI {R1, R1, -4});
}

void Context::Pop (const Code::Operand& target, const Index index)
{
	const auto result = Acquire (target, index);
	Emit ({GetLoadMnemonic (target.type), result, {0, R1}});
	Store (result, target, index); Emit (LADDI {R1, R1, 4});
}

void Context::Jump (const Instruction::Mnemonic mnemonic, const Code::Operand& target)
{
	const auto address = Load (target, Low); Emit ({mnemonic, address});
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Code::Offset offset)
{
	Branch (mnemonic, GetLabel (offset), LNOP {0});
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const Label& label, const Instruction& delay)
{
	AddFixup (label, mnemonic, 4); if (listing) listing << '\t' << mnemonic << '\t' << label << '\n'; Emit (delay);
}

void Context::Compare (const Instruction::Mnemonic mnemonic, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	const auto value = Load (value1, index);
	if (IsImmediate (value2) && IsOperand (Extract (value2, index)))
		if (const auto immediate = GetImmediate (mnemonic)) return Emit ({immediate, value, Extract (value2, index)});
	Emit ({mnemonic, value, Load (value2, index)});
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	Instruction {Instruction::Mnemonic (code), Immediate (target - bytes.begin ())}.Emit (bytes);
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

bool Context::IsOperand (const Immediate immediate)
{
	return immediate >= -32768 && immediate <= 32767;
}

bool Context::IsComplex (const Code::Operand& operand)
{
	return operand.type.size == 8;
}

Instruction::Mnemonic Context::GetLoadMnemonic (const Code::Type& type)
{
	switch (type.size)
	{
	case 1: return type.model == Code::Type::Signed ? Instruction::LLBS : Instruction::LLBZ;
	case 2: return type.model == Code::Type::Signed ? Instruction::LLHS : Instruction::LLHZ;
	case 4: case 8: return type.model == Code::Type::Signed ? Instruction::LLWS : Instruction::LLWZ;
	default: assert (Code::Type::Unreachable);
	}
}

Instruction::Mnemonic Context::GetStoreMnemonic (const Code::Type& type)
{
	switch (type.size)
	{
	case 1: return Instruction::LSB;
	case 2: return Instruction::LSH;
	case 4: case 8: return Instruction::LSW;
	default: assert (Code::Type::Unreachable);
	}
}

Instruction::Mnemonic Context::GetImmediate (const Instruction::Mnemonic mnemonic)
{
	switch (mnemonic)
	{
	case Instruction::LADD: return Instruction::LADDI;
	case Instruction::LADDC: return Instruction::LADDIC;
	case Instruction::LMUL: return Instruction::LMULI;
	case Instruction::LOR: return Instruction::LORI;
	case Instruction::LANDI: return Instruction::LANDI;
	case Instruction::LXORI: return Instruction::LXORI;
	case Instruction::LSLL: return Instruction::LSLLI;
	case Instruction::LSRA: return Instruction::LSRAI;
	case Instruction::LSRL: return Instruction::LSRLI;
	case Instruction::LSFEQ: return Instruction::LSFEQI;
	case Instruction::LSFNE: return Instruction::LSFNEI;
	case Instruction::LSFLTS: return Instruction::LSFLTSI;
	case Instruction::LSFLTU: return Instruction::LSFLTUI;
	case Instruction::LSFGTS: return Instruction::LSFGTSI;
	case Instruction::LSFGTU: return Instruction::LSFGTUI;
	default: return {};
	}
}

SmartOperand::SmartOperand (Context& c, const OR1K::Register register_) :
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

// ARM machine code generator
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

#include "arm.hpp"
#include "armgenerator.hpp"
#include "asmgeneratorcontext.hpp"

using namespace ECS;
using namespace ARM;

using Context =
	#include "armgeneratorcontext.hpp"

Generator::Generator (Diagnostics& d, StringPool& sp, Assembly::Assembler& a, const Target t, const Name n, const FloatingPointExtension fpe) :
	Assembly::Generator {d, sp, a, t, n, {{4, 1, 8}, {fpe ? 8u : 4u, 4, 4}, 4, 4, {0, 4, 4}, true}, true}, floatingPointExtension {fpe}
{
}

Context::Context (const Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}, floatingPointExtension {g.floatingPointExtension}
{
	for (auto& set: registers) for (auto& register_: set) register_ = R15;
	Acquire (registers[Low][Code::RSP] = SP); Acquire (registers[Low][Code::RFP] = R11); Acquire (registers[Low][Code::RLink] = LR); Acquire (R15);
}

void Context::Acquire (const Register register_)
{
	assert (register_ < 32); assert (!acquired[register_]); acquired[register_] = true;
}

void Context::Release (const Register register_)
{
	assert (register_ < 32); assert (acquired[register_]); acquired[register_] = false;
}

Register Context::GetFree (const Index index) const
{
	auto register_ = index == Float ? D1 : R2; while (register_ % 16 && acquired[register_]) register_ = Register (register_ + 1);
	if (register_ % 16 == 0) throw RegisterShortage {}; return register_;
}

Register Context::Select (const Code::Operand& operand, const Index index) const
{
	assert (IsRegister (operand)); return Translate (registers[index][operand.register_], operand.type);
}

Immediate Context::Extract (const Code::Operand& operand, const Index index) const
{
	assert (IsImmediate (operand)); return Immediate (Code::Convert (operand) >> index * 32);
}

Register Context::Translate (const Register register_, const Code::Type& type) const
{
	return floatingPointExtension && type.model == Code::Type::Float && type.size == 4 ? Register ((register_ - D0) * 2 + S0) : register_;
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	auto high = false, floating = false;
	for (auto& type: types) if (floatingPointExtension && type.model == Code::Type::Float) floating = true; else if (type.size == 8) high = true;
	assert (registers[Low][register_] == R15); Acquire (registers[Low][register_] = (register_ == Code::RRes ? R0 : GetFree (Low)));
	assert (registers[High][register_] == R15); if (high) Acquire (registers[High][register_] = (register_ == Code::RRes ? R1 : GetFree (High)));
	assert (registers[Float][register_] == R15); if (floating) Acquire (registers[Float][register_] = (register_ == Code::RRes ? D0 : GetFree (Float)));
}

void Context::Release (const Code::Register register_)
{
	assert (registers[Low][register_] != R15); Release (registers[Low][register_]); registers[Low][register_] = R15;
	if (registers[High][register_] != R15) Release (registers[High][register_]), registers[High][register_] = R15;
	if (registers[Float][register_] != R15) Release (registers[Float][register_]), registers[Float][register_] = R15;
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

	case Code::Instruction::CONV:
		return floatingPointExtension ? IsFloat (operand1) == IsFloat (operand2) || IsFloat (operand1) && !IsComplex (operand2) || IsFloat (operand2) && !IsComplex (operand1) : !IsFloat (operand1) && !IsFloat (operand2);

	case Code::Instruction::MUL:
		return floatingPointExtension || !IsFloat (operand1);

	case Code::Instruction::DIV:
	case Code::Instruction::MOD:
		return floatingPointExtension ? IsFloat (operand1) || !IsComplex (operand1) : IsImmediate (operand3) && IsPowerOfTwo (Code::Convert (operand3));

	case Code::Instruction::LSH:
	case Code::Instruction::RSH:
		return !IsComplex (operand1);

	default:
		return floatingPointExtension || !IsFloat (operand1) && !IsFloat (operand2);
	}
}

Context::Part Context::GetRegisterParts (const Code::Operand& operand) const
{
	return (IsComplex (operand) && (!floatingPointExtension || !IsFloat (operand))) + 1;
}

Context::Suffix Context::GetRegisterSuffix (const Code::Operand& operand, const Part part) const
{
	return IsComplex (operand) ? part == High ? 'h' : 'l' : 0;
}

std::ostream& Context::WriteRegister (std::ostream& stream, const Code::Operand& operand, const Part part)
{
	return stream << Translate (registers[IsFloat (operand) ? Float : Index (part)][operand.register_], operand.type);
}

Suffix Context::GetSuffix (const Code::Operand& operand) const
{
	return IsFloat (operand) && floatingPointExtension ? IsComplex (operand) ? SF64 : SF32 : None;
}

Instruction::Mnemonic Context::GetLoadMnemonic (const Code::Type& type) const
{
	switch (type.size)
	{
	case 1: return type.model == Code::Type::Signed ? Instruction::LDRSB : Instruction::LDRB;
	case 2: return type.model == Code::Type::Signed ? Instruction::LDRSH : Instruction::LDRH;
	case 4: case 8: return floatingPointExtension && type.model == Code::Type::Float ? Instruction::VLDR : Instruction::LDR;
	default: assert (Code::Type::Unreachable);
	}
}

Instruction::Mnemonic Context::GetStoreMnemonic (const Code::Type& type) const
{
	switch (type.size)
	{
	case 1: return Instruction::STRB;
	case 2: return Instruction::STRH;
	case 4: case 8: return floatingPointExtension && type.model == Code::Type::Float ? Instruction::VSTR : Instruction::STR;
	default: assert (Code::Type::Unreachable);
	}
}

Register Context::TranslateBack (const Register register_)
{
	return register_ >= S0 ? Register ((register_ - S0) / 2 + D0) : register_;
}

bool Context::IsComplex (const Code::Operand& operand)
{
	return operand.type.size == 8;
}

Code::Type::Size Context::GetSize (const Code::Operand& operand)
{
	return operand.type.size;
}

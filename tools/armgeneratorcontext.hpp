// ARM machine code generator context
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

#ifndef ECS_ARM_GENERATOR_CONTEXT_HEADER_INCLUDED
#define ECS_ARM_GENERATOR_CONTEXT_HEADER_INCLUDED

#include "arm.hpp"
#include "armgenerator.hpp"
#include "asmgeneratorcontext.hpp"

class ECS::ARM::Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

protected:
	enum Index {Low, High, Float};

	const FloatingPointExtension floatingPointExtension;

	bool acquired[32] {};
	Register registers[3][Code::Registers];

	void Acquire (Register);
	void Release (Register);

	Register GetFree (Index) const;
	Register Select (const Code::Operand&, Index) const;
	Immediate Extract (const Code::Operand&, Index) const;
	Register Translate (Register, const Code::Type&) const;

	ARM::Suffix GetSuffix (const Code::Operand&) const;
	Instruction::Mnemonic GetLoadMnemonic (const Code::Type&) const;
	Instruction::Mnemonic GetStoreMnemonic (const Code::Type&) const;

	auto Acquire (Code::Register, const Types&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static Register TranslateBack (Register);
	static bool IsComplex (const Code::Operand&);
	static Code::Type::Size GetSize (const Code::Operand&);
};

#endif // ECS_ARM_GENERATOR_CONTEXT_HEADER_INCLUDED

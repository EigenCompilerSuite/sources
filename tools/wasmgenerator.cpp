// WebAssembly machine code generator
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
#include "wasm.hpp"
#include "wasmgenerator.hpp"

#include <deque>
#include <map>
#include <sstream>

using namespace ECS;
using namespace WebAssembly;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const WebAssembly::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	using BranchInstruction = const Code::Instruction*;
	using Local = Integer;

	std::vector<BranchInstruction> blocks;
	std::deque<BranchInstruction> branches;
	std::map<TypeCode, std::map<Code::Register, Local>> locals;
	Local count, cache[Code::Registers - Code::GeneralRegisters];

	bool IsLocal (Code::Register) const;
	void CollectLocals (const Code::Operand&);
	void CollectLocals (const Code::Instruction&);
	Local GetLocal (Code::Register, const Code::Type&);

	bool IsCached (Code::Register) const;
	void Cache (Code::Register, const Code::Type&);

	void Emit (const Instruction&);
	void Emit (const Object::Section::Name&, Object::Patch::Mode, Integer = 0);

	void LoadImmediate (const Code::Operand&);
	void LoadRegister (const Code::Type&, Code::Register, Integer = 0);
	void LoadAddress (const Code::Type&, const Object::Section::Name&, Integer);
	void LoadAddress (const Code::Type&, const Object::Section::Name&, Code::Register, Integer);
	void StoreRegister (const Code::Type&, Code::Register);

	void Load (const Code::Operand&);
	void LoadExtended (const Code::Operand&);
	void Store (const Code::Operand&);
	void Access (const Code::Operand&);
	void Access (const Code::Operand&, Instruction::Mnemonic);

	void BeginBlock (BranchInstruction);
	void EndBlock (BranchInstruction);

	void Extend (const Code::Type&);
	void Convert (const Code::Type&, const Code::Type&);
	void Branch (Instruction::Mnemonic, BranchInstruction);

	auto Generate (const Code::Instruction&) -> void override;
	auto GetAddress (const Code::Operand& operand) const -> Code::Section::Name override;
	auto GetPatchMode (const Code::Type&) const -> Object::Patch::Mode override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Postprocess (const Code::Section&) -> void override;
	auto Preprocess (const Code::Instruction&) -> void override;
	auto Preprocess (const Code::Section&) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static TypeCode GetTypeCode (const Code::Type&);
	static const Code::Instruction* GetExtent (BranchInstruction);
	static const Code::Instruction* GetOrigin (BranchInstruction);
	static const Code::Instruction* GetTarget (BranchInstruction);
	static Object::Section::Name GetGlobal (Code::Register, const Code::Type&);
	static Instruction::Mnemonic GetLoadMnemonic (const Code::Operand&);
	static Instruction::Mnemonic GetStoreMnemonic (const Code::Operand&);
	static Instruction::Mnemonic GetIntegerMnemonic (const Code::Type&, Instruction::Mnemonic, Instruction::Mnemonic);
	static Instruction::Mnemonic GetNumericMnemonic (const Code::Type&, Instruction::Mnemonic, Instruction::Mnemonic, Instruction::Mnemonic, Instruction::Mnemonic);
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c) :
	Assembly::Generator {d, sp, assembler, "wasm", "WebAssembly", {{4, 1, 8}, {8, 4, 8}, 4, 4, {0, 4, 4}, false}, false}, assembler {d, c}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const WebAssembly::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}
{
}

void Context::CollectLocals (const Code::Operand& operand)
{
	if (HasRegister (operand) && locals[GetTypeCode (IsMemory (operand) ? generator.platform.pointer : operand.type)].insert ({operand.register_, count}).second) ++count;
}

void Context::CollectLocals (const Code::Instruction& instruction)
{
	CollectLocals (instruction.operand1); CollectLocals (instruction.operand2); CollectLocals (instruction.operand3);
}

bool Context::IsLocal (const Code::Register register_) const
{
	return count && (IsGeneral (register_) || IsCached (register_));
}

Context::Local Context::GetLocal (const Code::Register register_, const Code::Type& type)
{
	assert (count); return locals[GetTypeCode (type)][register_];
}

bool Context::IsCached (const Code::Register register_) const
{
	assert (!IsGeneral (register_)); return cache[register_ - Code::GeneralRegisters] != count;
}

void Context::Cache (const Code::Register register_, const Code::Type& type)
{
	assert (!IsGeneral (register_)); if (count) Emit (LOCALTEE {cache[register_ - Code::GeneralRegisters] = GetLocal (register_, type)});
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction)); instruction.Emit (Reserve (GetSize (instruction)));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Emit (const Object::Section::Name& address, const Object::Patch::Mode mode, const Integer displacement)
{
	I32 instruction {Integer {0}}; Object::Patch patch {0, mode, Object::Patch::Displacement (displacement), 0};
	instruction.Adjust (patch); AddLink (address, patch); instruction.Emit (Reserve (GetSize (instruction)));
	if (listing) WriteAddress (listing << '\t' << Instruction::I32 << '\t', Assembly::GetFunction (mode), address, displacement, 0) << '\n';
}

void Context::LoadImmediate (const Code::Operand& operand)
{
	switch (operand.type.model)
	{
	case Code::Type::Signed: return operand.type.size != 8 ? Emit (I32CONST {operand.simm}) : Emit (I64CONST {operand.simm});
	case Code::Type::Unsigned: return operand.type.size < 4 ? Emit (I32CONST {Integer (Truncate (operand.uimm, operand.type.size * 8))}) : operand.type.size != 8 ? Emit (I32CONST {Truncate (Integer (operand.uimm), operand.type.size * 8)}) : Emit (I64CONST {Integer (operand.uimm)});
	case Code::Type::Float: return operand.type.size != 8 ? Emit (F32CONST {operand.fimm}) : Emit (F64CONST {operand.fimm});
	case Code::Type::Pointer: return operand.type.size != 8 ? Emit (I32CONST {Truncate (Integer (operand.ptrimm), operand.type.size * 8)}) : Emit (I64CONST {Integer (operand.ptrimm)});
	case Code::Type::Function: return Emit (I32CONST {Truncate (Integer (operand.funimm), 32)});
	default: assert (Code::Type::Unreachable);
	}
}

void Context::LoadRegister (const Code::Type& type, const Code::Register register_, const Integer displacement)
{
	if (IsLocal (register_)) Emit (LOCALGET {GetLocal (register_, type)}); else Emit (GLOBALGET {}), Emit (GetGlobal (register_, type), Object::Patch::Index);
	if (!IsGeneral (register_) && !IsCached (register_)) Cache (register_, type);
	if (displacement > 0) Emit ({GetIntegerMnemonic (type, Instruction::I32CONST, Instruction::I64CONST), displacement}), Emit (GetIntegerMnemonic (type, Instruction::I32ADD, Instruction::I64ADD));
	if (displacement < 0) Emit ({GetIntegerMnemonic (type, Instruction::I32CONST, Instruction::I64CONST), -displacement}), Emit (GetIntegerMnemonic (type, Instruction::I32SUB, Instruction::I64SUB));
}

void Context::StoreRegister (const Code::Type& type, const Code::Register register_)
{
	if (!IsGeneral (register_)) Cache (register_, type);
	if (IsLocal (register_) && IsGeneral (register_)) Emit (LOCALSET {GetLocal (register_, type)}); else Emit (GLOBALSET {}), Emit (GetGlobal (register_, type), Object::Patch::Index);
}

void Context::LoadAddress (const Code::Type& type, const Object::Section::Name& address, const Code::Register register_, const Integer displacement)
{
	if (address.empty ()) return LoadRegister (type, register_, displacement);
	Emit (GetIntegerMnemonic (type, Instruction::I32CONST, Instruction::I64CONST)); Emit (address, GetPatchMode (type), displacement);
	if (register_ != Code::RVoid) LoadRegister (type, register_), Emit (GetIntegerMnemonic (type, Instruction::I32ADD, Instruction::I64ADD));
}

void Context::Access (const Code::Operand& operand)
{
	if (!IsMemory (operand)) return; if (operand.address.empty () && operand.register_ == Code::RVoid) return LoadImmediate (operand);
	LoadAddress (generator.platform.pointer, operand.address, operand.register_, operand.displacement < 0 ? operand.displacement : 0);
}

void Context::Access (const Code::Operand& operand, const Instruction::Mnemonic mnemonic)
{
	Emit ({mnemonic, Integer {0}, Integer (operand.address.empty () && operand.register_ == Code::RVoid || operand.displacement < 0 ? 0 : operand.displacement)});
}

void Context::Load (const Code::Operand& operand)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
		return LoadImmediate (operand);

	case Code::Operand::Register:
		return LoadRegister (operand.type, operand.register_, operand.displacement);

	case Code::Operand::Address:
		return LoadAddress (operand.type, GetAddress (operand), operand.register_, operand.displacement);

	case Code::Operand::Memory:
		return Access (operand), Access (operand, GetLoadMnemonic (operand));

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::LoadExtended (const Code::Operand& operand)
{
	Load (operand);
	if (IsRegister (operand)) Extend (operand.type);
}

void Context::Store (const Code::Operand& operand)
{
	switch (operand.model)
	{
	case Code::Operand::Register:
		return StoreRegister (operand.type, operand.register_);

	case Code::Operand::Memory:
		return Access (operand, GetStoreMnemonic (operand));

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Preprocess (const Code::Section& section)
{
	branches.clear (); blocks.clear (); locals.clear (); count = 0; if (!IsCode (section.type)) return;
	for (auto& instruction: section.instructions) if (IsBranching (instruction.mnemonic)) branches.push_back (&instruction);
	std::sort (branches.begin (), branches.end (), [] (const BranchInstruction first, const BranchInstruction second) {return GetOrigin (first) < GetOrigin (second);});
	if (section.type != Code::Section::Code || IsEntryPoint (section)) return;
	if (section.group.empty ()) SetGroup ("_s10_codes");
	Emit (section.name, Object::Patch::Size, -5);
	for (auto& instruction: section.instructions) CollectLocals (instruction);
	Emit (VEC {Integer {Integer (locals.size ())}});
	for (auto& local: locals) Emit (U32 {Integer (local.second.size ())}), Emit (VALTYPE {local.first});
	for (auto& local: cache) local = count;
}

void Context::Postprocess (const Code::Section& section)
{
	while (!blocks.empty ()) EndBlock (blocks.back ());
	if (section.type != Code::Section::Code || IsEntryPoint (section)) return;
	Emit (END {}); AddSection (Code::Section::Header, '_' + section.name + "_function", section.required, section.duplicable, section.replaceable);
	for (auto& instruction: section.instructions) if (instruction.mnemonic == Code::Instruction::ALIAS) AddAlias ('_' + instruction.operand1.address + "_function");
	SetGroup ("_s02_functions"); Require (section.name); Emit ("_main_type", Object::Patch::Index);
}

void Context::Preprocess (const Code::Instruction& instruction)
{
	while (!blocks.empty () && GetExtent (blocks.back ()) <= &instruction) EndBlock (blocks.back ());
	while (!branches.empty () && GetOrigin (branches.front ()) == &instruction) BeginBlock (branches.front ()), branches.pop_front ();
}

void Context::BeginBlock (const BranchInstruction instruction)
{
	for (const auto block: blocks) if (block == instruction) return; const auto target = GetTarget (instruction);
	for (auto branch: branches) if (branch < target && GetTarget (branch) > target) BeginBlock (branch);
	blocks.push_back (instruction); Emit (target <= instruction ? Instruction::LOOP : Instruction::BLOCK);
}

void Context::EndBlock (const BranchInstruction instruction)
{
	assert (!blocks.empty ()); assert (blocks.back () == instruction); blocks.pop_back (); Emit (END {});
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	switch (instruction.mnemonic)
	{
	case Code::Instruction::FILL:
		return instruction.operand3.type.size == 1;

	case Code::Instruction::JUMP:
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
		Access (operand1);
		Load (operand2);
		Store (operand1);
		break;

	case Code::Instruction::CONV:
		Access (operand1);
		Load (operand2);
		Convert (operand1.type, operand2.type);
		Store (operand1);
		break;

	case Code::Instruction::COPY:
		Load (operand1);
		Load (operand2);
		Load (operand3);
		Emit (MEMORYCOPY {});
		break;

	case Code::Instruction::FILL:
		Load (operand1);
		Load (operand3);
		Load (operand2);
		Emit (MEMORYFILL {});
		break;

	case Code::Instruction::NEG:
		Access (operand1);
		if (!IsFloat (operand1)) Emit ({GetIntegerMnemonic (operand1.type, Instruction::I32CONST, Instruction::I64CONST), Integer {0}});
		Load (operand2);
		Emit (GetNumericMnemonic (operand1.type, Instruction::I32SUB, Instruction::I64SUB, Instruction::F32NEG, Instruction::F64NEG));
		Store (operand1);
		break;

	case Code::Instruction::ADD:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		Emit (GetNumericMnemonic (operand1.type, Instruction::I32ADD, Instruction::I64ADD, Instruction::F32ADD, Instruction::F64ADD));
		Store (operand1);
		break;

	case Code::Instruction::SUB:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		Emit (GetNumericMnemonic (operand1.type, Instruction::I32SUB, Instruction::I64SUB, Instruction::F32SUB, Instruction::F64SUB));
		Store (operand1);
		break;

	case Code::Instruction::MUL:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		Emit (GetNumericMnemonic (operand1.type, Instruction::I32MUL, Instruction::I64MUL, Instruction::F32MUL, Instruction::F64MUL));
		Store (operand1);
		break;

	case Code::Instruction::DIV:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		if (IsSigned (operand1.type)) Emit (GetIntegerMnemonic (operand1.type, Instruction::I32DIV_S, Instruction::I64DIV_S));
		else Emit (GetNumericMnemonic (operand1.type, Instruction::I32DIV_U, Instruction::I64DIV_U, Instruction::F32DIV, Instruction::F64DIV));
		Store (operand1);
		break;

	case Code::Instruction::MOD:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		if (IsSigned (operand1.type)) Emit (GetIntegerMnemonic (operand1.type, Instruction::I32REM_S, Instruction::I64REM_S));
		else Emit (GetIntegerMnemonic (operand1.type, Instruction::I32REM_U, Instruction::I64REM_U));
		Store (operand1);
		break;

	case Code::Instruction::NOT:
		Access (operand1);
		Emit ({GetIntegerMnemonic (operand1.type, Instruction::I32CONST, Instruction::I64CONST), Integer {-1}});
		Load (operand2);
		Emit (GetIntegerMnemonic (operand1.type, Instruction::I32XOR, Instruction::I64XOR));
		Store (operand1);
		break;

	case Code::Instruction::AND:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		Emit (GetIntegerMnemonic (operand1.type, Instruction::I32AND, Instruction::I64AND));
		Store (operand1);
		break;

	case Code::Instruction::OR:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		Emit (GetIntegerMnemonic (operand1.type, Instruction::I32OR, Instruction::I64OR));
		Store (operand1);
		break;

	case Code::Instruction::XOR:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		Emit (GetIntegerMnemonic (operand1.type, Instruction::I32XOR, Instruction::I64XOR));
		Store (operand1);
		break;

	case Code::Instruction::LSH:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		Emit (GetIntegerMnemonic (operand1.type, Instruction::I32SHL, Instruction::I64SHL));
		Store (operand1);
		break;

	case Code::Instruction::RSH:
		Access (operand1);
		Load (operand2);
		Load (operand3);
		if (IsSigned (operand1.type)) Emit (GetIntegerMnemonic (operand1.type, Instruction::I32SHR_S, Instruction::I64SHR_S));
		else Emit (GetIntegerMnemonic (operand1.type, Instruction::I32SHR_U, Instruction::I64SHR_U));
		Store (operand1);
		break;

	case Code::Instruction::PUSH:
		LoadRegister (generator.platform.pointer, Code::RSP, -Integer (operand1.type.size));
		StoreRegister (generator.platform.pointer, Code::RSP);
		LoadRegister (generator.platform.pointer, Code::RSP);
		Load (operand1);
		Emit ({GetStoreMnemonic (operand1.type), Integer {0}, Integer {0}});
		break;

	case Code::Instruction::POP:
		Access (operand1);
		LoadRegister (generator.platform.pointer, Code::RSP);
		Emit ({GetLoadMnemonic (operand1.type), Integer {0}, Integer {0}});
		Store (operand1);
		LoadRegister (generator.platform.pointer, Code::RSP, Integer (operand1.type.size));
		StoreRegister (generator.platform.pointer, Code::RSP);
		break;

	case Code::Instruction::CALL:
		if (IsAddress (instruction.operand1)) Emit (CALL {}), Emit (GetAddress (operand1), Object::Patch::Index);
		else Load (operand1), Emit (CALL_INDIRECT {}), Emit ("_main_type", Object::Patch::Index), Emit ("_main_table", Object::Patch::Index);
		if (operand2.size) LoadRegister (generator.platform.pointer, Code::RSP, operand2.size), StoreRegister (generator.platform.pointer, Code::RSP);
		break;

	case Code::Instruction::RET:
		Emit (RETURN {});
		break;

	case Code::Instruction::ENTER:
		LoadRegister (generator.platform.pointer, Code::RSP, -Integer (generator.platform.pointer.size));
		StoreRegister (generator.platform.pointer, Code::RSP);
		LoadRegister (generator.platform.pointer, Code::RSP);
		LoadRegister (generator.platform.pointer, Code::RFP);
		Emit ({GetStoreMnemonic (generator.platform.pointer), Integer {0}, Integer {0}});
		LoadRegister (generator.platform.pointer, Code::RSP);
		StoreRegister (generator.platform.pointer, Code::RFP);
		if (operand1.size) LoadRegister (generator.platform.pointer, Code::RSP, -Integer (operand1.size)), StoreRegister (generator.platform.pointer, Code::RSP);
		break;

	case Code::Instruction::LEAVE:
		LoadRegister (generator.platform.pointer, Code::RFP);
		StoreRegister (generator.platform.pointer, Code::RSP);
		LoadRegister (generator.platform.pointer, Code::RSP);
		Emit ({GetLoadMnemonic (generator.platform.pointer), Integer {0}, Integer {0}});
		StoreRegister (generator.platform.pointer, Code::RFP);
		LoadRegister (generator.platform.pointer, Code::RSP, generator.platform.pointer.size);
		StoreRegister (generator.platform.pointer, Code::RSP);
		break;

	case Code::Instruction::BR:
		Branch (Instruction::BR, &instruction);
		break;

	case Code::Instruction::BREQ:
		LoadExtended (operand2);
		LoadExtended (operand3);
		Emit (GetNumericMnemonic (operand2.type, Instruction::I32EQ, Instruction::I64EQ, Instruction::F32EQ, Instruction::F64EQ));
		Branch (Instruction::BR_IF, &instruction);
		break;

	case Code::Instruction::BRNE:
		LoadExtended (operand2);
		LoadExtended (operand3);
		Emit (GetNumericMnemonic (operand2.type, Instruction::I32NE, Instruction::I64NE, Instruction::F32NE, Instruction::F64NE));
		Branch (Instruction::BR_IF, &instruction);
		break;

	case Code::Instruction::BRLT:
		LoadExtended (operand2);
		LoadExtended (operand3);
		if (IsSigned (operand2.type)) Emit (GetIntegerMnemonic (operand2.type, Instruction::I32LT_S, Instruction::I64LT_S));
		else Emit (GetNumericMnemonic (operand2.type, Instruction::I32LT_U, Instruction::I64LT_U, Instruction::F32LT, Instruction::F64LT));
		Branch (Instruction::BR_IF, &instruction);
		break;

	case Code::Instruction::BRGE:
		LoadExtended (operand2);
		LoadExtended (operand3);
		if (IsSigned (operand2.type)) Emit (GetIntegerMnemonic (operand2.type, Instruction::I32GE_S, Instruction::I64GE_S));
		else Emit (GetNumericMnemonic (operand2.type, Instruction::I32GE_U, Instruction::I64GE_U, Instruction::F32GE, Instruction::F64GE));
		Branch (Instruction::BR_IF, &instruction);
		break;

	case Code::Instruction::TRAP:
		Emit (UNREACHABLE {});
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Extend (const Code::Type& type)
{
	if (!IsFloat (type) && type.size < 4)
		if (!IsSigned (type)) Emit (I32CONST {(Integer {1} << type.size * 8) - 1}), Emit (I32AND {});
		else if (type.size == 1) Emit (I32EXTEND8_S {}); else if (type.size == 2) Emit (I32EXTEND16_S {});
}

void Context::Convert (const Code::Type& target, const Code::Type& source)
{
	if (target == source) return;

	if (IsFloat (target))
		if (IsFloat (source))
			Emit (GetIntegerMnemonic (target, Instruction::F32DEMOTE_F64, Instruction::F64PROMOTE_F32));
		else if (IsSigned (source))
			if (source.size != 8) Emit (GetIntegerMnemonic (target, Instruction::F32CONVERT_I32_S, Instruction::F64CONVERT_I32_S));
			else Emit (GetIntegerMnemonic (target, Instruction::F32CONVERT_I64_S, Instruction::F64CONVERT_I64_S));
		else
			if (source.size != 8) Emit (GetIntegerMnemonic (target, Instruction::F32CONVERT_I32_U, Instruction::F64CONVERT_I32_U));
			else Emit (GetIntegerMnemonic (target, Instruction::F32CONVERT_I64_U, Instruction::F64CONVERT_I64_U));
	else
		if (IsFloat (source))
			if (source.size != 8) Emit (GetIntegerMnemonic (target, Instruction::I32TRUNC_F32_S, Instruction::I64TRUNC_F32_S));
			else Emit (GetIntegerMnemonic (target, Instruction::I32TRUNC_F64_S, Instruction::I64TRUNC_F64_S));
		else if (source.size != 8 && target.size == 8)
			if (IsSigned (source)) Emit (I64EXTEND_I32_S {});
			else Emit (I64EXTEND_I32_U {});
		else if (source.size == 8 && target.size != 8)
			Emit (I32WRAP_I64 {});

	Extend (target);
}

void Context::Branch (const Instruction::Mnemonic mnemonic, const BranchInstruction instruction)
{
	for (const auto& block: blocks) if (block == instruction) Emit ({mnemonic, Integer (&blocks.back () - &block)});
}

Object::Section::Name Context::GetAddress (const Code::Operand& operand) const
{
	return operand.type.model == Code::Type::Function ? '_' + operand.address + "_function" : operand.address;
}

Object::Patch::Mode Context::GetPatchMode (const Code::Type& type) const
{
	return type.model == Code::Type::Function ? Object::Patch::Index : Object::Patch::Absolute;
}

std::ostream& Context::WriteRegister (std::ostream& stream, const Code::Operand& operand, const Part)
{
	return IsLocal (operand.register_) ? stream << GetLocal (operand.register_, operand.type) : stream << GetGlobal (operand.register_, operand.type);
}

const Code::Instruction* Context::GetOrigin (const BranchInstruction instruction)
{
	return std::min (instruction, GetTarget (instruction));
}

const Code::Instruction* Context::GetExtent (const BranchInstruction instruction)
{
	return std::max (instruction + 1, GetTarget (instruction));
}

const Code::Instruction* Context::GetTarget (const BranchInstruction instruction)
{
	assert (IsBranching (instruction->mnemonic)); return instruction + instruction->operand1.offset + 1;
}

TypeCode Context::GetTypeCode (const Code::Type& type)
{
	return type.model != Code::Type::Float ? type.size != 8 ? TypeCode::I32 : TypeCode::I64 : type.size != 8 ? TypeCode::F32 : TypeCode::F64;
}

Object::Section::Name Context::GetGlobal (const Code::Register register_, const Code::Type& type)
{
	std::stringstream stream {}; stream << '_' << register_;
	if (IsUser (register_)) stream << '_' << GetTypeCode (type);
	return stream.str ();
}

Instruction::Mnemonic Context::GetIntegerMnemonic (const Code::Type& type, const Instruction::Mnemonic i32, const Instruction::Mnemonic i64)
{
	return type.size != 8 ? i32 : i64;
}

Instruction::Mnemonic Context::GetNumericMnemonic (const Code::Type& type, const Instruction::Mnemonic i32, const Instruction::Mnemonic i64, const Instruction::Mnemonic f32, const Instruction::Mnemonic f64)
{
	return type.model != Code::Type::Float ? type.size != 8 ? i32 : i64 : type.size != 8 ? f32 : f64;
}

Instruction::Mnemonic Context::GetLoadMnemonic (const Code::Operand& operand)
{
	switch (operand.type.size)
	{
	case 1: return IsSigned (operand) ? Instruction::I32LOAD8_S : Instruction::I32LOAD8_U;
	case 2: return IsSigned (operand) ? Instruction::I32LOAD16_S : Instruction::I32LOAD16_U;
	case 4: return IsFloat (operand) ? Instruction::F32LOAD : Instruction::I32LOAD;
	case 8: return IsFloat (operand) ? Instruction::F64LOAD : Instruction::I64LOAD;
	default: assert (Code::Type::Unreachable);
	}
}

Instruction::Mnemonic Context::GetStoreMnemonic (const Code::Operand& operand)
{
	switch (operand.type.size)
	{
	case 1: return Instruction::I32STORE8;
	case 2: return Instruction::I32STORE16;
	case 4: return IsFloat (operand) ? Instruction::F32STORE : Instruction::I32STORE;
	case 8: return IsFloat (operand) ? Instruction::F64STORE : Instruction::I64STORE;
	default: assert (Code::Type::Unreachable);
	}
}

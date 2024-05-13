// AMD64 machine code generator
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

#include "amd64.hpp"
#include "amd64generator.hpp"
#include "asmgeneratorcontext.hpp"

using namespace ECS;
using namespace AMD64;

using Context = class Generator::Context : public Assembly::Generator::Context
{
public:
	Context (const AMD64::Generator&, Object::Binaries&, Debugging::Information&, std::ostream&);

private:
	enum Index {Low, High, Float};
	enum RegisterIndex {RA = RAX - RAX, RB = RBX - RAX, RC = RCX - RAX, RD = RDX - RAX, SP = RSP - RAX, BP = RBP - RAX, SI = RSI - RAX, DI = RDI - RAX, FP0 = 0};

	class SmartOperand;

	struct RegisterSetElement;
	struct RegisterTicket;

	using Offset = unsigned;
	using RegisterSet = std::vector<RegisterSetElement>;
	using RegisterTickets = std::list<RegisterTicket>;
	using Ticket = RegisterTickets::iterator;

	const OperatingMode mode;
	const MediaFloat mediaFloat;
	const DirectAddressing directAddressing;

	Offset stackSize = 0;
	RegisterTickets tickets;
	Offset legacyStackPointer = 0;
	RegisterSet general, floating;
	Ticket registers[3][Code::Registers];

	bool IsByte (RegisterIndex) const;
	bool IsIndex (RegisterIndex) const;
	bool IsComplex (const Code::Type&) const;
	bool IsBasic (const Code::Operand&) const;
	bool IsQWord (const Code::Operand&) const;
	bool IsComplex (const Code::Operand&) const;
	bool IsMediaFloat (const Code::Type&) const;
	bool IsIndexIncrement (RegisterIndex) const;
	bool IsLegacyFloat (const Code::Type&) const;
	bool IsMediaFloat (const Code::Operand&) const;
	bool IsLegacyFloat (const Code::Operand&) const;
	Operand::Size GetSize (const Code::Type&) const;
	bool IsIndexBaseIncrement (RegisterIndex) const;
	Operand::Size GetSize (const Code::Operand&) const;
	Code::Type GetParameterType (const Code::Operand&) const;
	bool IsAvailable (RegisterIndex, const Code::Type&) const;

	RegisterSet& GetRegisterSet (const Code::Type&);
	RegisterSetElement& GetRegisterSetElement (const Code::Type&, RegisterIndex);

	using Assembly::Generator::Context::Reserve;
	void Release (Ticket);
	void Reserve (Ticket);
	void Unreserve (Ticket);
	bool IsReserved (Ticket);
	bool IsUnmapped (Ticket);
	Register Access (Ticket);
	Ticket Acquire (const Code::Type&);
	Register AccessIndex (Code::Register);
	Register Access (Ticket, const Code::Type&);
	Operand AccessMem (Ticket, const Code::Type&);
	Ticket Acquire (RegisterIndex, const Code::Type&);

	void Prerelease (const Code::Operand&, Index);
	void ReleaseRegisterTicket (Code::Register, Index);
	Ticket GetRegisterTicket (Code::Register, Index) const;
	Ticket SetRegisterTicket (Code::Register, Ticket, Index);

	Register Select (RegisterIndex, const Code::Type&) const;

	Immediate Extract (const Code::Operand&, Index) const;
	Immediate Extract (const Code::Operand&, const Code::Type&, Index) const;

	Register Select (const Code::Operand&, Index);
	Register Select (const Code::Operand&, const Code::Type&, Index);

	SmartOperand GetTemporary (const Code::Type&);
	SmartOperand GetTemporary (const Code::Operand&, Index);
	SmartOperand GetTemporary (const Code::Operand&, const Code::Type&, Index);
	SmartOperand GetTemporary (const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);

	SmartOperand Access (const Code::Operand&, Index);
	SmartOperand Access (const Code::Operand&, const Code::Type&, Index);

	SmartOperand Load (const Code::Operand&, Index);
	SmartOperand Load (const Code::Operand&, const Code::Type&, Index);

	void Load (const SmartOperand&, const Code::Operand&, Index);
	void Load (const SmartOperand&, const Code::Operand&, const Code::Type&, Index);

	void Store (const SmartOperand&, const Code::Operand&, Index);
	void Store (const SmartOperand&, const Code::Operand&, const Code::Type&, Index);

	void LegacyFloatLoad (const Code::Operand&);
	void LegacyFloatStore (const Code::Operand&);

	void Emit (const Instruction&);
	void ModifyStackPointer (Instruction::Mnemonic, Immediate);
	void Emit (Instruction::Mnemonic, const SmartOperand&, const SmartOperand&, const Operand& = {});

	void Pop (const Code::Operand&, Index);
	void Push (const Code::Operand&, Index);
	void Branch (const Code::Operand&, Instruction::Mnemonic);
	void Not (const Code::Operand&, const Code::Operand&, Index);
	void Move (const Code::Operand&, const Code::Operand&, Index);
	void Negate (const Code::Operand&, const Code::Operand&, Index);
	void Convert (const Code::Operand&, const Code::Operand&, Index);
	void MediaFloatConvert (const Code::Operand&, const Code::Operand&);
	void LegacyFloatConvert (const Code::Operand&, const Code::Operand&);
	void Copy (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Fill (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Multiply (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Divide (const Code::Operand&, const Code::Operand&, const Code::Operand&, bool);
	void SignedMultiply (const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Shift (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void Operation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&, Index);
	void LegacyFloatOperation (Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);
	void MediaFloatOperation (Instruction::Mnemonic, Instruction::Mnemonic, const Code::Operand&, const Code::Operand&, const Code::Operand&);

	void Branch (Code::Offset, Instruction::Mnemonic = Instruction::JMP);
	void CompareAndBranch (Code::Offset, const Code::Operand&, const Code::Operand&, Instruction::Mnemonic, Index);

	auto Acquire (Code::Register, const Types&) -> void override;
	auto FixupInstruction (Span<Byte>, const Byte*, FixupCode) const -> void override;
	auto Generate (const Code::Instruction&) -> void override;
	auto GetRegisterParts (const Code::Operand&) const -> Part override;
	auto GetRegisterSuffix (const Code::Operand&, Part) const -> Suffix override;
	auto IsSupported (const Code::Instruction&) const -> bool override;
	auto Release (Code::Register) -> void override;
	auto WriteRegister (std::ostream&, const Code::Operand&, Part) -> std::ostream& override;

	static constexpr auto LegacyFPUInitialization = "_init_fpu";

	static bool IsDoublePrecision (const Code::Type&);
	static bool IsDoublePrecision (const Code::Operand&);

	static void Write (std::ostream&, const SmartOperand&);

	static Instruction::Mnemonic Transpose (Instruction::Mnemonic);
};

struct Context::RegisterTicket
{
	const Code::Type type;
	const RegisterIndex index;
	Offset offset = 0;

	RegisterTicket (RegisterIndex, const Code::Type&);
};

struct Context::RegisterSetElement
{
	std::size_t uses = 0;
	bool reserved = false;
	Ticket current, temporary;

	RegisterSetElement (Ticket);
};

using SmartOperand = class Context::SmartOperand : public Operand
{
public:
	using Operand::Operand;
	SmartOperand () = default;
	SmartOperand (const Operand&);
	SmartOperand (SmartOperand&&) noexcept;
	~SmartOperand ();

	SmartOperand (Context&, Ticket, AMD64::Register);
	SmartOperand (Context&, Ticket, const Code::Type&, AMD64::Register, Index = RVoid);

	SmartOperand (const Context&, const Code::Section::Name&, Code::Displacement);
	SmartOperand (const Context&, const Code::Type&, const Code::Section::Name&, Code::Displacement);

	operator AMD64::Register () const;

private:
	Context* context = nullptr;
	Code::Section::Name address;
	Code::Displacement displacement;
	Ticket ticket;

	friend void Context::Write (std::ostream&, const SmartOperand&);
	friend void Context::Emit (Instruction::Mnemonic, const SmartOperand&, const SmartOperand&, const Operand&);
};

Generator::Generator (Diagnostics& d, StringPool& sp, Charset& c, const OperatingMode m, const MediaFloat mf, const DirectAddressing da) :
	Assembly::Generator {d, sp, assembler, "amd", "AMD64", {{m == RealMode ? 2u : 4u, 1, m == LongMode ? 8u : 4u}, {8, 4, m == LongMode ? 8u : 4u}, m >> 3, m >> 3, {0, m >> 3, m == LongMode ? 8u : 4u}, true}, false},
	assembler {d, c, m}, mode {m}, mediaFloat {mf}, directAddressing {da}
{
}

void Generator::Process (const Code::Sections& sections, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	Context {*this, binaries, information, listing}.Process (sections);
}

Context::Context (const AMD64::Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l) :
	Assembly::Generator::Context {g, b, i, l, false}, mode {g.mode}, mediaFloat {g.mediaFloat}, directAddressing {g.directAddressing},
	general {mode == LongMode ? 16u : 8u, tickets.end ()}, floating {mediaFloat && mode == LongMode ? 16u : 8u, tickets.end ()}
{
	for (auto& set: registers) for (auto& ticket: set) ticket = tickets.end ();
	++general[RA].uses; if (mode != LongMode) ++general[RD].uses; ++floating[FP0].uses; ++general[RC].uses;
	Reserve (SetRegisterTicket (Code::RSP, Acquire (SP, generator.platform.pointer), Low));
	Reserve (SetRegisterTicket (Code::RFP, Acquire (BP, generator.platform.pointer), Low));
}

bool Context::IsDoublePrecision (const Code::Operand& operand)
{
	return IsDoublePrecision (operand.type);
}

bool Context::IsDoublePrecision (const Code::Type& type)
{
	assert (type.model == Code::Type::Float);
	return type.size == Operand::QWord;
}

bool Context::IsComplex (const Code::Operand& operand) const
{
	return IsComplex (operand.type);
}

bool Context::IsQWord (const Code::Operand& operand) const
{
	return GetSize (operand) == Operand::QWord && IsImmediate (operand) && !TruncatesPreserving (Extract (operand, Low), 32);
}

bool Context::IsMediaFloat (const Code::Type& type) const
{
	return type.model == Code::Type::Float && mediaFloat;
}

bool Context::IsMediaFloat (const Code::Operand& operand) const
{
	return IsMediaFloat (operand.type);
}

bool Context::IsLegacyFloat (const Code::Type& type) const
{
	return type.model == Code::Type::Float && !mediaFloat;
}

bool Context::IsLegacyFloat (const Code::Operand& operand) const
{
	return IsLegacyFloat (operand.type);
}

Operand::Size Context::GetSize (const Code::Operand& operand) const
{
	return GetSize (operand.type);
}

bool Context::IsComplex (const Code::Type& type) const
{
	return type.model != Code::Type::Float && type.size == Operand::QWord && mode != LongMode;
}

Operand::Size Context::GetSize (const Code::Type& type) const
{
	return IsComplex (type) ? Operand::DWord : Operand::Size (type.size);
}

bool Context::IsIndex (const RegisterIndex index) const
{
	return mode != RealMode || index == RB || index == BP || index == SI || index == DI;
}

bool Context::IsIndexBaseIncrement (const RegisterIndex index) const
{
	return mode != RealMode || index == RB || index == BP;
}

bool Context::IsIndexIncrement (const RegisterIndex index) const
{
	return mode != RealMode ? index != SP : index == SI || index == DI;
}

bool Context::IsByte (const RegisterIndex index) const
{
	return mode == LongMode || index == RA || index == RB || index == RC || index == RD;
}

bool Context::IsBasic (const Code::Operand& operand) const
{
	return IsImmediate (operand) || IsRegister (operand) || IsAddress (operand) && directAddressing || IsMemory (operand);
}

bool Context::IsAvailable (const RegisterIndex index, const Code::Type& type) const
{
	if (IsAddress (type)) return IsIndex (index);
	if (type.size == Operand::Byte) return IsByte (index);
	return true;
}

Code::Type Context::GetParameterType (const Code::Operand& operand) const
{
	return {IsFloat (operand) ? Code::Type::Unsigned : operand.type.model, generator.platform.GetStackSize (operand.type)};
}

Context::Ticket Context::GetRegisterTicket (const Code::Register register_, const Index index) const
{
	assert (registers[index][register_] != tickets.end ());
	return registers[index][register_];
}

Context::Ticket Context::SetRegisterTicket (const Code::Register register_, const Ticket ticket, const Index index)
{
	return registers[index][register_] = ticket;
}

void Context::ReleaseRegisterTicket (const Code::Register register_, const Index index)
{
	if (registers[index][register_] != tickets.end ()) Release (registers[index][register_]), registers[index][register_] = tickets.end ();
}

void Context::Prerelease (const Code::Operand& operand, const Index index)
{
	if (IsRegister (operand) && IsLastUseOf (operand.register_)) ReleaseRegisterTicket (operand.register_, index);
}

Context::RegisterSet& Context::GetRegisterSet (const Code::Type& type)
{
	return type.model == Code::Type::Float ? floating : general;
}

Context::RegisterSetElement& Context::GetRegisterSetElement (const Code::Type& type, const RegisterIndex index)
{
	return GetRegisterSet (type)[index];
}

void Context::Reserve (const Ticket ticket)
{
	auto& element = GetRegisterSetElement (ticket->type, ticket->index);
	assert (!element.reserved); element.reserved = true;
}

void Context::Unreserve (const Ticket ticket)
{
	auto& element = GetRegisterSetElement (ticket->type, ticket->index);
	assert (element.reserved); element.reserved = false; if (element.temporary == tickets.end ()) return;
	Release (element.temporary); element.temporary = tickets.end ();
}

bool Context::IsReserved (const Ticket ticket)
{
	return GetRegisterSetElement (ticket->type, ticket->index).reserved;
}

Context::Ticket Context::Acquire (const Code::Type& type)
{
	std::size_t index = 0; auto& set = GetRegisterSet (type);
	for (std::size_t use = 0; index == set.size () || set[index].reserved || !IsAvailable (RegisterIndex (index), type) || set[index].uses > use;)
		if (index == set.size ()) index = 0, ++use; else ++index;
	return Acquire (RegisterIndex (index), type);
}

Context::Ticket Context::Acquire (const RegisterIndex index, const Code::Type& type)
{
	++GetRegisterSetElement (type, index).uses;
	return tickets.emplace (tickets.end (), index, type);
}

bool Context::IsUnmapped (const Ticket ticket)
{
	auto& element = GetRegisterSetElement (ticket->type, ticket->index);
	return element.current == ticket || element.temporary == tickets.end () && !ticket->offset;
}

Register Context::Access (const Ticket ticket)
{
	return Access (ticket, ticket->type);
}

Register Context::Access (const Ticket ticket, const Code::Type& type)
{
	assert (ticket != tickets.end ());

	const auto register_ = Select (ticket->index, type);
	auto& element = GetRegisterSetElement (ticket->type, ticket->index);
	const auto current = element.current;
	if (current == ticket) return register_;

	if (element.temporary != tickets.end ())
		return Access (element.temporary, type);
	if (element.reserved && ticket->offset)
		return Access (element.temporary = Acquire (type), type);

	const Code::Type padded {type.model, mode == LongMode ? Operand::QWord : Operand::DWord};
	if (current != tickets.end ())
		if (ticket->offset)
			Emit (XCHG {mode, Select (current->index, padded), AccessMem (ticket, padded)}), std::swap (current->offset, ticket->offset);
		else if (current->offset)
			Emit (MOV {mode, AccessMem (current, padded), Select (current->index, padded)});
		else
			Emit (PUSH {mode, Select (current->index, padded)}), current->offset = stackSize += padded.size;

	element.current = ticket;

	if (ticket->offset)
		if (ticket->offset != stackSize)
			Emit (MOV {mode, Select (ticket->index, padded), AccessMem (ticket, padded)}), ticket->offset = 0;
		else
			Emit (POP {mode, Select (ticket->index, padded)}), ticket->offset = 0, stackSize -= padded.size;

	assert (!ticket->offset);
	return register_;
}

Operand Context::AccessMem (const Ticket ticket, const Code::Type& type)
{
	assert (ticket != tickets.end ());
	if (!ticket->offset || general[ticket->index].current == tickets.end ()) return Access (ticket, type);
	const auto index = AccessIndex (Code::RSP);
	return Mem {index, stackSize - ticket->offset, GetSize (type)};
}

Register Context::AccessIndex (const Code::Register register_)
{
	const auto ticket = GetRegisterTicket (register_, Low);
	const auto type = IsIndex (ticket->index) ? generator.platform.pointer : Code::Pointer {Operand::DWord};
	const auto index = Access (ticket, type);
	if (ticket->offset) Emit (MOV {mode, index, AccessMem (ticket, type)});
	return index;
}

void Context::Release (const Ticket ticket)
{
	assert (ticket != tickets.end ());
	auto& element = GetRegisterSetElement (ticket->type, ticket->index);

	if (element.current == ticket)
	{
		element.current = tickets.end ();

		for (auto previous = tickets.begin (); previous != tickets.end (); ++previous)
			if (previous->index == ticket->index && previous != ticket) {Access (previous); break;}
	}

	--element.uses;
	tickets.erase (ticket);

	Offset maxOffset = 0;
	for (auto& ticket: tickets) if (ticket.offset > maxOffset) maxOffset = ticket.offset;
	assert (maxOffset <= stackSize);
	ModifyStackPointer (Instruction::ADD, stackSize - maxOffset);
	stackSize = maxOffset;
}

Register Context::Select (const RegisterIndex index, const Code::Type& type) const
{
	if (IsMediaFloat (type)) return Register (XMM0 + index);
	if (IsLegacyFloat (type)) return Register (ST0 + (index + legacyStackPointer) % 8);
	if (type.size == Operand::Byte) return assert (IsByte (index)), Register ((mode == LongMode && index >= SP && index <= DI ? SPL - SP : AL) + index);
	if (type.size == Operand::Word) return Register (AX + index);
	if (type.size == Operand::QWord && mode == LongMode) return Register (RAX + index);
	return Register (EAX + index);
}

Immediate Context::Extract (const Code::Operand& operand, const Index index) const
{
	return Extract (operand, operand.type, index);
}

Immediate Context::Extract (const Code::Operand& operand, const Code::Type& type, const Index index) const
{
	assert (IsImmediate (operand));
	auto value = Immediate (Code::Convert (operand));
	if (IsSigned (operand)) value = Truncate (value, operand.type.size * 8);
	if (IsComplex (type)) value = (value >> index * 32) & 0xffffffff;
	return Truncate (value, type.size * 8);
}

Register Context::Select (const Code::Operand& operand, const Index index)
{
	return Select (operand, operand.type, index);
}

Register Context::Select (const Code::Operand& operand, const Code::Type& type, const Index index)
{
	assert (IsRegister (operand)); return Access (GetRegisterTicket (operand.register_, index), type);
}

SmartOperand Context::GetTemporary (const Code::Operand& operand, const Index index)
{
	return GetTemporary (operand, operand.type, index);
}

SmartOperand Context::GetTemporary (const Code::Operand& operand, const Code::Type& type, const Index index)
{
	if (IsRegister (operand) && (operand.type.model == Code::Type::Float) == (type.model == Code::Type::Float) && IsUnmapped (GetRegisterTicket (operand.register_, index)) && !IsReserved (GetRegisterTicket (operand.register_, index)))
		return Access (GetRegisterTicket (operand.register_, index), type);
	return GetTemporary (type);
}

SmartOperand Context::GetTemporary (const Code::Operand& operand, const Code::Operand& operand1, const Code::Operand& operand2, const Index index)
{
	if (HasRegister (operand) && HasRegister (operand2) && operand.register_ == operand2.register_) return GetTemporary (operand.type);
	if (IsRegister (operand1) && IsLastUseOf (operand1.register_)) return GetTemporary (operand1, operand.type, index);
	return GetTemporary (operand, operand.type, index);
}

SmartOperand Context::GetTemporary (const Code::Type& type)
{
	const auto temporary = Acquire (type); return {*this, temporary, Access (temporary, type)};
}

SmartOperand Context::Access (const Code::Operand& operand, const Index index)
{
	return Access (operand, operand.type, index);
}

SmartOperand Context::Access (const Code::Operand& operand, const Code::Type& type, const Index index)
{
	switch (operand.model)
	{
	case Code::Operand::Immediate:
	{
		if (!IsFloat (operand)) return Extract (operand, type, index);
		if (directAddressing) return {*this, type, DefineGlobal (operand), 0};
		const auto temporary = Acquire (generator.platform.pointer); const auto register_ = Access (temporary);
		Emit (Instruction::MOV, register_, {*this, DefineGlobal (operand), 0});
		return {*this, temporary, type, register_};
	}

	case Code::Operand::Register:
		assert (!operand.displacement);
		return AccessMem (GetRegisterTicket (operand.register_, index), type);

	case Code::Operand::Address:
		assert (operand.register_ == Code::RVoid);
		return {*this, operand.address, operand.displacement};

	case Code::Operand::Memory:
	{
		if (operand.register_ == Code::RVoid && directAddressing)
			if (operand.address.empty ()) return Mem {Immediate (operand.ptrimm) + (index == High) * Operand::DWord, GetSize (type)};
			else return {*this, type, operand.address, operand.displacement + (index == High) * Operand::DWord};
		if (operand.address.empty () && operand.register_ != Code::RVoid) return Mem {AccessIndex (operand.register_), operand.displacement + (index == High) * Operand::DWord + (operand.register_ == Code::RSP) * stackSize, GetSize (type)};
		const auto temporary = Acquire (generator.platform.pointer); const auto register_ = Access (temporary);
		if (operand.address.empty ()) Emit (MOV {mode, register_, Immediate (operand.ptrimm + (index == High) * Operand::DWord)});
		else Emit (Instruction::MOV, register_, {*this, operand.address, operand.displacement + (index == High) * Operand::DWord});
		const auto ticket = operand.register_ != Code::RVoid ? GetRegisterTicket (operand.register_, Low) : tickets.end ();
		if (operand.register_ != Code::RVoid) if (IsIndexIncrement (ticket->index) && IsIndexBaseIncrement (temporary->index))
			return {*this, temporary, type, register_, Access (ticket, generator.platform.pointer)};
		else if (IsIndexBaseIncrement (ticket->index) && IsIndexIncrement (temporary->index))
			return {*this, temporary, type, Access (ticket, generator.platform.pointer), register_};
		else Emit (ADD {mode, register_, AccessMem (ticket, generator.platform.pointer)});
		return {*this, temporary, type, register_};
	}

	default:
		assert (Code::Operand::Unreachable);
	}
}

SmartOperand Context::Load (const Code::Operand& operand, const Index index)
{
	return Load (operand, operand.type, index);
}

SmartOperand Context::Load (const Code::Operand& operand, const Code::Type& type, const Index index)
{
	auto register_ = GetTemporary (operand, type, index); Load (register_, operand, type, index); return register_;
}

void Context::Load (const SmartOperand& register_, const Code::Operand& operand, const Index index)
{
	Load (register_, operand, operand.type, index);
}

void Context::Load (const SmartOperand& register_, const Code::Operand& operand, const Code::Type& type, const Index index)
{
	assert (!IsLegacyFloat (type));

	switch (operand.model)
	{
	case Code::Operand::Immediate:
	{
		if (type.model == Code::Type::Float) return Emit (IsDoublePrecision (type) ? Instruction::MOVSD : Instruction::MOVSS, register_, Access (operand, type, index));
		const auto immediate = Extract (operand, type, index);
		if (!immediate && !index) return Emit (XOR {mode, register_, register_});
		return Emit (MOV {mode, register_, immediate});
	}

	case Code::Operand::Register:
	{
		const auto ticket = GetRegisterTicket (operand.register_, index);
		if (!operand.displacement && IsUnmapped (ticket) && Select (ticket->index, type) == register_) return;
		if (operand.displacement && IsIndex (ticket->index)) return Emit (LEA {mode, register_, Mem {AccessIndex (operand.register_), operand.displacement + (index == High) * Operand::DWord + (operand.register_ == Code::RSP) * stackSize}});
		Emit (IsFloat (operand) ? IsDoublePrecision (type) ? Instruction::MOVSD : Instruction::MOVSS : Instruction::MOV, register_, AccessMem (ticket, type));
		if (operand.displacement > 0) Emit (ADD {mode, register_, +operand.displacement});
		if (operand.displacement < 0) Emit (SUB {mode, register_, -operand.displacement});
		return;
	}

	case Code::Operand::Address:
		if (operand.register_ != Code::RVoid && IsUnmapped (GetRegisterTicket (operand.register_, index)) && Access (GetRegisterTicket (operand.register_, index), type) == register_)
			if (directAddressing) return Emit (Instruction::ADD, register_, {*this, operand.address, operand.displacement});
			else return Emit (Instruction::ADD, register_, Load (Code::Adr {type, operand.address, operand.displacement}, type, index));
		Emit (Instruction::MOV, register_, {*this, operand.address, operand.displacement});
		if (operand.register_ != Code::RVoid) Emit (ADD {mode, register_, AccessMem (GetRegisterTicket (operand.register_, index), type)});
		return;

	case Code::Operand::Memory:
		return Emit (type.model == Code::Type::Float ? IsDoublePrecision (type) ? Instruction::MOVSD : Instruction::MOVSS : Instruction::MOV, register_, Access (operand, type, index));

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::Store (const SmartOperand& register_, const Code::Operand& operand, const Index index)
{
	Store (register_, operand, operand.type, index);
}

void Context::Store (const SmartOperand& register_, const Code::Operand& operand, const Code::Type& type, const Index index)
{
	assert (!IsLegacyFloat (type));

	switch (operand.model)
	{
	case Code::Operand::Register:
	{
		assert (!operand.displacement);
		const auto ticket = GetRegisterTicket (operand.register_, index);
		if (IsUnmapped (ticket) && Select (ticket->index, type) == register_) return;
		return Emit (IsFloat (operand) ? IsDoublePrecision (type) ? Instruction::MOVSD : Instruction::MOVSS : Instruction::MOV, AccessMem (ticket, type), register_);
	}

	case Code::Operand::Memory:
		return Emit (IsFloat (operand) ? IsDoublePrecision (type) ? Instruction::MOVSD : Instruction::MOVSS : Instruction::MOV, Access (operand, type, index), register_);

	default:
		assert (Code::Operand::Unreachable);
	}
}

void Context::LegacyFloatLoad (const Code::Operand& operand)
{
	if (IsImmediate (operand)) if (operand.fimm == 0) return Emit (FLDZ {mode}); else if (operand.fimm == 1) return Emit (FLD1 {mode});
	if (IsRegister (operand) && Select (operand, operand.type, Float) == ST0) return;
	Emit (Instruction::FLD, Access (operand, Float), {});
}

void Context::LegacyFloatStore (const Code::Operand& operand)
{
	if (IsRegister (operand) && Select (operand, operand.type, Float) == ST1) return;
	Emit (Instruction::FSTP, Access (operand, Float), {});
}

void Context::Emit (const Instruction& instruction)
{
	assert (IsValid (instruction));
	instruction.Emit (Reserve (AMD64::GetSize (instruction)));
	if (listing) listing << '\t' << instruction << '\n';
}

void Context::Emit (const Instruction::Mnemonic mnemonic, const SmartOperand& operand1, const SmartOperand& operand2, const Operand& operand3)
{
	const Instruction instruction {mode, mnemonic, operand1, operand2, operand3}; assert (IsValid (instruction));
	const auto operand = !operand1.address.empty () ? &operand1 : !operand2.address.empty () ? &operand2 : nullptr;
	if (!operand) return Emit (instruction); Object::Patch patch {0, Object::Patch::Absolute, Object::Patch::Displacement (operand->displacement), 0};
	instruction.Adjust (patch); AddLink (operand->address, patch); instruction.Emit (Reserve (AMD64::GetSize (instruction)));
	if (!listing) return; Write (listing << '\t' << mnemonic << '\t', operand1);
	if (!IsEmpty (operand2)) Write (listing << ", ", operand2);
	if (!IsEmpty (operand3)) listing << ", " << operand3; listing << '\n';
}

void Context::ModifyStackPointer (const Instruction::Mnemonic mnemonic, const Immediate value)
{
	if (value) Emit ({mode, mnemonic, Select (SP, generator.platform.pointer), value});
}

void Context::Acquire (const Code::Register register_, const Types& types)
{
	const Code::Type *smallest = nullptr, *largest = nullptr, *floating = nullptr;
	for (auto& type: types)
		if (type.model == Code::Type::Float) floating = &type;
		else if (!smallest) smallest = &type, largest = &type;
		else if (type.size < smallest->size) smallest = &type;
		else if (type.size > largest->size) largest = &type;

	if (floating) SetRegisterTicket (register_, register_ == Code::RRes ? Acquire (FP0, *floating) : Acquire (*floating), Float);
	if (smallest) SetRegisterTicket (register_, register_ == Code::RRes ? Acquire (RA, *smallest) : Acquire (*smallest), Low);
	if (largest && IsComplex (*largest)) SetRegisterTicket (register_, register_ == Code::RRes ? Acquire (RD, *largest) : Acquire (*largest), High);
}

void Context::Release (const Code::Register register_)
{
	ReleaseRegisterTicket (register_, Low); ReleaseRegisterTicket (register_, High); ReleaseRegisterTicket (register_, Float);
}

bool Context::IsSupported (const Code::Instruction& instruction) const
{
	assert (IsValid (instruction));

	switch (instruction.mnemonic)
	{
	case Code::Instruction::FILL:
		return mode == LongMode || instruction.operand3.type.size != Operand::QWord;

	case Code::Instruction::MUL:
	case Code::Instruction::DIV:
	case Code::Instruction::MOD:
	case Code::Instruction::LSH:
	case Code::Instruction::RSH:
		return !IsComplex (instruction.operand3);

	case Code::Instruction::TRAP:
		return mode != RealMode;

	default:
		return true;
	}
}

void Context::Generate (const Code::Instruction& instruction)
{
	assert (IsSupported (instruction));

	const auto& operand1 = instruction.operand1;
	const auto& operand2 = instruction.operand2;
	const auto& operand3 = instruction.operand3;

	switch (instruction.mnemonic)
	{
	case Code::Instruction::MOV:
		Move (operand1, operand2, IsFloat (operand2) ? Float : Low);
		if (IsComplex (operand1)) Move (operand1, operand2, High);
		break;

	case Code::Instruction::CONV:
		if (IsMediaFloat (operand1) || IsMediaFloat (operand2)) return MediaFloatConvert (operand1, operand2);
		if (IsLegacyFloat (operand1) || IsLegacyFloat (operand2)) return LegacyFloatConvert (operand1, operand2);
		Convert (operand1, operand2, Low);
		if (IsComplex (operand1)) Convert (operand1, operand2, High);
		break;

	case Code::Instruction::COPY:
		Copy (operand1, operand2, operand3);
		break;

	case Code::Instruction::FILL:
		assert (!IsComplex (operand3));
		Fill (operand1, operand2, operand3);
		break;

	case Code::Instruction::NEG:
		if (IsMediaFloat (operand1)) MediaFloatOperation (Instruction::SUBSS, Instruction::SUBSD, operand1, Code::FImm {operand1.type, 0}, operand2);
		else if (IsLegacyFloat (operand1)) LegacyFloatOperation (Instruction::FSUB, operand1, Code::FImm {operand1.type, 0}, operand2);
		else Negate (operand1, operand2, Low);
		if (IsComplex (operand1)) Negate (operand1, operand2, High);
		break;

	case Code::Instruction::ADD:
		if (IsMediaFloat (operand1)) MediaFloatOperation (Instruction::ADDSS, Instruction::ADDSD, operand1, operand2, operand3);
		else if (IsLegacyFloat (operand1)) LegacyFloatOperation (Instruction::FADD, operand1, operand2, operand3);
		else Operation (Instruction::ADD, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::ADC, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::SUB:
		if (IsMediaFloat (operand1)) MediaFloatOperation (Instruction::SUBSS, Instruction::SUBSD, operand1, operand2, operand3);
		else if (IsLegacyFloat (operand1)) LegacyFloatOperation (Instruction::FSUB, operand1, operand2, operand3);
		else Operation (Instruction::SUB, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::SBB, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::MUL:
		if (IsMediaFloat (operand1)) MediaFloatOperation (Instruction::MULSS, Instruction::MULSD, operand1, operand2, operand3);
		else if (IsLegacyFloat (operand1)) LegacyFloatOperation (Instruction::FMUL, operand1, operand2, operand3);
		else if (IsSigned (operand1)) SignedMultiply (operand1, operand2, operand3);
		else Multiply (operand1, operand2, operand3);
		break;

	case Code::Instruction::DIV:
		if (IsMediaFloat (operand1)) MediaFloatOperation (Instruction::DIVSS, Instruction::DIVSD, operand1, operand2, operand3);
		else if (IsLegacyFloat (operand1)) LegacyFloatOperation (Instruction::FDIV, operand1, operand2, operand3);
		else Divide (operand1, operand2, operand3, false);
		break;

	case Code::Instruction::MOD:
		Divide (operand1, operand2, operand3, true);
		break;

	case Code::Instruction::NOT:
		Not (operand1, operand2, Low);
		if (IsComplex (operand1)) Not (operand1, operand2, High);
		break;

	case Code::Instruction::AND:
		Operation (Instruction::AND, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::AND, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::OR:
		Operation (Instruction::OR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::OR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::XOR:
		Operation (Instruction::XOR, operand1, operand2, operand3, Low);
		if (IsComplex (operand1)) Operation (Instruction::XOR, operand1, operand2, operand3, High);
		break;

	case Code::Instruction::LSH:
		Shift (IsSigned (operand1) ? Instruction::SAL : Instruction::SHL, operand1, operand2, operand3);
		break;

	case Code::Instruction::RSH:
		Shift (IsSigned (operand1) ? Instruction::SAR : Instruction::SHR, operand1, operand2, operand3);
		break;

	case Code::Instruction::PUSH:
		if (IsComplex (operand1)) Push (operand1, High); Push (operand1, Low);
		break;

	case Code::Instruction::POP:
		Pop (operand1, Low); if (IsComplex (operand1)) Pop (operand1, High);
		break;

	case Code::Instruction::CALL:
		Branch (operand1, Instruction::CALL);
		ModifyStackPointer (Instruction::ADD, operand2.size);
		break;

	case Code::Instruction::RET:
		Emit (RET {mode});
		break;

	case Code::Instruction::ENTER:
		Emit (PUSH {mode, Select (BP, generator.platform.pointer)});
		Emit (MOV {mode, Select (BP, generator.platform.pointer), Select (SP, generator.platform.pointer)});
		ModifyStackPointer (Instruction::SUB, operand1.size);
		break;

	case Code::Instruction::LEAVE:
		Emit (MOV {mode, Select (SP, generator.platform.pointer), Select (BP, generator.platform.pointer)});
		Emit (POP {mode, Select (BP, generator.platform.pointer)});
		break;

	case Code::Instruction::BR:
		Branch (operand1.offset);
		break;

	case Code::Instruction::BREQ:
		if (IsComplex (operand2)) CompareAndBranch (0, operand2, operand3, Instruction::JNE, High);
		CompareAndBranch (operand1.offset, operand2, operand3, Instruction::JE, Low);
		break;

	case Code::Instruction::BRNE:
		if (IsComplex (operand2)) CompareAndBranch (operand1.offset, operand2, operand3, Instruction::JNE, High);
		CompareAndBranch (operand1.offset, operand2, operand3, Instruction::JNE, Low);
		break;

	case Code::Instruction::BRLT:
		if (IsComplex (operand2)) CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) ? Instruction::JL : Instruction::JB, High), Branch (0, IsSigned (operand2) ? Instruction::JG : Instruction::JA);
		CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) && !IsComplex (operand2) ? Instruction::JL : Instruction::JB, Low);
		break;

	case Code::Instruction::BRGE:
		if (IsComplex (operand2)) CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) ? Instruction::JG : Instruction::JA, High), Branch (0, IsSigned (operand2) ? Instruction::JL : Instruction::JB);
		CompareAndBranch (operand1.offset, operand2, operand3, IsSigned (operand2) && !IsComplex (operand2) ? Instruction::JGE : Instruction::JAE, Low);
		break;

	case Code::Instruction::JUMP:
		Branch (operand1, Instruction::JMP);
		break;

	case Code::Instruction::TRAP:
		Emit (UD2 {mode});
		break;

	default:
		assert (Code::Instruction::Unreachable);
	}
}

void Context::Move (const Code::Operand& target, const Code::Operand& source, const Index index)
{
	if (IsLegacyFloat (target)) LegacyFloatLoad (source), ++legacyStackPointer, LegacyFloatStore (target), --legacyStackPointer;
	else if (IsRegister (target)) Load (Select (target, index), source, index);
	else Store (IsImmediate (source) && !IsFloat (source) && !IsQWord (source) ? Access (source, index) : Load (source, index), target, index);
}

void Context::Convert (const Code::Operand& target, const Code::Operand& source, const Index index)
{
	if (GetSize (target) <= GetSize (source) && !index || IsComplex (source))
		if (GetSize (target) == Operand::Byte && IsRegister (source) && !IsByte (GetRegisterTicket (source.register_, Low)->index))
		{
			const auto temporary = Acquire (target.type); Load (Access (temporary, source.type), source, index);
			Store (Access (temporary), target, index); return Release (temporary);
		}
		else if (IsRegister (target)) return Load (Select (target, index), source, target.type, index);
		else if (IsImmediate (source) && !IsQWord (source)) return Store (Extract (source, target.type, index), target, index);
		else if (target.model == source.model && target.address == source.address && target.register_ == source.register_ && target.displacement == source.displacement) return;
		else return Store (Load (source, target.type, index), target, index);
	else if (IsImmediate (source) && IsRegister (target)) return Load (Select (target, index), source, target.type, index);
	else if (IsImmediate (source)) return Store (Load (source, target.type, index), target, index);
	else if (index && IsSigned (source)) {const auto register_ = GetTemporary (target, index); return Load (register_, target, Low), Emit (SAR {mode, register_, 31}), Store (register_, target, index);}
	else if (index) return Move (target, Code::Imm {target.type, 0}, index);
	else if (mode == LongMode && !IsSigned (source) && target.type.size == Operand::QWord && source.type.size == Operand::DWord)
		{Load (GetTemporary (target, source.type, Low), source, Low); Store (GetTemporary (target, Low), target, Low); return;}

	const auto register_ = GetTemporary (target, index);
	const auto mnemonic = IsSigned (source) ? (mode == LongMode && target.type.size == Operand::QWord && source.type.size == Operand::DWord ? Instruction::MOVSXD : Instruction::MOVSX) : Instruction::MOVZX;
	Emit (mnemonic, register_, Access (source, index)); Prerelease (source, index); Store (register_, target, index);
}

void Context::MediaFloatConvert (const Code::Operand& target, const Code::Operand& source)
{
	if (target.type == source.type)
		Move (target, source, Float);
	else if (IsMediaFloat (target) && IsMediaFloat (source))
		{const auto register_ = GetTemporary (target, Float); Emit (IsDoublePrecision (target) ? Instruction::CVTSS2SD : Instruction::CVTSD2SS, register_, Access (source, Float)); Store (register_, target, Float);}
	else if (IsMediaFloat (target))
	{
		const auto conv = IsDoublePrecision (target) ? Instruction::CVTSI2SD : Instruction::CVTSI2SS;
		if (IsComplex (source)) return Push (source, High), Push (source, Low),
			Emit ({mode, conv, GetTemporary (target, Float), Mem {AccessIndex (Code::RSP), 0}}), ModifyStackPointer (Instruction::ADD, Operand::QWord);
		if (GetSize (source) == Operand::DWord && !IsSigned (source))
			{const auto register_ = GetTemporary (target, Float); Load (GetTemporary (source, Low), source, Low);
				Emit ({mode, conv, register_, GetTemporary (source, generator.platform.pointer, Low)}), Store (register_, target, Float); return;}
		if (GetSize (source) >= Operand::DWord)
			{const auto register_ = GetTemporary (target, Float); Emit (conv, register_, IsRegister (source) || IsMemory (source) ? Access (source, Low) : Load (source, Low)); Store (register_, target, Float); return;}

		const auto register_ = GetTemporary (source, Code::Unsigned {Operand::DWord}, Low);
		Emit (IsSigned (source) ? Instruction::MOVSX : Instruction::MOVZX, register_, IsImmediate (source) ? Load (source, Low) : Access (source, Low));
		Emit ({mode, conv, GetTemporary (target, Float), register_});
		Store (GetTemporary (target, Float), target, Float);
	}
	else if (IsMediaFloat (source))
	{
		const auto conv = IsDoublePrecision (source) ? Instruction::CVTSD2SI : Instruction::CVTSS2SI;
		if (IsRegister (target) && GetSize (target) >= Operand::DWord) Emit (conv, Select (target, Low), Access (source, Float));
		else {Emit (conv, GetTemporary (target, GetSize (target) >= Operand::DWord ? target.type : generator.platform.integer, Low), Access (source, Float)); Store (GetTemporary (target, Low), target, Low);}
	}
}

void Context::LegacyFloatConvert (const Code::Operand& target, const Code::Operand& source)
{
	if (IsLegacyFloat (target) && IsLegacyFloat (source)) return Move (target, source, Float);

	if (IsLegacyFloat (target))
	{
		auto type = GetParameterType (source); auto size = type.size;
		if (IsComplex (source)) Push (source, High), Push (source, Low);
		else if (IsSigned (source) && GetSize (source) != Operand::Byte) Push (source, Low), size = GetSize (source);
		else if (GetSize (source) == Operand::QWord) Push (source, Low);
		else if (GetSize (source) == GetSize (type)) Emit (PUSH {mode, {0, Operand::Size (size)}}), size = type.size += type.size, Push (source, Low);
		else
		{
			const auto register_ = GetTemporary (source, type, Low);
			if (GetSize (source) == Operand::DWord && GetSize (type) == Operand::QWord) Load (register_, source, Low);
			else Emit (IsSigned (source) ? GetSize (source) == Operand::DWord ? Instruction::MOVSXD : Instruction::MOVSX : Instruction::MOVZX, register_, IsImmediate (source) ? Load (source, Low) : Access (source, Low));
			Emit (PUSH {mode, register_});
		}
		Emit (FILD {mode, Mem {AccessIndex (Code::RSP), 0, Operand::Size (size)}});
		ModifyStackPointer (Instruction::ADD, type.size); ++legacyStackPointer;
		LegacyFloatStore (target); --legacyStackPointer;
	}
	else if (IsLegacyFloat (source))
	{
		LegacyFloatLoad (source);
		const auto size = generator.platform.GetStackSize (target.type);
		ModifyStackPointer (Instruction::SUB, size); Emit (FISTP {mode, Mem {AccessIndex (Code::RSP), 0, Operand::Size (size)}});
		Pop (target, Low); if (IsComplex (target)) Pop (target, High);
	}

	Require (LegacyFPUInitialization);
}

void Context::Copy (const Code::Operand& target, const Code::Operand& source, const Code::Operand& size)
{
	const auto di = Acquire (DI, generator.platform.pointer); Reserve (di);
	const auto si = Acquire (SI, generator.platform.pointer); Reserve (si);
	const auto rc = Acquire (RC, generator.platform.pointer); Reserve (rc);
	Load (Access (di), target, Low); Prerelease (target, Low);
	Load (Access (si), source, Low); Prerelease (source, Low);
	Load (Access (rc), size, Low); Prerelease (size, Low);
	Emit (CLD {mode}); Emit (MOVSB::REP {mode});
	Unreserve (di); Unreserve (si); Unreserve (rc);
	Release (di); Release (si); Release (rc);
}

void Context::Fill (const Code::Operand& target, const Code::Operand& size, const Code::Operand& value)
{
	const auto di = Acquire (DI, generator.platform.pointer); Reserve (di);
	const auto rc = Acquire (RC, generator.platform.pointer); Reserve (rc);
	const auto ra = Acquire (RA, Code::Unsigned {GetSize (value)}); Reserve (ra);
	Load (Access (di), target, Low); Prerelease (target, Low);
	Load (Access (rc), size, Low); Prerelease (size, Low);
	if (IsMediaFloat (value) && IsRegister (value)) Emit (Instruction::MOVD, Access (ra), Select (value, Float));
	else if (IsLegacyFloat (value) && IsRegister (value)) Push (value, Float), Emit (POP {mode, AccessMem (ra, GetParameterType (value))});
	else Load (Access (ra), value, ra->type, Low); Prerelease (value, Low);
	Emit (CLD {mode});
	switch (GetSize (value))
	{
	case Operand::Byte: Emit (STOSB::REP {mode}); break;
	case Operand::Word: Emit (STOSW::REP {mode}); break;
	case Operand::QWord: Emit (STOSQ::REP {mode}); break;
	default: Emit (STOSD::REP {mode}); break;
	}
	Unreserve (di); Unreserve (rc); Unreserve (ra);
	Release (di); Release (rc); Release (ra);
}

void Context::Negate (const Code::Operand& target, const Code::Operand& value, const Index index)
{
	if (IsComplex (target) && !index) Not (target, value, High);
	if (target == value && !index) return Emit (Instruction::NEG, Access (target, index), {});
	if (index) return Emit (Instruction::SBB, Access (target, index), -1);
	const auto register_ = GetTemporary (target, value, value, index);
	Load (register_, value, index); Emit (NEG {mode, register_}); Store (register_, target, index);
}

void Context::SignedMultiply (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	if (IsImmediate (value1) && !IsImmediate (value2) || target == value2 && value1 != value2)
		return SignedMultiply (target, value2, value1);
	if (IsImmediate (value2) && IsPowerOfTwo (std::abs (Extract (value2, Low))))
		return Shift (Instruction::SAL, target, value1, Code::Imm {value2.type, CountOnes (Extract (value2, Low) - 1ull)});
	if (GetSize (target) == Operand::Byte)
		return Multiply (target, value1, value2);

	const auto register_ = GetTemporary (target, value1, value2, Low);

	if (IsImmediate (value2) && !IsQWord (value2))
		return Emit (Instruction::IMUL, register_, IsImmediate (value1) ? Load (value1, Low) : Access (value1, Low), Extract (value2, Low)), Store (register_, target, Low);

	Load (register_, value1, Low);
	Emit (Instruction::IMUL, register_, IsImmediate (value2) ? Load (value2, Low) : Access (value2, Low));
	Prerelease (value2, Low); Store (register_, target, Low);
}

void Context::Multiply (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	if (IsImmediate (value1) && !IsImmediate (value2))
		return Multiply (target, value2, value1);
	if (IsImmediate (value2) && IsPowerOfTwo (std::abs (Extract (value2, Low))))
		return Shift (IsSigned (value2) ? Instruction::SAL : Instruction::SHL, target, value1, Code::Imm {value2.type, CountOnes (Extract (value2, Low) - 1ull)});

	const auto byte = GetSize (target) == Operand::Byte;
	const auto ra = Acquire (RA, target.type); Reserve (ra);
	Load (Access (ra), value1, Low); Prerelease (value1, Low);
	const auto rd = Acquire (RD, target.type); if (!byte) Reserve (rd), Access (rd);
	Emit (IsSigned (target) ? Instruction::IMUL : Instruction::MUL, IsImmediate (value2) ? Load (value2, Low) : Access (value2, Low), {});
	Prerelease (value2, Low); if (!byte) Unreserve (rd); Release (rd);
	Store (SmartOperand {Access (ra)}, target, Low); Unreserve (ra); Release (ra);
}

void Context::Divide (const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const bool remainder)
{
	if (IsImmediate (value2) && IsPowerOfTwo (std::abs (Extract (value2, Low))))
		if (remainder) return Operation (Instruction::AND, target, value1, Code::Imm {value2.type, Extract (value2, Low) - 1}, Low);
		else return Shift (IsSigned (value2) ? Instruction::SAR : Instruction::SHR, target, value1, Code::Imm {value2.type, CountOnes (Extract (value2, Low) - 1ull)});

	if (IsRegister (value2)) Select (value2, Low);
	const auto byte = GetSize (target) == Operand::Byte;
	const auto ra = Acquire (RA, target.type); Reserve (ra);
	Load (Access (ra), value1, Low); Prerelease (value1, Low);
	const auto rd = Acquire (RD, target.type); if (!byte) Reserve (rd), Access (rd);
	if (IsSigned (target))
		switch (GetSize (target))
		{
		case Operand::Byte: Emit (CBW {mode}); break;
		case Operand::Word: Emit (CWD {mode}); break;
		case Operand::QWord: Emit (CQO {mode}); break;
		default: Emit (CDQ {mode}); break;
		}
	else if (byte) Emit (XOR {mode, AH, AH});
	else Emit (XOR {mode, Access (rd), Access (rd)});
	Emit (IsSigned (target) ? Instruction::IDIV : Instruction::DIV, IsImmediate (value2) ? Load (value2, Low) : Access (value2, Low), {});
	Prerelease (value2, Low); if (remainder) Unreserve (ra), Release (ra); else {if (!byte) Unreserve (rd); Release (rd);}
	if (remainder && byte && mode == LongMode) Emit ({mode, IsSigned (target) ? Instruction::SAR : Instruction::SHR, AX, 8}), Store (AL, target, Low);
	else Store (SmartOperand {remainder ? byte ? AH : Access (rd) : Access (ra)}, target, Low);
	if (!remainder) Unreserve (ra), Release (ra); else {if (!byte) Unreserve (rd); Release (rd);}
}

void Context::Not (const Code::Operand& target, const Code::Operand& value, const Index index)
{
	if (target == value) return Emit (Instruction::NOT, Access (target, index), {});
	const auto register_ = GetTemporary (target, value, value, index);
	Load (register_, value, index); Emit (NOT {mode, register_}); Store (register_, target, index);
}

void Context::Operation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2, const Index index)
{
	if (IsImmediate (value1) && !IsImmediate (value2) || target == value2 && value1 != value2)
		if (mnemonic != Instruction::SUB && mnemonic != Instruction::SBB) return Operation (mnemonic, target, value2, value1, index);
	if (target == value1)
		if (IsImmediate (value2) && !IsQWord (value2))
			if (mnemonic == Instruction::ADD && Extract (value2, index) == 1 && !IsComplex (value2)) return Emit (Instruction::INC, Access (target, index), {});
			else if (mnemonic == Instruction::SUB && Extract (value2, index) == 1 && !IsComplex (value2)) return Emit (Instruction::DEC, Access (target, index), {});
			else return Emit (mnemonic, Access (target, index), Extract (value2, index));
		else if (IsRegister (target) && !IsQWord (value2)) return Emit (mnemonic, Select (target, index), IsBasic (value2) ? Access (value2, index) : Load (value2, index));
		else return Emit (mnemonic, Access (target, index), Load (value2, index));
	if (IsRegister (target) && IsRegister (value1) && !IsComplex (target) && GetSize (target) == GetSize (generator.platform.pointer) && IsIndexBaseIncrement (GetRegisterTicket (value1.register_, Low)->index))
		if (mnemonic == Instruction::SUB && IsImmediate (value2) && TruncatesPreserving (Extract (value2, Low), generator.platform.integer.size * 8))
			return Emit (LEA {mode, Select (target, Low), Mem {Select (value1, Low), -Extract (value2, Low)}});
		else if (mnemonic == Instruction::ADD && IsImmediate (value2) && TruncatesPreserving (Extract (value2, Low), generator.platform.integer.size * 8))
			return Emit (LEA {mode, Select (target, Low), Mem {Select (value1, Low), +Extract (value2, Low)}});
		else if (mnemonic == Instruction::ADD && IsRegister (value2) && IsIndexIncrement (GetRegisterTicket (value2.register_, Low)->index))
			return Emit (LEA {mode, Select (target, Low), Mem {Select (value1, Low), Select (value2, Low)}});

	const auto register_ = GetTemporary (target, value1, value2, index); Load (register_, value1, index);
	if (mnemonic == Instruction::ADD && IsImmediate (value2) && Extract (value2, index) == 1 && !IsComplex (value2)) Emit (Instruction::INC, register_, {});
	else if (mnemonic == Instruction::SUB && IsImmediate (value2) && Extract (value2, index) == 1 && !IsComplex (value2)) Emit (Instruction::DEC, register_, {});
	else Emit (mnemonic, register_, IsQWord (value2) ? Load (value2, index) : Access (value2, index));
	Prerelease (value2, index); Store (register_, target, index);
}

void Context::LegacyFloatOperation (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	LegacyFloatLoad (value1); ++legacyStackPointer;
	if (IsRegister (value2)) Emit (mnemonic, ST0, Select (value2, Float)); else Emit (mnemonic, Access (value2, Float), {});
	LegacyFloatStore (target); --legacyStackPointer; Require (LegacyFPUInitialization);
}

void Context::MediaFloatOperation (const Instruction::Mnemonic singleMnemonic, const Instruction::Mnemonic doubleMnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const auto register_ = GetTemporary (target, value1, value2, Float); Load (register_, value1, Float);
	Emit (IsDoublePrecision (target) ? doubleMnemonic : singleMnemonic, register_, Access (value2, Float));
	Store (register_, target, Float);
}

void Context::Shift (const Instruction::Mnemonic mnemonic, const Code::Operand& target, const Code::Operand& value1, const Code::Operand& value2)
{
	const Code::Unsigned type {Operand::Byte};

	if (IsImmediate (value2))
	{
		if (target == value1) return Emit (mnemonic, Access (target, Low), Extract (value2, type, Low));
		const auto register_ = GetTemporary (target, value1, value2, Low);
		return Load (register_, value1, Low), Emit ({mode, mnemonic, register_, Extract (value2, type, Low)}), Store (register_, target, Low);
	}

	const auto rc = Acquire (RC, value2.type); Reserve (rc); Load (Access (rc), value2, Low); Prerelease (value2, Low);
	if (target == value1) return Emit (mnemonic, Access (target, Low), Access (rc, type)), Unreserve (rc), Release (rc);
	const auto register_ = GetTemporary (target, Low);
	Load (register_, value1, Low); Prerelease (value1, Low);
	Emit (mnemonic, register_, Access (rc, type));
	Unreserve (rc); Release (rc); Store (register_, target, Low);
}

void Context::Push (const Code::Operand& value, const Index index)
{
	if (stackSize) throw RegisterShortage {}; const auto type = GetParameterType (value);
	if (IsMediaFloat (value)) ModifyStackPointer (Instruction::SUB, type.size), Emit ({mode, IsDoublePrecision (value) ? Instruction::MOVSD : Instruction::MOVSS, Mem {AccessIndex (Code::RSP), 0, GetSize (value)}, Load (value, Float)});
	else if (IsLegacyFloat (value)) LegacyFloatLoad (value), ModifyStackPointer (Instruction::SUB, type.size), Emit (FSTP {mode, Mem {AccessIndex (Code::RSP), 0, GetSize (value)}});
	else if (!IsImmediate (value)) Emit (Instruction::PUSH, IsBasic (value) ? Access (value, type, index) : Load (value, type, index), {});
	else if (TruncatesPreserving (Extract (value, type, index), 8) && type.size <= mode / 8u) Emit (PUSH {mode, Extract (value, type, index)});
	else if (TruncatesPreserving (Extract (value, type, index), 32)) Emit (PUSH {mode, {Extract (value, type, index), mode == LongMode ? Operand::DWord : GetSize (type)}});
	else Emit (PUSH {mode, Load (value, type, index)});
}

void Context::Pop (const Code::Operand& target, const Index index)
{
	if (stackSize) throw RegisterShortage {}; const auto type = GetParameterType (target);
	if (IsMediaFloat (target)) {Emit ({mode, IsDoublePrecision (target) ? Instruction::MOVSD : Instruction::MOVSS, GetTemporary (target, Float), Mem {AccessIndex (Code::RSP), 0, GetSize (target)}});
		ModifyStackPointer (Instruction::ADD, type.size); Store (GetTemporary (target, Float), target, Float);}
	else if (IsLegacyFloat (target)) Emit (FLD {mode, Mem {AccessIndex (Code::RSP), 0, GetSize (target)}}), ModifyStackPointer (Instruction::ADD, type.size), ++legacyStackPointer, LegacyFloatStore (target), --legacyStackPointer;
	else if (GetSize (target) == GetSize (type) || IsRegister (target)) Emit (Instruction::POP, Access (target, type, index), {});
	else {Emit (POP {mode, GetTemporary (target, type, index)}); Store (GetTemporary (target, index), target, index);}
}

void Context::Branch (const Code::Operand& target, const Instruction::Mnemonic mnemonic)
{
	if (stackSize) throw RegisterShortage {};
	const auto address = IsImmediate (target) ? Load (target, Low) : Access (target, Low);
	Emit (mnemonic, address, {});
}

void Context::CompareAndBranch (const Code::Offset offset, const Code::Operand& value1, const Code::Operand& value2, const Instruction::Mnemonic mnemonic, const Index index)
{
	if (IsImmediate (value1) && !IsImmediate (value2)) return CompareAndBranch (offset, value2, value1, Transpose (mnemonic), index); const auto previous = GetPreviousInstruction ();
	if (IsMediaFloat (value1)) Emit (IsDoublePrecision (value1) ? Instruction::COMISD : Instruction::COMISS, Load (value1, Float), Access (value2, Float));
	else if (IsLegacyFloat (value1)) LegacyFloatLoad (value1), ++legacyStackPointer, Emit (Instruction::FCOMP, Access (value2, Float), {}), --legacyStackPointer, Emit (FNSTSW {mode, AX}), Emit (SAHF {mode});
	else if (!IsComplex (value1) && IsImmediate (value2) && !Extract (value2, index) && previous && previous->mnemonic == Code::Instruction::SUB && previous->operand1 == value1 && previous->operand2 == value1 && IsImmediate (previous->operand3));
	else if (!IsMemory (value1) && !IsQWord (value2)) Emit (Instruction::CMP, Load (value1, index), IsBasic (value2) ? Access (value2, index) : Load (value2, index));
	else if (IsImmediate (value2) && !IsQWord (value2)) Emit (Instruction::CMP, Access (value1, index), Extract (value2, index));
	else Emit (Instruction::CMP, IsImmediate (value1) ? Load (value1, index) : Access (value1, index), Load (value2, index));
	Prerelease (value1, index); Prerelease (value2, index); Branch (offset, mnemonic);
}

void Context::Branch (const Code::Offset offset, const Instruction::Mnemonic mnemonic)
{
	if (stackSize) throw RegisterShortage {}; const auto label = GetLabel (offset);
	const auto width = offset <= 4 && GetBranchOffset (label, 0) > -127 ? Operand::Byte : mode == RealMode ? Operand::Word : Operand::DWord;
	AddFixup (label, mnemonic, AMD64::GetSize ({mode, mnemonic, {0, width}}));
	if (listing) listing << '\t' << mnemonic << '\t' << width << ' ' << label << '\n';
}

void Context::FixupInstruction (const Span<Byte> bytes, const Byte*const target, const FixupCode code) const
{
	const auto width = bytes.size () == 2 ? Operand::Byte : mode == RealMode ? Operand::Word : Operand::DWord;
	const Instruction instruction {mode, Instruction::Mnemonic (code), {Immediate (target - bytes.end ()), width}};
	assert (IsValid (instruction)); assert (AMD64::GetSize (instruction) == bytes.size ()); instruction.Emit (bytes);
}

Context::Part Context::GetRegisterParts (const Code::Operand& operand) const
{
	return IsComplex (operand.type) + 1;
}

Context::Suffix Context::GetRegisterSuffix (const Code::Operand& operand, const Part part) const
{
	return IsComplex (operand.type) ? part == High ? 'h' : 'l' : 0;
}

std::ostream& Context::WriteRegister (std::ostream& stream, const Code::Operand& operand, const Part part)
{
	return stream << Access (GetRegisterTicket (operand.register_, IsFloat (operand) ? Float : Index (part)));
}

void Context::Write (std::ostream& stream, const SmartOperand& operand)
{
	if (operand.address.empty ()) return void (stream << operand);
	stream << operand.size << ' ';
	if (operand.model == SmartOperand::Memory) stream << '[';
	if (operand.register_) stream << operand.register_ << " + ";
	WriteAddress (stream, nullptr, operand.address, operand.displacement, 0);
	if (operand.model == SmartOperand::Memory) stream << ']';
}

Instruction::Mnemonic Context::Transpose (const Instruction::Mnemonic mnemonic)
{
	switch (mnemonic)
	{
	case Instruction::JL: return Instruction::JG; case Instruction::JB: return Instruction::JA;
	case Instruction::JG: return Instruction::JL; case Instruction::JA: return Instruction::JB;
	case Instruction::JGE: return Instruction::JLE; case Instruction::JAE: return Instruction::JBE;
	default: return mnemonic;
	}
}

Context::RegisterTicket::RegisterTicket (const RegisterIndex i, const Code::Type& t) :
	type {t}, index {i}
{
}

Context::RegisterSetElement::RegisterSetElement (const Ticket c) :
	current {c}, temporary {c}
{
}

SmartOperand::SmartOperand (const Operand& o) :
	Operand {o}
{
}

SmartOperand::SmartOperand (SmartOperand&& operand) noexcept :
	Operand {std::move (operand)}, context {operand.context}, address {std::move (operand.address)}, displacement {operand.displacement}, ticket {operand.ticket}
{
	operand.context = nullptr;
}

SmartOperand::SmartOperand (Context& c, const Ticket t, const AMD64::Register r) :
	Operand {r}, context {&c}, ticket {t}
{
}

SmartOperand::SmartOperand (Context& c, const Ticket t, const Code::Type& type, const AMD64::Register r, const Index i) :
	Operand {c.GetSize (type), RVoid, r, i, 1, 0}, context {&c}, ticket {t}
{
}

SmartOperand::SmartOperand (const Context& c, const Code::Section::Name& a, const Code::Displacement d) :
	Operand {0, c.mode == LongMode && c.directAddressing ? DWord : c.GetSize (c.generator.platform.pointer)}, address {a}, displacement {d}
{
	assert (!address.empty ());
}

SmartOperand::SmartOperand (const Context& c, const Code::Type& type, const Code::Section::Name& a, const Code::Displacement d) :
	Operand {c.GetSize (type), RVoid, c.mode == LongMode ? RIP : RVoid, RVoid, 0, 0}, address {a}, displacement {d}
{
	assert (!address.empty ());
}

SmartOperand::~SmartOperand ()
{
	if (context) context->Release (ticket);
}

SmartOperand::operator AMD64::Register () const
{
	return register_;
}

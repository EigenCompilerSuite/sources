// Generic machine code generator
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

#include "asmassembler.hpp"
#include "asmgenerator.hpp"
#include "assembly.hpp"
#include "debugging.hpp"
#include "error.hpp"
#include "format.hpp"
#include "position.hpp"
#include "utilities.hpp"

#include <cstring>

using namespace ECS;
using namespace Assembly;

using Context =
	#include "asmgeneratorcontext.hpp"

Generator::Generator (Diagnostics& d, StringPool& sp, Assembler& a, const Target t, const Name n, const Layout& l, const HasLinkRegister hlr) :
	layout {l}, platform {layout, hlr}, assembler {a}, target {t}, name {n}, parser {d, sp, false}
{
	assert (target); assert (name);
}

void Generator::Generate (const Code::Sections& sections, const Source& source, Object::Binaries& binaries, Debugging::Information& information, std::ostream& listing) const
{
	information.sources.push_back (source);
	const auto bitmode = !std::strchr (name, ' ') && assembler.Validate (assembler.bitmode) ? assembler.bitmode : 0;
	information.target.name = bitmode ? target + std::to_string (bitmode) : target;
	information.target.endianness = assembler.endianness;
	information.target.pointer = layout.pointer.size;

	listing << "; " << name; if (bitmode) listing << ' ' << bitmode << "-bit"; listing << " assembly code listing generated from " << source << '\n';
	Process (sections, binaries, information, listing);
}

Context::Context (const Generator& g, Object::Binaries& b, Debugging::Information& i, std::ostream& l, const InitializeData id) :
	listing {l}, generator {g}, endianness {generator.assembler.endianness}, binaries {b}, information {i}	, initializeData {id}
{
}

void Context::EmitError (const Message& message) const
{
	generator.assembler.diagnostics.Emit (Diagnostics::Error, section->name, currentInstruction + 1, message); throw Error {};
}

void Context::Process (const Code::Sections& sections)
{
	if (initializeData) for (auto& section: sections) Initialize (section);
	Batch (sections, [this] (const Code::Section& section) {Process (section);});
	if (initializeData) for (auto& section: globalDefinitions) Initialize (section);
	for (auto& section: globalDefinitions) Process (section);
}

void Context::Process (const Code::Section& section)
try
{
	this->section = &section;
	if (IsAssembly (section)) return Batch (section.instructions, [this] (const Code::Instruction& instruction) {Assemble (instruction);});

	binary = !IsType (section.type) ? &binaries.emplace_back (section) : nullptr;
	labels.resize (section.instructions.size () + 1); currentDirective = Lexer::Invalid; entry = nullptr; currentInstruction = 0;

	if (listing && binary)
	{
		listing << '\n';
		if (!section.comment.empty ()) listing << "; " << section.comment << '\n';
		WriteIdentifier (listing << '.' << section.type << ' ', section.name) << '\n';
		if (section.required) listing << '\t' << Assembly::Lexer::Required << '\n';
		if (section.duplicable) listing << '\t' << Assembly::Lexer::Duplicable << '\n';
		if (section.replaceable) listing << '\t' << Assembly::Lexer::Replaceable << '\n';
		if (section.fixed) listing << '\t' << Lexer::Origin << '\t' << section.origin << '\n';
		if (!section.group.empty ()) WriteIdentifier (listing << '\t' << Lexer::Group << '\t', section.group) << '\n';
	}

	if (IsCode (section.type)) binary->bytes.reserve (section.instructions.size () * generator.assembler.instructionAlignment);
	else if (IsData (section.type) && initializeData && HasDefinitions (section) && !section.required) Require ("_init_" + section.name);
	else if (IsType (section.type)) AddTypeableEntry (Debugging::Entry::Type);
	if (const auto original = binary) Preprocess (section), binary = original;
	if (!pendingDefinitions.empty ()) ApplyLocalDefinitions (-1);
	Batch (section.instructions, [this] (const Code::Instruction& instruction) {Emit (instruction);});
	if (location) if (IsType (section.type)) *location = {}, location = nullptr; else EmitError ("missing source code location");
	for (auto fixed: fixes) if (fixed) EmitError ("fixed register mapping");
	if (!types.empty ()) EmitError ("missing type declaration");

	for (auto symbol: symbols) assert (!symbol); symbols.clear (); declarations.clear ();
	assert (std::count (uses, uses + Code::UserRegisters, 0) == Code::UserRegisters);
	if (!pendingDefinitions.empty ()) ApplyLocalDefinitions (0); appliedDefinitions.clear ();
	if (binary) generator.assembler.Align (*binary);

	if (listing && binary)
	{
		if (currentDirective) listing << '\n';
		if (IsCode (section.type)) WriteIdentifier (listing << '\n' << Label {section.instructions.size ()} << ":\t; end of ", section.name) << '\n';
		if (!binary->fixed && binary->alignment > 1) listing << '\t' << Lexer::Alignment << '\t' << binary->alignment << '\n';
	}

	if (const auto original = binary) Postprocess (section), binary = original;

	if (entry && binary) entry->size = binary->bytes.size ();
	if (binary) labels[section.instructions.size ()] = binary->bytes.size ();
	for (auto& fixup: fixups) FixupInstruction ({binary->bytes.data () + fixup.offset, fixup.size}, binary->bytes.data () + labels[fixup.index], fixup.code); fixups.clear ();
}
catch (const Error&)
{
	if (!pendingDefinitions.empty ()) ApplyLocalDefinitions (0); appliedDefinitions.clear (); types.clear (); symbols.clear (); declarations.clear (); fixups.clear (); location = nullptr;
	for (auto& fixed: fixes) fixed = 0; for (auto& used: uses) if (used) Release (Code::Register (&used - uses), used); throw;
}

void Context::Initialize (const Code::Section& section)
{
	if (!IsData (section.type) || !HasDefinitions (section)) return;

	Code::Section initDataSection {Code::Section::InitData, "_init_" + section.name, 0, section.required, section.duplicable, section.replaceable};
	Format ("initialization of %0 section %1", section.type, section.name).swap (initDataSection.comment);

	Code::Displacement displacement = 0; auto set = false;
	for (auto instruction = section.instructions.begin (); instruction != section.instructions.end ();)
		switch (instruction->mnemonic)
		{
		case Code::Instruction::ALIAS:
		case Code::Instruction::REQ:
		case Code::Instruction::LOC:
		case Code::Instruction::FIELD:
		case Code::Instruction::VALUE:
		case Code::Instruction::VOID:
		case Code::Instruction::TYPE:
		case Code::Instruction::ARRAY:
		case Code::Instruction::REC:
		case Code::Instruction::PTR:
		case Code::Instruction::REF:
		case Code::Instruction::FUNC:
		case Code::Instruction::ENUM:
			++instruction;
			break;

		case Code::Instruction::DEF:
		{
			if (IsZero (instruction->operand1)) {displacement += instruction->operand1.type.size; ++instruction; break;}
			if (!set) initDataSection.instructions.emplace_back (Code::Instruction::MOV, Code::Reg {generator.platform.pointer, Code::R0}, Code::Adr {generator.platform.pointer, section.name, displacement}), displacement = 0, set = true;
			else if (displacement >= 128) initDataSection.instructions.emplace_back (Code::Instruction::ADD, Code::Reg {generator.platform.pointer, Code::R0}, Code::Reg {generator.platform.pointer, Code::R0}, Code::PtrImm (generator.platform.pointer, displacement)), displacement = 0;
			const auto skip = std::find_if (instruction, section.instructions.end (), [instruction] (const Code::Instruction& other) {return *instruction != other;}) - instruction;
			if (skip < 4) initDataSection.instructions.emplace_back (Code::Instruction::MOV, Code::Mem {instruction->operand1.type, Code::R0, displacement}, instruction->operand1), displacement += instruction->operand1.type.size, ++instruction;
			else initDataSection.instructions.emplace_back (Code::Instruction::FILL, Code::Reg {generator.platform.pointer, Code::R0, displacement}, Code::PtrImm (generator.platform.pointer, Code::Pointer::Value (skip)), instruction->operand1), displacement += instruction->operand1.type.size * skip, instruction += skip;
			break;
		}

		case Code::Instruction::RES:
			displacement += instruction->operand1.size; ++instruction;
			break;

		default:
			assert (Code::Instruction::Unreachable);
		}

	Process (initDataSection);
}

void Context::Check (const Code::Operand& operand) const
{
	if (HasRegister (operand) && IsGeneral (operand.register_) && !uses[operand.register_]) EmitError ("unmapped register");
}

void Context::Acquire (const Code::Register register_, const Types& types, const Code::Size count)
{
	assert (count); if (!uses[register_]) if (uses[register_] = count, !fixes[register_]) Acquire (register_, types);
}

void Context::AcquireRegister (const Code::Instruction& instruction)
{
	Acquire (GetModifiedRegister (instruction), GetModifiedRegisterType (instruction), instruction);
	Check (instruction.operand1); Check (instruction.operand2); Check (instruction.operand3);
}

void Context::Acquire (const Code::Register register_, const Code::Type& type, const Code::Instruction& instruction)
{
	if (!IsUser (register_) || uses[register_]) return;
	Code::Size uses = instruction.Uses (register_), fixes = 0; Types types {type};
	if (uses > 1) Check (instruction.operand2), Check (instruction.operand3);
	const auto last = &section->instructions.front () + section->instructions.size ();
	for (auto i = &instruction + 1; i != last; uses += i->Uses (register_), ++i)
	{
		if (i->mnemonic == Code::Instruction::FIX && i->operand1.Uses (register_)) ++fixes;
		if (i->mnemonic == Code::Instruction::UNFIX && i->operand1.Uses (register_)) --fixes;
		if (IsModifying (*i) && register_ == Code::RRes && !IsSupported (*i)) InsertUnique (i->operand1.type, types);
		if (register_ == GetModifiedRegister (*i) && !i->operand2.Uses (register_) && !i->operand3.Uses (register_) && !fixes) break;
		AddType (register_, i->operand1, types); AddType (register_, i->operand2, types); AddType (register_, i->operand3, types);
	}
	Acquire (register_, types, uses);
}

void Context::AddType (const Code::Register register_, const Code::Operand& operand, Types& types) const
{
	if (HasRegister (operand) && operand.register_ == register_) InsertUnique (IsMemory (operand) ? generator.platform.pointer : operand.type, types);
}

void Context::ReleaseRegisters (const Code::Instruction& instruction)
{
	for (auto register_ = Code::R0; register_ <= Code::RRes; register_ = Code::Register (register_ + 1)) Release (register_, instruction.Uses (register_));
}

void Context::Release (const Code::Register register_, const Code::Size count)
{
	if (!IsUser (register_) || !count || !uses[register_]) return; assert (uses[register_] >= count);
	if (!(uses[register_] -= count)) if (!fixes[register_]) Release (register_);
}

bool Context::IsLastUseOf (const Code::Register register_) const
{
	return IsUser (register_) && uses[register_] == 1 && !fixes[register_];
}

void Context::Fix (const Code::Register register_)
{
	if (IsUser (register_)) ++fixes[register_];
}

void Context::Unfix (const Code::Register register_)
{
	if (IsUser (register_) && !--fixes[register_] && !uses[register_]) Release (register_);
}

void Context::List (const Code::Instruction& instruction)
{
	if (instruction.mnemonic == Code::Instruction::DEF && instruction.comment.empty ()) return;
	if (currentDirective) listing << '\n', currentDirective = Lexer::Invalid;

	if (instruction.line || !instruction.comment.empty ()) listing << '\n';
	const auto separateLabel = !instruction.line && (instruction.mnemonic == Code::Instruction::ALIAS || instruction.mnemonic == Code::Instruction::ASM);
	if (separateLabel) listing << Label {currentInstruction} << ':';
	if (!instruction.comment.empty ()) listing << "\t; " << instruction.comment << '\n'; else if (separateLabel) listing << '\n';
	if (!instruction.line && IsCode (section->type) && !separateLabel) listing << Label {currentInstruction} << ':';
	if (!instruction.line || !IsCode (section->type)) return;
	listing << Label {currentInstruction} << ":\t; line " << instruction.line << ": ";
	if (instruction.mnemonic == Code::Instruction::ASM) listing << instruction.mnemonic << '\n'; else listing << instruction << '\n';
}

void Context::Emit (const Code::Instruction& instruction)
try
{
	assert (IsValid (instruction, *section, generator.platform));
	currentInstruction = GetIndex (instruction, section->instructions);
	if (binary) labels[currentInstruction] = binary->bytes.size ();

	if (listing && binary) List (instruction);
	const auto position = listing.tellp ();
	Preprocess (instruction);

	switch (instruction.mnemonic)
	{
	case Code::Instruction::ALIAS:
		AddAlias (instruction.operand1.address);
		AcquireRegister (instruction); ReleaseRegisters (instruction);
		break;

	case Code::Instruction::REQ:
		Require (instruction.operand1.address);
		break;

	case Code::Instruction::DEF:
		Define (instruction.operand1);
		break;

	case Code::Instruction::RES:
		Reserve (instruction.operand1.size);
		if (listing) listing << '\t' << Lexer::Reserve << '\t' << instruction.operand1.size << '\n';
		break;

	case Code::Instruction::NOP:
		break;

	case Code::Instruction::ASM:
		AssembleInline (instruction.operand1.address, instruction.operand2.size, instruction.operand3.address);
		break;

	case Code::Instruction::FIX:
		if (fixes[instruction.operand1.register_]) EmitError ("fixed register");
		Acquire (instruction.operand1.register_, instruction.operand1.type, instruction);
		Fix (instruction.operand1.register_); Release (instruction.operand1.register_, 1);
		break;

	case Code::Instruction::UNFIX:
		if (!fixes[instruction.operand1.register_]) EmitError ("unfixed register");
		Unfix (instruction.operand1.register_); Release (instruction.operand1.register_, 1);
		break;

	case Code::Instruction::LOC:
		if (IsCode (section->type)) AddTypeableEntry (Debugging::Entry::Code);
		else if (IsData (section->type)) AddTypeableEntry (Debugging::Entry::Data);
		if (!location) EmitError ("invalid source code location");
		location->index = Insert (instruction.operand1.address); location->line = instruction.operand2.size; location->column = instruction.operand3.size; location = nullptr;
		break;

	case Code::Instruction::BREAK:
		AddTypeableEntry (Debugging::Entry::Code);
		if (location) EmitError ("missing source code location");
		location = &entry->breakpoints.emplace_back (binary->bytes.size ()).location;
		break;

	case Code::Instruction::SYM:
		if (IsRegister (instruction.operand3)) Acquire (instruction.operand3.register_, instruction.operand3.type, instruction);
		Declare (instruction.operand1.offset, instruction.operand2.address, instruction.operand3);
		if (HasRegister (instruction.operand3)) Release (instruction.operand3.register_, 1);
		break;

	case Code::Instruction::FIELD:
		if (location) if (IsType (section->type)) *location = {}; else EmitError ("missing source code location");
		if (declarations.empty () || !IsRecord (*declarations.back ().type)) EmitError ("invalid field declaration");
		location = &declarations.back ().type->fields.emplace_back (instruction.operand1.address, instruction.operand2.size, Convert (instruction.operand3)).location;
		types.push_back (&declarations.back ().type->fields.back ().type);
		break;

	case Code::Instruction::VALUE:
		if (location) if (IsType (section->type)) *location = {}; else EmitError ("missing source code location");
		if (declarations.empty () || !IsEnumeration (*declarations.back ().type)) EmitError ("invalid enumerator declaration");
		location = &declarations.back ().type->enumerators.emplace_back (instruction.operand1.address, GetValue (instruction.operand2)).location;
		break;

	case Code::Instruction::VOID:
		Declare (Debugging::Type::Void);
		break;

	case Code::Instruction::TYPE:
		Declare (GetType (instruction.operand1));
		break;

	case Code::Instruction::ARRAY:
		Declare ({Debugging::Type::Array, instruction.operand2.size}).index = instruction.operand1.size;
		break;

	case Code::Instruction::REC:
		declarations.emplace_back (currentInstruction + instruction.operand1.offset, Declare ({Debugging::Type::Record, instruction.operand2.size}));
		break;

	case Code::Instruction::PTR:
		Declare (Debugging::Type::Pointer);
		break;

	case Code::Instruction::REF:
		Declare (Debugging::Type::Reference);
		break;

	case Code::Instruction::FUNC:
		declarations.emplace_back (currentInstruction + instruction.operand1.offset, Declare (Debugging::Type::Function));
		break;

	case Code::Instruction::ENUM:
		declarations.emplace_back (currentInstruction + instruction.operand1.offset, Declare (Debugging::Type::Enumeration));
		break;

	default:
		Encode (instruction);
	}

	if (listing && IsCode (section->type) && binary && listing.tellp () == position && position != -1 && !instruction.line) listing << '\n';
	for (auto& symbol: symbols) if (symbol && symbol->lifetime.end == currentInstruction) Undeclare (*symbol), symbol = nullptr;
	while (!declarations.empty () && declarations.back ().extent <= currentInstruction) declarations.pop_back ();
	for (auto& definition: pendingDefinitions) if (binary->bytes.size () > definition.limit) return ApplyLocalDefinitions (0);
}
catch (const RegisterShortage&)
{
	EmitError ("register shortage");
}

Code::Size Context::Push (const Code::Operand& operand)
{
	assert (HasType (operand));
	Check (operand); Generate (Code::PUSH {operand});
	return generator.platform.GetStackSize (operand.type);
}

void Context::Encode (const Code::Instruction& instruction)
{
	const auto modified = GetModifiedRegister (instruction);
	const auto type = GetModifiedRegisterType (instruction);
	if (IsUser (modified)) registerTypes[modified] = type;

	if (IsSupported (instruction)) return AcquireRegister (instruction), Generate (instruction), ReleaseRegisters (instruction);

	const auto address = GetAddress (instruction);
	if (instruction.mnemonic == Code::Instruction::TRAP) return Generate (Code::CALL {address, Code::Size {0}});

	bool saved[Code::UserRegisters];
	for (auto register_ = Code::R0; register_ <= Code::RRes; register_ = Code::Register (register_ + 1))
		if (saved[register_] = register_ != modified && uses[register_] > instruction.Uses (register_)) Push (Code::Reg {registerTypes[register_], register_});

	Code::Size parameters = 0;
	const auto modifying = IsModifying (instruction);
	if (HasType (instruction.operand3)) parameters += Push (instruction.operand3);
	if (HasType (instruction.operand2)) parameters += Push (DisplaceStackPointer (instruction.operand2, parameters));
	if (HasType (instruction.operand1) && !modifying) parameters += Push (DisplaceStackPointer (instruction.operand1, parameters));

	if (HasRegister (instruction.operand2)) Release (instruction.operand2.register_, 1);
	if (HasRegister (instruction.operand3)) Release (instruction.operand3.register_, 1);

	Generate (Code::CALL {address, parameters});
	const Code::Reg result {modifying || modified != Code::RVoid ? type : Code::Unsigned {1}, Code::RRes};
	if (modified != Code::RVoid) Acquire (modified, type, instruction);

	const auto used = uses[result.register_];
	if (used) Release (result.register_, used); Acquire (result.register_, {result.type});
	if (modifying && modified != Code::RRes) Generate (Code::MOV {instruction.operand1, result});
	if (IsOffset (instruction.operand1)) assert (!used); else Release (result.register_);
	if (used) Acquire (result.register_, {registerTypes[result.register_]}, used);

	for (auto register_ = Code::RRes; register_ >= Code::R0; register_ = Code::Register (register_ - 1))
		if (saved[register_]) Generate (Code::POP {Code::Reg {registerTypes[register_], register_}});

	if (IsOffset (instruction.operand1)) Generate (Code::BRNE {instruction.operand1.offset, result, Code::UImm (result.type, 0)}), Release (result.register_);

	if (HasRegister (instruction.operand1)) Release (instruction.operand1.register_, 1);
}

Code::Operand Context::GetAddress (const Code::Instruction& instruction) const
{
	if (instruction.mnemonic == Code::Instruction::TRAP) return Code::Adr {generator.platform.function, "abort"};
	std::ostringstream address; address << '_' << instruction.mnemonic;
	if (HasType (instruction.operand1)) address << '_' << instruction.operand1.type;
	if (HasType (instruction.operand2) && instruction.operand2.type != instruction.operand1.type || instruction.mnemonic == Code::Instruction::CONV) address << '_' << instruction.operand2.type;
	if (HasType (instruction.operand3) && instruction.operand3.type != instruction.operand2.type) address << '_' << instruction.operand3.type;
	return Code::Adr {generator.platform.function, address.str ()};
}

void Context::AddFixup (const Label& label, const FixupCode code, const Code::Size size)
{
	assert (label.index < labels.size ()); assert (size);
	fixups.emplace_back (binary->bytes.size (), label.index, code, size); Reserve (size);
}

Code::Offset Context::GetOffset (const Byte*const byte) const
{
	const Code::Size offset = byte - binary->bytes.data (); assert (offset <= binary->bytes.size ()); return offset;
}

Code::Offset Context::GetBranchOffset (const Label& label, const Code::Offset defaultOffset) const
{
	assert (label.index < labels.size ());
	return label.index <= currentInstruction ? labels[label.index] - binary->bytes.size () : defaultOffset;
}

const Code::Instruction* Context::GetPreviousInstruction () const
{
	return currentInstruction ? &section->instructions[currentInstruction - 1] : nullptr;
}

Code::Operand Context::DisplaceStackPointer (const Code::Operand& operand, const Code::Displacement displacement)
{
	auto result = operand; if (result.Uses (Code::RSP)) result.displacement += displacement; return result;
}

void Context::Require (const Object::Section::Name& name)
{
	if (binary->AddRequirement (name) && listing) WriteIdentifier (listing << '\t' << Lexer::Require << '\t', name) << '\n';
}

void Context::SetGroup (const Object::Section::Name& name)
{
	assert (binary->group.empty ()); binary->group = name;
	if (listing) WriteIdentifier (listing << '\t' << Lexer::Group << '\t', name) << '\n';
}

void Context::AddAlias (const Code::Section::Name& name)
{
	binary->aliases.emplace_back (name, binary->bytes.size ());
	if (listing) WriteIdentifier (listing << '\t' << Lexer::Alias << '\t', name) << '\n';
}

void Context::AddLink (const Object::Section::Name& name, Object::Patch& patch)
{
	patch.offset += binary->bytes.size (); binary->AddLink (name, patch);
}

void Context::AddSection (const Code::Section::Type type, const Code::Section::Name& name, const Code::Section::Required required, const Code::Section::Duplicable duplicable, const Code::Section::Replaceable replaceable)
{
	binary = &binaries.emplace_back (type, name, 1, required, duplicable, replaceable); if (!listing) return;
	WriteIdentifier (listing << '\n' << '.' << type << ' ', name) << '\n';
	if (required) listing << '\t' << Assembly::Lexer::Required << '\n';
	if (duplicable) listing << '\t' << Assembly::Lexer::Duplicable << '\n';
	if (replaceable) listing << '\t' << Assembly::Lexer::Replaceable << '\n';
}

Context::LocalLabel Context::CreateLabel ()
{
	const auto index = labels.size (); labels.push_back (0); return {*this, index};
}

Context::Label Context::GetLabel (const Code::Offset offset) const
{
	const auto index = currentInstruction + offset + 1; assert (index <= section->instructions.size ()); return Label {index};
}

Code::Section::Name Context::DefineGlobal (const Code::Operand& value)
{
	std::ostringstream stream; stream << '_' << value.type << '_' << std::hex << Convert (value);
	const auto name = stream.str (); for (auto& section: globalDefinitions) if (section.name == name) return name;
	globalDefinitions.emplace_back (Code::Section::Const, name, generator.platform.GetAlignment (value.type), false, true);
	Format ("definition of %0", value).swap (globalDefinitions.back ().comment);
	globalDefinitions.back ().instructions.emplace_back (Code::Instruction::DEF, value); return name;
}

Context::Label Context::DefineLocal (const Code::Operand& value, const Code::Size forward, const Code::Size backward)
{
	const auto limit = binary->bytes.size () + forward;
	for (auto& definition: pendingDefinitions) if (definition.value == value) return definition.limit = std::min (definition.limit, limit), definition.label;
	for (auto& definition: appliedDefinitions) if (definition.value == value && binary->bytes.size () - labels[definition.label.index] <= backward) return definition.label;
	return pendingDefinitions.emplace_back (limit, *this, value).label;
}

void Context::ApplyLocalDefinitions (const Code::Offset offset)
{
	assert (!pendingDefinitions.empty ()); if (listing) listing << "\n\t; local definitions\n";
	if (offset || !IsSink (section->instructions[currentInstruction].mnemonic)) Generate (Code::BR {offset});
	for (auto& definition: pendingDefinitions) Apply (definition); Align (generator.assembler.instructionAlignment);
	appliedDefinitions.splice (appliedDefinitions.end (), pendingDefinitions);
}

void Context::Apply (LocalDefinition& definition)
{
	const auto alignment = generator.platform.GetAlignment (definition.value.type); AddAlignment (alignment);
	Align (alignment); definition.label (); Define (definition.value); currentDirective = Lexer::Invalid; if (listing) listing << '\n';
}

void Context::Assemble (const Code::Instruction& instruction)
{
	assert (IsValid (instruction, *section, generator.platform)); if (listing && listing.tellp ()) listing << '\n';
	if (!instruction.comment.empty () && listing) listing << "; " << instruction.comment << '\n';
	Assemble (instruction.operand1.address, instruction.operand2.size, instruction.operand3.address);
}

void Context::Assemble (const Source& source, const Line line, const Code::String& code)
{
	Program program {source}; std::istringstream assembly {code};
	generator.parser.Parse (assembly, line, program);
	generator.assembler.Assemble (program, binaries);
	if (listing) generator.printer.Print (program, listing);
}

void Context::AssembleInline (const Source& source, const Line line, const Code::String& code)
{
	std::stringstream assembly;
	for (auto symbol: symbols) if (symbol) Define (*symbol, assembly);
	if (assembly.tellp ()) WriteLine (assembly, line) << '\n';
	Instructions instructions; assembly << code;
	generator.parser.Parse (assembly, source, line, instructions);
	generator.assembler.Assemble (instructions, *binary);
	if (listing) generator.printer.Print (instructions, listing);
}

void Context::Define (const Debugging::Symbol& symbol, std::ostream& assembly)
{
	switch (symbol.model)
	{
	case Debugging::Symbol::Constant:
		WriteValue (WriteDefinition (WriteIdentifier (assembly, symbol.name)), symbol.value) << '\n';
		break;

	case Debugging::Symbol::Register:
		DefineRegister (GetDeclaration (symbol).operand3, symbol.name, assembly);
		break;

	case Debugging::Symbol::Variable:
		WriteDefinition (WriteIdentifier (assembly, symbol.name)) << symbol.displacement << '\n';
		break;

	default:
		assert (Debugging::Symbol::Unreachable);
	}
}

void Context::DefineRegister (const Code::Operand& operand, const Debugging::Name& name, std::ostream& assembly)
{
	assert (HasRegister (operand)); const auto parts = GetRegisterParts (operand);
	for (Part part = 0; part != parts; ++part) DefineRegister (operand, name, part, assembly);
}

void Context::DefineRegister (const Code::Operand& operand, const Debugging::Name& name, const Part part, std::ostream& assembly)
{
	if (const auto suffix = GetRegisterSuffix (operand, part)) WriteIdentifier (assembly, name + '.' + suffix); else WriteIdentifier (assembly, name);
	WriteRegister (WriteDefinition (assembly), operand, part) << '\n';
}

void Context::Define (const Code::Operand& operand)
{
	const auto size = operand.type.size;
	assert (generator.platform.IsAligned (*section, operand.type));
	assert (generator.platform.IsAligned (binary->bytes.size (), operand.type));

	if (listing)
	{
		const auto directive = size == 8 ? Lexer::OByte : size == 4 ? Lexer::QByte : size == 3 ? Lexer::TByte : size == 2 ? Lexer::DByte : Lexer::Byte;
		if (directive == currentDirective && !IsAddress (operand)) listing << ", ";
		else if (currentDirective) listing << "\n\t" << directive << '\t'; else listing << '\t' << directive << '\t';
		currentDirective = directive;
	}

	if (IsImmediate (operand)) Define (Convert (operand) >> GetPatchScale (operand.type), size);
	else Define (GetAddress (operand), GetPatchMode (operand.type), operand.displacement, GetPatchScale (operand.type), size);
}

void Context::Define (const Object::Section::Name& name, const Object::Patch::Mode mode, const Object::Patch::Displacement displacement, const Object::Patch::Scale scale, const Code::Type::Size size)
{
	Object::Patch patch {0, mode, displacement, scale}; patch.pattern = {size, endianness}; AddLink (name, patch); Reserve (size);
	if (listing) WriteAddress (listing, GetFunction (mode), name, displacement, scale);
}

void Context::Define (const Code::Unsigned::Value value, const Code::Type::Size size)
{
	Object::Pattern {size, endianness}.Patch (value, Reserve (size)); if (listing) listing << value;
}

Span<Byte> Context::Reserve (const Code::Size size)
{
	const auto previous = binary->bytes.size (); binary->bytes.resize (previous + size); return {binary->bytes.data () + previous, size};
}

void Context::Align (const Code::Section::Alignment alignment)
{
	if (listing && binary->bytes.size () % alignment) listing << '\t' << Lexer::Align << '\t' << alignment << '\n';
	Reserve (ECS::Align (binary->bytes.size (), Code::Size (alignment)) - binary->bytes.size ());
}

void Context::AddAlignment (const Code::Section::Alignment alignment)
{
	assert (IsPowerOfTwo (alignment)); assert (IsCode (section->type));
	if (!binary->fixed && alignment > binary->alignment) binary->alignment = alignment;
}

Debugging::Index Context::Insert (const Source& source)
{
	for (auto& element: information.sources) if (element == source) return GetIndex (element, information.sources);
	information.sources.emplace_back (source); return information.sources.size () - 1;
}

Debugging::Type& Context::Declare (Debugging::Type&& type)
{
	if (IsCode (section->type)) AddTypeableEntry (Debugging::Entry::Code); else if (IsData (section->type)) AddTypeableEntry (Debugging::Entry::Data);
	if (types.empty ()) if (!declarations.empty () && IsFunction (*declarations.back ().type)) types.push_back (&declarations.back ().type->subtypes.emplace_back ()); else EmitError ("invalid type declaration");
	auto& result = *types.back (); result = std::move (type); types.pop_back (); for (auto& subtype: Reverse {result.subtypes}) types.push_back (&subtype); return result;
}

void Context::AddEntry (const Debugging::Entry::Model model)
{
	if (!entry) entry = &information.entries.emplace_back (model, section->name), entry->size = 0;
}

void Context::AddTypeableEntry (const Debugging::Entry::Model model)
{
	if (!entry) AddEntry (model), location = &entry->location, types.push_back (&entry->type);
}

void Context::Declare (const Code::Offset offset, const Code::String& name, const Code::Operand& operand)
{
	const Debugging::Lifetime lifetime = {offset < 0 ? currentInstruction + offset + 1 : currentInstruction, offset < 0 ? currentInstruction : currentInstruction + offset};
	if (IsImmediate (operand)) Declare ({name, lifetime, GetValue (operand)});
	else if (IsRegister (operand)) Declare ({name, lifetime, GetRegisterName (operand)});
	else if (!operand.address.empty ()) Declare ({name, lifetime, operand.address, 0});
	else Declare ({name, lifetime, GetRegisterName (operand), operand.displacement});
	if (IsRegister (operand)) Fix (operand.register_);
}

void Context::Declare (Debugging::Symbol&& symbol)
{
	if (IsCode (section->type)) AddTypeableEntry (Debugging::Entry::Code);
	if (location) EmitError ("missing source code location"); entry->symbols.push_back (std::move (symbol));
	location = &entry->symbols.back ().location; types.push_back (&entry->symbols.back ().type); symbols.push_back (&entry->symbols.back ());
}

void Context::Undeclare (Debugging::Symbol& symbol)
{
	assert (symbol.lifetime.end == currentInstruction);
	if (IsRegister (symbol)) Unfix (GetDeclaration (symbol).operand3.register_);
	if (binary) symbol.lifetime = {labels[symbol.lifetime.begin], binary->bytes.size ()};
}

const Code::Instruction& Context::GetDeclaration (const Debugging::Symbol& symbol) const
{
	assert (IsRegister (symbol));
	return section->instructions[std::min (symbol.lifetime.begin, symbol.lifetime.end)];
}

Debugging::Name Context::GetRegisterName (const Code::Operand& operand)
{
	assert (HasRegister (operand)); const auto parts = GetRegisterParts (operand); std::ostringstream stream;
	for (Part part = 0; part != parts; ++part) WriteRegister (part ? stream << ':' : stream, operand, part);
	return stream.str ();
}

Debugging::Type Context::GetType (const Code::Operand& operand)
{
	if (IsString (operand)) return operand.address;

	switch (operand.type.model)
	{
	case Code::Type::Signed:
		return {Debugging::Type::Signed, operand.type.size};
	case Code::Type::Unsigned:
		return {Debugging::Type::Unsigned, operand.type.size};
	case Code::Type::Float:
		return {Debugging::Type::Float, operand.type.size};
	case Code::Type::Pointer:
		return {Debugging::Type::Pointer, 0, Debugging::Type::Void};
	case Code::Type::Function:
		return {Debugging::Type::Pointer, 0, Debugging::Type::Function};
	default:
		assert (Code::Type::Unreachable);
	}
}

Debugging::Value Context::GetValue (const Code::Operand& operand)
{
	assert (IsImmediate (operand));

	switch (operand.type.model)
	{
	case Code::Type::Signed:
		return operand.simm;
	case Code::Type::Unsigned:
		return operand.uimm;
	case Code::Type::Float:
		return operand.fimm;
	case Code::Type::Pointer:
		return operand.ptrimm;
	case Code::Type::Function:
		return operand.funimm;
	default:
		assert (Code::Type::Unreachable);
	}
}

std::ostream& Context::WriteValue (std::ostream& stream, const Debugging::Value& value)
{
	switch (value.model)
	{
	case Debugging::Type::Signed:
		return stream << value.signed_;
	case Debugging::Type::Unsigned:
		return stream << value.unsigned_;
	case Debugging::Type::Float:
		return stream << value.float_;
	default:
		assert (Debugging::Type::Unreachable);
	}
}

Context::Label::Label (const Code::Size i) :
	index {i}
{
}

Context::LocalLabel::LocalLabel (Context& c, const Code::Size i) :
	Label {i}, context {&c}
{
}

Context::LocalLabel::LocalLabel (LocalLabel&& label) noexcept :
	Label {label.index}, context {label.context}
{
	label.context = nullptr;
}

Context::LocalLabel::~LocalLabel ()
{
	if (!std::uncaught_exceptions ()) assert (!context);
}

void Context::LocalLabel::operator () ()
{
	assert (context); assert (index < context->labels.size ());
	assert (index > context->section->instructions.size ());
	context->labels[index] = context->binary->bytes.size ();
	if (context->listing) context->listing << *this << ':';
	context = nullptr;
}

Context::LocalDefinition::LocalDefinition (const Code::Size l, Context& context, const Code::Operand& v) :
	limit {l}, label {context.CreateLabel ()}, value {v}
{
}

Context::InstructionFixup::InstructionFixup (const Code::Size o, const Code::Size i, const FixupCode c, const Code::Size s) :
	offset {o}, index {i}, code {c}, size {s}
{
}

Context::TypeDeclaration::TypeDeclaration (const Code::Size e, Debugging::Type& t) :
	extent {e}, type {&t}
{
}

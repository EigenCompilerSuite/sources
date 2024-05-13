// WebAssembly instruction set representation
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

#include "ieee.hpp"
#include "object.hpp"
#include "utilities.hpp"
#include "wasm.hpp"

#include <cassert>

using namespace ECS;
using namespace WebAssembly;

struct Instruction::Entry
{
	Mnemonic mnemonic;
	Byte code, integer;
	Operand::Type type1, type2, type3;
};

static const char*const typeCodeNames[] = {
	#define TYPECODE(name, code, value) #name,
	#include "wasm.def"
};

static const Byte typeCodeValues[] = {
	#define TYPECODE(name, code, value) value,
	#include "wasm.def"
};

constexpr const Instruction::Entry Instruction::table[] {
	#define INSTR(mnem, code, integer, type1, type2, type3) {Instruction::mnem, code, integer, Operand::type1, Operand::type2, Operand::type3},
	#include "wasm.def"
};

const char*const Instruction::mnemonics[] {
	#define MNEM(name, mnem) #name,
	#include "wasm.def"
};

constexpr Lookup<Instruction::Entry, Instruction::Mnemonic> Instruction::first {table}, Instruction::last {table, 0};

Operand::Operand (const WebAssembly::Float f) :
	model {Float}, float_ {f}
{
}

Operand::Operand (const WebAssembly::Integer i) :
	model {Integer}, integer {i}
{
}

Operand::Operand (const WebAssembly::TypeCode tc) :
	model {TypeCode}, typeCode {tc}
{
}

std::size_t Operand::GetSize (const Type type) const
{
	switch (type)
	{
	case Alignment: case DataIndex: case ElementIndex: case FunctionIndex: case GlobalIndex: case LabelIndex: case LocalIndex: case Offset: case TableIndex: case TypeIndex: return GetSize (Unsigned32);
	case BlockType: return model == Empty ? GetSize (EmptyType) : model == TypeCode ? GetSize (ValueType) : GetSize (TypeIndex);
	case EmptyType: case LaneIndex: case NumberType: case VectorType: case ValueType: case ReferenceType: case ZeroIndex: return 1;
	case Float32: return 4;
	case Float64: return 8;
	case Signed32: case Signed64: return GetSize (Signed (integer));
	case Unsigned32: case Unsigned64: return GetSize (Unsigned (integer));
	default: return 0;
	}
}

bool Operand::IsCompatibleWith (const Type type) const
{
	switch (type)
	{
	case Alignment: return IsCompatibleWith (Unsigned32) && (integer == 0 || integer <= 32 && IsPowerOfTwo (integer));
	case BlockType: return IsCompatibleWith (EmptyType) || IsCompatibleWith (TypeIndex) || IsCompatibleWith (ValueType);
	case DataIndex: case ElementIndex: case FunctionIndex: case GlobalIndex: case LabelIndex: case LocalIndex: case Offset: case TableIndex: case TypeIndex: return IsCompatibleWith (Unsigned32);
	case Float32: case Float64: return model == Float || model == Integer;
	case LaneIndex: return model == Integer && integer >= 0 && integer <= 255;
	case NumberType: return model == TypeCode && (typeCode == TypeCode::I32 || typeCode == TypeCode::I64 || typeCode == TypeCode::F32 || typeCode == TypeCode::F64);
	case ReferenceType: return model == TypeCode && (typeCode == TypeCode::FuncRef || typeCode == TypeCode::ExternRef);
	case Signed32: return model == Integer && integer >= -WebAssembly::Integer (2147483648) && integer <= WebAssembly::Integer (2147483647);
	case Signed64: case Unsigned64: return model == Integer;
	case Unsigned32: return model == Integer && integer >= 0 && integer <= WebAssembly::Integer (4294967295);
	case VectorType: return model == TypeCode && typeCode == TypeCode::V128;
	case ValueType: return IsCompatibleWith (NumberType) || IsCompatibleWith (VectorType) || IsCompatibleWith (ReferenceType);
	default: return model == Empty;
	}
}

void Operand::Encode (const Type type, Byte*& begin, Byte*const end) const
{
	switch (type)
	{
	case Alignment: case DataIndex: case ElementIndex: case FunctionIndex: case GlobalIndex: case LabelIndex: case LocalIndex: case Offset: case TableIndex: case TypeIndex: return Encode (Unsigned32, begin, end);
	case BlockType: return model == Empty ? Encode (EmptyType, begin, end) : model == TypeCode ? Encode (ValueType, begin, end) : Encode (TypeIndex, begin, end);
	case Float32: case Float64: return Encode (model == Integer ? WebAssembly::Float (integer) : float_, begin, end, GetSize (type));
	case EmptyType: return Encode (Byte {0x40}, begin, end);
	case LaneIndex: return Encode (Byte (integer), begin, end);
	case NumberType: case ReferenceType: case ValueType: case VectorType: return Encode (typeCode, begin, end);
	case Signed32: case Signed64: return Encode (Signed (integer), begin, end);
	case Unsigned32: case Unsigned64: return Encode (Unsigned (integer), begin, end);
	case ZeroIndex: return Encode (Byte {0x00}, begin, end);
	default: return;
	}
}

bool Operand::Decode (const Byte*& begin, const Byte*const end, const Type type)
{
	switch (type)
	{
	case Alignment: case DataIndex: case ElementIndex: case FunctionIndex: case GlobalIndex: case LabelIndex: case LocalIndex: case Offset: case TableIndex: case TypeIndex: return Decode (begin, end, Unsigned32);
	case BlockType: if (auto previous = begin; Decode (begin, end, EmptyType)) return true; else return Decode (begin = previous, end, ValueType) || Decode (begin = previous, end, TypeIndex);
	case Float32: case Float64: return model = Float, Decode (begin, end, float_, GetSize (type));
	case EmptyType: if (Byte code; Decode (begin, end, code) && code == 0x40) return model = Empty, true; else return false;
	case LaneIndex: if (Byte code; Decode (begin, end, code)) return model = Integer, integer = code, true; else return false;
	case NumberType: case ReferenceType: case ValueType: case VectorType: return model = TypeCode, Decode (begin, end, typeCode);
	case Signed32: case Signed64: if (Signed value; Decode (begin, end, value)) return model = Integer, integer = value, true; else return false;
	case Unsigned32: case Unsigned64: if (Unsigned value; Decode (begin, end, value)) return model = Integer, integer = value, true; else return false;
	case ZeroIndex: if (Byte code; Decode (begin, end, code) && code == 0x00) return model = Empty, true; else return false;
	default: return model = Empty, true;
	}
}

void Operand::Encode (const Byte code, Byte*& begin, Byte*const end)
{
	assert (begin != end); *begin++ = code;
}

bool Operand::Decode (const Byte*& begin, const Byte*const end, Byte& code)
{
	if (begin != end) return code = *begin++, true; else return false;
}

void Operand::Encode (const WebAssembly::TypeCode typeCode, Byte*& begin, Byte*const end)
{
	Encode (typeCodeValues[int (typeCode)], begin, end);
}

bool Operand::Decode (const Byte*& begin, const Byte*const end, WebAssembly::TypeCode& typeCode)
{
	if (Byte code; Decode (begin, end, code)) for (auto& value: typeCodeValues) if (code == value) return typeCode = WebAssembly::TypeCode (&value - typeCodeValues), true; return false;
}

void Operand::Encode (WebAssembly::Float float_, Byte*& begin, Byte*const end, std::size_t size)
{
	for (Unsigned value = size == 4 ? IEEE::SinglePrecision::Encode (float_) : IEEE::DoublePrecision::Encode (float_); size; --size) Encode (Byte (value), begin, end), value >>= 8;
}

bool Operand::Decode (const Byte*& begin, const Byte*const end, WebAssembly::Float& float_, std::size_t size)
{
	Unsigned value = 0; for (Unsigned count = size, shift = 0; count; --count, shift += 8) if (Byte code; Decode (begin, end, code)) value |= Unsigned (code) << shift; else return false;
	float_ = size == 4 ? IEEE::SinglePrecision::Decode (value) : IEEE::DoublePrecision::Decode (value); return true;
}

void Operand::Encode (Signed value, Byte*& begin, Byte*const end)
{
	Byte code; do code = value & 0x7f, value >>= 7, code |= ((value != 0 || code & 0x40) && (value != -1 || !(code & 0x40))) << 7, Encode (code, begin, end); while (code & 0x80);
}

bool Operand::Decode (const Byte*& begin, const Byte*const end, Signed& value)
{
	value = 0; Byte code, shift = 0; do if (Decode (begin, end, code)) value |= Signed (code & 0x7f) << shift, shift += 7; else return false; while (code & 0x80); if ((shift < 64) && (code & 0x40)) value |= Unsigned (~0) << shift; return true;
}

void Operand::Encode (Unsigned value, Byte*& begin, Byte*const end, int minimum)
{
	Byte code, more; do code = value & 0x7f, value >>= 7, more = (--minimum > 0 || value) << 7, code |= more, Encode (code, begin, end); while (more);
}

bool Operand::Decode (const Byte*& begin, const Byte*const end, Unsigned& value)
{
	value = 0; Byte code, shift = 0; do if (!Decode (begin, end, code)) return false; else value |= Unsigned (code & 0x7f) << shift, shift += 7; while (code & 0x80); return true;
}

std::size_t Operand::GetSize (Signed value)
{
	std::size_t size = 0; Byte code; do code = value & 0x7f, value >>= 7, ++size; while ((value != 0 || code & 0x40) && (value != -1 || !(code & 0x40))); return size;
}

std::size_t Operand::GetSize (Unsigned value)
{
	std::size_t size = 0; do value >>= 7, ++size; while (value); return size;
}

Instruction::Instruction (const Span<const Byte> bytes)
{
	auto begin = bytes.begin (), end = bytes.end (); Byte code;
	if (!Operand::Decode (begin, end, code) || code == 0xFE) return;
	for (auto& entry: table) if (Operand::Unsigned integer; entry.code == code)
		if (auto next = begin; entry.code != 0xFC && entry.code != 0xFD || Operand::Decode (next, end, integer) && entry.integer == integer)
			if (operand1.Decode (next, end, entry.type1) && operand1.IsCompatibleWith (entry.type1))
				if (operand2.Decode (next, end, entry.type2) && operand2.IsCompatibleWith (entry.type2))
					if (operand3.Decode (next, end, entry.type3) && operand3.IsCompatibleWith (entry.type3))
						{this->entry = &entry; size = next - bytes.begin (); return;}
}

Instruction::Instruction (const Mnemonic mnemonic, const Operand& o1, const Operand& o2, const Operand& o3) :
	operand1 {o1}, operand2 {o2}, operand3 {o3}
{
	for (auto& entry: Span<const Entry> {first[mnemonic], last[mnemonic]})
		if (operand1.IsCompatibleWith (entry.type1) && operand2.IsCompatibleWith (entry.type2) && operand3.IsCompatibleWith (entry.type3))
			if (this->entry = &entry, entry.mnemonic == I32) {size = 5; return;}
			else if (entry.code == 0xFE) {size = operand1.GetSize (entry.type1); return;}
			else {size = (entry.code == 0xFC || entry.code == 0xFD ? Operand::GetSize (Operand::Unsigned (entry.integer)) + 1 : 1) + operand1.GetSize (entry.type1) + operand2.GetSize (entry.type2) + operand3.GetSize (entry.type3); return;}
}

void Instruction::Emit (const Span<Byte> bytes) const
{
	assert (entry); auto begin = bytes.begin (), end = bytes.end ();
	if (entry->mnemonic == I32) return Operand::Encode (Operand::Unsigned (operand1.integer), begin, end, 5);
	if (entry->code == 0xFE) return operand1.Encode (entry->type1, begin, end);
	if (Operand::Encode (entry->code, begin, end), entry->code == 0xFC || entry->code == 0xFD) Operand::Encode (Operand::Unsigned (entry->integer), begin, end);
	operand1.Encode (entry->type1, begin, end); operand2.Encode (entry->type2, begin, end); operand3.Encode (entry->type3, begin, end);
}

void Instruction::Adjust (Object::Patch& patch) const
{
	assert (entry);
	if (entry->mnemonic == I32) patch.pattern = {{0, 0x7f}, {1, 0x7f}, {2, 0x7f}, {3, 0x7f}, {3, 0x7f}};
}

std::size_t WebAssembly::GetSize (const Instruction& instruction)
{
	assert (instruction.entry); return instruction.size;
}

std::istream& WebAssembly::operator >> (std::istream& stream, TypeCode& typeCode)
{
	return ReadSortedEnum (stream, typeCode, typeCodeNames, IsAlnum);
}

std::ostream& WebAssembly::operator << (std::ostream& stream, const TypeCode typeCode)
{
	return WriteEnum (stream, typeCode, typeCodeNames);
}

std::istream& WebAssembly::operator >> (std::istream& stream, Operand& operand)
{
	Float float_; Integer integer; TypeCode typeCode;
	if (stream >> std::ws && std::isalpha (stream.peek ()) && stream >> typeCode) operand = typeCode;
	else if (stream >> integer) if (stream.good () && stream.peek () == '.' && stream >> float_) operand = float_ + integer; else operand = integer;
	return stream;
}

std::ostream& WebAssembly::operator << (std::ostream& stream, const Operand& operand)
{
	switch (operand.model)
	{
	case Operand::Float: return stream << operand.float_;
	case Operand::Integer: return stream << operand.integer;
	case Operand::TypeCode: return stream << operand.typeCode;
	default: return stream;
	}
}

std::istream& WebAssembly::operator >> (std::istream& stream, Instruction& instruction)
{
	Instruction::Mnemonic mnemonic;
	Operand operand1, operand2, operand3;

	if (stream >> mnemonic && stream.good () && stream >> std::ws && stream.good ())
		if (stream >> operand1 && stream.good () && stream >> std::ws && stream.good ())
			if (stream >> operand2 && stream.good () && stream >> std::ws && stream.good ())
				stream >> operand3;

	if (stream) instruction = {mnemonic, operand1, operand2, operand3};
	return stream;
}

std::ostream& WebAssembly::operator << (std::ostream& stream, const Instruction& instruction)
{
	assert (instruction.entry);
	if (stream << instruction.entry->mnemonic && !IsEmpty (instruction.operand1))
		if (stream << '\t' << instruction.operand1 && !IsEmpty (instruction.operand2))
			if (stream << ' ' << instruction.operand2 && !IsEmpty (instruction.operand3))
				stream << ' ' << instruction.operand3;
	return stream;
}

std::istream& WebAssembly::operator >> (std::istream& stream, Instruction::Mnemonic& mnemonic)
{
	return ReadSortedEnum (stream, mnemonic, Instruction::mnemonics, IsIdentifier);
}

std::ostream& WebAssembly::operator << (std::ostream& stream, const Instruction::Mnemonic mnemonic)
{
	return WriteEnum (stream, mnemonic, Instruction::mnemonics);
}

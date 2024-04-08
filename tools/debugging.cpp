// Debugging information representation
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

#include "debugging.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cstdlib>

using namespace ECS;
using namespace Debugging;

static const char*const endiannesses[] {"little", "big"};
static const char*const entries[] {"code", "data", "type"};
static const char*const types[] {"void", nullptr, "signed", "unsigned", "float", "array", "record", "pointer", "reference", "function", "enumeration"};

Breakpoint::Breakpoint (const Offset o) :
	offset {o}
{
}

Type::Type (const Model m, const Size s, Type&& t) :
	model {m}, size {s}
{
	if (IsCompound (*this)) subtypes.push_back (std::move (t));
}

Type::Type (const Debugging::Name& n) :
	model {Name}, name {n}
{
}

Value::Value (const Signed s) :
	model {Type::Signed}, signed_ {s}
{
}

Value::Value (const Unsigned u) :
	model {Type::Unsigned}, unsigned_ {u}
{
}

Value::Value (const Float f) :
	model {Type::Float}, float_ {f}
{
}

Field::Field (const Name& n, const Offset o, const Mask m) :
	name {n}, offset {o}, mask {m}
{
}

Enumerator::Enumerator (const Name& n, const Value& v) :
	name {n}, value {v}
{
}

Symbol::Symbol (const Name& n, const Lifetime& l, const Value& v) :
	model {Constant}, name {n}, lifetime {l}, value {v}
{
}

Symbol::Symbol (const Name& n, const Lifetime& l, const Debugging::Register& r) :
	model {Register}, name {n}, lifetime {l}, register_ {r}
{
}

Symbol::Symbol (const Name& n, const Lifetime& l, const Debugging::Register& r, const Displacement d) :
	model {Variable}, name {n}, lifetime {l}, register_ {r}, displacement {d}
{
}

Entry::Entry (const Model m, const Name& n) :
	model {m}, name {n}
{
}

bool Debugging::IsName (const Type& type)
{
	return type.model == Type::Name;
}

bool Debugging::IsArray (const Type& type)
{
	return type.model == Type::Array;
}

bool Debugging::IsRecord (const Type& type)
{
	return type.model == Type::Record;
}

bool Debugging::IsFunction (const Type& type)
{
	return type.model == Type::Function;
}

bool Debugging::IsEnumeration (const Type& type)
{
	return type.model == Type::Enumeration;
}

bool Debugging::IsBasic (const Type& type)
{
	return type.model == Type::Signed || type.model == Type::Unsigned || type.model == Type::Float;
}

bool Debugging::IsCompound (const Type& type)
{
	return type.model == Type::Array || type.model == Type::Pointer || type.model == Type::Reference || type.model == Type::Function || type.model == Type::Enumeration;
}

bool Debugging::IsConstant (const Symbol& symbol)
{
	return symbol.model == Symbol::Constant;
}

bool Debugging::IsRegister (const Symbol& symbol)
{
	return symbol.model == Symbol::Register;
}

bool Debugging::IsVariable (const Symbol& symbol)
{
	return symbol.model == Symbol::Variable;
}

bool Debugging::IsAlias (const Symbol& symbol)
{
	return IsVariable (symbol) && !symbol.displacement;
}

bool Debugging::IsBase (const Field& field)
{
	return field.name.empty ();
}

bool Debugging::IsBitField (const Field& field)
{
	return field.mask;
}

bool Debugging::IsResult (const Symbol& symbol)
{
	return symbol.name.empty ();
}

bool Debugging::IsValid (const Location& location)
{
	return location.line && location.column;
}

bool Debugging::IsCode (const Entry& entry)
{
	return entry.model == Entry::Code;
}

bool Debugging::IsData (const Entry& entry)
{
	return entry.model == Entry::Data;
}

bool Debugging::IsType (const Entry& entry)
{
	return entry.model == Entry::Type;
}

std::istream& Debugging::ReadValue (std::istream& stream, Value& value)
{
	if (stream >> std::ws && stream.peek () == '-') return value.model = Type::Signed, stream >> value.signed_;
	return value.model = Type::Unsigned, stream >> value.unsigned_;
}

std::ostream& Debugging::WriteValue (std::ostream& stream, const Value& value)
{
	switch (value.model)
	{
	case Type::Signed:
		return stream << value.signed_;
	case Type::Unsigned:
		return stream << value.unsigned_;
	case Type::Float:
		return stream << value.float_;
	default:
		assert (Type::Unreachable);
	}
}

std::istream& Debugging::operator >> (std::istream& stream, Location& location)
{
	if (stream >> location.index >> location.line >> location.column && !IsValid (location)) stream.setstate (stream.failbit); return stream;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Location& location)
{
	return stream << location.index << ' ' << location.line << ' ' << location.column;
}

std::istream& Debugging::operator >> (std::istream& stream, Lifetime& lifetime)
{
	return stream >> lifetime.begin >> lifetime.end;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Lifetime& lifetime)
{
	return stream << lifetime.begin << ' ' << lifetime.end;
}

std::istream& Debugging::operator >> (std::istream& stream, Type& type)
{
	if (stream >> std::ws && stream.peek () == '"') type.model = Type::Name, ReadString (stream, type.name, '"'); else if (!ReadEnum (stream, type.model, types, IsAlpha)) return stream;
	if (IsBasic (type) || IsArray (type) && stream >> type.index || IsRecord (type) || IsFunction (type)) stream >> type.size; type.enumerators.clear (); type.subtypes.clear ();
	if (IsCompound (type)) stream >> type.subtypes.emplace_back ();
	if (IsRecord (type)) while (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '"') stream >> type.fields.emplace_back ();
	if (IsFunction (type)) while (type.size--) stream >> type.subtypes.emplace_back ();
	if (IsEnumeration (type)) while (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '"') stream >> type.enumerators.emplace_back ();
	return stream;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Type& type)
{
	if (IsName (type)) WriteString (stream, type.name, '"'); else WriteEnum (stream, type.model, types);
	if (IsBasic (type) || IsArray (type) && stream << ' ' << type.index || IsRecord (type)) stream << ' ' << type.size;
	if (IsFunction (type)) stream << ' ' << type.subtypes.size () - 1;
	if (IsCompound (type)) for (auto& subtype: type.subtypes) stream << ' ' << subtype;
	if (IsRecord (type)) for (auto& field: type.fields) stream << ' ' << field;
	if (IsEnumeration (type)) for (auto& enumerator: type.enumerators) stream << ' ' << enumerator;
	return stream;
}

std::istream& Debugging::operator >> (std::istream& stream, Value& value)
{
	if (!ReadEnum (stream, value.model, types, IsAlpha)) return stream;

	switch (value.model)
	{
	case Type::Signed:
		return stream >> value.signed_;
	case Type::Unsigned:
		return stream >> value.unsigned_;
	case Type::Float:
		return ReadFloat (stream, value.float_, std::strtod);
	default:
		return stream.setstate (stream.failbit), stream;
	}
}

std::ostream& Debugging::operator << (std::ostream& stream, const Value& value)
{
	return WriteValue (WriteEnum (stream, value.model, types) << ' ', value);
}

std::istream& Debugging::operator >> (std::istream& stream, Field& field)
{
	return ReadString (stream, field.name, '"') >> field.location >> field.type >> field.offset >> field.mask;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Field& field)
{
	return WriteString (stream, field.name, '"') << ' ' << field.location << ' ' << field.type << ' ' << field.offset << ' ' << field.mask;
}

std::istream& Debugging::operator >> (std::istream& stream, Enumerator& enumerator)
{
	return ReadValue (ReadString (stream, enumerator.name, '"') >> enumerator.location, enumerator.value);
}

std::ostream& Debugging::operator << (std::ostream& stream, const Enumerator& enumerator)
{
	return WriteValue (WriteString (stream, enumerator.name, '"') << ' ' << enumerator.location << ' ', enumerator.value);
}

std::istream& Debugging::operator >> (std::istream& stream, Symbol& symbol)
{
	ReadString (stream, symbol.name, '"') >> symbol.location;
	if (stream >> std::ws && std::isalpha (stream.peek ())) symbol.model = Symbol::Constant, stream >> symbol.value;
	else if (ReadString (stream, symbol.register_, '"')) symbol.model = stream.good () && stream >> std::ws && stream.good () && (stream.peek () == '-' || stream.peek () == '+') && stream >> symbol.displacement ? Symbol::Variable : Symbol::Register;
	return stream >> symbol.type >> symbol.lifetime;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Symbol& symbol)
{
	WriteString (stream, symbol.name, '"') << ' ' << symbol.location;
	if (IsConstant (symbol)) stream << ' ' << symbol.value; else WriteString (stream << ' ', symbol.register_, '"');
	if (IsVariable (symbol)) (symbol.displacement < 0 ? stream << ' ' : stream << " +") << symbol.displacement;
	return stream << ' ' << symbol.type << ' ' << symbol.lifetime;
}

std::istream& Debugging::operator >> (std::istream& stream, Breakpoint& breakpoint)
{
	return stream >> breakpoint.offset >> breakpoint.location;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Breakpoint& breakpoint)
{
	return stream << breakpoint.offset << ' ' << breakpoint.location;
}

std::istream& Debugging::operator >> (std::istream& stream, Entry& entry)
{
	entry.symbols.clear (); entry.breakpoints.clear ();
	ReadString (ReadEnum (stream, entry.model, entries, IsAlpha), entry.name, '"');
	if (stream >> std::ws && std::isdigit (stream.peek ())) stream >> entry.location; else entry.location = {};
	stream >> entry.type; if (!IsType (entry)) stream >> entry.size;
	while (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '"') stream >> entry.symbols.emplace_back ();
	while (stream.good () && stream >> std::ws && stream.good () && std::isdigit (stream.peek ())) stream >> entry.breakpoints.emplace_back ();
	return stream;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Entry& entry)
{
	WriteString (WriteEnum (stream, entry.model, entries) << ' ', entry.name, '"');
	if (IsValid (entry.location)) stream << ' ' << entry.location;
	if (!IsType (entry)) stream << ' ' << entry.type << ' ' << entry.size << '\n';
	else if (!IsRecord (entry.type)) stream << ' ' << entry.type << '\n';
	else for (auto& field: WriteEnum (stream << ' ', entry.type.model, types) << ' ' << entry.type.size << '\n', entry.type.fields) stream << '\t' << field << '\n';
	for (auto& symbol: entry.symbols) stream << '\t' << symbol << '\n';
	for (auto& breakpoint: entry.breakpoints) stream << '\t' << breakpoint << '\n';
	return stream;
}

std::istream& Debugging::operator >> (std::istream& stream, Target& target)
{
	return ReadEnum (ReadString (stream, target.name, '"'), target.endianness, endiannesses, IsAlpha) >> target.pointer;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Target& target)
{
	return WriteEnum (WriteString (stream, target.name, '"') << ' ', target.endianness, endiannesses) << ' ' << target.pointer;
}

std::istream& Debugging::operator >> (std::istream& stream, Information& information)
{
	stream >> information.target; information.sources.clear (); information.entries.clear ();
	do ReadString (stream, information.sources.emplace_back (), '"'); while (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '"');
	while (stream.good () && stream >> std::ws && stream.good ()) stream >> information.entries.emplace_back ();
	return stream;
}

std::ostream& Debugging::operator << (std::ostream& stream, const Information& information)
{
	stream << information.target << '\n';
	for (auto& source: information.sources) WriteString (stream << '\t', source, '"') << '\n';
	for (auto& entry: information.entries) stream << entry;
	return stream;
}

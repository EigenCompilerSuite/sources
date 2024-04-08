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

#ifndef ECS_DEBUGGING_HEADER_INCLUDED
#define ECS_DEBUGGING_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>
#include <list>
#include <string>
#include <vector>

namespace ECS
{
	enum class Endianness;

	using Column = std::streamoff;
	using Line = std::streamoff;
	using Source = std::string;
}

namespace ECS::Debugging
{
	struct Breakpoint;
	struct Entry;
	struct Enumerator;
	struct Field;
	struct Information;
	struct Lifetime;
	struct Location;
	struct Symbol;
	struct Target;
	struct Type;
	struct Value;

	using Breakpoints = std::vector<Breakpoint>;
	using Entries = std::vector<Entry>;
	using Enumerators = std::vector<Enumerator>;
	using Fields = std::vector<Field>;
	using Index = std::size_t;
	using Name = std::string;
	using Offset = std::size_t;
	using Register = std::string;
	using Size = std::size_t;
	using Sources = std::vector<Source>;
	using Symbols = std::list<Symbol>;
	using Types = std::vector<Type>;

	bool IsAlias (const Symbol&);
	bool IsArray (const Type&);
	bool IsBase (const Field&);
	bool IsBasic (const Type&);
	bool IsBitField (const Field&);
	bool IsCode (const Entry&);
	bool IsCompound (const Type&);
	bool IsConstant (const Symbol&);
	bool IsData (const Entry&);
	bool IsEnumeration (const Type&);
	bool IsFunction (const Type&);
	bool IsName (const Type&);
	bool IsRecord (const Type&);
	bool IsRegister (const Symbol&);
	bool IsResult (const Symbol&);
	bool IsType (const Entry&);
	bool IsValid (const Location&);
	bool IsVariable (const Symbol&);

	std::istream& ReadValue (std::istream&, Value&);
	std::ostream& WriteValue (std::ostream&, const Value&);

	std::istream& operator >> (std::istream&, Breakpoint&);
	std::istream& operator >> (std::istream&, Entry&);
	std::istream& operator >> (std::istream&, Enumerator&);
	std::istream& operator >> (std::istream&, Field&);
	std::istream& operator >> (std::istream&, Information&);
	std::istream& operator >> (std::istream&, Lifetime&);
	std::istream& operator >> (std::istream&, Location&);
	std::istream& operator >> (std::istream&, Symbol&);
	std::istream& operator >> (std::istream&, Target&);
	std::istream& operator >> (std::istream&, Type&);
	std::istream& operator >> (std::istream&, Value&);
	std::ostream& operator << (std::ostream&, const Breakpoint&);
	std::ostream& operator << (std::ostream&, const Entry&);
	std::ostream& operator << (std::ostream&, const Enumerator&);
	std::ostream& operator << (std::ostream&, const Field&);
	std::ostream& operator << (std::ostream&, const Information&);
	std::ostream& operator << (std::ostream&, const Lifetime&);
	std::ostream& operator << (std::ostream&, const Location&);
	std::ostream& operator << (std::ostream&, const Symbol&);
	std::ostream& operator << (std::ostream&, const Target&);
	std::ostream& operator << (std::ostream&, const Type&);
	std::ostream& operator << (std::ostream&, const Value&);
}

struct ECS::Debugging::Location
{
	Index index;
	Line line;
	Column column;
};

struct ECS::Debugging::Lifetime
{
	Offset begin, end;
};

struct ECS::Debugging::Type
{
	enum Model {Void, Name, Signed, Unsigned, Float, Array, Record, Pointer, Reference, Function, Enumeration, Unreachable = 0};

	Model model;
	Size size;
	Index index;
	Debugging::Name name;
	Types subtypes;
	Fields fields;
	Enumerators enumerators;

	Type () = default;
	Type (const Debugging::Name&);
	Type (Model, Size = 0, Type&& = {});
};

struct ECS::Debugging::Value
{
	using Float = double;
	using Signed = std::int64_t;
	using Unsigned = std::uint64_t;

	Type::Model model;

	union
	{
		Signed signed_;
		Unsigned unsigned_;
		Float float_;
	};

	Value () = default;
	Value (Signed);
	Value (Unsigned);
	Value (Float);
};

struct ECS::Debugging::Field
{
	using Mask = std::uint64_t;

	Name name;
	Location location;
	Type type;
	Offset offset;
	Mask mask;

	Field () = default;
	Field (const Name&, Offset, Mask);
};

struct ECS::Debugging::Enumerator
{
	Name name;
	Location location;
	Value value;

	Enumerator () = default;
	Enumerator (const Name&, const Value&);
};

struct ECS::Debugging::Symbol
{
	enum Model {Constant, Register, Variable, Unreachable = 0};

	using Displacement = std::int64_t;

	Model model;
	Name name;
	Location location;
	Type type;

	Lifetime lifetime;
	Value value;
	Debugging::Register register_;
	Displacement displacement;

	Symbol () = default;
	Symbol (const Name&, const Lifetime&, const Value&);
	Symbol (const Name&, const Lifetime&, const Debugging::Register&);
	Symbol (const Name&, const Lifetime&, const Debugging::Register&, Displacement);
};

struct ECS::Debugging::Breakpoint
{
	Offset offset;
	Location location;

	Breakpoint () = default;
	explicit Breakpoint (Offset);
};

struct ECS::Debugging::Entry
{
	enum Model {Code, Data, Type, Unreachable = 0};

	Model model;
	Name name;
	Location location;
	Debugging::Type type;
	Size size;
	Symbols symbols;
	Breakpoints breakpoints;

	Entry () = default;
	Entry (Model, const Name&);
};

struct ECS::Debugging::Target
{
	Name name;
	Endianness endianness;
	Size pointer;
};

struct ECS::Debugging::Information
{
	Target target;
	Sources sources;
	Entries entries;
};

#endif // ECS_DEBUGGING_HEADER_INCLUDED

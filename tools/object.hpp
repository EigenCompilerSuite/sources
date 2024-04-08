// Object file representation
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

#ifndef ECS_OBJECT_HEADER_INCLUDED
#define ECS_OBJECT_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>
#include <list>
#include <string>
#include <vector>

namespace ECS
{
	enum class Endianness;

	template <typename> class Span;

	using Byte = std::uint8_t;
}

namespace ECS::Object
{
	class Pattern;

	struct Alias;
	struct Binary;
	struct Link;
	struct Mask;
	struct Patch;
	struct Section;

	using Aliases = std::vector<Alias>;
	using Binaries = std::list<Binary>;
	using Bytes = std::vector<Byte>;
	using Links = std::vector<Link>;
	using Offset = std::size_t;
	using Patches = std::vector<Patch>;
	using Size = std::size_t;

	bool operator == (const Alias&, const Alias&);
	bool operator == (const Binary&, const Binary&);
	bool operator == (const Link&, const Link&);
	bool operator == (const Mask&, const Mask&);
	bool operator == (const Patch&, const Patch&);
	bool operator == (const Pattern&, const Pattern&);

	std::istream& operator >> (std::istream&, Alias&);
	std::istream& operator >> (std::istream&, Binaries&);
	std::istream& operator >> (std::istream&, Binary&);
	std::istream& operator >> (std::istream&, Link&);
	std::istream& operator >> (std::istream&, Mask&);
	std::istream& operator >> (std::istream&, Patch&);
	std::istream& operator >> (std::istream&, Pattern&);
	std::ostream& operator << (std::ostream&, const Alias&);
	std::ostream& operator << (std::ostream&, const Binaries&);
	std::ostream& operator << (std::ostream&, const Binary&);
	std::ostream& operator << (std::ostream&, const Link&);
	std::ostream& operator << (std::ostream&, const Mask&);
	std::ostream& operator << (std::ostream&, const Patch&);
	std::ostream& operator << (std::ostream&, const Pattern&);
}

struct ECS::Object::Mask
{
	using Bitmask = Byte;
	using Offset = Byte;

	Offset offset;
	Bitmask bitmask;
};

class ECS::Object::Pattern
{
public:
	using Value = std::uint64_t;

	Pattern () = default;
	Pattern (std::initializer_list<Mask>);
	Pattern (Size, Endianness);

	Pattern& operator += (Mask);

	void Patch (Value, Span<Byte>) const;

private:
	Size size = 0;
	Mask masks[8];

	friend bool IsEmpty (const Pattern&);
	friend Size GetSize (const Pattern&);
	friend bool operator == (const Pattern&, const Pattern&);
	friend std::ostream& operator << (std::ostream&, const Pattern&);
};

struct ECS::Object::Section
{
	enum Type {Code, InitCode, InitData, Data, Const, Header, Trailer, TypeSection};

	using Alignment = std::size_t;
	using Duplicable = bool;
	using Name = std::string;
	using Origin = std::size_t;
	using Replaceable = bool;
	using Required = bool;

	Type type = Code;
	Name name, group;
	bool required = false, duplicable = false, replaceable = false, fixed = false;
	union {Alignment alignment = 0; Origin origin;};

	Section () = default;
	Section (Type, const Name&, Alignment = 0, Required = false, Duplicable = false, Replaceable = false);

	static const char*const EntryPoint;
};

struct ECS::Object::Alias
{
	Section::Name name;
	Offset offset = 0;

	Alias () = default;
	Alias (const Section::Name&, Offset);
};

struct ECS::Object::Patch
{
	enum Mode {Absolute, Relative, Size, Extent, Position, Index, Count};

	using Displacement = std::ptrdiff_t;
	using Scale = std::size_t;

	Offset offset = 0;
	Mode mode = Absolute;
	Displacement displacement = 0;
	Scale scale = 0;
	Pattern pattern;

	Patch () = default;
	Patch (Offset, Mode, Displacement, Scale);
};

struct ECS::Object::Link
{
	Section::Name name;
	Patches patches;

	Link () = default;
	explicit Link (const Section::Name&);
};

struct ECS::Object::Binary : Section
{
	Aliases aliases;
	Links links;
	Bytes bytes;

	Binary () = default;
	using Section::Section;
	explicit Binary (const Section&);

	Link& AddLink (const Name&);
	bool AddRequirement (const Name&);
	void AddLink (const Name&, const Patch&);

	static Span<const Byte> FindSegment (Span<const Byte>, Size);
};

namespace ECS::Object
{
	bool HasConditionals (const Section::Name&);
	bool IsAssembly (const Section&);
	bool IsCode (Section::Type);
	bool IsData (Section::Type);
	bool IsEmpty (const Pattern&);
	bool IsEntryPoint (const Section&);
	bool IsType (Section::Type);
	bool IsValid (const Section::Name&);

	auto GetSize (const Pattern&) -> Size;
	auto StripConditionals (const Section::Name&, bool = true) -> Section::Name;

	std::istream& operator >> (std::istream&, Patch::Mode&);
	std::istream& operator >> (std::istream&, Section::Type&);
	std::ostream& operator << (std::ostream&, Patch::Mode);
	std::ostream& operator << (std::ostream&, Section::Type);
}

inline ECS::Object::Pattern::Pattern (const std::initializer_list<Mask> masks)
{
	for (auto& mask: masks) operator += (mask);
}

inline bool ECS::Object::IsCode (const Section::Type type)
{
	return type < Section::Data;
}

inline bool ECS::Object::IsData (const Section::Type type)
{
	return type >= Section::Data && type < Section::TypeSection;
}

inline bool ECS::Object::IsType (const Section::Type type)
{
	return type == Section::TypeSection;
}

inline bool ECS::Object::IsEmpty (const Pattern& pattern)
{
	return pattern.size == 0;
}

inline bool ECS::Object::IsAssembly (const Section& section)
{
	return section.type == Section::Code && section.name.empty ();
}

#endif // ECS_OBJECT_HEADER_INCLUDED

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

#include "object.hpp"
#include "utilities.hpp"

#include <cassert>
#include <cctype>

using namespace ECS;
using namespace Object;

const char*const Section::EntryPoint = "main";

static const char*const options[] {"required", "duplicable", "replaceable"};
static const char*const modes[] {"abs", "rel", "siz", "ext", "pos", "idx", "cnt"};
static const char*const placements[] {"aligned", "fixed"};
static const char*const types[] {"code", "initcode", "initdata", "data", "const", "header", "trailer", "type"};

Section::Section (const Type t, const Name& n, const Alignment a, const Required req, const Duplicable d, const Replaceable rep) :
	type {t}, name {n}, required {req}, duplicable {d}, replaceable {rep}, alignment {a}
{
	assert (IsValid (name)); assert (!alignment || IsData (type));
}

Alias::Alias (const Section::Name& n, const Offset o) :
	name {n}, offset {o}
{
}

Patch::Patch (const Offset o, const Mode m, const Displacement d, const Scale s) :
	offset {o}, mode {m}, displacement {d}, scale {s}
{
}

Link::Link (const Section::Name& n) :
	name {n}
{
}

Binary::Binary (const Section& s) :
	Section {s}
{
	assert (!IsType (type));
}

bool Binary::AddRequirement (const Name& name)
{
	const auto size = links.size (); AddLink (name); return size != links.size ();
}

Link& Binary::AddLink (const Name& name)
{
	for (auto& link: links) if (link.name == name) return link;
	return links.emplace_back (name);
}

void Binary::AddLink (const Name& name, const Patch& patch)
{
	assert (!IsEmpty (patch.pattern)); AddLink (name).patches.push_back (patch);
}

Span<const Byte> Binary::FindSegment (const Span<const Byte> bytes, const Size size)
{
	static const auto zero = [] (const Byte byte) {return byte == 0;};
	auto first = std::find_if_not (bytes.begin (), bytes.end (), zero), end = first + std::min<Size> (bytes.end () - first, size), last = std::find_if (first, end, zero);
	for (auto next = std::find_if_not (last, end, zero); next != end && next - last < 4; next = std::find_if_not (last, end, zero)) last = std::find_if (next, end, zero);
	return {first, last};
}

Pattern::Pattern (const Size size, const Endianness endianness)
{
	for (Size index = 0; index != size; ++index) operator += ({Mask::Offset (endianness == Endianness::Big ? size - index - 1 : index), 0xff});
}

Pattern& Pattern::operator += (const Mask mask)
{
	assert (size != 8); assert (mask.offset < 10);
	if (mask.bitmask) masks[size] = mask, ++size; return *this;
}

void Pattern::Patch (Value value, const Span<Byte> bytes) const
{
	for (auto mask = masks; mask != masks + size; ++mask)
		if (auto bitmask = mask->bitmask, &byte = bytes[mask->offset]; byte &= ~bitmask, bitmask == 0xff) byte |= Byte (value), value >>= 8;
		else for (Bits index = 0; bitmask; ++index, bitmask >>= 1) if (bitmask & 1) byte |= Byte (value & 1) << index, value >>= 1;
}

bool Object::IsEntryPoint (const Section& section)
{
	return section.type == Section::Code && section.group.empty () && section.name == Section::EntryPoint;
}

bool Object::IsExecutable (const Section& section)
{
	return IsCode (section.type) && (section.type != Section::Code || section.fixed);
}

bool Object::IsValid (const Section::Name& name)
{
	return !name.empty () && !HasConditionals (name);
}

bool Object::HasConditionals (const Section::Name& name)
{
	return name.find ('?') != name.npos;
}

Section::Name Object::StripConditionals (const Section::Name& name, const bool required)
{
	const auto mark = name.rfind ('?'); if (mark == name.npos) return name;
	const auto colon = name.find (':', mark); if (colon == name.npos) return name.substr (required ? mark + 1 : name.size ());
	return required ? name.substr (mark + 1, colon - mark - 1) : name.substr (colon + 1);
}

Size Object::GetSize (const Pattern& pattern)
{
	Size size = 0; for (Size index = 0; index != pattern.size; ++index) size = std::max<Size> (pattern.masks[index].offset + 1, size); return size;
}

bool Object::operator == (const Mask& a, const Mask& b)
{
	return a.offset == b.offset && a.bitmask == b.bitmask;
}

bool Object::operator == (const Alias& a, const Alias& b)
{
	return a.name == b.name && a.offset == b.offset;
}

bool Object::operator == (const Link& a, const Link& b)
{
	return a.name == b.name && a.patches == b.patches;
}

bool Object::operator == (const Patch& a, const Patch& b)
{
	return a.offset == b.offset && a.mode == b.mode && a.displacement == b.displacement && a.scale == b.scale && a.pattern == b.pattern;
}

bool Object::operator == (const Binary& a, const Binary& b)
{
	return a.type == b.type && a.name == b.name && a.group == b.group && a.required == b.required && a.duplicable == b.duplicable && a.replaceable == b.replaceable && a.fixed == b.fixed && a.origin == b.origin && a.aliases == b.aliases && a.links == b.links && a.bytes == b.bytes;
}

bool Object::operator == (const Pattern& a, const Pattern& b)
{
	return std::equal (a.masks, a.masks + a.size, b.masks, b.masks + b.size);
}

std::istream& Object::operator >> (std::istream& stream, Binary& binary)
{
	binary.bytes.clear (); binary.aliases.clear (); binary.links.clear (); Size size; if (stream >> binary.type >> size) binary.bytes.resize (size);
	ReadString (ReadOptions (stream, {&binary.required, &binary.duplicable, &binary.replaceable}, options, IsAlpha), binary.name, '"');
	while (stream >> std::ws && std::isdigit (stream.peek ())) stream >> binary.aliases.emplace_back ();
	for (auto& alias: binary.aliases) if (alias.offset > binary.bytes.size ()) return stream.setstate (stream.failbit), stream;
	if (stream >> std::ws && stream.peek () == '"') ReadString (stream, binary.group, '"'); else binary.group.clear ();
	ReadBool (stream, binary.fixed, placements, IsAlpha) >> (binary.fixed ? binary.origin : binary.alignment);
	if (IsType (binary.type) || !binary.fixed && !IsPowerOfTwo (binary.alignment)) return stream.setstate (stream.failbit), stream;
	for (Offset offset; stream.good () && stream >> std::ws && stream.good () && std::isdigit (stream.peek ()) && stream >> offset;)
		do if (offset < binary.bytes.size () && ReadByte (stream, binary.bytes[offset])) ++offset; else stream.setstate (stream.failbit); while (stream.good () && std::isxdigit (stream.peek ()));
	while (stream.good () && stream >> std::ws && stream.good () && stream.peek () == '"') stream >> binary.links.emplace_back ();
	for (auto& link: binary.links) for (auto& patch: link.patches) if (patch.offset + GetSize (patch.pattern) > binary.bytes.size ()) return stream.setstate (stream.failbit), stream;
	return stream;
}

std::ostream& Object::operator << (std::ostream& stream, const Binary& binary)
{
	const Span<const Byte> bytes {binary.bytes};
	WriteString (WriteOptions (stream << binary.type << ' ' << bytes.size (), {binary.required, binary.duplicable, binary.replaceable}, options) << ' ', binary.name, '"');
	for (auto& alias: binary.aliases) stream << ' ' << alias; if (!binary.group.empty ()) WriteString (stream << ' ', binary.group, '"');
	WriteBool (stream << ' ', binary.fixed, placements) << ' ' << (binary.fixed ? binary.origin : binary.alignment) << '\n';
	for (auto segment = Binary::FindSegment (bytes, bytes.size ()); segment.size (); segment = Binary::FindSegment ({segment.end (), bytes.end ()}, bytes.size ()))
		WriteBytes (stream << '\t' << segment.begin () - bytes.begin () << ' ', segment) << '\n';
	for (auto& link: binary.links) stream << '\t' << link << '\n';
	return stream;
}

std::istream& Object::operator >> (std::istream& stream, Binaries& binaries)
{
	while (stream.good () && stream >> std::ws && stream.good ()) stream >> binaries.emplace_back ();
	return stream;
}

std::ostream& Object::operator << (std::ostream& stream, const Binaries& binaries)
{
	for (auto& binary: binaries) stream << binary;
	return stream;
}

std::istream& Object::operator >> (std::istream& stream, Alias& alias)
{
	return ReadString (stream >> alias.offset, alias.name, '"');
}

std::ostream& Object::operator << (std::ostream& stream, const Alias& alias)
{
	return WriteString (stream << alias.offset << ' ', alias.name, '"');
}

std::istream& Object::operator >> (std::istream& stream, Link& link)
{
	ReadString (stream, link.name, '"'); link.patches.clear ();
	while (stream.good () && stream >> std::ws && stream.good () && std::isdigit (stream.peek ())) stream >> link.patches.emplace_back ();
	return stream;
}

std::ostream& Object::operator << (std::ostream& stream, const Link& link)
{
	WriteString (stream, link.name, '"');
	for (auto& patch: link.patches) stream << ' ' << patch;
	return stream;
}

std::istream& Object::operator >> (std::istream& stream, Patch& patch)
{
	return stream >> patch.offset >> patch.mode >> patch.displacement >> patch.scale >> patch.pattern;
}

std::ostream& Object::operator << (std::ostream& stream, const Patch& patch)
{
	return stream << patch.offset << ' ' << patch.mode << ' ' << patch.displacement << ' ' << patch.scale << ' ' << patch.pattern;
}

std::istream& Object::operator >> (std::istream& stream, Pattern& pattern)
{
	const char next = stream >> std::ws ? stream.peek () : 0; Size size = 0;
	if (next == '+' && stream.ignore () >> size && size >= 1 && size <= 8) pattern = {size, Endianness::Little};
	else if (next == '-' && stream.ignore () >> size && size >= 1 && size <= 8) pattern = {size, Endianness::Big};
	else if (std::isdigit (next)) for (Mask mask; size != 8 && std::isdigit (stream.peek ()) && stream >> mask; ++size) pattern += mask;
	else stream.setstate (stream.failbit);
	return stream;
}

std::ostream& Object::operator << (std::ostream& stream, const Pattern& pattern)
{
	Size index;
	for (index = 0; index != pattern.size; ++index) if (pattern.masks[index].offset != index || pattern.masks[index].bitmask != 0xff) break;
	if (index == pattern.size) return stream << '+' << pattern.size;
	for (index = 0; index != pattern.size; ++index) if (pattern.masks[index].offset != pattern.size - index - 1 || pattern.masks[index].bitmask != 0xff) break;
	if (index == pattern.size) return stream << '-' << pattern.size;
	for (index = 0; index != pattern.size; ++index) stream << pattern.masks[index]; return stream;
}

std::istream& Object::operator >> (std::istream& stream, Mask& mask)
{
	char offset; if (ReadByte (stream >> offset, mask.bitmask) && std::isdigit (offset)) mask.offset = offset - '0'; else stream.setstate (stream.failbit); return stream;
}

std::ostream& Object::operator << (std::ostream& stream, const Mask& mask)
{
	return WriteByte (stream.put (mask.offset + '0'), mask.bitmask);
}

std::istream& Object::operator >> (std::istream& stream, Patch::Mode& mode)
{
	return ReadEnum (stream, mode, modes, IsAlpha);
}

std::ostream& Object::operator << (std::ostream& stream, const Patch::Mode mode)
{
	return WriteEnum (stream, mode, modes);
}

std::istream& Object::operator >> (std::istream& stream, Section::Type& type)
{
	return ReadEnum (stream, type, types, IsAlpha);
}

std::ostream& Object::operator << (std::ostream& stream, const Section::Type type)
{
	return WriteEnum (stream, type, types);
}

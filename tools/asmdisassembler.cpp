// Generic disassembler
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

#include "asmdisassembler.hpp"
#include "asmlexer.hpp"
#include "charset.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace Object;
using namespace Assembly;

struct Disassembler::Alias
{
	const Byte* byte;
	const Binary::Name* name;

	Alias (const Binary&, const Object::Alias&);
	bool operator < (const Alias& other) const {return byte < other.byte;}
};

struct Disassembler::Reference
{
	const Byte* byte;
	const Link* link;
	const Patch* patch;

	Reference (const Binary&, const Link&, const Patch&);
	bool operator < (const Reference& other) const {return byte < other.byte;}
};

using Context = class Disassembler::Context
{
public:
	Context (const Disassembler&, std::ostream&);

	void Disassemble (const Binaries&);
	void Disassemble (Span<const Byte>, Binary::Type, Size);

private:
	const Disassembler& disassembler;
	std::ostream& stream;

	std::vector<Alias> aliases;
	std::vector<Reference> references;
	std::vector<Alias>::const_iterator alias;
	std::vector<Reference>::const_iterator reference;

	void Disassemble (const Binary&);
	void Disassemble (Span<const Byte>);

	Size ListData (Span<const Byte>) const;
	Size ListCode (Span<const Byte>, State&) const;
};

Disassembler::Disassembler (Charset& c, const Alignment a, const Size m) :
	charset {c}, alignment {a}, maximum {m}
{
	assert (IsPowerOfTwo (alignment)); assert (maximum);
}

void Disassembler::Disassemble (const Binaries& binaries, std::ostream& stream) const
{
	Context {*this, stream}.Disassemble (binaries);
}

void Disassembler::Disassemble (const Span<const Byte> bytes, std::ostream& stream) const
{
	Context {*this, stream}.Disassemble (bytes, Binary::Code, 0);
}

std::ostream& Disassembler::Pad (std::ostream& stream, Size size) const
{
	do stream << "  "; while (++size <= maximum); return stream;
}

std::ostream& Disassembler::Write (std::ostream& stream, const Span<const Byte> bytes) const
{
	return Pad (WriteBytes (stream, bytes), bytes.size ());
}

void Disassembler::Write (std::ostream& stream, const Alias& alias, const Size width) const
{
	stream.width (width); stream.fill (' '); WriteIdentifier (Pad (stream << ' ', 0) << "  " << Lexer::Alias << '\t', *alias.name) << '\n';
}

void Disassembler::Write (std::ostream& stream, const Reference& reference) const
{
	WriteAddress (stream, GetFunction (reference.patch->mode), reference.link->name, reference.patch->displacement, reference.patch->scale);
}

Context::Context (const Disassembler& d, std::ostream& s) :
	disassembler {d}, stream {s}, alias {aliases.end ()}, reference {references.end ()}
{
}

void Context::Disassemble (const Binaries& binaries)
{
	for (auto& binary: binaries) Disassemble (binary);
}

void Context::Disassemble (const Binary& binary)
{
	for (auto& alias: binary.aliases) aliases.emplace_back (binary, alias);
	std::sort (aliases.begin (), aliases.end ()); alias = aliases.begin ();
	for (auto& link: binary.links) for (auto& patch: link.patches) references.emplace_back (binary, link, patch);
	std::sort (references.begin (), references.end ()); reference = references.begin ();
	WriteIdentifier (stream << '.' << binary.type << ' ', binary.name) << '\n';
	Disassemble (binary.bytes, binary.type, 2);
	aliases.clear (); references.clear ();
}

void Context::Disassemble (const Span<const Byte> bytes, const Binary::Type type, const Size indent)
{
	const auto width = std::to_string (bytes.size ()).size () + indent; State state = 0;
	for (auto byte = bytes.begin (); byte != bytes.end (); stream << '\n')
	{
		while (alias != aliases.end () && alias->byte <= byte) disassembler.Write (stream, *alias, width), ++alias;
		stream.width (width); stream.fill (' '); stream << byte - bytes.begin () << "  ";
		byte += IsCode (type) ? ListCode ({byte, bytes.end ()}, state) : ListData ({byte, bytes.end ()});
		for (auto first = true; reference != references.end () && reference->byte < byte; ++reference, first = false)
			disassembler.Write (first ? stream << "\t; " : stream << ", ", *reference);
	}
	while (alias != aliases.end ()) disassembler.Write (stream, *alias, width), ++alias;
	stream.width (width); stream.fill (' '); stream << bytes.size () << '\n';
}

Disassembler::Size Context::ListCode (const Span<const Byte> bytes, State& state) const
{
	if (const auto size = disassembler.ListInstruction (bytes, stream, state)) return size;
	return state = 0, ListData ({bytes.begin (), std::min (disassembler.alignment, bytes.size ())});
}

Disassembler::Size Context::ListData (const Span<const Byte> bytes) const
{
	auto begin = bytes.begin (), end = bytes.end (); if (alias != aliases.end ()) end = std::min (alias->byte, end);
	if (reference != references.end ()) end = std::min (reference->byte == begin ? begin + GetSize (reference->patch->pattern) : reference->byte, end);

	const auto segment = Binary::FindSegment ({begin, end}, 16); const Size padding = segment.begin () - begin;
	if (padding > disassembler.alignment) return disassembler.Pad (stream << "00..", 2) << Lexer::Reserve << '\t' << padding, padding;

	end = segment.end (); disassembler.Write (stream, {begin, end}) << Lexer::Byte << '\t';
	for (auto byte = begin; byte != end;)
	{
		if (byte != begin) stream << ", ";
		if (std::isprint (disassembler.charset.Decode (*byte)))
		{
			std::string string;
			do string.push_back (disassembler.charset.Decode (*byte)), ++byte;
			while (byte != end && std::isprint (disassembler.charset.Decode (*byte)));
			if (string.size () >= 2) {WriteString (stream, string, '"'); continue;} else byte -= string.size ();
		}
		stream << unsigned (*byte), ++byte;
	}

	return end - begin;
}

Disassembler::Alias::Alias (const Binary& binary, const Object::Alias& a) :
	byte {binary.bytes.data () + a.offset}, name {&a.name}
{
	assert (a.offset <= binary.bytes.size ());
}

Disassembler::Reference::Reference (const Binary& binary, const Link& l, const Patch& p) :
	byte {binary.bytes.data () + p.offset}, link {&l}, patch {&p}
{
	assert (patch->offset + GetSize (patch->pattern) <= binary.bytes.size ());
}

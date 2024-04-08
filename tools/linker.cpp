// Generic linker driver
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

#include "driver.hpp"
#include "objlinker.hpp"
#include "stdcharset.hpp"

using namespace ECS;

static ASCIICharset charset;
static Object::Binaries binaries;
static StreamDiagnostics diagnostics {std::cerr};
static Object::Linker linker {diagnostics};

static void Read (std::istream& stream, const Source& source, const Position&)
{
	stream >> binaries;
	if (!stream) throw InvalidInput {source, "invalid object file"};
}

#if defined LIBRARYLINKFILEFORMAT

	#define NAMESUFFIX "lib"

	static void Link (const Source& target)
	{
		linker.Combine (binaries);
		File library {target, ".lib"};
		library << binaries;
	}

#elif defined BINARYLINKFILEFORMAT

	#define NAMESUFFIX "bin"

	static void Link (const Source& target)
	{
		Object::MappedByteArrangement arrangement;
		linker.Link (binaries, arrangement);
		File file {target, GetContents ("_extension", binaries, charset, ".bin"), file.binary};
		Object::WriteBinary (file, arrangement.bytes);
		File map {target, ".map"};
		map << arrangement.map;
	}

#elif defined MEMORYLINKFILEFORMAT

	#define NAMESUFFIX "mem"

	static void Link (const Source& target)
	{
		Object::MappedByteArrangement ram, rom;
		linker.Link (binaries, rom, ram, rom);
		File ramfile {target, ".ram", ramfile.binary};
		Object::WriteBinary (ramfile, ram.bytes);
		File romfile {target, ".rom", romfile.binary};
		Object::WriteBinary (romfile, rom.bytes);
		File map {target, ".map"};
		map << ram.map << rom.map;
	}

#elif defined INTELHEXLINKFILEFORMAT

	#include "objhexfile.hpp"

	#define NAMESUFFIX "hex"

	static void Link (const Source& target)
	{
		Object::MappedByteArrangement code, data;
		linker.Link (binaries, code, data);
		File file {target, ".hex"};
		Object::HexFile hexfile {code.bytes, code.origin};
		file << hexfile;
		File map {target, ".map"};
		map << code.map << data.map;
	}

#elif defined GEMDOSLINKFILEFORMAT

	#include "utilities.hpp"

	#define NAMESUFFIX "prg"

	static void Link (const Source& target)
	{
		Object::MappedByteArrangement arrangement;
		linker.Link (binaries, arrangement);

		const Object::Pattern word {2, Endianness::Big}, long_ {4, Endianness::Big};
		Object::Bytes header (0x1c); word.Patch (0x601a, {&header[0x0], 2}); long_.Patch (arrangement.bytes.size () + arrangement.origin, {&header[0x2], 4}); long_.Patch (1, {&header[0x16], 4});
		std::set<Object::Offset> offsets; for (auto& entry: arrangement.map) if (entry.binary) for (auto& link: entry.binary->links) for (auto& patch: link.patches)
			if (patch.mode == Object::Patch::Absolute) if (patch.pattern == long_) offsets.insert (entry.offset + patch.offset); else throw ProcessFailed {"invalid link patch"};
		Object::Bytes fixups (4); Object::Offset current = 0; if (!offsets.empty ()) current = *offsets.begin (), long_.Patch (current, fixups);
		for (auto offset: offsets) {while (offset - current > 254) fixups.push_back (1), current += 254; if (offset != current) fixups.push_back (offset - current), current = offset;}
		if (!offsets.empty ()) fixups.push_back (0);

		File file {target, GetContents ("_extension", binaries, charset, ".prg"), file.binary};
		Object::WriteBinary (file, header).seekp (arrangement.origin, file.cur);
		Object::WriteBinary (Object::WriteBinary (file, arrangement.bytes), fixups);

		File map {target, ".map"};
		map << arrangement.map;
	}

#else

	#error unknown link file format

#endif

int main (int argc, char* argv[])
{
	return Drive (Read, "link" NAMESUFFIX, argc, argv, diagnostics, Link);
}

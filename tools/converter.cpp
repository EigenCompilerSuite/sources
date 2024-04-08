// Generic debugging information converter driver
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
#include "driver.hpp"
#include "object.hpp"
#include "stdcharset.hpp"

using namespace ECS;

static ASCIICharset charset;
static StreamDiagnostics diagnostics {std::cerr};

#if defined DWARFDEBUGFILEFORMAT

	#define NAMESUFFIX "dwarf"

	#include "dbgdwarfconverter.hpp"
	static Debugging::DWARFConverter converter {diagnostics, charset};

#else

	#error unknown debug file format

#endif

static void Convert (std::istream& stream, const Source& source, const Position&)
{
	Debugging::Information information;
	stream >> information;
	if (!stream) throw InvalidInput {source, "invalid debugging information"};
	Object::Binaries binaries;
	converter.Convert (information, source, binaries);
	File object {source, ".dbf"};
	object << binaries;
}

int main (int argc, char* argv[])
{
	return Drive (Convert, "dbg" NAMESUFFIX, argc, argv, diagnostics);
}

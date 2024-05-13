// Generic disassembler driver
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
#include "object.hpp"
#include "stdcharset.hpp"

using namespace ECS;

static ASCIICharset charset;
static StreamDiagnostics diagnostics {std::cerr};

#if defined AMD16ARCHITECTURE

	#include "amd64.hpp"
	#include "amd64disassembler.hpp"

	#define NAMEPREFIX "amd16"
	static AMD64::Disassembler disassembler {charset, AMD64::RealMode};

#elif defined AMD32ARCHITECTURE

	#include "amd64.hpp"
	#include "amd64disassembler.hpp"

	#define NAMEPREFIX "amd32"
	static AMD64::Disassembler disassembler {charset, AMD64::ProtectedMode};

#elif defined AMD64ARCHITECTURE

	#include "amd64.hpp"
	#include "amd64disassembler.hpp"

	#define NAMEPREFIX "amd64"
	static AMD64::Disassembler disassembler {charset, AMD64::LongMode};

#elif defined ARMA32ARCHITECTURE

	#include "arma32disassembler.hpp"

	#define NAMEPREFIX "arma32"
	static ARM::A32::Disassembler disassembler {charset};

#elif defined ARMA64ARCHITECTURE

	#include "arma64disassembler.hpp"

	#define NAMEPREFIX "arma64"
	static ARM::A64::Disassembler disassembler {charset};

#elif defined ARMT32ARCHITECTURE

	#include "armt32disassembler.hpp"

	#define NAMEPREFIX "armt32"
	static ARM::T32::Disassembler disassembler {charset};

#elif defined AVRARCHITECTURE

	#include "avrdisassembler.hpp"

	#define NAMEPREFIX "avr"
	static AVR::Disassembler disassembler {charset};

#elif defined AVR32ARCHITECTURE

	#include "avr32disassembler.hpp"

	#define NAMEPREFIX "avr32"
	static AVR32::Disassembler disassembler {charset};

#elif defined M68KARCHITECTURE

	#include "m68kdisassembler.hpp"

	#define NAMEPREFIX "m68k"
	static M68K::Disassembler disassembler {charset};

#elif defined MICROBLAZEARCHITECTURE

	#include "mibldisassembler.hpp"

	#define NAMEPREFIX "mibl"
	static MicroBlaze::Disassembler disassembler {charset};

#elif defined MIPS32ARCHITECTURE

	#include "mips.hpp"
	#include "mipsdisassembler.hpp"
	#include "utilities.hpp"

	#define NAMEPREFIX "mips32"
	static MIPS::Disassembler disassembler {charset, MIPS::MIPS32, Endianness::Little};

#elif defined MIPS64ARCHITECTURE

	#include "mips.hpp"
	#include "mipsdisassembler.hpp"
	#include "utilities.hpp"

	#define NAMEPREFIX "mips64"
	static MIPS::Disassembler disassembler {charset, MIPS::MIPS64, Endianness::Little};

#elif defined MMIXARCHITECTURE

	#include "mmixdisassembler.hpp"

	#define NAMEPREFIX "mmix"
	static MMIX::Disassembler disassembler {charset};

#elif defined OR1KARCHITECTURE

	#include "or1kdisassembler.hpp"

	#define NAMEPREFIX "or1k"
	static OR1K::Disassembler disassembler {charset};

#elif defined POWERPC32ARCHITECTURE

	#include "ppc.hpp"
	#include "ppcdisassembler.hpp"

	#define NAMEPREFIX "ppc32"
	static PowerPC::Disassembler disassembler {charset, PowerPC::PPC32};

#elif defined POWERPC64ARCHITECTURE

	#include "ppc.hpp"
	#include "ppcdisassembler.hpp"

	#define NAMEPREFIX "ppc64"
	static PowerPC::Disassembler disassembler {charset, PowerPC::PPC64};

#elif defined RISCARCHITECTURE

	#include "riscdisassembler.hpp"

	#define NAMEPREFIX "risc"
	static RISC::Disassembler disassembler {charset};

#elif defined WEBASSEMBLYARCHITECTURE

	#include "wasmdisassembler.hpp"

	#define NAMEPREFIX "wasm"
	static WebAssembly::Disassembler disassembler {charset};

#elif defined XTENSAARCHITECTURE

	#include "xtensadisassembler.hpp"

	#define NAMEPREFIX "xtensa"
	static Xtensa::Disassembler disassembler {charset};

#else

	#error unknown source architecture

#endif

static void Disassemble (std::istream& stream, const Source& source, const Position&)
{
	Object::Binaries binaries;
	stream >> binaries;
	if (!stream) throw InvalidInput {source, "invalid object file"};
	disassembler.Disassemble (binaries, std::cout);
}

int main (int argc, char* argv[])
{
	return Drive (Disassemble, NAMEPREFIX "dism", argc, argv, diagnostics);
}

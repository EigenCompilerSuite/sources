// Generic assembler driver
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

#include "asmparser.hpp"
#include "assembly.hpp"
#include "driver.hpp"
#include "stdcharset.hpp"
#include "stringpool.hpp"

using namespace ECS;

static ASCIICharset charset;
static StringPool stringPool;
static StreamDiagnostics diagnostics {std::cerr};
static Assembly::Parser parser {diagnostics, stringPool, false};

#if defined AMD16ARCHITECTURE

	#include "amd64.hpp"
	#include "amd64assembler.hpp"

	#define NAMEPREFIX "amd16"
	static AMD64::Assembler assembler {diagnostics, charset, AMD64::RealMode};

#elif defined AMD32ARCHITECTURE

	#include "amd64.hpp"
	#include "amd64assembler.hpp"

	#define NAMEPREFIX "amd32"
	static AMD64::Assembler assembler {diagnostics, charset, AMD64::ProtectedMode};

#elif defined AMD64ARCHITECTURE

	#include "amd64.hpp"
	#include "amd64assembler.hpp"

	#define NAMEPREFIX "amd64"
	static AMD64::Assembler assembler {diagnostics, charset, AMD64::LongMode};

#elif defined ARMA32ARCHITECTURE

	#include "arma32assembler.hpp"

	#define NAMEPREFIX "arma32"
	static ARM::A32::Assembler assembler {diagnostics, charset};

#elif defined ARMA64ARCHITECTURE

	#include "arma64assembler.hpp"

	#define NAMEPREFIX "arma64"
	static ARM::A64::Assembler assembler {diagnostics, charset};

#elif defined ARMT32ARCHITECTURE

	#include "armt32assembler.hpp"

	#define NAMEPREFIX "armt32"
	static ARM::T32::Assembler assembler {diagnostics, charset};

#elif defined AVRARCHITECTURE

	#include "avrassembler.hpp"

	#define NAMEPREFIX "avr"
	static AVR::Assembler assembler {diagnostics, charset};

#elif defined AVR32ARCHITECTURE

	#include "avr32assembler.hpp"

	#define NAMEPREFIX "avr32"
	static AVR32::Assembler assembler {diagnostics, charset};

#elif defined M68KARCHITECTURE

	#include "m68kassembler.hpp"

	#define NAMEPREFIX "m68k"
	static M68K::Assembler assembler {diagnostics, charset};

#elif defined MICROBLAZEARCHITECTURE

	#include "miblassembler.hpp"

	#define NAMEPREFIX "mibl"
	static MicroBlaze::Assembler assembler {diagnostics, charset};

#elif defined MIPS32ARCHITECTURE

	#include "mips.hpp"
	#include "mipsassembler.hpp"
	#include "utilities.hpp"

	#define NAMEPREFIX "mips32"
	static MIPS::Assembler assembler {diagnostics, charset, MIPS::MIPS32, Endianness::Little};

#elif defined MIPS64ARCHITECTURE

	#include "mips.hpp"
	#include "mipsassembler.hpp"
	#include "utilities.hpp"

	#define NAMEPREFIX "mips64"
	static MIPS::Assembler assembler {diagnostics, charset, MIPS::MIPS64, Endianness::Little};

#elif defined MMIXARCHITECTURE

	#include "mmixassembler.hpp"

	#define NAMEPREFIX "mmix"
	static MMIX::Assembler assembler {diagnostics, charset};

#elif defined OR1KARCHITECTURE

	#include "or1kassembler.hpp"

	#define NAMEPREFIX "or1k"
	static OR1K::Assembler assembler {diagnostics, charset};

#elif defined POWERPC32ARCHITECTURE

	#include "ppc.hpp"
	#include "ppcassembler.hpp"

	#define NAMEPREFIX "ppc32"
	static PowerPC::Assembler assembler {diagnostics, charset, PowerPC::PPC32};

#elif defined POWERPC64ARCHITECTURE

	#include "ppc.hpp"
	#include "ppcassembler.hpp"

	#define NAMEPREFIX "ppc64"
	static PowerPC::Assembler assembler {diagnostics, charset, PowerPC::PPC64};

#elif defined RISCARCHITECTURE

	#include "riscassembler.hpp"

	#define NAMEPREFIX "risc"
	static RISC::Assembler assembler {diagnostics, charset};

#elif defined WEBASSEMBLYARCHITECTURE

	#include "wasmassembler.hpp"

	#define NAMEPREFIX "wasm"
	static WebAssembly::Assembler assembler {diagnostics, charset};

#elif defined XTENSAARCHITECTURE

	#include "xtensaassembler.hpp"

	#define NAMEPREFIX "xtensa"
	static Xtensa::Assembler assembler {diagnostics, charset};

#else

	#error unknown target architecture

#endif

static void Assemble (std::istream& stream, const Source& source, const Position& position)
{
	Assembly::Program program {source};
	parser.Parse (stream, GetLine (position), program);
	Object::Binaries binaries;
	assembler.Assemble (program, binaries);
	File object {source, ".obf"};
	object << binaries;
}

int main (int argc, char* argv[])
{
	return Drive (Assemble, NAMEPREFIX "asm", argc, argv, diagnostics);
}

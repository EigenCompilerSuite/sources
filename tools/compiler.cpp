// Generic compiler driver
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
#include "stdcharset.hpp"
#include "stringpool.hpp"

using namespace ECS;

static ASCIICharset charset;
static StringPool stringPool;
static StreamDiagnostics diagnostics {std::cerr};

#if defined CODEBACKEND

	#include "cdgenerator.hpp"

	#define NAMESUFFIX "code"
	static Code::Generator generator;

#elif defined AMD16BACKEND

	#include "amd64.hpp"
	#include "amd64generator.hpp"

	#define NAMESUFFIX "amd16"
	static AMD64::Generator generator {diagnostics, stringPool, charset, AMD64::RealMode, false, true};

#elif defined AMD32BACKEND

	#include "amd64.hpp"
	#include "amd64generator.hpp"

	#define NAMESUFFIX "amd32"
	static AMD64::Generator generator {diagnostics, stringPool, charset, AMD64::ProtectedMode, false, true};

#elif defined AMD64BACKEND

	#include "amd64.hpp"
	#include "amd64generator.hpp"

	#define NAMESUFFIX "amd64"
	static AMD64::Generator generator {diagnostics, stringPool, charset, AMD64::LongMode, true, true};

#elif defined ARMA32BACKEND

	#include "arma32generator.hpp"

	#define NAMESUFFIX "arma32"
	static ARM::A32::Generator generator {diagnostics, stringPool, charset, true};

#elif defined ARMA64BACKEND

	#include "arma64generator.hpp"

	#define NAMESUFFIX "arma64"
	static ARM::A64::Generator generator {diagnostics, stringPool, charset, false};

#elif defined ARMT32BACKEND

	#include "armt32generator.hpp"

	#define NAMESUFFIX "armt32"
	static ARM::T32::Generator generator {diagnostics, stringPool, charset, false};

#elif defined ARMT32FPEBACKEND

	#include "armt32generator.hpp"

	#define NAMESUFFIX "armt32fpe"
	static ARM::T32::Generator generator {diagnostics, stringPool, charset, true};

#elif defined AVRBACKEND

	#include "avrgenerator.hpp"

	#define NAMESUFFIX "avr"
	static AVR::Generator generator {diagnostics, stringPool, charset, 32 * 1024};

#elif defined AVR32BACKEND

	#include "avr32generator.hpp"

	#define NAMESUFFIX "avr32"
	static AVR32::Generator generator {diagnostics, stringPool, charset};

#elif defined M68KBACKEND

	#include "m68kgenerator.hpp"

	#define NAMESUFFIX "m68k"
	static M68K::Generator generator {diagnostics, stringPool, charset};

#elif defined MICROBLAZEBACKEND

	#include "miblgenerator.hpp"

	#define NAMESUFFIX "mibl"
	static MicroBlaze::Generator generator {diagnostics, stringPool, charset};

#elif defined MIPS32BACKEND

	#include "mips.hpp"
	#include "mipsgenerator.hpp"
	#include "utilities.hpp"

	#define NAMESUFFIX "mips32"
	static MIPS::Generator generator {diagnostics, stringPool, charset, MIPS::MIPS32, Endianness::Little, true, false};

#elif defined MIPS64BACKEND

	#include "mips.hpp"
	#include "mipsgenerator.hpp"
	#include "utilities.hpp"

	#define NAMESUFFIX "mips64"
	static MIPS::Generator generator {diagnostics, stringPool, charset, MIPS::MIPS64, Endianness::Little, true, true};

#elif defined MMIXBACKEND

	#include "mmixgenerator.hpp"

	#define NAMESUFFIX "mmix"
	static MMIX::Generator generator {diagnostics, stringPool, charset, false};

#elif defined OR1KBACKEND

	#include "or1kgenerator.hpp"

	#define NAMESUFFIX "or1k"
	static OR1K::Generator generator {diagnostics, stringPool, charset};

#elif defined POWERPC32BACKEND

	#include "ppc.hpp"
	#include "ppcgenerator.hpp"

	#define NAMESUFFIX "ppc32"
	static PowerPC::Generator generator {diagnostics, stringPool, charset, PowerPC::PPC32, false};

#elif defined POWERPC64BACKEND

	#include "ppc.hpp"
	#include "ppcgenerator.hpp"

	#define NAMESUFFIX "ppc64"
	static PowerPC::Generator generator {diagnostics, stringPool, charset, PowerPC::PPC64, false};

#elif defined RISCBACKEND

	#include "riscgenerator.hpp"

	#define NAMESUFFIX "risc"
	static RISC::Generator generator {diagnostics, stringPool, charset};

#elif defined WEBASSEMBLYBACKEND

	#include "wasmgenerator.hpp"

	#define NAMESUFFIX "wasm"
	static WebAssembly::Generator generator {diagnostics, stringPool, charset};

#elif defined XTENSABACKEND

	#include "xtensagenerator.hpp"

	#define NAMESUFFIX "xtensa"
	static Xtensa::Generator generator {diagnostics, stringPool, charset, Xtensa::ESP32};

#else

	#error unknown back-end

#endif

#if defined CODEBACKEND

	static void Generate (const Code::Sections& sections, const Source& source)
	{
		File file {source, ".cod"};
		generator.Generate (sections, source, file);
	}

#else

	#include "debugging.hpp"

	static void Generate (const Code::Sections& sections, const Source& source)
	{
		Object::Binaries binaries;
		Debugging::Information information;

		#if defined ASSEMBLYLISTING
			File listing {source, ".lst"};
		#else
			std::ostream listing {nullptr};
		#endif

		generator.Generate (sections, source, binaries, information, listing);
		File object {source, ".obf"};
		object << binaries;

		#if defined DEBUGGINGINFORMATION
			File debugging {source, ".dbg"};
			debugging << information;
		#endif
	}

#endif

#if defined CODEFRONTEND

	#include "asmparser.hpp"
	#include "assembly.hpp"
	#include "cdchecker.hpp"

	#define NAMEPREFIX "cd"
	static Assembly::Parser parser {diagnostics, stringPool, true};
	static Code::Checker checker {diagnostics, charset, generator.platform};

	static void Emit (std::istream& stream, const Source& source, const Position& position, Code::Sections& sections)
	{
		Assembly::Program program {source};
		parser.Parse (stream, GetLine (position), program);
		checker.Check (program, sections);
	}

#elif defined CPPFRONTEND

	#include "cppemitter.hpp"
	#include "cppparser.hpp"

	#define NAMEPREFIX "cpp"
	static CPP::Platform platform {generator.layout};
	static CPP::Parser parser {diagnostics, stringPool, charset, platform, false};
	static CPP::Emitter emitter {diagnostics, stringPool, charset, generator.platform, platform};

	static void Emit (std::istream& stream, const Source& source, const Position& position, Code::Sections& sections)
	{
		CPP::TranslationUnit translationUnit {source};
		parser.Parse (stream, position, translationUnit);
		emitter.Emit (translationUnit, sections);
	}

#elif defined FALSEFRONTEND

	#include "falemitter.hpp"
	#include "falparser.hpp"
	#include "false.hpp"

	#define NAMEPREFIX "fal"
	static FALSE::Parser parser {diagnostics};
	static FALSE::Emitter emitter {diagnostics, stringPool, charset, generator.platform};

	static void Emit (std::istream& stream, const Source& source, const Position& position, Code::Sections& sections)
	{
		FALSE::Program program {source};
		parser.Parse (stream, position, program);
		emitter.Emit (program, sections);
	}

#elif defined OBERONFRONTEND

	#include "obchecker.hpp"
	#include "obemitter.hpp"
	#include "oberon.hpp"

	#define NAMEPREFIX "ob"
	static Oberon::Parser parser {diagnostics, false};
	static Oberon::Platform platform {generator.layout};
	static Oberon::Checker checker {diagnostics, charset, platform, true};
	static Oberon::Emitter emitter {diagnostics, stringPool, charset, generator.platform, platform};

	static void Emit (std::istream& stream, const Source& source, const Position& position, Code::Sections& sections)
	{
		Oberon::Module module {source};
		parser.Parse (stream, position, module);
		checker.Check (module);
		emitter.Emit (module, sections);
	}

#else

	#error unknown front-end

#endif

#if defined CODEOPTIMIZER

	#include "cdoptimizer.hpp"

	static Code::Optimizer optimizer {generator.platform};

#endif

static void Compile (std::istream& stream, const Source& source, const Position& position)
{
	Code::Sections sections;
	Emit (stream, source, position, sections);

	#if defined CODEOPTIMIZER
		optimizer.Optimize (sections);
	#endif

	Generate (sections, source);
}

int main (int argc, char* argv[])
{
	#if defined CPPFRONTEND
		parser.IncludeEnvironmentDirectories ();
		parser.Predefine (stringPool.Insert ("__" NAMESUFFIX "__"));
	#endif

	return Drive (Compile, NAMEPREFIX NAMESUFFIX, argc, argv, diagnostics);
}

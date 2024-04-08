// Generic pretty printer driver
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
#include "stdlayout.hpp"

using namespace ECS;

static StandardLayout layout;
static StandardCharset charset;
static StreamDiagnostics diagnostics {std::cerr};

#if defined CPPLANGUAGE

	#include "cppparser.hpp"
	#include "cppprinter.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "cpp"
	static CPP::Printer printer;
	static StringPool stringPool;
	static CPP::Platform platform {layout};
	static CPP::Parser parser {diagnostics, stringPool, charset, platform, false};

	static void Print (std::istream& stream, const Source& source, const Position& position)
	{
		CPP::TranslationUnit translationUnit {source};
		parser.Parse (stream, GetPlain (position), translationUnit);
		printer.Print (translationUnit, std::cout);
	}

#elif defined FALSELANGUAGE

	#include "falparser.hpp"
	#include "falprinter.hpp"
	#include "false.hpp"

	#define NAMEPREFIX "fal"
	static FALSE::Printer printer;
	static FALSE::Parser parser {diagnostics};

	static void Print (std::istream& stream, const Source& source, const Position& position)
	{
		FALSE::Program program {source};
		parser.Parse (stream, GetPlain (position), program);
		printer.Print (program, std::cout);
	}

#elif defined OBERONLANGUAGE

	#include "oberon.hpp"
	#include "obparser.hpp"
	#include "obprinter.hpp"

	#define NAMEPREFIX "ob"
	static Oberon::Printer printer;
	static Oberon::Parser parser {diagnostics, false};

	static void Print (std::istream& stream, const Source& source, const Position& position)
	{
		Oberon::Module module {source};
		parser.Parse (stream, GetPlain (position), module);
		printer.Print (module, std::cout);
	}

#elif defined ASSEMBLYLANGUAGE

	#include "asmparser.hpp"
	#include "asmprinter.hpp"
	#include "assembly.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "asm"
	static StringPool stringPool;
	static Assembly::Printer printer;
	static Assembly::Parser parser {diagnostics, stringPool, true};

	static void Print (std::istream& stream, const Source& source, const Position& position)
	{
		Assembly::Program program {source};
		parser.Parse (stream, GetLine (position), program);
		printer.Print (program, std::cout);
	}

#else

	#error unknown programming language

#endif

int main (int argc, char* argv[])
{
	#if defined CPPLANGUAGE
		parser.IncludeEnvironmentDirectories ();
	#endif

	return Drive (Print, NAMEPREFIX "print", argc, argv, diagnostics);
}

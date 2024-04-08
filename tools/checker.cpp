// Generic semantic checker driver
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

#if defined CODELANGUAGE

	#include "asmparser.hpp"
	#include "assembly.hpp"
	#include "cdchecker.hpp"
	#include "code.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "cd"
	static StringPool stringPool;
	static Code::Platform platform {layout};
	static Code::Checker checker {diagnostics, charset, platform};
	static Assembly::Parser parser {diagnostics, stringPool, true};

	static void Check (std::istream& stream, const Source& source, const Position& position)
	{
		Assembly::Program program {source};
		parser.Parse (stream, GetLine (position), program);
		Code::Sections sections;
		checker.Check (program, sections);
	}

#elif defined CPPLANGUAGE

	#include "cppparser.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "cpp"
	static StringPool stringPool;
	static CPP::Platform platform {layout};
	static CPP::Parser parser {diagnostics, stringPool, charset, platform, false};

	static void Check (std::istream& stream, const Source& source, const Position& position)
	{
		CPP::TranslationUnit translationUnit {source};
		parser.Parse (stream, GetPlain (position), translationUnit);
	}

#elif defined FALSELANGUAGE

	#include "falparser.hpp"
	#include "false.hpp"

	#define NAMEPREFIX "fal"
	static FALSE::Parser parser {diagnostics};

	static void Check (std::istream& stream, const Source& source, const Position& position)
	{
		FALSE::Program program {source};
		parser.Parse (stream, GetPlain (position), program);
	}

#elif defined OBERONLANGUAGE

	#include "obchecker.hpp"
	#include "oberon.hpp"

	#define NAMEPREFIX "ob"
	static Oberon::Platform platform {layout};
	static Oberon::Parser parser {diagnostics, false};
	static Oberon::Checker checker {diagnostics, charset, platform, true};

	static void Check (std::istream& stream, const Source& source, const Position& position)
	{
		Oberon::Module module {source};
		parser.Parse (stream, GetPlain (position), module);
		checker.Check (module);
	}

#else

	#error unknown programming language

#endif

int main (int argc, char* argv[])
{
	#if defined CPPLANGUAGE
		parser.IncludeEnvironmentDirectories ();
	#endif

	return Drive (Check, NAMEPREFIX "check", argc, argv, diagnostics);
}

// Generic interpreter driver
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
#include "stdenvironment.hpp"
#include "stdlayout.hpp"

using namespace ECS;

static StandardLayout layout;
static StandardCharset charset;
static StreamDiagnostics diagnostics {std::cerr};
static StandardEnvironment environment {std::cin, std::cout, std::cerr};

#if defined CODELANGUAGE

	#include "assembly.hpp"
	#include "cdchecker.hpp"
	#include "cdinterpreter.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "cd"
	static StringPool stringPool;
	static Code::Sections sections;
	static Code::Platform platform {layout};
	static Code::Checker checker {diagnostics, charset, platform};
	static Assembly::Parser parser {diagnostics, stringPool, true};
	static Code::Interpreter interpreter {diagnostics, stringPool, charset, platform};

	static void Check (std::istream& stream, const Source& source, const Position& position)
	{
		Assembly::Program program {source};
		parser.Parse (stream, GetLine (position), program);
		checker.Check (program, sections);
	}

	static void Interpret (const Source&)
	{
		if (interpreter.Execute (sections, environment)) throw Error {};
	}

#elif defined CPPLANGUAGE

	#include "cppinterpreter.hpp"
	#include "cppparser.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "cpp"
	static StringPool stringPool;
	static CPP::Platform platform {layout};
	static CPP::TranslationUnits translationUnits;
	static CPP::Interpreter interpreter {diagnostics, stringPool, platform};
	static CPP::Parser parser {diagnostics, stringPool, charset, platform, false};

	static void Check (std::istream& stream, const Source& source, const Position& position)
	{
		translationUnits.emplace_back (source);
		parser.Parse (stream, GetPlain (position), translationUnits.back ());
	}

	static void Interpret (const Source& source)
	{
		CPP::Array arguments {nullptr};
		if (interpreter.Execute (translationUnits, source, environment, arguments)) throw Error {};
	}

#elif defined FALSELANGUAGE

	#include "falinterpreter.hpp"
	#include "falparser.hpp"
	#include "false.hpp"

	#define NAMEPREFIX "fal"
	static FALSE::Programs programs;
	static FALSE::Parser parser {diagnostics};
	static FALSE::Interpreter interpreter {diagnostics};

	static void Check (std::istream& stream, const Source& source, const Position& position)
	{
		programs.emplace_back (source);
		parser.Parse (stream, GetPlain (position), programs.back ());
	}

	static void Interpret (const Source&)
	{
		if (interpreter.Execute (programs, environment)) throw Error {};
	}

#elif defined OBERONLANGUAGE

	#include "obchecker.hpp"
	#include "oberon.hpp"

	#define NAMEPREFIX "ob"
	static Oberon::Modules modules;
	static Oberon::Platform platform {layout};
	static Oberon::Parser parser {diagnostics, false};
	static Oberon::Checker checker {diagnostics, charset, platform, false};
	static Oberon::Interpreter interpreter {diagnostics, charset, platform};

	static void Check (std::istream& stream, const Source& source, const Position& position)
	{
		modules.emplace_back (source);
		parser.Parse (stream, GetPlain (position), modules.back ());
		checker.Check (modules.back ());
	}

	static void Interpret (const Source&)
	{
		if (interpreter.Execute (modules, environment)) throw Error {};
	}

#else

	#error unknown programming language

#endif

static void CheckCommented (std::istream& stream, const Source& source, const Position& position)
{
	auto comment = position; char character;
	if (Advance (stream, comment, character) && character == '#')
		if (Advance (stream, comment, character) && character == '!')
			while (Advance (stream, comment, character) && character != '\n');
		else Regress (Regress (stream, comment, character), comment, '#');
	else Regress (stream, comment, character);
	Check (stream, source, comment);
}

int main (int argc, char* argv[])
{
	#if defined CPPLANGUAGE
		parser.IncludeEnvironmentDirectories ();
		parser.Predefine (stringPool.Insert ("__run__"));
	#endif

	return Drive (CheckCommented, NAMEPREFIX "run", argc, argv, diagnostics, Interpret);
}

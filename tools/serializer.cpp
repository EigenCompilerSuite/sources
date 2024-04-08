// Generic serializer driver
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
#include "xml.hpp"
#include "xmlprinter.hpp"

using namespace ECS;

static XML::Printer printer;
static StandardLayout layout;
static StandardCharset charset;
static StreamDiagnostics diagnostics {std::cerr};

#if defined CPPLANGUAGE

	#include "cppparser.hpp"
	#include "cppserializer.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "cpp"
	static StringPool stringPool;
	static CPP::Serializer serializer;
	static CPP::Platform platform {layout};
	static CPP::Parser parser {diagnostics, stringPool, charset, platform, true};

	static void Serialize (std::istream& stream, const Source& source, const Position& position, XML::Document& document)
	{
		CPP::TranslationUnit translationUnit {source};
		parser.Parse (stream, GetPlain (position), translationUnit);
		serializer.Serialize (translationUnit, document);
	}

#elif defined FALSELANGUAGE

	#include "falparser.hpp"
	#include "false.hpp"
	#include "falserializer.hpp"

	#define NAMEPREFIX "fal"
	static FALSE::Serializer serializer;
	static FALSE::Parser parser {diagnostics};

	static void Serialize (std::istream& stream, const Source& source, const Position& position, XML::Document& document)
	{
		FALSE::Program program {source};
		parser.Parse (stream, GetPlain (position), program);
		serializer.Serialize (program, document);
	}

#elif defined OBERONLANGUAGE

	#include "obchecker.hpp"
	#include "oberon.hpp"
	#include "obserializer.hpp"

	#define NAMEPREFIX "ob"
	static Oberon::Serializer serializer;
	static Oberon::Platform platform {layout};
	static Oberon::Parser parser {diagnostics, true};
	static Oberon::Checker checker {diagnostics, charset, platform, true};

	static void Serialize (std::istream& stream, const Source& source, const Position& position, XML::Document& document)
	{
		Oberon::Module module {source};
		parser.Parse (stream, GetPlain (position), module);
		checker.Check (module);
		serializer.Serialize (module, document);
	}

#else

	#error unknown programming language

#endif

static void Dump (std::istream& stream, const Source& source, const Position& position)
{
	XML::Document document;
	Serialize (stream, source, position, document);
	File file {source, ".xml"};
	printer.Print (document, file);
}

int main (int argc, char* argv[])
{
	#if defined CPPLANGUAGE
		parser.IncludeEnvironmentDirectories ();
	#endif

	return Drive (Dump, NAMEPREFIX "dump", argc, argv, diagnostics);
}

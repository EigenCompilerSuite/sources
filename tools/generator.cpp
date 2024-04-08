// Generic documentation generator driver
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

#include "docchecker.hpp"
#include "documentation.hpp"
#include "driver.hpp"
#include "stdlayout.hpp"

using namespace ECS;

static StandardLayout layout;
static Documentation::Documents documents;
static StreamDiagnostics diagnostics {std::cerr};
static Documentation::Checker docchecker {diagnostics};

#if defined DOCUMENTATIONFORMATTER

	#include "docprinter.hpp"

	#define EXTENSION ".doc"
	#define NAMESUFFIX "doc"
	static Documentation::Printer formatter;

#elif defined HTMLFORMATTER

	#include "dochtmlformatter.hpp"

	#define EXTENSION ".html"
	#define NAMESUFFIX "html"
	static Documentation::HTMLFormatter formatter;

#elif defined LATEXFORMATTER

	#include "doclatexformatter.hpp"

	#define EXTENSION ".tex"
	#define NAMESUFFIX "latex"
	static Documentation::LaTeXFormatter formatter;

#else

	#error unknown documentation formatter

#endif

#if defined DOCUMENTATIONEXTRACTOR

	#include "docparser.hpp"

	#define NAMEPREFIX "doc"
	static Documentation::Parser parser {diagnostics};

	static void Extract (std::istream& stream, const Source& source, const Position& position)
	{
		documents.emplace_back (source);
		parser.Parse (stream, position, documents.back ());
	}

#elif defined CPPEXTRACTOR

	#include "cppextractor.hpp"
	#include "cppparser.hpp"
	#include "stdcharset.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "cpp"
	static ASCIICharset charset;
	static StringPool stringPool;
	static CPP::Platform platform {layout};
	static CPP::Extractor extractor {diagnostics};
	static CPP::Parser parser {diagnostics, stringPool, charset, platform, true};

	static void Extract (std::istream& stream, const Source& source, const Position& position)
	{
		CPP::TranslationUnit translationUnit {source};
		parser.Parse (stream, position, translationUnit);
		documents.emplace_back (source);
		extractor.Extract (translationUnit, documents.back ());
	}

#elif defined OBERONEXTRACTOR

	#include "obchecker.hpp"
	#include "oberon.hpp"
	#include "obextractor.hpp"
	#include "stdcharset.hpp"

	#define NAMEPREFIX "ob"
	static ASCIICharset charset;
	static Oberon::Platform platform {layout};
	static Oberon::Parser parser {diagnostics, true};
	static Oberon::Extractor extractor {diagnostics};
	static Oberon::Checker checker {diagnostics, charset, platform, true};

	static void Extract (std::istream& stream, const Source& source, const Position& position)
	{
		Oberon::Module module {source};
		parser.Parse (stream, position, module);
		checker.Check (module);
		documents.emplace_back (source);
		extractor.Extract (module, documents.back ());
	}

#else

	#error unknown documentation extractor

#endif

static void Generate (const Source& target)
{
	docchecker.Check (documents);
	File file {target, EXTENSION};
	formatter.Print (documents, file);
}

int main (int argc, char* argv[])
{
	#if defined CPPEXTRACTOR
		parser.IncludeEnvironmentDirectories ();
	#endif

	return Drive (Extract, NAMEPREFIX NAMESUFFIX, argc, argv, diagnostics, Generate);
}

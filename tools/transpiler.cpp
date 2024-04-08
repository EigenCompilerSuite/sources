// Generic transpiler driver
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

#if defined FALSELANGUAGE

	#include "falparser.hpp"
	#include "false.hpp"
	#include "faltranspiler.hpp"

	#define NAMEPREFIX "fal"
	static FALSE::Transpiler transpiler;
	static FALSE::Parser parser {diagnostics};

	static void Transpile (std::istream& stream, const Source& source, const Position& position)
	{
		FALSE::Program program {source};
		parser.Parse (stream, GetPlain (position), program);
		File file {source, ".cpp"};
		transpiler.Transpile (program, file);
	}

#elif defined OBERONLANGUAGE

	#include "obchecker.hpp"
	#include "oberon.hpp"
	#include "obtranspiler.hpp"
	#include "utilities.hpp"

	#define NAMEPREFIX "ob"
	static Oberon::Platform platform {layout};
	static Oberon::Transpiler transpiler {platform};
	static Oberon::Parser parser {diagnostics, false};
	static Oberon::Checker checker {diagnostics, charset, platform, true};

	static void Transpile (std::istream& stream, const Source& source, const Position& position)
	{
		Oberon::Module module {source};
		parser.Parse (stream, GetPlain (position), module);
		checker.Check (module);
		const auto filename = GetFilename (module.identifier) + '.';
		File sourceFile {filename, ".cpp"}, headerFile {filename, ".hpp"};
		transpiler.Transpile (module, sourceFile, headerFile);
	}

#else

	#error unknown programming language

#endif

int main (int argc, char* argv[])
{
	return Drive (Transpile, NAMEPREFIX "cpp", argc, argv, diagnostics);
}

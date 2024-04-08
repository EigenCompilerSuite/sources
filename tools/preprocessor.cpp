// Generic preprocessor driver
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

using namespace ECS;

static StandardCharset charset;
static StreamDiagnostics diagnostics {std::cerr};

#if defined CPPLANGUAGE

	#include "cpppreprocessor.hpp"
	#include "stringpool.hpp"

	#define NAMEPREFIX "cpp"
	static StringPool stringPool;
	static CPP::Preprocessor preprocessor {diagnostics, stringPool, charset, false};

	static void Preprocess (std::istream& stream, const Source& source, const Position& position)
	{
		preprocessor.Preprocess (stream, source, GetPlain (position), std::cout);
	}

#else

	#error unknown programming language

#endif

int main (int argc, char* argv[])
{
	#if defined CPPLANGUAGE
		preprocessor.IncludeEnvironmentDirectories ();
	#endif

	return Drive (Preprocess, NAMEPREFIX "prep", argc, argv, diagnostics);
}

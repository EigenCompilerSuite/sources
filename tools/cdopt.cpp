// Intermediate code optimizer driver
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
#include "cdchecker.hpp"
#include "cdgenerator.hpp"
#include "cdoptimizer.hpp"
#include "driver.hpp"
#include "stdcharset.hpp"
#include "stringpool.hpp"

using namespace ECS;

static StringPool stringPool;
static StandardCharset charset;
static Code::Generator generator;
static StreamDiagnostics diagnostics {std::cerr};
static Code::Optimizer optimizer {generator.platform};
static Assembly::Parser parser {diagnostics, stringPool, true};
static Code::Checker checker {diagnostics, charset, generator.platform};

static void Optimize (std::istream& stream, const Source& source, const Position& position)
{
	Assembly::Program program {source};
	parser.Parse (stream, GetLine (position), program);
	Code::Sections sections;
	checker.Check (program, sections);
	optimizer.Optimize (sections);
	generator.Generate (sections, source, std::cout);
}

int main (int argc, char* argv[])
{
	return Drive (Optimize, "cdopt", argc, argv, diagnostics);
}

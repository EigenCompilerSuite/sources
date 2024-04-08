// Generic documentation semantic checker driver
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
#include "docparser.hpp"
#include "documentation.hpp"
#include "driver.hpp"

using namespace ECS;

static Documentation::Documents documents;
static StreamDiagnostics diagnostics {std::cerr};
static Documentation::Parser parser {diagnostics};
static Documentation::Checker checker {diagnostics};

static void Parse (std::istream& stream, const Source& source, const Position& position)
{
	documents.emplace_back (source);
	parser.Parse (stream, GetPlain (position), documents.back ());
}

static void Check (const Source&)
{
	checker.Check (documents);
}

int main (int argc, char* argv[])
{
	return Drive (Parse, "doccheck", argc, argv, diagnostics, Check);
}

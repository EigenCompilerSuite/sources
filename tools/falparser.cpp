// FALSE parser
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

#include "diagnostics.hpp"
#include "error.hpp"
#include "falparser.hpp"
#include "false.hpp"

using namespace ECS;
using namespace FALSE;

Parser::Parser (Diagnostics& d) :
	diagnostics {d}
{
}

void Parser::EmitError (const Program& program, const Position& position, const char*const message) const
{
	diagnostics.Emit (Diagnostics::Error, program.source, position, message); throw Error {};
}

void Parser::Parse (std::istream& stream, const Position& pos, Program& program) const
{
	Lexer lexer;
	Position position = pos;
	Lexer::Token current {position};
	Function* function = &program.main;
	std::vector<Function*> stack;

	for (lexer.Scan (stream, position, current); current.symbol != Lexer::Eof; lexer.Scan (stream, position, current))
		switch (current.symbol)
		{
		case Lexer::Invalid: EmitError (program, current.position, "encountered invalid token");
		case Lexer::BeginFunction: program.Create (current.function); function->push_back (current); stack.push_back (function); function = current.function; break;
		case Lexer::EndFunction: if (stack.empty ()) EmitError (program, current.position, "closing main function"); function = stack.back (); stack.pop_back (); break;
		default: function->push_back (current);
		}

	if (!stack.empty ()) EmitError (program, current.position, "function not closed");
}

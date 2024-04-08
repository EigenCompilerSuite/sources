// FALSE pretty printer
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

#include "falprinter.hpp"
#include "false.hpp"

#include <ostream>

using namespace ECS;
using namespace FALSE;

void Printer::Print (const Program& program, std::ostream& stream) const
{
	Print (program.main, stream);
}

void Printer::Print (const Function& function, std::ostream& stream) const
{
	for (auto& element: function)
		if (element.symbol == Lexer::Integer) stream << ' ' << element;
		else if (element.symbol != Lexer::BeginFunction) stream << element;
		else Print (*element.function, stream << Lexer::BeginFunction), stream << Lexer::EndFunction;
}

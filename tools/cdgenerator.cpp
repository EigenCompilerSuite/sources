// Intermediate code generator
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

#include "asmlexer.hpp"
#include "cdgenerator.hpp"
#include "utilities.hpp"

#include <ostream>

using namespace ECS;
using namespace Code;

void Generator::Generate (const Sections& sections, const Source& source, std::ostream& stream) const
{
	stream << "; intermediate code generated from " << source << '\n';
	for (auto& section: sections) Generate (section, stream);
}

void Generator::Generate (const Section& section, std::ostream& stream) const
{
	stream << '\n';
	if (!section.comment.empty ()) stream << "; " << section.comment << '\n';
	if (IsAssembly (section)) stream << Assembly::Lexer::Assembly << '\n';
	else Assembly::WriteIdentifier (stream << '.' << section.type << ' ', section.name) << '\n';
	if (section.required) stream << '\t' << Assembly::Lexer::Required << '\n';
	if (section.duplicable) stream << '\t' << Assembly::Lexer::Duplicable << '\n';
	if (section.replaceable) stream << '\t' << Assembly::Lexer::Replaceable << '\n';
	if (section.fixed) stream << '\t' << Assembly::Lexer::Origin << '\t' << section.origin << '\n';
	else if (section.alignment > 1) stream << '\t' << Assembly::Lexer::Alignment << '\t' << section.alignment << '\n';
	if (!section.group.empty ()) Assembly::WriteIdentifier (stream << '\t' << Assembly::Lexer::Group << '\t', section.group) << '\n';
	if (!section.instructions.empty () && section.instructions.front ().comment.empty ()) stream << '\n';
	for (auto& instruction: section.instructions) Generate (instruction, GetIndex (instruction, section.instructions) + 1, stream);
}

void Generator::Generate (const Instruction& instruction, const Size index, std::ostream& stream) const
{
	if (!instruction.comment.empty ()) stream << "\n\t; " << index << ": " << instruction.comment << '\n';
	stream << '\t' << instruction << '\n';
}

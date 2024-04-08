// Generic assembly language pretty printer
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

#include "asmprinter.hpp"
#include "assembly.hpp"
#include "indenter.hpp"

#include <ostream>

using namespace ECS;
using namespace Assembly;

using Context = class Printer::Context : Indenter
{
public:
	Instructions::size_type conditionals = 0;

	std::ostream& Print (std::ostream&, const Sections&);
	std::ostream& Print (std::ostream&, const Instructions&);

private:
	std::ostream& Print (std::ostream&, const Section&);
	std::ostream& Print (std::ostream&, const Instruction&);
};

void Printer::Print (const Program& program, std::ostream& stream) const
{
	Context {}.Print (stream, program.sections);
}

void Printer::Print (const Instructions& instructions, std::ostream& stream) const
{
	Context {}.Print (stream, instructions);
}

std::ostream& Context::Print (std::ostream& stream, const Sections& sections)
{
	for (auto& section: sections) Print (stream, section); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Section& section)
{
	if (IsAssembly (section)) Indent (stream) << Lexer::Assembly << '\n';
	else WriteIdentifier (Indent (stream) << '.' << section.type << ' ', section.name) << '\n';
	return Print (stream, section.instructions);
}

std::ostream& Context::Print (std::ostream& stream, const Instructions& instructions)
{
	for (auto& instruction: instructions) Print (stream, instruction);
	while (conditionals) Decrease (stream), --conditionals; return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Instruction& instruction)
{
	if (instruction.directive == Lexer::Endif && conditionals) Decrease (stream), --conditionals;

	Indent (stream);
	if (!instruction.label.empty ()) stream << instruction.label << ':';

	if (instruction.directive) stream << '\t' << instruction.directive;
	else if (!instruction.mnemonic.empty ()) stream << '\t' << instruction.mnemonic;

	if (!instruction.operands.empty ()) stream << '\t';
	stream << instruction.operands << '\n';

	if (instruction.directive == Lexer::If) Increase (stream), ++conditionals;
	return stream;
}

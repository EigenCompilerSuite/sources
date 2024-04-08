// FALSE transpiler
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

#include "false.hpp"
#include "faltranspiler.hpp"
#include "indenter.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace FALSE;

using Context = class Transpiler::Context : Indenter
{
public:
	std::ostream& Print (std::ostream&, const Program&);

private:
	using Functions = std::vector<const Function*>;

	Functions functions;

	std::ostream& Print (std::ostream&, const Element&);
	std::ostream& Print (std::ostream&, const Function&);
	std::ostream& Print (std::ostream&, const Function&, Functions::size_type);
};

void Transpiler::Transpile (const Program& program, std::ostream& stream) const
{
	Context {}.Print (stream, program);
}

std::ostream& Context::Print (std::ostream& stream, const Program& program)
{
	Indent (stream) << "#include <iostream>\n\n";

	Indent (stream) << "using Function = void (*) ();\n";
	Indent (stream) << "union Item {int value; Function function; Item* variable;} variables[26], stack[100], *top = stack + 100;\n\n";

	Indent (Decrease (Indent (Print (Indent (Increase (Indent (stream) << "int main ()\n{\n")) << "(--top)->value = 0;\n\n", program.main)) << "return top->value;\n")) << "}\n";

	for (Functions::size_type index = 0; index != functions.size (); ++index) Print (stream, *functions[index], index);

	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Function& function, const Functions::size_type index)
{
	return Indent (Decrease (Print (Increase (Indent (stream) << "\nvoid Function" << index << " ()\n{\n"), function))) << "}\n";
}

std::ostream& Context::Print (std::ostream& stream, const Function& function)
{
	for (auto& element: function) Print (stream, element); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Element& element)
{
	switch (element.symbol)
	{
	case Lexer::Assign: return Indent (stream) << "*top[0].variable = top[1]; top += 2;\n";
	case Lexer::Call: return Indent (stream) << "(top++)->function ();\n";
	case Lexer::If: return Indent (stream) << "{const auto function = (top++)->function; if ((top++)->value) function ();}\n";
	case Lexer::While: return Indent (stream) << "{const auto function = (top++)->function, condition = (top++)->function; "
		"while (condition (), (top++)->value) function ();}\n";
	case Lexer::Write: return Indent (stream) << "std::cout << (top++)->value;\n";
	case Lexer::Get: return Indent (stream) << "(--top)->value = std::cin.get ();\n";
	case Lexer::Put: return Indent (stream) << "std::cout.put (char ((top++)->value));\n";
	case Lexer::Flush: return Indent (stream) << "std::cout.flush ();\n";
	case Lexer::Dereference: return Indent (stream) << "*top = *top->variable;\n";
	case Lexer::BeginFunction: Indent (stream) << "void Function" << functions.size () << " (); (--top)->function = Function" << functions.size () << ";\n"; functions.push_back (element.function); return stream;
	case Lexer::Negate: return Indent (stream) << "top->value = -top->value;\n";
	case Lexer::Add: return Indent (stream) << "top[1].value += top[0].value; ++top;\n";
	case Lexer::Subtract: return Indent (stream) << "top[1].value -= top[0].value; ++top;\n";
	case Lexer::Multiply: return Indent (stream) << "top[1].value *= top[0].value; ++top;\n";
	case Lexer::Divide: return Indent (stream) << "top[1].value /= top[0].value; ++top;\n";
	case Lexer::Not: return Indent (stream) << "top->value = !top->value;\n";
	case Lexer::And: return Indent (stream) << "top[1].value = top[1].value && top[0].value; ++top;\n";
	case Lexer::Or: return Indent (stream) << "top[1].value = top[1].value || top[0].value; ++top;\n";
	case Lexer::Equal: return Indent (stream) << "top[1].value = top[1].value == top[0].value; ++top;\n";
	case Lexer::Greater: return Indent (stream) << "top[1].value = top[1].value > top[0].value; ++top;\n";
	case Lexer::Duplicate: return Indent (stream) << "--top; top[0] = top[1];\n";
	case Lexer::Delete: return Indent (stream) << "++top;\n";
	case Lexer::Swap: return Indent (stream) << "{const auto item = top[1]; top[1] = top[0]; top[0] = item;}\n";
	case Lexer::Rotate: return Indent (stream) << "{const auto item = top[2]; top[2] = top[1]; top[1] = top[0]; top[0] = item;}\n";
	case Lexer::Select: return Indent (stream) << "*top = top[++top->value];\n";
	case Lexer::Integer: return Indent (stream) << "(--top)->value = " << element.integer << ";\n";
	case Lexer::Character: return Indent (stream) << "(--top)->value = '" << element.character << "';\n";
	case Lexer::Variable: return Indent (stream) << "(--top)->variable = variables + " << element.character - 'a' << ";\n";
	case Lexer::String: return WriteString (Indent (stream) << "std::cout << ", element.string, '"') << ";\n";
	case Lexer::ExternalVariable: return Indent (stream) << "extern Item " << element.string << "; (--top)->variable = &" << element.string << ";\n";
	case Lexer::ExternalFunction: return Indent (stream) << "extern void " << element.string << " (); (--top)->function = &" << element.string << ";\n";
	case Lexer::Assembly: return !element.string.empty () ? WriteString (Indent (stream) << "asm (", element.string, '"') << ");\n" : stream;
	default: assert (Lexer::Unreachable);
	}
}

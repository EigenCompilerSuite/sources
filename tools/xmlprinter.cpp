// XML document pretty printer
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

#include "indenter.hpp"
#include "xml.hpp"
#include "xmlprinter.hpp"

#include <ostream>

using namespace ECS;
using namespace XML;

using Context = class Printer::Context : Indenter
{
public:
	std::ostream& Print (std::ostream&, const Document&);

private:
	std::ostream& Print (std::ostream&, const Element&);
	std::ostream& Print (std::ostream&, const Attribute&);
};

void Printer::Print (const Document& document, std::ostream& stream) const
{
	Context {}.Print (stream, document);

}
std::ostream& Context::Print (std::ostream& stream, const Document& document)
{
	Indent (stream) << "<?xml version=\"1.0\"?>\n";
	if (!document.definition.empty ()) Indent (stream) << "<!DOCTYPE " << document.root.name << " SYSTEM \"" << document.definition << ".dtd\">\n";
	return Print (stream, document.root);
}

std::ostream& Context::Print (std::ostream& stream, const Element& element)
{
	Indent (stream) << '<' << element.name; for (auto& attribute: element.attributes) Print (stream << ' ', attribute);
	if (element.text.empty () && element.children.empty ()) stream << '/'; stream << '>';
	const auto multiline = !element.children.empty () || element.text.find ('\n') != element.text.npos;
	if (multiline) Increase (stream << '\n'); if (!element.text.empty () && multiline) Indent (stream);
	for (auto c: element.text) if (c == '<') stream << "&lt;"; else if (c == '&') stream << "&amp;"; else if (c == '\n' && multiline) Indent (stream << '\n'); else if (c != '\f' && c != '\v') stream << c;
	if (!element.text.empty () && multiline) stream << '\n'; for (auto& child: element.children) Print (stream, child);
	if (multiline) Indent (Decrease (stream)); if (!element.text.empty () || !element.children.empty ()) stream << "</" << element.name << '>'; return stream << '\n';
}

std::ostream& Context::Print (std::ostream& stream, const Attribute& attribute)
{
	stream << attribute.name << "=\"";
	for (auto c: attribute.value) if (c == '<') stream << "&lt;"; else if (c == '&') stream << "&amp;"; else if (c == '"') stream << "&quot;"; else stream << c;
	return stream << '"';
}

// HTML documentation formatter
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

#include "dochtmlformatter.hpp"
#include "documentation.hpp"

#include <cassert>
#include <ostream>
#include <vector>

using namespace ECS;
using namespace Documentation;

using Context = class HTMLFormatter::Context
{
public:
	std::ostream& Print (std::ostream&, const Documents&);

private:
	using ListType = char;

	bool printLabels;
	Level currentLevel;
	std::vector<ListType> listTypes;

	std::ostream& List (std::ostream&, const Article&);
	std::ostream& List (std::ostream&, const Document&);

	std::ostream& Print (std::ostream&, const Text&);
	std::ostream& Print (std::ostream&, const Article&);
	std::ostream& Print (std::ostream&, const Document&);
	std::ostream& Print (std::ostream&, const Paragraph&);
	std::ostream& Print (std::ostream&, const Paragraphs&);
	std::ostream& Print (std::ostream&, const TextElement&);
	std::ostream& PrintLabel (std::ostream&, const Article&);
	std::ostream& PrintText (std::ostream&, const TextElement&);

	std::ostream& EndItem (std::ostream&, Level);
	std::ostream& BeginItem (std::ostream&, Level, ListType);

	static std::ostream& Print (std::ostream&, Character);
	static std::ostream& Print (std::ostream&, const Word&);
};

void HTMLFormatter::Print (const Documents& documents, std::ostream& stream) const
{
	Context {}.Print (stream, documents);
}

std::ostream& Context::Print (std::ostream& stream, const Documents& documents)
{
	stream << "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
		"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
		"<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title></title></head><body>";

	printLabels = true; currentLevel = 1;
	for (auto& document: documents) Print (stream, document.description);
	printLabels = false; currentLevel = 2;
	stream << "<h" << currentLevel << ">Contents</h" << currentLevel << '>';
	for (auto& document: documents) List (stream, document);
	printLabels = true; EndItem (stream, 0);
	for (auto& document: documents) Print (stream, document);

	return stream << "</body></html>\n";
}

std::ostream& Context::PrintLabel (std::ostream& stream, const Article& article)
{
	return article.label.empty () ? stream << '_' << &article : Print (stream, article.label);
}

std::ostream& Context::List (std::ostream& stream, const Document& document)
{
	for (auto& article: document.articles) List (stream, article); return stream;
}

std::ostream& Context::List (std::ostream& stream, const Article& article)
{
	return Print (PrintLabel (BeginItem (stream, article.level, 'o') << "<a href=\"#", article) << "\">", article.title) << "</a>";
}

std::ostream& Context::Print (std::ostream& stream, const Document& document)
{
	for (auto& article: document.articles) Print (stream, article); return stream;
}

std::ostream& Context::BeginItem (std::ostream& stream, const Level level, const Context::ListType type)
{
	EndItem (stream, level - (level == listTypes.size () && !listTypes.empty () && listTypes.back () != type));
	while (level > listTypes.size ()) stream << '<' << type << "l>", listTypes.push_back (type);
	if (level) stream << "<li>"; return stream;
}

std::ostream& Context::EndItem (std::ostream& stream, const Level level)
{
	while (level < listTypes.size ()) stream << "</li></" << listTypes.back () << "l>", listTypes.pop_back ();
	if (!listTypes.empty () && level == listTypes.size ()) stream << "</li>"; return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Article& article)
{
	return Print (Print (PrintLabel (stream << "<hr/><h" << currentLevel << " id=\"", article) << "\">", article.title) << "</h" << currentLevel << '>', article.paragraphs) << "<p><a href=\"#top\">Top of page</a></p>";
}

std::ostream& Context::Print (std::ostream& stream, const Paragraphs& paragraphs)
{
	for (auto& paragraph: paragraphs) Print (stream, paragraph); return EndItem (stream, 0);
}

std::ostream& Context::Print (std::ostream& stream, const Paragraph& paragraph)
{
	if (paragraph.type != Number && paragraph.type != Bullet) EndItem (stream, 0);

	switch (paragraph.type)
	{
	case Heading: return Print (stream << "<h" << paragraph.level + currentLevel << '>', paragraph.text) << "</h" << paragraph.level + currentLevel << '>';
	case TextBlock: return Print (stream << "<p>", paragraph.text) << "</p>";
	case Number: return Print (BeginItem (stream, paragraph.level, 'o'), paragraph.text);
	case Bullet: return Print (BeginItem (stream, paragraph.level, 'u'), paragraph.text);
	case CodeBlock: return Print (stream << "<pre>", paragraph.text) << "</pre>";
	case Table: return Print (stream << "<table>", paragraph.text) << "</table>";
	case Line: return stream << "<hr/>";
	default: assert (UnreachableParagraphType);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Character c)
{
	if (c == '<') return stream << "&lt;";
	if (c == '>') return stream << "&gt;";
	return stream << c;
}

std::ostream& Context::Print (std::ostream& stream, const Word& word)
{
	for (auto character: word) Print (stream, character); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Text& text)
{
	for (auto& element: text) Print (stream, element); return stream;
}

std::ostream& Context::PrintText (std::ostream& stream, const TextElement& element)
{
	return element.text.empty () ? Print (stream, element.word) : Print (stream, element.text);
}

std::ostream& Context::Print (std::ostream& stream, const TextElement& element)
{
	switch (element.style)
	{
	case Default: return PrintText (stream, element);
	case Italic: return PrintText (stream << "<em>", element) << "</em>";
	case Bold: return PrintText (stream << "<strong>", element) << "</strong>";
	case Header: return PrintText (stream << "<th>", element) << "</th>";
	case Cell: return PrintText (stream << "<td>", element) << "</td>";
	case Row: return PrintText (stream << "<tr>", element) << "</tr>";
	case Link: case WeakLink: case URL: stream << "<a href=\""; if (element.style != URL) stream << '#';
		return PrintText (Print (stream, element.word) << "\">", element) << "</a>";
	case Label: return printLabels ? Print (stream << "<a name=\"", element.word) << "\"/>" : stream;
	case Code: return PrintText (stream << "<code>", element) << "</code>";
	case LineBreak: return stream << "<br/>";
	case Space: return stream << ' ';
	case Tab: return stream << "&nbsp;&nbsp;&nbsp;";
	default: assert (UnreachableTextStyle);
	}
}

// Generic documentation pretty printer
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

#include "doclexer.hpp"
#include "docprinter.hpp"
#include "documentation.hpp"

#include <cassert>
#include <ostream>

using namespace ECS;
using namespace Documentation;

using Context = class Printer::Context
{
public:
	std::ostream& Print (std::ostream&, const Documents&);

private:
	std::ostream& Print (std::ostream&, const Text&);
	std::ostream& Print (std::ostream&, const Article&);
	std::ostream& Print (std::ostream&, const Document&);
	std::ostream& Print (std::ostream&, const Paragraph&);
	std::ostream& Print (std::ostream&, const Paragraphs&);
	std::ostream& Print (std::ostream&, const TextElement&);
	std::ostream& Print (std::ostream&, Lexer::Symbol, Lexer::Count);
	std::ostream& PrintText (std::ostream&, const TextElement&);
};

void Printer::Print (const Documents& documents, std::ostream& stream) const
{
	Context {}.Print (stream, documents);
}

std::ostream& Context::Print (std::ostream& stream, const Documents& documents)
{
	for (auto& document: documents) Print (stream, document.description);
	for (auto& document: documents) Print (stream, document); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Document& document)
{
	for (auto& article: document.articles) Print (stream, article); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Lexer::Symbol symbol, Lexer::Count count)
{
	do stream << symbol; while (--count); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Article& article)
{
	if (stream.tellp ()) stream << '\n';
	Print (stream, Lexer::Article, article.level);
	if (!article.label.empty ()) stream << ' ' << Lexer::LabelBegin << article.label << Lexer::LabelEnd;
	return Print (Print (stream, article.title) << '\n', article.paragraphs);
}

std::ostream& Context::Print (std::ostream& stream, const Paragraphs& paragraphs)
{
	for (auto& paragraph: paragraphs) Print (stream, paragraph); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Paragraph& paragraph)
{
	if (stream.tellp ()) stream << '\n';
	switch (paragraph.type)
	{
	case Heading: return Print (Print (stream, Lexer::Heading, paragraph.level), paragraph.text) << '\n';
	case TextBlock: return Print (stream, paragraph.text) << '\n';
	case Number: return Print (Print (stream, Lexer::Number, paragraph.level), paragraph.text) << '\n';
	case Bullet: return Print (Print (stream, Lexer::Bullet, paragraph.level), paragraph.text) << '\n';
	case CodeBlock: return Print (stream << Lexer::CodeBegin << '\n', paragraph.text) << '\n' << Lexer::CodeEnd << '\n';
	case Table: return Print (stream, paragraph.text);
	case Line: return stream << Lexer::Line << '\n';
	default: assert (UnreachableParagraphType);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Text& text)
{
	for (auto& element: text) Print (stream, element); return stream;
}

std::ostream& Context::PrintText (std::ostream& stream, const TextElement& element)
{
	return element.text.empty () ? stream << element.word : Print (stream, element.text);
}

std::ostream& Context::Print (std::ostream& stream, const TextElement& element)
{
	switch (element.style)
	{
	case Default: return PrintText (stream, element);
	case Italic: return PrintText (stream << Lexer::Italic, element) << Lexer::Italic;
	case Bold: return PrintText (stream << Lexer::Bold, element) << Lexer::Bold;
	case Header: return PrintText (stream << Lexer::Header, element);
	case Cell: return PrintText (stream << Lexer::Pipe, element);
	case Row: return PrintText (stream, element) << '\n';
	case Link: case WeakLink: case URL: stream << Lexer::LinkBegin << element.word;
		if (!element.text.empty ()) Print (stream << Lexer::Pipe, element.text); return stream << Lexer::LinkEnd;
	case Label: return stream << Lexer::LabelBegin << element.word << Lexer::LabelEnd;
	case Code: return PrintText (stream << Lexer::CodeBegin, element) << Lexer::CodeEnd;
	case LineBreak: return stream << Lexer::LineBreak;
	case Space: return stream << ' ';
	case Tab: return stream << '\t';
	default: assert (UnreachableTextStyle);
	}
}

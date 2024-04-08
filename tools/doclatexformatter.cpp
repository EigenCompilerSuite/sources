// LaTeX documentation formatter
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

#include "doclatexformatter.hpp"
#include "documentation.hpp"
#include "utilities.hpp"

#include <cassert>
#include <ostream>

using namespace ECS;
using namespace Documentation;

using Context = class LaTeXFormatter::Context
{
public:
	std::ostream& Print (std::ostream&, const Documents&);

private:
	using ListType = const char*;

	Level currentLevel, articleLevel;
	std::vector<ListType> listTypes;

	static std::ostream& Repeat (std::ostream&, Text::size_type, const char*);
	std::ostream& PrintStarSection (std::ostream&, Level, const Text&);
	std::ostream& PrintSection (std::ostream&, Level, const Word&, const Text&);

	std::ostream& Print (std::ostream&, const Text&);
	std::ostream& Print (std::ostream&, const Article&);
	std::ostream& Print (std::ostream&, const Articles&);
	std::ostream& Print (std::ostream&, const Document&);
	std::ostream& Print (std::ostream&, const Paragraph&);
	std::ostream& Print (std::ostream&, const Paragraphs&);
	std::ostream& Print (std::ostream&, const TextElement&);
	std::ostream& PrintText (std::ostream&, const TextElement&);

	std::ostream& PrintPlain (std::ostream&, const Text&);
	std::ostream& PrintPlain (std::ostream&, const TextElement&);

	std::ostream& EndItem (std::ostream&, Level);
	std::ostream& BeginItem (std::ostream&, Level, ListType);

	static std::ostream& Print (std::ostream&, Character);
	static std::ostream& Print (std::ostream&, const Word&);
};

void LaTeXFormatter::Print (const Documents& documents, std::ostream& stream) const
{
	Context {}.Print (stream, documents);
}

std::ostream& Context::Print (std::ostream& stream, const Documents& documents)
{
	stream << "% LaTeX documentation generated from:";
	for (auto& document: documents) stream << ' ' << document.source;
	stream << '\n';

	stream << "\\providecommand{\\docbegin}{\\documentclass{article}\\usepackage{caption}\\usepackage{longtable}\\usepackage[pdfborder={0 0 0}]{hyperref}\\usepackage[latin1]{inputenc}\\begin{document}}\n";
	stream << "\\providecommand{\\docend}{\\end{document}}\n";
	stream << "\\providecommand{\\doclabel}[1]{\\hypertarget{#1}}\n";
	stream << "\\providecommand{\\doclink}[2]{\\hyperlink{#1}{#2}}\n";
	stream << "\\providecommand{\\docsection}[3]{\\hypertarget{#1}{\\section{#2}}}\n";
	stream << "\\providecommand{\\docsectionstar}[1]{\\section*{#1}}\n";
	stream << "\\providecommand{\\docsubbegin}{}\n";
	stream << "\\providecommand{\\docsubend}{}\n";
	stream << "\\providecommand{\\docsubsection}[3]{\\hypertarget{#1}{\\subsection{#2}}}\n";
	stream << "\\providecommand{\\docsubsectionstar}[1]{\\subsection*{#1}}\n";
	stream << "\\providecommand{\\docsubsubbegin}{}\n";
	stream << "\\providecommand{\\docsubsubend}{}\n";
	stream << "\\providecommand{\\docsubsubsection}[3]{\\hypertarget{#1}{\\subsubsection{#2}}}\n";
	stream << "\\providecommand{\\docsubsubsectionstar}[1]{\\subsubsection*{#1}}\n";
	stream << "\\providecommand{\\docsubsubsubsection}[3]{\\hypertarget{#1}{\\paragraph{#2}}}\n";
	stream << "\\providecommand{\\docsubsubsubsectionstar}[1]{\\paragraph*{#1}}\n";
	stream << "\\providecommand{\\doctable}{\\tableofcontents}\n";

	stream << "\\docbegin\n";
	for (auto& document: documents) currentLevel = 0, Print (stream, document.description);
	stream << "\\doctable\n";
	for (auto& document: documents) Print (stream, document);
	return stream << "\\docend\n";
}

std::ostream& Context::Print (std::ostream& stream, const Document& document)
{
	articleLevel = 1; Print (stream, document.articles);
	while (articleLevel > 1) Repeat (stream << "\\doc", --articleLevel, "sub") << "end\n";
	return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Articles& articles)
{
	for (auto& article: articles) Print (stream, article); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Article& article)
{
	currentLevel = article.level;
	while (articleLevel > article.level) Repeat (stream << "\\doc", --articleLevel, "sub") << "end\n";
	while (articleLevel < article.level) Repeat (stream << "\\doc", articleLevel++, "sub") << "begin\n";
	return Print (PrintSection (stream, article.level, article.label, article.title) << '\n', article.paragraphs);
}

std::ostream& Context::BeginItem (std::ostream& stream, const Level level, Context::ListType type)
{
	EndItem (stream, level - (level == listTypes.size () && !listTypes.empty () && listTypes.back () != type));
	while (level > listTypes.size ()) stream << "\\begin{" << type << "}\n", listTypes.push_back (type);
	if (level) stream << "\\item\n"; return stream;
}

std::ostream& Context::EndItem (std::ostream& stream, const Level level)
{
	while (level < listTypes.size ()) stream << "\\end{" << listTypes.back () << "}\n", listTypes.pop_back (); return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Paragraphs& paragraphs)
{
	for (auto& paragraph: paragraphs) Print (stream, paragraph);
	if (!listTypes.empty ()) EndItem (stream << '\n', 0); return stream;
}

std::ostream& Context::PrintSection (std::ostream& stream, const Level level, const Word& label, const Text& text)
{
	return Print (PrintPlain (Repeat (stream << "\\doc", level - 1, "sub") << "section{" << label << "}{", text) << "}{", text) << '}';
}

std::ostream& Context::PrintStarSection (std::ostream& stream, const Level level, const Text& text)
{
	return Print (Repeat (stream << "\\doc", level - 1, "sub") << "sectionstar{", text) << '}';
}

std::ostream& Context::Repeat (std::ostream& stream, Text::size_type count, const char*const text)
{
	for (; count; --count) stream << text; return stream;
}

std::ostream& Context::Print (std::ostream& stream, const Paragraph& paragraph)
{
	if (paragraph.type != Number && paragraph.type != Bullet) EndItem (stream, 0);

	switch (paragraph.type)
	{
	case Heading: return PrintStarSection (stream, currentLevel + paragraph.level, paragraph.text) << '\n';
	case TextBlock: if (paragraph.text.size () == 1 && paragraph.text.front ().style == Code) stream << "\\noindent"; return Print (stream, paragraph.text) << "\\par\n";
	case Number: return Print (BeginItem (stream, paragraph.level, "enumerate"), paragraph.text);
	case Bullet: return Print (BeginItem (stream, paragraph.level, "itemize"), paragraph.text);
	case CodeBlock: return Print (stream << "\\begin{verbatim}\n", paragraph.text) << "\n\\end{verbatim}\n";
	case Table: return Print (Repeat (stream << "\\begin{longtable*}{", CountColumns (paragraph.text), "l") << "}\n", paragraph.text) << "\\end{longtable*}\n";
	case Line: return stream << "\\noindent\\hrulefill\n";
	default: assert (UnreachableParagraphType);
	}
}

std::ostream& Context::Print (std::ostream& stream, const Character c)
{
	if (c == '\\') return stream << "\\textbackslash";
	if (c == '~') return stream << "\\textasciitilde";
	if (c == '{' || c == '}' || c == '#' || c == '_' || c == '&') return stream << '\\' << c;
	if (c == ':') return stream << "$\\colon$";
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

std::ostream& Context::PrintPlain (std::ostream& stream, const Text& text)
{
	for (auto& element: text) PrintPlain (stream, element); return stream;
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
	case Italic: return PrintText (stream << "\\textit{", element) << '}';
	case Bold: return PrintText (stream << "\\textbf{", element) << '}';
	case Header: return PrintText (stream, element);
	case Cell: return PrintText (stream, element);
	case Row: {auto line = true; for (auto& cell: element.text) Print ((cell.style == Header || cell.style == Cell) && !IsFirst (cell, element.text) ? stream << '&' : stream, cell), line &= cell.style == Header;
		stream << "\\\\\n"; if (line) stream << "\\hline\n"; return stream; }
	case Link: case WeakLink: return PrintText (stream << "\\doclink{" << element.word << "}{", element) << '}';
	case URL: return element.text.empty () ? stream << "\\url{" << element.word << '}' : Print (stream << "\\href{" << element.word << "}{", element.text) << '}';
	case Label: return stream << "\\doclabel{" << element.word << '}';
	case Code: return PrintText (stream << "\\texttt{", element) << '}';
	case LineBreak: return stream << "\\newline";
	case Space: return stream << ' ';
	case Tab: return stream << "\\hspace*{2em}";
	default: assert (UnreachableTextStyle);
	}
}

std::ostream& Context::PrintPlain (std::ostream& stream, const TextElement& element)
{
	switch (element.style)
	{
	case Default: case Italic: case Bold: case Code: case Link: case WeakLink: case URL: return PrintText (stream, element);
	case Space: case Tab: return stream << ' ';
	default: assert (UnreachableTextStyle);
	}
}

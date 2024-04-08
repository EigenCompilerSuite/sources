// Generic documentation representation
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

#include "documentation.hpp"

#include <algorithm>
#include <cassert>

using namespace ECS;
using namespace Documentation;

Document::Document (const Source& s) :
	source {s}
{
}

Article::Article (const Level l, const Position& p) :
	position {p}, level {l}
{
	assert (level);
}

Article::Article (const Level le, const Word& la) :
	level {le}, label {la}
{
	assert (level);
}

Paragraph::Paragraph (const ParagraphType t, const Level l) :
	type {t}, level {l}
{
	assert (level);
}

Paragraph::Paragraph (const ParagraphType t, const Position& p) :
	position {p}, type {t}, level {0}
{
}

Paragraph::Paragraph (const ParagraphType t, const Level l, const Position& p) :
	position {p}, type {t}, level {l}
{
	assert (level);
}

TextElement::TextElement (const TextStyle s) :
	style {s}
{
}

TextElement::TextElement (const TextStyle s, const Word& w) :
	style {s}, word {w}
{
}

TextElement::TextElement (const TextStyle s, const Word& w, const Word& t) :
	style {s}, word {w}
{
	text.emplace_back (Default, t);
}

TextElement::TextElement (const TextStyle s, const Word& w, const Position& p) :
	position {p}, style {s}, word {w}
{
}

bool TextElement::operator < (const TextElement& other) const
{
	return word < other.word || word == other.word && text < other.text;
}

Text::size_type Documentation::CountColumns (const Text& table)
{
	Text::size_type columns = 0;
	for (auto& row: table) columns = std::max (columns, row.text.size ());
	return columns;
}

bool Documentation::HasText (const Paragraph& paragraph)
{
	return paragraph.type != CodeBlock && paragraph.type != Line && !paragraph.text.empty ();
}

bool Documentation::HasText (const TextElement& element)
{
	return element.style != Label && element.style != LineBreak && !element.text.empty ();
}

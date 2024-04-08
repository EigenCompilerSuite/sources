// Generic documentation extractor
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
#include "docextractor.hpp"

using namespace ECS;
using namespace Documentation;

Extractor::Extractor (Diagnostics& di, Document& doc) :
	diagnostics {di}, document {doc}, parser {di}
{
}

Article& Extractor::Add (Article&& article)
{
	return document.articles.push_back (std::move (article)), document.articles.back ();
}

void Extractor::Merge (const Annotation& annotation, const Source& source, const Position& position)
{
	std::istringstream stream {annotation};
	parser.Parse (stream, source, position, document);
}

void Extractor::Merge (Article& article, const Annotation& annotation, const Source& source, const Position& position, Tags& tags)
{
	std::istringstream stream {annotation};
	parser.Parse (stream, source, position, article.paragraphs, tags);
}

void Extractor::EmitWarning (const Source& source, const Position& position, const Message& message)
{
	diagnostics.Emit (Diagnostics::Warning, source, position, message);
}

Article& Documentation::operator << (Article& article, Paragraphs& paragraphs)
{
	return article.paragraphs.splice (article.paragraphs.end (), paragraphs), article;
}

Text& Documentation::operator << (Paragraphs& paragraphs, Paragraph&& paragraph)
{
	return paragraphs.push_back (std::move (paragraph)), paragraphs.back ().text;
}

Text& Documentation::operator << (Paragraphs& paragraphs, const ParagraphType type)
{
	return paragraphs.emplace_back (type, 1).text;
}

Text& Documentation::operator << (Text& text, const char* word)
{
	return text.emplace_back (Default, word), text;
}

Text& Documentation::operator << (Text& text, const Text& other)
{
	return text.insert (text.end (), other.begin (), other.end ()), text;
}

Text& Documentation::operator << (Text& text, const Word& word)
{
	return text.emplace_back (Default, word), text;
}

Text& Documentation::operator << (Text& text, TextElement&& element)
{
	return text.push_back (std::move (element)), text;
}

Text& Documentation::operator << (Text& text, const TextStyle style)
{
	return text.emplace_back (style), style == Default || style == Italic || style == Bold || style == Header || style == Cell || style == Row || style == Code ? text.back ().text : text;
}

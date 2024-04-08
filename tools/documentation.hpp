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

#ifndef ECS_DOCUMENTATION_HEADER_INCLUDED
#define ECS_DOCUMENTATION_HEADER_INCLUDED

#include "position.hpp"

#include <array>
#include <list>
#include <map>

namespace ECS::Documentation
{
	enum ParagraphType {Heading, TextBlock, Number, Bullet, CodeBlock, Table, Line, UnreachableParagraphType = 0};
	enum TextStyle {Default, Italic, Bold, Header, Cell, Row, Link, WeakLink, URL, Label, Code, LineBreak, Space, Tab, UnreachableTextStyle = 0};

	struct Article;
	struct Document;
	struct Paragraph;
	struct TextElement;

	using Articles = std::list<Article>;
	using Character = char;
	using Documents = std::list<Document>;
	using Level = std::size_t;
	using Paragraphs = std::list<Paragraph>;
	using Word = std::basic_string<Character>;
	using Tag = std::map<Word, Paragraphs>;
	using Tags = std::array<Tag, 2>;
	using Text = std::list<TextElement>;

	bool HasText (const Paragraph&);
	bool HasText (const TextElement&);

	auto CountColumns (const Text&) -> Text::size_type;
}

struct ECS::Documentation::TextElement
{
	Position position;
	TextStyle style;
	Word word;
	Text text;

	explicit TextElement (TextStyle);
	TextElement (TextStyle, const Word&);
	TextElement (TextStyle, const Word&, const Word&);
	TextElement (TextStyle, const Word&, const Position&);

	bool operator < (const TextElement&) const;
};

struct ECS::Documentation::Paragraph
{
	Position position;
	ParagraphType type;
	Level level;
	Text text;

	Paragraph (ParagraphType, Level);
	Paragraph (ParagraphType, const Position&);
	Paragraph (ParagraphType, Level, const Position&);
};

struct ECS::Documentation::Article
{
	Position position;
	Level level;
	Word label;
	Text title;
	Paragraphs paragraphs;

	Article (Level, const Word&);
	Article (Level, const Position&);
};

struct ECS::Documentation::Document
{
	Source source;
	Paragraphs description;
	Articles articles;

	explicit Document (const Source&);
};

#endif // ECS_DOCUMENTATION_HEADER_INCLUDED

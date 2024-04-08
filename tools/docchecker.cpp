// Generic documentation semantic checker
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
#include "docchecker.hpp"
#include "documentation.hpp"
#include "error.hpp"
#include "format.hpp"

#include <set>

using namespace ECS;
using namespace Documentation;

using Context = class Checker::Context
{
public:
	explicit Context (const Checker&);

	void Check (Documents&);

private:
	const Checker& checker;
	const Source* source;
	Level articleLevel, headingLevel, listItemLevel;
	std::set<Word> labels;

	void AddLabel (const Position&, const Word&);
	void CheckLevel (const Position&, Level, Level&, const char*);
	void EmitError [[noreturn]] (const Position&, const Message&) const;

	void Add (const Article&);
	void Add (const Document&);

	void Visit (const Article&);
	void Visit (const Document&);
	void Visit (const Paragraph&);
	void Visit (const TextElement&);

	void Check (Article&);
	void Check (Document&);
	void Check (Paragraph&);
	void Check (TextElement&);

	template <typename Container> void Add (const Container&);
	template <typename Container> void Visit (const Container&);
	template <typename Container> void Check (Container&);
};

Checker::Checker (Diagnostics& d) :
	diagnostics {d}
{
}

void Checker::Check (Documents& documents) const
{
	Context {*this}.Check (documents);
}

Context::Context (const Checker& c) :
	checker {c}
{
}

void Context::EmitError (const Position& position, const Message& message) const
{
	checker.diagnostics.Emit (Diagnostics::Error, *source, position, message); throw Error {};
}

void Context::AddLabel (const Position& position, const Word& label)
{
	assert (!label.empty ());
	if (!labels.insert (label).second) EmitError (position, Format ("duplicated label '%0'", label));
}

void Context::CheckLevel (const Position& position, const Level level, Level& previous, const char*const name)
{
	if (level > previous + 1) EmitError (position, Format ("%0 has invalid nesting level", name)); previous = level;
}

template <typename Container>
void Context::Add (const Container& container)
{
	Batch (container, [this] (const typename Container::value_type& structure) {Add (structure);});
}

template <typename Container>
void Context::Visit (const Container& container)
{
	Batch (container, [this] (const typename Container::value_type& structure) {Visit (structure);});
}

template <typename Container>
void Context::Check (Container& container)
{
	Batch (container, [this] (typename Container::value_type& structure) {Check (structure);});
}

void Context::Add (const Document& document)
{
	source = &document.source; Add (document.articles);
}

void Context::Add (const Article& article)
{
	if (!article.label.empty ()) AddLabel (article.position, article.label);
}

void Context::Visit (const Document& document)
{
	source = &document.source; Visit (document.description); Visit (document.articles);
}

void Context::Visit (const Article& article)
{
	Visit (article.title); Visit (article.paragraphs);
}

void Context::Visit (const Paragraph& paragraph)
{
	if (HasText (paragraph)) Visit (paragraph.text);
}

void Context::Visit (const TextElement& element)
{
	if (element.style == Label) AddLabel (element.position, element.word);
	if (HasText (element)) Visit (element.text);
}

void Context::Check (Documents& documents)
{
	Add (documents); Visit (documents); Check<Documents> (documents);
}

void Context::Check (Document& document)
{
	source = &document.source; articleLevel = headingLevel = listItemLevel = 0;
	Check (document.description); Check (document.articles);
}

void Context::Check (Article& article)
{
	headingLevel = listItemLevel = 0;
	CheckLevel (article.position, article.level, articleLevel, "article");
	Check (article.title); Check (article.paragraphs);
}

void Context::Check (Paragraph& paragraph)
{
	if (paragraph.type == Heading)
		CheckLevel (paragraph.position, paragraph.level, headingLevel, "heading");
	else if (paragraph.type == Number || paragraph.type == Bullet)
		CheckLevel (paragraph.position, paragraph.level, listItemLevel, "list item");

	if (HasText (paragraph)) Check (paragraph.text);
}

void Context::Check (TextElement& element)
{
	if (element.style == Link && labels.find (element.word) == labels.end ())
		EmitError (element.position, Format ("label '%0' not found", element.word));
	else if (element.style == WeakLink && labels.find (element.word) == labels.end ())
		element.style = Default;

	if (HasText (element)) Check (element.text);
}

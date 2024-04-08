// Generic documentation parser
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
#include "doclexer.hpp"
#include "docparser.hpp"
#include "documentation.hpp"
#include "error.hpp"
#include "format.hpp"

#include <istream>

using namespace ECS;
using namespace Documentation;

using Context = class Parser::Context
{
public:
	Context (const Parser&, std::istream&, const Source&, const Position&);

	void Parse (Document&);
	void Parse (Paragraphs&, Tags&);

private:
	const Parser& parser;
	std::istream& stream;
	const Source& source;
	Position position;
	Lexer lexer;
	Lexer::Token current;
	Lexer::Symbol previous;
	bool listItem = false, italic = false, bold = false, link = false, code = false;

	void EmitError [[noreturn]] (const Message&) const;

	void SkipCurrent ();
	void SkipWhiteSpace ();
	bool Skip (Lexer::Symbol);
	void Expect (Lexer::Symbol) const;
	bool IsCurrent (Lexer::Symbol) const;

	void Parse (Tags&);
	void ParseRow (Text&);
	void Parse (Articles&);
	void ParseTable (Text&);
	void Parse (Paragraphs&);
	void Parse (Text&, Lexer::Symbol);
};

Parser::Parser (Diagnostics& d) :
	diagnostics {d}
{
}

void Parser::Parse (std::istream& stream, const Position& position, Document& document) const
{
	Context {*this, stream, document.source, position}.Parse (document);
}

void Parser::Parse (std::istream& stream, const Source& source, const Position& position, Document& document) const
{
	Context {*this, stream, source, position}.Parse (document);
}

void Parser::Parse (std::istream& stream, const Source& source, const Position& position, Paragraphs& paragraphs, Tags& tags) const
{
	Context {*this, stream, source, position}.Parse (paragraphs, tags);
}

Context::Context (const Parser& p, std::istream& st, const Source& so, const Position& pos) :
	parser {p}, stream {st}, source {so}, position {pos}, current {pos}
{
	lexer.Scan (stream, position, current);
}

void Context::EmitError (const Message& message) const
{
	parser.diagnostics.Emit (Diagnostics::Error, source, current.position, message); throw Error {};
}

void Context::SkipCurrent ()
{
	previous = current.symbol; lexer.Scan (stream, position, current);
}

bool Context::IsCurrent (const Lexer::Symbol symbol) const
{
	return current.symbol == symbol;
}

void Context::SkipWhiteSpace ()
{
	while (IsCurrent (Lexer::Newline) || IsCurrent (Lexer::Space) || IsCurrent (Lexer::Tab)) SkipCurrent ();
}

bool Context::Skip (const Lexer::Symbol symbol)
{
	if (!IsCurrent (symbol)) return false; SkipCurrent (); return true;
}

void Context::Expect (const Lexer::Symbol symbol) const
{
	if (!IsCurrent (symbol)) EmitError (Format ("encountered %0 instead of %1", current, symbol));
}

void Context::Parse (Document& document)
{
	SkipWhiteSpace ();
	if (!IsCurrent (Lexer::Article)) Parse (document.description);
	Parse (document.articles);
}

void Context::Parse (Articles& articles)
{
	for (SkipWhiteSpace (); !IsCurrent (Lexer::Eof); SkipWhiteSpace ())
	{
		Expect (Lexer::Article); articles.emplace_back (current.count, current.position); SkipCurrent ();
		Parse (articles.back ().title, Lexer::Eof);
		Parse (articles.back ().paragraphs);
	}
}

void Context::Parse (Paragraphs& paragraphs, Tags& tags)
{
	SkipWhiteSpace (); Parse (paragraphs); Parse (tags);
}

void Context::Parse (Tags& tags)
{
	for (SkipWhiteSpace (); !IsCurrent (Lexer::Eof); SkipWhiteSpace ())
	{
		Expect (Lexer::Article); const auto level = current.count - 1;
		if (level < tags.size ()) SkipCurrent ();
		Expect (Lexer::String); const auto tag = tags[level].find (current.literal);
		if (tag == tags[level].end ()) EmitError (Format ("invalid tag '%0'", current.literal));
		else if (!tag->second.empty ()) EmitError (Format ("duplicated tag '%0'", current.literal));
		SkipCurrent (); Parse (tag->second); if (tag->second.empty ()) Expect (Lexer::String);
	}
}

void Context::Parse (Paragraphs& paragraphs)
{
	for (SkipWhiteSpace (); !IsCurrent (Lexer::Eof) && !IsCurrent (Lexer::Article); SkipWhiteSpace ())
		if (IsCurrent (Lexer::Heading))
			paragraphs.emplace_back (Heading, current.count, current.position),
			SkipCurrent (), listItem = false, Parse (paragraphs.back ().text, Lexer::Eof);
		else if (IsCurrent (Lexer::Number))
			paragraphs.emplace_back (Number, current.count, current.position),
			SkipCurrent (), listItem = true, Parse (paragraphs.back ().text, Lexer::Eof);
		else if (IsCurrent (Lexer::Bullet))
			paragraphs.emplace_back (Bullet, current.count, current.position),
			SkipCurrent (), listItem = true, Parse (paragraphs.back ().text, Lexer::Eof);
		else if (IsCurrent (Lexer::Bold) && listItem)
			paragraphs.emplace_back (Bullet, 2, current.position),
			SkipCurrent (), listItem = true, Parse (paragraphs.back ().text, Lexer::Eof);
		else if (IsCurrent (Lexer::CodeBegin))
			paragraphs.emplace_back (CodeBlock, current.position), SkipCurrent (), listItem = false,
			paragraphs.back ().text.emplace_back (Default, current.literal), Expect (Lexer::CodeEnd), SkipCurrent ();
		else if (IsCurrent (Lexer::Pipe) || IsCurrent (Lexer::Header))
			listItem = false, ParseTable (paragraphs.emplace_back (Table, current.position).text);
		else if (IsCurrent (Lexer::Line))
			paragraphs.emplace_back (Line, current.position), listItem = false, SkipCurrent ();
		else
			listItem = false, Parse (paragraphs.emplace_back (TextBlock, current.position).text, Lexer::Eof);
	listItem = false;
}

void Context::Parse (Text& text, const Lexer::Symbol sentinel)
{
	while (!IsCurrent (Lexer::Eof) && !IsCurrent (Lexer::Article) && !IsCurrent (sentinel) && (!IsCurrent (Lexer::Newline) || previous != Lexer::Newline) &&
		!IsCurrent (Lexer::Heading) && !IsCurrent (Lexer::Number) && !IsCurrent (Lexer::Bullet) && (!IsCurrent (Lexer::Bold) || !listItem) &&
		!IsCurrent (Lexer::Pipe) && !IsCurrent (Lexer::Header))
		if (!italic && Skip (Lexer::Italic))
			italic = true, Parse (text.emplace_back (Italic).text, Lexer::Italic), italic = false, Skip (Lexer::Italic);
		else if (!bold && Skip (Lexer::Bold))
			bold = true, Parse (text.emplace_back (Bold).text, Lexer::Bold), bold = false, Skip (Lexer::Bold);
		else if (!link && Skip (Lexer::LinkBegin))
		{
			if (!IsCurrent (Lexer::URL)) Expect (Lexer::String);
			text.emplace_back (IsCurrent (Lexer::URL) ? URL : Link, current.literal, current.position); SkipCurrent ();
			if (Skip (Lexer::Pipe)) link = true, Parse (text.back ().text, Lexer::LinkEnd), link = false;
			Expect (Lexer::LinkEnd); SkipCurrent ();
		}
		else if (Skip (Lexer::LabelBegin))
			Expect (Lexer::String), text.emplace_back (Label, current.literal, current.position), SkipCurrent (), Expect (Lexer::LabelEnd), SkipCurrent ();
		else if (!code && IsCurrent (Lexer::CodeBegin))
			current.symbol = Lexer::Eof, SkipCurrent (), code = true, Parse (text.emplace_back (Code).text, Lexer::CodeEnd), code = false, Skip (Lexer::CodeEnd);
		else if (Skip (Lexer::LineBreak))
			text.emplace_back (LineBreak);
		else if (IsCurrent (Lexer::URL))
			text.emplace_back (URL, current.literal, current.position), SkipCurrent ();
		else if (IsCurrent (Lexer::Newline))
			SkipCurrent ();
		else if (IsCurrent (Lexer::Space))
			text.emplace_back (Space), SkipCurrent ();
		else if (IsCurrent (Lexer::Tab))
			text.emplace_back (Tab), SkipCurrent ();
		else
			Expect (Lexer::String), text.emplace_back (Default, current.literal), SkipCurrent ();
}

void Context::ParseTable (Text& rows)
{
	while (IsCurrent (Lexer::Pipe) || IsCurrent (Lexer::Header))
		ParseRow (rows.emplace_back (Row).text);
}

void Context::ParseRow (Text& cells)
{
	while (IsCurrent (Lexer::Pipe) || IsCurrent (Lexer::Header))
		cells.emplace_back (IsCurrent (Lexer::Header) ? Header : Cell),
		SkipCurrent (), Parse (cells.back ().text, Lexer::Newline);
	if (!IsCurrent (Lexer::Eof)) Expect (Lexer::Newline), SkipCurrent ();
}

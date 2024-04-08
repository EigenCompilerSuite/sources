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

#ifndef ECS_DOCUMENTATION_EXTRACTOR_HEADER_INCLUDED
#define ECS_DOCUMENTATION_EXTRACTOR_HEADER_INCLUDED

#include "docparser.hpp"
#include "documentation.hpp"

namespace ECS
{
	using Message = std::string;
}

namespace ECS::Documentation
{
	class Extractor;

	Article& operator << (Article&, Paragraphs&);
	Text& operator << (Paragraphs&, Paragraph&&);
	Text& operator << (Paragraphs&, ParagraphType);

	Text& operator << (Text&, const char*);
	Text& operator << (Text&, const Text&);
	Text& operator << (Text&, const Word&);
	Text& operator << (Text&, TextElement&&);
	Text& operator << (Text&, TextStyle);

	template <typename Value> Text& operator << (Text&, const Value&);
}

class ECS::Documentation::Extractor
{
protected:
	using Annotation = std::string;

	Extractor (Diagnostics&, Document&);

	Article& Add (Article&&);

	void Merge (const Annotation&, const Source&, const Position&);
	void Merge (Article&, const Annotation&, const Source&, const Position&, Tags&);

	void EmitWarning (const Source&, const Position&, const Message&);

private:
	Diagnostics& diagnostics;
	Document& document;
	Parser parser;
};

#include <sstream>

template <typename Value>
ECS::Documentation::Text& ECS::Documentation::operator << (Text& text, const Value& value)
{
	std::ostringstream stream; stream << value;
	return text.emplace_back (Default, stream.str ()), text;
}

#endif // ECS_DOCUMENTATION_EXTRACTOR_HEADER_INCLUDED

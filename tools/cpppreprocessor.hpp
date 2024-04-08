// C++ preprocessor
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

#ifndef ECS_CPP_PREPROCESSOR_HEADER_INCLUDED
#define ECS_CPP_PREPROCESSOR_HEADER_INCLUDED

#include "cpplexer.hpp"

#include <map>

namespace ECS
{
	class StructurePool;
}

namespace ECS::CPP
{
	class Preprocessor;
}

class ECS::CPP::Preprocessor : protected Lexer
{
public:
	using Directory = Source;

	Preprocessor (Diagnostics&, StringPool&, Charset&, Annotations);

	void IncludeEnvironmentDirectories ();
	void IncludeHeader (const Directory&);
	void IncludeSourceFile (const Directory&);

	bool IsPredefined (const String*) const;
	void Predefine (const String*, const BasicToken& = Placemarker);

	void Preprocess (std::istream&, const Source&, const Position&, std::ostream&) const;

protected:
	class Context;

private:
	using Directories = std::vector<Directory>;

	Charset& charset;
	Directories headerDirectories, sourceFileDirectories;
	std::map<const String*, BasicToken> predefinedMacros;

	const String *const end, *const pragma, *const file, *const line, *const defined, *const hasAttribute, *const hasInclude, *const true_, *const vaargs;
	#define DIRECTIVE(directive, name) const String*const directive##Directive;
	#include "cpp.def"
};

#endif // ECS_CPP_PREPROCESSOR_HEADER_INCLUDED

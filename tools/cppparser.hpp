// C++ parser
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

#ifndef ECS_CPP_PARSER_HEADER_INCLUDED
#define ECS_CPP_PARSER_HEADER_INCLUDED

#include "cppchecker.hpp"
#include "cpppreprocessor.hpp"

namespace ECS::CPP
{
	class Parser;
}

class ECS::CPP::Parser : Preprocessor, Checker
{
public:
	Parser (Diagnostics&, StringPool&, Charset&, Platform&, Annotations);

	void Parse (std::istream&, const Position&, TranslationUnit&) const;

	using Preprocessor::IncludeEnvironmentDirectories;
	using Preprocessor::IncludeHeader;
	using Preprocessor::IncludeSourceFile;
	using Preprocessor::Predefine;

private:
	class Context;

	using Preprocessor::diagnostics;
	using Preprocessor::stringPool;

	#define ATTRIBUTE(attribute, name) const String*const attribute##Attribute;
	#define NAMESPACE(namespace, name) const String*const namespace##Namespace;
	#include "cpp.def"
};

#endif // ECS_CPP_PARSER_HEADER_INCLUDED

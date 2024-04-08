// C++ generic documentation extractor
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

#include "cppextractor.hpp"
#include "docextractor.hpp"

using namespace ECS;
using namespace CPP;
using namespace Documentation;

using Context = class CPP::Extractor::Context : Documentation::Extractor
{
public:
	Context (const CPP::Extractor&, const TranslationUnit&, Document&);

	void Extract ();

private:
	const TranslationUnit& translationUnit;
};

CPP::Extractor::Extractor (Diagnostics& d) :
	diagnostics {d}
{
}

void CPP::Extractor::Extract (const TranslationUnit& translationUnit, Document& document) const
{
	Context {*this, translationUnit, document}.Extract ();
}

Context::Context (const CPP::Extractor& e, const TranslationUnit& tu, Document& d) :
	Extractor {e.diagnostics, d}, translationUnit {tu}
{
}

void Context::Extract ()
{
}

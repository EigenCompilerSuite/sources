// C++ pretty printer
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

#ifndef ECS_CPP_PRINTER_HEADER_INCLUDED
#define ECS_CPP_PRINTER_HEADER_INCLUDED

#include <iosfwd>

namespace ECS::CPP
{
	class Printer;

	struct Attribute;
	struct AttributeSpecifier;
	struct Declaration;
	struct DeclarationSpecifier;
	struct Expression;
	struct Identifier;
	struct InitDeclarator;
	struct Statement;
	struct TranslationUnit;
	struct TypeSpecifier;

	std::ostream& operator << (std::ostream&, const Attribute&);
	std::ostream& operator << (std::ostream&, const AttributeSpecifier&);
	std::ostream& operator << (std::ostream&, const Declaration&);
	std::ostream& operator << (std::ostream&, const DeclarationSpecifier&);
	std::ostream& operator << (std::ostream&, const Expression&);
	std::ostream& operator << (std::ostream&, const Identifier&);
	std::ostream& operator << (std::ostream&, const InitDeclarator&);
	std::ostream& operator << (std::ostream&, const Statement&);
	std::ostream& operator << (std::ostream&, const TypeSpecifier&);
}

class ECS::CPP::Printer
{
public:
	void Print (const TranslationUnit&, std::ostream&) const;

private:
	class Context;

	friend std::ostream& operator << (std::ostream&, const Attribute&);
	friend std::ostream& operator << (std::ostream&, const AttributeSpecifier&);
	friend std::ostream& operator << (std::ostream&, const Declaration&);
	friend std::ostream& operator << (std::ostream&, const DeclarationSpecifier&);
	friend std::ostream& operator << (std::ostream&, const Expression&);
	friend std::ostream& operator << (std::ostream&, const Identifier&);
	friend std::ostream& operator << (std::ostream&, const InitDeclarator&);
	friend std::ostream& operator << (std::ostream&, const Statement&);
	friend std::ostream& operator << (std::ostream&, const TypeSpecifier&);
};

#endif // ECS_CPP_PRINTER_HEADER_INCLUDED

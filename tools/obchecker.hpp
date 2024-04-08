// Oberon semantic checker
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

#ifndef ECS_OBERON_CHECKER_HEADER_INCLUDED
#define ECS_OBERON_CHECKER_HEADER_INCLUDED

#include "obparser.hpp"
#include "obprinter.hpp"
#include "obinterpreter.hpp"

#include <memory>
#include <string>
#include <vector>

namespace ECS
{
	using Message = std::string;
	using Source = std::string;
}

namespace ECS::Oberon
{
	class Checker;
	class Platform;

	struct Expression;
	struct QualifiedIdentifier;
	struct Scope;

	using Expressions = std::vector<Expression>;
}

class ECS::Oberon::Checker : Interpreter
{
public:
	using SymbolFiles = bool;

	Checker (Diagnostics&, Charset&, Platform&, SymbolFiles);

	void Check (Module&);

private:
	class Context;

	const SymbolFiles symbolFiles;
	const char*const importDirectory;

	Parser parser;
	Printer printer;
	std::vector<Module*> modules;
	std::vector<std::unique_ptr<Module>> cache;

	void EmitFatalError [[noreturn]] (const Source&, const Message&) const;

	void Export (const Module&) const;
	Module& Import (const QualifiedIdentifier&, const Context&);
	Scope& Import (const QualifiedIdentifier&, Expressions*, const Context&);
	Module& Parameterize (Module&, Expressions*, const Context&);
	Module& Insert (std::unique_ptr<Module>, const Context&);
	void Remove (const QualifiedIdentifier&);
};

#endif // ECS_OBERON_CHECKER_HEADER_INCLUDED

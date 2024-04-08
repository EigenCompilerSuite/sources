// C++ preprocessor context
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

#ifndef ECS_CPP_PREPROCESSOR_CONTEXT_HEADER_INCLUDED
#define ECS_CPP_PREPROCESSOR_CONTEXT_HEADER_INCLUDED

#include "cpplexercontext.hpp"
#include "cpppreprocessor.hpp"

#include <deque>
#include <fstream>

class ECS::CPP::Preprocessor::Context : protected Lexer::Context
{
public:
	Context (const Preprocessor&, StructurePool&, std::istream&, const Location&);

	void Preprocess (std::ostream&);

protected:
	using Value = CPP::Signed;

	void SkipCurrent ();
	bool IsCurrent (Symbol) const;
	bool IsCurrentWhiteSpace () const;
	bool IsCurrent (Symbol, Symbol) const;

	void Putback (const Token&);
	void Putback (const Tokens&);

private:
	enum Conditional {Including, IncludingElse, Skipping, Ignoring, IgnoringElse};

	struct Macro;
	struct State;

	using Macros = std::map<const String*, Macro>;
	using Parameters = std::vector<const String*>;

	const Preprocessor& preprocessor;
	StructurePool& structurePool;

	Macros macros;
	std::ifstream file;
	const Source* filename;
	std::deque<Token> tokens;
	std::vector<State> states;
	Conditional conditional = Including;
	std::vector<Conditional> conditionals;
	bool newline = true, lexerAvailable = true, processingDirective = false, validate = true;

	void EmitWarning (const Token&, const Message&) const;
	void EmitError [[noreturn]] (const Token&, const Message&) const;
	void EmitFatalError [[noreturn]] (const Token&, const Message&) const;

	bool Skip (Symbol);
	bool Skip (Symbol, Symbol);
	void Expect (Symbol) const;
	void SkipCurrentReplaced ();
	void SkipCurrentDirective ();

	bool Replace (Macro&);
	bool ReplaceCurrent ();
	bool ReplaceFileMacro ();
	bool ReplaceLineMacro ();
	bool ReplacePragmaOperator ();
	bool ReplaceObjectLike (Macro&);
	bool Replace (const BasicToken&);
	bool ReplaceFunctionLike (Macro&);
	bool Replace (Macro&, const Tokens&);

	void Override (Location::Origin::Model, Tokens&, const Token&);

	Tokens Expand (const Tokens&);
	Token Stringize (const Token&, const Tokens&);
	Token Concatenate (const Token&, const Token&, const Token&);

	bool IsDefined (const String*) const;

	void ConvertHeaderName ();
	void RestorePreviousState ();
	bool Include (const Source&);
	bool HasInclude (const Source&);

	bool Open (bool (Context::*) (const Source&), const Token&);
	bool OpenHeader (bool (Context::*) (const Source&), const Token&);
	bool OpenSourceFile (bool (Context::*) (const Source&), const Token&);
	bool Open (bool (Context::*) (const Source&), const String&, const Directories&);

	bool ProcessDirective ();
	bool ProcessDiagnosticDirective (void (Context::*) (const Token&, const Message&) const);
	#define DIRECTIVE(directive, name) bool Process##directive##Directive ();
	#include "cpp.def"

	Value EvaluateAdditiveExpression ();
	Value EvaluateAndExpression ();
	Value EvaluateConditionalExpression ();
	Value EvaluateConstantExpression ();
	Value EvaluateDefinedMacroExpression ();
	Value EvaluateEqualityExpression ();
	Value EvaluateExclusiveOrExpression ();
	Value EvaluateExpression ();
	Value EvaluateHasAttributeExpression ();
	Value EvaluateHasIncludeExpression ();
	Value EvaluateInclusiveOrExpression ();
	Value EvaluateLogicalAndExpression ();
	Value EvaluateLogicalOrExpression ();
	Value EvaluateMultiplicativeExpression ();
	Value EvaluatePrimaryExpression ();
	Value EvaluateRelationalExpression ();
	Value EvaluateShiftExpression ();
	Value EvaluateUnaryDivisor ();
	Value EvaluateUnaryExpression ();

	virtual void ProcessPragma (const Tokens&);
	virtual void ValidateMacro (const Token&) const;
	virtual Value TestAttribute (const String*, const String*) const {return 0;}
};

struct ECS::CPP::Preprocessor::Context::Macro
{
	enum Model {Object, Function};

	Model model;
	Parameters parameters;
	Tokens replacementList;
	bool replacing = false;

	explicit Macro (Model);
};

struct ECS::CPP::Preprocessor::Context::State : Lexer::Context::State
{
	const Source* filename;
	Conditional conditional;
	std::streampos streampos;
	std::vector<Conditional> conditionals;

	State (const Lexer::Context::State&, const Source&, Conditional, std::streampos);
};

#endif // ECS_CPP_PREPROCESSOR_CONTEXT_HEADER_INCLUDED

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

#include "cpplexercontext.hpp"
#include "cpppreprocessor.hpp"
#include "error.hpp"
#include "format.hpp"
#include "stringpool.hpp"
#include "structurepool.hpp"
#include "utilities.hpp"

#include <cctype>
#include <cstdlib>
#include <ctime>
#include <deque>
#include <filesystem>
#include <fstream>

using namespace ECS;
using namespace CPP;

using Context =
	#include "cpppreprocessorcontext.hpp"

Preprocessor::Preprocessor (Diagnostics& d, StringPool& sp, Charset& c, const Annotations a) :
	Lexer {d, sp, a}, charset {c}, end {stringPool.Insert ("end")}, pragma {stringPool.Insert ("_Pragma")},
	file {stringPool.Insert ("__FILE__")}, line {stringPool.Insert ("__LINE__")}, defined {stringPool.Insert ("defined")},
	hasAttribute {Insert (HasAttribute)}, hasInclude {Insert (HasInclude)}, true_ {Insert (True)}, vaargs {stringPool.Insert ("__VA_ARGS__")}
	#define DIRECTIVE(directive, name) , directive##Directive {stringPool.Insert (name)}
	#include "cpp.def"
{
	Predefine (file); Predefine (line);
	const auto now = std::time (nullptr); const auto tm = now != -1 ? std::localtime (&now) : nullptr;
	char date[12] {"May 10 2023"}; if (tm) {strftime (date, sizeof date, "%b %d %Y", tm); if (tm->tm_mday < 10) date[4] = ' ';}
	Predefine (stringPool.Insert ("__DATE__"), {NarrowString, stringPool.Insert (WString {date, date + sizeof date - 1})});
	char time[9] {"00:00:00"}; if (tm) strftime (time, sizeof time, "%H:%M:%S", tm);
	Predefine (stringPool.Insert ("__TIME__"), {NarrowString, stringPool.Insert (WString {time, time + sizeof time - 1})});
}

void Preprocessor::IncludeHeader (const Directory& directory)
{
	assert (!directory.empty ());
	InsertUnique (directory, headerDirectories);
}

void Preprocessor::IncludeSourceFile (const Directory& directory)
{
	assert (!directory.empty ());
	InsertUnique (directory, sourceFileDirectories);
}

void Preprocessor::IncludeEnvironmentDirectories ()
{
	auto current = std::getenv ("ECSINCLUDE"); if (!current) return; auto previous = current;
	while (*current) if (*current == ';') {if (current != previous) IncludeHeader ({previous, current}); previous = ++current;} else ++current;
	if (previous != current) IncludeHeader (previous);
}

void Preprocessor::Predefine (const String*const macro, const BasicToken& token)
{
	assert (!IsPredefined (macro)); predefinedMacros.emplace (macro, token);
}

bool Preprocessor::IsPredefined (const String*const macro) const
{
	assert (macro); return macro == defined || macro == hasAttribute || macro == hasInclude || predefinedMacros.find (macro) != predefinedMacros.end ();
}

void Preprocessor::Preprocess (std::istream& input, const Source& source, const Position& position, std::ostream& output) const
{
	StructurePool structurePool;
	Context {*this, structurePool, input, {source, position}}.Preprocess (output);
}

Context::Context (const Preprocessor& p, StructurePool& sp, std::istream& s, const Location& l) :
	Lexer::Context {p, s, l}, preprocessor {p}, structurePool {sp}, filename {location.source}
{
}

void Context::Preprocess (std::ostream& stream)
{
	SkipCurrent (); while (!IsCurrent (Eof)) Write (stream, current), SkipCurrent ();
}

void Context::EmitWarning (const Token& token, const Message& message) const
{
	token.location.Emit (Diagnostics::Warning, preprocessor.diagnostics, message);
}

void Context::EmitError (const Token& token, const Message& message) const
{
	token.location.Emit (Diagnostics::Error, preprocessor.diagnostics, message); throw Error {};
}

void Context::EmitFatalError (const Token& token, const Message& message) const
{
	token.location.Emit (Diagnostics::FatalError, preprocessor.diagnostics, message); throw Error {};
}

bool Context::IsCurrent (const Symbol symbol) const
{
	return current.symbol == symbol;
}

bool Context::IsCurrent (const Symbol symbol, const Symbol alternative) const
{
	return IsCurrent (symbol) || IsCurrent (alternative);
}

bool Context::IsCurrentWhiteSpace () const
{
	return IsCurrent (WhiteSpace) || IsCurrent (Comment) || IsCurrent (Annotation);
}

bool Context::Skip (const Symbol symbol)
{
	if (!IsCurrent (symbol)) return false; do SkipCurrent (); while (IsCurrentWhiteSpace ()); return true;
}

bool Context::Skip (const Symbol symbol, const Symbol alternative)
{
	if (!IsCurrent (symbol, alternative)) return false; do SkipCurrent (); while (IsCurrentWhiteSpace ()); return true;
}

void Context::Expect (const Symbol symbol) const
{
	if (!IsCurrent (symbol)) EmitError (current, Format ("encountered %0 instead of %1", current, symbol));
}

void Context::SkipCurrent ()
{
	while (tokens.empty ()) if (Lexer::Context::SkipCurrent (), SkipCurrentDirective (), !ReplaceCurrent ()) return;
	current = tokens.front (); tokens.pop_front (); SkipCurrentDirective ();
}

void Context::Putback (const Token& cachedToken)
{
	tokens.push_front (cachedToken);
}

void Context::Putback (const Tokens& cachedTokens)
{
	tokens.insert (tokens.begin (), cachedTokens.begin (), cachedTokens.end ());
}

void Context::SkipCurrentReplaced ()
{
	if (!tokens.empty ()) current = tokens.front (), tokens.pop_front ();
	else if (lexerAvailable) Lexer::Context::SkipCurrent ();
	else current.symbol = Eof;
}

bool Context::ReplaceCurrent ()
{
	if (IsCurrent (Placemarker)) return true;
	if (!IsCurrent (Identifier)) return false;
	if (current.identifier == preprocessor.file) return ReplaceFileMacro ();
	if (current.identifier == preprocessor.line) return ReplaceLineMacro ();
	if (current.identifier == preprocessor.pragma) return ReplacePragmaOperator ();
	const auto predefinedMacro = preprocessor.predefinedMacros.find (current.identifier);
	if (predefinedMacro != preprocessor.predefinedMacros.end ()) return Replace (predefinedMacro->second);
	const auto macro = macros.find (current.identifier);
	if (macro != macros.end ()) return Replace (macro->second);
	return false;
}

bool Context::ReplaceFileMacro ()
{
	return Replace ({NarrowString, preprocessor.stringPool.Insert (WString {location.source->begin (), location.source->end ()})});
}

bool Context::ReplaceLineMacro ()
{
	return Replace ({DecimalInteger, preprocessor.stringPool.Insert (std::to_string (GetLine (location.position)))});
}

bool Context::ReplacePragmaOperator ()
{
	Expect (Identifier); do SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (LeftParen);
	do SkipCurrent (); while (IsCurrentWhiteSpace ()); if (!IsString (current.symbol)) Expect (NarrowString);
	std::stringstream stream; for (auto character: *current.literal) Write (stream, character);
	auto location = current.location; do SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (RightParen);
	location.position.Advance ('"'); const auto original = SwitchInput ({location, stream.rdbuf ()}); ProcessPragmaDirective ();
	SwitchInput (original); return !IsCurrent (Eof);
}

bool Context::Replace (Macro& macro)
{
	assert (IsCurrent (Identifier)); if (macro.replacing) return false;
	Override (Location::Origin::Expansion, macro.replacementList, current);
	return macro.model == Macro::Function ? ReplaceFunctionLike (macro) : ReplaceObjectLike (macro);
}

bool Context::ReplaceObjectLike (Macro& macro)
{
	assert (macro.model == Macro::Object);
	return Replace (macro, macro.replacementList);
}

bool Context::Replace (const BasicToken& token)
{
	current.BasicToken::operator = (token); return IsCurrent (Placemarker);
}

bool Context::Replace (Macro& macro, const Tokens& replacementList)
{
	assert (!macro.replacing); macro.replacing = true;
	Putback (Expand (replacementList));
	macro.replacing = false; return true;
}

Lexer::Tokens Context::Expand (const Tokens& replacementList)
{
	decltype (tokens) buffer; tokens.swap (buffer);
	const Restore restoreLexerAvailable {lexerAvailable, false};
	for (auto token = replacementList.begin (); token != replacementList.end (); ++token)
		if (IsConcatenator (token->symbol)) tokens.back () = Concatenate (tokens.back (), *token, *std::next (token)), ++token; else tokens.push_back (*token);
	Tokens expansion; expansion.reserve (tokens.size ());
	while (!tokens.empty ())
	{
		do SkipCurrentReplaced (); while (ReplaceCurrent ());
		if (!IsCurrent (Eof)) expansion.push_back (current);
	}
	tokens.swap (buffer); return expansion;
}

Lexer::Token Context::Concatenate (const Token& first, const Token& operator_, const Token& second)
{
	assert (IsConcatenator (operator_.symbol));
	if (first.symbol == Placemarker) return second;
	if (second.symbol == Placemarker) return first;
	std::stringstream stream; Write (stream, first); Write (stream, second);
	const auto original = SwitchInput ({operator_.location, stream.rdbuf ()}); Lexer::Context::SkipCurrent ();
	const auto result = current; Lexer::Context::SkipCurrent (); SwitchInput (original);
	if (!IsValid (result.symbol) || !IsCurrent (Newline)) EmitError (operator_, Format ("concatenation yields invalid token '%0'", stream.str ()));
	return result;
}

bool Context::ReplaceFunctionLike (Macro& macro)
{
	assert (macro.model == Macro::Function); const auto name = current; Tokens skippedTokens;
	do skippedTokens.push_back (current), SkipCurrentReplaced (); while (IsCurrentWhiteSpace () || IsCurrent (Newline));
	if (IsCurrent (Eof)) return Putback (skippedTokens), SkipCurrentReplaced (), false;
	if (!IsCurrent (LeftParen)) return Putback (current), Putback (skippedTokens), SkipCurrentReplaced (), false;
	do SkipCurrentReplaced (); while (IsCurrentWhiteSpace ()); std::vector<Tokens> arguments; arguments.emplace_back ();
	for (std::streamoff nesting = 0, space = false;; nesting += IsCurrent (LeftParen), nesting -= IsCurrent (RightParen), SkipCurrentReplaced ())
		if (IsCurrent (RightParen) && !nesting) break;
		else if (IsCurrent (Eof) || IsCurrent (Newline) && processingDirective) EmitError (current, Format ("missing closing parenthesis in invocation of macro '%0'", *name.identifier));
		else if (IsCurrentWhiteSpace () || IsCurrent (Newline)) space = !arguments.back ().empty ();
		else if (IsCurrent (Comma) && !nesting && (arguments.size () < macro.parameters.size () || macro.parameters.empty () || macro.parameters.back () != preprocessor.vaargs)) arguments.emplace_back (), space = false;
		else if (space) arguments.back ().emplace_back (WhiteSpace, current.location), arguments.back ().push_back (current), space = false;
		else arguments.back ().push_back (current), space = false;
	if (arguments.size () == 1 && arguments.back ().empty () && macro.parameters.empty ()) arguments.clear ();
	if (arguments.size () > macro.parameters.size ()) EmitError (current, Format ("too many arguments for macro '%0'", *name.identifier));
	else if (arguments.size () < macro.parameters.size ()) EmitError (current, Format ("too few arguments for macro '%0'", *name.identifier));
	Tokens replacementList; replacementList.reserve (macro.replacementList.size ());
	for (auto& token: macro.replacementList)
	{
		if (token.symbol != Identifier) {replacementList.push_back (token); continue;}
		const auto parameter = std::find (macro.parameters.begin (), macro.parameters.end (), token.identifier);
		if (parameter == macro.parameters.end ()) {replacementList.push_back (token); continue;}
		const auto& argument = arguments[parameter - macro.parameters.begin ()];
		const auto previous = replacementList.empty () ? nullptr : &replacementList.back ();
		if (previous && IsPound (previous->symbol)) *previous = Stringize (*previous, argument);
		else if (argument.empty ()) replacementList.emplace_back (Placemarker, token.location);
		else if (IsConcatenator (token.symbol) || previous && IsConcatenator (previous->symbol))
			replacementList.insert (replacementList.end (), argument.begin (), argument.end ());
		else {auto expansion = Expand (argument); Override (Location::Origin::Substitution, expansion, token); replacementList.insert (replacementList.end (), expansion.begin (), expansion.end ());}
	}
	return Replace (macro, replacementList);
}

Lexer::Token Context::Stringize (const Token& operator_, const Tokens& argument)
{
	assert (IsPound (operator_.symbol)); std::ostringstream stream;
	for (auto& token: argument) Write (stream, token); const auto literal = stream.str ();
	return {{NarrowString, preprocessor.stringPool.Insert (WString {literal.begin (), literal.end ()})}, operator_.location};
}

void Context::Override (const Location::Origin::Model model, Tokens& replacementList, const Token& token)
{
	if (!replacementList.empty ()) structurePool.Create (replacementList.front ().location.origin, model, token);
	for (auto& token: replacementList) token.location.origin = replacementList.front ().location.origin;
}

void Context::SkipCurrentDirective ()
{
	for (;;) switch (current.symbol) {
	case Newline: newline = true; return;
	case WhiteSpace: case Comment: case Annotation: goto check;
	case Pound: case PercentColon: if (!newline || !tokens.empty ()) goto check; if (ProcessDirective ()) break; return;
	case Eof: tokens.clear (); if (!conditionals.empty ()) EmitError (current, Format ("%0 ends without #endif directive", GetOrigin (current.location))); if (states.empty ()) return; RestorePreviousState (); break;
	default: newline = false; check: if (conditional != Including && conditional != IncludingElse) Lexer::Context::SkipCurrent (); else return;}
}

bool Context::ProcessDirective ()
{
	assert (!processingDirective); const Restore restoreProcessingDirective {processingDirective, true};
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ()); if (IsCurrent (Newline)) return false; Expect (Identifier);
	#define DIRECTIVE(directive, name) if (current.identifier == preprocessor.directive##Directive) return Process##directive##Directive ();
	#include "cpp.def"
	EmitError (current, Format ("encountered unsupported directive '#%0'", *current.identifier));
}

bool Context::ProcessDefineDirective ()
{
	if (conditional != Including && conditional != IncludingElse) return Lexer::Context::SkipCurrent (), true;
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Identifier);
	ConvertToKeyword (current); ValidateMacro (current); const auto name = current; Lexer::Context::SkipCurrent ();
	const auto model = IsCurrent (LeftParen) ? Lexer::Context::SkipCurrent (), Macro::Function : Macro::Object;
	Parameters parameters; if (model == Macro::Function)
		for (auto separated = true;; Lexer::Context::SkipCurrent ())
			if (IsCurrentWhiteSpace ()) continue;
			else if (IsCurrent (RightParen) && (!separated || parameters.empty ())) {Lexer::Context::SkipCurrent (); break;}
			else if (!parameters.empty () && parameters.back () == preprocessor.vaargs) Expect (RightParen);
			else if (IsCurrent (Ellipsis) && separated) parameters.push_back (preprocessor.vaargs), separated = false;
			else if (IsCurrent (Comma) && !separated) separated = true;
			else if (!separated) Expect (Comma);
			else if (!IsCurrent (Identifier)) Expect (Identifier);
			else if (InsertUnique (current.identifier, parameters)) separated = false;
			else EmitError (current, Format ("duplicated macro parameter '%0'", *current.identifier));
	else if (!IsCurrentWhiteSpace () && !IsCurrent (Newline, Eof)) Expect (WhiteSpace);
	while (IsCurrentWhiteSpace ()) Lexer::Context::SkipCurrent (); Tokens replacementList;
	for (auto space = false; !IsCurrent (Newline, Eof); Lexer::Context::SkipCurrent ())
		if (IsCurrentWhiteSpace ()) space = !replacementList.empty () && !(IsDoublePound (replacementList.back ().symbol) || IsPound (replacementList.back ().symbol) && model == Macro::Function);
		else if (IsCurrent (Identifier) && current.identifier == preprocessor.vaargs && (parameters.empty () || parameters.back () != current.identifier))
			if (model == Macro::Object) EmitError (current, Format ("identifier '%0' occurs in object-like macro", *current.identifier));
			else EmitError (current, Format ("identifier '%0' occurs in function-like macro without ellipsis", *current.identifier));
		else if (model == Macro::Function && !replacementList.empty () && IsPound (replacementList.back ().symbol) && (!IsCurrent (Identifier) || std::find (parameters.begin (), parameters.end (), current.identifier) == parameters.end ()))
			EmitError (current, Format ("%0 is not followed by a parameter", replacementList.back ()));
		else if (!space || IsDoublePound (current.symbol)) replacementList.push_back (current), space = false;
		else replacementList.emplace_back (WhiteSpace, current.location), replacementList.push_back (current), space = false;
	Expect (Newline); if (!replacementList.empty ())
		if (IsDoublePound (replacementList.front ().symbol)) EmitError (current, Format ("macro replacement list begins with %0", replacementList.front ()));
		else if (IsDoublePound (replacementList.back ().symbol)) EmitError (current, Format ("macro replacement list ends with %0", replacementList.back ()));
		else if (model == Macro::Function && IsPound (replacementList.back ().symbol)) EmitError (current, Format ("%0 is not followed by a parameter", replacementList.back ()));
	for (auto& token: replacementList) if (IsDoublePound (token.symbol)) token.symbol = Concatenator;
	const auto result = macros.insert (Macros::value_type (name.identifier, Macro {model})); auto& macro = result.first->second;
	if (!result.second && (model != macro.model || parameters != macro.parameters || replacementList != macro.replacementList)) EmitError (name, Format ("redefinition of macro '%0'", *name.identifier));
	parameters.swap (macro.parameters); replacementList.swap (macro.replacementList); return false;
}

void Context::ValidateMacro (const Token& name) const
{
	if (IsKeyword (name.symbol)) EmitWarning (name, Format ("using keyword '%0' as macro name", *name.identifier));
	if (preprocessor.IsPredefined (name.identifier)) EmitWarning (name, Format ("using predefined macro name '%0'", *name.identifier));
}

bool Context::ProcessElifDirective ()
{
	switch (conditional)
	{
	case Including:
		if (conditionals.empty ()) EmitError (current, "encountered #elif instead of #if directive");
	case Ignoring:
		conditional = Ignoring; Lexer::Context::SkipCurrent (); return true;
	case Skipping:
		conditional = Including;
		do SkipCurrent (); while (IsCurrentWhiteSpace ());
		if (!EvaluateConstantExpression ()) conditional = Skipping;
		Expect (Newline); return false;
	default:
		EmitError (current, "encountered mismatched #elif directive");
	}
}

bool Context::ProcessElseDirective ()
{
	switch (conditional)
	{
	case Including:
		if (conditionals.empty ()) EmitError (current, "encountered mismatched #else directive");
	case Ignoring:
		conditional = IgnoringElse; Lexer::Context::SkipCurrent (); return true;
	case Skipping:
		do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Newline);
		conditional = IncludingElse; return false;
	default:
		EmitError (current, "encountered #else instead of #endif directive");
	}
}

bool Context::ProcessEndifDirective ()
{
	if (conditionals.empty ()) EmitError (current, "encountered mismatched #endif directive");
	conditional = conditionals.back (); conditionals.pop_back ();
	if (conditional != Including && conditional != IncludingElse) return Lexer::Context::SkipCurrent (), true;
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Newline); return false;
}

bool Context::ProcessErrorDirective ()
{
	return ProcessDiagnosticDirective (&Context::EmitError);
}

bool Context::ProcessDiagnosticDirective (void (Context::*const emit) (const Token&, const Message&) const)
{
	if (conditional != Including && conditional != IncludingElse) return Lexer::Context::SkipCurrent (), true;
	const auto directive = current; do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ());
	if (IsCurrent (Newline)) return (this->*emit) (directive, Format ("#%0 directive", *directive.identifier)), false; std::ostringstream stream;
	for (auto space = false; !IsCurrent (Newline, Eof); Lexer::Context::SkipCurrent ())
		if (IsCurrentWhiteSpace ()) space = true; else if (space) Write (stream.put (' '), current), space = false; else Write (stream, current);
	Expect (Newline); (this->*emit) (directive, stream.str ()); return false;
}

bool Context::ProcessIfDirective ()
{
	conditionals.push_back (conditional);
	if (conditional != Including && conditional != IncludingElse) return conditional = Ignoring, Lexer::Context::SkipCurrent (), true;
	do SkipCurrent (); while (IsCurrentWhiteSpace ());
	conditional = EvaluateConstantExpression () ? Including : Skipping;
	Expect (Newline); return false;
}

bool Context::ProcessIfdefDirective ()
{
	conditionals.push_back (conditional);
	if (conditional != Including && conditional != IncludingElse) return conditional = Ignoring, Lexer::Context::SkipCurrent (), true;
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ());
	Expect (Identifier); conditional = IsDefined (current.identifier) ? Including : Skipping;
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Newline); return false;
}

bool Context::ProcessIfndefDirective ()
{
	conditionals.push_back (conditional);
	if (conditional != Including && conditional != IncludingElse) return conditional = Ignoring, Lexer::Context::SkipCurrent (), true;
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ());
	Expect (Identifier); conditional = IsDefined (current.identifier) ? Skipping : Including;
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Newline); return false;
}

bool Context::IsDefined (const String*const name) const
{
	return macros.find (name) != macros.end () || preprocessor.IsPredefined (name);
}

bool Context::ProcessIncludeDirective ()
{
	do ReadHeaderName (); while (IsCurrentWhiteSpace ());
	if (conditional != Including && conditional != IncludingElse) return true;
	if (!IsCurrent (Header, SourceFile) && ReplaceCurrent ()) do SkipCurrent (); while (IsCurrentWhiteSpace ());
	ConvertHeaderName (); if (!IsCurrent (Header, SourceFile)) Expect (Header);
	const auto token = current; do SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Newline);
	if (states.size () == 256) EmitError (token, "exceeded maximum nesting level of #include directives");
	if (!Open (&Context::Include, token)) EmitFatalError (token, Format ("failed to open %0", token));
	structurePool.Create (location.origin, Location::Origin::Inclusion, token); return true;
}

void Context::ConvertHeaderName ()
{
	std::ostringstream stream;
	if (IsCurrent (NarrowString) && !current.suffix)
		WriteEscaped (stream, *current.literal, '"'), current.symbol = SourceFile;
	else if (IsCurrent (Less))
		for (SkipCurrent ();; SkipCurrent ())
			if (IsCurrent (Greater)) {current.symbol = Header; break;}
			else if (IsCurrent (Eof)) Expect (Greater); else Write (stream, current);
	else return;
	current.headerName = preprocessor.stringPool.Insert (stream.str ());
}

bool Context::Open (bool (Context::*const open) (const Source&), const Token& token)
{
	assert (IsHeaderName (token.symbol));
	if (token.headerName->empty ()) EmitError (token, Format ("encountered empty %0", token.symbol));
	if (std::isdigit (token.headerName->front ())) EmitError (token, Format ("invalid first character in %0", token.symbol));
	return token.symbol == SourceFile ? OpenSourceFile (open, token) : OpenHeader (open, token);
}

bool Context::OpenSourceFile (bool (Context::*const open) (const Source&), const Token& token)
{
	const auto position = filename->find_last_of ("/\\");
	const auto fullName = position == filename->npos ? *token.headerName : filename->substr (0, position + 1) + *token.headerName;
	return (this->*open) (fullName) || Open (open, *token.headerName, preprocessor.sourceFileDirectories) || OpenHeader (open, token);
}

bool Context::OpenHeader (bool (Context::*const open) (const Source&), const Token& token)
{
	return Open (open, *token.headerName, preprocessor.headerDirectories);
}

bool Context::Open (bool (Context::*const open) (const Source&), const String& headerName, const Directories& directories)
{
	for (auto& directory: directories) if ((this->*open) (directory + headerName)) return true; return false;
}

bool Context::HasInclude (const Source& source)
{
	std::error_code error; return !std::filesystem::is_directory (source, error) && std::ifstream {source}.is_open ();
}

bool Context::Include (const Source& source)
{
	if (std::error_code error; std::filesystem::is_directory (source)) return false;
	std::ifstream header {source, header.binary}; if (!header.is_open ()) return false;
	const auto streampos = states.empty () ? std::streampos (0) : file.tellg (); file.swap (header);
	const auto name = preprocessor.stringPool.Insert (source); states.emplace_back (SwitchInput ({{*name, {file, *name, 1, 1}}, file.rdbuf ()}), *filename, conditional, streampos);
	filename = name; conditional = Including; conditionals.swap (states.back ().conditionals); current = {Eof, location}; Lexer::Context::SkipCurrent (); return true;
}

void Context::RestorePreviousState ()
{
	assert (!states.empty ());
	filename = states.back ().filename;
	conditional = states.back ().conditional;
	current = {Newline, states.back ().location};
	conditionals.swap (states.back ().conditionals);
	assert (file.is_open ()); file.close ();
	if (states.back ().streambuf == file.rdbuf ())
		if (file.open (*filename, file.binary), !file.is_open () || !file.seekg (states.back ().streampos))
			EmitFatalError (current, "failed to reopen after #include directive");
	SwitchInput (states.back ()); states.pop_back (); Lexer::Context::SkipCurrent ();
}

bool Context::ProcessLineDirective ()
{
	if (conditional != Including && conditional != IncludingElse) return Lexer::Context::SkipCurrent (), true;
	do SkipCurrent (); while (IsCurrentWhiteSpace ()); if (IsCurrent (OctalInteger)) current.symbol = DecimalInteger; else Expect (DecimalInteger);
	CPP::Unsigned line; if (current.suffix || !Evaluate (current, line) || !line || line > 2147483647) EmitError (current, "invalid line number");
	do SkipCurrent (); while (IsCurrentWhiteSpace ()); if (!IsString (current.symbol)) return Expect (Newline), location.position.Override (line), false;
	if (!IsCurrent (NarrowString, RawNarrowString) || current.suffix) EmitError (current, "invalid source filename");
	const auto& file = *current.literal; do SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Newline);
	location.source = preprocessor.stringPool.Insert (Source {file.begin (), file.end ()}); location.position.Override (line); return false;
}

bool Context::ProcessPragmaDirective ()
{
	if (conditional != Including && conditional != IncludingElse) return Lexer::Context::SkipCurrent (), true;
	Tokens tokens; for (Lexer::Context::SkipCurrent (); !IsCurrent (Newline, Eof); Lexer::Context::SkipCurrent ()) if (!IsCurrentWhiteSpace ()) tokens.push_back (current);
	Expect (Newline); ProcessPragma (tokens); return false;
}

void Context::ProcessPragma (const Tokens& tokens)
{
	if (tokens.size () == 1 && tokens.front ().symbol == Identifier && tokens.front ().identifier == preprocessor.end)
		if (conditionals.empty ()) current.symbol = Eof; else EmitError (tokens.front (), "encountered pragma end before #endif directive");
}

bool Context::ProcessUndefDirective ()
{
	if (conditional != Including && conditional != IncludingElse) return Lexer::Context::SkipCurrent (), true;
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Identifier);
	ConvertToKeyword (current); ValidateMacro (current); macros.erase (current.identifier);
	do Lexer::Context::SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (Newline); return false;
}

bool Context::ProcessWarningDirective ()
{
	return ProcessDiagnosticDirective (&Context::EmitWarning);
}

Context::Value Context::EvaluatePrimaryExpression ()
{
	switch (current.symbol)
	{
	case LeftParen:
	{
		do SkipCurrent (); while (IsCurrentWhiteSpace ());
		const auto value = EvaluateExpression (); Expect (RightParen);
		do SkipCurrent (); while (IsCurrentWhiteSpace ()); return value;
	}
	case Identifier:
	{
		if (current.identifier == preprocessor.defined) return EvaluateDefinedMacroExpression ();
		if (current.identifier == preprocessor.hasInclude) return EvaluateHasIncludeExpression ();
		if (current.identifier == preprocessor.hasAttribute) return EvaluateHasAttributeExpression ();
		const auto value = current.identifier == preprocessor.true_;
		do SkipCurrent (); while (IsCurrentWhiteSpace ()); return value;
	}
	case BinaryInteger:
	case OctalInteger:
	case DecimalInteger:
	case HexadecimalInteger:
	{
		bool isUnsigned, isLong, isLongLong;
		if (current.suffix && !HasIntegerSuffix (current, isUnsigned, isLong, isLongLong))
			EmitError (current, Format ("user-defined %0", current.symbol));

		CPP::Unsigned value = 0;
		if (!Evaluate (current, value) && validate) EmitError (current, Format ("%0 exceeds valid integer range", current));
		do SkipCurrent (); while (IsCurrentWhiteSpace ()); return value;
	}
	case NarrowCharacter:
	case Char8TCharacter:
	case Char16TCharacter:
	case Char32TCharacter:
	case WideCharacter:
	{
		if (current.suffix) EmitError (current, Format ("user-defined %0", current.symbol));
		const auto value = Evaluate (current, preprocessor.charset);
		do SkipCurrent (); while (IsCurrentWhiteSpace ()); return value;
	}
	default:
		EmitError (current, Format ("encountered %0 instead of integral expression", current));
	}
}

Context::Value Context::EvaluateUnaryExpression ()
{
	if (Skip (Plus)) return +EvaluateUnaryExpression ();
	if (Skip (Minus)) return -EvaluateUnaryExpression ();
	if (Skip (ExclamationMark, Not)) return !EvaluateUnaryExpression ();
	if (Skip (Tilde, Compl)) return ~EvaluateUnaryExpression ();
	return EvaluatePrimaryExpression ();
}

Context::Value Context::EvaluateDefinedMacroExpression ()
{
	do SkipCurrentReplaced (); while (IsCurrentWhiteSpace ());
	const auto parentheses = IsCurrent (LeftParen);
	if (parentheses) do SkipCurrentReplaced (); while (IsCurrentWhiteSpace ());
	Expect (Identifier); const auto value = IsDefined (current.identifier);
	if (parentheses) {do SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (RightParen);}
	do SkipCurrent (); while (IsCurrentWhiteSpace ()); return value;
}

Context::Value Context::EvaluateHasIncludeExpression ()
{
	do SkipCurrentReplaced (); while (IsCurrentWhiteSpace ());
	Expect (LeftParen); do ReadHeaderName (); while (IsCurrentWhiteSpace ());
	if (!IsCurrent (Header, SourceFile) && ReplaceCurrent ()) do SkipCurrent (); while (IsCurrentWhiteSpace ());
	ConvertHeaderName (); if (!IsCurrent (Header, SourceFile)) Expect (Header);
	const auto value = Open (&Context::HasInclude, current);
	do SkipCurrent (); while (IsCurrentWhiteSpace ()); Expect (RightParen);
	do SkipCurrent (); while (IsCurrentWhiteSpace ()); return value;
}

Context::Value Context::EvaluateHasAttributeExpression ()
{
	do SkipCurrentReplaced (); while (IsCurrentWhiteSpace ()); Expect (LeftParen); do SkipCurrentReplaced (); while (IsCurrentWhiteSpace ());
	Expect (Identifier); const String *name = current.identifier, *namespace_ = nullptr; do SkipCurrentReplaced (); while (IsCurrentWhiteSpace ());
	if (IsCurrent (DoubleColon)) {namespace_ = name; do SkipCurrentReplaced (); while (IsCurrentWhiteSpace ()); Expect (Identifier); name = current.identifier; do SkipCurrent (); while (IsCurrentWhiteSpace ());}
	Expect (RightParen); do SkipCurrent (); while (IsCurrentWhiteSpace ()); return TestAttribute (namespace_, name);
}

Context::Value Context::EvaluateMultiplicativeExpression ()
{
	for (auto value = EvaluateUnaryExpression ();;)
		if (Skip (Asterisk)) value *= EvaluateUnaryExpression ();
		else if (IsCurrent (Slash)) value /= EvaluateUnaryDivisor ();
		else if (IsCurrent (Percent)) value %= EvaluateUnaryDivisor ();
		else return value;
}

Context::Value Context::EvaluateUnaryDivisor ()
{
	assert (IsCurrent (Slash, Percent)); const auto operation = current;
	do SkipCurrent (); while (IsCurrentWhiteSpace ()); if (const auto value = EvaluateUnaryExpression ()) return value;
	if (validate) EmitError (operation, operation.symbol == Percent ? "modulo by zero" : "division by zero"); else return 1;
}

Context::Value Context::EvaluateAdditiveExpression ()
{
	for (auto value = EvaluateMultiplicativeExpression ();;)
		if (Skip (Plus)) value += EvaluateMultiplicativeExpression ();
		else if (Skip (Minus)) value -= EvaluateMultiplicativeExpression ();
		else return value;
}

Context::Value Context::EvaluateShiftExpression ()
{
	for (auto value = EvaluateAdditiveExpression ();;)
		if (Skip (DoubleLess)) value <<= EvaluateAdditiveExpression ();
		else if (Skip (DoubleGreater)) value >>= EvaluateAdditiveExpression ();
		else return value;
}

Context::Value Context::EvaluateRelationalExpression ()
{
	for (auto value = EvaluateShiftExpression ();;)
		if (Skip (Less)) value = value < EvaluateShiftExpression ();
		else if (Skip (Greater)) value = value > EvaluateShiftExpression ();
		else if (Skip (LessEqual)) value = value <= EvaluateShiftExpression ();
		else if (Skip (GreaterEqual)) value = value >= EvaluateShiftExpression ();
		else return value;
}

Context::Value Context::EvaluateEqualityExpression ()
{
	for (auto value = EvaluateRelationalExpression ();;)
		if (Skip (DoubleEqual)) value = value == EvaluateRelationalExpression ();
		else if (Skip (ExclamationMarkEqual, NotEq)) value = value != EvaluateRelationalExpression ();
		else return value;
}

Context::Value Context::EvaluateAndExpression ()
{
	for (auto value = EvaluateEqualityExpression ();;)
		if (Skip (Ampersand, Bitand)) value &= EvaluateEqualityExpression ();
		else return value;
}

Context::Value Context::EvaluateExclusiveOrExpression ()
{
	for (auto value = EvaluateAndExpression ();;)
		if (Skip (Caret, Xor)) value ^= EvaluateAndExpression ();
		else return value;
}

Context::Value Context::EvaluateInclusiveOrExpression ()
{
	for (auto value = EvaluateExclusiveOrExpression ();;)
		if (Skip (Bar, Bitor)) value |= EvaluateExclusiveOrExpression ();
		else return value;
}

Context::Value Context::EvaluateLogicalAndExpression ()
{
	const Restore restoreValidate {validate};
	for (auto value = EvaluateInclusiveOrExpression ();;)
		if (Skip (DoubleAmpersand, And)) validate &= value, value = EvaluateInclusiveOrExpression () && validate && value;
		else return value;
}

Context::Value Context::EvaluateLogicalOrExpression ()
{
	const Restore restoreValidate {validate};
	for (auto value = EvaluateLogicalAndExpression ();;)
		if (Skip (DoubleBar, Or)) validate &= !value, value = EvaluateLogicalAndExpression () && validate || value;
		else return value;
}

Context::Value Context::EvaluateConditionalExpression ()
{
	const auto value = EvaluateLogicalOrExpression (); if (!Skip (QuestionMark)) return value;
	const Restore restoreValidate {validate}; const auto previous = validate;
	validate = previous && value; auto first = EvaluateExpression (); Expect (Colon); do SkipCurrent (); while (IsCurrentWhiteSpace ());
	validate = previous && !value; auto second = EvaluateConditionalExpression (); return value ? first : second;
}

Context::Value Context::EvaluateExpression ()
{
	for (auto value = EvaluateConditionalExpression ();;)
		if (Skip (Comma)) value = EvaluateConditionalExpression ();
		else return value;
}

Context::Value Context::EvaluateConstantExpression ()
{
	return EvaluateConditionalExpression ();
}

Context::Macro::Macro (const Model m) :
	model {m}
{
}

Context::State::State (const Lexer::Context::State& s, const Source& fn, const Conditional c, const std::streampos sp) :
	Lexer::Context::State {s}, filename {&fn}, conditional {c}, streampos {sp}
{
}

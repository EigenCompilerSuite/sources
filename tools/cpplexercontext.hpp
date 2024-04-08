// C++ lexer context
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

#ifndef ECS_CPP_LEXER_CONTEXT_HEADER_INCLUDED
#define ECS_CPP_LEXER_CONTEXT_HEADER_INCLUDED

#include "cpplexer.hpp"

class ECS::CPP::Lexer::Context
{
protected:
	struct State;

	Token current;
	Location location;

	Context (const Lexer&, std::istream&, const Location&);

	void SkipCurrent ();
	void ReadHeaderName ();

	State SwitchInput (const State&);

	static void ConvertToKeyword (BasicToken&);
	static void ConvertToIdentifier (BasicToken&);

private:
	using Length = unsigned;

	const Lexer& lexer;
	std::istream& stream;

	bool commenting = false;
	std::vector<Character> characters;

	void EmitError [[noreturn]] (const Location&, const Message&) const;

	bool Read (Character&);
	bool ReadSource (Character&);
	void ReadEscaped (Character&);
	bool ReadPhysical (Character&);
	void ReadOctalEscaped (Character&);
	void ReadUniversal (Character&, Length);
	void ReadHexadecimalEscaped (Character&);
	void ReadCheckedUniversal (Character&, Length);

	bool Skip (Character);
	void Putback (Character);

	void ReadSuffix (Character);
	Symbol ReadNumber (Character);
	Symbol ReadSymbol (Character);
	Symbol ReadHeaderName (Character);
	Symbol ReadIdentifier (Character);
	Symbol ReadLiteral (Character, Symbol);
	Symbol ReadMultiLineComment (Character);
	Symbol ReadSingleLineComment (Character);
	Symbol ReadRawLiteral (Character, Symbol);

	static bool IsBasicSource (Character);
	static bool IsBinaryDigit (Character);
	static bool IsDigit (Character);
	static bool IsHexadecimalDigit (Character);
	static bool IsInitiallyDisallowed (Character);
	static bool IsNondigit (Character);
	static bool IsOctalDigit (Character);
	static bool IsUniversal (Character);
	static bool IsWhiteSpace (Character);

	static Character GetHexadecimalValue (Character);
	static Character GetOctalValue (Character);

	static String Trim (std::istream&);
	static Symbol Convert (const String&, Symbol, Symbol, Symbol);
};

struct ECS::CPP::Lexer::Context::State
{
	Location location;
	std::streambuf* streambuf;

	State (const Location&, std::streambuf*);
};

#endif // ECS_CPP_LEXER_CONTEXT_HEADER_INCLUDED

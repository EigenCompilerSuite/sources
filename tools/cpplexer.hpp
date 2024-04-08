// C++ lexer
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

#ifndef ECS_CPP_LEXER_HEADER_INCLUDED
#define ECS_CPP_LEXER_HEADER_INCLUDED

#include "diagnostics.hpp"
#include "position.hpp"

#include <cstdint>
#include <vector>

namespace ECS
{
	class Charset;
	class StringPool;
}

namespace ECS::CPP
{
	class Lexer;

	struct Location;

	using Boolean = bool;
	using Float = double;
	using Signed = std::int64_t;
	using Size = std::size_t;
	using String = std::string;
	using Unsigned = std::uint64_t;
	using WString = std::u32string;
}

struct ECS::CPP::Location
{
	struct Origin;

	const Source* source = nullptr;
	const Origin* origin = nullptr;
	Position position;

	Location () = default;
	Location (const Source&, const Position&);

	void Emit (Diagnostics::Type, Diagnostics&, const Message&) const;
};

class ECS::CPP::Lexer
{
public:
	enum Symbol {Eof,
		#define SYMBOL(symbol, name) symbol,
		#include "cpp.def"
		FirstKeyword = Alignas, LastKeyword = While,
		FirstReservedWord = HasAttribute, LastReservedWord = Typetrait,
		FirstOperator = Pound, LastOperator = DoublePercentColon,
		FirstFunctionOperator = ExclamationMark, LastFunctionOperator = XorEq,
		FirstAlternative = And, LastAlternative = XorEq,
		FirstLiteral = BinaryInteger, LastLiteral = RawWideString,
		FirstNumber = BinaryInteger, LastNumber = HexadecimalFloating,
		FirstInteger = BinaryInteger, LastInteger = HexadecimalInteger,
		FirstCharacter = NarrowCharacter, LastCharacter = WideCharacter,
		FirstString = NarrowString, LastString = RawWideString,
		FirstRawString = RawNarrowString, LastRawString = RawWideString,
		UnreachableOperator = 0, UnreachableLiteral = 0,
	};

	struct BasicToken;
	struct Token;

	using Character = char32_t;
	using Tokens = std::vector<Token>;

	static std::ostream& Write (std::ostream&, Character);
	static std::ostream& Write (std::ostream&, const BasicToken&);

	static bool Evaluate (const BasicToken&, CPP::Float&);
	static bool Evaluate (const BasicToken&, CPP::Unsigned&);
	static CPP::Unsigned Evaluate (const BasicToken&, Charset&);
	static CPP::Unsigned Evaluate (WString::value_type, Charset&);

protected:
	class Context;

	using Annotations = bool;

	Diagnostics& diagnostics;
	StringPool& stringPool;

	Lexer (Diagnostics&, StringPool&, Annotations);

	const String* Insert (Symbol) const;

private:
	const Annotations annotations;
};

struct ECS::CPP::Lexer::BasicToken
{
	Symbol symbol;
	const String* suffix;

	union
	{
		Character character;
		const String* number;
		const WString* literal;
		const String* annotation;
		const String* headerName;
		const String* identifier;
	};

	BasicToken (Symbol);
	BasicToken () = default;
	BasicToken (Symbol, const WString*);
	BasicToken (Symbol, const String*, const String* = nullptr);

	bool operator == (const BasicToken&) const;
};

struct ECS::CPP::Lexer::Token : BasicToken
{
	Location location;

	Token (const BasicToken&, const Location&);
};

struct ECS::CPP::Location::Origin
{
	enum Model {Expansion, Inclusion, Substitution, Unreachable = 0};

	Model model;
	Lexer::Token name;

	Origin (Model, const Lexer::Token&);

	void Emit (Diagnostics&) const;
};

namespace ECS::CPP
{
	bool HasFloatingSuffix (const Lexer::BasicToken&, bool&, bool&);
	bool HasIntegerSuffix (const Lexer::BasicToken&, bool&, bool&, bool&);
	bool HasStringSuffix (const Lexer::BasicToken&);
	bool IsAbstractDeclarator (Lexer::Symbol);
	bool IsAccessSpecifier (Lexer::Symbol);
	bool IsAlternative (Lexer::Symbol);
	bool IsAssignmentOperator (Lexer::Symbol);
	bool IsAttribute (Lexer::Symbol);
	bool IsCast (Lexer::Symbol);
	bool IsCharacter (Lexer::Symbol);
	bool IsClassKey (Lexer::Symbol);
	bool IsConcatenator (Lexer::Symbol);
	bool IsConstVolatileQualifier (Lexer::Symbol);
	bool IsDeclarationSpecifier (Lexer::Symbol);
	bool IsDoubleAmpersand (Lexer::Symbol);
	bool IsDoubleBar (Lexer::Symbol);
	bool IsDoublePound (Lexer::Symbol);
	bool IsElaboratedTypeSpecifier (Lexer::Symbol);
	bool IsExpressionDelimiter (Lexer::Symbol);
	bool IsFloating (Lexer::Symbol);
	bool IsFunctionBody (Lexer::Symbol);
	bool IsFunctionOperator (Lexer::Symbol);
	bool IsFunctionSpecifier (Lexer::Symbol);
	bool IsHeaderName (Lexer::Symbol);
	bool IsIdentifier (Lexer::Symbol);
	bool IsInteger (Lexer::Symbol);
	bool IsKeyword (Lexer::Symbol);
	bool IsLiteral (Lexer::Symbol);
	bool IsNestedNameSpecifier (Lexer::Symbol);
	bool IsNumber (Lexer::Symbol);
	bool IsOperator (Lexer::Symbol);
	bool IsPointerOperator (Lexer::Symbol);
	bool IsPound (Lexer::Symbol);
	bool IsRawString (Lexer::Symbol);
	bool IsReferenceQualifier (Lexer::Symbol);
	bool IsReservedWord (Lexer::Symbol);
	bool IsSimpleTypeSpecifier (Lexer::Symbol);
	bool IsStorageClass (Lexer::Symbol);
	bool IsString (Lexer::Symbol);
	bool IsTypeSpecifier (Lexer::Symbol);
	bool IsUnaryOperator (Lexer::Symbol);
	bool IsValid (Lexer::Symbol);

	Lexer::Symbol GetOrigin (const Location&);
	Lexer::Symbol GetPrimary (Lexer::Symbol);
	Lexer::Symbol GetString (Lexer::Symbol);

	std::ostream& operator << (std::ostream&, const Lexer::BasicToken&);
	std::ostream& operator << (std::ostream&, Lexer::Symbol);
}

#endif // ECS_CPP_LEXER_HEADER_INCLUDED

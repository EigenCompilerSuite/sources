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

#include "cppcheckercontext.hpp"
#include "cppparser.hpp"
#include "cpppreprocessorcontext.hpp"
#include "cppprinter.hpp"
#include "error.hpp"
#include "format.hpp"
#include "stringpool.hpp"

using namespace ECS;
using namespace CPP;

using Context = class Parser::Context : Preprocessor::Context, Checker::Context
{
public:
	Context (const Parser&, std::istream&, const Location&, TranslationUnit&);

	void Parse ();

private:
	class CachedStructure;
	class Hideout;

	struct AbstractDeclaratorCache;
	struct ConstructorCache;
	struct DeclarationCache;
	struct DeclaratorCache;
	struct InitDeclaratorCache;
	struct ParenthesizedTypeIdentifierCache;
	struct TypeIdentifierCache;
	struct TypeSpecifierCache;

	template <typename> struct Cached;
	template <Symbol, Symbol = Placemarker> struct CachedToken;

	using Identifier = struct Identifier;
	using Operator = struct Operator;

	const Parser& parser;

	CachedStructure* firstCached = nullptr;

	void Cache (CachedStructure&);
	void Uncache (CachedStructure&);

	bool IsCached (Symbol) const;
	bool IsCachedTypeName () const;
	bool IsCached (Symbol, Symbol) const;
	template <typename> bool IsCached () const;

	void EmitError [[noreturn]] (const Token&, const Message&) const;
	void EmitError [[noreturn]] (const Location&, const Message&) const;

	using Preprocessor::Context::IsCurrent;
	bool IsCurrent (DeclaratorCache&);
	bool IsCurrent (ConstructorCache&);
	bool IsCurrent (DeclarationCache&);
	bool IsCurrent (TypeSpecifierCache&);
	bool IsCurrent (InitDeclaratorCache&);
	bool IsCurrent (TypeIdentifierCache&);
	bool IsCurrent (AbstractDeclaratorCache&);
	bool IsCurrent (ParenthesizedTypeIdentifierCache&);
	template <typename StructureCache> bool IsCurrent (std::unique_ptr<StructureCache>&);

	bool IsCurrentName (DeclaratorCache&);
	bool IsCurrentPointer (DeclaratorCache&);
	bool IsCurrentReference (DeclaratorCache&);
	bool IsCurrentParenthesized (DeclaratorCache&);
	bool IsCurrentDeclarator (void (Context::*) (Declarator&));

	bool IsCurrentPointer (AbstractDeclaratorCache&);
	bool IsCurrentReference (AbstractDeclaratorCache&);
	bool IsCurrentParenthesized (AbstractDeclaratorCache&);

	void SkipCurrent ();

	bool Skip (Symbol);
	bool Skip (Symbol, Symbol);
	template <Symbol symbol> bool Skip (CachedToken<symbol>&);
	template <Symbol symbol, Symbol alternative> bool Skip (CachedToken<symbol, alternative>&);

	bool SkipCached (Symbol);
	bool SkipCached (Symbol, Symbol);

	void Restore (Tokens&);
	void RestoreCachedToken ();

	void Expect (Symbol) const;
	void Expect (Symbol, Symbol) const;

	template <typename Structure> void Locate (Structure&);
	template <typename Structure> void Model (Structure&, typename Structure::Model);

	void Parse (Symbol);
	void Parse (Symbol, Symbol);
	template <Symbol symbol> void Parse (CachedToken<symbol>&);
	template <typename Structure> void Parse (List<Structure>&);
	template <typename Structure> void Parse (Cached<Structure>&);
	template <typename Structure> void Parse (Packed<Structure>&);
	template <Symbol symbol, Symbol alternative> void Parse (CachedToken<symbol, alternative>&);
	template <typename Structure> void Parse (Cached<Structure>&, void (Context::*) (Structure&));
	template <typename Structure> void Parse (Packed<Structure>&, void (Context::*) (Structure&));

	void ParseCached (Symbol);
	void ParseCached (Symbol, Symbol);
	template <typename Structure> void ParseCached (Structure&);
	template <typename Structure> void ParseCached (Structure&, void (Context::*) (Structure&));

	template <typename Structure> void ParseIfCached (Structure*&);
	template <typename Structure> void ParseIfCachedOr (bool, Structure*&);
	template <typename Structure, typename... Arguments> void Parse (Structure*&, Arguments&&...);
	template <typename Structure, typename... Arguments> void ParseIf (bool, Structure*&, Arguments&&...);
	template <typename Structure, typename... Signature, typename... Arguments> void Parse (Structure*&, void (Context::*) (Structure&, Signature...), Arguments&&...);
	template <typename Structure, typename... Signature, typename... Arguments> void ParseIf (bool, Structure*&, void (Context::*) (Structure&, Signature...), Arguments&&...);

	void Parse (AccessSpecifier&);
	void Parse (Attributes&, const Identifier*);
	void Parse (AttributeSpecifiers&);
	void Parse (BaseSpecifier&);
	void Parse (Capture&);
	void Parse (CaptureDefault&);
	void Parse (ClassHead&, bool);
	void Parse (ClassKey&);
	void Parse (ConstVolatileQualifiers&);
	void Parse (DeclarationSpecifiers&);
	void Parse (DecltypeSpecifier&);
	void Parse (EnumeratorDefinition&);
	void Parse (EnumeratorDefinitions&);
	void Parse (EnumHead&);
	void Parse (EnumKey&);
	void Parse (ExceptionDeclaration&);
	void Parse (ExceptionHandler&);
	void Parse (ExceptionHandlers&);
	void Parse (Expressions&);
	void Parse (InitDeclarator&);
	void Parse (InitDeclarators&);
	void Parse (LambdaDeclarator&);
	void Parse (MemberInitializer&);
	void Parse (NoexceptSpecifier&);
	void Parse (Operator&);
	void Parse (ParameterDeclaration&);
	void Parse (ParameterDeclarations&);
	void Parse (ReferenceQualifier&);
	void Parse (Substatement&);
	void Parse (TypeParameterKey&);
	void Parse (UsingDeclarator&);
	void Parse (VirtualSpecifiers&);

	void Parse (MemberDeclarator&);
	void ParseInlined (MemberDeclarator&);

	void Parse (StringLiteral&);
	void ParsePlain (StringLiteral&);
	void ParseUserDefined (StringLiteral&);

	void Parse (Expression&);
	void ParseAdditive (Expression&);
	void ParseAddressof (Expression&);
	void ParseAlignof (Expression&);
	void ParseAnd (Expression&);
	void ParseAssignment (Expression&);
	void ParseBinary (Expression&, void (Context::*) (Expression&));
	void ParseBracedConstructorCall (Expression&);
	void ParseBraced (Expression&);
	void ParseCast (Expression&);
	void ParseCast (Expression&, Expression::Model);
	void ParseComma (Expression&);
	void ParseConditional (Expression&);
	void ParseConstant (Expression&);
	void ParseConstructorCall (Expression&);
	void ParseDelete (Expression&);
	void ParseDoubleColon (Expression&);
	void ParseEquality (Expression&);
	void ParseExclusiveOr (Expression&);
	void ParseFunctionCall (Expression&);
	void ParseIdentifier (Expression&);
	void ParseIdentifierOrConstructorCall (Expression&);
	void ParseInclusiveOr (Expression&);
	void ParseIndirection (Expression&);
	void ParseInitializerClause (Expression&);
	void ParseLambda (Expression&);
	void ParseLiteral (Expression&);
	void ParseLogicalAnd (Expression&);
	void ParseLogicalOr (Expression&);
	void ParseMemberAccess (Expression&);
	void ParseMemberIndirection (Expression&);
	void ParseMultiplicative (Expression&);
	void ParseNew (Expression&);
	void ParseNoexcept (Expression&);
	void ParseOptionallyBraced (Expression&);
	void ParseParenthesized (Expression&);
	void ParsePointerToMember (Expression&);
	void ParsePostfixed (Expression&);
	void ParsePostfix (Expression&);
	void ParsePrefix (Expression&);
	void ParsePrimary (Expression&);
	void ParseRelational (Expression&);
	void ParseShift (Expression&);
	void ParseSizeof (Expression&);
	void ParseSizeofExpression (Expression&);
	void ParseSizeofPack (Expression&);
	void ParseSizeofType (Expression&);
	void ParseStringLiteral (Expression&);
	void ParseSubscript (Expression&);
	void ParseThis (Expression&);
	void ParseThrow (Expression&);
	void ParseTypeid (Expression&);
	void ParseTypeidExpression (Expression&);
	void ParseTypeidType (Expression&);
	void ParseTypetrait (Expression&);
	void ParseUnary (Expression&);
	void ParseUnaryOperator (Expression&);

	void Parse (Identifier&);
	void ParseConversionFunction (Identifier&);
	void ParseDestructor (Identifier&);
	void ParseLiteralOperator (Identifier&);
	void ParseName (Identifier&);
	void ParseOperatorFunction (Identifier&);
	void ParseOperator (Identifier&);
	void ParseQualified (Identifier&);
	void ParseTemplate (Identifier&);
	void ParseUnqualified (Identifier&);

	void Parse (NestedNameSpecifier&);
	void ParseDecltype (NestedNameSpecifier&);
	void ParseGlobal (NestedNameSpecifier&);
	void ParseName (NestedNameSpecifier&);
	void ParseNested (NestedNameSpecifier&, Identifier&);

	void Parse (Statement&);
	void ParseBreak (Statement&);
	void ParseCase (Statement&);
	void ParseCompound (Statement&);
	void ParseContinue (Statement&);
	void ParseCoReturn (Statement&);
	void ParseDeclarationOrExpression (Statement&);
	void ParseDeclaration (Statement&);
	void ParseDefault (Statement&);
	void ParseDo (Statement&);
	void ParseExpression (Statement&);
	void ParseFor (Statement&);
	void ParseGoto (Statement&);
	void ParseIf (Statement&);
	void ParseInit (Statement&);
	void ParseLabel (Statement&);
	void ParseNull (Statement&);
	void ParseReturn (Statement&);
	void ParseSwitch (Statement&);
	void ParseTry (Statement&);
	void ParseWhile (Statement&);

	void Parse (Condition&);
	void ParseDeclaration (Condition&);
	void ParseExpression (Condition&);

	void Parse (StatementBlock&);
	void ParseStatement (StatementBlock&);

	void Parse (Declarations&);
	void ParseMember (Declarations&);

	void Parse (Declaration&);
	void ParseAccess (Declaration&);
	void ParseAlias (Declaration&);
	void ParseAsm (Declaration&);
	void ParseAttributedBlock (Declaration&);
	void ParseAttribute (Declaration&);
	void ParseBlock (Declaration&);
	void ParseCondition (Declaration&);
	void ParseEmpty (Declaration&);
	void ParseExplicitInstantiation (Declaration&);
	void ParseExplicitSpecialization (Declaration&);
	void ParseExtern (Declaration&);
	void ParseFunctionDefinition (Declaration&);
	void ParseInline (Declaration&);
	void ParseInlinedMember (Declaration&);
	void ParseInlinedMemberFunctionDefinition (Declaration&);
	void ParseInlinedMemberSpecification (Declaration&);
	void ParseLinkageSpecification (Declaration&);
	void ParseMember (Declaration&);
	void ParseMemberFunctionDefinition (Declaration&);
	void ParseMemberSpecification (Declaration&);
	void ParseNamespaceAliasDefinition (Declaration&);
	void ParseNamespace (Declaration&);
	void ParseNamespaceDefinition (Declaration&);
	void ParseOpaqueEnum (Declaration&);
	void ParseSimple (Declaration&);
	void ParseStaticAssertion (Declaration&);
	void ParseTemplate (Declaration&);
	void ParseTemplateOrExplicit (Declaration&);
	void ParseUsing (Declaration&);
	void ParseUsingDirective (Declaration&);
	void ParseUsingDirectiveOrAlias (Declaration&);
	void ParseUsingOrAlias (Declaration&);

	void Parse (DeclarationSpecifier&);
	void ParseConstexpr (DeclarationSpecifier&);
	void Parse (DeclarationSpecifiers&, ConstructorCache&);
	void ParseFriend (DeclarationSpecifier&);
	void ParseFunction (DeclarationSpecifier&);
	void ParseInline (DeclarationSpecifier&);
	void ParseStorageClass (DeclarationSpecifier&);
	void ParseType (DeclarationSpecifier&);
	void ParseTypedef (DeclarationSpecifier&);

	void Parse (TypeSpecifier&);
	void ParseClassOrDecltype (TypeSpecifier&);
	void ParseClass (TypeSpecifier&, bool);
	void ParseConstVolatileQualifier (TypeSpecifier&);
	void ParseDecltype (TypeSpecifier&);
	void ParseDefining (TypeSpecifier&);
	void ParseEnum (TypeSpecifier&, bool);
	void ParseSimple (TypeSpecifier&);
	void ParseTypename (TypeSpecifier&);
	void ParseTypeName (TypeSpecifier&);

	void Parse (TypeSpecifiers&);
	void ParseDefining (TypeSpecifiers&);

	void Parse (AttributeSpecifier&);
	void ParseAlignas (AttributeSpecifier&);
	void ParseAlignasExpression (AttributeSpecifier&);
	void ParseAlignasType (AttributeSpecifier&);
	void ParseAttributes (AttributeSpecifier&);

	void Parse (Attribute&, const Identifier*);
	#define ATTRIBUTE(attribute, name) void Parse##attribute (Attribute&);
	#include "cpp.def"

	void ParseFunctionBody (Tokens&);
	void Parse (Tokens&, Symbol, Symbol);
	void ParseBalanced (Tokens&, Symbol, Symbol);

	void Parse (Initializer&);
	void ParseAssignment (Initializer&);
	void ParseBraced (Initializer&);
	void ParseBracedOrAssignment (Initializer&);
	void ParseNew (Initializer&);
	void ParseParenthesized (Initializer&);

	void Parse (Declarator&);
	void ParseAbstractArray (Declarator&);
	void ParseAbstract (Declarator&);
	void ParseAbstractFunction (Declarator&, void (Context::*) (Declarator&));
	void ParseAbstractPack (Declarator&);
	void ParseArray (Declarator&);
	void ParseConversion (Declarator&);
	void ParseDeclaratedArray (Declarator&);
	void ParseFunction (Declarator&);
	void ParseMemberPointer (Declarator&, void (Context::*) (Declarator&));
	void ParseName (Declarator&);
	void ParseNewArray (Declarator&);
	void ParseNew (Declarator&);
	void ParseNoPtrAbstract (Declarator&);
	void ParseNoPtrAbstractPack (Declarator&);
	void ParseNoPtr (Declarator&);
	void ParseNoPtrNew (Declarator&);
	void ParseNoPtrOptionallyAbstractPack (Declarator&);
	void ParseOptionallyAbstract (Declarator&);
	void ParseParenthesized (Declarator&, void (Context::*) (Declarator&));
	void ParsePointer (Declarator&, void (Context::*) (Declarator&));
	void ParsePtr (Declarator&, void (Context::*) (Declarator&));
	void ParseReference (Declarator&, void (Context::*) (Declarator&));
	void ParseTrailingReturnType (Declarator&);

	void Parse (FunctionPrototype&);
	void ParseTrailingReturnType (FunctionPrototype&);

	void Parse (TypeIdentifier&);
	void ParseConversion (TypeIdentifier&);
	void ParseDefining (TypeIdentifier&);
	void ParseNew (TypeIdentifier&);

	void Parse (FunctionBody&);
	void ParseDefault (FunctionBody&);
	void ParseDelete (FunctionBody&);
	void ParseEqual (FunctionBody&);
	void ParseRegular (FunctionBody&);
	void ParseTry (FunctionBody&);

	void Parse (TemplateParameter&);
	void ParseDeclaration (TemplateParameter&);
	void ParseTemplate (TemplateParameter&);
	void ParseType (TemplateParameter&);

	void Parse (TemplateArgument&);
	void ParseExpression (TemplateArgument&);
	void ParseTypeIdentifier (TemplateArgument&);

	void ValidateMacro (const Token&) const override;
	Value TestAttribute (const String*, const String*) const override;

	static void Hide (CachedStructure&);
	static void Unhide (CachedStructure&);
	static void Unlink (CachedStructure&);
	static bool IsCached (const CachedStructure&);
	static void Link (CachedStructure&, CachedStructure**);
	template <typename Structure> static void Reset (Structure*&);
};

class Context::Hideout
{
public:
	Hideout (const Hideout&) = delete;
	explicit Hideout (CachedStructure&);
	~Hideout ();

private:
	CachedStructure& structure;
};

class Context::CachedStructure
{
protected:
	CachedStructure () = default;
	CachedStructure (const CachedStructure&) = delete;
	virtual ~CachedStructure () {if (!std::uncaught_exceptions ()) assert (state != Cached);}

private:
	enum State {Unparsed, Cached, Hidden, Uncached};

	Location location;
	State state = Unparsed;
	CachedStructure* next = nullptr;
	CachedStructure** previous = nullptr;

	friend void Context::Hide (CachedStructure&);
	friend void Context::Cache (CachedStructure&);
	friend void Context::Unhide (CachedStructure&);
	friend void Context::Unlink (CachedStructure&);
	friend void Context::Uncache (CachedStructure&);
	friend bool Context::IsCached (const CachedStructure&);
	friend void Context::Link (CachedStructure&, CachedStructure**);
	template <typename Structure> friend void Context::Locate (Structure&);
};

template <typename Structure> struct Context::Cached : CachedStructure, Structure {};
template <Lexer::Symbol, Lexer::Symbol> struct Context::CachedToken : Cached<BasicToken> {};
struct Context::TypeSpecifierCache {Cached<Identifier> identifier; Cached<DecltypeSpecifier> specifier;};
struct Context::AbstractDeclaratorCache {CachedToken<LeftParen> leftParen; CachedToken<Asterisk> asterisk; CachedToken<Ampersand, Bitand> ampersand; std::unique_ptr<AbstractDeclaratorCache> declarator;};
struct Context::TypeIdentifierCache {TypeSpecifierCache typeSpecifier; Cached<TypeSpecifier> specifier; AbstractDeclaratorCache abstractDeclarator;};
struct Context::ParenthesizedTypeIdentifierCache {CachedToken<LeftParen> leftParen; TypeIdentifierCache typeIdentifier;};
struct Context::ConstructorCache {Cached<Identifier> identifier; Cached<AttributeSpecifiers> attributes; CachedToken<LeftParen> leftParen; TypeSpecifierCache typeSpecifier;};
struct Context::DeclaratorCache {Cached<Identifier> identifier; CachedToken<LeftParen> leftParen; CachedToken<RightParen> rightParen; CachedToken<Asterisk> asterisk; CachedToken<Ampersand, Bitand> ampersand; std::unique_ptr<DeclaratorCache> declarator;};
struct Context::InitDeclaratorCache {DeclaratorCache declarator; CachedToken<Comma> comma; std::unique_ptr<InitDeclaratorCache> initDeclarator;};
struct Context::DeclarationCache {TypeSpecifierCache typeSpecifier; Cached<TypeSpecifier> specifier; InitDeclaratorCache initDeclarator;};

Parser::Parser (Diagnostics& d, StringPool& sp, Charset& c, Platform& p, const Annotations a) :
	Preprocessor {d, sp, c, a}, Checker {d, sp, c, p}
	#define ATTRIBUTE(attribute, name) , attribute##Attribute {stringPool.Insert (name)}
	#define NAMESPACE(namespace, name) , namespace##Namespace {stringPool.Insert (name)}
	#include "cpp.def"
{
	const auto L = stringPool.Insert ("L");
	Predefine (stringPool.Insert ("__ecs__"));
	Predefine (stringPool.Insert ("__cplusplus"), {DecimalInteger, stringPool.Insert ("202302"), L});
	Predefine (stringPool.Insert ("__STDC_HOSTED__"), {DecimalInteger, stringPool.Insert ("1")});
	Predefine (stringPool.Insert ("__STDCPP_DEFAULT_NEW_ALIGNMENT__"), {DecimalInteger, stringPool.Insert (std::to_string (defaultNewAlignment)), stringPool.Insert (IsLongInteger (size) ? "UL" : IsLongLongInteger (size) ? "ULL" : "U")});
	#define FEATURETESTMACRO(name, value) Predefine (stringPool.Insert (name), {DecimalInteger, stringPool.Insert (#value), L});
	#define SIZEOFMACRO(type, name) Predefine (stringPool.Insert ("__sizeof_" name "__"), {DecimalInteger, stringPool.Insert (std::to_string (p.GetSize (Type::type)))});
	#include "cpp.def"
}

void Parser::Parse (std::istream& stream, const Position& position, TranslationUnit& translationUnit) const
{
	Context {*this, stream, {translationUnit.source, position}, translationUnit}.Parse ();
}

Context::Context (const Parser& p, std::istream& s, const Location& l, TranslationUnit& tu) :
	Preprocessor::Context {p, tu, s, l}, Checker::Context {p, tu}, parser {p}
{
	SkipCurrent ();
}

void Context::EmitError (const Location& location, const Message& message) const
{
	location.Emit (Diagnostics::Error, parser.diagnostics, message); throw Error {};
}

inline void Context::EmitError (const Token& token, const Message& message) const
{
	EmitError (token.location, message);
}

void Context::SkipCurrent ()
{
	do Preprocessor::Context::SkipCurrent (); while (IsCurrentWhiteSpace () || IsCurrent (Newline));
	if (!IsCurrent (LeftBracket, LessColon)) return ConvertToKeyword (current); auto leftBracket = current;
	do Preprocessor::Context::SkipCurrent (); while (IsCurrentWhiteSpace () || IsCurrent (Newline));
	if (!IsCurrent (LeftBracket, LessColon)) Putback (current); else leftBracket.symbol = DoubleLeftBracket; current = leftBracket;
}

void Context::Restore (Tokens& tokens)
{
	Putback (current); Putback (tokens); SkipCurrent (); tokens.clear (); tokens.shrink_to_fit ();
}

bool Context::Skip (const Symbol symbol)
{
	if (!IsCurrent (symbol)) return false; SkipCurrent (); return true;
}

bool Context::Skip (const Symbol symbol, const Symbol alternative)
{
	if (!IsCurrent (symbol, alternative)) return false; SkipCurrent (); return true;
}

void Context::Expect (const Symbol symbol) const
{
	if (!IsCurrent (symbol)) EmitError (current, Format ("encountered %0 instead of %1", current, symbol));
}

void Context::Expect (const Symbol symbol, const Symbol alternative) const
{
	if (!IsCurrent (alternative)) Expect (symbol);
}

void Context::Parse (const Symbol symbol)
{
	Expect (symbol); SkipCurrent ();
}

void Context::Parse (const Symbol symbol, const Symbol alternative)
{
	Expect (symbol, alternative); SkipCurrent ();
}

template <typename Structure>
inline void Context::Reset (Structure*& structure)
{
	structure = nullptr;
}

template <typename Structure, typename... Arguments>
inline void Context::Parse (Structure*& structure, Arguments&&... arguments)
{
	translationUnit.Create (structure); Parse (*structure, std::forward<Arguments> (arguments)...);
}

template <typename Structure, typename... Signature, typename... Arguments>
inline void Context::Parse (Structure*& structure, void (Context::*const parse) (Structure&, Signature...), Arguments&&... arguments)
{
	translationUnit.Create (structure); (this->*parse) (*structure, std::forward<Arguments> (arguments)...);
}

template <typename Structure, typename... Arguments>
inline void Context::ParseIf (const bool condition, Structure*& structure, Arguments&&... arguments)
{
	if (condition) Parse (structure, std::forward<Arguments> (arguments)...); else Reset (structure);
}

template <typename Structure, typename... Signature, typename... Arguments>
inline void Context::ParseIf (const bool condition, Structure*& structure, void (Context::*const parse) (Structure&, Signature...), Arguments&&... arguments)
{
	if (condition) Parse (structure, parse, std::forward<Arguments> (arguments)...); else Reset (structure);
}

void Context::Cache (CachedStructure& structure)
{
	assert (structure.state == CachedStructure::Unparsed); structure.state = CachedStructure::Cached;
	auto previous = &firstCached; while (*previous) previous = &(*previous)->next; Link (structure, previous);
}

void Context::Uncache (CachedStructure& structure)
{
	assert (structure.state == CachedStructure::Cached); structure.state = CachedStructure::Uncached; Unlink (structure);
}

void Context::Hide (CachedStructure& structure)
{
	assert (structure.state == CachedStructure::Cached); structure.state = CachedStructure::Hidden; Unlink (structure);
}

void Context::Unhide (CachedStructure& structure)
{
	assert (structure.state == CachedStructure::Hidden); structure.state = CachedStructure::Cached; Link (structure, structure.previous);
}

void Context::Link (CachedStructure& structure, CachedStructure**const previous)
{
	assert (previous); if (structure.next) structure.next->previous = &structure.next; structure.next = *previous; *previous = &structure; structure.previous = previous;
}

void Context::Unlink (CachedStructure& structure)
{
	assert (structure.previous); if (structure.next) structure.next->previous = structure.previous; *structure.previous = structure.next;
}

inline Context::Hideout::Hideout (CachedStructure& s) :
	structure {s}
{
	Hide (structure);
}

inline Context::Hideout::~Hideout ()
{
	Unhide (structure);
}

inline bool Context::IsCached (const CachedStructure& structure)
{
	return structure.state == CachedStructure::Cached;
}

template <typename Structure>
inline bool Context::IsCached () const
{
	return dynamic_cast<Cached<Structure>*> (firstCached);
}

bool Context::IsCachedTypeName () const
{
	if (const auto identifier = dynamic_cast<Cached<Identifier>*> (firstCached)) return IsTypeName (*identifier); return false;
}

bool Context::IsCached (const Symbol symbol) const
{
	if (const auto cachedToken = dynamic_cast<Cached<BasicToken>*> (firstCached)) return cachedToken->symbol == symbol; return false;
}

bool Context::IsCached (const Symbol symbol, const Symbol alternative) const
{
	if (const auto cachedToken = dynamic_cast<Cached<BasicToken>*> (firstCached)) return cachedToken->symbol == symbol || cachedToken->symbol == alternative; return false;
}

bool Context::SkipCached (const Symbol symbol)
{
	if (!IsCached (symbol)) return Skip (symbol); Uncache (*firstCached); return true;
}

bool Context::SkipCached (const Symbol symbol, const Symbol alternative)
{
	if (!IsCached (symbol, alternative)) return Skip (symbol, alternative); Uncache (*firstCached); return true;
}

void Context::RestoreCachedToken ()
{
	Putback (current); current.BasicToken::operator = (dynamic_cast<Cached<BasicToken>&> (*firstCached)); Uncache (*firstCached);
}

template <typename Structure>
void Context::Parse (Cached<Structure>& structure)
{
	Locate<CachedStructure> (structure); Parse (static_cast<Structure&> (structure)); Cache (structure);
}

template <typename Structure>
void Context::Parse (Cached<Structure>& structure, void (Context::*const parse) (Structure&))
{
	Locate<CachedStructure> (structure); (this->*parse) (structure); Cache (structure);
}

template <Lexer::Symbol symbol>
inline void Context::Parse (CachedToken<symbol>& token)
{
	Locate (token); token.BasicToken::operator = (current); Parse (symbol); Cache (token);
}

template <Lexer::Symbol symbol, Lexer::Symbol alternative>
inline void Context::Parse (CachedToken<symbol, alternative>& token)
{
	Locate (token); token.BasicToken::operator = (current); Parse (symbol, alternative); Cache (token);
}

template <Lexer::Symbol symbol>
inline bool Context::Skip (CachedToken<symbol>& token)
{
	if (!IsCurrent (symbol)) return false; Parse (token); return true;
}

template <Lexer::Symbol symbol, Lexer::Symbol alternative>
bool Context::Skip (CachedToken<symbol, alternative>& token)
{
	if (!IsCurrent (symbol, alternative)) return false; Parse (token); return true;
}

template <typename Structure>
void Context::ParseCached (Structure& structure)
{
	if (const auto cachedStructure = dynamic_cast<Cached<Structure>*> (firstCached)) structure = std::move (*cachedStructure), Uncache (*cachedStructure); else Parse (structure);
}

template <typename Structure>
void Context::ParseCached (Structure& structure, void (Context::*const parse) (Structure&))
{
	if (const auto cachedStructure = dynamic_cast<Cached<Structure>*> (firstCached)) structure = std::move (*cachedStructure), Uncache (*cachedStructure); else (this->*parse) (structure);
}

void Context::ParseCached (const Symbol symbol)
{
	if (IsCached (symbol)) Uncache (*firstCached); else Parse (symbol);
}

void Context::ParseCached (const Symbol symbol, const Symbol alternative)
{
	if (IsCached (symbol, alternative)) Uncache (*firstCached); else Parse (symbol, alternative);
}

template <typename Structure>
inline void Context::ParseIfCached (Structure*& structure)
{
	ParseIf (IsCached<Structure> (), structure, &Context::ParseCached);
}

template <typename Structure>
inline void Context::ParseIfCachedOr (const bool condition, Structure*& structure)
{
	ParseIf (IsCached<Structure> () || condition, structure, &Context::ParseCached);
}

template <typename Structure>
void Context::Parse (List<Structure>& list)
{
	do Parse (list.emplace_back ()); while (Skip (Comma));
}

template <typename Structure>
inline void Context::Parse (Packed<Structure>& structure)
{
	Parse (static_cast<Structure&> (structure)); structure.isPacked = Skip (Ellipsis);
}

template <typename Structure>
inline void Context::Parse (Packed<Structure>& structure, void (Context::*const parse) (Structure&))
{
	(this->*parse) (structure); structure.isPacked = Skip (Ellipsis);
}

template <typename Structure>
inline void Context::Locate (Structure& structure)
{
	structure.location = firstCached ? firstCached->location : current.location;
}

template <typename Structure>
inline void Context::Model (Structure& structure, const typename Structure::Model model)
{
	structure.model = model; if (!structure.location.source) Locate (structure);
}

bool Context::IsCurrent (ConstructorCache& cache)
{
	assert (!IsCached (cache.identifier)); assert (!IsCached (cache.leftParen));
	if (!IsCurrent (Lexer::Identifier, DoubleColon)) return false;
	Parse (cache.identifier); if (!IsTypeName (cache.identifier)) return false;
	if (IsAttribute (current.symbol)) Parse (cache.attributes); if (!IsCurrent (LeftParen)) return false;
	Parse (cache.leftParen); if (IsCurrent (RightParen)) return true;
	const Hideout identifier {cache.identifier}, leftParen {cache.leftParen};
	return IsCurrent (cache.typeSpecifier);
}

bool Context::IsCurrent (TypeSpecifierCache& cache)
{
	if (IsCachedTypeName () || IsTypeSpecifier (current.symbol)) return true;
	assert (!IsCached (cache.identifier)); assert (!IsCached (cache.specifier));
	if (IsCurrent (Decltype) && !IsCached (DoubleColon)) Parse (cache.specifier);
	if (IsCached (cache.specifier) ? !IsCurrent (DoubleColon) && !IsCached (DoubleColon) : IsTypeSpecifier (current.symbol)) return true;
	if (IsCached (cache.specifier) || IsCurrent (Lexer::Identifier, DoubleColon)) Parse (cache.identifier);
	return IsCached (cache.identifier) && IsTypeName (cache.identifier);
}

bool Context::IsCurrent (ParenthesizedTypeIdentifierCache& cache)
{
	Parse (cache.leftParen); const Hideout leftParen {cache.leftParen};
	return IsCurrent (cache.typeIdentifier);
}

bool Context::IsCurrent (TypeIdentifierCache& cache)
{
	if (!IsCurrent (cache.typeSpecifier)) return false; Parse (cache.specifier);
	return !IsCurrent (LeftParen) && !IsCurrent (LeftBrace, LessPercent) || IsCurrent (cache.abstractDeclarator);
}

bool Context::IsCurrent (AbstractDeclaratorCache& cache)
{
	if (IsCurrentPointer (cache)) return true;
	if (IsCurrentReference (cache)) return true;
	if (IsCurrentParenthesized (cache)) return true;
	return false;
}

bool Context::IsCurrentParenthesized (AbstractDeclaratorCache& cache)
{
	if (!IsCurrent (LeftParen)) return false;
	Parse (cache.leftParen); if (IsCurrent (RightParen)) return true;
	const Hideout leftParen {cache.leftParen};
	return IsCurrent (cache.declarator);
}

bool Context::IsCurrentPointer (AbstractDeclaratorCache& cache)
{
	if (!IsCurrent (Asterisk)) return false; Parse (cache.asterisk);
	if (IsAttribute (current.symbol)) return true;
	if (IsConstVolatileQualifier (current.symbol)) return true;
	if (IsCurrent (RightParen)) return true;
	const Hideout asterisk {cache.asterisk};
	return IsCurrent (cache.declarator);
}

bool Context::IsCurrentReference (AbstractDeclaratorCache& cache)
{
	if (!IsCurrent (Ampersand, Bitand)) return false; Parse (cache.ampersand);
	if (IsAttribute (current.symbol)) return true;
	if (IsCurrent (RightParen)) return true;
	const Hideout ampersand {cache.ampersand};
	return IsCurrent (cache.declarator);
}

bool Context::IsCurrent (DeclarationCache& cache)
{
	if (IsCurrent (Asm) || IsCurrent (Namespace) || IsCurrent (Using) || IsCurrent (StaticAssert) || IsCurrent (DoubleLeftBracket)) return true;
	if (IsDeclarationSpecifier (current.symbol) && !IsTypeSpecifier (current.symbol)) return true;
	if (!IsCurrent (cache.typeSpecifier)) return false; Parse (cache.specifier, &Context::ParseDefining);
	if (IsDefinition (cache.specifier) || !IsCurrent (LeftParen)) return true;
	return IsCurrent (cache.initDeclarator);
}

bool Context::IsCurrent (InitDeclaratorCache& cache)
{
	if (!IsCurrent (cache.declarator)) return false;
	if (IsCurrent (Semicolon)) return true;
	if (!IsCurrent (Comma)) return false;
	Parse (cache.comma); return IsCurrent (cache.initDeclarator);
}

bool Context::IsCurrent (DeclaratorCache& cache)
{
	if (IsCurrentName (cache)) return true;
	if (IsCurrentPointer (cache)) return true;
	if (IsCurrentReference (cache)) return true;
	if (IsCurrentParenthesized (cache)) return true;
	return false;
}

bool Context::IsCurrentName (DeclaratorCache& cache)
{
	if (!IsIdentifier (current.symbol)) return false;
	Parse (cache.identifier); return true;
}

bool Context::IsCurrentParenthesized (DeclaratorCache& cache)
{
	if (!IsCurrent (LeftParen)) return false;
	Parse (cache.leftParen); if (IsCurrent (RightParen)) return false;
	if (!IsCurrent (cache.declarator)) return false;
	if (!IsCurrent (RightParen)) return false;
	Parse (cache.rightParen); return true;
}

bool Context::IsCurrentPointer (DeclaratorCache& cache)
{
	if (!IsCurrent (Asterisk)) return false; Parse (cache.asterisk);
	if (IsAttribute (current.symbol)) return true;
	if (IsConstVolatileQualifier (current.symbol)) return true;
	return IsCurrent (cache.declarator);
}

bool Context::IsCurrentReference (DeclaratorCache& cache)
{
	if (!IsCurrent (Ampersand, Bitand)) return false; Parse (cache.ampersand);
	if (IsAttribute (current.symbol)) return true;
	return IsCurrent (cache.declarator);
}

template <typename StructureCache>
bool Context::IsCurrent (std::unique_ptr<StructureCache>& cache)
{
	cache = std::make_unique<StructureCache> (); return IsCurrent (*cache);
}

bool Context::IsCurrentDeclarator (void (Context::*const parse) (Declarator&))
{
	if (parse == &Context::ParseNoPtr) return true;
	if (parse == &Context::ParseNoPtrNew) return IsCurrent (LeftBracket, LessColon);
	if (parse == static_cast<void (Context::*) (Declarator&)> (&Context::ParseConversion)) return IsPointerOperator (current.symbol);
	return IsAbstractDeclarator (current.symbol);
}

void Context::Parse ()
{
	if (!IsCurrent (Eof)) Parse (translationUnit.declarations); Expect (Eof); FinalizeChecks ();
}

void Context::ParsePrimary (Expression& expression)
{
	if (IsCurrent (Nullptr)) ParseLiteral (expression);
	else if (IsCurrent (True, False)) ParseLiteral (expression);
	else if (IsString (current.symbol)) ParseStringLiteral (expression);
	else if (IsLiteral (current.symbol)) ParseLiteral (expression);
	else if (IsCurrent (This)) ParseThis (expression);
	else if (IsCurrent (LeftParen)) ParseParenthesized (expression);
	else if (IsIdentifier (current.symbol)) ParseIdentifier (expression);
	else if (IsCurrent (LeftBracket, LessColon)) ParseLambda (expression);
	else EmitError (current, Format ("encountered %0 instead of expression", current));
}

void Context::ParseLiteral (Expression& expression)
{
	Model (expression, Expression::Literal);
	expression.literal.token = current; SkipCurrent (); Check (expression);
}

void Context::ParseStringLiteral (Expression& expression)
{
	Model (expression, Expression::StringLiteral);
	Parse (expression.stringLiteral, &Context::ParseUserDefined); Check (expression);
}

void Context::Parse (StringLiteral& literal)
{
	Locate (literal); if (!IsString (current.symbol)) Expect (NarrowString);
	literal.symbol = GetString (current.symbol); literal.suffix = current.suffix;
	do literal.tokens.push_back (current), SkipCurrent (); while (IsString (current.symbol));
	for (auto& token: literal.tokens)
		if (token.symbol == NarrowString || token.symbol == RawNarrowString) continue;
		else if (literal.symbol == NarrowString) literal.symbol = GetString (token.symbol);
		else if (GetString (token.symbol) != literal.symbol) EmitError (token, Format ("concatenating %0 with %1", literal.symbol, GetString (token.symbol)));
}

void Context::ParseUserDefined (StringLiteral& literal)
{
	Parse (literal);
	for (auto& token: literal.tokens)
		if (!HasStringSuffix (token)) continue; else if (!literal.suffix) literal.suffix = token.suffix;
		else if (token.suffix != literal.suffix) EmitError (token, Format ("concatenating user-defined %0s with differing suffixes '%1' and '%2'", literal.symbol, *literal.suffix, *token.suffix));
}

void Context::ParsePlain (StringLiteral& literal)
{
	Parse (literal);
	for (auto& token: literal.tokens)
		if (HasStringSuffix (token)) EmitError (token, "encountered string literal with suffix");
}

void Context::ParseThis (Expression& expression)
{
	Model (expression, Expression::This); Parse (This); Check (expression);
}

void Context::ParseParenthesized (Expression& expression)
{
	Model (expression, Expression::Parenthesized); ParseCached (LeftParen);
	Parse (expression.parenthesized.expression); Parse (RightParen); Check (expression);
}

void Context::ParseIdentifier (Expression& expression)
{
	Model (expression, Expression::Identifier);
	Parse (expression.identifier.identifier, &Context::ParseCached); Check (expression);
}

void Context::Parse (Identifier& identifier)
{
	ParseIf (IsCached (DoubleColon) || IsCached<DecltypeSpecifier> () || IsCurrent (DoubleColon) || IsCurrent (Decltype), identifier.nestedNameSpecifier);
	ParseUnqualified (identifier);
	while (IsCurrent (DoubleColon) && IsScopeName (identifier))
	{
		CachedToken<DoubleColon> doubleColon; Parse (doubleColon);
		if (IsIdentifier (current.symbol)) ParseQualified (identifier); else return RestoreCachedToken ();
	}
}

void Context::ParseUnqualified (Identifier& identifier)
{
	if (IsCurrent (Lexer::Operator)) ParseOperator (identifier);
	else if (IsCurrent (Tilde)) ParseDestructor (identifier);
	else ParseName (identifier);
	if (IsCurrent (Less) && IsTemplateName (identifier)) ParseTemplate (identifier);
}

void Context::ParseName (Identifier& identifier)
{
	Model (identifier, Identifier::Name); Expect (Lexer::Identifier);
	identifier.name.identifier = current.identifier; SkipCurrent ();
}

void Context::ParseDestructor (Identifier& identifier)
{
	Model (identifier, Identifier::Destructor); Parse (Tilde);
	if (IsCurrent (Decltype)) Parse (identifier.destructor.specifier, &Context::ParseDecltype);
	else Parse (identifier.destructor.specifier, &Context::ParseTypeName); Check (identifier);
}

void Context::ParseQualified (Identifier& identifier)
{
	Parse (identifier.nestedNameSpecifier, &Context::ParseNested, translationUnit.Create<Identifier> (identifier));
	Locate (identifier); ParseUnqualified (identifier);
}

void Context::Parse (NestedNameSpecifier& specifier)
{
	if (IsCached (DoubleColon)) ParseGlobal (specifier);
	else if (IsCached<DecltypeSpecifier> ()) ParseDecltype (specifier);
	else if (IsCached<Identifier> ()) ParseName (specifier);
	else if (IsCurrent (DoubleColon)) ParseGlobal (specifier);
	else if (IsCurrent (Decltype)) ParseDecltype (specifier);
	else ParseName (specifier);
}

void Context::ParseName (NestedNameSpecifier& specifier)
{
	Model (specifier, NestedNameSpecifier::Name); Parse (specifier.name.identifier, &Context::ParseCached);
	Parse (DoubleColon); specifier.name.isTemplate = Skip (Template); Check (specifier);
}

void Context::ParseGlobal (NestedNameSpecifier& specifier)
{
	Model (specifier, NestedNameSpecifier::Global); ParseCached (DoubleColon); Check (specifier);
}

void Context::ParseDecltype (NestedNameSpecifier& specifier)
{
	Model (specifier, NestedNameSpecifier::Decltype); ParseCached (specifier.decltype_.specifier); Expect (DoubleColon); Check (specifier);
}

void Context::ParseNested (NestedNameSpecifier& specifier, Identifier& identifier)
{
	Model (specifier, NestedNameSpecifier::Name); specifier.name.identifier = &identifier;
	ParseCached (DoubleColon); specifier.name.isTemplate = Skip (Template); Check (specifier);
}

void Context::ParseLambda (Expression& expression)
{
	Model (expression, Expression::Lambda); Parse (LeftBracket, LessColon);
	CachedToken<Ampersand, Bitand> ampersand; ParseIf (IsCurrent (Equal) || Skip (ampersand) && !IsCurrent (Lexer::Identifier), expression.lambda.default_);
	ParseIf (expression.lambda.default_ ? Skip (Comma) : !IsCurrent (RightBracket, ColonGreater), expression.lambda.captures);
	Parse (RightBracket, ColonGreater); ParseIf (IsCurrent (LeftParen), expression.lambda.declarator);
	Parse (expression.lambda.block); Check (expression);
}

void Context::Parse (CaptureDefault& default_)
{
	if (SkipCached (Ampersand, Bitand)) default_ = CaptureDefault::ByReference; else Parse (Equal), default_ = CaptureDefault::ByValue;
}

void Context::Parse (Capture& capture)
{
	capture.byReference = SkipCached (Ampersand, Bitand); ParseIf (capture.byReference || !Skip (This), capture.identifier);
	ParseIf (capture.identifier && (IsCurrent (Equal, LeftParen) || IsCurrent (LeftBrace, LessPercent)), capture.initializer);
}

void Context::Parse (LambdaDeclarator& declarator)
{
	Parse (LeftParen); Parse (declarator.parameterDeclarations); Parse (RightParen);
	ParseIf (IsDeclarationSpecifier (current.symbol), declarator.specifiers);
	ParseIf (IsCurrent (Noexcept, Throw), declarator.noexceptSpecifier);
	ParseIf (IsAttribute (current.symbol), declarator.attributes);
	ParseIf (IsCurrent (Arrow), declarator.trailingReturnType);
}

void Context::ParseBinary (Expression& expression, void (Context::*const parse) (Expression&))
{
	translationUnit.Create (expression.binary.left, expression); Locate (expression);
	Model (expression, Expression::Binary); Parse (expression.binary.operator_);
	Parse (expression.binary.right, parse); Check (expression);
}

void Context::ParsePostfixed (Expression& expression)
{
	if (IsCached (LeftParen)) ParseParenthesized (expression);
	else if (IsCached<Identifier> ()) ParseIdentifier (expression);
	else if (IsCached<TypeSpecifier> ()) ParseConstructorCall (expression);
	else if (IsCached (DoubleColon) || IsNestedNameSpecifier (current.symbol) || IsTypeSpecifier (current.symbol)) ParseIdentifierOrConstructorCall (expression);
	else if (IsCurrent (Typename)) ParseConstructorCall (expression);
	else if (IsCurrent (DynamicCast)) ParseCast (expression, Expression::DynamicCast);
	else if (IsCurrent (StaticCast)) ParseCast (expression, Expression::StaticCast);
	else if (IsCurrent (ReinterpretCast)) ParseCast (expression, Expression::ReinterpretCast);
	else if (IsCurrent (ConstCast)) ParseCast (expression, Expression::ConstCast);
	else if (IsCurrent (Typeid)) ParseTypeid (expression);
	else ParsePrimary (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (LeftBracket, LessColon) || IsCurrent (LeftParen) || IsCurrent (Dot, Arrow) || IsCurrent (DoublePlus, DoubleMinus))
		if (IsCurrent (LeftBracket, LessColon)) ParseSubscript (expression);
		else if (IsCurrent (LeftParen)) ParseFunctionCall (expression);
		else if (IsCurrent (Dot, Arrow)) ParseMemberAccess (expression);
		else if (IsCurrent (DoublePlus, DoubleMinus)) ParsePostfix (expression);
}

void Context::ParseSubscript (Expression& expression)
{
	translationUnit.Create (expression.subscript.left, expression);
	Model (expression, Expression::Subscript); Locate (expression); Parse (LeftBracket, LessColon);
	Parse (expression.subscript.right, &Context::ParseOptionallyBraced); Parse (RightBracket, ColonGreater); Check (expression);
}

void Context::ParseFunctionCall (Expression& expression)
{
	translationUnit.Create (expression.functionCall.expression, expression);
	Model (expression, Expression::FunctionCall); Locate (expression); Parse (LeftParen);
	ParseIf (!IsCurrent (RightParen), expression.functionCall.arguments);
	Parse (RightParen); Check (expression);
}

void Context::ParseIdentifierOrConstructorCall (Expression& expression)
{
	TypeSpecifierCache typeSpecifier;
	if (IsCurrent (typeSpecifier)) ParseConstructorCall (expression); else ParseIdentifier (expression);
}

void Context::ParseConstructorCall (Expression& expression)
{
	if (IsCached<TypeSpecifier> ()) Parse (expression.constructorCall.specifier, &Context::ParseCached);
	else if (IsCurrent (Typename)) Parse (expression.constructorCall.specifier, &Context::ParseTypename);
	else Parse (expression.constructorCall.specifier, &Context::ParseSimple);
	if (IsCurrent (LeftBrace, LessPercent)) return ParseBracedConstructorCall (expression);
	Model (expression, Expression::ConstructorCall); ParseCached (LeftParen);
	ParseIf (!IsCurrent (RightParen), expression.constructorCall.expressions);
	ParseCached (RightParen); Check (expression);
}

void Context::ParseBracedConstructorCall (Expression& expression)
{
	Model (expression, Expression::BracedConstructorCall);
	Parse (expression.bracedConstructorCall.expression, &Context::ParseBraced); Check (expression);
}

void Context::ParseMemberAccess (Expression& expression)
{
	assert (IsCurrent (Dot, Arrow)); translationUnit.Create (expression.memberAccess.expression, expression);
	Model (expression, Expression::MemberAccess); Locate (expression); expression.memberAccess.symbol = current.symbol; SkipCurrent ();
	expression.memberAccess.isTemplate = Skip (Template); Parse (expression.memberAccess.identifier); Check (expression);
}

void Context::ParsePostfix (Expression& expression)
{
	assert (IsCurrent (DoublePlus, DoubleMinus)); translationUnit.Create (expression.postfix.expression, expression);
	Model (expression, Expression::Postfix); Locate (expression); Parse (expression.postfix.operator_); Check (expression);
}

void Context::ParseCast (Expression& expression, const Expression::Model model)
{
	assert (IsCast (current.symbol)); Model (expression, model);
	expression.cast.symbol = current.symbol; SkipCurrent (); Parse (Less);
	Parse (expression.cast.typeIdentifier); Parse (Greater); Parse (LeftParen);
	Parse (expression.cast.expression); Parse (RightParen); Check (expression);
}

void Context::ParseTypeid (Expression& expression)
{
	Locate (expression); Parse (Typeid); Parse (LeftParen); TypeIdentifierCache typeIdentifier;
	if (IsCurrent (typeIdentifier)) ParseTypeidType (expression); else ParseTypeidExpression (expression);
}

void Context::ParseTypeidExpression (Expression& expression)
{
	Model (expression, Expression::TypeidExpression); Parse (expression.typeidExpression.expression); Parse (RightParen); Check (expression);
}

void Context::ParseTypeidType (Expression& expression)
{
	Model (expression, Expression::TypeidType); Parse (expression.typeidType.typeIdentifier); Parse (RightParen); Check (expression);
}

void Context::Parse (Expressions& expressions)
{
	do ParseInitializerClause (expressions.emplace_back ()); while (Skip (Comma) && !IsCurrent (RightBrace, PercentGreater));
}

void Context::ParseUnary (Expression& expression)
{
	if (IsCached (Asterisk)) ParseIndirection (expression);
	else if (IsCached (Ampersand, Bitand)) ParseAddressof (expression);
	else if (IsCached (LeftParen) || IsCached<Identifier> () || IsCached<TypeSpecifier> ()) ParsePostfixed (expression);
	else if (IsCurrent (DoublePlus, DoubleMinus)) ParsePrefix (expression);
	else if (IsCurrent (Asterisk)) ParseIndirection (expression);
	else if (IsCurrent (Ampersand, Bitand)) ParseAddressof (expression);
	else if (IsUnaryOperator (current.symbol)) ParseUnaryOperator (expression);
	else if (IsCurrent (Sizeof)) ParseSizeof (expression);
	else if (IsCurrent (Alignof)) ParseAlignof (expression);
	else if (IsCurrent (Noexcept)) ParseNoexcept (expression);
	else if (IsCurrent (New)) ParseNew (expression);
	else if (IsCurrent (Delete)) ParseDelete (expression);
	else if (IsCurrent (DoubleColon)) ParseDoubleColon (expression);
	else if (IsCurrent (Typetrait)) ParseTypetrait (expression);
	else ParsePostfixed (expression);
}

void Context::ParsePrefix (Expression& expression)
{
	assert (IsCurrent (DoublePlus, DoubleMinus)); Model (expression, Expression::Prefix);
	Parse (expression.prefix.operator_); Parse (expression.prefix.expression, &Context::ParseCast); Check (expression);
}

void Context::ParseIndirection (Expression& expression)
{
	Model (expression, Expression::Indirection); ParseCached (Asterisk);
	Parse (expression.indirection.expression, &Context::ParseCast); Check (expression);
}

void Context::ParseAddressof (Expression& expression)
{
	Model (expression, Expression::Addressof); ParseCached (Ampersand, Bitand);
	Parse (expression.addressof.expression, &Context::ParseCast); Check (expression);
}

void Context::ParseUnaryOperator (Expression& expression)
{
	assert (IsUnaryOperator (current.symbol));
	Model (expression, Expression::Unary); Parse (expression.unary.operator_);
	Parse (expression.unary.operand, &Context::ParseCast); Check (expression);
}

void Context::ParseSizeof (Expression& expression)
{
	Locate (expression); Parse (Sizeof);
	if (IsCurrent (Ellipsis)) return ParseSizeofPack (expression);
	if (!IsCurrent (LeftParen)) return ParseSizeofExpression (expression);
	ParenthesizedTypeIdentifierCache parenthesizedTypeIdentifier;
	if (IsCurrent (parenthesizedTypeIdentifier)) ParseSizeofType (expression);
	else ParseSizeofExpression (expression);
}

void Context::ParseSizeofExpression (Expression& expression)
{
	Model (expression, Expression::SizeofExpression);
	Parse (expression.sizeofExpression.expression, &Context::ParseUnary); Check (expression);
}

void Context::ParseSizeofType (Expression& expression)
{
	Model (expression, Expression::SizeofType); ParseCached (LeftParen);
	Parse (expression.sizeofType.typeIdentifier); Parse (RightParen); Check (expression);
}

void Context::ParseSizeofPack (Expression& expression)
{
	Model (expression, Expression::SizeofPack); Parse (Ellipsis); Parse (LeftParen);
	Parse (expression.sizeofPack.identifier, &Context::ParseName); Parse (RightParen); Check (expression);
}

void Context::ParseAlignof (Expression& expression)
{
	Model (expression, Expression::Alignof); Parse (Alignof); Parse (LeftParen);
	Parse (expression.alignof_.typeIdentifier); Parse (RightParen); Check (expression);
}

void Context::ParseDoubleColon (Expression& expression)
{
	CachedToken<DoubleColon> doubleColon; Parse (doubleColon);
	if (IsCurrent (New)) ParseNew (expression);
	else if (IsCurrent (Delete)) ParseDelete (expression);
	else ParsePostfixed (expression);
}

void Context::ParseTypetrait (Expression& expression)
{
	Model (expression, Expression::Typetrait); Parse (Typetrait); Parse (expression.typetrait.stringLiteral, &Context::ParsePlain);
	Parse (LeftParen); Parse (expression.typetrait.typeIdentifier); Parse (RightParen); Check (expression);
}

void Context::ParseNew (Expression& expression)
{
	Model (expression, Expression::New); expression.new_.qualified = SkipCached (DoubleColon);
	Parse (New); ParenthesizedTypeIdentifierCache parenthesizedTypeIdentifier;
	ParseIf (IsCurrent (LeftParen) && !IsCurrent (parenthesizedTypeIdentifier) && SkipCached (LeftParen), expression.new_.placement);
	if (expression.new_.placement) Parse (RightParen); expression.new_.parenthesized = SkipCached (LeftParen);
	if (expression.new_.parenthesized) Parse (expression.new_.typeIdentifier), Parse (RightParen); else Parse (expression.new_.typeIdentifier, &Context::ParseNew);
	ParseIf (IsCurrent (LeftParen) || IsCurrent (LeftBrace, LessPercent), expression.new_.initializer, &Context::ParseNew); Check (expression);
}

void Context::ParseNew (TypeIdentifier& identifier)
{
	Parse (identifier.specifiers);
	ParseIf (IsPointerOperator (current.symbol) || IsCurrent (LeftBracket, LessColon), identifier.declarator, &Context::ParseNew);
	Check (identifier);
}

void Context::ParseNew (Declarator& declarator)
{
	ParsePtr (declarator, &Context::ParseNoPtrNew);
}

void Context::ParseNoPtrNew (Declarator& declarator)
{
	Model (declarator, Declarator::Array); Reset (declarator.array.declarator);
	Parse (LeftBracket, LessColon); Parse (declarator.array.expression); Parse (RightBracket, ColonGreater);
	ParseIf (IsAttribute (current.symbol), declarator.array.attributes);
	while (IsCurrent (LeftBracket, LessColon)) ParseNewArray (declarator);
}

void Context::ParseNewArray (Declarator& declarator)
{
	translationUnit.Create (declarator.array.declarator, declarator); Model (declarator, Declarator::Array);
	Locate (declarator); Parse (LeftBracket, LessColon); Parse (declarator.array.expression, &Context::ParseConstant);
	Parse (RightBracket, ColonGreater); ParseIf (IsAttribute (current.symbol), declarator.array.attributes);
}

void Context::ParseNew (Initializer& initializer)
{
	if (IsCurrent (LeftBrace, LessPercent)) return ParseBraced (initializer);
	Locate (initializer); Parse (LeftParen); if (!IsCurrent (RightParen)) Parse (initializer.expressions); Parse (RightParen);
}

void Context::ParseDelete (Expression& expression)
{
	Model (expression, Expression::Delete); expression.delete_.qualified = SkipCached (DoubleColon);
	Parse (Delete); expression.delete_.bracketed = Skip (LeftBracket, LessColon);
	if (expression.delete_.bracketed) Parse (RightBracket, ColonGreater);
	Parse (expression.delete_.expression, &Context::ParseCast); Check (expression);
}

void Context::ParseNoexcept (Expression& expression)
{
	Model (expression, Expression::Noexcept); Parse (Noexcept); Parse (LeftParen);
	Parse (expression.noexcept_.expression); Parse (RightParen); Check (expression);
}

void Context::ParseCast (Expression& expression)
{
	if (IsCached<Identifier> () || IsCached<TypeSpecifier> ()) return ParsePostfixed (expression);
	if (!IsCurrent (LeftParen)) return ParseUnary (expression);
	ParenthesizedTypeIdentifierCache parenthesizedTypeIdentifier;
	if (!IsCurrent (parenthesizedTypeIdentifier)) return ParsePostfixed (expression);
	Model (expression, Expression::Cast); ParseCached (LeftParen); Parse (expression.cast.typeIdentifier);
	Parse (RightParen); Parse (expression.cast.expression, &Context::ParseCast); Check (expression);
}

void Context::ParsePointerToMember (Expression& expression)
{
	ParseCast (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (DotAsterisk, ArrowAsterisk)) ParseMemberIndirection (expression);
}

void Context::ParseMemberIndirection (Expression& expression)
{
	assert (IsCurrent (DotAsterisk, ArrowAsterisk)); translationUnit.Create (expression.memberIndirection.expression, expression);
	Model (expression, Expression::MemberIndirection); Locate (expression); expression.memberIndirection.symbol = current.symbol; SkipCurrent ();
	Parse (expression.memberIndirection.member, &Context::ParseCast); Check (expression);
}

void Context::ParseMultiplicative (Expression& expression)
{
	ParsePointerToMember (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (Asterisk) || IsCurrent (Slash) || IsCurrent (Percent)) ParseBinary (expression, &Context::ParsePointerToMember);
}

void Context::ParseAdditive (Expression& expression)
{
	ParseMultiplicative (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (Plus) || IsCurrent (Minus)) ParseBinary (expression, &Context::ParseMultiplicative);
}

void Context::ParseShift (Expression& expression)
{
	ParseAdditive (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (DoubleLess) || IsCurrent (DoubleGreater)) ParseBinary (expression, &Context::ParseAdditive);
}

void Context::ParseRelational (Expression& expression)
{
	ParseShift (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (Less, Greater) || IsCurrent (LessEqual, GreaterEqual)) ParseBinary (expression, &Context::ParseShift);
}

void Context::ParseEquality (Expression& expression)
{
	ParseRelational (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (DoubleEqual) || IsCurrent (ExclamationMarkEqual, NotEq)) ParseBinary (expression, &Context::ParseRelational);
}

void Context::ParseAnd (Expression& expression)
{
	ParseEquality (expression);
	while (IsCurrent (Ampersand, Bitand)) ParseBinary (expression, &Context::ParseEquality);
}

void Context::ParseExclusiveOr (Expression& expression)
{
	ParseAnd (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (Caret, Xor)) ParseBinary (expression, &Context::ParseAnd);
}

void Context::ParseInclusiveOr (Expression& expression)
{
	ParseExclusiveOr (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (Bar, Bitor)) ParseBinary (expression, &Context::ParseExclusiveOr);
}

void Context::ParseLogicalAnd (Expression& expression)
{
	ParseInclusiveOr (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (DoubleAmpersand, And)) ParseBinary (expression, &Context::ParseInclusiveOr);
}

void Context::ParseLogicalOr (Expression& expression)
{
	ParseLogicalAnd (expression); if (IsCached (RightParen)) return;
	while (IsCurrent (DoubleBar, Or)) ParseBinary (expression, &Context::ParseLogicalAnd);
}

void Context::ParseConditional (Expression& expression)
{
	if (IsCached (RightParen) || !IsCurrent (QuestionMark)) return;
	translationUnit.Create (expression.conditional.condition, expression); Locate (expression);
	Model (expression, Expression::Conditional); Parse (QuestionMark); Parse (expression.conditional.left);
	Parse (Colon); Parse (expression.conditional.right, &Context::ParseAssignment); Check (expression);
}

void Context::ParseThrow (Expression& expression)
{
	Model (expression, Expression::Throw); Parse (Throw);
	ParseIf (!IsExpressionDelimiter (current.symbol), expression.throw_.expression); Check (expression);
}

void Context::ParseAssignment (Expression& expression)
{
	if (IsCached (RightParen)) return;
	if (IsCurrent (Throw)) return ParseThrow (expression); ParseLogicalOr (expression);
	if (!IsAssignmentOperator (current.symbol)) return ParseConditional (expression);
	translationUnit.Create (expression.assignment.left, expression); Locate (expression);
	Model (expression, Expression::Assignment); Parse (expression.assignment.operator_);
	Parse (expression.assignment.right, &Context::ParseAssignment); Check (expression);
}

void Context::Parse (Expression& expression)
{
	ParseAssignment (expression); if (IsCached (RightParen)) return;
	while (IsCached (Comma) || IsCurrent (Comma)) ParseComma (expression);
}

void Context::ParseComma (Expression& expression)
{
	translationUnit.Create (expression.comma.left, expression);
	Model (expression, Expression::Comma); Locate (expression); ParseCached (Comma);
	Parse (expression.comma.right, &Context::ParseAssignment); Check (expression);
}

void Context::ParseConstant (Expression& expression)
{
	ParseLogicalOr (expression); ParseConditional (expression);
}

void Context::Parse (Statement& statement)
{
	Cached<AttributeSpecifiers> attributes; if (IsAttribute (current.symbol)) Parse (attributes);
	if (IsCurrent (Lexer::Identifier)) ParseLabel (statement);
	else if (IsCurrent (Case)) ParseCase (statement);
	else if (IsCurrent (Default)) ParseDefault (statement);
	else if (IsCurrent (Semicolon)) ParseNull (statement);
	else if (IsCurrent (LeftBrace, LessPercent)) ParseCompound (statement);
	else if (IsCurrent (If)) ParseIf (statement);
	else if (IsCurrent (Switch)) ParseSwitch (statement);
	else if (IsCurrent (While)) ParseWhile (statement);
	else if (IsCurrent (Do)) ParseDo (statement);
	else if (IsCurrent (For)) ParseFor (statement);
	else if (IsCurrent (Break)) ParseBreak (statement);
	else if (IsCurrent (Continue)) ParseContinue (statement);
	else if (IsCurrent (Return)) ParseReturn (statement);
	else if (IsCurrent (CoReturn)) ParseCoReturn (statement);
	else if (IsCurrent (Goto)) ParseGoto (statement);
	else if (IsCurrent (Try)) ParseTry (statement);
	else ParseDeclarationOrExpression (statement);
}

void Context::ParseInit (Statement& statement)
{
	if (IsCurrent (Semicolon)) return ParseNull (statement);
	DeclarationCache declaration; if (!IsCurrent (declaration)) return ParseExpression (statement);
	Model (statement, Statement::Declaration); Reset (statement.attributes); Parse (statement.declaration, &Context::ParseSimple); Check (statement);
}

void Context::Parse (Condition& condition)
{
	DeclarationCache declaration;
	if (IsCurrent (declaration)) ParseDeclaration (condition);
	else ParseExpression (condition);
}

void Context::ParseExpression (Condition& condition)
{
	Parse (condition.expression); Reset (condition.declaration);
}

void Context::ParseDeclaration (Condition& condition)
{
	Parse (condition.declaration, &Context::ParseCondition); Check (condition);
}

void Context::ParseCondition (Declaration& declaration)
{
	Model (declaration, Declaration::Condition); ParseIf (IsAttribute (current.symbol), declaration.condition.attributes);
	Parse (declaration.condition.specifiers); Parse (declaration.condition.declarator); Check (declaration);
	Parse (declaration.condition.initializer, &Context::ParseBracedOrAssignment); FinalizeCheck (declaration);
}

void Context::ParseLabel (Statement& statement)
{
	Cached<Identifier> identifier; Parse (identifier);
	if (!IsCurrent (Colon) || !IsName (identifier)) return ParseDeclarationOrExpression (statement);
	Model (statement, Statement::Label); ParseIfCached (statement.attributes);
	Parse (statement.label.identifier, &Context::ParseCached); Parse (Colon); Check (statement);
}

void Context::ParseCase (Statement& statement)
{
	Model (statement, Statement::Case); ParseIfCached (statement.attributes); Parse (Case);
	Parse (statement.case_.label, &Context::ParseConstant); Parse (Colon); Check (statement);
}

void Context::ParseDefault (Statement& statement)
{
	Model (statement, Statement::Default); ParseIfCached (statement.attributes); Parse (Default); Parse (Colon); Check (statement);
}

void Context::ParseNull (Statement& statement)
{
	Model (statement, Statement::Null); ParseIfCached (statement.attributes); Parse (Semicolon); Check (statement);
}

void Context::ParseExpression (Statement& statement)
{
	Model (statement, Statement::Expression); ParseIfCached (statement.attributes);
	Parse (statement.expression); Parse (Semicolon); Check (statement);
}

void Context::ParseCompound (Statement& statement)
{
	Model (statement, Statement::Compound); ParseIfCached (statement.attributes);
	Check (statement); Enter (statement); Parse (statement.compound.block); Leave (statement);
}

void Context::Parse (StatementBlock& block)
{
	Parse (LeftBrace, LessPercent); Enter (block);
	while (!IsCurrent (RightBrace, PercentGreater) && !IsCurrent (Eof)) ParseStatement (block);
	Parse (RightBrace, PercentGreater); Leave (block);
}

void Context::ParseStatement (StatementBlock& block)
{
	do Parse (block.statements.emplace_back (block)); while (IsLabeled (block.statements.back ()));
}

void Context::ParseIf (Statement& statement)
{
	Model (statement, Statement::If); ParseIfCached (statement.attributes);
	Enter (statement); Parse (If); statement.if_.isConstexpr = Skip (Constexpr);
	Parse (LeftParen); Parse (statement.if_.condition); Parse (RightParen); Check (statement);
	Parse (statement.if_.statement); ParseIf (Skip (Else), statement.if_.elseStatement); Leave (statement);
}

void Context::Parse (Substatement& statement)
{
	Cached<AttributeSpecifiers> attributes; if (IsAttribute (current.symbol)) Parse (attributes);
	Locate (statement); statement.isCompound = IsCurrent (LeftBrace, LessPercent);
	ParseIf (statement.isCompound && IsCached (attributes), statement.attributes, &Context::ParseCached); Check (statement);
	if (statement.isCompound) Parse (static_cast<StatementBlock&> (statement)); else Enter (statement), ParseStatement (statement), Leave (statement);
}

void Context::ParseSwitch (Statement& statement)
{
	Model (statement, Statement::Switch); ParseIfCached (statement.attributes); Enter (statement);
	Parse (Switch); Parse (LeftParen); Parse (statement.switch_.condition); Parse (RightParen);
	Check (statement); Parse (statement.switch_.statement); Leave (statement);
}

void Context::ParseWhile (Statement& statement)
{
	Model (statement, Statement::While); ParseIfCached (statement.attributes); Enter (statement);
	Parse (While); Parse (LeftParen); Parse (statement.while_.condition); Parse (RightParen);
	Check (statement); Parse (statement.while_.statement); Leave (statement);
}

void Context::ParseDo (Statement& statement)
{
	Model (statement, Statement::Do); ParseIfCached (statement.attributes); Enter (statement);
	Parse (Do); Parse (statement.do_.statement); Locate (statement); Parse (While);
	Parse (LeftParen); Parse (statement.do_.condition); Parse (RightParen);
	Parse (Semicolon); Check (statement); Leave (statement);
}

void Context::ParseFor (Statement& statement)
{
	Model (statement, Statement::For); ParseIfCached (statement.attributes); Enter (statement);
	Parse (For); Parse (LeftParen); Parse (statement.for_.initStatement, &Context::ParseInit);
	ParseIf (!IsCurrent (Semicolon), statement.for_.condition); Parse (Semicolon);
	ParseIf (!IsCurrent (RightParen), statement.for_.expression); Parse (RightParen);
	Check (statement); Parse (statement.for_.statement); Leave (statement);
}

void Context::ParseBreak (Statement& statement)
{
	Model (statement, Statement::Break); ParseIfCached (statement.attributes); Parse (Break); Parse (Semicolon); Check (statement);
}

void Context::ParseContinue (Statement& statement)
{
	Model (statement, Statement::Continue); ParseIfCached (statement.attributes); Parse (Continue); Parse (Semicolon); Check (statement);
}

void Context::ParseReturn (Statement& statement)
{
	Model (statement, Statement::Return); ParseIfCached (statement.attributes); Parse (Return);
	ParseIf (!IsCurrent (Semicolon), statement.return_.expression, &Context::ParseOptionallyBraced); Parse (Semicolon); Check (statement);
}

void Context::ParseCoReturn (Statement& statement)
{
	Model (statement, Statement::CoReturn); ParseIfCached (statement.attributes); Parse (CoReturn);
	ParseIf (!IsCurrent (Semicolon), statement.coReturn.expression, &Context::ParseOptionallyBraced); Parse (Semicolon); Check (statement);
}

void Context::ParseGoto (Statement& statement)
{
	Model (statement, Statement::Goto); ParseIfCached (statement.attributes); Parse (Goto);
	Parse (statement.goto_.identifier, &Context::ParseName); Parse (Semicolon); Check (statement);
}

void Context::ParseDeclaration (Statement& statement)
{
	Model (statement, Statement::Declaration); Reset (statement.attributes);
	if (IsCached<AttributeSpecifiers> ()) Parse (statement.declaration, &Context::ParseAttributedBlock);
	else Parse (statement.declaration, &Context::ParseBlock); Check (statement);
}

void Context::ParseDeclarationOrExpression (Statement& statement)
{
	DeclarationCache declaration;
	if (IsCurrent (declaration)) ParseDeclaration (statement);
	else ParseExpression (statement);
}

void Context::Parse (Declarations& declarations)
{
	do Parse (declarations.emplace_back ()); while (!IsCurrent (RightBrace, PercentGreater) && !IsCurrent (Eof));
}

void Context::Parse (Declaration& declaration)
{
	if (IsCurrent (Template)) ParseTemplateOrExplicit (declaration);
	else if (IsCurrent (Extern)) ParseExtern (declaration);
	else if (IsCurrent (Namespace)) ParseNamespace (declaration);
	else if (IsCurrent (Inline)) ParseInline (declaration);
	else if (IsCurrent (Semicolon)) ParseEmpty (declaration);
	else if (IsAttribute (current.symbol)) ParseAttribute (declaration);
	else ParseBlock (declaration);
}

void Context::ParseTemplateOrExplicit (Declaration& declaration)
{
	CachedToken<Template> template_; Parse (template_);
	if (!IsCurrent (Less)) return ParseExplicitInstantiation (declaration);
	CachedToken<Less> less; Hide (template_); Parse (less); Unhide (template_);
	if (IsCurrent (Greater)) ParseExplicitSpecialization (declaration);
	else ParseTemplate (declaration);
}

void Context::ParseExtern (Declaration& declaration)
{
	CachedToken<Extern> extern_; Parse (extern_);
	if (IsString (current.symbol)) ParseLinkageSpecification (declaration);
	else if (IsCurrent (Template)) ParseExplicitInstantiation (declaration);
	else ParseSimple (declaration);
}

void Context::ParseNamespace (Declaration& declaration)
{
	CachedToken<Namespace> namespace_; Parse (namespace_);
	if (IsAttribute (current.symbol) || IsCurrent (LeftBrace)) return ParseNamespaceDefinition (declaration);
	Cached<Identifier> identifier; Expect (Lexer::Identifier); Hide (namespace_); Parse (identifier); Unhide (namespace_);
	if (IsCurrent (Equal)) ParseNamespaceAliasDefinition (declaration);
	else ParseNamespaceDefinition (declaration);
}

void Context::ParseInline (Declaration& declaration)
{
	CachedToken<Inline> inline_; Parse (inline_);
	if (IsCurrent (Namespace)) ParseNamespaceDefinition (declaration);
	else ParseSimple (declaration);
}

void Context::ParseBlock (Declaration& declaration)
{
	if (IsCurrent (Asm)) ParseAsm (declaration);
	else if (IsCurrent (Namespace)) ParseNamespaceAliasDefinition (declaration);
	else if (IsCurrent (Using)) ParseUsingDirectiveOrAlias (declaration);
	else if (IsCurrent (StaticAssert)) ParseStaticAssertion (declaration);
	else if (IsCurrent (Enum)) ParseOpaqueEnum (declaration);
	else ParseSimple (declaration);
}

void Context::ParseUsingDirectiveOrAlias (Declaration& declaration)
{
	CachedToken<Using> using_; Parse (using_);
	if (IsCurrent (Namespace)) ParseUsingDirective (declaration);
	else RestoreCachedToken (), ParseUsingOrAlias (declaration);
}

void Context::ParseAttributedBlock (Declaration& declaration)
{
	assert (IsCached<AttributeSpecifiers> ());
	if (IsCurrent (Asm)) ParseAsm (declaration);
	else if (IsCurrent (Using)) ParseUsingDirective (declaration);
	else ParseSimple (declaration);
}

void Context::ParseAlias (Declaration& declaration)
{
	Model (declaration, Declaration::Alias); ParseCached (Using); Parse (declaration.alias.identifier, &Context::ParseCached);
	ParseIf (IsAttribute (current.symbol), declaration.alias.attributes); Parse (Equal);
	Parse (declaration.alias.typeIdentifier, &Context::ParseDefining); Parse (Semicolon); Check (declaration);
}

void Context::ParseSimple (Declaration& declaration)
{
	ParseIfCachedOr (IsAttribute (current.symbol) && !IsCached<TypeSpecifier> (), declaration.basic.attributes);
	if (!IsCurrent (Lexer::Identifier, DoubleColon) && !IsCurrent (LeftParen) && !IsDeclarationSpecifier (current.symbol) && !IsCached<EnumHead> () && !IsCached<TypeSpecifier> ())
		EmitError (current, Format ("encountered %0 instead of declaration", current));
	ConstructorCache constructor; Parse (declaration.basic.specifiers, constructor);
	if (IsCurrent (Semicolon) && !IsCached (LeftParen)) return Model (declaration, Declaration::Simple), Reset (declaration.simple.declarators), Parse (Semicolon), Check (declaration);
	Cached<Declarator> declarator; if (!IsCached (LeftParen)) Parse (declarator);
	if (IsCached (declarator) && IsFunctionBody (current.symbol) && IsFunctionDefinition (declarator)) return ParseFunctionDefinition (declaration);
	Model (declaration, Declaration::Simple); Enter (declaration); Parse (declaration.simple.declarators); Leave (declaration); Parse (Semicolon); Check (declaration);
}

void Context::ParseStaticAssertion (Declaration& declaration)
{
	Model (declaration, Declaration::StaticAssertion); Parse (StaticAssert);
	Parse (LeftParen); Parse (declaration.staticAssertion.expression, &Context::ParseConstant);
	ParseIf (Skip (Comma), declaration.staticAssertion.stringLiteral, &Context::ParsePlain);
	Parse (RightParen); Parse (Semicolon); Check (declaration);
}

void Context::ParseEmpty (Declaration& declaration)
{
	Model (declaration, Declaration::Empty); Parse (Semicolon); Check (declaration);
}

void Context::ParseAttribute (Declaration& declaration)
{
	Cached<AttributeSpecifiers> attributes; Parse (attributes); if (!IsCurrent (Semicolon)) return ParseAttributedBlock (declaration);
	Model (declaration, Declaration::Attribute); Parse (declaration.attribute.specifiers, &Context::ParseCached); Parse (Semicolon); Check (declaration);
}

void Context::Parse (DeclarationSpecifier& specifier)
{
	if (IsCached<Identifier> ()) ParseType (specifier);
	else if (IsCached<TypeSpecifier> ()) ParseType (specifier);
	else if (IsCached (Extern)) ParseStorageClass (specifier);
	else if (IsCached (Inline)) ParseInline (specifier);
	else if (IsStorageClass (current.symbol)) ParseStorageClass (specifier);
	else if (IsFunctionSpecifier (current.symbol)) ParseFunction (specifier);
	else if (IsCurrent (Friend)) ParseFriend (specifier);
	else if (IsCurrent (Typedef)) ParseTypedef (specifier);
	else if (IsCurrent (Constexpr)) ParseConstexpr (specifier);
	else if (IsCurrent (Inline)) ParseInline (specifier);
	else ParseType (specifier);
}

void Context::ParseFriend (DeclarationSpecifier& specifier)
{
	Model (specifier, DeclarationSpecifier::Friend); Parse (Friend);
}

void Context::ParseTypedef (DeclarationSpecifier& specifier)
{
	Model (specifier, DeclarationSpecifier::Typedef); Parse (Typedef);
}

void Context::ParseConstexpr (DeclarationSpecifier& specifier)
{
	Model (specifier, DeclarationSpecifier::Constexpr); Parse (Constexpr);
}

void Context::ParseInline (DeclarationSpecifier& specifier)
{
	Model (specifier, DeclarationSpecifier::Inline); ParseCached (Inline);
}

void Context::Parse (DeclarationSpecifiers& specifiers)
{
	do Parse (specifiers.emplace_back ()), Check (specifiers.back (), specifiers);
	while (RequiresType (specifiers) || IsDeclarationSpecifier (current.symbol));
	ParseIf (IsAttribute (current.symbol), specifiers.attributes); Check (specifiers);
}

void Context::Parse (DeclarationSpecifiers& specifiers, ConstructorCache& constructor)
{
	do if (!IsCached (Extern) && !IsCached (Inline) && !IsCached<TypeSpecifier> () && (IsCurrent (Tilde, Lexer::Operator) || IsCurrent (constructor))) break;
	else Parse (specifiers.emplace_back ()), Check (specifiers.back (), specifiers);
	while (RequiresType (specifiers) || IsDeclarationSpecifier (current.symbol));
	ParseIf (IsAttribute (current.symbol) && !IsCached (constructor.identifier), specifiers.attributes); Check (specifiers);
}

void Context::ParseStorageClass (DeclarationSpecifier& specifier)
{
	Model (specifier, DeclarationSpecifier::StorageClass);
	if (SkipCached (Extern)) specifier.storageClass.specifier = Extern;
	else specifier.storageClass.specifier = current.symbol, SkipCurrent ();
}

void Context::ParseFunction (DeclarationSpecifier& specifier)
{
	Model (specifier, DeclarationSpecifier::Function);
	specifier.function.specifier = current.symbol, SkipCurrent ();
}

void Context::ParseType (DeclarationSpecifier& specifier)
{
	Model (specifier, DeclarationSpecifier::Type); using Argument = void (Context::*) (TypeSpecifier&);
	Parse (specifier.type.specifier, static_cast<void (Context::*) (TypeSpecifier&, Argument)> (&Context::ParseCached), static_cast<Argument> (&Context::ParseDefining));
}

void Context::Parse (TypeSpecifier& specifier)
{
	if (IsClassKey (current.symbol)) ParseClass (specifier, true);
	else if (IsCurrent (Enum)) ParseEnum (specifier, true);
	else if (IsCurrent (Typename)) ParseTypename (specifier);
	else if (IsConstVolatileQualifier (current.symbol)) ParseConstVolatileQualifier (specifier);
	else ParseSimple (specifier);
}

void Context::ParseConstVolatileQualifier (TypeSpecifier& specifier)
{
	Model (specifier, TypeSpecifier::ConstVolatileQualifier);
	specifier.constVolatile.qualifier = current.symbol; Parse (Const, Volatile);
}

void Context::Parse (TypeSpecifiers& specifiers)
{
	do ParseCached (specifiers.emplace_back ()), Check (specifiers.back (), specifiers);
	while (RequiresType (specifiers) || IsTypeSpecifier (current.symbol));
	ParseIf (IsAttribute (current.symbol), specifiers.attributes); Check (specifiers);
}

void Context::ParseDefining (TypeSpecifier& specifier)
{
	if (IsCached<Identifier> ()) ParseTypeName (specifier);
	else if (IsCached<EnumHead> ()) ParseEnum (specifier, false);
	else if (IsClassKey (current.symbol)) ParseClass (specifier, false);
	else if (IsCurrent (Enum)) ParseEnum (specifier, false);
	else Parse (specifier);
}

void Context::ParseDefining (TypeSpecifiers& specifiers)
{
	do ParseDefining (specifiers.emplace_back ()), Check (specifiers.back (), specifiers);
	while (RequiresType (specifiers) || IsTypeSpecifier (current.symbol));
	ParseIf (IsAttribute (current.symbol), specifiers.attributes); Check (specifiers);
}

void Context::ParseSimple (TypeSpecifier& specifier)
{
	if (IsCached<Identifier> () || IsCurrent (Lexer::Identifier, DoubleColon)) return ParseTypeName (specifier);
	if (IsCached<DecltypeSpecifier> () || IsCurrent (Decltype)) return ParseDecltype (specifier);
	if (!IsSimpleTypeSpecifier (current.symbol)) EmitError (current, Format ("encountered %0 instead of type specifier", current));
	Model (specifier, TypeSpecifier::Simple); specifier.simple.type = current.symbol; SkipCurrent ();
}

void Context::ParseTypeName (TypeSpecifier& specifier)
{
	Model (specifier, TypeSpecifier::TypeName); Parse (specifier.typeName.identifier, &Context::ParseCached);
}

void Context::ParseDecltype (TypeSpecifier& specifier)
{
	Model (specifier, TypeSpecifier::Decltype); ParseCached (specifier.decltype_.specifier);
}

void Context::Parse (DecltypeSpecifier& specifier)
{
	Parse (Decltype); Parse (LeftParen); ParseIf (!Skip (Auto), specifier.expression); Parse (RightParen);
}

void Context::ParseEnum (TypeSpecifier& specifier, const bool elaborated)
{
	Model (specifier, TypeSpecifier::Enum); ParseCached (specifier.enum_.head); Enter (specifier);
	specifier.enum_.isDefinition = !elaborated && (IsScoped (specifier.enum_.head.key) || specifier.enum_.head.attributes || !specifier.enum_.head.identifier || specifier.enum_.head.base || IsCurrent (LeftBrace, LessPercent));
	if (specifier.enum_.isDefinition) Parse (LeftBrace, LessPercent), ParseIf (!IsCurrent (RightBrace, PercentGreater), specifier.enum_.enumerators), Parse (RightBrace, PercentGreater);
	else Reset (specifier.enum_.enumerators); Leave (specifier);
}

void Context::Parse (EnumHead& head)
{
	Parse (head.key); ParseIf (IsAttribute (current.symbol), head.attributes);
	ParseIf (IsScoped (head.key) || IsNestedNameSpecifier (current.symbol), head.identifier);
	ParseIf (Skip (Colon), head.base); Check (head);
}

void Context::ParseOpaqueEnum (Declaration& declaration)
{
	Cached<EnumHead> head; Parse (head); if (!head.identifier || !IsCurrent (Semicolon)) return ParseSimple (declaration);
	Model (declaration, Declaration::OpaqueEnum); ParseCached (declaration.opaqueEnum.head); Parse (Semicolon); Check (declaration);
}

void Context::Parse (EnumKey& key)
{
	Parse (Enum); if (IsCurrent (Class, Struct)) key.symbol = current.symbol, SkipCurrent (); else key.symbol = Enum;
}

void Context::Parse (EnumeratorDefinitions& enumerators)
{
	do Parse (enumerators.emplace_back ());
	while (Skip (Comma) && !IsCurrent (RightBrace, PercentGreater) && !IsCurrent (Eof));
}

void Context::Parse (EnumeratorDefinition& enumerator)
{
	ParseName (enumerator.identifier);
	ParseIf (IsAttribute (current.symbol), enumerator.attributes);
	ParseIf (Skip (Equal), enumerator.expression, &Context::ParseConstant);
	Check (enumerator);
}

void Context::ParseNamespaceDefinition (Declaration& declaration)
{
	Model (declaration, Declaration::NamespaceDefinition);
	declaration.namespaceDefinition.isInline = SkipCached (Inline); ParseCached (Namespace);
	ParseIf (IsAttribute (current.symbol), declaration.namespaceDefinition.attributes);
	ParseIfCachedOr (IsCurrent (Lexer::Identifier), declaration.namespaceDefinition.identifier); Check (declaration);
	Enter (declaration); Parse (LeftBrace, LessPercent); ParseIf (!IsCurrent (RightBrace, PercentGreater), declaration.namespaceDefinition.body);
	Parse (RightBrace, PercentGreater); Leave (declaration);
}

void Context::ParseNamespaceAliasDefinition (Declaration& declaration)
{
	Model (declaration, Declaration::NamespaceAliasDefinition);
	ParseCached (Namespace); Parse (declaration.namespaceAliasDefinition.identifier, &Context::ParseCached);
	Parse (Equal); Parse (declaration.namespaceAliasDefinition.name); Parse (Semicolon); Check (declaration);
}

void Context::ParseUsing (Declaration& declaration)
{
	Model (declaration, Declaration::Using); ParseCached (Using);
	Parse (declaration.using_.declarators); Parse (Semicolon); Check (declaration);
}

void Context::Parse (UsingDeclarator& declarator)
{
	declarator.isTypename = Skip (Typename); ParseCached (declarator.identifier); Check (declarator);
}

void Context::ParseUsingDirective (Declaration& declaration)
{
	ParseIfCachedOr (IsAttribute (current.symbol), declaration.usingDirective.attributes);
	Model (declaration, Declaration::UsingDirective); ParseCached (Using); Parse (Namespace);
	Parse (declaration.usingDirective.identifier); Parse (Semicolon); Check (declaration);
}

void Context::ParseAsm (Declaration& declaration)
{
	Model (declaration, Declaration::Asm); ParseIfCachedOr (IsAttribute (current.symbol), declaration.asm_.attributes); Parse (Asm);
	Parse (LeftParen); Parse (declaration.asm_.stringLiteral, &Context::ParsePlain); Parse (RightParen); Parse (Semicolon); Check (declaration);
}

void Context::ParseLinkageSpecification (Declaration& declaration)
{
	Model (declaration, Declaration::LinkageSpecification); ParseCached (Extern);
	Parse (declaration.linkageSpecification.stringLiteral, &Context::ParsePlain); Check (declaration);
	Enter (declaration); ParseIf (!Skip (LeftBrace, LessPercent), declaration.linkageSpecification.declaration);
	ParseIf (!declaration.linkageSpecification.declaration && !IsCurrent (RightBrace, PercentGreater), declaration.linkageSpecification.declarations);
	if (!declaration.linkageSpecification.declaration) Parse (RightBrace, PercentGreater); Leave (declaration);
}

void Context::Parse (AttributeSpecifiers& specifiers)
{
	do Parse (specifiers.emplace_back ()); while (IsAttribute (current.symbol));
}

void Context::Parse (AttributeSpecifier& specifier)
{
	if (IsCurrent (Alignas)) ParseAlignas (specifier);
	else ParseAttributes (specifier);
}

void Context::ParseAttributes (AttributeSpecifier& specifier)
{
	Model (specifier, AttributeSpecifier::Attributes); Parse (DoubleLeftBracket);
	ParseIf (Skip (Using), specifier.attributes.usingPrefix, &Context::ParseName); if (specifier.attributes.usingPrefix) Parse (Colon);
	ParseIf (!IsCurrent (RightBracket, ColonGreater), specifier.attributes.list, specifier.attributes.usingPrefix); Parse (RightBracket, ColonGreater); Parse (RightBracket, ColonGreater);
}

void Context::ParseAlignas (AttributeSpecifier& specifier)
{
	Locate (specifier); Parse (Alignas); ParenthesizedTypeIdentifierCache parenthesizedTypeIdentifier;
	if (IsCurrent (parenthesizedTypeIdentifier)) ParseAlignasType (specifier); else ParseAlignasExpression (specifier);
}

void Context::ParseAlignasType (AttributeSpecifier& specifier)
{
	Model (specifier, AttributeSpecifier::AlignasType); ParseCached (LeftParen);
	Parse (specifier.alignasType.typeIdentifier); Parse (RightParen); Check (specifier);
}

void Context::ParseAlignasExpression (AttributeSpecifier& specifier)
{
	Model (specifier, AttributeSpecifier::AlignasExpression); ParseCached (LeftParen);
	Parse (specifier.alignasExpression.expression, &Context::ParseConstant); Parse (RightParen); Check (specifier);
}

void Context::Parse (Attributes& attributes, const Identifier*const namespace_)
{
	do if (IsCurrent (Lexer::Identifier) || IsKeyword (current.symbol) || IsAlternative (current.symbol)) Parse (attributes.emplace_back (), namespace_); while (Skip (Comma)); Check (attributes);
}

void Context::Parse (Attribute& attribute, const Identifier* namespace_)
{
	Locate (attribute); ConvertToIdentifier (current); Parse (attribute.name, &Context::ParseName);
	if (!namespace_ && Skip (DoubleColon)) namespace_ = attribute.namespace_ = attribute.name, ConvertToIdentifier (current), Parse (attribute.name, &Context::ParseName); else Reset (attribute.namespace_);
	#define EXTATTRIBUTE(namespace, attribute_, name_, value) if (namespace_ && namespace_->name.identifier == parser.namespace##Namespace && attribute.name->name.identifier == parser.attribute_##Attribute) return Parse##attribute_ (attribute);
	#define STDATTRIBUTE(attribute_, name_, value) if (!namespace_ && attribute.name->name.identifier == parser.attribute_##Attribute) return Parse##attribute_ (attribute);
	#include "cpp.def"
	Model (attribute, Attribute::Unspecified); ParseIf (Skip (LeftParen), attribute.unspecified.tokens, &Context::ParseBalanced, RightParen, RightParen);
	if (attribute.unspecified.tokens) for (auto& token: Parse (RightParen), *attribute.unspecified.tokens) ConvertToIdentifier (token); Check (attribute);
}

void Context::ParseCarriesDependency (Attribute& attribute)
{
	Model (attribute, Attribute::CarriesDependency); Check (attribute);
}

void Context::ParseDeprecated (Attribute& attribute)
{
	Model (attribute, Attribute::Deprecated);
	ParseIf (Skip (LeftParen), attribute.deprecated.stringLiteral, &Context::ParsePlain);
	if (attribute.deprecated.stringLiteral) Parse (RightParen); Check (attribute);
}

void Context::ParseFallthrough (Attribute& attribute)
{
	Model (attribute, Attribute::Fallthrough); Check (attribute);
}

void Context::ParseLikely (Attribute& attribute)
{
	Model (attribute, Attribute::Likely); Check (attribute);
}

void Context::ParseMaybeUnused (Attribute& attribute)
{
	Model (attribute, Attribute::MaybeUnused); Check (attribute);
}

void Context::ParseNodiscard (Attribute& attribute)
{
	Model (attribute, Attribute::Nodiscard);
	ParseIf (Skip (LeftParen), attribute.nodiscard.stringLiteral, &Context::ParsePlain);
	if (attribute.nodiscard.stringLiteral) Parse (RightParen); Check (attribute);
}

void Context::ParseNoreturn (Attribute& attribute)
{
	Model (attribute, Attribute::Noreturn); Check (attribute);
}

void Context::ParseNoUniqueAddress (Attribute& attribute)
{
	Model (attribute, Attribute::NoUniqueAddress); Check (attribute);
}

void Context::ParseUnlikely (Attribute& attribute)
{
	Model (attribute, Attribute::Unlikely); Check (attribute);
}

void Context::ParseAlias (Attribute& attribute)
{
	Model (attribute, Attribute::Alias); Parse (LeftParen);
	Parse (attribute.alias.stringLiteral, &Context::ParsePlain);
	Parse (RightParen); Check (attribute);
}

void Context::ParseCode (Attribute& attribute)
{
	Model (attribute, Attribute::Code); Check (attribute);
}

void Context::ParseDuplicable (Attribute& attribute)
{
	Model (attribute, Attribute::Duplicable); Check (attribute);
}

void Context::ParseGroup (Attribute& attribute)
{
	Model (attribute, Attribute::Group); Parse (LeftParen);
	Parse (attribute.group.stringLiteral, &Context::ParsePlain);
	Parse (RightParen); Check (attribute);
}

void Context::ParseOrigin (Attribute& attribute)
{
	Model (attribute, Attribute::Origin); Parse (LeftParen);
	Parse (attribute.origin.expression, &Context::ParseConstant);
	Parse (RightParen); Check (attribute);
}

void Context::ParseRegister (Attribute& attribute)
{
	Model (attribute, Attribute::Register); Check (attribute);
}

void Context::ParseReplaceable (Attribute& attribute)
{
	Model (attribute, Attribute::Replaceable); Check (attribute);
}

void Context::ParseRequired (Attribute& attribute)
{
	Model (attribute, Attribute::Required); Check (attribute);
}

void Context::Parse (Tokens& tokens, const Symbol sentinel, const Symbol alternative)
{
	tokens.push_back (current); SkipCurrent (); ParseBalanced (tokens, sentinel, alternative); tokens.push_back (current); Parse (sentinel, alternative);
}

void Context::ParseBalanced (Tokens& tokens, const Symbol sentinel, const Symbol alternative)
{
	while (!IsCurrent (sentinel, alternative) && !IsCurrent (Eof))
		if (IsCurrent (LeftParen)) Parse (tokens, RightParen, RightParen);
		else if (IsCurrent (LeftBracket, LessColon)) Parse (tokens, RightBracket, ColonGreater);
		else if (IsCurrent (LeftBrace, LessPercent)) Parse (tokens, RightBrace, PercentGreater);
		else if (IsCurrent (RightParen) || IsCurrent (RightBracket, ColonGreater) || IsCurrent (RightBrace, PercentGreater)) Expect (sentinel);
		else if (IsCurrent (DoubleLeftBracket)) Parse (tokens, RightBracket, ColonGreater), tokens.push_back (current), Parse (RightBracket, ColonGreater);
		else tokens.push_back (current), SkipCurrent ();
}

void Context::Parse (InitDeclarators& declarators)
{
	do Parse (declarators.emplace_back ()); while (SkipCached (Comma));
}

void Context::Parse (InitDeclarator& declarator)
{
	Parse (declarator.declarator, &Context::ParseCached); Check (declarator);
	ParseIf (IsCurrent (Equal, LeftParen) || IsCurrent (LeftBrace, LessPercent), declarator.initializer);
	FinalizeCheck (declarator);
}

void Context::Parse (Declarator& declarator)
{
	Enter (declarator); ParsePtr (declarator, &Context::ParseNoPtr);
	if (IsCurrent (Arrow) && IsFunction (declarator)) ParseTrailingReturnType (declarator); Leave (declarator);
}

void Context::ParsePtr (Declarator& declarator, void (Context::*const parse) (Declarator&))
{
	if (IsCached<Identifier> () || IsCached (LeftParen)) (this->*parse) (declarator);
	else if (IsCached (Asterisk) || IsCurrent (Asterisk)) ParsePointer (declarator, parse);
	else if (IsCached (Ampersand, Bitand) || IsCurrent (Ampersand, Bitand) || IsCurrent (DoubleAmpersand, And)) ParseReference (declarator, parse);
	else if (IsNestedNameSpecifier (current.symbol)) ParseMemberPointer (declarator, parse);
	else (this->*parse) (declarator);
}

void Context::ParseNoPtr (Declarator& declarator)
{
	if (IsCached<Identifier> ()) ParseName (declarator);
	else if (IsCached (LeftParen)) ParseParenthesized (declarator, &Context::ParseNoPtr);
	else if (IsCurrent (Ellipsis) || IsIdentifier (current.symbol)) ParseName (declarator);
	else if (IsCurrent (LeftParen)) ParseParenthesized (declarator, &Context::ParseNoPtr);
	else EmitError (current, Format ("encountered %0 instead of declarator", current));
	while (IsCached (LeftParen) || IsCurrent (LeftParen) || IsCurrent (LeftBracket, LessColon))
		if (IsCached (LeftParen) || IsCurrent (LeftParen)) ParseFunction (declarator); else ParseArray (declarator);
}

void Context::ParseFunction (Declarator& declarator)
{
	translationUnit.Create (declarator.function.declarator, declarator); Locate (declarator);
	Model (declarator, Declarator::Function); Parse (declarator.function.prototype);
}

void Context::Parse (FunctionPrototype& prototype)
{
	Enter (prototype);
	ParseCached (LeftParen); Parse (prototype.parameterDeclarations); Parse (RightParen);
	ParseIf (IsConstVolatileQualifier (current.symbol), prototype.constVolatileQualifiers);
	ParseIf (IsReferenceQualifier (current.symbol), prototype.referenceQualifier);
	ParseIf (IsCurrent (Noexcept, Throw), prototype.noexceptSpecifier);
	ParseIf (IsAttribute (current.symbol), prototype.attributes);
	Leave (prototype);
}

void Context::ParseTrailingReturnType (Declarator& declarator)
{
	assert (IsFunction (declarator)); assert (declarator.function.prototype);
	ParseTrailingReturnType (*declarator.function.prototype);
}

void Context::ParseTrailingReturnType (FunctionPrototype& prototype)
{
	Enter (prototype); Parse (Arrow); Parse (prototype.trailingReturnType); Leave (prototype);
}

void Context::ParseArray (Declarator& declarator)
{
	translationUnit.Create (declarator.array.declarator, declarator); Locate (declarator); ParseDeclaratedArray (declarator);
}

void Context::ParseDeclaratedArray (Declarator& declarator)
{
	Model (declarator, Declarator::Array); Parse (LeftBracket, LessColon);
	ParseIf (!IsCurrent (RightBracket, ColonGreater), declarator.array.expression, &Context::ParseConstant);
	Parse (RightBracket, ColonGreater); ParseIf (IsAttribute (current.symbol), declarator.array.attributes);
}

void Context::ParseParenthesized (Declarator& declarator, void (Context::*const parse) (Declarator&))
{
	Model (declarator, Declarator::Parenthesized); ParseCached (LeftParen);
	Parse (declarator.parenthesized.declarator, &Context::ParsePtr, parse); ParseCached (RightParen);
}

void Context::ParsePointer (Declarator& declarator, void (Context::*const parse) (Declarator&))
{
	Model (declarator, Declarator::Pointer); ParseCached (Asterisk);
	if (IsCached (Asterisk)) Reset (declarator.pointer.attributes), Reset (declarator.pointer.qualifiers), Parse (declarator.pointer.declarator, &Context::ParsePointer, parse);
	ParseIf (IsAttribute (current.symbol), declarator.pointer.attributes);
	ParseIf (IsConstVolatileQualifier (current.symbol), declarator.pointer.qualifiers);
	ParseIf (IsCurrentDeclarator (parse), declarator.pointer.declarator, &Context::ParsePtr, parse);
}

void Context::ParseReference (Declarator& declarator, void (Context::*const parse) (Declarator&))
{
	Model (declarator, Declarator::Reference); declarator.reference.isRValue = !SkipCached (Ampersand, Bitand);
	if (declarator.reference.isRValue) ParseCached (DoubleAmpersand, And); ParseIf (IsAttribute (current.symbol), declarator.reference.attributes);
	ParseIf (IsCurrentDeclarator (parse), declarator.reference.declarator, &Context::ParsePtr, parse);
}

void Context::ParseMemberPointer (Declarator& declarator, void (Context::*const parse) (Declarator&))
{
	Cached<Identifier> identifier; Parse (identifier); if (!IsCurrent (DoubleColon)) return (this->*parse) (declarator);
	Model (declarator, Declarator::MemberPointer); Parse (declarator.memberPointer.specifier);
	Parse (Asterisk); ParseIf (IsAttribute (current.symbol), declarator.memberPointer.attributes);
	ParseIf (IsConstVolatileQualifier (current.symbol), declarator.memberPointer.qualifiers);
	ParseIf (IsCurrentDeclarator (parse), declarator.memberPointer.declarator, &Context::ParsePtr, parse);
}

void Context::Parse (ConstVolatileQualifiers& qualifiers)
{
	assert (IsConstVolatileQualifier (current.symbol));
	do Check (qualifiers, current), SkipCurrent (); while (IsConstVolatileQualifier (current.symbol));
}

void Context::Parse (ReferenceQualifier& qualifier)
{
	assert (IsReferenceQualifier (current.symbol)); qualifier.symbol = current.symbol; SkipCurrent ();
}

void Context::ParseName (Declarator& declarator)
{
	Model (declarator, Declarator::Name); declarator.name.isPacked = !IsCached<Identifier> () && Skip (Ellipsis);
	ParseIfCachedOr (IsIdentifier (current.symbol), declarator.name.identifier); Check (declarator);
	ParseIfCachedOr (declarator.name.identifier && IsAttribute (current.symbol), declarator.name.attributes);
}

void Context::Parse (TypeIdentifier& identifier)
{
	Parse (identifier.specifiers);
	ParseIf (IsCached (LeftParen) || IsAbstractDeclarator (current.symbol), identifier.declarator, &Context::ParseAbstract);
	Check (identifier);
}

void Context::ParseDefining (TypeIdentifier& identifier)
{
	ParseDefining (identifier.specifiers);
	ParseIf (IsAbstractDeclarator (current.symbol), identifier.declarator, &Context::ParseAbstract);
	Check (identifier);
}

void Context::ParseAbstract (Declarator& declarator)
{
	ParsePtr (declarator, &Context::ParseNoPtrAbstractPack);
	if (IsCurrent (Arrow) && IsFunction (declarator)) ParseTrailingReturnType (declarator);
}

void Context::ParseNoPtrAbstract (Declarator& declarator)
{
	if (IsCached<Identifier> ()) ParseAbstractPack (declarator);
	else if (IsCached (LeftParen) || IsCurrent (LeftParen)) ParseAbstractFunction (declarator, &Context::ParseNoPtrAbstract);
	else if (IsCurrent (LeftBracket, LessColon)) ParseAbstractArray (declarator);
	else EmitError (current, Format ("encountered %0 instead of abstract declarator", current));
	while (IsCurrent (LeftParen) || IsCurrent (LeftBracket, LessColon)) if (IsCurrent (LeftParen)) ParseFunction (declarator); else ParseArray (declarator);
}

void Context::ParseAbstractFunction (Declarator& declarator, void (Context::*const parse) (Declarator&))
{
	CachedToken<LeftParen> leftParen; if (!IsCached (LeftParen)) Parse (leftParen);
	{auto& token = *firstCached; Hide (token); if (IsCached (Asterisk)) return Unhide (token), ParseParenthesized (declarator, parse); Unhide (token);}
	if (IsPointerOperator (current.symbol) || IsCurrent (LeftParen)) return ParseParenthesized (declarator, parse);
	Model (declarator, Declarator::Function); Reset (declarator.function.declarator); Parse (declarator.function.prototype);
}

void Context::ParseAbstractArray (Declarator& declarator)
{
	Reset (declarator.function.declarator); ParseDeclaratedArray (declarator);
}

void Context::ParseNoPtrAbstractPack (Declarator& declarator)
{
	if (IsCurrent (Ellipsis)) ParseAbstractPack (declarator); else return ParseNoPtrAbstract (declarator);
	while (IsCurrent (LeftParen) || IsCurrent (LeftBracket, LessColon)) if (IsCurrent (LeftParen)) ParseFunction (declarator); else ParseArray (declarator);
}

void Context::ParseAbstractPack (Declarator& declarator)
{
	Model (declarator, Declarator::Name); ParseIfCached (declarator.name.identifier);
	if (declarator.name.identifier) EmitError (declarator.name.identifier->location, Format ("encountered identifier '%0' in abstract declarator", *declarator.name.identifier));
	Parse (Ellipsis); declarator.name.isPacked = true; Reset (declarator.name.attributes);
}

void Context::Parse (ParameterDeclarations& declarations)
{
	if (IsCached<Identifier> () || !IsCurrent (RightParen)) do if (IsCurrent (Ellipsis)) break; else Parse (declarations.emplace_back ()); while (Skip (Comma));
	if (const auto declarator = DisambiguateEllipsis (declarations)) declarator->name.isPacked = false, declarations.isPacked = true; else declarations.isPacked = Skip (Ellipsis);
	Check (declarations);
}

void Context::Parse (ParameterDeclaration& declaration)
{
	ParseIf (IsAttribute (current.symbol), declaration.attributes); Locate (declaration); Parse (declaration.specifiers);
	ParseIf (IsCached<Identifier> () || IsIdentifier (current.symbol) || IsAbstractDeclarator (current.symbol), declaration.declarator, &Context::ParseOptionallyAbstract);
	Check (declaration); ParseIf (Skip (Equal), declaration.initializer, &Context::ParseInitializerClause);
	FinalizeCheck (declaration);
}

void Context::ParseOptionallyAbstract (Declarator& declarator)
{
	Enter (declarator); ParsePtr (declarator, &Context::ParseNoPtrOptionallyAbstractPack);
	if (IsCurrent (Arrow) && IsFunction (declarator)) ParseTrailingReturnType (declarator); Leave (declarator);
}

void Context::ParseNoPtrOptionallyAbstractPack (Declarator& declarator)
{
	if (IsCached<Identifier> () || IsIdentifier (current.symbol)) return ParseNoPtr (declarator);
	if (IsCurrent (LeftParen)) ParseAbstractFunction (declarator, &Context::ParseNoPtrOptionallyAbstractPack); else return ParseNoPtrAbstractPack (declarator);
	while (IsCurrent (LeftParen) || IsCurrent (LeftBracket, LessColon)) if (IsCurrent (LeftParen)) ParseFunction (declarator); else ParseArray (declarator);
}

void Context::ParseFunctionDefinition (Declaration& declaration)
{
	Model (declaration, Declaration::FunctionDefinition);
	Parse (declaration.functionDefinition.declarator, &Context::ParseCached);
	Reset (declaration.functionDefinition.virtualSpecifiers); Reset (declaration.functionDefinition.inlinedBody);
	Check (declaration); Enter (declaration); Parse (declaration.functionDefinition.body); Leave (declaration);
}

void Context::ParseMemberFunctionDefinition (Declaration& declaration)
{
	Model (declaration, Declaration::FunctionDefinition);
	Parse (declaration.functionDefinition.declarator, &Context::ParseCached);
	ParseIfCachedOr (IsVirtualSpecifier (current), declaration.functionDefinition.virtualSpecifiers);
	Check (declaration); if (!IsCached (Equal)) Parse (declaration.functionDefinition.inlinedBody, &Context::ParseFunctionBody);
	else Reset (declaration.functionDefinition.inlinedBody), Enter (declaration), Parse (declaration.functionDefinition.body), Leave (declaration);
}

void Context::ParseFunctionBody (Tokens& tokens)
{
	if (IsCurrent (Colon, Try)) ParseBalanced (tokens, LeftBrace, LessPercent); Parse (tokens, RightBrace, PercentGreater);
	while (IsCurrent (Catch)) ParseBalanced (tokens, LeftBrace, LessPercent), Parse (tokens, RightBrace, PercentGreater);
}

void Context::ParseInlinedMemberFunctionDefinition (Declaration& declaration)
{
	assert (IsFunctionDefinition (declaration)); if (!declaration.functionDefinition.inlinedBody) return;
	Restore (*declaration.functionDefinition.inlinedBody); Enter (declaration); Parse (declaration.functionDefinition.body); Leave (declaration);
}

void Context::Parse (FunctionBody& body)
{
	if (IsCached (Equal)) ParseEqual (body);
	else if (IsCurrent (Try)) ParseTry (body);
	else if (IsCurrent (Equal)) ParseEqual (body);
	else ParseRegular (body);
}

void Context::ParseTry (FunctionBody& body)
{
	Model (body, FunctionBody::Try); Parse (Try);
	ParseIf (Skip (Colon), body.try_.initializers); Check (body);
	Parse (body.try_.block); Parse (body.try_.handlers);
}

void Context::ParseEqual (FunctionBody& body)
{
	Locate (body); ParseCached (Equal);
	if (IsCurrent (Default)) ParseDefault (body); else if (IsCurrent (Delete)) ParseDelete (body);
	else EmitError (current, Format ("encountered %0 instead of %1 or %2", current, Default, Delete));
}

void Context::ParseDefault (FunctionBody& body)
{
	Model (body, FunctionBody::Default); Parse (Default); Parse (Semicolon); Check (body);
}

void Context::ParseDelete (FunctionBody& body)
{
	Model (body, FunctionBody::Delete); Parse (Delete); Parse (Semicolon); Check (body);
}

void Context::ParseRegular (FunctionBody& body)
{
	Model (body, FunctionBody::Regular);
	ParseIf (Skip (Colon), body.regular.initializers);
	Check (body); Parse (body.regular.block);
}

void Context::Parse (Initializer& initializer)
{
	if (IsCurrent (LeftParen)) ParseParenthesized (initializer);
	else ParseBracedOrAssignment (initializer);
}

void Context::ParseParenthesized (Initializer& initializer)
{
	Locate (initializer); Parse (LeftParen); Parse (initializer.expressions); Parse (RightParen);
}

void Context::ParseBracedOrAssignment (Initializer& initializer)
{
	if (IsCurrent (LeftBrace, LessPercent)) ParseBraced (initializer);
	else ParseAssignment (initializer);
}

void Context::ParseAssignment (Initializer& initializer)
{
	Locate (initializer); Parse (Equal); initializer.assignment = true;
	if (IsCurrent (LeftBrace, LessPercent)) return ParseBraced (initializer);
	ParseAssignment (initializer.expressions.emplace_back ());
}

void Context::ParseBraced (Initializer& initializer)
{
	Locate (initializer); Parse (LeftBrace, LessPercent); initializer.braced = true;
	if (!IsCurrent (RightBrace, PercentGreater)) Parse (initializer.expressions); Parse (RightBrace, PercentGreater);
}

void Context::ParseInitializerClause (Expression& expression)
{
	if (IsCurrent (LeftBrace, LessPercent)) ParseBraced (expression);
	else ParseAssignment (expression);
}

void Context::ParseBraced (Expression& expression)
{
	Model (expression, Expression::Braced); Parse (LeftBrace, LessPercent);
	ParseIf (!IsCurrent (RightBrace, PercentGreater), expression.braced.expressions); Parse (RightBrace, PercentGreater); Check (expression);
}

void Context::ParseOptionallyBraced (Expression& expression)
{
	if (IsCurrent (LeftBrace, LessPercent)) ParseBraced (expression);
	else Parse (expression);
}

void Context::ParseClass (TypeSpecifier& specifier, const bool elaborated)
{
	Model (specifier, TypeSpecifier::Class); Parse (specifier.class_.head, elaborated); Enter (specifier);
	specifier.class_.isDefinition = !elaborated && (specifier.class_.head.isFinal || specifier.class_.head.baseSpecifiers || IsCurrent (LeftBrace, LessPercent));
	if (specifier.class_.isDefinition) Parse (LeftBrace, LessPercent), ParseIf (!IsCurrent (RightBrace, PercentGreater), specifier.class_.members, &Context::ParseMember), Parse (RightBrace, PercentGreater);
	else Reset (specifier.class_.members); Leave (specifier);
}

void Context::Parse (ClassHead& head, const bool elaborated)
{
	Parse (head.key); ParseIf (IsAttribute (current.symbol), head.attributes);
	ParseIf (IsNestedNameSpecifier (current.symbol), head.identifier);
	head.isFinal = !elaborated && head.identifier && IsFinal (current) && Skip (Lexer::Identifier);
	ParseIf (!elaborated && Skip (Colon), head.baseSpecifiers); Check (head);
}

void Context::Parse (ClassKey& key)
{
	assert (IsClassKey (current.symbol)); key.symbol = current.symbol; SkipCurrent ();
}

void Context::ParseMember (Declarations& declarations)
{
	do ParseMemberSpecification (declarations.emplace_back ());
	while (!IsCurrent (RightBrace, PercentGreater) && !IsCurrent (Eof));
	for (auto& declaration: declarations) ParseInlinedMemberSpecification (declaration);
}

void Context::ParseMemberSpecification (Declaration& declaration)
{
	if (IsAccessSpecifier (current.symbol)) ParseAccess (declaration);
	else if (IsCurrent (Using)) ParseUsingOrAlias (declaration);
	else if (IsCurrent (StaticAssert)) ParseStaticAssertion (declaration);
	else if (IsCurrent (Template)) ParseTemplate (declaration);
	else if (IsCurrent (Semicolon)) ParseEmpty (declaration);
	else ParseMember (declaration);
}

void Context::ParseInlinedMemberSpecification (Declaration& declaration)
{
	if (IsMember (declaration)) ParseInlinedMember (declaration);
	else if (IsFunctionDefinition (declaration)) ParseInlinedMemberFunctionDefinition (declaration);
}

void Context::ParseMember (Declaration& declaration)
{
	ParseIf (IsAttribute (current.symbol), declaration.basic.attributes);
	if (!IsCurrent (Lexer::Identifier, DoubleColon) && !IsCurrent (Tilde, Lexer::Operator) && !IsCurrent (LeftParen) && !IsDeclarationSpecifier (current.symbol) && !IsCached<EnumHead> ())
		EmitError (current, Format ("encountered %0 instead of member declaration", current));
	ConstructorCache constructor; Parse (declaration.basic.specifiers, constructor);
	if (IsCurrent (Semicolon)) return Model (declaration, Declaration::Simple), Reset (declaration.simple.declarators), Parse (Semicolon), Check (declaration);
	Cached<Declarator> declarator; if (!IsCurrent (Colon)) Parse (declarator);
	Cached<VirtualSpecifiers> virtualSpecifiers; if (IsCached (declarator) && IsVirtualSpecifier (current)) Parse (virtualSpecifiers);
	CachedToken<Equal> equal; if (IsCached (declarator) && IsCurrent (Equal)) Parse (equal);
	if (IsCached (declarator) && (IsCached (equal) ? !IsCurrent (OctalInteger) : IsFunctionBody (current.symbol)) && IsFunctionDefinition (declarator)) return ParseMemberFunctionDefinition (declaration);
	Model (declaration, Declaration::Member); Enter (declaration); Parse (declaration.member.declarators); Leave (declaration); Parse (Semicolon); Check (declaration);
}

void Context::ParseInlinedMember (Declaration& declaration)
{
	assert (IsMember (declaration)); assert (declaration.member.declarators);
	Enter (declaration); for (auto& declarator: *declaration.member.declarators) ParseInlined (declarator); Leave (declaration);
}

void Context::Parse (MemberDeclarator& declarator)
{
	ParseIfCachedOr (!IsCurrent (Colon) && !IsAttribute (current.symbol), declarator.declarator); Check (declarator);
	ParseIfCachedOr (IsVirtualSpecifier (current) && declarator.declarator, declarator.virtualSpecifiers); Reset (declarator.initializer);
	if (IsCached (Equal)) RestoreCachedToken (), ParseBalanced (declarator.inlinedInitializer, Semicolon, Comma);
	else if (IsCurrent (Equal) || IsCurrent (LeftBrace, LessPercent)) ParseBalanced (declarator.inlinedInitializer, Semicolon, Comma);
	else if (!declarator.declarator) Parse (Colon), Parse (declarator.expression, &Context::ParseConstant);
	else ParseIf (IsName (*declarator.declarator) && !declarator.virtualSpecifiers && Skip (Colon), declarator.expression, &Context::ParseConstant);
}

void Context::ParseInlined (MemberDeclarator& declarator)
{
	if (!declarator.inlinedInitializer.empty ()) Restore (declarator.inlinedInitializer), Enter (declarator), Parse (declarator.initializer), Leave (declarator);
	FinalizeCheck (declarator);
}

void Context::ParseAccess (Declaration& declaration)
{
	Model (declaration, Declaration::Access); Parse (declaration.access.specifier); Parse (Colon);
}

void Context::ParseUsingOrAlias (Declaration& declaration)
{
	CachedToken<Using> using_; Parse (using_);
	if (IsCurrent (Typename)) return ParseUsing (declaration);
	Cached<Identifier> identifier; Hide (using_); Parse (identifier); Unhide (using_);
	if (IsQualified (identifier)) ParseUsing (declaration); else ParseAlias (declaration);
}

void Context::Parse (VirtualSpecifiers& specifiers)
{
	do Check (specifiers, current), SkipCurrent (); while (IsVirtualSpecifier (current));
}

void Context::Parse (BaseSpecifier& specifier)
{
	ParseIf (IsAttribute (current.symbol), specifier.attributes);
	specifier.isVirtual = Skip (Virtual);
	ParseIf (IsAccessSpecifier (current.symbol), specifier.accessSpecifier);
	if (!specifier.isVirtual) specifier.isVirtual = Skip (Virtual);
	ParseClassOrDecltype (specifier.typeSpecifier);
}

void Context::ParseClassOrDecltype (TypeSpecifier& specifier)
{
	if (IsCurrent (Lexer::Identifier, DoubleColon)) return ParseTypeName (specifier);
	if (!IsCurrent (Decltype)) EmitError (current, Format ("encountered %0 instead of type specifier", current));
	Cached<DecltypeSpecifier> decltypeSpecifier; Parse (decltypeSpecifier);
	if (IsCurrent (DoubleColon)) ParseTypeName (specifier); else ParseDecltype (specifier);
}

void Context::Parse (AccessSpecifier& specifier)
{
	assert (IsAccessSpecifier (current.symbol)); specifier.symbol = current.symbol; SkipCurrent ();
}

void Context::ParseOperator (Identifier& identifier)
{
	Locate (identifier); Parse (Lexer::Operator);
	if (IsFunctionOperator (current.symbol)) ParseOperatorFunction (identifier);
	else if (IsString (current.symbol)) ParseLiteralOperator (identifier);
	else ParseConversionFunction (identifier);
}

void Context::ParseConversionFunction (Identifier& identifier)
{
	Model (identifier, Identifier::ConversionFunction);
	Parse (identifier.conversionFunction.typeIdentifier, &Context::ParseConversion);
}

void Context::ParseConversion (TypeIdentifier& identifier)
{
	Parse (identifier.specifiers); ParseIf (IsPointerOperator (current.symbol), identifier.declarator, &Context::ParseConversion); Check (identifier);
}

void Context::ParseConversion (Declarator& declarator)
{
	assert (IsPointerOperator (current.symbol)); ParsePtr (declarator, &Context::ParseConversion);
}

void Context::Parse (MemberInitializer& initializer)
{
	ParseClassOrDecltype (initializer.specifier); ParseNew (initializer.initializer);
}

void Context::ParseOperatorFunction (Identifier& identifier)
{
	Model (identifier, Identifier::OperatorFunction); Parse (identifier.operatorFunction.operator_);
}

void Context::Parse (Operator& operator_)
{
	assert (IsFunctionOperator (current.symbol)); operator_.symbol = current.symbol; SkipCurrent ();
	operator_.bracketed = (operator_.symbol == New || operator_.symbol == Delete) && Skip (LeftBracket, LessColon);
	if (operator_.symbol == LeftBracket || operator_.symbol == LessColon || operator_.bracketed) Parse (RightBracket, ColonGreater);
	else if (operator_.symbol == LeftParen) Parse (RightParen);
}

void Context::ParseLiteralOperator (Identifier& identifier)
{
	Model (identifier, Identifier::LiteralOperator); StringLiteral literal; ParseUserDefined (literal);
	for (auto& token: literal.tokens) if (token.symbol != NarrowString || !token.literal->empty ()) EmitError (token, Format ("encountered %0 instead of empty string literal", token));
	if (literal.suffix) identifier.literalOperator.suffixIdentifier = literal.suffix;
	else Expect (Lexer::Identifier), identifier.literalOperator.suffixIdentifier = current.identifier, SkipCurrent ();
}

void Context::ParseTemplate (Declaration& declaration)
{
	Model (declaration, Declaration::Template); ParseCached (Template);
	Enter (declaration); ParseCached (Less); Parse (declaration.template_.parameters); Parse (Greater);
	Check (declaration); Parse (declaration.template_.declaration); Leave (declaration);
}

void Context::Parse (TemplateParameter& parameter)
{
	if (IsCurrent (Class, Typename)) ParseType (parameter);
	else if (IsCurrent (Template)) ParseTemplate (parameter);
	else ParseDeclaration (parameter);
}

void Context::ParseType (TemplateParameter& parameter)
{
	Model (parameter, TemplateParameter::Type);
	Parse (parameter.type.key); parameter.type.isPacked = Skip (Ellipsis);
	ParseIf (IsCurrent (Lexer::Identifier), parameter.type.identifier, &Context::ParseName);
	ParseIf (!parameter.type.isPacked && Skip (Equal), parameter.type.default_); Check (parameter);
}

void Context::ParseTemplate (TemplateParameter& parameter)
{
	Model (parameter, TemplateParameter::Template); Parse (Template);
	Parse (Less); Parse (parameter.template_.parameters); Parse (Greater);
	Parse (parameter.template_.key); parameter.template_.isPacked = Skip (Ellipsis);
	ParseIf (IsCurrent (Lexer::Identifier), parameter.template_.identifier, &Context::ParseName);
	ParseIf (!parameter.template_.isPacked && Skip (Equal), parameter.template_.default_); Check (parameter);
}

void Context::ParseDeclaration (TemplateParameter& parameter)
{
	Model (parameter, TemplateParameter::Declaration);
	Parse (parameter.declaration); Check (parameter);
}

void Context::Parse (TypeParameterKey& key)
{
	key.symbol = current.symbol; Parse (Class, Typename);
}

void Context::ParseTemplate (Identifier& identifier)
{
	translationUnit.Create (identifier.template_.identifier, identifier); Model (identifier, Identifier::Template);
	Locate (identifier); Parse (Less); ParseIf (!IsCurrent (Greater), identifier.template_.arguments);
	if (IsCurrent (DoubleGreater)) current.symbol = Greater, current.location.position.Advance ('>'); else Parse (Greater); Check (identifier);
}

void Context::Parse (TemplateArgument& argument)
{
	TypeIdentifierCache typeIdentifier;
	if (IsCurrent (typeIdentifier)) ParseTypeIdentifier (argument); else ParseExpression (argument);
}

void Context::ParseExpression (TemplateArgument& argument)
{
	Model (argument, TemplateArgument::Expression); Parse (argument.expression); Check (argument);
}

void Context::ParseTypeIdentifier (TemplateArgument& argument)
{
	Model (argument, TemplateArgument::TypeIdentifier); Parse (argument.typeIdentifier); Check (argument);
}

void Context::ParseTypename (TypeSpecifier& specifier)
{
	Model (specifier, TypeSpecifier::Typename); Parse (Typename); Parse (specifier.typename_.identifier);
}

void Context::ParseExplicitInstantiation (Declaration& declaration)
{
	Model (declaration, Declaration::ExplicitInstantiation);
	declaration.explicitInstantiation.isExtern = SkipCached (Extern); ParseCached (Template); Enter (declaration);
	Parse (declaration.explicitInstantiation.declaration, &Context::ParseSimple); Leave (declaration); Check (declaration);
}

void Context::ParseExplicitSpecialization (Declaration& declaration)
{
	Model (declaration, Declaration::ExplicitSpecialization);
	ParseCached (Template); ParseCached (Less); Parse (Greater);
	Parse (declaration.explicitSpecialization.declaration); Check (declaration);
}

void Context::ParseTry (Statement& statement)
{
	Model (statement, Statement::Try); ParseIfCached (statement.attributes); Parse (Try);
	Enter (statement); Parse (statement.try_.block); Parse (statement.try_.handlers); Leave (statement); Check (statement);
}

void Context::Parse (ExceptionHandlers& handlers)
{
	do Parse (handlers.emplace_back ()); while (IsCurrent (Catch));
}

void Context::Parse (ExceptionHandler& handler)
{
	Parse (Catch); Parse (LeftParen); Parse (handler.declaration);
	Parse (RightParen); Parse (handler.block);
}

void Context::Parse (ExceptionDeclaration& declaration)
{
	if (Skip (Ellipsis)) return Reset (declaration.attributes), Reset (declaration.declarator);
	ParseIf (IsAttribute (current.symbol), declaration.attributes); Parse (declaration.specifiers);
	ParseIf (IsIdentifier (current.symbol) || IsAbstractDeclarator (current.symbol), declaration.declarator, &Context::ParseOptionallyAbstract);
}

void Context::Parse (NoexceptSpecifier& specifier)
{
	Locate (specifier); specifier.throw_ = IsCurrent (Throw); Parse (Noexcept, Throw);
	if (specifier.throw_) Parse (LeftParen); else ParseIf (Skip (LeftParen), specifier.expression, &Context::ParseConstant);
	if (specifier.throw_ || specifier.expression) Parse (RightParen); Check (specifier);
}

void Context::ValidateMacro (const Token& name) const
{
	if (IsKeyword (name.symbol) || IsFinal (name) || IsOverride (name) || parser.IsPredefined (name.identifier)
		#define STDATTRIBUTE(attribute, name_, value) || name.identifier == parser.attribute##Attribute
		#include "cpp.def"
		) EmitError (name, Format ("invalid macro name '%0'", *name.identifier));
}

Context::Value Context::TestAttribute (const String*const namespace_, const String*const name) const
{
	#define EXTATTRIBUTE(namespace, attribute_, name_, value) if (namespace_ == parser.namespace##Namespace && name == parser.attribute_##Attribute) return value;
	#define STDATTRIBUTE(attribute_, name_, value) if (!namespace_ && name == parser.attribute_##Attribute) return value;
	#include "cpp.def"
	return 0;
}

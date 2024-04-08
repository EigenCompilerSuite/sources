// C++ semantic checker context
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

#ifndef ECS_CPP_CHECKER_CONTEXT_HEADER_INCLUDED
#define ECS_CPP_CHECKER_CONTEXT_HEADER_INCLUDED

#include "cppchecker.hpp"
#include "cppevaluator.hpp"

class ECS::CPP::Checker::Context : Evaluator
{
protected:
	TranslationUnit& translationUnit;

	Context (const Checker&, TranslationUnit&);

	void Check (Attribute&);
	void Check (Attributes&);
	void Check (AttributeSpecifier&);
	void Check (ClassHead&);
	void Check (Condition&);
	void Check (ConstVolatileQualifiers&, const Lexer::Token&);
	void Check (Declaration&);
	void Check (DeclarationSpecifier&, DeclarationSpecifiers&);
	void Check (DeclarationSpecifiers&);
	void Check (Declarator&);
	void Check (EnumeratorDefinition&);
	void Check (EnumHead&);
	void Check (Expression&);
	void Check (FunctionBody&);
	void Check (Identifier&);
	void Check (InitDeclarator&);
	void Check (NestedNameSpecifier&);
	void Check (NoexceptSpecifier&);
	void Check (ParameterDeclaration&);
	void Check (ParameterDeclarations&);
	void Check (Statement&);
	void Check (Substatement&);
	void Check (TemplateArgument&);
	void Check (TemplateParameter&);
	void Check (TypeIdentifier&);
	void Check (TypeSpecifiers&);
	void Check (TypeSpecifier&, TypeSpecifiers&);
	void Check (UsingDeclarator&);
	void Check (VirtualSpecifiers&, const Lexer::Token&);

	void FinalizeChecks ();
	void FinalizeCheck (Declaration&);
	void FinalizeCheck (InitDeclarator&);
	void FinalizeCheck (MemberDeclarator&);
	void FinalizeCheck (ParameterDeclaration&);

	void Enter (Declaration&);
	void Enter (Declarator&);
	void Enter (FunctionPrototype&);
	void Enter (MemberDeclarator&);
	void Enter (Statement&);
	void Enter (StatementBlock&);
	void Enter (TypeSpecifier&);
	void Leave (Declaration&);
	void Leave (Declarator&);
	void Leave (FunctionPrototype&);
	void Leave (MemberDeclarator&);
	void Leave (Statement&);
	void Leave (StatementBlock&);
	void Leave (TypeSpecifier&);

	bool IsFinal (const Lexer::BasicToken&) const;
	bool IsOverride (const Lexer::BasicToken&) const;
	bool IsScopeName (const Identifier&) const;
	bool IsTemplateName (const Identifier&) const;
	bool IsTypeName (const Identifier&) const;
	bool IsVirtualSpecifier (const Lexer::BasicToken&) const;

	Declarator* DisambiguateEllipsis (ParameterDeclarations&) const;

private:
	struct Expansion;
	struct InlineUse {const Entity& entity; Location location;};

	const Checker& checker;

	Size bytes, variables, registers;
	mutable std::vector<InlineUse> inlineUses;
	std::vector<const Statement*> asmDeclarations;

	Scope* currentScope;
	Function* currentFunction = nullptr;
	Expansion* currentExpansion = nullptr;
	LanguageLinkage currentLinkage = LanguageLinkage::CPP;

	std::vector<Scope*> enclosingScopes;
	Statement* enclosingStatement = nullptr;
	std::vector<Function*> enclosingFunctions;
	std::vector<LanguageLinkage> enclosingLinkages;
	std::vector<Declaration*> enclosingDeclarations;
	std::vector<MemberDeclarator*> enclosingMemberDeclarators;

	void EmitNote (const Location&, const Message&) const;
	void EmitWarning (const Location&, const Message&) const;
	void EmitErrorNote (const Location&, const Message&) const;
	void EmitError (bool, const Location&, const Message&) const;
	void EmitError [[noreturn]] (const Location&, const Message&) const;
	void EmitWarning (const Location&, const Message&, const Location&) const;
	void EmitError (bool, const Location&, const Message&, const Location&) const;
	void EmitError [[noreturn]] (const Location&, const Message&, const Location&) const;

	Entity& Use (Entity&, const Location&) const;
	void Use (Deprecation&, const Location&) const;
	void WarnAboutUnusedEntities (const Scope&) const;

	Entities Lookup (const Identifier&) const;
	Entities Search (const Identifier&) const;
	Entity& LookupType (const Identifier&) const;
	Scope& LookupScope (const Identifier&) const;
	Namespace& LookupNamespace (const Identifier&) const;
	Entity& Lookup (const Identifier&, const Type&) const;
	bool LookupUnqualified (const Name&, Entities&) const;
	Entity& LookupStandard (const Name&, const Location&, const char*) const;

	void EnterBlock (Scope&);
	void LeaveBlock (Scope&);

	Entity& DeclareAlias (const Type&, const Identifier&, const DeclarationSpecifiers&);
	Entity& DeclareClass (const ClassKey&, const Identifier&);
	Entity& Declare (const Type&, const Identifier&, const DeclarationSpecifiers&);
	Entity& Declare (Entity::Model, const Identifier&, const Type&, Scope&);
	Entity& DeclareEnumeration (const EnumKey&, const Identifier&, const Type&);
	Entity& DeclareFunction (const Type&, const Identifier&, const DeclarationSpecifiers&);
	Entity& DeclareLabel (const Identifier&);
	Entity& DeclareVariable (const Type&, const Identifier&, const DeclarationSpecifiers&);
	Entity& Define (Entity&, const Location&);
	Entity& DefineEnumerator (const Identifier&);
	Entity& DefineFunction (const Type&, const Identifier&, const DeclarationSpecifiers&);
	Entity& DefineLabel (const Identifier&, const Statement&);
	Entity& DefineParameter (const Type&, const Identifier&, const DeclarationSpecifiers&);
	Entity& Insert (Entity::Model, const Identifier&, const Type&, Scope&);
	Entity& Predefine (Entity&, const Location&);
	Entity& PredefineStaticArray (const Identifier&, const String&);
	Entity& Redeclare (Entity&, Scope&, const Location&);

	Namespace& DefineNamespace (bool, const Location&);
	Namespace& DefineNamespace (bool, const Identifier&);
	Namespace& Define (Namespace&, bool, const Location&);
	void DefineNamespaceAlias (const Identifier&, Namespace&);

	Array& Insert (const StringLiteral&, const Type&);

	void Normalize (Type&);
	void AdjustParameter (Type&);
	Type GetType (TypeSpecifier&);
	void CheckLabel (const Entity&);
	void TransformParameter (Type&);
	void Check (Initializer&, Variable&);
	void Combine (TypeSpecifier&, Type&);
	void CheckConstant (const Expression&);
	void CheckDiscarded (const Expression&);
	void Set (bool&, const DeclarationSpecifier&);
	void CheckSize (const Type&, const Location&);
	void Check (Parameter&, ParameterDeclaration&);
	void Check (FunctionPrototype&, Function&, bool);
	void CheckFunctionType (const FunctionPrototype&);
	void CheckAlignment (const Type&, const Location&);
	void CheckMain (const Function&, const Identifier&);
	void CheckIncrement (const Expression&, const Operator&);
	void CheckConsistency (const Storage&, Entity&, const Identifier&);
	void Check (ConstVolatileQualifiers&, Lexer::Symbol, const Location&);
	void CheckLanguageLinkage (const Storage&, const Entity&, const Identifier&);
	Declarator& Check (Declarator&, const DeclarationSpecifiers&, Entity& (Context::*) (const Type&, const Identifier&, const DeclarationSpecifiers&));
	Declarator& Check (Declarator&, const Type&, const DeclarationSpecifiers&, Entity& (Context::*) (const Type&, const Identifier&, const DeclarationSpecifiers&));

	void CheckExtended (AlignmentSpecification&);
	void CheckFundamental (AlignmentSpecification&);

	void Assemble (Entity&, Declaration&);

	void StringInitialize (Type&, const Expression&);

	Declarator* DisambiguateEllipsis (Declarator&) const;

	void FoldConstant (Expression&);
	void EvaluateIf (bool, Expression&);
	void Classify (Expression&, const Type&, ValueCategory, bool, bool, bool);

	Unsigned GetSize (const Type&) const;
	Alignment GetAlignment (const Type&) const;

	bool CheckReachability (FunctionBody&);
	bool CheckReachability (StatementBlock&, bool, bool);
	bool CheckReachability (StatementBlock&, ExceptionHandlers&, bool);
	bool CheckReachability (Statement&, bool);

	void ReserveSpace (Parameters&);
	void ReserveBlockSpace (Variable&);
	void ReserveClassSpace (Variable&);
	void ReserveClassSpace (Alignment);
	void ReserveClassSpace (Bits, const Type&, Alignment);
	void ReserveRegisterSpace (Size&, const Type&, const Location&);

	void ConvertArithmetic (Expression&);
	void Convert (Expression&, const Type&, bool = true);
	bool ConvertBoolean (Expression&, const Type&);
	bool ConvertPointer (Expression&, const Type&);
	void ConvertPRValue (Expression&, const Type&);
	void ConvertConstant (Expression&, const Type&);
	bool PromoteIntegral (Expression&, const Type&);
	bool ConvertArithmetic (Expression&, const Type&);
	bool ConvertFloatingPoint (Expression&, const Type&);
	bool PromoteFloatingPoint (Expression&, const Type&);
	bool ConvertMemberPointer (Expression&, const Type&);
	bool ConvertQualification (Expression&, const Type&);
	bool ConvertArrayToPointer (Expression&, const Type&);
	bool ConvertLValueToRValue (Expression&, const Type&);
	bool ConvertIntegral (Expression&, const Type&, bool, bool);
	bool ConvertStandard (Expression&, const Type&, bool, bool);
	bool ConvertFunctionPointer (Expression&, const Type&);
	bool ConvertFunctionToPointer (Expression&, const Type&);
	bool ConvertFloatingIntegral (Expression&, const Type&, bool, bool);
	bool Apply (Conversion, Expression&, const Type&, ValueCategory, bool = true, bool = true);

	void Apply (const AttributeSpecifier&, Class&);
	void Apply (const AttributeSpecifier&, Entity&);
	void Apply (const AttributeSpecifier&, Variable&);
	void Apply (const AttributeSpecifier&, Enumeration&);
	void Apply (const AttributeSpecifier&, AlignmentSpecification&);
	template <typename Structure> void Apply (const AttributeSpecifier&, Structure&);
	template <typename Structure> void Apply (const AttributeSpecifiers&, Structure&);
	void ApplyInvalid [[noreturn]] (const AttributeSpecifier&);

	void Apply (const Attribute&, Class&);
	void Apply (const Attribute&, Entity&);
	void Apply (const Attribute&, Namespace&);
	void Apply (const Attribute&, Statement&);
	void Apply (const Attribute&, Enumerator&);
	void Apply (const Attribute&, Declaration&);
	void Apply (const Attribute&, Deprecation&);
	void Apply (const Attribute&, Enumeration&);
	void Apply (const Attribute&, TranslationUnit&);
	void Apply (const Attribute&, ParameterDeclaration&);
	template <typename Structure> void Apply (const Attribute&, Structure&);
	void ApplyInvalid [[noreturn]] (const Attribute&);

	void Expand (Entities&);
	void Expand (Condition&);
	void Expand (Statement&);
	void Expand (Expression&);
	void Expand (Declaration&);
	void Expand (Initializer&);
	void Expand (FunctionBody&);
	void Expand (InitDeclarator&);
	void Expand (StatementBlock&);
	void ExpandFunctionCall (Expression&);
	template <typename Structure> void Expand (Structure*&);
	template <typename Structure> void Expand (List<Structure>&);
	void Map (const ParameterDeclaration&, const Expression&);
	Entity* MapExpandedParameter (const Entity&);

	Value& Designate (const Entity&) override;
	Value Evaluate (const Expression&) override;
	Value Call (const Function&, Values&&, const Location&) override;

	static void Invalidate (Expression&);
	static void Assign (Expression&, const Value&);
};

#endif // ECS_CPP_CHECKER_CONTEXT_HEADER_INCLUDED

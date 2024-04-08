// C++ function executor
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

#ifndef ECS_CPP_EXECUTOR_HEADER_INCLUDED
#define ECS_CPP_EXECUTOR_HEADER_INCLUDED

#include "cppevaluator.hpp"

class ECS::CPP::Interpreter::Executor : protected Evaluator
{
public:
	Executor (const Interpreter&, TranslationUnit&);

	Value Call (const Function&, Values&&, const Location&) override;

protected:
	void ZeroInitialize (const Variable&);
	void DefaultInitialize (const Variable&);
	void Initialize (const Variable&, const Initializer&);

	Value& Designate (const Entity&) override;

private:
	struct Instruction;
	struct StackFrame;

	TranslationUnit& translationUnit;
	StackFrame* current = nullptr;

	Instruction Execute (const Statement&);
	Instruction Continue (const Statement&);
	Instruction Advance (const Statement&);

	void Execute (const Instruction&);
	void Execute (const Declaration&);
	void Execute (const FunctionBody&);
	void Execute (const InitDeclarator&);

	Value Evaluate (const Condition&);

	void ZeroInitialize (Value&, const Type&);
	void DefaultInitialize (Value&, const Type&);
	void StringInitialize (Value&, const Type&, const Expression&);

	Value Evaluate (const Expression&) override;
};

#endif // ECS_CPP_EXECUTOR_HEADER_INCLUDED

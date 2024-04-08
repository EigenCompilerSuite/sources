// C++ expression evaluator
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

#ifndef ECS_CPP_EVALUATOR_HEADER_INCLUDED
#define ECS_CPP_EVALUATOR_HEADER_INCLUDED

#include "cpp.hpp"
#include "cppinterpreter.hpp"

class ECS::CPP::Interpreter::Evaluator
{
protected:
	struct UndefinedBehavior final {Location location; Message message;};

	const Interpreter& interpreter;

	explicit Evaluator (const Interpreter&);

	void EmitError [[noreturn]] (const Location&, const Message&) const;

	virtual Value Evaluate (const Expression&);

private:
	Value& Dereference (Value&, const Expression&, Signed = 0);
	Value& Designate (const Value&, const Expression&, Signed = 0);

	void Increment (Value&, bool, const Expression&);

	Signed Truncate (Signed, const Expression&);
	template <typename Value> Value Truncate (Value, const Expression&);

	virtual Value& Designate (const Entity&) = 0;
	virtual Value Call (const Function&, Values&&, const Location&) = 0;
};

#endif // ECS_CPP_EVALUATOR_HEADER_INCLUDED

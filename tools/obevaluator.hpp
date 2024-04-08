// Oberon expression evaluator
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

#ifndef ECS_OBERON_EVALUATOR_HEADER_INCLUDED
#define ECS_OBERON_EVALUATOR_HEADER_INCLUDED

#include "oberon.hpp"
#include "diagnostics.hpp"
#include "obinterpreter.hpp"

class ECS::Oberon::Interpreter::Evaluator
{
protected:
	const Interpreter& interpreter;

	explicit Evaluator (const Interpreter&);

	virtual void EmitError [[noreturn]] (const Position&, const Message&) const = 0;

	String EvaluateString (const Expression&);
	Value Evaluate (Object&, const Expression&);
	Value EvaluateArgument (const Expression&, Size);
	Value EvaluateArgument (const Expression&, Size, const Value&);
	Set::Element EvaluateElement (const Expression&, const Type&);

	Object& Dereference (const Value&, const Expression&);

	virtual Value Evaluate (const Expression&);
	virtual Value CallExternal (const Declaration&, const Expression&);
	virtual Value CallPredeclared (const Declaration&, const Expression&);

	static Value Truncate (const Value&, const Type&);

private:
	Set::Range EvaluateRange (const Expression&, const Type&);

	#define FUNCTION(scope, function, name) Value Call##function (const Expression&);
	#include "oberon.def"

	virtual Value Call (const Declaration&, const Expression&, Object*) = 0;

	template <typename Basic, typename> static Basic Convert (const Value&);
};

#endif // ECS_OBERON_EVALUATOR_HEADER_INCLUDED

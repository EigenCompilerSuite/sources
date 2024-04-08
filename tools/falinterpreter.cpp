// FALSE interpreter
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

#include "diagnostics.hpp"
#include "environment.hpp"
#include "error.hpp"
#include "falinterpreter.hpp"
#include "false.hpp"

#include <cassert>

using namespace ECS;
using namespace FALSE;

using Value = struct Interpreter::Value
{
	enum Type {Void, Integer, Variable, Function};

	Type type = Void;

	union
	{
		FALSE::Integer integer;
		Value* variable;
		const FALSE::Function* function;
	};

	Value () = default;
	Value (FALSE::Integer);
	Value (Value*);
	Value (const FALSE::Function*);

	bool operator == (const Value&) const;
};

using Context = class Interpreter::Context
{
public:
	Context (const Interpreter&, Environment&);

	Integer Interpret (const Program&);

private:
	const Interpreter& interpreter;
	Environment& environment;
	const Source* source;
	std::vector<Value> stack;
	Value variables[26];

	void Interpret (const Function&);
	void Interpret (const Element&);

	void Push (const Value&);
	Value Pop (const Element&);
	Integer PopInteger (const Element&);
	Value& PopVariable (const Element&);
	const Function& PopFunction (const Element&);

	void EmitError [[noreturn]] (const Element&, const char*) const;
};

Interpreter::Interpreter (Diagnostics& d) :
	diagnostics {d}
{
}

Integer Interpreter::Execute (const Program& program, Environment& environment) const
{
	return Context {*this, environment}.Interpret (program);
}

Integer Interpreter::Execute (const Programs& programs, Environment& environment) const
{
	Context context {*this, environment}; for (auto& program: programs) if (const auto status = context.Interpret (program)) return status; return 0;
}

Context::Context (const Interpreter& i, Environment& e) :
	interpreter {i}, environment {e}
{
}

Integer Context::Interpret (const Program& program)
{
	source = &program.source; Push (0); Interpret (program.main); return PopInteger (program.main.back ());
}

void Context::Interpret (const Function& function)
{
	for (auto& element: function) Interpret (element);
}

void Context::Interpret (const Element& element)
{
	switch (element.symbol)
	{
	case Lexer::Assign: {auto& variable = PopVariable (element); variable = Pop (element); break;}
	case Lexer::Call: Interpret (PopFunction (element)); break;
	case Lexer::If: {auto& function = PopFunction (element); if (PopInteger (element)) Interpret (function); break;}
	case Lexer::While: {auto &function = PopFunction (element), &condition = PopFunction (element); while (Interpret (condition), PopInteger (element)) Interpret (function); break;}
	case Lexer::Write: environment.Fputs (std::to_string (PopInteger (element)), environment.stdout_); break;
	case Lexer::Put: environment.Putchar (PopInteger (element)); break;
	case Lexer::Get: Push (environment.Getchar ()); break;
	case Lexer::Flush: environment.Fflush (environment.stdout_); break;
	case Lexer::Dereference: Push (PopVariable (element)); break;
	case Lexer::BeginFunction: Push (element.function); break;
	case Lexer::Negate: Push (-PopInteger (element)); break;
	case Lexer::Add: {const auto value = PopInteger (element); Push (PopInteger (element) + value); break;}
	case Lexer::Subtract: {const auto value = PopInteger (element); Push (PopInteger (element) - value); break;}
	case Lexer::Multiply: {const auto value = PopInteger (element); Push (PopInteger (element) * value); break;}
	case Lexer::Divide: {const auto value = PopInteger (element); Push (PopInteger (element) / value); break;}
	case Lexer::Not: Push (!PopInteger (element)); break;
	case Lexer::And: {const auto value = PopInteger (element); Push (PopInteger (element) && value); break;}
	case Lexer::Or: {const auto value = PopInteger (element); Push (PopInteger (element) || value); break;}
	case Lexer::Equal: {const auto value = Pop (element); Push (Pop (element) == value); break;}
	case Lexer::Greater: {const auto value = PopInteger (element); Push (PopInteger (element) > value); break;}
	case Lexer::Duplicate: Push (stack.back ()); break;
	case Lexer::Delete: Pop (element); break;
	case Lexer::Swap: {const auto object1 = Pop (element), object2 = Pop (element); Push (object1); Push (object2); break;}
	case Lexer::Rotate: {const auto object1 = Pop (element), object2 = Pop (element), object3 (Pop (element)); Push (object2); Push (object1); Push (object3); break;}
	case Lexer::Select: {const auto selection = PopInteger (element); if (selection >= Integer (stack.size ())) EmitError (element, "invalid selection"); Push (stack[stack.size () - selection - 1]); break;}
	case Lexer::Integer: Push (element.integer); break;
	case Lexer::Character: Push (Integer (element.character)); break;
	case Lexer::Variable: Push (variables + element.character - 'a'); break;
	case Lexer::String: environment.Fputs (element.string, environment.stdout_); break;
	case Lexer::ExternalVariable: EmitError (element, "extern variables not supported");
	case Lexer::ExternalFunction: EmitError (element, "extern functions not supported");
	case Lexer::Assembly: EmitError (element, "inline assembly not supported");
	default: assert (Lexer::Unreachable);
	}
}

void Context::Push (const Value& value)
{
	stack.push_back (value);
}

Value Context::Pop (const Element& element)
{
	if (stack.empty ()) EmitError (element, "stack empty");
	const auto value = stack.back (); stack.pop_back (); return value;
}

Integer Context::PopInteger (const Element& element)
{
	const auto value = Pop (element); if (value.type != Value::Integer) EmitError (element, "stack top not an integer"); return value.integer;
}

Value& Context::PopVariable (const Element& element)
{
	const auto value = Pop (element); if (value.type != Value::Variable) EmitError (element, "stack top not a variable"); return *value.variable;
}

const Function& Context::PopFunction (const Element& element)
{
	const auto value = Pop (element); if (value.type != Value::Function) EmitError (element, "stack top not a function"); return *value.function;
}

void Context::EmitError (const Element& element, const char*const message) const
{
	interpreter.diagnostics.Emit (Diagnostics::Error, *source, element.position, message); throw Error {};
}

Value::Value (const FALSE::Integer i) :
	type {Integer}, integer {i}
{
}

Value::Value (Value*const v) :
	type {Variable}, variable {v}
{
}

Value::Value (const FALSE::Function*const f) :
	type {Function}, function {f}
{
}

bool Value::operator == (const Value& other) const
{
	return type == other.type && (type == Integer && integer == other.integer || type == Variable && variable == other.variable || type == Function && function == other.function);
}

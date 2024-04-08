(* Generic generators
Copyright (C) Florian Negele

This file is part of the Eigen Compiler Suite.

The ECS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The ECS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of the GNU General Public License version 3,
the copyright holder grants you additional permissions to use
this file as described in the ECS Runtime Support Exception.

You should have received a copy of the GNU General Public License
and a copy of the ECS Runtime Support Exception along with
the ECS.  If not, see <https://www.gnu.org/licenses/>. *)

(** The module {{{Generators}}} provides restricted coroutines that transfer control back to their callers multiple times. *)
MODULE Generators IN OBL;

IMPORT Coroutines IN OBL;

TYPE Caller = RECORD- (Coroutines.Coroutine) END;

(** Represents a coroutine that may return multiple times to its caller. *)
TYPE Generator* = RECORD* (Coroutines.Coroutine) caller: Caller; yielded: BOOLEAN END;

PROCEDURE- (VAR caller: Caller) Call;
BEGIN IGNORE (caller);
END Call;

(** Waits from a call to the generator to return. *)
(** The result indicates whether the generator yielded and thus will return again. *)
PROCEDURE- (VAR generator: Generator) Await* (): BOOLEAN;
BEGIN
	generator.yielded := FALSE;
	generator.caller.Transfer (generator);
	RETURN generator.yielded;
END Await;

(** Returns to the caller of the generator. *)
PROCEDURE- (VAR generator: Generator) Yield*;
BEGIN
	generator.yielded := TRUE;
	generator.Transfer (generator.caller);
END Yield;

END Generators.

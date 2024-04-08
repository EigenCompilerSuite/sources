(* Non-preemptive threads
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

(** Module Coroutines provides non-preemptive threads each with its own stack but otherwise sharing a common address space. *)
(** Coroutines can explicitly transfer control to other coroutines which are then resumed from the point where they did their last transfer of control. *)
MODULE Coroutines;

IMPORT Coroutines IN OBL;

(** Represents the body of a coroutine. *)
TYPE Body* = PROCEDURE;

TYPE Wrapper = RECORD- (Coroutines.Coroutine) body: Body END;

(** Represents a coroutine. *)
TYPE Coroutine* = RECORD wrapper: Wrapper END;

PROCEDURE (VAR coroutine: Wrapper) Call;
BEGIN coroutine.body; HALT (1);
END Call;

(** Creates and initialises a new coroutine with a specified stack size and body provided as a procedure. *)
(** An initialised coroutine can be started by a {{{[[Coroutines.Transfer|Transfer]]}}} to it. *)
(** In this case its execution will start at the first instruction of its body which must never return. *)
PROCEDURE Init* (body: Body; stackSize: LONGINT; VAR cor: Coroutine);
BEGIN cor.wrapper.body := body; IGNORE (stackSize);
END Init;

(** Transfers control from the currently executing coroutine to another one. *)
(** The state of the currently executing coroutine is saved. *)
(** When control is transferred back later, the coroutine will be restarted in the saved state. *)
PROCEDURE Transfer* (VAR from, to: Coroutine);
BEGIN from.wrapper.Transfer (to.wrapper);
END Transfer;

END Coroutines.

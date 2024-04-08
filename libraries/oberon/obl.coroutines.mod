(* Generic coroutines
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

(** The module {{{Coroutines}}} provides non-preemptive coroutines that share a common address space. *)
(** Coroutines can explicitly transfer control to other coroutines which are then resumed from their last transfer of control. *)
MODULE Coroutines IN OBL;

IMPORT SYSTEM, Exceptions IN OBL;

(** Represents a non-preemptive coroutine. *)
TYPE Coroutine* = RECORD* frame, stack: SYSTEM.PTR END;

(** Starts the operation of the coroutine. *)
(** This abstract procedure is called by the first transfer to the coroutine. *)
PROCEDURE* (VAR coroutine: Coroutine) Call*;

(** Transfers control from the currently executing coroutine to {{{target}}}. *)
(** This procedure may raise an exception of type {{{[[OBL:Exceptions.AllocationFailure|AllocationFailure]]}}}. *)
PROCEDURE- (VAR coroutine: Coroutine) Transfer* (VAR target: Coroutine);
CONST StackSize = ASH (16, SIZE (INTEGER) + SIZE (LENGTH));
VAR pointer: SYSTEM.PTR; exception: Exceptions.AllocationFailure;
BEGIN
	SYSTEM.CODE ("mov ptr [$fp + pointer], ptr $fp");
	coroutine.frame := pointer;
	IF target.frame = NIL THEN
		SYSTEM.NEW (target.stack, StackSize);
		pointer := target.stack;
		IF pointer = NIL THEN exception.Raise END;
		SYSTEM.CODE ("add ptr $sp, ptr [$fp + pointer], ptr StackSize - stackdisp");
		target.Call;
		SYSTEM.CODE ("mov ptr $sp, ptr $fp + exception - stackdisp");
		SYSTEM.DISPOSE (target.stack);
		target.frame := NIL;
	ELSE
		pointer := target.frame;
		SYSTEM.CODE ("mov ptr $fp, ptr [$fp + pointer]");
	END;
END Transfer;

END Coroutines.

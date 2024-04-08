(* Generic exception handling
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

(** The module {{{Exceptions}}} provides a generic exception handling facility. *)
(** Exceptions are extensions of {{{[[OBL:Exceptions.Exception|Exception]]}}} and should only be used as the type of local variables. *)
(** @remarks Exceptions are handled by calling {{{[[OBL:Exceptions.Exception.Try|Try]]}}} on a local variable in the guard of an if statement. *)
(** This procedure initially returns {{{TRUE}}} such that the guarded statement sequence of the if statement is executed. *)
(** If this sequence directly or indirectly calls {{{[[OBL:Exceptions.Exception.Raise|Raise]]}}} on an exception of the same type or an extension thereof, the procedure returns again with the value {{{FALSE}}} such that the execution resumes in the {{{ELSE}}} part of the if statement. *)
(** Otherwise the exception stays registered for exception handling until {{{[[OBL:Exceptions.Exception.End|End]]}}} is called, typically at the end of the guarded statement sequence. *)
MODULE Exceptions IN OBL;

IMPORT SYSTEM;

TYPE Variable = POINTER TO Exception;
TYPE Descriptor = RECORD- size: LENGTH; table: ARRAY 8 OF POINTER TO - Descriptor END;

(** Represents a generic exception that can be raised and handled. *)
TYPE Exception* = RECORD* previous: Variable; descriptor: POINTER TO - Descriptor; stack, frame: SYSTEM.PTR; caller: PROCEDURE END;

(** Represents a memory allocation failure exception. *)
TYPE AllocationFailure* = RECORD- (Exception) END;

VAR current: Variable;

PROCEDURE (VAR descriptor-: Descriptor) Extends (base-: POINTER TO - Descriptor): BOOLEAN;
VAR index: LENGTH; BEGIN FOR index := 1 TO LEN (descriptor.table) - 1 DO IF descriptor.table[index] = base THEN RETURN TRUE END END; RETURN FALSE;
END Extends;

(** Registers {{{exception}}} for exception handling and returns {{{TRUE}}}. *)
(** Raising an exception of the same or an extended type transfers control to the most current call of this procedure and returns {{{FALSE}}}. *)
(** Exceptions should be registered in the guard of an if statement and handled in its {{{ELSE}}} part. *)
PROCEDURE- (VAR exception: Exception) Try* (): BOOLEAN;
VAR descriptor: POINTER TO - Descriptor; stack, frame: SYSTEM.PTR; caller: PROCEDURE;
BEGIN
	SYSTEM.CODE ("mov ptr [$fp + descriptor], ptr [$fp + exception + ptralign]");
	SYSTEM.CODE ("mov ptr [$fp + stack], ptr $fp");
	SYSTEM.CODE ("mov ptr [$fp + frame], ptr [$fp + stackdisp]");
	SYSTEM.CODE ("mov fun [$fp + caller], fun [$fp + ptralign + stackdisp]");
	exception.previous := current;
	exception.descriptor := descriptor;
	exception.stack := stack;
	exception.frame := frame;
	exception.caller := caller;
	current := SYSTEM.VAL (Variable, SYSTEM.ADR (exception));
	RETURN TRUE;
END Try;

(** Unregisters {{{exception}}} from exception handling. *)
(** Exceptions should be unregistered before leaving the guarded statement sequence of the if statement that registers and handles them. *)
PROCEDURE- (VAR exception: Exception) End*;
BEGIN current := exception.previous;
END End;

(** Resumes control at the most current registration of an exception of the same or a base type and copies the value of {{{exception}}} to the corresponding variable. *)
PROCEDURE- (VAR exception-: Exception) Raise*;
VAR descriptor: POINTER TO - Descriptor; stack, frame: SYSTEM.PTR; caller: PROCEDURE;
BEGIN
	SYSTEM.CODE ("mov ptr [$fp + descriptor], ptr [$fp + exception + ptralign]");
	WHILE ~descriptor.Extends (current.descriptor) DO current := current.previous END;
	SYSTEM.MOVE (SYSTEM.ADR (exception) + SIZE (Exception), SYSTEM.ADR (current^) + SIZE (Exception), current.descriptor.size - SIZE (Exception));
	stack := current.stack;
	frame := current.frame;
	caller := current.caller;
	current := current.previous;
	SYSTEM.CODE ("mov ptr $sp, ptr [$fp + stack]");
	SYSTEM.CODE ("mov ptr [$sp + stackdisp], ptr [$fp + frame]");
	SYSTEM.CODE ("mov fun [$sp + ptralign + stackdisp], fun [$fp + caller]");
	SYSTEM.CODE ("mov ptr $fp, ptr $sp");
	SYSTEM.CODE ("mov u1 $res, u1 0");
END Raise;

END Exceptions.

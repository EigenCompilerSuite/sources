(* Basic type operations
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

(** The generic module {{{BasicTypes}}} provides utility operations for basic types. *)
(** @@Value The underlying basic type for all operations. *)
MODULE BasicTypes (Value*) IN OBL;

IMPORT Hashes IN OBL;

(** Indicates whether the basic type is a boolean type. *)
CONST IsBoolean* = Value IS BOOLEAN;

(** Indicates whether the basic type is a character type. *)
CONST IsCharacter* = Value IS CHAR;

(** Indicates whether the basic type is a signed integer type. *)
CONST IsSignedInteger* = (Value IS SIGNED8) OR (Value IS SIGNED16) OR (Value IS SIGNED32) OR (Value IS SIGNED64);

(** Indicates whether the basic type is an unsigned integer type. *)
CONST IsUnsignedInteger* = (Value IS UNSIGNED8) OR (Value IS UNSIGNED16) OR (Value IS UNSIGNED32) OR (Value IS UNSIGNED64);

(** Indicates whether the basic type is an integer type. *)
CONST IsInteger* = IsSignedInteger OR IsUnsignedInteger;

(** Indicates whether the basic type is a real type. *)
CONST IsReal* = (Value IS REAL32) OR (Value IS REAL64);

(** Indicates whether the basic type is a numeric type. *)
CONST IsNumeric* = IsInteger OR IsReal;

(** Indicates whether the basic type is a set type. *)
CONST IsSet* = (Value IS SET8) OR (Value IS SET16) OR (Value IS SET32) OR (Value IS SET64);

(** Returns whether {{{x}}} is equal to {{{y}. *)
PROCEDURE IsEqual* (x-, y-: Value): BOOLEAN;
BEGIN RETURN x = y;
END IsEqual;

(** Returns whether {{{x}}} is not equal to {{{y}. *)
PROCEDURE IsNotEqual* (x-, y-: Value): BOOLEAN;
BEGIN RETURN x # y;
END IsNotEqual;

(** Returns whether {{{x}}} is less than {{{y}. *)
PROCEDURE IsLessThan* (x-, y-: Value): BOOLEAN;
BEGIN RETURN x < y;
END IsLessThan;

(** Returns whether {{{x}}} is less than or equal to {{{y}. *)
PROCEDURE IsLessOrEqual* (x-, y-: Value): BOOLEAN;
BEGIN RETURN x <= y;
END IsLessOrEqual;

(** Returns whether {{{x}}} is greater than {{{y}. *)
PROCEDURE IsGreaterThan* (x-, y-: Value): BOOLEAN;
BEGIN RETURN x > y;
END IsGreaterThan;

(** Returns whether {{{x}}} is greater than or equal to {{{y}. *)
PROCEDURE IsGreaterOrEqual* (x-, y-: Value): BOOLEAN;
BEGIN RETURN x >= y;
END IsGreaterOrEqual;

(** Swaps the values of two variables. *)
PROCEDURE Swap* (VAR first, second: Value);
VAR temporary: Value;
BEGIN temporary := first; first := second; second := temporary;
END Swap;

(** Returns a hash value for the specified value. *)
PROCEDURE Hash* (value-: Value): LENGTH;
BEGIN RETURN SEL (IsReal OR (SIZE (Value) > SIZE (LENGTH)), Hashes.Hash (value), LENGTH (value));
END Hash;

END BasicTypes.

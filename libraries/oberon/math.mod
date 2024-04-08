(* General purpose functions using REAL arithmetic
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

(** The module {{{Math}}} provides a basic set of general purpose functions using {{{REAL}}} arithmetic. *)
MODULE Math;

IMPORT Math (REAL) IN OBL;

(** The ratio of the circumference of a circle to its diameter. *)
CONST pi* = REAL (Math.Pi);

(** The base of natural logarithms. *)
CONST e* = REAL (Math.E);

(** Returns the square root of //x//, where //x// must be positive. *)
PROCEDURE sqrt* (x: REAL): REAL;
BEGIN RETURN Math.Sqrt (x);
END sqrt;

END Math.

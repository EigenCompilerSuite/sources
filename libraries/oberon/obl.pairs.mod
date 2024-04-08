(* Generic pairs
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

(** The generic module {{{pairs}}} provides a way of storing a pair of values with different type. *)
(** @@First The type of the first value in a pair. *)
(** @@Second The type of the second value in a pair. *)
MODULE Pairs (First*, Second*) IN OBL;

(** Represents a pair of values. *)
TYPE Pair* = RECORD- first*: First; second*: Second END;

(** Creates a pair with the given values. *)
PROCEDURE Make* (first-: First; second-: Second): Pair;
VAR pair: Pair;
BEGIN pair.first := first; pair.second := second; RETURN pair;
END Make;

END Pairs.

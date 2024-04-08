(* Generic set types
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

(** The generic module {{{Sets}}} provides set types of arbitrary sizes. *)
(** @@Size The maximal number of different integers in a set. *)
MODULE Sets (Size*) IN OBL;

(** The minimal element of a set. *)
CONST Minimum* = Size - Size;

(** The maximal element of a set. *)
CONST Maximum* = Size - 1;

CONST Elements = MAX (SET) - MIN (SET) + 1;
CONST Mask = {0 .. (Size - 1) MOD Elements};
CONST Sets = (Size + Elements - 1) DIV Elements;

(** Set of integers between {{{[[OBL:Sets.Minimum|Minimum]]}}} and {{{[[OBL:Sets.Maximum|Maximum]]}}}. *)
TYPE Set* = RECORD- array: ARRAY Sets OF SET END;

(** Removes all integers from the set. *)
PROCEDURE (VAR set: Set) Clear*;
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 1 DO set.array[i] := {} END;
END Clear;

(** Adds all integers to the set. *)
PROCEDURE (VAR set: Set) Set*;
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 1 DO set.array[i] := -{} END;
END Set;

(** Counts all integers in the set. *)
PROCEDURE (VAR set-: Set) Count* (): LENGTH;
VAR count, element: LENGTH;
BEGIN count := 0; FOR element := Minimum TO Maximum DO INC (count, LENGTH (element MOD Elements IN set.array[element DIV Elements])) END; RETURN count;
END Count;

(** Computes the complement of the set. *)
PROCEDURE (VAR set: Set) Complement*;
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 1 DO set.array[i] := -set.array[i] END;
END Complement;

(** Returns whether the set is empty. *)
PROCEDURE (VAR set-: Set) IsEmpty* (): BOOLEAN;
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 2 DO IF set.array[i] # {} THEN RETURN FALSE END END; RETURN set.array[Sets - 1] * Mask = {};
END IsEmpty;

(** Computes the union of the set with another set. *)
PROCEDURE (VAR set: Set) Add* (other-: Set);
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 1 DO set.array[i] := set.array[i] + other.array[i] END;
END Add;

(** Computes the difference of the set with another set. *)
PROCEDURE (VAR set: Set) Subtract* (other-: Set);
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 1 DO set.array[i] := set.array[i] - other.array[i] END;
END Subtract;

(** Computes the intersection of the set with another set. *)
PROCEDURE (VAR set: Set) Intersect* (other-: Set);
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 1 DO set.array[i] := set.array[i] * other.array[i] END;
END Intersect;

(** Computes the symmetric difference of the set with another set. *)
PROCEDURE (VAR set: Set) Differ* (other-: Set);
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 1 DO set.array[i] := set.array[i] / other.array[i] END;
END Differ;

(** Returns whether the set equals another set. *)
PROCEDURE (VAR set-: Set) Equals* (other-: Set): BOOLEAN;
VAR i: LENGTH;
BEGIN FOR i := 0 TO Sets - 2 DO IF set.array[i] # other.array[i] THEN RETURN FALSE END END; RETURN set.array[Sets - 1] * Mask = other.array[Sets - 1] * Mask;
END Equals;

(** Includes an integer in the set. *)
PROCEDURE (VAR set: Set) Include* (element: LENGTH);
BEGIN INCL (set.array[element DIV Elements], element MOD Elements);
END Include;

(** Excludes an integer from the set. *)
PROCEDURE (VAR set: Set) Exclude* (element: LENGTH);
BEGIN EXCL (set.array[element DIV Elements], element MOD Elements);
END Exclude;

(** Returns whether an integer is element of the set. *)
PROCEDURE (VAR set-: Set) Test* (element: LENGTH): BOOLEAN;
BEGIN RETURN element MOD Elements IN set.array[element DIV Elements];
END Test;

(** Exchanges the contents of a set with that of another one. *)
PROCEDURE Swap* (VAR first, second: Set);
VAR i: LENGTH; set: SET;
BEGIN FOR i := 0 TO Sets - 1 DO set := first.array[i]; first.array[i] := second.array[i]; second.array[i] := set END;
END Swap;

END Sets.

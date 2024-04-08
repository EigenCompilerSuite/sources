(* Operations on strings
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

(** Module {{{Strings}}} provides a set of operations on string constants and character arrays, both of which contain the character {{{0X}}} as a terminator. *)
(* All positions in strings start at 0. *)
MODULE Strings;

IMPORT Strings (CHAR) IN OBL;

(** Returns the number of characters in //s// up to and excluding the first 0X. *)
PROCEDURE Length* (s: ARRAY OF CHAR): INTEGER;
BEGIN RETURN INTEGER (Strings.GetLength (s));
END Length;

(** Replaces each lower case letter within //s// by its upper case equivalent. *)
PROCEDURE Cap* (VAR s: ARRAY OF CHAR);
VAR position: LENGTH;
BEGIN position := 0; WHILE s[position] # 0X DO s[position] := CAP (s[position]); INC (position) END;
END Cap;

END Strings.

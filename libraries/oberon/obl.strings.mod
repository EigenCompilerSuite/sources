(* Runtime support for strings
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

(** The generic module {{{Strings}}} provides utility procedures for strings that are represented by arrays of type {{{[[OBL:Strings.Char|Char]]}}}. *)
(** All of the following procedures operate on the length of a string which is equal to the index of the first null character in the character array. *)
(** @@Char The element type of a character array. *)
MODULE Strings (Char*) IN OBL;

CONST Null = Char (0);

(** Returns {{{TRUE}}} if the length of the string is zero. *)
PROCEDURE IsEmpty* (string-: ARRAY OF Char): BOOLEAN;
BEGIN RETURN string[0] = Null;
END IsEmpty;

(** Returns the length of the string. *)
(** The length of a string equals to the index of the first null character in the character array. *)
PROCEDURE GetLength* (string-: ARRAY OF Char): LENGTH;
VAR length: LENGTH;
BEGIN length := 0; WHILE string[length] # Null DO INC (length) END; RETURN length;
END GetLength;

(** Truncates the contents of a string by shortening its length. *)
PROCEDURE Truncate* (VAR string: ARRAY OF Char; length: LENGTH);
BEGIN string[length] := Null;
END Truncate;

(** Returns {{{TRUE}}} if it finds a certain character in a string beginning at a given position. *)
PROCEDURE FindCharacter* (value: Char; string-: ARRAY OF Char; VAR pos: LENGTH): BOOLEAN;
VAR char: Char;
BEGIN pos := 0; REPEAT char := string[pos]; IF char = value THEN RETURN TRUE END; INC (pos) UNTIL char = Null; RETURN FALSE;
END FindCharacter;

(** This procedure compares two strings lexicographically. *)
(** It returns {{{-1}}} if the first string is lexicographically less than the second one. *)
(** It returns {{{+1}}} if the first string is lexicographically greater than the second one. *)
(** If they compare equal, this procedure returns zero. *)
PROCEDURE Compare* (string1-, string2-: ARRAY OF Char): INTEGER;
VAR i: LENGTH; char1, char2: Char;
BEGIN i := 0; REPEAT char1 := string1[i]; char2 := string2[i]; INC (i) UNTIL (char1 # char2) OR (char1 = Null);
	IF char1 < char2 THEN RETURN -1 END; IF char1 > char2 THEN RETURN +1 END; RETURN 0;
END Compare;

(** Copies some characters of a string into another one starting at a given position in the source string. *)
(** The length of the destination array may not be less than the given length. *)
PROCEDURE Copy* (source-: ARRAY OF Char; VAR dest: ARRAY OF Char; pos: LENGTH; length: LENGTH);
BEGIN dest[length] := Null; WHILE length # 0 DO DEC (length); dest[length] := source[pos + length] END;
END Copy;

(** Appends a string to another one. *)
(** The length of the destination array may not be less than the length of the string it contains plus the length of the appendix. *)
PROCEDURE Concatenate* (VAR string: ARRAY OF Char; appendix-: ARRAY OF Char);
VAR i, j: LENGTH; char: Char;
BEGIN i := GetLength (string); j := 0; LOOP char := appendix[j]; string[i] := char; IF char = Null THEN EXIT END; INC (i); INC (j) END;
END Concatenate;

END Strings.

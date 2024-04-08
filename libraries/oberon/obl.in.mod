(* Standard Oberon input
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

(** The module {{{In}}} provides utility procedures to read values of basic type from the standard input stream. *)
MODULE In IN OBL;

IMPORT SYSTEM;

VAR peek: CHAR;

(** A Boolean value indicating whether the last input operation was successful. *)
VAR Done-: BOOLEAN;

PROCEDURE ^ Getchar ["getchar"] (): INTEGER;

(** Returns the next available character without removing it from the standard input stream. *)
(** If there are no more characters available the result value is {{{0X}}}. *)
PROCEDURE Peek* (): CHAR;
VAR character: INTEGER;
BEGIN IF (peek = 0X) THEN character := Getchar (); Done := character # -1; IF Done THEN peek := CHR (character) END END; RETURN peek;
END Peek;

(** Reads a character from the standard input stream without returning its value. *)
PROCEDURE Ignore*;
BEGIN IF Peek () # 0X THEN peek := 0X END;
END Ignore;

PROCEDURE IsSpace (char: CHAR): BOOLEAN;
BEGIN RETURN (char = ' ') OR (ORD (char) >= ORD (09X)) & (ORD (char) <= ORD (0DX));
END IsSpace;

PROCEDURE IsDigit (char: CHAR): BOOLEAN;
BEGIN RETURN (ORD (char) >= ORD ('0')) & (ORD (char) <= ORD ('9'));
END IsDigit;

(** Skips all space characters. *)
(** This does not include new-line characters. *)
PROCEDURE SkipSpace*;
BEGIN WHILE IsSpace (Peek ()) DO Ignore END;
END SkipSpace;

(** Skips all white-space characters. *)
(** This includes new-line characters. *)
PROCEDURE SkipWhiteSpace*;
BEGIN WHILE IsSpace (Peek ()) & (Peek () # 0AX) DO Ignore END;
END SkipWhiteSpace;

(** Skips the contents of the current line until the next new-line character. *)
PROCEDURE SkipLn*;
BEGIN WHILE Peek () # 0AX DO Ignore END; Ignore;
END SkipLn;

(** Reads a character value from the standard input stream. *)
PROCEDURE Char* (VAR char: CHAR);
BEGIN SkipSpace; char := Peek (); Ignore;
END Char;

(** Reads a string value value from the standard input stream. *)
(** The number of read characters equals the length of the string but does not exceed the array length. *)
PROCEDURE String* (VAR string: ARRAY OF CHAR);
VAR i: LENGTH;
BEGIN SkipSpace; i := 0; WHILE (i # LEN (string) - 1) & ~IsSpace (Peek ()) & Done DO Char (string[i]); INC (i) END; string[i] := 0X;
END String;

(** Reads an integer value from the standard input stream. *)
PROCEDURE Integer* (VAR value: INTEGER);
VAR sign: INTEGER;
BEGIN
	SkipSpace; IF Peek () = '-' THEN sign := -1; Ignore ELSE sign := 1 END; Done := IsDigit (Peek ()); value := 0;
	WHILE IsDigit (Peek ()) DO value := value * 10 + ORD (Peek ()) - ORD ('0'); Ignore END; value := value * sign;
END Integer;

END In.

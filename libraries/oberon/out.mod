(* Basic routines for formatted output
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

(** The module {{{Out}}} provides a set of basic routines for formatted output of characters, numbers, and strings. *)
MODULE Out;

IMPORT SYSTEM;

CONST LN = 10; Space = 32; Plus = 43; Minus = 45; Dot = 46; Zero = 48; D = 68; E = 69;

PROCEDURE ^ PutChar ["putchar"] (character: INTEGER): INTEGER;

(** Initializes the output stream. *)
PROCEDURE Open*;
END Open;

(** Writes the character to the end of the output stream. *)
PROCEDURE Char* (ch: CHAR);
BEGIN IGNORE (PutChar (ORD (ch)));
END Char;

(** Writes the null-terminated character sequence to the end of the output stream. *)
PROCEDURE String* (str: ARRAY OF CHAR);
VAR index: LENGTH; character: CHAR;
BEGIN index := 0; LOOP character := str[index]; IF character = 0X THEN EXIT END; IGNORE (PutChar (ORD (character))); INC (index) END;
END String;

PROCEDURE Integer (i, n: LONGINT; fill: INTEGER);
VAR index: LENGTH; digits: ARRAY 19 OF CHAR;
BEGIN
	IF i < 0 THEN IGNORE (PutChar (Minus)); i := -i END;
	index := 0; REPEAT digits[index] := CHR (i MOD 10 + Zero); i := i DIV 10; INC (index) UNTIL i = 0;
	WHILE n > index DO IGNORE (PutChar (fill)); DEC (n) END;
	WHILE index # 0 DO DEC (index); IGNORE (PutChar (ORD (digits[index]))) END;
END Integer;

(** Writes the integer number to the end of the output stream padded with the specified number of spaces at the left end. *)
PROCEDURE Int* (i, n: LONGINT);
BEGIN Integer (i, n, Space);
END Int;

(** Writes the real number to the end of the output stream using an exponential form padded with the specified number of spaces at the left end. *)
PROCEDURE Real* (x: REAL; n: INTEGER);
VAR exponent: INTEGER;
BEGIN
	IF x < 0 THEN IGNORE (PutChar (Minus)); x := -x; DEC (n) END;
	exponent := 0; WHILE x >= 10 DO INC (exponent); x := x * 0.1 END; IF x > 0 THEN WHILE x < 1 DO DEC (exponent); x := x * 10 END END;
	Integer (ENTIER (x), n - 9, Space); IGNORE (PutChar (Dot)); Integer (ENTIER (x * 1000) MOD 1000, 3, Zero);
	IGNORE (PutChar (E)); IF exponent >= 0 THEN IGNORE (PutChar (Plus)) END; Integer (exponent, 3, Zero);
END Real;

(** Writes the long real number to the end of the output stream using an exponential form padded with the specified number of spaces at the left end. *)
PROCEDURE LongReal* (x: LONGREAL; n: INTEGER);
VAR exponent: INTEGER;
BEGIN
	IF x < 0 THEN IGNORE (PutChar (Minus)); x := -x; DEC (n) END;
	exponent := 0; WHILE x >= 10 DO INC (exponent); x := x * 0.1 END; IF x > 0 THEN WHILE x < 1 DO DEC (exponent); x := x * 10 END END;
	Integer (ENTIER (x), n - 9, Space); IGNORE (PutChar (Dot)); Integer (ENTIER (x * 1000) MOD 1000, 3, Zero);
	IGNORE (PutChar (D)); IF exponent >= 0 THEN IGNORE (PutChar (Plus)) END; Integer (exponent, 3, Zero);
END LongReal;

(** Writes an end-of-line character to the end of the output stream. *)
PROCEDURE Ln*;
BEGIN IGNORE (PutChar (LN));
END Ln;

END Out.

(* Basic routines for formatted input
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

(** The module {{{In}}} provides a set of basic routines for formatted input of characters, character sequences, numbers, and names. *)
(** All operations except {{{[[In.Char|Char]]}}} skip leading blanks, tabs or end-of-line characters. *)
MODULE In;

IMPORT SYSTEM;

CONST TAB = 9; LN = 10; CR = 13; Space = 32; Quotes = 34; Plus = 43; Minus = 45; Dot = 46; Zero = 48; Nine = 57; D = 68; E = 69;

VAR peek: INTEGER;

(** Indicates the success of the last input operation. *)
VAR Done-: BOOLEAN;

PROCEDURE ^ GetChar ["getchar"] (): INTEGER;

(** Sets the current position to the beginning of the input stream. *)
PROCEDURE Open*;
BEGIN peek := GetChar (); Done := peek >= 0;
END Open;

(** Returns the character at the current position. *)
PROCEDURE Char* (VAR ch: CHAR);
BEGIN Done := peek >= 0; IF Done THEN ch := CHR (peek); peek := GetChar () END;
END Char;

PROCEDURE SkipSpace;
BEGIN WHILE (peek = TAB) OR (peek = LN) OR (peek = CR) OR (peek = Space) DO peek := GetChar () END;
END SkipSpace;

(** Returns the integer constant at the current position. *)
PROCEDURE Int* (VAR i: INTEGER);
BEGIN SkipSpace; Done := (peek >= Zero) & (peek <= Nine); IF Done THEN i := 0; REPEAT i := i * 10 + peek - Zero; peek := GetChar () UNTIL (peek < Zero) OR (peek > Nine); END;
END Int;

(** Returns the long integer constant at the current position. *)
PROCEDURE LongInt* (VAR i: LONGINT);
BEGIN SkipSpace; Done := (peek >= Zero) & (peek <= Nine); IF Done THEN i := 0; REPEAT i := i * 10 + peek - Zero; peek := GetChar () UNTIL (peek < Zero) OR (peek > Nine); END;
END LongInt;

(** Returns the real constant at the current position. *)
PROCEDURE Real* (VAR x: REAL);
VAR exponent, factor: INTEGER; digit: REAL; minus: BOOLEAN;
BEGIN
	SkipSpace; Done := (peek >= Zero) & (peek <= Nine); IF Done THEN exponent := 0; x := 0; REPEAT digit := peek - Zero; x := x * 10 + digit; peek := GetChar () UNTIL (peek < Zero) OR (peek > Nine);
	IF peek = Dot THEN peek := GetChar (); WHILE (peek >= Zero) & (peek <= Nine) DO digit := peek - Zero; x := x * 10 + digit; DEC (exponent); peek := GetChar () END END;
	IF peek = E THEN peek := GetChar (); minus := peek = Minus; IF (peek = Plus) OR minus THEN peek := GetChar () END; Done := (peek >= Zero) & (peek <= Nine); IF Done THEN Int (factor); IF minus THEN DEC (exponent, factor) ELSE INC (exponent, factor) END END END;
	WHILE exponent > 0 DO x := x * 10; DEC (exponent) END; WHILE exponent < 0 DO x := x * 0.1; INC (exponent) END END;
END Real;

(** Returns the long real constant at the current position. *)
PROCEDURE LongReal* (VAR x: LONGREAL);
VAR exponent, factor: INTEGER; digit: LONGREAL; minus: BOOLEAN;
BEGIN
	SkipSpace; Done := (peek >= Zero) & (peek <= Nine); IF Done THEN exponent := 0; x := 0; REPEAT digit := peek - Zero; x := x * 10 + digit; peek := GetChar () UNTIL (peek < Zero) OR (peek > Nine);
	IF peek = Dot THEN peek := GetChar (); WHILE (peek >= Zero) & (peek <= Nine) DO digit := peek - Zero; x := x * 10 + digit; DEC (exponent); peek := GetChar () END END;
	IF (peek = E) OR (peek = D) THEN peek := GetChar (); minus := peek = Minus; IF (peek = Plus) OR minus THEN peek := GetChar () END; Done := (peek >= Zero) & (peek <= Nine); IF Done THEN Int (factor); IF minus THEN DEC (exponent, factor) ELSE INC (exponent, factor) END END END;
	WHILE exponent > 0 DO x := x * 10; DEC (exponent) END; WHILE exponent < 0 DO x := x * 0.1; INC (exponent) END END;
END LongReal;

(** Returns the string at the current position. *)
PROCEDURE String* (VAR str: ARRAY OF CHAR);
VAR i: LENGTH;
BEGIN SkipSpace; Done := peek = Quotes; IF Done THEN peek := GetChar (); i := 0; WHILE (peek # Quotes) & (peek >= Space) DO str[i] := CHR (peek); INC (i); peek := GetChar () END; Done := peek = Quotes; IF Done THEN peek := GetChar () END END;
END String;

(** Returns the name at the current position. *)
PROCEDURE Name* (VAR name: ARRAY OF CHAR);
VAR i: LENGTH;
BEGIN SkipSpace; i := 0; WHILE peek > Space DO name[i] := CHR (peek); INC (i); peek := GetChar () END; Done := i # 0; IF Done THEN name[i] := 0X END;
END Name;

END In.

(* Standard Oberon output
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

(** The module {{{Out}}} provides utility procedures to print values of basic type to the standard output stream. *)
MODULE Out IN OBL;

IMPORT SYSTEM, Math (LONGREAL) IN OBL;

(** A Boolean value indicating whether the last output operation was successful. *)
VAR Done-: BOOLEAN;

PROCEDURE ^ Putchar ["putchar"] (character: INTEGER): INTEGER;

(** Prints a character value to the standard output stream. *)
PROCEDURE Char* (value: CHAR);
BEGIN Done := Putchar (ORD (value)) = ORD (value);
END Char;

(** Prints a string value to the standard output stream. *)
PROCEDURE String* (value-: ARRAY OF CHAR);
VAR i: LENGTH; char: CHAR;
BEGIN FOR i := 0 TO LEN (value) - 1 DO char := value[i]; IF char = 0X THEN RETURN END; Char (char) END;
END String;

(** Prints a Boolean value to the standard output stream. *)
PROCEDURE Boolean* (value: BOOLEAN);
BEGIN IF value THEN String ("TRUE") ELSE String ("FALSE") END;
END Boolean;

(** Prints an unsigned integer value to the standard output stream. *)
PROCEDURE Unsigned* (value: UNSIGNED64);
VAR i: LENGTH; buffer: ARRAY 19 OF CHAR;
BEGIN
	i := 0; REPEAT buffer[i] := CHR (value MOD 10 + ORD ('0')); value := value DIV 10; INC (i) UNTIL value = 0;
	WHILE i # 0 DO DEC (i); Char (buffer[i]) END;
END Unsigned;

(** Prints a signed integer value to the standard output stream. *)
PROCEDURE Signed* (value: SIGNED64);
BEGIN IF value < 0 THEN Char ('-'); Unsigned (-value) ELSE Unsigned (value) END;
END Signed;

(** Prints a decimal integer value to the standard output stream. *)
PROCEDURE Integer* (value: HUGEINT);
BEGIN Signed (value);
END Integer;

PROCEDURE Hexadecimal (value: SYSTEM.ADDRESS; digits: LENGTH);
VAR i: LENGTH; digit: SYSTEM.ADDRESS; buffer: ARRAY SIZE (SYSTEM.ADDRESS) * 2 OF CHAR;
BEGIN
	i := 0;
	REPEAT
		digit := value MOD 16;
		IF digit > 9 THEN INC (digit, ORD ('A') - 10) ELSE INC (digit, ORD ('0')) END;
		buffer[i] := CHR (digit); value := value DIV 16; INC (i);
	UNTIL i = digits;
	WHILE i # 0 DO DEC (i); Char (buffer[i]) END;
END Hexadecimal;

(** Prints a hexademical byte value to the standard output stream. *)
PROCEDURE Byte* (value: CHAR);
BEGIN Hexadecimal (ORD (value), 2);
END Byte;

(** Prints a hexademical address value to the standard output stream. *)
PROCEDURE Address* (value: SYSTEM.ADDRESS);
BEGIN Hexadecimal (value, SIZE (SYSTEM.ADDRESS) * 2);
END Address;

(** Prints a real value to the standard output stream. *)
PROCEDURE Real* (value: LONGREAL; precision: INTEGER);
VAR count: LONGINT;
BEGIN
	IF Math.IsNegative (value) THEN Char ('-') END;
	IF Math.IsInf (value) THEN String ("INF"); RETURN END; IF Math.IsNan (value) THEN String ("NAN"); RETURN END;
	count := ENTIER (value); IF count < 0 THEN IF count < value THEN INC (count) END; value := count - value ELSE value := value - count END;
	Integer (ABS (count)); IF value # 0 THEN Char ('.') END;
	WHILE (precision # 0) & (value # 0) DO value := value * 10; count := ENTIER (value); Integer (count); value := value - count; DEC (precision) END;
END Real;

(** Prints a complex value to the standard output stream. *)
PROCEDURE Complex* (value: LONGCOMPLEX; precision: INTEGER);
VAR real, imag: LONGREAL;
BEGIN
	real := RE (value); imag := IM (value);
	IF real # 0 THEN Real (real, precision) END;
	IF (real # 0) & (imag # 0) THEN Char (' '); IF imag < 0 THEN Char ('-') ELSE Char ('+') END; Char (' ') END;
	IF (imag # 0) & (imag # 1) THEN Real (SEL (real # 0, ABS (imag), imag), precision); Char (' '); Char ('*'); Char (' ') END;
	IF imag # 0 THEN Char ('I') END;
END Complex;

(** Prints a set value to the standard output stream. *)
PROCEDURE Set* (value: SET64);
VAR i: INTEGER; comma: BOOLEAN;
BEGIN
	Char ('{'); comma := FALSE;
	FOR i := MIN (SET64) TO MAX (SET64) DO IF i IN value THEN IF comma THEN Char (','); Char (' ') END; Integer (i); comma := TRUE END END;
	Char ('}');
END Set;

(** Prints a new-line character to the standard output stream. *)
PROCEDURE Ln*;
BEGIN Char (0AX);
END Ln;

END Out.

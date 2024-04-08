# Standard Oberon execution test and validation suite
# Copyright (C) Florian Negele

# This file is part of the Eigen Compiler Suite.

# The ECS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# The ECS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with the ECS.  If not, see <https://www.gnu.org/licenses/>.

# 6.4 Pointer types

positive: allocating record type

	MODULE Test;
	VAR pointer: POINTER TO RECORD END;
	BEGIN NEW (pointer); ASSERT (pointer # NIL);
	END Test.

positive: allocating array type

	MODULE Test;
	VAR pointer: POINTER TO ARRAY 10 OF CHAR;
	BEGIN NEW (pointer); ASSERT (pointer # NIL); ASSERT (LEN (pointer^) = 10);
	END Test.

positive: allocating open array type

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF CHAR;
	BEGIN NEW (pointer, 10); ASSERT (pointer # NIL); ASSERT (LEN (pointer^) = 10);
	END Test.

positive: allocating two-dimensional open array type

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN NEW (pointer, 10, 20); ASSERT (pointer # NIL); ASSERT (LEN (pointer^, 0) = 10); ASSERT (LEN (pointer^, 1) = 20);
	END Test.

# 6.5 Procedure types

positive: variable of procedure type having a procedure as value

	MODULE Test;
	VAR procedure: PROCEDURE;
	PROCEDURE Procedure;
	BEGIN ASSERT (procedure = Procedure);
	END Procedure;
	BEGIN procedure := Procedure; procedure;
	END Test.

positive: variable of procedure type having NIL as value

	MODULE Test;
	VAR procedure: PROCEDURE;
	BEGIN procedure := NIL; ASSERT (procedure = NIL);
	END Test.

# 8.1 Operands

positive: denoting array element with constant index zero

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[0] := 0X; ASSERT (array[0] = 0X);
	END Test.

positive: denoting array element with constant positive index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[1] := 0X; ASSERT (array[1] = 0X);
	END Test.

negative: denoting array element with constant negative index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[-1] := 0X;
	END Test.

positive: denoting array element with constant length minus one as index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[9] := 0X; ASSERT (array[9] = 0X);
	END Test.

negative: denoting array element with constant length as index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[10] := 0X;
	END Test.

positive: denoting array element with index zero

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR; index: INTEGER;
	BEGIN index := 0; array[index] := 0X; ASSERT (array[index] = 0X);
	END Test.

positive: denoting array element with positive index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR; index: INTEGER;
	BEGIN index := 1; array[index] := 0X; ASSERT (array[index] = 0X);
	END Test.

negative: denoting array element with negative index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR; index: INTEGER;
	BEGIN index := -1; array[index] := 0X;
	END Test.

positive: denoting array element with length minus one as index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR; index: INTEGER;
	BEGIN index := 9; array[index] := 0X; ASSERT (array[index] = 0X);
	END Test.

negative: denoting array element with length as index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR; index: INTEGER;
	BEGIN index := 10; array[index] := 0X;
	END Test.

positive: two dimensional expression list as array index

	MODULE Test;
	VAR array: ARRAY 10, 20 OF INTEGER; i, j: INTEGER;
	BEGIN FOR i := 0 TO LEN (array, 0) -1 DO FOR j := 0 TO LEN (array, 1) - 1 DO array[i, j] := i - j; ASSERT (array[i, j] = i - j) END END;
	END Test.

positive: applying type guard on parameter of record type

	MODULE Test;
	TYPE Record = RECORD field1: CHAR END;
	TYPE Extension = RECORD (Record) field2: CHAR END;
	VAR variable: Extension;
	PROCEDURE Procedure (VAR record: Record);
	BEGIN record(Extension).field2 := record(Extension).field1; ASSERT (record(Record).field1 = record(Extension).field1);
	END Procedure;
	BEGIN variable.field1 := 5X; Procedure (variable); ASSERT (variable.field2 = 5X);
	END Test.

positive: applying type guard on variable of pointer type

	MODULE Test;
	TYPE Record = RECORD field1: CHAR END;
	TYPE Pointer = POINTER TO Record;
	TYPE Extension = POINTER TO RECORD (Record) field2: CHAR END;
	VAR record: Pointer; extension: Extension;
	BEGIN NEW (extension); record := extension; record(Pointer).field1 := 5X; ASSERT (record(Pointer).field1 = record(Extension).field1);
		record(Extension).field2 := record(Extension).field1; ASSERT (extension.field2 = 5X);
	END Test.

# 8.2 Operators

positive: left-to-right association example

	MODULE Test;
	VAR x, y, z: INTEGER;
	BEGIN x := 10; y := 8; z := 5; ASSERT (x - y - z = (x - y) - z); ASSERT (x - y - z = -3);
	END Test.

# 8.2.1 Logical operators

positive: logical disjunction

	MODULE Test;
	VAR a, b: BOOLEAN;
	BEGIN
		a := FALSE; b := FALSE; ASSERT (~(a OR b));
		a := FALSE; b := TRUE; ASSERT (a OR b);
		a := TRUE; b := FALSE; ASSERT (a OR b);
		a := TRUE; b := TRUE; ASSERT (a OR b);
	END Test.

positive: logical conjunction

	MODULE Test;
	VAR a, b: BOOLEAN;
	BEGIN
		a := FALSE; b := FALSE; ASSERT (~(a & b));
		a := FALSE; b := TRUE; ASSERT (~(a & b));
		a := TRUE; b := FALSE; ASSERT (~(a & b));
		a := TRUE; b := TRUE; ASSERT (a & b);
	END Test.

positive: negation

	MODULE Test;
	VAR a: BOOLEAN;
	BEGIN
		a := FALSE; ASSERT (~a);
		a := TRUE; ASSERT (~(~a));
	END Test.

positive: short-circuit evaluation

	MODULE Test;
	PROCEDURE True (): BOOLEAN; BEGIN RETURN TRUE END True;
	PROCEDURE False (): BOOLEAN; BEGIN RETURN FALSE END False;
	PROCEDURE Halt (): BOOLEAN; BEGIN HALT (123) END Halt;
	BEGIN
		ASSERT (False () & Halt () = FALSE);
		ASSERT (True () OR Halt () = TRUE);
	END Test.

# 8.2.2 Arithmetic operators

positive: SHORTINT sum

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: INTEGER sum

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: LONGINT sum

	MODULE Test;
	VAR a, b: LONGINT;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: REAL sum

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: LONGREAL sum

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: SHORTINT difference

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
		a := -3; b := 2; ASSERT (a - b = -5); ASSERT (a - b = (-3) - 2);
		a := 3; b := -2; ASSERT (a - b = +5); ASSERT (a - b = 3 - (-2));
		a := -3; b := -2; ASSERT (a - b = -1); ASSERT (a - b = (-3) - (-2));
	END Test.

positive: INTEGER difference

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
		a := -3; b := 2; ASSERT (a - b = -5); ASSERT (a - b = (-3) - 2);
		a := 3; b := -2; ASSERT (a - b = +5); ASSERT (a - b = 3 - (-2));
		a := -3; b := -2; ASSERT (a - b = -1); ASSERT (a - b = (-3) - (-2));
	END Test.

positive: LONGINT difference

	MODULE Test;
	VAR a, b: LONGINT;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
		a := -3; b := 2; ASSERT (a - b = -5); ASSERT (a - b = (-3) - 2);
		a := 3; b := -2; ASSERT (a - b = +5); ASSERT (a - b = 3 - (-2));
		a := -3; b := -2; ASSERT (a - b = -1); ASSERT (a - b = (-3) - (-2));
	END Test.

positive: REAL difference

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: LONGREAL difference

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: SHORTINT product

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
		a := -3; b := 2; ASSERT (a * b = -6); ASSERT (a * b = (-3) * 2);
		a := 3; b := -2; ASSERT (a * b = -6); ASSERT (a * b = 3 * (-2));
		a := -3; b := -2; ASSERT (a * b = +6); ASSERT (a * b = (-3) * (-2));
	END Test.

positive: INTEGER product

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
		a := -3; b := 2; ASSERT (a * b = -6); ASSERT (a * b = (-3) * 2);
		a := 3; b := -2; ASSERT (a * b = -6); ASSERT (a * b = 3 * (-2));
		a := -3; b := -2; ASSERT (a * b = +6); ASSERT (a * b = (-3) * (-2));
	END Test.

positive: LONGINT product

	MODULE Test;
	VAR a, b: LONGINT;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
		a := -3; b := 2; ASSERT (a * b = -6); ASSERT (a * b = (-3) * 2);
		a := 3; b := -2; ASSERT (a * b = -6); ASSERT (a * b = 3 * (-2));
		a := -3; b := -2; ASSERT (a * b = +6); ASSERT (a * b = (-3) * (-2));
	END Test.

positive: REAL product

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a * b = +8.75); ASSERT (a * b = 3.5 * 2.5);
		a := -3.5; b := 2.5; ASSERT (a * b = -8.75); ASSERT (a * b = (-3.5) * 2.5);
		a := 3.5; b := -2.5; ASSERT (a * b = -8.75); ASSERT (a * b = 3.5 * (-2.5));
		a := -3.5; b := -2.5; ASSERT (a * b = +8.75); ASSERT (a * b = (-3.5) * (-2.5));
	END Test.

positive: LONGREAL product

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a * b = +8.75); ASSERT (a * b = 3.5 * 2.5);
		a := -3.5; b := 2.5; ASSERT (a * b = -8.75); ASSERT (a * b = (-3.5) * 2.5);
		a := 3.5; b := -2.5; ASSERT (a * b = -8.75); ASSERT (a * b = 3.5 * (-2.5));
		a := -3.5; b := -2.5; ASSERT (a * b = +8.75); ASSERT (a * b = (-3.5) * (-2.5));
	END Test.

positive: SHORTINT real quotient

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: INTEGER real quotient

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: LONGINT real quotient

	MODULE Test;
	VAR a, b: LONGINT;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: REAL real quotient

	MODULE Test;
	VAR a, b: REAL;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: LONGREAL real quotient

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: SHORTINT integer quotient

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: INTEGER integer quotient

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: LONGINT integer quotient

	MODULE Test;
	VAR a, b: LONGINT;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: SHORTINT modulus

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: INTEGER modulus

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: LONGINT modulus

	MODULE Test;
	VAR a, b: LONGINT;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: SHORTINT sign inversion

	MODULE Test;
	VAR value: SHORTINT;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: INTEGER sign inversion

	MODULE Test;
	VAR value: INTEGER;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: LONGINT sign inversion

	MODULE Test;
	VAR value: LONGINT;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: REAL sign inversion

	MODULE Test;
	VAR value: REAL;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: LONGREAL sign inversion

	MODULE Test;
	VAR value: LONGREAL;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: SHORTINT identity

	MODULE Test;
	VAR value: SHORTINT;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: INTEGER identity

	MODULE Test;
	VAR value: INTEGER;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: LONGINT identity

	MODULE Test;
	VAR value: LONGINT;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: REAL identity

	MODULE Test;
	VAR value: REAL;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: LONGREAL identity

	MODULE Test;
	VAR value: LONGREAL;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: integer quotient and modulus exmaple

	MODULE Test;
	VAR x, y: INTEGER;
	BEGIN
		x := 5; y := 3; ASSERT (x DIV y = 1); ASSERT (x MOD y = 2);
	END Test.

# 8.2.3 Set Operators

positive: SET union

	MODULE Test;
	VAR a, b: SET;
	BEGIN
		a := {}; b := {}; ASSERT (a + b = {}); ASSERT (a + b = {} + {});
		a := {1, 2}; b := {}; ASSERT (a + b = {1, 2}); ASSERT (a + b = {1, 2} + {});
		a := {}; b := {2, 3}; ASSERT (a + b = {2, 3}); ASSERT (a + b = {} + {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a + b = {1..3}); ASSERT (a + b = {1, 2} + {2, 3});
	END Test.

positive: SET difference

	MODULE Test;
	VAR a, b: SET;
	BEGIN
		a := {}; b := {}; ASSERT (a - b = {}); ASSERT (a - b = {} - {});
		a := {1, 2}; b := {}; ASSERT (a - b = {1, 2}); ASSERT (a - b = {1, 2} - {});
		a := {}; b := {2, 3}; ASSERT (a - b = {}); ASSERT (a - b = {} - {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a - b = {1}); ASSERT (a - b = {1, 2} - {2, 3});
	END Test.

positive: SET intersection

	MODULE Test;
	VAR a, b: SET;
	BEGIN
		a := {}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {} * {});
		a := {1, 2}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {1, 2} * {});
		a := {}; b := {2, 3}; ASSERT (a * b = {}); ASSERT (a * b = {} * {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a * b = {2}); ASSERT (a * b = {1, 2} * {2, 3});
	END Test.

positive: SET symmetric set difference

	MODULE Test;
	VAR a, b: SET;
	BEGIN
		a := {}; b := {}; ASSERT (a / b = {}); ASSERT (a / b = {} / {});
		a := {1, 2}; b := {}; ASSERT (a / b = {1, 2}); ASSERT (a / b = {1, 2} / {});
		a := {}; b := {2, 3}; ASSERT (a / b = {2, 3}); ASSERT (a / b = {} / {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a / b = {1, 3}); ASSERT (a / b = {1, 2} / {2, 3});
	END Test.

positive: SET identity

	MODULE Test;
	VAR value: SET;
	BEGIN value := {3}; ASSERT (+value = +{3}); ASSERT (+(+value) = {3}); ASSERT (+(+value) = value)
	END Test.

positive: SET complement set difference

	MODULE Test;
	VAR value: SET;
	BEGIN value := {2}; ASSERT (-value = {0..MAX (SET)} - {2}); ASSERT (-(-value) = {2}); ASSERT (-(-value) = value)
	END Test.

positive: set constructor with single integer element

	MODULE Test;
	VAR element: INTEGER; set: SET;
	BEGIN
		element := MIN (SET); set := {element}; ASSERT (element IN set); ASSERT (set - {element} = {});
		element := MAX (SET); set := {element}; ASSERT (element IN set); ASSERT (set - {element} = {});
	END Test.

positive: set constructor with multiple integer elements

	MODULE Test;
	VAR first, last: INTEGER; set: SET;
	BEGIN
		first := MIN (SET); last := MAX (SET); set := {first .. last}; ASSERT (set = {MIN (SET) .. MAX (SET)});
		ASSERT (first IN set); ASSERT (last IN set); ASSERT (-set = {});
		first := MIN (SET) + 2; last := MAX (SET) - 2; set := {first .. last}; ASSERT (set = {MIN (SET) + 2 .. MAX (SET) - 2});
		ASSERT (first IN set); ASSERT (last IN set); ASSERT (-set = {MIN (SET), MIN (SET) + 1, MAX (SET) - 1, MAX (SET)});
		first := MIN (SET) + 2; last := first; set := {first .. last}; ASSERT (set = {first});
		first := MIN (SET) + 2; last := first + 1; set := {first .. last}; ASSERT (set = {first, last});
		first := MIN (SET) + 2; last := first - 1; set := {first .. last}; ASSERT (set = {});
	END Test.

# 8.2.4 Relations

positive: BOOLEAN equal relation

	MODULE Test;
	VAR a, b: BOOLEAN;
	BEGIN
		a := TRUE; b := FALSE; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (TRUE = FALSE));
		a := FALSE; b := FALSE; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (FALSE = FALSE));
	END Test.

positive: CHAR equal relation

	MODULE Test;
	VAR a, b: CHAR;
	BEGIN
		a := 'a'; b := 'b'; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ('a' = 'b'));
		a := 'c'; b := 'c'; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ('c' = 'c'));
	END Test.

positive: SHORTINT equal relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := 4; b := 4; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4 = 4));
	END Test.

positive: INTEGER equal relation

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := 4; b := 4; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4 = 4));
	END Test.

positive: LONGINT equal relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := 4; b := 4; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4 = 4));
	END Test.

positive: REAL equal relation

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 = 2.5));
		a := 4.5; b := 4.5; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 = 4.5));
	END Test.

positive: LONGREAL equal relation

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 = 2.5));
		a := 4.5; b := 4.5; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 = 4.5));
	END Test.

positive: SET equal relation

	MODULE Test;
	VAR a, b: SET;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ({0} = {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ({3, 4} = {4, 3}));
	END Test.

positive: ARRAY OF CHAR equal relation

	MODULE Test;
	VAR a, b: ARRAY 10 OF CHAR;
	BEGIN
		a := "abc"; b := "xyz"; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ("abc" = "xyz"));
		a := "hello"; b := "hello"; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ("hello" = "hello"));
	END Test.

positive: POINTER equal relation

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR;
	BEGIN
		NEW (a); NEW (b); ASSERT ((a = b) = FALSE);
		NEW (a); a := b; ASSERT ((a = b) = TRUE);
	END Test.

positive: PROCEDURE equal relation

	MODULE Test;
	VAR a, b: PROCEDURE;
	PROCEDURE Procedure; END Procedure;
	BEGIN
		a := Procedure; b := NIL; ASSERT ((a = b) = FALSE);
		a := Procedure; b := Procedure; ASSERT ((a = b) = TRUE);
	END Test.

positive: BOOLEAN unequal relation

	MODULE Test;
	VAR a, b: BOOLEAN;
	BEGIN
		a := TRUE; b := FALSE; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (TRUE # FALSE));
		a := FALSE; b := FALSE; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (FALSE # FALSE));
	END Test.

positive: CHAR unequal relation

	MODULE Test;
	VAR a, b: CHAR;
	BEGIN
		a := 'a'; b := 'b'; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ('a' # 'b'));
		a := 'c'; b := 'c'; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ('c' # 'c'));
	END Test.

positive: SHORTINT unequal relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: INTEGER unequal relation

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: LONGINT unequal relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: REAL unequal relation

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 # 2.5));
		a := 4.5; b := 4.5; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 # 4.5));
	END Test.

positive: LONGREAL unequal relation

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 # 2.5));
		a := 4.5; b := 4.5; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 # 4.5));
	END Test.

positive: SET unequal relation

	MODULE Test;
	VAR a, b: SET;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ({0} # {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ({3, 4} # {4, 3}));
	END Test.

positive: ARRAY OF CHAR unequal relation

	MODULE Test;
	VAR a, b: ARRAY 10 OF CHAR;
	BEGIN
		a := "abc"; b := "xyz"; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ("abc" # "xyz"));
		a := "hello"; b := "hello"; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ("hello" # "hello"));
	END Test.

positive: POINTER unequal relation

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR;
	BEGIN
		NEW (a); NEW (b); ASSERT ((a # b) = TRUE);
		NEW (a); a := b; ASSERT ((a # b) = FALSE);
	END Test.

positive: PROCEDURE unequal relation

	MODULE Test;
	VAR a, b: PROCEDURE;
	PROCEDURE Procedure; END Procedure;
	BEGIN
		a := Procedure; b := NIL; ASSERT ((a # b) = TRUE);
		a := Procedure; b := Procedure; ASSERT ((a # b) = FALSE);
	END Test.

positive: CHAR less relation

	MODULE Test;
	VAR a, b: CHAR;
	BEGIN
		a := 'a'; b := 'b'; ASSERT ((a < b) = TRUE); ASSERT ((a < b) = ('a' < 'b'));
		a := 'c'; b := 'c'; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = ('c' < 'c'));
	END Test.

positive: SHORTINT less relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: INTEGER less relation

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: LONGINT less relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: REAL less relation

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3.5 < 2.5));
		a := 4.5; b := 4.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4.5 < 4.5));
	END Test.

positive: LONGREAL less relation

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3.5 < 2.5));
		a := 4.5; b := 4.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4.5 < 4.5));
	END Test.

positive: ARRAY OF CHAR less relation

	MODULE Test;
	VAR a, b: ARRAY 10 OF CHAR;
	BEGIN
		a := "abc"; b := "xyz"; ASSERT ((a < b) = TRUE); ASSERT ((a < b) = ("abc" < "xyz"));
		a := "hello"; b := "hello"; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = ("hello" < "hello"));
	END Test.

positive: CHAR less or equal relation

	MODULE Test;
	VAR a, b: CHAR;
	BEGIN
		a := 'a'; b := 'b'; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = ('a' <= 'b'));
		a := 'c'; b := 'c'; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = ('c' <= 'c'));
	END Test.

positive: SHORTINT less or equal relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: INTEGER less or equal relation

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: LONGINT less or equal relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: REAL less or equal relation

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3.5 <= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4.5 <= 4.5));
	END Test.

positive: LONGREAL less or equal relation

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3.5 <= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4.5 <= 4.5));
	END Test.

positive: CHAR greater relation

	MODULE Test;
	VAR a, b: CHAR;
	BEGIN
		a := 'a'; b := 'b'; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = ('a' > 'b'));
		a := 'c'; b := 'c'; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = ('c' > 'c'));
	END Test.

positive: SHORTINT greater relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: INTEGER greater relation

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: LONGINT greater relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: REAL greater relation

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3.5 > 2.5));
		a := 4.5; b := 4.5; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4.5 > 4.5));
	END Test.

positive: LONGREAL greater relation

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3.5 > 2.5));
		a := 4.5; b := 4.5; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4.5 > 4.5));
	END Test.

positive: ARRAY OF CHAR greater relation

	MODULE Test;
	VAR a, b: ARRAY 10 OF CHAR;
	BEGIN
		a := "abc"; b := "xyz"; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = ("abc" > "xyz"));
		a := "hello"; b := "hello"; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = ("hello" > "hello"));
	END Test.

positive: CHAR greater or equal relation

	MODULE Test;
	VAR a, b: CHAR;
	BEGIN
		a := 'a'; b := 'b'; ASSERT ((a >= b) = FALSE); ASSERT ((a >= b) = ('a' >= 'b'));
		a := 'c'; b := 'c'; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = ('c' >= 'c'));
	END Test.

positive: SHORTINT greater or equal relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: INTEGER greater or equal relation

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: LONGINT greater or equal relation

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: REAL greater or equal relation

	MODULE Test;
	VAR a, b: REAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3.5 >= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4.5 >= 4.5));
	END Test.

positive: LONGREAL greater or equal relation

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3.5 >= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4.5 >= 4.5));
	END Test.

positive: ARRAY OF CHAR greater or equal relation

	MODULE Test;
	VAR a, b: ARRAY 10 OF CHAR;
	BEGIN
		a := "abc"; b := "xyz"; ASSERT ((a >= b) = FALSE); ASSERT ((a >= b) = ("abc" >= "xyz"));
		a := "hello"; b := "hello"; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = ("hello" >= "hello"));
	END Test.

positive: SHORTINT set membership

	MODULE Test;
	VAR a: SHORTINT; b: SET;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: INTEGER set membership

	MODULE Test;
	VAR a: INTEGER; b: SET;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: type test on extended record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD (Type) END;
	VAR variable: Record;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Record;
	END Procedure;
	BEGIN ASSERT (Procedure (variable));
	END Test.

positive: type test on unextended record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD (Type) END;
	VAR variable: Type;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Record;
	END Procedure;
	BEGIN ASSERT (~Procedure (variable));
	END Test.

positive: type test on pointer to extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Record = POINTER TO RECORD (Base) END;
	VAR variable: Record; pointer: Type;
	BEGIN NEW (variable); pointer := variable; ASSERT (pointer IS Record);
	END Test.

positive: type test on pointer to unextended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Record = POINTER TO RECORD (Base) END;
	VAR variable: Type; pointer: Type;
	BEGIN NEW (variable); pointer := variable; ASSERT (~(pointer IS Record));
	END Test.

# 9.1 Assignments

positive: BOOLEAN assignment

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN variable := TRUE; ASSERT (variable);
	END Test.

positive: CHAR assignment

	MODULE Test;
	VAR variable: CHAR;
	BEGIN variable := ' '; ASSERT (variable = ' ');
	END Test.

positive: SHORTINT assignment

	MODULE Test;
	VAR variable: SHORTINT;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: INTEGER assignment

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: LONGINT assignment

	MODULE Test;
	VAR variable: LONGINT;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: REAL assignment

	MODULE Test;
	VAR variable: REAL;
	BEGIN variable := 2.5; ASSERT (variable = 2.5);
	END Test.

positive: LONGREAL assignment

	MODULE Test;
	VAR variable: LONGREAL;
	BEGIN variable := 2.5; ASSERT (variable = 2.5);
	END Test.

positive: SET assignment

	MODULE Test;
	VAR variable: SET;
	BEGIN variable := {1, 2}; ASSERT (variable = {1..2});
	END Test.

positive: ARRAY assignment

	MODULE Test;
	VAR variable, value: ARRAY 10 OF SET;
	BEGIN value[0] := {0}; value[9] := {9}; variable := value; ASSERT (variable[0] = {0}); ASSERT (variable[9] = {9});
	END Test.

positive: ARRAY OF CHAR assignment

	MODULE Test;
	VAR variable: ARRAY 10 OF CHAR;
	BEGIN variable := "test"; ASSERT (variable[0] = 't'); ASSERT (variable[1] = 'e'); ASSERT (variable[2] = 's'); ASSERT (variable[3] = 't'); ASSERT (variable[4] = 0X);
	END Test.

positive: RECORD assignment

	MODULE Test;
	VAR variable, value: RECORD x, y: SET END;
	BEGIN value.x := {0}; value.y := {1}; variable := value; ASSERT (variable.x = {0}); ASSERT (variable.y = {1});
	END Test.

positive: RECORD assignment with same dynamic type

	MODULE Test;
	TYPE Record = RECORD x, y: CHAR END;
	VAR variable: Record; value: RECORD (Record) z: CHAR END;
	PROCEDURE Procedure (VAR variable, value: Record);
	BEGIN variable := value;
	END Procedure;
	BEGIN value.x := 'x'; value.y := 'y'; value.z := 'z'; Procedure (variable, value); ASSERT (variable.x = 'x'); ASSERT (variable.y = 'y');
	END Test.

negative: RECORD assignment with unequal dynamic type

	MODULE Test;
	TYPE Record = RECORD x, y: CHAR END;
	VAR variable, value: RECORD (Record) z: CHAR END;
	PROCEDURE Procedure (VAR variable, value: Record);
	BEGIN variable := value;
	END Procedure;
	BEGIN value.x := 'x'; value.y := 'y'; value.z := 'z'; Procedure (variable, value);
	END Test.

positive: POINTER assignment

	MODULE Test;
	VAR variable, value: POINTER TO ARRAY 10 OF CHAR;
	BEGIN NEW (value); variable := value; ASSERT (variable = value); variable := NIL; ASSERT (variable = NIL);
	END Test.

positive: POINTER assignment with same dynamic type

	MODULE Test;
	TYPE Record = RECORD x, y: CHAR END;
	VAR variable, value: POINTER TO RECORD (Record) z: CHAR END;
	BEGIN NEW (value); value.x := 'x'; value.y := 'y'; value.z := 'z'; variable := value; ASSERT (variable = value); ASSERT (variable.x = 'x'); ASSERT (variable.y = 'y'); ASSERT (variable.z = 'z');
	END Test.

positive: POINTER assignment with unequal dynamic type

	MODULE Test;
	TYPE Record = RECORD x, y: CHAR END;
	VAR variable: POINTER TO Record; value: POINTER TO RECORD (Record) z: CHAR END;
	BEGIN NEW (value); value.x := 'x'; value.y := 'y'; value.z := 'z'; variable := value; ASSERT (variable = value); ASSERT (variable.x = 'x'); ASSERT (variable.y = 'y');
	END Test.

positive: PROCEDURE assignment

	MODULE Test;
	VAR variable: PROCEDURE;
	PROCEDURE Procedure; END Procedure;
	BEGIN variable := Procedure; ASSERT (variable = Procedure); variable := NIL; ASSERT (variable = NIL);
	END Test.

# 9.2 Procedure calls

positive: procedure activation

	MODULE Test;
	VAR a, b: SHORTINT;
	PROCEDURE Procedure (VAR x, y: SHORTINT; z: SET);
	BEGIN ASSERT (x = a); ASSERT (y = b); ASSERT (z = {x..y});
	END Procedure;
	BEGIN a := 1; b := 2; Procedure (a, b, {a..b});
	END Test.

positive: BOOLEAN conversion

	MODULE Test;
	VAR b: BOOLEAN; c: CHAR; i: INTEGER; r: REAL; s: SET;
	BEGIN
		b := TRUE; ASSERT (BOOLEAN (b) = TRUE); ASSERT (BOOLEAN (b) = BOOLEAN (TRUE));
		c := 5X; ASSERT (BOOLEAN (c) = TRUE); ASSERT (BOOLEAN (c) = BOOLEAN (5X));
		i := 0; ASSERT (BOOLEAN (i) = FALSE); ASSERT (BOOLEAN (i) = BOOLEAN (0));
		r := 2.5; ASSERT (BOOLEAN (r) = TRUE); ASSERT (BOOLEAN (r) = BOOLEAN (2.5));
		s := {2}; ASSERT (BOOLEAN (s) = TRUE); ASSERT (BOOLEAN (s) = BOOLEAN ({2}));
	END Test.

positive: CHAR conversion

	MODULE Test;
	VAR b: BOOLEAN; c: CHAR; i: INTEGER; r: REAL; s: SET;
	BEGIN
		b := TRUE; ASSERT (CHAR (b) = 1X); ASSERT (CHAR (b) = CHAR (TRUE));
		c := 5X; ASSERT (CHAR (c) = 5X); ASSERT (CHAR (c) = CHAR (5X));
		i := 0; ASSERT (CHAR (i) = 0X); ASSERT (CHAR (i) = CHAR (0));
		r := 2.5; ASSERT (CHAR (r) = 2X); ASSERT (CHAR (r) = CHAR (2.5));
		s := {2}; ASSERT (CHAR (s) = 4X); ASSERT (CHAR (s) = CHAR ({2}));
	END Test.

positive: INTEGER conversion

	MODULE Test;
	VAR b: BOOLEAN; c: CHAR; i: INTEGER; r: REAL; s: SET;
	BEGIN
		b := TRUE; ASSERT (INTEGER (b) = 1); ASSERT (INTEGER (b) = INTEGER (TRUE));
		c := 5X; ASSERT (INTEGER (c) = 5); ASSERT (INTEGER (c) = INTEGER (5X));
		i := 0; ASSERT (INTEGER (i) = 0); ASSERT (INTEGER (i) = INTEGER (0));
		r := 2.5; ASSERT (INTEGER (r) = 2); ASSERT (INTEGER (r) = INTEGER (2.5));
		s := {2}; ASSERT (INTEGER (s) = 4); ASSERT (INTEGER (s) = INTEGER ({2}));
	END Test.

positive: REAL conversion

	MODULE Test;
	VAR b: BOOLEAN; c: CHAR; i: INTEGER; r: REAL; s: SET;
	BEGIN
		b := TRUE; ASSERT (REAL (b) = 1.); ASSERT (REAL (b) = REAL (TRUE));
		c := 5X; ASSERT (REAL (c) = 5.); ASSERT (REAL (c) = REAL (5X));
		i := 0; ASSERT (REAL (i) = 0.); ASSERT (REAL (i) = REAL (0));
		r := 2.5; ASSERT (REAL (r) = 2.5); ASSERT (REAL (r) = REAL (2.5));
		s := {2}; ASSERT (REAL (s) = 4.); ASSERT (REAL (s) = REAL ({2}));
	END Test.

positive: SET conversion

	MODULE Test;
	VAR b: BOOLEAN; c: CHAR; i: INTEGER; r: REAL; s: SET;
	BEGIN
		b := TRUE; ASSERT (SET (b) = {0}); ASSERT (SET (b) = SET (TRUE));
		c := 5X; ASSERT (SET (c) = {0, 2}); ASSERT (SET (c) = SET (5X));
		i := 0; ASSERT (SET (i) = {}); ASSERT (SET (i) = SET (0));
		r := 2.5; ASSERT (SET (r) = {1}); ASSERT (SET (r) = SET (2.5));
		s := {2}; ASSERT (SET (s) = {2}); ASSERT (SET (s) = SET ({2}));
	END Test.

# 9.4 If statements

positive: if statement with satisfied guard

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; IF i = 0 THEN ELSIF i = 1 THEN HALT (123) ELSIF i = 2 THEN HALT (123) ELSE HALT (123) END;
		IF i = 0 THEN RETURN ELSIF i = 1 THEN ELSIF i = 2 THEN ELSE END; HALT (123);
	END Test.

positive: if statement with unsatisfied guard

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 2; IF i = 0 THEN HALT (123) ELSIF i = 1 THEN HALT (123) ELSIF i = 2 THEN ELSE HALT (123) END;
		IF i = 0 THEN ELSIF i = 1 THEN ELSIF i = 2 THEN RETURN ELSE END; HALT (123);
	END Test.

positive: if statement with unsatisfied nested guard

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 4; IF i = 0 THEN HALT (123) ELSIF i = 1 THEN HALT (123) ELSIF i = 2 THEN HALT (123) ELSE END;
		IF i = 0 THEN ELSIF i = 1 THEN ELSIF i = 2 THEN ELSE RETURN END; HALT (123);
	END Test.

# 9.5 Case statements

positive: case statement with character value

	MODULE Test;
	PROCEDURE Case (c: CHAR): INTEGER;
	BEGIN CASE c OF | 'a', 't', 'j': RETURN 0 | 'l'..'o': RETURN 1 | 'r', 'b', 10X: RETURN 2 ELSE RETURN 3 END; HALT (123);
	END Case;
	BEGIN ASSERT (Case ('a') = 0); ASSERT (Case ('b') = 2); ASSERT (Case ('c') = 3); ASSERT (Case ('j') = 0); ASSERT (Case ('n') = 1);
		ASSERT (Case ('o') = 1); ASSERT (Case ('r') = 2); ASSERT (Case ('t') = 0); ASSERT (Case ('z') = 3); ASSERT (Case (10X) = 2);
	END Test.

negative: case statement with too low character value

	MODULE Test;
	VAR c: CHAR;
	BEGIN c := 'a'; CASE c OF | 'b'..'g': | 's', 'r': | 'u', 'v': END;
	END Test.

negative: case statement with too high character value

	MODULE Test;
	VAR c: CHAR;
	BEGIN c := 'w'; CASE c OF | 'b'..'g': | 's', 'r': | 'u', 'v': END;
	END Test.

negative: case statement with unmatched character value

	MODULE Test;
	VAR c: CHAR;
	BEGIN c := 't'; CASE c OF | 'b'..'g': | 's', 'r': | 'u', 'v': END;
	END Test.

positive: case statement with integer value

	MODULE Test;
	PROCEDURE Case (i: INTEGER): INTEGER;
	BEGIN CASE i OF | 1, 3, 9: RETURN 0 | 4..6: RETURN 1 | 8, 2: RETURN 2 ELSE RETURN 3 END; HALT (123);
	END Case;
	BEGIN ASSERT (Case (0) = 3); ASSERT (Case (1) = 0); ASSERT (Case (2) = 2); ASSERT (Case (3) = 0); ASSERT (Case (4) = 1);
		ASSERT (Case (5) = 1); ASSERT (Case (6) = 1); ASSERT (Case (7) = 3); ASSERT (Case (8) = 2); ASSERT (Case (9) = 0);
	END Test.

negative: case statement with too low integer value

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; CASE i OF | 1, 3, 9: | 4..6: | 8, 2: END;
	END Test.

negative: case statement with too high integer value

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 10; CASE i OF | 1, 3, 9: | 4..6: | 8, 2: END;
	END Test.

negative: case statement with unmatched integer value

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 7; CASE i OF | 1, 3, 9: | 4..6: | 8, 2: END;
	END Test.

negative: empty case statement

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; CASE i OF END
	END Test.

positive: empty case statement with else

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; CASE i OF ELSE END
	END Test.

# 9.6 While statements

positive: while statement with satisfied guard

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; WHILE i < 10 DO ASSERT (i < 10); INC (i) END; ASSERT (i = 10);
	END Test.

positive: while statement with unsatisfied guard

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; WHILE i > 10 DO HALT (123) END; ASSERT (i = 0);
	END Test.

positive: while statement with checked guard before every execution

	MODULE Test;
	VAR i: INTEGER;
	PROCEDURE Test (): BOOLEAN;
	BEGIN INC (i); RETURN i < 10;
	END Test;
	BEGIN i := 0; WHILE Test () DO ASSERT (i < 10) END; ASSERT (i = 10);
	END Test.

# 9.7 Repeat statements

positive: repeat statement with satisfied guard

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; REPEAT ASSERT (i < 10); INC (i) UNTIL i = 10; ASSERT (i = 10);
	END Test.

positive: repeat statement with unsatisfied guard

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; REPEAT INC (i) UNTIL i = 1; ASSERT (i = 1);
	END Test.

# 9.8 For statements

positive: for statement with positive step sizes

	MODULE Test;
	VAR i, steps: INTEGER;
	BEGIN
		steps := 0; FOR i := 0 TO 10 DO INC (steps) END; ASSERT (steps = 11);
		steps := 0; FOR i := 0 TO 10 BY 1 DO INC (steps) END; ASSERT (steps = 11);
		steps := 0; FOR i := 0 TO 10 BY 2 DO INC (steps) END; ASSERT (steps = 6);
		steps := 0; FOR i := 0 TO 10 BY 3 DO INC (steps) END; ASSERT (steps = 4);
		steps := 0; FOR i := 0 TO 10 BY 4 DO INC (steps) END; ASSERT (steps = 3);
	END Test.

positive: for statement with negative step sizes

	MODULE Test;
	VAR i, steps: INTEGER;
	BEGIN
		steps := 0; FOR i := 10 TO 0 DO INC (steps) END; ASSERT (steps = 0);
		steps := 0; FOR i := 10 TO 0 BY -1 DO INC (steps) END; ASSERT (steps = 11);
		steps := 0; FOR i := 10 TO 0 BY -2 DO INC (steps) END; ASSERT (steps = 6);
		steps := 0; FOR i := 10 TO 0 BY -3 DO INC (steps) END; ASSERT (steps = 4);
		steps := 0; FOR i := 10 TO 0 BY -4 DO INC (steps) END; ASSERT (steps = 3);
	END Test.

positive: modifying start counter in for statement

	MODULE Test;
	VAR i, steps, start: INTEGER;
	BEGIN steps := 0; start := 0; FOR i := start TO 10 DO start := i; INC (steps) END; ASSERT (steps = 11);
	END Test.

positive: modifying end counter in for statement

	MODULE Test;
	VAR i, steps, end: INTEGER;
	BEGIN steps := 0; end := 10; FOR i := 0 TO end DO end := i; INC (steps) END; ASSERT (steps = 11);
	END Test.

positive: using counter as end counter for statement

	MODULE Test;
	VAR i, steps: INTEGER;
	BEGIN steps := 0; i := 10; FOR i := 0 TO i DO INC (steps) END; ASSERT (steps = 11);
	END Test.

# 9.9 Loop statements

positive: loop statement with exit statement

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; LOOP ASSERT (i = 0); INC (i); EXIT; HALT (123) END; ASSERT (i = 1);
	END Test.

# 9.10 Return and exit statements

positive: function procedure with return statement

	MODULE Test;
	PROCEDURE Procedure (): INTEGER;
	BEGIN RETURN 1234; HALT (123);
	END Procedure;
	BEGIN ASSERT (Procedure () = 1234);
	END Test.

negative: function procedure without return statement

	MODULE Test;
	PROCEDURE Procedure (): INTEGER;
	BEGIN
	END Procedure;
	BEGIN ASSERT (Procedure () = 1234);
	END Test.

positive: proper procedure with return statement

	MODULE Test;
	PROCEDURE Procedure;
	BEGIN RETURN; HALT (123);
	END Procedure;
	BEGIN Procedure;
	END Test.

positive: proper procedure without return statement

	MODULE Test;
	PROCEDURE Procedure;
	BEGIN
	END Procedure;
	BEGIN Procedure;
	END Test.

positive: explicit return statement as additional termination point

	MODULE Test;
	PROCEDURE Procedure (x: INTEGER);
	BEGIN IF x < 0 THEN RETURN END; IF x > 0 THEN RETURN END; RETURN; HALT (123);
	END Procedure;
	BEGIN Procedure (50);
	END Test.

positive: unconditional exit statement

	MODULE Test;
	BEGIN LOOP EXIT; HALT (123) END;
	END Test.

positive: nested unconditional exit statement

	MODULE Test;
	BEGIN LOOP LOOP EXIT; HALT (123) END; EXIT; HALT (123) END;
	END Test.

positive: conditional exit statement

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; LOOP IF i = 0 THEN EXIT END; HALT (123) END;
	END Test.

positive: nested conditional exit statement

	MODULE Test;
	VAR i: INTEGER;
	BEGIN i := 0; LOOP LOOP IF i = 0 THEN EXIT END; HALT (123) END; EXIT; HALT (123) END;
	END Test.

# 9.11 With statements

positive: with statement on extended record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD (Type) value: INTEGER END;
	VAR variable: Record;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Record DO INC (parameter.value) ELSE HALT (123) END;
	END Procedure;
	BEGIN variable.value := 0; Procedure (variable); ASSERT (variable.value = 1);
	END Test.

positive: with statement on doubly extended record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD (Type) value: INTEGER END;
	TYPE Extension = RECORD (Record) END;
	VAR variable: Extension;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Record DO INC (parameter.value) ELSE HALT (123) END;
	END Procedure;
	BEGIN variable.value := 0; Procedure (variable); ASSERT (variable.value = 1);
	END Test.

positive: with statement on unextended record type

	MODULE Test;
	TYPE Type = RECORD value: INTEGER END;
	TYPE Record = RECORD (Type) END;
	VAR variable: Type;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Record DO HALT (123) ELSE INC (parameter.value) END
	END Procedure;
	BEGIN variable.value := 0; Procedure (variable); ASSERT (variable.value = 1);
	END Test.

negative: with statement on unmatched record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD (Type) END;
	VAR variable: Type;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Record DO END
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: with statement on pointer to extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Record = POINTER TO RECORD (Base) value: INTEGER END;
	VAR variable: Record; pointer: Type;
	BEGIN NEW (variable); variable.value := 0; pointer := variable; WITH pointer: Record DO INC (pointer.value) ELSE HALT (123) END; ASSERT (variable.value = 1);
	END Test.

positive: with statement on pointer to doubly extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Extension = RECORD (Base) value: INTEGER END;
	TYPE Record = POINTER TO Extension;
	TYPE Pointer = POINTER TO RECORD (Extension) END;
	VAR variable: Pointer; pointer: Type;
	BEGIN NEW (variable); variable.value := 0; pointer := variable; WITH pointer: Record DO INC (pointer.value) ELSE HALT (123) END; ASSERT (variable.value = 1);
	END Test.

positive: with statement on pointer to unextended record type

	MODULE Test;
	TYPE Base = RECORD value: INTEGER END;
	TYPE Type = POINTER TO Base;
	TYPE Record = POINTER TO RECORD (Base) END;
	VAR variable: Type; pointer: Type;
	BEGIN NEW (variable); variable.value := 0; pointer := variable; WITH pointer: Record DO HALT (123) ELSE INC (pointer.value) END; ASSERT (variable.value = 1);
	END Test.

negative: with statement on pointer to unmatched record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Record = POINTER TO RECORD (Base) END;
	VAR variable: Type; pointer: Type;
	BEGIN NEW (variable); pointer := variable; WITH pointer: Record DO END;
	END Test.

# 10. Procedure declarations

positive: recursive procedure activation

	MODULE Test;
	VAR activations: INTEGER;
	PROCEDURE Fibonacci (index: INTEGER): INTEGER;
	BEGIN INC (activations); IF index < 2 THEN RETURN index END; RETURN Fibonacci (index - 1) + Fibonacci (index - 2);
	END Fibonacci;
	BEGIN activations := 0; ASSERT (Fibonacci (10) = 55); ASSERT (activations = 177);
	END Test.

positive: nested recursive procedure activation

	MODULE Test;
	VAR activations: INTEGER;
	PROCEDURE Fibonacci (index: INTEGER): INTEGER;
		PROCEDURE Compute (increment: INTEGER): INTEGER;
		BEGIN INC (activations, increment); IF index < 2 THEN RETURN index END; RETURN Fibonacci (index - 1) + Fibonacci (index - 2);
		END Compute;
	BEGIN RETURN Compute (1);
	END Fibonacci;
	BEGIN activations := 0; ASSERT (Fibonacci (10) = 55); ASSERT (activations = 177);
	END Test.

positive: global variable visible in procedure

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure;
	BEGIN variable := 45;
	END Procedure;
	BEGIN variable := 0; Procedure; ASSERT (variable = 45);
	END Test.

positive: global variable concealed in procedure

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure;
	VAR variable: INTEGER;
	BEGIN variable := 45;
	END Procedure;
	BEGIN variable := 0; Procedure; ASSERT (variable = 0);
	END Test.

positive: local variable visible in procedure

	MODULE Test;
	PROCEDURE Procedure;
	VAR variable: INTEGER;
		PROCEDURE Nested;
		BEGIN variable := 45;
		END Nested;
	BEGIN variable := 0; Nested; ASSERT (variable = 45);
	END Procedure;
	BEGIN Procedure;
	END Test.

positive: local variable concealed in procedure

	MODULE Test;
	PROCEDURE Procedure;
	VAR variable: INTEGER;
		PROCEDURE Nested;
		VAR variable: INTEGER;
		BEGIN variable := 45;
		END Nested;
	BEGIN variable := 0; Nested; ASSERT (variable = 0);
	END Procedure;
	BEGIN Procedure;
	END Test.

positive: parameter visible in procedure

	MODULE Test;
	PROCEDURE Procedure (parameter: INTEGER);
		PROCEDURE Nested;
		BEGIN parameter := 45;
		END Nested;
	BEGIN Nested; ASSERT (parameter = 45);
	END Procedure;
	BEGIN Procedure (0);
	END Test.

positive: parameter concealed in procedure

	MODULE Test;
	PROCEDURE Procedure (parameter: INTEGER);
		PROCEDURE Nested;
		VAR parameter: INTEGER;
		BEGIN parameter := 45;
		END Nested;
	BEGIN Nested; ASSERT (parameter = 0);
	END Procedure;
	BEGIN Procedure (0);
	END Test.

# 10.1 Formal parameters

positive: formal parameters corresponding to actual parameters

	MODULE Test;
	PROCEDURE Procedure (a: BOOLEAN; b: CHAR; c: INTEGER);
	BEGIN ASSERT (a); ASSERT (b = 's'); ASSERT (c = 33);
	END Procedure;
	BEGIN Procedure (TRUE, 's', 21H);
	END Test.

positive: value parameter initialized with actual parameter

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure (value: INTEGER);
	BEGIN ASSERT (value = 1); value := 2;
	END Procedure;
	BEGIN variable := 1; Procedure (variable); ASSERT (variable = 1);
	END Test.

positive: variable parameter standing for actual parameter

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure (VAR value: INTEGER);
	BEGIN ASSERT (value = 1); variable := 2; ASSERT (value = 2); value := 3;
	END Procedure;
	BEGIN variable := 1; Procedure (variable); ASSERT (variable = 3);
	END Test.

positive: open array value parameter

	MODULE Test;
	VAR variable: ARRAY 10 OF CHAR;
	PROCEDURE Procedure (parameter: ARRAY OF CHAR; length: INTEGER);
	BEGIN ASSERT (LEN (parameter) = length); ASSERT (parameter[0] = 't'); parameter[0] := 'u';
	END Procedure;
	BEGIN variable[0] := 't'; Procedure (variable, 10); ASSERT (variable[0] = 't'); Procedure ('t', 2); Procedure ("test", 5);
	END Test.

positive: open array variable parameter

	MODULE Test;
	VAR variable: ARRAY 10 OF CHAR;
	PROCEDURE Procedure (VAR parameter: ARRAY OF CHAR; length: INTEGER);
	BEGIN ASSERT (LEN (parameter) = length); ASSERT (parameter[0] = 't'); parameter[0] := 'u';
	END Procedure;
	BEGIN variable[0] := 't'; Procedure (variable, 10); ASSERT (variable[0] = 'u');
	END Test.

# 10.2 Type-bound procedures

positive: type-bound procedure call on unextended record type

	MODULE Test;
	TYPE Base = RECORD value: INTEGER END;
	VAR variable: Base;
	PROCEDURE (VAR base: Base) Procedure (value: INTEGER);
	BEGIN ASSERT (base.value = 0); base.value := value;
	END Procedure;
	BEGIN variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 1);
	END Test.

positive: type-bound procedure call on extended record type

	MODULE Test;
	TYPE Base = RECORD value: INTEGER END;
	TYPE Extension = RECORD (Base) END;
	VAR variable: Extension;
	PROCEDURE (VAR base: Base) Procedure (value: INTEGER);
	BEGIN ASSERT (base.value = 0); ASSERT (base IS Extension); base.value := value;
	END Procedure;
	BEGIN variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 1);
	END Test.

positive: type-bound procedure calls on extended record type

	MODULE Test;
	TYPE Base = RECORD value: INTEGER END;
	TYPE Extension = RECORD (Base) END;
	VAR variable: Extension;
	PROCEDURE (VAR base: Base) Procedure1;
	BEGIN ASSERT (base.value = 0); ASSERT (base IS Extension); base.value := 1;
	END Procedure1;
	PROCEDURE (VAR extension: Extension) Procedure2;
	BEGIN ASSERT (extension.value = 1); ASSERT (extension IS Extension); extension.value := 2;
	END Procedure2;
	BEGIN variable.value := 0; variable.Procedure1; variable.Procedure2; ASSERT (variable.value = 2);
	END Test.

positive: redefined type-bound procedure call on unextended record type

	MODULE Test;
	TYPE Base = RECORD value: INTEGER END;
	TYPE Extension = RECORD (Base) END;
	VAR variable: Base;
	PROCEDURE (VAR base: Base) Procedure (value: INTEGER);
	BEGIN ASSERT (base.value = 0); base.value := value;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (value: INTEGER);
	BEGIN HALT (123);
	END Procedure;
	BEGIN variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 1);
	END Test.

positive: redefined type-bound procedure call on extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) value: INTEGER END;
	VAR variable: Extension;
	PROCEDURE (VAR base: Base) Procedure (value: INTEGER);
	BEGIN HALT (123);
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (value: INTEGER);
	BEGIN ASSERT (extension.value = 0); ASSERT (extension IS Extension); extension.value := value;
	END Procedure;
	BEGIN variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 1);
	END Test.

positive: type-bound procedure call on pointer to unextended record type

	MODULE Test;
	TYPE Record = RECORD value: INTEGER END;
	TYPE Base = POINTER TO Record;
	VAR variable: Base;
	PROCEDURE (base: Base) Procedure (value: INTEGER);
	BEGIN ASSERT (base.value = 0); base.value := value;
	END Procedure;
	BEGIN NEW (variable); variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 1);
	END Test.

positive: type-bound procedure call on pointer to extended record type

	MODULE Test;
	TYPE Record = RECORD value: INTEGER END;
	TYPE Base = POINTER TO Record;
	TYPE Extension = POINTER TO RECORD (Record) END;
	VAR variable: Extension;
	PROCEDURE (base: Base) Procedure (value: INTEGER);
	BEGIN ASSERT (base.value = 0); ASSERT (base IS Extension); base.value := value;
	END Procedure;
	BEGIN NEW (variable); variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 1);
	END Test.

positive: redefined type-bound procedure call on pointer to unextended record type

	MODULE Test;
	TYPE Record = RECORD value: INTEGER END;
	TYPE Base = POINTER TO Record;
	TYPE Extension = POINTER TO RECORD (Record) END;
	VAR variable: Base;
	PROCEDURE (base: Base) Procedure (value: INTEGER);
	BEGIN ASSERT (base.value = 0); base.value := value;
	END Procedure;
	PROCEDURE (extension: Extension) Procedure (value: INTEGER);
	BEGIN HALT (123);
	END Procedure;
	BEGIN NEW (variable); variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 1);
	END Test.

positive: redefined type-bound procedure call on pointer to extended record type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Base = POINTER TO Record;
	TYPE Extension = RECORD (Record) value: INTEGER END;
	TYPE Pointer = POINTER TO Extension;
	VAR variable: Pointer;
	PROCEDURE (base: Base) Procedure (value: INTEGER);
	BEGIN HALT (123);
	END Procedure;
	PROCEDURE (extension: Pointer) Procedure (value: INTEGER);
	BEGIN ASSERT (extension.value = 0); ASSERT (extension IS Pointer); extension.value := value;
	END Procedure;
	BEGIN NEW (variable); variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 1);
	END Test.

positive: calling redefined type-bound procedure of extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) value: INTEGER END;
	VAR variable: Extension;
	PROCEDURE (VAR base: Base) Procedure (value: INTEGER);
	BEGIN ASSERT (base IS Extension); ASSERT (value = 2); base.Procedure (3);
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (value: INTEGER);
	BEGIN ASSERT (extension IS Extension); extension.value := value; IF value = 1 THEN extension.Procedure^ (2) END;
	END Procedure;
	BEGIN variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 3);
	END Test.

positive: calling redefined type-bound procedure of pointer to extended record type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Base = POINTER TO Record;
	TYPE Extension = RECORD (Record) value: INTEGER END;
	TYPE Pointer = POINTER TO Extension;
	VAR variable: Pointer;
	PROCEDURE (base: Base) Procedure (value: INTEGER);
	BEGIN ASSERT (base IS Pointer); ASSERT (value = 2); base.Procedure (3);
	END Procedure;
	PROCEDURE (extension: Pointer) Procedure (value: INTEGER);
	BEGIN ASSERT (extension IS Pointer); extension.value := value; IF value = 1 THEN extension.Procedure^ (2) END;
	END Procedure;
	BEGIN NEW (variable); variable.value := 0; variable.Procedure (1); ASSERT (variable.value = 3);
	END Test.

# 10.3 Predeclared procedures

positive: SHORTINT absolute value

	MODULE Test;
	VAR value: SHORTINT;
	BEGIN
		value := 5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: INTEGER absolute value

	MODULE Test;
	VAR value: INTEGER;
	BEGIN
		value := 5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: LONGINT absolute value

	MODULE Test;
	VAR value: LONGINT;
	BEGIN
		value := 5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: REAL absolute value

	MODULE Test;
	VAR value: REAL;
	BEGIN
		value := 5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: LONGREAL absolute value

	MODULE Test;
	VAR value: LONGREAL;
	BEGIN
		value := 5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: SHORTINT arithmetic shift

	MODULE Test;
	VAR a, b: SHORTINT;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
		a := 6; b := -2; ASSERT (ASH (a, b) = 1); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (6, -2));
		a := -6; b := 2; ASSERT (ASH (a, b) = -24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (-6, 2));
		a := -6; b := 0; ASSERT (ASH (a, b) = -6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (-6, 0));
		a := -6; b := -2; ASSERT (ASH (a, b) = -2); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (-6, -2));
	END Test.

positive: INTEGER arithmetic shift

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
		a := 6; b := -2; ASSERT (ASH (a, b) = 1); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (6, -2));
		a := -6; b := 2; ASSERT (ASH (a, b) = -24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (-6, 2));
		a := -6; b := 0; ASSERT (ASH (a, b) = -6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (-6, 0));
		a := -6; b := -2; ASSERT (ASH (a, b) = -2); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (-6, -2));
	END Test.

positive: LONGINT arithmetic shift

	MODULE Test;
	VAR a, b: LONGINT;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
		a := 6; b := -2; ASSERT (ASH (a, b) = 1); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (6, -2));
		a := -6; b := 2; ASSERT (ASH (a, b) = -24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (-6, 2));
		a := -6; b := 0; ASSERT (ASH (a, b) = -6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (-6, 0));
		a := -6; b := -2; ASSERT (ASH (a, b) = -2); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (-6, -2));
	END Test.

positive: CHAR capital letter

	MODULE Test;
	VAR value: CHAR;
	BEGIN
		value := '0'; ASSERT (CAP (value) = '0'); ASSERT (CAP (value) = CAP ('0'));
		value := '9'; ASSERT (CAP (value) = '9'); ASSERT (CAP (value) = CAP ('9'));
		value := 'a'; ASSERT (CAP (value) = 'A'); ASSERT (CAP (value) = CAP ('a'));
		value := 'z'; ASSERT (CAP (value) = 'Z'); ASSERT (CAP (value) = CAP ('z'));
		value := 'A'; ASSERT (CAP (value) = 'A'); ASSERT (CAP (value) = CAP ('A'));
		value := 'Z'; ASSERT (CAP (value) = 'Z'); ASSERT (CAP (value) = CAP ('Z'));
	END Test.

positive: CHAR ordinal number

	MODULE Test;
	VAR value: CHAR; i: INTEGER;
	BEGIN
		value := '0'; ASSERT (ORD (value) = ORD ('0'));
		value := '9'; ASSERT (ORD (value) = ORD ('9'));
		value := 'a'; ASSERT (ORD (value) = ORD ('a'));
		value := 'z'; ASSERT (ORD (value) = ORD ('z'));
		value := 'A'; ASSERT (ORD (value) = ORD ('A'));
		value := 'Z'; ASSERT (ORD (value) = ORD ('Z'));
		FOR i := ORD (MIN (CHAR)) TO ORD (MAX (CHAR)) DO value := CHR (i); ASSERT (ORD (value) = i) END;
	END Test.

positive: REAL entier number

	MODULE Test;
	VAR value: REAL;
	BEGIN
		value := 0.; ASSERT (ENTIER (value) = 0); ASSERT (ENTIER (value) = ENTIER (0.));
		value := 1.; ASSERT (ENTIER (value) = 1); ASSERT (ENTIER (value) = ENTIER (1.));
		value := 1.25; ASSERT (ENTIER (value) = 1); ASSERT (ENTIER (value) = ENTIER (1.25));
		value := 1.5; ASSERT (ENTIER (value) = 1); ASSERT (ENTIER (value) = ENTIER (1.5));
		value := 1.75; ASSERT (ENTIER (value) = 1); ASSERT (ENTIER (value) = ENTIER (1.75));
		value := -1.; ASSERT (ENTIER (value) = -1); ASSERT (ENTIER (value) = ENTIER (-1.));
		value := -1.25; ASSERT (ENTIER (value) = -2); ASSERT (ENTIER (value) = ENTIER (-1.25));
		value := -1.5; ASSERT (ENTIER (value) = -2); ASSERT (ENTIER (value) = ENTIER (-1.5));
		value := -1.75; ASSERT (ENTIER (value) = -2); ASSERT (ENTIER (value) = ENTIER (-1.75));
	END Test.

positive: LONGREAL entier number

	MODULE Test;
	VAR value: LONGREAL;
	BEGIN
		value := 0.; ASSERT (ENTIER (value) = 0); ASSERT (ENTIER (value) = ENTIER (0.));
		value := 1.; ASSERT (ENTIER (value) = 1); ASSERT (ENTIER (value) = ENTIER (1.));
		value := 1.25; ASSERT (ENTIER (value) = 1); ASSERT (ENTIER (value) = ENTIER (1.25));
		value := 1.5; ASSERT (ENTIER (value) = 1); ASSERT (ENTIER (value) = ENTIER (1.5));
		value := 1.75; ASSERT (ENTIER (value) = 1); ASSERT (ENTIER (value) = ENTIER (1.75));
		value := -1.; ASSERT (ENTIER (value) = -1); ASSERT (ENTIER (value) = ENTIER (-1.));
		value := -1.25; ASSERT (ENTIER (value) = -2); ASSERT (ENTIER (value) = ENTIER (-1.25));
		value := -1.5; ASSERT (ENTIER (value) = -2); ASSERT (ENTIER (value) = ENTIER (-1.5));
		value := -1.75; ASSERT (ENTIER (value) = -2); ASSERT (ENTIER (value) = ENTIER (-1.75));
	END Test.

positive: length of one-dimensional open array

	MODULE Test;
	VAR a: ARRAY 10 OF INTEGER;
	PROCEDURE Procedure (p: ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p) = len);
	END Procedure;
	BEGIN Procedure (a, 10); Procedure (a, LEN (a));
	END Test.

positive: first dimension of one-dimensional open array

	MODULE Test;
	VAR a: ARRAY 10 OF INTEGER;
	PROCEDURE Procedure (p: ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p, 0) = len);
	END Procedure;
	BEGIN Procedure (a, 10); Procedure (a, LEN (a, 0));
	END Test.

positive: length of two-dimensional open array

	MODULE Test;
	VAR a: ARRAY 10, 5 OF INTEGER;
	PROCEDURE Procedure (p: ARRAY OF ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p) = len);
	END Procedure;
	BEGIN Procedure (a, 10); Procedure (a, LEN (a));
	END Test.

positive: first dimension of two-dimensional open array

	MODULE Test;
	VAR a: ARRAY 10, 5 OF INTEGER;
	PROCEDURE Procedure (p: ARRAY OF ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p, 0) = len);
	END Procedure;
	BEGIN Procedure (a, 10); Procedure (a, LEN (a, 0));
	END Test.

positive: second dimension of two-dimensional open array

	MODULE Test;
	VAR a: ARRAY 10, 5 OF INTEGER;
	PROCEDURE Procedure (p: ARRAY OF ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p, 1) = len);
	END Procedure;
	BEGIN Procedure (a, 5); Procedure (a, LEN (a, 1));
	END Test.

positive: length of one-dimensional variable open array

	MODULE Test;
	VAR a: ARRAY 10 OF INTEGER;
	PROCEDURE Procedure (VAR p: ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p) = len);
	END Procedure;
	BEGIN Procedure (a, 10); Procedure (a, LEN (a));
	END Test.

positive: first dimension of one-dimensional variable open array

	MODULE Test;
	VAR a: ARRAY 10 OF INTEGER;
	PROCEDURE Procedure (VAR p: ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p, 0) = len);
	END Procedure;
	BEGIN Procedure (a, 10); Procedure (a, LEN (a, 0));
	END Test.

positive: length of two-dimensional variable open array

	MODULE Test;
	VAR a: ARRAY 10, 5 OF INTEGER;
	PROCEDURE Procedure (VAR p: ARRAY OF ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p) = len);
	END Procedure;
	BEGIN Procedure (a, 10); Procedure (a, LEN (a));
	END Test.

positive: first dimension of two-dimensional variable open array

	MODULE Test;
	VAR a: ARRAY 10, 5 OF INTEGER;
	PROCEDURE Procedure (VAR p: ARRAY OF ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p, 0) = len);
	END Procedure;
	BEGIN Procedure (a, 10); Procedure (a, LEN (a, 0));
	END Test.

positive: second dimension of two-dimensional variable open array

	MODULE Test;
	VAR a: ARRAY 10, 5 OF INTEGER;
	PROCEDURE Procedure (VAR p: ARRAY OF ARRAY OF INTEGER; len: INTEGER);
	BEGIN ASSERT (LEN (p, 1) = len);
	END Procedure;
	BEGIN Procedure (a, 5); Procedure (a, LEN (a, 1));
	END Test.

positive: SHORTINT oddness

	MODULE Test;
	VAR value: SHORTINT;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
		value := -5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: INTEGER oddness

	MODULE Test;
	VAR value: INTEGER;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
		value := -5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: LONGINT oddness

	MODULE Test;
	VAR value: LONGINT;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
		value := -5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: satisfied assertion

	MODULE Test;
	VAR condition: BOOLEAN;
	BEGIN condition := TRUE; ASSERT (condition);
	END Test.

negative: unsatisfied assertion

	MODULE Test;
	VAR condition: BOOLEAN;
	BEGIN condition := FALSE; ASSERT (condition);
	END Test.

positive: copy of array of character

	MODULE Test;
	VAR a, b: ARRAY 10 OF CHAR;
	BEGIN a := "text"; b := "ignored"; COPY (a, b); ASSERT (b = "text");
	END Test.

positive: truncated copy of array of character

	MODULE Test;
	VAR a: ARRAY 20 OF CHAR; b: ARRAY 10 OF CHAR;
	BEGIN a := "very long text"; b := "ignored"; COPY (a, b); ASSERT (b = "very long");
	END Test.

positive: copy of open array of character

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	PROCEDURE Procedure (a: ARRAY OF CHAR; VAR b: ARRAY OF CHAR);
	BEGIN COPY (a, b);
	END Procedure;
	BEGIN array := "ignored"; Procedure ("text", array); ASSERT (array = "text");
	END Test.

positive: truncated copy of open array of character

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	PROCEDURE Procedure (a: ARRAY OF CHAR; VAR b: ARRAY OF CHAR);
	BEGIN COPY (a, b);
	END Procedure;
	BEGIN array := "ignored"; Procedure ("very long text", array); ASSERT (array = "very long");
	END Test.

positive: copy of string

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array := "ignored"; COPY ("text", array); ASSERT (array = "text");
	END Test.

positive: truncated copy of string

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array := "ignored"; COPY ("very long text", array); ASSERT (array = "very long");
	END Test.

positive: SHORTINT decrement

	MODULE Test;
	VAR a, b, c: SHORTINT;
	BEGIN a := 0; b := 3; c := -4;
		DEC (a); ASSERT (a = -1); INC (a); ASSERT (a = 0);
		DEC (a, 2); ASSERT (a = -2); DEC (a, -2); ASSERT (a = 0);
		DEC (a, b); ASSERT (a = -b); DEC (a, -b); ASSERT (a = 0);
		DEC (a, c); ASSERT (a = -c); DEC (a, -c); ASSERT (a = 0);
	END Test.

positive: INTEGER decrement

	MODULE Test;
	VAR a, b, c: INTEGER;
	BEGIN a := 0; b := 3; c := -4;
		DEC (a); ASSERT (a = -1); INC (a); ASSERT (a = 0);
		DEC (a, 2); ASSERT (a = -2); DEC (a, -2); ASSERT (a = 0);
		DEC (a, b); ASSERT (a = -b); DEC (a, -b); ASSERT (a = 0);
		DEC (a, c); ASSERT (a = -c); DEC (a, -c); ASSERT (a = 0);
	END Test.

positive: LONGINT decrement

	MODULE Test;
	VAR a, b, c: LONGINT;
	BEGIN a := 0; b := 3; c := -4;
		DEC (a); ASSERT (a = -1); INC (a); ASSERT (a = 0);
		DEC (a, 2); ASSERT (a = -2); DEC (a, -2); ASSERT (a = 0);
		DEC (a, b); ASSERT (a = -b); DEC (a, -b); ASSERT (a = 0);
		DEC (a, c); ASSERT (a = -c); DEC (a, -c); ASSERT (a = 0);
	END Test.

positive: SHORTINT exclusion

	MODULE Test;
	VAR set: SET; element: SHORTINT;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: INTEGER exclusion

	MODULE Test;
	VAR set: SET; element: INTEGER;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: LONGINT exclusion

	MODULE Test;
	VAR set: SET; element: LONGINT;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: SHORTINT increment

	MODULE Test;
	VAR a, b, c: SHORTINT;
	BEGIN a := 0; b := 3; c := -4;
		INC (a); ASSERT (a = 1); DEC (a); ASSERT (a = 0);
		INC (a, 2); ASSERT (a = 2); INC (a, -2); ASSERT (a = 0);
		INC (a, b); ASSERT (a = b); INC (a, -b); ASSERT (a = 0);
		INC (a, c); ASSERT (a = c); INC (a, -c); ASSERT (a = 0);
	END Test.

positive: INTEGER increment

	MODULE Test;
	VAR a, b, c: INTEGER;
	BEGIN a := 0; b := 3; c := -4;
		INC (a); ASSERT (a = 1); DEC (a); ASSERT (a = 0);
		INC (a, 2); ASSERT (a = 2); INC (a, -2); ASSERT (a = 0);
		INC (a, b); ASSERT (a = b); INC (a, -b); ASSERT (a = 0);
		INC (a, c); ASSERT (a = c); INC (a, -c); ASSERT (a = 0);
	END Test.

positive: LONGINT increment

	MODULE Test;
	VAR a, b, c: LONGINT;
	BEGIN a := 0; b := 3; c := -4;
		INC (a); ASSERT (a = 1); DEC (a); ASSERT (a = 0);
		INC (a, 2); ASSERT (a = 2); INC (a, -2); ASSERT (a = 0);
		INC (a, b); ASSERT (a = b); INC (a, -b); ASSERT (a = 0);
		INC (a, c); ASSERT (a = c); INC (a, -c); ASSERT (a = 0);
	END Test.

positive: SHORTINT inclusion

	MODULE Test;
	VAR set: SET; element: SHORTINT;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: INTEGER inclusion

	MODULE Test;
	VAR set: SET; element: INTEGER;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: LONGINT inclusion

	MODULE Test;
	VAR set: SET; element: LONGINT;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: allocation on pointer to array

	MODULE Test;
	VAR p: POINTER TO ARRAY 10 OF INTEGER;
	BEGIN NEW (p); ASSERT (p # NIL); ASSERT (LEN (p^) = 10); p[2] := 3; p[1] := p[2]; ASSERT (p[2] = 3);
	END Test.

positive: allocation on pointer to open array

	MODULE Test;
	VAR p: POINTER TO ARRAY OF INTEGER;
	BEGIN NEW (p, 10); ASSERT (p # NIL); ASSERT (LEN (p^) = 10); p[2] := 3; p[1] := p[2]; ASSERT (p[2] = 3);
	END Test.

positive: allocation on pointer to record

	MODULE Test;
	VAR p: POINTER TO RECORD a, b: INTEGER END;
	BEGIN NEW (p); ASSERT (p # NIL); p.a := 3; p.b := p.a; ASSERT (p.b = 3);
	END Test.

# 11. Modules

positive: Gaussian natural sum

	MODULE Test;
	CONST Count = 100; Result = Count * (Count - 1) DIV 2;
	VAR i, sum: INTEGER; a: ARRAY Count OF INTEGER;
	BEGIN
		FOR i := 0 TO Count - 1 DO a[i] := i END; i := 0; sum := 0;
		WHILE i < Count DO INC (sum, a[i]); INC (i) END; ASSERT (sum = Result);
	END Test.

positive: sudoku solver

	MODULE Test;
	CONST Empty = '0'; Blocks = 3; Columns = Blocks * Blocks; Cells = Columns * Columns;
	TYPE Cell = INTEGER; Value = CHAR; Game = ARRAY Cells + 1 OF Value;
	PROCEDURE IsValidCell (VAR game: Game; cell: Cell): BOOLEAN;
	VAR value: Value; VAR row, column: Cell;
		PROCEDURE Check (start, stride: Cell): BOOLEAN;
		VAR cells, count: Cell;
		BEGIN count := stride; FOR cells := 0 TO Columns - 1 DO IF (start # cell) & (game[start] = value) THEN RETURN FALSE END;
			DEC (count); IF count = 0 THEN count := stride; INC (start, Columns + 1 - stride) ELSE INC (start) END END; RETURN TRUE;
		END Check;
	BEGIN value := game[cell]; IF value = Empty THEN RETURN TRUE END; row := cell DIV Columns; column := cell MOD Columns;
		RETURN Check (cell - column, Columns) & Check (column, 1) & Check (cell - row MOD Blocks * Columns - column MOD Blocks, Blocks);
	END IsValidCell;
	PROCEDURE IsValid (VAR game: Game): BOOLEAN;
	VAR cell: Cell; BEGIN FOR cell := 0 TO Cells - 1 DO IF ~IsValidCell (game, cell) THEN RETURN FALSE END END; RETURN TRUE;
	END IsValid;
	PROCEDURE Solve (VAR game: Game): BOOLEAN;
	VAR cell: Cell; value: INTEGER;
	BEGIN FOR cell := 0 TO Cells - 1 DO IF game[cell] = Empty THEN FOR value := ORD (Empty) + 1 TO ORD (Empty) + Columns DO game[cell] := CHR (value);
		IF IsValidCell (game, cell) & Solve (game) THEN RETURN TRUE END END; game[cell] := Empty; RETURN FALSE END END; RETURN IsValid (game);
	END Solve;
	PROCEDURE Check (problem, solution: Game);
	VAR game: Game; BEGIN ASSERT (IsValid (problem)); ASSERT (IsValid (solution)); game := problem; ASSERT (Solve (game)); ASSERT (game = solution);
	END Check;
	BEGIN Check ("003020080090500000018609074600047390080205040059160007930402760000006010040070900", "563724189794581236218639574621847395387295641459163827935412768872956413146378952");
	END Test.

positive: towers of hanoi

	MODULE Test;
	PROCEDURE Test (size: INTEGER);
	VAR tower: ARRAY 3 OF INTEGER; moves: INTEGER;
	PROCEDURE Move (count, from, to: INTEGER);
	BEGIN ASSERT (count > 0); ASSERT (count <= tower[from]);
		IF count > 1 THEN Move (count - 1, from, 3 - from - to) END;
		ASSERT (tower[from] > 0); DEC (tower[from]); INC (tower[to]); INC (moves);
		IF count > 1 THEN Move (count - 1, 3 - from - to, to) END;
	END Move;
	BEGIN tower[0] := size; tower[1] := 0; tower[2] := 0; moves := 0; Move (size, 0, 1);
		ASSERT (tower[0] = 0); ASSERT (tower[1] = size); ASSERT (tower[2] = 0); ASSERT (moves = ASH (1, size) - 1);
	END Test;
	BEGIN Test (2); Test (4); Test (8);
	END Test.

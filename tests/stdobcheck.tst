# Standard Oberon compilation test and validation suite
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

# 3. Vocabulary and Representation

negative: blanks in identifiers

	MODULE Te st;
	END Test.

negative: blanks in numbers

	MODULE Test;
	CONST C = 12 34;
	END Test.

positive: blanks in strings

	MODULE Test;
	CONST C = "ab cd";
	END Test.

negative: blanks in operators

	MODULE Test;
	CONST C = 1 < = 2;
	END Test.

negative: blanks in delimiters

	MODULE Test;
	CONST C = 1 . . 2;
	END Test.

negative: line break in identifiers

	MODULE Te
	st;
	END Test.

negative: line break in numbers

	MODULE Test;
	CONST C = 12
	34;
	END Test.

negative: line break in operators

	MODULE Test;
	CONST C = 1 <
	= 2;
	END Test.

negative: line break in delimiters

	MODULE Test;
	CONST C = 1 .
	. 2;
	END Test.

negative: distinct capital and lower-case letters

	MODULE Test;
	END test.

positive: identifier as sequence of letters

	MODULE Test;
	CONST abcdefghijklmnopqrstuvwxyz = 0;
	END Test.

negative: identifier as sequence of digits

	MODULE Test;
	CONST 0123456789 = 0;
	END Test.

positive: identifier as sequence of letters and digits

	MODULE Test;
	CONST a0b1c2d3e4f5g6h7i8j9 = 0;
	END Test.

positive: identifier beginning with letter

	MODULE Test;
	CONST a0 = 0;
	END Test.

negative: identifier beginning with digit

	MODULE Test;
	CONST 0a = 0;
	END Test.

positive: identifier examples

	MODULE Test;
	CONST x = 0; Scan = 0; Oberon2 = 0; GetSymbol = 0; firstLetter = 0;
	END Test.

positive: integer constant with single digit

	MODULE Test;
	CONST Integer = 0;
	END Test.

positive: integer constant with multiple digits

	MODULE Test;
	CONST Integer = 0123456789;
	END Test.

positive: hexadecimal integer constant with single digit

	MODULE Test;
	CONST Integer = 0H;
	END Test.

positive: hexadecimal integer constant with multiple digits

	MODULE Test;
	CONST Integer = 012345678H;
	END Test.

positive: hexadecimal integer constant with uppercase hexadecimal digits

	MODULE Test;
	CONST Integer = 0ABCDEFH;
	END Test.

negative: hexadecimal integer constant with lowercase hexadecimal digits

	MODULE Test;
	CONST Integer = 0abcdefH;
	END Test.

negative: hexadecimal integer constant beginning with hexadecimal digits

	MODULE Test;
	CONST Integer = ABCH;
	END Test.

positive: hexadecimal integer constant beginning with zero and hexadecimal digits

	MODULE Test;
	CONST Integer = 0ABCH;
	END Test.

positive: hexadecimal integer constant with H suffix

	MODULE Test;
	CONST Integer = 0123ABCH;
	END Test.

negative: hexadecimal integer constant with h suffix

	MODULE Test;
	CONST Integer = 0123ABCh;
	END Test.

negative: hexadecimal integer constant missing H suffix

	MODULE Test;
	CONST Integer = 0123ABC;
	END Test.

positive: decimal integer constant representation

	MODULE Test;
	CONST Integer = 1234;
	BEGIN ASSERT (Integer = 1234);
	END Test.

positive: hexadecimal integer constant representation

	MODULE Test;
	CONST Integer = 1234H;
	BEGIN ASSERT (Integer = 4660);
	END Test.

positive: real number containing decimal point

	MODULE Test;
	CONST Real = 0.0E0;
	END Test.

negative: real number missing decimal point

	MODULE Test;
	CONST Real = 0E0;
	END Test.

negative: real number missing integer part

	MODULE Test;
	CONST Real = .0;
	END Test.

negative: real number with hexadecimal integer part

	MODULE Test;
	CONST Real = 0ABC.0E0;
	END Test.

positive: real number missing fractional part

	MODULE Test;
	CONST Real = 0.;
	END Test.

negative: real number with hexadecimal fractional part

	MODULE Test;
	CONST Real = 0.0ABCE0;
	END Test.

positive: real number missing scale factor

	MODULE Test;
	CONST Real = 0.0E0;
	END Test.

negative: real number with hexadecimal scale factor part

	MODULE Test;
	CONST Real = 0.0E0ABC;
	END Test.

positive: real number missing sign in scale factor

	MODULE Test;
	CONST Real = 0.0E0;
	END Test.

positive: real number with positive sign in scale factor

	MODULE Test;
	CONST Real = 0.0E+0;
	END Test.

positive: real number with negative sign in scale factor

	MODULE Test;
	CONST Real = 0.0E-0;
	END Test.

negative: real number missing digit in scale factor

	MODULE Test;
	CONST Real = 0.0E;
	END Test.

positive: real number with single digit in scale factor

	MODULE Test;
	CONST Real = 0.0E0;
	END Test.

positive: real number with multiple digits in scale factor

	MODULE Test;
	CONST Real = 0.0E000;
	END Test.

negative: real number with letter in scale factor

	MODULE Test;
	CONST Real = 0.0EA;
	END Test.

positive: integer number example

	MODULE Test;
	CONST Constant = 1991;
	VAR variable: INTEGER;
	BEGIN variable := Constant; ASSERT (Constant = 1991);
	END Test.

positive: short integer number example

	MODULE Test;
	CONST Constant = 0DH;
	VAR variable: SHORTINT;
	BEGIN variable := Constant; ASSERT (Constant = 13);
	END Test.

positive: first real number example

	MODULE Test;
	CONST Constant = 12.3;
	VAR variable: REAL;
	BEGIN variable := Constant; ASSERT (Constant = 12.3);
	END Test.

positive: second real number example

	MODULE Test;
	CONST Constant = 4.567E8;
	VAR variable: REAL;
	BEGIN variable := Constant; ASSERT (Constant = 456700000);
	END Test.

positive: long real number example

	MODULE Test;
	CONST Constant = 0.95367431640625D-6;
	VAR variable: LONGREAL;
	BEGIN variable := Constant; ASSERT (Constant = 0.00000095367431640625);
	END Test.

positive: character constant with single digit

	MODULE Test;
	CONST Character = 0X;
	END Test.

positive: character constant with multiple digits

	MODULE Test;
	CONST Character = 012X;
	END Test.

positive: character constant with uppercase hexadecimal digits

	MODULE Test;
	CONST Character = 0ABX;
	END Test.

negative: character constant with lowercase hexadecimal digits

	MODULE Test;
	CONST Character = 0abX;
	END Test.

negative: character constant beginning with hexadecimal digits

	MODULE Test;
	CONST Character = ABX;
	END Test.

positive: character constant beginning with zero and hexadecimal digits

	MODULE Test;
	CONST Character = 0ABX;
	END Test.

positive: character constant with X suffix

	MODULE Test;
	CONST Character = 00012X;
	END Test.

negative: character constant with x suffix

	MODULE Test;
	CONST Character = 00012x;
	END Test.

negative: character constant missing X suffix

	MODULE Test;
	VAR character: CHAR;
	BEGIN character := 00012;
	END Test.

positive: character constant representation

	MODULE Test;
	CONST Character = 65X;
	BEGIN ASSERT (ORD (Character) = 101);
	END Test.

positive: string enclosed in single quote marks

	MODULE Test;
	CONST String = 'string';
	END Test.

positive: string enclosed in double quote marks

	MODULE Test;
	CONST String = "string";
	END Test.

negative: string with single opening quote and double closing quite

	MODULE Test;
	CONST String = 'string";
	END Test.

negative: string with double opening quote and single closing quite

	MODULE Test;
	CONST String = "string';
	END Test.

negative: string enclosed in single quote marks with single quote occurring in the string

	MODULE Test;
	CONST String = 'str'ing';
	END Test.

positive: string enclosed in single quote marks with double quote occurring in the string

	MODULE Test;
	CONST String = 'str"ing';
	END Test.

positive: string enclosed in double quote marks with single quote occurring in the string

	MODULE Test;
	CONST String = "str'ing";
	END Test.

negative: string enclosed in double quote marks with double quote occurring in the string

	MODULE Test;
	CONST String = "str"ing";
	END Test.

positive: using string of length 1 as a character constant

	MODULE Test;
	CONST Character = 'a';
	VAR character: CHAR;
	BEGIN character := Character; ASSERT (ORD (character) = 65);
	END Test.

positive: string examples

	MODULE Test;
	CONST Oberon2 = "Oberon-2"; DontWorry = "Don't worry!"; x = "x";
	END Test.

negative: using reserved word ARRAY as identifier

	MODULE Test;
	CONST ARRAY = 0;
	END Test.

negative: using reserved word BEGIN as identifier

	MODULE Test;
	CONST BEGIN = 0;
	END Test.

negative: using reserved word BY as identifier

	MODULE Test;
	CONST BY = 0;
	END Test.

negative: using reserved word CASE as identifier

	MODULE Test;
	CONST CASE = 0;
	END Test.

negative: using reserved word CONST as identifier

	MODULE Test;
	CONST CONST = 0;
	END Test.

negative: using reserved word DIV as identifier

	MODULE Test;
	CONST DIV = 0;
	END Test.

negative: using reserved word DO as identifier

	MODULE Test;
	CONST DO = 0;
	END Test.

negative: using reserved word ELSE as identifier

	MODULE Test;
	CONST ELSE = 0;
	END Test.

negative: using reserved word ELSIF as identifier

	MODULE Test;
	CONST ELSIF = 0;
	END Test.

negative: using reserved word END as identifier

	MODULE Test;
	CONST END = 0;
	END Test.

negative: using reserved word EXIT as identifier

	MODULE Test;
	CONST EXIT = 0;
	END Test.

negative: using reserved word FOR as identifier

	MODULE Test;
	CONST FOR = 0;
	END Test.

negative: using reserved word IF as identifier

	MODULE Test;
	CONST IF = 0;
	END Test.

negative: using reserved word IMPORT as identifier

	MODULE Test;
	CONST IMPORT = 0;
	END Test.

negative: using reserved word IN as identifier

	MODULE Test;
	CONST IN = 0;
	END Test.

negative: using reserved word IS as identifier

	MODULE Test;
	CONST IS = 0;
	END Test.

negative: using reserved word LOOP as identifier

	MODULE Test;
	CONST LOOP = 0;
	END Test.

negative: using reserved word MOD as identifier

	MODULE Test;
	CONST MOD = 0;
	END Test.

negative: using reserved word MODULE as identifier

	MODULE Test;
	CONST MODULE = 0;
	END Test.

negative: using reserved word NIL as identifier

	MODULE Test;
	CONST NIL = 0;
	END Test.

negative: using reserved word OF as identifier

	MODULE Test;
	CONST OF = 0;
	END Test.

negative: using reserved word OR as identifier

	MODULE Test;
	CONST OR = 0;
	END Test.

negative: using reserved word POINTER as identifier

	MODULE Test;
	CONST POINTER = 0;
	END Test.

negative: using reserved word PROCEDURE as identifier

	MODULE Test;
	CONST PROCEDURE = 0;
	END Test.

negative: using reserved word RECORD as identifier

	MODULE Test;
	CONST RECORD = 0;
	END Test.

negative: using reserved word REPEAT as identifier

	MODULE Test;
	CONST REPEAT = 0;
	END Test.

negative: using reserved word RETURN as identifier

	MODULE Test;
	CONST RETURN = 0;
	END Test.

negative: using reserved word THEN as identifier

	MODULE Test;
	CONST THEN = 0;
	END Test.

negative: using reserved word TO as identifier

	MODULE Test;
	CONST TO = 0;
	END Test.

negative: using reserved word TYPE as identifier

	MODULE Test;
	CONST TYPE = 0;
	END Test.

negative: using reserved word UNTIL as identifier

	MODULE Test;
	CONST UNTIL = 0;
	END Test.

negative: using reserved word VAR as identifier

	MODULE Test;
	CONST VAR = 0;
	END Test.

negative: using reserved word WHILE as identifier

	MODULE Test;
	CONST WHILE = 0;
	END Test.

negative: using reserved word WITH as identifier

	MODULE Test;
	CONST BY = 0;
	END Test.

negative: comment only

	(* MODULE *)

positive: comment in front of module definition

	(* comment *)
	MODULE Test;
	END Test.

positive: comment within module definition

	MODULE Test;
	(* comment *)
	END Test.

positive: comment after module definition

	MODULE Test;
	END Test.
	(* comment *)

positive: arbitrary character sequence in comment

	MODULE Test;
	(*
	+ - * / ~ & . , ; | ( [ { := ^ = # < > <= >= .. : ) ] }
	ARRAY BEGIN BY CASE CONST DIV DO ELSE ELSIF END EXIT FOR IF IMPORT IN IS LOOP MOD MODULE NIL OF OR POINTER PROCEDURE RECORD REPEAT RETURN THEN TO TYPE UNTIL VAR WHILE WITH
	*)
	END Test.

negative: unnopened comment

	MODULE Test;
	comment *)
	END Test.

negative: unclosed comment

	MODULE Test;
	(* comment
	END Test.

positive: nested comment

	MODULE Test;
	(* (* comment *) *)
	END Test.

negative: unnopened nested comment

	MODULE Test;
	(* comment *) *)
	END Test.

negative: unclosed nested comment

	MODULE Test;
	(* (* comment *)
	END Test.

positive: comment not affecting the meaning of a program

	MODULE Test;
	BEGIN (* ASSERT (FALSE); *)
	END Test.

# 4. Declarations and scope rules

positive: using declared identifier

	MODULE Test;
	CONST A = 0; B = A;
	END Test.

negative: using undeclared identifier

	MODULE Test;
	CONST B = A;
	END Test.

positive: using predeclared identifier

	MODULE Test;
	CONST B = TRUE;
	END Test.

positive: constant declaration

	MODULE Test;
	CONST Constant = 0;
	END Test.

positive: referring to constant declaration

	MODULE Test;
	CONST Constant = 0; Referrer = Constant;
	END Test.

positive: type declaration

	MODULE Test;
	TYPE Type = RECORD END;
	END Test.

positive: referring to type declaration

	MODULE Test;
	TYPE Type = RECORD END; Referrer = Type;
	END Test.

positive: variable declaration

	MODULE Test;
	VAR variable: CHAR;
	END Test.

positive: referring to variable declaration

	MODULE Test;
	VAR variable: CHAR; referrer: CHAR;
	BEGIN referrer := variable;
	END Test.

positive: procedure declaration

	MODULE Test;
	PROCEDURE Procedure;
	END Procedure;
	END Test.

positive: referring to procedure declaration

	MODULE Test;
	PROCEDURE Procedure;
	VAR procedure: PROCEDURE;
	BEGIN procedure := Procedure;
	END Procedure;
	END Test.

negative: import redeclaration in module block

	MODULE Test;
	IMPORT X := Import, X := Import;
	END Test.

negative: constant redeclaration in module block

	MODULE Test;
	CONST X = FALSE;
	CONST X = TRUE;
	END Test.

positive: constant redeclaration in nested module block

	MODULE Test;
	CONST X = FALSE;
	PROCEDURE N;
	CONST X = TRUE;
	BEGIN ASSERT (X);
	END N;
	END Test.

negative: type redeclaration in module block

	MODULE Test;
	TYPE X = CHAR;
	TYPE X = PROCEDURE;
	END Test.

positive: type redeclaration in nested module block

	MODULE Test;
	TYPE X = CHAR;
	PROCEDURE N;
	TYPE X = PROCEDURE;
	VAR x: X;
	BEGIN x := N;
	END N;
	END Test.

negative: variable redeclaration in module block

	MODULE Test;
	VAR x: CHAR;
	VAR x: INTEGER;
	END Test.

positive: variable redeclaration in nested module block

	MODULE Test;
	VAR x: CHAR;
	PROCEDURE N;
	VAR x: INTEGER;
	BEGIN x := 0;
	END N;
	END Test.

negative: constant redeclaration in procedure block

	MODULE Test;
	PROCEDURE P;
	CONST X = FALSE;
	CONST X = TRUE;
	END P;
	END Test.

positive: constant redeclaration in nested procedure block

	MODULE Test;
	PROCEDURE P;
	CONST X = FALSE;
	PROCEDURE N;
	CONST X = TRUE;
	BEGIN ASSERT (X);
	END N;
	END P;
	END Test.

negative: type redeclaration in procedure block

	MODULE Test;
	PROCEDURE P;
	TYPE X = CHAR;
	TYPE X = PROCEDURE;
	END P;
	END Test.

positive: type redeclaration in nested procedure block

	MODULE Test;
	PROCEDURE P;
	TYPE X = CHAR;
	PROCEDURE N;
	TYPE X = PROCEDURE;
	VAR x: X;
	BEGIN x := P;
	END N;
	END P;
	END Test.

negative: variable redeclaration in procedure block

	MODULE Test;
	PROCEDURE P;
	VAR x: CHAR;
	VAR x: INTEGER;
	END P;
	END Test.

positive: variable redeclaration in nested procedure block

	MODULE Test;
	PROCEDURE P;
	VAR x: CHAR;
	PROCEDURE N;
	VAR x: INTEGER;
	BEGIN x := 0;
	END N;
	END P;
	END Test.

negative: parameter redeclaration in procedure block

	MODULE Test;
	PROCEDURE P (x: CHAR; x: INTEGER);
	END P;
	END Test.

positive: parameter redeclaration in nested procedure block

	MODULE Test;
	PROCEDURE P (x: CHAR);
	PROCEDURE N (x: INTEGER);
	BEGIN x := 0;
	END N;
	END P;
	END Test.

negative: field redeclaration in record block

	MODULE Test;
	TYPE R = RECORD
		x: CHAR;
		x: INTEGER;
	END;
	END Test.

positive: field redeclaration in nested procedure block

	MODULE Test;
	TYPE R = RECORD
		x: CHAR;
		y: RECORD x: INTEGER END;
	END;
	END Test.

negative: referencing object outside procedure scope

	MODULE Test;
	PROCEDURE P;
	VAR x: INTEGER;
	END P;
	BEGIN x := 0;
	END Test.

negative: referencing object outside record scope

	MODULE Test;
	TYPE R = RECORD x: INTEGER END;
	BEGIN x := 0;
	END Test.

positive: pointer type declaration in module scope with known base type

	MODULE Test;
	TYPE B = RECORD END;
	TYPE T = POINTER TO B;
	END Test.

positive: pointer type declaration in module scope with unknown base type

	MODULE Test;
	TYPE T = POINTER TO B;
	TYPE B = RECORD END;
	END Test.

negative: pointer type declaration in module scope with invalid base type

	MODULE Test;
	TYPE T = POINTER TO B;
	CONST B = 0;
	END Test.

negative: pointer type declaration in module scope with undeclared base type

	MODULE Test;
	TYPE T = POINTER TO B;
	END Test.

negative: pointer type declaration in module scope with base type declared in nested scope

	MODULE Test;
	TYPE T = POINTER TO B;
	PROCEDURE N;
	TYPE B = RECORD END;
	END N;
	END Test.

positive: pointer type declaration in procedure scope with known base type

	MODULE Test;
	PROCEDURE P;
	TYPE B = RECORD END;
	TYPE T = POINTER TO B;
	END P;
	END Test.

positive: pointer type declaration in procedure scope with unknown base type

	MODULE Test;
	PROCEDURE P;
	TYPE T = POINTER TO B;
	TYPE B = RECORD END;
	END P;
	END Test.

negative: pointer type declaration in procedure scope with invalid base type

	MODULE Test;
	PROCEDURE P;
	TYPE T = POINTER TO B;
	CONST B = 0;
	END P;
	END Test.

negative: pointer type declaration in procedure scope with undeclared base type

	MODULE Test;
	PROCEDURE P;
	TYPE T = POINTER TO B;
	END P;
	END Test.

negative: pointer type declaration in procedure scope with base type declared in nested scope

	MODULE Test;
	PROCEDURE P;
	TYPE T = POINTER TO B;
	PROCEDURE N;
	TYPE B = RECORD END;
	END N;
	END P;
	END Test.

positive: pointer type declaration in record scope with known base type

	MODULE Test;
	TYPE B = RECORD END;
	TYPE T = RECORD p: POINTER TO B END;
	END Test.

negative: pointer type declaration in record scope with undeclared base type

	MODULE Test;
	TYPE T = RECORD p: POINTER TO B END;
	END Test.

negative: pointer type declaration in record scope with base type declared in nested scope

	MODULE Test;
	TYPE T = RECORD p: POINTER TO B END;
	PROCEDURE N;
	TYPE B = RECORD END;
	END N;
	END Test.

positive: identifier denoting field in record designator

	MODULE Test;
	VAR record: RECORD field: INTEGER END;
	BEGIN record.field := 0;
	END Test.

negative: identifier denoting field outside record designator

	MODULE Test;
	VAR record: RECORD field: INTEGER END;
	BEGIN field := 0;
	END Test.

positive: identifier denoting type-bound procedure in record designator

	MODULE Test;
	TYPE Record = RECORD END;
	VAR record: Record;
	PROCEDURE (VAR record: Record) P; END P;
	BEGIN record.P ();
	END Test.

negative: identifier denoting type-bound procedure outside record designator

	MODULE Test;
	TYPE Record = RECORD END;
	VAR record: Record;
	PROCEDURE (VAR record: Record) P; END P;
	BEGIN P ();
	END Test.

positive: constant declared without export mark in module block

	MODULE Test;
	CONST Constant = 0;
	END Test.

positive: constant declared with export mark in module block

	MODULE Test;
	CONST Constant* = 0;
	END Test.

positive: type declared without export mark in module block

	MODULE Test;
	TYPE Type = CHAR;
	END Test.

positive: type declared with export mark in module block

	MODULE Test;
	TYPE Type* = CHAR;
	END Test.

positive: variable declared without export mark in module block

	MODULE Test;
	VAR variable: CHAR;
	END Test.

positive: variable declared with export mark in module block

	MODULE Test;
	VAR variable*: CHAR;
	END Test.

positive: variable declared with read-only mark in module block

	MODULE Test;
	VAR variable-: CHAR;
	END Test.

positive: procedure declared without export mark in module block

	MODULE Test;
	PROCEDURE Procedure; END Procedure;
	END Test.

positive: procedure declared with export mark in module block

	MODULE Test;
	PROCEDURE Procedure*; END Procedure;
	END Test.

positive: constant declared without export mark in procedure block

	MODULE Test;
	PROCEDURE P;
	CONST Constant = 0;
	END P;
	END Test.

negative: constant declared with export mark in procedure block

	MODULE Test;
	PROCEDURE P;
	CONST Constant* = 0;
	END P;
	END Test.

negative: constant declared with read-only mark in procedure block

	MODULE Test;
	PROCEDURE P;
	CONST Constant- = 0;
	END P;
	END Test.

positive: type declared without export mark in procedure block

	MODULE Test;
	PROCEDURE P;
	TYPE Type = CHAR;
	END P;
	END Test.

negative: type declared with export mark in procedure block

	MODULE Test;
	PROCEDURE P;
	TYPE Type* = CHAR;
	END P;
	END Test.

negative: type declared with read-only mark in procedure block

	MODULE Test;
	PROCEDURE P;
	TYPE Type- = CHAR;
	END P;
	END Test.

positive: variable declared without export mark in procedure block

	MODULE Test;
	PROCEDURE P;
	VAR variable: CHAR;
	END P;
	END Test.

negative: variable declared with export mark in procedure block

	MODULE Test;
	PROCEDURE P;
	VAR variable*: CHAR;
	END P;
	END Test.

negative: variable declared with read-only mark in procedure block

	MODULE Test;
	PROCEDURE P;
	VAR variable-: CHAR;
	END P;
	END Test.

positive: procedure declared without export mark in procedure block

	MODULE Test;
	PROCEDURE P;
	PROCEDURE Procedure; END Procedure;
	END P;
	END Test.

negative: procedure declared with export mark in procedure block

	MODULE Test;
	PROCEDURE P;
	PROCEDURE Procedure*; END Procedure;
	END P;
	END Test.

negative: procedure declared with read-only mark in procedure block

	MODULE Test;
	PROCEDURE P;
	PROCEDURE Procedure-; END Procedure;
	END P;
	END Test.

positive: parameter declared without export mark in procedure block

	MODULE Test;
	PROCEDURE P (parameter: INTEGER);
	END P;
	END Test.

negative: parameter declared with export mark in procedure block

	MODULE Test;
	PROCEDURE P (parameter*: INTEGER);
	END P;
	END Test.

positive: parameter declared with read-only mark in procedure block

	MODULE Test;
	PROCEDURE P (parameter-: INTEGER);
	END P;
	END Test.

negative: using constant declared without export mark

	MODULE Test;
	IMPORT Import;
	CONST Constant = Import.Constant;
	END Test.

positive: using constant declared with export mark

	MODULE Test;
	IMPORT Import;
	CONST Constant = Import.ExportedConstant;
	END Test.

negative: using type declared without export mark

	MODULE Test;
	IMPORT Import;
	TYPE Type = Import.Type;
	END Test.

positive: using type declared with export mark

	MODULE Test;
	IMPORT Import;
	TYPE Type = Import.ExportedType;
	END Test.

negative: using variable declared without export mark

	MODULE Test;
	IMPORT Import;
	VAR variable: INTEGER;
	BEGIN variable := Import.variable;
	END Test.

positive: using variable declared with export mark

	MODULE Test;
	IMPORT Import;
	VAR variable: INTEGER;
	BEGIN variable := Import.exportedVariable;
	END Test.

positive: modifying variable declared with export mark

	MODULE Test;
	IMPORT Import;
	BEGIN Import.exportedVariable := 0;
	END Test.

positive: using variable declared with read-only mark

	MODULE Test;
	IMPORT Import;
	VAR variable: INTEGER;
	BEGIN variable := Import.readOnlyVariable;
	END Test.

negative: modifying variable declared with read-only mark

	MODULE Test;
	IMPORT Import;
	BEGIN Import.readOnlyVariable := 0;
	END Test.

negative: using procedure declared without export mark

	MODULE Test;
	IMPORT Import;
	BEGIN Import.Procedure ();
	END Test.

positive: using procedure declared with export mark

	MODULE Test;
	IMPORT Import;
	BEGIN Import.ExportedProcedure ();
	END Test.

negative: using field declared without export mark

	MODULE Test;
	IMPORT Import;
	VAR variable: INTEGER; record: Import.ExportedType;
	BEGIN variable := record.field;
	END Test.

positive: using field declared with export mark

	MODULE Test;
	IMPORT Import;
	VAR variable: INTEGER; record: Import.ExportedType;
	BEGIN variable := record.exportedField;
	END Test.

positive: modifying field declared with export mark

	MODULE Test;
	IMPORT Import;
	VAR record: Import.ExportedType;
	BEGIN record.exportedField := 0;
	END Test.

positive: using field declared with read-only mark

	MODULE Test;
	IMPORT Import;
	VAR variable: INTEGER; record: Import.ExportedType;
	BEGIN variable := record.readOnlyField;
	END Test.

negative: modifying field declared with read-only mark

	MODULE Test;
	IMPORT Import;
	VAR record: Import.ExportedType;
	BEGIN record.readOnlyField := 0;
	END Test.

# 5. Constant declarations

negative: constant declaration missing identifier

	MODULE Test;
	CONST = 0;
	END Test.

positive: constant declaration with export mark

	MODULE Test;
	CONST Constant* = 0;
	END Test.

negative: constant declaration with read-only mark

	MODULE Test;
	CONST Constant- = 0;
	END Test.

positive: constant declaration without export mark

	MODULE Test;
	CONST Constant = 0;
	END Test.

negative: constant declaration missing equal sign

	MODULE Test;
	CONST Constant 0;
	END Test.

negative: constant declaration missing expression

	MODULE Test;
	CONST Constant = ;
	END Test.

positive: constant set constructor in constant expression

	MODULE Test;
	CONST Constant = {0};
	END Test.

negative: variable set constructor in constant expression

	MODULE Test;
	VAR variable: INTEGER;
	CONST Constant = {variable};
	END Test.

positive: number in constant expression

	MODULE Test;
	CONST Constant = 3214;
	END Test.

positive: character constant in constant expression

	MODULE Test;
	CONST Constant = 45X;
	END Test.

positive: string in constant expression

	MODULE Test;
	CONST Constant = "string";
	END Test.

negative: true logical disjunction with variable as first operand in constant expression

	MODULE Test;
	VAR variable: BOOLEAN;
	CONST Constant = variable OR TRUE;
	END Test.

positive: true logical disjunction with variable as second operand in constant expression

	MODULE Test;
	VAR variable: BOOLEAN;
	CONST Constant = TRUE OR variable;
	END Test.

negative: false logical disjunction with variable as first operand in constant expression

	MODULE Test;
	VAR variable: BOOLEAN;
	CONST Constant = variable OR FALSE;
	END Test.

negative: false logical disjunction with variable as second operand in constant expression

	MODULE Test;
	VAR variable: BOOLEAN;
	CONST Constant = FALSE OR variable;
	END Test.

negative: true logical conjunction with variable as first operand in constant expression

	MODULE Test;
	VAR variable: BOOLEAN;
	CONST Constant = variable & TRUE;
	END Test.

negative: true logical conjunction with variable as second operand in constant expression

	MODULE Test;
	VAR variable: BOOLEAN;
	CONST Constant = TRUE & variable;
	END Test.

negative: false logical conjunction with variable as first operand in constant expression

	MODULE Test;
	VAR variable: BOOLEAN;
	CONST Constant = variable & FALSE;
	END Test.

positive: false logical conjunction with variable as second operand in constant expression

	MODULE Test;
	VAR variable: BOOLEAN;
	CONST Constant = FALSE & variable;
	END Test.

positive: constant referred in constant expression

	MODULE Test;
	CONST Constant = 0;
	CONST Referrer = Constant;
	END Test.

positive: imported constant referred in constant expression

	MODULE Test;
	IMPORT Import;
	CONST Referrer = Import.ExportedConstant;
	END Test.

negative: variable referred in constant expression

	MODULE Test;
	VAR variable: INTEGER;
	CONST Referrer = variable;
	END Test.

positive: procedure referred in constant expression

	MODULE Test;
	PROCEDURE Procedure;
	CONST Referrer = Procedure;
	END Procedure;
	END Test.

positive: imported procedure referred in constant expression

	MODULE Test;
	IMPORT Import;
	CONST Referrer = Import.ExportedProcedure;
	END Test.

positive: evaluating FALSE in constant expression

	MODULE Test;
	CONST Constant = FALSE;
	BEGIN ASSERT (Constant = FALSE);
	END Test.

positive: evaluating TRUE in constant expression

	MODULE Test;
	CONST Constant = TRUE;
	BEGIN ASSERT (Constant = TRUE);
	END Test.

positive: evaluating ABS in constant expression

	MODULE Test;
	CONST Constant = ABS (-4);
	BEGIN ASSERT (Constant = 4);
	END Test.

positive: evaluating ASH in constant expression

	MODULE Test;
	CONST Constant = ASH (4, 2);
	BEGIN ASSERT (Constant = 16);
	END Test.

positive: evaluating CAP in constant expression

	MODULE Test;
	CONST Constant = CAP ('s');
	BEGIN ASSERT (Constant = 'S');
	END Test.

positive: evaluating CHR in constant expression

	MODULE Test;
	CONST Constant = CHR (42H);
	BEGIN ASSERT (Constant = 42X);
	END Test.

positive: evaluating ENTIER in constant expression

	MODULE Test;
	CONST Constant = ENTIER (-5.2);
	BEGIN ASSERT (Constant = -6);
	END Test.

positive: evaluating LEN in constant expression

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	CONST Constant = LEN (array);
	BEGIN ASSERT (Constant = 10);
	END Test.

positive: evaluating LONG in constant expression

	MODULE Test;
	CONST Constant = LONG (MAX (SHORTINT));
	BEGIN ASSERT (Constant = MAX (SHORTINT));
	END Test.

positive: evaluating MAX in constant expression

	MODULE Test;
	CONST Constant = MAX (INTEGER);
	BEGIN ASSERT (Constant = MAX (INTEGER));
	END Test.

positive: evaluating MIN in constant expression

	MODULE Test;
	CONST Constant = MIN (INTEGER);
	BEGIN ASSERT (Constant = MIN (INTEGER));
	END Test.

positive: evaluating ODD in constant expression

	MODULE Test;
	CONST Constant = ODD (5);
	BEGIN ASSERT (Constant = TRUE);
	END Test.

positive: evaluating ORD in constant expression

	MODULE Test;
	CONST Constant = ORD (65X);
	BEGIN ASSERT (Constant = 65H);
	END Test.

positive: evaluating SHORT in constant expression

	MODULE Test;
	CONST Constant = SHORT (MAX (LONGINT));
	END Test.

positive: evaluating SIZE in constant expression

	MODULE Test;
	CONST Constant = SIZE (INTEGER);
	END Test.

positive: constant declaration examples

	MODULE Test;
	CONST N = 100;
	CONST limit = 2*N - 1;
	CONST fullSet = {MIN(SET) .. MAX(SET)};
	END Test.

# 6. Type declarations

negative: array type containing itself

	MODULE Test;
	TYPE Type = ARRAY 10 OF Type;
	END Test.

negative: record type containing itself

	MODULE Test;
	TYPE Type = RECORD field: Type END;
	END Test.

positive: pointer type containing itself

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF Type;
	END Test.

positive: procedure type containing itself

	MODULE Test;
	TYPE Type = PROCEDURE (): Type;
	END Test.

negative: type declaration missing identifier

	MODULE Test;
	TYPE = CHAR;
	END Test.

positive: type declaration with export mark

	MODULE Test;
	TYPE Type* = CHAR;
	END Test.

negative: type declaration with read-only mark

	MODULE Test;
	TYPE Type- = CHAR;
	END Test.

positive: type declaration without export mark

	MODULE Test;
	TYPE Type = CHAR;
	END Test.

negative: type declaration missing equal sign

	MODULE Test;
	TYPE Type CHAR;
	END Test.

negative: type declaration missing type

	MODULE Test;
	TYPE Type = ;
	END Test.

positive: type declaration examples

	MODULE Test;
	CONST N = 10;
	TYPE Table = ARRAY N OF REAL;
	TYPE Tree = POINTER TO Node;
	TYPE Node = RECORD
		key: INTEGER;
		left, right: Tree
	END;
	TYPE CenterTree = POINTER TO CenterNode;
	TYPE CenterNode = RECORD (Node)
		width: INTEGER;
		subnode: Tree
	END;
	Function = PROCEDURE(x: INTEGER): INTEGER;
	END Test.

# 6.1 Basic types

positive: basic BOOLEAN type

	MODULE Test;
	TYPE Type = BOOLEAN;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic CHAR type

	MODULE Test;
	TYPE Type = CHAR;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic SHORTINT type

	MODULE Test;
	TYPE Type = SHORTINT;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic INTEGER type

	MODULE Test;
	TYPE Type = INTEGER;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic LONGINT type

	MODULE Test;
	TYPE Type = LONGINT;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic REAL type

	MODULE Test;
	TYPE Type = REAL;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic LONGREAL type

	MODULE Test;
	TYPE Type = LONGREAL;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: numeric type hierarchy

	MODULE Test;
	VAR longreal: LONGREAL; real: REAL; longint: LONGINT; integer: INTEGER; shortint: SHORTINT;
	BEGIN longreal := real; real := longint; longint := integer; integer := shortint;
	END Test.

positive: basic SET type

	MODULE Test;
	TYPE Type = SET;
	VAR variable: Type;
	BEGIN
		variable := {};
		variable := {MIN (Type) .. MAX (Type)};
	END Test.

# 6.2 Array types

positive: array elements of same element type

	MODULE Test;
	VAR array: ARRAY 3 OF SET;
	BEGIN array[0] := {0}; array[1] := {1}; array[2] := {2};
	END Test.

positive: array with positive length

	MODULE Test;
	VAR array: ARRAY 1 OF CHAR;
	END Test.

negative: array with zero length

	MODULE Test;
	VAR array: ARRAY 0 OF CHAR;
	END Test.

negative: array with negative length

	MODULE Test;
	VAR array: ARRAY -1 OF CHAR;
	END Test.

negative: array type missing ARRAY

	MODULE Test;
	VAR array: 10 OF CHAR;
	END Test.

positive: array type missing length

	MODULE Test;
	VAR array: POINTER TO ARRAY OF CHAR;
	END Test.

positive: array type with single length

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	END Test.

positive: array type with multiple lengths

	MODULE Test;
	VAR array: ARRAY 10, 20 OF CHAR;
	END Test.

negative: array type with multiple lengths missing comma

	MODULE Test;
	VAR array: ARRAY 10 20 OF CHAR;
	END Test.

negative: array type missing OF

	MODULE Test;
	VAR array: ARRAY 10 CHAR;
	END Test.

negative: array type missing element type

	MODULE Test;
	VAR array: ARRAY 10 OF;
	END Test.

positive: array type abbreviation

	MODULE Test;
	VAR array: ARRAY 1 OF ARRAY 2 OF CHAR; abbreviation: ARRAY 1, 2 OF CHAR;
	BEGIN array[0, 1] := abbreviation[0][1]; array[0][1] := abbreviation[0, 1];
	END Test.

positive: open array as pointer base type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY OF CHAR;
	END Test.

positive: nested open array as pointer base type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY OF ARRAY OF CHAR;
	END Test.

negative: open array as array element type

	MODULE Test;
	TYPE Type = ARRAY 10 OF ARRAY OF CHAR;
	END Test.

positive: nested open array as array element type

	MODULE Test;
	TYPE Type = ARRAY OF ARRAY OF CHAR;
	END Test.

negative: open array as variable type

	MODULE Test;
	VAR variable: ARRAY OF CHAR;
	END Test.

negative: open array as field type

	MODULE Test;
	VAR variable: RECORD field: ARRAY OF CHAR END;
	END Test.

positive: open array as parameter type

	MODULE Test;
	PROCEDURE Procedure (parameter: ARRAY OF CHAR);
	END Procedure;
	END Test.

positive: array type examples

	MODULE Test;
	CONST N = 10;
	TYPE T1 = ARRAY 10, N OF INTEGER;
	TYPE T2 = ARRAY OF CHAR;
	END Test.

# 6.3 Record types

positive: record type with no fields

	MODULE Test;
	TYPE Type = RECORD END;
	END Test.

positive: record type with single field

	MODULE Test;
	TYPE Type = RECORD field: CHAR END;
	END Test.

positive: record type with multiple fields

	MODULE Test;
	TYPE Type = RECORD field1, field2: CHAR; field3: SET END;
	END Test.

positive: record type with multiple fields with same type

	MODULE Test;
	TYPE Type = RECORD field1, field2: CHAR; field3: CHAR END;
	END Test.

positive: record type with multiple fields with different types

	MODULE Test;
	TYPE Type = RECORD field1: SET; field2: CHAR; field3: BOOLEAN END;
	END Test.

positive: scope of field identifier limited to end of record type

	MODULE Test;
	TYPE Type = RECORD field: CHAR END;
	VAR field: CHAR;
	END Test.

negative: using field identifier in variable designator

	MODULE Test;
	VAR record: RECORD field: CHAR END;
	BEGIN field := 0X;
	END Test.

positive: using field identifier in record designator

	MODULE Test;
	VAR record: RECORD field: CHAR END;
	BEGIN record.field := 0X;
	END Test.

negative: using undeclared field identifier in record designator

	MODULE Test;
	VAR record: RECORD END;
	BEGIN record.field := 0X;
	END Test.

negative: record type missing RECORD

	MODULE Test;
	TYPE Type = END;
	END Test.

negative: record type missing END

	MODULE Test;
	TYPE Type = RECORD;
	END Test.

positive: record type with parenthesized base type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD (Base) END;
	END Test.

positive: record type with imported base type

	MODULE Test;
	IMPORT Import;
	TYPE Type = RECORD (Import.ExportedType) END;
	END Test.

negative: record type with base type and missing parentheses

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD Base END;
	END Test.

negative: record type with missing parenthesis before base type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD Base) END;
	END Test.

negative: record type with missing parenthesis after base type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD (Base END;
	END Test.

negative: record type with parentheses and missing base type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD () END;
	END Test.

positive: record type missing field list

	MODULE Test;
	TYPE Record = RECORD END;
	END Test.

positive: record type with empty field list

	MODULE Test;
	TYPE Record = RECORD ; END;
	END Test.

positive: record type with empty field lists

	MODULE Test;
	TYPE Record = RECORD ; ; END;
	END Test.

positive: record type with semicolon after field list

	MODULE Test;
	TYPE Record = RECORD field: CHAR; END;
	END Test.

positive: record type with semicolon before field list

	MODULE Test;
	TYPE Record = RECORD ; field: CHAR END;
	END Test.

negative: record type with field lists missing semicolon

	MODULE Test;
	TYPE Record = RECORD field: CHAR field: CHAR END;
	END Test.

positive: record type with single identifier in field list

	MODULE Test;
	TYPE Record = RECORD field: CHAR END;
	END Test.

positive: record type with multiple identifiers in field list

	MODULE Test;
	TYPE Record = RECORD field1, field2: CHAR END;
	END Test.

negative: record type with multiple identifiers in field list missing comma

	MODULE Test;
	TYPE Record = RECORD field1 field2: CHAR END;
	END Test.

negative: record type with field list missing colon

	MODULE Test;
	TYPE Record = RECORD field CHAR END;
	END Test.

negative: record type with field list missing type

	MODULE Test;
	TYPE Record = RECORD field: END;
	END Test.

negative: boolean type extending record type

	MODULE Test;
	TYPE Base = BOOLEAN;
	TYPE Record = RECORD (Base) END;
	END Test.

negative: character type extending record type

	MODULE Test;
	TYPE Base = CHAR;
	TYPE Record = RECORD (Base) END;
	END Test.

negative: integer type extending record type

	MODULE Test;
	TYPE Base = INTEGER;
	TYPE Record = RECORD (Base) END;
	END Test.

negative: real type extending record type

	MODULE Test;
	TYPE Base = REAL;
	TYPE Record = RECORD (Base) END;
	END Test.

negative: set type extending record type

	MODULE Test;
	TYPE Base = SET;
	TYPE Record = RECORD (Base) END;
	END Test.

negative: array type extending record type

	MODULE Test;
	TYPE Base = ARRAY 10 OF CHAR;
	TYPE Record = RECORD (Base) END;
	END Test.

positive: record type extending record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Record = RECORD (Base) END;
	END Test.

negative: record type extending itself

	MODULE Test;
	TYPE Record = RECORD (Record) END;
	END Test.

negative: pointer type extending record type

	MODULE Test;
	TYPE Base = POINTER TO RECORD END;
	TYPE Record = RECORD (Base) END;
	END Test.

negative: procedure type extending record type

	MODULE Test;
	TYPE Base = PROCEDURE;
	TYPE Record = RECORD (Base) END;
	END Test.

positive: extensible record type example

	MODULE Test;
	TYPE T0 = RECORD x: INTEGER END;
	TYPE T1 = RECORD (T0) y: REAL END;
	END Test.

positive: using field of base type in base type

	MODULE Test;
	TYPE Base = RECORD field: CHAR END;
	TYPE Extension = RECORD (Base) END;
	VAR record: Base;
	BEGIN record.field := 0X;
	END Test.

positive: using field of base type in extended type

	MODULE Test;
	TYPE Base = RECORD field: CHAR END;
	TYPE Extension = RECORD (Base) END;
	VAR record: Extension;
	BEGIN record.field := 0X;
	END Test.

negative: using field of extended type in base type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) field: CHAR END;
	VAR record: Base;
	BEGIN record.field := 0X;
	END Test.

positive: using field of extended type in extended type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) field: CHAR END;
	VAR record: Extension;
	BEGIN record.field := 0X;
	END Test.

negative: same field identifier in base type as in base type

	MODULE Test;
	TYPE Base = RECORD field: CHAR; field: CHAR END;
	TYPE Extension = RECORD (Base) END;
	END Test.

negative: same field identifier in extended type as in base type

	MODULE Test;
	TYPE Base = RECORD field: CHAR; END;
	TYPE Extension = RECORD (Base) field: CHAR END;
	END Test.

negative: same field identifier in extended type as in extended type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) field: CHAR; field: CHAR END;
	END Test.

positive: record type declaration examples

	MODULE Test;
	TYPE T1 = RECORD
		day, month, year: INTEGER
	END;
	TYPE T2 = RECORD
		name, firstname: ARRAY 32 OF CHAR;
		age: INTEGER;
		salary: REAL
	END;
	END Test.

# 6.4 Pointer types

negative: boolean as pointer base type

	MODULE Test;
	TYPE Pointer = POINTER TO BOOLEAN;
	END Test.

negative: character as pointer base type

	MODULE Test;
	TYPE Pointer = POINTER TO CHAR;
	END Test.

negative: integer as pointer base type

	MODULE Test;
	TYPE Pointer = POINTER TO INTEGER;
	END Test.

negative: real as pointer base type

	MODULE Test;
	TYPE Pointer = POINTER TO REAL;
	END Test.

negative: set as pointer base type

	MODULE Test;
	TYPE Pointer = POINTER TO SET;
	END Test.

positive: array as pointer base type

	MODULE Test;
	TYPE Pointer = POINTER TO ARRAY 10 OF CHAR;
	END Test.

positive: record as pointer base type

	MODULE Test;
	TYPE Pointer = POINTER TO RECORD END;
	END Test.

negative: procedure as pointer base type

	MODULE Test;
	TYPE Pointer = POINTER TO PROCEDURE;
	END Test.

positive: pointer types adopting extension relation of their base types

	MODULE Test;
	TYPE T = RECORD END;
	TYPE P = POINTER TO T;
	TYPE T1 = RECORD (T) END;
	TYPE P1 = POINTER TO T1;
	VAR p: P; p1: P1;
	BEGIN p := p1;
	END Test.

negative: pointer type missing POINTER

	MODULE Test;
	TYPE Type = TO RECORD END;
	END Test.

negative: pointer type missing TO

	MODULE Test;
	TYPE Type = POINTER RECORD END;
	END Test.

negative: pointer type missing base type

	MODULE Test;
	TYPE Type = POINTER TO;
	END Test.

positive: allocating record type with no additional arguments

	MODULE Test;
	VAR pointer: POINTER TO RECORD END;
	BEGIN NEW (pointer);
	END Test.

negative: allocating record type with additional argument

	MODULE Test;
	VAR pointer: POINTER TO RECORD END;
	BEGIN NEW (pointer, 10);
	END Test.

positive: allocating array type with no additional arguments

	MODULE Test;
	VAR pointer: POINTER TO ARRAY 10 OF CHAR;
	BEGIN NEW (pointer);
	END Test.

negative: allocating array type with additional argument

	MODULE Test;
	VAR pointer: POINTER TO ARRAY 10 OF CHAR;
	BEGIN NEW (pointer, 10);
	END Test.

negative: allocating open array type with no additional argument

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF CHAR;
	BEGIN NEW (pointer);
	END Test.

positive: allocating open array type with single additional argument

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF CHAR;
	BEGIN NEW (pointer, 10);
	END Test.

negative: allocating open array type with two additional arguments

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF CHAR;
	BEGIN NEW (pointer, 10, 20);
	END Test.

negative: allocating two-dimensional open array type with no additional argument

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN NEW (pointer);
	END Test.

negative: allocating two-dimensional open array type with single additional argument

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN NEW (pointer, 10);
	END Test.

positive: allocating two-dimensional open array type with two additional arguments

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN NEW (pointer, 10, 20);
	END Test.

negative: allocating two-dimensional open array type with three additional arguments

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN NEW (pointer, 10, 20, 30);
	END Test.

positive: pointer to record type assuming NIL

	MODULE Test;
	VAR pointer: POINTER TO RECORD END;
	BEGIN pointer := NIL;
	END Test.

positive: pointer to array type assuming NIL

	MODULE Test;
	VAR pointer: POINTER TO ARRAY 10 OF CHAR;
	BEGIN pointer := NIL;
	END Test.

positive: pointer to open array type assuming NIL

	MODULE Test;
	VAR pointer: POINTER TO ARRAY OF CHAR;
	BEGIN pointer := NIL;
	END Test.

# 6.5 Procedure types

positive: assigning procedure with same number of parameters

	MODULE Test;
	VAR procedure: PROCEDURE (parameter: CHAR);
	PROCEDURE Procedure (parameter: CHAR);
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

negative: assigning procedure with different number of parameters

	MODULE Test;
	VAR procedure: PROCEDURE;
	PROCEDURE Procedure (parameter: CHAR);
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

positive: assigning procedure with same result type

	MODULE Test;
	VAR procedure: PROCEDURE (): CHAR;
	PROCEDURE Procedure (): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

negative: assigning procedure with different result type

	MODULE Test;
	VAR procedure: PROCEDURE (): CHAR;
	PROCEDURE Procedure (): BOOLEAN;
	BEGIN RETURN FALSE;
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

positive: assigning procedure with equal parameter type

	MODULE Test;
	VAR procedure: PROCEDURE (parameter: CHAR);
	PROCEDURE Procedure (parameter: CHAR);
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

negative: assigning procedure with unequal parameter type

	MODULE Test;
	VAR procedure: PROCEDURE (parameter: CHAR);
	PROCEDURE Procedure (parameter: BOOLEAN);
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

positive: assigning procedure with same variable parameter type

	MODULE Test;
	VAR procedure: PROCEDURE (VAR parameter: CHAR);
	PROCEDURE Procedure (VAR parameter: CHAR);
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

negative: assigning procedure with different variable parameter type

	MODULE Test;
	VAR procedure: PROCEDURE (VAR parameter: CHAR);
	PROCEDURE Procedure (parameter: CHAR);
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

negative: assigning predeclared procedure

	MODULE Test;
	VAR procedure: PROCEDURE (x: CHAR): CHAR;
	BEGIN procedure := CAP;
	END Test.

negative: assigning type-bound procedure

	MODULE Test;
	TYPE Record = RECORD END;
	VAR procedure: PROCEDURE; record: Record;
	PROCEDURE (VAR record: Record) Procedure;
	END Procedure;
	BEGIN procedure := record.Procedure;
	END Test.

negative: assigning local procedure

	MODULE Test;
	PROCEDURE Procedure;
	VAR procedure: PROCEDURE;
	PROCEDURE Procedure;
	END Procedure;
	BEGIN procedure := Procedure;
	END Procedure;
	END Test.

positive: assigning global procedure

	MODULE Test;
	VAR procedure: PROCEDURE;
	PROCEDURE Procedure;
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

# 7. Variable declarations

negative: variable declaration missing identifier

	MODULE Test;
	VAR : CHAR;
	END Test.

positive: variable declaration with export mark

	MODULE Test;
	VAR variable*: CHAR;
	END Test.

positive: variable declaration with read-only mark

	MODULE Test;
	VAR variable-: CHAR;
	END Test.

positive: variable declaration without export mark

	MODULE Test;
	VAR variable: CHAR;
	END Test.

negative: variable declaration missing colon

	MODULE Test;
	VAR variable CHAR;
	END Test.

negative: variable declaration missing type

	MODULE Test;
	VAR variable:;
	END Test.

positive: variable declaration examples

	MODULE Test;
	TYPE Tree = POINTER TO Node;
	TYPE Node = RECORD
		key : INTEGER;
		left, right: Tree
	END;
	TYPE Function = PROCEDURE(x: INTEGER): INTEGER;
	VAR i, j, k: INTEGER;
	VAR x, y: REAL;
	VAR p, q: BOOLEAN;
	VAR s: SET;
	VAR F: Function;
	VAR a: ARRAY 100 OF REAL;
	VAR w: ARRAY 16 OF RECORD
		name: ARRAY 32 OF CHAR;
		count: INTEGER
	END;
	VAR t, c: Tree;
	END Test.

# 8.1 Operands

negative: designator referring to an import

	MODULE Test;
	IMPORT Designator := Import;
	VAR variable: INTEGER;
	BEGIN variable := Designator;
	END Test.

positive: designator referring to a constant

	MODULE Test;
	CONST Designator = 0;
	VAR variable: INTEGER;
	BEGIN variable := Designator;
	END Test.

positive: qualified designator referring to a constant

	MODULE Test;
	IMPORT Import;
	VAR variable: INTEGER;
	BEGIN variable := Import.ExportedConstant;
	END Test.

negative: designator referring to a type

	MODULE Test;
	TYPE Designator = INTEGER;
	VAR variable: INTEGER;
	BEGIN variable := Designator;
	END Test.

positive: designator referring to a variable

	MODULE Test;
	VAR Designator: INTEGER;
	VAR variable: INTEGER;
	BEGIN variable := Designator;
	END Test.

positive: designator referring to a variable followed by selectors

	MODULE Test;
	VAR Designator: RECORD field: INTEGER END;
	VAR variable: INTEGER;
	BEGIN variable := Designator.field;
	END Test.

positive: qualified designator referring to a variable

	MODULE Test;
	IMPORT Import;
	VAR variable: INTEGER;
	BEGIN variable := Import.exportedVariable;
	END Test.

positive: designator referring to a procedure

	MODULE Test;
	VAR variable: PROCEDURE;
	PROCEDURE Designator; END Designator;
	BEGIN variable := Designator;
	END Test.

positive: qualified designator referring to a procedure

	MODULE Test;
	IMPORT Import;
	VAR variable: PROCEDURE;
	BEGIN variable := Import.ExportedProcedure;
	END Test.

positive: selector with identifier

	MODULE Test;
	TYPE Record = RECORD field: CHAR END;
	VAR record: Record;
	BEGIN record.field := 0X;
	END Test.

negative: selector missing dot

	MODULE Test;
	TYPE Record = RECORD field: CHAR END;
	VAR record: Record;
	BEGIN record field := 0X;
	END Test.

negative: selector missing identifier

	MODULE Test;
	TYPE Record = RECORD field: CHAR END;
	VAR record: Record;
	BEGIN record. := record;
	END Test.

positive: array designator with single expression

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[0] := 0X;
	END Test.

positive: array designator with multiple expressions

	MODULE Test;
	VAR array: ARRAY 10, 20 OF CHAR;
	BEGIN array[0, 0] := 0X;
	END Test.

negative: array designator missing expressions

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array [] := array;
	END Test.

negative: array designator missing opening bracket

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array 0] := 0X;
	END Test.

negative: array designator missing closing bracket

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array [0 := 0X;
	END Test.

positive: dereference designator with pointer

	MODULE Test;
	TYPE Record = RECORD END;
	VAR pointer: POINTER TO Record; record: Record;
	BEGIN record := pointer^;
	END Test.

negative: dereference designator with pointer after dot

	MODULE Test;
	TYPE Record = RECORD END;
	VAR pointer: POINTER TO Record; record: Record;
	BEGIN record := pointer.^;
	END Test.

negative: dereference designator missing pointer

	MODULE Test;
	TYPE Record = RECORD END;
	VAR pointer: POINTER TO Record; record: Record;
	BEGIN record := pointer;
	END Test.

negative: type guard missing opening parenthesis

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE Procedure (VAR record: Record);
	BEGIN record := record Record);
	END Procedure;
	END Test.

negative: type guard with nested parentheses

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE Procedure (VAR record: Record);
	BEGIN record := record ((Record));
	END Procedure;
	END Test.

negative: type guard missing closing parenthesis

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE Procedure (VAR record: Record);
	BEGIN record := record(Record;
	END Procedure;
	END Test.

negative: type guard missing type identifier

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE Procedure (VAR record: Record);
	BEGIN record := record();
	END Procedure;
	END Test.

positive: type guard with type identifier

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE Procedure (VAR record: Record);
	BEGIN record := record(Record);
	END Procedure;
	END Test.

negative: type guard with record type

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE Procedure (VAR record: Record);
	BEGIN record := record(RECORD (Record) END);
	END Procedure;
	END Test.

negative: indexing boolean variable

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN variable[0] := variable[0];
	END Test.

negative: indexing character variable

	MODULE Test;
	VAR variable: CHAR;
	BEGIN variable[0] := variable[0];
	END Test.

negative: indexing integer variable

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN variable[0] := variable[0];
	END Test.

negative: indexing real variable

	MODULE Test;
	VAR variable: REAL;
	BEGIN variable[0] := variable[0];
	END Test.

negative: indexing set variable

	MODULE Test;
	VAR variable: SET;
	BEGIN variable[0] := variable[0];
	END Test.

positive: indexing array variable

	MODULE Test;
	VAR variable: ARRAY 10 OF CHAR;
	BEGIN variable[0] := variable[0];
	END Test.

negative: indexing record variable

	MODULE Test;
	VAR variable: RECORD END;
	BEGIN variable[0] := variable[0];
	END Test.

negative: indexing pointer to record variable

	MODULE Test;
	VAR variable: POINTER TO RECORD END;
	BEGIN variable[0] := variable[0];
	END Test.

positive: indexing pointer to array variable

	MODULE Test;
	VAR variable: POINTER TO ARRAY 10 OF CHAR;
	BEGIN variable[0] := variable[0];
	END Test.

negative: indexing procedure variable

	MODULE Test;
	VAR variable: PROCEDURE;
	BEGIN variable[0] := variable[0];
	END Test.

negative: boolean index designator

	MODULE Test;
	VAR index: BOOLEAN;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

negative: character index designator

	MODULE Test;
	VAR index: CHAR;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

positive: integer index designator

	MODULE Test;
	VAR index: INTEGER;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

negative: real index designator

	MODULE Test;
	VAR index: REAL;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

negative: set index designator

	MODULE Test;
	VAR index: SET;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

negative: array index designator

	MODULE Test;
	VAR index: ARRAY 10 OF INTEGER;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

negative: record index designator

	MODULE Test;
	VAR index: RECORD END;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

negative: pointer index designator

	MODULE Test;
	VAR index: POINTER TO ARRAY OF INTEGER;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

negative: procedure index designator

	MODULE Test;
	VAR index: PROCEDURE;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[index] := array[index];
	END Test.

positive: expression list as array index

	MODULE Test;
	VAR index: INTEGER;
	VAR array: ARRAY 10, 10, 10 OF CHAR;
	BEGIN array[index, 0, 10 - index] := 0X;
	END Test.

negative: expression list as array index missing comma

	MODULE Test;
	VAR index: INTEGER;
	VAR array: ARRAY 10, 10, 10 OF CHAR;
	BEGIN array[index 0 10 - index] := 0X;
	END Test.

negative: expression list as one dimensional array index

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN array[0, 0] := array[0, 0];
	END Test.

positive: expression list as two dimensional array index

	MODULE Test;
	VAR array: ARRAY 10, 10 OF CHAR;
	BEGIN array[0, 0] := array[0][0];
	END Test.

negative: expression list as three dimensional array index

	MODULE Test;
	VAR array: ARRAY 10, 10 OF CHAR;
	BEGIN array[0, 0, 0] := array[0, 0, 0];
	END Test.

positive: selector denoting field

	MODULE Test;
	VAR record: RECORD field: CHAR END;
	BEGIN record.field := 0X;
	END Test.

positive: selector denoting bound procedure

	MODULE Test;
	TYPE Record = RECORD END;
	VAR record: Record;
	PROCEDURE (VAR record: Record) Procedure; END Procedure;
	BEGIN record.Procedure;
	END Test.

positive: dereference designator denoting array variable

	MODULE Test;
	TYPE Array = ARRAY 10 OF CHAR;
	VAR pointer: POINTER TO Array; array: Array;
	BEGIN array := pointer^;
	END Test.

positive: dereference designator denoting record variable

	MODULE Test;
	TYPE Record = RECORD END;
	VAR pointer: POINTER TO Record; record: Record;
	BEGIN record := pointer^;
	END Test.

positive: abbreviating dereference designator denoting array variable

	MODULE Test;
	TYPE Array = ARRAY 10 OF CHAR;
	VAR pointer: POINTER TO Array;
	BEGIN pointer[0] := pointer^[0];
	END Test.

positive: abbreviating dereference designator denoting record variable

	MODULE Test;
	TYPE Record = RECORD field: CHAR END;
	VAR pointer: POINTER TO Record; record: Record;
	BEGIN record.field := pointer.field;
	END Test.

positive: reading element of read-only array

	MODULE Test;
	IMPORT Import;
	BEGIN Import.exportedArray[0] := Import.readOnlyArray[0];
	END Test.

negative: writing element of read-only array

	MODULE Test;
	IMPORT Import;
	BEGIN Import.readOnlyArray[0] := Import.exportedArray[0];
	END Test.

positive: reading field of read-only record

	MODULE Test;
	IMPORT Import;
	BEGIN Import.exportedRecord.exportedField := Import.readOnlyRecord.exportedField;
	END Test.

negative: writing field of read-only record

	MODULE Test;
	IMPORT Import;
	BEGIN Import.readOnlyRecord.exportedField := Import.exportedRecord.exportedField;
	END Test.

positive: reading read-only field of record

	MODULE Test;
	IMPORT Import;
	BEGIN Import.exportedRecord.exportedField := Import.exportedRecord.readOnlyField;
	END Test.

negative: writing read-only field of record

	MODULE Test;
	IMPORT Import;
	BEGIN Import.exportedRecord.readOnlyField := Import.exportedRecord.exportedField;
	END Test.

positive: reading read-only field of read-only record

	MODULE Test;
	IMPORT Import;
	BEGIN Import.exportedRecord.exportedField := Import.readOnlyRecord.readOnlyField;
	END Test.

negative: writing read-only field of read-only record

	MODULE Test;
	IMPORT Import;
	BEGIN Import.readOnlyRecord.readOnlyField := Import.exportedRecord.exportedField;
	END Test.

negative: applying type guard on variable parameter of boolean type

	MODULE Test;
	TYPE Type = BOOLEAN;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

negative: applying type guard on variable parameter of character type

	MODULE Test;
	TYPE Type = CHAR;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

negative: applying type guard on variable parameter of integer type

	MODULE Test;
	TYPE Type = INTEGER;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

negative: applying type guard on variable parameter of real type

	MODULE Test;
	TYPE Type = REAL;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

negative: applying type guard on variable parameter of set type

	MODULE Test;
	TYPE Type = SET;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

negative: applying type guard on variable parameter of array type

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

positive: applying type guard on variable parameter of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

negative: applying type guard on value parameter of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

positive: applying type guard on variable parameter of pointer type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Type = POINTER TO Record;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

positive: applying type guard on value parameter of pointer type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Type = POINTER TO Record;
	PROCEDURE Procedure (parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

negative: applying type guard on variable parameter of procedure type

	MODULE Test;
	TYPE Type = PROCEDURE;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN parameter := parameter(Type);
	END Procedure;
	END Test.

positive: applying type guard on variable of pointer type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Type = POINTER TO Record;
	VAR variable: Type;
	BEGIN variable := variable(Type);
	END Test.

positive: applying type guard on an extended record type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Extension = RECORD (Record) END;
	PROCEDURE Procedure (VAR parameter: Record);
	BEGIN parameter := parameter(Extension);
	END Procedure;
	END Test.

negative: applying type guard on an unextended record type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Extension = RECORD END;
	PROCEDURE Procedure (VAR parameter: Record);
	BEGIN parameter := parameter(Extension);
	END Procedure;
	END Test.

positive: applying type guard on an extended pointer type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Extension = POINTER TO RECORD (Record) END;
	VAR variable: POINTER TO Record;
	BEGIN variable := variable(Extension);
	END Test.

negative: applying type guard on an unextended pointer type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Extension = POINTER TO RECORD END;
	VAR variable: POINTER TO Record;
	BEGIN variable := variable(Extension);
	END Test.

positive: designator referring to the value of a constant

	MODULE Test;
	CONST designator = 365420;
	BEGIN ASSERT (designator = 365420);
	END Test.

positive: designator referring to the current value of a variable

	MODULE Test;
	VAR designator: INTEGER;
	BEGIN designator := 4; ASSERT (designator = 4); designator := -designator; ASSERT (designator = -4);
	END Test.

positive: designator referring to a procedure not followed by parameter list

	MODULE Test;
	VAR variable: PROCEDURE;
	PROCEDURE designator; END designator;
	BEGIN variable := designator;
	END Test.

positive: designator referring to a procedure followed by parameter list

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE designator (): INTEGER; BEGIN RETURN 0; END designator;
	BEGIN variable := designator ();
	END Test.

positive: designator examples

	MODULE Test;
	TYPE Tree = POINTER TO Node;
	TYPE Node = RECORD
		left, right: Tree
	END;
	TYPE CenterTree = POINTER TO CenterNode;
	TYPE CenterNode = RECORD (Node)
		subnode: Tree
	END;
	VAR i: INTEGER;
	VAR a: ARRAY 100 OF REAL;
	VAR w: ARRAY 16 OF RECORD
		name: ARRAY 32 OF CHAR;
	END;
	VAR t: Tree;
	VAR integer: INTEGER;
	VAR real: REAL;
	VAR char: CHAR;
	VAR tree: Tree;
	BEGIN
		i := integer;
		a[i] := real;
		w[3].name[i] := char;
		t.left.right := tree;
		t(CenterTree).subnode := tree;
	END Test.

# 8.2 Operators

positive: four classes of operators with different precedences

	MODULE Test;
	CONST Integer = - 2 * 0 + 8 DIV 2 = + 4 * 3 + 2 - 10;
	CONST Real = - 2.5 * 1.5 + 7 / 4 = + 4.0 * 3.5 - 32 DIV 2;
	CONST Set = - {2} * {} + {3} / {1,3} # {4} * {3} + {2} - {2,4};
	BEGIN ASSERT (Integer & Real & Set);
	END Test.

positive: highest precedence

	MODULE Test;
	BEGIN ASSERT (~FALSE & ~TRUE = (~FALSE) & (~TRUE));
	END Test.

positive: second highest precedence

	MODULE Test;
	BEGIN ASSERT (4 * 5 + 3 * 2 = (4 * 5) + (3 * 2));
	END Test.

positive: second lowest precedence

	MODULE Test;
	BEGIN ASSERT ((4 + 5 = 2 + 7) = ((4 + 5) = (2 + 7)));
	END Test.

positive: left-to-right association

	MODULE Test;
	BEGIN
		ASSERT (1 - 2 - 3 = (1 - 2) - 3);
		ASSERT (20 DIV 4 DIV 2 = (20 DIV 4) DIV 2);
	END Test.

# 8.2.1 Logical operators

positive: logical disjunction on boolean types

	MODULE Test;
	BEGIN
		ASSERT (~(FALSE OR FALSE));
		ASSERT (FALSE OR TRUE);
		ASSERT (TRUE OR FALSE);
		ASSERT (TRUE OR TRUE);
	END Test.

negative: logical disjunction on character types

	MODULE Test;
	CONST Result = 0X OR 1X;
	END Test.

negative: logical disjunction on integer types

	MODULE Test;
	CONST Result = 0 OR 1;
	END Test.

negative: logical disjunction on real types

	MODULE Test;
	CONST Result = 0.5 OR 1.5;
	END Test.

negative: logical disjunction on set types

	MODULE Test;
	CONST Result = {0} OR {1};
	END Test.

positive: logical conjunction on boolean types

	MODULE Test;
	BEGIN
		ASSERT (~(FALSE & FALSE));
		ASSERT (~(FALSE & TRUE));
		ASSERT (~(TRUE & FALSE));
		ASSERT (TRUE & TRUE);
	END Test.

negative: logical conjunction on character types

	MODULE Test;
	CONST Result = 0X & 1X;
	END Test.

negative: logical conjunction on integer types

	MODULE Test;
	CONST Result = 0 & 1;
	END Test.

negative: logical conjunction on real types

	MODULE Test;
	CONST Result = 0.5 & 1.5;
	END Test.

negative: logical conjunction on set types

	MODULE Test;
	CONST Result = {0} & {1};
	END Test.

positive: negation on boolean type

	MODULE Test;
	BEGIN
		ASSERT (~FALSE);
		ASSERT (~(~TRUE));
	END Test.

negative: negation on character type

	MODULE Test;
	CONST Result = ~0X;
	END Test.

negative: negation on integer type

	MODULE Test;
	CONST Result = ~0;
	END Test.

negative: negation on real type

	MODULE Test;
	CONST Result = ~0.5;
	END Test.

negative: negation on set type

	MODULE Test;
	CONST Result = ~{};
	END Test.

# 8.2.2 Arithmetic operators

negative: sum on boolean types

	MODULE Test;
	CONST Result = FALSE + TRUE;
	END Test.

negative: sum on character types

	MODULE Test;
	CONST Result = 0X + 1X;
	END Test.

positive: sum on integer types

	MODULE Test;
	CONST Result = 4 + 5;
	BEGIN ASSERT (Result = 9);
	END Test.

positive: sum on real types

	MODULE Test;
	CONST Result = 2.75 + 1.5;
	BEGIN ASSERT (Result = 4.25);
	END Test.

positive: sum on numeric types

	MODULE Test;
	CONST Result = 2 + 1.5;
	BEGIN ASSERT (Result = 3.5);
	END Test.

negative: difference on boolean types

	MODULE Test;
	CONST Result = FALSE - TRUE;
	END Test.

negative: difference on character types

	MODULE Test;
	CONST Result = 0X - 1X;
	END Test.

positive: difference on integer types

	MODULE Test;
	CONST Result = 4 - 5;
	BEGIN ASSERT (Result = -1);
	END Test.

positive: difference on real types

	MODULE Test;
	CONST Result = 2.75 - 1.5;
	BEGIN ASSERT (Result = 1.25);
	END Test.

positive: difference on numeric types

	MODULE Test;
	CONST Result = 2 - 1.5;
	BEGIN ASSERT (Result = 0.5);
	END Test.

negative: product on boolean types

	MODULE Test;
	CONST Result = FALSE * TRUE;
	END Test.

negative: product on character types

	MODULE Test;
	CONST Result = 0X * 1X;
	END Test.

positive: product on integer types

	MODULE Test;
	CONST Result = 4 * 5;
	BEGIN ASSERT (Result = 20);
	END Test.

positive: product on real types

	MODULE Test;
	CONST Result = 2.75 * 2.0;
	BEGIN ASSERT (Result = 5.5);
	END Test.

positive: product on numeric types

	MODULE Test;
	CONST Result = 2 * 1.75;
	BEGIN ASSERT (Result = 3.5);
	END Test.

negative: real quotient on boolean types

	MODULE Test;
	CONST Result = FALSE / TRUE;
	END Test.

negative: real quotient on character types

	MODULE Test;
	CONST Result = 0X / 1X;
	END Test.

positive: real quotient on integer types

	MODULE Test;
	CONST Result = 5 / 2;
	BEGIN ASSERT (Result = 2.5);
	END Test.

positive: real quotient on real types

	MODULE Test;
	CONST Result = 3.5 / 2.0;
	BEGIN ASSERT (Result = 1.75);
	END Test.

positive: real quotient on numeric types

	MODULE Test;
	CONST Result = 4.5 / 2;
	BEGIN ASSERT (Result = 2.25);
	END Test.

negative: integer quotient on boolean types

	MODULE Test;
	CONST Result = FALSE DIV TRUE;
	END Test.

negative: integer quotient on character types

	MODULE Test;
	CONST Result = 0X DIV 1X;
	END Test.

positive: integer quotient on integer types

	MODULE Test;
	CONST Result = 5 DIV 2;
	BEGIN ASSERT (Result = 2);
	END Test.

negative: integer quotient on real types

	MODULE Test;
	CONST Result = 3.5 DIV 2.0;
	END Test.

negative: integer quotient on numeric types

	MODULE Test;
	CONST Result = 4.5 DIV 2;
	END Test.

negative: modulus on boolean types

	MODULE Test;
	CONST Result = FALSE MOD TRUE;
	END Test.

negative: modulus on character types

	MODULE Test;
	CONST Result = 0X MOD 1X;
	END Test.

positive: modulus on integer types

	MODULE Test;
	CONST Result = 5 MOD 2;
	BEGIN ASSERT (Result = 1);
	END Test.

negative: modulus on real types

	MODULE Test;
	CONST Result = 3.5 MOD 2.0;
	END Test.

negative: modulus on numeric types

	MODULE Test;
	CONST Result = 4.5 MOD 2;
	END Test.

negative: sign inversion on boolean type

	MODULE Test;
	CONST Result = -FALSE;
	END Test.

negative: sign inversion on character type

	MODULE Test;
	CONST Result = -0X;
	END Test.

positive: sign inversion on integer type

	MODULE Test;
	CONST Result = -5;
	BEGIN ASSERT (Result = 0 - 5);
	END Test.

positive: sign inversion on real type

	MODULE Test;
	CONST Result = -3.5;
	BEGIN ASSERT (Result = 0 - 3.5);
	END Test.

negative: identity on boolean type

	MODULE Test;
	CONST Result = +FALSE;
	END Test.

negative: identity on character types

	MODULE Test;
	CONST Result = +0X;
	END Test.

positive: identity on integer type

	MODULE Test;
	CONST Result = +5;
	BEGIN ASSERT (Result = 0 + 5);
	END Test.

positive: identity on real type

	MODULE Test;
	CONST Result = +3.5;
	BEGIN ASSERT (Result = 0 + 3.5);
	END Test.

positive: integer quotient and modulus example

	MODULE Test;
	BEGIN
		ASSERT (5 DIV 3 = 1); ASSERT (5 MOD 3 = 2);
	END Test.

# 8.2.3 Set Operators

positive: union on set types

	MODULE Test;
	CONST Result = {1} + {2};
	BEGIN ASSERT (Result = {1, 2});
	END Test.

positive: difference on set types

	MODULE Test;
	CONST Result = {1..3} - {2};
	BEGIN ASSERT (Result = {1, 3});
	END Test.

positive: intersection on set types

	MODULE Test;
	CONST Result = {1, 2, 3} * {0, 2};
	BEGIN ASSERT (Result = {2});
	END Test.

positive: symmetric set difference on set types

	MODULE Test;
	CONST Result = {1, 2, 3} / {0, 2};
	BEGIN ASSERT (Result = {0, 1, 3});
	END Test.

positive: identity on set type

	MODULE Test;
	CONST Result = +{4, 6};
	BEGIN ASSERT (Result = {6, 4});
	END Test.

positive: complement on set type

	MODULE Test;
	CONST Result = -{0..MAX (SET)};
	BEGIN ASSERT (Result = {});
	END Test.

positive: non-associative set operators

	MODULE Test;
	CONST a = {1, 2}; b = {3}; c = {1};
	BEGIN ASSERT ((a + b) - c # a + (b - c));
	END Test.

positive: empty set constructor

	MODULE Test;
	CONST Set = {};
	BEGIN ASSERT (~(0 IN Set)); ASSERT (~(1 IN Set));
	END Test.

positive: set constructor with single element

	MODULE Test;
	CONST Set = {0};
	BEGIN ASSERT (0 IN Set); ASSERT (~(1 IN Set));
	END Test.

positive: set constructor with two elements

	MODULE Test;
	CONST Set = {0, 1};
	BEGIN ASSERT (0 IN Set); ASSERT (1 IN Set);
	END Test.

negative: negative set constructor element

	MODULE Test;
	CONST Set = {-1};
	END Test.

negative: invalid set constructor element

	MODULE Test;
	CONST Set = {64};
	END Test.

positive: set constructor with element range consisting of a single value

	MODULE Test;
	CONST Set = {0..0};
	BEGIN ASSERT (Set = {0});
	END Test.

positive: set constructor with element range consisting of increasing values

	MODULE Test;
	CONST Set = {0..1};
	BEGIN ASSERT (Set = {0, 1});
	END Test.

positive: set constructor with element range consisting of decreasing values

	MODULE Test;
	CONST Set = {1..0};
	BEGIN ASSERT (Set = {});
	END Test.

# 8.2.4 Relations

positive: equal relation on boolean types

	MODULE Test;
	CONST Result = FALSE = TRUE;
	BEGIN ASSERT (~Result);
	END Test.

positive: equal relation on character types

	MODULE Test;
	CONST Result = 'a' = 'b';
	BEGIN ASSERT (~Result);
	END Test.

positive: equal relation on integer types

	MODULE Test;
	CONST Result = 54 = 21;
	BEGIN ASSERT (~Result);
	END Test.

positive: equal relation on real types

	MODULE Test;
	CONST Result = 5.5 = 2.75;
	BEGIN ASSERT (~Result);
	END Test.

positive: equal relation on set types

	MODULE Test;
	CONST Result = {1, 2} = {1..2};
	BEGIN ASSERT (Result);
	END Test.

positive: equal relation on string types

	MODULE Test;
	CONST Result = "abc" = "xyz";
	BEGIN ASSERT (~Result);
	END Test.

positive: equal relation on nil types

	MODULE Test;
	CONST Result = NIL = NIL;
	BEGIN ASSERT (Result);
	END Test.

positive: equal relation on array of character types

	MODULE Test;
	VAR a: ARRAY 10 OF CHAR; b: ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a = b;
	END Test.

positive: equal relation on pointer to array types

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a = b;
	END Test.

positive: equal relation on pointer to record types

	MODULE Test;
	TYPE T = RECORD END;
	VAR a: POINTER TO T; b: POINTER TO T; result: BOOLEAN;
	BEGIN result := a = b;
	END Test.

positive: equal relation on procedure types

	MODULE Test;
	VAR a: PROCEDURE; b: PROCEDURE; result: BOOLEAN;
	BEGIN result := a = b;
	END Test.

positive: unequal relation on boolean types

	MODULE Test;
	CONST Result = FALSE # TRUE;
	BEGIN ASSERT (Result);
	END Test.

positive: unequal relation on character types

	MODULE Test;
	CONST Result = 'a' # 'b';
	BEGIN ASSERT (Result);
	END Test.

positive: unequal relation on integer types

	MODULE Test;
	CONST Result = 54 # 21;
	BEGIN ASSERT (Result);
	END Test.

positive: unequal relation on real types

	MODULE Test;
	CONST Result = 5.5 # 2.75;
	BEGIN ASSERT (Result);
	END Test.

positive: unequal relation on set types

	MODULE Test;
	CONST Result = {1, 2} # {1..2};
	BEGIN ASSERT (~Result);
	END Test.

positive: unequal relation on string types

	MODULE Test;
	CONST Result = "abc" # "xyz";
	BEGIN ASSERT (Result);
	END Test.

positive: unequal relation on nil types

	MODULE Test;
	CONST Result = NIL # NIL;
	BEGIN ASSERT (~Result);
	END Test.

positive: unequal relation on array of character types

	MODULE Test;
	VAR a: ARRAY 10 OF CHAR; b: ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a # b;
	END Test.

positive: unequal relation on pointer to array types

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a # b;
	END Test.

positive: unequal relation on pointer to record types

	MODULE Test;
	TYPE T = RECORD END;
	VAR a: POINTER TO T; b: POINTER TO T; result: BOOLEAN;
	BEGIN result := a # b;
	END Test.

positive: unequal relation on procedure types

	MODULE Test;
	VAR a: PROCEDURE; b: PROCEDURE; result: BOOLEAN;
	BEGIN result := a # b;
	END Test.

negative: less relation on boolean types

	MODULE Test;
	CONST Result = FALSE < TRUE;
	END Test.

positive: less relation on character types

	MODULE Test;
	CONST Result = 'a' < 'b';
	BEGIN ASSERT (Result);
	END Test.

positive: less relation on integer types

	MODULE Test;
	CONST Result = 54 < 21;
	BEGIN ASSERT (~Result);
	END Test.

positive: less relation on real types

	MODULE Test;
	CONST Result = 5.5 < 2.75;
	BEGIN ASSERT (~Result);
	END Test.

negative: less relation on set types

	MODULE Test;
	CONST Result = {1, 2} < {1..2};
	END Test.

positive: less relation on string types

	MODULE Test;
	CONST Result = "abc" < "xyz";
	BEGIN ASSERT (Result);
	END Test.

negative: less relation on nil types

	MODULE Test;
	CONST Result = NIL < NIL;
	END Test.

positive: less relation on array of character types

	MODULE Test;
	VAR a: ARRAY 10 OF CHAR; b: ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a < b;
	END Test.

negative: less relation on pointer to array types

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a < b;
	END Test.

negative: less relation on pointer to record types

	MODULE Test;
	TYPE T = RECORD END;
	VAR a: POINTER TO T; b: POINTER TO T; result: BOOLEAN;
	BEGIN result := a < b;
	END Test.

negative: less relation on procedure types

	MODULE Test;
	VAR a: PROCEDURE; b: PROCEDURE; result: BOOLEAN;
	BEGIN result := a < b;
	END Test.

negative: less or equal relation on boolean types

	MODULE Test;
	CONST Result = FALSE <= TRUE;
	END Test.

positive: less or equal relation on character types

	MODULE Test;
	CONST Result = 'a' <= 'b';
	BEGIN ASSERT (Result);
	END Test.

positive: less or equal relation on integer types

	MODULE Test;
	CONST Result = 54 <= 21;
	BEGIN ASSERT (~Result);
	END Test.

positive: less or equal relation on real types

	MODULE Test;
	CONST Result = 5.5 <= 2.75;
	BEGIN ASSERT (~Result);
	END Test.

negative: less or equal relation on set types

	MODULE Test;
	CONST Result = {1, 2} <= {1..2};
	END Test.

positive: less or equal relation on string types

	MODULE Test;
	CONST Result = "abc" <= "xyz";
	BEGIN ASSERT (Result);
	END Test.

negative: less or equal relation on nil types

	MODULE Test;
	CONST Result = NIL <= NIL;
	END Test.

positive: less or equal relation on array of character types

	MODULE Test;
	VAR a: ARRAY 10 OF CHAR; b: ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a <= b;
	END Test.

negative: less or equal relation on pointer to array types

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a <= b;
	END Test.

negative: less or equal relation on pointer to record types

	MODULE Test;
	TYPE T = RECORD END;
	VAR a: POINTER TO T; b: POINTER TO T; result: BOOLEAN;
	BEGIN result := a <= b;
	END Test.

negative: less or equal relation on procedure types

	MODULE Test;
	VAR a: PROCEDURE; b: PROCEDURE; result: BOOLEAN;
	BEGIN result := a <= b;
	END Test.

negative: greater relation on boolean types

	MODULE Test;
	CONST Result = FALSE > TRUE;
	END Test.

positive: greater relation on character types

	MODULE Test;
	CONST Result = 'a' > 'b';
	BEGIN ASSERT (~Result);
	END Test.

positive: greater relation on integer types

	MODULE Test;
	CONST Result = 54 > 21;
	BEGIN ASSERT (Result);
	END Test.

positive: greater relation on real types

	MODULE Test;
	CONST Result = 5.5 > 2.75;
	BEGIN ASSERT (Result);
	END Test.

negative: greater relation on set types

	MODULE Test;
	CONST Result = {1, 2} > {1..2};
	END Test.

positive: greater relation on string types

	MODULE Test;
	CONST Result = "abc" > "xyz";
	BEGIN ASSERT (~Result);
	END Test.

negative: greater relation on nil types

	MODULE Test;
	CONST Result = NIL > NIL;
	END Test.

positive: greater relation on array of character types

	MODULE Test;
	VAR a: ARRAY 10 OF CHAR; b: ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a > b;
	END Test.

negative: greater relation on pointer to array types

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a > b;
	END Test.

negative: greater relation on pointer to record types

	MODULE Test;
	TYPE T = RECORD END;
	VAR a: POINTER TO T; b: POINTER TO T; result: BOOLEAN;
	BEGIN result := a > b;
	END Test.

negative: greater relation on procedure types

	MODULE Test;
	VAR a: PROCEDURE; b: PROCEDURE; result: BOOLEAN;
	BEGIN result := a > b;
	END Test.

negative: greater or equal relation on boolean types

	MODULE Test;
	CONST Result = FALSE >= TRUE;
	END Test.

positive: greater or equal relation on character types

	MODULE Test;
	CONST Result = 'a' >= 'b';
	BEGIN ASSERT (~Result);
	END Test.

positive: greater or equal relation on integer types

	MODULE Test;
	CONST Result = 54 >= 21;
	BEGIN ASSERT (Result);
	END Test.

positive: greater or equal relation on real types

	MODULE Test;
	CONST Result = 5.5 >= 2.75;
	BEGIN ASSERT (Result);
	END Test.

negative: greater or equal relation on set types

	MODULE Test;
	CONST Result = {1, 2} >= {1..2};
	END Test.

positive: greater or equal relation on string types

	MODULE Test;
	CONST Result = "abc" >= "xyz";
	BEGIN ASSERT (~Result);
	END Test.

negative: greater or equal relation on nil types

	MODULE Test;
	CONST Result = NIL >= NIL;
	END Test.

positive: greater or equal relation on array of character types

	MODULE Test;
	VAR a: ARRAY 10 OF CHAR; b: ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a >= b;
	END Test.

negative: greater or equal relation on pointer to array types

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR; result: BOOLEAN;
	BEGIN result := a >= b;
	END Test.

negative: greater or equal relation on pointer to record types

	MODULE Test;
	TYPE T = RECORD END;
	VAR a: POINTER TO T; b: POINTER TO T; result: BOOLEAN;
	BEGIN result := a >= b;
	END Test.

negative: greater or equal relation on procedure types

	MODULE Test;
	VAR a: PROCEDURE; b: PROCEDURE; result: BOOLEAN;
	BEGIN result := a >= b;
	END Test.

negative: set membership on integer types

	MODULE Test;
	CONST Result = 1 IN 1;
	END Test.

positive: set membership on integer and set types

	MODULE Test;
	CONST Result = 1 IN {1, 2};
	BEGIN ASSERT (Result);
	END Test.

negative: set membership on set and integer types

	MODULE Test;
	CONST Result = {1, 2} IN 1;
	END Test.

negative: set membership on set types

	MODULE Test;
	CONST Result = {1, 2} IN {1, 2};
	END Test.

negative: type test on boolean type

	MODULE Test;
	TYPE Type = BOOLEAN;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

negative: type test on character type

	MODULE Test;
	TYPE Type = CHAR;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

negative: type test on integer type

	MODULE Test;
	TYPE Type = INTEGER;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

negative: type test on real type

	MODULE Test;
	TYPE Type = REAL;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

negative: type test on set type

	MODULE Test;
	TYPE Type = SET;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

negative: type test on array type

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

negative: type test on global variable of record type

	MODULE Test;
	TYPE Type = RECORD END;
	VAR variable: Type;
	PROCEDURE Procedure (): BOOLEAN;
	BEGIN RETURN variable IS Type;
	END Procedure;
	END Test.

negative: type test on local variable of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (): BOOLEAN;
	VAR variable: Type;
	BEGIN RETURN variable IS Type;
	END Procedure;
	END Test.

negative: type test on value parameter of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

positive: type test on variable parameter of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

positive: type test on variable parameter of extended record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD (Type) END;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Record;
	END Procedure;
	END Test.

negative: type test on variable parameter of unextended record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD END;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Record;
	END Procedure;
	END Test.

positive: type test on global variable of pointer to record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	VAR variable: Type;
	PROCEDURE Procedure (): BOOLEAN;
	BEGIN RETURN variable IS Type;
	END Procedure;
	END Test.

positive: type test on local variable of pointer to record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	PROCEDURE Procedure (): BOOLEAN;
	VAR variable: Type;
	BEGIN RETURN variable IS Type;
	END Procedure;
	END Test.

positive: type test on value parameter of pointer to record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	PROCEDURE Procedure (parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

positive: type test on variable parameter of pointer to record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

positive: type test on variable parameter of pointer to extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Pointer = POINTER TO RECORD (Base) END;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Pointer;
	END Procedure;
	END Test.

negative: type test on variable parameter of pointer to unextended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Pointer = POINTER TO RECORD END;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Pointer;
	END Procedure;
	END Test.

negative: type test on pointer to array type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

negative: type test on procedure type

	MODULE Test;
	TYPE Type = PROCEDURE;
	PROCEDURE Procedure (VAR parameter: Type): BOOLEAN;
	BEGIN RETURN parameter IS Type;
	END Procedure;
	END Test.

positive: expression examples

	MODULE Test;
	TYPE Tree = POINTER TO Node;
	TYPE Node = RECORD
		key : INTEGER;
	END;
	TYPE CenterTree = POINTER TO CenterNode;
	TYPE CenterNode = RECORD (Node)
	END;
	VAR i, j, k: INTEGER;
	VAR x: REAL;
	VAR p, q: BOOLEAN;
	VAR s: SET;
	VAR a: ARRAY 100 OF REAL;
	VAR w: ARRAY 16 OF RECORD
		name: ARRAY 32 OF CHAR;
		count: INTEGER
	END;
	VAR t: Tree;
	VAR integer: INTEGER;
	VAR boolean: BOOLEAN;
	VAR real: REAL;
	VAR set: SET;
	BEGIN
		integer := 1991;
		integer := i DIV 3;
		boolean := ~p OR q;
		integer := (i+j) * (i-j);
		set := s - {8, 9, 13};
		real := i + x;
		real := a[i+j] * a[i-j];
		boolean := (0<=i) & (i<100);
		boolean := t.key = 0;
		boolean := k IN {i..j-1};
		boolean := w[i].name <= "John";
		boolean := t IS CenterTree;
	END Test.

# 9. Statements

positive: empty statement

	MODULE Test;
	BEGIN ;
	END Test.

positive: empty statements

	MODULE Test;
	BEGIN ;;;
	END Test.

# 9.1 Assignments

negative: assignment missing designator

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN := 5;
	END Test.

negative: assignment missing becomes symbol

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN variable 5;
	END Test.

negative: assignment missing expression

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN variable := ;
	END Test.

positive: assignment examples

	MODULE Test;
	TYPE Tree = POINTER TO Node;
	TYPE Node = RECORD
		key : INTEGER;
	END;
	TYPE Function = PROCEDURE(x: INTEGER): INTEGER;
	VAR i, j, k: INTEGER;
	VAR x, y: REAL;
	VAR p: BOOLEAN;
	VAR s: SET;
	VAR F: Function;
	VAR a: ARRAY 100 OF REAL;
	VAR w: ARRAY 16 OF RECORD
		name: ARRAY 32 OF CHAR;
		count: INTEGER
	END;
	VAR t, c: Tree;
	PROCEDURE log2 (x: INTEGER): INTEGER; BEGIN RETURN 0; END log2;
	BEGIN
		i := 0;
		p := i = j;
		x := i + 1;
		k := log2(i+j);
		F := log2;
		s := {2, 3, 5, 7, 11, 13};
		a[i] := (x+y) * (x-y);
		t.key := i;
		w[i+1].name := "John";
		t := c;
	END Test.

# 9.2 Procedure calls

positive: procedure call without parameters

	MODULE Test;
	PROCEDURE Procedure;
	END Procedure;
	BEGIN Procedure;
	END Test.

negative: procedure call without parameters missing opening parenthesis

	MODULE Test;
	PROCEDURE Procedure;
	END Procedure;
	BEGIN Procedure );
	END Test.

negative: procedure call without parameters missing closing parenthesis

	MODULE Test;
	PROCEDURE Procedure;
	END Procedure;
	BEGIN Procedure (;
	END Test.

positive: procedure call without parameters missing parentheses

	MODULE Test;
	PROCEDURE Procedure;
	END Procedure;
	BEGIN Procedure;
	END Test.

positive: procedure call with single parameter

	MODULE Test;
	PROCEDURE Procedure (x: INTEGER);
	END Procedure;
	BEGIN Procedure (0);
	END Test.

positive: procedure call with parameters

	MODULE Test;
	PROCEDURE Procedure (x, y, z: INTEGER);
	END Procedure;
	BEGIN Procedure (0, 1, 2);
	END Test.

negative: procedure call with parameters missing opening parenthesis

	MODULE Test;
	PROCEDURE Procedure (x, y, z: INTEGER);
	END Procedure;
	BEGIN Procedure 0, 1, 2);
	END Test.

negative: procedure call with parameters missing closing parenthesis

	MODULE Test;
	PROCEDURE Procedure (x, y, z: INTEGER);
	END Procedure;
	BEGIN Procedure (0, 1, 2;
	END Test.

negative: procedure call with parameters missing parentheses

	MODULE Test;
	PROCEDURE Procedure (x, y, z: INTEGER);
	END Procedure;
	BEGIN Procedure 0, 1, 2;
	END Test.

negative: procedure call with mismatched number of parameters

	MODULE Test;
	PROCEDURE Procedure (x, y: INTEGER);
	END Procedure;
	BEGIN Procedure (0);
	END Test.

positive: procedure call with designator as value parameter

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure (parameter: INTEGER);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: procedure call with designator as variable parameter

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure (VAR parameter: INTEGER);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: procedure call with designator of including type as value parameter

	MODULE Test;
	VAR variable: SHORTINT;
	PROCEDURE Procedure (parameter: LONGINT);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

negative: procedure call with designator of including type as variable parameter

	MODULE Test;
	VAR variable: SHORTINT;
	PROCEDURE Procedure (VAR parameter: LONGINT);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: procedure call with expression as value parameter

	MODULE Test;
	PROCEDURE Procedure (parameter: INTEGER);
	END Procedure;
	BEGIN Procedure (0);
	END Test.

negative: procedure call with expression as variable parameter

	MODULE Test;
	PROCEDURE Procedure (VAR parameter: INTEGER);
	END Procedure;
	BEGIN Procedure (0);
	END Test.

positive: procedure call examples

	MODULE Test;
	TYPE Tree* = POINTER TO Node;
	TYPE Node* = RECORD END;
	VAR i, k: INTEGER;
	VAR w: ARRAY 16 OF RECORD
		count: INTEGER
	END;
	VAR t: Tree;
	PROCEDURE WriteInt (x: INTEGER); END WriteInt;
	PROCEDURE (t: Tree) Insert (name: ARRAY OF CHAR);
	END Insert;
	BEGIN
		WriteInt(i*2);
		INC(w[k].count);;
		t.Insert("John");
	END Test.

# 9.3 Statement sequences

positive: statement sequence with separating semicolon

	MODULE Test;
	BEGIN LOOP EXIT; RETURN END;
	END Test.

negative: statement sequence missing separating semicolon

	MODULE Test;
	BEGIN LOOP EXIT RETURN END;
	END Test.

# 9.4 If statements

negative: if statement missing IF

	MODULE Test;
	BEGIN TRUE THEN END;
	END Test.

negative: if statement missing condition

	MODULE Test;
	BEGIN IF THEN END;
	END Test.

negative: if statement missing THEN

	MODULE Test;
	BEGIN IF TRUE END;
	END Test.

negative: if statement missing END

	MODULE Test;
	BEGIN IF TRUE THEN;
	END Test.

positive: if statement without ELSIF

	MODULE Test;
	BEGIN IF TRUE THEN END;
	END Test.

negative: if statement with ELSIF missing condition

	MODULE Test;
	BEGIN IF TRUE THEN ELSIF THEN END;
	END Test.

negative: if statement with ELSIF missing THEN

	MODULE Test;
	BEGIN IF TRUE THEN ELSIF FALSE END;
	END Test.

negative: if statement with ELSIF missing END

	MODULE Test;
	BEGIN IF TRUE THEN ELSIF FALSE THEN;
	END Test.

positive: if statement with ELSIF without ELSE

	MODULE Test;
	BEGIN IF TRUE THEN ELSIF FALSE THEN END;
	END Test.

positive: if statement with ELSIF and ELSE

	MODULE Test;
	BEGIN IF TRUE THEN ELSIF FALSE THEN ELSE END;
	END Test.

negative: if statement with ELSE and ELSIF

	MODULE Test;
	BEGIN IF TRUE THEN ELSE ELSIF FALSE THEN END;
	END Test.

positive: if statement without ELSE

	MODULE Test;
	BEGIN IF TRUE THEN END;
	END Test.

positive: if statement with ELSE

	MODULE Test;
	BEGIN IF TRUE THEN ELSE END;
	END Test.

positive: if statement with boolean guard

	MODULE Test;
	BEGIN IF FALSE THEN END;
	END Test.

negative: if statement with character guard

	MODULE Test;
	BEGIN IF 0X THEN END;
	END Test.

negative: if statement with integer guard

	MODULE Test;
	BEGIN IF 0 THEN END;
	END Test.

negative: if statement with real guard

	MODULE Test;
	BEGIN IF 0X THEN END;
	END Test.

negative: if statement with set guard

	MODULE Test;
	BEGIN IF 0X THEN END;
	END Test.

negative: if statement with array guard

	MODULE Test;
	VAR condition: ARRAY 10 OF CHAR;
	BEGIN IF condition THEN END;
	END Test.

negative: if statement with record guard

	MODULE Test;
	VAR condition: RECORD END;
	BEGIN IF condition THEN END;
	END Test.

negative: if statement with pointer to array guard

	MODULE Test;
	VAR condition: POINTER TO ARRAY 10 OF CHAR;
	BEGIN IF condition THEN END;
	END Test.

negative: if statement with pointer to record guard

	MODULE Test;
	VAR condition: POINTER TO RECORD END;
	BEGIN IF condition THEN END;
	END Test.

negative: if statement with procedure guard

	MODULE Test;
	VAR condition: PROCEDURE;
	BEGIN IF condition THEN END;
	END Test.

positive: if statement example

	MODULE Test;
	VAR ch: ARRAY 10 OF CHAR;
	PROCEDURE ReadIdentifier; END ReadIdentifier;
	PROCEDURE ReadNumber; END ReadNumber;
	PROCEDURE ReadString; END ReadString;
	PROCEDURE SpecialCharacter; END SpecialCharacter;
	BEGIN
		IF (ch >= "A") & (ch <= "Z") THEN ReadIdentifier
		ELSIF (ch >= "0") & (ch <= "9") THEN ReadNumber
		ELSIF (ch = " ' ") OR (ch = ' " ') THEN ReadString
		ELSE SpecialCharacter
		END
	END Test.

# 9.5 Case statements

negative: case expression of boolean type

	MODULE Test;
	BEGIN CASE TRUE OF ELSE END;
	END Test.

positive: case expression of character type

	MODULE Test;
	BEGIN CASE '0' OF 0X: ELSE END; CASE 0X OF '0': ELSE END;
	END Test.

positive: case expression of integer type

	MODULE Test;
	BEGIN CASE 0 OF 0..2: ELSE END;
	END Test.

negative: case expression of real type

	MODULE Test;
	BEGIN CASE 0.0 OF ELSE END;
	END Test.

negative: case expression of set type

	MODULE Test;
	BEGIN CASE {0} OF ELSE END;
	END Test.

negative: case expression of array type

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	BEGIN CASE array OF ELSE END;
	END Test.

negative: case expression of record type

	MODULE Test;
	VAR record: RECORD END;
	BEGIN CASE record OF ELSE END;
	END Test.

negative: case expression of pointer to array type

	MODULE Test;
	VAR pointer: POINTER TO ARRAY 10 OF CHAR;
	BEGIN CASE pointer OF ELSE END;
	END Test.

negative: case expression of pointer to record type

	MODULE Test;
	VAR pointer: POINTER TO RECORD END;
	BEGIN CASE pointer OF ELSE END;
	END Test.

negative: case expression of procedure type

	MODULE Test;
	VAR procedure: PROCEDURE;
	BEGIN CASE procedure OF ELSE END;
	END Test.

positive: case expression including complete case range

	MODULE Test;
	VAR value: CHAR;
	BEGIN CASE value OF MIN (CHAR), MAX (CHAR): END;
	END Test.

positive: case expression including types of all case labels

	MODULE Test;
	VAR value: LONGINT;
	BEGIN CASE value OF MAX (SHORTINT), MAX (LONGINT): END;
	END Test.

negative: case expression excluding types of all case labels

	MODULE Test;
	VAR value: SHORTINT;
	BEGIN CASE value OF MAX (LONGINT): END;
	END Test.

positive: constant case label

	MODULE Test;
	CONST Value = 0;
	VAR value: INTEGER;
	BEGIN CASE value OF Value: END;
	END Test.

negative: non-constant case label

	MODULE Test;
	VAR value: INTEGER;
	BEGIN CASE value OF value: END;
	END Test.

negative: value duplicated in same case label list

	MODULE Test;
	BEGIN CASE 0 OF 0, 0: END;
	END Test.

negative: value duplicated in different case label list

	MODULE Test;
	BEGIN CASE 0 OF 0: | 0: END;
	END Test.

positive: empty case statement

	MODULE Test;
	BEGIN CASE 0 OF END;
	END Test.

positive: empty case statement with ELSE

	MODULE Test;
	BEGIN CASE 0 OF ELSE END;
	END Test.

negative: empty case statement missing CASE

	MODULE Test;
	BEGIN 0 OF END;
	END Test.

negative: empty case statement missing case expression

	MODULE Test;
	BEGIN CASE OF END;
	END Test.

negative: empty case statement missing OF

	MODULE Test;
	BEGIN CASE OF END;
	END Test.

negative: empty case statement missing END

	MODULE Test;
	BEGIN CASE 0 OF;
	END Test.

positive: case statement with case

	MODULE Test;
	BEGIN CASE 0 OF 0: END;
	END Test.

positive: case statement with empty case

	MODULE Test;
	BEGIN CASE 0 OF | END;
	END Test.

positive: case statement with multiple cases

	MODULE Test;
	BEGIN CASE 0 OF 0: | 1: END;
	END Test.

negative: case statement with multiple cases missing bar

	MODULE Test;
	BEGIN CASE 0 OF 0: 1: END;
	END Test.

positive: case statement with case label

	MODULE Test;
	BEGIN CASE 0 OF 0: END;
	END Test.

negative: case statement with case label missing value

	MODULE Test;
	BEGIN CASE 0 OF : END;
	END Test.

negative: case statement with case label missing colon

	MODULE Test;
	BEGIN CASE 0 OF 0 END;
	END Test.

positive: case statement with case labels

	MODULE Test;
	BEGIN CASE 0 OF 0, 1: END;
	END Test.

negative: case statement with case labels missing comma

	MODULE Test;
	BEGIN CASE 0 OF 0 1: END;
	END Test.

positive: case statement with case label range

	MODULE Test;
	BEGIN CASE 0 OF 0..1: END;
	END Test.

negative: case statement with case label range missing first value

	MODULE Test;
	BEGIN CASE 0 OF ..1: END;
	END Test.

negative: case statement with case label range missing dots

	MODULE Test;
	BEGIN CASE 0 OF 0 1: END;
	END Test.

negative: case statement with case label range missing second value

	MODULE Test;
	BEGIN CASE 0 OF 0..: END;
	END Test.

positive: case statement with case label range consisting of a single value

	MODULE Test;
	BEGIN CASE 0 OF 0..0: END;
	END Test.

positive: case statement with case label range consisting of increasing values

	MODULE Test;
	BEGIN CASE 0 OF 0..1: END;
	END Test.

negative: case statement with case label range consisting of decreasing values

	MODULE Test;
	BEGIN CASE 0 OF 1..0: END;
	END Test.

positive: case statement example

	MODULE Test;
	VAR ch: CHAR;
	PROCEDURE ReadIdentifier; END ReadIdentifier;
	PROCEDURE ReadNumber; END ReadNumber;
	PROCEDURE ReadString; END ReadString;
	PROCEDURE SpecialCharacter; END SpecialCharacter;
	BEGIN
		CASE ch OF
		"A" .. "Z": ReadIdentifier
		| "0" .. "9": ReadNumber
		| "'", '"': ReadString
		ELSE SpecialCharacter
		END
	END Test.

# 9.6 While statements

positive: while statement with boolean guard

	MODULE Test;
	BEGIN WHILE FALSE DO END;
	END Test.

negative: while statement with character guard

	MODULE Test;
	BEGIN WHILE 0X DO END;
	END Test.

negative: while statement with integer guard

	MODULE Test;
	BEGIN WHILE 0 DO END;
	END Test.

negative: while statement with real guard

	MODULE Test;
	BEGIN WHILE 0X DO END;
	END Test.

negative: while statement with set guard

	MODULE Test;
	BEGIN WHILE 0X DO END;
	END Test.

negative: while statement with array guard

	MODULE Test;
	VAR condition: ARRAY 10 OF CHAR;
	BEGIN WHILE condition DO END;
	END Test.

negative: while statement with record guard

	MODULE Test;
	VAR condition: RECORD END;
	BEGIN WHILE condition DO END;
	END Test.

negative: while statement with pointer to array guard

	MODULE Test;
	VAR condition: POINTER TO ARRAY 10 OF CHAR;
	BEGIN WHILE condition DO END;
	END Test.

negative: while statement with pointer to record guard

	MODULE Test;
	VAR condition: POINTER TO RECORD END;
	BEGIN WHILE condition DO END;
	END Test.

negative: while statement with procedure guard

	MODULE Test;
	VAR condition: PROCEDURE;
	BEGIN WHILE condition DO END;
	END Test.

negative: while statement missing WHILE

	MODULE Test;
	BEGIN TRUE DO END;
	END Test.

negative: while statement missing condition

	MODULE Test;
	BEGIN WHILE DO END;
	END Test.

negative: while statement missing DO

	MODULE Test;
	BEGIN WHILE TRUE END;
	END Test.

negative: while statement missing END

	MODULE Test;
	BEGIN WHILE TRUE DO;
	END Test.

positive: while statement examples

	MODULE Test;
	TYPE Tree = POINTER TO Node;
	TYPE Node = RECORD
		key : INTEGER;
		left: Tree
	END;
	VAR i, k: INTEGER;
	VAR t: Tree;
	BEGIN
		WHILE i > 0 DO i := i DIV 2; k := k + 1 END;
		WHILE (t # NIL) & (t.key # i) DO t := t.left END;
	END Test.

# 9.7 Repeat statements

positive: repeat statement with boolean guard

	MODULE Test;
	BEGIN REPEAT UNTIL FALSE;
	END Test.

negative: repeat statement with character guard

	MODULE Test;
	BEGIN REPEAT UNTIL 0X;
	END Test.

negative: repeat statement with integer guard

	MODULE Test;
	BEGIN REPEAT UNTIL 0;
	END Test.

negative: repeat statement with real guard

	MODULE Test;
	BEGIN REPEAT UNTIL 0X;
	END Test.

negative: repeat statement with set guard

	MODULE Test;
	BEGIN REPEAT UNTIL 0X;
	END Test.

negative: repeat statement with array guard

	MODULE Test;
	VAR condition: ARRAY 10 OF CHAR;
	BEGIN REPEAT UNTIL condition;
	END Test.

negative: repeat statement with record guard

	MODULE Test;
	VAR condition: RECORD END;
	BEGIN REPEAT UNTIL condition;
	END Test.

negative: repeat statement with pointer to array guard

	MODULE Test;
	VAR condition: POINTER TO ARRAY 10 OF CHAR;
	BEGIN REPEAT UNTIL condition;
	END Test.

negative: repeat statement with pointer to record guard

	MODULE Test;
	VAR condition: POINTER TO RECORD END;
	BEGIN REPEAT UNTIL condition;
	END Test.

negative: repeat statement with procedure guard

	MODULE Test;
	VAR condition: PROCEDURE;
	BEGIN REPEAT UNTIL condition;
	END Test.

negative: repeat statement missing REPEAT

	MODULE Test;
	BEGIN UNTIL TRUE;
	END Test.

negative: repeat statement missing UNTIL

	MODULE Test;
	BEGIN REPEAT TRUE;
	END Test.

negative: repeat statement missing condition

	MODULE Test;
	BEGIN REPEAT UNTIL;
	END Test.

# 9.8 For statements

negative: for statement with control variable of boolean type

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement with control variable of character type

	MODULE Test;
	VAR variable: CHAR;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

positive: for statement with control variable of integer type

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement with control variable of real type

	MODULE Test;
	VAR variable: REAL;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement with control variable of set type

	MODULE Test;
	VAR variable: SET;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement with control variable of array type

	MODULE Test;
	VAR variable: ARRAY 10 OF CHAR;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement with control variable of record type

	MODULE Test;
	VAR variable: RECORD END;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement with control variable of pointer to array type

	MODULE Test;
	VAR variable: POINTER TO ARRAY 10 OF CHAR;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement with control variable of pointer to record type

	MODULE Test;
	VAR variable: POINTER TO RECORD;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement with control variable of procedure type

	MODULE Test;
	VAR variable: PROCEDURE;
	BEGIN FOR variable := variable TO variable DO END;
	END Test.

negative: for statement missing FOR

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN variable := 0 TO 10 DO END;
	END Test.

negative: for statement missing control variable

	MODULE Test;
	BEGIN FOR := 0 TO 10 DO END;
	END Test.

negative: for statement missing assignment

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN FOR variable 0 TO 10 DO END;
	END Test.

negative: for statement missing low value

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN FOR variable := TO 10 DO END;
	END Test.

negative: for statement missing TO

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN FOR variable := 0 10 DO END;
	END Test.

negative: for statement missing high value

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN FOR variable := 0 TO DO END;
	END Test.

positive: for statement with step

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN FOR variable := 0 TO 10 BY 2 DO END;
	END Test.

negative: for statement with step missing BY

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN FOR variable := 0 TO 10 2 DO END;
	END Test.

negative: for statement missing END

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN FOR variable := 0 TO 10 DO;
	END Test.

negative: for statement with control value

	MODULE Test;
	BEGIN FOR 0 := 0 TO 10 DO END;
	END Test.

negative: for statement with imported control variable

	MODULE Test;
	IMPORT Import;
	BEGIN FOR Import.exportedVariable := 0 TO 10 DO END;
	END Test.

negative: for statement with record control variable

	MODULE Test;
	VAR variable: RECORD value: INTEGER END;
	BEGIN FOR variable.value := 0 TO 10 DO END;
	END Test.

positive: for statement with constant first value

	MODULE Test;
	CONST Low = 0;
	VAR variable: INTEGER;
	BEGIN FOR variable := Low TO 10 DO END;
	END Test.

positive: for statement with variable first value

	MODULE Test;
	VAR variable, low: INTEGER;
	BEGIN FOR variable := low TO 10 DO END;
	END Test.

positive: for statement with constant high value

	MODULE Test;
	CONST High = 10;
	VAR variable: INTEGER;
	BEGIN FOR variable := 0 TO High DO END;
	END Test.

positive: for statement with variable high value

	MODULE Test;
	VAR variable, high: INTEGER;
	BEGIN FOR variable := 0 TO high DO END;
	END Test.

positive: for statement with constant step value

	MODULE Test;
	CONST Step = 1;
	VAR variable: INTEGER;
	BEGIN FOR variable := 0 TO 10 BY Step DO END;
	END Test.

negative: for statement with zero step value

	MODULE Test;
	CONST Step = 0;
	VAR variable: INTEGER;
	BEGIN FOR variable := 0 TO 10 BY Step DO END;
	END Test.

negative: for statement with variable step value

	MODULE Test;
	VAR variable, step: INTEGER;
	BEGIN FOR variable := 0 TO 10 BY step DO END;
	END Test.

positive: for statement examples

	MODULE Test;
	VAR i, k: INTEGER;
	VAR a: ARRAY 100 OF INTEGER;
	BEGIN
		FOR i := 0 TO 79 DO k := k + a[i] END;
		FOR i := 79 TO 1 BY -1 DO a[i] := a[i - 1] END;
	END Test.

# 9.9 Loop statement

negative: loop statement missing LOOP

	MODULE Test;
	BEGIN END
	END Test.

negative: loop statement missing END

	MODULE Test;
	BEGIN LOOP
	END Test.

positive: nested loop statement

	MODULE Test;
	BEGIN LOOP LOOP END END
	END Test.

positive: loop statement example

	MODULE Test;
	VAR i: INTEGER;
	PROCEDURE ReadInt (VAR x: INTEGER); END ReadInt;
	PROCEDURE WriteInt (x: INTEGER); END WriteInt;
	BEGIN
		LOOP
			ReadInt(i);
			IF i < 0 THEN EXIT END;
			WriteInt(i)
		END
	END Test.

# 9.10 Return and exit statements

negative: return statement missing RETURN;

	MODULE Test;
	PROCEDURE Procedure (): INTEGER;
	BEGIN 0;
	END Procedure;
	END Test.

positive: return statement without expression in module body

	MODULE Test;
	BEGIN RETURN;
	END Test.

positive: return statement without expression in proper procedure

	MODULE Test;
	PROCEDURE Procedure;
	BEGIN RETURN;
	END Procedure;
	END Test.

negative: return statement without expression in function procedure

	MODULE Test;
	PROCEDURE Procedure (): INTEGER;
	BEGIN RETURN;
	END Procedure;
	END Test.

negative: return statement with expression in module body

	MODULE Test;
	BEGIN RETURN 0;
	END Test.

negative: return statement with expression in proper procedure

	MODULE Test;
	PROCEDURE Procedure;
	BEGIN RETURN 0;
	END Procedure;
	END Test.

positive: return statement with expression in function procedure

	MODULE Test;
	PROCEDURE Procedure (): INTEGER;
	BEGIN RETURN 0;
	END Procedure;
	END Test.

positive: return statement with assignment-compatible expression

	MODULE Test;
	TYPE PointerType = POINTER TO RECORD END;
	TYPE ProcedureType = PROCEDURE;
	PROCEDURE Boolean (): BOOLEAN; BEGIN RETURN TRUE END Boolean;
	PROCEDURE Character (): CHAR; BEGIN RETURN ' ' END Character;
	PROCEDURE Integer (): LONGINT; BEGIN RETURN MAX (SHORTINT); RETURN MAX (INTEGER); RETURN MAX (LONGINT) END Integer;
	PROCEDURE Real (): LONGREAL; BEGIN RETURN MAX (LONGINT); RETURN MAX (REAL); RETURN MAX (LONGREAL) END Real;
	PROCEDURE Set (): SET; BEGIN RETURN {} END Set;
	PROCEDURE Pointer (): PointerType; BEGIN RETURN NIL END Pointer;
	PROCEDURE Procedure (): ProcedureType; BEGIN RETURN NIL END Procedure;
	END Test.

negative: unbounded exit statement

	MODULE Test;
	BEGIN EXIT
	END Test.

positive: exit statement within loop

	MODULE Test;
	BEGIN LOOP EXIT END
	END Test.

negative: exit statement before loop

	MODULE Test;
	BEGIN EXIT ; LOOP END
	END Test.

negative: exit statement after loop

	MODULE Test;
	BEGIN LOOP END ; EXIT
	END Test.

positive: exit statement within nested loop

	MODULE Test;
	BEGIN LOOP LOOP EXIT END END
	END Test.

positive: exit statement before nested loop

	MODULE Test;
	BEGIN LOOP EXIT ; LOOP END END
	END Test.

positive: exit statement after nested loop

	MODULE Test;
	BEGIN LOOP LOOP END ; EXIT END
	END Test.

# 9.11 With statements

negative: with statement with guard of boolean type

	MODULE Test;
	TYPE Guard = BOOLEAN;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

negative: with statement with guard of character type

	MODULE Test;
	TYPE Guard = CHAR;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

negative: with statement with guard of integer type

	MODULE Test;
	TYPE Guard = INTEGER;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

negative: with statement with guard of real type

	MODULE Test;
	TYPE Guard = REAL;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

negative: with statement with guard of set type

	MODULE Test;
	TYPE Guard = SET;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

negative: with statement with guard of array type

	MODULE Test;
	TYPE Guard = ARRAY 10 OF CHAR;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

positive: with statement with guard of record type

	MODULE Test;
	TYPE Guard = RECORD END;
	PROCEDURE Procedure (VAR guard: Guard);
	BEGIN WITH guard: Guard DO END;
	END Procedure;
	END Test.

negative: with statement with guard of pointer to array type

	MODULE Test;
	TYPE Guard = POINTER TO ARRAY 10 OF CHAR;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

positive: with statement with guard of pointer to record type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

negative: with statement with guard of procedure type

	MODULE Test;
	TYPE Guard = PROCEDURE;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO END;
	END Test.

negative: empty with statement

	MODULE Test;
	BEGIN WITH END;
	END Test.

negative: with statement missing WITH

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	VAR guard: Guard;
	BEGIN guard: Guard DO END;
	END Test.

negative: with statement missing variable

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	BEGIN WITH : Guard DO END;
	END Test.

negative: with statement missing colon

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	VAR guard: Guard;
	BEGIN WITH guard Guard DO END;
	END Test.

negative: with statement missing type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	VAR guard: Guard;
	BEGIN WITH guard: DO END;
	END Test.

negative: with statement missing DO

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	VAR guard: Guard;
	BEGIN WITH guard: Guard END;
	END Test.

positive: with statement with guard

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO ELSE END;
	END Test.

positive: with statement with multiple guards

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard1 = POINTER TO RECORD (Record) END;
	TYPE Guard2 = POINTER TO RECORD (Record) END;
	VAR guard: POINTER TO Record;
	BEGIN WITH guard: Guard1 DO | guard: Guard2 DO ELSE END;
	END Test.

negative: with statement with multiple guards missing bar

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard1 = POINTER TO RECORD (Record) END;
	TYPE Guard2 = POINTER TO RECORD (Record) END;
	VAR guard: POINTER TO Record;
	BEGIN WITH guard: Guard1 DO guard: Guard2 DO ELSE END;
	END Test.

positive: with statement with END

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO ELSE END;
	END Test.

negative: with statement missing END

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Guard = POINTER TO Record;
	VAR guard: Guard;
	BEGIN WITH guard: Guard DO;
	END Test.

negative: with statement with global variable of record type

	MODULE Test;
	TYPE Type = RECORD END;
	VAR variable: Type;
	BEGIN WITH variable: Type DO END;
	END Test.

negative: with statement with local variable of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure;
	VAR variable: Type;
	BEGIN WITH variable: Type DO END;
	END Procedure;
	END Test.

negative: with statement with value parameter of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (parameter: Type);
	BEGIN WITH parameter: Type DO END;
	END Procedure;
	END Test.

positive: with statement with variable parameter of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Type DO Procedure (parameter) END;
	END Procedure;
	END Test.

positive: with statement with variable parameter of extended record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD (Type) x: CHAR END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Record DO parameter.x := 0X; Procedure (parameter) END;
	END Procedure;
	END Test.

negative: with statement with variable parameter of unextended record type

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Record = RECORD END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Record DO END;
	END Procedure;
	END Test.

positive: with statement with global variable of pointer to record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	VAR variable: Type;
	BEGIN WITH variable: Type DO END;
	END Test.

positive: with statement with local variable of pointer to record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	PROCEDURE Procedure;
	VAR variable: Type;
	BEGIN WITH variable: Type DO END;
	END Procedure;
	END Test.

positive: with statement with value parameter of pointer to record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	PROCEDURE Procedure (parameter: Type);
	BEGIN WITH parameter: Type DO Procedure (parameter) END;
	END Procedure;
	END Test.

positive: with statement with value parameter of pointer to extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Pointer = POINTER TO RECORD (Base) x: CHAR END;
	PROCEDURE Procedure (parameter: Type);
	BEGIN WITH parameter: Pointer DO parameter.x := 0X; Procedure (parameter) END;
	END Procedure;
	END Test.

positive: with statement with variable parameter of pointer to record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Type DO Procedure (parameter) END;
	END Procedure;
	END Test.

positive: with statement with variable parameter of pointer to extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Pointer = POINTER TO RECORD (Base) x: CHAR END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Pointer DO parameter.x := 0X END;
	END Procedure;
	END Test.

negative: with statement with variable parameter of pointer to unextended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = POINTER TO Base;
	TYPE Pointer = POINTER TO RECORD END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Pointer DO END;
	END Procedure;
	END Test.

negative: with statement with pointer to array type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Type DO END;
	END Procedure;
	END Test.

negative: with statement with procedure type

	MODULE Test;
	TYPE Type = PROCEDURE;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Type DO END;
	END Procedure;
	END Test.

positive: with statement example

	MODULE Test;
	TYPE Tree = POINTER TO Node;
	TYPE Node = RECORD
	END;
	TYPE CenterTree = POINTER TO CenterNode;
	TYPE CenterNode = RECORD (Node)
		width: INTEGER;
		subnode: Tree;
	END;
	VAR i: INTEGER;
	VAR t, c: Tree;
	BEGIN WITH t: CenterTree DO i := t.width; c := t.subnode END;
	END Test.

# 10. Procedure declarations

positive: repeated procedure identifier

	MODULE Test;
	PROCEDURE Procedure;
	END Procedure;
	END Test.

negative: unmatched procedure identifier

	MODULE Test;
	PROCEDURE Procedure;
	END Hello;
	END Test.

positive: function procedure activation in expression

	MODULE Test;
	VAR value: INTEGER;
	PROCEDURE Function (): INTEGER;
	BEGIN RETURN 0;
	END Function;
	BEGIN value := Function ();
	END Test.

negative: function procedure activation in procedure call

	MODULE Test;
	VAR value: INTEGER;
	PROCEDURE Function (): INTEGER;
	BEGIN RETURN 0;
	END Function;
	BEGIN Function;
	END Test.

negative: proper procedure activation in expression

	MODULE Test;
	VAR value: INTEGER;
	PROCEDURE Function;
	END Function;
	BEGIN value := Function ();
	END Test.

positive: proper procedure activation in procedure call

	MODULE Test;
	VAR value: INTEGER;
	PROCEDURE Function;
	END Function;
	BEGIN Function;
	END Test.

positive: local constant used inside of procedure

	MODULE Test;
	PROCEDURE Procedure;
	CONST Constant = 0;
	VAR variable: INTEGER;
	BEGIN variable := Constant;
	END Procedure;
	END Test.

negative: local constant used outside of procedure

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure;
	CONST Constant = 0;
	END Procedure;
	BEGIN variable := Constant;
	END Test.

positive: local variable used inside of procedure

	MODULE Test;
	CONST Constant = 0;
	PROCEDURE Procedure;
	VAR variable: INTEGER;
	BEGIN variable := Constant;
	END Procedure;
	END Test.

negative: local variable used outside of procedure

	MODULE Test;
	CONST Constant = 0;
	PROCEDURE Procedure;
	VAR variable: INTEGER;
	END Procedure;
	BEGIN variable := Constant;
	END Test.

positive: local type used inside of procedure

	MODULE Test;
	PROCEDURE Procedure;
	TYPE Type = INTEGER;
	VAR variable: Type;
	END Procedure;
	END Test.

negative: local type used outside of procedure

	MODULE Test;
	PROCEDURE Procedure;
	TYPE Type = INTEGER;
	END Procedure;
	PROCEDURE Function (): Type;
	BEGIN RETURN 0;
	END Function;
	END Test.

positive: local procedure used inside of procedure

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE Nested;
	END Nested;
	BEGIN Nested;
	END Procedure;
	END Test.

negative: local procedure used outside of procedure

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE Nested;
	END Nested;
	END Procedure;
	BEGIN Nested;
	END Test.

positive: nested procedure declarations

	MODULE Test;
	PROCEDURE Procedure;
		PROCEDURE Procedure;
			PROCEDURE Procedure;
			END Procedure;
		END Procedure;
	END Procedure;
	END Test.

negative: procedure declaration missing PROCEDURE

	MODULE Test;
	Procedure;
	END Procedure;
	END Test.

negative: procedure declaration missing identifier

	MODULE Test;
	PROCEDURE;
	END Procedure;
	END Test.

positive: procedure declaration with receiver

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE (VAR record: Record) Procedure;
	END Procedure;
	END Test.

positive: procedure declaration with formal parameters

	MODULE Test;
	PROCEDURE Procedure ();
	END Procedure;
	END Test.

negative: procedure declaration missing semicolon

	MODULE Test;
	PROCEDURE Procedure
	END Procedure;
	END Test.

positive: procedure declaration with declaration sequence

	MODULE Test;
	PROCEDURE Procedure;
	CONST VAR TYPE
	END Procedure;
	END Test.

positive: procedure declaration with body

	MODULE Test;
	PROCEDURE Procedure;
	BEGIN
	END Procedure;
	END Test.

negative: procedure declaration missing END

	MODULE Test;
	PROCEDURE Procedure;
	Procedure;
	END Test.

negative: procedure declaration missing identifier at the end

	MODULE Test;
	PROCEDURE Procedure;
	END;
	END Test.

negative: procedure declaration missing semicolon at the end

	MODULE Test;
	PROCEDURE Procedure;
	END Procedure
	END Test.

positive: empty declaration sequence

	MODULE Test;
	CONST TYPE VAR
	END Test.

positive: empty declaration sequences

	MODULE Test;
	CONST TYPE VAR CONST TYPE VAR
	END Test.

negative: constant declaration missing semicolon

	MODULE Test;
	CONST Constant = 0
	END Test.

negative: type declaration missing semicolon

	MODULE Test;
	TYPE Type = INTEGER
	END Test.

negative: variable declaration missing semicolon

	MODULE Test;
	VAR variable: INTEGER
	END Test.

positive: forward declaration

	MODULE Test;
	PROCEDURE ^ Procedure;
	PROCEDURE Procedure; END Procedure;
	END Test.

negative: forward declaration missing PROCEDURE

	MODULE Test;
	^ Procedure;
	PROCEDURE Procedure; END Procedure;
	END Test.

negative: forward declaration missing ^

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE Procedure; END Procedure;
	END Test.

negative: forward declaration missing identifier

	MODULE Test;
	PROCEDURE ^;
	PROCEDURE Procedure; END Procedure;
	END Test.

positive: forward declaration with receiver

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure;
	PROCEDURE (VAR record: Record) Procedure;
	END Procedure;
	END Test.

positive: forward declaration with formal parameters

	MODULE Test;
	PROCEDURE ^ Procedure ();
	PROCEDURE Procedure; END Procedure;
	END Test.

negative: forward declaration missing semicolon

	MODULE Test;
	PROCEDURE ^ Procedure
	PROCEDURE Procedure; END Procedure;
	END Test.

negative: forward declaration with declaration sequence

	MODULE Test;
	PROCEDURE ^ Procedure;
	CONST VAR TYPE
	PROCEDURE Procedure; END Procedure;
	END Test.

negative: forward declaration with body

	MODULE Test;
	PROCEDURE ^ Procedure;
	BEGIN
	PROCEDURE Procedure; END Procedure;
	END Test.

negative: forward declaration with END

	MODULE Test;
	PROCEDURE ^ Procedure ();
	END Procedure;
	PROCEDURE Procedure; END Procedure;
	END Test.

negative: undeclared forward declaration

	MODULE Test;
	PROCEDURE ^ Procedure;
	END Test.

positive: duplicated forward declaration

	MODULE Test;
	PROCEDURE ^ Procedure;
	PROCEDURE ^ Procedure;
	PROCEDURE Procedure;
	END Procedure;
	END Test.

positive: forward declaration before procedure declaration

	MODULE Test;
	PROCEDURE ^ Procedure;
	PROCEDURE Procedure;
	END Procedure;
	END Test.

negative: forward declaration after procedure declaration

	MODULE Test;
	PROCEDURE Procedure;
	END Procedure;
	PROCEDURE ^ Procedure;
	END Test.

positive: referencing procedure declaration declared earlier

	MODULE Test;
	PROCEDURE Forward;
	END Forward;
	PROCEDURE Procedure;
	BEGIN Forward;
	END Procedure;
	END Test.

negative: referencing procedure declaration declared later

	MODULE Test;
	PROCEDURE Procedure;
	BEGIN Forward;
	END Procedure;
	PROCEDURE Forward;
	END Forward;
	END Test.

positive: referencing forward declaration declared earlier

	MODULE Test;
	PROCEDURE ^ Forward;
	PROCEDURE Forward;
	END Forward;
	PROCEDURE Procedure;
	BEGIN Forward;
	END Procedure;
	END Test.

positive: referencing forward declaration declared later

	MODULE Test;
	PROCEDURE ^ Forward;
	PROCEDURE Procedure;
	BEGIN Forward;
	END Procedure;
	PROCEDURE Forward;
	END Forward;
	END Test.

negative: undeclared nested forward declaration

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE ^ Procedure;
	END Procedure;
	END Test.

positive: duplicated nested forward declaration

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE ^ Procedure;
	PROCEDURE ^ Procedure;
	PROCEDURE Procedure;
	END Procedure;
	END Procedure;
	END Test.

positive: nested forward declaration before procedure declaration

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE ^ Procedure;
	PROCEDURE Procedure;
	END Procedure;
	END Procedure;
	END Test.

negative: nested forward declaration after procedure declaration

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE Procedure;
	END Procedure;
	PROCEDURE ^ Procedure;
	END Procedure;
	END Test.

positive: referencing nested procedure declaration declared earlier

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE Forward;
	END Forward;
	PROCEDURE Procedure;
	BEGIN Forward;
	END Procedure;
	END Procedure;
	END Test.

negative: referencing nested procedure declaration declared later

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE Procedure;
	BEGIN Forward;
	END Procedure;
	PROCEDURE Forward;
	END Forward;
	END Procedure;
	END Test.

positive: referencing nested forward declaration declared earlier

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE ^ Forward;
	PROCEDURE Forward;
	END Forward;
	PROCEDURE Procedure;
	BEGIN Forward;
	END Procedure;
	END Procedure;
	END Test.

positive: referencing nested forward declaration declared later

	MODULE Test;
	PROCEDURE Procedure;
	PROCEDURE ^ Forward;
	PROCEDURE Procedure;
	BEGIN Forward;
	END Procedure;
	PROCEDURE Forward;
	END Forward;
	END Procedure;
	END Test.

positive: forward declaration with identical formal parameters

	MODULE Test;
	PROCEDURE ^ Procedure (parameter: SET): CHAR;
	PROCEDURE Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration with unidentical parameter count

	MODULE Test;
	PROCEDURE ^ Procedure (): CHAR;
	PROCEDURE Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration with unidentical value parameter

	MODULE Test;
	PROCEDURE ^ Procedure (parameter: SET): CHAR;
	PROCEDURE Procedure (VAR parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration with unidentical variable parameter

	MODULE Test;
	PROCEDURE ^ Procedure (VAR parameter: SET): CHAR;
	PROCEDURE Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration with unidentical parameter type

	MODULE Test;
	PROCEDURE ^ Procedure (parameter: SET): CHAR;
	PROCEDURE Procedure (parameter: CHAR): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration with unidentical result type

	MODULE Test;
	PROCEDURE ^ Procedure (parameter: SET);
	PROCEDURE Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

# 10.1 Formal parameters

positive: using formal parameter before end of procedure block in which it is declared

	MODULE Test;
	PROCEDURE Procedure (parameter: INTEGER);
	BEGIN parameter := 0;
	END Procedure;
	END Test.

negative: using formal parameter after end of procedure block in which it is declared

	MODULE Test;
	PROCEDURE Procedure (parameter: INTEGER);
	END Procedure;
	BEGIN parameter := 0;
	END Test.

negative: function procedure without parameters missing empty parameter list

	MODULE Test;
	PROCEDURE Procedure : INTEGER;
	END Procedure;
	END Test.

positive: function procedure without parameters and empty parameter list

	MODULE Test;
	PROCEDURE Procedure (): INTEGER;
	BEGIN RETURN 0;
	END Procedure;
	END Test.

negative: function procedure without parameters called by procedure call

	MODULE Test;
	PROCEDURE Procedure (): INTEGER;
	BEGIN RETURN 0;
	END Procedure;
	BEGIN Procedure;
	END Test.

negative: function procedure without parameters called by function designator missing empty parameter list

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure (): INTEGER;
	BEGIN RETURN 0;
	END Procedure;
	BEGIN variable := Procedure;
	END Test.

positive: function procedure without parameters called by function designator with empty parameter list

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure (): INTEGER;
	BEGIN RETURN 0;
	END Procedure;
	BEGIN variable := Procedure ();
	END Test.

positive: boolean function result type

	MODULE Test;
	TYPE Type = BOOLEAN;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

positive: character function result type

	MODULE Test;
	TYPE Type = CHAR;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

positive: integer function result type

	MODULE Test;
	TYPE Type = INTEGER;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

positive: real function result type

	MODULE Test;
	TYPE Type = REAL;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

positive: set function result type

	MODULE Test;
	TYPE Type = SET;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

positive: pointer to array function result type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

positive: pointer to record function result type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

positive: procedure function result type

	MODULE Test;
	TYPE Type = PROCEDURE;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

positive: formal parameters with empty formal parameter list

	MODULE Test;
	PROCEDURE Procedure ();
	END Procedure;
	END Test.

negative: formal parameters missing opening parenthesis

	MODULE Test;
	PROCEDURE Procedure );
	END Procedure;
	END Test.

negative: formal parameters missing closing parenthesis

	MODULE Test;
	PROCEDURE Procedure (;
	END Procedure;
	END Test.

positive: formal parameters without result type

	MODULE Test;
	PROCEDURE Procedure ();
	END Procedure;
	END Test.

negative: formal parameters with result type missing colon

	MODULE Test;
	PROCEDURE Procedure () INTEGER;
	BEGIN RETURN 0;
	END Procedure;
	END Test.

negative: formal parameters with result type missing type

	MODULE Test;
	PROCEDURE Procedure (): ;
	BEGIN RETURN 0;
	END Procedure;
	END Test.

negative: formal parameter list missing identifier

	MODULE Test;
	PROCEDURE Procedure (: INTEGER);
	END Procedure;
	END Test.

negative: formal parameter list missing colon

	MODULE Test;
	PROCEDURE Procedure (a INTEGER);
	END Procedure;
	END Test.

negative: formal parameter list missing type

	MODULE Test;
	PROCEDURE Procedure (a: );
	END Procedure;
	END Test.

positive: formal parameter list with multiple identifiers

	MODULE Test;
	PROCEDURE Procedure (a, b: INTEGER);
	END Procedure;
	END Test.

negative: formal parameter list with multiple identifiers missing comma

	MODULE Test;
	PROCEDURE Procedure (a b: INTEGER);
	END Procedure;
	END Test.

positive: formal parameter list with multiple sections

	MODULE Test;
	PROCEDURE Procedure (a: INTEGER; b: INTEGER);
	END Procedure;
	END Test.

negative: formal parameter list with multiple sections missing semicolon

	MODULE Test;
	PROCEDURE Procedure (a: INTEGER b: INTEGER);
	END Procedure;
	END Test.

positive: assignment-compatible value parameter

	MODULE Test;
	VAR variable: SHORTINT;
	PROCEDURE Procedure (parameter: INTEGER);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

negative: assignment-incompatible value parameter

	MODULE Test;
	VAR variable: INTEGER;
	PROCEDURE Procedure (parameter: SET);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: same variable parameter

	MODULE Test;
	VAR variable: SHORTINT;
	PROCEDURE Procedure (VAR parameter: SHORTINT);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

negative: differing variable parameter

	MODULE Test;
	VAR variable: SHORTINT;
	PROCEDURE Procedure (VAR parameter: INTEGER);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: extended record variable parameter

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Record = RECORD (Base) END;
	VAR variable: Record;
	PROCEDURE Procedure (VAR parameter: Base);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

negative: unextended record variable parameter

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Record = RECORD END;
	VAR variable: Record;
	PROCEDURE Procedure (VAR parameter: Base);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

negative: extended pointer variable parameter

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Record = RECORD (Base) END;
	VAR variable: POINTER TO Record;
	PROCEDURE Procedure (VAR parameter: POINTER TO Base);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

negative: unextended pointer variable parameter

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Record = RECORD END;
	VAR variable: POINTER TO Record;
	PROCEDURE Procedure (VAR parameter: POINTER TO Base);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: array compatible open array value parameter

	MODULE Test;
	PROCEDURE Procedure (parameter: ARRAY OF CHAR);
	BEGIN Procedure (parameter); Procedure ("test");
	END Procedure;
	END Test.

positive: array compatible open array variable parameter

	MODULE Test;
	PROCEDURE Procedure (VAR parameter: ARRAY OF CHAR);
	BEGIN Procedure (parameter);
	END Procedure;
	END Test.

positive: procedure declaration examples

	MODULE Test;
	PROCEDURE Read(VAR ch: CHAR); END Read;
	PROCEDURE Write(ch: CHAR); END Write;
	PROCEDURE ReadInt(VAR x: INTEGER);
	VAR i: INTEGER; ch: CHAR;
	BEGIN i := 0; Read(ch);
		WHILE ("0" <= ch) & (ch <= "9") DO
		i := 10*i + (ORD(ch)-ORD("0")); Read(ch)
	END;
	x := i
	END ReadInt;
	PROCEDURE WriteInt(x: INTEGER); (*0 <= x <100000*)
	VAR i: INTEGER; buf: ARRAY 5 OF INTEGER;
	BEGIN i := 0;
		REPEAT buf[i] := x MOD 10; x := x DIV 10; INC(i) UNTIL x = 0;
		REPEAT DEC(i); Write(CHR(buf[i] + ORD("0"))) UNTIL i = 0
	END WriteInt;
	PROCEDURE WriteString(s: ARRAY OF CHAR);
	VAR i: INTEGER;
	BEGIN i := 0;
		WHILE (i < LEN(s)) & (s[i] # 0X) DO Write(s[i]); INC(i) END
	END WriteString;
	PROCEDURE log2(x: INTEGER): INTEGER;
	VAR y: INTEGER; (*assume x>0*)
	BEGIN
		y := 0; WHILE x > 1 DO x := x DIV 2; INC(y) END;
		RETURN y
	END log2;
	END Test.

# 10.2 Type-bound procedures

negative: binding procedure to boolean type

	MODULE Test;
	TYPE Type = BOOLEAN;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: binding procedure to character type

	MODULE Test;
	TYPE Type = CHAR;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: binding procedure to integer type

	MODULE Test;
	TYPE Type = INTEGER;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: binding procedure to real type

	MODULE Test;
	TYPE Type = REAL;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: binding procedure to set type

	MODULE Test;
	TYPE Type = SET;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: binding procedure to array type

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

positive: binding global procedure to record type declared in the same module

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: binding global procedure to record type declared in other module

	MODULE Test;
	IMPORT Import;
	TYPE Type = Import.ExportedType;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: binding local procedure to record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure;
		PROCEDURE (VAR receiver: Type) Procedure;
		END Procedure;
	END Procedure;
	END Test.

negative: binding procedure to pointer to array type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	PROCEDURE (receiver: Type) Procedure;
	END Procedure;
	END Test.

positive: binding procedure to pointer to record type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	PROCEDURE (receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: binding procedure to procedure type

	MODULE Test;
	TYPE Type = PROCEDURE;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

positive: variable receiver of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: value receiver of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: variable receiver of pointer type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

positive: value receiver of pointer type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	PROCEDURE (receiver: Type) Procedure;
	END Procedure;
	END Test.

positive: local type-bound procedure

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver: Type) Procedure;
	BEGIN receiver.Procedure;
	END Procedure;
	END Test.

negative: global type-bound procedure

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver: Type) Procedure;
	BEGIN Procedure (receiver);
	END Procedure;
	END Test.

negative: receiver missing opening parenthesis

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE VAR receiver: Type) Procedure;
	END Procedure;
	END Test.

negative: receiver missing identifier

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR : Type) Procedure;
	END Procedure;
	END Test.

negative: receiver with multiple identifiers

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver1, receiver2: Type) Procedure;
	END Procedure;
	END Test.

negative: receiver with missing colon

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver Type) Procedure;
	END Procedure;
	END Test.

negative: receiver with missing type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver:) Procedure;
	END Procedure;
	END Test.

negative: receiver with anonymous record type

	MODULE Test;
	PROCEDURE (VAR receiver: RECORD END) Procedure;
	END Procedure;
	END Test.

negative: receiver with anonymous pointer to record type

	MODULE Test;
	PROCEDURE (VAR receiver: POINTER TO RECORD END) Procedure;
	END Procedure;
	END Test.

negative: receiver missing closing parenthesis

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver: Type Procedure;
	END Procedure;
	END Test.

negative: multiple receivers

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver1: Type; VAR receiver2: Type) Procedure;
	END Procedure;
	END Test.

negative: consecutive receivers

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver1: Type) (VAR receiver2: Type) Procedure;
	END Procedure;
	END Test.

positive: procedure bound to extended record types

	MODULE Test;
	TYPE Type = RECORD END;
	VAR variable: RECORD (Type) END;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	BEGIN variable.Procedure;
	END Test.

negative: procedure bound to unextended record types

	MODULE Test;
	TYPE Type = RECORD END;
	VAR variable: RECORD END;
	PROCEDURE (VAR receiver: Type) Procedure;
	END Procedure;
	BEGIN variable.Procedure;
	END Test.

positive: redefinition of type-bound procedure with matching formal parameters

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched parameter count

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched value parameter

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (VAR parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched variable parameter

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (VAR parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched parameter type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: CHAR): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched result type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET);
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched receiver of record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = POINTER TO RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched receiver of pointer type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Base = POINTER TO Record;
	TYPE Extension = RECORD (Record) END;
	PROCEDURE (base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: exported redefinition of type-bound procedure in exported type with matching export marks

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension* = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure* (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure* (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: exported redefinition of type-bound procedure in exported type with unmatched export marks

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension* = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure* (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: exported redefinition of type-bound procedure in unexported type with matching export marks

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure* (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure* (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: exported redefinition of type-bound procedure in unexported type with unmatched export marks

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure* (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: unexported redefinition of type-bound procedure in exported type with matching export marks

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension* = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: unexported redefinition of type-bound procedure in exported type with unmatched export marks

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension* = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure* (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: unexported redefinition of type-bound procedure in unexported type with matching export marks

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: unexported redefinition of type-bound procedure in unexported type with unmatched export marks

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure* (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: preceding redefinition of type-bound procedure

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure;
	END Procedure;
	END Test.

positive: succeeding redefinition of type-bound procedure

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR extension: Extension) Procedure;
	END Procedure;
	PROCEDURE (VAR base: Base) Procedure;
	END Procedure;
	END Test.

positive: denoting redefined type-bound procedure of extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure;
	BEGIN extension.Procedure^;
	END Procedure;
	END Test.

negative: denoting redefined type-bound procedure of unextended record type

	MODULE Test;
	TYPE Base = RECORD END;
	PROCEDURE (VAR base: Base) Procedure;
	BEGIN base.Procedure^;
	END Procedure;
	END Test.

positive: denoting redefined type-bound procedure of pointer to extended record type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Base = POINTER TO Record;
	TYPE Extension = POINTER TO RECORD (Record) END;
	PROCEDURE (base: Base) Procedure;
	END Procedure;
	PROCEDURE (extension: Extension) Procedure;
	BEGIN extension.Procedure^;
	END Procedure;
	END Test.

negative: denoting redefined type-bound procedure of pointer to unextended record type

	MODULE Test;
	TYPE Base = POINTER TO RECORD END;
	PROCEDURE (base: Base) Procedure;
	BEGIN base.Procedure^;
	END Procedure;
	END Test.

negative: denoting redefined type-bound procedure on variable parameter

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (VAR record: Extension);
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (VAR record: Extension);
	BEGIN record.Procedure^;
	END Procedure;
	END Test.
	END Test.

positive: forward declaration of type-bound procedure with identical formal parameters

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure (parameter: SET): CHAR;
	PROCEDURE (VAR record: Record) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration of type-bound procedure with unidentical receiver

	MODULE Test;
	TYPE Record = RECORD END; Type = RECORD END;
	PROCEDURE ^ (VAR record: Type) Procedure (): CHAR;
	PROCEDURE (VAR record: Record) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration of type-bound procedure with unidentical parameter count

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure (): CHAR;
	PROCEDURE (VAR record: Record) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration of type-bound procedure with unidentical value parameter

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure (parameter: SET): CHAR;
	PROCEDURE (VAR record: Record) Procedure (VAR parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration of type-bound procedure with unidentical variable parameter

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure (VAR parameter: SET): CHAR;
	PROCEDURE (VAR record: Record) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration of type-bound procedure with unidentical parameter type

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure (parameter: SET): CHAR;
	PROCEDURE (VAR record: Record) Procedure (parameter: CHAR): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: forward declaration of type-bound procedure with unidentical result type

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure (parameter: SET);
	PROCEDURE (VAR record: Record) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

positive: type-bound procedure examples

	MODULE Test;
	TYPE Tree = POINTER TO Node;
	TYPE Node = RECORD
		key : INTEGER;
		left, right: Tree
	END;
	TYPE CenterTree = POINTER TO CenterNode;
	TYPE CenterNode = RECORD (Node)
		width: INTEGER;
		subnode: Tree
	END;
	PROCEDURE WriteInt (x: INTEGER); END WriteInt;
	PROCEDURE (t: Tree) Insert (node: Tree);
		VAR p, father: Tree;
	BEGIN p := t;
		REPEAT father := p;
			IF node.key = p.key THEN RETURN END;
			IF node.key < p.key THEN p := p.left ELSE p := p.right END
		UNTIL p = NIL;
		IF node.key < father.key THEN father.left := node ELSE father.right := node END;
		node.left := NIL; node.right := NIL
	END Insert;
	PROCEDURE (t: CenterTree) Insert (node: Tree); (*redefinition*)
	BEGIN
		WriteInt(node(CenterTree).width);
		t.Insert^ (node) (* calls the Insert procedure bound to Tree *)
	END Insert;
	END Test.

# 10.3 Predeclared procedures

negative: absolute value on boolean type

	MODULE Test;
	CONST Result = ABS (FALSE);
	END Test.

negative: absolute value on character type

	MODULE Test;
	CONST Result = ABS (5X);
	END Test.

positive: absolute value on integer type

	MODULE Test;
	CONST Result = ABS (-5);
	BEGIN ASSERT (Result = 5);
	END Test.

positive: absolute value on real type

	MODULE Test;
	CONST Result = ABS (-5.5);
	BEGIN ASSERT (Result = 5.5);
	END Test.

negative: absolute value on set type

	MODULE Test;
	CONST Result = ABS ({5});
	END Test.

negative: arithmetic shift on boolean type

	MODULE Test;
	CONST Result = ASH (FALSE, TRUE);
	END Test.

negative: arithmetic shift on character type

	MODULE Test;
	CONST Result = ASH (4X, 2X);
	END Test.

positive: arithmetic shift on integer type

	MODULE Test;
	CONST Result = ASH (-10, -2);
	BEGIN ASSERT (Result = -3);
	END Test.

negative: arithmetic shift on real type

	MODULE Test;
	CONST Result = ASH (2.5, 2);
	END Test.

negative: arithmetic shift on set type

	MODULE Test;
	CONST Result = ASH ({3}, {1});
	END Test.

negative: capital letter on boolean type

	MODULE Test;
	CONST Result = CAP (FALSE);
	END Test.

positive: capital letter on character type

	MODULE Test;
	CONST Result = CAP ('s');
	BEGIN ASSERT (Result = 'S');
	END Test.

negative: capital letter on integer type

	MODULE Test;
	CONST Result = CAP (5);
	END Test.

negative: capital letter on real type

	MODULE Test;
	CONST Result = CAP (-5.5);
	END Test.

negative: capital letter on set type

	MODULE Test;
	CONST Result = CAP ({5});
	END Test.

negative: ordinal number on boolean type

	MODULE Test;
	CONST Result = CHR (FALSE);
	END Test.

negative: ordinal number on character type

	MODULE Test;
	CONST Result = CHR (5X);
	END Test.

positive: ordinal number on integer type

	MODULE Test;
	CONST Result = CHR (5);
	BEGIN ASSERT (ORD (Result) = 5);
	END Test.

negative: ordinal number on real type

	MODULE Test;
	CONST Result = CHR (-5.5);
	END Test.

negative: ordinal number on set type

	MODULE Test;
	CONST Result = CHR ({5});
	END Test.

negative: entier number on boolean type

	MODULE Test;
	CONST Result = ENTIER (FALSE);
	END Test.

negative: entier number on character type

	MODULE Test;
	CONST Result = ENTIER (5X);
	END Test.

positive: entier number on integer type

	MODULE Test;
	CONST Result = ENTIER (-5);
	BEGIN ASSERT (Result = -5);
	END Test.

positive: entier number on real type

	MODULE Test;
	CONST Result = ENTIER (-4.5);
	BEGIN ASSERT (Result = -5);
	END Test.

negative: entier number on set type

	MODULE Test;
	CONST Result = ENTIER ({5});
	END Test.

negative: length of boolean type

	MODULE Test;
	CONST Result = LEN (FALSE);
	END Test.

negative: length of character type

	MODULE Test;
	CONST Result = LEN (5X);
	END Test.

negative: length of integer type

	MODULE Test;
	CONST Result = LEN (5);
	END Test.

negative: length of real type

	MODULE Test;
	CONST Result = LEN (-4.5);
	END Test.

negative: length of set type

	MODULE Test;
	CONST Result = LEN ({5});
	END Test.

positive: length of array type

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	CONST Result = LEN (array);
	BEGIN ASSERT (Result = 10);
	END Test.

positive: length of array type with constant dimension

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR;
	CONST Result = LEN (array, 0);
	BEGIN ASSERT (Result = 10);
	END Test.

negative: length of array type with variable dimension

	MODULE Test;
	VAR array: ARRAY 10 OF CHAR; dimension: INTEGER;
	BEGIN dimension := 0; ASSERT (LEN (array, dimension) = 10);
	END Test.

negative: length of record type

	MODULE Test;
	VAR record: RECORD END;
	CONST Result = LEN (record);
	END Test.

negative: length of pointer to array type

	MODULE Test;
	VAR pointer: POINTER TO ARRAY 10 OF CHAR;
	CONST Result = LEN (pointer);
	END Test.

negative: length of pointer to record type

	MODULE Test;
	VAR pointer: POINTER TO RECORD END;
	CONST Result = LEN (pointer);
	END Test.

negative: length of procedure type

	MODULE Test;
	VAR procedure: PROCEDURE;
	CONST Result = LEN (procedure);
	END Test.

positive: maximal value of boolean type

	MODULE Test;
	CONST Result = MAX (BOOLEAN);
	END Test.

positive: maximal value of character type

	MODULE Test;
	CONST Result = MAX (CHAR);
	END Test.

positive: maximal value of integer type

	MODULE Test;
	CONST Result = MAX (INTEGER);
	END Test.

positive: maximal value of real type

	MODULE Test;
	CONST Result = MAX (REAL);
	END Test.

positive: maximal value of set type

	MODULE Test;
	CONST Result = MAX (SET);
	END Test.

negative: maximal value of array type

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	CONST Result = MAX (Type);
	END Test.

negative: maximal value of record type

	MODULE Test;
	TYPE Type = RECORD END;
	CONST Result = MAX (Type);
	END Test.

negative: maximal value of pointer to array type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	CONST Result = MAX (Type);
	END Test.

negative: maximal value of pointer to record type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	CONST Result = MAX (Type);
	END Test.

negative: maximal value of procedure

	MODULE Test;
	TYPE Type = PROCEDURE;
	CONST Result = MAX (Type);
	END Test.

positive: minimal value of boolean type

	MODULE Test;
	CONST Result = MIN (BOOLEAN);
	END Test.

positive: minimal value of character type

	MODULE Test;
	CONST Result = MIN (CHAR);
	END Test.

positive: minimal value of integer type

	MODULE Test;
	CONST Result = MIN (INTEGER);
	END Test.

positive: minimal value of real type

	MODULE Test;
	CONST Result = MIN (REAL);
	END Test.

positive: minimal value of set type

	MODULE Test;
	CONST Result = MIN (SET);
	END Test.

negative: minimal value of array type

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	CONST Result = MIN (Type);
	END Test.

negative: minimal value of record type

	MODULE Test;
	TYPE Type = RECORD END;
	CONST Result = MIN (Type);
	END Test.

negative: minimal value of pointer to array type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	CONST Result = MIN (Type);
	END Test.

negative: minimal value of pointer to record type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	CONST Result = MIN (Type);
	END Test.

negative: minimal value of procedure

	MODULE Test;
	TYPE Type = PROCEDURE;
	CONST Result = MIN (Type);
	END Test.

negative: oddness on boolean type

	MODULE Test;
	CONST Result = ODD (FALSE);
	END Test.

negative: oddness on character type

	MODULE Test;
	CONST Result = ODD (5X);
	END Test.

positive: oddness on integer type

	MODULE Test;
	CONST Result = ODD (5);
	BEGIN ASSERT (Result);
	END Test.

negative: oddness on real type

	MODULE Test;
	CONST Result = ODD (-5.5);
	END Test.

negative: oddness on set type

	MODULE Test;
	CONST Result = ODD ({5});
	END Test.

positive: size of boolean type

	MODULE Test;
	CONST Result = SIZE (BOOLEAN);
	BEGIN ASSERT (Result >= 1);
	END Test.

positive: size of character type

	MODULE Test;
	CONST Result = SIZE (CHAR);
	BEGIN ASSERT (Result >= 1);
	END Test.

positive: size of integer type

	MODULE Test;
	CONST Result = SIZE (INTEGER);
	BEGIN ASSERT (Result >= 1);
	END Test.

positive: size of real type

	MODULE Test;
	CONST Result = SIZE (REAL);
	BEGIN ASSERT (Result >= 1);
	END Test.

positive: size of set type

	MODULE Test;
	CONST Result = SIZE (SET);
	BEGIN ASSERT (Result >= 1);
	END Test.

positive: size of array type

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	CONST Result = SIZE (Type);
	BEGIN ASSERT (Result >= SIZE (CHAR) * 10);
	END Test.

positive: size of record type

	MODULE Test;
	TYPE Type = RECORD a, b: INTEGER END;
	CONST Result = SIZE (Type);
	BEGIN ASSERT (Result >= SIZE (INTEGER) * 2);
	END Test.

positive: size of pointer to array type

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	CONST Result = SIZE (Type);
	BEGIN ASSERT (Result >= 1);
	END Test.

positive: size of pointer to record type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	CONST Result = SIZE (Type);
	BEGIN ASSERT (Result >= 1);
	END Test.

positive: size of procedure type

	MODULE Test;
	TYPE Type = PROCEDURE;
	CONST Result = SIZE (Type);
	BEGIN ASSERT (Result >= 1);
	END Test.

positive: assertion with satisfied boolean guard

	MODULE Test;
	BEGIN ASSERT (TRUE);
	END Test.

negative: assertion with unsatisfied boolean guard

	MODULE Test;
	BEGIN ASSERT (FALSE);
	END Test.

negative: assertion with boolean guard and boolean status

	MODULE Test;
	BEGIN ASSERT (TRUE, TRUE);
	END Test.

negative: assertion with boolean guard and character status

	MODULE Test;
	BEGIN ASSERT (TRUE, 's');
	END Test.

positive: assertion with boolean guard and integer status

	MODULE Test;
	BEGIN ASSERT (TRUE, 0);
	END Test.

negative: assertion with boolean guard and real status

	MODULE Test;
	BEGIN ASSERT (TRUE, 2.5);
	END Test.

negative: assertion with boolean guard and set status

	MODULE Test;
	BEGIN ASSERT (TRUE, {3});
	END Test.

negative: assertion with character guard

	MODULE Test;
	BEGIN ASSERT ('s');
	END Test.

negative: assertion with integer guard

	MODULE Test;
	BEGIN ASSERT (5);
	END Test.

negative: assertion with real guard

	MODULE Test;
	BEGIN ASSERT (2.5);
	END Test.

negative: assertion with set guard

	MODULE Test;
	BEGIN ASSERT ({3});
	END Test.

negative: copy on boolean types

	MODULE Test;
	VAR a, b: BOOL;
	BEGIN COPY (a, b);
	END Test.

negative: copy on character types

	MODULE Test;
	VAR a, b: CHAR;
	BEGIN COPY (a, b);
	END Test.

negative: copy on integer types

	MODULE Test;
	VAR a, b: INTEGER;
	BEGIN COPY (a, b);
	END Test.

negative: copy on real types

	MODULE Test;
	VAR a, b: REAL;
	BEGIN COPY (a, b);
	END Test.

negative: copy on set types

	MODULE Test;
	VAR a, b: SET;
	BEGIN COPY (a, b);
	END Test.

negative: copy on array of boolean types

	MODULE Test;
	VAR a, b: ARRAY 10 OF BOOL;
	BEGIN COPY (a, b);
	END Test.

positive: copy on array of character types

	MODULE Test;
	VAR a, b: ARRAY 10 OF CHAR;
	BEGIN COPY (a, b);
	END Test.

positive: copy on separate array of character types

	MODULE Test;
	VAR a: ARRAY 10 OF CHAR; b: ARRAY 10 OF CHAR;
	BEGIN COPY (a, b);
	END Test.

positive: copy on string and array of character type

	MODULE Test;
	VAR b: ARRAY 10 OF CHAR;
	BEGIN COPY ("a", b);
	END Test.

negative: copy on array of character type and string

	MODULE Test;
	VAR a: ARRAY 10 OF CHAR;
	BEGIN COPY (a, "a");
	END Test.

negative: copy on array of integer types

	MODULE Test;
	VAR a, b: ARRAY 10 OF INTEGER;
	BEGIN COPY (a, b);
	END Test.

negative: copy on array of real types

	MODULE Test;
	VAR a, b: ARRAY 10 OF REAL;
	BEGIN COPY (a, b);
	END Test.

negative: copy on array of set types

	MODULE Test;
	VAR a, b: ARRAY 10 OF SET;
	BEGIN COPY (a, b);
	END Test.

negative: copy on array of array types

	MODULE Test;
	VAR a, b: ARRAY 10 OF ARRAY 10 OF CHAR;
	BEGIN COPY (a, b);
	END Test.

negative: copy on array of record types

	MODULE Test;
	VAR a, b: ARRAY 10 OF RECORD END;
	BEGIN COPY (a, b);
	END Test.

negative: copy on array of pointer to array types

	MODULE Test;
	VAR a, b: ARRAY 10 OF POINTER TO ARRAY OF CHAR;
	BEGIN COPY (a, b);
	END Test.

negative: copy on array of pointer to record types

	MODULE Test;
	VAR a, b: ARRAY 10 OF POINTER TO RECORD END;
	BEGIN COPY (a, b);
	END Test.

negative: copy on array of procedure types

	MODULE Test;
	VAR a, b: ARRAY 10 OF PROCEDURE;
	BEGIN COPY (a, b);
	END Test.

negative: copy on record types

	MODULE Test;
	VAR a, b: RECORD END;
	BEGIN COPY (a, b);
	END Test.

negative: copy on pointer to array types

	MODULE Test;
	VAR a, b: POINTER TO ARRAY 10 OF CHAR;
	BEGIN COPY (a, b);
	END Test.

negative: copy on pointer to record types

	MODULE Test;
	VAR a, b: POINTER TO RECORD END;
	BEGIN COPY (a, b);
	END Test.

negative: copy on procedure types

	MODULE Test;
	VAR a, b: PROCEDURE;
	BEGIN COPY (a, b);
	END Test.

negative: decrement on boolean variable

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN DEC (variable);
	END Test.

negative: decrement on character variable

	MODULE Test;
	VAR variable: CHAR;
	BEGIN DEC (variable);
	END Test.

positive: decrement on integer variable

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN DEC (variable); DEC (variable, 1); DEC (variable, variable);
	END Test.

negative: decrement on integer constant

	MODULE Test;
	CONST Constant = 0;
	BEGIN DEC (Constant);
	END Test.

negative: decrement on real variable

	MODULE Test;
	VAR variable: REAL;
	BEGIN DEC (variable);
	END Test.

negative: decrement on set variable

	MODULE Test;
	VAR variable: SET;
	BEGIN DEC (variable);
	END Test.

negative: exclusion on boolean variable

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN EXCL (variable);
	END Test.

negative: exclusion on character variable

	MODULE Test;
	VAR variable: CHAR;
	BEGIN DEC (variable);
	END Test.

positive: exclusion on integer variable

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN DEC (variable);
	END Test.

negative: exclusion on real variable

	MODULE Test;
	VAR variable: REAL;
	BEGIN EXCL (variable);
	END Test.

negative: exclusion of boolean type on set variable

	MODULE Test;
	VAR variable: SET; element: BOOLEAN;
	BEGIN EXCL (variable, element);
	END Test.

negative: exclusion of character type on set variable

	MODULE Test;
	VAR variable: SET; element: CHAR;
	BEGIN EXCL (variable, element);
	END Test.

positive: exclusion of integer type on set variable

	MODULE Test;
	VAR variable: SET; element: INTEGER;
	BEGIN EXCL (variable, element);
	END Test.

negative: exclusion of integer type on set constant

	MODULE Test;
	CONST Constant = {};
	VAR element: INTEGER;
	BEGIN EXCL (Constant, element);
	END Test.

negative: exclusion of real type on set variable

	MODULE Test;
	VAR variable: SET; element: REAL;
	BEGIN EXCL (variable, element);
	END Test.

negative: exclusion of set type on set variable

	MODULE Test;
	VAR variable: SET; element: SET;
	BEGIN EXCL (variable, element);
	END Test.

negative: halt with boolean status

	MODULE Test;
	BEGIN HALT (TRUE);
	END Test.

negative: halt with character status

	MODULE Test;
	BEGIN HALT ('s');
	END Test.

positive: halt with integer status

	MODULE Test;
	BEGIN HALT (0);
	END Test.

negative: halt with real status

	MODULE Test;
	BEGIN HALT (2.5);
	END Test.

negative: halt with set status

	MODULE Test;
	BEGIN HALT ({3});
	END Test.

negative: increment on boolean variable

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN INC (variable);
	END Test.

negative: increment on character variable

	MODULE Test;
	VAR variable: CHAR;
	BEGIN INC (variable);
	END Test.

positive: increment on integer variable

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN INC (variable); INC (variable, 1); INC (variable, variable);
	END Test.

negative: increment on integer constant

	MODULE Test;
	CONST Constant = 0;
	BEGIN INC (Constant);
	END Test.

negative: increment on real variable

	MODULE Test;
	VAR variable: REAL;
	BEGIN INC (variable);
	END Test.

negative: increment on set variable

	MODULE Test;
	VAR variable: SET;
	BEGIN INC (variable);
	END Test.

negative: inclusion on boolean variable

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN INCL (variable);
	END Test.

negative: inclusion on character variable

	MODULE Test;
	VAR variable: CHAR;
	BEGIN INC (variable);
	END Test.

positive: inclusion on integer variable

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN INC (variable);
	END Test.

negative: inclusion on real variable

	MODULE Test;
	VAR variable: REAL;
	BEGIN INCL (variable);
	END Test.

negative: inclusion of boolean type on set variable

	MODULE Test;
	VAR variable: SET; element: BOOLEAN;
	BEGIN INCL (variable, element);
	END Test.

negative: inclusion of character type on set variable

	MODULE Test;
	VAR variable: SET; element: CHAR;
	BEGIN INCL (variable, element);
	END Test.

positive: inclusion of integer type on set variable

	MODULE Test;
	VAR variable: SET; element: INTEGER;
	BEGIN INCL (variable, element);
	END Test.

negative: inclusion of integer type on set constant

	MODULE Test;
	CONST Constant = {};
	VAR element: INTEGER;
	BEGIN INCL (Constant, element);
	END Test.

negative: inclusion of real type on set variable

	MODULE Test;
	VAR variable: SET; element: REAL;
	BEGIN INCL (variable, element);
	END Test.

negative: inclusion of set type on set variable

	MODULE Test;
	VAR variable: SET; element: SET;
	BEGIN INCL (variable, element);
	END Test.

negative: allocation of boolean variable

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN NEW (variable);
	END Test.

negative: allocation of character variable

	MODULE Test;
	VAR variable: CHAR;
	BEGIN NEW (variable);
	END Test.

negative: allocation of integer variable

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN NEW (variable);
	END Test.

negative: allocation of real variable

	MODULE Test;
	VAR variable: REAL;
	BEGIN NEW (variable);
	END Test.

negative: allocation of set variable

	MODULE Test;
	VAR variable: SET;
	BEGIN NEW (variable);
	END Test.

negative: allocation of array variable

	MODULE Test;
	VAR variable: ARRAY 10 OF CHAR;
	BEGIN NEW (variable);
	END Test.

negative: allocation of record variable

	MODULE Test;
	VAR variable: RECORD END;
	BEGIN NEW (variable);
	END Test.

positive: allocation of pointer to fixed array variable without length

	MODULE Test;
	VAR variable: POINTER TO ARRAY 10 OF CHAR;
	BEGIN NEW (variable);
	END Test.

negative: allocation of pointer to fixed array variable with length

	MODULE Test;
	VAR variable: POINTER TO ARRAY 10 OF CHAR;
	BEGIN NEW (variable, 10);
	END Test.

negative: allocation of pointer to fixed array variable with lengths

	MODULE Test;
	VAR variable: POINTER TO ARRAY 10 OF CHAR;
	BEGIN NEW (variable, 10, 10);
	END Test.

negative: allocation of pointer to single open array variable without length

	MODULE Test;
	VAR variable: POINTER TO ARRAY OF CHAR;
	BEGIN NEW (variable);
	END Test.

positive: allocation of pointer to single open array variable with length

	MODULE Test;
	VAR variable: POINTER TO ARRAY OF CHAR;
	BEGIN NEW (variable, 10);
	END Test.

negative: allocation of pointer to single open array variable with lengths

	MODULE Test;
	VAR variable: POINTER TO ARRAY 10 OF CHAR;
	BEGIN NEW (variable, 10, 10);
	END Test.

negative: allocation of pointer to double open array variable without length

	MODULE Test;
	VAR variable: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN NEW (variable);
	END Test.

negative: allocation of pointer to double open array variable with length

	MODULE Test;
	VAR variable: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN NEW (variable, 10);
	END Test.

positive: allocation of pointer to double open array variable with lengths

	MODULE Test;
	VAR variable: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN NEW (variable, 10, 10);
	END Test.

positive: allocation of pointer to record variable without length

	MODULE Test;
	VAR variable: POINTER TO RECORD END;
	BEGIN NEW (variable);
	END Test.

negative: allocation of pointer to record variable with length

	MODULE Test;
	VAR variable: POINTER TO RECORD END;
	BEGIN NEW (variable, 10);
	END Test.

negative: allocation of pointer to record variable with lengths

	MODULE Test;
	VAR variable: POINTER TO RECORD END;
	BEGIN NEW (variable, 10, 10);
	END Test.

negative: allocation of procedure variable

	MODULE Test;
	VAR variable: PROCEDURE;
	BEGIN NEW (variable);
	END Test.

# 11. Modules

positive: repeated module identifier

	MODULE Test;
	END Test.

negative: unmatched module identifier

	MODULE Test;
	END Hello.

negative: module missing MODULE

	Test;
	END Test.

negative: module missing identifier

	MODULE ;
	END Test.

negative: module missing semicolon

	MODULE Test
	END Test.

positive: module with import list

	MODULE Test;
	IMPORT Import;
	END Test.

negative: module with empty import list

	MODULE Test;
	IMPORT;
	END Test.

positive: module with declaration sequence

	MODULE Test;
	CONST VAR TYPE
	PROCEDURE Procedure;
	END Procedure;
	END Test.

positive: module with body

	MODULE Test;
	BEGIN
	END Test.

negative: module missing END

	MODULE Test;
	Test.

negative: module missing identifier at the end

	MODULE Test;
	END .

negative: module missing dot at the end

	MODULE Test;
	END Test

negative: import list missing IMPORT

	MODULE Test;
	Import;
	END Test.

negative: import list missing import

	MODULE Test;
	IMPORT;
	END Test.

negative: import list missing separating comma

	MODULE Test;
	IMPORT A := Import B := Import;
	END Test.

negative: import list missing semicolon

	MODULE Test;
	IMPORT Import
	END Test.

positive: import without alias

	MODULE Test;
	IMPORT Import;
	END Test.

positive: import with alias

	MODULE Test;
	IMPORT A := Import;
	END Test.

negative: duplicated imports

	MODULE Test;
	IMPORT Import, Import;
	END Test.

negative: duplicated aliased imports

	MODULE Test;
	IMPORT A := Import, A := Import;
	END Test.

positive: unique aliased imports

	MODULE Test;
	IMPORT A := Import, B := Import;
	END Test.

positive: unique partially aliased imports

	MODULE Test;
	IMPORT Import, A := Import, B := Import;
	END Test.

positive: referring to imported identifier

	MODULE Test;
	IMPORT Import;
	CONST Constant = Import.ExportedConstant;
	TYPE Type = Import.ExportedType;
	BEGIN Import.exportedVariable := Import.readOnlyVariable; Import.ExportedProcedure;
	END Test.

positive: referring to imported identifier via alias

	MODULE Test;
	IMPORT Alias := Import;
	CONST Constant = Alias.ExportedConstant;
	TYPE Type = Alias.ExportedType;
	BEGIN Alias.exportedVariable := Alias.readOnlyVariable; Alias.ExportedProcedure;
	END Test.

negative: referring to imported identifier via undefined alias

	MODULE Test;
	IMPORT Import;
	CONST Constant = Alias.ExportedConstant;
	TYPE Type = Alias.ExportedType;
	BEGIN Alias.exportedVariable := Alias.readOnlyVariable; Alias.ExportedProcedure;
	END Test.

negative: module importing itself

	MODULE Test;
	IMPORT Test;
	END Test.

negative: module importing itself via alias

	MODULE Test;
	IMPORT Alias := Test;
	END Test.

positive: module example

	MODULE Test;
	(* exports: Tree, Node, Insert, Search, Write, NewTree *)
	(* exports read-only: Node.name *)
	TYPE
		Tree* = POINTER TO Node;
		Node* = RECORD
			name-: POINTER TO ARRAY OF CHAR;
			left, right: Tree
		END;

	PROCEDURE WriteString(s: ARRAY OF CHAR); END WriteString;
	PROCEDURE WriteLn; END WriteLn;

	PROCEDURE (t: Tree) Insert* (name: ARRAY OF CHAR);
		VAR p, father: Tree;
	BEGIN p := t;
		REPEAT father := p;
			IF name = p.name^ THEN RETURN END;
			IF name < p.name^ THEN p := p.left ELSE p := p.right END
		UNTIL p = NIL;
		NEW(p); p.left := NIL; p.right := NIL; NEW(p.name, LEN(name)+1); COPY(name, p.name^);
		IF name < father.name^ THEN father.left := p ELSE father.right := p END
	END Insert;

	PROCEDURE (t: Tree) Search* (name: ARRAY OF CHAR): Tree;
		VAR p: Tree;
	BEGIN p := t;
		WHILE (p # NIL) & (name # p.name^) DO
			IF name < p.name^ THEN p := p.left ELSE p := p.right END
		END;
		RETURN p
	END Search;

	PROCEDURE (t: Tree) Write*;
	BEGIN
		IF t.left # NIL THEN t.left.Write END;
		WriteString(t.name^); WriteLn;
		IF t.right # NIL THEN t.right.Write END
	END Write;

	PROCEDURE NewTree* (): Tree;
		VAR t: Tree;
	BEGIN NEW(t); NEW(t.name, 1); t.name[0] := 0X; t.left := NIL; t.right := NIL; RETURN t
	END NewTree;

	END Test.

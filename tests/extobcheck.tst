# Extended Oberon compilation test and validation suite
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

positive: identifier as sequence of letters and underscore

	MODULE Test;
	CONST ab_cd = 0;
	END Test.

negative: identifier beginning with underscore

	MODULE Test;
	CONST _abcd = 0;
	END Test.

positive: identifier ending with underscore

	MODULE Test;
	CONST abcd_ = 0;
	END Test.

positive: binary integer constant with single digit

	MODULE Test;
	CONST Integer = 0B;
	END Test.

positive: binary integer constant with multiple digits

	MODULE Test;
	CONST Integer = 010100010B;
	END Test.

negative: binary integer constant with decimal digits

	MODULE Test;
	CONST Integer = 0123B;
	END Test.

negative: binary integer constant with hexadecimal digits

	MODULE Test;
	CONST Integer = 010ABCDEFB;
	END Test.

positive: binary integer constant beginning with binary digits

	MODULE Test;
	CONST Integer = 1010B;
	END Test.

positive: binary integer constant beginning with zero and binary digits

	MODULE Test;
	CONST Integer = 010B;
	END Test.

negative: binary integer constant beginning with decimal digits

	MODULE Test;
	CONST Integer = 2010B;
	END Test.

negative: binary integer constant beginning with hexadecimal digits

	MODULE Test;
	CONST Integer = ABCB;
	END Test.

positive: binary integer constant with B suffix

	MODULE Test;
	CONST Integer = 01010B;
	END Test.

negative: binary integer constant with b suffix

	MODULE Test;
	CONST Integer = 01010b;
	END Test.

positive: binary integer constant representation

	MODULE Test;
	CONST Integer = 1010010B;
	BEGIN ASSERT (Integer = 82);
	END Test.

positive: decimal integer constant with single quotes between digits

	MODULE Test;
	CONST Constant = 0'1'2;
	BEGIN ASSERT (Constant = 12);
	END Test.

negative: decimal integer constant with consequtive single quotes between digits

	MODULE Test;
	CONST Constant = 0''1;
	END Test.

negative: decimal integer constant beginning with single quote

	MODULE Test;
	CONST Constant = '0;
	END Test.

negative: decimal integer constant ending with single quote

	MODULE Test;
	CONST Constant = 0';
	END Test.

positive: binary integer constant with single quotes between digits

	MODULE Test;
	CONST Constant = 0'1'0'1B;
	BEGIN ASSERT (Constant = 5);
	END Test.

negative: binary integer constant with consequtive single quotes between digits

	MODULE Test;
	CONST Constant = 0''1B;
	END Test.

negative: binary integer constant beginning with single quote

	MODULE Test;
	CONST Constant = '0B;
	END Test.

negative: binary integer constant ending with single quote

	MODULE Test;
	CONST Constant = 0'B;
	END Test.

positive: hexadecimal integer constant with single quotes between digits

	MODULE Test;
	CONST Constant = 0'1'2H;
	BEGIN ASSERT (Constant = 18);
	END Test.

negative: hexadecimal integer constant with consequtive single quotes between digits

	MODULE Test;
	CONST Constant = 0''1H;
	END Test.

negative: hexadecimal integer constant beginning with single quote

	MODULE Test;
	CONST Constant = '0H;
	END Test.

negative: hexadecimal integer constant ending with single quote

	MODULE Test;
	CONST Constant = 0'H;
	END Test.

positive: real number with single quotes between digits

	MODULE Test;
	CONST Constant = 0'1'2.5;
	BEGIN ASSERT (Constant = 12.5);
	END Test.

negative: real number with consequtive single quotes between digits

	MODULE Test;
	CONST Constant = 0''1.5;
	END Test.

negative: real number beginning with single quote

	MODULE Test;
	CONST Constant = '0.5;
	END Test.

negative: real number ending with single quote

	MODULE Test;
	CONST Constant = 0.5';
	END Test.

positive: real number with single quote in integer part

	MODULE Test;
	CONST Constant = 0'1.5;
	BEGIN ASSERT (Constant = 1.5);
	END Test.

negative: real number with single quote in fractional part

	MODULE Test;
	CONST Constant = 1.2'5;
	END Test.

negative: real number with single quote in scale factor part

	MODULE Test;
	CONST Constant = 1.1E2'3;
	END Test.

positive: ignored letter in scale factor

	MODULE Test;
	VAR real: REAL;
	BEGIN real := 1.0E0; real := 1.0D0;
	END Test.

positive: line break in strings

	MODULE Test;
	CONST C = "ab
	cd";
	END Test.

# 4. Declarations and scope rules

negative: referring to same constant declaration

	MODULE Test;
	CONST Constant = Constant;
	END Test.

negative: referring to same type declaration

	MODULE Test;
	TYPE Type = Type;
	END Test.

positive: pointer type declaration in record scope with unknown base type

	MODULE Test;
	TYPE T = RECORD p: POINTER TO B END;
	TYPE B = RECORD END;
	END Test.

positive: pointer type declaration in record scope with invalid base type

	MODULE Test;
	TYPE T = RECORD p: POINTER TO B; B: CHAR END;
	TYPE B = RECORD END;
	END Test.

negative: constant declared with read-only mark in module block

	MODULE Test;
	CONST Constant- = 0;
	END Test.

negative: type declared with read-only mark in module block

	MODULE Test;
	TYPE Type- = CHAR;
	END Test.

negative: procedure declared with read-only mark in module block

	MODULE Test;
	PROCEDURE Procedure-; END Procedure;
	END Test.

negative: import marked external

	MODULE Test;
	IMPORT SYSTEM, Import [0];
	END Test.

negative: aliased import marked external

	MODULE Test;
	IMPORT SYSTEM, Alias := Import [0];
	END Test.

negative: constant marked external

	MODULE Test;
	IMPORT SYSTEM;
	CONST Constant [0] = 0;
	END Test.

negative: exported constant marked external

	MODULE Test;
	IMPORT SYSTEM;
	CONST Constant* [0] = 0;
	END Test.

negative: type declaration marked external

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type [0] = INTEGER;
	END Test.

negative: exported type declaration marked external

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type* [0] = INTEGER;
	END Test.

positive: variable marked external

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [0]: INTEGER;
	END Test.

positive: exported variable marked external

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable* [0]: INTEGER;
	END Test.

negative: local variable marked external

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure;
	VAR variable [0]: INTEGER;
	END Procedure;
	END Test.

positive: variables marked external

	MODULE Test;
	IMPORT SYSTEM;
	VAR first [0], second [0]: INTEGER;
	END Test.

positive: exported variables marked external

	MODULE Test;
	IMPORT SYSTEM;
	VAR first* [0], second- [0]: INTEGER;
	END Test.

negative: local variables marked external

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure;
	VAR first [0], second [0]: INTEGER;
	END Procedure;
	END Test.

negative: external variable missing expression

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable []: INTEGER;
	END Test.

negative: external variable missing bracket before expression

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable 0]: INTEGER;
	END Test.

negative: external variable missing bracket after expression

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [0: INTEGER;
	END Test.

positive: external variable with constant expression

	MODULE Test;
	IMPORT SYSTEM;
	CONST Constant = 0;
	VAR variable [Constant]: INTEGER;
	END Test.

negative: external variable with variable expression

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [variable]: INTEGER;
	END Test.

negative: external variable missing system import

	MODULE Test;
	VAR variable [0]: INTEGER;
	END Test.

positive: procedure marked external

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [0];
	END Procedure;
	END Test.

positive: exported procedure marked external

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure* [0];
	END Procedure;
	END Test.

negative: local procedure marked external

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure;
	PROCEDURE Procedure [0];
	END Procedure;
	END Procedure;
	END Test.

negative: external procedure missing expression

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [];
	END Procedure;
	END Test.

negative: external procedure missing bracket before expression

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure 0];
	END Procedure;
	END Test.

negative: external procedure missing bracket after expression

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [0;
	END Procedure;
	END Test.

positive: external procedure with constant expression

	MODULE Test;
	IMPORT SYSTEM;
	CONST Constant = 0;
	PROCEDURE Procedure [Constant];
	END Procedure;
	END Test.

negative: external procedure with variable expression

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: INTEGER;
	PROCEDURE Procedure [variable];
	END Test.

negative: external procedure missing system import

	MODULE Test;
	PROCEDURE Procedure [0];
	END Procedure;
	END Test.

positive: external procedure with procedure body

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [0];
	END Procedure;
	END Test.

negative: external procedure missing procedure body

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [0];
	END Test.

negative: field marked external

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Record = RECORD field [0]: INTEGER END;
	END Test.

negative: exported field marked external

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Record = RECORD field* [0]: INTEGER END;
	END Test.

negative: external variable with boolean address

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [FALSE]: INTEGER;
	END Test.

negative: external variable with character address

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [0X]: INTEGER;
	END Test.

positive: external variable with integer address

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [0]: INTEGER;
	END Test.

negative: external variable with real address

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [0.0]: INTEGER;
	END Test.

negative: external variable with set address

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [{}]: INTEGER;
	END Test.

negative: external variable with nil address

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [NIL]: INTEGER;
	END Test.

positive: external variable with string address

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable ["address"]: INTEGER;
	END Test.

positive: external variable with empty string address

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable [""]: INTEGER;
	END Test.

negative: external procedure with boolean address

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [FALSE];
	END Procedure;
	END Test.

negative: external procedure with character address

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [0X];
	END Procedure;
	END Test.

positive: external procedure with integer address

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [0];
	END Procedure;
	END Test.

negative: external procedure with real address

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [0.0];
	END Procedure;
	END Test.

negative: external procedure with set address

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [{}];
	END Procedure;
	END Test.

negative: external procedure with nil address

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [NIL];
	END Procedure;
	END Test.

positive: external procedure with string address

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure ["address"];
	END Procedure;
	END Test.

positive: external procedure with empty string address

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE Procedure [""];
	END Procedure;
	END Test.

positive: forward declaration marked as external with variable declaration

	MODULE Test;
	IMPORT SYSTEM;
	VAR ^ variable [0]: INTEGER;
	VAR variable [0]: INTEGER;
	END Test.

positive: forward declaration marked as external without variable declaration

	MODULE Test;
	IMPORT SYSTEM;
	VAR ^ variable [0]: INTEGER;
	END Test.

negative: forward declaration marked as external without variable declaration missing system import

	MODULE Test;
	VAR ^ variable [0]: INTEGER;
	END Test.

positive: forward declaration marked as external with procedure declaration

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE ^ Procedure [0];
	PROCEDURE Procedure [0];
	END Procedure;
	END Test.

positive: forward declaration marked as external without procedure declaration

	MODULE Test;
	IMPORT SYSTEM;
	PROCEDURE ^ Procedure [0];
	END Test.

negative: forward declaration marked as external without procedure declaration missing system import

	MODULE Test;
	PROCEDURE ^ Procedure [0];
	END Test.

# 5. Constant declarations

positive: ABS referred in constant expression

	MODULE Test;
	CONST Referrer = ABS;
	END Test.

positive: ASH referred in constant expression

	MODULE Test;
	CONST Referrer = ASH;
	END Test.

positive: ASSERT referred in constant expression

	MODULE Test;
	CONST Referrer = ASSERT;
	END Test.

positive: BOOLEAN referred in constant expression

	MODULE Test;
	CONST Referrer = BOOLEAN;
	END Test.

positive: CARDINAL referred in constant expression

	MODULE Test;
	CONST Referrer = CARDINAL;
	END Test.

positive: COMPLEX referred in constant expression

	MODULE Test;
	CONST Referrer = COMPLEX;
	END Test.

positive: COMPLEX32 referred in constant expression

	MODULE Test;
	CONST Referrer = COMPLEX32;
	END Test.

positive: COMPLEX64 referred in constant expression

	MODULE Test;
	CONST Referrer = COMPLEX64;
	END Test.

positive: CAP referred in constant expression

	MODULE Test;
	CONST Referrer = CAP;
	END Test.

positive: CHAR referred in constant expression

	MODULE Test;
	CONST Referrer = CHAR;
	END Test.

positive: CHR referred in constant expression

	MODULE Test;
	CONST Referrer = CHR;
	END Test.

positive: COPY referred in constant expression

	MODULE Test;
	CONST Referrer = COPY;
	END Test.

positive: DEC referred in constant expression

	MODULE Test;
	CONST Referrer = DEC;
	END Test.

positive: ENTIER referred in constant expression

	MODULE Test;
	CONST Referrer = ENTIER;
	END Test.

positive: EXCL referred in constant expression

	MODULE Test;
	CONST Referrer = EXCL;
	END Test.

positive: HALT referred in constant expression

	MODULE Test;
	CONST Referrer = HALT;
	END Test.

positive: HUGECARD referred in constant expression

	MODULE Test;
	CONST Referrer = HUGECARD;
	END Test.

positive: HUGEINT referred in constant expression

	MODULE Test;
	CONST Referrer = HUGEINT;
	END Test.

positive: HUGESET referred in constant expression

	MODULE Test;
	CONST Referrer = HUGESET;
	END Test.

positive: I referred in constant expression

	MODULE Test;
	CONST Referrer = I;
	END Test.

positive: IGNORE referred in constant expression

	MODULE Test;
	CONST Referrer = IGNORE;
	END Test.

positive: INC referred in constant expression

	MODULE Test;
	CONST Referrer = INC;
	END Test.

positive: INCL referred in constant expression

	MODULE Test;
	CONST Referrer = INCL;
	END Test.

positive: INF referred in constant expression

	MODULE Test;
	CONST Referrer = INF;
	END Test.

positive: INTEGER referred in constant expression

	MODULE Test;
	CONST Referrer = INTEGER;
	END Test.

positive: LEN referred in constant expression

	MODULE Test;
	CONST Referrer = LEN;
	END Test.

positive: LENGTH referred in constant expression

	MODULE Test;
	CONST Referrer = LENGTH;
	END Test.

positive: LONG referred in constant expression

	MODULE Test;
	CONST Referrer = LONG;
	END Test.

positive: LONGCARD referred in constant expression

	MODULE Test;
	CONST Referrer = LONGCARD;
	END Test.

positive: LONGCOMPLEX referred in constant expression

	MODULE Test;
	CONST Referrer = LONGCOMPLEX;
	END Test.

positive: LONGINT referred in constant expression

	MODULE Test;
	CONST Referrer = LONGINT;
	END Test.

positive: LONGREAL referred in constant expression

	MODULE Test;
	CONST Referrer = LONGREAL;
	END Test.

positive: LONGSET referred in constant expression

	MODULE Test;
	CONST Referrer = LONGSET;
	END Test.

positive: MAX referred in constant expression

	MODULE Test;
	CONST Referrer = MAX;
	END Test.

positive: MIN referred in constant expression

	MODULE Test;
	CONST Referrer = MIN;
	END Test.

positive: NAN referred in constant expression

	MODULE Test;
	CONST Referrer = NAN;
	END Test.

positive: NEW referred in constant expression

	MODULE Test;
	CONST Referrer = NEW;
	END Test.

positive: ODD referred in constant expression

	MODULE Test;
	CONST Referrer = ODD;
	END Test.

positive: ORD referred in constant expression

	MODULE Test;
	CONST Referrer = ORD;
	END Test.

positive: PTR referred in constant expression

	MODULE Test;
	CONST Referrer = PTR;
	END Test.

positive: REAL referred in constant expression

	MODULE Test;
	CONST Referrer = REAL;
	END Test.

positive: REAL32 referred in constant expression

	MODULE Test;
	CONST Referrer = REAL32;
	END Test.

positive: REAL64 referred in constant expression

	MODULE Test;
	CONST Referrer = REAL64;
	END Test.

positive: SEL referred in constant expression

	MODULE Test;
	CONST Referrer = SEL;
	END Test.

positive: SET referred in constant expression

	MODULE Test;
	CONST Referrer = SET;
	END Test.

positive: SET8 referred in constant expression

	MODULE Test;
	CONST Referrer = SET8;
	END Test.

positive: SET16 referred in constant expression

	MODULE Test;
	CONST Referrer = SET16;
	END Test.

positive: SET32 referred in constant expression

	MODULE Test;
	CONST Referrer = SET32;
	END Test.

positive: SET64 referred in constant expression

	MODULE Test;
	CONST Referrer = SET64;
	END Test.

positive: SHORT referred in constant expression

	MODULE Test;
	CONST Referrer = SHORT;
	END Test.

positive: SHORTCARD referred in constant expression

	MODULE Test;
	CONST Referrer = SHORTCARD;
	END Test.

positive: SHORTCOMPLEX referred in constant expression

	MODULE Test;
	CONST Referrer = SHORTCOMPLEX;
	END Test.

positive: SHORTINT referred in constant expression

	MODULE Test;
	CONST Referrer = SHORTINT;
	END Test.

positive: SHORTREAL referred in constant expression

	MODULE Test;
	CONST Referrer = SHORTREAL;
	END Test.

positive: SHORTSET referred in constant expression

	MODULE Test;
	CONST Referrer = SHORTSET;
	END Test.

positive: SIGNED8 referred in constant expression

	MODULE Test;
	CONST Referrer = SIGNED8;
	END Test.

positive: SIGNED16 referred in constant expression

	MODULE Test;
	CONST Referrer = SIGNED16;
	END Test.

positive: SIGNED32 referred in constant expression

	MODULE Test;
	CONST Referrer = SIGNED32;
	END Test.

positive: SIGNED64 referred in constant expression

	MODULE Test;
	CONST Referrer = SIGNED64;
	END Test.

positive: SIZE referred in constant expression

	MODULE Test;
	CONST Referrer = SIZE;
	END Test.

positive: TRACE referred in constant expression

	MODULE Test;
	CONST Referrer = TRACE;
	END Test.

positive: UNSIGNED8 referred in constant expression

	MODULE Test;
	CONST Referrer = UNSIGNED8;
	END Test.

positive: UNSIGNED16 referred in constant expression

	MODULE Test;
	CONST Referrer = UNSIGNED16;
	END Test.

positive: UNSIGNED32 referred in constant expression

	MODULE Test;
	CONST Referrer = UNSIGNED32;
	END Test.

positive: UNSIGNED64 referred in constant expression

	MODULE Test;
	CONST Referrer = UNSIGNED64;
	END Test.

positive: type referred in constant expression

	MODULE Test;
	TYPE Type = RECORD END;
	CONST Referrer = Type;
	END Test.

# 6.1 Basic types

positive: positive infinity

	MODULE Test;
	VAR real: REAL;
	BEGIN real := INF;
	END Test.

positive: quiet not a number

	MODULE Test;
	VAR real: REAL;
	BEGIN real := NAN;
	END Test.

positive: basic SIGNED8 type

	MODULE Test;
	TYPE Type = SIGNED8;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic SIGNED16 type

	MODULE Test;
	TYPE Type = SIGNED16;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic SIGNED32 type

	MODULE Test;
	TYPE Type = SIGNED32;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic SIGNED64 type

	MODULE Test;
	TYPE Type = SIGNED64;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic UNSIGNED8 type

	MODULE Test;
	TYPE Type = UNSIGNED8;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic UNSIGNED16 type

	MODULE Test;
	TYPE Type = UNSIGNED16;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic UNSIGNED32 type

	MODULE Test;
	TYPE Type = UNSIGNED32;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic UNSIGNED64 type

	MODULE Test;
	TYPE Type = UNSIGNED64;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic REAL32 type

	MODULE Test;
	TYPE Type = REAL32;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic REAL64 type

	MODULE Test;
	TYPE Type = REAL64;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: platform-independent numeric type hierarchy

	MODULE Test;
	VAR real64: REAL64; real32: REAL32; unsigned64: UNSIGNED64; signed64: SIGNED64; unsigned32: UNSIGNED32; signed32: UNSIGNED32; unsigned16: UNSIGNED16; signed16: SIGNED16; unsigned8: UNSIGNED8; signed8: SIGNED8;
	BEGIN real64 := real32; real32 := unsigned64; unsigned64 := signed64; signed64 := unsigned32; unsigned32 := signed32; signed32 := unsigned16; unsigned16 := signed16; signed16 := unsigned8; unsigned8 := signed8;
	END Test.

positive: basic HUGEINT type

	MODULE Test;
	TYPE Type = HUGEINT;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic SHORTCARD type

	MODULE Test;
	TYPE Type = SHORTCARD;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic CARDINAL type

	MODULE Test;
	TYPE Type = CARDINAL;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic LONGCARD type

	MODULE Test;
	TYPE Type = LONGCARD;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic HUGECARD type

	MODULE Test;
	TYPE Type = HUGECARD;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic SHORTREAL type

	MODULE Test;
	TYPE Type = SHORTREAL;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic SHORTCOMPLEX type

	MODULE Test;
	TYPE Type = SHORTCOMPLEX;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic COMPLEX type

	MODULE Test;
	TYPE Type = COMPLEX;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: basic LONGCOMPLEX type

	MODULE Test;
	TYPE Type = LONGCOMPLEX;
	VAR variable: Type;
	BEGIN
		variable := MIN (Type);
		variable := MAX (Type);
	END Test.

positive: extended numeric type hierarchy

	MODULE Test;
	VAR longcomplex: LONGCOMPLEX; complex: COMPLEX; shortcomplex: SHORTCOMPLEX; real: REAL; shortreal: SHORTREAL; hugecard: HUGECARD; longcard: LONGCARD; cardinal: CARDINAL; shortcard: SHORTCARD; hugeint: HUGEINT; longint: LONGINT; integer: INTEGER; shortint: SHORTINT;
	BEGIN longcomplex := complex; complex := shortcomplex; complex := real; shortcomplex := shortreal; real := shortreal; shortreal := hugecard; hugecard := hugeint; hugecard := longcard; hugeint := longint; longcard := longint; longcard := cardinal; cardinal := integer; cardinal := shortcard; shortcard := shortint;
	END Test.

positive: basic SET8 type

	MODULE Test;
	TYPE Type = SET8;
	VAR variable: Type;
	BEGIN
		variable := {};
		variable := {MIN (Type) .. MAX (Type)};
	END Test.

positive: basic SET16 type

	MODULE Test;
	TYPE Type = SET16;
	VAR variable: Type;
	BEGIN
		variable := {};
		variable := {MIN (Type) .. MAX (Type)};
	END Test.

positive: basic SET32 type

	MODULE Test;
	TYPE Type = SET32;
	VAR variable: Type;
	BEGIN
		variable := {};
		variable := {MIN (Type) .. MAX (Type)};
	END Test.

positive: basic SET64 type

	MODULE Test;
	TYPE Type = SET64;
	VAR variable: Type;
	BEGIN
		variable := {};
		variable := {MIN (Type) .. MAX (Type)};
	END Test.

positive: platform-independent set type hierarchy

	MODULE Test;
	VAR set64: SET64; set32: SET32; set16: SET16; set8: SET8;
	BEGIN set64 := set32; set32 := set16; set16 := set8;
	END Test.

positive: basic SHORTSET type

	MODULE Test;
	TYPE Type = SHORTSET;
	VAR variable: Type;
	BEGIN
		variable := {};
		variable := {MIN (Type) .. MAX (Type)};
	END Test.

positive: basic LONGSET type

	MODULE Test;
	TYPE Type = LONGSET;
	VAR variable: Type;
	BEGIN
		variable := {};
		variable := {MIN (Type) .. MAX (Type)};
	END Test.

positive: basic HUGESET type

	MODULE Test;
	TYPE Type = HUGESET;
	VAR variable: Type;
	BEGIN
		variable := {};
		variable := {MIN (Type) .. MAX (Type)};
	END Test.

positive: extended set type hierarchy

	MODULE Test;
	VAR hugeset: HUGESET; longset: LONGSET; set: SET; shortset: SHORTSET;
	BEGIN hugeset := longset; longset := set; set := shortset;
	END Test.

positive: size of BOOLEAN type

	MODULE Test;
	BEGIN ASSERT (SIZE (BOOLEAN) = 1);
	END Test.

positive: size of CHAR type

	MODULE Test;
	BEGIN ASSERT (SIZE (CHAR) = 1);
	END Test.

positive: size of SIGNED8 type

	MODULE Test;
	BEGIN ASSERT (SIZE (SIGNED8) = 1);
	END Test.

positive: size of SIGNED16 type

	MODULE Test;
	BEGIN ASSERT (SIZE (SIGNED16) = 2);
	END Test.

positive: size of SIGNED32 type

	MODULE Test;
	BEGIN ASSERT (SIZE (SIGNED32) = 4);
	END Test.

positive: size of SIGNED64 type

	MODULE Test;
	BEGIN ASSERT (SIZE (SIGNED64) = 8);
	END Test.

positive: size of SHORTINT type

	MODULE Test;
	BEGIN ASSERT (SIZE (SHORTINT) = 2);
	END Test.

positive: size of INTEGER type

	MODULE Test;
	BEGIN ASSERT ((SIZE (INTEGER) = 2) OR (SIZE (INTEGER) = 4));
	END Test.

positive: size of LONGINT type

	MODULE Test;
	BEGIN ASSERT (SIZE (LONGINT) = 4);
	END Test.

positive: size of HUGEINT type

	MODULE Test;
	BEGIN ASSERT (SIZE (HUGEINT) = 8);
	END Test.

positive: size of LENGTH type

	MODULE Test;
	BEGIN ASSERT ((SIZE (INTEGER) = 2) OR (SIZE (INTEGER) = 4) OR (SIZE (INTEGER) = 8));
	END Test.

positive: size of UNSIGNED8 type

	MODULE Test;
	BEGIN ASSERT (SIZE (UNSIGNED8) = 1);
	END Test.

positive: size of UNSIGNED16 type

	MODULE Test;
	BEGIN ASSERT (SIZE (UNSIGNED16) = 2);
	END Test.

positive: size of UNSIGNED32 type

	MODULE Test;
	BEGIN ASSERT (SIZE (UNSIGNED32) = 4);
	END Test.

positive: size of UNSIGNED64 type

	MODULE Test;
	BEGIN ASSERT (SIZE (UNSIGNED64) = 8);
	END Test.

positive: size of SHORTCARD type

	MODULE Test;
	BEGIN ASSERT (SIZE (SHORTCARD) = 2);
	END Test.

positive: size of CARDINAL type

	MODULE Test;
	BEGIN ASSERT ((SIZE (CARDINAL) = 2) OR (SIZE (CARDINAL) = 4));
	END Test.

positive: size of LONGCARD type

	MODULE Test;
	BEGIN ASSERT (SIZE (LONGCARD) = 4);
	END Test.

positive: size of HUGECARD type

	MODULE Test;
	BEGIN ASSERT (SIZE (HUGECARD) = 8);
	END Test.

positive: size of REAL32 type

	MODULE Test;
	BEGIN ASSERT (SIZE (REAL32) = 4);
	END Test.

positive: size of REAL64 type

	MODULE Test;
	BEGIN ASSERT (SIZE (REAL64) = 8);
	END Test.

positive: size of SHORTREAL type

	MODULE Test;
	BEGIN ASSERT (SIZE (SHORTREAL) = 4);
	END Test.

positive: size of REAL type

	MODULE Test;
	BEGIN ASSERT ((SIZE (REAL) = 4) OR (SIZE (REAL) = 8));
	END Test.

positive: size of LONGREAL type

	MODULE Test;
	BEGIN ASSERT (SIZE (LONGREAL) = 8);
	END Test.

positive: size of COMPLEX32 type

	MODULE Test;
	BEGIN ASSERT (SIZE (COMPLEX32) = 8);
	END Test.

positive: size of COMPLEX64 type

	MODULE Test;
	BEGIN ASSERT (SIZE (COMPLEX64) = 16);
	END Test.

positive: size of SHORTCOMPLEX type

	MODULE Test;
	BEGIN ASSERT (SIZE (SHORTCOMPLEX) = 8);
	END Test.

positive: size of COMPLEX type

	MODULE Test;
	BEGIN ASSERT ((SIZE (COMPLEX) = 8) OR (SIZE (COMPLEX) = 16));
	END Test.

positive: size of LONGCOMPLEX type

	MODULE Test;
	BEGIN ASSERT (SIZE (LONGCOMPLEX) = 16);
	END Test.

positive: size of SET8 type

	MODULE Test;
	BEGIN ASSERT (SIZE (SET8) = 1);
	END Test.

positive: size of SET16 type

	MODULE Test;
	BEGIN ASSERT (SIZE (SET16) = 2);
	END Test.

positive: size of SET32 type

	MODULE Test;
	BEGIN ASSERT (SIZE (SET32) = 4);
	END Test.

positive: size of SET64 type

	MODULE Test;
	BEGIN ASSERT (SIZE (SET64) = 8);
	END Test.

positive: size of SHORTSET type

	MODULE Test;
	BEGIN ASSERT (SIZE (SHORTSET) = 2);
	END Test.

positive: size of SET type

	MODULE Test;
	BEGIN ASSERT ((SIZE (SET) = 2) OR (SIZE (SET) = 4));
	END Test.

positive: size of LONGSET type

	MODULE Test;
	BEGIN ASSERT (SIZE (LONGSET) = 4);
	END Test.

positive: size of HUGESET type

	MODULE Test;
	BEGIN ASSERT (SIZE (HUGESET) = 8);
	END Test.

# 6.3 Record types

positive: abstract record type

	MODULE Test;
	TYPE Type = RECORD* END;
	END Test.

negative: anonymous abstract record

	MODULE Test;
	VAR variable: RECORD* END;
	END Test.

positive: extended abstract record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD* (Base) END;
	END Test.

positive: extending abstract record type

	MODULE Test;
	TYPE Base = RECORD* END;
	TYPE Type = RECORD (Base) END;
	END Test.

negative: allocating abstract record

	MODULE Test;
	TYPE Type = RECORD* END;
	VAR pointer: POINTER TO Type;
	BEGIN NEW (pointer);
	END Test.

positive: allocating extended abstract record

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Extension = RECORD (Type) END;
	VAR pointer: POINTER TO Extension;
	BEGIN NEW (pointer);
	END Test.

negative: using abstract record as array element

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Array = ARRAY OF Type;
	END Test.

positive: using extended abstract record as array element

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Extension = RECORD (Type) END;
	TYPE Array = ARRAY OF Extension;
	END Test.

negative: using abstract record as two-dimensional array element

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Array = ARRAY OF ARRAY OF Type;
	END Test.

positive: using extended abstract record as two-dimensional array element

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Extension = RECORD (Type) END;
	TYPE Array = ARRAY OF ARRAY OF Extension;
	END Test.

negative: using abstract record as variable

	MODULE Test;
	TYPE Type = RECORD* END;
	VAR variable: Type;
	END Test.

positive: using extended abstract record as variable

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Extension = RECORD (Type) END;
	VAR variable: Extension;
	END Test.

negative: using abstract record as value parameter

	MODULE Test;
	TYPE Type = RECORD* END;
	PROCEDURE Procedure (parameter: Type);
	END Procedure;
	END Test.

positive: using extended abstract record as value parameter

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Extension = RECORD (Type) END;
	PROCEDURE Procedure (parameter: Extension);
	END Procedure;
	END Test.

positive: using abstract record as variable parameter

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Extension = RECORD (Type) END;
	PROCEDURE Procedure (VAR parameter: Extension);
	END Procedure;
	END Test.

positive: using extended abstract record as variable parameter

	MODULE Test;
	TYPE Type = RECORD* END;
	PROCEDURE Procedure (VAR parameter: Type);
	END Procedure;
	END Test.

negative: using abstract record as function result

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Procedure = PROCEDURE (): Type;
	END Test.

positive: using extended abstract record as function result

	MODULE Test;
	TYPE Type = RECORD* END;
	TYPE Extension = RECORD (Type) END;
	TYPE Procedure = PROCEDURE (): Extension;
	END Test.

positive: final record type

	MODULE Test;
	TYPE Type = RECORD- END;
	END Test.

positive: anonymous final record

	MODULE Test;
	VAR variable: RECORD- END;
	END Test.

positive: extended final record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD- (Base) END;
	END Test.

negative: extending final record type

	MODULE Test;
	TYPE Base = RECORD- END;
	TYPE Type = RECORD (Base) END;
	END Test.

# 6.4 Pointer types

positive: variable pointer type

	MODULE Test;
	TYPE Type = POINTER TO VAR RECORD END;
	END Test.

positive: read-only pointer type

	MODULE Test;
	TYPE Type = POINTER TO - RECORD END;
	END Test.

positive: assigning pointer type to pointer type

	MODULE Test;
	TYPE R = RECORD END;
	VAR p: POINTER TO R;
	BEGIN p := p;
	END Test.

negative: assigning pointer type to variable pointer type

	MODULE Test;
	TYPE R = RECORD END;
	VAR p: POINTER TO R;
	VAR r: POINTER TO VAR R;
	BEGIN r := p;
	END Test.

negative: assigning variable pointer type to pointer type

	MODULE Test;
	TYPE R = RECORD END;
	VAR p: POINTER TO R;
	VAR r: POINTER TO VAR R;
	BEGIN p := r;
	END Test.

positive: assigning variable pointer type to variable pointer type

	MODULE Test;
	TYPE R = RECORD END;
	VAR r: POINTER TO VAR R;
	BEGIN r := r;
	END Test.

positive: assigning pointer type to read-only pointer type

	MODULE Test;
	TYPE R = RECORD END;
	VAR p: POINTER TO R;
	VAR r: POINTER TO - R;
	BEGIN r := p;
	END Test.

negative: assigning read-only pointer type to pointer type

	MODULE Test;
	TYPE R = RECORD END;
	VAR p: POINTER TO R;
	VAR r: POINTER TO - R;
	BEGIN p := r;
	END Test.

positive: assigning read-only pointer type to read-only pointer type

	MODULE Test;
	TYPE R = RECORD END;
	VAR r: POINTER TO - R;
	BEGIN r := r;
	END Test.

positive: reading read-only referenced variable

	MODULE Test;
	VAR p: POINTER TO - ARRAY 10 OF CHAR; c: CHAR;
	BEGIN c := p[0];
	END Test.

negative: writing read-only referenced variable

	MODULE Test;
	VAR p: POINTER TO - ARRAY 10 OF CHAR; c: CHAR;
	BEGIN p[0] := c;
	END Test.

# 6.5 Procedure types

positive: assigning procedure with same read-only parameter type

	MODULE Test;
	VAR procedure: PROCEDURE (parameter-: CHAR);
	PROCEDURE Procedure (parameter-: CHAR);
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

negative: assigning procedure with different read-only parameter type

	MODULE Test;
	VAR procedure: PROCEDURE (parameter-: CHAR);
	PROCEDURE Procedure (parameter: CHAR);
	END Procedure;
	BEGIN procedure := Procedure;
	END Test.

# 7. Variable declarations

positive: forward declaration

	MODULE Test;
	VAR ^ variable : INTEGER;
	VAR variable : INTEGER;
	END Test.

negative: forward declaration missing VAR

	MODULE Test;
	^ variable : INTEGER;
	VAR variable : INTEGER;
	END Test.

negative: forward declaration missing ^

	MODULE Test;
	VAR variable : INTEGER;
	VAR variable : INTEGER;
	END Test.

negative: forward declaration missing identifier

	MODULE Test;
	VAR ^ : INTEGER;
	VAR variable : INTEGER;
	END Test.

negative: forward declaration missing colon

	MODULE Test;
	VAR ^ variable INTEGER;
	VAR variable : INTEGER;
	END Test.

negative: forward declaration missing type

	MODULE Test;
	VAR ^ variable : ;
	VAR variable : INTEGER;
	END Test.

negative: forward declaration missing semicolon

	MODULE Test;
	VAR ^ variable : INTEGER
	VAR variable : INTEGER;
	END Test.

negative: undeclared forward declaration

	MODULE Test;
	VAR ^ variable : INTEGER;
	END Test.

positive: duplicated forward declaration

	MODULE Test;
	VAR ^ variable : INTEGER;
	VAR ^ variable : INTEGER;
	VAR variable : INTEGER;
	END Test.

positive: forward declaration before variable declaration

	MODULE Test;
	VAR ^ variable : INTEGER;
	VAR variable : INTEGER;
	END Test.

negative: forward declaration after variable declaration

	MODULE Test;
	VAR variable : INTEGER;
	VAR ^ variable : INTEGER;
	END Test.

negative: undeclared nested forward declaration

	MODULE Test;
	PROCEDURE Procedure;
	VAR ^ variable : INTEGER;
	END Procedure;
	END Test.

positive: duplicated nested forward declaration

	MODULE Test;
	PROCEDURE Procedure;
	VAR ^ variable : INTEGER;
	VAR ^ variable : INTEGER;
	VAR variable : INTEGER;
	END Procedure;
	END Test.

positive: nested forward declaration before variable declaration

	MODULE Test;
	PROCEDURE Procedure;
	VAR ^ variable : INTEGER;
	VAR variable : INTEGER;
	END Procedure;
	END Test.

negative: nested forward declaration after variable declaration

	MODULE Test;
	PROCEDURE Procedure;
	VAR variable : INTEGER;
	VAR ^ variable : INTEGER;
	END Procedure;
	END Test.

positive: forward declaration with same type

	MODULE Test;
	VAR ^ variable : INTEGER;
	VAR variable : INTEGER;
	END Test.

negative: forward declaration with different type

	MODULE Test;
	VAR ^ variable : INTEGER;
	VAR variable : CHAR;
	END Test.

# 8.1 Operands

positive: module designator referring to imported module

	MODULE Test;
	IMPORT Import;
	CONST Module = Import;
	CONST Constant = Module.ExportedConstant;
	END Test.

# 8.2 Operators

positive: boolean conversion

	MODULE Test;
	TYPE Type = BOOLEAN;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

positive: character conversion

	MODULE Test;
	TYPE Type = CHAR;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

positive: integer conversion

	MODULE Test;
	TYPE Type = INTEGER;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

positive: real conversion

	MODULE Test;
	TYPE Type = REAL;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

positive: set conversion

	MODULE Test;
	TYPE Type = SET;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

negative: array conversion

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

negative: record conversion

	MODULE Test;
	TYPE Type = RECORD END;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

negative: pointer to array conversion

	MODULE Test;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

negative: pointer to record conversion

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

negative: procedure conversion

	MODULE Test;
	TYPE Type = PROCEDURE;
	VAR value: Type;
	BEGIN value := Type (0);
	END Test.

positive: boolean to boolean conversion

	MODULE Test;
	CONST Result = BOOLEAN (TRUE);
	BEGIN ASSERT (Result = TRUE);
	END Test.

positive: boolean to character conversion

	MODULE Test;
	CONST Result = CHAR (TRUE);
	BEGIN ASSERT (Result = 1X);
	END Test.

positive: boolean to integer conversion

	MODULE Test;
	CONST Result = INTEGER (TRUE);
	BEGIN ASSERT (Result = 1);
	END Test.

positive: boolean to real conversion

	MODULE Test;
	CONST Result = REAL (TRUE);
	BEGIN ASSERT (Result = 1.);
	END Test.

positive: boolean to set conversion

	MODULE Test;
	CONST Result = SET (TRUE);
	BEGIN ASSERT (Result = {0});
	END Test.

positive: character to boolean conversion

	MODULE Test;
	CONST Result = BOOLEAN (1X);
	BEGIN ASSERT (Result = TRUE);
	END Test.

positive: character to character conversion

	MODULE Test;
	CONST Result = CHAR (3X);
	BEGIN ASSERT (Result = 3X);
	END Test.

positive: character to integer conversion

	MODULE Test;
	CONST Result = INTEGER (5X);
	BEGIN ASSERT (Result = 5);
	END Test.

positive: character to real conversion

	MODULE Test;
	CONST Result = REAL (8X);
	BEGIN ASSERT (Result = 8.);
	END Test.

positive: character to set conversion

	MODULE Test;
	CONST Result = SET (5X);
	BEGIN ASSERT (Result = {0, 2});
	END Test.

positive: integer to boolean conversion

	MODULE Test;
	CONST Result = BOOLEAN (0);
	BEGIN ASSERT (Result = FALSE);
	END Test.

positive: integer to character conversion

	MODULE Test;
	CONST Result = CHAR (3);
	BEGIN ASSERT (Result = 3X);
	END Test.

positive: integer to integer conversion

	MODULE Test;
	CONST Result = INTEGER (5);
	BEGIN ASSERT (Result = 5);
	END Test.

positive: integer to real conversion

	MODULE Test;
	CONST Result = REAL (7);
	BEGIN ASSERT (Result = 7.);
	END Test.

positive: integer to set conversion

	MODULE Test;
	CONST Result = SET (6);
	BEGIN ASSERT (Result = {1, 2});
	END Test.

positive: real to boolean conversion

	MODULE Test;
	CONST Result = BOOLEAN (0.5);
	BEGIN ASSERT (Result = TRUE);
	END Test.

positive: real to character conversion

	MODULE Test;
	CONST Result = CHAR (2.5);
	BEGIN ASSERT (Result = 2X);
	END Test.

positive: real to integer conversion

	MODULE Test;
	CONST Result = INTEGER (-3.4);
	BEGIN ASSERT (Result = -3);
	END Test.

positive: real to real conversion

	MODULE Test;
	CONST Result = REAL (7.5);
	BEGIN ASSERT (Result = 7.5);
	END Test.

positive: real to set conversion

	MODULE Test;
	CONST Result = SET (4.5);
	BEGIN ASSERT (Result = {2});
	END Test.

positive: set to boolean conversion

	MODULE Test;
	CONST Result = BOOLEAN ({7});
	BEGIN ASSERT (Result = TRUE);
	END Test.

positive: set to character conversion

	MODULE Test;
	CONST Result = CHAR ({3});
	BEGIN ASSERT (Result = 8X);
	END Test.

positive: set to integer conversion

	MODULE Test;
	CONST Result = INTEGER ({0, 1});
	BEGIN ASSERT (Result = 3);
	END Test.

positive: set to real conversion

	MODULE Test;
	CONST Result = REAL ({1, 2});
	BEGIN ASSERT (Result = 6.);
	END Test.

positive: set to set conversion

	MODULE Test;
	CONST Result = SET ({4});
	BEGIN ASSERT (Result = {4});
	END Test.

positive: conversion using constant

	MODULE Test;
	TYPE Type = BOOLEAN;
	CONST Constant = Type;
	VAR value: Type;
	BEGIN value := Constant (0);
	END Test.

# 8.2.2 Arithmetic operators

positive: rounding of integer quotient toward zero

	MODULE Test;
	BEGIN
		ASSERT (5 DIV 2 = 2);
		ASSERT (-5 DIV 2 = -2);
	END Test.

positive: modulus with same sign as dividend

	MODULE Test;
	BEGIN
		ASSERT (5 MOD 2 = 1);
		ASSERT (-5 MOD 2 = -1);
	END Test.

positive: integer quotient and modulus example

	MODULE Test;
	BEGIN
		ASSERT (5 DIV 3 = 1); ASSERT (5 MOD 3 = 2);
		ASSERT (-5 DIV 3 = -1); ASSERT (-5 MOD 3 = -2);
	END Test.

# 8.2.3 Typed set constructors

positive: set constructor prefixed with identifier

	MODULE Test;
	CONST Constant = SET {};
	END Test.

negative: set constructor prefixed with identifier denoting import

	MODULE Test;
	IMPORT Type := SYSTEM;
	CONST Constant = Type {};
	END Test.

negative: set constructor prefixed with identifier denoting constant

	MODULE Test;
	CONST Type = 0;
	CONST Constant = Type {};
	END Test.

positive: set constructor prefixed with identifier denoting type

	MODULE Test;
	TYPE Type = SET;
	CONST Constant = Type {};
	END Test.

negative: set constructor prefixed with identifier denoting variable

	MODULE Test;
	VAR Type: INTEGER;
	CONST Constant = Type {};
	END Test.

negative: set constructor prefixed with identifier denoting procedure

	MODULE Test;
	PROCEDURE Type;
	CONST Constant = Type {};
	END Type;
	END Test.

negative: set constructor with boolean type

	MODULE Test;
	TYPE Type = BOOLEAN;
	CONST Constant = Type {};
	END Test.

negative: set constructor with character type

	MODULE Test;
	TYPE Type = CHAR;
	CONST Constant = Type {};
	END Test.

negative: set constructor with integer type

	MODULE Test;
	TYPE Type = INTEGER;
	CONST Constant = Type {};
	END Test.

negative: set constructor with real type

	MODULE Test;
	TYPE Type = REAL;
	CONST Constant = Type {};
	END Test.

positive: set constructor with set type

	MODULE Test;
	TYPE Type = SET;
	CONST Constant = Type {};
	END Test.

negative: set constructor with array type

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	CONST Constant = Type {};
	END Test.

negative: set constructor with record type

	MODULE Test;
	TYPE Type = RECORD END;
	CONST Constant = Type {};
	END Test.

negative: set constructor with pointer type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	CONST Constant = Type {};
	END Test.

negative: set constructor with procedure type

	MODULE Test;
	TYPE Type = PROCEDURE;
	CONST Constant = Type {};
	END Test.

positive: typed set constructor with SET8 type

	MODULE Test;
	TYPE Set = SET8;
	VAR set: Set;
	BEGIN set := Set {};
	END Test.

positive: typed set constructor with SET16 type

	MODULE Test;
	TYPE Set = SET16;
	VAR set: Set;
	BEGIN set := Set {};
	END Test.

positive: typed set constructor with SET32 type

	MODULE Test;
	TYPE Set = SET32;
	VAR set: Set;
	BEGIN set := Set {};
	END Test.

positive: typed set constructor with SET64 type

	MODULE Test;
	TYPE Set = SET64;
	VAR set: Set;
	BEGIN set := Set {};
	END Test.

positive: typed set constructor with SHORTSET type

	MODULE Test;
	TYPE Set = SHORTSET;
	VAR set: Set;
	BEGIN set := Set {};
	END Test.

positive: typed set constructor with SET type

	MODULE Test;
	TYPE Set = SET;
	VAR set: Set;
	BEGIN set := Set {};
	END Test.

positive: typed set constructor with LONGSET type

	MODULE Test;
	TYPE Set = LONGSET;
	VAR set: Set;
	BEGIN set := Set {};
	END Test.

positive: typed set constructor with HUGESET type

	MODULE Test;
	TYPE Set = HUGESET;
	VAR set: Set;
	BEGIN set := Set {};
	END Test.

positive: typed set constructor with valid element

	MODULE Test;
	CONST Constant = SET {MAX (SET)};
	END Test.

negative: typed set constructor with invalid element

	MODULE Test;
	CONST Constant = SET {MAX (SET) + 1};
	END Test.

# 8.2.4 Relations

positive: equal relation on module designators

	MODULE Test;
	IMPORT S := SYSTEM, SYSTEM;
	CONST Result = S = SYSTEM;
	BEGIN ASSERT (Result);
	END Test.

positive: eunqual relation on module designators

	MODULE Test;
	IMPORT S := SYSTEM, SYSTEM;
	CONST Result = S # SYSTEM;
	BEGIN ASSERT (~Result);
	END Test.

negative: less relation on module designators

	MODULE Test;
	IMPORT S := SYSTEM, SYSTEM;
	CONST Result = S < SYSTEM;
	END Test.

negative: less or equal relation on module designators

	MODULE Test;
	IMPORT S := SYSTEM, SYSTEM;
	CONST Result = S <= SYSTEM;
	END Test.

negative: greater relation on module designators

	MODULE Test;
	IMPORT S := SYSTEM, SYSTEM;
	CONST Result = S > SYSTEM;
	END Test.

negative: greater or equal relation on module designators

	MODULE Test;
	IMPORT S := SYSTEM, SYSTEM;
	CONST Result = S >= SYSTEM;
	END Test.

positive: type test on two types

	MODULE Test;
	CONST Result = LONGINT IS SIGNED32;
	BEGIN ASSERT (Result);
	END Test.

# 9.11 With statements

negative: with statement with duplicated type guards

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Type DO | parameter: Type DO END;
	END Procedure;
	END Test.

positive: with statement with unrelated type guards

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (VAR parameter1, parameter2: Type);
	BEGIN WITH parameter1: Type DO | parameter2: Type DO END;
	END Procedure;
	END Test.

negative: with statement with specialising type guards

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Type DO | parameter: Extension DO END;
	END Procedure;
	END Test.

positive: with statement with generalising type guards

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	PROCEDURE Procedure (VAR parameter: Type);
	BEGIN WITH parameter: Extension DO | parameter: Type DO END;
	END Procedure;
	END Test.

# 10. Procedure declarations

negative: forward declaration with unidentical read-only parameter

	MODULE Test;
	PROCEDURE ^ Procedure (parameter-: SET): CHAR;
	PROCEDURE Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

# 10.1 Formal parameters

positive: modifying variable parameter

	MODULE Test;
	PROCEDURE Procedure (VAR integer: INTEGER);
	BEGIN integer := 0;
	END Procedure;
	END Test.

negative: modifying variable read-only parameter

	MODULE Test;
	PROCEDURE Procedure (VAR integer-: INTEGER);
	BEGIN integer := 0;
	END Procedure;
	END Test.

positive: using variable declared with export mark as variable parameter

	MODULE Test;
	IMPORT Import;
	PROCEDURE Procedure (VAR parameter: INTEGER);
	END Procedure;
	BEGIN Procedure (Import.exportedVariable);
	END Test.

negative: using variable declared with read-only mark as variable parameter

	MODULE Test;
	IMPORT Import;
	PROCEDURE Procedure (VAR parameter: INTEGER);
	END Procedure;
	BEGIN Procedure (Import.readOnlyVariable);
	END Test.

positive: using variable declared with export mark as variable read-only parameter

	MODULE Test;
	IMPORT Import;
	PROCEDURE Procedure (VAR parameter-: INTEGER);
	END Procedure;
	BEGIN Procedure (Import.exportedVariable);
	END Test.

positive: using variable declared with read-only mark as variable read-only parameter

	MODULE Test;
	IMPORT Import;
	PROCEDURE Procedure (VAR parameter-: INTEGER);
	END Procedure;
	BEGIN Procedure (Import.readOnlyVariable);
	END Test.

positive: using variable parameter as variable parameter

	MODULE Test;
	PROCEDURE Procedure (VAR variable: INTEGER; readOnly-: INTEGER);
	BEGIN Procedure (variable, readOnly);
	END Procedure;
	END Test.

negative: using read-only parameter as variable parameter

	MODULE Test;
	PROCEDURE Procedure (VAR variable: INTEGER; readOnly-: INTEGER);
	BEGIN Procedure (readOnly, readOnly);
	END Procedure;
	END Test.

positive: using variable parameter as read-only parameter

	MODULE Test;
	PROCEDURE Procedure (VAR variable: INTEGER; readOnly-: INTEGER);
	BEGIN Procedure (variable, variable);
	END Procedure;
	END Test.

positive: using read-only parameter as read-only parameter

	MODULE Test;
	PROCEDURE Procedure (VAR variable: INTEGER; readOnly-: INTEGER);
	BEGIN Procedure (variable, readOnly);
	END Procedure;
	END Test.

positive: array function result type

	MODULE Test;
	TYPE Type = ARRAY 10 OF CHAR;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

negative: open array function result type

	MODULE Test;
	TYPE Type = ARRAY OF CHAR;
	PROCEDURE Procedure (): Type;
	END Procedure;
	END Test.

positive: record function result type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE Procedure (): Type;
	VAR result: Type;
	BEGIN RETURN result;
	END Procedure;
	END Test.

negative: abstract record function result type

	MODULE Test;
	TYPE Type = RECORD* END;
	PROCEDURE Procedure (): Type;
	END Procedure;
	END Test.

# 10.2 Type-bound procedures

positive: read-only receiver of record type

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE (VAR receiver-: Type) Procedure;
	END Procedure;
	END Test.

positive: read-only receiver of pointer type

	MODULE Test;
	TYPE Type = POINTER TO RECORD END;
	PROCEDURE (receiver-: Type) Procedure;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched read-only receiver of record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension-: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: redefinition of type-bound procedure with unmatched variable receiver of record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE (VAR base-: Base) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	PROCEDURE (VAR extension: Extension) Procedure (parameter: SET): CHAR;
	BEGIN RETURN 0X;
	END Procedure;
	END Test.

negative: denoting redefined abstract procedure of extended record type

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Extension = RECORD (Base) END;
	PROCEDURE* (VAR base: Base) Procedure;
	PROCEDURE (VAR extension: Extension) Procedure;
	BEGIN extension.Procedure^;
	END Procedure;
	END Test.

negative: denoting redefined type-bound procedure of pointer to extended record type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Base = POINTER TO Record;
	TYPE Extension = POINTER TO RECORD (Record) END;
	PROCEDURE* (base: Base) Procedure;
	PROCEDURE (extension: Extension) Procedure;
	BEGIN extension.Procedure^;
	END Procedure;
	END Test.

positive: calling type-bound procedure with variable receiver using variable parameter

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE (VAR record: Record) Procedure (VAR other: Record);
	BEGIN other.Procedure (other);
	END Procedure;
	END Test.

positive: calling type-bound procedure with read-only receiver using variable parameter

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE (VAR record-: Record) Procedure (VAR other: Record);
	BEGIN other.Procedure (other);
	END Procedure;
	END Test.

negative: calling type-bound procedure with variable receiver using read-only parameter

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE (VAR record: Record) Procedure (VAR other-: Record);
	BEGIN other.Procedure (record);
	END Procedure;
	END Test.

positive: calling type-bound procedure with read-only receiver using read-only parameter

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE (VAR record-: Record) Procedure (VAR other-: Record);
	BEGIN other.Procedure (record);
	END Procedure;
	END Test.

positive: abstract type-bound procedure

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE* (VAR record: Record) Procedure;
	END Test.

negative: abstract type-bound procedure of final record type

	MODULE Test;
	TYPE Record = RECORD- END;
	PROCEDURE* (VAR record: Record) Procedure;
	END Test.

negative: abstract type-bound procedure of extended record type

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Extension = RECORD- (Record) END;
	PROCEDURE* (VAR record: Extension) Procedure;
	END Test.

negative: abstract type-bound procedure of final record extension

	MODULE Test;
	TYPE Record = RECORD END;
	TYPE Extension = RECORD- (Record) END;
	PROCEDURE* (VAR record: Record) Procedure;
	END Test.

negative: abstract type-bound procedure with procedure body

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE* (VAR record: Record) Procedure;
	END Procedure;
	END Test.

negative: abstract non-type-bound procedure

	MODULE Test;
	PROCEDURE* Procedure;
	END Test.

positive: redefined abstract procedure

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD (Base) END;
	PROCEDURE* (VAR base: Base) Procedure;
	PROCEDURE (VAR type: Type) Procedure;
	END Procedure;
	END Test.

negative: redefining abstract procedure

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure;
	END Procedure;
	PROCEDURE* (VAR type: Type) Procedure;
	END Test.

positive: abstract forward declaration of abstract procedure

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE* ^ (VAR record: Record) Procedure;
	PROCEDURE* (VAR record: Record) Procedure;
	END Test.

negative: abstract forward declaration of non-abstract procedure

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE* ^ (VAR record: Record) Procedure;
	PROCEDURE (VAR record: Record) Procedure;
	END Procedure;
	END Test.

negative: non-abstract forward declaration of abstract procedure

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure;
	PROCEDURE* (VAR record: Record) Procedure;
	END Test.

negative: allocating record with abstract procedure

	MODULE Test;
	TYPE Type = RECORD END;
	VAR pointer: POINTER TO Type;
	PROCEDURE* (VAR type: Type) Procedure;
	BEGIN NEW (pointer);
	END Test.

positive: allocating record with redefined abstract procedure

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	VAR pointer: POINTER TO Extension;
	PROCEDURE* (VAR type: Type) Procedure;
	PROCEDURE (VAR type: Extension) Procedure;
	END Procedure;
	BEGIN NEW (pointer);
	END Test.

positive: allocating extension of record with redefined abstract procedure

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	TYPE Record = RECORD (Extension) END;
	VAR pointer: POINTER TO Record;
	PROCEDURE* (VAR type: Type) Procedure;
	PROCEDURE (VAR type: Extension) Procedure;
	END Procedure;
	BEGIN NEW (pointer);
	END Test.

negative: using record with abstract procedure as variable

	MODULE Test;
	TYPE Type = RECORD END;
	VAR variable: Type;
	PROCEDURE* (VAR type: Type) Procedure;
	END Test.

positive: using record with redefined abstract procedure as variable

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	VAR variable: Extension;
	PROCEDURE* (VAR type: Type) Procedure;
	PROCEDURE (VAR type: Extension) Procedure;
	END Procedure;
	END Test.

positive: using extension of record with redefined abstract procedure as variable

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	TYPE Record = RECORD (Extension) END;
	VAR variable: Record;
	PROCEDURE* (VAR type: Type) Procedure;
	PROCEDURE (VAR type: Extension) Procedure;
	END Procedure;
	END Test.

negative: using record with abstract procedure as value parameter

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE* (VAR type: Type) Procedure (parameter: Type);
	END Test.

positive: using record with redefined abstract procedure as value parameter

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	PROCEDURE* (VAR type: Type) Procedure (parameter: Extension);
	PROCEDURE (VAR type: Extension) Procedure (parameter: Extension);
	END Procedure;
	END Test.

positive: using extension of record with redefined abstract procedure as value parameter

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	TYPE Record = RECORD (Extension) END;
	PROCEDURE* (VAR type: Type) Procedure (parameter: Record);
	PROCEDURE (VAR type: Extension) Procedure (parameter: Record);
	END Procedure;
	END Test.

positive: using record with abstract procedure as variable parameter

	MODULE Test;
	TYPE Type = RECORD END;
	PROCEDURE* (VAR type: Type) Procedure (VAR parameter: Type);
	END Test.

positive: using record with redefined abstract procedure as variable parameter

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	PROCEDURE* (VAR type: Type) Procedure (VAR parameter: Extension);
	PROCEDURE (VAR type: Extension) Procedure (VAR parameter: Extension);
	END Procedure;
	END Test.

positive: using extension of record with redefined abstract procedure as variable parameter

	MODULE Test;
	TYPE Type = RECORD END;
	TYPE Extension = RECORD (Type) END;
	TYPE Record = RECORD (Extension) END;
	PROCEDURE* (VAR type: Type) Procedure (VAR parameter: Record);
	PROCEDURE (VAR type: Extension) Procedure (VAR parameter: Record);
	END Procedure;
	END Test.

positive: final type-bound procedure

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE- (VAR record: Record) Procedure;
	END Procedure;
	END Test.

negative: final non-type-bound procedure

	MODULE Test;
	PROCEDURE- Procedure;
	END Procedure;
	END Test.

negative: redefined final procedure

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD (Base) END;
	PROCEDURE- (VAR base: Base) Procedure;
	END Procedure;
	PROCEDURE (VAR type: Type) Procedure;
	END Procedure;
	END Test.

positive: redefining final procedure

	MODULE Test;
	TYPE Base = RECORD END;
	TYPE Type = RECORD (Base) END;
	PROCEDURE (VAR base: Base) Procedure;
	END Procedure;
	PROCEDURE- (VAR type: Type) Procedure;
	END Procedure;
	END Test.

positive: final forward declaration of final procedure

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE- ^ (VAR record: Record) Procedure;
	PROCEDURE- (VAR record: Record) Procedure;
	END Procedure;
	END Test.

negative: final forward declaration of non-final procedure

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE- ^ (VAR record: Record) Procedure;
	PROCEDURE (VAR record: Record) Procedure;
	END Procedure;
	END Test.

negative: non-final forward declaration of final procedure

	MODULE Test;
	TYPE Record = RECORD END;
	PROCEDURE ^ (VAR record: Record) Procedure;
	PROCEDURE- (VAR record: Record) Procedure;
	END Procedure;
	END Test.

# 10.3 Predeclared procedures

positive: pointer to boolean variable

	MODULE Test;
	TYPE Variable = BOOLEAN;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

positive: pointer to character variable

	MODULE Test;
	TYPE Variable = CHAR;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

positive: pointer to integer variable

	MODULE Test;
	TYPE Variable = INTEGER;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

positive: pointer to real variable

	MODULE Test;
	TYPE Variable = REAL;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

positive: pointer to set variable

	MODULE Test;
	TYPE Variable = SET;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

positive: pointer to array variable

	MODULE Test;
	TYPE Variable = ARRAY 10 OF CHAR;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

positive: open array pointer to array variable

	MODULE Test;
	TYPE Variable = ARRAY 10 OF CHAR;
	VAR variable: Variable; pointer: POINTER TO VAR ARRAY OF CHAR;
	BEGIN pointer := PTR (variable);
	END Test.

positive: pointer to record variable

	MODULE Test;
	TYPE Variable = RECORD END;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

positive: pointer to pointer variable

	MODULE Test;
	TYPE Variable = POINTER TO ARRAY OF CHAR;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

positive: pointer to procedure variable

	MODULE Test;
	TYPE Variable = PROCEDURE;
	VAR variable: Variable; pointer: POINTER TO VAR Variable;
	BEGIN pointer := PTR (variable);
	END Test.

negative: pointer to constant

	MODULE Test;
	VAR pointer: POINTER TO VAR INTEGER;
	BEGIN pointer := PTR (0);
	END Test.

negative: incompatible pointer to variables

	MODULE Test;
	VAR variable: BOOLEAN; pointer: POINTER TO VAR INTEGER;
	BEGIN pointer := PTR (variable);
	END Test.

positive: binary selection on boolean types

	MODULE Test;
	CONST Result = SEL (TRUE, FALSE, TRUE);
	BEGIN ASSERT (~Result);
	END Test.

positive: binary selection on character types

	MODULE Test;
	CONST Result = SEL (FALSE, 2X, 3X);
	BEGIN ASSERT (Result = 3X);
	END Test.

positive: binary selection on integer types

	MODULE Test;
	CONST Result = SEL (TRUE, 2, 5);
	BEGIN ASSERT (Result = 2);
	END Test.

positive: binary selection on real types

	MODULE Test;
	CONST Result = SEL (FALSE, 2.5, 5.5);
	BEGIN ASSERT (Result = 5.5);
	END Test.

positive: binary selection on set types

	MODULE Test;
	CONST Result = SEL (TRUE, {2}, {1});
	BEGIN ASSERT (Result = {2});
	END Test.

positive: binary selection on string types

	MODULE Test;
	CONST Result = SEL (TRUE, "first", "second");
	END Test.

positive: binary selection on nil types

	MODULE Test;
	CONST Result = SEL (TRUE, NIL, NIL);
	BEGIN ASSERT (Result = NIL);
	END Test.

negative: binary selection on array types

	MODULE Test;
	VAR a, b, c: ARRAY 10 OF CHAR;
	BEGIN a := SEL (FALSE, b, c);
	END Test.

negative: binary selection on record types

	MODULE Test;
	VAR a, b, c: RECORD END;
	BEGIN a := SEL (FALSE, b, c);
	END Test.

positive: binary selection on pointer to array types

	MODULE Test;
	VAR a, b, c: POINTER TO ARRAY 10 OF CHAR;
	BEGIN a := SEL (FALSE, b, c);
	END Test.

positive: binary selection on pointer to record types

	MODULE Test;
	VAR a, b, c: POINTER TO RECORD END;
	BEGIN a := SEL (FALSE, b, c);
	END Test.

positive: binary selection on procedure types

	MODULE Test;
	VAR a, b, c: PROCEDURE;
	BEGIN a := SEL (FALSE, b, c);
	END Test.

negative: binary selection on incompatible types

	MODULE Test;
	CONST Result = SEL (TRUE, FALSE, 0X);
	END Test.

positive: assertion with status number between 0 and 255

	MODULE Test;
	BEGIN ASSERT (TRUE, 0); ASSERT (TRUE, 255);
	END Test.

negative: assertion with status number smaller than 0

	MODULE Test;
	BEGIN ASSERT (TRUE, -1);
	END Test.

negative: assertion with status number bigger than 255

	MODULE Test;
	BEGIN ASSERT (TRUE, 256);
	END Test.

negative: deallocation of boolean variable

	MODULE Test;
	VAR variable: BOOLEAN;
	BEGIN DISPOSE (variable);
	END Test.

negative: deallocation of character variable

	MODULE Test;
	VAR variable: CHAR;
	BEGIN DISPOSE (variable);
	END Test.

negative: deallocation of integer variable

	MODULE Test;
	VAR variable: INTEGER;
	BEGIN DISPOSE (variable);
	END Test.

negative: deallocation of real variable

	MODULE Test;
	VAR variable: REAL;
	BEGIN DISPOSE (variable);
	END Test.

negative: deallocation of set variable

	MODULE Test;
	VAR variable: SET;
	BEGIN DISPOSE (variable);
	END Test.

negative: deallocation of array variable

	MODULE Test;
	VAR variable: ARRAY 10 OF CHAR;
	BEGIN DISPOSE (variable);
	END Test.

negative: deallocation of record variable

	MODULE Test;
	VAR variable: RECORD END;
	BEGIN DISPOSE (variable);
	END Test.

positive: deallocation of pointer to fixed array variable

	MODULE Test;
	VAR variable: POINTER TO ARRAY 10 OF CHAR;
	BEGIN DISPOSE (variable);
	END Test.

positive: deallocation of pointer to single open array variable

	MODULE Test;
	VAR variable: POINTER TO ARRAY OF CHAR;
	BEGIN DISPOSE (variable);
	END Test.

positive: deallocation of pointer to double open array variable

	MODULE Test;
	VAR variable: POINTER TO ARRAY OF ARRAY OF CHAR;
	BEGIN DISPOSE (variable);
	END Test.

positive: deallocation of pointer to record variable

	MODULE Test;
	VAR variable: POINTER TO RECORD END;
	BEGIN DISPOSE (variable);
	END Test.

negative: deallocation of procedure variable

	MODULE Test;
	VAR variable: PROCEDURE;
	BEGIN DISPOSE (variable);
	END Test.

positive: ignoring expressions

	MODULE Test;
	BEGIN IGNORE (TRUE); IGNORE (FALSE); IGNORE (0); IGNORE (0.0); IGNORE ({}); IGNORE (""); IGNORE (NIL);
	END Test.

negative: ignoring proper procedures

	MODULE Test;
	BEGIN IGNORE (IGNORE (0));
	END Test.

positive: ignoring function procedures

	MODULE Test;
	BEGIN IGNORE (ABS (0));
	END Test.

positive: halt with status number between 0 and 255

	MODULE Test;
	BEGIN HALT (0); HALT (255);
	END Test.

negative: halt with status number smaller than 0

	MODULE Test;
	BEGIN HALT (-1);
	END Test.

negative: halt with status number bigger than 255

	MODULE Test;
	BEGIN HALT (256);
	END Test.

positive: expression evaluation of boolean value

	MODULE Test;
	BEGIN TRACE (FALSE);
	END Test.

positive: expression evaluation of character value

	MODULE Test;
	BEGIN TRACE (20X); TRACE ('c');
	END Test.

positive: expression evaluation of integer value

	MODULE Test;
	BEGIN TRACE (25);
	END Test.

positive: expression evaluation of real value

	MODULE Test;
	BEGIN TRACE (5.25);
	END Test.

positive: expression evaluation of set value

	MODULE Test;
	BEGIN TRACE ({1, 4..7});
	END Test.

positive: expression evaluation of string value

	MODULE Test;
	BEGIN TRACE ("test");
	END Test.

positive: expression evaluation of nil value

	MODULE Test;
	BEGIN TRACE (NIL);
	END Test.

positive: expression evaluation of array of character value

	MODULE Test;
	VAR value: ARRAY 10 OF CHAR;
	BEGIN TRACE (value);
	END Test.

negative: expression evaluation of array of integer value

	MODULE Test;
	VAR value: ARRAY 10 OF INTEGER;
	BEGIN TRACE (value);
	END Test.

negative: expression evaluation of array of record

	MODULE Test;
	VAR value: ARRAY RECORD END;
	BEGIN TRACE (value);
	END Test.

positive: expression evaluation of pointer to array value

	MODULE Test;
	VAR value: POINTER TO ARRAY 10 OF INTEGER;
	BEGIN TRACE (value);
	END Test.

positive: expression evaluation of pointer to record value

	MODULE Test;
	VAR value: POINTER TO RECORD END;
	BEGIN TRACE (value);
	END Test.

positive: expression evaluation of procedure value

	MODULE Test;
	VAR value: PROCEDURE;
	BEGIN TRACE (value);
	END Test.

# 11. Modules

negative: generic module missing opening parenthesis

	MODULE Test Parameter);
	END Test.

negative: generic module missing closing parenthesis

	MODULE Test (Parameter;
	END Test.

negative: generic module missing identifier

	MODULE Test ();
	END Test.

positive: generic module with identifier without export mark

	MODULE Test (Parameter);
	END Test.

positive: generic module with identifier with export mark

	MODULE Test (Parameter*);
	END Test.

negative: generic module with identifier with read-only mark

	MODULE Test (Parameter-);
	END Test.

positive: generic module with single identifier

	MODULE Test (Parameter);
	END Test.

positive: generic module with multiple identifiers

	MODULE Test (First, Second);
	END Test.

negative: generic module with duplicated identifiers

	MODULE Test (Parameter, Parameter);
	END Test.

negative: importing generic module missing opening parenthesis

	MODULE Test;
	IMPORT Import CHAR);
	END Test.

negative: importing generic module missing closing parenthesis

	MODULE Test;
	IMPORT Import (CHAR;
	END Test.

negative: importing generic module missing parameter

	MODULE Test;
	IMPORT Import ();
	END Test.

negative: importing non-generic module with parameters

	MODULE Test;
	IMPORT Import (CHAR);
	END Test.

negative: importing system module with parameters

	MODULE Test;
	IMPORT SYSTEM (CHAR);
	END Test.

negative: importing generic module without parameters

	MODULE Test;
	IMPORT Generic;
	END Test.

negative: importing generic module with unmatched parameter count

	MODULE Test;
	IMPORT Generic (CHAR);
	END Test.

positive: importing generic module with matched parameter count

	MODULE Test;
	IMPORT Generic (CHAR, 1);
	END Test.

negative: importing generic module with invalid type parameter

	MODULE Test;
	IMPORT Generic (1, 1);
	END Test.

negative: importing generic module with invalid value parameter

	MODULE Test;
	IMPORT Generic (CHAR, CHAR);
	END Test.

negative: redeclaring constant parameter of generic module

	MODULE Test (Constant);
	CONST Constant = 0;
	END Test.

negative: redeclaring type parameter of generic module

	MODULE Test (Parameter);
	TYPE Parameter = CHAR;
	END Test.

positive: using parameters of generic module

	MODULE Test (Type, Constant);
	TYPE Array = ARRAY Constant OF Type;
	END Test.

positive: using parameter with export mark of imported generic module

	MODULE Test;
	IMPORT Generic (INTEGER, 10);
	TYPE Type = Generic.Type;
	BEGIN ASSERT (Type IS INTEGER); ASSERT (LEN (Generic.variable) = 10);
	END Test.

negative: using parameter without export mark of imported generic module

	MODULE Test;
	IMPORT Generic (INTEGER, 10);
	CONST Constant = Generic.Constant;
	END Test.

positive: using parameter with export mark of aliased imported generic module

	MODULE Test;
	IMPORT Alias := Generic (INTEGER, 10);
	TYPE Type = Alias.Type;
	BEGIN ASSERT (Type IS INTEGER); ASSERT (LEN (Alias.variable) = 10);
	END Test.

negative: using parameter without export mark of aliased imported generic module

	MODULE Test;
	IMPORT Alias := Generic (INTEGER, 10);
	CONST Constant = Alias.Constant;
	END Test.

positive: importing generic module multiple times with aliases

	MODULE Test;
	IMPORT First := Generic (INTEGER, 10), Second := Generic (INTEGER, 10), Generic (INTEGER, 10);
	END Test.

negative: importing generic module multiple times without aliases

	MODULE Test;
	IMPORT Generic (INTEGER, 10), Generic (INTEGER, 10);
	END Test.

positive: importing generic module multiple times with same parameters

	MODULE Test;
	IMPORT First := Generic (INTEGER, 10), Second := Generic (INTEGER, 10);
	BEGIN ASSERT (First.Type IS Second.Type); ASSERT (LEN (First.variable) = LEN (Second.variable));
	END Test.

positive: importing generic module multiple times with different parameters

	MODULE Test;
	IMPORT First := Generic (INTEGER, 10), Second := Generic (CHAR, 20);
	BEGIN ASSERT (~(First.Type IS Second.Type)); ASSERT (LEN (First.variable) # LEN (Second.variable));
	END Test.

positive: importing generic module with generic parameter

	MODULE Test (Value, Type);
	IMPORT Generic (Value, Type);
	END Test.

negative: module named SYSTEM

	MODULE SYSTEM;
	END SYSTEM.

positive: packaged import

	MODULE Test;
	IMPORT Packaged IN Package;
	END Test.

positive: packaged import list

	MODULE Test;
	IN Package IMPORT Packaged;
	END Test.

positive: module with import lists

	MODULE Test;
	IMPORT A := Import;
	IMPORT B := Import;
	END Test.

positive: ignored text following a module

	MODULE Test;
	END Test. This text
	is completely ignored.

# C: The module SYSTEM

positive: byte type

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Byte = SYSTEM.BYTE;
	END Test.

positive: character compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: CHAR;
	BEGIN variable := value; variable := 0X; variable := '0';
	END Test.

positive: 8-bit signed integer compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: SIGNED8;
	BEGIN variable := value; variable := 0;
	END Test.

negative: 16-bit signed integer compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: SIGNED16;
	BEGIN variable := value;
	END Test.

negative: 32-bit signed integer compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: SIGNED32;
	BEGIN variable := value;
	END Test.

negative: 64-bit signed integer compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: SIGNED64;
	BEGIN variable := value;
	END Test.

positive: 8-bit unsigned integer compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: UNSIGNED8;
	BEGIN variable := value; variable := 0;
	END Test.

negative: 16-bit unsigned integer compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: UNSIGNED16;
	BEGIN variable := value;
	END Test.

negative: 32-bit unsigned integer compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: UNSIGNED32;
	BEGIN variable := value;
	END Test.

negative: 64-bit unsigned integer compatibility with byte type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE; value: UNSIGNED64;
	BEGIN variable := value;
	END Test.

positive: boolean compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: BOOLEAN;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: character compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: CHAR;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: integer compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: INTEGER;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: real compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: REAL;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: set compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SET;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: byte compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.BYTE;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: array compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: ARRAY 10 OF CHAR;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: record compatibility with open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: RECORD END;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: pointer to array compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: POINTER TO ARRAY OF CHAR;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: pointer to record compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: POINTER TO ARRAY OF RECORD END;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: procedure compatibility with variable open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: PROCEDURE;
	PROCEDURE Procedure (VAR array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

negative: compatibility with value open array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: INTEGER;
	PROCEDURE Procedure (array: ARRAY OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

negative: compatibility with variable fixed array of byte parameter

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: INTEGER;
	PROCEDURE Procedure (VAR array: ARRAY SIZE (INTEGER) OF SYSTEM.BYTE);
	END Procedure;
	BEGIN Procedure (variable);
	END Test.

positive: any type

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Any = SYSTEM.PTR;
	END Test.

positive: pointer to array compatibility with any type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.PTR; value: POINTER TO ARRAY OF CHAR;
	BEGIN variable := value; variable := NIL;
	END Test.

positive: pointer to record compatibility with any type

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: SYSTEM.PTR; value: POINTER TO RECORD END;
	BEGIN variable := value; variable := NIL;
	END Test.

negative: omission of condition

	MODULE Test;
	IMPORT SYSTEM;
	CONST Condition = SYSTEM.CC;
	END Test.

positive: address type

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Address = SYSTEM.ADDRESS;
	BEGIN ASSERT (SIZE (Address) = SIZE (LENGTH));
	END Test.

positive: set type

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Set = SYSTEM.SET;
	BEGIN ASSERT (SIZE (Set) = SIZE (LENGTH));
	END Test.

positive: memory address of boolean variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: BOOLEAN;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of character variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: CHAR;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of integer variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: INTEGER;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of real variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: REAL;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of set variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: SET;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of array variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: ARRAY 10 OF CHAR;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of record variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: RECORD END;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of pointer to array variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: POINTER TO ARRAY OF CHAR;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of pointer to record variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: POINTER TO RECORD END;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

positive: memory address of procedure variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: PROCEDURE;
	BEGIN address := SYSTEM.ADR (variable);
	END Test.

negative: memory address of integer value

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS;
	BEGIN address := SYSTEM.ADR (0);
	END Test.

positive: memory bit using address and length

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; index: LENGTH; result: BOOLEAN;
	BEGIN result := SYSTEM.BIT (address, index);
	END Test.

negative: logical shift on boolean type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.LSH (FALSE, TRUE);
	END Test.

negative: logical shift on character type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.LSH (4X, 2X);
	END Test.

positive: logical shift on integer type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.LSH (10, -2);
	BEGIN ASSERT (Result = 2);
	END Test.

negative: logical shift on real type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.LSH (2.5, 2);
	END Test.

negative: logical shift on set type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.LSH ({3}, {1});
	END Test.

negative: rotation on boolean type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.ROT (FALSE, TRUE);
	END Test.

negative: rotation on character type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.ROT (4X, 2X);
	END Test.

positive: rotation on integer type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.ROT (10, 2);
	BEGIN ASSERT (Result = 40);
	END Test.

negative: rotation on real type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.ROT (2.5, 2);
	END Test.

negative: rotation on set type

	MODULE Test;
	IMPORT SYSTEM;
	CONST Result = SYSTEM.ROT ({3}, {1});
	END Test.

positive: boolean type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (BOOLEAN, variable) := FALSE;
	END Test.

positive: character type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (CHAR, variable) := 0X;
	END Test.

positive: integer type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (INTEGER, variable) := 0;
	END Test.

positive: real type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (REAL, variable) := 0.0;
	END Test.

positive: set type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (SET, variable) := {};
	END Test.

positive: array type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = ARRAY 10 OF CHAR;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (Type, variable)[0] := 0X;
	END Test.

negative: open array type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = ARRAY OF CHAR;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (Type, variable)[0] := 0X;
	END Test.

positive: record type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = RECORD value: CHAR END;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (Type, variable).value := 0X;
	END Test.

positive: pointer to array type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (Type, variable)[0] := 0X;
	END Test.

positive: pointer to record type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = POINTER TO RECORD value: CHAR END;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (Type, variable).value := 0X;
	END Test.

positive: procedure type interpretation of variable

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = PROCEDURE;
	VAR variable: RECORD END;
	BEGIN SYSTEM.VAL (Type, variable) := NIL;
	END Test.

positive: boolean type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = BOOLEAN;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, 0X);
	END Test.

positive: character type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = CHAR;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, 0);
	END Test.

positive: integer type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = INTEGER;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, 0.5);
	END Test.

positive: real type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = REAL;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, {});
	END Test.

positive: set type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = SET;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, 0);
	END Test.

negative: array type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = ARRAY 10 OF CHAR;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, 0);
	END Test.

negative: record type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = RECORD END;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, 0);
	END Test.

positive: pointer to record type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = POINTER TO RECORD END;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, "record");
	END Test.

positive: pointer to array type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = POINTER TO ARRAY 10 OF CHAR;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, "array");
	END Test.

positive: procedure type interpretation of value

	MODULE Test;
	IMPORT SYSTEM;
	TYPE Type = PROCEDURE;
	VAR result: Type;
	BEGIN result := SYSTEM.VAL (Type, NIL);
	END Test.

negative: omission of register read

	MODULE Test;
	IMPORT SYSTEM;
	CONST RegisterRead = SYSTEM.GETREG;
	END Test.

negative: omission of register write

	MODULE Test;
	IMPORT SYSTEM;
	CONST RegisterWrite = SYSTEM.PUTREG;
	END Test.

positive: inline assembly code

	MODULE Test;
	IMPORT SYSTEM;
	BEGIN SYSTEM.ASM ("");
	END Test.

positive: inline intermediate code

	MODULE Test;
	IMPORT SYSTEM;
	BEGIN SYSTEM.CODE ("");
	END Test.

positive: memory deallocation using pointer

	MODULE Test;
	IMPORT SYSTEM;
	VAR pointer: POINTER TO RECORD END;
	BEGIN SYSTEM.DISPOSE (pointer);
	END Test.

positive: memory deallocation using any type

	MODULE Test;
	IMPORT SYSTEM;
	VAR pointer: SYSTEM.PTR;
	BEGIN SYSTEM.DISPOSE (pointer);
	END Test.

positive: memory read of boolean variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: BOOLEAN;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

positive: memory read of character variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: CHAR;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

positive: memory read of integer variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: INTEGER;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

positive: memory read of real variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: REAL;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

positive: memory read of set variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: SET;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

negative: memory read of array variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: ARRAY 10 OF CHAR;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

negative: memory read of record variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: RECORD END;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

positive: memory read of pointer to array variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: POINTER TO ARRAY OF CHAR;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

positive: memory read of pointer to record variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: POINTER TO RECORD END;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

positive: memory read of procedure variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: PROCEDURE;
	BEGIN SYSTEM.GET (address, variable);
	END Test.

negative: memory read of integer value

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS;
	BEGIN address := SYSTEM.ADR (0);
	END Test.

positive: memory copy using addresses and length

	MODULE Test;
	IMPORT SYSTEM;
	VAR source, target: SYSTEM.ADDRESS; length: LENGTH;
	BEGIN SYSTEM.MOVE (source, target, length);
	END Test.

positive: memory write of boolean variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: BOOLEAN;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

positive: memory write of character variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: CHAR;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

positive: memory write of integer variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: INTEGER;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

positive: memory write of real variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: REAL;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

positive: memory write of set variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: SET;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

negative: memory write of array variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: ARRAY 10 OF CHAR;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

negative: memory write of record variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: RECORD END;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

positive: memory write of pointer to array variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: POINTER TO ARRAY OF CHAR;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

positive: memory write of pointer to record variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: POINTER TO RECORD END;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

positive: memory write of procedure variable

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS; variable: PROCEDURE;
	BEGIN SYSTEM.PUT (address, variable);
	END Test.

negative: memory write of integer value

	MODULE Test;
	IMPORT SYSTEM;
	VAR address: SYSTEM.ADDRESS;
	BEGIN address := SYSTEM.ADR (0);
	END Test.

positive: memory allocation using pointer and length

	MODULE Test;
	IMPORT SYSTEM;
	VAR pointer: POINTER TO RECORD END; length: LENGTH;
	BEGIN SYSTEM.NEW (pointer, length);
	END Test.

positive: memory allocation using any type and length

	MODULE Test;
	IMPORT SYSTEM;
	VAR pointer: SYSTEM.PTR; length: LENGTH;
	BEGIN SYSTEM.NEW (pointer, length);
	END Test.

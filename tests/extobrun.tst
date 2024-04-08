# Extended Oberon execution test and validation suite
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

positive: global pointer variable initialized to NIL

	MODULE Test;
	VAR pointer: POINTER TO RECORD END;
	BEGIN ASSERT (pointer = NIL);
	END Test.

positive: local pointer variable initialized to NIL

	MODULE Test;
	PROCEDURE Procedure;
	VAR pointer: POINTER TO RECORD END;
	BEGIN ASSERT (pointer = NIL);
	END Procedure;
	BEGIN Procedure;
	END Test.

positive: global pointer field initialized to NIL

	MODULE Test;
	VAR record: RECORD pointer: POINTER TO RECORD END END;
	BEGIN ASSERT (record.pointer = NIL);
	END Test.

positive: local pointer field initialized to NIL

	MODULE Test;
	PROCEDURE Procedure;
	VAR record: RECORD pointer: POINTER TO RECORD END END;
	BEGIN ASSERT (record.pointer = NIL);
	END Procedure;
	BEGIN Procedure;
	END Test.

# 8.2.2 Arithmetic operators

positive: SIGNED8 sum

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: SIGNED16 sum

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: SIGNED32 sum

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: SIGNED64 sum

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: UNSIGNED8 sum

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
	END Test.

positive: UNSIGNED16 sum

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
	END Test.

positive: UNSIGNED32 sum

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
	END Test.

positive: UNSIGNED64 sum

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
	END Test.

positive: REAL32 sum

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: REAL64 sum

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: COMPLEX32 sum

	MODULE Test;
	VAR a, b: COMPLEX32;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = 1 - 4 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = -6 + 1 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = 6 - 1 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = -1 + 4 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (2.5 + 1.5 * I));
	END Test.

positive: COMPLEX64 sum

	MODULE Test;
	VAR a, b: COMPLEX64;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = 1 - 4 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = -6 + 1 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = 6 - 1 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = -1 + 4 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (2.5 + 1.5 * I));
	END Test.

positive: HUGEINT sum

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT (a + b = +5); ASSERT (a + b = 3 + 2);
		a := -3; b := 2; ASSERT (a + b = -1); ASSERT (a + b = (-3) + 2);
		a := 3; b := -2; ASSERT (a + b = +1); ASSERT (a + b = 3 + (-2));
		a := -3; b := -2; ASSERT (a + b = -5); ASSERT (a + b = (-3) + (-2));
	END Test.

positive: SHORTREAL sum

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: SHORTCOMPLEX sum

	MODULE Test;
	VAR a, b: SHORTCOMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = 1 - 4 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = -6 + 1 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = 6 - 1 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = -1 + 4 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (2.5 + 1.5 * I));
	END Test.

positive: COMPLEX sum

	MODULE Test;
	VAR a, b: COMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = 1 - 4 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = -6 + 1 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = 6 - 1 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = -1 + 4 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (2.5 + 1.5 * I));
	END Test.

positive: LONGCOMPLEX sum

	MODULE Test;
	VAR a, b: LONGCOMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = 1 - 4 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a + b = -6 + 1 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = 6 - 1 * I); ASSERT (a + b = (3.5 - 2.5 * I) + (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a + b = -1 + 4 * I); ASSERT (a + b = (-3.5 + 2.5 * I) + (2.5 + 1.5 * I));
	END Test.

positive: SIGNED8 difference

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
		a := -3; b := 2; ASSERT (a - b = -5); ASSERT (a - b = (-3) - 2);
		a := 3; b := -2; ASSERT (a - b = +5); ASSERT (a - b = 3 - (-2));
		a := -3; b := -2; ASSERT (a - b = -1); ASSERT (a - b = (-3) - (-2));
	END Test.

positive: SIGNED16 difference

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
		a := -3; b := 2; ASSERT (a - b = -5); ASSERT (a - b = (-3) - 2);
		a := 3; b := -2; ASSERT (a - b = +5); ASSERT (a - b = 3 - (-2));
		a := -3; b := -2; ASSERT (a - b = -1); ASSERT (a - b = (-3) - (-2));
	END Test.

positive: SIGNED32 difference

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
		a := -3; b := 2; ASSERT (a - b = -5); ASSERT (a - b = (-3) - 2);
		a := 3; b := -2; ASSERT (a - b = +5); ASSERT (a - b = 3 - (-2));
		a := -3; b := -2; ASSERT (a - b = -1); ASSERT (a - b = (-3) - (-2));
	END Test.

positive: SIGNED64 difference

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
		a := -3; b := 2; ASSERT (a - b = -5); ASSERT (a - b = (-3) - 2);
		a := 3; b := -2; ASSERT (a - b = +5); ASSERT (a - b = 3 - (-2));
		a := -3; b := -2; ASSERT (a - b = -1); ASSERT (a - b = (-3) - (-2));
	END Test.

positive: UNSIGNED8 difference

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
	END Test.

positive: UNSIGNED16 difference

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
	END Test.

positive: UNSIGNED32 difference

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
	END Test.

positive: UNSIGNED64 difference

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
	END Test.

positive: REAL32 difference

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: REAL64 difference

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: COMPLEX32 difference

	MODULE Test;
	VAR a, b: COMPLEX32;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = 6 - 1 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = -1 + 4 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = 1 - 4 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = -6 + 1 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (2.5 + 1.5 * I));
	END Test.

positive: COMPLEX64 difference

	MODULE Test;
	VAR a, b: COMPLEX64;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = 6 - 1 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = -1 + 4 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = 1 - 4 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = -6 + 1 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (2.5 + 1.5 * I));
	END Test.

positive: HUGEINT difference

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT (a - b = +1); ASSERT (a - b = 3 - 2);
		a := -3; b := 2; ASSERT (a - b = -5); ASSERT (a - b = (-3) - 2);
		a := 3; b := -2; ASSERT (a - b = +5); ASSERT (a - b = 3 - (-2));
		a := -3; b := -2; ASSERT (a - b = -1); ASSERT (a - b = (-3) - (-2));
	END Test.

positive: SHORTREAL difference

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a + b = +6); ASSERT (a + b = 3.5 + 2.5);
		a := -3.5; b := 2.5; ASSERT (a + b = -1); ASSERT (a + b = (-3.5) + 2.5);
		a := 3.5; b := -2.5; ASSERT (a + b = +1); ASSERT (a + b = 3.5 + (-2.5));
		a := -3.5; b := -2.5; ASSERT (a + b = -6); ASSERT (a + b = (-3.5) + (-2.5));
	END Test.

positive: SHORTCOMPLEX difference

	MODULE Test;
	VAR a, b: SHORTCOMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = 6 - 1 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = -1 + 4 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = 1 - 4 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = -6 + 1 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (2.5 + 1.5 * I));
	END Test.

positive: COMPLEX difference

	MODULE Test;
	VAR a, b: COMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = 6 - 1 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = -1 + 4 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = 1 - 4 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = -6 + 1 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (2.5 + 1.5 * I));
	END Test.

positive: LONGCOMPLEX difference

	MODULE Test;
	VAR a, b: LONGCOMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = 6 - 1 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a - b = -1 + 4 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = 1 - 4 * I); ASSERT (a - b = (3.5 - 2.5 * I) - (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a - b = -6 + 1 * I); ASSERT (a - b = (-3.5 + 2.5 * I) - (2.5 + 1.5 * I));
	END Test.

positive: SIGNED8 product

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
		a := -3; b := 2; ASSERT (a * b = -6); ASSERT (a * b = (-3) * 2);
		a := 3; b := -2; ASSERT (a * b = -6); ASSERT (a * b = 3 * (-2));
		a := -3; b := -2; ASSERT (a * b = +6); ASSERT (a * b = (-3) * (-2));
	END Test.

positive: SIGNED16 product

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
		a := -3; b := 2; ASSERT (a * b = -6); ASSERT (a * b = (-3) * 2);
		a := 3; b := -2; ASSERT (a * b = -6); ASSERT (a * b = 3 * (-2));
		a := -3; b := -2; ASSERT (a * b = +6); ASSERT (a * b = (-3) * (-2));
	END Test.

positive: SIGNED32 product

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
		a := -3; b := 2; ASSERT (a * b = -6); ASSERT (a * b = (-3) * 2);
		a := 3; b := -2; ASSERT (a * b = -6); ASSERT (a * b = 3 * (-2));
		a := -3; b := -2; ASSERT (a * b = +6); ASSERT (a * b = (-3) * (-2));
	END Test.

positive: SIGNED64 product

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
		a := -3; b := 2; ASSERT (a * b = -6); ASSERT (a * b = (-3) * 2);
		a := 3; b := -2; ASSERT (a * b = -6); ASSERT (a * b = 3 * (-2));
		a := -3; b := -2; ASSERT (a * b = +6); ASSERT (a * b = (-3) * (-2));
	END Test.

positive: UNSIGNED8 product

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
	END Test.

positive: UNSIGNED16 product

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
	END Test.

positive: UNSIGNED32 product

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
	END Test.

positive: UNSIGNED64 product

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
	END Test.

positive: REAL32 product

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a * b = +8.75); ASSERT (a * b = 3.5 * 2.5);
		a := -3.5; b := 2.5; ASSERT (a * b = -8.75); ASSERT (a * b = (-3.5) * 2.5);
		a := 3.5; b := -2.5; ASSERT (a * b = -8.75); ASSERT (a * b = 3.5 * (-2.5));
		a := -3.5; b := -2.5; ASSERT (a * b = +8.75); ASSERT (a * b = (-3.5) * (-2.5));
	END Test.

positive: REAL64 product

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a * b = +8.75); ASSERT (a * b = 3.5 * 2.5);
		a := -3.5; b := 2.5; ASSERT (a * b = -8.75); ASSERT (a * b = (-3.5) * 2.5);
		a := 3.5; b := -2.5; ASSERT (a * b = -8.75); ASSERT (a * b = 3.5 * (-2.5));
		a := -3.5; b := -2.5; ASSERT (a * b = +8.75); ASSERT (a * b = (-3.5) * (-2.5));
	END Test.

positive: COMPLEX32 product

	MODULE Test;
	VAR a, b: COMPLEX32;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (2.5 + 1.5 * I));
	END Test.

positive: COMPLEX64 product

	MODULE Test;
	VAR a, b: COMPLEX64;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (2.5 + 1.5 * I));
	END Test.

positive: HUGEINT product

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT (a * b = +6); ASSERT (a * b = 3 * 2);
		a := -3; b := 2; ASSERT (a * b = -6); ASSERT (a * b = (-3) * 2);
		a := 3; b := -2; ASSERT (a * b = -6); ASSERT (a * b = 3 * (-2));
		a := -3; b := -2; ASSERT (a * b = +6); ASSERT (a * b = (-3) * (-2));
	END Test.

positive: SHORTREAL product

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT (a * b = +8.75); ASSERT (a * b = 3.5 * 2.5);
		a := -3.5; b := 2.5; ASSERT (a * b = -8.75); ASSERT (a * b = (-3.5) * 2.5);
		a := 3.5; b := -2.5; ASSERT (a * b = -8.75); ASSERT (a * b = 3.5 * (-2.5));
		a := -3.5; b := -2.5; ASSERT (a * b = +8.75); ASSERT (a * b = (-3.5) * (-2.5));
	END Test.

positive: SHORTCOMPLEX product

	MODULE Test;
	VAR a, b: SHORTCOMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (2.5 + 1.5 * I));
	END Test.

positive: COMPLEX product

	MODULE Test;
	VAR a, b: COMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (2.5 + 1.5 * I));
	END Test.

positive: LONGCOMPLEX product

	MODULE Test;
	VAR a, b: LONGCOMPLEX;
	BEGIN
		a := 3.5 - 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (-2.5 - 1.5 * I));
		a := -3.5 + 2.5 * I; b := -2.5 - 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (-2.5 - 1.5 * I));
		a := 3.5 - 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = 12.5 - 1 * I); ASSERT (a * b = (3.5 - 2.5 * I) * (2.5 + 1.5 * I));
		a := -3.5 + 2.5 * I; b := 2.5 + 1.5 * I; ASSERT (a * b = -12.5 + 1 * I); ASSERT (a * b = (-3.5 + 2.5 * I) * (2.5 + 1.5 * I));
	END Test.

positive: SIGNED8 real quotient

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: SIGNED16 real quotient

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: SIGNED32 real quotient

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: SIGNED64 real quotient

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: UNSIGNED8 real quotient

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: UNSIGNED16 real quotient

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: UNSIGNED32 real quotient

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: UNSIGNED64 real quotient

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: REAL32 real quotient

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: REAL64 real quotient

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: COMPLEX32 real quotient

	MODULE Test;
	VAR a, b: COMPLEX32;
	BEGIN a := 3 + 2 * I; b := 1 - 1 * I; ASSERT (a / b = 0.5 + 2.5 * I); ASSERT (a / b = (3 + 2 * I) / (1 - 1 * I));
	END Test.

positive: COMPLEX64 real quotient

	MODULE Test;
	VAR a, b: COMPLEX64;
	BEGIN a := 3 + 2 * I; b := 1 - 1 * I; ASSERT (a / b = 0.5 + 2.5 * I); ASSERT (a / b = (3 + 2 * I) / (1 - 1 * I));
	END Test.

positive: HUGEINT real quotient

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: SHORTREAL real quotient

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN a := 3; b := 2; ASSERT (a / b = 1.5); ASSERT (a / b = 3 / 2);
	END Test.

positive: SHORTCOMPLEX real quotient

	MODULE Test;
	VAR a, b: SHORTCOMPLEX;
	BEGIN a := 3 + 2 * I; b := 1 - 1 * I; ASSERT (a / b = 0.5 + 2.5 * I); ASSERT (a / b = (3 + 2 * I) / (1 - 1 * I));
	END Test.

positive: COMPLEX real quotient

	MODULE Test;
	VAR a, b: COMPLEX;
	BEGIN a := 3 + 2 * I; b := 1 - 1 * I; ASSERT (a / b = 0.5 + 2.5 * I); ASSERT (a / b = (3 + 2 * I) / (1 - 1 * I));
	END Test.

positive: LONGCOMPLEX real quotient

	MODULE Test;
	VAR a, b: LONGCOMPLEX;
	BEGIN a := 3 + 2 * I; b := 1 - 1 * I; ASSERT (a / b = 0.5 + 2.5 * I); ASSERT (a / b = (3 + 2 * I) / (1 - 1 * I));
	END Test.

positive: SIGNED8 integer quotient

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: SIGNED16 integer quotient

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: SIGNED32 integer quotient

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: SIGNED64 integer quotient

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: UNSIGNED8 integer quotient

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: UNSIGNED16 integer quotient

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: UNSIGNED32 integer quotient

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: UNSIGNED64 integer quotient

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: HUGEINT integer quotient

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT (a DIV b = +1); ASSERT (a DIV b = 3 DIV 2);
		a := 2; b := 3; ASSERT (a DIV b = +0); ASSERT (a DIV b = 2 DIV 3);
	END Test.

positive: SIGNED8 modulus

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: SIGNED16 modulus

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: SIGNED32 modulus

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: SIGNED64 modulus

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: UNSIGNED8 modulus

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: UNSIGNED16 modulus

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: UNSIGNED32 modulus

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: UNSIGNED64 modulus

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: HUGEINT modulus

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT (a MOD b = +1); ASSERT (a MOD b = 3 MOD 2);
		a := 2; b := 3; ASSERT (a MOD b = +2); ASSERT (a MOD b = 2 MOD 3);
	END Test.

positive: SIGNED8 sign inversion

	MODULE Test;
	VAR value: SIGNED8;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: SIGNED16 sign inversion

	MODULE Test;
	VAR value: SIGNED16;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: SIGNED32 sign inversion

	MODULE Test;
	VAR value: SIGNED32;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: SIGNED64 sign inversion

	MODULE Test;
	VAR value: SIGNED64;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: REAL32 sign inversion

	MODULE Test;
	VAR value: REAL32;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: REAL64 sign inversion

	MODULE Test;
	VAR value: REAL64;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: COMPLEX32 sign inversion

	MODULE Test;
	VAR value: COMPLEX32;
	BEGIN value := 5 - 3 * I; ASSERT (-value = -5 + 3 * I); ASSERT (-(-value) = 5 - 3 * I); ASSERT (-(-value) = value)
	END Test.

positive: COMPLEX64 sign inversion

	MODULE Test;
	VAR value: COMPLEX64;
	BEGIN value := 5 - 3 * I; ASSERT (-value = -5 + 3 * I); ASSERT (-(-value) = 5 - 3 * I); ASSERT (-(-value) = value)
	END Test.

positive: HUGEINT sign inversion

	MODULE Test;
	VAR value: HUGEINT;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: SHORTREAL sign inversion

	MODULE Test;
	VAR value: SHORTREAL;
	BEGIN value := 5; ASSERT (-value = -5); ASSERT (-(-value) = 5); ASSERT (-(-value) = value)
	END Test.

positive: SHORTCOMPLEX sign inversion

	MODULE Test;
	VAR value: SHORTCOMPLEX;
	BEGIN value := 5 - 3 * I; ASSERT (-value = -5 + 3 * I); ASSERT (-(-value) = 5 - 3 * I); ASSERT (-(-value) = value)
	END Test.

positive: COMPLEX sign inversion

	MODULE Test;
	VAR value: COMPLEX;
	BEGIN value := 5 - 3 * I; ASSERT (-value = -5 + 3 * I); ASSERT (-(-value) = 5 - 3 * I); ASSERT (-(-value) = value)
	END Test.

positive: LONGCOMPLEX sign inversion

	MODULE Test;
	VAR value: LONGCOMPLEX;
	BEGIN value := 5 - 3 * I; ASSERT (-value = -5 + 3 * I); ASSERT (-(-value) = 5 - 3 * I); ASSERT (-(-value) = value)
	END Test.

positive: SIGNED8 identity

	MODULE Test;
	VAR value: SIGNED8;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: SIGNED16 identity

	MODULE Test;
	VAR value: SIGNED16;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: SIGNED32 identity

	MODULE Test;
	VAR value: SIGNED32;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: SIGNED64 identity

	MODULE Test;
	VAR value: SIGNED64;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: UNSIGNED8 identity

	MODULE Test;
	VAR value: UNSIGNED8;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: UNSIGNED16 identity

	MODULE Test;
	VAR value: UNSIGNED16;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: UNSIGNED32 identity

	MODULE Test;
	VAR value: UNSIGNED32;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: UNSIGNED64 identity

	MODULE Test;
	VAR value: UNSIGNED64;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: REAL32 identity

	MODULE Test;
	VAR value: REAL32;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: REAL64 identity

	MODULE Test;
	VAR value: REAL64;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: COMPLEX32 identity

	MODULE Test;
	VAR value: COMPLEX32;
	BEGIN value := 5 - 3 * I; ASSERT (+value = 5 - 3 * I); ASSERT (+(+value) = 5 - 3 * I); ASSERT (+(+value) = value)
	END Test.

positive: COMPLEX64 identity

	MODULE Test;
	VAR value: COMPLEX64;
	BEGIN value := 5 - 3 * I; ASSERT (+value = 5 - 3 * I); ASSERT (+(+value) = 5 - 3 * I); ASSERT (+(+value) = value)
	END Test.

positive: HUGEINT identity

	MODULE Test;
	VAR value: HUGEINT;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: SHORTREAL identity

	MODULE Test;
	VAR value: SHORTREAL;
	BEGIN value := 5; ASSERT (+value = +5); ASSERT (+(+value) = 5); ASSERT (+(+value) = value)
	END Test.

positive: SHORTCOMPLEX identity

	MODULE Test;
	VAR value: SHORTCOMPLEX;
	BEGIN value := 5 - 3 * I; ASSERT (+value = 5 - 3 * I); ASSERT (+(+value) = 5 - 3 * I); ASSERT (+(+value) = value)
	END Test.

positive: COMPLEX identity

	MODULE Test;
	VAR value: COMPLEX;
	BEGIN value := 5 - 3 * I; ASSERT (+value = 5 - 3 * I); ASSERT (+(+value) = 5 - 3 * I); ASSERT (+(+value) = value)
	END Test.

positive: LONGCOMPLEX identity

	MODULE Test;
	VAR value: LONGCOMPLEX;
	BEGIN value := 5 - 3 * I; ASSERT (+value = 5 - 3 * I); ASSERT (+(+value) = 5 - 3 * I); ASSERT (+(+value) = value)
	END Test.

positive: rounding of integer quotient toward zero

	MODULE Test;
	VAR x, y: INTEGER;
	BEGIN
		x := 5; y := 2; ASSERT (x DIV y = 2);
		x := -5; y := 2; ASSERT (x DIV y = -2);
	END Test.

positive: modulus with same sign as dividend

	MODULE Test;
	VAR x, y: INTEGER;
	BEGIN
		x := 5; y := 2; ASSERT (x MOD y = 1);
		x := -5; y := 2; ASSERT (x MOD y = -1);
	END Test.

positive: integer quotient and modulus example

	MODULE Test;
	VAR x, y: INTEGER;
	BEGIN
		x := 5; y := 3; ASSERT (x DIV y = 1); ASSERT (x MOD y = 2);
		x := -5; y := 3; ASSERT (x DIV y = -1); ASSERT (x MOD y = -2);
	END Test.

# 8.2.3 Set Operators

positive: SET8 union

	MODULE Test;
	VAR a, b: SET8;
	BEGIN
		a := {}; b := {}; ASSERT (a + b = {}); ASSERT (a + b = {} + {});
		a := {1, 2}; b := {}; ASSERT (a + b = {1, 2}); ASSERT (a + b = {1, 2} + {});
		a := {}; b := {2, 3}; ASSERT (a + b = {2, 3}); ASSERT (a + b = {} + {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a + b = {1..3}); ASSERT (a + b = {1, 2} + {2, 3});
	END Test.

positive: SET16 union

	MODULE Test;
	VAR a, b: SET16;
	BEGIN
		a := {}; b := {}; ASSERT (a + b = {}); ASSERT (a + b = {} + {});
		a := {1, 2}; b := {}; ASSERT (a + b = {1, 2}); ASSERT (a + b = {1, 2} + {});
		a := {}; b := {2, 3}; ASSERT (a + b = {2, 3}); ASSERT (a + b = {} + {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a + b = {1..3}); ASSERT (a + b = {1, 2} + {2, 3});
	END Test.

positive: SET32 union

	MODULE Test;
	VAR a, b: SET32;
	BEGIN
		a := {}; b := {}; ASSERT (a + b = {}); ASSERT (a + b = {} + {});
		a := {1, 2}; b := {}; ASSERT (a + b = {1, 2}); ASSERT (a + b = {1, 2} + {});
		a := {}; b := {2, 3}; ASSERT (a + b = {2, 3}); ASSERT (a + b = {} + {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a + b = {1..3}); ASSERT (a + b = {1, 2} + {2, 3});
	END Test.

positive: SET64 union

	MODULE Test;
	VAR a, b: SET64;
	BEGIN
		a := {}; b := {}; ASSERT (a + b = {}); ASSERT (a + b = {} + {});
		a := {1, 2}; b := {}; ASSERT (a + b = {1, 2}); ASSERT (a + b = {1, 2} + {});
		a := {}; b := {2, 3}; ASSERT (a + b = {2, 3}); ASSERT (a + b = {} + {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a + b = {1..3}); ASSERT (a + b = {1, 2} + {2, 3});
	END Test.

positive: SHORTSET union

	MODULE Test;
	VAR a, b: SHORTSET;
	BEGIN
		a := {}; b := {}; ASSERT (a + b = {}); ASSERT (a + b = {} + {});
		a := {1, 2}; b := {}; ASSERT (a + b = {1, 2}); ASSERT (a + b = {1, 2} + {});
		a := {}; b := {2, 3}; ASSERT (a + b = {2, 3}); ASSERT (a + b = {} + {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a + b = {1..3}); ASSERT (a + b = {1, 2} + {2, 3});
	END Test.

positive: LONGSET union

	MODULE Test;
	VAR a, b: LONGSET;
	BEGIN
		a := {}; b := {}; ASSERT (a + b = {}); ASSERT (a + b = {} + {});
		a := {1, 2}; b := {}; ASSERT (a + b = {1, 2}); ASSERT (a + b = {1, 2} + {});
		a := {}; b := {2, 3}; ASSERT (a + b = {2, 3}); ASSERT (a + b = {} + {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a + b = {1..3}); ASSERT (a + b = {1, 2} + {2, 3});
	END Test.

positive: HUGESET union

	MODULE Test;
	VAR a, b: HUGESET;
	BEGIN
		a := {}; b := {}; ASSERT (a + b = {}); ASSERT (a + b = {} + {});
		a := {1, 2}; b := {}; ASSERT (a + b = {1, 2}); ASSERT (a + b = {1, 2} + {});
		a := {}; b := {2, 3}; ASSERT (a + b = {2, 3}); ASSERT (a + b = {} + {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a + b = {1..3}); ASSERT (a + b = {1, 2} + {2, 3});
	END Test.

positive: SET8 difference

	MODULE Test;
	VAR a, b: SET8;
	BEGIN
		a := {}; b := {}; ASSERT (a - b = {}); ASSERT (a - b = {} - {});
		a := {1, 2}; b := {}; ASSERT (a - b = {1, 2}); ASSERT (a - b = {1, 2} - {});
		a := {}; b := {2, 3}; ASSERT (a - b = {}); ASSERT (a - b = {} - {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a - b = {1}); ASSERT (a - b = {1, 2} - {2, 3});
	END Test.

positive: SET16 difference

	MODULE Test;
	VAR a, b: SET16;
	BEGIN
		a := {}; b := {}; ASSERT (a - b = {}); ASSERT (a - b = {} - {});
		a := {1, 2}; b := {}; ASSERT (a - b = {1, 2}); ASSERT (a - b = {1, 2} - {});
		a := {}; b := {2, 3}; ASSERT (a - b = {}); ASSERT (a - b = {} - {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a - b = {1}); ASSERT (a - b = {1, 2} - {2, 3});
	END Test.

positive: SET32 difference

	MODULE Test;
	VAR a, b: SET32;
	BEGIN
		a := {}; b := {}; ASSERT (a - b = {}); ASSERT (a - b = {} - {});
		a := {1, 2}; b := {}; ASSERT (a - b = {1, 2}); ASSERT (a - b = {1, 2} - {});
		a := {}; b := {2, 3}; ASSERT (a - b = {}); ASSERT (a - b = {} - {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a - b = {1}); ASSERT (a - b = {1, 2} - {2, 3});
	END Test.

positive: SET64 difference

	MODULE Test;
	VAR a, b: SET64;
	BEGIN
		a := {}; b := {}; ASSERT (a - b = {}); ASSERT (a - b = {} - {});
		a := {1, 2}; b := {}; ASSERT (a - b = {1, 2}); ASSERT (a - b = {1, 2} - {});
		a := {}; b := {2, 3}; ASSERT (a - b = {}); ASSERT (a - b = {} - {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a - b = {1}); ASSERT (a - b = {1, 2} - {2, 3});
	END Test.

positive: SHORTSET difference

	MODULE Test;
	VAR a, b: SHORTSET;
	BEGIN
		a := {}; b := {}; ASSERT (a - b = {}); ASSERT (a - b = {} - {});
		a := {1, 2}; b := {}; ASSERT (a - b = {1, 2}); ASSERT (a - b = {1, 2} - {});
		a := {}; b := {2, 3}; ASSERT (a - b = {}); ASSERT (a - b = {} - {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a - b = {1}); ASSERT (a - b = {1, 2} - {2, 3});
	END Test.

positive: LONGSET difference

	MODULE Test;
	VAR a, b: LONGSET;
	BEGIN
		a := {}; b := {}; ASSERT (a - b = {}); ASSERT (a - b = {} - {});
		a := {1, 2}; b := {}; ASSERT (a - b = {1, 2}); ASSERT (a - b = {1, 2} - {});
		a := {}; b := {2, 3}; ASSERT (a - b = {}); ASSERT (a - b = {} - {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a - b = {1}); ASSERT (a - b = {1, 2} - {2, 3});
	END Test.

positive: HUGESET difference

	MODULE Test;
	VAR a, b: HUGESET;
	BEGIN
		a := {}; b := {}; ASSERT (a - b = {}); ASSERT (a - b = {} - {});
		a := {1, 2}; b := {}; ASSERT (a - b = {1, 2}); ASSERT (a - b = {1, 2} - {});
		a := {}; b := {2, 3}; ASSERT (a - b = {}); ASSERT (a - b = {} - {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a - b = {1}); ASSERT (a - b = {1, 2} - {2, 3});
	END Test.

positive: SET8 intersection

	MODULE Test;
	VAR a, b: SET8;
	BEGIN
		a := {}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {} * {});
		a := {1, 2}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {1, 2} * {});
		a := {}; b := {2, 3}; ASSERT (a * b = {}); ASSERT (a * b = {} * {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a * b = {2}); ASSERT (a * b = {1, 2} * {2, 3});
	END Test.

positive: SET16 intersection

	MODULE Test;
	VAR a, b: SET16;
	BEGIN
		a := {}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {} * {});
		a := {1, 2}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {1, 2} * {});
		a := {}; b := {2, 3}; ASSERT (a * b = {}); ASSERT (a * b = {} * {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a * b = {2}); ASSERT (a * b = {1, 2} * {2, 3});
	END Test.

positive: SET32 intersection

	MODULE Test;
	VAR a, b: SET32;
	BEGIN
		a := {}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {} * {});
		a := {1, 2}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {1, 2} * {});
		a := {}; b := {2, 3}; ASSERT (a * b = {}); ASSERT (a * b = {} * {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a * b = {2}); ASSERT (a * b = {1, 2} * {2, 3});
	END Test.

positive: SET64 intersection

	MODULE Test;
	VAR a, b: SET64;
	BEGIN
		a := {}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {} * {});
		a := {1, 2}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {1, 2} * {});
		a := {}; b := {2, 3}; ASSERT (a * b = {}); ASSERT (a * b = {} * {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a * b = {2}); ASSERT (a * b = {1, 2} * {2, 3});
	END Test.

positive: SHORTSET intersection

	MODULE Test;
	VAR a, b: SHORTSET;
	BEGIN
		a := {}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {} * {});
		a := {1, 2}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {1, 2} * {});
		a := {}; b := {2, 3}; ASSERT (a * b = {}); ASSERT (a * b = {} * {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a * b = {2}); ASSERT (a * b = {1, 2} * {2, 3});
	END Test.

positive: LONGSET intersection

	MODULE Test;
	VAR a, b: LONGSET;
	BEGIN
		a := {}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {} * {});
		a := {1, 2}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {1, 2} * {});
		a := {}; b := {2, 3}; ASSERT (a * b = {}); ASSERT (a * b = {} * {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a * b = {2}); ASSERT (a * b = {1, 2} * {2, 3});
	END Test.

positive: HUGESET intersection

	MODULE Test;
	VAR a, b: HUGESET;
	BEGIN
		a := {}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {} * {});
		a := {1, 2}; b := {}; ASSERT (a * b = {}); ASSERT (a * b = {1, 2} * {});
		a := {}; b := {2, 3}; ASSERT (a * b = {}); ASSERT (a * b = {} * {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a * b = {2}); ASSERT (a * b = {1, 2} * {2, 3});
	END Test.

positive: SET8 symmetric set difference

	MODULE Test;
	VAR a, b: SET8;
	BEGIN
		a := {}; b := {}; ASSERT (a / b = {}); ASSERT (a / b = {} / {});
		a := {1, 2}; b := {}; ASSERT (a / b = {1, 2}); ASSERT (a / b = {1, 2} / {});
		a := {}; b := {2, 3}; ASSERT (a / b = {2, 3}); ASSERT (a / b = {} / {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a / b = {1, 3}); ASSERT (a / b = {1, 2} / {2, 3});
	END Test.

positive: SET16 symmetric set difference

	MODULE Test;
	VAR a, b: SET16;
	BEGIN
		a := {}; b := {}; ASSERT (a / b = {}); ASSERT (a / b = {} / {});
		a := {1, 2}; b := {}; ASSERT (a / b = {1, 2}); ASSERT (a / b = {1, 2} / {});
		a := {}; b := {2, 3}; ASSERT (a / b = {2, 3}); ASSERT (a / b = {} / {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a / b = {1, 3}); ASSERT (a / b = {1, 2} / {2, 3});
	END Test.

positive: SET32 symmetric set difference

	MODULE Test;
	VAR a, b: SET32;
	BEGIN
		a := {}; b := {}; ASSERT (a / b = {}); ASSERT (a / b = {} / {});
		a := {1, 2}; b := {}; ASSERT (a / b = {1, 2}); ASSERT (a / b = {1, 2} / {});
		a := {}; b := {2, 3}; ASSERT (a / b = {2, 3}); ASSERT (a / b = {} / {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a / b = {1, 3}); ASSERT (a / b = {1, 2} / {2, 3});
	END Test.

positive: SET64 symmetric set difference

	MODULE Test;
	VAR a, b: SET64;
	BEGIN
		a := {}; b := {}; ASSERT (a / b = {}); ASSERT (a / b = {} / {});
		a := {1, 2}; b := {}; ASSERT (a / b = {1, 2}); ASSERT (a / b = {1, 2} / {});
		a := {}; b := {2, 3}; ASSERT (a / b = {2, 3}); ASSERT (a / b = {} / {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a / b = {1, 3}); ASSERT (a / b = {1, 2} / {2, 3});
	END Test.

positive: SHORTSET symmetric set difference

	MODULE Test;
	VAR a, b: SHORTSET;
	BEGIN
		a := {}; b := {}; ASSERT (a / b = {}); ASSERT (a / b = {} / {});
		a := {1, 2}; b := {}; ASSERT (a / b = {1, 2}); ASSERT (a / b = {1, 2} / {});
		a := {}; b := {2, 3}; ASSERT (a / b = {2, 3}); ASSERT (a / b = {} / {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a / b = {1, 3}); ASSERT (a / b = {1, 2} / {2, 3});
	END Test.

positive: LONGSET symmetric set difference

	MODULE Test;
	VAR a, b: LONGSET;
	BEGIN
		a := {}; b := {}; ASSERT (a / b = {}); ASSERT (a / b = {} / {});
		a := {1, 2}; b := {}; ASSERT (a / b = {1, 2}); ASSERT (a / b = {1, 2} / {});
		a := {}; b := {2, 3}; ASSERT (a / b = {2, 3}); ASSERT (a / b = {} / {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a / b = {1, 3}); ASSERT (a / b = {1, 2} / {2, 3});
	END Test.

positive: HUGESET symmetric set difference

	MODULE Test;
	VAR a, b: HUGESET;
	BEGIN
		a := {}; b := {}; ASSERT (a / b = {}); ASSERT (a / b = {} / {});
		a := {1, 2}; b := {}; ASSERT (a / b = {1, 2}); ASSERT (a / b = {1, 2} / {});
		a := {}; b := {2, 3}; ASSERT (a / b = {2, 3}); ASSERT (a / b = {} / {2, 3});
		a := {1, 2}; b := {2, 3}; ASSERT (a / b = {1, 3}); ASSERT (a / b = {1, 2} / {2, 3});
	END Test.

positive: SET8 identity

	MODULE Test;
	VAR value: SET8;
	BEGIN value := {3}; ASSERT (+value = +{3}); ASSERT (+(+value) = {3}); ASSERT (+(+value) = value)
	END Test.

positive: SET16 identity

	MODULE Test;
	VAR value: SET16;
	BEGIN value := {3}; ASSERT (+value = +{3}); ASSERT (+(+value) = {3}); ASSERT (+(+value) = value)
	END Test.

positive: SET32 identity

	MODULE Test;
	VAR value: SET32;
	BEGIN value := {3}; ASSERT (+value = +{3}); ASSERT (+(+value) = {3}); ASSERT (+(+value) = value)
	END Test.

positive: SET64 identity

	MODULE Test;
	VAR value: SET64;
	BEGIN value := {3}; ASSERT (+value = +{3}); ASSERT (+(+value) = {3}); ASSERT (+(+value) = value)
	END Test.

positive: SHORTSET identity

	MODULE Test;
	VAR value: SHORTSET;
	BEGIN value := {3}; ASSERT (+value = +{3}); ASSERT (+(+value) = {3}); ASSERT (+(+value) = value)
	END Test.

positive: LONGSET identity

	MODULE Test;
	VAR value: LONGSET;
	BEGIN value := {3}; ASSERT (+value = +{3}); ASSERT (+(+value) = {3}); ASSERT (+(+value) = value)
	END Test.

positive: HUGESET identity

	MODULE Test;
	VAR value: HUGESET;
	BEGIN value := {3}; ASSERT (+value = +{3}); ASSERT (+(+value) = {3}); ASSERT (+(+value) = value)
	END Test.

positive: SET8 complement set difference

	MODULE Test;
	VAR value: SET8;
	BEGIN value := {2}; ASSERT (-value = {0..MAX (SET8)} - {2}); ASSERT (-(-value) = {2}); ASSERT (-(-value) = value)
	END Test.

positive: SET16 complement set difference

	MODULE Test;
	VAR value: SET16;
	BEGIN value := {2}; ASSERT (-value = {0..MAX (SET16)} - {2}); ASSERT (-(-value) = {2}); ASSERT (-(-value) = value)
	END Test.

positive: SET32 complement set difference

	MODULE Test;
	VAR value: SET32;
	BEGIN value := {2}; ASSERT (-value = {0..MAX (SET32)} - {2}); ASSERT (-(-value) = {2}); ASSERT (-(-value) = value)
	END Test.

positive: SET64 complement set difference

	MODULE Test;
	VAR value: SET64;
	BEGIN value := {2}; ASSERT (-value = {0..MAX (SET64)} - {2}); ASSERT (-(-value) = {2}); ASSERT (-(-value) = value)
	END Test.

positive: SHORTSET complement set difference

	MODULE Test;
	VAR value: SHORTSET;
	BEGIN value := {2}; ASSERT (-value = {0..MAX (SHORTSET)} - {2}); ASSERT (-(-value) = {2}); ASSERT (-(-value) = value)
	END Test.

positive: LONGSET complement set difference

	MODULE Test;
	VAR value: LONGSET;
	BEGIN value := {2}; ASSERT (-value = {0..MAX (LONGSET)} - {2}); ASSERT (-(-value) = {2}); ASSERT (-(-value) = value)
	END Test.

positive: HUGESET complement set difference

	MODULE Test;
	VAR value: HUGESET;
	BEGIN value := {2}; ASSERT (-value = {0..MAX (HUGESET)} - {2}); ASSERT (-(-value) = {2}); ASSERT (-(-value) = value)
	END Test.

# 8.2.4 Relations

positive: SIGNED8 equal relation

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: SIGNED16 equal relation

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: SIGNED32 equal relation

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: SIGNED64 equal relation

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: UNSIGNED8 equal relation

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: UNSIGNED16 equal relation

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: UNSIGNED32 equal relation

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: UNSIGNED64 equal relation

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: REAL32 equal relation

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 = 2.5));
		a := 4.5; b := 4.5; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 = 4.5));
	END Test.

positive: REAL64 equal relation

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 = 2.5));
		a := 4.5; b := 4.5; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 = 4.5));
	END Test.

positive: COMPLEX32 equal relation

	MODULE Test;
	VAR a, b: COMPLEX32;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 + 1.5 * I = 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 + 2.5 * I = 4.5 + 2.5 * I));
	END Test.

positive: COMPLEX64 equal relation

	MODULE Test;
	VAR a, b: COMPLEX64;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 + 1.5 * I = 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 + 2.5 * I = 4.5 + 2.5 * I));
	END Test.

positive: HUGEINT equal relation

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3 = 2));
		a := a; b := a; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (a = a));
	END Test.

positive: SHORTREAL equal relation

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 = 2.5));
		a := 4.5; b := 4.5; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 = 4.5));
	END Test.

positive: SHORTCOMPLEX equal relation

	MODULE Test;
	VAR a, b: SHORTCOMPLEX;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 + 1.5 * I = 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 + 2.5 * I = 4.5 + 2.5 * I));
	END Test.

positive: COMPLEX equal relation

	MODULE Test;
	VAR a, b: COMPLEX;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 + 1.5 * I = 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 + 2.5 * I = 4.5 + 2.5 * I));
	END Test.

positive: LONGCOMPLEX equal relation

	MODULE Test;
	VAR a, b: LONGCOMPLEX;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = (3.5 + 1.5 * I = 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = (4.5 + 2.5 * I = 4.5 + 2.5 * I));
	END Test.

positive: SET8 equal relation

	MODULE Test;
	VAR a, b: SET8;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ({0} = {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ({3, 4} = {4, 3}));
	END Test.

positive: SET16 equal relation

	MODULE Test;
	VAR a, b: SET16;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ({0} = {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ({3, 4} = {4, 3}));
	END Test.

positive: SET32 equal relation

	MODULE Test;
	VAR a, b: SET32;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ({0} = {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ({3, 4} = {4, 3}));
	END Test.

positive: SET64 equal relation

	MODULE Test;
	VAR a, b: SET64;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ({0} = {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ({3, 4} = {4, 3}));
	END Test.

positive: SHORTSET equal relation

	MODULE Test;
	VAR a, b: SHORTSET;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ({0} = {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ({3, 4} = {4, 3}));
	END Test.

positive: LONGSET equal relation

	MODULE Test;
	VAR a, b: LONGSET;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ({0} = {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ({3, 4} = {4, 3}));
	END Test.

positive: HUGESET equal relation

	MODULE Test;
	VAR a, b: HUGESET;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a = b) = FALSE); ASSERT ((a = b) = ({0} = {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a = b) = TRUE); ASSERT ((a = b) = ({3, 4} = {4, 3}));
	END Test.

positive: SIGNED8 unequal relation

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: SIGNED16 unequal relation

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: SIGNED32 unequal relation

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: SIGNED64 unequal relation

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: UNSIGNED8 unequal relation

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: UNSIGNED16 unequal relation

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: UNSIGNED32 unequal relation

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: UNSIGNED64 unequal relation

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: REAL32 unequal relation

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 # 2.5));
		a := 4.5; b := 4.5; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 # 4.5));
	END Test.

positive: REAL64 unequal relation

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 # 2.5));
		a := 4.5; b := 4.5; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 # 4.5));
	END Test.

positive: COMPLEX32 unequal relation

	MODULE Test;
	VAR a, b: COMPLEX32;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 + 1.5 * I # 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 + 2.5 * I # 4.5 + 2.5 * I));
	END Test.

positive: COMPLEX64 unequal relation

	MODULE Test;
	VAR a, b: COMPLEX64;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 + 1.5 * I # 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 + 2.5 * I # 4.5 + 2.5 * I));
	END Test.

positive: HUGEINT unequal relation

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3 # 2));
		a := 4; b := 4; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4 # 4));
	END Test.

positive: SHORTREAL unequal relation

	MODULE Test;
	VAR a, b: LONGREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 # 2.5));
		a := 4.5; b := 4.5; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 # 4.5));
	END Test.

positive: SHORTCOMPLEX unequal relation

	MODULE Test;
	VAR a, b: SHORTCOMPLEX;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 + 1.5 * I # 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 + 2.5 * I # 4.5 + 2.5 * I));
	END Test.

positive: COMPLEX unequal relation

	MODULE Test;
	VAR a, b: COMPLEX;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 + 1.5 * I # 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 + 2.5 * I # 4.5 + 2.5 * I));
	END Test.

positive: LONGCOMPLEX unequal relation

	MODULE Test;
	VAR a, b: LONGCOMPLEX;
	BEGIN
		a := 3.5 + 1.5 * I; b := 2.5 - 3.5 * I; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = (3.5 + 1.5 * I # 2.5 - 3.5 * I));
		a := 4.5 + 2.5 * I; b := 4.5 + 2.5 * I; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = (4.5 + 2.5 * I # 4.5 + 2.5 * I));
	END Test.

positive: SET8 unequal relation

	MODULE Test;
	VAR a, b: SET8;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ({0} # {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ({3, 4} # {4, 3}));
	END Test.

positive: SET16 unequal relation

	MODULE Test;
	VAR a, b: SET16;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ({0} # {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ({3, 4} # {4, 3}));
	END Test.

positive: SET32 unequal relation

	MODULE Test;
	VAR a, b: SET32;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ({0} # {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ({3, 4} # {4, 3}));
	END Test.

positive: SET64 unequal relation

	MODULE Test;
	VAR a, b: SET64;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ({0} # {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ({3, 4} # {4, 3}));
	END Test.

positive: SHORTSET unequal relation

	MODULE Test;
	VAR a, b: SHORTSET;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ({0} # {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ({3, 4} # {4, 3}));
	END Test.

positive: LONGSET unequal relation

	MODULE Test;
	VAR a, b: LONGSET;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ({0} # {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ({3, 4} # {4, 3}));
	END Test.

positive: HUGESET unequal relation

	MODULE Test;
	VAR a, b: HUGESET;
	BEGIN
		a := {0}; b := {1, 2}; ASSERT ((a # b) = TRUE); ASSERT ((a # b) = ({0} # {1, 2}));
		a := {3, 4}; b := {4, 3}; ASSERT ((a # b) = FALSE); ASSERT ((a # b) = ({3, 4} # {4, 3}));
	END Test.

positive: SIGNED8 less relation

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: SIGNED16 less relation

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: SIGNED32 less relation

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: SIGNED64 less relation

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: UNSIGNED8 less relation

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: UNSIGNED16 less relation

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: UNSIGNED32 less relation

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: UNSIGNED64 less relation

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: REAL32 less relation

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3.5 < 2.5));
		a := 4.5; b := 4.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4.5 < 4.5));
	END Test.

positive: REAL64 less relation

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3.5 < 2.5));
		a := 4.5; b := 4.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4.5 < 4.5));
	END Test.

positive: HUGEINT less relation

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3 < 2));
		a := 4; b := 4; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4 < 4));
	END Test.

positive: SHORTREAL less relation

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (3.5 < 2.5));
		a := 4.5; b := 4.5; ASSERT ((a < b) = FALSE); ASSERT ((a < b) = (4.5 < 4.5));
	END Test.

positive: SIGNED8 less or equal relation

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: SIGNED16 less or equal relation

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: SIGNED32 less or equal relation

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: SIGNED64 less or equal relation

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: UNSIGNED8 less or equal relation

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: UNSIGNED16 less or equal relation

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: UNSIGNED32 less or equal relation

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: UNSIGNED64 less or equal relation

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: REAL32 less or equal relation

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3.5 <= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4.5 <= 4.5));
	END Test.

positive: REAL64 less or equal relation

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3.5 <= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4.5 <= 4.5));
	END Test.

positive: HUGEINT less or equal relation

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3 <= 2));
		a := 4; b := 4; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4 <= 4));
	END Test.

positive: SHORTREAL less or equal relation

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a <= b) = FALSE); ASSERT ((a <= b) = (3.5 <= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a <= b) = TRUE); ASSERT ((a <= b) = (4.5 <= 4.5));
	END Test.

positive: SIGNED8 greater relation

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: SIGNED16 greater relation

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: SIGNED32 greater relation

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: SIGNED64 greater relation

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: UNSIGNED8 greater relation

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: UNSIGNED16 greater relation

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: UNSIGNED32 greater relation

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: UNSIGNED64 greater relation

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: REAL32 greater relation

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3.5 > 2.5));
		a := 4.5; b := 4.5; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4.5 > 4.5));
	END Test.

positive: REAL64 greater relation

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3.5 > 2.5));
		a := 4.5; b := 4.5; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4.5 > 4.5));
	END Test.

positive: HUGEINT greater relation

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3 > 2));
		a := 4; b := 4; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4 > 4));
	END Test.

positive: SHORTREAL greater relation

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a > b) = TRUE); ASSERT ((a > b) = (3.5 > 2.5));
		a := 4.5; b := 4.5; ASSERT ((a > b) = FALSE); ASSERT ((a > b) = (4.5 > 4.5));
	END Test.

positive: SIGNED8 greater or equal relation

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: SIGNED16 greater or equal relation

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: SIGNED32 greater or equal relation

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: SIGNED64 greater or equal relation

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: UNSIGNED8 greater or equal relation

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: UNSIGNED16 greater or equal relation

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: UNSIGNED32 greater or equal relation

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: UNSIGNED64 greater or equal relation

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: REAL32 greater or equal relation

	MODULE Test;
	VAR a, b: REAL32;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3.5 >= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4.5 >= 4.5));
	END Test.

positive: REAL64 greater or equal relation

	MODULE Test;
	VAR a, b: REAL64;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3.5 >= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4.5 >= 4.5));
	END Test.

positive: HUGEINT greater or equal relation

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 3; b := 2; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3 >= 2));
		a := 4; b := 4; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4 >= 4));
	END Test.

positive: SHORTREAL greater or equal relation

	MODULE Test;
	VAR a, b: SHORTREAL;
	BEGIN
		a := 3.5; b := 2.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (3.5 >= 2.5));
		a := 4.5; b := 4.5; ASSERT ((a >= b) = TRUE); ASSERT ((a >= b) = (4.5 >= 4.5));
	END Test.

positive: SIGNED8 set membership

	MODULE Test;
	VAR a: SIGNED8; b: SET8;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: SIGNED16 set membership

	MODULE Test;
	VAR a: SIGNED16; b: SET16;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: SIGNED32 set membership

	MODULE Test;
	VAR a: SIGNED32; b: SET32;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: SIGNED64 set membership

	MODULE Test;
	VAR a: SIGNED64; b: SET64;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: UNSIGNED8 set membership

	MODULE Test;
	VAR a: UNSIGNED8; b: SET8;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: UNSIGNED16 set membership

	MODULE Test;
	VAR a: UNSIGNED16; b: SET16;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: UNSIGNED32 set membership

	MODULE Test;
	VAR a: UNSIGNED32; b: SET32;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

positive: UNSIGNED64 set membership

	MODULE Test;
	VAR a: UNSIGNED64; b: SET64;
	BEGIN
		a := 3; b := {1, 2}; ASSERT ((a IN b) = FALSE); ASSERT ((a IN b) = (3 IN {1, 2}));
		a := 2; b := {1, 2}; ASSERT ((a IN b) = TRUE); ASSERT ((a IN b) = (2 IN {2, 1}));
	END Test.

# 9.1 Assignments

positive: SIGNED8 assignment

	MODULE Test;
	VAR variable: SIGNED8;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: SIGNED16 assignment

	MODULE Test;
	VAR variable: SIGNED16;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: SIGNED32 assignment

	MODULE Test;
	VAR variable: SIGNED32;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: SIGNED64 assignment

	MODULE Test;
	VAR variable: SIGNED64;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: UNSIGNED8 assignment

	MODULE Test;
	VAR variable: UNSIGNED8;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: UNSIGNED16 assignment

	MODULE Test;
	VAR variable: UNSIGNED16;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: UNSIGNED32 assignment

	MODULE Test;
	VAR variable: UNSIGNED32;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: UNSIGNED64 assignment

	MODULE Test;
	VAR variable: UNSIGNED64;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: REAL32 assignment

	MODULE Test;
	VAR variable: REAL32;
	BEGIN variable := 2.5; ASSERT (variable = 2.5);
	END Test.

positive: REAL64 assignment

	MODULE Test;
	VAR variable: REAL64;
	BEGIN variable := 2.5; ASSERT (variable = 2.5);
	END Test.

positive: COMPLEX32 assignment

	MODULE Test;
	VAR variable: COMPLEX32;
	BEGIN variable := 2.5 - 1.5 * I; ASSERT (variable = 2.5 - 1.5 * I);
	END Test.

positive: COMPLEX64 assignment

	MODULE Test;
	VAR variable: COMPLEX64;
	BEGIN variable := 2.5 - 1.5 * I; ASSERT (variable = 2.5 - 1.5 * I);
	END Test.

positive: HUGEINT assignment

	MODULE Test;
	VAR variable: HUGEINT;
	BEGIN variable := 123; ASSERT (variable = 123);
	END Test.

positive: SHORTREAL assignment

	MODULE Test;
	VAR variable: SHORTREAL;
	BEGIN variable := 2.5; ASSERT (variable = 2.5);
	END Test.

positive: SHORTCOMPLEX assignment

	MODULE Test;
	VAR variable: SHORTCOMPLEX;
	BEGIN variable := 2.5 - 1.5 * I; ASSERT (variable = 2.5 - 1.5 * I);
	END Test.

positive: COMPLEX assignment

	MODULE Test;
	VAR variable: COMPLEX;
	BEGIN variable := 2.5 - 1.5 * I; ASSERT (variable = 2.5 - 1.5 * I);
	END Test.

positive: LONGCOMPLEX assignment

	MODULE Test;
	VAR variable: LONGCOMPLEX;
	BEGIN variable := 2.5 - 1.5 * I; ASSERT (variable = 2.5 - 1.5 * I);
	END Test.

positive: SET8 assignment

	MODULE Test;
	VAR variable: SET8;
	BEGIN variable := {1, 2}; ASSERT (variable = {1..2});
	END Test.

positive: SET16 assignment

	MODULE Test;
	VAR variable: SET16;
	BEGIN variable := {1, 2}; ASSERT (variable = {1..2});
	END Test.

positive: SET32 assignment

	MODULE Test;
	VAR variable: SET32;
	BEGIN variable := {1, 2}; ASSERT (variable = {1..2});
	END Test.

positive: SET64 assignment

	MODULE Test;
	VAR variable: SET64;
	BEGIN variable := {1, 2}; ASSERT (variable = {1..2});
	END Test.

positive: SHORTSET assignment

	MODULE Test;
	VAR variable: SHORTSET;
	BEGIN variable := {1, 2}; ASSERT (variable = {1..2});
	END Test.

positive: LONGSET assignment

	MODULE Test;
	VAR variable: LONGSET;
	BEGIN variable := {1, 2}; ASSERT (variable = {1..2});
	END Test.

positive: HUGESET assignment

	MODULE Test;
	VAR variable: HUGESET;
	BEGIN variable := {1, 2}; ASSERT (variable = {1..2});
	END Test.

# 10.3 Predeclared procedures

positive: SIGNED8 absolute value

	MODULE Test;
	VAR value: SIGNED8;
	BEGIN
		value := 5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: SIGNED16 absolute value

	MODULE Test;
	VAR value: SIGNED16;
	BEGIN
		value := 5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: SIGNED32 absolute value

	MODULE Test;
	VAR value: SIGNED32;
	BEGIN
		value := 5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: SIGNED64 absolute value

	MODULE Test;
	VAR value: SIGNED64;
	BEGIN
		value := 5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: REAL32 absolute value

	MODULE Test;
	VAR value: REAL32;
	BEGIN
		value := 5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: REAL64 absolute value

	MODULE Test;
	VAR value: REAL64;
	BEGIN
		value := 5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: COMPLEX32 absolute value

	MODULE Test;
	VAR value: COMPLEX32;
	BEGIN
		value := 3 + 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (3 + 4 * I));
		value := -3 - 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (-3 - 4 * I));
	END Test.

positive: COMPLEX64 absolute value

	MODULE Test;
	VAR value: COMPLEX64;
	BEGIN
		value := 3 + 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (3 + 4 * I));
		value := -3 - 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (-3 - 4 * I));
	END Test.

positive: HUGEINT absolute value

	MODULE Test;
	VAR value: HUGEINT;
	BEGIN
		value := 5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: SHORTREAL absolute value

	MODULE Test;
	VAR value: SHORTREAL;
	BEGIN
		value := 5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = value); ASSERT (ABS (-value) = value);
		value := -5.5; ASSERT (ABS (value) = 5.5); ASSERT (ABS (-value) = 5.5); ASSERT (ABS (value) = -value); ASSERT (ABS (-value) = -value);
	END Test.

positive: SHORTCOMPLEX absolute value

	MODULE Test;
	VAR value: SHORTCOMPLEX;
	BEGIN
		value := 3 + 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (3 + 4 * I));
		value := -3 - 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (-3 - 4 * I));
	END Test.

positive: COMPLEX absolute value

	MODULE Test;
	VAR value: COMPLEX;
	BEGIN
		value := 3 + 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (3 + 4 * I));
		value := -3 - 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (-3 - 4 * I));
	END Test.

positive: LONGCOMPLEX absolute value

	MODULE Test;
	VAR value: LONGCOMPLEX;
	BEGIN
		value := 3 + 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (3 + 4 * I));
		value := -3 - 4 * I; ASSERT (ABS (value) = 5); ASSERT (ABS (-value) = 5); ASSERT (ABS (value) = ABS (-3 - 4 * I));
	END Test.

positive: SIGNED8 arithmetic shift

	MODULE Test;
	VAR a, b: SIGNED8;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
		a := 6; b := -2; ASSERT (ASH (a, b) = 1); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (6, -2));
		a := -6; b := 2; ASSERT (ASH (a, b) = -24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (-6, 2));
		a := -6; b := 0; ASSERT (ASH (a, b) = -6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (-6, 0));
		a := -6; b := -2; ASSERT (ASH (a, b) = -2); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (-6, -2));
	END Test.

positive: SIGNED16 arithmetic shift

	MODULE Test;
	VAR a, b: SIGNED16;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
		a := 6; b := -2; ASSERT (ASH (a, b) = 1); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (6, -2));
		a := -6; b := 2; ASSERT (ASH (a, b) = -24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (-6, 2));
		a := -6; b := 0; ASSERT (ASH (a, b) = -6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (-6, 0));
		a := -6; b := -2; ASSERT (ASH (a, b) = -2); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (-6, -2));
	END Test.

positive: SIGNED32 arithmetic shift

	MODULE Test;
	VAR a, b: SIGNED32;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
		a := 6; b := -2; ASSERT (ASH (a, b) = 1); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (6, -2));
		a := -6; b := 2; ASSERT (ASH (a, b) = -24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (-6, 2));
		a := -6; b := 0; ASSERT (ASH (a, b) = -6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (-6, 0));
		a := -6; b := -2; ASSERT (ASH (a, b) = -2); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (-6, -2));
	END Test.

positive: SIGNED64 arithmetic shift

	MODULE Test;
	VAR a, b: SIGNED64;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
		a := 6; b := -2; ASSERT (ASH (a, b) = 1); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (6, -2));
		a := -6; b := 2; ASSERT (ASH (a, b) = -24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (-6, 2));
		a := -6; b := 0; ASSERT (ASH (a, b) = -6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (-6, 0));
		a := -6; b := -2; ASSERT (ASH (a, b) = -2); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (-6, -2));
	END Test.

positive: UNSIGNED8 arithmetic shift

	MODULE Test;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
	END Test.

positive: UNSIGNED16 arithmetic shift

	MODULE Test;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
	END Test.

positive: UNSIGNED32 arithmetic shift

	MODULE Test;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
	END Test.

positive: UNSIGNED64 arithmetic shift

	MODULE Test;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
	END Test.

positive: HUGEINT arithmetic shift

	MODULE Test;
	VAR a, b: HUGEINT;
	BEGIN
		a := 6; b := 2; ASSERT (ASH (a, b) = 24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (6, 2));
		a := 6; b := 0; ASSERT (ASH (a, b) = 6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (6, 0));
		a := 6; b := -2; ASSERT (ASH (a, b) = 1); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (6, -2));
		a := -6; b := 2; ASSERT (ASH (a, b) = -24); ASSERT (ASH (a, b) = ASH (a, 2)); ASSERT (ASH (a, b) = ASH (-6, 2));
		a := -6; b := 0; ASSERT (ASH (a, b) = -6); ASSERT (ASH (a, b) = ASH (a, 0)); ASSERT (ASH (a, b) = ASH (-6, 0));
		a := -6; b := -2; ASSERT (ASH (a, b) = -2); ASSERT (ASH (a, b) = ASH (a, -2)); ASSERT (ASH (a, b) = ASH (-6, -2));
	END Test.

positive: REAL32 entier number

	MODULE Test;
	VAR value: REAL32;
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

positive: REAL64 entier number

	MODULE Test;
	VAR value: REAL64;
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

positive: SHORTREAL entier number

	MODULE Test;
	VAR value: SHORTREAL;
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

positive: COMPLEX32 real part

	MODULE Test;
	VAR a: COMPLEX32;
	BEGIN
		a := I; ASSERT (RE (a) = 0); ASSERT (RE (a) = RE (I));
		a := 1.5 - 2.5 * I; ASSERT (RE (a) = 1.5); ASSERT (RE (a) = RE (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (RE (a) = -1.5); ASSERT (RE (a) = RE (-1.5 + 2.5 * I));
	END Test.

positive: COMPLEX64 real part

	MODULE Test;
	VAR a: COMPLEX64;
	BEGIN
		a := I; ASSERT (RE (a) = 0); ASSERT (RE (a) = RE (I));
		a := 1.5 - 2.5 * I; ASSERT (RE (a) = 1.5); ASSERT (RE (a) = RE (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (RE (a) = -1.5); ASSERT (RE (a) = RE (-1.5 + 2.5 * I));
	END Test.

positive: SHORTCOMPLEX real part

	MODULE Test;
	VAR a: SHORTCOMPLEX;
	BEGIN
		a := I; ASSERT (RE (a) = 0); ASSERT (RE (a) = RE (I));
		a := 1.5 - 2.5 * I; ASSERT (RE (a) = 1.5); ASSERT (RE (a) = RE (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (RE (a) = -1.5); ASSERT (RE (a) = RE (-1.5 + 2.5 * I));
	END Test.

positive: COMPLEX real part

	MODULE Test;
	VAR a: COMPLEX;
	BEGIN
		a := I; ASSERT (RE (a) = 0); ASSERT (RE (a) = RE (I));
		a := 1.5 - 2.5 * I; ASSERT (RE (a) = 1.5); ASSERT (RE (a) = RE (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (RE (a) = -1.5); ASSERT (RE (a) = RE (-1.5 + 2.5 * I));
	END Test.

positive: LONGCOMPLEX real part

	MODULE Test;
	VAR a: LONGCOMPLEX;
	BEGIN
		a := I; ASSERT (RE (a) = 0); ASSERT (RE (a) = RE (I));
		a := 1.5 - 2.5 * I; ASSERT (RE (a) = 1.5); ASSERT (RE (a) = RE (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (RE (a) = -1.5); ASSERT (RE (a) = RE (-1.5 + 2.5 * I));
	END Test.

positive: COMPLEX32 imaginary part

	MODULE Test;
	VAR a: COMPLEX32;
	BEGIN
		a := I; ASSERT (IM (a) = 1); ASSERT (IM (a) = IM (I));
		a := 1.5 - 2.5 * I; ASSERT (IM (a) = -2.5); ASSERT (IM (a) = IM (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (IM (a) = 2.5); ASSERT (IM (a) = IM (-1.5 + 2.5 * I));
	END Test.

positive: COMPLEX64 imaginary part

	MODULE Test;
	VAR a: COMPLEX64;
	BEGIN
		a := I; ASSERT (IM (a) = 1); ASSERT (IM (a) = IM (I));
		a := 1.5 - 2.5 * I; ASSERT (IM (a) = -2.5); ASSERT (IM (a) = IM (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (IM (a) = 2.5); ASSERT (IM (a) = IM (-1.5 + 2.5 * I));
	END Test.

positive: SHORTCOMPLEX imaginary part

	MODULE Test;
	VAR a: SHORTCOMPLEX;
	BEGIN
		a := I; ASSERT (IM (a) = 1); ASSERT (IM (a) = IM (I));
		a := 1.5 - 2.5 * I; ASSERT (IM (a) = -2.5); ASSERT (IM (a) = IM (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (IM (a) = 2.5); ASSERT (IM (a) = IM (-1.5 + 2.5 * I));
	END Test.

positive: COMPLEX imaginary part

	MODULE Test;
	VAR a: COMPLEX;
	BEGIN
		a := I; ASSERT (IM (a) = 1); ASSERT (IM (a) = IM (I));
		a := 1.5 - 2.5 * I; ASSERT (IM (a) = -2.5); ASSERT (IM (a) = IM (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (IM (a) = 2.5); ASSERT (IM (a) = IM (-1.5 + 2.5 * I));
	END Test.

positive: LONGCOMPLEX imaginary part

	MODULE Test;
	VAR a: LONGCOMPLEX;
	BEGIN
		a := I; ASSERT (IM (a) = 1); ASSERT (IM (a) = IM (I));
		a := 1.5 - 2.5 * I; ASSERT (IM (a) = -2.5); ASSERT (IM (a) = IM (1.5 - 2.5 * I));
		a := -1.5 + 2.5 * I; ASSERT (IM (a) = 2.5); ASSERT (IM (a) = IM (-1.5 + 2.5 * I));
	END Test.

positive: SIGNED8 oddness

	MODULE Test;
	VAR value: SIGNED8;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
		value := -5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: SIGNED16 oddness

	MODULE Test;
	VAR value: SIGNED16;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
		value := -5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: SIGNED32 oddness

	MODULE Test;
	VAR value: SIGNED32;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
		value := -5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: SIGNED64 oddness

	MODULE Test;
	VAR value: SIGNED64;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
		value := -5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: UNSIGNED8 oddness

	MODULE Test;
	VAR value: UNSIGNED8;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: UNSIGNED16 oddness

	MODULE Test;
	VAR value: UNSIGNED16;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: UNSIGNED32 oddness

	MODULE Test;
	VAR value: UNSIGNED32;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: UNSIGNED64 oddness

	MODULE Test;
	VAR value: UNSIGNED64;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: HUGEINT oddness

	MODULE Test;
	VAR value: HUGEINT;
	BEGIN
		value := 0; ASSERT (~ODD (value)); ASSERT (ODD (value + 1));
		value := 5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
		value := -5; ASSERT (ODD (value)); ASSERT (~ODD (value + 1));
	END Test.

positive: BOOLEAN binary selection

	MODULE Test;
	CONST True = FALSE; False = TRUE;
	VAR condition: BOOLEAN; true, false: BOOLEAN;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: CHAR binary selection

	MODULE Test;
	CONST True = 2X; False = 4X;
	VAR condition: BOOLEAN; true, false: CHAR;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SIGNED8 binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: SIGNED8;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SIGNED16 binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: SIGNED16;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SIGNED32 binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: SIGNED32;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SIGNED64 binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: SIGNED64;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: UNSIGNED8 binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: UNSIGNED8;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: UNSIGNED16 binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: UNSIGNED16;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: UNSIGNED32 binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: UNSIGNED32;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: UNSIGNED64 binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: UNSIGNED64;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SHORTINT binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: SHORTINT;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: INTEGER binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: INTEGER;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: LONGINT binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: LONGINT;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: HUGEINT binary selection

	MODULE Test;
	CONST True = 2; False = 4;
	VAR condition: BOOLEAN; true, false: HUGEINT;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: REAL32 binary selection

	MODULE Test;
	CONST True = 2.5; False = 4.5;
	VAR condition: BOOLEAN; true, false: REAL32;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: REAL64 binary selection

	MODULE Test;
	CONST True = 2.5; False = 4.5;
	VAR condition: BOOLEAN; true, false: REAL64;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SHORTREAL binary selection

	MODULE Test;
	CONST True = 2.5; False = 4.5;
	VAR condition: BOOLEAN; true, false: SHORTREAL;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: REAL binary selection

	MODULE Test;
	CONST True = 2.5; False = 4.5;
	VAR condition: BOOLEAN; true, false: REAL;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: LONGREAL binary selection

	MODULE Test;
	CONST True = 2.5; False = 4.5;
	VAR condition: BOOLEAN; true, false: LONGREAL;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SET8 binary selection

	MODULE Test;
	CONST True = {2}; False = {4};
	VAR condition: BOOLEAN; true, false: SET8;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SET16 binary selection

	MODULE Test;
	CONST True = {2}; False = {4};
	VAR condition: BOOLEAN; true, false: SET16;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SET32 binary selection

	MODULE Test;
	CONST True = {2}; False = {4};
	VAR condition: BOOLEAN; true, false: SET32;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SET64 binary selection

	MODULE Test;
	CONST True = {2}; False = {4};
	VAR condition: BOOLEAN; true, false: SET64;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SHORTSET binary selection

	MODULE Test;
	CONST True = {2}; False = {4};
	VAR condition: BOOLEAN; true, false: SHORTSET;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: SET binary selection

	MODULE Test;
	CONST True = {2}; False = {4};
	VAR condition: BOOLEAN; true, false: SET;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: LONGSET binary selection

	MODULE Test;
	CONST True = {2}; False = {4};
	VAR condition: BOOLEAN; true, false: LONGSET;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: HUGESET binary selection

	MODULE Test;
	CONST True = {2}; False = {4};
	VAR condition: BOOLEAN; true, false: HUGESET;
	BEGIN
		true := True; false := False;
		condition := FALSE; ASSERT (SEL (condition, true, false) = False); ASSERT (SEL (condition, true, false) = SEL (FALSE, true, false)); ASSERT (SEL (condition, true, false) = SEL (FALSE, True, False));
		condition := TRUE; ASSERT (SEL (condition, true, false) = True); ASSERT (SEL (condition, true, false) = SEL (TRUE, true, false)); ASSERT (SEL (condition, true, false) = SEL (TRUE, True, False));
	END Test.

positive: short-circuit binary selection

	MODULE Test;
	PROCEDURE True (): BOOLEAN; BEGIN RETURN TRUE; END True;
	PROCEDURE False (): BOOLEAN; BEGIN RETURN FALSE; END False;
	PROCEDURE Halt (): BOOLEAN; BEGIN HALT (123); END Halt;
	BEGIN
		ASSERT (SEL (True (), False (), Halt ()) = FALSE);
		ASSERT (SEL (False (), Halt (), True ()) = TRUE);
	END Test.

positive: assertion with zero status

	MODULE Test;
	VAR condition: BOOLEAN;
	BEGIN condition := FALSE; ASSERT (condition, 0);
	END Test.

negative: assertion with non-zero status

	MODULE Test;
	VAR condition: BOOLEAN;
	BEGIN condition := FALSE; ASSERT (condition, 1);
	END Test.

positive: deallocation on pointer to array

	MODULE Test;
	VAR p: POINTER TO ARRAY 10 OF INTEGER;
	BEGIN NEW (p); ASSERT (p # NIL); DISPOSE (p); ASSERT (p = NIL);
	END Test.

positive: deallocation on pointer to open array

	MODULE Test;
	VAR p: POINTER TO ARRAY OF INTEGER;
	BEGIN NEW (p, 10); ASSERT (p # NIL); DISPOSE (p); ASSERT (p = NIL);
	END Test.

positive: deallocation on pointer to record

	MODULE Test;
	VAR p: POINTER TO RECORD a, b: INTEGER END;
	BEGIN NEW (p); ASSERT (p # NIL); DISPOSE (p); ASSERT (p = NIL);
	END Test.

positive: SIGNED8 decrement

	MODULE Test;
	VAR a, b, c: SIGNED8;
	BEGIN a := 0; b := 3; c := -4;
		DEC (a); ASSERT (a = -1); INC (a); ASSERT (a = 0);
		DEC (a, 2); ASSERT (a = -2); DEC (a, -2); ASSERT (a = 0);
		DEC (a, b); ASSERT (a = -b); DEC (a, -b); ASSERT (a = 0);
		DEC (a, c); ASSERT (a = -c); DEC (a, -c); ASSERT (a = 0);
	END Test.

positive: SIGNED16 decrement

	MODULE Test;
	VAR a, b, c: SIGNED16;
	BEGIN a := 0; b := 3; c := -4;
		DEC (a); ASSERT (a = -1); INC (a); ASSERT (a = 0);
		DEC (a, 2); ASSERT (a = -2); DEC (a, -2); ASSERT (a = 0);
		DEC (a, b); ASSERT (a = -b); DEC (a, -b); ASSERT (a = 0);
		DEC (a, c); ASSERT (a = -c); DEC (a, -c); ASSERT (a = 0);
	END Test.

positive: SIGNED32 decrement

	MODULE Test;
	VAR a, b, c: SIGNED32;
	BEGIN a := 0; b := 3; c := -4;
		DEC (a); ASSERT (a = -1); INC (a); ASSERT (a = 0);
		DEC (a, 2); ASSERT (a = -2); DEC (a, -2); ASSERT (a = 0);
		DEC (a, b); ASSERT (a = -b); DEC (a, -b); ASSERT (a = 0);
		DEC (a, c); ASSERT (a = -c); DEC (a, -c); ASSERT (a = 0);
	END Test.

positive: SIGNED64 decrement

	MODULE Test;
	VAR a, b, c: SIGNED64;
	BEGIN a := 0; b := 3; c := -4;
		DEC (a); ASSERT (a = -1); INC (a); ASSERT (a = 0);
		DEC (a, 2); ASSERT (a = -2); DEC (a, -2); ASSERT (a = 0);
		DEC (a, b); ASSERT (a = -b); DEC (a, -b); ASSERT (a = 0);
		DEC (a, c); ASSERT (a = -c); DEC (a, -c); ASSERT (a = 0);
	END Test.

positive: UNSIGNED8 decrement

	MODULE Test;
	VAR a: UNSIGNED8; b, c: SIGNED8;
	BEGIN a := 10; b := 3; c := -4;
		DEC (a); ASSERT (a = 9); INC (a); ASSERT (a = 10);
		DEC (a, 2); ASSERT (a = 8); DEC (a, -2); ASSERT (a = 10);
		DEC (a, b); ASSERT (a = 10 - b); DEC (a, -b); ASSERT (a = 10);
		DEC (a, c); ASSERT (a = 10 - c); DEC (a, -c); ASSERT (a = 10);
	END Test.

positive: UNSIGNED16 decrement

	MODULE Test;
	VAR a: UNSIGNED16; b, c: SIGNED16;
	BEGIN a := 10; b := 3; c := -4;
		DEC (a); ASSERT (a = 9); INC (a); ASSERT (a = 10);
		DEC (a, 2); ASSERT (a = 8); DEC (a, -2); ASSERT (a = 10);
		DEC (a, b); ASSERT (a = 10 - b); DEC (a, -b); ASSERT (a = 10);
		DEC (a, c); ASSERT (a = 10 - c); DEC (a, -c); ASSERT (a = 10);
	END Test.

positive: UNSIGNED32 decrement

	MODULE Test;
	VAR a: UNSIGNED32; b, c: SIGNED32;
	BEGIN a := 10; b := 3; c := -4;
		DEC (a); ASSERT (a = 9); INC (a); ASSERT (a = 10);
		DEC (a, 2); ASSERT (a = 8); DEC (a, -2); ASSERT (a = 10);
		DEC (a, b); ASSERT (a = 10 - b); DEC (a, -b); ASSERT (a = 10);
		DEC (a, c); ASSERT (a = 10 - c); DEC (a, -c); ASSERT (a = 10);
	END Test.

positive: UNSIGNED64 decrement

	MODULE Test;
	VAR a: UNSIGNED64; b, c: SIGNED64;
	BEGIN a := 10; b := 3; c := -4;
		DEC (a); ASSERT (a = 9); INC (a); ASSERT (a = 10);
		DEC (a, 2); ASSERT (a = 8); DEC (a, -2); ASSERT (a = 10);
		DEC (a, b); ASSERT (a = 10 - b); DEC (a, -b); ASSERT (a = 10);
		DEC (a, c); ASSERT (a = 10 - c); DEC (a, -c); ASSERT (a = 10);
	END Test.

positive: HUGEINT decrement

	MODULE Test;
	VAR a, b, c: HUGEINT;
	BEGIN a := 0; b := 3; c := -4;
		DEC (a); ASSERT (a = -1); INC (a); ASSERT (a = 0);
		DEC (a, 2); ASSERT (a = -2); DEC (a, -2); ASSERT (a = 0);
		DEC (a, b); ASSERT (a = -b); DEC (a, -b); ASSERT (a = 0);
		DEC (a, c); ASSERT (a = -c); DEC (a, -c); ASSERT (a = 0);
	END Test.

positive: SIGNED8 exclusion

	MODULE Test;
	VAR set: SET; element: SIGNED8;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: SIGNED16 exclusion

	MODULE Test;
	VAR set: SET; element: SIGNED16;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: SIGNED32 exclusion

	MODULE Test;
	VAR set: SET; element: SIGNED32;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: SIGNED64 exclusion

	MODULE Test;
	VAR set: SET; element: SIGNED64;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: UNSIGNED8 exclusion

	MODULE Test;
	VAR set: SET; element: UNSIGNED8;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: UNSIGNED16 exclusion

	MODULE Test;
	VAR set: SET; element: UNSIGNED16;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: UNSIGNED32 exclusion

	MODULE Test;
	VAR set: SET; element: UNSIGNED32;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: UNSIGNED64 exclusion

	MODULE Test;
	VAR set: SET; element: UNSIGNED64;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: HUGEINT exclusion

	MODULE Test;
	VAR set: SET; element: HUGEINT;
	BEGIN
		set := {}; element := MIN (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		set := {}; element := MAX (SET); EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MIN (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
		element := MAX (SET); set := {element}; EXCL (set, element); ASSERT (set = {}); ASSERT (~(element IN set));
	END Test.

positive: halt with zero status

	MODULE Test;
	BEGIN HALT (0);
	END Test.

negative: halt with non-zero status

	MODULE Test;
	BEGIN HALT (1);
	END Test.

positive: SIGNED8 increment

	MODULE Test;
	VAR a, b, c: SIGNED8;
	BEGIN a := 0; b := 3; c := -4;
		INC (a); ASSERT (a = 1); DEC (a); ASSERT (a = 0);
		INC (a, 2); ASSERT (a = 2); INC (a, -2); ASSERT (a = 0);
		INC (a, b); ASSERT (a = b); INC (a, -b); ASSERT (a = 0);
		INC (a, c); ASSERT (a = c); INC (a, -c); ASSERT (a = 0);
	END Test.

positive: SIGNED16 increment

	MODULE Test;
	VAR a, b, c: SIGNED16;
	BEGIN a := 0; b := 3; c := -4;
		INC (a); ASSERT (a = 1); DEC (a); ASSERT (a = 0);
		INC (a, 2); ASSERT (a = 2); INC (a, -2); ASSERT (a = 0);
		INC (a, b); ASSERT (a = b); INC (a, -b); ASSERT (a = 0);
		INC (a, c); ASSERT (a = c); INC (a, -c); ASSERT (a = 0);
	END Test.

positive: SIGNED32 increment

	MODULE Test;
	VAR a, b, c: SIGNED32;
	BEGIN a := 0; b := 3; c := -4;
		INC (a); ASSERT (a = 1); DEC (a); ASSERT (a = 0);
		INC (a, 2); ASSERT (a = 2); INC (a, -2); ASSERT (a = 0);
		INC (a, b); ASSERT (a = b); INC (a, -b); ASSERT (a = 0);
		INC (a, c); ASSERT (a = c); INC (a, -c); ASSERT (a = 0);
	END Test.

positive: SIGNED64 increment

	MODULE Test;
	VAR a, b, c: SIGNED64;
	BEGIN a := 0; b := 3; c := -4;
		INC (a); ASSERT (a = 1); DEC (a); ASSERT (a = 0);
		INC (a, 2); ASSERT (a = 2); INC (a, -2); ASSERT (a = 0);
		INC (a, b); ASSERT (a = b); INC (a, -b); ASSERT (a = 0);
		INC (a, c); ASSERT (a = c); INC (a, -c); ASSERT (a = 0);
	END Test.

positive: UNSIGNED8 increment

	MODULE Test;
	VAR a: UNSIGNED8; b, c: SIGNED8;
	BEGIN a := 10; b := 3; c := -4;
		INC (a); ASSERT (a = 11); DEC (a); ASSERT (a = 10);
		INC (a, 2); ASSERT (a = 12); INC (a, -2); ASSERT (a = 10);
		INC (a, b); ASSERT (a = 10 + b); INC (a, -b); ASSERT (a = 10);
		INC (a, c); ASSERT (a = 10 + c); INC (a, -c); ASSERT (a = 10);
	END Test.

positive: UNSIGNED16 increment

	MODULE Test;
	VAR a: UNSIGNED16; b, c: SIGNED16;
	BEGIN a := 10; b := 3; c := -4;
		INC (a); ASSERT (a = 11); DEC (a); ASSERT (a = 10);
		INC (a, 2); ASSERT (a = 12); INC (a, -2); ASSERT (a = 10);
		INC (a, b); ASSERT (a = 10 + b); INC (a, -b); ASSERT (a = 10);
		INC (a, c); ASSERT (a = 10 + c); INC (a, -c); ASSERT (a = 10);
	END Test.

positive: UNSIGNED32 increment

	MODULE Test;
	VAR a: UNSIGNED32; b, c: SIGNED32;
	BEGIN a := 10; b := 3; c := -4;
		INC (a); ASSERT (a = 11); DEC (a); ASSERT (a = 10);
		INC (a, 2); ASSERT (a = 12); INC (a, -2); ASSERT (a = 10);
		INC (a, b); ASSERT (a = 10 + b); INC (a, -b); ASSERT (a = 10);
		INC (a, c); ASSERT (a = 10 + c); INC (a, -c); ASSERT (a = 10);
	END Test.

positive: UNSIGNED64 increment

	MODULE Test;
	VAR a: UNSIGNED64; b, c: SIGNED64;
	BEGIN a := 10; b := 3; c := -4;
		INC (a); ASSERT (a = 11); DEC (a); ASSERT (a = 10);
		INC (a, 2); ASSERT (a = 12); INC (a, -2); ASSERT (a = 10);
		INC (a, b); ASSERT (a = 10 + b); INC (a, -b); ASSERT (a = 10);
		INC (a, c); ASSERT (a = 10 + c); INC (a, -c); ASSERT (a = 10);
	END Test.

positive: HUGEINT increment

	MODULE Test;
	VAR a, b, c: HUGEINT;
	BEGIN a := 0; b := 3; c := -4;
		INC (a); ASSERT (a = 1); DEC (a); ASSERT (a = 0);
		INC (a, 2); ASSERT (a = 2); INC (a, -2); ASSERT (a = 0);
		INC (a, b); ASSERT (a = b); INC (a, -b); ASSERT (a = 0);
		INC (a, c); ASSERT (a = c); INC (a, -c); ASSERT (a = 0);
	END Test.

positive: SIGNED8 inclusion

	MODULE Test;
	VAR set: SET; element: SIGNED8;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: SIGNED16 inclusion

	MODULE Test;
	VAR set: SET; element: SIGNED16;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: SIGNED32 inclusion

	MODULE Test;
	VAR set: SET; element: SIGNED32;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: SIGNED64 inclusion

	MODULE Test;
	VAR set: SET; element: SIGNED64;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: UNSIGNED8 inclusion

	MODULE Test;
	VAR set: SET; element: UNSIGNED8;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: UNSIGNED16 inclusion

	MODULE Test;
	VAR set: SET; element: UNSIGNED16;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: UNSIGNED32 inclusion

	MODULE Test;
	VAR set: SET; element: UNSIGNED32;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: UNSIGNED64 inclusion

	MODULE Test;
	VAR set: SET; element: UNSIGNED64;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

positive: HUGEINT inclusion

	MODULE Test;
	VAR set: SET; element: HUGEINT;
	BEGIN
		set := {}; element := MIN (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		set := {}; element := MAX (SET); INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
		element := MIN (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MIN (SET)}); ASSERT (element IN set);
		element := MAX (SET); set := {element}; INCL (set, element); ASSERT (set = {element}); ASSERT (set = {MAX (SET)}); ASSERT (element IN set);
	END Test.

# 11. Modules

positive: generic module import

	MODULE Test;
	IMPORT First := Generic (INTEGER, 10), Second := Generic (CHAR, 20H);
	BEGIN ASSERT (First.variable[0] = 10); ASSERT (Second.variable[0] = 20X);
	END Test.

# C: The module SYSTEM

positive: SIGNED8 logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SIGNED8;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
		a := 6; b := -2; ASSERT (SYSTEM.LSH (a, b) = 1); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, -2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, -2));
		a := -6; b := 2; ASSERT (SYSTEM.LSH (a, b) = -24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 2));
		a := -6; b := 0; ASSERT (SYSTEM.LSH (a, b) = -6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 0));
	END Test.

positive: SIGNED16 logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SIGNED16;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
		a := 6; b := -2; ASSERT (SYSTEM.LSH (a, b) = 1); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, -2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, -2));
		a := -6; b := 2; ASSERT (SYSTEM.LSH (a, b) = -24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 2));
		a := -6; b := 0; ASSERT (SYSTEM.LSH (a, b) = -6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 0));
	END Test.

positive: SIGNED32 logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SIGNED32;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
		a := 6; b := -2; ASSERT (SYSTEM.LSH (a, b) = 1); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, -2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, -2));
		a := -6; b := 2; ASSERT (SYSTEM.LSH (a, b) = -24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 2));
		a := -6; b := 0; ASSERT (SYSTEM.LSH (a, b) = -6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 0));
	END Test.

positive: SIGNED64 logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SIGNED64;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
		a := 6; b := -2; ASSERT (SYSTEM.LSH (a, b) = 1); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, -2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, -2));
		a := -6; b := 2; ASSERT (SYSTEM.LSH (a, b) = -24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 2));
		a := -6; b := 0; ASSERT (SYSTEM.LSH (a, b) = -6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 0));
	END Test.

positive: UNSIGNED8 logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
	END Test.

positive: UNSIGNED16 logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
	END Test.

positive: UNSIGNED32 logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
	END Test.

positive: UNSIGNED64 logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
	END Test.

positive: SHORTINT logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SHORTINT;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
		a := 6; b := -2; ASSERT (SYSTEM.LSH (a, b) = 1); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, -2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, -2));
		a := -6; b := 2; ASSERT (SYSTEM.LSH (a, b) = -24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 2));
		a := -6; b := 0; ASSERT (SYSTEM.LSH (a, b) = -6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 0));
	END Test.

positive: LONGINT logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: LONGINT;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
		a := 6; b := -2; ASSERT (SYSTEM.LSH (a, b) = 1); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, -2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, -2));
		a := -6; b := 2; ASSERT (SYSTEM.LSH (a, b) = -24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 2));
		a := -6; b := 0; ASSERT (SYSTEM.LSH (a, b) = -6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 0));
	END Test.

positive: HUGEINT logical shift

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: HUGEINT;
	BEGIN
		a := 6; b := 2; ASSERT (SYSTEM.LSH (a, b) = 24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 2));
		a := 6; b := 0; ASSERT (SYSTEM.LSH (a, b) = 6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, 0));
		a := 6; b := -2; ASSERT (SYSTEM.LSH (a, b) = 1); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, -2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (6, -2));
		a := -6; b := 2; ASSERT (SYSTEM.LSH (a, b) = -24); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 2)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 2));
		a := -6; b := 0; ASSERT (SYSTEM.LSH (a, b) = -6); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (a, 0)); ASSERT (SYSTEM.LSH (a, b) = SYSTEM.LSH (-6, 0));
	END Test.

positive: SIGNED8 rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SIGNED8;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
		a := 4; b := -2; ASSERT (SYSTEM.ROT (a, b) = 1); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, -2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, -2));
	END Test.

positive: SIGNED16 rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SIGNED16;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
		a := 4; b := -2; ASSERT (SYSTEM.ROT (a, b) = 1); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, -2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, -2));
	END Test.

positive: SIGNED32 rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SIGNED32;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
		a := 4; b := -2; ASSERT (SYSTEM.ROT (a, b) = 1); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, -2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, -2));
	END Test.

positive: SIGNED64 rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: SIGNED64;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
		a := 4; b := -2; ASSERT (SYSTEM.ROT (a, b) = 1); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, -2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, -2));
	END Test.

positive: UNSIGNED8 rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: UNSIGNED8;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
	END Test.

positive: UNSIGNED16 rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: UNSIGNED16;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
	END Test.

positive: UNSIGNED32 rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: UNSIGNED32;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
	END Test.

positive: UNSIGNED64 rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: UNSIGNED64;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
	END Test.

positive: INTEGER rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: INTEGER;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
		a := 4; b := -2; ASSERT (SYSTEM.ROT (a, b) = 1); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, -2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, -2));
	END Test.

positive: LONGINT rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: LONGINT;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
		a := 4; b := -2; ASSERT (SYSTEM.ROT (a, b) = 1); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, -2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, -2));
	END Test.

positive: HUGEINT rotation

	MODULE Test;
	IMPORT SYSTEM;
	VAR a, b: HUGEINT;
	BEGIN
		a := 4; b := 2; ASSERT (SYSTEM.ROT (a, b) = 16); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 2));
		a := 4; b := 0; ASSERT (SYSTEM.ROT (a, b) = 4); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, 0)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, 0));
		a := 4; b := -2; ASSERT (SYSTEM.ROT (a, b) = 1); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (a, -2)); ASSERT (SYSTEM.ROT (a, b) = SYSTEM.ROT (4, -2));
	END Test.

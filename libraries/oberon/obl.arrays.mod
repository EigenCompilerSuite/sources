(* Generic arrays
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

(** The generic module {{{Arrays}}} provides an iterator type for iterating over arrays of type {{{[[OBL:Arrays.Element|Element]]}}}. *)
(** @@Element The type of an element contained in an array. *)
MODULE Arrays (Element*) IN OBL;

IMPORT Iterators (Element) IN OBL;

(** Represents an iteration over an array. *)
TYPE Iterator* = RECORD- (Iterators.Iterator) pointer: POINTER TO VAR- ARRAY OF Element; index: LENGTH END;

(** Fills the array in the range [{{{begin}}}, {{{end}}}) with the given value. *)
PROCEDURE Fill* (VAR array: ARRAY OF Element; begin, end: LENGTH; value-: Element);
BEGIN WHILE begin # end DO array[begin] := value; INC (begin) END;
END Fill;

(** Reverses the order of the elements of the array in the range [{{{begin}}}, {{{end}}}) using the given element swap operation. *)
PROCEDURE Reverse* (VAR array: ARRAY OF Element; begin, end: LENGTH; swap: PROCEDURE (VAR left, right: Element));
BEGIN DEC (end); WHILE begin < end DO swap (array[begin], array[end]); INC (begin); DEC (end) END;
END Reverse;

(** Sorts the array in the range [{{{begin}}}, {{{end}}}) with the given element ordering and swap operation. *)
PROCEDURE Sort* (VAR array: ARRAY OF Element; begin, end: LENGTH; compare: PROCEDURE (left-, right-: Element): BOOLEAN; swap: PROCEDURE (VAR left, right: Element));
VAR pivot, left, right: LENGTH;
BEGIN
	IF end - begin < 2 THEN RETURN END;
	pivot := (begin + end) DIV 2; left := begin; right := end - 1;
	LOOP
		WHILE compare (array[left], array[pivot]) DO INC (left) END;
		WHILE compare (array[pivot], array[right]) DO DEC (right) END;
		IF left >= right THEN EXIT END;
		IF left = pivot THEN pivot := right ELSIF right = pivot THEN pivot := left END;
		swap (array[left], array[right]); INC (left); DEC (right);
	END;
	Sort (array, begin, left, compare, swap); Sort (array, left, end, compare, swap);
END Sort;

(** Returns whether the array is sorted in the range [{{{begin}}}, {{{end}}}) with the given element ordering. *)
PROCEDURE IsSorted* (array-: ARRAY OF Element; begin, end: LENGTH; compare: PROCEDURE (left-, right-: Element): BOOLEAN): BOOLEAN;
BEGIN IF end - begin >= 2 THEN INC (begin); REPEAT IF compare (array[begin], array[begin - 1]) THEN RETURN FALSE END; INC (begin) UNTIL begin = end END; RETURN TRUE;
END IsSorted;

(** Returns an iterator for the given open array. *)
PROCEDURE GetIterator* (array-: ARRAY OF Element; VAR iterator: Iterator);
BEGIN iterator.pointer := PTR (array); iterator.index := 0;
END GetIterator;

(** Returns the next element in the array iteration if available as indicated by the boolean result. *)
PROCEDURE (VAR iterator: Iterator) GetNext* (VAR element: Element): BOOLEAN;
BEGIN IF (iterator.pointer # NIL) & (iterator.index # LEN (iterator.pointer^)) THEN element := iterator.pointer[iterator.index]; INC (iterator.index); RETURN TRUE END; RETURN FALSE;
END GetNext;

END Arrays.

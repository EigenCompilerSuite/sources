(* Generic dynamic arrays
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

(** The generic module {{{DynamicArrays}}} provides an iterator type for iterating over dynamic arrays of type {{{[[OBL:DynamicArrays.Element|Element]]}}}. *)
(** @@Element The type of an element contained in an array. *)
MODULE DynamicArrays (Element*) IN OBL;

IMPORT SYSTEM, Arrays (Element) IN OBL, Exceptions IN OBL, Iterators (Element) IN OBL;

TYPE Pointer = POINTER TO ARRAY OF Element;

(** Represents a dynamic array container with a dynamic size. *)
TYPE Array* = RECORD- pointer: Pointer; size: LENGTH END;

(** Represents an iteration over a dynamic array. *)
TYPE Iterator* = RECORD- (Iterators.Iterator) pointer: POINTER TO VAR- ARRAY OF Element; index: LENGTH END;

(** Reserves space for {{{size}}} array elements. *)
(** This procedure may raise an exception of type {{{[[OBL:Exceptions.AllocationFailure|AllocationFailure]]}}}. *)
PROCEDURE (VAR array: Array) Reserve* (size: LENGTH);
VAR pointer: Pointer; exception: Exceptions.AllocationFailure;
BEGIN
	IF array.pointer = NIL THEN
		NEW (array.pointer, size);
		IF array.pointer = NIL THEN exception.Raise END;
		array.size := 0;
	ELSIF size > LEN (array.pointer^) THEN
		NEW (pointer, size);
		IF pointer = NIL THEN exception.Raise END;
		SYSTEM.MOVE (SYSTEM.ADR (array.pointer^), SYSTEM.ADR (pointer^), array.size * SIZE (Element));
		DISPOSE (array.pointer);
		array.pointer := pointer;
	END;
END Reserve;

(** Appends the specified element to the end of the array. *)
(** This procedure may raise an exception of type {{{[[OBL:Exceptions.AllocationFailure|AllocationFailure]]}}}. *)
PROCEDURE (VAR array: Array) Add* (element-: Element);
BEGIN IF array.pointer = NIL THEN array.Reserve (8) ELSIF array.size = LEN (array.pointer^) THEN array.Reserve (array.size * 2) END; array.pointer[array.size] := element; INC (array.size);
END Add;

(** Removes all elements from the array. *)
(** This procedure must be called when an array variable goes out of scope in order to deallocate its elements. *)
PROCEDURE (VAR array: Array) Clear*;
BEGIN IF array.pointer # NIL THEN DISPOSE (array.pointer) END;
END Clear;

(** Returns the size of the array. *)
PROCEDURE (VAR array-: Array) GetSize* (): LENGTH;
BEGIN RETURN SEL (array.pointer # NIL, array.size, 0);
END GetSize;

(** Returns whether the array is empty. *)
PROCEDURE (VAR array-: Array) IsEmpty* (): BOOLEAN;
BEGIN RETURN array.pointer = NIL;
END IsEmpty;

(** Returns the element at the specified position in the array. *)
PROCEDURE (VAR array-: Array) GetElement* (index: LENGTH): Element;
BEGIN RETURN array.pointer[index];
END GetElement;

(** Replaces the element at the specified position in the array. *)
PROCEDURE (VAR array: Array) SetElement* (index: LENGTH; element-: Element);
BEGIN array.pointer[index] := element;
END SetElement;

(** Returns an iterator for the array. *)
PROCEDURE (VAR array-: Array) GetIterator* (VAR iterator: Iterator);
BEGIN IF array.pointer # NIL THEN iterator.pointer := PTR (array.pointer^); iterator.index := 0 ELSE iterator.pointer := NIL END;
END GetIterator;

(** Fills the array in the range [{{{begin}}}, {{{end}}}) with the given value. *)
PROCEDURE (VAR array: Array) Fill* (begin, end: LENGTH; value-: Element);
BEGIN IF begin # end THEN Arrays.Fill (array.pointer^, begin, end, value) END;
END Fill;

(** Reverses the order of the elements of the array in the range [{{{begin}}}, {{{end}}}) using the given element swap operation. *)
PROCEDURE (VAR array: Array) Reverse* (begin, end: LENGTH; swap: PROCEDURE (VAR left, right: Element));
BEGIN IF begin # end THEN Arrays.Reverse (array.pointer^, begin, end, swap) END;
END Reverse;

(** Sorts the array in the range [{{{begin}}}, {{{end}}}) with the given element ordering and swap operation. *)
PROCEDURE (VAR array: Array) Sort* (begin, end: LENGTH; compare: PROCEDURE (left-, right-: Element): BOOLEAN; swap: PROCEDURE (VAR left, right: Element));
BEGIN IF begin # end THEN Arrays.Sort (array.pointer^, begin, end, compare, swap) END;
END Sort;

(** Returns whether the array is sorted in the range [{{{begin}}}, {{{end}}}) with the given element ordering. *)
PROCEDURE (VAR array: Array) IsSorted* (begin, end: LENGTH; compare: PROCEDURE (left-, right-: Element): BOOLEAN): BOOLEAN;
BEGIN IF begin # end THEN RETURN Arrays.IsSorted (array.pointer^, begin, end, compare) END; RETURN TRUE;
END IsSorted;

(** Returns the next element in the array iteration if available as indicated by the boolean result. *)
PROCEDURE (VAR iterator: Iterator) GetNext* (VAR element: Element): BOOLEAN;
BEGIN IF (iterator.pointer # NIL) & (iterator.index # LEN (iterator.pointer^)) THEN element := iterator.pointer[iterator.index]; INC (iterator.index); RETURN TRUE END; RETURN FALSE;
END GetNext;

(** Exchanges the contents of an array with that of another one. *)
PROCEDURE Swap* (VAR first, second: Array);
VAR pointer: Pointer; size: LENGTH;
BEGIN pointer := first.pointer; size := first.size; first.pointer := second.pointer; first.size := second.size; second.pointer := pointer; second.size := size;
END Swap;

END DynamicArrays.

(* Generic lists
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

(** The generic module {{{Lists}}} provides an iterator type for iterating over lists of type {{{[[OBL:Lists.Element|Element]]}}}. *)
(** @@Element The type of an element contained in a list. *)
MODULE Lists (Element*) IN OBL;

IMPORT Exceptions IN OBL, Iterators (Element) IN OBL;

TYPE Item = RECORD- next: POINTER TO Item; element: Element END;

(** Represents a list container. *)
TYPE List* = RECORD- first, last: POINTER TO Item; size: LENGTH END;

(** Represents an iteration over a list. *)
TYPE Iterator* = RECORD- (Iterators.Iterator) item: POINTER TO Item END;

(** Appends the specified element to the end of the list. *)
(** This procedure may raise an exception of type {{{[[OBL:Exceptions.AllocationFailure|AllocationFailure]]}}}. *)
PROCEDURE (VAR list: List) Add* (element-: Element);
VAR item: POINTER TO Item; exception: Exceptions.AllocationFailure;
BEGIN NEW (item); IF item = NIL THEN exception.Raise END; item.element := element; IF list.last # NIL THEN list.last.next := item; INC (list.size) ELSE list.first := item; list.size := 1 END; list.last := item;
END Add;

(** Removes all elements from the list. *)
(** This procedure must be called when a list variable goes out of scope in order to deallocate its elements. *)
PROCEDURE (VAR list: List) Clear*;
VAR item, next: POINTER TO Item;
BEGIN item := list.first; WHILE item # NIL DO next := item.next; DISPOSE (item); item := next END; list.first := NIL; list.last := NIL;
END Clear;

(** Reverses the order of the elements of the list. *)
PROCEDURE (VAR list: List) Reverse*;
VAR item, previous, next: POINTER TO Item;
BEGIN item := list.first; list.last := item; WHILE item # NIL DO next := item.next; item.next := previous; previous := item; item := next END; list.first := previous;
END Reverse;

(** Returns the size of the list. *)
PROCEDURE (VAR list-: List) GetSize* (): LENGTH;
BEGIN RETURN SEL (list.first # NIL, list.size, 0);
END GetSize;

(** Returns whether the list is empty. *)
PROCEDURE (VAR list-: List) IsEmpty* (): BOOLEAN;
BEGIN RETURN list.first = NIL;
END IsEmpty;

(** Returns the element at the specified position in the list. *)
PROCEDURE (VAR list-: List) GetElement* (index: LENGTH): Element;
VAR item: POINTER TO Item;
BEGIN item := list.first; WHILE index # 0 DO DEC (index); item := item.next END; RETURN item.element;
END GetElement;

(** Replaces the element at the specified position in the list. *)
PROCEDURE (VAR list: List) SetElement* (index: LENGTH; element-: Element);
VAR item: POINTER TO Item;
BEGIN item := list.first; WHILE index # 0 DO DEC (index); item := item.next END; item.element := element;
END SetElement;

(** Returns an iterator for the list. *)
PROCEDURE (VAR list-: List) GetIterator* (VAR iterator: Iterator);
BEGIN iterator.item := list.first;
END GetIterator;

(** Returns the next element in the list iteration if available as indicated by the boolean result. *)
PROCEDURE (VAR iterator: Iterator) GetNext* (VAR element: Element): BOOLEAN;
BEGIN IF iterator.item # NIL THEN element := iterator.item.element; iterator.item := iterator.item.next; RETURN TRUE END; RETURN FALSE;
END GetNext;

(** Exchanges the contents of a list with that of another one. *)
PROCEDURE Swap* (VAR first, second: List);
VAR first_, last: POINTER TO Item; size: LENGTH;
BEGIN first_ := first.first; last := first.last; size := first.size; first.first := second.first; first.last := second.last; first.size := second.size; second.first := first_; second.last := last; second.size := size;
END Swap;

END Lists.

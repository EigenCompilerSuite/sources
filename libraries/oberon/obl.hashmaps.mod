(* Generic hash maps
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

(** The generic module {{{HashMaps}}} provides a hash table that maps key of type {{{[[OBL:HashMaps.Key|Key]]}}} to values of type {{{[[OBL:HashMaps.Value|Value]]}}}. *)
(** @@Key The type of a key associated with an element in a hash map. *)
(** @@Value The type of a value associated with an element in a hash map. *)
(** @@Hash The hash function for keys in a hash map. *)
MODULE HashMaps (Key*, Value*, Hash*) IN OBL;

IMPORT Exceptions IN OBL, Pairs (Key, Value) IN OBL, Iterators (Pairs.Pair) IN OBL, Lists (Pairs.Pair) IN OBL;

TYPE Bucket = Lists.List;
TYPE Buckets = ARRAY OF Bucket;

(** Represents an element of a hash map. *)
TYPE Element* = Pairs.Pair;

(** A hash map as to be created using {{{[[OBL:HashMaps.Map.New|New]]}}} and disposed using {{{[[OBL:HashMaps.Map.Dispose|Dispose]]}}}. *)
TYPE Map* = RECORD- buckets: POINTER TO Buckets; size: LENGTH END;

(** Represents an iteration over a list. *)
TYPE Iterator* = RECORD- (Iterators.Iterator) buckets: POINTER TO Buckets; index: LENGTH; iterator: Lists.Iterator END;

(** Creates a new hash map with the specified capacity. *)
(** This procedure may raise an exception of type {{{[[OBL:Exceptions.AllocationFailure|AllocationFailure]]}}}. *)
PROCEDURE (VAR map: Map) New* (capacity: LENGTH);
VAR exception: Exceptions.AllocationFailure;
BEGIN NEW (map.buckets, capacity); IF map.buckets = NIL THEN exception.Raise END; map.size := 0;
END New;

(** Adds an element with the specified key and value to the hash map. *)
(** This procedure may raise an exception of type {{{[[OBL:Exceptions.AllocationFailure|AllocationFailure]]}}}. *)
PROCEDURE (VAR map: Map) Add* (key-: Key; value-: Value);
BEGIN map.buckets[Hash (key) MOD LEN (map.buckets^)].Add (Pairs.Make (key, value)); INC (map.size);
END Add;

(** Removes all elements from the hash map. *)
PROCEDURE (VAR map: Map) Clear*;
VAR index: LENGTH;
BEGIN FOR index := 0 TO LEN (map.buckets^) - 1 DO map.buckets[index].Clear END; map.size := 0;
END Clear;

(** Returns whether the hash map contains an element with the specified key. *)
PROCEDURE (VAR map-: Map) Contains* (key-: Key): BOOLEAN;
BEGIN RETURN ~map.buckets[Hash (key) MOD LEN (map.buckets^)].IsEmpty ();
END Contains;

(** Returns an iterator for all elements with the specified key. *)
PROCEDURE (VAR map-: Map) Find* (key-: Key; VAR iterator: Lists.Iterator);
BEGIN map.buckets[Hash (key) MOD LEN (map.buckets^)].GetIterator (iterator);
END Find;

(** Returns the value of the element with the specified key if available. *)
PROCEDURE (VAR map-: Map) Lookup* (key-: Key; VAR value: Value): BOOLEAN;
VAR iterator: Lists.Iterator; element: Element;
BEGIN map.Find (key, iterator); IF iterator.GetNext (element) THEN value := element.second; RETURN TRUE END; RETURN FALSE;
END Lookup;

(** Returns the number of elements in the hash map. *)
PROCEDURE (VAR map-: Map) GetSize* (): LENGTH;
BEGIN RETURN map.size;
END GetSize;

(** Returns the capacity of the hash map. *)
PROCEDURE (VAR map-: Map) GetCapacity* (): LENGTH;
BEGIN RETURN LEN (map.buckets^);
END GetCapacity;

(** Returns the load factor of the hash map. *)
PROCEDURE (VAR map-: Map) GetLoadFactor* (): REAL;
BEGIN RETURN map.size / LEN (map.buckets^);
END GetLoadFactor;

(** Disposes a previously created hash map. *)
(** This procedure must be called when a hash map variable goes out of scope in order to deallocate its hash table. *)
PROCEDURE (VAR map: Map) Dispose*;
BEGIN map.Clear; DISPOSE (map.buckets);
END Dispose;

(** Returns an iterator for the hash map. *)
PROCEDURE (VAR map-: Map) GetIterator* (VAR iterator: Iterator);
BEGIN iterator.buckets := map.buckets; iterator.index := 0; iterator.buckets[0].GetIterator (iterator.iterator);
END GetIterator;

(** Returns the next element in the hash map iteration if available as indicated by the boolean result. *)
PROCEDURE (VAR iterator: Iterator) GetNext* (VAR element: Element): BOOLEAN;
BEGIN IF iterator.iterator.GetNext (element) THEN RETURN TRUE END;
	REPEAT INC (iterator.index) UNTIL (iterator.index = LEN (iterator.buckets^)) OR ~iterator.buckets[iterator.index].IsEmpty ();
	IF iterator.index = LEN (iterator.buckets^) THEN RETURN FALSE END;
	iterator.buckets[iterator.index].GetIterator (iterator.iterator);
	RETURN iterator.iterator.GetNext (element);
END GetNext;

(** Exchanges the contents of a hash map with that of another one. *)
PROCEDURE Swap* (VAR first, second: Map);
VAR buckets: POINTER TO Buckets; size: LENGTH;
BEGIN buckets := first.buckets; size := first.size; first.buckets := second.buckets; first.size := second.size; second.buckets := buckets; second.size := size;
END Swap;

END HashMaps.

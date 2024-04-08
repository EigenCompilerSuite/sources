(* Generic functions
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

(** The generic module {{{Functions}}} provides generators that yield a value of type {{{[[OBL:Functions.Result|Result]]}}}. *)
(** Functions are extensions of {{{[[OBL:Functions.Function|Function]]}}} that represent their parameters and results as fields. *)
(** @@Result The type of the result returned by functions. *)
MODULE Functions (Result*) IN OBL;

IMPORT Generators IN OBL, Iterators (Result) IN OBL;

(** Represents a generator that may return a result multiple times to its caller. *)
TYPE Function* = RECORD* (Generators.Generator)
	(** The result of a function call. *)
	result-: POINTER TO VAR- Result;
END;

(** Represents a function that filters all results from another function for which the predicate is satisfied. *)
TYPE Filter* = RECORD- (Function)
	(** The function to filter results from. *)
	function*: POINTER TO VAR Function;
	(** The predicate used for filter results. *)
	predicate*: PROCEDURE (value-: Result): BOOLEAN;
END;

(** Represents a function that takes a number of results from another function. *)
TYPE Take* = RECORD- (Function)
	(** The function to take results from. *)
	function*: POINTER TO VAR Function;
	(** The number of results. *)
	count*: LENGTH;
END;

(** Represents a function that iterates over an iterator. *)
TYPE Iterate* = RECORD- (Function)
	(** The iterator to iterate over. *)
	iterator*: POINTER TO VAR Iterators.Iterator;
END;

(** Represents an iterator over the results of calling a function. *)
TYPE Iterator* = RECORD- (Iterators.Iterator)
	(** The function to call. *)
	function*: POINTER TO VAR Function;
END;

(** Returns {{{result}}} to the caller of the function. *)
PROCEDURE- (VAR function: Function) Return* (result-: Result);
BEGIN function.result := PTR (result); function.Yield;
END Return;

(** Filters all results from another function for which the predicate is satisfied. *)
PROCEDURE (VAR filter: Filter) Call*;
BEGIN
	WHILE filter.function.Await () DO
		IF filter.predicate (filter.function.result^) THEN
			filter.Return (filter.function.result^);
		END;
	END;
END Call;

(** Takes the specified number of results from another function. *)
PROCEDURE (VAR take: Take) Call*;
VAR count: LENGTH;
BEGIN
	count := 0;
	WHILE take.function.Await () DO
		IF count # take.count THEN
			INC (count);
			take.Return (take.function.result^);
		END;
	END;
END Call;

(** Iterates over the specified iterator. *)
PROCEDURE (VAR iterate: Iterate) Call*;
VAR element: Result;
BEGIN WHILE iterate.iterator.GetNext (element) DO iterate.Return (element) END;
END Call;

(** Returns the next element in the function iteration if available as indicated by the boolean result. *)
PROCEDURE (VAR iterator: Iterator) GetNext* (VAR element: Result): BOOLEAN;
BEGIN IF iterator.function.Await () THEN element := iterator.function.result^; RETURN TRUE END; RETURN FALSE;
END GetNext;

END Functions.

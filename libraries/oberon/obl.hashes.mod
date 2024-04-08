(* Generic hash functions
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

(** The module {{{Hashes}}} provides utility procedures to calculate and combine hashes of arbitrary values. *)
MODULE Hashes IN OBL;

IMPORT SYSTEM;

(** Combines two hashes. *)
PROCEDURE Combine* (VAR seed: LENGTH; hash: LENGTH);
BEGIN seed := LENGTH (SYSTEM.SET (hash + LENGTH (9E3779B9H) + SYSTEM.LSH (seed, 6) + SYSTEM.LSH (seed, -2)) / SYSTEM.SET (seed));
END Combine;

(** Calculates the hash of {{{value}}}. *)
PROCEDURE Hash* (VAR value-: ARRAY OF SYSTEM.BYTE): LENGTH;
VAR seed, i: LENGTH;
BEGIN seed := 0; FOR i := 0 TO LEN (value) - 1 DO Combine (seed, LENGTH (value[i])) END; RETURN seed;
END Hash;

END Hashes.

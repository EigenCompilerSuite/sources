(* Generic file operations
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

(** The module {{{Files}}} provides a generic file operations. *)
MODULE Files IN OBL;

IMPORT SYSTEM, Devices IN OBL;

CONST EOF = -1;

(** Represents a file. *)
TYPE File* = RECORD- (Devices.Device) stream: SYSTEM.PTR END;

PROCEDURE ^ fclose ["fclose"] (file: SYSTEM.PTR): INTEGER;
PROCEDURE ^ fopen ["fopen"] (filename: POINTER TO VAR- CHAR; mode: POINTER TO VAR- CHAR): SYSTEM.PTR;
PROCEDURE ^ fread ["fread"] (buffer: SYSTEM.ADDRESS; size: SYSTEM.ADDRESS; count: SYSTEM.ADDRESS; stream: SYSTEM.PTR): SYSTEM.ADDRESS;
PROCEDURE ^ fwrite ["fwrite"] (buffer: SYSTEM.ADDRESS; size: SYSTEM.ADDRESS; count: SYSTEM.ADDRESS; stream: SYSTEM.PTR): SYSTEM.ADDRESS;

(** Opens a file using the specified mode and returns wether the operation was successful. *)
PROCEDURE (VAR file: File) Open* (filename-: ARRAY OF CHAR; write: BOOLEAN): BOOLEAN;
VAR mode: ARRAY 2 OF CHAR;
BEGIN IF write THEN mode := "w" ELSE mode := "r" END; file.stream := fopen (PTR (filename[0]), PTR (mode[0])); RETURN file.stream # NIL;
END Open;

(** Reads arbitrary data from the file and returns wether the operation was successful. *)
PROCEDURE (VAR file: File) Read* (VAR data: ARRAY OF SYSTEM.BYTE): BOOLEAN;
BEGIN RETURN fread (SYSTEM.ADR (data), SIZE (SYSTEM.BYTE), LEN (data), file.stream) = LEN (data);
END Read;

(** Writes arbitrary data to the file and returns wether the operation was successful. *)
PROCEDURE (VAR file: File) Write* (VAR data-: ARRAY OF SYSTEM.BYTE): BOOLEAN;
BEGIN RETURN fwrite (SYSTEM.ADR (data), SIZE (SYSTEM.BYTE), LEN (data), file.stream) = LEN (data);
END Write;

(** Closes the file and returns wether the operation was successful. *)
PROCEDURE (VAR file: File) Close* (): BOOLEAN;
BEGIN RETURN fclose (file.stream) # EOF;
END Close;

END Files.

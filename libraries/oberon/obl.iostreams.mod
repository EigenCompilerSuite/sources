(* Standard I/O Streams
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

(** The module {{{IOStreams}}} provides a standard I/O streams. *)
MODULE IOStreams IN OBL;

IMPORT SYSTEM, Devices IN OBL, Files IN OBL;

TYPE Stream = RECORD (Devices.Device) file: Files.File; END;

(** The standard error stream. *)
VAR ^ stderr* ["_stderr"]: Stream;

(** The standard input stream. *)
VAR ^ stdin* ["_stdin"]: Stream;

(** The standard output stream. *)
VAR ^ stdout* ["_stdout"]: Stream;

PROCEDURE (VAR stream: Stream) Read* (VAR data: ARRAY OF SYSTEM.BYTE): BOOLEAN;
BEGIN RETURN stream.file.Read (data);
END Read;

PROCEDURE (VAR stream: Stream) Write* (VAR data-: ARRAY OF SYSTEM.BYTE): BOOLEAN;
BEGIN RETURN stream.file.Write (data);
END Write;

END IOStreams.

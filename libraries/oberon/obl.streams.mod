(* Standard Oberon streams
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

(** The module {{{Streams}}} provides abstract stream types for reading and writing characters of type {{{[[OBL:Streams.Character|Character]]}}}. *)
(** @@Character The character type used for input and output. *)
MODULE Streams (Character*) IN OBL;

(** Represents an input stream reader. *)
TYPE Reader* = RECORD* END;

(** Represents an output stream writer. *)
TYPE Writer* = RECORD* END;

(** Reads a value of type {{{[[OBL:Streams.Character|Character]]}}} from the stream and returns whether that operation succeeded. *)
PROCEDURE* (VAR reader: Reader) Read* (VAR value: Character): BOOLEAN;

(** Writes a value of type {{{[[OBL:Streams.Character|Character]]}}} to the stream. *)
PROCEDURE* (VAR writer: Writer) Write* (value: Character);

(** Writes a character value to the stream. *)
PROCEDURE- (VAR writer: Writer) Char* (value: CHAR);
BEGIN writer.Write (Character (value));
END Char;

(** Writes a string value to the stream. *)
PROCEDURE- (VAR writer: Writer) String* (value-: ARRAY OF CHAR);
VAR i: LENGTH; char: CHAR;
BEGIN FOR i := 0 TO LEN (value) - 1 DO char := value[i]; IF char = 0X THEN RETURN END; writer.Char (char) END;
END String;

(** Writes a Boolean value to the stream. *)
PROCEDURE- (VAR writer: Writer) Boolean* (value: BOOLEAN);
BEGIN IF value THEN writer.String ("TRUE") ELSE writer.String ("FALSE") END;
END Boolean;

(** Writes a new-line character to the stream. *)
PROCEDURE- (VAR writer: Writer) Ln*;
BEGIN writer.Char (0AX);
END Ln;

END Streams.

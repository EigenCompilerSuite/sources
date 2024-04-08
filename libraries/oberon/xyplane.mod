(* Basic facilities for graphics programming
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

(** Module {{{XYplane}}} provides basic facilities for graphics programming. *)
(** It provides a Cartesian plane of pixels that can be drawn and erased. *)
(** The plane is mapped to some location on the screen. *)
MODULE XYplane;

IMPORT SYSTEM, SDL IN API;

(** Draw pixel mode. *)
CONST draw* = 1;

(** Erase pixel mode. *)
CONST erase* = 0;

(** Left border of the screen. *)
VAR X-: INTEGER;

(** Lower border of the screen. *)
VAR Y-: INTEGER;

(** Width of the screen. *)
VAR W-: INTEGER;

(** Height of the screen. *)
VAR H-: INTEGER;

VAR rect: SDL.Rect;
VAR window: POINTER TO VAR SDL.Window;
VAR surface: POINTER TO VAR SDL.Surface;
VAR xstride, ystride: INTEGER;
VAR colors: ARRAY 2 OF SDL.Uint32;

(** Initializes the drawing plane. *)
PROCEDURE Open*;
VAR title: ARRAY 10 OF CHAR;
BEGIN
	IF window # NIL THEN RETURN END;
	IGNORE (SDL.Init (SDL.INIT_VIDEO));
	X := 0; Y := 0; W := 1024; H := 768; rect.w := 1; rect.h := 1; title := "XYplane";
	window := SDL.CreateWindow (PTR (title[0]), INTEGER (SDL.WINDOWPOS_UNDEFINED), INTEGER (SDL.WINDOWPOS_UNDEFINED), W * rect.w, H * rect.h, 0);
	surface := SDL.GetWindowSurface (window);
	xstride := surface.format.BytesPerPixel * rect.w;
	ystride := surface.pitch * rect.w;
	colors[draw] := SDL.MapRGB (surface.format, SDL.Uint8 (255), SDL.Uint8 (255), SDL.Uint8 (255));
	colors[erase] := SDL.MapRGB (surface.format, SDL.Uint8 (0), SDL.Uint8 (0), SDL.Uint8 (0));
	IGNORE (SDL.UpdateWindowSurface (window));
END Open;

(** Terminates the drawing plane. *)
PROCEDURE Close*;
BEGIN
	SDL.DestroyWindow (window);
	SDL.Quit;
END Close;

(** Erases all pixels in the drawing plane. *)
PROCEDURE Clear*;
BEGIN
	IGNORE (SDL.FillRect (surface, NIL, colors[erase]));
	IGNORE (SDL.UpdateWindowSurface (window));
END Clear;

(** Draws or erases the pixel at the coordinates (//x//, //y//) relative to the lower left corner of the plane. *)
(** //mode// must be either {{{[[XYplane.draw|draw]]}}} or {{{[[XYplane.erase|erase]]}}}. *)
PROCEDURE Dot* (x, y, mode: INTEGER);
BEGIN
	rect.x := x * rect.w; rect.y := (H - y - 1) * rect.h;
	IGNORE (SDL.FillRect (surface, PTR (rect), colors[mode]));
	IGNORE (SDL.UpdateWindowSurfaceRects (window, PTR (rect), 1));
END Dot;

(** Returns whether the pixel at the coordinates (//x//, //y//) relative to the lower left corner of the screen is drawn. *)
PROCEDURE IsDot* (x, y: INTEGER): BOOLEAN;
VAR color: SDL.Uint32;
BEGIN
	SYSTEM.GET (surface.pixels + x * xstride + (H - y - 1) * ystride, color);
	RETURN color = colors[draw];
END IsDot;

(** Reads the keyboard. *)
(** If a key was pressed prior to invocation, its character value is returned, otherwise the result is {{{0X}}}. *)
PROCEDURE Key* (): CHAR;
BEGIN RETURN 0X;
END Key;

END XYplane.

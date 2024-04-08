(* Mathematical functions
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

(** The generic module {{{Math}}} provides mathematical functions on values of type {{{[[OBL:Math.Real|Real]]}}}. *)
(** @@Real The real type used for mathematical functions. *)
MODULE Math (Real*) IN OBL;

IMPORT SYSTEM;

(** The base of natural logarithms. *)
CONST E* = Real (2.71828182845904523536);

(** The ratio of the circumference of a circle to its diameter. *)
CONST Pi* = Real (3.14159265358979323846);

(** The ratio of the circumference of a circle to its radius. *)
CONST Tau* = Real (6.28318530717958647692);

PROCEDURE ^ Mod [SEL (Real IS LONGREAL, "modfl", "modff")] (num: Real; iptr: POINTER TO VAR Real): Real;

(** Computes the absolute value of {{{x}}}. *)
PROCEDURE ^ Abs* [SEL (Real IS LONGREAL, "fabsl", "fabsf")] (x: Real): Real;

(** Composes a value with the magnitude of {{{m}}} and the sign of {{{s}}}. *)
PROCEDURE ^ CopySign* [SEL (Real IS LONGREAL, "copysignl", "copysignf")] (m: Real; s: Real): Real;

(** Computes the cosine of {{{x}}}. *)
PROCEDURE ^ Cos* [SEL (Real IS LONGREAL, "cosl", "cosf")] (x: Real): Real;

(** Returns the fractional part of {{{x}}}. *)
PROCEDURE Fraction* (x: Real): Real;
BEGIN RETURN Mod (x, NIL);
END Fraction;

(** Returns the integral part of {{{x}}}. *)
PROCEDURE Integer* (x: Real): Real;
VAR result: Real; BEGIN x := Mod (x, PTR (result)); RETURN result;
END Integer;

(** Determines whether {{{x}}} has a finite value. *)
PROCEDURE ^ IsFinite* [SEL (Real IS LONGREAL, "std::isfinite(long double)", "std::isfinite(float)")] (x: Real): BOOLEAN;

(** Determines whether {{{x}}} is an infinity. *)
PROCEDURE ^ IsInf* [SEL (Real IS LONGREAL, "std::isinf(long double)", "std::isinf(float)")] (x: Real): BOOLEAN;

(** Determines whether {{{x}}} is not a number. *)
PROCEDURE ^ IsNan* [SEL (Real IS LONGREAL, "std::isnan(long double)", "std::isnan(float)")] (x: Real): BOOLEAN;

(** Determines whether {{{x}}} has a normal value. *)
PROCEDURE ^ IsNormal* [SEL (Real IS LONGREAL, "std::isnormal(long double)", "std::isnormal(float)")] (x: Real): BOOLEAN;

(** Computes the fused multiplication and accumulation of {{{x}}}, {{{y}}}, and {{{z}}}. *)
PROCEDURE ^ Ma* [SEL (Real IS LONGREAL, "fmal", "fmaf")] (x: Real; y: Real; z: Real): Real;

(** Computes the maximum of {{{x}}} and {{{y}}}. *)
PROCEDURE ^ Max* [SEL (Real IS LONGREAL, "fmaxl", "fmaxf")] (x: Real; y: Real): Real;

(** Computes the minimum of {{{x}}} and {{{y}}}. *)
PROCEDURE ^ Min* [SEL (Real IS LONGREAL, "fminl", "fminf")] (x: Real; y: Real): Real;

(** Determines whether {{{x}}} has a negative value. *)
PROCEDURE ^ IsNegative* [SEL (Real IS LONGREAL, "std::signbit(long double)", "std::signbit(float)")] (x: Real): BOOLEAN;

(** Computes the sine of {{{x}}}. *)
PROCEDURE ^ Sin* [SEL (Real IS LONGREAL, "sinl", "sinf")] (x: Real): Real;

(** Computes the square root of {{{x}}}. *)
PROCEDURE ^ Sqrt* [SEL (Real IS LONGREAL, "sqrtl", "sqrtf")] (x: Real): Real;

(** Computes the tangent of {{{x}}}. *)
PROCEDURE ^ Tan* [SEL (Real IS LONGREAL, "tanl", "tanf")] (x: Real): Real;

END Math.

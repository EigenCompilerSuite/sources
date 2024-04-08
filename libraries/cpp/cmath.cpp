// Standard C++ <cmath> header
// Copyright (C) Florian Negele

// This file is part of the Eigen Compiler Suite.

// The ECS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// The ECS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// Under Section 7 of the GNU General Public License version 3,
// the copyright holder grants you additional permissions to use
// this file as described in the ECS Runtime Support Exception.

// You should have received a copy of the GNU General Public License
// and a copy of the ECS Runtime Support Exception along with
// the ECS.  If not, see <https://www.gnu.org/licenses/>.

#include "cmath"

using namespace std;

// standard cos function

#if defined __amd16__

	asm (R"(
		.code cos
			mov	si, sp
			fld	qword [si + 2]
			fcos
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code cos
			fld	qword [esp + 4]
			fcos
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code cos
			fld	qword [rsp + 8]
			fcos
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#endif

// standard cosf function

#if defined __amd16__

	asm (R"(
		.code cosf
			mov	si, sp
			fld	dword [si + 2]
			fcos
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code cosf
			fld	dword [esp + 4]
			fcos
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code cosf
			fld	dword [rsp + 8]
			fcos
			fstp	dword [rsp - 8]
			movss	xmm0, [rsp - 8]
			ret
	)");

#endif

// standard cosl function

#if defined __amd16__

	asm (R"(
		.code cosl
			mov	si, sp
			fld	qword [si + 2]
			fcos
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code cosl
			fld	qword [esp + 4]
			fcos
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code cosl
			fld	qword [rsp + 8]
			fcos
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#endif

// standard fabs function

#if defined __amd16__

	asm (R"(
		.code fabs
			mov	si, sp
			fld	qword [si + 2]
			fabs
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code fabs
			fld	qword [esp + 4]
			fabs
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code fabs
			fld	qword [rsp + 8]
			fabs
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#else

	double std::fabs (const double x) noexcept
	{
		return x < 0 ? -x : x;
	}

#endif

// standard fabsf function

#if defined __amd16__

	asm (R"(
		.code fabsf
			mov	si, sp
			fld	dword [si + 2]
			fabs
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code fabsf
			fld	dword [esp + 4]
			fabs
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code fabsf
			fld	dword [rsp + 8]
			fabs
			fstp	dword [rsp - 8]
			movss	xmm0, [rsp - 8]
			ret
	)");

#else

	float std::fabsf (const float x) noexcept
	{
		return x < 0 ? -x : x;
	}

#endif

// standard fabsl function

#if defined __amd16__

	asm (R"(
		.code fabsl
			mov	si, sp
			fld	qword [si + 2]
			fabs
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code fabsl
			fld	qword [esp + 4]
			fabs
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code fabsl
			fld	qword [rsp + 8]
			fabs
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#else

	long double std::fabsl (const long double x) noexcept
	{
		return x < 0 ? -x : x;
	}

#endif

// standard fma function

double std::fma (const double x, const double y, const double z) noexcept
{
	return x * y + z;
}

// standard fmaf function

float std::fmaf (const float x, const float y, const float z) noexcept
{
	return x * y + z;
}

// standard fmal function

long double std::fmal (const long double x, const long double y, const long double z) noexcept
{
	return x * y + z;
}

// standard fmax function

double std::fmax (const double x, const double y) noexcept
{
	return x > y ? x : y;
}

// standard fmaxf function

float std::fmaxf (const float x, const float y) noexcept
{
	return x > y ? x : y;
}

// standard fmaxl function

long double std::fmaxl (const long double x, const long double y) noexcept
{
	return x > y ? x : y;
}

// standard fmin function

double std::fmin (const double x, const double y) noexcept
{
	return x < y ? x : y;
}

// standard fminf function

float std::fminf (const float x, const float y) noexcept
{
	return x < y ? x : y;
}

// standard fminl function

long double std::fminl (const long double x, const long double y) noexcept
{
	return x < y ? x : y;
}

// standard sin function

#if defined __amd16__

	asm (R"(
		.code sin
			mov	si, sp
			fld	qword [si + 2]
			fsin
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code sin
			fld	qword [esp + 4]
			fsin
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code sin
			fld	qword [rsp + 8]
			fsin
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#endif

// standard sinf function

#if defined __amd16__

	asm (R"(
		.code sinf
			mov	si, sp
			fld	dword [si + 2]
			fsin
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code sinf
			fld	dword [esp + 4]
			fsin
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code sinf
			fld	dword [rsp + 8]
			fsin
			fstp	dword [rsp - 8]
			movss	xmm0, [rsp - 8]
			ret
	)");

#endif

// standard sinl function

#if defined __amd16__

	asm (R"(
		.code sinl
			mov	si, sp
			fld	qword [si + 2]
			fsin
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code sinl
			fld	qword [esp + 4]
			fsin
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code sinl
			fld	qword [rsp + 8]
			fsin
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#endif

// standard tan function

#if defined __amd16__

	asm (R"(
		.code tan
			mov	si, sp
			fld	qword [si + 2]
			fsincos
			fdivp
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code tan
			fld	qword [esp + 4]
			fsincos
			fdivp
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code tan
			fld	qword [rsp + 8]
			fsincos
			fdivp
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#else

	double std::tan (const double x) noexcept
	{
		return sin (x) / cos (x);
	}

#endif

// standard tanf function

#if defined __amd16__

	asm (R"(
		.code tanf
			mov	si, sp
			fld	dword [si + 2]
			fsincos
			fdivp
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code tanf
			fld	dword [esp + 4]
			fsincos
			fdivp
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code tanf
			fld	dword [rsp + 8]
			fsincos
			fdivp
			fstp	dword [rsp - 8]
			movss	xmm0, [rsp - 8]
			ret
	)");

#else

	float std::tanf (const float x) noexcept
	{
		return sinf (x) / cosf (x);
	}

#endif

// standard tanl function

#if defined __amd16__

	asm (R"(
		.code tanl
			mov	si, sp
			fld	qword [si + 2]
			fsincos
			fdivp
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code tanl
			fld	qword [esp + 4]
			fsincos
			fdivp
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code tanl
			fld	qword [rsp + 8]
			fsincos
			fdivp
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#else

	long double std::tanl (const long double x) noexcept
	{
		return sinl (x) / cosl (x);
	}

#endif

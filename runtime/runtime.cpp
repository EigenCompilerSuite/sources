// Common basic runtime support
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

using f4 = float;
using f8 = long double;
using s1 = signed char;
using s2 = signed short;
using s4 = signed long;
using s8 = signed long long;
using u1 = unsigned char;
using u2 = unsigned short;
using u4 = unsigned long;
using u8 = unsigned long long;

struct fp4 {u4 s; u4 m; s4 e;};
struct fp8 {u8 s; u8 m; s8 e;};
struct ss8 {s4 l; s4 h;};
struct us8 {u4 l; s4 h;};
struct uu8 {u4 l; u4 h;};

#define ALIAS(name) [[ecs::alias (#name)]]

#if __sizeof_double__ == __sizeof_float__
	#define FLOATALIAS(name) ALIAS (name)
	#define LONGALIAS(name)
#elif __sizeof_double__ == __sizeof_long_double__
	#define FLOATALIAS(name)
	#define LONGALIAS(name) ALIAS (name)
#else
	#error unsupported double size
#endif

#define PACK4(x, px) (px).c = (x).m ? (x).s << 31 | (x).e << 23 | (x).m & 0x007f'ffff : 0
#define PACK8(x, px) (px).c = (x).m ? (x).s << 63 | (x).e << 52 | (x).m & 0x000f'ffff'ffff'ffff : 0
#define UNPACK4(px, x) (x).s = (px).c >> 31, (x).m = (px).c ? (px).c & 0x007f'ffff | 0x0080'0000 : 0, (x).e = (px).c >> 23 & 0xff
#define UNPACK8(px, x) (x).s = (px).c >> 63, (x).m = (px).c ? (px).c & 0x000f'ffff'ffff'ffff | 0x0010'0000'0000'0000 : 0, (x).e = (px).c >> 52 & 0x7ff

// floating-point unit initialization

#if defined __amd16__

	asm (R"(
		.initdata _init_fpu
			fninit
			push	word 0x0f7f
			mov	si, sp
			fldcw	[si]
			pop	ax
	)");

#elif defined __amd32__

	asm (R"(
		.initdata _init_fpu
			fninit
			push	word 0x0f7f
			fldcw	[esp]
			pop	ax
	)");

#endif

// global register definitions

#if defined __wasm__

	asm (R"(
		#define register
			.header _$#0

				.group	_s05_globals

				valtype	#1	; valtype
				.byte	0x01	; var
				#1.const	0	; expr
				end
		#enddef

		#repeat 8
			register	##_i32, i32
			register	##_i64, i64
			register	##_f32, f32
			register	##_f64, f64
		#endrep

		register	res_i32, i32
		register	res_i64, i64
		register	res_f32, f32
		register	res_f64, f64

		register	sp, i32
		.require	_init_stack
		register	fp, i32
		.require	_init_stack

		#undef register
	)");

#endif

// intermediate conv instruction

extern "C" s1 _conv_s1_f4 (const f4 x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const s4 e = (a.c << 1 >> 24) - 127; s4 r;
	if (e < 0) r = 0; else if (e < 32) r = 1 << e | a.c << 9 >> 32 - e; else r = -1;
	if (a.c >> 31) r = -r; return s1 (r);
}

extern "C" s1 _conv_s1_f8 (const f8 x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const s4 e = (a.c.h << 1 >> 21) - 1023; s4 r;
	if (e < 0) r = 0; else if (e < 20) r = 1 << e | a.c.h << 12 >> 32 - e;
	else if (e < 32) r = 1 << e | a.c.h << 12 >> 32 - e | a.c.l >> 52 - e; else r = -1;
	if (a.c.h >> 31) r = -r; return s1 (r);
}

extern "C" s2 _conv_s2_f4 (const f4 x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const s4 e = (a.c << 1 >> 24) - 127; s4 r;
	if (e < 0) r = 0; else if (e < 32) r = 1 << e | a.c << 9 >> 32 - e; else r = -1;
	if (a.c >> 31) r = -r; return s2 (r);
}

extern "C" s2 _conv_s2_f8 (const f8 x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const s4 e = (a.c.h << 1 >> 21) - 1023; s4 r;
	if (e < 0) r = 0; else if (e < 20) r = 1 << e | a.c.h << 12 >> 32 - e;
	else if (e < 32) r = 1 << e | a.c.h << 12 >> 32 - e | a.c.l >> 52 - e; else r = -1;
	if (a.c.h >> 31) r = -r; return s2 (r);
}

extern "C" s4 _conv_s4_f4 (const f4 x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const s4 e = (a.c << 1 >> 24) - 127; s4 r;
	if (e < 0) r = 0; else if (e < 32) r = 1 << e | a.c << 9 >> 32 - e; else r = -1;
	if (a.c >> 31) r = -r; return r;
}

extern "C" s4 _conv_s4_f8 (const f8 x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const s4 e = (a.c.h << 1 >> 21) - 1023; s4 r;
	if (e < 0) r = 0; else if (e < 20) r = 1 << e | a.c.h << 12 >> 32 - e;
	else if (e < 32) r = 1 << e | a.c.h << 12 >> 32 - e | a.c.l >> 52 - e; else r = -1;
	if (a.c.h >> 31) r = -r; return r;
}

extern "C" s8 _conv_s8_f4 (const f4 x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const s4 e = (a.c << 1 >> 24) - 127; union {s8 v; uu8 c;} r;
	if (e < 0) r.c.l = 0, r.c.h = 0; else if (e < 32) r.c.l = 1 << e | a.c << 9 >> 32 - e, r.c.h = 0;
	else if (e < 64) r.c.l = a.c << 9 >> 64 - e, r.c.h = 1 << e - 32 | a.c << 9 >> 64 - e; else r.c.l = -1, r.c.h = -1;
	if (a.c >> 31) r.v = -r.v; return r.v;
}

extern "C" s8 _conv_s8_f8 (const f8 x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const s4 e = (a.c.h << 1 >> 21) - 1023; union {s8 v; uu8 c;} r;
	if (e < 0) r.c.l = 0, r.c.h = 0; else if (e < 20) r.c.l = 1 << e | a.c.h << 12 >> 32 - e, r.c.h = 0;
	else if (e < 32) r.c.l = 1 << e | a.c.h << 12 >> 32 - e | a.c.l >> 52 - e, r.c.h = 0;
	else if (e < 52) r.c.l = a.c.l >> 52 - e | a.c.h << e - 20, r.c.h = 1 << e - 32 | a.c.h << 12 >> 64 - e;
	else if (e < 64) r.c.l = a.c.l << e - 52, r.c.h = 1 << e - 64 | a.c.h << 12 >> 64 - e | a.c.l >> 84 - e; else r.c.l = -1, r.c.h = -1;
	if (a.c.h >> 31) r.v = -r.v; return r.v;
}

extern "C" u1 _conv_u1_f4 (const f4 x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const s4 e = (a.c >> 23) - 127; u4 r;
	if (e < 0) r = 0; else if (e < 32) r = 1 << e | a.c << 9 >> 32 - e; else r = -1;
	return u1 (r);
}

extern "C" u1 _conv_u1_f8 (const f8 x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const s4 e = (a.c.h >> 20) - 1023; u4 r;
	if (e < 0) r = 0; else if (e < 20) r = 1 << e | a.c.h << 12 >> 32 - e;
	else if (e < 32) r = 1 << e | a.c.h << 12 >> 32 - e | a.c.l >> 52 - e; else r = -1;
	return u1 (r);
}

extern "C" u2 _conv_u2_f4 (const f4 x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const s4 e = (a.c >> 23) - 127; u4 r;
	if (e < 0) r = 0; else if (e < 32) r = 1 << e | a.c << 9 >> 32 - e; else r = -1;
	return u2 (r);
}

extern "C" u2 _conv_u2_f8 (const f8 x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const s4 e = (a.c.h >> 20) - 1023; u4 r;
	if (e < 0) r = 0; else if (e < 20) r = 1 << e | a.c.h << 12 >> 32 - e;
	else if (e < 32) r = 1 << e | a.c.h << 12 >> 32 - e | a.c.l >> 52 - e; else r = -1;
	return u2 (r);
}

extern "C" u4 _conv_u4_f4 (const f4 x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const s4 e = (a.c >> 23) - 127; u4 r;
	if (e < 0) r = 0; else if (e < 32) r = 1 << e | a.c << 9 >> 32 - e; else r = -1;
	return r;
}

extern "C" u4 _conv_u4_f8 (const f8 x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const s4 e = (a.c.h >> 20) - 1023; u4 r;
	if (e < 0) r = 0; else if (e < 20) r = 1 << e | a.c.h << 12 >> 32 - e;
	else if (e < 32) r = 1 << e | a.c.h << 12 >> 32 - e | a.c.l >> 52 - e; else r = -1;
	return r;
}

extern "C" u8 _conv_u8_f4 (const f4 x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const s4 e = (a.c >> 23) - 127; union {u8 v; uu8 c;} r;
	if (e < 0) r.c.l = 0, r.c.h = 0; else if (e < 32) r.c.l = 1 << e | a.c << 9 >> 32 - e, r.c.h = 0;
	else if (e < 64) r.c.l = a.c << 9 >> 64 - e, r.c.h = 1 << e - 32 | a.c << 9 >> 64 - e; else r.c.l = -1, r.c.h = -1;
	return r.v;
}

extern "C" u8 _conv_u8_f8 (const f8 x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const s4 e = (a.c.h >> 20) - 1023; union {u8 v; uu8 c;} r;
	if (e < 0) r.c.l = 0, r.c.h = 0; else if (e < 20) r.c.l = 1 << e | a.c.h << 12 >> 32 - e, r.c.h = 0;
	else if (e < 32) r.c.l = 1 << e | a.c.h << 12 >> 32 - e | a.c.l >> 52 - e, r.c.h = 0;
	else if (e < 52) r.c.l = a.c.l >> 52 - e | a.c.h << e - 20, r.c.h = 1 << e - 32 | a.c.h << 12 >> 64 - e;
	else if (e < 64) r.c.l = a.c.l << e - 52, r.c.h = 1 << e - 64 | a.c.h << 12 >> 64 - e | a.c.l >> 84 - e; else r.c.l = -1, r.c.h = -1;
	return r.v;
}

extern "C" f4 _conv_f4_s1 (s1 x) noexcept
{
	const bool s = x < 0; if (s) x = -x;
	u4 a {x}, b {x}; union {u4 c; f4 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c = p + 126 << 23 | b >> 9; else r.c = 0;
	if (s) r.v = -r.v; return r.v;
}

extern "C" f4 _conv_f4_s2 (s2 x) noexcept
{
	const bool s = x < 0; if (s) x = -x;
	u4 a {x}, b {x}; union {u4 c; f4 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c = p + 126 << 23 | b >> 9; else r.c = 0;
	if (s) r.v = -r.v; return r.v;
}

extern "C" f4 _conv_f4_s4 (s4 x) noexcept
{
	const bool s = x < 0; if (s) x = -x;
	u4 a {x}, b {x}; union {u4 c; f4 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c = p + 126 << 23 | b >> 9; else r.c = 0;
	if (s) r.v = -r.v; return r.v;
}

extern "C" f4 _conv_f4_s8 (s8 x) noexcept
{
	const bool s = x < 0; if (s) x = -x;
	union {u8 a; uu8 c;} a {x}, b {x}; union {u4 c; f4 v;} r;
	u4 p = 0; if (a.c.h) {p += 32; do a.c.h >>= 1, ++p; while (a.c.h);} else while (a.c.l) a.c.l >>= 1, ++p;
	if (p > 32) b.c.h = b.c.h << 64 - p << 1 | b.c.l >> p - 33; else if (p > 0) b.c.h = b.c.l << 32 - p << 1;
	if (p) r.c = p + 126 << 23 | b.c.h >> 9; else r.c = 0;
	if (s) r.v = -r.v; return r.v;
}

extern "C" f8 _conv_f8_s1 (s1 x) noexcept
{
	const bool s = x < 0; if (s) x = -x;
	u4 a {x}, b {x}; union {uu8 c; f8 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c.l = b << 20, r.c.h = p + 1022 << 20 | b >> 12; else r.c.l = 0, r.c.h = 0;
	if (s) r.v = -r.v; return r.v;
}

extern "C" f8 _conv_f8_s2 (s2 x) noexcept
{
	const bool s = x < 0; if (s) x = -x;
	u4 a {x}, b {x}; union {uu8 c; f8 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c.l = b << 20, r.c.h = p + 1022 << 20 | b >> 12; else r.c.l = 0, r.c.h = 0;
	if (s) r.v = -r.v; return r.v;
}

extern "C" f8 _conv_f8_s4 (s4 x) noexcept
{
	const bool s = x < 0; if (s) x = -x;
	u4 a {x}, b {x}; union {uu8 c; f8 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c.l = b << 20, r.c.h = p + 1022 << 20 | b >> 12; else r.c.l = 0, r.c.h = 0;
	if (s) r.v = -r.v; return r.v;
}

extern "C" f8 _conv_f8_s8 (s8 x) noexcept
{
	const bool s = x < 0; if (s) x = -x;
	union {u8 a; uu8 c;} a {x}, b {x}; union {uu8 c; f8 v;} r;
	u4 p = 0; if (a.c.h) {p += 32; do a.c.h >>= 1, ++p; while (a.c.h);} else while (a.c.l) a.c.l >>= 1, ++p;
	if (p > 32) b.c.h = b.c.h << 64 - p << 1 | b.c.l >> p - 33, b.c.l = b.c.l << 64 - p << 1; else if (p > 0) b.c.h = b.c.l << 32 - p << 1, b.c.l = 0;
	if (p) r.c.l = b.c.l >> 12 | b.c.h << 20, r.c.h = p + 1022 << 20 | b.c.h >> 12; else r.c.l = 0, r.c.h = 0;
	if (s) r.v = -r.v; return r.v;
}

extern "C" f4 _conv_f4_u1 (const u1 x) noexcept
{
	u4 a {x}, b {x}; union {u4 c; f4 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c = p + 126 << 23 | b >> 9; else r.c = 0;
	return r.v;
}

extern "C" f4 _conv_f4_u2 (const u2 x) noexcept
{
	u4 a {x}, b {x}; union {u4 c; f4 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c = p + 126 << 23 | b >> 9; else r.c = 0;
	return r.v;
}

extern "C" f4 _conv_f4_u4 (const u4 x) noexcept
{
	u4 a {x}, b {x}; union {u4 c; f4 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c = p + 126 << 23 | b >> 9; else r.c = 0;
	return r.v;
}

extern "C" f4 _conv_f4_u8 (const u8 x) noexcept
{
	union {u8 a; uu8 c;} a {x}, b {x}; union {u4 c; f4 v;} r;
	u4 p = 0; if (a.c.h) {p += 32; do a.c.h >>= 1, ++p; while (a.c.h);} else while (a.c.l) a.c.l >>= 1, ++p;
	if (p > 32) b.c.h = b.c.h << 64 - p << 1 | b.c.l >> p - 33; else if (p > 0) b.c.h = b.c.l << 32 - p << 1;
	if (p) r.c = p + 126 << 23 | b.c.h >> 9; else r.c = 0;
	return r.v;
}

extern "C" f8 _conv_f8_u1 (const u1 x) noexcept
{
	u4 a {x}, b {x}; union {uu8 c; f8 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c.l = b << 20, r.c.h = p + 1022 << 20 | b >> 12; else r.c.l = 0, r.c.h = 0;
	return r.v;
}

extern "C" f8 _conv_f8_u2 (const u2 x) noexcept
{
	u4 a {x}, b {x}; union {uu8 c; f8 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c.l = b << 20, r.c.h = p + 1022 << 20 | b >> 12; else r.c.l = 0, r.c.h = 0;
	return r.v;
}

extern "C" f8 _conv_f8_u4 (const u4 x) noexcept
{
	u4 a {x}, b {x}; union {uu8 c; f8 v;} r;
	u4 p = 0; while (a) a >>= 1, ++p;
	if (p > 0) b = b << 32 - p << 1;
	if (p) r.c.l = b << 20, r.c.h = p + 1022 << 20 | b >> 12; else r.c.l = 0, r.c.h = 0;
	return r.v;
}

extern "C" f8 _conv_f8_u8 (const u8 x) noexcept
{
	union {u8 a; uu8 c;} a {x}, b {x}; union {uu8 c; f8 v;} r;
	u4 p = 0; if (a.c.h) {p += 32; do a.c.h >>= 1, ++p; while (a.c.h);} else while (a.c.l) a.c.l >>= 1, ++p;
	if (p > 32) b.c.h = b.c.h << 64 - p << 1 | b.c.l >> p - 33, b.c.l = b.c.l << 64 - p << 1; else if (p > 0) b.c.h = b.c.l << 32 - p << 1, b.c.l = 0;
	if (p) r.c.l = b.c.l >> 12 | b.c.h << 20, r.c.h = p + 1022 << 20 | b.c.h >> 12; else r.c.l = 0, r.c.h = 0;
	return r.v;
}

extern "C" f4 _conv_f4_f8 (const f8 x) noexcept
{
	union {f8 v; u8 c;} pa {x}; fp8 a; UNPACK8 (pa, a); union {f4 v; u4 c;} pr; fp4 r;
	r.s = u4 (a.s);
	r.e = s4 (a.e) - 1023 + 127;
	r.m = u4 (a.m >> 29);
	PACK4 (r, pr); return pr.v;
}

extern "C" f8 _conv_f8_f4 (const f4 x) noexcept
{
	union {f4 v; u4 c;} pa {x}; fp4 a; UNPACK4 (pa, a); union {f8 v; u8 c;} pr; fp8 r;
	r.s = a.s;
	r.e = a.e - 127 + 1023;
	r.m = u8 (a.m) << 29;
	PACK8 (r, pr); return pr.v;
}

// intermediate fill instruction

#if defined __amd16__

	asm (R"(
		.code _fill_ptr_s8
			.alias	_fill_ptr_u8
			.alias	_fill_ptr_f8
			mov	si, sp
			mov	cx, [si + 4]
			cmp	cx, 0
			je	done
			mov	di, [si + 2]
			mov	eax, [si + 6]
			mov	ebx, [si + 10]
		loop:	mov	[di], eax
			mov	[di + 4], ebx
			add	di, 8
			dec	cx
			jne	loop
		done:	ret
	)");

#elif defined __amd32__

	asm (R"(
		.code _fill_ptr_s8
			.alias	_fill_ptr_u8
			.alias	_fill_ptr_f8
			mov	ecx, [esp + 8]
			cmp	ecx, 0
			je	done
			mov	edx, [esp + 4]
			mov	eax, [esp + 12]
			mov	ebx, [esp + 16]
		loop:	mov	[edx], eax
			mov	[edx + 4], ebx
			add	edx, 8
			dec	ecx
			jne	loop
		done:	ret
	)");

#elif defined __wasm__

	asm (R"(
		#define fill
			.code _fill_ptr_#0#1

				#if	#0#1 === u4
					.alias	_fill_ptr
					.alias	_fill_ptr_fun
				#endif

				.group	_s10_codes
				i32	size (@_fill_ptr_#0#1) - 5	; size
				vec	2	; vec (locals)
				u32	2	; locals
				valtype	i32	; valtype
				u32	1	; locals
				valtype	#2	; valtype

				global.get
				i32	index (@_$sp)
				i32.load	0 0
				local.set	0
				global.get
				i32	index (@_$sp)
				i32.load	0 4
				local.set	1
				global.get
				i32	index (@_$sp)
				#2.#3	0 8
				local.set	2
				block
				loop
				local.get	1
				i32.const	0
				i32.eq
				br_if	1
				local.get	0
				local.get	2
				#2.#4	0 0
				local.get	0
				i32.const	#1
				i32.add
				local.set	0
				local.get	1
				i32.const	1
				i32.sub
				local.set	1
				br	0
				end
				end
				end	; expr

			.header __fill_ptr_#0#1_function

				#if	#0#1 === u4
					.alias	__fill_ptr_function
					.alias	__fill_ptr_fun_function
				#endif

				.group	_s02_functions
				.require	_fill_ptr_#0#1
				i32	index (@_main_type)	; typeidx
		#enddef

		fill	s, 2, i32, load16_s, store16
		fill	u, 2, i32, load16_u, store16
		fill	s, 4, i32, load, store
		fill	u, 4, i32, load, store
		fill	s, 8, i64, load, store
		fill	u, 8, i64, load, store
		fill	f, 4, f32, load, store
		fill	f, 8, f64, load, store
	)");

#endif

// intermediate neg instruction

extern "C" s8 _neg_s8 (const s8 x) noexcept
{
	union {s8 v; ss8 c;} r {x};
	r.c.l = -r.c.l; r.c.h = -r.c.h; if (r.c.l) --r.c.h;
	return r.v;
}

extern "C" f4 _neg_f4 (const f4 x) noexcept
{
	union {f4 v; u4 c;} r {x};
	r.c ^= 0x8000'0000;
	return r.v;
}

extern "C" f8 _neg_f8 (const f8 x) noexcept
{
	union {f8 v; uu8 c;} r {x};
	r.c.h ^= 0x8000'0000;
	return r.v;
}

// intermediate add instruction

extern "C" s8 _add_s8 ALIAS (_add_u8) (const s8 x, const s8 y) noexcept
{
	union {s8 v; uu8 c;} a {x}, b {y}, r;
	r.c.l = a.c.l + b.c.l; r.c.h = a.c.h + b.c.h; if (r.c.l < a.c.l) ++r.c.h;
	return r.v;
}

extern "C" f4 _add_f4 (const f4 x, const f4 y) noexcept
{
	union {f4 v; u4 c;} pa {x}, pb {y}, pr; fp4 a, b, r; UNPACK4 (pa, a); UNPACK4 (pb, b);
	if (a.e < b.e) a.m = a.m >> (b.e - a.e < 24 ? b.e - a.e : 24), a.e = b.e;
	if (b.e < a.e) b.m = b.m >> (a.e - b.e < 24 ? a.e - b.e : 24), b.e = a.e;
	if (a.s) a.m = -a.m;
	if (b.s) b.m = -b.m;
	r.m = a.m + b.m;
	r.s = r.m >> 31;
	if (r.s) r.m = -r.m;
	r.e = a.e;
	if (r.m & 0x0100'0000) r.m >>= 1, r.e += 1;
	else while (r.m && ~r.m & 0x0080'0000) r.m <<= 1, r.e -= 1;
	PACK4 (r, pr); return pr.v;
}

extern "C" f8 _add_f8 (const f8 x, const f8 y) noexcept
{
	union {f8 v; u8 c;} pa {x}, pb {y}, pr; fp8 a, b, r; UNPACK8 (pa, a); UNPACK8 (pb, b);
	if (a.e < b.e) a.m = a.m >> (b.e - a.e < 53 ? b.e - a.e : 53), a.e = b.e;
	if (b.e < a.e) b.m = b.m >> (a.e - b.e < 53 ? a.e - b.e : 53), b.e = a.e;
	if (a.s) a.m = -a.m;
	if (b.s) b.m = -b.m;
	r.m = a.m + b.m;
	r.s = r.m >> 63;
	if (r.s) r.m = -r.m;
	r.e = a.e;
	if (r.m & 0x0020'0000'0000'0000) r.m >>= 1, r.e += 1;
	else while (r.m && ~r.m & 0x0010'0000'0000'0000) r.m <<= 1, r.e -= 1;
	PACK8 (r, pr); return pr.v;
}

// intermediate sub instruction

extern "C" f4 _sub_f4 (const f4 x, const f4 y) noexcept
{
	union {f4 v; u4 c;} pa {x}, pb {y}, pr; fp4 a, b, r; UNPACK4 (pa, a); UNPACK4 (pb, b);
	if (a.e < b.e) a.m = a.m >> (b.e - a.e < 24 ? b.e - a.e : 24), a.e = b.e;
	if (b.e < a.e) b.m = b.m >> (a.e - b.e < 24 ? a.e - b.e : 24), b.e = a.e;
	if (a.s) a.m = -a.m;
	if (b.s) b.m = -b.m;
	r.m = a.m - b.m;
	r.s = r.m >> 31;
	if (r.s) r.m = -r.m;
	r.e = a.e;
	if (r.m & 0x0100'0000) r.m >>= 1, r.e += 1;
	else while (r.m && ~r.m & 0x0080'0000) r.m <<= 1, r.e -= 1;
	PACK4 (r, pr); return pr.v;
}

extern "C" f8 _sub_f8 (const f8 x, const f8 y) noexcept
{
	union {f8 v; u8 c;} pa {x}, pb {y}, pr; fp8 a, b, r; UNPACK8 (pa, a); UNPACK8 (pb, b);
	if (a.e < b.e) a.m = a.m >> (b.e - a.e < 53 ? b.e - a.e : 53), a.e = b.e;
	if (b.e < a.e) b.m = b.m >> (a.e - b.e < 53 ? a.e - b.e : 53), b.e = a.e;
	if (a.s) a.m = -a.m;
	if (b.s) b.m = -b.m;
	r.m = a.m - b.m;
	r.s = r.m >> 63;
	if (r.s) r.m = -r.m;
	r.e = a.e;
	if (r.m & 0x0020'0000'0000'0000) r.m >>= 1, r.e += 1;
	else while (r.m && ~r.m & 0x0010'0000'0000'0000) r.m <<= 1, r.e -= 1;
	PACK8 (r, pr); return pr.v;
}

// intermediate mul instruction

#if defined __m68k__

	asm (R"(
		.code _mul_s4
			move.l	(4, sp), d0
			asr.l	8, d0
			asr.l	8, d0
			move.l	(8, sp), d2
			asr.l	8, d2
			asr.l	8, d2
			muls	d2, d0
			rts
	)");

#endif

extern "C" u4 _mul_u4 (const u4 x, const u4 y) noexcept
{
	u4 a = x, b = y, r;
	if (a > b) r = a, a = b, b = r;
	for (r = 0; a; a >>= 1, b <<= 1) if (a & 1) r += b;
	return r;
}

#if defined __amd16__

	asm (R"(
		.code _mul_s8
			.alias	_mul_u8
			mov	di, sp
			mov	edx, [di + 6]
			mov	ecx, [di + 14]
			or	edx, ecx
			mov	edx, [di + 10]
			mov	eax, [di + 2]
			jnz	twomul
			mul	edx
			ret
		twomul:
			imul	edx, [di + 6]
			imul	ecx, eax
			add	ecx, edx
			mul	dword [di + 10]
			add	edx, ecx
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code _mul_s8
			.alias	_mul_u8
			mov	edx, [esp + 8]
			mov	ecx, [esp + 16]
			or	edx, ecx
			mov	edx, [esp + 12]
			mov	eax, [esp + 4]
			jnz	twomul
			mul	edx
			ret
		twomul:
			imul	edx, [esp + 8]
			imul	ecx, eax
			add	ecx, edx
			mul	dword [esp + 12]
			add	edx, ecx
			ret
	)");

#else

	extern "C" u8 _mul_u8 (const u8 x, const u8 y) noexcept
	{
		u8 a = x, b = y, r;
		if (a > b) r = a, a = b, b = r;
		for (r = 0; a; a >>= 1, b <<= 1) if (a & 1) r += b;
		return r;
	}

#endif

extern "C" f4 _mul_f4 (const f4 x, const f4 y) noexcept
{
	union {f4 v; u4 c;} pa {x}, pb {y}, pr; fp4 a, b, r; UNPACK4 (pa, a); UNPACK4 (pb, b);
	r.s = a.s ^ b.s;
	r.m = (a.m >> 8) * (b.m >> 8) >> 8;
	r.e = a.e + b.e - 127;
	if (r.m & 0x0080'0000) r.e += 1; else r.m <<= 1;
	PACK4 (r, pr); return pr.v;
}

extern "C" f8 _mul_f8 (const f8 x, const f8 y) noexcept
{
	union {f8 v; u8 c;} pa {x}, pb {y}, pr; fp8 a, b, r; UNPACK8 (pa, a); UNPACK8 (pb, b);
	r.s = a.s ^ b.s;
	r.m = (a.m >> 21) * (b.m >> 21) >> 11;
	r.e = a.e + b.e - 1023;
	if (r.m & 0x0010'0000'0000'0000) r.e += 1; else r.m <<= 1;
	PACK8 (r, pr); return pr.v;
}

// intermediate div instruction

extern "C" s1 _div_s1 (s1 x, s1 y) noexcept
{
	u1 q = 0, r = 0; bool s = x < 0; if (s) x = -x; if (y < 0) s ^= true, y = -y;
	for (int i = 7; i >= 0; --i) if (r <<= 1, r |= u1 (x >> i & 1), r >= y) r -= y, q |= u1 (1 << i);
	return s ? -q : q;
}

extern "C" u1 _div_u1 (const u1 x, const u1 y) noexcept
{
	u1 q = 0, r = 0;
	for (int i = 7; i >= 0; --i) if (r <<= 1, r |= u1 (x >> i & 1), r >= y) r -= y, q |= u1 (1 << i);
	return q;
}

extern "C" s2 _div_s2 (s2 x, s2 y) noexcept
{
	u2 q = 0, r = 0; bool s = x < 0; if (s) x = -x; if (y < 0) s ^= true, y = -y;
	for (int i = 15; i >= 0; --i) if (r <<= 1, r |= u2 (x >> i & 1), r >= y) r -= y, q |= u2 (1 << i);
	return s ? -q : q;
}

extern "C" u2 _div_u2 (const u2 x, const u2 y) noexcept
{
	u2 q = 0, r = 0;
	for (int i = 15; i >= 0; --i) if (r <<= 1, r |= u2 (x >> i & 1), r >= y) r -= y, q |= u2 (1 << i);
	return q;
}

#if defined __arma32__

	asm (R"(
		.code _div_s4
			ldr	r2, [sp, 0]
			ldr	r3, [sp, 4]
			mov	r0, r2, asr 31
			add	r2, r2, r0
			eor	r2, r2, r0
			mov	r1, r3, asr 31
			add	r3, r3, r1
			eor	r3, r3, r1
			eor	r1, r0, r1
			clz	r4, r2
			clz	r5, r3
			sub	r4, r5, r4
			add	r4, r4, 1
			mov	r5, 0
			b	check
		loop:	cmp	r2, r3, lsl r4
			adc	r5, r5, r5
			subcs	r2, r2, r3, lsl r4
		check:	subs	r4, r4, 1
			bpl	loop
			add	r0, r5, r1
			eor	r0, r0, r1
			bx	lr

		.code _div_u4
			ldr	r2, [sp, 0]
			ldr	r3, [sp, 4]
			clz	r4, r2
			clz	r5, r3
			sub	r4, r5, r4
			add	r4, r4, 1
			mov	r5, 0
			b	check
		loop:	cmp	r2, r3, lsl r4
			adc	r5, r5, r5
			subcs	r2, r2, r3, lsl r4
		check:	subs	r4, r4, 1
			bpl	loop
			mov	r0, r5
			bx	lr
	)");

#else

	extern "C" s4 _div_s4 (s4 x, s4 y) noexcept
	{
		u4 q = 0, r = 0; bool s = x < 0; if (s) x = -x; if (y < 0) s ^= true, y = -y;
		for (int i = 31; i >= 0; --i) if (r <<= 1, r |= u4 (x >> i & 1), r >= y) r -= y, q |= u4 (1) << i;
		return s ? -q : q;
	}

	extern "C" u4 _div_u4 (const u4 x, const u4 y) noexcept
	{
		u4 q = 0, r = 0;
		for (int i = 31; i >= 0; --i) if (r <<= 1, r |= u4 (x >> i & 1), r >= y) r -= y, q |= u4 (1) << i;
		return q;
	}

#endif

#if defined __amd16__

	asm (R"(
		.code _div_s8
			mov	si, sp
			mov	ecx, [si + 14]
			mov	ebx, [si + 10]
			mov	edx, [si + 6]
			mov	eax, [si + 2]
			mov	esi, ecx
			xor	esi, edx
			sar	esi, 31
			mov	edi, edx
			sar	edi, 31
			xor	eax, edi
			xor	edx, edi
			sub	eax, edi
			sbb	edx, edi
			mov	edi, ecx
			sar	edi, 31
			xor	ebx, edi
			xor	ecx, edi
			sub	ebx, edi
			sbb	ecx, edi
			jnz	big_divisor
			cmp	edx, ebx
			jae	two_divs
			div	ebx
			mov	edx, ecx
			xor	eax, esi
			xor	edx, esi
			sub	eax, esi
			sbb	edx, esi
			ret
		two_divs:
			mov	ecx, eax
			mov	eax, edx
			xor	edx, edx
			div	ebx
			xchg	eax, ecx
			div	ebx
			mov	edx, ecx
			jmp	make_sign
		big_divisor:
			push	esi
			sub	sp, 0xc
			mov	si, sp
			mov	[si], eax
			mov	[si + 4], ebx
			mov	[si + 8], edx
			mov	edi, ecx
			shr	edx, 1
			rcr	eax, 1
			ror	edi, 1
			rcr	ebx, 1
			bsr	ecx, ecx
			shrd	ebx, edi, cl
			shrd	eax, edx, cl
			shr	edx, cl
			rol	edi, 1
			div	ebx
			mov	ebx, [si]
			mov	ecx, eax
			imul	edi, eax
			mul	dword [si + 4]
			add	edx, edi
			sub	ebx, eax
			mov	eax, ecx
			mov	ecx, [si + 8]
			sbb	ecx, edx
			sbb	eax, 0
			xor	edx, edx
			add	sp, 0xc
			pop	esi
		make_sign:
			xor	eax, esi
			xor	edx, esi
			sub	eax, esi
			sbb	edx, esi
			ret

		.code _div_u8
			mov	si, sp
			mov	ecx, [si + 14]
			mov	ebx, [si + 10]
			mov	edx, [si + 6]
			mov	eax, [si + 2]
			test	ecx, ecx
			jnz	big_divisor
			cmp	edx, ebx
			jae	two_divs
			div	ebx
			mov	edx, ecx
			ret
		two_divs:
			mov	ecx, eax
			mov	eax, edx
			xor	edx, edx
			div	ebx
			xchg	eax, ecx
			div	ebx
			mov	edx, ecx
			ret
		big_divisor:
			mov	edi, ecx
			shr	edx, 1
			rcr	eax, 1
			ror	edi, 1
			rcr	ebx, 1
			bsr	ecx, ecx
			shrd	ebx, edi, cl
			shrd	eax, edx, cl
			shr	edx, cl
			rol	edi, 1
			div	ebx
			mov	ebx, [si + 2]
			mov	ecx, eax
			imul	edi, eax
			mul	dword [si + 10]
			add	edx, edi
			sub	ebx, eax
			mov	eax, ecx
			mov	ecx, [si + 6]
			sbb	ecx, edx
			sbb	eax, 0
			xor	edx, edx
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code _div_s8
			mov	ecx, [esp + 16]
			mov	ebx, [esp + 12]
			mov	edx, [esp + 8]
			mov	eax, [esp + 4]
			mov	esi, ecx
			xor	esi, edx
			sar	esi, 31
			mov	edi, edx
			sar	edi, 31
			xor	eax, edi
			xor	edx, edi
			sub	eax, edi
			sbb	edx, edi
			mov	edi, ecx
			sar	edi, 31
			xor	ebx, edi
			xor	ecx, edi
			sub	ebx, edi
			sbb	ecx, edi
			jnz	big_divisor
			cmp	edx, ebx
			jae	two_divs
			div	ebx
			mov	edx, ecx
			xor	eax, esi
			xor	edx, esi
			sub	eax, esi
			sbb	edx, esi
			ret
		two_divs:
			mov	ecx, eax
			mov	eax, edx
			xor	edx, edx
			div	ebx
			xchg	eax, ecx
			div	ebx
			mov	edx, ecx
			jmp	make_sign
		big_divisor:
			sub	esp, 0xc
			mov	[esp], eax
			mov	[esp + 4], ebx
			mov	[esp + 8], edx
			mov	edi, ecx
			shr	edx, 1
			rcr	eax, 1
			ror	edi, 1
			rcr	ebx, 1
			bsr	ecx, ecx
			shrd	ebx, edi, cl
			shrd	eax, edx, cl
			shr	edx, cl
			rol	edi, 1
			div	ebx
			mov	ebx, [esp]
			mov	ecx, eax
			imul	edi, eax
			mul	dword [esp + 4]
			add	edx, edi
			sub	ebx, eax
			mov	eax, ecx
			mov	ecx, [esp + 8]
			sbb	ecx, edx
			sbb	eax, 0
			xor	edx, edx
			add	esp, 0xc
		make_sign:
			xor	eax, esi
			xor	edx, esi
			sub	eax, esi
			sbb	edx, esi
			ret

		.code _div_u8
			mov	ecx, [esp + 16]
			mov	ebx, [esp + 12]
			mov	edx, [esp + 8]
			mov	eax, [esp + 4]
			test	ecx, ecx
			jnz	big_divisor
			cmp	edx, ebx
			jae	two_divs
			div	ebx
			mov	edx, ecx
			ret
		two_divs:
			mov	ecx, eax
			mov	eax, edx
			xor	edx, edx
			div	ebx
			xchg	eax, ecx
			div	ebx
			mov	edx, ecx
			ret
		big_divisor:
			mov	edi, ecx
			shr	edx, 1
			rcr	eax, 1
			ror	edi, 1
			rcr	ebx, 1
			bsr	ecx, ecx
			shrd	ebx, edi, cl
			shrd	eax, edx, cl
			shr	edx, cl
			rol	edi, 1
			div	ebx
			mov	ebx, [esp + 4]
			mov	ecx, eax
			imul	edi, eax
			mul	dword [esp + 12]
			add	edx, edi
			sub	ebx, eax
			mov	eax, ecx
			mov	ecx, [esp + 8]
			sbb	ecx, edx
			sbb	eax, 0
			xor	edx, edx
			ret
	)");

#else

	extern "C" s8 _div_s8 (s8 x, s8 y) noexcept
	{
		u8 q = 0, r = 0; bool s = x < 0; if (s) x = -x; if (y < 0) s ^= true, y = -y;
		for (int i = 63; i >= 0; --i) if (r <<= 1, r |= u8 (x >> i & 1), r >= y) r -= y, q |= u8 (1) << i;
		return s ? -q : q;
	}

	extern "C" u8 _div_u8 (const u8 x, const u8 y) noexcept
	{
		u8 q = 0, r = 0;
		for (int i = 63; i >= 0; --i) if (r <<= 1, r |= u8 (x >> i & 1), r >= y) r -= y, q |= u8 (1) << i;
		return q;
	}

#endif

extern "C" f4 _div_f4 (const f4 x, const f4 y) noexcept
{
	union {f4 v; u4 c;} pa {x}, pb {y}, pr; fp4 a, b, r; UNPACK4 (pa, a); UNPACK4 (pb, b);
	r.s = a.s ^ b.s;
	r.m = (a.m << 8) / (b.m >> 15);
	r.e = a.e - b.e + 127;
	if (~r.m & 0x0080'0000) r.m <<= 1, r.e -= 1;
	PACK4 (r, pr); return pr.v;
}

extern "C" f8 _div_f8 (const f8 x, const f8 y) noexcept
{
	union {f8 v; u8 c;} pa {x}, pb {y}, pr; fp8 a, b, r; UNPACK8 (pa, a); UNPACK8 (pb, b);
	r.s = a.s ^ b.s;
	r.m = (a.m << 11) / (b.m >> 41);
	r.e = a.e - b.e + 1023;
	if (~r.m & 0x0010'0000'0000'0000) r.m <<= 1, r.e -= 1;
	PACK8 (r, pr); return pr.v;
}

// intermediate mod instruction

extern "C" s1 _mod_s1 (s1 x, s1 y) noexcept
{
	u1 r = 0; bool s = x < 0; if (s) x = -x; if (y < 0) s ^= true, y = -y;
	for (int i = 7; i >= 0; --i) if (r <<= 1, r |= u1 (x >> i & 1), r >= y) r -= y;
	return s ? -r : r;
}

extern "C" u1 _mod_u1 (const u1 x, const u1 y) noexcept
{
	u1 r = 0;
	for (int i = 7; i >= 0; --i) if (r <<= 1, r |= u1 (x >> i & 1), r >= y) r -= y;
	return r;
}

extern "C" s2 _mod_s2 (s2 x, s2 y) noexcept
{
	u2 r = 0; bool s = x < 0; if (s) x = -x; if (y < 0) s ^= true, y = -y;
	for (int i = 15; i >= 0; --i) if (r <<= 1, r |= u2 (x >> i & 1), r >= y) r -= y;
	return s ? -r : r;
}

extern "C" u2 _mod_u2 (const u2 x, const u2 y) noexcept
{
	u2 r = 0;
	for (int i = 15; i >= 0; --i) if (r <<= 1, r |= u2 (x >> i & 1), r >= y) r -= y;
	return r;
}

#if defined __arma32__

	asm (R"(
		.code _mod_s4
			ldr	r2, [sp, 0]
			ldr	r3, [sp, 4]
			mov	r0, r2, asr 31
			add	r2, r2, r0
			eor	r2, r2, r0
			mov	r1, r3, asr 31
			add	r3, r3, r1
			eor	r3, r3, r1
			eor	r1, r0, r1
			clz	r4, r2
			clz	r5, r3
			sub	r4, r5, r4
			add	r4, r4, 1
			mov	r5, 0
			b	check
		loop:	cmp	r2, r3, lsl r4
			adc	r5, r5, r5
			subcs	r2, r2, r3, lsl r4
		check:	subs	r4, r4, 1
			bpl	loop
			add	r0, r2, r1
			eor	r0, r0, r1
			bx	lr

		.code _mod_u4
			ldr	r2, [sp, 0]
			ldr	r3, [sp, 4]
			clz	r4, r2
			clz	r5, r3
			sub	r4, r5, r4
			add	r4, r4, 1
			mov	r5, 0
			b	check
		loop:	cmp	r2, r3, lsl r4
			adc	r5, r5, r5
			subcs	r2, r2, r3, lsl r4
		check:	subs	r4, r4, 1
			bpl	loop
			mov	r0, r2
			bx	lr
	)");

#else

	extern "C" s4 _mod_s4 (s4 x, s4 y) noexcept
	{
		u4 r = 0; bool s = x < 0; if (s) x = -x; if (y < 0) s ^= true, y = -y;
		for (int i = 31; i >= 0; --i) if (r <<= 1, r |= u4 (x >> i & 1), r >= y) r -= y;
		return s ? -r : r;
	}

	extern "C" u4 _mod_u4 (const u4 x, const u4 y) noexcept
	{
		u4 r = 0;
		for (int i = 31; i >= 0; --i) if (r <<= 1, r |= u4 (x >> i & 1), r >= y) r -= y;
		return r;
	}

#endif

#if defined __amd16__

	asm (R"(
		.code _mod_s8
			mov	si, sp
			mov	ecx, [si + 14]
			mov	ebx, [si + 10]
			mov	edx, [si + 6]
			mov	eax, [si + 2]
			mov	esi, edx
			sar	esi, 31
			mov	edi, edx
			sar	edi, 31
			xor	eax, edi
			xor	edx, edi
			sub	eax, edi
			sbb	edx, edi
			mov	edi, ecx
			sar	edi, 31
			xor	ebx, edi
			xor	ecx, edi
			sub	ebx, edi
			sbb	ecx, edi
			jnz	sr_big_divisor
			cmp	edx, ebx
			jae	sr_two_divs
			div	ebx
			mov	eax, edx
			mov	edx, ecx
			xor	eax, esi
			xor	edx, esi
			sub	eax, esi
			sbb	edx, esi
			ret
		sr_two_divs:
			mov	ecx, eax
			mov	eax, edx
			xor	edx, edx
			div	ebx
			mov	eax, ecx
			div	ebx
			mov	eax, edx
			xor	edx, edx
			jmp	sr_makesign
		sr_big_divisor:
			push	esi
			sub	sp, 16
			mov	si, sp
			mov	[si], eax
			mov	[si + 4], ebx
			mov	[si + 8], edx
			mov	[si + 12], ecx
			mov	edi, ecx
			shr	edx, 1
			rcr	eax, 1
			ror	edi, 1
			rcr	ebx, 1
			bsr	ecx, ecx
			shrd	ebx, edi, cl
			shrd	eax, edx, cl
			shr	edx, cl
			rol	edi, 1
			div	ebx
			mov	ebx, [si]
			mov	ecx, eax
			imul	edi, eax
			mul	dword [si + 4]
			add	edx, edi
			sub	ebx, eax
			mov	ecx, [si + 8]
			sbb	ecx, edx
			sbb	eax, eax
			mov	edx, [si + 12]
			and	edx, eax
			and	eax, [si + 4]
			add	eax, ebx
			add	edx, ecx
			add	sp, 16
			pop	esi
		sr_makesign:
			xor	eax, esi
			xor	edx, esi
			sub	eax, esi
			sbb	edx, esi
			ret

		.code _mod_u8
			mov	si, sp
			mov	ecx, [si + 14]
			mov	ebx, [si + 10]
			mov	edx, [si + 6]
			mov	eax, [si + 2]
			test	ecx, ecx
			jnz	r_big_divisor
			cmp	edx, ebx
			jae	r_two_divs
			div	ebx
			mov	eax, edx
			mov	edx, ecx
			ret
		r_two_divs:
			mov	ecx, eax
			mov	eax, edx
			xor	edx, edx
			div	ebx
			mov	eax, ecx
			div	ebx
			mov	eax, edx
			xor	edx, edx
			ret
		r_big_divisor:
			mov	edi, ecx
			shr	edx, 1
			rcr	eax, 1
			ror	edi, 1
			rcr	ebx, 1
			bsr	ecx, ecx
			shrd	ebx, edi, cl
			shrd	eax, edx, cl
			shr	edx, cl
			rol	edi, 1
			div	ebx
			mov	ebx, [si + 2]
			mov	ecx, eax
			imul	edi, eax
			mul	dword [si + 10]
			add	edx, edi
			sub	ebx, eax
			mov	ecx, [si + 6]
			mov	eax, [si + 10]
			sbb	ecx, edx
			sbb	edx, edx
			and	eax, edx
			and	edx, [si + 14]
			add	eax, ebx
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code _mod_s8
			mov	ecx, [esp + 16]
			mov	ebx, [esp + 12]
			mov	edx, [esp + 8]
			mov	eax, [esp + 4]
			mov	esi, edx
			sar	esi, 31
			mov	edi, edx
			sar	edi, 31
			xor	eax, edi
			xor	edx, edi
			sub	eax, edi
			sbb	edx, edi
			mov	edi, ecx
			sar	edi, 31
			xor	ebx, edi
			xor	ecx, edi
			sub	ebx, edi
			sbb	ecx, edi
			jnz	sr_big_divisor
			cmp	edx, ebx
			jae	sr_two_divs
			div	ebx
			mov	eax, edx
			mov	edx, ecx
			xor	eax, esi
			xor	edx, esi
			sub	eax, esi
			sbb	edx, esi
			ret
		sr_two_divs:
			mov	ecx, eax
			mov	eax, edx
			xor	edx, edx
			div	ebx
			mov	eax, ecx
			div	ebx
			mov	eax, edx
			xor	edx, edx
			jmp	sr_makesign
		sr_big_divisor:
			sub	esp, 16
			mov	[esp], eax
			mov	[esp + 4], ebx
			mov	[esp + 8], edx
			mov	[esp + 12], ecx
			mov	edi, ecx
			shr	edx, 1
			rcr	eax, 1
			ror	edi, 1
			rcr	ebx, 1
			bsr	ecx, ecx
			shrd	ebx, edi, cl
			shrd	eax, edx, cl
			shr	edx, cl
			rol	edi, 1
			div	ebx
			mov	ebx, [esp]
			mov	ecx, eax
			imul	edi, eax
			mul	dword [esp + 4]
			add	edx, edi
			sub	ebx, eax
			mov	ecx, [esp + 8]
			sbb	ecx, edx
			sbb	eax, eax
			mov	edx, [esp + 12]
			and	edx, eax
			and	eax, [esp + 4]
			add	eax, ebx
			add	edx, ecx
			add	esp, 16
		sr_makesign:
			xor	eax, esi
			xor	edx, esi
			sub	eax, esi
			sbb	edx, esi
			ret

		.code _mod_u8
			mov	ecx, [esp + 16]
			mov	ebx, [esp + 12]
			mov	edx, [esp + 8]
			mov	eax, [esp + 4]
			test	ecx, ecx
			jnz	r_big_divisor
			cmp	edx, ebx
			jae	r_two_divs
			div	ebx
			mov	eax, edx
			mov	edx, ecx
			ret
		r_two_divs:
			mov	ecx, eax
			mov	eax, edx
			xor	edx, edx
			div	ebx
			mov	eax, ecx
			div	ebx
			mov	eax, edx
			xor	edx, edx
			ret
		r_big_divisor:
			mov	edi, ecx
			shr	edx, 1
			rcr	eax, 1
			ror	edi, 1
			rcr	ebx, 1
			bsr	ecx, ecx
			shrd	ebx, edi, cl
			shrd	eax, edx, cl
			shr	edx, cl
			rol	edi, 1
			div	ebx
			mov	ebx, [esp + 4]
			mov	ecx, eax
			imul	edi, eax
			mul	dword [esp + 12]
			add	edx, edi
			sub	ebx, eax
			mov	ecx, [esp + 8]
			mov	eax, [esp + 12]
			sbb	ecx, edx
			sbb	edx, edx
			and	eax, edx
			and	edx, [esp + 16]
			add	eax, ebx
			ret
	)");

#else

	extern "C" s8 _mod_s8 (s8 x, s8 y) noexcept
	{
		u8 r = 0; bool s = x < 0; if (s) x = -x; if (y < 0) s ^= true, y = -y;
		for (int i = 63; i >= 0; --i) if (r <<= 1, r |= u8 (x >> i & 1), r >= y) r -= y;
		return s ? -r : r;
	}

	extern "C" u8 _mod_u8 (const u8 x, const u8 y) noexcept
	{
		u8 r = 0;
		for (int i = 63; i >= 0; --i) if (r <<= 1, r |= u8 (x >> i & 1), r >= y) r -= y;
		return r;
	}

#endif

// intermediate lsh instruction

#if defined __amd16__

	asm (R"(
		.code _lsh_s8
			.alias	_lsh_u8
			mov	si, sp
			mov	eax, [si + 2]
			mov	edx, [si + 6]
			mov	ecx, [si + 10]
			shld	edx, eax, cl
			shl	eax, cl
			test	ecx, 32
			jz	done
			mov	edx, eax
			xor	eax, eax
		done:	ret
	)");

#elif defined __amd32__

	asm (R"(
		.code _lsh_s8
			.alias	_lsh_u8
			mov	eax, [esp + 4]
			mov	edx, [esp + 8]
			mov	ecx, [esp + 12]
			shld	edx, eax, cl
			shl	eax, cl
			test	ecx, 32
			jz	done
			mov	edx, eax
			xor	eax, eax
		done:	ret
	)");

#elif defined __arma32__

	asm (R"(
		.code _lsh_s8
			.alias	_lsh_u8
			ldr	r2, [sp, 0]
			ldr	r3, [sp, 4]
			ldr	r4, [sp, 8]
			ldr	r5, [sp, 12]
			cmp	r5, 0
			movne	r4, 64
			rsbs	r5, r4, 32
			submi	r5, r4, 32
			movmi	r1, r2, lsl r5
			movpl	r1, r3, lsl r4
			orrpl	r1, r1, r2, lsr r5
			mov	r0, r2, lsl r4
			bx	lr
	)");

#else

	extern "C" s8 _lsh_s8 ALIAS (_lsh_u8) (const s8 x, const s8 y) noexcept
	{
		union {s8 v; us8 c;} a {x}, b {y}, r;
		if (b.c.l >= 32) r.c.l = 0, r.c.h = a.c.l << b.c.l - 32;
		else r.c.l = a.c.l << b.c.l, r.c.h = a.c.h << b.c.l | a.c.l >> 32 - b.c.l;
		return r.v;
	}

#endif

// intermediate rsh instruction

#if defined __amd16__

	asm (R"(
		.code _rsh_s8
			mov	si, sp
			mov	eax, [si + 2]
			mov	edx, [si + 6]
			mov	ecx, [si + 10]
			shrd	eax, edx, cl
			sar	edx, cl
			test	ecx, 32
			jz	done
			mov	eax, edx
			cdq
		done:	ret

		.code _rsh_u8
			mov	si, sp
			mov	eax, [si + 2]
			mov	edx, [si + 6]
			mov	ecx, [si + 10]
			shrd	eax, edx, cl
			shr	edx, cl
			test	ecx, 32
			jz	done
			mov	eax, edx
			xor	edx, edx
		done:	ret
	)");

#elif defined __amd32__

	asm (R"(
		.code _rsh_s8
			mov	eax, [esp + 4]
			mov	edx, [esp + 8]
			mov	ecx, [esp + 12]
			shrd	eax, edx, cl
			sar	edx, cl
			test	ecx, 32
			jz	done
			mov	eax, edx
			cdq
		done:	ret

		.code _rsh_u8
			mov	eax, [esp + 4]
			mov	edx, [esp + 8]
			mov	ecx, [esp + 12]
			shrd	eax, edx, cl
			shr	edx, cl
			test	ecx, 32
			jz	done
			mov	eax, edx
			xor	edx, edx
		done:	ret
	)");

#elif defined __arma32__

	asm (R"(
		.code _rsh_s8
			ldr	r2, [sp, 0]
			ldr	r3, [sp, 4]
			ldr	r4, [sp, 8]
			ldr	r5, [sp, 12]
			cmp	r5, 0
			movne	r4, 64
			rsbs	r5, r4, 32
			submi	r5, r4, 32
			movmi	r0, r3, asr r5
			movpl	r0, r2, lsr r4
			orrpl	r0, r0, r3, lsl r5
			mov	r1, r3, asr r4
			bx	lr

		.code _rsh_u8
			ldr	r2, [sp, 0]
			ldr	r3, [sp, 4]
			ldr	r4, [sp, 8]
			ldr	r5, [sp, 12]
			cmp	r5, 0
			movne	r4, 64
			rsbs	r5, r4, 32
			submi	r5, r4, 32
			movmi	r0, r3, lsr r5
			movpl	r0, r2, lsr r4
			orrpl	r0, r0, r3, lsl r5
			mov	r1, r3, lsr r4
			bx	lr
	)");

#else

	extern "C" s8 _rsh_s8 (const s8 x, const s8 y) noexcept
	{
		union {s8 v; us8 c;} a {x}, b {y}, r;
		if (b.c.l >= 32) r.c.l = a.c.h >> s4 (b.c.l) - 32, r.c.h = a.c.h >> 31;
		else r.c.l = a.c.l >> b.c.l | a.c.h << 32 - b.c.l, r.c.h = a.c.h >> s4 (b.c.l);
		return r.v;
	}

	extern "C" u8 _rsh_u8 (const u8 x, const u8 y) noexcept
	{
		union {u8 v; uu8 c;} a {x}, b {y}, r;
		if (b.c.l >= 32) r.c.l = a.c.h >> b.c.l - 32, r.c.h = 0;
		else r.c.l = a.c.l >> b.c.l | a.c.h << 32 - b.c.l, r.c.h = a.c.h >> b.c.l;
		return r.v;
	}

#endif

// intermediate breq instruction

extern "C" bool _breq_f4 (const f4 x, const f4 y) noexcept
{
	union {f4 v; u4 c;} a {x}, b {y};
	return a.c == b.c;
}

extern "C" bool _breq_f8 (const f8 x, const f8 y) noexcept
{
	union {f8 v; u8 c;} a {x}, b {y};
	return a.c == b.c;
}

// intermediate brne instruction

extern "C" bool _brne_f4 (const f4 x, const f4 y) noexcept
{
	union {f4 v; u4 c;} a {x}, b {y};
	return a.c != b.c;
}

extern "C" bool _brne_f8 (const f8 x, const f8 y) noexcept
{
	union {f8 v; u8 c;} a {x}, b {y};
	return a.c != b.c;
}

// intermediate brlt instruction

extern "C" bool _brlt_f4 (const f4 x, const f4 y) noexcept
{
	union {f4 v; u4 c;} pa {x}, pb {y}; fp4 a, b; UNPACK4 (pa, a); UNPACK4 (pb, b);
	return a.s > b.s || a.s == b.s && (a.s ? a.e > b.e || a.e == b.e && a.m > b.m : a.e < b.e || a.e == b.e && a.m < b.m);
}

extern "C" bool _brlt_f8 (const f8 x, const f8 y) noexcept
{
	union {f8 v; u8 c;} pa {x}, pb {y}; fp8 a, b; UNPACK8 (pa, a); UNPACK8 (pb, b);
	return a.s > b.s || a.s == b.s && (a.s ? a.e > b.e || a.e == b.e && a.m > b.m : a.e < b.e || a.e == b.e && a.m < b.m);
}

// intermediate brge instruction

extern "C" bool _brge_f4 (const f4 x, const f4 y) noexcept
{
	union {f4 v; u4 c;} pa {x}, pb {y}; fp4 a, b; UNPACK4 (pa, a); UNPACK4 (pb, b);
	return a.s < b.s || a.s == b.s && (a.s ? a.e < b.e || a.e == b.e && a.m <= b.m : a.e > b.e || a.e == b.e && a.m >= b.m);
}

extern "C" bool _brge_f8 (const f8 x, const f8 y) noexcept
{
	union {f8 v; u8 c;} pa {x}, pb {y}; fp8 a, b; UNPACK8 (pa, a); UNPACK8 (pb, b);
	return a.s < b.s || a.s == b.s && (a.s ? a.e < b.e || a.e == b.e && a.m <= b.m : a.e > b.e || a.e == b.e && a.m >= b.m);
}

#include "../libraries/cpp/cctype"
#include "../libraries/cpp/cmath"
#include "../libraries/cpp/cstdio"
#include "../libraries/cpp/cstring"

// standard copysignf function

float std::copysignf FLOATALIAS (copysign) (const float mag, const float sgn) noexcept
{
	const union {f4 v; u4 c;} m {mag}, s {sgn}, r;
	r.c = m.c & 0x7fff'ffff | s.c & 0x8000'0000;
	return r.v;
}

// standard copysignl function

long double std::copysignl LONGALIAS (copysign) (const long double mag, const long double sgn) noexcept
{
	const union {f8 v; uu8 c;} m {mag}, s {sgn}, r;
	r.c.h = m.c.h & 0x7fff'ffff | s.c.h & 0x8000'0000; r.c.l = m.c.l;
	return r.v;
}

// standard fflush function

int std::fflush [[ecs::replaceable]] (FILE*const) noexcept
{
	return EOF;
}

// standard floorf function

#if defined __amd16__

	asm (R"(
		.code floorf
			push	word 0x077f
			mov	si, sp
			fldcw	[si]
			pop	ax
			fld	dword [si + 4]
			frndint
			push	word 0x0f7f
			fldcw	[si]
			pop	ax
			fstp	st1
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code floorf
			push	word 0x077f
			fldcw	[esp]
			pop	ax
			fld	dword [esp + 4]
			frndint
			push	word 0x0f7f
			fldcw	[esp]
			pop	ax
			fstp	st1
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code floorf
			movsd		xmm0, [rsp + 8]
			cvttss2si	rax, xmm0
			cvtsi2ss	xmm1, rax
			subss		xmm0, xmm1
			movd		rbx, xmm0
			bt		rbx, 63
			sbb		rax, 0
			cvtsi2ss	xmm0, rax
			ret
	)");

#elif defined __mmix__

	asm (R"(
		.code floorf
			ldou	$0, $1, 8
			fint	$0, 3, $0
			ldou	$255, $1, 0
			addu	$1, $1, 8
			go	$255, $255, 0
	)");

#elif not defined __code__

	extern "C" float floorf FLOATALIAS (floor) (const float x) noexcept
	{
		const float r = float (s4 (x)); return r - float (r > x);
	}

#endif

// standard floorl function

#if defined __amd16__

	asm (R"(
		.code floorl
			.alias	floor
			push	word 0x077f
			mov	si, sp
			fldcw	[si]
			pop	ax
			fld	qword [si + 4]
			frndint
			push	word 0x0f7f
			fldcw	[si]
			pop	ax
			fstp	st1
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code floorl
			.alias	floor
			push	word 0x077f
			fldcw	[esp]
			pop	ax
			fld	qword [esp + 4]
			frndint
			push	word 0x0f7f
			fldcw	[esp]
			pop	ax
			fstp	st1
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code floorl
			.alias	floor
			movsd		xmm0, [rsp + 8]
			cvttsd2si	rax, xmm0
			cvtsi2sd	xmm1, rax
			subsd		xmm0, xmm1
			movd		rbx, xmm0
			bt		rbx, 63
			sbb		rax, 0
			cvtsi2sd	xmm0, rax
			ret
	)");

#elif defined __mmix__

	asm (R"(
		.code floorl
			.alias	floor
			ldou	$0, $1, 8
			fint	$0, 3, $0
			ldou	$255, $1, 0
			addu	$1, $1, 8
			go	$255, $255, 0
	)");

#elif not defined __code__

	extern "C" long double floorl LONGALIAS (floor) (const long double x) noexcept
	{
		const float r = float (s8 (x)); return r - float (r > x);
	}

#endif

// standard getchar function

int std::getchar [[ecs::replaceable]] () noexcept
{
	return fgetc (stdin);
}

// standard isfinite function

bool std::isfinite FLOATALIAS (std::isfinite(double)) (const float x) noexcept
{
	const union {f4 v; u4 c;} a {x};
	return (a.c & 0x7f80'0000) != 0x7f80'0000;
}

bool std::isfinite LONGALIAS (std::isfinite(double)) (const long double x) noexcept
{
	const union {f8 v; uu8 c;} a {x};
	return (a.c.h & 0x7ff0'0000) != 0x7ff0'0000;
}

// standard isinf function

bool std::isinf FLOATALIAS (std::isinf(double)) (const float x) noexcept
{
	const union {f4 v; u4 c;} a {x};
	return (a.c & 0x7fff'ffff) == 0x7f80'0000;
}

bool std::isinf LONGALIAS (std::isinf(double)) (const long double x) noexcept
{
	const union {f8 v; uu8 c;} a {x};
	return (a.c.h & 0x7fff'ffff) == 0x7ff0'0000 && a.c.l == 0x0000'0000;
}

// standard isnan function

bool std::isnan FLOATALIAS (std::isnan(double)) (const float x) noexcept
{
	const union {f4 v; u4 c;} a {x};
	return (a.c & 0x7f80'0000) == 0x7f80'0000 && (a.c & 0x007f'ffff) != 0x0000'0000;
}

bool std::isnan LONGALIAS (std::isnan(double)) (const long double x) noexcept
{
	const union {f8 v; uu8 c;} a {x};
	return (a.c.h & 0x7ff0'0000) == 0x7ff0'0000 && ((a.c.h & 0x000f'ffff) != 0x0000'0000 || a.c.l != 0x0000'0000);
}

// standard isnormal function

bool std::isnormal FLOATALIAS (std::isnormal(double)) (const float x) noexcept
{
	const union {f4 v; u4 c;} a {x}; const u4 exponent = a.c & 0x7f80'0000;
	return exponent != 0x0000'0000 && exponent != 0x7f80'0000;
}

bool std::isnormal LONGALIAS (std::isnormal(double)) (const long double x) noexcept
{
	const union {f8 v; uu8 c;} a {x}; const u4 exponent = a.c.h & 0x7ff0'0000;
	return exponent != 0x0000'0000 && exponent != 0x7ff0'0000;
}

// standard putchar function

int std::putchar [[ecs::replaceable]] (const int character) noexcept
{
	return fputc (character, stdout);
}

// standard puts function

int std::puts (const char* string) noexcept
{
	while (*string) putchar (*string), ++string;
	return putchar ('\n');
}

// standard signbit function

bool std::signbit FLOATALIAS (std::signbit(double)) (const float x) noexcept
{
	const union {f4 v; u4 c;} a {x};
	return a.c & 0x8000'0000;
}

bool std::signbit LONGALIAS (std::signbit(double)) (const long double x) noexcept
{
	const union {f8 v; uu8 c;} a {x};
	return a.c.h & 0x8000'0000;
}

// standard sqrtf function

#if defined __amd16__

	asm (R"(
		.code sqrtf
			mov	si, sp
			fld	dword [si + 2]
			fsqrt
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code sqrtf
			fld	dword [esp + 4]
			fsqrt
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code sqrtf
			fld	dword [rsp + 8]
			fsqrt
			fstp	dword [rsp - 8]
			movss	xmm0, [rsp - 8]
			ret
	)");

#elif defined __arma64__

	asm (R"(
		.code sqrtf
			ldr	s0, [sp]
			fsqrt	s0, s0
			ret
	)");

#else

	float std::sqrtf FLOATALIAS (sqrt) (const float x) noexcept
	{
		auto result = x;
		for (int i = 0; i != 10; ++i) result = (x / result + result) * 0.5f;
		return result;
	}

#endif

// standard sqrtl function

#if defined __amd16__

	asm (R"(
		.code sqrtl
			.alias	sqrt
			mov	si, sp
			fld	qword [si + 2]
			fsqrt
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code sqrtl
			.alias	sqrt
			fld	qword [esp + 4]
			fsqrt
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code sqrtl
			.alias	sqrt
			fld	qword [rsp + 8]
			fsqrt
			fstp	qword [rsp - 8]
			movsd	xmm0, [rsp - 8]
			ret
	)");

#elif defined __arma64__

	asm (R"(
		.code sqrtl
			.alias	sqrt
			ldr	d0, [sp]
			fsqrt	d0, d0
			ret
	)");

#else

	long double std::sqrtl LONGALIAS (sqrt) (const long double x) noexcept
	{
		auto result = x;
		for (int i = 0; i != 10; ++i) result = (x / result + result) * 0.5;
		return result;
	}

#endif
// standard strcmp function

int std::strcmp (const char* left, const char* right) noexcept
{
	while (*left != '\0' && *left == *right) ++left, ++right;
	return int (*left) - int (*right);
}

// standard tolower function

int std::tolower (const int c) noexcept
{
	return c >= 'A' && c <= 'Z' ? c + 32 : c;
}

// standard toupper function

int std::toupper (const int c) noexcept
{
	return c >= 'a' && c <= 'z' ? c - 32 : c;
}

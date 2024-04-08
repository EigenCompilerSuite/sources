# Standard C++ execution test and validation suite
# Copyright (C) Florian Negele

# This file is part of the Eigen Compiler Suite.

# The ECS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# The ECS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with the ECS.  If not, see <https://www.gnu.org/licenses/>.

# todo: 4.5 [intro.object] 6

# 5.13.5 [lex.string] 4

positive: raw string example

	#include <cassert>
	#include <cstring>

	const char* p = R"(a\
	b
	c)";

	int main ()
	{
		assert(std::strcmp(p, "a\\\nb\nc") == 0);
	}

# 6.6.1 [basic.start.main] 1

negative: missing main function

# 7.7 [conv.fpprom] 1

positive: promoting prvalue of type float to prvalue of type double

	#include <cassert>

	double f (float x) {return x;}

	int main ()
	{
		assert (f (0.0f) == 0.0);
		assert (f (0.5f) == 0.5);
		assert (f (1.0f) == 1.0);
		assert (f (1.5f) == 1.5);
	}

# 7.8 [conv.integral] 2

positive: unsigned conversion from signed char to char

	#include <cassert>
	#include <climits>

	unsigned char f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == (SCHAR_MIN & UCHAR_MAX));
		assert (f (SCHAR_MAX) == (SCHAR_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from signed short to char

	#include <cassert>
	#include <climits>

	unsigned char f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == (SHRT_MIN & UCHAR_MAX));
		assert (f (SHRT_MAX) == (SHRT_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from signed int to char

	#include <cassert>
	#include <climits>

	unsigned char f (signed int x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == (INT_MIN & UCHAR_MAX));
		assert (f (INT_MAX) == (INT_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from signed long to char

	#include <cassert>
	#include <climits>

	unsigned char f (signed long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == (LONG_MIN & UCHAR_MAX));
		assert (f (LONG_MAX) == (LONG_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from signed long long to char

	#include <cassert>
	#include <climits>

	unsigned char f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LLONG_MIN) == (LLONG_MIN & UCHAR_MAX));
		assert (f (LLONG_MAX) == (LLONG_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from signed char to short

	#include <cassert>
	#include <climits>

	unsigned short f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == (SCHAR_MIN & USHRT_MAX));
		assert (f (SCHAR_MAX) == (SCHAR_MAX & USHRT_MAX));
	}

positive: unsigned conversion from signed short to short

	#include <cassert>
	#include <climits>

	unsigned short f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == (SHRT_MIN & USHRT_MAX));
		assert (f (SHRT_MAX) == (SHRT_MAX & USHRT_MAX));
	}

positive: unsigned conversion from signed int to short

	#include <cassert>
	#include <climits>

	unsigned short f (signed int x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == (INT_MIN & USHRT_MAX));
		assert (f (INT_MAX) == (INT_MAX & USHRT_MAX));
	}

positive: unsigned conversion from signed long to short

	#include <cassert>
	#include <climits>

	unsigned short f (signed long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == (LONG_MIN & USHRT_MAX));
		assert (f (LONG_MAX) == (LONG_MAX & USHRT_MAX));
	}

positive: unsigned conversion from signed long long to short

	#include <cassert>
	#include <climits>

	unsigned short f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LLONG_MIN) == (LLONG_MIN & USHRT_MAX));
		assert (f (LLONG_MAX) == (LLONG_MAX & USHRT_MAX));
	}

positive: unsigned conversion from signed char to int

	#include <cassert>
	#include <climits>

	unsigned int f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == (SCHAR_MIN & UINT_MAX));
		assert (f (SCHAR_MAX) == (SCHAR_MAX & UINT_MAX));
	}

positive: unsigned conversion from signed short to int

	#include <cassert>
	#include <climits>

	unsigned int f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == (SHRT_MIN & UINT_MAX));
		assert (f (SHRT_MAX) == (SHRT_MAX & UINT_MAX));
	}

positive: unsigned conversion from signed int to int

	#include <cassert>
	#include <climits>

	unsigned int f (signed int x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == (INT_MIN & UINT_MAX));
		assert (f (INT_MAX) == (INT_MAX & UINT_MAX));
	}

positive: unsigned conversion from signed long to int

	#include <cassert>
	#include <climits>

	unsigned int f (signed long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == (LONG_MIN & UINT_MAX));
		assert (f (LONG_MAX) == (LONG_MAX & UINT_MAX));
	}

positive: unsigned conversion from signed long long to int

	#include <cassert>
	#include <climits>

	unsigned int f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LLONG_MIN) == (LLONG_MIN & UINT_MAX));
		assert (f (LLONG_MAX) == (LLONG_MAX & UINT_MAX));
	}

positive: unsigned conversion from signed char to long

	#include <cassert>
	#include <climits>

	unsigned long f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == (SCHAR_MIN & ULONG_MAX));
		assert (f (SCHAR_MAX) == (SCHAR_MAX & ULONG_MAX));
	}

positive: unsigned conversion from signed short to long

	#include <cassert>
	#include <climits>

	unsigned long f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == (SHRT_MIN & ULONG_MAX));
		assert (f (SHRT_MAX) == (SHRT_MAX & ULONG_MAX));
	}

positive: unsigned conversion from signed int to long

	#include <cassert>
	#include <climits>

	unsigned long f (signed int x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == (INT_MIN & ULONG_MAX));
		assert (f (INT_MAX) == (INT_MAX & ULONG_MAX));
	}

positive: unsigned conversion from signed long to long

	#include <cassert>
	#include <climits>

	unsigned long f (signed long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == (LONG_MIN & ULONG_MAX));
		assert (f (LONG_MAX) == (LONG_MAX & ULONG_MAX));
	}

positive: unsigned conversion from signed long long to long

	#include <cassert>
	#include <climits>

	unsigned long f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LLONG_MIN) == (LLONG_MIN & ULONG_MAX));
		assert (f (LLONG_MAX) == (LLONG_MAX & ULONG_MAX));
	}

positive: unsigned conversion from signed char to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == (SCHAR_MIN & ULLONG_MAX));
		assert (f (SCHAR_MAX) == (SCHAR_MAX & ULLONG_MAX));
	}

positive: unsigned conversion from signed short to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == (SHRT_MIN & ULLONG_MAX));
		assert (f (SHRT_MAX) == (SHRT_MAX & ULLONG_MAX));
	}

positive: unsigned conversion from signed int to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (signed int x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == (INT_MIN & ULLONG_MAX));
		assert (f (INT_MAX) == (INT_MAX & ULLONG_MAX));
	}

positive: unsigned conversion from signed long to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (signed long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == (LONG_MIN & ULLONG_MAX));
		assert (f (LONG_MAX) == (LONG_MAX & ULLONG_MAX));
	}

positive: unsigned conversion from signed long long to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LLONG_MIN) == (LLONG_MIN & ULLONG_MAX));
		assert (f (LLONG_MAX) == (LLONG_MAX & ULLONG_MAX));
	}

positive: unsigned conversion from unsigned short to char

	#include <cassert>
	#include <climits>

	unsigned char f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (USHRT_MAX) == (USHRT_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from unsigned int to char

	#include <cassert>
	#include <climits>

	unsigned char f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (UINT_MAX) == (UINT_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from unsigned long to char

	#include <cassert>
	#include <climits>

	unsigned char f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (ULONG_MAX) == (ULONG_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from unsigned long long to char

	#include <cassert>
	#include <climits>

	unsigned char f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (ULLONG_MAX) == (ULLONG_MAX & UCHAR_MAX));
	}

positive: unsigned conversion from unsigned char to short

	#include <cassert>
	#include <climits>

	unsigned short f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (UCHAR_MAX) == (UCHAR_MAX & USHRT_MAX));
	}

positive: unsigned conversion from unsigned int to short

	#include <cassert>
	#include <climits>

	unsigned short f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (UINT_MAX) == (UINT_MAX & USHRT_MAX));
	}

positive: unsigned conversion from unsigned long to short

	#include <cassert>
	#include <climits>

	unsigned short f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (ULONG_MAX) == (ULONG_MAX & USHRT_MAX));
	}

positive: unsigned conversion from unsigned long long to short

	#include <cassert>
	#include <climits>

	unsigned short f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (ULLONG_MAX) == (ULLONG_MAX & USHRT_MAX));
	}

positive: unsigned conversion from unsigned char to int

	#include <cassert>
	#include <climits>

	unsigned int f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (UCHAR_MAX) == (UCHAR_MAX & UINT_MAX));
	}

positive: unsigned conversion from unsigned short to int

	#include <cassert>
	#include <climits>

	unsigned int f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (USHRT_MAX) == (USHRT_MAX & UINT_MAX));
	}

positive: unsigned conversion from unsigned long to int

	#include <cassert>
	#include <climits>

	unsigned int f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (ULONG_MAX) == (ULONG_MAX & UINT_MAX));
	}

positive: unsigned conversion from unsigned long long to int

	#include <cassert>
	#include <climits>

	unsigned int f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (ULLONG_MAX) == (ULLONG_MAX & UINT_MAX));
	}

positive: unsigned conversion from unsigned char to long

	#include <cassert>
	#include <climits>

	unsigned long f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (UCHAR_MAX) == (UCHAR_MAX & ULONG_MAX));
	}

positive: unsigned conversion from unsigned short to long

	#include <cassert>
	#include <climits>

	unsigned long f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (USHRT_MAX) == (USHRT_MAX & ULONG_MAX));
	}

positive: unsigned conversion from unsigned int to long

	#include <cassert>
	#include <climits>

	unsigned long f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (UINT_MAX) == (UINT_MAX & ULONG_MAX));
	}

positive: unsigned conversion from unsigned long long to long

	#include <cassert>
	#include <climits>

	unsigned long f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (ULLONG_MAX) == (ULLONG_MAX & ULONG_MAX));
	}

positive: unsigned conversion from unsigned char to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (UCHAR_MAX) == (UCHAR_MAX & ULLONG_MAX));
	}

positive: unsigned conversion from unsigned short to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (USHRT_MAX) == (USHRT_MAX & ULLONG_MAX));
	}

positive: unsigned conversion from unsigned int to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (UINT_MAX) == (UINT_MAX & ULLONG_MAX));
	}

positive: unsigned conversion from unsigned long to long long

	#include <cassert>
	#include <climits>

	unsigned long long f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (ULONG_MAX) == (ULONG_MAX & ULLONG_MAX));
	}

# 7.8 [conv.integral] 3

positive: signed conversion from signed short to char

	#include <cassert>
	#include <climits>

	signed char f (signed short x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == SCHAR_MIN);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from signed int to char

	#include <cassert>
	#include <climits>

	signed char f (signed int x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == SCHAR_MIN);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from signed long to char

	#include <cassert>
	#include <climits>

	signed char f (signed long x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == SCHAR_MIN);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from signed long long to char

	#include <cassert>
	#include <climits>

	signed char f (signed long long x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == SCHAR_MIN);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from signed char to short

	#include <cassert>
	#include <climits>

	signed short f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == SCHAR_MIN);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from signed int to short

	#include <cassert>
	#include <climits>

	signed short f (signed int x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == SHRT_MIN);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from signed long to short

	#include <cassert>
	#include <climits>

	signed short f (signed long x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == SHRT_MIN);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from signed long long to short

	#include <cassert>
	#include <climits>

	signed short f (signed long long x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == SHRT_MIN);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from signed char to int

	#include <cassert>
	#include <climits>

	signed int f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == SCHAR_MIN);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from signed short to int

	#include <cassert>
	#include <climits>

	signed int f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == SHRT_MIN);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from signed long to int

	#include <cassert>
	#include <climits>

	signed int f (signed long x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == INT_MIN);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from signed long long to int

	#include <cassert>
	#include <climits>

	signed int f (signed long long x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == INT_MIN);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from signed char to long

	#include <cassert>
	#include <climits>

	signed long f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == SCHAR_MIN);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from signed short to long

	#include <cassert>
	#include <climits>

	signed long f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == SHRT_MIN);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from signed int to long

	#include <cassert>
	#include <climits>

	signed long f (signed int x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == INT_MIN);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from signed long long to long

	#include <cassert>
	#include <climits>

	signed long f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == LONG_MIN);
		assert (f (LONG_MAX) == LONG_MAX);
	}

positive: signed conversion from signed char to long long

	#include <cassert>
	#include <climits>

	signed long long f (signed char x) {return x;}

	int main ()
	{
		assert (f (SCHAR_MIN) == SCHAR_MIN);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from signed short to long long

	#include <cassert>
	#include <climits>

	signed long long f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == SHRT_MIN);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from signed int to long long

	#include <cassert>
	#include <climits>

	signed long long f (signed int x) {return x;}

	int main ()
	{
		assert (f (INT_MIN) == INT_MIN);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from signed long to long long

	#include <cassert>
	#include <climits>

	signed long long f (signed long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == LONG_MIN);
		assert (f (LONG_MAX) == LONG_MAX);
	}

positive: signed conversion from unsigned char to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned short to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned int to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned long to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned long long to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned char to short

	#include <cassert>
	#include <climits>

	signed short f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned short to short

	#include <cassert>
	#include <climits>

	signed short f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from unsigned int to short

	#include <cassert>
	#include <climits>

	signed short f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from unsigned long to short

	#include <cassert>
	#include <climits>

	signed short f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from unsigned long long to short

	#include <cassert>
	#include <climits>

	signed short f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from unsigned char to int

	#include <cassert>
	#include <climits>

	signed int f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned short to int

	#include <cassert>
	#include <climits>

	signed int f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from unsigned int to int

	#include <cassert>
	#include <climits>

	signed int f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from unsigned long to int

	#include <cassert>
	#include <climits>

	signed int f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from unsigned long long to int

	#include <cassert>
	#include <climits>

	signed int f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from unsigned char to long

	#include <cassert>
	#include <climits>

	signed long f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned short to long

	#include <cassert>
	#include <climits>

	signed long f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from unsigned int to long

	#include <cassert>
	#include <climits>

	signed long f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from unsigned long to long

	#include <cassert>
	#include <climits>

	signed long f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (LONG_MAX) == LONG_MAX);
	}

positive: signed conversion from unsigned long long to long

	#include <cassert>
	#include <climits>

	signed long f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (LONG_MAX) == LONG_MAX);
	}

positive: signed conversion from unsigned char to long long

	#include <cassert>
	#include <climits>

	signed long long f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SCHAR_MAX) == SCHAR_MAX);
	}

positive: signed conversion from unsigned short to long long

	#include <cassert>
	#include <climits>

	signed long long f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (SHRT_MAX) == SHRT_MAX);
	}

positive: signed conversion from unsigned int to long long

	#include <cassert>
	#include <climits>

	signed long long f (unsigned int x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (INT_MAX) == INT_MAX);
	}

positive: signed conversion from unsigned long to long long

	#include <cassert>
	#include <climits>

	signed long long f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (LONG_MAX) == LONG_MAX);
	}

positive: signed conversion from signed long long to long long

	#include <cassert>
	#include <climits>

	signed long long f (signed long long x) {return x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (LLONG_MAX) == LLONG_MAX);
	}

# 7.8 [conv.integral] 4

positive: unsigned conversion from bool to char

	#include <cassert>

	unsigned char f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: unsigned conversion from bool to short

	#include <cassert>

	unsigned short f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: unsigned conversion from bool to int

	#include <cassert>

	unsigned int f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: unsigned conversion from bool to long

	#include <cassert>

	unsigned long f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: unsigned conversion from bool to long long

	#include <cassert>

	unsigned long long f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: signed conversion from bool to char

	#include <cassert>

	signed char f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: signed conversion from bool to short

	#include <cassert>

	signed short f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: signed conversion from bool to int

	#include <cassert>

	signed int f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: signed conversion from bool to long

	#include <cassert>

	signed long f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

positive: signed conversion from bool to long long

	#include <cassert>

	signed long long f (bool x) {return x;}

	int main ()
	{
		assert (f (true));
		assert (!f (false));
	}

# todo: 7.13 [conv.fctptr] 1

# 8.1.3 [expr.prim.paren] 1

positive: value of parenthesized expression

	#include <cassert>

	void f (int a, int b) {assert (a + b == (a + b));}

	int main ()
	{
		f (0, 7);
		f (1, 3);
		f (2, 1);
		f (4, 0);
	}

# 8.3.1 [expr.unary.op] 7

positive: integral identity

	#include <cassert>

	int f (int x) {return +x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (1) == 1);
		assert (f (2) == 2);
		assert (f (-4) == -4);
	}

positive: enumeration identity

	#include <cassert>

	enum E {a, b, c};

	int f (E x) {return +x;}

	int main ()
	{
		assert (f (a) == a);
		assert (f (b) == b);
		assert (f (c) == c);
	}

positive: pointer identity

	#include <cassert>

	int* f (int* x) {return +x;}

	int main ()
	{
		int a, b, c;
		assert (f (&a) == &a);
		assert (f (&b) == &b);
		assert (f (&c) == &c);
	}

# 8.3.1 [expr.unary.op] 8

positive: signed negation

	#include <cassert>

	signed f (signed x) {return -x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (1) == -1);
		assert (f (2) == -2);
		assert (f (-4) == +4);
	}

positive: unsigned negation

	#include <cassert>

	unsigned f (unsigned x) {return -x;}

	int main ()
	{
		assert (f (0) == 0);
		assert (f (1) == -1);
		assert (f (2) == -2);
		assert (f (-4) == +4);
	}

positive: enumeration negation

	#include <cassert>

	enum E {a, b, c};

	int f (E x) {return -x;}

	int main ()
	{
		assert (f (a) == -a);
		assert (f (b) == -b);
		assert (f (c) == -c);
	}

# 8.3.1 [expr.unary.op] 9

positive: logical NOT operation

	#include <cassert>

	bool f (bool x) {return !x;}

	int main ()
	{
		assert (f (true) == false);
		assert (f (false) == true);
	}

# 8.3.1 [expr.unary.op] 10

positive: bitwise NOT operation

	#include <cassert>

	unsigned f (unsigned x) {return ~x;}

	int main ()
	{
		assert ((f (0b000) & 0b111) == 0b111);
		assert ((f (0b001) & 0b111) == 0b110);
		assert ((f (0b011) & 0b111) == 0b100);
		assert ((f (0b111) & 0b111) == 0b000);
	}

# 8.6 [expr.mul] 3

positive: integral multiplication

	#include <cassert>

	int f (int a, int b) {return a * b;}

	int main ()
	{
		assert (f (0, 7) == 0);
		assert (f (1, 3) == 3);
		assert (f (2, 1) == 2);
		assert (f (4, 0) == 0);
	}

positive: floating-point multiplication

	#include <cassert>

	double f (double a, double b) {return a * b;}

	int main ()
	{
		assert (f (0, 2.5) == 0);
		assert (f (1, 1.5) == 1.5);
		assert (f (2, 0.5) == 1);
		assert (f (4, 0) == 0);
	}

# 8.6 [expr.mul] 4

positive: integral quotient of division

	#include <cassert>

	int f (int a, int b) {return a / b;}

	int main ()
	{
		assert (f (10, 1) == 10);
		assert (f (10, 2) == 5);
		assert (f (10, 4) == 2);
	}

positive: floating-point quotient of division

	#include <cassert>

	double f (double a, double b) {return a / b;}

	int main ()
	{
		assert (f (10, 1) == 10);
		assert (f (10, 2) == 5);
		assert (f (10, 4) == 2.5);
	}

positive: integral remainder of division

	#include <cassert>

	int f (int a, int b) {return a % b;}

	int main ()
	{
		assert (f (10, 1) == 0);
		assert (f (10, 2) == 0);
		assert (f (10, 4) == 2);
	}

positive: binary / operator yielding algebraic quotient for integral operands with discarded fractional part

	#include <cassert>

	int f (int a, int b) {return a / b;}

	int main ()
	{
		assert (f (10, 2) == 5);
		assert (f (10, -3) == -3);
		assert (f (-10, 4) == -2);
		assert (f (-10, -5) == 2);
	}

positive: quotient times divisor plus remainder equal to dividend

	#include <cassert>

	int f (int a, int b) {return (a / b) * b + a % b;}

	int main ()
	{
		assert (f (10, 4) == 10);
		assert (f (10, -4) == 10);
		assert (f (-10, 4) == -10);
		assert (f (-10, -4) == -10);
	}

# 8.7 [expr.add] 3

positive: integral addition

	#include <cassert>

	int f (int a, int b) {return a + b;}

	int main ()
	{
		assert (f (0, 7) == 7);
		assert (f (1, 3) == 4);
		assert (f (2, 1) == 3);
		assert (f (4, 0) == 4);
	}

positive: floating-point addition

	#include <cassert>

	double f (double a, double b) {return a + b;}

	int main ()
	{
		assert (f (0, 2.5) == 2.5);
		assert (f (1, 1.5) == 2.5);
		assert (f (2, 0.5) == 2.5);
		assert (f (4, 0) == 4);
	}

positive: integral subtraction

	#include <cassert>

	int f (int a, int b) {return a - b;}

	int main ()
	{
		assert (f (0, 7) == -7);
		assert (f (1, 3) == -2);
		assert (f (2, 1) == 1);
		assert (f (4, 0) == 4);
	}

positive: floating-point subtraction

	#include <cassert>

	double f (double a, double b) {return a - b;}

	int main ()
	{
		assert (f (0, 2.5) == -2.5);
		assert (f (1, 1.5) == -0.5);
		assert (f (2, 0.5) == 1.5);
		assert (f (4, 0) == 4);
	}

# 8.7 [expr.add] 4

positive: pointer addition

	#include <cassert>
	#include <cstddef>

	int* f (int* a, std::ptrdiff_t b) {return a + b;}
	int* g (std::ptrdiff_t a, int* b) {return a + b;}

	int main ()
	{
		int x[10];
		assert (f (&x[0], 7) == x + 7);
		assert (f (&x[1], 3) == x + 4);
		assert (f (&x[2], 1) == x + 3);
		assert (f (&x[4], 0) == x + 4);
		assert (g (0, &x[7]) == x + 7);
		assert (g (-1, &x[3]) == x + 2);
		assert (g (2, &x[1]) == x + 3);
		assert (g (4, &x[0]) == x + 4);
	}

positive: pointer subtraction

	#include <cassert>
	#include <cstddef>

	int* f (int* a, std::ptrdiff_t b) {return a - b;}

	int main ()
	{
		int x[10];
		assert (f (&x[0], -7) == x + 7);
		assert (f (&x[1], -3) == x + 4);
		assert (f (&x[2], 1) == x + 1);
		assert (f (&x[4], 0) == x + 4);
	}

# 8.7 [expr.add] 5

positive: pointer difference

	#include <cassert>
	#include <cstddef>

	std::ptrdiff_t f (int* a, int* b) {return a - b;}

	int main ()
	{
		int x[10];
		assert (f (&x[0], x + 7) == -7);
		assert (f (&x[1], x + 3) == -2);
		assert (f (&x[2], x + 1) == 1);
		assert (f (&x[4], x + 0) == 4);
	}

# 8.7 [expr.add] 7

positive: null pointer addition

	#include <cassert>
	#include <cstddef>

	int* f (int* a, std::ptrdiff_t b) {return a + b;}
	int* g (std::ptrdiff_t a, int* b) {return a + b;}

	int main ()
	{
		assert (f (nullptr, 0) == nullptr);
		assert (g (0, nullptr) == nullptr);
	}

positive: null pointer subtraction

	#include <cassert>
	#include <cstddef>

	int* f (int* a, std::ptrdiff_t b) {return a - b;}

	int main ()
	{
		assert (f (nullptr, 0) == nullptr);
	}

positive: null pointer difference

	#include <cassert>
	#include <cstddef>

	std::ptrdiff_t f (int* a, int* b) {return a - b;}

	int main ()
	{
		assert (f (nullptr, nullptr) == 0);
	}

# 8.8 [expr.shift] 1

positive: left-shift operator grouping left-to-right

	#include <cassert>

	int main ()
	{
		int x = 2;
		assert (1 << x << 3 == 32);
	}

positive: right-shift operator grouping left-to-right

	#include <cassert>

	int main ()
	{
		int x = 2;
		assert (16 >> x >> 1 == 2);
	}

# 8.8 [expr.shift] 2

positive: left-shift operation with unsigned left-hand operand

	#include <cassert>

	int f (unsigned a, unsigned b) {return a << b;}

	int main ()
	{
		assert (f (0, 7) == 0);
		assert (f (1, 3) == 8);
		assert (f (2, 1) == 4);
		assert (f (4, 0) == 4);
	}

positive: left-shift operation with signed left-hand operand

	#include <cassert>

	int f (signed a, signed b) {return a << b;}

	int main ()
	{
		assert (f (0, 7) == 0);
		assert (f (1, 3) == 8);
		assert (f (-2, 1) == -4);
		assert (f (-4, 0) == -4);
	}

# 8.8 [expr.shift] 3

positive: right-shift operation with unsigned left-hand operand

	#include <cassert>

	int f (unsigned a, unsigned b) {return a >> b;}

	int main ()
	{
		assert (f (10, 7) == 0);
		assert (f (10, 3) == 1);
		assert (f (10, 1) == 5);
		assert (f (10, 0) == 10);
	}

positive: right-shift operation with signed left-hand operand

	#include <cassert>

	int f (signed a, signed b) {return a >> b;}

	int main ()
	{
		assert (f (10, 7) == 0);
		assert (f (10, 3) == 1);
		assert (f (10, 1) == 5);
		assert (f (10, 0) == 10);
	}

# 8.8 [expr.shift] 4

positive: left-hand operand sequenced before right-hand operand in left-shift operation

	#include <cassert>

	int main ()
	{
		int x = 0;
		assert (++x << ++x == 4);
		assert (++x << ++x == 48);
	}

positive: left-hand operand sequenced before right-hand operand in right-shift operation

	#include <cassert>

	int main ()
	{
		int x = 5;
		assert (--x >> --x == 0);
		assert (--x >> --x == 1);
	}

# 8.11 [expr.bit.and] 1

positive: return value of bitwise AND operation

	#include <cassert>

	int f (int a, int b) {return a & b;}

	int main ()
	{
		assert (f (0b000, 0b111) == 0b000);
		assert (f (0b001, 0b011) == 0b001);
		assert (f (0b010, 0b001) == 0b000);
		assert (f (0b100, 0b000) == 0b000);
	}

# 8.12 [expr.xor] 1

positive: return value of bitwise exclusive OR operation

	#include <cassert>

	int f (int a, int b) {return a ^ b;}

	int main ()
	{
		assert (f (0b000, 0b111) == 0b111);
		assert (f (0b001, 0b011) == 0b010);
		assert (f (0b010, 0b001) == 0b011);
		assert (f (0b100, 0b000) == 0b100);
	}

# 8.13 [expr.or] 1

positive: return value of bitwise inclusive OR operation

	#include <cassert>

	int f (int a, int b) {return a | b;}

	int main ()
	{
		assert (f (0b000, 0b111) == 0b111);
		assert (f (0b001, 0b011) == 0b011);
		assert (f (0b010, 0b001) == 0b011);
		assert (f (0b100, 0b000) == 0b100);
	}

# 8.14 [expr.log.and] 1

positive: return value of logical AND operator

	#include <cassert>

	bool f (bool a, bool b) {return a && b;}

	int main ()
	{
		assert (!f (false, false));
		assert (!f (true, false));
		assert (!f (false, true));
		assert (f (true, true));
	}

positive: short circuit evaluation of logical AND operator

	#include <cassert>

	bool f (bool a, bool b) {return a && (assert (false), b);}

	int main ()
	{
		assert (!f (false, false));
		assert (!f (false, true));
	}

# 8.14 [expr.log.and] 2

positive: left-to-right evaluation of logical AND operator

	#include <cassert>

	int main ()
	{
		int x = 0;
		assert (++x && (assert (x == 1), true));
		assert (!(--x && (assert (false), true)));
	}

# 8.15 [expr.log.or] 1

positive: return value of logical OR operator

	#include <cassert>

	bool f (bool a, bool b) {return a || b;}

	int main ()
	{
		assert (!f (false, false));
		assert (f (true, false));
		assert (f (false, true));
		assert (f (true, true));
	}

positive: short circuit evaluation of logical OR operator

	#include <cassert>

	bool f (bool a, bool b) {return a || (assert (false), b);}

	int main ()
	{
		assert (f (true, false));
		assert (f (true, true));
	}

# 8.15 [expr.log.or] 2

positive: left-to-right evaluation of logical OR operator

	#include <cassert>

	int main ()
	{
		int x = 0;
		assert (++x || (assert (false), true));
		assert (--x || (assert (x == 0), true));
	}

# 8.19 [expr.comma] 1

positive: comma operator grouping left-to-right

	#include <cassert>

	int main ()
	{
		int x = 0;
		assert ((x = 1, x = 3, ++x) == 4);
	}

positive: left-to-right evaluation of comma operator

	#include <cassert>

	int main ()
	{
		int x = 1;
		assert ((++x, x = 3) == 3);
	}

negative: comma operator with value of left operand

	#include <cassert>

	int main ()
	{
		auto x = (0.1, 2);
		assert (x == 0.1);
	}

positive: comma operator with type of right operand

	#include <cassert>

	int main ()
	{
		auto x = (0.1, 2);
		assert (x == 2);
	}

# 8.19 [expr.comma] 2

positive: comma operator example

	#include <cassert>

	void f (int x, int y, int z)
	{
		assert (x == 0);
		assert (y == 5);
		assert (z == 2);
	}

	int main ()
	{
		int a = 0, t = 1, c = 2;
		f(a, (t=3, t+2), c);
		assert (t == 3);
	}

# 9.2 [stmt.expr] 1

positive: completed side effects from an expression statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		++x; assert (x == 1);
	}

# 9.4.1 [stmt.if] 1

positive: execution of first substatement of satisfied if statement

	#include <cassert>

	int main ()
	{
		int x = 1;
		if (x == 1) ++x; assert (x == 2);
		if (int y = x - 1) x += x + y; assert (x == 5);
	}

positive: non-execution of first substatement of unsatisfied if statement

	#include <cassert>

	int main ()
	{
		int x = 1;
		if (x != 1) ++x; assert (x == 1);
		if (int y = x - 1) x += x + y; assert (x == 1);
	}

positive: execution of second substatement of unsatisfied if statement

	#include <cassert>

	int main ()
	{
		int x = 1;
		if (x != 1) --x; else ++x; assert (x == 2);
		if (int y = x - 2) --x; else x += x + y; assert (x == 4);
	}

positive: skipped evaluation of condition of if statement

	#include <cassert>

	int main ()
	{
		int x = 1;
		goto label1; if (--x) label1: ++x; else --x; assert (x == 2);
		goto label2; if (--x) --x; else label2: ++x; assert (x == 3);
	}

# 9.4.2 [stmt.switch] 1

positive: control transfer using switch statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		switch (x) ++x; assert (x == 0);
	}

# 9.4.2 [stmt.switch] 5

positive: execution of switch statement without default label

	#include <cassert>

	int f (int x) {switch (x) {case 1: case 4: return 3; case -1: return 2; case 2: ;} return 4;}

	int main ()
	{
		assert (f (-1) == 2);
		assert (f (0) == 4);
		assert (f (1) == 3);
		assert (f (2) == 4);
		assert (f (3) == 4);
	}

positive: execution of switch statement with default label

	#include <cassert>

	int f (int x) {switch (x) {case 1: case 4: return 3; case -1: return 2; default: case 2: return 4;}}

	int main ()
	{
		assert (f (-1) == 2);
		assert (f (0) == 4);
		assert (f (1) == 3);
		assert (f (2) == 4);
		assert (f (3) == 4);
	}

# 9.4.2 [stmt.switch] 6

positive: unimpeded control flow accross case and default labels

	#include <cassert>

	int main ()
	{
		int x = 0;
		switch (x) {case 0: ++x; case 1: ++x; default: ++x;} assert (x == 3);
	}

# 9.5.1 [stmt.while] 1

positive: repeated execution of while statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		while (x != 10) ++x; assert (x == 10);
		while (int y = x - 1) x = y; assert (x == 1);
	}

positive: evaluation of while statement condition before execution of substatement

	#include <cassert>

	int main ()
	{
		int x = 10;
		while (--x) assert (x != 10); assert (x == 0);
	}

# todo: 9.5.1 [stmt.while] 2

# 9.5.2 [stmt.do] 2

positive: repeated execution of do statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		do ++x; while (x != 10); assert (x == 10);
	}

positive: evaluation of do statement condition after execution of substatement

	#include <cassert>

	int main ()
	{
		int x = 10;
		do assert (x != 0); while (--x); assert (x == 0);
	}

# 9.5.3 [stmt.for] 1

positive: execution of for statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		for (int y = 0; y != 10; ++y) ++x; assert (x == 10);
		for (; int y = x - 1; ) x = y; assert (x == 1);
	}

positive: skipped execution of for statement

	#include <cassert>

	int main ()
	{
		int x;
		for (; x = 0; ++x) ++x; assert (x == 0);
		for (x = 0; x; ++x) ++x; assert (x == 0);
	}

# todo: continue

# todo: 9.5.3 [stmt.for] 2
# todo: 9.5.3 [stmt.for] 3

# 9.6.1 [stmt.break] 1

positive: termination of while statement using break statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		while (true) if (++x == 10) break; assert (x == 10);
	}

positive: termination of do statement using break statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		do if (++x == 10) break; while (true); assert (x == 10);
	}

positive: termination of for statement using break statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		for (;;) if (++x == 10) break; assert (x == 10);
	}

positive: termination of switch statement using break statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		switch (x) {case 0: ++x; break; default: --x;} assert (x == 1);
	}

# 9.6.2 [stmt.cont] 1

positive: continuation of while statement using continue statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		while (++x < 10) {if (++x == 5) continue; ++x;} assert (x == 12);
	}

positive: continuation of do statement using continue statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		do {if (++x == 4) continue; ++x;} while (++x < 10); assert (x == 11);
	}

positive: continuation of for statement using continue statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		for (; ++x < 10; ++x) if (++x == 5) continue; assert (x == 10);
	}

# 9.6.4 [stmt.goto] 1

positive: unconditional control transfer using goto statement

	#include <cassert>

	int main ()
	{
		int x = 0;
		label: ++x; if (x < 10) goto label; assert (x == 10);
	}

# todo: 12.2.4 [class.bit] 4

# 22.3.2 [assertions.assert] 1

positive: satisfied enabled assertion

	#undef NDEBUG
	#include <cassert>

	int main ()
	{
		assert (true);
	}

negative: unsatisfied enabled assertion

	#undef NDEBUG
	#include <cassert>

	int main ()
	{
		assert (false);
	}

positive: satisfied disabled assertion

	#define NDEBUG
	#include <cassert>

	int main ()
	{
		assert (true);
	}

positive: unsatisfied disabled assertion

	#define NDEBUG
	#include <cassert>

	int main ()
	{
		assert (false);
	}

positive: enabling and disabling assertions

	#undef NDEBUG
	#include <cassert>
	void f (const bool value) {assert (value);}

	#define NDEBUG
	#include <cassert>
	void g (const bool value) {assert (value);}

	int main ()
	{
		f (true); g (false);
	}

# 24.5.1 [cctype.syn] 1

positive: standard isalnum function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isalnum ('\0')); assert (!std::isalnum ('\x7f'));
		assert (!std::isalnum ('\t')); assert (!std::isalnum (' '));
		assert (!std::isalnum ('\n')); assert (!std::isalnum ('\r'));
		assert (!std::isalnum ('!')); assert (!std::isalnum ('/'));
		assert (std::isalnum ('0')); assert (std::isalnum ('9'));
		assert (!std::isalnum (':')); assert (!std::isalnum ('@'));
		assert (std::isalnum ('A')); assert (std::isalnum ('Z'));
		assert (!std::isalnum ('[')); assert (!std::isalnum ('`'));
		assert (std::isalnum ('a')); assert (std::isalnum ('z'));
		assert (!std::isalnum ('{')); assert (!std::isalnum ('~'));
	}

positive: standard isalpha function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isalpha ('\0')); assert (!std::isalpha ('\x7f'));
		assert (!std::isalpha ('\t')); assert (!std::isalpha (' '));
		assert (!std::isalpha ('\n')); assert (!std::isalpha ('\r'));
		assert (!std::isalpha ('!')); assert (!std::isalpha ('/'));
		assert (!std::isalpha ('0')); assert (!std::isalpha ('9'));
		assert (!std::isalpha (':')); assert (!std::isalpha ('@'));
		assert (std::isalpha ('A')); assert (std::isalpha ('Z'));
		assert (!std::isalpha ('[')); assert (!std::isalpha ('`'));
		assert (std::isalpha ('a')); assert (std::isalpha ('z'));
		assert (!std::isalpha ('{')); assert (!std::isalpha ('~'));
	}

positive: standard isblank function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isblank ('\0')); assert (!std::isblank ('\x7f'));
		assert (std::isblank ('\t')); assert (std::isblank (' '));
		assert (!std::isblank ('\n')); assert (!std::isblank ('\r'));
		assert (!std::isblank ('!')); assert (!std::isblank ('/'));
		assert (!std::isblank ('0')); assert (!std::isblank ('9'));
		assert (!std::isblank (':')); assert (!std::isblank ('@'));
		assert (!std::isblank ('A')); assert (!std::isblank ('Z'));
		assert (!std::isblank ('[')); assert (!std::isblank ('`'));
		assert (!std::isblank ('a')); assert (!std::isblank ('z'));
		assert (!std::isblank ('{')); assert (!std::isblank ('~'));
	}

positive: standard iscntrl function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (std::iscntrl ('\0')); assert (std::iscntrl ('\x7f'));
		assert (std::iscntrl ('\t')); assert (!std::iscntrl (' '));
		assert (std::iscntrl ('\n')); assert (std::iscntrl ('\r'));
		assert (!std::iscntrl ('!')); assert (!std::iscntrl ('/'));
		assert (!std::iscntrl ('0')); assert (!std::iscntrl ('9'));
		assert (!std::iscntrl (':')); assert (!std::iscntrl ('@'));
		assert (!std::iscntrl ('A')); assert (!std::iscntrl ('Z'));
		assert (!std::iscntrl ('[')); assert (!std::iscntrl ('`'));
		assert (!std::iscntrl ('a')); assert (!std::iscntrl ('z'));
		assert (!std::iscntrl ('{')); assert (!std::iscntrl ('~'));
	}

positive: standard isdigit function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isdigit ('\0')); assert (!std::isdigit ('\x7f'));
		assert (!std::isdigit ('\t')); assert (!std::isdigit (' '));
		assert (!std::isdigit ('\n')); assert (!std::isdigit ('\r'));
		assert (!std::isdigit ('!')); assert (!std::isdigit ('/'));
		assert (std::isdigit ('0')); assert (std::isdigit ('9'));
		assert (!std::isdigit (':')); assert (!std::isdigit ('@'));
		assert (!std::isdigit ('A')); assert (!std::isdigit ('Z'));
		assert (!std::isdigit ('[')); assert (!std::isdigit ('`'));
		assert (!std::isdigit ('a')); assert (!std::isdigit ('z'));
		assert (!std::isdigit ('{')); assert (!std::isdigit ('~'));
	}

positive: standard isgraph function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isgraph ('\0')); assert (!std::isgraph ('\x7f'));
		assert (!std::isgraph ('\t')); assert (!std::isgraph (' '));
		assert (!std::isgraph ('\n')); assert (!std::isgraph ('\r'));
		assert (std::isgraph ('!')); assert (std::isgraph ('/'));
		assert (std::isgraph ('0')); assert (std::isgraph ('9'));
		assert (std::isgraph (':')); assert (std::isgraph ('@'));
		assert (std::isgraph ('A')); assert (std::isgraph ('Z'));
		assert (std::isgraph ('[')); assert (std::isgraph ('`'));
		assert (std::isgraph ('a')); assert (std::isgraph ('z'));
		assert (std::isgraph ('{')); assert (std::isgraph ('~'));
	}

positive: standard islower function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::islower ('\0')); assert (!std::islower ('\x7f'));
		assert (!std::islower ('\t')); assert (!std::islower (' '));
		assert (!std::islower ('\n')); assert (!std::islower ('\r'));
		assert (!std::islower ('!')); assert (!std::islower ('/'));
		assert (!std::islower ('0')); assert (!std::islower ('9'));
		assert (!std::islower (':')); assert (!std::islower ('@'));
		assert (!std::islower ('A')); assert (!std::islower ('Z'));
		assert (!std::islower ('[')); assert (!std::islower ('`'));
		assert (std::islower ('a')); assert (std::islower ('z'));
		assert (!std::islower ('{')); assert (!std::islower ('~'));
	}

positive: standard isprint function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isprint ('\0')); assert (!std::isprint ('\x7f'));
		assert (!std::isprint ('\t')); assert (std::isprint (' '));
		assert (!std::isprint ('\n')); assert (!std::isprint ('\r'));
		assert (std::isprint ('!')); assert (std::isprint ('/'));
		assert (std::isprint ('0')); assert (std::isprint ('9'));
		assert (std::isprint (':')); assert (std::isprint ('@'));
		assert (std::isprint ('A')); assert (std::isprint ('Z'));
		assert (std::isprint ('[')); assert (std::isprint ('`'));
		assert (std::isprint ('a')); assert (std::isprint ('z'));
		assert (std::isprint ('{')); assert (std::isprint ('~'));
	}

positive: standard ispunct function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::ispunct ('\0')); assert (!std::ispunct ('\x7f'));
		assert (!std::ispunct ('\t')); assert (!std::ispunct (' '));
		assert (!std::ispunct ('\n')); assert (!std::ispunct ('\r'));
		assert (std::ispunct ('!')); assert (std::ispunct ('/'));
		assert (!std::ispunct ('0')); assert (!std::ispunct ('9'));
		assert (std::ispunct (':')); assert (std::ispunct ('@'));
		assert (!std::ispunct ('A')); assert (!std::ispunct ('Z'));
		assert (std::ispunct ('[')); assert (std::ispunct ('`'));
		assert (!std::ispunct ('a')); assert (!std::ispunct ('z'));
		assert (std::ispunct ('{')); assert (std::ispunct ('~'));
	}

positive: standard isspace function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isspace ('\0')); assert (!std::isspace ('\x7f'));
		assert (std::isspace ('\t')); assert (!std::isspace (' '));
		assert (std::isspace ('\n')); assert (std::isspace ('\r'));
		assert (!std::isspace ('!')); assert (!std::isspace ('/'));
		assert (!std::isspace ('0')); assert (!std::isspace ('9'));
		assert (!std::isspace (':')); assert (!std::isspace ('@'));
		assert (!std::isspace ('A')); assert (!std::isspace ('Z'));
		assert (!std::isspace ('[')); assert (!std::isspace ('`'));
		assert (!std::isspace ('a')); assert (!std::isspace ('z'));
		assert (!std::isspace ('{')); assert (!std::isspace ('~'));
	}

positive: standard isupper function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isupper ('\0')); assert (!std::isupper ('\x7f'));
		assert (!std::isupper ('\t')); assert (!std::isupper (' '));
		assert (!std::isupper ('\n')); assert (!std::isupper ('\r'));
		assert (!std::isupper ('!')); assert (!std::isupper ('/'));
		assert (!std::isupper ('0')); assert (!std::isupper ('9'));
		assert (!std::isupper (':')); assert (!std::isupper ('@'));
		assert (std::isupper ('A')); assert (std::isupper ('Z'));
		assert (!std::isupper ('[')); assert (!std::isupper ('`'));
		assert (!std::isupper ('a')); assert (!std::isupper ('z'));
		assert (!std::isupper ('{')); assert (!std::isupper ('~'));
	}

positive: standard isxdigit function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		assert (!std::isxdigit ('\0')); assert (!std::isxdigit ('\x7f'));
		assert (!std::isxdigit ('\t')); assert (!std::isxdigit (' '));
		assert (!std::isxdigit ('\n')); assert (!std::isxdigit ('\r'));
		assert (!std::isxdigit ('!')); assert (!std::isxdigit ('/'));
		assert (std::isxdigit ('0')); assert (std::isxdigit ('9'));
		assert (!std::isxdigit (':')); assert (!std::isxdigit ('@'));
		assert (std::isxdigit ('A')); assert (!std::isxdigit ('g'));
		assert (!std::isxdigit ('[')); assert (!std::isxdigit ('`'));
		assert (std::isxdigit ('a')); assert (!std::isxdigit ('g'));
		assert (!std::isxdigit ('{')); assert (!std::isxdigit ('~'));
	}

positive: standard tolower function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		for (int c = 0; c != 128; ++c)
			if (std::isalpha (c)) assert (std::islower (std::tolower (c)));
	}

positive: standard toupper function

	#include <cassert>
	#include <cctype>

	int main ()
	{
		for (int c = 0; c != 128; ++c)
			if (std::isalpha (c)) assert (std::isupper (std::toupper (c)));
	}

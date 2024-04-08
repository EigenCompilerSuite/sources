# Extended C++ execution test and validation suite
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

# 5.13.5 [lex.string] 16

positive: equal string literals stored in the same object

	#include <cassert>

	int main ()
	{
		const char *a = "hello";
		const char *b = R"(hello)";
		assert (a == b);
	}

# 7.8 [conv.integral] 3

positive: signed conversion from signed short to char

	#include <cassert>
	#include <climits>

	signed char f (signed short x) {return x;}

	int main ()
	{
		assert (f (SHRT_MIN) == 0);
		assert (f (SHRT_MAX) == -1);
	}

positive: signed conversion from signed long to char

	#include <cassert>
	#include <climits>

	signed char f (signed long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == 0);
		assert (f (LONG_MAX) == -1);
	}

positive: signed conversion from signed long long to char

	#include <cassert>
	#include <climits>

	signed char f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LLONG_MIN) == 0);
		assert (f (LLONG_MAX) == -1);
	}

positive: signed conversion from signed long to short

	#include <cassert>
	#include <climits>

	signed short f (signed long x) {return x;}

	int main ()
	{
		assert (f (LONG_MIN) == 0);
		assert (f (LONG_MAX) == -1);
	}

positive: signed conversion from signed long long to short

	#include <cassert>
	#include <climits>

	signed short f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LLONG_MIN) == 0);
		assert (f (LLONG_MAX) == -1);
	}

positive: signed conversion from signed long long to long

	#include <cassert>
	#include <climits>

	signed long f (signed long long x) {return x;}

	int main ()
	{
		assert (f (LLONG_MIN) == 0);
		assert (f (LLONG_MAX) == -1);
	}

positive: signed conversion from unsigned char to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned char x) {return x;}

	int main ()
	{
		assert (f (UCHAR_MAX) == -1);
	}

positive: signed conversion from unsigned short to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (USHRT_MAX) == -1);
	}

positive: signed conversion from unsigned long to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (ULONG_MAX) == -1);
	}

positive: signed conversion from unsigned long long to char

	#include <cassert>
	#include <climits>

	signed char f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (ULLONG_MAX) == -1);
	}

positive: signed conversion from unsigned short to short

	#include <cassert>
	#include <climits>

	signed short f (unsigned short x) {return x;}

	int main ()
	{
		assert (f (USHRT_MAX) == -1);
	}

positive: signed conversion from unsigned long to short

	#include <cassert>
	#include <climits>

	signed short f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (ULONG_MAX) == -1);
	}

positive: signed conversion from unsigned long long to short

	#include <cassert>
	#include <climits>

	signed short f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (ULLONG_MAX) == -1);
	}

positive: signed conversion from unsigned long to long

	#include <cassert>
	#include <climits>

	signed long f (unsigned long x) {return x;}

	int main ()
	{
		assert (f (ULONG_MAX) == -1);
	}

positive: signed conversion from unsigned long long to long

	#include <cassert>
	#include <climits>

	signed long f (unsigned long long x) {return x;}

	int main ()
	{
		assert (f (ULLONG_MAX) == -1);
	}

positive: signed conversion from signed long long to long long

	#include <cassert>
	#include <climits>

	signed long long f (signed long long x) {return x;}

	int main ()
	{
		assert (f (ULLONG_MAX) == -1);
	}

# 8.8 [expr.shift] 3

positive: right-shift operation with signed left-hand operand

	#include <cassert>

	int f (signed a, signed b) {return a >> b;}

	int main ()
	{
		assert (f (-10, 7) == -1);
		assert (f (-10, 3) == -2);
		assert (f (-10, 1) == -5);
		assert (f (-10, 0) == -10);
	}

# 10.1.3 [dcl.typedef] 9

positive: alias name denoting unnamed class for linkage purposes

	typedef class {} *x, y, z;

	void f (z) {}
	void g [[ecs::alias ("f(y)")]] ();

	int main ()
	{
		g ();
	}

positive: alias name denoting unnamed enumeration for linkage purposes

	typedef enum {} *x, y, z;

	void f (z) {}
	void g [[ecs::alias ("f(y)")]] ();

	int main ()
	{
		g ();
	}

# 10.6.1 [dcl.attr.grammar] 6

positive: register attribute as hint to compilers

	#include <cassert>

	int f ([[ecs::register]] int v)
	{
		[[ecs::register]] int r;
		#if defined __code__
			asm ("mov int r, int v");
		#elif defined __amd16__ || defined __amd32__ || defined __amd64__
			asm ("mov r, v");
		#elif defined __arma32__ || defined __arma64__ || defined __armt32__
			asm ("mov r, v");
		#elif defined __avr__
			asm ("movw r, v");
		#elif defined __avr32__
			asm ("mov r, v");
		#elif defined __m68k__
			asm ("move.w v, r");
		#elif defined __mibl__
			asm ("addi r, v, 0");
		#elif defined __mips32__ || defined __mips64__
			asm ("addiu r, v, 0");
		#elif defined __mmix__
			asm ("addu r, v, 0");
		#elif defined __or1k__
			asm ("l.add r, r0, v");
		#elif defined __ppc32__ || defined __ppc64__
			asm ("mr r, v");
		#elif defined __risc__
			asm ("mov r, v");
		#else
			r = v;
		#endif
		return r;
	}

	int main ()
	{
		assert (f (1234) == 1234);
	}

# 11.4.1 [dcl.fct.def.general] 8

positive: using function-local predefined variable __func__ in different functions

	#include <cassert>
	#include <cstring>

	const char* f () {return __func__;}
	const char* g () {return __func__;}

	int main ()
	{
		const auto fn = f (), gn = g ();
		assert (f () == fn); assert (g () == gn); assert (fn != gn);
		assert (std::strcmp (fn, gn));
	}

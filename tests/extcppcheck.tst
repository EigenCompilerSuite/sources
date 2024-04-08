# Extended C++ compilation test and validation suite
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

# 5.7 [lex.comment] 1

positive: white-space characters following form-feed character in single-line comment

	//\
		\

negative: non-white-space characters following form-feed character in single-line comment

	//a

positive: white-space characters following vertical-tab character in single-line comment

	//\
		\

negative: non-white-space characters following vertical-tab character in single-line comment

	//a

# 5.8 [lex.header] 2

positive: appearance of special characters in header name

	#if false
		#include <">
	#endif

positive: appearance of special characters in source file header name

	#if false
		#include "'\/*//"
	#endif

# 5.11 [lex.key] 1

positive: keywords in attributes

	[[keywords (
		alignas alignof asm auto bool break case catch char char8_t char16_t char32_t class concept const consteval constexpr constinit const_cast continue co_await
		co_return co_yield decltype default delete do double dynamic_cast else enum explicit export extern false float for friend goto if inline int long mutable
		namespace new noexcept nullptr operator private protected public register reinterpret_cast requires return short signed sizeof static static_assert
		static_cast struct switch template this thread_local throw true try typedef typeid typename union unsigned using virtual void volatile wchar_t while
	)]];

# 5.13.3 [lex.ccon] 2

positive: multicharacter literal

	decltype ('xyz') c;
	extern int c;

positive: multicharacter literal value

	static_assert ('xyz' == 'x');

# 5.13.3 [lex.ccon] 6

positive: wide character literal value

	static_assert (L'xyz' == 'x');

# 5.13.3 [lex.ccon] 7

negative: invalid escape sequence

	char c = '\c';

# 5.13.3 [lex.ccon] 8

negative: unrepresentable escape sequence in ordinary character literal

	char c = '\x123';

negative: unrepresentable escape sequence in UTF-8 character literal

	char c = u8'\x100';

negative: unrepresentable escape sequence in char16_t character literal

	char16_t c = u'\x12345';

negative: unrepresentable escape sequence in char32_t character literal

	char32_t c = U'\x123456789';

negative: unrepresentable escape sequence in wide character literal

	wchar_t c = L'\x123456789';

# 5.13.3 [lex.ccon] 9

negative: unrepresentable universal character name in ordinary character literal

	char c = '\u0123';

negative: unrepresentable universal character name in UTF-8 character literal

	char c = u8'\U00000100';

negative: unrepresentable universal character name in char16_t character literal

	char16_t c = u'\U00012345';

# 5.13.4 [lex.fcon] 1

negative: unrepresentable floating literal with f suffix

	float f = 1e100f;

# todo: nearest representable value

# 5.13.5 [lex.string] 13

negative: concatenating UTF-8 string literal with char16_t string literal

	decltype (u8"abc" u"xyz") s;

negative: concatenating UTF-8 string literal with char32_t string literal

	decltype (u8"abc" U"xyz") s;

negative: concatenating char16_t string literal with UTF-8 string literal

	decltype (u"abc" u8"xyz") s;

negative: concatenating char16_t string literal with char32_t string literal

	decltype (u"abc" U"xyz") s;

negative: concatenating char16_t string literal with wide string literal

	decltype (u"abc" L"xyz") s;

negative: concatenating char32_t string literal with UTF-8 string literal

	decltype (U"abc" u8"xyz") s;

negative: concatenating char32_t string literal with char16_t string literal

	decltype (U"abc" u"xyz") s;

negative: concatenating char32_t string literal with wide string literal

	decltype (U"abc" L"xyz") s;

negative: concatenating wide string literal with char16_t string literal

	decltype (L"abc" u"xyz") s;

negative: concatenating wide string literal with char32_t string literal

	decltype (L"abc" U"xyz") s;

# 6.7.4.3 [basic.stc.dynamic.safety] 4

positive: relaxed pointer safety

	#ifdef __STDCPP_STRICT_POINTER_SAFETY__
		#error
	#endif

# 7.8 [conv.integral] 3

positive: signed conversion from signed short to char

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr signed char y = x;
	static_assert (y == 0);

positive: signed conversion from signed long to char

	#include <climits>
	constexpr signed long x = LONG_MIN;
	constexpr signed char y = x;
	static_assert (y == 0);

positive: signed conversion from signed long long to char

	#include <climits>
	constexpr signed long long x = LLONG_MIN;
	constexpr signed char y = x;
	static_assert (y == 0);

positive: signed conversion from signed long to short

	#include <climits>
	constexpr signed long x = LONG_MIN;
	constexpr signed short y = x;
	static_assert (y == 0);

positive: signed conversion from signed long long to short

	#include <climits>
	constexpr signed long long x = LLONG_MIN;
	constexpr signed short y = x;
	static_assert (y == 0);

positive: signed conversion from signed long long to long

	#include <climits>
	constexpr signed long long x = LLONG_MIN;
	constexpr signed long y = x;
	static_assert (y == 0);

positive: signed conversion from unsigned char to char

	#include <climits>
	constexpr unsigned short x = UCHAR_MAX;
	constexpr signed char y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned short to char

	#include <climits>
	constexpr unsigned short x = USHRT_MAX;
	constexpr signed char y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned long to char

	#include <climits>
	constexpr unsigned long x = ULONG_MAX;
	constexpr signed char y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned long long to char

	#include <climits>
	constexpr unsigned long long x = ULLONG_MAX;
	constexpr signed char y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned short to short

	#include <climits>
	constexpr unsigned short x = USHRT_MAX;
	constexpr signed short y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned long to short

	#include <climits>
	constexpr unsigned long x = ULONG_MAX;
	constexpr signed short y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned long long to short

	#include <climits>
	constexpr unsigned long long x = ULLONG_MAX;
	constexpr signed short y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned long to long

	#include <climits>
	constexpr unsigned long x = ULONG_MAX;
	constexpr signed long y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned long long to long

	#include <climits>
	constexpr unsigned long long x = ULLONG_MAX;
	constexpr signed long y = x;
	static_assert (y == -1);

positive: signed conversion from unsigned long long to long long

	#include <climits>
	constexpr unsigned long long x = ULLONG_MAX;
	constexpr signed long long y = x;
	static_assert (y == -1);

# 8.8 [expr.shift] 3

positive: right-shift operation with signed left-hand operand

	static_assert (-130 >> 5 == -130 / 32 - 1);

# 10 [dcl.dcl] 3

positive: deprecated attribute declaration

	[[deprecated]];

# 10 [dcl.dcl] 6

# todo: static assertion example

# 10.4 [dcl.asm] 1

positive: asm declaration in namespace scope

	asm ("");

positive: attributed asm declaration in namespace scope

	[[]] asm ("");

positive: asm declaration in block scope

	void f () {asm ("");}

positive: attributed asm declaration in block scope

	void f () {[[]] asm ("");}

negative: asm declaration missing asm keyword

	("");

negative: asm declaration missing opening parenthesis

	asm "");

negative: asm declaration missing string literal

	asm ();

negative: asm declaration missing closing parenthesis

	asm ("";

negative: asm declaration missing semicolon

	asm ("")

# 10.6.1 [dcl.attr.grammar] 4

negative: alias attribute as pack expansion

	int x [[ecs::alias ("alias")...]];

negative: duplicable attribute as pack expansion

	int x [[ecs::duplicable...]];

negative: group attribute as pack expansion

	int x [[ecs::group ("group")...]];

negative: origin attribute as pack expansion

	int x [[ecs::origin (0)...]];

negative: replaceable attribute as pack expansion

	int x [[ecs::replaceable...]];

negative: required attribute as pack expansion

	int x [[ecs::required...]];

# 10.6.1 [dcl.attr.grammar] 6

positive: alias attribute applied to function

	int f [[ecs::alias ("g")]] ();

positive: alias attribute applied to member function

	class c {int f [[ecs::alias ("g")]] ();};

positive: alias attribute applied to global variable

	int x [[ecs::alias ("y")]];

negative: alias attribute applied to local variable

	void f () {int x [[ecs::alias ("y")]];}

negative: alias attribute applied to parameter

	void f (int x [[ecs::alias ("y")]]);

positive: alias attribute applied to static variable

	void f () {static int x [[ecs::alias ("y")]];}

negative: alias attribute applied to data member

	class c {int x [[ecs::alias ("y")]];};

positive: alias attribute applied to static data member

	class c {static int x [[ecs::alias ("y")]];};

positive: multiple alias attributes in different attribute specifier sequences

	[[ecs::alias ("y")]] int x [[ecs::alias ("y")]];

positive: multiple alias attributes in different attribute lists

	int x [[ecs::alias ("y")]] [[ecs::alias ("y")]];

negative: multiple alias attributes in same attribute list

	int x [[ecs::alias ("y"), ecs::alias ("y")]];

negative: alias attribute without argument

	int x [[ecs::alias]];

positive: alias attribute with argument

	int x [[ecs::alias ("y")]];

negative: alias attribute with argument missing opening parenthesis

	int x [[ecs::alias "y")]];

negative: alias attribute with argument missing string literal

	int x [[ecs::alias ()]];

negative: alias attribute with argument missing closing parenthesis

	int x [[ecs::alias ("y"]];

negative: alias attribute with argument missing parentheses

	int x [[ecs::alias "y"]];

negative: alias attribute with empty string literal

	int x [[ecs::alias ("")]];

negative: alias attribute with integer literal

	int x [[ecs::alias (0)]];

positive: alias attribute in all declarations

	void f [[ecs::alias ("g")]] ();
	void f [[ecs::alias ("g")]] ();

positive: alias attribute in first declaration

	void f [[ecs::alias ("g")]] ();
	void f ();

positive: alias attribute in second declaration

	void f ();
	void f [[ecs::alias ("g")]] ();

negative: alias attribute redeclared with different arguments

	void f [[ecs::alias ("g")]] ();
	void f [[ecs::alias ("h")]] ();

positive: duplicable attribute applied to function

	int f [[ecs::duplicable]] ();

positive: duplicable attribute applied to inline function

	inline int f [[ecs::duplicable]] ();

positive: duplicable attribute applied to member function

	class c {int f [[ecs::duplicable]] ();};

positive: duplicable attribute applied to inline member function

	class c {inline int f [[ecs::duplicable]] ();};

positive: duplicable attribute applied to global variable

	int x [[ecs::duplicable]];

positive: duplicable attribute applied to inline variable

	inline int x [[ecs::duplicable]];

negative: duplicable attribute applied to local variable

	void f () {int x [[ecs::duplicable]];}

negative: duplicable attribute applied to parameter

	void f (int x [[ecs::duplicable]]);

positive: duplicable attribute applied to static variable

	void f () {static int x [[ecs::duplicable]];}

negative: duplicable attribute applied to data member

	class c {int x [[ecs::duplicable]];};

positive: duplicable attribute applied to static data member

	class c {static int x [[ecs::duplicable]];};

positive: duplicable attribute applied to static inline data member

	class c {static inline int x [[ecs::duplicable]];};

positive: multiple duplicable attributes in different attribute specifier sequences

	[[ecs::duplicable]] int x [[ecs::duplicable]];

positive: multiple duplicable attributes in different attribute lists

	int x [[ecs::duplicable]] [[ecs::duplicable]];

negative: multiple duplicable attributes in same attribute list

	int x [[ecs::duplicable, ecs::duplicable]];

positive: duplicable attribute without argument

	int x [[ecs::duplicable]];

negative: duplicable attribute with argument

	int x [[ecs::duplicable ()]];

positive: duplicable attribute combined with replaceable attribute

	int x [[ecs::duplicable]] [[ecs::replaceable]];

positive: duplicable attribute combined with required attribute

	int x [[ecs::duplicable]] [[ecs::required]];

positive: duplicable attribute in all declarations

	void f [[ecs::duplicable]] ();
	void f [[ecs::duplicable]] ();

positive: duplicable attribute in first declaration

	void f [[ecs::duplicable]] ();
	void f ();

positive: duplicable attribute in second declaration

	void f ();
	void f [[ecs::duplicable]] ();

negative: code attribute applied to function

	int f [[ecs::code]] ();

negative: code attribute applied to inline member function

	class c {inline int f [[ecs::code]] ();};

negative: code attribute applied to global variable

	int x [[ecs::code]];

negative: code attribute applied to local variable

	void f () {int x [[ecs::code]];}

negative: code attribute applied to parameter

	void f (int x [[ecs::code]]);

negative: code attribute applied to static variable

	void f () {static int x [[ecs::code]];}

negative: code attribute applied to data member

	class c {int x [[ecs::code]];};

negative: code attribute applied to static data member

	class c {static int x [[ecs::code]];};

positive: code attribute applied to asm declaration

	[[ecs::code]] asm ("");

positive: multiple code attributes in different attribute lists

	[[ecs::code]] [[ecs::code]] asm ("");

negative: multiple code attributes in same attribute list

	[[ecs::code, ecs::code]] asm ("");

positive: code attribute without argument

	[[ecs::code]] asm ("");

negative: code attribute with argument

	[[ecs::code ()]] asm ("");

positive: group attribute applied to function

	int f [[ecs::group ("g")]] ();

positive: group attribute applied to member function

	class c {int f [[ecs::group ("g")]] ();};

positive: group attribute applied to global variable

	int x [[ecs::group ("g")]];

negative: group attribute applied to local variable

	void f () {int x [[ecs::group ("g")]];}

negative: group attribute applied to parameter

	void f (int x [[ecs::group ("g")]]};

positive: group attribute applied to static variable

	void f () {static int x [[ecs::group ("g")]];}

negative: group attribute applied to data member

	class c {int x [[ecs::group ("g")]];};

positive: group attribute applied to static data member

	class c {static int x [[ecs::group ("g")]];};

positive: multiple group attributes in different attribute specifier sequences

	[[ecs::group ("g")]] int x [[ecs::group ("g")]];

positive: multiple group attributes in different attribute lists

	int x [[ecs::group ("g")]] [[ecs::group ("g")]];

negative: multiple group attributes in same attribute list

	int x [[ecs::group ("g"), ecs::group ("g")]];

negative: group attribute without argument

	int x [[ecs::group]];

positive: group attribute with argument

	int x [[ecs::group ("g")]];

negative: group attribute with argument missing opening parenthesis

	int x [[ecs::group "g")]];

negative: group attribute with argument missing string literal

	int x [[ecs::group ()]];

negative: group attribute with argument missing closing parenthesis

	int x [[ecs::group ("g"]];

negative: group attribute with argument missing parentheses

	int x [[ecs::group "g"]];

negative: group attribute with empty string literal

	int x [[ecs::group ("")]];

negative: group attribute with integer literal

	int x [[ecs::group (0)]];

positive: group attribute in all declarations

	void f [[ecs::group ("g")]] ();
	void f [[ecs::group ("g")]] ();

positive: group attribute in first declaration

	void f [[ecs::group ("g")]] ();
	void f ();

positive: group attribute in second declaration

	void f ();
	void f [[ecs::group ("g")]] ();

negative: group attribute redeclared with different arguments

	void f [[ecs::group ("g")]] ();
	void f [[ecs::group ("h")]] ();

positive: origin attribute applied to function

	int f [[ecs::origin (0)]] ();

positive: origin attribute applied to member function

	class c {int f [[ecs::origin (0)]] ();};

positive: origin attribute applied to global variable

	int x [[ecs::origin (0)]];

negative: origin attribute applied to local variable

	void f () {int x [[ecs::origin (0)]];}

negative: origin attribute applied to parameter

	void f (int x [[ecs::origin (0)]]);

positive: origin attribute applied to static variable

	void f () {static int x [[ecs::origin (0)]];}

negative: origin attribute applied to data member

	class c {int x [[ecs::origin (0)]];};

positive: origin attribute applied to static data member

	class c {static int x [[ecs::origin (0)]];};

positive: multiple origin attributes in different attribute specifier sequences

	[[ecs::origin (0)]] int x [[ecs::origin (0)]];

positive: multiple origin attributes in different attribute lists

	int x [[ecs::origin (0)]] [[ecs::origin (0)]];

negative: multiple origin attributes in same attribute list

	int x [[ecs::origin (0), ecs::origin (0)]];

negative: origin attribute without argument

	int x [[ecs::origin]];

positive: origin attribute with argument

	int x [[ecs::origin (0)]];

negative: origin attribute with argument missing opening parenthesis

	int x [[ecs::origin 0)]];

negative: origin attribute with argument missing string literal

	int x [[ecs::origin ()]];

negative: origin attribute with argument missing closing parenthesis

	int x [[ecs::origin (0]];

negative: origin attribute with argument missing parentheses

	int x [[ecs::origin 0]];

negative: origin attribute with string literal

	int x [[ecs::origin ("")]];

positive: origin attribute in all declarations

	void f [[ecs::origin (0)]] ();
	void f [[ecs::origin (0)]] ();

positive: origin attribute in first declaration

	void f [[ecs::origin (0)]] ();
	void f ();

positive: origin attribute in second declaration

	void f ();
	void f [[ecs::origin (0)]] ();

negative: origin attribute redeclared with different arguments

	void f [[ecs::origin (0)]] ();
	void f [[ecs::origin (0x1000)]] ();

negative: register attribute applied to function

	int f [[ecs::register]] ();

negative: register attribute applied to global variable

	int x [[ecs::register]];

positive: register attribute applied to local variable

	void f () {int x [[ecs::register]];}

positive: register attribute applied to parameter

	void f (int x [[ecs::register]]);

negative: register attribute applied to static variable

	void f () {static int x [[ecs::register]];}

negative: register attribute applied to data member

	class c {int x [[ecs::register]];};

negative: register attribute applied to static data member

	class c {static int x [[ecs::register]];};

positive: multiple register attributes in different attribute specifier sequences

	void f () {[[ecs::register]] int x [[ecs::register]];}

positive: multiple register attributes in different attribute lists

	void f () {int x [[ecs::register]] [[ecs::register]];}

negative: multiple register attributes in same attribute list

	void f () {int x [[ecs::register, ecs::register]];}

positive: register attribute without argument

	void f () {int x [[ecs::register]];}

negative: register attribute with argument

	void f () {int x [[ecs::register ()]];}

positive: register attribute applied to up to four parameters

	void f (int a [[ecs::register]]) {}
	void f (int a [[ecs::register]], int b [[ecs::register]]) {}
	void f (int a [[ecs::register]], int b [[ecs::register]], int c [[ecs::register]]) {}
	void f (int a [[ecs::register]], int b [[ecs::register]], int c [[ecs::register]], int d [[ecs::register]]) {}

negative: register attribute applied to five parameters

	void f (int a [[ecs::register]], int b [[ecs::register]], int c [[ecs::register]], int d [[ecs::register]], int e [[ecs::register]]) {}

positive: register attribute applied to up to four variables

	void f () {
		{[[ecs::register]] int a;}
		{[[ecs::register]] int a, b;}
		{[[ecs::register]] int a, b, c;}
		{[[ecs::register]] int a, b, c, d;}
	}

negative: register attribute applied to five variables

	void f () {
		{[[ecs::register]] int a, b, c, d, e;}
	}

positive: register attribute applied to up to four parameters and variables

	void f (int a [[ecs::register]], int b [[ecs::register]]) {
		[[ecs::register]] int c;
		{[[ecs::register]] int d;}
	}

negative: register attribute applied to five parameters and variables

	void f (int a [[ecs::register]], int b [[ecs::register]]) {
		[[ecs::register]] int c;
		{[[ecs::register]] int d, e;}
	}

positive: register attribute applied to variable of fundamental type

	void f () {[[ecs::register]] bool a; [[ecs::register]] char b; [[ecs::register]] int c; [[ecs::register]] float d;}

negative: register attribute applied to variable of array type

	void f () {[[ecs::register]] int x[10];}

negative: register attribute applied to variable of reference type

	void f () {[[ecs::register]] int x, &y = x;}

negative: register attribute applied to variable of class type

	void f () {[[ecs::register]] class {} x;}

negative: register attribute applied to variable of enumeration type

	void f () {[[ecs::register]] enum {} x;}

positive: register attribute applied to variable of pointer type

	void f () {[[ecs::register]] int* x;}

negative: register attribute applied to variable of pointer to member type

	void f () {class c; [[ecs::register]] int c::* x;}

positive: register attribute in all declarations

	void f ([[ecs::register]] int);
	void f (int x[[ecs::register]]);

positive: register attribute in first declaration

	void f ([[ecs::register]] int);
	void f (int x);

positive: register attribute in second declaration

	void f (int);
	void f (int x[[ecs::register]]);

positive: replaceable attribute applied to function

	int f [[ecs::replaceable]] ();

positive: replaceable attribute applied to inline function

	inline int f [[ecs::replaceable]] ();

positive: replaceable attribute applied to member function

	class c {int f [[ecs::replaceable]] ();};

positive: replaceable attribute applied to inline member function

	class c {inline int f [[ecs::replaceable]] ();};

positive: replaceable attribute applied to global variable

	int x [[ecs::replaceable]];

positive: replaceable attribute applied to inline variable

	inline int x [[ecs::replaceable]];

negative: replaceable attribute applied to local variable

	void f () {int x [[ecs::replaceable]];}

negative: replaceable attribute applied to parameter

	void f (int x [[ecs::replaceable]]);

positive: replaceable attribute applied to static variable

	void f () {static int x [[ecs::replaceable]];}

negative: replaceable attribute applied to data member

	class c {int x [[ecs::replaceable]];};

positive: replaceable attribute applied to static data member

	class c {static int x [[ecs::replaceable]];};

positive: replaceable attribute applied to static inline data member

	class c {static inline int x [[ecs::replaceable]];};

positive: multiple replaceable attributes in different attribute specifier sequences

	[[ecs::replaceable]] int x [[ecs::replaceable]];

positive: multiple replaceable attributes in different attribute lists

	int x [[ecs::replaceable]] [[ecs::replaceable]];

negative: multiple replaceable attributes in same attribute list

	int x [[ecs::replaceable, ecs::replaceable]];

positive: replaceable attribute without argument

	int x [[ecs::replaceable]];

negative: replaceable attribute with argument

	int x [[ecs::replaceable ()]];

positive: replaceable attribute combined with duplicable attribute

	int x [[ecs::replaceable]] [[ecs::duplicable]];

positive: replaceable attribute combined with required attribute

	int x [[ecs::replaceable]] [[ecs::required]];

positive: replaceable attribute in all declarations

	void f [[ecs::replaceable]] ();
	void f [[ecs::replaceable]] ();

positive: replaceable attribute in first declaration

	void f [[ecs::replaceable]] ();
	void f ();

positive: replaceable attribute in second declaration

	void f ();
	void f [[ecs::replaceable]] ();

positive: required attribute applied to function

	int f [[ecs::required]] ();

positive: required attribute applied to inline function

	inline int f [[ecs::required]] ();

positive: required attribute applied to member function

	class c {int f [[ecs::required]] ();};

positive: required attribute applied to inline member function

	class c {inline int f [[ecs::required]] ();};

positive: required attribute applied to global variable

	int x [[ecs::required]];

positive: required attribute applied to inline variable

	inline int x [[ecs::required]];

negative: required attribute applied to local variable

	void f () {int x [[ecs::required]];}

negative: required attribute applied to parameter

	void f (int x [[ecs::required]]);

positive: required attribute applied to static variable

	void f () {static int x [[ecs::required]];}

negative: required attribute applied to data member

	class c {int x [[ecs::required]];};

positive: required attribute applied to static data member

	class c {static int x [[ecs::required]];};

positive: required attribute applied to static inline data member

	class c {static inline int x [[ecs::required]];};

positive: multiple required attributes in different attribute specifier sequences

	[[ecs::required]] int x [[ecs::required]];

positive: multiple required attributes in different attribute lists

	int x [[ecs::required]] [[ecs::required]];

negative: multiple required attributes in same attribute list

	int x [[ecs::required, ecs::required]];

positive: required attribute without argument

	int x [[ecs::required]];

negative: required attribute with argument

	int x [[ecs::required ()]];

positive: required attribute combined with duplicable attribute

	int x [[ecs::required]] [[ecs::duplicable]];

positive: required attribute combined with replaceable attribute

	int x [[ecs::required]] [[ecs::replaceable]];

positive: required attribute in all declarations

	void f [[ecs::required]] ();
	void f [[ecs::required]] ();

positive: required attribute in first declaration

	void f [[ecs::required]] ();
	void f ();

positive: required attribute in second declaration

	void f ();
	void f [[ecs::required]] ();

# 10.6.1 [dcl.attr.grammar] 7

positive: consecutive left brackets in balanced token sequence

	int x [[ a ([[]])]];

# 10.6.2 [dcl.align] 2

positive: variable declaration with extended alignment

	char x alignas (1024);

negative: local variable declaration with extended alignment

	void f () {char x alignas (1024);}

negative: class declaration with extended alignment

	class alignas (1024) c;

negative: class definition with extended alignment

	class alignas (1024) c {};

negative: enumeration declaration with extended alignment

	enum alignas (1024) e : int;

negative: enumeration definition with extended alignment

	enum alignas (1024) e {};

# 10.6.4 [dcl.attr.deprecated] 2

positive: deprecated attribute applied to translation unit

	[[deprecated]];
	namespace {[[deprecated]];}
	namespace n {[[deprecated]];}

# 10.6.5 [dcl.attr.fallthrough] 2

positive: warning for case label reachable from previous statement

	void f () {switch (0) {case 0: ; case 1: ;}}

positive: no warning for case label reachable from fallthrough statement

	void f () {switch (0) {case 0: [[fallthrough]]; case 1: ;}}

positive: warning for default label reachable from previous statement

	void f () {switch (0) {case 0: ; default: ;}}

positive: no warning for default label reachable from fallthrough statement

	void f () {switch (0) {case 0: [[fallthrough]]; default: ;}}

# 10.6.8 [dcl.attr.noreturn] 2

negative: noreturn attribute applied to asm declaration at namespace scope

	[[noreturn]] asm ("");

positive: noreturn attribute applied to asm declaration at block scope

	void f () {[[noreturn]] asm ("");}

# 10.6.8 [dcl.attr.noreturn] 2

positive: warning for function marked [[noreturn]] with return statement

	void f [[noreturn]] () {return;}

positive: warning for function marked [[noreturn]] with return type

	int f [[noreturn]] ();

# 19 [cpp] 2

negative: conditionally-supported directive beginning with unsupported directive name

	# unsupported

# 19.1 [cpp.cond] 10

negative: invalid integer value in controlling constant expression

	#if 12345678901234567890123456789012345678901234567890123456789012345678901234567890
	#endif

negative: division by zero in controlling constant expression

	#if 0 / 0
	#endif

negative: modulo by zero in controlling constant expression

	#if 0 % 0
	#endif

negative: invalid value in evaluated part of logical AND expression

	#if true && 0 / 0
	#endif

positive: invalid value in unevaluated part of logical AND expression

	#if false && 0 / 0
	#endif
	#if false && true && 0 / 0
	#endif
	#if true && false && 0 / 0
	#endif

negative: invalid value in evaluated part of logical OR expression

	#if false || 0 / 0
	#endif

positive: invalid value in unevaluated part of logical OR expression

	#if true || 0 / 0
	#endif
	#if true || false || 0 / 0
	#endif
	#if false || true || 0 / 0
	#endif

negative: invalid value in evaluated first part of conditional expression

	#if true ? 0 / 0 : 0
	#endif

positive: invalid value in unevaluated first part of conditional expression

	#if false ? 0 / 0 : 0
	#endif
	#if false && (true ? 0 / 0 : 0)
	#endif

negative: invalid value in evaluated second part of conditional expression

	#if false ? 0 : 0 / 0
	#endif

positive: invalid value in unevaluated second part of conditional expression

	#if true ? 0 : 0 / 0
	#endif
	#if false && (false ? 0 : 0 / 0)
	#endif

# 19.2 [cpp.include] 4

positive: header #include directive with replaced preprocessing tokens

	#define HEADER thread
	#define INCLUDE <HEADER>
	#include INCLUDE

# 19.4 [cpp.line] 3

negative: #line directive with digit sequence specifying zero

	#line 0

negative: #line directive with digit sequence specifying number greater than 2147483647

	#line 2147483648

# 19.6 [cpp.pragma] 1

positive: #pragma end directive

	#pragma end
	ignored source code

positive: ignoring all other #pragma directives

	#pragma
	#pragma abc
	#pragma warning

# 19.8 [cpp.predefined] 1

positive: predefined __STDC_HOSTED__ macro name

	#ifndef __STDC_HOSTED__
		#error
	#endif
	static_assert (__STDC_HOSTED__ == 1);

# todo: 19.8 [cpp.predefined] 2

# 19.8 [cpp.predefined] 4

positive: predefined __ecs__ macro name

	#ifndef __ecs__
		#error
	#endif

negative: definition of defined identifier

	#define defined

negative: redefinition of __cplusplus macro name

	#define __cplusplus

negative: redefinition of __DATE__ macro name

	#define __DATE__

negative: redefinition of __FILE__ macro name

	#define __FILE__

negative: redefinition of __LINE__ macro name

	#define __LINE__

negative: redefinition of __STDC_HOSTED__ macro name

	#define __STDC_HOSTED__

negative: redefinition of __STDCPP_DEFAULT_NEW_ALIGNMENT__ macro name

	#define __STDCPP_DEFAULT_NEW_ALIGNMENT__

negative: redefinition of __TIME__ macro name

	#define __TIME__

negative: redefinition of __ecs__ macro name

	#define __ecs__

negative: undefinition of defined identifier

	#undef defined

negative: undefinition of __cplusplus macro name

	#undef __cplusplus

negative: undefinition of __DATE__ macro name

	#undef __DATE__

negative: undefinition of __FILE__ macro name

	#undef __FILE__

negative: undefinition of __LINE__ macro name

	#undef __LINE__

negative: undefinition of __STDC_HOSTED__ macro name

	#undef __STDC_HOSTED__

negative: undefinition of __STDCPP_DEFAULT_NEW_ALIGNMENT__ macro name

	#undef __STDCPP_DEFAULT_NEW_ALIGNMENT__

negative: undefinition of __TIME__ macro name

	#undef __TIME__

negative: undefinition of __ecs__ macro name

	#undef __ecs__

# 19.9 [cpp.pragma.op] 1

positive: pragma end operator with string literal

	_Pragma ("end") ignored source code

positive: pragma end operator with string literal containing white space

	_Pragma (" end ") ignored source code

positive: pragma operator with wide string literal

	_Pragma (L"end") ignored source code

positive: pragma operator with wide string literal containing white space

	_Pragma (L" end ") ignored source code

# B [implimits] 2

negative: excessive recursive #include files

	#include __FILE__

positive: limited recursive constexpr function invocations

	constexpr int f (int x) {return x > 1 ? f (x - 1) : 1;}
	int x[f (512)];

negative: excessive recursive constexpr function invocations

	constexpr int f (int x) {return x > 1 ? f (x - 1) : 1;}
	int x[f (513)];

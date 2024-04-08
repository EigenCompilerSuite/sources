# Standard C++ compilation test and validation suite
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

# 5.3 [lex.charset] 1

positive: basic source character set consisting of 96 characters

	#define M \
		a b c d e f g h i j k l m n o p q r s t u v w x y z \
		A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
		0 1 2 3 4 5 6 7 8 9 \
		_ { } [ ] # ( ) < > % : ; . ? * + - / ^ & | ~ ! = , \ " " ' ' \

# 5.3 [lex.charset] 2

positive: matching universal character names

	int \u0100 = \U00000100;
	int \u1000 = \U00001000;
	int \uf900 = \uF900 = \U0000f900 = \U0000F900;
	int \uff00 = \uFF00 = \U0000ff00 = \U0000FF00;
	int \ufff0 = \uFFF0 = \U0000fff0 = \U0000FFF0;
	int \ufffd = \uFFFD = \U0000fffd = \U0000FFFD;

negative: universal character name corresponding to surrogate code point 0xd800

	int \ud800;

negative: universal character name corresponding to surrogate code point 0xdfff

	int \udfff;

negative: universal character name corresponding to control character 0x00

	int \u0000;

negative: universal character name corresponding to control character 0x1f

	int \u001f;

negative: universal character name corresponding to control character 0x7f

	int \u007f;

negative: universal character name corresponding to control character 0x9f

	int \u009f;

positive: universal character names corresponding control characters in character literals

	#define c0 '\u0000' '\u0001' '\u0002' '\u0003' '\u0004' '\u0005' '\u0005' '\u0007' '\u0008' '\u0009' '\u000a' '\u000b' '\u000c' '\u000d' '\u000e' '\u000f'
	#define c1 '\u0010' '\u0011' '\u0012' '\u0013' '\u0014' '\u0015' '\u0015' '\u0017' '\u0018' '\u0019' '\u001a' '\u001b' '\u001c' '\u001d' '\u001e' '\u001f'
	#define c7 '\u007f'
	#define c8 '\u0080' '\u0081' '\u0082' '\u0083' '\u0084' '\u0085' '\u0085' '\u0087' '\u0088' '\u0089' '\u008a' '\u008b' '\u008c' '\u008d' '\u008e' '\u008f'
	#define c9 '\u0090' '\u0091' '\u0092' '\u0093' '\u0094' '\u0095' '\u0095' '\u0097' '\u0098' '\u0099' '\u009a' '\u009b' '\u009c' '\u009d' '\u009e' '\u009f'

positive: universal character names corresponding control characters in string literals

	#define s0 "\u0000\u0001\u0002\u0003\u0004\u0005\u0005\u0007\u0008\u0009\u000a\u000b\u000c\u000d\u000e\u000f"
	#define s1 "\u0010\u0011\u0012\u0013\u0014\u0015\u0015\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f"
	#define s7 "\u007f"
	#define s8 "\u0080\u0081\u0082\u0083\u0084\u0085\u0085\u0087\u0088\u0089\u008a\u008b\u008c\u008d\u008e\u008f"
	#define s9 "\u0090\u0091\u0092\u0093\u0094\u0095\u0095\u0097\u0098\u0099\u009a\u009b\u009c\u009d\u009e\u009f"

negative: invalid universal character name

	#define c '\U00110000'

# 5.4 [lex.pptoken] 3

positive: reverted universal character name in raw string literal

	static_assert (sizeof R"(\u1234)" == 7);

positive: reverted line splicing in raw string literal

	static_assert (sizeof R"(\
	)" == 3, "");

positive: shortest sequence of characters in raw string pattern

	const char* s = (R"abc(xyz)abc");

negative: longest sequence of characters in raw string pattern

	const char* s = (R"abc(xyz)abc")abc";

negative: ill-formed raw string example

	#define R "x"
	const char* s = R"y";

# todo: <::>
# todo: 5.4 [lex.pptoken] 4
# todo: 5.4 [lex.pptoken] 5

# 5.5 [lex.digraph] 2

positive: alternative tokens

	%:define T a%:%:b%:%:c
	class [<::>] T <%%>;
	void operator and_eq (T, T);
	void operator and (T, T);
	void operator bitand (T, T);
	void operator bitor (T, T);
	void operator compl (T);
	void operator not_eq (T, T);
	void operator not (T);
	void operator or_eq (T, T);
	void operator or (T, T);
	void operator xor_eq (T, T);
	void operator xor (T, T);

# 5.7 [lex.comment] 1

positive: multi-line comment spanning single line

	int /* comment */ a;

positive: multi-line comment spanning multiple lines

	int /*
	comment
	*/ a;

negative: multi-line comment missing starting comment characters

	*/

negative: multi-line comment missing ending comment characters

	/*

negative: nested multi-line comment

	/* /* */ */

positive: single-line comment

	int // comment
	a;

positive: ignored comment characters in single-line comment

	// */ // /*

positive: ignored comment characters in multi-line comment

	/* // /* */

# 5.8 [lex.header] 1

positive: header name

	#include <complex>

negative: header name missing starting delimiter

	#include complex>

negative: header name missing ending delimiter

	#include <complex

positive: source file header name

	#include "complex"

negative: source file header name missing starting delimiter

	#include complex"

negative: source file header name missing ending delimiter

	#include "complex

# 5.9 [lex.ppnumber] 2

positive: integer preprocessing number without value

	#define number 12345678901234567890123456789012345678901234567890123456789012345678901234567890

positive: floating preprocessing number without value

	#define number 1234567890123456789012345678901234567890.1234567890123456789012345678901234567890p1234567890123456789012345678901234567890

# 5.10 [lex.name] 1

positive: arbitrarily long identifier

	int abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789;

positive: ranges of allowed identifiers characters

	int \u00a8;
	int \u00aa;
	int \u00ad;
	int \u00af;
	int \u00b2\u00b5;
	int \u00b7\u00ba;
	int \u00bc\u00be;
	int \u00c0\u00d0\u00d6;
	int \u00d8\u00e0\u00f0\u00f6;
	int \u00f8\u00ff;

	int \u0100\u1000\u1600\u1670\u167f;
	int \u1681\u1690\u1700\u1800\u180d;
	int \u180f\u1810\u1900\u1f00\u1ff0\u1fff;

	int \u200b\u200d;
	int \u202a\u202e;
	int \u203f\u2040;
	int \u2054;
	int \u2060\u206f;
	int \u2070\u2100\u2180\u218f;
	int \u2460\u24f0\u24ff;
	int \u2776\u2780\u2790\u2793;
	int \u2c00\u2d00\u2df0\u2dff;

	int \u3004\u3007;
	int \u3021\u302f;
	int \u3031\u303f\u3040\u3100\u4000\ud000\ud700\ud7f0\ud7ff;

	int \uf900\ufd00\ufd30\ufd3d;
	int \ufd40\ufdc0\ufdcf;
	int \ufdf0\ufe00\ufe40\ufe44;
	int \ufe47\ufe50\uff00\ufff0\ufffd;

	int \U00010000\U0001f000\U0001ff00\U0001fff0\U0001fffd;
	int \U00020000\U0002f000\U0002ff00\U0002fff0\U0002fffd;
	int \U00030000\U0003f000\U0003ff00\U0003fff0\U0003fffd;
	int \U00040000\U0004f000\U0004ff00\U0004fff0\U0004fffd;
	int \U00050000\U0005f000\U0005ff00\U0005fff0\U0005fffd;
	int \U00060000\U0006f000\U0006ff00\U0006fff0\U0006fffd;
	int \U00070000\U0007f000\U0007ff00\U0007fff0\U0007fffd;
	int \U00080000\U0008f000\U0008ff00\U0008fff0\U0008fffd;
	int \U00090000\U0009f000\U0009ff00\U0009fff0\U0009fffd;
	int \U000a0000\U000af000\U000aff00\U000afff0\U000afffd;
	int \U000b0000\U000bf000\U000bff00\U000bfff0\U000bfffd;
	int \U000c0000\U000cf000\U000cff00\U000cfff0\U000cfffd;
	int \U000d0000\U000df000\U000dff00\U000dfff0\U000dfffd;
	int \U000e0000\U000ef000\U000eff00\U000efff0\U000efffd;

negative: disallowed identifier character \u00a7

	int \u00a7;

negative: disallowed identifier character \u00a9

	int \u00a9;

negative: disallowed identifier character \u00ab

	int \u00ab;

negative: disallowed identifier character \u00ac

	int \u00ac;

negative: disallowed identifier character \u00b0

	int \u00b0;

negative: disallowed identifier character \u00b1

	int \u00b1;

negative: disallowed identifier character \u00b6

	int \u00b6;

negative: disallowed identifier character \u00bb

	int \u00bb;

negative: disallowed identifier character \u00bf

	int \u00bf;

negative: disallowed identifier character \u00d7

	int \u00d7;

negative: disallowed identifier character \u00f7

	int \u00f7;

negative: disallowed identifier character \u1680

	int \u1680;

negative: disallowed identifier character \u180e

	int \u180e;

negative: disallowed identifier character \u2000

	int \u2000;

negative: disallowed identifier character \u200a

	int \u200a;

negative: disallowed identifier character \u200e

	int \u200e;

negative: disallowed identifier character \u2029

	int \u2029;

negative: disallowed identifier character \u202f

	int \u202f;

negative: disallowed identifier character \u203e

	int \u203e;

negative: disallowed identifier character \u2041

	int \u2041;

negative: disallowed identifier character \u2053

	int \u2053;

negative: disallowed identifier character \u2055

	int \u2055;

negative: disallowed identifier character \u205f

	int \u205f;

negative: disallowed identifier character \u2190

	int \u2190;

negative: disallowed identifier character \u245f

	int \u245f;

negative: disallowed identifier character \u2500

	int \u2500;

negative: disallowed identifier character \u2775

	int \u2775;

negative: disallowed identifier character \u2794

	int \u2794;

negative: disallowed identifier character \u2bff

	int \u2bff;

negative: disallowed identifier character \u2e00

	int \u2e00;

negative: disallowed identifier character \u3000

	int \u3000;

negative: disallowed identifier character \u3003

	int \u3003;

negative: disallowed identifier character \u3008

	int \u3008;

negative: disallowed identifier character \u3020

	int \u3020;

negative: disallowed identifier character \u3030

	int \u3030;

negative: disallowed identifier character \ud800

	int \ud800;

negative: disallowed identifier character \uf8ff

	int \uf8ff;

negative: disallowed identifier character \ufd3e

	int \ufd3e;

negative: disallowed identifier character \ufd3f

	int \ufd3f;

negative: disallowed identifier character \ufdd0

	int \ufdd0;

negative: disallowed identifier character \ufdef

	int \ufdef;

negative: disallowed identifier character \ufe45

	int \ufe45;

negative: disallowed identifier character \ufe46

	int \ufe46;

negative: disallowed identifier character \ufffe

	int \ufffe;

negative: disallowed identifier character \U0000ffff

	int \U0000ffff;

negative: disallowed identifier character \U0001fffe

	int \U0001fffe;

negative: disallowed identifier character \U0001ffff

	int \U0001ffff;

negative: disallowed identifier character \U0002fffe

	int \U0002fffe;

negative: disallowed identifier character \U0002ffff

	int \U0002ffff;

negative: disallowed identifier character \U0003fffe

	int \U0003fffe;

negative: disallowed identifier character \U0003ffff

	int \U0003ffff;

negative: disallowed identifier character \U0004fffe

	int \U0004fffe;

negative: disallowed identifier character \U0004ffff

	int \U0004ffff;

negative: disallowed identifier character \U0005fffe

	int \U0005fffe;

negative: disallowed identifier character \U0005ffff

	int \U0005ffff;

negative: disallowed identifier character \U0006fffe

	int \U0006fffe;

negative: disallowed identifier character \U0006ffff

	int \U0006ffff;

negative: disallowed identifier character \U0007fffe

	int \U0007fffe;

negative: disallowed identifier character \U0007ffff

	int \U0007ffff;

negative: disallowed identifier character \U0008fffe

	int \U0008fffe;

negative: disallowed identifier character \U0008ffff

	int \U0008ffff;

negative: disallowed identifier character \U0009fffe

	int \U0009fffe;

negative: disallowed identifier character \U0009ffff

	int \U0009ffff;

negative: disallowed identifier character \U000afffe

	int \U000afffe;

negative: disallowed identifier character \U000affff

	int \U000affff;

negative: disallowed identifier character \U000bfffe

	int \U000bfffe;

negative: disallowed identifier character \U000bffff

	int \U000bffff;

negative: disallowed identifier character \U000cfffe

	int \U000cfffe;

negative: disallowed identifier character \U000cffff

	int \U000cffff;

negative: disallowed identifier character \U000dfffe

	int \U000dfffe;

negative: disallowed identifier character \U000dffff

	int \U000dffff;

negative: disallowed identifier character \U000efffe

	int \U000efffe;

negative: initially disallowed identifier character \u0300

	int \u0300;

negative: initially disallowed identifier character \u036f

	int \u036f;

negative: initially disallowed identifier character \u1dc0

	int \u1dc0;

negative: initially disallowed identifier character \u1dff

	int \u1dff;

negative: initially disallowed identifier character \u20d0

	int \u20d0;

negative: initially disallowed identifier character \u20ff

	int \u20ff;

negative: initially disallowed identifier character \ufe20

	int \ufe20;

negative: initially disallowed identifier character \ufe2f

	int \ufe2f;

positive: case sensitive identifiers

	int abcdefghijklmnopqrstuvwxyz;
	int ABCDEFGHIJKLMNOPQRSTUVWXYZ;

positive: first significant character in identifier

	int abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;
	int AbcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;

positive: last significant character in identifier

	int abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;
	int abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYz;

# 5.10 [lex.name] 2

positive: special identifier override

	int override;

positive: special identifier final

	int final;

# 5.11 [lex.key] 1

negative: reserved identifier alignas

	int (alignas);

negative: reserved identifier alignof

	int (alignof);

negative: reserved identifier asm

	int (asm);

negative: reserved identifier auto

	int (auto);

negative: reserved identifier bool

	int (bool);

negative: reserved identifier break

	int (break);

negative: reserved identifier case

	int (case);

negative: reserved identifier catch

	int (catch);

negative: reserved identifier char

	int (char);

negative: reserved identifier char8_t

	int (char8_t);

negative: reserved identifier char16_t

	int (char16_t);

negative: reserved identifier char32_t

	int (char32_t);

negative: reserved identifier class

	int (class);

negative: reserved identifier concept

	int (concept);

negative: reserved identifier const

	int (const);

negative: reserved identifier consteval

	int (consteval);

negative: reserved identifier constexpr

	int (constexpr);

negative: reserved identifier constinit

	int (constinit);

negative: reserved identifier const_cast

	int (const_cast);

negative: reserved identifier continue

	int (continue);

negative: reserved identifier co_await

	int (co_await);

negative: reserved identifier co_return

	int (co_return);

negative: reserved identifier co_yield

	int (co_yield);

negative: reserved identifier decltype

	int (decltype);

negative: reserved identifier default

	int (default);

negative: reserved identifier delete

	int (delete);

negative: reserved identifier do

	int (do);

negative: reserved identifier double

	int (double);

negative: reserved identifier dynamic_cast

	int (dynamic_cast);

negative: reserved identifier else

	int (else);

negative: reserved identifier enum

	int (enum);

negative: reserved identifier explicit

	int (explicit);

negative: reserved identifier export

	int (export);

negative: reserved identifier extern

	int (extern);

negative: reserved identifier false

	int (false);

negative: reserved identifier float

	int (float);

negative: reserved identifier for

	int (for);

negative: reserved identifier friend

	int (friend);

negative: reserved identifier goto

	int (goto);

negative: reserved identifier if

	int (if);

negative: reserved identifier inline

	int (inline);

negative: reserved identifier int

	int (int);

negative: reserved identifier long

	int (long);

negative: reserved identifier mutable

	int (mutable);

negative: reserved identifier namespace

	int (namespace);

negative: reserved identifier new

	int (new);

negative: reserved identifier noexcept

	int (noexcept);

negative: reserved identifier nullptr

	int (nullptr);

negative: reserved identifier operator

	int (operator);

negative: reserved identifier private

	int (private);

negative: reserved identifier protected

	int (protected);

negative: reserved identifier public

	int (public);

negative: reserved identifier register

	int (register);

negative: reserved identifier reinterpret_cast

	int (reinterpret_cast);

negative: reserved identifier requires

	int (requires);

negative: reserved identifier return

	int (return);

negative: reserved identifier short

	int (short);

negative: reserved identifier signed

	int (signed);

negative: reserved identifier sizeof

	int (sizeof);

negative: reserved identifier static

	int (static);

negative: reserved identifier static_assert

	int (static_assert);

negative: reserved identifier static_cast

	int (static_cast);

negative: reserved identifier struct

	int (struct);

negative: reserved identifier switch

	int (switch);

negative: reserved identifier template

	int (template);

negative: reserved identifier this

	int (this);

negative: reserved identifier thread_local

	int (thread_local);

negative: reserved identifier throw

	int (throw);

negative: reserved identifier true

	int (true);

negative: reserved identifier try

	int (try);

negative: reserved identifier typedef

	int (typedef);

negative: reserved identifier typeid

	int (typeid);

negative: reserved identifier typename

	int (typename);

negative: reserved identifier union

	int (union);

negative: reserved identifier unsigned

	int (unsigned);

negative: reserved identifier using

	int (using);

negative: reserved identifier virtual

	int (virtual);

negative: reserved identifier void

	int (void);

negative: reserved identifier volatile

	int (volatile);

negative: reserved identifier wchar_t

	int (wchar_t);

negative: reserved identifier while

	int (while);

# 5.11 [lex.key] 2

negative: reserved identifier and

	int (and);

negative: reserved identifier and_eq

	int (and_eq);

negative: reserved identifier bitand

	int (bitand);

negative: reserved identifier bitor

	int (bitor);

negative: reserved identifier compl

	int (compl);

negative: reserved identifier not

	int (not);

negative: reserved identifier not_eq

	int (not_eq);

negative: reserved identifier or

	int (or);

negative: reserved identifier or_eq

	int (or_eq);

negative: reserved identifier xor

	int (xor);

negative: reserved identifier xor_eq

	int (xor_eq);

# 5.13.2 [lex.icon] 1

positive: binary integer literal

	auto i = 0b101011100;

negative: binary integer literal with invalid digit 2

	auto i = 0b1010111002;

negative: binary integer literal with invalid digit 3

	auto i = 0b1010111003;

negative: binary integer literal with invalid digit 4

	auto i = 0b1010111004;

negative: binary integer literal with invalid digit 5

	auto i = 0b1010111005;

negative: binary integer literal with invalid digit 6

	auto i = 0b1010111006;

negative: binary integer literal with invalid digit 7

	auto i = 0b1010111007;

negative: binary integer literal with invalid digit 8

	auto i = 0b1010111008;

negative: binary integer literal with invalid digit 9

	auto i = 0b1010111009;

positive: most significant digit in binary integer

	static_assert (0b10 > 0B01);

negative: binary integer literal beginning with separating single quote

	auto i = 0b'1010111009;

negative: binary integer literal ending with separating single quote

	auto i = 0b1010111009';

positive: binary integer literal with separating single quotes

	static_assert (0b101011100 == 0b1'0'101'1100);

positive: octal integer literal

	auto i = 01234567;

negative: octal integer literal with invalid digit 8

	auto i = 012345678;

negative: octal integer literal with invalid digit 9

	auto i = 012345679;

positive: most significant digit in octal integer

	static_assert (010 > 001);

negative: octal integer literal beginning with separating single quote

	auto i = '01234567;

negative: octal integer literal ending with separating single quote

	auto i = 01234567';

positive: octal integer literal with separating single quotes

	static_assert (01234567 == 01'23'456'7);

positive: decimal integer literal

	auto i = 1234567890;

positive: most significant digit in decimal integer

	static_assert (10 > 01);

negative: decimal integer literal beginning with separating single quote

	auto i = '1234567890;

negative: decimal integer literal ending with separating single quote

	auto i = 1234567890';

positive: decimal integer literal with separating single quotes

	static_assert (1234567890 == 1'23'456'7890);

positive: hexadecimal integer literal with lower case digits

	auto i = 0x123456789abcdef;

positive: hexadecimal integer literal with upper case digits

	auto i = 0x123456789ABCDEF;

positive: hexadecimal integer literal with mixed case digits

	auto i = 0x123456789abcDEF;

positive: most significant digit in hexadecimal integer

	static_assert (0x10 > 0X01);

negative: hexadecimal integer literal beginning with separating single quote

	auto i = 0x'123456789abcdef;

negative: hexadecimal integer literal ending with separating single quote

	auto i = 0x123456789abcdef';

positive: hexadecimal integer literal with separating single quotes

	static_assert (0x123456789abcdef == 0x1'23'456'789a'bcdef);

positive: number twelve example

	static_assert (014 == 12);
	static_assert (0XC == 12);
	static_assert (0b1100 == 12);

positive: integer literals example

	static_assert (1'048'576 == 1048576);
	static_assert (0X100000 == 1048576);
	static_assert (0x10'0000 == 1048576);
	static_assert (0'004'000'000 == 1048576);

# 5.13.2 [lex.icon] 2

positive: binary integer literal with u suffix

	decltype (0b1101u) i;
	extern unsigned i;

positive: binary integer literal with U suffix

	decltype (0b1101U) i;
	extern unsigned i;

positive: binary integer literal with l suffix

	decltype (0b1101l) i;
	extern long i;

positive: binary integer literal with L suffix

	decltype (0b1101l) i;
	extern long i;

positive: binary integer literal with ul suffix

	decltype (0b1101ul) i;
	extern unsigned long i;

positive: binary integer literal with uL suffix

	decltype (0b1101uL) i;
	extern unsigned long i;

positive: binary integer literal with Ul suffix

	decltype (0b1101Ul) i;
	extern unsigned long i;

positive: binary integer literal with UL suffix

	decltype (0b1101UL) i;
	extern unsigned long i;

positive: binary integer literal with ll suffix

	decltype (0b1101ll) i;
	extern long long i;

positive: binary integer literal with LL suffix

	decltype (0b1101LL) i;
	extern long long i;

positive: binary integer literal with ull suffix

	decltype (0b1101ull) i;
	extern unsigned long long i;

positive: binary integer literal with uLL suffix

	decltype (0b1101uLL) i;
	extern unsigned long long i;

positive: binary integer literal with Ull suffix

	decltype (0b1101Ull) i;
	extern unsigned long long i;

positive: binary integer literal with ULL suffix

	decltype (0b1101ULL) i;
	extern unsigned long long i;

positive: binary integer literal with llu suffix

	decltype (0b1101llu) i;
	extern unsigned long long i;

positive: binary integer literal with LLu suffix

	decltype (0b1101LLu) i;
	extern unsigned long long i;

positive: binary integer literal with llU suffix

	decltype (0b1101llU) i;
	extern unsigned long long i;

positive: binary integer literal with LLU suffix

	decltype (0b1101LLU) i;
	extern unsigned long long i;

positive: octal integer literal with u suffix

	decltype (01234u) i;
	extern unsigned i;

positive: octal integer literal with U suffix

	decltype (01234U) i;
	extern unsigned i;

positive: octal integer literal with l suffix

	decltype (01234l) i;
	extern long i;

positive: octal integer literal with L suffix

	decltype (01234l) i;
	extern long i;

positive: octal integer literal with ul suffix

	decltype (01234ul) i;
	extern unsigned long i;

positive: octal integer literal with uL suffix

	decltype (01234uL) i;
	extern unsigned long i;

positive: octal integer literal with Ul suffix

	decltype (01234Ul) i;
	extern unsigned long i;

positive: octal integer literal with UL suffix

	decltype (01234UL) i;
	extern unsigned long i;

positive: octal integer literal with ll suffix

	decltype (01234ll) i;
	extern long long i;

positive: octal integer literal with LL suffix

	decltype (01234LL) i;
	extern long long i;

positive: octal integer literal with ull suffix

	decltype (01234ull) i;
	extern unsigned long long i;

positive: octal integer literal with uLL suffix

	decltype (01234uLL) i;
	extern unsigned long long i;

positive: octal integer literal with Ull suffix

	decltype (01234Ull) i;
	extern unsigned long long i;

positive: octal integer literal with ULL suffix

	decltype (01234ULL) i;
	extern unsigned long long i;

positive: octal integer literal with llu suffix

	decltype (01234llu) i;
	extern unsigned long long i;

positive: octal integer literal with LLu suffix

	decltype (01234LLu) i;
	extern unsigned long long i;

positive: octal integer literal with llU suffix

	decltype (01234llU) i;
	extern unsigned long long i;

positive: octal integer literal with LLU suffix

	decltype (01234LLU) i;
	extern unsigned long long i;

positive: decimal integer literal with u suffix

	decltype (1234u) i;
	extern unsigned i;

positive: decimal integer literal with U suffix

	decltype (1234U) i;
	extern unsigned i;

positive: decimal integer literal with l suffix

	decltype (1234l) i;
	extern long i;

positive: decimal integer literal with L suffix

	decltype (1234l) i;
	extern long i;

positive: decimal integer literal with ul suffix

	decltype (1234ul) i;
	extern unsigned long i;

positive: decimal integer literal with uL suffix

	decltype (1234uL) i;
	extern unsigned long i;

positive: decimal integer literal with Ul suffix

	decltype (1234Ul) i;
	extern unsigned long i;

positive: decimal integer literal with UL suffix

	decltype (1234UL) i;
	extern unsigned long i;

positive: decimal integer literal with ll suffix

	decltype (1234ll) i;
	extern long long i;

positive: decimal integer literal with LL suffix

	decltype (1234LL) i;
	extern long long i;

positive: decimal integer literal with ull suffix

	decltype (1234ull) i;
	extern unsigned long long i;

positive: decimal integer literal with uLL suffix

	decltype (1234uLL) i;
	extern unsigned long long i;

positive: decimal integer literal with Ull suffix

	decltype (1234Ull) i;
	extern unsigned long long i;

positive: decimal integer literal with ULL suffix

	decltype (1234ULL) i;
	extern unsigned long long i;

positive: decimal integer literal with llu suffix

	decltype (1234llu) i;
	extern unsigned long long i;

positive: decimal integer literal with LLu suffix

	decltype (1234LLu) i;
	extern unsigned long long i;

positive: decimal integer literal with llU suffix

	decltype (1234llU) i;
	extern unsigned long long i;

positive: decimal integer literal with LLU suffix

	decltype (1234LLU) i;
	extern unsigned long long i;

positive: hexadecimal integer literal with u suffix

	decltype (0x3cd2u) i;
	extern unsigned i;

positive: hexadecimal integer literal with U suffix

	decltype (0x3cd2U) i;
	extern unsigned i;

positive: hexadecimal integer literal with l suffix

	decltype (0x3cd2l) i;
	extern long i;

positive: hexadecimal integer literal with L suffix

	decltype (0x3cd2l) i;
	extern long i;

positive: hexadecimal integer literal with ul suffix

	decltype (0x3cd2ul) i;
	extern unsigned long i;

positive: hexadecimal integer literal with uL suffix

	decltype (0x3cd2uL) i;
	extern unsigned long i;

positive: hexadecimal integer literal with Ul suffix

	decltype (0x3cd2Ul) i;
	extern unsigned long i;

positive: hexadecimal integer literal with UL suffix

	decltype (0x3cd2UL) i;
	extern unsigned long i;

positive: hexadecimal integer literal with ll suffix

	decltype (0x3cd2ll) i;
	extern long long i;

positive: hexadecimal integer literal with LL suffix

	decltype (0x3cd2LL) i;
	extern long long i;

positive: hexadecimal integer literal with ull suffix

	decltype (0x3cd2ull) i;
	extern unsigned long long i;

positive: hexadecimal integer literal with uLL suffix

	decltype (0x3cd2uLL) i;
	extern unsigned long long i;

positive: hexadecimal integer literal with Ull suffix

	decltype (0x3cd2Ull) i;
	extern unsigned long long i;

positive: hexadecimal integer literal with ULL suffix

	decltype (0x3cd2ULL) i;
	extern unsigned long long i;

positive: hexadecimal integer literal with llu suffix

	decltype (0x3cd2llu) i;
	extern unsigned long long i;

positive: hexadecimal integer literal with LLu suffix

	decltype (0x3cd2LLu) i;
	extern unsigned long long i;

positive: hexadecimal integer literal with llU suffix

	decltype (0x3cd2llU) i;
	extern unsigned long long i;

positive: hexadecimal integer literal with LLU suffix

	decltype (0x3cd2LLU) i;
	extern unsigned long long i;

# 5.13.2 [lex.icon] 3

negative: unrepresentable integer literal

	auto i = 12345678901234567890123456789012345678901234567890123456789012345678901234567890;

# 5.13.3 [lex.ccon] 1

positive: examples of character literals

	char x1 = 'x';
	char w = u8'w';
	char16_t x2 = u'x';
	char32_t y = U'y';
	wchar_t z = L'z';

# 5.13.3 [lex.ccon] 2

positive: ordinary character literal

	decltype ('x') c;
	extern char c;

# 5.13.3 [lex.ccon] 3

positive: UTF-8 character literal

	decltype (u8'w') c;
	extern char c;

positive: UTF-8 character literal representable in C0 Controls and Basic Latin Unicode block

	char f = u8'\u0000', t = u8'\u007f';

negative: unrepresentable UTF-8 character literal

	char c = u8'\u0080';

negative: UTF-8 character literal containing multiple characters

	char c = u8'ab';

# 5.13.3 [lex.ccon] 4

positive: char16_t character literal

	decltype (u'x') c;
	extern char16_t c;

negative: unrepresentable char16_t character literal

	char16_t c = u'\U00010000';

negative: char16_t character literal containing multiple characters

	char16_t c = u'ab';

# todo: 5.13.3 [lex.ccon] 5

positive: char32_t character literal

	decltype (U'y') c;
	extern char32_t c;

negative: char32_t character literal containing multiple characters

	char32_t c = U'ab';

# todo: 5.13.3 [lex.ccon] 6

positive: wide character literal

	decltype (L'z') c;
	extern wchar_t c;

# 5.13.3 [lex.ccon] 7

positive: new-line escape sequence

	static_assert ('\n');
	static_assert (sizeof "\n" == 2);

positive: horizontal tab escape sequence

	static_assert ('\t');
	static_assert (sizeof "\t" == 2);

positive: vertical tab escape sequence

	static_assert ('\v');
	static_assert (sizeof "\v" == 2);

positive: backspace escape sequence

	static_assert ('\b');
	static_assert (sizeof "\b" == 2);

positive: carriage return escape sequence

	static_assert ('\r');
	static_assert (sizeof "\r" == 2);

positive: form feed escape sequence

	static_assert ('\f');
	static_assert (sizeof "\f" == 2);

positive: alert escape sequence

	static_assert ('\a');
	static_assert (sizeof "\a" == 2);

positive: backslash escape sequence

	static_assert ('\\');
	static_assert (sizeof "\\" == 2);

positive: question mark escape sequence

	static_assert ('\?' == '?');
	static_assert (sizeof "\?" == 2);

positive: single quote escape sequence

	static_assert ('\'');
	static_assert (sizeof "\'" == 2);

positive: double quote escape sequence

	static_assert ('\"' == '"');
	static_assert (sizeof "\"" == 2);

# 5.13.3 [lex.ccon] 8

positive: escape sequence with one octal digit

	static_assert ('\5' == 5);
	static_assert (sizeof "\5" == 2);

positive: escape sequence with two octal digits

	static_assert ('\25' == 21);
	static_assert (sizeof "\25" == 2);

positive: escape sequence with three octal digits

	static_assert ('\125' == 85);
	static_assert (sizeof "\125" == 2);

positive: escape sequence with four octal digits

	static_assert (sizeof "\0125" == 3);

positive: escape sequence with one hexadecimal digit

	static_assert ('\xa' == 10);
	static_assert (sizeof "\xa" == 2);

positive: escape sequence with two hexadecimal digits

	static_assert ('\x7a' == 122);
	static_assert (sizeof "\x7a" == 2);

positive: escape sequence with three hexadecimal digits

	static_assert ('\x07a' == 122);
	static_assert (sizeof "\x07a" == 2);

positive: escape sequence with four hexadecimal digits

	static_assert ('\x007a' == 122);
	static_assert (sizeof "\x007a" == 2);

positive: unlimited number of hexadecimal digits in escape sequence

	static_assert ('\x000000000000000000000000000000000000000000000000000000000000003F' == 63);
	static_assert (sizeof "\x000000000000000000000000000000000000000000000000000000000000003F" == 2);

positive: octal digit sequence terminated by non-octal digit

	static_assert (sizeof "\x12g" == 3);

positive: hexadecimal digit sequence terminated by non-hexadecimal digit

	static_assert (sizeof "\x000000012g" == 3);

# 5.13.3 [lex.ccon] 9

positive: universal character name in ordinary character literal

	static_assert ('\u002e' == 46);
	static_assert (sizeof "\u002e" == 2);
	static_assert ('\U0000003a' == 58);
	static_assert (sizeof "\U0000003a" == 2);

positive: universal character name in UTF-8 character literal

	static_assert (u8'\u0017' == 23);
	static_assert (sizeof u8"\u0017" == 2);
	static_assert (u8'\U0000005C' == 92);
	static_assert (sizeof u8"\U000000FC" == 2);

positive: universal character name in char16_t character literal

	static_assert (u'\u1234' == 4660);
	static_assert (sizeof u"\u1234" / sizeof u'\u1234' == 2);
	static_assert (u'\U0000ABcd' == 43981);
	static_assert (sizeof u"\U0000ABcd" / sizeof u'\U0000ABcd' == 2);

positive: universal character name in char32_t character literal

	static_assert (U'\u5678' == 22136);
	static_assert (sizeof U"\u5678" / sizeof U'\u5678' == 2);
	static_assert (U'\U0010abCD' == 1092557);
	static_assert (sizeof U"\U0010abCD" / sizeof U'\U0010abCD' == 2);

positive: universal character name in wide character literal

	static_assert (L'\u38ef' == 14575);
	static_assert (sizeof L"\u38ef" / sizeof L'\u38ef' == 2);
	static_assert (L'\U0010ffFF' == 1114111);
	static_assert (sizeof L"\U0010ffFF" / sizeof L'\U0010ffFF' == 2);

# 5.13.4 [lex.fcon] 1

positive: floating literal with optional prefix

	double d = 0x1c.;

positive: floating literal without optional prefix

	double d = 214.;

negative: floating literal with hexadecimal digits without optional prefix

	double d = 1c.;

negative: floating literal missing exponent

	double d = 10E+;

positive: floating literal with optional exponent

	decltype (10E4) d;
	extern double d;

positive: floating literal with positive exponent

	decltype (5.25E+5) d;
	extern double d;

positive: floating literal with negative exponent

	decltype (6.75E-3) d;
	extern double d;

positive: floating literals example

	static_assert (1.602'176'565e-19 == 1.602176565e-19);

positive: floating literal with omitted integer part

	decltype (.25) d;
	extern double d;

positive: floating literal with omitted fractional part

	decltype (25.) d;
	extern double d;

positive: significant part in floating literal

	static_assert (10.3 > 01.3);
	static_assert (1.30 > 1.03);

positive: floating literal exponent power of ten

	static_assert (1E3 == 1000);
	static_assert (5E-4 == 0.0005);

positive: hexadecimal floating literal example

	static_assert (49.625 == 0xC.68p+2);

positive: floating literal without suffix

	decltype (1.25) d;
	extern double d;

positive: floating literal with f suffix

	decltype (1.25f) d;
	extern float d;

positive: floating literal with F suffix

	decltype (1.25F) d;
	extern float d;

positive: floating literal with l suffix

	decltype (1.25l) d;
	extern long double d;

positive: floating literal with L suffix

	decltype (1.25L) d;
	extern long double d;

negative: unrepresentable floating literal

	float f = 1e10000;

# 5.13.5 [lex.string] 1

positive: string literal examples

	const char* s0 = "...";
	const char* s1 = R"(...)";
	const char* s2 = u8"...";
	const char* s3 = u8R"**(...)**";
	const char16_t* s4 = u"...";
	const char16_t* s5 = uR"*~(...)*~";
	const char32_t* s6 = U"...";
	const char32_t* s7 = UR"zzz(...)zzz";
	const wchar_t* s8 = L"...";
	const wchar_t* s9 = LR"(...)";

# 5.13.5 [lex.string] 2

negative: mismatched delimiter in raw string literal

	const char* s0 = R"abc(...)xyz";

positive: empty delimiter in raw string literal

	const char* s0 = R"(...)";

positive: 16 character delimiter in raw string literal

	const char* s0 = R"0123456789abcdef(...)0123456789abcdef";

negative: 17 character delimiter in raw string literal

	const char* s0 = R"0123456789abcdef0(...)0123456789abcdef0";

# 5.13.5 [lex.string] 3

positive: parentheses in raw string literal

	static_assert (sizeof R"delimiter((a|b))delimiter" == sizeof "(a|b)");

# 5.13.5 [lex.string] 4

positive: new line in raw string literal

	static_assert (sizeof R"(a\
	b
	c)" == sizeof "a\\\nb\nc", "");

# 5.13.5 [lex.string] 5

positive: raw string examples

	static_assert (sizeof R"a(
	)\
	a"
	)a" == sizeof "\n)\\\na\"\n", "");

	static_assert (sizeof R"(??)" == sizeof "\?\?");

	static_assert (sizeof R"#(
	)??="
	)#" == sizeof "\n)\?\?=\"\n", "");

# 5.13.5 [lex.string] 6

positive: concatenated string literals without prefix

	decltype ("asdf" "xyz" "abc") s;
	extern const char s[11];

# 5.13.5 [lex.string] 8

positive: ordinary string literal

	decltype ("asdf") s;
	extern const char s[5];

positive: UTF-8 string literal

	decltype (u8"asdf") s;
	extern const char s[5];

# todo: 2.14.5 [lex.string] 9

# 5.13.5 [lex.string] 10

positive: char16_t string literal

	decltype (u"asdf") s;
	extern const char16_t s[5];

# todo: surrogate pairs

# 5.13.5 [lex.string] 11

positive: char32_t string literal

	decltype (U"asdf") s;
	extern const char32_t s[5];

# 5.13.5 [lex.string] 12

positive: wide string literal

	decltype (L"asdf") s;
	extern const wchar_t s[5];

# 5.13.5 [lex.string] 13

positive: concatenating ordinary string literal with ordinary string literal

	decltype ("abc" "xyz") s;
	extern const char s[7];

positive: concatenating ordinary string literal with UTF-8 string literal

	decltype ("abc" u8"xyz") s;
	extern const char s[7];

positive: concatenating ordinary string literal with char16_t string literal

	decltype ("abc" u"xyz") s;
	extern const char16_t s[7];

positive: concatenating ordinary string literal with char32_t string literal

	decltype ("abc" U"xyz") s;
	extern const char32_t s[7];

positive: concatenating ordinary string literal with wide string literal

	decltype ("abc" L"xyz") s;
	extern const wchar_t s[7];

positive: concatenating UTF-8 string literal with ordinary string literal

	decltype (u8"abc" "xyz") s;
	extern const char s[7];

positive: concatenating UTF-8 string literal with UTF-8 string literal

	decltype (u8"abc" u8"xyz") s;
	extern const char s[7];

negative: concatenating UTF-8 string literal with wide string literal

	decltype (u8"abc" L"xyz") s;

positive: concatenating char16_t string literal with ordinary string literal

	decltype (u"abc" "xyz") s;
	extern const char16_t s[7];

positive: concatenating char16_t string literal with char16_t string literal

	decltype (u"abc" u"xyz") s;
	extern const char16_t s[7];

positive: concatenating char32_t string literal with ordinary string literal

	decltype (U"abc" "xyz") s;
	extern const char32_t s[7];

positive: concatenating char32_t string literal with char32_t string literal

	decltype (U"abc" U"xyz") s;
	extern const char32_t s[7];

positive: concatenating wide string literal with ordinary string literal

	decltype (L"abc" "xyz") s;
	extern const wchar_t s[7];

negative: concatenating wide string literal with UTF-8 string literal

	decltype (L"abc" u8"xyz") s;

positive: concatenating wide string literal with wide string literal

	decltype (L"abc" L"xyz") s;
	extern const wchar_t s[7];

positive: valid string literal concatenation examples

	decltype (u"a" u"b") s0; extern const char16_t s0[3];
	decltype (u"a" "b") s1; extern const char16_t s1[3];
	decltype ("a" u"b") s2; extern const char16_t s2[3];

	decltype (U"a" U"b") s3; extern const char32_t s3[3];
	decltype (U"a" "b") s4; extern const char32_t s4[3];
	decltype ("a" U"b") s5; extern const char32_t s5[3];

	decltype (L"a" L"b") s6; extern const wchar_t s6[3];
	decltype (L"a" "b") s7; extern const wchar_t s7[3];
	decltype ("a" L"b") s8; extern const wchar_t s8[3];

positive: distinct characters in concatenated strings example

	static_assert (sizeof "\xA" "B" == 3);

# todo: 5.13.5 [lex.string] 14
# todo: 5.13.5 [lex.string] 15
# todo: 5.13.5 [lex.string] 16

# 5.13.6 [lex.bool] 1

positive: Boolean literal false

	decltype (false) b;
	extern bool b;

positive: Boolean literal true

	decltype (true) b;
	extern bool b;

# 5.13.7 [lex.nullptr] 1

positive: pointer literal

	#include <cstddef>
	decltype (nullptr) p;
	extern std::nullptr_t p;

# todo: 5.13.8 [lex.ext]

# 6.3.4 [basic.scope.proto] 1

positive: parameter names in function prototype scope

	using f = void (int x, int y);

negative: duplicated parameter names in function prototype scope

	using f = void (int x, int x);

positive: using parameter name in function declaration inside function prototype scope

	int f (int x) noexcept (noexcept (x));

negative: using parameter name in function declaration outside function prototype scope

	int f (int x), y = x;

positive: using parameter name in function declarator inside function prototype scope

	using f = int (int x) noexcept (noexcept (x));

negative: using parameter name in function declarator outside function prototype scope

	using f = int (int x); int y = x;

positive: using parameter name in nested function declarator inside function prototype scope

	using f = int (* (int x) noexcept (noexcept (x))) ();

negative: using parameter name in nested function declarator outside function prototype scope

	using f = int (* (int x)) () noexcept (noexcept (x));

# 6.5 [basic.link] 1

positive: empty translation unit

# 7.7 [conv.fpprom] 1

positive: promoting prvalue of type float to prvalue of type double

	float x;
	double y = x;

# 7.8 [conv.integral] 1

positive: converting signed char to signed short

	signed char x;
	signed short y = x;

positive: converting signed char to signed int

	signed char x;
	signed int y = x;

positive: converting signed char to signed long

	signed char x;
	signed long y = x;

positive: converting signed char to signed long long

	signed char x;
	signed long long y = x;

positive: converting signed char to unsigned char

	signed char x;
	unsigned char y = x;

positive: converting signed char to unsigned short

	signed char x;
	unsigned short y = x;

positive: converting signed char to unsigned int

	signed char x;
	unsigned int y = x;

positive: converting signed char to unsigned long

	signed char x;
	unsigned long y = x;

positive: converting signed char to unsigned long long

	signed char x;
	unsigned long long y = x;

positive: converting signed short to signed char

	signed short x;
	signed char y = x;

positive: converting signed short to signed int

	signed short x;
	signed int y = x;

positive: converting signed short to signed long

	signed short x;
	signed long y = x;

positive: converting signed short to signed long long

	signed short x;
	signed long long y = x;

positive: converting signed short to unsigned char

	signed short x;
	unsigned char y = x;

positive: converting signed short to unsigned short

	signed short x;
	unsigned short y = x;

positive: converting signed short to unsigned int

	signed short x;
	unsigned int y = x;

positive: converting signed short to unsigned long

	signed short x;
	unsigned long y = x;

positive: converting signed short to unsigned long long

	signed short x;
	unsigned long long y = x;

positive: converting signed int to signed char

	signed int x;
	signed char y = x;

positive: converting signed int to signed short

	signed int x;
	signed short y = x;

positive: converting signed int to signed long

	signed int x;
	signed long y = x;

positive: converting signed int to signed long long

	signed int x;
	signed long long y = x;

positive: converting signed int to unsigned char

	signed int x;
	unsigned char y = x;

positive: converting signed int to unsigned short

	signed int x;
	unsigned short y = x;

positive: converting signed int to unsigned int

	signed int x;
	unsigned int y = x;

positive: converting signed int to unsigned long

	signed int x;
	unsigned long y = x;

positive: converting signed int to unsigned long long

	signed int x;
	unsigned long long y = x;

positive: converting signed long to signed char

	signed long x;
	signed char y = x;

positive: converting signed long to signed short

	signed long x;
	signed short y = x;

positive: converting signed long to signed int

	signed long x;
	signed int y = x;

positive: converting signed long to signed long long

	signed long x;
	signed long long y = x;

positive: converting signed long to unsigned char

	signed long x;
	unsigned char y = x;

positive: converting signed long to unsigned short

	signed long x;
	unsigned short y = x;

positive: converting signed long to unsigned int

	signed long x;
	unsigned int y = x;

positive: converting signed long to unsigned long

	signed long x;
	unsigned long y = x;

positive: converting signed long to unsigned long long

	signed long x;
	unsigned long long y = x;

positive: converting signed long long to signed char

	signed long long x;
	signed char y = x;

positive: converting signed long long to signed short

	signed long long x;
	signed short y = x;

positive: converting signed long long to signed int

	signed long long x;
	signed int y = x;

positive: converting signed long long to signed long

	signed long long x;
	signed long y = x;

positive: converting signed long long to unsigned char

	signed long long x;
	unsigned char y = x;

positive: converting signed long long to unsigned short

	signed long long x;
	unsigned short y = x;

positive: converting signed long long to unsigned int

	signed long long x;
	unsigned int y = x;

positive: converting signed long long to unsigned long

	signed long long x;
	unsigned long y = x;

positive: converting signed long long to unsigned long long

	signed long long x;
	unsigned long long y = x;

positive: converting unsigned char to signed char

	unsigned char x;
	signed char y = x;

positive: converting unsigned char to signed short

	unsigned char x;
	signed short y = x;

positive: converting unsigned char to signed int

	unsigned char x;
	signed int y = x;

positive: converting unsigned char to signed long

	unsigned char x;
	signed long y = x;

positive: converting unsigned char to signed long long

	unsigned char x;
	signed long long y = x;

positive: converting unsigned char to unsigned short

	unsigned char x;
	unsigned short y = x;

positive: converting unsigned char to unsigned int

	unsigned char x;
	unsigned int y = x;

positive: converting unsigned char to unsigned long

	unsigned char x;
	unsigned long y = x;

positive: converting unsigned char to unsigned long long

	unsigned char x;
	unsigned long long y = x;

positive: converting unsigned short to signed char

	unsigned short x;
	signed char y = x;

positive: converting unsigned short to signed short

	unsigned short x;
	signed short y = x;

positive: converting unsigned short to signed int

	unsigned short x;
	signed int y = x;

positive: converting unsigned short to signed long

	unsigned short x;
	signed long y = x;

positive: converting unsigned short to signed long long

	unsigned short x;
	signed long long y = x;

positive: converting unsigned short to unsigned char

	unsigned short x;
	unsigned char y = x;

positive: converting unsigned short to unsigned int

	unsigned short x;
	unsigned int y = x;

positive: converting unsigned short to unsigned long

	unsigned short x;
	unsigned long y = x;

positive: converting unsigned short to unsigned long long

	unsigned short x;
	unsigned long long y = x;

positive: converting unsigned int to signed char

	unsigned int x;
	signed char y = x;

positive: converting unsigned int to signed short

	unsigned int x;
	signed short y = x;

positive: converting unsigned int to signed int

	unsigned int x;
	signed int y = x;

positive: converting unsigned int to signed long

	unsigned int x;
	signed long y = x;

positive: converting unsigned int to signed long long

	unsigned int x;
	signed long long y = x;

positive: converting unsigned int to unsigned char

	unsigned int x;
	unsigned char y = x;

positive: converting unsigned int to unsigned short

	unsigned int x;
	unsigned short y = x;

positive: converting unsigned int to unsigned long

	unsigned int x;
	unsigned long y = x;

positive: converting unsigned int to unsigned long long

	unsigned int x;
	unsigned long long y = x;

positive: converting unsigned long to signed char

	unsigned long x;
	signed char y = x;

positive: converting unsigned long to signed short

	unsigned long x;
	signed short y = x;

positive: converting unsigned long to signed int

	unsigned long x;
	signed int y = x;

positive: converting unsigned long to signed long

	unsigned long x;
	signed long y = x;

positive: converting unsigned long to signed long long

	unsigned long x;
	signed long long y = x;

positive: converting unsigned long to unsigned char

	unsigned long x;
	unsigned char y = x;

positive: converting unsigned long to unsigned short

	unsigned long x;
	unsigned short y = x;

positive: converting unsigned long to unsigned int

	unsigned long x;
	unsigned int y = x;

positive: converting unsigned long to unsigned long long

	unsigned long x;
	unsigned long long y = x;

positive: converting unsigned long long to signed char

	unsigned long long x;
	signed char y = x;

positive: converting unsigned long long to signed short

	unsigned long long x;
	signed short y = x;

positive: converting unsigned long long to signed int

	unsigned long long x;
	signed int y = x;

positive: converting unsigned long long to signed long

	unsigned long long x;
	signed long y = x;

positive: converting unsigned long long to signed long long

	unsigned long long x;
	signed long long y = x;

positive: converting unsigned long long to unsigned char

	unsigned long long x;
	unsigned char y = x;

positive: converting unsigned long long to unsigned short

	unsigned long long x;
	unsigned short y = x;

positive: converting unsigned long long to unsigned int

	unsigned long long x;
	unsigned int y = x;

positive: converting unsigned long long to unsigned long

	unsigned long long x;
	unsigned long y = x;

positive: converting unscoped enumeration type to signed char

	enum {} x;
	signed char y = x;

positive: converting unscoped enumeration type to signed short

	enum {} x;
	signed short y = x;

positive: converting unscoped enumeration type to signed int

	enum {} x;
	signed int y = x;

positive: converting unscoped enumeration type to signed long

	enum {} x;
	signed long y = x;

positive: converting unscoped enumeration type to signed long long

	enum {} x;
	signed long long y = x;

positive: converting unscoped enumeration type to unsigned char

	enum {} x;
	unsigned char y = x;

positive: converting unscoped enumeration type to unsigned short

	enum {} x;
	unsigned short y = x;

positive: converting unscoped enumeration type to unsigned int

	enum {} x;
	unsigned int y = x;

positive: converting unscoped enumeration type to unsigned long

	enum {} x;
	unsigned long y = x;

positive: converting unscoped enumeration type to unsigned long long

	enum {} x;
	unsigned long long y = x;

negative: converting scoped enumeration type to signed char

	enum class e {} x;
	signed char y = x;

negative: converting scoped enumeration type to signed short

	enum class e {} x;
	signed short y = x;

negative: converting scoped enumeration type to signed int

	enum class e {} x;
	signed int y = x;

negative: converting scoped enumeration type to signed long

	enum class e {} x;
	signed long y = x;

negative: converting scoped enumeration type to signed long long

	enum class e {} x;
	signed long long y = x;

negative: converting scoped enumeration type to unsigned char

	enum class e {} x;
	unsigned char y = x;

negative: converting scoped enumeration type to unsigned short

	enum class e {} x;
	unsigned short y = x;

negative: converting scoped enumeration type to unsigned int

	enum class e {} x;
	unsigned int y = x;

negative: converting scoped enumeration type to unsigned long

	enum class e {} x;
	unsigned long y = x;

negative: converting scoped enumeration type to unsigned long long

	enum class e {} x;
	unsigned long long y = x;

# 7.8 [conv.integral] 2

positive: unsigned conversion from signed char to char

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr unsigned char y = x;
	static_assert (y == (SCHAR_MIN & UCHAR_MAX));

positive: unsigned conversion from signed short to char

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr unsigned char y = x;
	static_assert (y == (SHRT_MIN & UCHAR_MAX));

positive: unsigned conversion from signed int to char

	#include <climits>
	constexpr signed int x = INT_MIN;
	constexpr unsigned char y = x;
	static_assert (y == (INT_MIN & UCHAR_MAX));

positive: unsigned conversion from signed long to char

	#include <climits>
	constexpr signed long x = LONG_MIN;
	constexpr unsigned char y = x;
	static_assert (y == (LONG_MIN & UCHAR_MAX));

positive: unsigned conversion from signed long long to char

	#include <climits>
	constexpr signed long long x = LLONG_MIN;
	constexpr unsigned char y = x;
	static_assert (y == (LLONG_MIN & UCHAR_MAX));

positive: unsigned conversion from signed char to short

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr unsigned short y = x;
	static_assert (y == (SCHAR_MIN & USHRT_MAX));

positive: unsigned conversion from signed short to short

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr unsigned short y = x;
	static_assert (y == (SHRT_MIN & USHRT_MAX));

positive: unsigned conversion from signed int to short

	#include <climits>
	constexpr signed int x = INT_MIN;
	constexpr unsigned short y = x;
	static_assert (y == (INT_MIN & USHRT_MAX));

positive: unsigned conversion from signed long to short

	#include <climits>
	constexpr signed long x = LONG_MIN;
	constexpr unsigned short y = x;
	static_assert (y == (LONG_MIN & USHRT_MAX));

positive: unsigned conversion from signed long long to short

	#include <climits>
	constexpr signed long long x = LLONG_MIN;
	constexpr unsigned short y = x;
	static_assert (y == (LLONG_MIN & USHRT_MAX));

positive: unsigned conversion from signed char to int

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr unsigned int y = x;
	static_assert (y == (SCHAR_MIN & UINT_MAX));

positive: unsigned conversion from signed short to int

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr unsigned int y = x;
	static_assert (y == (SHRT_MIN & UINT_MAX));

positive: unsigned conversion from signed int to int

	#include <climits>
	constexpr signed int x = INT_MIN;
	constexpr unsigned int y = x;
	static_assert (y == (INT_MIN & UINT_MAX));

positive: unsigned conversion from signed long to int

	#include <climits>
	constexpr signed long x = LONG_MIN;
	constexpr unsigned int y = x;
	static_assert (y == (LONG_MIN & UINT_MAX));

positive: unsigned conversion from signed long long to int

	#include <climits>
	constexpr signed long long x = LLONG_MIN;
	constexpr unsigned int y = x;
	static_assert (y == (LLONG_MIN & UINT_MAX));

positive: unsigned conversion from signed char to long

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr unsigned long y = x;
	static_assert (y == (SCHAR_MIN & ULONG_MAX));

positive: unsigned conversion from signed short to long

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr unsigned long y = x;
	static_assert (y == (SHRT_MIN & ULONG_MAX));

positive: unsigned conversion from signed int to long

	#include <climits>
	constexpr signed int x = INT_MIN;
	constexpr unsigned long y = x;
	static_assert (y == (INT_MIN & ULONG_MAX));

positive: unsigned conversion from signed long to long

	#include <climits>
	constexpr signed long x = LONG_MIN;
	constexpr unsigned long y = x;
	static_assert (y == (LONG_MIN & ULONG_MAX));

positive: unsigned conversion from signed long long to long

	#include <climits>
	constexpr signed long long x = LLONG_MIN;
	constexpr unsigned long y = x;
	static_assert (y == (LLONG_MIN & ULONG_MAX));

positive: unsigned conversion from signed char to long long

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr unsigned long long y = x;
	static_assert (y == (SCHAR_MIN & ULLONG_MAX));

positive: unsigned conversion from signed short to long long

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr unsigned long long y = x;
	static_assert (y == (SHRT_MIN & ULLONG_MAX));

positive: unsigned conversion from signed int to long long

	#include <climits>
	constexpr signed int x = INT_MIN;
	constexpr unsigned long long y = x;
	static_assert (y == (INT_MIN & ULLONG_MAX));

positive: unsigned conversion from signed long to long long

	#include <climits>
	constexpr signed long x = LONG_MIN;
	constexpr unsigned long long y = x;
	static_assert (y == (LONG_MIN & ULLONG_MAX));

positive: unsigned conversion from signed long long to long long

	#include <climits>
	constexpr signed long long x = LLONG_MIN;
	constexpr unsigned long long y = x;
	static_assert (y == (LLONG_MIN & ULLONG_MAX));

positive: unsigned conversion from unsigned short to char

	#include <climits>
	constexpr unsigned short x = USHRT_MAX;
	constexpr unsigned char y = x;
	static_assert (y == (USHRT_MAX & UCHAR_MAX));

positive: unsigned conversion from unsigned int to char

	#include <climits>
	constexpr unsigned int x = UINT_MAX;
	constexpr unsigned char y = x;
	static_assert (y == (UINT_MAX & UCHAR_MAX));

positive: unsigned conversion from unsigned long to char

	#include <climits>
	constexpr unsigned long x = ULONG_MAX;
	constexpr unsigned char y = x;
	static_assert (y == (ULONG_MAX & UCHAR_MAX));

positive: unsigned conversion from unsigned long long to char

	#include <climits>
	constexpr unsigned long long x = ULLONG_MAX;
	constexpr unsigned char y = x;
	static_assert (y == (ULLONG_MAX & UCHAR_MAX));

positive: unsigned conversion from unsigned char to short

	#include <climits>
	constexpr unsigned char x = UCHAR_MAX;
	constexpr unsigned short y = x;
	static_assert (y == (UCHAR_MAX & USHRT_MAX));

positive: unsigned conversion from unsigned int to short

	#include <climits>
	constexpr unsigned int x = UINT_MAX;
	constexpr unsigned short y = x;
	static_assert (y == (UINT_MAX & USHRT_MAX));

positive: unsigned conversion from unsigned long to short

	#include <climits>
	constexpr unsigned long x = ULONG_MAX;
	constexpr unsigned short y = x;
	static_assert (y == (ULONG_MAX & USHRT_MAX));

positive: unsigned conversion from unsigned long long to short

	#include <climits>
	constexpr unsigned long long x = ULLONG_MAX;
	constexpr unsigned short y = x;
	static_assert (y == (ULLONG_MAX & USHRT_MAX));

positive: unsigned conversion from unsigned char to int

	#include <climits>
	constexpr unsigned char x = UCHAR_MAX;
	constexpr unsigned int y = x;
	static_assert (y == (UCHAR_MAX & UINT_MAX));

positive: unsigned conversion from unsigned short to int

	#include <climits>
	constexpr unsigned short x = USHRT_MAX;
	constexpr unsigned int y = x;
	static_assert (y == (USHRT_MAX & UINT_MAX));

positive: unsigned conversion from unsigned long to int

	#include <climits>
	constexpr unsigned long x = ULONG_MAX;
	constexpr unsigned int y = x;
	static_assert (y == (ULONG_MAX & UINT_MAX));

positive: unsigned conversion from unsigned long long to int

	#include <climits>
	constexpr unsigned long long x = ULLONG_MAX;
	constexpr unsigned int y = x;
	static_assert (y == (ULLONG_MAX & UINT_MAX));

positive: unsigned conversion from unsigned char to long

	#include <climits>
	constexpr unsigned char x = UCHAR_MAX;
	constexpr unsigned long y = x;
	static_assert (y == (UCHAR_MAX & ULONG_MAX));

positive: unsigned conversion from unsigned short to long

	#include <climits>
	constexpr unsigned short x = USHRT_MAX;
	constexpr unsigned long y = x;
	static_assert (y == (USHRT_MAX & ULONG_MAX));

positive: unsigned conversion from unsigned int to long

	#include <climits>
	constexpr unsigned int x = UINT_MAX;
	constexpr unsigned long y = x;
	static_assert (y == (UINT_MAX & ULONG_MAX));

positive: unsigned conversion from unsigned long long to long

	#include <climits>
	constexpr unsigned long long x = ULLONG_MAX;
	constexpr unsigned long y = x;
	static_assert (y == (ULLONG_MAX & ULONG_MAX));

positive: unsigned conversion from unsigned char to long long

	#include <climits>
	constexpr unsigned char x = UCHAR_MAX;
	constexpr unsigned long long y = x;
	static_assert (y == (UCHAR_MAX & ULLONG_MAX));

positive: unsigned conversion from unsigned short to long long

	#include <climits>
	constexpr unsigned short x = USHRT_MAX;
	constexpr unsigned long long y = x;
	static_assert (y == (USHRT_MAX & ULLONG_MAX));

positive: unsigned conversion from unsigned int to long long

	#include <climits>
	constexpr unsigned int x = UINT_MAX;
	constexpr unsigned long long y = x;
	static_assert (y == (UINT_MAX & ULLONG_MAX));

positive: unsigned conversion from unsigned long to long long

	#include <climits>
	constexpr unsigned long x = ULONG_MAX;
	constexpr unsigned long long y = x;
	static_assert (y == (ULONG_MAX & ULLONG_MAX));

# 7.8 [conv.integral] 3

positive: signed conversion from signed short to char

	#include <climits>
	constexpr signed short x = SCHAR_MIN;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MIN);

positive: signed conversion from signed int to char

	#include <climits>
	constexpr signed int x = SCHAR_MIN;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MIN);

positive: signed conversion from signed long to char

	#include <climits>
	constexpr signed long x = SCHAR_MIN;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MIN);

positive: signed conversion from signed long long to char

	#include <climits>
	constexpr signed long long x = SCHAR_MIN;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MIN);

positive: signed conversion from signed char to short

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr signed short y = x;
	static_assert (y == SCHAR_MIN);

positive: signed conversion from signed int to short

	#include <climits>
	constexpr signed int x = SHRT_MIN;
	constexpr signed short y = x;
	static_assert (y == SHRT_MIN);

positive: signed conversion from signed long to short

	#include <climits>
	constexpr signed long x = SHRT_MIN;
	constexpr signed short y = x;
	static_assert (y == SHRT_MIN);

positive: signed conversion from signed long long to short

	#include <climits>
	constexpr signed long long x = SHRT_MIN;
	constexpr signed short y = x;
	static_assert (y == SHRT_MIN);

positive: signed conversion from signed char to int

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr signed int y = x;
	static_assert (y == SCHAR_MIN);

positive: signed conversion from signed short to int

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr signed int y = x;
	static_assert (y == SHRT_MIN);

positive: signed conversion from signed long to int

	#include <climits>
	constexpr signed long x = INT_MIN;
	constexpr signed int y = x;
	static_assert (y == INT_MIN);

positive: signed conversion from signed long long to int

	#include <climits>
	constexpr signed long long x = INT_MIN;
	constexpr signed int y = x;
	static_assert (y == INT_MIN);

positive: signed conversion from signed char to long

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr signed long y = x;
	static_assert (y == SCHAR_MIN);

positive: signed conversion from signed short to long

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr signed long y = x;
	static_assert (y == SHRT_MIN);

positive: signed conversion from signed int to long

	#include <climits>
	constexpr signed int x = INT_MIN;
	constexpr signed long y = x;
	static_assert (y == INT_MIN);

positive: signed conversion from signed long long to long

	#include <climits>
	constexpr signed long long x = LONG_MIN;
	constexpr signed long y = x;
	static_assert (y == LONG_MIN);

positive: signed conversion from signed char to long long

	#include <climits>
	constexpr signed char x = SCHAR_MIN;
	constexpr signed long long y = x;
	static_assert (y == (SCHAR_MIN & ULLONG_MAX));

positive: signed conversion from signed short to long long

	#include <climits>
	constexpr signed short x = SHRT_MIN;
	constexpr signed long long y = x;
	static_assert (y == SHRT_MIN);

positive: signed conversion from signed int to long long

	#include <climits>
	constexpr signed int x = INT_MIN;
	constexpr signed long long y = x;
	static_assert (y == INT_MIN);

positive: signed conversion from signed long to long long

	#include <climits>
	constexpr signed long x = LONG_MIN;
	constexpr signed long long y = x;
	static_assert (y == LONG_MIN);

positive: signed conversion from unsigned char to char

	#include <climits>
	constexpr unsigned short x = SCHAR_MAX;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned short to char

	#include <climits>
	constexpr unsigned short x = SCHAR_MAX;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned int to char

	#include <climits>
	constexpr unsigned int x = SCHAR_MAX;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned long to char

	#include <climits>
	constexpr unsigned long x = SCHAR_MAX;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned long long to char

	#include <climits>
	constexpr unsigned long long x = SCHAR_MAX;
	constexpr signed char y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned char to short

	#include <climits>
	constexpr unsigned char x = SCHAR_MAX;
	constexpr signed short y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned short to short

	#include <climits>
	constexpr unsigned short x = SHRT_MAX;
	constexpr signed short y = x;
	static_assert (y == SHRT_MAX);

positive: signed conversion from unsigned int to short

	#include <climits>
	constexpr unsigned int x = SHRT_MAX;
	constexpr signed short y = x;
	static_assert (y == SHRT_MAX);

positive: signed conversion from unsigned long to short

	#include <climits>
	constexpr unsigned long x = SHRT_MAX;
	constexpr signed short y = x;
	static_assert (y == SHRT_MAX);

positive: signed conversion from unsigned long long to short

	#include <climits>
	constexpr unsigned long long x = SHRT_MAX;
	constexpr signed short y = x;
	static_assert (y == SHRT_MAX);

positive: signed conversion from unsigned char to int

	#include <climits>
	constexpr unsigned char x = SCHAR_MAX;
	constexpr signed int y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned short to int

	#include <climits>
	constexpr unsigned short x = SHRT_MAX;
	constexpr signed int y = x;
	static_assert (y == SHRT_MAX);

positive: signed conversion from unsigned int to int

	#include <climits>
	constexpr unsigned int x = INT_MAX;
	constexpr signed int y = x;
	static_assert (y == INT_MAX);

positive: signed conversion from unsigned long to int

	#include <climits>
	constexpr unsigned long x = INT_MAX;
	constexpr signed int y = x;
	static_assert (y == INT_MAX);

positive: signed conversion from unsigned long long to int

	#include <climits>
	constexpr unsigned long long x = INT_MAX;
	constexpr signed int y = x;
	static_assert (y == INT_MAX);

positive: signed conversion from unsigned char to long

	#include <climits>
	constexpr unsigned char x = SCHAR_MAX;
	constexpr signed long y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned short to long

	#include <climits>
	constexpr unsigned short x = SHRT_MAX;
	constexpr signed long y = x;
	static_assert (y == SHRT_MAX);

positive: signed conversion from unsigned int to long

	#include <climits>
	constexpr unsigned int x = INT_MAX;
	constexpr signed long y = x;
	static_assert (y == INT_MAX);

positive: signed conversion from unsigned long to long

	#include <climits>
	constexpr unsigned long x = LONG_MAX;
	constexpr signed long y = x;
	static_assert (y == LONG_MAX);

positive: signed conversion from unsigned long long to long

	#include <climits>
	constexpr unsigned long long x = LONG_MAX;
	constexpr signed long y = x;
	static_assert (y == LONG_MAX);

positive: signed conversion from unsigned char to long long

	#include <climits>
	constexpr unsigned char x = SCHAR_MAX;
	constexpr signed long long y = x;
	static_assert (y == SCHAR_MAX);

positive: signed conversion from unsigned short to long long

	#include <climits>
	constexpr unsigned short x = SHRT_MAX;
	constexpr signed long long y = x;
	static_assert (y == SHRT_MAX);

positive: signed conversion from unsigned int to long long

	#include <climits>
	constexpr unsigned int x = INT_MAX;
	constexpr signed long long y = x;
	static_assert (y == INT_MAX);

positive: signed conversion from unsigned long to long long

	#include <climits>
	constexpr unsigned long x = LONG_MAX;
	constexpr signed long long y = x;
	static_assert (y == LONG_MAX);

positive: signed conversion from unsigned long long to long long

	#include <climits>
	constexpr unsigned long long x = LONG_MAX;
	constexpr signed long long y = x;
	static_assert (y == LONG_MAX);

# 7.8 [conv.integral] 4

positive: unsigned conversion from false to char

	constexpr unsigned char x = false;
	static_assert (x == 0);

positive: unsigned conversion from true to char

	constexpr unsigned char x = true;
	static_assert (x == 1);

positive: unsigned conversion from false to short

	constexpr unsigned short x = false;
	static_assert (x == 0);

positive: unsigned conversion from true to short

	constexpr unsigned short x = true;
	static_assert (x == 1);

positive: unsigned conversion from false to int

	constexpr unsigned int x = false;
	static_assert (x == 0);

positive: unsigned conversion from true to int

	constexpr unsigned int x = true;
	static_assert (x == 1);

positive: unsigned conversion from false to long

	constexpr unsigned long x = false;
	static_assert (x == 0);

positive: unsigned conversion from true to long

	constexpr unsigned long x = true;
	static_assert (x == 1);

positive: unsigned conversion from false to long long

	constexpr unsigned long long x = false;
	static_assert (x == 0);

positive: unsigned conversion from true to long long

	constexpr unsigned long long x = true;
	static_assert (x == 1);

positive: signed conversion from false to char

	constexpr signed char x = false;
	static_assert (x == 0);

positive: signed conversion from true to char

	constexpr signed char x = true;
	static_assert (x == 1);

positive: signed conversion from false to short

	constexpr signed short x = false;
	static_assert (x == 0);

positive: signed conversion from true to short

	constexpr signed short x = true;
	static_assert (x == 1);

positive: signed conversion from false to int

	constexpr signed int x = false;
	static_assert (x == 0);

positive: signed conversion from true to int

	constexpr signed int x = true;
	static_assert (x == 1);

positive: signed conversion from false to long

	constexpr signed long x = false;
	static_assert (x == 0);

positive: signed conversion from true to long

	constexpr signed long x = true;
	static_assert (x == 1);

positive: signed conversion from false to long long

	constexpr signed long long x = false;
	static_assert (x == 0);

positive: signed conversion from true to long long

	constexpr signed long long x = true;
	static_assert (x == 1);

# 7.13 [conv.fctptr] 1

positive: converting pointer to noexcept function to pointer to function

	void (*x) () noexcept;
	void (*y) () = x;

negative: converting pointer to function to pointer to noexcept function

	void (*x) ();
	void (*y) () noexcept = x;

positive: converting pointer to member of type noexcept function to pointer to member of type function

	class c;
	void (c::*x) () noexcept;
	void (c::*y) () = x;

negative: converting pointer to member of type function to pointer to member of type noexcept function

	class c;
	void (c::*x) ();
	void (c::*y) () noexcept = x;

# todo: function pointer conversion example

# 8.1 [expr.prim]

positive: literal as primary expression

	int x = 5;

positive: this as primary expression

	class c {c* x = this;};

positive: parentheses as primary expression

	int x = (5);

negative: parenthesized expression missing opening parenthesis

	int x = 5);

negative: parenthesized expression missing closing parenthesis

	int x = (5;

positive: identifier as primary expression

	int x, y = x;

# todo: lambda expression as primary expression
# todo: fold expression as primary expression

# 8.1.1 [expr.prim.literal] 1

negative: integer literal as lvalue

	int& x = 0;

negative: character literal as lvalue

	char& x = 'y';

negative: floating literal as lvalue

	double& x = 0.0;

positive: string literal as lvalue

	const char (&x)[1] = "";

negative: boolean literal as lvalue

	bool& x = false;

negative: pointer literal as lvalue

	decltype (nullptr)& x = nullptr;

# 8.1.3 [expr.prim.paren] 1

positive: value of parenthesized expression

	static_assert (1 + 2 == (1 + 2));

positive: type of parenthesized expression

	int x = (1 + 2);
	extern decltype (1 + 2) x;

# 8.3.1 [expr.unary.op] 1

negative: indirection applied on void

	void f (); auto x = *f ();

negative: indirection applied on bool

	bool x; auto y = *x;

negative: indirection applied on char

	char x; auto y = *x;

negative: indirection applied on char16_t

	char16_t x; auto y = *x;

negative: indirection applied on char32_t

	char32_t x; auto y = *x;

negative: indirection applied on wchar_t

	wchar_t x; auto y = *x;

negative: indirection applied on short int

	short int x; auto y = *x;

negative: indirection applied on unsigned short int

	unsigned short int x; auto y = *x;

negative: indirection applied on int

	int x; auto y = *x;

negative: indirection applied on unsigned int

	unsigned int x; auto y = *x;

negative: indirection applied on long int

	long int x; auto y = *x;

negative: indirection applied on unsigned long int

	unsigned long int x; auto y = *x;

negative: indirection applied on long long int

	long long int x; auto y = *x;

negative: indirection applied on unsigned long long int

	unsigned long long int x; auto y = *x;

negative: indirection applied on float

	float x; auto y = *x;

negative: indirection applied on double

	double x; auto y = *x;

negative: indirection applied on long double

	long double x; auto y = *x;

negative: indirection applied on class

	class {} x; auto y = *x;

negative: indirection applied on enumeration

	enum {} x; auto y = *x;

positive: indirection applied on array

	int x[10]; auto y = *x;

negative: indirection applied on function

	void f (); auto y = *f;

negative: indirection applied on pointer to lvalue reference type

	extern int x, &y = x; auto z = *y;

negative: indirection applied on pointer to rvalue reference type

	extern int x, &&y = x; auto z = *y;

negative: indirection applied on pointer to void

	extern void* x; auto y = *x;

positive: indirection applied on pointer to bool

	extern bool* x; auto y = *x; extern bool y;

positive: indirection applied on pointer to char

	extern char* x; auto y = *x; extern char y;

positive: indirection applied on pointer to char16_t

	extern char16_t* x; auto y = *x; extern char16_t y;

positive: indirection applied on pointer to char32_t

	extern char32_t* x; auto y = *x; extern char32_t y;

positive: indirection applied on pointer to wchar_t

	extern wchar_t* x; auto y = *x; extern wchar_t y;

positive: indirection applied on pointer to short int

	extern short int* x; auto y = *x; extern short int y;

positive: indirection applied on pointer to unsigned short int

	extern unsigned short int* x; auto y = *x; extern unsigned short int y;

positive: indirection applied on pointer to int

	extern int* x; auto y = *x; extern int y;

positive: indirection applied on pointer to unsigned int

	extern unsigned int* x; auto y = *x; extern unsigned int y;

positive: indirection applied on pointer to long int

	extern long int* x; auto y = *x; extern long int y;

positive: indirection applied on pointer to unsigned long int

	extern unsigned long int* x; auto y = *x; extern unsigned long int y;

positive: indirection applied on pointer to long long int

	extern long long int* x; auto y = *x; extern long long int y;

positive: indirection applied on pointer to unsigned long long int

	extern unsigned long long int* x; auto y = *x; extern unsigned long long int y;

positive: indirection applied on pointer to float

	extern float* x; auto y = *x; extern float y;

positive: indirection applied on pointer to double

	extern double* x; auto y = *x; extern double y;

positive: indirection applied on pointer to long double

	extern long double* x; auto y = *x; extern long double y;

positive: indirection applied on pointer to class

	extern class c {}* x; auto y = *x; extern c y;

positive: indirection applied on pointer to enumeration

	extern enum e {}* x; auto y = *x; extern e y;

positive: indirection applied on pointer to array

	extern int (*x)[10]; auto y = *x; extern int* y;

positive: indirection applied on pointer to function

	extern void (*f) (); auto y = *f; // todo: extern void (*y) ();

positive: indirection applied on pointer to pointer

	extern void** x; auto y = *x; extern void* y;

negative: indirection through a pointer to void

	extern void* x; void f () {*x;}

# todo:
#positive: indirection through a pointer to incomplete class

#	class c; extern c* x; auto& y = *x;

#positive: indirection through a pointer to incomplete enumeration

#	enum e : int; extern e * x; auto& y = *x;

#positive: indirection through a pointer to incomplete array

#	extern int (*x)[]; auto& y = *x;

# 8.3.1 [expr.unary.op] 3

positive: address of variable

	int x;
	int* y = &x;

positive: address of function

	void x ();
	void (*y) () = &x;

positive: address of non-static member

	struct {int m;} x;
	int* y = &x.m;

positive: address of static member

	struct C {static int m;} x;
	int* y = &x.m;
	int* z = &C::m;

negative: address of literal

	int* y = &5;

positive: address of qualified identifier

	struct C {int m;};
	int C::*y = &C::m;

positive: address of operator naming a non-static member

	struct C {int m;};
	auto x = &C::m;
	extern int C::*x;

positive: address of operator naming a static member

	struct C {static int m;};
	auto x = &C::m;
	extern int *x;

positive: address of const object

	const int x;
	auto y = &x;
	extern const int* y;

positive: address of volatile object

	volatile int x;
	auto y = &x;
	extern volatile int* y;

positive: address of const volatile object

	const volatile int x;
	auto y = &x;
	extern const volatile int* y;

# todo: address of example

#negative: pointer to member reflecting mutable specifier

#	struct C {mutable int m;};
#	int C::* x = &C::m;
#	void f (const C& y) {y.*x = 0;}

# 8.3.1 [expr.unary.op] 4

positive: forming pointer to member with unparenthesized address-of operator and qualified identifier

	struct C {int m; int C::* x = &C::m;};

negative: forming pointer to member with unparenthesized address-of operator and unqualified identifier

	struct C {int m; int C::* x = &m;};

negative: forming pointer to member with parenthesized address-of operator and qualified identifier

	struct C {int m; int C::* x = &(C::m);};

negative: forming pointer to member without address-of operator and qualified identifier

	struct C {int m; int C::* x = C::m;};

# 8.3.1 [expr.unary.op] 5

negative: address of operator with bit-field operand

	struct {int m : 1;} x;
	auto y = &x.m;

negative: address of operator with bit-field member

	struct C {int m : 1;};
	auto x = &C::m;

# 8.3.1 [expr.unary.op] 6

# todo: address of an overloaded function

# 8.3.1 [expr.unary.op] 7

positive: unary + operator applied to integral operand

	auto x = +0;
	extern int x;

positive: unary + operator applied to arithmetic operand

	auto x = +0.0;
	extern double x;

negative: unary + operator applied to non-arithmetic operand

	auto x = +nullptr;

positive: unary + operator applied to unscoped enumeration operand

	enum e {a};
	auto x = +e::a;
	extern int x;

negative: unary + operator applied to scoped enumeration operand

	enum class e {a};
	auto x = +e::a;

positive: unary + operator applied to operand of function pointer type

	int (*p) ();
	auto x = +p;

positive: unary + operator applied to operand of incomplete pointer type

	class *p;
	auto x = +p;

# 8.3.1 [expr.unary.op] 8

positive: unary - operator applied to integral operand

	auto x = -0;
	extern int x;

positive: unary - operator applied to arithmetic operand

	auto x = -0.0;
	extern double x;

negative: unary - operator applied to non-arithmetic operand

	auto x = -nullptr;

positive: unary - operator applied to unscoped enumeration operand

	enum e {a};
	auto x = -e::a;
	extern int x;

negative: unary - operator applied to scoped enumeration operand

	enum class e {a};
	auto x = -e::a;

negative: unary - operator applied to operand of function pointer type

	int (*p) ();
	auto x = -p;

negative: unary - operator applied to operand of incomplete pointer type

	class *p;
	auto x = -p;

# 8.3.1 [expr.unary.op] 9

positive: unary ! operator applied to boolean operand

	auto x = !false;
	extern bool x;

positive: unary ! operator applied to integral operand

	auto x = !0;
	extern bool x;

positive: unary ! operator applied to arithmetic operand

	auto x = !0.0;
	extern bool x;

positive: unary ! operator applied to non-arithmetic operand

	auto x = !nullptr;
	extern bool x;

positive: unary ! operator applied to unscoped enumeration operand

	enum e {a};
	auto x = !e::a;
	extern bool x;

negative: unary ! operator applied to scoped enumeration operand

	enum class e {a};
	auto x = !e::a;

positive: logical negation of false

	static_assert (!false == true);

positive: logical negation of true

	static_assert (!true == false);

# 8.3.1 [expr.unary.op] 10

positive: unary ~ operator applied to boolean operand

	auto x = ~false;
	extern int x;

positive: unary ~ operator applied to integral operand

	auto x = ~0;
	extern int x;

negative: unary ~ operator applied to arithmetic operand

	auto x = ~0.0;
	extern bool x;

positive: unary ~ operator applied to unscoped enumeration operand

	enum e {a};
	auto x = ~e::a;
	extern int x;

negative: unary ~ operator applied to scoped enumeration operand

	enum class e {a};
	auto x = ~e::a;

negative: unary complement operator followed by class name

	class C;
	auto x = ~C;

negative: unary complement operator followed by decltype specifier

	auto x = ~decltype(0);

# 8.3.3 [expr.sizeof] 1

positive: sizeof operator with expression operand

	static_assert (sizeof 0 >= 1);

positive: sizeof operator with parenthesized expression operand

	static_assert (sizeof (0) >= 1);

negative: sizeof operator with type identifier operand

	static_assert (sizeof int >= 1);

positive: sizeof operator with parenthesized type identifier operand

	static_assert (sizeof (int) >= 1);

negative: size of function type

	static_assert (sizeof (void ()) >= 1);

positive: size of complete type

	static_assert (sizeof (bool) >= 1);
	static_assert (sizeof (char) >= 1);
	static_assert (sizeof (char[10]) >= 1);
	static_assert (sizeof (char16_t) >= 1);
	static_assert (sizeof (char32_t) >= 1);
	static_assert (sizeof (wchar_t) >= 1);
	static_assert (sizeof (short int) >= 1);
	static_assert (sizeof (unsigned short int) >= 1);
	static_assert (sizeof (int) >= 1);
	static_assert (sizeof (unsigned int) >= 1);
	static_assert (sizeof (long int) >= 1);
	static_assert (sizeof (unsigned long int) >= 1);
	static_assert (sizeof (long long int) >= 1);
	static_assert (sizeof (unsigned long long int) >= 1);
	static_assert (sizeof (float) >= 1);
	static_assert (sizeof (double) >= 1);
	static_assert (sizeof (long double) >= 1);
	static_assert (sizeof (decltype (nullptr)) >= 1);
	static_assert (sizeof (int[10]) >= 1);
	static_assert (sizeof (void*) >= 1);
	static_assert (sizeof (void(*)()) >= 1);

negative: size of incomplete type

	extern class c;
	static_assert (sizeof (c) >= 1);

negative: size of void

	static_assert (sizeof (void) >= 1);

positive: size of complete class

	class c {};
	static_assert (sizeof (c) >= 1);

negative: size of on incomplete class

	static_assert (sizeof (class c) >= 1);

positive: size of complete enumeration

	enum e {};
	static_assert (sizeof (e) >= 1);

negative: size of incomplete enumeration

	enum e {a = sizeof (e)};

negative: size of expression with function type

	void f ();
	static_assert (sizeof f >= 1);

negative: size of expression with incomplete type

	extern class c x;
	static_assert (sizeof x >= 1);

negative: size of expression designating bit-field

	struct {int m : 1;} x;
	auto y = sizeof (x.m);

positive: size of char

	static_assert (sizeof (char) == 1);

positive: size of signed char

	static_assert (sizeof (signed char) == 1);

positive: size of unsigned char

	static_assert (sizeof (unsigned char) == 1);

# 8.3.3 [expr.sizeof] 2

positive: sizeof applied to lvalue reference

	extern char& x;
	static_assert (sizeof x == 1);

positive: sizeof applied to rvalue reference

	extern char&& x;
	static_assert (sizeof x == 1);

positive: sizeof applied to lvalue reference type

	static_assert (sizeof (char&) == 1);

positive: sizeof applied to rvalue reference type

	static_assert (sizeof (char&&) == 1);

positive: sizeof applied to class

	class c {};
	static_assert (sizeof (c) == sizeof (c[1]));

positive: sizeof applied to aligned class

	class alignas (8) c {};
	static_assert (sizeof (c) == sizeof (c[1]));

# todo: size of most derived class

positive: size of bool

	static_assert (sizeof (bool) >= 1);

# todo: sizeof applied to base class subobject

positive: sizeof applied to array

	static_assert (sizeof (int[10]) == sizeof (int) * 10);

# 8.3.3 [expr.sizeof] 3

positive: sizeof applied to pointer to a function

	static_assert (sizeof (void (*) ()) >= 1);

negative: sizeof applied to a function type

	static_assert (sizeof (void ()) >= 1);

negative: sizeof applied to a function

	void f ();
	static_assert (sizeof f >= 1);

# todo: 8.3.3 [expr.sizeof] 4
# todo: 8.3.3 [expr.sizeof] 5

# 8.3.3 [expr.sizeof] 6

positive: result of sizeof constant

	constexpr auto x = sizeof (char);
	static_assert (x == 1);

positive: result of sizeof of type std::size_t

	#include <cstddef>
	auto x = sizeof (char);
	extern std::size_t x;

# todo: result of sizeof...

# 8.3.6 [expr.alignof] 1

positive: alignof expression on complete type

	static_assert (alignof (bool) >= 1);
	static_assert (alignof (char) >= 1);
	static_assert (alignof (char[10]) >= 1);
	static_assert (alignof (char16_t) >= 1);
	static_assert (alignof (char32_t) >= 1);
	static_assert (alignof (wchar_t) >= 1);
	static_assert (alignof (short int) >= 1);
	static_assert (alignof (unsigned short int) >= 1);
	static_assert (alignof (int) >= 1);
	static_assert (alignof (unsigned int) >= 1);
	static_assert (alignof (long int) >= 1);
	static_assert (alignof (unsigned long int) >= 1);
	static_assert (alignof (long long int) >= 1);
	static_assert (alignof (unsigned long long int) >= 1);
	static_assert (alignof (float) >= 1);
	static_assert (alignof (double) >= 1);
	static_assert (alignof (long double) >= 1);
	static_assert (alignof (decltype (nullptr)) >= 1);
	static_assert (alignof (int[10]) >= 1);
	static_assert (alignof (void*) >= 1);
	static_assert (alignof (void(*)()) >= 1);

# todo: class types
# todo: pointer to member types

negative: alignof expression on void

	static_assert (alignof (void) >= 1);

positive: alignof expression on complete class

	class c {};
	static_assert (alignof (c) >= 1);

negative: alignof expression on incomplete class

	static_assert (alignof (class c) >= 1);

positive: alignof expression on complete enumeration

	enum e {};
	static_assert (alignof (e) >= 1);

negative: alignof expression on incomplete enumeration

	enum e {a = alignof (e)};

negative: alignof expression on function type

	static_assert (alignof (void ()) >= 1);

positive: alignof expression on array with complete element type

	static_assert (alignof (int[10]) >= 1);

negative: alignof expression on array with incomplete element type

	static_assert (alignof (class c[10]) >= 1);

negative: alignof expression on array of unknown bound

	static_assert (alignof (int[]) >= 1);

positive: alignof expression on complete lvalue reference types

	static_assert (alignof (bool&) >= 1);
	static_assert (alignof (char&) >= 1);
	static_assert (alignof (char16_t&) >= 1);
	static_assert (alignof (char32_t&) >= 1);
	static_assert (alignof (wchar_t&) >= 1);
	static_assert (alignof (short int&) >= 1);
	static_assert (alignof (unsigned short int&) >= 1);
	static_assert (alignof (int&) >= 1);
	static_assert (alignof (unsigned int&) >= 1);
	static_assert (alignof (long int&) >= 1);
	static_assert (alignof (unsigned long int&) >= 1);
	static_assert (alignof (long long int&) >= 1);
	static_assert (alignof (unsigned long long int&) >= 1);
	static_assert (alignof (float&) >= 1);
	static_assert (alignof (double&) >= 1);
	static_assert (alignof (long double&) >= 1);
	static_assert (alignof (decltype (nullptr)&) >= 1);
	static_assert (alignof (int(&)[10]) >= 1);
	static_assert (alignof (void*&) >= 1);
	static_assert (alignof (void(*&)()) >= 1);

positive: alignof expression on complete reference types

	static_assert (alignof (bool&&) >= 1);
	static_assert (alignof (char&&) >= 1);
	static_assert (alignof (char16_t&&) >= 1);
	static_assert (alignof (char32_t&&) >= 1);
	static_assert (alignof (wchar_t&&) >= 1);
	static_assert (alignof (short int&&) >= 1);
	static_assert (alignof (unsigned short int&&) >= 1);
	static_assert (alignof (int&&) >= 1);
	static_assert (alignof (unsigned int&&) >= 1);
	static_assert (alignof (long int&&) >= 1);
	static_assert (alignof (unsigned long int&&) >= 1);
	static_assert (alignof (long long int&&) >= 1);
	static_assert (alignof (unsigned long long int&&) >= 1);
	static_assert (alignof (float&&) >= 1);
	static_assert (alignof (double&&) >= 1);
	static_assert (alignof (long double&&) >= 1);
	static_assert (alignof (decltype (nullptr)&&) >= 1);
	static_assert (alignof (int(&&)[10]) >= 1);
	static_assert (alignof (void*&&) >= 1);
	static_assert (alignof (void(*&&)()) >= 1);

negative: alignof expression on incomplete reference type

	static_assert (alignof (class c&) >= 1);

# 8.3.6 [expr.alignof] 2

positive: alignof expression with integral result

	auto result = alignof (int);
	extern decltype (sizeof (0)) result;

positive: alignof expression with constant result

	static_assert (alignof (char) == 1);
	static_assert (alignof (signed char) == 1);
	static_assert (alignof (unsigned char) == 1);

# 8.3.6 [expr.alignof] 3

positive: alignof expression on lvalue reference types

	static_assert (alignof (bool&) == alignof (bool));
	static_assert (alignof (char&) == alignof (char));
	static_assert (alignof (char16_t&) == alignof (char16_t));
	static_assert (alignof (char32_t&) == alignof (char32_t));
	static_assert (alignof (wchar_t&) == alignof (wchar_t));
	static_assert (alignof (short int&) == alignof (short int));
	static_assert (alignof (unsigned short int&) == alignof (unsigned short int));
	static_assert (alignof (int&) == alignof (int));
	static_assert (alignof (unsigned int&) == alignof (unsigned int));
	static_assert (alignof (long int&) == alignof (long int));
	static_assert (alignof (unsigned long int&) == alignof (unsigned long int));
	static_assert (alignof (long long int&) == alignof (long long int));
	static_assert (alignof (unsigned long long int&) == alignof (unsigned long long int));
	static_assert (alignof (float&) == alignof (float));
	static_assert (alignof (double&) == alignof (double));
	static_assert (alignof (long double&) == alignof (long double));
	static_assert (alignof (decltype (nullptr)&) == alignof (decltype (nullptr)));
	static_assert (alignof (int(&)[10]) >= alignof (int[10]));
	static_assert (alignof (void*&) >= alignof (void*));
	static_assert (alignof (void(*&)()) >= alignof (void(*)()));

positive: alignof expression on rvalue reference types

	static_assert (alignof (bool&&) == alignof (bool));
	static_assert (alignof (char&&) == alignof (char));
	static_assert (alignof (char16_t&&) == alignof (char16_t));
	static_assert (alignof (char32_t&&) == alignof (char32_t));
	static_assert (alignof (wchar_t&&) == alignof (wchar_t));
	static_assert (alignof (short int&&) == alignof (short int));
	static_assert (alignof (unsigned short int&&) == alignof (unsigned short int));
	static_assert (alignof (int&&) == alignof (int));
	static_assert (alignof (unsigned int&&) == alignof (unsigned int));
	static_assert (alignof (long int&&) == alignof (long int));
	static_assert (alignof (unsigned long int&&) == alignof (unsigned long int));
	static_assert (alignof (long long int&&) == alignof (long long int));
	static_assert (alignof (unsigned long long int&&) == alignof (unsigned long long int));
	static_assert (alignof (float&&) == alignof (float));
	static_assert (alignof (double&&) == alignof (double));
	static_assert (alignof (long double&&) == alignof (long double));
	static_assert (alignof (decltype (nullptr)&&) == alignof (decltype (nullptr)));
	static_assert (alignof (int(&&)[10]) >= alignof (int[10]));
	static_assert (alignof (void*&&) >= alignof (void*));
	static_assert (alignof (void(*&&)()) >= alignof (void(*)()));

positive: alignof expression on array types

	static_assert (alignof (bool[10]) == alignof (bool));
	static_assert (alignof (char[10]) == alignof (char));
	static_assert (alignof (char16_t[10]) == alignof (char16_t));
	static_assert (alignof (char32_t[10]) == alignof (char32_t));
	static_assert (alignof (wchar_t[10]) == alignof (wchar_t));
	static_assert (alignof (short int[10]) == alignof (short int));
	static_assert (alignof (unsigned short int[10]) == alignof (unsigned short int));
	static_assert (alignof (int[10]) == alignof (int));
	static_assert (alignof (unsigned int[10]) == alignof (unsigned int));
	static_assert (alignof (long int[10]) == alignof (long int));
	static_assert (alignof (unsigned long int[10]) == alignof (unsigned long int));
	static_assert (alignof (long long int[10]) == alignof (long long int));
	static_assert (alignof (unsigned long long int[10]) == alignof (unsigned long long int));
	static_assert (alignof (float[10]) == alignof (float));
	static_assert (alignof (double[10]) == alignof (double));
	static_assert (alignof (long double[10]) == alignof (long double));
	static_assert (alignof (decltype (nullptr)[10]) == alignof (decltype (nullptr)));
	static_assert (alignof (int[10][10]) == alignof (int[10]));
	static_assert (alignof (void*[10]) == alignof (void*));
	static_assert (alignof (void(*[10])()) == alignof (void(*)()));

# 8.3.7 [expr.unary.noexcept] 1

positive: unevaluated operand of noexcept operator

	struct s {int m;};
	static_assert (noexcept (s::m));

negative: noexcept operator missing noexcept keyword

	struct s {int m;};
	static_assert ((s::m));

negative: noexcept operator missing opening parenthesis

	struct s {int m;};
	static_assert (noexcept s::m));

negative: noexcept operator missing operand

	static_assert (noexcept ());

negative: noexcept operator missing closing parenthesis

	struct s {int m;};
	static_assert (noexcept (s::m);

# 8.3.7 [expr.unary.noexcept] 2

positive: constant result of noexcept operator

	static_assert (noexcept (0));

positive: result of noexcept operator of type bool

	auto result = noexcept (0);
	extern bool result;

# 8.3.7 [expr.unary.noexcept] 3

positive: noexcept operator with potentially-throwing expression

	void f () noexcept (false);
	static_assert (!noexcept (f ()));

positive: noexcept operator with non-throwing expression

	void f () noexcept (true);
	static_assert (noexcept (f ()));

# 8.6 [expr.mul] 1

positive: multiplicative operators

	static_assert (6 * 5 / 4 % 3 == 1);

# 8.6 [expr.mul] 2

positive: binary * operator applied to integral left-hand operand

	auto x = 0 * 1;
	extern int x;

positive: binary * operator applied to arithmetic left-hand operand

	auto x = 0.0 * 1;
	extern double x;

negative: binary * operator applied to non-arithmetic left-hand operand

	auto x = nullptr * 1;

positive: binary * operator applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a * 1;
	extern int x;

negative: binary * operator applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a * 1;

positive: binary * operator applied to integral right-hand operand

	auto x = 0 * 1;
	extern int x;

positive: binary * operator applied to arithmetic right-hand operand

	auto x = 0 * 1.0;
	extern double x;

negative: binary * operator applied to non-arithmetic right-hand operand

	auto x = 0 * nullptr;

positive: binary * operator applied to unscoped enumeration right-hand operand

	enum e {a = 1};
	auto x = 0 * e::a;
	extern int x;

negative: binary * operator applied to scoped enumeration right-hand operand

	enum class e {a = 1};
	auto x = 0 * e::a;

positive: binary / operator applied to integral left-hand operand

	auto x = 0 / 1;
	extern int x;

positive: binary / operator applied to arithmetic left-hand operand

	auto x = 0.0 / 1;
	extern double x;

negative: binary / operator applied to non-arithmetic left-hand operand

	auto x = nullptr / 1;

positive: binary / operator applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a / 1;
	extern int x;

negative: binary / operator applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a / 1;

positive: binary / operator applied to integral right-hand operand

	auto x = 0 / 1;
	extern int x;

positive: binary / operator applied to arithmetic right-hand operand

	auto x = 0 / 1.0;
	extern double x;

negative: binary / operator applied to non-arithmetic right-hand operand

	auto x = 0 / nullptr;

positive: binary / operator applied to unscoped enumeration right-hand operand

	enum e {a = 1};
	auto x = 0 / e::a;
	extern int x;

negative: binary / operator applied to scoped enumeration right-hand operand

	enum class e {a = 1};
	auto x = 0 / e::a;

positive: binary % operator applied to integral left-hand operand

	auto x = 0 % 1;
	extern int x;

negative: binary % operator applied to non-integral left-hand operand

	auto x = 0.0 % 1;

positive: binary % operator applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a % 1;
	extern int x;

negative: binary % operator applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a % 1;

positive: binary % operator applied to integral right-hand operand

	auto x = 0 % 1;
	extern int x;

negative: binary % operator applied to non-integral right-hand operand

	auto x = 0 % 1.0;

positive: binary % operator applied to unscoped enumeration right-hand operand

	enum e {a = 1};
	auto x = 0 % e::a;
	extern int x;

negative: binary % operator applied to scoped enumeration right-hand operand

	enum class e {a = 1};
	auto x = 0 % e::a;

# 8.6 [expr.mul] 3

positive: integral multiplication

	static_assert (2 * 3 == 6);

positive: floating-point multiplication

	static_assert (2.5 * 3.5 == 8.75);

# 8.6 [expr.mul] 4

positive: integral quotient of division

	static_assert (6 / 4 == 1);

positive: floating-point quotient of division

	static_assert (6.0 / 4.0 == 1.5);

positive: integral remainder of division

	static_assert (6 % 4 == 2);

positive: binary / operator yielding algebraic quotient for integral operands with discarded fractional part

	static_assert (10 / 4 == 2);
	static_assert (10 / -4 == -2);
	static_assert (-10 / 4 == -2);
	static_assert (-10 / -4 == 2);

positive: quotient times divisor plus remainder equal to dividend

	static_assert ((10 / 4) * 4 + 10 % 4 == 10);
	static_assert ((10 / -4) * -4 + 10 % -4 == 10);
	static_assert ((-10 / 4) * 4 + -10 % 4 == -10);
	static_assert ((-10 / -4) * -4 + -10 % -4 == -10);

# 8.7 [expr.add] 1

positive: additive operators

	static_assert (5 + 4 - 3 == 6);

positive: binary + operator applied to integral left-hand operand

	auto x = 0 + 1;
	extern int x;

positive: binary + operator applied to arithmetic left-hand operand

	auto x = 0.0 + 1;
	extern double x;

negative: binary + operator applied to non-arithmetic left-hand operand

	auto x = nullptr + 1;

positive: binary + operator applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a + 1;
	extern int x;

negative: binary + operator applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a + 1;

negative: binary + operator applied to left-hand operand of function pointer type

	int (*p) ();
	auto x = p + 0;

negative: binary + operator applied to left-hand operand of incomplete pointer type

	class *p;
	auto x = p + 0;

positive: binary + operator applied to left-hand operand of pointer type and integral right-hand operand

	int* p;
	auto x = p + 0;
	extern int* x;

negative: binary + operator applied to left-hand operand of pointer type and non-integral right-hand operand

	int* p;
	auto x = p + 0.0;

positive: binary + operator applied to left-hand operand of pointer type and unscoped enumeration right-hand operand

	int* p;
	enum e {a};
	auto x = p + e::a;
	extern int* x;

negative: binary + operator applied to left-hand operand of pointer type and scoped enumeration right-hand operand

	int* p;
	enum class e {a};
	auto x = p + e::a;

positive: binary + operator applied to integral right-hand operand

	auto x = 1 + 0;
	extern int x;

positive: binary + operator applied to arithmetic right-hand operand

	auto x = 1 + 0.0;
	extern double x;

negative: binary + operator applied to non-arithmetic right-hand operand

	auto x = 1 + nullptr;

positive: binary + operator applied to unscoped enumeration right-hand operand

	enum e {a};
	auto x = 1 + e::a;
	extern int x;

negative: binary + operator applied to scoped enumeration right-hand operand

	enum class e {a};
	auto x = 1 + e::a;

negative: binary + operator applied to right-hand operand of function pointer type

	int (*p) ();
	auto x = 0 + p;

negative: binary + operator applied to right-hand operand of incomplete pointer type

	class *p;
	auto x = 0 + p;

positive: binary + operator applied to right-hand operand of pointer type and integral left-hand operand

	int* p;
	auto x = 0 + p;
	extern int* x;

negative: binary + operator applied to right-hand operand of pointer type and non-integral left-hand operand

	int* p;
	auto x = 0.0 + p;

positive: binary + operator applied to right-hand operand of pointer type and unscoped enumeration left-hand operand

	int* p;
	enum e {a};
	auto x = e::a + p;
	extern int* x;

negative: binary + operator applied to right-hand operand of pointer type and scoped enumeration left-hand operand

	int* p;
	enum class e {a};
	auto x = e::a + p;

# 8.7 [expr.add] 2

positive: binary - operator applied to integral left-hand operand

	auto x = 0 - 1;
	extern int x;

positive: binary - operator applied to arithmetic left-hand operand

	auto x = 0.0 - 1;
	extern double x;

negative: binary - operator applied to non-arithmetic left-hand operand

	auto x = nullptr - 1;

positive: binary - operator applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a - 1;
	extern int x;

negative: binary - operator applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a - 1;

negative: binary - operator applied to left-hand operand of function pointer type

	int (*p) ();
	auto x = p - 0;

negative: binary - operator applied to left-hand operand of incomplete pointer type

	class *p;
	auto x = p - 0;

positive: binary - operator applied to left-hand operand of pointer type and integral right-hand operand

	int* p;
	auto x = p - 0;
	extern int* x;

negative: binary - operator applied to left-hand operand of pointer type and non-integral right-hand operand

	int* p;
	auto x = p - 0.0;

positive: binary - operator applied to left-hand operand of pointer type and unscoped enumeration right-hand operand

	int* p;
	enum e {a};
	auto x = p - e::a;
	extern int* x;

negative: binary - operator applied to left-hand operand of pointer type and scoped enumeration right-hand operand

	int* p;
	enum class e {a};
	auto x = p - e::a;

negative: binary - operator applied to left-hand operand of pointer type and right-hand operand of differing pointer type

	int* p;
	double *q;
	auto x = p - q;

positive: binary - operator applied to left-hand operand of pointer type and right-hand operand of same pointer type

	int* p, *q;
	auto x = p - q;

positive: binary - operator applied to left-hand operand of cv-qualified pointer type and right-hand operand of same cv-unqualified pointer type

	const int* p;
	int *q;
	auto x = p - q;

positive: binary - operator applied to left-hand operand of cv-unqualified pointer type and right-hand operand of same cv-qualified pointer type

	int* p;
	const int *q;
	auto x = p - q;

positive: binary - operator applied to integral right-hand operand

	auto x = 1 - 0;
	extern int x;

positive: binary - operator applied to arithmetic right-hand operand

	auto x = 1 - 0.0;
	extern double x;

negative: binary - operator applied to non-arithmetic right-hand operand

	auto x = 1 - nullptr;

positive: binary - operator applied to unscoped enumeration right-hand operand

	enum e {a};
	auto x = 1 - e::a;
	extern int x;

negative: binary - operator applied to scoped enumeration right-hand operand

	enum class e {a};
	auto x = 1 - e::a;

negative: binary - operator applied to right-hand operand of function pointer type

	int (*p) ();
	auto x = p - p;

negative: binary - operator applied to right-hand operand of incomplete pointer type

	class *p;
	auto x = p - p;

negative: binary - operator applied to right-hand operand of pointer type and integral left-hand operand

	int* p;
	auto x = 0 - p;
	extern int* x;

# 8.7 [expr.add] 3

positive: integral addition

	static_assert (2 + 3 == 5);

positive: floating-point addition

	static_assert (2.5 + 3.75 == 6.25);

positive: integral subtraction

	static_assert (2 - 3 == -1);

positive: floating-point subtraction

	static_assert (2.5 - 3.75 == -1.25);

# 8.7 [expr.add] 4

positive: pointer addition

	int x[10];
	static_assert (x + 5 == &x[5]);
	static_assert (4 + &x[3] == x + 7);

positive: pointer subtraction

	int x[10];
	static_assert (x - -5 == &x[5]);
	static_assert (&x[7] - 2 == x + 5);

# 8.7 [expr.add] 5

positive: pointer difference type

	#include <cstddef>
	int a[10];
	int* p = a + 5;
	int* q = a + 2;
	auto x = p - q;
	extern std::ptrdiff_t x;

positive: pointer difference

	int x[10];
	static_assert (&x[7] - &x[2] == 5);

# todo: 8.7 [expr.add] 7

#positive: null pointer addition

#	constexpr int* x = nullptr;
#	static_assert (x + 0 == nullptr);
#	static_assert (0 + x == nullptr);

#positive: null pointer subtraction

#	constexpr int* x = nullptr;
#	static_assert (x - 0 == nullptr);

#positive: null pointer difference

#	constexpr int* x = nullptr;
#	static_assert (x - x == 0);

# 8.8 [expr.shift] 1

positive: left-shift operator grouping left-to-right

	static_assert (1 << 2 << 3 == (1 << 2) << 3);

positive: right-shift operator grouping left-to-right

	static_assert (16 >> 2 >> 1 == (16 >> 2) >> 1);

negative: left-shift operator missing left operand

	static_assert ( << 2);

negative: left-shift operation missing operator

	static_assert (1 2);

negative: left-shift operation missing right operand

	static_assert (1 <<);

negative: right-shift operation missing left operand

	static_assert ( >> 2);

negative: right-shift operation missing operator

	static_assert (1 2);

negative: right-shift operation missing right operand

	static_assert (1 >>);

positive: left-shift operation applied to integral left-hand operand

	auto x = 1 << 0;
	extern int x;

negative: left-shift operation applied to non-integral left-hand operand

	auto x = 1. << 0;

positive: left-shift operation applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a << 0;
	extern int x;

negative: left-shift operation applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a << 0;

positive: right-shift operation applied to integral right-hand operand

	auto x = 0 >> 1;
	extern int x;

negative: right-shift operation applied to non-integral right-hand operand

	auto x = 0 >> 1.;

positive: right-shift operation applied to unscoped enumeration right-hand operand

	enum e {a};
	auto x = 0 >> e::a;
	extern int x;

negative: right-shift operation applied to scoped enumeration right-hand operand

	enum class e {a};
	auto x = 0 >> e::a;

# 8.8 [expr.shift] 2

positive: zero-filling vacated bits in left-shift operation

	static_assert (10 << 10 == 10240);

positive: left-shift operation with unsigned left-hand operand

	static_assert (5u << 5 == 5 * 32);

positive: left-shift operation with signed left-hand operand

	static_assert (-5 << 5 == -5 * 32);

# 8.8 [expr.shift] 3

positive: right-shift operation with unsigned left-hand operand

	static_assert (130u >> 5 == 128 / 32);

positive: right-shift operation with signed left-hand operand

	static_assert (130 >> 5 == 130 / 32);

# 8.11 [expr.bit.and] 1

positive: bitwise AND operation

	static_assert ((0b1100 & 0b1010) == 0b1000);

positive: bitwise AND operation applied to integral left-hand operand

	auto x = 1 & 0;
	extern int x;

negative: bitwise AND operation applied to non-integral left-hand operand

	auto x = 1. & 0;

positive: bitwise AND operation applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a & 0;
	extern int x;

negative: bitwise AND operation applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a & 0;

positive: bitwise AND operation applied to integral right-hand operand

	auto x = 0 & 1;
	extern int x;

negative: bitwise AND operation applied to non-integral right-hand operand

	auto x = 0 & 1.;

positive: bitwise AND operation applied to unscoped enumeration right-hand operand

	enum e {a};
	auto x = 0 & e::a;
	extern int x;

negative: bitwise AND operation applied to scoped enumeration right-hand operand

	enum class e {a};
	auto x = 0 & e::a;

# 8.12 [expr.xor] 1

positive: bitwise exclusive OR operation

	static_assert ((0b1100 ^ 0b1010) == 0b0110);

positive: bitwise exclusive OR operation applied to integral left-hand operand

	auto x = 1 ^ 0;
	extern int x;

negative: bitwise exclusive OR operation applied to non-integral left-hand operand

	auto x = 1. ^ 0;

positive: bitwise exclusive OR operation applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a ^ 0;
	extern int x;

negative: bitwise exclusive OR operation applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a ^ 0;

positive: bitwise exclusive OR operation applied to integral right-hand operand

	auto x = 0 ^ 1;
	extern int x;

negative: bitwise exclusive OR operation applied to non-integral right-hand operand

	auto x = 0 ^ 1.;

positive: bitwise exclusive OR operation applied to unscoped enumeration right-hand operand

	enum e {a};
	auto x = 0 ^ e::a;
	extern int x;

negative: bitwise exclusive OR operation applied to scoped enumeration right-hand operand

	enum class e {a};
	auto x = 0 ^ e::a;

# 8.13 [expr.or] 1

positive: bitwise inclusive OR operation

	static_assert ((0b1100 | 0b1010) == 0b1110);

positive: bitwise inclusive OR operation applied to integral left-hand operand

	auto x = 1 | 0;
	extern int x;

negative: bitwise inclusive OR operation applied to non-integral left-hand operand

	auto x = 1. | 0;

positive: bitwise inclusive OR operation applied to unscoped enumeration left-hand operand

	enum e {a};
	auto x = e::a | 0;
	extern int x;

negative: bitwise inclusive OR operation applied to scoped enumeration left-hand operand

	enum class e {a};
	auto x = e::a | 0;

positive: bitwise inclusive OR operation applied to integral right-hand operand

	auto x = 0 | 1;
	extern int x;

negative: bitwise inclusive OR operation applied to non-integral right-hand operand

	auto x = 0 | 1.;

positive: bitwise inclusive OR operation applied to unscoped enumeration right-hand operand

	enum e {a};
	auto x = 0 | e::a;
	extern int x;

negative: bitwise inclusive OR operation applied to scoped enumeration right-hand operand

	enum class e {a};
	auto x = 0 | e::a;

# 8.14 [expr.log.and] 1

positive: logical AND operator grouping left-to-right

	static_assert ((true && false && true) == ((true && false) && true));

positive: return value of logical AND operator

	static_assert (!(false && false));
	static_assert (!(true && false));
	static_assert (!(false && true));
	static_assert (true && true);

# 8.14 [expr.log.and] 2

positive: return type of logical AND operator

	auto x = true && false;
	extern bool x;

# 8.15 [expr.log.or] 1

positive: logical OR operator grouping left-to-right

	static_assert ((true || false || true) == ((true || false) || true));

positive: return value of logical OR operator

	static_assert (!(false || false));
	static_assert (true || false);
	static_assert (false || true);
	static_assert (true || true);

# 8.15 [expr.log.or] 2

positive: return type of logical OR operator

	auto x = true || false;
	extern bool x;

# 8.19 [expr.comma] 1

positive: comma operator grouping left-to-right

	static_assert ((1, 2, 3) == ((1, 2), 3));

negative: comma operator missing left expression

	int x = (, 1);

negative: comma operator expression missing comma

	int x = (0 1);

negative: comma operator missing right expression

	int x = (0, );

positive: left-to-right evaluation of comma operator

	static_assert ((1, 2) == 2);

# todo: invocation of an overloaded comma operator with unsequenced evaluations of its arguments

negative: comma operator with type of left operand

	auto x = (0.1, 2);
	extern double x;

positive: comma operator with type of right operand

	auto x = (0.1, 2);
	extern int x;

positive: comma operator with left bit-field operand

	struct {int l : 1, r;} x;
	auto y = &(x.l, x.r);

negative: comma operator with right bit-field operand

	struct {int l, r : 1;} x;
	auto y = &(x.l, x.r);

# todo: temporary

# 8.19 [expr.comma] 2

positive: parenthesized comma operator in function argument list

	int f (int), x = f ((1, 2));

negative: unparenthesized comma operator in function argument list

	int f (int), x = f (1, 2);

positive: parenthesized comma operator in initializer list

	int x = (1, 2);

negative: unparenthesized comma operator in initializer list

	int x = 1, 2;

# 9 [stmt.stmt] 1

positive: attributed labeled statement

	void f () {[[]] label: ;}

positive: attributed case statement

	void f () {switch (0) [[]] case 0: ;}

positive: attributed default statement

	void f () {switch (0) [[]] default: ;}

positive: attributed expression statement

	void f () {[[]] 0;}

positive: attributed null statement

	void f () {[[]];}

positive: attributed compound statement

	void f () {[[]] {} }

positive: attributed if statement

	void f () {[[]] if (false) ;}

positive: attributed switch statement

	void f () {[[]] switch (0) ;}

positive: attributed while statement

	void f () {[[]] while (false) ;}

positive: attributed do statement

	void f () {[[]] do ; while (false);}

positive: attributed for statement

	void f () {[[]] for (;;) ;}

positive: attributed break statement

	void f () {while (true) [[]] break;}

positive: attributed continue statement

	void f () {while (true) [[]] continue;}

positive: attributed return statement

	void f () {[[]] return;}

positive: attributed goto statement

	void f () {label: [[]] goto label;}

positive: attributed declaration statement

	void f () {[[]] void g ();}

# todo: attributed try statement

# 9 [stmt.stmt] 2

negative: function declarator in condition of if statement

	void f () {if (void g () {}) ;}

negative: function declarator in condition of if statement with else

	void f () {if (void g () {}) ; else;}

negative: function declarator in condition of switch statement

	void f () {switch (void g () {}) ;}

negative: function declarator in condition of for statement

	void f () {for (; void g () {};) ;}

negative: function declarator in condition of while statement

	void f () {while (void g () {}) ;}

negative: parenthesized function declarator in condition of if statement

	void f () {if (void (g ()) {}) ;}

negative: parenthesized function declarator in condition of if statement with else

	void f () {if (void (g ()) {}) ; else;}

negative: parenthesized function declarator in condition of switch statement

	void f () {switch (void (g ()) {}) ;}

negative: parenthesized function declarator in condition of for statement

	void f () {for (; void (g ()) {};) ;}

negative: parenthesized function declarator in condition of while statement

	void f () {while (void (g ()) {}) ;}

negative: array declarator in condition of if statement

	void f () {if (int x[10] {}) ;}

negative: array declarator in condition of if statement with else

	void f () {if (int x[10] {}) ; else;}

negative: array declarator in condition of switch statement

	void f () {switch (int x[10] {}) ;}

negative: array declarator in condition of for statement

	void f () {for (; int x[10] {};) ;}

negative: array declarator in condition of while statement

	void f () {while (int x[10] {}) ;}

negative: parenthesized array declarator in condition of if statement

	void f () {if (int (x[10]) {}) ;}

negative: parenthesized array declarator in condition of if statement with else

	void f () {if (int (x[10]) {}) ; else;}

negative: parenthesized array declarator in condition of switch statement

	void f () {switch (int (x[10]) {});}

negative: parenthesized array declarator in condition of for statement

	void f () {for (; int (x[10]) {};) ;}

negative: parenthesized array declarator in condition of while statement

	void f () {while (int (x[10]) {}) ;}

negative: class definition in condition

	void f () {if (class {} x {}) ;}

negative: enumeration definition in condition

	void f () {if (class {} x {}) ;}

positive: deduced type in condition

	void f () {if (auto x = 0) ;}

# 9 [stmt.stmt] 3

positive: name introduced by declaration specifier in scope of substatements

	void f () {if (struct s* x = nullptr) typedef s y; else typedef s y;}

positive: name introduced by declarator specifier in scope of substatements

	void f () {if (struct s* x = nullptr) x = nullptr; else x = nullptr;}

negative: redeclaration of name in outermost block of first substatement

	void f () {if (int x = 0) int x;}

negative: redeclaration of name in compound block of first substatement

	void f () {if (int x = 0) {int x;}}

positive: redeclaration of name in nested compound block of first substatement

	void f () {if (int x = 0) {{int x;}}}

negative: redeclaration of name in outermost block of second substatement

	void f () {if (int x = 0) ; else int x;}

negative: redeclaration of name in compound block of second substatement

	void f () {if (int x = 0) ; else {int x;}}

positive: redeclaration of name in nested compound block of second substatement

	void f () {if (int x = 0) ; else {{int x;}}}

negative: redeclaration of name in condition example a

	void f ()
	{
		if (int x = f()) {
			int x; // ill-formed, redeclaration of x
		else {
			// int x; // ill-formed, redeclaration of x
		}
	}

negative: redeclaration of name in condition example b

	void f ()
	{
		if (int x = f()) {
			// int x; // ill-formed, redeclaration of x
		else {
			int x; // ill-formed, redeclaration of x
		}
	}

# todo: 9 [stmt.stmt] 4
# todo: 9 [stmt.stmt] 5

# 9 [stmt.stmt] 6

negative: static storage specifier in condition

	void f () {if (static int x = 0) ;}

negative: thread_local storage specifier in condition

	void f () {if (thread_local int x = 0) ;}

negative: extern storage specifier in condition

	void f () {if (extern int x = 0) ;}

negative: mutable storage specifier in condition

	void f () {if (mutable int x = 0) ;}

negative: virtual function specifier in condition

	void f () {if (virtual int x = 0) ;}

negative: explicit function specifier in condition

	void f () {if (explicit int x = 0) ;}

negative: friend specifier in condition

	void f () {if (friend int x = 0) ;}

negative: typedef specifier in condition

	void f () {if (typedef int x = 0) ;}

positive: constexpr specifier in condition

	void f () {if (constexpr int x = 0) ;}

negative: inline function specifier in condition

	void f () {if (inline int x = 0) ;}

positive: type specifier in condition

# todo:	void f () {if (const unsigned int x = 0) ;}

# 9.1 [stmt.label] 1

positive: labeled statement

	void f () {label: ;}

negative: labeled statement missing identifier

	void f () {: ;}

negative: labeled statement missing colon

	void f () {label;}

negative: labeled statement missing statement

	void f () {label:}

positive: case statement

	void f () {switch (0) case 0: ;}

negative: case statement missing case keyword

	void f () {switch (0) 0: ;}

negative: case statement missing expression

	void f () {switch (0) case: ;}

negative: case statement missing colon

	void f () {switch (0) case 0 ;}

negative: case statement missing statement

	void f () {switch (0) case 0:}

positive: default statement

	void f () {switch (0) default: ;}

negative: default statement missing default keyword

	void f () {switch (0) : ;}

negative: default statement missing colon

	void f () {switch (0) default ;}

negative: default statement missing statement

	void f () {switch (0) default:}

negative: undeclared identifier label

	void f () {goto label;}

positive: identifier label used as target of a goto statement

	void f () {label: goto label;}

negative: identifier label used in expression

	void f () {label: label;}

positive: identifier label used in function scope

	void f () {label: goto label;}

positive: identifier label used in different block scopes

	void f () {{label: ;} {goto label;}}

negative: identifier label used in different function scopes

	void f () {label: ;}
	void g () {goto label;}

negative: identifier label redeclared in same scope

	void f () {label: label: ;}

negative: identifier label redeclared in different scopes

	void f () {{label: ;} {label: ;}}

positive: identifier label redeclared in different functions

	void f () {label: ;}
	void g () {label: ;}

positive: identifier label used in goto statement before its definition

	void f () {goto label; label: ;}

positive: identifier label used in goto statement after its definition

	void f () {label: ; goto label;}

positive: identifier labels in own name space

	void f () {label: int label;}

# todo: note

# 9.1 [stmt.label] 2

positive: case label inside switch statement

	void f () {switch (0) case 0: ;}

negative: case label outside switch statement

	void f () {case 0: switch (0) ;}

positive: default label inside switch statement

	void f () {switch (0) default: ;}

negative: default label outside switch statement

	void f () {default: switch (0) ;}

# 9.2 [stmt.expr] 1

positive: expression statement

	void f () {0;}

positive: null statement

	void f () {;}

positive: null statement before the } of a compound statement

	void f () {{label: ;}}

positive: null statement as null body of an iteration statement

	void f () {while (true) ;}

# 9.3 [stmt.block] 1

positive: compound statement

	void f () {{}}

negative: compound statement missing opening brace

	void f () {}}

negative: compound statement missing closing brace

	void f () {{}

positive: empty compound statement

	void f () {{}}

positive: non-empty compound statement

	void f () {{;}}

positive: nested compound statement

	void f () {{{}}}

positive: several nested compound statement

	void f () {{{}{}{}}}

positive: compound statement defining block scope

	void f () {int x; {int x; {int x;}}}

# 9.4 [stmt.select] 1

positive: if statement

	void f () {if (true) return;}

negative: if statement missing if keyword

	void f () {(true) return;}

negative: if statement missing opening parenthesis

	void f () {if true) return;}

negative: if statement missing condition

	void f () {if () return;}

negative: if statement missing closing parenthesis

	void f () {if (true return;}

negative: if statement missing parentheses

	void f () {if true return;}

negative: if statement missing statement

	void f () {if (true)}

positive: if statement missing else

	void f () {if (true) return;}

positive: if statement with else

	void f () {if (true) return; else return;}

negative: if statement with else missing statement

	void f () {if (true) return; else}

positive: switch statement

	void f () {switch (0) break;}

negative: switch statement missing switch keyword

	void f () {(0) break;}

negative: switch statement missing opening parenthesis

	void f () {switch 0) break;}

negative: switch statement missing condition

	void f () {switch () break;}

negative: switch statement missing closing parenthesis

	void f () {switch (0 break;}

negative: switch statement missing parentheses

	void f () {switch 0 break;}

negative: switch statement missing statement

	void f () {switch (0)}

positive: expression as condition

	void f () {int x = 0; if (x) ;}

positive: declaration as condition

	void f () {if (int x = 0) ;}

positive: attributed declaration as condition

	void f () {if ([[]] int x = 0) ;}

negative: declaration as condition missing declaration specifiers

	void f () {if (x = 0) ;}

negative: declaration as condition missing declarator

	void f () {if (int = 0) ;}

negative: declaration as condition missing initializer

	void f () {if (int x) ;}

positive: declaration as condition with assignment initializer

	void f () {if (int x = 0) ;}

# todo: declaration as condition with braced initializer

positive: implicitly defined block scope in substatements

	void f ()
	{
		int x; if (true) int x;
		if (true) int x; else int x;
	}

positive: substatement example

	void f (int x)
	{
		if (x)
			int i;
		if (x) {
			int i;
		}
	}

# 9.4.1 [stmt.if] 1

positive: if statement of first substatement in if statement containing else part

	void f () {if (int x = 0) if (int y = x) ; else y = 0;}

positive: else part associated with nearest un-elsed if statement

	void f () {if (int x = 0) if (int y = x) ; else y = 0; else x = 0;}

negative: else part associated with farthest un-elsed if statement

	void f () {if (int x = 0) if (int y = x) ; else x = 0; else y = 0;}

# 9.4.2 [stmt.switch] 2

positive: switch condition of integral type

	void f (bool x) {switch (x) ;}
	void f (char x) {switch (x) ;}
	void f (signed char x) {switch (x) ;}
	void f (unsigned char x) {switch (x) ;}
	void f (char16_t x) {switch (x) ;}
	void f (char32_t x) {switch (x) ;}
	void f (signed short x) {switch (x) ;}
	void f (unsigned short x) {switch (x) ;}
	void f (signed int x) {switch (x) ;}
	void f (unsigned int x) {switch (x) ;}
	void f (signed long x) {switch (x) ;}
	void f (unsigned long x) {switch (x) ;}
	void f (signed long long x) {switch (x) ;}
	void f (unsigned long long x) {switch (x) ;}

negative: switch condition of type float

	void f (float x) {switch (x) ;}

negative: switch condition of type double

	void f (double x) {switch (x) ;}

negative: switch condition of type long double

	void f (long double x) {switch (x) ;}

negative: switch condition of type std::nullptr_t

	void f () {switch (nullptr) ;}

negative: switch condition of type void

	void f () {switch (f ()) ;}

positive: switch condition of unscoped enumeration type

	void f () {enum e {} x; switch (x) ;}

positive: switch condition of scoped enumeration type

	void f () {enum class e {} x; switch (x) ;}

# todo: switch condition of class type

negative: switch condition of array type

	void f () {int x[10]; switch (x) ;}

negative: switch condition of pointer type

	void f (int* x) {switch (x) ;}

# todo: integral promotions

positive: switch statement with no case labels

	void f () {switch (0) ;}

positive: switch statement with one case label

	void f () {switch (0) case 0: ;}

positive: switch statement with two case labels

	void f () {switch (0) case 0: case 1: ;}

positive: switch statement with case labels in different statements

	void f () {switch (0) case 0: case 1: {case 2: case 3: ;}}

positive: case statement with constant expression

	void f () {switch (0) case 5: ;}

negative: case statement with non-constant expression

	void f () {switch (0) case x: ;}

negative: case statement with narrowing conversion

	void f () {switch (0) case 1'000'000'000'000: ;}

negative: switch statement with duplicated case labels

	void f () {switch (0) case 0: case 1 - 1: ;}

# 9.4.2 [stmt.switch] 3

positive: switch statement with no default label

	void f () {switch (0) ;}

positive: switch statement with one default label

	void f () {switch (0) default: ;}

negative: switch statement with two default labels

	void f () {switch (0) default: default: ;}

negative: switch statement with default labels in different statements

	void f () {switch (0) default: {default: ;}}

# 9.4.2 [stmt.switch] 4

positive: nested switch statements

	void f () {switch (0) default: case 0: case 1: switch (0) case 1: default: case 0: ;}

positive: case label associated with nearest enclosing switch statement

	void f () {switch (int x = 0) {switch (int y = x) case 0: y = 0; case 0: x = 0;}}

negative: case label associated with farthest enclosing switch statement

	void f () {switch (int x = 0) {switch (int y = x) case 0: x = 0; case 0: y = 0;}}

positive: default label associated with nearest enclosing switch statement

	void f () {switch (int x = 0) {switch (int y = x) default: y = 0; default: x = 0;}}

negative: default label associated with farthest enclosing switch statement

	void f () {switch (int x = 0) {switch (int y = x) default: x = 0; default: y = 0;}}

# 9.5 [stmt.iter] 1

positive: while statement

	void f () {while (true) return;}

negative: while statement missing while keyword

	void f () { (true) return;}

negative: while statement missing opening parenthesis

	void f () {while true) return;}

negative: while statement missing condition

	void f () {while () return;}

negative: while statement missing closing parenthesis

	void f () {while (true return;}

negative: while statement missing parentheses

	void f () {while true return;}

negative: while statement missing statement

	void f () {while (true)}

positive: do statement

	void f () {do return; while (true);}

negative: do statement missing do keyword

	void f () {return while (true);}

negative: do statement missing statement

	void f () {do while (true);}

negative: do statement missing opening parenthesis

	void f () {do return; while true);}

negative: do statement missing condition

	void f () {do return; while ();}

negative: do statement missing closing parenthesis

	void f () {do return; while (true;}

negative: do statement missing parentheses

	void f () {do return; while true;}

negative: do statement missing semicolon

	void f () {do return; while (true)}

positive: for statement

	void f () {for (int i = 0; i != 10; ++i) ;}

negative: for statement missing for keyword

	void f () {(int i = 0; i != 10; ++i) ;}

negative: for statement missing opening parenthesis

	void f () {for int i = 0; i != 10; ++i) ;}

negative: for statement missing init statement

	void f () {int i = 0; for (i != 10; ++i) ;}

positive: for statement with null init statement

	void f () {int i = 0; for (; i != 10; ++i) ;}

positive: for statement with expression as init statement

	void f () {int i; for (i = 0; i != 10; ++i) ;}

positive: for statement missing condition

	void f () {for (int i = 0;; ++i) ;}

negative: for statement missing semicolon after condition

	void f () {for (int i = 0; i != 10 ++i) ;}

positive: for statement missing increment expression

	void f () {for (int i = 0; i != 10;) ;}

negative: for statement missing closing parenthesis

	void f () {for (int i = 0; i != 10; ++i ;}

negative: for statement missing statement

	void f () {for (int i = 0; i != 10; ++i)}

positive: for statement missing condition and increment expression

	void f () {for (int i = 0;;) ;}

positive: for statement with null statement missing condition and increment expression

	void f () {for (;;) ;}

# todo: range-based for statement

# 9.5 [stmt.iter] 2

positive: implicitly defined block scope in iteration statement

	void f ()
	{
		int x;
		while (true) int x;
		do int x; while (true);
		for (;;) int x;
	}

positive: iteration substatement example

	void f (int x)
	{
		while (--x >= 0)
			int i;

		while (--x >= 0) {
			int i;
		}
	}

# 9.5.2 [stmt.do] 1

positive: do statement with boolean condition

	void f () {do ; while (true);}

positive: do statement with condition converted to boolean

	void f () {int x; do ; while (x);}

# todo: non-convertible condition

negative: do statement with declaration as condition

	void f () {do ; while (int x = 0);}

negative: do statement with condition accessing scope of substatement

	void f () {do int x; while (x);}

# 9.5.3 [stmt.for] 1

positive: names declared init statement in same scope as condition

	void f () {for (int x; int y = x; ++x, ++y) --x, --y;}

negative: redaclaration of names declared init statement in same scope as condition

	void f () {for (int x; int x = 0;) ;}

# todo: 9.5.4 [stmt.ranged]

# 9.6 [stmt.jump] 1

positive: break statement

	void f () {for (;;) break;}

negative: break statement missing semicolon

	void f () {for (;;) break}

positive: continue statement

	void f () {for (;;) continue;}

negative: continue statement missing semicolon

	void f () {for (;;) continue}

positive: return statement

	int f () {return 0;}

positive: return statement missing expression

	void f () {return;}

negative: return statement missing semicolon

	int f () {return 0}

positive: goto statement

	void f () {label: goto label;}

negative: goto statement missing identifier

	void f () {label: goto ;}

negative: goto statement missing semicolon

	void f () {label: goto label}

# todo: 9.6 [stmt.jump] 2

# 9.6.1 [stmt.break] 1

positive: break statement inside while statement

	void f () {while (true) break;}

positive: break statement inside do statement

	void f () {do break; while (true);}

positive: break statement inside for statement

	void f () {for (;;) break;}

positive: break statement inside switch statement

	void f () {switch (0) break;}

negative: break statement inside compound statement

	void f () {{break;}}

negative: break statement outside iteration or switch statement

	void f () {break;}

# 9.6.2 [stmt.cont] 1

positive: continue statement inside while statement

	void f () {while (true) continue;}

positive: continue statement inside do statement

	void f () {do continue; while (true);}

positive: continue statement inside continue statement

	void f () {for (;;) continue;}

negative: continue statement inside switch statement

	void f () {switch (0) continue;}

negative: continue statement inside compound statement

	void f () {{continue;}}

negative: continue statement outside iteration statement

	void f () {continue;}

# 9.6.4 [stmt.goto] 1

positive: goto statement with declared identifier

	void f () {label: goto label;}

negative: goto statement with undeclared identifier

	void f () {goto label;}

# 10 [dcl.dcl] 1

positive: alias declaration

	using t = int;

negative: alias declaration missing using keyword

	t = int;

negative: alias declaration missing identifier

	using = int;

positive: attribute alias declaration

	using t [[]] = int;

negative: alias declaration missing equal sign

	using t int;

negative: alias declaration missing type identifier

	using t =;

negative: alias declaration missing semicolon

	using t = int

# todo: simple declaration missing declaration specifiers

positive: simple declaration missing declarators

	class c;

negative: simple declaration missing semicolon

	class c

positive: static assertion

	static_assert (true);
	static_assert (true, "");

negative: static assertion missing static_assert keyword

	(true, "");

negative: static assertion missing opening parenthesis

	static_assert true, "");

negative: static assertion missing expression

	static_assert (, "");

negative: static assertion missing comma

	static_assert (true "");

negative: static assertion missing string literal

	static_assert (true, );

positive: static assertion missing second argument

	static_assert (true);

negative: static assertion missing closing parenthesis

	static_assert (true, "";

negative: static assertion missing semicolon

	static_assert (true, "")

positive: empty declaration

	;

positive: attribute declaration

	[[]];

negative: attribute declaration missing semicolon

	[[]]

# 10 [dcl.dcl] 2

positive: attributes in simple declaration appertaining to all declared entities

	[[noreturn]] void f (), g (), h ();

positive: attributes appertaining at the start of declaration and after declarator example

	[[noreturn]] void f [[noreturn]] (); // OK

# todo: 10 [dcl.dcl] 4

# 10 [dcl.dcl] 5

positive: omitted declarators in simple declaration of a named class

	class x {};
	class y;

negative: omitted declarators in simple declaration of an unnamed class

	class {};

positive: omitted declarators in simple declaration of a scoped enumeration

	enum class x {};

positive: omitted declarators in simple declaration of a named unscoped enumeration

	enum x {};

positive: omitted declarators in simple declaration of an unnamed unscoped enumeration with enumerators

	enum {a};

negative: omitted declarators in simple declaration of an unnamed unscoped enumeration without enumerators

	enum {};

negative: omitted declarators in simple declaration;

	int;

negative: non-declaring declaration specifiers example a

	enum { }; // ill-formed

negative: non-declaring declaration specifiers example b

	typedef class { }; // ill-formed

# 10 [dcl.dcl] 6

negative: static assertion with non-constant expression

	int x;
	static_assert (x);

negative: static assertion with non-boolean expression

	class {} x;
	static_assert (x);

positive: static assertion with expression converted to bool

	static_assert (1);

positive: satisfied static assertion with string literal

	static_assert (true, "unsatisfied");

positive: satisfied static assertion without string literal

	static_assert (true);

negative: unsatisfied static assertion with string literal

	static_assert (false, "unsatisfied");

negative: unsatisfied static assertion without string literal

	static_assert (false);

# 10 [dcl.dcl] 7

positive: effect-free empty declaration

	;

# 10 [dcl.dcl] 8

negative: declarator in simple declaration missing identifier

	int*;

# 10 [dcl.dcl] 9

negative: object declaration is definition

	int x;
	int x;

negative: object declaration with initializer is definition

	int x = 0;
	int x;

negative: object declaration with extern specifier and initializer is definition

	extern int x = 0;
	int x;

# todo: 10 [dcl.dcl] 10
# todo: 10 [dcl.dcl] 11
# todo: 10 [dcl.dcl] 12

# 10.1 [dcl.spec] 1

positive: friend declaration specifier

	class c {friend void f ();};

positive: typedef declaration specifier

	typedef int x;

positive: constexpr declaration specifier

	constexpr int x = 0;

positive: inline declaration specifier

	inline void f ();

positive: attributed declaration specifiers

	int [[]] x;

# todo: unaffected declarations by attributed declaration specifiers

# 10.1 [dcl.spec] 2

negative: duplicated static specifier

	static static int x;

negative: duplicated thread_local specifier

	thread_local thread_local int x;

negative: duplicated extern specifier

	extern extern int x;

negative: duplicated mutable specifier

	class c {mutable mutable int x;};

negative: duplicated class specifier

	class c class d x;

negative: duplicated enum specifier

	enum {} enum {} x;

negative: duplicated const specifier

	const const int x = 0;

negative: duplicated volatile specifier

	volatile volatile int x;

negative: duplicated type specifier

	using t = int; t t x;

negative: duplicated char specifier

	char char x;

negative: duplicated char16_t specifier

	char16_t char16_t x;

negative: duplicated char32_t specifier

	char32_t char32_t x;

negative: duplicated wchar_t specifier

	wchar_t wchar_t x;

negative: duplicated bool specifier

	bool bool x;

negative: duplicated short specifier

	short short x;

negative: duplicated int specifier

	int int x;

positive: duplicated long specifier

	long long x;

negative: tripled long specifier

	long long long x;

negative: duplicated signed specifier

	signed signed x;

negative: duplicated unsigned specifier

	unsigned unsigned x;

negative: duplicated float specifier

	float float x;

negative: duplicated double specifier

	double double x;

negative: duplicated void specifier

	void void f ();

negative: duplicated auto specifier

	auto auto x = 0;

negative: duplicated decltype specifier

	decltype (0) decltype (0) x;

negative: duplicated virtual specifier

	class c {virtual virtual void f ();};

negative: duplicated explicit specifier

	class c {explicit explicit c ();};

negative: duplicated friend specifier

	class c {friend friend void f ();};

negative: duplicated typedef specifier

	typedef typedef int t;

negative: duplicated constexpr specifier

	constexpr constexpr int t = 0;

negative: duplicated inline specifier

	inline inline void f ();

# 10.1 [dcl.spec] 3

positive: type name part of declaration specifiers without type specifier

	class x;
	extern x y;

negative: type name part of declaration specifiers with type specifier

	class x;
	extern int x y;

positive: type name part of declaration specifiers with const-volatile specifier

	class x;
	extern const x y;
	extern x const y;
	extern volatile x z;
	extern x volatile z;

negative: type name part of declaration specifiers example a

	typedef char* Pc;
	static Pc; // error: name missing

positive: type name part of declaration specifiers example b

	typedef char* Pc;
	void f(const Pc); // void f(char* const) (not const char*)
	void g(const int Pc); // void g(const int)

	void ::f (char* const);
	void ::g (const int);

# 10.1 [dcl.spec] 4

positive: type name appearing after signed, unsigned, long, and short example

	typedef char* Pc;
	void h(unsigned Pc); // void h(unsigned int)
	void k(unsigned int Pc); // void k(unsigned int)

	void ::h (unsigned int);
	void ::k (unsigned int);

# 10.1.1 [dcl.stc] 1

positive: static storage class

	void f () {static int x; int static y;}

positive: thread_local storage class

	void f () {thread_local int x; int thread_local y;}

positive: extern storage class

	void f () {extern int x; int extern y;}

positive: mutable storage class

	class c {mutable int x;};

negative: combination of storage classes static and static

	void f () {static static int x;}

positive: combination of storage classes static and thread_local

	void f () {static thread_local int x;}

negative: combination of storage classes static and extern

	void f () {static extern int x;}

negative: combination of storage classes static and mutable

	void f () {static mutable int x;}

positive: combination of storage classes thread_local and static

	void f () {thread_local static int x;}

negative: combination of storage classes thread_local and thread_local

	void f () {thread_local thread_local int x;}

positive: combination of storage classes thread_local and extern

	void f () {thread_local extern int x;}

negative: combination of storage classes thread_local and mutable

	void f () {thread_local mutable int x;}

negative: combination of storage classes extern and static

	void f () {extern static int x;}

positive: combination of storage classes extern and thread_local

	void f () {extern thread_local int x;}

negative: combination of storage classes extern and extern

	void f () {extern extern int x;}

negative: combination of storage classes extern and mutable

	void f () {extern mutable int x;}

negative: combination of storage classes mutable and static

	class c {mutable static int x;};

negative: combination of storage classes mutable and thread_local

	class c {mutable thread_local int x;};

negative: combination of storage classes mutable and extern

	class c {mutable extern int x;};

negative: combination of storage classes mutable and mutable

	class c {mutable mutable int x;};

positive: thread_local in all declarations of a variable

	extern thread_local int x;
	extern thread_local int x;

negative: thread_local in first declaration of a variable

	extern thread_local int x;
	extern int x;

negative: thread_local in second declaration of a variable

	extern int x;
	extern thread_local int x;

negative: static storage class with typedef specifier

	void f () {typedef static int x;}

negative: thread_local storage class with typedef specifier

	void f () {typedef thread_local int x;}

negative: extern storage class with typedef specifier

	void f () {typedef extern int x;}

negative: mutable storage class with typedef specifier

	class c {typedef mutable int x;};

negative: static storage class without declarator

	void f () {static int;}

negative: thread_local storage class without declarator

	void f () {thread_local int;}

negative: extern storage class without declarator

	void f () {extern int;}

negative: mutable storage class without declarator

	class c {mutable int;};

# todo: anonymous union

positive: non-application of storage class to class specifier

	static class c {static int x;} y;
	thread_local class d {static thread_local int x;} z;

positive: non-application of storage class to enum specifier

	static enum {a, b, c} x;
	thread_local enum {d, e, f} y;

# todo: storage class in explicit specialisation or instantiantion

# todo: 10.1.1 [dcl.stc] 3

# 10.1.1 [dcl.stc] 4

positive: static specifier applied to variable in global scope

	static int x;

positive: static specifier applied to variable in namespace scope

	namespace n {static int x;}
	namespace {static int x;}

positive: static specifier applied to member variable

	class c {static int x;};

positive: static specifier applied to variable in block scope

	void f () {static int x;}

positive: static specifier applied to function in global scope

	static void f ();

positive: static specifier applied to function in namespace scope

	namespace n {static void f ();}
	namespace {static void f ();}

positive: static specifier applied to member function

	class c {static void f ();};

negative: static specifier applied to function in block scope

	void f () {static void g ();}

negative: static specifier applied to function parameter

	void f (static int x);

# todo: anonymous union

# 10.1.1 [dcl.stc] 5

positive: extern specifier applied to variable in global scope

	extern int x;

positive: extern specifier applied to variable in namespace scope

	namespace n {extern int x;}
	namespace {extern int x;}

negative: extern specifier applied to data member

	class c {extern int x;};

positive: extern specifier applied to variable in block scope

	void f () {extern int x;}

positive: extern specifier applied to function in global scope

	extern void f ();

positive: extern specifier applied to function in namespace scope

	namespace n {extern void f ();}
	namespace {extern void f ();}

negative: extern specifier applied to member function

	class c {extern void f ();};

positive: extern specifier applied to function in block scope

	void f () {extern void g ();}

negative: extern specifier applied to function parameter

	void f (extern int x);

# 10.1.1 [dcl.stc] 6-9

# todo: 10.1.2 [dcl.fct.spec] 1-3

# 10.1.3 [dcl.typedef] 1

negative: combination of typedef specifier with static specifier

	typedef static int x;

negative: combination of typedef specifier with thread_local specifier

	typedef thread_local int x;

negative: combination of typedef specifier with extern specifier

	typedef extern int x;

negative: combination of typedef specifier with mutable specifier

	typedef mutable int x;

positive: combination of typedef specifier with type specifier

	typedef int x;

negative: combination of typedef specifier with virtual specifier

	typedef virtual int x;

negative: combination of typedef specifier with explicit specifier

	typedef explicit int x;

negative: combination of typedef specifier with friend specifier

	typedef friend int x;

negative: combination of typedef specifier with typedef specifier

	typedef typedef int x;

negative: combination of typedef specifier with constexpr specifier

	typedef constexpr bool x;

negative: combination of typedef specifier with inline specifier

	typedef inline int x;

negative: typedef specifier used in parameter declaration

	void f (typedef int x);

negative: typedef specifier used in function definition

	typedef int f () {};

positive: typedef specifier used in simple declaration

	typedef int x;

negative: typedef specifier used in simple declaration without declarators

	typedef class c;

positive: typedef specifier used in simple declaration with unqualified declarators

	typedef int x, y;

negative: typedef specifier used in simple declaration with qualified declarators

	typedef int x, y;
	typedef int ::x, ::y;

positive: name declared with typedef specifier becoming type alias

	typedef int x;
	x y;

positive: synonymous type introduced by type alias

	typedef int x;
	extern x y;
	extern int y;

positive: type alias example

	typedef int MILES, *KLICKSP;
	MILES distance;
	extern KLICKSP metricp;

	extern int distance;
	extern int* metricp;

# 10.1.3 [dcl.typedef] 2

positive: synonymous type introduced by alias declaration

	using x = int;
	extern x y;
	extern int y;

negative: name of alias declaration appearing in type identifier

	using x = x;

positive: alias declaration example a

	using handler_t = void (*)(int);
	extern handler_t ignore;
	extern void (*ignore)(int); // redeclare ignore

# todo: alias declaration example b
# todo: type definition in template-declaration

# 10.1.3 [dcl.typedef] 3

positive: alias name redefinition of any declared type in non-class scope

	typedef int x;
	typedef x x;
	typedef x x;

positive: alias name redefinition of declared class type in non-class scope

	class x {};
	typedef x x;
	typedef x x;

positive: alias name redefinition of declared enumeration type in non-class scope

	enum x {};
	typedef x x;
	typedef x x;

positive: alias name redefinition example

	typedef struct s { /*...*/ } s;
	typedef int I;
	typedef int I;
	typedef I I;

# 10.1.3 [dcl.typedef] 4

negative: alias name redefinition of any declared type in class scope

	class c {
		typedef int x;
		typedef x x;
	};

positive: alias name redefinition of declared class type in class scope

	class c {
		class x {};
		typedef x x;
	};

negative: alias name redefinition of already referable class type in class scope

	class c {
		class x {};
		typedef x x;
		typedef x x;
	};

positive: alias name redefinition of declared enumeration type in class scope

	class c {
		enum x {};
		typedef x x;
	};

negative: alias name redefinition of already referable enumeration type in class scope

	class c {
		enum e {};
		typedef e e;
		typedef e e;
	};

positive: alias name redefinition in class scope example a

	struct S {
		typedef struct A { } A; // OK
		typedef struct B B; // OK
	};

negative: alias name redefinition in class scope example b

	struct S {
		typedef struct A { } A; // OK
		typedef A A; // error
	};

# 10.1.3 [dcl.typedef] 5

positive: referencing an entity redefined by an alias name using an elaborated class specifier

	typedef class c c;
	extern class c x;
	extern c x;

positive: referencing an entity redefined by an alias name using an elaborated class definition

	class c {};
	typedef c c;
	extern class c x;
	extern c x;

# todo: elaborated enum specifier

positive: referencing an entity redefined by an alias name using an elaborated enumeration definition

	class e {};
	typedef e e;
	extern class e x;
	extern e x;

positive: referencing redefined entity example

	struct S;
	typedef struct S S;
	int main () {
		struct S* p;
	}
	struct S { };

# 10.1.3 [dcl.typedef] 6

negative: alias name redefinition of using different type

	typedef int x;
	typedef bool x;

negative: alias name redefinition of declared class type using different type

	class x {};
	typedef int x;

negative: alias name redefinition of declared enumeration type using different type

	enum x {};
	typedef int x;

negative: alias name redefinition using different type example

	class complex { /* ... */ };
	typedef int complex; // error: redefinition

# 10.1.3 [dcl.typedef] 7

negative: class declared with alias name referring to different type

	typedef int x;
	class x {};

positive: class declared with alias name referring to same type

	typedef class x x;
	class x {};

negative: enumeration declaration with alias name referring to different type

	typedef int x;
	enum x {};

# todo: enumeration declared with alias name referring to same type

negative: declaration of alias name referring to different type example

	typedef int complex;
	class complex { /* ... */ }; // error: redefinition

# todo: 10.1.3 [dcl.typedef] 8

# 10.1.3 [dcl.typedef] 9

positive: aliasing unnamed class

	typedef class {} x;

positive: aliasing unnamed enumeration

	typedef enum {} x;

positive: aliasing unnamed class example

	typedef struct { } *ps, S; // S is the class name for linkage purposes

# 10.1.6 [dcl.inline] 1

positive: inline specifier applied to variable in global scope

	inline int x;

positive: inline specifier applied to static variable in global scope

	static inline int x;

positive: inline specifier applied to variable in namespace scope

	namespace n {inline int x;}

positive: inline specifier applied to static variable in namespace scope

	namespace n {static inline int x;}

negative: inline specifier applied to non-static data member

	class c {inline int x;};

positive: inline specifier applied to static data member

	class c {static inline int x;};

positive: inline specifier applied to function in global scope

	inline void f ();

positive: inline specifier applied to static function in global scope

	static inline void f ();

positive: inline specifier applied to function in namespace scope

	namespace n {inline void f ();}
	namespace {inline void f ();}

positive: inline specifier applied to static function in namespace scope

	namespace n {static inline void f ();}
	namespace {static inline void f ();}

positive: inline specifier applied to member function

	class c {inline void f ();};

negative: inline specifier applied to static member function

	void f () {static inline void g ();}

negative: inline specifier applied to function parameter

	void f (inline int x);

# todo: 10.1.6 [dcl.inline] 4

# 10.1.6 [dcl.inline] 5

negative: inline specifier applied to variable in block scope

	void f () {inline int x;}

negative: inline specifier applied to static variable in block scope

	void f () {static inline int x;}

negative: inline specifier applied to function in block scope

	void f () {inline void g ();}

# todo: friend function declaration

# 10.1.6 [dcl.inline] 6

positive: unused undefined inline function

	inline void f ();

negative: using undefined inline function

	inline void f ();
	void g () {f ();}

positive: unused defined inline function

	inline void f () {}

positive: using defined inline function

	inline void f () {}
	void g () {f ();}

positive: using inline function before its definition

	inline void f ();
	void g () {f ();}
	void f () {}

positive: unused undefined inline variable

	extern inline int x;

negative: using undefined inline variable

	extern inline int x;
	int g () {return x;}

positive: unused defined inline variable

	inline int x;

positive: using defined inline variable

	inline int x;
	int g () {return x;}

positive: using inline variable before its definition

	extern inline int x;
	int g () {return x;}
	int x;

negative: function definition before first declaration as inline

	void f () {}
	inline void f ();

positive: function definition after first declaration as inline

	inline void f ();
	void f () {}

negative: variable definition before first declaration as inline

	int x;
	extern inline int x;

positive: variable definition after first declaration as inline

	extern inline int x;
	int x;

# todo: static local variable in an inline function
# todo: type defined within the body of an inline function

# 10.2 [dcl.enum] 1

negative: enum specifier missing enum head

	{a};

negative: enum specifier missing opening brace

	enum e a};

negative: enum specifier missing closing brace

	enum e {a;

positive: enum specifier with empty enumerator list

	enum e {};

negative: enum specifier with empty enumerator list and trailing comma

	enum e {,};

positive: enum specifier with single enumerator

	enum e {a};

positive: enum specifier with single enumerator and trailing comma

	enum e {a};

positive: enum specifier with multiple enumerators

	enum e {a, b, c};

positive: enum specifier with multiple enumerators and trailing comma

	enum e {a, b, c,};

negative: enum head missing enum key

	[[]] e : int {a};

positive: enum head missing attributes

	enum e : int {a};

positive: enum head missing identifier

	enum [[]] : int {a};

positive: enum head missing enum base

	enum [[]] e {a};

positive: enum specifier with attributes

	enum [[]] e {};

positive: opaque enum declaration with attributes

	enum class [[]] e;

negative: enumeration redaclaration example

	struct S {
		enum E : int {};
		enum E : int {};
	};

# 10.2 [dcl.enum] 2

positive: unscoped enumeration

	enum e : int;

positive: scoped enumeration

	enum class e;
	enum struct e;

negative: scoped enumeration missing identifier

	enum class : int {a};

positive: enum base of integral type

	enum e0 : bool;
	enum e1 : char;
	enum e2 : char16_t;
	enum e3 : char32_t;
	enum e4 : wchar_t;
	enum e5 : signed char;
	enum e6 : short int;
	enum e7 : int;
	enum e8 : long int;
	enum e9 : long long int;
	enum e10 : unsigned char;
	enum e11 : unsigned short int;
	enum e12 : unsigned int;
	enum e13 : unsigned long int;
	enum e14 : unsigned long long int;

negative: enum base of type float

	enum e : float;

negative: enum base of type double

	enum e : double;

negative: enum base of type long double

	enum e : long double;

negative: enum base of type class

	enum e : class b {};

negative: enum base of type enumeration

	enum e : enum b {};

positive: ignoring cv-qualification in enum base

	enum e : int;
	enum e : const int;
	enum e : volatile int;
	enum e : const volatile int;

negative: opaque declaration of unscoped enumeration missing enum base

	enum e;

positive: enumerator definition example

	enum { a, b, c = 0 };
	enum { d, e, f = e + 2 };
	static_assert (a == 0);
	static_assert (b == 1);
	static_assert (c == 0);
	static_assert (d == 0);
	static_assert (e == 1);
	static_assert (f == 3);

# 10.2 [dcl.enum] 3

positive: declaration of new enumeration

	enum class e;

positive: redeclaration of enumeration in current scope

	enum class e;
	enum class e;

negative: redeclaration of enumeration in different scope

	namespace n {enum class e;}
	enum class n::e;

# todo: note

positive: redaclaration of scoped enumeration

	enum class e : int;
	enum class e : int;

negative: redaclaration of scoped enumeration as unscoped

	enum class e : int;
	enum e : int;

negative: redaclaration of scoped enumeration with different underlying type

	enum class e : int;
	enum class e : bool;

positive: redaclaration of unscoped enumeration

	enum e : int;
	enum e : int;

negative: redaclaration of unscoped enumeration as scoped

	enum e : int;
	enum class e : int;

negative: redaclaration of unscoped enumeration with different underlying type

	enum e : int;
	enum e : bool;

# 10.2 [dcl.enum] 4

# todo: enumeration declared in class

positive: enum specifier referring to enumeration declared in namespace

	namespace n {enum class e;}
	enum class n::e {};

negative: enum specifier referring to enumeration declared in different namespace

	namespace n {namespace m {enum class e;}; using m::e;}
	enum class n::e {};

negative: enum specifier referring to enumeration within non-namespace scope

	namespace n {enum class e;}
	void f () {enum class n::e {};}

negative: enum specifier referring to enumeration within non-enclosing namespace

	namespace n {enum class e;}
	namespace m {enum class n::e {};}

# 10.2 [dcl.enum] 5

negative: different enumeration types

	extern enum {} a;
	extern enum {} a;

positive: implicit underlying type of scoped enumeration

	enum class e;
	enum class e : int;

positive: type of enumerators after closing brace

	enum e {a, b, c} x, y, z;
	extern decltype (a) x;
	extern decltype (b) y;
	extern decltype (c) z;

# todo: 10.2 [dcl.enum] 6-12

# 10.3.2 [namespace.alias] 1

negative: namespace alias definition missing namespace keyword

	namespace a {}
	b = a;

negative: namespace alias definition missing identifier

	namespace a {}
	namespace = a;

negative: namespace alias definition missing equal sign

	namespace a {}
	namespace b a;

negative: namespace alias definition missing name

	namespace a {}
	namespace b = ;

negative: namespace alias definition missing semicolon

	namespace a {}
	namespace b = a

# 10.3.2 [namespace.alias] 2

positive: namespace alias definition

	namespace a {extern int x;}
	namespace b = a;
	int b::x;

positive: nested namespace alias definition

	namespace a {namespace b {extern int x;}}
	namespace c = a::b;
	int c::x;

positive: namespace alias definition referring to namespace

	namespace a {}
	namespace b = a;

negative: namespace alias definition referring to class

	struct a {};
	namespace b = a;

negative: namespace alias definition referring to enumeration

	enum a {};
	namespace b = a;

negative: namespace alias definition referring to itself

	namespace a = a;

# 10.3.2 [namespace.alias] 3

negative: redeclaration of namespace alias referring to different namespace

	namespace a {}
	namespace b {}
	namespace c = a;
	namespace c = b;

positive: namespace alias redeclaration example

	namespace Company_with_very_long_name { /* ... */ }
	namespace CWVLN = Company_with_very_long_name;
	namespace CWVLN = Company_with_very_long_name;
	namespace CWVLN = CWVLN;

# 10.3.4 [namespace.udir] 1

negative: using directive missing using keyword

	namespace n {}
	namespace n;

negative: using directive missing namespace keyword

	namespace n {}
	using n;

negative: using directive missing identifier

	namespace n {}
	using namespace;

negative: using directive missing semicolon

	namespace n {}
	using namespace n

negative: using directive in class scope

	namespace n {}
	class c {using namespace n;}

positive: using directive in namespace scope

	namespace n {using namespace n;}

positive: using directive in block scope

	namespace n {}
	void f () {using namespace n;}

positive: using directive referring to namespace

	namespace n {}
	using namespace n;

negative: using directive referring to object

	int n;
	using namespace n;

negative: using directive referring to type alias

	using n = int;
	using namespace n;

negative: using directive referring to class

	class n {};
	using namespace n;

negative: using directive referring to enumeration

	enum n {};
	using namespace n;

positive: attributed using directive

	namespace n {}
	[[]] using namespace n;

# 10.3.4 [namespace.udir] 2

positive: unqualified lookup of name nominated by using directive

	namespace n {int x;}
	using namespace n;
	int y = x;

positive: unqualified lookup of name nominated by using directive in directly enclosing namespace

	namespace n {int x;}
	using namespace n;
	namespace a {int y = x;}

positive: unqualified lookup of name nominated by using directive in indirectly enclosing namespace

	namespace n {int x;}
	using namespace n;
	namespace a {namespace b {int y = x;}}

# 10.3.4 [namespace.udir] 3

positive: unchanged set of members in declarative region of using directive

	namespace n {int x;}
	using namespace n;
	int x;

positive: unchanged set of members in declarative region of using directive example a

	namespace A {
		int i;
		namespace B {
			namespace C {
				int i;
			}
			using namespace A::B::C;
			void f1() {
				i = 5; // OK, C::i visible in B and hides A::i
			}
		}
	}

negative: unchanged set of members in declarative region of using directive example b

	namespace A {
		int i;
		namespace B {
			namespace C {
				int i;
			}
			using namespace A::B::C;
		}
		namespace D {
			using namespace B;
			using namespace C;
			void f2() {
				i = 5; // ambiguous, B::C::i or A::i?
			}
		}
	}

positive: unchanged set of members in declarative region of using directive example c

	namespace A {
		int i;
		namespace B {
			namespace C {
				int i;
			}
			using namespace A::B::C;
		}
		namespace D {
			using namespace B;
			using namespace C;
		}
		void f3() {
			i = 5; // uses A::i
		}
	}

negative: unchanged set of members in declarative region of using directive example d

	namespace A {
		int i;
		namespace B {
			namespace C {
				int i;
			}
			using namespace A::B::C;
		}
		namespace D {
			using namespace B;
			using namespace C;
		}
	}
	void f4() {
		i = 5;
	}

# 10.3.4 [namespace.udir] 4

positive: transitive using directives

	namespace a {namespace b {namespace c {int x;} using namespace c;} using namespace b;}
	using namespace a;
	int y = x;

negative: first transitive using directive example

	namespace M {
		int i;
	}
	namespace N {
		int i;
		using namespace M;
	}
	void f() {
		using namespace N;
		i = 7;
	}

positive: second transitive using directive example a

	namespace A {
		int i;
	}
	namespace B {
		int i;
		namespace C {
			namespace D {
				using namespace A;
				int a = i; // B::i hides A::i
			}
		}
	}

positive: second transitive using directive example b

	namespace B {
		namespace C {
			namespace D {
				int k;
			}
			using namespace D;
			int k = 89; // no problem yet
		}
	}

negative: second transitive using directive example c

	namespace B {
		namespace C {
			namespace D {
				int k;
			}
			using namespace D;
			int k = 89; // no problem yet
			int l = k; // ambiguous: C::k or D::k
		}
	}

positive: second transitive using directive example d

	namespace A {
		int i;
	}
	namespace B {
		int i;
		int j;
		namespace C {
			namespace D {
				using namespace A;
				int j;
			}
			using namespace D;
			int m = i; // B::i hides A::i
			int n = j; // D::j hides B::j
		}
	}

# 10.3.4 [namespace.udir] 5

positive: use of additional members of extended namespace nominated by using directive

	namespace n {}
	using namespace n;
	namespace n {int x;}
	int y = x;

# todo: 10.3.4 [namespace.udir] 6
# todo: 10.3.4 [namespace.udir] 7

# 10.6.1 [dcl.attr.grammar] 1

positive: single attribute specifier

	int x [[]];

positive: multiple attribute specifiers

	int x [[]][[]][[]];

negative: nested attribute specifiers

	int [[[[]]]]

positive: attribute specifier

	int x [[]] alignas (int) [[]];

positive: attribute specifier with spaces

	int x [ [ ] ];

negative: attribute specifier with single brackets

	[] int x;

positive: attribute specifier with double brackets

	[[]] int x;

negative: attribute specifier with triple brackets

	[[[]]] int x;

negative: attribute specifier missing opening brackets

	int x [[;

negative: attribute specifier missing closing brackets

	int x ]];

negative: alignment specifier missing alignas keyword

	int x (int) = 0;

negative: alignment specifier missing opening parenthesis

	int x alignas int);

negative: alignment specifier missing closing parenthesis

	int x alignas (int;

negative: alignment specifier missing parentheses

	int x alignas int;

positive: alignment specifier with type

	int x alignas (int);

positive: alignment specifier with expression

	int x alignas (6 - 5) alignas (int);

negative: alignment specifier missing argument

	int x alignas ();

positive: attribute using prefix

	int x [[using prefix:]];

negative: attribute using prefix missing using keyword

	int x [[prefix:]];

negative: attribute using prefix missing namespace identifier

	int x [[using :]];

negative: attribute using prefix missing colon

	int x [[using prefix]];

positive: empty attribute list

	int x [[]];

positive: empty attribute list with using prefix

	int x [[using prefix:]];

positive: attribute list with omitted attributes

	int x [[,,]];

positive: attribute list with using prefix and omitted attributes

	int x [[using prefix: ,,]];

negative: scoped attribute missing namespace identifier

	int x [[::a]];

negative: scoped attribute missing double colon

	int x [[n a]];

negative: scoped attribute missing identifier

	int x [[n::]];

positive: unscoped attribute token

	int x [[a]];

positive: empty attribute argument clause

	int x [[a ()]];

negative: attribute argument clause missing opening parenthesis

	int x [[a )]];

negative: attribute argument clause missing closing parenthesis

	int x [[a (]];

negative: attribute argument clause missing closing parentheses

	int x [[a b]];

positive: balanced token sequence with parentheses

	int x [[a (())]];

negative: balanced token sequence missing opening parenthesis

	int x [[a ())]];

negative: balanced token sequence missing closing parenthesis

	int x [[a (()]];

positive: balanced token sequence with brackets

	int x [[a ([])]];

negative: balanced token sequence missing opening bracket

	int x [[a (])]];

negative: balanced token sequence missing closing bracket

	int x [[a ([)]];

positive: balanced token sequence with braces

	int x [[a ({})]];

negative: balanced token sequence missing opening brace

	int x [[a (})]];

negative: balanced token sequence missing closing brace

	int x [[a ({)]];

positive: balanced token sequences

	int x [[a (x y z)]];

positive: nested balanced token sequences

	int x [[a (([{}])[{()}]{([])})]];

# 10.6.1 [dcl.attr.grammar] 2

positive: scoped attribute without using prefix

	int x [[n::a]];

negative: scoped attribute with using prefix

	int x [[using n: n::a]];

positive: attribute using prefix example a

	[[using CC: opt(1), debug]] // same as [[CC::opt(1), CC::debug]]
	void f() {}
	[[using CC: opt(1)]] [[CC::debug]] // same as [[CC::opt(1)]] [[CC::debug]]
	void h() {}

negative: attribute using prefix example b

	[[using CC: CC::opt(1)]] error: cannot combine using and scoped attribute token
	void h() {}

# 10.6.1 [dcl.attr.grammar] 4

negative: unspecified attribute as pack expansion

	int x [[a...]];

negative: unspecified attributes as pack expansion

	int x [[a...,b...]];

negative: carries_dependency attribute as pack expansion

	int f [[carries_dependency...]] ();

negative: deprecated attribute as pack expansion

	int x [[deprecated...]];

negative: fallthrough attribute as pack expansion

	void f () {switch (0) {[[fallthrough...]]; default: ;}}

negative: maybe_unused attribute as pack expansion

	int f [[maybe_unused...]] ();

negative: noreturn attribute as pack expansion

	int f [[noreturn...]] ();

positive: empty attribute specifier with no effect

	int [[]] x;

positive: insignificant order of attribute tokens

	int f [[deprecated, noreturn]] ();
	int f [[noreturn, deprecated]] ();

positive: keyword as attribute token

	int x [[alignas]][[alignof]][[asm]][[auto]][[bool]][[break]][[case]][[catch]][[char]][[char8_t]][[char16_t]][[char32_t]][[class]][[concept]][[const]][[consteval]][[constexpr]][[constinit]][[const_cast]][[continue]][[co_await]]
		[[co_return]][[co_yield]][[decltype]][[default]][[delete]][[do]][[double]][[dynamic_cast]][[else]][[enum]][[explicit]][[export]][[extern]][[false]][[float]][[for]][[friend]][[goto]][[if]][[inline]][[int]][[long]][[mutable]]
		[[namespace]][[new]][[noexcept]][[nullptr]][[operator]][[private]][[protected]][[public]][[register]][[reinterpret_cast]][[requires]][[return]][[short]][[signed]][[sizeof]][[static]][[static_assert]]
		[[static_cast]][[struct]][[switch]][[template]][[this]][[thread_local]][[throw]][[true]][[try]][[typedef]][[typeid]][[typename]][[union]][[unsigned]][[namespace::using]][[virtual]][[void]][[volatile]][[wchar_t]][[while]];

positive: alternative token as attribute token

	int x [[and]][[andeq]][[bitand]][[bitor]][[compl]][[not]][[noteq]][[or]][[oreq]][[xor]][[xoreq]];

positive: no name lookup for attribute token

	int main ();
	int x [[unknown,main,unknown::unknown,main::unknown]];

# todo: 10.6.1 [dcl.attr.grammar] 5

# 10.6.1 [dcl.attr.grammar] 6

positive: ingoring unspecified unscoped attribute

	int x [[unspecified]];

positive: ingoring unspecified scoped attribute

	int x [[namespace::unspecified]];

# 10.6.1 [dcl.attr.grammar] 7

positive: consecutive left brackets in attribute specifier

	int x [ [ ] ];

negative: consecutive left brackets in subscript expression

	int x[10], y = x[[] () {return 0;} ()];

positive: consecutive left brackets in balanced token sequence

	int x [[a ([[]])]];

negative: consecutive left brackets example a

	int p[10];
	void f() {
		int x = 42, y[5];
		int(p[[x] { return x; }()]); // error: invalid attribute on a nested declarator-id and not a function-style cast of an element of p.
	}

negative: consecutive left brackets example b

	void f() {
		y[[] { return 2; }()] = 2; // error even though attributes are not allowed in this context.
	}

# 10.6.2 [dcl.align] 1

positive: alignment specifier applied to variable

	char x alignas (char);

positive: alignment specifier applied to local variable

	void f () {char x alignas (char);}

positive: alignment specifier applied to static data member

	struct C {static int m alignas (int);};

positive: alignment specifier applied to non-static data member

	struct C {int m alignas (int);};

negative: alignment specifier applied to bit-field

	struct C {int m alignas (int) : 1;};

negative: alignment specifier applied to unnamed bit-field

	struct C {alignas (int) int : 1;};

negative: alignment specifier applied to function

	void f alignas (int) ();

negative: alignment specifier applied to function parameter

	void f (char x alignas (char));

negative: alignment specifier applied to namespace

	namespace alignas (int) n {};

# todo: exception declaration

positive: alignment specifier applied to class declaration

	class alignas (int) c;

positive: alignment specifier applied to unnamed class declaration

	class alignas (int) {} c;

positive: alignment specifier applied to class definition

	class alignas (int) c {};

positive: alignment specifier applied to enumeration declaration

	enum alignas (int) e : int;

positive: alignment specifier applied to unnamed enumeration declaration

	enum alignas (int) {} e;

positive: alignment specifier applied to enumeration definition

	enum alignas (int) e {};

negative: alignment specifier applied to enumerator

	enum {e alignas (int)};

negative: alignment specifier applied to typedef name

	typedef char t alignas (char);

negative: alignment specifier applied to type

	using t = char alignas (char);

# todo: pack expansion

# 10.6.2 [dcl.align] 2

positive: alignment specifier with integral constant expression

	char x alignas (8);

negative: alignment specifier with non-integral constant expression

	char x alignas (nullptr);

negative: alignment specifier with integral non-constant expression

	char x, y alignas (x);

positive: alignment specifier with fundamental alignment

	char x alignas (alignof (int));

negative: alignment specifier with zero alignment

	char x alignas (0) alignas (char);

negative: alignment specifier with non-power-of-two alignment

	char x alignas (3) alignas (char);

negative: alignment specifier with negative alignment

	char x alignas (-1) alignas (char);

# 10.6.2 [dcl.align] 3

positive: alignment specifier with complete type

	extern char x alignas (bool);
	extern char x alignas (char);
	extern char x alignas (char);
	extern char x alignas (char&);
	extern char x alignas (char&&);
	extern char x alignas (char[10]);
	extern char x alignas (char16_t);
	extern char x alignas (char32_t);
	extern char x alignas (wchar_t);
	extern char x alignas (short int);
	extern char x alignas (unsigned short int);
	extern char x alignas (int);
	extern char x alignas (unsigned int);
	extern char x alignas (long int);
	extern char x alignas (unsigned long int);
	extern char x alignas (long long int);
	extern char x alignas (unsigned long long int);
	extern char x alignas (float);
	extern char x alignas (double);
	extern char x alignas (long double);
	extern char x alignas (decltype (nullptr));
	extern char x alignas (int[10]);
	extern char x alignas (void*);
# todo:	extern char x alignas (void(*)());

# todo: pointer to member types

negative: alignment specifier with void

	char x alignas (void);

positive: alignment specifier with complete class

	class c {};
	char x alignas (c);

negative: alignment specifier with incomplete class

	char x alignas (class c);

positive: alignment specifier with complete enumeration

	enum e {};
	char x alignas (e);

negative: alignment specifier with incomplete enumeration

	enum e {a = alignof (e)};

negative: alignment specifier with function type

	char x alignas (void ());

positive: alignment specifier with array with complete element type

	char x alignas (int[10]);

negative: alignment specifier with array with incomplete element type

	char x alignas (class c[10]);

negative: alignment specifier with array of unknown bound

	char x alignas (int[]);

positive: alignment specifier with complete lvalue reference types

	extern char x alignas (bool&);
	extern char x alignas (char&);
	extern char x alignas (char16_t&);
	extern char x alignas (char32_t&);
	extern char x alignas (wchar_t&);
	extern char x alignas (short int&);
	extern char x alignas (unsigned short int&);
	extern char x alignas (int&);
	extern char x alignas (unsigned int&);
	extern char x alignas (long int&);
	extern char x alignas (unsigned long int&);
	extern char x alignas (long long int&);
	extern char x alignas (unsigned long long int&);
	extern char x alignas (float&);
	extern char x alignas (double&);
	extern char x alignas (long double&);
	extern char x alignas (decltype (nullptr)&);
# todo:	extern char x alignas (int(&)[10]);
# todo:	extern char x alignas (void*&);
# todo:	extern char x alignas (void(*&)());

positive: alignment specifier with complete reference types

	extern char x alignas (bool&&);
	extern char x alignas (char&&);
	extern char x alignas (char16_t&&);
	extern char x alignas (char32_t&&);
	extern char x alignas (wchar_t&&);
	extern char x alignas (short int&&);
	extern char x alignas (unsigned short int&&);
	extern char x alignas (int&&);
	extern char x alignas (unsigned int&&);
	extern char x alignas (long int&&);
	extern char x alignas (unsigned long int&&);
	extern char x alignas (long long int&&);
	extern char x alignas (unsigned long long int&&);
	extern char x alignas (float&&);
	extern char x alignas (double&&);
	extern char x alignas (long double&&);
	extern char x alignas (decltype (nullptr)&&);
# todo:	extern char x alignas (int(&&)[10]);
# todo:	extern char x alignas (void*&&);
# todo:	extern char x alignas (void(*&&)());

negative: alignment specifier with incomplete reference type

	char x alignas (class c&);

# 10.6.2 [dcl.align] 4

positive: multiple alignment specifiers

	char x alignas (int) alignas (alignof (double)) alignas (char);

positive: strictest alignment specifiers

	#include <cstddef>

	class alignas (char) alignas (int) alignas (std::max_align_t) c {};

	static_assert (alignof (c) == alignof (std::max_align_t));

# 10.6.2 [dcl.align] 5

negative: less strict alignment specifier

	#include <cstddef>

	std::max_align_t x alignas (1);
	static_assert (alignof (std::max_align_t) > 1);

negative: less strict alignment specifier example

	struct alignas(8) S {};
	struct alignas(1) U {
		S s;
	}; // error: U specifies an alignment that is less strict than if the alignas(1) were omitted.

# todo: 10.6.2 [dcl.align] 6
# todo: 10.6.2 [dcl.align] 7
# todo: 10.6.2 [dcl.align] 8

# 10.6.3 [dcl.attr.depend] 1

positive: multiple carries_dependency attributes in different attribute specifier sequences

	[[carries_dependency]] void f [[carries_dependency]] ();

positive: multiple carries_dependency attributes in different attribute lists

	void f [[carries_dependency]] [[carries_dependency]] ();

negative: multiple carries_dependency attributes in same attribute list

	void f [[carries_dependency, carries_dependency]] ();

positive: carries_dependency attribute without argument

	void f [[carries_dependency]] ();

negative: carries_dependency attribute with argument

	void f [[carries_dependency ()]] ();

positive: carries_dependency attribute applied to function declaration

	void f [[carries_dependency]] ();

positive: carries_dependency attribute applied to function definition

	void f [[carries_dependency]] () {}

negative: carries_dependency applied to namespace

	namespace [[carries_dependency]] {}

negative: carries_dependency attribute applied to type

	using t [[carries_dependency]] = int;

negative: carries_dependency attribute applied to class

	class [[carries_dependency]] c;

negative: carries_dependency attribute applied to enumeration

	enum [[carries_dependency]] e : int;

negative: carries_dependency attribute applied to enumerator

	enum {e [[carries_dependency]]};

negative: carries_dependency attribute applied to variable

	int x [[carries_dependency]];

positive: carries_dependency attribute applied to parameter

	void f ([[carries_dependency]] int x);
	void f (int x [[carries_dependency]]);

negative: carries_dependency attribute applied to parameter of function type declaration

	using t = void ([[carries_dependency]] int);

# todo: positive: carries_dependency attribute applied to lambda parameter

negative: carries_dependency attribute applied to statement;

	void f () {[[carries_dependency]];}

# 10.6.3 [dcl.attr.depend] 2

positive: carries_dependency attribute in all declarations of a function

	void f [[carries_dependency]] ();
	void f [[carries_dependency]] ();

positive: carries_dependency attribute in first declaration of a function

	void f [[carries_dependency]] ();
	void f ();

negative: carries_dependency attribute in second declaration of a function

	void f ();
	void f [[carries_dependency]] ();

positive: carries_dependency attribute in all declarations of a parameter

	void f ([[carries_dependency]] int);
	void f ([[carries_dependency]] int);

positive: carries_dependency attribute in first declaration of a parameter

	void f ([[carries_dependency]] int);
	void f (int);

negative: carries_dependency attribute in second declaration of a parameter

	void f (int);
	void f ([[carries_dependency]] int);

# todo: 10.6.3 [dcl.attr.depend] 4

# 10.6.4 [dcl.attr.deprecated] 1

positive: deprecated attribute at start of declaration

	[[deprecated]] int x;

positive: deprecated attribute after declaration identifier

	int x [[deprecated]];

positive: multiple deprecated attributes in different attribute specifier sequences

	[[deprecated]] int x [[deprecated]];

positive: multiple deprecated attributes in different attribute lists

	int x [[deprecated]] [[deprecated]];

negative: multiple deprecated attributes in same attribute list

	int x [[deprecated, deprecated]];

positive: deprecated attribute without argument

	int x [[deprecated]] ();

positive: deprecated attribute with argument

	int x [[deprecated ("")]];

negative: deprecated attribute with argument missing opening parenthesis

	int x [[deprecated "")]];

negative: deprecated attribute with argument missing string literal

	int x [[deprecated ()]];

negative: deprecated attribute with argument missing closing parenthesis

	int x [[deprecated (""]];

negative: deprecated attribute with argument missing parentheses

	int x [[deprecated ""]];

# 10.6.4 [dcl.attr.deprecated] 2

positive: deprecated attribute applied to class declaration

	class [[deprecated]] c;

positive: deprecated attribute applied to unnamed class declaration

	class [[deprecated]] {} c;

positive: deprecated attribute applied to typedef name

	typedef int t [[deprecated]];
	[[deprecated]] typedef int t;

# todo: data member

positive: deprecated attribute applied to function declaration

	void f [[deprecated]] ();

positive: deprecated attribute applied to namespace declaration

	namespace [[deprecated]] n {}

positive: deprecated attribute applied to unnamed namespace declaration

	namespace [[deprecated]] {}

positive: deprecated attribute applied to enumeration declaration

	enum [[deprecated]] c : int;

positive: deprecated attribute applied to unnamed enumeration declaration

	enum [[deprecated]] {} e;

positive: deprecated attribute applied to enumerator declaration

	enum {e [[deprecated]]};

# todo: template specialization

negative: deprecated attribute applied to statement

	void f () {[[deprecated]];}

# 10.6.4 [dcl.attr.deprecated] 3

positive: deprecated attribute in all declarations

	void f [[deprecated]] ();
	void f [[deprecated]] ();

positive: deprecated attribute in first declaration

	void f [[deprecated]] ();
	void f ();

positive: deprecated attribute in second declaration

	void f ();
	void f [[deprecated]] ();

positive: deprecated attribute redeclared with different arguments

	void f [[deprecated]] ();
	void f [[deprecated ("")]] ();
	void f [[deprecated ("deprecated")]] ();
	void f [[deprecated ("obsolete")]] ();
	void f [[deprecated ("")]] ();
	void f [[deprecated]] ();

# 10.6.5 [dcl.attr.fallthrough] 1

negative: fallthrough attribute applied to function declaration

	void f [[fallthrough]] ();

negative: fallthrough applied to namespace

	namespace [[fallthrough]] {}

negative: fallthrough attribute applied to type

	using t [[fallthrough]] = int;

negative: fallthrough attribute applied to class

	class [[fallthrough]] c;

negative: fallthrough attribute applied to enumeration

	enum [[fallthrough]] e : int;

negative: fallthrough attribute applied to enumerator

	enum {e [[fallthrough]]};

negative: fallthrough attribute applied to variable

	int x [[fallthrough]];

negative: fallthrough attribute applied to parameter

	void f ([[fallthrough]] int);

# todo: negative: fallthrough attribute applied to lambda parameter

negative: fallthrough attribute applied to labeled statement

	void f () {[[fallthrough]] label: ;}

negative: fallthrough attribute applied to case statement

	void f () {switch (0) [[fallthrough]] case 0: ;}

negative: fallthrough attribute applied to default statement

	void f () {switch (0) [[fallthrough]] default: ;}

negative: fallthrough attribute applied to expression statement

	void f () {[[fallthrough]] 0;}

positive: fallthrough attribute applied to null statement

	void f () {switch (0) {[[fallthrough]]; default: ;}}

negative: fallthrough attribute applied to compound statement

	void f () {[[fallthrough]] {} }

negative: fallthrough attribute applied to if statement

	void f () {[[fallthrough]] if (false) ;}

negative: fallthrough attribute applied to switch statement

	void f () {[[fallthrough]] switch (0) ;}

negative: fallthrough attribute applied to while statement

	void f () {[[fallthrough]] while (false) ;}

negative: fallthrough attribute applied to do statement

	void f () {[[fallthrough]] do ; while (false);}

negative: fallthrough attribute applied to for statement

	void f () {[[fallthrough]] for (;;) ;}

negative: fallthrough attribute applied to break statement

	void f () {while (true) [[fallthrough]] break;}

negative: fallthrough attribute applied to continue statement

	void f () {while (true) [[fallthrough]] continue;}

negative: fallthrough attribute applied to return statement

	void f () {[[fallthrough]] return;}

negative: fallthrough attribute applied to goto statement

	void f () {label: [[fallthrough]] goto label;}

negative: fallthrough attribute applied to declaration statement

	void f () {[[fallthrough]] void g ();}

positive: multiple fallthrough attributes in different attribute lists

	void f () {switch (0) {[[fallthrough]] [[fallthrough]]; default: ;}}

negative: multiple fallthrough attributes in same attribute list

	void f () {switch (0) {[[fallthrough, fallthrough]]; default: ;}}

positive: fallthrough attribute without argument

	void f () {switch (0) {[[fallthrough]]; default: ;}}

negative: fallthrough attribute with argument

	void f () {switch (0) {[[fallthrough ()]]; default: ;}}

positive: fallthrough statement inside switch statement

	void f () {switch (0) {[[fallthrough]]; default: ;}}

negative: fallthrough statement outside switch statement

	void f () {[[fallthrough]];}}

negative: fallthrough statement followed by labeled statement

	void f () {switch (0) {[[fallthrough]]; label: ;}}

positive: fallthrough statement followed by case statement

	void f () {switch (0) {[[fallthrough]]; case 0: ;}}

negative: fallthrough statement followed by case statement from different switch statement

	void f () {switch (0) {switch (0) [[fallthrough]]; case 0: ;}}

positive: fallthrough statement followed by default statement

	void f () {switch (0) {[[fallthrough]]; default: ;}}

negative: fallthrough statement followed by default statement from different switch statement

	void f () {switch (0) {switch (0) [[fallthrough]]; default: ;}}

negative: fallthrough statement followed by expression statement

	void f () {switch (0) {[[fallthrough]]; 0;}}

negative: fallthrough statement followed by null statement

	void f () {switch (0) {[[fallthrough]]; ;}}

negative: fallthrough statement followed by compound statement

	void f () {switch (0) {[[fallthrough]]; {} }}

negative: fallthrough statement followed by if statement

	void f () {switch (0) {[[fallthrough]]; if (false) ;}}

negative: ffallthrough statement followed by switch statement

	void f () {switch (0) {[[fallthrough]]; switch (0) ;}}

negative: fallthrough statement followed by while statement

	void f () {switch (0) {[[fallthrough]]; while (false) ;}}

negative: fallthrough statement followed by do statement

	void f () {switch (0) {[[fallthrough]]; do ; while (false);}}

negative: fallthrough statement followed by for statement

	void f () {switch (0) {[[fallthrough]]; for (;;) ;}}

negative: fallthrough statement followed by break statement

	void f () {switch (0) {[[fallthrough]]; break;}}

negative: fallthrough statement followed by continue statement

	void f () {switch (0) {while (true) [[fallthrough]]; continue;}}

negative: fallthrough statement followed by return statement

	void f () {switch (0) {[[fallthrough]]; return;}}

negative: fallthrough statement followed by no statement

	void f () {switch (0) [[fallthrough]];}

# 10.6.5 [dcl.attr.fallthrough] 3

positive: fallthrough statement example a

	void f(int n) {
		void g(), h(), i();
		switch (n) {
		case 1:
		case 2:
			g();
			[[fallthrough]];
		case 3: // warning on fallthrough discouraged
			h();
		case 4: // implementation may warn on fallthrough
			i();
		}
	}

negative: fallthrough statement example b

	void f(int n) {
		void g(), h(), i();
		switch (n) {
		case 4:
			[[fallthrough]]; // ill-formed
		}
	}

# 10.6.6 [dcl.attr.unused] 1

positive: maybe_unused attribute at start of declaration

	[[maybe_unused]] int x;

positive: maybe_unused attribute after declaration identifier

	int x [[maybe_unused]];

positive: multiple maybe_unused attributes in different attribute specifier sequences

	[[maybe_unused]] int x [[maybe_unused]];

positive: multiple maybe_unused attributes in different attribute lists

	int x [[maybe_unused]] [[maybe_unused]];

negative: multiple maybe_unused attributes in same attribute list

	int x [[maybe_unused, maybe_unused]];

positive: maybe_unused attribute without argument

	int x [[maybe_unused]];

negative: maybe_unused attribute with argument

	int x [[maybe_unused ()]];

# 10.6.6 [dcl.attr.unused] 2

positive: maybe_unused attribute applied to class declaration

	class [[maybe_unused]] c;

positive: maybe_unused attribute applied to unnamed class declaration

	class [[maybe_unused]] {} c;

positive: maybe_unused attribute applied to type definition

	typedef int t [[maybe_unused]];
	using t [[maybe_unused]] = int;

positive: maybe_unused attribute applied to function declaration

	void f [[maybe_unused]] ();

positive: maybe_unused attribute applied to variable

	int x [[maybe_unused]];

negative: maybe_unused attribute applied to static data member

	class c {static int x [[maybe_unused]];};

positive: maybe_unused attribute applied to non-static data member

	class c {int x [[maybe_unused]];};

positive: maybe_unused attribute applied to function

	void f [[maybe_unused]] ();

positive: maybe_unused attribute applied to member function

	class c {void f [[maybe_unused]] ();};

positive: maybe_unused attribute applied to static member function

	class c {static void f [[maybe_unused]] ();};

negative: maybe_unused attribute applied to namespace

	namespace [[maybe_unused]] {}

positive: maybe_unused attribute applied to enumeration

	enum [[maybe_unused]] e : int;

positive: maybe_unused attribute applied to unnamed enumeration

	enum [[maybe_unused]] {} e;

positive: maybe_unused attribute applied to enumerator

	enum {e [[maybe_unused]]};

positive: maybe_unused attribute applied to parameter

	void f (int x [[maybe_unused]]);

positive: maybe_unused attribute applied to unnamed parameter

	void f ([[maybe_unused]] int);

negative: maybe_unused attribute applied to statement

	void f () {[[maybe_unused]];}

# 10.6.6 [dcl.attr.unused] 4

positive: maybe_unused attribute in all declarations of a function

	void f [[maybe_unused]] ();
	void f [[maybe_unused]] ();

positive: maybe_unused attribute in first declaration of a function

	void f [[maybe_unused]] ();
	void f ();

positive: maybe_unused attribute in second declaration of a function

	void f ();
	void f [[maybe_unused]] ();

positive: maybe_unused attribute in all declarations of a variable

	extern int x [[maybe_unused]];
	extern int x [[maybe_unused]];

positive: maybe_unused attribute in first declaration of a variable

	extern int x [[maybe_unused]];
	extern int x;

positive: maybe_unused attribute in second declaration of a variable

	extern int x;
	extern int x [[maybe_unused]];

# 10.6.6 [dcl.attr.unused] 5

positive: maybe_unused attribute example a

	#define NDEBUG
	#include <cassert>

	[[maybe_unused]] void f([[maybe_unused]] bool thing1,
			[[maybe_unused]] bool thing2) {
		[[maybe_unused]] bool b = thing1 && thing2;
		assert(b);
	}

positive: maybe_unused attribute example b

	#undef NDEBUG
	#include <cassert>

	[[maybe_unused]] void f([[maybe_unused]] bool thing1,
			[[maybe_unused]] bool thing2) {
		[[maybe_unused]] bool b = thing1 && thing2;
		assert(b);
	}

# 10.6.7 [dcl.attr.nodiscard] 1

positive: nodiscard attribute applied to function declaration

	void f [[nodiscard]] ();

positive: nodiscard attribute applied to function definition

	void f [[nodiscard]] () {}

negative: nodiscard attribute applied to function type declaration

	typedef void f [[nodiscard]] ();

negative: nodiscard attribute applied to namespace

	namespace [[nodiscard]] {}

negative: nodiscard attribute applied to type

	using t [[nodiscard]] = int;

positive: nodiscard attribute applied to class declaration

	class [[nodiscard]] c;

positive: nodiscard attribute applied to unnamed class declaration

	class [[nodiscard]] {} c;

positive: nodiscard attribute applied to enumeration declaration

	enum [[nodiscard]] e : int;

positive: nodiscard attribute applied to unnamed enumeration declaration

	enum [[nodiscard]] {} e;

negative: nodiscard attribute applied to enumerator

	enum {e [[nodiscard]]};

negative: nodiscard attribute applied to variable

	int x [[nodiscard]];

negative: nodiscard attribute applied to parameter

	void f (int x [[nodiscard]]);

negative: nodiscard attribute applied to statement

	void f () {[[nodiscard]];}

positive: nodiscard attribute at start of declaration

	[[nodiscard]] void f ();

positive: nodiscard attribute after declaration identifier

	void f [[nodiscard]] ();

positive: multiple nodiscard attributes in different attribute specifier sequences

	[[nodiscard]] void f [[nodiscard]] ();

positive: multiple nodiscard attributes in different attribute lists

	void f [[nodiscard]] [[nodiscard]] ();

negative: multiple nodiscard attributes in same attribute list

	void f [[nodiscard, nodiscard]] ();

positive: nodiscard attribute without argument

	void f [[nodiscard]] ();

negative: nodiscard attribute with argument

	void f [[nodiscard ()]] ();

positive: nodiscard attribute in all declarations of a function

	void f [[nodiscard]] ();
	void f [[nodiscard]] ();

positive: nodiscard attribute in first declaration of a function

	void f [[nodiscard]] ();
	void f ();

positive: nodiscard attribute in second declaration of a function

	void f ();
	void f [[nodiscard]] ();

positive: nodiscard attribute in all declarations of a class

	class [[nodiscard]] c;
	class [[nodiscard]] c;

positive: nodiscard attribute in first declaration of a class

	class [[nodiscard]] c;
	class c;

positive: nodiscard attribute in second declaration of a class

	class c;
	class [[nodiscard]] c;

positive: nodiscard attribute in all declarations of an enumeration

	enum [[nodiscard]] e : int;
	enum [[nodiscard]] e : int;

positive: nodiscard attribute in first declaration of an enumeration

	enum [[nodiscard]] e : int;
	enum e : int;

positive: nodiscard attribute in second declaration of an enumeration

	enum e : int;
	enum [[nodiscard]] e : int;

# 10.6.7 [dcl.attr.nodiscard] 3

positive: nodiscard attribute example

	struct [[nodiscard]] error_info { /* ... */ };
	error_info enable_missile_safety_mode();
	void launch_missiles();
	void test_missiles() {
		enable_missile_safety_mode(); // warning encouraged
		launch_missiles();
	}
	error_info &foo();
	void f() { foo(); } // warning not encouraged: not a nodiscard call, because neither
		// the (reference) return type nor the function is declared nodiscard

# 10.6.8 [dcl.attr.noreturn] 1

positive: noreturn attribute at start of declaration

	[[noreturn]] void f ();

positive: noreturn attribute after declaration identifier

	void f [[noreturn]] ();

positive: multiple noreturn attributes in different attribute specifier sequences

	[[noreturn]] void f [[noreturn]] ();

positive: multiple noreturn attributes in different attribute lists

	void f [[noreturn]] [[noreturn]] ();

negative: multiple noreturn attributes in same attribute list

	void f [[noreturn, noreturn]] ();

positive: noreturn attribute without argument

	void f [[noreturn]] ();

negative: noreturn attribute with argument

	void f [[noreturn ()]] ();

positive: noreturn attribute applied to function declaration

	void f [[noreturn]] ();

positive: noreturn attribute applied to function definition

	void f [[noreturn]] () {}

negative: noreturn attribute applied to function type declaration

	typedef void f [[noreturn]] ();

negative: noreturn attribute applied to namespace

	namespace [[noreturn]] {}

negative: noreturn attribute applied to type

	using t [[noreturn]] = int;

negative: noreturn attribute applied to class

	class [[noreturn]] c;

negative: noreturn attribute applied to enumeration

	enum [[noreturn]] e : int;

negative: noreturn attribute applied to enumerator

	enum {e [[noreturn]]};

negative: noreturn attribute applied to variable

	int x [[noreturn]];

negative: noreturn attribute applied to parameter

	void f (int x [[noreturn]]);

negative: noreturn attribute applied to statement

	void f () {[[noreturn]];}

positive: noreturn attribute in all declarations of a function

	void f [[noreturn]] ();
	void f [[noreturn]] ();

positive: noreturn attribute in first declaration of a function

	void f [[noreturn]] ();
	void f ();

negative: noreturn attribute in second declaration of a function

	void f ();
	void f [[noreturn]] ();

# 10.6.8 [dcl.attr.noreturn] 3

positive: noreturn attribute example

	[[ noreturn ]] void f() {
		throw "error"; // OK
	}

	[[ noreturn ]] void q(int i) { // behavior is undefined if called with an argument <= 0
		if (i > 0)
			throw "positive";
	}

# 11.1 [dcl.name] 1

negative: type identifier missing type specifier sequence

	using t = *;

positive: type identifier missing abstract declarator

	using t = int;

positive: type identifier with abstract pointer declarator

	using t = int*;

positive: type identifier with parenthesized abstract pointer declarator

	using t = int(*);

negative: type identifier with parenthesized abstract pointer declarator missing opening parenthesis

	using t = int*);

negative: type identifier with parenthesized abstract pointer declarator missing closing parenthesis

	using t = int(*;

positive: type identifier with abstract lvalue reference declarator

	using t = int&;

positive: type identifier with parenthesized abstract lvalue reference declarator

	using t = int(&);

negative: type identifier with parenthesized abstract lvalue reference declarator missing opening parenthesis

	using t = int&);

negative: type identifier with parenthesized abstract lvalue reference declarator missing closing parenthesis

	using t = int(&;

positive: type identifier with abstract rvalue reference declarator

	using t = int&&;

positive: type identifier with parenthesized abstract rvalue reference declarator

	using t = int(&&);

negative: type identifier with parenthesized abstract rvalue reference declarator missing opening parenthesis

	using t = int&&);

negative: type identifier with parenthesized abstract rvalue reference declarator missing closing parenthesis

	using t = int(&&;

positive: type identifier with abstract array declarator

	using t = int[];

negative: type identifier with abstract array declarator missing opening brackets

	using t = int];

negative: type identifier with abstract array declarator missing closing brackets

	using t = int[;

positive: type identifier with abstract function declarator

	using t = int ();

negative: type identifier with abstract function declarator missing opening parenthesis

	using t = int (;

negative: type identifier with abstract function declarator missing closing parenthesis

	using t = int );

positive: type identifier with parenthesized abstract function declarator

	using t = int (());

negative: type identifier with parenthesized abstract function declarator missing opening parenthesis

	using t = int ());

negative: type identifier with parenthesized abstract function declarator missing closing parenthesis

	using t = int (();

positive: type identifier with abstract function declarator and trailing return type

	using t = auto () -> int;

negative: type identifier with abstract function declarator and trailing return type missing arrow

	using t = auto () int;

negative: type identifier with abstract function declarator and trailing return type missing type identifier

	using t = auto () ->;

negative: type identifier with parenthesized abstract function declarator and trailing return type

	using t = auto (() -> int);

negative: type identifier with nested abstract function declarator and trailing return type

	using t = auto () -> int -> ();

negative: type identifier with named declarator

	using t = int x;

negative: type identifier with parenthesized named declarator

	using t = int (x);

positive: abstract declarator example

	using ti = int;
	using tpi = int *;
	using tp = int *[3];
	using tp3i = int (*)[3];
	using tf = int *();
	using tpf = int (*)(double);

	int i;
	int *pi;
	int *p[3];
	int (*p3i)[3];
	int *f();
	int (*pf)(double);

	extern ti i;
	extern tpi pi;
	extern tp p;
	extern tp3i p3i;
	extern tf f;
	extern tpf pf;

# 11.3.1 [dcl.ptr] 1

positive: pointer declarator with attributes

	int* [[]] x;

positive: pointer declarator with const qualifier

	int* const x;

negative: pointer declarator with const qualifiers

	int* const const x;

positive: pointer declarator with volatile qualifier

	int* volatile x;

negative: pointer declarator with volatile qualifiers

	int* volatile volatile x;

positive: pointer declarator with const volatile qualifiers

	int* const volatile x;

negative: pointer declarator with const volatile qualifiers followed by attributes

	int * const volatile [[]] x;

positive: pointer declarator with volatile const qualifiers

	int* volatile const x;

positive: pointer declarator with attributes followed by const volatile qualifiers

	int* [[]] const volatile x;

# 11.3.1 [dcl.ptr] 2

positive: correct operations on pointer example

	const int ci = 10, *pc = &ci, *const cpc = pc, **ppc;
	int i, *p, *const cp = &i;

	void f ()
	{
		i = ci;
		*cp = ci;
		pc++;
		pc = cpc;
		pc = p;
		ppc = &pc;
	}

negative: ill-formed operations on pointer example a

	const int ci = 10;

	void f ()
	{
		ci = 1; // error
	}

negative: ill-formed operations on pointer example b

	const int ci = 10;

	void f ()
	{
		ci++; // error
	}

negative: ill-formed operations on pointer example c

	const int ci = 10, *pc = &ci;

	void f ()
	{
		*pc = 2; // error
	}

negative: ill-formed operations on pointer example d

	const int ci = 10;
	int i, *const cp = &i;

	void f ()
	{
		cp = &ci; // error
	}

negative: ill-formed operations on pointer example e

	const int ci = 10, *pc = &ci, *const cpc = pc;

	void f ()
	{
		cpc++; // error
	}

negative: ill-formed operations on pointer example f

	const int ci = 10, *pc = &ci;
	int *p;

	void f ()
	{
		p = pc; // error
	}

negative: ill-formed operations on pointer example g

	const int **ppc;
	int *p;

	void f ()
	{
		ppc = &p; // error
	}

# todo: clobber example

# 11.3.1 [dcl.ptr] 4

negative: forming a pointer to a lvalue reference type

	using t = int&*;

negative: forming a pointer to a rvalue reference type

	using t = int&&*;

positive: forming a function pointer type without qualifiers

	using t = void (*) ();

negative: forming a function pointer type with const qualifier

	using t = void (*) () const;

negative: forming a function pointer type with volatile qualifier

	using t = void (*) () volatile;

negative: forming a function pointer type with lvalue reference qualifier

	using t = void (*) () &;

negative: forming a function pointer type with rvalue reference qualifier

	using t = void (*) () &&;

# 11.3.2 [dcl.ref] 1

positive: lvalue reference declarator

	extern int& x;

positive: lvalue reference declarator with attributes

	extern int& [[]] x;

negative: lvalue reference declarator with attributes followed by const qualifier

	extern int& [[]] const x;

negative: lvalue reference declarator with attributes followed by volatile qualifier

	extern int& [[]] volatile x;

negative: lvalue reference declarator with const qualifier

	extern int& const;

negative: lvalue reference declarator with volatile qualifier

	extern int& volatile;

negative: lvalue reference declarator with const qualifier followed by attributes

	extern int& const [[]] x;

negative: lvalue reference declarator with volatile qualifier followed by attributes

	extern int& volatile [[]] x;

positive: rvalue reference declarator

	extern int&& x;

positive: rvalue reference declarator with attributes

	extern int&& [[]] x;

negative: rvalue reference declarator with attributes followed by const qualifier

	extern int&& [[]] const x;

negative: rvalue reference declarator with attributes followed by volatile qualifier

	extern int&& [[]] volatile x;

negative: rvalue reference declarator with const qualifier

	extern int&& const;

negative: rvalue reference declarator with volatile qualifier

	extern int&& volatile;

negative: rvalue reference declarator with const qualifier followed by attributes

	extern int&& const [[]] x;

negative: rvalue reference declarator with volatile qualifier followed by attributes

	extern int&& volatile [[]] x;

positive: lvalue reference declarator with ignored const qualifier introduced through alias name

	using t = volatile int&;
	extern const t x;
	extern volatile int& x;

positive: lvalue reference declarator with ignored volatile qualifier introduced through alias name

	using t = const int&;
	extern volatile t x;
	extern const int& x;

positive: rvalue reference declarator with ignored const qualifier introduced through alias name

	using t = volatile int&&;
	extern const t x;
	extern volatile int&& x;

positive: rvalue reference declarator with ignored volatile qualifier introduced through alias name

	using t = const int&&;
	extern volatile t x;
	extern const int&& x;

positive: lvalue reference declarator with ignored const qualifier introduced through decltype specifier

	extern volatile int& x;
	extern const decltype (x) y;
	extern volatile int& y;

positive: lvalue reference declarator with ignored volatile qualifier introduced through decltype specifier

	extern const int& x;
	extern volatile decltype (x) y;
	extern const int& y;

positive: rvalue reference declarator with ignored const qualifier introduced through decltype specifier

	extern volatile int&& x;
	extern const decltype (x) y;
	extern volatile int&& y;

positive: rvalue reference declarator with ignored volatile qualifier introduced through decltype specifier

	extern const int&& x;
	extern volatile decltype (x) y;
	extern const int&& y;

# todo: ignored const qualifier introduced through alias name example

negative: lvalue reference declarator specifying reference to void

	using t = void&;

negative: lvalue reference declarator specifying reference to const void

	using t = const void&;

negative: lvalue reference declarator specifying reference to volatile void

	using t = volatile void&;

negative: lvalue reference declarator specifying reference to const volatile void

	using t = const volatile void&;

negative: rvalue reference declarator specifying reference to void

	using t = void&&;

negative: rvalue reference declarator specifying reference to const void

	using t = const void&&;

negative: rvalue reference declarator specifying reference to volatile void

	using t = volatile void&&;

negative: rvalue reference declarator specifying reference to const volatile void

	using t = const volatile void&&;

# 11.3.2 [dcl.ref] 2

negative: lvalue references distinct from referenced type

	using t = int&;
	using t = int;

negative: lvalue references distinct from rvalue references

	using t = int&;
	using t = int&&;

negative: rvalue references distinct from referenced type

	using t = int&&;
	using t = int;

negative: rvalue references distinct from lvalue references

	using t = int&&;
	using t = int&;

# todo: 11.3.2 [dcl.ref] 3

# 11.3.2 [dcl.ref] 5

negative: forming lvalue reference to lvalue reference

	using t = int & &;

negative: forming lvalue reference to rvalue reference

	using t = int && &;

negative: forming array of lvalue references

	using t = int &[];

negative: forming pointer of lvalue reference

	using t = int &*;

negative: forming rvalue reference to lvalue reference

	using t = int & &&;

negative: forming rvalue reference to rvalue reference

	using t = int && &&;

negative: forming array of rvalue references

	using t = int &&[];

negative: forming pointer of rvalue reference

	using t = int &&*;

negative: lvalue reference declaration missing initializer

	int& x;

positive: lvalue reference declaration missing initializer with extern specifier

	extern int& x;

positive: lvalue reference declaration missing initializer contained directly in linkage specification

	extern "C" int& x;

negative: lvalue reference declaration missing initializer contained indirectly in linkage specification

	extern "C" {int& x;}

positive: lvalue reference class member declaration missing initializer

	class c {int& x;};

positive: lvalue reference parameter declaration missing initializer

	void f (int& x);

positive: lvalue reference return type declaration missing initializer

	int& f ();

negative: lrvalue reference declaration missing initializer

	int&& x;

positive: lrvalue reference declaration missing initializer with extern specifier

	extern int&& x;

positive: lrvalue reference declaration missing initializer contained directly in linkage specification

	extern "C" int&& x;

negative: lrvalue reference declaration missing initializer contained indirectly in linkage specification

	extern "C" {int&& x;}

positive: lrvalue reference class member declaration missing initializer

	class c {int&& x;};

positive: lrvalue reference parameter declaration missing initializer

	void f (int&& x);

positive: lrvalue reference return type declaration missing initializer

	int&& f ();

# 11.3.2 [dcl.ref] 6

positive: creating lvalue reference to lvalue reference type through alias name

	using t = int&;
	extern t& x;
	extern int& x;

positive: creating lvalue reference to const lvalue reference type through alias name

	using t = int&;
	extern const t& x;
	extern int& x;

positive: creating lvalue reference to volatile lvalue reference type through alias name

	using t = int&;
	extern volatile t& x;
	extern int& x;

positive: creating lvalue reference to const volatile lvalue reference type through alias name

	using t = int&;
	extern const volatile t& x;
	extern int& x;

positive: creating lvalue reference to rvalue reference type through alias name

	using t = int&&;
	extern t& x;
	extern int& x;

positive: creating lvalue reference to const rvalue reference type through alias name

	using t = int&&;
	extern const t& x;
	extern int& x;

positive: creating lvalue reference to volatile rvalue reference type through alias name

	using t = int&&;
	extern volatile t& x;
	extern int& x;

positive: creating lvalue reference to const volatile rvalue reference type through alias name

	using t = int&&;
	extern const volatile t& x;
	extern int& x;

positive: creating rvalue reference to lvalue reference type through alias name

	using t = int&;
	extern t&& x;
	extern int& x;

positive: creating rvalue reference to const lvalue reference type through alias name

	using t = int&;
	extern const t&& x;
	extern int& x;

positive: creating rvalue reference to volatile lvalue reference type through alias name

	using t = int&;
	extern volatile t&& x;
	extern int& x;

positive: creating rvalue reference to const volatile lvalue reference type through alias name

	using t = int&;
	extern const volatile t&& x;
	extern int& x;

positive: creating rvalue reference to rvalue reference type through alias name

	using t = int&&;
	extern t&& x;
	extern int&& x;

positive: creating rvalue reference to const rvalue reference type through alias name

	using t = int&&;
	extern const t&& x;
	extern int&& x;

positive: creating rvalue reference to volatile rvalue reference type through alias name

	using t = int&&;
	extern volatile t&& x;
	extern int&& x;

positive: creating rvalue reference to const volatile rvalue reference type through alias name

	using t = int&&;
	extern const volatile t&& x;
	extern int&& x;

positive: creating lvalue reference to lvalue reference type through decltype specifier

	extern int& x;
	extern decltype (x)& y;
	extern int& y;

positive: creating lvalue reference to const lvalue reference type through decltype specifier

	extern int& x;
	extern const decltype (x)& y;
	extern int& y;

positive: creating lvalue reference to volatile lvalue reference type through decltype specifier

	extern int& x;
	extern volatile decltype (x)& y;
	extern int& y;

positive: creating lvalue reference to const volatile lvalue reference type through decltype specifier

	extern int& x;
	extern const volatile decltype (x)& y;
	extern int& y;

positive: creating lvalue reference to rvalue reference type through decltype specifier

	extern int&& x;
	extern decltype (x)& y;
	extern int& y;

positive: creating lvalue reference to const rvalue reference type through decltype specifier

	extern int&& x;
	extern const decltype (x)& y;
	extern int& y;

positive: creating lvalue reference to volatile rvalue reference type through decltype specifier

	extern int&& x;
	extern volatile decltype (x)& y;
	extern int& y;

positive: creating lvalue reference to const volatile rvalue reference type through decltype specifier

	extern int&& x;
	extern const volatile decltype (x)& y;
	extern int& y;

positive: creating rvalue reference to lvalue reference type through decltype specifier

	extern int& x;
	extern decltype (x)&& y;
	extern int& y;

positive: creating rvalue reference to const lvalue reference type through decltype specifier

	extern int& x;
	extern const decltype (x)&& y;
	extern int& y;

positive: creating rvalue reference to volatile lvalue reference type through decltype specifier

	extern int& x;
	extern volatile decltype (x)&& y;
	extern int& y;

positive: creating rvalue reference to const volatile lvalue reference type through decltype specifier

	extern int& x;
	extern const volatile decltype (x)&& y;
	extern int& y;

positive: creating rvalue reference to rvalue reference type through decltype specifier

	extern int&& x;
	extern decltype (x)&& y;
	extern int&& y;

positive: creating rvalue reference to const rvalue reference type through decltype specifier

	extern int&& x;
	extern const decltype (x)&& y;
	extern int&& y;

positive: creating rvalue reference to volatile rvalue reference type through decltype specifier

	extern int&& x;
	extern volatile decltype (x)&& y;
	extern int&& y;

positive: creating rvalue reference to const volatile rvalue reference type through decltype specifier

	extern int&& x;
	extern const volatile decltype (x)&& y;
	extern int&& y;

# todo: reference collapsing example

# 11.3.2 [dcl.ref] 7

positive: forming a lvalue reference to function type without qualifiers

	using t = void (&) ();

negative: forming a lvalue reference to function type with const qualifier

	using t = void (&) () const;

negative: forming a lvalue reference to function type with volatile qualifier

	using t = void (&) () volatile;

negative: forming a lvalue reference to function type with lvalue reference qualifier

	using t = void (&) () &;

negative: forming a lvalue reference to function type with rvalue reference qualifier

	using t = void (&) () &&;

positive: forming a rvalue reference to function type without qualifiers

	using t = void (&&) ();

negative: forming a rvalue reference to function type with const qualifier

	using t = void (&&) () const;

negative: forming a rvalue reference to function type with volatile qualifier

	using t = void (&&) () volatile;

negative: forming a rvalue reference to function type with lvalue reference qualifier

	using t = void (&&) () &;

negative: forming a rvalue reference to function type with rvalue reference qualifier

	using t = void (&&) () &&;

# 11.3.3 [dcl.mptr] 1

positive: pointer to member declarator

	class c;
	int c::* x;

negative: pointer to member declarator missing nested name specifier

	class c;
	int ::* x;

negative: pointer to member declarator with nested name specifier denoting non-type

	int x;
	int x::* y;

negative: pointer to member declarator with nested name specifier denoting non-class

	using t = int;
	int t::* x;

positive: pointer to member declarator with nested name specifier denoting incomplete class

	class c;
	int c::* x;

positive: pointer to member declarator with nested name specifier denoting complete class

	class c {};
	int c::* x;

positive: pointer to member declarator with attributes

	class c;
	int c::* [[]] x;

positive: pointer to member declarator with attributes followed by const volatile qualifiers

	class c;
	int c::* [[]] const volatile x;

positive: pointer to member declarator with const qualifier

	class c;
	int c::* const x;

negative: pointer to member declarator with const qualifiers

	class c;
	int c::* const const x;

positive: pointer to member declarator with volatile qualifier

	class c;
	int c::* volatile x;

negative: pointer to member declarator with volatile qualifiers

	class c;
	int c::* volatile volatile x;

positive: pointer to member declarator with const volatile qualifiers

	class c;
	int c::* const volatile x;

positive: pointer to member declarator with volatile const qualifiers

	class c;
	int c::* volatile const x;

negative: pointer to member declarator with const volatile qualifiers followed by attributes

	class c;
	int c::* const volatile [[]] x;

# 11.3.3 [dcl.mptr] 2

positive: pointer to member declarator example

	struct X {
		void f(int);
		int a;
	};
	struct Y;

	int X::* pmi = &X::a;
	void (X::* pmf)(int) = &X::f;
	double X::* pmd;
	char Y::* pmc;

	void f ()
	{
		X obj;
		// ...
		obj.*pmi = 7; // assign 7 to an integer member of obj
		(obj.*pmf)(7); // call a function member of obj with the argument 7
	}

# 11.3.3 [dcl.mptr] 3

positive: pointer to member declarator pointing to non-static member of a class

	struct s {int m;} x;
	int s::* y = &s::m;

negative: pointer to member declarator pointing to static member of a class

	struct s {static int m;} x;
	int s::* y = &s::m;

negative: pointer to member declarator of lvalue reference type

	struct s;
	int& s::* x;

negative: pointer to member declarator of rvalue reference type

	struct s;
	int&& s::* x;

negative: pointer to member declarator of type void

	struct s;
	void s::* x;

negative: pointer to member declarator of type const void

	struct s;
	const void s::* x;

negative: pointer to member declarator of type volatile void

	struct s;
	volatile void s::* x;

negative: pointer to member declarator of type const volatile void

	struct s;
	volatile const void s::* x;

# 11.3.4 [dcl.array] 1

positive: array declarator

	int x[1];

negative: array declarator missing opening bracket

	int x 1];

positive: array declarator missing constant expression

	extern int x[];

negative: array declarator missing closing bracket

	int x[1;

negative: array declarator containing auto type specifier

	auto x[1];

negative: array declarator of lvalue reference type

	int& x[1];

negative: array declarator of rvalue reference type

	int&& x[1];

negative: array declarator of type void

	void x[1];

negative: array declarator of type const void

	const void x[1];

negative: array declarator of type volatile void

	volatile void x[1];

negative: array declarator of type const volatile void

	const volatile void x[1];

negative: array declarator of function type

	int x[1]();

negative: array declarator of abstract class type

	class {virtual void f () = 0;} x[1];

negative: array declarator with non-constant expression

	int x, y[x];

positive: array declarator with constant expression convertible to size_t

	enum e {c = 1};
	int x[e::c];

negative: array declarator with constant expression non-convertible to size_t

	enum class e {c = 1};
	int x[e::c];

positive: array declarator with constant expression greater than zero

	int x[+1];

negative: array declarator with constant expression equal to zero

	int x[0];

negative: array declarator with constant expression less than zero

	int x[-1];

negative: array declarators differing in bound declaring distinct types

	extern int x[1];
	extern int x[2];

negative: array declarators with known and unknown bound declaring distinct types

	extern int x[];
	extern int x[1];

positive: array declarators of known bound with adjusted const volatile qualifiers

	using t = int [1];
	using ct = const int [1];
	extern ct x;
	extern const t x;
	extern const ct x;
	extern const int x[1];

positive: array declarators of unknown bound with adjusted const volatile qualifiers

	using t = int [];
	using ct = const int [];
	extern ct x;
	extern const t x;
	extern const ct x;
	extern const int x[];

positive: array declarator with attributes

	int x[] [[]];

positive: array declarator example

	typedef int A[5], AA[2][3];
	typedef const A CA; // type is “array of 5 const int”
	typedef const AA CAA; // type is “array of 2 array of 3 const int”

	using A = int[5];
	using AA = int[2][3];
	using CA = const int[5];
	using CAA = const int[2][3];

# 11.3.4 [dcl.array] 2

positive: constructing array from type bool

	using t = bool[];

positive: constructing array from type char

	using t = char[];

positive: constructing array from type signed char

	using t = signed char[];

positive: constructing array from type unsigned char

	using t = unsigned char[];

positive: constructing array from type char16_t

	using t = char16_t[];

positive: constructing array from type char32_t

	using t = char32_t[];

positive: constructing array from type wchar_t

	using t = wchar_t[];

positive: constructing array from type short int

	using t = short int[];

positive: constructing array from type unsigned short int

	using t = unsigned short int[];

positive: constructing array from type int

	using t = int[];

positive: constructing array from type unsigned int

	using t = unsigned int[];

positive: constructing array from type long int

	using t = long int[];

positive: constructing array from type unsigned long int

	using t = unsigned long int[];

positive: constructing array from type long long int

	using t = long long int[];

positive: constructing array from type unsigned long long int

	using t = unsigned long long int[];

positive: constructing array from type float

	using t = float[];

positive: constructing array from type double

	using t = double[];

positive: constructing array from type long double

	using t = long double[];

negative: constructing array from type void

	using t = void[];

positive: constructing array from type std::nullptr_t

	using t = decltype(nullptr)[];

positive: constructing array from a pointer

	using t = int*[];

positive: constructing array from a pointer to member

	class c;
	using t = int c::*[];

positive: constructing array from a class

	class c;
	using t = c[];

positive: constructing array from an enumeration

	enum e : int;
	using t = e[];

positive: constructing array from an other array

	using t = int[][1];

# 11.3.4 [dcl.array] 3

positive: creating a multidimensional array type

	using t = int[10][10][10];

positive: creating a multidimensional array type with first bound omitted

	using t = int[][10][10];

negative: creating a multidimensional array type with second bound omitted

	using t = int[10][][10];

negative: creating a multidimensional array type with third bound omitted

	using t = int[10][10][];

# todo: ommited bounds

# todo: 11.3.4 [dcl.array] 4-8

# 11.3.5 [dcl.fct] 1

positive: function declarator

	int f ();

negative: function declarator missing opening parenthesis

	int f );

negative: function declarator missing closing parenthesis

	int f (;

positive: function declarator with const qualifier

	class c {int f () const;};

negative: function declarator with const qualifiers

	class c {int f () const const;};

positive: function declarator with volatile qualifier

	class c {int f () volatile;};

negative: function declarator with volatile qualifiers

	class c {int f () volatile volatile;};

positive: function declarator with const volatile qualifiers

	class c {int f () const volatile;};

positive: function declarator with volatile const qualifiers

	class c {int f () const volatile;};

positive: function declarator with const volatile qualifiers followed by lvalue reference qualifier

	class c {int f () const volatile &;};

positive: function declarator with const volatile qualifiers followed by rvalue reference qualifier

	class c {int f () const volatile &&;};

positive: function declarator with const volatile qualifiers followed by noexcept specifier

	class c {int f () const volatile noexcept;};

positive: function declarator with const volatile qualifiers followed by attributes

	class c {int f () const volatile [[]];};

positive: function declarator with const volatile qualifiers followed by trailing return type

	class c {auto f () const volatile -> int;};

positive: function declarator with lvalue reference qualifier

	class c {int f () &;};

negative: function declarator with lvalue reference qualifier followed by const volatile qualifiers

	class c {int f () & const volatile;};

positive: function declarator with lvalue reference qualifier followed by noexcept specifier

	class c {int f () & noexcept;};

positive: function declarator with lvalue reference qualifier followed by attributes

	class c {int f () & [[]];};

positive: function declarator with lvalue reference qualifier followed by trailing return type

	class c {auto f () & -> int;};

positive: function declarator with rvalue reference qualifier

	class c {int f () &&;};

negative: function declarator with rvalue reference qualifier followed by const volatile qualifiers

	class c {int f () && const volatile;};

positive: function declarator with rvalue reference qualifier followed by noexcept specifier

	class c {int f () && noexcept;};

positive: function declarator with rvalue reference qualifier followed by attributes

	class c {int f () && [[]];};

positive: function declarator with rvalue reference qualifier followed by trailing return type

	class c {auto f () && -> int;};

positive: function declarator with noexcept specifier

	int f () noexcept;

negative: function declarator with noexcept specifier followed by const volatile qualifiers

	class c {int f () noexcept const volatile;};

negative: function declarator with noexcept specifier followed by lvalue reference qualifier

	class c {int f () noexcept &;};

negative: function declarator with noexcept specifier followed by rvalue reference qualifier

	class c {int f () noexcept &&;};

positive: function declarator with noexcept specifier followed by attributes

	int f () noexcept [[]];

positive: function declarator with noexcept specifier followed by trailing return type

	auto f () noexcept -> int;

positive: function declarator with attributes

	int f () [[]];

negative: function declarator with attributes followed by const volatile qualifiers

	class c {int f () [[]] const volatile;};

negative: function declarator with attributes followed by lvalue reference qualifier

	class c {int f () [[]] &;};

negative: function declarator with attributes followed by rvalue reference qualifier

	class c {int f () [[]] &&;};

negative: function declarator with attributes followed by noexcept specifier

	int f () [[]] noexcept;

positive: function declarator with attributes followed by trailing return type

	auto f () [[]] -> int;

# 11.3.5 [dcl.fct] 2

negative: function declarator with trailing return type and int type specifier

	int f () -> int;

positive: function declarator with trailing return type and auto type specifier

	auto f () -> int;

negative: function declarator with trailing return type and const auto type specifier

	const auto f () -> int;

negative: function declarator with trailing return type and volatile auto type specifier

	volatile auto f () -> int;

negative: function declarator with trailing return type and const volatile auto type specifier

	const volatile auto f () -> int;

negative: function declarator with trailing return type and lvalue reference to auto type specifier

	auto& f () -> int;

negative: function declarator with trailing return type and rvalue reference to auto type specifier

	auto&& f () -> int;

# todo: noexcept specifier

# 11.3.5 [dcl.fct] 3

positive: empty parameter declaration clause

	void f ();

positive: parameter declaration clause consisting of parameter declaration list

	void f (int, int);

positive: parameter declaration clause consisting of parameter declaration list followed by ellipsis

	void f (int, int ...);

positive: parameter declaration clause consisting of parameter declaration list followed by comma-separated ellipsis

	void f (int, int, ...);

positive: parameter declaration clause consisting of ellipsis

	void f (...);

negative: parameter declaration clause consisting of ellipsis followed by parameter declaration list

	void f (... int);

negative: parameter declaration clause consisting of ellipsis followed by comma-separated parameter declaration list

	void f (..., int);

negative: parameter declaration clause consisting of comma-separated ellipsis

	void f (, ...);

negative: parameter declaration list followed by parameter declaration

	void f (int int);

positive: parameter declaration list followed by comma-separated parameter declaration

	void f (int, int);

negative: parameter declaration list followed by semicolon-separated parameter declaration

	void f (int; int);

positive: parameter declaration with declarator

	void f (int x);

positive: parameter declaration with attributes followed by declarator

	void f ([[]] int x);

positive: parameter declaration with declarator followed by initializer clause

	void f (int x = 0);

positive: parameter declaration with abstract declarator

	void f (int);

positive: parameter declaration with attributes followed by abstract declarator

	void f ([[]] int);

positive: parameter declaration with abstract declarator followed by initializer clause

	void f (int = 0);

# 11.3.5 [dcl.fct] 4

positive: empty parameter list

	void f ();

positive: parameter list consisting of single unnamed parameter of non-dependent type void

	void f (void);

positive: parameter list consisting of single unnamed parameter of non-dependent type void equivalent to empty parameter list

	using t = void ();
	using t = void (void);
	extern "C" void f ();
	extern "C" void f (void);

negative: parameter list consisting of multiple unnamed parameter of non-dependent type void

	void f (void, void);

negative: parameter list consisting of single named parameter of non-dependent type void

	void f (void x);

# todo: dependent void type

negative: parameter list consisting of single unnamed parameter of non-dependent type const void

	void f (const void);

negative: parameter list consisting of single unnamed parameter of non-dependent type volatile void

	void f (volatile void);

negative: parameter list consisting of single unnamed parameter of non-dependent type const volatile void

	void f (const volatile void);

negative: parameter list consisting of single unnamed parameter of non-dependent type lvalue reference to void

	void f (void&);

negative: parameter list consisting of single unnamed parameter of non-dependent type rvalue reference to void

	void f (void&&);

negative: parameter of type void

	void f (void x);

negative: parameter of type const void

	void f (const void x);

negative: parameter of type volatile void

	void f (volatile void x);

negative: parameter of type const volatile void

	void f (const volatile void x);

negative: variadic function type differing from non-variadic function type

	using t = void (...);
	using t = void ();

positive: variadic function type corresponding to comma separated variadic function type

	using t = void (int ...);
	using t = void (int, ...);

negative: calling non-variadic function with more arguments than parameters

	int f (int), x = f (1, 2);

positive: calling non-variadic function with same number of arguments and parameters

	int f (int), x = f (1);

negative: calling non-variadic function with less arguments than parameters

	int f (int), x = f ();

positive: calling variadic function with more arguments than parameters

	int f (int ...), x = f (1, 2);

positive: calling variadic function with same number of arguments and parameters

	int f (int ...), x = f (1);

negative: calling variadic function with less arguments than parameters

	int f (int ...), x = f ();

positive: calling comma-separated variadic function with more arguments than parameters

	int f (int, ...), x = f (1, 2);

positive: calling comma-separated variadic function with same number of arguments and parameters

	int f (int, ...), x = f (1);

negative: calling comma-separated variadic function with less arguments than parameters

	int f (int, ...), x = f ();

# todo: function parameter pack
# todo: default arguments

positive: variadic function declaration example

	int printf(const char*, ...);
	void f (int a, int b)
	{
		printf("hello world");
		printf("a=%d b=%d", a, b);
	}

# 11.3.5 [dcl.fct] 5

positive: using single name for several different functions

	void f () {}
	void f (...) {}
	void f (int) {}

positive: function declarations agreeing in return type and parameter types

	void f (int, bool);
	void ::f (int, bool);
	void ::f (int, bool);

negative: function declarations disagreeing in return type

	void f (int, bool);
	int ::f (int, bool);

negative: function declarations disagreeing in first parameter type

	void f (int, bool);
	void ::f (char, bool);

negative: function declarations disagreeing in second parameter type

	void f (int, bool);
	void ::f (int, float);

negative: function declarations disagreeing in parameter types

	void f (int, bool);
	void ::f (char, float);

positive: adjusting parameter in function type from array type to pointer type

	using t = void (int[]);
	using t = void (int*);
	using t = void (int[10]);

negative: adjusting parameter in function type from lvalue reference to array type to pointer type

	using t = void (int(&)[10]);
	using t = void (int*&);

negative: adjusting parameter in function type from rvalue reference to array type to pointer type

	using t = void (int(&&)[10]);
	using t = void (int*&&);

positive: adjusting parameter in function type from function type to pointer type

	using t = void (int ());
	using t = void (int (*)());

negative: adjusting parameter in function type from lvalue reference to function type to pointer type

	using t = void (int (&)());
	using t = void (int (*&)());

negative: adjusting parameter in function type from rvalue reference to function type to pointer type

	using t = void (int (&&)());
	using t = void (int (*&&)());

positive: discarding top-level const volatile qualifiers when forming the function type

	using t = void (const int, volatile char, const volatile double);
	using t = void (int, char, double);

negative: discarding lower-level const volatile qualifiers when forming the function type

	using t = void (const int*, volatile char*, const volatile double*);
	using t = void (int*, char*, double*);

positive: identical variadic function types example

	using t = int(*)(const int p, decltype(p)*);
	using t = int(*)(int, const int*);

# 11.3.5 [dcl.fct] 6

positive: using function type with const qualifier for non-static member function

	class c {void f () const;};

negative: using function type with const qualifier for static member function

	class c {static void f () const;};

negative: using function type with const qualifier for non-member function

	void f () const;

positive: using function type with const qualifier for pointer to member

	class c; using t = void (c::*) () const;

negative: using function type with const qualifier for pointer

	using t = void (*) () const;

positive: using top-level function type with const qualifier for typedef declaration

	typedef void t () const;

negative: using lower-level function type with const qualifier for typedef declaration

	typedef void t (void () const);

positive: using top-level function type with const qualifier for alias declaration

	using t = void () const;

negative: using lower-level function type with const qualifier for alias declaration

	using t = void (void () const);

positive: using function type with volatile qualifier for non-static member function

	class c {void f () volatile;};

negative: using function type with volatile qualifier for static member function

	class c {static void f () volatile;};

negative: using function type with volatile qualifier for non-member function

	void f () volatile;

positive: using function type with volatile qualifier for pointer to member

	class c; using t = void (c::*) () volatile;

negative: using function type with volatile qualifier for pointer

	using t = void (*) () volatile;

positive: using top-level function type with volatile qualifier for typedef declaration

	typedef void t () volatile;

negative: using lower-level function type with volatile qualifier for typedef declaration

	typedef void t (void () volatile);

positive: using top-level function type with volatile qualifier for alias declaration

	using t = void () volatile;

negative: using lower-level function type with volatile qualifier for alias declaration

	using t = void (void () volatile);

positive: using function type with const volatile qualifiers for non-static member function

	class c {void f () const volatile;};

negative: using function type with const volatile qualifiers for static member function

	class c {static void f () const volatile;};

negative: using function type with const volatile qualifiers for non-member function

	void f () const volatile;

positive: using function type with const volatile qualifiers for pointer to member

	class c; using t = void (c::*) () const volatile;

negative: using function type with const volatile qualifiers for pointer

	using t = void (*) () const volatile;

positive: using top-level function type with const volatile qualifiers for typedef declaration

	typedef void t () const volatile;

negative: using lower-level function type with const volatile qualifiers for typedef declaration

	typedef void t (void () const volatile);

positive: using top-level function type with const volatile qualifiers for alias declaration

	using t = void () const volatile;

negative: using lower-level function type with const volatile qualifiers for alias declaration

	using t = void (void () const volatile);

positive: using function type with lvalue reference qualifier for non-static member function

	class c {void f () &;};

negative: using function type with lvalue reference qualifier for static member function

	class c {static void f () &;};

negative: using function type with lvalue reference qualifier for non-member function

	void f () &;

positive: using function type with lvalue reference qualifier for pointer to member

	class c; using t = void (c::*) () &;

negative: using function type with lvalue reference qualifier for pointer

	using t = void (*) () &;

positive: using top-level function type with lvalue reference qualifier for typedef declaration

	typedef void t () &;

negative: using lower-level function type with lvalue reference qualifier for typedef declaration

	typedef void t (void () &);

positive: using top-level function type with lvalue reference qualifier for alias declaration

	using t = void () &;

negative: using lower-level function type with lvalue reference qualifier for alias declaration

	using t = void (void () &);

positive: using function type with rvalue reference qualifier for non-static member function

	class c {void f () &&;};

negative: using function type with rvalue reference qualifier for static member function

	class c {static void f () &&;};

negative: using function type with rvalue reference qualifier for non-member function

	void f () &&;

positive: using function type with rvalue reference qualifier for pointer to member

	class c; using t = void (c::*) () &&;

negative: using function type with rvalue reference qualifier for pointer

	using t = void (*) () &&;

positive: using top-level function type with rvalue reference qualifier for typedef declaration

	typedef void t () &&;

negative: using lower-level function type with rvalue reference qualifier for typedef declaration

	typedef void t (void () &&);

positive: using top-level function type with rvalue reference qualifier for alias declaration

	using t = void () &&;

negative: using lower-level function type with rvalue reference qualifier for alias declaration

	using t = void (void () &&);

# todo: default argument of a type-parameter
# todo: template-argument for a type-parameter

negative: const qualified function type example a

	typedef int FIC(int) const;
	FIC f; // ill-formed: does not declare a member function

positive: const qualified function type example b

	typedef int FIC(int) const;
	struct S {
		FIC f; // OK
	};
	FIC S::*pm = &S::f; // OK

# 11.3.5 [dcl.fct] 7

negative: function declarator with const qualifier differing from const qualification on top of the function type

	using f = void ();
	using t = const f;
	using t = void () const;

negative: function declarator with volatile qualifier differing from volatile qualification on top of the function type

	using f = void ();
	using t = volatile f;
	using t = void () volatile;

negative: function declarator with const volatile qualifiers differing from const volatile qualification on top of the function type

	using f = void ();
	using t = const volatile f;
	using t = void () const volatile;

positive: ignoring const qualification on top of function type

	using f = void ();
	using t = f;
	using t = const f;

positive: ignoring volatile qualification on top of function type

	using f = void ();
	using t = f;
	using t = volatile f;

positive: ignoring const volatile qualification on top of function type

	using f = void ();
	using t = f;
	using t = const volatile f;

positive: ignored qualification on function type example

	typedef void F();
	struct S {
		const F f; // OK: equivalent to: void f();
	};
	void S::f () {}

# 11.3.5 [dcl.fct] 8

negative: function types with different return type

	using t = void ();
	using t = char ();

negative: function types with different parameter types

	using t = void (bool);
	using t = void (char);

negative: function types with different reference qualifiers

	using t = void () &;
	using t = void () &&;

negative: function types with different const volatile qualifiers

	using t = void () const;
	using t = void () volatile;

negative: function types with different exception specification

	using t = void () noexcept (false);
	using t = void () noexcept (true);

negative: function types with different default arguments

	void f (int = 0) {}
	void f (int = 1) {}

# todo: check

positive: checked function types during assignment of pointer to functions

	void f () {auto x = &f; x = &f;}

positive: checked function types during assignment of pointer to member functions

	struct c {void f () {auto x = &c::f; x = &c::f;}};

positive: checked function types during initialization of pointer to functions

	void f (), (*x) () = &f;

positive: checked function types during initialization of references to functions

	void f (), (&x) () = f;

positive: checked function types during initialization of pointer to member functions

	struct c {void f ();}; void (c::*x) () = &c::f;

# 11.3.5 [dcl.fct] 9

positive: function declaration example

	class FILE;
	int fseek(FILE*, long, int);
	int (*x) (FILE*, long, int) = fseek;

# 11.3.5 [dcl.fct] 10

negative: function returning array type

	int f () [];

positive: function returning pointer to array type

	int (*f ()) [];

positive: function returning lvalue reference to array type

	int (&f ()) [];

positive: function returning rvalue reference to array type

	int (&&f ()) [];

negative: function returning function type

	int f () ();

positive: function returning pointer to function type

	int (*f ()) ();

positive: function returning lvalue reference to function type

	int (&f ()) ();

positive: function returning rvalue reference to function type

	int (&&f ()) ();

negative: array of functions

	void x[10] ();

negative: array of pointers to functions

	void (*x)[10] ();

# 11.3.5 [dcl.fct] 11

negative: class definition in return type

	class {} f ();

negative: class definition in parameter declaration

	void f (class {});

# todo: incomplete class types

# 11.3.5 [dcl.fct] 12

positive: using typedef declaration of function type to declare a function

	typedef void t ();
	t f;

negative: using typedef declaration of function type to define a function

	typedef void t ();
	t f {}

positive: using alias declaration of function type to declare a function

	using t = void ();
	t f;

negative: using alias declaration of function type to define a function

	using t = void ();
	t f {}

positive: using typedef declaration in function declaration example a

	typedef void F();
	F fv; // OK: equivalent to void fv();
	void fv() { } // OK: definition of fv

negative: using typedef declaration in function declaration example b

	typedef void F();
	F fv { } // ill-formed

# 11.3.5 [dcl.fct] 13

positive: optionally provided parameter name in function type

	using t = void (int);
	using t = void (int p);
	using t = void (int x);

positive: optionally provided parameter name in function definition

	int f (int);
	int f (int p);
	int f (int x) {return x;}

positive: optional parameter name in function declaration

	void f (int);

positive: optional parameter name in function definition

	void f (int) {}

positive: differing parameter names in function declarations

	void f (int x);
	void f (int y);

positive: differing parameter names in function definition

	void f (int x) {}
	void f (int y);
	void f (int z);

negative: using parameter name in function declaration outside its function declarator

	int f (int x), y = x;

# 11.3.5 [dcl.fct] 14

positive: function pointer declarations example

	int i,
		*pi,
		f(),
		*fpi(int),
		(*pif)(const char*, const char*),
		(*fpif(int))(int);

# todo: trailing return type example

# todo: 11.3.5 [dcl.fct] 15
# todo: 11.3.5 [dcl.fct] 16
# todo: 11.3.5 [dcl.fct] 17

# 11.4.1 [dcl.fct.def.general] 1

positive: function definition

	void f () {}

positive: function definition with attributes

	[[]] void f () {}

negative: function definition missing declarator

	void {}

positive: function definition with final virtual specifier

	class c {virtual void f () final {}};

positive: function definition with override virtual specifier

	class b {virtual void f ();};
	class c : b {void f () override {}};

negative: function definition missing function body

	void ()

negative: function body with braces

	void f {}

negative: function body missing opening brace

	void f () }

negative: function body missing closing brace

	void f () {

positive: function body with constructor initializer

	class c {int a; c () : a (0) {}};

negative: function body with constructor initializer missing opening brace

	class c {int a; c () : a (0) }};

negative: function body with constructor initializer missing closing brace

	class c {int a; c () : a (0) {};

positive: delete function body

	void f () = delete;

negative: delete function body missing equal sign

	void f () delete;

negative: delete function body missing delete keyword

	void f () = ;

negative: delete function body missing semicolon

	void f () = delete

negative: delete function body followed by braces

	void f () = delete {}

positive: default function body

	class c {c () = default;};

negative: default function body missing equal sign

	class c {c () default;};

negative: default function body missing default keyword

	class c {c () = ;};

negative: default function body missing semicolon

	class c {c () = default};

negative: default function body followed by braces

	class c {c () = default {}};

positive: final virtual specifier in member function definition

	class c {virtual void f () final {}};

negative: final virtual specifier in non-member function definition

	virtual void f () final {};

positive: override virtual specifier in member function definition

	class b {virtual void f ();};
	class c : b {void f () override {}};

negative: override virtual specifier in non-member function definition

	void f () override {};

# 11.4.1 [dcl.fct.def.general] 2

positive: declarator in function definition

	int f () {}

negative: declarator in function definition missing opening parenthesis

	int f ) {}

negative: declarator in function definition missing closing parenthesis

	int f ( {}

positive: declarator in function definition with const qualifier

	class c {int f () const {}};

negative: declarator in function definition with const qualifiers

	class c {int f () const const {}};

positive: declarator in function definition with volatile qualifier

	class c {int f () volatile {}};

negative: declarator in function definition with volatile qualifiers

	class c {int f () volatile volatile {}};

positive: declarator in function definition with const volatile qualifiers

	class c {int f () const volatile {}};

positive: declarator in function definition with volatile const qualifiers

	class c {int f () const volatile {}};

positive: declarator in function definition with const volatile qualifiers followed by lvalue reference qualifier

	class c {int f () const volatile & {}};

positive: declarator in function definition with const volatile qualifiers followed by rvalue reference qualifier

	class c {int f () const volatile && {}};

positive: declarator in function definition with const volatile qualifiers followed by noexcept specifier

	class c {int f () const volatile noexcept {}};

positive: declarator in function definition with const volatile qualifiers followed by attributes

	class c {int f () const volatile [[]] {}};

positive: declarator in function definition with const volatile qualifiers followed by trailing return type

	class c {auto f () const volatile -> int {}};

positive: declarator in function definition with lvalue reference qualifier

	class c {int f () & {}};

negative: declarator in function definition with lvalue reference qualifier followed by const volatile qualifiers

	class c {int f () & const volatile {}};

positive: declarator in function definition with lvalue reference qualifier followed by noexcept specifier

	class c {int f () & noexcept {}};

positive: declarator in function definition with lvalue reference qualifier followed by attributes

	class c {int f () & [[]] {}};

positive: declarator in function definition with lvalue reference qualifier followed by trailing return type

	class c {auto f () & -> int {}};

positive: declarator in function definition with rvalue reference qualifier

	class c {int f () && {}};

negative: declarator in function definition with rvalue reference qualifier followed by const volatile qualifiers

	class c {int f () && const volatile {}};

positive: declarator in function definition with rvalue reference qualifier followed by noexcept specifier

	class c {int f () && noexcept {}};

positive: declarator in function definition with rvalue reference qualifier followed by attributes

	class c {int f () && [[]] {}};

positive: declarator in function definition with rvalue reference qualifier followed by trailing return type

	class c {auto f () && -> int {}};

positive: declarator in function definition with noexcept specifier

	int f () noexcept {}

negative: declarator in function definition with noexcept specifier followed by const volatile qualifiers

	class c {int f () noexcept const volatile {}};

negative: declarator in function definition with noexcept specifier followed by lvalue reference qualifier

	class c {int f () noexcept & {}};

negative: declarator in function definition with noexcept specifier followed by rvalue reference qualifier

	class c {int f () noexcept && {}};

positive: declarator in function definition with noexcept specifier followed by attributes

	int f () noexcept [[]] {}

positive: declarator in function definition with noexcept specifier followed by trailing return type

	auto f () noexcept -> int {}

positive: declarator in function definition with attributes

	int f () [[]] {}

negative: declarator in function definition with attributes followed by const volatile qualifiers

	class c {int f () [[]] const volatile {}};

negative: declarator in function definition with attributes followed by lvalue reference qualifier

	class c {int f () [[]] & {}};

negative: declarator in function definition with attributes followed by rvalue reference qualifier

	class c {int f () [[]] && {}};

negative: declarator in function definition with attributes followed by noexcept specifier

	int f () [[]] noexcept {}

positive: declarator in function definition with attributes followed by trailing return type

	auto f () [[]] -> int {}

negative: declarator in function definition with trailing return type and int type specifier

	int f () -> int {}

positive: declarator in function definition with trailing return type and auto type specifier

	auto f () -> int {}

negative: declarator in function definition with trailing return type and const auto type specifier

	const auto f () -> int {}

negative: declarator in function definition with trailing return type and volatile auto type specifier

	volatile auto f () -> int {}

negative: declarator in function definition with trailing return type and const volatile auto type specifier

	const volatile auto f () -> int {}

negative: declarator in function definition with trailing return type and lvalue reference to auto type specifier

	auto& f () -> int {}

negative: declarator in function definition with trailing return type and rvalue reference to auto type specifier

	auto&& f () -> int {}

positive: function definition in class scope

	class c {void f () {}};

negative: function definition in block scope

	void f () {void g () {}}

positive: function definition in global scope

	void f () {}

positive: function definition in namespace scope

	namespace n {void f () {}}
	namespace {void f () {}}

# todo: declaration without void
# todo: parenthesized declarator

# 11.4.1 [dcl.fct.def.general] 3

positive: complete function definition example

	int max(int a, int b, int c) {
		int m = (a > b) ? a : b;
		return (m > c) ? m : c;
	}

# 11.4.1 [dcl.fct.def.general] 4

negative: using constructor initializer in non-member function

	int a; void f () : a () {}

negative: using constructor initializer in non-special member function

	class c {int a; void f () : a () {}};

positive: using constructor initializer in constructor inside class definition

	class c {int a; c () : a () {}};

positive: using constructor initializer in constructor outside class definition

	class c {int a; c ();}; c::c () : a () {}

# todo: 11.4.1 [dcl.fct.def.general] 5

# 11.4.1 [dcl.fct.def.general] 6

positive: unnamed parameters example

	#include <cstdio>

	void print(int a, int) {
		std::printf("a = %d\n",a);
	}

# 11.4.1 [dcl.fct.def.general] 7

positive: referring to function-local predefined variable in function body

	void f () {const char* f = __func__;}

positive: referring to function-local predefined variable in constructor initializer

	class c {const char* f; c () : f (__func__) {}};

negative: referring to function-local predefined variable outside function definition

	const char* f = __func__;

# 11.4.1 [dcl.fct.def.general] 8

negative: redefining function-local predefined variable __func__ in function body

	void f () {int __func__;}

positive: redefining function-local predefined variable __func__ in compound statement in function body

	void f () {{int __func__;}}

negative: redefining function-local predefined variable __func__ in function try block

	void f () try {int __func__;} catch (...) {}

positive: redefining function-local predefined variable __func__ in compound statement in function try block

	void f () try {{int __func__;}} catch (...) {}

negative: redefining function-local predefined variable __func__ in handler of function try block

	void f () try {} catch (...) {int __func__;}

positive: redefining function-local predefined variable __func__ in compound statement in handler of function try block

	void f () try {} catch (...) {{int __func__;}}

positive: function-local predefined variable __func__

	void f () {const char* x = __func__; static_assert (sizeof __func__ > 0);}

positive: function-local predefined variable __func__ example a

	struct S {
		S() : s(__func__) { } // OK
		const char* s;
	};

negative: function-local predefined variable __func__ example b

	void f(const char* s = __func__); // error: __func__ is undeclared

# 11.4.3 [dcl.fct.def.delete] 1

positive: deleted definition

	void f () = delete;

negative: deleted definition missing equal sign

	void f () delete;

negative: deleted definition missing delete keyword

	void f () = ;

negative: deleted definition missing semicolon

	void f () = delete

# 11.4.3 [dcl.fct.def.delete] 2

negative: calling deleted function

	void f () = delete;
	void g () {f ();}

negative: forming pointer to deleted function

	void f () = delete;
	void (*x) = &f;

negative: forming member pointer to deleted member function

	class c {void f () = delete;};
	void (c::*x) () = &c::f;

# todo: implicit calling deleted function
# todo: potentially-unevaluated function calls
# todo: function overloads

# todo: 11.4.3 [dcl.fct.def.delete] 3

# 11.4.3 [dcl.fct.def.delete] 4

negative: redefinition of deleted function as deleted

	void f () = delete;
	void f () = delete;

negative: redefinition of defined function as deleted

	void f () {}
	void f () = delete;

negative: redefinition of deleted function as defined

	void f () = delete;
	void f () {}

positive: first declaration of deleted function

	void f () = delete;
	void f ();

negative: second declaration of deleted function

	void f ();
	void f () = delete;

# todo: explicit specialization of a function template
# todo: implicitly declared allocation or deallocation function

negative: deleting function after first declaration example

	struct sometype {
		sometype();
	};
	sometype::sometype() = delete; // ill-formed; not first declaration

# 12.1 [class.name] 1

positive: class definition type introduction example

	struct X { int a; };
	struct Y { int a; };
	X a1;
	Y a2;
	int a3;

negative: class definition type mismatch example a

	struct X { int a; };
	struct Y { int a; };
	X a1;
	Y a2;
	void f () {a1 = a2;} // error: Y assigned to X

negative: class definition type mismatch example b

	struct X { int a; };
	struct Y { int a; };
	X a1;
	int a3;
	void f () {a1 = a3;} // error: int assigned to X

positive: class definition overload example

	struct X { int a; };
	struct Y { int a; };
	int f(X) {}
	int f(Y) {}

negative: double class definition example

	struct S { int a; };
	struct S { int a; }; // error, double definition

# 12.1 [class.name] 2

positive: name introduction by class declaration

	class c {}; c x;

positive: class declaration hiding class declaration in enclosing scope

	class c {};
	namespace {class c {}; c x;}

positive: class declaration hiding variable declaration in enclosing scope

	int c;
	namespace {class c {}; c x;}

positive: class declaration hiding function declaration in enclosing scope

	int c ();
	namespace {class c {}; c x;}

positive: class declaration hiding enumeration declaration in enclosing scope

	enum c {};
	namespace {class c {}; c x;}

positive: class declaration hiding enumerator declaration in enclosing scope

	enum {c};
	namespace {class c {}; c x;}

positive: class declaration in same scope as variable declaration

	int c;
	class c;

positive: using elaborated type specifier to refer to class in same scope as variable declaration

	int c;
	class c;
	extern class c x;

negative: using non-elaborated type specifier to refer to class in same scope as variable declaration

	int c;
	class c;
	extern c x;

positive: class declaration in same scope as function declaration

	int c ();
	class c;

positive: using elaborated type specifier to refer to class in same scope as function declaration

	int c ();
	class c;
	extern class c x;

negative: using non-elaborated type specifier to refer to class in same scope as function declaration

	int c ();
	class c;
	extern c x;

negative: class declaration in same scope as enumeration declaration

	enum c {};
	class c;

positive: class declaration in same scope as enumerator declaration

	enum {c};
	class c;

positive: using elaborated type specifier to refer to class in same scope as enumerator declaration

	enum {c};
	class c;
	extern class c x;

negative: using non-elaborated type specifier to refer to class in same scope as enumerator declaration

	enum {c};
	class c;
	extern c x;

# todo: examples
# todo: 12.1 [class.name] 3
# todo: 12.1 [class.name] 4

# 12.1 [class.name] 5

# todo: cv-qualified version of class type

negative: using typedef name as identifier in class head

	typedef class c x;
	class x;

# 12.2.4 [class.bit] 1

positive: bit-field specification in member declarator

	struct S {int x : 1;};

negative: bit-field specification in declarator

	int x : 1;

negative: bit-field specification missing colon

	struct S {int x 1;};

negative: bit-field specification missing length

	struct S {int : ;};

positive: attributed bit-field

	struct S {int x [[]] : 1;};

positive: attributed unnamed bit-field

	struct S {int [[]] : 1;};

positive: bit-field attribute not part of member type

	struct S {int x : 1;};
	decltype (S::x) x;
	extern int x;

positive: integral bit-field length

	struct S {int : true, : '1', : 1, : 1u, : 1l;};

negative: non-integral bit-field length

	struct S {int x : 1.1;};

positive: constant bit-field length

	constexpr int x = 1;
	struct S {int : x;};

negative: non-constant bit-field length

	int x = 1;
	struct S {int : x;};

positive: positive bit-field length

	struct S {int : 1;};

positive: zero bit-field length

	struct S {int : 0;};

negative: negative bit-field length

	struct S {int : -1;};

positive: extra bits used as padding bits in bit-field

	struct S {int : 100;};

# 12.2.4 [class.bit] 2

positive: unnamed bit-field

	struct S {int : 1;};

negative: initializing unnamed bit-field

	struct S {int : 1 = 0;};

positive: unnamed bit-field with a width of zero

	struct S {int : 0;};

negative: named bit-field with a width of zero

	struct S {int x : 0;};

# 12.2.4 [class.bit] 3

negative: static member bit-field

	struct S {static int x : 1;};

positive: integral bit-field

	struct S {int x : 1;};

negative: non-integral bit-field

	struct S {float x : 1;};

positive: unscoped enumeration bit-field

	struct S {enum {} x : 1;};

positive: scoped enumeration bit-field

	struct S {enum class e {} x : 1;};

positive: storing boolean balue in bit-field of any positive size

	struct S {bool x : 1, y : 2, z : 100;};

negative: applying address of operator to bit-field

	struct {int m : 1;} x;
	auto y = &x.m;

# todo: binding non-const reference to bit-field

# 12.2.6 [class.nested.type] 1

negative: nested type names used outside their class without qualification example a

	struct X {
		typedef int I;
		class Y { /* ... */ };
		I a;
	};
	I b; // error

negative: nested type names used outside their class without qualification example b

	struct X {
		typedef int I;
		class Y { /* ... */ };
		I a;
	};
	Y c; // error

positive: nested type names used outside their class without qualification example c

	struct X {
		typedef int I;
		class Y { /* ... */ };
		I a;
	};
	X::Y d; // OK
	X::I e; // OK

# 12.4 [class.local] 1

positive: local class declaration

	void f () {class c;}

positive: using local class inside enclosing scope

	void f () {class c {}; c x;}

negative: using local class outside enclosing scope

	void f () {class c {};} c x;

positive: access of local class to names outside enclosing function

	int x;
	void f () {class c {int y = x;};}

negative: local class using variable with automatic storage

	void f () {int x; class c {int y = x;};}

negative: local class declarations example a

	void f() {
		int x;
		struct local {
			int g() { return x; } // error: odr-use of automatic variable x
		};
	}

positive: local class declarations example b

	int x;
	void f() {
		static int s;
		const int N = 5;
		extern int q();
		struct local {
			int h() { return s; } // OK
			int k() { return ::x; } // OK
			int l() { return q(); } // OK
	// todo:		int m() { return N; } // OK: not an odr-use
		};
	}

negative: local class declarations example c

	void f() {
		const int N = 5;
		struct local {
			int* n() { return &N; } // error: odr-use of automatic variable N
		};
	}

negative: local class declarations example d

	void f() {
		struct local {
		};
	}
	local* p = 0; // error: local not in scope

# 12.4 [class.local] 2

# todo: access to members of local class

positive: missing definition of member function of local class

	void f () {class c {void f ();};}

positive: definition of member function of local class inside its definition

	void f () {class c {void f () {}};}

negative: definition of member function of local class outside its definition

	void f () {class c {void f ();}; void c::f () {}}

positive: definition of static member function of local class inside its definition

	void f () {class c {static void f () {}};}

negative: definition of static member function of local class outside its definition

	void f () {class c {static void f ();}; void c::f () {}}

# 12.4 [class.local] 3

positive: nested class definition inside local class

	void f () {class c {class x; class x {};};}

positive: nested class definition outside local class

	void f () {class c {class x;}; class c::x {};}

negative: nested class of local class with static data member

	void f () {class c {class x {static int x;};};}

# 12.4 [class.local] 4

positive: local class with data member

	void f () {class c {class x {int x;};};}

negative: local class with static data member

	void f () {class c {class x {static int x;};};}

# 16 [over] 1

positive: overloaded function declaration

	void f (int);
	void f (char);

# todo: overloaded function template declaration

negative: overloaded variable declaration

	int v;
	char v;

negative: overloaded type declaration

	typedef int t;
	typedef char t;

# 19 [cpp] 1

positive: # preprocessing token as first character

	#

positive: # preprocessing token following white space

		#

positive: # preprocessing token following white space with deleted new-line character

		\
		#

negative: new-line character ending preprocessing directive in invocation of function-like macro

	#define M(x) x
	#line M (1
	)

# 19 [cpp] 2

negative: text line beginning with a # preprocessing token

	# int a;

# 19 [cpp] 3

positive: relaxed directive syntax in skipped group

	#if false
		#ifdef
		#elif a b c
		#else x y z
		#endif 1 2 3
		#include + -
		#define
		#undef
		#line
		#error
		#warning
	#endif

# 19 [cpp] 4

positive: white-space and horizontal-tab characters between preprocessing tokens within a preprocessing directive

	#    define	M	\

positive: spaces that have replaced comments between preprocessing tokens within a preprocessing directive

	# /* comment */ define M // comment

# 19 [cpp] 6

negative: unexpanded preprocessing tokens in preprocessing directive

	#define EMPTY
	#EMPTY

negative: sequence of preprocessing tokens example

	#define EMPTY
	EMPTY # include <iostream>

# 19.1 [cpp.cond] 1

positive: defined-macro expression with parentheses

	#if defined (asm)
	#endif

positive: defined-macro expression without parentheses

	#if defined bool
	#endif

positive: defined-macro expression using identifier

	#if defined MACRO
	#endif

positive: defined-macro expression using keyword

	#if defined true
	#endif

negative: defined-macro expression using integer

	#if defined 0
	#endif

positive: has-include expression with parentheses

	#if __has_include ("atomic")
	#endif

negative: has-include expression without parentheses

	#if __has_include "atomic"
	#endif

negative: has-include expression missing opening parenthesis

	#if __has_include "atomic")
	#endif

negative: has-include expression missing closing parenthesis

	#if __has_include ("atomic"
	#endif

positive: has-include expression using header name

	#if __has_include (<atomic>)
	#endif

negative: has-include expression using keyword

	#if __has_include (true)
	#endif

negative: has-include expression using integer

	#if __has_include (0)
	#endif

positive: integral constant expression controlling conditional inclusion

	#if 0
	#elif 1
	#endif

positive: identifier controlling conditional inclusion

	#if abc
	#elif abc
	#endif

positive: keywords controlling conditional inclusion

	#if namespace
	#elif int
	#endif

negative: string literal controlling conditional inclusion

	#if ""
	#endif

# 19.1 [cpp.cond] 2

positive: identifiers interpreted as macro names

	#if defined abc
	#endif

positive: keywords interpreted as macro names

	#if defined int
	#endif

positive: defined-macro expression on defined macro

	#define MACRO
	#if defined MACRO != 1
		#error
	#endif

positive: defined-macro expression on undefined macro

	#undef MACRO
	#if defined MACRO != 0
		#error
	#endif

# 19.1 [cpp.cond] 3

positive: has-include expression with header and replaced preprocessing tokens

	#define INCLUDE <atomic>
	#if __has_include (INCLUDE)
	#else
		#error
	#endif

positive: has-include expression with header and replaced preprocessing tokens including white space

	#define SPACE
	#define INCLUDE SPACE <atomic> SPACE
	#if __has_include (INCLUDE)
	#else
		#error
	#endif

positive: has-include expression with source file and replaced preprocessing tokens

	#define INCLUDE(header) #header
	#if __has_include (INCLUDE (atomic))
	#else
		#error
	#endif

positive: has-include expression with source file and replaced preprocessing tokens including white space

	#define SPACE
	#define INCLUDE(header) SPACE #header SPACE
	#if __has_include (INCLUDE (atomic))
	#else
		#error
	#endif

# 19.1 [cpp.cond] 4

positive: has-include expression with header

	#if __has_include (<atomic>)
	#else
		#error
	#endif

negative: has-include expression with header missing opening <

	#if __has_include (atomic>)
	#endif

negative: has-include expression with header missing header name

	#if __has_include (<>)
	#endif

negative: has-include expression with header missing closing >

	#if __has_include (<atomic)
	#endif

positive: has-include expression with source file

	#if __has_include ("atomic")
	#else
		#error
	#endif

negative: has-include expression with source file missing opening quotation mark

	#if __has_include (atomic")
	#endif

negative: has-include expression with source file missing header name

	#if __has_include ("")
	#endif

negative: has-include expression with source file missing closing quotation mark

	#if __has_include ("atomic)
	#endif

negative: has-include expression with header name beginning with digit

	#if __has_include (<1>)
	#endif

positive: has-include expression with successful header search evaluating to 1

	#if __has_include (<atomic>) == 1
	#else
		#error
	#endif

positive: has-include expression with successful source file search evaluating to 1

	#if __has_include ("atomic") == 1
	#else
		#error
	#endif

positive: has-include expression with failed header search evaluating to 0

	#if __has_include (<unknown>) == 0
	#else
		#error
	#endif

positive: has-include expression with failed source file search evaluating to 0

	#if __has_include ("unknown") == 0
	#else
		#error
	#endif

# 19.1 [cpp.cond] 5

positive: __has_include identifier appearing in #ifdef directive

	#ifdef __has_include
	#else
		#error
	#endif

positive: __has_include identifier appearing in #ifnef directive

	#ifndef __has_include
		#error
	#endif

positive: __has_include identifier appearing in defined-macro expression

	#if !defined __has_include
		#error
	#endif

negative: __has_include identifier appearing as identifier

	int __has_include;

negative: __has_include identifier appearing as attribute

	[[__has_include]];

# 19.1 [cpp.cond] 6

positive: remaining preprocessing tokens in controlling expression in lexical form of a token

	#define IDENTIFIER identifier
	#define KEYWORD namespace
	#define LITERAL 123
	#define OPERATOR (TRUE || FALSE)
	#define PUNCTUATOR (((0)))
	#if IDENTIFIER + KEYWORD + LITERAL + OPERATOR + PUNCTUATOR
	#endif

negative: invalid remaining preprocessing tokens in controlling expression

	#if @
	#endif

# 19.1 [cpp.cond] 7

negative: #if directive missing controlling expression

	#if
	#endif

positive: controlling expression of #if directive evaluating to zero

	#if 0
		#error
	#endif

negative: controlling expression of #if directive evaluating to non-zero

	#if 1
		#error
	#endif

negative: #elif directive missing controlling expression

	#if 0
	#elif
	#endif

positive: controlling expression of #elif directive evaluating to zero

	#if 0
	#elif 0
		#error
	#endif

negative: controlling expression of #elif directive evaluating to non-zero

	#if 0
	#elif 1
		#error
	#endif

# 19.1 [cpp.cond] 9

positive: replaced macro invocations in controlling expression

	#if defined M
		#error
	#endif

negative: non-replaced macro name modified by the defined-macro expression

	#define M N
	#if defined M
		#error
	#endif

positive: replacement of identifiers and keywords with preprocessing number 0

	#if abc + xyz + auto + void
		#error
	#endif

positive: non-replacement of alternative tokens in controlling expression

	#if 0 or 0
		#error
	#endif

# 19.1 [cpp.cond] 10

positive: integral controlling constant expression evaluation

	#if 0 ? 0b1 : 2 || 0x3 && '4' | +5 ^ -6 & !7 == ~8 != 9 < 10 > 11 <= 12 >= 13 << 14 >> 15 + 16 - 17 * 18 / 19 % 20
	#endif

positive: integral promotion in evaluation of subexpression of controlling expression

	#if (true == 1 && false == 0) != 1
		#error
	#endif

# 19.1 [cpp.cond] 11

negative: #ifdef directive missing identifier

	#ifdef
	#endif

positive: #ifdef directive with defined identifier

	#define MACRO
	#ifdef MACRO
		#if !defined MACRO
			#error
		#endif
	#else
		#error
	#endif

positive: #ifdef directive with undefined identifier

	#undef MACRO
	#ifdef MACRO
		#error
	#else
		#if defined MACRO
			#error
		#endif
	#endif

negative: #ifndef directive missing identifier

	#ifndef
	#endif

positive: #ifndef directive with defined identifier

	#define MACRO
	#ifndef MACRO
		#error
	#else
		#if !defined MACRO
			#error
		#endif
	#endif

positive: #ifndef directive with undefined identifier

	#undef MACRO
	#ifndef MACRO
		#if defined MACRO
			#error
		#endif
	#else
		#error
	#endif

# 19.1 [cpp.cond] 12

positive: skipping controlled preprocessing group

	#if 0
		#error
	#endif

positive: skipping nested conditionals in preprocessing group

	#if 0
		#if
		#endif
	#endif

positive: conditional inclusion evaluated in order

	#if 1
	#elif 1
		#error
	#elif 1
		#error
	#endif

	#if 0
		#error
	#elif 1
	#elif 1
		#error
	#endif

	#if 0
		#error
	#elif 0
		#error
	#elif 1
	#endif

	#if 0
		#error
	#elif 0
		#error
	#elif 0
		#error
	#endif

positive: conditional inclusion evaluated in order with #else directive

	#if 1
	#elif 1
		#error
	#elif 1
		#error
	#else
		#error
	#endif

	#if 0
		#error
	#elif 1
	#elif 1
		#error
	#else
		#error
	#endif

	#if 0
		#error
	#elif 0
		#error
	#elif 1
	#else
		#error
	#endif

	#if 0
		#error
	#elif 0
		#error
	#elif 0
		#error
	#else
	#endif

positive: missing #else directive

	#if 1
	#endif

negative: missing #endif directive

	#if 1

positive: optional library facility example

	#if __has_include(<optional>)
	# include <optional>
	# define have_optional 1
	#elif __has_include(<experimental/optional>)
	# include <experimental/optional>
	# define have_optional 1
	# define experimental_optional 1
	#else
	# define have_optional 0
	#endif

# 19.2 [cpp.include] 2

positive: header #include directive

	#include <map>

negative: header #include directive missing opening <

	#include map>

negative: header #include directive missing header name

	#include <>

negative: header #include directive missing closing >

	#include <map

# 19.2 [cpp.include] 3

positive: source file #include directive

	#include "map"

negative: source file #include directive missing opening quotation mark

	#include map"

negative: source file #include directive missing header name

	#include ""

negative: source file #include directive missing closing quotation mark

	#include "map

# 19.2 [cpp.include] 4

positive: header #include directive with replaced preprocessing tokens

	#define INCLUDE <thread>
	#include INCLUDE

positive: header #include directive with replaced preprocessing tokens including white space

	#define SPACE
	#define INCLUDE SPACE <thread> SPACE
	#include INCLUDE

positive: source file #include directive with replaced preprocessing tokens

	#define INCLUDE(header) #header
	#include INCLUDE (thread)

positive: source file #include directive with replaced preprocessing tokens including white space

	#define SPACE
	#define INCLUDE(header) SPACE #header SPACE
	#include INCLUDE (thread)

# 19.2 [cpp.include] 5

negative: header name in #include directive beginning with digit

	#include <1>

# 19.2 [cpp.include] 7

positive: #include directives example

	#include <stdio.h>
	#include <stddef.h> // <unistd.h>
	#include "stdio.h" // "usefullib.h"
	#include "stddef.h" // "myprog.h"

# 19.2 [cpp.include] 8

positive: macro-replaced #include directives example

	#if VERSION == 1
		#define INCFILE <chrono> // "vers1.h"
	#elif VERSION == 2
		#define INCFILE <new> // "vers2.h" // and so on
	#else
		#define INCFILE <vector> // "versN.h"
	#endif
	#include INCFILE

# 19.3 [cpp.replace] 1

positive: identical replacement lists

	#define M for 100 : [virtual]
	#define M for 100 : [virtual]

negative: replacement lists with different number of preprocessing tokens

	#define M for 100 : [virtual]
	#define M for 100 : [virtual] ?

negative: replacement lists with different ordering of preprocessing tokens

	#define M for 100 : [virtual]
	#define M for : 100 [virtual]

negative: replacement lists with different spelling of preprocessing tokens

	#define M for 100 : [virtual]
	#define M for 100 : <:virtual]

negative: replacement lists with different white-space separation

	#define M for 100 : [virtual]
	#define M for 100 : [ virtual ]

positive: replacement lists with identical white-space separation

	#define M for 100 : [virtual]
	#define M for	100	:	[virtual]	\

# 19.3 [cpp.replace] 2

positive: redefinition of object-like macro with empty replacement list

	#define M
	#define M

positive: redefinition of object-like macro with identical replacement list

	#define M a + b
	#define M a + b

negative: redefinition of object-like macro with different replacement list

	#define M a + b
	#define M a - b

negative: redefinition of object-like macro with function-like macro

	#define M a + b
	#define M() a + b

positive: redefinition of function-like macro with empty parameters

	#define M() a + b
	#define M() a + b

positive: redefinition of function-like macro with identical parameters

	#define M(a, b) a + b
	#define M(a, b) a + b

negative: redefinition of function-like macro with different number of parameters

	#define M(a) a + b
	#define M(a, b) a + b

negative: redefinition of function-like macro with different ordering of parameters

	#define M(b, a) a + b
	#define M(a, b) a + b

negative: redefinition of function-like macro with different spelling of parameters

	#define M(a, b) a + b
	#define M(a, c) a + b

positive: redefinition of function-like macro with empty replacement list

	#define M()
	#define M()

positive: redefinition of function-like macro with identical replacement list

	#define M() a + b
	#define M() a + b

negative: redefinition of function-like macro with different replacement list

	#define M() a + b
	#define M() a - b

negative: redefinition of function-like macro with object-like macro

	#define M() a + b
	#define M a + b

# 19.3 [cpp.replace] 3

positive: definition of object-like macro with intervening white space

	#define M +
	#define M/* */+
	#define M	+

negative: definition of object-like macro without intervening white space

	#define M+

# 19.3 [cpp.replace] 4

positive: invocation of function-like macro without ellipsis with same number of arguments

	#define F(a, b, c)
	F (1, 2, 3)

positive: invocation of function-like macro without ellipsis with same number of arguments consisting of no preprocessing tokens

	#define F(a, b, c)
	F (,,)

negative: invocation of function-like macro without ellipsis with more arguments

	#define F(a, b, c)
	F (1, 2, 3, 4)

negative: invocation of function-like macro without ellipsis with less arguments

	#define F(a, b, c)
	F (1, 2)

negative: invocation of function-like macro with ellipsis with same number of arguments

	#define F(a, b, c, ...)
	F (1, 2, 3)

positive: invocation of function-like macro with ellipsis with more arguments

	#define F(a, b, c, ...)
	F (1, 2, 3, 4)

negative: invocation of function-like macro with ellipsis with less arguments

	#define F(a, b, c, ...)
	F (1, 2)

negative: invocation of function-like macro without closing parenthesis

	#define F(a, b, c)
	F (1, 2, 3

# 19.3 [cpp.replace] 5

negative: __VA_ARGS__ in replacement of object-like macro

	#define M __VA_ARGS__

negative: __VA_ARGS__ in replacement of function-like macro without ellipsis

	#define M() __VA_ARGS__

positive: __VA_ARGS__ in replacement of function-like macro with ellipsis

	#define M(...) __VA_ARGS__

# 19.3 [cpp.replace] 6

positive: unique parameter identifier in a function-like macro

	#define F(a, b)

negative: duplicated parameter identifier in a function-like macro

	#define F(a, a)

# 19.3 [cpp.replace] 7

negative: macro definition missing macro name

	#define

negative: macro redefinition in different namespace

	#define M a
	namespace N {
		#define M b
	}

positive: replacement list with identical preceding white space in object-like macro

	#define M .
	#define M/* */.
	#define M	.

positive: replacement list with identical following white space in object-like macro

	#define M . //
	#define M . /* */ //
	#define M .	//

positive: replacement list with identical preceding white space in function-like macro

	#define M() .
	#define M()/* */.
	#define M()	.

positive: replacement list with identical following white space in function-like macro

	#define M() . //
	#define M() . /* */ //
	#define M() .	//

positive: ignored white space preceding and following replacement list of object-like macro

	#define STR(x) #x
	#define STRING(x) STR(x)
	#define M    abc   \
	static_assert (sizeof STRING (M) == 4);

positive: ignored white space preceding and following replacement list of function-like macro

	#define STR(x) #x
	#define STRING(x) STR(x)
	#define M(x)    x   \
	static_assert (sizeof STRING (M(abc)) == 4);

# 19.3 [cpp.replace] 8

negative: non-replaced directive identifier

	#define M
	#M

# 19.3 [cpp.replace] 9

positive: object-like macro definition

	# define ASSERTION true, ""
	static_assert (ASSERTION);

negative: object-like macro definition missing identifier

	#define

positive: non-replaced macro names in character literals

	#define M m
	static_assert ('M' != 'm');

positive: non-replaced macro names in string literals

	#define M hello
	static_assert (sizeof "M" == 2);

negative: macro definition using alternate token as name

	#define and hello

# 19.3 [cpp.replace] 10

positive: function-like macro definition

	# define F()
	F()

negative: function-like macro definition missing identifier

	# define ()

negative: function-like macro definition missing left parenthesis

	# define F)

negative: function-like macro definition with left parenthesis and intervening white space

	# define F ()
	F()

negative: function-like macro definition missing right parenthesis

	# define F(

positive: function-like macro definition without parameters

	# define F()

negative: function-like macro definition without parameters with trailing comma

	# define F(,)

positive: function-like macro definition without parameters with ellipsis

	# define F(...)

negative: function-like macro definition without parameters with ellipsis and preceding comma

	# define F(,...)

negative: function-like macro definition without parameters with ellipsis and trailing comma

	# define F(...,)

positive: function-like macro definition with parameter

	# define F(a)

negative: function-like macro definition with parameter and trailing comma

	# define F(a,)

negative: function-like macro definition with parameter and ellipsis

	# define F(a...)

positive: function-like macro definition with parameter and ellipsis with preceding comma

	# define F(a,...)

negative: function-like macro definition with parameter and ellipsis with trailing comma

	# define F(a...,)

positive: function-like macro definition with parameters

	# define F(a)

negative: function-like macro definition with parameters and trailing comma

	# define F(a,b,)

negative: function-like macro definition with parameters and ellipsis

	# define F(a,b...)

positive: function-like macro definition with parameters and ellipsis with preceding comma

	# define F(a,b,...)

negative: function-like macro definition with parameters and ellipsis with trailing comma

	# define F(a,b...,)

negative: function-like macro definition with missing parameter names

	# define F(,)

negative: macro parameter extending its scope after new-line character

	# define F(n) int n
	F(a) = n;

positive: function-like macro invocation

	#define F(x) x + 1 ==
	static_assert (F(3) 4);

positive: function-like macro invocation with parentheses

	#define F() int a
	F();

negative: function-like macro invocation missing left parenthesis

	#define F() int a
	F);

negative: function-like macro invocation missing right parenthesis

	#define F() int a
	F(;

negative: function-like macro invocation missing parentheses

	#define F() int a
	F;

positive: function-like macro invocation with matched parentheses

	#define F(t, n) t n
	F(int, ((a)));

negative: function-like macro invocation with mismatched parentheses

	#define F(t, n) t n
	F((int, (a)));

positive: function-like macro invocation with new-line characters

	#define F(t, n) t n
	F(
	int
	,a
	);

# 19.3 [cpp.replace] 11

positive: function-like macro arguments with outside-most matching parentheses

	#define F(a, b, c)
	F(x, y, z)

negative: function-like macro arguments with outside-most mismatching parentheses

	#define F(a, b, c)
	F((x, y, z))

positive: comma separated preprocessing tokens as function-like macro arguments

	#define F(a, b, c)
	F(x y z, 0 1 2, | & ^)

positive: function-like macro arguments with inner parentheses

	#define F(a, b, c)
	F((x, y, z), (0, 1, 2), (|, &, ^))

# 19.3 [cpp.replace] 12

positive: merged function-like macro argument

	#define F(x, ...) x G(__VA_ARGS__)
	#define G(a) a
	F(int, c);

positive: merged function-like macro arguments

	#define F(x, ...) x G(__VA_ARGS__)
	#define G(a, b) a b
	F([[]], int, c);

# 19.3.1 [cpp.subst] 1

positive: simple marco argument substitution

	#define F(a, b) a b
	F (int, x);

positive: complex marco argument substitution

	#define F(a, b) a b
	F (int, x[10]);

positive: expanded marco argument substitution

	#define A(n) x[n]
	#define F(a, b) a b
	F (int, A (10));

# 19.3.1 [cpp.subst] 2

positive: identifier __VA_ARGS__ treated as macro parameter

	#define F(...) __VA_ARGS__
	static_assert (F (true, ""));
	#define G(...) #__VA_ARGS__
	static_assert (sizeof G ( a , b ) == 6);

# 19.3.2 [cpp.stringize] 1

positive: # preprocessing token in replacement list for function-like macro followed by a parameter

	#define F(a) #a

positive: # preprocessing token in replacement list for function-like macro followed by a parameter with intervening white space

	#define F(a) # a

negative: # preprocessing token in replacement list for function-like macro not followed by a parameter

	#define F() #a

negative: # preprocessing token in replacement list for function-like macro not followed by a identifier

	#define F() #

# 19.3.2 [cpp.stringize] 2

positive: macro parameter replaced by character string literal

	#define F(x) x #x
	static_assert (F (12 - sizeof) == 0);

positive: macro parameter replaced by single character string literal

	#define F(x) #x
	decltype (F (asdf)) s;
	extern const char s[5];

positive: concatenation of macro parameter replaced by character string literal

	#define STATIC_ASSERT(x) static_assert (x, "static_assertion '" #x "' failed")
	STATIC_ASSERT (true);

positive: trimmed white space in macro argument replaced by character string literal

	#define F(x) #x
	static_assert (sizeof F (a    b		c) == 6);

positive: deleted white space before first preprocessing token of macro argument replaced by character string literal

	#define F(x) #x
	static_assert (sizeof F (      a) == 2);

positive: deleted white space after last preprocessing token of macro argument replaced by character string literal

	#define F(x) #x
	static_assert (sizeof F (a      ) == 2);

positive: retaining spelling of processing tokens of macro argument replaced by character string literal

	#define F(x) #x
	static_assert (sizeof F (&&) == 3);
	static_assert (sizeof F (and) == 4);
	static_assert (sizeof F (asm) == 4);

positive: retaining spelling of string literal in macro argument replaced by character string literal

	#define F(x) #x
	static_assert (sizeof F ("abc") == 6);

positive: retaining spelling of character literal in macro argument replaced by character string literal

	#define F(x) #x
	static_assert (sizeof F ('a') == 4);

positive: empty macro argument replaced by empty character string literal

	#define F(x) #x
	static_assert (sizeof F () == 1);

# 19.3.3 [cpp.concat] 1

negative: object-like macro definition consisting of ## preprocessing token

	#define M ##

negative: object-like macro definition beginning with ## preprocessing token

	#define M ## abc

negative: object-like macro definition ending with ## preprocessing token

	#define M abc ##

negative: function-like macro definition consisting of ## preprocessing token

	#define F() ##

negative: function-like macro definition beginning with ## preprocessing token

	#define F() ## abc

negative: function-like macro definition ending with ## preprocessing token

	#define F() abc ##

# 19.3.3 [cpp.concat] 2

positive: macro parameter immediately followed by a ## preprocessing token

	#define F(x) x##bc
	F (int a);

positive: macro parameter immediately followed by a ## preprocessing token with white space

	#define F(x) x ## bc
	F (int a);

positive: macro parameter immediately preceded by a ## preprocessing token

	#define F(x) in##x
	F (t a);

positive: macro parameter immediately preceded by a ## preprocessing token with white space

	#define F(x) in ## x
	F (t a);

positive: empty macro argument before ## preprocessing token

	#define F(x) x##int a
	F ();

positive: empty macro argument before ## preprocessing token with white space

	#define F(x) x ## int a
	F ();

positive: empty macro argument after ## preprocessing token

	#define F(x) int##x a
	F ();

positive: empty macro argument after ## preprocessing token with white space

	#define F(x) int ## x a
	F ();

# 19.3.3 [cpp.concat] 3

positive: concatenation of preprocessing tokens in object-like macro

	#define M A##B
	#define AB int
	M x;

positive: concatenation of preprocessing tokens in function-like macro

	#define F(x, y) x##y
	#define AB int
	F (A, B) x;

negative: non-concatenation of ## preprocessing token

	in##t x;

negative: non-concatenation of ## preprocessing token in macro argument

	#define F(a) a
	F (in##t) x;

positive: concatenation of two placemarker preprocessing tokens

	#define F(x, y)	x##y
	F(,)

positive: concatenation of single placemarker preprocessing token

	#define F(x, y)	x##y
	F (int,) x;
	F (,int) y;

positive: hash hash example

	#define hash_hash # ## #
	#define mkstr(a) # a
	#define in_between(a) mkstr(a)
	#define join(c, d) in_between(c hash_hash d)
	const char* p = join(x, y); // equivalent to char p[] = "x ## y";

# 19.3.4 [cpp.rescan] 1

positive: removal of placemarker preprocessing tokens

	#define F(x)
	#define G(x, y) x##y
	F () int G (,) x F ();

positive: replacement of object-like macro given as macro argument

	#define F(x) x
	#define M int
	F (M) x;

positive: replacement of function-like macro given as macro argument

	#define F(x, y) x (y)
	#define G(y) y
	F (G, int) x;

# 19.3.4 [cpp.rescan] 2

positive: non-replacement of object-like macro being replaced

	#define M int M
	M;

positive: nested non-replacement of object-like macro being replaced

	#define M int N
	#define N M
	M;

positive: non-replacement of function-like macro being replaced

	#define F(x) x F (x)
	F (int);

positive: nested non-replacement of function-like macro being replaced

	#define F(x) x G (x)
	F (int);

# 19.3.4 [cpp.rescan] 3

negative: completely macro-replaced preprocessing token sequence resulting in preprocessing directive

	#define F(x, y) x y
	F (#, define) M

# 19.3.5 [cpp.scope] 1

positive: macro definition lasting until the end of the translation unit

	#define M
	#include <string>
	#ifndef M
		#error
	#endif

positive: macro definition lasting until corresponding #undef directive

	#define M
	#include <string>
	#undef M
	#ifdef M
		#error
	#endif

# 19.3.5 [cpp.scope] 2

positive: undefinition of defined macro name

	#define M
	#undef M
	#ifdef M
		#error
	#endif

positive: undefinition of undefined macro name

	#undef M
	#ifdef M
		#error
	#endif

# 19.3.5 [cpp.scope] 3

positive: manifest constant example

	#define TABSIZE 100
	int table[TABSIZE];

# 19.3.5 [cpp.scope] 4

positive: maximum of arguments function-like macro example

	#define max(a, b) ((a) > (b) ? (a) : (b))
	int x = max (1 + 2, 3 + 4);

# todo: 19.3.5 [cpp.scope] 5
# todo: 19.3.5 [cpp.scope] 6
# todo: 19.3.5 [cpp.scope] 7
# todo: 19.3.5 [cpp.scope] 8
# todo: 19.3.5 [cpp.scope] 9

# 19.4 [cpp.line] 1

positive: #line directive with character string literal

	#line 1 "file"

negative: #line directive with UTF-8 string literal

	#line 1 u8"file"

negative: #line directive with char16_t string literal

	#line 1 u"file"

negative: #line directive with char32_t string literal

	#line 1 U"file"

negative: #line directive with wide string literal

	#line 1 L"file"

# 19.4 [cpp.line] 2

positive: line number equals to number of read new-line characters plus one

	static_assert (__LINE__ == 1);
	static_assert (__LINE__ == 2); \
	static_assert (__LINE__ == 3);

# 19.4 [cpp.line] 3

negative: #line directive missing digit sequence

	#line

positive: #line directive with digit sequence

	#line 123456789
	static_assert (__LINE__ == 123456789);

negative: #line directive with binary digit sequence

	#line 0b0110

positive: #line directive with octal digit sequence interpreted as decimal number

	#line 01234
	static_assert (__LINE__ == 1234);

positive: #line directive with decimal digit sequence

	#line 1234

negative: #line directive with hexadecimal digit sequence

	#line 0x1234

positive: #line directive with digit sequence containing single quotes

	#line 12'34'56
	static_assert (__LINE__ == 123456);

positive: #line directive with digit sequence specifying one

	#line 1

positive: #line directive with digit sequence specifying 2147483647

	#line 2147483647

# 19.4 [cpp.line] 4

positive: #line directive with source filename

	#line 1234 "file"
	static_assert (__LINE__ == 1234);
	static_assert (sizeof __FILE__ == 5);

positive: #line directive with empty source filename

	#line 1234 ""
	static_assert (__LINE__ == 1234);
	static_assert (sizeof __FILE__ == 1);

# 19.4 [cpp.line] 5

positive: #line directive with macro replaced digit sequence

	#line __LINE__
	#define M __LINE__
	#line M
	static_assert (__LINE__ == 2);

positive: #line directive with macro replaced character string literal

	#line __LINE__ __FILE__
	#define F(x, y) x #y
	#line F (__LINE__, source)
	static_assert (__LINE__ == 2);

# 19.5 [cpp.error] 1

negative: #error directive without preprocessing tokens

	# error

negative: #error directive with preprocessing tokens

	# error error

positive: #warning directive without preprocessing tokens

	# warning

positive: #warning directive with preprocessing tokens

	# warning warning

# 19.6 [cpp.pragma] 1

positive: unknown pragmas

	# pragma
	# pragma not recognized

# 19.7 [cpp.null] 1

positive: null directive

	#

# 19.8 [cpp.predefined] 1

positive: predefined __cplusplus macro name

	#ifndef __cplusplus
		#error
	#endif
	static_assert (__cplusplus == 202302L);

positive: predefined __DATE__ macro name

	#ifndef __DATE__
		#error
	#endif
	static_assert (sizeof __DATE__ == 12);

positive: predefined __FILE__ macro name

	#ifndef __FILE__
		#error
	#endif
	static_assert (sizeof __FILE__ >= 1);

positive: predefined __LINE__ macro name

	#ifndef __LINE__
		#error
	#endif
	static_assert (__LINE__ == 4);
	static_assert (__LINE__ == 5);

positive: predefined __LINE__ macro in single-line macro definition

	#define M __LINE__

	static_assert (M == 3);
	static_assert (M == 4);

positive: predefined __LINE__ macro at beginning of multi-line macro definition

	#define M __LINE__ \

	static_assert (M == 3);
	static_assert (M == 4);

positive: predefined __LINE__ macro at end of multi-line macro definition

	#define M \
		__LINE__
	static_assert (M == 3);
	static_assert (M == 4);

positive: predefined __STDC_HOSTED__ macro name

	#ifndef __STDC_HOSTED__
		#error
	#endif
	static_assert (__STDC_HOSTED__ == 0 || __STDC_HOSTED__ == 1);

positive: predefined __STDCPP_DEFAULT_NEW_ALIGNMENT__ macro name

	#ifndef __STDCPP_DEFAULT_NEW_ALIGNMENT__
		#error
	#endif
	static_assert (__STDCPP_DEFAULT_NEW_ALIGNMENT__ >= 1);

positive: predefined __TIME__ macro name

	#ifndef __TIME__
		#error
	#endif

# 19.8 [cpp.predefined] 2

positive: predefined __STDCPP_STRICT_POINTER_SAFETY__ macro name

	#ifdef __STDCPP_STRICT_POINTER_SAFETY__
		static_assert (__STDCPP_STRICT_POINTER_SAFETY__ == 1);
	#endif

positive: predefined __STDCPP_THREADS__ macro name

	#ifdef __STDCPP_THREADS__
		static_assert (__STDCPP_THREADS__ == 1);
	#endif

# 19.9 [cpp.pragma.op] 1

positive: pragma operator with empty string literal

	_Pragma ("")

positive: pragma operator with empty wide string literal

	_Pragma (L"")

negative: pragma operator missing opening parenthesis

	_Pragma "")

negative: pragma operator missing string literal

	_Pragma ()

negative: pragma operator missing closing parenthesis

	_Pragma (""

# 19.9 [cpp.pragma.op] 2

positive: pragma operator example

	#pragma listing on "../listing.dir"
	_Pragma ( "listing on \"../listing.dir\"" )
	#define LISTING(x) PRAGMA(listing on #x)
	#define PRAGMA(x) _Pragma(#x)
	LISTING( ../listing.dir )

# 20.5.1.2 [headers] 2

positive: 88 C++ library headers

	#include <algorithm>
	#include <any>
	#include <array>
	#include <atomic>
	#include <barrier>
	#include <bit>
	#include <bitset>
	#include <charconv>
	#include <chrono>
	#include <codecvt>
	#include <compare>
	#include <complex>
	#include <concepts>
	#include <condition_variable>
	#include <coroutine>
	#include <deque>
	#include <exception>
	#include <execution>
	#include <expected>
	#include <filesystem>
	#include <flat_map>
	#include <flat_set>
	#include <format>
	#include <forward_list>
	#include <fstream>
	#include <functional>
	#include <future>
	#include <generator>
	#include <initializer_list>
	#include <iomanip>
	#include <ios>
	#include <iosfwd>
	#include <iostream>
	#include <istream>
	#include <iterator>
	#include <latch>
	#include <limits>
	#include <list>
	#include <locale>
	#include <map>
	#include <mdspan>
	#include <memory>
	#include <memory_resource>
	#include <mutex>
	#include <new>
	#include <numbers>
	#include <numeric>
	#include <optional>
	#include <ostream>
	#include <print>
	#include <queue>
	#include <random>
	#include <ranges>
	#include <ratio>
	#include <rcu>
	#include <regex>
	#include <scoped_allocator>
	#include <semaphore>
	#include <set>
	#include <shared_mutex>
	#include <source_location>
	#include <span>
	#include <spanstream>
	#include <sstream>
	#include <stack>
	#include <stacktrace>
	#include <stdexcept>
	#include <stdfloat>
	#include <stop_token>
	#include <streambuf>
	#include <string>
	#include <string_view>
	#include <strstream>
	#include <syncstream>
	#include <system_error>
	#include <text_encoding>
	#include <thread>
	#include <tuple>
	#include <type_traits>
	#include <typeindex>
	#include <typeinfo>
	#include <unordered_map>
	#include <unordered_set>
	#include <utility>
	#include <valarray>
	#include <variant>
	#include <vector>
	#include <version>

# 20.5.1.2 [headers] 3

positive: 21 additional library headers

	#include <cassert>
	#include <cctype>
	#include <cerrno>
	#include <cfenv>
	#include <cfloat>
	#include <cinttypes>
	#include <climits>
	#include <clocale>
	#include <cmath>
	#include <csetjmp>
	#include <csignal>
	#include <cstdarg>
	#include <cstddef>
	#include <cstdint>
	#include <cstdio>
	#include <cstdlib>
	#include <cstring>
	#include <ctime>
	#include <cuchar>
	#include <cwchar>
	#include <cwctype>

# 20.5.1.3 [compliance] 2

positive: available library headers in freestanding implementations

	#include <cstddef>
	#include <cfloat>
	#include <climits>
	#include <limits>
	#include <version>
	#include <cstdint>
	#include <cstdlib>
	#include <new>
	#include <typeinfo>
	#include <source_location>
	#include <exception>
	#include <initializer_list>
	#include <compare>
	#include <coroutine>
	#include <cstdarg>
	#include <concepts>
	#include <type_traits>
	#include <bit>
	#include <atomic>
	#include <utility>
	#include <tuple>
	#include <memory>
	#include <functional>
	#include <ratio>
	#include <iterator>
	#include <ranges>

# todo: 20.5.1.3 [compliance] 3

# 20.5.2.2 [using.headers] 2

positive: including library headers twice in any order

	#include <cstdarg>
	#include <cerrno>
	#include <array>
	#include <format>
	#include <ostream>
	#include <climits>
	#include <cwctype>
	#include <iso646.h>
	#include <variant>
	#include <spanstream>
	#include <complex.h>
	#include <generator>
	#include <assert.h>
	#include <uchar.h>
	#include <initializer_list>
	#include <csetjmp>
	#include <limits>
	#include <vector>
	#include <stack>
	#include <complex>
	#include <wctype.h>
	#include <span>
	#include <list>
	#include <math.h>
	#include <limits.h>
	#include <istream>
	#include <charconv>
	#include <flat_set>
	#include <typeinfo>
	#include <stdio.h>
	#include <cstdint>
	#include <sstream>
	#include <ios>
	#include <ratio>
	#include <type_traits>
	#include <text_encoding>
	#include <fenv.h>
	#include <iostream>
	#include <stdfloat>
	#include <source_location>
	#include <inttypes.h>
	#include <stop_token>
	#include <future>
	#include <float.h>
	#include <algorithm>
	#include <clocale>
	#include <typeindex>
	#include <stacktrace>
	#include <stdint.h>
	#include <string>
	#include <semaphore>
	#include <forward_list>
	#include <unordered_map>
	#include <exception>
	#include <syncstream>
	#include <new>
	#include <functional>
	#include <expected>
	#include <unordered_set>
	#include <thread>
	#include <cctype>
	#include <setjmp.h>
	#include <stdatomic.h>
	#include <print>
	#include <bit>
	#include <optional>
	#include <barrier>
	#include <csignal>
	#include <scoped_allocator>
	#include <regex>
	#include <chrono>
	#include <cassert>
	#include <errno.h>
	#include <ctype.h>
	#include <shared_mutex>
	#include <ranges>
	#include <strstream>
	#include <wchar.h>
	#include <any>
	#include <random>
	#include <valarray>
	#include <set>
	#include <memory>
	#include <fstream>
	#include <cmath>
	#include <version>
	#include <rcu>
	#include <cwchar>
	#include <system_error>
	#include <condition_variable>
	#include <atomic>
	#include <locale>
	#include <codecvt>
	#include <latch>
	#include <streambuf>
	#include <cinttypes>
	#include <stddef.h>
	#include <cfenv>
	#include <map>
	#include <cstddef>
	#include <cfloat>
	#include <utility>
	#include <memory_resource>
	#include <flat_map>
	#include <tgmath.h>
	#include <iterator>
	#include <stdbool.h>
	#include <cstdlib>
	#include <string_view>
	#include <stdarg.h>
	#include <cuchar>
	#include <locale.h>
	#include <bitset>
	#include <iomanip>
	#include <queue>
	#include <stdalign.h>
	#include <compare>
	#include <mdspan>
	#include <coroutine>
	#include <cstring>
	#include <filesystem>
	#include <ctime>
	#include <numbers>
	#include <string.h>
	#include <signal.h>
	#include <execution>
	#include <stdlib.h>
	#include <iosfwd>
	#include <tuple>
	#include <numeric>
	#include <deque>
	#include <stdexcept>
	#include <cstdio>
	#include <concepts>
	#include <mutex>
	#include <time.h>

	#include <typeindex>
	#include <filesystem>
	#include <span>
	#include <iostream>
	#include <cstdio>
	#include <iomanip>
	#include <shared_mutex>
	#include <locale.h>
	#include <mutex>
	#include <cinttypes>
	#include <any>
	#include <cmath>
	#include <stop_token>
	#include <stdarg.h>
	#include <text_encoding>
	#include <csetjmp>
	#include <tgmath.h>
	#include <cctype>
	#include <algorithm>
	#include <flat_map>
	#include <complex>
	#include <variant>
	#include <condition_variable>
	#include <signal.h>
	#include <iosfwd>
	#include <limits.h>
	#include <thread>
	#include <stdint.h>
	#include <coroutine>
	#include <codecvt>
	#include <optional>
	#include <unordered_set>
	#include <cerrno>
	#include <string_view>
	#include <cstdlib>
	#include <string.h>
	#include <math.h>
	#include <expected>
	#include <generator>
	#include <system_error>
	#include <cuchar>
	#include <istream>
	#include <iso646.h>
	#include <wchar.h>
	#include <wctype.h>
	#include <type_traits>
	#include <charconv>
	#include <ostream>
	#include <complex.h>
	#include <scoped_allocator>
	#include <syncstream>
	#include <stdfloat>
	#include <stdalign.h>
	#include <spanstream>
	#include <regex>
	#include <string>
	#include <array>
	#include <chrono>
	#include <csignal>
	#include <list>
	#include <cstdint>
	#include <compare>
	#include <exception>
	#include <unordered_map>
	#include <stdlib.h>
	#include <streambuf>
	#include <cfenv>
	#include <cfloat>
	#include <functional>
	#include <bit>
	#include <ratio>
	#include <format>
	#include <map>
	#include <stack>
	#include <stacktrace>
	#include <climits>
	#include <errno.h>
	#include <execution>
	#include <cstring>
	#include <queue>
	#include <iterator>
	#include <semaphore>
	#include <ctime>
	#include <limits>
	#include <new>
	#include <sstream>
	#include <stdbool.h>
	#include <ranges>
	#include <forward_list>
	#include <barrier>
	#include <fstream>
	#include <stdatomic.h>
	#include <flat_set>
	#include <stdio.h>
	#include <cstdarg>
	#include <stddef.h>
	#include <print>
	#include <valarray>
	#include <cstddef>
	#include <latch>
	#include <typeinfo>
	#include <float.h>
	#include <set>
	#include <clocale>
	#include <version>
	#include <initializer_list>
	#include <strstream>
	#include <ios>
	#include <memory>
	#include <utility>
	#include <bitset>
	#include <fenv.h>
	#include <assert.h>
	#include <stdexcept>
	#include <vector>
	#include <tuple>
	#include <time.h>
	#include <memory_resource>
	#include <uchar.h>
	#include <numbers>
	#include <ctype.h>
	#include <cwctype>
	#include <concepts>
	#include <locale>
	#include <atomic>
	#include <source_location>
	#include <future>
	#include <setjmp.h>
	#include <random>
	#include <cassert>
	#include <cwchar>
	#include <inttypes.h>
	#include <mdspan>
	#include <deque>
	#include <rcu>
	#include <numeric>

# 20.5.4.3.2 [macro.names] 2

negative: definition of macro name identical to alignas keyword

	#define alignas

negative: definition of macro name identical to alignof keyword

	#define alignof

negative: definition of macro name identical to asm keyword

	#define asm

negative: definition of macro name identical to auto keyword

	#define auto

negative: definition of macro name identical to bool keyword

	#define bool

negative: definition of macro name identical to break keyword

	#define break

negative: definition of macro name identical to case keyword

	#define case

negative: definition of macro name identical to catch keyword

	#define catch

negative: definition of macro name identical to char keyword

	#define char

negative: definition of macro name identical to char8_t keyword

	#define char8_t

negative: definition of macro name identical to char16_t keyword

	#define char16_t

negative: definition of macro name identical to char32_t keyword

	#define char32_t

negative: definition of macro name identical to class keyword

	#define class

negative: definition of macro name identical to concept keyword

	#define concept

negative: definition of macro name identical to const keyword

	#define const

negative: definition of macro name identical to consteval keyword

	#define consteval

negative: definition of macro name identical to constexpr keyword

	#define constexpr

negative: definition of macro name identical to constinit keyword

	#define constinit

negative: definition of macro name identical to const_cast keyword

	#define const_cast

negative: definition of macro name identical to continue keyword

	#define continue

negative: definition of macro name identical to co_await keyword

	#define co_await

negative: definition of macro name identical to co_return keyword

	#define co_return

negative: definition of macro name identical to co_yield keyword

	#define co_yield

negative: definition of macro name identical to decltype keyword

	#define decltype

negative: definition of macro name identical to default keyword

	#define default

negative: definition of macro name identical to delete keyword

	#define delete

negative: definition of macro name identical to do keyword

	#define do

negative: definition of macro name identical to double keyword

	#define double

negative: definition of macro name identical to dynamic_cast keyword

	#define dynamic_cast

negative: definition of macro name identical to else keyword

	#define else

negative: definition of macro name identical to enum keyword

	#define enum

negative: definition of macro name identical to explicit keyword

	#define explicit

negative: definition of macro name identical to export keyword

	#define export

negative: definition of macro name identical to extern keyword

	#define extern

negative: definition of macro name identical to false keyword

	#define false

negative: definition of macro name identical to float keyword

	#define float

negative: definition of macro name identical to for keyword

	#define for

negative: definition of macro name identical to friend keyword

	#define friend

negative: definition of macro name identical to goto keyword

	#define goto

negative: definition of macro name identical to if keyword

	#define if

negative: definition of macro name identical to inline keyword

	#define inline

negative: definition of macro name identical to int keyword

	#define int

negative: definition of macro name identical to long keyword

	#define long

negative: definition of macro name identical to mutable keyword

	#define mutable

negative: definition of macro name identical to namespace keyword

	#define namespace

negative: definition of macro name identical to new keyword

	#define new

negative: definition of macro name identical to noexcept keyword

	#define noexcept

negative: definition of macro name identical to nullptr keyword

	#define nullptr

negative: definition of macro name identical to operator keyword

	#define operator

negative: definition of macro name identical to private keyword

	#define private

negative: definition of macro name identical to protected keyword

	#define protected

negative: definition of macro name identical to public keyword

	#define public

negative: definition of macro name identical to register keyword

	#define register

negative: definition of macro name identical to reinterpret_cast keyword

	#define reinterpret_cast

negative: definition of macro name identical to requires keyword

	#define requires

negative: definition of macro name identical to return keyword

	#define return

negative: definition of macro name identical to short keyword

	#define short

negative: definition of macro name identical to signed keyword

	#define signed

negative: definition of macro name identical to sizeof keyword

	#define sizeof

negative: definition of macro name identical to static keyword

	#define static

negative: definition of macro name identical to static_assert keyword

	#define static_assert

negative: definition of macro name identical to static_cast keyword

	#define static_cast

negative: definition of macro name identical to struct keyword

	#define struct

negative: definition of macro name identical to switch keyword

	#define switch

negative: definition of macro name identical to template keyword

	#define template

negative: definition of macro name identical to this keyword

	#define this

negative: definition of macro name identical to thread_local keyword

	#define thread_local

negative: definition of macro name identical to throw keyword

	#define throw

negative: definition of macro name identical to true keyword

	#define true

negative: definition of macro name identical to try keyword

	#define try

negative: definition of macro name identical to typedef keyword

	#define typedef

negative: definition of macro name identical to typeid keyword

	#define typeid

negative: definition of macro name identical to typename keyword

	#define typename

negative: definition of macro name identical to union keyword

	#define union

negative: definition of macro name identical to unsigned keyword

	#define unsigned

negative: definition of macro name identical to using keyword

	#define using

negative: definition of macro name identical to virtual keyword

	#define virtual

negative: definition of macro name identical to void keyword

	#define void

negative: definition of macro name identical to volatile keyword

	#define volatile

negative: definition of macro name identical to wchar_t keyword

	#define wchar_t

negative: definition of macro name identical to while keyword

	#define while

negative: definition of macro name identical to final identifier

	#define final

negative: definition of macro name identical to override identifier

	#define override

negative: definition of macro name identical to noreturn attribute

	#define noreturn

negative: definition of macro name identical to carries_dependency attribute

	#define carries_dependency

negative: definition of macro name identical to deprecated attribute

	#define deprecated

negative: undefinition of macro name identical to alignas keyword

	#undef alignas

negative: undefinition of macro name identical to alignof keyword

	#undef alignof

negative: undefinition of macro name identical to asm keyword

	#undef asm

negative: undefinition of macro name identical to auto keyword

	#undef auto

negative: undefinition of macro name identical to bool keyword

	#undef bool

negative: undefinition of macro name identical to break keyword

	#undef break

negative: undefinition of macro name identical to case keyword

	#undef case

negative: undefinition of macro name identical to catch keyword

	#undef catch

negative: undefinition of macro name identical to char keyword

	#undef char

negative: undefinition of macro name identical to char8_t keyword

	#undef char8_t

negative: undefinition of macro name identical to char16_t keyword

	#undef char16_t

negative: undefinition of macro name identical to char32_t keyword

	#undef char32_t

negative: undefinition of macro name identical to class keyword

	#undef class

negative: undefinition of macro name identical to concept keyword

	#undef concept

negative: undefinition of macro name identical to const keyword

	#undef const

negative: undefinition of macro name identical to consteval keyword

	#undef consteval

negative: undefinition of macro name identical to constexpr keyword

	#undef constexpr

negative: undefinition of macro name identical to constinit keyword

	#undef constinit

negative: undefinition of macro name identical to const_cast keyword

	#undef const_cast

negative: undefinition of macro name identical to continue keyword

	#undef continue

negative: undefinition of macro name identical to co_await keyword

	#undef co_await

negative: undefinition of macro name identical to co_return keyword

	#undef co_return

negative: undefinition of macro name identical to co_yield keyword

	#undef co_yield

negative: undefinition of macro name identical to decltype keyword

	#undef decltype

negative: undefinition of macro name identical to default keyword

	#undef default

negative: undefinition of macro name identical to delete keyword

	#undef delete

negative: undefinition of macro name identical to do keyword

	#undef do

negative: undefinition of macro name identical to double keyword

	#undef double

negative: undefinition of macro name identical to dynamic_cast keyword

	#undef dynamic_cast

negative: undefinition of macro name identical to else keyword

	#undef else

negative: undefinition of macro name identical to enum keyword

	#undef enum

negative: undefinition of macro name identical to explicit keyword

	#undef explicit

negative: undefinition of macro name identical to export keyword

	#undef export

negative: undefinition of macro name identical to extern keyword

	#undef extern

negative: undefinition of macro name identical to false keyword

	#undef false

negative: undefinition of macro name identical to float keyword

	#undef float

negative: undefinition of macro name identical to for keyword

	#undef for

negative: undefinition of macro name identical to friend keyword

	#undef friend

negative: undefinition of macro name identical to goto keyword

	#undef goto

negative: undefinition of macro name identical to if keyword

	#undef if

negative: undefinition of macro name identical to inline keyword

	#undef inline

negative: undefinition of macro name identical to int keyword

	#undef int

negative: undefinition of macro name identical to long keyword

	#undef long

negative: undefinition of macro name identical to mutable keyword

	#undef mutable

negative: undefinition of macro name identical to namespace keyword

	#undef namespace

negative: undefinition of macro name identical to new keyword

	#undef new

negative: undefinition of macro name identical to noexcept keyword

	#undef noexcept

negative: undefinition of macro name identical to nullptr keyword

	#undef nullptr

negative: undefinition of macro name identical to operator keyword

	#undef operator

negative: undefinition of macro name identical to private keyword

	#undef private

negative: undefinition of macro name identical to protected keyword

	#undef protected

negative: undefinition of macro name identical to public keyword

	#undef public

negative: undefinition of macro name identical to register keyword

	#undef register

negative: undefinition of macro name identical to reinterpret_cast keyword

	#undef reinterpret_cast

negative: undefinition of macro name identical to requires keyword

	#undef requires

negative: undefinition of macro name identical to return keyword

	#undef return

negative: undefinition of macro name identical to short keyword

	#undef short

negative: undefinition of macro name identical to signed keyword

	#undef signed

negative: undefinition of macro name identical to sizeof keyword

	#undef sizeof

negative: undefinition of macro name identical to static keyword

	#undef static

negative: undefinition of macro name identical to static_assert keyword

	#undef static_assert

negative: undefinition of macro name identical to static_cast keyword

	#undef static_cast

negative: undefinition of macro name identical to struct keyword

	#undef struct

negative: undefinition of macro name identical to switch keyword

	#undef switch

negative: undefinition of macro name identical to template keyword

	#undef template

negative: undefinition of macro name identical to this keyword

	#undef this

negative: undefinition of macro name identical to thread_local keyword

	#undef thread_local

negative: undefinition of macro name identical to throw keyword

	#undef throw

negative: undefinition of macro name identical to true keyword

	#undef true

negative: undefinition of macro name identical to try keyword

	#undef try

negative: undefinition of macro name identical to typedef keyword

	#undef typedef

negative: undefinition of macro name identical to typeid keyword

	#undef typeid

negative: undefinition of macro name identical to typename keyword

	#undef typename

negative: undefinition of macro name identical to union keyword

	#undef union

negative: undefinition of macro name identical to unsigned keyword

	#undef unsigned

negative: undefinition of macro name identical to using keyword

	#undef using

negative: undefinition of macro name identical to virtual keyword

	#undef virtual

negative: undefinition of macro name identical to void keyword

	#undef void

negative: undefinition of macro name identical to volatile keyword

	#undef volatile

negative: undefinition of macro name identical to wchar_t keyword

	#undef wchar_t

negative: undefinition of macro name identical to while keyword

	#undef while

negative: undefinition of macro name identical to final identifier

	#undef final

negative: undefinition of macro name identical to override identifier

	#undef override

negative: undefinition of macro name identical to noreturn attribute

	#undef noreturn

negative: undefinition of macro name identical to carries_dependency attribute

	#undef carries_dependency

negative: undefinition of macro name identical to deprecated attribute

	#undef deprecated

# 21.2.3 [support.types.nullptr] 1

positive: nullptr_t as synonym for the type of a nullptr expression

	#include <cstddef>
	using t = std::nullptr_t;
	using t = decltype (nullptr);

negative: taking address of nullptr

	auto x = &nullptr;

positive: taking address of nullptr_t object

	#include <cstddef>
	std::nullptr_t y;
	auto x = &y;

# 21.2.3 [support.types.nullptr] 2

positive: macro NULL as a null pointer constant

	#include <cstddef>
	constexpr std::nullptr_t x = NULL;

# 21.3.5 [climits.syn] 1

positive: CHAR_BIT macro

	#include <climits>
	#if !defined CHAR_BIT || CHAR_BIT < 8
	#error
	#endif

positive: SCHAR_MIN macro

	#include <climits>
	#if !defined SCHAR_MIN || SCHAR_MIN > -127
	#error
	#endif

positive: SCHAR_MAX macro

	#include <climits>
	#if !defined SCHAR_MAX || SCHAR_MAX < +127
	#error
	#endif

positive: UCHAR_MAX macro

	#include <climits>
	#if !defined UCHAR_MAX || UCHAR_MAX < 255 || UCHAR_MAX != (1 << CHAR_BIT) - 1
	#error
	#endif

positive: CHAR_MIN macro

	#include <climits>
	#if !defined CHAR_MIN || CHAR_MIN > 0
	#error
	#endif

positive: CHAR_MAX macro

	#include <climits>
	#if !defined CHAR_MAX || CHAR_MAX < UCHAR_MAX
	#error
	#endif

positive: MB_LEN_MAX

	#include <climits>
	#if !defined MB_LEN_MAX || MB_LEN_MAX < 1
	#error
	#endif

positive: SHRT_MIN macro

	#include <climits>
	#if !defined SHRT_MIN || SHRT_MIN > -32767
	#error
	#endif

positive: SHRT_MAX macro

	#include <climits>
	#if !defined SHRT_MAX || SHRT_MAX < +32767
	#error
	#endif

positive: USHRT_MAX macro

	#include <climits>
	#if !defined USHRT_MAX || USHRT_MAX < 65535
	#error
	#endif

positive: INT_MIN macro

	#include <climits>
	#if !defined INT_MIN || INT_MIN > -32767
	#error
	#endif

positive: INT_MAX macro

	#include <climits>
	#if !defined INT_MAX || INT_MAX < +32767
	#error
	#endif

positive: UINT_MAX macro

	#include <climits>
	#if !defined UINT_MAX || UINT_MAX < 65535
	#error
	#endif

positive: LONG_MIN macro

	#include <climits>
	#if !defined LONG_MIN || LONG_MIN > -2147483647
	#error
	#endif

positive: LONG_MAX macro

	#include <climits>
	#if !defined LONG_MAX || LONG_MAX < +2147483647
	#error
	#endif

positive: ULONG_MAX macro

	#include <climits>
	#if !defined ULONG_MAX || ULONG_MAX < 4294967295
	#error
	#endif

positive: LLONG_MIN macro

	#include <climits>
	#if !defined LLONG_MIN || LLONG_MIN > -9223372036854775807
	#error
	#endif

positive: LLONG_MAX macro

	#include <climits>
	#if !defined LLONG_MAX || LLONG_MAX < +9223372036854775807
	#error
	#endif

positive: ULLONG_MAX macro

	#include <climits>
	#if !defined ULLONG_MAX || ULLONG_MAX < 18446744073709551615
	#error
	#endif

# 22.3.1 [cassert.syn] 1

positive: assert macro in <cassert> header with enabled assertions

	#undef NDEBUG
	#include <cassert>
	#ifndef assert
	#error
	#endif

positive: assert macro in <cassert> header with disabled assertions

	#define NDEBUG
	#include <cassert>
	#ifndef assert
	#error
	#endif

positive: assert macro in <assert.h> header with enabled assertions

	#undef NDEBUG
	#include <assert.h>
	#ifndef assert
	#error
	#endif

positive: assert macro in <assert.h> header with disabled assertions

	#define NDEBUG
	#include <assert.h>
	#ifndef assert
	#error
	#endif

positive: multiple inclusion of <cassert> header

	#include <cassert>
	#include <cassert>
	#undef NDEBUG
	#include <cassert>
	#include <cassert>
	#define NDEBUG
	#include <cassert>
	#include <cassert>

positive: multiple inclusion of <assert.h> header

	#include <assert.h>
	#include <assert.h>
	#undef NDEBUG
	#include <assert.h>
	#include <assert.h>
	#define NDEBUG
	#include <assert.h>
	#include <assert.h>

positive: multiple inclusion of <cassert> and <assert.h> headers

	#include <cassert>
	#include <assert.h>
	#undef NDEBUG
	#include <cassert>
	#include <assert.h>
	#define NDEBUG
	#include <cassert>
	#include <assert.h>

# 22.3.2 [assertions.assert] 1

positive: enabled assertions with boolean argument

	#undef NDEBUG
	#include <cassert>
	void f () {assert (true); assert (false);}

positive: disabled assertions with boolean argument

	#define NDEBUG
	#include <cassert>
	void f () {assert (true); assert (false);}

# 24.5.1 [cctype.syn] 1

positive: header <cctype> synopsis

	#include <cctype>
	auto isalnum_ = std::isalnum;
	auto isalpha_ = std::isalpha;
	auto isblank_ = std::isblank;
	auto iscntrl_ = std::iscntrl;
	auto isdigit_ = std::isdigit;
	auto isgraph_ = std::isgraph;
	auto islower_ = std::islower;
	auto isprint_ = std::isprint;
	auto ispunct_ = std::ispunct;
	auto isspace_ = std::isspace;
	auto isupper_ = std::isupper;
	auto isxdigit_ = std::isxdigit;
	auto tolower_ = std::tolower;
	auto toupper_ = std::toupper;

positive: header <ctype.h> synopsis

	#include <ctype.h>
	auto isalnum_ = isalnum;
	auto isalpha_ = isalpha;
	auto isblank_ = isblank;
	auto iscntrl_ = iscntrl;
	auto isdigit_ = isdigit;
	auto isgraph_ = isgraph;
	auto islower_ = islower;
	auto isprint_ = isprint;
	auto ispunct_ = ispunct;
	auto isspace_ = isspace;
	auto isupper_ = isupper;
	auto isxdigit_ = isxdigit;
	auto tolower_ = tolower;
	auto toupper_ = toupper;

# C.5.1 [diff.mods.to.headers] 2

negative: C++ header <cstdnoreturn>

	#include <cstdnoreturn>

negative: C++ header <cthreads>

	#include <cthreads>

negative: C header <stdnoreturn.h>

	#include <stdnoreturn.h>

negative: C header <threads.h>

	#include <threads.h>

# C.5.2.1 [diff.char16] 1

positive: distinct char16_t type

	using t = char16_t;

positive: distinct char32_t type

	using t = char32_t;

negative: reserved char16_t token

	int char16_t;

negative: reserved char32_t token

	int char32_t;

positive: char16_t macro undefined in <cuchar>

	#include <cuchar>
	#ifdef char16_t
	#error
	#endif

positive: char32_t macro undefined in <cuchar>

	#include <cuchar>
	#ifdef char32_t
	#error
	#endif

# C.5.2.2 [diff.wchar.t] 1

positive: distinct wchar_t type

	using t = wchar_t;

negative: reserved wchar_t token

	int wchar_t;

positive: wchar_t macro undefined in <cstddef>

	#include <cstddef>
	#ifdef wchar_t
	#error
	#endif

positive: wchar_t macro undefined in <cstdlib>

	#include <cstdlib>
	#ifdef wchar_t
	#error
	#endif

positive: wchar_t macro undefined in <cwchar>

	#include <cwchar>
	#ifdef wchar_t
	#error
	#endif

# C.5.2.3 [diff.header.assert.h] 1

negative: reserved static_assert token

	int static_assert;

positive: wchar_t macro undefined in <cassert>

	#include <cassert>
	#ifdef static_assert
	#error
	#endif

# C.5.2.4 [diff.header.iso646.h] 1

negative: reserved and token

	int and;

negative: reserved bitand token

	int bitand;

negative: reserved bitor token

	int bitor;

negative: reserved compl token

	int compl;

negative: reserved not_eq token

	int not_eq;

negative: reserved or token

	int or;

negative: reserved or_eq token

	int or_eq;

negative: reserved xor token

	int xor;

negative: reserved xor_eq token

	int xor_eq;

# C.5.2.5 [diff.header.stdalign.h] 1

negative: reserved alignas token

	int alignas;

positive: alignas macro undefined in <cstdalign>

	#include <stdalign.h>
	#ifdef alignas
	#error
	#endif

# C.5.2.6 [diff.header.stdbool.h] 1

negative: reserved bool token

	int bool;

negative: reserved true token

	int true;

negative: reserved false token

	int false;

# C.5.2.7 [diff.null] 1

positive: null pointer constant defined in <clocale>

	#include <clocale>
	decltype (nullptr) x = NULL;

positive: null pointer constant defined in <cstddef>

	#include <cstddef>
	decltype (nullptr) x = NULL;

positive: null pointer constant defined in <cstdio>

	#include <cstdio>
	decltype (nullptr) x = NULL;

positive: null pointer constant defined in <cstdlib>

	#include <cstdlib>
	decltype (nullptr) x = NULL;

positive: null pointer constant defined in <cstring>

	#include <cstring>
	decltype (nullptr) x = NULL;

positive: null pointer constant defined in <ctime>

	#include <ctime>
	decltype (nullptr) x = NULL;

positive: null pointer constant defined in <cwchar>

	#include <cwchar>
	decltype (nullptr) x = NULL;

# D.4.2 [depr.cstdalign.syn] 1

positive: header <stdalign.h> synopsis

	#include <stdalign.h>
	#ifdef alignas
	#error
	#endif
	#ifdef alignof
	#error
	#endif
	#ifndef __alignas_is_defined
	#error
	#endif
	static_assert (__alignas_is_defined == 1);
	#ifndef __alignof_is_defined
	#error
	#endif
	static_assert (__alignof_is_defined == 1);

# D.4.3 [depr.cstdbool.syn] 1

positive: header <stdbool.h> synopsis

	#include <stdbool.h>
	#ifdef bool
	#error
	#endif
	#ifdef true
	#error
	#endif
	#ifdef false
	#error
	#endif
	#ifndef __bool_true_false_are_defined
	#error
	#endif
	static_assert (__bool_true_false_are_defined == 1);

# D.5 [depr.c.headers] 1

positive: 27 C library headers

	#include <assert.h>
	#include <complex.h>
	#include <ctype.h>
	#include <errno.h>
	#include <fenv.h>
	#include <float.h>
	#include <inttypes.h>
	#include <iso646.h>
	#include <limits.h>
	#include <locale.h>
	#include <math.h>
	#include <setjmp.h>
	#include <signal.h>
	#include <stdalign.h>
	#include <stdarg.h>
	#include <stdatomic.h>
	#include <stdbool.h>
	#include <stddef.h>
	#include <stdint.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <tgmath.h>
	#include <time.h>
	#include <uchar.h>
	#include <wchar.h>
	#include <wctype.h>

# todo: D.5 [depr.c.headers] 3

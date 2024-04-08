# Intermediate code compilation test and validation suite
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

# generic assembler

positive: empty assembly

positive: single-line comment

	; this comment spans one line

positive: multiple-line comment

	; this comment spans
	; several lines

positive: single end code directive

	#end

positive: end code directive followed by text

	#end
	This text should not be assembled.

negative: labeled end code directive

	label:	#end

positive: empty standard code section

	.code test

positive: empty standard code sections

	.code test1
	.code test2

negative: standard code section directive missing mnemonic

	test

negative: standard code section directive missing identifier

	.code

negative: standard code section directive with identifier in comment

	.code	; test

negative: standard code section directive with identifier on new line

	.code
	test

negative: labeled standard code section directive

	label:	.code

positive: standard code section directive with end code directive

	.code test
	#end

positive: standard code section directive with end code directive followed by text

	.code test
	#end
	This text should not be assembled.

positive: empty initializing code section

	.initcode test

positive: empty initializing code sections

	.initcode test1
	.initcode test2

negative: initializing code section directive missing mnemonic

	test

negative: initializing code section directive missing identifier

	.initcode

negative: initializing code section directive with identifier in comment

	.initcode	; test

negative: initializing code section directive with identifier on new line

	.initcode
	test

negative: labeled initializing code section directive

	label:	.initcode

positive: initializing code section directive with end code directive

	.initcode test
	#end

positive: initializing code section directive with end code directive followed by text

	.initcode test
	#end
	This text should not be assembled.

positive: empty data initializing code section

	.initdata test

positive: empty data initializing code sections

	.initdata test1
	.initdata test2

negative: data initializing code section directive missing mnemonic

	test

negative: data initializing code section directive missing identifier

	.initdata

negative: data initializing code section directive with identifier in comment

	.initdata	; test

negative: data initializing code section directive with identifier on new line

	.initdata
	test

negative: labeled data initializing code section directive

	label:	.initdata

positive: data initializing code section directive with end code directive

	.initdata test
	#end

positive: data initializing code section directive with end code directive followed by text

	.initdata test
	#end
	This text should not be assembled.

positive: empty standard data section

	.data test

positive: empty standard data sections

	.data test1
	.data test2

negative: standard data section directive missing mnemonic

	test

negative: standard data section directive missing identifier

	.data

negative: standard data section directive with identifier in comment

	.data	; test

negative: standard data section directive with identifier on new line

	.data
	test

negative: labeled standard data section directive

	label:	.data

positive: standard data section directive with end code directive

	.data test
	#end

positive: standard data section directive with end code directive followed by text

	.data test
	#end
	This text should not be assembled.

positive: empty constant data section

	.const test

positive: empty constant data sections

	.const test1
	.const test2

negative: constant data section directive missing mnemonic

	test

negative: constant data section directive missing identifier

	.const

negative: constant data section directive with identifier in comment

	.const	; test

negative: constant data section directive with identifier on new line

	.const
	test

negative: labeled constant data section directive

	label:	.const

positive: constant data section directive with end code directive

	.const test
	#end

positive: constant data section directive with end code directive followed by text

	.const test
	#end
	This text should not be assembled.

positive: empty heading metadata section

	.header test

positive: empty heading metadata sections

	.header test1
	.header test2

negative: heading metadata section directive missing mnemonic

	test

negative: heading metadata section directive missing identifier

	.header

negative: heading metadata section directive with identifier in comment

	.header	; test

negative: heading metadata section directive with identifier on new line

	.header
	test

negative: labeled heading metadata section directive

	label:	.header

positive: heading metadata section directive with end code directive

	.header test
	#end

positive: heading metadata section directive with end code directive followed by text

	.header test
	#end
	This text should not be assembled.

positive: empty trailing metadata section

	.trailer test

positive: empty trailing metadata sections

	.trailer test1
	.trailer test2

negative: trailing metadata section directive missing mnemonic

	test

negative: trailing metadata section directive missing identifier

	.trailer

negative: trailing metadata section directive with identifier in comment

	.trailer	; test

negative: trailing metadata section directive with identifier on new line

	.trailer
	test

negative: labeled trailing metadata section directive

	label:	.trailer

positive: trailing metadata section directive with end code directive

	.trailer test
	#end

positive: trailing metadata section directive with end code directive followed by text

	.trailer test
	#end
	This text should not be assembled.

negative: alias name

	.alias	name

negative: name requirement

	.require	name

negative: section group directive missing mnemonic

	name

negative: section group directive missing identifier

	.group

negative: section group directive with identifier in comment

	.group	; name

negative: section group directive with identifier on new line

	.group
	name

negative: labeled section group directive

	label:	.group	name

positive: section group

	.group	name

negative: duplicated section group

	.group	name
	.group	name

negative: section groups

	.group	name1
	.group	name2

negative: duplicated section groups

	.group	name
	.group	name

negative: static assertion directive missing mnemonic

	1

negative: static assertion directive missing condition

	.assert

negative: static assertion directive with condition in comment

	.assert	; 1

negative: static assertion directive with condition on new line

	.assert
	1

negative: labeled static assertion directive

	label:	.assert	1

positive: satisified static assertion

	.assert	1

negative: unsatisified static assertion

	.assert	0

negative: section alignment directive missing mnemonic

	4

negative: section alignment directive missing value

	.alignment

negative: section alignment directive with value in comment

	.alignment	; 4

negative: section alignment directive with value on new line

	.alignment
	4

negative: labeled section alignment directive

	label:	.alignment	4

negative: negative section alignment

	.alignment	-4

negative: zero section alignment

	.alignment	0

positive: positive section alignment

	.alignment	4
	.assert	.alignment == 4

negative: invalid positive section alignment

	.alignment	5

negative: duplicated section alignment

	.alignment	4
	.alignment	4

negative: modified section alignment

	.alignment	second + 4
	nop
	second:

negative: section alignment after section origin

	.origin	0
	.alignment	4

negative: data reservation

	.reserve	4

negative: data padding

	.pad	4

negative: data alignment

	.align	8

negative: definition missing label

	.equals	1

negative: constant definition directive missing mnemonic

	label:	1

negative: constant definition directive missing value

	label:	.equals

negative: constant definition directive with value in comment

	label:	.equals	; 1

negative: constant definition directive with value on new line

	label:	.equals
	1

positive: labeled constant definition directive

	label:	.equals	1

negative: unlabeled constant definition directive

	.equals	1

positive: duplicated equal constant definitions

	label:	.equals	1
	label:	.equals	1
	label:	.equals	1
	label:	.equals	1

negative: duplicated unequal constant definitions

	label:	.equals	1
	label:	.equals	2

positive: forward referencing constant definitions

	.assert	second - first == 1
	first:	.equals	1
	second:	.equals	2

positive: backward referencing constant definitions

	first:	.equals	1
	second:	.equals	2
	.assert	second - first == 1

negative: recursive constant definition

	label:	.equals	label
	.byte	label

negative: recursive constant definitions

	first:	.equals	second
	second:	.equals	first
	.byte	first, second

positive: conditional if directive

	#if 0
		.assert	0
	#endif

negative: labeled conditional if directive

	label:	#if 0
	#endif

negative: conditional if directive missing condition

	#if
	#endif

negative: conditional if missing conditional end-if

	#if 0

positive: nested conditional ifs

	#if 1
		#if 0
			.assert	0
		#endif
	#endif

negative: nested conditional ifs missing conditional end-if

	#if 1
		#if 0
			.assert	0
	#endif

positive: conditional else-if directive

	#if 0
	#elif 0
		.assert	0
	#endif

positive: conditional else-if directives

	#if 0
	#elif 0
	#elif 0
	#elif 0
	#elif 0
	#endif

negative: labeled conditional else-if directive

	#if 0
	label:	#elif 0
	#endif

negative: conditional else-if directive missing condition

	#if 0
	#elif
	#endif

negative: conditional else-if missing conditional if

	#elif 0
	#endif

negative: conditional else-if missing conditional end-if

	#if 0
	#elif 0

positive: conditional else directive

	#if 1
	#else
		.assert	0
	#endif

negative: conditional else directives

	#if 0
	#else
	#else
	#endif

negative: labeled conditional else directive

	#if 0
	label:	#else
	#endif

negative: conditional else missing conditional if

	#else
	#endif

negative: conditional else missing conditional end-if

	#if 0
	#else

positive: conditional end-if directive

	#if 0
	#endif

negative: labeled conditional end-if directive

	#if 0
	label:	#endif

negative: conditional end-if missing conditional if

	#endif

positive: begin repetition directive

	#repeat 0
	#endrep

negative: labeled begin repetition directive

	label:	#repeat 0
	#endrep

negative: begin repetition directive missing number

	#repeat
	#endrep

negative: begin repetition missing end repetition

	#repeat 0

positive: end repetition directive

	#repeat 0
	#endrep

negative: labeled end repetition directive

	#repeat 0
	label:	#endrep

negative: end repetition missing begin repetition

	#endrep

positive: code repetition

	#repeat 100
		byte##:	nop
			.assert	byte## == ##
	#endrep

positive: begin macro definition directive

	#define macro
	#enddef

negative: labeled begin macro definition directive

	label:	#define macro
	#enddef

negative: begin macro definition directive missing identifier

	#define
	#enddef

negative: begin macro definition missing end macro definition

	#define macro

positive: end macro definition directive

	#define macro
	#enddef

negative: labeled end macro definition directive

	#define macro
	label:	#enddef

negative: end macro definition missing begin macro definition

	#enddef

positive: remove macro definition directive

	#define macro
	#enddef
	#undef macro

negative: labeled remove macro definition directive

	#define macro
	#enddef
	label:	#undef macro

negative: remove macro definition directive missing identifier

	#define macro
	#enddef
	#undef

negative: duplicated macro definition

	#define macro
	#enddef
	#define macro
	#enddef

positive: duplicated macro definition with removal

	#define macro
	#enddef
	#undef macro
	#define macro
	#enddef

negative: undefined macro removal

	#undef macro

negative: duplicated macro removal

	#define macro
	#enddef
	#undef macro
	#undef macro

positive: duplicated macro removal with definition

	#define macro
	#enddef
	#undef macro
	#define macro
	#enddef
	#undef macro

negative: recursive macro definition

	#define macro
		macro
	#enddef

negative: indirectly recursive macro definition

	#define macro1
		macro2
	#enddef
	#define macro2
		macro1
	#enddef

positive: macro invocation

	#define add
		add_result:	.equals	#0 + #1 + #2 + #3
	#enddef
	#define multiply
		multiply_result:	.equals	#0 * #1 * #2 * #3
	#enddef
	#define invoke
		#5_##:	.equals	#0_result
			#0	#1, #2, #3, #4
	#enddef
	invoke	add, 2, 3, 4, 5, sum
	invoke	multiply, 2, 3, 4, 5, product
	.assert	sum_11 == 14
	.assert	product_12 == 120

negative: undefined macro invocation

	macro

negative: removed macro invocation

	#define macro
	#enddef
	#undef macro
	macro

negative: byte data

	.byte	0

negative: double byte data

	.dbyte	0

negative: triple byte data

	.dbyte	0

negative: quadruple byte data

	.dbyte	0

negative: octuple byte data

	.dbyte	0

negative: section origin directive missing mnemonic

	0

negative: section origin directive missing offset

	.origin

negative: section origin directive with offset in comment

	.origin	; 0

negative: section origin directive with offset on new line

	.origin
	0

negative: labeled section origin directive

	label:	.origin	0

negative: negative section origin

	.origin	-4

positive: zero section origin

	.origin	0
	.assert	.origin == 0

positive: positive section origin

	.origin	4
	.assert	.origin == 4

negative: invalid positive section origin

	.origin	0xffffffff

negative: duplicated section origin

	.origin	0
	.origin	0

negative: modified section origin

	.origin	second + 4
	nop
	second:

negative: section origin after section alignment

	.alignment	4
	.origin	0

negative: bit mode

	.bitmode	16

negative: little-endian mode

	.little

negative: big-endian mode

	.big

positive: required section

	.required
	.assert	.required

positive: required and duplicable section

	.required
	.duplicable
	.assert	.required
	.assert .duplicable

positive: required and replaceable section

	.required
	.replaceable
	.assert	.required
	.assert .replaceable

negative: required section directive with operand

	.required	0

negative: duplicated required section directive

	.required
	.required

negative: labeled required section directive

	label:	.required

positive: duplicable section

	.duplicable
	.assert	.duplicable

positive: duplicable and required section

	.duplicable
	.required
	.assert	.duplicable
	.assert	.required

positive: duplicable and replaceable section

	.duplicable
	.replaceable
	.assert	.duplicable
	.assert	.replaceable

negative: duplicable section directive with operand

	.duplicable	0

negative: duplicated duplicable section directive

	.duplicable
	.duplicable

negative: labeled duplicable section directive

	label:	.duplicable

positive: replaceable section

	.replaceable
	.assert	.replaceable

positive: replaceable and required section

	.replaceable
	.required
	.assert	.replaceable
	.assert .required

positive: replaceable and duplicable section

	.replaceable
	.duplicable
	.assert	.replaceable
	.assert .duplicable

negative: replaceable section directive with operand

	.replaceable	0

negative: duplicated replaceable section directive

	.replaceable
	.replaceable

negative: labeled replaceable section directive

	label:	.replaceable

negative: empty label

	:

positive: label missing instruction

	label:

negative: duplicated labels

	label:
	label:

positive: forward referencing labels

	.assert	second - first == 0
	first:
	second:

positive: backward referencing labels

	first:
	second:
	.assert	second - first == 0

positive: empty instruction

positive: empty instruction with comment

	; instruction

positive: labeled empty instruction

	label:

positive: labeled empty instruction with comment

	label:	; instruction

# intermediate code assembler

# sections

negative: datum definition in standard code section

	.code test
	def	u1 0

negative: space reservation in standard code section

	.code test
	res	1

positive: no operation in standard code section

	.code test
	nop

positive: datum definition in standard data section

	.data test
	def	u1 0

positive: space reservation in standard data section

	.data test
	res	1

negative: no operation in standard data section

	.data test
	nop

positive: datum definition in constant data section

	.const test
	def	u1 0

positive: space reservation in constant data section

	.const test
	res	1

negative: no operation in constant data section

	.const test
	nop

# types

negative: instruction missing type

	push	0

negative: signed type missing model

	push	4 0

negative: signed type with invalid model

	push	a4 0

negative: signed type missing size

	push	s 0

negative: signed type with negative size

	push	s-1 0

negative: signed type with zero size

	push	s0 0

positive: signed type with positive size

	push	s1 0

negative: signed type with signed positive size

	push	s+1 0

negative: signed type with size 0

	push	s0 0

positive: signed type with size 1

	push	s1 0

positive: signed type with size 2

	push	s2 0

negative: signed type with size 3

	push	s3 0

positive: signed type with size 4

	push	s4 0

negative: signed type with size 5

	push	s5 0

negative: signed type with size 6

	push	s6 0

negative: signed type with size 7

	push	s7 0

positive: signed type with size 8

	push	s8 0

negative: signed type with size 9

	push	s9 0

negative: signed type with size 10

	push	s10 0

negative: signed type with size 16

	push	s16 0

negative: unsigned type missing model

	push	4 0

negative: unsigned type with invalid model

	push	v4 0

negative: unsigned type missing size

	push	u 0

negative: unsigned type with negative size

	push	u-1 0

negative: unsigned type with zero size

	push	u0 0

positive: unsigned type with positive size

	push	u1 0

negative: unsigned type with signed positive size

	push	u+1 0

negative: unsigned type with size 0

	push	u0 0

positive: unsigned type with size 1

	push	u1 0

positive: unsigned type with size 2

	push	u2 0

negative: unsigned type with size 3

	push	u3 0

positive: unsigned type with size 4

	push	u4 0

negative: unsigned type with size 5

	push	u5 0

negative: unsigned type with size 6

	push	u6 0

negative: unsigned type with size 7

	push	u7 0

positive: unsigned type with size 8

	push	u8 0

negative: unsigned type with size 9

	push	u9 0

negative: unsigned type with size 10

	push	u10 0

negative: unsigned type with size 16

	push	u16 0

negative: float type missing model

	push	4 0

negative: float type with invalid model

	push	_4 0

negative: float type missing size

	push	f 0

negative: float type with negative size

	push	f-4 0

negative: float type with zero size

	push	f0 0

positive: float type with positive size

	push	f4 0

negative: float type with signed positive size

	push	f+4 0

negative: float type with size 0

	push	f0 0

negative: float type with size 1

	push	f1 0

negative: float type with size 2

	push	f2 0

negative: float type with size 3

	push	f3 0

positive: float type with size 4

	push	f4 0

negative: float type with size 5

	push	f5 0

negative: float type with size 6

	push	f6 0

negative: float type with size 7

	push	f7 0

positive: float type with size 8

	push	f8 0

negative: float type with size 9

	push	f9 0

negative: float type with size 10

	push	f10 0

negative: float type with size 16

	push	f16 0

negative: pointer type missing model

	push	0

negative: pointer type with invalid model

	push	rtp 0

positive: pointer type missing size

	push	ptr 0

negative: pointer type with size

	push	ptr4 0

# size operands

negative: negative size

	trap	-1

positive: zero size

	trap	0

positive: positive size

	trap	1

negative: positive size with sign

	trap	+1

# offset operands

positive: negative offset

	br	-1

negative: negative offset missing sign

	br	1

positive: negative offset with space

	br	- 1

negative: invalid negative offset

	br	-2

positive: zero offset

	br	+0

negative: zero offset missing sign

	br	0

positive: zero offset with space

	br	+ 0

positive: positive offset

	br	+1
	nop

negative: positive offset missing sign

	br	1
	nop

positive: positive offset with space

	br	+ 1
	nop

negative: invalid positive offset

	br	+1

# string operands

negative: string missing beginning double quote

	req	"string

negative: string missing ending double quote

	req	string"

positive: empty string

	req	""

positive: string

	req	"string"

positive: string with space

	req	" "

negative: string with double quote

	req	"""

negative: string with double quotes

	req	""""

positive: string with escaped double quote

	req	"\""

positive: string with escaped double quotes

	req	"\"\""

negative: string starting with escaped double quote

	req	\"string"

negative: string ending with escaped double quote

	req	string\"

# type operands

positive: type

	type	s1

negative: type missing model

	type	1

negative: type missing size

	type	s

# immediate operands

positive: signed immediate

	push	s1 0

negative: signed immediate missing type

	push	0

negative: signed immediate with text

	push	s1 zero

negative: signed immediate missing value

	push	s1

positive: signed immediate with negative value

	push	s1 -1
	push	s1 -128

negative: signed immediate with invalid negative value

	push	s1 -129

positive: signed immediate with positive value

	push	s1 +1
	push	s1 +127

negative: signed immediate with invalid positive value

	push	s1 128

negative: signed immediate with floating value

	push	s1 1.0

positive: unsigned immediate

	push	u1 0

negative: unsigned immediate missing type

	push	0

negative: unsigned immediate with text

	push	u1 zero

negative: unsigned immediate missing value

	push	u1

negative: unsigned immediate with negative value

	push	u1 -1

positive: unsigned immediate with positive value

	push	u1 +1
	push	u1 +255

negative: unsigned immediate with invalid positive value

	push	s1 +256

negative: unsigned immediate with floating value

	push	u1 1.0

positive: floating immediate

	push	f4 0

negative: floating immediate missing type

	push	0

negative: floating immediate missing value

	push	f4

negative: floating immediate with text

	push	f4 zero

positive: floating immediate with negative value

	push	f4 -1

positive: floating immediate with positive value

	push	f4 +1

positive: floating immediate with floating value

	push	f4 1.0

positive: pointer immediate

	push	ptr 0

negative: pointer immediate missing type

	push	0

negative: pointer immediate with text

	push	ptr zero

negative: pointer immediate missing value

	push	ptr

negative: pointer immediate with negative value

	push	ptr -1

positive: pointer immediate with positive value

	push	ptr +1
	push	ptr +255

negative: pointer immediate with floating value

	push	ptr 1.0

# register operands

negative: register missing type

	push	$0

negative: register missing dollar

	pop	u4 0

negative: register missing number

	push	u4 $

negative: register with space

	push	u4 $ 0

negative: negative register

	push	u4 $-1

positive: positive register

	push	u4 $1

negative: signed register with positive displacement

	push	s4 $0 + 1

negative: signed register with negative displacement

	push	s4 $0 - 1

negative: unsigned register with positive displacement

	push	u4 $0 + 1

negative: unsigned register with negative displacement

	push	u4 $0 - 1

negative: float register with positive displacement

	push	f4 $0 + 1

negative: float register with negative displacement

	push	f4 $0 - 1

negative: pointer register with displacement missing sign

	push	ptr $0 1

positive: pointer register with positive displacement

	push	ptr $0 + 1

positive: pointer register with negative displacement

	push	ptr $0 - 1

negative: pointer register target with negative displacement

	pop	ptr $0 - 1

negative: pointer register target with positive displacement

	pop	ptr $0 + 1

negative: function register with positive displacement

	push	fun $0 + 1

negative: function register with negative displacement

	push	fun $0 - 1

positive: reading result register

	push	ptr $res

positive: writing result register

	pop	ptr $res

positive: reading stack pointer

	push	ptr $sp

positive: writing stack pointer

	pop	ptr $sp

positive: reading frame pointer

	push	ptr $fp

positive: writing frame pointer

	pop	ptr $fp

positive: reading link register

	#if lnksize
		mov	fun $0, fun $lnk
	#endif

positive: writing link register

	#if lnksize
		mov	fun $lnk, fun 0
	#endif

# address operands

negative: address missing type

	push	@test

negative: address missing at

	push	ptr test

negative: address missing name

	push	ptr @

negative: address with space

	push	ptr @ test

positive: address with name

	push	ptr @test

negative: signed address operand

	push	s4 @test

negative: unsigned address operand

	push	u4 @test

negative: floating address operand

	push	f4 @test

positive: pointer address operand

	push	ptr @test

negative: address with positive sign

	push	ptr @test +

negative: address with negative sign

	push	ptr @test -

negative: address with register missing sign

	push	ptr @test $0

positive: address with positive register

	push	ptr @test + $0

negative: address with negative register

	push	ptr @test - $0

negative: address with displacement missing sign

	push	ptr @test 1

positive: address with positive displacement

	push	ptr @test + 1

positive: address with negative displacement

	push	ptr @test - 1

negative: address with register missing sign and displacement

	push	ptr @test $0 + 1

negative: address with register and displacement missing sign

	push	ptr @test + $0 1

positive: address with positive register and positive displacement

	push	ptr @test + $0 + 1

positive: address with positive register and negative displacement

	push	ptr @test + $0 - 1

negative: address with positive register and positive sign

	push	ptr @test + $0 +

negative: address with positive register and negative sign

	push	ptr @test + $0 -

negative: address with negative register and positive displacement

	push	ptr @test - $0 + 1

negative: address with negative register and negative displacement

	push	ptr @test - $0 - 1

# memory operands

negative: memory missing type

	push	[@test]

negative: memory missing opening brackets

	push	u4 @test]

negative: memory missing closing brackets

	push	u4 [@test

positive: signed memory operand

	push	s4 [@test]

positive: strict signed memory operand

	push	s4 [@test] !

positive: unsigned memory operand

	push	u4 [@test]

positive: strict unsigned memory operand

	push	u4 [@test] !

positive: floating memory operand

	push	f4 [@test]

positive: strict floating memory operand

	push	f4 [@test] !

negative: empty memory operand

	push	f4 []

positive: memory with address

	push	u4 [@test]

positive: strict memory with address

	push	u4 [@test] !

positive: memory with register

	push	u4 [$0]

positive: memory with immediate address

	push	u4 [1]

positive: strict memory with immediate address

	push	u4 [1] !

negative: memory with address and positive sign

	push	u4 [@test +]

negative: memory with address and negative sign

	push	u4 [@test -]

negative: memory with address and register missing sign

	push	u4 [@test $0]

positive: memory with address and positive register

	push	u4 [@test + $0]

positive: strict memory with address and positive register

	push	u4 [@test + $0] !

negative: memory with address and negative register

	push	u4 [@test - $0]

negative: memory with address and displacement missing sign

	push	u4 [@test 1]

positive: memory with address and positive displacement

	push	u4 [@test + 1]

positive: strict memory with address and positive displacement

	push	u4 [@test + 1] !

positive: memory with address and negative displacement

	push	u4 [@test - 1]

positive: strict memory with address and negative displacement

	push	u4 [@test - 1] !

negative: memory with address and register missing sign and displacement

	push	u4 [@test $0 + 1]

negative: memory with address and register and displacement missing sign

	push	u4 [@test + $0 1]

positive: memory with address and positive register and positive displacement

	push	u4 [@test + $0 + 1]

positive: strict memory with address and positive register and positive displacement

	push	u4 [@test + $0 + 1] !

positive: memory with address and positive register and negative displacement

	push	u4 [@test + $0 - 1]

positive: strict memory with address and positive register and negative displacement

	push	u4 [@test + $0 - 1] !

negative: memory with address and positive register and positive sign

	push	u4 [@test + $0 +]

negative: memory with address and positive register and negative sign

	push	u4 [@test + $0 -]

negative: memory with address and negative register and positive displacement

	push	u4 [@test - $0 + 1]

negative: memory with address and negative register and negative displacement

	push	u4 [@test - $0 - 1]

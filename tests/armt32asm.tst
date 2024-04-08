# ARM T32 assembler test and validation suite
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

negative: alias name directive missing mnemonic

	name

negative: alias name directive missing identifier

	.alias

negative: alias name directive with identifier in comment

	.alias	; name

negative: alias name directive with identifier on new line

	.alias
	name

negative: labeled alias name directive

	label:	.alias	name

positive: alias name

	.alias	name

negative: duplicated alias name

	.alias	main

positive: alias names

	.alias	name1
	.alias	name2

negative: duplicated alias names

	.alias	name
	.alias	name

negative: name requirement directive missing mnemonic

	name

negative: name requirement directive missing identifier

	.require

negative: name requirement directive with identifier in comment

	.require	; name

negative: name requirement directive with identifier on new line

	.require
	name

negative: labeled name requirement directive

	label:	.require	name

positive: name requirement

	.require	name

positive: name requirements

	.require	name1
	.require	name2

negative: duplicated name requirements

	.require	name
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

negative: misaligned section alignment

	.alignment	1

negative: modified section alignment

	.alignment	second + 4
	nop
	second:

negative: section alignment after section origin

	.origin	0
	.alignment	4

negative: data reservation directive missing mnemonic

	4

negative: data reservation directive missing value

	.reserve

negative: data reservation directive with value in comment

	.reserve	; 4

negative: data reservation directive with value on new line

	.reserve
	4

positive: labeled data reservation directive

	label:	.reserve	4

negative: negative data reservation

	.reserve	-4

positive: zero data reservation

	.reserve	0

positive: positive data reservation

	.reserve	4

positive: data reservation

	.byte	0, 1, 2, 3
	.reserve	4
	pos:
	.assert	pos == 8

negative: data padding directive missing mnemonic

	4

negative: data padding directive missing value

	.pad

negative: data padding directive with value in comment

	.pad	; 4

negative: data padding directive with value on new line

	.pad
	4

negative: labeled data padding directive

	label:	.pad	4

negative: negative data padding

	.pad	-4

positive: zero data padding

	.pad	0

positive: positive data padding

	.pad	4

negative: invalid data padding

	.reserve 4
	.pad	0

positive: data padding

	.byte	0, 1, 2, 3
	.pad	8
	pos:
	.assert	pos == 8

negative: data alignment directive missing mnemonic

	4

negative: data alignment directive missing value

	.align

negative: data alignment directive with value in comment

	.align	; 4

negative: data alignment directive with value on new line

	.align
	4

negative: labeled data alignment directive

	label:	.align	4

negative: negative data alignment

	.align	-4

negative: zero data alignment

	.align	0

positive: positive data alignment

	.align	4

negative: invalid data alignment

	.align	5

positive: data alignment

	.byte	0, 1, 2, 3
	.align	8
	pos:
	.assert	pos % 8 == 0

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
		byte##:	.byte	##
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

negative: byte data directive missing operand

	.byte

positive: labeled byte data directive

	label:	.byte	0

positive: byte data with integer

	.byte	0

positive: byte data with negative integer

	.byte	-45

negative: byte data with invalid integer

	.byte	256

negative: byte data with invalid negative integer

	.byte	-256

positive: byte data with character

	.byte	'c'

positive: byte data with string

	.byte	"string"

positive: byte data with empty string

	.byte	""

positive: byte data with address

	.byte	@test

positive: byte data with several values

	.byte	5, 0b0000'0010, 0o10, 0x10, @test+5, 'c', "string"

negative: double byte data directive missing operand

	.dbyte

positive: labeled double byte data directive

	label:	.dbyte	0

positive: double byte data with integer

	.dbyte	0

positive: double byte data with negative integer

	.dbyte	-45

negative: double byte data with invalid integer

	.dbyte	65536

negative: double byte data with invalid negative integer

	.dbyte	-65536

positive: double byte data with character

	.dbyte	'c'

positive: double byte data with string

	.dbyte	"string"

positive: double byte data with empty string

	.byte	""

positive: double byte data with address

	.dbyte	@test

positive: double byte data with several values

	.dbyte	5, 0b0000'0010, 0o10, 0x10, @test+5, 'c', "string"

negative: triple byte data directive missing operand

	.tbyte

positive: labeled triple byte data directive

	label:	.tbyte	0

positive: triple byte data with integer

	.tbyte	0

positive: triple byte data with negative integer

	.tbyte	-45

negative: triple byte data with invalid integer

	.tbyte	16777216

negative: triple byte data with invalid negative integer

	.tbyte	-16777216

positive: triple byte data with character

	.tbyte	'c'

positive: triple byte data with string

	.tbyte	"string"

positive: triple byte data with empty string

	.byte	""

positive: triple byte data with address

	.tbyte	@test

positive: triple byte data with several values

	.tbyte	5, 0b0000'0010, 0o10, 0x10, @test+5, 'c', "string"

negative: quadruple byte data directive missing operand

	.qbyte

positive: labeled quadruple byte data directive

	label:	.qbyte	0

positive: quadruple byte data with integer

	.qbyte	0

positive: quadruple byte data with negative integer

	.qbyte	-45

negative: quadruple byte data with invalid integer

	.qbyte	4294967296

negative: quadruple byte data with invalid negative integer

	.qbyte	-4294967296

positive: quadruple byte data with character

	.qbyte	'c'

positive: quadruple byte data with string

	.qbyte	"string"

positive: quadruple byte data with empty string

	.qbyte	""

positive: quadruple byte data with address

	.qbyte	@test

positive: quadruple byte data with several values

	.qbyte	5, 0b0000'0010, 0o10, 0x10, @test+5, 'c', "string"

negative: octuple byte data directive missing operand

	.obyte

positive: labeled octuple byte data directive

	label:	.obyte	0

positive: octuple byte data with integer

	.obyte	0

positive: octuple byte data with negative integer

	.obyte	-45

negative: octuple byte data with invalid integer

	.obyte	18446744073709551616

negative: octuple byte data with invalid negative integer

	.obyte	-18446744073709551616

positive: octuple byte data with character

	.obyte	'c'

positive: octuple byte data with string

	.obyte	"string"

positive: octuple byte data with empty string

	.obyte	""

positive: octuple byte data with address

	.obyte	@test

positive: octuple byte data with several values

	.obyte	5, 0b0000'0010, 0o10, 0x10, @test+5, 'c', "string"

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

negative: misaligned section origin

	.origin	1

negative: modified section origin

	.origin	second + 4
	nop
	second:

negative: section origin after section alignment

	.alignment	4
	.origin	0

negative: bit mode directive missing mnemonic

	16

negative: bit mode directive missing mode

	.bitmode

negative: bit mode directive with mode in comment

	.bitmode	; 16

negative: bit mode directive with mode on new line

	.bitmode
	16

negative: labeled bit mode directive

	label:	.bitmode	16

negative: negative bit mode

	.bitmode	-16

negative: 0-bit mode

	.bitmode	0

negative: 8-bit mode

	.bitmode	8

positive: 16-bit mode

	.bitmode	16
	.assert	.bitmode == 16

negative: 24-bit mode

	.bitmode	24

positive: 32-bit mode

	.bitmode	32
	.assert	.bitmode == 32

negative: 40-bit mode

	.bitmode	40

negative: 48-bit mode

	.bitmode	48

negative: 56-bit mode

	.bitmode	56

negative: 64-bit mode

	.bitmode	64

negative: 128-bit mode

	.bitmode	128

positive: duplicated bit mode

	.bitmode	16
	.assert	.bitmode == 16
	.bitmode	32
	.assert	.bitmode == 32
	.bitmode	16
	.assert	.bitmode == 16
	.bitmode	32
	.assert	.bitmode == 32

positive: little-endian mode

	.little
	.assert	.little
	.assert	!.big

positive: duplicated little-endian mode

	.little
	.big
	.little

negative: little-endian mode with operand directive

	.little	0

negative: labeled little-endian mode directive

	label:	.little

positive: big-endian mode

	.big
	.assert	.big
	.assert	!.little

positive: duplicated big-endian mode

	.big
	.little
	.big

negative: big-endian mode with operand directive

	.big	0

negative: labeled big-endian mode directive

	label:	.big

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

# ARM T32 assembler

# base instructions

positive: adc instruction

	adc	r0, 0
	adc	r15, 0xff000000
	adc	r0, r0, 0
	adc	r15, r15, 0xff000000
	it	al
	adcal	r0, r0
	it	al
	adcal	r7, r7
	it	al
	adcal	r0, r0, r0
	it	al
	adcal	r7, r7, r7
	adc	r0, r0, rrx
	adc	r15, r15, rrx
	adc	r0, r0, r0, rrx
	adc	r15, r15, r15, rrx
	adc	r0, r0
	adc	r15, r15
	adc	r0, r0, r0
	adc	r15, r15, r15
	adc	r0, r0, lsl 1
	adc	r15, r15, ror 31
	adc	r0, r0, r0, lsl 1
	adc	r15, r15, r15, ror 31

positive: adcs instruction

	adcs	r0, 0
	adcs	r15, 0xff000000
	adcs	r0, r0, 0
	adcs	r15, r15, 0xff000000
	adcs	r0, r0
	adcs	r7, r7
	adcs	r0, r0, r0
	adcs	r7, r7, r7
	adcs	r0, r0, rrx
	adcs	r15, r15, rrx
	adcs	r0, r0, r0, rrx
	adcs	r15, r15, r15, rrx
	adcs	r0, r0
	adcs	r15, r15
	adcs	r0, r0, r0
	adcs	r15, r15, r15
	adcs	r0, r0, lsl 1
	adcs	r15, r15, ror 31
	adcs	r0, r0, r0, lsl 1
	adcs	r15, r15, r15, ror 31

positive: add instruction

	it	al
	addal	r0, r0, 0
	it	al
	addal	r7, r7, 7
	it	al
	addal	r0, 0
	it	al
	addal	r7, 255
	it	al
	addal	r0, r0, 0
	it	al
	addal	r7, r7, 255
	add	r0, 0
	add	r15, 0xff000000
	add	r0, r0, 0
	add	r15, r15, 0xff000000
	add	r0, 0
	add	r15, 4095
	add	r0, r0, 0
	add	r15, r15, 4095
	it	al
	addal	r0, r0
	it	al
	addal	r7, r0
	it	al
	addal	r0, r0, r0
	it	al
	addal	r7, r7, r7
	add	r0, r0
	add	r15, r15
	add	r0, r0, r0
	add	r15, r15, r15
	add	r0, r0, rrx
	add	r15, r15, rrx
	add	r0, r0, r0, rrx
	add	r15, r15, r15, rrx
	add	r0, r0
	add	r15, r15
	add	r0, r0, r0
	add	r15, r15, r15
	add	r0, r0, lsl 1
	add	r15, r15, ror 31
	add	r0, r0, r0, lsl 1
	add	r15, r15, r15, ror 31
	add	r0, sp, 0
	add	r7, sp, 1020
	add	sp, 0
	add	sp, 0xff000000
	add	r0, sp, 0
	add	r15, sp, 0xff000000
	add	sp, 0
	add	sp, 4095
	add	r0, sp, 0
	add	r15, sp, 4095
	add	r0, sp
	add	r15, sp
	add	r0, sp, r0
	add	r15, sp, r15
	add	sp, r0
	add	sp, r15
	add	sp, sp, r0
	add	sp, sp, r15
	add	sp, r0, rrx
	add	sp, r15, rrx
	add	r0, sp, r0, rrx
	add	r15, sp, r15, rrx
	add	sp, r0
	add	sp, r15
	add	sp, sp, r0
	add	sp, sp, r15
	add	sp, r0, lsl 1
	add	sp, r15, ror 31
	add	sp, sp, r0, lsl 1
	add	sp, sp, r15, ror 31
	add	r0, pc, 0
	add	r7, pc, 1020

positive: adds instruction

	adds	r0, r0, 0
	adds	r7, r7, 7
	adds	r0, 0
	adds	r7, 255
	adds	r0, r0, 0
	adds	r7, r7, 255
	adds	r0, 0
	adds	r15, 0xff000000
	adds	r0, r0, 0
	adds	r15, r15, 0xff000000
	adds	r0, r0
	adds	r7, r0
	adds	r0, r0, r0
	adds	r7, r7, r7
	adds	r0, r0, rrx
	adds	r15, r15, rrx
	adds	r0, r0, r0, rrx
	adds	r15, r15, r15, rrx
	adds	r0, r0
	adds	r15, r15
	adds	r0, r0, r0
	adds	r15, r15, r15
	adds	r0, r0, lsl 1
	adds	r15, r15, ror 31
	adds	r0, r0, r0, lsl 1
	adds	r15, r15, r15, ror 31
	adds	sp, 0
	adds	sp, 0xff000000
	adds	r0, sp, 0
	adds	r15, sp, 0xff000000
	adds	sp, r0, rrx
	adds	sp, r15, rrx
	adds	r0, sp, r0, rrx
	adds	r15, sp, r15, rrx
	adds	sp, r0
	adds	sp, r15
	adds	sp, sp, r0
	adds	sp, sp, r15
	adds	sp, r0, lsl 1
	adds	sp, r15, ror 31
	adds	r0, sp, r0, lsl 1
	adds	r15, sp, r15, ror 31

positive: addw instruction

	addw	r0, 0
	addw	r15, 4095
	addw	r0, r0, 0
	addw	r15, r15, 4095
	addw	sp, 0
	addw	sp, 4095
	addw	r0, sp, 0
	addw	r15, sp, 4095
	addw	r0, pc, 0
	addw	r15, pc, 4095

positive: adr instruction

	adr	r0, 0
	adr	r7, 1020
	adr	r0, -1
	adr	r15, -4095
	adr	r0, 0
	adr	r15, 4095

positive: and instruction

	and	r0, 0
	and	r15, 0xff000000
	and	r0, r0, 0
	and	r15, r15, 0xff000000
	it	al
	andal	r0, r0
	it	al
	andal	r7, r7
	it	al
	andal	r0, r0, r0
	it	al
	andal	r7, r7, r7
	and	r0, r0, rrx
	and	r15, r15, rrx
	and	r0, r0, r0, rrx
	and	r15, r15, r15, rrx
	and	r0, r0
	and	r15, r15
	and	r0, r0, r0
	and	r15, r15, r15
	and	r0, r0, lsl 1
	and	r15, r15, ror 31
	and	r0, r0, r0, lsl 1
	and	r15, r15, r15, ror 31

positive: ands instruction

	ands	r0, 0
	ands	r15, 0xff000000
	ands	r0, r0, 0
	ands	r15, r15, 0xff000000
	ands	r0, r0
	ands	r7, r7
	ands	r0, r0, r0
	ands	r7, r7, r7
	ands	r0, r0, rrx
	ands	r15, r15, rrx
	ands	r0, r0, r0, rrx
	ands	r15, r15, r15, rrx
	ands	r0, r0
	ands	r15, r15
	ands	r0, r0, r0
	ands	r15, r15, r15
	ands	r0, r0, lsl 1
	ands	r15, r15, ror 31
	ands	r0, r0, r0, lsl 1
	ands	r15, r15, r15, ror 31

positive: asr instruction

	it	al
	asral	r0, 1
	it	al
	asral	r7, 32
	it	al
	asral	r0, r0, 1
	it	al
	asral	r7, r7, 32
	it	al
	asral	r0, 1
	it	al
	asral	r15, 32
	it	al
	asral	r0, r0, 1
	it	al
	asral	r15, r15, 32
	it	al
	asral	r0, r0
	it	al
	asral	r7, r7
	it	al
	asral	r0, r0, r0
	it	al
	asral	r7, r7, r7
	it	al
	asral	r0, r0
	it	al
	asral	r15, r15
	it	al
	asral	r0, r0, r0
	it	al
	asral	r15, r15, r15
	asr	r0, 1
	asr	r15, 31
	asr	r0, r0, 1
	asr	r15, r15, 31
	asr	r0, r0
	asr	r15, r15
	asr	r0, r0, r0
	asr	r15, r15, r15

positive: asrs instruction

	asrs	r0, 1
	asrs	r7, 32
	asrs	r0, r0, 1
	asrs	r7, r7, 32
	asrs	r0, 1
	asrs	r15, 32
	asrs	r0, r0, 1
	asrs	r15, r15, 32
	asrs	r0, r0
	asrs	r7, r7
	asrs	r0, r0, r0
	asrs	r7, r7, r7
	asrs	r0, r0
	asrs	r15, r15
	asrs	r0, r0, r0
	asrs	r15, r15, r15

positive: b instruction

	beq	-256
	beq	+254
	b	-2048
	b	+2046
	beq	-1048576
	beq	+1048574
	b	-16777216
	b	+16777214

positive: bfc instruction

	bfc	r0, 0, 32
	bfc	r15, 31, 1

positive: bfi instruction

	bfi r0, r0, 0, 32
	bfi r15, r15, 31, 1

positive: bic instruction

	bic	r0, 0
	bic	r15, 0xff000000
	bic	r0, r0, 0
	bic	r15, r15, 0xff000000
	it	al
	bical	r0, r0
	it	al
	bical	r7, r7
	it	al
	bical	r0, r0, r0
	it	al
	bical	r7, r7, r7
	bic	r0, r0, rrx
	bic	r15, r15, rrx
	bic	r0, r0, r0, rrx
	bic	r15, r15, r15, rrx
	bic	r0, r0
	bic	r15, r15
	bic	r0, r0, r0
	bic	r15, r15, r15
	bic	r0, r0, lsl 1
	bic	r15, r15, ror 31
	bic	r0, r0, r0, lsl 1
	bic	r15, r15, r15, ror 31

positive: bics instruction

	bics	r0, 0
	bics	r15, 0xff000000
	bics	r0, r0, 0
	bics	r15, r15, 0xff000000
	bics	r0, r0
	bics	r7, r7
	bics	r0, r0, r0
	bics	r7, r7, r7
	bics	r0, r0, rrx
	bics	r15, r15, rrx
	bics	r0, r0, r0, rrx
	bics	r15, r15, r15, rrx
	bics	r0, r0
	bics	r15, r15
	bics	r0, r0, r0
	bics	r15, r15, r15
	bics	r0, r0, lsl 1
	bics	r15, r15, ror 31
	bics	r0, r0, r0, lsl 1
	bics	r15, r15, r15, ror 31

positive: bl instruction

	bl	-16777216
	bl	+16777214

positive: blx instruction

	blx	-16777216
	blx	+16777212
	blx	r0
	blx	r15

positive: bx instruction

	bx	r0
	bx	r15

positive: bxj instruction

	bxj	r0
	bxj	r15

positive: cbnz instruction

	cbnz	r0, 0
	cbnz	r7, 126

positive: cbz instruction

	cbz	r0, 0
	cbz	r7, 126

positive: clrex instruction

	clrex

positive: clz instruction

	clz	r0, r0
	clz	r15, r15

positive: cmn instruction

	cmn	r0, 0
	cmn	r15, 0xff000000
	cmn	r0, r0
	cmn	r7, r7
	cmn	r0, r0, rrx
	cmn	r15, r15, rrx
	cmn	r0, r0
	cmn	r15, r15
	cmn	r0, r0, lsl 1
	cmn	r15, r15, ror 31

positive: cmp instruction

	cmp	r0, 0
	cmp	r0, 255
	cmp	r0, 0
	cmp	r15, 0xff000000
	cmp	r0, r0
	cmp	r7, r7
	cmp	r0, r0
	cmp	r15, r15
	cmp	r0, r0, rrx
	cmp	r15, r15, rrx
	cmp	r0, r0
	cmp	r15, r15
	cmp	r0, r0, lsl 1
	cmp	r15, r15, ror 31

positive: cps instruction

	cps	0
	cps	31

positive: cpsid instruction

	cpsid	a
	cpsid	aif
	cpsid.w	a
	cpsid.w	aif
	cpsid	a, 0
	cpsid	aif, 31

positive: cpsie instruction

	cpsie	a
	cpsie	aif
	cpsie.w	a
	cpsie.w	aif
	cpsie	a, 0
	cpsie	aif, 31

positive: crc32b instruction

	crc32b	r0, r0, r0
	crc32b	r15, r15, r15

positive: crc32h instruction

	crc32h	r0, r0, r0
	crc32h	r15, r15, r15

positive: crc32w instruction

	crc32w	r0, r0, r0
	crc32w	r15, r15, r15

positive: crc32cb instruction

	crc32cb	r0, r0, r0
	crc32cb	r15, r15, r15

positive: crc32ch instruction

	crc32ch	r0, r0, r0
	crc32ch	r15, r15, r15

positive: crc32cw instruction

	crc32cw	r0, r0, r0
	crc32cw	r15, r15, r15

positive: dbg instruction

	dbg	0
	dbg	15

positive: dcps1 instruction

	dcps1

positive: dcps2 instruction

	dcps2

positive: dcps3 instruction

	dcps3

positive: dmb instruction

	dmb
	dmb	sy
	dmb	st
	dmb	ld
	dmb	ish
	dmb	ishst
	dmb	ishld
	dmb	nsh
	dmb	nshst
	dmb	nshld
	dmb	osh
	dmb	oshst
	dmb	oshld

positive: dsb instruction

	dsb
	dsb	sy
	dsb	st
	dsb	ld
	dsb	ish
	dsb	ishst
	dsb	ishld
	dsb	nsh
	dsb	nshst
	dsb	nshld
	dsb	osh
	dsb	oshst
	dsb	oshld

positive: eor instruction

	eor	r0, 0
	eor	r15, 0xff000000
	eor	r0, r0, 0
	eor	r15, r15, 0xff000000
	it	al
	eoral	r0, r0
	it	al
	eoral	r7, r7
	it	al
	eoral	r0, r0, r0
	it	al
	eoral	r7, r7, r7
	eor	r0, r0, rrx
	eor	r15, r15, rrx
	eor	r0, r0, r0, rrx
	eor	r15, r15, r15, rrx
	eor	r0, r0
	eor	r15, r15
	eor	r0, r0, r0
	eor	r15, r15, r15
	eor	r0, r0, lsl 1
	eor	r15, r15, ror 31
	eor	r0, r0, r0, lsl 1
	eor	r15, r15, r15, ror 31

positive: eors instruction

	eors	r0, 0
	eors	r15, 0xff000000
	eors	r0, r0, 0
	eors	r15, r15, 0xff000000
	eors	r0, r0
	eors	r7, r7
	eors	r0, r0, r0
	eors	r7, r7, r7
	eors	r0, r0, rrx
	eors	r15, r15, rrx
	eors	r0, r0, r0, rrx
	eors	r15, r15, r15, rrx
	eors	r0, r0
	eors	r15, r15
	eors	r0, r0, r0
	eors	r15, r15, r15
	eors	r0, r0, lsl 1
	eors	r15, r15, ror 31
	eors	r0, r0, r0, lsl 1
	eors	r15, r15, r15, ror 31

positive: eret instruction

	eret

positive: esb instruction

	esb.w

positive: hlt instruction

	hlt	0
	hlt	63

positive: hvc instruction

	hvc	0
	hvc	65535

positive: isb instruction

	isb
	isb	sy

positive: it instruction

	it	eq
	nopeq
	it	ne
	nopne
	it	cs
	nopcs
	it	cc
	nopcc
	it	mi
	nopmi
	it	pl
	noppl
	it	vs
	nopvs
	it	vc
	nopvc
	it	hi
	nophi
	it	ls
	nopls
	it	ge
	nopge
	it	lt
	noplt
	it	gt
	nopgt
	it	le
	nople
	it	al
	nopal

positive: lda instruction

	lda	r0, [r0]
	lda	r15, [r15]

positive: ldab instruction

	ldab	r0, [r0]
	ldab	r15, [r15]

positive: ldaex instruction

	ldaex	r0, [r0]
	ldaex	r15, [r15]

positive: ldaexb instruction

	ldaexb	r0, [r0]
	ldaexb	r15, [r15]

positive: ldaexd instruction

	ldaexd	r0, r0, [r0]
	ldaexd	r15, r15, [r15]

positive: ldaexh instruction

	ldaexh	r0, [r0]
	ldaexh	r15, [r15]

positive: ldah instruction

	ldah	r0, [r0]
	ldah	r15, [r15]

positive: ldc instruction

	ldc	p14, c5, [r0, -1020]
	ldc	p14, c5, [r15, +1020]
	ldc	p14, c5, [r0], -1020
	ldc	p14, c5, [r15], +1020
	ldc	p14, c5, [r0, -1020]!
	ldc	p14, c5, [r15, +1020]!
	ldc	p14, c5, [r0], 0
	ldc	p14, c5, [r15], 255
	ldc	p14, c5, -1020
	ldc	p14, c5, +1020
	ldc	p14, c5, [pc, -1020]
	ldc	p14, c5, [pc, +1020]

positive: ldm instruction

	ldm	r0!, {}
	ldm	r0, {r0, r7}
	ldm	r0, {}
	ldm	r15!, {r0, r15}

positive: ldmia instruction

	ldmia	r0!, {}
	ldmia	r0, {r0, r7}
	ldmia	r0, {}
	ldmia	r15!, {r0, r15}

positive: ldmfd instruction

	ldmfd	r0!, {}
	ldmfd	r0, {r0, r7}
	ldmfd	r0, {}
	ldmfd	r15!, {r0, r15}

positive: ldmdb instruction

	ldmdb	r0, {}
	ldmdb	r15!, {r0, r15}

positive: ldmea instruction

	ldmea	r0, {}
	ldmea	r15!, {r0, r15}

positive: ldr instruction

	ldr	r0, [r0, 0]
	ldr	r7, [r7, 120]
	ldr	r0, [sp, 0]
	ldr	r7, [sp, 1020]
	ldr	r0, [r0, 0]
	ldr	r15, [r15, 4095]
	ldr	r0, [r0, -255]
	ldr	r15, [r15, -0]
	ldr	r0, [r0], -255
	ldr	r15, [r15], +255
	ldr	r0, [r0, -255]!
	ldr	r15, [r15, +255]!
	ldr	r0, 0
	ldr	r7, 1020
	ldr	r0, 0
	ldr	r15, 4095
	ldr	r0, [r0, r0]
	ldr	r7, [r7, r7]
	ldr	r0, [r0, r0]
	ldr	r15, [r15, r15]
	ldr	r0, [r0, r0, lsl 0]
	ldr	r15, [r15, r15, lsl 3]

positive: ldrb instruction

	ldrb	r0, [r0, 0]
	ldrb	r7, [r7, 31]
	ldrb	r0, [r0, 0]
	ldrb	r15, [r15, 4095]
	ldrb	r0, [r0, -255]
	ldrb	r15, [r15, -0]
	ldrb	r0, [r0], -255
	ldrb	r15, [r15], +255
	ldrb	r0, [r0, -255]!
	ldrb	r15, [r15, +255]!
	ldrb	r0, 0
	ldrb	r15, 4095
	ldrb	r0, [r0, r0]
	ldrb	r7, [r7, r7]
	ldrb	r0, [r0, r0]
	ldrb	r15, [r15, r15]
	ldrb	r0, [r0, r0, lsl 0]
	ldrb	r15, [r15, r15, lsl 3]

positive: ldrbt instruction

	ldrbt	r0, [r0, 0]
	ldrbt	r15, [r15, 255]

positive: ldrd instruction

	ldrd	r0, r0, [r0, -1020]
	ldrd	r15, r15, [r15, +1020]
	ldrd	r0, r0, [r0], -1020
	ldrd	r15, r15, [r15], +1020
	ldrd	r0, r0, [r0, -1020]!
	ldrd	r15, r15, [r15, +1020]!
	ldrd	r0, r0, -1020
	ldrd	r15, r15, +1020
	ldrd	r0, r0, [pc, -1020]
	ldrd	r15, r15, [pc, +1020]

positive: ldrex instruction

	ldrex	r0, [r0, 0]
	ldrex	r15, [r15, 1020]

positive: ldrexb instruction

	ldrexb	r0, [r0]
	ldrexb	r15, [r15]

positive: ldrexd instruction

	ldrexd	r0, r0, [r0]
	ldrexd	r15, r15, [r15]

positive: ldrexh instruction

	ldrexh	r0, [r0]
	ldrexh	r15, [r15]

positive: ldrh instruction

	ldrh	r0, [r0, 0]
	ldrh	r7, [r7, 62]
	ldrh	r0, [r0, 0]
	ldrh	r15, [r15, 4095]
	ldrh	r0, [r0, -255]
	ldrh	r15, [r15, -0]
	ldrh	r0, [r0], -255
	ldrh	r15, [r15], +255
	ldrh	r0, [r0, -255]!
	ldrh	r15, [r15, +255]!
	ldrh	r0, 0
	ldrh	r15, 4095
	ldrh	r0, [r0, r0]
	ldrh	r7, [r7, r7]
	ldrh	r0, [r0, r0]
	ldrh	r15, [r15, r15]
	ldrh	r0, [r0, r0, lsl 0]
	ldrh	r15, [r15, r15, lsl 3]

positive: ldrht instruction

	ldrht	r0, [r0, 0]
	ldrht	r15, [r15, 255]

positive: ldrsb instruction

	ldrsb	r0, [r0, 0]
	ldrsb	r15, [r15, 4095]
	ldrsb	r0, [r0, -255]
	ldrsb	r15, [r15, -0]
	ldrsb	r0, [r0], -255
	ldrsb	r15, [r15], +255
	ldrsb	r0, [r0, -255]!
	ldrsb	r15, [r15, +255]!
	ldrsb	r0, 0
	ldrsb	r15, 4095
	ldrsb	r0, [r0, r0]
	ldrsb	r7, [r7, r7]
	ldrsb	r0, [r0, r0]
	ldrsb	r15, [r15, r15]
	ldrsb	r0, [r0, r0, lsl 0]
	ldrsb	r15, [r15, r15, lsl 3]

positive: ldrsbt instruction

	ldrsbt	r0, [r0, 0]
	ldrsbt	r15, [r15, 255]

positive: ldrsh instruction

	ldrsh	r0, [r0, 0]
	ldrsh	r15, [r15, 4095]
	ldrsh	r0, [r0, -255]
	ldrsh	r15, [r15, -0]
	ldrsh	r0, [r0], -255
	ldrsh	r15, [r15], +255
	ldrsh	r0, [r0, -255]!
	ldrsh	r15, [r15, +255]!
	ldrsh	r0, 0
	ldrsh	r15, 4095
	ldrsh	r0, [r0, r0]
	ldrsh	r7, [r7, r7]
	ldrsh	r0, [r0, r0]
	ldrsh	r15, [r15, r15]
	ldrsh	r0, [r0, r0, lsl 0]
	ldrsh	r15, [r15, r15, lsl 3]

positive: ldrsht instruction

	ldrsht	r0, [r0, 0]
	ldrsht	r15, [r15, 255]

positive: ldrt instruction

	ldrt	r0, [r0, 0]
	ldrt	r15, [r15, 255]

positive: strt instruction

	strt	r0, [r0, 0]
	strt	r15, [r15, 255]

positive: lsl instruction

	it	al
	lslal	r0, 1
	it	al
	lslal	r7, 31
	it	al
	lslal	r0, r0, 1
	it	al
	lslal	r7, r7, 31
	it	al
	lslal	r0, 1
	it	al
	lslal	r15, 31
	it	al
	lslal	r0, r0, 1
	it	al
	lslal	r15, r15, 31
	it	al
	lslal	r0, r0
	it	al
	lslal	r7, r7
	it	al
	lslal	r0, r0, r0
	it	al
	lslal	r7, r7, r7
	it	al
	lslal	r0, r0
	it	al
	lslal	r15, r15
	it	al
	lslal	r0, r0, r0
	it	al
	lslal	r15, r15, r15
	lsl	r0, 1
	lsl	r15, 31
	lsl	r0, r0, 1
	lsl	r15, r15, 31
	lsl	r0, r0
	lsl	r15, r15
	lsl	r0, r0, r0
	lsl	r15, r15, r15

positive: lsls instruction

	lsls	r0, 1
	lsls	r7, 31
	lsls	r0, r0, 1
	lsls	r7, r7, 31
	lsls	r0, 1
	lsls	r15, 31
	lsls	r0, r0, 1
	lsls	r15, r15, 31
	lsls	r0, r0
	lsls	r7, r7
	lsls	r0, r0, r0
	lsls	r7, r7, r7
	lsls	r0, r0
	lsls	r15, r15
	lsls	r0, r0, r0
	lsls	r15, r15, r15

positive: lsr instruction

	it	al
	lsral	r0, 1
	it	al
	lsral	r7, 32
	it	al
	lsral	r0, r0, 1
	it	al
	lsral	r7, r7, 32
	it	al
	lsral	r0, 1
	it	al
	lsral	r15, 32
	it	al
	lsral	r0, r0, 1
	it	al
	lsral	r15, r15, 32
	it	al
	lsral	r0, r0
	it	al
	lsral	r7, r7
	it	al
	lsral	r0, r0, r0
	it	al
	lsral	r7, r7, r7
	it	al
	lsral	r0, r0
	it	al
	lsral	r15, r15
	it	al
	lsral	r0, r0, r0
	it	al
	lsral	r15, r15, r15
	lsr	r0, 1
	lsr	r15, 31
	lsr	r0, r0, 1
	lsr	r15, r15, 31
	lsr	r0, r0
	lsr	r15, r15
	lsr	r0, r0, r0
	lsr	r15, r15, r15

positive: lsrs instruction

	lsrs	r0, 1
	lsrs	r7, 32
	lsrs	r0, r0, 1
	lsrs	r7, r7, 32
	lsrs	r0, 1
	lsrs	r15, 32
	lsrs	r0, r0, 1
	lsrs	r15, r15, 32
	lsrs	r0, r0
	lsrs	r7, r7
	lsrs	r0, r0, r0
	lsrs	r7, r7, r7
	lsrs	r0, r0
	lsrs	r15, r15
	lsrs	r0, r0, r0
	lsrs	r15, r15, r15

positive: mcr instruction

	mcr	p14, 0, r0, c0, c0
	mcr	p15, 7, r15, c15, c15
	mcr	p14, 0, r0, c0, c0, 0
	mcr	p15, 7, r15, c15, c15, 7

positive: mcrr instruction

	mcrr	p14, 0, r0, r0, c0
	mcrr	p15, 15, r15, r15, c15

positive: mla instruction

	mla	r0, r0, r0, r0
	mla	r15, r15, r15, r15

positive: mls instruction

	mls	r0, r0, r0, r0
	mls	r15, r15, r15, r15

positive: mov instruction

	it	al
	moval	r0, 0
	it	al
	moval	r7, 255
	it	al
	moval	r0, 0
	it	al
	moval	r15, 0xff000000
	mov	r0, 0
	mov	r15, 0xff000000
	mov	r0, 0
	mov	r0, 65535
	mov	r0, r1
	mov	r15, r15
	it	al
	moval	r0, r0
	it	al
	moval	r7, r7
	it	al
	moval	r0, r0, lsl 1
	it	al
	moval	r7, r7, lsl 31
	it	al
	moval	r0, r0, asr 1
	it	al
	moval	r7, r7, asr 32
	mov	r0, r0, rrx
	mov	r15, r15, rrx
	mov	r0, r0
	mov	r15, r15
	mov	r0, r0, lsl 1
	mov	r15, r15, ror 31
	it	al
	moval	r0, r0, asr r0
	it	al
	moval	r7, r7, asr r7
	it	al
	moval	r0, r0, lsl r0
	it	al
	moval	r7, r7, lsl r7
	it	al
	moval	r0, r0, lsr r0
	it	al
	moval	r7, r7, lsr r7
	it	al
	moval	r0, r0, ror r0
	it	al
	moval	r7, r7, ror r7
	it	al
	moval	r0, r0, lsl r0
	it	al
	moval	r15, r15, ror r15

positive: movs instruction

	movs	r0, 0
	movs	r7, 255
	movs	r0, 0
	movs	r15, 0xff000000
	movs	r0, r0
	movs	r7, r7
	movs	r0, r0, lsl 1
	movs	r7, r7, lsl 31
	movs	r0, r0, asr 1
	movs	r7, r7, asr 32
	movs	r0, r0, rrx
	movs	r15, r15, rrx
	movs	r0, r0
	movs	r15, r15
	movs	r0, r0, lsl 1
	movs	r15, r15, ror 31
	movs	r0, r0, asr r0
	movs	r7, r7, asr r7
	movs	r0, r0, lsl r0
	movs	r7, r7, lsl r7
	movs	r0, r0, lsr r0
	movs	r7, r7, lsr r7
	movs	r0, r0, ror r0
	movs	r7, r7, ror r7
	movs	r0, r0, lsl r0
	movs	r15, r15, ror r15

positive: movt instruction

	movt	r0, 0
	movt	r15, 65535

positive: movw instruction

	movw	r0, 0
	movw	r0, 65535

positive: mrc instruction

	mrc	p14, 0, r0, c0, c0
	mrc	p15, 7, r15, c15, c15
	mrc	p14, 0, r0, c0, c0, 0
	mrc	p15, 7, r15, c15, c15, 7

positive: mrrc instruction

	mrrc	p14, 0, r0, r0, c0
	mrrc	p15, 15, r15, r15, c15

positive: mul instruction

	it	al
	mulal	r0, r0
	it	al
	mulal	r7, r7
	it	al
	mulal	r0, r0, r0
	it	al
	mulal	r7, r7, r7
	it	al
	mulal	r0, r0
	it	al
	mulal	r15, r15
	it	al
	mulal	r0, r0, r0
	it	al
	mulal	r15, r15, r15
	mul	r0, r0
	mul	r7, r7
	mul	r0, r0, r0
	mul	r7, r7, r7

positive: muls instruction

	muls	r0, r0
	muls	r7, r7
	muls	r0, r0, r0
	muls	r7, r7, r7

positive: mvn instruction

	mvn	r0, 0
	mvn	r15, 0xff000000
	it	al
	mvnal	r0, r0
	it	al
	mvnal	r7, r7
	mvn	r0, r0, rrx
	mvn	r15, r15, rrx
	mvn	r0, r0
	mvn	r15, r15
	mvn	r0, r0, lsl 1
	mvn	r15, r15, ror 31

positive: mvns instruction

	mvns	r0, 0
	mvns	r15, 0xff000000
	mvns	r0, r0
	mvns	r7, r7
	mvns	r0, r0, rrx
	mvns	r15, r15, rrx
	mvns	r0, r0
	mvns	r15, r15
	mvns	r0, r0, lsl 1
	mvns	r15, r15, ror 31

positive: nop instruction

	nop
	nop.n
	nop.w

positive: orn instruction

	orn	r0, 0
	orn	r15, 0xff000000
	orn	r0, r0, 0
	orn	r15, r15, 0xff000000
	orn	r0, r0, rrx
	orn	r15, r15, rrx
	orn	r0, r0, r0, rrx
	orn	r15, r15, r15, rrx
	orn	r0, r0
	orn	r15, r15
	orn	r0, r0, r0
	orn	r15, r15, r15
	orn	r0, r0, lsl 1
	orn	r15, r15, ror 31
	orn	r0, r0, r0, lsl 1
	orn	r15, r15, r15, ror 31

positive: orns instruction

	orns	r0, 0
	orns	r15, 0xff000000
	orns	r0, r0, 0
	orns	r15, r15, 0xff000000
	orns	r0, r0, rrx
	orns	r15, r15, rrx
	orns	r0, r0, r0, rrx
	orns	r15, r15, r15, rrx
	orns	r0, r0
	orns	r15, r15
	orns	r0, r0, r0
	orns	r15, r15, r15
	orns	r0, r0, lsl 1
	orns	r15, r15, ror 31
	orns	r0, r0, r0, lsl 1
	orns	r15, r15, r15, ror 31

positive: orr instruction

	orr	r0, 0
	orr	r15, 0xff000000
	orr	r0, r0, 0
	orr	r15, r15, 0xff000000
	it	al
	orral	r0, r0
	it	al
	orral	r7, r7
	it	al
	orral	r0, r0, r0
	it	al
	orral	r7, r7, r7
	orr	r0, r0, rrx
	orr	r15, r15, rrx
	orr	r0, r0, r0, rrx
	orr	r15, r15, r15, rrx
	orr	r0, r0
	orr	r15, r15
	orr	r0, r0, r0
	orr	r15, r15, r15
	orr	r0, r0, lsl 1
	orr	r15, r15, ror 31
	orr	r0, r0, r0, lsl 1
	orr	r15, r15, r15, ror 31

positive: orrs instruction

	orrs	r0, 0
	orrs	r15, 0xff000000
	orrs	r0, r0, 0
	orrs	r15, r15, 0xff000000
	orrs	r0, r0
	orrs	r7, r7
	orrs	r0, r0, r0
	orrs	r7, r7, r7
	orrs	r0, r0, rrx
	orrs	r15, r15, rrx
	orrs	r0, r0, r0, rrx
	orrs	r15, r15, r15, rrx
	orrs	r0, r0
	orrs	r15, r15
	orrs	r0, r0, r0
	orrs	r15, r15, r15
	orrs	r0, r0, lsl 1
	orrs	r15, r15, ror 31
	orrs	r0, r0, r0, lsl 1
	orrs	r15, r15, r15, ror 31

positive: pkhbt instruction

	pkhbt	r0, r0
	pkhbt	r15, r15
	pkhbt	r0, r0, r0
	pkhbt	r0, r15, r15
	pkhbt	r0, r0, lsl 1
	pkhbt	r15, r15, lsl 31
	pkhbt	r0, r0, r0, lsl 1
	pkhbt	r0, r15, r15, lsl 31

positive: pkhtb instruction

	pkhtb	r0, r0
	pkhtb	r15, r15
	pkhtb	r0, r0, r0
	pkhtb	r0, r15, r15
	pkhtb	r0, r0, asr 1
	pkhtb	r15, r15, asr 32
	pkhtb	r0, r0, r0, asr 1
	pkhtb	r0, r15, r15, asr 32

positive: pld instruction

	pld	[r0, 0]
	pld	[r15, 4095]
	pld	[r0, -255]
	pld	[r15, -0]
	pld	-4095
	pld	+4095
	pld	[r0, r0]
	pld	[r15, r15]
	pld	[r0, r0, lsl 0]
	pld	[r15, r15, lsl 3]

positive: pldw instruction

	pldw	[r0, 0]
	pldw	[r15, 4095]
	pldw	[r0, -255]
	pldw	[r15, -0]
	pldw	[r0, r0]
	pldw	[r15, r15]
	pldw	[r0, r0, lsl 0]
	pldw	[r15, r15, lsl 3]

positive: pli instruction

	pli	[r0, 0]
	pli	[r15, 4095]
	pli	[r0, -255]
	pli	[r15, -0]
	pli	-4095
	pli	+4095
	pli	[r0, r0]
	pli	[r15, r15]
	pli	[r0, r0, lsl 0]
	pli	[r15, r15, lsl 3]

positive: pop instruction

	pop	{}
	pop	{r0, r7, r15}
	pop	{}
	pop	{r0, r15}
	pop	{r0}
	pop	{r15}

positive: push instruction

	push	{}
	push	{r0, r7, r15}
	push	{}
	push	{r0, r15}
	push	{r0}
	push	{r15}

positive: qadd instruction

	qadd	r0, r0
	qadd	r15, r15
	qadd	r0, r0, r0
	qadd	r15, r15, r15

positive: qadd16 instruction

	qadd16	r0, r0
	qadd16	r15, r15
	qadd16	r0, r0, r0
	qadd16	r15, r15, r15

positive: qadd8 instruction

	qadd8	r0, r0
	qadd8	r15, r15
	qadd8	r0, r0, r0
	qadd8	r15, r15, r15

positive: qasx instruction

	qasx	r0, r0
	qasx	r15, r15
	qasx	r0, r0, r0
	qasx	r15, r15, r15

positive: qdadd instruction

	qdadd	r0, r0
	qdadd	r15, r15
	qdadd	r0, r0, r0
	qdadd	r15, r15, r15

positive: qdsub instruction

	qdsub	r0, r0
	qdsub	r15, r15
	qdsub	r0, r0, r0
	qdsub	r15, r15, r15

positive: qsax instruction

	qsax	r0, r0
	qsax	r15, r15
	qsax	r0, r0, r0
	qsax	r15, r15, r15

positive: qsub instruction

	qsub	r0, r0
	qsub	r15, r15
	qsub	r0, r0, r0
	qsub	r15, r15, r15

positive: qsub16 instruction

	qsub16	r0, r0
	qsub16	r15, r15
	qsub16	r0, r0, r0
	qsub16	r15, r15, r15

positive: qsub8 instruction

	qsub8	r0, r0
	qsub8	r15, r15
	qsub8	r0, r0, r0
	qsub8	r15, r15, r15

positive: rbit instruction

	rbit	r0, r0
	rbit	r15, r15

positive: rev instruction

	rev	r0, r0
	rev	r7, r7
	rev	r0, r0
	rev	r15, r15

positive: rev16 instruction

	rev16	r0, r0
	rev16	r7, r7
	rev16	r0, r0
	rev16	r15, r15

positive: revsh instruction

	revsh	r0, r0
	revsh	r7, r7
	revsh	r0, r0
	revsh	r15, r15

positive: rfe instruction

	rfe	r0
	rfe	r15!

positive: rfedb instruction

	rfedb	r0
	rfedb	r15!

positive: rfeia instruction

	rfeia	r0
	rfeia	r15!

positive: ror instruction

	it	al
	roral	r0, 1
	it	al
	roral	r15, 31
	it	al
	roral	r0, r0, 1
	it	al
	roral	r15, r15, 31
	it	al
	roral	r0, r0
	it	al
	roral	r7, r7
	it	al
	roral	r0, r0, r0
	it	al
	roral	r7, r7, r7
	it	al
	roral	r0, r0
	it	al
	roral	r15, r15
	it	al
	roral	r0, r0, r0
	it	al
	roral	r15, r15, r15
	ror	r0, 1
	ror	r15, 31
	ror	r0, r0, 1
	ror	r15, r15, 31
	ror	r0, r0
	ror	r15, r15
	ror	r0, r0, r0
	ror	r15, r15, r15

positive: rors instruction

	rors	r0, 1
	rors	r15, 31
	rors	r0, r0, 1
	rors	r15, r15, 31
	rors	r0, r0
	rors	r7, r7
	rors	r0, r0, r0
	rors	r7, r7, r7
	rors	r0, r0
	rors	r15, r15
	rors	r0, r0, r0
	rors	r15, r15, r15

positive: rrx instruction

	rrx	r0
	rrx	r15
	rrx	r0, r0
	rrx	r15, r15

positive: rrxs instruction

	rrxs	r0
	rrxs	r15
	rrxs	r0, r0
	rrxs	r15, r15

positive: rsb instruction

	it	al
	rsbal	r0, 0
	it	al
	rsbal	r7, 0
	it	al
	rsbal	r0, r0, 0
	it	al
	rsbal	r7, r7, 0
	rsb	r0, 0
	rsb	r15, 0xff000000
	rsb	r0, r0, 0
	rsb	r15, r15, 0xff000000
	rsb	r0, r0, rrx
	rsb	r15, r15, rrx
	rsb	r0, r0, r0, rrx
	rsb	r15, r15, r15, rrx
	rsb	r0, r0
	rsb	r15, r15
	rsb	r0, r0, r0
	rsb	r15, r15, r15
	rsb	r0, r0, lsl 1
	rsb	r15, r15, ror 31
	rsb	r0, r0, r0, lsl 1
	rsb	r15, r15, r15, ror 31

positive: rsbs instruction

	rsbs	r0, 0
	rsbs	r7, 0
	rsbs	r0, r0, 0
	rsbs	r7, r7, 0
	rsbs	r0, 0
	rsbs	r15, 0xff000000
	rsbs	r0, r0, 0
	rsbs	r15, r15, 0xff000000
	rsbs	r0, r0, rrx
	rsbs	r15, r15, rrx
	rsbs	r0, r0, r0, rrx
	rsbs	r15, r15, r15, rrx
	rsbs	r0, r0
	rsbs	r15, r15
	rsbs	r0, r0, r0
	rsbs	r15, r15, r15
	rsbs	r0, r0, lsl 1
	rsbs	r15, r15, ror 31
	rsbs	r0, r0, r0, lsl 1
	rsbs	r15, r15, r15, ror 31

positive: sadd16 instruction

	sadd16	r0, r0
	sadd16	r15, r15
	sadd16	r0, r0, r0
	sadd16	r15, r15, r15

positive: sadd8 instruction

	sadd8	r0, r0
	sadd8	r15, r15
	sadd8	r0, r0, r0
	sadd8	r15, r15, r15

positive: sasx instruction

	sasx	r0, r0
	sasx	r15, r15
	sasx	r0, r0, r0
	sasx	r15, r15, r15

positive: sbc instruction

	sbc	r0, 0
	sbc	r15, 0xff000000
	sbc	r0, r0, 0
	sbc	r15, r15, 0xff000000
	it	al
	sbcal	r0, r0
	it	al
	sbcal	r7, r7
	it	al
	sbcal	r0, r0, r0
	it	al
	sbcal	r7, r7, r7
	sbc	r0, r0, rrx
	sbc	r15, r15, rrx
	sbc	r0, r0, r0, rrx
	sbc	r15, r15, r15, rrx
	sbc	r0, r0
	sbc	r15, r15
	sbc	r0, r0, r0
	sbc	r15, r15, r15
	sbc	r0, r0, lsl 1
	sbc	r15, r15, ror 31
	sbc	r0, r0, r0, lsl 1
	sbc	r15, r15, r15, ror 31

positive: sbcs instruction

	sbcs	r0, 0
	sbcs	r15, 0xff000000
	sbcs	r0, r0, 0
	sbcs	r15, r15, 0xff000000
	sbcs	r0, r0
	sbcs	r7, r7
	sbcs	r0, r0, r0
	sbcs	r7, r7, r7
	sbcs	r0, r0, rrx
	sbcs	r15, r15, rrx
	sbcs	r0, r0, r0, rrx
	sbcs	r15, r15, r15, rrx
	sbcs	r0, r0
	sbcs	r15, r15
	sbcs	r0, r0, r0
	sbcs	r15, r15, r15
	sbcs	r0, r0, lsl 1
	sbcs	r15, r15, ror 31
	sbcs	r0, r0, r0, lsl 1
	sbcs	r15, r15, r15, ror 31

positive: sbfx instruction

	sbfx	r0, r0, 0, 32
	sbfx	r15, r15, 31, 1

positive: sdiv instruction

	sdiv	r0, r0
	sdiv	r15, r15
	sdiv	r0, r0, r0
	sdiv	r15, r15, r15

positive: sel instruction

	sel	r0, r0
	sel	r15, r15
	sel	r0, r0, r0
	sel	r15, r15, r15

positive: setend instruction

	setend	0
	setend	1

positive: setpan instruction

	setpan	0
	setpan	1

positive: sev instruction

	sev
	sev.n
	sev.w

positive: sevl instruction

	sevl
	sevl.n
	sevl.w

positive: shadd16 instruction

	shadd16	r0, r0
	shadd16	r15, r15
	shadd16	r0, r0, r0
	shadd16	r15, r15, r15

positive: shadd8 instruction

	shadd8	r0, r0
	shadd8	r15, r15
	shadd8	r0, r0, r0
	shadd8	r15, r15, r15

positive: shasx instruction

	shasx	r0, r0
	shasx	r15, r15
	shasx	r0, r0, r0
	shasx	r15, r15, r15

positive: shsax instruction

	shsax	r0, r0
	shsax	r15, r15
	shsax	r0, r0, r0
	shsax	r15, r15, r15

positive: shsub16 instruction

	shsub16	r0, r0
	shsub16	r15, r15
	shsub16	r0, r0, r0
	shsub16	r15, r15, r15

positive: shsub8 instruction

	shsub8	r0, r0
	shsub8	r15, r15
	shsub8	r0, r0, r0
	shsub8	r15, r15, r15

positive: smc instruction

	smc	0
	smc	15

positive: smlabb instruction

	smlabb	r0, r0, r0, r0
	smlabb	r15, r15, r15, r15

positive: smlabt instruction

	smlabt	r0, r0, r0, r0
	smlabt	r15, r15, r15, r15

positive: smlatb instruction

	smlatb	r0, r0, r0, r0
	smlatb	r15, r15, r15, r15

positive: smlatt instruction

	smlatt	r0, r0, r0, r0
	smlatb	r15, r15, r15, r15

positive: smlad instruction

	smlad	r0, r0, r0, r0
	smlad	r15, r15, r15, r15

positive: smladx instruction

	smladx	r0, r0, r0, r0
	smladx	r15, r15, r15, r15

positive: smlal instruction

	smlal	r0, r0, r0, r0
	smlal	r15, r15, r15, r15

positive: smlalbb instruction

	smlalbb	r0, r0, r0, r0
	smlalbb	r15, r15, r15, r15

positive: smlalbt instruction

	smlalbt	r0, r0, r0, r0
	smlalbt	r15, r15, r15, r15

positive: smlaltb instruction

	smlaltb	r0, r0, r0, r0
	smlaltb	r15, r15, r15, r15

positive: smlaltt instruction

	smlaltt	r0, r0, r0, r0
	smlaltt	r15, r15, r15, r15

positive: smlald instruction

	smlald	r0, r0, r0, r0
	smlald	r15, r15, r15, r15

positive: smlaldx instruction

	smlaldx	r0, r0, r0, r0
	smlaldx	r15, r15, r15, r15

positive: smlawb instruction

	smlawb	r0, r0, r0, r0
	smlawb	r15, r15, r15, r15

positive: smlawt instruction

	smlawt	r0, r0, r0, r0
	smlawt	r15, r15, r15, r15

positive: smlsd instruction

	smlsd	r0, r0, r0, r0
	smlsd	r15, r15, r15, r15

positive: smlsdx instruction

	smlsdx	r0, r0, r0, r0
	smlsdx	r15, r15, r15, r15

positive: smlsld instruction

	smlsld	r0, r0, r0, r0
	smlsld	r15, r15, r15, r15

positive: smlsldx instruction

	smlsldx	r0, r0, r0, r0
	smlsldx	r15, r15, r15, r15

positive: smmla instruction

	smmla	r0, r0, r0, r0
	smmla	r15, r15, r15, r15

positive: smmlar instruction

	smmlar	r0, r0, r0, r0
	smmlar	r15, r15, r15, r15

positive: smmls instruction

	smmls	r0, r0, r0, r0
	smmls	r15, r15, r15, r15

positive: smmlsr instruction

	smmlsr	r0, r0, r0, r0
	smmlsr	r15, r15, r15, r15

positive: smmul instruction

	smmul	r0, r0
	smmul	r15, r15
	smmul	r0, r0, r0
	smmul	r15, r15, r15

positive: smmulr instruction

	smmulr	r0, r0
	smmulr	r15, r15
	smmulr	r0, r0, r0
	smmulr	r15, r15, r15

positive: smuad instruction

	smuad	r0, r0
	smuad	r15, r15
	smuad	r0, r0, r0
	smuad	r15, r15, r15

positive: smuadx instruction

	smuadx	r0, r0
	smuadx	r15, r15
	smuadx	r0, r0, r0
	smuadx	r15, r15, r15

positive: smulbb instruction

	smulbb	r0, r0
	smulbb	r15, r15
	smulbb	r0, r0, r0
	smulbb	r15, r15, r15

positive: smulbt instruction

	smulbt	r0, r0
	smulbt	r15, r15
	smulbt	r0, r0, r0
	smulbt	r15, r15, r15

positive: smultb instruction

	smultb	r0, r0
	smultb	r15, r15
	smultb	r0, r0, r0
	smultb	r15, r15, r15

positive: smultt instruction

	smultt	r0, r0
	smultt	r15, r15
	smultt	r0, r0, r0
	smultt	r15, r15, r15

positive: smull instruction

	smull	r0, r0, r0, r0
	smull	r15, r15, r15, r15

positive: smulwb instruction

	smulwb	r0, r0
	smulwb	r15, r15
	smulwb	r0, r0, r0
	smulwb	r15, r15, r15

positive: smulwt instruction

	smulwt	r0, r0
	smulwt	r15, r15
	smulwt	r0, r0, r0
	smulwt	r15, r15, r15

positive: smusd instruction

	smusd	r0, r0
	smusd	r15, r15
	smusd	r0, r0, r0
	smusd	r15, r15, r15

positive: smusdx instruction

	smusdx	r0, r0
	smusdx	r15, r15
	smusdx	r0, r0, r0
	smusdx	r15, r15, r15

positive: srs instruction

	srs	sp, 0
	srs	sp!, 31

positive: srsdb instruction

	srsdb	sp, 0
	srsdb	sp!, 31

positive: srsia instruction

	srsia	sp, 0
	srsia	sp!, 31

positive: ssat instruction

	ssat	r0, 1, r0, asr 1
	ssat	r15, 32, r15, asr 31
	ssat	r0, 1, r0
	ssat	r15, 32, r15
	ssat	r0, 1, r0, lsl 1
	ssat	r15, 32, r15, lsl 31

positive: ssat16 instruction

	ssat16	r0, 1, r0
	ssat16	r15, 16, r15

positive: ssax instruction

	ssax	r0, r0
	ssax	r15, r15
	ssax	r0, r0, r0
	ssax	r15, r15, r15

positive: ssub16 instruction

	ssub16	r0, r0
	ssub16	r15, r15
	ssub16	r0, r0, r0
	ssub16	r15, r15, r15

positive: ssub8 instruction

	ssub8	r0, r0
	ssub8	r15, r15
	ssub8	r0, r0, r0
	ssub8	r15, r15, r15

positive: stc instruction

	stc	p14, c5, [r0, -1020]
	stc	p14, c5, [r15, +1020]
	stc	p14, c5, [r0], -1020
	stc	p14, c5, [r15], +1020
	stc	p14, c5, [r0, -1020]!
	stc	p14, c5, [r15, +1020]!
	stc	p14, c5, [r0], 0
	stc	p14, c5, [r15], 255

positive: stl instruction

	stl	r0, [r0]
	stl	r15, [r15]

positive: stlb instruction

	stlb	r0, [r0]
	stlb	r15, [r15]

positive: stlex instruction

	stlex	r0, r0, [r0]
	stlex	r15, r15, [r15]

positive: stlexb instruction

	stlexb	r0, r0, [r0]
	stlexb	r15, r15, [r15]

positive: stlexd instruction

	stlexd	r0, r0, r0, [r0]
	stlexd	r15, r15, r15, [r15]

positive: stlexh instruction

	stlexh	r0, r0, [r0]
	stlexh	r15, r15, [r15]

positive: stlh instruction

	stlh	r0, [r0]
	stlh	r15, [r15]

positive: stm instruction

	stm	r0!, {}
	stm	r7!, {r0, r7}
	stm	r0, {}
	stm	r15!, {r0, r15}

positive: stmia instruction

	stmia	r0!, {}
	stmia	r7!, {r0, r7}
	stmia	r0, {}
	stmia	r15!, {r0, r15}

positive: stmea instruction

	stmea	r0!, {}
	stmea	r7!, {r0, r7}
	stmea	r0, {}
	stmea	r15!, {r0, r15}

positive: stmfd instruction

	stmfd	r0, {}
	stmfd	r15!, {r0, r15}

positive: stmdb instruction

	stmdb	r0, {}
	stmdb	r15!, {r0, r15}

positive: str instruction

	str	r0, [r0, 0]
	str	r7, [r7, 120]
	str	r0, [sp, 0]
	str	r7, [sp, 1020]
	str	r0, [r0, 0]
	str	r15, [r15, 4095]
	str	r0, [r0, -255]
	str	r15, [r15, -0]
	str	r0, [r0], -255
	str	r15, [r15], +255
	str	r0, [r0, -255]!
	str	r15, [r15, +255]!
	str	r0, [r0, r0]
	str	r7, [r7, r7]
	str	r0, [r0, r0]
	str	r15, [r15, r15]
	str	r0, [r0, r0, lsl 0]
	str	r15, [r15, r15, lsl 3]

positive: strb instruction

	strb	r0, [r0, 0]
	strb	r7, [r7, 31]
	strb	r0, [r0, 0]
	strb	r15, [r15, 4095]
	strb	r0, [r0, -255]
	strb	r15, [r15, -0]
	strb	r0, [r0], -255
	strb	r15, [r15], +255
	strb	r0, [r0, -255]!
	strb	r15, [r15, +255]!
	strb	r0, [r0, r0]
	strb	r7, [r7, r7]
	strb	r0, [r0, r0]
	strb	r15, [r15, r15]
	strb	r0, [r0, r0, lsl 0]
	strb	r15, [r15, r15, lsl 3]

positive: strbt instruction

	strbt	r0, [r0, 0]
	strbt	r15, [r15, 255]

positive: strd instruction

	strd	r0, r0, [r0, -1020]
	strd	r15, r15, [r15, +1020]
	strd	r0, r0, [r0], -1020
	strd	r15, r15, [r15], +1020
	strd	r0, r0, [r0, -1020]!
	strd	r15, r15, [r15, +1020]!

positive: strex instruction

	strex	r0, r0, [r0, 0]
	strex	r15, r15, [r15, 1020]

positive: strexb instruction

	strexb	r0, r0, [r0]
	strexb	r15, r15, [r15]

positive: strexd instruction

	strexd	r0, r0, r0, [r0]
	strexd	r15, r15, r15, [r15]

positive: strexh instruction

	strexh	r0, r0, [r0]
	strexh	r15, r15, [r15]

positive: strh instruction

	strh	r0, [r0, 0]
	strh	r7, [r7, 62]
	strh	r0, [r0, 0]
	strh	r15, [r15, 4095]
	strh	r0, [r0, -255]
	strh	r15, [r15, -0]
	strh	r0, [r0], -255
	strh	r15, [r15], +255
	strh	r0, [r0, -255]!
	strh	r15, [r15, +255]!
	strh	r0, [r0, r0]
	strh	r7, [r7, r7]
	strh	r0, [r0, r0]
	strh	r15, [r15, r15]
	strh	r0, [r0, r0, lsl 0]
	strh	r15, [r15, r15, lsl 3]

positive: strht instruction

	strht	r0, [r0, 0]
	strht	r15, [r15, 255]

positive: sub instruction

	sub	r0, pc, 0
	sub	r15, pc, 4095
	it	al
	subal	r0, r0, 0
	it	al
	subal	r7, r7, 7
	it	al
	subal	r0, 0
	it	al
	subal	r7, 255
	it	al
	subal	r0, r0, 0
	it	al
	subal	r7, r7, 255
	sub	r0, 0
	sub	r15, 0xff000000
	sub	r0, r0, 0
	sub	r15, r15, 0xff000000
	sub	r0, 0
	sub	r15, 4095
	sub	r0, r0, 0
	sub	r15, r15, 4095
	it	al
	subal	r0, r0
	it	al
	subal	r7, r0
	it	al
	subal	r0, r0, r0
	it	al
	subal	r7, r7, r7
	sub	r0, r0, rrx
	sub	r15, r15, rrx
	sub	r0, r0, r0, rrx
	sub	r15, r15, r15, rrx
	sub	r0, r0
	sub	r15, r15
	sub	r0, r0, r0
	sub	r15, r15, r15
	sub	r0, r0, lsl 1
	sub	r15, r15, ror 31
	sub	r0, r0, r0, lsl 1
	sub	r15, r15, r15, ror 31
	sub	r0, sp, 0
	sub	r7, sp, 1020
	sub	sp, 0
	sub	sp, 0xff000000
	sub	r0, sp, 0
	sub	r15, sp, 0xff000000
	sub	sp, 0
	sub	sp, 4095
	sub	r0, sp, 0
	sub	r15, sp, 4095
	sub	sp, r0, rrx
	sub	sp, r15, rrx
	sub	r0, sp, r0, rrx
	sub	r15, sp, r15, rrx
	sub	sp, r0
	sub	sp, r15
	sub	sp, sp, r0
	sub	sp, sp, r15
	sub	sp, r0, lsl 1
	sub	sp, r15, ror 31
	sub	sp, sp, r0, lsl 1
	sub	sp, sp, r15, ror 31

positive: subs instruction

	subs	r0, r0, 0
	subs	r7, r7, 7
	subs	r0, 0
	subs	r7, 255
	subs	r0, r0, 0
	subs	r7, r7, 255
	subs	r0, 0
	subs	r15, 0xff000000
	subs	r0, r0, 0
	subs	r15, r15, 0xff000000
	subs	pc, lr, 0
	subs	pc, lr, 255
	subs	r0, r0
	subs	r7, r0
	subs	r0, r0, r0
	subs	r7, r7, r7
	subs	r0, r0, rrx
	subs	r15, r15, rrx
	subs	r0, r0, r0, rrx
	subs	r15, r15, r15, rrx
	subs	r0, r0
	subs	r15, r15
	subs	r0, r0, r0
	subs	r15, r15, r15
	subs	r0, r0, lsl 1
	subs	r15, r15, ror 31
	subs	r0, r0, r0, lsl 1
	subs	r15, r15, r15, ror 31
	subs	sp, 0
	subs	sp, 0xff000000
	subs	r0, sp, 0
	subs	r15, sp, 0xff000000
	subs	sp, r0, rrx
	subs	sp, r15, rrx
	subs	r0, sp, r0, rrx
	subs	r15, sp, r15, rrx
	subs	sp, r0
	subs	sp, r15
	subs	sp, sp, r0
	subs	sp, sp, r15
	subs	sp, r0, lsl 1
	subs	sp, r15, ror 31
	subs	r0, sp, r0, lsl 1
	subs	r15, sp, r15, ror 31

positive: subw instruction

	subw	r0, 0
	subw	r15, 4095
	subw	r0, r0, 0
	subw	r15, r15, 4095
	subw	sp, 0
	subw	sp, 4095
	subw	r0, sp, 0
	subw	r15, sp, 4095

positive: svc instruction

	svc	0
	svc	255

positive: sxtab instruction

	sxtab	r0, r0
	sxtab	r15, r15
	sxtab	r0, r0, ror 0
	sxtab	r15, r15, ror 24
	sxtab	r0, r0, r0
	sxtab	r15, r15, r15
	sxtab	r0, r0, r0, ror 0
	sxtab	r15, r15, r15, ror 24

positive: sxtab16 instruction

	sxtab16	r0, r0
	sxtab16	r15, r15
	sxtab16	r0, r0, ror 0
	sxtab16	r15, r15, ror 24
	sxtab16	r0, r0, r0
	sxtab16	r15, r15, r15
	sxtab16	r0, r0, r0, ror 0
	sxtab16	r15, r15, r15, ror 24

positive: sxtah instruction

	sxtah	r0, r0
	sxtah	r15, r15
	sxtah	r0, r0, ror 0
	sxtah	r15, r15, ror 24
	sxtah	r0, r0, r0
	sxtah	r15, r15, r15
	sxtah	r0, r0, r0, ror 0
	sxtah	r15, r15, r15, ror 24

positive: sxtb instruction

	sxtb	r0
	sxtb	r7
	sxtb	r0, r0
	sxtb	r7, r7
	sxtb	r0
	sxtb	r15
	sxtb	r0, ror 0
	sxtb	r15, ror 24
	sxtb	r0, r0
	sxtb	r15, r15
	sxtb	r0, r0, ror 0
	sxtb	r15, r15, ror 24

positive: sxtb16 instruction

	sxtb16	r0
	sxtb16	r15
	sxtb16	r0, ror 0
	sxtb16	r15, ror 24
	sxtb16	r0, r0
	sxtb16	r15, r15
	sxtb16	r0, r0, ror 0
	sxtb16	r15, r15, ror 24

positive: sxth instruction

	sxth	r0
	sxth	r7
	sxth	r0, r0
	sxth	r7, r7
	sxth	r0
	sxth	r15
	sxth	r0, ror 0
	sxth	r15, ror 24
	sxth	r0, r0
	sxth	r15, r15
	sxth	r0, r0, ror 0
	sxth	r15, r15, ror 24

positive: teq instruction

	teq	r0, 0
	teq	r15, 0xff000000
	teq	r0, r0, rrx
	teq	r15, r15, rrx
	teq	r0, r0
	teq	r15, r15
	teq	r0, r0, lsl 1
	teq	r15, r15, ror 31

positive: tst instruction

	tst	r0, 0
	tst	r15, 0xff000000
	tst	r0, r0
	tst	r7, r7
	tst	r0, r0, rrx
	tst	r15, r15, rrx
	tst	r0, r0
	tst	r15, r15
	tst	r0, r0, lsl 1
	tst	r15, r15, ror 31

positive: uadd16 instruction

	uadd16	r0, r0
	uadd16	r15, r15
	uadd16	r0, r0, r0
	uadd16	r15, r15, r15

positive: uadd8 instruction

	uadd8	r0, r0
	uadd8	r15, r15
	uadd8	r0, r0, r0
	uadd8	r15, r15, r15

positive: uasx instruction

	uasx	r0, r0
	uasx	r15, r15
	uasx	r0, r0, r0
	uasx	r15, r15, r15

positive: ubfx instruction

	ubfx	r0, r0, 0, 32
	ubfx	r15, r15, 31, 1

positive: udf instruction

	udf	0
	udf	255
	udf	0
	udf	65535

positive: udiv instruction

	udiv	r0, r0
	udiv	r15, r15
	udiv	r0, r0, r0
	udiv	r15, r15, r15

positive: uhadd16 instruction

	uhadd16	r0, r0
	uhadd16	r15, r15
	uhadd16	r0, r0, r0
	uhadd16	r15, r15, r15

positive: uhadd8 instruction

	uhadd8	r0, r0
	uhadd8	r15, r15
	uhadd8	r0, r0, r0
	uhadd8	r15, r15, r15

positive: uhasx instruction

	uhasx	r0, r0
	uhasx	r15, r15
	uhasx	r0, r0, r0
	uhasx	r15, r15, r15

positive: uhsax instruction

	uhsax	r0, r0
	uhsax	r15, r15
	uhsax	r0, r0, r0
	uhsax	r15, r15, r15

positive: uhsub16 instruction

	uhsub16	r0, r0
	uhsub16	r15, r15
	uhsub16	r0, r0, r0
	uhsub16	r15, r15, r15

positive: uhsub8 instruction

	uhsub8	r0, r0
	uhsub8	r15, r15
	uhsub8	r0, r0, r0
	uhsub8	r15, r15, r15

positive: umaal instruction

	umaal	r0, r0, r0, r0
	umaal	r15, r15, r15, r15

positive: umlal instruction

	umlal	r0, r0, r0, r0
	umlal	r15, r15, r15, r15

positive: umull instruction

	umull	r0, r0, r0, r0
	umull	r15, r15, r15, r15

positive: uqadd16 instruction

	uqadd16	r0, r0
	uqadd16	r15, r15
	uqadd16	r0, r0, r0
	uqadd16	r15, r15, r15

positive: uqadd8 instruction

	uqadd8	r0, r0
	uqadd8	r15, r15
	uqadd8	r0, r0, r0
	uqadd8	r15, r15, r15

positive: uqasx instruction

	uqasx	r0, r0
	uqasx	r15, r15
	uqasx	r0, r0, r0
	uqasx	r15, r15, r15

positive: uqsax instruction

	uqsax	r0, r0
	uqsax	r15, r15
	uqsax	r0, r0, r0
	uqsax	r15, r15, r15

positive: uqsub16 instruction

	uqsub16	r0, r0
	uqsub16	r15, r15
	uqsub16	r0, r0, r0
	uqsub16	r15, r15, r15

positive: uqsub8 instruction

	uqsub8	r0, r0
	uqsub8	r15, r15
	uqsub8	r0, r0, r0
	uqsub8	r15, r15, r15

positive: usad8 instruction

	usad8	r0, r0
	usad8	r15, r15
	usad8	r0, r0, r0
	usad8	r15, r15, r15

positive: usada8 instruction

	usada8	r0, r0, r0, r0
	usada8	r15, r15, r15, r15

positive: usat instruction

	usat	r0, 1, r0, asr 1
	usat	r15, 32, r15, asr 31
	usat	r0, 1, r0
	usat	r15, 32, r15
	usat	r0, 1, r0, lsl 1
	usat	r15, 32, r15, lsl 31

positive: usat16 instruction

	usat16	r0, 1, r0
	usat16	r15, 16, r15

positive: usax instruction

	usax	r0, r0
	usax	r15, r15
	usax	r0, r0, r0
	usax	r15, r15, r15

positive: usub16 instruction

	usub16	r0, r0
	usub16	r15, r15
	usub16	r0, r0, r0
	usub16	r15, r15, r15

positive: usub8 instruction

	usub8	r0, r0
	usub8	r15, r15
	usub8	r0, r0, r0
	usub8	r15, r15, r15

positive: uxtab instruction

	uxtab	r0, r0
	uxtab	r15, r15
	uxtab	r0, r0, ror 0
	uxtab	r15, r15, ror 24
	uxtab	r0, r0, r0
	uxtab	r15, r15, r15
	uxtab	r0, r0, r0, ror 0
	uxtab	r15, r15, r15, ror 24

positive: uxtab16 instruction

	uxtab16	r0, r0
	uxtab16	r15, r15
	uxtab16	r0, r0, ror 0
	uxtab16	r15, r15, ror 24
	uxtab16	r0, r0, r0
	uxtab16	r15, r15, r15
	uxtab16	r0, r0, r0, ror 0
	uxtab16	r15, r15, r15, ror 24

positive: uxtah instruction

	uxtah	r0, r0
	uxtah	r15, r15
	uxtah	r0, r0, ror 0
	uxtah	r15, r15, ror 24
	uxtah	r0, r0, r0
	uxtah	r15, r15, r15
	uxtah	r0, r0, r0, ror 0
	uxtah	r15, r15, r15, ror 24

positive: uxtb instruction

	uxtb	r0
	uxtb	r7
	uxtb	r0, r0
	uxtb	r7, r7
	uxtb	r0
	uxtb	r15
	uxtb	r0, ror 0
	uxtb	r15, ror 24
	uxtb	r0, r0
	uxtb	r15, r15
	uxtb	r0, r0, ror 0
	uxtb	r15, r15, ror 24

positive: uxtb16 instruction

	uxtb16	r0
	uxtb16	r15
	uxtb16	r0, ror 0
	uxtb16	r15, ror 24
	uxtb16	r0, r0
	uxtb16	r15, r15
	uxtb16	r0, r0, ror 0
	uxtb16	r15, r15, ror 24

positive: uxth instruction

	uxth	r0
	uxth	r7
	uxth	r0, r0
	uxth	r7, r7
	uxth	r0
	uxth	r15
	uxth	r0, ror 0
	uxth	r15, ror 24
	uxth	r0, r0
	uxth	r15, r15
	uxth	r0, r0, ror 0
	uxth	r15, r15, ror 24

positive: wfe instruction

	wfe
	wfe.n
	wfe.w

positive: wfi instruction

	wfi
	wfi.n
	wfi.w

positive: yield instruction

	yield
	yield.n
	yield.w

# advanced SIMD and Floating-point instructions

positive: aesd instruction

	aesd.8	q0, q0
	aesd.8	q15, q15

positive: aese instruction

	aese.8	q0, q0
	aese.8	q15, q15

positive: aesimc instruction

	aesimc.8	q0, q0
	aesimc.8	q15, q15

positive: aesmc instruction

	aesmc.8	q0, q0
	aesmc.8	q15, q15

positive: fldmdbx instruction

	fldmdbx	r0!, {d0}
	fldmdbx	r15!, {d15}

positive: fldmiax instruction

	fldmiax	r0, {d0}
	fldmiax	r15!, {d15}

positive: fstmdbx instruction

	fstmdbx	r0!, {d0}
	fstmdbx	r15!, {d15}

positive: fstmiax instruction

	fstmiax	r0, {d0}
	fstmiax	r15!, {d15}

positive: sha1c instruction

	sha1c.32	q0, q0, q0
	sha1c.32	q15, q15, q15

positive: sha1h instruction

	sha1h.32	q0, q0
	sha1h.32	q15, q15

positive: sha1m instruction

	sha1m.32	q0, q0, q0
	sha1m.32	q15, q15, q15

positive: sha1p instruction

	sha1p.32	q0, q0, q0
	sha1p.32	q15, q15, q15

positive: sha1su0 instruction

	sha1su0.32	q0, q0, q0
	sha1su0.32	q15, q15, q15

positive: sha1su1 instruction

	sha1su1.32	q0, q1
	sha1su1.32	q15, q15

positive: sha256h instruction

	sha256h.32	q0, q0, q0
	sha256h.32	q15, q15, q15

positive: sha256h2 instruction

	sha256h2.32	q0, q0, q0
	sha256h2.32	q15, q15, q15

positive: sha256su0 instruction

	sha256su0.32	q0, q0
	sha256su0.32	q15, q15

positive: sha256su1 instruction

	sha256su1.32	q0, q0, q0
	sha256su1.32	q15, q15, q15

positive: vaba instruction

	vaba.s8	d0, d0, d0
	vaba.s8	d31, d31, d31
	vaba.s16	d0, d0, d0
	vaba.s16	d31, d31, d31
	vaba.s32	d0, d0, d0
	vaba.s32	d31, d31, d31
	vaba.u8	d0, d0, d0
	vaba.u8	d31, d31, d31
	vaba.u16	d0, d0, d0
	vaba.u16	d31, d31, d31
	vaba.u32	d0, d0, d0
	vaba.u32	d31, d31, d31
	vaba.s8	q0, q0, q0
	vaba.s8	q15, q15, q15
	vaba.s16	q0, q0, q0
	vaba.s16	q15, q15, q15
	vaba.s32	q0, q0, q0
	vaba.s32	q15, q15, q15
	vaba.u8	q0, q0, q0
	vaba.u8	q15, q15, q15
	vaba.u16	q0, q0, q0
	vaba.u16	q15, q15, q15
	vaba.u32	q0, q0, q0
	vaba.u32	q15, q15, q15

positive: vabal instruction

	vabal.u8	q0, d0, d0
	vabal.u8	q15, d31, d31
	vabal.u16	q0, d0, d0
	vabal.u16	q15, d31, d31
	vabal.u32	q0, d0, d0
	vabal.u32	q15, d31, d31

positive: vabd instruction

	vabd.f16	d0, d0
	vabd.f16	d31, d31
	vabd.f16	d0, d0, d0
	vabd.f16	d31, d31, d31
	vabd.f32	d0, d0
	vabd.f32	d31, d31
	vabd.f32	d0, d0, d0
	vabd.f32	d31, d31, d31
	vabd.f16	q0, q0
	vabd.f16	q15, q15
	vabd.f16	q0, q0, q0
	vabd.f16	q15, q15, q15
	vabd.f32	q0, q0
	vabd.f32	q15, q15
	vabd.f32	q0, q0, q0
	vabd.f32	q15, q15, q15
	vabd.s8	d0, d0
	vabd.s8	d31, d31
	vabd.s8	d0, d0, d0
	vabd.s8	d31, d31, d31
	vabd.s16	d0, d0
	vabd.s16	d31, d31
	vabd.s16	d0, d0, d0
	vabd.s16	d31, d31, d31
	vabd.s32	d0, d0
	vabd.s32	d31, d31
	vabd.s32	d0, d0, d0
	vabd.s32	d31, d31, d31
	vabd.u8	d0, d0
	vabd.u8	d31, d31
	vabd.u8	d0, d0, d0
	vabd.u8	d31, d31, d31
	vabd.u16	d0, d0
	vabd.u16	d31, d31
	vabd.u16	d0, d0, d0
	vabd.u16	d31, d31, d31
	vabd.u32	d0, d0
	vabd.u32	d31, d31
	vabd.u32	d0, d0, d0
	vabd.u32	d31, d31, d31
	vabd.s8	q0, q0
	vabd.s8	q15, q15
	vabd.s8	q0, q0, q0
	vabd.s8	q15, q15, q15
	vabd.s16	q0, q0
	vabd.s16	q15, q15
	vabd.s16	q0, q0, q0
	vabd.s16	q15, q15, q15
	vabd.s32	q0, q0
	vabd.s32	q15, q15
	vabd.s32	q0, q0, q0
	vabd.s32	q15, q15, q15
	vabd.u8	q0, q0
	vabd.u8	q15, q15
	vabd.u8	q0, q0, q0
	vabd.u8	q15, q15, q15
	vabd.u16	q0, q0
	vabd.u16	q15, q15
	vabd.u16	q0, q0, q0
	vabd.u16	q15, q15, q15
	vabd.u32	q0, q0
	vabd.u32	q15, q15
	vabd.u32	q0, q0, q0
	vabd.u32	q15, q15, q15

positive: vabdl instruction

	vabdl.u8	q0, d0, d0
	vabdl.u8	q15, d31, d31
	vabdl.u16	q0, d0, d0
	vabdl.u16	q15, d31, d31
	vabdl.u32	q0, d0, d0
	vabdl.u32	q15, d31, d31

positive: vabs instruction

	vabs.s8	d0, d0
	vabs.s8	d31, d31
	vabs.s16	d0, d0
	vabs.s16	d31, d31
	vabs.s32	d0, d0
	vabs.s32	d31, d31
	vabs.f16	d0, d0
	vabs.f16	d31, d31
	vabs.f32	d0, d0
	vabs.f32	d31, d31
	vabs.s8	q0, q0
	vabs.s8	q15, q15
	vabs.s16	q0, q0
	vabs.s16	q15, q15
	vabs.s32	q0, q0
	vabs.s32	q15, q15
	vabs.f16	q0, q0
	vabs.f16	q15, q15
	vabs.f32	q0, q0
	vabs.f32	q15, q15
	vabs.f16	s0, s0
	vabs.f16	s31, s31
	vabs.f32	s0, s0
	vabs.f32	s31, s31
	vabs.f64	d0, d0
	vabs.f64	d31, d31

positive: vacge instruction

	vacge.f16	d0, d0
	vacge.f16	d31, d31
	vacge.f16	d0, d0, d0
	vacge.f16	d31, d31, d31
	vacge.f32	d0, d0
	vacge.f32	d31, d31
	vacge.f32	d0, d0, d0
	vacge.f32	d31, d31, d31
	vacge.f16	q0, q0
	vacge.f16	q15, q15
	vacge.f16	q0, q0, q0
	vacge.f16	q15, q15, q15
	vacge.f32	q0, q0
	vacge.f32	q15, q15
	vacge.f32	q0, q0, q0
	vacge.f32	q15, q15, q15

positive: vacle instruction

	vacle.f16	d0, d0
	vacle.f16	d31, d31
	vacle.f16	d0, d0, d0
	vacle.f16	d31, d31, d31
	vacle.f32	d0, d0
	vacle.f32	d31, d31
	vacle.f32	d0, d0, d0
	vacle.f32	d31, d31, d31
	vacle.f16	q0, q0
	vacle.f16	q15, q15
	vacle.f16	q0, q0, q0
	vacle.f16	q15, q15, q15
	vacle.f32	q0, q0
	vacle.f32	q15, q15
	vacle.f32	q0, q0, q0
	vacle.f32	q15, q15, q15

positive: vacgt instruction

	vacgt.f16	d0, d0
	vacgt.f16	d31, d31
	vacgt.f16	d0, d0, d0
	vacgt.f16	d31, d31, d31
	vacgt.f32	d0, d0
	vacgt.f32	d31, d31
	vacgt.f32	d0, d0, d0
	vacgt.f32	d31, d31, d31
	vacgt.f16	q0, q0
	vacgt.f16	q15, q15
	vacgt.f16	q0, q0, q0
	vacgt.f16	q15, q15, q15
	vacgt.f32	q0, q0
	vacgt.f32	q15, q15
	vacgt.f32	q0, q0, q0
	vacgt.f32	q15, q15, q15

positive: vaclt instruction

	vaclt.f16	d0, d0
	vaclt.f16	d31, d31
	vaclt.f16	d0, d0, d0
	vaclt.f16	d31, d31, d31
	vaclt.f32	d0, d0
	vaclt.f32	d31, d31
	vaclt.f32	d0, d0, d0
	vaclt.f32	d31, d31, d31
	vaclt.f16	q0, q0
	vaclt.f16	q15, q15
	vaclt.f16	q0, q0, q0
	vaclt.f16	q15, q15, q15
	vaclt.f32	q0, q0
	vaclt.f32	q15, q15
	vaclt.f32	q0, q0, q0
	vaclt.f32	q15, q15, q15

positive: vadd instruction

	vadd.f16	d0, d0
	vadd.f16	d31, d31
	vadd.f16	d0, d0, d0
	vadd.f16	d31, d31, d31
	vadd.f32	d0, d0
	vadd.f32	d31, d31
	vadd.f32	d0, d0, d0
	vadd.f32	d31, d31, d31
	vadd.f16	q0, q0
	vadd.f16	q15, q15
	vadd.f16	q0, q0, q0
	vadd.f16	q15, q15, q15
	vadd.f32	q0, q0
	vadd.f32	q15, q15
	vadd.f32	q0, q0, q0
	vadd.f32	q15, q15, q15
	vadd.f16	s0, s0
	vadd.f16	s31, s31
	vadd.f16	s0, s0, s0
	vadd.f16	s31, s31, s31
	vadd.f32	s0, s0
	vadd.f32	s31, s31
	vadd.f32	s0, s0, s0
	vadd.f32	s31, s31, s31
	vadd.f64	d0, d0
	vadd.f64	d31, d31
	vadd.f64	d0, d0, d0
	vadd.f64	d31, d31, d31
	vadd.i8	d0, d0
	vadd.i8	d31, d31
	vadd.i8	d0, d0, d0
	vadd.i8	d31, d31, d31
	vadd.i16	d0, d0
	vadd.i16	d31, d31
	vadd.i16	d0, d0, d0
	vadd.i16	d31, d31, d31
	vadd.i32	d0, d0
	vadd.i32	d31, d31
	vadd.i32	d0, d0, d0
	vadd.i32	d31, d31, d31
	vadd.i64	d0, d0
	vadd.i64	d31, d31
	vadd.i64	d0, d0, d0
	vadd.i64	d31, d31, d31
	vadd.i8	q0, q0
	vadd.i8	q15, q15
	vadd.i8	q0, q0, q0
	vadd.i8	q15, q15, q15
	vadd.i16	q0, q0
	vadd.i16	q15, q15
	vadd.i16	q0, q0, q0
	vadd.i16	q15, q15, q15
	vadd.i32	q0, q0
	vadd.i32	q15, q15
	vadd.i32	q0, q0, q0
	vadd.i32	q15, q15, q15
	vadd.i64	q0, q0
	vadd.i64	q15, q15
	vadd.i64	q0, q0, q0
	vadd.i64	q15, q15, q15

positive: vaddhn instruction

	vaddhn.i16	d0, q0, q0
	vaddhn.i16	d31, q15, q15
	vaddhn.i32	d0, q0, q0
	vaddhn.i32	d31, q15, q15
	vaddhn.i64	d0, q0, q0
	vaddhn.i64	d31, q15, q15

positive: vaddl instruction

	vaddl.s8	q0, d0, d0
	vaddl.s8	q15, d31, d31
	vaddl.s16	q0, d0, d0
	vaddl.s16	q15, d31, d31
	vaddl.s32	q0, d0, d0
	vaddl.s32	q15, d31, d31
	vaddl.u8	q0, d0, d0
	vaddl.u8	q15, d31, d31
	vaddl.u16	q0, d0, d0
	vaddl.u16	q15, d31, d31
	vaddl.u32	q0, d0, d0
	vaddl.u32	q15, d31, d31

positive: vaddw instruction

	vaddw.s8	q0, d0
	vaddw.s8	q15, d31
	vaddw.s8	q0, q0, d0
	vaddw.s8	q15, q15, d31
	vaddw.s16	q0, d0
	vaddw.s16	q15, d31
	vaddw.s16	q0, q0, d0
	vaddw.s16	q15, q15, d31
	vaddw.s32	q0, d0
	vaddw.s32	q15, d31
	vaddw.s32	q0, q0, d0
	vaddw.s32	q15, q15, d31
	vaddw.u8	q0, d0
	vaddw.u8	q15, d31
	vaddw.u8	q0, q0, d0
	vaddw.u8	q15, q15, d31
	vaddw.u16	q0, d0
	vaddw.u16	q15, d31
	vaddw.u16	q0, q0, d0
	vaddw.u16	q15, q15, d31
	vaddw.u32	q0, d0
	vaddw.u32	q15, d31
	vaddw.u32	q0, q0, d0
	vaddw.u32	q15, q15, d31

positive: vcmp instruction

	vcmp.f16	s0, s0
	vcmp.f16	s31, s31
	vcmp.f32	s0, s0
	vcmp.f32	s31, s31
	vcmp.f64	d0, d0
	vcmp.f64	d31, d31
	vcmp.f16	s0, 0
	vcmp.f16	s31, 0
	vcmp.f32	s0, 0
	vcmp.f32	s31, 0
	vcmp.f64	d0, 0
	vcmp.f64	d31, 0

positive: vcvt instruction

	vcvt.f64.f32	d0, s0
	vcvt.f64.f32	d31, s31
	vcvt.f32.f64	s0, d0
	vcvt.f32.f64	s31, d31
	vcvt.f16.f32	d0, q0
	vcvt.f16.f32	d31, q15
	vcvt.f32.f16	q0, d0
	vcvt.f32.f16	q15, d31
	vcvt.f16.s16	d0, d0
	vcvt.f16.s16	d31, d31
	vcvt.f16.u16	d0, d0
	vcvt.f16.u16	d31, d31
	vcvt.s16.f16	d0, d0
	vcvt.s16.f16	d31, d31
	vcvt.u16.f16	d0, d0
	vcvt.u16.f16	d31, d31
	vcvt.f32.s32	d0, d0
	vcvt.f32.s32	d31, d31
	vcvt.f32.u32	d0, d0
	vcvt.f32.u32	d31, d31
	vcvt.s32.f32	d0, d0
	vcvt.s32.f32	d31, d31
	vcvt.u32.f32	d0, d0
	vcvt.u32.f32	d31, d31
	vcvt.f16.s16	q0, q0
	vcvt.f16.s16	q15, q15
	vcvt.f16.u16	q0, q0
	vcvt.f16.u16	q15, q15
	vcvt.s16.f16	q0, q0
	vcvt.s16.f16	q15, q15
	vcvt.u16.f16	q0, q0
	vcvt.u16.f16	q15, q15
	vcvt.f32.s32	q0, q0
	vcvt.f32.s32	q15, q15
	vcvt.f32.u32	q0, q0
	vcvt.f32.u32	q15, q15
	vcvt.s32.f32	q0, q0
	vcvt.s32.f32	q15, q15
	vcvt.u32.f32	q0, q0
	vcvt.u32.f32	q15, q15
	vcvt.u32.f16	s0, s0
	vcvt.u32.f16	s31, s31
	vcvt.s32.f16	s0, s0
	vcvt.s32.f16	s31, s31
	vcvt.u32.f32	s0, s0
	vcvt.u32.f32	s31, s31
	vcvt.s32.f32	s0, s0
	vcvt.s32.f32	s31, s31
	vcvt.u32.f64	s0, d0
	vcvt.u32.f64	s31, d31
	vcvt.s32.f64	s0, d0
	vcvt.s32.f64	s31, d31
	vcvt.f16.u32	s0, s0
	vcvt.f16.u32	s31, s31
	vcvt.f16.s32	s0, s0
	vcvt.f16.s32	s31, s31
	vcvt.f32.u32	s0, s0
	vcvt.f32.u32	s31, s31
	vcvt.f32.s32	s0, s0
	vcvt.f32.s32	s31, s31
	vcvt.f64.u32	d0, s0
	vcvt.f64.u32	d31, s31
	vcvt.f64.s32	d0, s0
	vcvt.f64.s32	d31, s31

positive: vdiv instruction

	vdiv.f16	s0, s0
	vdiv.f16	s31, s31
	vdiv.f16	s0, s0, s0
	vdiv.f16	s31, s31, s31
	vdiv.f32	s0, s0
	vdiv.f32	s31, s31
	vdiv.f32	s0, s0, s0
	vdiv.f32	s31, s31, s31
	vdiv.f64	d0, d0
	vdiv.f64	d31, d31
	vdiv.f64	d0, d0, d0
	vdiv.f64	d31, d31, d31

positive: vldm instruction

	vldm	r0, {d0}
	vldm	r15!, {d15}
	vldm.64	r0, {d0}
	vldm.64	r15!, {d15}
	vldm	r0, {s0}
	vldm	r15!, {s15}
	vldm.32	r0, {s0}
	vldm.32	r15!, {s15}

positive: vldmdb instruction

	vldmdb	r0!, {d0}
	vldmdb	r15!, {d15}
	vldmdb.64	r0!, {d0}
	vldmdb.64	r15!, {d15}
	vldmdb	r0!, {s0}
	vldmdb	r15!, {s15}
	vldmdb.32	r0!, {s0}
	vldmdb.32	r15!, {s15}

positive: vldmia instruction

	vldmia	r0, {d0}
	vldmia	r15!, {d15}
	vldmia.64	r0, {d0}
	vldmia.64	r15!, {d15}
	vldmia	r0, {s0}
	vldmia	r15!, {s15}
	vldmia.32	r0, {s0}
	vldmia.32	r15!, {s15}

positive: vldr instruction

	vldr.16	s0, [r0, -510]
	vldr.16	s31, [r15, +510]
	vldr	s0, [r0, -1020]
	vldr	s31, [r15, +1020]
	vldr.32	s0, [r0, -1020]
	vldr.32	s31, [r15, +1020]
	vldr	d0, [r0, -1020]
	vldr	d31, [r15, +1020]
	vldr.64	d0, [r0, -1020]
	vldr.64	d31, [r15, +1020]
	vldr.16	s0, -510
	vldr.16	s31, +510
	vldr	s0, -1020
	vldr	s31, +1020
	vldr.32	s0, -1020
	vldr.32	s31, +1020
	vldr	d0, -1020
	vldr	d31, +1020
	vldr.64	d0, -1020
	vldr.64	d31, +1020

positive: vmov instruction

	vmov.f32	s0, s0
	vmov.f32	s31, s31
	vmov.f64	d0, d0
	vmov.f64	d31, d31
	vmov	s0, r0
	vmov	s31, r15
	vmov	r0, s0
	vmov	r15, s31

positive: vmul instruction

	vmul.f16	d0, d0
	vmul.f16	d31, d31
	vmul.f16	d0, d0, d0
	vmul.f16	d31, d31, d31
	vmul.f32	d0, d0
	vmul.f32	d31, d31
	vmul.f32	d0, d0, d0
	vmul.f32	d31, d31, d31
	vmul.f16	q0, q0
	vmul.f16	q15, q15
	vmul.f16	q0, q0, q0
	vmul.f16	q15, q15, q15
	vmul.f32	q0, q0
	vmul.f32	q15, q15
	vmul.f32	q0, q0, q0
	vmul.f32	q15, q15, q15
	vmul.f16	s0, s0
	vmul.f16	s31, s31
	vmul.f16	s0, s0, s0
	vmul.f16	s31, s31, s31
	vmul.f32	s0, s0
	vmul.f32	s31, s31
	vmul.f32	s0, s0, s0
	vmul.f32	s31, s31, s31
	vmul.f64	d0, d0
	vmul.f64	d31, d31
	vmul.f64	d0, d0, d0
	vmul.f64	d31, d31, d31

positive: vneg instruction

	vneg.s8	d0, d0
	vneg.s8	d31, d31
	vneg.s16	d0, d0
	vneg.s16	d31, d31
	vneg.s32	d0, d0
	vneg.s32	d31, d31
	vneg.f16	d0, d0
	vneg.f16	d31, d31
	vneg.f32	d0, d0
	vneg.f32	d31, d31
	vneg.s8	q0, q0
	vneg.s8	q15, q15
	vneg.s16	q0, q0
	vneg.s16	q15, q15
	vneg.s32	q0, q0
	vneg.s32	q15, q15
	vneg.f16	q0, q0
	vneg.f16	q15, q15
	vneg.f32	q0, q0
	vneg.f32	q15, q15
	vneg.f16	s0, s0
	vneg.f16	s15, s15
	vneg.f32	s0, s0
	vneg.f32	s15, s15
	vneg.f64	d0, d0
	vneg.f64	d15, d15

positive: vpop instruction

	vpop	{d0}
	vpop	{d31}
	vpop.64	{d0}
	vpop.64	{d31}
	vpop	{s0}
	vpop	{s31}
	vpop.32	{s0}
	vpop.32	{s31}

positive: vpush instruction

	vpush	{d0}
	vpush	{d31}
	vpush.64	{d0}
	vpush.64	{d31}
	vpush	{s0}
	vpush	{s31}
	vpush.32	{s0}
	vpush.32	{s31}

positive: vsub instruction

	vsub.f16	d0, d0
	vsub.f16	d31, d31
	vsub.f16	d0, d0, d0
	vsub.f16	d31, d31, d31
	vsub.f32	d0, d0
	vsub.f32	d31, d31
	vsub.f32	d0, d0, d0
	vsub.f32	d31, d31, d31
	vsub.f16	q0, q0
	vsub.f16	q15, q15
	vsub.f16	q0, q0, q0
	vsub.f16	q15, q15, q15
	vsub.f32	q0, q0
	vsub.f32	q15, q15
	vsub.f32	q0, q0, q0
	vsub.f32	q15, q15, q15
	vsub.f16	s0, s0
	vsub.f16	s31, s31
	vsub.f16	s0, s0, s0
	vsub.f16	s31, s31, s31
	vsub.f32	s0, s0
	vsub.f32	s31, s31
	vsub.f32	s0, s0, s0
	vsub.f32	s31, s31, s31
	vsub.f64	d0, d0
	vsub.f64	d31, d31
	vsub.f64	d0, d0, d0
	vsub.f64	d31, d31, d31
	vsub.i8	d0, d0
	vsub.i8	d31, d31
	vsub.i8	d0, d0, d0
	vsub.i8	d31, d31, d31
	vsub.i16	d0, d0
	vsub.i16	d31, d31
	vsub.i16	d0, d0, d0
	vsub.i16	d31, d31, d31
	vsub.i32	d0, d0
	vsub.i32	d31, d31
	vsub.i32	d0, d0, d0
	vsub.i32	d31, d31, d31
	vsub.i64	d0, d0
	vsub.i64	d31, d31
	vsub.i64	d0, d0, d0
	vsub.i64	d31, d31, d31
	vsub.i8	q0, q0
	vsub.i8	q15, q15
	vsub.i8	q0, q0, q0
	vsub.i8	q15, q15, q15
	vsub.i16	q0, q0
	vsub.i16	q15, q15
	vsub.i16	q0, q0, q0
	vsub.i16	q15, q15, q15
	vsub.i32	q0, q0
	vsub.i32	q15, q15
	vsub.i32	q0, q0, q0
	vsub.i32	q15, q15, q15
	vsub.i64	q0, q0
	vsub.i64	q15, q15
	vsub.i64	q0, q0, q0
	vsub.i64	q15, q15, q15

positive: vstm instruction

	vstm	r0, {d0}
	vstm	r15!, {d31}
	vstm.64	r0, {d0}
	vstm.64	r15!, {d31}
	vstm	r0, {s0}
	vstm	r15!, {s31}
	vstm.32	r0, {s0}
	vstm.32	r15!, {s31}

positive: vstmdb instruction

	vstmdb	r0!, {d0}
	vstmdb	r15!, {d31}
	vstmdb.64	r0!, {d0}
	vstmdb.64	r15!, {d31}
	vstmdb	r0!, {s0}
	vstmdb	r15!, {s31}
	vstmdb.32	r0!, {s0}
	vstmdb.32	r15!, {s31}

positive: vstmia instruction

	vstmia	r0, {d0}
	vstmia	r15!, {d31}
	vstmia.64	r0, {d0}
	vstmia.64	r15!, {d31}
	vstmia	r0, {s0}
	vstmia	r15!, {s31}
	vstmia.32	r0, {s0}
	vstmia.32	r15!, {s31}

positive: vstr instruction

	vstr.16	s0, [r0, -510]
	vstr.16	s31, [r15, +510]
	vstr	s0, [r0, -1020]
	vstr	s31, [r15, +1020]
	vstr.32	s0, [r0, -1020]
	vstr.32	s31, [r15, +1020]
	vstr	d0, [r0, -1020]
	vstr	d31, [r15, +1020]
	vstr.64	d0, [r0, -1020]
	vstr.64	d31, [r15, +1020]

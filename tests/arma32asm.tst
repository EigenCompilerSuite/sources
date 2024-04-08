# ARM A32 assembler test and validation suite
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

negative: bit mode

	.bitmode	16

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

# ARM A32 assembler

# operand types

positive: 3-bit immediate

	cdp	p0, 1, c2, c3, c4, 0
	cdp	p0, 1, c2, c3, c4, 7

negative: too small 3-bit immediate

	cdp	p0, 1, c2, c3, c4, -1

negative: too large 3-bit immediate

	cdp	p0, 1, c2, c3, c4, 8

positive: 4-bit immediate

	cdp	p0, 0, c2, c3, c4, 5
	cdp	p0, 15, c2, c3, c4, 5

negative: too small 4-bit immediate

	cdp	p0, -1, c2, c3, c4, 5

negative: too large 4-bit immediate

	cdp	p0, 16, c2, c3, c4, 5

positive: 5-bit immediate logical left shift

	adc	r0, r1, r2, lsl 0
	adc	r0, r1, r2, lsl 31

negative: too small 5-bit logical immediate left shift

	adc	r0, r1, r2, lsl -1

negative: too large 5-bit logical immediate left shift

	adc	r0, r1, r2, lsl 32

positive: 5-bit immediate logical right shift

	adc	r0, r1, r2, lsr 1
	adc	r0, r1, r2, lsr 32

negative: too small 5-bit logical immediate right shift

	adc	r0, r1, r2, lsr 0

negative: too large 5-bit logical immediate right shift

	adc	r0, r1, r2, lsr 33

positive: 5-bit immediate arithmetic right shift

	adc	r0, r1, r2, asr 1
	adc	r0, r1, r2, asr 32

negative: too small 5-bit logical arithmetic right shift

	adc	r0, r1, r2, asr 0

negative: too large 5-bit logical arithmetic right shift

	adc	r0, r1, r2, asr 33

positive: 5-bit immediate right rotate

	adc	r0, r1, r2, ror 1
	adc	r0, r1, r2, ror 31

negative: too small 5-bit right rotate

	adc	r0, r1, r2, ror 0

negative: too large 5-bit right rotate

	adc	r0, r1, r2, ror 32

positive: rotated 8-bit immediate

	adc	r0, r1, 0
	adc	r0, r1, 0xff
	adc	r0, r1, 0x3fc
	adc	r0, r1, 0xff00
	adc	r0, r1, 0x3fc0
	adc	r0, r1, 0xff000
	adc	r0, r1, 0x3fc00
	adc	r0, r1, 0xff0000
	adc	r0, r1, 0x3fc000
	adc	r0, r1, 0xff00000
	adc	r0, r1, 0x3fc0000
	adc	r0, r1, 0xff00000
	adc	r0, r1, 0x3fc00000
	adc	r0, r1, 0xff000000

negative: too small rotated 8-bit immediate

	adc	r0, r1, -1

negative: too large rotated 8-bit immediate

	adc	r0, r1, 0xff000001

negative: invalid rotated 8-bit immediate

	adc	r0, r1, 0x101

positive: 16-bit displaced immediate

	bkpt	0
	bkpt	65535

negative: too small 16-bit displaced immediate

	bkpt	-1

negative: too large 16-bit displaced immediate

	bkpt	65536

positive: 24-bit immediate

	swi	0
	swi	16777215

negative: too small 24-bit immediate

	swi	-1

negative: too large 24-bit immediate

	swi	16777216

positive: 8-bit immediate offset

	ldrh	r0, [r1, -255]
	ldrh	r15, [r15, +255]

negative: too small 8-bit immediate offset

	ldrh	r0, [r1, -256]

negative: too large 8-bit immediate offset

	ldrh	r0, [r1, +256]

positive: 8-bit multiple of four immediate offset

	ldc	p0, c1, [r2, -1020]
	ldc	p0, c1, [r2, +1020]

negative: too small 8-bit multiple of four immediate offset

	ldc	p0, c1, [r2, -1024]

negative: too large 8-bit multiple of four immediate offset

	ldc	p0, c1, [r2, +1024]

negative: invalid 8-bit multiple of four immediate offset

	ldc	p0, c1, [r2, +1]

positive: 12-bit immediate offset

	ldr	r0, [r1, -4095]
	ldr	r0, [r1, +4095]

negative: too small 12-bit immediate offset

	ldr	r0, [r1, -4096]

negative: too large 12-bit immediate offset

	ldr	r0, [r1, +4096]

positive: 24-bit multiple of four offset

	b	-33554432
	b	+33554428

negative: too small 24-bit multiple of four offset

	b	-33554436

negative: too large 24-bit multiple of four offset

	b	+33554432

negative: invalid 24-bit multiple of four offset

	b	+1

positive: 8-bit coprocessor option

	ldc	p0, c1, [r2], {0}
	ldc	p0, c1, [r2], {255}

negative: too small 8-bit coprocessor option

	ldc	p0, c1, [r2], {-1}

negative: too large 8-bit coprocessor option

	ldc	p0, c1, [r2], {256}

negative: invalid 8-bit coprocessor option

	ldc	p0, c1, [r2], {}

# instruction set

positive: adc instruction

	adc	r0, r0, 0
	adc	r15, r15, 0xff000000
	adc	r0, r0, r0
	adc	r15, r15, r15
	adc	r0, r0, r0, lsl 0
	adc	r15, r15, r15, lsl 31
	adc	r0, r0, r0, lsl r0
	adc	r15, r15, r15, lsl r15
	adc	r0, r0, r0, lsr 1
	adc	r15, r15, r15, lsr 32
	adc	r0, r0, r0, lsr r0
	adc	r15, r15, r15, asr r15
	adc	r0, r0, r0, asr 1
	adc	r15, r15, r15, asr 32
	adc	r0, r0, r0, asr r0
	adc	r15, r15, r15, asr r15
	adc	r0, r0, r0, ror 1
	adc	r15, r15, r15, ror 31
	adc	r0, r0, r0, ror r0
	adc	r15, r15, r15, ror r15
	adc	r0, r0, r0, rrx

positive: adceq instruction

	adceq	r0, r0, 0
	adceq	r15, r15, 0xff000000
	adceq	r0, r0, r0
	adceq	r15, r15, r15
	adceq	r0, r0, r0, lsl 0
	adceq	r15, r15, r15, lsl 31
	adceq	r0, r0, r0, lsl r0
	adceq	r15, r15, r15, lsl r15
	adceq	r0, r0, r0, lsr 1
	adceq	r15, r15, r15, lsr 32
	adceq	r0, r0, r0, lsr r0
	adceq	r15, r15, r15, asr r15
	adceq	r0, r0, r0, asr 1
	adceq	r15, r15, r15, asr 32
	adceq	r0, r0, r0, asr r0
	adceq	r15, r15, r15, asr r15
	adceq	r0, r0, r0, ror 1
	adceq	r15, r15, r15, ror 31
	adceq	r0, r0, r0, ror r0
	adceq	r15, r15, r15, ror r15
	adceq	r0, r0, r0, rrx

positive: adcne instruction

	adcne	r0, r0, 0
	adcne	r15, r15, 0xff000000
	adcne	r0, r0, r0
	adcne	r15, r15, r15
	adcne	r0, r0, r0, lsl 0
	adcne	r15, r15, r15, lsl 31
	adcne	r0, r0, r0, lsl r0
	adcne	r15, r15, r15, lsl r15
	adcne	r0, r0, r0, lsr 1
	adcne	r15, r15, r15, lsr 32
	adcne	r0, r0, r0, lsr r0
	adcne	r15, r15, r15, asr r15
	adcne	r0, r0, r0, asr 1
	adcne	r15, r15, r15, asr 32
	adcne	r0, r0, r0, asr r0
	adcne	r15, r15, r15, asr r15
	adcne	r0, r0, r0, ror 1
	adcne	r15, r15, r15, ror 31
	adcne	r0, r0, r0, ror r0
	adcne	r15, r15, r15, ror r15
	adcne	r0, r0, r0, rrx

positive: adccs instruction

	adccs	r0, r0, 0
	adccs	r15, r15, 0xff000000
	adccs	r0, r0, r0
	adccs	r15, r15, r15
	adccs	r0, r0, r0, lsl 0
	adccs	r15, r15, r15, lsl 31
	adccs	r0, r0, r0, lsl r0
	adccs	r15, r15, r15, lsl r15
	adccs	r0, r0, r0, lsr 1
	adccs	r15, r15, r15, lsr 32
	adccs	r0, r0, r0, lsr r0
	adccs	r15, r15, r15, asr r15
	adccs	r0, r0, r0, asr 1
	adccs	r15, r15, r15, asr 32
	adccs	r0, r0, r0, asr r0
	adccs	r15, r15, r15, asr r15
	adccs	r0, r0, r0, ror 1
	adccs	r15, r15, r15, ror 31
	adccs	r0, r0, r0, ror r0
	adccs	r15, r15, r15, ror r15
	adccs	r0, r0, r0, rrx

positive: adchs instruction

	adchs	r0, r0, 0
	adchs	r15, r15, 0xff000000
	adchs	r0, r0, r0
	adchs	r15, r15, r15
	adchs	r0, r0, r0, lsl 0
	adchs	r15, r15, r15, lsl 31
	adchs	r0, r0, r0, lsl r0
	adchs	r15, r15, r15, lsl r15
	adchs	r0, r0, r0, lsr 1
	adchs	r15, r15, r15, lsr 32
	adchs	r0, r0, r0, lsr r0
	adchs	r15, r15, r15, asr r15
	adchs	r0, r0, r0, asr 1
	adchs	r15, r15, r15, asr 32
	adchs	r0, r0, r0, asr r0
	adchs	r15, r15, r15, asr r15
	adchs	r0, r0, r0, ror 1
	adchs	r15, r15, r15, ror 31
	adchs	r0, r0, r0, ror r0
	adchs	r15, r15, r15, ror r15
	adchs	r0, r0, r0, rrx

positive: adccc instruction

	adccc	r0, r0, 0
	adccc	r15, r15, 0xff000000
	adccc	r0, r0, r0
	adccc	r15, r15, r15
	adccc	r0, r0, r0, lsl 0
	adccc	r15, r15, r15, lsl 31
	adccc	r0, r0, r0, lsl r0
	adccc	r15, r15, r15, lsl r15
	adccc	r0, r0, r0, lsr 1
	adccc	r15, r15, r15, lsr 32
	adccc	r0, r0, r0, lsr r0
	adccc	r15, r15, r15, asr r15
	adccc	r0, r0, r0, asr 1
	adccc	r15, r15, r15, asr 32
	adccc	r0, r0, r0, asr r0
	adccc	r15, r15, r15, asr r15
	adccc	r0, r0, r0, ror 1
	adccc	r15, r15, r15, ror 31
	adccc	r0, r0, r0, ror r0
	adccc	r15, r15, r15, ror r15
	adccc	r0, r0, r0, rrx

positive: adclo instruction

	adclo	r0, r0, 0
	adclo	r15, r15, 0xff000000
	adclo	r0, r0, r0
	adclo	r15, r15, r15
	adclo	r0, r0, r0, lsl 0
	adclo	r15, r15, r15, lsl 31
	adclo	r0, r0, r0, lsl r0
	adclo	r15, r15, r15, lsl r15
	adclo	r0, r0, r0, lsr 1
	adclo	r15, r15, r15, lsr 32
	adclo	r0, r0, r0, lsr r0
	adclo	r15, r15, r15, asr r15
	adclo	r0, r0, r0, asr 1
	adclo	r15, r15, r15, asr 32
	adclo	r0, r0, r0, asr r0
	adclo	r15, r15, r15, asr r15
	adclo	r0, r0, r0, ror 1
	adclo	r15, r15, r15, ror 31
	adclo	r0, r0, r0, ror r0
	adclo	r15, r15, r15, ror r15
	adclo	r0, r0, r0, rrx

positive: adcmi instruction

	adcmi	r0, r0, 0
	adcmi	r15, r15, 0xff000000
	adcmi	r0, r0, r0
	adcmi	r15, r15, r15
	adcmi	r0, r0, r0, lsl 0
	adcmi	r15, r15, r15, lsl 31
	adcmi	r0, r0, r0, lsl r0
	adcmi	r15, r15, r15, lsl r15
	adcmi	r0, r0, r0, lsr 1
	adcmi	r15, r15, r15, lsr 32
	adcmi	r0, r0, r0, lsr r0
	adcmi	r15, r15, r15, asr r15
	adcmi	r0, r0, r0, asr 1
	adcmi	r15, r15, r15, asr 32
	adcmi	r0, r0, r0, asr r0
	adcmi	r15, r15, r15, asr r15
	adcmi	r0, r0, r0, ror 1
	adcmi	r15, r15, r15, ror 31
	adcmi	r0, r0, r0, ror r0
	adcmi	r15, r15, r15, ror r15
	adcmi	r0, r0, r0, rrx

positive: adcpl instruction

	adcpl	r0, r0, 0
	adcpl	r15, r15, 0xff000000
	adcpl	r0, r0, r0
	adcpl	r15, r15, r15
	adcpl	r0, r0, r0, lsl 0
	adcpl	r15, r15, r15, lsl 31
	adcpl	r0, r0, r0, lsl r0
	adcpl	r15, r15, r15, lsl r15
	adcpl	r0, r0, r0, lsr 1
	adcpl	r15, r15, r15, lsr 32
	adcpl	r0, r0, r0, lsr r0
	adcpl	r15, r15, r15, asr r15
	adcpl	r0, r0, r0, asr 1
	adcpl	r15, r15, r15, asr 32
	adcpl	r0, r0, r0, asr r0
	adcpl	r15, r15, r15, asr r15
	adcpl	r0, r0, r0, ror 1
	adcpl	r15, r15, r15, ror 31
	adcpl	r0, r0, r0, ror r0
	adcpl	r15, r15, r15, ror r15
	adcpl	r0, r0, r0, rrx

positive: adcvs instruction

	adcvs	r0, r0, 0
	adcvs	r15, r15, 0xff000000
	adcvs	r0, r0, r0
	adcvs	r15, r15, r15
	adcvs	r0, r0, r0, lsl 0
	adcvs	r15, r15, r15, lsl 31
	adcvs	r0, r0, r0, lsl r0
	adcvs	r15, r15, r15, lsl r15
	adcvs	r0, r0, r0, lsr 1
	adcvs	r15, r15, r15, lsr 32
	adcvs	r0, r0, r0, lsr r0
	adcvs	r15, r15, r15, asr r15
	adcvs	r0, r0, r0, asr 1
	adcvs	r15, r15, r15, asr 32
	adcvs	r0, r0, r0, asr r0
	adcvs	r15, r15, r15, asr r15
	adcvs	r0, r0, r0, ror 1
	adcvs	r15, r15, r15, ror 31
	adcvs	r0, r0, r0, ror r0
	adcvs	r15, r15, r15, ror r15
	adcvs	r0, r0, r0, rrx

positive: adcvc instruction

	adcvc	r0, r0, 0
	adcvc	r15, r15, 0xff000000
	adcvc	r0, r0, r0
	adcvc	r15, r15, r15
	adcvc	r0, r0, r0, lsl 0
	adcvc	r15, r15, r15, lsl 31
	adcvc	r0, r0, r0, lsl r0
	adcvc	r15, r15, r15, lsl r15
	adcvc	r0, r0, r0, lsr 1
	adcvc	r15, r15, r15, lsr 32
	adcvc	r0, r0, r0, lsr r0
	adcvc	r15, r15, r15, asr r15
	adcvc	r0, r0, r0, asr 1
	adcvc	r15, r15, r15, asr 32
	adcvc	r0, r0, r0, asr r0
	adcvc	r15, r15, r15, asr r15
	adcvc	r0, r0, r0, ror 1
	adcvc	r15, r15, r15, ror 31
	adcvc	r0, r0, r0, ror r0
	adcvc	r15, r15, r15, ror r15
	adcvc	r0, r0, r0, rrx

positive: adchi instruction

	adchi	r0, r0, 0
	adchi	r15, r15, 0xff000000
	adchi	r0, r0, r0
	adchi	r15, r15, r15
	adchi	r0, r0, r0, lsl 0
	adchi	r15, r15, r15, lsl 31
	adchi	r0, r0, r0, lsl r0
	adchi	r15, r15, r15, lsl r15
	adchi	r0, r0, r0, lsr 1
	adchi	r15, r15, r15, lsr 32
	adchi	r0, r0, r0, lsr r0
	adchi	r15, r15, r15, asr r15
	adchi	r0, r0, r0, asr 1
	adchi	r15, r15, r15, asr 32
	adchi	r0, r0, r0, asr r0
	adchi	r15, r15, r15, asr r15
	adchi	r0, r0, r0, ror 1
	adchi	r15, r15, r15, ror 31
	adchi	r0, r0, r0, ror r0
	adchi	r15, r15, r15, ror r15
	adchi	r0, r0, r0, rrx

positive: adcls instruction

	adcls	r0, r0, 0
	adcls	r15, r15, 0xff000000
	adcls	r0, r0, r0
	adcls	r15, r15, r15
	adcls	r0, r0, r0, lsl 0
	adcls	r15, r15, r15, lsl 31
	adcls	r0, r0, r0, lsl r0
	adcls	r15, r15, r15, lsl r15
	adcls	r0, r0, r0, lsr 1
	adcls	r15, r15, r15, lsr 32
	adcls	r0, r0, r0, lsr r0
	adcls	r15, r15, r15, asr r15
	adcls	r0, r0, r0, asr 1
	adcls	r15, r15, r15, asr 32
	adcls	r0, r0, r0, asr r0
	adcls	r15, r15, r15, asr r15
	adcls	r0, r0, r0, ror 1
	adcls	r15, r15, r15, ror 31
	adcls	r0, r0, r0, ror r0
	adcls	r15, r15, r15, ror r15
	adcls	r0, r0, r0, rrx

positive: adcge instruction

	adcge	r0, r0, 0
	adcge	r15, r15, 0xff000000
	adcge	r0, r0, r0
	adcge	r15, r15, r15
	adcge	r0, r0, r0, lsl 0
	adcge	r15, r15, r15, lsl 31
	adcge	r0, r0, r0, lsl r0
	adcge	r15, r15, r15, lsl r15
	adcge	r0, r0, r0, lsr 1
	adcge	r15, r15, r15, lsr 32
	adcge	r0, r0, r0, lsr r0
	adcge	r15, r15, r15, asr r15
	adcge	r0, r0, r0, asr 1
	adcge	r15, r15, r15, asr 32
	adcge	r0, r0, r0, asr r0
	adcge	r15, r15, r15, asr r15
	adcge	r0, r0, r0, ror 1
	adcge	r15, r15, r15, ror 31
	adcge	r0, r0, r0, ror r0
	adcge	r15, r15, r15, ror r15
	adcge	r0, r0, r0, rrx

positive: adclt instruction

	adclt	r0, r0, 0
	adclt	r15, r15, 0xff000000
	adclt	r0, r0, r0
	adclt	r15, r15, r15
	adclt	r0, r0, r0, lsl 0
	adclt	r15, r15, r15, lsl 31
	adclt	r0, r0, r0, lsl r0
	adclt	r15, r15, r15, lsl r15
	adclt	r0, r0, r0, lsr 1
	adclt	r15, r15, r15, lsr 32
	adclt	r0, r0, r0, lsr r0
	adclt	r15, r15, r15, asr r15
	adclt	r0, r0, r0, asr 1
	adclt	r15, r15, r15, asr 32
	adclt	r0, r0, r0, asr r0
	adclt	r15, r15, r15, asr r15
	adclt	r0, r0, r0, ror 1
	adclt	r15, r15, r15, ror 31
	adclt	r0, r0, r0, ror r0
	adclt	r15, r15, r15, ror r15
	adclt	r0, r0, r0, rrx

positive: adcgt instruction

	adcgt	r0, r0, 0
	adcgt	r15, r15, 0xff000000
	adcgt	r0, r0, r0
	adcgt	r15, r15, r15
	adcgt	r0, r0, r0, lsl 0
	adcgt	r15, r15, r15, lsl 31
	adcgt	r0, r0, r0, lsl r0
	adcgt	r15, r15, r15, lsl r15
	adcgt	r0, r0, r0, lsr 1
	adcgt	r15, r15, r15, lsr 32
	adcgt	r0, r0, r0, lsr r0
	adcgt	r15, r15, r15, asr r15
	adcgt	r0, r0, r0, asr 1
	adcgt	r15, r15, r15, asr 32
	adcgt	r0, r0, r0, asr r0
	adcgt	r15, r15, r15, asr r15
	adcgt	r0, r0, r0, ror 1
	adcgt	r15, r15, r15, ror 31
	adcgt	r0, r0, r0, ror r0
	adcgt	r15, r15, r15, ror r15
	adcgt	r0, r0, r0, rrx

positive: adcle instruction

	adcle	r0, r0, 0
	adcle	r15, r15, 0xff000000
	adcle	r0, r0, r0
	adcle	r15, r15, r15
	adcle	r0, r0, r0, lsl 0
	adcle	r15, r15, r15, lsl 31
	adcle	r0, r0, r0, lsl r0
	adcle	r15, r15, r15, lsl r15
	adcle	r0, r0, r0, lsr 1
	adcle	r15, r15, r15, lsr 32
	adcle	r0, r0, r0, lsr r0
	adcle	r15, r15, r15, asr r15
	adcle	r0, r0, r0, asr 1
	adcle	r15, r15, r15, asr 32
	adcle	r0, r0, r0, asr r0
	adcle	r15, r15, r15, asr r15
	adcle	r0, r0, r0, ror 1
	adcle	r15, r15, r15, ror 31
	adcle	r0, r0, r0, ror r0
	adcle	r15, r15, r15, ror r15
	adcle	r0, r0, r0, rrx

positive: adcal instruction

	adcal	r0, r0, 0
	adcal	r15, r15, 0xff000000
	adcal	r0, r0, r0
	adcal	r15, r15, r15
	adcal	r0, r0, r0, lsl 0
	adcal	r15, r15, r15, lsl 31
	adcal	r0, r0, r0, lsl r0
	adcal	r15, r15, r15, lsl r15
	adcal	r0, r0, r0, lsr 1
	adcal	r15, r15, r15, lsr 32
	adcal	r0, r0, r0, lsr r0
	adcal	r15, r15, r15, asr r15
	adcal	r0, r0, r0, asr 1
	adcal	r15, r15, r15, asr 32
	adcal	r0, r0, r0, asr r0
	adcal	r15, r15, r15, asr r15
	adcal	r0, r0, r0, ror 1
	adcal	r15, r15, r15, ror 31
	adcal	r0, r0, r0, ror r0
	adcal	r15, r15, r15, ror r15
	adcal	r0, r0, r0, rrx

positive: adcs instruction

	adcs	r0, r0, 0
	adcs	r15, r15, 0xff000000
	adcs	r0, r0, r0
	adcs	r15, r15, r15
	adcs	r0, r0, r0, lsl 0
	adcs	r15, r15, r15, lsl 31
	adcs	r0, r0, r0, lsl r0
	adcs	r15, r15, r15, lsl r15
	adcs	r0, r0, r0, lsr 1
	adcs	r15, r15, r15, lsr 32
	adcs	r0, r0, r0, lsr r0
	adcs	r15, r15, r15, asr r15
	adcs	r0, r0, r0, asr 1
	adcs	r15, r15, r15, asr 32
	adcs	r0, r0, r0, asr r0
	adcs	r15, r15, r15, asr r15
	adcs	r0, r0, r0, ror 1
	adcs	r15, r15, r15, ror 31
	adcs	r0, r0, r0, ror r0
	adcs	r15, r15, r15, ror r15
	adcs	r0, r0, r0, rrx

positive: adcseq instruction

	adcseq	r0, r0, 0
	adcseq	r15, r15, 0xff000000
	adcseq	r0, r0, r0
	adcseq	r15, r15, r15
	adcseq	r0, r0, r0, lsl 0
	adcseq	r15, r15, r15, lsl 31
	adcseq	r0, r0, r0, lsl r0
	adcseq	r15, r15, r15, lsl r15
	adcseq	r0, r0, r0, lsr 1
	adcseq	r15, r15, r15, lsr 32
	adcseq	r0, r0, r0, lsr r0
	adcseq	r15, r15, r15, asr r15
	adcseq	r0, r0, r0, asr 1
	adcseq	r15, r15, r15, asr 32
	adcseq	r0, r0, r0, asr r0
	adcseq	r15, r15, r15, asr r15
	adcseq	r0, r0, r0, ror 1
	adcseq	r15, r15, r15, ror 31
	adcseq	r0, r0, r0, ror r0
	adcseq	r15, r15, r15, ror r15
	adcseq	r0, r0, r0, rrx

positive: adcsne instruction

	adcsne	r0, r0, 0
	adcsne	r15, r15, 0xff000000
	adcsne	r0, r0, r0
	adcsne	r15, r15, r15
	adcsne	r0, r0, r0, lsl 0
	adcsne	r15, r15, r15, lsl 31
	adcsne	r0, r0, r0, lsl r0
	adcsne	r15, r15, r15, lsl r15
	adcsne	r0, r0, r0, lsr 1
	adcsne	r15, r15, r15, lsr 32
	adcsne	r0, r0, r0, lsr r0
	adcsne	r15, r15, r15, asr r15
	adcsne	r0, r0, r0, asr 1
	adcsne	r15, r15, r15, asr 32
	adcsne	r0, r0, r0, asr r0
	adcsne	r15, r15, r15, asr r15
	adcsne	r0, r0, r0, ror 1
	adcsne	r15, r15, r15, ror 31
	adcsne	r0, r0, r0, ror r0
	adcsne	r15, r15, r15, ror r15
	adcsne	r0, r0, r0, rrx

positive: adcscs instruction

	adcscs	r0, r0, 0
	adcscs	r15, r15, 0xff000000
	adcscs	r0, r0, r0
	adcscs	r15, r15, r15
	adcscs	r0, r0, r0, lsl 0
	adcscs	r15, r15, r15, lsl 31
	adcscs	r0, r0, r0, lsl r0
	adcscs	r15, r15, r15, lsl r15
	adcscs	r0, r0, r0, lsr 1
	adcscs	r15, r15, r15, lsr 32
	adcscs	r0, r0, r0, lsr r0
	adcscs	r15, r15, r15, asr r15
	adcscs	r0, r0, r0, asr 1
	adcscs	r15, r15, r15, asr 32
	adcscs	r0, r0, r0, asr r0
	adcscs	r15, r15, r15, asr r15
	adcscs	r0, r0, r0, ror 1
	adcscs	r15, r15, r15, ror 31
	adcscs	r0, r0, r0, ror r0
	adcscs	r15, r15, r15, ror r15
	adcscs	r0, r0, r0, rrx

positive: adcshs instruction

	adcshs	r0, r0, 0
	adcshs	r15, r15, 0xff000000
	adcshs	r0, r0, r0
	adcshs	r15, r15, r15
	adcshs	r0, r0, r0, lsl 0
	adcshs	r15, r15, r15, lsl 31
	adcshs	r0, r0, r0, lsl r0
	adcshs	r15, r15, r15, lsl r15
	adcshs	r0, r0, r0, lsr 1
	adcshs	r15, r15, r15, lsr 32
	adcshs	r0, r0, r0, lsr r0
	adcshs	r15, r15, r15, asr r15
	adcshs	r0, r0, r0, asr 1
	adcshs	r15, r15, r15, asr 32
	adcshs	r0, r0, r0, asr r0
	adcshs	r15, r15, r15, asr r15
	adcshs	r0, r0, r0, ror 1
	adcshs	r15, r15, r15, ror 31
	adcshs	r0, r0, r0, ror r0
	adcshs	r15, r15, r15, ror r15
	adcshs	r0, r0, r0, rrx

positive: adcscc instruction

	adcscc	r0, r0, 0
	adcscc	r15, r15, 0xff000000
	adcscc	r0, r0, r0
	adcscc	r15, r15, r15
	adcscc	r0, r0, r0, lsl 0
	adcscc	r15, r15, r15, lsl 31
	adcscc	r0, r0, r0, lsl r0
	adcscc	r15, r15, r15, lsl r15
	adcscc	r0, r0, r0, lsr 1
	adcscc	r15, r15, r15, lsr 32
	adcscc	r0, r0, r0, lsr r0
	adcscc	r15, r15, r15, asr r15
	adcscc	r0, r0, r0, asr 1
	adcscc	r15, r15, r15, asr 32
	adcscc	r0, r0, r0, asr r0
	adcscc	r15, r15, r15, asr r15
	adcscc	r0, r0, r0, ror 1
	adcscc	r15, r15, r15, ror 31
	adcscc	r0, r0, r0, ror r0
	adcscc	r15, r15, r15, ror r15
	adcscc	r0, r0, r0, rrx

positive: adcslo instruction

	adcslo	r0, r0, 0
	adcslo	r15, r15, 0xff000000
	adcslo	r0, r0, r0
	adcslo	r15, r15, r15
	adcslo	r0, r0, r0, lsl 0
	adcslo	r15, r15, r15, lsl 31
	adcslo	r0, r0, r0, lsl r0
	adcslo	r15, r15, r15, lsl r15
	adcslo	r0, r0, r0, lsr 1
	adcslo	r15, r15, r15, lsr 32
	adcslo	r0, r0, r0, lsr r0
	adcslo	r15, r15, r15, asr r15
	adcslo	r0, r0, r0, asr 1
	adcslo	r15, r15, r15, asr 32
	adcslo	r0, r0, r0, asr r0
	adcslo	r15, r15, r15, asr r15
	adcslo	r0, r0, r0, ror 1
	adcslo	r15, r15, r15, ror 31
	adcslo	r0, r0, r0, ror r0
	adcslo	r15, r15, r15, ror r15
	adcslo	r0, r0, r0, rrx

positive: adcsmi instruction

	adcsmi	r0, r0, 0
	adcsmi	r15, r15, 0xff000000
	adcsmi	r0, r0, r0
	adcsmi	r15, r15, r15
	adcsmi	r0, r0, r0, lsl 0
	adcsmi	r15, r15, r15, lsl 31
	adcsmi	r0, r0, r0, lsl r0
	adcsmi	r15, r15, r15, lsl r15
	adcsmi	r0, r0, r0, lsr 1
	adcsmi	r15, r15, r15, lsr 32
	adcsmi	r0, r0, r0, lsr r0
	adcsmi	r15, r15, r15, asr r15
	adcsmi	r0, r0, r0, asr 1
	adcsmi	r15, r15, r15, asr 32
	adcsmi	r0, r0, r0, asr r0
	adcsmi	r15, r15, r15, asr r15
	adcsmi	r0, r0, r0, ror 1
	adcsmi	r15, r15, r15, ror 31
	adcsmi	r0, r0, r0, ror r0
	adcsmi	r15, r15, r15, ror r15
	adcsmi	r0, r0, r0, rrx

positive: adcspl instruction

	adcspl	r0, r0, 0
	adcspl	r15, r15, 0xff000000
	adcspl	r0, r0, r0
	adcspl	r15, r15, r15
	adcspl	r0, r0, r0, lsl 0
	adcspl	r15, r15, r15, lsl 31
	adcspl	r0, r0, r0, lsl r0
	adcspl	r15, r15, r15, lsl r15
	adcspl	r0, r0, r0, lsr 1
	adcspl	r15, r15, r15, lsr 32
	adcspl	r0, r0, r0, lsr r0
	adcspl	r15, r15, r15, asr r15
	adcspl	r0, r0, r0, asr 1
	adcspl	r15, r15, r15, asr 32
	adcspl	r0, r0, r0, asr r0
	adcspl	r15, r15, r15, asr r15
	adcspl	r0, r0, r0, ror 1
	adcspl	r15, r15, r15, ror 31
	adcspl	r0, r0, r0, ror r0
	adcspl	r15, r15, r15, ror r15
	adcspl	r0, r0, r0, rrx

positive: adcsvs instruction

	adcsvs	r0, r0, 0
	adcsvs	r15, r15, 0xff000000
	adcsvs	r0, r0, r0
	adcsvs	r15, r15, r15
	adcsvs	r0, r0, r0, lsl 0
	adcsvs	r15, r15, r15, lsl 31
	adcsvs	r0, r0, r0, lsl r0
	adcsvs	r15, r15, r15, lsl r15
	adcsvs	r0, r0, r0, lsr 1
	adcsvs	r15, r15, r15, lsr 32
	adcsvs	r0, r0, r0, lsr r0
	adcsvs	r15, r15, r15, asr r15
	adcsvs	r0, r0, r0, asr 1
	adcsvs	r15, r15, r15, asr 32
	adcsvs	r0, r0, r0, asr r0
	adcsvs	r15, r15, r15, asr r15
	adcsvs	r0, r0, r0, ror 1
	adcsvs	r15, r15, r15, ror 31
	adcsvs	r0, r0, r0, ror r0
	adcsvs	r15, r15, r15, ror r15
	adcsvs	r0, r0, r0, rrx

positive: adcsvc instruction

	adcsvc	r0, r0, 0
	adcsvc	r15, r15, 0xff000000
	adcsvc	r0, r0, r0
	adcsvc	r15, r15, r15
	adcsvc	r0, r0, r0, lsl 0
	adcsvc	r15, r15, r15, lsl 31
	adcsvc	r0, r0, r0, lsl r0
	adcsvc	r15, r15, r15, lsl r15
	adcsvc	r0, r0, r0, lsr 1
	adcsvc	r15, r15, r15, lsr 32
	adcsvc	r0, r0, r0, lsr r0
	adcsvc	r15, r15, r15, asr r15
	adcsvc	r0, r0, r0, asr 1
	adcsvc	r15, r15, r15, asr 32
	adcsvc	r0, r0, r0, asr r0
	adcsvc	r15, r15, r15, asr r15
	adcsvc	r0, r0, r0, ror 1
	adcsvc	r15, r15, r15, ror 31
	adcsvc	r0, r0, r0, ror r0
	adcsvc	r15, r15, r15, ror r15
	adcsvc	r0, r0, r0, rrx

positive: adcshi instruction

	adcshi	r0, r0, 0
	adcshi	r15, r15, 0xff000000
	adcshi	r0, r0, r0
	adcshi	r15, r15, r15
	adcshi	r0, r0, r0, lsl 0
	adcshi	r15, r15, r15, lsl 31
	adcshi	r0, r0, r0, lsl r0
	adcshi	r15, r15, r15, lsl r15
	adcshi	r0, r0, r0, lsr 1
	adcshi	r15, r15, r15, lsr 32
	adcshi	r0, r0, r0, lsr r0
	adcshi	r15, r15, r15, asr r15
	adcshi	r0, r0, r0, asr 1
	adcshi	r15, r15, r15, asr 32
	adcshi	r0, r0, r0, asr r0
	adcshi	r15, r15, r15, asr r15
	adcshi	r0, r0, r0, ror 1
	adcshi	r15, r15, r15, ror 31
	adcshi	r0, r0, r0, ror r0
	adcshi	r15, r15, r15, ror r15
	adcshi	r0, r0, r0, rrx

positive: adcsls instruction

	adcsls	r0, r0, 0
	adcsls	r15, r15, 0xff000000
	adcsls	r0, r0, r0
	adcsls	r15, r15, r15
	adcsls	r0, r0, r0, lsl 0
	adcsls	r15, r15, r15, lsl 31
	adcsls	r0, r0, r0, lsl r0
	adcsls	r15, r15, r15, lsl r15
	adcsls	r0, r0, r0, lsr 1
	adcsls	r15, r15, r15, lsr 32
	adcsls	r0, r0, r0, lsr r0
	adcsls	r15, r15, r15, asr r15
	adcsls	r0, r0, r0, asr 1
	adcsls	r15, r15, r15, asr 32
	adcsls	r0, r0, r0, asr r0
	adcsls	r15, r15, r15, asr r15
	adcsls	r0, r0, r0, ror 1
	adcsls	r15, r15, r15, ror 31
	adcsls	r0, r0, r0, ror r0
	adcsls	r15, r15, r15, ror r15
	adcsls	r0, r0, r0, rrx

positive: adcsge instruction

	adcsge	r0, r0, 0
	adcsge	r15, r15, 0xff000000
	adcsge	r0, r0, r0
	adcsge	r15, r15, r15
	adcsge	r0, r0, r0, lsl 0
	adcsge	r15, r15, r15, lsl 31
	adcsge	r0, r0, r0, lsl r0
	adcsge	r15, r15, r15, lsl r15
	adcsge	r0, r0, r0, lsr 1
	adcsge	r15, r15, r15, lsr 32
	adcsge	r0, r0, r0, lsr r0
	adcsge	r15, r15, r15, asr r15
	adcsge	r0, r0, r0, asr 1
	adcsge	r15, r15, r15, asr 32
	adcsge	r0, r0, r0, asr r0
	adcsge	r15, r15, r15, asr r15
	adcsge	r0, r0, r0, ror 1
	adcsge	r15, r15, r15, ror 31
	adcsge	r0, r0, r0, ror r0
	adcsge	r15, r15, r15, ror r15
	adcsge	r0, r0, r0, rrx

positive: adcslt instruction

	adcslt	r0, r0, 0
	adcslt	r15, r15, 0xff000000
	adcslt	r0, r0, r0
	adcslt	r15, r15, r15
	adcslt	r0, r0, r0, lsl 0
	adcslt	r15, r15, r15, lsl 31
	adcslt	r0, r0, r0, lsl r0
	adcslt	r15, r15, r15, lsl r15
	adcslt	r0, r0, r0, lsr 1
	adcslt	r15, r15, r15, lsr 32
	adcslt	r0, r0, r0, lsr r0
	adcslt	r15, r15, r15, asr r15
	adcslt	r0, r0, r0, asr 1
	adcslt	r15, r15, r15, asr 32
	adcslt	r0, r0, r0, asr r0
	adcslt	r15, r15, r15, asr r15
	adcslt	r0, r0, r0, ror 1
	adcslt	r15, r15, r15, ror 31
	adcslt	r0, r0, r0, ror r0
	adcslt	r15, r15, r15, ror r15
	adcslt	r0, r0, r0, rrx

positive: adcsgt instruction

	adcsgt	r0, r0, 0
	adcsgt	r15, r15, 0xff000000
	adcsgt	r0, r0, r0
	adcsgt	r15, r15, r15
	adcsgt	r0, r0, r0, lsl 0
	adcsgt	r15, r15, r15, lsl 31
	adcsgt	r0, r0, r0, lsl r0
	adcsgt	r15, r15, r15, lsl r15
	adcsgt	r0, r0, r0, lsr 1
	adcsgt	r15, r15, r15, lsr 32
	adcsgt	r0, r0, r0, lsr r0
	adcsgt	r15, r15, r15, asr r15
	adcsgt	r0, r0, r0, asr 1
	adcsgt	r15, r15, r15, asr 32
	adcsgt	r0, r0, r0, asr r0
	adcsgt	r15, r15, r15, asr r15
	adcsgt	r0, r0, r0, ror 1
	adcsgt	r15, r15, r15, ror 31
	adcsgt	r0, r0, r0, ror r0
	adcsgt	r15, r15, r15, ror r15
	adcsgt	r0, r0, r0, rrx

positive: adcsle instruction

	adcsle	r0, r0, 0
	adcsle	r15, r15, 0xff000000
	adcsle	r0, r0, r0
	adcsle	r15, r15, r15
	adcsle	r0, r0, r0, lsl 0
	adcsle	r15, r15, r15, lsl 31
	adcsle	r0, r0, r0, lsl r0
	adcsle	r15, r15, r15, lsl r15
	adcsle	r0, r0, r0, lsr 1
	adcsle	r15, r15, r15, lsr 32
	adcsle	r0, r0, r0, lsr r0
	adcsle	r15, r15, r15, asr r15
	adcsle	r0, r0, r0, asr 1
	adcsle	r15, r15, r15, asr 32
	adcsle	r0, r0, r0, asr r0
	adcsle	r15, r15, r15, asr r15
	adcsle	r0, r0, r0, ror 1
	adcsle	r15, r15, r15, ror 31
	adcsle	r0, r0, r0, ror r0
	adcsle	r15, r15, r15, ror r15
	adcsle	r0, r0, r0, rrx

positive: adcsal instruction

	adcsal	r0, r0, 0
	adcsal	r15, r15, 0xff000000
	adcsal	r0, r0, r0
	adcsal	r15, r15, r15
	adcsal	r0, r0, r0, lsl 0
	adcsal	r15, r15, r15, lsl 31
	adcsal	r0, r0, r0, lsl r0
	adcsal	r15, r15, r15, lsl r15
	adcsal	r0, r0, r0, lsr 1
	adcsal	r15, r15, r15, lsr 32
	adcsal	r0, r0, r0, lsr r0
	adcsal	r15, r15, r15, asr r15
	adcsal	r0, r0, r0, asr 1
	adcsal	r15, r15, r15, asr 32
	adcsal	r0, r0, r0, asr r0
	adcsal	r15, r15, r15, asr r15
	adcsal	r0, r0, r0, ror 1
	adcsal	r15, r15, r15, ror 31
	adcsal	r0, r0, r0, ror r0
	adcsal	r15, r15, r15, ror r15
	adcsal	r0, r0, r0, rrx

positive: add instruction

	add	r0, r0, 0
	add	r15, r15, 0xff000000
	add	r0, r0, r0
	add	r15, r15, r15
	add	r0, r0, r0, lsl 0
	add	r15, r15, r15, lsl 31
	add	r0, r0, r0, lsl r0
	add	r15, r15, r15, lsl r15
	add	r0, r0, r0, lsr 1
	add	r15, r15, r15, lsr 32
	add	r0, r0, r0, lsr r0
	add	r15, r15, r15, asr r15
	add	r0, r0, r0, asr 1
	add	r15, r15, r15, asr 32
	add	r0, r0, r0, asr r0
	add	r15, r15, r15, asr r15
	add	r0, r0, r0, ror 1
	add	r15, r15, r15, ror 31
	add	r0, r0, r0, ror r0
	add	r15, r15, r15, ror r15
	add	r0, r0, r0, rrx

positive: addeq instruction

	addeq	r0, r0, 0
	addeq	r15, r15, 0xff000000
	addeq	r0, r0, r0
	addeq	r15, r15, r15
	addeq	r0, r0, r0, lsl 0
	addeq	r15, r15, r15, lsl 31
	addeq	r0, r0, r0, lsl r0
	addeq	r15, r15, r15, lsl r15
	addeq	r0, r0, r0, lsr 1
	addeq	r15, r15, r15, lsr 32
	addeq	r0, r0, r0, lsr r0
	addeq	r15, r15, r15, asr r15
	addeq	r0, r0, r0, asr 1
	addeq	r15, r15, r15, asr 32
	addeq	r0, r0, r0, asr r0
	addeq	r15, r15, r15, asr r15
	addeq	r0, r0, r0, ror 1
	addeq	r15, r15, r15, ror 31
	addeq	r0, r0, r0, ror r0
	addeq	r15, r15, r15, ror r15
	addeq	r0, r0, r0, rrx

positive: addne instruction

	addne	r0, r0, 0
	addne	r15, r15, 0xff000000
	addne	r0, r0, r0
	addne	r15, r15, r15
	addne	r0, r0, r0, lsl 0
	addne	r15, r15, r15, lsl 31
	addne	r0, r0, r0, lsl r0
	addne	r15, r15, r15, lsl r15
	addne	r0, r0, r0, lsr 1
	addne	r15, r15, r15, lsr 32
	addne	r0, r0, r0, lsr r0
	addne	r15, r15, r15, asr r15
	addne	r0, r0, r0, asr 1
	addne	r15, r15, r15, asr 32
	addne	r0, r0, r0, asr r0
	addne	r15, r15, r15, asr r15
	addne	r0, r0, r0, ror 1
	addne	r15, r15, r15, ror 31
	addne	r0, r0, r0, ror r0
	addne	r15, r15, r15, ror r15
	addne	r0, r0, r0, rrx

positive: addcs instruction

	addcs	r0, r0, 0
	addcs	r15, r15, 0xff000000
	addcs	r0, r0, r0
	addcs	r15, r15, r15
	addcs	r0, r0, r0, lsl 0
	addcs	r15, r15, r15, lsl 31
	addcs	r0, r0, r0, lsl r0
	addcs	r15, r15, r15, lsl r15
	addcs	r0, r0, r0, lsr 1
	addcs	r15, r15, r15, lsr 32
	addcs	r0, r0, r0, lsr r0
	addcs	r15, r15, r15, asr r15
	addcs	r0, r0, r0, asr 1
	addcs	r15, r15, r15, asr 32
	addcs	r0, r0, r0, asr r0
	addcs	r15, r15, r15, asr r15
	addcs	r0, r0, r0, ror 1
	addcs	r15, r15, r15, ror 31
	addcs	r0, r0, r0, ror r0
	addcs	r15, r15, r15, ror r15
	addcs	r0, r0, r0, rrx

positive: addhs instruction

	addhs	r0, r0, 0
	addhs	r15, r15, 0xff000000
	addhs	r0, r0, r0
	addhs	r15, r15, r15
	addhs	r0, r0, r0, lsl 0
	addhs	r15, r15, r15, lsl 31
	addhs	r0, r0, r0, lsl r0
	addhs	r15, r15, r15, lsl r15
	addhs	r0, r0, r0, lsr 1
	addhs	r15, r15, r15, lsr 32
	addhs	r0, r0, r0, lsr r0
	addhs	r15, r15, r15, asr r15
	addhs	r0, r0, r0, asr 1
	addhs	r15, r15, r15, asr 32
	addhs	r0, r0, r0, asr r0
	addhs	r15, r15, r15, asr r15
	addhs	r0, r0, r0, ror 1
	addhs	r15, r15, r15, ror 31
	addhs	r0, r0, r0, ror r0
	addhs	r15, r15, r15, ror r15
	addhs	r0, r0, r0, rrx

positive: addcc instruction

	addcc	r0, r0, 0
	addcc	r15, r15, 0xff000000
	addcc	r0, r0, r0
	addcc	r15, r15, r15
	addcc	r0, r0, r0, lsl 0
	addcc	r15, r15, r15, lsl 31
	addcc	r0, r0, r0, lsl r0
	addcc	r15, r15, r15, lsl r15
	addcc	r0, r0, r0, lsr 1
	addcc	r15, r15, r15, lsr 32
	addcc	r0, r0, r0, lsr r0
	addcc	r15, r15, r15, asr r15
	addcc	r0, r0, r0, asr 1
	addcc	r15, r15, r15, asr 32
	addcc	r0, r0, r0, asr r0
	addcc	r15, r15, r15, asr r15
	addcc	r0, r0, r0, ror 1
	addcc	r15, r15, r15, ror 31
	addcc	r0, r0, r0, ror r0
	addcc	r15, r15, r15, ror r15
	addcc	r0, r0, r0, rrx

positive: addlo instruction

	addlo	r0, r0, 0
	addlo	r15, r15, 0xff000000
	addlo	r0, r0, r0
	addlo	r15, r15, r15
	addlo	r0, r0, r0, lsl 0
	addlo	r15, r15, r15, lsl 31
	addlo	r0, r0, r0, lsl r0
	addlo	r15, r15, r15, lsl r15
	addlo	r0, r0, r0, lsr 1
	addlo	r15, r15, r15, lsr 32
	addlo	r0, r0, r0, lsr r0
	addlo	r15, r15, r15, asr r15
	addlo	r0, r0, r0, asr 1
	addlo	r15, r15, r15, asr 32
	addlo	r0, r0, r0, asr r0
	addlo	r15, r15, r15, asr r15
	addlo	r0, r0, r0, ror 1
	addlo	r15, r15, r15, ror 31
	addlo	r0, r0, r0, ror r0
	addlo	r15, r15, r15, ror r15
	addlo	r0, r0, r0, rrx

positive: addmi instruction

	addmi	r0, r0, 0
	addmi	r15, r15, 0xff000000
	addmi	r0, r0, r0
	addmi	r15, r15, r15
	addmi	r0, r0, r0, lsl 0
	addmi	r15, r15, r15, lsl 31
	addmi	r0, r0, r0, lsl r0
	addmi	r15, r15, r15, lsl r15
	addmi	r0, r0, r0, lsr 1
	addmi	r15, r15, r15, lsr 32
	addmi	r0, r0, r0, lsr r0
	addmi	r15, r15, r15, asr r15
	addmi	r0, r0, r0, asr 1
	addmi	r15, r15, r15, asr 32
	addmi	r0, r0, r0, asr r0
	addmi	r15, r15, r15, asr r15
	addmi	r0, r0, r0, ror 1
	addmi	r15, r15, r15, ror 31
	addmi	r0, r0, r0, ror r0
	addmi	r15, r15, r15, ror r15
	addmi	r0, r0, r0, rrx

positive: addpl instruction

	addpl	r0, r0, 0
	addpl	r15, r15, 0xff000000
	addpl	r0, r0, r0
	addpl	r15, r15, r15
	addpl	r0, r0, r0, lsl 0
	addpl	r15, r15, r15, lsl 31
	addpl	r0, r0, r0, lsl r0
	addpl	r15, r15, r15, lsl r15
	addpl	r0, r0, r0, lsr 1
	addpl	r15, r15, r15, lsr 32
	addpl	r0, r0, r0, lsr r0
	addpl	r15, r15, r15, asr r15
	addpl	r0, r0, r0, asr 1
	addpl	r15, r15, r15, asr 32
	addpl	r0, r0, r0, asr r0
	addpl	r15, r15, r15, asr r15
	addpl	r0, r0, r0, ror 1
	addpl	r15, r15, r15, ror 31
	addpl	r0, r0, r0, ror r0
	addpl	r15, r15, r15, ror r15
	addpl	r0, r0, r0, rrx

positive: addvs instruction

	addvs	r0, r0, 0
	addvs	r15, r15, 0xff000000
	addvs	r0, r0, r0
	addvs	r15, r15, r15
	addvs	r0, r0, r0, lsl 0
	addvs	r15, r15, r15, lsl 31
	addvs	r0, r0, r0, lsl r0
	addvs	r15, r15, r15, lsl r15
	addvs	r0, r0, r0, lsr 1
	addvs	r15, r15, r15, lsr 32
	addvs	r0, r0, r0, lsr r0
	addvs	r15, r15, r15, asr r15
	addvs	r0, r0, r0, asr 1
	addvs	r15, r15, r15, asr 32
	addvs	r0, r0, r0, asr r0
	addvs	r15, r15, r15, asr r15
	addvs	r0, r0, r0, ror 1
	addvs	r15, r15, r15, ror 31
	addvs	r0, r0, r0, ror r0
	addvs	r15, r15, r15, ror r15
	addvs	r0, r0, r0, rrx

positive: addvc instruction

	addvc	r0, r0, 0
	addvc	r15, r15, 0xff000000
	addvc	r0, r0, r0
	addvc	r15, r15, r15
	addvc	r0, r0, r0, lsl 0
	addvc	r15, r15, r15, lsl 31
	addvc	r0, r0, r0, lsl r0
	addvc	r15, r15, r15, lsl r15
	addvc	r0, r0, r0, lsr 1
	addvc	r15, r15, r15, lsr 32
	addvc	r0, r0, r0, lsr r0
	addvc	r15, r15, r15, asr r15
	addvc	r0, r0, r0, asr 1
	addvc	r15, r15, r15, asr 32
	addvc	r0, r0, r0, asr r0
	addvc	r15, r15, r15, asr r15
	addvc	r0, r0, r0, ror 1
	addvc	r15, r15, r15, ror 31
	addvc	r0, r0, r0, ror r0
	addvc	r15, r15, r15, ror r15
	addvc	r0, r0, r0, rrx

positive: addhi instruction

	addhi	r0, r0, 0
	addhi	r15, r15, 0xff000000
	addhi	r0, r0, r0
	addhi	r15, r15, r15
	addhi	r0, r0, r0, lsl 0
	addhi	r15, r15, r15, lsl 31
	addhi	r0, r0, r0, lsl r0
	addhi	r15, r15, r15, lsl r15
	addhi	r0, r0, r0, lsr 1
	addhi	r15, r15, r15, lsr 32
	addhi	r0, r0, r0, lsr r0
	addhi	r15, r15, r15, asr r15
	addhi	r0, r0, r0, asr 1
	addhi	r15, r15, r15, asr 32
	addhi	r0, r0, r0, asr r0
	addhi	r15, r15, r15, asr r15
	addhi	r0, r0, r0, ror 1
	addhi	r15, r15, r15, ror 31
	addhi	r0, r0, r0, ror r0
	addhi	r15, r15, r15, ror r15
	addhi	r0, r0, r0, rrx

positive: addls instruction

	addls	r0, r0, 0
	addls	r15, r15, 0xff000000
	addls	r0, r0, r0
	addls	r15, r15, r15
	addls	r0, r0, r0, lsl 0
	addls	r15, r15, r15, lsl 31
	addls	r0, r0, r0, lsl r0
	addls	r15, r15, r15, lsl r15
	addls	r0, r0, r0, lsr 1
	addls	r15, r15, r15, lsr 32
	addls	r0, r0, r0, lsr r0
	addls	r15, r15, r15, asr r15
	addls	r0, r0, r0, asr 1
	addls	r15, r15, r15, asr 32
	addls	r0, r0, r0, asr r0
	addls	r15, r15, r15, asr r15
	addls	r0, r0, r0, ror 1
	addls	r15, r15, r15, ror 31
	addls	r0, r0, r0, ror r0
	addls	r15, r15, r15, ror r15
	addls	r0, r0, r0, rrx

positive: addge instruction

	addge	r0, r0, 0
	addge	r15, r15, 0xff000000
	addge	r0, r0, r0
	addge	r15, r15, r15
	addge	r0, r0, r0, lsl 0
	addge	r15, r15, r15, lsl 31
	addge	r0, r0, r0, lsl r0
	addge	r15, r15, r15, lsl r15
	addge	r0, r0, r0, lsr 1
	addge	r15, r15, r15, lsr 32
	addge	r0, r0, r0, lsr r0
	addge	r15, r15, r15, asr r15
	addge	r0, r0, r0, asr 1
	addge	r15, r15, r15, asr 32
	addge	r0, r0, r0, asr r0
	addge	r15, r15, r15, asr r15
	addge	r0, r0, r0, ror 1
	addge	r15, r15, r15, ror 31
	addge	r0, r0, r0, ror r0
	addge	r15, r15, r15, ror r15
	addge	r0, r0, r0, rrx

positive: addlt instruction

	addlt	r0, r0, 0
	addlt	r15, r15, 0xff000000
	addlt	r0, r0, r0
	addlt	r15, r15, r15
	addlt	r0, r0, r0, lsl 0
	addlt	r15, r15, r15, lsl 31
	addlt	r0, r0, r0, lsl r0
	addlt	r15, r15, r15, lsl r15
	addlt	r0, r0, r0, lsr 1
	addlt	r15, r15, r15, lsr 32
	addlt	r0, r0, r0, lsr r0
	addlt	r15, r15, r15, asr r15
	addlt	r0, r0, r0, asr 1
	addlt	r15, r15, r15, asr 32
	addlt	r0, r0, r0, asr r0
	addlt	r15, r15, r15, asr r15
	addlt	r0, r0, r0, ror 1
	addlt	r15, r15, r15, ror 31
	addlt	r0, r0, r0, ror r0
	addlt	r15, r15, r15, ror r15
	addlt	r0, r0, r0, rrx

positive: addgt instruction

	addgt	r0, r0, 0
	addgt	r15, r15, 0xff000000
	addgt	r0, r0, r0
	addgt	r15, r15, r15
	addgt	r0, r0, r0, lsl 0
	addgt	r15, r15, r15, lsl 31
	addgt	r0, r0, r0, lsl r0
	addgt	r15, r15, r15, lsl r15
	addgt	r0, r0, r0, lsr 1
	addgt	r15, r15, r15, lsr 32
	addgt	r0, r0, r0, lsr r0
	addgt	r15, r15, r15, asr r15
	addgt	r0, r0, r0, asr 1
	addgt	r15, r15, r15, asr 32
	addgt	r0, r0, r0, asr r0
	addgt	r15, r15, r15, asr r15
	addgt	r0, r0, r0, ror 1
	addgt	r15, r15, r15, ror 31
	addgt	r0, r0, r0, ror r0
	addgt	r15, r15, r15, ror r15
	addgt	r0, r0, r0, rrx

positive: addle instruction

	addle	r0, r0, 0
	addle	r15, r15, 0xff000000
	addle	r0, r0, r0
	addle	r15, r15, r15
	addle	r0, r0, r0, lsl 0
	addle	r15, r15, r15, lsl 31
	addle	r0, r0, r0, lsl r0
	addle	r15, r15, r15, lsl r15
	addle	r0, r0, r0, lsr 1
	addle	r15, r15, r15, lsr 32
	addle	r0, r0, r0, lsr r0
	addle	r15, r15, r15, asr r15
	addle	r0, r0, r0, asr 1
	addle	r15, r15, r15, asr 32
	addle	r0, r0, r0, asr r0
	addle	r15, r15, r15, asr r15
	addle	r0, r0, r0, ror 1
	addle	r15, r15, r15, ror 31
	addle	r0, r0, r0, ror r0
	addle	r15, r15, r15, ror r15
	addle	r0, r0, r0, rrx

positive: addal instruction

	addal	r0, r0, 0
	addal	r15, r15, 0xff000000
	addal	r0, r0, r0
	addal	r15, r15, r15
	addal	r0, r0, r0, lsl 0
	addal	r15, r15, r15, lsl 31
	addal	r0, r0, r0, lsl r0
	addal	r15, r15, r15, lsl r15
	addal	r0, r0, r0, lsr 1
	addal	r15, r15, r15, lsr 32
	addal	r0, r0, r0, lsr r0
	addal	r15, r15, r15, asr r15
	addal	r0, r0, r0, asr 1
	addal	r15, r15, r15, asr 32
	addal	r0, r0, r0, asr r0
	addal	r15, r15, r15, asr r15
	addal	r0, r0, r0, ror 1
	addal	r15, r15, r15, ror 31
	addal	r0, r0, r0, ror r0
	addal	r15, r15, r15, ror r15
	addal	r0, r0, r0, rrx

positive: adds instruction

	adds	r0, r0, 0
	adds	r15, r15, 0xff000000
	adds	r0, r0, r0
	adds	r15, r15, r15
	adds	r0, r0, r0, lsl 0
	adds	r15, r15, r15, lsl 31
	adds	r0, r0, r0, lsl r0
	adds	r15, r15, r15, lsl r15
	adds	r0, r0, r0, lsr 1
	adds	r15, r15, r15, lsr 32
	adds	r0, r0, r0, lsr r0
	adds	r15, r15, r15, asr r15
	adds	r0, r0, r0, asr 1
	adds	r15, r15, r15, asr 32
	adds	r0, r0, r0, asr r0
	adds	r15, r15, r15, asr r15
	adds	r0, r0, r0, ror 1
	adds	r15, r15, r15, ror 31
	adds	r0, r0, r0, ror r0
	adds	r15, r15, r15, ror r15
	adds	r0, r0, r0, rrx

positive: addseq instruction

	addseq	r0, r0, 0
	addseq	r15, r15, 0xff000000
	addseq	r0, r0, r0
	addseq	r15, r15, r15
	addseq	r0, r0, r0, lsl 0
	addseq	r15, r15, r15, lsl 31
	addseq	r0, r0, r0, lsl r0
	addseq	r15, r15, r15, lsl r15
	addseq	r0, r0, r0, lsr 1
	addseq	r15, r15, r15, lsr 32
	addseq	r0, r0, r0, lsr r0
	addseq	r15, r15, r15, asr r15
	addseq	r0, r0, r0, asr 1
	addseq	r15, r15, r15, asr 32
	addseq	r0, r0, r0, asr r0
	addseq	r15, r15, r15, asr r15
	addseq	r0, r0, r0, ror 1
	addseq	r15, r15, r15, ror 31
	addseq	r0, r0, r0, ror r0
	addseq	r15, r15, r15, ror r15
	addseq	r0, r0, r0, rrx

positive: addsne instruction

	addsne	r0, r0, 0
	addsne	r15, r15, 0xff000000
	addsne	r0, r0, r0
	addsne	r15, r15, r15
	addsne	r0, r0, r0, lsl 0
	addsne	r15, r15, r15, lsl 31
	addsne	r0, r0, r0, lsl r0
	addsne	r15, r15, r15, lsl r15
	addsne	r0, r0, r0, lsr 1
	addsne	r15, r15, r15, lsr 32
	addsne	r0, r0, r0, lsr r0
	addsne	r15, r15, r15, asr r15
	addsne	r0, r0, r0, asr 1
	addsne	r15, r15, r15, asr 32
	addsne	r0, r0, r0, asr r0
	addsne	r15, r15, r15, asr r15
	addsne	r0, r0, r0, ror 1
	addsne	r15, r15, r15, ror 31
	addsne	r0, r0, r0, ror r0
	addsne	r15, r15, r15, ror r15
	addsne	r0, r0, r0, rrx

positive: addscs instruction

	addscs	r0, r0, 0
	addscs	r15, r15, 0xff000000
	addscs	r0, r0, r0
	addscs	r15, r15, r15
	addscs	r0, r0, r0, lsl 0
	addscs	r15, r15, r15, lsl 31
	addscs	r0, r0, r0, lsl r0
	addscs	r15, r15, r15, lsl r15
	addscs	r0, r0, r0, lsr 1
	addscs	r15, r15, r15, lsr 32
	addscs	r0, r0, r0, lsr r0
	addscs	r15, r15, r15, asr r15
	addscs	r0, r0, r0, asr 1
	addscs	r15, r15, r15, asr 32
	addscs	r0, r0, r0, asr r0
	addscs	r15, r15, r15, asr r15
	addscs	r0, r0, r0, ror 1
	addscs	r15, r15, r15, ror 31
	addscs	r0, r0, r0, ror r0
	addscs	r15, r15, r15, ror r15
	addscs	r0, r0, r0, rrx

positive: addshs instruction

	addshs	r0, r0, 0
	addshs	r15, r15, 0xff000000
	addshs	r0, r0, r0
	addshs	r15, r15, r15
	addshs	r0, r0, r0, lsl 0
	addshs	r15, r15, r15, lsl 31
	addshs	r0, r0, r0, lsl r0
	addshs	r15, r15, r15, lsl r15
	addshs	r0, r0, r0, lsr 1
	addshs	r15, r15, r15, lsr 32
	addshs	r0, r0, r0, lsr r0
	addshs	r15, r15, r15, asr r15
	addshs	r0, r0, r0, asr 1
	addshs	r15, r15, r15, asr 32
	addshs	r0, r0, r0, asr r0
	addshs	r15, r15, r15, asr r15
	addshs	r0, r0, r0, ror 1
	addshs	r15, r15, r15, ror 31
	addshs	r0, r0, r0, ror r0
	addshs	r15, r15, r15, ror r15
	addshs	r0, r0, r0, rrx

positive: addscc instruction

	addscc	r0, r0, 0
	addscc	r15, r15, 0xff000000
	addscc	r0, r0, r0
	addscc	r15, r15, r15
	addscc	r0, r0, r0, lsl 0
	addscc	r15, r15, r15, lsl 31
	addscc	r0, r0, r0, lsl r0
	addscc	r15, r15, r15, lsl r15
	addscc	r0, r0, r0, lsr 1
	addscc	r15, r15, r15, lsr 32
	addscc	r0, r0, r0, lsr r0
	addscc	r15, r15, r15, asr r15
	addscc	r0, r0, r0, asr 1
	addscc	r15, r15, r15, asr 32
	addscc	r0, r0, r0, asr r0
	addscc	r15, r15, r15, asr r15
	addscc	r0, r0, r0, ror 1
	addscc	r15, r15, r15, ror 31
	addscc	r0, r0, r0, ror r0
	addscc	r15, r15, r15, ror r15
	addscc	r0, r0, r0, rrx

positive: addslo instruction

	addslo	r0, r0, 0
	addslo	r15, r15, 0xff000000
	addslo	r0, r0, r0
	addslo	r15, r15, r15
	addslo	r0, r0, r0, lsl 0
	addslo	r15, r15, r15, lsl 31
	addslo	r0, r0, r0, lsl r0
	addslo	r15, r15, r15, lsl r15
	addslo	r0, r0, r0, lsr 1
	addslo	r15, r15, r15, lsr 32
	addslo	r0, r0, r0, lsr r0
	addslo	r15, r15, r15, asr r15
	addslo	r0, r0, r0, asr 1
	addslo	r15, r15, r15, asr 32
	addslo	r0, r0, r0, asr r0
	addslo	r15, r15, r15, asr r15
	addslo	r0, r0, r0, ror 1
	addslo	r15, r15, r15, ror 31
	addslo	r0, r0, r0, ror r0
	addslo	r15, r15, r15, ror r15
	addslo	r0, r0, r0, rrx

positive: addsmi instruction

	addsmi	r0, r0, 0
	addsmi	r15, r15, 0xff000000
	addsmi	r0, r0, r0
	addsmi	r15, r15, r15
	addsmi	r0, r0, r0, lsl 0
	addsmi	r15, r15, r15, lsl 31
	addsmi	r0, r0, r0, lsl r0
	addsmi	r15, r15, r15, lsl r15
	addsmi	r0, r0, r0, lsr 1
	addsmi	r15, r15, r15, lsr 32
	addsmi	r0, r0, r0, lsr r0
	addsmi	r15, r15, r15, asr r15
	addsmi	r0, r0, r0, asr 1
	addsmi	r15, r15, r15, asr 32
	addsmi	r0, r0, r0, asr r0
	addsmi	r15, r15, r15, asr r15
	addsmi	r0, r0, r0, ror 1
	addsmi	r15, r15, r15, ror 31
	addsmi	r0, r0, r0, ror r0
	addsmi	r15, r15, r15, ror r15
	addsmi	r0, r0, r0, rrx

positive: addspl instruction

	addspl	r0, r0, 0
	addspl	r15, r15, 0xff000000
	addspl	r0, r0, r0
	addspl	r15, r15, r15
	addspl	r0, r0, r0, lsl 0
	addspl	r15, r15, r15, lsl 31
	addspl	r0, r0, r0, lsl r0
	addspl	r15, r15, r15, lsl r15
	addspl	r0, r0, r0, lsr 1
	addspl	r15, r15, r15, lsr 32
	addspl	r0, r0, r0, lsr r0
	addspl	r15, r15, r15, asr r15
	addspl	r0, r0, r0, asr 1
	addspl	r15, r15, r15, asr 32
	addspl	r0, r0, r0, asr r0
	addspl	r15, r15, r15, asr r15
	addspl	r0, r0, r0, ror 1
	addspl	r15, r15, r15, ror 31
	addspl	r0, r0, r0, ror r0
	addspl	r15, r15, r15, ror r15
	addspl	r0, r0, r0, rrx

positive: addsvs instruction

	addsvs	r0, r0, 0
	addsvs	r15, r15, 0xff000000
	addsvs	r0, r0, r0
	addsvs	r15, r15, r15
	addsvs	r0, r0, r0, lsl 0
	addsvs	r15, r15, r15, lsl 31
	addsvs	r0, r0, r0, lsl r0
	addsvs	r15, r15, r15, lsl r15
	addsvs	r0, r0, r0, lsr 1
	addsvs	r15, r15, r15, lsr 32
	addsvs	r0, r0, r0, lsr r0
	addsvs	r15, r15, r15, asr r15
	addsvs	r0, r0, r0, asr 1
	addsvs	r15, r15, r15, asr 32
	addsvs	r0, r0, r0, asr r0
	addsvs	r15, r15, r15, asr r15
	addsvs	r0, r0, r0, ror 1
	addsvs	r15, r15, r15, ror 31
	addsvs	r0, r0, r0, ror r0
	addsvs	r15, r15, r15, ror r15
	addsvs	r0, r0, r0, rrx

positive: addsvc instruction

	addsvc	r0, r0, 0
	addsvc	r15, r15, 0xff000000
	addsvc	r0, r0, r0
	addsvc	r15, r15, r15
	addsvc	r0, r0, r0, lsl 0
	addsvc	r15, r15, r15, lsl 31
	addsvc	r0, r0, r0, lsl r0
	addsvc	r15, r15, r15, lsl r15
	addsvc	r0, r0, r0, lsr 1
	addsvc	r15, r15, r15, lsr 32
	addsvc	r0, r0, r0, lsr r0
	addsvc	r15, r15, r15, asr r15
	addsvc	r0, r0, r0, asr 1
	addsvc	r15, r15, r15, asr 32
	addsvc	r0, r0, r0, asr r0
	addsvc	r15, r15, r15, asr r15
	addsvc	r0, r0, r0, ror 1
	addsvc	r15, r15, r15, ror 31
	addsvc	r0, r0, r0, ror r0
	addsvc	r15, r15, r15, ror r15
	addsvc	r0, r0, r0, rrx

positive: addshi instruction

	addshi	r0, r0, 0
	addshi	r15, r15, 0xff000000
	addshi	r0, r0, r0
	addshi	r15, r15, r15
	addshi	r0, r0, r0, lsl 0
	addshi	r15, r15, r15, lsl 31
	addshi	r0, r0, r0, lsl r0
	addshi	r15, r15, r15, lsl r15
	addshi	r0, r0, r0, lsr 1
	addshi	r15, r15, r15, lsr 32
	addshi	r0, r0, r0, lsr r0
	addshi	r15, r15, r15, asr r15
	addshi	r0, r0, r0, asr 1
	addshi	r15, r15, r15, asr 32
	addshi	r0, r0, r0, asr r0
	addshi	r15, r15, r15, asr r15
	addshi	r0, r0, r0, ror 1
	addshi	r15, r15, r15, ror 31
	addshi	r0, r0, r0, ror r0
	addshi	r15, r15, r15, ror r15
	addshi	r0, r0, r0, rrx

positive: addsls instruction

	addsls	r0, r0, 0
	addsls	r15, r15, 0xff000000
	addsls	r0, r0, r0
	addsls	r15, r15, r15
	addsls	r0, r0, r0, lsl 0
	addsls	r15, r15, r15, lsl 31
	addsls	r0, r0, r0, lsl r0
	addsls	r15, r15, r15, lsl r15
	addsls	r0, r0, r0, lsr 1
	addsls	r15, r15, r15, lsr 32
	addsls	r0, r0, r0, lsr r0
	addsls	r15, r15, r15, asr r15
	addsls	r0, r0, r0, asr 1
	addsls	r15, r15, r15, asr 32
	addsls	r0, r0, r0, asr r0
	addsls	r15, r15, r15, asr r15
	addsls	r0, r0, r0, ror 1
	addsls	r15, r15, r15, ror 31
	addsls	r0, r0, r0, ror r0
	addsls	r15, r15, r15, ror r15
	addsls	r0, r0, r0, rrx

positive: addsge instruction

	addsge	r0, r0, 0
	addsge	r15, r15, 0xff000000
	addsge	r0, r0, r0
	addsge	r15, r15, r15
	addsge	r0, r0, r0, lsl 0
	addsge	r15, r15, r15, lsl 31
	addsge	r0, r0, r0, lsl r0
	addsge	r15, r15, r15, lsl r15
	addsge	r0, r0, r0, lsr 1
	addsge	r15, r15, r15, lsr 32
	addsge	r0, r0, r0, lsr r0
	addsge	r15, r15, r15, asr r15
	addsge	r0, r0, r0, asr 1
	addsge	r15, r15, r15, asr 32
	addsge	r0, r0, r0, asr r0
	addsge	r15, r15, r15, asr r15
	addsge	r0, r0, r0, ror 1
	addsge	r15, r15, r15, ror 31
	addsge	r0, r0, r0, ror r0
	addsge	r15, r15, r15, ror r15
	addsge	r0, r0, r0, rrx

positive: addslt instruction

	addslt	r0, r0, 0
	addslt	r15, r15, 0xff000000
	addslt	r0, r0, r0
	addslt	r15, r15, r15
	addslt	r0, r0, r0, lsl 0
	addslt	r15, r15, r15, lsl 31
	addslt	r0, r0, r0, lsl r0
	addslt	r15, r15, r15, lsl r15
	addslt	r0, r0, r0, lsr 1
	addslt	r15, r15, r15, lsr 32
	addslt	r0, r0, r0, lsr r0
	addslt	r15, r15, r15, asr r15
	addslt	r0, r0, r0, asr 1
	addslt	r15, r15, r15, asr 32
	addslt	r0, r0, r0, asr r0
	addslt	r15, r15, r15, asr r15
	addslt	r0, r0, r0, ror 1
	addslt	r15, r15, r15, ror 31
	addslt	r0, r0, r0, ror r0
	addslt	r15, r15, r15, ror r15
	addslt	r0, r0, r0, rrx

positive: addsgt instruction

	addsgt	r0, r0, 0
	addsgt	r15, r15, 0xff000000
	addsgt	r0, r0, r0
	addsgt	r15, r15, r15
	addsgt	r0, r0, r0, lsl 0
	addsgt	r15, r15, r15, lsl 31
	addsgt	r0, r0, r0, lsl r0
	addsgt	r15, r15, r15, lsl r15
	addsgt	r0, r0, r0, lsr 1
	addsgt	r15, r15, r15, lsr 32
	addsgt	r0, r0, r0, lsr r0
	addsgt	r15, r15, r15, asr r15
	addsgt	r0, r0, r0, asr 1
	addsgt	r15, r15, r15, asr 32
	addsgt	r0, r0, r0, asr r0
	addsgt	r15, r15, r15, asr r15
	addsgt	r0, r0, r0, ror 1
	addsgt	r15, r15, r15, ror 31
	addsgt	r0, r0, r0, ror r0
	addsgt	r15, r15, r15, ror r15
	addsgt	r0, r0, r0, rrx

positive: addsle instruction

	addsle	r0, r0, 0
	addsle	r15, r15, 0xff000000
	addsle	r0, r0, r0
	addsle	r15, r15, r15
	addsle	r0, r0, r0, lsl 0
	addsle	r15, r15, r15, lsl 31
	addsle	r0, r0, r0, lsl r0
	addsle	r15, r15, r15, lsl r15
	addsle	r0, r0, r0, lsr 1
	addsle	r15, r15, r15, lsr 32
	addsle	r0, r0, r0, lsr r0
	addsle	r15, r15, r15, asr r15
	addsle	r0, r0, r0, asr 1
	addsle	r15, r15, r15, asr 32
	addsle	r0, r0, r0, asr r0
	addsle	r15, r15, r15, asr r15
	addsle	r0, r0, r0, ror 1
	addsle	r15, r15, r15, ror 31
	addsle	r0, r0, r0, ror r0
	addsle	r15, r15, r15, ror r15
	addsle	r0, r0, r0, rrx

positive: addsal instruction

	addsal	r0, r0, 0
	addsal	r15, r15, 0xff000000
	addsal	r0, r0, r0
	addsal	r15, r15, r15
	addsal	r0, r0, r0, lsl 0
	addsal	r15, r15, r15, lsl 31
	addsal	r0, r0, r0, lsl r0
	addsal	r15, r15, r15, lsl r15
	addsal	r0, r0, r0, lsr 1
	addsal	r15, r15, r15, lsr 32
	addsal	r0, r0, r0, lsr r0
	addsal	r15, r15, r15, asr r15
	addsal	r0, r0, r0, asr 1
	addsal	r15, r15, r15, asr 32
	addsal	r0, r0, r0, asr r0
	addsal	r15, r15, r15, asr r15
	addsal	r0, r0, r0, ror 1
	addsal	r15, r15, r15, ror 31
	addsal	r0, r0, r0, ror r0
	addsal	r15, r15, r15, ror r15
	addsal	r0, r0, r0, rrx

positive: and instruction

	and	r0, r0, 0
	and	r15, r15, 0xff000000
	and	r0, r0, r0
	and	r15, r15, r15
	and	r0, r0, r0, lsl 0
	and	r15, r15, r15, lsl 31
	and	r0, r0, r0, lsl r0
	and	r15, r15, r15, lsl r15
	and	r0, r0, r0, lsr 1
	and	r15, r15, r15, lsr 32
	and	r0, r0, r0, lsr r0
	and	r15, r15, r15, asr r15
	and	r0, r0, r0, asr 1
	and	r15, r15, r15, asr 32
	and	r0, r0, r0, asr r0
	and	r15, r15, r15, asr r15
	and	r0, r0, r0, ror 1
	and	r15, r15, r15, ror 31
	and	r0, r0, r0, ror r0
	and	r15, r15, r15, ror r15
	and	r0, r0, r0, rrx

positive: andeq instruction

	andeq	r0, r0, 0
	andeq	r15, r15, 0xff000000
	andeq	r0, r0, r0
	andeq	r15, r15, r15
	andeq	r0, r0, r0, lsl 0
	andeq	r15, r15, r15, lsl 31
	andeq	r0, r0, r0, lsl r0
	andeq	r15, r15, r15, lsl r15
	andeq	r0, r0, r0, lsr 1
	andeq	r15, r15, r15, lsr 32
	andeq	r0, r0, r0, lsr r0
	andeq	r15, r15, r15, asr r15
	andeq	r0, r0, r0, asr 1
	andeq	r15, r15, r15, asr 32
	andeq	r0, r0, r0, asr r0
	andeq	r15, r15, r15, asr r15
	andeq	r0, r0, r0, ror 1
	andeq	r15, r15, r15, ror 31
	andeq	r0, r0, r0, ror r0
	andeq	r15, r15, r15, ror r15
	andeq	r0, r0, r0, rrx

positive: andne instruction

	andne	r0, r0, 0
	andne	r15, r15, 0xff000000
	andne	r0, r0, r0
	andne	r15, r15, r15
	andne	r0, r0, r0, lsl 0
	andne	r15, r15, r15, lsl 31
	andne	r0, r0, r0, lsl r0
	andne	r15, r15, r15, lsl r15
	andne	r0, r0, r0, lsr 1
	andne	r15, r15, r15, lsr 32
	andne	r0, r0, r0, lsr r0
	andne	r15, r15, r15, asr r15
	andne	r0, r0, r0, asr 1
	andne	r15, r15, r15, asr 32
	andne	r0, r0, r0, asr r0
	andne	r15, r15, r15, asr r15
	andne	r0, r0, r0, ror 1
	andne	r15, r15, r15, ror 31
	andne	r0, r0, r0, ror r0
	andne	r15, r15, r15, ror r15
	andne	r0, r0, r0, rrx

positive: andcs instruction

	andcs	r0, r0, 0
	andcs	r15, r15, 0xff000000
	andcs	r0, r0, r0
	andcs	r15, r15, r15
	andcs	r0, r0, r0, lsl 0
	andcs	r15, r15, r15, lsl 31
	andcs	r0, r0, r0, lsl r0
	andcs	r15, r15, r15, lsl r15
	andcs	r0, r0, r0, lsr 1
	andcs	r15, r15, r15, lsr 32
	andcs	r0, r0, r0, lsr r0
	andcs	r15, r15, r15, asr r15
	andcs	r0, r0, r0, asr 1
	andcs	r15, r15, r15, asr 32
	andcs	r0, r0, r0, asr r0
	andcs	r15, r15, r15, asr r15
	andcs	r0, r0, r0, ror 1
	andcs	r15, r15, r15, ror 31
	andcs	r0, r0, r0, ror r0
	andcs	r15, r15, r15, ror r15
	andcs	r0, r0, r0, rrx

positive: andhs instruction

	andhs	r0, r0, 0
	andhs	r15, r15, 0xff000000
	andhs	r0, r0, r0
	andhs	r15, r15, r15
	andhs	r0, r0, r0, lsl 0
	andhs	r15, r15, r15, lsl 31
	andhs	r0, r0, r0, lsl r0
	andhs	r15, r15, r15, lsl r15
	andhs	r0, r0, r0, lsr 1
	andhs	r15, r15, r15, lsr 32
	andhs	r0, r0, r0, lsr r0
	andhs	r15, r15, r15, asr r15
	andhs	r0, r0, r0, asr 1
	andhs	r15, r15, r15, asr 32
	andhs	r0, r0, r0, asr r0
	andhs	r15, r15, r15, asr r15
	andhs	r0, r0, r0, ror 1
	andhs	r15, r15, r15, ror 31
	andhs	r0, r0, r0, ror r0
	andhs	r15, r15, r15, ror r15
	andhs	r0, r0, r0, rrx

positive: andcc instruction

	andcc	r0, r0, 0
	andcc	r15, r15, 0xff000000
	andcc	r0, r0, r0
	andcc	r15, r15, r15
	andcc	r0, r0, r0, lsl 0
	andcc	r15, r15, r15, lsl 31
	andcc	r0, r0, r0, lsl r0
	andcc	r15, r15, r15, lsl r15
	andcc	r0, r0, r0, lsr 1
	andcc	r15, r15, r15, lsr 32
	andcc	r0, r0, r0, lsr r0
	andcc	r15, r15, r15, asr r15
	andcc	r0, r0, r0, asr 1
	andcc	r15, r15, r15, asr 32
	andcc	r0, r0, r0, asr r0
	andcc	r15, r15, r15, asr r15
	andcc	r0, r0, r0, ror 1
	andcc	r15, r15, r15, ror 31
	andcc	r0, r0, r0, ror r0
	andcc	r15, r15, r15, ror r15
	andcc	r0, r0, r0, rrx

positive: andlo instruction

	andlo	r0, r0, 0
	andlo	r15, r15, 0xff000000
	andlo	r0, r0, r0
	andlo	r15, r15, r15
	andlo	r0, r0, r0, lsl 0
	andlo	r15, r15, r15, lsl 31
	andlo	r0, r0, r0, lsl r0
	andlo	r15, r15, r15, lsl r15
	andlo	r0, r0, r0, lsr 1
	andlo	r15, r15, r15, lsr 32
	andlo	r0, r0, r0, lsr r0
	andlo	r15, r15, r15, asr r15
	andlo	r0, r0, r0, asr 1
	andlo	r15, r15, r15, asr 32
	andlo	r0, r0, r0, asr r0
	andlo	r15, r15, r15, asr r15
	andlo	r0, r0, r0, ror 1
	andlo	r15, r15, r15, ror 31
	andlo	r0, r0, r0, ror r0
	andlo	r15, r15, r15, ror r15
	andlo	r0, r0, r0, rrx

positive: andmi instruction

	andmi	r0, r0, 0
	andmi	r15, r15, 0xff000000
	andmi	r0, r0, r0
	andmi	r15, r15, r15
	andmi	r0, r0, r0, lsl 0
	andmi	r15, r15, r15, lsl 31
	andmi	r0, r0, r0, lsl r0
	andmi	r15, r15, r15, lsl r15
	andmi	r0, r0, r0, lsr 1
	andmi	r15, r15, r15, lsr 32
	andmi	r0, r0, r0, lsr r0
	andmi	r15, r15, r15, asr r15
	andmi	r0, r0, r0, asr 1
	andmi	r15, r15, r15, asr 32
	andmi	r0, r0, r0, asr r0
	andmi	r15, r15, r15, asr r15
	andmi	r0, r0, r0, ror 1
	andmi	r15, r15, r15, ror 31
	andmi	r0, r0, r0, ror r0
	andmi	r15, r15, r15, ror r15
	andmi	r0, r0, r0, rrx

positive: andpl instruction

	andpl	r0, r0, 0
	andpl	r15, r15, 0xff000000
	andpl	r0, r0, r0
	andpl	r15, r15, r15
	andpl	r0, r0, r0, lsl 0
	andpl	r15, r15, r15, lsl 31
	andpl	r0, r0, r0, lsl r0
	andpl	r15, r15, r15, lsl r15
	andpl	r0, r0, r0, lsr 1
	andpl	r15, r15, r15, lsr 32
	andpl	r0, r0, r0, lsr r0
	andpl	r15, r15, r15, asr r15
	andpl	r0, r0, r0, asr 1
	andpl	r15, r15, r15, asr 32
	andpl	r0, r0, r0, asr r0
	andpl	r15, r15, r15, asr r15
	andpl	r0, r0, r0, ror 1
	andpl	r15, r15, r15, ror 31
	andpl	r0, r0, r0, ror r0
	andpl	r15, r15, r15, ror r15
	andpl	r0, r0, r0, rrx

positive: andvs instruction

	andvs	r0, r0, 0
	andvs	r15, r15, 0xff000000
	andvs	r0, r0, r0
	andvs	r15, r15, r15
	andvs	r0, r0, r0, lsl 0
	andvs	r15, r15, r15, lsl 31
	andvs	r0, r0, r0, lsl r0
	andvs	r15, r15, r15, lsl r15
	andvs	r0, r0, r0, lsr 1
	andvs	r15, r15, r15, lsr 32
	andvs	r0, r0, r0, lsr r0
	andvs	r15, r15, r15, asr r15
	andvs	r0, r0, r0, asr 1
	andvs	r15, r15, r15, asr 32
	andvs	r0, r0, r0, asr r0
	andvs	r15, r15, r15, asr r15
	andvs	r0, r0, r0, ror 1
	andvs	r15, r15, r15, ror 31
	andvs	r0, r0, r0, ror r0
	andvs	r15, r15, r15, ror r15
	andvs	r0, r0, r0, rrx

positive: andvc instruction

	andvc	r0, r0, 0
	andvc	r15, r15, 0xff000000
	andvc	r0, r0, r0
	andvc	r15, r15, r15
	andvc	r0, r0, r0, lsl 0
	andvc	r15, r15, r15, lsl 31
	andvc	r0, r0, r0, lsl r0
	andvc	r15, r15, r15, lsl r15
	andvc	r0, r0, r0, lsr 1
	andvc	r15, r15, r15, lsr 32
	andvc	r0, r0, r0, lsr r0
	andvc	r15, r15, r15, asr r15
	andvc	r0, r0, r0, asr 1
	andvc	r15, r15, r15, asr 32
	andvc	r0, r0, r0, asr r0
	andvc	r15, r15, r15, asr r15
	andvc	r0, r0, r0, ror 1
	andvc	r15, r15, r15, ror 31
	andvc	r0, r0, r0, ror r0
	andvc	r15, r15, r15, ror r15
	andvc	r0, r0, r0, rrx

positive: andhi instruction

	andhi	r0, r0, 0
	andhi	r15, r15, 0xff000000
	andhi	r0, r0, r0
	andhi	r15, r15, r15
	andhi	r0, r0, r0, lsl 0
	andhi	r15, r15, r15, lsl 31
	andhi	r0, r0, r0, lsl r0
	andhi	r15, r15, r15, lsl r15
	andhi	r0, r0, r0, lsr 1
	andhi	r15, r15, r15, lsr 32
	andhi	r0, r0, r0, lsr r0
	andhi	r15, r15, r15, asr r15
	andhi	r0, r0, r0, asr 1
	andhi	r15, r15, r15, asr 32
	andhi	r0, r0, r0, asr r0
	andhi	r15, r15, r15, asr r15
	andhi	r0, r0, r0, ror 1
	andhi	r15, r15, r15, ror 31
	andhi	r0, r0, r0, ror r0
	andhi	r15, r15, r15, ror r15
	andhi	r0, r0, r0, rrx

positive: andls instruction

	andls	r0, r0, 0
	andls	r15, r15, 0xff000000
	andls	r0, r0, r0
	andls	r15, r15, r15
	andls	r0, r0, r0, lsl 0
	andls	r15, r15, r15, lsl 31
	andls	r0, r0, r0, lsl r0
	andls	r15, r15, r15, lsl r15
	andls	r0, r0, r0, lsr 1
	andls	r15, r15, r15, lsr 32
	andls	r0, r0, r0, lsr r0
	andls	r15, r15, r15, asr r15
	andls	r0, r0, r0, asr 1
	andls	r15, r15, r15, asr 32
	andls	r0, r0, r0, asr r0
	andls	r15, r15, r15, asr r15
	andls	r0, r0, r0, ror 1
	andls	r15, r15, r15, ror 31
	andls	r0, r0, r0, ror r0
	andls	r15, r15, r15, ror r15
	andls	r0, r0, r0, rrx

positive: andge instruction

	andge	r0, r0, 0
	andge	r15, r15, 0xff000000
	andge	r0, r0, r0
	andge	r15, r15, r15
	andge	r0, r0, r0, lsl 0
	andge	r15, r15, r15, lsl 31
	andge	r0, r0, r0, lsl r0
	andge	r15, r15, r15, lsl r15
	andge	r0, r0, r0, lsr 1
	andge	r15, r15, r15, lsr 32
	andge	r0, r0, r0, lsr r0
	andge	r15, r15, r15, asr r15
	andge	r0, r0, r0, asr 1
	andge	r15, r15, r15, asr 32
	andge	r0, r0, r0, asr r0
	andge	r15, r15, r15, asr r15
	andge	r0, r0, r0, ror 1
	andge	r15, r15, r15, ror 31
	andge	r0, r0, r0, ror r0
	andge	r15, r15, r15, ror r15
	andge	r0, r0, r0, rrx

positive: andlt instruction

	andlt	r0, r0, 0
	andlt	r15, r15, 0xff000000
	andlt	r0, r0, r0
	andlt	r15, r15, r15
	andlt	r0, r0, r0, lsl 0
	andlt	r15, r15, r15, lsl 31
	andlt	r0, r0, r0, lsl r0
	andlt	r15, r15, r15, lsl r15
	andlt	r0, r0, r0, lsr 1
	andlt	r15, r15, r15, lsr 32
	andlt	r0, r0, r0, lsr r0
	andlt	r15, r15, r15, asr r15
	andlt	r0, r0, r0, asr 1
	andlt	r15, r15, r15, asr 32
	andlt	r0, r0, r0, asr r0
	andlt	r15, r15, r15, asr r15
	andlt	r0, r0, r0, ror 1
	andlt	r15, r15, r15, ror 31
	andlt	r0, r0, r0, ror r0
	andlt	r15, r15, r15, ror r15
	andlt	r0, r0, r0, rrx

positive: andgt instruction

	andgt	r0, r0, 0
	andgt	r15, r15, 0xff000000
	andgt	r0, r0, r0
	andgt	r15, r15, r15
	andgt	r0, r0, r0, lsl 0
	andgt	r15, r15, r15, lsl 31
	andgt	r0, r0, r0, lsl r0
	andgt	r15, r15, r15, lsl r15
	andgt	r0, r0, r0, lsr 1
	andgt	r15, r15, r15, lsr 32
	andgt	r0, r0, r0, lsr r0
	andgt	r15, r15, r15, asr r15
	andgt	r0, r0, r0, asr 1
	andgt	r15, r15, r15, asr 32
	andgt	r0, r0, r0, asr r0
	andgt	r15, r15, r15, asr r15
	andgt	r0, r0, r0, ror 1
	andgt	r15, r15, r15, ror 31
	andgt	r0, r0, r0, ror r0
	andgt	r15, r15, r15, ror r15
	andgt	r0, r0, r0, rrx

positive: andle instruction

	andle	r0, r0, 0
	andle	r15, r15, 0xff000000
	andle	r0, r0, r0
	andle	r15, r15, r15
	andle	r0, r0, r0, lsl 0
	andle	r15, r15, r15, lsl 31
	andle	r0, r0, r0, lsl r0
	andle	r15, r15, r15, lsl r15
	andle	r0, r0, r0, lsr 1
	andle	r15, r15, r15, lsr 32
	andle	r0, r0, r0, lsr r0
	andle	r15, r15, r15, asr r15
	andle	r0, r0, r0, asr 1
	andle	r15, r15, r15, asr 32
	andle	r0, r0, r0, asr r0
	andle	r15, r15, r15, asr r15
	andle	r0, r0, r0, ror 1
	andle	r15, r15, r15, ror 31
	andle	r0, r0, r0, ror r0
	andle	r15, r15, r15, ror r15
	andle	r0, r0, r0, rrx

positive: andal instruction

	andal	r0, r0, 0
	andal	r15, r15, 0xff000000
	andal	r0, r0, r0
	andal	r15, r15, r15
	andal	r0, r0, r0, lsl 0
	andal	r15, r15, r15, lsl 31
	andal	r0, r0, r0, lsl r0
	andal	r15, r15, r15, lsl r15
	andal	r0, r0, r0, lsr 1
	andal	r15, r15, r15, lsr 32
	andal	r0, r0, r0, lsr r0
	andal	r15, r15, r15, asr r15
	andal	r0, r0, r0, asr 1
	andal	r15, r15, r15, asr 32
	andal	r0, r0, r0, asr r0
	andal	r15, r15, r15, asr r15
	andal	r0, r0, r0, ror 1
	andal	r15, r15, r15, ror 31
	andal	r0, r0, r0, ror r0
	andal	r15, r15, r15, ror r15
	andal	r0, r0, r0, rrx

positive: ands instruction

	ands	r0, r0, 0
	ands	r15, r15, 0xff000000
	ands	r0, r0, r0
	ands	r15, r15, r15
	ands	r0, r0, r0, lsl 0
	ands	r15, r15, r15, lsl 31
	ands	r0, r0, r0, lsl r0
	ands	r15, r15, r15, lsl r15
	ands	r0, r0, r0, lsr 1
	ands	r15, r15, r15, lsr 32
	ands	r0, r0, r0, lsr r0
	ands	r15, r15, r15, asr r15
	ands	r0, r0, r0, asr 1
	ands	r15, r15, r15, asr 32
	ands	r0, r0, r0, asr r0
	ands	r15, r15, r15, asr r15
	ands	r0, r0, r0, ror 1
	ands	r15, r15, r15, ror 31
	ands	r0, r0, r0, ror r0
	ands	r15, r15, r15, ror r15
	ands	r0, r0, r0, rrx

positive: andseq instruction

	andseq	r0, r0, 0
	andseq	r15, r15, 0xff000000
	andseq	r0, r0, r0
	andseq	r15, r15, r15
	andseq	r0, r0, r0, lsl 0
	andseq	r15, r15, r15, lsl 31
	andseq	r0, r0, r0, lsl r0
	andseq	r15, r15, r15, lsl r15
	andseq	r0, r0, r0, lsr 1
	andseq	r15, r15, r15, lsr 32
	andseq	r0, r0, r0, lsr r0
	andseq	r15, r15, r15, asr r15
	andseq	r0, r0, r0, asr 1
	andseq	r15, r15, r15, asr 32
	andseq	r0, r0, r0, asr r0
	andseq	r15, r15, r15, asr r15
	andseq	r0, r0, r0, ror 1
	andseq	r15, r15, r15, ror 31
	andseq	r0, r0, r0, ror r0
	andseq	r15, r15, r15, ror r15
	andseq	r0, r0, r0, rrx

positive: andsne instruction

	andsne	r0, r0, 0
	andsne	r15, r15, 0xff000000
	andsne	r0, r0, r0
	andsne	r15, r15, r15
	andsne	r0, r0, r0, lsl 0
	andsne	r15, r15, r15, lsl 31
	andsne	r0, r0, r0, lsl r0
	andsne	r15, r15, r15, lsl r15
	andsne	r0, r0, r0, lsr 1
	andsne	r15, r15, r15, lsr 32
	andsne	r0, r0, r0, lsr r0
	andsne	r15, r15, r15, asr r15
	andsne	r0, r0, r0, asr 1
	andsne	r15, r15, r15, asr 32
	andsne	r0, r0, r0, asr r0
	andsne	r15, r15, r15, asr r15
	andsne	r0, r0, r0, ror 1
	andsne	r15, r15, r15, ror 31
	andsne	r0, r0, r0, ror r0
	andsne	r15, r15, r15, ror r15
	andsne	r0, r0, r0, rrx

positive: andscs instruction

	andscs	r0, r0, 0
	andscs	r15, r15, 0xff000000
	andscs	r0, r0, r0
	andscs	r15, r15, r15
	andscs	r0, r0, r0, lsl 0
	andscs	r15, r15, r15, lsl 31
	andscs	r0, r0, r0, lsl r0
	andscs	r15, r15, r15, lsl r15
	andscs	r0, r0, r0, lsr 1
	andscs	r15, r15, r15, lsr 32
	andscs	r0, r0, r0, lsr r0
	andscs	r15, r15, r15, asr r15
	andscs	r0, r0, r0, asr 1
	andscs	r15, r15, r15, asr 32
	andscs	r0, r0, r0, asr r0
	andscs	r15, r15, r15, asr r15
	andscs	r0, r0, r0, ror 1
	andscs	r15, r15, r15, ror 31
	andscs	r0, r0, r0, ror r0
	andscs	r15, r15, r15, ror r15
	andscs	r0, r0, r0, rrx

positive: andshs instruction

	andshs	r0, r0, 0
	andshs	r15, r15, 0xff000000
	andshs	r0, r0, r0
	andshs	r15, r15, r15
	andshs	r0, r0, r0, lsl 0
	andshs	r15, r15, r15, lsl 31
	andshs	r0, r0, r0, lsl r0
	andshs	r15, r15, r15, lsl r15
	andshs	r0, r0, r0, lsr 1
	andshs	r15, r15, r15, lsr 32
	andshs	r0, r0, r0, lsr r0
	andshs	r15, r15, r15, asr r15
	andshs	r0, r0, r0, asr 1
	andshs	r15, r15, r15, asr 32
	andshs	r0, r0, r0, asr r0
	andshs	r15, r15, r15, asr r15
	andshs	r0, r0, r0, ror 1
	andshs	r15, r15, r15, ror 31
	andshs	r0, r0, r0, ror r0
	andshs	r15, r15, r15, ror r15
	andshs	r0, r0, r0, rrx

positive: andscc instruction

	andscc	r0, r0, 0
	andscc	r15, r15, 0xff000000
	andscc	r0, r0, r0
	andscc	r15, r15, r15
	andscc	r0, r0, r0, lsl 0
	andscc	r15, r15, r15, lsl 31
	andscc	r0, r0, r0, lsl r0
	andscc	r15, r15, r15, lsl r15
	andscc	r0, r0, r0, lsr 1
	andscc	r15, r15, r15, lsr 32
	andscc	r0, r0, r0, lsr r0
	andscc	r15, r15, r15, asr r15
	andscc	r0, r0, r0, asr 1
	andscc	r15, r15, r15, asr 32
	andscc	r0, r0, r0, asr r0
	andscc	r15, r15, r15, asr r15
	andscc	r0, r0, r0, ror 1
	andscc	r15, r15, r15, ror 31
	andscc	r0, r0, r0, ror r0
	andscc	r15, r15, r15, ror r15
	andscc	r0, r0, r0, rrx

positive: andslo instruction

	andslo	r0, r0, 0
	andslo	r15, r15, 0xff000000
	andslo	r0, r0, r0
	andslo	r15, r15, r15
	andslo	r0, r0, r0, lsl 0
	andslo	r15, r15, r15, lsl 31
	andslo	r0, r0, r0, lsl r0
	andslo	r15, r15, r15, lsl r15
	andslo	r0, r0, r0, lsr 1
	andslo	r15, r15, r15, lsr 32
	andslo	r0, r0, r0, lsr r0
	andslo	r15, r15, r15, asr r15
	andslo	r0, r0, r0, asr 1
	andslo	r15, r15, r15, asr 32
	andslo	r0, r0, r0, asr r0
	andslo	r15, r15, r15, asr r15
	andslo	r0, r0, r0, ror 1
	andslo	r15, r15, r15, ror 31
	andslo	r0, r0, r0, ror r0
	andslo	r15, r15, r15, ror r15
	andslo	r0, r0, r0, rrx

positive: andsmi instruction

	andsmi	r0, r0, 0
	andsmi	r15, r15, 0xff000000
	andsmi	r0, r0, r0
	andsmi	r15, r15, r15
	andsmi	r0, r0, r0, lsl 0
	andsmi	r15, r15, r15, lsl 31
	andsmi	r0, r0, r0, lsl r0
	andsmi	r15, r15, r15, lsl r15
	andsmi	r0, r0, r0, lsr 1
	andsmi	r15, r15, r15, lsr 32
	andsmi	r0, r0, r0, lsr r0
	andsmi	r15, r15, r15, asr r15
	andsmi	r0, r0, r0, asr 1
	andsmi	r15, r15, r15, asr 32
	andsmi	r0, r0, r0, asr r0
	andsmi	r15, r15, r15, asr r15
	andsmi	r0, r0, r0, ror 1
	andsmi	r15, r15, r15, ror 31
	andsmi	r0, r0, r0, ror r0
	andsmi	r15, r15, r15, ror r15
	andsmi	r0, r0, r0, rrx

positive: andspl instruction

	andspl	r0, r0, 0
	andspl	r15, r15, 0xff000000
	andspl	r0, r0, r0
	andspl	r15, r15, r15
	andspl	r0, r0, r0, lsl 0
	andspl	r15, r15, r15, lsl 31
	andspl	r0, r0, r0, lsl r0
	andspl	r15, r15, r15, lsl r15
	andspl	r0, r0, r0, lsr 1
	andspl	r15, r15, r15, lsr 32
	andspl	r0, r0, r0, lsr r0
	andspl	r15, r15, r15, asr r15
	andspl	r0, r0, r0, asr 1
	andspl	r15, r15, r15, asr 32
	andspl	r0, r0, r0, asr r0
	andspl	r15, r15, r15, asr r15
	andspl	r0, r0, r0, ror 1
	andspl	r15, r15, r15, ror 31
	andspl	r0, r0, r0, ror r0
	andspl	r15, r15, r15, ror r15
	andspl	r0, r0, r0, rrx

positive: andsvs instruction

	andsvs	r0, r0, 0
	andsvs	r15, r15, 0xff000000
	andsvs	r0, r0, r0
	andsvs	r15, r15, r15
	andsvs	r0, r0, r0, lsl 0
	andsvs	r15, r15, r15, lsl 31
	andsvs	r0, r0, r0, lsl r0
	andsvs	r15, r15, r15, lsl r15
	andsvs	r0, r0, r0, lsr 1
	andsvs	r15, r15, r15, lsr 32
	andsvs	r0, r0, r0, lsr r0
	andsvs	r15, r15, r15, asr r15
	andsvs	r0, r0, r0, asr 1
	andsvs	r15, r15, r15, asr 32
	andsvs	r0, r0, r0, asr r0
	andsvs	r15, r15, r15, asr r15
	andsvs	r0, r0, r0, ror 1
	andsvs	r15, r15, r15, ror 31
	andsvs	r0, r0, r0, ror r0
	andsvs	r15, r15, r15, ror r15
	andsvs	r0, r0, r0, rrx

positive: andsvc instruction

	andsvc	r0, r0, 0
	andsvc	r15, r15, 0xff000000
	andsvc	r0, r0, r0
	andsvc	r15, r15, r15
	andsvc	r0, r0, r0, lsl 0
	andsvc	r15, r15, r15, lsl 31
	andsvc	r0, r0, r0, lsl r0
	andsvc	r15, r15, r15, lsl r15
	andsvc	r0, r0, r0, lsr 1
	andsvc	r15, r15, r15, lsr 32
	andsvc	r0, r0, r0, lsr r0
	andsvc	r15, r15, r15, asr r15
	andsvc	r0, r0, r0, asr 1
	andsvc	r15, r15, r15, asr 32
	andsvc	r0, r0, r0, asr r0
	andsvc	r15, r15, r15, asr r15
	andsvc	r0, r0, r0, ror 1
	andsvc	r15, r15, r15, ror 31
	andsvc	r0, r0, r0, ror r0
	andsvc	r15, r15, r15, ror r15
	andsvc	r0, r0, r0, rrx

positive: andshi instruction

	andshi	r0, r0, 0
	andshi	r15, r15, 0xff000000
	andshi	r0, r0, r0
	andshi	r15, r15, r15
	andshi	r0, r0, r0, lsl 0
	andshi	r15, r15, r15, lsl 31
	andshi	r0, r0, r0, lsl r0
	andshi	r15, r15, r15, lsl r15
	andshi	r0, r0, r0, lsr 1
	andshi	r15, r15, r15, lsr 32
	andshi	r0, r0, r0, lsr r0
	andshi	r15, r15, r15, asr r15
	andshi	r0, r0, r0, asr 1
	andshi	r15, r15, r15, asr 32
	andshi	r0, r0, r0, asr r0
	andshi	r15, r15, r15, asr r15
	andshi	r0, r0, r0, ror 1
	andshi	r15, r15, r15, ror 31
	andshi	r0, r0, r0, ror r0
	andshi	r15, r15, r15, ror r15
	andshi	r0, r0, r0, rrx

positive: andsls instruction

	andsls	r0, r0, 0
	andsls	r15, r15, 0xff000000
	andsls	r0, r0, r0
	andsls	r15, r15, r15
	andsls	r0, r0, r0, lsl 0
	andsls	r15, r15, r15, lsl 31
	andsls	r0, r0, r0, lsl r0
	andsls	r15, r15, r15, lsl r15
	andsls	r0, r0, r0, lsr 1
	andsls	r15, r15, r15, lsr 32
	andsls	r0, r0, r0, lsr r0
	andsls	r15, r15, r15, asr r15
	andsls	r0, r0, r0, asr 1
	andsls	r15, r15, r15, asr 32
	andsls	r0, r0, r0, asr r0
	andsls	r15, r15, r15, asr r15
	andsls	r0, r0, r0, ror 1
	andsls	r15, r15, r15, ror 31
	andsls	r0, r0, r0, ror r0
	andsls	r15, r15, r15, ror r15
	andsls	r0, r0, r0, rrx

positive: andsge instruction

	andsge	r0, r0, 0
	andsge	r15, r15, 0xff000000
	andsge	r0, r0, r0
	andsge	r15, r15, r15
	andsge	r0, r0, r0, lsl 0
	andsge	r15, r15, r15, lsl 31
	andsge	r0, r0, r0, lsl r0
	andsge	r15, r15, r15, lsl r15
	andsge	r0, r0, r0, lsr 1
	andsge	r15, r15, r15, lsr 32
	andsge	r0, r0, r0, lsr r0
	andsge	r15, r15, r15, asr r15
	andsge	r0, r0, r0, asr 1
	andsge	r15, r15, r15, asr 32
	andsge	r0, r0, r0, asr r0
	andsge	r15, r15, r15, asr r15
	andsge	r0, r0, r0, ror 1
	andsge	r15, r15, r15, ror 31
	andsge	r0, r0, r0, ror r0
	andsge	r15, r15, r15, ror r15
	andsge	r0, r0, r0, rrx

positive: andslt instruction

	andslt	r0, r0, 0
	andslt	r15, r15, 0xff000000
	andslt	r0, r0, r0
	andslt	r15, r15, r15
	andslt	r0, r0, r0, lsl 0
	andslt	r15, r15, r15, lsl 31
	andslt	r0, r0, r0, lsl r0
	andslt	r15, r15, r15, lsl r15
	andslt	r0, r0, r0, lsr 1
	andslt	r15, r15, r15, lsr 32
	andslt	r0, r0, r0, lsr r0
	andslt	r15, r15, r15, asr r15
	andslt	r0, r0, r0, asr 1
	andslt	r15, r15, r15, asr 32
	andslt	r0, r0, r0, asr r0
	andslt	r15, r15, r15, asr r15
	andslt	r0, r0, r0, ror 1
	andslt	r15, r15, r15, ror 31
	andslt	r0, r0, r0, ror r0
	andslt	r15, r15, r15, ror r15
	andslt	r0, r0, r0, rrx

positive: andsgt instruction

	andsgt	r0, r0, 0
	andsgt	r15, r15, 0xff000000
	andsgt	r0, r0, r0
	andsgt	r15, r15, r15
	andsgt	r0, r0, r0, lsl 0
	andsgt	r15, r15, r15, lsl 31
	andsgt	r0, r0, r0, lsl r0
	andsgt	r15, r15, r15, lsl r15
	andsgt	r0, r0, r0, lsr 1
	andsgt	r15, r15, r15, lsr 32
	andsgt	r0, r0, r0, lsr r0
	andsgt	r15, r15, r15, asr r15
	andsgt	r0, r0, r0, asr 1
	andsgt	r15, r15, r15, asr 32
	andsgt	r0, r0, r0, asr r0
	andsgt	r15, r15, r15, asr r15
	andsgt	r0, r0, r0, ror 1
	andsgt	r15, r15, r15, ror 31
	andsgt	r0, r0, r0, ror r0
	andsgt	r15, r15, r15, ror r15
	andsgt	r0, r0, r0, rrx

positive: andsle instruction

	andsle	r0, r0, 0
	andsle	r15, r15, 0xff000000
	andsle	r0, r0, r0
	andsle	r15, r15, r15
	andsle	r0, r0, r0, lsl 0
	andsle	r15, r15, r15, lsl 31
	andsle	r0, r0, r0, lsl r0
	andsle	r15, r15, r15, lsl r15
	andsle	r0, r0, r0, lsr 1
	andsle	r15, r15, r15, lsr 32
	andsle	r0, r0, r0, lsr r0
	andsle	r15, r15, r15, asr r15
	andsle	r0, r0, r0, asr 1
	andsle	r15, r15, r15, asr 32
	andsle	r0, r0, r0, asr r0
	andsle	r15, r15, r15, asr r15
	andsle	r0, r0, r0, ror 1
	andsle	r15, r15, r15, ror 31
	andsle	r0, r0, r0, ror r0
	andsle	r15, r15, r15, ror r15
	andsle	r0, r0, r0, rrx

positive: andsal instruction

	andsal	r0, r0, 0
	andsal	r15, r15, 0xff000000
	andsal	r0, r0, r0
	andsal	r15, r15, r15
	andsal	r0, r0, r0, lsl 0
	andsal	r15, r15, r15, lsl 31
	andsal	r0, r0, r0, lsl r0
	andsal	r15, r15, r15, lsl r15
	andsal	r0, r0, r0, lsr 1
	andsal	r15, r15, r15, lsr 32
	andsal	r0, r0, r0, lsr r0
	andsal	r15, r15, r15, asr r15
	andsal	r0, r0, r0, asr 1
	andsal	r15, r15, r15, asr 32
	andsal	r0, r0, r0, asr r0
	andsal	r15, r15, r15, asr r15
	andsal	r0, r0, r0, ror 1
	andsal	r15, r15, r15, ror 31
	andsal	r0, r0, r0, ror r0
	andsal	r15, r15, r15, ror r15
	andsal	r0, r0, r0, rrx

positive: b instruction

	b	-33554432
	b	+33554428

positive: beq instruction

	beq	-33554432
	beq	+33554428

positive: bne instruction

	bne	-33554432
	bne	+33554428

positive: bcs instruction

	bcs	-33554432
	bcs	+33554428

positive: bhs instruction

	bhs	-33554432
	bhs	+33554428

positive: bcc instruction

	bcc	-33554432
	bcc	+33554428

positive: blo instruction

	blo	-33554432
	blo	+33554428

positive: bmi instruction

	bmi	-33554432
	bmi	+33554428

positive: bpl instruction

	bpl	-33554432
	bpl	+33554428

positive: bvs instruction

	bvs	-33554432
	bvs	+33554428

positive: bvc instruction

	bvc	-33554432
	bvc	+33554428

positive: bhi instruction

	bhi	-33554432
	bhi	+33554428

positive: bls instruction

	bls	-33554432
	bls	+33554428

positive: bge instruction

	bge	-33554432
	bge	+33554428

positive: blt instruction

	blt	-33554432
	blt	+33554428

positive: bgt instruction

	bgt	-33554432
	bgt	+33554428

positive: ble instruction

	ble	-33554432
	ble	+33554428

positive: bal instruction

	bal	-33554432
	bal	+33554428

positive: bl instruction

	bl	-33554432
	bl	+33554428

positive: bleq instruction

	bleq	-33554432
	bleq	+33554428

positive: blne instruction

	blne	-33554432
	blne	+33554428

positive: blcs instruction

	blcs	-33554432
	blcs	+33554428

positive: blhs instruction

	blhs	-33554432
	blhs	+33554428

positive: blcc instruction

	blcc	-33554432
	blcc	+33554428

positive: bllo instruction

	bllo	-33554432
	bllo	+33554428

positive: blmi instruction

	blmi	-33554432
	blmi	+33554428

positive: blpl instruction

	blpl	-33554432
	blpl	+33554428

positive: blvs instruction

	blvs	-33554432
	blvs	+33554428

positive: blvc instruction

	blvc	-33554432
	blvc	+33554428

positive: blhi instruction

	blhi	-33554432
	blhi	+33554428

positive: blls instruction

	blls	-33554432
	blls	+33554428

positive: blge instruction

	blge	-33554432
	blge	+33554428

positive: bllt instruction

	bllt	-33554432
	bllt	+33554428

positive: blgt instruction

	blgt	-33554432
	blgt	+33554428

positive: blle instruction

	blle	-33554432
	blle	+33554428

positive: blal instruction

	blal	-33554432
	blal	+33554428

positive: bic instruction

	bic	r0, r0, 0
	bic	r15, r15, 0xff000000
	bic	r0, r0, r0
	bic	r15, r15, r15
	bic	r0, r0, r0, lsl 0
	bic	r15, r15, r15, lsl 31
	bic	r0, r0, r0, lsl r0
	bic	r15, r15, r15, lsl r15
	bic	r0, r0, r0, lsr 1
	bic	r15, r15, r15, lsr 32
	bic	r0, r0, r0, lsr r0
	bic	r15, r15, r15, asr r15
	bic	r0, r0, r0, asr 1
	bic	r15, r15, r15, asr 32
	bic	r0, r0, r0, asr r0
	bic	r15, r15, r15, asr r15
	bic	r0, r0, r0, ror 1
	bic	r15, r15, r15, ror 31
	bic	r0, r0, r0, ror r0
	bic	r15, r15, r15, ror r15
	bic	r0, r0, r0, rrx

positive: biceq instruction

	biceq	r0, r0, 0
	biceq	r15, r15, 0xff000000
	biceq	r0, r0, r0
	biceq	r15, r15, r15
	biceq	r0, r0, r0, lsl 0
	biceq	r15, r15, r15, lsl 31
	biceq	r0, r0, r0, lsl r0
	biceq	r15, r15, r15, lsl r15
	biceq	r0, r0, r0, lsr 1
	biceq	r15, r15, r15, lsr 32
	biceq	r0, r0, r0, lsr r0
	biceq	r15, r15, r15, asr r15
	biceq	r0, r0, r0, asr 1
	biceq	r15, r15, r15, asr 32
	biceq	r0, r0, r0, asr r0
	biceq	r15, r15, r15, asr r15
	biceq	r0, r0, r0, ror 1
	biceq	r15, r15, r15, ror 31
	biceq	r0, r0, r0, ror r0
	biceq	r15, r15, r15, ror r15
	biceq	r0, r0, r0, rrx

positive: bicne instruction

	bicne	r0, r0, 0
	bicne	r15, r15, 0xff000000
	bicne	r0, r0, r0
	bicne	r15, r15, r15
	bicne	r0, r0, r0, lsl 0
	bicne	r15, r15, r15, lsl 31
	bicne	r0, r0, r0, lsl r0
	bicne	r15, r15, r15, lsl r15
	bicne	r0, r0, r0, lsr 1
	bicne	r15, r15, r15, lsr 32
	bicne	r0, r0, r0, lsr r0
	bicne	r15, r15, r15, asr r15
	bicne	r0, r0, r0, asr 1
	bicne	r15, r15, r15, asr 32
	bicne	r0, r0, r0, asr r0
	bicne	r15, r15, r15, asr r15
	bicne	r0, r0, r0, ror 1
	bicne	r15, r15, r15, ror 31
	bicne	r0, r0, r0, ror r0
	bicne	r15, r15, r15, ror r15
	bicne	r0, r0, r0, rrx

positive: biccs instruction

	biccs	r0, r0, 0
	biccs	r15, r15, 0xff000000
	biccs	r0, r0, r0
	biccs	r15, r15, r15
	biccs	r0, r0, r0, lsl 0
	biccs	r15, r15, r15, lsl 31
	biccs	r0, r0, r0, lsl r0
	biccs	r15, r15, r15, lsl r15
	biccs	r0, r0, r0, lsr 1
	biccs	r15, r15, r15, lsr 32
	biccs	r0, r0, r0, lsr r0
	biccs	r15, r15, r15, asr r15
	biccs	r0, r0, r0, asr 1
	biccs	r15, r15, r15, asr 32
	biccs	r0, r0, r0, asr r0
	biccs	r15, r15, r15, asr r15
	biccs	r0, r0, r0, ror 1
	biccs	r15, r15, r15, ror 31
	biccs	r0, r0, r0, ror r0
	biccs	r15, r15, r15, ror r15
	biccs	r0, r0, r0, rrx

positive: bichs instruction

	bichs	r0, r0, 0
	bichs	r15, r15, 0xff000000
	bichs	r0, r0, r0
	bichs	r15, r15, r15
	bichs	r0, r0, r0, lsl 0
	bichs	r15, r15, r15, lsl 31
	bichs	r0, r0, r0, lsl r0
	bichs	r15, r15, r15, lsl r15
	bichs	r0, r0, r0, lsr 1
	bichs	r15, r15, r15, lsr 32
	bichs	r0, r0, r0, lsr r0
	bichs	r15, r15, r15, asr r15
	bichs	r0, r0, r0, asr 1
	bichs	r15, r15, r15, asr 32
	bichs	r0, r0, r0, asr r0
	bichs	r15, r15, r15, asr r15
	bichs	r0, r0, r0, ror 1
	bichs	r15, r15, r15, ror 31
	bichs	r0, r0, r0, ror r0
	bichs	r15, r15, r15, ror r15
	bichs	r0, r0, r0, rrx

positive: biccc instruction

	biccc	r0, r0, 0
	biccc	r15, r15, 0xff000000
	biccc	r0, r0, r0
	biccc	r15, r15, r15
	biccc	r0, r0, r0, lsl 0
	biccc	r15, r15, r15, lsl 31
	biccc	r0, r0, r0, lsl r0
	biccc	r15, r15, r15, lsl r15
	biccc	r0, r0, r0, lsr 1
	biccc	r15, r15, r15, lsr 32
	biccc	r0, r0, r0, lsr r0
	biccc	r15, r15, r15, asr r15
	biccc	r0, r0, r0, asr 1
	biccc	r15, r15, r15, asr 32
	biccc	r0, r0, r0, asr r0
	biccc	r15, r15, r15, asr r15
	biccc	r0, r0, r0, ror 1
	biccc	r15, r15, r15, ror 31
	biccc	r0, r0, r0, ror r0
	biccc	r15, r15, r15, ror r15
	biccc	r0, r0, r0, rrx

positive: biclo instruction

	biclo	r0, r0, 0
	biclo	r15, r15, 0xff000000
	biclo	r0, r0, r0
	biclo	r15, r15, r15
	biclo	r0, r0, r0, lsl 0
	biclo	r15, r15, r15, lsl 31
	biclo	r0, r0, r0, lsl r0
	biclo	r15, r15, r15, lsl r15
	biclo	r0, r0, r0, lsr 1
	biclo	r15, r15, r15, lsr 32
	biclo	r0, r0, r0, lsr r0
	biclo	r15, r15, r15, asr r15
	biclo	r0, r0, r0, asr 1
	biclo	r15, r15, r15, asr 32
	biclo	r0, r0, r0, asr r0
	biclo	r15, r15, r15, asr r15
	biclo	r0, r0, r0, ror 1
	biclo	r15, r15, r15, ror 31
	biclo	r0, r0, r0, ror r0
	biclo	r15, r15, r15, ror r15
	biclo	r0, r0, r0, rrx

positive: bicmi instruction

	bicmi	r0, r0, 0
	bicmi	r15, r15, 0xff000000
	bicmi	r0, r0, r0
	bicmi	r15, r15, r15
	bicmi	r0, r0, r0, lsl 0
	bicmi	r15, r15, r15, lsl 31
	bicmi	r0, r0, r0, lsl r0
	bicmi	r15, r15, r15, lsl r15
	bicmi	r0, r0, r0, lsr 1
	bicmi	r15, r15, r15, lsr 32
	bicmi	r0, r0, r0, lsr r0
	bicmi	r15, r15, r15, asr r15
	bicmi	r0, r0, r0, asr 1
	bicmi	r15, r15, r15, asr 32
	bicmi	r0, r0, r0, asr r0
	bicmi	r15, r15, r15, asr r15
	bicmi	r0, r0, r0, ror 1
	bicmi	r15, r15, r15, ror 31
	bicmi	r0, r0, r0, ror r0
	bicmi	r15, r15, r15, ror r15
	bicmi	r0, r0, r0, rrx

positive: bicpl instruction

	bicpl	r0, r0, 0
	bicpl	r15, r15, 0xff000000
	bicpl	r0, r0, r0
	bicpl	r15, r15, r15
	bicpl	r0, r0, r0, lsl 0
	bicpl	r15, r15, r15, lsl 31
	bicpl	r0, r0, r0, lsl r0
	bicpl	r15, r15, r15, lsl r15
	bicpl	r0, r0, r0, lsr 1
	bicpl	r15, r15, r15, lsr 32
	bicpl	r0, r0, r0, lsr r0
	bicpl	r15, r15, r15, asr r15
	bicpl	r0, r0, r0, asr 1
	bicpl	r15, r15, r15, asr 32
	bicpl	r0, r0, r0, asr r0
	bicpl	r15, r15, r15, asr r15
	bicpl	r0, r0, r0, ror 1
	bicpl	r15, r15, r15, ror 31
	bicpl	r0, r0, r0, ror r0
	bicpl	r15, r15, r15, ror r15
	bicpl	r0, r0, r0, rrx

positive: bicvs instruction

	bicvs	r0, r0, 0
	bicvs	r15, r15, 0xff000000
	bicvs	r0, r0, r0
	bicvs	r15, r15, r15
	bicvs	r0, r0, r0, lsl 0
	bicvs	r15, r15, r15, lsl 31
	bicvs	r0, r0, r0, lsl r0
	bicvs	r15, r15, r15, lsl r15
	bicvs	r0, r0, r0, lsr 1
	bicvs	r15, r15, r15, lsr 32
	bicvs	r0, r0, r0, lsr r0
	bicvs	r15, r15, r15, asr r15
	bicvs	r0, r0, r0, asr 1
	bicvs	r15, r15, r15, asr 32
	bicvs	r0, r0, r0, asr r0
	bicvs	r15, r15, r15, asr r15
	bicvs	r0, r0, r0, ror 1
	bicvs	r15, r15, r15, ror 31
	bicvs	r0, r0, r0, ror r0
	bicvs	r15, r15, r15, ror r15
	bicvs	r0, r0, r0, rrx

positive: bicvc instruction

	bicvc	r0, r0, 0
	bicvc	r15, r15, 0xff000000
	bicvc	r0, r0, r0
	bicvc	r15, r15, r15
	bicvc	r0, r0, r0, lsl 0
	bicvc	r15, r15, r15, lsl 31
	bicvc	r0, r0, r0, lsl r0
	bicvc	r15, r15, r15, lsl r15
	bicvc	r0, r0, r0, lsr 1
	bicvc	r15, r15, r15, lsr 32
	bicvc	r0, r0, r0, lsr r0
	bicvc	r15, r15, r15, asr r15
	bicvc	r0, r0, r0, asr 1
	bicvc	r15, r15, r15, asr 32
	bicvc	r0, r0, r0, asr r0
	bicvc	r15, r15, r15, asr r15
	bicvc	r0, r0, r0, ror 1
	bicvc	r15, r15, r15, ror 31
	bicvc	r0, r0, r0, ror r0
	bicvc	r15, r15, r15, ror r15
	bicvc	r0, r0, r0, rrx

positive: bichi instruction

	bichi	r0, r0, 0
	bichi	r15, r15, 0xff000000
	bichi	r0, r0, r0
	bichi	r15, r15, r15
	bichi	r0, r0, r0, lsl 0
	bichi	r15, r15, r15, lsl 31
	bichi	r0, r0, r0, lsl r0
	bichi	r15, r15, r15, lsl r15
	bichi	r0, r0, r0, lsr 1
	bichi	r15, r15, r15, lsr 32
	bichi	r0, r0, r0, lsr r0
	bichi	r15, r15, r15, asr r15
	bichi	r0, r0, r0, asr 1
	bichi	r15, r15, r15, asr 32
	bichi	r0, r0, r0, asr r0
	bichi	r15, r15, r15, asr r15
	bichi	r0, r0, r0, ror 1
	bichi	r15, r15, r15, ror 31
	bichi	r0, r0, r0, ror r0
	bichi	r15, r15, r15, ror r15
	bichi	r0, r0, r0, rrx

positive: bicls instruction

	bicls	r0, r0, 0
	bicls	r15, r15, 0xff000000
	bicls	r0, r0, r0
	bicls	r15, r15, r15
	bicls	r0, r0, r0, lsl 0
	bicls	r15, r15, r15, lsl 31
	bicls	r0, r0, r0, lsl r0
	bicls	r15, r15, r15, lsl r15
	bicls	r0, r0, r0, lsr 1
	bicls	r15, r15, r15, lsr 32
	bicls	r0, r0, r0, lsr r0
	bicls	r15, r15, r15, asr r15
	bicls	r0, r0, r0, asr 1
	bicls	r15, r15, r15, asr 32
	bicls	r0, r0, r0, asr r0
	bicls	r15, r15, r15, asr r15
	bicls	r0, r0, r0, ror 1
	bicls	r15, r15, r15, ror 31
	bicls	r0, r0, r0, ror r0
	bicls	r15, r15, r15, ror r15
	bicls	r0, r0, r0, rrx

positive: bicge instruction

	bicge	r0, r0, 0
	bicge	r15, r15, 0xff000000
	bicge	r0, r0, r0
	bicge	r15, r15, r15
	bicge	r0, r0, r0, lsl 0
	bicge	r15, r15, r15, lsl 31
	bicge	r0, r0, r0, lsl r0
	bicge	r15, r15, r15, lsl r15
	bicge	r0, r0, r0, lsr 1
	bicge	r15, r15, r15, lsr 32
	bicge	r0, r0, r0, lsr r0
	bicge	r15, r15, r15, asr r15
	bicge	r0, r0, r0, asr 1
	bicge	r15, r15, r15, asr 32
	bicge	r0, r0, r0, asr r0
	bicge	r15, r15, r15, asr r15
	bicge	r0, r0, r0, ror 1
	bicge	r15, r15, r15, ror 31
	bicge	r0, r0, r0, ror r0
	bicge	r15, r15, r15, ror r15
	bicge	r0, r0, r0, rrx

positive: biclt instruction

	biclt	r0, r0, 0
	biclt	r15, r15, 0xff000000
	biclt	r0, r0, r0
	biclt	r15, r15, r15
	biclt	r0, r0, r0, lsl 0
	biclt	r15, r15, r15, lsl 31
	biclt	r0, r0, r0, lsl r0
	biclt	r15, r15, r15, lsl r15
	biclt	r0, r0, r0, lsr 1
	biclt	r15, r15, r15, lsr 32
	biclt	r0, r0, r0, lsr r0
	biclt	r15, r15, r15, asr r15
	biclt	r0, r0, r0, asr 1
	biclt	r15, r15, r15, asr 32
	biclt	r0, r0, r0, asr r0
	biclt	r15, r15, r15, asr r15
	biclt	r0, r0, r0, ror 1
	biclt	r15, r15, r15, ror 31
	biclt	r0, r0, r0, ror r0
	biclt	r15, r15, r15, ror r15
	biclt	r0, r0, r0, rrx

positive: bicgt instruction

	bicgt	r0, r0, 0
	bicgt	r15, r15, 0xff000000
	bicgt	r0, r0, r0
	bicgt	r15, r15, r15
	bicgt	r0, r0, r0, lsl 0
	bicgt	r15, r15, r15, lsl 31
	bicgt	r0, r0, r0, lsl r0
	bicgt	r15, r15, r15, lsl r15
	bicgt	r0, r0, r0, lsr 1
	bicgt	r15, r15, r15, lsr 32
	bicgt	r0, r0, r0, lsr r0
	bicgt	r15, r15, r15, asr r15
	bicgt	r0, r0, r0, asr 1
	bicgt	r15, r15, r15, asr 32
	bicgt	r0, r0, r0, asr r0
	bicgt	r15, r15, r15, asr r15
	bicgt	r0, r0, r0, ror 1
	bicgt	r15, r15, r15, ror 31
	bicgt	r0, r0, r0, ror r0
	bicgt	r15, r15, r15, ror r15
	bicgt	r0, r0, r0, rrx

positive: bicle instruction

	bicle	r0, r0, 0
	bicle	r15, r15, 0xff000000
	bicle	r0, r0, r0
	bicle	r15, r15, r15
	bicle	r0, r0, r0, lsl 0
	bicle	r15, r15, r15, lsl 31
	bicle	r0, r0, r0, lsl r0
	bicle	r15, r15, r15, lsl r15
	bicle	r0, r0, r0, lsr 1
	bicle	r15, r15, r15, lsr 32
	bicle	r0, r0, r0, lsr r0
	bicle	r15, r15, r15, asr r15
	bicle	r0, r0, r0, asr 1
	bicle	r15, r15, r15, asr 32
	bicle	r0, r0, r0, asr r0
	bicle	r15, r15, r15, asr r15
	bicle	r0, r0, r0, ror 1
	bicle	r15, r15, r15, ror 31
	bicle	r0, r0, r0, ror r0
	bicle	r15, r15, r15, ror r15
	bicle	r0, r0, r0, rrx

positive: bical instruction

	bical	r0, r0, 0
	bical	r15, r15, 0xff000000
	bical	r0, r0, r0
	bical	r15, r15, r15
	bical	r0, r0, r0, lsl 0
	bical	r15, r15, r15, lsl 31
	bical	r0, r0, r0, lsl r0
	bical	r15, r15, r15, lsl r15
	bical	r0, r0, r0, lsr 1
	bical	r15, r15, r15, lsr 32
	bical	r0, r0, r0, lsr r0
	bical	r15, r15, r15, asr r15
	bical	r0, r0, r0, asr 1
	bical	r15, r15, r15, asr 32
	bical	r0, r0, r0, asr r0
	bical	r15, r15, r15, asr r15
	bical	r0, r0, r0, ror 1
	bical	r15, r15, r15, ror 31
	bical	r0, r0, r0, ror r0
	bical	r15, r15, r15, ror r15
	bical	r0, r0, r0, rrx

positive: bics instruction

	bics	r0, r0, 0
	bics	r15, r15, 0xff000000
	bics	r0, r0, r0
	bics	r15, r15, r15
	bics	r0, r0, r0, lsl 0
	bics	r15, r15, r15, lsl 31
	bics	r0, r0, r0, lsl r0
	bics	r15, r15, r15, lsl r15
	bics	r0, r0, r0, lsr 1
	bics	r15, r15, r15, lsr 32
	bics	r0, r0, r0, lsr r0
	bics	r15, r15, r15, asr r15
	bics	r0, r0, r0, asr 1
	bics	r15, r15, r15, asr 32
	bics	r0, r0, r0, asr r0
	bics	r15, r15, r15, asr r15
	bics	r0, r0, r0, ror 1
	bics	r15, r15, r15, ror 31
	bics	r0, r0, r0, ror r0
	bics	r15, r15, r15, ror r15
	bics	r0, r0, r0, rrx

positive: bicseq instruction

	bicseq	r0, r0, 0
	bicseq	r15, r15, 0xff000000
	bicseq	r0, r0, r0
	bicseq	r15, r15, r15
	bicseq	r0, r0, r0, lsl 0
	bicseq	r15, r15, r15, lsl 31
	bicseq	r0, r0, r0, lsl r0
	bicseq	r15, r15, r15, lsl r15
	bicseq	r0, r0, r0, lsr 1
	bicseq	r15, r15, r15, lsr 32
	bicseq	r0, r0, r0, lsr r0
	bicseq	r15, r15, r15, asr r15
	bicseq	r0, r0, r0, asr 1
	bicseq	r15, r15, r15, asr 32
	bicseq	r0, r0, r0, asr r0
	bicseq	r15, r15, r15, asr r15
	bicseq	r0, r0, r0, ror 1
	bicseq	r15, r15, r15, ror 31
	bicseq	r0, r0, r0, ror r0
	bicseq	r15, r15, r15, ror r15
	bicseq	r0, r0, r0, rrx

positive: bicsne instruction

	bicsne	r0, r0, 0
	bicsne	r15, r15, 0xff000000
	bicsne	r0, r0, r0
	bicsne	r15, r15, r15
	bicsne	r0, r0, r0, lsl 0
	bicsne	r15, r15, r15, lsl 31
	bicsne	r0, r0, r0, lsl r0
	bicsne	r15, r15, r15, lsl r15
	bicsne	r0, r0, r0, lsr 1
	bicsne	r15, r15, r15, lsr 32
	bicsne	r0, r0, r0, lsr r0
	bicsne	r15, r15, r15, asr r15
	bicsne	r0, r0, r0, asr 1
	bicsne	r15, r15, r15, asr 32
	bicsne	r0, r0, r0, asr r0
	bicsne	r15, r15, r15, asr r15
	bicsne	r0, r0, r0, ror 1
	bicsne	r15, r15, r15, ror 31
	bicsne	r0, r0, r0, ror r0
	bicsne	r15, r15, r15, ror r15
	bicsne	r0, r0, r0, rrx

positive: bicscs instruction

	bicscs	r0, r0, 0
	bicscs	r15, r15, 0xff000000
	bicscs	r0, r0, r0
	bicscs	r15, r15, r15
	bicscs	r0, r0, r0, lsl 0
	bicscs	r15, r15, r15, lsl 31
	bicscs	r0, r0, r0, lsl r0
	bicscs	r15, r15, r15, lsl r15
	bicscs	r0, r0, r0, lsr 1
	bicscs	r15, r15, r15, lsr 32
	bicscs	r0, r0, r0, lsr r0
	bicscs	r15, r15, r15, asr r15
	bicscs	r0, r0, r0, asr 1
	bicscs	r15, r15, r15, asr 32
	bicscs	r0, r0, r0, asr r0
	bicscs	r15, r15, r15, asr r15
	bicscs	r0, r0, r0, ror 1
	bicscs	r15, r15, r15, ror 31
	bicscs	r0, r0, r0, ror r0
	bicscs	r15, r15, r15, ror r15
	bicscs	r0, r0, r0, rrx

positive: bicshs instruction

	bicshs	r0, r0, 0
	bicshs	r15, r15, 0xff000000
	bicshs	r0, r0, r0
	bicshs	r15, r15, r15
	bicshs	r0, r0, r0, lsl 0
	bicshs	r15, r15, r15, lsl 31
	bicshs	r0, r0, r0, lsl r0
	bicshs	r15, r15, r15, lsl r15
	bicshs	r0, r0, r0, lsr 1
	bicshs	r15, r15, r15, lsr 32
	bicshs	r0, r0, r0, lsr r0
	bicshs	r15, r15, r15, asr r15
	bicshs	r0, r0, r0, asr 1
	bicshs	r15, r15, r15, asr 32
	bicshs	r0, r0, r0, asr r0
	bicshs	r15, r15, r15, asr r15
	bicshs	r0, r0, r0, ror 1
	bicshs	r15, r15, r15, ror 31
	bicshs	r0, r0, r0, ror r0
	bicshs	r15, r15, r15, ror r15
	bicshs	r0, r0, r0, rrx

positive: bicscc instruction

	bicscc	r0, r0, 0
	bicscc	r15, r15, 0xff000000
	bicscc	r0, r0, r0
	bicscc	r15, r15, r15
	bicscc	r0, r0, r0, lsl 0
	bicscc	r15, r15, r15, lsl 31
	bicscc	r0, r0, r0, lsl r0
	bicscc	r15, r15, r15, lsl r15
	bicscc	r0, r0, r0, lsr 1
	bicscc	r15, r15, r15, lsr 32
	bicscc	r0, r0, r0, lsr r0
	bicscc	r15, r15, r15, asr r15
	bicscc	r0, r0, r0, asr 1
	bicscc	r15, r15, r15, asr 32
	bicscc	r0, r0, r0, asr r0
	bicscc	r15, r15, r15, asr r15
	bicscc	r0, r0, r0, ror 1
	bicscc	r15, r15, r15, ror 31
	bicscc	r0, r0, r0, ror r0
	bicscc	r15, r15, r15, ror r15
	bicscc	r0, r0, r0, rrx

positive: bicslo instruction

	bicslo	r0, r0, 0
	bicslo	r15, r15, 0xff000000
	bicslo	r0, r0, r0
	bicslo	r15, r15, r15
	bicslo	r0, r0, r0, lsl 0
	bicslo	r15, r15, r15, lsl 31
	bicslo	r0, r0, r0, lsl r0
	bicslo	r15, r15, r15, lsl r15
	bicslo	r0, r0, r0, lsr 1
	bicslo	r15, r15, r15, lsr 32
	bicslo	r0, r0, r0, lsr r0
	bicslo	r15, r15, r15, asr r15
	bicslo	r0, r0, r0, asr 1
	bicslo	r15, r15, r15, asr 32
	bicslo	r0, r0, r0, asr r0
	bicslo	r15, r15, r15, asr r15
	bicslo	r0, r0, r0, ror 1
	bicslo	r15, r15, r15, ror 31
	bicslo	r0, r0, r0, ror r0
	bicslo	r15, r15, r15, ror r15
	bicslo	r0, r0, r0, rrx

positive: bicsmi instruction

	bicsmi	r0, r0, 0
	bicsmi	r15, r15, 0xff000000
	bicsmi	r0, r0, r0
	bicsmi	r15, r15, r15
	bicsmi	r0, r0, r0, lsl 0
	bicsmi	r15, r15, r15, lsl 31
	bicsmi	r0, r0, r0, lsl r0
	bicsmi	r15, r15, r15, lsl r15
	bicsmi	r0, r0, r0, lsr 1
	bicsmi	r15, r15, r15, lsr 32
	bicsmi	r0, r0, r0, lsr r0
	bicsmi	r15, r15, r15, asr r15
	bicsmi	r0, r0, r0, asr 1
	bicsmi	r15, r15, r15, asr 32
	bicsmi	r0, r0, r0, asr r0
	bicsmi	r15, r15, r15, asr r15
	bicsmi	r0, r0, r0, ror 1
	bicsmi	r15, r15, r15, ror 31
	bicsmi	r0, r0, r0, ror r0
	bicsmi	r15, r15, r15, ror r15
	bicsmi	r0, r0, r0, rrx

positive: bicspl instruction

	bicspl	r0, r0, 0
	bicspl	r15, r15, 0xff000000
	bicspl	r0, r0, r0
	bicspl	r15, r15, r15
	bicspl	r0, r0, r0, lsl 0
	bicspl	r15, r15, r15, lsl 31
	bicspl	r0, r0, r0, lsl r0
	bicspl	r15, r15, r15, lsl r15
	bicspl	r0, r0, r0, lsr 1
	bicspl	r15, r15, r15, lsr 32
	bicspl	r0, r0, r0, lsr r0
	bicspl	r15, r15, r15, asr r15
	bicspl	r0, r0, r0, asr 1
	bicspl	r15, r15, r15, asr 32
	bicspl	r0, r0, r0, asr r0
	bicspl	r15, r15, r15, asr r15
	bicspl	r0, r0, r0, ror 1
	bicspl	r15, r15, r15, ror 31
	bicspl	r0, r0, r0, ror r0
	bicspl	r15, r15, r15, ror r15
	bicspl	r0, r0, r0, rrx

positive: bicsvs instruction

	bicsvs	r0, r0, 0
	bicsvs	r15, r15, 0xff000000
	bicsvs	r0, r0, r0
	bicsvs	r15, r15, r15
	bicsvs	r0, r0, r0, lsl 0
	bicsvs	r15, r15, r15, lsl 31
	bicsvs	r0, r0, r0, lsl r0
	bicsvs	r15, r15, r15, lsl r15
	bicsvs	r0, r0, r0, lsr 1
	bicsvs	r15, r15, r15, lsr 32
	bicsvs	r0, r0, r0, lsr r0
	bicsvs	r15, r15, r15, asr r15
	bicsvs	r0, r0, r0, asr 1
	bicsvs	r15, r15, r15, asr 32
	bicsvs	r0, r0, r0, asr r0
	bicsvs	r15, r15, r15, asr r15
	bicsvs	r0, r0, r0, ror 1
	bicsvs	r15, r15, r15, ror 31
	bicsvs	r0, r0, r0, ror r0
	bicsvs	r15, r15, r15, ror r15
	bicsvs	r0, r0, r0, rrx

positive: bicsvc instruction

	bicsvc	r0, r0, 0
	bicsvc	r15, r15, 0xff000000
	bicsvc	r0, r0, r0
	bicsvc	r15, r15, r15
	bicsvc	r0, r0, r0, lsl 0
	bicsvc	r15, r15, r15, lsl 31
	bicsvc	r0, r0, r0, lsl r0
	bicsvc	r15, r15, r15, lsl r15
	bicsvc	r0, r0, r0, lsr 1
	bicsvc	r15, r15, r15, lsr 32
	bicsvc	r0, r0, r0, lsr r0
	bicsvc	r15, r15, r15, asr r15
	bicsvc	r0, r0, r0, asr 1
	bicsvc	r15, r15, r15, asr 32
	bicsvc	r0, r0, r0, asr r0
	bicsvc	r15, r15, r15, asr r15
	bicsvc	r0, r0, r0, ror 1
	bicsvc	r15, r15, r15, ror 31
	bicsvc	r0, r0, r0, ror r0
	bicsvc	r15, r15, r15, ror r15
	bicsvc	r0, r0, r0, rrx

positive: bicshi instruction

	bicshi	r0, r0, 0
	bicshi	r15, r15, 0xff000000
	bicshi	r0, r0, r0
	bicshi	r15, r15, r15
	bicshi	r0, r0, r0, lsl 0
	bicshi	r15, r15, r15, lsl 31
	bicshi	r0, r0, r0, lsl r0
	bicshi	r15, r15, r15, lsl r15
	bicshi	r0, r0, r0, lsr 1
	bicshi	r15, r15, r15, lsr 32
	bicshi	r0, r0, r0, lsr r0
	bicshi	r15, r15, r15, asr r15
	bicshi	r0, r0, r0, asr 1
	bicshi	r15, r15, r15, asr 32
	bicshi	r0, r0, r0, asr r0
	bicshi	r15, r15, r15, asr r15
	bicshi	r0, r0, r0, ror 1
	bicshi	r15, r15, r15, ror 31
	bicshi	r0, r0, r0, ror r0
	bicshi	r15, r15, r15, ror r15
	bicshi	r0, r0, r0, rrx

positive: bicsls instruction

	bicsls	r0, r0, 0
	bicsls	r15, r15, 0xff000000
	bicsls	r0, r0, r0
	bicsls	r15, r15, r15
	bicsls	r0, r0, r0, lsl 0
	bicsls	r15, r15, r15, lsl 31
	bicsls	r0, r0, r0, lsl r0
	bicsls	r15, r15, r15, lsl r15
	bicsls	r0, r0, r0, lsr 1
	bicsls	r15, r15, r15, lsr 32
	bicsls	r0, r0, r0, lsr r0
	bicsls	r15, r15, r15, asr r15
	bicsls	r0, r0, r0, asr 1
	bicsls	r15, r15, r15, asr 32
	bicsls	r0, r0, r0, asr r0
	bicsls	r15, r15, r15, asr r15
	bicsls	r0, r0, r0, ror 1
	bicsls	r15, r15, r15, ror 31
	bicsls	r0, r0, r0, ror r0
	bicsls	r15, r15, r15, ror r15
	bicsls	r0, r0, r0, rrx

positive: bicsge instruction

	bicsge	r0, r0, 0
	bicsge	r15, r15, 0xff000000
	bicsge	r0, r0, r0
	bicsge	r15, r15, r15
	bicsge	r0, r0, r0, lsl 0
	bicsge	r15, r15, r15, lsl 31
	bicsge	r0, r0, r0, lsl r0
	bicsge	r15, r15, r15, lsl r15
	bicsge	r0, r0, r0, lsr 1
	bicsge	r15, r15, r15, lsr 32
	bicsge	r0, r0, r0, lsr r0
	bicsge	r15, r15, r15, asr r15
	bicsge	r0, r0, r0, asr 1
	bicsge	r15, r15, r15, asr 32
	bicsge	r0, r0, r0, asr r0
	bicsge	r15, r15, r15, asr r15
	bicsge	r0, r0, r0, ror 1
	bicsge	r15, r15, r15, ror 31
	bicsge	r0, r0, r0, ror r0
	bicsge	r15, r15, r15, ror r15
	bicsge	r0, r0, r0, rrx

positive: bicslt instruction

	bicslt	r0, r0, 0
	bicslt	r15, r15, 0xff000000
	bicslt	r0, r0, r0
	bicslt	r15, r15, r15
	bicslt	r0, r0, r0, lsl 0
	bicslt	r15, r15, r15, lsl 31
	bicslt	r0, r0, r0, lsl r0
	bicslt	r15, r15, r15, lsl r15
	bicslt	r0, r0, r0, lsr 1
	bicslt	r15, r15, r15, lsr 32
	bicslt	r0, r0, r0, lsr r0
	bicslt	r15, r15, r15, asr r15
	bicslt	r0, r0, r0, asr 1
	bicslt	r15, r15, r15, asr 32
	bicslt	r0, r0, r0, asr r0
	bicslt	r15, r15, r15, asr r15
	bicslt	r0, r0, r0, ror 1
	bicslt	r15, r15, r15, ror 31
	bicslt	r0, r0, r0, ror r0
	bicslt	r15, r15, r15, ror r15
	bicslt	r0, r0, r0, rrx

positive: bicsgt instruction

	bicsgt	r0, r0, 0
	bicsgt	r15, r15, 0xff000000
	bicsgt	r0, r0, r0
	bicsgt	r15, r15, r15
	bicsgt	r0, r0, r0, lsl 0
	bicsgt	r15, r15, r15, lsl 31
	bicsgt	r0, r0, r0, lsl r0
	bicsgt	r15, r15, r15, lsl r15
	bicsgt	r0, r0, r0, lsr 1
	bicsgt	r15, r15, r15, lsr 32
	bicsgt	r0, r0, r0, lsr r0
	bicsgt	r15, r15, r15, asr r15
	bicsgt	r0, r0, r0, asr 1
	bicsgt	r15, r15, r15, asr 32
	bicsgt	r0, r0, r0, asr r0
	bicsgt	r15, r15, r15, asr r15
	bicsgt	r0, r0, r0, ror 1
	bicsgt	r15, r15, r15, ror 31
	bicsgt	r0, r0, r0, ror r0
	bicsgt	r15, r15, r15, ror r15
	bicsgt	r0, r0, r0, rrx

positive: bicsle instruction

	bicsle	r0, r0, 0
	bicsle	r15, r15, 0xff000000
	bicsle	r0, r0, r0
	bicsle	r15, r15, r15
	bicsle	r0, r0, r0, lsl 0
	bicsle	r15, r15, r15, lsl 31
	bicsle	r0, r0, r0, lsl r0
	bicsle	r15, r15, r15, lsl r15
	bicsle	r0, r0, r0, lsr 1
	bicsle	r15, r15, r15, lsr 32
	bicsle	r0, r0, r0, lsr r0
	bicsle	r15, r15, r15, asr r15
	bicsle	r0, r0, r0, asr 1
	bicsle	r15, r15, r15, asr 32
	bicsle	r0, r0, r0, asr r0
	bicsle	r15, r15, r15, asr r15
	bicsle	r0, r0, r0, ror 1
	bicsle	r15, r15, r15, ror 31
	bicsle	r0, r0, r0, ror r0
	bicsle	r15, r15, r15, ror r15
	bicsle	r0, r0, r0, rrx

positive: bicsal instruction

	bicsal	r0, r0, 0
	bicsal	r15, r15, 0xff000000
	bicsal	r0, r0, r0
	bicsal	r15, r15, r15
	bicsal	r0, r0, r0, lsl 0
	bicsal	r15, r15, r15, lsl 31
	bicsal	r0, r0, r0, lsl r0
	bicsal	r15, r15, r15, lsl r15
	bicsal	r0, r0, r0, lsr 1
	bicsal	r15, r15, r15, lsr 32
	bicsal	r0, r0, r0, lsr r0
	bicsal	r15, r15, r15, asr r15
	bicsal	r0, r0, r0, asr 1
	bicsal	r15, r15, r15, asr 32
	bicsal	r0, r0, r0, asr r0
	bicsal	r15, r15, r15, asr r15
	bicsal	r0, r0, r0, ror 1
	bicsal	r15, r15, r15, ror 31
	bicsal	r0, r0, r0, ror r0
	bicsal	r15, r15, r15, ror r15
	bicsal	r0, r0, r0, rrx

positive: bkbt instruction

	bkpt	0
	bkpt	65535

positive: blx instruction

	blx	-33554432
	blx	+33554428
	blx	r0
	blx	r15

positive: blxeq instruction

	blxeq	r0
	blxeq	r15

positive: blxne instruction

	blxne	r0
	blxne	r15

positive: blxcs instruction

	blxcs	r0
	blxcs	r15

positive: blxhs instruction

	blxhs	r0
	blxhs	r15

positive: blxcc instruction

	blxcc	r0
	blxcc	r15

positive: blxlo instruction

	blxlo	r0
	blxlo	r15

positive: blxmi instruction

	blxmi	r0
	blxmi	r15

positive: blxpl instruction

	blxpl	r0
	blxpl	r15

positive: blxvs instruction

	blxvs	r0
	blxvs	r15

positive: blxvc instruction

	blxvc	r0
	blxvc	r15

positive: blxhi instruction

	blxhi	r0
	blxhi	r15

positive: blxls instruction

	blxls	r0
	blxls	r15

positive: blxge instruction

	blxge	r0
	blxge	r15

positive: blxlt instruction

	blxlt	r0
	blxlt	r15

positive: blxgt instruction

	blxgt	r0
	blxgt	r15

positive: blxle instruction

	blxle	r0
	blxle	r15

positive: blxal instruction

	blxal	r0
	blxal	r15

positive: bx instruction

	bx	r0
	bx	r15

positive: bxeq instruction

	bxeq	r0
	bxeq	r15

positive: bxne instruction

	bxne	r0
	bxne	r15

positive: bxcs instruction

	bxcs	r0
	bxcs	r15

positive: bxhs instruction

	bxhs	r0
	bxhs	r15

positive: bxcc instruction

	bxcc	r0
	bxcc	r15

positive: bxlo instruction

	bxlo	r0
	bxlo	r15

positive: bxmi instruction

	bxmi	r0
	bxmi	r15

positive: bxpl instruction

	bxpl	r0
	bxpl	r15

positive: bxvs instruction

	bxvs	r0
	bxvs	r15

positive: bxvc instruction

	bxvc	r0
	bxvc	r15

positive: bxhi instruction

	bxhi	r0
	bxhi	r15

positive: bxls instruction

	bxls	r0
	bxls	r15

positive: bxge instruction

	bxge	r0
	bxge	r15

positive: bxlt instruction

	bxlt	r0
	bxlt	r15

positive: bxgt instruction

	bxgt	r0
	bxgt	r15

positive: bxle instruction

	bxle	r0
	bxle	r15

positive: bxal instruction

	bxal	r0
	bxal	r15

positive: cdp instruction

	cdp	p0, 0, c0, c0, c0, 0
	cdp	p15, 15, c15, c15, c15, 7

positive: cdpeq instruction

	cdpeq	p0, 0, c0, c0, c0, 0
	cdpeq	p15, 15, c15, c15, c15, 7

positive: cdpne instruction

	cdpne	p0, 0, c0, c0, c0, 0
	cdpne	p15, 15, c15, c15, c15, 7

positive: cdpcs instruction

	cdpcs	p0, 0, c0, c0, c0, 0
	cdpcs	p15, 15, c15, c15, c15, 7

positive: cdphs instruction

	cdphs	p0, 0, c0, c0, c0, 0
	cdphs	p15, 15, c15, c15, c15, 7

positive: cdpcc instruction

	cdpcc	p0, 0, c0, c0, c0, 0
	cdpcc	p15, 15, c15, c15, c15, 7

positive: cdplo instruction

	cdplo	p0, 0, c0, c0, c0, 0
	cdplo	p15, 15, c15, c15, c15, 7

positive: cdpmi instruction

	cdpmi	p0, 0, c0, c0, c0, 0
	cdpmi	p15, 15, c15, c15, c15, 7

positive: cdppl instruction

	cdppl	p0, 0, c0, c0, c0, 0
	cdppl	p15, 15, c15, c15, c15, 7

positive: cdpvs instruction

	cdpvs	p0, 0, c0, c0, c0, 0
	cdpvs	p15, 15, c15, c15, c15, 7

positive: cdpvc instruction

	cdpvc	p0, 0, c0, c0, c0, 0
	cdpvc	p15, 15, c15, c15, c15, 7

positive: cdphi instruction

	cdphi	p0, 0, c0, c0, c0, 0
	cdphi	p15, 15, c15, c15, c15, 7

positive: cdpls instruction

	cdpls	p0, 0, c0, c0, c0, 0
	cdpls	p15, 15, c15, c15, c15, 7

positive: cdpge instruction

	cdpge	p0, 0, c0, c0, c0, 0
	cdpge	p15, 15, c15, c15, c15, 7

positive: cdplt instruction

	cdplt	p0, 0, c0, c0, c0, 0
	cdplt	p15, 15, c15, c15, c15, 7

positive: cdpgtg instruction

	cdpgt	p0, 0, c0, c0, c0, 0
	cdpgt	p15, 15, c15, c15, c15, 7

positive: cdple instruction

	cdple	p0, 0, c0, c0, c0, 0
	cdple	p15, 15, c15, c15, c15, 7

positive: cdpal instruction

	cdpal	p0, 0, c0, c0, c0, 0
	cdpal	p15, 15, c15, c15, c15, 7

positive: cdp2 instruction

	cdp2	p0, 0, c0, c0, c0, 0
	cdp2	p15, 15, c15, c15, c15, 7

positive: clz instruction

	clz	r0, r0
	clz	r15, r15

positive: clzeq instruction

	clzeq	r0, r0
	clzeq	r15, r15

positive: clzne instruction

	clzne	r0, r0
	clzne	r15, r15

positive: clzcs instruction

	clzcs	r0, r0
	clzcs	r15, r15

positive: clzhs instruction

	clzhs	r0, r0
	clzhs	r15, r15

positive: clzcc instruction

	clzcc	r0, r0
	clzcc	r15, r15

positive: clzlo instruction

	clzlo	r0, r0
	clzlo	r15, r15

positive: clzmi instruction

	clzmi	r0, r0
	clzmi	r15, r15

positive: clzpl instruction

	clzpl	r0, r0
	clzpl	r15, r15

positive: clzvs instruction

	clzvs	r0, r0
	clzvs	r15, r15

positive: clzvc instruction

	clzvc	r0, r0
	clzvc	r15, r15

positive: clzhi instruction

	clzhi	r0, r0
	clzhi	r15, r15

positive: clzls instruction

	clzls	r0, r0
	clzls	r15, r15

positive: clzge instruction

	clzge	r0, r0
	clzge	r15, r15

positive: clzlt instruction

	clzlt	r0, r0
	clzlt	r15, r15

positive: clzgt instruction

	clzgt	r0, r0
	clzgt	r15, r15

positive: clzle instruction

	clzle	r0, r0
	clzle	r15, r15

positive: clzal instruction

	clzal	r0, r0
	clzal	r15, r15

positive: cmn instruction

	cmn	r0, 0
	cmn	r15, 0xff000000
	cmn	r0, r0
	cmn	r15, r15
	cmn	r0, r0, lsl 0
	cmn	r15, r15, lsl 31
	cmn	r0, r0, lsl r0
	cmn	r15, r15, lsl r15
	cmn	r0, r0, lsr 1
	cmn	r15, r15, lsr 32
	cmn	r0, r0, lsr r0
	cmn	r15, r15, asr r15
	cmn	r0, r0, asr 1
	cmn	r15, r15, asr 32
	cmn	r0, r0, asr r0
	cmn	r15, r15, asr r15
	cmn	r0, r0, ror 1
	cmn	r15, r15, ror 31
	cmn	r0, r0, ror r0
	cmn	r15, r15, ror r15
	cmn	r0, r0, rrx

positive: cmneq instruction

	cmneq	r0, 0
	cmneq	r15, 0xff000000
	cmneq	r0, r0
	cmneq	r15, r15
	cmneq	r0, r0, lsl 0
	cmneq	r15, r15, lsl 31
	cmneq	r0, r0, lsl r0
	cmneq	r15, r15, lsl r15
	cmneq	r0, r0, lsr 1
	cmneq	r15, r15, lsr 32
	cmneq	r0, r0, lsr r0
	cmneq	r15, r15, asr r15
	cmneq	r0, r0, asr 1
	cmneq	r15, r15, asr 32
	cmneq	r0, r0, asr r0
	cmneq	r15, r15, asr r15
	cmneq	r0, r0, ror 1
	cmneq	r15, r15, ror 31
	cmneq	r0, r0, ror r0
	cmneq	r15, r15, ror r15
	cmneq	r0, r0, rrx

positive: cmnne instruction

	cmnne	r0, 0
	cmnne	r15, 0xff000000
	cmnne	r0, r0
	cmnne	r15, r15
	cmnne	r0, r0, lsl 0
	cmnne	r15, r15, lsl 31
	cmnne	r0, r0, lsl r0
	cmnne	r15, r15, lsl r15
	cmnne	r0, r0, lsr 1
	cmnne	r15, r15, lsr 32
	cmnne	r0, r0, lsr r0
	cmnne	r15, r15, asr r15
	cmnne	r0, r0, asr 1
	cmnne	r15, r15, asr 32
	cmnne	r0, r0, asr r0
	cmnne	r15, r15, asr r15
	cmnne	r0, r0, ror 1
	cmnne	r15, r15, ror 31
	cmnne	r0, r0, ror r0
	cmnne	r15, r15, ror r15
	cmnne	r0, r0, rrx

positive: cmncs instruction

	cmncs	r0, 0
	cmncs	r15, 0xff000000
	cmncs	r0, r0
	cmncs	r15, r15
	cmncs	r0, r0, lsl 0
	cmncs	r15, r15, lsl 31
	cmncs	r0, r0, lsl r0
	cmncs	r15, r15, lsl r15
	cmncs	r0, r0, lsr 1
	cmncs	r15, r15, lsr 32
	cmncs	r0, r0, lsr r0
	cmncs	r15, r15, asr r15
	cmncs	r0, r0, asr 1
	cmncs	r15, r15, asr 32
	cmncs	r0, r0, asr r0
	cmncs	r15, r15, asr r15
	cmncs	r0, r0, ror 1
	cmncs	r15, r15, ror 31
	cmncs	r0, r0, ror r0
	cmncs	r15, r15, ror r15
	cmncs	r0, r0, rrx

positive: cmnhs instruction

	cmnhs	r0, 0
	cmnhs	r15, 0xff000000
	cmnhs	r0, r0
	cmnhs	r15, r15
	cmnhs	r0, r0, lsl 0
	cmnhs	r15, r15, lsl 31
	cmnhs	r0, r0, lsl r0
	cmnhs	r15, r15, lsl r15
	cmnhs	r0, r0, lsr 1
	cmnhs	r15, r15, lsr 32
	cmnhs	r0, r0, lsr r0
	cmnhs	r15, r15, asr r15
	cmnhs	r0, r0, asr 1
	cmnhs	r15, r15, asr 32
	cmnhs	r0, r0, asr r0
	cmnhs	r15, r15, asr r15
	cmnhs	r0, r0, ror 1
	cmnhs	r15, r15, ror 31
	cmnhs	r0, r0, ror r0
	cmnhs	r15, r15, ror r15
	cmnhs	r0, r0, rrx

positive: cmncc instruction

	cmncc	r0, 0
	cmncc	r15, 0xff000000
	cmncc	r0, r0
	cmncc	r15, r15
	cmncc	r0, r0, lsl 0
	cmncc	r15, r15, lsl 31
	cmncc	r0, r0, lsl r0
	cmncc	r15, r15, lsl r15
	cmncc	r0, r0, lsr 1
	cmncc	r15, r15, lsr 32
	cmncc	r0, r0, lsr r0
	cmncc	r15, r15, asr r15
	cmncc	r0, r0, asr 1
	cmncc	r15, r15, asr 32
	cmncc	r0, r0, asr r0
	cmncc	r15, r15, asr r15
	cmncc	r0, r0, ror 1
	cmncc	r15, r15, ror 31
	cmncc	r0, r0, ror r0
	cmncc	r15, r15, ror r15
	cmncc	r0, r0, rrx

positive: cmnlo instruction

	cmnlo	r0, 0
	cmnlo	r15, 0xff000000
	cmnlo	r0, r0
	cmnlo	r15, r15
	cmnlo	r0, r0, lsl 0
	cmnlo	r15, r15, lsl 31
	cmnlo	r0, r0, lsl r0
	cmnlo	r15, r15, lsl r15
	cmnlo	r0, r0, lsr 1
	cmnlo	r15, r15, lsr 32
	cmnlo	r0, r0, lsr r0
	cmnlo	r15, r15, asr r15
	cmnlo	r0, r0, asr 1
	cmnlo	r15, r15, asr 32
	cmnlo	r0, r0, asr r0
	cmnlo	r15, r15, asr r15
	cmnlo	r0, r0, ror 1
	cmnlo	r15, r15, ror 31
	cmnlo	r0, r0, ror r0
	cmnlo	r15, r15, ror r15
	cmnlo	r0, r0, rrx

positive: cmnmi instruction

	cmnmi	r0, 0
	cmnmi	r15, 0xff000000
	cmnmi	r0, r0
	cmnmi	r15, r15
	cmnmi	r0, r0, lsl 0
	cmnmi	r15, r15, lsl 31
	cmnmi	r0, r0, lsl r0
	cmnmi	r15, r15, lsl r15
	cmnmi	r0, r0, lsr 1
	cmnmi	r15, r15, lsr 32
	cmnmi	r0, r0, lsr r0
	cmnmi	r15, r15, asr r15
	cmnmi	r0, r0, asr 1
	cmnmi	r15, r15, asr 32
	cmnmi	r0, r0, asr r0
	cmnmi	r15, r15, asr r15
	cmnmi	r0, r0, ror 1
	cmnmi	r15, r15, ror 31
	cmnmi	r0, r0, ror r0
	cmnmi	r15, r15, ror r15
	cmnmi	r0, r0, rrx

positive: cmnpl instruction

	cmnpl	r0, 0
	cmnpl	r15, 0xff000000
	cmnpl	r0, r0
	cmnpl	r15, r15
	cmnpl	r0, r0, lsl 0
	cmnpl	r15, r15, lsl 31
	cmnpl	r0, r0, lsl r0
	cmnpl	r15, r15, lsl r15
	cmnpl	r0, r0, lsr 1
	cmnpl	r15, r15, lsr 32
	cmnpl	r0, r0, lsr r0
	cmnpl	r15, r15, asr r15
	cmnpl	r0, r0, asr 1
	cmnpl	r15, r15, asr 32
	cmnpl	r0, r0, asr r0
	cmnpl	r15, r15, asr r15
	cmnpl	r0, r0, ror 1
	cmnpl	r15, r15, ror 31
	cmnpl	r0, r0, ror r0
	cmnpl	r15, r15, ror r15
	cmnpl	r0, r0, rrx

positive: cmnvs instruction

	cmnvs	r0, 0
	cmnvs	r15, 0xff000000
	cmnvs	r0, r0
	cmnvs	r15, r15
	cmnvs	r0, r0, lsl 0
	cmnvs	r15, r15, lsl 31
	cmnvs	r0, r0, lsl r0
	cmnvs	r15, r15, lsl r15
	cmnvs	r0, r0, lsr 1
	cmnvs	r15, r15, lsr 32
	cmnvs	r0, r0, lsr r0
	cmnvs	r15, r15, asr r15
	cmnvs	r0, r0, asr 1
	cmnvs	r15, r15, asr 32
	cmnvs	r0, r0, asr r0
	cmnvs	r15, r15, asr r15
	cmnvs	r0, r0, ror 1
	cmnvs	r15, r15, ror 31
	cmnvs	r0, r0, ror r0
	cmnvs	r15, r15, ror r15
	cmnvs	r0, r0, rrx

positive: cmnvc instruction

	cmnvc	r0, 0
	cmnvc	r15, 0xff000000
	cmnvc	r0, r0
	cmnvc	r15, r15
	cmnvc	r0, r0, lsl 0
	cmnvc	r15, r15, lsl 31
	cmnvc	r0, r0, lsl r0
	cmnvc	r15, r15, lsl r15
	cmnvc	r0, r0, lsr 1
	cmnvc	r15, r15, lsr 32
	cmnvc	r0, r0, lsr r0
	cmnvc	r15, r15, asr r15
	cmnvc	r0, r0, asr 1
	cmnvc	r15, r15, asr 32
	cmnvc	r0, r0, asr r0
	cmnvc	r15, r15, asr r15
	cmnvc	r0, r0, ror 1
	cmnvc	r15, r15, ror 31
	cmnvc	r0, r0, ror r0
	cmnvc	r15, r15, ror r15
	cmnvc	r0, r0, rrx

positive: cmnhi instruction

	cmnhi	r0, 0
	cmnhi	r15, 0xff000000
	cmnhi	r0, r0
	cmnhi	r15, r15
	cmnhi	r0, r0, lsl 0
	cmnhi	r15, r15, lsl 31
	cmnhi	r0, r0, lsl r0
	cmnhi	r15, r15, lsl r15
	cmnhi	r0, r0, lsr 1
	cmnhi	r15, r15, lsr 32
	cmnhi	r0, r0, lsr r0
	cmnhi	r15, r15, asr r15
	cmnhi	r0, r0, asr 1
	cmnhi	r15, r15, asr 32
	cmnhi	r0, r0, asr r0
	cmnhi	r15, r15, asr r15
	cmnhi	r0, r0, ror 1
	cmnhi	r15, r15, ror 31
	cmnhi	r0, r0, ror r0
	cmnhi	r15, r15, ror r15
	cmnhi	r0, r0, rrx

positive: cmnls instruction

	cmnls	r0, 0
	cmnls	r15, 0xff000000
	cmnls	r0, r0
	cmnls	r15, r15
	cmnls	r0, r0, lsl 0
	cmnls	r15, r15, lsl 31
	cmnls	r0, r0, lsl r0
	cmnls	r15, r15, lsl r15
	cmnls	r0, r0, lsr 1
	cmnls	r15, r15, lsr 32
	cmnls	r0, r0, lsr r0
	cmnls	r15, r15, asr r15
	cmnls	r0, r0, asr 1
	cmnls	r15, r15, asr 32
	cmnls	r0, r0, asr r0
	cmnls	r15, r15, asr r15
	cmnls	r0, r0, ror 1
	cmnls	r15, r15, ror 31
	cmnls	r0, r0, ror r0
	cmnls	r15, r15, ror r15
	cmnls	r0, r0, rrx

positive: cmnge instruction

	cmnge	r0, 0
	cmnge	r15, 0xff000000
	cmnge	r0, r0
	cmnge	r15, r15
	cmnge	r0, r0, lsl 0
	cmnge	r15, r15, lsl 31
	cmnge	r0, r0, lsl r0
	cmnge	r15, r15, lsl r15
	cmnge	r0, r0, lsr 1
	cmnge	r15, r15, lsr 32
	cmnge	r0, r0, lsr r0
	cmnge	r15, r15, asr r15
	cmnge	r0, r0, asr 1
	cmnge	r15, r15, asr 32
	cmnge	r0, r0, asr r0
	cmnge	r15, r15, asr r15
	cmnge	r0, r0, ror 1
	cmnge	r15, r15, ror 31
	cmnge	r0, r0, ror r0
	cmnge	r15, r15, ror r15
	cmnge	r0, r0, rrx

positive: cmnlt instruction

	cmnlt	r0, 0
	cmnlt	r15, 0xff000000
	cmnlt	r0, r0
	cmnlt	r15, r15
	cmnlt	r0, r0, lsl 0
	cmnlt	r15, r15, lsl 31
	cmnlt	r0, r0, lsl r0
	cmnlt	r15, r15, lsl r15
	cmnlt	r0, r0, lsr 1
	cmnlt	r15, r15, lsr 32
	cmnlt	r0, r0, lsr r0
	cmnlt	r15, r15, asr r15
	cmnlt	r0, r0, asr 1
	cmnlt	r15, r15, asr 32
	cmnlt	r0, r0, asr r0
	cmnlt	r15, r15, asr r15
	cmnlt	r0, r0, ror 1
	cmnlt	r15, r15, ror 31
	cmnlt	r0, r0, ror r0
	cmnlt	r15, r15, ror r15
	cmnlt	r0, r0, rrx

positive: cmngt instruction

	cmngt	r0, 0
	cmngt	r15, 0xff000000
	cmngt	r0, r0
	cmngt	r15, r15
	cmngt	r0, r0, lsl 0
	cmngt	r15, r15, lsl 31
	cmngt	r0, r0, lsl r0
	cmngt	r15, r15, lsl r15
	cmngt	r0, r0, lsr 1
	cmngt	r15, r15, lsr 32
	cmngt	r0, r0, lsr r0
	cmngt	r15, r15, asr r15
	cmngt	r0, r0, asr 1
	cmngt	r15, r15, asr 32
	cmngt	r0, r0, asr r0
	cmngt	r15, r15, asr r15
	cmngt	r0, r0, ror 1
	cmngt	r15, r15, ror 31
	cmngt	r0, r0, ror r0
	cmngt	r15, r15, ror r15
	cmngt	r0, r0, rrx

positive: cmnle instruction

	cmnle	r0, 0
	cmnle	r15, 0xff000000
	cmnle	r0, r0
	cmnle	r15, r15
	cmnle	r0, r0, lsl 0
	cmnle	r15, r15, lsl 31
	cmnle	r0, r0, lsl r0
	cmnle	r15, r15, lsl r15
	cmnle	r0, r0, lsr 1
	cmnle	r15, r15, lsr 32
	cmnle	r0, r0, lsr r0
	cmnle	r15, r15, asr r15
	cmnle	r0, r0, asr 1
	cmnle	r15, r15, asr 32
	cmnle	r0, r0, asr r0
	cmnle	r15, r15, asr r15
	cmnle	r0, r0, ror 1
	cmnle	r15, r15, ror 31
	cmnle	r0, r0, ror r0
	cmnle	r15, r15, ror r15
	cmnle	r0, r0, rrx

positive: cmnal instruction

	cmnal	r0, 0
	cmnal	r15, 0xff000000
	cmnal	r0, r0
	cmnal	r15, r15
	cmnal	r0, r0, lsl 0
	cmnal	r15, r15, lsl 31
	cmnal	r0, r0, lsl r0
	cmnal	r15, r15, lsl r15
	cmnal	r0, r0, lsr 1
	cmnal	r15, r15, lsr 32
	cmnal	r0, r0, lsr r0
	cmnal	r15, r15, asr r15
	cmnal	r0, r0, asr 1
	cmnal	r15, r15, asr 32
	cmnal	r0, r0, asr r0
	cmnal	r15, r15, asr r15
	cmnal	r0, r0, ror 1
	cmnal	r15, r15, ror 31
	cmnal	r0, r0, ror r0
	cmnal	r15, r15, ror r15
	cmnal	r0, r0, rrx

positive: cmp instruction

	cmp	r0, 0
	cmp	r15, 0xff000000
	cmp	r0, r0
	cmp	r15, r15
	cmp	r0, r0, lsl 0
	cmp	r15, r15, lsl 31
	cmp	r0, r0, lsl r0
	cmp	r15, r15, lsl r15
	cmp	r0, r0, lsr 1
	cmp	r15, r15, lsr 32
	cmp	r0, r0, lsr r0
	cmp	r15, r15, asr r15
	cmp	r0, r0, asr 1
	cmp	r15, r15, asr 32
	cmp	r0, r0, asr r0
	cmp	r15, r15, asr r15
	cmp	r0, r0, ror 1
	cmp	r15, r15, ror 31
	cmp	r0, r0, ror r0
	cmp	r15, r15, ror r15
	cmp	r0, r0, rrx

positive: cmpeq instruction

	cmpeq	r0, 0
	cmpeq	r15, 0xff000000
	cmpeq	r0, r0
	cmpeq	r15, r15
	cmpeq	r0, r0, lsl 0
	cmpeq	r15, r15, lsl 31
	cmpeq	r0, r0, lsl r0
	cmpeq	r15, r15, lsl r15
	cmpeq	r0, r0, lsr 1
	cmpeq	r15, r15, lsr 32
	cmpeq	r0, r0, lsr r0
	cmpeq	r15, r15, asr r15
	cmpeq	r0, r0, asr 1
	cmpeq	r15, r15, asr 32
	cmpeq	r0, r0, asr r0
	cmpeq	r15, r15, asr r15
	cmpeq	r0, r0, ror 1
	cmpeq	r15, r15, ror 31
	cmpeq	r0, r0, ror r0
	cmpeq	r15, r15, ror r15
	cmpeq	r0, r0, rrx

positive: cmpne instruction

	cmpne	r0, 0
	cmpne	r15, 0xff000000
	cmpne	r0, r0
	cmpne	r15, r15
	cmpne	r0, r0, lsl 0
	cmpne	r15, r15, lsl 31
	cmpne	r0, r0, lsl r0
	cmpne	r15, r15, lsl r15
	cmpne	r0, r0, lsr 1
	cmpne	r15, r15, lsr 32
	cmpne	r0, r0, lsr r0
	cmpne	r15, r15, asr r15
	cmpne	r0, r0, asr 1
	cmpne	r15, r15, asr 32
	cmpne	r0, r0, asr r0
	cmpne	r15, r15, asr r15
	cmpne	r0, r0, ror 1
	cmpne	r15, r15, ror 31
	cmpne	r0, r0, ror r0
	cmpne	r15, r15, ror r15
	cmpne	r0, r0, rrx

positive: cmpcs instruction

	cmpcs	r0, 0
	cmpcs	r15, 0xff000000
	cmpcs	r0, r0
	cmpcs	r15, r15
	cmpcs	r0, r0, lsl 0
	cmpcs	r15, r15, lsl 31
	cmpcs	r0, r0, lsl r0
	cmpcs	r15, r15, lsl r15
	cmpcs	r0, r0, lsr 1
	cmpcs	r15, r15, lsr 32
	cmpcs	r0, r0, lsr r0
	cmpcs	r15, r15, asr r15
	cmpcs	r0, r0, asr 1
	cmpcs	r15, r15, asr 32
	cmpcs	r0, r0, asr r0
	cmpcs	r15, r15, asr r15
	cmpcs	r0, r0, ror 1
	cmpcs	r15, r15, ror 31
	cmpcs	r0, r0, ror r0
	cmpcs	r15, r15, ror r15
	cmpcs	r0, r0, rrx

positive: cmphs instruction

	cmphs	r0, 0
	cmphs	r15, 0xff000000
	cmphs	r0, r0
	cmphs	r15, r15
	cmphs	r0, r0, lsl 0
	cmphs	r15, r15, lsl 31
	cmphs	r0, r0, lsl r0
	cmphs	r15, r15, lsl r15
	cmphs	r0, r0, lsr 1
	cmphs	r15, r15, lsr 32
	cmphs	r0, r0, lsr r0
	cmphs	r15, r15, asr r15
	cmphs	r0, r0, asr 1
	cmphs	r15, r15, asr 32
	cmphs	r0, r0, asr r0
	cmphs	r15, r15, asr r15
	cmphs	r0, r0, ror 1
	cmphs	r15, r15, ror 31
	cmphs	r0, r0, ror r0
	cmphs	r15, r15, ror r15
	cmphs	r0, r0, rrx

positive: cmpcc instruction

	cmpcc	r0, 0
	cmpcc	r15, 0xff000000
	cmpcc	r0, r0
	cmpcc	r15, r15
	cmpcc	r0, r0, lsl 0
	cmpcc	r15, r15, lsl 31
	cmpcc	r0, r0, lsl r0
	cmpcc	r15, r15, lsl r15
	cmpcc	r0, r0, lsr 1
	cmpcc	r15, r15, lsr 32
	cmpcc	r0, r0, lsr r0
	cmpcc	r15, r15, asr r15
	cmpcc	r0, r0, asr 1
	cmpcc	r15, r15, asr 32
	cmpcc	r0, r0, asr r0
	cmpcc	r15, r15, asr r15
	cmpcc	r0, r0, ror 1
	cmpcc	r15, r15, ror 31
	cmpcc	r0, r0, ror r0
	cmpcc	r15, r15, ror r15
	cmpcc	r0, r0, rrx

positive: cmplo instruction

	cmplo	r0, 0
	cmplo	r15, 0xff000000
	cmplo	r0, r0
	cmplo	r15, r15
	cmplo	r0, r0, lsl 0
	cmplo	r15, r15, lsl 31
	cmplo	r0, r0, lsl r0
	cmplo	r15, r15, lsl r15
	cmplo	r0, r0, lsr 1
	cmplo	r15, r15, lsr 32
	cmplo	r0, r0, lsr r0
	cmplo	r15, r15, asr r15
	cmplo	r0, r0, asr 1
	cmplo	r15, r15, asr 32
	cmplo	r0, r0, asr r0
	cmplo	r15, r15, asr r15
	cmplo	r0, r0, ror 1
	cmplo	r15, r15, ror 31
	cmplo	r0, r0, ror r0
	cmplo	r15, r15, ror r15
	cmplo	r0, r0, rrx

positive: cmpmi instruction

	cmpmi	r0, 0
	cmpmi	r15, 0xff000000
	cmpmi	r0, r0
	cmpmi	r15, r15
	cmpmi	r0, r0, lsl 0
	cmpmi	r15, r15, lsl 31
	cmpmi	r0, r0, lsl r0
	cmpmi	r15, r15, lsl r15
	cmpmi	r0, r0, lsr 1
	cmpmi	r15, r15, lsr 32
	cmpmi	r0, r0, lsr r0
	cmpmi	r15, r15, asr r15
	cmpmi	r0, r0, asr 1
	cmpmi	r15, r15, asr 32
	cmpmi	r0, r0, asr r0
	cmpmi	r15, r15, asr r15
	cmpmi	r0, r0, ror 1
	cmpmi	r15, r15, ror 31
	cmpmi	r0, r0, ror r0
	cmpmi	r15, r15, ror r15
	cmpmi	r0, r0, rrx

positive: cmppl instruction

	cmppl	r0, 0
	cmppl	r15, 0xff000000
	cmppl	r0, r0
	cmppl	r15, r15
	cmppl	r0, r0, lsl 0
	cmppl	r15, r15, lsl 31
	cmppl	r0, r0, lsl r0
	cmppl	r15, r15, lsl r15
	cmppl	r0, r0, lsr 1
	cmppl	r15, r15, lsr 32
	cmppl	r0, r0, lsr r0
	cmppl	r15, r15, asr r15
	cmppl	r0, r0, asr 1
	cmppl	r15, r15, asr 32
	cmppl	r0, r0, asr r0
	cmppl	r15, r15, asr r15
	cmppl	r0, r0, ror 1
	cmppl	r15, r15, ror 31
	cmppl	r0, r0, ror r0
	cmppl	r15, r15, ror r15
	cmppl	r0, r0, rrx

positive: cmpvs instruction

	cmpvs	r0, 0
	cmpvs	r15, 0xff000000
	cmpvs	r0, r0
	cmpvs	r15, r15
	cmpvs	r0, r0, lsl 0
	cmpvs	r15, r15, lsl 31
	cmpvs	r0, r0, lsl r0
	cmpvs	r15, r15, lsl r15
	cmpvs	r0, r0, lsr 1
	cmpvs	r15, r15, lsr 32
	cmpvs	r0, r0, lsr r0
	cmpvs	r15, r15, asr r15
	cmpvs	r0, r0, asr 1
	cmpvs	r15, r15, asr 32
	cmpvs	r0, r0, asr r0
	cmpvs	r15, r15, asr r15
	cmpvs	r0, r0, ror 1
	cmpvs	r15, r15, ror 31
	cmpvs	r0, r0, ror r0
	cmpvs	r15, r15, ror r15
	cmpvs	r0, r0, rrx

positive: cmpvc instruction

	cmpvc	r0, 0
	cmpvc	r15, 0xff000000
	cmpvc	r0, r0
	cmpvc	r15, r15
	cmpvc	r0, r0, lsl 0
	cmpvc	r15, r15, lsl 31
	cmpvc	r0, r0, lsl r0
	cmpvc	r15, r15, lsl r15
	cmpvc	r0, r0, lsr 1
	cmpvc	r15, r15, lsr 32
	cmpvc	r0, r0, lsr r0
	cmpvc	r15, r15, asr r15
	cmpvc	r0, r0, asr 1
	cmpvc	r15, r15, asr 32
	cmpvc	r0, r0, asr r0
	cmpvc	r15, r15, asr r15
	cmpvc	r0, r0, ror 1
	cmpvc	r15, r15, ror 31
	cmpvc	r0, r0, ror r0
	cmpvc	r15, r15, ror r15
	cmpvc	r0, r0, rrx

positive: cmphi instruction

	cmphi	r0, 0
	cmphi	r15, 0xff000000
	cmphi	r0, r0
	cmphi	r15, r15
	cmphi	r0, r0, lsl 0
	cmphi	r15, r15, lsl 31
	cmphi	r0, r0, lsl r0
	cmphi	r15, r15, lsl r15
	cmphi	r0, r0, lsr 1
	cmphi	r15, r15, lsr 32
	cmphi	r0, r0, lsr r0
	cmphi	r15, r15, asr r15
	cmphi	r0, r0, asr 1
	cmphi	r15, r15, asr 32
	cmphi	r0, r0, asr r0
	cmphi	r15, r15, asr r15
	cmphi	r0, r0, ror 1
	cmphi	r15, r15, ror 31
	cmphi	r0, r0, ror r0
	cmphi	r15, r15, ror r15
	cmphi	r0, r0, rrx

positive: cmpls instruction

	cmpls	r0, 0
	cmpls	r15, 0xff000000
	cmpls	r0, r0
	cmpls	r15, r15
	cmpls	r0, r0, lsl 0
	cmpls	r15, r15, lsl 31
	cmpls	r0, r0, lsl r0
	cmpls	r15, r15, lsl r15
	cmpls	r0, r0, lsr 1
	cmpls	r15, r15, lsr 32
	cmpls	r0, r0, lsr r0
	cmpls	r15, r15, asr r15
	cmpls	r0, r0, asr 1
	cmpls	r15, r15, asr 32
	cmpls	r0, r0, asr r0
	cmpls	r15, r15, asr r15
	cmpls	r0, r0, ror 1
	cmpls	r15, r15, ror 31
	cmpls	r0, r0, ror r0
	cmpls	r15, r15, ror r15
	cmpls	r0, r0, rrx

positive: cmpge instruction

	cmpge	r0, 0
	cmpge	r15, 0xff000000
	cmpge	r0, r0
	cmpge	r15, r15
	cmpge	r0, r0, lsl 0
	cmpge	r15, r15, lsl 31
	cmpge	r0, r0, lsl r0
	cmpge	r15, r15, lsl r15
	cmpge	r0, r0, lsr 1
	cmpge	r15, r15, lsr 32
	cmpge	r0, r0, lsr r0
	cmpge	r15, r15, asr r15
	cmpge	r0, r0, asr 1
	cmpge	r15, r15, asr 32
	cmpge	r0, r0, asr r0
	cmpge	r15, r15, asr r15
	cmpge	r0, r0, ror 1
	cmpge	r15, r15, ror 31
	cmpge	r0, r0, ror r0
	cmpge	r15, r15, ror r15
	cmpge	r0, r0, rrx

positive: cmplt instruction

	cmplt	r0, 0
	cmplt	r15, 0xff000000
	cmplt	r0, r0
	cmplt	r15, r15
	cmplt	r0, r0, lsl 0
	cmplt	r15, r15, lsl 31
	cmplt	r0, r0, lsl r0
	cmplt	r15, r15, lsl r15
	cmplt	r0, r0, lsr 1
	cmplt	r15, r15, lsr 32
	cmplt	r0, r0, lsr r0
	cmplt	r15, r15, asr r15
	cmplt	r0, r0, asr 1
	cmplt	r15, r15, asr 32
	cmplt	r0, r0, asr r0
	cmplt	r15, r15, asr r15
	cmplt	r0, r0, ror 1
	cmplt	r15, r15, ror 31
	cmplt	r0, r0, ror r0
	cmplt	r15, r15, ror r15
	cmplt	r0, r0, rrx

positive: cmpgt instruction

	cmpgt	r0, 0
	cmpgt	r15, 0xff000000
	cmpgt	r0, r0
	cmpgt	r15, r15
	cmpgt	r0, r0, lsl 0
	cmpgt	r15, r15, lsl 31
	cmpgt	r0, r0, lsl r0
	cmpgt	r15, r15, lsl r15
	cmpgt	r0, r0, lsr 1
	cmpgt	r15, r15, lsr 32
	cmpgt	r0, r0, lsr r0
	cmpgt	r15, r15, asr r15
	cmpgt	r0, r0, asr 1
	cmpgt	r15, r15, asr 32
	cmpgt	r0, r0, asr r0
	cmpgt	r15, r15, asr r15
	cmpgt	r0, r0, ror 1
	cmpgt	r15, r15, ror 31
	cmpgt	r0, r0, ror r0
	cmpgt	r15, r15, ror r15
	cmpgt	r0, r0, rrx

positive: cmple instruction

	cmple	r0, 0
	cmple	r15, 0xff000000
	cmple	r0, r0
	cmple	r15, r15
	cmple	r0, r0, lsl 0
	cmple	r15, r15, lsl 31
	cmple	r0, r0, lsl r0
	cmple	r15, r15, lsl r15
	cmple	r0, r0, lsr 1
	cmple	r15, r15, lsr 32
	cmple	r0, r0, lsr r0
	cmple	r15, r15, asr r15
	cmple	r0, r0, asr 1
	cmple	r15, r15, asr 32
	cmple	r0, r0, asr r0
	cmple	r15, r15, asr r15
	cmple	r0, r0, ror 1
	cmple	r15, r15, ror 31
	cmple	r0, r0, ror r0
	cmple	r15, r15, ror r15
	cmple	r0, r0, rrx

positive: cmpal instruction

	cmpal	r0, 0
	cmpal	r15, 0xff000000
	cmpal	r0, r0
	cmpal	r15, r15
	cmpal	r0, r0, lsl 0
	cmpal	r15, r15, lsl 31
	cmpal	r0, r0, lsl r0
	cmpal	r15, r15, lsl r15
	cmpal	r0, r0, lsr 1
	cmpal	r15, r15, lsr 32
	cmpal	r0, r0, lsr r0
	cmpal	r15, r15, asr r15
	cmpal	r0, r0, asr 1
	cmpal	r15, r15, asr 32
	cmpal	r0, r0, asr r0
	cmpal	r15, r15, asr r15
	cmpal	r0, r0, ror 1
	cmpal	r15, r15, ror 31
	cmpal	r0, r0, ror r0
	cmpal	r15, r15, ror r15
	cmpal	r0, r0, rrx

positive: cpy instruction

	cpy	r0, r0
	cpy	r15, r15

positive: cpyeq instruction

	cpyeq	r0, r0
	cpyeq	r15, r15

positive: cpyne instruction

	cpyne	r0, r0
	cpyne	r15, r15

positive: cpycs instruction

	cpycs	r0, r0
	cpycs	r15, r15

positive: cpyhs instruction

	cpyhs	r0, r0
	cpyhs	r15, r15

positive: cpycc instruction

	cpycc	r0, r0
	cpycc	r15, r15

positive: cpylo instruction

	cpylo	r0, r0
	cpylo	r15, r15

positive: cpymi instruction

	cpymi	r0, r0
	cpymi	r15, r15

positive: cpypl instruction

	cpypl	r0, r0
	cpypl	r15, r15

positive: cpyvs instruction

	cpyvs	r0, r0
	cpyvs	r15, r15

positive: cpyvc instruction

	cpyvc	r0, r0
	cpyvc	r15, r15

positive: cpyhi instruction

	cpyhi	r0, r0
	cpyhi	r15, r15

positive: cpyls instruction

	cpyls	r0, r0
	cpyls	r15, r15

positive: cpyge instruction

	cpyge	r0, r0
	cpyge	r15, r15

positive: cpylt instruction

	cpylt	r0, r0
	cpylt	r15, r15

positive: cpygt instruction

	cpygt	r0, r0
	cpygt	r15, r15

positive: cpyle instruction

	cpyle	r0, r0
	cpyle	r15, r15

positive: cpyal instruction

	cpyal	r0, r0
	cpyal	r15, r15

positive: dbg instruction

	dbg	0
	dbg	15

positive: dbgeq instruction

	dbgeq	0
	dbgeq	15

positive: dbgne instruction

	dbgne	0
	dbgne	15

positive: dbgcs instruction

	dbgcs	0
	dbgcs	15

positive: dbghs instruction

	dbghs	0
	dbghs	15

positive: dbgcc instruction

	dbgcc	0
	dbgcc	15

positive: dbglo instruction

	dbglo	0
	dbglo	15

positive: dbgmi instruction

	dbgmi	0
	dbgmi	15

positive: dbgpl instruction

	dbgpl	0
	dbgpl	15

positive: dbgvs instruction

	dbgvs	0
	dbgvs	15

positive: dbgvc instruction

	dbgvc	0
	dbgvc	15

positive: dbghi instruction

	dbghi	0
	dbghi	15

positive: dbgls instruction

	dbgls	0
	dbgls	15

positive: dbgge instruction

	dbgge	0
	dbgge	15

positive: dbglt instruction

	dbglt	0
	dbglt	15

positive: dbggt instruction

	dbggt	0
	dbggt	15

positive: dbgle instruction

	dbgle	0
	dbgle	15

positive: dbgal instruction

	dbgal	0
	dbgal	15

positive: dmb instruction

	dmb
	dmb	0
	dmb	15

positive: dsb instruction

	dsb
	dsb	0
	dsb	15

positive: eor instruction

	eor	r0, r0, 0
	eor	r15, r15, 0xff000000
	eor	r0, r0, r0
	eor	r15, r15, r15
	eor	r0, r0, r0, lsl 0
	eor	r15, r15, r15, lsl 31
	eor	r0, r0, r0, lsl r0
	eor	r15, r15, r15, lsl r15
	eor	r0, r0, r0, lsr 1
	eor	r15, r15, r15, lsr 32
	eor	r0, r0, r0, lsr r0
	eor	r15, r15, r15, asr r15
	eor	r0, r0, r0, asr 1
	eor	r15, r15, r15, asr 32
	eor	r0, r0, r0, asr r0
	eor	r15, r15, r15, asr r15
	eor	r0, r0, r0, ror 1
	eor	r15, r15, r15, ror 31
	eor	r0, r0, r0, ror r0
	eor	r15, r15, r15, ror r15
	eor	r0, r0, r0, rrx

positive: eoreq instruction

	eoreq	r0, r0, 0
	eoreq	r15, r15, 0xff000000
	eoreq	r0, r0, r0
	eoreq	r15, r15, r15
	eoreq	r0, r0, r0, lsl 0
	eoreq	r15, r15, r15, lsl 31
	eoreq	r0, r0, r0, lsl r0
	eoreq	r15, r15, r15, lsl r15
	eoreq	r0, r0, r0, lsr 1
	eoreq	r15, r15, r15, lsr 32
	eoreq	r0, r0, r0, lsr r0
	eoreq	r15, r15, r15, asr r15
	eoreq	r0, r0, r0, asr 1
	eoreq	r15, r15, r15, asr 32
	eoreq	r0, r0, r0, asr r0
	eoreq	r15, r15, r15, asr r15
	eoreq	r0, r0, r0, ror 1
	eoreq	r15, r15, r15, ror 31
	eoreq	r0, r0, r0, ror r0
	eoreq	r15, r15, r15, ror r15
	eoreq	r0, r0, r0, rrx

positive: eorne instruction

	eorne	r0, r0, 0
	eorne	r15, r15, 0xff000000
	eorne	r0, r0, r0
	eorne	r15, r15, r15
	eorne	r0, r0, r0, lsl 0
	eorne	r15, r15, r15, lsl 31
	eorne	r0, r0, r0, lsl r0
	eorne	r15, r15, r15, lsl r15
	eorne	r0, r0, r0, lsr 1
	eorne	r15, r15, r15, lsr 32
	eorne	r0, r0, r0, lsr r0
	eorne	r15, r15, r15, asr r15
	eorne	r0, r0, r0, asr 1
	eorne	r15, r15, r15, asr 32
	eorne	r0, r0, r0, asr r0
	eorne	r15, r15, r15, asr r15
	eorne	r0, r0, r0, ror 1
	eorne	r15, r15, r15, ror 31
	eorne	r0, r0, r0, ror r0
	eorne	r15, r15, r15, ror r15
	eorne	r0, r0, r0, rrx

positive: eorcs instruction

	eorcs	r0, r0, 0
	eorcs	r15, r15, 0xff000000
	eorcs	r0, r0, r0
	eorcs	r15, r15, r15
	eorcs	r0, r0, r0, lsl 0
	eorcs	r15, r15, r15, lsl 31
	eorcs	r0, r0, r0, lsl r0
	eorcs	r15, r15, r15, lsl r15
	eorcs	r0, r0, r0, lsr 1
	eorcs	r15, r15, r15, lsr 32
	eorcs	r0, r0, r0, lsr r0
	eorcs	r15, r15, r15, asr r15
	eorcs	r0, r0, r0, asr 1
	eorcs	r15, r15, r15, asr 32
	eorcs	r0, r0, r0, asr r0
	eorcs	r15, r15, r15, asr r15
	eorcs	r0, r0, r0, ror 1
	eorcs	r15, r15, r15, ror 31
	eorcs	r0, r0, r0, ror r0
	eorcs	r15, r15, r15, ror r15
	eorcs	r0, r0, r0, rrx

positive: eorhs instruction

	eorhs	r0, r0, 0
	eorhs	r15, r15, 0xff000000
	eorhs	r0, r0, r0
	eorhs	r15, r15, r15
	eorhs	r0, r0, r0, lsl 0
	eorhs	r15, r15, r15, lsl 31
	eorhs	r0, r0, r0, lsl r0
	eorhs	r15, r15, r15, lsl r15
	eorhs	r0, r0, r0, lsr 1
	eorhs	r15, r15, r15, lsr 32
	eorhs	r0, r0, r0, lsr r0
	eorhs	r15, r15, r15, asr r15
	eorhs	r0, r0, r0, asr 1
	eorhs	r15, r15, r15, asr 32
	eorhs	r0, r0, r0, asr r0
	eorhs	r15, r15, r15, asr r15
	eorhs	r0, r0, r0, ror 1
	eorhs	r15, r15, r15, ror 31
	eorhs	r0, r0, r0, ror r0
	eorhs	r15, r15, r15, ror r15
	eorhs	r0, r0, r0, rrx

positive: eorcc instruction

	eorcc	r0, r0, 0
	eorcc	r15, r15, 0xff000000
	eorcc	r0, r0, r0
	eorcc	r15, r15, r15
	eorcc	r0, r0, r0, lsl 0
	eorcc	r15, r15, r15, lsl 31
	eorcc	r0, r0, r0, lsl r0
	eorcc	r15, r15, r15, lsl r15
	eorcc	r0, r0, r0, lsr 1
	eorcc	r15, r15, r15, lsr 32
	eorcc	r0, r0, r0, lsr r0
	eorcc	r15, r15, r15, asr r15
	eorcc	r0, r0, r0, asr 1
	eorcc	r15, r15, r15, asr 32
	eorcc	r0, r0, r0, asr r0
	eorcc	r15, r15, r15, asr r15
	eorcc	r0, r0, r0, ror 1
	eorcc	r15, r15, r15, ror 31
	eorcc	r0, r0, r0, ror r0
	eorcc	r15, r15, r15, ror r15
	eorcc	r0, r0, r0, rrx

positive: eorlo instruction

	eorlo	r0, r0, 0
	eorlo	r15, r15, 0xff000000
	eorlo	r0, r0, r0
	eorlo	r15, r15, r15
	eorlo	r0, r0, r0, lsl 0
	eorlo	r15, r15, r15, lsl 31
	eorlo	r0, r0, r0, lsl r0
	eorlo	r15, r15, r15, lsl r15
	eorlo	r0, r0, r0, lsr 1
	eorlo	r15, r15, r15, lsr 32
	eorlo	r0, r0, r0, lsr r0
	eorlo	r15, r15, r15, asr r15
	eorlo	r0, r0, r0, asr 1
	eorlo	r15, r15, r15, asr 32
	eorlo	r0, r0, r0, asr r0
	eorlo	r15, r15, r15, asr r15
	eorlo	r0, r0, r0, ror 1
	eorlo	r15, r15, r15, ror 31
	eorlo	r0, r0, r0, ror r0
	eorlo	r15, r15, r15, ror r15
	eorlo	r0, r0, r0, rrx

positive: eormi instruction

	eormi	r0, r0, 0
	eormi	r15, r15, 0xff000000
	eormi	r0, r0, r0
	eormi	r15, r15, r15
	eormi	r0, r0, r0, lsl 0
	eormi	r15, r15, r15, lsl 31
	eormi	r0, r0, r0, lsl r0
	eormi	r15, r15, r15, lsl r15
	eormi	r0, r0, r0, lsr 1
	eormi	r15, r15, r15, lsr 32
	eormi	r0, r0, r0, lsr r0
	eormi	r15, r15, r15, asr r15
	eormi	r0, r0, r0, asr 1
	eormi	r15, r15, r15, asr 32
	eormi	r0, r0, r0, asr r0
	eormi	r15, r15, r15, asr r15
	eormi	r0, r0, r0, ror 1
	eormi	r15, r15, r15, ror 31
	eormi	r0, r0, r0, ror r0
	eormi	r15, r15, r15, ror r15
	eormi	r0, r0, r0, rrx

positive: eorpl instruction

	eorpl	r0, r0, 0
	eorpl	r15, r15, 0xff000000
	eorpl	r0, r0, r0
	eorpl	r15, r15, r15
	eorpl	r0, r0, r0, lsl 0
	eorpl	r15, r15, r15, lsl 31
	eorpl	r0, r0, r0, lsl r0
	eorpl	r15, r15, r15, lsl r15
	eorpl	r0, r0, r0, lsr 1
	eorpl	r15, r15, r15, lsr 32
	eorpl	r0, r0, r0, lsr r0
	eorpl	r15, r15, r15, asr r15
	eorpl	r0, r0, r0, asr 1
	eorpl	r15, r15, r15, asr 32
	eorpl	r0, r0, r0, asr r0
	eorpl	r15, r15, r15, asr r15
	eorpl	r0, r0, r0, ror 1
	eorpl	r15, r15, r15, ror 31
	eorpl	r0, r0, r0, ror r0
	eorpl	r15, r15, r15, ror r15
	eorpl	r0, r0, r0, rrx

positive: eorvs instruction

	eorvs	r0, r0, 0
	eorvs	r15, r15, 0xff000000
	eorvs	r0, r0, r0
	eorvs	r15, r15, r15
	eorvs	r0, r0, r0, lsl 0
	eorvs	r15, r15, r15, lsl 31
	eorvs	r0, r0, r0, lsl r0
	eorvs	r15, r15, r15, lsl r15
	eorvs	r0, r0, r0, lsr 1
	eorvs	r15, r15, r15, lsr 32
	eorvs	r0, r0, r0, lsr r0
	eorvs	r15, r15, r15, asr r15
	eorvs	r0, r0, r0, asr 1
	eorvs	r15, r15, r15, asr 32
	eorvs	r0, r0, r0, asr r0
	eorvs	r15, r15, r15, asr r15
	eorvs	r0, r0, r0, ror 1
	eorvs	r15, r15, r15, ror 31
	eorvs	r0, r0, r0, ror r0
	eorvs	r15, r15, r15, ror r15
	eorvs	r0, r0, r0, rrx

positive: eorvc instruction

	eorvc	r0, r0, 0
	eorvc	r15, r15, 0xff000000
	eorvc	r0, r0, r0
	eorvc	r15, r15, r15
	eorvc	r0, r0, r0, lsl 0
	eorvc	r15, r15, r15, lsl 31
	eorvc	r0, r0, r0, lsl r0
	eorvc	r15, r15, r15, lsl r15
	eorvc	r0, r0, r0, lsr 1
	eorvc	r15, r15, r15, lsr 32
	eorvc	r0, r0, r0, lsr r0
	eorvc	r15, r15, r15, asr r15
	eorvc	r0, r0, r0, asr 1
	eorvc	r15, r15, r15, asr 32
	eorvc	r0, r0, r0, asr r0
	eorvc	r15, r15, r15, asr r15
	eorvc	r0, r0, r0, ror 1
	eorvc	r15, r15, r15, ror 31
	eorvc	r0, r0, r0, ror r0
	eorvc	r15, r15, r15, ror r15
	eorvc	r0, r0, r0, rrx

positive: eorhi instruction

	eorhi	r0, r0, 0
	eorhi	r15, r15, 0xff000000
	eorhi	r0, r0, r0
	eorhi	r15, r15, r15
	eorhi	r0, r0, r0, lsl 0
	eorhi	r15, r15, r15, lsl 31
	eorhi	r0, r0, r0, lsl r0
	eorhi	r15, r15, r15, lsl r15
	eorhi	r0, r0, r0, lsr 1
	eorhi	r15, r15, r15, lsr 32
	eorhi	r0, r0, r0, lsr r0
	eorhi	r15, r15, r15, asr r15
	eorhi	r0, r0, r0, asr 1
	eorhi	r15, r15, r15, asr 32
	eorhi	r0, r0, r0, asr r0
	eorhi	r15, r15, r15, asr r15
	eorhi	r0, r0, r0, ror 1
	eorhi	r15, r15, r15, ror 31
	eorhi	r0, r0, r0, ror r0
	eorhi	r15, r15, r15, ror r15
	eorhi	r0, r0, r0, rrx

positive: eorls instruction

	eorls	r0, r0, 0
	eorls	r15, r15, 0xff000000
	eorls	r0, r0, r0
	eorls	r15, r15, r15
	eorls	r0, r0, r0, lsl 0
	eorls	r15, r15, r15, lsl 31
	eorls	r0, r0, r0, lsl r0
	eorls	r15, r15, r15, lsl r15
	eorls	r0, r0, r0, lsr 1
	eorls	r15, r15, r15, lsr 32
	eorls	r0, r0, r0, lsr r0
	eorls	r15, r15, r15, asr r15
	eorls	r0, r0, r0, asr 1
	eorls	r15, r15, r15, asr 32
	eorls	r0, r0, r0, asr r0
	eorls	r15, r15, r15, asr r15
	eorls	r0, r0, r0, ror 1
	eorls	r15, r15, r15, ror 31
	eorls	r0, r0, r0, ror r0
	eorls	r15, r15, r15, ror r15
	eorls	r0, r0, r0, rrx

positive: eorge instruction

	eorge	r0, r0, 0
	eorge	r15, r15, 0xff000000
	eorge	r0, r0, r0
	eorge	r15, r15, r15
	eorge	r0, r0, r0, lsl 0
	eorge	r15, r15, r15, lsl 31
	eorge	r0, r0, r0, lsl r0
	eorge	r15, r15, r15, lsl r15
	eorge	r0, r0, r0, lsr 1
	eorge	r15, r15, r15, lsr 32
	eorge	r0, r0, r0, lsr r0
	eorge	r15, r15, r15, asr r15
	eorge	r0, r0, r0, asr 1
	eorge	r15, r15, r15, asr 32
	eorge	r0, r0, r0, asr r0
	eorge	r15, r15, r15, asr r15
	eorge	r0, r0, r0, ror 1
	eorge	r15, r15, r15, ror 31
	eorge	r0, r0, r0, ror r0
	eorge	r15, r15, r15, ror r15
	eorge	r0, r0, r0, rrx

positive: eorlt instruction

	eorlt	r0, r0, 0
	eorlt	r15, r15, 0xff000000
	eorlt	r0, r0, r0
	eorlt	r15, r15, r15
	eorlt	r0, r0, r0, lsl 0
	eorlt	r15, r15, r15, lsl 31
	eorlt	r0, r0, r0, lsl r0
	eorlt	r15, r15, r15, lsl r15
	eorlt	r0, r0, r0, lsr 1
	eorlt	r15, r15, r15, lsr 32
	eorlt	r0, r0, r0, lsr r0
	eorlt	r15, r15, r15, asr r15
	eorlt	r0, r0, r0, asr 1
	eorlt	r15, r15, r15, asr 32
	eorlt	r0, r0, r0, asr r0
	eorlt	r15, r15, r15, asr r15
	eorlt	r0, r0, r0, ror 1
	eorlt	r15, r15, r15, ror 31
	eorlt	r0, r0, r0, ror r0
	eorlt	r15, r15, r15, ror r15
	eorlt	r0, r0, r0, rrx

positive: eorgt instruction

	eorgt	r0, r0, 0
	eorgt	r15, r15, 0xff000000
	eorgt	r0, r0, r0
	eorgt	r15, r15, r15
	eorgt	r0, r0, r0, lsl 0
	eorgt	r15, r15, r15, lsl 31
	eorgt	r0, r0, r0, lsl r0
	eorgt	r15, r15, r15, lsl r15
	eorgt	r0, r0, r0, lsr 1
	eorgt	r15, r15, r15, lsr 32
	eorgt	r0, r0, r0, lsr r0
	eorgt	r15, r15, r15, asr r15
	eorgt	r0, r0, r0, asr 1
	eorgt	r15, r15, r15, asr 32
	eorgt	r0, r0, r0, asr r0
	eorgt	r15, r15, r15, asr r15
	eorgt	r0, r0, r0, ror 1
	eorgt	r15, r15, r15, ror 31
	eorgt	r0, r0, r0, ror r0
	eorgt	r15, r15, r15, ror r15
	eorgt	r0, r0, r0, rrx

positive: eorle instruction

	eorle	r0, r0, 0
	eorle	r15, r15, 0xff000000
	eorle	r0, r0, r0
	eorle	r15, r15, r15
	eorle	r0, r0, r0, lsl 0
	eorle	r15, r15, r15, lsl 31
	eorle	r0, r0, r0, lsl r0
	eorle	r15, r15, r15, lsl r15
	eorle	r0, r0, r0, lsr 1
	eorle	r15, r15, r15, lsr 32
	eorle	r0, r0, r0, lsr r0
	eorle	r15, r15, r15, asr r15
	eorle	r0, r0, r0, asr 1
	eorle	r15, r15, r15, asr 32
	eorle	r0, r0, r0, asr r0
	eorle	r15, r15, r15, asr r15
	eorle	r0, r0, r0, ror 1
	eorle	r15, r15, r15, ror 31
	eorle	r0, r0, r0, ror r0
	eorle	r15, r15, r15, ror r15
	eorle	r0, r0, r0, rrx

positive: eoral instruction

	eoral	r0, r0, 0
	eoral	r15, r15, 0xff000000
	eoral	r0, r0, r0
	eoral	r15, r15, r15
	eoral	r0, r0, r0, lsl 0
	eoral	r15, r15, r15, lsl 31
	eoral	r0, r0, r0, lsl r0
	eoral	r15, r15, r15, lsl r15
	eoral	r0, r0, r0, lsr 1
	eoral	r15, r15, r15, lsr 32
	eoral	r0, r0, r0, lsr r0
	eoral	r15, r15, r15, asr r15
	eoral	r0, r0, r0, asr 1
	eoral	r15, r15, r15, asr 32
	eoral	r0, r0, r0, asr r0
	eoral	r15, r15, r15, asr r15
	eoral	r0, r0, r0, ror 1
	eoral	r15, r15, r15, ror 31
	eoral	r0, r0, r0, ror r0
	eoral	r15, r15, r15, ror r15
	eoral	r0, r0, r0, rrx

positive: eors instruction

	eors	r0, r0, 0
	eors	r15, r15, 0xff000000
	eors	r0, r0, r0
	eors	r15, r15, r15
	eors	r0, r0, r0, lsl 0
	eors	r15, r15, r15, lsl 31
	eors	r0, r0, r0, lsl r0
	eors	r15, r15, r15, lsl r15
	eors	r0, r0, r0, lsr 1
	eors	r15, r15, r15, lsr 32
	eors	r0, r0, r0, lsr r0
	eors	r15, r15, r15, asr r15
	eors	r0, r0, r0, asr 1
	eors	r15, r15, r15, asr 32
	eors	r0, r0, r0, asr r0
	eors	r15, r15, r15, asr r15
	eors	r0, r0, r0, ror 1
	eors	r15, r15, r15, ror 31
	eors	r0, r0, r0, ror r0
	eors	r15, r15, r15, ror r15
	eors	r0, r0, r0, rrx

positive: eorseq instruction

	eorseq	r0, r0, 0
	eorseq	r15, r15, 0xff000000
	eorseq	r0, r0, r0
	eorseq	r15, r15, r15
	eorseq	r0, r0, r0, lsl 0
	eorseq	r15, r15, r15, lsl 31
	eorseq	r0, r0, r0, lsl r0
	eorseq	r15, r15, r15, lsl r15
	eorseq	r0, r0, r0, lsr 1
	eorseq	r15, r15, r15, lsr 32
	eorseq	r0, r0, r0, lsr r0
	eorseq	r15, r15, r15, asr r15
	eorseq	r0, r0, r0, asr 1
	eorseq	r15, r15, r15, asr 32
	eorseq	r0, r0, r0, asr r0
	eorseq	r15, r15, r15, asr r15
	eorseq	r0, r0, r0, ror 1
	eorseq	r15, r15, r15, ror 31
	eorseq	r0, r0, r0, ror r0
	eorseq	r15, r15, r15, ror r15
	eorseq	r0, r0, r0, rrx

positive: eorsne instruction

	eorsne	r0, r0, 0
	eorsne	r15, r15, 0xff000000
	eorsne	r0, r0, r0
	eorsne	r15, r15, r15
	eorsne	r0, r0, r0, lsl 0
	eorsne	r15, r15, r15, lsl 31
	eorsne	r0, r0, r0, lsl r0
	eorsne	r15, r15, r15, lsl r15
	eorsne	r0, r0, r0, lsr 1
	eorsne	r15, r15, r15, lsr 32
	eorsne	r0, r0, r0, lsr r0
	eorsne	r15, r15, r15, asr r15
	eorsne	r0, r0, r0, asr 1
	eorsne	r15, r15, r15, asr 32
	eorsne	r0, r0, r0, asr r0
	eorsne	r15, r15, r15, asr r15
	eorsne	r0, r0, r0, ror 1
	eorsne	r15, r15, r15, ror 31
	eorsne	r0, r0, r0, ror r0
	eorsne	r15, r15, r15, ror r15
	eorsne	r0, r0, r0, rrx

positive: eorscs instruction

	eorscs	r0, r0, 0
	eorscs	r15, r15, 0xff000000
	eorscs	r0, r0, r0
	eorscs	r15, r15, r15
	eorscs	r0, r0, r0, lsl 0
	eorscs	r15, r15, r15, lsl 31
	eorscs	r0, r0, r0, lsl r0
	eorscs	r15, r15, r15, lsl r15
	eorscs	r0, r0, r0, lsr 1
	eorscs	r15, r15, r15, lsr 32
	eorscs	r0, r0, r0, lsr r0
	eorscs	r15, r15, r15, asr r15
	eorscs	r0, r0, r0, asr 1
	eorscs	r15, r15, r15, asr 32
	eorscs	r0, r0, r0, asr r0
	eorscs	r15, r15, r15, asr r15
	eorscs	r0, r0, r0, ror 1
	eorscs	r15, r15, r15, ror 31
	eorscs	r0, r0, r0, ror r0
	eorscs	r15, r15, r15, ror r15
	eorscs	r0, r0, r0, rrx

positive: eorshs instruction

	eorshs	r0, r0, 0
	eorshs	r15, r15, 0xff000000
	eorshs	r0, r0, r0
	eorshs	r15, r15, r15
	eorshs	r0, r0, r0, lsl 0
	eorshs	r15, r15, r15, lsl 31
	eorshs	r0, r0, r0, lsl r0
	eorshs	r15, r15, r15, lsl r15
	eorshs	r0, r0, r0, lsr 1
	eorshs	r15, r15, r15, lsr 32
	eorshs	r0, r0, r0, lsr r0
	eorshs	r15, r15, r15, asr r15
	eorshs	r0, r0, r0, asr 1
	eorshs	r15, r15, r15, asr 32
	eorshs	r0, r0, r0, asr r0
	eorshs	r15, r15, r15, asr r15
	eorshs	r0, r0, r0, ror 1
	eorshs	r15, r15, r15, ror 31
	eorshs	r0, r0, r0, ror r0
	eorshs	r15, r15, r15, ror r15
	eorshs	r0, r0, r0, rrx

positive: eorscc instruction

	eorscc	r0, r0, 0
	eorscc	r15, r15, 0xff000000
	eorscc	r0, r0, r0
	eorscc	r15, r15, r15
	eorscc	r0, r0, r0, lsl 0
	eorscc	r15, r15, r15, lsl 31
	eorscc	r0, r0, r0, lsl r0
	eorscc	r15, r15, r15, lsl r15
	eorscc	r0, r0, r0, lsr 1
	eorscc	r15, r15, r15, lsr 32
	eorscc	r0, r0, r0, lsr r0
	eorscc	r15, r15, r15, asr r15
	eorscc	r0, r0, r0, asr 1
	eorscc	r15, r15, r15, asr 32
	eorscc	r0, r0, r0, asr r0
	eorscc	r15, r15, r15, asr r15
	eorscc	r0, r0, r0, ror 1
	eorscc	r15, r15, r15, ror 31
	eorscc	r0, r0, r0, ror r0
	eorscc	r15, r15, r15, ror r15
	eorscc	r0, r0, r0, rrx

positive: eorslo instruction

	eorslo	r0, r0, 0
	eorslo	r15, r15, 0xff000000
	eorslo	r0, r0, r0
	eorslo	r15, r15, r15
	eorslo	r0, r0, r0, lsl 0
	eorslo	r15, r15, r15, lsl 31
	eorslo	r0, r0, r0, lsl r0
	eorslo	r15, r15, r15, lsl r15
	eorslo	r0, r0, r0, lsr 1
	eorslo	r15, r15, r15, lsr 32
	eorslo	r0, r0, r0, lsr r0
	eorslo	r15, r15, r15, asr r15
	eorslo	r0, r0, r0, asr 1
	eorslo	r15, r15, r15, asr 32
	eorslo	r0, r0, r0, asr r0
	eorslo	r15, r15, r15, asr r15
	eorslo	r0, r0, r0, ror 1
	eorslo	r15, r15, r15, ror 31
	eorslo	r0, r0, r0, ror r0
	eorslo	r15, r15, r15, ror r15
	eorslo	r0, r0, r0, rrx

positive: eorsmi instruction

	eorsmi	r0, r0, 0
	eorsmi	r15, r15, 0xff000000
	eorsmi	r0, r0, r0
	eorsmi	r15, r15, r15
	eorsmi	r0, r0, r0, lsl 0
	eorsmi	r15, r15, r15, lsl 31
	eorsmi	r0, r0, r0, lsl r0
	eorsmi	r15, r15, r15, lsl r15
	eorsmi	r0, r0, r0, lsr 1
	eorsmi	r15, r15, r15, lsr 32
	eorsmi	r0, r0, r0, lsr r0
	eorsmi	r15, r15, r15, asr r15
	eorsmi	r0, r0, r0, asr 1
	eorsmi	r15, r15, r15, asr 32
	eorsmi	r0, r0, r0, asr r0
	eorsmi	r15, r15, r15, asr r15
	eorsmi	r0, r0, r0, ror 1
	eorsmi	r15, r15, r15, ror 31
	eorsmi	r0, r0, r0, ror r0
	eorsmi	r15, r15, r15, ror r15
	eorsmi	r0, r0, r0, rrx

positive: eorspl instruction

	eorspl	r0, r0, 0
	eorspl	r15, r15, 0xff000000
	eorspl	r0, r0, r0
	eorspl	r15, r15, r15
	eorspl	r0, r0, r0, lsl 0
	eorspl	r15, r15, r15, lsl 31
	eorspl	r0, r0, r0, lsl r0
	eorspl	r15, r15, r15, lsl r15
	eorspl	r0, r0, r0, lsr 1
	eorspl	r15, r15, r15, lsr 32
	eorspl	r0, r0, r0, lsr r0
	eorspl	r15, r15, r15, asr r15
	eorspl	r0, r0, r0, asr 1
	eorspl	r15, r15, r15, asr 32
	eorspl	r0, r0, r0, asr r0
	eorspl	r15, r15, r15, asr r15
	eorspl	r0, r0, r0, ror 1
	eorspl	r15, r15, r15, ror 31
	eorspl	r0, r0, r0, ror r0
	eorspl	r15, r15, r15, ror r15
	eorspl	r0, r0, r0, rrx

positive: eorsvs instruction

	eorsvs	r0, r0, 0
	eorsvs	r15, r15, 0xff000000
	eorsvs	r0, r0, r0
	eorsvs	r15, r15, r15
	eorsvs	r0, r0, r0, lsl 0
	eorsvs	r15, r15, r15, lsl 31
	eorsvs	r0, r0, r0, lsl r0
	eorsvs	r15, r15, r15, lsl r15
	eorsvs	r0, r0, r0, lsr 1
	eorsvs	r15, r15, r15, lsr 32
	eorsvs	r0, r0, r0, lsr r0
	eorsvs	r15, r15, r15, asr r15
	eorsvs	r0, r0, r0, asr 1
	eorsvs	r15, r15, r15, asr 32
	eorsvs	r0, r0, r0, asr r0
	eorsvs	r15, r15, r15, asr r15
	eorsvs	r0, r0, r0, ror 1
	eorsvs	r15, r15, r15, ror 31
	eorsvs	r0, r0, r0, ror r0
	eorsvs	r15, r15, r15, ror r15
	eorsvs	r0, r0, r0, rrx

positive: eorsvc instruction

	eorsvc	r0, r0, 0
	eorsvc	r15, r15, 0xff000000
	eorsvc	r0, r0, r0
	eorsvc	r15, r15, r15
	eorsvc	r0, r0, r0, lsl 0
	eorsvc	r15, r15, r15, lsl 31
	eorsvc	r0, r0, r0, lsl r0
	eorsvc	r15, r15, r15, lsl r15
	eorsvc	r0, r0, r0, lsr 1
	eorsvc	r15, r15, r15, lsr 32
	eorsvc	r0, r0, r0, lsr r0
	eorsvc	r15, r15, r15, asr r15
	eorsvc	r0, r0, r0, asr 1
	eorsvc	r15, r15, r15, asr 32
	eorsvc	r0, r0, r0, asr r0
	eorsvc	r15, r15, r15, asr r15
	eorsvc	r0, r0, r0, ror 1
	eorsvc	r15, r15, r15, ror 31
	eorsvc	r0, r0, r0, ror r0
	eorsvc	r15, r15, r15, ror r15
	eorsvc	r0, r0, r0, rrx

positive: eorshi instruction

	eorshi	r0, r0, 0
	eorshi	r15, r15, 0xff000000
	eorshi	r0, r0, r0
	eorshi	r15, r15, r15
	eorshi	r0, r0, r0, lsl 0
	eorshi	r15, r15, r15, lsl 31
	eorshi	r0, r0, r0, lsl r0
	eorshi	r15, r15, r15, lsl r15
	eorshi	r0, r0, r0, lsr 1
	eorshi	r15, r15, r15, lsr 32
	eorshi	r0, r0, r0, lsr r0
	eorshi	r15, r15, r15, asr r15
	eorshi	r0, r0, r0, asr 1
	eorshi	r15, r15, r15, asr 32
	eorshi	r0, r0, r0, asr r0
	eorshi	r15, r15, r15, asr r15
	eorshi	r0, r0, r0, ror 1
	eorshi	r15, r15, r15, ror 31
	eorshi	r0, r0, r0, ror r0
	eorshi	r15, r15, r15, ror r15
	eorshi	r0, r0, r0, rrx

positive: eorsls instruction

	eorsls	r0, r0, 0
	eorsls	r15, r15, 0xff000000
	eorsls	r0, r0, r0
	eorsls	r15, r15, r15
	eorsls	r0, r0, r0, lsl 0
	eorsls	r15, r15, r15, lsl 31
	eorsls	r0, r0, r0, lsl r0
	eorsls	r15, r15, r15, lsl r15
	eorsls	r0, r0, r0, lsr 1
	eorsls	r15, r15, r15, lsr 32
	eorsls	r0, r0, r0, lsr r0
	eorsls	r15, r15, r15, asr r15
	eorsls	r0, r0, r0, asr 1
	eorsls	r15, r15, r15, asr 32
	eorsls	r0, r0, r0, asr r0
	eorsls	r15, r15, r15, asr r15
	eorsls	r0, r0, r0, ror 1
	eorsls	r15, r15, r15, ror 31
	eorsls	r0, r0, r0, ror r0
	eorsls	r15, r15, r15, ror r15
	eorsls	r0, r0, r0, rrx

positive: eorsge instruction

	eorsge	r0, r0, 0
	eorsge	r15, r15, 0xff000000
	eorsge	r0, r0, r0
	eorsge	r15, r15, r15
	eorsge	r0, r0, r0, lsl 0
	eorsge	r15, r15, r15, lsl 31
	eorsge	r0, r0, r0, lsl r0
	eorsge	r15, r15, r15, lsl r15
	eorsge	r0, r0, r0, lsr 1
	eorsge	r15, r15, r15, lsr 32
	eorsge	r0, r0, r0, lsr r0
	eorsge	r15, r15, r15, asr r15
	eorsge	r0, r0, r0, asr 1
	eorsge	r15, r15, r15, asr 32
	eorsge	r0, r0, r0, asr r0
	eorsge	r15, r15, r15, asr r15
	eorsge	r0, r0, r0, ror 1
	eorsge	r15, r15, r15, ror 31
	eorsge	r0, r0, r0, ror r0
	eorsge	r15, r15, r15, ror r15
	eorsge	r0, r0, r0, rrx

positive: eorslt instruction

	eorslt	r0, r0, 0
	eorslt	r15, r15, 0xff000000
	eorslt	r0, r0, r0
	eorslt	r15, r15, r15
	eorslt	r0, r0, r0, lsl 0
	eorslt	r15, r15, r15, lsl 31
	eorslt	r0, r0, r0, lsl r0
	eorslt	r15, r15, r15, lsl r15
	eorslt	r0, r0, r0, lsr 1
	eorslt	r15, r15, r15, lsr 32
	eorslt	r0, r0, r0, lsr r0
	eorslt	r15, r15, r15, asr r15
	eorslt	r0, r0, r0, asr 1
	eorslt	r15, r15, r15, asr 32
	eorslt	r0, r0, r0, asr r0
	eorslt	r15, r15, r15, asr r15
	eorslt	r0, r0, r0, ror 1
	eorslt	r15, r15, r15, ror 31
	eorslt	r0, r0, r0, ror r0
	eorslt	r15, r15, r15, ror r15
	eorslt	r0, r0, r0, rrx

positive: eorsgt instruction

	eorsgt	r0, r0, 0
	eorsgt	r15, r15, 0xff000000
	eorsgt	r0, r0, r0
	eorsgt	r15, r15, r15
	eorsgt	r0, r0, r0, lsl 0
	eorsgt	r15, r15, r15, lsl 31
	eorsgt	r0, r0, r0, lsl r0
	eorsgt	r15, r15, r15, lsl r15
	eorsgt	r0, r0, r0, lsr 1
	eorsgt	r15, r15, r15, lsr 32
	eorsgt	r0, r0, r0, lsr r0
	eorsgt	r15, r15, r15, asr r15
	eorsgt	r0, r0, r0, asr 1
	eorsgt	r15, r15, r15, asr 32
	eorsgt	r0, r0, r0, asr r0
	eorsgt	r15, r15, r15, asr r15
	eorsgt	r0, r0, r0, ror 1
	eorsgt	r15, r15, r15, ror 31
	eorsgt	r0, r0, r0, ror r0
	eorsgt	r15, r15, r15, ror r15
	eorsgt	r0, r0, r0, rrx

positive: eorsle instruction

	eorsle	r0, r0, 0
	eorsle	r15, r15, 0xff000000
	eorsle	r0, r0, r0
	eorsle	r15, r15, r15
	eorsle	r0, r0, r0, lsl 0
	eorsle	r15, r15, r15, lsl 31
	eorsle	r0, r0, r0, lsl r0
	eorsle	r15, r15, r15, lsl r15
	eorsle	r0, r0, r0, lsr 1
	eorsle	r15, r15, r15, lsr 32
	eorsle	r0, r0, r0, lsr r0
	eorsle	r15, r15, r15, asr r15
	eorsle	r0, r0, r0, asr 1
	eorsle	r15, r15, r15, asr 32
	eorsle	r0, r0, r0, asr r0
	eorsle	r15, r15, r15, asr r15
	eorsle	r0, r0, r0, ror 1
	eorsle	r15, r15, r15, ror 31
	eorsle	r0, r0, r0, ror r0
	eorsle	r15, r15, r15, ror r15
	eorsle	r0, r0, r0, rrx

positive: eorsal instruction

	eorsal	r0, r0, 0
	eorsal	r15, r15, 0xff000000
	eorsal	r0, r0, r0
	eorsal	r15, r15, r15
	eorsal	r0, r0, r0, lsl 0
	eorsal	r15, r15, r15, lsl 31
	eorsal	r0, r0, r0, lsl r0
	eorsal	r15, r15, r15, lsl r15
	eorsal	r0, r0, r0, lsr 1
	eorsal	r15, r15, r15, lsr 32
	eorsal	r0, r0, r0, lsr r0
	eorsal	r15, r15, r15, asr r15
	eorsal	r0, r0, r0, asr 1
	eorsal	r15, r15, r15, asr 32
	eorsal	r0, r0, r0, asr r0
	eorsal	r15, r15, r15, asr r15
	eorsal	r0, r0, r0, ror 1
	eorsal	r15, r15, r15, ror 31
	eorsal	r0, r0, r0, ror r0
	eorsal	r15, r15, r15, ror r15
	eorsal	r0, r0, r0, rrx

positive: hlt instruction

	hlt	0
	hlt	65535

positive: isb instruction

	isb
	isb	0
	isb	15

positive: ldc instruction

	ldc	p0, c0, [r0, -1020]
	ldc	p15, c15, [r15, +1020]
	ldc	p0, c0, [r0, -1020] !
	ldc	p15, c15, [r15, +1020] !
	ldc	p0, c0, [r0], -1020
	ldc	p15, c15, [r15], +1020
	ldc	p0, c0, [r0], {0}
	ldc	p15, c15, [r15], {255}

positive: ldceq instruction

	ldceq	p0, c0, [r0, -1020]
	ldceq	p15, c15, [r15, +1020]
	ldceq	p0, c0, [r0, -1020] !
	ldceq	p15, c15, [r15, +1020] !
	ldceq	p0, c0, [r0], -1020
	ldceq	p15, c15, [r15], +1020
	ldceq	p0, c0, [r0], {0}
	ldceq	p15, c15, [r15], {255}

positive: ldcne instruction

	ldcne	p0, c0, [r0, -1020]
	ldcne	p15, c15, [r15, +1020]
	ldcne	p0, c0, [r0, -1020] !
	ldcne	p15, c15, [r15, +1020] !
	ldcne	p0, c0, [r0], -1020
	ldcne	p15, c15, [r15], +1020
	ldcne	p0, c0, [r0], {0}
	ldcne	p15, c15, [r15], {255}

positive: ldccs instruction

	ldccs	p0, c0, [r0, -1020]
	ldccs	p15, c15, [r15, +1020]
	ldccs	p0, c0, [r0, -1020] !
	ldccs	p15, c15, [r15, +1020] !
	ldccs	p0, c0, [r0], -1020
	ldccs	p15, c15, [r15], +1020
	ldccs	p0, c0, [r0], {0}
	ldccs	p15, c15, [r15], {255}

positive: ldchs instruction

	ldchs	p0, c0, [r0, -1020]
	ldchs	p15, c15, [r15, +1020]
	ldchs	p0, c0, [r0, -1020] !
	ldchs	p15, c15, [r15, +1020] !
	ldchs	p0, c0, [r0], -1020
	ldchs	p15, c15, [r15], +1020
	ldchs	p0, c0, [r0], {0}
	ldchs	p15, c15, [r15], {255}

positive: ldccc instruction

	ldccc	p0, c0, [r0, -1020]
	ldccc	p15, c15, [r15, +1020]
	ldccc	p0, c0, [r0, -1020] !
	ldccc	p15, c15, [r15, +1020] !
	ldccc	p0, c0, [r0], -1020
	ldccc	p15, c15, [r15], +1020
	ldccc	p0, c0, [r0], {0}
	ldccc	p15, c15, [r15], {255}

positive: ldclo instruction

	ldclo	p0, c0, [r0, -1020]
	ldclo	p15, c15, [r15, +1020]
	ldclo	p0, c0, [r0, -1020] !
	ldclo	p15, c15, [r15, +1020] !
	ldclo	p0, c0, [r0], -1020
	ldclo	p15, c15, [r15], +1020
	ldclo	p0, c0, [r0], {0}
	ldclo	p15, c15, [r15], {255}

positive: ldcmi instruction

	ldcmi	p0, c0, [r0, -1020]
	ldcmi	p15, c15, [r15, +1020]
	ldcmi	p0, c0, [r0, -1020] !
	ldcmi	p15, c15, [r15, +1020] !
	ldcmi	p0, c0, [r0], -1020
	ldcmi	p15, c15, [r15], +1020
	ldcmi	p0, c0, [r0], {0}
	ldcmi	p15, c15, [r15], {255}

positive: ldcpl instruction

	ldcpl	p0, c0, [r0, -1020]
	ldcpl	p15, c15, [r15, +1020]
	ldcpl	p0, c0, [r0, -1020] !
	ldcpl	p15, c15, [r15, +1020] !
	ldcpl	p0, c0, [r0], -1020
	ldcpl	p15, c15, [r15], +1020
	ldcpl	p0, c0, [r0], {0}
	ldcpl	p15, c15, [r15], {255}

positive: ldcvs instruction

	ldcvs	p0, c0, [r0, -1020]
	ldcvs	p15, c15, [r15, +1020]
	ldcvs	p0, c0, [r0, -1020] !
	ldcvs	p15, c15, [r15, +1020] !
	ldcvs	p0, c0, [r0], -1020
	ldcvs	p15, c15, [r15], +1020
	ldcvs	p0, c0, [r0], {0}
	ldcvs	p15, c15, [r15], {255}

positive: ldcvc instruction

	ldcvc	p0, c0, [r0, -1020]
	ldcvc	p15, c15, [r15, +1020]
	ldcvc	p0, c0, [r0, -1020] !
	ldcvc	p15, c15, [r15, +1020] !
	ldcvc	p0, c0, [r0], -1020
	ldcvc	p15, c15, [r15], +1020
	ldcvc	p0, c0, [r0], {0}
	ldcvc	p15, c15, [r15], {255}

positive: ldchi instruction

	ldchi	p0, c0, [r0, -1020]
	ldchi	p15, c15, [r15, +1020]
	ldchi	p0, c0, [r0, -1020] !
	ldchi	p15, c15, [r15, +1020] !
	ldchi	p0, c0, [r0], -1020
	ldchi	p15, c15, [r15], +1020
	ldchi	p0, c0, [r0], {0}
	ldchi	p15, c15, [r15], {255}

positive: ldcls instruction

	ldcls	p0, c0, [r0, -1020]
	ldcls	p15, c15, [r15, +1020]
	ldcls	p0, c0, [r0, -1020] !
	ldcls	p15, c15, [r15, +1020] !
	ldcls	p0, c0, [r0], -1020
	ldcls	p15, c15, [r15], +1020
	ldcls	p0, c0, [r0], {0}
	ldcls	p15, c15, [r15], {255}

positive: ldcge instruction

	ldcge	p0, c0, [r0, -1020]
	ldcge	p15, c15, [r15, +1020]
	ldcge	p0, c0, [r0, -1020] !
	ldcge	p15, c15, [r15, +1020] !
	ldcge	p0, c0, [r0], -1020
	ldcge	p15, c15, [r15], +1020
	ldcge	p0, c0, [r0], {0}
	ldcge	p15, c15, [r15], {255}

positive: ldclt instruction

	ldclt	p0, c0, [r0, -1020]
	ldclt	p15, c15, [r15, +1020]
	ldclt	p0, c0, [r0, -1020] !
	ldclt	p15, c15, [r15, +1020] !
	ldclt	p0, c0, [r0], -1020
	ldclt	p15, c15, [r15], +1020
	ldclt	p0, c0, [r0], {0}
	ldclt	p15, c15, [r15], {255}

positive: ldcgt instruction

	ldcgt	p0, c0, [r0, -1020]
	ldcgt	p15, c15, [r15, +1020]
	ldcgt	p0, c0, [r0, -1020] !
	ldcgt	p15, c15, [r15, +1020] !
	ldcgt	p0, c0, [r0], -1020
	ldcgt	p15, c15, [r15], +1020
	ldcgt	p0, c0, [r0], {0}
	ldcgt	p15, c15, [r15], {255}

positive: ldcle instruction

	ldcle	p0, c0, [r0, -1020]
	ldcle	p15, c15, [r15, +1020]
	ldcle	p0, c0, [r0, -1020] !
	ldcle	p15, c15, [r15, +1020] !
	ldcle	p0, c0, [r0], -1020
	ldcle	p15, c15, [r15], +1020
	ldcle	p0, c0, [r0], {0}
	ldcle	p15, c15, [r15], {255}

positive: ldcal instruction

	ldcal	p0, c0, [r0, -1020]
	ldcal	p15, c15, [r15, +1020]
	ldcal	p0, c0, [r0, -1020] !
	ldcal	p15, c15, [r15, +1020] !
	ldcal	p0, c0, [r0], -1020
	ldcal	p15, c15, [r15], +1020
	ldcal	p0, c0, [r0], {0}
	ldcal	p15, c15, [r15], {255}

positive: ldcl instruction

	ldcl	p0, c0, [r0, -1020]
	ldcl	p15, c15, [r15, +1020]
	ldcl	p0, c0, [r0, -1020] !
	ldcl	p15, c15, [r15, +1020] !
	ldcl	p0, c0, [r0], -1020
	ldcl	p15, c15, [r15], +1020
	ldcl	p0, c0, [r0], {0}
	ldcl	p15, c15, [r15], {255}

positive: ldcleq instruction

	ldcleq	p0, c0, [r0, -1020]
	ldcleq	p15, c15, [r15, +1020]
	ldcleq	p0, c0, [r0, -1020] !
	ldcleq	p15, c15, [r15, +1020] !
	ldcleq	p0, c0, [r0], -1020
	ldcleq	p15, c15, [r15], +1020
	ldcleq	p0, c0, [r0], {0}
	ldcleq	p15, c15, [r15], {255}

positive: ldclne instruction

	ldclne	p0, c0, [r0, -1020]
	ldclne	p15, c15, [r15, +1020]
	ldclne	p0, c0, [r0, -1020] !
	ldclne	p15, c15, [r15, +1020] !
	ldclne	p0, c0, [r0], -1020
	ldclne	p15, c15, [r15], +1020
	ldclne	p0, c0, [r0], {0}
	ldclne	p15, c15, [r15], {255}

positive: ldclcs instruction

	ldclcs	p0, c0, [r0, -1020]
	ldclcs	p15, c15, [r15, +1020]
	ldclcs	p0, c0, [r0, -1020] !
	ldclcs	p15, c15, [r15, +1020] !
	ldclcs	p0, c0, [r0], -1020
	ldclcs	p15, c15, [r15], +1020
	ldclcs	p0, c0, [r0], {0}
	ldclcs	p15, c15, [r15], {255}

positive: ldclhs instruction

	ldclhs	p0, c0, [r0, -1020]
	ldclhs	p15, c15, [r15, +1020]
	ldclhs	p0, c0, [r0, -1020] !
	ldclhs	p15, c15, [r15, +1020] !
	ldclhs	p0, c0, [r0], -1020
	ldclhs	p15, c15, [r15], +1020
	ldclhs	p0, c0, [r0], {0}
	ldclhs	p15, c15, [r15], {255}

positive: ldclcc instruction

	ldclcc	p0, c0, [r0, -1020]
	ldclcc	p15, c15, [r15, +1020]
	ldclcc	p0, c0, [r0, -1020] !
	ldclcc	p15, c15, [r15, +1020] !
	ldclcc	p0, c0, [r0], -1020
	ldclcc	p15, c15, [r15], +1020
	ldclcc	p0, c0, [r0], {0}
	ldclcc	p15, c15, [r15], {255}

positive: ldcllo instruction

	ldcllo	p0, c0, [r0, -1020]
	ldcllo	p15, c15, [r15, +1020]
	ldcllo	p0, c0, [r0, -1020] !
	ldcllo	p15, c15, [r15, +1020] !
	ldcllo	p0, c0, [r0], -1020
	ldcllo	p15, c15, [r15], +1020
	ldcllo	p0, c0, [r0], {0}
	ldcllo	p15, c15, [r15], {255}

positive: ldclmi instruction

	ldclmi	p0, c0, [r0, -1020]
	ldclmi	p15, c15, [r15, +1020]
	ldclmi	p0, c0, [r0, -1020] !
	ldclmi	p15, c15, [r15, +1020] !
	ldclmi	p0, c0, [r0], -1020
	ldclmi	p15, c15, [r15], +1020
	ldclmi	p0, c0, [r0], {0}
	ldclmi	p15, c15, [r15], {255}

positive: ldclpl instruction

	ldclpl	p0, c0, [r0, -1020]
	ldclpl	p15, c15, [r15, +1020]
	ldclpl	p0, c0, [r0, -1020] !
	ldclpl	p15, c15, [r15, +1020] !
	ldclpl	p0, c0, [r0], -1020
	ldclpl	p15, c15, [r15], +1020
	ldclpl	p0, c0, [r0], {0}
	ldclpl	p15, c15, [r15], {255}

positive: ldclvs instruction

	ldclvs	p0, c0, [r0, -1020]
	ldclvs	p15, c15, [r15, +1020]
	ldclvs	p0, c0, [r0, -1020] !
	ldclvs	p15, c15, [r15, +1020] !
	ldclvs	p0, c0, [r0], -1020
	ldclvs	p15, c15, [r15], +1020
	ldclvs	p0, c0, [r0], {0}
	ldclvs	p15, c15, [r15], {255}

positive: ldclvc instruction

	ldclvc	p0, c0, [r0, -1020]
	ldclvc	p15, c15, [r15, +1020]
	ldclvc	p0, c0, [r0, -1020] !
	ldclvc	p15, c15, [r15, +1020] !
	ldclvc	p0, c0, [r0], -1020
	ldclvc	p15, c15, [r15], +1020
	ldclvc	p0, c0, [r0], {0}
	ldclvc	p15, c15, [r15], {255}

positive: ldclhi instruction

	ldclhi	p0, c0, [r0, -1020]
	ldclhi	p15, c15, [r15, +1020]
	ldclhi	p0, c0, [r0, -1020] !
	ldclhi	p15, c15, [r15, +1020] !
	ldclhi	p0, c0, [r0], -1020
	ldclhi	p15, c15, [r15], +1020
	ldclhi	p0, c0, [r0], {0}
	ldclhi	p15, c15, [r15], {255}

positive: ldclls instruction

	ldclls	p0, c0, [r0, -1020]
	ldclls	p15, c15, [r15, +1020]
	ldclls	p0, c0, [r0, -1020] !
	ldclls	p15, c15, [r15, +1020] !
	ldclls	p0, c0, [r0], -1020
	ldclls	p15, c15, [r15], +1020
	ldclls	p0, c0, [r0], {0}
	ldclls	p15, c15, [r15], {255}

positive: ldclge instruction

	ldclge	p0, c0, [r0, -1020]
	ldclge	p15, c15, [r15, +1020]
	ldclge	p0, c0, [r0, -1020] !
	ldclge	p15, c15, [r15, +1020] !
	ldclge	p0, c0, [r0], -1020
	ldclge	p15, c15, [r15], +1020
	ldclge	p0, c0, [r0], {0}
	ldclge	p15, c15, [r15], {255}

positive: ldcllt instruction

	ldcllt	p0, c0, [r0, -1020]
	ldcllt	p15, c15, [r15, +1020]
	ldcllt	p0, c0, [r0, -1020] !
	ldcllt	p15, c15, [r15, +1020] !
	ldcllt	p0, c0, [r0], -1020
	ldcllt	p15, c15, [r15], +1020
	ldcllt	p0, c0, [r0], {0}
	ldcllt	p15, c15, [r15], {255}

positive: ldclgt instruction

	ldclgt	p0, c0, [r0, -1020]
	ldclgt	p15, c15, [r15, +1020]
	ldclgt	p0, c0, [r0, -1020] !
	ldclgt	p15, c15, [r15, +1020] !
	ldclgt	p0, c0, [r0], -1020
	ldclgt	p15, c15, [r15], +1020
	ldclgt	p0, c0, [r0], {0}
	ldclgt	p15, c15, [r15], {255}

positive: ldclle instruction

	ldclle	p0, c0, [r0, -1020]
	ldclle	p15, c15, [r15, +1020]
	ldclle	p0, c0, [r0, -1020] !
	ldclle	p15, c15, [r15, +1020] !
	ldclle	p0, c0, [r0], -1020
	ldclle	p15, c15, [r15], +1020
	ldclle	p0, c0, [r0], {0}
	ldclle	p15, c15, [r15], {255}

positive: ldclal instruction

	ldclal	p0, c0, [r0, -1020]
	ldclal	p15, c15, [r15, +1020]
	ldclal	p0, c0, [r0, -1020] !
	ldclal	p15, c15, [r15, +1020] !
	ldclal	p0, c0, [r0], -1020
	ldclal	p15, c15, [r15], +1020
	ldclal	p0, c0, [r0], {0}
	ldclal	p15, c15, [r15], {255}

positive: ldc2 instruction

	ldc2	p0, c0, [r0, -1020]
	ldc2	p15, c15, [r15, +1020]
	ldc2	p0, c0, [r0, -1020] !
	ldc2	p15, c15, [r15, +1020] !
	ldc2	p0, c0, [r0], -1020
	ldc2	p15, c15, [r15], +1020
	ldc2	p0, c0, [r0], {0}
	ldc2	p15, c15, [r15], {255}

positive: ldc2l instruction

	ldc2l	p0, c0, [r0, -1020]
	ldc2l	p15, c15, [r15, +1020]
	ldc2l	p0, c0, [r0, -1020] !
	ldc2l	p15, c15, [r15, +1020] !
	ldc2l	p0, c0, [r0], -1020
	ldc2l	p15, c15, [r15], +1020
	ldc2l	p0, c0, [r0], {0}
	ldc2l	p15, c15, [r15], {255}

positive: ldmia instruction

	ldmia	r0, {}
	ldmia	r15, {r0, r15}
	ldmia	r0 !, {}
	ldmia	r15 !, {r0, r15}
	ldmia	r0, {} ^
	ldmia	r0, {r0, r14} ^
	ldmia	r0, {pc} ^
	ldmia	r0, {r0, r14, pc} ^
	ldmia	r0 !, {pc} ^
	ldmia	r0 !, {r0, r14, pc} ^

positive: ldmiaeq instruction

	ldmiaeq	r0, {}
	ldmiaeq	r15, {r0, r15}
	ldmiaeq	r0 !, {}
	ldmiaeq	r15 !, {r0, r15}
	ldmiaeq	r0, {} ^
	ldmiaeq	r0, {r0, r14} ^
	ldmiaeq	r0, {pc} ^
	ldmiaeq	r0, {r0, r14, pc} ^
	ldmiaeq	r0 !, {pc} ^
	ldmiaeq	r0 !, {r0, r14, pc} ^

positive: ldmiane instruction

	ldmiane	r0, {}
	ldmiane	r15, {r0, r15}
	ldmiane	r0 !, {}
	ldmiane	r15 !, {r0, r15}
	ldmiane	r0, {} ^
	ldmiane	r0, {r0, r14} ^
	ldmiane	r0, {pc} ^
	ldmiane	r0, {r0, r14, pc} ^
	ldmiane	r0 !, {pc} ^
	ldmiane	r0 !, {r0, r14, pc} ^

positive: ldmiacs instruction

	ldmiacs	r0, {}
	ldmiacs	r15, {r0, r15}
	ldmiacs	r0 !, {}
	ldmiacs	r15 !, {r0, r15}
	ldmiacs	r0, {} ^
	ldmiacs	r0, {r0, r14} ^
	ldmiacs	r0, {pc} ^
	ldmiacs	r0, {r0, r14, pc} ^
	ldmiacs	r0 !, {pc} ^
	ldmiacs	r0 !, {r0, r14, pc} ^

positive: ldmiahs instruction

	ldmiahs	r0, {}
	ldmiahs	r15, {r0, r15}
	ldmiahs	r0 !, {}
	ldmiahs	r15 !, {r0, r15}
	ldmiahs	r0, {} ^
	ldmiahs	r0, {r0, r14} ^
	ldmiahs	r0, {pc} ^
	ldmiahs	r0, {r0, r14, pc} ^
	ldmiahs	r0 !, {pc} ^
	ldmiahs	r0 !, {r0, r14, pc} ^

positive: ldmiacc instruction

	ldmiacc	r0, {}
	ldmiacc	r15, {r0, r15}
	ldmiacc	r0 !, {}
	ldmiacc	r15 !, {r0, r15}
	ldmiacc	r0, {} ^
	ldmiacc	r0, {r0, r14} ^
	ldmiacc	r0, {pc} ^
	ldmiacc	r0, {r0, r14, pc} ^
	ldmiacc	r0 !, {pc} ^
	ldmiacc	r0 !, {r0, r14, pc} ^

positive: ldmialo instruction

	ldmialo	r0, {}
	ldmialo	r15, {r0, r15}
	ldmialo	r0 !, {}
	ldmialo	r15 !, {r0, r15}
	ldmialo	r0, {} ^
	ldmialo	r0, {r0, r14} ^
	ldmialo	r0, {pc} ^
	ldmialo	r0, {r0, r14, pc} ^
	ldmialo	r0 !, {pc} ^
	ldmialo	r0 !, {r0, r14, pc} ^

positive: ldmiami instruction

	ldmiami	r0, {}
	ldmiami	r15, {r0, r15}
	ldmiami	r0 !, {}
	ldmiami	r15 !, {r0, r15}
	ldmiami	r0, {} ^
	ldmiami	r0, {r0, r14} ^
	ldmiami	r0, {pc} ^
	ldmiami	r0, {r0, r14, pc} ^
	ldmiami	r0 !, {pc} ^
	ldmiami	r0 !, {r0, r14, pc} ^

positive: ldmiapl instruction

	ldmiapl	r0, {}
	ldmiapl	r15, {r0, r15}
	ldmiapl	r0 !, {}
	ldmiapl	r15 !, {r0, r15}
	ldmiapl	r0, {} ^
	ldmiapl	r0, {r0, r14} ^
	ldmiapl	r0, {pc} ^
	ldmiapl	r0, {r0, r14, pc} ^
	ldmiapl	r0 !, {pc} ^
	ldmiapl	r0 !, {r0, r14, pc} ^

positive: ldmiavs instruction

	ldmiavs	r0, {}
	ldmiavs	r15, {r0, r15}
	ldmiavs	r0 !, {}
	ldmiavs	r15 !, {r0, r15}
	ldmiavs	r0, {} ^
	ldmiavs	r0, {r0, r14} ^
	ldmiavs	r0, {pc} ^
	ldmiavs	r0, {r0, r14, pc} ^
	ldmiavs	r0 !, {pc} ^
	ldmiavs	r0 !, {r0, r14, pc} ^

positive: ldmiavc instruction

	ldmiavc	r0, {}
	ldmiavc	r15, {r0, r15}
	ldmiavc	r0 !, {}
	ldmiavc	r15 !, {r0, r15}
	ldmiavc	r0, {} ^
	ldmiavc	r0, {r0, r14} ^
	ldmiavc	r0, {pc} ^
	ldmiavc	r0, {r0, r14, pc} ^
	ldmiavc	r0 !, {pc} ^
	ldmiavc	r0 !, {r0, r14, pc} ^

positive: ldmiahi instruction

	ldmiahi	r0, {}
	ldmiahi	r15, {r0, r15}
	ldmiahi	r0 !, {}
	ldmiahi	r15 !, {r0, r15}
	ldmiahi	r0, {} ^
	ldmiahi	r0, {r0, r14} ^
	ldmiahi	r0, {pc} ^
	ldmiahi	r0, {r0, r14, pc} ^
	ldmiahi	r0 !, {pc} ^
	ldmiahi	r0 !, {r0, r14, pc} ^

positive: ldmials instruction

	ldmials	r0, {}
	ldmials	r15, {r0, r15}
	ldmials	r0 !, {}
	ldmials	r15 !, {r0, r15}
	ldmials	r0, {} ^
	ldmials	r0, {r0, r14} ^
	ldmials	r0, {pc} ^
	ldmials	r0, {r0, r14, pc} ^
	ldmials	r0 !, {pc} ^
	ldmials	r0 !, {r0, r14, pc} ^

positive: ldmiage instruction

	ldmiage	r0, {}
	ldmiage	r15, {r0, r15}
	ldmiage	r0 !, {}
	ldmiage	r15 !, {r0, r15}
	ldmiage	r0, {} ^
	ldmiage	r0, {r0, r14} ^
	ldmiage	r0, {pc} ^
	ldmiage	r0, {r0, r14, pc} ^
	ldmiage	r0 !, {pc} ^
	ldmiage	r0 !, {r0, r14, pc} ^

positive: ldmialt instruction

	ldmialt	r0, {}
	ldmialt	r15, {r0, r15}
	ldmialt	r0 !, {}
	ldmialt	r15 !, {r0, r15}
	ldmialt	r0, {} ^
	ldmialt	r0, {r0, r14} ^
	ldmialt	r0, {pc} ^
	ldmialt	r0, {r0, r14, pc} ^
	ldmialt	r0 !, {pc} ^
	ldmialt	r0 !, {r0, r14, pc} ^

positive: ldmiagt instruction

	ldmiagt	r0, {}
	ldmiagt	r15, {r0, r15}
	ldmiagt	r0 !, {}
	ldmiagt	r15 !, {r0, r15}
	ldmiagt	r0, {} ^
	ldmiagt	r0, {r0, r14} ^
	ldmiagt	r0, {pc} ^
	ldmiagt	r0, {r0, r14, pc} ^
	ldmiagt	r0 !, {pc} ^
	ldmiagt	r0 !, {r0, r14, pc} ^

positive: ldmiale instruction

	ldmiale	r0, {}
	ldmiale	r15, {r0, r15}
	ldmiale	r0 !, {}
	ldmiale	r15 !, {r0, r15}
	ldmiale	r0, {} ^
	ldmiale	r0, {r0, r14} ^
	ldmiale	r0, {pc} ^
	ldmiale	r0, {r0, r14, pc} ^
	ldmiale	r0 !, {pc} ^
	ldmiale	r0 !, {r0, r14, pc} ^

positive: ldmiaal instruction

	ldmiaal	r0, {}
	ldmiaal	r15, {r0, r15}
	ldmiaal	r0 !, {}
	ldmiaal	r15 !, {r0, r15}
	ldmiaal	r0, {} ^
	ldmiaal	r0, {r0, r14} ^
	ldmiaal	r0, {pc} ^
	ldmiaal	r0, {r0, r14, pc} ^
	ldmiaal	r0 !, {pc} ^
	ldmiaal	r0 !, {r0, r14, pc} ^

positive: ldmib instruction

	ldmib	r0, {}
	ldmib	r15, {r0, r15}
	ldmib	r0 !, {}
	ldmib	r15 !, {r0, r15}
	ldmib	r0, {} ^
	ldmib	r0, {r0, r14} ^
	ldmib	r0, {pc} ^
	ldmib	r0, {r0, r14, pc} ^
	ldmib	r0 !, {pc} ^
	ldmib	r0 !, {r0, r14, pc} ^

positive: ldmibeq instruction

	ldmibeq	r0, {}
	ldmibeq	r15, {r0, r15}
	ldmibeq	r0 !, {}
	ldmibeq	r15 !, {r0, r15}
	ldmibeq	r0, {} ^
	ldmibeq	r0, {r0, r14} ^
	ldmibeq	r0, {pc} ^
	ldmibeq	r0, {r0, r14, pc} ^
	ldmibeq	r0 !, {pc} ^
	ldmibeq	r0 !, {r0, r14, pc} ^

positive: ldmibne instruction

	ldmibne	r0, {}
	ldmibne	r15, {r0, r15}
	ldmibne	r0 !, {}
	ldmibne	r15 !, {r0, r15}
	ldmibne	r0, {} ^
	ldmibne	r0, {r0, r14} ^
	ldmibne	r0, {pc} ^
	ldmibne	r0, {r0, r14, pc} ^
	ldmibne	r0 !, {pc} ^
	ldmibne	r0 !, {r0, r14, pc} ^

positive: ldmibcs instruction

	ldmibcs	r0, {}
	ldmibcs	r15, {r0, r15}
	ldmibcs	r0 !, {}
	ldmibcs	r15 !, {r0, r15}
	ldmibcs	r0, {} ^
	ldmibcs	r0, {r0, r14} ^
	ldmibcs	r0, {pc} ^
	ldmibcs	r0, {r0, r14, pc} ^
	ldmibcs	r0 !, {pc} ^
	ldmibcs	r0 !, {r0, r14, pc} ^

positive: ldmibhs instruction

	ldmibhs	r0, {}
	ldmibhs	r15, {r0, r15}
	ldmibhs	r0 !, {}
	ldmibhs	r15 !, {r0, r15}
	ldmibhs	r0, {} ^
	ldmibhs	r0, {r0, r14} ^
	ldmibhs	r0, {pc} ^
	ldmibhs	r0, {r0, r14, pc} ^
	ldmibhs	r0 !, {pc} ^
	ldmibhs	r0 !, {r0, r14, pc} ^

positive: ldmibcc instruction

	ldmibcc	r0, {}
	ldmibcc	r15, {r0, r15}
	ldmibcc	r0 !, {}
	ldmibcc	r15 !, {r0, r15}
	ldmibcc	r0, {} ^
	ldmibcc	r0, {r0, r14} ^
	ldmibcc	r0, {pc} ^
	ldmibcc	r0, {r0, r14, pc} ^
	ldmibcc	r0 !, {pc} ^
	ldmibcc	r0 !, {r0, r14, pc} ^

positive: ldmiblo instruction

	ldmiblo	r0, {}
	ldmiblo	r15, {r0, r15}
	ldmiblo	r0 !, {}
	ldmiblo	r15 !, {r0, r15}
	ldmiblo	r0, {} ^
	ldmiblo	r0, {r0, r14} ^
	ldmiblo	r0, {pc} ^
	ldmiblo	r0, {r0, r14, pc} ^
	ldmiblo	r0 !, {pc} ^
	ldmiblo	r0 !, {r0, r14, pc} ^

positive: ldmibmi instruction

	ldmibmi	r0, {}
	ldmibmi	r15, {r0, r15}
	ldmibmi	r0 !, {}
	ldmibmi	r15 !, {r0, r15}
	ldmibmi	r0, {} ^
	ldmibmi	r0, {r0, r14} ^
	ldmibmi	r0, {pc} ^
	ldmibmi	r0, {r0, r14, pc} ^
	ldmibmi	r0 !, {pc} ^
	ldmibmi	r0 !, {r0, r14, pc} ^

positive: ldmibpl instruction

	ldmibpl	r0, {}
	ldmibpl	r15, {r0, r15}
	ldmibpl	r0 !, {}
	ldmibpl	r15 !, {r0, r15}
	ldmibpl	r0, {} ^
	ldmibpl	r0, {r0, r14} ^
	ldmibpl	r0, {pc} ^
	ldmibpl	r0, {r0, r14, pc} ^
	ldmibpl	r0 !, {pc} ^
	ldmibpl	r0 !, {r0, r14, pc} ^

positive: ldmibvs instruction

	ldmibvs	r0, {}
	ldmibvs	r15, {r0, r15}
	ldmibvs	r0 !, {}
	ldmibvs	r15 !, {r0, r15}
	ldmibvs	r0, {} ^
	ldmibvs	r0, {r0, r14} ^
	ldmibvs	r0, {pc} ^
	ldmibvs	r0, {r0, r14, pc} ^
	ldmibvs	r0 !, {pc} ^
	ldmibvs	r0 !, {r0, r14, pc} ^

positive: ldmibvc instruction

	ldmibvc	r0, {}
	ldmibvc	r15, {r0, r15}
	ldmibvc	r0 !, {}
	ldmibvc	r15 !, {r0, r15}
	ldmibvc	r0, {} ^
	ldmibvc	r0, {r0, r14} ^
	ldmibvc	r0, {pc} ^
	ldmibvc	r0, {r0, r14, pc} ^
	ldmibvc	r0 !, {pc} ^
	ldmibvc	r0 !, {r0, r14, pc} ^

positive: ldmibhi instruction

	ldmibhi	r0, {}
	ldmibhi	r15, {r0, r15}
	ldmibhi	r0 !, {}
	ldmibhi	r15 !, {r0, r15}
	ldmibhi	r0, {} ^
	ldmibhi	r0, {r0, r14} ^
	ldmibhi	r0, {pc} ^
	ldmibhi	r0, {r0, r14, pc} ^
	ldmibhi	r0 !, {pc} ^
	ldmibhi	r0 !, {r0, r14, pc} ^

positive: ldmibls instruction

	ldmibls	r0, {}
	ldmibls	r15, {r0, r15}
	ldmibls	r0 !, {}
	ldmibls	r15 !, {r0, r15}
	ldmibls	r0, {} ^
	ldmibls	r0, {r0, r14} ^
	ldmibls	r0, {pc} ^
	ldmibls	r0, {r0, r14, pc} ^
	ldmibls	r0 !, {pc} ^
	ldmibls	r0 !, {r0, r14, pc} ^

positive: ldmibge instruction

	ldmibge	r0, {}
	ldmibge	r15, {r0, r15}
	ldmibge	r0 !, {}
	ldmibge	r15 !, {r0, r15}
	ldmibge	r0, {} ^
	ldmibge	r0, {r0, r14} ^
	ldmibge	r0, {pc} ^
	ldmibge	r0, {r0, r14, pc} ^
	ldmibge	r0 !, {pc} ^
	ldmibge	r0 !, {r0, r14, pc} ^

positive: ldmiblt instruction

	ldmiblt	r0, {}
	ldmiblt	r15, {r0, r15}
	ldmiblt	r0 !, {}
	ldmiblt	r15 !, {r0, r15}
	ldmiblt	r0, {} ^
	ldmiblt	r0, {r0, r14} ^
	ldmiblt	r0, {pc} ^
	ldmiblt	r0, {r0, r14, pc} ^
	ldmiblt	r0 !, {pc} ^
	ldmiblt	r0 !, {r0, r14, pc} ^

positive: ldmibgt instruction

	ldmibgt	r0, {}
	ldmibgt	r15, {r0, r15}
	ldmibgt	r0 !, {}
	ldmibgt	r15 !, {r0, r15}
	ldmibgt	r0, {} ^
	ldmibgt	r0, {r0, r14} ^
	ldmibgt	r0, {pc} ^
	ldmibgt	r0, {r0, r14, pc} ^
	ldmibgt	r0 !, {pc} ^
	ldmibgt	r0 !, {r0, r14, pc} ^

positive: ldmible instruction

	ldmible	r0, {}
	ldmible	r15, {r0, r15}
	ldmible	r0 !, {}
	ldmible	r15 !, {r0, r15}
	ldmible	r0, {} ^
	ldmible	r0, {r0, r14} ^
	ldmible	r0, {pc} ^
	ldmible	r0, {r0, r14, pc} ^
	ldmible	r0 !, {pc} ^
	ldmible	r0 !, {r0, r14, pc} ^

positive: ldmibal instruction

	ldmibal	r0, {}
	ldmibal	r15, {r0, r15}
	ldmibal	r0 !, {}
	ldmibal	r15 !, {r0, r15}
	ldmibal	r0, {} ^
	ldmibal	r0, {r0, r14} ^
	ldmibal	r0, {pc} ^
	ldmibal	r0, {r0, r14, pc} ^
	ldmibal	r0 !, {pc} ^
	ldmibal	r0 !, {r0, r14, pc} ^

positive: ldmda instruction

	ldmda	r0, {}
	ldmda	r15, {r0, r15}
	ldmda	r0 !, {}
	ldmda	r15 !, {r0, r15}
	ldmda	r0, {} ^
	ldmda	r0, {r0, r14} ^
	ldmda	r0, {pc} ^
	ldmda	r0, {r0, r14, pc} ^
	ldmda	r0 !, {pc} ^
	ldmda	r0 !, {r0, r14, pc} ^

positive: ldmdaeq instruction

	ldmdaeq	r0, {}
	ldmdaeq	r15, {r0, r15}
	ldmdaeq	r0 !, {}
	ldmdaeq	r15 !, {r0, r15}
	ldmdaeq	r0, {} ^
	ldmdaeq	r0, {r0, r14} ^
	ldmdaeq	r0, {pc} ^
	ldmdaeq	r0, {r0, r14, pc} ^
	ldmdaeq	r0 !, {pc} ^
	ldmdaeq	r0 !, {r0, r14, pc} ^

positive: ldmdane instruction

	ldmdane	r0, {}
	ldmdane	r15, {r0, r15}
	ldmdane	r0 !, {}
	ldmdane	r15 !, {r0, r15}
	ldmdane	r0, {} ^
	ldmdane	r0, {r0, r14} ^
	ldmdane	r0, {pc} ^
	ldmdane	r0, {r0, r14, pc} ^
	ldmdane	r0 !, {pc} ^
	ldmdane	r0 !, {r0, r14, pc} ^

positive: ldmdacs instruction

	ldmdacs	r0, {}
	ldmdacs	r15, {r0, r15}
	ldmdacs	r0 !, {}
	ldmdacs	r15 !, {r0, r15}
	ldmdacs	r0, {} ^
	ldmdacs	r0, {r0, r14} ^
	ldmdacs	r0, {pc} ^
	ldmdacs	r0, {r0, r14, pc} ^
	ldmdacs	r0 !, {pc} ^
	ldmdacs	r0 !, {r0, r14, pc} ^

positive: ldmdahs instruction

	ldmdahs	r0, {}
	ldmdahs	r15, {r0, r15}
	ldmdahs	r0 !, {}
	ldmdahs	r15 !, {r0, r15}
	ldmdahs	r0, {} ^
	ldmdahs	r0, {r0, r14} ^
	ldmdahs	r0, {pc} ^
	ldmdahs	r0, {r0, r14, pc} ^
	ldmdahs	r0 !, {pc} ^
	ldmdahs	r0 !, {r0, r14, pc} ^

positive: ldmdacc instruction

	ldmdacc	r0, {}
	ldmdacc	r15, {r0, r15}
	ldmdacc	r0 !, {}
	ldmdacc	r15 !, {r0, r15}
	ldmdacc	r0, {} ^
	ldmdacc	r0, {r0, r14} ^
	ldmdacc	r0, {pc} ^
	ldmdacc	r0, {r0, r14, pc} ^
	ldmdacc	r0 !, {pc} ^
	ldmdacc	r0 !, {r0, r14, pc} ^

positive: ldmdalo instruction

	ldmdalo	r0, {}
	ldmdalo	r15, {r0, r15}
	ldmdalo	r0 !, {}
	ldmdalo	r15 !, {r0, r15}
	ldmdalo	r0, {} ^
	ldmdalo	r0, {r0, r14} ^
	ldmdalo	r0, {pc} ^
	ldmdalo	r0, {r0, r14, pc} ^
	ldmdalo	r0 !, {pc} ^
	ldmdalo	r0 !, {r0, r14, pc} ^

positive: ldmdami instruction

	ldmdami	r0, {}
	ldmdami	r15, {r0, r15}
	ldmdami	r0 !, {}
	ldmdami	r15 !, {r0, r15}
	ldmdami	r0, {} ^
	ldmdami	r0, {r0, r14} ^
	ldmdami	r0, {pc} ^
	ldmdami	r0, {r0, r14, pc} ^
	ldmdami	r0 !, {pc} ^
	ldmdami	r0 !, {r0, r14, pc} ^

positive: ldmdapl instruction

	ldmdapl	r0, {}
	ldmdapl	r15, {r0, r15}
	ldmdapl	r0 !, {}
	ldmdapl	r15 !, {r0, r15}
	ldmdapl	r0, {} ^
	ldmdapl	r0, {r0, r14} ^
	ldmdapl	r0, {pc} ^
	ldmdapl	r0, {r0, r14, pc} ^
	ldmdapl	r0 !, {pc} ^
	ldmdapl	r0 !, {r0, r14, pc} ^

positive: ldmdavs instruction

	ldmdavs	r0, {}
	ldmdavs	r15, {r0, r15}
	ldmdavs	r0 !, {}
	ldmdavs	r15 !, {r0, r15}
	ldmdavs	r0, {} ^
	ldmdavs	r0, {r0, r14} ^
	ldmdavs	r0, {pc} ^
	ldmdavs	r0, {r0, r14, pc} ^
	ldmdavs	r0 !, {pc} ^
	ldmdavs	r0 !, {r0, r14, pc} ^

positive: ldmdavc instruction

	ldmdavc	r0, {}
	ldmdavc	r15, {r0, r15}
	ldmdavc	r0 !, {}
	ldmdavc	r15 !, {r0, r15}
	ldmdavc	r0, {} ^
	ldmdavc	r0, {r0, r14} ^
	ldmdavc	r0, {pc} ^
	ldmdavc	r0, {r0, r14, pc} ^
	ldmdavc	r0 !, {pc} ^
	ldmdavc	r0 !, {r0, r14, pc} ^

positive: ldmdahi instruction

	ldmdahi	r0, {}
	ldmdahi	r15, {r0, r15}
	ldmdahi	r0 !, {}
	ldmdahi	r15 !, {r0, r15}
	ldmdahi	r0, {} ^
	ldmdahi	r0, {r0, r14} ^
	ldmdahi	r0, {pc} ^
	ldmdahi	r0, {r0, r14, pc} ^
	ldmdahi	r0 !, {pc} ^
	ldmdahi	r0 !, {r0, r14, pc} ^

positive: ldmdals instruction

	ldmdals	r0, {}
	ldmdals	r15, {r0, r15}
	ldmdals	r0 !, {}
	ldmdals	r15 !, {r0, r15}
	ldmdals	r0, {} ^
	ldmdals	r0, {r0, r14} ^
	ldmdals	r0, {pc} ^
	ldmdals	r0, {r0, r14, pc} ^
	ldmdals	r0 !, {pc} ^
	ldmdals	r0 !, {r0, r14, pc} ^

positive: ldmdage instruction

	ldmdage	r0, {}
	ldmdage	r15, {r0, r15}
	ldmdage	r0 !, {}
	ldmdage	r15 !, {r0, r15}
	ldmdage	r0, {} ^
	ldmdage	r0, {r0, r14} ^
	ldmdage	r0, {pc} ^
	ldmdage	r0, {r0, r14, pc} ^
	ldmdage	r0 !, {pc} ^
	ldmdage	r0 !, {r0, r14, pc} ^

positive: ldmdalt instruction

	ldmdalt	r0, {}
	ldmdalt	r15, {r0, r15}
	ldmdalt	r0 !, {}
	ldmdalt	r15 !, {r0, r15}
	ldmdalt	r0, {} ^
	ldmdalt	r0, {r0, r14} ^
	ldmdalt	r0, {pc} ^
	ldmdalt	r0, {r0, r14, pc} ^
	ldmdalt	r0 !, {pc} ^
	ldmdalt	r0 !, {r0, r14, pc} ^

positive: ldmdagt instruction

	ldmdagt	r0, {}
	ldmdagt	r15, {r0, r15}
	ldmdagt	r0 !, {}
	ldmdagt	r15 !, {r0, r15}
	ldmdagt	r0, {} ^
	ldmdagt	r0, {r0, r14} ^
	ldmdagt	r0, {pc} ^
	ldmdagt	r0, {r0, r14, pc} ^
	ldmdagt	r0 !, {pc} ^
	ldmdagt	r0 !, {r0, r14, pc} ^

positive: ldmdale instruction

	ldmdale	r0, {}
	ldmdale	r15, {r0, r15}
	ldmdale	r0 !, {}
	ldmdale	r15 !, {r0, r15}
	ldmdale	r0, {} ^
	ldmdale	r0, {r0, r14} ^
	ldmdale	r0, {pc} ^
	ldmdale	r0, {r0, r14, pc} ^
	ldmdale	r0 !, {pc} ^
	ldmdale	r0 !, {r0, r14, pc} ^

positive: ldmdaal instruction

	ldmdaal	r0, {}
	ldmdaal	r15, {r0, r15}
	ldmdaal	r0 !, {}
	ldmdaal	r15 !, {r0, r15}
	ldmdaal	r0, {} ^
	ldmdaal	r0, {r0, r14} ^
	ldmdaal	r0, {pc} ^
	ldmdaal	r0, {r0, r14, pc} ^
	ldmdaal	r0 !, {pc} ^
	ldmdaal	r0 !, {r0, r14, pc} ^

positive: ldmdb instruction

	ldmdb	r0, {}
	ldmdb	r15, {r0, r15}
	ldmdb	r0 !, {}
	ldmdb	r15 !, {r0, r15}
	ldmdb	r0, {} ^
	ldmdb	r0, {r0, r14} ^
	ldmdb	r0, {pc} ^
	ldmdb	r0, {r0, r14, pc} ^
	ldmdb	r0 !, {pc} ^
	ldmdb	r0 !, {r0, r14, pc} ^

positive: ldmdbeq instruction

	ldmdbeq	r0, {}
	ldmdbeq	r15, {r0, r15}
	ldmdbeq	r0 !, {}
	ldmdbeq	r15 !, {r0, r15}
	ldmdbeq	r0, {} ^
	ldmdbeq	r0, {r0, r14} ^
	ldmdbeq	r0, {pc} ^
	ldmdbeq	r0, {r0, r14, pc} ^
	ldmdbeq	r0 !, {pc} ^
	ldmdbeq	r0 !, {r0, r14, pc} ^

positive: ldmdbne instruction

	ldmdbne	r0, {}
	ldmdbne	r15, {r0, r15}
	ldmdbne	r0 !, {}
	ldmdbne	r15 !, {r0, r15}
	ldmdbne	r0, {} ^
	ldmdbne	r0, {r0, r14} ^
	ldmdbne	r0, {pc} ^
	ldmdbne	r0, {r0, r14, pc} ^
	ldmdbne	r0 !, {pc} ^
	ldmdbne	r0 !, {r0, r14, pc} ^

positive: ldmdbcs instruction

	ldmdbcs	r0, {}
	ldmdbcs	r15, {r0, r15}
	ldmdbcs	r0 !, {}
	ldmdbcs	r15 !, {r0, r15}
	ldmdbcs	r0, {} ^
	ldmdbcs	r0, {r0, r14} ^
	ldmdbcs	r0, {pc} ^
	ldmdbcs	r0, {r0, r14, pc} ^
	ldmdbcs	r0 !, {pc} ^
	ldmdbcs	r0 !, {r0, r14, pc} ^

positive: ldmdbhs instruction

	ldmdbhs	r0, {}
	ldmdbhs	r15, {r0, r15}
	ldmdbhs	r0 !, {}
	ldmdbhs	r15 !, {r0, r15}
	ldmdbhs	r0, {} ^
	ldmdbhs	r0, {r0, r14} ^
	ldmdbhs	r0, {pc} ^
	ldmdbhs	r0, {r0, r14, pc} ^
	ldmdbhs	r0 !, {pc} ^
	ldmdbhs	r0 !, {r0, r14, pc} ^

positive: ldmdbcc instruction

	ldmdbcc	r0, {}
	ldmdbcc	r15, {r0, r15}
	ldmdbcc	r0 !, {}
	ldmdbcc	r15 !, {r0, r15}
	ldmdbcc	r0, {} ^
	ldmdbcc	r0, {r0, r14} ^
	ldmdbcc	r0, {pc} ^
	ldmdbcc	r0, {r0, r14, pc} ^
	ldmdbcc	r0 !, {pc} ^
	ldmdbcc	r0 !, {r0, r14, pc} ^

positive: ldmdblo instruction

	ldmdblo	r0, {}
	ldmdblo	r15, {r0, r15}
	ldmdblo	r0 !, {}
	ldmdblo	r15 !, {r0, r15}
	ldmdblo	r0, {} ^
	ldmdblo	r0, {r0, r14} ^
	ldmdblo	r0, {pc} ^
	ldmdblo	r0, {r0, r14, pc} ^
	ldmdblo	r0 !, {pc} ^
	ldmdblo	r0 !, {r0, r14, pc} ^

positive: ldmdbmi instruction

	ldmdbmi	r0, {}
	ldmdbmi	r15, {r0, r15}
	ldmdbmi	r0 !, {}
	ldmdbmi	r15 !, {r0, r15}
	ldmdbmi	r0, {} ^
	ldmdbmi	r0, {r0, r14} ^
	ldmdbmi	r0, {pc} ^
	ldmdbmi	r0, {r0, r14, pc} ^
	ldmdbmi	r0 !, {pc} ^
	ldmdbmi	r0 !, {r0, r14, pc} ^

positive: ldmdbpl instruction

	ldmdbpl	r0, {}
	ldmdbpl	r15, {r0, r15}
	ldmdbpl	r0 !, {}
	ldmdbpl	r15 !, {r0, r15}
	ldmdbpl	r0, {} ^
	ldmdbpl	r0, {r0, r14} ^
	ldmdbpl	r0, {pc} ^
	ldmdbpl	r0, {r0, r14, pc} ^
	ldmdbpl	r0 !, {pc} ^
	ldmdbpl	r0 !, {r0, r14, pc} ^

positive: ldmdbvs instruction

	ldmdbvs	r0, {}
	ldmdbvs	r15, {r0, r15}
	ldmdbvs	r0 !, {}
	ldmdbvs	r15 !, {r0, r15}
	ldmdbvs	r0, {} ^
	ldmdbvs	r0, {r0, r14} ^
	ldmdbvs	r0, {pc} ^
	ldmdbvs	r0, {r0, r14, pc} ^
	ldmdbvs	r0 !, {pc} ^
	ldmdbvs	r0 !, {r0, r14, pc} ^

positive: ldmdbvc instruction

	ldmdbvc	r0, {}
	ldmdbvc	r15, {r0, r15}
	ldmdbvc	r0 !, {}
	ldmdbvc	r15 !, {r0, r15}
	ldmdbvc	r0, {} ^
	ldmdbvc	r0, {r0, r14} ^
	ldmdbvc	r0, {pc} ^
	ldmdbvc	r0, {r0, r14, pc} ^
	ldmdbvc	r0 !, {pc} ^
	ldmdbvc	r0 !, {r0, r14, pc} ^

positive: ldmdbhi instruction

	ldmdbhi	r0, {}
	ldmdbhi	r15, {r0, r15}
	ldmdbhi	r0 !, {}
	ldmdbhi	r15 !, {r0, r15}
	ldmdbhi	r0, {} ^
	ldmdbhi	r0, {r0, r14} ^
	ldmdbhi	r0, {pc} ^
	ldmdbhi	r0, {r0, r14, pc} ^
	ldmdbhi	r0 !, {pc} ^
	ldmdbhi	r0 !, {r0, r14, pc} ^

positive: ldmdbls instruction

	ldmdbls	r0, {}
	ldmdbls	r15, {r0, r15}
	ldmdbls	r0 !, {}
	ldmdbls	r15 !, {r0, r15}
	ldmdbls	r0, {} ^
	ldmdbls	r0, {r0, r14} ^
	ldmdbls	r0, {pc} ^
	ldmdbls	r0, {r0, r14, pc} ^
	ldmdbls	r0 !, {pc} ^
	ldmdbls	r0 !, {r0, r14, pc} ^

positive: ldmdbge instruction

	ldmdbge	r0, {}
	ldmdbge	r15, {r0, r15}
	ldmdbge	r0 !, {}
	ldmdbge	r15 !, {r0, r15}
	ldmdbge	r0, {} ^
	ldmdbge	r0, {r0, r14} ^
	ldmdbge	r0, {pc} ^
	ldmdbge	r0, {r0, r14, pc} ^
	ldmdbge	r0 !, {pc} ^
	ldmdbge	r0 !, {r0, r14, pc} ^

positive: ldmdblt instruction

	ldmdblt	r0, {}
	ldmdblt	r15, {r0, r15}
	ldmdblt	r0 !, {}
	ldmdblt	r15 !, {r0, r15}
	ldmdblt	r0, {} ^
	ldmdblt	r0, {r0, r14} ^
	ldmdblt	r0, {pc} ^
	ldmdblt	r0, {r0, r14, pc} ^
	ldmdblt	r0 !, {pc} ^
	ldmdblt	r0 !, {r0, r14, pc} ^

positive: ldmdbgt instruction

	ldmdbgt	r0, {}
	ldmdbgt	r15, {r0, r15}
	ldmdbgt	r0 !, {}
	ldmdbgt	r15 !, {r0, r15}
	ldmdbgt	r0, {} ^
	ldmdbgt	r0, {r0, r14} ^
	ldmdbgt	r0, {pc} ^
	ldmdbgt	r0, {r0, r14, pc} ^
	ldmdbgt	r0 !, {pc} ^
	ldmdbgt	r0 !, {r0, r14, pc} ^

positive: ldmdble instruction

	ldmdble	r0, {}
	ldmdble	r15, {r0, r15}
	ldmdble	r0 !, {}
	ldmdble	r15 !, {r0, r15}
	ldmdble	r0, {} ^
	ldmdble	r0, {r0, r14} ^
	ldmdble	r0, {pc} ^
	ldmdble	r0, {r0, r14, pc} ^
	ldmdble	r0 !, {pc} ^
	ldmdble	r0 !, {r0, r14, pc} ^

positive: ldmdbal instruction

	ldmdbal	r0, {}
	ldmdbal	r15, {r0, r15}
	ldmdbal	r0 !, {}
	ldmdbal	r15 !, {r0, r15}
	ldmdbal	r0, {} ^
	ldmdbal	r0, {r0, r14} ^
	ldmdbal	r0, {pc} ^
	ldmdbal	r0, {r0, r14, pc} ^
	ldmdbal	r0 !, {pc} ^
	ldmdbal	r0 !, {r0, r14, pc} ^

positive: ldr instruction

	ldr	r0, [r0, -4095]
	ldr	r15, [r15, +4095]
	ldr	r0, [r0, -r0]
	ldr	r15, [r15, +r15]
	ldr	r0, [r1, r2, lsl 0]
	ldr	r15, [r15, r15, lsl 31]
	ldr	r0, [r1, r2, lsr 1]
	ldr	r15, [r15, r15, lsr 32]
	ldr	r0, [r1, r2, asr 1]
	ldr	r15, [r15, r15, asr 32]
	ldr	r0, [r1, r2, ror 1]
	ldr	r15, [r15, r15, ror 31]
	ldr	r0, [r1, r2, rrx]
	ldr	r15, [r15, r15, rrx]
	ldr	r0, [r0, -4095] !
	ldr	r15, [r15, +4095] !
	ldr	r0, [r0, -r0] !
	ldr	r15, [r15, +r15] !
	ldr	r0, [r1, r2, lsl 0] !
	ldr	r15, [r15, r15, lsl 31] !
	ldr	r0, [r1, r2, lsr 1] !
	ldr	r15, [r15, r15, lsr 32] !
	ldr	r0, [r1, r2, asr 1] !
	ldr	r15, [r15, r15, asr 32] !
	ldr	r0, [r1, r2, ror 1] !
	ldr	r15, [r15, r15, ror 31] !
	ldr	r0, [r1, r2, rrx] !
	ldr	r15, [r15, r15, rrx] !
	ldr	r0, [r0], -4095
	ldr	r15, [r15], +4095
	ldr	r0, [r0], -r0
	ldr	r15, [r15], +r15
	ldr	r0, [r1], r2, lsl 0
	ldr	r15, [r15], r15, lsl 31
	ldr	r0, [r1], r2, lsr 1
	ldr	r15, [r15], r15, lsr 32
	ldr	r0, [r1], r2, asr 1
	ldr	r15, [r15], r15, asr 32
	ldr	r0, [r1], r2, ror 1
	ldr	r15, [r15], r15, ror 31
	ldr	r0, [r1], r2, rrx
	ldr	r15, [r15], r15, rrx

positive: ldreq instruction

	ldreq	r0, [r0, -4095]
	ldreq	r15, [r15, +4095]
	ldreq	r0, [r0, -r0]
	ldreq	r15, [r15, +r15]
	ldreq	r0, [r1, r2, lsl 0]
	ldreq	r15, [r15, r15, lsl 31]
	ldreq	r0, [r1, r2, lsr 1]
	ldreq	r15, [r15, r15, lsr 32]
	ldreq	r0, [r1, r2, asr 1]
	ldreq	r15, [r15, r15, asr 32]
	ldreq	r0, [r1, r2, ror 1]
	ldreq	r15, [r15, r15, ror 31]
	ldreq	r0, [r1, r2, rrx]
	ldreq	r15, [r15, r15, rrx]
	ldreq	r0, [r0, -4095] !
	ldreq	r15, [r15, +4095] !
	ldreq	r0, [r0, -r0] !
	ldreq	r15, [r15, +r15] !
	ldreq	r0, [r1, r2, lsl 0] !
	ldreq	r15, [r15, r15, lsl 31] !
	ldreq	r0, [r1, r2, lsr 1] !
	ldreq	r15, [r15, r15, lsr 32] !
	ldreq	r0, [r1, r2, asr 1] !
	ldreq	r15, [r15, r15, asr 32] !
	ldreq	r0, [r1, r2, ror 1] !
	ldreq	r15, [r15, r15, ror 31] !
	ldreq	r0, [r1, r2, rrx] !
	ldreq	r15, [r15, r15, rrx] !
	ldreq	r0, [r0], -4095
	ldreq	r15, [r15], +4095
	ldreq	r0, [r0], -r0
	ldreq	r15, [r15], +r15
	ldreq	r0, [r1], r2, lsl 0
	ldreq	r15, [r15], r15, lsl 31
	ldreq	r0, [r1], r2, lsr 1
	ldreq	r15, [r15], r15, lsr 32
	ldreq	r0, [r1], r2, asr 1
	ldreq	r15, [r15], r15, asr 32
	ldreq	r0, [r1], r2, ror 1
	ldreq	r15, [r15], r15, ror 31
	ldreq	r0, [r1], r2, rrx
	ldreq	r15, [r15], r15, rrx

positive: ldrne instruction

	ldrne	r0, [r0, -4095]
	ldrne	r15, [r15, +4095]
	ldrne	r0, [r0, -r0]
	ldrne	r15, [r15, +r15]
	ldrne	r0, [r1, r2, lsl 0]
	ldrne	r15, [r15, r15, lsl 31]
	ldrne	r0, [r1, r2, lsr 1]
	ldrne	r15, [r15, r15, lsr 32]
	ldrne	r0, [r1, r2, asr 1]
	ldrne	r15, [r15, r15, asr 32]
	ldrne	r0, [r1, r2, ror 1]
	ldrne	r15, [r15, r15, ror 31]
	ldrne	r0, [r1, r2, rrx]
	ldrne	r15, [r15, r15, rrx]
	ldrne	r0, [r0, -4095] !
	ldrne	r15, [r15, +4095] !
	ldrne	r0, [r0, -r0] !
	ldrne	r15, [r15, +r15] !
	ldrne	r0, [r1, r2, lsl 0] !
	ldrne	r15, [r15, r15, lsl 31] !
	ldrne	r0, [r1, r2, lsr 1] !
	ldrne	r15, [r15, r15, lsr 32] !
	ldrne	r0, [r1, r2, asr 1] !
	ldrne	r15, [r15, r15, asr 32] !
	ldrne	r0, [r1, r2, ror 1] !
	ldrne	r15, [r15, r15, ror 31] !
	ldrne	r0, [r1, r2, rrx] !
	ldrne	r15, [r15, r15, rrx] !
	ldrne	r0, [r0], -4095
	ldrne	r15, [r15], +4095
	ldrne	r0, [r0], -r0
	ldrne	r15, [r15], +r15
	ldrne	r0, [r1], r2, lsl 0
	ldrne	r15, [r15], r15, lsl 31
	ldrne	r0, [r1], r2, lsr 1
	ldrne	r15, [r15], r15, lsr 32
	ldrne	r0, [r1], r2, asr 1
	ldrne	r15, [r15], r15, asr 32
	ldrne	r0, [r1], r2, ror 1
	ldrne	r15, [r15], r15, ror 31
	ldrne	r0, [r1], r2, rrx
	ldrne	r15, [r15], r15, rrx

positive: ldrcs instruction

	ldrcs	r0, [r0, -4095]
	ldrcs	r15, [r15, +4095]
	ldrcs	r0, [r0, -r0]
	ldrcs	r15, [r15, +r15]
	ldrcs	r0, [r1, r2, lsl 0]
	ldrcs	r15, [r15, r15, lsl 31]
	ldrcs	r0, [r1, r2, lsr 1]
	ldrcs	r15, [r15, r15, lsr 32]
	ldrcs	r0, [r1, r2, asr 1]
	ldrcs	r15, [r15, r15, asr 32]
	ldrcs	r0, [r1, r2, ror 1]
	ldrcs	r15, [r15, r15, ror 31]
	ldrcs	r0, [r1, r2, rrx]
	ldrcs	r15, [r15, r15, rrx]
	ldrcs	r0, [r0, -4095] !
	ldrcs	r15, [r15, +4095] !
	ldrcs	r0, [r0, -r0] !
	ldrcs	r15, [r15, +r15] !
	ldrcs	r0, [r1, r2, lsl 0] !
	ldrcs	r15, [r15, r15, lsl 31] !
	ldrcs	r0, [r1, r2, lsr 1] !
	ldrcs	r15, [r15, r15, lsr 32] !
	ldrcs	r0, [r1, r2, asr 1] !
	ldrcs	r15, [r15, r15, asr 32] !
	ldrcs	r0, [r1, r2, ror 1] !
	ldrcs	r15, [r15, r15, ror 31] !
	ldrcs	r0, [r1, r2, rrx] !
	ldrcs	r15, [r15, r15, rrx] !
	ldrcs	r0, [r0], -4095
	ldrcs	r15, [r15], +4095
	ldrcs	r0, [r0], -r0
	ldrcs	r15, [r15], +r15
	ldrcs	r0, [r1], r2, lsl 0
	ldrcs	r15, [r15], r15, lsl 31
	ldrcs	r0, [r1], r2, lsr 1
	ldrcs	r15, [r15], r15, lsr 32
	ldrcs	r0, [r1], r2, asr 1
	ldrcs	r15, [r15], r15, asr 32
	ldrcs	r0, [r1], r2, ror 1
	ldrcs	r15, [r15], r15, ror 31
	ldrcs	r0, [r1], r2, rrx
	ldrcs	r15, [r15], r15, rrx

positive: ldrhs instruction

	ldrhs	r0, [r0, -4095]
	ldrhs	r15, [r15, +4095]
	ldrhs	r0, [r0, -r0]
	ldrhs	r15, [r15, +r15]
	ldrhs	r0, [r1, r2, lsl 0]
	ldrhs	r15, [r15, r15, lsl 31]
	ldrhs	r0, [r1, r2, lsr 1]
	ldrhs	r15, [r15, r15, lsr 32]
	ldrhs	r0, [r1, r2, asr 1]
	ldrhs	r15, [r15, r15, asr 32]
	ldrhs	r0, [r1, r2, ror 1]
	ldrhs	r15, [r15, r15, ror 31]
	ldrhs	r0, [r1, r2, rrx]
	ldrhs	r15, [r15, r15, rrx]
	ldrhs	r0, [r0, -4095] !
	ldrhs	r15, [r15, +4095] !
	ldrhs	r0, [r0, -r0] !
	ldrhs	r15, [r15, +r15] !
	ldrhs	r0, [r1, r2, lsl 0] !
	ldrhs	r15, [r15, r15, lsl 31] !
	ldrhs	r0, [r1, r2, lsr 1] !
	ldrhs	r15, [r15, r15, lsr 32] !
	ldrhs	r0, [r1, r2, asr 1] !
	ldrhs	r15, [r15, r15, asr 32] !
	ldrhs	r0, [r1, r2, ror 1] !
	ldrhs	r15, [r15, r15, ror 31] !
	ldrhs	r0, [r1, r2, rrx] !
	ldrhs	r15, [r15, r15, rrx] !
	ldrhs	r0, [r0], -4095
	ldrhs	r15, [r15], +4095
	ldrhs	r0, [r0], -r0
	ldrhs	r15, [r15], +r15
	ldrhs	r0, [r1], r2, lsl 0
	ldrhs	r15, [r15], r15, lsl 31
	ldrhs	r0, [r1], r2, lsr 1
	ldrhs	r15, [r15], r15, lsr 32
	ldrhs	r0, [r1], r2, asr 1
	ldrhs	r15, [r15], r15, asr 32
	ldrhs	r0, [r1], r2, ror 1
	ldrhs	r15, [r15], r15, ror 31
	ldrhs	r0, [r1], r2, rrx
	ldrhs	r15, [r15], r15, rrx

positive: ldrcc instruction

	ldrcc	r0, [r0, -4095]
	ldrcc	r15, [r15, +4095]
	ldrcc	r0, [r0, -r0]
	ldrcc	r15, [r15, +r15]
	ldrcc	r0, [r1, r2, lsl 0]
	ldrcc	r15, [r15, r15, lsl 31]
	ldrcc	r0, [r1, r2, lsr 1]
	ldrcc	r15, [r15, r15, lsr 32]
	ldrcc	r0, [r1, r2, asr 1]
	ldrcc	r15, [r15, r15, asr 32]
	ldrcc	r0, [r1, r2, ror 1]
	ldrcc	r15, [r15, r15, ror 31]
	ldrcc	r0, [r1, r2, rrx]
	ldrcc	r15, [r15, r15, rrx]
	ldrcc	r0, [r0, -4095] !
	ldrcc	r15, [r15, +4095] !
	ldrcc	r0, [r0, -r0] !
	ldrcc	r15, [r15, +r15] !
	ldrcc	r0, [r1, r2, lsl 0] !
	ldrcc	r15, [r15, r15, lsl 31] !
	ldrcc	r0, [r1, r2, lsr 1] !
	ldrcc	r15, [r15, r15, lsr 32] !
	ldrcc	r0, [r1, r2, asr 1] !
	ldrcc	r15, [r15, r15, asr 32] !
	ldrcc	r0, [r1, r2, ror 1] !
	ldrcc	r15, [r15, r15, ror 31] !
	ldrcc	r0, [r1, r2, rrx] !
	ldrcc	r15, [r15, r15, rrx] !
	ldrcc	r0, [r0], -4095
	ldrcc	r15, [r15], +4095
	ldrcc	r0, [r0], -r0
	ldrcc	r15, [r15], +r15
	ldrcc	r0, [r1], r2, lsl 0
	ldrcc	r15, [r15], r15, lsl 31
	ldrcc	r0, [r1], r2, lsr 1
	ldrcc	r15, [r15], r15, lsr 32
	ldrcc	r0, [r1], r2, asr 1
	ldrcc	r15, [r15], r15, asr 32
	ldrcc	r0, [r1], r2, ror 1
	ldrcc	r15, [r15], r15, ror 31
	ldrcc	r0, [r1], r2, rrx
	ldrcc	r15, [r15], r15, rrx

positive: ldrlo instruction

	ldrlo	r0, [r0, -4095]
	ldrlo	r15, [r15, +4095]
	ldrlo	r0, [r0, -r0]
	ldrlo	r15, [r15, +r15]
	ldrlo	r0, [r1, r2, lsl 0]
	ldrlo	r15, [r15, r15, lsl 31]
	ldrlo	r0, [r1, r2, lsr 1]
	ldrlo	r15, [r15, r15, lsr 32]
	ldrlo	r0, [r1, r2, asr 1]
	ldrlo	r15, [r15, r15, asr 32]
	ldrlo	r0, [r1, r2, ror 1]
	ldrlo	r15, [r15, r15, ror 31]
	ldrlo	r0, [r1, r2, rrx]
	ldrlo	r15, [r15, r15, rrx]
	ldrlo	r0, [r0, -4095] !
	ldrlo	r15, [r15, +4095] !
	ldrlo	r0, [r0, -r0] !
	ldrlo	r15, [r15, +r15] !
	ldrlo	r0, [r1, r2, lsl 0] !
	ldrlo	r15, [r15, r15, lsl 31] !
	ldrlo	r0, [r1, r2, lsr 1] !
	ldrlo	r15, [r15, r15, lsr 32] !
	ldrlo	r0, [r1, r2, asr 1] !
	ldrlo	r15, [r15, r15, asr 32] !
	ldrlo	r0, [r1, r2, ror 1] !
	ldrlo	r15, [r15, r15, ror 31] !
	ldrlo	r0, [r1, r2, rrx] !
	ldrlo	r15, [r15, r15, rrx] !
	ldrlo	r0, [r0], -4095
	ldrlo	r15, [r15], +4095
	ldrlo	r0, [r0], -r0
	ldrlo	r15, [r15], +r15
	ldrlo	r0, [r1], r2, lsl 0
	ldrlo	r15, [r15], r15, lsl 31
	ldrlo	r0, [r1], r2, lsr 1
	ldrlo	r15, [r15], r15, lsr 32
	ldrlo	r0, [r1], r2, asr 1
	ldrlo	r15, [r15], r15, asr 32
	ldrlo	r0, [r1], r2, ror 1
	ldrlo	r15, [r15], r15, ror 31
	ldrlo	r0, [r1], r2, rrx
	ldrlo	r15, [r15], r15, rrx

positive: ldrmi instruction

	ldrmi	r0, [r0, -4095]
	ldrmi	r15, [r15, +4095]
	ldrmi	r0, [r0, -r0]
	ldrmi	r15, [r15, +r15]
	ldrmi	r0, [r1, r2, lsl 0]
	ldrmi	r15, [r15, r15, lsl 31]
	ldrmi	r0, [r1, r2, lsr 1]
	ldrmi	r15, [r15, r15, lsr 32]
	ldrmi	r0, [r1, r2, asr 1]
	ldrmi	r15, [r15, r15, asr 32]
	ldrmi	r0, [r1, r2, ror 1]
	ldrmi	r15, [r15, r15, ror 31]
	ldrmi	r0, [r1, r2, rrx]
	ldrmi	r15, [r15, r15, rrx]
	ldrmi	r0, [r0, -4095] !
	ldrmi	r15, [r15, +4095] !
	ldrmi	r0, [r0, -r0] !
	ldrmi	r15, [r15, +r15] !
	ldrmi	r0, [r1, r2, lsl 0] !
	ldrmi	r15, [r15, r15, lsl 31] !
	ldrmi	r0, [r1, r2, lsr 1] !
	ldrmi	r15, [r15, r15, lsr 32] !
	ldrmi	r0, [r1, r2, asr 1] !
	ldrmi	r15, [r15, r15, asr 32] !
	ldrmi	r0, [r1, r2, ror 1] !
	ldrmi	r15, [r15, r15, ror 31] !
	ldrmi	r0, [r1, r2, rrx] !
	ldrmi	r15, [r15, r15, rrx] !
	ldrmi	r0, [r0], -4095
	ldrmi	r15, [r15], +4095
	ldrmi	r0, [r0], -r0
	ldrmi	r15, [r15], +r15
	ldrmi	r0, [r1], r2, lsl 0
	ldrmi	r15, [r15], r15, lsl 31
	ldrmi	r0, [r1], r2, lsr 1
	ldrmi	r15, [r15], r15, lsr 32
	ldrmi	r0, [r1], r2, asr 1
	ldrmi	r15, [r15], r15, asr 32
	ldrmi	r0, [r1], r2, ror 1
	ldrmi	r15, [r15], r15, ror 31
	ldrmi	r0, [r1], r2, rrx
	ldrmi	r15, [r15], r15, rrx

positive: ldrpl instruction

	ldrpl	r0, [r0, -4095]
	ldrpl	r15, [r15, +4095]
	ldrpl	r0, [r0, -r0]
	ldrpl	r15, [r15, +r15]
	ldrpl	r0, [r1, r2, lsl 0]
	ldrpl	r15, [r15, r15, lsl 31]
	ldrpl	r0, [r1, r2, lsr 1]
	ldrpl	r15, [r15, r15, lsr 32]
	ldrpl	r0, [r1, r2, asr 1]
	ldrpl	r15, [r15, r15, asr 32]
	ldrpl	r0, [r1, r2, ror 1]
	ldrpl	r15, [r15, r15, ror 31]
	ldrpl	r0, [r1, r2, rrx]
	ldrpl	r15, [r15, r15, rrx]
	ldrpl	r0, [r0, -4095] !
	ldrpl	r15, [r15, +4095] !
	ldrpl	r0, [r0, -r0] !
	ldrpl	r15, [r15, +r15] !
	ldrpl	r0, [r1, r2, lsl 0] !
	ldrpl	r15, [r15, r15, lsl 31] !
	ldrpl	r0, [r1, r2, lsr 1] !
	ldrpl	r15, [r15, r15, lsr 32] !
	ldrpl	r0, [r1, r2, asr 1] !
	ldrpl	r15, [r15, r15, asr 32] !
	ldrpl	r0, [r1, r2, ror 1] !
	ldrpl	r15, [r15, r15, ror 31] !
	ldrpl	r0, [r1, r2, rrx] !
	ldrpl	r15, [r15, r15, rrx] !
	ldrpl	r0, [r0], -4095
	ldrpl	r15, [r15], +4095
	ldrpl	r0, [r0], -r0
	ldrpl	r15, [r15], +r15
	ldrpl	r0, [r1], r2, lsl 0
	ldrpl	r15, [r15], r15, lsl 31
	ldrpl	r0, [r1], r2, lsr 1
	ldrpl	r15, [r15], r15, lsr 32
	ldrpl	r0, [r1], r2, asr 1
	ldrpl	r15, [r15], r15, asr 32
	ldrpl	r0, [r1], r2, ror 1
	ldrpl	r15, [r15], r15, ror 31
	ldrpl	r0, [r1], r2, rrx
	ldrpl	r15, [r15], r15, rrx

positive: ldrvs instruction

	ldrvs	r0, [r0, -4095]
	ldrvs	r15, [r15, +4095]
	ldrvs	r0, [r0, -r0]
	ldrvs	r15, [r15, +r15]
	ldrvs	r0, [r1, r2, lsl 0]
	ldrvs	r15, [r15, r15, lsl 31]
	ldrvs	r0, [r1, r2, lsr 1]
	ldrvs	r15, [r15, r15, lsr 32]
	ldrvs	r0, [r1, r2, asr 1]
	ldrvs	r15, [r15, r15, asr 32]
	ldrvs	r0, [r1, r2, ror 1]
	ldrvs	r15, [r15, r15, ror 31]
	ldrvs	r0, [r1, r2, rrx]
	ldrvs	r15, [r15, r15, rrx]
	ldrvs	r0, [r0, -4095] !
	ldrvs	r15, [r15, +4095] !
	ldrvs	r0, [r0, -r0] !
	ldrvs	r15, [r15, +r15] !
	ldrvs	r0, [r1, r2, lsl 0] !
	ldrvs	r15, [r15, r15, lsl 31] !
	ldrvs	r0, [r1, r2, lsr 1] !
	ldrvs	r15, [r15, r15, lsr 32] !
	ldrvs	r0, [r1, r2, asr 1] !
	ldrvs	r15, [r15, r15, asr 32] !
	ldrvs	r0, [r1, r2, ror 1] !
	ldrvs	r15, [r15, r15, ror 31] !
	ldrvs	r0, [r1, r2, rrx] !
	ldrvs	r15, [r15, r15, rrx] !
	ldrvs	r0, [r0], -4095
	ldrvs	r15, [r15], +4095
	ldrvs	r0, [r0], -r0
	ldrvs	r15, [r15], +r15
	ldrvs	r0, [r1], r2, lsl 0
	ldrvs	r15, [r15], r15, lsl 31
	ldrvs	r0, [r1], r2, lsr 1
	ldrvs	r15, [r15], r15, lsr 32
	ldrvs	r0, [r1], r2, asr 1
	ldrvs	r15, [r15], r15, asr 32
	ldrvs	r0, [r1], r2, ror 1
	ldrvs	r15, [r15], r15, ror 31
	ldrvs	r0, [r1], r2, rrx
	ldrvs	r15, [r15], r15, rrx

positive: ldrvc instruction

	ldrvc	r0, [r0, -4095]
	ldrvc	r15, [r15, +4095]
	ldrvc	r0, [r0, -r0]
	ldrvc	r15, [r15, +r15]
	ldrvc	r0, [r1, r2, lsl 0]
	ldrvc	r15, [r15, r15, lsl 31]
	ldrvc	r0, [r1, r2, lsr 1]
	ldrvc	r15, [r15, r15, lsr 32]
	ldrvc	r0, [r1, r2, asr 1]
	ldrvc	r15, [r15, r15, asr 32]
	ldrvc	r0, [r1, r2, ror 1]
	ldrvc	r15, [r15, r15, ror 31]
	ldrvc	r0, [r1, r2, rrx]
	ldrvc	r15, [r15, r15, rrx]
	ldrvc	r0, [r0, -4095] !
	ldrvc	r15, [r15, +4095] !
	ldrvc	r0, [r0, -r0] !
	ldrvc	r15, [r15, +r15] !
	ldrvc	r0, [r1, r2, lsl 0] !
	ldrvc	r15, [r15, r15, lsl 31] !
	ldrvc	r0, [r1, r2, lsr 1] !
	ldrvc	r15, [r15, r15, lsr 32] !
	ldrvc	r0, [r1, r2, asr 1] !
	ldrvc	r15, [r15, r15, asr 32] !
	ldrvc	r0, [r1, r2, ror 1] !
	ldrvc	r15, [r15, r15, ror 31] !
	ldrvc	r0, [r1, r2, rrx] !
	ldrvc	r15, [r15, r15, rrx] !
	ldrvc	r0, [r0], -4095
	ldrvc	r15, [r15], +4095
	ldrvc	r0, [r0], -r0
	ldrvc	r15, [r15], +r15
	ldrvc	r0, [r1], r2, lsl 0
	ldrvc	r15, [r15], r15, lsl 31
	ldrvc	r0, [r1], r2, lsr 1
	ldrvc	r15, [r15], r15, lsr 32
	ldrvc	r0, [r1], r2, asr 1
	ldrvc	r15, [r15], r15, asr 32
	ldrvc	r0, [r1], r2, ror 1
	ldrvc	r15, [r15], r15, ror 31
	ldrvc	r0, [r1], r2, rrx
	ldrvc	r15, [r15], r15, rrx

positive: ldrhi instruction

	ldrhi	r0, [r0, -4095]
	ldrhi	r15, [r15, +4095]
	ldrhi	r0, [r0, -r0]
	ldrhi	r15, [r15, +r15]
	ldrhi	r0, [r1, r2, lsl 0]
	ldrhi	r15, [r15, r15, lsl 31]
	ldrhi	r0, [r1, r2, lsr 1]
	ldrhi	r15, [r15, r15, lsr 32]
	ldrhi	r0, [r1, r2, asr 1]
	ldrhi	r15, [r15, r15, asr 32]
	ldrhi	r0, [r1, r2, ror 1]
	ldrhi	r15, [r15, r15, ror 31]
	ldrhi	r0, [r1, r2, rrx]
	ldrhi	r15, [r15, r15, rrx]
	ldrhi	r0, [r0, -4095] !
	ldrhi	r15, [r15, +4095] !
	ldrhi	r0, [r0, -r0] !
	ldrhi	r15, [r15, +r15] !
	ldrhi	r0, [r1, r2, lsl 0] !
	ldrhi	r15, [r15, r15, lsl 31] !
	ldrhi	r0, [r1, r2, lsr 1] !
	ldrhi	r15, [r15, r15, lsr 32] !
	ldrhi	r0, [r1, r2, asr 1] !
	ldrhi	r15, [r15, r15, asr 32] !
	ldrhi	r0, [r1, r2, ror 1] !
	ldrhi	r15, [r15, r15, ror 31] !
	ldrhi	r0, [r1, r2, rrx] !
	ldrhi	r15, [r15, r15, rrx] !
	ldrhi	r0, [r0], -4095
	ldrhi	r15, [r15], +4095
	ldrhi	r0, [r0], -r0
	ldrhi	r15, [r15], +r15
	ldrhi	r0, [r1], r2, lsl 0
	ldrhi	r15, [r15], r15, lsl 31
	ldrhi	r0, [r1], r2, lsr 1
	ldrhi	r15, [r15], r15, lsr 32
	ldrhi	r0, [r1], r2, asr 1
	ldrhi	r15, [r15], r15, asr 32
	ldrhi	r0, [r1], r2, ror 1
	ldrhi	r15, [r15], r15, ror 31
	ldrhi	r0, [r1], r2, rrx
	ldrhi	r15, [r15], r15, rrx

positive: ldrls instruction

	ldrls	r0, [r0, -4095]
	ldrls	r15, [r15, +4095]
	ldrls	r0, [r0, -r0]
	ldrls	r15, [r15, +r15]
	ldrls	r0, [r1, r2, lsl 0]
	ldrls	r15, [r15, r15, lsl 31]
	ldrls	r0, [r1, r2, lsr 1]
	ldrls	r15, [r15, r15, lsr 32]
	ldrls	r0, [r1, r2, asr 1]
	ldrls	r15, [r15, r15, asr 32]
	ldrls	r0, [r1, r2, ror 1]
	ldrls	r15, [r15, r15, ror 31]
	ldrls	r0, [r1, r2, rrx]
	ldrls	r15, [r15, r15, rrx]
	ldrls	r0, [r0, -4095] !
	ldrls	r15, [r15, +4095] !
	ldrls	r0, [r0, -r0] !
	ldrls	r15, [r15, +r15] !
	ldrls	r0, [r1, r2, lsl 0] !
	ldrls	r15, [r15, r15, lsl 31] !
	ldrls	r0, [r1, r2, lsr 1] !
	ldrls	r15, [r15, r15, lsr 32] !
	ldrls	r0, [r1, r2, asr 1] !
	ldrls	r15, [r15, r15, asr 32] !
	ldrls	r0, [r1, r2, ror 1] !
	ldrls	r15, [r15, r15, ror 31] !
	ldrls	r0, [r1, r2, rrx] !
	ldrls	r15, [r15, r15, rrx] !
	ldrls	r0, [r0], -4095
	ldrls	r15, [r15], +4095
	ldrls	r0, [r0], -r0
	ldrls	r15, [r15], +r15
	ldrls	r0, [r1], r2, lsl 0
	ldrls	r15, [r15], r15, lsl 31
	ldrls	r0, [r1], r2, lsr 1
	ldrls	r15, [r15], r15, lsr 32
	ldrls	r0, [r1], r2, asr 1
	ldrls	r15, [r15], r15, asr 32
	ldrls	r0, [r1], r2, ror 1
	ldrls	r15, [r15], r15, ror 31
	ldrls	r0, [r1], r2, rrx
	ldrls	r15, [r15], r15, rrx

positive: ldrge instruction

	ldrge	r0, [r0, -4095]
	ldrge	r15, [r15, +4095]
	ldrge	r0, [r0, -r0]
	ldrge	r15, [r15, +r15]
	ldrge	r0, [r1, r2, lsl 0]
	ldrge	r15, [r15, r15, lsl 31]
	ldrge	r0, [r1, r2, lsr 1]
	ldrge	r15, [r15, r15, lsr 32]
	ldrge	r0, [r1, r2, asr 1]
	ldrge	r15, [r15, r15, asr 32]
	ldrge	r0, [r1, r2, ror 1]
	ldrge	r15, [r15, r15, ror 31]
	ldrge	r0, [r1, r2, rrx]
	ldrge	r15, [r15, r15, rrx]
	ldrge	r0, [r0, -4095] !
	ldrge	r15, [r15, +4095] !
	ldrge	r0, [r0, -r0] !
	ldrge	r15, [r15, +r15] !
	ldrge	r0, [r1, r2, lsl 0] !
	ldrge	r15, [r15, r15, lsl 31] !
	ldrge	r0, [r1, r2, lsr 1] !
	ldrge	r15, [r15, r15, lsr 32] !
	ldrge	r0, [r1, r2, asr 1] !
	ldrge	r15, [r15, r15, asr 32] !
	ldrge	r0, [r1, r2, ror 1] !
	ldrge	r15, [r15, r15, ror 31] !
	ldrge	r0, [r1, r2, rrx] !
	ldrge	r15, [r15, r15, rrx] !
	ldrge	r0, [r0], -4095
	ldrge	r15, [r15], +4095
	ldrge	r0, [r0], -r0
	ldrge	r15, [r15], +r15
	ldrge	r0, [r1], r2, lsl 0
	ldrge	r15, [r15], r15, lsl 31
	ldrge	r0, [r1], r2, lsr 1
	ldrge	r15, [r15], r15, lsr 32
	ldrge	r0, [r1], r2, asr 1
	ldrge	r15, [r15], r15, asr 32
	ldrge	r0, [r1], r2, ror 1
	ldrge	r15, [r15], r15, ror 31
	ldrge	r0, [r1], r2, rrx
	ldrge	r15, [r15], r15, rrx

positive: ldrlt instruction

	ldrlt	r0, [r0, -4095]
	ldrlt	r15, [r15, +4095]
	ldrlt	r0, [r0, -r0]
	ldrlt	r15, [r15, +r15]
	ldrlt	r0, [r1, r2, lsl 0]
	ldrlt	r15, [r15, r15, lsl 31]
	ldrlt	r0, [r1, r2, lsr 1]
	ldrlt	r15, [r15, r15, lsr 32]
	ldrlt	r0, [r1, r2, asr 1]
	ldrlt	r15, [r15, r15, asr 32]
	ldrlt	r0, [r1, r2, ror 1]
	ldrlt	r15, [r15, r15, ror 31]
	ldrlt	r0, [r1, r2, rrx]
	ldrlt	r15, [r15, r15, rrx]
	ldrlt	r0, [r0, -4095] !
	ldrlt	r15, [r15, +4095] !
	ldrlt	r0, [r0, -r0] !
	ldrlt	r15, [r15, +r15] !
	ldrlt	r0, [r1, r2, lsl 0] !
	ldrlt	r15, [r15, r15, lsl 31] !
	ldrlt	r0, [r1, r2, lsr 1] !
	ldrlt	r15, [r15, r15, lsr 32] !
	ldrlt	r0, [r1, r2, asr 1] !
	ldrlt	r15, [r15, r15, asr 32] !
	ldrlt	r0, [r1, r2, ror 1] !
	ldrlt	r15, [r15, r15, ror 31] !
	ldrlt	r0, [r1, r2, rrx] !
	ldrlt	r15, [r15, r15, rrx] !
	ldrlt	r0, [r0], -4095
	ldrlt	r15, [r15], +4095
	ldrlt	r0, [r0], -r0
	ldrlt	r15, [r15], +r15
	ldrlt	r0, [r1], r2, lsl 0
	ldrlt	r15, [r15], r15, lsl 31
	ldrlt	r0, [r1], r2, lsr 1
	ldrlt	r15, [r15], r15, lsr 32
	ldrlt	r0, [r1], r2, asr 1
	ldrlt	r15, [r15], r15, asr 32
	ldrlt	r0, [r1], r2, ror 1
	ldrlt	r15, [r15], r15, ror 31
	ldrlt	r0, [r1], r2, rrx
	ldrlt	r15, [r15], r15, rrx

positive: ldrgt instruction

	ldrgt	r0, [r0, -4095]
	ldrgt	r15, [r15, +4095]
	ldrgt	r0, [r0, -r0]
	ldrgt	r15, [r15, +r15]
	ldrgt	r0, [r1, r2, lsl 0]
	ldrgt	r15, [r15, r15, lsl 31]
	ldrgt	r0, [r1, r2, lsr 1]
	ldrgt	r15, [r15, r15, lsr 32]
	ldrgt	r0, [r1, r2, asr 1]
	ldrgt	r15, [r15, r15, asr 32]
	ldrgt	r0, [r1, r2, ror 1]
	ldrgt	r15, [r15, r15, ror 31]
	ldrgt	r0, [r1, r2, rrx]
	ldrgt	r15, [r15, r15, rrx]
	ldrgt	r0, [r0, -4095] !
	ldrgt	r15, [r15, +4095] !
	ldrgt	r0, [r0, -r0] !
	ldrgt	r15, [r15, +r15] !
	ldrgt	r0, [r1, r2, lsl 0] !
	ldrgt	r15, [r15, r15, lsl 31] !
	ldrgt	r0, [r1, r2, lsr 1] !
	ldrgt	r15, [r15, r15, lsr 32] !
	ldrgt	r0, [r1, r2, asr 1] !
	ldrgt	r15, [r15, r15, asr 32] !
	ldrgt	r0, [r1, r2, ror 1] !
	ldrgt	r15, [r15, r15, ror 31] !
	ldrgt	r0, [r1, r2, rrx] !
	ldrgt	r15, [r15, r15, rrx] !
	ldrgt	r0, [r0], -4095
	ldrgt	r15, [r15], +4095
	ldrgt	r0, [r0], -r0
	ldrgt	r15, [r15], +r15
	ldrgt	r0, [r1], r2, lsl 0
	ldrgt	r15, [r15], r15, lsl 31
	ldrgt	r0, [r1], r2, lsr 1
	ldrgt	r15, [r15], r15, lsr 32
	ldrgt	r0, [r1], r2, asr 1
	ldrgt	r15, [r15], r15, asr 32
	ldrgt	r0, [r1], r2, ror 1
	ldrgt	r15, [r15], r15, ror 31
	ldrgt	r0, [r1], r2, rrx
	ldrgt	r15, [r15], r15, rrx

positive: ldrle instruction

	ldrle	r0, [r0, -4095]
	ldrle	r15, [r15, +4095]
	ldrle	r0, [r0, -r0]
	ldrle	r15, [r15, +r15]
	ldrle	r0, [r1, r2, lsl 0]
	ldrle	r15, [r15, r15, lsl 31]
	ldrle	r0, [r1, r2, lsr 1]
	ldrle	r15, [r15, r15, lsr 32]
	ldrle	r0, [r1, r2, asr 1]
	ldrle	r15, [r15, r15, asr 32]
	ldrle	r0, [r1, r2, ror 1]
	ldrle	r15, [r15, r15, ror 31]
	ldrle	r0, [r1, r2, rrx]
	ldrle	r15, [r15, r15, rrx]
	ldrle	r0, [r0, -4095] !
	ldrle	r15, [r15, +4095] !
	ldrle	r0, [r0, -r0] !
	ldrle	r15, [r15, +r15] !
	ldrle	r0, [r1, r2, lsl 0] !
	ldrle	r15, [r15, r15, lsl 31] !
	ldrle	r0, [r1, r2, lsr 1] !
	ldrle	r15, [r15, r15, lsr 32] !
	ldrle	r0, [r1, r2, asr 1] !
	ldrle	r15, [r15, r15, asr 32] !
	ldrle	r0, [r1, r2, ror 1] !
	ldrle	r15, [r15, r15, ror 31] !
	ldrle	r0, [r1, r2, rrx] !
	ldrle	r15, [r15, r15, rrx] !
	ldrle	r0, [r0], -4095
	ldrle	r15, [r15], +4095
	ldrle	r0, [r0], -r0
	ldrle	r15, [r15], +r15
	ldrle	r0, [r1], r2, lsl 0
	ldrle	r15, [r15], r15, lsl 31
	ldrle	r0, [r1], r2, lsr 1
	ldrle	r15, [r15], r15, lsr 32
	ldrle	r0, [r1], r2, asr 1
	ldrle	r15, [r15], r15, asr 32
	ldrle	r0, [r1], r2, ror 1
	ldrle	r15, [r15], r15, ror 31
	ldrle	r0, [r1], r2, rrx
	ldrle	r15, [r15], r15, rrx

positive: ldral instruction

	ldral	r0, [r0, -4095]
	ldral	r15, [r15, +4095]
	ldral	r0, [r0, -r0]
	ldral	r15, [r15, +r15]
	ldral	r0, [r1, r2, lsl 0]
	ldral	r15, [r15, r15, lsl 31]
	ldral	r0, [r1, r2, lsr 1]
	ldral	r15, [r15, r15, lsr 32]
	ldral	r0, [r1, r2, asr 1]
	ldral	r15, [r15, r15, asr 32]
	ldral	r0, [r1, r2, ror 1]
	ldral	r15, [r15, r15, ror 31]
	ldral	r0, [r1, r2, rrx]
	ldral	r15, [r15, r15, rrx]
	ldral	r0, [r0, -4095] !
	ldral	r15, [r15, +4095] !
	ldral	r0, [r0, -r0] !
	ldral	r15, [r15, +r15] !
	ldral	r0, [r1, r2, lsl 0] !
	ldral	r15, [r15, r15, lsl 31] !
	ldral	r0, [r1, r2, lsr 1] !
	ldral	r15, [r15, r15, lsr 32] !
	ldral	r0, [r1, r2, asr 1] !
	ldral	r15, [r15, r15, asr 32] !
	ldral	r0, [r1, r2, ror 1] !
	ldral	r15, [r15, r15, ror 31] !
	ldral	r0, [r1, r2, rrx] !
	ldral	r15, [r15, r15, rrx] !
	ldral	r0, [r0], -4095
	ldral	r15, [r15], +4095
	ldral	r0, [r0], -r0
	ldral	r15, [r15], +r15
	ldral	r0, [r1], r2, lsl 0
	ldral	r15, [r15], r15, lsl 31
	ldral	r0, [r1], r2, lsr 1
	ldral	r15, [r15], r15, lsr 32
	ldral	r0, [r1], r2, asr 1
	ldral	r15, [r15], r15, asr 32
	ldral	r0, [r1], r2, ror 1
	ldral	r15, [r15], r15, ror 31
	ldral	r0, [r1], r2, rrx
	ldral	r15, [r15], r15, rrx

positive: ldrb instruction

	ldrb	r0, [r0, -4095]
	ldrb	r15, [r15, +4095]
	ldrb	r0, [r0, -r0]
	ldrb	r15, [r15, +r15]
	ldrb	r0, [r1, r2, lsl 0]
	ldrb	r15, [r15, r15, lsl 31]
	ldrb	r0, [r1, r2, lsr 1]
	ldrb	r15, [r15, r15, lsr 32]
	ldrb	r0, [r1, r2, asr 1]
	ldrb	r15, [r15, r15, asr 32]
	ldrb	r0, [r1, r2, ror 1]
	ldrb	r15, [r15, r15, ror 31]
	ldrb	r0, [r1, r2, rrx]
	ldrb	r15, [r15, r15, rrx]
	ldrb	r0, [r0, -4095] !
	ldrb	r15, [r15, +4095] !
	ldrb	r0, [r0, -r0] !
	ldrb	r15, [r15, +r15] !
	ldrb	r0, [r1, r2, lsl 0] !
	ldrb	r15, [r15, r15, lsl 31] !
	ldrb	r0, [r1, r2, lsr 1] !
	ldrb	r15, [r15, r15, lsr 32] !
	ldrb	r0, [r1, r2, asr 1] !
	ldrb	r15, [r15, r15, asr 32] !
	ldrb	r0, [r1, r2, ror 1] !
	ldrb	r15, [r15, r15, ror 31] !
	ldrb	r0, [r1, r2, rrx] !
	ldrb	r15, [r15, r15, rrx] !
	ldrb	r0, [r0], -4095
	ldrb	r15, [r15], +4095
	ldrb	r0, [r0], -r0
	ldrb	r15, [r15], +r15
	ldrb	r0, [r1], r2, lsl 0
	ldrb	r15, [r15], r15, lsl 31
	ldrb	r0, [r1], r2, lsr 1
	ldrb	r15, [r15], r15, lsr 32
	ldrb	r0, [r1], r2, asr 1
	ldrb	r15, [r15], r15, asr 32
	ldrb	r0, [r1], r2, ror 1
	ldrb	r15, [r15], r15, ror 31
	ldrb	r0, [r1], r2, rrx
	ldrb	r15, [r15], r15, rrx

positive: ldrbeq instruction

	ldrbeq	r0, [r0, -4095]
	ldrbeq	r15, [r15, +4095]
	ldrbeq	r0, [r0, -r0]
	ldrbeq	r15, [r15, +r15]
	ldrbeq	r0, [r1, r2, lsl 0]
	ldrbeq	r15, [r15, r15, lsl 31]
	ldrbeq	r0, [r1, r2, lsr 1]
	ldrbeq	r15, [r15, r15, lsr 32]
	ldrbeq	r0, [r1, r2, asr 1]
	ldrbeq	r15, [r15, r15, asr 32]
	ldrbeq	r0, [r1, r2, ror 1]
	ldrbeq	r15, [r15, r15, ror 31]
	ldrbeq	r0, [r1, r2, rrx]
	ldrbeq	r15, [r15, r15, rrx]
	ldrbeq	r0, [r0, -4095] !
	ldrbeq	r15, [r15, +4095] !
	ldrbeq	r0, [r0, -r0] !
	ldrbeq	r15, [r15, +r15] !
	ldrbeq	r0, [r1, r2, lsl 0] !
	ldrbeq	r15, [r15, r15, lsl 31] !
	ldrbeq	r0, [r1, r2, lsr 1] !
	ldrbeq	r15, [r15, r15, lsr 32] !
	ldrbeq	r0, [r1, r2, asr 1] !
	ldrbeq	r15, [r15, r15, asr 32] !
	ldrbeq	r0, [r1, r2, ror 1] !
	ldrbeq	r15, [r15, r15, ror 31] !
	ldrbeq	r0, [r1, r2, rrx] !
	ldrbeq	r15, [r15, r15, rrx] !
	ldrbeq	r0, [r0], -4095
	ldrbeq	r15, [r15], +4095
	ldrbeq	r0, [r0], -r0
	ldrbeq	r15, [r15], +r15
	ldrbeq	r0, [r1], r2, lsl 0
	ldrbeq	r15, [r15], r15, lsl 31
	ldrbeq	r0, [r1], r2, lsr 1
	ldrbeq	r15, [r15], r15, lsr 32
	ldrbeq	r0, [r1], r2, asr 1
	ldrbeq	r15, [r15], r15, asr 32
	ldrbeq	r0, [r1], r2, ror 1
	ldrbeq	r15, [r15], r15, ror 31
	ldrbeq	r0, [r1], r2, rrx
	ldrbeq	r15, [r15], r15, rrx

positive: ldrbne instruction

	ldrbne	r0, [r0, -4095]
	ldrbne	r15, [r15, +4095]
	ldrbne	r0, [r0, -r0]
	ldrbne	r15, [r15, +r15]
	ldrbne	r0, [r1, r2, lsl 0]
	ldrbne	r15, [r15, r15, lsl 31]
	ldrbne	r0, [r1, r2, lsr 1]
	ldrbne	r15, [r15, r15, lsr 32]
	ldrbne	r0, [r1, r2, asr 1]
	ldrbne	r15, [r15, r15, asr 32]
	ldrbne	r0, [r1, r2, ror 1]
	ldrbne	r15, [r15, r15, ror 31]
	ldrbne	r0, [r1, r2, rrx]
	ldrbne	r15, [r15, r15, rrx]
	ldrbne	r0, [r0, -4095] !
	ldrbne	r15, [r15, +4095] !
	ldrbne	r0, [r0, -r0] !
	ldrbne	r15, [r15, +r15] !
	ldrbne	r0, [r1, r2, lsl 0] !
	ldrbne	r15, [r15, r15, lsl 31] !
	ldrbne	r0, [r1, r2, lsr 1] !
	ldrbne	r15, [r15, r15, lsr 32] !
	ldrbne	r0, [r1, r2, asr 1] !
	ldrbne	r15, [r15, r15, asr 32] !
	ldrbne	r0, [r1, r2, ror 1] !
	ldrbne	r15, [r15, r15, ror 31] !
	ldrbne	r0, [r1, r2, rrx] !
	ldrbne	r15, [r15, r15, rrx] !
	ldrbne	r0, [r0], -4095
	ldrbne	r15, [r15], +4095
	ldrbne	r0, [r0], -r0
	ldrbne	r15, [r15], +r15
	ldrbne	r0, [r1], r2, lsl 0
	ldrbne	r15, [r15], r15, lsl 31
	ldrbne	r0, [r1], r2, lsr 1
	ldrbne	r15, [r15], r15, lsr 32
	ldrbne	r0, [r1], r2, asr 1
	ldrbne	r15, [r15], r15, asr 32
	ldrbne	r0, [r1], r2, ror 1
	ldrbne	r15, [r15], r15, ror 31
	ldrbne	r0, [r1], r2, rrx
	ldrbne	r15, [r15], r15, rrx

positive: ldrbcs instruction

	ldrbcs	r0, [r0, -4095]
	ldrbcs	r15, [r15, +4095]
	ldrbcs	r0, [r0, -r0]
	ldrbcs	r15, [r15, +r15]
	ldrbcs	r0, [r1, r2, lsl 0]
	ldrbcs	r15, [r15, r15, lsl 31]
	ldrbcs	r0, [r1, r2, lsr 1]
	ldrbcs	r15, [r15, r15, lsr 32]
	ldrbcs	r0, [r1, r2, asr 1]
	ldrbcs	r15, [r15, r15, asr 32]
	ldrbcs	r0, [r1, r2, ror 1]
	ldrbcs	r15, [r15, r15, ror 31]
	ldrbcs	r0, [r1, r2, rrx]
	ldrbcs	r15, [r15, r15, rrx]
	ldrbcs	r0, [r0, -4095] !
	ldrbcs	r15, [r15, +4095] !
	ldrbcs	r0, [r0, -r0] !
	ldrbcs	r15, [r15, +r15] !
	ldrbcs	r0, [r1, r2, lsl 0] !
	ldrbcs	r15, [r15, r15, lsl 31] !
	ldrbcs	r0, [r1, r2, lsr 1] !
	ldrbcs	r15, [r15, r15, lsr 32] !
	ldrbcs	r0, [r1, r2, asr 1] !
	ldrbcs	r15, [r15, r15, asr 32] !
	ldrbcs	r0, [r1, r2, ror 1] !
	ldrbcs	r15, [r15, r15, ror 31] !
	ldrbcs	r0, [r1, r2, rrx] !
	ldrbcs	r15, [r15, r15, rrx] !
	ldrbcs	r0, [r0], -4095
	ldrbcs	r15, [r15], +4095
	ldrbcs	r0, [r0], -r0
	ldrbcs	r15, [r15], +r15
	ldrbcs	r0, [r1], r2, lsl 0
	ldrbcs	r15, [r15], r15, lsl 31
	ldrbcs	r0, [r1], r2, lsr 1
	ldrbcs	r15, [r15], r15, lsr 32
	ldrbcs	r0, [r1], r2, asr 1
	ldrbcs	r15, [r15], r15, asr 32
	ldrbcs	r0, [r1], r2, ror 1
	ldrbcs	r15, [r15], r15, ror 31
	ldrbcs	r0, [r1], r2, rrx
	ldrbcs	r15, [r15], r15, rrx

positive: ldrbhs instruction

	ldrbhs	r0, [r0, -4095]
	ldrbhs	r15, [r15, +4095]
	ldrbhs	r0, [r0, -r0]
	ldrbhs	r15, [r15, +r15]
	ldrbhs	r0, [r1, r2, lsl 0]
	ldrbhs	r15, [r15, r15, lsl 31]
	ldrbhs	r0, [r1, r2, lsr 1]
	ldrbhs	r15, [r15, r15, lsr 32]
	ldrbhs	r0, [r1, r2, asr 1]
	ldrbhs	r15, [r15, r15, asr 32]
	ldrbhs	r0, [r1, r2, ror 1]
	ldrbhs	r15, [r15, r15, ror 31]
	ldrbhs	r0, [r1, r2, rrx]
	ldrbhs	r15, [r15, r15, rrx]
	ldrbhs	r0, [r0, -4095] !
	ldrbhs	r15, [r15, +4095] !
	ldrbhs	r0, [r0, -r0] !
	ldrbhs	r15, [r15, +r15] !
	ldrbhs	r0, [r1, r2, lsl 0] !
	ldrbhs	r15, [r15, r15, lsl 31] !
	ldrbhs	r0, [r1, r2, lsr 1] !
	ldrbhs	r15, [r15, r15, lsr 32] !
	ldrbhs	r0, [r1, r2, asr 1] !
	ldrbhs	r15, [r15, r15, asr 32] !
	ldrbhs	r0, [r1, r2, ror 1] !
	ldrbhs	r15, [r15, r15, ror 31] !
	ldrbhs	r0, [r1, r2, rrx] !
	ldrbhs	r15, [r15, r15, rrx] !
	ldrbhs	r0, [r0], -4095
	ldrbhs	r15, [r15], +4095
	ldrbhs	r0, [r0], -r0
	ldrbhs	r15, [r15], +r15
	ldrbhs	r0, [r1], r2, lsl 0
	ldrbhs	r15, [r15], r15, lsl 31
	ldrbhs	r0, [r1], r2, lsr 1
	ldrbhs	r15, [r15], r15, lsr 32
	ldrbhs	r0, [r1], r2, asr 1
	ldrbhs	r15, [r15], r15, asr 32
	ldrbhs	r0, [r1], r2, ror 1
	ldrbhs	r15, [r15], r15, ror 31
	ldrbhs	r0, [r1], r2, rrx
	ldrbhs	r15, [r15], r15, rrx

positive: ldrbcc instruction

	ldrbcc	r0, [r0, -4095]
	ldrbcc	r15, [r15, +4095]
	ldrbcc	r0, [r0, -r0]
	ldrbcc	r15, [r15, +r15]
	ldrbcc	r0, [r1, r2, lsl 0]
	ldrbcc	r15, [r15, r15, lsl 31]
	ldrbcc	r0, [r1, r2, lsr 1]
	ldrbcc	r15, [r15, r15, lsr 32]
	ldrbcc	r0, [r1, r2, asr 1]
	ldrbcc	r15, [r15, r15, asr 32]
	ldrbcc	r0, [r1, r2, ror 1]
	ldrbcc	r15, [r15, r15, ror 31]
	ldrbcc	r0, [r1, r2, rrx]
	ldrbcc	r15, [r15, r15, rrx]
	ldrbcc	r0, [r0, -4095] !
	ldrbcc	r15, [r15, +4095] !
	ldrbcc	r0, [r0, -r0] !
	ldrbcc	r15, [r15, +r15] !
	ldrbcc	r0, [r1, r2, lsl 0] !
	ldrbcc	r15, [r15, r15, lsl 31] !
	ldrbcc	r0, [r1, r2, lsr 1] !
	ldrbcc	r15, [r15, r15, lsr 32] !
	ldrbcc	r0, [r1, r2, asr 1] !
	ldrbcc	r15, [r15, r15, asr 32] !
	ldrbcc	r0, [r1, r2, ror 1] !
	ldrbcc	r15, [r15, r15, ror 31] !
	ldrbcc	r0, [r1, r2, rrx] !
	ldrbcc	r15, [r15, r15, rrx] !
	ldrbcc	r0, [r0], -4095
	ldrbcc	r15, [r15], +4095
	ldrbcc	r0, [r0], -r0
	ldrbcc	r15, [r15], +r15
	ldrbcc	r0, [r1], r2, lsl 0
	ldrbcc	r15, [r15], r15, lsl 31
	ldrbcc	r0, [r1], r2, lsr 1
	ldrbcc	r15, [r15], r15, lsr 32
	ldrbcc	r0, [r1], r2, asr 1
	ldrbcc	r15, [r15], r15, asr 32
	ldrbcc	r0, [r1], r2, ror 1
	ldrbcc	r15, [r15], r15, ror 31
	ldrbcc	r0, [r1], r2, rrx
	ldrbcc	r15, [r15], r15, rrx

positive: ldrblo instruction

	ldrblo	r0, [r0, -4095]
	ldrblo	r15, [r15, +4095]
	ldrblo	r0, [r0, -r0]
	ldrblo	r15, [r15, +r15]
	ldrblo	r0, [r1, r2, lsl 0]
	ldrblo	r15, [r15, r15, lsl 31]
	ldrblo	r0, [r1, r2, lsr 1]
	ldrblo	r15, [r15, r15, lsr 32]
	ldrblo	r0, [r1, r2, asr 1]
	ldrblo	r15, [r15, r15, asr 32]
	ldrblo	r0, [r1, r2, ror 1]
	ldrblo	r15, [r15, r15, ror 31]
	ldrblo	r0, [r1, r2, rrx]
	ldrblo	r15, [r15, r15, rrx]
	ldrblo	r0, [r0, -4095] !
	ldrblo	r15, [r15, +4095] !
	ldrblo	r0, [r0, -r0] !
	ldrblo	r15, [r15, +r15] !
	ldrblo	r0, [r1, r2, lsl 0] !
	ldrblo	r15, [r15, r15, lsl 31] !
	ldrblo	r0, [r1, r2, lsr 1] !
	ldrblo	r15, [r15, r15, lsr 32] !
	ldrblo	r0, [r1, r2, asr 1] !
	ldrblo	r15, [r15, r15, asr 32] !
	ldrblo	r0, [r1, r2, ror 1] !
	ldrblo	r15, [r15, r15, ror 31] !
	ldrblo	r0, [r1, r2, rrx] !
	ldrblo	r15, [r15, r15, rrx] !
	ldrblo	r0, [r0], -4095
	ldrblo	r15, [r15], +4095
	ldrblo	r0, [r0], -r0
	ldrblo	r15, [r15], +r15
	ldrblo	r0, [r1], r2, lsl 0
	ldrblo	r15, [r15], r15, lsl 31
	ldrblo	r0, [r1], r2, lsr 1
	ldrblo	r15, [r15], r15, lsr 32
	ldrblo	r0, [r1], r2, asr 1
	ldrblo	r15, [r15], r15, asr 32
	ldrblo	r0, [r1], r2, ror 1
	ldrblo	r15, [r15], r15, ror 31
	ldrblo	r0, [r1], r2, rrx
	ldrblo	r15, [r15], r15, rrx

positive: ldrbmi instruction

	ldrbmi	r0, [r0, -4095]
	ldrbmi	r15, [r15, +4095]
	ldrbmi	r0, [r0, -r0]
	ldrbmi	r15, [r15, +r15]
	ldrbmi	r0, [r1, r2, lsl 0]
	ldrbmi	r15, [r15, r15, lsl 31]
	ldrbmi	r0, [r1, r2, lsr 1]
	ldrbmi	r15, [r15, r15, lsr 32]
	ldrbmi	r0, [r1, r2, asr 1]
	ldrbmi	r15, [r15, r15, asr 32]
	ldrbmi	r0, [r1, r2, ror 1]
	ldrbmi	r15, [r15, r15, ror 31]
	ldrbmi	r0, [r1, r2, rrx]
	ldrbmi	r15, [r15, r15, rrx]
	ldrbmi	r0, [r0, -4095] !
	ldrbmi	r15, [r15, +4095] !
	ldrbmi	r0, [r0, -r0] !
	ldrbmi	r15, [r15, +r15] !
	ldrbmi	r0, [r1, r2, lsl 0] !
	ldrbmi	r15, [r15, r15, lsl 31] !
	ldrbmi	r0, [r1, r2, lsr 1] !
	ldrbmi	r15, [r15, r15, lsr 32] !
	ldrbmi	r0, [r1, r2, asr 1] !
	ldrbmi	r15, [r15, r15, asr 32] !
	ldrbmi	r0, [r1, r2, ror 1] !
	ldrbmi	r15, [r15, r15, ror 31] !
	ldrbmi	r0, [r1, r2, rrx] !
	ldrbmi	r15, [r15, r15, rrx] !
	ldrbmi	r0, [r0], -4095
	ldrbmi	r15, [r15], +4095
	ldrbmi	r0, [r0], -r0
	ldrbmi	r15, [r15], +r15
	ldrbmi	r0, [r1], r2, lsl 0
	ldrbmi	r15, [r15], r15, lsl 31
	ldrbmi	r0, [r1], r2, lsr 1
	ldrbmi	r15, [r15], r15, lsr 32
	ldrbmi	r0, [r1], r2, asr 1
	ldrbmi	r15, [r15], r15, asr 32
	ldrbmi	r0, [r1], r2, ror 1
	ldrbmi	r15, [r15], r15, ror 31
	ldrbmi	r0, [r1], r2, rrx
	ldrbmi	r15, [r15], r15, rrx

positive: ldrbpl instruction

	ldrbpl	r0, [r0, -4095]
	ldrbpl	r15, [r15, +4095]
	ldrbpl	r0, [r0, -r0]
	ldrbpl	r15, [r15, +r15]
	ldrbpl	r0, [r1, r2, lsl 0]
	ldrbpl	r15, [r15, r15, lsl 31]
	ldrbpl	r0, [r1, r2, lsr 1]
	ldrbpl	r15, [r15, r15, lsr 32]
	ldrbpl	r0, [r1, r2, asr 1]
	ldrbpl	r15, [r15, r15, asr 32]
	ldrbpl	r0, [r1, r2, ror 1]
	ldrbpl	r15, [r15, r15, ror 31]
	ldrbpl	r0, [r1, r2, rrx]
	ldrbpl	r15, [r15, r15, rrx]
	ldrbpl	r0, [r0, -4095] !
	ldrbpl	r15, [r15, +4095] !
	ldrbpl	r0, [r0, -r0] !
	ldrbpl	r15, [r15, +r15] !
	ldrbpl	r0, [r1, r2, lsl 0] !
	ldrbpl	r15, [r15, r15, lsl 31] !
	ldrbpl	r0, [r1, r2, lsr 1] !
	ldrbpl	r15, [r15, r15, lsr 32] !
	ldrbpl	r0, [r1, r2, asr 1] !
	ldrbpl	r15, [r15, r15, asr 32] !
	ldrbpl	r0, [r1, r2, ror 1] !
	ldrbpl	r15, [r15, r15, ror 31] !
	ldrbpl	r0, [r1, r2, rrx] !
	ldrbpl	r15, [r15, r15, rrx] !
	ldrbpl	r0, [r0], -4095
	ldrbpl	r15, [r15], +4095
	ldrbpl	r0, [r0], -r0
	ldrbpl	r15, [r15], +r15
	ldrbpl	r0, [r1], r2, lsl 0
	ldrbpl	r15, [r15], r15, lsl 31
	ldrbpl	r0, [r1], r2, lsr 1
	ldrbpl	r15, [r15], r15, lsr 32
	ldrbpl	r0, [r1], r2, asr 1
	ldrbpl	r15, [r15], r15, asr 32
	ldrbpl	r0, [r1], r2, ror 1
	ldrbpl	r15, [r15], r15, ror 31
	ldrbpl	r0, [r1], r2, rrx
	ldrbpl	r15, [r15], r15, rrx

positive: ldrbvs instruction

	ldrbvs	r0, [r0, -4095]
	ldrbvs	r15, [r15, +4095]
	ldrbvs	r0, [r0, -r0]
	ldrbvs	r15, [r15, +r15]
	ldrbvs	r0, [r1, r2, lsl 0]
	ldrbvs	r15, [r15, r15, lsl 31]
	ldrbvs	r0, [r1, r2, lsr 1]
	ldrbvs	r15, [r15, r15, lsr 32]
	ldrbvs	r0, [r1, r2, asr 1]
	ldrbvs	r15, [r15, r15, asr 32]
	ldrbvs	r0, [r1, r2, ror 1]
	ldrbvs	r15, [r15, r15, ror 31]
	ldrbvs	r0, [r1, r2, rrx]
	ldrbvs	r15, [r15, r15, rrx]
	ldrbvs	r0, [r0, -4095] !
	ldrbvs	r15, [r15, +4095] !
	ldrbvs	r0, [r0, -r0] !
	ldrbvs	r15, [r15, +r15] !
	ldrbvs	r0, [r1, r2, lsl 0] !
	ldrbvs	r15, [r15, r15, lsl 31] !
	ldrbvs	r0, [r1, r2, lsr 1] !
	ldrbvs	r15, [r15, r15, lsr 32] !
	ldrbvs	r0, [r1, r2, asr 1] !
	ldrbvs	r15, [r15, r15, asr 32] !
	ldrbvs	r0, [r1, r2, ror 1] !
	ldrbvs	r15, [r15, r15, ror 31] !
	ldrbvs	r0, [r1, r2, rrx] !
	ldrbvs	r15, [r15, r15, rrx] !
	ldrbvs	r0, [r0], -4095
	ldrbvs	r15, [r15], +4095
	ldrbvs	r0, [r0], -r0
	ldrbvs	r15, [r15], +r15
	ldrbvs	r0, [r1], r2, lsl 0
	ldrbvs	r15, [r15], r15, lsl 31
	ldrbvs	r0, [r1], r2, lsr 1
	ldrbvs	r15, [r15], r15, lsr 32
	ldrbvs	r0, [r1], r2, asr 1
	ldrbvs	r15, [r15], r15, asr 32
	ldrbvs	r0, [r1], r2, ror 1
	ldrbvs	r15, [r15], r15, ror 31
	ldrbvs	r0, [r1], r2, rrx
	ldrbvs	r15, [r15], r15, rrx

positive: ldrbvc instruction

	ldrbvc	r0, [r0, -4095]
	ldrbvc	r15, [r15, +4095]
	ldrbvc	r0, [r0, -r0]
	ldrbvc	r15, [r15, +r15]
	ldrbvc	r0, [r1, r2, lsl 0]
	ldrbvc	r15, [r15, r15, lsl 31]
	ldrbvc	r0, [r1, r2, lsr 1]
	ldrbvc	r15, [r15, r15, lsr 32]
	ldrbvc	r0, [r1, r2, asr 1]
	ldrbvc	r15, [r15, r15, asr 32]
	ldrbvc	r0, [r1, r2, ror 1]
	ldrbvc	r15, [r15, r15, ror 31]
	ldrbvc	r0, [r1, r2, rrx]
	ldrbvc	r15, [r15, r15, rrx]
	ldrbvc	r0, [r0, -4095] !
	ldrbvc	r15, [r15, +4095] !
	ldrbvc	r0, [r0, -r0] !
	ldrbvc	r15, [r15, +r15] !
	ldrbvc	r0, [r1, r2, lsl 0] !
	ldrbvc	r15, [r15, r15, lsl 31] !
	ldrbvc	r0, [r1, r2, lsr 1] !
	ldrbvc	r15, [r15, r15, lsr 32] !
	ldrbvc	r0, [r1, r2, asr 1] !
	ldrbvc	r15, [r15, r15, asr 32] !
	ldrbvc	r0, [r1, r2, ror 1] !
	ldrbvc	r15, [r15, r15, ror 31] !
	ldrbvc	r0, [r1, r2, rrx] !
	ldrbvc	r15, [r15, r15, rrx] !
	ldrbvc	r0, [r0], -4095
	ldrbvc	r15, [r15], +4095
	ldrbvc	r0, [r0], -r0
	ldrbvc	r15, [r15], +r15
	ldrbvc	r0, [r1], r2, lsl 0
	ldrbvc	r15, [r15], r15, lsl 31
	ldrbvc	r0, [r1], r2, lsr 1
	ldrbvc	r15, [r15], r15, lsr 32
	ldrbvc	r0, [r1], r2, asr 1
	ldrbvc	r15, [r15], r15, asr 32
	ldrbvc	r0, [r1], r2, ror 1
	ldrbvc	r15, [r15], r15, ror 31
	ldrbvc	r0, [r1], r2, rrx
	ldrbvc	r15, [r15], r15, rrx

positive: ldrbhi instruction

	ldrbhi	r0, [r0, -4095]
	ldrbhi	r15, [r15, +4095]
	ldrbhi	r0, [r0, -r0]
	ldrbhi	r15, [r15, +r15]
	ldrbhi	r0, [r1, r2, lsl 0]
	ldrbhi	r15, [r15, r15, lsl 31]
	ldrbhi	r0, [r1, r2, lsr 1]
	ldrbhi	r15, [r15, r15, lsr 32]
	ldrbhi	r0, [r1, r2, asr 1]
	ldrbhi	r15, [r15, r15, asr 32]
	ldrbhi	r0, [r1, r2, ror 1]
	ldrbhi	r15, [r15, r15, ror 31]
	ldrbhi	r0, [r1, r2, rrx]
	ldrbhi	r15, [r15, r15, rrx]
	ldrbhi	r0, [r0, -4095] !
	ldrbhi	r15, [r15, +4095] !
	ldrbhi	r0, [r0, -r0] !
	ldrbhi	r15, [r15, +r15] !
	ldrbhi	r0, [r1, r2, lsl 0] !
	ldrbhi	r15, [r15, r15, lsl 31] !
	ldrbhi	r0, [r1, r2, lsr 1] !
	ldrbhi	r15, [r15, r15, lsr 32] !
	ldrbhi	r0, [r1, r2, asr 1] !
	ldrbhi	r15, [r15, r15, asr 32] !
	ldrbhi	r0, [r1, r2, ror 1] !
	ldrbhi	r15, [r15, r15, ror 31] !
	ldrbhi	r0, [r1, r2, rrx] !
	ldrbhi	r15, [r15, r15, rrx] !
	ldrbhi	r0, [r0], -4095
	ldrbhi	r15, [r15], +4095
	ldrbhi	r0, [r0], -r0
	ldrbhi	r15, [r15], +r15
	ldrbhi	r0, [r1], r2, lsl 0
	ldrbhi	r15, [r15], r15, lsl 31
	ldrbhi	r0, [r1], r2, lsr 1
	ldrbhi	r15, [r15], r15, lsr 32
	ldrbhi	r0, [r1], r2, asr 1
	ldrbhi	r15, [r15], r15, asr 32
	ldrbhi	r0, [r1], r2, ror 1
	ldrbhi	r15, [r15], r15, ror 31
	ldrbhi	r0, [r1], r2, rrx
	ldrbhi	r15, [r15], r15, rrx

positive: ldrbls instruction

	ldrbls	r0, [r0, -4095]
	ldrbls	r15, [r15, +4095]
	ldrbls	r0, [r0, -r0]
	ldrbls	r15, [r15, +r15]
	ldrbls	r0, [r1, r2, lsl 0]
	ldrbls	r15, [r15, r15, lsl 31]
	ldrbls	r0, [r1, r2, lsr 1]
	ldrbls	r15, [r15, r15, lsr 32]
	ldrbls	r0, [r1, r2, asr 1]
	ldrbls	r15, [r15, r15, asr 32]
	ldrbls	r0, [r1, r2, ror 1]
	ldrbls	r15, [r15, r15, ror 31]
	ldrbls	r0, [r1, r2, rrx]
	ldrbls	r15, [r15, r15, rrx]
	ldrbls	r0, [r0, -4095] !
	ldrbls	r15, [r15, +4095] !
	ldrbls	r0, [r0, -r0] !
	ldrbls	r15, [r15, +r15] !
	ldrbls	r0, [r1, r2, lsl 0] !
	ldrbls	r15, [r15, r15, lsl 31] !
	ldrbls	r0, [r1, r2, lsr 1] !
	ldrbls	r15, [r15, r15, lsr 32] !
	ldrbls	r0, [r1, r2, asr 1] !
	ldrbls	r15, [r15, r15, asr 32] !
	ldrbls	r0, [r1, r2, ror 1] !
	ldrbls	r15, [r15, r15, ror 31] !
	ldrbls	r0, [r1, r2, rrx] !
	ldrbls	r15, [r15, r15, rrx] !
	ldrbls	r0, [r0], -4095
	ldrbls	r15, [r15], +4095
	ldrbls	r0, [r0], -r0
	ldrbls	r15, [r15], +r15
	ldrbls	r0, [r1], r2, lsl 0
	ldrbls	r15, [r15], r15, lsl 31
	ldrbls	r0, [r1], r2, lsr 1
	ldrbls	r15, [r15], r15, lsr 32
	ldrbls	r0, [r1], r2, asr 1
	ldrbls	r15, [r15], r15, asr 32
	ldrbls	r0, [r1], r2, ror 1
	ldrbls	r15, [r15], r15, ror 31
	ldrbls	r0, [r1], r2, rrx
	ldrbls	r15, [r15], r15, rrx

positive: ldrbge instruction

	ldrbge	r0, [r0, -4095]
	ldrbge	r15, [r15, +4095]
	ldrbge	r0, [r0, -r0]
	ldrbge	r15, [r15, +r15]
	ldrbge	r0, [r1, r2, lsl 0]
	ldrbge	r15, [r15, r15, lsl 31]
	ldrbge	r0, [r1, r2, lsr 1]
	ldrbge	r15, [r15, r15, lsr 32]
	ldrbge	r0, [r1, r2, asr 1]
	ldrbge	r15, [r15, r15, asr 32]
	ldrbge	r0, [r1, r2, ror 1]
	ldrbge	r15, [r15, r15, ror 31]
	ldrbge	r0, [r1, r2, rrx]
	ldrbge	r15, [r15, r15, rrx]
	ldrbge	r0, [r0, -4095] !
	ldrbge	r15, [r15, +4095] !
	ldrbge	r0, [r0, -r0] !
	ldrbge	r15, [r15, +r15] !
	ldrbge	r0, [r1, r2, lsl 0] !
	ldrbge	r15, [r15, r15, lsl 31] !
	ldrbge	r0, [r1, r2, lsr 1] !
	ldrbge	r15, [r15, r15, lsr 32] !
	ldrbge	r0, [r1, r2, asr 1] !
	ldrbge	r15, [r15, r15, asr 32] !
	ldrbge	r0, [r1, r2, ror 1] !
	ldrbge	r15, [r15, r15, ror 31] !
	ldrbge	r0, [r1, r2, rrx] !
	ldrbge	r15, [r15, r15, rrx] !
	ldrbge	r0, [r0], -4095
	ldrbge	r15, [r15], +4095
	ldrbge	r0, [r0], -r0
	ldrbge	r15, [r15], +r15
	ldrbge	r0, [r1], r2, lsl 0
	ldrbge	r15, [r15], r15, lsl 31
	ldrbge	r0, [r1], r2, lsr 1
	ldrbge	r15, [r15], r15, lsr 32
	ldrbge	r0, [r1], r2, asr 1
	ldrbge	r15, [r15], r15, asr 32
	ldrbge	r0, [r1], r2, ror 1
	ldrbge	r15, [r15], r15, ror 31
	ldrbge	r0, [r1], r2, rrx
	ldrbge	r15, [r15], r15, rrx

positive: ldrblt instruction

	ldrblt	r0, [r0, -4095]
	ldrblt	r15, [r15, +4095]
	ldrblt	r0, [r0, -r0]
	ldrblt	r15, [r15, +r15]
	ldrblt	r0, [r1, r2, lsl 0]
	ldrblt	r15, [r15, r15, lsl 31]
	ldrblt	r0, [r1, r2, lsr 1]
	ldrblt	r15, [r15, r15, lsr 32]
	ldrblt	r0, [r1, r2, asr 1]
	ldrblt	r15, [r15, r15, asr 32]
	ldrblt	r0, [r1, r2, ror 1]
	ldrblt	r15, [r15, r15, ror 31]
	ldrblt	r0, [r1, r2, rrx]
	ldrblt	r15, [r15, r15, rrx]
	ldrblt	r0, [r0, -4095] !
	ldrblt	r15, [r15, +4095] !
	ldrblt	r0, [r0, -r0] !
	ldrblt	r15, [r15, +r15] !
	ldrblt	r0, [r1, r2, lsl 0] !
	ldrblt	r15, [r15, r15, lsl 31] !
	ldrblt	r0, [r1, r2, lsr 1] !
	ldrblt	r15, [r15, r15, lsr 32] !
	ldrblt	r0, [r1, r2, asr 1] !
	ldrblt	r15, [r15, r15, asr 32] !
	ldrblt	r0, [r1, r2, ror 1] !
	ldrblt	r15, [r15, r15, ror 31] !
	ldrblt	r0, [r1, r2, rrx] !
	ldrblt	r15, [r15, r15, rrx] !
	ldrblt	r0, [r0], -4095
	ldrblt	r15, [r15], +4095
	ldrblt	r0, [r0], -r0
	ldrblt	r15, [r15], +r15
	ldrblt	r0, [r1], r2, lsl 0
	ldrblt	r15, [r15], r15, lsl 31
	ldrblt	r0, [r1], r2, lsr 1
	ldrblt	r15, [r15], r15, lsr 32
	ldrblt	r0, [r1], r2, asr 1
	ldrblt	r15, [r15], r15, asr 32
	ldrblt	r0, [r1], r2, ror 1
	ldrblt	r15, [r15], r15, ror 31
	ldrblt	r0, [r1], r2, rrx
	ldrblt	r15, [r15], r15, rrx

positive: ldrbgt instruction

	ldrbgt	r0, [r0, -4095]
	ldrbgt	r15, [r15, +4095]
	ldrbgt	r0, [r0, -r0]
	ldrbgt	r15, [r15, +r15]
	ldrbgt	r0, [r1, r2, lsl 0]
	ldrbgt	r15, [r15, r15, lsl 31]
	ldrbgt	r0, [r1, r2, lsr 1]
	ldrbgt	r15, [r15, r15, lsr 32]
	ldrbgt	r0, [r1, r2, asr 1]
	ldrbgt	r15, [r15, r15, asr 32]
	ldrbgt	r0, [r1, r2, ror 1]
	ldrbgt	r15, [r15, r15, ror 31]
	ldrbgt	r0, [r1, r2, rrx]
	ldrbgt	r15, [r15, r15, rrx]
	ldrbgt	r0, [r0, -4095] !
	ldrbgt	r15, [r15, +4095] !
	ldrbgt	r0, [r0, -r0] !
	ldrbgt	r15, [r15, +r15] !
	ldrbgt	r0, [r1, r2, lsl 0] !
	ldrbgt	r15, [r15, r15, lsl 31] !
	ldrbgt	r0, [r1, r2, lsr 1] !
	ldrbgt	r15, [r15, r15, lsr 32] !
	ldrbgt	r0, [r1, r2, asr 1] !
	ldrbgt	r15, [r15, r15, asr 32] !
	ldrbgt	r0, [r1, r2, ror 1] !
	ldrbgt	r15, [r15, r15, ror 31] !
	ldrbgt	r0, [r1, r2, rrx] !
	ldrbgt	r15, [r15, r15, rrx] !
	ldrbgt	r0, [r0], -4095
	ldrbgt	r15, [r15], +4095
	ldrbgt	r0, [r0], -r0
	ldrbgt	r15, [r15], +r15
	ldrbgt	r0, [r1], r2, lsl 0
	ldrbgt	r15, [r15], r15, lsl 31
	ldrbgt	r0, [r1], r2, lsr 1
	ldrbgt	r15, [r15], r15, lsr 32
	ldrbgt	r0, [r1], r2, asr 1
	ldrbgt	r15, [r15], r15, asr 32
	ldrbgt	r0, [r1], r2, ror 1
	ldrbgt	r15, [r15], r15, ror 31
	ldrbgt	r0, [r1], r2, rrx
	ldrbgt	r15, [r15], r15, rrx

positive: ldrble instruction

	ldrble	r0, [r0, -4095]
	ldrble	r15, [r15, +4095]
	ldrble	r0, [r0, -r0]
	ldrble	r15, [r15, +r15]
	ldrble	r0, [r1, r2, lsl 0]
	ldrble	r15, [r15, r15, lsl 31]
	ldrble	r0, [r1, r2, lsr 1]
	ldrble	r15, [r15, r15, lsr 32]
	ldrble	r0, [r1, r2, asr 1]
	ldrble	r15, [r15, r15, asr 32]
	ldrble	r0, [r1, r2, ror 1]
	ldrble	r15, [r15, r15, ror 31]
	ldrble	r0, [r1, r2, rrx]
	ldrble	r15, [r15, r15, rrx]
	ldrble	r0, [r0, -4095] !
	ldrble	r15, [r15, +4095] !
	ldrble	r0, [r0, -r0] !
	ldrble	r15, [r15, +r15] !
	ldrble	r0, [r1, r2, lsl 0] !
	ldrble	r15, [r15, r15, lsl 31] !
	ldrble	r0, [r1, r2, lsr 1] !
	ldrble	r15, [r15, r15, lsr 32] !
	ldrble	r0, [r1, r2, asr 1] !
	ldrble	r15, [r15, r15, asr 32] !
	ldrble	r0, [r1, r2, ror 1] !
	ldrble	r15, [r15, r15, ror 31] !
	ldrble	r0, [r1, r2, rrx] !
	ldrble	r15, [r15, r15, rrx] !
	ldrble	r0, [r0], -4095
	ldrble	r15, [r15], +4095
	ldrble	r0, [r0], -r0
	ldrble	r15, [r15], +r15
	ldrble	r0, [r1], r2, lsl 0
	ldrble	r15, [r15], r15, lsl 31
	ldrble	r0, [r1], r2, lsr 1
	ldrble	r15, [r15], r15, lsr 32
	ldrble	r0, [r1], r2, asr 1
	ldrble	r15, [r15], r15, asr 32
	ldrble	r0, [r1], r2, ror 1
	ldrble	r15, [r15], r15, ror 31
	ldrble	r0, [r1], r2, rrx
	ldrble	r15, [r15], r15, rrx

positive: ldrbal instruction

	ldrbal	r0, [r0, -4095]
	ldrbal	r15, [r15, +4095]
	ldrbal	r0, [r0, -r0]
	ldrbal	r15, [r15, +r15]
	ldrbal	r0, [r1, r2, lsl 0]
	ldrbal	r15, [r15, r15, lsl 31]
	ldrbal	r0, [r1, r2, lsr 1]
	ldrbal	r15, [r15, r15, lsr 32]
	ldrbal	r0, [r1, r2, asr 1]
	ldrbal	r15, [r15, r15, asr 32]
	ldrbal	r0, [r1, r2, ror 1]
	ldrbal	r15, [r15, r15, ror 31]
	ldrbal	r0, [r1, r2, rrx]
	ldrbal	r15, [r15, r15, rrx]
	ldrbal	r0, [r0, -4095] !
	ldrbal	r15, [r15, +4095] !
	ldrbal	r0, [r0, -r0] !
	ldrbal	r15, [r15, +r15] !
	ldrbal	r0, [r1, r2, lsl 0] !
	ldrbal	r15, [r15, r15, lsl 31] !
	ldrbal	r0, [r1, r2, lsr 1] !
	ldrbal	r15, [r15, r15, lsr 32] !
	ldrbal	r0, [r1, r2, asr 1] !
	ldrbal	r15, [r15, r15, asr 32] !
	ldrbal	r0, [r1, r2, ror 1] !
	ldrbal	r15, [r15, r15, ror 31] !
	ldrbal	r0, [r1, r2, rrx] !
	ldrbal	r15, [r15, r15, rrx] !
	ldrbal	r0, [r0], -4095
	ldrbal	r15, [r15], +4095
	ldrbal	r0, [r0], -r0
	ldrbal	r15, [r15], +r15
	ldrbal	r0, [r1], r2, lsl 0
	ldrbal	r15, [r15], r15, lsl 31
	ldrbal	r0, [r1], r2, lsr 1
	ldrbal	r15, [r15], r15, lsr 32
	ldrbal	r0, [r1], r2, asr 1
	ldrbal	r15, [r15], r15, asr 32
	ldrbal	r0, [r1], r2, ror 1
	ldrbal	r15, [r15], r15, ror 31
	ldrbal	r0, [r1], r2, rrx
	ldrbal	r15, [r15], r15, rrx

positive: ldrbt instruction

	ldrbt	r0, [r0], -4095
	ldrbt	r15, [r15], +4095
	ldrbt	r0, [r0], -r0
	ldrbt	r15, [r15], +r15
	ldrbt	r0, [r1], r2, lsl 0
	ldrbt	r15, [r15], r15, lsl 31
	ldrbt	r0, [r1], r2, lsr 1
	ldrbt	r15, [r15], r15, lsr 32
	ldrbt	r0, [r1], r2, asr 1
	ldrbt	r15, [r15], r15, asr 32
	ldrbt	r0, [r1], r2, ror 1
	ldrbt	r15, [r15], r15, ror 31
	ldrbt	r0, [r1], r2, rrx
	ldrbt	r15, [r15], r15, rrx

positive: ldrbteq instruction

	ldrbteq	r0, [r0], -4095
	ldrbteq	r15, [r15], +4095
	ldrbteq	r0, [r0], -r0
	ldrbteq	r15, [r15], +r15
	ldrbteq	r0, [r1], r2, lsl 0
	ldrbteq	r15, [r15], r15, lsl 31
	ldrbteq	r0, [r1], r2, lsr 1
	ldrbteq	r15, [r15], r15, lsr 32
	ldrbteq	r0, [r1], r2, asr 1
	ldrbteq	r15, [r15], r15, asr 32
	ldrbteq	r0, [r1], r2, ror 1
	ldrbteq	r15, [r15], r15, ror 31
	ldrbteq	r0, [r1], r2, rrx
	ldrbteq	r15, [r15], r15, rrx

positive: ldrbtne instruction

	ldrbtne	r0, [r0], -4095
	ldrbtne	r15, [r15], +4095
	ldrbtne	r0, [r0], -r0
	ldrbtne	r15, [r15], +r15
	ldrbtne	r0, [r1], r2, lsl 0
	ldrbtne	r15, [r15], r15, lsl 31
	ldrbtne	r0, [r1], r2, lsr 1
	ldrbtne	r15, [r15], r15, lsr 32
	ldrbtne	r0, [r1], r2, asr 1
	ldrbtne	r15, [r15], r15, asr 32
	ldrbtne	r0, [r1], r2, ror 1
	ldrbtne	r15, [r15], r15, ror 31
	ldrbtne	r0, [r1], r2, rrx
	ldrbtne	r15, [r15], r15, rrx

positive: ldrbtcs instruction

	ldrbtcs	r0, [r0], -4095
	ldrbtcs	r15, [r15], +4095
	ldrbtcs	r0, [r0], -r0
	ldrbtcs	r15, [r15], +r15
	ldrbtcs	r0, [r1], r2, lsl 0
	ldrbtcs	r15, [r15], r15, lsl 31
	ldrbtcs	r0, [r1], r2, lsr 1
	ldrbtcs	r15, [r15], r15, lsr 32
	ldrbtcs	r0, [r1], r2, asr 1
	ldrbtcs	r15, [r15], r15, asr 32
	ldrbtcs	r0, [r1], r2, ror 1
	ldrbtcs	r15, [r15], r15, ror 31
	ldrbtcs	r0, [r1], r2, rrx
	ldrbtcs	r15, [r15], r15, rrx

positive: ldrbths instruction

	ldrbths	r0, [r0], -4095
	ldrbths	r15, [r15], +4095
	ldrbths	r0, [r0], -r0
	ldrbths	r15, [r15], +r15
	ldrbths	r0, [r1], r2, lsl 0
	ldrbths	r15, [r15], r15, lsl 31
	ldrbths	r0, [r1], r2, lsr 1
	ldrbths	r15, [r15], r15, lsr 32
	ldrbths	r0, [r1], r2, asr 1
	ldrbths	r15, [r15], r15, asr 32
	ldrbths	r0, [r1], r2, ror 1
	ldrbths	r15, [r15], r15, ror 31
	ldrbths	r0, [r1], r2, rrx
	ldrbths	r15, [r15], r15, rrx

positive: ldrbtcc instruction

	ldrbtcc	r0, [r0], -4095
	ldrbtcc	r15, [r15], +4095
	ldrbtcc	r0, [r0], -r0
	ldrbtcc	r15, [r15], +r15
	ldrbtcc	r0, [r1], r2, lsl 0
	ldrbtcc	r15, [r15], r15, lsl 31
	ldrbtcc	r0, [r1], r2, lsr 1
	ldrbtcc	r15, [r15], r15, lsr 32
	ldrbtcc	r0, [r1], r2, asr 1
	ldrbtcc	r15, [r15], r15, asr 32
	ldrbtcc	r0, [r1], r2, ror 1
	ldrbtcc	r15, [r15], r15, ror 31
	ldrbtcc	r0, [r1], r2, rrx
	ldrbtcc	r15, [r15], r15, rrx

positive: ldrbtlo instruction

	ldrbtlo	r0, [r0], -4095
	ldrbtlo	r15, [r15], +4095
	ldrbtlo	r0, [r0], -r0
	ldrbtlo	r15, [r15], +r15
	ldrbtlo	r0, [r1], r2, lsl 0
	ldrbtlo	r15, [r15], r15, lsl 31
	ldrbtlo	r0, [r1], r2, lsr 1
	ldrbtlo	r15, [r15], r15, lsr 32
	ldrbtlo	r0, [r1], r2, asr 1
	ldrbtlo	r15, [r15], r15, asr 32
	ldrbtlo	r0, [r1], r2, ror 1
	ldrbtlo	r15, [r15], r15, ror 31
	ldrbtlo	r0, [r1], r2, rrx
	ldrbtlo	r15, [r15], r15, rrx

positive: ldrbtmi instruction

	ldrbtmi	r0, [r0], -4095
	ldrbtmi	r15, [r15], +4095
	ldrbtmi	r0, [r0], -r0
	ldrbtmi	r15, [r15], +r15
	ldrbtmi	r0, [r1], r2, lsl 0
	ldrbtmi	r15, [r15], r15, lsl 31
	ldrbtmi	r0, [r1], r2, lsr 1
	ldrbtmi	r15, [r15], r15, lsr 32
	ldrbtmi	r0, [r1], r2, asr 1
	ldrbtmi	r15, [r15], r15, asr 32
	ldrbtmi	r0, [r1], r2, ror 1
	ldrbtmi	r15, [r15], r15, ror 31
	ldrbtmi	r0, [r1], r2, rrx
	ldrbtmi	r15, [r15], r15, rrx

positive: ldrbtpl instruction

	ldrbtpl	r0, [r0], -4095
	ldrbtpl	r15, [r15], +4095
	ldrbtpl	r0, [r0], -r0
	ldrbtpl	r15, [r15], +r15
	ldrbtpl	r0, [r1], r2, lsl 0
	ldrbtpl	r15, [r15], r15, lsl 31
	ldrbtpl	r0, [r1], r2, lsr 1
	ldrbtpl	r15, [r15], r15, lsr 32
	ldrbtpl	r0, [r1], r2, asr 1
	ldrbtpl	r15, [r15], r15, asr 32
	ldrbtpl	r0, [r1], r2, ror 1
	ldrbtpl	r15, [r15], r15, ror 31
	ldrbtpl	r0, [r1], r2, rrx
	ldrbtpl	r15, [r15], r15, rrx

positive: ldrbtvs instruction

	ldrbtvs	r0, [r0], -4095
	ldrbtvs	r15, [r15], +4095
	ldrbtvs	r0, [r0], -r0
	ldrbtvs	r15, [r15], +r15
	ldrbtvs	r0, [r1], r2, lsl 0
	ldrbtvs	r15, [r15], r15, lsl 31
	ldrbtvs	r0, [r1], r2, lsr 1
	ldrbtvs	r15, [r15], r15, lsr 32
	ldrbtvs	r0, [r1], r2, asr 1
	ldrbtvs	r15, [r15], r15, asr 32
	ldrbtvs	r0, [r1], r2, ror 1
	ldrbtvs	r15, [r15], r15, ror 31
	ldrbtvs	r0, [r1], r2, rrx
	ldrbtvs	r15, [r15], r15, rrx

positive: ldrbtvc instruction

	ldrbtvc	r0, [r0], -4095
	ldrbtvc	r15, [r15], +4095
	ldrbtvc	r0, [r0], -r0
	ldrbtvc	r15, [r15], +r15
	ldrbtvc	r0, [r1], r2, lsl 0
	ldrbtvc	r15, [r15], r15, lsl 31
	ldrbtvc	r0, [r1], r2, lsr 1
	ldrbtvc	r15, [r15], r15, lsr 32
	ldrbtvc	r0, [r1], r2, asr 1
	ldrbtvc	r15, [r15], r15, asr 32
	ldrbtvc	r0, [r1], r2, ror 1
	ldrbtvc	r15, [r15], r15, ror 31
	ldrbtvc	r0, [r1], r2, rrx
	ldrbtvc	r15, [r15], r15, rrx

positive: ldrbthi instruction

	ldrbthi	r0, [r0], -4095
	ldrbthi	r15, [r15], +4095
	ldrbthi	r0, [r0], -r0
	ldrbthi	r15, [r15], +r15
	ldrbthi	r0, [r1], r2, lsl 0
	ldrbthi	r15, [r15], r15, lsl 31
	ldrbthi	r0, [r1], r2, lsr 1
	ldrbthi	r15, [r15], r15, lsr 32
	ldrbthi	r0, [r1], r2, asr 1
	ldrbthi	r15, [r15], r15, asr 32
	ldrbthi	r0, [r1], r2, ror 1
	ldrbthi	r15, [r15], r15, ror 31
	ldrbthi	r0, [r1], r2, rrx
	ldrbthi	r15, [r15], r15, rrx

positive: ldrbtls instruction

	ldrbtls	r0, [r0], -4095
	ldrbtls	r15, [r15], +4095
	ldrbtls	r0, [r0], -r0
	ldrbtls	r15, [r15], +r15
	ldrbtls	r0, [r1], r2, lsl 0
	ldrbtls	r15, [r15], r15, lsl 31
	ldrbtls	r0, [r1], r2, lsr 1
	ldrbtls	r15, [r15], r15, lsr 32
	ldrbtls	r0, [r1], r2, asr 1
	ldrbtls	r15, [r15], r15, asr 32
	ldrbtls	r0, [r1], r2, ror 1
	ldrbtls	r15, [r15], r15, ror 31
	ldrbtls	r0, [r1], r2, rrx
	ldrbtls	r15, [r15], r15, rrx

positive: ldrbtge instruction

	ldrbtge	r0, [r0], -4095
	ldrbtge	r15, [r15], +4095
	ldrbtge	r0, [r0], -r0
	ldrbtge	r15, [r15], +r15
	ldrbtge	r0, [r1], r2, lsl 0
	ldrbtge	r15, [r15], r15, lsl 31
	ldrbtge	r0, [r1], r2, lsr 1
	ldrbtge	r15, [r15], r15, lsr 32
	ldrbtge	r0, [r1], r2, asr 1
	ldrbtge	r15, [r15], r15, asr 32
	ldrbtge	r0, [r1], r2, ror 1
	ldrbtge	r15, [r15], r15, ror 31
	ldrbtge	r0, [r1], r2, rrx
	ldrbtge	r15, [r15], r15, rrx

positive: ldrbtlt instruction

	ldrbtlt	r0, [r0], -4095
	ldrbtlt	r15, [r15], +4095
	ldrbtlt	r0, [r0], -r0
	ldrbtlt	r15, [r15], +r15
	ldrbtlt	r0, [r1], r2, lsl 0
	ldrbtlt	r15, [r15], r15, lsl 31
	ldrbtlt	r0, [r1], r2, lsr 1
	ldrbtlt	r15, [r15], r15, lsr 32
	ldrbtlt	r0, [r1], r2, asr 1
	ldrbtlt	r15, [r15], r15, asr 32
	ldrbtlt	r0, [r1], r2, ror 1
	ldrbtlt	r15, [r15], r15, ror 31
	ldrbtlt	r0, [r1], r2, rrx
	ldrbtlt	r15, [r15], r15, rrx

positive: ldrbtgt instruction

	ldrbtgt	r0, [r0], -4095
	ldrbtgt	r15, [r15], +4095
	ldrbtgt	r0, [r0], -r0
	ldrbtgt	r15, [r15], +r15
	ldrbtgt	r0, [r1], r2, lsl 0
	ldrbtgt	r15, [r15], r15, lsl 31
	ldrbtgt	r0, [r1], r2, lsr 1
	ldrbtgt	r15, [r15], r15, lsr 32
	ldrbtgt	r0, [r1], r2, asr 1
	ldrbtgt	r15, [r15], r15, asr 32
	ldrbtgt	r0, [r1], r2, ror 1
	ldrbtgt	r15, [r15], r15, ror 31
	ldrbtgt	r0, [r1], r2, rrx
	ldrbtgt	r15, [r15], r15, rrx

positive: ldrbtle instruction

	ldrbtle	r0, [r0], -4095
	ldrbtle	r15, [r15], +4095
	ldrbtle	r0, [r0], -r0
	ldrbtle	r15, [r15], +r15
	ldrbtle	r0, [r1], r2, lsl 0
	ldrbtle	r15, [r15], r15, lsl 31
	ldrbtle	r0, [r1], r2, lsr 1
	ldrbtle	r15, [r15], r15, lsr 32
	ldrbtle	r0, [r1], r2, asr 1
	ldrbtle	r15, [r15], r15, asr 32
	ldrbtle	r0, [r1], r2, ror 1
	ldrbtle	r15, [r15], r15, ror 31
	ldrbtle	r0, [r1], r2, rrx
	ldrbtle	r15, [r15], r15, rrx

positive: ldrbtal instruction

	ldrbtal	r0, [r0], -4095
	ldrbtal	r15, [r15], +4095
	ldrbtal	r0, [r0], -r0
	ldrbtal	r15, [r15], +r15
	ldrbtal	r0, [r1], r2, lsl 0
	ldrbtal	r15, [r15], r15, lsl 31
	ldrbtal	r0, [r1], r2, lsr 1
	ldrbtal	r15, [r15], r15, lsr 32
	ldrbtal	r0, [r1], r2, asr 1
	ldrbtal	r15, [r15], r15, asr 32
	ldrbtal	r0, [r1], r2, ror 1
	ldrbtal	r15, [r15], r15, ror 31
	ldrbtal	r0, [r1], r2, rrx
	ldrbtal	r15, [r15], r15, rrx

positive: ldrh instruction

	ldrh	r0, [r0, -255]
	ldrh	r15, [r15, +255]
	ldrh	r0, [r0, -r0]
	ldrh	r15, [r15, +r15]
	ldrh	r0, [r0, -255]!
	ldrh	r15, [r15, +255]!
	ldrh	r0, [r0, -r0]!
	ldrh	r15, [r15, +r15]!
	ldrh	r0, [r0], -255
	ldrh	r15, [r15], +255
	ldrh	r0, [r0], -r0
	ldrh	r15, [r15], +r15

positive: ldrheq instruction

	ldrheq	r0, [r0, -255]
	ldrheq	r15, [r15, +255]
	ldrheq	r0, [r0, -r0]
	ldrheq	r15, [r15, +r15]
	ldrheq	r0, [r0, -255]!
	ldrheq	r15, [r15, +255]!
	ldrheq	r0, [r0, -r0]!
	ldrheq	r15, [r15, +r15]!
	ldrheq	r0, [r0], -255
	ldrheq	r15, [r15], +255
	ldrheq	r0, [r0], -r0
	ldrheq	r15, [r15], +r15

positive: ldrhne instruction

	ldrhne	r0, [r0, -255]
	ldrhne	r15, [r15, +255]
	ldrhne	r0, [r0, -r0]
	ldrhne	r15, [r15, +r15]
	ldrhne	r0, [r0, -255]!
	ldrhne	r15, [r15, +255]!
	ldrhne	r0, [r0, -r0]!
	ldrhne	r15, [r15, +r15]!
	ldrhne	r0, [r0], -255
	ldrhne	r15, [r15], +255
	ldrhne	r0, [r0], -r0
	ldrhne	r15, [r15], +r15

positive: ldrhcs instruction

	ldrhcs	r0, [r0, -255]
	ldrhcs	r15, [r15, +255]
	ldrhcs	r0, [r0, -r0]
	ldrhcs	r15, [r15, +r15]
	ldrhcs	r0, [r0, -255]!
	ldrhcs	r15, [r15, +255]!
	ldrhcs	r0, [r0, -r0]!
	ldrhcs	r15, [r15, +r15]!
	ldrhcs	r0, [r0], -255
	ldrhcs	r15, [r15], +255
	ldrhcs	r0, [r0], -r0
	ldrhcs	r15, [r15], +r15

positive: ldrhhs instruction

	ldrhhs	r0, [r0, -255]
	ldrhhs	r15, [r15, +255]
	ldrhhs	r0, [r0, -r0]
	ldrhhs	r15, [r15, +r15]
	ldrhhs	r0, [r0, -255]!
	ldrhhs	r15, [r15, +255]!
	ldrhhs	r0, [r0, -r0]!
	ldrhhs	r15, [r15, +r15]!
	ldrhhs	r0, [r0], -255
	ldrhhs	r15, [r15], +255
	ldrhhs	r0, [r0], -r0
	ldrhhs	r15, [r15], +r15

positive: ldrhcc instruction

	ldrhcc	r0, [r0, -255]
	ldrhcc	r15, [r15, +255]
	ldrhcc	r0, [r0, -r0]
	ldrhcc	r15, [r15, +r15]
	ldrhcc	r0, [r0, -255]!
	ldrhcc	r15, [r15, +255]!
	ldrhcc	r0, [r0, -r0]!
	ldrhcc	r15, [r15, +r15]!
	ldrhcc	r0, [r0], -255
	ldrhcc	r15, [r15], +255
	ldrhcc	r0, [r0], -r0
	ldrhcc	r15, [r15], +r15

positive: ldrhlo instruction

	ldrhlo	r0, [r0, -255]
	ldrhlo	r15, [r15, +255]
	ldrhlo	r0, [r0, -r0]
	ldrhlo	r15, [r15, +r15]
	ldrhlo	r0, [r0, -255]!
	ldrhlo	r15, [r15, +255]!
	ldrhlo	r0, [r0, -r0]!
	ldrhlo	r15, [r15, +r15]!
	ldrhlo	r0, [r0], -255
	ldrhlo	r15, [r15], +255
	ldrhlo	r0, [r0], -r0
	ldrhlo	r15, [r15], +r15

positive: ldrhmi instruction

	ldrhmi	r0, [r0, -255]
	ldrhmi	r15, [r15, +255]
	ldrhmi	r0, [r0, -r0]
	ldrhmi	r15, [r15, +r15]
	ldrhmi	r0, [r0, -255]!
	ldrhmi	r15, [r15, +255]!
	ldrhmi	r0, [r0, -r0]!
	ldrhmi	r15, [r15, +r15]!
	ldrhmi	r0, [r0], -255
	ldrhmi	r15, [r15], +255
	ldrhmi	r0, [r0], -r0
	ldrhmi	r15, [r15], +r15

positive: ldrhpl instruction

	ldrhpl	r0, [r0, -255]
	ldrhpl	r15, [r15, +255]
	ldrhpl	r0, [r0, -r0]
	ldrhpl	r15, [r15, +r15]
	ldrhpl	r0, [r0, -255]!
	ldrhpl	r15, [r15, +255]!
	ldrhpl	r0, [r0, -r0]!
	ldrhpl	r15, [r15, +r15]!
	ldrhpl	r0, [r0], -255
	ldrhpl	r15, [r15], +255
	ldrhpl	r0, [r0], -r0
	ldrhpl	r15, [r15], +r15

positive: ldrhvs instruction

	ldrhvs	r0, [r0, -255]
	ldrhvs	r15, [r15, +255]
	ldrhvs	r0, [r0, -r0]
	ldrhvs	r15, [r15, +r15]
	ldrhvs	r0, [r0, -255]!
	ldrhvs	r15, [r15, +255]!
	ldrhvs	r0, [r0, -r0]!
	ldrhvs	r15, [r15, +r15]!
	ldrhvs	r0, [r0], -255
	ldrhvs	r15, [r15], +255
	ldrhvs	r0, [r0], -r0
	ldrhvs	r15, [r15], +r15

positive: ldrhvc instruction

	ldrhvc	r0, [r0, -255]
	ldrhvc	r15, [r15, +255]
	ldrhvc	r0, [r0, -r0]
	ldrhvc	r15, [r15, +r15]
	ldrhvc	r0, [r0, -255]!
	ldrhvc	r15, [r15, +255]!
	ldrhvc	r0, [r0, -r0]!
	ldrhvc	r15, [r15, +r15]!
	ldrhvc	r0, [r0], -255
	ldrhvc	r15, [r15], +255
	ldrhvc	r0, [r0], -r0
	ldrhvc	r15, [r15], +r15

positive: ldrhhi instruction

	ldrhhi	r0, [r0, -255]
	ldrhhi	r15, [r15, +255]
	ldrhhi	r0, [r0, -r0]
	ldrhhi	r15, [r15, +r15]
	ldrhhi	r0, [r0, -255]!
	ldrhhi	r15, [r15, +255]!
	ldrhhi	r0, [r0, -r0]!
	ldrhhi	r15, [r15, +r15]!
	ldrhhi	r0, [r0], -255
	ldrhhi	r15, [r15], +255
	ldrhhi	r0, [r0], -r0
	ldrhhi	r15, [r15], +r15

positive: ldrhls instruction

	ldrhls	r0, [r0, -255]
	ldrhls	r15, [r15, +255]
	ldrhls	r0, [r0, -r0]
	ldrhls	r15, [r15, +r15]
	ldrhls	r0, [r0, -255]!
	ldrhls	r15, [r15, +255]!
	ldrhls	r0, [r0, -r0]!
	ldrhls	r15, [r15, +r15]!
	ldrhls	r0, [r0], -255
	ldrhls	r15, [r15], +255
	ldrhls	r0, [r0], -r0
	ldrhls	r15, [r15], +r15

positive: ldrhge instruction

	ldrhge	r0, [r0, -255]
	ldrhge	r15, [r15, +255]
	ldrhge	r0, [r0, -r0]
	ldrhge	r15, [r15, +r15]
	ldrhge	r0, [r0, -255]!
	ldrhge	r15, [r15, +255]!
	ldrhge	r0, [r0, -r0]!
	ldrhge	r15, [r15, +r15]!
	ldrhge	r0, [r0], -255
	ldrhge	r15, [r15], +255
	ldrhge	r0, [r0], -r0
	ldrhge	r15, [r15], +r15

positive: ldrhlt instruction

	ldrhlt	r0, [r0, -255]
	ldrhlt	r15, [r15, +255]
	ldrhlt	r0, [r0, -r0]
	ldrhlt	r15, [r15, +r15]
	ldrhlt	r0, [r0, -255]!
	ldrhlt	r15, [r15, +255]!
	ldrhlt	r0, [r0, -r0]!
	ldrhlt	r15, [r15, +r15]!
	ldrhlt	r0, [r0], -255
	ldrhlt	r15, [r15], +255
	ldrhlt	r0, [r0], -r0
	ldrhlt	r15, [r15], +r15

positive: ldrhgt instruction

	ldrhgt	r0, [r0, -255]
	ldrhgt	r15, [r15, +255]
	ldrhgt	r0, [r0, -r0]
	ldrhgt	r15, [r15, +r15]
	ldrhgt	r0, [r0, -255]!
	ldrhgt	r15, [r15, +255]!
	ldrhgt	r0, [r0, -r0]!
	ldrhgt	r15, [r15, +r15]!
	ldrhgt	r0, [r0], -255
	ldrhgt	r15, [r15], +255
	ldrhgt	r0, [r0], -r0
	ldrhgt	r15, [r15], +r15

positive: ldrhle instruction

	ldrhle	r0, [r0, -255]
	ldrhle	r15, [r15, +255]
	ldrhle	r0, [r0, -r0]
	ldrhle	r15, [r15, +r15]
	ldrhle	r0, [r0, -255]!
	ldrhle	r15, [r15, +255]!
	ldrhle	r0, [r0, -r0]!
	ldrhle	r15, [r15, +r15]!
	ldrhle	r0, [r0], -255
	ldrhle	r15, [r15], +255
	ldrhle	r0, [r0], -r0
	ldrhle	r15, [r15], +r15

positive: ldrhal instruction

	ldrhal	r0, [r0, -255]
	ldrhal	r15, [r15, +255]
	ldrhal	r0, [r0, -r0]
	ldrhal	r15, [r15, +r15]
	ldrhal	r0, [r0, -255]!
	ldrhal	r15, [r15, +255]!
	ldrhal	r0, [r0, -r0]!
	ldrhal	r15, [r15, +r15]!
	ldrhal	r0, [r0], -255
	ldrhal	r15, [r15], +255
	ldrhal	r0, [r0], -r0
	ldrhal	r15, [r15], +r15

positive: ldrsb instruction

	ldrsb	r0, [r0, -255]
	ldrsb	r15, [r15, +255]
	ldrsb	r0, [r0, -r0]
	ldrsb	r15, [r15, +r15]
	ldrsb	r0, [r0, -255]!
	ldrsb	r15, [r15, +255]!
	ldrsb	r0, [r0, -r0]!
	ldrsb	r15, [r15, +r15]!
	ldrsb	r0, [r0], -255
	ldrsb	r15, [r15], +255
	ldrsb	r0, [r0], -r0
	ldrsb	r15, [r15], +r15

positive: ldrsbeq instruction

	ldrsbeq	r0, [r0, -255]
	ldrsbeq	r15, [r15, +255]
	ldrsbeq	r0, [r0, -r0]
	ldrsbeq	r15, [r15, +r15]
	ldrsbeq	r0, [r0, -255]!
	ldrsbeq	r15, [r15, +255]!
	ldrsbeq	r0, [r0, -r0]!
	ldrsbeq	r15, [r15, +r15]!
	ldrsbeq	r0, [r0], -255
	ldrsbeq	r15, [r15], +255
	ldrsbeq	r0, [r0], -r0
	ldrsbeq	r15, [r15], +r15

positive: ldrsbne instruction

	ldrsbne	r0, [r0, -255]
	ldrsbne	r15, [r15, +255]
	ldrsbne	r0, [r0, -r0]
	ldrsbne	r15, [r15, +r15]
	ldrsbne	r0, [r0, -255]!
	ldrsbne	r15, [r15, +255]!
	ldrsbne	r0, [r0, -r0]!
	ldrsbne	r15, [r15, +r15]!
	ldrsbne	r0, [r0], -255
	ldrsbne	r15, [r15], +255
	ldrsbne	r0, [r0], -r0
	ldrsbne	r15, [r15], +r15

positive: ldrsbcs instruction

	ldrsbcs	r0, [r0, -255]
	ldrsbcs	r15, [r15, +255]
	ldrsbcs	r0, [r0, -r0]
	ldrsbcs	r15, [r15, +r15]
	ldrsbcs	r0, [r0, -255]!
	ldrsbcs	r15, [r15, +255]!
	ldrsbcs	r0, [r0, -r0]!
	ldrsbcs	r15, [r15, +r15]!
	ldrsbcs	r0, [r0], -255
	ldrsbcs	r15, [r15], +255
	ldrsbcs	r0, [r0], -r0
	ldrsbcs	r15, [r15], +r15

positive: ldrsbhs instruction

	ldrsbhs	r0, [r0, -255]
	ldrsbhs	r15, [r15, +255]
	ldrsbhs	r0, [r0, -r0]
	ldrsbhs	r15, [r15, +r15]
	ldrsbhs	r0, [r0, -255]!
	ldrsbhs	r15, [r15, +255]!
	ldrsbhs	r0, [r0, -r0]!
	ldrsbhs	r15, [r15, +r15]!
	ldrsbhs	r0, [r0], -255
	ldrsbhs	r15, [r15], +255
	ldrsbhs	r0, [r0], -r0
	ldrsbhs	r15, [r15], +r15

positive: ldrsbcc instruction

	ldrsbcc	r0, [r0, -255]
	ldrsbcc	r15, [r15, +255]
	ldrsbcc	r0, [r0, -r0]
	ldrsbcc	r15, [r15, +r15]
	ldrsbcc	r0, [r0, -255]!
	ldrsbcc	r15, [r15, +255]!
	ldrsbcc	r0, [r0, -r0]!
	ldrsbcc	r15, [r15, +r15]!
	ldrsbcc	r0, [r0], -255
	ldrsbcc	r15, [r15], +255
	ldrsbcc	r0, [r0], -r0
	ldrsbcc	r15, [r15], +r15

positive: ldrsblo instruction

	ldrsblo	r0, [r0, -255]
	ldrsblo	r15, [r15, +255]
	ldrsblo	r0, [r0, -r0]
	ldrsblo	r15, [r15, +r15]
	ldrsblo	r0, [r0, -255]!
	ldrsblo	r15, [r15, +255]!
	ldrsblo	r0, [r0, -r0]!
	ldrsblo	r15, [r15, +r15]!
	ldrsblo	r0, [r0], -255
	ldrsblo	r15, [r15], +255
	ldrsblo	r0, [r0], -r0
	ldrsblo	r15, [r15], +r15

positive: ldrsbmi instruction

	ldrsbmi	r0, [r0, -255]
	ldrsbmi	r15, [r15, +255]
	ldrsbmi	r0, [r0, -r0]
	ldrsbmi	r15, [r15, +r15]
	ldrsbmi	r0, [r0, -255]!
	ldrsbmi	r15, [r15, +255]!
	ldrsbmi	r0, [r0, -r0]!
	ldrsbmi	r15, [r15, +r15]!
	ldrsbmi	r0, [r0], -255
	ldrsbmi	r15, [r15], +255
	ldrsbmi	r0, [r0], -r0
	ldrsbmi	r15, [r15], +r15

positive: ldrsbpl instruction

	ldrsbpl	r0, [r0, -255]
	ldrsbpl	r15, [r15, +255]
	ldrsbpl	r0, [r0, -r0]
	ldrsbpl	r15, [r15, +r15]
	ldrsbpl	r0, [r0, -255]!
	ldrsbpl	r15, [r15, +255]!
	ldrsbpl	r0, [r0, -r0]!
	ldrsbpl	r15, [r15, +r15]!
	ldrsbpl	r0, [r0], -255
	ldrsbpl	r15, [r15], +255
	ldrsbpl	r0, [r0], -r0
	ldrsbpl	r15, [r15], +r15

positive: ldrsbvs instruction

	ldrsbvs	r0, [r0, -255]
	ldrsbvs	r15, [r15, +255]
	ldrsbvs	r0, [r0, -r0]
	ldrsbvs	r15, [r15, +r15]
	ldrsbvs	r0, [r0, -255]!
	ldrsbvs	r15, [r15, +255]!
	ldrsbvs	r0, [r0, -r0]!
	ldrsbvs	r15, [r15, +r15]!
	ldrsbvs	r0, [r0], -255
	ldrsbvs	r15, [r15], +255
	ldrsbvs	r0, [r0], -r0
	ldrsbvs	r15, [r15], +r15

positive: ldrsbvc instruction

	ldrsbvc	r0, [r0, -255]
	ldrsbvc	r15, [r15, +255]
	ldrsbvc	r0, [r0, -r0]
	ldrsbvc	r15, [r15, +r15]
	ldrsbvc	r0, [r0, -255]!
	ldrsbvc	r15, [r15, +255]!
	ldrsbvc	r0, [r0, -r0]!
	ldrsbvc	r15, [r15, +r15]!
	ldrsbvc	r0, [r0], -255
	ldrsbvc	r15, [r15], +255
	ldrsbvc	r0, [r0], -r0
	ldrsbvc	r15, [r15], +r15

positive: ldrsbhi instruction

	ldrsbhi	r0, [r0, -255]
	ldrsbhi	r15, [r15, +255]
	ldrsbhi	r0, [r0, -r0]
	ldrsbhi	r15, [r15, +r15]
	ldrsbhi	r0, [r0, -255]!
	ldrsbhi	r15, [r15, +255]!
	ldrsbhi	r0, [r0, -r0]!
	ldrsbhi	r15, [r15, +r15]!
	ldrsbhi	r0, [r0], -255
	ldrsbhi	r15, [r15], +255
	ldrsbhi	r0, [r0], -r0
	ldrsbhi	r15, [r15], +r15

positive: ldrsbls instruction

	ldrsbls	r0, [r0, -255]
	ldrsbls	r15, [r15, +255]
	ldrsbls	r0, [r0, -r0]
	ldrsbls	r15, [r15, +r15]
	ldrsbls	r0, [r0, -255]!
	ldrsbls	r15, [r15, +255]!
	ldrsbls	r0, [r0, -r0]!
	ldrsbls	r15, [r15, +r15]!
	ldrsbls	r0, [r0], -255
	ldrsbls	r15, [r15], +255
	ldrsbls	r0, [r0], -r0
	ldrsbls	r15, [r15], +r15

positive: ldrsbge instruction

	ldrsbge	r0, [r0, -255]
	ldrsbge	r15, [r15, +255]
	ldrsbge	r0, [r0, -r0]
	ldrsbge	r15, [r15, +r15]
	ldrsbge	r0, [r0, -255]!
	ldrsbge	r15, [r15, +255]!
	ldrsbge	r0, [r0, -r0]!
	ldrsbge	r15, [r15, +r15]!
	ldrsbge	r0, [r0], -255
	ldrsbge	r15, [r15], +255
	ldrsbge	r0, [r0], -r0
	ldrsbge	r15, [r15], +r15

positive: ldrsblt instruction

	ldrsblt	r0, [r0, -255]
	ldrsblt	r15, [r15, +255]
	ldrsblt	r0, [r0, -r0]
	ldrsblt	r15, [r15, +r15]
	ldrsblt	r0, [r0, -255]!
	ldrsblt	r15, [r15, +255]!
	ldrsblt	r0, [r0, -r0]!
	ldrsblt	r15, [r15, +r15]!
	ldrsblt	r0, [r0], -255
	ldrsblt	r15, [r15], +255
	ldrsblt	r0, [r0], -r0
	ldrsblt	r15, [r15], +r15

positive: ldrsbgt instruction

	ldrsbgt	r0, [r0, -255]
	ldrsbgt	r15, [r15, +255]
	ldrsbgt	r0, [r0, -r0]
	ldrsbgt	r15, [r15, +r15]
	ldrsbgt	r0, [r0, -255]!
	ldrsbgt	r15, [r15, +255]!
	ldrsbgt	r0, [r0, -r0]!
	ldrsbgt	r15, [r15, +r15]!
	ldrsbgt	r0, [r0], -255
	ldrsbgt	r15, [r15], +255
	ldrsbgt	r0, [r0], -r0
	ldrsbgt	r15, [r15], +r15

positive: ldrsble instruction

	ldrsble	r0, [r0, -255]
	ldrsble	r15, [r15, +255]
	ldrsble	r0, [r0, -r0]
	ldrsble	r15, [r15, +r15]
	ldrsble	r0, [r0, -255]!
	ldrsble	r15, [r15, +255]!
	ldrsble	r0, [r0, -r0]!
	ldrsble	r15, [r15, +r15]!
	ldrsble	r0, [r0], -255
	ldrsble	r15, [r15], +255
	ldrsble	r0, [r0], -r0
	ldrsble	r15, [r15], +r15

positive: ldrsbal instruction

	ldrsbal	r0, [r0, -255]
	ldrsbal	r15, [r15, +255]
	ldrsbal	r0, [r0, -r0]
	ldrsbal	r15, [r15, +r15]
	ldrsbal	r0, [r0, -255]!
	ldrsbal	r15, [r15, +255]!
	ldrsbal	r0, [r0, -r0]!
	ldrsbal	r15, [r15, +r15]!
	ldrsbal	r0, [r0], -255
	ldrsbal	r15, [r15], +255
	ldrsbal	r0, [r0], -r0
	ldrsbal	r15, [r15], +r15

positive: ldrsh instruction

	ldrsh	r0, [r0, -255]
	ldrsh	r15, [r15, +255]
	ldrsh	r0, [r0, -r0]
	ldrsh	r15, [r15, +r15]
	ldrsh	r0, [r0, -255]!
	ldrsh	r15, [r15, +255]!
	ldrsh	r0, [r0, -r0]!
	ldrsh	r15, [r15, +r15]!
	ldrsh	r0, [r0], -255
	ldrsh	r15, [r15], +255
	ldrsh	r0, [r0], -r0
	ldrsh	r15, [r15], +r15

positive: ldrsheq instruction

	ldrsheq	r0, [r0, -255]
	ldrsheq	r15, [r15, +255]
	ldrsheq	r0, [r0, -r0]
	ldrsheq	r15, [r15, +r15]
	ldrsheq	r0, [r0, -255]!
	ldrsheq	r15, [r15, +255]!
	ldrsheq	r0, [r0, -r0]!
	ldrsheq	r15, [r15, +r15]!
	ldrsheq	r0, [r0], -255
	ldrsheq	r15, [r15], +255
	ldrsheq	r0, [r0], -r0
	ldrsheq	r15, [r15], +r15

positive: ldrshne instruction

	ldrshne	r0, [r0, -255]
	ldrshne	r15, [r15, +255]
	ldrshne	r0, [r0, -r0]
	ldrshne	r15, [r15, +r15]
	ldrshne	r0, [r0, -255]!
	ldrshne	r15, [r15, +255]!
	ldrshne	r0, [r0, -r0]!
	ldrshne	r15, [r15, +r15]!
	ldrshne	r0, [r0], -255
	ldrshne	r15, [r15], +255
	ldrshne	r0, [r0], -r0
	ldrshne	r15, [r15], +r15

positive: ldrshcs instruction

	ldrshcs	r0, [r0, -255]
	ldrshcs	r15, [r15, +255]
	ldrshcs	r0, [r0, -r0]
	ldrshcs	r15, [r15, +r15]
	ldrshcs	r0, [r0, -255]!
	ldrshcs	r15, [r15, +255]!
	ldrshcs	r0, [r0, -r0]!
	ldrshcs	r15, [r15, +r15]!
	ldrshcs	r0, [r0], -255
	ldrshcs	r15, [r15], +255
	ldrshcs	r0, [r0], -r0
	ldrshcs	r15, [r15], +r15

positive: ldrshhs instruction

	ldrshhs	r0, [r0, -255]
	ldrshhs	r15, [r15, +255]
	ldrshhs	r0, [r0, -r0]
	ldrshhs	r15, [r15, +r15]
	ldrshhs	r0, [r0, -255]!
	ldrshhs	r15, [r15, +255]!
	ldrshhs	r0, [r0, -r0]!
	ldrshhs	r15, [r15, +r15]!
	ldrshhs	r0, [r0], -255
	ldrshhs	r15, [r15], +255
	ldrshhs	r0, [r0], -r0
	ldrshhs	r15, [r15], +r15

positive: ldrshcc instruction

	ldrshcc	r0, [r0, -255]
	ldrshcc	r15, [r15, +255]
	ldrshcc	r0, [r0, -r0]
	ldrshcc	r15, [r15, +r15]
	ldrshcc	r0, [r0, -255]!
	ldrshcc	r15, [r15, +255]!
	ldrshcc	r0, [r0, -r0]!
	ldrshcc	r15, [r15, +r15]!
	ldrshcc	r0, [r0], -255
	ldrshcc	r15, [r15], +255
	ldrshcc	r0, [r0], -r0
	ldrshcc	r15, [r15], +r15

positive: ldrshlo instruction

	ldrshlo	r0, [r0, -255]
	ldrshlo	r15, [r15, +255]
	ldrshlo	r0, [r0, -r0]
	ldrshlo	r15, [r15, +r15]
	ldrshlo	r0, [r0, -255]!
	ldrshlo	r15, [r15, +255]!
	ldrshlo	r0, [r0, -r0]!
	ldrshlo	r15, [r15, +r15]!
	ldrshlo	r0, [r0], -255
	ldrshlo	r15, [r15], +255
	ldrshlo	r0, [r0], -r0
	ldrshlo	r15, [r15], +r15

positive: ldrshmi instruction

	ldrshmi	r0, [r0, -255]
	ldrshmi	r15, [r15, +255]
	ldrshmi	r0, [r0, -r0]
	ldrshmi	r15, [r15, +r15]
	ldrshmi	r0, [r0, -255]!
	ldrshmi	r15, [r15, +255]!
	ldrshmi	r0, [r0, -r0]!
	ldrshmi	r15, [r15, +r15]!
	ldrshmi	r0, [r0], -255
	ldrshmi	r15, [r15], +255
	ldrshmi	r0, [r0], -r0
	ldrshmi	r15, [r15], +r15

positive: ldrshpl instruction

	ldrshpl	r0, [r0, -255]
	ldrshpl	r15, [r15, +255]
	ldrshpl	r0, [r0, -r0]
	ldrshpl	r15, [r15, +r15]
	ldrshpl	r0, [r0, -255]!
	ldrshpl	r15, [r15, +255]!
	ldrshpl	r0, [r0, -r0]!
	ldrshpl	r15, [r15, +r15]!
	ldrshpl	r0, [r0], -255
	ldrshpl	r15, [r15], +255
	ldrshpl	r0, [r0], -r0
	ldrshpl	r15, [r15], +r15

positive: ldrshvs instruction

	ldrshvs	r0, [r0, -255]
	ldrshvs	r15, [r15, +255]
	ldrshvs	r0, [r0, -r0]
	ldrshvs	r15, [r15, +r15]
	ldrshvs	r0, [r0, -255]!
	ldrshvs	r15, [r15, +255]!
	ldrshvs	r0, [r0, -r0]!
	ldrshvs	r15, [r15, +r15]!
	ldrshvs	r0, [r0], -255
	ldrshvs	r15, [r15], +255
	ldrshvs	r0, [r0], -r0
	ldrshvs	r15, [r15], +r15

positive: ldrshvc instruction

	ldrshvc	r0, [r0, -255]
	ldrshvc	r15, [r15, +255]
	ldrshvc	r0, [r0, -r0]
	ldrshvc	r15, [r15, +r15]
	ldrshvc	r0, [r0, -255]!
	ldrshvc	r15, [r15, +255]!
	ldrshvc	r0, [r0, -r0]!
	ldrshvc	r15, [r15, +r15]!
	ldrshvc	r0, [r0], -255
	ldrshvc	r15, [r15], +255
	ldrshvc	r0, [r0], -r0
	ldrshvc	r15, [r15], +r15

positive: ldrshhi instruction

	ldrshhi	r0, [r0, -255]
	ldrshhi	r15, [r15, +255]
	ldrshhi	r0, [r0, -r0]
	ldrshhi	r15, [r15, +r15]
	ldrshhi	r0, [r0, -255]!
	ldrshhi	r15, [r15, +255]!
	ldrshhi	r0, [r0, -r0]!
	ldrshhi	r15, [r15, +r15]!
	ldrshhi	r0, [r0], -255
	ldrshhi	r15, [r15], +255
	ldrshhi	r0, [r0], -r0
	ldrshhi	r15, [r15], +r15

positive: ldrshls instruction

	ldrshls	r0, [r0, -255]
	ldrshls	r15, [r15, +255]
	ldrshls	r0, [r0, -r0]
	ldrshls	r15, [r15, +r15]
	ldrshls	r0, [r0, -255]!
	ldrshls	r15, [r15, +255]!
	ldrshls	r0, [r0, -r0]!
	ldrshls	r15, [r15, +r15]!
	ldrshls	r0, [r0], -255
	ldrshls	r15, [r15], +255
	ldrshls	r0, [r0], -r0
	ldrshls	r15, [r15], +r15

positive: ldrshge instruction

	ldrshge	r0, [r0, -255]
	ldrshge	r15, [r15, +255]
	ldrshge	r0, [r0, -r0]
	ldrshge	r15, [r15, +r15]
	ldrshge	r0, [r0, -255]!
	ldrshge	r15, [r15, +255]!
	ldrshge	r0, [r0, -r0]!
	ldrshge	r15, [r15, +r15]!
	ldrshge	r0, [r0], -255
	ldrshge	r15, [r15], +255
	ldrshge	r0, [r0], -r0
	ldrshge	r15, [r15], +r15

positive: ldrshlt instruction

	ldrshlt	r0, [r0, -255]
	ldrshlt	r15, [r15, +255]
	ldrshlt	r0, [r0, -r0]
	ldrshlt	r15, [r15, +r15]
	ldrshlt	r0, [r0, -255]!
	ldrshlt	r15, [r15, +255]!
	ldrshlt	r0, [r0, -r0]!
	ldrshlt	r15, [r15, +r15]!
	ldrshlt	r0, [r0], -255
	ldrshlt	r15, [r15], +255
	ldrshlt	r0, [r0], -r0
	ldrshlt	r15, [r15], +r15

positive: ldrshgt instruction

	ldrshgt	r0, [r0, -255]
	ldrshgt	r15, [r15, +255]
	ldrshgt	r0, [r0, -r0]
	ldrshgt	r15, [r15, +r15]
	ldrshgt	r0, [r0, -255]!
	ldrshgt	r15, [r15, +255]!
	ldrshgt	r0, [r0, -r0]!
	ldrshgt	r15, [r15, +r15]!
	ldrshgt	r0, [r0], -255
	ldrshgt	r15, [r15], +255
	ldrshgt	r0, [r0], -r0
	ldrshgt	r15, [r15], +r15

positive: ldrshle instruction

	ldrshle	r0, [r0, -255]
	ldrshle	r15, [r15, +255]
	ldrshle	r0, [r0, -r0]
	ldrshle	r15, [r15, +r15]
	ldrshle	r0, [r0, -255]!
	ldrshle	r15, [r15, +255]!
	ldrshle	r0, [r0, -r0]!
	ldrshle	r15, [r15, +r15]!
	ldrshle	r0, [r0], -255
	ldrshle	r15, [r15], +255
	ldrshle	r0, [r0], -r0
	ldrshle	r15, [r15], +r15

positive: ldrshal instruction

	ldrshal	r0, [r0, -255]
	ldrshal	r15, [r15, +255]
	ldrshal	r0, [r0, -r0]
	ldrshal	r15, [r15, +r15]
	ldrshal	r0, [r0, -255]!
	ldrshal	r15, [r15, +255]!
	ldrshal	r0, [r0, -r0]!
	ldrshal	r15, [r15, +r15]!
	ldrshal	r0, [r0], -255
	ldrshal	r15, [r15], +255
	ldrshal	r0, [r0], -r0
	ldrshal	r15, [r15], +r15

positive: ldrt instruction

	ldrt	r0, [r0], -4095
	ldrt	r15, [r15], +4095
	ldrt	r0, [r0], -r0
	ldrt	r15, [r15], +r15
	ldrt	r0, [r1], r2, lsl 0
	ldrt	r15, [r15], r15, lsl 31
	ldrt	r0, [r1], r2, lsr 1
	ldrt	r15, [r15], r15, lsr 32
	ldrt	r0, [r1], r2, asr 1
	ldrt	r15, [r15], r15, asr 32
	ldrt	r0, [r1], r2, ror 1
	ldrt	r15, [r15], r15, ror 31
	ldrt	r0, [r1], r2, rrx
	ldrt	r15, [r15], r15, rrx

positive: ldrteq instruction

	ldrteq	r0, [r0], -4095
	ldrteq	r15, [r15], +4095
	ldrteq	r0, [r0], -r0
	ldrteq	r15, [r15], +r15
	ldrteq	r0, [r1], r2, lsl 0
	ldrteq	r15, [r15], r15, lsl 31
	ldrteq	r0, [r1], r2, lsr 1
	ldrteq	r15, [r15], r15, lsr 32
	ldrteq	r0, [r1], r2, asr 1
	ldrteq	r15, [r15], r15, asr 32
	ldrteq	r0, [r1], r2, ror 1
	ldrteq	r15, [r15], r15, ror 31
	ldrteq	r0, [r1], r2, rrx
	ldrteq	r15, [r15], r15, rrx

positive: ldrtne instruction

	ldrtne	r0, [r0], -4095
	ldrtne	r15, [r15], +4095
	ldrtne	r0, [r0], -r0
	ldrtne	r15, [r15], +r15
	ldrtne	r0, [r1], r2, lsl 0
	ldrtne	r15, [r15], r15, lsl 31
	ldrtne	r0, [r1], r2, lsr 1
	ldrtne	r15, [r15], r15, lsr 32
	ldrtne	r0, [r1], r2, asr 1
	ldrtne	r15, [r15], r15, asr 32
	ldrtne	r0, [r1], r2, ror 1
	ldrtne	r15, [r15], r15, ror 31
	ldrtne	r0, [r1], r2, rrx
	ldrtne	r15, [r15], r15, rrx

positive: ldrtcs instruction

	ldrtcs	r0, [r0], -4095
	ldrtcs	r15, [r15], +4095
	ldrtcs	r0, [r0], -r0
	ldrtcs	r15, [r15], +r15
	ldrtcs	r0, [r1], r2, lsl 0
	ldrtcs	r15, [r15], r15, lsl 31
	ldrtcs	r0, [r1], r2, lsr 1
	ldrtcs	r15, [r15], r15, lsr 32
	ldrtcs	r0, [r1], r2, asr 1
	ldrtcs	r15, [r15], r15, asr 32
	ldrtcs	r0, [r1], r2, ror 1
	ldrtcs	r15, [r15], r15, ror 31
	ldrtcs	r0, [r1], r2, rrx
	ldrtcs	r15, [r15], r15, rrx

positive: ldrths instruction

	ldrths	r0, [r0], -4095
	ldrths	r15, [r15], +4095
	ldrths	r0, [r0], -r0
	ldrths	r15, [r15], +r15
	ldrths	r0, [r1], r2, lsl 0
	ldrths	r15, [r15], r15, lsl 31
	ldrths	r0, [r1], r2, lsr 1
	ldrths	r15, [r15], r15, lsr 32
	ldrths	r0, [r1], r2, asr 1
	ldrths	r15, [r15], r15, asr 32
	ldrths	r0, [r1], r2, ror 1
	ldrths	r15, [r15], r15, ror 31
	ldrths	r0, [r1], r2, rrx
	ldrths	r15, [r15], r15, rrx

positive: ldrtcc instruction

	ldrtcc	r0, [r0], -4095
	ldrtcc	r15, [r15], +4095
	ldrtcc	r0, [r0], -r0
	ldrtcc	r15, [r15], +r15
	ldrtcc	r0, [r1], r2, lsl 0
	ldrtcc	r15, [r15], r15, lsl 31
	ldrtcc	r0, [r1], r2, lsr 1
	ldrtcc	r15, [r15], r15, lsr 32
	ldrtcc	r0, [r1], r2, asr 1
	ldrtcc	r15, [r15], r15, asr 32
	ldrtcc	r0, [r1], r2, ror 1
	ldrtcc	r15, [r15], r15, ror 31
	ldrtcc	r0, [r1], r2, rrx
	ldrtcc	r15, [r15], r15, rrx

positive: ldrtlo instruction

	ldrtlo	r0, [r0], -4095
	ldrtlo	r15, [r15], +4095
	ldrtlo	r0, [r0], -r0
	ldrtlo	r15, [r15], +r15
	ldrtlo	r0, [r1], r2, lsl 0
	ldrtlo	r15, [r15], r15, lsl 31
	ldrtlo	r0, [r1], r2, lsr 1
	ldrtlo	r15, [r15], r15, lsr 32
	ldrtlo	r0, [r1], r2, asr 1
	ldrtlo	r15, [r15], r15, asr 32
	ldrtlo	r0, [r1], r2, ror 1
	ldrtlo	r15, [r15], r15, ror 31
	ldrtlo	r0, [r1], r2, rrx
	ldrtlo	r15, [r15], r15, rrx

positive: ldrtmi instruction

	ldrtmi	r0, [r0], -4095
	ldrtmi	r15, [r15], +4095
	ldrtmi	r0, [r0], -r0
	ldrtmi	r15, [r15], +r15
	ldrtmi	r0, [r1], r2, lsl 0
	ldrtmi	r15, [r15], r15, lsl 31
	ldrtmi	r0, [r1], r2, lsr 1
	ldrtmi	r15, [r15], r15, lsr 32
	ldrtmi	r0, [r1], r2, asr 1
	ldrtmi	r15, [r15], r15, asr 32
	ldrtmi	r0, [r1], r2, ror 1
	ldrtmi	r15, [r15], r15, ror 31
	ldrtmi	r0, [r1], r2, rrx
	ldrtmi	r15, [r15], r15, rrx

positive: ldrtpl instruction

	ldrtpl	r0, [r0], -4095
	ldrtpl	r15, [r15], +4095
	ldrtpl	r0, [r0], -r0
	ldrtpl	r15, [r15], +r15
	ldrtpl	r0, [r1], r2, lsl 0
	ldrtpl	r15, [r15], r15, lsl 31
	ldrtpl	r0, [r1], r2, lsr 1
	ldrtpl	r15, [r15], r15, lsr 32
	ldrtpl	r0, [r1], r2, asr 1
	ldrtpl	r15, [r15], r15, asr 32
	ldrtpl	r0, [r1], r2, ror 1
	ldrtpl	r15, [r15], r15, ror 31
	ldrtpl	r0, [r1], r2, rrx
	ldrtpl	r15, [r15], r15, rrx

positive: ldrtvs instruction

	ldrtvs	r0, [r0], -4095
	ldrtvs	r15, [r15], +4095
	ldrtvs	r0, [r0], -r0
	ldrtvs	r15, [r15], +r15
	ldrtvs	r0, [r1], r2, lsl 0
	ldrtvs	r15, [r15], r15, lsl 31
	ldrtvs	r0, [r1], r2, lsr 1
	ldrtvs	r15, [r15], r15, lsr 32
	ldrtvs	r0, [r1], r2, asr 1
	ldrtvs	r15, [r15], r15, asr 32
	ldrtvs	r0, [r1], r2, ror 1
	ldrtvs	r15, [r15], r15, ror 31
	ldrtvs	r0, [r1], r2, rrx
	ldrtvs	r15, [r15], r15, rrx

positive: ldrtvc instruction

	ldrtvc	r0, [r0], -4095
	ldrtvc	r15, [r15], +4095
	ldrtvc	r0, [r0], -r0
	ldrtvc	r15, [r15], +r15
	ldrtvc	r0, [r1], r2, lsl 0
	ldrtvc	r15, [r15], r15, lsl 31
	ldrtvc	r0, [r1], r2, lsr 1
	ldrtvc	r15, [r15], r15, lsr 32
	ldrtvc	r0, [r1], r2, asr 1
	ldrtvc	r15, [r15], r15, asr 32
	ldrtvc	r0, [r1], r2, ror 1
	ldrtvc	r15, [r15], r15, ror 31
	ldrtvc	r0, [r1], r2, rrx
	ldrtvc	r15, [r15], r15, rrx

positive: ldrthi instruction

	ldrthi	r0, [r0], -4095
	ldrthi	r15, [r15], +4095
	ldrthi	r0, [r0], -r0
	ldrthi	r15, [r15], +r15
	ldrthi	r0, [r1], r2, lsl 0
	ldrthi	r15, [r15], r15, lsl 31
	ldrthi	r0, [r1], r2, lsr 1
	ldrthi	r15, [r15], r15, lsr 32
	ldrthi	r0, [r1], r2, asr 1
	ldrthi	r15, [r15], r15, asr 32
	ldrthi	r0, [r1], r2, ror 1
	ldrthi	r15, [r15], r15, ror 31
	ldrthi	r0, [r1], r2, rrx
	ldrthi	r15, [r15], r15, rrx

positive: ldrtls instruction

	ldrtls	r0, [r0], -4095
	ldrtls	r15, [r15], +4095
	ldrtls	r0, [r0], -r0
	ldrtls	r15, [r15], +r15
	ldrtls	r0, [r1], r2, lsl 0
	ldrtls	r15, [r15], r15, lsl 31
	ldrtls	r0, [r1], r2, lsr 1
	ldrtls	r15, [r15], r15, lsr 32
	ldrtls	r0, [r1], r2, asr 1
	ldrtls	r15, [r15], r15, asr 32
	ldrtls	r0, [r1], r2, ror 1
	ldrtls	r15, [r15], r15, ror 31
	ldrtls	r0, [r1], r2, rrx
	ldrtls	r15, [r15], r15, rrx

positive: ldrtge instruction

	ldrtge	r0, [r0], -4095
	ldrtge	r15, [r15], +4095
	ldrtge	r0, [r0], -r0
	ldrtge	r15, [r15], +r15
	ldrtge	r0, [r1], r2, lsl 0
	ldrtge	r15, [r15], r15, lsl 31
	ldrtge	r0, [r1], r2, lsr 1
	ldrtge	r15, [r15], r15, lsr 32
	ldrtge	r0, [r1], r2, asr 1
	ldrtge	r15, [r15], r15, asr 32
	ldrtge	r0, [r1], r2, ror 1
	ldrtge	r15, [r15], r15, ror 31
	ldrtge	r0, [r1], r2, rrx
	ldrtge	r15, [r15], r15, rrx

positive: ldrtlt instruction

	ldrtlt	r0, [r0], -4095
	ldrtlt	r15, [r15], +4095
	ldrtlt	r0, [r0], -r0
	ldrtlt	r15, [r15], +r15
	ldrtlt	r0, [r1], r2, lsl 0
	ldrtlt	r15, [r15], r15, lsl 31
	ldrtlt	r0, [r1], r2, lsr 1
	ldrtlt	r15, [r15], r15, lsr 32
	ldrtlt	r0, [r1], r2, asr 1
	ldrtlt	r15, [r15], r15, asr 32
	ldrtlt	r0, [r1], r2, ror 1
	ldrtlt	r15, [r15], r15, ror 31
	ldrtlt	r0, [r1], r2, rrx
	ldrtlt	r15, [r15], r15, rrx

positive: ldrtgt instruction

	ldrtgt	r0, [r0], -4095
	ldrtgt	r15, [r15], +4095
	ldrtgt	r0, [r0], -r0
	ldrtgt	r15, [r15], +r15
	ldrtgt	r0, [r1], r2, lsl 0
	ldrtgt	r15, [r15], r15, lsl 31
	ldrtgt	r0, [r1], r2, lsr 1
	ldrtgt	r15, [r15], r15, lsr 32
	ldrtgt	r0, [r1], r2, asr 1
	ldrtgt	r15, [r15], r15, asr 32
	ldrtgt	r0, [r1], r2, ror 1
	ldrtgt	r15, [r15], r15, ror 31
	ldrtgt	r0, [r1], r2, rrx
	ldrtgt	r15, [r15], r15, rrx

positive: ldrtle instruction

	ldrtle	r0, [r0], -4095
	ldrtle	r15, [r15], +4095
	ldrtle	r0, [r0], -r0
	ldrtle	r15, [r15], +r15
	ldrtle	r0, [r1], r2, lsl 0
	ldrtle	r15, [r15], r15, lsl 31
	ldrtle	r0, [r1], r2, lsr 1
	ldrtle	r15, [r15], r15, lsr 32
	ldrtle	r0, [r1], r2, asr 1
	ldrtle	r15, [r15], r15, asr 32
	ldrtle	r0, [r1], r2, ror 1
	ldrtle	r15, [r15], r15, ror 31
	ldrtle	r0, [r1], r2, rrx
	ldrtle	r15, [r15], r15, rrx

positive: ldrtal instruction

	ldrtal	r0, [r0], -4095
	ldrtal	r15, [r15], +4095
	ldrtal	r0, [r0], -r0
	ldrtal	r15, [r15], +r15
	ldrtal	r0, [r1], r2, lsl 0
	ldrtal	r15, [r15], r15, lsl 31
	ldrtal	r0, [r1], r2, lsr 1
	ldrtal	r15, [r15], r15, lsr 32
	ldrtal	r0, [r1], r2, asr 1
	ldrtal	r15, [r15], r15, asr 32
	ldrtal	r0, [r1], r2, ror 1
	ldrtal	r15, [r15], r15, ror 31
	ldrtal	r0, [r1], r2, rrx
	ldrtal	r15, [r15], r15, rrx

positive: ldrex instruction

	ldrex	r0, [r0]
	ldrex	r15, [r15]

positive: ldrexeq instruction

	ldrexeq	r0, [r0]
	ldrexeq	r15, [r15]

positive: ldrexne instruction

	ldrexne	r0, [r0]
	ldrexne	r15, [r15]

positive: ldrexcs instruction

	ldrexcs	r0, [r0]
	ldrexcs	r15, [r15]

positive: ldrexhs instruction

	ldrexhs	r0, [r0]
	ldrexhs	r15, [r15]

positive: ldrexcc instruction

	ldrexcc	r0, [r0]
	ldrexcc	r15, [r15]

positive: ldrexlo instruction

	ldrexlo	r0, [r0]
	ldrexlo	r15, [r15]

positive: ldrexmi instruction

	ldrexmi	r0, [r0]
	ldrexmi	r15, [r15]

positive: ldrexpl instruction

	ldrexpl	r0, [r0]
	ldrexpl	r15, [r15]

positive: ldrexvs instruction

	ldrexvs	r0, [r0]
	ldrexvs	r15, [r15]

positive: ldrexvc instruction

	ldrexvc	r0, [r0]
	ldrexvc	r15, [r15]

positive: ldrexhi instruction

	ldrexhi	r0, [r0]
	ldrexhi	r15, [r15]

positive: ldrexls instruction

	ldrexls	r0, [r0]
	ldrexls	r15, [r15]

positive: ldrexge instruction

	ldrexge	r0, [r0]
	ldrexge	r15, [r15]

positive: ldrexlt instruction

	ldrexlt	r0, [r0]
	ldrexlt	r15, [r15]

positive: ldrexgt instruction

	ldrexgt	r0, [r0]
	ldrexgt	r15, [r15]

positive: ldrexle instruction

	ldrexle	r0, [r0]
	ldrexle	r15, [r15]

positive: ldrexal instruction

	ldrexal	r0, [r0]
	ldrexal	r15, [r15]

positive: ldrexb instruction

	ldrexb	r0, [r0]
	ldrexb	r15, [r15]

positive: ldrexbeq instruction

	ldrexbeq	r0, [r0]
	ldrexbeq	r15, [r15]

positive: ldrexbne instruction

	ldrexbne	r0, [r0]
	ldrexbne	r15, [r15]

positive: ldrexbcs instruction

	ldrexbcs	r0, [r0]
	ldrexbcs	r15, [r15]

positive: ldrexbhs instruction

	ldrexbhs	r0, [r0]
	ldrexbhs	r15, [r15]

positive: ldrexbcc instruction

	ldrexbcc	r0, [r0]
	ldrexbcc	r15, [r15]

positive: ldrexblo instruction

	ldrexblo	r0, [r0]
	ldrexblo	r15, [r15]

positive: ldrexbmi instruction

	ldrexbmi	r0, [r0]
	ldrexbmi	r15, [r15]

positive: ldrexbpl instruction

	ldrexbpl	r0, [r0]
	ldrexbpl	r15, [r15]

positive: ldrexbvs instruction

	ldrexbvs	r0, [r0]
	ldrexbvs	r15, [r15]

positive: ldrexbvc instruction

	ldrexbvc	r0, [r0]
	ldrexbvc	r15, [r15]

positive: ldrexbhi instruction

	ldrexbhi	r0, [r0]
	ldrexbhi	r15, [r15]

positive: ldrexbls instruction

	ldrexbls	r0, [r0]
	ldrexbls	r15, [r15]

positive: ldrexbge instruction

	ldrexbge	r0, [r0]
	ldrexbge	r15, [r15]

positive: ldrexblt instruction

	ldrexblt	r0, [r0]
	ldrexblt	r15, [r15]

positive: ldrexbgt instruction

	ldrexbgt	r0, [r0]
	ldrexbgt	r15, [r15]

positive: ldrexble instruction

	ldrexble	r0, [r0]
	ldrexble	r15, [r15]

positive: ldrexbal instruction

	ldrexbal	r0, [r0]
	ldrexbal	r15, [r15]

positive: ldrexd instruction

	ldrexd	r0, [r0]
	ldrexd	r15, [r15]

positive: ldrexdeq instruction

	ldrexdeq	r0, [r0]
	ldrexdeq	r15, [r15]

positive: ldrexdne instruction

	ldrexdne	r0, [r0]
	ldrexdne	r15, [r15]

positive: ldrexdcs instruction

	ldrexdcs	r0, [r0]
	ldrexdcs	r15, [r15]

positive: ldrexdhs instruction

	ldrexdhs	r0, [r0]
	ldrexdhs	r15, [r15]

positive: ldrexdcc instruction

	ldrexdcc	r0, [r0]
	ldrexdcc	r15, [r15]

positive: ldrexdlo instruction

	ldrexdlo	r0, [r0]
	ldrexdlo	r15, [r15]

positive: ldrexdmi instruction

	ldrexdmi	r0, [r0]
	ldrexdmi	r15, [r15]

positive: ldrexdpl instruction

	ldrexdpl	r0, [r0]
	ldrexdpl	r15, [r15]

positive: ldrexdvs instruction

	ldrexdvs	r0, [r0]
	ldrexdvs	r15, [r15]

positive: ldrexdvc instruction

	ldrexdvc	r0, [r0]
	ldrexdvc	r15, [r15]

positive: ldrexdhi instruction

	ldrexdhi	r0, [r0]
	ldrexdhi	r15, [r15]

positive: ldrexdls instruction

	ldrexdls	r0, [r0]
	ldrexdls	r15, [r15]

positive: ldrexdge instruction

	ldrexdge	r0, [r0]
	ldrexdge	r15, [r15]

positive: ldrexdlt instruction

	ldrexdlt	r0, [r0]
	ldrexdlt	r15, [r15]

positive: ldrexdgt instruction

	ldrexdgt	r0, [r0]
	ldrexdgt	r15, [r15]

positive: ldrexdle instruction

	ldrexdle	r0, [r0]
	ldrexdle	r15, [r15]

positive: ldrexdal instruction

	ldrexdal	r0, [r0]
	ldrexdal	r15, [r15]

positive: ldrexh instruction

	ldrexh	r0, [r0]
	ldrexh	r15, [r15]

positive: ldrexheq instruction

	ldrexheq	r0, [r0]
	ldrexheq	r15, [r15]

positive: ldrexhne instruction

	ldrexhne	r0, [r0]
	ldrexhne	r15, [r15]

positive: ldrexhcs instruction

	ldrexhcs	r0, [r0]
	ldrexhcs	r15, [r15]

positive: ldrexhhs instruction

	ldrexhhs	r0, [r0]
	ldrexhhs	r15, [r15]

positive: ldrexhcc instruction

	ldrexhcc	r0, [r0]
	ldrexhcc	r15, [r15]

positive: ldrexhlo instruction

	ldrexhlo	r0, [r0]
	ldrexhlo	r15, [r15]

positive: ldrexhmi instruction

	ldrexhmi	r0, [r0]
	ldrexhmi	r15, [r15]

positive: ldrexhpl instruction

	ldrexhpl	r0, [r0]
	ldrexhpl	r15, [r15]

positive: ldrexhvs instruction

	ldrexhvs	r0, [r0]
	ldrexhvs	r15, [r15]

positive: ldrexhvc instruction

	ldrexhvc	r0, [r0]
	ldrexhvc	r15, [r15]

positive: ldrexhhi instruction

	ldrexhhi	r0, [r0]
	ldrexhhi	r15, [r15]

positive: ldrexhls instruction

	ldrexhls	r0, [r0]
	ldrexhls	r15, [r15]

positive: ldrexhge instruction

	ldrexhge	r0, [r0]
	ldrexhge	r15, [r15]

positive: ldrexhlt instruction

	ldrexhlt	r0, [r0]
	ldrexhlt	r15, [r15]

positive: ldrexhgt instruction

	ldrexhgt	r0, [r0]
	ldrexhgt	r15, [r15]

positive: ldrexhle instruction

	ldrexhle	r0, [r0]
	ldrexhle	r15, [r15]

positive: ldrexhal instruction

	ldrexhal	r0, [r0]
	ldrexhal	r15, [r15]

positive: mcr instruction

	mcr	p0, 0, r0, c0, c0
	mcr	p15, 7, r15, c15, c15
	mcr	p0, 0, r0, c0, c0, 0
	mcr	p15, 7, r15, c15, c15, 7

positive: mcreq instruction

	mcreq	p0, 0, r0, c0, c0
	mcreq	p15, 7, r15, c15, c15
	mcreq	p0, 0, r0, c0, c0, 0
	mcreq	p15, 7, r15, c15, c15, 7

positive: mcrne instruction

	mcrne	p0, 0, r0, c0, c0
	mcrne	p15, 7, r15, c15, c15
	mcrne	p0, 0, r0, c0, c0, 0
	mcrne	p15, 7, r15, c15, c15, 7

positive: mcrcs instruction

	mcrcs	p0, 0, r0, c0, c0
	mcrcs	p15, 7, r15, c15, c15
	mcrcs	p0, 0, r0, c0, c0, 0
	mcrcs	p15, 7, r15, c15, c15, 7

positive: mcrhs instruction

	mcrhs	p0, 0, r0, c0, c0
	mcrhs	p15, 7, r15, c15, c15
	mcrhs	p0, 0, r0, c0, c0, 0
	mcrhs	p15, 7, r15, c15, c15, 7

positive: mcrcc instruction

	mcrcc	p0, 0, r0, c0, c0
	mcrcc	p15, 7, r15, c15, c15
	mcrcc	p0, 0, r0, c0, c0, 0
	mcrcc	p15, 7, r15, c15, c15, 7

positive: mcrlo instruction

	mcrlo	p0, 0, r0, c0, c0
	mcrlo	p15, 7, r15, c15, c15
	mcrlo	p0, 0, r0, c0, c0, 0
	mcrlo	p15, 7, r15, c15, c15, 7

positive: mcrmi instruction

	mcrmi	p0, 0, r0, c0, c0
	mcrmi	p15, 7, r15, c15, c15
	mcrmi	p0, 0, r0, c0, c0, 0
	mcrmi	p15, 7, r15, c15, c15, 7

positive: mcrpl instruction

	mcrpl	p0, 0, r0, c0, c0
	mcrpl	p15, 7, r15, c15, c15
	mcrpl	p0, 0, r0, c0, c0, 0
	mcrpl	p15, 7, r15, c15, c15, 7

positive: mcrvs instruction

	mcrvs	p0, 0, r0, c0, c0
	mcrvs	p15, 7, r15, c15, c15
	mcrvs	p0, 0, r0, c0, c0, 0
	mcrvs	p15, 7, r15, c15, c15, 7

positive: mcrvc instruction

	mcrvc	p0, 0, r0, c0, c0
	mcrvc	p15, 7, r15, c15, c15
	mcrvc	p0, 0, r0, c0, c0, 0
	mcrvc	p15, 7, r15, c15, c15, 7

positive: mcrhi instruction

	mcrhi	p0, 0, r0, c0, c0
	mcrhi	p15, 7, r15, c15, c15
	mcrhi	p0, 0, r0, c0, c0, 0
	mcrhi	p15, 7, r15, c15, c15, 7

positive: mcrls instruction

	mcrls	p0, 0, r0, c0, c0
	mcrls	p15, 7, r15, c15, c15
	mcrls	p0, 0, r0, c0, c0, 0
	mcrls	p15, 7, r15, c15, c15, 7

positive: mcrge instruction

	mcrge	p0, 0, r0, c0, c0
	mcrge	p15, 7, r15, c15, c15
	mcrge	p0, 0, r0, c0, c0, 0
	mcrge	p15, 7, r15, c15, c15, 7

positive: mcrlt instruction

	mcrlt	p0, 0, r0, c0, c0
	mcrlt	p15, 7, r15, c15, c15
	mcrlt	p0, 0, r0, c0, c0, 0
	mcrlt	p15, 7, r15, c15, c15, 7

positive: mcrgt instruction

	mcrgt	p0, 0, r0, c0, c0
	mcrgt	p15, 7, r15, c15, c15
	mcrgt	p0, 0, r0, c0, c0, 0
	mcrgt	p15, 7, r15, c15, c15, 7

positive: mcrle instruction

	mcrle	p0, 0, r0, c0, c0
	mcrle	p15, 7, r15, c15, c15
	mcrle	p0, 0, r0, c0, c0, 0
	mcrle	p15, 7, r15, c15, c15, 7

positive: mcral instruction

	mcral	p0, 0, r0, c0, c0
	mcral	p15, 7, r15, c15, c15
	mcral	p0, 0, r0, c0, c0, 0
	mcral	p15, 7, r15, c15, c15, 7

positive: mcr2 instruction

	mcr2	p0, 0, r0, c0, c0
	mcr2	p15, 7, r15, c15, c15
	mcr2	p0, 0, r0, c0, c0, 0
	mcr2	p15, 7, r15, c15, c15, 7

positive: mcrr instruction

	mcrr	p0, 0, r0, r0, c0
	mcrr	p15, 7, r15, r15, c15

positive: mcrreq instruction

	mcrreq	p0, 0, r0, r0, c0
	mcrreq	p15, 7, r15, r15, c15

positive: mcrrne instruction

	mcrrne	p0, 0, r0, r0, c0
	mcrrne	p15, 7, r15, r15, c15

positive: mcrrcs instruction

	mcrrcs	p0, 0, r0, r0, c0
	mcrrcs	p15, 7, r15, r15, c15

positive: mcrrhs instruction

	mcrrhs	p0, 0, r0, r0, c0
	mcrrhs	p15, 7, r15, r15, c15

positive: mcrrcc instruction

	mcrrcc	p0, 0, r0, r0, c0
	mcrrcc	p15, 7, r15, r15, c15

positive: mcrrlo instruction

	mcrrlo	p0, 0, r0, r0, c0
	mcrrlo	p15, 7, r15, r15, c15

positive: mcrrmi instruction

	mcrrmi	p0, 0, r0, r0, c0
	mcrrmi	p15, 7, r15, r15, c15

positive: mcrrpl instruction

	mcrrpl	p0, 0, r0, r0, c0
	mcrrpl	p15, 7, r15, r15, c15

positive: mcrrvs instruction

	mcrrvs	p0, 0, r0, r0, c0
	mcrrvs	p15, 7, r15, r15, c15

positive: mcrrvc instruction

	mcrrvc	p0, 0, r0, r0, c0
	mcrrvc	p15, 7, r15, r15, c15

positive: mcrrhi instruction

	mcrrhi	p0, 0, r0, r0, c0
	mcrrhi	p15, 7, r15, r15, c15

positive: mcrrls instruction

	mcrrls	p0, 0, r0, r0, c0
	mcrrls	p15, 7, r15, r15, c15

positive: mcrrge instruction

	mcrrge	p0, 0, r0, r0, c0
	mcrrge	p15, 7, r15, r15, c15

positive: mcrrlt instruction

	mcrrlt	p0, 0, r0, r0, c0
	mcrrlt	p15, 7, r15, r15, c15

positive: mcrrgt instruction

	mcrrgt	p0, 0, r0, r0, c0
	mcrrgt	p15, 7, r15, r15, c15

positive: mcrrle instruction

	mcrrle	p0, 0, r0, r0, c0
	mcrrle	p15, 7, r15, r15, c15

positive: mcrral instruction

	mcrral	p0, 0, r0, r0, c0
	mcrral	p15, 7, r15, r15, c15

positive: mcrr2 instruction

	mcrr2	p0, 0, r0, r0, c0
	mcrr2	p15, 7, r15, r15, c15

positive: mla instruction

	mla	r0, r0, r0, r0
	mla	r15, r15, r15, r15

positive: mlaeq instruction

	mlaeq	r0, r0, r0, r0
	mlaeq	r15, r15, r15, r15

positive: mlane instruction

	mlane	r0, r0, r0, r0
	mlane	r15, r15, r15, r15

positive: mlacs instruction

	mlacs	r0, r0, r0, r0
	mlacs	r15, r15, r15, r15

positive: mlahs instruction

	mlahs	r0, r0, r0, r0
	mlahs	r15, r15, r15, r15

positive: mlacc instruction

	mlacc	r0, r0, r0, r0
	mlacc	r15, r15, r15, r15

positive: mlalo instruction

	mlalo	r0, r0, r0, r0
	mlalo	r15, r15, r15, r15

positive: mlami instruction

	mlami	r0, r0, r0, r0
	mlami	r15, r15, r15, r15

positive: mlapl instruction

	mlapl	r0, r0, r0, r0
	mlapl	r15, r15, r15, r15

positive: mlavs instruction

	mlavs	r0, r0, r0, r0
	mlavs	r15, r15, r15, r15

positive: mlavc instruction

	mlavc	r0, r0, r0, r0
	mlavc	r15, r15, r15, r15

positive: mlahi instruction

	mlahi	r0, r0, r0, r0
	mlahi	r15, r15, r15, r15

positive: mlals instruction

	mlals	r0, r0, r0, r0
	mlals	r15, r15, r15, r15

positive: mlage instruction

	mlage	r0, r0, r0, r0
	mlage	r15, r15, r15, r15

positive: mlalt instruction

	mlalt	r0, r0, r0, r0
	mlalt	r15, r15, r15, r15

positive: mlagt instruction

	mlagt	r0, r0, r0, r0
	mlagt	r15, r15, r15, r15

positive: mlale instruction

	mlale	r0, r0, r0, r0
	mlale	r15, r15, r15, r15

positive: mlaal instruction

	mlaal	r0, r0, r0, r0
	mlaal	r15, r15, r15, r15

positive: mlas instruction

	mlas	r0, r0, r0, r0
	mlas	r15, r15, r15, r15

positive: mlaseq instruction

	mlaseq	r0, r0, r0, r0
	mlaseq	r15, r15, r15, r15

positive: mlasne instruction

	mlasne	r0, r0, r0, r0
	mlasne	r15, r15, r15, r15

positive: mlascs instruction

	mlascs	r0, r0, r0, r0
	mlascs	r15, r15, r15, r15

positive: mlashs instruction

	mlashs	r0, r0, r0, r0
	mlashs	r15, r15, r15, r15

positive: mlascc instruction

	mlascc	r0, r0, r0, r0
	mlascc	r15, r15, r15, r15

positive: mlaslo instruction

	mlaslo	r0, r0, r0, r0
	mlaslo	r15, r15, r15, r15

positive: mlasmi instruction

	mlasmi	r0, r0, r0, r0
	mlasmi	r15, r15, r15, r15

positive: mlaspl instruction

	mlaspl	r0, r0, r0, r0
	mlaspl	r15, r15, r15, r15

positive: mlasvs instruction

	mlasvs	r0, r0, r0, r0
	mlasvs	r15, r15, r15, r15

positive: mlasvc instruction

	mlasvc	r0, r0, r0, r0
	mlasvc	r15, r15, r15, r15

positive: mlashi instruction

	mlashi	r0, r0, r0, r0
	mlashi	r15, r15, r15, r15

positive: mlasls instruction

	mlasls	r0, r0, r0, r0
	mlasls	r15, r15, r15, r15

positive: mlasge instruction

	mlasge	r0, r0, r0, r0
	mlasge	r15, r15, r15, r15

positive: mlaslt instruction

	mlaslt	r0, r0, r0, r0
	mlaslt	r15, r15, r15, r15

positive: mlasgt instruction

	mlasgt	r0, r0, r0, r0
	mlasgt	r15, r15, r15, r15

positive: mlasle instruction

	mlasle	r0, r0, r0, r0
	mlasle	r15, r15, r15, r15

positive: mlasal instruction

	mlasal	r0, r0, r0, r0
	mlasal	r15, r15, r15, r15

positive: mov instruction

	mov	r0, 0
	mov	r15, 0xff000000
	mov	r0, r0
	mov	r15, r15
	mov	r0, r0, lsl 0
	mov	r15, r15, lsl 31
	mov	r0, r0, lsl r0
	mov	r15, r15, lsl r15
	mov	r0, r0, lsr 1
	mov	r15, r15, lsr 32
	mov	r0, r0, lsr r0
	mov	r15, r15, asr r15
	mov	r0, r0, asr 1
	mov	r15, r15, asr 32
	mov	r0, r0, asr r0
	mov	r15, r15, asr r15
	mov	r0, r0, ror 1
	mov	r15, r15, ror 31
	mov	r0, r0, ror r0
	mov	r15, r15, ror r15
	mov	r0, r0, rrx

positive: moveq instruction

	moveq	r0, 0
	moveq	r15, 0xff000000
	moveq	r0, r0
	moveq	r15, r15
	moveq	r0, r0, lsl 0
	moveq	r15, r15, lsl 31
	moveq	r0, r0, lsl r0
	moveq	r15, r15, lsl r15
	moveq	r0, r0, lsr 1
	moveq	r15, r15, lsr 32
	moveq	r0, r0, lsr r0
	moveq	r15, r15, asr r15
	moveq	r0, r0, asr 1
	moveq	r15, r15, asr 32
	moveq	r0, r0, asr r0
	moveq	r15, r15, asr r15
	moveq	r0, r0, ror 1
	moveq	r15, r15, ror 31
	moveq	r0, r0, ror r0
	moveq	r15, r15, ror r15
	moveq	r0, r0, rrx

positive: movne instruction

	movne	r0, 0
	movne	r15, 0xff000000
	movne	r0, r0
	movne	r15, r15
	movne	r0, r0, lsl 0
	movne	r15, r15, lsl 31
	movne	r0, r0, lsl r0
	movne	r15, r15, lsl r15
	movne	r0, r0, lsr 1
	movne	r15, r15, lsr 32
	movne	r0, r0, lsr r0
	movne	r15, r15, asr r15
	movne	r0, r0, asr 1
	movne	r15, r15, asr 32
	movne	r0, r0, asr r0
	movne	r15, r15, asr r15
	movne	r0, r0, ror 1
	movne	r15, r15, ror 31
	movne	r0, r0, ror r0
	movne	r15, r15, ror r15
	movne	r0, r0, rrx

positive: movcs instruction

	movcs	r0, 0
	movcs	r15, 0xff000000
	movcs	r0, r0
	movcs	r15, r15
	movcs	r0, r0, lsl 0
	movcs	r15, r15, lsl 31
	movcs	r0, r0, lsl r0
	movcs	r15, r15, lsl r15
	movcs	r0, r0, lsr 1
	movcs	r15, r15, lsr 32
	movcs	r0, r0, lsr r0
	movcs	r15, r15, asr r15
	movcs	r0, r0, asr 1
	movcs	r15, r15, asr 32
	movcs	r0, r0, asr r0
	movcs	r15, r15, asr r15
	movcs	r0, r0, ror 1
	movcs	r15, r15, ror 31
	movcs	r0, r0, ror r0
	movcs	r15, r15, ror r15
	movcs	r0, r0, rrx

positive: movhs instruction

	movhs	r0, 0
	movhs	r15, 0xff000000
	movhs	r0, r0
	movhs	r15, r15
	movhs	r0, r0, lsl 0
	movhs	r15, r15, lsl 31
	movhs	r0, r0, lsl r0
	movhs	r15, r15, lsl r15
	movhs	r0, r0, lsr 1
	movhs	r15, r15, lsr 32
	movhs	r0, r0, lsr r0
	movhs	r15, r15, asr r15
	movhs	r0, r0, asr 1
	movhs	r15, r15, asr 32
	movhs	r0, r0, asr r0
	movhs	r15, r15, asr r15
	movhs	r0, r0, ror 1
	movhs	r15, r15, ror 31
	movhs	r0, r0, ror r0
	movhs	r15, r15, ror r15
	movhs	r0, r0, rrx

positive: movcc instruction

	movcc	r0, 0
	movcc	r15, 0xff000000
	movcc	r0, r0
	movcc	r15, r15
	movcc	r0, r0, lsl 0
	movcc	r15, r15, lsl 31
	movcc	r0, r0, lsl r0
	movcc	r15, r15, lsl r15
	movcc	r0, r0, lsr 1
	movcc	r15, r15, lsr 32
	movcc	r0, r0, lsr r0
	movcc	r15, r15, asr r15
	movcc	r0, r0, asr 1
	movcc	r15, r15, asr 32
	movcc	r0, r0, asr r0
	movcc	r15, r15, asr r15
	movcc	r0, r0, ror 1
	movcc	r15, r15, ror 31
	movcc	r0, r0, ror r0
	movcc	r15, r15, ror r15
	movcc	r0, r0, rrx

positive: movlo instruction

	movlo	r0, 0
	movlo	r15, 0xff000000
	movlo	r0, r0
	movlo	r15, r15
	movlo	r0, r0, lsl 0
	movlo	r15, r15, lsl 31
	movlo	r0, r0, lsl r0
	movlo	r15, r15, lsl r15
	movlo	r0, r0, lsr 1
	movlo	r15, r15, lsr 32
	movlo	r0, r0, lsr r0
	movlo	r15, r15, asr r15
	movlo	r0, r0, asr 1
	movlo	r15, r15, asr 32
	movlo	r0, r0, asr r0
	movlo	r15, r15, asr r15
	movlo	r0, r0, ror 1
	movlo	r15, r15, ror 31
	movlo	r0, r0, ror r0
	movlo	r15, r15, ror r15
	movlo	r0, r0, rrx

positive: movmi instruction

	movmi	r0, 0
	movmi	r15, 0xff000000
	movmi	r0, r0
	movmi	r15, r15
	movmi	r0, r0, lsl 0
	movmi	r15, r15, lsl 31
	movmi	r0, r0, lsl r0
	movmi	r15, r15, lsl r15
	movmi	r0, r0, lsr 1
	movmi	r15, r15, lsr 32
	movmi	r0, r0, lsr r0
	movmi	r15, r15, asr r15
	movmi	r0, r0, asr 1
	movmi	r15, r15, asr 32
	movmi	r0, r0, asr r0
	movmi	r15, r15, asr r15
	movmi	r0, r0, ror 1
	movmi	r15, r15, ror 31
	movmi	r0, r0, ror r0
	movmi	r15, r15, ror r15
	movmi	r0, r0, rrx

positive: movpl instruction

	movpl	r0, 0
	movpl	r15, 0xff000000
	movpl	r0, r0
	movpl	r15, r15
	movpl	r0, r0, lsl 0
	movpl	r15, r15, lsl 31
	movpl	r0, r0, lsl r0
	movpl	r15, r15, lsl r15
	movpl	r0, r0, lsr 1
	movpl	r15, r15, lsr 32
	movpl	r0, r0, lsr r0
	movpl	r15, r15, asr r15
	movpl	r0, r0, asr 1
	movpl	r15, r15, asr 32
	movpl	r0, r0, asr r0
	movpl	r15, r15, asr r15
	movpl	r0, r0, ror 1
	movpl	r15, r15, ror 31
	movpl	r0, r0, ror r0
	movpl	r15, r15, ror r15
	movpl	r0, r0, rrx

positive: movvs instruction

	movvs	r0, 0
	movvs	r15, 0xff000000
	movvs	r0, r0
	movvs	r15, r15
	movvs	r0, r0, lsl 0
	movvs	r15, r15, lsl 31
	movvs	r0, r0, lsl r0
	movvs	r15, r15, lsl r15
	movvs	r0, r0, lsr 1
	movvs	r15, r15, lsr 32
	movvs	r0, r0, lsr r0
	movvs	r15, r15, asr r15
	movvs	r0, r0, asr 1
	movvs	r15, r15, asr 32
	movvs	r0, r0, asr r0
	movvs	r15, r15, asr r15
	movvs	r0, r0, ror 1
	movvs	r15, r15, ror 31
	movvs	r0, r0, ror r0
	movvs	r15, r15, ror r15
	movvs	r0, r0, rrx

positive: movvc instruction

	movvc	r0, 0
	movvc	r15, 0xff000000
	movvc	r0, r0
	movvc	r15, r15
	movvc	r0, r0, lsl 0
	movvc	r15, r15, lsl 31
	movvc	r0, r0, lsl r0
	movvc	r15, r15, lsl r15
	movvc	r0, r0, lsr 1
	movvc	r15, r15, lsr 32
	movvc	r0, r0, lsr r0
	movvc	r15, r15, asr r15
	movvc	r0, r0, asr 1
	movvc	r15, r15, asr 32
	movvc	r0, r0, asr r0
	movvc	r15, r15, asr r15
	movvc	r0, r0, ror 1
	movvc	r15, r15, ror 31
	movvc	r0, r0, ror r0
	movvc	r15, r15, ror r15
	movvc	r0, r0, rrx

positive: movhi instruction

	movhi	r0, 0
	movhi	r15, 0xff000000
	movhi	r0, r0
	movhi	r15, r15
	movhi	r0, r0, lsl 0
	movhi	r15, r15, lsl 31
	movhi	r0, r0, lsl r0
	movhi	r15, r15, lsl r15
	movhi	r0, r0, lsr 1
	movhi	r15, r15, lsr 32
	movhi	r0, r0, lsr r0
	movhi	r15, r15, asr r15
	movhi	r0, r0, asr 1
	movhi	r15, r15, asr 32
	movhi	r0, r0, asr r0
	movhi	r15, r15, asr r15
	movhi	r0, r0, ror 1
	movhi	r15, r15, ror 31
	movhi	r0, r0, ror r0
	movhi	r15, r15, ror r15
	movhi	r0, r0, rrx

positive: movls instruction

	movls	r0, 0
	movls	r15, 0xff000000
	movls	r0, r0
	movls	r15, r15
	movls	r0, r0, lsl 0
	movls	r15, r15, lsl 31
	movls	r0, r0, lsl r0
	movls	r15, r15, lsl r15
	movls	r0, r0, lsr 1
	movls	r15, r15, lsr 32
	movls	r0, r0, lsr r0
	movls	r15, r15, asr r15
	movls	r0, r0, asr 1
	movls	r15, r15, asr 32
	movls	r0, r0, asr r0
	movls	r15, r15, asr r15
	movls	r0, r0, ror 1
	movls	r15, r15, ror 31
	movls	r0, r0, ror r0
	movls	r15, r15, ror r15
	movls	r0, r0, rrx

positive: movge instruction

	movge	r0, 0
	movge	r15, 0xff000000
	movge	r0, r0
	movge	r15, r15
	movge	r0, r0, lsl 0
	movge	r15, r15, lsl 31
	movge	r0, r0, lsl r0
	movge	r15, r15, lsl r15
	movge	r0, r0, lsr 1
	movge	r15, r15, lsr 32
	movge	r0, r0, lsr r0
	movge	r15, r15, asr r15
	movge	r0, r0, asr 1
	movge	r15, r15, asr 32
	movge	r0, r0, asr r0
	movge	r15, r15, asr r15
	movge	r0, r0, ror 1
	movge	r15, r15, ror 31
	movge	r0, r0, ror r0
	movge	r15, r15, ror r15
	movge	r0, r0, rrx

positive: movlt instruction

	movlt	r0, 0
	movlt	r15, 0xff000000
	movlt	r0, r0
	movlt	r15, r15
	movlt	r0, r0, lsl 0
	movlt	r15, r15, lsl 31
	movlt	r0, r0, lsl r0
	movlt	r15, r15, lsl r15
	movlt	r0, r0, lsr 1
	movlt	r15, r15, lsr 32
	movlt	r0, r0, lsr r0
	movlt	r15, r15, asr r15
	movlt	r0, r0, asr 1
	movlt	r15, r15, asr 32
	movlt	r0, r0, asr r0
	movlt	r15, r15, asr r15
	movlt	r0, r0, ror 1
	movlt	r15, r15, ror 31
	movlt	r0, r0, ror r0
	movlt	r15, r15, ror r15
	movlt	r0, r0, rrx

positive: movgt instruction

	movgt	r0, 0
	movgt	r15, 0xff000000
	movgt	r0, r0
	movgt	r15, r15
	movgt	r0, r0, lsl 0
	movgt	r15, r15, lsl 31
	movgt	r0, r0, lsl r0
	movgt	r15, r15, lsl r15
	movgt	r0, r0, lsr 1
	movgt	r15, r15, lsr 32
	movgt	r0, r0, lsr r0
	movgt	r15, r15, asr r15
	movgt	r0, r0, asr 1
	movgt	r15, r15, asr 32
	movgt	r0, r0, asr r0
	movgt	r15, r15, asr r15
	movgt	r0, r0, ror 1
	movgt	r15, r15, ror 31
	movgt	r0, r0, ror r0
	movgt	r15, r15, ror r15
	movgt	r0, r0, rrx

positive: movle instruction

	movle	r0, 0
	movle	r15, 0xff000000
	movle	r0, r0
	movle	r15, r15
	movle	r0, r0, lsl 0
	movle	r15, r15, lsl 31
	movle	r0, r0, lsl r0
	movle	r15, r15, lsl r15
	movle	r0, r0, lsr 1
	movle	r15, r15, lsr 32
	movle	r0, r0, lsr r0
	movle	r15, r15, asr r15
	movle	r0, r0, asr 1
	movle	r15, r15, asr 32
	movle	r0, r0, asr r0
	movle	r15, r15, asr r15
	movle	r0, r0, ror 1
	movle	r15, r15, ror 31
	movle	r0, r0, ror r0
	movle	r15, r15, ror r15
	movle	r0, r0, rrx

positive: moval instruction

	moval	r0, 0
	moval	r15, 0xff000000
	moval	r0, r0
	moval	r15, r15
	moval	r0, r0, lsl 0
	moval	r15, r15, lsl 31
	moval	r0, r0, lsl r0
	moval	r15, r15, lsl r15
	moval	r0, r0, lsr 1
	moval	r15, r15, lsr 32
	moval	r0, r0, lsr r0
	moval	r15, r15, asr r15
	moval	r0, r0, asr 1
	moval	r15, r15, asr 32
	moval	r0, r0, asr r0
	moval	r15, r15, asr r15
	moval	r0, r0, ror 1
	moval	r15, r15, ror 31
	moval	r0, r0, ror r0
	moval	r15, r15, ror r15
	moval	r0, r0, rrx

positive: movs instruction

	movs	r0, 0
	movs	r15, 0xff000000
	movs	r0, r0
	movs	r15, r15
	movs	r0, r0, lsl 0
	movs	r15, r15, lsl 31
	movs	r0, r0, lsl r0
	movs	r15, r15, lsl r15
	movs	r0, r0, lsr 1
	movs	r15, r15, lsr 32
	movs	r0, r0, lsr r0
	movs	r15, r15, asr r15
	movs	r0, r0, asr 1
	movs	r15, r15, asr 32
	movs	r0, r0, asr r0
	movs	r15, r15, asr r15
	movs	r0, r0, ror 1
	movs	r15, r15, ror 31
	movs	r0, r0, ror r0
	movs	r15, r15, ror r15
	movs	r0, r0, rrx

positive: movseq instruction

	movseq	r0, 0
	movseq	r15, 0xff000000
	movseq	r0, r0
	movseq	r15, r15
	movseq	r0, r0, lsl 0
	movseq	r15, r15, lsl 31
	movseq	r0, r0, lsl r0
	movseq	r15, r15, lsl r15
	movseq	r0, r0, lsr 1
	movseq	r15, r15, lsr 32
	movseq	r0, r0, lsr r0
	movseq	r15, r15, asr r15
	movseq	r0, r0, asr 1
	movseq	r15, r15, asr 32
	movseq	r0, r0, asr r0
	movseq	r15, r15, asr r15
	movseq	r0, r0, ror 1
	movseq	r15, r15, ror 31
	movseq	r0, r0, ror r0
	movseq	r15, r15, ror r15
	movseq	r0, r0, rrx

positive: movsne instruction

	movsne	r0, 0
	movsne	r15, 0xff000000
	movsne	r0, r0
	movsne	r15, r15
	movsne	r0, r0, lsl 0
	movsne	r15, r15, lsl 31
	movsne	r0, r0, lsl r0
	movsne	r15, r15, lsl r15
	movsne	r0, r0, lsr 1
	movsne	r15, r15, lsr 32
	movsne	r0, r0, lsr r0
	movsne	r15, r15, asr r15
	movsne	r0, r0, asr 1
	movsne	r15, r15, asr 32
	movsne	r0, r0, asr r0
	movsne	r15, r15, asr r15
	movsne	r0, r0, ror 1
	movsne	r15, r15, ror 31
	movsne	r0, r0, ror r0
	movsne	r15, r15, ror r15
	movsne	r0, r0, rrx

positive: movscs instruction

	movscs	r0, 0
	movscs	r15, 0xff000000
	movscs	r0, r0
	movscs	r15, r15
	movscs	r0, r0, lsl 0
	movscs	r15, r15, lsl 31
	movscs	r0, r0, lsl r0
	movscs	r15, r15, lsl r15
	movscs	r0, r0, lsr 1
	movscs	r15, r15, lsr 32
	movscs	r0, r0, lsr r0
	movscs	r15, r15, asr r15
	movscs	r0, r0, asr 1
	movscs	r15, r15, asr 32
	movscs	r0, r0, asr r0
	movscs	r15, r15, asr r15
	movscs	r0, r0, ror 1
	movscs	r15, r15, ror 31
	movscs	r0, r0, ror r0
	movscs	r15, r15, ror r15
	movscs	r0, r0, rrx

positive: movshs instruction

	movshs	r0, 0
	movshs	r15, 0xff000000
	movshs	r0, r0
	movshs	r15, r15
	movshs	r0, r0, lsl 0
	movshs	r15, r15, lsl 31
	movshs	r0, r0, lsl r0
	movshs	r15, r15, lsl r15
	movshs	r0, r0, lsr 1
	movshs	r15, r15, lsr 32
	movshs	r0, r0, lsr r0
	movshs	r15, r15, asr r15
	movshs	r0, r0, asr 1
	movshs	r15, r15, asr 32
	movshs	r0, r0, asr r0
	movshs	r15, r15, asr r15
	movshs	r0, r0, ror 1
	movshs	r15, r15, ror 31
	movshs	r0, r0, ror r0
	movshs	r15, r15, ror r15
	movshs	r0, r0, rrx

positive: movscc instruction

	movscc	r0, 0
	movscc	r15, 0xff000000
	movscc	r0, r0
	movscc	r15, r15
	movscc	r0, r0, lsl 0
	movscc	r15, r15, lsl 31
	movscc	r0, r0, lsl r0
	movscc	r15, r15, lsl r15
	movscc	r0, r0, lsr 1
	movscc	r15, r15, lsr 32
	movscc	r0, r0, lsr r0
	movscc	r15, r15, asr r15
	movscc	r0, r0, asr 1
	movscc	r15, r15, asr 32
	movscc	r0, r0, asr r0
	movscc	r15, r15, asr r15
	movscc	r0, r0, ror 1
	movscc	r15, r15, ror 31
	movscc	r0, r0, ror r0
	movscc	r15, r15, ror r15
	movscc	r0, r0, rrx

positive: movslo instruction

	movslo	r0, 0
	movslo	r15, 0xff000000
	movslo	r0, r0
	movslo	r15, r15
	movslo	r0, r0, lsl 0
	movslo	r15, r15, lsl 31
	movslo	r0, r0, lsl r0
	movslo	r15, r15, lsl r15
	movslo	r0, r0, lsr 1
	movslo	r15, r15, lsr 32
	movslo	r0, r0, lsr r0
	movslo	r15, r15, asr r15
	movslo	r0, r0, asr 1
	movslo	r15, r15, asr 32
	movslo	r0, r0, asr r0
	movslo	r15, r15, asr r15
	movslo	r0, r0, ror 1
	movslo	r15, r15, ror 31
	movslo	r0, r0, ror r0
	movslo	r15, r15, ror r15
	movslo	r0, r0, rrx

positive: movsmi instruction

	movsmi	r0, 0
	movsmi	r15, 0xff000000
	movsmi	r0, r0
	movsmi	r15, r15
	movsmi	r0, r0, lsl 0
	movsmi	r15, r15, lsl 31
	movsmi	r0, r0, lsl r0
	movsmi	r15, r15, lsl r15
	movsmi	r0, r0, lsr 1
	movsmi	r15, r15, lsr 32
	movsmi	r0, r0, lsr r0
	movsmi	r15, r15, asr r15
	movsmi	r0, r0, asr 1
	movsmi	r15, r15, asr 32
	movsmi	r0, r0, asr r0
	movsmi	r15, r15, asr r15
	movsmi	r0, r0, ror 1
	movsmi	r15, r15, ror 31
	movsmi	r0, r0, ror r0
	movsmi	r15, r15, ror r15
	movsmi	r0, r0, rrx

positive: movspl instruction

	movspl	r0, 0
	movspl	r15, 0xff000000
	movspl	r0, r0
	movspl	r15, r15
	movspl	r0, r0, lsl 0
	movspl	r15, r15, lsl 31
	movspl	r0, r0, lsl r0
	movspl	r15, r15, lsl r15
	movspl	r0, r0, lsr 1
	movspl	r15, r15, lsr 32
	movspl	r0, r0, lsr r0
	movspl	r15, r15, asr r15
	movspl	r0, r0, asr 1
	movspl	r15, r15, asr 32
	movspl	r0, r0, asr r0
	movspl	r15, r15, asr r15
	movspl	r0, r0, ror 1
	movspl	r15, r15, ror 31
	movspl	r0, r0, ror r0
	movspl	r15, r15, ror r15
	movspl	r0, r0, rrx

positive: movsvs instruction

	movsvs	r0, 0
	movsvs	r15, 0xff000000
	movsvs	r0, r0
	movsvs	r15, r15
	movsvs	r0, r0, lsl 0
	movsvs	r15, r15, lsl 31
	movsvs	r0, r0, lsl r0
	movsvs	r15, r15, lsl r15
	movsvs	r0, r0, lsr 1
	movsvs	r15, r15, lsr 32
	movsvs	r0, r0, lsr r0
	movsvs	r15, r15, asr r15
	movsvs	r0, r0, asr 1
	movsvs	r15, r15, asr 32
	movsvs	r0, r0, asr r0
	movsvs	r15, r15, asr r15
	movsvs	r0, r0, ror 1
	movsvs	r15, r15, ror 31
	movsvs	r0, r0, ror r0
	movsvs	r15, r15, ror r15
	movsvs	r0, r0, rrx

positive: movsvc instruction

	movsvc	r0, 0
	movsvc	r15, 0xff000000
	movsvc	r0, r0
	movsvc	r15, r15
	movsvc	r0, r0, lsl 0
	movsvc	r15, r15, lsl 31
	movsvc	r0, r0, lsl r0
	movsvc	r15, r15, lsl r15
	movsvc	r0, r0, lsr 1
	movsvc	r15, r15, lsr 32
	movsvc	r0, r0, lsr r0
	movsvc	r15, r15, asr r15
	movsvc	r0, r0, asr 1
	movsvc	r15, r15, asr 32
	movsvc	r0, r0, asr r0
	movsvc	r15, r15, asr r15
	movsvc	r0, r0, ror 1
	movsvc	r15, r15, ror 31
	movsvc	r0, r0, ror r0
	movsvc	r15, r15, ror r15
	movsvc	r0, r0, rrx

positive: movshi instruction

	movshi	r0, 0
	movshi	r15, 0xff000000
	movshi	r0, r0
	movshi	r15, r15
	movshi	r0, r0, lsl 0
	movshi	r15, r15, lsl 31
	movshi	r0, r0, lsl r0
	movshi	r15, r15, lsl r15
	movshi	r0, r0, lsr 1
	movshi	r15, r15, lsr 32
	movshi	r0, r0, lsr r0
	movshi	r15, r15, asr r15
	movshi	r0, r0, asr 1
	movshi	r15, r15, asr 32
	movshi	r0, r0, asr r0
	movshi	r15, r15, asr r15
	movshi	r0, r0, ror 1
	movshi	r15, r15, ror 31
	movshi	r0, r0, ror r0
	movshi	r15, r15, ror r15
	movshi	r0, r0, rrx

positive: movsls instruction

	movsls	r0, 0
	movsls	r15, 0xff000000
	movsls	r0, r0
	movsls	r15, r15
	movsls	r0, r0, lsl 0
	movsls	r15, r15, lsl 31
	movsls	r0, r0, lsl r0
	movsls	r15, r15, lsl r15
	movsls	r0, r0, lsr 1
	movsls	r15, r15, lsr 32
	movsls	r0, r0, lsr r0
	movsls	r15, r15, asr r15
	movsls	r0, r0, asr 1
	movsls	r15, r15, asr 32
	movsls	r0, r0, asr r0
	movsls	r15, r15, asr r15
	movsls	r0, r0, ror 1
	movsls	r15, r15, ror 31
	movsls	r0, r0, ror r0
	movsls	r15, r15, ror r15
	movsls	r0, r0, rrx

positive: movsge instruction

	movsge	r0, 0
	movsge	r15, 0xff000000
	movsge	r0, r0
	movsge	r15, r15
	movsge	r0, r0, lsl 0
	movsge	r15, r15, lsl 31
	movsge	r0, r0, lsl r0
	movsge	r15, r15, lsl r15
	movsge	r0, r0, lsr 1
	movsge	r15, r15, lsr 32
	movsge	r0, r0, lsr r0
	movsge	r15, r15, asr r15
	movsge	r0, r0, asr 1
	movsge	r15, r15, asr 32
	movsge	r0, r0, asr r0
	movsge	r15, r15, asr r15
	movsge	r0, r0, ror 1
	movsge	r15, r15, ror 31
	movsge	r0, r0, ror r0
	movsge	r15, r15, ror r15
	movsge	r0, r0, rrx

positive: movslt instruction

	movslt	r0, 0
	movslt	r15, 0xff000000
	movslt	r0, r0
	movslt	r15, r15
	movslt	r0, r0, lsl 0
	movslt	r15, r15, lsl 31
	movslt	r0, r0, lsl r0
	movslt	r15, r15, lsl r15
	movslt	r0, r0, lsr 1
	movslt	r15, r15, lsr 32
	movslt	r0, r0, lsr r0
	movslt	r15, r15, asr r15
	movslt	r0, r0, asr 1
	movslt	r15, r15, asr 32
	movslt	r0, r0, asr r0
	movslt	r15, r15, asr r15
	movslt	r0, r0, ror 1
	movslt	r15, r15, ror 31
	movslt	r0, r0, ror r0
	movslt	r15, r15, ror r15
	movslt	r0, r0, rrx

positive: movsgt instruction

	movsgt	r0, 0
	movsgt	r15, 0xff000000
	movsgt	r0, r0
	movsgt	r15, r15
	movsgt	r0, r0, lsl 0
	movsgt	r15, r15, lsl 31
	movsgt	r0, r0, lsl r0
	movsgt	r15, r15, lsl r15
	movsgt	r0, r0, lsr 1
	movsgt	r15, r15, lsr 32
	movsgt	r0, r0, lsr r0
	movsgt	r15, r15, asr r15
	movsgt	r0, r0, asr 1
	movsgt	r15, r15, asr 32
	movsgt	r0, r0, asr r0
	movsgt	r15, r15, asr r15
	movsgt	r0, r0, ror 1
	movsgt	r15, r15, ror 31
	movsgt	r0, r0, ror r0
	movsgt	r15, r15, ror r15
	movsgt	r0, r0, rrx

positive: movsle instruction

	movsle	r0, 0
	movsle	r15, 0xff000000
	movsle	r0, r0
	movsle	r15, r15
	movsle	r0, r0, lsl 0
	movsle	r15, r15, lsl 31
	movsle	r0, r0, lsl r0
	movsle	r15, r15, lsl r15
	movsle	r0, r0, lsr 1
	movsle	r15, r15, lsr 32
	movsle	r0, r0, lsr r0
	movsle	r15, r15, asr r15
	movsle	r0, r0, asr 1
	movsle	r15, r15, asr 32
	movsle	r0, r0, asr r0
	movsle	r15, r15, asr r15
	movsle	r0, r0, ror 1
	movsle	r15, r15, ror 31
	movsle	r0, r0, ror r0
	movsle	r15, r15, ror r15
	movsle	r0, r0, rrx

positive: movsal instruction

	movsal	r0, 0
	movsal	r15, 0xff000000
	movsal	r0, r0
	movsal	r15, r15
	movsal	r0, r0, lsl 0
	movsal	r15, r15, lsl 31
	movsal	r0, r0, lsl r0
	movsal	r15, r15, lsl r15
	movsal	r0, r0, lsr 1
	movsal	r15, r15, lsr 32
	movsal	r0, r0, lsr r0
	movsal	r15, r15, asr r15
	movsal	r0, r0, asr 1
	movsal	r15, r15, asr 32
	movsal	r0, r0, asr r0
	movsal	r15, r15, asr r15
	movsal	r0, r0, ror 1
	movsal	r15, r15, ror 31
	movsal	r0, r0, ror r0
	movsal	r15, r15, ror r15
	movsal	r0, r0, rrx

positive: mrc instruction

	mrc	p0, 0, r0, c0, c0
	mrc	p15, 7, r15, c15, c15
	mrc	p0, 0, r0, c0, c0, 0
	mrc	p15, 7, r15, c15, c15, 7

positive: mrceq instruction

	mrceq	p0, 0, r0, c0, c0
	mrceq	p15, 7, r15, c15, c15
	mrceq	p0, 0, r0, c0, c0, 0
	mrceq	p15, 7, r15, c15, c15, 7

positive: mrcne instruction

	mrcne	p0, 0, r0, c0, c0
	mrcne	p15, 7, r15, c15, c15
	mrcne	p0, 0, r0, c0, c0, 0
	mrcne	p15, 7, r15, c15, c15, 7

positive: mrccs instruction

	mrccs	p0, 0, r0, c0, c0
	mrccs	p15, 7, r15, c15, c15
	mrccs	p0, 0, r0, c0, c0, 0
	mrccs	p15, 7, r15, c15, c15, 7

positive: mrchs instruction

	mrchs	p0, 0, r0, c0, c0
	mrchs	p15, 7, r15, c15, c15
	mrchs	p0, 0, r0, c0, c0, 0
	mrchs	p15, 7, r15, c15, c15, 7

positive: mrccc instruction

	mrccc	p0, 0, r0, c0, c0
	mrccc	p15, 7, r15, c15, c15
	mrccc	p0, 0, r0, c0, c0, 0
	mrccc	p15, 7, r15, c15, c15, 7

positive: mrclo instruction

	mrclo	p0, 0, r0, c0, c0
	mrclo	p15, 7, r15, c15, c15
	mrclo	p0, 0, r0, c0, c0, 0
	mrclo	p15, 7, r15, c15, c15, 7

positive: mrcmi instruction

	mrcmi	p0, 0, r0, c0, c0
	mrcmi	p15, 7, r15, c15, c15
	mrcmi	p0, 0, r0, c0, c0, 0
	mrcmi	p15, 7, r15, c15, c15, 7

positive: mrcpl instruction

	mrcpl	p0, 0, r0, c0, c0
	mrcpl	p15, 7, r15, c15, c15
	mrcpl	p0, 0, r0, c0, c0, 0
	mrcpl	p15, 7, r15, c15, c15, 7

positive: mrcvs instruction

	mrcvs	p0, 0, r0, c0, c0
	mrcvs	p15, 7, r15, c15, c15
	mrcvs	p0, 0, r0, c0, c0, 0
	mrcvs	p15, 7, r15, c15, c15, 7

positive: mrcvc instruction

	mrcvc	p0, 0, r0, c0, c0
	mrcvc	p15, 7, r15, c15, c15
	mrcvc	p0, 0, r0, c0, c0, 0
	mrcvc	p15, 7, r15, c15, c15, 7

positive: mrchi instruction

	mrchi	p0, 0, r0, c0, c0
	mrchi	p15, 7, r15, c15, c15
	mrchi	p0, 0, r0, c0, c0, 0
	mrchi	p15, 7, r15, c15, c15, 7

positive: mrcls instruction

	mrcls	p0, 0, r0, c0, c0
	mrcls	p15, 7, r15, c15, c15
	mrcls	p0, 0, r0, c0, c0, 0
	mrcls	p15, 7, r15, c15, c15, 7

positive: mrcge instruction

	mrcge	p0, 0, r0, c0, c0
	mrcge	p15, 7, r15, c15, c15
	mrcge	p0, 0, r0, c0, c0, 0
	mrcge	p15, 7, r15, c15, c15, 7

positive: mrclt instruction

	mrclt	p0, 0, r0, c0, c0
	mrclt	p15, 7, r15, c15, c15
	mrclt	p0, 0, r0, c0, c0, 0
	mrclt	p15, 7, r15, c15, c15, 7

positive: mrcgt instruction

	mrcgt	p0, 0, r0, c0, c0
	mrcgt	p15, 7, r15, c15, c15
	mrcgt	p0, 0, r0, c0, c0, 0
	mrcgt	p15, 7, r15, c15, c15, 7

positive: mrcle instruction

	mrcle	p0, 0, r0, c0, c0
	mrcle	p15, 7, r15, c15, c15
	mrcle	p0, 0, r0, c0, c0, 0
	mrcle	p15, 7, r15, c15, c15, 7

positive: mrcal instruction

	mrcal	p0, 0, r0, c0, c0
	mrcal	p15, 7, r15, c15, c15
	mrcal	p0, 0, r0, c0, c0, 0
	mrcal	p15, 7, r15, c15, c15, 7

positive: mrc2 instruction

	mrc2	p0, 0, r0, c0, c0
	mrc2	p15, 7, r15, c15, c15
	mrc2	p0, 0, r0, c0, c0, 0
	mrc2	p15, 7, r15, c15, c15, 7

positive: mrs instruction

	mrs	r0
	mrs	r15

positive: mrseq instruction

	mrseq	r0
	mrseq	r15

positive: mrsne instruction

	mrsne	r0
	mrsne	r15

positive: mrscs instruction

	mrscs	r0
	mrscs	r15

positive: mrshs instruction

	mrshs	r0
	mrshs	r15

positive: mrscc instruction

	mrscc	r0
	mrscc	r15

positive: mrslo instruction

	mrslo	r0
	mrslo	r15

positive: mrsmi instruction

	mrsmi	r0
	mrsmi	r15

positive: mrspl instruction

	mrspl	r0
	mrspl	r15

positive: mrsvs instruction

	mrsvs	r0
	mrsvs	r15

positive: mrsvc instruction

	mrsvc	r0
	mrsvc	r15

positive: mrshi instruction

	mrshi	r0
	mrshi	r15

positive: mrsls instruction

	mrsls	r0
	mrsls	r15

positive: mrsge instruction

	mrsge	r0
	mrsge	r15

positive: mrslt instruction

	mrslt	r0
	mrslt	r15

positive: mrsgt instruction

	mrsgt	r0
	mrsgt	r15

positive: mrsle instruction

	mrsle	r0
	mrsle	r15

positive: mrsal instruction

	mrsal	r0
	mrsal	r15

positive: msr instruction

	msr	0
	msr	0xff000000
	msr	r0
	msr	r15

positive: msreq instruction

	msreq	0
	msreq	0xff000000
	msreq	r0
	msreq	r15

positive: msrne instruction

	msrne	0
	msrne	0xff000000
	msrne	r0
	msrne	r15

positive: msrcs instruction

	msrcs	0
	msrcs	0xff000000
	msrcs	r0
	msrcs	r15

positive: msrhs instruction

	msrhs	0
	msrhs	0xff000000
	msrhs	r0
	msrhs	r15

positive: msrcc instruction

	msrcc	0
	msrcc	0xff000000
	msrcc	r0
	msrcc	r15

positive: msrlo instruction

	msrlo	0
	msrlo	0xff000000
	msrlo	r0
	msrlo	r15

positive: msrmi instruction

	msrmi	0
	msrmi	0xff000000
	msrmi	r0
	msrmi	r15

positive: msrpl instruction

	msrpl	0
	msrpl	0xff000000
	msrpl	r0
	msrpl	r15

positive: msrvs instruction

	msrvs	0
	msrvs	0xff000000
	msrvs	r0
	msrvs	r15

positive: msrvc instruction

	msrvc	0
	msrvc	0xff000000
	msrvc	r0
	msrvc	r15

positive: msrhi instruction

	msrhi	0
	msrhi	0xff000000
	msrhi	r0
	msrhi	r15

positive: msrls instruction

	msrls	0
	msrls	0xff000000
	msrls	r0
	msrls	r15

positive: msrge instruction

	msrge	0
	msrge	0xff000000
	msrge	r0
	msrge	r15

positive: msrlt instruction

	msrlt	0
	msrlt	0xff000000
	msrlt	r0
	msrlt	r15

positive: msrgt instruction

	msrgt	0
	msrgt	0xff000000
	msrgt	r0
	msrgt	r15

positive: msrle instruction

	msrle	0
	msrle	0xff000000
	msrle	r0
	msrle	r15

positive: msral instruction

	msral	0
	msral	0xff000000
	msral	r0
	msral	r15

positive: mul instruction

	mul	r0, r0, r0
	mul	r15, r15, r15

positive: muleq instruction

	muleq	r0, r0, r0
	muleq	r15, r15, r15

positive: mulne instruction

	mulne	r0, r0, r0
	mulne	r15, r15, r15

positive: mulcs instruction

	mulcs	r0, r0, r0
	mulcs	r15, r15, r15

positive: mulhs instruction

	mulhs	r0, r0, r0
	mulhs	r15, r15, r15

positive: mulcc instruction

	mulcc	r0, r0, r0
	mulcc	r15, r15, r15

positive: mullo instruction

	mullo	r0, r0, r0
	mullo	r15, r15, r15

positive: mulmi instruction

	mulmi	r0, r0, r0
	mulmi	r15, r15, r15

positive: mulpl instruction

	mulpl	r0, r0, r0
	mulpl	r15, r15, r15

positive: mulvs instruction

	mulvs	r0, r0, r0
	mulvs	r15, r15, r15

positive: mulvc instruction

	mulvc	r0, r0, r0
	mulvc	r15, r15, r15

positive: mulhi instruction

	mulhi	r0, r0, r0
	mulhi	r15, r15, r15

positive: mulls instruction

	mulls	r0, r0, r0
	mulls	r15, r15, r15

positive: mulge instruction

	mulge	r0, r0, r0
	mulge	r15, r15, r15

positive: mullt instruction

	mullt	r0, r0, r0
	mullt	r15, r15, r15

positive: mulgt instruction

	mulgt	r0, r0, r0
	mulgt	r15, r15, r15

positive: mulle instruction

	mulle	r0, r0, r0
	mulle	r15, r15, r15

positive: mulal instruction

	mulal	r0, r0, r0
	mulal	r15, r15, r15

positive: muls instruction

	muls	r0, r0, r0
	muls	r15, r15, r15

positive: mulseq instruction

	mulseq	r0, r0, r0
	mulseq	r15, r15, r15

positive: mulsne instruction

	mulsne	r0, r0, r0
	mulsne	r15, r15, r15

positive: mulscs instruction

	mulscs	r0, r0, r0
	mulscs	r15, r15, r15

positive: mulshs instruction

	mulshs	r0, r0, r0
	mulshs	r15, r15, r15

positive: mulscc instruction

	mulscc	r0, r0, r0
	mulscc	r15, r15, r15

positive: mulslo instruction

	mulslo	r0, r0, r0
	mulslo	r15, r15, r15

positive: mulsmi instruction

	mulsmi	r0, r0, r0
	mulsmi	r15, r15, r15

positive: mulspl instruction

	mulspl	r0, r0, r0
	mulspl	r15, r15, r15

positive: mulsvs instruction

	mulsvs	r0, r0, r0
	mulsvs	r15, r15, r15

positive: mulsvc instruction

	mulsvc	r0, r0, r0
	mulsvc	r15, r15, r15

positive: mulshi instruction

	mulshi	r0, r0, r0
	mulshi	r15, r15, r15

positive: mulsls instruction

	mulsls	r0, r0, r0
	mulsls	r15, r15, r15

positive: mulsge instruction

	mulsge	r0, r0, r0
	mulsge	r15, r15, r15

positive: mulslt instruction

	mulslt	r0, r0, r0
	mulslt	r15, r15, r15

positive: mulsgt instruction

	mulsgt	r0, r0, r0
	mulsgt	r15, r15, r15

positive: mulsle instruction

	mulsle	r0, r0, r0
	mulsle	r15, r15, r15

positive: mulsal instruction

	mulsal	r0, r0, r0
	mulsal	r15, r15, r15

positive: mvn instruction

	mvn	r0, 0
	mvn	r15, 0xff000000
	mvn	r0, r0
	mvn	r15, r15
	mvn	r0, r0, lsl 0
	mvn	r15, r15, lsl 31
	mvn	r0, r0, lsl r0
	mvn	r15, r15, lsl r15
	mvn	r0, r0, lsr 1
	mvn	r15, r15, lsr 32
	mvn	r0, r0, lsr r0
	mvn	r15, r15, asr r15
	mvn	r0, r0, asr 1
	mvn	r15, r15, asr 32
	mvn	r0, r0, asr r0
	mvn	r15, r15, asr r15
	mvn	r0, r0, ror 1
	mvn	r15, r15, ror 31
	mvn	r0, r0, ror r0
	mvn	r15, r15, ror r15
	mvn	r0, r0, rrx

positive: mvneq instruction

	mvneq	r0, 0
	mvneq	r15, 0xff000000
	mvneq	r0, r0
	mvneq	r15, r15
	mvneq	r0, r0, lsl 0
	mvneq	r15, r15, lsl 31
	mvneq	r0, r0, lsl r0
	mvneq	r15, r15, lsl r15
	mvneq	r0, r0, lsr 1
	mvneq	r15, r15, lsr 32
	mvneq	r0, r0, lsr r0
	mvneq	r15, r15, asr r15
	mvneq	r0, r0, asr 1
	mvneq	r15, r15, asr 32
	mvneq	r0, r0, asr r0
	mvneq	r15, r15, asr r15
	mvneq	r0, r0, ror 1
	mvneq	r15, r15, ror 31
	mvneq	r0, r0, ror r0
	mvneq	r15, r15, ror r15
	mvneq	r0, r0, rrx

positive: mvnne instruction

	mvnne	r0, 0
	mvnne	r15, 0xff000000
	mvnne	r0, r0
	mvnne	r15, r15
	mvnne	r0, r0, lsl 0
	mvnne	r15, r15, lsl 31
	mvnne	r0, r0, lsl r0
	mvnne	r15, r15, lsl r15
	mvnne	r0, r0, lsr 1
	mvnne	r15, r15, lsr 32
	mvnne	r0, r0, lsr r0
	mvnne	r15, r15, asr r15
	mvnne	r0, r0, asr 1
	mvnne	r15, r15, asr 32
	mvnne	r0, r0, asr r0
	mvnne	r15, r15, asr r15
	mvnne	r0, r0, ror 1
	mvnne	r15, r15, ror 31
	mvnne	r0, r0, ror r0
	mvnne	r15, r15, ror r15
	mvnne	r0, r0, rrx

positive: mvncs instruction

	mvncs	r0, 0
	mvncs	r15, 0xff000000
	mvncs	r0, r0
	mvncs	r15, r15
	mvncs	r0, r0, lsl 0
	mvncs	r15, r15, lsl 31
	mvncs	r0, r0, lsl r0
	mvncs	r15, r15, lsl r15
	mvncs	r0, r0, lsr 1
	mvncs	r15, r15, lsr 32
	mvncs	r0, r0, lsr r0
	mvncs	r15, r15, asr r15
	mvncs	r0, r0, asr 1
	mvncs	r15, r15, asr 32
	mvncs	r0, r0, asr r0
	mvncs	r15, r15, asr r15
	mvncs	r0, r0, ror 1
	mvncs	r15, r15, ror 31
	mvncs	r0, r0, ror r0
	mvncs	r15, r15, ror r15
	mvncs	r0, r0, rrx

positive: mvnhs instruction

	mvnhs	r0, 0
	mvnhs	r15, 0xff000000
	mvnhs	r0, r0
	mvnhs	r15, r15
	mvnhs	r0, r0, lsl 0
	mvnhs	r15, r15, lsl 31
	mvnhs	r0, r0, lsl r0
	mvnhs	r15, r15, lsl r15
	mvnhs	r0, r0, lsr 1
	mvnhs	r15, r15, lsr 32
	mvnhs	r0, r0, lsr r0
	mvnhs	r15, r15, asr r15
	mvnhs	r0, r0, asr 1
	mvnhs	r15, r15, asr 32
	mvnhs	r0, r0, asr r0
	mvnhs	r15, r15, asr r15
	mvnhs	r0, r0, ror 1
	mvnhs	r15, r15, ror 31
	mvnhs	r0, r0, ror r0
	mvnhs	r15, r15, ror r15
	mvnhs	r0, r0, rrx

positive: mvncc instruction

	mvncc	r0, 0
	mvncc	r15, 0xff000000
	mvncc	r0, r0
	mvncc	r15, r15
	mvncc	r0, r0, lsl 0
	mvncc	r15, r15, lsl 31
	mvncc	r0, r0, lsl r0
	mvncc	r15, r15, lsl r15
	mvncc	r0, r0, lsr 1
	mvncc	r15, r15, lsr 32
	mvncc	r0, r0, lsr r0
	mvncc	r15, r15, asr r15
	mvncc	r0, r0, asr 1
	mvncc	r15, r15, asr 32
	mvncc	r0, r0, asr r0
	mvncc	r15, r15, asr r15
	mvncc	r0, r0, ror 1
	mvncc	r15, r15, ror 31
	mvncc	r0, r0, ror r0
	mvncc	r15, r15, ror r15
	mvncc	r0, r0, rrx

positive: mvnlo instruction

	mvnlo	r0, 0
	mvnlo	r15, 0xff000000
	mvnlo	r0, r0
	mvnlo	r15, r15
	mvnlo	r0, r0, lsl 0
	mvnlo	r15, r15, lsl 31
	mvnlo	r0, r0, lsl r0
	mvnlo	r15, r15, lsl r15
	mvnlo	r0, r0, lsr 1
	mvnlo	r15, r15, lsr 32
	mvnlo	r0, r0, lsr r0
	mvnlo	r15, r15, asr r15
	mvnlo	r0, r0, asr 1
	mvnlo	r15, r15, asr 32
	mvnlo	r0, r0, asr r0
	mvnlo	r15, r15, asr r15
	mvnlo	r0, r0, ror 1
	mvnlo	r15, r15, ror 31
	mvnlo	r0, r0, ror r0
	mvnlo	r15, r15, ror r15
	mvnlo	r0, r0, rrx

positive: mvnmi instruction

	mvnmi	r0, 0
	mvnmi	r15, 0xff000000
	mvnmi	r0, r0
	mvnmi	r15, r15
	mvnmi	r0, r0, lsl 0
	mvnmi	r15, r15, lsl 31
	mvnmi	r0, r0, lsl r0
	mvnmi	r15, r15, lsl r15
	mvnmi	r0, r0, lsr 1
	mvnmi	r15, r15, lsr 32
	mvnmi	r0, r0, lsr r0
	mvnmi	r15, r15, asr r15
	mvnmi	r0, r0, asr 1
	mvnmi	r15, r15, asr 32
	mvnmi	r0, r0, asr r0
	mvnmi	r15, r15, asr r15
	mvnmi	r0, r0, ror 1
	mvnmi	r15, r15, ror 31
	mvnmi	r0, r0, ror r0
	mvnmi	r15, r15, ror r15
	mvnmi	r0, r0, rrx

positive: mvnpl instruction

	mvnpl	r0, 0
	mvnpl	r15, 0xff000000
	mvnpl	r0, r0
	mvnpl	r15, r15
	mvnpl	r0, r0, lsl 0
	mvnpl	r15, r15, lsl 31
	mvnpl	r0, r0, lsl r0
	mvnpl	r15, r15, lsl r15
	mvnpl	r0, r0, lsr 1
	mvnpl	r15, r15, lsr 32
	mvnpl	r0, r0, lsr r0
	mvnpl	r15, r15, asr r15
	mvnpl	r0, r0, asr 1
	mvnpl	r15, r15, asr 32
	mvnpl	r0, r0, asr r0
	mvnpl	r15, r15, asr r15
	mvnpl	r0, r0, ror 1
	mvnpl	r15, r15, ror 31
	mvnpl	r0, r0, ror r0
	mvnpl	r15, r15, ror r15
	mvnpl	r0, r0, rrx

positive: mvnvs instruction

	mvnvs	r0, 0
	mvnvs	r15, 0xff000000
	mvnvs	r0, r0
	mvnvs	r15, r15
	mvnvs	r0, r0, lsl 0
	mvnvs	r15, r15, lsl 31
	mvnvs	r0, r0, lsl r0
	mvnvs	r15, r15, lsl r15
	mvnvs	r0, r0, lsr 1
	mvnvs	r15, r15, lsr 32
	mvnvs	r0, r0, lsr r0
	mvnvs	r15, r15, asr r15
	mvnvs	r0, r0, asr 1
	mvnvs	r15, r15, asr 32
	mvnvs	r0, r0, asr r0
	mvnvs	r15, r15, asr r15
	mvnvs	r0, r0, ror 1
	mvnvs	r15, r15, ror 31
	mvnvs	r0, r0, ror r0
	mvnvs	r15, r15, ror r15
	mvnvs	r0, r0, rrx

positive: mvnvc instruction

	mvnvc	r0, 0
	mvnvc	r15, 0xff000000
	mvnvc	r0, r0
	mvnvc	r15, r15
	mvnvc	r0, r0, lsl 0
	mvnvc	r15, r15, lsl 31
	mvnvc	r0, r0, lsl r0
	mvnvc	r15, r15, lsl r15
	mvnvc	r0, r0, lsr 1
	mvnvc	r15, r15, lsr 32
	mvnvc	r0, r0, lsr r0
	mvnvc	r15, r15, asr r15
	mvnvc	r0, r0, asr 1
	mvnvc	r15, r15, asr 32
	mvnvc	r0, r0, asr r0
	mvnvc	r15, r15, asr r15
	mvnvc	r0, r0, ror 1
	mvnvc	r15, r15, ror 31
	mvnvc	r0, r0, ror r0
	mvnvc	r15, r15, ror r15
	mvnvc	r0, r0, rrx

positive: mvnhi instruction

	mvnhi	r0, 0
	mvnhi	r15, 0xff000000
	mvnhi	r0, r0
	mvnhi	r15, r15
	mvnhi	r0, r0, lsl 0
	mvnhi	r15, r15, lsl 31
	mvnhi	r0, r0, lsl r0
	mvnhi	r15, r15, lsl r15
	mvnhi	r0, r0, lsr 1
	mvnhi	r15, r15, lsr 32
	mvnhi	r0, r0, lsr r0
	mvnhi	r15, r15, asr r15
	mvnhi	r0, r0, asr 1
	mvnhi	r15, r15, asr 32
	mvnhi	r0, r0, asr r0
	mvnhi	r15, r15, asr r15
	mvnhi	r0, r0, ror 1
	mvnhi	r15, r15, ror 31
	mvnhi	r0, r0, ror r0
	mvnhi	r15, r15, ror r15
	mvnhi	r0, r0, rrx

positive: mvnls instruction

	mvnls	r0, 0
	mvnls	r15, 0xff000000
	mvnls	r0, r0
	mvnls	r15, r15
	mvnls	r0, r0, lsl 0
	mvnls	r15, r15, lsl 31
	mvnls	r0, r0, lsl r0
	mvnls	r15, r15, lsl r15
	mvnls	r0, r0, lsr 1
	mvnls	r15, r15, lsr 32
	mvnls	r0, r0, lsr r0
	mvnls	r15, r15, asr r15
	mvnls	r0, r0, asr 1
	mvnls	r15, r15, asr 32
	mvnls	r0, r0, asr r0
	mvnls	r15, r15, asr r15
	mvnls	r0, r0, ror 1
	mvnls	r15, r15, ror 31
	mvnls	r0, r0, ror r0
	mvnls	r15, r15, ror r15
	mvnls	r0, r0, rrx

positive: mvnge instruction

	mvnge	r0, 0
	mvnge	r15, 0xff000000
	mvnge	r0, r0
	mvnge	r15, r15
	mvnge	r0, r0, lsl 0
	mvnge	r15, r15, lsl 31
	mvnge	r0, r0, lsl r0
	mvnge	r15, r15, lsl r15
	mvnge	r0, r0, lsr 1
	mvnge	r15, r15, lsr 32
	mvnge	r0, r0, lsr r0
	mvnge	r15, r15, asr r15
	mvnge	r0, r0, asr 1
	mvnge	r15, r15, asr 32
	mvnge	r0, r0, asr r0
	mvnge	r15, r15, asr r15
	mvnge	r0, r0, ror 1
	mvnge	r15, r15, ror 31
	mvnge	r0, r0, ror r0
	mvnge	r15, r15, ror r15
	mvnge	r0, r0, rrx

positive: mvnlt instruction

	mvnlt	r0, 0
	mvnlt	r15, 0xff000000
	mvnlt	r0, r0
	mvnlt	r15, r15
	mvnlt	r0, r0, lsl 0
	mvnlt	r15, r15, lsl 31
	mvnlt	r0, r0, lsl r0
	mvnlt	r15, r15, lsl r15
	mvnlt	r0, r0, lsr 1
	mvnlt	r15, r15, lsr 32
	mvnlt	r0, r0, lsr r0
	mvnlt	r15, r15, asr r15
	mvnlt	r0, r0, asr 1
	mvnlt	r15, r15, asr 32
	mvnlt	r0, r0, asr r0
	mvnlt	r15, r15, asr r15
	mvnlt	r0, r0, ror 1
	mvnlt	r15, r15, ror 31
	mvnlt	r0, r0, ror r0
	mvnlt	r15, r15, ror r15
	mvnlt	r0, r0, rrx

positive: mvngt instruction

	mvngt	r0, 0
	mvngt	r15, 0xff000000
	mvngt	r0, r0
	mvngt	r15, r15
	mvngt	r0, r0, lsl 0
	mvngt	r15, r15, lsl 31
	mvngt	r0, r0, lsl r0
	mvngt	r15, r15, lsl r15
	mvngt	r0, r0, lsr 1
	mvngt	r15, r15, lsr 32
	mvngt	r0, r0, lsr r0
	mvngt	r15, r15, asr r15
	mvngt	r0, r0, asr 1
	mvngt	r15, r15, asr 32
	mvngt	r0, r0, asr r0
	mvngt	r15, r15, asr r15
	mvngt	r0, r0, ror 1
	mvngt	r15, r15, ror 31
	mvngt	r0, r0, ror r0
	mvngt	r15, r15, ror r15
	mvngt	r0, r0, rrx

positive: mvnle instruction

	mvnle	r0, 0
	mvnle	r15, 0xff000000
	mvnle	r0, r0
	mvnle	r15, r15
	mvnle	r0, r0, lsl 0
	mvnle	r15, r15, lsl 31
	mvnle	r0, r0, lsl r0
	mvnle	r15, r15, lsl r15
	mvnle	r0, r0, lsr 1
	mvnle	r15, r15, lsr 32
	mvnle	r0, r0, lsr r0
	mvnle	r15, r15, asr r15
	mvnle	r0, r0, asr 1
	mvnle	r15, r15, asr 32
	mvnle	r0, r0, asr r0
	mvnle	r15, r15, asr r15
	mvnle	r0, r0, ror 1
	mvnle	r15, r15, ror 31
	mvnle	r0, r0, ror r0
	mvnle	r15, r15, ror r15
	mvnle	r0, r0, rrx

positive: mvnal instruction

	mvnal	r0, 0
	mvnal	r15, 0xff000000
	mvnal	r0, r0
	mvnal	r15, r15
	mvnal	r0, r0, lsl 0
	mvnal	r15, r15, lsl 31
	mvnal	r0, r0, lsl r0
	mvnal	r15, r15, lsl r15
	mvnal	r0, r0, lsr 1
	mvnal	r15, r15, lsr 32
	mvnal	r0, r0, lsr r0
	mvnal	r15, r15, asr r15
	mvnal	r0, r0, asr 1
	mvnal	r15, r15, asr 32
	mvnal	r0, r0, asr r0
	mvnal	r15, r15, asr r15
	mvnal	r0, r0, ror 1
	mvnal	r15, r15, ror 31
	mvnal	r0, r0, ror r0
	mvnal	r15, r15, ror r15
	mvnal	r0, r0, rrx

positive: mvns instruction

	mvns	r0, 0
	mvns	r15, 0xff000000
	mvns	r0, r0
	mvns	r15, r15
	mvns	r0, r0, lsl 0
	mvns	r15, r15, lsl 31
	mvns	r0, r0, lsl r0
	mvns	r15, r15, lsl r15
	mvns	r0, r0, lsr 1
	mvns	r15, r15, lsr 32
	mvns	r0, r0, lsr r0
	mvns	r15, r15, asr r15
	mvns	r0, r0, asr 1
	mvns	r15, r15, asr 32
	mvns	r0, r0, asr r0
	mvns	r15, r15, asr r15
	mvns	r0, r0, ror 1
	mvns	r15, r15, ror 31
	mvns	r0, r0, ror r0
	mvns	r15, r15, ror r15
	mvns	r0, r0, rrx

positive: mvnseq instruction

	mvnseq	r0, 0
	mvnseq	r15, 0xff000000
	mvnseq	r0, r0
	mvnseq	r15, r15
	mvnseq	r0, r0, lsl 0
	mvnseq	r15, r15, lsl 31
	mvnseq	r0, r0, lsl r0
	mvnseq	r15, r15, lsl r15
	mvnseq	r0, r0, lsr 1
	mvnseq	r15, r15, lsr 32
	mvnseq	r0, r0, lsr r0
	mvnseq	r15, r15, asr r15
	mvnseq	r0, r0, asr 1
	mvnseq	r15, r15, asr 32
	mvnseq	r0, r0, asr r0
	mvnseq	r15, r15, asr r15
	mvnseq	r0, r0, ror 1
	mvnseq	r15, r15, ror 31
	mvnseq	r0, r0, ror r0
	mvnseq	r15, r15, ror r15
	mvnseq	r0, r0, rrx

positive: mvnsne instruction

	mvnsne	r0, 0
	mvnsne	r15, 0xff000000
	mvnsne	r0, r0
	mvnsne	r15, r15
	mvnsne	r0, r0, lsl 0
	mvnsne	r15, r15, lsl 31
	mvnsne	r0, r0, lsl r0
	mvnsne	r15, r15, lsl r15
	mvnsne	r0, r0, lsr 1
	mvnsne	r15, r15, lsr 32
	mvnsne	r0, r0, lsr r0
	mvnsne	r15, r15, asr r15
	mvnsne	r0, r0, asr 1
	mvnsne	r15, r15, asr 32
	mvnsne	r0, r0, asr r0
	mvnsne	r15, r15, asr r15
	mvnsne	r0, r0, ror 1
	mvnsne	r15, r15, ror 31
	mvnsne	r0, r0, ror r0
	mvnsne	r15, r15, ror r15
	mvnsne	r0, r0, rrx

positive: mvnscs instruction

	mvnscs	r0, 0
	mvnscs	r15, 0xff000000
	mvnscs	r0, r0
	mvnscs	r15, r15
	mvnscs	r0, r0, lsl 0
	mvnscs	r15, r15, lsl 31
	mvnscs	r0, r0, lsl r0
	mvnscs	r15, r15, lsl r15
	mvnscs	r0, r0, lsr 1
	mvnscs	r15, r15, lsr 32
	mvnscs	r0, r0, lsr r0
	mvnscs	r15, r15, asr r15
	mvnscs	r0, r0, asr 1
	mvnscs	r15, r15, asr 32
	mvnscs	r0, r0, asr r0
	mvnscs	r15, r15, asr r15
	mvnscs	r0, r0, ror 1
	mvnscs	r15, r15, ror 31
	mvnscs	r0, r0, ror r0
	mvnscs	r15, r15, ror r15
	mvnscs	r0, r0, rrx

positive: mvnshs instruction

	mvnshs	r0, 0
	mvnshs	r15, 0xff000000
	mvnshs	r0, r0
	mvnshs	r15, r15
	mvnshs	r0, r0, lsl 0
	mvnshs	r15, r15, lsl 31
	mvnshs	r0, r0, lsl r0
	mvnshs	r15, r15, lsl r15
	mvnshs	r0, r0, lsr 1
	mvnshs	r15, r15, lsr 32
	mvnshs	r0, r0, lsr r0
	mvnshs	r15, r15, asr r15
	mvnshs	r0, r0, asr 1
	mvnshs	r15, r15, asr 32
	mvnshs	r0, r0, asr r0
	mvnshs	r15, r15, asr r15
	mvnshs	r0, r0, ror 1
	mvnshs	r15, r15, ror 31
	mvnshs	r0, r0, ror r0
	mvnshs	r15, r15, ror r15
	mvnshs	r0, r0, rrx

positive: mvnscc instruction

	mvnscc	r0, 0
	mvnscc	r15, 0xff000000
	mvnscc	r0, r0
	mvnscc	r15, r15
	mvnscc	r0, r0, lsl 0
	mvnscc	r15, r15, lsl 31
	mvnscc	r0, r0, lsl r0
	mvnscc	r15, r15, lsl r15
	mvnscc	r0, r0, lsr 1
	mvnscc	r15, r15, lsr 32
	mvnscc	r0, r0, lsr r0
	mvnscc	r15, r15, asr r15
	mvnscc	r0, r0, asr 1
	mvnscc	r15, r15, asr 32
	mvnscc	r0, r0, asr r0
	mvnscc	r15, r15, asr r15
	mvnscc	r0, r0, ror 1
	mvnscc	r15, r15, ror 31
	mvnscc	r0, r0, ror r0
	mvnscc	r15, r15, ror r15
	mvnscc	r0, r0, rrx

positive: mvnslo instruction

	mvnslo	r0, 0
	mvnslo	r15, 0xff000000
	mvnslo	r0, r0
	mvnslo	r15, r15
	mvnslo	r0, r0, lsl 0
	mvnslo	r15, r15, lsl 31
	mvnslo	r0, r0, lsl r0
	mvnslo	r15, r15, lsl r15
	mvnslo	r0, r0, lsr 1
	mvnslo	r15, r15, lsr 32
	mvnslo	r0, r0, lsr r0
	mvnslo	r15, r15, asr r15
	mvnslo	r0, r0, asr 1
	mvnslo	r15, r15, asr 32
	mvnslo	r0, r0, asr r0
	mvnslo	r15, r15, asr r15
	mvnslo	r0, r0, ror 1
	mvnslo	r15, r15, ror 31
	mvnslo	r0, r0, ror r0
	mvnslo	r15, r15, ror r15
	mvnslo	r0, r0, rrx

positive: mvnsmi instruction

	mvnsmi	r0, 0
	mvnsmi	r15, 0xff000000
	mvnsmi	r0, r0
	mvnsmi	r15, r15
	mvnsmi	r0, r0, lsl 0
	mvnsmi	r15, r15, lsl 31
	mvnsmi	r0, r0, lsl r0
	mvnsmi	r15, r15, lsl r15
	mvnsmi	r0, r0, lsr 1
	mvnsmi	r15, r15, lsr 32
	mvnsmi	r0, r0, lsr r0
	mvnsmi	r15, r15, asr r15
	mvnsmi	r0, r0, asr 1
	mvnsmi	r15, r15, asr 32
	mvnsmi	r0, r0, asr r0
	mvnsmi	r15, r15, asr r15
	mvnsmi	r0, r0, ror 1
	mvnsmi	r15, r15, ror 31
	mvnsmi	r0, r0, ror r0
	mvnsmi	r15, r15, ror r15
	mvnsmi	r0, r0, rrx

positive: mvnspl instruction

	mvnspl	r0, 0
	mvnspl	r15, 0xff000000
	mvnspl	r0, r0
	mvnspl	r15, r15
	mvnspl	r0, r0, lsl 0
	mvnspl	r15, r15, lsl 31
	mvnspl	r0, r0, lsl r0
	mvnspl	r15, r15, lsl r15
	mvnspl	r0, r0, lsr 1
	mvnspl	r15, r15, lsr 32
	mvnspl	r0, r0, lsr r0
	mvnspl	r15, r15, asr r15
	mvnspl	r0, r0, asr 1
	mvnspl	r15, r15, asr 32
	mvnspl	r0, r0, asr r0
	mvnspl	r15, r15, asr r15
	mvnspl	r0, r0, ror 1
	mvnspl	r15, r15, ror 31
	mvnspl	r0, r0, ror r0
	mvnspl	r15, r15, ror r15
	mvnspl	r0, r0, rrx

positive: mvnsvs instruction

	mvnsvs	r0, 0
	mvnsvs	r15, 0xff000000
	mvnsvs	r0, r0
	mvnsvs	r15, r15
	mvnsvs	r0, r0, lsl 0
	mvnsvs	r15, r15, lsl 31
	mvnsvs	r0, r0, lsl r0
	mvnsvs	r15, r15, lsl r15
	mvnsvs	r0, r0, lsr 1
	mvnsvs	r15, r15, lsr 32
	mvnsvs	r0, r0, lsr r0
	mvnsvs	r15, r15, asr r15
	mvnsvs	r0, r0, asr 1
	mvnsvs	r15, r15, asr 32
	mvnsvs	r0, r0, asr r0
	mvnsvs	r15, r15, asr r15
	mvnsvs	r0, r0, ror 1
	mvnsvs	r15, r15, ror 31
	mvnsvs	r0, r0, ror r0
	mvnsvs	r15, r15, ror r15
	mvnsvs	r0, r0, rrx

positive: mvnsvc instruction

	mvnsvc	r0, 0
	mvnsvc	r15, 0xff000000
	mvnsvc	r0, r0
	mvnsvc	r15, r15
	mvnsvc	r0, r0, lsl 0
	mvnsvc	r15, r15, lsl 31
	mvnsvc	r0, r0, lsl r0
	mvnsvc	r15, r15, lsl r15
	mvnsvc	r0, r0, lsr 1
	mvnsvc	r15, r15, lsr 32
	mvnsvc	r0, r0, lsr r0
	mvnsvc	r15, r15, asr r15
	mvnsvc	r0, r0, asr 1
	mvnsvc	r15, r15, asr 32
	mvnsvc	r0, r0, asr r0
	mvnsvc	r15, r15, asr r15
	mvnsvc	r0, r0, ror 1
	mvnsvc	r15, r15, ror 31
	mvnsvc	r0, r0, ror r0
	mvnsvc	r15, r15, ror r15
	mvnsvc	r0, r0, rrx

positive: mvnshi instruction

	mvnshi	r0, 0
	mvnshi	r15, 0xff000000
	mvnshi	r0, r0
	mvnshi	r15, r15
	mvnshi	r0, r0, lsl 0
	mvnshi	r15, r15, lsl 31
	mvnshi	r0, r0, lsl r0
	mvnshi	r15, r15, lsl r15
	mvnshi	r0, r0, lsr 1
	mvnshi	r15, r15, lsr 32
	mvnshi	r0, r0, lsr r0
	mvnshi	r15, r15, asr r15
	mvnshi	r0, r0, asr 1
	mvnshi	r15, r15, asr 32
	mvnshi	r0, r0, asr r0
	mvnshi	r15, r15, asr r15
	mvnshi	r0, r0, ror 1
	mvnshi	r15, r15, ror 31
	mvnshi	r0, r0, ror r0
	mvnshi	r15, r15, ror r15
	mvnshi	r0, r0, rrx

positive: mvnsls instruction

	mvnsls	r0, 0
	mvnsls	r15, 0xff000000
	mvnsls	r0, r0
	mvnsls	r15, r15
	mvnsls	r0, r0, lsl 0
	mvnsls	r15, r15, lsl 31
	mvnsls	r0, r0, lsl r0
	mvnsls	r15, r15, lsl r15
	mvnsls	r0, r0, lsr 1
	mvnsls	r15, r15, lsr 32
	mvnsls	r0, r0, lsr r0
	mvnsls	r15, r15, asr r15
	mvnsls	r0, r0, asr 1
	mvnsls	r15, r15, asr 32
	mvnsls	r0, r0, asr r0
	mvnsls	r15, r15, asr r15
	mvnsls	r0, r0, ror 1
	mvnsls	r15, r15, ror 31
	mvnsls	r0, r0, ror r0
	mvnsls	r15, r15, ror r15
	mvnsls	r0, r0, rrx

positive: mvnsge instruction

	mvnsge	r0, 0
	mvnsge	r15, 0xff000000
	mvnsge	r0, r0
	mvnsge	r15, r15
	mvnsge	r0, r0, lsl 0
	mvnsge	r15, r15, lsl 31
	mvnsge	r0, r0, lsl r0
	mvnsge	r15, r15, lsl r15
	mvnsge	r0, r0, lsr 1
	mvnsge	r15, r15, lsr 32
	mvnsge	r0, r0, lsr r0
	mvnsge	r15, r15, asr r15
	mvnsge	r0, r0, asr 1
	mvnsge	r15, r15, asr 32
	mvnsge	r0, r0, asr r0
	mvnsge	r15, r15, asr r15
	mvnsge	r0, r0, ror 1
	mvnsge	r15, r15, ror 31
	mvnsge	r0, r0, ror r0
	mvnsge	r15, r15, ror r15
	mvnsge	r0, r0, rrx

positive: mvnslt instruction

	mvnslt	r0, 0
	mvnslt	r15, 0xff000000
	mvnslt	r0, r0
	mvnslt	r15, r15
	mvnslt	r0, r0, lsl 0
	mvnslt	r15, r15, lsl 31
	mvnslt	r0, r0, lsl r0
	mvnslt	r15, r15, lsl r15
	mvnslt	r0, r0, lsr 1
	mvnslt	r15, r15, lsr 32
	mvnslt	r0, r0, lsr r0
	mvnslt	r15, r15, asr r15
	mvnslt	r0, r0, asr 1
	mvnslt	r15, r15, asr 32
	mvnslt	r0, r0, asr r0
	mvnslt	r15, r15, asr r15
	mvnslt	r0, r0, ror 1
	mvnslt	r15, r15, ror 31
	mvnslt	r0, r0, ror r0
	mvnslt	r15, r15, ror r15
	mvnslt	r0, r0, rrx

positive: mvnsgt instruction

	mvnsgt	r0, 0
	mvnsgt	r15, 0xff000000
	mvnsgt	r0, r0
	mvnsgt	r15, r15
	mvnsgt	r0, r0, lsl 0
	mvnsgt	r15, r15, lsl 31
	mvnsgt	r0, r0, lsl r0
	mvnsgt	r15, r15, lsl r15
	mvnsgt	r0, r0, lsr 1
	mvnsgt	r15, r15, lsr 32
	mvnsgt	r0, r0, lsr r0
	mvnsgt	r15, r15, asr r15
	mvnsgt	r0, r0, asr 1
	mvnsgt	r15, r15, asr 32
	mvnsgt	r0, r0, asr r0
	mvnsgt	r15, r15, asr r15
	mvnsgt	r0, r0, ror 1
	mvnsgt	r15, r15, ror 31
	mvnsgt	r0, r0, ror r0
	mvnsgt	r15, r15, ror r15
	mvnsgt	r0, r0, rrx

positive: mvnsle instruction

	mvnsle	r0, 0
	mvnsle	r15, 0xff000000
	mvnsle	r0, r0
	mvnsle	r15, r15
	mvnsle	r0, r0, lsl 0
	mvnsle	r15, r15, lsl 31
	mvnsle	r0, r0, lsl r0
	mvnsle	r15, r15, lsl r15
	mvnsle	r0, r0, lsr 1
	mvnsle	r15, r15, lsr 32
	mvnsle	r0, r0, lsr r0
	mvnsle	r15, r15, asr r15
	mvnsle	r0, r0, asr 1
	mvnsle	r15, r15, asr 32
	mvnsle	r0, r0, asr r0
	mvnsle	r15, r15, asr r15
	mvnsle	r0, r0, ror 1
	mvnsle	r15, r15, ror 31
	mvnsle	r0, r0, ror r0
	mvnsle	r15, r15, ror r15
	mvnsle	r0, r0, rrx

positive: mvnsal instruction

	mvnsal	r0, 0
	mvnsal	r15, 0xff000000
	mvnsal	r0, r0
	mvnsal	r15, r15
	mvnsal	r0, r0, lsl 0
	mvnsal	r15, r15, lsl 31
	mvnsal	r0, r0, lsl r0
	mvnsal	r15, r15, lsl r15
	mvnsal	r0, r0, lsr 1
	mvnsal	r15, r15, lsr 32
	mvnsal	r0, r0, lsr r0
	mvnsal	r15, r15, asr r15
	mvnsal	r0, r0, asr 1
	mvnsal	r15, r15, asr 32
	mvnsal	r0, r0, asr r0
	mvnsal	r15, r15, asr r15
	mvnsal	r0, r0, ror 1
	mvnsal	r15, r15, ror 31
	mvnsal	r0, r0, ror r0
	mvnsal	r15, r15, ror r15
	mvnsal	r0, r0, rrx

positive: orr instruction

	orr	r0, r0, 0
	orr	r15, r15, 0xff000000
	orr	r0, r0, r0
	orr	r15, r15, r15
	orr	r0, r0, r0, lsl 0
	orr	r15, r15, r15, lsl 31
	orr	r0, r0, r0, lsl r0
	orr	r15, r15, r15, lsl r15
	orr	r0, r0, r0, lsr 1
	orr	r15, r15, r15, lsr 32
	orr	r0, r0, r0, lsr r0
	orr	r15, r15, r15, asr r15
	orr	r0, r0, r0, asr 1
	orr	r15, r15, r15, asr 32
	orr	r0, r0, r0, asr r0
	orr	r15, r15, r15, asr r15
	orr	r0, r0, r0, ror 1
	orr	r15, r15, r15, ror 31
	orr	r0, r0, r0, ror r0
	orr	r15, r15, r15, ror r15
	orr	r0, r0, r0, rrx

positive: orreq instruction

	orreq	r0, r0, 0
	orreq	r15, r15, 0xff000000
	orreq	r0, r0, r0
	orreq	r15, r15, r15
	orreq	r0, r0, r0, lsl 0
	orreq	r15, r15, r15, lsl 31
	orreq	r0, r0, r0, lsl r0
	orreq	r15, r15, r15, lsl r15
	orreq	r0, r0, r0, lsr 1
	orreq	r15, r15, r15, lsr 32
	orreq	r0, r0, r0, lsr r0
	orreq	r15, r15, r15, asr r15
	orreq	r0, r0, r0, asr 1
	orreq	r15, r15, r15, asr 32
	orreq	r0, r0, r0, asr r0
	orreq	r15, r15, r15, asr r15
	orreq	r0, r0, r0, ror 1
	orreq	r15, r15, r15, ror 31
	orreq	r0, r0, r0, ror r0
	orreq	r15, r15, r15, ror r15
	orreq	r0, r0, r0, rrx

positive: orrne instruction

	orrne	r0, r0, 0
	orrne	r15, r15, 0xff000000
	orrne	r0, r0, r0
	orrne	r15, r15, r15
	orrne	r0, r0, r0, lsl 0
	orrne	r15, r15, r15, lsl 31
	orrne	r0, r0, r0, lsl r0
	orrne	r15, r15, r15, lsl r15
	orrne	r0, r0, r0, lsr 1
	orrne	r15, r15, r15, lsr 32
	orrne	r0, r0, r0, lsr r0
	orrne	r15, r15, r15, asr r15
	orrne	r0, r0, r0, asr 1
	orrne	r15, r15, r15, asr 32
	orrne	r0, r0, r0, asr r0
	orrne	r15, r15, r15, asr r15
	orrne	r0, r0, r0, ror 1
	orrne	r15, r15, r15, ror 31
	orrne	r0, r0, r0, ror r0
	orrne	r15, r15, r15, ror r15
	orrne	r0, r0, r0, rrx

positive: orrcs instruction

	orrcs	r0, r0, 0
	orrcs	r15, r15, 0xff000000
	orrcs	r0, r0, r0
	orrcs	r15, r15, r15
	orrcs	r0, r0, r0, lsl 0
	orrcs	r15, r15, r15, lsl 31
	orrcs	r0, r0, r0, lsl r0
	orrcs	r15, r15, r15, lsl r15
	orrcs	r0, r0, r0, lsr 1
	orrcs	r15, r15, r15, lsr 32
	orrcs	r0, r0, r0, lsr r0
	orrcs	r15, r15, r15, asr r15
	orrcs	r0, r0, r0, asr 1
	orrcs	r15, r15, r15, asr 32
	orrcs	r0, r0, r0, asr r0
	orrcs	r15, r15, r15, asr r15
	orrcs	r0, r0, r0, ror 1
	orrcs	r15, r15, r15, ror 31
	orrcs	r0, r0, r0, ror r0
	orrcs	r15, r15, r15, ror r15
	orrcs	r0, r0, r0, rrx

positive: orrhs instruction

	orrhs	r0, r0, 0
	orrhs	r15, r15, 0xff000000
	orrhs	r0, r0, r0
	orrhs	r15, r15, r15
	orrhs	r0, r0, r0, lsl 0
	orrhs	r15, r15, r15, lsl 31
	orrhs	r0, r0, r0, lsl r0
	orrhs	r15, r15, r15, lsl r15
	orrhs	r0, r0, r0, lsr 1
	orrhs	r15, r15, r15, lsr 32
	orrhs	r0, r0, r0, lsr r0
	orrhs	r15, r15, r15, asr r15
	orrhs	r0, r0, r0, asr 1
	orrhs	r15, r15, r15, asr 32
	orrhs	r0, r0, r0, asr r0
	orrhs	r15, r15, r15, asr r15
	orrhs	r0, r0, r0, ror 1
	orrhs	r15, r15, r15, ror 31
	orrhs	r0, r0, r0, ror r0
	orrhs	r15, r15, r15, ror r15
	orrhs	r0, r0, r0, rrx

positive: orrcc instruction

	orrcc	r0, r0, 0
	orrcc	r15, r15, 0xff000000
	orrcc	r0, r0, r0
	orrcc	r15, r15, r15
	orrcc	r0, r0, r0, lsl 0
	orrcc	r15, r15, r15, lsl 31
	orrcc	r0, r0, r0, lsl r0
	orrcc	r15, r15, r15, lsl r15
	orrcc	r0, r0, r0, lsr 1
	orrcc	r15, r15, r15, lsr 32
	orrcc	r0, r0, r0, lsr r0
	orrcc	r15, r15, r15, asr r15
	orrcc	r0, r0, r0, asr 1
	orrcc	r15, r15, r15, asr 32
	orrcc	r0, r0, r0, asr r0
	orrcc	r15, r15, r15, asr r15
	orrcc	r0, r0, r0, ror 1
	orrcc	r15, r15, r15, ror 31
	orrcc	r0, r0, r0, ror r0
	orrcc	r15, r15, r15, ror r15
	orrcc	r0, r0, r0, rrx

positive: orrlo instruction

	orrlo	r0, r0, 0
	orrlo	r15, r15, 0xff000000
	orrlo	r0, r0, r0
	orrlo	r15, r15, r15
	orrlo	r0, r0, r0, lsl 0
	orrlo	r15, r15, r15, lsl 31
	orrlo	r0, r0, r0, lsl r0
	orrlo	r15, r15, r15, lsl r15
	orrlo	r0, r0, r0, lsr 1
	orrlo	r15, r15, r15, lsr 32
	orrlo	r0, r0, r0, lsr r0
	orrlo	r15, r15, r15, asr r15
	orrlo	r0, r0, r0, asr 1
	orrlo	r15, r15, r15, asr 32
	orrlo	r0, r0, r0, asr r0
	orrlo	r15, r15, r15, asr r15
	orrlo	r0, r0, r0, ror 1
	orrlo	r15, r15, r15, ror 31
	orrlo	r0, r0, r0, ror r0
	orrlo	r15, r15, r15, ror r15
	orrlo	r0, r0, r0, rrx

positive: orrmi instruction

	orrmi	r0, r0, 0
	orrmi	r15, r15, 0xff000000
	orrmi	r0, r0, r0
	orrmi	r15, r15, r15
	orrmi	r0, r0, r0, lsl 0
	orrmi	r15, r15, r15, lsl 31
	orrmi	r0, r0, r0, lsl r0
	orrmi	r15, r15, r15, lsl r15
	orrmi	r0, r0, r0, lsr 1
	orrmi	r15, r15, r15, lsr 32
	orrmi	r0, r0, r0, lsr r0
	orrmi	r15, r15, r15, asr r15
	orrmi	r0, r0, r0, asr 1
	orrmi	r15, r15, r15, asr 32
	orrmi	r0, r0, r0, asr r0
	orrmi	r15, r15, r15, asr r15
	orrmi	r0, r0, r0, ror 1
	orrmi	r15, r15, r15, ror 31
	orrmi	r0, r0, r0, ror r0
	orrmi	r15, r15, r15, ror r15
	orrmi	r0, r0, r0, rrx

positive: orrpl instruction

	orrpl	r0, r0, 0
	orrpl	r15, r15, 0xff000000
	orrpl	r0, r0, r0
	orrpl	r15, r15, r15
	orrpl	r0, r0, r0, lsl 0
	orrpl	r15, r15, r15, lsl 31
	orrpl	r0, r0, r0, lsl r0
	orrpl	r15, r15, r15, lsl r15
	orrpl	r0, r0, r0, lsr 1
	orrpl	r15, r15, r15, lsr 32
	orrpl	r0, r0, r0, lsr r0
	orrpl	r15, r15, r15, asr r15
	orrpl	r0, r0, r0, asr 1
	orrpl	r15, r15, r15, asr 32
	orrpl	r0, r0, r0, asr r0
	orrpl	r15, r15, r15, asr r15
	orrpl	r0, r0, r0, ror 1
	orrpl	r15, r15, r15, ror 31
	orrpl	r0, r0, r0, ror r0
	orrpl	r15, r15, r15, ror r15
	orrpl	r0, r0, r0, rrx

positive: orrvs instruction

	orrvs	r0, r0, 0
	orrvs	r15, r15, 0xff000000
	orrvs	r0, r0, r0
	orrvs	r15, r15, r15
	orrvs	r0, r0, r0, lsl 0
	orrvs	r15, r15, r15, lsl 31
	orrvs	r0, r0, r0, lsl r0
	orrvs	r15, r15, r15, lsl r15
	orrvs	r0, r0, r0, lsr 1
	orrvs	r15, r15, r15, lsr 32
	orrvs	r0, r0, r0, lsr r0
	orrvs	r15, r15, r15, asr r15
	orrvs	r0, r0, r0, asr 1
	orrvs	r15, r15, r15, asr 32
	orrvs	r0, r0, r0, asr r0
	orrvs	r15, r15, r15, asr r15
	orrvs	r0, r0, r0, ror 1
	orrvs	r15, r15, r15, ror 31
	orrvs	r0, r0, r0, ror r0
	orrvs	r15, r15, r15, ror r15
	orrvs	r0, r0, r0, rrx

positive: orrvc instruction

	orrvc	r0, r0, 0
	orrvc	r15, r15, 0xff000000
	orrvc	r0, r0, r0
	orrvc	r15, r15, r15
	orrvc	r0, r0, r0, lsl 0
	orrvc	r15, r15, r15, lsl 31
	orrvc	r0, r0, r0, lsl r0
	orrvc	r15, r15, r15, lsl r15
	orrvc	r0, r0, r0, lsr 1
	orrvc	r15, r15, r15, lsr 32
	orrvc	r0, r0, r0, lsr r0
	orrvc	r15, r15, r15, asr r15
	orrvc	r0, r0, r0, asr 1
	orrvc	r15, r15, r15, asr 32
	orrvc	r0, r0, r0, asr r0
	orrvc	r15, r15, r15, asr r15
	orrvc	r0, r0, r0, ror 1
	orrvc	r15, r15, r15, ror 31
	orrvc	r0, r0, r0, ror r0
	orrvc	r15, r15, r15, ror r15
	orrvc	r0, r0, r0, rrx

positive: orrhi instruction

	orrhi	r0, r0, 0
	orrhi	r15, r15, 0xff000000
	orrhi	r0, r0, r0
	orrhi	r15, r15, r15
	orrhi	r0, r0, r0, lsl 0
	orrhi	r15, r15, r15, lsl 31
	orrhi	r0, r0, r0, lsl r0
	orrhi	r15, r15, r15, lsl r15
	orrhi	r0, r0, r0, lsr 1
	orrhi	r15, r15, r15, lsr 32
	orrhi	r0, r0, r0, lsr r0
	orrhi	r15, r15, r15, asr r15
	orrhi	r0, r0, r0, asr 1
	orrhi	r15, r15, r15, asr 32
	orrhi	r0, r0, r0, asr r0
	orrhi	r15, r15, r15, asr r15
	orrhi	r0, r0, r0, ror 1
	orrhi	r15, r15, r15, ror 31
	orrhi	r0, r0, r0, ror r0
	orrhi	r15, r15, r15, ror r15
	orrhi	r0, r0, r0, rrx

positive: orrls instruction

	orrls	r0, r0, 0
	orrls	r15, r15, 0xff000000
	orrls	r0, r0, r0
	orrls	r15, r15, r15
	orrls	r0, r0, r0, lsl 0
	orrls	r15, r15, r15, lsl 31
	orrls	r0, r0, r0, lsl r0
	orrls	r15, r15, r15, lsl r15
	orrls	r0, r0, r0, lsr 1
	orrls	r15, r15, r15, lsr 32
	orrls	r0, r0, r0, lsr r0
	orrls	r15, r15, r15, asr r15
	orrls	r0, r0, r0, asr 1
	orrls	r15, r15, r15, asr 32
	orrls	r0, r0, r0, asr r0
	orrls	r15, r15, r15, asr r15
	orrls	r0, r0, r0, ror 1
	orrls	r15, r15, r15, ror 31
	orrls	r0, r0, r0, ror r0
	orrls	r15, r15, r15, ror r15
	orrls	r0, r0, r0, rrx

positive: orrge instruction

	orrge	r0, r0, 0
	orrge	r15, r15, 0xff000000
	orrge	r0, r0, r0
	orrge	r15, r15, r15
	orrge	r0, r0, r0, lsl 0
	orrge	r15, r15, r15, lsl 31
	orrge	r0, r0, r0, lsl r0
	orrge	r15, r15, r15, lsl r15
	orrge	r0, r0, r0, lsr 1
	orrge	r15, r15, r15, lsr 32
	orrge	r0, r0, r0, lsr r0
	orrge	r15, r15, r15, asr r15
	orrge	r0, r0, r0, asr 1
	orrge	r15, r15, r15, asr 32
	orrge	r0, r0, r0, asr r0
	orrge	r15, r15, r15, asr r15
	orrge	r0, r0, r0, ror 1
	orrge	r15, r15, r15, ror 31
	orrge	r0, r0, r0, ror r0
	orrge	r15, r15, r15, ror r15
	orrge	r0, r0, r0, rrx

positive: orrlt instruction

	orrlt	r0, r0, 0
	orrlt	r15, r15, 0xff000000
	orrlt	r0, r0, r0
	orrlt	r15, r15, r15
	orrlt	r0, r0, r0, lsl 0
	orrlt	r15, r15, r15, lsl 31
	orrlt	r0, r0, r0, lsl r0
	orrlt	r15, r15, r15, lsl r15
	orrlt	r0, r0, r0, lsr 1
	orrlt	r15, r15, r15, lsr 32
	orrlt	r0, r0, r0, lsr r0
	orrlt	r15, r15, r15, asr r15
	orrlt	r0, r0, r0, asr 1
	orrlt	r15, r15, r15, asr 32
	orrlt	r0, r0, r0, asr r0
	orrlt	r15, r15, r15, asr r15
	orrlt	r0, r0, r0, ror 1
	orrlt	r15, r15, r15, ror 31
	orrlt	r0, r0, r0, ror r0
	orrlt	r15, r15, r15, ror r15
	orrlt	r0, r0, r0, rrx

positive: orrgt instruction

	orrgt	r0, r0, 0
	orrgt	r15, r15, 0xff000000
	orrgt	r0, r0, r0
	orrgt	r15, r15, r15
	orrgt	r0, r0, r0, lsl 0
	orrgt	r15, r15, r15, lsl 31
	orrgt	r0, r0, r0, lsl r0
	orrgt	r15, r15, r15, lsl r15
	orrgt	r0, r0, r0, lsr 1
	orrgt	r15, r15, r15, lsr 32
	orrgt	r0, r0, r0, lsr r0
	orrgt	r15, r15, r15, asr r15
	orrgt	r0, r0, r0, asr 1
	orrgt	r15, r15, r15, asr 32
	orrgt	r0, r0, r0, asr r0
	orrgt	r15, r15, r15, asr r15
	orrgt	r0, r0, r0, ror 1
	orrgt	r15, r15, r15, ror 31
	orrgt	r0, r0, r0, ror r0
	orrgt	r15, r15, r15, ror r15
	orrgt	r0, r0, r0, rrx

positive: orrle instruction

	orrle	r0, r0, 0
	orrle	r15, r15, 0xff000000
	orrle	r0, r0, r0
	orrle	r15, r15, r15
	orrle	r0, r0, r0, lsl 0
	orrle	r15, r15, r15, lsl 31
	orrle	r0, r0, r0, lsl r0
	orrle	r15, r15, r15, lsl r15
	orrle	r0, r0, r0, lsr 1
	orrle	r15, r15, r15, lsr 32
	orrle	r0, r0, r0, lsr r0
	orrle	r15, r15, r15, asr r15
	orrle	r0, r0, r0, asr 1
	orrle	r15, r15, r15, asr 32
	orrle	r0, r0, r0, asr r0
	orrle	r15, r15, r15, asr r15
	orrle	r0, r0, r0, ror 1
	orrle	r15, r15, r15, ror 31
	orrle	r0, r0, r0, ror r0
	orrle	r15, r15, r15, ror r15
	orrle	r0, r0, r0, rrx

positive: orral instruction

	orral	r0, r0, 0
	orral	r15, r15, 0xff000000
	orral	r0, r0, r0
	orral	r15, r15, r15
	orral	r0, r0, r0, lsl 0
	orral	r15, r15, r15, lsl 31
	orral	r0, r0, r0, lsl r0
	orral	r15, r15, r15, lsl r15
	orral	r0, r0, r0, lsr 1
	orral	r15, r15, r15, lsr 32
	orral	r0, r0, r0, lsr r0
	orral	r15, r15, r15, asr r15
	orral	r0, r0, r0, asr 1
	orral	r15, r15, r15, asr 32
	orral	r0, r0, r0, asr r0
	orral	r15, r15, r15, asr r15
	orral	r0, r0, r0, ror 1
	orral	r15, r15, r15, ror 31
	orral	r0, r0, r0, ror r0
	orral	r15, r15, r15, ror r15
	orral	r0, r0, r0, rrx

positive: orrs instruction

	orrs	r0, r0, 0
	orrs	r15, r15, 0xff000000
	orrs	r0, r0, r0
	orrs	r15, r15, r15
	orrs	r0, r0, r0, lsl 0
	orrs	r15, r15, r15, lsl 31
	orrs	r0, r0, r0, lsl r0
	orrs	r15, r15, r15, lsl r15
	orrs	r0, r0, r0, lsr 1
	orrs	r15, r15, r15, lsr 32
	orrs	r0, r0, r0, lsr r0
	orrs	r15, r15, r15, asr r15
	orrs	r0, r0, r0, asr 1
	orrs	r15, r15, r15, asr 32
	orrs	r0, r0, r0, asr r0
	orrs	r15, r15, r15, asr r15
	orrs	r0, r0, r0, ror 1
	orrs	r15, r15, r15, ror 31
	orrs	r0, r0, r0, ror r0
	orrs	r15, r15, r15, ror r15
	orrs	r0, r0, r0, rrx

positive: orrseq instruction

	orrseq	r0, r0, 0
	orrseq	r15, r15, 0xff000000
	orrseq	r0, r0, r0
	orrseq	r15, r15, r15
	orrseq	r0, r0, r0, lsl 0
	orrseq	r15, r15, r15, lsl 31
	orrseq	r0, r0, r0, lsl r0
	orrseq	r15, r15, r15, lsl r15
	orrseq	r0, r0, r0, lsr 1
	orrseq	r15, r15, r15, lsr 32
	orrseq	r0, r0, r0, lsr r0
	orrseq	r15, r15, r15, asr r15
	orrseq	r0, r0, r0, asr 1
	orrseq	r15, r15, r15, asr 32
	orrseq	r0, r0, r0, asr r0
	orrseq	r15, r15, r15, asr r15
	orrseq	r0, r0, r0, ror 1
	orrseq	r15, r15, r15, ror 31
	orrseq	r0, r0, r0, ror r0
	orrseq	r15, r15, r15, ror r15
	orrseq	r0, r0, r0, rrx

positive: orrsne instruction

	orrsne	r0, r0, 0
	orrsne	r15, r15, 0xff000000
	orrsne	r0, r0, r0
	orrsne	r15, r15, r15
	orrsne	r0, r0, r0, lsl 0
	orrsne	r15, r15, r15, lsl 31
	orrsne	r0, r0, r0, lsl r0
	orrsne	r15, r15, r15, lsl r15
	orrsne	r0, r0, r0, lsr 1
	orrsne	r15, r15, r15, lsr 32
	orrsne	r0, r0, r0, lsr r0
	orrsne	r15, r15, r15, asr r15
	orrsne	r0, r0, r0, asr 1
	orrsne	r15, r15, r15, asr 32
	orrsne	r0, r0, r0, asr r0
	orrsne	r15, r15, r15, asr r15
	orrsne	r0, r0, r0, ror 1
	orrsne	r15, r15, r15, ror 31
	orrsne	r0, r0, r0, ror r0
	orrsne	r15, r15, r15, ror r15
	orrsne	r0, r0, r0, rrx

positive: orrscs instruction

	orrscs	r0, r0, 0
	orrscs	r15, r15, 0xff000000
	orrscs	r0, r0, r0
	orrscs	r15, r15, r15
	orrscs	r0, r0, r0, lsl 0
	orrscs	r15, r15, r15, lsl 31
	orrscs	r0, r0, r0, lsl r0
	orrscs	r15, r15, r15, lsl r15
	orrscs	r0, r0, r0, lsr 1
	orrscs	r15, r15, r15, lsr 32
	orrscs	r0, r0, r0, lsr r0
	orrscs	r15, r15, r15, asr r15
	orrscs	r0, r0, r0, asr 1
	orrscs	r15, r15, r15, asr 32
	orrscs	r0, r0, r0, asr r0
	orrscs	r15, r15, r15, asr r15
	orrscs	r0, r0, r0, ror 1
	orrscs	r15, r15, r15, ror 31
	orrscs	r0, r0, r0, ror r0
	orrscs	r15, r15, r15, ror r15
	orrscs	r0, r0, r0, rrx

positive: orrshs instruction

	orrshs	r0, r0, 0
	orrshs	r15, r15, 0xff000000
	orrshs	r0, r0, r0
	orrshs	r15, r15, r15
	orrshs	r0, r0, r0, lsl 0
	orrshs	r15, r15, r15, lsl 31
	orrshs	r0, r0, r0, lsl r0
	orrshs	r15, r15, r15, lsl r15
	orrshs	r0, r0, r0, lsr 1
	orrshs	r15, r15, r15, lsr 32
	orrshs	r0, r0, r0, lsr r0
	orrshs	r15, r15, r15, asr r15
	orrshs	r0, r0, r0, asr 1
	orrshs	r15, r15, r15, asr 32
	orrshs	r0, r0, r0, asr r0
	orrshs	r15, r15, r15, asr r15
	orrshs	r0, r0, r0, ror 1
	orrshs	r15, r15, r15, ror 31
	orrshs	r0, r0, r0, ror r0
	orrshs	r15, r15, r15, ror r15
	orrshs	r0, r0, r0, rrx

positive: orrscc instruction

	orrscc	r0, r0, 0
	orrscc	r15, r15, 0xff000000
	orrscc	r0, r0, r0
	orrscc	r15, r15, r15
	orrscc	r0, r0, r0, lsl 0
	orrscc	r15, r15, r15, lsl 31
	orrscc	r0, r0, r0, lsl r0
	orrscc	r15, r15, r15, lsl r15
	orrscc	r0, r0, r0, lsr 1
	orrscc	r15, r15, r15, lsr 32
	orrscc	r0, r0, r0, lsr r0
	orrscc	r15, r15, r15, asr r15
	orrscc	r0, r0, r0, asr 1
	orrscc	r15, r15, r15, asr 32
	orrscc	r0, r0, r0, asr r0
	orrscc	r15, r15, r15, asr r15
	orrscc	r0, r0, r0, ror 1
	orrscc	r15, r15, r15, ror 31
	orrscc	r0, r0, r0, ror r0
	orrscc	r15, r15, r15, ror r15
	orrscc	r0, r0, r0, rrx

positive: orrslo instruction

	orrslo	r0, r0, 0
	orrslo	r15, r15, 0xff000000
	orrslo	r0, r0, r0
	orrslo	r15, r15, r15
	orrslo	r0, r0, r0, lsl 0
	orrslo	r15, r15, r15, lsl 31
	orrslo	r0, r0, r0, lsl r0
	orrslo	r15, r15, r15, lsl r15
	orrslo	r0, r0, r0, lsr 1
	orrslo	r15, r15, r15, lsr 32
	orrslo	r0, r0, r0, lsr r0
	orrslo	r15, r15, r15, asr r15
	orrslo	r0, r0, r0, asr 1
	orrslo	r15, r15, r15, asr 32
	orrslo	r0, r0, r0, asr r0
	orrslo	r15, r15, r15, asr r15
	orrslo	r0, r0, r0, ror 1
	orrslo	r15, r15, r15, ror 31
	orrslo	r0, r0, r0, ror r0
	orrslo	r15, r15, r15, ror r15
	orrslo	r0, r0, r0, rrx

positive: orrsmi instruction

	orrsmi	r0, r0, 0
	orrsmi	r15, r15, 0xff000000
	orrsmi	r0, r0, r0
	orrsmi	r15, r15, r15
	orrsmi	r0, r0, r0, lsl 0
	orrsmi	r15, r15, r15, lsl 31
	orrsmi	r0, r0, r0, lsl r0
	orrsmi	r15, r15, r15, lsl r15
	orrsmi	r0, r0, r0, lsr 1
	orrsmi	r15, r15, r15, lsr 32
	orrsmi	r0, r0, r0, lsr r0
	orrsmi	r15, r15, r15, asr r15
	orrsmi	r0, r0, r0, asr 1
	orrsmi	r15, r15, r15, asr 32
	orrsmi	r0, r0, r0, asr r0
	orrsmi	r15, r15, r15, asr r15
	orrsmi	r0, r0, r0, ror 1
	orrsmi	r15, r15, r15, ror 31
	orrsmi	r0, r0, r0, ror r0
	orrsmi	r15, r15, r15, ror r15
	orrsmi	r0, r0, r0, rrx

positive: orrspl instruction

	orrspl	r0, r0, 0
	orrspl	r15, r15, 0xff000000
	orrspl	r0, r0, r0
	orrspl	r15, r15, r15
	orrspl	r0, r0, r0, lsl 0
	orrspl	r15, r15, r15, lsl 31
	orrspl	r0, r0, r0, lsl r0
	orrspl	r15, r15, r15, lsl r15
	orrspl	r0, r0, r0, lsr 1
	orrspl	r15, r15, r15, lsr 32
	orrspl	r0, r0, r0, lsr r0
	orrspl	r15, r15, r15, asr r15
	orrspl	r0, r0, r0, asr 1
	orrspl	r15, r15, r15, asr 32
	orrspl	r0, r0, r0, asr r0
	orrspl	r15, r15, r15, asr r15
	orrspl	r0, r0, r0, ror 1
	orrspl	r15, r15, r15, ror 31
	orrspl	r0, r0, r0, ror r0
	orrspl	r15, r15, r15, ror r15
	orrspl	r0, r0, r0, rrx

positive: orrsvs instruction

	orrsvs	r0, r0, 0
	orrsvs	r15, r15, 0xff000000
	orrsvs	r0, r0, r0
	orrsvs	r15, r15, r15
	orrsvs	r0, r0, r0, lsl 0
	orrsvs	r15, r15, r15, lsl 31
	orrsvs	r0, r0, r0, lsl r0
	orrsvs	r15, r15, r15, lsl r15
	orrsvs	r0, r0, r0, lsr 1
	orrsvs	r15, r15, r15, lsr 32
	orrsvs	r0, r0, r0, lsr r0
	orrsvs	r15, r15, r15, asr r15
	orrsvs	r0, r0, r0, asr 1
	orrsvs	r15, r15, r15, asr 32
	orrsvs	r0, r0, r0, asr r0
	orrsvs	r15, r15, r15, asr r15
	orrsvs	r0, r0, r0, ror 1
	orrsvs	r15, r15, r15, ror 31
	orrsvs	r0, r0, r0, ror r0
	orrsvs	r15, r15, r15, ror r15
	orrsvs	r0, r0, r0, rrx

positive: orrsvc instruction

	orrsvc	r0, r0, 0
	orrsvc	r15, r15, 0xff000000
	orrsvc	r0, r0, r0
	orrsvc	r15, r15, r15
	orrsvc	r0, r0, r0, lsl 0
	orrsvc	r15, r15, r15, lsl 31
	orrsvc	r0, r0, r0, lsl r0
	orrsvc	r15, r15, r15, lsl r15
	orrsvc	r0, r0, r0, lsr 1
	orrsvc	r15, r15, r15, lsr 32
	orrsvc	r0, r0, r0, lsr r0
	orrsvc	r15, r15, r15, asr r15
	orrsvc	r0, r0, r0, asr 1
	orrsvc	r15, r15, r15, asr 32
	orrsvc	r0, r0, r0, asr r0
	orrsvc	r15, r15, r15, asr r15
	orrsvc	r0, r0, r0, ror 1
	orrsvc	r15, r15, r15, ror 31
	orrsvc	r0, r0, r0, ror r0
	orrsvc	r15, r15, r15, ror r15
	orrsvc	r0, r0, r0, rrx

positive: orrshi instruction

	orrshi	r0, r0, 0
	orrshi	r15, r15, 0xff000000
	orrshi	r0, r0, r0
	orrshi	r15, r15, r15
	orrshi	r0, r0, r0, lsl 0
	orrshi	r15, r15, r15, lsl 31
	orrshi	r0, r0, r0, lsl r0
	orrshi	r15, r15, r15, lsl r15
	orrshi	r0, r0, r0, lsr 1
	orrshi	r15, r15, r15, lsr 32
	orrshi	r0, r0, r0, lsr r0
	orrshi	r15, r15, r15, asr r15
	orrshi	r0, r0, r0, asr 1
	orrshi	r15, r15, r15, asr 32
	orrshi	r0, r0, r0, asr r0
	orrshi	r15, r15, r15, asr r15
	orrshi	r0, r0, r0, ror 1
	orrshi	r15, r15, r15, ror 31
	orrshi	r0, r0, r0, ror r0
	orrshi	r15, r15, r15, ror r15
	orrshi	r0, r0, r0, rrx

positive: orrsls instruction

	orrsls	r0, r0, 0
	orrsls	r15, r15, 0xff000000
	orrsls	r0, r0, r0
	orrsls	r15, r15, r15
	orrsls	r0, r0, r0, lsl 0
	orrsls	r15, r15, r15, lsl 31
	orrsls	r0, r0, r0, lsl r0
	orrsls	r15, r15, r15, lsl r15
	orrsls	r0, r0, r0, lsr 1
	orrsls	r15, r15, r15, lsr 32
	orrsls	r0, r0, r0, lsr r0
	orrsls	r15, r15, r15, asr r15
	orrsls	r0, r0, r0, asr 1
	orrsls	r15, r15, r15, asr 32
	orrsls	r0, r0, r0, asr r0
	orrsls	r15, r15, r15, asr r15
	orrsls	r0, r0, r0, ror 1
	orrsls	r15, r15, r15, ror 31
	orrsls	r0, r0, r0, ror r0
	orrsls	r15, r15, r15, ror r15
	orrsls	r0, r0, r0, rrx

positive: orrsge instruction

	orrsge	r0, r0, 0
	orrsge	r15, r15, 0xff000000
	orrsge	r0, r0, r0
	orrsge	r15, r15, r15
	orrsge	r0, r0, r0, lsl 0
	orrsge	r15, r15, r15, lsl 31
	orrsge	r0, r0, r0, lsl r0
	orrsge	r15, r15, r15, lsl r15
	orrsge	r0, r0, r0, lsr 1
	orrsge	r15, r15, r15, lsr 32
	orrsge	r0, r0, r0, lsr r0
	orrsge	r15, r15, r15, asr r15
	orrsge	r0, r0, r0, asr 1
	orrsge	r15, r15, r15, asr 32
	orrsge	r0, r0, r0, asr r0
	orrsge	r15, r15, r15, asr r15
	orrsge	r0, r0, r0, ror 1
	orrsge	r15, r15, r15, ror 31
	orrsge	r0, r0, r0, ror r0
	orrsge	r15, r15, r15, ror r15
	orrsge	r0, r0, r0, rrx

positive: orrslt instruction

	orrslt	r0, r0, 0
	orrslt	r15, r15, 0xff000000
	orrslt	r0, r0, r0
	orrslt	r15, r15, r15
	orrslt	r0, r0, r0, lsl 0
	orrslt	r15, r15, r15, lsl 31
	orrslt	r0, r0, r0, lsl r0
	orrslt	r15, r15, r15, lsl r15
	orrslt	r0, r0, r0, lsr 1
	orrslt	r15, r15, r15, lsr 32
	orrslt	r0, r0, r0, lsr r0
	orrslt	r15, r15, r15, asr r15
	orrslt	r0, r0, r0, asr 1
	orrslt	r15, r15, r15, asr 32
	orrslt	r0, r0, r0, asr r0
	orrslt	r15, r15, r15, asr r15
	orrslt	r0, r0, r0, ror 1
	orrslt	r15, r15, r15, ror 31
	orrslt	r0, r0, r0, ror r0
	orrslt	r15, r15, r15, ror r15
	orrslt	r0, r0, r0, rrx

positive: orrsgt instruction

	orrsgt	r0, r0, 0
	orrsgt	r15, r15, 0xff000000
	orrsgt	r0, r0, r0
	orrsgt	r15, r15, r15
	orrsgt	r0, r0, r0, lsl 0
	orrsgt	r15, r15, r15, lsl 31
	orrsgt	r0, r0, r0, lsl r0
	orrsgt	r15, r15, r15, lsl r15
	orrsgt	r0, r0, r0, lsr 1
	orrsgt	r15, r15, r15, lsr 32
	orrsgt	r0, r0, r0, lsr r0
	orrsgt	r15, r15, r15, asr r15
	orrsgt	r0, r0, r0, asr 1
	orrsgt	r15, r15, r15, asr 32
	orrsgt	r0, r0, r0, asr r0
	orrsgt	r15, r15, r15, asr r15
	orrsgt	r0, r0, r0, ror 1
	orrsgt	r15, r15, r15, ror 31
	orrsgt	r0, r0, r0, ror r0
	orrsgt	r15, r15, r15, ror r15
	orrsgt	r0, r0, r0, rrx

positive: orrsle instruction

	orrsle	r0, r0, 0
	orrsle	r15, r15, 0xff000000
	orrsle	r0, r0, r0
	orrsle	r15, r15, r15
	orrsle	r0, r0, r0, lsl 0
	orrsle	r15, r15, r15, lsl 31
	orrsle	r0, r0, r0, lsl r0
	orrsle	r15, r15, r15, lsl r15
	orrsle	r0, r0, r0, lsr 1
	orrsle	r15, r15, r15, lsr 32
	orrsle	r0, r0, r0, lsr r0
	orrsle	r15, r15, r15, asr r15
	orrsle	r0, r0, r0, asr 1
	orrsle	r15, r15, r15, asr 32
	orrsle	r0, r0, r0, asr r0
	orrsle	r15, r15, r15, asr r15
	orrsle	r0, r0, r0, ror 1
	orrsle	r15, r15, r15, ror 31
	orrsle	r0, r0, r0, ror r0
	orrsle	r15, r15, r15, ror r15
	orrsle	r0, r0, r0, rrx

positive: orrsal instruction

	orrsal	r0, r0, 0
	orrsal	r15, r15, 0xff000000
	orrsal	r0, r0, r0
	orrsal	r15, r15, r15
	orrsal	r0, r0, r0, lsl 0
	orrsal	r15, r15, r15, lsl 31
	orrsal	r0, r0, r0, lsl r0
	orrsal	r15, r15, r15, lsl r15
	orrsal	r0, r0, r0, lsr 1
	orrsal	r15, r15, r15, lsr 32
	orrsal	r0, r0, r0, lsr r0
	orrsal	r15, r15, r15, asr r15
	orrsal	r0, r0, r0, asr 1
	orrsal	r15, r15, r15, asr 32
	orrsal	r0, r0, r0, asr r0
	orrsal	r15, r15, r15, asr r15
	orrsal	r0, r0, r0, ror 1
	orrsal	r15, r15, r15, ror 31
	orrsal	r0, r0, r0, ror r0
	orrsal	r15, r15, r15, ror r15
	orrsal	r0, r0, r0, rrx

positive: pld instruction

	pld	[r0, -4095]
	pld	[r15, +4095]
	pld	[r0, -r0]
	pld	[r15, +r15]
	pld	[r0, r1, lsl 0]
	pld	[r15, r15, lsl 31]
	pld	[r0, r1, lsr 1]
	pld	[r15, r15, lsr 32]
	pld	[r0, r1, asr 1]
	pld	[r15, r15, asr 32]
	pld	[r0, r1, ror 1]
	pld	[r15, r15, ror 31]
	pld	[r0, r1, rrx]
	pld	[r15, r15, rrx]

positive: qadd instruction

	qadd	r0, r0, r0
	qadd	r15, r15, r15

positive: qaddeq instruction

	qaddeq	r0, r0, r0
	qaddeq	r15, r15, r15

positive: qaddne instruction

	qaddne	r0, r0, r0
	qaddne	r15, r15, r15

positive: qaddcs instruction

	qaddcs	r0, r0, r0
	qaddcs	r15, r15, r15

positive: qaddhs instruction

	qaddhs	r0, r0, r0
	qaddhs	r15, r15, r15

positive: qaddcc instruction

	qaddcc	r0, r0, r0
	qaddcc	r15, r15, r15

positive: qaddlo instruction

	qaddlo	r0, r0, r0
	qaddlo	r15, r15, r15

positive: qaddmi instruction

	qaddmi	r0, r0, r0
	qaddmi	r15, r15, r15

positive: qaddpl instruction

	qaddpl	r0, r0, r0
	qaddpl	r15, r15, r15

positive: qaddvs instruction

	qaddvs	r0, r0, r0
	qaddvs	r15, r15, r15

positive: qaddvc instruction

	qaddvc	r0, r0, r0
	qaddvc	r15, r15, r15

positive: qaddhi instruction

	qaddhi	r0, r0, r0
	qaddhi	r15, r15, r15

positive: qaddls instruction

	qaddls	r0, r0, r0
	qaddls	r15, r15, r15

positive: qaddge instruction

	qaddge	r0, r0, r0
	qaddge	r15, r15, r15

positive: qaddlt instruction

	qaddlt	r0, r0, r0
	qaddlt	r15, r15, r15

positive: qaddgt instruction

	qaddgt	r0, r0, r0
	qaddgt	r15, r15, r15

positive: qaddle instruction

	qaddle	r0, r0, r0
	qaddle	r15, r15, r15

positive: qaddal instruction

	qaddal	r0, r0, r0
	qaddal	r15, r15, r15

positive: qadd16 instruction

	qadd16	r0, r0, r0
	qadd16	r15, r15, r15

positive: qadd16eq instruction

	qadd16eq	r0, r0, r0
	qadd16eq	r15, r15, r15

positive: qadd16ne instruction

	qadd16ne	r0, r0, r0
	qadd16ne	r15, r15, r15

positive: qadd16cs instruction

	qadd16cs	r0, r0, r0
	qadd16cs	r15, r15, r15

positive: qadd16hs instruction

	qadd16hs	r0, r0, r0
	qadd16hs	r15, r15, r15

positive: qadd16cc instruction

	qadd16cc	r0, r0, r0
	qadd16cc	r15, r15, r15

positive: qadd16lo instruction

	qadd16lo	r0, r0, r0
	qadd16lo	r15, r15, r15

positive: qadd16mi instruction

	qadd16mi	r0, r0, r0
	qadd16mi	r15, r15, r15

positive: qadd16pl instruction

	qadd16pl	r0, r0, r0
	qadd16pl	r15, r15, r15

positive: qadd16vs instruction

	qadd16vs	r0, r0, r0
	qadd16vs	r15, r15, r15

positive: qadd16vc instruction

	qadd16vc	r0, r0, r0
	qadd16vc	r15, r15, r15

positive: qadd16hi instruction

	qadd16hi	r0, r0, r0
	qadd16hi	r15, r15, r15

positive: qadd16ls instruction

	qadd16ls	r0, r0, r0
	qadd16ls	r15, r15, r15

positive: qadd16ge instruction

	qadd16ge	r0, r0, r0
	qadd16ge	r15, r15, r15

positive: qadd16lt instruction

	qadd16lt	r0, r0, r0
	qadd16lt	r15, r15, r15

positive: qadd16gt instruction

	qadd16gt	r0, r0, r0
	qadd16gt	r15, r15, r15

positive: qadd16le instruction

	qadd16le	r0, r0, r0
	qadd16le	r15, r15, r15

positive: qadd16al instruction

	qadd16al	r0, r0, r0
	qadd16al	r15, r15, r15

positive: qadd8 instruction

	qadd8	r0, r0, r0
	qadd8	r15, r15, r15

positive: qadd8eq instruction

	qadd8eq	r0, r0, r0
	qadd8eq	r15, r15, r15

positive: qadd8ne instruction

	qadd8ne	r0, r0, r0
	qadd8ne	r15, r15, r15

positive: qadd8cs instruction

	qadd8cs	r0, r0, r0
	qadd8cs	r15, r15, r15

positive: qadd8hs instruction

	qadd8hs	r0, r0, r0
	qadd8hs	r15, r15, r15

positive: qadd8cc instruction

	qadd8cc	r0, r0, r0
	qadd8cc	r15, r15, r15

positive: qadd8lo instruction

	qadd8lo	r0, r0, r0
	qadd8lo	r15, r15, r15

positive: qadd8mi instruction

	qadd8mi	r0, r0, r0
	qadd8mi	r15, r15, r15

positive: qadd8pl instruction

	qadd8pl	r0, r0, r0
	qadd8pl	r15, r15, r15

positive: qadd8vs instruction

	qadd8vs	r0, r0, r0
	qadd8vs	r15, r15, r15

positive: qadd8vc instruction

	qadd8vc	r0, r0, r0
	qadd8vc	r15, r15, r15

positive: qadd8hi instruction

	qadd8hi	r0, r0, r0
	qadd8hi	r15, r15, r15

positive: qadd8ls instruction

	qadd8ls	r0, r0, r0
	qadd8ls	r15, r15, r15

positive: qadd8ge instruction

	qadd8ge	r0, r0, r0
	qadd8ge	r15, r15, r15

positive: qadd8lt instruction

	qadd8lt	r0, r0, r0
	qadd8lt	r15, r15, r15

positive: qadd8gt instruction

	qadd8gt	r0, r0, r0
	qadd8gt	r15, r15, r15

positive: qadd8le instruction

	qadd8le	r0, r0, r0
	qadd8le	r15, r15, r15

positive: qadd8al instruction

	qadd8al	r0, r0, r0
	qadd8al	r15, r15, r15

positive: qaddsubx instruction

	qaddsubx	r0, r0, r0
	qaddsubx	r15, r15, r15

positive: qaddsubxeq instruction

	qaddsubxeq	r0, r0, r0
	qaddsubxeq	r15, r15, r15

positive: qaddsubxne instruction

	qaddsubxne	r0, r0, r0
	qaddsubxne	r15, r15, r15

positive: qaddsubxcs instruction

	qaddsubxcs	r0, r0, r0
	qaddsubxcs	r15, r15, r15

positive: qaddsubxhs instruction

	qaddsubxhs	r0, r0, r0
	qaddsubxhs	r15, r15, r15

positive: qaddsubxcc instruction

	qaddsubxcc	r0, r0, r0
	qaddsubxcc	r15, r15, r15

positive: qaddsubxlo instruction

	qaddsubxlo	r0, r0, r0
	qaddsubxlo	r15, r15, r15

positive: qaddsubxmi instruction

	qaddsubxmi	r0, r0, r0
	qaddsubxmi	r15, r15, r15

positive: qaddsubxpl instruction

	qaddsubxpl	r0, r0, r0
	qaddsubxpl	r15, r15, r15

positive: qaddsubxvs instruction

	qaddsubxvs	r0, r0, r0
	qaddsubxvs	r15, r15, r15

positive: qaddsubxvc instruction

	qaddsubxvc	r0, r0, r0
	qaddsubxvc	r15, r15, r15

positive: qaddsubxhi instruction

	qaddsubxhi	r0, r0, r0
	qaddsubxhi	r15, r15, r15

positive: qaddsubxls instruction

	qaddsubxls	r0, r0, r0
	qaddsubxls	r15, r15, r15

positive: qaddsubxge instruction

	qaddsubxge	r0, r0, r0
	qaddsubxge	r15, r15, r15

positive: qaddsubxlt instruction

	qaddsubxlt	r0, r0, r0
	qaddsubxlt	r15, r15, r15

positive: qaddsubxgt instruction

	qaddsubxgt	r0, r0, r0
	qaddsubxgt	r15, r15, r15

positive: qaddsubxle instruction

	qaddsubxle	r0, r0, r0
	qaddsubxle	r15, r15, r15

positive: qaddsubxal instruction

	qaddsubxal	r0, r0, r0
	qaddsubxal	r15, r15, r15

positive: qdadd instruction

	qdadd	r0, r0, r0
	qdadd	r15, r15, r15

positive: qdaddeq instruction

	qdaddeq	r0, r0, r0
	qdaddeq	r15, r15, r15

positive: qdaddne instruction

	qdaddne	r0, r0, r0
	qdaddne	r15, r15, r15

positive: qdaddcs instruction

	qdaddcs	r0, r0, r0
	qdaddcs	r15, r15, r15

positive: qdaddhs instruction

	qdaddhs	r0, r0, r0
	qdaddhs	r15, r15, r15

positive: qdaddcc instruction

	qdaddcc	r0, r0, r0
	qdaddcc	r15, r15, r15

positive: qdaddlo instruction

	qdaddlo	r0, r0, r0
	qdaddlo	r15, r15, r15

positive: qdaddmi instruction

	qdaddmi	r0, r0, r0
	qdaddmi	r15, r15, r15

positive: qdaddpl instruction

	qdaddpl	r0, r0, r0
	qdaddpl	r15, r15, r15

positive: qdaddvs instruction

	qdaddvs	r0, r0, r0
	qdaddvs	r15, r15, r15

positive: qdaddvc instruction

	qdaddvc	r0, r0, r0
	qdaddvc	r15, r15, r15

positive: qdaddhi instruction

	qdaddhi	r0, r0, r0
	qdaddhi	r15, r15, r15

positive: qdaddls instruction

	qdaddls	r0, r0, r0
	qdaddls	r15, r15, r15

positive: qdaddge instruction

	qdaddge	r0, r0, r0
	qdaddge	r15, r15, r15

positive: qdaddlt instruction

	qdaddlt	r0, r0, r0
	qdaddlt	r15, r15, r15

positive: qdaddgt instruction

	qdaddgt	r0, r0, r0
	qdaddgt	r15, r15, r15

positive: qdaddle instruction

	qdaddle	r0, r0, r0
	qdaddle	r15, r15, r15

positive: qdaddal instruction

	qdaddal	r0, r0, r0
	qdaddal	r15, r15, r15

positive: qdsub instruction

	qdsub	r0, r0, r0
	qdsub	r15, r15, r15

positive: qdsubeq instruction

	qdsubeq	r0, r0, r0
	qdsubeq	r15, r15, r15

positive: qdsubne instruction

	qdsubne	r0, r0, r0
	qdsubne	r15, r15, r15

positive: qdsubcs instruction

	qdsubcs	r0, r0, r0
	qdsubcs	r15, r15, r15

positive: qdsubhs instruction

	qdsubhs	r0, r0, r0
	qdsubhs	r15, r15, r15

positive: qdsubcc instruction

	qdsubcc	r0, r0, r0
	qdsubcc	r15, r15, r15

positive: qdsublo instruction

	qdsublo	r0, r0, r0
	qdsublo	r15, r15, r15

positive: qdsubmi instruction

	qdsubmi	r0, r0, r0
	qdsubmi	r15, r15, r15

positive: qdsubpl instruction

	qdsubpl	r0, r0, r0
	qdsubpl	r15, r15, r15

positive: qdsubvs instruction

	qdsubvs	r0, r0, r0
	qdsubvs	r15, r15, r15

positive: qdsubvc instruction

	qdsubvc	r0, r0, r0
	qdsubvc	r15, r15, r15

positive: qdsubhi instruction

	qdsubhi	r0, r0, r0
	qdsubhi	r15, r15, r15

positive: qdsubls instruction

	qdsubls	r0, r0, r0
	qdsubls	r15, r15, r15

positive: qdsubge instruction

	qdsubge	r0, r0, r0
	qdsubge	r15, r15, r15

positive: qdsublt instruction

	qdsublt	r0, r0, r0
	qdsublt	r15, r15, r15

positive: qdsubgt instruction

	qdsubgt	r0, r0, r0
	qdsubgt	r15, r15, r15

positive: qdsuble instruction

	qdsuble	r0, r0, r0
	qdsuble	r15, r15, r15

positive: qdsubal instruction

	qdsubal	r0, r0, r0
	qdsubal	r15, r15, r15

positive: qsub instruction

	qsub	r0, r0, r0
	qsub	r15, r15, r15

positive: qsubeq instruction

	qsubeq	r0, r0, r0
	qsubeq	r15, r15, r15

positive: qsubne instruction

	qsubne	r0, r0, r0
	qsubne	r15, r15, r15

positive: qsubcs instruction

	qsubcs	r0, r0, r0
	qsubcs	r15, r15, r15

positive: qsubhs instruction

	qsubhs	r0, r0, r0
	qsubhs	r15, r15, r15

positive: qsubcc instruction

	qsubcc	r0, r0, r0
	qsubcc	r15, r15, r15

positive: qsublo instruction

	qsublo	r0, r0, r0
	qsublo	r15, r15, r15

positive: qsubmi instruction

	qsubmi	r0, r0, r0
	qsubmi	r15, r15, r15

positive: qsubpl instruction

	qsubpl	r0, r0, r0
	qsubpl	r15, r15, r15

positive: qsubvs instruction

	qsubvs	r0, r0, r0
	qsubvs	r15, r15, r15

positive: qsubvc instruction

	qsubvc	r0, r0, r0
	qsubvc	r15, r15, r15

positive: qsubhi instruction

	qsubhi	r0, r0, r0
	qsubhi	r15, r15, r15

positive: qsubls instruction

	qsubls	r0, r0, r0
	qsubls	r15, r15, r15

positive: qsubge instruction

	qsubge	r0, r0, r0
	qsubge	r15, r15, r15

positive: qsublt instruction

	qsublt	r0, r0, r0
	qsublt	r15, r15, r15

positive: qsubgt instruction

	qsubgt	r0, r0, r0
	qsubgt	r15, r15, r15

positive: qsuble instruction

	qsuble	r0, r0, r0
	qsuble	r15, r15, r15

positive: qsubal instruction

	qsubal	r0, r0, r0
	qsubal	r15, r15, r15

positive: qsub16 instruction

	qsub16	r0, r0, r0
	qsub16	r15, r15, r15

positive: qsub16eq instruction

	qsub16eq	r0, r0, r0
	qsub16eq	r15, r15, r15

positive: qsub16ne instruction

	qsub16ne	r0, r0, r0
	qsub16ne	r15, r15, r15

positive: qsub16cs instruction

	qsub16cs	r0, r0, r0
	qsub16cs	r15, r15, r15

positive: qsub16hs instruction

	qsub16hs	r0, r0, r0
	qsub16hs	r15, r15, r15

positive: qsub16cc instruction

	qsub16cc	r0, r0, r0
	qsub16cc	r15, r15, r15

positive: qsub16lo instruction

	qsub16lo	r0, r0, r0
	qsub16lo	r15, r15, r15

positive: qsub16mi instruction

	qsub16mi	r0, r0, r0
	qsub16mi	r15, r15, r15

positive: qsub16pl instruction

	qsub16pl	r0, r0, r0
	qsub16pl	r15, r15, r15

positive: qsub16vs instruction

	qsub16vs	r0, r0, r0
	qsub16vs	r15, r15, r15

positive: qsub16vc instruction

	qsub16vc	r0, r0, r0
	qsub16vc	r15, r15, r15

positive: qsub16hi instruction

	qsub16hi	r0, r0, r0
	qsub16hi	r15, r15, r15

positive: qsub16ls instruction

	qsub16ls	r0, r0, r0
	qsub16ls	r15, r15, r15

positive: qsub16ge instruction

	qsub16ge	r0, r0, r0
	qsub16ge	r15, r15, r15

positive: qsub16lt instruction

	qsub16lt	r0, r0, r0
	qsub16lt	r15, r15, r15

positive: qsub16gt instruction

	qsub16gt	r0, r0, r0
	qsub16gt	r15, r15, r15

positive: qsub16le instruction

	qsub16le	r0, r0, r0
	qsub16le	r15, r15, r15

positive: qsub16al instruction

	qsub16al	r0, r0, r0
	qsub16al	r15, r15, r15

positive: qsub8 instruction

	qsub8	r0, r0, r0
	qsub8	r15, r15, r15

positive: qsub8eq instruction

	qsub8eq	r0, r0, r0
	qsub8eq	r15, r15, r15

positive: qsub8ne instruction

	qsub8ne	r0, r0, r0
	qsub8ne	r15, r15, r15

positive: qsub8cs instruction

	qsub8cs	r0, r0, r0
	qsub8cs	r15, r15, r15

positive: qsub8hs instruction

	qsub8hs	r0, r0, r0
	qsub8hs	r15, r15, r15

positive: qsub8cc instruction

	qsub8cc	r0, r0, r0
	qsub8cc	r15, r15, r15

positive: qsub8lo instruction

	qsub8lo	r0, r0, r0
	qsub8lo	r15, r15, r15

positive: qsub8mi instruction

	qsub8mi	r0, r0, r0
	qsub8mi	r15, r15, r15

positive: qsub8pl instruction

	qsub8pl	r0, r0, r0
	qsub8pl	r15, r15, r15

positive: qsub8vs instruction

	qsub8vs	r0, r0, r0
	qsub8vs	r15, r15, r15

positive: qsub8vc instruction

	qsub8vc	r0, r0, r0
	qsub8vc	r15, r15, r15

positive: qsub8hi instruction

	qsub8hi	r0, r0, r0
	qsub8hi	r15, r15, r15

positive: qsub8ls instruction

	qsub8ls	r0, r0, r0
	qsub8ls	r15, r15, r15

positive: qsub8ge instruction

	qsub8ge	r0, r0, r0
	qsub8ge	r15, r15, r15

positive: qsub8lt instruction

	qsub8lt	r0, r0, r0
	qsub8lt	r15, r15, r15

positive: qsub8gt instruction

	qsub8gt	r0, r0, r0
	qsub8gt	r15, r15, r15

positive: qsub8le instruction

	qsub8le	r0, r0, r0
	qsub8le	r15, r15, r15

positive: qsub8al instruction

	qsub8al	r0, r0, r0
	qsub8al	r15, r15, r15

positive: qsubaddx instruction

	qsubaddx	r0, r0, r0
	qsubaddx	r15, r15, r15

positive: qsubaddxeq instruction

	qsubaddxeq	r0, r0, r0
	qsubaddxeq	r15, r15, r15

positive: qsubaddxne instruction

	qsubaddxne	r0, r0, r0
	qsubaddxne	r15, r15, r15

positive: qsubaddxcs instruction

	qsubaddxcs	r0, r0, r0
	qsubaddxcs	r15, r15, r15

positive: qsubaddxhs instruction

	qsubaddxhs	r0, r0, r0
	qsubaddxhs	r15, r15, r15

positive: qsubaddxcc instruction

	qsubaddxcc	r0, r0, r0
	qsubaddxcc	r15, r15, r15

positive: qsubaddxlo instruction

	qsubaddxlo	r0, r0, r0
	qsubaddxlo	r15, r15, r15

positive: qsubaddxmi instruction

	qsubaddxmi	r0, r0, r0
	qsubaddxmi	r15, r15, r15

positive: qsubaddxpl instruction

	qsubaddxpl	r0, r0, r0
	qsubaddxpl	r15, r15, r15

positive: qsubaddxvs instruction

	qsubaddxvs	r0, r0, r0
	qsubaddxvs	r15, r15, r15

positive: qsubaddxvc instruction

	qsubaddxvc	r0, r0, r0
	qsubaddxvc	r15, r15, r15

positive: qsubaddxhi instruction

	qsubaddxhi	r0, r0, r0
	qsubaddxhi	r15, r15, r15

positive: qsubaddxls instruction

	qsubaddxls	r0, r0, r0
	qsubaddxls	r15, r15, r15

positive: qsubaddxge instruction

	qsubaddxge	r0, r0, r0
	qsubaddxge	r15, r15, r15

positive: qsubaddxlt instruction

	qsubaddxlt	r0, r0, r0
	qsubaddxlt	r15, r15, r15

positive: qsubaddxgt instruction

	qsubaddxgt	r0, r0, r0
	qsubaddxgt	r15, r15, r15

positive: qsubaddxle instruction

	qsubaddxle	r0, r0, r0
	qsubaddxle	r15, r15, r15

positive: qsubaddxal instruction

	qsubaddxal	r0, r0, r0
	qsubaddxal	r15, r15, r15

positive: rev instruction

	rev	r0, r0
	rev	r15, r15

positive: reveq instruction

	reveq	r0, r0
	reveq	r15, r15

positive: revne instruction

	revne	r0, r0
	revne	r15, r15

positive: revcs instruction

	revcs	r0, r0
	revcs	r15, r15

positive: revhs instruction

	revhs	r0, r0
	revhs	r15, r15

positive: revcc instruction

	revcc	r0, r0
	revcc	r15, r15

positive: revlo instruction

	revlo	r0, r0
	revlo	r15, r15

positive: revmi instruction

	revmi	r0, r0
	revmi	r15, r15

positive: revpl instruction

	revpl	r0, r0
	revpl	r15, r15

positive: revvs instruction

	revvs	r0, r0
	revvs	r15, r15

positive: revvc instruction

	revvc	r0, r0
	revvc	r15, r15

positive: revhi instruction

	revhi	r0, r0
	revhi	r15, r15

positive: revls instruction

	revls	r0, r0
	revls	r15, r15

positive: revge instruction

	revge	r0, r0
	revge	r15, r15

positive: revlt instruction

	revlt	r0, r0
	revlt	r15, r15

positive: revgt instruction

	revgt	r0, r0
	revgt	r15, r15

positive: revle instruction

	revle	r0, r0
	revle	r15, r15

positive: reval instruction

	reval	r0, r0
	reval	r15, r15

positive: rev16 instruction

	rev16	r0, r0
	rev16	r15, r15

positive: rev16eq instruction

	rev16eq	r0, r0
	rev16eq	r15, r15

positive: rev16ne instruction

	rev16ne	r0, r0
	rev16ne	r15, r15

positive: rev16cs instruction

	rev16cs	r0, r0
	rev16cs	r15, r15

positive: rev16hs instruction

	rev16hs	r0, r0
	rev16hs	r15, r15

positive: rev16cc instruction

	rev16cc	r0, r0
	rev16cc	r15, r15

positive: rev16lo instruction

	rev16lo	r0, r0
	rev16lo	r15, r15

positive: rev16mi instruction

	rev16mi	r0, r0
	rev16mi	r15, r15

positive: rev16pl instruction

	rev16pl	r0, r0
	rev16pl	r15, r15

positive: rev16vs instruction

	rev16vs	r0, r0
	rev16vs	r15, r15

positive: rev16vc instruction

	rev16vc	r0, r0
	rev16vc	r15, r15

positive: rev16hi instruction

	rev16hi	r0, r0
	rev16hi	r15, r15

positive: rev16ls instruction

	rev16ls	r0, r0
	rev16ls	r15, r15

positive: rev16ge instruction

	rev16ge	r0, r0
	rev16ge	r15, r15

positive: rev16lt instruction

	rev16lt	r0, r0
	rev16lt	r15, r15

positive: rev16gt instruction

	rev16gt	r0, r0
	rev16gt	r15, r15

positive: rev16le instruction

	rev16le	r0, r0
	rev16le	r15, r15

positive: rev16al instruction

	rev16al	r0, r0
	rev16al	r15, r15

positive: revsh instruction

	revsh	r0, r0
	revsh	r15, r15

positive: revsheq instruction

	revsheq	r0, r0
	revsheq	r15, r15

positive: revshne instruction

	revshne	r0, r0
	revshne	r15, r15

positive: revshcs instruction

	revshcs	r0, r0
	revshcs	r15, r15

positive: revshhs instruction

	revshhs	r0, r0
	revshhs	r15, r15

positive: revshcc instruction

	revshcc	r0, r0
	revshcc	r15, r15

positive: revshlo instruction

	revshlo	r0, r0
	revshlo	r15, r15

positive: revshmi instruction

	revshmi	r0, r0
	revshmi	r15, r15

positive: revshpl instruction

	revshpl	r0, r0
	revshpl	r15, r15

positive: revshvs instruction

	revshvs	r0, r0
	revshvs	r15, r15

positive: revshvc instruction

	revshvc	r0, r0
	revshvc	r15, r15

positive: revshhi instruction

	revshhi	r0, r0
	revshhi	r15, r15

positive: revshls instruction

	revshls	r0, r0
	revshls	r15, r15

positive: revshge instruction

	revshge	r0, r0
	revshge	r15, r15

positive: revshlt instruction

	revshlt	r0, r0
	revshlt	r15, r15

positive: revshgt instruction

	revshgt	r0, r0
	revshgt	r15, r15

positive: revshle instruction

	revshle	r0, r0
	revshle	r15, r15

positive: revshal instruction

	revshal	r0, r0
	revshal	r15, r15

positive: rfeia instruction

	rfeia	r0
	rfeia	r15
	rfeia	r0 !
	rfeia	r15 !

positive: rfeib instruction

	rfeib	r0
	rfeib	r15
	rfeib	r0 !
	rfeib	r15 !

positive: rfeda instruction

	rfeda	r0
	rfeda	r15
	rfeda	r0 !
	rfeda	r15 !

positive: rfedb instruction

	rfedb	r0
	rfedb	r15
	rfedb	r0 !
	rfedb	r15 !

positive: rsb instruction

	rsb	r0, r0, 0
	rsb	r15, r15, 0xff000000
	rsb	r0, r0, r0
	rsb	r15, r15, r15
	rsb	r0, r0, r0, lsl 0
	rsb	r15, r15, r15, lsl 31
	rsb	r0, r0, r0, lsl r0
	rsb	r15, r15, r15, lsl r15
	rsb	r0, r0, r0, lsr 1
	rsb	r15, r15, r15, lsr 32
	rsb	r0, r0, r0, lsr r0
	rsb	r15, r15, r15, asr r15
	rsb	r0, r0, r0, asr 1
	rsb	r15, r15, r15, asr 32
	rsb	r0, r0, r0, asr r0
	rsb	r15, r15, r15, asr r15
	rsb	r0, r0, r0, ror 1
	rsb	r15, r15, r15, ror 31
	rsb	r0, r0, r0, ror r0
	rsb	r15, r15, r15, ror r15
	rsb	r0, r0, r0, rrx

positive: rsbeq instruction

	rsbeq	r0, r0, 0
	rsbeq	r15, r15, 0xff000000
	rsbeq	r0, r0, r0
	rsbeq	r15, r15, r15
	rsbeq	r0, r0, r0, lsl 0
	rsbeq	r15, r15, r15, lsl 31
	rsbeq	r0, r0, r0, lsl r0
	rsbeq	r15, r15, r15, lsl r15
	rsbeq	r0, r0, r0, lsr 1
	rsbeq	r15, r15, r15, lsr 32
	rsbeq	r0, r0, r0, lsr r0
	rsbeq	r15, r15, r15, asr r15
	rsbeq	r0, r0, r0, asr 1
	rsbeq	r15, r15, r15, asr 32
	rsbeq	r0, r0, r0, asr r0
	rsbeq	r15, r15, r15, asr r15
	rsbeq	r0, r0, r0, ror 1
	rsbeq	r15, r15, r15, ror 31
	rsbeq	r0, r0, r0, ror r0
	rsbeq	r15, r15, r15, ror r15
	rsbeq	r0, r0, r0, rrx

positive: rsbne instruction

	rsbne	r0, r0, 0
	rsbne	r15, r15, 0xff000000
	rsbne	r0, r0, r0
	rsbne	r15, r15, r15
	rsbne	r0, r0, r0, lsl 0
	rsbne	r15, r15, r15, lsl 31
	rsbne	r0, r0, r0, lsl r0
	rsbne	r15, r15, r15, lsl r15
	rsbne	r0, r0, r0, lsr 1
	rsbne	r15, r15, r15, lsr 32
	rsbne	r0, r0, r0, lsr r0
	rsbne	r15, r15, r15, asr r15
	rsbne	r0, r0, r0, asr 1
	rsbne	r15, r15, r15, asr 32
	rsbne	r0, r0, r0, asr r0
	rsbne	r15, r15, r15, asr r15
	rsbne	r0, r0, r0, ror 1
	rsbne	r15, r15, r15, ror 31
	rsbne	r0, r0, r0, ror r0
	rsbne	r15, r15, r15, ror r15
	rsbne	r0, r0, r0, rrx

positive: rsbcs instruction

	rsbcs	r0, r0, 0
	rsbcs	r15, r15, 0xff000000
	rsbcs	r0, r0, r0
	rsbcs	r15, r15, r15
	rsbcs	r0, r0, r0, lsl 0
	rsbcs	r15, r15, r15, lsl 31
	rsbcs	r0, r0, r0, lsl r0
	rsbcs	r15, r15, r15, lsl r15
	rsbcs	r0, r0, r0, lsr 1
	rsbcs	r15, r15, r15, lsr 32
	rsbcs	r0, r0, r0, lsr r0
	rsbcs	r15, r15, r15, asr r15
	rsbcs	r0, r0, r0, asr 1
	rsbcs	r15, r15, r15, asr 32
	rsbcs	r0, r0, r0, asr r0
	rsbcs	r15, r15, r15, asr r15
	rsbcs	r0, r0, r0, ror 1
	rsbcs	r15, r15, r15, ror 31
	rsbcs	r0, r0, r0, ror r0
	rsbcs	r15, r15, r15, ror r15
	rsbcs	r0, r0, r0, rrx

positive: rsbhs instruction

	rsbhs	r0, r0, 0
	rsbhs	r15, r15, 0xff000000
	rsbhs	r0, r0, r0
	rsbhs	r15, r15, r15
	rsbhs	r0, r0, r0, lsl 0
	rsbhs	r15, r15, r15, lsl 31
	rsbhs	r0, r0, r0, lsl r0
	rsbhs	r15, r15, r15, lsl r15
	rsbhs	r0, r0, r0, lsr 1
	rsbhs	r15, r15, r15, lsr 32
	rsbhs	r0, r0, r0, lsr r0
	rsbhs	r15, r15, r15, asr r15
	rsbhs	r0, r0, r0, asr 1
	rsbhs	r15, r15, r15, asr 32
	rsbhs	r0, r0, r0, asr r0
	rsbhs	r15, r15, r15, asr r15
	rsbhs	r0, r0, r0, ror 1
	rsbhs	r15, r15, r15, ror 31
	rsbhs	r0, r0, r0, ror r0
	rsbhs	r15, r15, r15, ror r15
	rsbhs	r0, r0, r0, rrx

positive: rsbcc instruction

	rsbcc	r0, r0, 0
	rsbcc	r15, r15, 0xff000000
	rsbcc	r0, r0, r0
	rsbcc	r15, r15, r15
	rsbcc	r0, r0, r0, lsl 0
	rsbcc	r15, r15, r15, lsl 31
	rsbcc	r0, r0, r0, lsl r0
	rsbcc	r15, r15, r15, lsl r15
	rsbcc	r0, r0, r0, lsr 1
	rsbcc	r15, r15, r15, lsr 32
	rsbcc	r0, r0, r0, lsr r0
	rsbcc	r15, r15, r15, asr r15
	rsbcc	r0, r0, r0, asr 1
	rsbcc	r15, r15, r15, asr 32
	rsbcc	r0, r0, r0, asr r0
	rsbcc	r15, r15, r15, asr r15
	rsbcc	r0, r0, r0, ror 1
	rsbcc	r15, r15, r15, ror 31
	rsbcc	r0, r0, r0, ror r0
	rsbcc	r15, r15, r15, ror r15
	rsbcc	r0, r0, r0, rrx

positive: rsblo instruction

	rsblo	r0, r0, 0
	rsblo	r15, r15, 0xff000000
	rsblo	r0, r0, r0
	rsblo	r15, r15, r15
	rsblo	r0, r0, r0, lsl 0
	rsblo	r15, r15, r15, lsl 31
	rsblo	r0, r0, r0, lsl r0
	rsblo	r15, r15, r15, lsl r15
	rsblo	r0, r0, r0, lsr 1
	rsblo	r15, r15, r15, lsr 32
	rsblo	r0, r0, r0, lsr r0
	rsblo	r15, r15, r15, asr r15
	rsblo	r0, r0, r0, asr 1
	rsblo	r15, r15, r15, asr 32
	rsblo	r0, r0, r0, asr r0
	rsblo	r15, r15, r15, asr r15
	rsblo	r0, r0, r0, ror 1
	rsblo	r15, r15, r15, ror 31
	rsblo	r0, r0, r0, ror r0
	rsblo	r15, r15, r15, ror r15
	rsblo	r0, r0, r0, rrx

positive: rsbmi instruction

	rsbmi	r0, r0, 0
	rsbmi	r15, r15, 0xff000000
	rsbmi	r0, r0, r0
	rsbmi	r15, r15, r15
	rsbmi	r0, r0, r0, lsl 0
	rsbmi	r15, r15, r15, lsl 31
	rsbmi	r0, r0, r0, lsl r0
	rsbmi	r15, r15, r15, lsl r15
	rsbmi	r0, r0, r0, lsr 1
	rsbmi	r15, r15, r15, lsr 32
	rsbmi	r0, r0, r0, lsr r0
	rsbmi	r15, r15, r15, asr r15
	rsbmi	r0, r0, r0, asr 1
	rsbmi	r15, r15, r15, asr 32
	rsbmi	r0, r0, r0, asr r0
	rsbmi	r15, r15, r15, asr r15
	rsbmi	r0, r0, r0, ror 1
	rsbmi	r15, r15, r15, ror 31
	rsbmi	r0, r0, r0, ror r0
	rsbmi	r15, r15, r15, ror r15
	rsbmi	r0, r0, r0, rrx

positive: rsbpl instruction

	rsbpl	r0, r0, 0
	rsbpl	r15, r15, 0xff000000
	rsbpl	r0, r0, r0
	rsbpl	r15, r15, r15
	rsbpl	r0, r0, r0, lsl 0
	rsbpl	r15, r15, r15, lsl 31
	rsbpl	r0, r0, r0, lsl r0
	rsbpl	r15, r15, r15, lsl r15
	rsbpl	r0, r0, r0, lsr 1
	rsbpl	r15, r15, r15, lsr 32
	rsbpl	r0, r0, r0, lsr r0
	rsbpl	r15, r15, r15, asr r15
	rsbpl	r0, r0, r0, asr 1
	rsbpl	r15, r15, r15, asr 32
	rsbpl	r0, r0, r0, asr r0
	rsbpl	r15, r15, r15, asr r15
	rsbpl	r0, r0, r0, ror 1
	rsbpl	r15, r15, r15, ror 31
	rsbpl	r0, r0, r0, ror r0
	rsbpl	r15, r15, r15, ror r15
	rsbpl	r0, r0, r0, rrx

positive: rsbvs instruction

	rsbvs	r0, r0, 0
	rsbvs	r15, r15, 0xff000000
	rsbvs	r0, r0, r0
	rsbvs	r15, r15, r15
	rsbvs	r0, r0, r0, lsl 0
	rsbvs	r15, r15, r15, lsl 31
	rsbvs	r0, r0, r0, lsl r0
	rsbvs	r15, r15, r15, lsl r15
	rsbvs	r0, r0, r0, lsr 1
	rsbvs	r15, r15, r15, lsr 32
	rsbvs	r0, r0, r0, lsr r0
	rsbvs	r15, r15, r15, asr r15
	rsbvs	r0, r0, r0, asr 1
	rsbvs	r15, r15, r15, asr 32
	rsbvs	r0, r0, r0, asr r0
	rsbvs	r15, r15, r15, asr r15
	rsbvs	r0, r0, r0, ror 1
	rsbvs	r15, r15, r15, ror 31
	rsbvs	r0, r0, r0, ror r0
	rsbvs	r15, r15, r15, ror r15
	rsbvs	r0, r0, r0, rrx

positive: rsbvc instruction

	rsbvc	r0, r0, 0
	rsbvc	r15, r15, 0xff000000
	rsbvc	r0, r0, r0
	rsbvc	r15, r15, r15
	rsbvc	r0, r0, r0, lsl 0
	rsbvc	r15, r15, r15, lsl 31
	rsbvc	r0, r0, r0, lsl r0
	rsbvc	r15, r15, r15, lsl r15
	rsbvc	r0, r0, r0, lsr 1
	rsbvc	r15, r15, r15, lsr 32
	rsbvc	r0, r0, r0, lsr r0
	rsbvc	r15, r15, r15, asr r15
	rsbvc	r0, r0, r0, asr 1
	rsbvc	r15, r15, r15, asr 32
	rsbvc	r0, r0, r0, asr r0
	rsbvc	r15, r15, r15, asr r15
	rsbvc	r0, r0, r0, ror 1
	rsbvc	r15, r15, r15, ror 31
	rsbvc	r0, r0, r0, ror r0
	rsbvc	r15, r15, r15, ror r15
	rsbvc	r0, r0, r0, rrx

positive: rsbhi instruction

	rsbhi	r0, r0, 0
	rsbhi	r15, r15, 0xff000000
	rsbhi	r0, r0, r0
	rsbhi	r15, r15, r15
	rsbhi	r0, r0, r0, lsl 0
	rsbhi	r15, r15, r15, lsl 31
	rsbhi	r0, r0, r0, lsl r0
	rsbhi	r15, r15, r15, lsl r15
	rsbhi	r0, r0, r0, lsr 1
	rsbhi	r15, r15, r15, lsr 32
	rsbhi	r0, r0, r0, lsr r0
	rsbhi	r15, r15, r15, asr r15
	rsbhi	r0, r0, r0, asr 1
	rsbhi	r15, r15, r15, asr 32
	rsbhi	r0, r0, r0, asr r0
	rsbhi	r15, r15, r15, asr r15
	rsbhi	r0, r0, r0, ror 1
	rsbhi	r15, r15, r15, ror 31
	rsbhi	r0, r0, r0, ror r0
	rsbhi	r15, r15, r15, ror r15
	rsbhi	r0, r0, r0, rrx

positive: rsbls instruction

	rsbls	r0, r0, 0
	rsbls	r15, r15, 0xff000000
	rsbls	r0, r0, r0
	rsbls	r15, r15, r15
	rsbls	r0, r0, r0, lsl 0
	rsbls	r15, r15, r15, lsl 31
	rsbls	r0, r0, r0, lsl r0
	rsbls	r15, r15, r15, lsl r15
	rsbls	r0, r0, r0, lsr 1
	rsbls	r15, r15, r15, lsr 32
	rsbls	r0, r0, r0, lsr r0
	rsbls	r15, r15, r15, asr r15
	rsbls	r0, r0, r0, asr 1
	rsbls	r15, r15, r15, asr 32
	rsbls	r0, r0, r0, asr r0
	rsbls	r15, r15, r15, asr r15
	rsbls	r0, r0, r0, ror 1
	rsbls	r15, r15, r15, ror 31
	rsbls	r0, r0, r0, ror r0
	rsbls	r15, r15, r15, ror r15
	rsbls	r0, r0, r0, rrx

positive: rsbge instruction

	rsbge	r0, r0, 0
	rsbge	r15, r15, 0xff000000
	rsbge	r0, r0, r0
	rsbge	r15, r15, r15
	rsbge	r0, r0, r0, lsl 0
	rsbge	r15, r15, r15, lsl 31
	rsbge	r0, r0, r0, lsl r0
	rsbge	r15, r15, r15, lsl r15
	rsbge	r0, r0, r0, lsr 1
	rsbge	r15, r15, r15, lsr 32
	rsbge	r0, r0, r0, lsr r0
	rsbge	r15, r15, r15, asr r15
	rsbge	r0, r0, r0, asr 1
	rsbge	r15, r15, r15, asr 32
	rsbge	r0, r0, r0, asr r0
	rsbge	r15, r15, r15, asr r15
	rsbge	r0, r0, r0, ror 1
	rsbge	r15, r15, r15, ror 31
	rsbge	r0, r0, r0, ror r0
	rsbge	r15, r15, r15, ror r15
	rsbge	r0, r0, r0, rrx

positive: rsblt instruction

	rsblt	r0, r0, 0
	rsblt	r15, r15, 0xff000000
	rsblt	r0, r0, r0
	rsblt	r15, r15, r15
	rsblt	r0, r0, r0, lsl 0
	rsblt	r15, r15, r15, lsl 31
	rsblt	r0, r0, r0, lsl r0
	rsblt	r15, r15, r15, lsl r15
	rsblt	r0, r0, r0, lsr 1
	rsblt	r15, r15, r15, lsr 32
	rsblt	r0, r0, r0, lsr r0
	rsblt	r15, r15, r15, asr r15
	rsblt	r0, r0, r0, asr 1
	rsblt	r15, r15, r15, asr 32
	rsblt	r0, r0, r0, asr r0
	rsblt	r15, r15, r15, asr r15
	rsblt	r0, r0, r0, ror 1
	rsblt	r15, r15, r15, ror 31
	rsblt	r0, r0, r0, ror r0
	rsblt	r15, r15, r15, ror r15
	rsblt	r0, r0, r0, rrx

positive: rsbgt instruction

	rsbgt	r0, r0, 0
	rsbgt	r15, r15, 0xff000000
	rsbgt	r0, r0, r0
	rsbgt	r15, r15, r15
	rsbgt	r0, r0, r0, lsl 0
	rsbgt	r15, r15, r15, lsl 31
	rsbgt	r0, r0, r0, lsl r0
	rsbgt	r15, r15, r15, lsl r15
	rsbgt	r0, r0, r0, lsr 1
	rsbgt	r15, r15, r15, lsr 32
	rsbgt	r0, r0, r0, lsr r0
	rsbgt	r15, r15, r15, asr r15
	rsbgt	r0, r0, r0, asr 1
	rsbgt	r15, r15, r15, asr 32
	rsbgt	r0, r0, r0, asr r0
	rsbgt	r15, r15, r15, asr r15
	rsbgt	r0, r0, r0, ror 1
	rsbgt	r15, r15, r15, ror 31
	rsbgt	r0, r0, r0, ror r0
	rsbgt	r15, r15, r15, ror r15
	rsbgt	r0, r0, r0, rrx

positive: rsble instruction

	rsble	r0, r0, 0
	rsble	r15, r15, 0xff000000
	rsble	r0, r0, r0
	rsble	r15, r15, r15
	rsble	r0, r0, r0, lsl 0
	rsble	r15, r15, r15, lsl 31
	rsble	r0, r0, r0, lsl r0
	rsble	r15, r15, r15, lsl r15
	rsble	r0, r0, r0, lsr 1
	rsble	r15, r15, r15, lsr 32
	rsble	r0, r0, r0, lsr r0
	rsble	r15, r15, r15, asr r15
	rsble	r0, r0, r0, asr 1
	rsble	r15, r15, r15, asr 32
	rsble	r0, r0, r0, asr r0
	rsble	r15, r15, r15, asr r15
	rsble	r0, r0, r0, ror 1
	rsble	r15, r15, r15, ror 31
	rsble	r0, r0, r0, ror r0
	rsble	r15, r15, r15, ror r15
	rsble	r0, r0, r0, rrx

positive: rsbal instruction

	rsbal	r0, r0, 0
	rsbal	r15, r15, 0xff000000
	rsbal	r0, r0, r0
	rsbal	r15, r15, r15
	rsbal	r0, r0, r0, lsl 0
	rsbal	r15, r15, r15, lsl 31
	rsbal	r0, r0, r0, lsl r0
	rsbal	r15, r15, r15, lsl r15
	rsbal	r0, r0, r0, lsr 1
	rsbal	r15, r15, r15, lsr 32
	rsbal	r0, r0, r0, lsr r0
	rsbal	r15, r15, r15, asr r15
	rsbal	r0, r0, r0, asr 1
	rsbal	r15, r15, r15, asr 32
	rsbal	r0, r0, r0, asr r0
	rsbal	r15, r15, r15, asr r15
	rsbal	r0, r0, r0, ror 1
	rsbal	r15, r15, r15, ror 31
	rsbal	r0, r0, r0, ror r0
	rsbal	r15, r15, r15, ror r15
	rsbal	r0, r0, r0, rrx

positive: rsbs instruction

	rsbs	r0, r0, 0
	rsbs	r15, r15, 0xff000000
	rsbs	r0, r0, r0
	rsbs	r15, r15, r15
	rsbs	r0, r0, r0, lsl 0
	rsbs	r15, r15, r15, lsl 31
	rsbs	r0, r0, r0, lsl r0
	rsbs	r15, r15, r15, lsl r15
	rsbs	r0, r0, r0, lsr 1
	rsbs	r15, r15, r15, lsr 32
	rsbs	r0, r0, r0, lsr r0
	rsbs	r15, r15, r15, asr r15
	rsbs	r0, r0, r0, asr 1
	rsbs	r15, r15, r15, asr 32
	rsbs	r0, r0, r0, asr r0
	rsbs	r15, r15, r15, asr r15
	rsbs	r0, r0, r0, ror 1
	rsbs	r15, r15, r15, ror 31
	rsbs	r0, r0, r0, ror r0
	rsbs	r15, r15, r15, ror r15
	rsbs	r0, r0, r0, rrx

positive: rsbseq instruction

	rsbseq	r0, r0, 0
	rsbseq	r15, r15, 0xff000000
	rsbseq	r0, r0, r0
	rsbseq	r15, r15, r15
	rsbseq	r0, r0, r0, lsl 0
	rsbseq	r15, r15, r15, lsl 31
	rsbseq	r0, r0, r0, lsl r0
	rsbseq	r15, r15, r15, lsl r15
	rsbseq	r0, r0, r0, lsr 1
	rsbseq	r15, r15, r15, lsr 32
	rsbseq	r0, r0, r0, lsr r0
	rsbseq	r15, r15, r15, asr r15
	rsbseq	r0, r0, r0, asr 1
	rsbseq	r15, r15, r15, asr 32
	rsbseq	r0, r0, r0, asr r0
	rsbseq	r15, r15, r15, asr r15
	rsbseq	r0, r0, r0, ror 1
	rsbseq	r15, r15, r15, ror 31
	rsbseq	r0, r0, r0, ror r0
	rsbseq	r15, r15, r15, ror r15
	rsbseq	r0, r0, r0, rrx

positive: rsbsne instruction

	rsbsne	r0, r0, 0
	rsbsne	r15, r15, 0xff000000
	rsbsne	r0, r0, r0
	rsbsne	r15, r15, r15
	rsbsne	r0, r0, r0, lsl 0
	rsbsne	r15, r15, r15, lsl 31
	rsbsne	r0, r0, r0, lsl r0
	rsbsne	r15, r15, r15, lsl r15
	rsbsne	r0, r0, r0, lsr 1
	rsbsne	r15, r15, r15, lsr 32
	rsbsne	r0, r0, r0, lsr r0
	rsbsne	r15, r15, r15, asr r15
	rsbsne	r0, r0, r0, asr 1
	rsbsne	r15, r15, r15, asr 32
	rsbsne	r0, r0, r0, asr r0
	rsbsne	r15, r15, r15, asr r15
	rsbsne	r0, r0, r0, ror 1
	rsbsne	r15, r15, r15, ror 31
	rsbsne	r0, r0, r0, ror r0
	rsbsne	r15, r15, r15, ror r15
	rsbsne	r0, r0, r0, rrx

positive: rsbscs instruction

	rsbscs	r0, r0, 0
	rsbscs	r15, r15, 0xff000000
	rsbscs	r0, r0, r0
	rsbscs	r15, r15, r15
	rsbscs	r0, r0, r0, lsl 0
	rsbscs	r15, r15, r15, lsl 31
	rsbscs	r0, r0, r0, lsl r0
	rsbscs	r15, r15, r15, lsl r15
	rsbscs	r0, r0, r0, lsr 1
	rsbscs	r15, r15, r15, lsr 32
	rsbscs	r0, r0, r0, lsr r0
	rsbscs	r15, r15, r15, asr r15
	rsbscs	r0, r0, r0, asr 1
	rsbscs	r15, r15, r15, asr 32
	rsbscs	r0, r0, r0, asr r0
	rsbscs	r15, r15, r15, asr r15
	rsbscs	r0, r0, r0, ror 1
	rsbscs	r15, r15, r15, ror 31
	rsbscs	r0, r0, r0, ror r0
	rsbscs	r15, r15, r15, ror r15
	rsbscs	r0, r0, r0, rrx

positive: rsbshs instruction

	rsbshs	r0, r0, 0
	rsbshs	r15, r15, 0xff000000
	rsbshs	r0, r0, r0
	rsbshs	r15, r15, r15
	rsbshs	r0, r0, r0, lsl 0
	rsbshs	r15, r15, r15, lsl 31
	rsbshs	r0, r0, r0, lsl r0
	rsbshs	r15, r15, r15, lsl r15
	rsbshs	r0, r0, r0, lsr 1
	rsbshs	r15, r15, r15, lsr 32
	rsbshs	r0, r0, r0, lsr r0
	rsbshs	r15, r15, r15, asr r15
	rsbshs	r0, r0, r0, asr 1
	rsbshs	r15, r15, r15, asr 32
	rsbshs	r0, r0, r0, asr r0
	rsbshs	r15, r15, r15, asr r15
	rsbshs	r0, r0, r0, ror 1
	rsbshs	r15, r15, r15, ror 31
	rsbshs	r0, r0, r0, ror r0
	rsbshs	r15, r15, r15, ror r15
	rsbshs	r0, r0, r0, rrx

positive: rsbscc instruction

	rsbscc	r0, r0, 0
	rsbscc	r15, r15, 0xff000000
	rsbscc	r0, r0, r0
	rsbscc	r15, r15, r15
	rsbscc	r0, r0, r0, lsl 0
	rsbscc	r15, r15, r15, lsl 31
	rsbscc	r0, r0, r0, lsl r0
	rsbscc	r15, r15, r15, lsl r15
	rsbscc	r0, r0, r0, lsr 1
	rsbscc	r15, r15, r15, lsr 32
	rsbscc	r0, r0, r0, lsr r0
	rsbscc	r15, r15, r15, asr r15
	rsbscc	r0, r0, r0, asr 1
	rsbscc	r15, r15, r15, asr 32
	rsbscc	r0, r0, r0, asr r0
	rsbscc	r15, r15, r15, asr r15
	rsbscc	r0, r0, r0, ror 1
	rsbscc	r15, r15, r15, ror 31
	rsbscc	r0, r0, r0, ror r0
	rsbscc	r15, r15, r15, ror r15
	rsbscc	r0, r0, r0, rrx

positive: rsbslo instruction

	rsbslo	r0, r0, 0
	rsbslo	r15, r15, 0xff000000
	rsbslo	r0, r0, r0
	rsbslo	r15, r15, r15
	rsbslo	r0, r0, r0, lsl 0
	rsbslo	r15, r15, r15, lsl 31
	rsbslo	r0, r0, r0, lsl r0
	rsbslo	r15, r15, r15, lsl r15
	rsbslo	r0, r0, r0, lsr 1
	rsbslo	r15, r15, r15, lsr 32
	rsbslo	r0, r0, r0, lsr r0
	rsbslo	r15, r15, r15, asr r15
	rsbslo	r0, r0, r0, asr 1
	rsbslo	r15, r15, r15, asr 32
	rsbslo	r0, r0, r0, asr r0
	rsbslo	r15, r15, r15, asr r15
	rsbslo	r0, r0, r0, ror 1
	rsbslo	r15, r15, r15, ror 31
	rsbslo	r0, r0, r0, ror r0
	rsbslo	r15, r15, r15, ror r15
	rsbslo	r0, r0, r0, rrx

positive: rsbsmi instruction

	rsbsmi	r0, r0, 0
	rsbsmi	r15, r15, 0xff000000
	rsbsmi	r0, r0, r0
	rsbsmi	r15, r15, r15
	rsbsmi	r0, r0, r0, lsl 0
	rsbsmi	r15, r15, r15, lsl 31
	rsbsmi	r0, r0, r0, lsl r0
	rsbsmi	r15, r15, r15, lsl r15
	rsbsmi	r0, r0, r0, lsr 1
	rsbsmi	r15, r15, r15, lsr 32
	rsbsmi	r0, r0, r0, lsr r0
	rsbsmi	r15, r15, r15, asr r15
	rsbsmi	r0, r0, r0, asr 1
	rsbsmi	r15, r15, r15, asr 32
	rsbsmi	r0, r0, r0, asr r0
	rsbsmi	r15, r15, r15, asr r15
	rsbsmi	r0, r0, r0, ror 1
	rsbsmi	r15, r15, r15, ror 31
	rsbsmi	r0, r0, r0, ror r0
	rsbsmi	r15, r15, r15, ror r15
	rsbsmi	r0, r0, r0, rrx

positive: rsbspl instruction

	rsbspl	r0, r0, 0
	rsbspl	r15, r15, 0xff000000
	rsbspl	r0, r0, r0
	rsbspl	r15, r15, r15
	rsbspl	r0, r0, r0, lsl 0
	rsbspl	r15, r15, r15, lsl 31
	rsbspl	r0, r0, r0, lsl r0
	rsbspl	r15, r15, r15, lsl r15
	rsbspl	r0, r0, r0, lsr 1
	rsbspl	r15, r15, r15, lsr 32
	rsbspl	r0, r0, r0, lsr r0
	rsbspl	r15, r15, r15, asr r15
	rsbspl	r0, r0, r0, asr 1
	rsbspl	r15, r15, r15, asr 32
	rsbspl	r0, r0, r0, asr r0
	rsbspl	r15, r15, r15, asr r15
	rsbspl	r0, r0, r0, ror 1
	rsbspl	r15, r15, r15, ror 31
	rsbspl	r0, r0, r0, ror r0
	rsbspl	r15, r15, r15, ror r15
	rsbspl	r0, r0, r0, rrx

positive: rsbsvs instruction

	rsbsvs	r0, r0, 0
	rsbsvs	r15, r15, 0xff000000
	rsbsvs	r0, r0, r0
	rsbsvs	r15, r15, r15
	rsbsvs	r0, r0, r0, lsl 0
	rsbsvs	r15, r15, r15, lsl 31
	rsbsvs	r0, r0, r0, lsl r0
	rsbsvs	r15, r15, r15, lsl r15
	rsbsvs	r0, r0, r0, lsr 1
	rsbsvs	r15, r15, r15, lsr 32
	rsbsvs	r0, r0, r0, lsr r0
	rsbsvs	r15, r15, r15, asr r15
	rsbsvs	r0, r0, r0, asr 1
	rsbsvs	r15, r15, r15, asr 32
	rsbsvs	r0, r0, r0, asr r0
	rsbsvs	r15, r15, r15, asr r15
	rsbsvs	r0, r0, r0, ror 1
	rsbsvs	r15, r15, r15, ror 31
	rsbsvs	r0, r0, r0, ror r0
	rsbsvs	r15, r15, r15, ror r15
	rsbsvs	r0, r0, r0, rrx

positive: rsbsvc instruction

	rsbsvc	r0, r0, 0
	rsbsvc	r15, r15, 0xff000000
	rsbsvc	r0, r0, r0
	rsbsvc	r15, r15, r15
	rsbsvc	r0, r0, r0, lsl 0
	rsbsvc	r15, r15, r15, lsl 31
	rsbsvc	r0, r0, r0, lsl r0
	rsbsvc	r15, r15, r15, lsl r15
	rsbsvc	r0, r0, r0, lsr 1
	rsbsvc	r15, r15, r15, lsr 32
	rsbsvc	r0, r0, r0, lsr r0
	rsbsvc	r15, r15, r15, asr r15
	rsbsvc	r0, r0, r0, asr 1
	rsbsvc	r15, r15, r15, asr 32
	rsbsvc	r0, r0, r0, asr r0
	rsbsvc	r15, r15, r15, asr r15
	rsbsvc	r0, r0, r0, ror 1
	rsbsvc	r15, r15, r15, ror 31
	rsbsvc	r0, r0, r0, ror r0
	rsbsvc	r15, r15, r15, ror r15
	rsbsvc	r0, r0, r0, rrx

positive: rsbshi instruction

	rsbshi	r0, r0, 0
	rsbshi	r15, r15, 0xff000000
	rsbshi	r0, r0, r0
	rsbshi	r15, r15, r15
	rsbshi	r0, r0, r0, lsl 0
	rsbshi	r15, r15, r15, lsl 31
	rsbshi	r0, r0, r0, lsl r0
	rsbshi	r15, r15, r15, lsl r15
	rsbshi	r0, r0, r0, lsr 1
	rsbshi	r15, r15, r15, lsr 32
	rsbshi	r0, r0, r0, lsr r0
	rsbshi	r15, r15, r15, asr r15
	rsbshi	r0, r0, r0, asr 1
	rsbshi	r15, r15, r15, asr 32
	rsbshi	r0, r0, r0, asr r0
	rsbshi	r15, r15, r15, asr r15
	rsbshi	r0, r0, r0, ror 1
	rsbshi	r15, r15, r15, ror 31
	rsbshi	r0, r0, r0, ror r0
	rsbshi	r15, r15, r15, ror r15
	rsbshi	r0, r0, r0, rrx

positive: rsbsls instruction

	rsbsls	r0, r0, 0
	rsbsls	r15, r15, 0xff000000
	rsbsls	r0, r0, r0
	rsbsls	r15, r15, r15
	rsbsls	r0, r0, r0, lsl 0
	rsbsls	r15, r15, r15, lsl 31
	rsbsls	r0, r0, r0, lsl r0
	rsbsls	r15, r15, r15, lsl r15
	rsbsls	r0, r0, r0, lsr 1
	rsbsls	r15, r15, r15, lsr 32
	rsbsls	r0, r0, r0, lsr r0
	rsbsls	r15, r15, r15, asr r15
	rsbsls	r0, r0, r0, asr 1
	rsbsls	r15, r15, r15, asr 32
	rsbsls	r0, r0, r0, asr r0
	rsbsls	r15, r15, r15, asr r15
	rsbsls	r0, r0, r0, ror 1
	rsbsls	r15, r15, r15, ror 31
	rsbsls	r0, r0, r0, ror r0
	rsbsls	r15, r15, r15, ror r15
	rsbsls	r0, r0, r0, rrx

positive: rsbsge instruction

	rsbsge	r0, r0, 0
	rsbsge	r15, r15, 0xff000000
	rsbsge	r0, r0, r0
	rsbsge	r15, r15, r15
	rsbsge	r0, r0, r0, lsl 0
	rsbsge	r15, r15, r15, lsl 31
	rsbsge	r0, r0, r0, lsl r0
	rsbsge	r15, r15, r15, lsl r15
	rsbsge	r0, r0, r0, lsr 1
	rsbsge	r15, r15, r15, lsr 32
	rsbsge	r0, r0, r0, lsr r0
	rsbsge	r15, r15, r15, asr r15
	rsbsge	r0, r0, r0, asr 1
	rsbsge	r15, r15, r15, asr 32
	rsbsge	r0, r0, r0, asr r0
	rsbsge	r15, r15, r15, asr r15
	rsbsge	r0, r0, r0, ror 1
	rsbsge	r15, r15, r15, ror 31
	rsbsge	r0, r0, r0, ror r0
	rsbsge	r15, r15, r15, ror r15
	rsbsge	r0, r0, r0, rrx

positive: rsbslt instruction

	rsbslt	r0, r0, 0
	rsbslt	r15, r15, 0xff000000
	rsbslt	r0, r0, r0
	rsbslt	r15, r15, r15
	rsbslt	r0, r0, r0, lsl 0
	rsbslt	r15, r15, r15, lsl 31
	rsbslt	r0, r0, r0, lsl r0
	rsbslt	r15, r15, r15, lsl r15
	rsbslt	r0, r0, r0, lsr 1
	rsbslt	r15, r15, r15, lsr 32
	rsbslt	r0, r0, r0, lsr r0
	rsbslt	r15, r15, r15, asr r15
	rsbslt	r0, r0, r0, asr 1
	rsbslt	r15, r15, r15, asr 32
	rsbslt	r0, r0, r0, asr r0
	rsbslt	r15, r15, r15, asr r15
	rsbslt	r0, r0, r0, ror 1
	rsbslt	r15, r15, r15, ror 31
	rsbslt	r0, r0, r0, ror r0
	rsbslt	r15, r15, r15, ror r15
	rsbslt	r0, r0, r0, rrx

positive: rsbsgt instruction

	rsbsgt	r0, r0, 0
	rsbsgt	r15, r15, 0xff000000
	rsbsgt	r0, r0, r0
	rsbsgt	r15, r15, r15
	rsbsgt	r0, r0, r0, lsl 0
	rsbsgt	r15, r15, r15, lsl 31
	rsbsgt	r0, r0, r0, lsl r0
	rsbsgt	r15, r15, r15, lsl r15
	rsbsgt	r0, r0, r0, lsr 1
	rsbsgt	r15, r15, r15, lsr 32
	rsbsgt	r0, r0, r0, lsr r0
	rsbsgt	r15, r15, r15, asr r15
	rsbsgt	r0, r0, r0, asr 1
	rsbsgt	r15, r15, r15, asr 32
	rsbsgt	r0, r0, r0, asr r0
	rsbsgt	r15, r15, r15, asr r15
	rsbsgt	r0, r0, r0, ror 1
	rsbsgt	r15, r15, r15, ror 31
	rsbsgt	r0, r0, r0, ror r0
	rsbsgt	r15, r15, r15, ror r15
	rsbsgt	r0, r0, r0, rrx

positive: rsbsle instruction

	rsbsle	r0, r0, 0
	rsbsle	r15, r15, 0xff000000
	rsbsle	r0, r0, r0
	rsbsle	r15, r15, r15
	rsbsle	r0, r0, r0, lsl 0
	rsbsle	r15, r15, r15, lsl 31
	rsbsle	r0, r0, r0, lsl r0
	rsbsle	r15, r15, r15, lsl r15
	rsbsle	r0, r0, r0, lsr 1
	rsbsle	r15, r15, r15, lsr 32
	rsbsle	r0, r0, r0, lsr r0
	rsbsle	r15, r15, r15, asr r15
	rsbsle	r0, r0, r0, asr 1
	rsbsle	r15, r15, r15, asr 32
	rsbsle	r0, r0, r0, asr r0
	rsbsle	r15, r15, r15, asr r15
	rsbsle	r0, r0, r0, ror 1
	rsbsle	r15, r15, r15, ror 31
	rsbsle	r0, r0, r0, ror r0
	rsbsle	r15, r15, r15, ror r15
	rsbsle	r0, r0, r0, rrx

positive: rsbsal instruction

	rsbsal	r0, r0, 0
	rsbsal	r15, r15, 0xff000000
	rsbsal	r0, r0, r0
	rsbsal	r15, r15, r15
	rsbsal	r0, r0, r0, lsl 0
	rsbsal	r15, r15, r15, lsl 31
	rsbsal	r0, r0, r0, lsl r0
	rsbsal	r15, r15, r15, lsl r15
	rsbsal	r0, r0, r0, lsr 1
	rsbsal	r15, r15, r15, lsr 32
	rsbsal	r0, r0, r0, lsr r0
	rsbsal	r15, r15, r15, asr r15
	rsbsal	r0, r0, r0, asr 1
	rsbsal	r15, r15, r15, asr 32
	rsbsal	r0, r0, r0, asr r0
	rsbsal	r15, r15, r15, asr r15
	rsbsal	r0, r0, r0, ror 1
	rsbsal	r15, r15, r15, ror 31
	rsbsal	r0, r0, r0, ror r0
	rsbsal	r15, r15, r15, ror r15
	rsbsal	r0, r0, r0, rrx

positive: rsc instruction

	rsc	r0, r0, 0
	rsc	r15, r15, 0xff000000
	rsc	r0, r0, r0
	rsc	r15, r15, r15
	rsc	r0, r0, r0, lsl 0
	rsc	r15, r15, r15, lsl 31
	rsc	r0, r0, r0, lsl r0
	rsc	r15, r15, r15, lsl r15
	rsc	r0, r0, r0, lsr 1
	rsc	r15, r15, r15, lsr 32
	rsc	r0, r0, r0, lsr r0
	rsc	r15, r15, r15, asr r15
	rsc	r0, r0, r0, asr 1
	rsc	r15, r15, r15, asr 32
	rsc	r0, r0, r0, asr r0
	rsc	r15, r15, r15, asr r15
	rsc	r0, r0, r0, ror 1
	rsc	r15, r15, r15, ror 31
	rsc	r0, r0, r0, ror r0
	rsc	r15, r15, r15, ror r15
	rsc	r0, r0, r0, rrx

positive: rsceq instruction

	rsceq	r0, r0, 0
	rsceq	r15, r15, 0xff000000
	rsceq	r0, r0, r0
	rsceq	r15, r15, r15
	rsceq	r0, r0, r0, lsl 0
	rsceq	r15, r15, r15, lsl 31
	rsceq	r0, r0, r0, lsl r0
	rsceq	r15, r15, r15, lsl r15
	rsceq	r0, r0, r0, lsr 1
	rsceq	r15, r15, r15, lsr 32
	rsceq	r0, r0, r0, lsr r0
	rsceq	r15, r15, r15, asr r15
	rsceq	r0, r0, r0, asr 1
	rsceq	r15, r15, r15, asr 32
	rsceq	r0, r0, r0, asr r0
	rsceq	r15, r15, r15, asr r15
	rsceq	r0, r0, r0, ror 1
	rsceq	r15, r15, r15, ror 31
	rsceq	r0, r0, r0, ror r0
	rsceq	r15, r15, r15, ror r15
	rsceq	r0, r0, r0, rrx

positive: rscne instruction

	rscne	r0, r0, 0
	rscne	r15, r15, 0xff000000
	rscne	r0, r0, r0
	rscne	r15, r15, r15
	rscne	r0, r0, r0, lsl 0
	rscne	r15, r15, r15, lsl 31
	rscne	r0, r0, r0, lsl r0
	rscne	r15, r15, r15, lsl r15
	rscne	r0, r0, r0, lsr 1
	rscne	r15, r15, r15, lsr 32
	rscne	r0, r0, r0, lsr r0
	rscne	r15, r15, r15, asr r15
	rscne	r0, r0, r0, asr 1
	rscne	r15, r15, r15, asr 32
	rscne	r0, r0, r0, asr r0
	rscne	r15, r15, r15, asr r15
	rscne	r0, r0, r0, ror 1
	rscne	r15, r15, r15, ror 31
	rscne	r0, r0, r0, ror r0
	rscne	r15, r15, r15, ror r15
	rscne	r0, r0, r0, rrx

positive: rsccs instruction

	rsccs	r0, r0, 0
	rsccs	r15, r15, 0xff000000
	rsccs	r0, r0, r0
	rsccs	r15, r15, r15
	rsccs	r0, r0, r0, lsl 0
	rsccs	r15, r15, r15, lsl 31
	rsccs	r0, r0, r0, lsl r0
	rsccs	r15, r15, r15, lsl r15
	rsccs	r0, r0, r0, lsr 1
	rsccs	r15, r15, r15, lsr 32
	rsccs	r0, r0, r0, lsr r0
	rsccs	r15, r15, r15, asr r15
	rsccs	r0, r0, r0, asr 1
	rsccs	r15, r15, r15, asr 32
	rsccs	r0, r0, r0, asr r0
	rsccs	r15, r15, r15, asr r15
	rsccs	r0, r0, r0, ror 1
	rsccs	r15, r15, r15, ror 31
	rsccs	r0, r0, r0, ror r0
	rsccs	r15, r15, r15, ror r15
	rsccs	r0, r0, r0, rrx

positive: rschs instruction

	rschs	r0, r0, 0
	rschs	r15, r15, 0xff000000
	rschs	r0, r0, r0
	rschs	r15, r15, r15
	rschs	r0, r0, r0, lsl 0
	rschs	r15, r15, r15, lsl 31
	rschs	r0, r0, r0, lsl r0
	rschs	r15, r15, r15, lsl r15
	rschs	r0, r0, r0, lsr 1
	rschs	r15, r15, r15, lsr 32
	rschs	r0, r0, r0, lsr r0
	rschs	r15, r15, r15, asr r15
	rschs	r0, r0, r0, asr 1
	rschs	r15, r15, r15, asr 32
	rschs	r0, r0, r0, asr r0
	rschs	r15, r15, r15, asr r15
	rschs	r0, r0, r0, ror 1
	rschs	r15, r15, r15, ror 31
	rschs	r0, r0, r0, ror r0
	rschs	r15, r15, r15, ror r15
	rschs	r0, r0, r0, rrx

positive: rsccc instruction

	rsccc	r0, r0, 0
	rsccc	r15, r15, 0xff000000
	rsccc	r0, r0, r0
	rsccc	r15, r15, r15
	rsccc	r0, r0, r0, lsl 0
	rsccc	r15, r15, r15, lsl 31
	rsccc	r0, r0, r0, lsl r0
	rsccc	r15, r15, r15, lsl r15
	rsccc	r0, r0, r0, lsr 1
	rsccc	r15, r15, r15, lsr 32
	rsccc	r0, r0, r0, lsr r0
	rsccc	r15, r15, r15, asr r15
	rsccc	r0, r0, r0, asr 1
	rsccc	r15, r15, r15, asr 32
	rsccc	r0, r0, r0, asr r0
	rsccc	r15, r15, r15, asr r15
	rsccc	r0, r0, r0, ror 1
	rsccc	r15, r15, r15, ror 31
	rsccc	r0, r0, r0, ror r0
	rsccc	r15, r15, r15, ror r15
	rsccc	r0, r0, r0, rrx

positive: rsclo instruction

	rsclo	r0, r0, 0
	rsclo	r15, r15, 0xff000000
	rsclo	r0, r0, r0
	rsclo	r15, r15, r15
	rsclo	r0, r0, r0, lsl 0
	rsclo	r15, r15, r15, lsl 31
	rsclo	r0, r0, r0, lsl r0
	rsclo	r15, r15, r15, lsl r15
	rsclo	r0, r0, r0, lsr 1
	rsclo	r15, r15, r15, lsr 32
	rsclo	r0, r0, r0, lsr r0
	rsclo	r15, r15, r15, asr r15
	rsclo	r0, r0, r0, asr 1
	rsclo	r15, r15, r15, asr 32
	rsclo	r0, r0, r0, asr r0
	rsclo	r15, r15, r15, asr r15
	rsclo	r0, r0, r0, ror 1
	rsclo	r15, r15, r15, ror 31
	rsclo	r0, r0, r0, ror r0
	rsclo	r15, r15, r15, ror r15
	rsclo	r0, r0, r0, rrx

positive: rscmi instruction

	rscmi	r0, r0, 0
	rscmi	r15, r15, 0xff000000
	rscmi	r0, r0, r0
	rscmi	r15, r15, r15
	rscmi	r0, r0, r0, lsl 0
	rscmi	r15, r15, r15, lsl 31
	rscmi	r0, r0, r0, lsl r0
	rscmi	r15, r15, r15, lsl r15
	rscmi	r0, r0, r0, lsr 1
	rscmi	r15, r15, r15, lsr 32
	rscmi	r0, r0, r0, lsr r0
	rscmi	r15, r15, r15, asr r15
	rscmi	r0, r0, r0, asr 1
	rscmi	r15, r15, r15, asr 32
	rscmi	r0, r0, r0, asr r0
	rscmi	r15, r15, r15, asr r15
	rscmi	r0, r0, r0, ror 1
	rscmi	r15, r15, r15, ror 31
	rscmi	r0, r0, r0, ror r0
	rscmi	r15, r15, r15, ror r15
	rscmi	r0, r0, r0, rrx

positive: rscpl instruction

	rscpl	r0, r0, 0
	rscpl	r15, r15, 0xff000000
	rscpl	r0, r0, r0
	rscpl	r15, r15, r15
	rscpl	r0, r0, r0, lsl 0
	rscpl	r15, r15, r15, lsl 31
	rscpl	r0, r0, r0, lsl r0
	rscpl	r15, r15, r15, lsl r15
	rscpl	r0, r0, r0, lsr 1
	rscpl	r15, r15, r15, lsr 32
	rscpl	r0, r0, r0, lsr r0
	rscpl	r15, r15, r15, asr r15
	rscpl	r0, r0, r0, asr 1
	rscpl	r15, r15, r15, asr 32
	rscpl	r0, r0, r0, asr r0
	rscpl	r15, r15, r15, asr r15
	rscpl	r0, r0, r0, ror 1
	rscpl	r15, r15, r15, ror 31
	rscpl	r0, r0, r0, ror r0
	rscpl	r15, r15, r15, ror r15
	rscpl	r0, r0, r0, rrx

positive: rscvs instruction

	rscvs	r0, r0, 0
	rscvs	r15, r15, 0xff000000
	rscvs	r0, r0, r0
	rscvs	r15, r15, r15
	rscvs	r0, r0, r0, lsl 0
	rscvs	r15, r15, r15, lsl 31
	rscvs	r0, r0, r0, lsl r0
	rscvs	r15, r15, r15, lsl r15
	rscvs	r0, r0, r0, lsr 1
	rscvs	r15, r15, r15, lsr 32
	rscvs	r0, r0, r0, lsr r0
	rscvs	r15, r15, r15, asr r15
	rscvs	r0, r0, r0, asr 1
	rscvs	r15, r15, r15, asr 32
	rscvs	r0, r0, r0, asr r0
	rscvs	r15, r15, r15, asr r15
	rscvs	r0, r0, r0, ror 1
	rscvs	r15, r15, r15, ror 31
	rscvs	r0, r0, r0, ror r0
	rscvs	r15, r15, r15, ror r15
	rscvs	r0, r0, r0, rrx

positive: rscvc instruction

	rscvc	r0, r0, 0
	rscvc	r15, r15, 0xff000000
	rscvc	r0, r0, r0
	rscvc	r15, r15, r15
	rscvc	r0, r0, r0, lsl 0
	rscvc	r15, r15, r15, lsl 31
	rscvc	r0, r0, r0, lsl r0
	rscvc	r15, r15, r15, lsl r15
	rscvc	r0, r0, r0, lsr 1
	rscvc	r15, r15, r15, lsr 32
	rscvc	r0, r0, r0, lsr r0
	rscvc	r15, r15, r15, asr r15
	rscvc	r0, r0, r0, asr 1
	rscvc	r15, r15, r15, asr 32
	rscvc	r0, r0, r0, asr r0
	rscvc	r15, r15, r15, asr r15
	rscvc	r0, r0, r0, ror 1
	rscvc	r15, r15, r15, ror 31
	rscvc	r0, r0, r0, ror r0
	rscvc	r15, r15, r15, ror r15
	rscvc	r0, r0, r0, rrx

positive: rschi instruction

	rschi	r0, r0, 0
	rschi	r15, r15, 0xff000000
	rschi	r0, r0, r0
	rschi	r15, r15, r15
	rschi	r0, r0, r0, lsl 0
	rschi	r15, r15, r15, lsl 31
	rschi	r0, r0, r0, lsl r0
	rschi	r15, r15, r15, lsl r15
	rschi	r0, r0, r0, lsr 1
	rschi	r15, r15, r15, lsr 32
	rschi	r0, r0, r0, lsr r0
	rschi	r15, r15, r15, asr r15
	rschi	r0, r0, r0, asr 1
	rschi	r15, r15, r15, asr 32
	rschi	r0, r0, r0, asr r0
	rschi	r15, r15, r15, asr r15
	rschi	r0, r0, r0, ror 1
	rschi	r15, r15, r15, ror 31
	rschi	r0, r0, r0, ror r0
	rschi	r15, r15, r15, ror r15
	rschi	r0, r0, r0, rrx

positive: rscls instruction

	rscls	r0, r0, 0
	rscls	r15, r15, 0xff000000
	rscls	r0, r0, r0
	rscls	r15, r15, r15
	rscls	r0, r0, r0, lsl 0
	rscls	r15, r15, r15, lsl 31
	rscls	r0, r0, r0, lsl r0
	rscls	r15, r15, r15, lsl r15
	rscls	r0, r0, r0, lsr 1
	rscls	r15, r15, r15, lsr 32
	rscls	r0, r0, r0, lsr r0
	rscls	r15, r15, r15, asr r15
	rscls	r0, r0, r0, asr 1
	rscls	r15, r15, r15, asr 32
	rscls	r0, r0, r0, asr r0
	rscls	r15, r15, r15, asr r15
	rscls	r0, r0, r0, ror 1
	rscls	r15, r15, r15, ror 31
	rscls	r0, r0, r0, ror r0
	rscls	r15, r15, r15, ror r15
	rscls	r0, r0, r0, rrx

positive: rscge instruction

	rscge	r0, r0, 0
	rscge	r15, r15, 0xff000000
	rscge	r0, r0, r0
	rscge	r15, r15, r15
	rscge	r0, r0, r0, lsl 0
	rscge	r15, r15, r15, lsl 31
	rscge	r0, r0, r0, lsl r0
	rscge	r15, r15, r15, lsl r15
	rscge	r0, r0, r0, lsr 1
	rscge	r15, r15, r15, lsr 32
	rscge	r0, r0, r0, lsr r0
	rscge	r15, r15, r15, asr r15
	rscge	r0, r0, r0, asr 1
	rscge	r15, r15, r15, asr 32
	rscge	r0, r0, r0, asr r0
	rscge	r15, r15, r15, asr r15
	rscge	r0, r0, r0, ror 1
	rscge	r15, r15, r15, ror 31
	rscge	r0, r0, r0, ror r0
	rscge	r15, r15, r15, ror r15
	rscge	r0, r0, r0, rrx

positive: rsclt instruction

	rsclt	r0, r0, 0
	rsclt	r15, r15, 0xff000000
	rsclt	r0, r0, r0
	rsclt	r15, r15, r15
	rsclt	r0, r0, r0, lsl 0
	rsclt	r15, r15, r15, lsl 31
	rsclt	r0, r0, r0, lsl r0
	rsclt	r15, r15, r15, lsl r15
	rsclt	r0, r0, r0, lsr 1
	rsclt	r15, r15, r15, lsr 32
	rsclt	r0, r0, r0, lsr r0
	rsclt	r15, r15, r15, asr r15
	rsclt	r0, r0, r0, asr 1
	rsclt	r15, r15, r15, asr 32
	rsclt	r0, r0, r0, asr r0
	rsclt	r15, r15, r15, asr r15
	rsclt	r0, r0, r0, ror 1
	rsclt	r15, r15, r15, ror 31
	rsclt	r0, r0, r0, ror r0
	rsclt	r15, r15, r15, ror r15
	rsclt	r0, r0, r0, rrx

positive: rscgt instruction

	rscgt	r0, r0, 0
	rscgt	r15, r15, 0xff000000
	rscgt	r0, r0, r0
	rscgt	r15, r15, r15
	rscgt	r0, r0, r0, lsl 0
	rscgt	r15, r15, r15, lsl 31
	rscgt	r0, r0, r0, lsl r0
	rscgt	r15, r15, r15, lsl r15
	rscgt	r0, r0, r0, lsr 1
	rscgt	r15, r15, r15, lsr 32
	rscgt	r0, r0, r0, lsr r0
	rscgt	r15, r15, r15, asr r15
	rscgt	r0, r0, r0, asr 1
	rscgt	r15, r15, r15, asr 32
	rscgt	r0, r0, r0, asr r0
	rscgt	r15, r15, r15, asr r15
	rscgt	r0, r0, r0, ror 1
	rscgt	r15, r15, r15, ror 31
	rscgt	r0, r0, r0, ror r0
	rscgt	r15, r15, r15, ror r15
	rscgt	r0, r0, r0, rrx

positive: rscle instruction

	rscle	r0, r0, 0
	rscle	r15, r15, 0xff000000
	rscle	r0, r0, r0
	rscle	r15, r15, r15
	rscle	r0, r0, r0, lsl 0
	rscle	r15, r15, r15, lsl 31
	rscle	r0, r0, r0, lsl r0
	rscle	r15, r15, r15, lsl r15
	rscle	r0, r0, r0, lsr 1
	rscle	r15, r15, r15, lsr 32
	rscle	r0, r0, r0, lsr r0
	rscle	r15, r15, r15, asr r15
	rscle	r0, r0, r0, asr 1
	rscle	r15, r15, r15, asr 32
	rscle	r0, r0, r0, asr r0
	rscle	r15, r15, r15, asr r15
	rscle	r0, r0, r0, ror 1
	rscle	r15, r15, r15, ror 31
	rscle	r0, r0, r0, ror r0
	rscle	r15, r15, r15, ror r15
	rscle	r0, r0, r0, rrx

positive: rscal instruction

	rscal	r0, r0, 0
	rscal	r15, r15, 0xff000000
	rscal	r0, r0, r0
	rscal	r15, r15, r15
	rscal	r0, r0, r0, lsl 0
	rscal	r15, r15, r15, lsl 31
	rscal	r0, r0, r0, lsl r0
	rscal	r15, r15, r15, lsl r15
	rscal	r0, r0, r0, lsr 1
	rscal	r15, r15, r15, lsr 32
	rscal	r0, r0, r0, lsr r0
	rscal	r15, r15, r15, asr r15
	rscal	r0, r0, r0, asr 1
	rscal	r15, r15, r15, asr 32
	rscal	r0, r0, r0, asr r0
	rscal	r15, r15, r15, asr r15
	rscal	r0, r0, r0, ror 1
	rscal	r15, r15, r15, ror 31
	rscal	r0, r0, r0, ror r0
	rscal	r15, r15, r15, ror r15
	rscal	r0, r0, r0, rrx

positive: rscs instruction

	rscs	r0, r0, 0
	rscs	r15, r15, 0xff000000
	rscs	r0, r0, r0
	rscs	r15, r15, r15
	rscs	r0, r0, r0, lsl 0
	rscs	r15, r15, r15, lsl 31
	rscs	r0, r0, r0, lsl r0
	rscs	r15, r15, r15, lsl r15
	rscs	r0, r0, r0, lsr 1
	rscs	r15, r15, r15, lsr 32
	rscs	r0, r0, r0, lsr r0
	rscs	r15, r15, r15, asr r15
	rscs	r0, r0, r0, asr 1
	rscs	r15, r15, r15, asr 32
	rscs	r0, r0, r0, asr r0
	rscs	r15, r15, r15, asr r15
	rscs	r0, r0, r0, ror 1
	rscs	r15, r15, r15, ror 31
	rscs	r0, r0, r0, ror r0
	rscs	r15, r15, r15, ror r15
	rscs	r0, r0, r0, rrx

positive: rscseq instruction

	rscseq	r0, r0, 0
	rscseq	r15, r15, 0xff000000
	rscseq	r0, r0, r0
	rscseq	r15, r15, r15
	rscseq	r0, r0, r0, lsl 0
	rscseq	r15, r15, r15, lsl 31
	rscseq	r0, r0, r0, lsl r0
	rscseq	r15, r15, r15, lsl r15
	rscseq	r0, r0, r0, lsr 1
	rscseq	r15, r15, r15, lsr 32
	rscseq	r0, r0, r0, lsr r0
	rscseq	r15, r15, r15, asr r15
	rscseq	r0, r0, r0, asr 1
	rscseq	r15, r15, r15, asr 32
	rscseq	r0, r0, r0, asr r0
	rscseq	r15, r15, r15, asr r15
	rscseq	r0, r0, r0, ror 1
	rscseq	r15, r15, r15, ror 31
	rscseq	r0, r0, r0, ror r0
	rscseq	r15, r15, r15, ror r15
	rscseq	r0, r0, r0, rrx

positive: rscsne instruction

	rscsne	r0, r0, 0
	rscsne	r15, r15, 0xff000000
	rscsne	r0, r0, r0
	rscsne	r15, r15, r15
	rscsne	r0, r0, r0, lsl 0
	rscsne	r15, r15, r15, lsl 31
	rscsne	r0, r0, r0, lsl r0
	rscsne	r15, r15, r15, lsl r15
	rscsne	r0, r0, r0, lsr 1
	rscsne	r15, r15, r15, lsr 32
	rscsne	r0, r0, r0, lsr r0
	rscsne	r15, r15, r15, asr r15
	rscsne	r0, r0, r0, asr 1
	rscsne	r15, r15, r15, asr 32
	rscsne	r0, r0, r0, asr r0
	rscsne	r15, r15, r15, asr r15
	rscsne	r0, r0, r0, ror 1
	rscsne	r15, r15, r15, ror 31
	rscsne	r0, r0, r0, ror r0
	rscsne	r15, r15, r15, ror r15
	rscsne	r0, r0, r0, rrx

positive: rscscs instruction

	rscscs	r0, r0, 0
	rscscs	r15, r15, 0xff000000
	rscscs	r0, r0, r0
	rscscs	r15, r15, r15
	rscscs	r0, r0, r0, lsl 0
	rscscs	r15, r15, r15, lsl 31
	rscscs	r0, r0, r0, lsl r0
	rscscs	r15, r15, r15, lsl r15
	rscscs	r0, r0, r0, lsr 1
	rscscs	r15, r15, r15, lsr 32
	rscscs	r0, r0, r0, lsr r0
	rscscs	r15, r15, r15, asr r15
	rscscs	r0, r0, r0, asr 1
	rscscs	r15, r15, r15, asr 32
	rscscs	r0, r0, r0, asr r0
	rscscs	r15, r15, r15, asr r15
	rscscs	r0, r0, r0, ror 1
	rscscs	r15, r15, r15, ror 31
	rscscs	r0, r0, r0, ror r0
	rscscs	r15, r15, r15, ror r15
	rscscs	r0, r0, r0, rrx

positive: rscshs instruction

	rscshs	r0, r0, 0
	rscshs	r15, r15, 0xff000000
	rscshs	r0, r0, r0
	rscshs	r15, r15, r15
	rscshs	r0, r0, r0, lsl 0
	rscshs	r15, r15, r15, lsl 31
	rscshs	r0, r0, r0, lsl r0
	rscshs	r15, r15, r15, lsl r15
	rscshs	r0, r0, r0, lsr 1
	rscshs	r15, r15, r15, lsr 32
	rscshs	r0, r0, r0, lsr r0
	rscshs	r15, r15, r15, asr r15
	rscshs	r0, r0, r0, asr 1
	rscshs	r15, r15, r15, asr 32
	rscshs	r0, r0, r0, asr r0
	rscshs	r15, r15, r15, asr r15
	rscshs	r0, r0, r0, ror 1
	rscshs	r15, r15, r15, ror 31
	rscshs	r0, r0, r0, ror r0
	rscshs	r15, r15, r15, ror r15
	rscshs	r0, r0, r0, rrx

positive: rscscc instruction

	rscscc	r0, r0, 0
	rscscc	r15, r15, 0xff000000
	rscscc	r0, r0, r0
	rscscc	r15, r15, r15
	rscscc	r0, r0, r0, lsl 0
	rscscc	r15, r15, r15, lsl 31
	rscscc	r0, r0, r0, lsl r0
	rscscc	r15, r15, r15, lsl r15
	rscscc	r0, r0, r0, lsr 1
	rscscc	r15, r15, r15, lsr 32
	rscscc	r0, r0, r0, lsr r0
	rscscc	r15, r15, r15, asr r15
	rscscc	r0, r0, r0, asr 1
	rscscc	r15, r15, r15, asr 32
	rscscc	r0, r0, r0, asr r0
	rscscc	r15, r15, r15, asr r15
	rscscc	r0, r0, r0, ror 1
	rscscc	r15, r15, r15, ror 31
	rscscc	r0, r0, r0, ror r0
	rscscc	r15, r15, r15, ror r15
	rscscc	r0, r0, r0, rrx

positive: rscslo instruction

	rscslo	r0, r0, 0
	rscslo	r15, r15, 0xff000000
	rscslo	r0, r0, r0
	rscslo	r15, r15, r15
	rscslo	r0, r0, r0, lsl 0
	rscslo	r15, r15, r15, lsl 31
	rscslo	r0, r0, r0, lsl r0
	rscslo	r15, r15, r15, lsl r15
	rscslo	r0, r0, r0, lsr 1
	rscslo	r15, r15, r15, lsr 32
	rscslo	r0, r0, r0, lsr r0
	rscslo	r15, r15, r15, asr r15
	rscslo	r0, r0, r0, asr 1
	rscslo	r15, r15, r15, asr 32
	rscslo	r0, r0, r0, asr r0
	rscslo	r15, r15, r15, asr r15
	rscslo	r0, r0, r0, ror 1
	rscslo	r15, r15, r15, ror 31
	rscslo	r0, r0, r0, ror r0
	rscslo	r15, r15, r15, ror r15
	rscslo	r0, r0, r0, rrx

positive: rscsmi instruction

	rscsmi	r0, r0, 0
	rscsmi	r15, r15, 0xff000000
	rscsmi	r0, r0, r0
	rscsmi	r15, r15, r15
	rscsmi	r0, r0, r0, lsl 0
	rscsmi	r15, r15, r15, lsl 31
	rscsmi	r0, r0, r0, lsl r0
	rscsmi	r15, r15, r15, lsl r15
	rscsmi	r0, r0, r0, lsr 1
	rscsmi	r15, r15, r15, lsr 32
	rscsmi	r0, r0, r0, lsr r0
	rscsmi	r15, r15, r15, asr r15
	rscsmi	r0, r0, r0, asr 1
	rscsmi	r15, r15, r15, asr 32
	rscsmi	r0, r0, r0, asr r0
	rscsmi	r15, r15, r15, asr r15
	rscsmi	r0, r0, r0, ror 1
	rscsmi	r15, r15, r15, ror 31
	rscsmi	r0, r0, r0, ror r0
	rscsmi	r15, r15, r15, ror r15
	rscsmi	r0, r0, r0, rrx

positive: rscspl instruction

	rscspl	r0, r0, 0
	rscspl	r15, r15, 0xff000000
	rscspl	r0, r0, r0
	rscspl	r15, r15, r15
	rscspl	r0, r0, r0, lsl 0
	rscspl	r15, r15, r15, lsl 31
	rscspl	r0, r0, r0, lsl r0
	rscspl	r15, r15, r15, lsl r15
	rscspl	r0, r0, r0, lsr 1
	rscspl	r15, r15, r15, lsr 32
	rscspl	r0, r0, r0, lsr r0
	rscspl	r15, r15, r15, asr r15
	rscspl	r0, r0, r0, asr 1
	rscspl	r15, r15, r15, asr 32
	rscspl	r0, r0, r0, asr r0
	rscspl	r15, r15, r15, asr r15
	rscspl	r0, r0, r0, ror 1
	rscspl	r15, r15, r15, ror 31
	rscspl	r0, r0, r0, ror r0
	rscspl	r15, r15, r15, ror r15
	rscspl	r0, r0, r0, rrx

positive: rscsvs instruction

	rscsvs	r0, r0, 0
	rscsvs	r15, r15, 0xff000000
	rscsvs	r0, r0, r0
	rscsvs	r15, r15, r15
	rscsvs	r0, r0, r0, lsl 0
	rscsvs	r15, r15, r15, lsl 31
	rscsvs	r0, r0, r0, lsl r0
	rscsvs	r15, r15, r15, lsl r15
	rscsvs	r0, r0, r0, lsr 1
	rscsvs	r15, r15, r15, lsr 32
	rscsvs	r0, r0, r0, lsr r0
	rscsvs	r15, r15, r15, asr r15
	rscsvs	r0, r0, r0, asr 1
	rscsvs	r15, r15, r15, asr 32
	rscsvs	r0, r0, r0, asr r0
	rscsvs	r15, r15, r15, asr r15
	rscsvs	r0, r0, r0, ror 1
	rscsvs	r15, r15, r15, ror 31
	rscsvs	r0, r0, r0, ror r0
	rscsvs	r15, r15, r15, ror r15
	rscsvs	r0, r0, r0, rrx

positive: rscsvc instruction

	rscsvc	r0, r0, 0
	rscsvc	r15, r15, 0xff000000
	rscsvc	r0, r0, r0
	rscsvc	r15, r15, r15
	rscsvc	r0, r0, r0, lsl 0
	rscsvc	r15, r15, r15, lsl 31
	rscsvc	r0, r0, r0, lsl r0
	rscsvc	r15, r15, r15, lsl r15
	rscsvc	r0, r0, r0, lsr 1
	rscsvc	r15, r15, r15, lsr 32
	rscsvc	r0, r0, r0, lsr r0
	rscsvc	r15, r15, r15, asr r15
	rscsvc	r0, r0, r0, asr 1
	rscsvc	r15, r15, r15, asr 32
	rscsvc	r0, r0, r0, asr r0
	rscsvc	r15, r15, r15, asr r15
	rscsvc	r0, r0, r0, ror 1
	rscsvc	r15, r15, r15, ror 31
	rscsvc	r0, r0, r0, ror r0
	rscsvc	r15, r15, r15, ror r15
	rscsvc	r0, r0, r0, rrx

positive: rscshi instruction

	rscshi	r0, r0, 0
	rscshi	r15, r15, 0xff000000
	rscshi	r0, r0, r0
	rscshi	r15, r15, r15
	rscshi	r0, r0, r0, lsl 0
	rscshi	r15, r15, r15, lsl 31
	rscshi	r0, r0, r0, lsl r0
	rscshi	r15, r15, r15, lsl r15
	rscshi	r0, r0, r0, lsr 1
	rscshi	r15, r15, r15, lsr 32
	rscshi	r0, r0, r0, lsr r0
	rscshi	r15, r15, r15, asr r15
	rscshi	r0, r0, r0, asr 1
	rscshi	r15, r15, r15, asr 32
	rscshi	r0, r0, r0, asr r0
	rscshi	r15, r15, r15, asr r15
	rscshi	r0, r0, r0, ror 1
	rscshi	r15, r15, r15, ror 31
	rscshi	r0, r0, r0, ror r0
	rscshi	r15, r15, r15, ror r15
	rscshi	r0, r0, r0, rrx

positive: rscsls instruction

	rscsls	r0, r0, 0
	rscsls	r15, r15, 0xff000000
	rscsls	r0, r0, r0
	rscsls	r15, r15, r15
	rscsls	r0, r0, r0, lsl 0
	rscsls	r15, r15, r15, lsl 31
	rscsls	r0, r0, r0, lsl r0
	rscsls	r15, r15, r15, lsl r15
	rscsls	r0, r0, r0, lsr 1
	rscsls	r15, r15, r15, lsr 32
	rscsls	r0, r0, r0, lsr r0
	rscsls	r15, r15, r15, asr r15
	rscsls	r0, r0, r0, asr 1
	rscsls	r15, r15, r15, asr 32
	rscsls	r0, r0, r0, asr r0
	rscsls	r15, r15, r15, asr r15
	rscsls	r0, r0, r0, ror 1
	rscsls	r15, r15, r15, ror 31
	rscsls	r0, r0, r0, ror r0
	rscsls	r15, r15, r15, ror r15
	rscsls	r0, r0, r0, rrx

positive: rscsge instruction

	rscsge	r0, r0, 0
	rscsge	r15, r15, 0xff000000
	rscsge	r0, r0, r0
	rscsge	r15, r15, r15
	rscsge	r0, r0, r0, lsl 0
	rscsge	r15, r15, r15, lsl 31
	rscsge	r0, r0, r0, lsl r0
	rscsge	r15, r15, r15, lsl r15
	rscsge	r0, r0, r0, lsr 1
	rscsge	r15, r15, r15, lsr 32
	rscsge	r0, r0, r0, lsr r0
	rscsge	r15, r15, r15, asr r15
	rscsge	r0, r0, r0, asr 1
	rscsge	r15, r15, r15, asr 32
	rscsge	r0, r0, r0, asr r0
	rscsge	r15, r15, r15, asr r15
	rscsge	r0, r0, r0, ror 1
	rscsge	r15, r15, r15, ror 31
	rscsge	r0, r0, r0, ror r0
	rscsge	r15, r15, r15, ror r15
	rscsge	r0, r0, r0, rrx

positive: rscslt instruction

	rscslt	r0, r0, 0
	rscslt	r15, r15, 0xff000000
	rscslt	r0, r0, r0
	rscslt	r15, r15, r15
	rscslt	r0, r0, r0, lsl 0
	rscslt	r15, r15, r15, lsl 31
	rscslt	r0, r0, r0, lsl r0
	rscslt	r15, r15, r15, lsl r15
	rscslt	r0, r0, r0, lsr 1
	rscslt	r15, r15, r15, lsr 32
	rscslt	r0, r0, r0, lsr r0
	rscslt	r15, r15, r15, asr r15
	rscslt	r0, r0, r0, asr 1
	rscslt	r15, r15, r15, asr 32
	rscslt	r0, r0, r0, asr r0
	rscslt	r15, r15, r15, asr r15
	rscslt	r0, r0, r0, ror 1
	rscslt	r15, r15, r15, ror 31
	rscslt	r0, r0, r0, ror r0
	rscslt	r15, r15, r15, ror r15
	rscslt	r0, r0, r0, rrx

positive: rscsgt instruction

	rscsgt	r0, r0, 0
	rscsgt	r15, r15, 0xff000000
	rscsgt	r0, r0, r0
	rscsgt	r15, r15, r15
	rscsgt	r0, r0, r0, lsl 0
	rscsgt	r15, r15, r15, lsl 31
	rscsgt	r0, r0, r0, lsl r0
	rscsgt	r15, r15, r15, lsl r15
	rscsgt	r0, r0, r0, lsr 1
	rscsgt	r15, r15, r15, lsr 32
	rscsgt	r0, r0, r0, lsr r0
	rscsgt	r15, r15, r15, asr r15
	rscsgt	r0, r0, r0, asr 1
	rscsgt	r15, r15, r15, asr 32
	rscsgt	r0, r0, r0, asr r0
	rscsgt	r15, r15, r15, asr r15
	rscsgt	r0, r0, r0, ror 1
	rscsgt	r15, r15, r15, ror 31
	rscsgt	r0, r0, r0, ror r0
	rscsgt	r15, r15, r15, ror r15
	rscsgt	r0, r0, r0, rrx

positive: rscsle instruction

	rscsle	r0, r0, 0
	rscsle	r15, r15, 0xff000000
	rscsle	r0, r0, r0
	rscsle	r15, r15, r15
	rscsle	r0, r0, r0, lsl 0
	rscsle	r15, r15, r15, lsl 31
	rscsle	r0, r0, r0, lsl r0
	rscsle	r15, r15, r15, lsl r15
	rscsle	r0, r0, r0, lsr 1
	rscsle	r15, r15, r15, lsr 32
	rscsle	r0, r0, r0, lsr r0
	rscsle	r15, r15, r15, asr r15
	rscsle	r0, r0, r0, asr 1
	rscsle	r15, r15, r15, asr 32
	rscsle	r0, r0, r0, asr r0
	rscsle	r15, r15, r15, asr r15
	rscsle	r0, r0, r0, ror 1
	rscsle	r15, r15, r15, ror 31
	rscsle	r0, r0, r0, ror r0
	rscsle	r15, r15, r15, ror r15
	rscsle	r0, r0, r0, rrx

positive: rscsal instruction

	rscsal	r0, r0, 0
	rscsal	r15, r15, 0xff000000
	rscsal	r0, r0, r0
	rscsal	r15, r15, r15
	rscsal	r0, r0, r0, lsl 0
	rscsal	r15, r15, r15, lsl 31
	rscsal	r0, r0, r0, lsl r0
	rscsal	r15, r15, r15, lsl r15
	rscsal	r0, r0, r0, lsr 1
	rscsal	r15, r15, r15, lsr 32
	rscsal	r0, r0, r0, lsr r0
	rscsal	r15, r15, r15, asr r15
	rscsal	r0, r0, r0, asr 1
	rscsal	r15, r15, r15, asr 32
	rscsal	r0, r0, r0, asr r0
	rscsal	r15, r15, r15, asr r15
	rscsal	r0, r0, r0, ror 1
	rscsal	r15, r15, r15, ror 31
	rscsal	r0, r0, r0, ror r0
	rscsal	r15, r15, r15, ror r15
	rscsal	r0, r0, r0, rrx

positive: sadd16 instruction

	sadd16	r0, r0, r0
	sadd16	r15, r15, r15

positive: sadd16eq instruction

	sadd16eq	r0, r0, r0
	sadd16eq	r15, r15, r15

positive: sadd16ne instruction

	sadd16ne	r0, r0, r0
	sadd16ne	r15, r15, r15

positive: sadd16cs instruction

	sadd16cs	r0, r0, r0
	sadd16cs	r15, r15, r15

positive: sadd16hs instruction

	sadd16hs	r0, r0, r0
	sadd16hs	r15, r15, r15

positive: sadd16cc instruction

	sadd16cc	r0, r0, r0
	sadd16cc	r15, r15, r15

positive: sadd16lo instruction

	sadd16lo	r0, r0, r0
	sadd16lo	r15, r15, r15

positive: sadd16mi instruction

	sadd16mi	r0, r0, r0
	sadd16mi	r15, r15, r15

positive: sadd16pl instruction

	sadd16pl	r0, r0, r0
	sadd16pl	r15, r15, r15

positive: sadd16vs instruction

	sadd16vs	r0, r0, r0
	sadd16vs	r15, r15, r15

positive: sadd16vc instruction

	sadd16vc	r0, r0, r0
	sadd16vc	r15, r15, r15

positive: sadd16hi instruction

	sadd16hi	r0, r0, r0
	sadd16hi	r15, r15, r15

positive: sadd16ls instruction

	sadd16ls	r0, r0, r0
	sadd16ls	r15, r15, r15

positive: sadd16ge instruction

	sadd16ge	r0, r0, r0
	sadd16ge	r15, r15, r15

positive: sadd16lt instruction

	sadd16lt	r0, r0, r0
	sadd16lt	r15, r15, r15

positive: sadd16gt instruction

	sadd16gt	r0, r0, r0
	sadd16gt	r15, r15, r15

positive: sadd16le instruction

	sadd16le	r0, r0, r0
	sadd16le	r15, r15, r15

positive: sadd16al instruction

	sadd16al	r0, r0, r0
	sadd16al	r15, r15, r15

positive: sadd8 instruction

	sadd8	r0, r0, r0
	sadd8	r15, r15, r15

positive: sadd8eq instruction

	sadd8eq	r0, r0, r0
	sadd8eq	r15, r15, r15

positive: sadd8ne instruction

	sadd8ne	r0, r0, r0
	sadd8ne	r15, r15, r15

positive: sadd8cs instruction

	sadd8cs	r0, r0, r0
	sadd8cs	r15, r15, r15

positive: sadd8hs instruction

	sadd8hs	r0, r0, r0
	sadd8hs	r15, r15, r15

positive: sadd8cc instruction

	sadd8cc	r0, r0, r0
	sadd8cc	r15, r15, r15

positive: sadd8lo instruction

	sadd8lo	r0, r0, r0
	sadd8lo	r15, r15, r15

positive: sadd8mi instruction

	sadd8mi	r0, r0, r0
	sadd8mi	r15, r15, r15

positive: sadd8pl instruction

	sadd8pl	r0, r0, r0
	sadd8pl	r15, r15, r15

positive: sadd8vs instruction

	sadd8vs	r0, r0, r0
	sadd8vs	r15, r15, r15

positive: sadd8vc instruction

	sadd8vc	r0, r0, r0
	sadd8vc	r15, r15, r15

positive: sadd8hi instruction

	sadd8hi	r0, r0, r0
	sadd8hi	r15, r15, r15

positive: sadd8ls instruction

	sadd8ls	r0, r0, r0
	sadd8ls	r15, r15, r15

positive: sadd8ge instruction

	sadd8ge	r0, r0, r0
	sadd8ge	r15, r15, r15

positive: sadd8lt instruction

	sadd8lt	r0, r0, r0
	sadd8lt	r15, r15, r15

positive: sadd8gt instruction

	sadd8gt	r0, r0, r0
	sadd8gt	r15, r15, r15

positive: sadd8le instruction

	sadd8le	r0, r0, r0
	sadd8le	r15, r15, r15

positive: sadd8al instruction

	sadd8al	r0, r0, r0
	sadd8al	r15, r15, r15

positive: saddsubx instruction

	saddsubx	r0, r0, r0
	saddsubx	r15, r15, r15

positive: saddsubxeq instruction

	saddsubxeq	r0, r0, r0
	saddsubxeq	r15, r15, r15

positive: saddsubxne instruction

	saddsubxne	r0, r0, r0
	saddsubxne	r15, r15, r15

positive: saddsubxcs instruction

	saddsubxcs	r0, r0, r0
	saddsubxcs	r15, r15, r15

positive: saddsubxhs instruction

	saddsubxhs	r0, r0, r0
	saddsubxhs	r15, r15, r15

positive: saddsubxcc instruction

	saddsubxcc	r0, r0, r0
	saddsubxcc	r15, r15, r15

positive: saddsubxlo instruction

	saddsubxlo	r0, r0, r0
	saddsubxlo	r15, r15, r15

positive: saddsubxmi instruction

	saddsubxmi	r0, r0, r0
	saddsubxmi	r15, r15, r15

positive: saddsubxpl instruction

	saddsubxpl	r0, r0, r0
	saddsubxpl	r15, r15, r15

positive: saddsubxvs instruction

	saddsubxvs	r0, r0, r0
	saddsubxvs	r15, r15, r15

positive: saddsubxvc instruction

	saddsubxvc	r0, r0, r0
	saddsubxvc	r15, r15, r15

positive: saddsubxhi instruction

	saddsubxhi	r0, r0, r0
	saddsubxhi	r15, r15, r15

positive: saddsubxls instruction

	saddsubxls	r0, r0, r0
	saddsubxls	r15, r15, r15

positive: saddsubxge instruction

	saddsubxge	r0, r0, r0
	saddsubxge	r15, r15, r15

positive: saddsubxlt instruction

	saddsubxlt	r0, r0, r0
	saddsubxlt	r15, r15, r15

positive: saddsubxgt instruction

	saddsubxgt	r0, r0, r0
	saddsubxgt	r15, r15, r15

positive: saddsubxle instruction

	saddsubxle	r0, r0, r0
	saddsubxle	r15, r15, r15

positive: saddsubxal instruction

	saddsubxal	r0, r0, r0
	saddsubxal	r15, r15, r15

positive: sbc instruction

	sbc	r0, r0, 0
	sbc	r15, r15, 0xff000000
	sbc	r0, r0, r0
	sbc	r15, r15, r15
	sbc	r0, r0, r0, lsl 0
	sbc	r15, r15, r15, lsl 31
	sbc	r0, r0, r0, lsl r0
	sbc	r15, r15, r15, lsl r15
	sbc	r0, r0, r0, lsr 1
	sbc	r15, r15, r15, lsr 32
	sbc	r0, r0, r0, lsr r0
	sbc	r15, r15, r15, asr r15
	sbc	r0, r0, r0, asr 1
	sbc	r15, r15, r15, asr 32
	sbc	r0, r0, r0, asr r0
	sbc	r15, r15, r15, asr r15
	sbc	r0, r0, r0, ror 1
	sbc	r15, r15, r15, ror 31
	sbc	r0, r0, r0, ror r0
	sbc	r15, r15, r15, ror r15
	sbc	r0, r0, r0, rrx

positive: sbceq instruction

	sbceq	r0, r0, 0
	sbceq	r15, r15, 0xff000000
	sbceq	r0, r0, r0
	sbceq	r15, r15, r15
	sbceq	r0, r0, r0, lsl 0
	sbceq	r15, r15, r15, lsl 31
	sbceq	r0, r0, r0, lsl r0
	sbceq	r15, r15, r15, lsl r15
	sbceq	r0, r0, r0, lsr 1
	sbceq	r15, r15, r15, lsr 32
	sbceq	r0, r0, r0, lsr r0
	sbceq	r15, r15, r15, asr r15
	sbceq	r0, r0, r0, asr 1
	sbceq	r15, r15, r15, asr 32
	sbceq	r0, r0, r0, asr r0
	sbceq	r15, r15, r15, asr r15
	sbceq	r0, r0, r0, ror 1
	sbceq	r15, r15, r15, ror 31
	sbceq	r0, r0, r0, ror r0
	sbceq	r15, r15, r15, ror r15
	sbceq	r0, r0, r0, rrx

positive: sbcne instruction

	sbcne	r0, r0, 0
	sbcne	r15, r15, 0xff000000
	sbcne	r0, r0, r0
	sbcne	r15, r15, r15
	sbcne	r0, r0, r0, lsl 0
	sbcne	r15, r15, r15, lsl 31
	sbcne	r0, r0, r0, lsl r0
	sbcne	r15, r15, r15, lsl r15
	sbcne	r0, r0, r0, lsr 1
	sbcne	r15, r15, r15, lsr 32
	sbcne	r0, r0, r0, lsr r0
	sbcne	r15, r15, r15, asr r15
	sbcne	r0, r0, r0, asr 1
	sbcne	r15, r15, r15, asr 32
	sbcne	r0, r0, r0, asr r0
	sbcne	r15, r15, r15, asr r15
	sbcne	r0, r0, r0, ror 1
	sbcne	r15, r15, r15, ror 31
	sbcne	r0, r0, r0, ror r0
	sbcne	r15, r15, r15, ror r15
	sbcne	r0, r0, r0, rrx

positive: sbccs instruction

	sbccs	r0, r0, 0
	sbccs	r15, r15, 0xff000000
	sbccs	r0, r0, r0
	sbccs	r15, r15, r15
	sbccs	r0, r0, r0, lsl 0
	sbccs	r15, r15, r15, lsl 31
	sbccs	r0, r0, r0, lsl r0
	sbccs	r15, r15, r15, lsl r15
	sbccs	r0, r0, r0, lsr 1
	sbccs	r15, r15, r15, lsr 32
	sbccs	r0, r0, r0, lsr r0
	sbccs	r15, r15, r15, asr r15
	sbccs	r0, r0, r0, asr 1
	sbccs	r15, r15, r15, asr 32
	sbccs	r0, r0, r0, asr r0
	sbccs	r15, r15, r15, asr r15
	sbccs	r0, r0, r0, ror 1
	sbccs	r15, r15, r15, ror 31
	sbccs	r0, r0, r0, ror r0
	sbccs	r15, r15, r15, ror r15
	sbccs	r0, r0, r0, rrx

positive: sbchs instruction

	sbchs	r0, r0, 0
	sbchs	r15, r15, 0xff000000
	sbchs	r0, r0, r0
	sbchs	r15, r15, r15
	sbchs	r0, r0, r0, lsl 0
	sbchs	r15, r15, r15, lsl 31
	sbchs	r0, r0, r0, lsl r0
	sbchs	r15, r15, r15, lsl r15
	sbchs	r0, r0, r0, lsr 1
	sbchs	r15, r15, r15, lsr 32
	sbchs	r0, r0, r0, lsr r0
	sbchs	r15, r15, r15, asr r15
	sbchs	r0, r0, r0, asr 1
	sbchs	r15, r15, r15, asr 32
	sbchs	r0, r0, r0, asr r0
	sbchs	r15, r15, r15, asr r15
	sbchs	r0, r0, r0, ror 1
	sbchs	r15, r15, r15, ror 31
	sbchs	r0, r0, r0, ror r0
	sbchs	r15, r15, r15, ror r15
	sbchs	r0, r0, r0, rrx

positive: sbccc instruction

	sbccc	r0, r0, 0
	sbccc	r15, r15, 0xff000000
	sbccc	r0, r0, r0
	sbccc	r15, r15, r15
	sbccc	r0, r0, r0, lsl 0
	sbccc	r15, r15, r15, lsl 31
	sbccc	r0, r0, r0, lsl r0
	sbccc	r15, r15, r15, lsl r15
	sbccc	r0, r0, r0, lsr 1
	sbccc	r15, r15, r15, lsr 32
	sbccc	r0, r0, r0, lsr r0
	sbccc	r15, r15, r15, asr r15
	sbccc	r0, r0, r0, asr 1
	sbccc	r15, r15, r15, asr 32
	sbccc	r0, r0, r0, asr r0
	sbccc	r15, r15, r15, asr r15
	sbccc	r0, r0, r0, ror 1
	sbccc	r15, r15, r15, ror 31
	sbccc	r0, r0, r0, ror r0
	sbccc	r15, r15, r15, ror r15
	sbccc	r0, r0, r0, rrx

positive: sbclo instruction

	sbclo	r0, r0, 0
	sbclo	r15, r15, 0xff000000
	sbclo	r0, r0, r0
	sbclo	r15, r15, r15
	sbclo	r0, r0, r0, lsl 0
	sbclo	r15, r15, r15, lsl 31
	sbclo	r0, r0, r0, lsl r0
	sbclo	r15, r15, r15, lsl r15
	sbclo	r0, r0, r0, lsr 1
	sbclo	r15, r15, r15, lsr 32
	sbclo	r0, r0, r0, lsr r0
	sbclo	r15, r15, r15, asr r15
	sbclo	r0, r0, r0, asr 1
	sbclo	r15, r15, r15, asr 32
	sbclo	r0, r0, r0, asr r0
	sbclo	r15, r15, r15, asr r15
	sbclo	r0, r0, r0, ror 1
	sbclo	r15, r15, r15, ror 31
	sbclo	r0, r0, r0, ror r0
	sbclo	r15, r15, r15, ror r15
	sbclo	r0, r0, r0, rrx

positive: sbcmi instruction

	sbcmi	r0, r0, 0
	sbcmi	r15, r15, 0xff000000
	sbcmi	r0, r0, r0
	sbcmi	r15, r15, r15
	sbcmi	r0, r0, r0, lsl 0
	sbcmi	r15, r15, r15, lsl 31
	sbcmi	r0, r0, r0, lsl r0
	sbcmi	r15, r15, r15, lsl r15
	sbcmi	r0, r0, r0, lsr 1
	sbcmi	r15, r15, r15, lsr 32
	sbcmi	r0, r0, r0, lsr r0
	sbcmi	r15, r15, r15, asr r15
	sbcmi	r0, r0, r0, asr 1
	sbcmi	r15, r15, r15, asr 32
	sbcmi	r0, r0, r0, asr r0
	sbcmi	r15, r15, r15, asr r15
	sbcmi	r0, r0, r0, ror 1
	sbcmi	r15, r15, r15, ror 31
	sbcmi	r0, r0, r0, ror r0
	sbcmi	r15, r15, r15, ror r15
	sbcmi	r0, r0, r0, rrx

positive: sbcpl instruction

	sbcpl	r0, r0, 0
	sbcpl	r15, r15, 0xff000000
	sbcpl	r0, r0, r0
	sbcpl	r15, r15, r15
	sbcpl	r0, r0, r0, lsl 0
	sbcpl	r15, r15, r15, lsl 31
	sbcpl	r0, r0, r0, lsl r0
	sbcpl	r15, r15, r15, lsl r15
	sbcpl	r0, r0, r0, lsr 1
	sbcpl	r15, r15, r15, lsr 32
	sbcpl	r0, r0, r0, lsr r0
	sbcpl	r15, r15, r15, asr r15
	sbcpl	r0, r0, r0, asr 1
	sbcpl	r15, r15, r15, asr 32
	sbcpl	r0, r0, r0, asr r0
	sbcpl	r15, r15, r15, asr r15
	sbcpl	r0, r0, r0, ror 1
	sbcpl	r15, r15, r15, ror 31
	sbcpl	r0, r0, r0, ror r0
	sbcpl	r15, r15, r15, ror r15
	sbcpl	r0, r0, r0, rrx

positive: sbcvs instruction

	sbcvs	r0, r0, 0
	sbcvs	r15, r15, 0xff000000
	sbcvs	r0, r0, r0
	sbcvs	r15, r15, r15
	sbcvs	r0, r0, r0, lsl 0
	sbcvs	r15, r15, r15, lsl 31
	sbcvs	r0, r0, r0, lsl r0
	sbcvs	r15, r15, r15, lsl r15
	sbcvs	r0, r0, r0, lsr 1
	sbcvs	r15, r15, r15, lsr 32
	sbcvs	r0, r0, r0, lsr r0
	sbcvs	r15, r15, r15, asr r15
	sbcvs	r0, r0, r0, asr 1
	sbcvs	r15, r15, r15, asr 32
	sbcvs	r0, r0, r0, asr r0
	sbcvs	r15, r15, r15, asr r15
	sbcvs	r0, r0, r0, ror 1
	sbcvs	r15, r15, r15, ror 31
	sbcvs	r0, r0, r0, ror r0
	sbcvs	r15, r15, r15, ror r15
	sbcvs	r0, r0, r0, rrx

positive: sbcvc instruction

	sbcvc	r0, r0, 0
	sbcvc	r15, r15, 0xff000000
	sbcvc	r0, r0, r0
	sbcvc	r15, r15, r15
	sbcvc	r0, r0, r0, lsl 0
	sbcvc	r15, r15, r15, lsl 31
	sbcvc	r0, r0, r0, lsl r0
	sbcvc	r15, r15, r15, lsl r15
	sbcvc	r0, r0, r0, lsr 1
	sbcvc	r15, r15, r15, lsr 32
	sbcvc	r0, r0, r0, lsr r0
	sbcvc	r15, r15, r15, asr r15
	sbcvc	r0, r0, r0, asr 1
	sbcvc	r15, r15, r15, asr 32
	sbcvc	r0, r0, r0, asr r0
	sbcvc	r15, r15, r15, asr r15
	sbcvc	r0, r0, r0, ror 1
	sbcvc	r15, r15, r15, ror 31
	sbcvc	r0, r0, r0, ror r0
	sbcvc	r15, r15, r15, ror r15
	sbcvc	r0, r0, r0, rrx

positive: sbchi instruction

	sbchi	r0, r0, 0
	sbchi	r15, r15, 0xff000000
	sbchi	r0, r0, r0
	sbchi	r15, r15, r15
	sbchi	r0, r0, r0, lsl 0
	sbchi	r15, r15, r15, lsl 31
	sbchi	r0, r0, r0, lsl r0
	sbchi	r15, r15, r15, lsl r15
	sbchi	r0, r0, r0, lsr 1
	sbchi	r15, r15, r15, lsr 32
	sbchi	r0, r0, r0, lsr r0
	sbchi	r15, r15, r15, asr r15
	sbchi	r0, r0, r0, asr 1
	sbchi	r15, r15, r15, asr 32
	sbchi	r0, r0, r0, asr r0
	sbchi	r15, r15, r15, asr r15
	sbchi	r0, r0, r0, ror 1
	sbchi	r15, r15, r15, ror 31
	sbchi	r0, r0, r0, ror r0
	sbchi	r15, r15, r15, ror r15
	sbchi	r0, r0, r0, rrx

positive: sbcls instruction

	sbcls	r0, r0, 0
	sbcls	r15, r15, 0xff000000
	sbcls	r0, r0, r0
	sbcls	r15, r15, r15
	sbcls	r0, r0, r0, lsl 0
	sbcls	r15, r15, r15, lsl 31
	sbcls	r0, r0, r0, lsl r0
	sbcls	r15, r15, r15, lsl r15
	sbcls	r0, r0, r0, lsr 1
	sbcls	r15, r15, r15, lsr 32
	sbcls	r0, r0, r0, lsr r0
	sbcls	r15, r15, r15, asr r15
	sbcls	r0, r0, r0, asr 1
	sbcls	r15, r15, r15, asr 32
	sbcls	r0, r0, r0, asr r0
	sbcls	r15, r15, r15, asr r15
	sbcls	r0, r0, r0, ror 1
	sbcls	r15, r15, r15, ror 31
	sbcls	r0, r0, r0, ror r0
	sbcls	r15, r15, r15, ror r15
	sbcls	r0, r0, r0, rrx

positive: sbcge instruction

	sbcge	r0, r0, 0
	sbcge	r15, r15, 0xff000000
	sbcge	r0, r0, r0
	sbcge	r15, r15, r15
	sbcge	r0, r0, r0, lsl 0
	sbcge	r15, r15, r15, lsl 31
	sbcge	r0, r0, r0, lsl r0
	sbcge	r15, r15, r15, lsl r15
	sbcge	r0, r0, r0, lsr 1
	sbcge	r15, r15, r15, lsr 32
	sbcge	r0, r0, r0, lsr r0
	sbcge	r15, r15, r15, asr r15
	sbcge	r0, r0, r0, asr 1
	sbcge	r15, r15, r15, asr 32
	sbcge	r0, r0, r0, asr r0
	sbcge	r15, r15, r15, asr r15
	sbcge	r0, r0, r0, ror 1
	sbcge	r15, r15, r15, ror 31
	sbcge	r0, r0, r0, ror r0
	sbcge	r15, r15, r15, ror r15
	sbcge	r0, r0, r0, rrx

positive: sbclt instruction

	sbclt	r0, r0, 0
	sbclt	r15, r15, 0xff000000
	sbclt	r0, r0, r0
	sbclt	r15, r15, r15
	sbclt	r0, r0, r0, lsl 0
	sbclt	r15, r15, r15, lsl 31
	sbclt	r0, r0, r0, lsl r0
	sbclt	r15, r15, r15, lsl r15
	sbclt	r0, r0, r0, lsr 1
	sbclt	r15, r15, r15, lsr 32
	sbclt	r0, r0, r0, lsr r0
	sbclt	r15, r15, r15, asr r15
	sbclt	r0, r0, r0, asr 1
	sbclt	r15, r15, r15, asr 32
	sbclt	r0, r0, r0, asr r0
	sbclt	r15, r15, r15, asr r15
	sbclt	r0, r0, r0, ror 1
	sbclt	r15, r15, r15, ror 31
	sbclt	r0, r0, r0, ror r0
	sbclt	r15, r15, r15, ror r15
	sbclt	r0, r0, r0, rrx

positive: sbcgt instruction

	sbcgt	r0, r0, 0
	sbcgt	r15, r15, 0xff000000
	sbcgt	r0, r0, r0
	sbcgt	r15, r15, r15
	sbcgt	r0, r0, r0, lsl 0
	sbcgt	r15, r15, r15, lsl 31
	sbcgt	r0, r0, r0, lsl r0
	sbcgt	r15, r15, r15, lsl r15
	sbcgt	r0, r0, r0, lsr 1
	sbcgt	r15, r15, r15, lsr 32
	sbcgt	r0, r0, r0, lsr r0
	sbcgt	r15, r15, r15, asr r15
	sbcgt	r0, r0, r0, asr 1
	sbcgt	r15, r15, r15, asr 32
	sbcgt	r0, r0, r0, asr r0
	sbcgt	r15, r15, r15, asr r15
	sbcgt	r0, r0, r0, ror 1
	sbcgt	r15, r15, r15, ror 31
	sbcgt	r0, r0, r0, ror r0
	sbcgt	r15, r15, r15, ror r15
	sbcgt	r0, r0, r0, rrx

positive: sbcle instruction

	sbcle	r0, r0, 0
	sbcle	r15, r15, 0xff000000
	sbcle	r0, r0, r0
	sbcle	r15, r15, r15
	sbcle	r0, r0, r0, lsl 0
	sbcle	r15, r15, r15, lsl 31
	sbcle	r0, r0, r0, lsl r0
	sbcle	r15, r15, r15, lsl r15
	sbcle	r0, r0, r0, lsr 1
	sbcle	r15, r15, r15, lsr 32
	sbcle	r0, r0, r0, lsr r0
	sbcle	r15, r15, r15, asr r15
	sbcle	r0, r0, r0, asr 1
	sbcle	r15, r15, r15, asr 32
	sbcle	r0, r0, r0, asr r0
	sbcle	r15, r15, r15, asr r15
	sbcle	r0, r0, r0, ror 1
	sbcle	r15, r15, r15, ror 31
	sbcle	r0, r0, r0, ror r0
	sbcle	r15, r15, r15, ror r15
	sbcle	r0, r0, r0, rrx

positive: sbcal instruction

	sbcal	r0, r0, 0
	sbcal	r15, r15, 0xff000000
	sbcal	r0, r0, r0
	sbcal	r15, r15, r15
	sbcal	r0, r0, r0, lsl 0
	sbcal	r15, r15, r15, lsl 31
	sbcal	r0, r0, r0, lsl r0
	sbcal	r15, r15, r15, lsl r15
	sbcal	r0, r0, r0, lsr 1
	sbcal	r15, r15, r15, lsr 32
	sbcal	r0, r0, r0, lsr r0
	sbcal	r15, r15, r15, asr r15
	sbcal	r0, r0, r0, asr 1
	sbcal	r15, r15, r15, asr 32
	sbcal	r0, r0, r0, asr r0
	sbcal	r15, r15, r15, asr r15
	sbcal	r0, r0, r0, ror 1
	sbcal	r15, r15, r15, ror 31
	sbcal	r0, r0, r0, ror r0
	sbcal	r15, r15, r15, ror r15
	sbcal	r0, r0, r0, rrx

positive: sbcs instruction

	sbcs	r0, r0, 0
	sbcs	r15, r15, 0xff000000
	sbcs	r0, r0, r0
	sbcs	r15, r15, r15
	sbcs	r0, r0, r0, lsl 0
	sbcs	r15, r15, r15, lsl 31
	sbcs	r0, r0, r0, lsl r0
	sbcs	r15, r15, r15, lsl r15
	sbcs	r0, r0, r0, lsr 1
	sbcs	r15, r15, r15, lsr 32
	sbcs	r0, r0, r0, lsr r0
	sbcs	r15, r15, r15, asr r15
	sbcs	r0, r0, r0, asr 1
	sbcs	r15, r15, r15, asr 32
	sbcs	r0, r0, r0, asr r0
	sbcs	r15, r15, r15, asr r15
	sbcs	r0, r0, r0, ror 1
	sbcs	r15, r15, r15, ror 31
	sbcs	r0, r0, r0, ror r0
	sbcs	r15, r15, r15, ror r15
	sbcs	r0, r0, r0, rrx

positive: sbcseq instruction

	sbcseq	r0, r0, 0
	sbcseq	r15, r15, 0xff000000
	sbcseq	r0, r0, r0
	sbcseq	r15, r15, r15
	sbcseq	r0, r0, r0, lsl 0
	sbcseq	r15, r15, r15, lsl 31
	sbcseq	r0, r0, r0, lsl r0
	sbcseq	r15, r15, r15, lsl r15
	sbcseq	r0, r0, r0, lsr 1
	sbcseq	r15, r15, r15, lsr 32
	sbcseq	r0, r0, r0, lsr r0
	sbcseq	r15, r15, r15, asr r15
	sbcseq	r0, r0, r0, asr 1
	sbcseq	r15, r15, r15, asr 32
	sbcseq	r0, r0, r0, asr r0
	sbcseq	r15, r15, r15, asr r15
	sbcseq	r0, r0, r0, ror 1
	sbcseq	r15, r15, r15, ror 31
	sbcseq	r0, r0, r0, ror r0
	sbcseq	r15, r15, r15, ror r15
	sbcseq	r0, r0, r0, rrx

positive: sbcsne instruction

	sbcsne	r0, r0, 0
	sbcsne	r15, r15, 0xff000000
	sbcsne	r0, r0, r0
	sbcsne	r15, r15, r15
	sbcsne	r0, r0, r0, lsl 0
	sbcsne	r15, r15, r15, lsl 31
	sbcsne	r0, r0, r0, lsl r0
	sbcsne	r15, r15, r15, lsl r15
	sbcsne	r0, r0, r0, lsr 1
	sbcsne	r15, r15, r15, lsr 32
	sbcsne	r0, r0, r0, lsr r0
	sbcsne	r15, r15, r15, asr r15
	sbcsne	r0, r0, r0, asr 1
	sbcsne	r15, r15, r15, asr 32
	sbcsne	r0, r0, r0, asr r0
	sbcsne	r15, r15, r15, asr r15
	sbcsne	r0, r0, r0, ror 1
	sbcsne	r15, r15, r15, ror 31
	sbcsne	r0, r0, r0, ror r0
	sbcsne	r15, r15, r15, ror r15
	sbcsne	r0, r0, r0, rrx

positive: sbcscs instruction

	sbcscs	r0, r0, 0
	sbcscs	r15, r15, 0xff000000
	sbcscs	r0, r0, r0
	sbcscs	r15, r15, r15
	sbcscs	r0, r0, r0, lsl 0
	sbcscs	r15, r15, r15, lsl 31
	sbcscs	r0, r0, r0, lsl r0
	sbcscs	r15, r15, r15, lsl r15
	sbcscs	r0, r0, r0, lsr 1
	sbcscs	r15, r15, r15, lsr 32
	sbcscs	r0, r0, r0, lsr r0
	sbcscs	r15, r15, r15, asr r15
	sbcscs	r0, r0, r0, asr 1
	sbcscs	r15, r15, r15, asr 32
	sbcscs	r0, r0, r0, asr r0
	sbcscs	r15, r15, r15, asr r15
	sbcscs	r0, r0, r0, ror 1
	sbcscs	r15, r15, r15, ror 31
	sbcscs	r0, r0, r0, ror r0
	sbcscs	r15, r15, r15, ror r15
	sbcscs	r0, r0, r0, rrx

positive: sbcshs instruction

	sbcshs	r0, r0, 0
	sbcshs	r15, r15, 0xff000000
	sbcshs	r0, r0, r0
	sbcshs	r15, r15, r15
	sbcshs	r0, r0, r0, lsl 0
	sbcshs	r15, r15, r15, lsl 31
	sbcshs	r0, r0, r0, lsl r0
	sbcshs	r15, r15, r15, lsl r15
	sbcshs	r0, r0, r0, lsr 1
	sbcshs	r15, r15, r15, lsr 32
	sbcshs	r0, r0, r0, lsr r0
	sbcshs	r15, r15, r15, asr r15
	sbcshs	r0, r0, r0, asr 1
	sbcshs	r15, r15, r15, asr 32
	sbcshs	r0, r0, r0, asr r0
	sbcshs	r15, r15, r15, asr r15
	sbcshs	r0, r0, r0, ror 1
	sbcshs	r15, r15, r15, ror 31
	sbcshs	r0, r0, r0, ror r0
	sbcshs	r15, r15, r15, ror r15
	sbcshs	r0, r0, r0, rrx

positive: sbcscc instruction

	sbcscc	r0, r0, 0
	sbcscc	r15, r15, 0xff000000
	sbcscc	r0, r0, r0
	sbcscc	r15, r15, r15
	sbcscc	r0, r0, r0, lsl 0
	sbcscc	r15, r15, r15, lsl 31
	sbcscc	r0, r0, r0, lsl r0
	sbcscc	r15, r15, r15, lsl r15
	sbcscc	r0, r0, r0, lsr 1
	sbcscc	r15, r15, r15, lsr 32
	sbcscc	r0, r0, r0, lsr r0
	sbcscc	r15, r15, r15, asr r15
	sbcscc	r0, r0, r0, asr 1
	sbcscc	r15, r15, r15, asr 32
	sbcscc	r0, r0, r0, asr r0
	sbcscc	r15, r15, r15, asr r15
	sbcscc	r0, r0, r0, ror 1
	sbcscc	r15, r15, r15, ror 31
	sbcscc	r0, r0, r0, ror r0
	sbcscc	r15, r15, r15, ror r15
	sbcscc	r0, r0, r0, rrx

positive: sbcslo instruction

	sbcslo	r0, r0, 0
	sbcslo	r15, r15, 0xff000000
	sbcslo	r0, r0, r0
	sbcslo	r15, r15, r15
	sbcslo	r0, r0, r0, lsl 0
	sbcslo	r15, r15, r15, lsl 31
	sbcslo	r0, r0, r0, lsl r0
	sbcslo	r15, r15, r15, lsl r15
	sbcslo	r0, r0, r0, lsr 1
	sbcslo	r15, r15, r15, lsr 32
	sbcslo	r0, r0, r0, lsr r0
	sbcslo	r15, r15, r15, asr r15
	sbcslo	r0, r0, r0, asr 1
	sbcslo	r15, r15, r15, asr 32
	sbcslo	r0, r0, r0, asr r0
	sbcslo	r15, r15, r15, asr r15
	sbcslo	r0, r0, r0, ror 1
	sbcslo	r15, r15, r15, ror 31
	sbcslo	r0, r0, r0, ror r0
	sbcslo	r15, r15, r15, ror r15
	sbcslo	r0, r0, r0, rrx

positive: sbcsmi instruction

	sbcsmi	r0, r0, 0
	sbcsmi	r15, r15, 0xff000000
	sbcsmi	r0, r0, r0
	sbcsmi	r15, r15, r15
	sbcsmi	r0, r0, r0, lsl 0
	sbcsmi	r15, r15, r15, lsl 31
	sbcsmi	r0, r0, r0, lsl r0
	sbcsmi	r15, r15, r15, lsl r15
	sbcsmi	r0, r0, r0, lsr 1
	sbcsmi	r15, r15, r15, lsr 32
	sbcsmi	r0, r0, r0, lsr r0
	sbcsmi	r15, r15, r15, asr r15
	sbcsmi	r0, r0, r0, asr 1
	sbcsmi	r15, r15, r15, asr 32
	sbcsmi	r0, r0, r0, asr r0
	sbcsmi	r15, r15, r15, asr r15
	sbcsmi	r0, r0, r0, ror 1
	sbcsmi	r15, r15, r15, ror 31
	sbcsmi	r0, r0, r0, ror r0
	sbcsmi	r15, r15, r15, ror r15
	sbcsmi	r0, r0, r0, rrx

positive: sbcspl instruction

	sbcspl	r0, r0, 0
	sbcspl	r15, r15, 0xff000000
	sbcspl	r0, r0, r0
	sbcspl	r15, r15, r15
	sbcspl	r0, r0, r0, lsl 0
	sbcspl	r15, r15, r15, lsl 31
	sbcspl	r0, r0, r0, lsl r0
	sbcspl	r15, r15, r15, lsl r15
	sbcspl	r0, r0, r0, lsr 1
	sbcspl	r15, r15, r15, lsr 32
	sbcspl	r0, r0, r0, lsr r0
	sbcspl	r15, r15, r15, asr r15
	sbcspl	r0, r0, r0, asr 1
	sbcspl	r15, r15, r15, asr 32
	sbcspl	r0, r0, r0, asr r0
	sbcspl	r15, r15, r15, asr r15
	sbcspl	r0, r0, r0, ror 1
	sbcspl	r15, r15, r15, ror 31
	sbcspl	r0, r0, r0, ror r0
	sbcspl	r15, r15, r15, ror r15
	sbcspl	r0, r0, r0, rrx

positive: sbcsvs instruction

	sbcsvs	r0, r0, 0
	sbcsvs	r15, r15, 0xff000000
	sbcsvs	r0, r0, r0
	sbcsvs	r15, r15, r15
	sbcsvs	r0, r0, r0, lsl 0
	sbcsvs	r15, r15, r15, lsl 31
	sbcsvs	r0, r0, r0, lsl r0
	sbcsvs	r15, r15, r15, lsl r15
	sbcsvs	r0, r0, r0, lsr 1
	sbcsvs	r15, r15, r15, lsr 32
	sbcsvs	r0, r0, r0, lsr r0
	sbcsvs	r15, r15, r15, asr r15
	sbcsvs	r0, r0, r0, asr 1
	sbcsvs	r15, r15, r15, asr 32
	sbcsvs	r0, r0, r0, asr r0
	sbcsvs	r15, r15, r15, asr r15
	sbcsvs	r0, r0, r0, ror 1
	sbcsvs	r15, r15, r15, ror 31
	sbcsvs	r0, r0, r0, ror r0
	sbcsvs	r15, r15, r15, ror r15
	sbcsvs	r0, r0, r0, rrx

positive: sbcsvc instruction

	sbcsvc	r0, r0, 0
	sbcsvc	r15, r15, 0xff000000
	sbcsvc	r0, r0, r0
	sbcsvc	r15, r15, r15
	sbcsvc	r0, r0, r0, lsl 0
	sbcsvc	r15, r15, r15, lsl 31
	sbcsvc	r0, r0, r0, lsl r0
	sbcsvc	r15, r15, r15, lsl r15
	sbcsvc	r0, r0, r0, lsr 1
	sbcsvc	r15, r15, r15, lsr 32
	sbcsvc	r0, r0, r0, lsr r0
	sbcsvc	r15, r15, r15, asr r15
	sbcsvc	r0, r0, r0, asr 1
	sbcsvc	r15, r15, r15, asr 32
	sbcsvc	r0, r0, r0, asr r0
	sbcsvc	r15, r15, r15, asr r15
	sbcsvc	r0, r0, r0, ror 1
	sbcsvc	r15, r15, r15, ror 31
	sbcsvc	r0, r0, r0, ror r0
	sbcsvc	r15, r15, r15, ror r15
	sbcsvc	r0, r0, r0, rrx

positive: sbcshi instruction

	sbcshi	r0, r0, 0
	sbcshi	r15, r15, 0xff000000
	sbcshi	r0, r0, r0
	sbcshi	r15, r15, r15
	sbcshi	r0, r0, r0, lsl 0
	sbcshi	r15, r15, r15, lsl 31
	sbcshi	r0, r0, r0, lsl r0
	sbcshi	r15, r15, r15, lsl r15
	sbcshi	r0, r0, r0, lsr 1
	sbcshi	r15, r15, r15, lsr 32
	sbcshi	r0, r0, r0, lsr r0
	sbcshi	r15, r15, r15, asr r15
	sbcshi	r0, r0, r0, asr 1
	sbcshi	r15, r15, r15, asr 32
	sbcshi	r0, r0, r0, asr r0
	sbcshi	r15, r15, r15, asr r15
	sbcshi	r0, r0, r0, ror 1
	sbcshi	r15, r15, r15, ror 31
	sbcshi	r0, r0, r0, ror r0
	sbcshi	r15, r15, r15, ror r15
	sbcshi	r0, r0, r0, rrx

positive: sbcsls instruction

	sbcsls	r0, r0, 0
	sbcsls	r15, r15, 0xff000000
	sbcsls	r0, r0, r0
	sbcsls	r15, r15, r15
	sbcsls	r0, r0, r0, lsl 0
	sbcsls	r15, r15, r15, lsl 31
	sbcsls	r0, r0, r0, lsl r0
	sbcsls	r15, r15, r15, lsl r15
	sbcsls	r0, r0, r0, lsr 1
	sbcsls	r15, r15, r15, lsr 32
	sbcsls	r0, r0, r0, lsr r0
	sbcsls	r15, r15, r15, asr r15
	sbcsls	r0, r0, r0, asr 1
	sbcsls	r15, r15, r15, asr 32
	sbcsls	r0, r0, r0, asr r0
	sbcsls	r15, r15, r15, asr r15
	sbcsls	r0, r0, r0, ror 1
	sbcsls	r15, r15, r15, ror 31
	sbcsls	r0, r0, r0, ror r0
	sbcsls	r15, r15, r15, ror r15
	sbcsls	r0, r0, r0, rrx

positive: sbcsge instruction

	sbcsge	r0, r0, 0
	sbcsge	r15, r15, 0xff000000
	sbcsge	r0, r0, r0
	sbcsge	r15, r15, r15
	sbcsge	r0, r0, r0, lsl 0
	sbcsge	r15, r15, r15, lsl 31
	sbcsge	r0, r0, r0, lsl r0
	sbcsge	r15, r15, r15, lsl r15
	sbcsge	r0, r0, r0, lsr 1
	sbcsge	r15, r15, r15, lsr 32
	sbcsge	r0, r0, r0, lsr r0
	sbcsge	r15, r15, r15, asr r15
	sbcsge	r0, r0, r0, asr 1
	sbcsge	r15, r15, r15, asr 32
	sbcsge	r0, r0, r0, asr r0
	sbcsge	r15, r15, r15, asr r15
	sbcsge	r0, r0, r0, ror 1
	sbcsge	r15, r15, r15, ror 31
	sbcsge	r0, r0, r0, ror r0
	sbcsge	r15, r15, r15, ror r15
	sbcsge	r0, r0, r0, rrx

positive: sbcslt instruction

	sbcslt	r0, r0, 0
	sbcslt	r15, r15, 0xff000000
	sbcslt	r0, r0, r0
	sbcslt	r15, r15, r15
	sbcslt	r0, r0, r0, lsl 0
	sbcslt	r15, r15, r15, lsl 31
	sbcslt	r0, r0, r0, lsl r0
	sbcslt	r15, r15, r15, lsl r15
	sbcslt	r0, r0, r0, lsr 1
	sbcslt	r15, r15, r15, lsr 32
	sbcslt	r0, r0, r0, lsr r0
	sbcslt	r15, r15, r15, asr r15
	sbcslt	r0, r0, r0, asr 1
	sbcslt	r15, r15, r15, asr 32
	sbcslt	r0, r0, r0, asr r0
	sbcslt	r15, r15, r15, asr r15
	sbcslt	r0, r0, r0, ror 1
	sbcslt	r15, r15, r15, ror 31
	sbcslt	r0, r0, r0, ror r0
	sbcslt	r15, r15, r15, ror r15
	sbcslt	r0, r0, r0, rrx

positive: sbcsgt instruction

	sbcsgt	r0, r0, 0
	sbcsgt	r15, r15, 0xff000000
	sbcsgt	r0, r0, r0
	sbcsgt	r15, r15, r15
	sbcsgt	r0, r0, r0, lsl 0
	sbcsgt	r15, r15, r15, lsl 31
	sbcsgt	r0, r0, r0, lsl r0
	sbcsgt	r15, r15, r15, lsl r15
	sbcsgt	r0, r0, r0, lsr 1
	sbcsgt	r15, r15, r15, lsr 32
	sbcsgt	r0, r0, r0, lsr r0
	sbcsgt	r15, r15, r15, asr r15
	sbcsgt	r0, r0, r0, asr 1
	sbcsgt	r15, r15, r15, asr 32
	sbcsgt	r0, r0, r0, asr r0
	sbcsgt	r15, r15, r15, asr r15
	sbcsgt	r0, r0, r0, ror 1
	sbcsgt	r15, r15, r15, ror 31
	sbcsgt	r0, r0, r0, ror r0
	sbcsgt	r15, r15, r15, ror r15
	sbcsgt	r0, r0, r0, rrx

positive: sbcsle instruction

	sbcsle	r0, r0, 0
	sbcsle	r15, r15, 0xff000000
	sbcsle	r0, r0, r0
	sbcsle	r15, r15, r15
	sbcsle	r0, r0, r0, lsl 0
	sbcsle	r15, r15, r15, lsl 31
	sbcsle	r0, r0, r0, lsl r0
	sbcsle	r15, r15, r15, lsl r15
	sbcsle	r0, r0, r0, lsr 1
	sbcsle	r15, r15, r15, lsr 32
	sbcsle	r0, r0, r0, lsr r0
	sbcsle	r15, r15, r15, asr r15
	sbcsle	r0, r0, r0, asr 1
	sbcsle	r15, r15, r15, asr 32
	sbcsle	r0, r0, r0, asr r0
	sbcsle	r15, r15, r15, asr r15
	sbcsle	r0, r0, r0, ror 1
	sbcsle	r15, r15, r15, ror 31
	sbcsle	r0, r0, r0, ror r0
	sbcsle	r15, r15, r15, ror r15
	sbcsle	r0, r0, r0, rrx

positive: sbcsal instruction

	sbcsal	r0, r0, 0
	sbcsal	r15, r15, 0xff000000
	sbcsal	r0, r0, r0
	sbcsal	r15, r15, r15
	sbcsal	r0, r0, r0, lsl 0
	sbcsal	r15, r15, r15, lsl 31
	sbcsal	r0, r0, r0, lsl r0
	sbcsal	r15, r15, r15, lsl r15
	sbcsal	r0, r0, r0, lsr 1
	sbcsal	r15, r15, r15, lsr 32
	sbcsal	r0, r0, r0, lsr r0
	sbcsal	r15, r15, r15, asr r15
	sbcsal	r0, r0, r0, asr 1
	sbcsal	r15, r15, r15, asr 32
	sbcsal	r0, r0, r0, asr r0
	sbcsal	r15, r15, r15, asr r15
	sbcsal	r0, r0, r0, ror 1
	sbcsal	r15, r15, r15, ror 31
	sbcsal	r0, r0, r0, ror r0
	sbcsal	r15, r15, r15, ror r15
	sbcsal	r0, r0, r0, rrx

positive: sel instruction

	sel	r0, r0, r0
	sel	r15, r15, r15

positive: seleq instruction

	seleq	r0, r0, r0
	seleq	r15, r15, r15

positive: selne instruction

	selne	r0, r0, r0
	selne	r15, r15, r15

positive: selcs instruction

	selcs	r0, r0, r0
	selcs	r15, r15, r15

positive: selhs instruction

	selhs	r0, r0, r0
	selhs	r15, r15, r15

positive: selcc instruction

	selcc	r0, r0, r0
	selcc	r15, r15, r15

positive: sello instruction

	sello	r0, r0, r0
	sello	r15, r15, r15

positive: selmi instruction

	selmi	r0, r0, r0
	selmi	r15, r15, r15

positive: selpl instruction

	selpl	r0, r0, r0
	selpl	r15, r15, r15

positive: selvs instruction

	selvs	r0, r0, r0
	selvs	r15, r15, r15

positive: selvc instruction

	selvc	r0, r0, r0
	selvc	r15, r15, r15

positive: selhi instruction

	selhi	r0, r0, r0
	selhi	r15, r15, r15

positive: sells instruction

	sells	r0, r0, r0
	sells	r15, r15, r15

positive: selge instruction

	selge	r0, r0, r0
	selge	r15, r15, r15

positive: sellt instruction

	sellt	r0, r0, r0
	sellt	r15, r15, r15

positive: selgt instruction

	selgt	r0, r0, r0
	selgt	r15, r15, r15

positive: selle instruction

	selle	r0, r0, r0
	selle	r15, r15, r15

positive: selal instruction

	selal	r0, r0, r0
	selal	r15, r15, r15

positive: setendbe instruction

	setendbe

positive: setendle instruction

	setendle

positive: sev instruction

	sev

positive: seveq instruction

	seveq

positive: sevne instruction

	sevne

positive: sevcs instruction

	sevcs

positive: sevhs instruction

	sevhs

positive: sevcc instruction

	sevcc

positive: sevlo instruction

	sevlo

positive: sevmi instruction

	sevmi

positive: sevpl instruction

	sevpl

positive: sevvs instruction

	sevvs

positive: sevvc instruction

	sevvc

positive: sevhi instruction

	sevhi

positive: sevls instruction

	sevls

positive: sevge instruction

	sevge

positive: sevlt instruction

	sevlt

positive: sevgt instruction

	sevgt

positive: sevle instruction

	sevle

positive: seval instruction

	seval

positive: shadd16 instruction

	shadd16	r0, r0, r0
	shadd16	r15, r15, r15

positive: shadd16eq instruction

	shadd16eq	r0, r0, r0
	shadd16eq	r15, r15, r15

positive: shadd16ne instruction

	shadd16ne	r0, r0, r0
	shadd16ne	r15, r15, r15

positive: shadd16cs instruction

	shadd16cs	r0, r0, r0
	shadd16cs	r15, r15, r15

positive: shadd16hs instruction

	shadd16hs	r0, r0, r0
	shadd16hs	r15, r15, r15

positive: shadd16cc instruction

	shadd16cc	r0, r0, r0
	shadd16cc	r15, r15, r15

positive: shadd16lo instruction

	shadd16lo	r0, r0, r0
	shadd16lo	r15, r15, r15

positive: shadd16mi instruction

	shadd16mi	r0, r0, r0
	shadd16mi	r15, r15, r15

positive: shadd16pl instruction

	shadd16pl	r0, r0, r0
	shadd16pl	r15, r15, r15

positive: shadd16vs instruction

	shadd16vs	r0, r0, r0
	shadd16vs	r15, r15, r15

positive: shadd16vc instruction

	shadd16vc	r0, r0, r0
	shadd16vc	r15, r15, r15

positive: shadd16hi instruction

	shadd16hi	r0, r0, r0
	shadd16hi	r15, r15, r15

positive: shadd16ls instruction

	shadd16ls	r0, r0, r0
	shadd16ls	r15, r15, r15

positive: shadd16ge instruction

	shadd16ge	r0, r0, r0
	shadd16ge	r15, r15, r15

positive: shadd16lt instruction

	shadd16lt	r0, r0, r0
	shadd16lt	r15, r15, r15

positive: shadd16gt instruction

	shadd16gt	r0, r0, r0
	shadd16gt	r15, r15, r15

positive: shadd16le instruction

	shadd16le	r0, r0, r0
	shadd16le	r15, r15, r15

positive: shadd16al instruction

	shadd16al	r0, r0, r0
	shadd16al	r15, r15, r15

positive: shadd8 instruction

	shadd8	r0, r0, r0
	shadd8	r15, r15, r15

positive: shadd8eq instruction

	shadd8eq	r0, r0, r0
	shadd8eq	r15, r15, r15

positive: shadd8ne instruction

	shadd8ne	r0, r0, r0
	shadd8ne	r15, r15, r15

positive: shadd8cs instruction

	shadd8cs	r0, r0, r0
	shadd8cs	r15, r15, r15

positive: shadd8hs instruction

	shadd8hs	r0, r0, r0
	shadd8hs	r15, r15, r15

positive: shadd8cc instruction

	shadd8cc	r0, r0, r0
	shadd8cc	r15, r15, r15

positive: shadd8lo instruction

	shadd8lo	r0, r0, r0
	shadd8lo	r15, r15, r15

positive: shadd8mi instruction

	shadd8mi	r0, r0, r0
	shadd8mi	r15, r15, r15

positive: shadd8pl instruction

	shadd8pl	r0, r0, r0
	shadd8pl	r15, r15, r15

positive: shadd8vs instruction

	shadd8vs	r0, r0, r0
	shadd8vs	r15, r15, r15

positive: shadd8vc instruction

	shadd8vc	r0, r0, r0
	shadd8vc	r15, r15, r15

positive: shadd8hi instruction

	shadd8hi	r0, r0, r0
	shadd8hi	r15, r15, r15

positive: shadd8ls instruction

	shadd8ls	r0, r0, r0
	shadd8ls	r15, r15, r15

positive: shadd8ge instruction

	shadd8ge	r0, r0, r0
	shadd8ge	r15, r15, r15

positive: shadd8lt instruction

	shadd8lt	r0, r0, r0
	shadd8lt	r15, r15, r15

positive: shadd8gt instruction

	shadd8gt	r0, r0, r0
	shadd8gt	r15, r15, r15

positive: shadd8le instruction

	shadd8le	r0, r0, r0
	shadd8le	r15, r15, r15

positive: shadd8al instruction

	shadd8al	r0, r0, r0
	shadd8al	r15, r15, r15

positive: shaddsubx instruction

	shaddsubx	r0, r0, r0
	shaddsubx	r15, r15, r15

positive: shaddsubxeq instruction

	shaddsubxeq	r0, r0, r0
	shaddsubxeq	r15, r15, r15

positive: shaddsubxne instruction

	shaddsubxne	r0, r0, r0
	shaddsubxne	r15, r15, r15

positive: shaddsubxcs instruction

	shaddsubxcs	r0, r0, r0
	shaddsubxcs	r15, r15, r15

positive: shaddsubxhs instruction

	shaddsubxhs	r0, r0, r0
	shaddsubxhs	r15, r15, r15

positive: shaddsubxcc instruction

	shaddsubxcc	r0, r0, r0
	shaddsubxcc	r15, r15, r15

positive: shaddsubxlo instruction

	shaddsubxlo	r0, r0, r0
	shaddsubxlo	r15, r15, r15

positive: shaddsubxmi instruction

	shaddsubxmi	r0, r0, r0
	shaddsubxmi	r15, r15, r15

positive: shaddsubxpl instruction

	shaddsubxpl	r0, r0, r0
	shaddsubxpl	r15, r15, r15

positive: shaddsubxvs instruction

	shaddsubxvs	r0, r0, r0
	shaddsubxvs	r15, r15, r15

positive: shaddsubxvc instruction

	shaddsubxvc	r0, r0, r0
	shaddsubxvc	r15, r15, r15

positive: shaddsubxhi instruction

	shaddsubxhi	r0, r0, r0
	shaddsubxhi	r15, r15, r15

positive: shaddsubxls instruction

	shaddsubxls	r0, r0, r0
	shaddsubxls	r15, r15, r15

positive: shaddsubxge instruction

	shaddsubxge	r0, r0, r0
	shaddsubxge	r15, r15, r15

positive: shaddsubxlt instruction

	shaddsubxlt	r0, r0, r0
	shaddsubxlt	r15, r15, r15

positive: shaddsubxgt instruction

	shaddsubxgt	r0, r0, r0
	shaddsubxgt	r15, r15, r15

positive: shaddsubxle instruction

	shaddsubxle	r0, r0, r0
	shaddsubxle	r15, r15, r15

positive: shaddsubxal instruction

	shaddsubxal	r0, r0, r0
	shaddsubxal	r15, r15, r15

positive: shsub16 instruction

	shsub16	r0, r0, r0
	shsub16	r15, r15, r15

positive: shsub16eq instruction

	shsub16eq	r0, r0, r0
	shsub16eq	r15, r15, r15

positive: shsub16ne instruction

	shsub16ne	r0, r0, r0
	shsub16ne	r15, r15, r15

positive: shsub16cs instruction

	shsub16cs	r0, r0, r0
	shsub16cs	r15, r15, r15

positive: shsub16hs instruction

	shsub16hs	r0, r0, r0
	shsub16hs	r15, r15, r15

positive: shsub16cc instruction

	shsub16cc	r0, r0, r0
	shsub16cc	r15, r15, r15

positive: shsub16lo instruction

	shsub16lo	r0, r0, r0
	shsub16lo	r15, r15, r15

positive: shsub16mi instruction

	shsub16mi	r0, r0, r0
	shsub16mi	r15, r15, r15

positive: shsub16pl instruction

	shsub16pl	r0, r0, r0
	shsub16pl	r15, r15, r15

positive: shsub16vs instruction

	shsub16vs	r0, r0, r0
	shsub16vs	r15, r15, r15

positive: shsub16vc instruction

	shsub16vc	r0, r0, r0
	shsub16vc	r15, r15, r15

positive: shsub16hi instruction

	shsub16hi	r0, r0, r0
	shsub16hi	r15, r15, r15

positive: shsub16ls instruction

	shsub16ls	r0, r0, r0
	shsub16ls	r15, r15, r15

positive: shsub16ge instruction

	shsub16ge	r0, r0, r0
	shsub16ge	r15, r15, r15

positive: shsub16lt instruction

	shsub16lt	r0, r0, r0
	shsub16lt	r15, r15, r15

positive: shsub16gt instruction

	shsub16gt	r0, r0, r0
	shsub16gt	r15, r15, r15

positive: shsub16le instruction

	shsub16le	r0, r0, r0
	shsub16le	r15, r15, r15

positive: shsub16al instruction

	shsub16al	r0, r0, r0
	shsub16al	r15, r15, r15

positive: shsub8 instruction

	shsub8	r0, r0, r0
	shsub8	r15, r15, r15

positive: shsub8eq instruction

	shsub8eq	r0, r0, r0
	shsub8eq	r15, r15, r15

positive: shsub8ne instruction

	shsub8ne	r0, r0, r0
	shsub8ne	r15, r15, r15

positive: shsub8cs instruction

	shsub8cs	r0, r0, r0
	shsub8cs	r15, r15, r15

positive: shsub8hs instruction

	shsub8hs	r0, r0, r0
	shsub8hs	r15, r15, r15

positive: shsub8cc instruction

	shsub8cc	r0, r0, r0
	shsub8cc	r15, r15, r15

positive: shsub8lo instruction

	shsub8lo	r0, r0, r0
	shsub8lo	r15, r15, r15

positive: shsub8mi instruction

	shsub8mi	r0, r0, r0
	shsub8mi	r15, r15, r15

positive: shsub8pl instruction

	shsub8pl	r0, r0, r0
	shsub8pl	r15, r15, r15

positive: shsub8vs instruction

	shsub8vs	r0, r0, r0
	shsub8vs	r15, r15, r15

positive: shsub8vc instruction

	shsub8vc	r0, r0, r0
	shsub8vc	r15, r15, r15

positive: shsub8hi instruction

	shsub8hi	r0, r0, r0
	shsub8hi	r15, r15, r15

positive: shsub8ls instruction

	shsub8ls	r0, r0, r0
	shsub8ls	r15, r15, r15

positive: shsub8ge instruction

	shsub8ge	r0, r0, r0
	shsub8ge	r15, r15, r15

positive: shsub8lt instruction

	shsub8lt	r0, r0, r0
	shsub8lt	r15, r15, r15

positive: shsub8gt instruction

	shsub8gt	r0, r0, r0
	shsub8gt	r15, r15, r15

positive: shsub8le instruction

	shsub8le	r0, r0, r0
	shsub8le	r15, r15, r15

positive: shsub8al instruction

	shsub8al	r0, r0, r0
	shsub8al	r15, r15, r15

positive: shsubaddx instruction

	shsubaddx	r0, r0, r0
	shsubaddx	r15, r15, r15

positive: shsubaddxeq instruction

	shsubaddxeq	r0, r0, r0
	shsubaddxeq	r15, r15, r15

positive: shsubaddxne instruction

	shsubaddxne	r0, r0, r0
	shsubaddxne	r15, r15, r15

positive: shsubaddxcs instruction

	shsubaddxcs	r0, r0, r0
	shsubaddxcs	r15, r15, r15

positive: shsubaddxhs instruction

	shsubaddxhs	r0, r0, r0
	shsubaddxhs	r15, r15, r15

positive: shsubaddxcc instruction

	shsubaddxcc	r0, r0, r0
	shsubaddxcc	r15, r15, r15

positive: shsubaddxlo instruction

	shsubaddxlo	r0, r0, r0
	shsubaddxlo	r15, r15, r15

positive: shsubaddxmi instruction

	shsubaddxmi	r0, r0, r0
	shsubaddxmi	r15, r15, r15

positive: shsubaddxpl instruction

	shsubaddxpl	r0, r0, r0
	shsubaddxpl	r15, r15, r15

positive: shsubaddxvs instruction

	shsubaddxvs	r0, r0, r0
	shsubaddxvs	r15, r15, r15

positive: shsubaddxvc instruction

	shsubaddxvc	r0, r0, r0
	shsubaddxvc	r15, r15, r15

positive: shsubaddxhi instruction

	shsubaddxhi	r0, r0, r0
	shsubaddxhi	r15, r15, r15

positive: shsubaddxls instruction

	shsubaddxls	r0, r0, r0
	shsubaddxls	r15, r15, r15

positive: shsubaddxge instruction

	shsubaddxge	r0, r0, r0
	shsubaddxge	r15, r15, r15

positive: shsubaddxlt instruction

	shsubaddxlt	r0, r0, r0
	shsubaddxlt	r15, r15, r15

positive: shsubaddxgt instruction

	shsubaddxgt	r0, r0, r0
	shsubaddxgt	r15, r15, r15

positive: shsubaddxle instruction

	shsubaddxle	r0, r0, r0
	shsubaddxle	r15, r15, r15

positive: shsubaddxal instruction

	shsubaddxal	r0, r0, r0
	shsubaddxal	r15, r15, r15

positive: smlabb instruction

	smlabb	r0, r0, r0, r0
	smlabb	r15, r15, r15, r15

positive: smlabbeq instruction

	smlabbeq	r0, r0, r0, r0
	smlabbeq	r15, r15, r15, r15

positive: smlabbne instruction

	smlabbne	r0, r0, r0, r0
	smlabbne	r15, r15, r15, r15

positive: smlabbcs instruction

	smlabbcs	r0, r0, r0, r0
	smlabbcs	r15, r15, r15, r15

positive: smlabbhs instruction

	smlabbhs	r0, r0, r0, r0
	smlabbhs	r15, r15, r15, r15

positive: smlabbcc instruction

	smlabbcc	r0, r0, r0, r0
	smlabbcc	r15, r15, r15, r15

positive: smlabblo instruction

	smlabblo	r0, r0, r0, r0
	smlabblo	r15, r15, r15, r15

positive: smlabbmi instruction

	smlabbmi	r0, r0, r0, r0
	smlabbmi	r15, r15, r15, r15

positive: smlabbpl instruction

	smlabbpl	r0, r0, r0, r0
	smlabbpl	r15, r15, r15, r15

positive: smlabbvs instruction

	smlabbvs	r0, r0, r0, r0
	smlabbvs	r15, r15, r15, r15

positive: smlabbvc instruction

	smlabbvc	r0, r0, r0, r0
	smlabbvc	r15, r15, r15, r15

positive: smlabbhi instruction

	smlabbhi	r0, r0, r0, r0
	smlabbhi	r15, r15, r15, r15

positive: smlabbls instruction

	smlabbls	r0, r0, r0, r0
	smlabbls	r15, r15, r15, r15

positive: smlabbge instruction

	smlabbge	r0, r0, r0, r0
	smlabbge	r15, r15, r15, r15

positive: smlabblt instruction

	smlabblt	r0, r0, r0, r0
	smlabblt	r15, r15, r15, r15

positive: smlabbgt instruction

	smlabbgt	r0, r0, r0, r0
	smlabbgt	r15, r15, r15, r15

positive: smlabble instruction

	smlabble	r0, r0, r0, r0
	smlabble	r15, r15, r15, r15

positive: smlabbal instruction

	smlabbal	r0, r0, r0, r0
	smlabbal	r15, r15, r15, r15

positive: smlabt instruction

	smlabt	r0, r0, r0, r0
	smlabt	r15, r15, r15, r15

positive: smlabteq instruction

	smlabteq	r0, r0, r0, r0
	smlabteq	r15, r15, r15, r15

positive: smlabtne instruction

	smlabtne	r0, r0, r0, r0
	smlabtne	r15, r15, r15, r15

positive: smlabtcs instruction

	smlabtcs	r0, r0, r0, r0
	smlabtcs	r15, r15, r15, r15

positive: smlabths instruction

	smlabths	r0, r0, r0, r0
	smlabths	r15, r15, r15, r15

positive: smlabtcc instruction

	smlabtcc	r0, r0, r0, r0
	smlabtcc	r15, r15, r15, r15

positive: smlabtlo instruction

	smlabtlo	r0, r0, r0, r0
	smlabtlo	r15, r15, r15, r15

positive: smlabtmi instruction

	smlabtmi	r0, r0, r0, r0
	smlabtmi	r15, r15, r15, r15

positive: smlabtpl instruction

	smlabtpl	r0, r0, r0, r0
	smlabtpl	r15, r15, r15, r15

positive: smlabtvs instruction

	smlabtvs	r0, r0, r0, r0
	smlabtvs	r15, r15, r15, r15

positive: smlabtvc instruction

	smlabtvc	r0, r0, r0, r0
	smlabtvc	r15, r15, r15, r15

positive: smlabthi instruction

	smlabthi	r0, r0, r0, r0
	smlabthi	r15, r15, r15, r15

positive: smlabtls instruction

	smlabtls	r0, r0, r0, r0
	smlabtls	r15, r15, r15, r15

positive: smlabtge instruction

	smlabtge	r0, r0, r0, r0
	smlabtge	r15, r15, r15, r15

positive: smlabtlt instruction

	smlabtlt	r0, r0, r0, r0
	smlabtlt	r15, r15, r15, r15

positive: smlabtgt instruction

	smlabtgt	r0, r0, r0, r0
	smlabtgt	r15, r15, r15, r15

positive: smlabtle instruction

	smlabtle	r0, r0, r0, r0
	smlabtle	r15, r15, r15, r15

positive: smlabtal instruction

	smlabtal	r0, r0, r0, r0
	smlabtal	r15, r15, r15, r15

positive: smlatb instruction

	smlatb	r0, r0, r0, r0
	smlatb	r15, r15, r15, r15

positive: smlatbeq instruction

	smlatbeq	r0, r0, r0, r0
	smlatbeq	r15, r15, r15, r15

positive: smlatbne instruction

	smlatbne	r0, r0, r0, r0
	smlatbne	r15, r15, r15, r15

positive: smlatbcs instruction

	smlatbcs	r0, r0, r0, r0
	smlatbcs	r15, r15, r15, r15

positive: smlatbhs instruction

	smlatbhs	r0, r0, r0, r0
	smlatbhs	r15, r15, r15, r15

positive: smlatbcc instruction

	smlatbcc	r0, r0, r0, r0
	smlatbcc	r15, r15, r15, r15

positive: smlatblo instruction

	smlatblo	r0, r0, r0, r0
	smlatblo	r15, r15, r15, r15

positive: smlatbmi instruction

	smlatbmi	r0, r0, r0, r0
	smlatbmi	r15, r15, r15, r15

positive: smlatbpl instruction

	smlatbpl	r0, r0, r0, r0
	smlatbpl	r15, r15, r15, r15

positive: smlatbvs instruction

	smlatbvs	r0, r0, r0, r0
	smlatbvs	r15, r15, r15, r15

positive: smlatbvc instruction

	smlatbvc	r0, r0, r0, r0
	smlatbvc	r15, r15, r15, r15

positive: smlatbhi instruction

	smlatbhi	r0, r0, r0, r0
	smlatbhi	r15, r15, r15, r15

positive: smlatbls instruction

	smlatbls	r0, r0, r0, r0
	smlatbls	r15, r15, r15, r15

positive: smlatbge instruction

	smlatbge	r0, r0, r0, r0
	smlatbge	r15, r15, r15, r15

positive: smlatblt instruction

	smlatblt	r0, r0, r0, r0
	smlatblt	r15, r15, r15, r15

positive: smlatbgt instruction

	smlatbgt	r0, r0, r0, r0
	smlatbgt	r15, r15, r15, r15

positive: smlatble instruction

	smlatble	r0, r0, r0, r0
	smlatble	r15, r15, r15, r15

positive: smlatbal instruction

	smlatbal	r0, r0, r0, r0
	smlatbal	r15, r15, r15, r15

positive: smlatt instruction

	smlatt	r0, r0, r0, r0
	smlatt	r15, r15, r15, r15

positive: smlatteq instruction

	smlatteq	r0, r0, r0, r0
	smlatteq	r15, r15, r15, r15

positive: smlattne instruction

	smlattne	r0, r0, r0, r0
	smlattne	r15, r15, r15, r15

positive: smlattcs instruction

	smlattcs	r0, r0, r0, r0
	smlattcs	r15, r15, r15, r15

positive: smlatths instruction

	smlatths	r0, r0, r0, r0
	smlatths	r15, r15, r15, r15

positive: smlattcc instruction

	smlattcc	r0, r0, r0, r0
	smlattcc	r15, r15, r15, r15

positive: smlattlo instruction

	smlattlo	r0, r0, r0, r0
	smlattlo	r15, r15, r15, r15

positive: smlattmi instruction

	smlattmi	r0, r0, r0, r0
	smlattmi	r15, r15, r15, r15

positive: smlattpl instruction

	smlattpl	r0, r0, r0, r0
	smlattpl	r15, r15, r15, r15

positive: smlattvs instruction

	smlattvs	r0, r0, r0, r0
	smlattvs	r15, r15, r15, r15

positive: smlattvc instruction

	smlattvc	r0, r0, r0, r0
	smlattvc	r15, r15, r15, r15

positive: smlatthi instruction

	smlatthi	r0, r0, r0, r0
	smlatthi	r15, r15, r15, r15

positive: smlattls instruction

	smlattls	r0, r0, r0, r0
	smlattls	r15, r15, r15, r15

positive: smlattge instruction

	smlattge	r0, r0, r0, r0
	smlattge	r15, r15, r15, r15

positive: smlattlt instruction

	smlattlt	r0, r0, r0, r0
	smlattlt	r15, r15, r15, r15

positive: smlattgt instruction

	smlattgt	r0, r0, r0, r0
	smlattgt	r15, r15, r15, r15

positive: smlattle instruction

	smlattle	r0, r0, r0, r0
	smlattle	r15, r15, r15, r15

positive: smlattal instruction

	smlattal	r0, r0, r0, r0
	smlattal	r15, r15, r15, r15

positive: smlad instruction

	smlad	r0, r0, r0, r0
	smlad	r15, r15, r15, r15

positive: smladeq instruction

	smladeq	r0, r0, r0, r0
	smladeq	r15, r15, r15, r15

positive: smladne instruction

	smladne	r0, r0, r0, r0
	smladne	r15, r15, r15, r15

positive: smladcs instruction

	smladcs	r0, r0, r0, r0
	smladcs	r15, r15, r15, r15

positive: smladhs instruction

	smladhs	r0, r0, r0, r0
	smladhs	r15, r15, r15, r15

positive: smladcc instruction

	smladcc	r0, r0, r0, r0
	smladcc	r15, r15, r15, r15

positive: smladlo instruction

	smladlo	r0, r0, r0, r0
	smladlo	r15, r15, r15, r15

positive: smladmi instruction

	smladmi	r0, r0, r0, r0
	smladmi	r15, r15, r15, r15

positive: smladpl instruction

	smladpl	r0, r0, r0, r0
	smladpl	r15, r15, r15, r15

positive: smladvs instruction

	smladvs	r0, r0, r0, r0
	smladvs	r15, r15, r15, r15

positive: smladvc instruction

	smladvc	r0, r0, r0, r0
	smladvc	r15, r15, r15, r15

positive: smladhi instruction

	smladhi	r0, r0, r0, r0
	smladhi	r15, r15, r15, r15

positive: smladls instruction

	smladls	r0, r0, r0, r0
	smladls	r15, r15, r15, r15

positive: smladge instruction

	smladge	r0, r0, r0, r0
	smladge	r15, r15, r15, r15

positive: smladlt instruction

	smladlt	r0, r0, r0, r0
	smladlt	r15, r15, r15, r15

positive: smladgt instruction

	smladgt	r0, r0, r0, r0
	smladgt	r15, r15, r15, r15

positive: smladle instruction

	smladle	r0, r0, r0, r0
	smladle	r15, r15, r15, r15

positive: smladal instruction

	smladal	r0, r0, r0, r0
	smladal	r15, r15, r15, r15

positive: smladx instruction

	smladx	r0, r0, r0, r0
	smladx	r15, r15, r15, r15

positive: smladxeq instruction

	smladxeq	r0, r0, r0, r0
	smladxeq	r15, r15, r15, r15

positive: smladxne instruction

	smladxne	r0, r0, r0, r0
	smladxne	r15, r15, r15, r15

positive: smladxcs instruction

	smladxcs	r0, r0, r0, r0
	smladxcs	r15, r15, r15, r15

positive: smladxhs instruction

	smladxhs	r0, r0, r0, r0
	smladxhs	r15, r15, r15, r15

positive: smladxcc instruction

	smladxcc	r0, r0, r0, r0
	smladxcc	r15, r15, r15, r15

positive: smladxlo instruction

	smladxlo	r0, r0, r0, r0
	smladxlo	r15, r15, r15, r15

positive: smladxmi instruction

	smladxmi	r0, r0, r0, r0
	smladxmi	r15, r15, r15, r15

positive: smladxpl instruction

	smladxpl	r0, r0, r0, r0
	smladxpl	r15, r15, r15, r15

positive: smladxvs instruction

	smladxvs	r0, r0, r0, r0
	smladxvs	r15, r15, r15, r15

positive: smladxvc instruction

	smladxvc	r0, r0, r0, r0
	smladxvc	r15, r15, r15, r15

positive: smladxhi instruction

	smladxhi	r0, r0, r0, r0
	smladxhi	r15, r15, r15, r15

positive: smladxls instruction

	smladxls	r0, r0, r0, r0
	smladxls	r15, r15, r15, r15

positive: smladxge instruction

	smladxge	r0, r0, r0, r0
	smladxge	r15, r15, r15, r15

positive: smladxlt instruction

	smladxlt	r0, r0, r0, r0
	smladxlt	r15, r15, r15, r15

positive: smladxgt instruction

	smladxgt	r0, r0, r0, r0
	smladxgt	r15, r15, r15, r15

positive: smladxle instruction

	smladxle	r0, r0, r0, r0
	smladxle	r15, r15, r15, r15

positive: smladxal instruction

	smladxal	r0, r0, r0, r0
	smladxal	r15, r15, r15, r15

positive: smlal instruction

	smlal	r0, r0, r0, r0
	smlal	r15, r15, r15, r15

positive: smlaleq instruction

	smlaleq	r0, r0, r0, r0
	smlaleq	r15, r15, r15, r15

positive: smlalne instruction

	smlalne	r0, r0, r0, r0
	smlalne	r15, r15, r15, r15

positive: smlalcs instruction

	smlalcs	r0, r0, r0, r0
	smlalcs	r15, r15, r15, r15

positive: smlalhs instruction

	smlalhs	r0, r0, r0, r0
	smlalhs	r15, r15, r15, r15

positive: smlalcc instruction

	smlalcc	r0, r0, r0, r0
	smlalcc	r15, r15, r15, r15

positive: smlallo instruction

	smlallo	r0, r0, r0, r0
	smlallo	r15, r15, r15, r15

positive: smlalmi instruction

	smlalmi	r0, r0, r0, r0
	smlalmi	r15, r15, r15, r15

positive: smlalpl instruction

	smlalpl	r0, r0, r0, r0
	smlalpl	r15, r15, r15, r15

positive: smlalvs instruction

	smlalvs	r0, r0, r0, r0
	smlalvs	r15, r15, r15, r15

positive: smlalvc instruction

	smlalvc	r0, r0, r0, r0
	smlalvc	r15, r15, r15, r15

positive: smlalhi instruction

	smlalhi	r0, r0, r0, r0
	smlalhi	r15, r15, r15, r15

positive: smlalls instruction

	smlalls	r0, r0, r0, r0
	smlalls	r15, r15, r15, r15

positive: smlalge instruction

	smlalge	r0, r0, r0, r0
	smlalge	r15, r15, r15, r15

positive: smlallt instruction

	smlallt	r0, r0, r0, r0
	smlallt	r15, r15, r15, r15

positive: smlalgt instruction

	smlalgt	r0, r0, r0, r0
	smlalgt	r15, r15, r15, r15

positive: smlalle instruction

	smlalle	r0, r0, r0, r0
	smlalle	r15, r15, r15, r15

positive: smlalal instruction

	smlalal	r0, r0, r0, r0
	smlalal	r15, r15, r15, r15

positive: smlals instruction

	smlals	r0, r0, r0, r0
	smlals	r15, r15, r15, r15

positive: smlalseq instruction

	smlalseq	r0, r0, r0, r0
	smlalseq	r15, r15, r15, r15

positive: smlalsne instruction

	smlalsne	r0, r0, r0, r0
	smlalsne	r15, r15, r15, r15

positive: smlalscs instruction

	smlalscs	r0, r0, r0, r0
	smlalscs	r15, r15, r15, r15

positive: smlalshs instruction

	smlalshs	r0, r0, r0, r0
	smlalshs	r15, r15, r15, r15

positive: smlalscc instruction

	smlalscc	r0, r0, r0, r0
	smlalscc	r15, r15, r15, r15

positive: smlalslo instruction

	smlalslo	r0, r0, r0, r0
	smlalslo	r15, r15, r15, r15

positive: smlalsmi instruction

	smlalsmi	r0, r0, r0, r0
	smlalsmi	r15, r15, r15, r15

positive: smlalspl instruction

	smlalspl	r0, r0, r0, r0
	smlalspl	r15, r15, r15, r15

positive: smlalsvs instruction

	smlalsvs	r0, r0, r0, r0
	smlalsvs	r15, r15, r15, r15

positive: smlalsvc instruction

	smlalsvc	r0, r0, r0, r0
	smlalsvc	r15, r15, r15, r15

positive: smlalshi instruction

	smlalshi	r0, r0, r0, r0
	smlalshi	r15, r15, r15, r15

positive: smlalsls instruction

	smlalsls	r0, r0, r0, r0
	smlalsls	r15, r15, r15, r15

positive: smlalsge instruction

	smlalsge	r0, r0, r0, r0
	smlalsge	r15, r15, r15, r15

positive: smlalslt instruction

	smlalslt	r0, r0, r0, r0
	smlalslt	r15, r15, r15, r15

positive: smlalsgt instruction

	smlalsgt	r0, r0, r0, r0
	smlalsgt	r15, r15, r15, r15

positive: smlalsle instruction

	smlalsle	r0, r0, r0, r0
	smlalsle	r15, r15, r15, r15

positive: smlalsal instruction

	smlalsal	r0, r0, r0, r0
	smlalsal	r15, r15, r15, r15

positive: smlalbb instruction

	smlalbb	r0, r0, r0, r0
	smlalbb	r15, r15, r15, r15

positive: smlalbbeq instruction

	smlalbbeq	r0, r0, r0, r0
	smlalbbeq	r15, r15, r15, r15

positive: smlalbbne instruction

	smlalbbne	r0, r0, r0, r0
	smlalbbne	r15, r15, r15, r15

positive: smlalbbcs instruction

	smlalbbcs	r0, r0, r0, r0
	smlalbbcs	r15, r15, r15, r15

positive: smlalbbhs instruction

	smlalbbhs	r0, r0, r0, r0
	smlalbbhs	r15, r15, r15, r15

positive: smlalbbcc instruction

	smlalbbcc	r0, r0, r0, r0
	smlalbbcc	r15, r15, r15, r15

positive: smlalbblo instruction

	smlalbblo	r0, r0, r0, r0
	smlalbblo	r15, r15, r15, r15

positive: smlalbbmi instruction

	smlalbbmi	r0, r0, r0, r0
	smlalbbmi	r15, r15, r15, r15

positive: smlalbbpl instruction

	smlalbbpl	r0, r0, r0, r0
	smlalbbpl	r15, r15, r15, r15

positive: smlalbbvs instruction

	smlalbbvs	r0, r0, r0, r0
	smlalbbvs	r15, r15, r15, r15

positive: smlalbbvc instruction

	smlalbbvc	r0, r0, r0, r0
	smlalbbvc	r15, r15, r15, r15

positive: smlalbbhi instruction

	smlalbbhi	r0, r0, r0, r0
	smlalbbhi	r15, r15, r15, r15

positive: smlalbbls instruction

	smlalbbls	r0, r0, r0, r0
	smlalbbls	r15, r15, r15, r15

positive: smlalbbge instruction

	smlalbbge	r0, r0, r0, r0
	smlalbbge	r15, r15, r15, r15

positive: smlalbblt instruction

	smlalbblt	r0, r0, r0, r0
	smlalbblt	r15, r15, r15, r15

positive: smlalbbgt instruction

	smlalbbgt	r0, r0, r0, r0
	smlalbbgt	r15, r15, r15, r15

positive: smlalbble instruction

	smlalbble	r0, r0, r0, r0
	smlalbble	r15, r15, r15, r15

positive: smlalbbal instruction

	smlalbbal	r0, r0, r0, r0
	smlalbbal	r15, r15, r15, r15

positive: smlalbt instruction

	smlalbt	r0, r0, r0, r0
	smlalbt	r15, r15, r15, r15

positive: smlalbteq instruction

	smlalbteq	r0, r0, r0, r0
	smlalbteq	r15, r15, r15, r15

positive: smlalbtne instruction

	smlalbtne	r0, r0, r0, r0
	smlalbtne	r15, r15, r15, r15

positive: smlalbtcs instruction

	smlalbtcs	r0, r0, r0, r0
	smlalbtcs	r15, r15, r15, r15

positive: smlalbths instruction

	smlalbths	r0, r0, r0, r0
	smlalbths	r15, r15, r15, r15

positive: smlalbtcc instruction

	smlalbtcc	r0, r0, r0, r0
	smlalbtcc	r15, r15, r15, r15

positive: smlalbtlo instruction

	smlalbtlo	r0, r0, r0, r0
	smlalbtlo	r15, r15, r15, r15

positive: smlalbtmi instruction

	smlalbtmi	r0, r0, r0, r0
	smlalbtmi	r15, r15, r15, r15

positive: smlalbtpl instruction

	smlalbtpl	r0, r0, r0, r0
	smlalbtpl	r15, r15, r15, r15

positive: smlalbtvs instruction

	smlalbtvs	r0, r0, r0, r0
	smlalbtvs	r15, r15, r15, r15

positive: smlalbtvc instruction

	smlalbtvc	r0, r0, r0, r0
	smlalbtvc	r15, r15, r15, r15

positive: smlalbthi instruction

	smlalbthi	r0, r0, r0, r0
	smlalbthi	r15, r15, r15, r15

positive: smlalbtls instruction

	smlalbtls	r0, r0, r0, r0
	smlalbtls	r15, r15, r15, r15

positive: smlalbtge instruction

	smlalbtge	r0, r0, r0, r0
	smlalbtge	r15, r15, r15, r15

positive: smlalbtlt instruction

	smlalbtlt	r0, r0, r0, r0
	smlalbtlt	r15, r15, r15, r15

positive: smlalbtgt instruction

	smlalbtgt	r0, r0, r0, r0
	smlalbtgt	r15, r15, r15, r15

positive: smlalbtle instruction

	smlalbtle	r0, r0, r0, r0
	smlalbtle	r15, r15, r15, r15

positive: smlalbtal instruction

	smlalbtal	r0, r0, r0, r0
	smlalbtal	r15, r15, r15, r15

positive: smlaltb instruction

	smlaltb	r0, r0, r0, r0
	smlaltb	r15, r15, r15, r15

positive: smlaltbeq instruction

	smlaltbeq	r0, r0, r0, r0
	smlaltbeq	r15, r15, r15, r15

positive: smlaltbne instruction

	smlaltbne	r0, r0, r0, r0
	smlaltbne	r15, r15, r15, r15

positive: smlaltbcs instruction

	smlaltbcs	r0, r0, r0, r0
	smlaltbcs	r15, r15, r15, r15

positive: smlaltbhs instruction

	smlaltbhs	r0, r0, r0, r0
	smlaltbhs	r15, r15, r15, r15

positive: smlaltbcc instruction

	smlaltbcc	r0, r0, r0, r0
	smlaltbcc	r15, r15, r15, r15

positive: smlaltblo instruction

	smlaltblo	r0, r0, r0, r0
	smlaltblo	r15, r15, r15, r15

positive: smlaltbmi instruction

	smlaltbmi	r0, r0, r0, r0
	smlaltbmi	r15, r15, r15, r15

positive: smlaltbpl instruction

	smlaltbpl	r0, r0, r0, r0
	smlaltbpl	r15, r15, r15, r15

positive: smlaltbvs instruction

	smlaltbvs	r0, r0, r0, r0
	smlaltbvs	r15, r15, r15, r15

positive: smlaltbvc instruction

	smlaltbvc	r0, r0, r0, r0
	smlaltbvc	r15, r15, r15, r15

positive: smlaltbhi instruction

	smlaltbhi	r0, r0, r0, r0
	smlaltbhi	r15, r15, r15, r15

positive: smlaltbls instruction

	smlaltbls	r0, r0, r0, r0
	smlaltbls	r15, r15, r15, r15

positive: smlaltbge instruction

	smlaltbge	r0, r0, r0, r0
	smlaltbge	r15, r15, r15, r15

positive: smlaltblt instruction

	smlaltblt	r0, r0, r0, r0
	smlaltblt	r15, r15, r15, r15

positive: smlaltbgt instruction

	smlaltbgt	r0, r0, r0, r0
	smlaltbgt	r15, r15, r15, r15

positive: smlaltble instruction

	smlaltble	r0, r0, r0, r0
	smlaltble	r15, r15, r15, r15

positive: smlaltbal instruction

	smlaltbal	r0, r0, r0, r0
	smlaltbal	r15, r15, r15, r15

positive: smlaltt instruction

	smlaltt	r0, r0, r0, r0
	smlaltt	r15, r15, r15, r15

positive: smlaltteq instruction

	smlaltteq	r0, r0, r0, r0
	smlaltteq	r15, r15, r15, r15

positive: smlalttne instruction

	smlalttne	r0, r0, r0, r0
	smlalttne	r15, r15, r15, r15

positive: smlalttcs instruction

	smlalttcs	r0, r0, r0, r0
	smlalttcs	r15, r15, r15, r15

positive: smlaltths instruction

	smlaltths	r0, r0, r0, r0
	smlaltths	r15, r15, r15, r15

positive: smlalttcc instruction

	smlalttcc	r0, r0, r0, r0
	smlalttcc	r15, r15, r15, r15

positive: smlalttlo instruction

	smlalttlo	r0, r0, r0, r0
	smlalttlo	r15, r15, r15, r15

positive: smlalttmi instruction

	smlalttmi	r0, r0, r0, r0
	smlalttmi	r15, r15, r15, r15

positive: smlalttpl instruction

	smlalttpl	r0, r0, r0, r0
	smlalttpl	r15, r15, r15, r15

positive: smlalttvs instruction

	smlalttvs	r0, r0, r0, r0
	smlalttvs	r15, r15, r15, r15

positive: smlalttvc instruction

	smlalttvc	r0, r0, r0, r0
	smlalttvc	r15, r15, r15, r15

positive: smlaltthi instruction

	smlaltthi	r0, r0, r0, r0
	smlaltthi	r15, r15, r15, r15

positive: smlalttls instruction

	smlalttls	r0, r0, r0, r0
	smlalttls	r15, r15, r15, r15

positive: smlalttge instruction

	smlalttge	r0, r0, r0, r0
	smlalttge	r15, r15, r15, r15

positive: smlalttlt instruction

	smlalttlt	r0, r0, r0, r0
	smlalttlt	r15, r15, r15, r15

positive: smlalttgt instruction

	smlalttgt	r0, r0, r0, r0
	smlalttgt	r15, r15, r15, r15

positive: smlalttle instruction

	smlalttle	r0, r0, r0, r0
	smlalttle	r15, r15, r15, r15

positive: smlalttal instruction

	smlalttal	r0, r0, r0, r0
	smlalttal	r15, r15, r15, r15

positive: smlald instruction

	smlald	r0, r0, r0, r0
	smlald	r15, r15, r15, r15

positive: smlaldeq instruction

	smlaldeq	r0, r0, r0, r0
	smlaldeq	r15, r15, r15, r15

positive: smlaldne instruction

	smlaldne	r0, r0, r0, r0
	smlaldne	r15, r15, r15, r15

positive: smlaldcs instruction

	smlaldcs	r0, r0, r0, r0
	smlaldcs	r15, r15, r15, r15

positive: smlaldhs instruction

	smlaldhs	r0, r0, r0, r0
	smlaldhs	r15, r15, r15, r15

positive: smlaldcc instruction

	smlaldcc	r0, r0, r0, r0
	smlaldcc	r15, r15, r15, r15

positive: smlaldlo instruction

	smlaldlo	r0, r0, r0, r0
	smlaldlo	r15, r15, r15, r15

positive: smlaldmi instruction

	smlaldmi	r0, r0, r0, r0
	smlaldmi	r15, r15, r15, r15

positive: smlaldpl instruction

	smlaldpl	r0, r0, r0, r0
	smlaldpl	r15, r15, r15, r15

positive: smlaldvs instruction

	smlaldvs	r0, r0, r0, r0
	smlaldvs	r15, r15, r15, r15

positive: smlaldvc instruction

	smlaldvc	r0, r0, r0, r0
	smlaldvc	r15, r15, r15, r15

positive: smlaldhi instruction

	smlaldhi	r0, r0, r0, r0
	smlaldhi	r15, r15, r15, r15

positive: smlaldls instruction

	smlaldls	r0, r0, r0, r0
	smlaldls	r15, r15, r15, r15

positive: smlaldge instruction

	smlaldge	r0, r0, r0, r0
	smlaldge	r15, r15, r15, r15

positive: smlaldlt instruction

	smlaldlt	r0, r0, r0, r0
	smlaldlt	r15, r15, r15, r15

positive: smlaldgt instruction

	smlaldgt	r0, r0, r0, r0
	smlaldgt	r15, r15, r15, r15

positive: smlaldle instruction

	smlaldle	r0, r0, r0, r0
	smlaldle	r15, r15, r15, r15

positive: smlaldal instruction

	smlaldal	r0, r0, r0, r0
	smlaldal	r15, r15, r15, r15

positive: smlaldx instruction

	smlaldx	r0, r0, r0, r0
	smlaldx	r15, r15, r15, r15

positive: smlaldxeq instruction

	smlaldxeq	r0, r0, r0, r0
	smlaldxeq	r15, r15, r15, r15

positive: smlaldxne instruction

	smlaldxne	r0, r0, r0, r0
	smlaldxne	r15, r15, r15, r15

positive: smlaldxcs instruction

	smlaldxcs	r0, r0, r0, r0
	smlaldxcs	r15, r15, r15, r15

positive: smlaldxhs instruction

	smlaldxhs	r0, r0, r0, r0
	smlaldxhs	r15, r15, r15, r15

positive: smlaldxcc instruction

	smlaldxcc	r0, r0, r0, r0
	smlaldxcc	r15, r15, r15, r15

positive: smlaldxlo instruction

	smlaldxlo	r0, r0, r0, r0
	smlaldxlo	r15, r15, r15, r15

positive: smlaldxmi instruction

	smlaldxmi	r0, r0, r0, r0
	smlaldxmi	r15, r15, r15, r15

positive: smlaldxpl instruction

	smlaldxpl	r0, r0, r0, r0
	smlaldxpl	r15, r15, r15, r15

positive: smlaldxvs instruction

	smlaldxvs	r0, r0, r0, r0
	smlaldxvs	r15, r15, r15, r15

positive: smlaldxvc instruction

	smlaldxvc	r0, r0, r0, r0
	smlaldxvc	r15, r15, r15, r15

positive: smlaldxhi instruction

	smlaldxhi	r0, r0, r0, r0
	smlaldxhi	r15, r15, r15, r15

positive: smlaldxls instruction

	smlaldxls	r0, r0, r0, r0
	smlaldxls	r15, r15, r15, r15

positive: smlaldxge instruction

	smlaldxge	r0, r0, r0, r0
	smlaldxge	r15, r15, r15, r15

positive: smlaldxlt instruction

	smlaldxlt	r0, r0, r0, r0
	smlaldxlt	r15, r15, r15, r15

positive: smlaldxgt instruction

	smlaldxgt	r0, r0, r0, r0
	smlaldxgt	r15, r15, r15, r15

positive: smlaldxle instruction

	smlaldxle	r0, r0, r0, r0
	smlaldxle	r15, r15, r15, r15

positive: smlaldxal instruction

	smlaldxal	r0, r0, r0, r0
	smlaldxal	r15, r15, r15, r15

positive: smlawb instruction

	smlawb	r0, r0, r0, r0
	smlawb	r15, r15, r15, r15

positive: smlawbeq instruction

	smlawbeq	r0, r0, r0, r0
	smlawbeq	r15, r15, r15, r15

positive: smlawbne instruction

	smlawbne	r0, r0, r0, r0
	smlawbne	r15, r15, r15, r15

positive: smlawbcs instruction

	smlawbcs	r0, r0, r0, r0
	smlawbcs	r15, r15, r15, r15

positive: smlawbhs instruction

	smlawbhs	r0, r0, r0, r0
	smlawbhs	r15, r15, r15, r15

positive: smlawbcc instruction

	smlawbcc	r0, r0, r0, r0
	smlawbcc	r15, r15, r15, r15

positive: smlawblo instruction

	smlawblo	r0, r0, r0, r0
	smlawblo	r15, r15, r15, r15

positive: smlawbmi instruction

	smlawbmi	r0, r0, r0, r0
	smlawbmi	r15, r15, r15, r15

positive: smlawbpl instruction

	smlawbpl	r0, r0, r0, r0
	smlawbpl	r15, r15, r15, r15

positive: smlawbvs instruction

	smlawbvs	r0, r0, r0, r0
	smlawbvs	r15, r15, r15, r15

positive: smlawbvc instruction

	smlawbvc	r0, r0, r0, r0
	smlawbvc	r15, r15, r15, r15

positive: smlawbhi instruction

	smlawbhi	r0, r0, r0, r0
	smlawbhi	r15, r15, r15, r15

positive: smlawbls instruction

	smlawbls	r0, r0, r0, r0
	smlawbls	r15, r15, r15, r15

positive: smlawbge instruction

	smlawbge	r0, r0, r0, r0
	smlawbge	r15, r15, r15, r15

positive: smlawblt instruction

	smlawblt	r0, r0, r0, r0
	smlawblt	r15, r15, r15, r15

positive: smlawbgt instruction

	smlawbgt	r0, r0, r0, r0
	smlawbgt	r15, r15, r15, r15

positive: smlawble instruction

	smlawble	r0, r0, r0, r0
	smlawble	r15, r15, r15, r15

positive: smlawbal instruction

	smlawbal	r0, r0, r0, r0
	smlawbal	r15, r15, r15, r15

positive: smlawt instruction

	smlawt	r0, r0, r0, r0
	smlawt	r15, r15, r15, r15

positive: smlawteq instruction

	smlawteq	r0, r0, r0, r0
	smlawteq	r15, r15, r15, r15

positive: smlawtne instruction

	smlawtne	r0, r0, r0, r0
	smlawtne	r15, r15, r15, r15

positive: smlawtcs instruction

	smlawtcs	r0, r0, r0, r0
	smlawtcs	r15, r15, r15, r15

positive: smlawths instruction

	smlawths	r0, r0, r0, r0
	smlawths	r15, r15, r15, r15

positive: smlawtcc instruction

	smlawtcc	r0, r0, r0, r0
	smlawtcc	r15, r15, r15, r15

positive: smlawtlo instruction

	smlawtlo	r0, r0, r0, r0
	smlawtlo	r15, r15, r15, r15

positive: smlawtmi instruction

	smlawtmi	r0, r0, r0, r0
	smlawtmi	r15, r15, r15, r15

positive: smlawtpl instruction

	smlawtpl	r0, r0, r0, r0
	smlawtpl	r15, r15, r15, r15

positive: smlawtvs instruction

	smlawtvs	r0, r0, r0, r0
	smlawtvs	r15, r15, r15, r15

positive: smlawtvc instruction

	smlawtvc	r0, r0, r0, r0
	smlawtvc	r15, r15, r15, r15

positive: smlawthi instruction

	smlawthi	r0, r0, r0, r0
	smlawthi	r15, r15, r15, r15

positive: smlawtls instruction

	smlawtls	r0, r0, r0, r0
	smlawtls	r15, r15, r15, r15

positive: smlawtge instruction

	smlawtge	r0, r0, r0, r0
	smlawtge	r15, r15, r15, r15

positive: smlawtlt instruction

	smlawtlt	r0, r0, r0, r0
	smlawtlt	r15, r15, r15, r15

positive: smlawtgt instruction

	smlawtgt	r0, r0, r0, r0
	smlawtgt	r15, r15, r15, r15

positive: smlawtle instruction

	smlawtle	r0, r0, r0, r0
	smlawtle	r15, r15, r15, r15

positive: smlawtal instruction

	smlawtal	r0, r0, r0, r0
	smlawtal	r15, r15, r15, r15

positive: smlsd instruction

	smlsd	r0, r0, r0, r0
	smlsd	r15, r15, r15, r15

positive: smlsdeq instruction

	smlsdeq	r0, r0, r0, r0
	smlsdeq	r15, r15, r15, r15

positive: smlsdne instruction

	smlsdne	r0, r0, r0, r0
	smlsdne	r15, r15, r15, r15

positive: smlsdcs instruction

	smlsdcs	r0, r0, r0, r0
	smlsdcs	r15, r15, r15, r15

positive: smlsdhs instruction

	smlsdhs	r0, r0, r0, r0
	smlsdhs	r15, r15, r15, r15

positive: smlsdcc instruction

	smlsdcc	r0, r0, r0, r0
	smlsdcc	r15, r15, r15, r15

positive: smlsdlo instruction

	smlsdlo	r0, r0, r0, r0
	smlsdlo	r15, r15, r15, r15

positive: smlsdmi instruction

	smlsdmi	r0, r0, r0, r0
	smlsdmi	r15, r15, r15, r15

positive: smlsdpl instruction

	smlsdpl	r0, r0, r0, r0
	smlsdpl	r15, r15, r15, r15

positive: smlsdvs instruction

	smlsdvs	r0, r0, r0, r0
	smlsdvs	r15, r15, r15, r15

positive: smlsdvc instruction

	smlsdvc	r0, r0, r0, r0
	smlsdvc	r15, r15, r15, r15

positive: smlsdhi instruction

	smlsdhi	r0, r0, r0, r0
	smlsdhi	r15, r15, r15, r15

positive: smlsdls instruction

	smlsdls	r0, r0, r0, r0
	smlsdls	r15, r15, r15, r15

positive: smlsdge instruction

	smlsdge	r0, r0, r0, r0
	smlsdge	r15, r15, r15, r15

positive: smlsdlt instruction

	smlsdlt	r0, r0, r0, r0
	smlsdlt	r15, r15, r15, r15

positive: smlsdgt instruction

	smlsdgt	r0, r0, r0, r0
	smlsdgt	r15, r15, r15, r15

positive: smlsdle instruction

	smlsdle	r0, r0, r0, r0
	smlsdle	r15, r15, r15, r15

positive: smlsdal instruction

	smlsdal	r0, r0, r0, r0
	smlsdal	r15, r15, r15, r15

positive: smlsdx instruction

	smlsdx	r0, r0, r0, r0
	smlsdx	r15, r15, r15, r15

positive: smlsdxeq instruction

	smlsdxeq	r0, r0, r0, r0
	smlsdxeq	r15, r15, r15, r15

positive: smlsdxne instruction

	smlsdxne	r0, r0, r0, r0
	smlsdxne	r15, r15, r15, r15

positive: smlsdxcs instruction

	smlsdxcs	r0, r0, r0, r0
	smlsdxcs	r15, r15, r15, r15

positive: smlsdxhs instruction

	smlsdxhs	r0, r0, r0, r0
	smlsdxhs	r15, r15, r15, r15

positive: smlsdxcc instruction

	smlsdxcc	r0, r0, r0, r0
	smlsdxcc	r15, r15, r15, r15

positive: smlsdxlo instruction

	smlsdxlo	r0, r0, r0, r0
	smlsdxlo	r15, r15, r15, r15

positive: smlsdxmi instruction

	smlsdxmi	r0, r0, r0, r0
	smlsdxmi	r15, r15, r15, r15

positive: smlsdxpl instruction

	smlsdxpl	r0, r0, r0, r0
	smlsdxpl	r15, r15, r15, r15

positive: smlsdxvs instruction

	smlsdxvs	r0, r0, r0, r0
	smlsdxvs	r15, r15, r15, r15

positive: smlsdxvc instruction

	smlsdxvc	r0, r0, r0, r0
	smlsdxvc	r15, r15, r15, r15

positive: smlsdxhi instruction

	smlsdxhi	r0, r0, r0, r0
	smlsdxhi	r15, r15, r15, r15

positive: smlsdxls instruction

	smlsdxls	r0, r0, r0, r0
	smlsdxls	r15, r15, r15, r15

positive: smlsdxge instruction

	smlsdxge	r0, r0, r0, r0
	smlsdxge	r15, r15, r15, r15

positive: smlsdxlt instruction

	smlsdxlt	r0, r0, r0, r0
	smlsdxlt	r15, r15, r15, r15

positive: smlsdxgt instruction

	smlsdxgt	r0, r0, r0, r0
	smlsdxgt	r15, r15, r15, r15

positive: smlsdxle instruction

	smlsdxle	r0, r0, r0, r0
	smlsdxle	r15, r15, r15, r15

positive: smlsdxal instruction

	smlsdxal	r0, r0, r0, r0
	smlsdxal	r15, r15, r15, r15

positive: smlsld instruction

	smlsld	r0, r0, r0, r0
	smlsld	r15, r15, r15, r15

positive: smlsldeq instruction

	smlsldeq	r0, r0, r0, r0
	smlsldeq	r15, r15, r15, r15

positive: smlsldne instruction

	smlsldne	r0, r0, r0, r0
	smlsldne	r15, r15, r15, r15

positive: smlsldcs instruction

	smlsldcs	r0, r0, r0, r0
	smlsldcs	r15, r15, r15, r15

positive: smlsldhs instruction

	smlsldhs	r0, r0, r0, r0
	smlsldhs	r15, r15, r15, r15

positive: smlsldcc instruction

	smlsldcc	r0, r0, r0, r0
	smlsldcc	r15, r15, r15, r15

positive: smlsldlo instruction

	smlsldlo	r0, r0, r0, r0
	smlsldlo	r15, r15, r15, r15

positive: smlsldmi instruction

	smlsldmi	r0, r0, r0, r0
	smlsldmi	r15, r15, r15, r15

positive: smlsldpl instruction

	smlsldpl	r0, r0, r0, r0
	smlsldpl	r15, r15, r15, r15

positive: smlsldvs instruction

	smlsldvs	r0, r0, r0, r0
	smlsldvs	r15, r15, r15, r15

positive: smlsldvc instruction

	smlsldvc	r0, r0, r0, r0
	smlsldvc	r15, r15, r15, r15

positive: smlsldhi instruction

	smlsldhi	r0, r0, r0, r0
	smlsldhi	r15, r15, r15, r15

positive: smlsldls instruction

	smlsldls	r0, r0, r0, r0
	smlsldls	r15, r15, r15, r15

positive: smlsldge instruction

	smlsldge	r0, r0, r0, r0
	smlsldge	r15, r15, r15, r15

positive: smlsldlt instruction

	smlsldlt	r0, r0, r0, r0
	smlsldlt	r15, r15, r15, r15

positive: smlsldgt instruction

	smlsldgt	r0, r0, r0, r0
	smlsldgt	r15, r15, r15, r15

positive: smlsldle instruction

	smlsldle	r0, r0, r0, r0
	smlsldle	r15, r15, r15, r15

positive: smlsldal instruction

	smlsldal	r0, r0, r0, r0
	smlsldal	r15, r15, r15, r15

positive: smlsldx instruction

	smlsldx	r0, r0, r0, r0
	smlsldx	r15, r15, r15, r15

positive: smlsldxeq instruction

	smlsldxeq	r0, r0, r0, r0
	smlsldxeq	r15, r15, r15, r15

positive: smlsldxne instruction

	smlsldxne	r0, r0, r0, r0
	smlsldxne	r15, r15, r15, r15

positive: smlsldxcs instruction

	smlsldxcs	r0, r0, r0, r0
	smlsldxcs	r15, r15, r15, r15

positive: smlsldxhs instruction

	smlsldxhs	r0, r0, r0, r0
	smlsldxhs	r15, r15, r15, r15

positive: smlsldxcc instruction

	smlsldxcc	r0, r0, r0, r0
	smlsldxcc	r15, r15, r15, r15

positive: smlsldxlo instruction

	smlsldxlo	r0, r0, r0, r0
	smlsldxlo	r15, r15, r15, r15

positive: smlsldxmi instruction

	smlsldxmi	r0, r0, r0, r0
	smlsldxmi	r15, r15, r15, r15

positive: smlsldxpl instruction

	smlsldxpl	r0, r0, r0, r0
	smlsldxpl	r15, r15, r15, r15

positive: smlsldxvs instruction

	smlsldxvs	r0, r0, r0, r0
	smlsldxvs	r15, r15, r15, r15

positive: smlsldxvc instruction

	smlsldxvc	r0, r0, r0, r0
	smlsldxvc	r15, r15, r15, r15

positive: smlsldxhi instruction

	smlsldxhi	r0, r0, r0, r0
	smlsldxhi	r15, r15, r15, r15

positive: smlsldxls instruction

	smlsldxls	r0, r0, r0, r0
	smlsldxls	r15, r15, r15, r15

positive: smlsldxge instruction

	smlsldxge	r0, r0, r0, r0
	smlsldxge	r15, r15, r15, r15

positive: smlsldxlt instruction

	smlsldxlt	r0, r0, r0, r0
	smlsldxlt	r15, r15, r15, r15

positive: smlsldxgt instruction

	smlsldxgt	r0, r0, r0, r0
	smlsldxgt	r15, r15, r15, r15

positive: smlsldxle instruction

	smlsldxle	r0, r0, r0, r0
	smlsldxle	r15, r15, r15, r15

positive: smlsldxal instruction

	smlsldxal	r0, r0, r0, r0
	smlsldxal	r15, r15, r15, r15

positive: smmla instruction

	smmla	r0, r0, r0, r0
	smmla	r15, r15, r15, r15

positive: smmlaeq instruction

	smmlaeq	r0, r0, r0, r0
	smmlaeq	r15, r15, r15, r15

positive: smmlane instruction

	smmlane	r0, r0, r0, r0
	smmlane	r15, r15, r15, r15

positive: smmlacs instruction

	smmlacs	r0, r0, r0, r0
	smmlacs	r15, r15, r15, r15

positive: smmlahs instruction

	smmlahs	r0, r0, r0, r0
	smmlahs	r15, r15, r15, r15

positive: smmlacc instruction

	smmlacc	r0, r0, r0, r0
	smmlacc	r15, r15, r15, r15

positive: smmlalo instruction

	smmlalo	r0, r0, r0, r0
	smmlalo	r15, r15, r15, r15

positive: smmlami instruction

	smmlami	r0, r0, r0, r0
	smmlami	r15, r15, r15, r15

positive: smmlapl instruction

	smmlapl	r0, r0, r0, r0
	smmlapl	r15, r15, r15, r15

positive: smmlavs instruction

	smmlavs	r0, r0, r0, r0
	smmlavs	r15, r15, r15, r15

positive: smmlavc instruction

	smmlavc	r0, r0, r0, r0
	smmlavc	r15, r15, r15, r15

positive: smmlahi instruction

	smmlahi	r0, r0, r0, r0
	smmlahi	r15, r15, r15, r15

positive: smmlals instruction

	smmlals	r0, r0, r0, r0
	smmlals	r15, r15, r15, r15

positive: smmlage instruction

	smmlage	r0, r0, r0, r0
	smmlage	r15, r15, r15, r15

positive: smmlalt instruction

	smmlalt	r0, r0, r0, r0
	smmlalt	r15, r15, r15, r15

positive: smmlagt instruction

	smmlagt	r0, r0, r0, r0
	smmlagt	r15, r15, r15, r15

positive: smmlale instruction

	smmlale	r0, r0, r0, r0
	smmlale	r15, r15, r15, r15

positive: smmlaal instruction

	smmlaal	r0, r0, r0, r0
	smmlaal	r15, r15, r15, r15

positive: smmlar instruction

	smmlar	r0, r0, r0, r0
	smmlar	r15, r15, r15, r15

positive: smmlareq instruction

	smmlareq	r0, r0, r0, r0
	smmlareq	r15, r15, r15, r15

positive: smmlarne instruction

	smmlarne	r0, r0, r0, r0
	smmlarne	r15, r15, r15, r15

positive: smmlarcs instruction

	smmlarcs	r0, r0, r0, r0
	smmlarcs	r15, r15, r15, r15

positive: smmlarhs instruction

	smmlarhs	r0, r0, r0, r0
	smmlarhs	r15, r15, r15, r15

positive: smmlarcc instruction

	smmlarcc	r0, r0, r0, r0
	smmlarcc	r15, r15, r15, r15

positive: smmlarlo instruction

	smmlarlo	r0, r0, r0, r0
	smmlarlo	r15, r15, r15, r15

positive: smmlarmi instruction

	smmlarmi	r0, r0, r0, r0
	smmlarmi	r15, r15, r15, r15

positive: smmlarpl instruction

	smmlarpl	r0, r0, r0, r0
	smmlarpl	r15, r15, r15, r15

positive: smmlarvs instruction

	smmlarvs	r0, r0, r0, r0
	smmlarvs	r15, r15, r15, r15

positive: smmlarvc instruction

	smmlarvc	r0, r0, r0, r0
	smmlarvc	r15, r15, r15, r15

positive: smmlarhi instruction

	smmlarhi	r0, r0, r0, r0
	smmlarhi	r15, r15, r15, r15

positive: smmlarls instruction

	smmlarls	r0, r0, r0, r0
	smmlarls	r15, r15, r15, r15

positive: smmlarge instruction

	smmlarge	r0, r0, r0, r0
	smmlarge	r15, r15, r15, r15

positive: smmlarlt instruction

	smmlarlt	r0, r0, r0, r0
	smmlarlt	r15, r15, r15, r15

positive: smmlargt instruction

	smmlargt	r0, r0, r0, r0
	smmlargt	r15, r15, r15, r15

positive: smmlarle instruction

	smmlarle	r0, r0, r0, r0
	smmlarle	r15, r15, r15, r15

positive: smmlaral instruction

	smmlaral	r0, r0, r0, r0
	smmlaral	r15, r15, r15, r15

positive: smmls instruction

	smmls	r0, r0, r0, r0
	smmls	r15, r15, r15, r15

positive: smmlseq instruction

	smmlseq	r0, r0, r0, r0
	smmlseq	r15, r15, r15, r15

positive: smmlsne instruction

	smmlsne	r0, r0, r0, r0
	smmlsne	r15, r15, r15, r15

positive: smmlscs instruction

	smmlscs	r0, r0, r0, r0
	smmlscs	r15, r15, r15, r15

positive: smmlshs instruction

	smmlshs	r0, r0, r0, r0
	smmlshs	r15, r15, r15, r15

positive: smmlscc instruction

	smmlscc	r0, r0, r0, r0
	smmlscc	r15, r15, r15, r15

positive: smmlslo instruction

	smmlslo	r0, r0, r0, r0
	smmlslo	r15, r15, r15, r15

positive: smmlsmi instruction

	smmlsmi	r0, r0, r0, r0
	smmlsmi	r15, r15, r15, r15

positive: smmlspl instruction

	smmlspl	r0, r0, r0, r0
	smmlspl	r15, r15, r15, r15

positive: smmlsvs instruction

	smmlsvs	r0, r0, r0, r0
	smmlsvs	r15, r15, r15, r15

positive: smmlsvc instruction

	smmlsvc	r0, r0, r0, r0
	smmlsvc	r15, r15, r15, r15

positive: smmlshi instruction

	smmlshi	r0, r0, r0, r0
	smmlshi	r15, r15, r15, r15

positive: smmlsls instruction

	smmlsls	r0, r0, r0, r0
	smmlsls	r15, r15, r15, r15

positive: smmlsge instruction

	smmlsge	r0, r0, r0, r0
	smmlsge	r15, r15, r15, r15

positive: smmlslt instruction

	smmlslt	r0, r0, r0, r0
	smmlslt	r15, r15, r15, r15

positive: smmlsgt instruction

	smmlsgt	r0, r0, r0, r0
	smmlsgt	r15, r15, r15, r15

positive: smmlsle instruction

	smmlsle	r0, r0, r0, r0
	smmlsle	r15, r15, r15, r15

positive: smmlsal instruction

	smmlsal	r0, r0, r0, r0
	smmlsal	r15, r15, r15, r15

positive: smmlsr instruction

	smmlsr	r0, r0, r0, r0
	smmlsr	r15, r15, r15, r15

positive: smmlsreq instruction

	smmlsreq	r0, r0, r0, r0
	smmlsreq	r15, r15, r15, r15

positive: smmlsrne instruction

	smmlsrne	r0, r0, r0, r0
	smmlsrne	r15, r15, r15, r15

positive: smmlsrcs instruction

	smmlsrcs	r0, r0, r0, r0
	smmlsrcs	r15, r15, r15, r15

positive: smmlsrhs instruction

	smmlsrhs	r0, r0, r0, r0
	smmlsrhs	r15, r15, r15, r15

positive: smmlsrcc instruction

	smmlsrcc	r0, r0, r0, r0
	smmlsrcc	r15, r15, r15, r15

positive: smmlsrlo instruction

	smmlsrlo	r0, r0, r0, r0
	smmlsrlo	r15, r15, r15, r15

positive: smmlsrmi instruction

	smmlsrmi	r0, r0, r0, r0
	smmlsrmi	r15, r15, r15, r15

positive: smmlsrpl instruction

	smmlsrpl	r0, r0, r0, r0
	smmlsrpl	r15, r15, r15, r15

positive: smmlsrvs instruction

	smmlsrvs	r0, r0, r0, r0
	smmlsrvs	r15, r15, r15, r15

positive: smmlsrvc instruction

	smmlsrvc	r0, r0, r0, r0
	smmlsrvc	r15, r15, r15, r15

positive: smmlsrhi instruction

	smmlsrhi	r0, r0, r0, r0
	smmlsrhi	r15, r15, r15, r15

positive: smmlsrls instruction

	smmlsrls	r0, r0, r0, r0
	smmlsrls	r15, r15, r15, r15

positive: smmlsrge instruction

	smmlsrge	r0, r0, r0, r0
	smmlsrge	r15, r15, r15, r15

positive: smmlsrlt instruction

	smmlsrlt	r0, r0, r0, r0
	smmlsrlt	r15, r15, r15, r15

positive: smmlsrgt instruction

	smmlsrgt	r0, r0, r0, r0
	smmlsrgt	r15, r15, r15, r15

positive: smmlsrle instruction

	smmlsrle	r0, r0, r0, r0
	smmlsrle	r15, r15, r15, r15

positive: smmlsral instruction

	smmlsral	r0, r0, r0, r0
	smmlsral	r15, r15, r15, r15

positive: smmul instruction

	smmul	r0, r0, r0
	smmul	r15, r15, r15

positive: smmuleq instruction

	smmuleq	r0, r0, r0
	smmuleq	r15, r15, r15

positive: smmulne instruction

	smmulne	r0, r0, r0
	smmulne	r15, r15, r15

positive: smmulcs instruction

	smmulcs	r0, r0, r0
	smmulcs	r15, r15, r15

positive: smmulhs instruction

	smmulhs	r0, r0, r0
	smmulhs	r15, r15, r15

positive: smmulcc instruction

	smmulcc	r0, r0, r0
	smmulcc	r15, r15, r15

positive: smmullo instruction

	smmullo	r0, r0, r0
	smmullo	r15, r15, r15

positive: smmulmi instruction

	smmulmi	r0, r0, r0
	smmulmi	r15, r15, r15

positive: smmulpl instruction

	smmulpl	r0, r0, r0
	smmulpl	r15, r15, r15

positive: smmulvs instruction

	smmulvs	r0, r0, r0
	smmulvs	r15, r15, r15

positive: smmulvc instruction

	smmulvc	r0, r0, r0
	smmulvc	r15, r15, r15

positive: smmulhi instruction

	smmulhi	r0, r0, r0
	smmulhi	r15, r15, r15

positive: smmulls instruction

	smmulls	r0, r0, r0
	smmulls	r15, r15, r15

positive: smmulge instruction

	smmulge	r0, r0, r0
	smmulge	r15, r15, r15

positive: smmullt instruction

	smmullt	r0, r0, r0
	smmullt	r15, r15, r15

positive: smmulgt instruction

	smmulgt	r0, r0, r0
	smmulgt	r15, r15, r15

positive: smmulle instruction

	smmulle	r0, r0, r0
	smmulle	r15, r15, r15

positive: smmulal instruction

	smmulal	r0, r0, r0
	smmulal	r15, r15, r15

positive: smuad instruction

	smuad	r0, r0, r0
	smuad	r15, r15, r15

positive: smuadeq instruction

	smuadeq	r0, r0, r0
	smuadeq	r15, r15, r15

positive: smuadne instruction

	smuadne	r0, r0, r0
	smuadne	r15, r15, r15

positive: smuadcs instruction

	smuadcs	r0, r0, r0
	smuadcs	r15, r15, r15

positive: smuadhs instruction

	smuadhs	r0, r0, r0
	smuadhs	r15, r15, r15

positive: smuadcc instruction

	smuadcc	r0, r0, r0
	smuadcc	r15, r15, r15

positive: smuadlo instruction

	smuadlo	r0, r0, r0
	smuadlo	r15, r15, r15

positive: smuadmi instruction

	smuadmi	r0, r0, r0
	smuadmi	r15, r15, r15

positive: smuadpl instruction

	smuadpl	r0, r0, r0
	smuadpl	r15, r15, r15

positive: smuadvs instruction

	smuadvs	r0, r0, r0
	smuadvs	r15, r15, r15

positive: smuadvc instruction

	smuadvc	r0, r0, r0
	smuadvc	r15, r15, r15

positive: smuadhi instruction

	smuadhi	r0, r0, r0
	smuadhi	r15, r15, r15

positive: smuadls instruction

	smuadls	r0, r0, r0
	smuadls	r15, r15, r15

positive: smuadge instruction

	smuadge	r0, r0, r0
	smuadge	r15, r15, r15

positive: smuadlt instruction

	smuadlt	r0, r0, r0
	smuadlt	r15, r15, r15

positive: smuadgt instruction

	smuadgt	r0, r0, r0
	smuadgt	r15, r15, r15

positive: smuadle instruction

	smuadle	r0, r0, r0
	smuadle	r15, r15, r15

positive: smuadal instruction

	smuadal	r0, r0, r0
	smuadal	r15, r15, r15

positive: smuadx instruction

	smuadx	r0, r0, r0
	smuadx	r15, r15, r15

positive: smuadxeq instruction

	smuadxeq	r0, r0, r0
	smuadxeq	r15, r15, r15

positive: smuadxne instruction

	smuadxne	r0, r0, r0
	smuadxne	r15, r15, r15

positive: smuadxcs instruction

	smuadxcs	r0, r0, r0
	smuadxcs	r15, r15, r15

positive: smuadxhs instruction

	smuadxhs	r0, r0, r0
	smuadxhs	r15, r15, r15

positive: smuadxcc instruction

	smuadxcc	r0, r0, r0
	smuadxcc	r15, r15, r15

positive: smuadxlo instruction

	smuadxlo	r0, r0, r0
	smuadxlo	r15, r15, r15

positive: smuadxmi instruction

	smuadxmi	r0, r0, r0
	smuadxmi	r15, r15, r15

positive: smuadxpl instruction

	smuadxpl	r0, r0, r0
	smuadxpl	r15, r15, r15

positive: smuadxvs instruction

	smuadxvs	r0, r0, r0
	smuadxvs	r15, r15, r15

positive: smuadxvc instruction

	smuadxvc	r0, r0, r0
	smuadxvc	r15, r15, r15

positive: smuadxhi instruction

	smuadxhi	r0, r0, r0
	smuadxhi	r15, r15, r15

positive: smuadxls instruction

	smuadxls	r0, r0, r0
	smuadxls	r15, r15, r15

positive: smuadxge instruction

	smuadxge	r0, r0, r0
	smuadxge	r15, r15, r15

positive: smuadxlt instruction

	smuadxlt	r0, r0, r0
	smuadxlt	r15, r15, r15

positive: smuadxgt instruction

	smuadxgt	r0, r0, r0
	smuadxgt	r15, r15, r15

positive: smuadxle instruction

	smuadxle	r0, r0, r0
	smuadxle	r15, r15, r15

positive: smuadxal instruction

	smuadxal	r0, r0, r0
	smuadxal	r15, r15, r15

positive: smulbb instruction

	smulbb	r0, r0, r0
	smulbb	r15, r15, r15

positive: smulbbeq instruction

	smulbbeq	r0, r0, r0
	smulbbeq	r15, r15, r15

positive: smulbbne instruction

	smulbbne	r0, r0, r0
	smulbbne	r15, r15, r15

positive: smulbbcs instruction

	smulbbcs	r0, r0, r0
	smulbbcs	r15, r15, r15

positive: smulbbhs instruction

	smulbbhs	r0, r0, r0
	smulbbhs	r15, r15, r15

positive: smulbbcc instruction

	smulbbcc	r0, r0, r0
	smulbbcc	r15, r15, r15

positive: smulbblo instruction

	smulbblo	r0, r0, r0
	smulbblo	r15, r15, r15

positive: smulbbmi instruction

	smulbbmi	r0, r0, r0
	smulbbmi	r15, r15, r15

positive: smulbbpl instruction

	smulbbpl	r0, r0, r0
	smulbbpl	r15, r15, r15

positive: smulbbvs instruction

	smulbbvs	r0, r0, r0
	smulbbvs	r15, r15, r15

positive: smulbbvc instruction

	smulbbvc	r0, r0, r0
	smulbbvc	r15, r15, r15

positive: smulbbhi instruction

	smulbbhi	r0, r0, r0
	smulbbhi	r15, r15, r15

positive: smulbbls instruction

	smulbbls	r0, r0, r0
	smulbbls	r15, r15, r15

positive: smulbbge instruction

	smulbbge	r0, r0, r0
	smulbbge	r15, r15, r15

positive: smulbblt instruction

	smulbblt	r0, r0, r0
	smulbblt	r15, r15, r15

positive: smulbbgt instruction

	smulbbgt	r0, r0, r0
	smulbbgt	r15, r15, r15

positive: smulbble instruction

	smulbble	r0, r0, r0
	smulbble	r15, r15, r15

positive: smulbbal instruction

	smulbbal	r0, r0, r0
	smulbbal	r15, r15, r15

positive: smulbt instruction

	smulbt	r0, r0, r0
	smulbt	r15, r15, r15

positive: smulbteq instruction

	smulbteq	r0, r0, r0
	smulbteq	r15, r15, r15

positive: smulbtne instruction

	smulbtne	r0, r0, r0
	smulbtne	r15, r15, r15

positive: smulbtcs instruction

	smulbtcs	r0, r0, r0
	smulbtcs	r15, r15, r15

positive: smulbths instruction

	smulbths	r0, r0, r0
	smulbths	r15, r15, r15

positive: smulbtcc instruction

	smulbtcc	r0, r0, r0
	smulbtcc	r15, r15, r15

positive: smulbtlo instruction

	smulbtlo	r0, r0, r0
	smulbtlo	r15, r15, r15

positive: smulbtmi instruction

	smulbtmi	r0, r0, r0
	smulbtmi	r15, r15, r15

positive: smulbtpl instruction

	smulbtpl	r0, r0, r0
	smulbtpl	r15, r15, r15

positive: smulbtvs instruction

	smulbtvs	r0, r0, r0
	smulbtvs	r15, r15, r15

positive: smulbtvc instruction

	smulbtvc	r0, r0, r0
	smulbtvc	r15, r15, r15

positive: smulbthi instruction

	smulbthi	r0, r0, r0
	smulbthi	r15, r15, r15

positive: smulbtls instruction

	smulbtls	r0, r0, r0
	smulbtls	r15, r15, r15

positive: smulbtge instruction

	smulbtge	r0, r0, r0
	smulbtge	r15, r15, r15

positive: smulbtlt instruction

	smulbtlt	r0, r0, r0
	smulbtlt	r15, r15, r15

positive: smulbtgt instruction

	smulbtgt	r0, r0, r0
	smulbtgt	r15, r15, r15

positive: smulbtle instruction

	smulbtle	r0, r0, r0
	smulbtle	r15, r15, r15

positive: smulbtal instruction

	smulbtal	r0, r0, r0
	smulbtal	r15, r15, r15

positive: smultb instruction

	smultb	r0, r0, r0
	smultb	r15, r15, r15

positive: smultbeq instruction

	smultbeq	r0, r0, r0
	smultbeq	r15, r15, r15

positive: smultbne instruction

	smultbne	r0, r0, r0
	smultbne	r15, r15, r15

positive: smultbcs instruction

	smultbcs	r0, r0, r0
	smultbcs	r15, r15, r15

positive: smultbhs instruction

	smultbhs	r0, r0, r0
	smultbhs	r15, r15, r15

positive: smultbcc instruction

	smultbcc	r0, r0, r0
	smultbcc	r15, r15, r15

positive: smultblo instruction

	smultblo	r0, r0, r0
	smultblo	r15, r15, r15

positive: smultbmi instruction

	smultbmi	r0, r0, r0
	smultbmi	r15, r15, r15

positive: smultbpl instruction

	smultbpl	r0, r0, r0
	smultbpl	r15, r15, r15

positive: smultbvs instruction

	smultbvs	r0, r0, r0
	smultbvs	r15, r15, r15

positive: smultbvc instruction

	smultbvc	r0, r0, r0
	smultbvc	r15, r15, r15

positive: smultbhi instruction

	smultbhi	r0, r0, r0
	smultbhi	r15, r15, r15

positive: smultbls instruction

	smultbls	r0, r0, r0
	smultbls	r15, r15, r15

positive: smultbge instruction

	smultbge	r0, r0, r0
	smultbge	r15, r15, r15

positive: smultblt instruction

	smultblt	r0, r0, r0
	smultblt	r15, r15, r15

positive: smultbgt instruction

	smultbgt	r0, r0, r0
	smultbgt	r15, r15, r15

positive: smultble instruction

	smultble	r0, r0, r0
	smultble	r15, r15, r15

positive: smultbal instruction

	smultbal	r0, r0, r0
	smultbal	r15, r15, r15

positive: smultt instruction

	smultt	r0, r0, r0
	smultt	r15, r15, r15

positive: smultteq instruction

	smultteq	r0, r0, r0
	smultteq	r15, r15, r15

positive: smulttne instruction

	smulttne	r0, r0, r0
	smulttne	r15, r15, r15

positive: smulttcs instruction

	smulttcs	r0, r0, r0
	smulttcs	r15, r15, r15

positive: smultths instruction

	smultths	r0, r0, r0
	smultths	r15, r15, r15

positive: smulttcc instruction

	smulttcc	r0, r0, r0
	smulttcc	r15, r15, r15

positive: smulttlo instruction

	smulttlo	r0, r0, r0
	smulttlo	r15, r15, r15

positive: smulttmi instruction

	smulttmi	r0, r0, r0
	smulttmi	r15, r15, r15

positive: smulttpl instruction

	smulttpl	r0, r0, r0
	smulttpl	r15, r15, r15

positive: smulttvs instruction

	smulttvs	r0, r0, r0
	smulttvs	r15, r15, r15

positive: smulttvc instruction

	smulttvc	r0, r0, r0
	smulttvc	r15, r15, r15

positive: smultthi instruction

	smultthi	r0, r0, r0
	smultthi	r15, r15, r15

positive: smulttls instruction

	smulttls	r0, r0, r0
	smulttls	r15, r15, r15

positive: smulttge instruction

	smulttge	r0, r0, r0
	smulttge	r15, r15, r15

positive: smulttlt instruction

	smulttlt	r0, r0, r0
	smulttlt	r15, r15, r15

positive: smulttgt instruction

	smulttgt	r0, r0, r0
	smulttgt	r15, r15, r15

positive: smulttle instruction

	smulttle	r0, r0, r0
	smulttle	r15, r15, r15

positive: smulttal instruction

	smulttal	r0, r0, r0
	smulttal	r15, r15, r15

positive: smull instruction

	smull	r0, r0, r0, r0
	smull	r15, r15, r15, r15

positive: smulleq instruction

	smulleq	r0, r0, r0, r0
	smulleq	r15, r15, r15, r15

positive: smullne instruction

	smullne	r0, r0, r0, r0
	smullne	r15, r15, r15, r15

positive: smullcs instruction

	smullcs	r0, r0, r0, r0
	smullcs	r15, r15, r15, r15

positive: smullhs instruction

	smullhs	r0, r0, r0, r0
	smullhs	r15, r15, r15, r15

positive: smullcc instruction

	smullcc	r0, r0, r0, r0
	smullcc	r15, r15, r15, r15

positive: smulllo instruction

	smulllo	r0, r0, r0, r0
	smulllo	r15, r15, r15, r15

positive: smullmi instruction

	smullmi	r0, r0, r0, r0
	smullmi	r15, r15, r15, r15

positive: smullpl instruction

	smullpl	r0, r0, r0, r0
	smullpl	r15, r15, r15, r15

positive: smullvs instruction

	smullvs	r0, r0, r0, r0
	smullvs	r15, r15, r15, r15

positive: smullvc instruction

	smullvc	r0, r0, r0, r0
	smullvc	r15, r15, r15, r15

positive: smullhi instruction

	smullhi	r0, r0, r0, r0
	smullhi	r15, r15, r15, r15

positive: smullls instruction

	smullls	r0, r0, r0, r0
	smullls	r15, r15, r15, r15

positive: smullge instruction

	smullge	r0, r0, r0, r0
	smullge	r15, r15, r15, r15

positive: smulllt instruction

	smulllt	r0, r0, r0, r0
	smulllt	r15, r15, r15, r15

positive: smullgt instruction

	smullgt	r0, r0, r0, r0
	smullgt	r15, r15, r15, r15

positive: smullle instruction

	smullle	r0, r0, r0, r0
	smullle	r15, r15, r15, r15

positive: smullal instruction

	smullal	r0, r0, r0, r0
	smullal	r15, r15, r15, r15

positive: smulls instruction

	smulls	r0, r0, r0, r0
	smulls	r15, r15, r15, r15

positive: smullseq instruction

	smullseq	r0, r0, r0, r0
	smullseq	r15, r15, r15, r15

positive: smullsne instruction

	smullsne	r0, r0, r0, r0
	smullsne	r15, r15, r15, r15

positive: smullscs instruction

	smullscs	r0, r0, r0, r0
	smullscs	r15, r15, r15, r15

positive: smullshs instruction

	smullshs	r0, r0, r0, r0
	smullshs	r15, r15, r15, r15

positive: smullscc instruction

	smullscc	r0, r0, r0, r0
	smullscc	r15, r15, r15, r15

positive: smullslo instruction

	smullslo	r0, r0, r0, r0
	smullslo	r15, r15, r15, r15

positive: smullsmi instruction

	smullsmi	r0, r0, r0, r0
	smullsmi	r15, r15, r15, r15

positive: smullspl instruction

	smullspl	r0, r0, r0, r0
	smullspl	r15, r15, r15, r15

positive: smullsvs instruction

	smullsvs	r0, r0, r0, r0
	smullsvs	r15, r15, r15, r15

positive: smullsvc instruction

	smullsvc	r0, r0, r0, r0
	smullsvc	r15, r15, r15, r15

positive: smullshi instruction

	smullshi	r0, r0, r0, r0
	smullshi	r15, r15, r15, r15

positive: smullsls instruction

	smullsls	r0, r0, r0, r0
	smullsls	r15, r15, r15, r15

positive: smullsge instruction

	smullsge	r0, r0, r0, r0
	smullsge	r15, r15, r15, r15

positive: smullslt instruction

	smullslt	r0, r0, r0, r0
	smullslt	r15, r15, r15, r15

positive: smullsgt instruction

	smullsgt	r0, r0, r0, r0
	smullsgt	r15, r15, r15, r15

positive: smullsle instruction

	smullsle	r0, r0, r0, r0
	smullsle	r15, r15, r15, r15

positive: smullsal instruction

	smullsal	r0, r0, r0, r0
	smullsal	r15, r15, r15, r15

positive: smulwb instruction

	smulwb	r0, r0, r0
	smulwb	r15, r15, r15

positive: smulwbeq instruction

	smulwbeq	r0, r0, r0
	smulwbeq	r15, r15, r15

positive: smulwbne instruction

	smulwbne	r0, r0, r0
	smulwbne	r15, r15, r15

positive: smulwbcs instruction

	smulwbcs	r0, r0, r0
	smulwbcs	r15, r15, r15

positive: smulwbhs instruction

	smulwbhs	r0, r0, r0
	smulwbhs	r15, r15, r15

positive: smulwbcc instruction

	smulwbcc	r0, r0, r0
	smulwbcc	r15, r15, r15

positive: smulwblo instruction

	smulwblo	r0, r0, r0
	smulwblo	r15, r15, r15

positive: smulwbmi instruction

	smulwbmi	r0, r0, r0
	smulwbmi	r15, r15, r15

positive: smulwbpl instruction

	smulwbpl	r0, r0, r0
	smulwbpl	r15, r15, r15

positive: smulwbvs instruction

	smulwbvs	r0, r0, r0
	smulwbvs	r15, r15, r15

positive: smulwbvc instruction

	smulwbvc	r0, r0, r0
	smulwbvc	r15, r15, r15

positive: smulwbhi instruction

	smulwbhi	r0, r0, r0
	smulwbhi	r15, r15, r15

positive: smulwbls instruction

	smulwbls	r0, r0, r0
	smulwbls	r15, r15, r15

positive: smulwbge instruction

	smulwbge	r0, r0, r0
	smulwbge	r15, r15, r15

positive: smulwblt instruction

	smulwblt	r0, r0, r0
	smulwblt	r15, r15, r15

positive: smulwbgt instruction

	smulwbgt	r0, r0, r0
	smulwbgt	r15, r15, r15

positive: smulwble instruction

	smulwble	r0, r0, r0
	smulwble	r15, r15, r15

positive: smulwbal instruction

	smulwbal	r0, r0, r0
	smulwbal	r15, r15, r15

positive: smulwt instruction

	smulwt	r0, r0, r0
	smulwt	r15, r15, r15

positive: smulwteq instruction

	smulwteq	r0, r0, r0
	smulwteq	r15, r15, r15

positive: smulwtne instruction

	smulwtne	r0, r0, r0
	smulwtne	r15, r15, r15

positive: smulwtcs instruction

	smulwtcs	r0, r0, r0
	smulwtcs	r15, r15, r15

positive: smulwths instruction

	smulwths	r0, r0, r0
	smulwths	r15, r15, r15

positive: smulwtcc instruction

	smulwtcc	r0, r0, r0
	smulwtcc	r15, r15, r15

positive: smulwtlo instruction

	smulwtlo	r0, r0, r0
	smulwtlo	r15, r15, r15

positive: smulwtmi instruction

	smulwtmi	r0, r0, r0
	smulwtmi	r15, r15, r15

positive: smulwtpl instruction

	smulwtpl	r0, r0, r0
	smulwtpl	r15, r15, r15

positive: smulwtvs instruction

	smulwtvs	r0, r0, r0
	smulwtvs	r15, r15, r15

positive: smulwtvc instruction

	smulwtvc	r0, r0, r0
	smulwtvc	r15, r15, r15

positive: smulwthi instruction

	smulwthi	r0, r0, r0
	smulwthi	r15, r15, r15

positive: smulwtls instruction

	smulwtls	r0, r0, r0
	smulwtls	r15, r15, r15

positive: smulwtge instruction

	smulwtge	r0, r0, r0
	smulwtge	r15, r15, r15

positive: smulwtlt instruction

	smulwtlt	r0, r0, r0
	smulwtlt	r15, r15, r15

positive: smulwtgt instruction

	smulwtgt	r0, r0, r0
	smulwtgt	r15, r15, r15

positive: smulwtle instruction

	smulwtle	r0, r0, r0
	smulwtle	r15, r15, r15

positive: smulwtal instruction

	smulwtal	r0, r0, r0
	smulwtal	r15, r15, r15

positive: smusd instruction

	smusd	r0, r0, r0
	smusd	r15, r15, r15

positive: smusdeq instruction

	smusdeq	r0, r0, r0
	smusdeq	r15, r15, r15

positive: smusdne instruction

	smusdne	r0, r0, r0
	smusdne	r15, r15, r15

positive: smusdcs instruction

	smusdcs	r0, r0, r0
	smusdcs	r15, r15, r15

positive: smusdhs instruction

	smusdhs	r0, r0, r0
	smusdhs	r15, r15, r15

positive: smusdcc instruction

	smusdcc	r0, r0, r0
	smusdcc	r15, r15, r15

positive: smusdlo instruction

	smusdlo	r0, r0, r0
	smusdlo	r15, r15, r15

positive: smusdmi instruction

	smusdmi	r0, r0, r0
	smusdmi	r15, r15, r15

positive: smusdpl instruction

	smusdpl	r0, r0, r0
	smusdpl	r15, r15, r15

positive: smusdvs instruction

	smusdvs	r0, r0, r0
	smusdvs	r15, r15, r15

positive: smusdvc instruction

	smusdvc	r0, r0, r0
	smusdvc	r15, r15, r15

positive: smusdhi instruction

	smusdhi	r0, r0, r0
	smusdhi	r15, r15, r15

positive: smusdls instruction

	smusdls	r0, r0, r0
	smusdls	r15, r15, r15

positive: smusdge instruction

	smusdge	r0, r0, r0
	smusdge	r15, r15, r15

positive: smusdlt instruction

	smusdlt	r0, r0, r0
	smusdlt	r15, r15, r15

positive: smusdgt instruction

	smusdgt	r0, r0, r0
	smusdgt	r15, r15, r15

positive: smusdle instruction

	smusdle	r0, r0, r0
	smusdle	r15, r15, r15

positive: smusdal instruction

	smusdal	r0, r0, r0
	smusdal	r15, r15, r15

positive: smusdx instruction

	smusdx	r0, r0, r0
	smusdx	r15, r15, r15

positive: smusdxeq instruction

	smusdxeq	r0, r0, r0
	smusdxeq	r15, r15, r15

positive: smusdxne instruction

	smusdxne	r0, r0, r0
	smusdxne	r15, r15, r15

positive: smusdxcs instruction

	smusdxcs	r0, r0, r0
	smusdxcs	r15, r15, r15

positive: smusdxhs instruction

	smusdxhs	r0, r0, r0
	smusdxhs	r15, r15, r15

positive: smusdxcc instruction

	smusdxcc	r0, r0, r0
	smusdxcc	r15, r15, r15

positive: smusdxlo instruction

	smusdxlo	r0, r0, r0
	smusdxlo	r15, r15, r15

positive: smusdxmi instruction

	smusdxmi	r0, r0, r0
	smusdxmi	r15, r15, r15

positive: smusdxpl instruction

	smusdxpl	r0, r0, r0
	smusdxpl	r15, r15, r15

positive: smusdxvs instruction

	smusdxvs	r0, r0, r0
	smusdxvs	r15, r15, r15

positive: smusdxvc instruction

	smusdxvc	r0, r0, r0
	smusdxvc	r15, r15, r15

positive: smusdxhi instruction

	smusdxhi	r0, r0, r0
	smusdxhi	r15, r15, r15

positive: smusdxls instruction

	smusdxls	r0, r0, r0
	smusdxls	r15, r15, r15

positive: smusdxge instruction

	smusdxge	r0, r0, r0
	smusdxge	r15, r15, r15

positive: smusdxlt instruction

	smusdxlt	r0, r0, r0
	smusdxlt	r15, r15, r15

positive: smusdxgt instruction

	smusdxgt	r0, r0, r0
	smusdxgt	r15, r15, r15

positive: smusdxle instruction

	smusdxle	r0, r0, r0
	smusdxle	r15, r15, r15

positive: smusdxal instruction

	smusdxal	r0, r0, r0
	smusdxal	r15, r15, r15

positive: srsia instruction

	srsia	0
	srsia	31
	srsia	0 !
	srsia	31 !

positive: srsib instruction

	srsib	0
	srsib	31
	srsib	0 !
	srsib	31 !

positive: srsda instruction

	srsda	0
	srsda	31
	srsda	0 !
	srsda	31 !

positive: srsdb instruction

	srsdb	0
	srsdb	31
	srsdb	0 !
	srsdb	31 !

positive: ssub16 instruction

	ssub16	r0, r0, r0
	ssub16	r15, r15, r15

positive: ssub16eq instruction

	ssub16eq	r0, r0, r0
	ssub16eq	r15, r15, r15

positive: ssub16ne instruction

	ssub16ne	r0, r0, r0
	ssub16ne	r15, r15, r15

positive: ssub16cs instruction

	ssub16cs	r0, r0, r0
	ssub16cs	r15, r15, r15

positive: ssub16hs instruction

	ssub16hs	r0, r0, r0
	ssub16hs	r15, r15, r15

positive: ssub16cc instruction

	ssub16cc	r0, r0, r0
	ssub16cc	r15, r15, r15

positive: ssub16lo instruction

	ssub16lo	r0, r0, r0
	ssub16lo	r15, r15, r15

positive: ssub16mi instruction

	ssub16mi	r0, r0, r0
	ssub16mi	r15, r15, r15

positive: ssub16pl instruction

	ssub16pl	r0, r0, r0
	ssub16pl	r15, r15, r15

positive: ssub16vs instruction

	ssub16vs	r0, r0, r0
	ssub16vs	r15, r15, r15

positive: ssub16vc instruction

	ssub16vc	r0, r0, r0
	ssub16vc	r15, r15, r15

positive: ssub16hi instruction

	ssub16hi	r0, r0, r0
	ssub16hi	r15, r15, r15

positive: ssub16ls instruction

	ssub16ls	r0, r0, r0
	ssub16ls	r15, r15, r15

positive: ssub16ge instruction

	ssub16ge	r0, r0, r0
	ssub16ge	r15, r15, r15

positive: ssub16lt instruction

	ssub16lt	r0, r0, r0
	ssub16lt	r15, r15, r15

positive: ssub16gt instruction

	ssub16gt	r0, r0, r0
	ssub16gt	r15, r15, r15

positive: ssub16le instruction

	ssub16le	r0, r0, r0
	ssub16le	r15, r15, r15

positive: ssub16al instruction

	ssub16al	r0, r0, r0
	ssub16al	r15, r15, r15

positive: ssub8 instruction

	ssub8	r0, r0, r0
	ssub8	r15, r15, r15

positive: ssub8eq instruction

	ssub8eq	r0, r0, r0
	ssub8eq	r15, r15, r15

positive: ssub8ne instruction

	ssub8ne	r0, r0, r0
	ssub8ne	r15, r15, r15

positive: ssub8cs instruction

	ssub8cs	r0, r0, r0
	ssub8cs	r15, r15, r15

positive: ssub8hs instruction

	ssub8hs	r0, r0, r0
	ssub8hs	r15, r15, r15

positive: ssub8cc instruction

	ssub8cc	r0, r0, r0
	ssub8cc	r15, r15, r15

positive: ssub8lo instruction

	ssub8lo	r0, r0, r0
	ssub8lo	r15, r15, r15

positive: ssub8mi instruction

	ssub8mi	r0, r0, r0
	ssub8mi	r15, r15, r15

positive: ssub8pl instruction

	ssub8pl	r0, r0, r0
	ssub8pl	r15, r15, r15

positive: ssub8vs instruction

	ssub8vs	r0, r0, r0
	ssub8vs	r15, r15, r15

positive: ssub8vc instruction

	ssub8vc	r0, r0, r0
	ssub8vc	r15, r15, r15

positive: ssub8hi instruction

	ssub8hi	r0, r0, r0
	ssub8hi	r15, r15, r15

positive: ssub8ls instruction

	ssub8ls	r0, r0, r0
	ssub8ls	r15, r15, r15

positive: ssub8ge instruction

	ssub8ge	r0, r0, r0
	ssub8ge	r15, r15, r15

positive: ssub8lt instruction

	ssub8lt	r0, r0, r0
	ssub8lt	r15, r15, r15

positive: ssub8gt instruction

	ssub8gt	r0, r0, r0
	ssub8gt	r15, r15, r15

positive: ssub8le instruction

	ssub8le	r0, r0, r0
	ssub8le	r15, r15, r15

positive: ssub8al instruction

	ssub8al	r0, r0, r0
	ssub8al	r15, r15, r15

positive: ssubaddx instruction

	ssubaddx	r0, r0, r0
	ssubaddx	r15, r15, r15

positive: ssubaddxeq instruction

	ssubaddxeq	r0, r0, r0
	ssubaddxeq	r15, r15, r15

positive: ssubaddxne instruction

	ssubaddxne	r0, r0, r0
	ssubaddxne	r15, r15, r15

positive: ssubaddxcs instruction

	ssubaddxcs	r0, r0, r0
	ssubaddxcs	r15, r15, r15

positive: ssubaddxhs instruction

	ssubaddxhs	r0, r0, r0
	ssubaddxhs	r15, r15, r15

positive: ssubaddxcc instruction

	ssubaddxcc	r0, r0, r0
	ssubaddxcc	r15, r15, r15

positive: ssubaddxlo instruction

	ssubaddxlo	r0, r0, r0
	ssubaddxlo	r15, r15, r15

positive: ssubaddxmi instruction

	ssubaddxmi	r0, r0, r0
	ssubaddxmi	r15, r15, r15

positive: ssubaddxpl instruction

	ssubaddxpl	r0, r0, r0
	ssubaddxpl	r15, r15, r15

positive: ssubaddxvs instruction

	ssubaddxvs	r0, r0, r0
	ssubaddxvs	r15, r15, r15

positive: ssubaddxvc instruction

	ssubaddxvc	r0, r0, r0
	ssubaddxvc	r15, r15, r15

positive: ssubaddxhi instruction

	ssubaddxhi	r0, r0, r0
	ssubaddxhi	r15, r15, r15

positive: ssubaddxls instruction

	ssubaddxls	r0, r0, r0
	ssubaddxls	r15, r15, r15

positive: ssubaddxge instruction

	ssubaddxge	r0, r0, r0
	ssubaddxge	r15, r15, r15

positive: ssubaddxlt instruction

	ssubaddxlt	r0, r0, r0
	ssubaddxlt	r15, r15, r15

positive: ssubaddxgt instruction

	ssubaddxgt	r0, r0, r0
	ssubaddxgt	r15, r15, r15

positive: ssubaddxle instruction

	ssubaddxle	r0, r0, r0
	ssubaddxle	r15, r15, r15

positive: ssubaddxal instruction

	ssubaddxal	r0, r0, r0
	ssubaddxal	r15, r15, r15

positive: stc instruction

	stc	p0, c0, [r0, -1020]
	stc	p15, c15, [r15, +1020]
	stc	p0, c0, [r0, -1020] !
	stc	p15, c15, [r15, +1020] !
	stc	p0, c0, [r0], -1020
	stc	p15, c15, [r15], +1020
	stc	p0, c0, [r0], {0}
	stc	p15, c15, [r15], {255}

positive: stceq instruction

	stceq	p0, c0, [r0, -1020]
	stceq	p15, c15, [r15, +1020]
	stceq	p0, c0, [r0, -1020] !
	stceq	p15, c15, [r15, +1020] !
	stceq	p0, c0, [r0], -1020
	stceq	p15, c15, [r15], +1020
	stceq	p0, c0, [r0], {0}
	stceq	p15, c15, [r15], {255}

positive: stcne instruction

	stcne	p0, c0, [r0, -1020]
	stcne	p15, c15, [r15, +1020]
	stcne	p0, c0, [r0, -1020] !
	stcne	p15, c15, [r15, +1020] !
	stcne	p0, c0, [r0], -1020
	stcne	p15, c15, [r15], +1020
	stcne	p0, c0, [r0], {0}
	stcne	p15, c15, [r15], {255}

positive: stccs instruction

	stccs	p0, c0, [r0, -1020]
	stccs	p15, c15, [r15, +1020]
	stccs	p0, c0, [r0, -1020] !
	stccs	p15, c15, [r15, +1020] !
	stccs	p0, c0, [r0], -1020
	stccs	p15, c15, [r15], +1020
	stccs	p0, c0, [r0], {0}
	stccs	p15, c15, [r15], {255}

positive: stchs instruction

	stchs	p0, c0, [r0, -1020]
	stchs	p15, c15, [r15, +1020]
	stchs	p0, c0, [r0, -1020] !
	stchs	p15, c15, [r15, +1020] !
	stchs	p0, c0, [r0], -1020
	stchs	p15, c15, [r15], +1020
	stchs	p0, c0, [r0], {0}
	stchs	p15, c15, [r15], {255}

positive: stccc instruction

	stccc	p0, c0, [r0, -1020]
	stccc	p15, c15, [r15, +1020]
	stccc	p0, c0, [r0, -1020] !
	stccc	p15, c15, [r15, +1020] !
	stccc	p0, c0, [r0], -1020
	stccc	p15, c15, [r15], +1020
	stccc	p0, c0, [r0], {0}
	stccc	p15, c15, [r15], {255}

positive: stclo instruction

	stclo	p0, c0, [r0, -1020]
	stclo	p15, c15, [r15, +1020]
	stclo	p0, c0, [r0, -1020] !
	stclo	p15, c15, [r15, +1020] !
	stclo	p0, c0, [r0], -1020
	stclo	p15, c15, [r15], +1020
	stclo	p0, c0, [r0], {0}
	stclo	p15, c15, [r15], {255}

positive: stcmi instruction

	stcmi	p0, c0, [r0, -1020]
	stcmi	p15, c15, [r15, +1020]
	stcmi	p0, c0, [r0, -1020] !
	stcmi	p15, c15, [r15, +1020] !
	stcmi	p0, c0, [r0], -1020
	stcmi	p15, c15, [r15], +1020
	stcmi	p0, c0, [r0], {0}
	stcmi	p15, c15, [r15], {255}

positive: stcpl instruction

	stcpl	p0, c0, [r0, -1020]
	stcpl	p15, c15, [r15, +1020]
	stcpl	p0, c0, [r0, -1020] !
	stcpl	p15, c15, [r15, +1020] !
	stcpl	p0, c0, [r0], -1020
	stcpl	p15, c15, [r15], +1020
	stcpl	p0, c0, [r0], {0}
	stcpl	p15, c15, [r15], {255}

positive: stcvs instruction

	stcvs	p0, c0, [r0, -1020]
	stcvs	p15, c15, [r15, +1020]
	stcvs	p0, c0, [r0, -1020] !
	stcvs	p15, c15, [r15, +1020] !
	stcvs	p0, c0, [r0], -1020
	stcvs	p15, c15, [r15], +1020
	stcvs	p0, c0, [r0], {0}
	stcvs	p15, c15, [r15], {255}

positive: stcvc instruction

	stcvc	p0, c0, [r0, -1020]
	stcvc	p15, c15, [r15, +1020]
	stcvc	p0, c0, [r0, -1020] !
	stcvc	p15, c15, [r15, +1020] !
	stcvc	p0, c0, [r0], -1020
	stcvc	p15, c15, [r15], +1020
	stcvc	p0, c0, [r0], {0}
	stcvc	p15, c15, [r15], {255}

positive: stchi instruction

	stchi	p0, c0, [r0, -1020]
	stchi	p15, c15, [r15, +1020]
	stchi	p0, c0, [r0, -1020] !
	stchi	p15, c15, [r15, +1020] !
	stchi	p0, c0, [r0], -1020
	stchi	p15, c15, [r15], +1020
	stchi	p0, c0, [r0], {0}
	stchi	p15, c15, [r15], {255}

positive: stcls instruction

	stcls	p0, c0, [r0, -1020]
	stcls	p15, c15, [r15, +1020]
	stcls	p0, c0, [r0, -1020] !
	stcls	p15, c15, [r15, +1020] !
	stcls	p0, c0, [r0], -1020
	stcls	p15, c15, [r15], +1020
	stcls	p0, c0, [r0], {0}
	stcls	p15, c15, [r15], {255}

positive: stcge instruction

	stcge	p0, c0, [r0, -1020]
	stcge	p15, c15, [r15, +1020]
	stcge	p0, c0, [r0, -1020] !
	stcge	p15, c15, [r15, +1020] !
	stcge	p0, c0, [r0], -1020
	stcge	p15, c15, [r15], +1020
	stcge	p0, c0, [r0], {0}
	stcge	p15, c15, [r15], {255}

positive: stclt instruction

	stclt	p0, c0, [r0, -1020]
	stclt	p15, c15, [r15, +1020]
	stclt	p0, c0, [r0, -1020] !
	stclt	p15, c15, [r15, +1020] !
	stclt	p0, c0, [r0], -1020
	stclt	p15, c15, [r15], +1020
	stclt	p0, c0, [r0], {0}
	stclt	p15, c15, [r15], {255}

positive: stcgt instruction

	stcgt	p0, c0, [r0, -1020]
	stcgt	p15, c15, [r15, +1020]
	stcgt	p0, c0, [r0, -1020] !
	stcgt	p15, c15, [r15, +1020] !
	stcgt	p0, c0, [r0], -1020
	stcgt	p15, c15, [r15], +1020
	stcgt	p0, c0, [r0], {0}
	stcgt	p15, c15, [r15], {255}

positive: stcle instruction

	stcle	p0, c0, [r0, -1020]
	stcle	p15, c15, [r15, +1020]
	stcle	p0, c0, [r0, -1020] !
	stcle	p15, c15, [r15, +1020] !
	stcle	p0, c0, [r0], -1020
	stcle	p15, c15, [r15], +1020
	stcle	p0, c0, [r0], {0}
	stcle	p15, c15, [r15], {255}

positive: stcal instruction

	stcal	p0, c0, [r0, -1020]
	stcal	p15, c15, [r15, +1020]
	stcal	p0, c0, [r0, -1020] !
	stcal	p15, c15, [r15, +1020] !
	stcal	p0, c0, [r0], -1020
	stcal	p15, c15, [r15], +1020
	stcal	p0, c0, [r0], {0}
	stcal	p15, c15, [r15], {255}

positive: stcl instruction

	stcl	p0, c0, [r0, -1020]
	stcl	p15, c15, [r15, +1020]
	stcl	p0, c0, [r0, -1020] !
	stcl	p15, c15, [r15, +1020] !
	stcl	p0, c0, [r0], -1020
	stcl	p15, c15, [r15], +1020
	stcl	p0, c0, [r0], {0}
	stcl	p15, c15, [r15], {255}

positive: stcleq instruction

	stcleq	p0, c0, [r0, -1020]
	stcleq	p15, c15, [r15, +1020]
	stcleq	p0, c0, [r0, -1020] !
	stcleq	p15, c15, [r15, +1020] !
	stcleq	p0, c0, [r0], -1020
	stcleq	p15, c15, [r15], +1020
	stcleq	p0, c0, [r0], {0}
	stcleq	p15, c15, [r15], {255}

positive: stclne instruction

	stclne	p0, c0, [r0, -1020]
	stclne	p15, c15, [r15, +1020]
	stclne	p0, c0, [r0, -1020] !
	stclne	p15, c15, [r15, +1020] !
	stclne	p0, c0, [r0], -1020
	stclne	p15, c15, [r15], +1020
	stclne	p0, c0, [r0], {0}
	stclne	p15, c15, [r15], {255}

positive: stclcs instruction

	stclcs	p0, c0, [r0, -1020]
	stclcs	p15, c15, [r15, +1020]
	stclcs	p0, c0, [r0, -1020] !
	stclcs	p15, c15, [r15, +1020] !
	stclcs	p0, c0, [r0], -1020
	stclcs	p15, c15, [r15], +1020
	stclcs	p0, c0, [r0], {0}
	stclcs	p15, c15, [r15], {255}

positive: stclhs instruction

	stclhs	p0, c0, [r0, -1020]
	stclhs	p15, c15, [r15, +1020]
	stclhs	p0, c0, [r0, -1020] !
	stclhs	p15, c15, [r15, +1020] !
	stclhs	p0, c0, [r0], -1020
	stclhs	p15, c15, [r15], +1020
	stclhs	p0, c0, [r0], {0}
	stclhs	p15, c15, [r15], {255}

positive: stclcc instruction

	stclcc	p0, c0, [r0, -1020]
	stclcc	p15, c15, [r15, +1020]
	stclcc	p0, c0, [r0, -1020] !
	stclcc	p15, c15, [r15, +1020] !
	stclcc	p0, c0, [r0], -1020
	stclcc	p15, c15, [r15], +1020
	stclcc	p0, c0, [r0], {0}
	stclcc	p15, c15, [r15], {255}

positive: stcllo instruction

	stcllo	p0, c0, [r0, -1020]
	stcllo	p15, c15, [r15, +1020]
	stcllo	p0, c0, [r0, -1020] !
	stcllo	p15, c15, [r15, +1020] !
	stcllo	p0, c0, [r0], -1020
	stcllo	p15, c15, [r15], +1020
	stcllo	p0, c0, [r0], {0}
	stcllo	p15, c15, [r15], {255}

positive: stclmi instruction

	stclmi	p0, c0, [r0, -1020]
	stclmi	p15, c15, [r15, +1020]
	stclmi	p0, c0, [r0, -1020] !
	stclmi	p15, c15, [r15, +1020] !
	stclmi	p0, c0, [r0], -1020
	stclmi	p15, c15, [r15], +1020
	stclmi	p0, c0, [r0], {0}
	stclmi	p15, c15, [r15], {255}

positive: stclpl instruction

	stclpl	p0, c0, [r0, -1020]
	stclpl	p15, c15, [r15, +1020]
	stclpl	p0, c0, [r0, -1020] !
	stclpl	p15, c15, [r15, +1020] !
	stclpl	p0, c0, [r0], -1020
	stclpl	p15, c15, [r15], +1020
	stclpl	p0, c0, [r0], {0}
	stclpl	p15, c15, [r15], {255}

positive: stclvs instruction

	stclvs	p0, c0, [r0, -1020]
	stclvs	p15, c15, [r15, +1020]
	stclvs	p0, c0, [r0, -1020] !
	stclvs	p15, c15, [r15, +1020] !
	stclvs	p0, c0, [r0], -1020
	stclvs	p15, c15, [r15], +1020
	stclvs	p0, c0, [r0], {0}
	stclvs	p15, c15, [r15], {255}

positive: stclvc instruction

	stclvc	p0, c0, [r0, -1020]
	stclvc	p15, c15, [r15, +1020]
	stclvc	p0, c0, [r0, -1020] !
	stclvc	p15, c15, [r15, +1020] !
	stclvc	p0, c0, [r0], -1020
	stclvc	p15, c15, [r15], +1020
	stclvc	p0, c0, [r0], {0}
	stclvc	p15, c15, [r15], {255}

positive: stclhi instruction

	stclhi	p0, c0, [r0, -1020]
	stclhi	p15, c15, [r15, +1020]
	stclhi	p0, c0, [r0, -1020] !
	stclhi	p15, c15, [r15, +1020] !
	stclhi	p0, c0, [r0], -1020
	stclhi	p15, c15, [r15], +1020
	stclhi	p0, c0, [r0], {0}
	stclhi	p15, c15, [r15], {255}

positive: stclls instruction

	stclls	p0, c0, [r0, -1020]
	stclls	p15, c15, [r15, +1020]
	stclls	p0, c0, [r0, -1020] !
	stclls	p15, c15, [r15, +1020] !
	stclls	p0, c0, [r0], -1020
	stclls	p15, c15, [r15], +1020
	stclls	p0, c0, [r0], {0}
	stclls	p15, c15, [r15], {255}

positive: stclge instruction

	stclge	p0, c0, [r0, -1020]
	stclge	p15, c15, [r15, +1020]
	stclge	p0, c0, [r0, -1020] !
	stclge	p15, c15, [r15, +1020] !
	stclge	p0, c0, [r0], -1020
	stclge	p15, c15, [r15], +1020
	stclge	p0, c0, [r0], {0}
	stclge	p15, c15, [r15], {255}

positive: stcllt instruction

	stcllt	p0, c0, [r0, -1020]
	stcllt	p15, c15, [r15, +1020]
	stcllt	p0, c0, [r0, -1020] !
	stcllt	p15, c15, [r15, +1020] !
	stcllt	p0, c0, [r0], -1020
	stcllt	p15, c15, [r15], +1020
	stcllt	p0, c0, [r0], {0}
	stcllt	p15, c15, [r15], {255}

positive: stclgt instruction

	stclgt	p0, c0, [r0, -1020]
	stclgt	p15, c15, [r15, +1020]
	stclgt	p0, c0, [r0, -1020] !
	stclgt	p15, c15, [r15, +1020] !
	stclgt	p0, c0, [r0], -1020
	stclgt	p15, c15, [r15], +1020
	stclgt	p0, c0, [r0], {0}
	stclgt	p15, c15, [r15], {255}

positive: stclle instruction

	stclle	p0, c0, [r0, -1020]
	stclle	p15, c15, [r15, +1020]
	stclle	p0, c0, [r0, -1020] !
	stclle	p15, c15, [r15, +1020] !
	stclle	p0, c0, [r0], -1020
	stclle	p15, c15, [r15], +1020
	stclle	p0, c0, [r0], {0}
	stclle	p15, c15, [r15], {255}

positive: stclal instruction

	stclal	p0, c0, [r0, -1020]
	stclal	p15, c15, [r15, +1020]
	stclal	p0, c0, [r0, -1020] !
	stclal	p15, c15, [r15, +1020] !
	stclal	p0, c0, [r0], -1020
	stclal	p15, c15, [r15], +1020
	stclal	p0, c0, [r0], {0}
	stclal	p15, c15, [r15], {255}

positive: stc2 instruction

	stc2	p0, c0, [r0, -1020]
	stc2	p15, c15, [r15, +1020]
	stc2	p0, c0, [r0, -1020] !
	stc2	p15, c15, [r15, +1020] !
	stc2	p0, c0, [r0], -1020
	stc2	p15, c15, [r15], +1020
	stc2	p0, c0, [r0], {0}
	stc2	p15, c15, [r15], {255}

positive: stc2l instruction

	stc2l	p0, c0, [r0, -1020]
	stc2l	p15, c15, [r15, +1020]
	stc2l	p0, c0, [r0, -1020] !
	stc2l	p15, c15, [r15, +1020] !
	stc2l	p0, c0, [r0], -1020
	stc2l	p15, c15, [r15], +1020
	stc2l	p0, c0, [r0], {0}
	stc2l	p15, c15, [r15], {255}

positive: stmia instruction

	stmia	r0, {}
	stmia	r15, {r0, r15}
	stmia	r0 !, {}
	stmia	r15 !, {r0, r15}
	stmia	r0, {} ^
	stmia	r0, {r0, r15} ^

positive: stmiaeq instruction

	stmiaeq	r0, {}
	stmiaeq	r15, {r0, r15}
	stmiaeq	r0 !, {}
	stmiaeq	r15 !, {r0, r15}
	stmiaeq	r0, {} ^
	stmiaeq	r0, {r0, r15} ^

positive: stmiane instruction

	stmiane	r0, {}
	stmiane	r15, {r0, r15}
	stmiane	r0 !, {}
	stmiane	r15 !, {r0, r15}
	stmiane	r0, {} ^
	stmiane	r0, {r0, r15} ^

positive: stmiacs instruction

	stmiacs	r0, {}
	stmiacs	r15, {r0, r15}
	stmiacs	r0 !, {}
	stmiacs	r15 !, {r0, r15}
	stmiacs	r0, {} ^
	stmiacs	r0, {r0, r15} ^

positive: stmiahs instruction

	stmiahs	r0, {}
	stmiahs	r15, {r0, r15}
	stmiahs	r0 !, {}
	stmiahs	r15 !, {r0, r15}
	stmiahs	r0, {} ^
	stmiahs	r0, {r0, r15} ^

positive: stmiacc instruction

	stmiacc	r0, {}
	stmiacc	r15, {r0, r15}
	stmiacc	r0 !, {}
	stmiacc	r15 !, {r0, r15}
	stmiacc	r0, {} ^
	stmiacc	r0, {r0, r15} ^

positive: stmialo instruction

	stmialo	r0, {}
	stmialo	r15, {r0, r15}
	stmialo	r0 !, {}
	stmialo	r15 !, {r0, r15}
	stmialo	r0, {} ^
	stmialo	r0, {r0, r15} ^

positive: stmiami instruction

	stmiami	r0, {}
	stmiami	r15, {r0, r15}
	stmiami	r0 !, {}
	stmiami	r15 !, {r0, r15}
	stmiami	r0, {} ^
	stmiami	r0, {r0, r15} ^

positive: stmiapl instruction

	stmiapl	r0, {}
	stmiapl	r15, {r0, r15}
	stmiapl	r0 !, {}
	stmiapl	r15 !, {r0, r15}
	stmiapl	r0, {} ^
	stmiapl	r0, {r0, r15} ^

positive: stmiavs instruction

	stmiavs	r0, {}
	stmiavs	r15, {r0, r15}
	stmiavs	r0 !, {}
	stmiavs	r15 !, {r0, r15}
	stmiavs	r0, {} ^
	stmiavs	r0, {r0, r15} ^

positive: stmiavc instruction

	stmiavc	r0, {}
	stmiavc	r15, {r0, r15}
	stmiavc	r0 !, {}
	stmiavc	r15 !, {r0, r15}
	stmiavc	r0, {} ^
	stmiavc	r0, {r0, r15} ^

positive: stmiahi instruction

	stmiahi	r0, {}
	stmiahi	r15, {r0, r15}
	stmiahi	r0 !, {}
	stmiahi	r15 !, {r0, r15}
	stmiahi	r0, {} ^
	stmiahi	r0, {r0, r15} ^

positive: stmials instruction

	stmials	r0, {}
	stmials	r15, {r0, r15}
	stmials	r0 !, {}
	stmials	r15 !, {r0, r15}
	stmials	r0, {} ^
	stmials	r0, {r0, r15} ^

positive: stmiage instruction

	stmiage	r0, {}
	stmiage	r15, {r0, r15}
	stmiage	r0 !, {}
	stmiage	r15 !, {r0, r15}
	stmiage	r0, {} ^
	stmiage	r0, {r0, r15} ^

positive: stmialt instruction

	stmialt	r0, {}
	stmialt	r15, {r0, r15}
	stmialt	r0 !, {}
	stmialt	r15 !, {r0, r15}
	stmialt	r0, {} ^
	stmialt	r0, {r0, r15} ^

positive: stmiagt instruction

	stmiagt	r0, {}
	stmiagt	r15, {r0, r15}
	stmiagt	r0 !, {}
	stmiagt	r15 !, {r0, r15}
	stmiagt	r0, {} ^
	stmiagt	r0, {r0, r15} ^

positive: stmiale instruction

	stmiale	r0, {}
	stmiale	r15, {r0, r15}
	stmiale	r0 !, {}
	stmiale	r15 !, {r0, r15}
	stmiale	r0, {} ^
	stmiale	r0, {r0, r15} ^

positive: stmiaal instruction

	stmiaal	r0, {}
	stmiaal	r15, {r0, r15}
	stmiaal	r0 !, {}
	stmiaal	r15 !, {r0, r15}
	stmiaal	r0, {} ^
	stmiaal	r0, {r0, r15} ^

positive: stmib instruction

	stmib	r0, {}
	stmib	r15, {r0, r15}
	stmib	r0 !, {}
	stmib	r15 !, {r0, r15}
	stmib	r0, {} ^
	stmib	r0, {r0, r15} ^

positive: stmibeq instruction

	stmibeq	r0, {}
	stmibeq	r15, {r0, r15}
	stmibeq	r0 !, {}
	stmibeq	r15 !, {r0, r15}
	stmibeq	r0, {} ^
	stmibeq	r0, {r0, r15} ^

positive: stmibne instruction

	stmibne	r0, {}
	stmibne	r15, {r0, r15}
	stmibne	r0 !, {}
	stmibne	r15 !, {r0, r15}
	stmibne	r0, {} ^
	stmibne	r0, {r0, r15} ^

positive: stmibcs instruction

	stmibcs	r0, {}
	stmibcs	r15, {r0, r15}
	stmibcs	r0 !, {}
	stmibcs	r15 !, {r0, r15}
	stmibcs	r0, {} ^
	stmibcs	r0, {r0, r15} ^

positive: stmibhs instruction

	stmibhs	r0, {}
	stmibhs	r15, {r0, r15}
	stmibhs	r0 !, {}
	stmibhs	r15 !, {r0, r15}
	stmibhs	r0, {} ^
	stmibhs	r0, {r0, r15} ^

positive: stmibcc instruction

	stmibcc	r0, {}
	stmibcc	r15, {r0, r15}
	stmibcc	r0 !, {}
	stmibcc	r15 !, {r0, r15}
	stmibcc	r0, {} ^
	stmibcc	r0, {r0, r15} ^

positive: stmiblo instruction

	stmiblo	r0, {}
	stmiblo	r15, {r0, r15}
	stmiblo	r0 !, {}
	stmiblo	r15 !, {r0, r15}
	stmiblo	r0, {} ^
	stmiblo	r0, {r0, r15} ^

positive: stmibmi instruction

	stmibmi	r0, {}
	stmibmi	r15, {r0, r15}
	stmibmi	r0 !, {}
	stmibmi	r15 !, {r0, r15}
	stmibmi	r0, {} ^
	stmibmi	r0, {r0, r15} ^

positive: stmibpl instruction

	stmibpl	r0, {}
	stmibpl	r15, {r0, r15}
	stmibpl	r0 !, {}
	stmibpl	r15 !, {r0, r15}
	stmibpl	r0, {} ^
	stmibpl	r0, {r0, r15} ^

positive: stmibvs instruction

	stmibvs	r0, {}
	stmibvs	r15, {r0, r15}
	stmibvs	r0 !, {}
	stmibvs	r15 !, {r0, r15}
	stmibvs	r0, {} ^
	stmibvs	r0, {r0, r15} ^

positive: stmibvc instruction

	stmibvc	r0, {}
	stmibvc	r15, {r0, r15}
	stmibvc	r0 !, {}
	stmibvc	r15 !, {r0, r15}
	stmibvc	r0, {} ^
	stmibvc	r0, {r0, r15} ^

positive: stmibhi instruction

	stmibhi	r0, {}
	stmibhi	r15, {r0, r15}
	stmibhi	r0 !, {}
	stmibhi	r15 !, {r0, r15}
	stmibhi	r0, {} ^
	stmibhi	r0, {r0, r15} ^

positive: stmibls instruction

	stmibls	r0, {}
	stmibls	r15, {r0, r15}
	stmibls	r0 !, {}
	stmibls	r15 !, {r0, r15}
	stmibls	r0, {} ^
	stmibls	r0, {r0, r15} ^

positive: stmibge instruction

	stmibge	r0, {}
	stmibge	r15, {r0, r15}
	stmibge	r0 !, {}
	stmibge	r15 !, {r0, r15}
	stmibge	r0, {} ^
	stmibge	r0, {r0, r15} ^

positive: stmiblt instruction

	stmiblt	r0, {}
	stmiblt	r15, {r0, r15}
	stmiblt	r0 !, {}
	stmiblt	r15 !, {r0, r15}
	stmiblt	r0, {} ^
	stmiblt	r0, {r0, r15} ^

positive: stmibgt instruction

	stmibgt	r0, {}
	stmibgt	r15, {r0, r15}
	stmibgt	r0 !, {}
	stmibgt	r15 !, {r0, r15}
	stmibgt	r0, {} ^
	stmibgt	r0, {r0, r15} ^

positive: stmible instruction

	stmible	r0, {}
	stmible	r15, {r0, r15}
	stmible	r0 !, {}
	stmible	r15 !, {r0, r15}
	stmible	r0, {} ^
	stmible	r0, {r0, r15} ^

positive: stmibal instruction

	stmibal	r0, {}
	stmibal	r15, {r0, r15}
	stmibal	r0 !, {}
	stmibal	r15 !, {r0, r15}
	stmibal	r0, {} ^
	stmibal	r0, {r0, r15} ^

positive: stmda instruction

	stmda	r0, {}
	stmda	r15, {r0, r15}
	stmda	r0 !, {}
	stmda	r15 !, {r0, r15}
	stmda	r0, {} ^
	stmda	r0, {r0, r15} ^

positive: stmdaeq instruction

	stmdaeq	r0, {}
	stmdaeq	r15, {r0, r15}
	stmdaeq	r0 !, {}
	stmdaeq	r15 !, {r0, r15}
	stmdaeq	r0, {} ^
	stmdaeq	r0, {r0, r15} ^

positive: stmdane instruction

	stmdane	r0, {}
	stmdane	r15, {r0, r15}
	stmdane	r0 !, {}
	stmdane	r15 !, {r0, r15}
	stmdane	r0, {} ^
	stmdane	r0, {r0, r15} ^

positive: stmdacs instruction

	stmdacs	r0, {}
	stmdacs	r15, {r0, r15}
	stmdacs	r0 !, {}
	stmdacs	r15 !, {r0, r15}
	stmdacs	r0, {} ^
	stmdacs	r0, {r0, r15} ^

positive: stmdahs instruction

	stmdahs	r0, {}
	stmdahs	r15, {r0, r15}
	stmdahs	r0 !, {}
	stmdahs	r15 !, {r0, r15}
	stmdahs	r0, {} ^
	stmdahs	r0, {r0, r15} ^

positive: stmdacc instruction

	stmdacc	r0, {}
	stmdacc	r15, {r0, r15}
	stmdacc	r0 !, {}
	stmdacc	r15 !, {r0, r15}
	stmdacc	r0, {} ^
	stmdacc	r0, {r0, r15} ^

positive: stmdalo instruction

	stmdalo	r0, {}
	stmdalo	r15, {r0, r15}
	stmdalo	r0 !, {}
	stmdalo	r15 !, {r0, r15}
	stmdalo	r0, {} ^
	stmdalo	r0, {r0, r15} ^

positive: stmdami instruction

	stmdami	r0, {}
	stmdami	r15, {r0, r15}
	stmdami	r0 !, {}
	stmdami	r15 !, {r0, r15}
	stmdami	r0, {} ^
	stmdami	r0, {r0, r15} ^

positive: stmdapl instruction

	stmdapl	r0, {}
	stmdapl	r15, {r0, r15}
	stmdapl	r0 !, {}
	stmdapl	r15 !, {r0, r15}
	stmdapl	r0, {} ^
	stmdapl	r0, {r0, r15} ^

positive: stmdavs instruction

	stmdavs	r0, {}
	stmdavs	r15, {r0, r15}
	stmdavs	r0 !, {}
	stmdavs	r15 !, {r0, r15}
	stmdavs	r0, {} ^
	stmdavs	r0, {r0, r15} ^

positive: stmdavc instruction

	stmdavc	r0, {}
	stmdavc	r15, {r0, r15}
	stmdavc	r0 !, {}
	stmdavc	r15 !, {r0, r15}
	stmdavc	r0, {} ^
	stmdavc	r0, {r0, r15} ^

positive: stmdahi instruction

	stmdahi	r0, {}
	stmdahi	r15, {r0, r15}
	stmdahi	r0 !, {}
	stmdahi	r15 !, {r0, r15}
	stmdahi	r0, {} ^
	stmdahi	r0, {r0, r15} ^

positive: stmdals instruction

	stmdals	r0, {}
	stmdals	r15, {r0, r15}
	stmdals	r0 !, {}
	stmdals	r15 !, {r0, r15}
	stmdals	r0, {} ^
	stmdals	r0, {r0, r15} ^

positive: stmdage instruction

	stmdage	r0, {}
	stmdage	r15, {r0, r15}
	stmdage	r0 !, {}
	stmdage	r15 !, {r0, r15}
	stmdage	r0, {} ^
	stmdage	r0, {r0, r15} ^

positive: stmdalt instruction

	stmdalt	r0, {}
	stmdalt	r15, {r0, r15}
	stmdalt	r0 !, {}
	stmdalt	r15 !, {r0, r15}
	stmdalt	r0, {} ^
	stmdalt	r0, {r0, r15} ^

positive: stmdagt instruction

	stmdagt	r0, {}
	stmdagt	r15, {r0, r15}
	stmdagt	r0 !, {}
	stmdagt	r15 !, {r0, r15}
	stmdagt	r0, {} ^
	stmdagt	r0, {r0, r15} ^

positive: stmdale instruction

	stmdale	r0, {}
	stmdale	r15, {r0, r15}
	stmdale	r0 !, {}
	stmdale	r15 !, {r0, r15}
	stmdale	r0, {} ^
	stmdale	r0, {r0, r15} ^

positive: stmdaal instruction

	stmdaal	r0, {}
	stmdaal	r15, {r0, r15}
	stmdaal	r0 !, {}
	stmdaal	r15 !, {r0, r15}
	stmdaal	r0, {} ^
	stmdaal	r0, {r0, r15} ^

positive: stmdb instruction

	stmdb	r0, {}
	stmdb	r15, {r0, r15}
	stmdb	r0 !, {}
	stmdb	r15 !, {r0, r15}
	stmdb	r0, {} ^
	stmdb	r0, {r0, r15} ^

positive: stmdbeq instruction

	stmdbeq	r0, {}
	stmdbeq	r15, {r0, r15}
	stmdbeq	r0 !, {}
	stmdbeq	r15 !, {r0, r15}
	stmdbeq	r0, {} ^
	stmdbeq	r0, {r0, r15} ^

positive: stmdbne instruction

	stmdbne	r0, {}
	stmdbne	r15, {r0, r15}
	stmdbne	r0 !, {}
	stmdbne	r15 !, {r0, r15}
	stmdbne	r0, {} ^
	stmdbne	r0, {r0, r15} ^

positive: stmdbcs instruction

	stmdbcs	r0, {}
	stmdbcs	r15, {r0, r15}
	stmdbcs	r0 !, {}
	stmdbcs	r15 !, {r0, r15}
	stmdbcs	r0, {} ^
	stmdbcs	r0, {r0, r15} ^

positive: stmdbhs instruction

	stmdbhs	r0, {}
	stmdbhs	r15, {r0, r15}
	stmdbhs	r0 !, {}
	stmdbhs	r15 !, {r0, r15}
	stmdbhs	r0, {} ^

positive: stmdbcc instruction

	stmdbcc	r0, {}
	stmdbcc	r15, {r0, r15}
	stmdbcc	r0 !, {}
	stmdbcc	r15 !, {r0, r15}
	stmdbcc	r0, {} ^
	stmdbcc	r0, {r0, r15} ^

positive: stmdblo instruction

	stmdblo	r0, {}
	stmdblo	r15, {r0, r15}
	stmdblo	r0 !, {}
	stmdblo	r15 !, {r0, r15}
	stmdblo	r0, {} ^
	stmdblo	r0, {r0, r15} ^

positive: stmdbmi instruction

	stmdbmi	r0, {}
	stmdbmi	r15, {r0, r15}
	stmdbmi	r0 !, {}
	stmdbmi	r15 !, {r0, r15}
	stmdbmi	r0, {} ^
	stmdbmi	r0, {r0, r15} ^

positive: stmdbpl instruction

	stmdbpl	r0, {}
	stmdbpl	r15, {r0, r15}
	stmdbpl	r0 !, {}
	stmdbpl	r15 !, {r0, r15}
	stmdbpl	r0, {} ^
	stmdbpl	r0, {r0, r15} ^

positive: stmdbvs instruction

	stmdbvs	r0, {}
	stmdbvs	r15, {r0, r15}
	stmdbvs	r0 !, {}
	stmdbvs	r15 !, {r0, r15}
	stmdbvs	r0, {} ^
	stmdbvs	r0, {r0, r15} ^

positive: stmdbvc instruction

	stmdbvc	r0, {}
	stmdbvc	r15, {r0, r15}
	stmdbvc	r0 !, {}
	stmdbvc	r15 !, {r0, r15}
	stmdbvc	r0, {} ^
	stmdbvc	r0, {r0, r15} ^

positive: stmdbhi instruction

	stmdbhi	r0, {}
	stmdbhi	r15, {r0, r15}
	stmdbhi	r0 !, {}
	stmdbhi	r15 !, {r0, r15}
	stmdbhi	r0, {} ^
	stmdbhi	r0, {r0, r15} ^

positive: stmdbls instruction

	stmdbls	r0, {}
	stmdbls	r15, {r0, r15}
	stmdbls	r0 !, {}
	stmdbls	r15 !, {r0, r15}
	stmdbls	r0, {} ^
	stmdbls	r0, {r0, r15} ^

positive: stmdbge instruction

	stmdbge	r0, {}
	stmdbge	r15, {r0, r15}
	stmdbge	r0 !, {}
	stmdbge	r15 !, {r0, r15}
	stmdbge	r0, {} ^
	stmdbge	r0, {r0, r15} ^

positive: stmdblt instruction

	stmdblt	r0, {}
	stmdblt	r15, {r0, r15}
	stmdblt	r0 !, {}
	stmdblt	r15 !, {r0, r15}
	stmdblt	r0, {} ^
	stmdblt	r0, {r0, r15} ^

positive: stmdbgt instruction

	stmdbgt	r0, {}
	stmdbgt	r15, {r0, r15}
	stmdbgt	r0 !, {}
	stmdbgt	r15 !, {r0, r15}
	stmdbgt	r0, {} ^
	stmdbgt	r0, {r0, r15} ^

positive: stmdble instruction

	stmdble	r0, {}
	stmdble	r15, {r0, r15}
	stmdble	r0 !, {}
	stmdble	r15 !, {r0, r15}
	stmdble	r0, {} ^
	stmdble	r0, {r0, r15} ^

positive: stmdbal instruction

	stmdbal	r0, {}
	stmdbal	r15, {r0, r15}
	stmdbal	r0 !, {}
	stmdbal	r15 !, {r0, r15}
	stmdbal	r0, {} ^
	stmdbal	r0, {r0, r15} ^

positive: str instruction

	str	r0, [r0, -4095]
	str	r15, [r15, +4095]
	str	r0, [r0, -r0]
	str	r15, [r15, +r15]
	str	r0, [r1, r2, lsl 0]
	str	r15, [r15, r15, lsl 31]
	str	r0, [r1, r2, lsr 1]
	str	r15, [r15, r15, lsr 32]
	str	r0, [r1, r2, asr 1]
	str	r15, [r15, r15, asr 32]
	str	r0, [r1, r2, ror 1]
	str	r15, [r15, r15, ror 31]
	str	r0, [r1, r2, rrx]
	str	r15, [r15, r15, rrx]
	str	r0, [r0, -4095] !
	str	r15, [r15, +4095] !
	str	r0, [r0, -r0] !
	str	r15, [r15, +r15] !
	str	r0, [r1, r2, lsl 0] !
	str	r15, [r15, r15, lsl 31] !
	str	r0, [r1, r2, lsr 1] !
	str	r15, [r15, r15, lsr 32] !
	str	r0, [r1, r2, asr 1] !
	str	r15, [r15, r15, asr 32] !
	str	r0, [r1, r2, ror 1] !
	str	r15, [r15, r15, ror 31] !
	str	r0, [r1, r2, rrx] !
	str	r15, [r15, r15, rrx] !
	str	r0, [r0], -4095
	str	r15, [r15], +4095
	str	r0, [r0], -r0
	str	r15, [r15], +r15
	str	r0, [r1], r2, lsl 0
	str	r15, [r15], r15, lsl 31
	str	r0, [r1], r2, lsr 1
	str	r15, [r15], r15, lsr 32
	str	r0, [r1], r2, asr 1
	str	r15, [r15], r15, asr 32
	str	r0, [r1], r2, ror 1
	str	r15, [r15], r15, ror 31
	str	r0, [r1], r2, rrx
	str	r15, [r15], r15, rrx

positive: streq instruction

	streq	r0, [r0, -4095]
	streq	r15, [r15, +4095]
	streq	r0, [r0, -r0]
	streq	r15, [r15, +r15]
	streq	r0, [r1, r2, lsl 0]
	streq	r15, [r15, r15, lsl 31]
	streq	r0, [r1, r2, lsr 1]
	streq	r15, [r15, r15, lsr 32]
	streq	r0, [r1, r2, asr 1]
	streq	r15, [r15, r15, asr 32]
	streq	r0, [r1, r2, ror 1]
	streq	r15, [r15, r15, ror 31]
	streq	r0, [r1, r2, rrx]
	streq	r15, [r15, r15, rrx]
	streq	r0, [r0, -4095] !
	streq	r15, [r15, +4095] !
	streq	r0, [r0, -r0] !
	streq	r15, [r15, +r15] !
	streq	r0, [r1, r2, lsl 0] !
	streq	r15, [r15, r15, lsl 31] !
	streq	r0, [r1, r2, lsr 1] !
	streq	r15, [r15, r15, lsr 32] !
	streq	r0, [r1, r2, asr 1] !
	streq	r15, [r15, r15, asr 32] !
	streq	r0, [r1, r2, ror 1] !
	streq	r15, [r15, r15, ror 31] !
	streq	r0, [r1, r2, rrx] !
	streq	r15, [r15, r15, rrx] !
	streq	r0, [r0], -4095
	streq	r15, [r15], +4095
	streq	r0, [r0], -r0
	streq	r15, [r15], +r15
	streq	r0, [r1], r2, lsl 0
	streq	r15, [r15], r15, lsl 31
	streq	r0, [r1], r2, lsr 1
	streq	r15, [r15], r15, lsr 32
	streq	r0, [r1], r2, asr 1
	streq	r15, [r15], r15, asr 32
	streq	r0, [r1], r2, ror 1
	streq	r15, [r15], r15, ror 31
	streq	r0, [r1], r2, rrx
	streq	r15, [r15], r15, rrx

positive: strne instruction

	strne	r0, [r0, -4095]
	strne	r15, [r15, +4095]
	strne	r0, [r0, -r0]
	strne	r15, [r15, +r15]
	strne	r0, [r1, r2, lsl 0]
	strne	r15, [r15, r15, lsl 31]
	strne	r0, [r1, r2, lsr 1]
	strne	r15, [r15, r15, lsr 32]
	strne	r0, [r1, r2, asr 1]
	strne	r15, [r15, r15, asr 32]
	strne	r0, [r1, r2, ror 1]
	strne	r15, [r15, r15, ror 31]
	strne	r0, [r1, r2, rrx]
	strne	r15, [r15, r15, rrx]
	strne	r0, [r0, -4095] !
	strne	r15, [r15, +4095] !
	strne	r0, [r0, -r0] !
	strne	r15, [r15, +r15] !
	strne	r0, [r1, r2, lsl 0] !
	strne	r15, [r15, r15, lsl 31] !
	strne	r0, [r1, r2, lsr 1] !
	strne	r15, [r15, r15, lsr 32] !
	strne	r0, [r1, r2, asr 1] !
	strne	r15, [r15, r15, asr 32] !
	strne	r0, [r1, r2, ror 1] !
	strne	r15, [r15, r15, ror 31] !
	strne	r0, [r1, r2, rrx] !
	strne	r15, [r15, r15, rrx] !
	strne	r0, [r0], -4095
	strne	r15, [r15], +4095
	strne	r0, [r0], -r0
	strne	r15, [r15], +r15
	strne	r0, [r1], r2, lsl 0
	strne	r15, [r15], r15, lsl 31
	strne	r0, [r1], r2, lsr 1
	strne	r15, [r15], r15, lsr 32
	strne	r0, [r1], r2, asr 1
	strne	r15, [r15], r15, asr 32
	strne	r0, [r1], r2, ror 1
	strne	r15, [r15], r15, ror 31
	strne	r0, [r1], r2, rrx
	strne	r15, [r15], r15, rrx

positive: strcs instruction

	strcs	r0, [r0, -4095]
	strcs	r15, [r15, +4095]
	strcs	r0, [r0, -r0]
	strcs	r15, [r15, +r15]
	strcs	r0, [r1, r2, lsl 0]
	strcs	r15, [r15, r15, lsl 31]
	strcs	r0, [r1, r2, lsr 1]
	strcs	r15, [r15, r15, lsr 32]
	strcs	r0, [r1, r2, asr 1]
	strcs	r15, [r15, r15, asr 32]
	strcs	r0, [r1, r2, ror 1]
	strcs	r15, [r15, r15, ror 31]
	strcs	r0, [r1, r2, rrx]
	strcs	r15, [r15, r15, rrx]
	strcs	r0, [r0, -4095] !
	strcs	r15, [r15, +4095] !
	strcs	r0, [r0, -r0] !
	strcs	r15, [r15, +r15] !
	strcs	r0, [r1, r2, lsl 0] !
	strcs	r15, [r15, r15, lsl 31] !
	strcs	r0, [r1, r2, lsr 1] !
	strcs	r15, [r15, r15, lsr 32] !
	strcs	r0, [r1, r2, asr 1] !
	strcs	r15, [r15, r15, asr 32] !
	strcs	r0, [r1, r2, ror 1] !
	strcs	r15, [r15, r15, ror 31] !
	strcs	r0, [r1, r2, rrx] !
	strcs	r15, [r15, r15, rrx] !
	strcs	r0, [r0], -4095
	strcs	r15, [r15], +4095
	strcs	r0, [r0], -r0
	strcs	r15, [r15], +r15
	strcs	r0, [r1], r2, lsl 0
	strcs	r15, [r15], r15, lsl 31
	strcs	r0, [r1], r2, lsr 1
	strcs	r15, [r15], r15, lsr 32
	strcs	r0, [r1], r2, asr 1
	strcs	r15, [r15], r15, asr 32
	strcs	r0, [r1], r2, ror 1
	strcs	r15, [r15], r15, ror 31
	strcs	r0, [r1], r2, rrx
	strcs	r15, [r15], r15, rrx

positive: strhs instruction

	strhs	r0, [r0, -4095]
	strhs	r15, [r15, +4095]
	strhs	r0, [r0, -r0]
	strhs	r15, [r15, +r15]
	strhs	r0, [r1, r2, lsl 0]
	strhs	r15, [r15, r15, lsl 31]
	strhs	r0, [r1, r2, lsr 1]
	strhs	r15, [r15, r15, lsr 32]
	strhs	r0, [r1, r2, asr 1]
	strhs	r15, [r15, r15, asr 32]
	strhs	r0, [r1, r2, ror 1]
	strhs	r15, [r15, r15, ror 31]
	strhs	r0, [r1, r2, rrx]
	strhs	r15, [r15, r15, rrx]
	strhs	r0, [r0, -4095] !
	strhs	r15, [r15, +4095] !
	strhs	r0, [r0, -r0] !
	strhs	r15, [r15, +r15] !
	strhs	r0, [r1, r2, lsl 0] !
	strhs	r15, [r15, r15, lsl 31] !
	strhs	r0, [r1, r2, lsr 1] !
	strhs	r15, [r15, r15, lsr 32] !
	strhs	r0, [r1, r2, asr 1] !
	strhs	r15, [r15, r15, asr 32] !
	strhs	r0, [r1, r2, ror 1] !
	strhs	r15, [r15, r15, ror 31] !
	strhs	r0, [r1, r2, rrx] !
	strhs	r15, [r15, r15, rrx] !
	strhs	r0, [r0], -4095
	strhs	r15, [r15], +4095
	strhs	r0, [r0], -r0
	strhs	r15, [r15], +r15
	strhs	r0, [r1], r2, lsl 0
	strhs	r15, [r15], r15, lsl 31
	strhs	r0, [r1], r2, lsr 1
	strhs	r15, [r15], r15, lsr 32
	strhs	r0, [r1], r2, asr 1
	strhs	r15, [r15], r15, asr 32
	strhs	r0, [r1], r2, ror 1
	strhs	r15, [r15], r15, ror 31
	strhs	r0, [r1], r2, rrx
	strhs	r15, [r15], r15, rrx

positive: strcc instruction

	strcc	r0, [r0, -4095]
	strcc	r15, [r15, +4095]
	strcc	r0, [r0, -r0]
	strcc	r15, [r15, +r15]
	strcc	r0, [r1, r2, lsl 0]
	strcc	r15, [r15, r15, lsl 31]
	strcc	r0, [r1, r2, lsr 1]
	strcc	r15, [r15, r15, lsr 32]
	strcc	r0, [r1, r2, asr 1]
	strcc	r15, [r15, r15, asr 32]
	strcc	r0, [r1, r2, ror 1]
	strcc	r15, [r15, r15, ror 31]
	strcc	r0, [r1, r2, rrx]
	strcc	r15, [r15, r15, rrx]
	strcc	r0, [r0, -4095] !
	strcc	r15, [r15, +4095] !
	strcc	r0, [r0, -r0] !
	strcc	r15, [r15, +r15] !
	strcc	r0, [r1, r2, lsl 0] !
	strcc	r15, [r15, r15, lsl 31] !
	strcc	r0, [r1, r2, lsr 1] !
	strcc	r15, [r15, r15, lsr 32] !
	strcc	r0, [r1, r2, asr 1] !
	strcc	r15, [r15, r15, asr 32] !
	strcc	r0, [r1, r2, ror 1] !
	strcc	r15, [r15, r15, ror 31] !
	strcc	r0, [r1, r2, rrx] !
	strcc	r15, [r15, r15, rrx] !
	strcc	r0, [r0], -4095
	strcc	r15, [r15], +4095
	strcc	r0, [r0], -r0
	strcc	r15, [r15], +r15
	strcc	r0, [r1], r2, lsl 0
	strcc	r15, [r15], r15, lsl 31
	strcc	r0, [r1], r2, lsr 1
	strcc	r15, [r15], r15, lsr 32
	strcc	r0, [r1], r2, asr 1
	strcc	r15, [r15], r15, asr 32
	strcc	r0, [r1], r2, ror 1
	strcc	r15, [r15], r15, ror 31
	strcc	r0, [r1], r2, rrx
	strcc	r15, [r15], r15, rrx

positive: strlo instruction

	strlo	r0, [r0, -4095]
	strlo	r15, [r15, +4095]
	strlo	r0, [r0, -r0]
	strlo	r15, [r15, +r15]
	strlo	r0, [r1, r2, lsl 0]
	strlo	r15, [r15, r15, lsl 31]
	strlo	r0, [r1, r2, lsr 1]
	strlo	r15, [r15, r15, lsr 32]
	strlo	r0, [r1, r2, asr 1]
	strlo	r15, [r15, r15, asr 32]
	strlo	r0, [r1, r2, ror 1]
	strlo	r15, [r15, r15, ror 31]
	strlo	r0, [r1, r2, rrx]
	strlo	r15, [r15, r15, rrx]
	strlo	r0, [r0, -4095] !
	strlo	r15, [r15, +4095] !
	strlo	r0, [r0, -r0] !
	strlo	r15, [r15, +r15] !
	strlo	r0, [r1, r2, lsl 0] !
	strlo	r15, [r15, r15, lsl 31] !
	strlo	r0, [r1, r2, lsr 1] !
	strlo	r15, [r15, r15, lsr 32] !
	strlo	r0, [r1, r2, asr 1] !
	strlo	r15, [r15, r15, asr 32] !
	strlo	r0, [r1, r2, ror 1] !
	strlo	r15, [r15, r15, ror 31] !
	strlo	r0, [r1, r2, rrx] !
	strlo	r15, [r15, r15, rrx] !
	strlo	r0, [r0], -4095
	strlo	r15, [r15], +4095
	strlo	r0, [r0], -r0
	strlo	r15, [r15], +r15
	strlo	r0, [r1], r2, lsl 0
	strlo	r15, [r15], r15, lsl 31
	strlo	r0, [r1], r2, lsr 1
	strlo	r15, [r15], r15, lsr 32
	strlo	r0, [r1], r2, asr 1
	strlo	r15, [r15], r15, asr 32
	strlo	r0, [r1], r2, ror 1
	strlo	r15, [r15], r15, ror 31
	strlo	r0, [r1], r2, rrx
	strlo	r15, [r15], r15, rrx

positive: strmi instruction

	strmi	r0, [r0, -4095]
	strmi	r15, [r15, +4095]
	strmi	r0, [r0, -r0]
	strmi	r15, [r15, +r15]
	strmi	r0, [r1, r2, lsl 0]
	strmi	r15, [r15, r15, lsl 31]
	strmi	r0, [r1, r2, lsr 1]
	strmi	r15, [r15, r15, lsr 32]
	strmi	r0, [r1, r2, asr 1]
	strmi	r15, [r15, r15, asr 32]
	strmi	r0, [r1, r2, ror 1]
	strmi	r15, [r15, r15, ror 31]
	strmi	r0, [r1, r2, rrx]
	strmi	r15, [r15, r15, rrx]
	strmi	r0, [r0, -4095] !
	strmi	r15, [r15, +4095] !
	strmi	r0, [r0, -r0] !
	strmi	r15, [r15, +r15] !
	strmi	r0, [r1, r2, lsl 0] !
	strmi	r15, [r15, r15, lsl 31] !
	strmi	r0, [r1, r2, lsr 1] !
	strmi	r15, [r15, r15, lsr 32] !
	strmi	r0, [r1, r2, asr 1] !
	strmi	r15, [r15, r15, asr 32] !
	strmi	r0, [r1, r2, ror 1] !
	strmi	r15, [r15, r15, ror 31] !
	strmi	r0, [r1, r2, rrx] !
	strmi	r15, [r15, r15, rrx] !
	strmi	r0, [r0], -4095
	strmi	r15, [r15], +4095
	strmi	r0, [r0], -r0
	strmi	r15, [r15], +r15
	strmi	r0, [r1], r2, lsl 0
	strmi	r15, [r15], r15, lsl 31
	strmi	r0, [r1], r2, lsr 1
	strmi	r15, [r15], r15, lsr 32
	strmi	r0, [r1], r2, asr 1
	strmi	r15, [r15], r15, asr 32
	strmi	r0, [r1], r2, ror 1
	strmi	r15, [r15], r15, ror 31
	strmi	r0, [r1], r2, rrx
	strmi	r15, [r15], r15, rrx

positive: strpl instruction

	strpl	r0, [r0, -4095]
	strpl	r15, [r15, +4095]
	strpl	r0, [r0, -r0]
	strpl	r15, [r15, +r15]
	strpl	r0, [r1, r2, lsl 0]
	strpl	r15, [r15, r15, lsl 31]
	strpl	r0, [r1, r2, lsr 1]
	strpl	r15, [r15, r15, lsr 32]
	strpl	r0, [r1, r2, asr 1]
	strpl	r15, [r15, r15, asr 32]
	strpl	r0, [r1, r2, ror 1]
	strpl	r15, [r15, r15, ror 31]
	strpl	r0, [r1, r2, rrx]
	strpl	r15, [r15, r15, rrx]
	strpl	r0, [r0, -4095] !
	strpl	r15, [r15, +4095] !
	strpl	r0, [r0, -r0] !
	strpl	r15, [r15, +r15] !
	strpl	r0, [r1, r2, lsl 0] !
	strpl	r15, [r15, r15, lsl 31] !
	strpl	r0, [r1, r2, lsr 1] !
	strpl	r15, [r15, r15, lsr 32] !
	strpl	r0, [r1, r2, asr 1] !
	strpl	r15, [r15, r15, asr 32] !
	strpl	r0, [r1, r2, ror 1] !
	strpl	r15, [r15, r15, ror 31] !
	strpl	r0, [r1, r2, rrx] !
	strpl	r15, [r15, r15, rrx] !
	strpl	r0, [r0], -4095
	strpl	r15, [r15], +4095
	strpl	r0, [r0], -r0
	strpl	r15, [r15], +r15
	strpl	r0, [r1], r2, lsl 0
	strpl	r15, [r15], r15, lsl 31
	strpl	r0, [r1], r2, lsr 1
	strpl	r15, [r15], r15, lsr 32
	strpl	r0, [r1], r2, asr 1
	strpl	r15, [r15], r15, asr 32
	strpl	r0, [r1], r2, ror 1
	strpl	r15, [r15], r15, ror 31
	strpl	r0, [r1], r2, rrx
	strpl	r15, [r15], r15, rrx

positive: strvs instruction

	strvs	r0, [r0, -4095]
	strvs	r15, [r15, +4095]
	strvs	r0, [r0, -r0]
	strvs	r15, [r15, +r15]
	strvs	r0, [r1, r2, lsl 0]
	strvs	r15, [r15, r15, lsl 31]
	strvs	r0, [r1, r2, lsr 1]
	strvs	r15, [r15, r15, lsr 32]
	strvs	r0, [r1, r2, asr 1]
	strvs	r15, [r15, r15, asr 32]
	strvs	r0, [r1, r2, ror 1]
	strvs	r15, [r15, r15, ror 31]
	strvs	r0, [r1, r2, rrx]
	strvs	r15, [r15, r15, rrx]
	strvs	r0, [r0, -4095] !
	strvs	r15, [r15, +4095] !
	strvs	r0, [r0, -r0] !
	strvs	r15, [r15, +r15] !
	strvs	r0, [r1, r2, lsl 0] !
	strvs	r15, [r15, r15, lsl 31] !
	strvs	r0, [r1, r2, lsr 1] !
	strvs	r15, [r15, r15, lsr 32] !
	strvs	r0, [r1, r2, asr 1] !
	strvs	r15, [r15, r15, asr 32] !
	strvs	r0, [r1, r2, ror 1] !
	strvs	r15, [r15, r15, ror 31] !
	strvs	r0, [r1, r2, rrx] !
	strvs	r15, [r15, r15, rrx] !
	strvs	r0, [r0], -4095
	strvs	r15, [r15], +4095
	strvs	r0, [r0], -r0
	strvs	r15, [r15], +r15
	strvs	r0, [r1], r2, lsl 0
	strvs	r15, [r15], r15, lsl 31
	strvs	r0, [r1], r2, lsr 1
	strvs	r15, [r15], r15, lsr 32
	strvs	r0, [r1], r2, asr 1
	strvs	r15, [r15], r15, asr 32
	strvs	r0, [r1], r2, ror 1
	strvs	r15, [r15], r15, ror 31
	strvs	r0, [r1], r2, rrx
	strvs	r15, [r15], r15, rrx

positive: strvc instruction

	strvc	r0, [r0, -4095]
	strvc	r15, [r15, +4095]
	strvc	r0, [r0, -r0]
	strvc	r15, [r15, +r15]
	strvc	r0, [r1, r2, lsl 0]
	strvc	r15, [r15, r15, lsl 31]
	strvc	r0, [r1, r2, lsr 1]
	strvc	r15, [r15, r15, lsr 32]
	strvc	r0, [r1, r2, asr 1]
	strvc	r15, [r15, r15, asr 32]
	strvc	r0, [r1, r2, ror 1]
	strvc	r15, [r15, r15, ror 31]
	strvc	r0, [r1, r2, rrx]
	strvc	r15, [r15, r15, rrx]
	strvc	r0, [r0, -4095] !
	strvc	r15, [r15, +4095] !
	strvc	r0, [r0, -r0] !
	strvc	r15, [r15, +r15] !
	strvc	r0, [r1, r2, lsl 0] !
	strvc	r15, [r15, r15, lsl 31] !
	strvc	r0, [r1, r2, lsr 1] !
	strvc	r15, [r15, r15, lsr 32] !
	strvc	r0, [r1, r2, asr 1] !
	strvc	r15, [r15, r15, asr 32] !
	strvc	r0, [r1, r2, ror 1] !
	strvc	r15, [r15, r15, ror 31] !
	strvc	r0, [r1, r2, rrx] !
	strvc	r15, [r15, r15, rrx] !
	strvc	r0, [r0], -4095
	strvc	r15, [r15], +4095
	strvc	r0, [r0], -r0
	strvc	r15, [r15], +r15
	strvc	r0, [r1], r2, lsl 0
	strvc	r15, [r15], r15, lsl 31
	strvc	r0, [r1], r2, lsr 1
	strvc	r15, [r15], r15, lsr 32
	strvc	r0, [r1], r2, asr 1
	strvc	r15, [r15], r15, asr 32
	strvc	r0, [r1], r2, ror 1
	strvc	r15, [r15], r15, ror 31
	strvc	r0, [r1], r2, rrx
	strvc	r15, [r15], r15, rrx

positive: strhi instruction

	strhi	r0, [r0, -4095]
	strhi	r15, [r15, +4095]
	strhi	r0, [r0, -r0]
	strhi	r15, [r15, +r15]
	strhi	r0, [r1, r2, lsl 0]
	strhi	r15, [r15, r15, lsl 31]
	strhi	r0, [r1, r2, lsr 1]
	strhi	r15, [r15, r15, lsr 32]
	strhi	r0, [r1, r2, asr 1]
	strhi	r15, [r15, r15, asr 32]
	strhi	r0, [r1, r2, ror 1]
	strhi	r15, [r15, r15, ror 31]
	strhi	r0, [r1, r2, rrx]
	strhi	r15, [r15, r15, rrx]
	strhi	r0, [r0, -4095] !
	strhi	r15, [r15, +4095] !
	strhi	r0, [r0, -r0] !
	strhi	r15, [r15, +r15] !
	strhi	r0, [r1, r2, lsl 0] !
	strhi	r15, [r15, r15, lsl 31] !
	strhi	r0, [r1, r2, lsr 1] !
	strhi	r15, [r15, r15, lsr 32] !
	strhi	r0, [r1, r2, asr 1] !
	strhi	r15, [r15, r15, asr 32] !
	strhi	r0, [r1, r2, ror 1] !
	strhi	r15, [r15, r15, ror 31] !
	strhi	r0, [r1, r2, rrx] !
	strhi	r15, [r15, r15, rrx] !
	strhi	r0, [r0], -4095
	strhi	r15, [r15], +4095
	strhi	r0, [r0], -r0
	strhi	r15, [r15], +r15
	strhi	r0, [r1], r2, lsl 0
	strhi	r15, [r15], r15, lsl 31
	strhi	r0, [r1], r2, lsr 1
	strhi	r15, [r15], r15, lsr 32
	strhi	r0, [r1], r2, asr 1
	strhi	r15, [r15], r15, asr 32
	strhi	r0, [r1], r2, ror 1
	strhi	r15, [r15], r15, ror 31
	strhi	r0, [r1], r2, rrx
	strhi	r15, [r15], r15, rrx

positive: strls instruction

	strls	r0, [r0, -4095]
	strls	r15, [r15, +4095]
	strls	r0, [r0, -r0]
	strls	r15, [r15, +r15]
	strls	r0, [r1, r2, lsl 0]
	strls	r15, [r15, r15, lsl 31]
	strls	r0, [r1, r2, lsr 1]
	strls	r15, [r15, r15, lsr 32]
	strls	r0, [r1, r2, asr 1]
	strls	r15, [r15, r15, asr 32]
	strls	r0, [r1, r2, ror 1]
	strls	r15, [r15, r15, ror 31]
	strls	r0, [r1, r2, rrx]
	strls	r15, [r15, r15, rrx]
	strls	r0, [r0, -4095] !
	strls	r15, [r15, +4095] !
	strls	r0, [r0, -r0] !
	strls	r15, [r15, +r15] !
	strls	r0, [r1, r2, lsl 0] !
	strls	r15, [r15, r15, lsl 31] !
	strls	r0, [r1, r2, lsr 1] !
	strls	r15, [r15, r15, lsr 32] !
	strls	r0, [r1, r2, asr 1] !
	strls	r15, [r15, r15, asr 32] !
	strls	r0, [r1, r2, ror 1] !
	strls	r15, [r15, r15, ror 31] !
	strls	r0, [r1, r2, rrx] !
	strls	r15, [r15, r15, rrx] !
	strls	r0, [r0], -4095
	strls	r15, [r15], +4095
	strls	r0, [r0], -r0
	strls	r15, [r15], +r15
	strls	r0, [r1], r2, lsl 0
	strls	r15, [r15], r15, lsl 31
	strls	r0, [r1], r2, lsr 1
	strls	r15, [r15], r15, lsr 32
	strls	r0, [r1], r2, asr 1
	strls	r15, [r15], r15, asr 32
	strls	r0, [r1], r2, ror 1
	strls	r15, [r15], r15, ror 31
	strls	r0, [r1], r2, rrx
	strls	r15, [r15], r15, rrx

positive: strge instruction

	strge	r0, [r0, -4095]
	strge	r15, [r15, +4095]
	strge	r0, [r0, -r0]
	strge	r15, [r15, +r15]
	strge	r0, [r1, r2, lsl 0]
	strge	r15, [r15, r15, lsl 31]
	strge	r0, [r1, r2, lsr 1]
	strge	r15, [r15, r15, lsr 32]
	strge	r0, [r1, r2, asr 1]
	strge	r15, [r15, r15, asr 32]
	strge	r0, [r1, r2, ror 1]
	strge	r15, [r15, r15, ror 31]
	strge	r0, [r1, r2, rrx]
	strge	r15, [r15, r15, rrx]
	strge	r0, [r0, -4095] !
	strge	r15, [r15, +4095] !
	strge	r0, [r0, -r0] !
	strge	r15, [r15, +r15] !
	strge	r0, [r1, r2, lsl 0] !
	strge	r15, [r15, r15, lsl 31] !
	strge	r0, [r1, r2, lsr 1] !
	strge	r15, [r15, r15, lsr 32] !
	strge	r0, [r1, r2, asr 1] !
	strge	r15, [r15, r15, asr 32] !
	strge	r0, [r1, r2, ror 1] !
	strge	r15, [r15, r15, ror 31] !
	strge	r0, [r1, r2, rrx] !
	strge	r15, [r15, r15, rrx] !
	strge	r0, [r0], -4095
	strge	r15, [r15], +4095
	strge	r0, [r0], -r0
	strge	r15, [r15], +r15
	strge	r0, [r1], r2, lsl 0
	strge	r15, [r15], r15, lsl 31
	strge	r0, [r1], r2, lsr 1
	strge	r15, [r15], r15, lsr 32
	strge	r0, [r1], r2, asr 1
	strge	r15, [r15], r15, asr 32
	strge	r0, [r1], r2, ror 1
	strge	r15, [r15], r15, ror 31
	strge	r0, [r1], r2, rrx
	strge	r15, [r15], r15, rrx

positive: strlt instruction

	strlt	r0, [r0, -4095]
	strlt	r15, [r15, +4095]
	strlt	r0, [r0, -r0]
	strlt	r15, [r15, +r15]
	strlt	r0, [r1, r2, lsl 0]
	strlt	r15, [r15, r15, lsl 31]
	strlt	r0, [r1, r2, lsr 1]
	strlt	r15, [r15, r15, lsr 32]
	strlt	r0, [r1, r2, asr 1]
	strlt	r15, [r15, r15, asr 32]
	strlt	r0, [r1, r2, ror 1]
	strlt	r15, [r15, r15, ror 31]
	strlt	r0, [r1, r2, rrx]
	strlt	r15, [r15, r15, rrx]
	strlt	r0, [r0, -4095] !
	strlt	r15, [r15, +4095] !
	strlt	r0, [r0, -r0] !
	strlt	r15, [r15, +r15] !
	strlt	r0, [r1, r2, lsl 0] !
	strlt	r15, [r15, r15, lsl 31] !
	strlt	r0, [r1, r2, lsr 1] !
	strlt	r15, [r15, r15, lsr 32] !
	strlt	r0, [r1, r2, asr 1] !
	strlt	r15, [r15, r15, asr 32] !
	strlt	r0, [r1, r2, ror 1] !
	strlt	r15, [r15, r15, ror 31] !
	strlt	r0, [r1, r2, rrx] !
	strlt	r15, [r15, r15, rrx] !
	strlt	r0, [r0], -4095
	strlt	r15, [r15], +4095
	strlt	r0, [r0], -r0
	strlt	r15, [r15], +r15
	strlt	r0, [r1], r2, lsl 0
	strlt	r15, [r15], r15, lsl 31
	strlt	r0, [r1], r2, lsr 1
	strlt	r15, [r15], r15, lsr 32
	strlt	r0, [r1], r2, asr 1
	strlt	r15, [r15], r15, asr 32
	strlt	r0, [r1], r2, ror 1
	strlt	r15, [r15], r15, ror 31
	strlt	r0, [r1], r2, rrx
	strlt	r15, [r15], r15, rrx

positive: strgt instruction

	strgt	r0, [r0, -4095]
	strgt	r15, [r15, +4095]
	strgt	r0, [r0, -r0]
	strgt	r15, [r15, +r15]
	strgt	r0, [r1, r2, lsl 0]
	strgt	r15, [r15, r15, lsl 31]
	strgt	r0, [r1, r2, lsr 1]
	strgt	r15, [r15, r15, lsr 32]
	strgt	r0, [r1, r2, asr 1]
	strgt	r15, [r15, r15, asr 32]
	strgt	r0, [r1, r2, ror 1]
	strgt	r15, [r15, r15, ror 31]
	strgt	r0, [r1, r2, rrx]
	strgt	r15, [r15, r15, rrx]
	strgt	r0, [r0, -4095] !
	strgt	r15, [r15, +4095] !
	strgt	r0, [r0, -r0] !
	strgt	r15, [r15, +r15] !
	strgt	r0, [r1, r2, lsl 0] !
	strgt	r15, [r15, r15, lsl 31] !
	strgt	r0, [r1, r2, lsr 1] !
	strgt	r15, [r15, r15, lsr 32] !
	strgt	r0, [r1, r2, asr 1] !
	strgt	r15, [r15, r15, asr 32] !
	strgt	r0, [r1, r2, ror 1] !
	strgt	r15, [r15, r15, ror 31] !
	strgt	r0, [r1, r2, rrx] !
	strgt	r15, [r15, r15, rrx] !
	strgt	r0, [r0], -4095
	strgt	r15, [r15], +4095
	strgt	r0, [r0], -r0
	strgt	r15, [r15], +r15
	strgt	r0, [r1], r2, lsl 0
	strgt	r15, [r15], r15, lsl 31
	strgt	r0, [r1], r2, lsr 1
	strgt	r15, [r15], r15, lsr 32
	strgt	r0, [r1], r2, asr 1
	strgt	r15, [r15], r15, asr 32
	strgt	r0, [r1], r2, ror 1
	strgt	r15, [r15], r15, ror 31
	strgt	r0, [r1], r2, rrx
	strgt	r15, [r15], r15, rrx

positive: strle instruction

	strle	r0, [r0, -4095]
	strle	r15, [r15, +4095]
	strle	r0, [r0, -r0]
	strle	r15, [r15, +r15]
	strle	r0, [r1, r2, lsl 0]
	strle	r15, [r15, r15, lsl 31]
	strle	r0, [r1, r2, lsr 1]
	strle	r15, [r15, r15, lsr 32]
	strle	r0, [r1, r2, asr 1]
	strle	r15, [r15, r15, asr 32]
	strle	r0, [r1, r2, ror 1]
	strle	r15, [r15, r15, ror 31]
	strle	r0, [r1, r2, rrx]
	strle	r15, [r15, r15, rrx]
	strle	r0, [r0, -4095] !
	strle	r15, [r15, +4095] !
	strle	r0, [r0, -r0] !
	strle	r15, [r15, +r15] !
	strle	r0, [r1, r2, lsl 0] !
	strle	r15, [r15, r15, lsl 31] !
	strle	r0, [r1, r2, lsr 1] !
	strle	r15, [r15, r15, lsr 32] !
	strle	r0, [r1, r2, asr 1] !
	strle	r15, [r15, r15, asr 32] !
	strle	r0, [r1, r2, ror 1] !
	strle	r15, [r15, r15, ror 31] !
	strle	r0, [r1, r2, rrx] !
	strle	r15, [r15, r15, rrx] !
	strle	r0, [r0], -4095
	strle	r15, [r15], +4095
	strle	r0, [r0], -r0
	strle	r15, [r15], +r15
	strle	r0, [r1], r2, lsl 0
	strle	r15, [r15], r15, lsl 31
	strle	r0, [r1], r2, lsr 1
	strle	r15, [r15], r15, lsr 32
	strle	r0, [r1], r2, asr 1
	strle	r15, [r15], r15, asr 32
	strle	r0, [r1], r2, ror 1
	strle	r15, [r15], r15, ror 31
	strle	r0, [r1], r2, rrx
	strle	r15, [r15], r15, rrx

positive: stral instruction

	stral	r0, [r0, -4095]
	stral	r15, [r15, +4095]
	stral	r0, [r0, -r0]
	stral	r15, [r15, +r15]
	stral	r0, [r1, r2, lsl 0]
	stral	r15, [r15, r15, lsl 31]
	stral	r0, [r1, r2, lsr 1]
	stral	r15, [r15, r15, lsr 32]
	stral	r0, [r1, r2, asr 1]
	stral	r15, [r15, r15, asr 32]
	stral	r0, [r1, r2, ror 1]
	stral	r15, [r15, r15, ror 31]
	stral	r0, [r1, r2, rrx]
	stral	r15, [r15, r15, rrx]
	stral	r0, [r0, -4095] !
	stral	r15, [r15, +4095] !
	stral	r0, [r0, -r0] !
	stral	r15, [r15, +r15] !
	stral	r0, [r1, r2, lsl 0] !
	stral	r15, [r15, r15, lsl 31] !
	stral	r0, [r1, r2, lsr 1] !
	stral	r15, [r15, r15, lsr 32] !
	stral	r0, [r1, r2, asr 1] !
	stral	r15, [r15, r15, asr 32] !
	stral	r0, [r1, r2, ror 1] !
	stral	r15, [r15, r15, ror 31] !
	stral	r0, [r1, r2, rrx] !
	stral	r15, [r15, r15, rrx] !
	stral	r0, [r0], -4095
	stral	r15, [r15], +4095
	stral	r0, [r0], -r0
	stral	r15, [r15], +r15
	stral	r0, [r1], r2, lsl 0
	stral	r15, [r15], r15, lsl 31
	stral	r0, [r1], r2, lsr 1
	stral	r15, [r15], r15, lsr 32
	stral	r0, [r1], r2, asr 1
	stral	r15, [r15], r15, asr 32
	stral	r0, [r1], r2, ror 1
	stral	r15, [r15], r15, ror 31
	stral	r0, [r1], r2, rrx
	stral	r15, [r15], r15, rrx

positive: strb instruction

	strb	r0, [r0, -4095]
	strb	r15, [r15, +4095]
	strb	r0, [r0, -r0]
	strb	r15, [r15, +r15]
	strb	r0, [r1, r2, lsl 0]
	strb	r15, [r15, r15, lsl 31]
	strb	r0, [r1, r2, lsr 1]
	strb	r15, [r15, r15, lsr 32]
	strb	r0, [r1, r2, asr 1]
	strb	r15, [r15, r15, asr 32]
	strb	r0, [r1, r2, ror 1]
	strb	r15, [r15, r15, ror 31]
	strb	r0, [r1, r2, rrx]
	strb	r15, [r15, r15, rrx]
	strb	r0, [r0, -4095] !
	strb	r15, [r15, +4095] !
	strb	r0, [r0, -r0] !
	strb	r15, [r15, +r15] !
	strb	r0, [r1, r2, lsl 0] !
	strb	r15, [r15, r15, lsl 31] !
	strb	r0, [r1, r2, lsr 1] !
	strb	r15, [r15, r15, lsr 32] !
	strb	r0, [r1, r2, asr 1] !
	strb	r15, [r15, r15, asr 32] !
	strb	r0, [r1, r2, ror 1] !
	strb	r15, [r15, r15, ror 31] !
	strb	r0, [r1, r2, rrx] !
	strb	r15, [r15, r15, rrx] !
	strb	r0, [r0], -4095
	strb	r15, [r15], +4095
	strb	r0, [r0], -r0
	strb	r15, [r15], +r15
	strb	r0, [r1], r2, lsl 0
	strb	r15, [r15], r15, lsl 31
	strb	r0, [r1], r2, lsr 1
	strb	r15, [r15], r15, lsr 32
	strb	r0, [r1], r2, asr 1
	strb	r15, [r15], r15, asr 32
	strb	r0, [r1], r2, ror 1
	strb	r15, [r15], r15, ror 31
	strb	r0, [r1], r2, rrx
	strb	r15, [r15], r15, rrx

positive: strbeq instruction

	strbeq	r0, [r0, -4095]
	strbeq	r15, [r15, +4095]
	strbeq	r0, [r0, -r0]
	strbeq	r15, [r15, +r15]
	strbeq	r0, [r1, r2, lsl 0]
	strbeq	r15, [r15, r15, lsl 31]
	strbeq	r0, [r1, r2, lsr 1]
	strbeq	r15, [r15, r15, lsr 32]
	strbeq	r0, [r1, r2, asr 1]
	strbeq	r15, [r15, r15, asr 32]
	strbeq	r0, [r1, r2, ror 1]
	strbeq	r15, [r15, r15, ror 31]
	strbeq	r0, [r1, r2, rrx]
	strbeq	r15, [r15, r15, rrx]
	strbeq	r0, [r0, -4095] !
	strbeq	r15, [r15, +4095] !
	strbeq	r0, [r0, -r0] !
	strbeq	r15, [r15, +r15] !
	strbeq	r0, [r1, r2, lsl 0] !
	strbeq	r15, [r15, r15, lsl 31] !
	strbeq	r0, [r1, r2, lsr 1] !
	strbeq	r15, [r15, r15, lsr 32] !
	strbeq	r0, [r1, r2, asr 1] !
	strbeq	r15, [r15, r15, asr 32] !
	strbeq	r0, [r1, r2, ror 1] !
	strbeq	r15, [r15, r15, ror 31] !
	strbeq	r0, [r1, r2, rrx] !
	strbeq	r15, [r15, r15, rrx] !
	strbeq	r0, [r0], -4095
	strbeq	r15, [r15], +4095
	strbeq	r0, [r0], -r0
	strbeq	r15, [r15], +r15
	strbeq	r0, [r1], r2, lsl 0
	strbeq	r15, [r15], r15, lsl 31
	strbeq	r0, [r1], r2, lsr 1
	strbeq	r15, [r15], r15, lsr 32
	strbeq	r0, [r1], r2, asr 1
	strbeq	r15, [r15], r15, asr 32
	strbeq	r0, [r1], r2, ror 1
	strbeq	r15, [r15], r15, ror 31
	strbeq	r0, [r1], r2, rrx
	strbeq	r15, [r15], r15, rrx

positive: strbne instruction

	strbne	r0, [r0, -4095]
	strbne	r15, [r15, +4095]
	strbne	r0, [r0, -r0]
	strbne	r15, [r15, +r15]
	strbne	r0, [r1, r2, lsl 0]
	strbne	r15, [r15, r15, lsl 31]
	strbne	r0, [r1, r2, lsr 1]
	strbne	r15, [r15, r15, lsr 32]
	strbne	r0, [r1, r2, asr 1]
	strbne	r15, [r15, r15, asr 32]
	strbne	r0, [r1, r2, ror 1]
	strbne	r15, [r15, r15, ror 31]
	strbne	r0, [r1, r2, rrx]
	strbne	r15, [r15, r15, rrx]
	strbne	r0, [r0, -4095] !
	strbne	r15, [r15, +4095] !
	strbne	r0, [r0, -r0] !
	strbne	r15, [r15, +r15] !
	strbne	r0, [r1, r2, lsl 0] !
	strbne	r15, [r15, r15, lsl 31] !
	strbne	r0, [r1, r2, lsr 1] !
	strbne	r15, [r15, r15, lsr 32] !
	strbne	r0, [r1, r2, asr 1] !
	strbne	r15, [r15, r15, asr 32] !
	strbne	r0, [r1, r2, ror 1] !
	strbne	r15, [r15, r15, ror 31] !
	strbne	r0, [r1, r2, rrx] !
	strbne	r15, [r15, r15, rrx] !
	strbne	r0, [r0], -4095
	strbne	r15, [r15], +4095
	strbne	r0, [r0], -r0
	strbne	r15, [r15], +r15
	strbne	r0, [r1], r2, lsl 0
	strbne	r15, [r15], r15, lsl 31
	strbne	r0, [r1], r2, lsr 1
	strbne	r15, [r15], r15, lsr 32
	strbne	r0, [r1], r2, asr 1
	strbne	r15, [r15], r15, asr 32
	strbne	r0, [r1], r2, ror 1
	strbne	r15, [r15], r15, ror 31
	strbne	r0, [r1], r2, rrx
	strbne	r15, [r15], r15, rrx

positive: strbcs instruction

	strbcs	r0, [r0, -4095]
	strbcs	r15, [r15, +4095]
	strbcs	r0, [r0, -r0]
	strbcs	r15, [r15, +r15]
	strbcs	r0, [r1, r2, lsl 0]
	strbcs	r15, [r15, r15, lsl 31]
	strbcs	r0, [r1, r2, lsr 1]
	strbcs	r15, [r15, r15, lsr 32]
	strbcs	r0, [r1, r2, asr 1]
	strbcs	r15, [r15, r15, asr 32]
	strbcs	r0, [r1, r2, ror 1]
	strbcs	r15, [r15, r15, ror 31]
	strbcs	r0, [r1, r2, rrx]
	strbcs	r15, [r15, r15, rrx]
	strbcs	r0, [r0, -4095] !
	strbcs	r15, [r15, +4095] !
	strbcs	r0, [r0, -r0] !
	strbcs	r15, [r15, +r15] !
	strbcs	r0, [r1, r2, lsl 0] !
	strbcs	r15, [r15, r15, lsl 31] !
	strbcs	r0, [r1, r2, lsr 1] !
	strbcs	r15, [r15, r15, lsr 32] !
	strbcs	r0, [r1, r2, asr 1] !
	strbcs	r15, [r15, r15, asr 32] !
	strbcs	r0, [r1, r2, ror 1] !
	strbcs	r15, [r15, r15, ror 31] !
	strbcs	r0, [r1, r2, rrx] !
	strbcs	r15, [r15, r15, rrx] !
	strbcs	r0, [r0], -4095
	strbcs	r15, [r15], +4095
	strbcs	r0, [r0], -r0
	strbcs	r15, [r15], +r15
	strbcs	r0, [r1], r2, lsl 0
	strbcs	r15, [r15], r15, lsl 31
	strbcs	r0, [r1], r2, lsr 1
	strbcs	r15, [r15], r15, lsr 32
	strbcs	r0, [r1], r2, asr 1
	strbcs	r15, [r15], r15, asr 32
	strbcs	r0, [r1], r2, ror 1
	strbcs	r15, [r15], r15, ror 31
	strbcs	r0, [r1], r2, rrx
	strbcs	r15, [r15], r15, rrx

positive: strbhs instruction

	strbhs	r0, [r0, -4095]
	strbhs	r15, [r15, +4095]
	strbhs	r0, [r0, -r0]
	strbhs	r15, [r15, +r15]
	strbhs	r0, [r1, r2, lsl 0]
	strbhs	r15, [r15, r15, lsl 31]
	strbhs	r0, [r1, r2, lsr 1]
	strbhs	r15, [r15, r15, lsr 32]
	strbhs	r0, [r1, r2, asr 1]
	strbhs	r15, [r15, r15, asr 32]
	strbhs	r0, [r1, r2, ror 1]
	strbhs	r15, [r15, r15, ror 31]
	strbhs	r0, [r1, r2, rrx]
	strbhs	r15, [r15, r15, rrx]
	strbhs	r0, [r0, -4095] !
	strbhs	r15, [r15, +4095] !
	strbhs	r0, [r0, -r0] !
	strbhs	r15, [r15, +r15] !
	strbhs	r0, [r1, r2, lsl 0] !
	strbhs	r15, [r15, r15, lsl 31] !
	strbhs	r0, [r1, r2, lsr 1] !
	strbhs	r15, [r15, r15, lsr 32] !
	strbhs	r0, [r1, r2, asr 1] !
	strbhs	r15, [r15, r15, asr 32] !
	strbhs	r0, [r1, r2, ror 1] !
	strbhs	r15, [r15, r15, ror 31] !
	strbhs	r0, [r1, r2, rrx] !
	strbhs	r15, [r15, r15, rrx] !
	strbhs	r0, [r0], -4095
	strbhs	r15, [r15], +4095
	strbhs	r0, [r0], -r0
	strbhs	r15, [r15], +r15
	strbhs	r0, [r1], r2, lsl 0
	strbhs	r15, [r15], r15, lsl 31
	strbhs	r0, [r1], r2, lsr 1
	strbhs	r15, [r15], r15, lsr 32
	strbhs	r0, [r1], r2, asr 1
	strbhs	r15, [r15], r15, asr 32
	strbhs	r0, [r1], r2, ror 1
	strbhs	r15, [r15], r15, ror 31
	strbhs	r0, [r1], r2, rrx
	strbhs	r15, [r15], r15, rrx

positive: strbcc instruction

	strbcc	r0, [r0, -4095]
	strbcc	r15, [r15, +4095]
	strbcc	r0, [r0, -r0]
	strbcc	r15, [r15, +r15]
	strbcc	r0, [r1, r2, lsl 0]
	strbcc	r15, [r15, r15, lsl 31]
	strbcc	r0, [r1, r2, lsr 1]
	strbcc	r15, [r15, r15, lsr 32]
	strbcc	r0, [r1, r2, asr 1]
	strbcc	r15, [r15, r15, asr 32]
	strbcc	r0, [r1, r2, ror 1]
	strbcc	r15, [r15, r15, ror 31]
	strbcc	r0, [r1, r2, rrx]
	strbcc	r15, [r15, r15, rrx]
	strbcc	r0, [r0, -4095] !
	strbcc	r15, [r15, +4095] !
	strbcc	r0, [r0, -r0] !
	strbcc	r15, [r15, +r15] !
	strbcc	r0, [r1, r2, lsl 0] !
	strbcc	r15, [r15, r15, lsl 31] !
	strbcc	r0, [r1, r2, lsr 1] !
	strbcc	r15, [r15, r15, lsr 32] !
	strbcc	r0, [r1, r2, asr 1] !
	strbcc	r15, [r15, r15, asr 32] !
	strbcc	r0, [r1, r2, ror 1] !
	strbcc	r15, [r15, r15, ror 31] !
	strbcc	r0, [r1, r2, rrx] !
	strbcc	r15, [r15, r15, rrx] !
	strbcc	r0, [r0], -4095
	strbcc	r15, [r15], +4095
	strbcc	r0, [r0], -r0
	strbcc	r15, [r15], +r15
	strbcc	r0, [r1], r2, lsl 0
	strbcc	r15, [r15], r15, lsl 31
	strbcc	r0, [r1], r2, lsr 1
	strbcc	r15, [r15], r15, lsr 32
	strbcc	r0, [r1], r2, asr 1
	strbcc	r15, [r15], r15, asr 32
	strbcc	r0, [r1], r2, ror 1
	strbcc	r15, [r15], r15, ror 31
	strbcc	r0, [r1], r2, rrx
	strbcc	r15, [r15], r15, rrx

positive: strblo instruction

	strblo	r0, [r0, -4095]
	strblo	r15, [r15, +4095]
	strblo	r0, [r0, -r0]
	strblo	r15, [r15, +r15]
	strblo	r0, [r1, r2, lsl 0]
	strblo	r15, [r15, r15, lsl 31]
	strblo	r0, [r1, r2, lsr 1]
	strblo	r15, [r15, r15, lsr 32]
	strblo	r0, [r1, r2, asr 1]
	strblo	r15, [r15, r15, asr 32]
	strblo	r0, [r1, r2, ror 1]
	strblo	r15, [r15, r15, ror 31]
	strblo	r0, [r1, r2, rrx]
	strblo	r15, [r15, r15, rrx]
	strblo	r0, [r0, -4095] !
	strblo	r15, [r15, +4095] !
	strblo	r0, [r0, -r0] !
	strblo	r15, [r15, +r15] !
	strblo	r0, [r1, r2, lsl 0] !
	strblo	r15, [r15, r15, lsl 31] !
	strblo	r0, [r1, r2, lsr 1] !
	strblo	r15, [r15, r15, lsr 32] !
	strblo	r0, [r1, r2, asr 1] !
	strblo	r15, [r15, r15, asr 32] !
	strblo	r0, [r1, r2, ror 1] !
	strblo	r15, [r15, r15, ror 31] !
	strblo	r0, [r1, r2, rrx] !
	strblo	r15, [r15, r15, rrx] !
	strblo	r0, [r0], -4095
	strblo	r15, [r15], +4095
	strblo	r0, [r0], -r0
	strblo	r15, [r15], +r15
	strblo	r0, [r1], r2, lsl 0
	strblo	r15, [r15], r15, lsl 31
	strblo	r0, [r1], r2, lsr 1
	strblo	r15, [r15], r15, lsr 32
	strblo	r0, [r1], r2, asr 1
	strblo	r15, [r15], r15, asr 32
	strblo	r0, [r1], r2, ror 1
	strblo	r15, [r15], r15, ror 31
	strblo	r0, [r1], r2, rrx
	strblo	r15, [r15], r15, rrx

positive: strbmi instruction

	strbmi	r0, [r0, -4095]
	strbmi	r15, [r15, +4095]
	strbmi	r0, [r0, -r0]
	strbmi	r15, [r15, +r15]
	strbmi	r0, [r1, r2, lsl 0]
	strbmi	r15, [r15, r15, lsl 31]
	strbmi	r0, [r1, r2, lsr 1]
	strbmi	r15, [r15, r15, lsr 32]
	strbmi	r0, [r1, r2, asr 1]
	strbmi	r15, [r15, r15, asr 32]
	strbmi	r0, [r1, r2, ror 1]
	strbmi	r15, [r15, r15, ror 31]
	strbmi	r0, [r1, r2, rrx]
	strbmi	r15, [r15, r15, rrx]
	strbmi	r0, [r0, -4095] !
	strbmi	r15, [r15, +4095] !
	strbmi	r0, [r0, -r0] !
	strbmi	r15, [r15, +r15] !
	strbmi	r0, [r1, r2, lsl 0] !
	strbmi	r15, [r15, r15, lsl 31] !
	strbmi	r0, [r1, r2, lsr 1] !
	strbmi	r15, [r15, r15, lsr 32] !
	strbmi	r0, [r1, r2, asr 1] !
	strbmi	r15, [r15, r15, asr 32] !
	strbmi	r0, [r1, r2, ror 1] !
	strbmi	r15, [r15, r15, ror 31] !
	strbmi	r0, [r1, r2, rrx] !
	strbmi	r15, [r15, r15, rrx] !
	strbmi	r0, [r0], -4095
	strbmi	r15, [r15], +4095
	strbmi	r0, [r0], -r0
	strbmi	r15, [r15], +r15
	strbmi	r0, [r1], r2, lsl 0
	strbmi	r15, [r15], r15, lsl 31
	strbmi	r0, [r1], r2, lsr 1
	strbmi	r15, [r15], r15, lsr 32
	strbmi	r0, [r1], r2, asr 1
	strbmi	r15, [r15], r15, asr 32
	strbmi	r0, [r1], r2, ror 1
	strbmi	r15, [r15], r15, ror 31
	strbmi	r0, [r1], r2, rrx
	strbmi	r15, [r15], r15, rrx

positive: strbpl instruction

	strbpl	r0, [r0, -4095]
	strbpl	r15, [r15, +4095]
	strbpl	r0, [r0, -r0]
	strbpl	r15, [r15, +r15]
	strbpl	r0, [r1, r2, lsl 0]
	strbpl	r15, [r15, r15, lsl 31]
	strbpl	r0, [r1, r2, lsr 1]
	strbpl	r15, [r15, r15, lsr 32]
	strbpl	r0, [r1, r2, asr 1]
	strbpl	r15, [r15, r15, asr 32]
	strbpl	r0, [r1, r2, ror 1]
	strbpl	r15, [r15, r15, ror 31]
	strbpl	r0, [r1, r2, rrx]
	strbpl	r15, [r15, r15, rrx]
	strbpl	r0, [r0, -4095] !
	strbpl	r15, [r15, +4095] !
	strbpl	r0, [r0, -r0] !
	strbpl	r15, [r15, +r15] !
	strbpl	r0, [r1, r2, lsl 0] !
	strbpl	r15, [r15, r15, lsl 31] !
	strbpl	r0, [r1, r2, lsr 1] !
	strbpl	r15, [r15, r15, lsr 32] !
	strbpl	r0, [r1, r2, asr 1] !
	strbpl	r15, [r15, r15, asr 32] !
	strbpl	r0, [r1, r2, ror 1] !
	strbpl	r15, [r15, r15, ror 31] !
	strbpl	r0, [r1, r2, rrx] !
	strbpl	r15, [r15, r15, rrx] !
	strbpl	r0, [r0], -4095
	strbpl	r15, [r15], +4095
	strbpl	r0, [r0], -r0
	strbpl	r15, [r15], +r15
	strbpl	r0, [r1], r2, lsl 0
	strbpl	r15, [r15], r15, lsl 31
	strbpl	r0, [r1], r2, lsr 1
	strbpl	r15, [r15], r15, lsr 32
	strbpl	r0, [r1], r2, asr 1
	strbpl	r15, [r15], r15, asr 32
	strbpl	r0, [r1], r2, ror 1
	strbpl	r15, [r15], r15, ror 31
	strbpl	r0, [r1], r2, rrx
	strbpl	r15, [r15], r15, rrx

positive: strbvs instruction

	strbvs	r0, [r0, -4095]
	strbvs	r15, [r15, +4095]
	strbvs	r0, [r0, -r0]
	strbvs	r15, [r15, +r15]
	strbvs	r0, [r1, r2, lsl 0]
	strbvs	r15, [r15, r15, lsl 31]
	strbvs	r0, [r1, r2, lsr 1]
	strbvs	r15, [r15, r15, lsr 32]
	strbvs	r0, [r1, r2, asr 1]
	strbvs	r15, [r15, r15, asr 32]
	strbvs	r0, [r1, r2, ror 1]
	strbvs	r15, [r15, r15, ror 31]
	strbvs	r0, [r1, r2, rrx]
	strbvs	r15, [r15, r15, rrx]
	strbvs	r0, [r0, -4095] !
	strbvs	r15, [r15, +4095] !
	strbvs	r0, [r0, -r0] !
	strbvs	r15, [r15, +r15] !
	strbvs	r0, [r1, r2, lsl 0] !
	strbvs	r15, [r15, r15, lsl 31] !
	strbvs	r0, [r1, r2, lsr 1] !
	strbvs	r15, [r15, r15, lsr 32] !
	strbvs	r0, [r1, r2, asr 1] !
	strbvs	r15, [r15, r15, asr 32] !
	strbvs	r0, [r1, r2, ror 1] !
	strbvs	r15, [r15, r15, ror 31] !
	strbvs	r0, [r1, r2, rrx] !
	strbvs	r15, [r15, r15, rrx] !
	strbvs	r0, [r0], -4095
	strbvs	r15, [r15], +4095
	strbvs	r0, [r0], -r0
	strbvs	r15, [r15], +r15
	strbvs	r0, [r1], r2, lsl 0
	strbvs	r15, [r15], r15, lsl 31
	strbvs	r0, [r1], r2, lsr 1
	strbvs	r15, [r15], r15, lsr 32
	strbvs	r0, [r1], r2, asr 1
	strbvs	r15, [r15], r15, asr 32
	strbvs	r0, [r1], r2, ror 1
	strbvs	r15, [r15], r15, ror 31
	strbvs	r0, [r1], r2, rrx
	strbvs	r15, [r15], r15, rrx

positive: strbvc instruction

	strbvc	r0, [r0, -4095]
	strbvc	r15, [r15, +4095]
	strbvc	r0, [r0, -r0]
	strbvc	r15, [r15, +r15]
	strbvc	r0, [r1, r2, lsl 0]
	strbvc	r15, [r15, r15, lsl 31]
	strbvc	r0, [r1, r2, lsr 1]
	strbvc	r15, [r15, r15, lsr 32]
	strbvc	r0, [r1, r2, asr 1]
	strbvc	r15, [r15, r15, asr 32]
	strbvc	r0, [r1, r2, ror 1]
	strbvc	r15, [r15, r15, ror 31]
	strbvc	r0, [r1, r2, rrx]
	strbvc	r15, [r15, r15, rrx]
	strbvc	r0, [r0, -4095] !
	strbvc	r15, [r15, +4095] !
	strbvc	r0, [r0, -r0] !
	strbvc	r15, [r15, +r15] !
	strbvc	r0, [r1, r2, lsl 0] !
	strbvc	r15, [r15, r15, lsl 31] !
	strbvc	r0, [r1, r2, lsr 1] !
	strbvc	r15, [r15, r15, lsr 32] !
	strbvc	r0, [r1, r2, asr 1] !
	strbvc	r15, [r15, r15, asr 32] !
	strbvc	r0, [r1, r2, ror 1] !
	strbvc	r15, [r15, r15, ror 31] !
	strbvc	r0, [r1, r2, rrx] !
	strbvc	r15, [r15, r15, rrx] !
	strbvc	r0, [r0], -4095
	strbvc	r15, [r15], +4095
	strbvc	r0, [r0], -r0
	strbvc	r15, [r15], +r15
	strbvc	r0, [r1], r2, lsl 0
	strbvc	r15, [r15], r15, lsl 31
	strbvc	r0, [r1], r2, lsr 1
	strbvc	r15, [r15], r15, lsr 32
	strbvc	r0, [r1], r2, asr 1
	strbvc	r15, [r15], r15, asr 32
	strbvc	r0, [r1], r2, ror 1
	strbvc	r15, [r15], r15, ror 31
	strbvc	r0, [r1], r2, rrx
	strbvc	r15, [r15], r15, rrx

positive: strbhi instruction

	strbhi	r0, [r0, -4095]
	strbhi	r15, [r15, +4095]
	strbhi	r0, [r0, -r0]
	strbhi	r15, [r15, +r15]
	strbhi	r0, [r1, r2, lsl 0]
	strbhi	r15, [r15, r15, lsl 31]
	strbhi	r0, [r1, r2, lsr 1]
	strbhi	r15, [r15, r15, lsr 32]
	strbhi	r0, [r1, r2, asr 1]
	strbhi	r15, [r15, r15, asr 32]
	strbhi	r0, [r1, r2, ror 1]
	strbhi	r15, [r15, r15, ror 31]
	strbhi	r0, [r1, r2, rrx]
	strbhi	r15, [r15, r15, rrx]
	strbhi	r0, [r0, -4095] !
	strbhi	r15, [r15, +4095] !
	strbhi	r0, [r0, -r0] !
	strbhi	r15, [r15, +r15] !
	strbhi	r0, [r1, r2, lsl 0] !
	strbhi	r15, [r15, r15, lsl 31] !
	strbhi	r0, [r1, r2, lsr 1] !
	strbhi	r15, [r15, r15, lsr 32] !
	strbhi	r0, [r1, r2, asr 1] !
	strbhi	r15, [r15, r15, asr 32] !
	strbhi	r0, [r1, r2, ror 1] !
	strbhi	r15, [r15, r15, ror 31] !
	strbhi	r0, [r1, r2, rrx] !
	strbhi	r15, [r15, r15, rrx] !
	strbhi	r0, [r0], -4095
	strbhi	r15, [r15], +4095
	strbhi	r0, [r0], -r0
	strbhi	r15, [r15], +r15
	strbhi	r0, [r1], r2, lsl 0
	strbhi	r15, [r15], r15, lsl 31
	strbhi	r0, [r1], r2, lsr 1
	strbhi	r15, [r15], r15, lsr 32
	strbhi	r0, [r1], r2, asr 1
	strbhi	r15, [r15], r15, asr 32
	strbhi	r0, [r1], r2, ror 1
	strbhi	r15, [r15], r15, ror 31
	strbhi	r0, [r1], r2, rrx
	strbhi	r15, [r15], r15, rrx

positive: strbls instruction

	strbls	r0, [r0, -4095]
	strbls	r15, [r15, +4095]
	strbls	r0, [r0, -r0]
	strbls	r15, [r15, +r15]
	strbls	r0, [r1, r2, lsl 0]
	strbls	r15, [r15, r15, lsl 31]
	strbls	r0, [r1, r2, lsr 1]
	strbls	r15, [r15, r15, lsr 32]
	strbls	r0, [r1, r2, asr 1]
	strbls	r15, [r15, r15, asr 32]
	strbls	r0, [r1, r2, ror 1]
	strbls	r15, [r15, r15, ror 31]
	strbls	r0, [r1, r2, rrx]
	strbls	r15, [r15, r15, rrx]
	strbls	r0, [r0, -4095] !
	strbls	r15, [r15, +4095] !
	strbls	r0, [r0, -r0] !
	strbls	r15, [r15, +r15] !
	strbls	r0, [r1, r2, lsl 0] !
	strbls	r15, [r15, r15, lsl 31] !
	strbls	r0, [r1, r2, lsr 1] !
	strbls	r15, [r15, r15, lsr 32] !
	strbls	r0, [r1, r2, asr 1] !
	strbls	r15, [r15, r15, asr 32] !
	strbls	r0, [r1, r2, ror 1] !
	strbls	r15, [r15, r15, ror 31] !
	strbls	r0, [r1, r2, rrx] !
	strbls	r15, [r15, r15, rrx] !
	strbls	r0, [r0], -4095
	strbls	r15, [r15], +4095
	strbls	r0, [r0], -r0
	strbls	r15, [r15], +r15
	strbls	r0, [r1], r2, lsl 0
	strbls	r15, [r15], r15, lsl 31
	strbls	r0, [r1], r2, lsr 1
	strbls	r15, [r15], r15, lsr 32
	strbls	r0, [r1], r2, asr 1
	strbls	r15, [r15], r15, asr 32
	strbls	r0, [r1], r2, ror 1
	strbls	r15, [r15], r15, ror 31
	strbls	r0, [r1], r2, rrx
	strbls	r15, [r15], r15, rrx

positive: strbge instruction

	strbge	r0, [r0, -4095]
	strbge	r15, [r15, +4095]
	strbge	r0, [r0, -r0]
	strbge	r15, [r15, +r15]
	strbge	r0, [r1, r2, lsl 0]
	strbge	r15, [r15, r15, lsl 31]
	strbge	r0, [r1, r2, lsr 1]
	strbge	r15, [r15, r15, lsr 32]
	strbge	r0, [r1, r2, asr 1]
	strbge	r15, [r15, r15, asr 32]
	strbge	r0, [r1, r2, ror 1]
	strbge	r15, [r15, r15, ror 31]
	strbge	r0, [r1, r2, rrx]
	strbge	r15, [r15, r15, rrx]
	strbge	r0, [r0, -4095] !
	strbge	r15, [r15, +4095] !
	strbge	r0, [r0, -r0] !
	strbge	r15, [r15, +r15] !
	strbge	r0, [r1, r2, lsl 0] !
	strbge	r15, [r15, r15, lsl 31] !
	strbge	r0, [r1, r2, lsr 1] !
	strbge	r15, [r15, r15, lsr 32] !
	strbge	r0, [r1, r2, asr 1] !
	strbge	r15, [r15, r15, asr 32] !
	strbge	r0, [r1, r2, ror 1] !
	strbge	r15, [r15, r15, ror 31] !
	strbge	r0, [r1, r2, rrx] !
	strbge	r15, [r15, r15, rrx] !
	strbge	r0, [r0], -4095
	strbge	r15, [r15], +4095
	strbge	r0, [r0], -r0
	strbge	r15, [r15], +r15
	strbge	r0, [r1], r2, lsl 0
	strbge	r15, [r15], r15, lsl 31
	strbge	r0, [r1], r2, lsr 1
	strbge	r15, [r15], r15, lsr 32
	strbge	r0, [r1], r2, asr 1
	strbge	r15, [r15], r15, asr 32
	strbge	r0, [r1], r2, ror 1
	strbge	r15, [r15], r15, ror 31
	strbge	r0, [r1], r2, rrx
	strbge	r15, [r15], r15, rrx

positive: strblt instruction

	strblt	r0, [r0, -4095]
	strblt	r15, [r15, +4095]
	strblt	r0, [r0, -r0]
	strblt	r15, [r15, +r15]
	strblt	r0, [r1, r2, lsl 0]
	strblt	r15, [r15, r15, lsl 31]
	strblt	r0, [r1, r2, lsr 1]
	strblt	r15, [r15, r15, lsr 32]
	strblt	r0, [r1, r2, asr 1]
	strblt	r15, [r15, r15, asr 32]
	strblt	r0, [r1, r2, ror 1]
	strblt	r15, [r15, r15, ror 31]
	strblt	r0, [r1, r2, rrx]
	strblt	r15, [r15, r15, rrx]
	strblt	r0, [r0, -4095] !
	strblt	r15, [r15, +4095] !
	strblt	r0, [r0, -r0] !
	strblt	r15, [r15, +r15] !
	strblt	r0, [r1, r2, lsl 0] !
	strblt	r15, [r15, r15, lsl 31] !
	strblt	r0, [r1, r2, lsr 1] !
	strblt	r15, [r15, r15, lsr 32] !
	strblt	r0, [r1, r2, asr 1] !
	strblt	r15, [r15, r15, asr 32] !
	strblt	r0, [r1, r2, ror 1] !
	strblt	r15, [r15, r15, ror 31] !
	strblt	r0, [r1, r2, rrx] !
	strblt	r15, [r15, r15, rrx] !
	strblt	r0, [r0], -4095
	strblt	r15, [r15], +4095
	strblt	r0, [r0], -r0
	strblt	r15, [r15], +r15
	strblt	r0, [r1], r2, lsl 0
	strblt	r15, [r15], r15, lsl 31
	strblt	r0, [r1], r2, lsr 1
	strblt	r15, [r15], r15, lsr 32
	strblt	r0, [r1], r2, asr 1
	strblt	r15, [r15], r15, asr 32
	strblt	r0, [r1], r2, ror 1
	strblt	r15, [r15], r15, ror 31
	strblt	r0, [r1], r2, rrx
	strblt	r15, [r15], r15, rrx

positive: strbgt instruction

	strbgt	r0, [r0, -4095]
	strbgt	r15, [r15, +4095]
	strbgt	r0, [r0, -r0]
	strbgt	r15, [r15, +r15]
	strbgt	r0, [r1, r2, lsl 0]
	strbgt	r15, [r15, r15, lsl 31]
	strbgt	r0, [r1, r2, lsr 1]
	strbgt	r15, [r15, r15, lsr 32]
	strbgt	r0, [r1, r2, asr 1]
	strbgt	r15, [r15, r15, asr 32]
	strbgt	r0, [r1, r2, ror 1]
	strbgt	r15, [r15, r15, ror 31]
	strbgt	r0, [r1, r2, rrx]
	strbgt	r15, [r15, r15, rrx]
	strbgt	r0, [r0, -4095] !
	strbgt	r15, [r15, +4095] !
	strbgt	r0, [r0, -r0] !
	strbgt	r15, [r15, +r15] !
	strbgt	r0, [r1, r2, lsl 0] !
	strbgt	r15, [r15, r15, lsl 31] !
	strbgt	r0, [r1, r2, lsr 1] !
	strbgt	r15, [r15, r15, lsr 32] !
	strbgt	r0, [r1, r2, asr 1] !
	strbgt	r15, [r15, r15, asr 32] !
	strbgt	r0, [r1, r2, ror 1] !
	strbgt	r15, [r15, r15, ror 31] !
	strbgt	r0, [r1, r2, rrx] !
	strbgt	r15, [r15, r15, rrx] !
	strbgt	r0, [r0], -4095
	strbgt	r15, [r15], +4095
	strbgt	r0, [r0], -r0
	strbgt	r15, [r15], +r15
	strbgt	r0, [r1], r2, lsl 0
	strbgt	r15, [r15], r15, lsl 31
	strbgt	r0, [r1], r2, lsr 1
	strbgt	r15, [r15], r15, lsr 32
	strbgt	r0, [r1], r2, asr 1
	strbgt	r15, [r15], r15, asr 32
	strbgt	r0, [r1], r2, ror 1
	strbgt	r15, [r15], r15, ror 31
	strbgt	r0, [r1], r2, rrx
	strbgt	r15, [r15], r15, rrx

positive: strble instruction

	strble	r0, [r0, -4095]
	strble	r15, [r15, +4095]
	strble	r0, [r0, -r0]
	strble	r15, [r15, +r15]
	strble	r0, [r1, r2, lsl 0]
	strble	r15, [r15, r15, lsl 31]
	strble	r0, [r1, r2, lsr 1]
	strble	r15, [r15, r15, lsr 32]
	strble	r0, [r1, r2, asr 1]
	strble	r15, [r15, r15, asr 32]
	strble	r0, [r1, r2, ror 1]
	strble	r15, [r15, r15, ror 31]
	strble	r0, [r1, r2, rrx]
	strble	r15, [r15, r15, rrx]
	strble	r0, [r0, -4095] !
	strble	r15, [r15, +4095] !
	strble	r0, [r0, -r0] !
	strble	r15, [r15, +r15] !
	strble	r0, [r1, r2, lsl 0] !
	strble	r15, [r15, r15, lsl 31] !
	strble	r0, [r1, r2, lsr 1] !
	strble	r15, [r15, r15, lsr 32] !
	strble	r0, [r1, r2, asr 1] !
	strble	r15, [r15, r15, asr 32] !
	strble	r0, [r1, r2, ror 1] !
	strble	r15, [r15, r15, ror 31] !
	strble	r0, [r1, r2, rrx] !
	strble	r15, [r15, r15, rrx] !
	strble	r0, [r0], -4095
	strble	r15, [r15], +4095
	strble	r0, [r0], -r0
	strble	r15, [r15], +r15
	strble	r0, [r1], r2, lsl 0
	strble	r15, [r15], r15, lsl 31
	strble	r0, [r1], r2, lsr 1
	strble	r15, [r15], r15, lsr 32
	strble	r0, [r1], r2, asr 1
	strble	r15, [r15], r15, asr 32
	strble	r0, [r1], r2, ror 1
	strble	r15, [r15], r15, ror 31
	strble	r0, [r1], r2, rrx
	strble	r15, [r15], r15, rrx

positive: strbal instruction

	strbal	r0, [r0, -4095]
	strbal	r15, [r15, +4095]
	strbal	r0, [r0, -r0]
	strbal	r15, [r15, +r15]
	strbal	r0, [r1, r2, lsl 0]
	strbal	r15, [r15, r15, lsl 31]
	strbal	r0, [r1, r2, lsr 1]
	strbal	r15, [r15, r15, lsr 32]
	strbal	r0, [r1, r2, asr 1]
	strbal	r15, [r15, r15, asr 32]
	strbal	r0, [r1, r2, ror 1]
	strbal	r15, [r15, r15, ror 31]
	strbal	r0, [r1, r2, rrx]
	strbal	r15, [r15, r15, rrx]
	strbal	r0, [r0, -4095] !
	strbal	r15, [r15, +4095] !
	strbal	r0, [r0, -r0] !
	strbal	r15, [r15, +r15] !
	strbal	r0, [r1, r2, lsl 0] !
	strbal	r15, [r15, r15, lsl 31] !
	strbal	r0, [r1, r2, lsr 1] !
	strbal	r15, [r15, r15, lsr 32] !
	strbal	r0, [r1, r2, asr 1] !
	strbal	r15, [r15, r15, asr 32] !
	strbal	r0, [r1, r2, ror 1] !
	strbal	r15, [r15, r15, ror 31] !
	strbal	r0, [r1, r2, rrx] !
	strbal	r15, [r15, r15, rrx] !
	strbal	r0, [r0], -4095
	strbal	r15, [r15], +4095
	strbal	r0, [r0], -r0
	strbal	r15, [r15], +r15
	strbal	r0, [r1], r2, lsl 0
	strbal	r15, [r15], r15, lsl 31
	strbal	r0, [r1], r2, lsr 1
	strbal	r15, [r15], r15, lsr 32
	strbal	r0, [r1], r2, asr 1
	strbal	r15, [r15], r15, asr 32
	strbal	r0, [r1], r2, ror 1
	strbal	r15, [r15], r15, ror 31
	strbal	r0, [r1], r2, rrx
	strbal	r15, [r15], r15, rrx

positive: strbt instruction

	strbt	r0, [r0], -4095
	strbt	r15, [r15], +4095
	strbt	r0, [r0], -r0
	strbt	r15, [r15], +r15
	strbt	r0, [r1], r2, lsl 0
	strbt	r15, [r15], r15, lsl 31
	strbt	r0, [r1], r2, lsr 1
	strbt	r15, [r15], r15, lsr 32
	strbt	r0, [r1], r2, asr 1
	strbt	r15, [r15], r15, asr 32
	strbt	r0, [r1], r2, ror 1
	strbt	r15, [r15], r15, ror 31
	strbt	r0, [r1], r2, rrx
	strbt	r15, [r15], r15, rrx

positive: strbteq instruction

	strbteq	r0, [r0], -4095
	strbteq	r15, [r15], +4095
	strbteq	r0, [r0], -r0
	strbteq	r15, [r15], +r15
	strbteq	r0, [r1], r2, lsl 0
	strbteq	r15, [r15], r15, lsl 31
	strbteq	r0, [r1], r2, lsr 1
	strbteq	r15, [r15], r15, lsr 32
	strbteq	r0, [r1], r2, asr 1
	strbteq	r15, [r15], r15, asr 32
	strbteq	r0, [r1], r2, ror 1
	strbteq	r15, [r15], r15, ror 31
	strbteq	r0, [r1], r2, rrx
	strbteq	r15, [r15], r15, rrx

positive: strbtne instruction

	strbtne	r0, [r0], -4095
	strbtne	r15, [r15], +4095
	strbtne	r0, [r0], -r0
	strbtne	r15, [r15], +r15
	strbtne	r0, [r1], r2, lsl 0
	strbtne	r15, [r15], r15, lsl 31
	strbtne	r0, [r1], r2, lsr 1
	strbtne	r15, [r15], r15, lsr 32
	strbtne	r0, [r1], r2, asr 1
	strbtne	r15, [r15], r15, asr 32
	strbtne	r0, [r1], r2, ror 1
	strbtne	r15, [r15], r15, ror 31
	strbtne	r0, [r1], r2, rrx
	strbtne	r15, [r15], r15, rrx

positive: strbtcs instruction

	strbtcs	r0, [r0], -4095
	strbtcs	r15, [r15], +4095
	strbtcs	r0, [r0], -r0
	strbtcs	r15, [r15], +r15
	strbtcs	r0, [r1], r2, lsl 0
	strbtcs	r15, [r15], r15, lsl 31
	strbtcs	r0, [r1], r2, lsr 1
	strbtcs	r15, [r15], r15, lsr 32
	strbtcs	r0, [r1], r2, asr 1
	strbtcs	r15, [r15], r15, asr 32
	strbtcs	r0, [r1], r2, ror 1
	strbtcs	r15, [r15], r15, ror 31
	strbtcs	r0, [r1], r2, rrx
	strbtcs	r15, [r15], r15, rrx

positive: strbths instruction

	strbths	r0, [r0], -4095
	strbths	r15, [r15], +4095
	strbths	r0, [r0], -r0
	strbths	r15, [r15], +r15
	strbths	r0, [r1], r2, lsl 0
	strbths	r15, [r15], r15, lsl 31
	strbths	r0, [r1], r2, lsr 1
	strbths	r15, [r15], r15, lsr 32
	strbths	r0, [r1], r2, asr 1
	strbths	r15, [r15], r15, asr 32
	strbths	r0, [r1], r2, ror 1
	strbths	r15, [r15], r15, ror 31
	strbths	r0, [r1], r2, rrx
	strbths	r15, [r15], r15, rrx

positive: strbtcc instruction

	strbtcc	r0, [r0], -4095
	strbtcc	r15, [r15], +4095
	strbtcc	r0, [r0], -r0
	strbtcc	r15, [r15], +r15
	strbtcc	r0, [r1], r2, lsl 0
	strbtcc	r15, [r15], r15, lsl 31
	strbtcc	r0, [r1], r2, lsr 1
	strbtcc	r15, [r15], r15, lsr 32
	strbtcc	r0, [r1], r2, asr 1
	strbtcc	r15, [r15], r15, asr 32
	strbtcc	r0, [r1], r2, ror 1
	strbtcc	r15, [r15], r15, ror 31
	strbtcc	r0, [r1], r2, rrx
	strbtcc	r15, [r15], r15, rrx

positive: strbtlo instruction

	strbtlo	r0, [r0], -4095
	strbtlo	r15, [r15], +4095
	strbtlo	r0, [r0], -r0
	strbtlo	r15, [r15], +r15
	strbtlo	r0, [r1], r2, lsl 0
	strbtlo	r15, [r15], r15, lsl 31
	strbtlo	r0, [r1], r2, lsr 1
	strbtlo	r15, [r15], r15, lsr 32
	strbtlo	r0, [r1], r2, asr 1
	strbtlo	r15, [r15], r15, asr 32
	strbtlo	r0, [r1], r2, ror 1
	strbtlo	r15, [r15], r15, ror 31
	strbtlo	r0, [r1], r2, rrx
	strbtlo	r15, [r15], r15, rrx

positive: strbtmi instruction

	strbtmi	r0, [r0], -4095
	strbtmi	r15, [r15], +4095
	strbtmi	r0, [r0], -r0
	strbtmi	r15, [r15], +r15
	strbtmi	r0, [r1], r2, lsl 0
	strbtmi	r15, [r15], r15, lsl 31
	strbtmi	r0, [r1], r2, lsr 1
	strbtmi	r15, [r15], r15, lsr 32
	strbtmi	r0, [r1], r2, asr 1
	strbtmi	r15, [r15], r15, asr 32
	strbtmi	r0, [r1], r2, ror 1
	strbtmi	r15, [r15], r15, ror 31
	strbtmi	r0, [r1], r2, rrx
	strbtmi	r15, [r15], r15, rrx

positive: strbtpl instruction

	strbtpl	r0, [r0], -4095
	strbtpl	r15, [r15], +4095
	strbtpl	r0, [r0], -r0
	strbtpl	r15, [r15], +r15
	strbtpl	r0, [r1], r2, lsl 0
	strbtpl	r15, [r15], r15, lsl 31
	strbtpl	r0, [r1], r2, lsr 1
	strbtpl	r15, [r15], r15, lsr 32
	strbtpl	r0, [r1], r2, asr 1
	strbtpl	r15, [r15], r15, asr 32
	strbtpl	r0, [r1], r2, ror 1
	strbtpl	r15, [r15], r15, ror 31
	strbtpl	r0, [r1], r2, rrx
	strbtpl	r15, [r15], r15, rrx

positive: strbtvs instruction

	strbtvs	r0, [r0], -4095
	strbtvs	r15, [r15], +4095
	strbtvs	r0, [r0], -r0
	strbtvs	r15, [r15], +r15
	strbtvs	r0, [r1], r2, lsl 0
	strbtvs	r15, [r15], r15, lsl 31
	strbtvs	r0, [r1], r2, lsr 1
	strbtvs	r15, [r15], r15, lsr 32
	strbtvs	r0, [r1], r2, asr 1
	strbtvs	r15, [r15], r15, asr 32
	strbtvs	r0, [r1], r2, ror 1
	strbtvs	r15, [r15], r15, ror 31
	strbtvs	r0, [r1], r2, rrx
	strbtvs	r15, [r15], r15, rrx

positive: strbtvc instruction

	strbtvc	r0, [r0], -4095
	strbtvc	r15, [r15], +4095
	strbtvc	r0, [r0], -r0
	strbtvc	r15, [r15], +r15
	strbtvc	r0, [r1], r2, lsl 0
	strbtvc	r15, [r15], r15, lsl 31
	strbtvc	r0, [r1], r2, lsr 1
	strbtvc	r15, [r15], r15, lsr 32
	strbtvc	r0, [r1], r2, asr 1
	strbtvc	r15, [r15], r15, asr 32
	strbtvc	r0, [r1], r2, ror 1
	strbtvc	r15, [r15], r15, ror 31
	strbtvc	r0, [r1], r2, rrx
	strbtvc	r15, [r15], r15, rrx

positive: strbthi instruction

	strbthi	r0, [r0], -4095
	strbthi	r15, [r15], +4095
	strbthi	r0, [r0], -r0
	strbthi	r15, [r15], +r15
	strbthi	r0, [r1], r2, lsl 0
	strbthi	r15, [r15], r15, lsl 31
	strbthi	r0, [r1], r2, lsr 1
	strbthi	r15, [r15], r15, lsr 32
	strbthi	r0, [r1], r2, asr 1
	strbthi	r15, [r15], r15, asr 32
	strbthi	r0, [r1], r2, ror 1
	strbthi	r15, [r15], r15, ror 31
	strbthi	r0, [r1], r2, rrx
	strbthi	r15, [r15], r15, rrx

positive: strbtls instruction

	strbtls	r0, [r0], -4095
	strbtls	r15, [r15], +4095
	strbtls	r0, [r0], -r0
	strbtls	r15, [r15], +r15
	strbtls	r0, [r1], r2, lsl 0
	strbtls	r15, [r15], r15, lsl 31
	strbtls	r0, [r1], r2, lsr 1
	strbtls	r15, [r15], r15, lsr 32
	strbtls	r0, [r1], r2, asr 1
	strbtls	r15, [r15], r15, asr 32
	strbtls	r0, [r1], r2, ror 1
	strbtls	r15, [r15], r15, ror 31
	strbtls	r0, [r1], r2, rrx
	strbtls	r15, [r15], r15, rrx

positive: strbtge instruction

	strbtge	r0, [r0], -4095
	strbtge	r15, [r15], +4095
	strbtge	r0, [r0], -r0
	strbtge	r15, [r15], +r15
	strbtge	r0, [r1], r2, lsl 0
	strbtge	r15, [r15], r15, lsl 31
	strbtge	r0, [r1], r2, lsr 1
	strbtge	r15, [r15], r15, lsr 32
	strbtge	r0, [r1], r2, asr 1
	strbtge	r15, [r15], r15, asr 32
	strbtge	r0, [r1], r2, ror 1
	strbtge	r15, [r15], r15, ror 31
	strbtge	r0, [r1], r2, rrx
	strbtge	r15, [r15], r15, rrx

positive: strbtlt instruction

	strbtlt	r0, [r0], -4095
	strbtlt	r15, [r15], +4095
	strbtlt	r0, [r0], -r0
	strbtlt	r15, [r15], +r15
	strbtlt	r0, [r1], r2, lsl 0
	strbtlt	r15, [r15], r15, lsl 31
	strbtlt	r0, [r1], r2, lsr 1
	strbtlt	r15, [r15], r15, lsr 32
	strbtlt	r0, [r1], r2, asr 1
	strbtlt	r15, [r15], r15, asr 32
	strbtlt	r0, [r1], r2, ror 1
	strbtlt	r15, [r15], r15, ror 31
	strbtlt	r0, [r1], r2, rrx
	strbtlt	r15, [r15], r15, rrx

positive: strbtgt instruction

	strbtgt	r0, [r0], -4095
	strbtgt	r15, [r15], +4095
	strbtgt	r0, [r0], -r0
	strbtgt	r15, [r15], +r15
	strbtgt	r0, [r1], r2, lsl 0
	strbtgt	r15, [r15], r15, lsl 31
	strbtgt	r0, [r1], r2, lsr 1
	strbtgt	r15, [r15], r15, lsr 32
	strbtgt	r0, [r1], r2, asr 1
	strbtgt	r15, [r15], r15, asr 32
	strbtgt	r0, [r1], r2, ror 1
	strbtgt	r15, [r15], r15, ror 31
	strbtgt	r0, [r1], r2, rrx
	strbtgt	r15, [r15], r15, rrx

positive: strbtle instruction

	strbtle	r0, [r0], -4095
	strbtle	r15, [r15], +4095
	strbtle	r0, [r0], -r0
	strbtle	r15, [r15], +r15
	strbtle	r0, [r1], r2, lsl 0
	strbtle	r15, [r15], r15, lsl 31
	strbtle	r0, [r1], r2, lsr 1
	strbtle	r15, [r15], r15, lsr 32
	strbtle	r0, [r1], r2, asr 1
	strbtle	r15, [r15], r15, asr 32
	strbtle	r0, [r1], r2, ror 1
	strbtle	r15, [r15], r15, ror 31
	strbtle	r0, [r1], r2, rrx
	strbtle	r15, [r15], r15, rrx

positive: strbtal instruction

	strbtal	r0, [r0], -4095
	strbtal	r15, [r15], +4095
	strbtal	r0, [r0], -r0
	strbtal	r15, [r15], +r15
	strbtal	r0, [r1], r2, lsl 0
	strbtal	r15, [r15], r15, lsl 31
	strbtal	r0, [r1], r2, lsr 1
	strbtal	r15, [r15], r15, lsr 32
	strbtal	r0, [r1], r2, asr 1
	strbtal	r15, [r15], r15, asr 32
	strbtal	r0, [r1], r2, ror 1
	strbtal	r15, [r15], r15, ror 31
	strbtal	r0, [r1], r2, rrx
	strbtal	r15, [r15], r15, rrx

positive: strh instruction

	strh	r0, [r0, -255]
	strh	r15, [r15, +255]
	strh	r0, [r0, -r0]
	strh	r15, [r15, +r15]
	strh	r0, [r0, -255]!
	strh	r15, [r15, +255]!
	strh	r0, [r0, -r0]!
	strh	r15, [r15, +r15]!
	strh	r0, [r0], -255
	strh	r15, [r15], +255
	strh	r0, [r0], -r0
	strh	r15, [r15], +r15

positive: strheq instruction

	strheq	r0, [r0, -255]
	strheq	r15, [r15, +255]
	strheq	r0, [r0, -r0]
	strheq	r15, [r15, +r15]
	strheq	r0, [r0, -255]!
	strheq	r15, [r15, +255]!
	strheq	r0, [r0, -r0]!
	strheq	r15, [r15, +r15]!
	strheq	r0, [r0], -255
	strheq	r15, [r15], +255
	strheq	r0, [r0], -r0
	strheq	r15, [r15], +r15

positive: strhne instruction

	strhne	r0, [r0, -255]
	strhne	r15, [r15, +255]
	strhne	r0, [r0, -r0]
	strhne	r15, [r15, +r15]
	strhne	r0, [r0, -255]!
	strhne	r15, [r15, +255]!
	strhne	r0, [r0, -r0]!
	strhne	r15, [r15, +r15]!
	strhne	r0, [r0], -255
	strhne	r15, [r15], +255
	strhne	r0, [r0], -r0
	strhne	r15, [r15], +r15

positive: strhcs instruction

	strhcs	r0, [r0, -255]
	strhcs	r15, [r15, +255]
	strhcs	r0, [r0, -r0]
	strhcs	r15, [r15, +r15]
	strhcs	r0, [r0, -255]!
	strhcs	r15, [r15, +255]!
	strhcs	r0, [r0, -r0]!
	strhcs	r15, [r15, +r15]!
	strhcs	r0, [r0], -255
	strhcs	r15, [r15], +255
	strhcs	r0, [r0], -r0
	strhcs	r15, [r15], +r15

positive: strhhs instruction

	strhhs	r0, [r0, -255]
	strhhs	r15, [r15, +255]
	strhhs	r0, [r0, -r0]
	strhhs	r15, [r15, +r15]
	strhhs	r0, [r0, -255]!
	strhhs	r15, [r15, +255]!
	strhhs	r0, [r0, -r0]!
	strhhs	r15, [r15, +r15]!
	strhhs	r0, [r0], -255
	strhhs	r15, [r15], +255
	strhhs	r0, [r0], -r0
	strhhs	r15, [r15], +r15

positive: strhcc instruction

	strhcc	r0, [r0, -255]
	strhcc	r15, [r15, +255]
	strhcc	r0, [r0, -r0]
	strhcc	r15, [r15, +r15]
	strhcc	r0, [r0, -255]!
	strhcc	r15, [r15, +255]!
	strhcc	r0, [r0, -r0]!
	strhcc	r15, [r15, +r15]!
	strhcc	r0, [r0], -255
	strhcc	r15, [r15], +255
	strhcc	r0, [r0], -r0
	strhcc	r15, [r15], +r15

positive: strhlo instruction

	strhlo	r0, [r0, -255]
	strhlo	r15, [r15, +255]
	strhlo	r0, [r0, -r0]
	strhlo	r15, [r15, +r15]
	strhlo	r0, [r0, -255]!
	strhlo	r15, [r15, +255]!
	strhlo	r0, [r0, -r0]!
	strhlo	r15, [r15, +r15]!
	strhlo	r0, [r0], -255
	strhlo	r15, [r15], +255
	strhlo	r0, [r0], -r0
	strhlo	r15, [r15], +r15

positive: strhmi instruction

	strhmi	r0, [r0, -255]
	strhmi	r15, [r15, +255]
	strhmi	r0, [r0, -r0]
	strhmi	r15, [r15, +r15]
	strhmi	r0, [r0, -255]!
	strhmi	r15, [r15, +255]!
	strhmi	r0, [r0, -r0]!
	strhmi	r15, [r15, +r15]!
	strhmi	r0, [r0], -255
	strhmi	r15, [r15], +255
	strhmi	r0, [r0], -r0
	strhmi	r15, [r15], +r15

positive: strhpl instruction

	strhpl	r0, [r0, -255]
	strhpl	r15, [r15, +255]
	strhpl	r0, [r0, -r0]
	strhpl	r15, [r15, +r15]
	strhpl	r0, [r0, -255]!
	strhpl	r15, [r15, +255]!
	strhpl	r0, [r0, -r0]!
	strhpl	r15, [r15, +r15]!
	strhpl	r0, [r0], -255
	strhpl	r15, [r15], +255
	strhpl	r0, [r0], -r0
	strhpl	r15, [r15], +r15

positive: strhvs instruction

	strhvs	r0, [r0, -255]
	strhvs	r15, [r15, +255]
	strhvs	r0, [r0, -r0]
	strhvs	r15, [r15, +r15]
	strhvs	r0, [r0, -255]!
	strhvs	r15, [r15, +255]!
	strhvs	r0, [r0, -r0]!
	strhvs	r15, [r15, +r15]!
	strhvs	r0, [r0], -255
	strhvs	r15, [r15], +255
	strhvs	r0, [r0], -r0
	strhvs	r15, [r15], +r15

positive: strhvc instruction

	strhvc	r0, [r0, -255]
	strhvc	r15, [r15, +255]
	strhvc	r0, [r0, -r0]
	strhvc	r15, [r15, +r15]
	strhvc	r0, [r0, -255]!
	strhvc	r15, [r15, +255]!
	strhvc	r0, [r0, -r0]!
	strhvc	r15, [r15, +r15]!
	strhvc	r0, [r0], -255
	strhvc	r15, [r15], +255
	strhvc	r0, [r0], -r0
	strhvc	r15, [r15], +r15

positive: strhhi instruction

	strhhi	r0, [r0, -255]
	strhhi	r15, [r15, +255]
	strhhi	r0, [r0, -r0]
	strhhi	r15, [r15, +r15]
	strhhi	r0, [r0, -255]!
	strhhi	r15, [r15, +255]!
	strhhi	r0, [r0, -r0]!
	strhhi	r15, [r15, +r15]!
	strhhi	r0, [r0], -255
	strhhi	r15, [r15], +255
	strhhi	r0, [r0], -r0
	strhhi	r15, [r15], +r15

positive: strhls instruction

	strhls	r0, [r0, -255]
	strhls	r15, [r15, +255]
	strhls	r0, [r0, -r0]
	strhls	r15, [r15, +r15]
	strhls	r0, [r0, -255]!
	strhls	r15, [r15, +255]!
	strhls	r0, [r0, -r0]!
	strhls	r15, [r15, +r15]!
	strhls	r0, [r0], -255
	strhls	r15, [r15], +255
	strhls	r0, [r0], -r0
	strhls	r15, [r15], +r15

positive: strhge instruction

	strhge	r0, [r0, -255]
	strhge	r15, [r15, +255]
	strhge	r0, [r0, -r0]
	strhge	r15, [r15, +r15]
	strhge	r0, [r0, -255]!
	strhge	r15, [r15, +255]!
	strhge	r0, [r0, -r0]!
	strhge	r15, [r15, +r15]!
	strhge	r0, [r0], -255
	strhge	r15, [r15], +255
	strhge	r0, [r0], -r0
	strhge	r15, [r15], +r15

positive: strhlt instruction

	strhlt	r0, [r0, -255]
	strhlt	r15, [r15, +255]
	strhlt	r0, [r0, -r0]
	strhlt	r15, [r15, +r15]
	strhlt	r0, [r0, -255]!
	strhlt	r15, [r15, +255]!
	strhlt	r0, [r0, -r0]!
	strhlt	r15, [r15, +r15]!
	strhlt	r0, [r0], -255
	strhlt	r15, [r15], +255
	strhlt	r0, [r0], -r0
	strhlt	r15, [r15], +r15

positive: strhgt instruction

	strhgt	r0, [r0, -255]
	strhgt	r15, [r15, +255]
	strhgt	r0, [r0, -r0]
	strhgt	r15, [r15, +r15]
	strhgt	r0, [r0, -255]!
	strhgt	r15, [r15, +255]!
	strhgt	r0, [r0, -r0]!
	strhgt	r15, [r15, +r15]!
	strhgt	r0, [r0], -255
	strhgt	r15, [r15], +255
	strhgt	r0, [r0], -r0
	strhgt	r15, [r15], +r15

positive: strhle instruction

	strhle	r0, [r0, -255]
	strhle	r15, [r15, +255]
	strhle	r0, [r0, -r0]
	strhle	r15, [r15, +r15]
	strhle	r0, [r0, -255]!
	strhle	r15, [r15, +255]!
	strhle	r0, [r0, -r0]!
	strhle	r15, [r15, +r15]!
	strhle	r0, [r0], -255
	strhle	r15, [r15], +255
	strhle	r0, [r0], -r0
	strhle	r15, [r15], +r15

positive: strhal instruction

	strhal	r0, [r0, -255]
	strhal	r15, [r15, +255]
	strhal	r0, [r0, -r0]
	strhal	r15, [r15, +r15]
	strhal	r0, [r0, -255]!
	strhal	r15, [r15, +255]!
	strhal	r0, [r0, -r0]!
	strhal	r15, [r15, +r15]!
	strhal	r0, [r0], -255
	strhal	r15, [r15], +255
	strhal	r0, [r0], -r0
	strhal	r15, [r15], +r15

positive: strt instruction

	strt	r0, [r0], -4095
	strt	r15, [r15], +4095
	strt	r0, [r0], -r0
	strt	r15, [r15], +r15
	strt	r0, [r1], r2, lsl 0
	strt	r15, [r15], r15, lsl 31
	strt	r0, [r1], r2, lsr 1
	strt	r15, [r15], r15, lsr 32
	strt	r0, [r1], r2, asr 1
	strt	r15, [r15], r15, asr 32
	strt	r0, [r1], r2, ror 1
	strt	r15, [r15], r15, ror 31
	strt	r0, [r1], r2, rrx
	strt	r15, [r15], r15, rrx

positive: strteq instruction

	strteq	r0, [r0], -4095
	strteq	r15, [r15], +4095
	strteq	r0, [r0], -r0
	strteq	r15, [r15], +r15
	strteq	r0, [r1], r2, lsl 0
	strteq	r15, [r15], r15, lsl 31
	strteq	r0, [r1], r2, lsr 1
	strteq	r15, [r15], r15, lsr 32
	strteq	r0, [r1], r2, asr 1
	strteq	r15, [r15], r15, asr 32
	strteq	r0, [r1], r2, ror 1
	strteq	r15, [r15], r15, ror 31
	strteq	r0, [r1], r2, rrx
	strteq	r15, [r15], r15, rrx

positive: strtne instruction

	strtne	r0, [r0], -4095
	strtne	r15, [r15], +4095
	strtne	r0, [r0], -r0
	strtne	r15, [r15], +r15
	strtne	r0, [r1], r2, lsl 0
	strtne	r15, [r15], r15, lsl 31
	strtne	r0, [r1], r2, lsr 1
	strtne	r15, [r15], r15, lsr 32
	strtne	r0, [r1], r2, asr 1
	strtne	r15, [r15], r15, asr 32
	strtne	r0, [r1], r2, ror 1
	strtne	r15, [r15], r15, ror 31
	strtne	r0, [r1], r2, rrx
	strtne	r15, [r15], r15, rrx

positive: strtcs instruction

	strtcs	r0, [r0], -4095
	strtcs	r15, [r15], +4095
	strtcs	r0, [r0], -r0
	strtcs	r15, [r15], +r15
	strtcs	r0, [r1], r2, lsl 0
	strtcs	r15, [r15], r15, lsl 31
	strtcs	r0, [r1], r2, lsr 1
	strtcs	r15, [r15], r15, lsr 32
	strtcs	r0, [r1], r2, asr 1
	strtcs	r15, [r15], r15, asr 32
	strtcs	r0, [r1], r2, ror 1
	strtcs	r15, [r15], r15, ror 31
	strtcs	r0, [r1], r2, rrx
	strtcs	r15, [r15], r15, rrx

positive: strths instruction

	strths	r0, [r0], -4095
	strths	r15, [r15], +4095
	strths	r0, [r0], -r0
	strths	r15, [r15], +r15
	strths	r0, [r1], r2, lsl 0
	strths	r15, [r15], r15, lsl 31
	strths	r0, [r1], r2, lsr 1
	strths	r15, [r15], r15, lsr 32
	strths	r0, [r1], r2, asr 1
	strths	r15, [r15], r15, asr 32
	strths	r0, [r1], r2, ror 1
	strths	r15, [r15], r15, ror 31
	strths	r0, [r1], r2, rrx
	strths	r15, [r15], r15, rrx

positive: strtcc instruction

	strtcc	r0, [r0], -4095
	strtcc	r15, [r15], +4095
	strtcc	r0, [r0], -r0
	strtcc	r15, [r15], +r15
	strtcc	r0, [r1], r2, lsl 0
	strtcc	r15, [r15], r15, lsl 31
	strtcc	r0, [r1], r2, lsr 1
	strtcc	r15, [r15], r15, lsr 32
	strtcc	r0, [r1], r2, asr 1
	strtcc	r15, [r15], r15, asr 32
	strtcc	r0, [r1], r2, ror 1
	strtcc	r15, [r15], r15, ror 31
	strtcc	r0, [r1], r2, rrx
	strtcc	r15, [r15], r15, rrx

positive: strtlo instruction

	strtlo	r0, [r0], -4095
	strtlo	r15, [r15], +4095
	strtlo	r0, [r0], -r0
	strtlo	r15, [r15], +r15
	strtlo	r0, [r1], r2, lsl 0
	strtlo	r15, [r15], r15, lsl 31
	strtlo	r0, [r1], r2, lsr 1
	strtlo	r15, [r15], r15, lsr 32
	strtlo	r0, [r1], r2, asr 1
	strtlo	r15, [r15], r15, asr 32
	strtlo	r0, [r1], r2, ror 1
	strtlo	r15, [r15], r15, ror 31
	strtlo	r0, [r1], r2, rrx
	strtlo	r15, [r15], r15, rrx

positive: strtmi instruction

	strtmi	r0, [r0], -4095
	strtmi	r15, [r15], +4095
	strtmi	r0, [r0], -r0
	strtmi	r15, [r15], +r15
	strtmi	r0, [r1], r2, lsl 0
	strtmi	r15, [r15], r15, lsl 31
	strtmi	r0, [r1], r2, lsr 1
	strtmi	r15, [r15], r15, lsr 32
	strtmi	r0, [r1], r2, asr 1
	strtmi	r15, [r15], r15, asr 32
	strtmi	r0, [r1], r2, ror 1
	strtmi	r15, [r15], r15, ror 31
	strtmi	r0, [r1], r2, rrx
	strtmi	r15, [r15], r15, rrx

positive: strtpl instruction

	strtpl	r0, [r0], -4095
	strtpl	r15, [r15], +4095
	strtpl	r0, [r0], -r0
	strtpl	r15, [r15], +r15
	strtpl	r0, [r1], r2, lsl 0
	strtpl	r15, [r15], r15, lsl 31
	strtpl	r0, [r1], r2, lsr 1
	strtpl	r15, [r15], r15, lsr 32
	strtpl	r0, [r1], r2, asr 1
	strtpl	r15, [r15], r15, asr 32
	strtpl	r0, [r1], r2, ror 1
	strtpl	r15, [r15], r15, ror 31
	strtpl	r0, [r1], r2, rrx
	strtpl	r15, [r15], r15, rrx

positive: strtvs instruction

	strtvs	r0, [r0], -4095
	strtvs	r15, [r15], +4095
	strtvs	r0, [r0], -r0
	strtvs	r15, [r15], +r15
	strtvs	r0, [r1], r2, lsl 0
	strtvs	r15, [r15], r15, lsl 31
	strtvs	r0, [r1], r2, lsr 1
	strtvs	r15, [r15], r15, lsr 32
	strtvs	r0, [r1], r2, asr 1
	strtvs	r15, [r15], r15, asr 32
	strtvs	r0, [r1], r2, ror 1
	strtvs	r15, [r15], r15, ror 31
	strtvs	r0, [r1], r2, rrx
	strtvs	r15, [r15], r15, rrx

positive: strtvc instruction

	strtvc	r0, [r0], -4095
	strtvc	r15, [r15], +4095
	strtvc	r0, [r0], -r0
	strtvc	r15, [r15], +r15
	strtvc	r0, [r1], r2, lsl 0
	strtvc	r15, [r15], r15, lsl 31
	strtvc	r0, [r1], r2, lsr 1
	strtvc	r15, [r15], r15, lsr 32
	strtvc	r0, [r1], r2, asr 1
	strtvc	r15, [r15], r15, asr 32
	strtvc	r0, [r1], r2, ror 1
	strtvc	r15, [r15], r15, ror 31
	strtvc	r0, [r1], r2, rrx
	strtvc	r15, [r15], r15, rrx

positive: strthi instruction

	strthi	r0, [r0], -4095
	strthi	r15, [r15], +4095
	strthi	r0, [r0], -r0
	strthi	r15, [r15], +r15
	strthi	r0, [r1], r2, lsl 0
	strthi	r15, [r15], r15, lsl 31
	strthi	r0, [r1], r2, lsr 1
	strthi	r15, [r15], r15, lsr 32
	strthi	r0, [r1], r2, asr 1
	strthi	r15, [r15], r15, asr 32
	strthi	r0, [r1], r2, ror 1
	strthi	r15, [r15], r15, ror 31
	strthi	r0, [r1], r2, rrx
	strthi	r15, [r15], r15, rrx

positive: strtls instruction

	strtls	r0, [r0], -4095
	strtls	r15, [r15], +4095
	strtls	r0, [r0], -r0
	strtls	r15, [r15], +r15
	strtls	r0, [r1], r2, lsl 0
	strtls	r15, [r15], r15, lsl 31
	strtls	r0, [r1], r2, lsr 1
	strtls	r15, [r15], r15, lsr 32
	strtls	r0, [r1], r2, asr 1
	strtls	r15, [r15], r15, asr 32
	strtls	r0, [r1], r2, ror 1
	strtls	r15, [r15], r15, ror 31
	strtls	r0, [r1], r2, rrx
	strtls	r15, [r15], r15, rrx

positive: strtge instruction

	strtge	r0, [r0], -4095
	strtge	r15, [r15], +4095
	strtge	r0, [r0], -r0
	strtge	r15, [r15], +r15
	strtge	r0, [r1], r2, lsl 0
	strtge	r15, [r15], r15, lsl 31
	strtge	r0, [r1], r2, lsr 1
	strtge	r15, [r15], r15, lsr 32
	strtge	r0, [r1], r2, asr 1
	strtge	r15, [r15], r15, asr 32
	strtge	r0, [r1], r2, ror 1
	strtge	r15, [r15], r15, ror 31
	strtge	r0, [r1], r2, rrx
	strtge	r15, [r15], r15, rrx

positive: strtlt instruction

	strtlt	r0, [r0], -4095
	strtlt	r15, [r15], +4095
	strtlt	r0, [r0], -r0
	strtlt	r15, [r15], +r15
	strtlt	r0, [r1], r2, lsl 0
	strtlt	r15, [r15], r15, lsl 31
	strtlt	r0, [r1], r2, lsr 1
	strtlt	r15, [r15], r15, lsr 32
	strtlt	r0, [r1], r2, asr 1
	strtlt	r15, [r15], r15, asr 32
	strtlt	r0, [r1], r2, ror 1
	strtlt	r15, [r15], r15, ror 31
	strtlt	r0, [r1], r2, rrx
	strtlt	r15, [r15], r15, rrx

positive: strtgt instruction

	strtgt	r0, [r0], -4095
	strtgt	r15, [r15], +4095
	strtgt	r0, [r0], -r0
	strtgt	r15, [r15], +r15
	strtgt	r0, [r1], r2, lsl 0
	strtgt	r15, [r15], r15, lsl 31
	strtgt	r0, [r1], r2, lsr 1
	strtgt	r15, [r15], r15, lsr 32
	strtgt	r0, [r1], r2, asr 1
	strtgt	r15, [r15], r15, asr 32
	strtgt	r0, [r1], r2, ror 1
	strtgt	r15, [r15], r15, ror 31
	strtgt	r0, [r1], r2, rrx
	strtgt	r15, [r15], r15, rrx

positive: strtle instruction

	strtle	r0, [r0], -4095
	strtle	r15, [r15], +4095
	strtle	r0, [r0], -r0
	strtle	r15, [r15], +r15
	strtle	r0, [r1], r2, lsl 0
	strtle	r15, [r15], r15, lsl 31
	strtle	r0, [r1], r2, lsr 1
	strtle	r15, [r15], r15, lsr 32
	strtle	r0, [r1], r2, asr 1
	strtle	r15, [r15], r15, asr 32
	strtle	r0, [r1], r2, ror 1
	strtle	r15, [r15], r15, ror 31
	strtle	r0, [r1], r2, rrx
	strtle	r15, [r15], r15, rrx

positive: strtal instruction

	strtal	r0, [r0], -4095
	strtal	r15, [r15], +4095
	strtal	r0, [r0], -r0
	strtal	r15, [r15], +r15
	strtal	r0, [r1], r2, lsl 0
	strtal	r15, [r15], r15, lsl 31
	strtal	r0, [r1], r2, lsr 1
	strtal	r15, [r15], r15, lsr 32
	strtal	r0, [r1], r2, asr 1
	strtal	r15, [r15], r15, asr 32
	strtal	r0, [r1], r2, ror 1
	strtal	r15, [r15], r15, ror 31
	strtal	r0, [r1], r2, rrx
	strtal	r15, [r15], r15, rrx

positive: strex instruction

	strex	r0, r0, [r0]
	strex	r15, r15, [r15]

positive: strexeq instruction

	strexeq	r0, r0, [r0]
	strexeq	r15, r15, [r15]

positive: strexne instruction

	strexne	r0, r0, [r0]
	strexne	r15, r15, [r15]

positive: strexcs instruction

	strexcs	r0, r0, [r0]
	strexcs	r15, r15, [r15]

positive: strexhs instruction

	strexhs	r0, r0, [r0]
	strexhs	r15, r15, [r15]

positive: strexcc instruction

	strexcc	r0, r0, [r0]
	strexcc	r15, r15, [r15]

positive: strexlo instruction

	strexlo	r0, r0, [r0]
	strexlo	r15, r15, [r15]

positive: strexmi instruction

	strexmi	r0, r0, [r0]
	strexmi	r15, r15, [r15]

positive: strexpl instruction

	strexpl	r0, r0, [r0]
	strexpl	r15, r15, [r15]

positive: strexvs instruction

	strexvs	r0, r0, [r0]
	strexvs	r15, r15, [r15]

positive: strexvc instruction

	strexvc	r0, r0, [r0]
	strexvc	r15, r15, [r15]

positive: strexhi instruction

	strexhi	r0, r0, [r0]
	strexhi	r15, r15, [r15]

positive: strexls instruction

	strexls	r0, r0, [r0]
	strexls	r15, r15, [r15]

positive: strexge instruction

	strexge	r0, r0, [r0]
	strexge	r15, r15, [r15]

positive: strexlt instruction

	strexlt	r0, r0, [r0]
	strexlt	r15, r15, [r15]

positive: strexgt instruction

	strexgt	r0, r0, [r0]
	strexgt	r15, r15, [r15]

positive: strexle instruction

	strexle	r0, r0, [r0]
	strexle	r15, r15, [r15]

positive: strexal instruction

	strexal	r0, r0, [r0]
	strexal	r15, r15, [r15]

positive: strexb instruction

	strexb	r0, r0, [r0]
	strexb	r15, r15, [r15]

positive: strexbeq instruction

	strexbeq	r0, r0, [r0]
	strexbeq	r15, r15, [r15]

positive: strexbne instruction

	strexbne	r0, r0, [r0]
	strexbne	r15, r15, [r15]

positive: strexbcs instruction

	strexbcs	r0, r0, [r0]
	strexbcs	r15, r15, [r15]

positive: strexbhs instruction

	strexbhs	r0, r0, [r0]
	strexbhs	r15, r15, [r15]

positive: strexbcc instruction

	strexbcc	r0, r0, [r0]
	strexbcc	r15, r15, [r15]

positive: strexblo instruction

	strexblo	r0, r0, [r0]
	strexblo	r15, r15, [r15]

positive: strexbmi instruction

	strexbmi	r0, r0, [r0]
	strexbmi	r15, r15, [r15]

positive: strexbpl instruction

	strexbpl	r0, r0, [r0]
	strexbpl	r15, r15, [r15]

positive: strexbvs instruction

	strexbvs	r0, r0, [r0]
	strexbvs	r15, r15, [r15]

positive: strexbvc instruction

	strexbvc	r0, r0, [r0]
	strexbvc	r15, r15, [r15]

positive: strexbhi instruction

	strexbhi	r0, r0, [r0]
	strexbhi	r15, r15, [r15]

positive: strexbls instruction

	strexbls	r0, r0, [r0]
	strexbls	r15, r15, [r15]

positive: strexbge instruction

	strexbge	r0, r0, [r0]
	strexbge	r15, r15, [r15]

positive: strexblt instruction

	strexblt	r0, r0, [r0]
	strexblt	r15, r15, [r15]

positive: strexbgt instruction

	strexbgt	r0, r0, [r0]
	strexbgt	r15, r15, [r15]

positive: strexble instruction

	strexble	r0, r0, [r0]
	strexble	r15, r15, [r15]

positive: strexbal instruction

	strexbal	r0, r0, [r0]
	strexbal	r15, r15, [r15]

positive: strexd instruction

	strexd	r0, r0, [r0]
	strexd	r15, r15, [r15]

positive: strexdeq instruction

	strexdeq	r0, r0, [r0]
	strexdeq	r15, r15, [r15]

positive: strexdne instruction

	strexdne	r0, r0, [r0]
	strexdne	r15, r15, [r15]

positive: strexdcs instruction

	strexdcs	r0, r0, [r0]
	strexdcs	r15, r15, [r15]

positive: strexdhs instruction

	strexdhs	r0, r0, [r0]
	strexdhs	r15, r15, [r15]

positive: strexdcc instruction

	strexdcc	r0, r0, [r0]
	strexdcc	r15, r15, [r15]

positive: strexdlo instruction

	strexdlo	r0, r0, [r0]
	strexdlo	r15, r15, [r15]

positive: strexdmi instruction

	strexdmi	r0, r0, [r0]
	strexdmi	r15, r15, [r15]

positive: strexdpl instruction

	strexdpl	r0, r0, [r0]
	strexdpl	r15, r15, [r15]

positive: strexdvs instruction

	strexdvs	r0, r0, [r0]
	strexdvs	r15, r15, [r15]

positive: strexdvc instruction

	strexdvc	r0, r0, [r0]
	strexdvc	r15, r15, [r15]

positive: strexdhi instruction

	strexdhi	r0, r0, [r0]
	strexdhi	r15, r15, [r15]

positive: strexdls instruction

	strexdls	r0, r0, [r0]
	strexdls	r15, r15, [r15]

positive: strexdge instruction

	strexdge	r0, r0, [r0]
	strexdge	r15, r15, [r15]

positive: strexdlt instruction

	strexdlt	r0, r0, [r0]
	strexdlt	r15, r15, [r15]

positive: strexdgt instruction

	strexdgt	r0, r0, [r0]
	strexdgt	r15, r15, [r15]

positive: strexdle instruction

	strexdle	r0, r0, [r0]
	strexdle	r15, r15, [r15]

positive: strexdal instruction

	strexdal	r0, r0, [r0]
	strexdal	r15, r15, [r15]

positive: strexh instruction

	strexh	r0, r0, [r0]
	strexh	r15, r15, [r15]

positive: strexheq instruction

	strexheq	r0, r0, [r0]
	strexheq	r15, r15, [r15]

positive: strexhne instruction

	strexhne	r0, r0, [r0]
	strexhne	r15, r15, [r15]

positive: strexhcs instruction

	strexhcs	r0, r0, [r0]
	strexhcs	r15, r15, [r15]

positive: strexhhs instruction

	strexhhs	r0, r0, [r0]
	strexhhs	r15, r15, [r15]

positive: strexhcc instruction

	strexhcc	r0, r0, [r0]
	strexhcc	r15, r15, [r15]

positive: strexhlo instruction

	strexhlo	r0, r0, [r0]
	strexhlo	r15, r15, [r15]

positive: strexhmi instruction

	strexhmi	r0, r0, [r0]
	strexhmi	r15, r15, [r15]

positive: strexhpl instruction

	strexhpl	r0, r0, [r0]
	strexhpl	r15, r15, [r15]

positive: strexhvs instruction

	strexhvs	r0, r0, [r0]
	strexhvs	r15, r15, [r15]

positive: strexhvc instruction

	strexhvc	r0, r0, [r0]
	strexhvc	r15, r15, [r15]

positive: strexhhi instruction

	strexhhi	r0, r0, [r0]
	strexhhi	r15, r15, [r15]

positive: strexhls instruction

	strexhls	r0, r0, [r0]
	strexhls	r15, r15, [r15]

positive: strexhge instruction

	strexhge	r0, r0, [r0]
	strexhge	r15, r15, [r15]

positive: strexhlt instruction

	strexhlt	r0, r0, [r0]
	strexhlt	r15, r15, [r15]

positive: strexhgt instruction

	strexhgt	r0, r0, [r0]
	strexhgt	r15, r15, [r15]

positive: strexhle instruction

	strexhle	r0, r0, [r0]
	strexhle	r15, r15, [r15]

positive: strexhal instruction

	strexhal	r0, r0, [r0]
	strexhal	r15, r15, [r15]

positive: sub instruction

	sub	r0, r0, 0
	sub	r15, r15, 0xff000000
	sub	r0, r0, r0
	sub	r15, r15, r15
	sub	r0, r0, r0, lsl 0
	sub	r15, r15, r15, lsl 31
	sub	r0, r0, r0, lsl r0
	sub	r15, r15, r15, lsl r15
	sub	r0, r0, r0, lsr 1
	sub	r15, r15, r15, lsr 32
	sub	r0, r0, r0, lsr r0
	sub	r15, r15, r15, asr r15
	sub	r0, r0, r0, asr 1
	sub	r15, r15, r15, asr 32
	sub	r0, r0, r0, asr r0
	sub	r15, r15, r15, asr r15
	sub	r0, r0, r0, ror 1
	sub	r15, r15, r15, ror 31
	sub	r0, r0, r0, ror r0
	sub	r15, r15, r15, ror r15
	sub	r0, r0, r0, rrx

positive: subeq instruction

	subeq	r0, r0, 0
	subeq	r15, r15, 0xff000000
	subeq	r0, r0, r0
	subeq	r15, r15, r15
	subeq	r0, r0, r0, lsl 0
	subeq	r15, r15, r15, lsl 31
	subeq	r0, r0, r0, lsl r0
	subeq	r15, r15, r15, lsl r15
	subeq	r0, r0, r0, lsr 1
	subeq	r15, r15, r15, lsr 32
	subeq	r0, r0, r0, lsr r0
	subeq	r15, r15, r15, asr r15
	subeq	r0, r0, r0, asr 1
	subeq	r15, r15, r15, asr 32
	subeq	r0, r0, r0, asr r0
	subeq	r15, r15, r15, asr r15
	subeq	r0, r0, r0, ror 1
	subeq	r15, r15, r15, ror 31
	subeq	r0, r0, r0, ror r0
	subeq	r15, r15, r15, ror r15
	subeq	r0, r0, r0, rrx

positive: subne instruction

	subne	r0, r0, 0
	subne	r15, r15, 0xff000000
	subne	r0, r0, r0
	subne	r15, r15, r15
	subne	r0, r0, r0, lsl 0
	subne	r15, r15, r15, lsl 31
	subne	r0, r0, r0, lsl r0
	subne	r15, r15, r15, lsl r15
	subne	r0, r0, r0, lsr 1
	subne	r15, r15, r15, lsr 32
	subne	r0, r0, r0, lsr r0
	subne	r15, r15, r15, asr r15
	subne	r0, r0, r0, asr 1
	subne	r15, r15, r15, asr 32
	subne	r0, r0, r0, asr r0
	subne	r15, r15, r15, asr r15
	subne	r0, r0, r0, ror 1
	subne	r15, r15, r15, ror 31
	subne	r0, r0, r0, ror r0
	subne	r15, r15, r15, ror r15
	subne	r0, r0, r0, rrx

positive: subcs instruction

	subcs	r0, r0, 0
	subcs	r15, r15, 0xff000000
	subcs	r0, r0, r0
	subcs	r15, r15, r15
	subcs	r0, r0, r0, lsl 0
	subcs	r15, r15, r15, lsl 31
	subcs	r0, r0, r0, lsl r0
	subcs	r15, r15, r15, lsl r15
	subcs	r0, r0, r0, lsr 1
	subcs	r15, r15, r15, lsr 32
	subcs	r0, r0, r0, lsr r0
	subcs	r15, r15, r15, asr r15
	subcs	r0, r0, r0, asr 1
	subcs	r15, r15, r15, asr 32
	subcs	r0, r0, r0, asr r0
	subcs	r15, r15, r15, asr r15
	subcs	r0, r0, r0, ror 1
	subcs	r15, r15, r15, ror 31
	subcs	r0, r0, r0, ror r0
	subcs	r15, r15, r15, ror r15
	subcs	r0, r0, r0, rrx

positive: subhs instruction

	subhs	r0, r0, 0
	subhs	r15, r15, 0xff000000
	subhs	r0, r0, r0
	subhs	r15, r15, r15
	subhs	r0, r0, r0, lsl 0
	subhs	r15, r15, r15, lsl 31
	subhs	r0, r0, r0, lsl r0
	subhs	r15, r15, r15, lsl r15
	subhs	r0, r0, r0, lsr 1
	subhs	r15, r15, r15, lsr 32
	subhs	r0, r0, r0, lsr r0
	subhs	r15, r15, r15, asr r15
	subhs	r0, r0, r0, asr 1
	subhs	r15, r15, r15, asr 32
	subhs	r0, r0, r0, asr r0
	subhs	r15, r15, r15, asr r15
	subhs	r0, r0, r0, ror 1
	subhs	r15, r15, r15, ror 31
	subhs	r0, r0, r0, ror r0
	subhs	r15, r15, r15, ror r15
	subhs	r0, r0, r0, rrx

positive: subcc instruction

	subcc	r0, r0, 0
	subcc	r15, r15, 0xff000000
	subcc	r0, r0, r0
	subcc	r15, r15, r15
	subcc	r0, r0, r0, lsl 0
	subcc	r15, r15, r15, lsl 31
	subcc	r0, r0, r0, lsl r0
	subcc	r15, r15, r15, lsl r15
	subcc	r0, r0, r0, lsr 1
	subcc	r15, r15, r15, lsr 32
	subcc	r0, r0, r0, lsr r0
	subcc	r15, r15, r15, asr r15
	subcc	r0, r0, r0, asr 1
	subcc	r15, r15, r15, asr 32
	subcc	r0, r0, r0, asr r0
	subcc	r15, r15, r15, asr r15
	subcc	r0, r0, r0, ror 1
	subcc	r15, r15, r15, ror 31
	subcc	r0, r0, r0, ror r0
	subcc	r15, r15, r15, ror r15
	subcc	r0, r0, r0, rrx

positive: sublo instruction

	sublo	r0, r0, 0
	sublo	r15, r15, 0xff000000
	sublo	r0, r0, r0
	sublo	r15, r15, r15
	sublo	r0, r0, r0, lsl 0
	sublo	r15, r15, r15, lsl 31
	sublo	r0, r0, r0, lsl r0
	sublo	r15, r15, r15, lsl r15
	sublo	r0, r0, r0, lsr 1
	sublo	r15, r15, r15, lsr 32
	sublo	r0, r0, r0, lsr r0
	sublo	r15, r15, r15, asr r15
	sublo	r0, r0, r0, asr 1
	sublo	r15, r15, r15, asr 32
	sublo	r0, r0, r0, asr r0
	sublo	r15, r15, r15, asr r15
	sublo	r0, r0, r0, ror 1
	sublo	r15, r15, r15, ror 31
	sublo	r0, r0, r0, ror r0
	sublo	r15, r15, r15, ror r15
	sublo	r0, r0, r0, rrx

positive: submi instruction

	submi	r0, r0, 0
	submi	r15, r15, 0xff000000
	submi	r0, r0, r0
	submi	r15, r15, r15
	submi	r0, r0, r0, lsl 0
	submi	r15, r15, r15, lsl 31
	submi	r0, r0, r0, lsl r0
	submi	r15, r15, r15, lsl r15
	submi	r0, r0, r0, lsr 1
	submi	r15, r15, r15, lsr 32
	submi	r0, r0, r0, lsr r0
	submi	r15, r15, r15, asr r15
	submi	r0, r0, r0, asr 1
	submi	r15, r15, r15, asr 32
	submi	r0, r0, r0, asr r0
	submi	r15, r15, r15, asr r15
	submi	r0, r0, r0, ror 1
	submi	r15, r15, r15, ror 31
	submi	r0, r0, r0, ror r0
	submi	r15, r15, r15, ror r15
	submi	r0, r0, r0, rrx

positive: subpl instruction

	subpl	r0, r0, 0
	subpl	r15, r15, 0xff000000
	subpl	r0, r0, r0
	subpl	r15, r15, r15
	subpl	r0, r0, r0, lsl 0
	subpl	r15, r15, r15, lsl 31
	subpl	r0, r0, r0, lsl r0
	subpl	r15, r15, r15, lsl r15
	subpl	r0, r0, r0, lsr 1
	subpl	r15, r15, r15, lsr 32
	subpl	r0, r0, r0, lsr r0
	subpl	r15, r15, r15, asr r15
	subpl	r0, r0, r0, asr 1
	subpl	r15, r15, r15, asr 32
	subpl	r0, r0, r0, asr r0
	subpl	r15, r15, r15, asr r15
	subpl	r0, r0, r0, ror 1
	subpl	r15, r15, r15, ror 31
	subpl	r0, r0, r0, ror r0
	subpl	r15, r15, r15, ror r15
	subpl	r0, r0, r0, rrx

positive: subvs instruction

	subvs	r0, r0, 0
	subvs	r15, r15, 0xff000000
	subvs	r0, r0, r0
	subvs	r15, r15, r15
	subvs	r0, r0, r0, lsl 0
	subvs	r15, r15, r15, lsl 31
	subvs	r0, r0, r0, lsl r0
	subvs	r15, r15, r15, lsl r15
	subvs	r0, r0, r0, lsr 1
	subvs	r15, r15, r15, lsr 32
	subvs	r0, r0, r0, lsr r0
	subvs	r15, r15, r15, asr r15
	subvs	r0, r0, r0, asr 1
	subvs	r15, r15, r15, asr 32
	subvs	r0, r0, r0, asr r0
	subvs	r15, r15, r15, asr r15
	subvs	r0, r0, r0, ror 1
	subvs	r15, r15, r15, ror 31
	subvs	r0, r0, r0, ror r0
	subvs	r15, r15, r15, ror r15
	subvs	r0, r0, r0, rrx

positive: subvc instruction

	subvc	r0, r0, 0
	subvc	r15, r15, 0xff000000
	subvc	r0, r0, r0
	subvc	r15, r15, r15
	subvc	r0, r0, r0, lsl 0
	subvc	r15, r15, r15, lsl 31
	subvc	r0, r0, r0, lsl r0
	subvc	r15, r15, r15, lsl r15
	subvc	r0, r0, r0, lsr 1
	subvc	r15, r15, r15, lsr 32
	subvc	r0, r0, r0, lsr r0
	subvc	r15, r15, r15, asr r15
	subvc	r0, r0, r0, asr 1
	subvc	r15, r15, r15, asr 32
	subvc	r0, r0, r0, asr r0
	subvc	r15, r15, r15, asr r15
	subvc	r0, r0, r0, ror 1
	subvc	r15, r15, r15, ror 31
	subvc	r0, r0, r0, ror r0
	subvc	r15, r15, r15, ror r15
	subvc	r0, r0, r0, rrx

positive: subhi instruction

	subhi	r0, r0, 0
	subhi	r15, r15, 0xff000000
	subhi	r0, r0, r0
	subhi	r15, r15, r15
	subhi	r0, r0, r0, lsl 0
	subhi	r15, r15, r15, lsl 31
	subhi	r0, r0, r0, lsl r0
	subhi	r15, r15, r15, lsl r15
	subhi	r0, r0, r0, lsr 1
	subhi	r15, r15, r15, lsr 32
	subhi	r0, r0, r0, lsr r0
	subhi	r15, r15, r15, asr r15
	subhi	r0, r0, r0, asr 1
	subhi	r15, r15, r15, asr 32
	subhi	r0, r0, r0, asr r0
	subhi	r15, r15, r15, asr r15
	subhi	r0, r0, r0, ror 1
	subhi	r15, r15, r15, ror 31
	subhi	r0, r0, r0, ror r0
	subhi	r15, r15, r15, ror r15
	subhi	r0, r0, r0, rrx

positive: subls instruction

	subls	r0, r0, 0
	subls	r15, r15, 0xff000000
	subls	r0, r0, r0
	subls	r15, r15, r15
	subls	r0, r0, r0, lsl 0
	subls	r15, r15, r15, lsl 31
	subls	r0, r0, r0, lsl r0
	subls	r15, r15, r15, lsl r15
	subls	r0, r0, r0, lsr 1
	subls	r15, r15, r15, lsr 32
	subls	r0, r0, r0, lsr r0
	subls	r15, r15, r15, asr r15
	subls	r0, r0, r0, asr 1
	subls	r15, r15, r15, asr 32
	subls	r0, r0, r0, asr r0
	subls	r15, r15, r15, asr r15
	subls	r0, r0, r0, ror 1
	subls	r15, r15, r15, ror 31
	subls	r0, r0, r0, ror r0
	subls	r15, r15, r15, ror r15
	subls	r0, r0, r0, rrx

positive: subge instruction

	subge	r0, r0, 0
	subge	r15, r15, 0xff000000
	subge	r0, r0, r0
	subge	r15, r15, r15
	subge	r0, r0, r0, lsl 0
	subge	r15, r15, r15, lsl 31
	subge	r0, r0, r0, lsl r0
	subge	r15, r15, r15, lsl r15
	subge	r0, r0, r0, lsr 1
	subge	r15, r15, r15, lsr 32
	subge	r0, r0, r0, lsr r0
	subge	r15, r15, r15, asr r15
	subge	r0, r0, r0, asr 1
	subge	r15, r15, r15, asr 32
	subge	r0, r0, r0, asr r0
	subge	r15, r15, r15, asr r15
	subge	r0, r0, r0, ror 1
	subge	r15, r15, r15, ror 31
	subge	r0, r0, r0, ror r0
	subge	r15, r15, r15, ror r15
	subge	r0, r0, r0, rrx

positive: sublt instruction

	sublt	r0, r0, 0
	sublt	r15, r15, 0xff000000
	sublt	r0, r0, r0
	sublt	r15, r15, r15
	sublt	r0, r0, r0, lsl 0
	sublt	r15, r15, r15, lsl 31
	sublt	r0, r0, r0, lsl r0
	sublt	r15, r15, r15, lsl r15
	sublt	r0, r0, r0, lsr 1
	sublt	r15, r15, r15, lsr 32
	sublt	r0, r0, r0, lsr r0
	sublt	r15, r15, r15, asr r15
	sublt	r0, r0, r0, asr 1
	sublt	r15, r15, r15, asr 32
	sublt	r0, r0, r0, asr r0
	sublt	r15, r15, r15, asr r15
	sublt	r0, r0, r0, ror 1
	sublt	r15, r15, r15, ror 31
	sublt	r0, r0, r0, ror r0
	sublt	r15, r15, r15, ror r15
	sublt	r0, r0, r0, rrx

positive: subgt instruction

	subgt	r0, r0, 0
	subgt	r15, r15, 0xff000000
	subgt	r0, r0, r0
	subgt	r15, r15, r15
	subgt	r0, r0, r0, lsl 0
	subgt	r15, r15, r15, lsl 31
	subgt	r0, r0, r0, lsl r0
	subgt	r15, r15, r15, lsl r15
	subgt	r0, r0, r0, lsr 1
	subgt	r15, r15, r15, lsr 32
	subgt	r0, r0, r0, lsr r0
	subgt	r15, r15, r15, asr r15
	subgt	r0, r0, r0, asr 1
	subgt	r15, r15, r15, asr 32
	subgt	r0, r0, r0, asr r0
	subgt	r15, r15, r15, asr r15
	subgt	r0, r0, r0, ror 1
	subgt	r15, r15, r15, ror 31
	subgt	r0, r0, r0, ror r0
	subgt	r15, r15, r15, ror r15
	subgt	r0, r0, r0, rrx

positive: suble instruction

	suble	r0, r0, 0
	suble	r15, r15, 0xff000000
	suble	r0, r0, r0
	suble	r15, r15, r15
	suble	r0, r0, r0, lsl 0
	suble	r15, r15, r15, lsl 31
	suble	r0, r0, r0, lsl r0
	suble	r15, r15, r15, lsl r15
	suble	r0, r0, r0, lsr 1
	suble	r15, r15, r15, lsr 32
	suble	r0, r0, r0, lsr r0
	suble	r15, r15, r15, asr r15
	suble	r0, r0, r0, asr 1
	suble	r15, r15, r15, asr 32
	suble	r0, r0, r0, asr r0
	suble	r15, r15, r15, asr r15
	suble	r0, r0, r0, ror 1
	suble	r15, r15, r15, ror 31
	suble	r0, r0, r0, ror r0
	suble	r15, r15, r15, ror r15
	suble	r0, r0, r0, rrx

positive: subal instruction

	subal	r0, r0, 0
	subal	r15, r15, 0xff000000
	subal	r0, r0, r0
	subal	r15, r15, r15
	subal	r0, r0, r0, lsl 0
	subal	r15, r15, r15, lsl 31
	subal	r0, r0, r0, lsl r0
	subal	r15, r15, r15, lsl r15
	subal	r0, r0, r0, lsr 1
	subal	r15, r15, r15, lsr 32
	subal	r0, r0, r0, lsr r0
	subal	r15, r15, r15, asr r15
	subal	r0, r0, r0, asr 1
	subal	r15, r15, r15, asr 32
	subal	r0, r0, r0, asr r0
	subal	r15, r15, r15, asr r15
	subal	r0, r0, r0, ror 1
	subal	r15, r15, r15, ror 31
	subal	r0, r0, r0, ror r0
	subal	r15, r15, r15, ror r15
	subal	r0, r0, r0, rrx

positive: subs instruction

	subs	r0, r0, 0
	subs	r15, r15, 0xff000000
	subs	r0, r0, r0
	subs	r15, r15, r15
	subs	r0, r0, r0, lsl 0
	subs	r15, r15, r15, lsl 31
	subs	r0, r0, r0, lsl r0
	subs	r15, r15, r15, lsl r15
	subs	r0, r0, r0, lsr 1
	subs	r15, r15, r15, lsr 32
	subs	r0, r0, r0, lsr r0
	subs	r15, r15, r15, asr r15
	subs	r0, r0, r0, asr 1
	subs	r15, r15, r15, asr 32
	subs	r0, r0, r0, asr r0
	subs	r15, r15, r15, asr r15
	subs	r0, r0, r0, ror 1
	subs	r15, r15, r15, ror 31
	subs	r0, r0, r0, ror r0
	subs	r15, r15, r15, ror r15
	subs	r0, r0, r0, rrx

positive: subseq instruction

	subseq	r0, r0, 0
	subseq	r15, r15, 0xff000000
	subseq	r0, r0, r0
	subseq	r15, r15, r15
	subseq	r0, r0, r0, lsl 0
	subseq	r15, r15, r15, lsl 31
	subseq	r0, r0, r0, lsl r0
	subseq	r15, r15, r15, lsl r15
	subseq	r0, r0, r0, lsr 1
	subseq	r15, r15, r15, lsr 32
	subseq	r0, r0, r0, lsr r0
	subseq	r15, r15, r15, asr r15
	subseq	r0, r0, r0, asr 1
	subseq	r15, r15, r15, asr 32
	subseq	r0, r0, r0, asr r0
	subseq	r15, r15, r15, asr r15
	subseq	r0, r0, r0, ror 1
	subseq	r15, r15, r15, ror 31
	subseq	r0, r0, r0, ror r0
	subseq	r15, r15, r15, ror r15
	subseq	r0, r0, r0, rrx

positive: subsne instruction

	subsne	r0, r0, 0
	subsne	r15, r15, 0xff000000
	subsne	r0, r0, r0
	subsne	r15, r15, r15
	subsne	r0, r0, r0, lsl 0
	subsne	r15, r15, r15, lsl 31
	subsne	r0, r0, r0, lsl r0
	subsne	r15, r15, r15, lsl r15
	subsne	r0, r0, r0, lsr 1
	subsne	r15, r15, r15, lsr 32
	subsne	r0, r0, r0, lsr r0
	subsne	r15, r15, r15, asr r15
	subsne	r0, r0, r0, asr 1
	subsne	r15, r15, r15, asr 32
	subsne	r0, r0, r0, asr r0
	subsne	r15, r15, r15, asr r15
	subsne	r0, r0, r0, ror 1
	subsne	r15, r15, r15, ror 31
	subsne	r0, r0, r0, ror r0
	subsne	r15, r15, r15, ror r15
	subsne	r0, r0, r0, rrx

positive: subscs instruction

	subscs	r0, r0, 0
	subscs	r15, r15, 0xff000000
	subscs	r0, r0, r0
	subscs	r15, r15, r15
	subscs	r0, r0, r0, lsl 0
	subscs	r15, r15, r15, lsl 31
	subscs	r0, r0, r0, lsl r0
	subscs	r15, r15, r15, lsl r15
	subscs	r0, r0, r0, lsr 1
	subscs	r15, r15, r15, lsr 32
	subscs	r0, r0, r0, lsr r0
	subscs	r15, r15, r15, asr r15
	subscs	r0, r0, r0, asr 1
	subscs	r15, r15, r15, asr 32
	subscs	r0, r0, r0, asr r0
	subscs	r15, r15, r15, asr r15
	subscs	r0, r0, r0, ror 1
	subscs	r15, r15, r15, ror 31
	subscs	r0, r0, r0, ror r0
	subscs	r15, r15, r15, ror r15
	subscs	r0, r0, r0, rrx

positive: subshs instruction

	subshs	r0, r0, 0
	subshs	r15, r15, 0xff000000
	subshs	r0, r0, r0
	subshs	r15, r15, r15
	subshs	r0, r0, r0, lsl 0
	subshs	r15, r15, r15, lsl 31
	subshs	r0, r0, r0, lsl r0
	subshs	r15, r15, r15, lsl r15
	subshs	r0, r0, r0, lsr 1
	subshs	r15, r15, r15, lsr 32
	subshs	r0, r0, r0, lsr r0
	subshs	r15, r15, r15, asr r15
	subshs	r0, r0, r0, asr 1
	subshs	r15, r15, r15, asr 32
	subshs	r0, r0, r0, asr r0
	subshs	r15, r15, r15, asr r15
	subshs	r0, r0, r0, ror 1
	subshs	r15, r15, r15, ror 31
	subshs	r0, r0, r0, ror r0
	subshs	r15, r15, r15, ror r15
	subshs	r0, r0, r0, rrx

positive: subscc instruction

	subscc	r0, r0, 0
	subscc	r15, r15, 0xff000000
	subscc	r0, r0, r0
	subscc	r15, r15, r15
	subscc	r0, r0, r0, lsl 0
	subscc	r15, r15, r15, lsl 31
	subscc	r0, r0, r0, lsl r0
	subscc	r15, r15, r15, lsl r15
	subscc	r0, r0, r0, lsr 1
	subscc	r15, r15, r15, lsr 32
	subscc	r0, r0, r0, lsr r0
	subscc	r15, r15, r15, asr r15
	subscc	r0, r0, r0, asr 1
	subscc	r15, r15, r15, asr 32
	subscc	r0, r0, r0, asr r0
	subscc	r15, r15, r15, asr r15
	subscc	r0, r0, r0, ror 1
	subscc	r15, r15, r15, ror 31
	subscc	r0, r0, r0, ror r0
	subscc	r15, r15, r15, ror r15
	subscc	r0, r0, r0, rrx

positive: subslo instruction

	subslo	r0, r0, 0
	subslo	r15, r15, 0xff000000
	subslo	r0, r0, r0
	subslo	r15, r15, r15
	subslo	r0, r0, r0, lsl 0
	subslo	r15, r15, r15, lsl 31
	subslo	r0, r0, r0, lsl r0
	subslo	r15, r15, r15, lsl r15
	subslo	r0, r0, r0, lsr 1
	subslo	r15, r15, r15, lsr 32
	subslo	r0, r0, r0, lsr r0
	subslo	r15, r15, r15, asr r15
	subslo	r0, r0, r0, asr 1
	subslo	r15, r15, r15, asr 32
	subslo	r0, r0, r0, asr r0
	subslo	r15, r15, r15, asr r15
	subslo	r0, r0, r0, ror 1
	subslo	r15, r15, r15, ror 31
	subslo	r0, r0, r0, ror r0
	subslo	r15, r15, r15, ror r15
	subslo	r0, r0, r0, rrx

positive: subsmi instruction

	subsmi	r0, r0, 0
	subsmi	r15, r15, 0xff000000
	subsmi	r0, r0, r0
	subsmi	r15, r15, r15
	subsmi	r0, r0, r0, lsl 0
	subsmi	r15, r15, r15, lsl 31
	subsmi	r0, r0, r0, lsl r0
	subsmi	r15, r15, r15, lsl r15
	subsmi	r0, r0, r0, lsr 1
	subsmi	r15, r15, r15, lsr 32
	subsmi	r0, r0, r0, lsr r0
	subsmi	r15, r15, r15, asr r15
	subsmi	r0, r0, r0, asr 1
	subsmi	r15, r15, r15, asr 32
	subsmi	r0, r0, r0, asr r0
	subsmi	r15, r15, r15, asr r15
	subsmi	r0, r0, r0, ror 1
	subsmi	r15, r15, r15, ror 31
	subsmi	r0, r0, r0, ror r0
	subsmi	r15, r15, r15, ror r15
	subsmi	r0, r0, r0, rrx

positive: subspl instruction

	subspl	r0, r0, 0
	subspl	r15, r15, 0xff000000
	subspl	r0, r0, r0
	subspl	r15, r15, r15
	subspl	r0, r0, r0, lsl 0
	subspl	r15, r15, r15, lsl 31
	subspl	r0, r0, r0, lsl r0
	subspl	r15, r15, r15, lsl r15
	subspl	r0, r0, r0, lsr 1
	subspl	r15, r15, r15, lsr 32
	subspl	r0, r0, r0, lsr r0
	subspl	r15, r15, r15, asr r15
	subspl	r0, r0, r0, asr 1
	subspl	r15, r15, r15, asr 32
	subspl	r0, r0, r0, asr r0
	subspl	r15, r15, r15, asr r15
	subspl	r0, r0, r0, ror 1
	subspl	r15, r15, r15, ror 31
	subspl	r0, r0, r0, ror r0
	subspl	r15, r15, r15, ror r15
	subspl	r0, r0, r0, rrx

positive: subsvs instruction

	subsvs	r0, r0, 0
	subsvs	r15, r15, 0xff000000
	subsvs	r0, r0, r0
	subsvs	r15, r15, r15
	subsvs	r0, r0, r0, lsl 0
	subsvs	r15, r15, r15, lsl 31
	subsvs	r0, r0, r0, lsl r0
	subsvs	r15, r15, r15, lsl r15
	subsvs	r0, r0, r0, lsr 1
	subsvs	r15, r15, r15, lsr 32
	subsvs	r0, r0, r0, lsr r0
	subsvs	r15, r15, r15, asr r15
	subsvs	r0, r0, r0, asr 1
	subsvs	r15, r15, r15, asr 32
	subsvs	r0, r0, r0, asr r0
	subsvs	r15, r15, r15, asr r15
	subsvs	r0, r0, r0, ror 1
	subsvs	r15, r15, r15, ror 31
	subsvs	r0, r0, r0, ror r0
	subsvs	r15, r15, r15, ror r15
	subsvs	r0, r0, r0, rrx

positive: subsvc instruction

	subsvc	r0, r0, 0
	subsvc	r15, r15, 0xff000000
	subsvc	r0, r0, r0
	subsvc	r15, r15, r15
	subsvc	r0, r0, r0, lsl 0
	subsvc	r15, r15, r15, lsl 31
	subsvc	r0, r0, r0, lsl r0
	subsvc	r15, r15, r15, lsl r15
	subsvc	r0, r0, r0, lsr 1
	subsvc	r15, r15, r15, lsr 32
	subsvc	r0, r0, r0, lsr r0
	subsvc	r15, r15, r15, asr r15
	subsvc	r0, r0, r0, asr 1
	subsvc	r15, r15, r15, asr 32
	subsvc	r0, r0, r0, asr r0
	subsvc	r15, r15, r15, asr r15
	subsvc	r0, r0, r0, ror 1
	subsvc	r15, r15, r15, ror 31
	subsvc	r0, r0, r0, ror r0
	subsvc	r15, r15, r15, ror r15
	subsvc	r0, r0, r0, rrx

positive: subshi instruction

	subshi	r0, r0, 0
	subshi	r15, r15, 0xff000000
	subshi	r0, r0, r0
	subshi	r15, r15, r15
	subshi	r0, r0, r0, lsl 0
	subshi	r15, r15, r15, lsl 31
	subshi	r0, r0, r0, lsl r0
	subshi	r15, r15, r15, lsl r15
	subshi	r0, r0, r0, lsr 1
	subshi	r15, r15, r15, lsr 32
	subshi	r0, r0, r0, lsr r0
	subshi	r15, r15, r15, asr r15
	subshi	r0, r0, r0, asr 1
	subshi	r15, r15, r15, asr 32
	subshi	r0, r0, r0, asr r0
	subshi	r15, r15, r15, asr r15
	subshi	r0, r0, r0, ror 1
	subshi	r15, r15, r15, ror 31
	subshi	r0, r0, r0, ror r0
	subshi	r15, r15, r15, ror r15
	subshi	r0, r0, r0, rrx

positive: subsls instruction

	subsls	r0, r0, 0
	subsls	r15, r15, 0xff000000
	subsls	r0, r0, r0
	subsls	r15, r15, r15
	subsls	r0, r0, r0, lsl 0
	subsls	r15, r15, r15, lsl 31
	subsls	r0, r0, r0, lsl r0
	subsls	r15, r15, r15, lsl r15
	subsls	r0, r0, r0, lsr 1
	subsls	r15, r15, r15, lsr 32
	subsls	r0, r0, r0, lsr r0
	subsls	r15, r15, r15, asr r15
	subsls	r0, r0, r0, asr 1
	subsls	r15, r15, r15, asr 32
	subsls	r0, r0, r0, asr r0
	subsls	r15, r15, r15, asr r15
	subsls	r0, r0, r0, ror 1
	subsls	r15, r15, r15, ror 31
	subsls	r0, r0, r0, ror r0
	subsls	r15, r15, r15, ror r15
	subsls	r0, r0, r0, rrx

positive: subsge instruction

	subsge	r0, r0, 0
	subsge	r15, r15, 0xff000000
	subsge	r0, r0, r0
	subsge	r15, r15, r15
	subsge	r0, r0, r0, lsl 0
	subsge	r15, r15, r15, lsl 31
	subsge	r0, r0, r0, lsl r0
	subsge	r15, r15, r15, lsl r15
	subsge	r0, r0, r0, lsr 1
	subsge	r15, r15, r15, lsr 32
	subsge	r0, r0, r0, lsr r0
	subsge	r15, r15, r15, asr r15
	subsge	r0, r0, r0, asr 1
	subsge	r15, r15, r15, asr 32
	subsge	r0, r0, r0, asr r0
	subsge	r15, r15, r15, asr r15
	subsge	r0, r0, r0, ror 1
	subsge	r15, r15, r15, ror 31
	subsge	r0, r0, r0, ror r0
	subsge	r15, r15, r15, ror r15
	subsge	r0, r0, r0, rrx

positive: subslt instruction

	subslt	r0, r0, 0
	subslt	r15, r15, 0xff000000
	subslt	r0, r0, r0
	subslt	r15, r15, r15
	subslt	r0, r0, r0, lsl 0
	subslt	r15, r15, r15, lsl 31
	subslt	r0, r0, r0, lsl r0
	subslt	r15, r15, r15, lsl r15
	subslt	r0, r0, r0, lsr 1
	subslt	r15, r15, r15, lsr 32
	subslt	r0, r0, r0, lsr r0
	subslt	r15, r15, r15, asr r15
	subslt	r0, r0, r0, asr 1
	subslt	r15, r15, r15, asr 32
	subslt	r0, r0, r0, asr r0
	subslt	r15, r15, r15, asr r15
	subslt	r0, r0, r0, ror 1
	subslt	r15, r15, r15, ror 31
	subslt	r0, r0, r0, ror r0
	subslt	r15, r15, r15, ror r15
	subslt	r0, r0, r0, rrx

positive: subsgt instruction

	subsgt	r0, r0, 0
	subsgt	r15, r15, 0xff000000
	subsgt	r0, r0, r0
	subsgt	r15, r15, r15
	subsgt	r0, r0, r0, lsl 0
	subsgt	r15, r15, r15, lsl 31
	subsgt	r0, r0, r0, lsl r0
	subsgt	r15, r15, r15, lsl r15
	subsgt	r0, r0, r0, lsr 1
	subsgt	r15, r15, r15, lsr 32
	subsgt	r0, r0, r0, lsr r0
	subsgt	r15, r15, r15, asr r15
	subsgt	r0, r0, r0, asr 1
	subsgt	r15, r15, r15, asr 32
	subsgt	r0, r0, r0, asr r0
	subsgt	r15, r15, r15, asr r15
	subsgt	r0, r0, r0, ror 1
	subsgt	r15, r15, r15, ror 31
	subsgt	r0, r0, r0, ror r0
	subsgt	r15, r15, r15, ror r15
	subsgt	r0, r0, r0, rrx

positive: subsle instruction

	subsle	r0, r0, 0
	subsle	r15, r15, 0xff000000
	subsle	r0, r0, r0
	subsle	r15, r15, r15
	subsle	r0, r0, r0, lsl 0
	subsle	r15, r15, r15, lsl 31
	subsle	r0, r0, r0, lsl r0
	subsle	r15, r15, r15, lsl r15
	subsle	r0, r0, r0, lsr 1
	subsle	r15, r15, r15, lsr 32
	subsle	r0, r0, r0, lsr r0
	subsle	r15, r15, r15, asr r15
	subsle	r0, r0, r0, asr 1
	subsle	r15, r15, r15, asr 32
	subsle	r0, r0, r0, asr r0
	subsle	r15, r15, r15, asr r15
	subsle	r0, r0, r0, ror 1
	subsle	r15, r15, r15, ror 31
	subsle	r0, r0, r0, ror r0
	subsle	r15, r15, r15, ror r15
	subsle	r0, r0, r0, rrx

positive: subsal instruction

	subsal	r0, r0, 0
	subsal	r15, r15, 0xff000000
	subsal	r0, r0, r0
	subsal	r15, r15, r15
	subsal	r0, r0, r0, lsl 0
	subsal	r15, r15, r15, lsl 31
	subsal	r0, r0, r0, lsl r0
	subsal	r15, r15, r15, lsl r15
	subsal	r0, r0, r0, lsr 1
	subsal	r15, r15, r15, lsr 32
	subsal	r0, r0, r0, lsr r0
	subsal	r15, r15, r15, asr r15
	subsal	r0, r0, r0, asr 1
	subsal	r15, r15, r15, asr 32
	subsal	r0, r0, r0, asr r0
	subsal	r15, r15, r15, asr r15
	subsal	r0, r0, r0, ror 1
	subsal	r15, r15, r15, ror 31
	subsal	r0, r0, r0, ror r0
	subsal	r15, r15, r15, ror r15
	subsal	r0, r0, r0, rrx

positive: swi instruction

	swi	0
	swi	16777215

positive: swieq instruction

	swieq	0
	swieq	16777215

positive: swine instruction

	swine	0
	swine	16777215

positive: swics instruction

	swics	0
	swics	16777215

positive: swihs instruction

	swihs	0
	swihs	16777215

positive: swicc instruction

	swicc	0
	swicc	16777215

positive: swilo instruction

	swilo	0
	swilo	16777215

positive: swimi instruction

	swimi	0
	swimi	16777215

positive: swipl instruction

	swipl	0
	swipl	16777215

positive: swivs instruction

	swivs	0
	swivs	16777215

positive: swivc instruction

	swivc	0
	swivc	16777215

positive: swihi instruction

	swihi	0
	swihi	16777215

positive: swils instruction

	swils	0
	swils	16777215

positive: swige instruction

	swige	0
	swige	16777215

positive: swilt instruction

	swilt	0
	swilt	16777215

positive: swigt instruction

	swigt	0
	swigt	16777215

positive: swile instruction

	swile	0
	swile	16777215

positive: swial instruction

	swial	0
	swial	16777215

positive: swp instruction

	swp	r0, r0, [r0]
	swp	r15, r15, [r15]

positive: swpeq instruction

	swpeq	r0, r0, [r0]
	swpeq	r15, r15, [r15]

positive: swpne instruction

	swpne	r0, r0, [r0]
	swpne	r15, r15, [r15]

positive: swpcs instruction

	swpcs	r0, r0, [r0]
	swpcs	r15, r15, [r15]

positive: swphs instruction

	swphs	r0, r0, [r0]
	swphs	r15, r15, [r15]

positive: swpcc instruction

	swpcc	r0, r0, [r0]
	swpcc	r15, r15, [r15]

positive: swplo instruction

	swplo	r0, r0, [r0]
	swplo	r15, r15, [r15]

positive: swpmi instruction

	swpmi	r0, r0, [r0]
	swpmi	r15, r15, [r15]

positive: swppl instruction

	swppl	r0, r0, [r0]
	swppl	r15, r15, [r15]

positive: swpvs instruction

	swpvs	r0, r0, [r0]
	swpvs	r15, r15, [r15]

positive: swpvc instruction

	swpvc	r0, r0, [r0]
	swpvc	r15, r15, [r15]

positive: swphi instruction

	swphi	r0, r0, [r0]
	swphi	r15, r15, [r15]

positive: swpls instruction

	swpls	r0, r0, [r0]
	swpls	r15, r15, [r15]

positive: swpge instruction

	swpge	r0, r0, [r0]
	swpge	r15, r15, [r15]

positive: swplt instruction

	swplt	r0, r0, [r0]
	swplt	r15, r15, [r15]

positive: swpgt instruction

	swpgt	r0, r0, [r0]
	swpgt	r15, r15, [r15]

positive: swple instruction

	swple	r0, r0, [r0]
	swple	r15, r15, [r15]

positive: swpal instruction

	swpal	r0, r0, [r0]
	swpal	r15, r15, [r15]

positive: swpb instruction

	swpb	r0, r0, [r0]
	swpb	r15, r15, [r15]

positive: swpbeq instruction

	swpbeq	r0, r0, [r0]
	swpbeq	r15, r15, [r15]

positive: swpbne instruction

	swpbne	r0, r0, [r0]
	swpbne	r15, r15, [r15]

positive: swpbcs instruction

	swpbcs	r0, r0, [r0]
	swpbcs	r15, r15, [r15]

positive: swpbhs instruction

	swpbhs	r0, r0, [r0]
	swpbhs	r15, r15, [r15]

positive: swpbcc instruction

	swpbcc	r0, r0, [r0]
	swpbcc	r15, r15, [r15]

positive: swpblo instruction

	swpblo	r0, r0, [r0]
	swpblo	r15, r15, [r15]

positive: swpbmi instruction

	swpbmi	r0, r0, [r0]
	swpbmi	r15, r15, [r15]

positive: swpbpl instruction

	swpbpl	r0, r0, [r0]
	swpbpl	r15, r15, [r15]

positive: swpbvs instruction

	swpbvs	r0, r0, [r0]
	swpbvs	r15, r15, [r15]

positive: swpbvc instruction

	swpbvc	r0, r0, [r0]
	swpbvc	r15, r15, [r15]

positive: swpbhi instruction

	swpbhi	r0, r0, [r0]
	swpbhi	r15, r15, [r15]

positive: swpbls instruction

	swpbls	r0, r0, [r0]
	swpbls	r15, r15, [r15]

positive: swpbge instruction

	swpbge	r0, r0, [r0]
	swpbge	r15, r15, [r15]

positive: swpblt instruction

	swpblt	r0, r0, [r0]
	swpblt	r15, r15, [r15]

positive: swpbgt instruction

	swpbgt	r0, r0, [r0]
	swpbgt	r15, r15, [r15]

positive: swpble instruction

	swpble	r0, r0, [r0]
	swpble	r15, r15, [r15]

positive: swpbal instruction

	swpbal	r0, r0, [r0]
	swpbal	r15, r15, [r15]

positive: sxtab instruction

	sxtab	r0, r0, r0
	sxtab	r15, r15, r15

positive: sxtabeq instruction

	sxtabeq	r0, r0, r0
	sxtabeq	r15, r15, r15

positive: sxtabne instruction

	sxtabne	r0, r0, r0
	sxtabne	r15, r15, r15

positive: sxtabcs instruction

	sxtabcs	r0, r0, r0
	sxtabcs	r15, r15, r15

positive: sxtabhs instruction

	sxtabhs	r0, r0, r0
	sxtabhs	r15, r15, r15

positive: sxtabcc instruction

	sxtabcc	r0, r0, r0
	sxtabcc	r15, r15, r15

positive: sxtablo instruction

	sxtablo	r0, r0, r0
	sxtablo	r15, r15, r15

positive: sxtabmi instruction

	sxtabmi	r0, r0, r0
	sxtabmi	r15, r15, r15

positive: sxtabpl instruction

	sxtabpl	r0, r0, r0
	sxtabpl	r15, r15, r15

positive: sxtabvs instruction

	sxtabvs	r0, r0, r0
	sxtabvs	r15, r15, r15

positive: sxtabvc instruction

	sxtabvc	r0, r0, r0
	sxtabvc	r15, r15, r15

positive: sxtabhi instruction

	sxtabhi	r0, r0, r0
	sxtabhi	r15, r15, r15

positive: sxtabls instruction

	sxtabls	r0, r0, r0
	sxtabls	r15, r15, r15

positive: sxtabge instruction

	sxtabge	r0, r0, r0
	sxtabge	r15, r15, r15

positive: sxtablt instruction

	sxtablt	r0, r0, r0
	sxtablt	r15, r15, r15

positive: sxtabgt instruction

	sxtabgt	r0, r0, r0
	sxtabgt	r15, r15, r15

positive: sxtable instruction

	sxtable	r0, r0, r0
	sxtable	r15, r15, r15

positive: sxtabal instruction

	sxtabal	r0, r0, r0
	sxtabal	r15, r15, r15

positive: sxtab16 instruction

	sxtab16	r0, r0, r0
	sxtab16	r15, r15, r15

positive: sxtab16eq instruction

	sxtab16eq	r0, r0, r0
	sxtab16eq	r15, r15, r15

positive: sxtab16ne instruction

	sxtab16ne	r0, r0, r0
	sxtab16ne	r15, r15, r15

positive: sxtab16cs instruction

	sxtab16cs	r0, r0, r0
	sxtab16cs	r15, r15, r15

positive: sxtab16hs instruction

	sxtab16hs	r0, r0, r0
	sxtab16hs	r15, r15, r15

positive: sxtab16cc instruction

	sxtab16cc	r0, r0, r0
	sxtab16cc	r15, r15, r15

positive: sxtab16lo instruction

	sxtab16lo	r0, r0, r0
	sxtab16lo	r15, r15, r15

positive: sxtab16mi instruction

	sxtab16mi	r0, r0, r0
	sxtab16mi	r15, r15, r15

positive: sxtab16pl instruction

	sxtab16pl	r0, r0, r0
	sxtab16pl	r15, r15, r15

positive: sxtab16vs instruction

	sxtab16vs	r0, r0, r0
	sxtab16vs	r15, r15, r15

positive: sxtab16vc instruction

	sxtab16vc	r0, r0, r0
	sxtab16vc	r15, r15, r15

positive: sxtab16hi instruction

	sxtab16hi	r0, r0, r0
	sxtab16hi	r15, r15, r15

positive: sxtab16ls instruction

	sxtab16ls	r0, r0, r0
	sxtab16ls	r15, r15, r15

positive: sxtab16ge instruction

	sxtab16ge	r0, r0, r0
	sxtab16ge	r15, r15, r15

positive: sxtab16lt instruction

	sxtab16lt	r0, r0, r0
	sxtab16lt	r15, r15, r15

positive: sxtab16gt instruction

	sxtab16gt	r0, r0, r0
	sxtab16gt	r15, r15, r15

positive: sxtab16le instruction

	sxtab16le	r0, r0, r0
	sxtab16le	r15, r15, r15

positive: sxtab16al instruction

	sxtab16al	r0, r0, r0
	sxtab16al	r15, r15, r15

positive: sxtah instruction

	sxtah	r0, r0, r0
	sxtah	r15, r15, r15

positive: sxtaheq instruction

	sxtaheq	r0, r0, r0
	sxtaheq	r15, r15, r15

positive: sxtahne instruction

	sxtahne	r0, r0, r0
	sxtahne	r15, r15, r15

positive: sxtahcs instruction

	sxtahcs	r0, r0, r0
	sxtahcs	r15, r15, r15

positive: sxtahhs instruction

	sxtahhs	r0, r0, r0
	sxtahhs	r15, r15, r15

positive: sxtahcc instruction

	sxtahcc	r0, r0, r0
	sxtahcc	r15, r15, r15

positive: sxtahlo instruction

	sxtahlo	r0, r0, r0
	sxtahlo	r15, r15, r15

positive: sxtahmi instruction

	sxtahmi	r0, r0, r0
	sxtahmi	r15, r15, r15

positive: sxtahpl instruction

	sxtahpl	r0, r0, r0
	sxtahpl	r15, r15, r15

positive: sxtahvs instruction

	sxtahvs	r0, r0, r0
	sxtahvs	r15, r15, r15

positive: sxtahvc instruction

	sxtahvc	r0, r0, r0
	sxtahvc	r15, r15, r15

positive: sxtahhi instruction

	sxtahhi	r0, r0, r0
	sxtahhi	r15, r15, r15

positive: sxtahls instruction

	sxtahls	r0, r0, r0
	sxtahls	r15, r15, r15

positive: sxtahge instruction

	sxtahge	r0, r0, r0
	sxtahge	r15, r15, r15

positive: sxtahlt instruction

	sxtahlt	r0, r0, r0
	sxtahlt	r15, r15, r15

positive: sxtahgt instruction

	sxtahgt	r0, r0, r0
	sxtahgt	r15, r15, r15

positive: sxtahle instruction

	sxtahle	r0, r0, r0
	sxtahle	r15, r15, r15

positive: sxtahal instruction

	sxtahal	r0, r0, r0
	sxtahal	r15, r15, r15

positive: sxtb instruction

	sxtb	r0, r0
	sxtb	r15, r15

positive: sxtbeq instruction

	sxtbeq	r0, r0
	sxtbeq	r15, r15

positive: sxtbne instruction

	sxtbne	r0, r0
	sxtbne	r15, r15

positive: sxtbcs instruction

	sxtbcs	r0, r0
	sxtbcs	r15, r15

positive: sxtbhs instruction

	sxtbhs	r0, r0
	sxtbhs	r15, r15

positive: sxtbcc instruction

	sxtbcc	r0, r0
	sxtbcc	r15, r15

positive: sxtblo instruction

	sxtblo	r0, r0
	sxtblo	r15, r15

positive: sxtbmi instruction

	sxtbmi	r0, r0
	sxtbmi	r15, r15

positive: sxtbpl instruction

	sxtbpl	r0, r0
	sxtbpl	r15, r15

positive: sxtbvs instruction

	sxtbvs	r0, r0
	sxtbvs	r15, r15

positive: sxtbvc instruction

	sxtbvc	r0, r0
	sxtbvc	r15, r15

positive: sxtbhi instruction

	sxtbhi	r0, r0
	sxtbhi	r15, r15

positive: sxtbls instruction

	sxtbls	r0, r0
	sxtbls	r15, r15

positive: sxtbge instruction

	sxtbge	r0, r0
	sxtbge	r15, r15

positive: sxtblt instruction

	sxtblt	r0, r0
	sxtblt	r15, r15

positive: sxtbgt instruction

	sxtbgt	r0, r0
	sxtbgt	r15, r15

positive: sxtble instruction

	sxtble	r0, r0
	sxtble	r15, r15

positive: sxtbal instruction

	sxtbal	r0, r0
	sxtbal	r15, r15

positive: sxtb16 instruction

	sxtb16	r0, r0
	sxtb16	r15, r15

positive: sxtb16eq instruction

	sxtb16eq	r0, r0
	sxtb16eq	r15, r15

positive: sxtb16ne instruction

	sxtb16ne	r0, r0
	sxtb16ne	r15, r15

positive: sxtb16cs instruction

	sxtb16cs	r0, r0
	sxtb16cs	r15, r15

positive: sxtb16hs instruction

	sxtb16hs	r0, r0
	sxtb16hs	r15, r15

positive: sxtb16cc instruction

	sxtb16cc	r0, r0
	sxtb16cc	r15, r15

positive: sxtb16lo instruction

	sxtb16lo	r0, r0
	sxtb16lo	r15, r15

positive: sxtb16mi instruction

	sxtb16mi	r0, r0
	sxtb16mi	r15, r15

positive: sxtb16pl instruction

	sxtb16pl	r0, r0
	sxtb16pl	r15, r15

positive: sxtb16vs instruction

	sxtb16vs	r0, r0
	sxtb16vs	r15, r15

positive: sxtb16vc instruction

	sxtb16vc	r0, r0
	sxtb16vc	r15, r15

positive: sxtb16hi instruction

	sxtb16hi	r0, r0
	sxtb16hi	r15, r15

positive: sxtb16ls instruction

	sxtb16ls	r0, r0
	sxtb16ls	r15, r15

positive: sxtb16ge instruction

	sxtb16ge	r0, r0
	sxtb16ge	r15, r15

positive: sxtb16lt instruction

	sxtb16lt	r0, r0
	sxtb16lt	r15, r15

positive: sxtb16gt instruction

	sxtb16gt	r0, r0
	sxtb16gt	r15, r15

positive: sxtb16le instruction

	sxtb16le	r0, r0
	sxtb16le	r15, r15

positive: sxtb16al instruction

	sxtb16al	r0, r0
	sxtb16al	r15, r15

positive: sxth instruction

	sxth	r0, r0
	sxth	r15, r15

positive: sxtheq instruction

	sxtheq	r0, r0
	sxtheq	r15, r15

positive: sxthne instruction

	sxthne	r0, r0
	sxthne	r15, r15

positive: sxthcs instruction

	sxthcs	r0, r0
	sxthcs	r15, r15

positive: sxthhs instruction

	sxthhs	r0, r0
	sxthhs	r15, r15

positive: sxthcc instruction

	sxthcc	r0, r0
	sxthcc	r15, r15

positive: sxthlo instruction

	sxthlo	r0, r0
	sxthlo	r15, r15

positive: sxthmi instruction

	sxthmi	r0, r0
	sxthmi	r15, r15

positive: sxthpl instruction

	sxthpl	r0, r0
	sxthpl	r15, r15

positive: sxthvs instruction

	sxthvs	r0, r0
	sxthvs	r15, r15

positive: sxthvc instruction

	sxthvc	r0, r0
	sxthvc	r15, r15

positive: sxthhi instruction

	sxthhi	r0, r0
	sxthhi	r15, r15

positive: sxthls instruction

	sxthls	r0, r0
	sxthls	r15, r15

positive: sxthge instruction

	sxthge	r0, r0
	sxthge	r15, r15

positive: sxthlt instruction

	sxthlt	r0, r0
	sxthlt	r15, r15

positive: sxthgt instruction

	sxthgt	r0, r0
	sxthgt	r15, r15

positive: sxthle instruction

	sxthle	r0, r0
	sxthle	r15, r15

positive: sxthal instruction

	sxthal	r0, r0
	sxthal	r15, r15

positive: teq instruction

	teq	r0, 0
	teq	r15, 0xff000000
	teq	r0, r0
	teq	r15, r15
	teq	r0, r0, lsl 0
	teq	r15, r15, lsl 31
	teq	r0, r0, lsl r0
	teq	r15, r15, lsl r15
	teq	r0, r0, lsr 1
	teq	r15, r15, lsr 32
	teq	r0, r0, lsr r0
	teq	r15, r15, asr r15
	teq	r0, r0, asr 1
	teq	r15, r15, asr 32
	teq	r0, r0, asr r0
	teq	r15, r15, asr r15
	teq	r0, r0, ror 1
	teq	r15, r15, ror 31
	teq	r0, r0, ror r0
	teq	r15, r15, ror r15
	teq	r0, r0, rrx

positive: teqeq instruction

	teqeq	r0, 0
	teqeq	r15, 0xff000000
	teqeq	r0, r0
	teqeq	r15, r15
	teqeq	r0, r0, lsl 0
	teqeq	r15, r15, lsl 31
	teqeq	r0, r0, lsl r0
	teqeq	r15, r15, lsl r15
	teqeq	r0, r0, lsr 1
	teqeq	r15, r15, lsr 32
	teqeq	r0, r0, lsr r0
	teqeq	r15, r15, asr r15
	teqeq	r0, r0, asr 1
	teqeq	r15, r15, asr 32
	teqeq	r0, r0, asr r0
	teqeq	r15, r15, asr r15
	teqeq	r0, r0, ror 1
	teqeq	r15, r15, ror 31
	teqeq	r0, r0, ror r0
	teqeq	r15, r15, ror r15
	teqeq	r0, r0, rrx

positive: teqne instruction

	teqne	r0, 0
	teqne	r15, 0xff000000
	teqne	r0, r0
	teqne	r15, r15
	teqne	r0, r0, lsl 0
	teqne	r15, r15, lsl 31
	teqne	r0, r0, lsl r0
	teqne	r15, r15, lsl r15
	teqne	r0, r0, lsr 1
	teqne	r15, r15, lsr 32
	teqne	r0, r0, lsr r0
	teqne	r15, r15, asr r15
	teqne	r0, r0, asr 1
	teqne	r15, r15, asr 32
	teqne	r0, r0, asr r0
	teqne	r15, r15, asr r15
	teqne	r0, r0, ror 1
	teqne	r15, r15, ror 31
	teqne	r0, r0, ror r0
	teqne	r15, r15, ror r15
	teqne	r0, r0, rrx

positive: teqcs instruction

	teqcs	r0, 0
	teqcs	r15, 0xff000000
	teqcs	r0, r0
	teqcs	r15, r15
	teqcs	r0, r0, lsl 0
	teqcs	r15, r15, lsl 31
	teqcs	r0, r0, lsl r0
	teqcs	r15, r15, lsl r15
	teqcs	r0, r0, lsr 1
	teqcs	r15, r15, lsr 32
	teqcs	r0, r0, lsr r0
	teqcs	r15, r15, asr r15
	teqcs	r0, r0, asr 1
	teqcs	r15, r15, asr 32
	teqcs	r0, r0, asr r0
	teqcs	r15, r15, asr r15
	teqcs	r0, r0, ror 1
	teqcs	r15, r15, ror 31
	teqcs	r0, r0, ror r0
	teqcs	r15, r15, ror r15
	teqcs	r0, r0, rrx

positive: teqhs instruction

	teqhs	r0, 0
	teqhs	r15, 0xff000000
	teqhs	r0, r0
	teqhs	r15, r15
	teqhs	r0, r0, lsl 0
	teqhs	r15, r15, lsl 31
	teqhs	r0, r0, lsl r0
	teqhs	r15, r15, lsl r15
	teqhs	r0, r0, lsr 1
	teqhs	r15, r15, lsr 32
	teqhs	r0, r0, lsr r0
	teqhs	r15, r15, asr r15
	teqhs	r0, r0, asr 1
	teqhs	r15, r15, asr 32
	teqhs	r0, r0, asr r0
	teqhs	r15, r15, asr r15
	teqhs	r0, r0, ror 1
	teqhs	r15, r15, ror 31
	teqhs	r0, r0, ror r0
	teqhs	r15, r15, ror r15
	teqhs	r0, r0, rrx

positive: teqcc instruction

	teqcc	r0, 0
	teqcc	r15, 0xff000000
	teqcc	r0, r0
	teqcc	r15, r15
	teqcc	r0, r0, lsl 0
	teqcc	r15, r15, lsl 31
	teqcc	r0, r0, lsl r0
	teqcc	r15, r15, lsl r15
	teqcc	r0, r0, lsr 1
	teqcc	r15, r15, lsr 32
	teqcc	r0, r0, lsr r0
	teqcc	r15, r15, asr r15
	teqcc	r0, r0, asr 1
	teqcc	r15, r15, asr 32
	teqcc	r0, r0, asr r0
	teqcc	r15, r15, asr r15
	teqcc	r0, r0, ror 1
	teqcc	r15, r15, ror 31
	teqcc	r0, r0, ror r0
	teqcc	r15, r15, ror r15
	teqcc	r0, r0, rrx

positive: teqlo instruction

	teqlo	r0, 0
	teqlo	r15, 0xff000000
	teqlo	r0, r0
	teqlo	r15, r15
	teqlo	r0, r0, lsl 0
	teqlo	r15, r15, lsl 31
	teqlo	r0, r0, lsl r0
	teqlo	r15, r15, lsl r15
	teqlo	r0, r0, lsr 1
	teqlo	r15, r15, lsr 32
	teqlo	r0, r0, lsr r0
	teqlo	r15, r15, asr r15
	teqlo	r0, r0, asr 1
	teqlo	r15, r15, asr 32
	teqlo	r0, r0, asr r0
	teqlo	r15, r15, asr r15
	teqlo	r0, r0, ror 1
	teqlo	r15, r15, ror 31
	teqlo	r0, r0, ror r0
	teqlo	r15, r15, ror r15
	teqlo	r0, r0, rrx

positive: teqmi instruction

	teqmi	r0, 0
	teqmi	r15, 0xff000000
	teqmi	r0, r0
	teqmi	r15, r15
	teqmi	r0, r0, lsl 0
	teqmi	r15, r15, lsl 31
	teqmi	r0, r0, lsl r0
	teqmi	r15, r15, lsl r15
	teqmi	r0, r0, lsr 1
	teqmi	r15, r15, lsr 32
	teqmi	r0, r0, lsr r0
	teqmi	r15, r15, asr r15
	teqmi	r0, r0, asr 1
	teqmi	r15, r15, asr 32
	teqmi	r0, r0, asr r0
	teqmi	r15, r15, asr r15
	teqmi	r0, r0, ror 1
	teqmi	r15, r15, ror 31
	teqmi	r0, r0, ror r0
	teqmi	r15, r15, ror r15
	teqmi	r0, r0, rrx

positive: teqpl instruction

	teqpl	r0, 0
	teqpl	r15, 0xff000000
	teqpl	r0, r0
	teqpl	r15, r15
	teqpl	r0, r0, lsl 0
	teqpl	r15, r15, lsl 31
	teqpl	r0, r0, lsl r0
	teqpl	r15, r15, lsl r15
	teqpl	r0, r0, lsr 1
	teqpl	r15, r15, lsr 32
	teqpl	r0, r0, lsr r0
	teqpl	r15, r15, asr r15
	teqpl	r0, r0, asr 1
	teqpl	r15, r15, asr 32
	teqpl	r0, r0, asr r0
	teqpl	r15, r15, asr r15
	teqpl	r0, r0, ror 1
	teqpl	r15, r15, ror 31
	teqpl	r0, r0, ror r0
	teqpl	r15, r15, ror r15
	teqpl	r0, r0, rrx

positive: teqvs instruction

	teqvs	r0, 0
	teqvs	r15, 0xff000000
	teqvs	r0, r0
	teqvs	r15, r15
	teqvs	r0, r0, lsl 0
	teqvs	r15, r15, lsl 31
	teqvs	r0, r0, lsl r0
	teqvs	r15, r15, lsl r15
	teqvs	r0, r0, lsr 1
	teqvs	r15, r15, lsr 32
	teqvs	r0, r0, lsr r0
	teqvs	r15, r15, asr r15
	teqvs	r0, r0, asr 1
	teqvs	r15, r15, asr 32
	teqvs	r0, r0, asr r0
	teqvs	r15, r15, asr r15
	teqvs	r0, r0, ror 1
	teqvs	r15, r15, ror 31
	teqvs	r0, r0, ror r0
	teqvs	r15, r15, ror r15
	teqvs	r0, r0, rrx

positive: teqvc instruction

	teqvc	r0, 0
	teqvc	r15, 0xff000000
	teqvc	r0, r0
	teqvc	r15, r15
	teqvc	r0, r0, lsl 0
	teqvc	r15, r15, lsl 31
	teqvc	r0, r0, lsl r0
	teqvc	r15, r15, lsl r15
	teqvc	r0, r0, lsr 1
	teqvc	r15, r15, lsr 32
	teqvc	r0, r0, lsr r0
	teqvc	r15, r15, asr r15
	teqvc	r0, r0, asr 1
	teqvc	r15, r15, asr 32
	teqvc	r0, r0, asr r0
	teqvc	r15, r15, asr r15
	teqvc	r0, r0, ror 1
	teqvc	r15, r15, ror 31
	teqvc	r0, r0, ror r0
	teqvc	r15, r15, ror r15
	teqvc	r0, r0, rrx

positive: teqhi instruction

	teqhi	r0, 0
	teqhi	r15, 0xff000000
	teqhi	r0, r0
	teqhi	r15, r15
	teqhi	r0, r0, lsl 0
	teqhi	r15, r15, lsl 31
	teqhi	r0, r0, lsl r0
	teqhi	r15, r15, lsl r15
	teqhi	r0, r0, lsr 1
	teqhi	r15, r15, lsr 32
	teqhi	r0, r0, lsr r0
	teqhi	r15, r15, asr r15
	teqhi	r0, r0, asr 1
	teqhi	r15, r15, asr 32
	teqhi	r0, r0, asr r0
	teqhi	r15, r15, asr r15
	teqhi	r0, r0, ror 1
	teqhi	r15, r15, ror 31
	teqhi	r0, r0, ror r0
	teqhi	r15, r15, ror r15
	teqhi	r0, r0, rrx

positive: teqls instruction

	teqls	r0, 0
	teqls	r15, 0xff000000
	teqls	r0, r0
	teqls	r15, r15
	teqls	r0, r0, lsl 0
	teqls	r15, r15, lsl 31
	teqls	r0, r0, lsl r0
	teqls	r15, r15, lsl r15
	teqls	r0, r0, lsr 1
	teqls	r15, r15, lsr 32
	teqls	r0, r0, lsr r0
	teqls	r15, r15, asr r15
	teqls	r0, r0, asr 1
	teqls	r15, r15, asr 32
	teqls	r0, r0, asr r0
	teqls	r15, r15, asr r15
	teqls	r0, r0, ror 1
	teqls	r15, r15, ror 31
	teqls	r0, r0, ror r0
	teqls	r15, r15, ror r15
	teqls	r0, r0, rrx

positive: teqge instruction

	teqge	r0, 0
	teqge	r15, 0xff000000
	teqge	r0, r0
	teqge	r15, r15
	teqge	r0, r0, lsl 0
	teqge	r15, r15, lsl 31
	teqge	r0, r0, lsl r0
	teqge	r15, r15, lsl r15
	teqge	r0, r0, lsr 1
	teqge	r15, r15, lsr 32
	teqge	r0, r0, lsr r0
	teqge	r15, r15, asr r15
	teqge	r0, r0, asr 1
	teqge	r15, r15, asr 32
	teqge	r0, r0, asr r0
	teqge	r15, r15, asr r15
	teqge	r0, r0, ror 1
	teqge	r15, r15, ror 31
	teqge	r0, r0, ror r0
	teqge	r15, r15, ror r15
	teqge	r0, r0, rrx

positive: teqlt instruction

	teqlt	r0, 0
	teqlt	r15, 0xff000000
	teqlt	r0, r0
	teqlt	r15, r15
	teqlt	r0, r0, lsl 0
	teqlt	r15, r15, lsl 31
	teqlt	r0, r0, lsl r0
	teqlt	r15, r15, lsl r15
	teqlt	r0, r0, lsr 1
	teqlt	r15, r15, lsr 32
	teqlt	r0, r0, lsr r0
	teqlt	r15, r15, asr r15
	teqlt	r0, r0, asr 1
	teqlt	r15, r15, asr 32
	teqlt	r0, r0, asr r0
	teqlt	r15, r15, asr r15
	teqlt	r0, r0, ror 1
	teqlt	r15, r15, ror 31
	teqlt	r0, r0, ror r0
	teqlt	r15, r15, ror r15
	teqlt	r0, r0, rrx

positive: teqgt instruction

	teqgt	r0, 0
	teqgt	r15, 0xff000000
	teqgt	r0, r0
	teqgt	r15, r15
	teqgt	r0, r0, lsl 0
	teqgt	r15, r15, lsl 31
	teqgt	r0, r0, lsl r0
	teqgt	r15, r15, lsl r15
	teqgt	r0, r0, lsr 1
	teqgt	r15, r15, lsr 32
	teqgt	r0, r0, lsr r0
	teqgt	r15, r15, asr r15
	teqgt	r0, r0, asr 1
	teqgt	r15, r15, asr 32
	teqgt	r0, r0, asr r0
	teqgt	r15, r15, asr r15
	teqgt	r0, r0, ror 1
	teqgt	r15, r15, ror 31
	teqgt	r0, r0, ror r0
	teqgt	r15, r15, ror r15
	teqgt	r0, r0, rrx

positive: teqle instruction

	teqle	r0, 0
	teqle	r15, 0xff000000
	teqle	r0, r0
	teqle	r15, r15
	teqle	r0, r0, lsl 0
	teqle	r15, r15, lsl 31
	teqle	r0, r0, lsl r0
	teqle	r15, r15, lsl r15
	teqle	r0, r0, lsr 1
	teqle	r15, r15, lsr 32
	teqle	r0, r0, lsr r0
	teqle	r15, r15, asr r15
	teqle	r0, r0, asr 1
	teqle	r15, r15, asr 32
	teqle	r0, r0, asr r0
	teqle	r15, r15, asr r15
	teqle	r0, r0, ror 1
	teqle	r15, r15, ror 31
	teqle	r0, r0, ror r0
	teqle	r15, r15, ror r15
	teqle	r0, r0, rrx

positive: teqal instruction

	teqal	r0, 0
	teqal	r15, 0xff000000
	teqal	r0, r0
	teqal	r15, r15
	teqal	r0, r0, lsl 0
	teqal	r15, r15, lsl 31
	teqal	r0, r0, lsl r0
	teqal	r15, r15, lsl r15
	teqal	r0, r0, lsr 1
	teqal	r15, r15, lsr 32
	teqal	r0, r0, lsr r0
	teqal	r15, r15, asr r15
	teqal	r0, r0, asr 1
	teqal	r15, r15, asr 32
	teqal	r0, r0, asr r0
	teqal	r15, r15, asr r15
	teqal	r0, r0, ror 1
	teqal	r15, r15, ror 31
	teqal	r0, r0, ror r0
	teqal	r15, r15, ror r15
	teqal	r0, r0, rrx

positive: tst instruction

	tst	r0, 0
	tst	r15, 0xff000000
	tst	r0, r0
	tst	r15, r15
	tst	r0, r0, lsl 0
	tst	r15, r15, lsl 31
	tst	r0, r0, lsl r0
	tst	r15, r15, lsl r15
	tst	r0, r0, lsr 1
	tst	r15, r15, lsr 32
	tst	r0, r0, lsr r0
	tst	r15, r15, asr r15
	tst	r0, r0, asr 1
	tst	r15, r15, asr 32
	tst	r0, r0, asr r0
	tst	r15, r15, asr r15
	tst	r0, r0, ror 1
	tst	r15, r15, ror 31
	tst	r0, r0, ror r0
	tst	r15, r15, ror r15
	tst	r0, r0, rrx

positive: tsteq instruction

	tsteq	r0, 0
	tsteq	r15, 0xff000000
	tsteq	r0, r0
	tsteq	r15, r15
	tsteq	r0, r0, lsl 0
	tsteq	r15, r15, lsl 31
	tsteq	r0, r0, lsl r0
	tsteq	r15, r15, lsl r15
	tsteq	r0, r0, lsr 1
	tsteq	r15, r15, lsr 32
	tsteq	r0, r0, lsr r0
	tsteq	r15, r15, asr r15
	tsteq	r0, r0, asr 1
	tsteq	r15, r15, asr 32
	tsteq	r0, r0, asr r0
	tsteq	r15, r15, asr r15
	tsteq	r0, r0, ror 1
	tsteq	r15, r15, ror 31
	tsteq	r0, r0, ror r0
	tsteq	r15, r15, ror r15
	tsteq	r0, r0, rrx

positive: tstne instruction

	tstne	r0, 0
	tstne	r15, 0xff000000
	tstne	r0, r0
	tstne	r15, r15
	tstne	r0, r0, lsl 0
	tstne	r15, r15, lsl 31
	tstne	r0, r0, lsl r0
	tstne	r15, r15, lsl r15
	tstne	r0, r0, lsr 1
	tstne	r15, r15, lsr 32
	tstne	r0, r0, lsr r0
	tstne	r15, r15, asr r15
	tstne	r0, r0, asr 1
	tstne	r15, r15, asr 32
	tstne	r0, r0, asr r0
	tstne	r15, r15, asr r15
	tstne	r0, r0, ror 1
	tstne	r15, r15, ror 31
	tstne	r0, r0, ror r0
	tstne	r15, r15, ror r15
	tstne	r0, r0, rrx

positive: tstcs instruction

	tstcs	r0, 0
	tstcs	r15, 0xff000000
	tstcs	r0, r0
	tstcs	r15, r15
	tstcs	r0, r0, lsl 0
	tstcs	r15, r15, lsl 31
	tstcs	r0, r0, lsl r0
	tstcs	r15, r15, lsl r15
	tstcs	r0, r0, lsr 1
	tstcs	r15, r15, lsr 32
	tstcs	r0, r0, lsr r0
	tstcs	r15, r15, asr r15
	tstcs	r0, r0, asr 1
	tstcs	r15, r15, asr 32
	tstcs	r0, r0, asr r0
	tstcs	r15, r15, asr r15
	tstcs	r0, r0, ror 1
	tstcs	r15, r15, ror 31
	tstcs	r0, r0, ror r0
	tstcs	r15, r15, ror r15
	tstcs	r0, r0, rrx

positive: tsths instruction

	tsths	r0, 0
	tsths	r15, 0xff000000
	tsths	r0, r0
	tsths	r15, r15
	tsths	r0, r0, lsl 0
	tsths	r15, r15, lsl 31
	tsths	r0, r0, lsl r0
	tsths	r15, r15, lsl r15
	tsths	r0, r0, lsr 1
	tsths	r15, r15, lsr 32
	tsths	r0, r0, lsr r0
	tsths	r15, r15, asr r15
	tsths	r0, r0, asr 1
	tsths	r15, r15, asr 32
	tsths	r0, r0, asr r0
	tsths	r15, r15, asr r15
	tsths	r0, r0, ror 1
	tsths	r15, r15, ror 31
	tsths	r0, r0, ror r0
	tsths	r15, r15, ror r15
	tsths	r0, r0, rrx

positive: tstcc instruction

	tstcc	r0, 0
	tstcc	r15, 0xff000000
	tstcc	r0, r0
	tstcc	r15, r15
	tstcc	r0, r0, lsl 0
	tstcc	r15, r15, lsl 31
	tstcc	r0, r0, lsl r0
	tstcc	r15, r15, lsl r15
	tstcc	r0, r0, lsr 1
	tstcc	r15, r15, lsr 32
	tstcc	r0, r0, lsr r0
	tstcc	r15, r15, asr r15
	tstcc	r0, r0, asr 1
	tstcc	r15, r15, asr 32
	tstcc	r0, r0, asr r0
	tstcc	r15, r15, asr r15
	tstcc	r0, r0, ror 1
	tstcc	r15, r15, ror 31
	tstcc	r0, r0, ror r0
	tstcc	r15, r15, ror r15
	tstcc	r0, r0, rrx

positive: tstlo instruction

	tstlo	r0, 0
	tstlo	r15, 0xff000000
	tstlo	r0, r0
	tstlo	r15, r15
	tstlo	r0, r0, lsl 0
	tstlo	r15, r15, lsl 31
	tstlo	r0, r0, lsl r0
	tstlo	r15, r15, lsl r15
	tstlo	r0, r0, lsr 1
	tstlo	r15, r15, lsr 32
	tstlo	r0, r0, lsr r0
	tstlo	r15, r15, asr r15
	tstlo	r0, r0, asr 1
	tstlo	r15, r15, asr 32
	tstlo	r0, r0, asr r0
	tstlo	r15, r15, asr r15
	tstlo	r0, r0, ror 1
	tstlo	r15, r15, ror 31
	tstlo	r0, r0, ror r0
	tstlo	r15, r15, ror r15
	tstlo	r0, r0, rrx

positive: tstmi instruction

	tstmi	r0, 0
	tstmi	r15, 0xff000000
	tstmi	r0, r0
	tstmi	r15, r15
	tstmi	r0, r0, lsl 0
	tstmi	r15, r15, lsl 31
	tstmi	r0, r0, lsl r0
	tstmi	r15, r15, lsl r15
	tstmi	r0, r0, lsr 1
	tstmi	r15, r15, lsr 32
	tstmi	r0, r0, lsr r0
	tstmi	r15, r15, asr r15
	tstmi	r0, r0, asr 1
	tstmi	r15, r15, asr 32
	tstmi	r0, r0, asr r0
	tstmi	r15, r15, asr r15
	tstmi	r0, r0, ror 1
	tstmi	r15, r15, ror 31
	tstmi	r0, r0, ror r0
	tstmi	r15, r15, ror r15
	tstmi	r0, r0, rrx

positive: tstpl instruction

	tstpl	r0, 0
	tstpl	r15, 0xff000000
	tstpl	r0, r0
	tstpl	r15, r15
	tstpl	r0, r0, lsl 0
	tstpl	r15, r15, lsl 31
	tstpl	r0, r0, lsl r0
	tstpl	r15, r15, lsl r15
	tstpl	r0, r0, lsr 1
	tstpl	r15, r15, lsr 32
	tstpl	r0, r0, lsr r0
	tstpl	r15, r15, asr r15
	tstpl	r0, r0, asr 1
	tstpl	r15, r15, asr 32
	tstpl	r0, r0, asr r0
	tstpl	r15, r15, asr r15
	tstpl	r0, r0, ror 1
	tstpl	r15, r15, ror 31
	tstpl	r0, r0, ror r0
	tstpl	r15, r15, ror r15
	tstpl	r0, r0, rrx

positive: tstvs instruction

	tstvs	r0, 0
	tstvs	r15, 0xff000000
	tstvs	r0, r0
	tstvs	r15, r15
	tstvs	r0, r0, lsl 0
	tstvs	r15, r15, lsl 31
	tstvs	r0, r0, lsl r0
	tstvs	r15, r15, lsl r15
	tstvs	r0, r0, lsr 1
	tstvs	r15, r15, lsr 32
	tstvs	r0, r0, lsr r0
	tstvs	r15, r15, asr r15
	tstvs	r0, r0, asr 1
	tstvs	r15, r15, asr 32
	tstvs	r0, r0, asr r0
	tstvs	r15, r15, asr r15
	tstvs	r0, r0, ror 1
	tstvs	r15, r15, ror 31
	tstvs	r0, r0, ror r0
	tstvs	r15, r15, ror r15
	tstvs	r0, r0, rrx

positive: tstvc instruction

	tstvc	r0, 0
	tstvc	r15, 0xff000000
	tstvc	r0, r0
	tstvc	r15, r15
	tstvc	r0, r0, lsl 0
	tstvc	r15, r15, lsl 31
	tstvc	r0, r0, lsl r0
	tstvc	r15, r15, lsl r15
	tstvc	r0, r0, lsr 1
	tstvc	r15, r15, lsr 32
	tstvc	r0, r0, lsr r0
	tstvc	r15, r15, asr r15
	tstvc	r0, r0, asr 1
	tstvc	r15, r15, asr 32
	tstvc	r0, r0, asr r0
	tstvc	r15, r15, asr r15
	tstvc	r0, r0, ror 1
	tstvc	r15, r15, ror 31
	tstvc	r0, r0, ror r0
	tstvc	r15, r15, ror r15
	tstvc	r0, r0, rrx

positive: tsthi instruction

	tsthi	r0, 0
	tsthi	r15, 0xff000000
	tsthi	r0, r0
	tsthi	r15, r15
	tsthi	r0, r0, lsl 0
	tsthi	r15, r15, lsl 31
	tsthi	r0, r0, lsl r0
	tsthi	r15, r15, lsl r15
	tsthi	r0, r0, lsr 1
	tsthi	r15, r15, lsr 32
	tsthi	r0, r0, lsr r0
	tsthi	r15, r15, asr r15
	tsthi	r0, r0, asr 1
	tsthi	r15, r15, asr 32
	tsthi	r0, r0, asr r0
	tsthi	r15, r15, asr r15
	tsthi	r0, r0, ror 1
	tsthi	r15, r15, ror 31
	tsthi	r0, r0, ror r0
	tsthi	r15, r15, ror r15
	tsthi	r0, r0, rrx

positive: tstls instruction

	tstls	r0, 0
	tstls	r15, 0xff000000
	tstls	r0, r0
	tstls	r15, r15
	tstls	r0, r0, lsl 0
	tstls	r15, r15, lsl 31
	tstls	r0, r0, lsl r0
	tstls	r15, r15, lsl r15
	tstls	r0, r0, lsr 1
	tstls	r15, r15, lsr 32
	tstls	r0, r0, lsr r0
	tstls	r15, r15, asr r15
	tstls	r0, r0, asr 1
	tstls	r15, r15, asr 32
	tstls	r0, r0, asr r0
	tstls	r15, r15, asr r15
	tstls	r0, r0, ror 1
	tstls	r15, r15, ror 31
	tstls	r0, r0, ror r0
	tstls	r15, r15, ror r15
	tstls	r0, r0, rrx

positive: tstge instruction

	tstge	r0, 0
	tstge	r15, 0xff000000
	tstge	r0, r0
	tstge	r15, r15
	tstge	r0, r0, lsl 0
	tstge	r15, r15, lsl 31
	tstge	r0, r0, lsl r0
	tstge	r15, r15, lsl r15
	tstge	r0, r0, lsr 1
	tstge	r15, r15, lsr 32
	tstge	r0, r0, lsr r0
	tstge	r15, r15, asr r15
	tstge	r0, r0, asr 1
	tstge	r15, r15, asr 32
	tstge	r0, r0, asr r0
	tstge	r15, r15, asr r15
	tstge	r0, r0, ror 1
	tstge	r15, r15, ror 31
	tstge	r0, r0, ror r0
	tstge	r15, r15, ror r15
	tstge	r0, r0, rrx

positive: tstlt instruction

	tstlt	r0, 0
	tstlt	r15, 0xff000000
	tstlt	r0, r0
	tstlt	r15, r15
	tstlt	r0, r0, lsl 0
	tstlt	r15, r15, lsl 31
	tstlt	r0, r0, lsl r0
	tstlt	r15, r15, lsl r15
	tstlt	r0, r0, lsr 1
	tstlt	r15, r15, lsr 32
	tstlt	r0, r0, lsr r0
	tstlt	r15, r15, asr r15
	tstlt	r0, r0, asr 1
	tstlt	r15, r15, asr 32
	tstlt	r0, r0, asr r0
	tstlt	r15, r15, asr r15
	tstlt	r0, r0, ror 1
	tstlt	r15, r15, ror 31
	tstlt	r0, r0, ror r0
	tstlt	r15, r15, ror r15
	tstlt	r0, r0, rrx

positive: tstgt instruction

	tstgt	r0, 0
	tstgt	r15, 0xff000000
	tstgt	r0, r0
	tstgt	r15, r15
	tstgt	r0, r0, lsl 0
	tstgt	r15, r15, lsl 31
	tstgt	r0, r0, lsl r0
	tstgt	r15, r15, lsl r15
	tstgt	r0, r0, lsr 1
	tstgt	r15, r15, lsr 32
	tstgt	r0, r0, lsr r0
	tstgt	r15, r15, asr r15
	tstgt	r0, r0, asr 1
	tstgt	r15, r15, asr 32
	tstgt	r0, r0, asr r0
	tstgt	r15, r15, asr r15
	tstgt	r0, r0, ror 1
	tstgt	r15, r15, ror 31
	tstgt	r0, r0, ror r0
	tstgt	r15, r15, ror r15
	tstgt	r0, r0, rrx

positive: tstle instruction

	tstle	r0, 0
	tstle	r15, 0xff000000
	tstle	r0, r0
	tstle	r15, r15
	tstle	r0, r0, lsl 0
	tstle	r15, r15, lsl 31
	tstle	r0, r0, lsl r0
	tstle	r15, r15, lsl r15
	tstle	r0, r0, lsr 1
	tstle	r15, r15, lsr 32
	tstle	r0, r0, lsr r0
	tstle	r15, r15, asr r15
	tstle	r0, r0, asr 1
	tstle	r15, r15, asr 32
	tstle	r0, r0, asr r0
	tstle	r15, r15, asr r15
	tstle	r0, r0, ror 1
	tstle	r15, r15, ror 31
	tstle	r0, r0, ror r0
	tstle	r15, r15, ror r15
	tstle	r0, r0, rrx

positive: tstal instruction

	tstal	r0, 0
	tstal	r15, 0xff000000
	tstal	r0, r0
	tstal	r15, r15
	tstal	r0, r0, lsl 0
	tstal	r15, r15, lsl 31
	tstal	r0, r0, lsl r0
	tstal	r15, r15, lsl r15
	tstal	r0, r0, lsr 1
	tstal	r15, r15, lsr 32
	tstal	r0, r0, lsr r0
	tstal	r15, r15, asr r15
	tstal	r0, r0, asr 1
	tstal	r15, r15, asr 32
	tstal	r0, r0, asr r0
	tstal	r15, r15, asr r15
	tstal	r0, r0, ror 1
	tstal	r15, r15, ror 31
	tstal	r0, r0, ror r0
	tstal	r15, r15, ror r15
	tstal	r0, r0, rrx

positive: uadd16 instruction

	uadd16	r0, r0, r0
	uadd16	r15, r15, r15

positive: uadd16eq instruction

	uadd16eq	r0, r0, r0
	uadd16eq	r15, r15, r15

positive: uadd16ne instruction

	uadd16ne	r0, r0, r0
	uadd16ne	r15, r15, r15

positive: uadd16cs instruction

	uadd16cs	r0, r0, r0
	uadd16cs	r15, r15, r15

positive: uadd16hs instruction

	uadd16hs	r0, r0, r0
	uadd16hs	r15, r15, r15

positive: uadd16cc instruction

	uadd16cc	r0, r0, r0
	uadd16cc	r15, r15, r15

positive: uadd16lo instruction

	uadd16lo	r0, r0, r0
	uadd16lo	r15, r15, r15

positive: uadd16mi instruction

	uadd16mi	r0, r0, r0
	uadd16mi	r15, r15, r15

positive: uadd16pl instruction

	uadd16pl	r0, r0, r0
	uadd16pl	r15, r15, r15

positive: uadd16vs instruction

	uadd16vs	r0, r0, r0
	uadd16vs	r15, r15, r15

positive: uadd16vc instruction

	uadd16vc	r0, r0, r0
	uadd16vc	r15, r15, r15

positive: uadd16hi instruction

	uadd16hi	r0, r0, r0
	uadd16hi	r15, r15, r15

positive: uadd16ls instruction

	uadd16ls	r0, r0, r0
	uadd16ls	r15, r15, r15

positive: uadd16ge instruction

	uadd16ge	r0, r0, r0
	uadd16ge	r15, r15, r15

positive: uadd16lt instruction

	uadd16lt	r0, r0, r0
	uadd16lt	r15, r15, r15

positive: uadd16gt instruction

	uadd16gt	r0, r0, r0
	uadd16gt	r15, r15, r15

positive: uadd16le instruction

	uadd16le	r0, r0, r0
	uadd16le	r15, r15, r15

positive: uadd16al instruction

	uadd16al	r0, r0, r0
	uadd16al	r15, r15, r15

positive: uadd8 instruction

	uadd8	r0, r0, r0
	uadd8	r15, r15, r15

positive: uadd8eq instruction

	uadd8eq	r0, r0, r0
	uadd8eq	r15, r15, r15

positive: uadd8ne instruction

	uadd8ne	r0, r0, r0
	uadd8ne	r15, r15, r15

positive: uadd8cs instruction

	uadd8cs	r0, r0, r0
	uadd8cs	r15, r15, r15

positive: uadd8hs instruction

	uadd8hs	r0, r0, r0
	uadd8hs	r15, r15, r15

positive: uadd8cc instruction

	uadd8cc	r0, r0, r0
	uadd8cc	r15, r15, r15

positive: uadd8lo instruction

	uadd8lo	r0, r0, r0
	uadd8lo	r15, r15, r15

positive: uadd8mi instruction

	uadd8mi	r0, r0, r0
	uadd8mi	r15, r15, r15

positive: uadd8pl instruction

	uadd8pl	r0, r0, r0
	uadd8pl	r15, r15, r15

positive: uadd8vs instruction

	uadd8vs	r0, r0, r0
	uadd8vs	r15, r15, r15

positive: uadd8vc instruction

	uadd8vc	r0, r0, r0
	uadd8vc	r15, r15, r15

positive: uadd8hi instruction

	uadd8hi	r0, r0, r0
	uadd8hi	r15, r15, r15

positive: uadd8ls instruction

	uadd8ls	r0, r0, r0
	uadd8ls	r15, r15, r15

positive: uadd8ge instruction

	uadd8ge	r0, r0, r0
	uadd8ge	r15, r15, r15

positive: uadd8lt instruction

	uadd8lt	r0, r0, r0
	uadd8lt	r15, r15, r15

positive: uadd8gt instruction

	uadd8gt	r0, r0, r0
	uadd8gt	r15, r15, r15

positive: uadd8le instruction

	uadd8le	r0, r0, r0
	uadd8le	r15, r15, r15

positive: uadd8al instruction

	uadd8al	r0, r0, r0
	uadd8al	r15, r15, r15

positive: uaddsubx instruction

	uaddsubx	r0, r0, r0
	uaddsubx	r15, r15, r15

positive: uaddsubxeq instruction

	uaddsubxeq	r0, r0, r0
	uaddsubxeq	r15, r15, r15

positive: uaddsubxne instruction

	uaddsubxne	r0, r0, r0
	uaddsubxne	r15, r15, r15

positive: uaddsubxcs instruction

	uaddsubxcs	r0, r0, r0
	uaddsubxcs	r15, r15, r15

positive: uaddsubxhs instruction

	uaddsubxhs	r0, r0, r0
	uaddsubxhs	r15, r15, r15

positive: uaddsubxcc instruction

	uaddsubxcc	r0, r0, r0
	uaddsubxcc	r15, r15, r15

positive: uaddsubxlo instruction

	uaddsubxlo	r0, r0, r0
	uaddsubxlo	r15, r15, r15

positive: uaddsubxmi instruction

	uaddsubxmi	r0, r0, r0
	uaddsubxmi	r15, r15, r15

positive: uaddsubxpl instruction

	uaddsubxpl	r0, r0, r0
	uaddsubxpl	r15, r15, r15

positive: uaddsubxvs instruction

	uaddsubxvs	r0, r0, r0
	uaddsubxvs	r15, r15, r15

positive: uaddsubxvc instruction

	uaddsubxvc	r0, r0, r0
	uaddsubxvc	r15, r15, r15

positive: uaddsubxhi instruction

	uaddsubxhi	r0, r0, r0
	uaddsubxhi	r15, r15, r15

positive: uaddsubxls instruction

	uaddsubxls	r0, r0, r0
	uaddsubxls	r15, r15, r15

positive: uaddsubxge instruction

	uaddsubxge	r0, r0, r0
	uaddsubxge	r15, r15, r15

positive: uaddsubxlt instruction

	uaddsubxlt	r0, r0, r0
	uaddsubxlt	r15, r15, r15

positive: uaddsubxgt instruction

	uaddsubxgt	r0, r0, r0
	uaddsubxgt	r15, r15, r15

positive: uaddsubxle instruction

	uaddsubxle	r0, r0, r0
	uaddsubxle	r15, r15, r15

positive: uaddsubxal instruction

	uaddsubxal	r0, r0, r0
	uaddsubxal	r15, r15, r15

positive: udf instruction

	udf	0
	udf	65535

positive: uhadd16 instruction

	uhadd16	r0, r0, r0
	uhadd16	r15, r15, r15

positive: uhadd16eq instruction

	uhadd16eq	r0, r0, r0
	uhadd16eq	r15, r15, r15

positive: uhadd16ne instruction

	uhadd16ne	r0, r0, r0
	uhadd16ne	r15, r15, r15

positive: uhadd16cs instruction

	uhadd16cs	r0, r0, r0
	uhadd16cs	r15, r15, r15

positive: uhadd16hs instruction

	uhadd16hs	r0, r0, r0
	uhadd16hs	r15, r15, r15

positive: uhadd16cc instruction

	uhadd16cc	r0, r0, r0
	uhadd16cc	r15, r15, r15

positive: uhadd16lo instruction

	uhadd16lo	r0, r0, r0
	uhadd16lo	r15, r15, r15

positive: uhadd16mi instruction

	uhadd16mi	r0, r0, r0
	uhadd16mi	r15, r15, r15

positive: uhadd16pl instruction

	uhadd16pl	r0, r0, r0
	uhadd16pl	r15, r15, r15

positive: uhadd16vs instruction

	uhadd16vs	r0, r0, r0
	uhadd16vs	r15, r15, r15

positive: uhadd16vc instruction

	uhadd16vc	r0, r0, r0
	uhadd16vc	r15, r15, r15

positive: uhadd16hi instruction

	uhadd16hi	r0, r0, r0
	uhadd16hi	r15, r15, r15

positive: uhadd16ls instruction

	uhadd16ls	r0, r0, r0
	uhadd16ls	r15, r15, r15

positive: uhadd16ge instruction

	uhadd16ge	r0, r0, r0
	uhadd16ge	r15, r15, r15

positive: uhadd16lt instruction

	uhadd16lt	r0, r0, r0
	uhadd16lt	r15, r15, r15

positive: uhadd16gt instruction

	uhadd16gt	r0, r0, r0
	uhadd16gt	r15, r15, r15

positive: uhadd16le instruction

	uhadd16le	r0, r0, r0
	uhadd16le	r15, r15, r15

positive: uhadd16al instruction

	uhadd16al	r0, r0, r0
	uhadd16al	r15, r15, r15

positive: uhadd8 instruction

	uhadd8	r0, r0, r0
	uhadd8	r15, r15, r15

positive: uhadd8eq instruction

	uhadd8eq	r0, r0, r0
	uhadd8eq	r15, r15, r15

positive: uhadd8ne instruction

	uhadd8ne	r0, r0, r0
	uhadd8ne	r15, r15, r15

positive: uhadd8cs instruction

	uhadd8cs	r0, r0, r0
	uhadd8cs	r15, r15, r15

positive: uhadd8hs instruction

	uhadd8hs	r0, r0, r0
	uhadd8hs	r15, r15, r15

positive: uhadd8cc instruction

	uhadd8cc	r0, r0, r0
	uhadd8cc	r15, r15, r15

positive: uhadd8lo instruction

	uhadd8lo	r0, r0, r0
	uhadd8lo	r15, r15, r15

positive: uhadd8mi instruction

	uhadd8mi	r0, r0, r0
	uhadd8mi	r15, r15, r15

positive: uhadd8pl instruction

	uhadd8pl	r0, r0, r0
	uhadd8pl	r15, r15, r15

positive: uhadd8vs instruction

	uhadd8vs	r0, r0, r0
	uhadd8vs	r15, r15, r15

positive: uhadd8vc instruction

	uhadd8vc	r0, r0, r0
	uhadd8vc	r15, r15, r15

positive: uhadd8hi instruction

	uhadd8hi	r0, r0, r0
	uhadd8hi	r15, r15, r15

positive: uhadd8ls instruction

	uhadd8ls	r0, r0, r0
	uhadd8ls	r15, r15, r15

positive: uhadd8ge instruction

	uhadd8ge	r0, r0, r0
	uhadd8ge	r15, r15, r15

positive: uhadd8lt instruction

	uhadd8lt	r0, r0, r0
	uhadd8lt	r15, r15, r15

positive: uhadd8gt instruction

	uhadd8gt	r0, r0, r0
	uhadd8gt	r15, r15, r15

positive: uhadd8le instruction

	uhadd8le	r0, r0, r0
	uhadd8le	r15, r15, r15

positive: uhadd8al instruction

	uhadd8al	r0, r0, r0
	uhadd8al	r15, r15, r15

positive: uhaddsubx instruction

	uhaddsubx	r0, r0, r0
	uhaddsubx	r15, r15, r15

positive: uhaddsubxeq instruction

	uhaddsubxeq	r0, r0, r0
	uhaddsubxeq	r15, r15, r15

positive: uhaddsubxne instruction

	uhaddsubxne	r0, r0, r0
	uhaddsubxne	r15, r15, r15

positive: uhaddsubxcs instruction

	uhaddsubxcs	r0, r0, r0
	uhaddsubxcs	r15, r15, r15

positive: uhaddsubxhs instruction

	uhaddsubxhs	r0, r0, r0
	uhaddsubxhs	r15, r15, r15

positive: uhaddsubxcc instruction

	uhaddsubxcc	r0, r0, r0
	uhaddsubxcc	r15, r15, r15

positive: uhaddsubxlo instruction

	uhaddsubxlo	r0, r0, r0
	uhaddsubxlo	r15, r15, r15

positive: uhaddsubxmi instruction

	uhaddsubxmi	r0, r0, r0
	uhaddsubxmi	r15, r15, r15

positive: uhaddsubxpl instruction

	uhaddsubxpl	r0, r0, r0
	uhaddsubxpl	r15, r15, r15

positive: uhaddsubxvs instruction

	uhaddsubxvs	r0, r0, r0
	uhaddsubxvs	r15, r15, r15

positive: uhaddsubxvc instruction

	uhaddsubxvc	r0, r0, r0
	uhaddsubxvc	r15, r15, r15

positive: uhaddsubxhi instruction

	uhaddsubxhi	r0, r0, r0
	uhaddsubxhi	r15, r15, r15

positive: uhaddsubxls instruction

	uhaddsubxls	r0, r0, r0
	uhaddsubxls	r15, r15, r15

positive: uhaddsubxge instruction

	uhaddsubxge	r0, r0, r0
	uhaddsubxge	r15, r15, r15

positive: uhaddsubxlt instruction

	uhaddsubxlt	r0, r0, r0
	uhaddsubxlt	r15, r15, r15

positive: uhaddsubxgt instruction

	uhaddsubxgt	r0, r0, r0
	uhaddsubxgt	r15, r15, r15

positive: uhaddsubxle instruction

	uhaddsubxle	r0, r0, r0
	uhaddsubxle	r15, r15, r15

positive: uhaddsubxal instruction

	uhaddsubxal	r0, r0, r0
	uhaddsubxal	r15, r15, r15

positive: uhsub16 instruction

	uhsub16	r0, r0, r0
	uhsub16	r15, r15, r15

positive: uhsub16eq instruction

	uhsub16eq	r0, r0, r0
	uhsub16eq	r15, r15, r15

positive: uhsub16ne instruction

	uhsub16ne	r0, r0, r0
	uhsub16ne	r15, r15, r15

positive: uhsub16cs instruction

	uhsub16cs	r0, r0, r0
	uhsub16cs	r15, r15, r15

positive: uhsub16hs instruction

	uhsub16hs	r0, r0, r0
	uhsub16hs	r15, r15, r15

positive: uhsub16cc instruction

	uhsub16cc	r0, r0, r0
	uhsub16cc	r15, r15, r15

positive: uhsub16lo instruction

	uhsub16lo	r0, r0, r0
	uhsub16lo	r15, r15, r15

positive: uhsub16mi instruction

	uhsub16mi	r0, r0, r0
	uhsub16mi	r15, r15, r15

positive: uhsub16pl instruction

	uhsub16pl	r0, r0, r0
	uhsub16pl	r15, r15, r15

positive: uhsub16vs instruction

	uhsub16vs	r0, r0, r0
	uhsub16vs	r15, r15, r15

positive: uhsub16vc instruction

	uhsub16vc	r0, r0, r0
	uhsub16vc	r15, r15, r15

positive: uhsub16hi instruction

	uhsub16hi	r0, r0, r0
	uhsub16hi	r15, r15, r15

positive: uhsub16ls instruction

	uhsub16ls	r0, r0, r0
	uhsub16ls	r15, r15, r15

positive: uhsub16ge instruction

	uhsub16ge	r0, r0, r0
	uhsub16ge	r15, r15, r15

positive: uhsub16lt instruction

	uhsub16lt	r0, r0, r0
	uhsub16lt	r15, r15, r15

positive: uhsub16gt instruction

	uhsub16gt	r0, r0, r0
	uhsub16gt	r15, r15, r15

positive: uhsub16le instruction

	uhsub16le	r0, r0, r0
	uhsub16le	r15, r15, r15

positive: uhsub16al instruction

	uhsub16al	r0, r0, r0
	uhsub16al	r15, r15, r15

positive: uhsub8 instruction

	uhsub8	r0, r0, r0
	uhsub8	r15, r15, r15

positive: uhsub8eq instruction

	uhsub8eq	r0, r0, r0
	uhsub8eq	r15, r15, r15

positive: uhsub8ne instruction

	uhsub8ne	r0, r0, r0
	uhsub8ne	r15, r15, r15

positive: uhsub8cs instruction

	uhsub8cs	r0, r0, r0
	uhsub8cs	r15, r15, r15

positive: uhsub8hs instruction

	uhsub8hs	r0, r0, r0
	uhsub8hs	r15, r15, r15

positive: uhsub8cc instruction

	uhsub8cc	r0, r0, r0
	uhsub8cc	r15, r15, r15

positive: uhsub8lo instruction

	uhsub8lo	r0, r0, r0
	uhsub8lo	r15, r15, r15

positive: uhsub8mi instruction

	uhsub8mi	r0, r0, r0
	uhsub8mi	r15, r15, r15

positive: uhsub8pl instruction

	uhsub8pl	r0, r0, r0
	uhsub8pl	r15, r15, r15

positive: uhsub8vs instruction

	uhsub8vs	r0, r0, r0
	uhsub8vs	r15, r15, r15

positive: uhsub8vc instruction

	uhsub8vc	r0, r0, r0
	uhsub8vc	r15, r15, r15

positive: uhsub8hi instruction

	uhsub8hi	r0, r0, r0
	uhsub8hi	r15, r15, r15

positive: uhsub8ls instruction

	uhsub8ls	r0, r0, r0
	uhsub8ls	r15, r15, r15

positive: uhsub8ge instruction

	uhsub8ge	r0, r0, r0
	uhsub8ge	r15, r15, r15

positive: uhsub8lt instruction

	uhsub8lt	r0, r0, r0
	uhsub8lt	r15, r15, r15

positive: uhsub8gt instruction

	uhsub8gt	r0, r0, r0
	uhsub8gt	r15, r15, r15

positive: uhsub8le instruction

	uhsub8le	r0, r0, r0
	uhsub8le	r15, r15, r15

positive: uhsub8al instruction

	uhsub8al	r0, r0, r0
	uhsub8al	r15, r15, r15

positive: uhsubaddx instruction

	uhsubaddx	r0, r0, r0
	uhsubaddx	r15, r15, r15

positive: uhsubaddxeq instruction

	uhsubaddxeq	r0, r0, r0
	uhsubaddxeq	r15, r15, r15

positive: uhsubaddxne instruction

	uhsubaddxne	r0, r0, r0
	uhsubaddxne	r15, r15, r15

positive: uhsubaddxcs instruction

	uhsubaddxcs	r0, r0, r0
	uhsubaddxcs	r15, r15, r15

positive: uhsubaddxhs instruction

	uhsubaddxhs	r0, r0, r0
	uhsubaddxhs	r15, r15, r15

positive: uhsubaddxcc instruction

	uhsubaddxcc	r0, r0, r0
	uhsubaddxcc	r15, r15, r15

positive: uhsubaddxlo instruction

	uhsubaddxlo	r0, r0, r0
	uhsubaddxlo	r15, r15, r15

positive: uhsubaddxmi instruction

	uhsubaddxmi	r0, r0, r0
	uhsubaddxmi	r15, r15, r15

positive: uhsubaddxpl instruction

	uhsubaddxpl	r0, r0, r0
	uhsubaddxpl	r15, r15, r15

positive: uhsubaddxvs instruction

	uhsubaddxvs	r0, r0, r0
	uhsubaddxvs	r15, r15, r15

positive: uhsubaddxvc instruction

	uhsubaddxvc	r0, r0, r0
	uhsubaddxvc	r15, r15, r15

positive: uhsubaddxhi instruction

	uhsubaddxhi	r0, r0, r0
	uhsubaddxhi	r15, r15, r15

positive: uhsubaddxls instruction

	uhsubaddxls	r0, r0, r0
	uhsubaddxls	r15, r15, r15

positive: uhsubaddxge instruction

	uhsubaddxge	r0, r0, r0
	uhsubaddxge	r15, r15, r15

positive: uhsubaddxlt instruction

	uhsubaddxlt	r0, r0, r0
	uhsubaddxlt	r15, r15, r15

positive: uhsubaddxgt instruction

	uhsubaddxgt	r0, r0, r0
	uhsubaddxgt	r15, r15, r15

positive: uhsubaddxle instruction

	uhsubaddxle	r0, r0, r0
	uhsubaddxle	r15, r15, r15

positive: uhsubaddxal instruction

	uhsubaddxal	r0, r0, r0
	uhsubaddxal	r15, r15, r15

positive: umaal instruction

	umaal	r0, r0, r0, r0
	umaal	r15, r15, r15, r15

positive: umaaleq instruction

	umaaleq	r0, r0, r0, r0
	umaaleq	r15, r15, r15, r15

positive: umaalne instruction

	umaalne	r0, r0, r0, r0
	umaalne	r15, r15, r15, r15

positive: umaalcs instruction

	umaalcs	r0, r0, r0, r0
	umaalcs	r15, r15, r15, r15

positive: umaalhs instruction

	umaalhs	r0, r0, r0, r0
	umaalhs	r15, r15, r15, r15

positive: umaalcc instruction

	umaalcc	r0, r0, r0, r0
	umaalcc	r15, r15, r15, r15

positive: umaallo instruction

	umaallo	r0, r0, r0, r0
	umaallo	r15, r15, r15, r15

positive: umaalmi instruction

	umaalmi	r0, r0, r0, r0
	umaalmi	r15, r15, r15, r15

positive: umaalpl instruction

	umaalpl	r0, r0, r0, r0
	umaalpl	r15, r15, r15, r15

positive: umaalvs instruction

	umaalvs	r0, r0, r0, r0
	umaalvs	r15, r15, r15, r15

positive: umaalvc instruction

	umaalvc	r0, r0, r0, r0
	umaalvc	r15, r15, r15, r15

positive: umaalhi instruction

	umaalhi	r0, r0, r0, r0
	umaalhi	r15, r15, r15, r15

positive: umaalls instruction

	umaalls	r0, r0, r0, r0
	umaalls	r15, r15, r15, r15

positive: umaalge instruction

	umaalge	r0, r0, r0, r0
	umaalge	r15, r15, r15, r15

positive: umaallt instruction

	umaallt	r0, r0, r0, r0
	umaallt	r15, r15, r15, r15

positive: umaalgt instruction

	umaalgt	r0, r0, r0, r0
	umaalgt	r15, r15, r15, r15

positive: umaalle instruction

	umaalle	r0, r0, r0, r0
	umaalle	r15, r15, r15, r15

positive: umaalal instruction

	umaalal	r0, r0, r0, r0
	umaalal	r15, r15, r15, r15

positive: umlal instruction

	umlal	r0, r0, r0, r0
	umlal	r15, r15, r15, r15

positive: umlaleq instruction

	umlaleq	r0, r0, r0, r0
	umlaleq	r15, r15, r15, r15

positive: umlalne instruction

	umlalne	r0, r0, r0, r0
	umlalne	r15, r15, r15, r15

positive: umlalcs instruction

	umlalcs	r0, r0, r0, r0
	umlalcs	r15, r15, r15, r15

positive: umlalhs instruction

	umlalhs	r0, r0, r0, r0
	umlalhs	r15, r15, r15, r15

positive: umlalcc instruction

	umlalcc	r0, r0, r0, r0
	umlalcc	r15, r15, r15, r15

positive: umlallo instruction

	umlallo	r0, r0, r0, r0
	umlallo	r15, r15, r15, r15

positive: umlalmi instruction

	umlalmi	r0, r0, r0, r0
	umlalmi	r15, r15, r15, r15

positive: umlalpl instruction

	umlalpl	r0, r0, r0, r0
	umlalpl	r15, r15, r15, r15

positive: umlalvs instruction

	umlalvs	r0, r0, r0, r0
	umlalvs	r15, r15, r15, r15

positive: umlalvc instruction

	umlalvc	r0, r0, r0, r0
	umlalvc	r15, r15, r15, r15

positive: umlalhi instruction

	umlalhi	r0, r0, r0, r0
	umlalhi	r15, r15, r15, r15

positive: umlalls instruction

	umlalls	r0, r0, r0, r0
	umlalls	r15, r15, r15, r15

positive: umlalge instruction

	umlalge	r0, r0, r0, r0
	umlalge	r15, r15, r15, r15

positive: umlallt instruction

	umlallt	r0, r0, r0, r0
	umlallt	r15, r15, r15, r15

positive: umlalgt instruction

	umlalgt	r0, r0, r0, r0
	umlalgt	r15, r15, r15, r15

positive: umlalle instruction

	umlalle	r0, r0, r0, r0
	umlalle	r15, r15, r15, r15

positive: umlalal instruction

	umlalal	r0, r0, r0, r0
	umlalal	r15, r15, r15, r15

positive: umlals instruction

	umlals	r0, r0, r0, r0
	umlals	r15, r15, r15, r15

positive: umlalseq instruction

	umlalseq	r0, r0, r0, r0
	umlalseq	r15, r15, r15, r15

positive: umlalsne instruction

	umlalsne	r0, r0, r0, r0
	umlalsne	r15, r15, r15, r15

positive: umlalscs instruction

	umlalscs	r0, r0, r0, r0
	umlalscs	r15, r15, r15, r15

positive: umlalshs instruction

	umlalshs	r0, r0, r0, r0
	umlalshs	r15, r15, r15, r15

positive: umlalscc instruction

	umlalscc	r0, r0, r0, r0
	umlalscc	r15, r15, r15, r15

positive: umlalslo instruction

	umlalslo	r0, r0, r0, r0
	umlalslo	r15, r15, r15, r15

positive: umlalsmi instruction

	umlalsmi	r0, r0, r0, r0
	umlalsmi	r15, r15, r15, r15

positive: umlalspl instruction

	umlalspl	r0, r0, r0, r0
	umlalspl	r15, r15, r15, r15

positive: umlalsvs instruction

	umlalsvs	r0, r0, r0, r0
	umlalsvs	r15, r15, r15, r15

positive: umlalsvc instruction

	umlalsvc	r0, r0, r0, r0
	umlalsvc	r15, r15, r15, r15

positive: umlalshi instruction

	umlalshi	r0, r0, r0, r0
	umlalshi	r15, r15, r15, r15

positive: umlalsls instruction

	umlalsls	r0, r0, r0, r0
	umlalsls	r15, r15, r15, r15

positive: umlalsge instruction

	umlalsge	r0, r0, r0, r0
	umlalsge	r15, r15, r15, r15

positive: umlalslt instruction

	umlalslt	r0, r0, r0, r0
	umlalslt	r15, r15, r15, r15

positive: umlalsgt instruction

	umlalsgt	r0, r0, r0, r0
	umlalsgt	r15, r15, r15, r15

positive: umlalsle instruction

	umlalsle	r0, r0, r0, r0
	umlalsle	r15, r15, r15, r15

positive: umlalsal instruction

	umlalsal	r0, r0, r0, r0
	umlalsal	r15, r15, r15, r15

positive: umull instruction

	umull	r0, r0, r0, r0
	umull	r15, r15, r15, r15

positive: umulleq instruction

	umulleq	r0, r0, r0, r0
	umulleq	r15, r15, r15, r15

positive: umullne instruction

	umullne	r0, r0, r0, r0
	umullne	r15, r15, r15, r15

positive: umullcs instruction

	umullcs	r0, r0, r0, r0
	umullcs	r15, r15, r15, r15

positive: umullhs instruction

	umullhs	r0, r0, r0, r0
	umullhs	r15, r15, r15, r15

positive: umullcc instruction

	umullcc	r0, r0, r0, r0
	umullcc	r15, r15, r15, r15

positive: umulllo instruction

	umulllo	r0, r0, r0, r0
	umulllo	r15, r15, r15, r15

positive: umullmi instruction

	umullmi	r0, r0, r0, r0
	umullmi	r15, r15, r15, r15

positive: umullpl instruction

	umullpl	r0, r0, r0, r0
	umullpl	r15, r15, r15, r15

positive: umullvs instruction

	umullvs	r0, r0, r0, r0
	umullvs	r15, r15, r15, r15

positive: umullvc instruction

	umullvc	r0, r0, r0, r0
	umullvc	r15, r15, r15, r15

positive: umullhi instruction

	umullhi	r0, r0, r0, r0
	umullhi	r15, r15, r15, r15

positive: umullls instruction

	umullls	r0, r0, r0, r0
	umullls	r15, r15, r15, r15

positive: umullge instruction

	umullge	r0, r0, r0, r0
	umullge	r15, r15, r15, r15

positive: umulllt instruction

	umulllt	r0, r0, r0, r0
	umulllt	r15, r15, r15, r15

positive: umullgt instruction

	umullgt	r0, r0, r0, r0
	umullgt	r15, r15, r15, r15

positive: umullle instruction

	umullle	r0, r0, r0, r0
	umullle	r15, r15, r15, r15

positive: umullal instruction

	umullal	r0, r0, r0, r0
	umullal	r15, r15, r15, r15

positive: umulls instruction

	umulls	r0, r0, r0, r0
	umulls	r15, r15, r15, r15

positive: umullseq instruction

	umullseq	r0, r0, r0, r0
	umullseq	r15, r15, r15, r15

positive: umullsne instruction

	umullsne	r0, r0, r0, r0
	umullsne	r15, r15, r15, r15

positive: umullscs instruction

	umullscs	r0, r0, r0, r0
	umullscs	r15, r15, r15, r15

positive: umullshs instruction

	umullshs	r0, r0, r0, r0
	umullshs	r15, r15, r15, r15

positive: umullscc instruction

	umullscc	r0, r0, r0, r0
	umullscc	r15, r15, r15, r15

positive: umullslo instruction

	umullslo	r0, r0, r0, r0
	umullslo	r15, r15, r15, r15

positive: umullsmi instruction

	umullsmi	r0, r0, r0, r0
	umullsmi	r15, r15, r15, r15

positive: umullspl instruction

	umullspl	r0, r0, r0, r0
	umullspl	r15, r15, r15, r15

positive: umullsvs instruction

	umullsvs	r0, r0, r0, r0
	umullsvs	r15, r15, r15, r15

positive: umullsvc instruction

	umullsvc	r0, r0, r0, r0
	umullsvc	r15, r15, r15, r15

positive: umullshi instruction

	umullshi	r0, r0, r0, r0
	umullshi	r15, r15, r15, r15

positive: umullsls instruction

	umullsls	r0, r0, r0, r0
	umullsls	r15, r15, r15, r15

positive: umullsge instruction

	umullsge	r0, r0, r0, r0
	umullsge	r15, r15, r15, r15

positive: umullslt instruction

	umullslt	r0, r0, r0, r0
	umullslt	r15, r15, r15, r15

positive: umullsgt instruction

	umullsgt	r0, r0, r0, r0
	umullsgt	r15, r15, r15, r15

positive: umullsle instruction

	umullsle	r0, r0, r0, r0
	umullsle	r15, r15, r15, r15

positive: umullsal instruction

	umullsal	r0, r0, r0, r0
	umullsal	r15, r15, r15, r15

positive: uqadd16 instruction

	uqadd16	r0, r0, r0
	uqadd16	r15, r15, r15

positive: uqadd16eq instruction

	uqadd16eq	r0, r0, r0
	uqadd16eq	r15, r15, r15

positive: uqadd16ne instruction

	uqadd16ne	r0, r0, r0
	uqadd16ne	r15, r15, r15

positive: uqadd16cs instruction

	uqadd16cs	r0, r0, r0
	uqadd16cs	r15, r15, r15

positive: uqadd16hs instruction

	uqadd16hs	r0, r0, r0
	uqadd16hs	r15, r15, r15

positive: uqadd16cc instruction

	uqadd16cc	r0, r0, r0
	uqadd16cc	r15, r15, r15

positive: uqadd16lo instruction

	uqadd16lo	r0, r0, r0
	uqadd16lo	r15, r15, r15

positive: uqadd16mi instruction

	uqadd16mi	r0, r0, r0
	uqadd16mi	r15, r15, r15

positive: uqadd16pl instruction

	uqadd16pl	r0, r0, r0
	uqadd16pl	r15, r15, r15

positive: uqadd16vs instruction

	uqadd16vs	r0, r0, r0
	uqadd16vs	r15, r15, r15

positive: uqadd16vc instruction

	uqadd16vc	r0, r0, r0
	uqadd16vc	r15, r15, r15

positive: uqadd16hi instruction

	uqadd16hi	r0, r0, r0
	uqadd16hi	r15, r15, r15

positive: uqadd16ls instruction

	uqadd16ls	r0, r0, r0
	uqadd16ls	r15, r15, r15

positive: uqadd16ge instruction

	uqadd16ge	r0, r0, r0
	uqadd16ge	r15, r15, r15

positive: uqadd16lt instruction

	uqadd16lt	r0, r0, r0
	uqadd16lt	r15, r15, r15

positive: uqadd16gt instruction

	uqadd16gt	r0, r0, r0
	uqadd16gt	r15, r15, r15

positive: uqadd16le instruction

	uqadd16le	r0, r0, r0
	uqadd16le	r15, r15, r15

positive: uqadd16al instruction

	uqadd16al	r0, r0, r0
	uqadd16al	r15, r15, r15

positive: uqadd8 instruction

	uqadd8	r0, r0, r0
	uqadd8	r15, r15, r15

positive: uqadd8eq instruction

	uqadd8eq	r0, r0, r0
	uqadd8eq	r15, r15, r15

positive: uqadd8ne instruction

	uqadd8ne	r0, r0, r0
	uqadd8ne	r15, r15, r15

positive: uqadd8cs instruction

	uqadd8cs	r0, r0, r0
	uqadd8cs	r15, r15, r15

positive: uqadd8hs instruction

	uqadd8hs	r0, r0, r0
	uqadd8hs	r15, r15, r15

positive: uqadd8cc instruction

	uqadd8cc	r0, r0, r0
	uqadd8cc	r15, r15, r15

positive: uqadd8lo instruction

	uqadd8lo	r0, r0, r0
	uqadd8lo	r15, r15, r15

positive: uqadd8mi instruction

	uqadd8mi	r0, r0, r0
	uqadd8mi	r15, r15, r15

positive: uqadd8pl instruction

	uqadd8pl	r0, r0, r0
	uqadd8pl	r15, r15, r15

positive: uqadd8vs instruction

	uqadd8vs	r0, r0, r0
	uqadd8vs	r15, r15, r15

positive: uqadd8vc instruction

	uqadd8vc	r0, r0, r0
	uqadd8vc	r15, r15, r15

positive: uqadd8hi instruction

	uqadd8hi	r0, r0, r0
	uqadd8hi	r15, r15, r15

positive: uqadd8ls instruction

	uqadd8ls	r0, r0, r0
	uqadd8ls	r15, r15, r15

positive: uqadd8ge instruction

	uqadd8ge	r0, r0, r0
	uqadd8ge	r15, r15, r15

positive: uqadd8lt instruction

	uqadd8lt	r0, r0, r0
	uqadd8lt	r15, r15, r15

positive: uqadd8gt instruction

	uqadd8gt	r0, r0, r0
	uqadd8gt	r15, r15, r15

positive: uqadd8le instruction

	uqadd8le	r0, r0, r0
	uqadd8le	r15, r15, r15

positive: uqadd8al instruction

	uqadd8al	r0, r0, r0
	uqadd8al	r15, r15, r15

positive: uqaddsubx instruction

	uqaddsubx	r0, r0, r0
	uqaddsubx	r15, r15, r15

positive: uqaddsubxeq instruction

	uqaddsubxeq	r0, r0, r0
	uqaddsubxeq	r15, r15, r15

positive: uqaddsubxne instruction

	uqaddsubxne	r0, r0, r0
	uqaddsubxne	r15, r15, r15

positive: uqaddsubxcs instruction

	uqaddsubxcs	r0, r0, r0
	uqaddsubxcs	r15, r15, r15

positive: uqaddsubxhs instruction

	uqaddsubxhs	r0, r0, r0
	uqaddsubxhs	r15, r15, r15

positive: uqaddsubxcc instruction

	uqaddsubxcc	r0, r0, r0
	uqaddsubxcc	r15, r15, r15

positive: uqaddsubxlo instruction

	uqaddsubxlo	r0, r0, r0
	uqaddsubxlo	r15, r15, r15

positive: uqaddsubxmi instruction

	uqaddsubxmi	r0, r0, r0
	uqaddsubxmi	r15, r15, r15

positive: uqaddsubxpl instruction

	uqaddsubxpl	r0, r0, r0
	uqaddsubxpl	r15, r15, r15

positive: uqaddsubxvs instruction

	uqaddsubxvs	r0, r0, r0
	uqaddsubxvs	r15, r15, r15

positive: uqaddsubxvc instruction

	uqaddsubxvc	r0, r0, r0
	uqaddsubxvc	r15, r15, r15

positive: uqaddsubxhi instruction

	uqaddsubxhi	r0, r0, r0
	uqaddsubxhi	r15, r15, r15

positive: uqaddsubxls instruction

	uqaddsubxls	r0, r0, r0
	uqaddsubxls	r15, r15, r15

positive: uqaddsubxge instruction

	uqaddsubxge	r0, r0, r0
	uqaddsubxge	r15, r15, r15

positive: uqaddsubxlt instruction

	uqaddsubxlt	r0, r0, r0
	uqaddsubxlt	r15, r15, r15

positive: uqaddsubxgt instruction

	uqaddsubxgt	r0, r0, r0
	uqaddsubxgt	r15, r15, r15

positive: uqaddsubxle instruction

	uqaddsubxle	r0, r0, r0
	uqaddsubxle	r15, r15, r15

positive: uqaddsubxal instruction

	uqaddsubxal	r0, r0, r0
	uqaddsubxal	r15, r15, r15

positive: uqsub16 instruction

	uqsub16	r0, r0, r0
	uqsub16	r15, r15, r15

positive: uqsub16eq instruction

	uqsub16eq	r0, r0, r0
	uqsub16eq	r15, r15, r15

positive: uqsub16ne instruction

	uqsub16ne	r0, r0, r0
	uqsub16ne	r15, r15, r15

positive: uqsub16cs instruction

	uqsub16cs	r0, r0, r0
	uqsub16cs	r15, r15, r15

positive: uqsub16hs instruction

	uqsub16hs	r0, r0, r0
	uqsub16hs	r15, r15, r15

positive: uqsub16cc instruction

	uqsub16cc	r0, r0, r0
	uqsub16cc	r15, r15, r15

positive: uqsub16lo instruction

	uqsub16lo	r0, r0, r0
	uqsub16lo	r15, r15, r15

positive: uqsub16mi instruction

	uqsub16mi	r0, r0, r0
	uqsub16mi	r15, r15, r15

positive: uqsub16pl instruction

	uqsub16pl	r0, r0, r0
	uqsub16pl	r15, r15, r15

positive: uqsub16vs instruction

	uqsub16vs	r0, r0, r0
	uqsub16vs	r15, r15, r15

positive: uqsub16vc instruction

	uqsub16vc	r0, r0, r0
	uqsub16vc	r15, r15, r15

positive: uqsub16hi instruction

	uqsub16hi	r0, r0, r0
	uqsub16hi	r15, r15, r15

positive: uqsub16ls instruction

	uqsub16ls	r0, r0, r0
	uqsub16ls	r15, r15, r15

positive: uqsub16ge instruction

	uqsub16ge	r0, r0, r0
	uqsub16ge	r15, r15, r15

positive: uqsub16lt instruction

	uqsub16lt	r0, r0, r0
	uqsub16lt	r15, r15, r15

positive: uqsub16gt instruction

	uqsub16gt	r0, r0, r0
	uqsub16gt	r15, r15, r15

positive: uqsub16le instruction

	uqsub16le	r0, r0, r0
	uqsub16le	r15, r15, r15

positive: uqsub16al instruction

	uqsub16al	r0, r0, r0
	uqsub16al	r15, r15, r15

positive: uqsub8 instruction

	uqsub8	r0, r0, r0
	uqsub8	r15, r15, r15

positive: uqsub8eq instruction

	uqsub8eq	r0, r0, r0
	uqsub8eq	r15, r15, r15

positive: uqsub8ne instruction

	uqsub8ne	r0, r0, r0
	uqsub8ne	r15, r15, r15

positive: uqsub8cs instruction

	uqsub8cs	r0, r0, r0
	uqsub8cs	r15, r15, r15

positive: uqsub8hs instruction

	uqsub8hs	r0, r0, r0
	uqsub8hs	r15, r15, r15

positive: uqsub8cc instruction

	uqsub8cc	r0, r0, r0
	uqsub8cc	r15, r15, r15

positive: uqsub8lo instruction

	uqsub8lo	r0, r0, r0
	uqsub8lo	r15, r15, r15

positive: uqsub8mi instruction

	uqsub8mi	r0, r0, r0
	uqsub8mi	r15, r15, r15

positive: uqsub8pl instruction

	uqsub8pl	r0, r0, r0
	uqsub8pl	r15, r15, r15

positive: uqsub8vs instruction

	uqsub8vs	r0, r0, r0
	uqsub8vs	r15, r15, r15

positive: uqsub8vc instruction

	uqsub8vc	r0, r0, r0
	uqsub8vc	r15, r15, r15

positive: uqsub8hi instruction

	uqsub8hi	r0, r0, r0
	uqsub8hi	r15, r15, r15

positive: uqsub8ls instruction

	uqsub8ls	r0, r0, r0
	uqsub8ls	r15, r15, r15

positive: uqsub8ge instruction

	uqsub8ge	r0, r0, r0
	uqsub8ge	r15, r15, r15

positive: uqsub8lt instruction

	uqsub8lt	r0, r0, r0
	uqsub8lt	r15, r15, r15

positive: uqsub8gt instruction

	uqsub8gt	r0, r0, r0
	uqsub8gt	r15, r15, r15

positive: uqsub8le instruction

	uqsub8le	r0, r0, r0
	uqsub8le	r15, r15, r15

positive: uqsub8al instruction

	uqsub8al	r0, r0, r0
	uqsub8al	r15, r15, r15

positive: uqsubaddx instruction

	uqsubaddx	r0, r0, r0
	uqsubaddx	r15, r15, r15

positive: uqsubaddxeq instruction

	uqsubaddxeq	r0, r0, r0
	uqsubaddxeq	r15, r15, r15

positive: uqsubaddxne instruction

	uqsubaddxne	r0, r0, r0
	uqsubaddxne	r15, r15, r15

positive: uqsubaddxcs instruction

	uqsubaddxcs	r0, r0, r0
	uqsubaddxcs	r15, r15, r15

positive: uqsubaddxhs instruction

	uqsubaddxhs	r0, r0, r0
	uqsubaddxhs	r15, r15, r15

positive: uqsubaddxcc instruction

	uqsubaddxcc	r0, r0, r0
	uqsubaddxcc	r15, r15, r15

positive: uqsubaddxlo instruction

	uqsubaddxlo	r0, r0, r0
	uqsubaddxlo	r15, r15, r15

positive: uqsubaddxmi instruction

	uqsubaddxmi	r0, r0, r0
	uqsubaddxmi	r15, r15, r15

positive: uqsubaddxpl instruction

	uqsubaddxpl	r0, r0, r0
	uqsubaddxpl	r15, r15, r15

positive: uqsubaddxvs instruction

	uqsubaddxvs	r0, r0, r0
	uqsubaddxvs	r15, r15, r15

positive: uqsubaddxvc instruction

	uqsubaddxvc	r0, r0, r0
	uqsubaddxvc	r15, r15, r15

positive: uqsubaddxhi instruction

	uqsubaddxhi	r0, r0, r0
	uqsubaddxhi	r15, r15, r15

positive: uqsubaddxls instruction

	uqsubaddxls	r0, r0, r0
	uqsubaddxls	r15, r15, r15

positive: uqsubaddxge instruction

	uqsubaddxge	r0, r0, r0
	uqsubaddxge	r15, r15, r15

positive: uqsubaddxlt instruction

	uqsubaddxlt	r0, r0, r0
	uqsubaddxlt	r15, r15, r15

positive: uqsubaddxgt instruction

	uqsubaddxgt	r0, r0, r0
	uqsubaddxgt	r15, r15, r15

positive: uqsubaddxle instruction

	uqsubaddxle	r0, r0, r0
	uqsubaddxle	r15, r15, r15

positive: uqsubaddxal instruction

	uqsubaddxal	r0, r0, r0
	uqsubaddxal	r15, r15, r15

positive: usad8 instruction

	usad8	r0, r0, r0
	usad8	r15, r15, r15

positive: usad8eq instruction

	usad8eq	r0, r0, r0
	usad8eq	r15, r15, r15

positive: usad8ne instruction

	usad8ne	r0, r0, r0
	usad8ne	r15, r15, r15

positive: usad8cs instruction

	usad8cs	r0, r0, r0
	usad8cs	r15, r15, r15

positive: usad8hs instruction

	usad8hs	r0, r0, r0
	usad8hs	r15, r15, r15

positive: usad8cc instruction

	usad8cc	r0, r0, r0
	usad8cc	r15, r15, r15

positive: usad8lo instruction

	usad8lo	r0, r0, r0
	usad8lo	r15, r15, r15

positive: usad8mi instruction

	usad8mi	r0, r0, r0
	usad8mi	r15, r15, r15

positive: usad8pl instruction

	usad8pl	r0, r0, r0
	usad8pl	r15, r15, r15

positive: usad8vs instruction

	usad8vs	r0, r0, r0
	usad8vs	r15, r15, r15

positive: usad8vc instruction

	usad8vc	r0, r0, r0
	usad8vc	r15, r15, r15

positive: usad8hi instruction

	usad8hi	r0, r0, r0
	usad8hi	r15, r15, r15

positive: usad8ls instruction

	usad8ls	r0, r0, r0
	usad8ls	r15, r15, r15

positive: usad8ge instruction

	usad8ge	r0, r0, r0
	usad8ge	r15, r15, r15

positive: usad8lt instruction

	usad8lt	r0, r0, r0
	usad8lt	r15, r15, r15

positive: usad8gt instruction

	usad8gt	r0, r0, r0
	usad8gt	r15, r15, r15

positive: usad8le instruction

	usad8le	r0, r0, r0
	usad8le	r15, r15, r15

positive: usad8al instruction

	usad8al	r0, r0, r0
	usad8al	r15, r15, r15

positive: usada8 instruction

	usada8	r0, r0, r0, r0
	usada8	r15, r15, r15, r15

positive: usada8eq instruction

	usada8eq	r0, r0, r0, r0
	usada8eq	r15, r15, r15, r15

positive: usada8ne instruction

	usada8ne	r0, r0, r0, r0
	usada8ne	r15, r15, r15, r15

positive: usada8cs instruction

	usada8cs	r0, r0, r0, r0
	usada8cs	r15, r15, r15, r15

positive: usada8hs instruction

	usada8hs	r0, r0, r0, r0
	usada8hs	r15, r15, r15, r15

positive: usada8cc instruction

	usada8cc	r0, r0, r0, r0
	usada8cc	r15, r15, r15, r15

positive: usada8lo instruction

	usada8lo	r0, r0, r0, r0
	usada8lo	r15, r15, r15, r15

positive: usada8mi instruction

	usada8mi	r0, r0, r0, r0
	usada8mi	r15, r15, r15, r15

positive: usada8pl instruction

	usada8pl	r0, r0, r0, r0
	usada8pl	r15, r15, r15, r15

positive: usada8vs instruction

	usada8vs	r0, r0, r0, r0
	usada8vs	r15, r15, r15, r15

positive: usada8vc instruction

	usada8vc	r0, r0, r0, r0
	usada8vc	r15, r15, r15, r15

positive: usada8hi instruction

	usada8hi	r0, r0, r0, r0
	usada8hi	r15, r15, r15, r15

positive: usada8ls instruction

	usada8ls	r0, r0, r0, r0
	usada8ls	r15, r15, r15, r15

positive: usada8ge instruction

	usada8ge	r0, r0, r0, r0
	usada8ge	r15, r15, r15, r15

positive: usada8lt instruction

	usada8lt	r0, r0, r0, r0
	usada8lt	r15, r15, r15, r15

positive: usada8gt instruction

	usada8gt	r0, r0, r0, r0
	usada8gt	r15, r15, r15, r15

positive: usada8le instruction

	usada8le	r0, r0, r0, r0
	usada8le	r15, r15, r15, r15

positive: usada8al instruction

	usada8al	r0, r0, r0, r0
	usada8al	r15, r15, r15, r15

positive: usub16 instruction

	usub16	r0, r0, r0
	usub16	r15, r15, r15

positive: usub16eq instruction

	usub16eq	r0, r0, r0
	usub16eq	r15, r15, r15

positive: usub16ne instruction

	usub16ne	r0, r0, r0
	usub16ne	r15, r15, r15

positive: usub16cs instruction

	usub16cs	r0, r0, r0
	usub16cs	r15, r15, r15

positive: usub16hs instruction

	usub16hs	r0, r0, r0
	usub16hs	r15, r15, r15

positive: usub16cc instruction

	usub16cc	r0, r0, r0
	usub16cc	r15, r15, r15

positive: usub16lo instruction

	usub16lo	r0, r0, r0
	usub16lo	r15, r15, r15

positive: usub16mi instruction

	usub16mi	r0, r0, r0
	usub16mi	r15, r15, r15

positive: usub16pl instruction

	usub16pl	r0, r0, r0
	usub16pl	r15, r15, r15

positive: usub16vs instruction

	usub16vs	r0, r0, r0
	usub16vs	r15, r15, r15

positive: usub16vc instruction

	usub16vc	r0, r0, r0
	usub16vc	r15, r15, r15

positive: usub16hi instruction

	usub16hi	r0, r0, r0
	usub16hi	r15, r15, r15

positive: usub16ls instruction

	usub16ls	r0, r0, r0
	usub16ls	r15, r15, r15

positive: usub16ge instruction

	usub16ge	r0, r0, r0
	usub16ge	r15, r15, r15

positive: usub16lt instruction

	usub16lt	r0, r0, r0
	usub16lt	r15, r15, r15

positive: usub16gt instruction

	usub16gt	r0, r0, r0
	usub16gt	r15, r15, r15

positive: usub16le instruction

	usub16le	r0, r0, r0
	usub16le	r15, r15, r15

positive: usub16al instruction

	usub16al	r0, r0, r0
	usub16al	r15, r15, r15

positive: usub8 instruction

	usub8	r0, r0, r0
	usub8	r15, r15, r15

positive: usub8eq instruction

	usub8eq	r0, r0, r0
	usub8eq	r15, r15, r15

positive: usub8ne instruction

	usub8ne	r0, r0, r0
	usub8ne	r15, r15, r15

positive: usub8cs instruction

	usub8cs	r0, r0, r0
	usub8cs	r15, r15, r15

positive: usub8hs instruction

	usub8hs	r0, r0, r0
	usub8hs	r15, r15, r15

positive: usub8cc instruction

	usub8cc	r0, r0, r0
	usub8cc	r15, r15, r15

positive: usub8lo instruction

	usub8lo	r0, r0, r0
	usub8lo	r15, r15, r15

positive: usub8mi instruction

	usub8mi	r0, r0, r0
	usub8mi	r15, r15, r15

positive: usub8pl instruction

	usub8pl	r0, r0, r0
	usub8pl	r15, r15, r15

positive: usub8vs instruction

	usub8vs	r0, r0, r0
	usub8vs	r15, r15, r15

positive: usub8vc instruction

	usub8vc	r0, r0, r0
	usub8vc	r15, r15, r15

positive: usub8hi instruction

	usub8hi	r0, r0, r0
	usub8hi	r15, r15, r15

positive: usub8ls instruction

	usub8ls	r0, r0, r0
	usub8ls	r15, r15, r15

positive: usub8ge instruction

	usub8ge	r0, r0, r0
	usub8ge	r15, r15, r15

positive: usub8lt instruction

	usub8lt	r0, r0, r0
	usub8lt	r15, r15, r15

positive: usub8gt instruction

	usub8gt	r0, r0, r0
	usub8gt	r15, r15, r15

positive: usub8le instruction

	usub8le	r0, r0, r0
	usub8le	r15, r15, r15

positive: usub8al instruction

	usub8al	r0, r0, r0
	usub8al	r15, r15, r15

positive: usubaddx instruction

	usubaddx	r0, r0, r0
	usubaddx	r15, r15, r15

positive: usubaddxeq instruction

	usubaddxeq	r0, r0, r0
	usubaddxeq	r15, r15, r15

positive: usubaddxne instruction

	usubaddxne	r0, r0, r0
	usubaddxne	r15, r15, r15

positive: usubaddxcs instruction

	usubaddxcs	r0, r0, r0
	usubaddxcs	r15, r15, r15

positive: usubaddxhs instruction

	usubaddxhs	r0, r0, r0
	usubaddxhs	r15, r15, r15

positive: usubaddxcc instruction

	usubaddxcc	r0, r0, r0
	usubaddxcc	r15, r15, r15

positive: usubaddxlo instruction

	usubaddxlo	r0, r0, r0
	usubaddxlo	r15, r15, r15

positive: usubaddxmi instruction

	usubaddxmi	r0, r0, r0
	usubaddxmi	r15, r15, r15

positive: usubaddxpl instruction

	usubaddxpl	r0, r0, r0
	usubaddxpl	r15, r15, r15

positive: usubaddxvs instruction

	usubaddxvs	r0, r0, r0
	usubaddxvs	r15, r15, r15

positive: usubaddxvc instruction

	usubaddxvc	r0, r0, r0
	usubaddxvc	r15, r15, r15

positive: usubaddxhi instruction

	usubaddxhi	r0, r0, r0
	usubaddxhi	r15, r15, r15

positive: usubaddxls instruction

	usubaddxls	r0, r0, r0
	usubaddxls	r15, r15, r15

positive: usubaddxge instruction

	usubaddxge	r0, r0, r0
	usubaddxge	r15, r15, r15

positive: usubaddxlt instruction

	usubaddxlt	r0, r0, r0
	usubaddxlt	r15, r15, r15

positive: usubaddxgt instruction

	usubaddxgt	r0, r0, r0
	usubaddxgt	r15, r15, r15

positive: usubaddxle instruction

	usubaddxle	r0, r0, r0
	usubaddxle	r15, r15, r15

positive: usubaddxal instruction

	usubaddxal	r0, r0, r0
	usubaddxal	r15, r15, r15

positive: uxtab instruction

	uxtab	r0, r0, r0
	uxtab	r15, r15, r15

positive: uxtabeq instruction

	uxtabeq	r0, r0, r0
	uxtabeq	r15, r15, r15

positive: uxtabne instruction

	uxtabne	r0, r0, r0
	uxtabne	r15, r15, r15

positive: uxtabcs instruction

	uxtabcs	r0, r0, r0
	uxtabcs	r15, r15, r15

positive: uxtabhs instruction

	uxtabhs	r0, r0, r0
	uxtabhs	r15, r15, r15

positive: uxtabcc instruction

	uxtabcc	r0, r0, r0
	uxtabcc	r15, r15, r15

positive: uxtablo instruction

	uxtablo	r0, r0, r0
	uxtablo	r15, r15, r15

positive: uxtabmi instruction

	uxtabmi	r0, r0, r0
	uxtabmi	r15, r15, r15

positive: uxtabpl instruction

	uxtabpl	r0, r0, r0
	uxtabpl	r15, r15, r15

positive: uxtabvs instruction

	uxtabvs	r0, r0, r0
	uxtabvs	r15, r15, r15

positive: uxtabvc instruction

	uxtabvc	r0, r0, r0
	uxtabvc	r15, r15, r15

positive: uxtabhi instruction

	uxtabhi	r0, r0, r0
	uxtabhi	r15, r15, r15

positive: uxtabls instruction

	uxtabls	r0, r0, r0
	uxtabls	r15, r15, r15

positive: uxtabge instruction

	uxtabge	r0, r0, r0
	uxtabge	r15, r15, r15

positive: uxtablt instruction

	uxtablt	r0, r0, r0
	uxtablt	r15, r15, r15

positive: uxtabgt instruction

	uxtabgt	r0, r0, r0
	uxtabgt	r15, r15, r15

positive: uxtable instruction

	uxtable	r0, r0, r0
	uxtable	r15, r15, r15

positive: uxtabal instruction

	uxtabal	r0, r0, r0
	uxtabal	r15, r15, r15

positive: uxtab16 instruction

	uxtab16	r0, r0, r0
	uxtab16	r15, r15, r15

positive: uxtab16eq instruction

	uxtab16eq	r0, r0, r0
	uxtab16eq	r15, r15, r15

positive: uxtab16ne instruction

	uxtab16ne	r0, r0, r0
	uxtab16ne	r15, r15, r15

positive: uxtab16cs instruction

	uxtab16cs	r0, r0, r0
	uxtab16cs	r15, r15, r15

positive: uxtab16hs instruction

	uxtab16hs	r0, r0, r0
	uxtab16hs	r15, r15, r15

positive: uxtab16cc instruction

	uxtab16cc	r0, r0, r0
	uxtab16cc	r15, r15, r15

positive: uxtab16lo instruction

	uxtab16lo	r0, r0, r0
	uxtab16lo	r15, r15, r15

positive: uxtab16mi instruction

	uxtab16mi	r0, r0, r0
	uxtab16mi	r15, r15, r15

positive: uxtab16pl instruction

	uxtab16pl	r0, r0, r0
	uxtab16pl	r15, r15, r15

positive: uxtab16vs instruction

	uxtab16vs	r0, r0, r0
	uxtab16vs	r15, r15, r15

positive: uxtab16vc instruction

	uxtab16vc	r0, r0, r0
	uxtab16vc	r15, r15, r15

positive: uxtab16hi instruction

	uxtab16hi	r0, r0, r0
	uxtab16hi	r15, r15, r15

positive: uxtab16ls instruction

	uxtab16ls	r0, r0, r0
	uxtab16ls	r15, r15, r15

positive: uxtab16ge instruction

	uxtab16ge	r0, r0, r0
	uxtab16ge	r15, r15, r15

positive: uxtab16lt instruction

	uxtab16lt	r0, r0, r0
	uxtab16lt	r15, r15, r15

positive: uxtab16gt instruction

	uxtab16gt	r0, r0, r0
	uxtab16gt	r15, r15, r15

positive: uxtab16le instruction

	uxtab16le	r0, r0, r0
	uxtab16le	r15, r15, r15

positive: uxtab16al instruction

	uxtab16al	r0, r0, r0
	uxtab16al	r15, r15, r15

positive: uxtah instruction

	uxtah	r0, r0, r0
	uxtah	r15, r15, r15

positive: uxtaheq instruction

	uxtaheq	r0, r0, r0
	uxtaheq	r15, r15, r15

positive: uxtahne instruction

	uxtahne	r0, r0, r0
	uxtahne	r15, r15, r15

positive: uxtahcs instruction

	uxtahcs	r0, r0, r0
	uxtahcs	r15, r15, r15

positive: uxtahhs instruction

	uxtahhs	r0, r0, r0
	uxtahhs	r15, r15, r15

positive: uxtahcc instruction

	uxtahcc	r0, r0, r0
	uxtahcc	r15, r15, r15

positive: uxtahlo instruction

	uxtahlo	r0, r0, r0
	uxtahlo	r15, r15, r15

positive: uxtahmi instruction

	uxtahmi	r0, r0, r0
	uxtahmi	r15, r15, r15

positive: uxtahpl instruction

	uxtahpl	r0, r0, r0
	uxtahpl	r15, r15, r15

positive: uxtahvs instruction

	uxtahvs	r0, r0, r0
	uxtahvs	r15, r15, r15

positive: uxtahvc instruction

	uxtahvc	r0, r0, r0
	uxtahvc	r15, r15, r15

positive: uxtahhi instruction

	uxtahhi	r0, r0, r0
	uxtahhi	r15, r15, r15

positive: uxtahls instruction

	uxtahls	r0, r0, r0
	uxtahls	r15, r15, r15

positive: uxtahge instruction

	uxtahge	r0, r0, r0
	uxtahge	r15, r15, r15

positive: uxtahlt instruction

	uxtahlt	r0, r0, r0
	uxtahlt	r15, r15, r15

positive: uxtahgt instruction

	uxtahgt	r0, r0, r0
	uxtahgt	r15, r15, r15

positive: uxtahle instruction

	uxtahle	r0, r0, r0
	uxtahle	r15, r15, r15

positive: uxtahal instruction

	uxtahal	r0, r0, r0
	uxtahal	r15, r15, r15

positive: uxtb instruction

	uxtb	r0, r0
	uxtb	r15, r15

positive: uxtbeq instruction

	uxtbeq	r0, r0
	uxtbeq	r15, r15

positive: uxtbne instruction

	uxtbne	r0, r0
	uxtbne	r15, r15

positive: uxtbcs instruction

	uxtbcs	r0, r0
	uxtbcs	r15, r15

positive: uxtbhs instruction

	uxtbhs	r0, r0
	uxtbhs	r15, r15

positive: uxtbcc instruction

	uxtbcc	r0, r0
	uxtbcc	r15, r15

positive: uxtblo instruction

	uxtblo	r0, r0
	uxtblo	r15, r15

positive: uxtbmi instruction

	uxtbmi	r0, r0
	uxtbmi	r15, r15

positive: uxtbpl instruction

	uxtbpl	r0, r0
	uxtbpl	r15, r15

positive: uxtbvs instruction

	uxtbvs	r0, r0
	uxtbvs	r15, r15

positive: uxtbvc instruction

	uxtbvc	r0, r0
	uxtbvc	r15, r15

positive: uxtbhi instruction

	uxtbhi	r0, r0
	uxtbhi	r15, r15

positive: uxtbls instruction

	uxtbls	r0, r0
	uxtbls	r15, r15

positive: uxtbge instruction

	uxtbge	r0, r0
	uxtbge	r15, r15

positive: uxtblt instruction

	uxtblt	r0, r0
	uxtblt	r15, r15

positive: uxtbgt instruction

	uxtbgt	r0, r0
	uxtbgt	r15, r15

positive: uxtble instruction

	uxtble	r0, r0
	uxtble	r15, r15

positive: uxtbal instruction

	uxtbal	r0, r0
	uxtbal	r15, r15

positive: uxtb16 instruction

	uxtb16	r0, r0
	uxtb16	r15, r15

positive: uxtb16eq instruction

	uxtb16eq	r0, r0
	uxtb16eq	r15, r15

positive: uxtb16ne instruction

	uxtb16ne	r0, r0
	uxtb16ne	r15, r15

positive: uxtb16cs instruction

	uxtb16cs	r0, r0
	uxtb16cs	r15, r15

positive: uxtb16hs instruction

	uxtb16hs	r0, r0
	uxtb16hs	r15, r15

positive: uxtb16cc instruction

	uxtb16cc	r0, r0
	uxtb16cc	r15, r15

positive: uxtb16lo instruction

	uxtb16lo	r0, r0
	uxtb16lo	r15, r15

positive: uxtb16mi instruction

	uxtb16mi	r0, r0
	uxtb16mi	r15, r15

positive: uxtb16pl instruction

	uxtb16pl	r0, r0
	uxtb16pl	r15, r15

positive: uxtb16vs instruction

	uxtb16vs	r0, r0
	uxtb16vs	r15, r15

positive: uxtb16vc instruction

	uxtb16vc	r0, r0
	uxtb16vc	r15, r15

positive: uxtb16hi instruction

	uxtb16hi	r0, r0
	uxtb16hi	r15, r15

positive: uxtb16ls instruction

	uxtb16ls	r0, r0
	uxtb16ls	r15, r15

positive: uxtb16ge instruction

	uxtb16ge	r0, r0
	uxtb16ge	r15, r15

positive: uxtb16lt instruction

	uxtb16lt	r0, r0
	uxtb16lt	r15, r15

positive: uxtb16gt instruction

	uxtb16gt	r0, r0
	uxtb16gt	r15, r15

positive: uxtb16le instruction

	uxtb16le	r0, r0
	uxtb16le	r15, r15

positive: uxtb16al instruction

	uxtb16al	r0, r0
	uxtb16al	r15, r15

positive: uxth instruction

	uxth	r0, r0
	uxth	r15, r15

positive: uxtheq instruction

	uxtheq	r0, r0
	uxtheq	r15, r15

positive: uxthne instruction

	uxthne	r0, r0
	uxthne	r15, r15

positive: uxthcs instruction

	uxthcs	r0, r0
	uxthcs	r15, r15

positive: uxthhs instruction

	uxthhs	r0, r0
	uxthhs	r15, r15

positive: uxthcc instruction

	uxthcc	r0, r0
	uxthcc	r15, r15

positive: uxthlo instruction

	uxthlo	r0, r0
	uxthlo	r15, r15

positive: uxthmi instruction

	uxthmi	r0, r0
	uxthmi	r15, r15

positive: uxthpl instruction

	uxthpl	r0, r0
	uxthpl	r15, r15

positive: uxthvs instruction

	uxthvs	r0, r0
	uxthvs	r15, r15

positive: uxthvc instruction

	uxthvc	r0, r0
	uxthvc	r15, r15

positive: uxthhi instruction

	uxthhi	r0, r0
	uxthhi	r15, r15

positive: uxthls instruction

	uxthls	r0, r0
	uxthls	r15, r15

positive: uxthge instruction

	uxthge	r0, r0
	uxthge	r15, r15

positive: uxthlt instruction

	uxthlt	r0, r0
	uxthlt	r15, r15

positive: uxthgt instruction

	uxthgt	r0, r0
	uxthgt	r15, r15

positive: uxthle instruction

	uxthle	r0, r0
	uxthle	r15, r15

positive: uxthal instruction

	uxthal	r0, r0
	uxthal	r15, r15

positive: wfe instruction

	wfe

positive: wfeeq instruction

	wfeeq

positive: wfene instruction

	wfene

positive: wfecs instruction

	wfecs

positive: wfehs instruction

	wfehs

positive: wfecc instruction

	wfecc

positive: wfelo instruction

	wfelo

positive: wfemi instruction

	wfemi

positive: wfepl instruction

	wfepl

positive: wfevs instruction

	wfevs

positive: wfevc instruction

	wfevc

positive: wfehi instruction

	wfehi

positive: wfels instruction

	wfels

positive: wfege instruction

	wfege

positive: wfelt instruction

	wfelt

positive: wfegt instruction

	wfegt

positive: wfele instruction

	wfele

positive: wfeal instruction

	wfeal

positive: wfi instruction

	wfi

positive: wfieq instruction

	wfieq

positive: wfine instruction

	wfine

positive: wfics instruction

	wfics

positive: wfihs instruction

	wfihs

positive: wficc instruction

	wficc

positive: wfilo instruction

	wfilo

positive: wfimi instruction

	wfimi

positive: wfipl instruction

	wfipl

positive: wfivs instruction

	wfivs

positive: wfivc instruction

	wfivc

positive: wfihi instruction

	wfihi

positive: wfils instruction

	wfils

positive: wfige instruction

	wfige

positive: wfilt instruction

	wfilt

positive: wfigt instruction

	wfigt

positive: wfile instruction

	wfile

positive: wfial instruction

	wfial

positive: yield instruction

	yield

positive: yieldeq instruction

	yieldeq

positive: yieldne instruction

	yieldne

positive: yieldcs instruction

	yieldcs

positive: yieldhs instruction

	yieldhs

positive: yieldcc instruction

	yieldcc

positive: yieldlo instruction

	yieldlo

positive: yieldmi instruction

	yieldmi

positive: yieldpl instruction

	yieldpl

positive: yieldvs instruction

	yieldvs

positive: yieldvc instruction

	yieldvc

positive: yieldhi instruction

	yieldhi

positive: yieldls instruction

	yieldls

positive: yieldge instruction

	yieldge

positive: yieldlt instruction

	yieldlt

positive: yieldgt instruction

	yieldgt

positive: yieldle instruction

	yieldle

positive: yieldal instruction

	yieldal

positive: fabsd instruction

	fabsd	d0, d0
	fabsd	d15, d15

positive: fabsdeq instruction

	fabsdeq	d0, d0
	fabsdeq	d15, d15

positive: fabsdne instruction

	fabsdne	d0, d0
	fabsdne	d15, d15

positive: fabsdcs instruction

	fabsdcs	d0, d0
	fabsdcs	d15, d15

positive: fabsdhs instruction

	fabsdhs	d0, d0
	fabsdhs	d15, d15

positive: fabsdcc instruction

	fabsdcc	d0, d0
	fabsdcc	d15, d15

positive: fabsdlo instruction

	fabsdlo	d0, d0
	fabsdlo	d15, d15

positive: fabsdmi instruction

	fabsdmi	d0, d0
	fabsdmi	d15, d15

positive: fabsdpl instruction

	fabsdpl	d0, d0
	fabsdpl	d15, d15

positive: fabsdvs instruction

	fabsdvs	d0, d0
	fabsdvs	d15, d15

positive: fabsdvc instruction

	fabsdvc	d0, d0
	fabsdvc	d15, d15

positive: fabsdhi instruction

	fabsdhi	d0, d0
	fabsdhi	d15, d15

positive: fabsdls instruction

	fabsdls	d0, d0
	fabsdls	d15, d15

positive: fabsdge instruction

	fabsdge	d0, d0
	fabsdge	d15, d15

positive: fabsdlt instruction

	fabsdlt	d0, d0
	fabsdlt	d15, d15

positive: fabsdgt instruction

	fabsdgt	d0, d0
	fabsdgt	d15, d15

positive: fabsdle instruction

	fabsdle	d0, d0
	fabsdle	d15, d15

positive: fabsdal instruction

	fabsdal	d0, d0
	fabsdal	d15, d15

positive: fabss instruction

	fabss	s0, s0
	fabss	s31, s31

positive: fabsseq instruction

	fabsseq	s0, s0
	fabsseq	s31, s31

positive: fabssne instruction

	fabssne	s0, s0
	fabssne	s31, s31

positive: fabsscs instruction

	fabsscs	s0, s0
	fabsscs	s31, s31

positive: fabsshs instruction

	fabsshs	s0, s0
	fabsshs	s31, s31

positive: fabsscc instruction

	fabsscc	s0, s0
	fabsscc	s31, s31

positive: fabsslo instruction

	fabsslo	s0, s0
	fabsslo	s31, s31

positive: fabssmi instruction

	fabssmi	s0, s0
	fabssmi	s31, s31

positive: fabsspl instruction

	fabsspl	s0, s0
	fabsspl	s31, s31

positive: fabssvs instruction

	fabssvs	s0, s0
	fabssvs	s31, s31

positive: fabssvc instruction

	fabssvc	s0, s0
	fabssvc	s31, s31

positive: fabsshi instruction

	fabsshi	s0, s0
	fabsshi	s31, s31

positive: fabssls instruction

	fabssls	s0, s0
	fabssls	s31, s31

positive: fabssge instruction

	fabssge	s0, s0
	fabssge	s31, s31

positive: fabsslt instruction

	fabsslt	s0, s0
	fabsslt	s31, s31

positive: fabssgt instruction

	fabssgt	s0, s0
	fabssgt	s31, s31

positive: fabssle instruction

	fabssle	s0, s0
	fabssle	s31, s31

positive: fabssal instruction

	fabssal	s0, s0
	fabssal	s31, s31

positive: faddd instruction

	faddd	d0, d0, d0
	faddd	d15, d15, d15

positive: fadddeq instruction

	fadddeq	d0, d0, d0
	fadddeq	d15, d15, d15

positive: fadddne instruction

	fadddne	d0, d0, d0
	fadddne	d15, d15, d15

positive: fadddcs instruction

	fadddcs	d0, d0, d0
	fadddcs	d15, d15, d15

positive: fadddhs instruction

	fadddhs	d0, d0, d0
	fadddhs	d15, d15, d15

positive: fadddcc instruction

	fadddcc	d0, d0, d0
	fadddcc	d15, d15, d15

positive: fadddlo instruction

	fadddlo	d0, d0, d0
	fadddlo	d15, d15, d15

positive: fadddmi instruction

	fadddmi	d0, d0, d0
	fadddmi	d15, d15, d15

positive: fadddpl instruction

	fadddpl	d0, d0, d0
	fadddpl	d15, d15, d15

positive: fadddvs instruction

	fadddvs	d0, d0, d0
	fadddvs	d15, d15, d15

positive: fadddvc instruction

	fadddvc	d0, d0, d0
	fadddvc	d15, d15, d15

positive: fadddhi instruction

	fadddhi	d0, d0, d0
	fadddhi	d15, d15, d15

positive: fadddls instruction

	fadddls	d0, d0, d0
	fadddls	d15, d15, d15

positive: fadddge instruction

	fadddge	d0, d0, d0
	fadddge	d15, d15, d15

positive: fadddlt instruction

	fadddlt	d0, d0, d0
	fadddlt	d15, d15, d15

positive: fadddgt instruction

	fadddgt	d0, d0, d0
	fadddgt	d15, d15, d15

positive: fadddle instruction

	fadddle	d0, d0, d0
	fadddle	d15, d15, d15

positive: fadddal instruction

	fadddal	d0, d0, d0
	fadddal	d15, d15, d15

positive: fadds instruction

	fadds	s0, s0, s0
	fadds	s31, s31, s31

positive: faddseq instruction

	faddseq	s0, s0, s0
	faddseq	s31, s31, s31

positive: faddsne instruction

	faddsne	s0, s0, s0
	faddsne	s31, s31, s31

positive: faddscs instruction

	faddscs	s0, s0, s0
	faddscs	s31, s31, s31

positive: faddshs instruction

	faddshs	s0, s0, s0
	faddshs	s31, s31, s31

positive: faddscc instruction

	faddscc	s0, s0, s0
	faddscc	s31, s31, s31

positive: faddslo instruction

	faddslo	s0, s0, s0
	faddslo	s31, s31, s31

positive: faddsmi instruction

	faddsmi	s0, s0, s0
	faddsmi	s31, s31, s31

positive: faddspl instruction

	faddspl	s0, s0, s0
	faddspl	s31, s31, s31

positive: faddsvs instruction

	faddsvs	s0, s0, s0
	faddsvs	s31, s31, s31

positive: faddsvc instruction

	faddsvc	s0, s0, s0
	faddsvc	s31, s31, s31

positive: faddshi instruction

	faddshi	s0, s0, s0
	faddshi	s31, s31, s31

positive: faddsls instruction

	faddsls	s0, s0, s0
	faddsls	s31, s31, s31

positive: faddsge instruction

	faddsge	s0, s0, s0
	faddsge	s31, s31, s31

positive: faddslt instruction

	faddslt	s0, s0, s0
	faddslt	s31, s31, s31

positive: faddsgt instruction

	faddsgt	s0, s0, s0
	faddsgt	s31, s31, s31

positive: faddsle instruction

	faddsle	s0, s0, s0
	faddsle	s31, s31, s31

positive: faddsal instruction

	faddsal	s0, s0, s0
	faddsal	s31, s31, s31

positive: fcmpd instruction

	fcmpd	d0, d0
	fcmpd	d15, d15

positive: fcmpdeq instruction

	fcmpdeq	d0, d0
	fcmpdeq	d15, d15

positive: fcmpdne instruction

	fcmpdne	d0, d0
	fcmpdne	d15, d15

positive: fcmpdcs instruction

	fcmpdcs	d0, d0
	fcmpdcs	d15, d15

positive: fcmpdhs instruction

	fcmpdhs	d0, d0
	fcmpdhs	d15, d15

positive: fcmpdcc instruction

	fcmpdcc	d0, d0
	fcmpdcc	d15, d15

positive: fcmpdlo instruction

	fcmpdlo	d0, d0
	fcmpdlo	d15, d15

positive: fcmpdmi instruction

	fcmpdmi	d0, d0
	fcmpdmi	d15, d15

positive: fcmpdpl instruction

	fcmpdpl	d0, d0
	fcmpdpl	d15, d15

positive: fcmpdvs instruction

	fcmpdvs	d0, d0
	fcmpdvs	d15, d15

positive: fcmpdvc instruction

	fcmpdvc	d0, d0
	fcmpdvc	d15, d15

positive: fcmpdhi instruction

	fcmpdhi	d0, d0
	fcmpdhi	d15, d15

positive: fcmpdls instruction

	fcmpdls	d0, d0
	fcmpdls	d15, d15

positive: fcmpdge instruction

	fcmpdge	d0, d0
	fcmpdge	d15, d15

positive: fcmpdlt instruction

	fcmpdlt	d0, d0
	fcmpdlt	d15, d15

positive: fcmpdgt instruction

	fcmpdgt	d0, d0
	fcmpdgt	d15, d15

positive: fcmpdle instruction

	fcmpdle	d0, d0
	fcmpdle	d15, d15

positive: fcmpdal instruction

	fcmpdal	d0, d0
	fcmpdal	d15, d15

positive: fcmped instruction

	fcmped	d0, d0
	fcmped	d15, d15

positive: fcmpedeq instruction

	fcmpedeq	d0, d0
	fcmpedeq	d15, d15

positive: fcmpedne instruction

	fcmpedne	d0, d0
	fcmpedne	d15, d15

positive: fcmpedcs instruction

	fcmpedcs	d0, d0
	fcmpedcs	d15, d15

positive: fcmpedhs instruction

	fcmpedhs	d0, d0
	fcmpedhs	d15, d15

positive: fcmpedcc instruction

	fcmpedcc	d0, d0
	fcmpedcc	d15, d15

positive: fcmpedlo instruction

	fcmpedlo	d0, d0
	fcmpedlo	d15, d15

positive: fcmpedmi instruction

	fcmpedmi	d0, d0
	fcmpedmi	d15, d15

positive: fcmpedpl instruction

	fcmpedpl	d0, d0
	fcmpedpl	d15, d15

positive: fcmpedvs instruction

	fcmpedvs	d0, d0
	fcmpedvs	d15, d15

positive: fcmpedvc instruction

	fcmpedvc	d0, d0
	fcmpedvc	d15, d15

positive: fcmpedhi instruction

	fcmpedhi	d0, d0
	fcmpedhi	d15, d15

positive: fcmpedls instruction

	fcmpedls	d0, d0
	fcmpedls	d15, d15

positive: fcmpedge instruction

	fcmpedge	d0, d0
	fcmpedge	d15, d15

positive: fcmpedlt instruction

	fcmpedlt	d0, d0
	fcmpedlt	d15, d15

positive: fcmpedgt instruction

	fcmpedgt	d0, d0
	fcmpedgt	d15, d15

positive: fcmpedle instruction

	fcmpedle	d0, d0
	fcmpedle	d15, d15

positive: fcmpedal instruction

	fcmpedal	d0, d0
	fcmpedal	d15, d15

positive: fcmpes instruction

	fcmpes	s0, s0
	fcmpes	s31, s31

positive: fcmpeseq instruction

	fcmpeseq	s0, s0
	fcmpeseq	s31, s31

positive: fcmpesne instruction

	fcmpesne	s0, s0
	fcmpesne	s31, s31

positive: fcmpescs instruction

	fcmpescs	s0, s0
	fcmpescs	s31, s31

positive: fcmpeshs instruction

	fcmpeshs	s0, s0
	fcmpeshs	s31, s31

positive: fcmpescc instruction

	fcmpescc	s0, s0
	fcmpescc	s31, s31

positive: fcmpeslo instruction

	fcmpeslo	s0, s0
	fcmpeslo	s31, s31

positive: fcmpesmi instruction

	fcmpesmi	s0, s0
	fcmpesmi	s31, s31

positive: fcmpespl instruction

	fcmpespl	s0, s0
	fcmpespl	s31, s31

positive: fcmpesvs instruction

	fcmpesvs	s0, s0
	fcmpesvs	s31, s31

positive: fcmpesvc instruction

	fcmpesvc	s0, s0
	fcmpesvc	s31, s31

positive: fcmpeshi instruction

	fcmpeshi	s0, s0
	fcmpeshi	s31, s31

positive: fcmpesls instruction

	fcmpesls	s0, s0
	fcmpesls	s31, s31

positive: fcmpesge instruction

	fcmpesge	s0, s0
	fcmpesge	s31, s31

positive: fcmpeslt instruction

	fcmpeslt	s0, s0
	fcmpeslt	s31, s31

positive: fcmpesgt instruction

	fcmpesgt	s0, s0
	fcmpesgt	s31, s31

positive: fcmpesle instruction

	fcmpesle	s0, s0
	fcmpesle	s31, s31

positive: fcmpesal instruction

	fcmpesal	s0, s0
	fcmpesal	s31, s31

positive: fcmpezd instruction

	fcmpezd	d0
	fcmpezd	d15

positive: fcmpezdeq instruction

	fcmpezdeq	d0
	fcmpezdeq	d15

positive: fcmpezdne instruction

	fcmpezdne	d0
	fcmpezdne	d15

positive: fcmpezdcs instruction

	fcmpezdcs	d0
	fcmpezdcs	d15

positive: fcmpezdhs instruction

	fcmpezdhs	d0
	fcmpezdhs	d15

positive: fcmpezdcc instruction

	fcmpezdcc	d0
	fcmpezdcc	d15

positive: fcmpezdlo instruction

	fcmpezdlo	d0
	fcmpezdlo	d15

positive: fcmpezdmi instruction

	fcmpezdmi	d0
	fcmpezdmi	d15

positive: fcmpezdpl instruction

	fcmpezdpl	d0
	fcmpezdpl	d15

positive: fcmpezdvs instruction

	fcmpezdvs	d0
	fcmpezdvs	d15

positive: fcmpezdvc instruction

	fcmpezdvc	d0
	fcmpezdvc	d15

positive: fcmpezdhi instruction

	fcmpezdhi	d0
	fcmpezdhi	d15

positive: fcmpezdls instruction

	fcmpezdls	d0
	fcmpezdls	d15

positive: fcmpezdge instruction

	fcmpezdge	d0
	fcmpezdge	d15

positive: fcmpezdlt instruction

	fcmpezdlt	d0
	fcmpezdlt	d15

positive: fcmpezdgt instruction

	fcmpezdgt	d0
	fcmpezdgt	d15

positive: fcmpezdle instruction

	fcmpezdle	d0
	fcmpezdle	d15

positive: fcmpezdal instruction

	fcmpezdal	d0
	fcmpezdal	d15

positive: fcmpezs instruction

	fcmpezs	s0
	fcmpezs	s31

positive: fcmpezseq instruction

	fcmpezseq	s0
	fcmpezseq	s31

positive: fcmpezsne instruction

	fcmpezsne	s0
	fcmpezsne	s31

positive: fcmpezscs instruction

	fcmpezscs	s0
	fcmpezscs	s31

positive: fcmpezshs instruction

	fcmpezshs	s0
	fcmpezshs	s31

positive: fcmpezscc instruction

	fcmpezscc	s0
	fcmpezscc	s31

positive: fcmpezslo instruction

	fcmpezslo	s0
	fcmpezslo	s31

positive: fcmpezsmi instruction

	fcmpezsmi	s0
	fcmpezsmi	s31

positive: fcmpezspl instruction

	fcmpezspl	s0
	fcmpezspl	s31

positive: fcmpezsvs instruction

	fcmpezsvs	s0
	fcmpezsvs	s31

positive: fcmpezsvc instruction

	fcmpezsvc	s0
	fcmpezsvc	s31

positive: fcmpezshi instruction

	fcmpezshi	s0
	fcmpezshi	s31

positive: fcmpezsls instruction

	fcmpezsls	s0
	fcmpezsls	s31

positive: fcmpezsge instruction

	fcmpezsge	s0
	fcmpezsge	s31

positive: fcmpezslt instruction

	fcmpezslt	s0
	fcmpezslt	s31

positive: fcmpezsgt instruction

	fcmpezsgt	s0
	fcmpezsgt	s31

positive: fcmpezsle instruction

	fcmpezsle	s0
	fcmpezsle	s31

positive: fcmpezsal instruction

	fcmpezsal	s0
	fcmpezsal	s31

positive: fcmps instruction

	fcmps	s0, s0
	fcmps	s31, s31

positive: fcmpseq instruction

	fcmpseq	s0, s0
	fcmpseq	s31, s31

positive: fcmpsne instruction

	fcmpsne	s0, s0
	fcmpsne	s31, s31

positive: fcmpscs instruction

	fcmpscs	s0, s0
	fcmpscs	s31, s31

positive: fcmpshs instruction

	fcmpshs	s0, s0
	fcmpshs	s31, s31

positive: fcmpscc instruction

	fcmpscc	s0, s0
	fcmpscc	s31, s31

positive: fcmpslo instruction

	fcmpslo	s0, s0
	fcmpslo	s31, s31

positive: fcmpsmi instruction

	fcmpsmi	s0, s0
	fcmpsmi	s31, s31

positive: fcmpspl instruction

	fcmpspl	s0, s0
	fcmpspl	s31, s31

positive: fcmpsvs instruction

	fcmpsvs	s0, s0
	fcmpsvs	s31, s31

positive: fcmpsvc instruction

	fcmpsvc	s0, s0
	fcmpsvc	s31, s31

positive: fcmpshi instruction

	fcmpshi	s0, s0
	fcmpshi	s31, s31

positive: fcmpsls instruction

	fcmpsls	s0, s0
	fcmpsls	s31, s31

positive: fcmpsge instruction

	fcmpsge	s0, s0
	fcmpsge	s31, s31

positive: fcmpslt instruction

	fcmpslt	s0, s0
	fcmpslt	s31, s31

positive: fcmpsgt instruction

	fcmpsgt	s0, s0
	fcmpsgt	s31, s31

positive: fcmpsle instruction

	fcmpsle	s0, s0
	fcmpsle	s31, s31

positive: fcmpsal instruction

	fcmpsal	s0, s0
	fcmpsal	s31, s31

positive: fcmpzd instruction

	fcmpzd	d0
	fcmpzd	d15

positive: fcmpzdeq instruction

	fcmpzdeq	d0
	fcmpzdeq	d15

positive: fcmpzdne instruction

	fcmpzdne	d0
	fcmpzdne	d15

positive: fcmpzdcs instruction

	fcmpzdcs	d0
	fcmpzdcs	d15

positive: fcmpzdhs instruction

	fcmpzdhs	d0
	fcmpzdhs	d15

positive: fcmpzdcc instruction

	fcmpzdcc	d0
	fcmpzdcc	d15

positive: fcmpzdlo instruction

	fcmpzdlo	d0
	fcmpzdlo	d15

positive: fcmpzdmi instruction

	fcmpzdmi	d0
	fcmpzdmi	d15

positive: fcmpzdpl instruction

	fcmpzdpl	d0
	fcmpzdpl	d15

positive: fcmpzdvs instruction

	fcmpzdvs	d0
	fcmpzdvs	d15

positive: fcmpzdvc instruction

	fcmpzdvc	d0
	fcmpzdvc	d15

positive: fcmpzdhi instruction

	fcmpzdhi	d0
	fcmpzdhi	d15

positive: fcmpzdls instruction

	fcmpzdls	d0
	fcmpzdls	d15

positive: fcmpzdge instruction

	fcmpzdge	d0
	fcmpzdge	d15

positive: fcmpzdlt instruction

	fcmpzdlt	d0
	fcmpzdlt	d15

positive: fcmpzdgt instruction

	fcmpzdgt	d0
	fcmpzdgt	d15

positive: fcmpzdle instruction

	fcmpzdle	d0
	fcmpzdle	d15

positive: fcmpzdal instruction

	fcmpzdal	d0
	fcmpzdal	d15

positive: fcmpzs instruction

	fcmpzs	s0
	fcmpzs	s31

positive: fcmpzseq instruction

	fcmpzseq	s0
	fcmpzseq	s31

positive: fcmpzsne instruction

	fcmpzsne	s0
	fcmpzsne	s31

positive: fcmpzscs instruction

	fcmpzscs	s0
	fcmpzscs	s31

positive: fcmpzshs instruction

	fcmpzshs	s0
	fcmpzshs	s31

positive: fcmpzscc instruction

	fcmpzscc	s0
	fcmpzscc	s31

positive: fcmpzslo instruction

	fcmpzslo	s0
	fcmpzslo	s31

positive: fcmpzsmi instruction

	fcmpzsmi	s0
	fcmpzsmi	s31

positive: fcmpzspl instruction

	fcmpzspl	s0
	fcmpzspl	s31

positive: fcmpzsvs instruction

	fcmpzsvs	s0
	fcmpzsvs	s31

positive: fcmpzsvc instruction

	fcmpzsvc	s0
	fcmpzsvc	s31

positive: fcmpzshi instruction

	fcmpzshi	s0
	fcmpzshi	s31

positive: fcmpzsls instruction

	fcmpzsls	s0
	fcmpzsls	s31

positive: fcmpzsge instruction

	fcmpzsge	s0
	fcmpzsge	s31

positive: fcmpzslt instruction

	fcmpzslt	s0
	fcmpzslt	s31

positive: fcmpzsgt instruction

	fcmpzsgt	s0
	fcmpzsgt	s31

positive: fcmpzsle instruction

	fcmpzsle	s0
	fcmpzsle	s31

positive: fcmpzsal instruction

	fcmpzsal	s0
	fcmpzsal	s31

positive: fcpyd instruction

	fcpyd	d0, d0
	fcpyd	d15, d15

positive: fcpydeq instruction

	fcpydeq	d0, d0
	fcpydeq	d15, d15

positive: fcpydne instruction

	fcpydne	d0, d0
	fcpydne	d15, d15

positive: fcpydcs instruction

	fcpydcs	d0, d0
	fcpydcs	d15, d15

positive: fcpydhs instruction

	fcpydhs	d0, d0
	fcpydhs	d15, d15

positive: fcpydcc instruction

	fcpydcc	d0, d0
	fcpydcc	d15, d15

positive: fcpydlo instruction

	fcpydlo	d0, d0
	fcpydlo	d15, d15

positive: fcpydmi instruction

	fcpydmi	d0, d0
	fcpydmi	d15, d15

positive: fcpydpl instruction

	fcpydpl	d0, d0
	fcpydpl	d15, d15

positive: fcpydvs instruction

	fcpydvs	d0, d0
	fcpydvs	d15, d15

positive: fcpydvc instruction

	fcpydvc	d0, d0
	fcpydvc	d15, d15

positive: fcpydhi instruction

	fcpydhi	d0, d0
	fcpydhi	d15, d15

positive: fcpydls instruction

	fcpydls	d0, d0
	fcpydls	d15, d15

positive: fcpydge instruction

	fcpydge	d0, d0
	fcpydge	d15, d15

positive: fcpydlt instruction

	fcpydlt	d0, d0
	fcpydlt	d15, d15

positive: fcpydgt instruction

	fcpydgt	d0, d0
	fcpydgt	d15, d15

positive: fcpydle instruction

	fcpydle	d0, d0
	fcpydle	d15, d15

positive: fcpydal instruction

	fcpydal	d0, d0
	fcpydal	d15, d15

positive: fcpys instruction

	fcpys	s0, s0
	fcpys	s31, s31

positive: fcpyseq instruction

	fcpyseq	s0, s0
	fcpyseq	s31, s31

positive: fcpysne instruction

	fcpysne	s0, s0
	fcpysne	s31, s31

positive: fcpyscs instruction

	fcpyscs	s0, s0
	fcpyscs	s31, s31

positive: fcpyshs instruction

	fcpyshs	s0, s0
	fcpyshs	s31, s31

positive: fcpyscc instruction

	fcpyscc	s0, s0
	fcpyscc	s31, s31

positive: fcpyslo instruction

	fcpyslo	s0, s0
	fcpyslo	s31, s31

positive: fcpysmi instruction

	fcpysmi	s0, s0
	fcpysmi	s31, s31

positive: fcpyspl instruction

	fcpyspl	s0, s0
	fcpyspl	s31, s31

positive: fcpysvs instruction

	fcpysvs	s0, s0
	fcpysvs	s31, s31

positive: fcpysvc instruction

	fcpysvc	s0, s0
	fcpysvc	s31, s31

positive: fcpyshi instruction

	fcpyshi	s0, s0
	fcpyshi	s31, s31

positive: fcpysls instruction

	fcpysls	s0, s0
	fcpysls	s31, s31

positive: fcpysge instruction

	fcpysge	s0, s0
	fcpysge	s31, s31

positive: fcpyslt instruction

	fcpyslt	s0, s0
	fcpyslt	s31, s31

positive: fcpysgt instruction

	fcpysgt	s0, s0
	fcpysgt	s31, s31

positive: fcpysle instruction

	fcpysle	s0, s0
	fcpysle	s31, s31

positive: fcpysal instruction

	fcpysal	s0, s0
	fcpysal	s31, s31

positive: fcvtds instruction

	fcvtds	d0, s0
	fcvtds	d15, s31

positive: fcvtdseq instruction

	fcvtdseq	d0, s0
	fcvtdseq	d15, s31

positive: fcvtdsne instruction

	fcvtdsne	d0, s0
	fcvtdsne	d15, s31

positive: fcvtdscs instruction

	fcvtdscs	d0, s0
	fcvtdscs	d15, s31

positive: fcvtdshs instruction

	fcvtdshs	d0, s0
	fcvtdshs	d15, s31

positive: fcvtdscc instruction

	fcvtdscc	d0, s0
	fcvtdscc	d15, s31

positive: fcvtdslo instruction

	fcvtdslo	d0, s0
	fcvtdslo	d15, s31

positive: fcvtdsmi instruction

	fcvtdsmi	d0, s0
	fcvtdsmi	d15, s31

positive: fcvtdspl instruction

	fcvtdspl	d0, s0
	fcvtdspl	d15, s31

positive: fcvtdsvs instruction

	fcvtdsvs	d0, s0
	fcvtdsvs	d15, s31

positive: fcvtdsvc instruction

	fcvtdsvc	d0, s0
	fcvtdsvc	d15, s31

positive: fcvtdshi instruction

	fcvtdshi	d0, s0
	fcvtdshi	d15, s31

positive: fcvtdsls instruction

	fcvtdsls	d0, s0
	fcvtdsls	d15, s31

positive: fcvtdsge instruction

	fcvtdsge	d0, s0
	fcvtdsge	d15, s31

positive: fcvtdslt instruction

	fcvtdslt	d0, s0
	fcvtdslt	d15, s31

positive: fcvtdsgt instruction

	fcvtdsgt	d0, s0
	fcvtdsgt	d15, s31

positive: fcvtdsle instruction

	fcvtdsle	d0, s0
	fcvtdsle	d15, s31

positive: fcvtdsal instruction

	fcvtdsal	d0, s0
	fcvtdsal	d15, s31

positive: fcvtsd instruction

	fcvtsd	s0, d0
	fcvtsd	s31, d15

positive: fcvtsdeq instruction

	fcvtsdeq	s0, d0
	fcvtsdeq	s31, d15

positive: fcvtsdne instruction

	fcvtsdne	s0, d0
	fcvtsdne	s31, d15

positive: fcvtsdcs instruction

	fcvtsdcs	s0, d0
	fcvtsdcs	s31, d15

positive: fcvtsdhs instruction

	fcvtsdhs	s0, d0
	fcvtsdhs	s31, d15

positive: fcvtsdcc instruction

	fcvtsdcc	s0, d0
	fcvtsdcc	s31, d15

positive: fcvtsdlo instruction

	fcvtsdlo	s0, d0
	fcvtsdlo	s31, d15

positive: fcvtsdmi instruction

	fcvtsdmi	s0, d0
	fcvtsdmi	s31, d15

positive: fcvtsdpl instruction

	fcvtsdpl	s0, d0
	fcvtsdpl	s31, d15

positive: fcvtsdvs instruction

	fcvtsdvs	s0, d0
	fcvtsdvs	s31, d15

positive: fcvtsdvc instruction

	fcvtsdvc	s0, d0
	fcvtsdvc	s31, d15

positive: fcvtsdhi instruction

	fcvtsdhi	s0, d0
	fcvtsdhi	s31, d15

positive: fcvtsdls instruction

	fcvtsdls	s0, d0
	fcvtsdls	s31, d15

positive: fcvtsdge instruction

	fcvtsdge	s0, d0
	fcvtsdge	s31, d15

positive: fcvtsdlt instruction

	fcvtsdlt	s0, d0
	fcvtsdlt	s31, d15

positive: fcvtsdgt instruction

	fcvtsdgt	s0, d0
	fcvtsdgt	s31, d15

positive: fcvtsdle instruction

	fcvtsdle	s0, d0
	fcvtsdle	s31, d15

positive: fcvtsdal instruction

	fcvtsdal	s0, d0
	fcvtsdal	s31, d15

positive: fdivd instruction

	fdivd	d0, d0, d0
	fdivd	d15, d15, d15

positive: fdivdeq instruction

	fdivdeq	d0, d0, d0
	fdivdeq	d15, d15, d15

positive: fdivdne instruction

	fdivdne	d0, d0, d0
	fdivdne	d15, d15, d15

positive: fdivdcs instruction

	fdivdcs	d0, d0, d0
	fdivdcs	d15, d15, d15

positive: fdivdhs instruction

	fdivdhs	d0, d0, d0
	fdivdhs	d15, d15, d15

positive: fdivdcc instruction

	fdivdcc	d0, d0, d0
	fdivdcc	d15, d15, d15

positive: fdivdlo instruction

	fdivdlo	d0, d0, d0
	fdivdlo	d15, d15, d15

positive: fdivdmi instruction

	fdivdmi	d0, d0, d0
	fdivdmi	d15, d15, d15

positive: fdivdpl instruction

	fdivdpl	d0, d0, d0
	fdivdpl	d15, d15, d15

positive: fdivdvs instruction

	fdivdvs	d0, d0, d0
	fdivdvs	d15, d15, d15

positive: fdivdvc instruction

	fdivdvc	d0, d0, d0
	fdivdvc	d15, d15, d15

positive: fdivdhi instruction

	fdivdhi	d0, d0, d0
	fdivdhi	d15, d15, d15

positive: fdivdls instruction

	fdivdls	d0, d0, d0
	fdivdls	d15, d15, d15

positive: fdivdge instruction

	fdivdge	d0, d0, d0
	fdivdge	d15, d15, d15

positive: fdivdlt instruction

	fdivdlt	d0, d0, d0
	fdivdlt	d15, d15, d15

positive: fdivdgt instruction

	fdivdgt	d0, d0, d0
	fdivdgt	d15, d15, d15

positive: fdivdle instruction

	fdivdle	d0, d0, d0
	fdivdle	d15, d15, d15

positive: fdivdal instruction

	fdivdal	d0, d0, d0
	fdivdal	d15, d15, d15

positive: fdivs instruction

	fdivs	s0, s0, s0
	fdivs	s31, s31, s31

positive: fdivseq instruction

	fdivseq	s0, s0, s0
	fdivseq	s31, s31, s31

positive: fdivsne instruction

	fdivsne	s0, s0, s0
	fdivsne	s31, s31, s31

positive: fdivscs instruction

	fdivscs	s0, s0, s0
	fdivscs	s31, s31, s31

positive: fdivshs instruction

	fdivshs	s0, s0, s0
	fdivshs	s31, s31, s31

positive: fdivscc instruction

	fdivscc	s0, s0, s0
	fdivscc	s31, s31, s31

positive: fdivslo instruction

	fdivslo	s0, s0, s0
	fdivslo	s31, s31, s31

positive: fdivsmi instruction

	fdivsmi	s0, s0, s0
	fdivsmi	s31, s31, s31

positive: fdivspl instruction

	fdivspl	s0, s0, s0
	fdivspl	s31, s31, s31

positive: fdivsvs instruction

	fdivsvs	s0, s0, s0
	fdivsvs	s31, s31, s31

positive: fdivsvc instruction

	fdivsvc	s0, s0, s0
	fdivsvc	s31, s31, s31

positive: fdivshi instruction

	fdivshi	s0, s0, s0
	fdivshi	s31, s31, s31

positive: fdivsls instruction

	fdivsls	s0, s0, s0
	fdivsls	s31, s31, s31

positive: fdivsge instruction

	fdivsge	s0, s0, s0
	fdivsge	s31, s31, s31

positive: fdivslt instruction

	fdivslt	s0, s0, s0
	fdivslt	s31, s31, s31

positive: fdivsgt instruction

	fdivsgt	s0, s0, s0
	fdivsgt	s31, s31, s31

positive: fdivsle instruction

	fdivsle	s0, s0, s0
	fdivsle	s31, s31, s31

positive: fdivsal instruction

	fdivsal	s0, s0, s0
	fdivsal	s31, s31, s31

positive: fldd instruction

	fldd	d0, [r0]
	fldd	d15, [r15]
	fldd	d0, [r0, -1020]
	fldd	d15, [r15, +1020]

positive: flddeq instruction

	flddeq	d0, [r0]
	flddeq	d15, [r15]
	flddeq	d0, [r0, -1020]
	flddeq	d15, [r15, +1020]

positive: flddne instruction

	flddne	d0, [r0]
	flddne	d15, [r15]
	flddne	d0, [r0, -1020]
	flddne	d15, [r15, +1020]

positive: flddcs instruction

	flddcs	d0, [r0]
	flddcs	d15, [r15]
	flddcs	d0, [r0, -1020]
	flddcs	d15, [r15, +1020]

positive: flddhs instruction

	flddhs	d0, [r0]
	flddhs	d15, [r15]
	flddhs	d0, [r0, -1020]
	flddhs	d15, [r15, +1020]

positive: flddcc instruction

	flddcc	d0, [r0]
	flddcc	d15, [r15]
	flddcc	d0, [r0, -1020]
	flddcc	d15, [r15, +1020]

positive: flddlo instruction

	flddlo	d0, [r0]
	flddlo	d15, [r15]
	flddlo	d0, [r0, -1020]
	flddlo	d15, [r15, +1020]

positive: flddmi instruction

	flddmi	d0, [r0]
	flddmi	d15, [r15]
	flddmi	d0, [r0, -1020]
	flddmi	d15, [r15, +1020]

positive: flddpl instruction

	flddpl	d0, [r0]
	flddpl	d15, [r15]
	flddpl	d0, [r0, -1020]
	flddpl	d15, [r15, +1020]

positive: flddvs instruction

	flddvs	d0, [r0]
	flddvs	d15, [r15]
	flddvs	d0, [r0, -1020]
	flddvs	d15, [r15, +1020]

positive: flddvc instruction

	flddvc	d0, [r0]
	flddvc	d15, [r15]
	flddvc	d0, [r0, -1020]
	flddvc	d15, [r15, +1020]

positive: flddhi instruction

	flddhi	d0, [r0]
	flddhi	d15, [r15]
	flddhi	d0, [r0, -1020]
	flddhi	d15, [r15, +1020]

positive: flddls instruction

	flddls	d0, [r0]
	flddls	d15, [r15]
	flddls	d0, [r0, -1020]
	flddls	d15, [r15, +1020]

positive: flddge instruction

	flddge	d0, [r0]
	flddge	d15, [r15]
	flddge	d0, [r0, -1020]
	flddge	d15, [r15, +1020]

positive: flddlt instruction

	flddlt	d0, [r0]
	flddlt	d15, [r15]
	flddlt	d0, [r0, -1020]
	flddlt	d15, [r15, +1020]

positive: flddgt instruction

	flddgt	d0, [r0]
	flddgt	d15, [r15]
	flddgt	d0, [r0, -1020]
	flddgt	d15, [r15, +1020]

positive: flddle instruction

	flddle	d0, [r0]
	flddle	d15, [r15]
	flddle	d0, [r0, -1020]
	flddle	d15, [r15, +1020]

positive: flddal instruction

	flddal	d0, [r0]
	flddal	d15, [r15]
	flddal	d0, [r0, -1020]
	flddal	d15, [r15, +1020]

positive: flds instruction

	flds	s0, [r0]
	flds	s31, [r15]
	flds	s0, [r0, -1020]
	flds	s31, [r15, +1020]

positive: fldseq instruction

	fldseq	s0, [r0]
	fldseq	s31, [r15]
	fldseq	s0, [r0, -1020]
	fldseq	s31, [r15, +1020]

positive: fldsne instruction

	fldsne	s0, [r0]
	fldsne	s31, [r15]
	fldsne	s0, [r0, -1020]
	fldsne	s31, [r15, +1020]

positive: fldscs instruction

	fldscs	s0, [r0]
	fldscs	s31, [r15]
	fldscs	s0, [r0, -1020]
	fldscs	s31, [r15, +1020]

positive: fldshs instruction

	fldshs	s0, [r0]
	fldshs	s31, [r15]
	fldshs	s0, [r0, -1020]
	fldshs	s31, [r15, +1020]

positive: fldscc instruction

	fldscc	s0, [r0]
	fldscc	s31, [r15]
	fldscc	s0, [r0, -1020]
	fldscc	s31, [r15, +1020]

positive: fldslo instruction

	fldslo	s0, [r0]
	fldslo	s31, [r15]
	fldslo	s0, [r0, -1020]
	fldslo	s31, [r15, +1020]

positive: fldsmi instruction

	fldsmi	s0, [r0]
	fldsmi	s31, [r15]
	fldsmi	s0, [r0, -1020]
	fldsmi	s31, [r15, +1020]

positive: fldspl instruction

	fldspl	s0, [r0]
	fldspl	s31, [r15]
	fldspl	s0, [r0, -1020]
	fldspl	s31, [r15, +1020]

positive: fldsvs instruction

	fldsvs	s0, [r0]
	fldsvs	s31, [r15]
	fldsvs	s0, [r0, -1020]
	fldsvs	s31, [r15, +1020]

positive: fldsvc instruction

	fldsvc	s0, [r0]
	fldsvc	s31, [r15]
	fldsvc	s0, [r0, -1020]
	fldsvc	s31, [r15, +1020]

positive: fldshi instruction

	fldshi	s0, [r0]
	fldshi	s31, [r15]
	fldshi	s0, [r0, -1020]
	fldshi	s31, [r15, +1020]

positive: fldsls instruction

	fldsls	s0, [r0]
	fldsls	s31, [r15]
	fldsls	s0, [r0, -1020]
	fldsls	s31, [r15, +1020]

positive: fldsge instruction

	fldsge	s0, [r0]
	fldsge	s31, [r15]
	fldsge	s0, [r0, -1020]
	fldsge	s31, [r15, +1020]

positive: fldslt instruction

	fldslt	s0, [r0]
	fldslt	s31, [r15]
	fldslt	s0, [r0, -1020]
	fldslt	s31, [r15, +1020]

positive: fldsgt instruction

	fldsgt	s0, [r0]
	fldsgt	s31, [r15]
	fldsgt	s0, [r0, -1020]
	fldsgt	s31, [r15, +1020]

positive: fldsle instruction

	fldsle	s0, [r0]
	fldsle	s31, [r15]
	fldsle	s0, [r0, -1020]
	fldsle	s31, [r15, +1020]

positive: fldsal instruction

	fldsal	s0, [r0]
	fldsal	s31, [r15]
	fldsal	s0, [r0, -1020]
	fldsal	s31, [r15, +1020]

positive: fldmiad instruction

	fldmiad	r0, {d0}
	fldmiad	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiad	r0 !, {d0}
	fldmiad	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadeq instruction

	fldmiadeq	r0, {d0}
	fldmiadeq	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadeq	r0 !, {d0}
	fldmiadeq	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadne instruction

	fldmiadne	r0, {d0}
	fldmiadne	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadne	r0 !, {d0}
	fldmiadne	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadcs instruction

	fldmiadcs	r0, {d0}
	fldmiadcs	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadcs	r0 !, {d0}
	fldmiadcs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadhs instruction

	fldmiadhs	r0, {d0}
	fldmiadhs	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadhs	r0 !, {d0}
	fldmiadhs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadcc instruction

	fldmiadcc	r0, {d0}
	fldmiadcc	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadcc	r0 !, {d0}
	fldmiadcc	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadlo instruction

	fldmiadlo	r0, {d0}
	fldmiadlo	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadlo	r0 !, {d0}
	fldmiadlo	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadmi instruction

	fldmiadmi	r0, {d0}
	fldmiadmi	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadmi	r0 !, {d0}
	fldmiadmi	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadpl instruction

	fldmiadpl	r0, {d0}
	fldmiadpl	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadpl	r0 !, {d0}
	fldmiadpl	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadvs instruction

	fldmiadvs	r0, {d0}
	fldmiadvs	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadvs	r0 !, {d0}
	fldmiadvs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadvc instruction

	fldmiadvc	r0, {d0}
	fldmiadvc	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadvc	r0 !, {d0}
	fldmiadvc	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadhi instruction

	fldmiadhi	r0, {d0}
	fldmiadhi	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadhi	r0 !, {d0}
	fldmiadhi	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadls instruction

	fldmiadls	r0, {d0}
	fldmiadls	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadls	r0 !, {d0}
	fldmiadls	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadge instruction

	fldmiadge	r0, {d0}
	fldmiadge	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadge	r0 !, {d0}
	fldmiadge	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadlt instruction

	fldmiadlt	r0, {d0}
	fldmiadlt	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadlt	r0 !, {d0}
	fldmiadlt	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadgt instruction

	fldmiadgt	r0, {d0}
	fldmiadgt	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadgt	r0 !, {d0}
	fldmiadgt	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadle instruction

	fldmiadle	r0, {d0}
	fldmiadle	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadle	r0 !, {d0}
	fldmiadle	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmiadal instruction

	fldmiadal	r0, {d0}
	fldmiadal	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fldmiadal	r0 !, {d0}
	fldmiadal	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbd instruction

	fldmdbd	r0 !, {d0}
	fldmdbd	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdeq instruction

	fldmdbdeq	r0 !, {d0}
	fldmdbdeq	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdne instruction

	fldmdbdne	r0 !, {d0}
	fldmdbdne	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdcs instruction

	fldmdbdcs	r0 !, {d0}
	fldmdbdcs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdhs instruction

	fldmdbdhs	r0 !, {d0}
	fldmdbdhs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdcc instruction

	fldmdbdcc	r0 !, {d0}
	fldmdbdcc	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdlo instruction

	fldmdbdlo	r0 !, {d0}
	fldmdbdlo	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdmi instruction

	fldmdbdmi	r0 !, {d0}
	fldmdbdmi	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdpl instruction

	fldmdbdpl	r0 !, {d0}
	fldmdbdpl	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdvs instruction

	fldmdbdvs	r0 !, {d0}
	fldmdbdvs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdvc instruction

	fldmdbdvc	r0 !, {d0}
	fldmdbdvc	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdhi instruction

	fldmdbdhi	r0 !, {d0}
	fldmdbdhi	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdls instruction

	fldmdbdls	r0 !, {d0}
	fldmdbdls	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdge instruction

	fldmdbdge	r0 !, {d0}
	fldmdbdge	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdlt instruction

	fldmdbdlt	r0 !, {d0}
	fldmdbdlt	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdgt instruction

	fldmdbdgt	r0 !, {d0}
	fldmdbdgt	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdle instruction

	fldmdbdle	r0 !, {d0}
	fldmdbdle	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmdbdal instruction

	fldmdbdal	r0 !, {d0}
	fldmdbdal	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fldmias instruction

	fldmias	r0, {s0}
	fldmias	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmias	r0 !, {s0}
	fldmias	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiaseq instruction

	fldmiaseq	r0, {s0}
	fldmiaseq	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiaseq	r0 !, {s0}
	fldmiaseq	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasne instruction

	fldmiasne	r0, {s0}
	fldmiasne	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasne	r0 !, {s0}
	fldmiasne	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiascs instruction

	fldmiascs	r0, {s0}
	fldmiascs	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiascs	r0 !, {s0}
	fldmiascs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiashs instruction

	fldmiashs	r0, {s0}
	fldmiashs	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiashs	r0 !, {s0}
	fldmiashs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiascc instruction

	fldmiascc	r0, {s0}
	fldmiascc	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiascc	r0 !, {s0}
	fldmiascc	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiaslo instruction

	fldmiaslo	r0, {s0}
	fldmiaslo	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiaslo	r0 !, {s0}
	fldmiaslo	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasmi instruction

	fldmiasmi	r0, {s0}
	fldmiasmi	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasmi	r0 !, {s0}
	fldmiasmi	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiaspl instruction

	fldmiaspl	r0, {s0}
	fldmiaspl	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiaspl	r0 !, {s0}
	fldmiaspl	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasvs instruction

	fldmiasvs	r0, {s0}
	fldmiasvs	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasvs	r0 !, {s0}
	fldmiasvs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasvc instruction

	fldmiasvc	r0, {s0}
	fldmiasvc	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasvc	r0 !, {s0}
	fldmiasvc	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiashi instruction

	fldmiashi	r0, {s0}
	fldmiashi	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiashi	r0 !, {s0}
	fldmiashi	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasls instruction

	fldmiasls	r0, {s0}
	fldmiasls	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasls	r0 !, {s0}
	fldmiasls	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasge instruction

	fldmiasge	r0, {s0}
	fldmiasge	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasge	r0 !, {s0}
	fldmiasge	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiaslt instruction

	fldmiaslt	r0, {s0}
	fldmiaslt	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiaslt	r0 !, {s0}
	fldmiaslt	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasgt instruction

	fldmiasgt	r0, {s0}
	fldmiasgt	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasgt	r0 !, {s0}
	fldmiasgt	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasle instruction

	fldmiasle	r0, {s0}
	fldmiasle	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasle	r0 !, {s0}
	fldmiasle	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmiasal instruction

	fldmiasal	r0, {s0}
	fldmiasal	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fldmiasal	r0 !, {s0}
	fldmiasal	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbs instruction

	fldmdbs	r0 !, {s0}
	fldmdbs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbseq instruction

	fldmdbseq	r0 !, {s0}
	fldmdbseq	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsne instruction

	fldmdbsne	r0 !, {s0}
	fldmdbsne	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbscs instruction

	fldmdbscs	r0 !, {s0}
	fldmdbscs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbshs instruction

	fldmdbshs	r0 !, {s0}
	fldmdbshs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbscc instruction

	fldmdbscc	r0 !, {s0}
	fldmdbscc	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbslo instruction

	fldmdbslo	r0 !, {s0}
	fldmdbslo	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsmi instruction

	fldmdbsmi	r0 !, {s0}
	fldmdbsmi	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbspl instruction

	fldmdbspl	r0 !, {s0}
	fldmdbspl	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsvs instruction

	fldmdbsvs	r0 !, {s0}
	fldmdbsvs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsvc instruction

	fldmdbsvc	r0 !, {s0}
	fldmdbsvc	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbshi instruction

	fldmdbshi	r0 !, {s0}
	fldmdbshi	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsls instruction

	fldmdbsls	r0 !, {s0}
	fldmdbsls	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsge instruction

	fldmdbsge	r0 !, {s0}
	fldmdbsge	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbslt instruction

	fldmdbslt	r0 !, {s0}
	fldmdbslt	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsgt instruction

	fldmdbsgt	r0 !, {s0}
	fldmdbsgt	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsle instruction

	fldmdbsle	r0 !, {s0}
	fldmdbsle	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fldmdbsal instruction

	fldmdbsal	r0 !, {s0}
	fldmdbsal	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fmacd instruction

	fmacd	d0, d0, d0
	fmacd	d15, d15, d15

positive: fmacdeq instruction

	fmacdeq	d0, d0, d0
	fmacdeq	d15, d15, d15

positive: fmacdne instruction

	fmacdne	d0, d0, d0
	fmacdne	d15, d15, d15

positive: fmacdcs instruction

	fmacdcs	d0, d0, d0
	fmacdcs	d15, d15, d15

positive: fmacdhs instruction

	fmacdhs	d0, d0, d0
	fmacdhs	d15, d15, d15

positive: fmacdcc instruction

	fmacdcc	d0, d0, d0
	fmacdcc	d15, d15, d15

positive: fmacdlo instruction

	fmacdlo	d0, d0, d0
	fmacdlo	d15, d15, d15

positive: fmacdmi instruction

	fmacdmi	d0, d0, d0
	fmacdmi	d15, d15, d15

positive: fmacdpl instruction

	fmacdpl	d0, d0, d0
	fmacdpl	d15, d15, d15

positive: fmacdvs instruction

	fmacdvs	d0, d0, d0
	fmacdvs	d15, d15, d15

positive: fmacdvc instruction

	fmacdvc	d0, d0, d0
	fmacdvc	d15, d15, d15

positive: fmacdhi instruction

	fmacdhi	d0, d0, d0
	fmacdhi	d15, d15, d15

positive: fmacdls instruction

	fmacdls	d0, d0, d0
	fmacdls	d15, d15, d15

positive: fmacdge instruction

	fmacdge	d0, d0, d0
	fmacdge	d15, d15, d15

positive: fmacdlt instruction

	fmacdlt	d0, d0, d0
	fmacdlt	d15, d15, d15

positive: fmacdgt instruction

	fmacdgt	d0, d0, d0
	fmacdgt	d15, d15, d15

positive: fmacdle instruction

	fmacdle	d0, d0, d0
	fmacdle	d15, d15, d15

positive: fmacdal instruction

	fmacdal	d0, d0, d0
	fmacdal	d15, d15, d15

positive: fmacs instruction

	fmacs	s0, s0, s0
	fmacs	s31, s31, s31

positive: fmacseq instruction

	fmacseq	s0, s0, s0
	fmacseq	s31, s31, s31

positive: fmacsne instruction

	fmacsne	s0, s0, s0
	fmacsne	s31, s31, s31

positive: fmacscs instruction

	fmacscs	s0, s0, s0
	fmacscs	s31, s31, s31

positive: fmacshs instruction

	fmacshs	s0, s0, s0
	fmacshs	s31, s31, s31

positive: fmacscc instruction

	fmacscc	s0, s0, s0
	fmacscc	s31, s31, s31

positive: fmacslo instruction

	fmacslo	s0, s0, s0
	fmacslo	s31, s31, s31

positive: fmacsmi instruction

	fmacsmi	s0, s0, s0
	fmacsmi	s31, s31, s31

positive: fmacspl instruction

	fmacspl	s0, s0, s0
	fmacspl	s31, s31, s31

positive: fmacsvs instruction

	fmacsvs	s0, s0, s0
	fmacsvs	s31, s31, s31

positive: fmacsvc instruction

	fmacsvc	s0, s0, s0
	fmacsvc	s31, s31, s31

positive: fmacshi instruction

	fmacshi	s0, s0, s0
	fmacshi	s31, s31, s31

positive: fmacsls instruction

	fmacsls	s0, s0, s0
	fmacsls	s31, s31, s31

positive: fmacsge instruction

	fmacsge	s0, s0, s0
	fmacsge	s31, s31, s31

positive: fmacslt instruction

	fmacslt	s0, s0, s0
	fmacslt	s31, s31, s31

positive: fmacsgt instruction

	fmacsgt	s0, s0, s0
	fmacsgt	s31, s31, s31

positive: fmacsle instruction

	fmacsle	s0, s0, s0
	fmacsle	s31, s31, s31

positive: fmacsal instruction

	fmacsal	s0, s0, s0
	fmacsal	s31, s31, s31

positive: fmdhr instruction

	fmdhr	d0, r0
	fmdhr	d15, r15

positive: fmdhreq instruction

	fmdhreq	d0, r0
	fmdhreq	d15, r15

positive: fmdhrne instruction

	fmdhrne	d0, r0
	fmdhrne	d15, r15

positive: fmdhrcs instruction

	fmdhrcs	d0, r0
	fmdhrcs	d15, r15

positive: fmdhrhs instruction

	fmdhrhs	d0, r0
	fmdhrhs	d15, r15

positive: fmdhrcc instruction

	fmdhrcc	d0, r0
	fmdhrcc	d15, r15

positive: fmdhrlo instruction

	fmdhrlo	d0, r0
	fmdhrlo	d15, r15

positive: fmdhrmi instruction

	fmdhrmi	d0, r0
	fmdhrmi	d15, r15

positive: fmdhrpl instruction

	fmdhrpl	d0, r0
	fmdhrpl	d15, r15

positive: fmdhrvs instruction

	fmdhrvs	d0, r0
	fmdhrvs	d15, r15

positive: fmdhrvc instruction

	fmdhrvc	d0, r0
	fmdhrvc	d15, r15

positive: fmdhrhi instruction

	fmdhrhi	d0, r0
	fmdhrhi	d15, r15

positive: fmdhrls instruction

	fmdhrls	d0, r0
	fmdhrls	d15, r15

positive: fmdhrge instruction

	fmdhrge	d0, r0
	fmdhrge	d15, r15

positive: fmdhrlt instruction

	fmdhrlt	d0, r0
	fmdhrlt	d15, r15

positive: fmdhrgt instruction

	fmdhrgt	d0, r0
	fmdhrgt	d15, r15

positive: fmdhrle instruction

	fmdhrle	d0, r0
	fmdhrle	d15, r15

positive: fmdhral instruction

	fmdhral	d0, r0
	fmdhral	d15, r15

positive: fmdlr instruction

	fmdlr	d0, r0
	fmdlr	d15, r15

positive: fmdlreq instruction

	fmdlreq	d0, r0
	fmdlreq	d15, r15

positive: fmdlrne instruction

	fmdlrne	d0, r0
	fmdlrne	d15, r15

positive: fmdlrcs instruction

	fmdlrcs	d0, r0
	fmdlrcs	d15, r15

positive: fmdlrhs instruction

	fmdlrhs	d0, r0
	fmdlrhs	d15, r15

positive: fmdlrcc instruction

	fmdlrcc	d0, r0
	fmdlrcc	d15, r15

positive: fmdlrlo instruction

	fmdlrlo	d0, r0
	fmdlrlo	d15, r15

positive: fmdlrmi instruction

	fmdlrmi	d0, r0
	fmdlrmi	d15, r15

positive: fmdlrpl instruction

	fmdlrpl	d0, r0
	fmdlrpl	d15, r15

positive: fmdlrvs instruction

	fmdlrvs	d0, r0
	fmdlrvs	d15, r15

positive: fmdlrvc instruction

	fmdlrvc	d0, r0
	fmdlrvc	d15, r15

positive: fmdlrhi instruction

	fmdlrhi	d0, r0
	fmdlrhi	d15, r15

positive: fmdlrls instruction

	fmdlrls	d0, r0
	fmdlrls	d15, r15

positive: fmdlrge instruction

	fmdlrge	d0, r0
	fmdlrge	d15, r15

positive: fmdlrlt instruction

	fmdlrlt	d0, r0
	fmdlrlt	d15, r15

positive: fmdlrgt instruction

	fmdlrgt	d0, r0
	fmdlrgt	d15, r15

positive: fmdlrle instruction

	fmdlrle	d0, r0
	fmdlrle	d15, r15

positive: fmdlral instruction

	fmdlral	d0, r0
	fmdlral	d15, r15

positive: fmdrr instruction

	fmdrr	d0, r0, r0
	fmdrr	d15, r15, r15

positive: fmdrreq instruction

	fmdrreq	d0, r0, r0
	fmdrreq	d15, r15, r15

positive: fmdrrne instruction

	fmdrrne	d0, r0, r0
	fmdrrne	d15, r15, r15

positive: fmdrrcs instruction

	fmdrrcs	d0, r0, r0
	fmdrrcs	d15, r15, r15

positive: fmdrrhs instruction

	fmdrrhs	d0, r0, r0
	fmdrrhs	d15, r15, r15

positive: fmdrrcc instruction

	fmdrrcc	d0, r0, r0
	fmdrrcc	d15, r15, r15

positive: fmdrrlo instruction

	fmdrrlo	d0, r0, r0
	fmdrrlo	d15, r15, r15

positive: fmdrrmi instruction

	fmdrrmi	d0, r0, r0
	fmdrrmi	d15, r15, r15

positive: fmdrrpl instruction

	fmdrrpl	d0, r0, r0
	fmdrrpl	d15, r15, r15

positive: fmdrrvs instruction

	fmdrrvs	d0, r0, r0
	fmdrrvs	d15, r15, r15

positive: fmdrrvc instruction

	fmdrrvc	d0, r0, r0
	fmdrrvc	d15, r15, r15

positive: fmdrrhi instruction

	fmdrrhi	d0, r0, r0
	fmdrrhi	d15, r15, r15

positive: fmdrrls instruction

	fmdrrls	d0, r0, r0
	fmdrrls	d15, r15, r15

positive: fmdrrge instruction

	fmdrrge	d0, r0, r0
	fmdrrge	d15, r15, r15

positive: fmdrrlt instruction

	fmdrrlt	d0, r0, r0
	fmdrrlt	d15, r15, r15

positive: fmdrrgt instruction

	fmdrrgt	d0, r0, r0
	fmdrrgt	d15, r15, r15

positive: fmdrrle instruction

	fmdrrle	d0, r0, r0
	fmdrrle	d15, r15, r15

positive: fmdrral instruction

	fmdrral	d0, r0, r0
	fmdrral	d15, r15, r15

positive: fmrdh instruction

	fmrdh	r0, d0
	fmrdh	r15, d15

positive: fmrdheq instruction

	fmrdheq	r0, d0
	fmrdheq	r15, d15

positive: fmrdhne instruction

	fmrdhne	r0, d0
	fmrdhne	r15, d15

positive: fmrdhcs instruction

	fmrdhcs	r0, d0
	fmrdhcs	r15, d15

positive: fmrdhhs instruction

	fmrdhhs	r0, d0
	fmrdhhs	r15, d15

positive: fmrdhcc instruction

	fmrdhcc	r0, d0
	fmrdhcc	r15, d15

positive: fmrdhlo instruction

	fmrdhlo	r0, d0
	fmrdhlo	r15, d15

positive: fmrdhmi instruction

	fmrdhmi	r0, d0
	fmrdhmi	r15, d15

positive: fmrdhpl instruction

	fmrdhpl	r0, d0
	fmrdhpl	r15, d15

positive: fmrdhvs instruction

	fmrdhvs	r0, d0
	fmrdhvs	r15, d15

positive: fmrdhvc instruction

	fmrdhvc	r0, d0
	fmrdhvc	r15, d15

positive: fmrdhhi instruction

	fmrdhhi	r0, d0
	fmrdhhi	r15, d15

positive: fmrdhls instruction

	fmrdhls	r0, d0
	fmrdhls	r15, d15

positive: fmrdhge instruction

	fmrdhge	r0, d0
	fmrdhge	r15, d15

positive: fmrdhlt instruction

	fmrdhlt	r0, d0
	fmrdhlt	r15, d15

positive: fmrdhgt instruction

	fmrdhgt	r0, d0
	fmrdhgt	r15, d15

positive: fmrdhle instruction

	fmrdhle	r0, d0
	fmrdhle	r15, d15

positive: fmrdhal instruction

	fmrdhal	r0, d0
	fmrdhal	r15, d15

positive: fmrdl instruction

	fmrdl	r0, d0
	fmrdl	r15, d15

positive: fmrdleq instruction

	fmrdleq	r0, d0
	fmrdleq	r15, d15

positive: fmrdlne instruction

	fmrdlne	r0, d0
	fmrdlne	r15, d15

positive: fmrdlcs instruction

	fmrdlcs	r0, d0
	fmrdlcs	r15, d15

positive: fmrdlhs instruction

	fmrdlhs	r0, d0
	fmrdlhs	r15, d15

positive: fmrdlcc instruction

	fmrdlcc	r0, d0
	fmrdlcc	r15, d15

positive: fmrdllo instruction

	fmrdllo	r0, d0
	fmrdllo	r15, d15

positive: fmrdlmi instruction

	fmrdlmi	r0, d0
	fmrdlmi	r15, d15

positive: fmrdlpl instruction

	fmrdlpl	r0, d0
	fmrdlpl	r15, d15

positive: fmrdlvs instruction

	fmrdlvs	r0, d0
	fmrdlvs	r15, d15

positive: fmrdlvc instruction

	fmrdlvc	r0, d0
	fmrdlvc	r15, d15

positive: fmrdlhi instruction

	fmrdlhi	r0, d0
	fmrdlhi	r15, d15

positive: fmrdlls instruction

	fmrdlls	r0, d0
	fmrdlls	r15, d15

positive: fmrdlge instruction

	fmrdlge	r0, d0
	fmrdlge	r15, d15

positive: fmrdllt instruction

	fmrdllt	r0, d0
	fmrdllt	r15, d15

positive: fmrdlgt instruction

	fmrdlgt	r0, d0
	fmrdlgt	r15, d15

positive: fmrdlle instruction

	fmrdlle	r0, d0
	fmrdlle	r15, d15

positive: fmrdlal instruction

	fmrdlal	r0, d0
	fmrdlal	r15, d15

positive: fmrrd instruction

	fmrrd	r0, r0, d0
	fmrrd	r15, r15, d15

positive: fmrrdeq instruction

	fmrrdeq	r0, r0, d0
	fmrrdeq	r15, r15, d15

positive: fmrrdne instruction

	fmrrdne	r0, r0, d0
	fmrrdne	r15, r15, d15

positive: fmrrdcs instruction

	fmrrdcs	r0, r0, d0
	fmrrdcs	r15, r15, d15

positive: fmrrdhs instruction

	fmrrdhs	r0, r0, d0
	fmrrdhs	r15, r15, d15

positive: fmrrdcc instruction

	fmrrdcc	r0, r0, d0
	fmrrdcc	r15, r15, d15

positive: fmrrdlo instruction

	fmrrdlo	r0, r0, d0
	fmrrdlo	r15, r15, d15

positive: fmrrdmi instruction

	fmrrdmi	r0, r0, d0
	fmrrdmi	r15, r15, d15

positive: fmrrdpl instruction

	fmrrdpl	r0, r0, d0
	fmrrdpl	r15, r15, d15

positive: fmrrdvs instruction

	fmrrdvs	r0, r0, d0
	fmrrdvs	r15, r15, d15

positive: fmrrdvc instruction

	fmrrdvc	r0, r0, d0
	fmrrdvc	r15, r15, d15

positive: fmrrdhi instruction

	fmrrdhi	r0, r0, d0
	fmrrdhi	r15, r15, d15

positive: fmrrdls instruction

	fmrrdls	r0, r0, d0
	fmrrdls	r15, r15, d15

positive: fmrrdge instruction

	fmrrdge	r0, r0, d0
	fmrrdge	r15, r15, d15

positive: fmrrdlt instruction

	fmrrdlt	r0, r0, d0
	fmrrdlt	r15, r15, d15

positive: fmrrdgt instruction

	fmrrdgt	r0, r0, d0
	fmrrdgt	r15, r15, d15

positive: fmrrdle instruction

	fmrrdle	r0, r0, d0
	fmrrdle	r15, r15, d15

positive: fmrrdal instruction

	fmrrdal	r0, r0, d0
	fmrrdal	r15, r15, d15

positive: fmrrs instruction

	fmrrs	r0, r0, s0
	fmrrs	r15, r15, s31

positive: fmrrseq instruction

	fmrrseq	r0, r0, s0
	fmrrseq	r15, r15, s31

positive: fmrrsne instruction

	fmrrsne	r0, r0, s0
	fmrrsne	r15, r15, s31

positive: fmrrscs instruction

	fmrrscs	r0, r0, s0
	fmrrscs	r15, r15, s31

positive: fmrrshs instruction

	fmrrshs	r0, r0, s0
	fmrrshs	r15, r15, s31

positive: fmrrscc instruction

	fmrrscc	r0, r0, s0
	fmrrscc	r15, r15, s31

positive: fmrrslo instruction

	fmrrslo	r0, r0, s0
	fmrrslo	r15, r15, s31

positive: fmrrsmi instruction

	fmrrsmi	r0, r0, s0
	fmrrsmi	r15, r15, s31

positive: fmrrspl instruction

	fmrrspl	r0, r0, s0
	fmrrspl	r15, r15, s31

positive: fmrrsvs instruction

	fmrrsvs	r0, r0, s0
	fmrrsvs	r15, r15, s31

positive: fmrrsvc instruction

	fmrrsvc	r0, r0, s0
	fmrrsvc	r15, r15, s31

positive: fmrrshi instruction

	fmrrshi	r0, r0, s0
	fmrrshi	r15, r15, s31

positive: fmrrsls instruction

	fmrrsls	r0, r0, s0
	fmrrsls	r15, r15, s31

positive: fmrrsge instruction

	fmrrsge	r0, r0, s0
	fmrrsge	r15, r15, s31

positive: fmrrslt instruction

	fmrrslt	r0, r0, s0
	fmrrslt	r15, r15, s31

positive: fmrrsgt instruction

	fmrrsgt	r0, r0, s0
	fmrrsgt	r15, r15, s31

positive: fmrrsle instruction

	fmrrsle	r0, r0, s0
	fmrrsle	r15, r15, s31

positive: fmrrsal instruction

	fmrrsal	r0, r0, s0
	fmrrsal	r15, r15, s31

positive: fmrs instruction

	fmrs	r0, s0
	fmrs	r15, s31

positive: fmrseq instruction

	fmrseq	r0, s0
	fmrseq	r15, s31

positive: fmrsne instruction

	fmrsne	r0, s0
	fmrsne	r15, s31

positive: fmrscs instruction

	fmrscs	r0, s0
	fmrscs	r15, s31

positive: fmrshs instruction

	fmrshs	r0, s0
	fmrshs	r15, s31

positive: fmrscc instruction

	fmrscc	r0, s0
	fmrscc	r15, s31

positive: fmrslo instruction

	fmrslo	r0, s0
	fmrslo	r15, s31

positive: fmrsmi instruction

	fmrsmi	r0, s0
	fmrsmi	r15, s31

positive: fmrspl instruction

	fmrspl	r0, s0
	fmrspl	r15, s31

positive: fmrsvs instruction

	fmrsvs	r0, s0
	fmrsvs	r15, s31

positive: fmrsvc instruction

	fmrsvc	r0, s0
	fmrsvc	r15, s31

positive: fmrshi instruction

	fmrshi	r0, s0
	fmrshi	r15, s31

positive: fmrsls instruction

	fmrsls	r0, s0
	fmrsls	r15, s31

positive: fmrsge instruction

	fmrsge	r0, s0
	fmrsge	r15, s31

positive: fmrslt instruction

	fmrslt	r0, s0
	fmrslt	r15, s31

positive: fmrsgt instruction

	fmrsgt	r0, s0
	fmrsgt	r15, s31

positive: fmrsle instruction

	fmrsle	r0, s0
	fmrsle	r15, s31

positive: fmrsal instruction

	fmrsal	r0, s0
	fmrsal	r15, s31

positive: fmscd instruction

	fmscd	d0, d0, d0
	fmscd	d15, d15, d15

positive: fmscdeq instruction

	fmscdeq	d0, d0, d0
	fmscdeq	d15, d15, d15

positive: fmscdne instruction

	fmscdne	d0, d0, d0
	fmscdne	d15, d15, d15

positive: fmscdcs instruction

	fmscdcs	d0, d0, d0
	fmscdcs	d15, d15, d15

positive: fmscdhs instruction

	fmscdhs	d0, d0, d0
	fmscdhs	d15, d15, d15

positive: fmscdcc instruction

	fmscdcc	d0, d0, d0
	fmscdcc	d15, d15, d15

positive: fmscdlo instruction

	fmscdlo	d0, d0, d0
	fmscdlo	d15, d15, d15

positive: fmscdmi instruction

	fmscdmi	d0, d0, d0
	fmscdmi	d15, d15, d15

positive: fmscdpl instruction

	fmscdpl	d0, d0, d0
	fmscdpl	d15, d15, d15

positive: fmscdvs instruction

	fmscdvs	d0, d0, d0
	fmscdvs	d15, d15, d15

positive: fmscdvc instruction

	fmscdvc	d0, d0, d0
	fmscdvc	d15, d15, d15

positive: fmscdhi instruction

	fmscdhi	d0, d0, d0
	fmscdhi	d15, d15, d15

positive: fmscdls instruction

	fmscdls	d0, d0, d0
	fmscdls	d15, d15, d15

positive: fmscdge instruction

	fmscdge	d0, d0, d0
	fmscdge	d15, d15, d15

positive: fmscdlt instruction

	fmscdlt	d0, d0, d0
	fmscdlt	d15, d15, d15

positive: fmscdgt instruction

	fmscdgt	d0, d0, d0
	fmscdgt	d15, d15, d15

positive: fmscdle instruction

	fmscdle	d0, d0, d0
	fmscdle	d15, d15, d15

positive: fmscdal instruction

	fmscdal	d0, d0, d0
	fmscdal	d15, d15, d15

positive: fmscs instruction

	fmscs	s0, s0, s0
	fmscs	s31, s31, s31

positive: fmscseq instruction

	fmscseq	s0, s0, s0
	fmscseq	s31, s31, s31

positive: fmscsne instruction

	fmscsne	s0, s0, s0
	fmscsne	s31, s31, s31

positive: fmscscs instruction

	fmscscs	s0, s0, s0
	fmscscs	s31, s31, s31

positive: fmscshs instruction

	fmscshs	s0, s0, s0
	fmscshs	s31, s31, s31

positive: fmscscc instruction

	fmscscc	s0, s0, s0
	fmscscc	s31, s31, s31

positive: fmscslo instruction

	fmscslo	s0, s0, s0
	fmscslo	s31, s31, s31

positive: fmscsmi instruction

	fmscsmi	s0, s0, s0
	fmscsmi	s31, s31, s31

positive: fmscspl instruction

	fmscspl	s0, s0, s0
	fmscspl	s31, s31, s31

positive: fmscsvs instruction

	fmscsvs	s0, s0, s0
	fmscsvs	s31, s31, s31

positive: fmscsvc instruction

	fmscsvc	s0, s0, s0
	fmscsvc	s31, s31, s31

positive: fmscshi instruction

	fmscshi	s0, s0, s0
	fmscshi	s31, s31, s31

positive: fmscsls instruction

	fmscsls	s0, s0, s0
	fmscsls	s31, s31, s31

positive: fmscsge instruction

	fmscsge	s0, s0, s0
	fmscsge	s31, s31, s31

positive: fmscslt instruction

	fmscslt	s0, s0, s0
	fmscslt	s31, s31, s31

positive: fmscsgt instruction

	fmscsgt	s0, s0, s0
	fmscsgt	s31, s31, s31

positive: fmscsle instruction

	fmscsle	s0, s0, s0
	fmscsle	s31, s31, s31

positive: fmscsal instruction

	fmscsal	s0, s0, s0
	fmscsal	s31, s31, s31

positive: fmsr instruction

	fmsr	s0, r0
	fmsr	s31, r15

positive: fmsreq instruction

	fmsreq	s0, r0
	fmsreq	s31, r15

positive: fmsrne instruction

	fmsrne	s0, r0
	fmsrne	s31, r15

positive: fmsrcs instruction

	fmsrcs	s0, r0
	fmsrcs	s31, r15

positive: fmsrhs instruction

	fmsrhs	s0, r0
	fmsrhs	s31, r15

positive: fmsrcc instruction

	fmsrcc	s0, r0
	fmsrcc	s31, r15

positive: fmsrlo instruction

	fmsrlo	s0, r0
	fmsrlo	s31, r15

positive: fmsrmi instruction

	fmsrmi	s0, r0
	fmsrmi	s31, r15

positive: fmsrpl instruction

	fmsrpl	s0, r0
	fmsrpl	s31, r15

positive: fmsrvs instruction

	fmsrvs	s0, r0
	fmsrvs	s31, r15

positive: fmsrvc instruction

	fmsrvc	s0, r0
	fmsrvc	s31, r15

positive: fmsrhi instruction

	fmsrhi	s0, r0
	fmsrhi	s31, r15

positive: fmsrls instruction

	fmsrls	s0, r0
	fmsrls	s31, r15

positive: fmsrge instruction

	fmsrge	s0, r0
	fmsrge	s31, r15

positive: fmsrlt instruction

	fmsrlt	s0, r0
	fmsrlt	s31, r15

positive: fmsrgt instruction

	fmsrgt	s0, r0
	fmsrgt	s31, r15

positive: fmsrle instruction

	fmsrle	s0, r0
	fmsrle	s31, r15

positive: fmsral instruction

	fmsral	s0, r0
	fmsral	s31, r15

positive: fmsrr instruction

	fmsrr	s0, r0, r0
	fmsrr	s31, r15, r15

positive: fmsrreq instruction

	fmsrreq	s0, r0, r0
	fmsrreq	s31, r15, r15

positive: fmsrrne instruction

	fmsrrne	s0, r0, r0
	fmsrrne	s31, r15, r15

positive: fmsrrcs instruction

	fmsrrcs	s0, r0, r0
	fmsrrcs	s31, r15, r15

positive: fmsrrhs instruction

	fmsrrhs	s0, r0, r0
	fmsrrhs	s31, r15, r15

positive: fmsrrcc instruction

	fmsrrcc	s0, r0, r0
	fmsrrcc	s31, r15, r15

positive: fmsrrlo instruction

	fmsrrlo	s0, r0, r0
	fmsrrlo	s31, r15, r15

positive: fmsrrmi instruction

	fmsrrmi	s0, r0, r0
	fmsrrmi	s31, r15, r15

positive: fmsrrpl instruction

	fmsrrpl	s0, r0, r0
	fmsrrpl	s31, r15, r15

positive: fmsrrvs instruction

	fmsrrvs	s0, r0, r0
	fmsrrvs	s31, r15, r15

positive: fmsrrvc instruction

	fmsrrvc	s0, r0, r0
	fmsrrvc	s31, r15, r15

positive: fmsrrhi instruction

	fmsrrhi	s0, r0, r0
	fmsrrhi	s31, r15, r15

positive: fmsrrls instruction

	fmsrrls	s0, r0, r0
	fmsrrls	s31, r15, r15

positive: fmsrrge instruction

	fmsrrge	s0, r0, r0
	fmsrrge	s31, r15, r15

positive: fmsrrlt instruction

	fmsrrlt	s0, r0, r0
	fmsrrlt	s31, r15, r15

positive: fmsrrgt instruction

	fmsrrgt	s0, r0, r0
	fmsrrgt	s31, r15, r15

positive: fmsrrle instruction

	fmsrrle	s0, r0, r0
	fmsrrle	s31, r15, r15

positive: fmsrral instruction

	fmsrral	s0, r0, r0
	fmsrral	s31, r15, r15

positive: fmuld instruction

	fmuld	d0, d0, d0
	fmuld	d15, d15, d15

positive: fmuldeq instruction

	fmuldeq	d0, d0, d0
	fmuldeq	d15, d15, d15

positive: fmuldne instruction

	fmuldne	d0, d0, d0
	fmuldne	d15, d15, d15

positive: fmuldcs instruction

	fmuldcs	d0, d0, d0
	fmuldcs	d15, d15, d15

positive: fmuldhs instruction

	fmuldhs	d0, d0, d0
	fmuldhs	d15, d15, d15

positive: fmuldcc instruction

	fmuldcc	d0, d0, d0
	fmuldcc	d15, d15, d15

positive: fmuldlo instruction

	fmuldlo	d0, d0, d0
	fmuldlo	d15, d15, d15

positive: fmuldmi instruction

	fmuldmi	d0, d0, d0
	fmuldmi	d15, d15, d15

positive: fmuldpl instruction

	fmuldpl	d0, d0, d0
	fmuldpl	d15, d15, d15

positive: fmuldvs instruction

	fmuldvs	d0, d0, d0
	fmuldvs	d15, d15, d15

positive: fmuldvc instruction

	fmuldvc	d0, d0, d0
	fmuldvc	d15, d15, d15

positive: fmuldhi instruction

	fmuldhi	d0, d0, d0
	fmuldhi	d15, d15, d15

positive: fmuldls instruction

	fmuldls	d0, d0, d0
	fmuldls	d15, d15, d15

positive: fmuldge instruction

	fmuldge	d0, d0, d0
	fmuldge	d15, d15, d15

positive: fmuldlt instruction

	fmuldlt	d0, d0, d0
	fmuldlt	d15, d15, d15

positive: fmuldgt instruction

	fmuldgt	d0, d0, d0
	fmuldgt	d15, d15, d15

positive: fmuldle instruction

	fmuldle	d0, d0, d0
	fmuldle	d15, d15, d15

positive: fmuldal instruction

	fmuldal	d0, d0, d0
	fmuldal	d15, d15, d15

positive: fmuls instruction

	fmuls	s0, s0, s0
	fmuls	s31, s31, s31

positive: fmulseq instruction

	fmulseq	s0, s0, s0
	fmulseq	s31, s31, s31

positive: fmulsne instruction

	fmulsne	s0, s0, s0
	fmulsne	s31, s31, s31

positive: fmulscs instruction

	fmulscs	s0, s0, s0
	fmulscs	s31, s31, s31

positive: fmulshs instruction

	fmulshs	s0, s0, s0
	fmulshs	s31, s31, s31

positive: fmulscc instruction

	fmulscc	s0, s0, s0
	fmulscc	s31, s31, s31

positive: fmulslo instruction

	fmulslo	s0, s0, s0
	fmulslo	s31, s31, s31

positive: fmulsmi instruction

	fmulsmi	s0, s0, s0
	fmulsmi	s31, s31, s31

positive: fmulspl instruction

	fmulspl	s0, s0, s0
	fmulspl	s31, s31, s31

positive: fmulsvs instruction

	fmulsvs	s0, s0, s0
	fmulsvs	s31, s31, s31

positive: fmulsvc instruction

	fmulsvc	s0, s0, s0
	fmulsvc	s31, s31, s31

positive: fmulshi instruction

	fmulshi	s0, s0, s0
	fmulshi	s31, s31, s31

positive: fmulsls instruction

	fmulsls	s0, s0, s0
	fmulsls	s31, s31, s31

positive: fmulsge instruction

	fmulsge	s0, s0, s0
	fmulsge	s31, s31, s31

positive: fmulslt instruction

	fmulslt	s0, s0, s0
	fmulslt	s31, s31, s31

positive: fmulsgt instruction

	fmulsgt	s0, s0, s0
	fmulsgt	s31, s31, s31

positive: fmulsle instruction

	fmulsle	s0, s0, s0
	fmulsle	s31, s31, s31

positive: fmulsal instruction

	fmulsal	s0, s0, s0
	fmulsal	s31, s31, s31

positive: fnegd instruction

	fnegd	d0, d0
	fnegd	d15, d15

positive: fnegdeq instruction

	fnegdeq	d0, d0
	fnegdeq	d15, d15

positive: fnegdne instruction

	fnegdne	d0, d0
	fnegdne	d15, d15

positive: fnegdcs instruction

	fnegdcs	d0, d0
	fnegdcs	d15, d15

positive: fnegdhs instruction

	fnegdhs	d0, d0
	fnegdhs	d15, d15

positive: fnegdcc instruction

	fnegdcc	d0, d0
	fnegdcc	d15, d15

positive: fnegdlo instruction

	fnegdlo	d0, d0
	fnegdlo	d15, d15

positive: fnegdmi instruction

	fnegdmi	d0, d0
	fnegdmi	d15, d15

positive: fnegdpl instruction

	fnegdpl	d0, d0
	fnegdpl	d15, d15

positive: fnegdvs instruction

	fnegdvs	d0, d0
	fnegdvs	d15, d15

positive: fnegdvc instruction

	fnegdvc	d0, d0
	fnegdvc	d15, d15

positive: fnegdhi instruction

	fnegdhi	d0, d0
	fnegdhi	d15, d15

positive: fnegdls instruction

	fnegdls	d0, d0
	fnegdls	d15, d15

positive: fnegdge instruction

	fnegdge	d0, d0
	fnegdge	d15, d15

positive: fnegdlt instruction

	fnegdlt	d0, d0
	fnegdlt	d15, d15

positive: fnegdgt instruction

	fnegdgt	d0, d0
	fnegdgt	d15, d15

positive: fnegdle instruction

	fnegdle	d0, d0
	fnegdle	d15, d15

positive: fnegdal instruction

	fnegdal	d0, d0
	fnegdal	d15, d15

positive: fnegs instruction

	fnegs	s0, s0
	fnegs	s31, s31

positive: fnegseq instruction

	fnegseq	s0, s0
	fnegseq	s31, s31

positive: fnegsne instruction

	fnegsne	s0, s0
	fnegsne	s31, s31

positive: fnegscs instruction

	fnegscs	s0, s0
	fnegscs	s31, s31

positive: fnegshs instruction

	fnegshs	s0, s0
	fnegshs	s31, s31

positive: fnegscc instruction

	fnegscc	s0, s0
	fnegscc	s31, s31

positive: fnegslo instruction

	fnegslo	s0, s0
	fnegslo	s31, s31

positive: fnegsmi instruction

	fnegsmi	s0, s0
	fnegsmi	s31, s31

positive: fnegspl instruction

	fnegspl	s0, s0
	fnegspl	s31, s31

positive: fnegsvs instruction

	fnegsvs	s0, s0
	fnegsvs	s31, s31

positive: fnegsvc instruction

	fnegsvc	s0, s0
	fnegsvc	s31, s31

positive: fnegshi instruction

	fnegshi	s0, s0
	fnegshi	s31, s31

positive: fnegsls instruction

	fnegsls	s0, s0
	fnegsls	s31, s31

positive: fnegsge instruction

	fnegsge	s0, s0
	fnegsge	s31, s31

positive: fnegslt instruction

	fnegslt	s0, s0
	fnegslt	s31, s31

positive: fnegsgt instruction

	fnegsgt	s0, s0
	fnegsgt	s31, s31

positive: fnegsle instruction

	fnegsle	s0, s0
	fnegsle	s31, s31

positive: fnegsal instruction

	fnegsal	s0, s0
	fnegsal	s31, s31

positive: fnmacd instruction

	fnmacd	d0, d0, d0
	fnmacd	d15, d15, d15

positive: fnmacdeq instruction

	fnmacdeq	d0, d0, d0
	fnmacdeq	d15, d15, d15

positive: fnmacdne instruction

	fnmacdne	d0, d0, d0
	fnmacdne	d15, d15, d15

positive: fnmacdcs instruction

	fnmacdcs	d0, d0, d0
	fnmacdcs	d15, d15, d15

positive: fnmacdhs instruction

	fnmacdhs	d0, d0, d0
	fnmacdhs	d15, d15, d15

positive: fnmacdcc instruction

	fnmacdcc	d0, d0, d0
	fnmacdcc	d15, d15, d15

positive: fnmacdlo instruction

	fnmacdlo	d0, d0, d0
	fnmacdlo	d15, d15, d15

positive: fnmacdmi instruction

	fnmacdmi	d0, d0, d0
	fnmacdmi	d15, d15, d15

positive: fnmacdpl instruction

	fnmacdpl	d0, d0, d0
	fnmacdpl	d15, d15, d15

positive: fnmacdvs instruction

	fnmacdvs	d0, d0, d0
	fnmacdvs	d15, d15, d15

positive: fnmacdvc instruction

	fnmacdvc	d0, d0, d0
	fnmacdvc	d15, d15, d15

positive: fnmacdhi instruction

	fnmacdhi	d0, d0, d0
	fnmacdhi	d15, d15, d15

positive: fnmacdls instruction

	fnmacdls	d0, d0, d0
	fnmacdls	d15, d15, d15

positive: fnmacdge instruction

	fnmacdge	d0, d0, d0
	fnmacdge	d15, d15, d15

positive: fnmacdlt instruction

	fnmacdlt	d0, d0, d0
	fnmacdlt	d15, d15, d15

positive: fnmacdgt instruction

	fnmacdgt	d0, d0, d0
	fnmacdgt	d15, d15, d15

positive: fnmacdle instruction

	fnmacdle	d0, d0, d0
	fnmacdle	d15, d15, d15

positive: fnmacdal instruction

	fnmacdal	d0, d0, d0
	fnmacdal	d15, d15, d15

positive: fnmacs instruction

	fnmacs	s0, s0, s0
	fnmacs	s31, s31, s31

positive: fnmacseq instruction

	fnmacseq	s0, s0, s0
	fnmacseq	s31, s31, s31

positive: fnmacsne instruction

	fnmacsne	s0, s0, s0
	fnmacsne	s31, s31, s31

positive: fnmacscs instruction

	fnmacscs	s0, s0, s0
	fnmacscs	s31, s31, s31

positive: fnmacshs instruction

	fnmacshs	s0, s0, s0
	fnmacshs	s31, s31, s31

positive: fnmacscc instruction

	fnmacscc	s0, s0, s0
	fnmacscc	s31, s31, s31

positive: fnmacslo instruction

	fnmacslo	s0, s0, s0
	fnmacslo	s31, s31, s31

positive: fnmacsmi instruction

	fnmacsmi	s0, s0, s0
	fnmacsmi	s31, s31, s31

positive: fnmacspl instruction

	fnmacspl	s0, s0, s0
	fnmacspl	s31, s31, s31

positive: fnmacsvs instruction

	fnmacsvs	s0, s0, s0
	fnmacsvs	s31, s31, s31

positive: fnmacsvc instruction

	fnmacsvc	s0, s0, s0
	fnmacsvc	s31, s31, s31

positive: fnmacshi instruction

	fnmacshi	s0, s0, s0
	fnmacshi	s31, s31, s31

positive: fnmacsls instruction

	fnmacsls	s0, s0, s0
	fnmacsls	s31, s31, s31

positive: fnmacsge instruction

	fnmacsge	s0, s0, s0
	fnmacsge	s31, s31, s31

positive: fnmacslt instruction

	fnmacslt	s0, s0, s0
	fnmacslt	s31, s31, s31

positive: fnmacsgt instruction

	fnmacsgt	s0, s0, s0
	fnmacsgt	s31, s31, s31

positive: fnmacsle instruction

	fnmacsle	s0, s0, s0
	fnmacsle	s31, s31, s31

positive: fnmacsal instruction

	fnmacsal	s0, s0, s0
	fnmacsal	s31, s31, s31

positive: fnmscd instruction

	fnmscd	d0, d0, d0
	fnmscd	d15, d15, d15

positive: fnmscdeq instruction

	fnmscdeq	d0, d0, d0
	fnmscdeq	d15, d15, d15

positive: fnmscdne instruction

	fnmscdne	d0, d0, d0
	fnmscdne	d15, d15, d15

positive: fnmscdcs instruction

	fnmscdcs	d0, d0, d0
	fnmscdcs	d15, d15, d15

positive: fnmscdhs instruction

	fnmscdhs	d0, d0, d0
	fnmscdhs	d15, d15, d15

positive: fnmscdcc instruction

	fnmscdcc	d0, d0, d0
	fnmscdcc	d15, d15, d15

positive: fnmscdlo instruction

	fnmscdlo	d0, d0, d0
	fnmscdlo	d15, d15, d15

positive: fnmscdmi instruction

	fnmscdmi	d0, d0, d0
	fnmscdmi	d15, d15, d15

positive: fnmscdpl instruction

	fnmscdpl	d0, d0, d0
	fnmscdpl	d15, d15, d15

positive: fnmscdvs instruction

	fnmscdvs	d0, d0, d0
	fnmscdvs	d15, d15, d15

positive: fnmscdvc instruction

	fnmscdvc	d0, d0, d0
	fnmscdvc	d15, d15, d15

positive: fnmscdhi instruction

	fnmscdhi	d0, d0, d0
	fnmscdhi	d15, d15, d15

positive: fnmscdls instruction

	fnmscdls	d0, d0, d0
	fnmscdls	d15, d15, d15

positive: fnmscdge instruction

	fnmscdge	d0, d0, d0
	fnmscdge	d15, d15, d15

positive: fnmscdlt instruction

	fnmscdlt	d0, d0, d0
	fnmscdlt	d15, d15, d15

positive: fnmscdgt instruction

	fnmscdgt	d0, d0, d0
	fnmscdgt	d15, d15, d15

positive: fnmscdle instruction

	fnmscdle	d0, d0, d0
	fnmscdle	d15, d15, d15

positive: fnmscdal instruction

	fnmscdal	d0, d0, d0
	fnmscdal	d15, d15, d15

positive: fnmscs instruction

	fnmscs	s0, s0, s0
	fnmscs	s31, s31, s31

positive: fnmscseq instruction

	fnmscseq	s0, s0, s0
	fnmscseq	s31, s31, s31

positive: fnmscsne instruction

	fnmscsne	s0, s0, s0
	fnmscsne	s31, s31, s31

positive: fnmscscs instruction

	fnmscscs	s0, s0, s0
	fnmscscs	s31, s31, s31

positive: fnmscshs instruction

	fnmscshs	s0, s0, s0
	fnmscshs	s31, s31, s31

positive: fnmscscc instruction

	fnmscscc	s0, s0, s0
	fnmscscc	s31, s31, s31

positive: fnmscslo instruction

	fnmscslo	s0, s0, s0
	fnmscslo	s31, s31, s31

positive: fnmscsmi instruction

	fnmscsmi	s0, s0, s0
	fnmscsmi	s31, s31, s31

positive: fnmscspl instruction

	fnmscspl	s0, s0, s0
	fnmscspl	s31, s31, s31

positive: fnmscsvs instruction

	fnmscsvs	s0, s0, s0
	fnmscsvs	s31, s31, s31

positive: fnmscsvc instruction

	fnmscsvc	s0, s0, s0
	fnmscsvc	s31, s31, s31

positive: fnmscshi instruction

	fnmscshi	s0, s0, s0
	fnmscshi	s31, s31, s31

positive: fnmscsls instruction

	fnmscsls	s0, s0, s0
	fnmscsls	s31, s31, s31

positive: fnmscsge instruction

	fnmscsge	s0, s0, s0
	fnmscsge	s31, s31, s31

positive: fnmscslt instruction

	fnmscslt	s0, s0, s0
	fnmscslt	s31, s31, s31

positive: fnmscsgt instruction

	fnmscsgt	s0, s0, s0
	fnmscsgt	s31, s31, s31

positive: fnmscsle instruction

	fnmscsle	s0, s0, s0
	fnmscsle	s31, s31, s31

positive: fnmscsal instruction

	fnmscsal	s0, s0, s0
	fnmscsal	s31, s31, s31

positive: fnmuld instruction

	fnmuld	d0, d0, d0
	fnmuld	d15, d15, d15

positive: fnmuldeq instruction

	fnmuldeq	d0, d0, d0
	fnmuldeq	d15, d15, d15

positive: fnmuldne instruction

	fnmuldne	d0, d0, d0
	fnmuldne	d15, d15, d15

positive: fnmuldcs instruction

	fnmuldcs	d0, d0, d0
	fnmuldcs	d15, d15, d15

positive: fnmuldhs instruction

	fnmuldhs	d0, d0, d0
	fnmuldhs	d15, d15, d15

positive: fnmuldcc instruction

	fnmuldcc	d0, d0, d0
	fnmuldcc	d15, d15, d15

positive: fnmuldlo instruction

	fnmuldlo	d0, d0, d0
	fnmuldlo	d15, d15, d15

positive: fnmuldmi instruction

	fnmuldmi	d0, d0, d0
	fnmuldmi	d15, d15, d15

positive: fnmuldpl instruction

	fnmuldpl	d0, d0, d0
	fnmuldpl	d15, d15, d15

positive: fnmuldvs instruction

	fnmuldvs	d0, d0, d0
	fnmuldvs	d15, d15, d15

positive: fnmuldvc instruction

	fnmuldvc	d0, d0, d0
	fnmuldvc	d15, d15, d15

positive: fnmuldhi instruction

	fnmuldhi	d0, d0, d0
	fnmuldhi	d15, d15, d15

positive: fnmuldls instruction

	fnmuldls	d0, d0, d0
	fnmuldls	d15, d15, d15

positive: fnmuldge instruction

	fnmuldge	d0, d0, d0
	fnmuldge	d15, d15, d15

positive: fnmuldlt instruction

	fnmuldlt	d0, d0, d0
	fnmuldlt	d15, d15, d15

positive: fnmuldgt instruction

	fnmuldgt	d0, d0, d0
	fnmuldgt	d15, d15, d15

positive: fnmuldle instruction

	fnmuldle	d0, d0, d0
	fnmuldle	d15, d15, d15

positive: fnmuldal instruction

	fnmuldal	d0, d0, d0
	fnmuldal	d15, d15, d15

positive: fnmuls instruction

	fnmuls	s0, s0, s0
	fnmuls	s31, s31, s31

positive: fnmulseq instruction

	fnmulseq	s0, s0, s0
	fnmulseq	s31, s31, s31

positive: fnmulsne instruction

	fnmulsne	s0, s0, s0
	fnmulsne	s31, s31, s31

positive: fnmulscs instruction

	fnmulscs	s0, s0, s0
	fnmulscs	s31, s31, s31

positive: fnmulshs instruction

	fnmulshs	s0, s0, s0
	fnmulshs	s31, s31, s31

positive: fnmulscc instruction

	fnmulscc	s0, s0, s0
	fnmulscc	s31, s31, s31

positive: fnmulslo instruction

	fnmulslo	s0, s0, s0
	fnmulslo	s31, s31, s31

positive: fnmulsmi instruction

	fnmulsmi	s0, s0, s0
	fnmulsmi	s31, s31, s31

positive: fnmulspl instruction

	fnmulspl	s0, s0, s0
	fnmulspl	s31, s31, s31

positive: fnmulsvs instruction

	fnmulsvs	s0, s0, s0
	fnmulsvs	s31, s31, s31

positive: fnmulsvc instruction

	fnmulsvc	s0, s0, s0
	fnmulsvc	s31, s31, s31

positive: fnmulshi instruction

	fnmulshi	s0, s0, s0
	fnmulshi	s31, s31, s31

positive: fnmulsls instruction

	fnmulsls	s0, s0, s0
	fnmulsls	s31, s31, s31

positive: fnmulsge instruction

	fnmulsge	s0, s0, s0
	fnmulsge	s31, s31, s31

positive: fnmulslt instruction

	fnmulslt	s0, s0, s0
	fnmulslt	s31, s31, s31

positive: fnmulsgt instruction

	fnmulsgt	s0, s0, s0
	fnmulsgt	s31, s31, s31

positive: fnmulsle instruction

	fnmulsle	s0, s0, s0
	fnmulsle	s31, s31, s31

positive: fnmulsal instruction

	fnmulsal	s0, s0, s0
	fnmulsal	s31, s31, s31

positive: fsitod instruction

	fsitod	d0, s0
	fsitod	d15, s31

positive: fsitodeq instruction

	fsitodeq	d0, s0
	fsitodeq	d15, s31

positive: fsitodne instruction

	fsitodne	d0, s0
	fsitodne	d15, s31

positive: fsitodcs instruction

	fsitodcs	d0, s0
	fsitodcs	d15, s31

positive: fsitodhs instruction

	fsitodhs	d0, s0
	fsitodhs	d15, s31

positive: fsitodcc instruction

	fsitodcc	d0, s0
	fsitodcc	d15, s31

positive: fsitodlo instruction

	fsitodlo	d0, s0
	fsitodlo	d15, s31

positive: fsitodmi instruction

	fsitodmi	d0, s0
	fsitodmi	d15, s31

positive: fsitodpl instruction

	fsitodpl	d0, s0
	fsitodpl	d15, s31

positive: fsitodvs instruction

	fsitodvs	d0, s0
	fsitodvs	d15, s31

positive: fsitodvc instruction

	fsitodvc	d0, s0
	fsitodvc	d15, s31

positive: fsitodhi instruction

	fsitodhi	d0, s0
	fsitodhi	d15, s31

positive: fsitodls instruction

	fsitodls	d0, s0
	fsitodls	d15, s31

positive: fsitodge instruction

	fsitodge	d0, s0
	fsitodge	d15, s31

positive: fsitodlt instruction

	fsitodlt	d0, s0
	fsitodlt	d15, s31

positive: fsitodgt instruction

	fsitodgt	d0, s0
	fsitodgt	d15, s31

positive: fsitodle instruction

	fsitodle	d0, s0
	fsitodle	d15, s31

positive: fsitodal instruction

	fsitodal	d0, s0
	fsitodal	d15, s31

positive: fsitos instruction

	fsitos	s0, s0
	fsitos	s31, s31

positive: fsitoseq instruction

	fsitoseq	s0, s0
	fsitoseq	s31, s31

positive: fsitosne instruction

	fsitosne	s0, s0
	fsitosne	s31, s31

positive: fsitoscs instruction

	fsitoscs	s0, s0
	fsitoscs	s31, s31

positive: fsitoshs instruction

	fsitoshs	s0, s0
	fsitoshs	s31, s31

positive: fsitoscc instruction

	fsitoscc	s0, s0
	fsitoscc	s31, s31

positive: fsitoslo instruction

	fsitoslo	s0, s0
	fsitoslo	s31, s31

positive: fsitosmi instruction

	fsitosmi	s0, s0
	fsitosmi	s31, s31

positive: fsitospl instruction

	fsitospl	s0, s0
	fsitospl	s31, s31

positive: fsitosvs instruction

	fsitosvs	s0, s0
	fsitosvs	s31, s31

positive: fsitosvc instruction

	fsitosvc	s0, s0
	fsitosvc	s31, s31

positive: fsitoshi instruction

	fsitoshi	s0, s0
	fsitoshi	s31, s31

positive: fsitosls instruction

	fsitosls	s0, s0
	fsitosls	s31, s31

positive: fsitosge instruction

	fsitosge	s0, s0
	fsitosge	s31, s31

positive: fsitoslt instruction

	fsitoslt	s0, s0
	fsitoslt	s31, s31

positive: fsitosgt instruction

	fsitosgt	s0, s0
	fsitosgt	s31, s31

positive: fsitosle instruction

	fsitosle	s0, s0
	fsitosle	s31, s31

positive: fsitosal instruction

	fsitosal	s0, s0
	fsitosal	s31, s31

positive: fsqrtd instruction

	fsqrtd	d0, d0
	fsqrtd	d15, d15

positive: fsqrtdeq instruction

	fsqrtdeq	d0, d0
	fsqrtdeq	d15, d15

positive: fsqrtdne instruction

	fsqrtdne	d0, d0
	fsqrtdne	d15, d15

positive: fsqrtdcs instruction

	fsqrtdcs	d0, d0
	fsqrtdcs	d15, d15

positive: fsqrtdhs instruction

	fsqrtdhs	d0, d0
	fsqrtdhs	d15, d15

positive: fsqrtdcc instruction

	fsqrtdcc	d0, d0
	fsqrtdcc	d15, d15

positive: fsqrtdlo instruction

	fsqrtdlo	d0, d0
	fsqrtdlo	d15, d15

positive: fsqrtdmi instruction

	fsqrtdmi	d0, d0
	fsqrtdmi	d15, d15

positive: fsqrtdpl instruction

	fsqrtdpl	d0, d0
	fsqrtdpl	d15, d15

positive: fsqrtdvs instruction

	fsqrtdvs	d0, d0
	fsqrtdvs	d15, d15

positive: fsqrtdvc instruction

	fsqrtdvc	d0, d0
	fsqrtdvc	d15, d15

positive: fsqrtdhi instruction

	fsqrtdhi	d0, d0
	fsqrtdhi	d15, d15

positive: fsqrtdls instruction

	fsqrtdls	d0, d0
	fsqrtdls	d15, d15

positive: fsqrtdge instruction

	fsqrtdge	d0, d0
	fsqrtdge	d15, d15

positive: fsqrtdlt instruction

	fsqrtdlt	d0, d0
	fsqrtdlt	d15, d15

positive: fsqrtdgt instruction

	fsqrtdgt	d0, d0
	fsqrtdgt	d15, d15

positive: fsqrtdle instruction

	fsqrtdle	d0, d0
	fsqrtdle	d15, d15

positive: fsqrtdal instruction

	fsqrtdal	d0, d0
	fsqrtdal	d15, d15

positive: fsqrts instruction

	fsqrts	s0, s0
	fsqrts	s31, s31

positive: fsqrtseq instruction

	fsqrtseq	s0, s0
	fsqrtseq	s31, s31

positive: fsqrtsne instruction

	fsqrtsne	s0, s0
	fsqrtsne	s31, s31

positive: fsqrtscs instruction

	fsqrtscs	s0, s0
	fsqrtscs	s31, s31

positive: fsqrtshs instruction

	fsqrtshs	s0, s0
	fsqrtshs	s31, s31

positive: fsqrtscc instruction

	fsqrtscc	s0, s0
	fsqrtscc	s31, s31

positive: fsqrtslo instruction

	fsqrtslo	s0, s0
	fsqrtslo	s31, s31

positive: fsqrtsmi instruction

	fsqrtsmi	s0, s0
	fsqrtsmi	s31, s31

positive: fsqrtspl instruction

	fsqrtspl	s0, s0
	fsqrtspl	s31, s31

positive: fsqrtsvs instruction

	fsqrtsvs	s0, s0
	fsqrtsvs	s31, s31

positive: fsqrtsvc instruction

	fsqrtsvc	s0, s0
	fsqrtsvc	s31, s31

positive: fsqrtshi instruction

	fsqrtshi	s0, s0
	fsqrtshi	s31, s31

positive: fsqrtsls instruction

	fsqrtsls	s0, s0
	fsqrtsls	s31, s31

positive: fsqrtsge instruction

	fsqrtsge	s0, s0
	fsqrtsge	s31, s31

positive: fsqrtslt instruction

	fsqrtslt	s0, s0
	fsqrtslt	s31, s31

positive: fsqrtsgt instruction

	fsqrtsgt	s0, s0
	fsqrtsgt	s31, s31

positive: fsqrtsle instruction

	fsqrtsle	s0, s0
	fsqrtsle	s31, s31

positive: fsqrtsal instruction

	fsqrtsal	s0, s0
	fsqrtsal	s31, s31

positive: fstd instruction

	fstd	d0, [r0]
	fstd	d15, [r15]
	fstd	d0, [r0, -1020]
	fstd	d15, [r15, +1020]

positive: fstdeq instruction

	fstdeq	d0, [r0]
	fstdeq	d15, [r15]
	fstdeq	d0, [r0, -1020]
	fstdeq	d15, [r15, +1020]

positive: fstdne instruction

	fstdne	d0, [r0]
	fstdne	d15, [r15]
	fstdne	d0, [r0, -1020]
	fstdne	d15, [r15, +1020]

positive: fstdcs instruction

	fstdcs	d0, [r0]
	fstdcs	d15, [r15]
	fstdcs	d0, [r0, -1020]
	fstdcs	d15, [r15, +1020]

positive: fstdhs instruction

	fstdhs	d0, [r0]
	fstdhs	d15, [r15]
	fstdhs	d0, [r0, -1020]
	fstdhs	d15, [r15, +1020]

positive: fstdcc instruction

	fstdcc	d0, [r0]
	fstdcc	d15, [r15]
	fstdcc	d0, [r0, -1020]
	fstdcc	d15, [r15, +1020]

positive: fstdlo instruction

	fstdlo	d0, [r0]
	fstdlo	d15, [r15]
	fstdlo	d0, [r0, -1020]
	fstdlo	d15, [r15, +1020]

positive: fstdmi instruction

	fstdmi	d0, [r0]
	fstdmi	d15, [r15]
	fstdmi	d0, [r0, -1020]
	fstdmi	d15, [r15, +1020]

positive: fstdpl instruction

	fstdpl	d0, [r0]
	fstdpl	d15, [r15]
	fstdpl	d0, [r0, -1020]
	fstdpl	d15, [r15, +1020]

positive: fstdvs instruction

	fstdvs	d0, [r0]
	fstdvs	d15, [r15]
	fstdvs	d0, [r0, -1020]
	fstdvs	d15, [r15, +1020]

positive: fstdvc instruction

	fstdvc	d0, [r0]
	fstdvc	d15, [r15]
	fstdvc	d0, [r0, -1020]
	fstdvc	d15, [r15, +1020]

positive: fstdhi instruction

	fstdhi	d0, [r0]
	fstdhi	d15, [r15]
	fstdhi	d0, [r0, -1020]
	fstdhi	d15, [r15, +1020]

positive: fstdls instruction

	fstdls	d0, [r0]
	fstdls	d15, [r15]
	fstdls	d0, [r0, -1020]
	fstdls	d15, [r15, +1020]

positive: fstdge instruction

	fstdge	d0, [r0]
	fstdge	d15, [r15]
	fstdge	d0, [r0, -1020]
	fstdge	d15, [r15, +1020]

positive: fstdlt instruction

	fstdlt	d0, [r0]
	fstdlt	d15, [r15]
	fstdlt	d0, [r0, -1020]
	fstdlt	d15, [r15, +1020]

positive: fstdgt instruction

	fstdgt	d0, [r0]
	fstdgt	d15, [r15]
	fstdgt	d0, [r0, -1020]
	fstdgt	d15, [r15, +1020]

positive: fstdle instruction

	fstdle	d0, [r0]
	fstdle	d15, [r15]
	fstdle	d0, [r0, -1020]
	fstdle	d15, [r15, +1020]

positive: fstdal instruction

	fstdal	d0, [r0]
	fstdal	d15, [r15]
	fstdal	d0, [r0, -1020]
	fstdal	d15, [r15, +1020]

positive: fsts instruction

	fsts	s0, [r0]
	fsts	s31, [r15]
	fsts	s0, [r0, -1020]
	fsts	s31, [r15, +1020]

positive: fstseq instruction

	fstseq	s0, [r0]
	fstseq	s31, [r15]
	fstseq	s0, [r0, -1020]
	fstseq	s31, [r15, +1020]

positive: fstsne instruction

	fstsne	s0, [r0]
	fstsne	s31, [r15]
	fstsne	s0, [r0, -1020]
	fstsne	s31, [r15, +1020]

positive: fstscs instruction

	fstscs	s0, [r0]
	fstscs	s31, [r15]
	fstscs	s0, [r0, -1020]
	fstscs	s31, [r15, +1020]

positive: fstshs instruction

	fstshs	s0, [r0]
	fstshs	s31, [r15]
	fstshs	s0, [r0, -1020]
	fstshs	s31, [r15, +1020]

positive: fstscc instruction

	fstscc	s0, [r0]
	fstscc	s31, [r15]
	fstscc	s0, [r0, -1020]
	fstscc	s31, [r15, +1020]

positive: fstslo instruction

	fstslo	s0, [r0]
	fstslo	s31, [r15]
	fstslo	s0, [r0, -1020]
	fstslo	s31, [r15, +1020]

positive: fstsmi instruction

	fstsmi	s0, [r0]
	fstsmi	s31, [r15]
	fstsmi	s0, [r0, -1020]
	fstsmi	s31, [r15, +1020]

positive: fstspl instruction

	fstspl	s0, [r0]
	fstspl	s31, [r15]
	fstspl	s0, [r0, -1020]
	fstspl	s31, [r15, +1020]

positive: fstsvs instruction

	fstsvs	s0, [r0]
	fstsvs	s31, [r15]
	fstsvs	s0, [r0, -1020]
	fstsvs	s31, [r15, +1020]

positive: fstsvc instruction

	fstsvc	s0, [r0]
	fstsvc	s31, [r15]
	fstsvc	s0, [r0, -1020]
	fstsvc	s31, [r15, +1020]

positive: fstshi instruction

	fstshi	s0, [r0]
	fstshi	s31, [r15]
	fstshi	s0, [r0, -1020]
	fstshi	s31, [r15, +1020]

positive: fstsls instruction

	fstsls	s0, [r0]
	fstsls	s31, [r15]
	fstsls	s0, [r0, -1020]
	fstsls	s31, [r15, +1020]

positive: fstsge instruction

	fstsge	s0, [r0]
	fstsge	s31, [r15]
	fstsge	s0, [r0, -1020]
	fstsge	s31, [r15, +1020]

positive: fstslt instruction

	fstslt	s0, [r0]
	fstslt	s31, [r15]
	fstslt	s0, [r0, -1020]
	fstslt	s31, [r15, +1020]

positive: fstsgt instruction

	fstsgt	s0, [r0]
	fstsgt	s31, [r15]
	fstsgt	s0, [r0, -1020]
	fstsgt	s31, [r15, +1020]

positive: fstsle instruction

	fstsle	s0, [r0]
	fstsle	s31, [r15]
	fstsle	s0, [r0, -1020]
	fstsle	s31, [r15, +1020]

positive: fstsal instruction

	fstsal	s0, [r0]
	fstsal	s31, [r15]
	fstsal	s0, [r0, -1020]
	fstsal	s31, [r15, +1020]

positive: fstmiad instruction

	fstmiad	r0, {d0}
	fstmiad	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiad	r0 !, {d0}
	fstmiad	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadeq instruction

	fstmiadeq	r0, {d0}
	fstmiadeq	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadeq	r0 !, {d0}
	fstmiadeq	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadne instruction

	fstmiadne	r0, {d0}
	fstmiadne	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadne	r0 !, {d0}
	fstmiadne	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadcs instruction

	fstmiadcs	r0, {d0}
	fstmiadcs	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadcs	r0 !, {d0}
	fstmiadcs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadhs instruction

	fstmiadhs	r0, {d0}
	fstmiadhs	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadhs	r0 !, {d0}
	fstmiadhs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadcc instruction

	fstmiadcc	r0, {d0}
	fstmiadcc	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadcc	r0 !, {d0}
	fstmiadcc	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadlo instruction

	fstmiadlo	r0, {d0}
	fstmiadlo	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadlo	r0 !, {d0}
	fstmiadlo	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadmi instruction

	fstmiadmi	r0, {d0}
	fstmiadmi	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadmi	r0 !, {d0}
	fstmiadmi	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadpl instruction

	fstmiadpl	r0, {d0}
	fstmiadpl	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadpl	r0 !, {d0}
	fstmiadpl	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadvs instruction

	fstmiadvs	r0, {d0}
	fstmiadvs	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadvs	r0 !, {d0}
	fstmiadvs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadvc instruction

	fstmiadvc	r0, {d0}
	fstmiadvc	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadvc	r0 !, {d0}
	fstmiadvc	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadhi instruction

	fstmiadhi	r0, {d0}
	fstmiadhi	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadhi	r0 !, {d0}
	fstmiadhi	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadls instruction

	fstmiadls	r0, {d0}
	fstmiadls	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadls	r0 !, {d0}
	fstmiadls	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadge instruction

	fstmiadge	r0, {d0}
	fstmiadge	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadge	r0 !, {d0}
	fstmiadge	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadlt instruction

	fstmiadlt	r0, {d0}
	fstmiadlt	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadlt	r0 !, {d0}
	fstmiadlt	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadgt instruction

	fstmiadgt	r0, {d0}
	fstmiadgt	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadgt	r0 !, {d0}
	fstmiadgt	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadle instruction

	fstmiadle	r0, {d0}
	fstmiadle	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadle	r0 !, {d0}
	fstmiadle	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmiadal instruction

	fstmiadal	r0, {d0}
	fstmiadal	r15, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
	fstmiadal	r0 !, {d0}
	fstmiadal	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbd instruction

	fstmdbd	r0 !, {d0}
	fstmdbd	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdeq instruction

	fstmdbdeq	r0 !, {d0}
	fstmdbdeq	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdne instruction

	fstmdbdne	r0 !, {d0}
	fstmdbdne	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdcs instruction

	fstmdbdcs	r0 !, {d0}
	fstmdbdcs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdhs instruction

	fstmdbdhs	r0 !, {d0}
	fstmdbdhs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdcc instruction

	fstmdbdcc	r0 !, {d0}
	fstmdbdcc	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdlo instruction

	fstmdbdlo	r0 !, {d0}
	fstmdbdlo	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdmi instruction

	fstmdbdmi	r0 !, {d0}
	fstmdbdmi	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdpl instruction

	fstmdbdpl	r0 !, {d0}
	fstmdbdpl	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdvs instruction

	fstmdbdvs	r0 !, {d0}
	fstmdbdvs	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdvc instruction

	fstmdbdvc	r0 !, {d0}
	fstmdbdvc	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdhi instruction

	fstmdbdhi	r0 !, {d0}
	fstmdbdhi	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdls instruction

	fstmdbdls	r0 !, {d0}
	fstmdbdls	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdge instruction

	fstmdbdge	r0 !, {d0}
	fstmdbdge	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdlt instruction

	fstmdbdlt	r0 !, {d0}
	fstmdbdlt	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdgt instruction

	fstmdbdgt	r0 !, {d0}
	fstmdbdgt	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdle instruction

	fstmdbdle	r0 !, {d0}
	fstmdbdle	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmdbdal instruction

	fstmdbdal	r0 !, {d0}
	fstmdbdal	r15 !, {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}

positive: fstmias instruction

	fstmias	r0, {s0}
	fstmias	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmias	r0 !, {s0}
	fstmias	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiaseq instruction

	fstmiaseq	r0, {s0}
	fstmiaseq	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiaseq	r0 !, {s0}
	fstmiaseq	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasne instruction

	fstmiasne	r0, {s0}
	fstmiasne	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasne	r0 !, {s0}
	fstmiasne	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiascs instruction

	fstmiascs	r0, {s0}
	fstmiascs	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiascs	r0 !, {s0}
	fstmiascs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiashs instruction

	fstmiashs	r0, {s0}
	fstmiashs	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiashs	r0 !, {s0}
	fstmiashs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiascc instruction

	fstmiascc	r0, {s0}
	fstmiascc	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiascc	r0 !, {s0}
	fstmiascc	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiaslo instruction

	fstmiaslo	r0, {s0}
	fstmiaslo	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiaslo	r0 !, {s0}
	fstmiaslo	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasmi instruction

	fstmiasmi	r0, {s0}
	fstmiasmi	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasmi	r0 !, {s0}
	fstmiasmi	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiaspl instruction

	fstmiaspl	r0, {s0}
	fstmiaspl	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiaspl	r0 !, {s0}
	fstmiaspl	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasvs instruction

	fstmiasvs	r0, {s0}
	fstmiasvs	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasvs	r0 !, {s0}
	fstmiasvs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasvc instruction

	fstmiasvc	r0, {s0}
	fstmiasvc	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasvc	r0 !, {s0}
	fstmiasvc	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiashi instruction

	fstmiashi	r0, {s0}
	fstmiashi	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiashi	r0 !, {s0}
	fstmiashi	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasls instruction

	fstmiasls	r0, {s0}
	fstmiasls	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasls	r0 !, {s0}
	fstmiasls	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasge instruction

	fstmiasge	r0, {s0}
	fstmiasge	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasge	r0 !, {s0}
	fstmiasge	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiaslt instruction

	fstmiaslt	r0, {s0}
	fstmiaslt	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiaslt	r0 !, {s0}
	fstmiaslt	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasgt instruction

	fstmiasgt	r0, {s0}
	fstmiasgt	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasgt	r0 !, {s0}
	fstmiasgt	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasle instruction

	fstmiasle	r0, {s0}
	fstmiasle	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasle	r0 !, {s0}
	fstmiasle	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmiasal instruction

	fstmiasal	r0, {s0}
	fstmiasal	r15, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
	fstmiasal	r0 !, {s0}
	fstmiasal	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbs instruction

	fstmdbs	r0 !, {s0}
	fstmdbs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbseq instruction

	fstmdbseq	r0 !, {s0}
	fstmdbseq	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsne instruction

	fstmdbsne	r0 !, {s0}
	fstmdbsne	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbscs instruction

	fstmdbscs	r0 !, {s0}
	fstmdbscs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbshs instruction

	fstmdbshs	r0 !, {s0}
	fstmdbshs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbscc instruction

	fstmdbscc	r0 !, {s0}
	fstmdbscc	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbslo instruction

	fstmdbslo	r0 !, {s0}
	fstmdbslo	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsmi instruction

	fstmdbsmi	r0 !, {s0}
	fstmdbsmi	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbspl instruction

	fstmdbspl	r0 !, {s0}
	fstmdbspl	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsvs instruction

	fstmdbsvs	r0 !, {s0}
	fstmdbsvs	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsvc instruction

	fstmdbsvc	r0 !, {s0}
	fstmdbsvc	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbshi instruction

	fstmdbshi	r0 !, {s0}
	fstmdbshi	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsls instruction

	fstmdbsls	r0 !, {s0}
	fstmdbsls	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsge instruction

	fstmdbsge	r0 !, {s0}
	fstmdbsge	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbslt instruction

	fstmdbslt	r0 !, {s0}
	fstmdbslt	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsgt instruction

	fstmdbsgt	r0 !, {s0}
	fstmdbsgt	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsle instruction

	fstmdbsle	r0 !, {s0}
	fstmdbsle	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fstmdbsal instruction

	fstmdbsal	r0 !, {s0}
	fstmdbsal	r15 !, {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}

positive: fsubd instruction

	fsubd	d0, d0, d0
	fsubd	d15, d15, d15

positive: fsubdeq instruction

	fsubdeq	d0, d0, d0
	fsubdeq	d15, d15, d15

positive: fsubdne instruction

	fsubdne	d0, d0, d0
	fsubdne	d15, d15, d15

positive: fsubdcs instruction

	fsubdcs	d0, d0, d0
	fsubdcs	d15, d15, d15

positive: fsubdhs instruction

	fsubdhs	d0, d0, d0
	fsubdhs	d15, d15, d15

positive: fsubdcc instruction

	fsubdcc	d0, d0, d0
	fsubdcc	d15, d15, d15

positive: fsubdlo instruction

	fsubdlo	d0, d0, d0
	fsubdlo	d15, d15, d15

positive: fsubdmi instruction

	fsubdmi	d0, d0, d0
	fsubdmi	d15, d15, d15

positive: fsubdpl instruction

	fsubdpl	d0, d0, d0
	fsubdpl	d15, d15, d15

positive: fsubdvs instruction

	fsubdvs	d0, d0, d0
	fsubdvs	d15, d15, d15

positive: fsubdvc instruction

	fsubdvc	d0, d0, d0
	fsubdvc	d15, d15, d15

positive: fsubdhi instruction

	fsubdhi	d0, d0, d0
	fsubdhi	d15, d15, d15

positive: fsubdls instruction

	fsubdls	d0, d0, d0
	fsubdls	d15, d15, d15

positive: fsubdge instruction

	fsubdge	d0, d0, d0
	fsubdge	d15, d15, d15

positive: fsubdlt instruction

	fsubdlt	d0, d0, d0
	fsubdlt	d15, d15, d15

positive: fsubdgt instruction

	fsubdgt	d0, d0, d0
	fsubdgt	d15, d15, d15

positive: fsubdle instruction

	fsubdle	d0, d0, d0
	fsubdle	d15, d15, d15

positive: fsubdal instruction

	fsubdal	d0, d0, d0
	fsubdal	d15, d15, d15

positive: fsubs instruction

	fsubs	s0, s0, s0
	fsubs	s31, s31, s31

positive: fsubseq instruction

	fsubseq	s0, s0, s0
	fsubseq	s31, s31, s31

positive: fsubsne instruction

	fsubsne	s0, s0, s0
	fsubsne	s31, s31, s31

positive: fsubscs instruction

	fsubscs	s0, s0, s0
	fsubscs	s31, s31, s31

positive: fsubshs instruction

	fsubshs	s0, s0, s0
	fsubshs	s31, s31, s31

positive: fsubscc instruction

	fsubscc	s0, s0, s0
	fsubscc	s31, s31, s31

positive: fsubslo instruction

	fsubslo	s0, s0, s0
	fsubslo	s31, s31, s31

positive: fsubsmi instruction

	fsubsmi	s0, s0, s0
	fsubsmi	s31, s31, s31

positive: fsubspl instruction

	fsubspl	s0, s0, s0
	fsubspl	s31, s31, s31

positive: fsubsvs instruction

	fsubsvs	s0, s0, s0
	fsubsvs	s31, s31, s31

positive: fsubsvc instruction

	fsubsvc	s0, s0, s0
	fsubsvc	s31, s31, s31

positive: fsubshi instruction

	fsubshi	s0, s0, s0
	fsubshi	s31, s31, s31

positive: fsubsls instruction

	fsubsls	s0, s0, s0
	fsubsls	s31, s31, s31

positive: fsubsge instruction

	fsubsge	s0, s0, s0
	fsubsge	s31, s31, s31

positive: fsubslt instruction

	fsubslt	s0, s0, s0
	fsubslt	s31, s31, s31

positive: fsubsgt instruction

	fsubsgt	s0, s0, s0
	fsubsgt	s31, s31, s31

positive: fsubsle instruction

	fsubsle	s0, s0, s0
	fsubsle	s31, s31, s31

positive: fsubsal instruction

	fsubsal	s0, s0, s0
	fsubsal	s31, s31, s31

positive: ftosid instruction

	ftosid	s0, d0
	ftosid	s31, d15

positive: ftosideq instruction

	ftosideq	s0, d0
	ftosideq	s31, d15

positive: ftosidne instruction

	ftosidne	s0, d0
	ftosidne	s31, d15

positive: ftosidcs instruction

	ftosidcs	s0, d0
	ftosidcs	s31, d15

positive: ftosidhs instruction

	ftosidhs	s0, d0
	ftosidhs	s31, d15

positive: ftosidcc instruction

	ftosidcc	s0, d0
	ftosidcc	s31, d15

positive: ftosidlo instruction

	ftosidlo	s0, d0
	ftosidlo	s31, d15

positive: ftosidmi instruction

	ftosidmi	s0, d0
	ftosidmi	s31, d15

positive: ftosidpl instruction

	ftosidpl	s0, d0
	ftosidpl	s31, d15

positive: ftosidvs instruction

	ftosidvs	s0, d0
	ftosidvs	s31, d15

positive: ftosidvc instruction

	ftosidvc	s0, d0
	ftosidvc	s31, d15

positive: ftosidhi instruction

	ftosidhi	s0, d0
	ftosidhi	s31, d15

positive: ftosidls instruction

	ftosidls	s0, d0
	ftosidls	s31, d15

positive: ftosidge instruction

	ftosidge	s0, d0
	ftosidge	s31, d15

positive: ftosidlt instruction

	ftosidlt	s0, d0
	ftosidlt	s31, d15

positive: ftosidgt instruction

	ftosidgt	s0, d0
	ftosidgt	s31, d15

positive: ftosidle instruction

	ftosidle	s0, d0
	ftosidle	s31, d15

positive: ftosidal instruction

	ftosidal	s0, d0
	ftosidal	s31, d15

positive: ftosizd instruction

	ftosizd	s0, d0
	ftosizd	s31, d15

positive: ftosizdeq instruction

	ftosizdeq	s0, d0
	ftosizdeq	s31, d15

positive: ftosizdne instruction

	ftosizdne	s0, d0
	ftosizdne	s31, d15

positive: ftosizdcs instruction

	ftosizdcs	s0, d0
	ftosizdcs	s31, d15

positive: ftosizdhs instruction

	ftosizdhs	s0, d0
	ftosizdhs	s31, d15

positive: ftosizdcc instruction

	ftosizdcc	s0, d0
	ftosizdcc	s31, d15

positive: ftosizdlo instruction

	ftosizdlo	s0, d0
	ftosizdlo	s31, d15

positive: ftosizdmi instruction

	ftosizdmi	s0, d0
	ftosizdmi	s31, d15

positive: ftosizdpl instruction

	ftosizdpl	s0, d0
	ftosizdpl	s31, d15

positive: ftosizdvs instruction

	ftosizdvs	s0, d0
	ftosizdvs	s31, d15

positive: ftosizdvc instruction

	ftosizdvc	s0, d0
	ftosizdvc	s31, d15

positive: ftosizdhi instruction

	ftosizdhi	s0, d0
	ftosizdhi	s31, d15

positive: ftosizdls instruction

	ftosizdls	s0, d0
	ftosizdls	s31, d15

positive: ftosizdge instruction

	ftosizdge	s0, d0
	ftosizdge	s31, d15

positive: ftosizdlt instruction

	ftosizdlt	s0, d0
	ftosizdlt	s31, d15

positive: ftosizdgt instruction

	ftosizdgt	s0, d0
	ftosizdgt	s31, d15

positive: ftosizdle instruction

	ftosizdle	s0, d0
	ftosizdle	s31, d15

positive: ftosizdal instruction

	ftosizdal	s0, d0
	ftosizdal	s31, d15

positive: ftosis instruction

	ftosis	s0, s0
	ftosis	s31, s31

positive: ftosiseq instruction

	ftosiseq	s0, s0
	ftosiseq	s31, s31

positive: ftosisne instruction

	ftosisne	s0, s0
	ftosisne	s31, s31

positive: ftosiscs instruction

	ftosiscs	s0, s0
	ftosiscs	s31, s31

positive: ftosishs instruction

	ftosishs	s0, s0
	ftosishs	s31, s31

positive: ftosiscc instruction

	ftosiscc	s0, s0
	ftosiscc	s31, s31

positive: ftosislo instruction

	ftosislo	s0, s0
	ftosislo	s31, s31

positive: ftosismi instruction

	ftosismi	s0, s0
	ftosismi	s31, s31

positive: ftosispl instruction

	ftosispl	s0, s0
	ftosispl	s31, s31

positive: ftosisvs instruction

	ftosisvs	s0, s0
	ftosisvs	s31, s31

positive: ftosisvc instruction

	ftosisvc	s0, s0
	ftosisvc	s31, s31

positive: ftosishi instruction

	ftosishi	s0, s0
	ftosishi	s31, s31

positive: ftosisls instruction

	ftosisls	s0, s0
	ftosisls	s31, s31

positive: ftosisge instruction

	ftosisge	s0, s0
	ftosisge	s31, s31

positive: ftosislt instruction

	ftosislt	s0, s0
	ftosislt	s31, s31

positive: ftosisgt instruction

	ftosisgt	s0, s0
	ftosisgt	s31, s31

positive: ftosisle instruction

	ftosisle	s0, s0
	ftosisle	s31, s31

positive: ftosisal instruction

	ftosisal	s0, s0
	ftosisal	s31, s31

positive: ftosizs instruction

	ftosizs	s0, s0
	ftosizs	s31, s31

positive: ftosizseq instruction

	ftosizseq	s0, s0
	ftosizseq	s31, s31

positive: ftosizsne instruction

	ftosizsne	s0, s0
	ftosizsne	s31, s31

positive: ftosizscs instruction

	ftosizscs	s0, s0
	ftosizscs	s31, s31

positive: ftosizshs instruction

	ftosizshs	s0, s0
	ftosizshs	s31, s31

positive: ftosizscc instruction

	ftosizscc	s0, s0
	ftosizscc	s31, s31

positive: ftosizslo instruction

	ftosizslo	s0, s0
	ftosizslo	s31, s31

positive: ftosizsmi instruction

	ftosizsmi	s0, s0
	ftosizsmi	s31, s31

positive: ftosizspl instruction

	ftosizspl	s0, s0
	ftosizspl	s31, s31

positive: ftosizsvs instruction

	ftosizsvs	s0, s0
	ftosizsvs	s31, s31

positive: ftosizsvc instruction

	ftosizsvc	s0, s0
	ftosizsvc	s31, s31

positive: ftosizshi instruction

	ftosizshi	s0, s0
	ftosizshi	s31, s31

positive: ftosizsls instruction

	ftosizsls	s0, s0
	ftosizsls	s31, s31

positive: ftosizsge instruction

	ftosizsge	s0, s0
	ftosizsge	s31, s31

positive: ftosizslt instruction

	ftosizslt	s0, s0
	ftosizslt	s31, s31

positive: ftosizsgt instruction

	ftosizsgt	s0, s0
	ftosizsgt	s31, s31

positive: ftosizsle instruction

	ftosizsle	s0, s0
	ftosizsle	s31, s31

positive: ftosizsal instruction

	ftosizsal	s0, s0
	ftosizsal	s31, s31

positive: ftouid instruction

	ftouid	s0, d0
	ftouid	s31, d15

positive: ftouideq instruction

	ftouideq	s0, d0
	ftouideq	s31, d15

positive: ftouidne instruction

	ftouidne	s0, d0
	ftouidne	s31, d15

positive: ftouidcs instruction

	ftouidcs	s0, d0
	ftouidcs	s31, d15

positive: ftouidhs instruction

	ftouidhs	s0, d0
	ftouidhs	s31, d15

positive: ftouidcc instruction

	ftouidcc	s0, d0
	ftouidcc	s31, d15

positive: ftouidlo instruction

	ftouidlo	s0, d0
	ftouidlo	s31, d15

positive: ftouidmi instruction

	ftouidmi	s0, d0
	ftouidmi	s31, d15

positive: ftouidpl instruction

	ftouidpl	s0, d0
	ftouidpl	s31, d15

positive: ftouidvs instruction

	ftouidvs	s0, d0
	ftouidvs	s31, d15

positive: ftouidvc instruction

	ftouidvc	s0, d0
	ftouidvc	s31, d15

positive: ftouidhi instruction

	ftouidhi	s0, d0
	ftouidhi	s31, d15

positive: ftouidls instruction

	ftouidls	s0, d0
	ftouidls	s31, d15

positive: ftouidge instruction

	ftouidge	s0, d0
	ftouidge	s31, d15

positive: ftouidlt instruction

	ftouidlt	s0, d0
	ftouidlt	s31, d15

positive: ftouidgt instruction

	ftouidgt	s0, d0
	ftouidgt	s31, d15

positive: ftouidle instruction

	ftouidle	s0, d0
	ftouidle	s31, d15

positive: ftouidal instruction

	ftouidal	s0, d0
	ftouidal	s31, d15

positive: ftouizd instruction

	ftouizd	s0, d0
	ftouizd	s31, d15

positive: ftouizdeq instruction

	ftouizdeq	s0, d0
	ftouizdeq	s31, d15

positive: ftouizdne instruction

	ftouizdne	s0, d0
	ftouizdne	s31, d15

positive: ftouizdcs instruction

	ftouizdcs	s0, d0
	ftouizdcs	s31, d15

positive: ftouizdhs instruction

	ftouizdhs	s0, d0
	ftouizdhs	s31, d15

positive: ftouizdcc instruction

	ftouizdcc	s0, d0
	ftouizdcc	s31, d15

positive: ftouizdlo instruction

	ftouizdlo	s0, d0
	ftouizdlo	s31, d15

positive: ftouizdmi instruction

	ftouizdmi	s0, d0
	ftouizdmi	s31, d15

positive: ftouizdpl instruction

	ftouizdpl	s0, d0
	ftouizdpl	s31, d15

positive: ftouizdvs instruction

	ftouizdvs	s0, d0
	ftouizdvs	s31, d15

positive: ftouizdvc instruction

	ftouizdvc	s0, d0
	ftouizdvc	s31, d15

positive: ftouizdhi instruction

	ftouizdhi	s0, d0
	ftouizdhi	s31, d15

positive: ftouizdls instruction

	ftouizdls	s0, d0
	ftouizdls	s31, d15

positive: ftouizdge instruction

	ftouizdge	s0, d0
	ftouizdge	s31, d15

positive: ftouizdlt instruction

	ftouizdlt	s0, d0
	ftouizdlt	s31, d15

positive: ftouizdgt instruction

	ftouizdgt	s0, d0
	ftouizdgt	s31, d15

positive: ftouizdle instruction

	ftouizdle	s0, d0
	ftouizdle	s31, d15

positive: ftouizdal instruction

	ftouizdal	s0, d0
	ftouizdal	s31, d15

positive: ftouis instruction

	ftouis	s0, s0
	ftouis	s31, s31

positive: ftouiseq instruction

	ftouiseq	s0, s0
	ftouiseq	s31, s31

positive: ftouisne instruction

	ftouisne	s0, s0
	ftouisne	s31, s31

positive: ftouiscs instruction

	ftouiscs	s0, s0
	ftouiscs	s31, s31

positive: ftouishs instruction

	ftouishs	s0, s0
	ftouishs	s31, s31

positive: ftouiscc instruction

	ftouiscc	s0, s0
	ftouiscc	s31, s31

positive: ftouislo instruction

	ftouislo	s0, s0
	ftouislo	s31, s31

positive: ftouismi instruction

	ftouismi	s0, s0
	ftouismi	s31, s31

positive: ftouispl instruction

	ftouispl	s0, s0
	ftouispl	s31, s31

positive: ftouisvs instruction

	ftouisvs	s0, s0
	ftouisvs	s31, s31

positive: ftouisvc instruction

	ftouisvc	s0, s0
	ftouisvc	s31, s31

positive: ftouishi instruction

	ftouishi	s0, s0
	ftouishi	s31, s31

positive: ftouisls instruction

	ftouisls	s0, s0
	ftouisls	s31, s31

positive: ftouisge instruction

	ftouisge	s0, s0
	ftouisge	s31, s31

positive: ftouislt instruction

	ftouislt	s0, s0
	ftouislt	s31, s31

positive: ftouisgt instruction

	ftouisgt	s0, s0
	ftouisgt	s31, s31

positive: ftouisle instruction

	ftouisle	s0, s0
	ftouisle	s31, s31

positive: ftouisal instruction

	ftouisal	s0, s0
	ftouisal	s31, s31

positive: ftouizs instruction

	ftouizs	s0, s0
	ftouizs	s31, s31

positive: ftouizseq instruction

	ftouizseq	s0, s0
	ftouizseq	s31, s31

positive: ftouizsne instruction

	ftouizsne	s0, s0
	ftouizsne	s31, s31

positive: ftouizscs instruction

	ftouizscs	s0, s0
	ftouizscs	s31, s31

positive: ftouizshs instruction

	ftouizshs	s0, s0
	ftouizshs	s31, s31

positive: ftouizscc instruction

	ftouizscc	s0, s0
	ftouizscc	s31, s31

positive: ftouizslo instruction

	ftouizslo	s0, s0
	ftouizslo	s31, s31

positive: ftouizsmi instruction

	ftouizsmi	s0, s0
	ftouizsmi	s31, s31

positive: ftouizspl instruction

	ftouizspl	s0, s0
	ftouizspl	s31, s31

positive: ftouizsvs instruction

	ftouizsvs	s0, s0
	ftouizsvs	s31, s31

positive: ftouizsvc instruction

	ftouizsvc	s0, s0
	ftouizsvc	s31, s31

positive: ftouizshi instruction

	ftouizshi	s0, s0
	ftouizshi	s31, s31

positive: ftouizsls instruction

	ftouizsls	s0, s0
	ftouizsls	s31, s31

positive: ftouizsge instruction

	ftouizsge	s0, s0
	ftouizsge	s31, s31

positive: ftouizslt instruction

	ftouizslt	s0, s0
	ftouizslt	s31, s31

positive: ftouizsgt instruction

	ftouizsgt	s0, s0
	ftouizsgt	s31, s31

positive: ftouizsle instruction

	ftouizsle	s0, s0
	ftouizsle	s31, s31

positive: ftouizsal instruction

	ftouizsal	s0, s0
	ftouizsal	s31, s31

positive: fuitod instruction

	fuitod	d0, s0
	fuitod	d15, s31

positive: fuitodeq instruction

	fuitodeq	d0, s0
	fuitodeq	d15, s31

positive: fuitodne instruction

	fuitodne	d0, s0
	fuitodne	d15, s31

positive: fuitodcs instruction

	fuitodcs	d0, s0
	fuitodcs	d15, s31

positive: fuitodhs instruction

	fuitodhs	d0, s0
	fuitodhs	d15, s31

positive: fuitodcc instruction

	fuitodcc	d0, s0
	fuitodcc	d15, s31

positive: fuitodlo instruction

	fuitodlo	d0, s0
	fuitodlo	d15, s31

positive: fuitodmi instruction

	fuitodmi	d0, s0
	fuitodmi	d15, s31

positive: fuitodpl instruction

	fuitodpl	d0, s0
	fuitodpl	d15, s31

positive: fuitodvs instruction

	fuitodvs	d0, s0
	fuitodvs	d15, s31

positive: fuitodvc instruction

	fuitodvc	d0, s0
	fuitodvc	d15, s31

positive: fuitodhi instruction

	fuitodhi	d0, s0
	fuitodhi	d15, s31

positive: fuitodls instruction

	fuitodls	d0, s0
	fuitodls	d15, s31

positive: fuitodge instruction

	fuitodge	d0, s0
	fuitodge	d15, s31

positive: fuitodlt instruction

	fuitodlt	d0, s0
	fuitodlt	d15, s31

positive: fuitodgt instruction

	fuitodgt	d0, s0
	fuitodgt	d15, s31

positive: fuitodle instruction

	fuitodle	d0, s0
	fuitodle	d15, s31

positive: fuitodal instruction

	fuitodal	d0, s0
	fuitodal	d15, s31

positive: fuitos instruction

	fuitos	s0, s0
	fuitos	s31, s31

positive: fuitoseq instruction

	fuitoseq	s0, s0
	fuitoseq	s31, s31

positive: fuitosne instruction

	fuitosne	s0, s0
	fuitosne	s31, s31

positive: fuitoscs instruction

	fuitoscs	s0, s0
	fuitoscs	s31, s31

positive: fuitoshs instruction

	fuitoshs	s0, s0
	fuitoshs	s31, s31

positive: fuitoscc instruction

	fuitoscc	s0, s0
	fuitoscc	s31, s31

positive: fuitoslo instruction

	fuitoslo	s0, s0
	fuitoslo	s31, s31

positive: fuitosmi instruction

	fuitosmi	s0, s0
	fuitosmi	s31, s31

positive: fuitospl instruction

	fuitospl	s0, s0
	fuitospl	s31, s31

positive: fuitosvs instruction

	fuitosvs	s0, s0
	fuitosvs	s31, s31

positive: fuitosvc instruction

	fuitosvc	s0, s0
	fuitosvc	s31, s31

positive: fuitoshi instruction

	fuitoshi	s0, s0
	fuitoshi	s31, s31

positive: fuitosls instruction

	fuitosls	s0, s0
	fuitosls	s31, s31

positive: fuitosge instruction

	fuitosge	s0, s0
	fuitosge	s31, s31

positive: fuitoslt instruction

	fuitoslt	s0, s0
	fuitoslt	s31, s31

positive: fuitosgt instruction

	fuitosgt	s0, s0
	fuitosgt	s31, s31

positive: fuitosle instruction

	fuitosle	s0, s0
	fuitosle	s31, s31

positive: fuitosal instruction

	fuitosal	s0, s0
	fuitosal	s31, s31

# ARM A64 assembler test and validation suite
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

	64

negative: bit mode directive missing mode

	.bitmode

negative: bit mode directive with mode in comment

	.bitmode	; 64

negative: bit mode directive with mode on new line

	.bitmode
	64

negative: labeled bit mode directive

	label:	.bitmode	64

negative: negative bit mode

	.bitmode	-64

negative: 0-bit mode

	.bitmode	0

negative: 8-bit mode

	.bitmode	8

negative: 16-bit mode

	.bitmode	16

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

positive: 64-bit mode

	.bitmode	64
	.assert	.bitmode == 64

negative: 128-bit mode

	.bitmode	128

positive: duplicated bit mode

	.bitmode	32
	.assert	.bitmode == 32
	.bitmode	64
	.assert	.bitmode == 64
	.bitmode	32
	.assert	.bitmode == 32
	.bitmode	64
	.assert	.bitmode == 64

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

# ARM A64 assembler

# base instructions

positive: adc instruction

	adc	w0, w0, w0
	adc	wzr, wzr, wzr
	adc	x0, x0, x0
	adc	xzr, xzr, xzr

positive: adcs instruction

	adcs	w0, w0, w0
	adcs	wzr, wzr, wzr
	adcs	x0, x0, x0
	adcs	xzr, xzr, xzr

positive: add instruction

	add	w0, w0, w0
	add	wsp, wsp, wzr
	add	w0, w0, w0, lsl 0
	add	wsp, wsp, wzr, lsl 3
	add	w0, w0, w0, uxtb 0
	add	wsp, wsp, wzr, uxtb 3
	add	w0, w0, w0, uxth 0
	add	wsp, wsp, wzr, uxth 3
	add	w0, w0, w0, uxtw 0
	add	wsp, wsp, wzr, uxtw 3
	add	w0, w0, w0, uxtx 0
	add	wsp, wsp, wzr, uxtx 3
	add	w0, w0, w0, sxtb 0
	add	wsp, wsp, wzr, sxtb 3
	add	w0, w0, w0, sxth 0
	add	wsp, wsp, wzr, sxth 3
	add	w0, w0, w0, sxtw 0
	add	wsp, wsp, wzr, sxtw 3
	add	w0, w0, w0, sxtx 0
	add	wsp, wsp, wzr, sxtx 3
	add	x0, x0, x0
	add	sp, sp, xzr
	add	x0, x0, x0, lsl 0
	add	sp, sp, xzr, lsl 3
	add	x0, x0, x0, uxtb 0
	add	sp, sp, xzr, uxtb 3
	add	x0, x0, x0, uxth 0
	add	sp, sp, xzr, uxth 3
	add	x0, x0, x0, uxtw 0
	add	sp, sp, xzr, uxtw 3
	add	x0, x0, x0, uxtx 0
	add	sp, sp, xzr, uxtx 3
	add	x0, x0, x0, sxtb 0
	add	sp, sp, xzr, sxtb 3
	add	x0, x0, x0, sxth 0
	add	sp, sp, xzr, sxth 3
	add	x0, x0, x0, sxtw 0
	add	sp, sp, xzr, sxtw 3
	add	x0, x0, x0, sxtx 0
	add	sp, sp, xzr, sxtx 3
	add	w0, w0, 0
	add	wsp, wsp, 4095
	add	w0, w0, 0, lsl 0
	add	wsp, wsp, 4095, lsl 0
	add	w0, w0, 0, lsl 12
	add	wsp, wsp, 4095, lsl 12
	add	x0, x0, 0
	add	sp, sp, 4095
	add	x0, x0, 0, lsl 0
	add	sp, sp, 4095, lsl 0
	add	x0, x0, 0, lsl 12
	add	sp, sp, 4095, lsl 12
	add	w0, w0, w0
	add	wzr, wzr, wzr
	add	w0, w0, w0, lsl 0
	add	wzr, wzr, wzr, lsl 31
	add	w0, w0, w0, lsr 0
	add	wzr, wzr, wzr, lsr 31
	add	w0, w0, w0, asr 0
	add	wzr, wzr, wzr, asr 31
	add	x0, x0, x0
	add	xzr, xzr, xzr
	add	x0, x0, x0, lsl 0
	add	xzr, xzr, xzr, lsl 63
	add	x0, x0, x0, lsr 0
	add	xzr, xzr, xzr, lsr 63
	add	x0, x0, x0, asr 0
	add	xzr, xzr, xzr, asr 63
	add	d0, d0, d0
	add	d31, d31, d31
	add	v0.8b, v0.8b, v0.8b
	add	v31.8b, v31.8b, v31.8b
	add	v0.16b, v0.16b, v0.16b
	add	v31.16b, v31.16b, v31.16b
	add	v0.4h, v0.4h, v0.4h
	add	v31.4h, v31.4h, v31.4h
	add	v0.8h, v0.8h, v0.8h
	add	v31.8h, v31.8h, v31.8h
	add	v0.2s, v0.2s, v0.2s
	add	v31.2s, v31.2s, v31.2s
	add	v0.4s, v0.4s, v0.4s
	add	v31.4s, v31.4s, v31.4s
	add	v0.2d, v0.2d, v0.2d
	add	v31.2d, v31.2d, v31.2d

positive: adds instruction

	adds	w0, w0, w0
	adds	wsp, wsp, wzr
	adds	w0, w0, w0, lsl 0
	adds	wsp, wsp, wzr, lsl 3
	adds	w0, w0, w0, uxtb 0
	adds	wsp, wsp, wzr, uxtb 3
	adds	w0, w0, w0, uxth 0
	adds	wsp, wsp, wzr, uxth 3
	adds	w0, w0, w0, uxtw 0
	adds	wsp, wsp, wzr, uxtw 3
	adds	w0, w0, w0, uxtx 0
	adds	wsp, wsp, wzr, uxtx 3
	adds	w0, w0, w0, sxtb 0
	adds	wsp, wsp, wzr, sxtb 3
	adds	w0, w0, w0, sxth 0
	adds	wsp, wsp, wzr, sxth 3
	adds	w0, w0, w0, sxtw 0
	adds	wsp, wsp, wzr, sxtw 3
	adds	w0, w0, w0, sxtx 0
	adds	wsp, wsp, wzr, sxtx 3
	adds	x0, x0, x0
	adds	sp, sp, xzr
	adds	x0, x0, x0, lsl 0
	adds	sp, sp, xzr, lsl 3
	adds	x0, x0, x0, uxtb 0
	adds	sp, sp, xzr, uxtb 3
	adds	x0, x0, x0, uxth 0
	adds	sp, sp, xzr, uxth 3
	adds	x0, x0, x0, uxtw 0
	adds	sp, sp, xzr, uxtw 3
	adds	x0, x0, x0, uxtx 0
	adds	sp, sp, xzr, uxtx 3
	adds	x0, x0, x0, sxtb 0
	adds	sp, sp, xzr, sxtb 3
	adds	x0, x0, x0, sxth 0
	adds	sp, sp, xzr, sxth 3
	adds	x0, x0, x0, sxtw 0
	adds	sp, sp, xzr, sxtw 3
	adds	x0, x0, x0, sxtx 0
	adds	sp, sp, xzr, sxtx 3
	adds	w0, w0, 0
	adds	wsp, wsp, 4095
	adds	w0, w0, 0, lsl 0
	adds	wsp, wsp, 4095, lsl 0
	adds	w0, w0, 0, lsl 12
	adds	wsp, wsp, 4095, lsl 12
	adds	x0, x0, 0
	adds	sp, sp, 4095
	adds	x0, x0, 0, lsl 0
	adds	sp, sp, 4095, lsl 0
	adds	x0, x0, 0, lsl 12
	adds	sp, sp, 4095, lsl 12
	adds	w0, w0, w0
	adds	wzr, wzr, wzr
	adds	w0, w0, w0, lsl 0
	adds	wzr, wzr, wzr, lsl 31
	adds	w0, w0, w0, lsr 0
	adds	wzr, wzr, wzr, lsr 31
	adds	w0, w0, w0, asr 0
	adds	wzr, wzr, wzr, asr 31
	adds	x0, x0, x0
	adds	xzr, xzr, xzr
	adds	x0, x0, x0, lsl 0
	adds	xzr, xzr, xzr, lsl 63
	adds	x0, x0, x0, lsr 0
	adds	xzr, xzr, xzr, lsr 63
	adds	x0, x0, x0, asr 0
	adds	xzr, xzr, xzr, asr 63

positive: adr instruction

	adr	x0, -1048576
	adr	xzr, +1048575

positive: adrp instruction

	adrp	x0, -4294967296
	adrp	xzr, +4294963200

positive: and instruction

	and	w0, w0, 0x1
	and	wsp, wzr, 0x7fffffff
	and	x0, x0, 0x1
	and	sp, xzr, 0x7fffffffffffffff
	and	w0, w0, w0
	and	wzr, wzr, wzr
	and	w0, w0, w0, lsl 0
	and	wzr, wzr, wzr, lsl 31
	and	w0, w0, w0, lsr 0
	and	wzr, wzr, wzr, lsr 31
	and	w0, w0, w0, asr 0
	and	wzr, wzr, wzr, asr 31
	and	w0, w0, w0, ror 0
	and	wzr, wzr, wzr, ror 31
	and	x0, x0, x0
	and	xzr, xzr, xzr
	and	x0, x0, x0, lsl 0
	and	xzr, xzr, xzr, lsl 63
	and	x0, x0, x0, lsr 0
	and	xzr, xzr, xzr, lsr 63
	and	x0, x0, x0, asr 0
	and	xzr, xzr, xzr, asr 63
	and	x0, x0, x0, ror 0
	and	xzr, xzr, xzr, ror 63
	add	v0.8b, v0.8b, v0.8b
	add	v31.8b, v31.8b, v31.8b
	add	v0.16b, v0.16b, v0.16b
	add	v31.16b, v31.16b, v31.16b

positive: ands instruction

	ands	w0, w0, 0x1
	ands	wsp, wzr, 0x7fffffff
	ands	x0, x0, 0x1
	ands	sp, xzr, 0x7fffffffffffffff
	ands	w0, w0, w0
	ands	wzr, wzr, wzr
	ands	w0, w0, w0, lsl 0
	ands	wzr, wzr, wzr, lsl 31
	ands	w0, w0, w0, lsr 0
	ands	wzr, wzr, wzr, lsr 31
	ands	w0, w0, w0, asr 0
	ands	wzr, wzr, wzr, asr 31
	ands	w0, w0, w0, ror 0
	ands	wzr, wzr, wzr, ror 31
	ands	x0, x0, x0
	ands	xzr, xzr, xzr
	ands	x0, x0, x0, lsl 0
	ands	xzr, xzr, xzr, lsl 63
	ands	x0, x0, x0, lsr 0
	ands	xzr, xzr, xzr, lsr 63
	ands	x0, x0, x0, asr 0
	ands	xzr, xzr, xzr, asr 63
	ands	x0, x0, x0, ror 0
	ands	xzr, xzr, xzr, ror 63

positive: asr instruction

	asr	w0, w0, w0
	asr	wzr, wzr, wzr
	asr	x0, x0, x0
	asr	xzr, xzr, xzr
	asr	w0, w0, 0
	asr	wzr, wzr, 31
	asr	x0, x0, 0
	asr	xzr, xzr, 63

positive: asrv instruction

	asrv	w0, w0, w0
	asrv	wzr, wzr, wzr
	asrv	x0, x0, x0
	asrv	xzr, xzr, xzr

positive: at instruction

	at	s1e1r, x0
	at	s1e1r, xzr
	at	s1e0r, x0
	at	s1e0w, x0
	at	s1e2r, x0
	at	s1e2w, x0
	at	s12e1r, x0
	at	s12e1w, x0
	at	s12e0r, x0
	at	s12e0w, x0
	at	s1e3r, x0
	at	s1e3w, x0
	at	s1e1rp, x0
	at	s1e1wp, x0

positive: autda instruction

	autda	x0, x0
	autda	xzr, sp

positive: autdza instruction

	autdza	x0
	autdza	xzr

positive: autdb instruction

	autdb	x0, x0
	autdb	xzr, sp

positive: autdzb instruction

	autdzb	x0
	autdzb	xzr

positive: autia instruction

	autia	x0, x0
	autia	xzr, sp

positive: autiza instruction

	autiza	x0
	autiza	xzr

positive: autiasp instruction

	autiasp

positive: autia1716 instruction

	autia1716

positive: autiaz instruction

	autiaz

positive: autib instruction

	autib	x0, x0
	autib	xzr, sp

positive: autizb instruction

	autizb	x0
	autizb	xzr

positive: autibsp instruction

	autibsp

positive: autib1716 instruction

	autib1716

positive: autibz instruction

	autibz

positive: b.eq instruction

	b.eq	-1048576
	b.eq	+1048572

positive: b.ne instruction

	b.ne	-1048576
	b.ne	+1048572

positive: b.cs instruction

	b.cs	-1048576
	b.cs	+1048572

positive: b.hs instruction

	b.hs	-1048576
	b.hs	+1048572

positive: b.cc instruction

	b.cc	-1048576
	b.cc	+1048572

positive: b.lo instruction

	b.lo	-1048576
	b.lo	+1048572

positive: b.mi instruction

	b.mi	-1048576
	b.mi	+1048572

positive: b.pl instruction

	b.pl	-1048576
	b.pl	+1048572

positive: b.vs instruction

	b.vs	-1048576
	b.vs	+1048572

positive: b.vc instruction

	b.vc	-1048576
	b.vc	+1048572

positive: b.hi instruction

	b.hi	-1048576
	b.hi	+1048572

positive: b.ls instruction

	b.ls	-1048576
	b.ls	+1048572

positive: b.ge instruction

	b.ge	-1048576
	b.ge	+1048572

positive: b.lt instruction

	b.lt	-1048576
	b.lt	+1048572

positive: b.gt instruction

	b.gt	-1048576
	b.gt	+1048572

positive: b.le instruction

	b.le	-1048576
	b.le	+1048572

positive: b.al instruction

	b.al	-1048576
	b.al	+1048572

positive: b.nv instruction

	b.nv	-1048576
	b.nv	+1048572

positive: b instruction

	b	-134217728
	b	+134217724

positive: bfc instruction

	bfc	w0, 0, 1
	bfc	wzr, 31, 32
	bfc	x0, 0, 1
	bfc	xzr, 63, 64

positive: bfi instruction

	bfi	w0, w0, 0, 1
	bfi	wzr, w30, 31, 32
	bfi	x0, x0, 0, 1
	bfi	xzr, x30, 63, 64

positive: bfm instruction

	bfm	w0, w0, 0, 0
	bfm	wzr, wzr, 31, 31
	bfm	x0, x0, 0, 0
	bfm	xzr, xzr, 63, 63

positive: bfxil instruction

	bfxil	w0, w0, 0, 32
	bfxil	wzr, wzr, 31, 1
	bfxil	x0, x0, 0, 64
	bfxil	xzr, xzr, 63, 1

positive: bic instruction

	bic	w0, w0, w0
	bic	wzr, wzr, wzr
	bic	w0, w0, w0, lsl 0
	bic	wzr, wzr, wzr, lsl 31
	bic	w0, w0, w0, lsr 0
	bic	wzr, wzr, wzr, lsr 31
	bic	w0, w0, w0, asr 0
	bic	wzr, wzr, wzr, asr 31
	bic	w0, w0, w0, ror 0
	bic	wzr, wzr, wzr, ror 31
	bic	x0, x0, x0
	bic	xzr, xzr, xzr
	bic	x0, x0, x0, lsl 0
	bic	xzr, xzr, xzr, lsl 63
	bic	x0, x0, x0, lsr 0
	bic	xzr, xzr, xzr, lsr 63
	bic	x0, x0, x0, asr 0
	bic	xzr, xzr, xzr, asr 63
	bic	x0, x0, x0, ror 0
	bic	xzr, xzr, xzr, ror 63
	bic	v0.4h, 0, lsl 0
	bic	v31.4h, 255, lsl 8
	bic	v0.8h, 0, lsl 0
	bic	v31.8h, 255, lsl 8
	bic	v0.2s, 0, lsl 0
	bic	v31.2s, 255, lsl 24
	bic	v0.4s, 0, lsl 0
	bic	v31.4s, 255, lsl 24
	bic	v0.8b, v0.8b, v0.8b
	bic	v31.8b, v31.8b, v31.8b
	bic	v0.16b, v0.16b, v0.16b
	bic	v31.16b, v31.16b, v31.16b

positive: bics instruction

	bics	w0, w0, w0
	bics	wzr, wzr, wzr
	bics	w0, w0, w0, lsl 0
	bics	wzr, wzr, wzr, lsl 31
	bics	w0, w0, w0, lsr 0
	bics	wzr, wzr, wzr, lsr 31
	bics	w0, w0, w0, asr 0
	bics	wzr, wzr, wzr, asr 31
	bics	w0, w0, w0, ror 0
	bics	wzr, wzr, wzr, ror 31
	bics	x0, x0, x0
	bics	xzr, xzr, xzr
	bics	x0, x0, x0, lsl 0
	bics	xzr, xzr, xzr, lsl 63
	bics	x0, x0, x0, lsr 0
	bics	xzr, xzr, xzr, lsr 63
	bics	x0, x0, x0, asr 0
	bics	xzr, xzr, xzr, asr 63
	bics	x0, x0, x0, ror 0
	bics	xzr, xzr, xzr, ror 63

positive: bl instruction

	bl	-134217728
	bl	+134217724

positive: blr instruction

	blr	x0
	blr	xzr

positive: blraa instruction

	blraa	x0, x0
	blraa	xzr, sp

positive: blraaz instruction

	blraaz	x0
	blraaz	xzr

positive: blrab instruction

	blrab	x0, x0
	blrab	xzr, sp

positive: blrabz instruction

	blrabz	x0
	blrabz	xzr

positive: br instruction

	br	x0
	br	xzr

positive: braa instruction

	braa	x0, x0
	braa	xzr, sp

positive: braaz instruction

	braaz	x0
	braaz	xzr

positive: brab instruction

	brab	x0, x0
	brab	xzr, sp

positive: brabz instruction

	brabz	x0
	brabz	xzr

positive: brk instruction

	brk	0
	brk	65535

positive: casab instruction

	casab	w0, w0, [x0]
	casab	wzr, wzr, [sp, 0]

positive: casalb instruction

	casalb	w0, w0, [x0]
	casalb	wzr, wzr, [sp, 0]

positive: casb instruction

	casb	w0, w0, [x0]
	casb	wzr, wzr, [sp, 0]

positive: caslb instruction

	caslb	w0, w0, [x0]
	caslb	wzr, wzr, [sp, 0]

positive: casah instruction

	casah	w0, w0, [x0]
	casah	wzr, wzr, [sp, 0]

positive: casalh instruction

	casalh	w0, w0, [x0]
	casalh	wzr, wzr, [sp, 0]

positive: cash instruction

	cash	w0, w0, [x0]
	cash	wzr, wzr, [sp, 0]

positive: caslh instruction

	caslh	w0, w0, [x0]
	caslh	wzr, wzr, [sp, 0]

positive: cas instruction

	cas	w0, w0, [x0]
	cas	wzr, wzr, [sp, 0]
	cas	x0, x0, [x0]
	cas	xzr, xzr, [sp, 0]

positive: casa instruction

	casa	w0, w0, [x0]
	casa	wzr, wzr, [sp, 0]
	casa	x0, x0, [x0]
	casa	xzr, xzr, [sp, 0]

positive: casal instruction

	casal	w0, w0, [x0]
	casal	wzr, wzr, [sp, 0]
	casal	x0, x0, [x0]
	casal	xzr, xzr, [sp, 0]

positive: casl instruction

	casl	w0, w0, [x0]
	casl	wzr, wzr, [sp, 0]
	casl	x0, x0, [x0]
	casl	xzr, xzr, [sp, 0]

positive: casp instruction

	casp	w0, w1, w0, w1, [x0]
	casp	w30, wzr, w30, wzr, [sp, 0]
	casp	x0, x1, x0, x1, [x0]
	casp	x30, xzr, x30, xzr, [sp, 0]

positive: caspa instruction

	caspa	w0, w1, w0, w1, [x0]
	caspa	w30, wzr, w30, wzr, [sp, 0]
	caspa	x0, x1, x0, x1, [x0]
	caspa	x30, xzr, x30, xzr, [sp, 0]

positive: caspal instruction

	caspal	w0, w1, w0, w1, [x0]
	caspal	w30, wzr, w30, wzr, [sp, 0]
	caspal	x0, x1, x0, x1, [x0]
	caspal	x30, xzr, x30, xzr, [sp, 0]

positive: caspl instruction

	caspl	w0, w1, w0, w1, [x0]
	caspl	w30, wzr, w30, wzr, [sp, 0]
	caspl	x0, x1, x0, x1, [x0]
	caspl	x30, xzr, x30, xzr, [sp, 0]

positive: cbnz instruction

	cbnz	w0, -1048576
	cbnz	wzr, +1048572
	cbnz	x0, -1048576
	cbnz	xzr, +1048572

positive: cbz instruction

positive: ccmn instruction

	ccmn	w0, 0, 0, eq
	ccmn	wzr, 31, 15, nv
	ccmn	x0, 0, 0, eq
	ccmn	xzr, 31, 15, nv
	ccmn	w0, w0, 0, eq
	ccmn	wzr, wzr, 15, nv
	ccmn	x0, x0, 0, eq
	ccmn	xzr, xzr, 15, nv

positive: ccmp instruction

	ccmp	w0, 0, 0, eq
	ccmp	wzr, 31, 15, nv
	ccmp	x0, 0, 0, eq
	ccmp	xzr, 31, 15, nv
	ccmp	w0, w0, 0, eq
	ccmp	wzr, wzr, 15, nv
	ccmp	x0, x0, 0, eq
	ccmp	xzr, xzr, 15, nv

positive: cinc instruction

	cinc	w0, w0, eq
	cinc	wzr, w30, le
	cinc	x0, x0, eq
	cinc	xzr, x30, le

positive: cinv instruction

	cinv	w0, w0, eq
	cinv	wzr, w30, le
	cinv	x0, x0, eq
	cinv	xzr, x30, le

positive: clrex instruction

	clrex

positive: cls instruction

	cls	w0, w0
	cls	wzr, wzr
	cls	x0, x0
	cls	xzr, xzr
	cls	v0.8b, v0.8b
	cls	v31.8b, v31.8b
	cls	v0.16b, v0.16b
	cls	v31.16b, v31.16b
	cls	v0.4h, v0.4h
	cls	v31.4h, v31.4h
	cls	v0.8h, v0.8h
	cls	v31.8h, v31.8h
	cls	v0.2s, v0.2s
	cls	v31.2s, v31.2s
	cls	v0.4s, v0.4s
	cls	v31.4s, v31.4s

positive: clz instruction

	clz	w0, w0
	clz	wzr, wzr
	clz	x0, x0
	clz	xzr, xzr
	clz	v0.8b, v0.8b
	clz	v31.8b, v31.8b
	clz	v0.16b, v0.16b
	clz	v31.16b, v31.16b
	clz	v0.4h, v0.4h
	clz	v31.4h, v31.4h
	clz	v0.8h, v0.8h
	clz	v31.8h, v31.8h
	clz	v0.2s, v0.2s
	clz	v31.2s, v31.2s
	clz	v0.4s, v0.4s
	clz	v31.4s, v31.4s

positive: cmn instruction

	cmn	w0, 0
	cmn	wsp, 4095
	cmn	w0, 0, lsl 0
	cmn	wsp, 4095, lsl 0
	cmn	w0, 0, lsl 12
	cmn	wsp, 4095, lsl 12
	cmn	x0, 0
	cmn	sp, 4095
	cmn	x0, 0, lsl 0
	cmn	sp, 4095, lsl 0
	cmn	x0, 0, lsl 12
	cmn	sp, 4095, lsl 12
	cmn	w0, w0
	cmn	wzr, wzr
	cmn	w0, w0, lsl 0
	cmn	wzr, wzr, lsl 31
	cmn	w0, w0, lsr 0
	cmn	wzr, wzr, lsr 31
	cmn	w0, w0, asr 0
	cmn	wzr, wzr, asr 31
	cmn	x0, x0
	cmn	xzr, xzr
	cmn	x0, x0, lsl 0
	cmn	xzr, xzr, lsl 63
	cmn	x0, x0, lsr 0
	cmn	xzr, xzr, lsr 63
	cmn	x0, x0, asr 0
	cmn	xzr, xzr, asr 63

positive: cmp instruction

	cmp	w0, w0
	cmp	wsp, wzr
	cmp	w0, w0, lsl 0
	cmp	wsp, wzr, lsl 3
	cmp	w0, w0, uxtb 0
	cmp	wsp, wzr, uxtb 3
	cmp	w0, w0, uxth 0
	cmp	wsp, wzr, uxth 3
	cmp	w0, w0, uxtw 0
	cmp	wsp, wzr, uxtw 3
	cmp	w0, w0, uxtx 0
	cmp	wsp, wzr, uxtx 3
	cmp	w0, w0, sxtb 0
	cmp	wsp, wzr, sxtb 3
	cmp	w0, w0, sxth 0
	cmp	wsp, wzr, sxth 3
	cmp	w0, w0, sxtw 0
	cmp	wsp, wzr, sxtw 3
	cmp	w0, w0, sxtx 0
	cmp	wsp, wzr, sxtx 3
	cmp	x0, x0
	cmp	sp, xzr
	cmp	x0, x0, lsl 0
	cmp	sp, xzr, lsl 3
	cmp	x0, x0, uxtb 0
	cmp	sp, xzr, uxtb 3
	cmp	x0, x0, uxth 0
	cmp	sp, xzr, uxth 3
	cmp	x0, x0, uxtw 0
	cmp	sp, xzr, uxtw 3
	cmp	x0, x0, uxtx 0
	cmp	sp, xzr, uxtx 3
	cmp	x0, x0, sxtb 0
	cmp	sp, xzr, sxtb 3
	cmp	x0, x0, sxth 0
	cmp	sp, xzr, sxth 3
	cmp	x0, x0, sxtw 0
	cmp	sp, xzr, sxtw 3
	cmp	x0, x0, sxtx 0
	cmp	sp, xzr, sxtx 3
	cmp	w0, 0
	cmp	wsp, 4095
	cmp	w0, 0, lsl 0
	cmp	wsp, 4095, lsl 0
	cmp	w0, 0, lsl 12
	cmp	wsp, 4095, lsl 12
	cmp	x0, 0
	cmp	sp, 4095
	cmp	x0, 0, lsl 0
	cmp	sp, 4095, lsl 0
	cmp	x0, 0, lsl 12
	cmp	sp, 4095, lsl 12
	cmp	w0, w0
	cmp	wzr, wzr
	cmp	w0, w0, lsl 0
	cmp	wzr, wzr, lsl 31
	cmp	w0, w0, lsr 0
	cmp	wzr, wzr, lsr 31
	cmp	w0, w0, asr 0
	cmp	wzr, wzr, asr 31
	cmp	x0, x0
	cmp	xzr, xzr
	cmp	x0, x0, lsl 0
	cmp	xzr, xzr, lsl 63
	cmp	x0, x0, lsr 0
	cmp	xzr, xzr, lsr 63
	cmp	x0, x0, asr 0
	cmp	xzr, xzr, asr 63

positive: cneg instruction

	cneg	w0, w0, eq
	cneg	wzr, wzr, le
	cneg	x0, x0, eq
	cneg	xzr, xzr, le

positive: crc32b instruction

	crc32b	w0, w0, w0
	crc32b	wzr, wzr, wzr

positive: crc32h instruction

	crc32h	w0, w0, w0
	crc32h	wzr, wzr, wzr

positive: crc32w instruction

	crc32w	w0, w0, w0
	crc32w	wzr, wzr, wzr

positive: crc32x instruction

	crc32x	w0, w0, x0
	crc32x	wzr, wzr, xzr

positive: crc32cb instruction

	crc32cb	w0, w0, w0
	crc32cb	wzr, wzr, wzr

positive: crc32ch instruction

	crc32ch	w0, w0, w0
	crc32ch	wzr, wzr, wzr

positive: crc32cw instruction

	crc32cw	w0, w0, w0
	crc32cw	wzr, wzr, wzr

positive: crc32cx instruction

	crc32cx	w0, w0, x0
	crc32cx	wzr, wzr, xzr

positive: csel instruction

	csel	w0, w0, w0, eq
	csel	wzr, wzr, wzr, nv
	csel	x0, x0, x0, eq
	csel	xzr, xzr, xzr, nv

positive: cset instruction

	cset	w0, eq
	cset	wzr, le
	cset	x0, eq
	cset	xzr, le

positive: csetm instruction

	csetm	w0, eq
	csetm	wzr, le
	csetm	x0, eq
	csetm	xzr, le

positive: csinc instruction

	csinc	w0, w0, w0, eq
	csinc	wzr, wzr, wzr, nv
	csinc	x0, x0, x0, eq
	csinc	xzr, xzr, xzr, nv

positive: csinv instruction

	csinv	w0, w0, w0, eq
	csinv	wzr, wzr, wzr, nv
	csinv	x0, x0, x0, eq
	csinv	xzr, xzr, xzr, nv

positive: csneg instruction

	csneg	w0, w0, w0, eq
	csneg	wzr, wzr, wzr, nv
	csneg	x0, x0, x0, eq
	csneg	xzr, xzr, xzr, nv

positive: dc instruction

	dc	ivac, x0
	dc	isw, xzr
	dc	csw, x0
	dc	cisw, x0
	dc	zva, x0
	dc	cvac, x0
	dc	cvau, x0
	dc	civac, x0
	dc	cvap, x0

positive: dcps1 instruction

	dcps1
	dcps1	0
	dcps1	65535

positive: dcps2 instruction

	dcps2
	dcps2	0
	dcps2	65535

positive: dcps3 instruction

	dcps3
	dcps3	0
	dcps3	65535

positive: dmb instruction

	dmb	0
	dmb	15
	dmb	sy
	dmb	st
	dmb	ld
	dmb	ish
	dmb	ishst
	dmb	nsh
	dmb	nshst
	dmb	nshld
	dmb	osh
	dmb	oshst
	dmb	oshld

positive: drps instruction

	drps

positive: dsb instruction

	dsb	0
	dsb	15
	dsb	sy
	dsb	st
	dsb	ld
	dsb	ish
	dsb	ishst
	dsb	nsh
	dsb	nshst
	dsb	nshld
	dsb	osh
	dsb	oshst
	dsb	oshld

positive: eon instruction

	eon	w0, w0, w0
	eon	wzr, wzr, wzr
	eon	w0, w0, w0, lsl 0
	eon	wzr, wzr, wzr, lsl 31
	eon	w0, w0, w0, lsr 0
	eon	wzr, wzr, wzr, lsr 31
	eon	w0, w0, w0, asr 0
	eon	wzr, wzr, wzr, asr 31
	eon	w0, w0, w0, ror 0
	eon	wzr, wzr, wzr, ror 31
	eon	x0, x0, x0
	eon	xzr, xzr, xzr
	eon	x0, x0, x0, lsl 0
	eon	xzr, xzr, xzr, lsl 63
	eon	x0, x0, x0, lsr 0
	eon	xzr, xzr, xzr, lsr 63
	eon	x0, x0, x0, asr 0
	eon	xzr, xzr, xzr, asr 63
	eon	x0, x0, x0, ror 0
	eon	xzr, xzr, xzr, ror 63

positive: eor instruction

	eor	w0, w0, 0x1
	eor	wsp, wzr, 0x7fffffff
	eor	x0, x0, 0x1
	eor	sp, xzr, 0x7fffffffffffffff
	eor	w0, w0, w0
	eor	wzr, wzr, wzr
	eor	w0, w0, w0, lsl 0
	eor	wzr, wzr, wzr, lsl 31
	eor	w0, w0, w0, lsr 0
	eor	wzr, wzr, wzr, lsr 31
	eor	w0, w0, w0, asr 0
	eor	wzr, wzr, wzr, asr 31
	eor	w0, w0, w0, ror 0
	eor	wzr, wzr, wzr, ror 31
	eor	x0, x0, x0
	eor	xzr, xzr, xzr
	eor	x0, x0, x0, lsl 0
	eor	xzr, xzr, xzr, lsl 63
	eor	x0, x0, x0, lsr 0
	eor	xzr, xzr, xzr, lsr 63
	eor	x0, x0, x0, asr 0
	eor	xzr, xzr, xzr, asr 63
	eor	x0, x0, x0, ror 0
	eor	xzr, xzr, xzr, ror 63
	eor	v0.8b, v0.8b, v0.8b
	eor	v31.8b, v31.8b, v31.8b
	eor	v0.16b, v0.16b, v0.16b
	eor	v31.16b, v31.16b, v31.16b

positive: eret instruction

	eret

positive: eretaa instruction

	eretaa

positive: eretab instruction

	eretab

positive: esb instruction

	esb

positive: extr instruction

	extr	w0, w0, w0, 0
	extr	wzr, wzr, wzr, 31
	extr	x0, x0, x0, 0
	extr	xzr, xzr, xzr, 63

positive: hint instruction

	hint	6
	hint	15
	hint	18
	hint	127

positive: hlt instruction

	hlt	0
	hlt	65535

positive: hvc instruction

	hvc	0
	hvc	65535

positive: ic instruction

	ic	ialluis
	ic	iallu
	ic	ivau
	ic	ialluis, x0
	ic	iallu, xzr
	ic	ivau, x0

positive: isb instruction

	isb
	isb	0
	isb	15
	isb	sy

positive: ldaddab instruction

	ldaddab	w0, w0, [x0]
	ldaddab	wzr, wzr, [sp]

positive: ldaddalb instruction

	ldaddalb	w0, w0, [x0]
	ldaddalb	wzr, wzr, [sp]

positive: ldaddb instruction

	ldaddb	w0, w0, [x0]
	ldaddb	wzr, wzr, [sp]

positive: ldaddlb instruction

	ldaddlb	w0, w0, [x0]
	ldaddlb	wzr, wzr, [sp]

positive: ldaddah instruction

	ldaddah	w0, w0, [x0]
	ldaddah	wzr, wzr, [sp]

positive: ldaddalh instruction

	ldaddalh	w0, w0, [x0]
	ldaddalh	wzr, wzr, [sp]

positive: ldaddh instruction

	ldaddh	w0, w0, [x0]
	ldaddh	wzr, wzr, [sp]

positive: ldaddlh instruction

	ldaddlh	w0, w0, [x0]
	ldaddlh	wzr, wzr, [sp]

positive: ldadda instruction

	ldadda	w0, w0, [x0]
	ldadda	wzr, wzr, [sp]
	ldadda	x0, x0, [x0]
	ldadda	xzr, xzr, [sp]

positive: ldaddal instruction

	ldaddal	w0, w0, [x0]
	ldaddal	wzr, wzr, [sp]
	ldaddal	x0, x0, [x0]
	ldaddal	xzr, xzr, [sp]

positive: ldadd instruction

	ldadd	w0, w0, [x0]
	ldadd	wzr, wzr, [sp]
	ldadd	x0, x0, [x0]
	ldadd	xzr, xzr, [sp]

positive: ldaddl instruction

	ldaddl	w0, w0, [x0]
	ldaddl	wzr, wzr, [sp]
	ldaddl	x0, x0, [x0]
	ldaddl	xzr, xzr, [sp]

positive: ldapr instruction

	ldapr	w0, [x0]
	ldapr	wzr, [sp, 0]
	ldapr	x0, [x0]
	ldapr	xzr, [sp, 0]

positive: ldaprb instruction

	ldaprb	w0, [x0]
	ldaprb	wzr, [sp, 0]

positive: ldaprh instruction

	ldaprh	w0, [x0]
	ldaprh	wzr, [sp, 0]

positive: ldar instruction

	ldar	w0, [x0]
	ldar	wzr, [sp, 0]
	ldar	x0, [x0]
	ldar	xzr, [sp, 0]

positive: ldarb instruction

	ldarb	w0, [x0]
	ldarb	wzr, [sp, 0]

positive: ldarh instruction

	ldarh	w0, [x0]
	ldarh	wzr, [sp, 0]

positive: ldaxp instruction

	ldaxp	w0, w0, [x0]
	ldaxp	wzr, wzr, [sp, 0]
	ldaxp	x0, x0, [x0]
	ldaxp	xzr, xzr, [sp, 0]

positive: ldaxr instruction

	ldaxr	w0, [x0]
	ldaxr	wzr, [sp, 0]
	ldaxr	x0, [x0]
	ldaxr	xzr, [sp, 0]

positive: ldaxrb instruction

	ldaxrb	w0, [x0]
	ldaxrb	wzr, [sp, 0]

positive: ldaxrh instruction

	ldaxrh	w0, [x0]
	ldaxrh	wzr, [sp, 0]

positive: ldclrab instruction

	ldclrab	w0, w0, [x0]
	ldclrab	wzr, wzr, [sp]

positive: ldclralb instruction

	ldclralb	w0, w0, [x0]
	ldclralb	wzr, wzr, [sp]

positive: ldclrb instruction

	ldclrb	w0, w0, [x0]
	ldclrb	wzr, wzr, [sp]

positive: ldclrlb instruction

	ldclrlb	w0, w0, [x0]
	ldclrlb	wzr, wzr, [sp]

positive: ldclrah instruction

	ldclrah	w0, w0, [x0]
	ldclrah	wzr, wzr, [sp]

positive: ldclralh instruction

	ldclralh	w0, w0, [x0]
	ldclralh	wzr, wzr, [sp]

positive: ldclrh instruction

	ldclrh	w0, w0, [x0]
	ldclrh	wzr, wzr, [sp]

positive: ldclrlh instruction

	ldclrlh	w0, w0, [x0]
	ldclrlh	wzr, wzr, [sp]

positive: ldclra instruction

	ldclra	w0, w0, [x0]
	ldclra	wzr, wzr, [sp]
	ldclra	x0, x0, [x0]
	ldclra	xzr, xzr, [sp]

positive: ldclral instruction

	ldclral	w0, w0, [x0]
	ldclral	wzr, wzr, [sp]
	ldclral	x0, x0, [x0]
	ldclral	xzr, xzr, [sp]

positive: ldclr instruction

	ldclr	w0, w0, [x0]
	ldclr	wzr, wzr, [sp]
	ldclr	x0, x0, [x0]
	ldclr	xzr, xzr, [sp]

positive: ldclrl instruction

	ldclrl	w0, w0, [x0]
	ldclrl	wzr, wzr, [sp]
	ldclrl	x0, x0, [x0]
	ldclrl	xzr, xzr, [sp]

positive: ldeorab instruction

	ldeorab	w0, w0, [x0]
	ldeorab	wzr, wzr, [sp]

positive: ldeoralb instruction

	ldeoralb	w0, w0, [x0]
	ldeoralb	wzr, wzr, [sp]

positive: ldeorb instruction

	ldeorb	w0, w0, [x0]
	ldeorb	wzr, wzr, [sp]

positive: ldeorlb instruction

	ldeorlb	w0, w0, [x0]
	ldeorlb	wzr, wzr, [sp]

positive: ldeorah instruction

	ldeorah	w0, w0, [x0]
	ldeorah	wzr, wzr, [sp]

positive: ldeoralh instruction

	ldeoralh	w0, w0, [x0]
	ldeoralh	wzr, wzr, [sp]

positive: ldeorh instruction

	ldeorh	w0, w0, [x0]
	ldeorh	wzr, wzr, [sp]

positive: ldeorlh instruction

	ldeorlh	w0, w0, [x0]
	ldeorlh	wzr, wzr, [sp]

positive: ldeora instruction

	ldeora	w0, w0, [x0]
	ldeora	wzr, wzr, [sp]
	ldeora	x0, x0, [x0]
	ldeora	xzr, xzr, [sp]

positive: ldeoral instruction

	ldeoral	w0, w0, [x0]
	ldeoral	wzr, wzr, [sp]
	ldeoral	x0, x0, [x0]
	ldeoral	xzr, xzr, [sp]

positive: ldeor instruction

	ldeor	w0, w0, [x0]
	ldeor	wzr, wzr, [sp]
	ldeor	x0, x0, [x0]
	ldeor	xzr, xzr, [sp]

positive: ldeorl instruction

	ldeorl	w0, w0, [x0]
	ldeorl	wzr, wzr, [sp]
	ldeorl	x0, x0, [x0]
	ldeorl	xzr, xzr, [sp]

positive: ldlar instruction

	ldlar	w0, [x0]
	ldlar	wzr, [sp, 0]
	ldlar	x0, [x0]
	ldlar	xzr, [sp, 0]

positive: ldlarb instruction

	ldlarb	w0, [x0]
	ldlarb	wzr, [sp, 0]

positive: ldlarh instruction

	ldlarh	w0, [x0]
	ldlarh	wzr, [sp, 0]

positive: ldnp instruction

	ldnp	w0, w0, [x0]
	ldnp	wzr, wzr, [x0]
	ldnp	w0, w0, [x0, -256]
	ldnp	wzr, wzr, [sp, -252]
	ldnp	x0, x0, [x0]
	ldnp	xzr, xzr, [x0]
	ldnp	x0, x0, [x0, -512]
	ldnp	xzr, xzr, [sp, -504]
	ldnp	s0, s0, [x0]
	ldnp	s31, s31, [sp]
	ldnp	s0, s0, [x0, -256]
	ldnp	s31, s31, [sp, +252]
	ldnp	d0, d0, [x0]
	ldnp	d31, d31, [sp]
	ldnp	d0, d0, [x0, -512]
	ldnp	d31, d31, [sp, +504]
	ldnp	q0, q0, [x0]
	ldnp	q31, q31, [sp]
	ldnp	q0, q0, [x0, -1024]
	ldnp	q31, q31, [sp, +1008]

positive: ldp instruction

	ldp	w0, w0, [x0], -256
	ldp	wzr, wzr, [sp], +252
	ldp	x0, x0, [x0], -512
	ldp	xzr, xzr, [sp], +504
	ldp	w0, w0, [x0, -256]!
	ldp	wzr, wzr, [sp, +252]!
	ldp	x0, x0, [x0, -512]!
	ldp	xzr, xzr, [sp, +504]!
	ldp	w0, w0, [x0]
	ldp	wzr, wzr, [sp]
	ldp	w0, w0, [x0, -256]
	ldp	wzr, wzr, [sp, +252]
	ldp	x0, x0, [x0]
	ldp	xzr, xzr, [sp]
	ldp	x0, x0, [x0, -512]
	ldp	xzr, xzr, [sp, +504]
	ldp	s0, s0, [x0], -256
	ldp	s31, s31, [sp], +252
	ldp	d0, d0, [x0], -512
	ldp	d31, d31, [sp], +504
	ldp	q0, q0, [x0], -1024
	ldp	q31, q31, [sp], +1008
	ldp	s0, s0, [x0, -256]!
	ldp	s31, s31, [sp, +252]!
	ldp	d0, d0, [x0, -512]!
	ldp	d31, d31, [sp, +504]!
	ldp	q0, q0, [x0, -1024]!
	ldp	q31, q31, [sp, +1008]!
	ldp	s0, s0, [x0]
	ldp	s31, s31, [sp]
	ldp	s0, s0, [x0, -256]
	ldp	s31, s31, [sp, +252]
	ldp	d0, d0, [x0]
	ldp	d31, d31, [sp]
	ldp	d0, d0, [x0, -512]
	ldp	d31, d31, [sp, +504]
	ldp	q0, q0, [x0]
	ldp	q31, q31, [sp]
	ldp	q0, q0, [x0, -1024]
	ldp	q31, q31, [sp, +1008]

positive: ldpsw instruction

	ldpsw	x0, x0, [x0], -256
	ldpsw	xzr, xzr, [sp], +252
	ldpsw	x0, x0, [x0, -256]!
	ldpsw	xzr, xzr, [sp, +252]!
	ldpsw	x0, x0, [x0]
	ldpsw	xzr, xzr, [sp]
	ldpsw	x0, x0, [x0, -256]
	ldpsw	xzr, xzr, [sp, +252]

positive: ldr instruction

	ldr	w0, [x0], -256
	ldr	wzr, [sp], +255
	ldr	x0, [x0], -256
	ldr	xzr, [sp], +255
	ldr	w0, [x0, -256]!
	ldr	wzr, [sp, +255]!
	ldr	x0, [x0, -256]!
	ldr	xzr, [sp, +255]!
	ldr	w0, [x0]
	ldr	wzr, [sp]
	ldr	w0, [x0, 0]
	ldr	wzr, [sp, 16380]
	ldr	x0, [x0]
	ldr	xzr, [sp]
	ldr	x0, [x0, 0]
	ldr	xzr, [sp, 32760]
	ldr	w0, -1048576
	ldr	wzr, +1048572
	ldr	x0, -1048576
	ldr	xzr, +1048572
	ldr	w0, [x0, w0, uxtw]
	ldr	wzr, [sp, wzr, uxtw 2]
	ldr	w0, [x0, x0]
	ldr	wzr, [sp, xzr]
	ldr	w0, [x0, x0, lsl 0]
	ldr	wzr, [sp, xzr, lsl 2]
	ldr	w0, [x0, w0, sxtw]
	ldr	wzr, [sp, wzr, sxtw 2]
	ldr	w0, [x0, x0, sxtx]
	ldr	wzr, [sp, xzr, sxtx 2]
	ldr	x0, [x0, w0, uxtw]
	ldr	xzr, [sp, wzr, uxtw 3]
	ldr	x0, [x0, x0]
	ldr	xzr, [sp, xzr]
	ldr	x0, [x0, x0, lsl 0]
	ldr	xzr, [sp, xzr, lsl 3]
	ldr	x0, [x0, w0, sxtw]
	ldr	xzr, [sp, wzr, sxtw 3]
	ldr	x0, [x0, x0, sxtx]
	ldr	xzr, [sp, xzr, sxtx 3]
	ldr	b0, [x0], -256
	ldr	b31, [sp], +255
	ldr	h0, [x0], -256
	ldr	h31, [sp], +255
	ldr	s0, [x0], -256
	ldr	s31, [sp], +255
	ldr	d0, [x0], -256
	ldr	d31, [sp], +255
	ldr	q0, [x0], -256
	ldr	q31, [sp], +255
	ldr	b0, [x0, -256]!
	ldr	b31, [sp, +255]!
	ldr	h0, [x0, -256]!
	ldr	h31, [sp, +255]!
	ldr	s0, [x0, -256]!
	ldr	s31, [sp, +255]!
	ldr	d0, [x0, -256]!
	ldr	d31, [sp, +255]!
	ldr	q0, [x0, -256]!
	ldr	q31, [sp, +255]!
	ldr	b0, [x0]
	ldr	b31, [sp]
	ldr	b0, [x0, 0]
	ldr	b31, [sp, 4095]
	ldr	h0, [x0]
	ldr	h31, [sp]
	ldr	h0, [x0, 0]
	ldr	h31, [sp, 8190]
	ldr	s0, [x0]
	ldr	s31, [sp]
	ldr	s0, [x0, 0]
	ldr	s31, [sp, 16380]
	ldr	d0, [x0]
	ldr	d31, [sp]
	ldr	d0, [x0, 0]
	ldr	d31, [sp, 32760]
	ldr	q0, [x0]
	ldr	q31, [sp]
	ldr	q0, [x0, 0]
	ldr	q31, [sp, 65520]
	ldr	s0, -1048576
	ldr	s31, +1048572
	ldr	d0, -1048576
	ldr	d31, +1048572
	ldr	q0, -1048576
	ldr	q31, +1048572
	ldr	b0, [x0, w0, uxtw]
	ldr	b31, [sp, wzr, uxtw 0]
	ldr	b0, [x0, x0]
	ldr	b31, [sp, xzr]
	ldr	b0, [x0, x0, lsl 0]
	ldr	b31, [sp, xzr, lsl 0]
	ldr	b0, [x0, w0, sxtw]
	ldr	b31, [sp, wzr, sxtw 0]
	ldr	b0, [x0, x0, sxtx]
	ldr	b31, [sp, xzr, sxtx 0]
	ldr	h0, [x0, w0, uxtw]
	ldr	h31, [sp, wzr, uxtw 1]
	ldr	h0, [x0, x0]
	ldr	h31, [sp, xzr]
	ldr	h0, [x0, x0, lsl 0]
	ldr	h31, [sp, xzr, lsl 1]
	ldr	h0, [x0, w0, sxtw]
	ldr	h31, [sp, wzr, sxtw 1]
	ldr	h0, [x0, x0, sxtx]
	ldr	h31, [sp, xzr, sxtx 1]
	ldr	s0, [x0, w0, uxtw]
	ldr	s31, [sp, wzr, uxtw 2]
	ldr	s0, [x0, x0]
	ldr	s31, [sp, xzr]
	ldr	s0, [x0, x0, lsl 0]
	ldr	s31, [sp, xzr, lsl 2]
	ldr	s0, [x0, w0, sxtw]
	ldr	s31, [sp, wzr, sxtw 2]
	ldr	s0, [x0, x0, sxtx]
	ldr	s31, [sp, xzr, sxtx 2]
	ldr	d0, [x0, w0, uxtw]
	ldr	d31, [sp, wzr, uxtw 3]
	ldr	d0, [x0, x0]
	ldr	d31, [sp, xzr]
	ldr	d0, [x0, x0, lsl 0]
	ldr	d31, [sp, xzr, lsl 3]
	ldr	d0, [x0, w0, sxtw]
	ldr	d31, [sp, wzr, sxtw 3]
	ldr	d0, [x0, x0, sxtx]
	ldr	d31, [sp, xzr, sxtx 3]

positive: ldraa instruction

	ldraa	x0, [x0]!
	ldraa	xzr, [sp]!
	ldraa	x0, [x0, -4096]!
	ldraa	xzr, [sp, +4088]!

positive: ldrab instruction

	ldrab	x0, [x0]!
	ldrab	xzr, [sp]!
	ldrab	x0, [x0, -4096]!
	ldrab	xzr, [sp, +4088]!

positive: ldrb instruction

	ldrb	w0, [x0], -256
	ldrb	wzr, [sp], +255
	ldrb	w0, [x0, -256]!
	ldrb	wzr, [sp, +255]!
	ldrb	w0, [x0]
	ldrb	wzr, [sp]
	ldrb	w0, [x0, 0]
	ldrb	wzr, [sp, 4095]
	ldrb	w0, [x0, w0, uxtw]
	ldrb	wzr, [sp, wzr, uxtw 0]
	ldrb	w0, [x0, x0]
	ldrb	wzr, [sp, xzr]
	ldrb	w0, [x0, x0, lsl 0]
	ldrb	wzr, [sp, xzr, lsl 0]
	ldrb	w0, [x0, w0, sxtw]
	ldrb	wzr, [sp, wzr, sxtw 0]
	ldrb	w0, [x0, x0, sxtx]
	ldrb	wzr, [sp, xzr, sxtx 0]

positive: ldrh instruction

	ldrh	w0, [x0], -256
	ldrh	wzr, [sp], +255
	ldrh	w0, [x0, -256]!
	ldrh	wzr, [sp, +255]!
	ldrh	w0, [x0]
	ldrh	wzr, [sp]
	ldrh	w0, [x0, 0]
	ldrh	wzr, [sp, 8190]
	ldrh	w0, [x0, w0, uxtw]
	ldrh	wzr, [sp, wzr, uxtw 1]
	ldrh	w0, [x0, x0]
	ldrh	wzr, [sp, xzr]
	ldrh	w0, [x0, x0, lsl 0]
	ldrh	wzr, [sp, xzr, lsl 1]
	ldrh	w0, [x0, w0, sxtw]
	ldrh	wzr, [sp, wzr, sxtw 1]
	ldrh	w0, [x0, x0, sxtx]
	ldrh	wzr, [sp, xzr, sxtx 1]

positive: ldrsb instruction

	ldrsb	w0, [x0], -256
	ldrsb	wzr, [sp], +255
	ldrsb	x0, [x0], -256
	ldrsb	xzr, [sp], +255
	ldrsb	w0, [x0, -256]!
	ldrsb	wzr, [sp, +255]!
	ldrsb	x0, [x0, -256]!
	ldrsb	xzr, [sp, +255]!
	ldrsb	w0, [x0]
	ldrsb	wzr, [sp]
	ldrsb	w0, [x0, 0]
	ldrsb	wzr, [sp, 4095]
	ldrsb	x0, [x0]
	ldrsb	xzr, [sp]
	ldrsb	x0, [x0, 0]
	ldrsb	xzr, [sp, 4095]
	ldrsb	w0, [x0, w0, uxtw]
	ldrsb	wzr, [sp, wzr, uxtw 0]
	ldrsb	w0, [x0, x0]
	ldrsb	wzr, [sp, xzr]
	ldrsb	w0, [x0, x0, lsl 0]
	ldrsb	wzr, [sp, xzr, lsl 0]
	ldrsb	w0, [x0, w0, sxtw]
	ldrsb	wzr, [sp, wzr, sxtw 0]
	ldrsb	w0, [x0, x0, sxtx]
	ldrsb	wzr, [sp, xzr, sxtx 0]
	ldrsb	x0, [x0, w0, uxtw]
	ldrsb	xzr, [sp, wzr, uxtw 0]
	ldrsb	x0, [x0, x0]
	ldrsb	xzr, [sp, xzr]
	ldrsb	x0, [x0, x0, lsl 0]
	ldrsb	xzr, [sp, xzr, lsl 0]
	ldrsb	x0, [x0, w0, sxtw]
	ldrsb	xzr, [sp, wzr, sxtw 0]
	ldrsb	x0, [x0, x0, sxtx]
	ldrsb	xzr, [sp, xzr, sxtx 0]

positive: ldrsh instruction

	ldrsh	w0, [x0], -256
	ldrsh	wzr, [sp], +255
	ldrsh	x0, [x0], -256
	ldrsh	xzr, [sp], +255
	ldrsh	w0, [x0, -256]!
	ldrsh	wzr, [sp, +255]!
	ldrsh	x0, [x0, -256]!
	ldrsh	xzr, [sp, +255]!
	ldrsh	w0, [x0]
	ldrsh	wzr, [sp]
	ldrsh	w0, [x0, 0]
	ldrsh	wzr, [sp, 8190]
	ldrsh	x0, [x0]
	ldrsh	xzr, [sp]
	ldrsh	x0, [x0, 0]
	ldrsh	xzr, [sp, 8190]
	ldrsh	w0, [x0, w0, uxtw]
	ldrsh	wzr, [sp, wzr, uxtw 1]
	ldrsh	w0, [x0, x0]
	ldrsh	wzr, [sp, xzr]
	ldrsh	w0, [x0, x0, lsl 0]
	ldrsh	wzr, [sp, xzr, lsl 1]
	ldrsh	w0, [x0, w0, sxtw]
	ldrsh	wzr, [sp, wzr, sxtw 1]
	ldrsh	w0, [x0, x0, sxtx]
	ldrsh	wzr, [sp, xzr, sxtx 1]
	ldrsh	x0, [x0, w0, uxtw]
	ldrsh	xzr, [sp, wzr, uxtw 1]
	ldrsh	x0, [x0, x0]
	ldrsh	xzr, [sp, xzr]
	ldrsh	x0, [x0, x0, lsl 0]
	ldrsh	xzr, [sp, xzr, lsl 1]
	ldrsh	x0, [x0, w0, sxtw]
	ldrsh	xzr, [sp, wzr, sxtw 1]
	ldrsh	x0, [x0, x0, sxtx]
	ldrsh	xzr, [sp, xzr, sxtx 1]

positive: ldrsw instruction

	ldrsw	x0, [x0], -256
	ldrsw	xzr, [sp], +255
	ldrsw	x0, [x0, -256]!
	ldrsw	xzr, [sp, +255]!
	ldrsw	x0, [x0]
	ldrsw	xzr, [sp]
	ldrsw	x0, [x0, 0]
	ldrsw	xzr, [sp, 16380]
	ldrsw	x0, -1048576
	ldrsw	xzr, +1048572
	ldrsw	x0, [x0, w0, uxtw]
	ldrsw	xzr, [sp, wzr, uxtw 2]
	ldrsw	x0, [x0, x0]
	ldrsw	xzr, [sp, xzr]
	ldrsw	x0, [x0, x0, lsl 0]
	ldrsw	xzr, [sp, xzr, lsl 2]
	ldrsw	x0, [x0, w0, sxtw]
	ldrsw	xzr, [sp, wzr, sxtw 2]
	ldrsw	x0, [x0, x0, sxtx]
	ldrsw	xzr, [sp, xzr, sxtx 2]

positive: ldsetab instruction

	ldsetab	w0, w0, [x0]
	ldsetab	wzr, wzr, [sp]

positive: ldsetalb instruction

	ldsetalb	w0, w0, [x0]
	ldsetalb	wzr, wzr, [sp]

positive: ldsetb instruction

	ldsetb	w0, w0, [x0]
	ldsetb	wzr, wzr, [sp]

positive: ldsetlb instruction

	ldsetlb	w0, w0, [x0]
	ldsetlb	wzr, wzr, [sp]

positive: ldsetah instruction

	ldsetah	w0, w0, [x0]
	ldsetah	wzr, wzr, [sp]

positive: ldsetalh instruction

	ldsetalh	w0, w0, [x0]
	ldsetalh	wzr, wzr, [sp]

positive: ldseth instruction

	ldseth	w0, w0, [x0]
	ldseth	wzr, wzr, [sp]

positive: ldsetlh instruction

	ldsetlh	w0, w0, [x0]
	ldsetlh	wzr, wzr, [sp]

positive: ldseta instruction

	ldseta	w0, w0, [x0]
	ldseta	wzr, wzr, [sp]
	ldseta	x0, x0, [x0]
	ldseta	xzr, xzr, [sp]

positive: ldsetal instruction

	ldsetal	w0, w0, [x0]
	ldsetal	wzr, wzr, [sp]
	ldsetal	x0, x0, [x0]
	ldsetal	xzr, xzr, [sp]

positive: ldset instruction

	ldset	w0, w0, [x0]
	ldset	wzr, wzr, [sp]
	ldset	x0, x0, [x0]
	ldset	xzr, xzr, [sp]

positive: ldsetl instruction

	ldsetl	w0, w0, [x0]
	ldsetl	wzr, wzr, [sp]
	ldsetl	x0, x0, [x0]
	ldsetl	xzr, xzr, [sp]

positive: ldsmaxab instruction

	ldsmaxab	w0, w0, [x0]
	ldsmaxab	wzr, wzr, [sp]

positive: ldsmaxalb instruction

	ldsmaxalb	w0, w0, [x0]
	ldsmaxalb	wzr, wzr, [sp]

positive: ldsmaxb instruction

	ldsmaxb	w0, w0, [x0]
	ldsmaxb	wzr, wzr, [sp]

positive: ldsmaxlb instruction

	ldsmaxlb	w0, w0, [x0]
	ldsmaxlb	wzr, wzr, [sp]

positive: ldsmaxah instruction

	ldsmaxah	w0, w0, [x0]
	ldsmaxah	wzr, wzr, [sp]

positive: ldsmaxalh instruction

	ldsmaxalh	w0, w0, [x0]
	ldsmaxalh	wzr, wzr, [sp]

positive: ldsmaxh instruction

	ldsmaxh	w0, w0, [x0]
	ldsmaxh	wzr, wzr, [sp]

positive: ldsmaxlh instruction

	ldsmaxlh	w0, w0, [x0]
	ldsmaxlh	wzr, wzr, [sp]

positive: ldsmaxa instruction

	ldsmaxa	w0, w0, [x0]
	ldsmaxa	wzr, wzr, [sp]
	ldsmaxa	x0, x0, [x0]
	ldsmaxa	xzr, xzr, [sp]

positive: ldsmaxal instruction

	ldsmaxal	w0, w0, [x0]
	ldsmaxal	wzr, wzr, [sp]
	ldsmaxal	x0, x0, [x0]
	ldsmaxal	xzr, xzr, [sp]

positive: ldsmax instruction

	ldsmax	w0, w0, [x0]
	ldsmax	wzr, wzr, [sp]
	ldsmax	x0, x0, [x0]
	ldsmax	xzr, xzr, [sp]

positive: ldsmaxl instruction

	ldsmaxl	w0, w0, [x0]
	ldsmaxl	wzr, wzr, [sp]
	ldsmaxl	x0, x0, [x0]
	ldsmaxl	xzr, xzr, [sp]

positive: ldsminab instruction

	ldsminab	w0, w0, [x0]
	ldsminab	wzr, wzr, [sp]

positive: ldsminalb instruction

	ldsminalb	w0, w0, [x0]
	ldsminalb	wzr, wzr, [sp]

positive: ldsminb instruction

	ldsminb	w0, w0, [x0]
	ldsminb	wzr, wzr, [sp]

positive: ldsminlb instruction

	ldsminlb	w0, w0, [x0]
	ldsminlb	wzr, wzr, [sp]

positive: ldsminah instruction

	ldsminah	w0, w0, [x0]
	ldsminah	wzr, wzr, [sp]

positive: ldsminalh instruction

	ldsminalh	w0, w0, [x0]
	ldsminalh	wzr, wzr, [sp]

positive: ldsminh instruction

	ldsminh	w0, w0, [x0]
	ldsminh	wzr, wzr, [sp]

positive: ldsminlh instruction

	ldsminlh	w0, w0, [x0]
	ldsminlh	wzr, wzr, [sp]

positive: ldsmina instruction

	ldsmina	w0, w0, [x0]
	ldsmina	wzr, wzr, [sp]
	ldsmina	x0, x0, [x0]
	ldsmina	xzr, xzr, [sp]

positive: ldsminal instruction

	ldsminal	w0, w0, [x0]
	ldsminal	wzr, wzr, [sp]
	ldsminal	x0, x0, [x0]
	ldsminal	xzr, xzr, [sp]

positive: ldsmin instruction

	ldsmin	w0, w0, [x0]
	ldsmin	wzr, wzr, [sp]
	ldsmin	x0, x0, [x0]
	ldsmin	xzr, xzr, [sp]

positive: ldsminl instruction

	ldsminl	w0, w0, [x0]
	ldsminl	wzr, wzr, [sp]
	ldsminl	x0, x0, [x0]
	ldsminl	xzr, xzr, [sp]

positive: ldtr instruction

	ldtr	w0, [x0]
	ldtr	wzr, [sp]
	ldtr	w0, [x0, -256]
	ldtr	wzr, [sp, +255]
	ldtr	x0, [x0, -256]
	ldtr	xzr, [sp, +255]

positive: ldtrb instruction

	ldtrb	w0, [x0]
	ldtrb	wzr, [sp]
	ldtrb	w0, [x0, -256]
	ldtrb	wzr, [sp, +255]

positive: ldtrh instruction

	ldtrh	w0, [x0]
	ldtrh	wzr, [sp, +255]
	ldtrh	w0, [x0]
	ldtrh	wzr, [sp, +255]

positive: ldtrsb instruction

	ldtrsb	w0, [x0]
	ldtrsb	wzr, [sp]
	ldtrsb	w0, [x0, -256]
	ldtrsb	wzr, [sp, +255]
	ldtrsb	x0, [x0]
	ldtrsb	xzr, [sp]
	ldtrsb	x0, [x0, -256]
	ldtrsb	xzr, [sp, +255]

positive: ldtrsh instruction

	ldtrsh	w0, [x0]
	ldtrsh	wzr, [sp]
	ldtrsh	w0, [x0, -256]
	ldtrsh	wzr, [sp, +255]
	ldtrsh	x0, [x0]
	ldtrsh	xzr, [sp]
	ldtrsh	x0, [x0, -256]
	ldtrsh	xzr, [sp, +255]

positive: ldtrsw instruction

	ldtrsw	x0, [x0]
	ldtrsw	xzr, [sp]
	ldtrsw	x0, [x0, -256]
	ldtrsw	xzr, [sp, +255]

positive: ldumaxab instruction

	ldumaxab	w0, w0, [x0]
	ldumaxab	wzr, wzr, [sp]

positive: ldumaxalb instruction

	ldumaxalb	w0, w0, [x0]
	ldumaxalb	wzr, wzr, [sp]

positive: ldumaxb instruction

	ldumaxb	w0, w0, [x0]
	ldumaxb	wzr, wzr, [sp]

positive: ldumaxlb instruction

	ldumaxlb	w0, w0, [x0]
	ldumaxlb	wzr, wzr, [sp]

positive: ldumaxah instruction

	ldumaxah	w0, w0, [x0]
	ldumaxah	wzr, wzr, [sp]

positive: ldumaxalh instruction

	ldumaxalh	w0, w0, [x0]
	ldumaxalh	wzr, wzr, [sp]

positive: ldumaxh instruction

	ldumaxh	w0, w0, [x0]
	ldumaxh	wzr, wzr, [sp]

positive: ldumaxlh instruction

	ldumaxlh	w0, w0, [x0]
	ldumaxlh	wzr, wzr, [sp]

positive: ldumaxa instruction

	ldumaxa	w0, w0, [x0]
	ldumaxa	wzr, wzr, [sp]
	ldumaxa	x0, x0, [x0]
	ldumaxa	xzr, xzr, [sp]

positive: ldumaxal instruction

	ldumaxal	w0, w0, [x0]
	ldumaxal	wzr, wzr, [sp]
	ldumaxal	x0, x0, [x0]
	ldumaxal	xzr, xzr, [sp]

positive: ldumax instruction

	ldumax	w0, w0, [x0]
	ldumax	wzr, wzr, [sp]
	ldumax	x0, x0, [x0]
	ldumax	xzr, xzr, [sp]

positive: ldumaxl instruction

	ldumaxl	w0, w0, [x0]
	ldumaxl	wzr, wzr, [sp]
	ldumaxl	x0, x0, [x0]
	ldumaxl	xzr, xzr, [sp]

positive: lduminab instruction

	lduminab	w0, w0, [x0]
	lduminab	wzr, wzr, [sp]

positive: lduminalb instruction

	lduminalb	w0, w0, [x0]
	lduminalb	wzr, wzr, [sp]

positive: lduminb instruction

	lduminb	w0, w0, [x0]
	lduminb	wzr, wzr, [sp]

positive: lduminlb instruction

	lduminlb	w0, w0, [x0]
	lduminlb	wzr, wzr, [sp]

positive: lduminah instruction

	lduminah	w0, w0, [x0]
	lduminah	wzr, wzr, [sp]

positive: lduminalh instruction

	lduminalh	w0, w0, [x0]
	lduminalh	wzr, wzr, [sp]

positive: lduminh instruction

	lduminh	w0, w0, [x0]
	lduminh	wzr, wzr, [sp]

positive: lduminlh instruction

	lduminlh	w0, w0, [x0]
	lduminlh	wzr, wzr, [sp]

positive: ldumina instruction

	ldumina	w0, w0, [x0]
	ldumina	wzr, wzr, [sp]
	ldumina	x0, x0, [x0]
	ldumina	xzr, xzr, [sp]

positive: lduminal instruction

	lduminal	w0, w0, [x0]
	lduminal	wzr, wzr, [sp]
	lduminal	x0, x0, [x0]
	lduminal	xzr, xzr, [sp]

positive: ldumin instruction

	ldumin	w0, w0, [x0]
	ldumin	wzr, wzr, [sp]
	ldumin	x0, x0, [x0]
	ldumin	xzr, xzr, [sp]

positive: lduminl instruction

	lduminl	w0, w0, [x0]
	lduminl	wzr, wzr, [sp]
	lduminl	x0, x0, [x0]
	lduminl	xzr, xzr, [sp]

positive: ldur instruction

	ldur	w0, [x0]
	ldur	wzr, [sp]
	ldur	w0, [x0, -256]
	ldur	wzr, [sp, +255]
	ldur	x0, [x0]
	ldur	xzr, [sp]
	ldur	x0, [x0, -256]
	ldur	xzr, [sp, +255]
	ldur	b0, [x0]
	ldur	b31, [sp]
	ldur	b0, [x0, -256]
	ldur	b31, [sp, +255]
	ldur	h0, [x0]
	ldur	h31, [sp]
	ldur	h0, [x0, -256]
	ldur	h31, [sp, +255]
	ldur	s0, [x0]
	ldur	s31, [sp]
	ldur	s0, [x0, -256]
	ldur	s31, [sp, +255]
	ldur	d0, [x0]
	ldur	d31, [sp]
	ldur	d0, [x0, -256]
	ldur	d31, [sp, +255]
	ldur	q0, [x0]
	ldur	q31, [sp]
	ldur	q0, [x0, -256]
	ldur	q31, [sp, +255]

positive: ldurb instruction

	ldurb	w0, [x0]
	ldurb	wzr, [sp]
	ldurb	w0, [x0, -256]
	ldurb	wzr, [sp, +255]

positive: ldurh instruction

	ldurh	w0, [x0]
	ldurh	wzr, [sp, +255]
	ldurh	w0, [x0]
	ldurh	wzr, [sp, +255]

positive: ldursb instruction

	ldursb	w0, [x0]
	ldursb	wzr, [sp]
	ldursb	w0, [x0, -256]
	ldursb	wzr, [sp, +255]
	ldursb	x0, [x0]
	ldursb	xzr, [sp]
	ldursb	x0, [x0, -256]
	ldursb	xzr, [sp, +255]

positive: ldursh instruction

	ldursh	w0, [x0]
	ldursh	wzr, [sp]
	ldursh	w0, [x0, -256]
	ldursh	wzr, [sp, +255]
	ldursh	x0, [x0]
	ldursh	xzr, [sp]
	ldursh	x0, [x0, -256]
	ldursh	xzr, [sp, +255]

positive: ldursw instruction

	ldursw	x0, [x0]
	ldursw	xzr, [sp]
	ldursw	x0, [x0, -256]
	ldursw	xzr, [sp, +255]

positive: ldxp instruction

	ldxp	w0, w0, [x0]
	ldxp	wzr, wzr, [sp, 0]
	ldxp	x0, x0, [x0]
	ldxp	xzr, xzr, [sp, 0]

positive: ldxr instruction

	ldxr	w0, [x0]
	ldxr	wzr, [sp, 0]
	ldxr	x0, [x0]
	ldxr	xzr, [sp, 0]

positive: ldxrb instruction

	ldxrb	w0, [x0]
	ldxrb	wzr, [sp, 0]

positive: ldxrh instruction

	ldxrh	w0, [x0]
	ldxrh	wzr, [sp, 0]

positive: lsl instruction

	lsl	w0, w0, w0
	lsl	wzr, wzr, wzr
	lsl	x0, x0, x0
	lsl	xzr, xzr, xzr
	lsl	x0, x0, 0
	lsl	xzr, xzr, 63

positive: lslv instruction

	lslv	w0, w0, w0
	lslv	wzr, wzr, wzr
	lslv	x0, x0, x0
	lslv	xzr, xzr, xzr

positive: lsr instruction

	lsr	w0, w0, w0
	lsr	wzr, wzr, wzr
	lsr	x0, x0, x0
	lsr	xzr, xzr, xzr
	lsr	x0, x0, 0
	lsr	xzr, xzr, 63

positive: lsrv instruction

	lsrv	w0, w0, w0
	lsrv	wzr, wzr, wzr
	lsrv	x0, x0, x0
	lsrv	xzr, xzr, xzr

positive: madd instruction

	madd	w0, w0, w0, w0
	madd	wzr, wzr, wzr, wzr
	madd	x0, x0, x0, x0
	madd	xzr, xzr, xzr, xzr

positive: mneg instruction

	mneg	w0, w0, w0
	mneg	wzr, wzr, wzr
	mneg	x0, x0, x0
	mneg	xzr, xzr, xzr

positive: mov instruction

	mov	w0, w0
	mov	wsp, wsp
	mov	x0, x0
	mov	sp, sp
	mov	w0, 0
	mov	wzr, 65535
	mov	x0, 0
	mov	xzr, 65535
	mov	w0, ~0
	mov	wzr, ~65535
	mov	x0, ~0
	mov	xzr, ~65535
	mov	w0, 0x1
	mov	wsp, 0x7fffffff
	mov	x0, 0x1
	mov	sp, 0x7fffffffffffffff
	mov	w0, w0
	mov	wzr, wzr
	mov	x0, x0
	mov	xzr, xzr
	mov	b0, v0.b[0]
	mov	b31, v31.b[15]
	mov	h0, v0.h[0]
	mov	h31, v31.h[7]
	mov	s0, v0.s[0]
	mov	s31, v31.s[3]
	mov	d0, v0.d[0]
	mov	d31, v31.d[1]
	mov	v0.b[0], v0.b[0]
	mov	v31.b[15], v31.b[15]
	mov	v0.h[0], v0.h[0]
	mov	v31.h[7], v31.h[7]
	mov	v0.s[0], v0.s[0]
	mov	v31.s[3], v31.s[3]
	mov	v0.d[0], v0.d[0]
	mov	v31.d[1], v31.d[1]
	mov	v0.b[0], w0
	mov	v31.b[15], wzr
	mov	v0.h[0], w0
	mov	v31.h[7], wzr
	mov	v0.s[0], w0
	mov	v31.s[3], wzr
	mov	v0.d[0], x0
	mov	v31.d[1], xzr
	mov	v0.8b, v0.8b
	mov	v31.8b, v31.8b
	mov	v0.16b, v0.16b
	mov	v31.16b, v31.16b
	mov	w0, v0.s[0]
	mov	wzr, v31.s[3]
	mov	x0, v0.d[0]
	mov	xzr, v31.d[1]

positive: movk instruction

	movk	w0, 0
	movk	w0, 65535
	movk	w0, 0, lsl 0
	movk	w0, 65535, lsl 16
	movk	x0, 0
	movk	x0, 65535
	movk	x0, 0, lsl 0
	movk	x0, 65535, lsl 48

positive: movn instruction

	movn	w0, 0
	movn	w0, 65535
	movn	w0, 0, lsl 0
	movn	w0, 65535, lsl 16
	movn	x0, 0
	movn	x0, 65535
	movn	x0, 0, lsl 0
	movn	x0, 65535, lsl 48

positive: movz instruction

	movz	w0, 0
	movz	w0, 65535
	movz	w0, 0, lsl 0
	movz	w0, 65535, lsl 16
	movz	x0, 0
	movz	x0, 65535
	movz	x0, 0, lsl 0
	movz	x0, 65535, lsl 48

positive: mrs instruction

	mrs	x0, actlr_el1
	mrs	xzr, actlr_el2
	mrs	x0, actlr_el3
	mrs	x0, afsr0_el1
	mrs	x0, afsr0_el12
	mrs	x0, afsr0_el2
	mrs	x0, afsr0_el3
	mrs	x0, afsr1_el1
	mrs	x0, afsr1_el12
	mrs	x0, afsr1_el2
	mrs	x0, afsr1_el3
	mrs	x0, aidr_el1
	mrs	x0, amair_el1
	mrs	x0, amair_el12
	mrs	x0, amair_el2
	mrs	x0, amair_el3
	mrs	x0, ccsidr2_el1
	mrs	x0, ccsidr_el1
	mrs	x0, clidr_el1
	mrs	x0, cntfrq_el0
	mrs	x0, cnthctl_el2
	mrs	x0, cnthp_ctl_el2
	mrs	x0, cnthp_cval_el2
	mrs	x0, cnthp_tval_el2
	mrs	x0, cnthv_ctl_el2
	mrs	x0, cnthv_cval_el2
	mrs	x0, cnthv_tval_el2
	mrs	x0, cntkctl_el1
	mrs	x0, cntkctl_el12
	mrs	x0, cntpct_el0
	mrs	x0, cntp_ctl_el0
	mrs	x0, cntp_ctl_el02
	mrs	x0, cntp_cval_el0
	mrs	x0, cntp_cval_el02
	mrs	x0, cntps_ctl_el1
	mrs	x0, cntps_cval_el1
	mrs	x0, cntps_tval_el1
	mrs	x0, cntp_tval_el0
	mrs	x0, cntp_tval_el02
	mrs	x0, cntvct_el0
	mrs	x0, cntv_ctl_el0
	mrs	x0, cntv_ctl_el02
	mrs	x0, cntv_cval_el0
	mrs	x0, cntv_cval_el02
	mrs	x0, cntvoff_el2
	mrs	x0, cntv_tval_el0
	mrs	x0, cntv_tval_el02
	mrs	x0, contextidr_el1
	mrs	x0, contextidr_el12
	mrs	x0, contextidr_el2
	mrs	x0, cpacr_el1
	mrs	x0, cpacr_el12
	mrs	x0, cptr_el2
	mrs	x0, cptr_el3
	mrs	x0, csselr_el1
	mrs	x0, ctr_el0
	mrs	x0, dacr32_el2
	mrs	x0, daif
	mrs	x0, dbgauthstatus_el1
	mrs	x0, dbgclaimclr_el1
	mrs	x0, dbgclaimset_el1
	mrs	x0, dbgdtr_el0
	mrs	x0, dbgdtrrx_el0
	mrs	x0, dbgdtrtx_el0
	mrs	x0, dbgprcr_el1
	mrs	x0, dbgvcr32_el2
	mrs	x0, dczid_el0
	mrs	x0, dlr_el0
	mrs	x0, dspsr_el0
	mrs	x0, elr_el1
	mrs	x0, elr_el12
	mrs	x0, elr_el2
	mrs	x0, elr_el3
	mrs	x0, esr_el1
	mrs	x0, esr_el12
	mrs	x0, esr_el2
	mrs	x0, esr_el3
	mrs	x0, far_el1
	mrs	x0, far_el12
	mrs	x0, far_el2
	mrs	x0, far_el3
	mrs	x0, fpcr
	mrs	x0, fpexc32_el2
	mrs	x0, fpsr
	mrs	x0, hacr_el2
	mrs	x0, hcr_el2
	mrs	x0, hpfar_el2
	mrs	x0, hstr_el2
	mrs	x0, id_aa64afr0_el1
	mrs	x0, id_aa64afr1_el1
	mrs	x0, id_aa64dfr0_el1
	mrs	x0, id_aa64dfr1_el1
	mrs	x0, id_aa64isar0_el1
	mrs	x0, id_aa64isar1_el1
	mrs	x0, id_aa64mmfr0_el1
	mrs	x0, id_aa64mmfr1_el1
	mrs	x0, id_aa64mmfr2_el1
	mrs	x0, id_aa64pfr0_el1
	mrs	x0, id_aa64pfr1_el1
	mrs	x0, id_afr0_el1
	mrs	x0, id_dfr0_el1
	mrs	x0, id_isar0_el1
	mrs	x0, id_isar1_el1
	mrs	x0, id_isar2_el1
	mrs	x0, id_isar3_el1
	mrs	x0, id_isar4_el1
	mrs	x0, id_isar5_el1
	mrs	x0, id_isar6_el1
	mrs	x0, id_mmfr0_el1
	mrs	x0, id_mmfr1_el1
	mrs	x0, id_mmfr2_el1
	mrs	x0, id_mmfr3_el1
	mrs	x0, id_mmfr4_el1
	mrs	x0, id_pfr0_el1
	mrs	x0, id_pfr1_el1
	mrs	x0, ifsr32_el2
	mrs	x0, isr_el1
	mrs	x0, lorc_el1
	mrs	x0, lorea_el1
	mrs	x0, lorid_el1
	mrs	x0, lorn_el1
	mrs	x0, lorsa_el1
	mrs	x0, mair_el1
	mrs	x0, mair_el12
	mrs	x0, mair_el2
	mrs	x0, mair_el3
	mrs	x0, mdccint_el1
	mrs	x0, mdccsr_el0
	mrs	x0, mdcr_el2
	mrs	x0, mdcr_el3
	mrs	x0, mdrar_el1
	mrs	x0, mdscr_el1
	mrs	x0, midr_el1
	mrs	x0, mpidr_el1
	mrs	x0, mvfr0_el1
	mrs	x0, mvfr1_el1
	mrs	x0, mvfr2_el1
	mrs	x0, nzcv
	mrs	x0, osdlr_el1
	mrs	x0, osdtrrx_el1
	mrs	x0, osdtrtx_el1
	mrs	x0, oseccr_el1
	mrs	x0, oslar_el1
	mrs	x0, oslsr_el1
	mrs	x0, pan
	mrs	x0, par_el1
	mrs	x0, pmccfiltr_el0
	mrs	x0, pmccntr_el0
	mrs	x0, pmceid0_el0
	mrs	x0, pmceid1_el0
	mrs	x0, pmcntenclr_el0
	mrs	x0, pmcntenset_el0
	mrs	x0, pmcr_el0
	mrs	x0, pmintenclr_el1
	mrs	x0, pmintenset_el1
	mrs	x0, pmovsclr_el0
	mrs	x0, pmovsset_el0
	mrs	x0, pmselr_el0
	mrs	x0, pmswinc_el0
	mrs	x0, pmuserenr_el0
	mrs	x0, pmxevcntr_el0
	mrs	x0, pmxevtyper_el0
	mrs	x0, revidr_el1
	mrs	x0, rmr_el1
	mrs	x0, rmr_el2
	mrs	x0, rmr_el3
	mrs	x0, rvbar_el1
	mrs	x0, rvbar_el2
	mrs	x0, rvbar_el3
	mrs	x0, scr_el3
	mrs	x0, sctlr_el1
	mrs	x0, sctlr_el12
	mrs	x0, sctlr_el2
	mrs	x0, sctlr_el3
	mrs	x0, sder32_el3
	mrs	x0, sp_el0
	mrs	x0, sp_el1
	mrs	x0, sp_el2
	mrs	x0, spsr_el1
	mrs	x0, spsr_el12
	mrs	x0, spsr_el2
	mrs	x0, spsr_el3
	mrs	x0, tcr_el1
	mrs	x0, tcr_el12
	mrs	x0, tcr_el2
	mrs	x0, tcr_el3
	mrs	x0, tpidr_el0
	mrs	x0, tpidr_el1
	mrs	x0, tpidr_el2
	mrs	x0, tpidr_el3
	mrs	x0, tpidrro_el0
	mrs	x0, ttbr0_el1
	mrs	x0, ttbr0_el12
	mrs	x0, ttbr0_el2
	mrs	x0, ttbr0_el3
	mrs	x0, ttbr1_el1
	mrs	x0, ttbr1_el12
	mrs	x0, ttbr1_el2
	mrs	x0, uao
	mrs	x0, vbar_el1
	mrs	x0, vbar_el12
	mrs	x0, vbar_el2
	mrs	x0, vbar_el3
	mrs	x0, vmpidr_el2
	mrs	x0, vpidr_el2
	mrs	x0, vtcr_el2
	mrs	x0, vttbr_el2

positive: msr instruction

	msr	spsel, 0
	msr	daifset, 15
	msr	daifclr, 0
	msr	actlr_el1, x0
	msr	actlr_el2, x0
	msr	actlr_el3, x0
	msr	afsr0_el1, x0
	msr	afsr0_el12, x0
	msr	afsr0_el2, x0
	msr	afsr0_el3, x0
	msr	afsr1_el1, x0
	msr	afsr1_el12, x0
	msr	afsr1_el2, x0
	msr	afsr1_el3, x0
	msr	aidr_el1, x0
	msr	amair_el1, x0
	msr	amair_el12, x0
	msr	amair_el2, x0
	msr	amair_el3, x0
	msr	ccsidr2_el1, x0
	msr	ccsidr_el1, x0
	msr	clidr_el1, x0
	msr	cntfrq_el0, x0
	msr	cnthctl_el2, x0
	msr	cnthp_ctl_el2, x0
	msr	cnthp_cval_el2, x0
	msr	cnthp_tval_el2, x0
	msr	cnthv_ctl_el2, x0
	msr	cnthv_cval_el2, x0
	msr	cnthv_tval_el2, x0
	msr	cntkctl_el1, x0
	msr	cntkctl_el12, x0
	msr	cntpct_el0, x0
	msr	cntp_ctl_el0, x0
	msr	cntp_ctl_el02, x0
	msr	cntp_cval_el0, x0
	msr	cntp_cval_el02, x0
	msr	cntps_ctl_el1, x0
	msr	cntps_cval_el1, x0
	msr	cntps_tval_el1, x0
	msr	cntp_tval_el0, x0
	msr	cntp_tval_el02, x0
	msr	cntvct_el0, x0
	msr	cntv_ctl_el0, x0
	msr	cntv_ctl_el02, x0
	msr	cntv_cval_el0, x0
	msr	cntv_cval_el02, x0
	msr	cntvoff_el2, x0
	msr	cntv_tval_el0, x0
	msr	cntv_tval_el02, x0
	msr	contextidr_el1, x0
	msr	contextidr_el12, x0
	msr	contextidr_el2, x0
	msr	cpacr_el1, x0
	msr	cpacr_el12, x0
	msr	cptr_el2, x0
	msr	cptr_el3, x0
	msr	csselr_el1, x0
	msr	ctr_el0, x0
	msr	dacr32_el2, x0
	msr	daif, x0
	msr	dbgauthstatus_el1, x0
	msr	dbgclaimclr_el1, x0
	msr	dbgclaimset_el1, x0
	msr	dbgdtr_el0, x0
	msr	dbgdtrrx_el0, x0
	msr	dbgdtrtx_el0, x0
	msr	dbgprcr_el1, x0
	msr	dbgvcr32_el2, x0
	msr	dczid_el0, x0
	msr	dlr_el0, x0
	msr	dspsr_el0, x0
	msr	elr_el1, x0
	msr	elr_el12, x0
	msr	elr_el2, x0
	msr	elr_el3, x0
	msr	esr_el1, x0
	msr	esr_el12, x0
	msr	esr_el2, x0
	msr	esr_el3, x0
	msr	far_el1, x0
	msr	far_el12, x0
	msr	far_el2, x0
	msr	far_el3, x0
	msr	fpcr, x0
	msr	fpexc32_el2, x0
	msr	fpsr, x0
	msr	hacr_el2, x0
	msr	hcr_el2, x0
	msr	hpfar_el2, x0
	msr	hstr_el2, x0
	msr	id_aa64afr0_el1, x0
	msr	id_aa64afr1_el1, x0
	msr	id_aa64dfr0_el1, x0
	msr	id_aa64dfr1_el1, x0
	msr	id_aa64isar0_el1, x0
	msr	id_aa64isar1_el1, x0
	msr	id_aa64mmfr0_el1, x0
	msr	id_aa64mmfr1_el1, x0
	msr	id_aa64mmfr2_el1, x0
	msr	id_aa64pfr0_el1, x0
	msr	id_aa64pfr1_el1, x0
	msr	id_afr0_el1, x0
	msr	id_dfr0_el1, x0
	msr	id_isar0_el1, x0
	msr	id_isar1_el1, x0
	msr	id_isar2_el1, x0
	msr	id_isar3_el1, x0
	msr	id_isar4_el1, x0
	msr	id_isar5_el1, x0
	msr	id_isar6_el1, x0
	msr	id_mmfr0_el1, x0
	msr	id_mmfr1_el1, x0
	msr	id_mmfr2_el1, x0
	msr	id_mmfr3_el1, x0
	msr	id_mmfr4_el1, x0
	msr	id_pfr0_el1, x0
	msr	id_pfr1_el1, x0
	msr	ifsr32_el2, x0
	msr	isr_el1, x0
	msr	lorc_el1, x0
	msr	lorea_el1, x0
	msr	lorid_el1, x0
	msr	lorn_el1, x0
	msr	lorsa_el1, x0
	msr	mair_el1, x0
	msr	mair_el12, x0
	msr	mair_el2, x0
	msr	mair_el3, x0
	msr	mdccint_el1, x0
	msr	mdccsr_el0, x0
	msr	mdcr_el2, x0
	msr	mdcr_el3, x0
	msr	mdrar_el1, x0
	msr	mdscr_el1, x0
	msr	midr_el1, x0
	msr	mpidr_el1, x0
	msr	mvfr0_el1, x0
	msr	mvfr1_el1, x0
	msr	mvfr2_el1, x0
	msr	nzcv, x0
	msr	osdlr_el1, x0
	msr	osdtrrx_el1, x0
	msr	osdtrtx_el1, x0
	msr	oseccr_el1, x0
	msr	oslar_el1, x0
	msr	oslsr_el1, x0
	msr	pan, x0
	msr	par_el1, x0
	msr	pmccfiltr_el0, x0
	msr	pmccntr_el0, x0
	msr	pmceid0_el0, x0
	msr	pmceid1_el0, x0
	msr	pmcntenclr_el0, x0
	msr	pmcntenset_el0, x0
	msr	pmcr_el0, x0
	msr	pmintenclr_el1, x0
	msr	pmintenset_el1, x0
	msr	pmovsclr_el0, x0
	msr	pmovsset_el0, x0
	msr	pmselr_el0, x0
	msr	pmswinc_el0, x0
	msr	pmuserenr_el0, x0
	msr	pmxevcntr_el0, x0
	msr	pmxevtyper_el0, x0
	msr	revidr_el1, x0
	msr	rmr_el1, x0
	msr	rmr_el2, x0
	msr	rmr_el3, x0
	msr	rvbar_el1, x0
	msr	rvbar_el2, x0
	msr	rvbar_el3, x0
	msr	scr_el3, x0
	msr	sctlr_el1, x0
	msr	sctlr_el12, x0
	msr	sctlr_el2, x0
	msr	sctlr_el3, x0
	msr	sder32_el3, x0
	msr	sp_el0, x0
	msr	sp_el1, x0
	msr	sp_el2, x0
	msr	spsr_el1, x0
	msr	spsr_el12, x0
	msr	spsr_el2, x0
	msr	spsr_el3, x0
	msr	tcr_el1, x0
	msr	tcr_el12, x0
	msr	tcr_el2, x0
	msr	tcr_el3, x0
	msr	tpidr_el0, x0
	msr	tpidr_el1, x0
	msr	tpidr_el2, x0
	msr	tpidr_el3, x0
	msr	tpidrro_el0, x0
	msr	ttbr0_el1, x0
	msr	ttbr0_el12, x0
	msr	ttbr0_el2, x0
	msr	ttbr0_el3, x0
	msr	ttbr1_el1, x0
	msr	ttbr1_el12, x0
	msr	ttbr1_el2, x0
	msr	uao, x0
	msr	vbar_el1, x0
	msr	vbar_el12, x0
	msr	vbar_el2, x0
	msr	vbar_el3, x0
	msr	vmpidr_el2, x0
	msr	vpidr_el2, x0
	msr	vtcr_el2, x0
	msr	vttbr_el2, x0

positive: msub instruction

	msub	w0, w0, w0, w0
	msub	wzr, wzr, wzr, wzr
	msub	x0, x0, x0, x0
	msub	xzr, xzr, xzr, xzr

positive: mul instruction

	mul	w0, w0, w0
	mul	wzr, wzr, wzr
	mul	x0, x0, x0
	mul	xzr, xzr, xzr
	mul	v0.4h, v0.4h, v0.h[0]
	mul	v31.4h, v31.4h, v15.h[7]
	mul	v0.8h, v0.8h, v0.h[0]
	mul	v31.8h, v31.8h, v15.h[7]
	mul	v0.2s, v0.2s, v0.s[0]
	mul	v31.2s, v31.2s, v31.s[3]
	mul	v0.4s, v0.4s, v0.s[0]
	mul	v31.4s, v31.4s, v31.s[3]
	mul	v0.8b, v0.8b, v0.8b
	mul	v31.8b, v31.8b, v31.8b
	mul	v0.16b, v0.16b, v0.16b
	mul	v31.16b, v31.16b, v31.16b
	mul	v0.4h, v0.4h, v0.4h
	mul	v31.4h, v31.4h, v31.4h
	mul	v0.8h, v0.8h, v0.8h
	mul	v31.8h, v31.8h, v31.8h
	mul	v0.2s, v0.2s, v0.2s
	mul	v31.2s, v31.2s, v31.2s
	mul	v0.4s, v0.4s, v0.4s
	mul	v31.4s, v31.4s, v31.4s

positive: mvn instruction

	mvn	w0, w0
	mvn	wzr, wzr
	mvn	w0, w0, lsl 0
	mvn	wzr, wzr, lsl 31
	mvn	w0, w0, lsr 0
	mvn	wzr, wzr, lsr 31
	mvn	w0, w0, asr 0
	mvn	wzr, wzr, asr 31
	mvn	w0, w0, ror 0
	mvn	wzr, wzr, ror 31
	mvn	x0, x0
	mvn	xzr, xzr
	mvn	x0, x0, lsl 0
	mvn	xzr, xzr, lsl 63
	mvn	x0, x0, lsr 0
	mvn	xzr, xzr, lsr 63
	mvn	x0, x0, asr 0
	mvn	xzr, xzr, asr 63
	mvn	x0, x0, ror 0
	mvn	xzr, xzr, ror 63
	mvn	v0.8b, v0.8b
	mvn	v31.8b, v31.8b
	mvn	v0.16b, v0.16b
	mvn	v31.16b, v31.16b

positive: neg instruction

	neg	w0, w0
	neg	wzr, wzr
	neg	w0, w0, lsl 0
	neg	wzr, wzr, lsl 31
	neg	w0, w0, lsr 0
	neg	wzr, wzr, lsr 31
	neg	w0, w0, asr 0
	neg	wzr, wzr, asr 31
	neg	x0, x0
	neg	xzr, xzr
	neg	x0, x0, lsl 0
	neg	xzr, xzr, lsl 63
	neg	x0, x0, lsr 0
	neg	xzr, xzr, lsr 63
	neg	x0, x0, asr 0
	neg	xzr, xzr, asr 63
	neg	d0, d0
	neg	d31, d31

positive: negs instruction

	negs	w0, w0
	negs	wzr, wzr
	negs	w0, w0, lsl 0
	negs	wzr, wzr, lsl 31
	negs	w0, w0, lsr 0
	negs	wzr, wzr, lsr 31
	negs	w0, w0, asr 0
	negs	wzr, wzr, asr 31
	negs	x0, x0
	negs	xzr, xzr
	negs	x0, x0, lsl 0
	negs	xzr, xzr, lsl 63
	negs	x0, x0, lsr 0
	negs	xzr, xzr, lsr 63
	negs	x0, x0, asr 0
	negs	xzr, xzr, asr 63

positive: ngc instruction

	ngc	w0, w0
	ngc	wzr, wzr
	ngc	x0, x0
	ngc	xzr, xzr

positive: ngcs instruction

	ngcs	w0, w0
	ngcs	wzr, wzr
	ngcs	x0, x0
	ngcs	xzr, xzr

positive: nop instruction

	nop

positive: orn instruction

	orn	w0, w0, w0
	orn	wzr, wzr, wzr
	orn	w0, w0, w0, lsl 0
	orn	wzr, wzr, wzr, lsl 31
	orn	w0, w0, w0, lsr 0
	orn	wzr, wzr, wzr, lsr 31
	orn	w0, w0, w0, asr 0
	orn	wzr, wzr, wzr, asr 31
	orn	w0, w0, w0, ror 0
	orn	wzr, wzr, wzr, ror 31
	orn	x0, x0, x0
	orn	xzr, xzr, xzr
	orn	x0, x0, x0, lsl 0
	orn	xzr, xzr, xzr, lsl 63
	orn	x0, x0, x0, lsr 0
	orn	xzr, xzr, xzr, lsr 63
	orn	x0, x0, x0, asr 0
	orn	xzr, xzr, xzr, asr 63
	orn	x0, x0, x0, ror 0
	orn	xzr, xzr, xzr, ror 63
	orn	v0.8b, v0.8b, v0.8b
	orn	v31.8b, v31.8b, v31.8b
	orn	v0.16b, v0.16b, v0.16b
	orn	v31.16b, v31.16b, v31.16b

positive: orr instruction

	orr	w0, w0, 0x1
	orr	wsp, wzr, 0x7fffffff
	orr	x0, x0, 0x1
	orr	sp, xzr, 0x7fffffffffffffff
	orr	w0, w0, w0
	orr	wzr, wzr, wzr
	orr	w0, w0, w0, lsl 0
	orr	wzr, wzr, wzr, lsl 31
	orr	w0, w0, w0, lsr 0
	orr	wzr, wzr, wzr, lsr 31
	orr	w0, w0, w0, asr 0
	orr	wzr, wzr, wzr, asr 31
	orr	w0, w0, w0, ror 0
	orr	wzr, wzr, wzr, ror 31
	orr	x0, x0, x0
	orr	xzr, xzr, xzr
	orr	x0, x0, x0, lsl 0
	orr	xzr, xzr, xzr, lsl 63
	orr	x0, x0, x0, lsr 0
	orr	xzr, xzr, xzr, lsr 63
	orr	x0, x0, x0, asr 0
	orr	xzr, xzr, xzr, asr 63
	orr	x0, x0, x0, ror 0
	orr	xzr, xzr, xzr, ror 63
	orr	v0.8b, v0.8b, v0.8b
	orr	v31.8b, v31.8b, v31.8b
	orr	v0.16b, v0.16b, v0.16b
	orr	v31.16b, v31.16b, v31.16b

positive: pacda instruction

	pacda	x0, x0
	pacda	xzr, sp

positive: pacdza instruction

	pacdza	x0
	pacdza	xzr

positive: pacdb instruction

	pacdb	x0, x0
	pacdb	xzr, sp

positive: pacdzb instruction

	pacdzb	x0
	pacdzb	xzr

positive: pacga instruction

	pacga	x0, x0, x0
	pacga	xzr, xzr, sp

positive: pacia instruction

	pacia	x0, x0
	pacia	xzr, sp

positive: paciza instruction

	paciza	x0
	paciza	xzr

positive: paciasp instruction

	paciasp

positive: pacia1716 instruction

	pacia1716

positive: paciaz instruction

	paciaz

positive: pacib instruction

	pacib	x0, x0
	pacib	xzr, sp

positive: pacizb instruction

	pacizb	x0
	pacizb	xzr

positive: pacibsp instruction

	pacibsp

positive: pacib1716 instruction

	pacib1716

positive: pacibz instruction

	pacibz

positive: psb instruction

	psb	csync

positive: prfm instruction

	prfm	pldl1keep, [x0, 0]
	prfm	pldl1strm, [sp, 32760]
	prfm	pldl2keep, [x0, 0]
	prfm	pldl2strm, [x0, 0]
	prfm	pldl3keep, [x0, 0]
	prfm	pldl3strm, [x0, 0]
	prfm	plil1keep, [x0, 0]
	prfm	plil1strm, [x0, 0]
	prfm	plil2keep, [x0, 0]
	prfm	plil2strm, [x0, 0]
	prfm	plil3keep, [x0, 0]
	prfm	plil3strm, [x0, 0]
	prfm	pstl1keep, [x0, 0]
	prfm	pstl1strm, [x0, 0]
	prfm	pstl2keep, [x0, 0]
	prfm	pstl2strm, [x0, 0]
	prfm	pstl3keep, [x0, 0]
	prfm	pstl3strm, [x0, 0]
	prfm	6, [x0, 0]
	prfm	31, [sp, 32760]
	prfm	pldl1keep, -1048576
	prfm	pstl3strm, +1048572
	prfm	6, -1048576
	prfm	31, +1048572
	prfm	pldl1keep, [x0, w0, uxtw]
	prfm	pstl3strm, [sp, wzr, uxtw 3]
	prfm	pldl1keep, [x0, x0]
	prfm	pstl3strm, [sp, xzr]
	prfm	pldl1keep, [x0, x0, lsl 0]
	prfm	pstl3strm, [sp, xzr, lsl 3]
	prfm	pldl1keep, [x0, w0, sxtw]
	prfm	pstl3strm, [sp, wzr, sxtw 3]
	prfm	pldl1keep, [x0, x0, sxtx]
	prfm	pstl3strm, [sp, xzr, sxtx 3]
	prfm	6, [x0, w0, uxtw]
	prfm	31, [sp, wzr, uxtw 3]
	prfm	6, [x0, x0]
	prfm	31, [sp, xzr]
	prfm	6, [x0, x0, lsl 0]
	prfm	31, [sp, xzr, lsl 3]
	prfm	6, [x0, w0, sxtw]
	prfm	31, [sp, wzr, sxtw 3]
	prfm	6, [x0, x0, sxtx]
	prfm	31, [sp, xzr, sxtx 3]

positive: prfum instruction

	prfum	pldl1keep, [x0, -256]
	prfum	pldl1strm, [sp, +255]
	prfum	pldl2keep, [x0, -256]
	prfum	pldl2strm, [x0, -256]
	prfum	pldl3keep, [x0, -256]
	prfum	pldl3strm, [x0, -256]
	prfum	plil1keep, [x0, -256]
	prfum	plil1strm, [x0, -256]
	prfum	plil2keep, [x0, -256]
	prfum	plil2strm, [x0, -256]
	prfum	plil3keep, [x0, -256]
	prfum	plil3strm, [x0, -256]
	prfum	pstl1keep, [x0, -256]
	prfum	pstl1strm, [x0, -256]
	prfum	pstl2keep, [x0, -256]
	prfum	pstl2strm, [x0, -256]
	prfum	pstl3keep, [x0, -256]
	prfum	pstl3strm, [x0, -256]
	prfum	6, [x0, -256]
	prfum	31, [sp, +255]

positive: rbit instruction

	rbit	w0, w0
	rbit	wzr, wzr
	rbit	x0, x0
	rbit	xzr, xzr
	rbit	v0.8b, v0.8b
	rbit	v31.8b, v31.8b
	rbit	v0.16b, v0.16b
	rbit	v31.16b, v31.16b

positive: ret instruction

	ret
	ret	x0
	ret	xzr

positive: retaa instruction

	retaa

positive: retab instruction

	retab

positive: rev instruction

	rev	w0, w0
	rev	wzr, wzr
	rev	x0, x0
	rev	xzr, xzr

positive: rev16 instruction

	rev16	w0, w0
	rev16	wzr, wzr
	rev16	x0, x0
	rev16	xzr, xzr
	rev16	v0.8b, v0.8b
	rev16	v31.8b, v31.8b
	rev16	v0.16b, v0.16b
	rev16	v31.16b, v31.16b

positive: rev32 instruction

	rev32	x0, x0
	rev32	xzr, xzr
	rev32	v0.8b, v0.8b
	rev32	v31.8b, v31.8b
	rev32	v0.16b, v0.16b
	rev32	v31.16b, v31.16b
	rev32	v0.4h, v0.4h
	rev32	v31.4h, v31.4h
	rev32	v0.8h, v0.8h
	rev32	v31.8h, v31.8h

positive: rev64 instruction

	rev64	x0, x0
	rev64	xzr, xzr
	rev64	v0.8b, v0.8b
	rev64	v31.8b, v31.8b
	rev64	v0.16b, v0.16b
	rev64	v31.16b, v31.16b
	rev64	v0.4h, v0.4h
	rev64	v31.4h, v31.4h
	rev64	v0.8h, v0.8h
	rev64	v31.8h, v31.8h
	rev64	v0.2s, v0.2s
	rev64	v31.2s, v31.2s
	rev64	v0.4s, v0.4s
	rev64	v31.4s, v31.4s

positive: ror instruction

	ror	w0, w0, 0
	ror	wzr, wzr, 31
	ror	x0, x0, 0
	ror	xzr, xzr, 63
	ror	w0, w0, w0
	ror	wzr, wzr, wzr
	ror	x0, x0, x0
	ror	xzr, xzr, xzr

positive: rorv instruction

	rorv	w0, w0, w0
	rorv	wzr, wzr, wzr
	rorv	x0, x0, x0
	rorv	xzr, xzr, xzr

positive: sbc instruction

	sbc	w0, w0, w0
	sbc	wzr, wzr, wzr
	sbc	x0, x0, x0
	sbc	xzr, xzr, xzr

positive: sbcs instruction

	sbcs	w0, w0, w0
	sbcs	wzr, wzr, wzr
	sbcs	x0, x0, x0
	sbcs	xzr, xzr, xzr

positive: sbfiz instruction

	sbfiz	w0, w0, 0, 1
	sbfiz	wzr, wzr, 31, 32
	sbfiz	x0, x0, 0, 1
	sbfiz	xzr, xzr, 63, 64

positive: sbfm instruction

	sbfm	w0, w0, 0, 0
	sbfm	wzr, wzr, 31, 31
	sbfm	x0, x0, 0, 0
	sbfm	xzr, xzr, 63, 63

positive: sbfx instruction

	sbfx	w0, w0, 0, 32
	sbfx	wzr, wzr, 31, 1
	sbfx	x0, x0, 0, 64
	sbfx	xzr, xzr, 63, 1

positive: sdiv instruction

	sdiv	w0, w0, w0
	sdiv	wzr, wzr, wzr
	sdiv	x0, x0, x0
	sdiv	xzr, xzr, xzr

positive: sev instruction

	sev

positive: sevl instruction

	sevl

positive: smaddl instruction

	smaddl	x0, w0, w0, x0
	smaddl	xzr, wzr, wzr, xzr

positive: smc instruction

	smc	0
	smc	65535

positive: smnegl instruction

	smnegl	x0, w0, w0
	smnegl	xzr, wzr, wzr

positive: smsubl instruction

	smsubl	x0, w0, w0, x0
	smsubl	xzr, wzr, wzr, xzr

positive: smulh instruction

	smulh	x0, x0, x0
	smulh	xzr, xzr, xzr

positive: smull instruction

	smull	x0, w0, w0
	smull	xzr, wzr, wzr
	smull	v0.4s, v0.4h, v0.h[0]
	smull	v31.4s, v31.4h, v15.h[7]
	smull	v0.2d, v0.2s, v0.s[0]
	smull	v31.2d, v31.2s, v31.s[3]
	smull	v0.8h, v0.8b, v0.8b
	smull	v31.8h, v31.8b, v31.8b
	smull	v0.4s, v0.4h, v0.4h
	smull	v31.4s, v31.4h, v31.4h
	smull	v0.2d, v0.2s, v0.2s
	smull	v31.2d, v31.2s, v31.2s

positive: staddb instruction

	staddb	w0, [x0]
	staddb	wzr, [sp]

positive: staddlb instruction

	staddlb	w0, [x0]
	staddlb	wzr, [sp]

positive: staddh instruction

	staddh	w0, [x0]
	staddh	wzr, [sp]

positive: staddlh instruction

	staddlh	w0, [x0]
	staddlh	wzr, [sp]

positive: stadd instruction

	stadd	w0, [x0]
	stadd	wzr, [sp]
	stadd	x0, [x0]
	stadd	xzr, [sp]

positive: staddl instruction

	staddl	w0, [x0]
	staddl	wzr, [sp]
	staddl	x0, [x0]
	staddl	xzr, [sp]

positive: stclrb instruction

	stclrb	w0, [x0]
	stclrb	wzr, [sp]

positive: stclrlb instruction

	stclrlb	w0, [x0]
	stclrlb	wzr, [sp]

positive: stclrh instruction

	stclrh	w0, [x0]
	stclrh	wzr, [sp]

positive: stclrlh instruction

	stclrlh	w0, [x0]
	stclrlh	wzr, [sp]

positive: stclr instruction

	stclr	w0, [x0]
	stclr	wzr, [sp]
	stclr	x0, [x0]
	stclr	xzr, [sp]

positive: stclrl instruction

	stclrl	w0, [x0]
	stclrl	wzr, [sp]
	stclrl	x0, [x0]
	stclrl	xzr, [sp]

positive: steorb instruction

	steorb	w0, [x0]
	steorb	wzr, [sp]

positive: steorlb instruction

	steorlb	w0, [x0]
	steorlb	wzr, [sp]

positive: steorh instruction

	steorh	w0, [x0]
	steorh	wzr, [sp]

positive: steorlh instruction

	steorlh	w0, [x0]
	steorlh	wzr, [sp]

positive: steor instruction

	steor	w0, [x0]
	steor	wzr, [sp]
	steor	x0, [x0]
	steor	xzr, [sp]

positive: steorl instruction

	steorl	w0, [x0]
	steorl	wzr, [sp]
	steorl	x0, [x0]
	steorl	xzr, [sp]

positive: stllr instruction

	stllr	w0, [x0]
	stllr	wzr, [sp, 0]
	stllr	x0, [x0]
	stllr	xzr, [sp, 0]

positive: stllrb instruction

	stllrb	w0, [x0]
	stllrb	wzr, [sp, 0]

positive: stllrh instruction

	stllrh	w0, [x0]
	stllrh	wzr, [sp, 0]

positive: stlr instruction

	stlr	w0, [x0]
	stlr	wzr, [sp, 0]
	stlr	x0, [x0]
	stlr	xzr, [sp, 0]

positive: stlrb instruction

	stlrb	w0, [x0]
	stlrb	wzr, [sp, 0]

positive: stlrh instruction

	stlrh	w0, [x0]
	stlrh	wzr, [sp, 0]

positive: stlxp instruction

	stlxp	w0, w0, w0, [x0]
	stlxp	wzr, wzr, wzr, [sp, 0]
	stlxp	w0, x0, x0, [x0]
	stlxp	wzr, xzr, xzr, [sp, 0]

positive: stlxr instruction

	stlxr	w0, w0, [x0]
	stlxr	wzr, wzr, [sp, 0]
	stlxr	w0, x0, [x0]
	stlxr	wzr, xzr, [sp, 0]

positive: stlxrb instruction

	stlxrb	w0, w0, [x0]
	stlxrb	wzr, wzr, [sp, 0]

positive: stlxrh instruction

	stlxrh	w0, w0, [x0]
	stlxrh	wzr, wzr, [sp, 0]

positive: stnp instruction

	stnp	w0, w0, [x0]
	stnp	wzr, wzr, [x0]
	stnp	w0, w0, [x0, -256]
	stnp	wzr, wzr, [sp, -252]
	stnp	x0, x0, [x0]
	stnp	xzr, xzr, [x0]
	stnp	x0, x0, [x0, -512]
	stnp	xzr, xzr, [sp, -504]
	stnp	s0, s0, [x0]
	stnp	s31, s31, [sp]
	stnp	s0, s0, [x0, -256]
	stnp	s31, s31, [sp, +252]
	stnp	d0, d0, [x0]
	stnp	d31, d31, [sp]
	stnp	d0, d0, [x0, -512]
	stnp	d31, d31, [sp, +504]
	stnp	q0, q0, [x0]
	stnp	q31, q31, [sp]
	stnp	q0, q0, [x0, -1024]
	stnp	q31, q31, [sp, +1008]

positive: stp instruction

	stp	w0, w0, [x0], -256
	stp	wzr, wzr, [sp], +252
	stp	x0, x0, [x0], -512
	stp	xzr, xzr, [sp], +504
	stp	w0, w0, [x0, -256]!
	stp	wzr, wzr, [sp, +252]!
	stp	x0, x0, [x0, -512]!
	stp	xzr, xzr, [sp, +504]!
	stp	w0, w0, [x0]
	stp	wzr, wzr, [sp]
	stp	w0, w0, [x0, -256]
	stp	wzr, wzr, [sp, +252]
	stp	x0, x0, [x0]
	stp	xzr, xzr, [sp]
	stp	x0, x0, [x0, -512]
	stp	xzr, xzr, [sp, +504]
	stp	s0, s0, [x0], -256
	stp	s31, s31, [sp], +252
	stp	d0, d0, [x0], -512
	stp	d31, d31, [sp], +504
	stp	q0, q0, [x0], -1024
	stp	q31, q31, [sp], +1008
	stp	s0, s0, [x0, -256]!
	stp	s31, s31, [sp, +252]!
	stp	d0, d0, [x0, -512]!
	stp	d31, d31, [sp, +504]!
	stp	q0, q0, [x0, -1024]!
	stp	q31, q31, [sp, +1008]!
	stp	s0, s0, [x0]
	stp	s31, s31, [sp]
	stp	s0, s0, [x0, -256]
	stp	s31, s31, [sp, +252]
	stp	d0, d0, [x0]
	stp	d31, d31, [sp]
	stp	d0, d0, [x0, -512]
	stp	d31, d31, [sp, +504]
	stp	q0, q0, [x0]
	stp	q31, q31, [sp]
	stp	q0, q0, [x0, -1024]
	stp	q31, q31, [sp, +1008]

positive: str instruction

	str	w0, [x0], -256
	str	wzr, [sp], +255
	str	x0, [x0], -256
	str	xzr, [sp], +255
	str	w0, [x0, -256]!
	str	wzr, [sp, +255]!
	str	x0, [x0, -256]!
	str	xzr, [sp, +255]!
	str	w0, [x0]
	str	wzr, [sp]
	str	w0, [x0, 0]
	str	wzr, [sp, 16380]
	str	x0, [x0]
	str	xzr, [sp]
	str	x0, [x0, 0]
	str	xzr, [sp, 32760]
	str	w0, [x0, w0, uxtw]
	str	wzr, [sp, wzr, uxtw 2]
	str	w0, [x0, x0]
	str	wzr, [sp, xzr]
	str	w0, [x0, x0, lsl 0]
	str	wzr, [sp, xzr, lsl 2]
	str	w0, [x0, w0, sxtw]
	str	wzr, [sp, wzr, sxtw 2]
	str	w0, [x0, x0, sxtx]
	str	wzr, [sp, xzr, sxtx 2]
	str	x0, [x0, w0, uxtw]
	str	xzr, [sp, wzr, uxtw 3]
	str	x0, [x0, x0]
	str	xzr, [sp, xzr]
	str	x0, [x0, x0, lsl 0]
	str	xzr, [sp, xzr, lsl 3]
	str	x0, [x0, w0, sxtw]
	str	xzr, [sp, wzr, sxtw 3]
	str	x0, [x0, x0, sxtx]
	str	xzr, [sp, xzr, sxtx 3]
	str	b0, [x0], -256
	str	b31, [sp], +255
	str	h0, [x0], -256
	str	h31, [sp], +255
	str	s0, [x0], -256
	str	s31, [sp], +255
	str	d0, [x0], -256
	str	d31, [sp], +255
	str	q0, [x0], -256
	str	q31, [sp], +255
	str	b0, [x0, -256]!
	str	b31, [sp, +255]!
	str	h0, [x0, -256]!
	str	h31, [sp, +255]!
	str	s0, [x0, -256]!
	str	s31, [sp, +255]!
	str	d0, [x0, -256]!
	str	d31, [sp, +255]!
	str	q0, [x0, -256]!
	str	q31, [sp, +255]!
	str	b0, [x0]
	str	b31, [sp]
	str	b0, [x0, 0]
	str	b31, [sp, 4095]
	str	h0, [x0]
	str	h31, [sp]
	str	h0, [x0, 0]
	str	h31, [sp, 8190]
	str	s0, [x0]
	str	s31, [sp]
	str	s0, [x0, 0]
	str	s31, [sp, 16380]
	str	d0, [x0]
	str	d31, [sp]
	str	d0, [x0, 0]
	str	d31, [sp, 32760]
	str	q0, [x0]
	str	q31, [sp]
	str	q0, [x0, 0]
	str	q31, [sp, 65520]
	str	b0, [x0, w0, uxtw]
	str	b31, [sp, wzr, uxtw 0]
	str	b0, [x0, x0]
	str	b31, [sp, xzr]
	str	b0, [x0, x0, lsl 0]
	str	b31, [sp, xzr, lsl 0]
	str	b0, [x0, w0, sxtw]
	str	b31, [sp, wzr, sxtw 0]
	str	b0, [x0, x0, sxtx]
	str	b31, [sp, xzr, sxtx 0]
	str	h0, [x0, w0, uxtw]
	str	h31, [sp, wzr, uxtw 1]
	str	h0, [x0, x0]
	str	h31, [sp, xzr]
	str	h0, [x0, x0, lsl 0]
	str	h31, [sp, xzr, lsl 1]
	str	h0, [x0, w0, sxtw]
	str	h31, [sp, wzr, sxtw 1]
	str	h0, [x0, x0, sxtx]
	str	h31, [sp, xzr, sxtx 1]
	str	s0, [x0, w0, uxtw]
	str	s31, [sp, wzr, uxtw 2]
	str	s0, [x0, x0]
	str	s31, [sp, xzr]
	str	s0, [x0, x0, lsl 0]
	str	s31, [sp, xzr, lsl 2]
	str	s0, [x0, w0, sxtw]
	str	s31, [sp, wzr, sxtw 2]
	str	s0, [x0, x0, sxtx]
	str	s31, [sp, xzr, sxtx 2]
	str	d0, [x0, w0, uxtw]
	str	d31, [sp, wzr, uxtw 3]
	str	d0, [x0, x0]
	str	d31, [sp, xzr]
	str	d0, [x0, x0, lsl 0]
	str	d31, [sp, xzr, lsl 3]
	str	d0, [x0, w0, sxtw]
	str	d31, [sp, wzr, sxtw 3]
	str	d0, [x0, x0, sxtx]
	str	d31, [sp, xzr, sxtx 3]

positive: strb instruction

	strb	w0, [x0], -256
	strb	wzr, [sp], +255
	strb	w0, [x0, -256]!
	strb	wzr, [sp, +255]!
	strb	w0, [x0]
	strb	wzr, [sp]
	strb	w0, [x0, 0]
	strb	wzr, [sp, 4095]
	strb	w0, [x0, w0, uxtw]
	strb	wzr, [sp, wzr, uxtw 0]
	strb	w0, [x0, x0]
	strb	wzr, [sp, xzr]
	strb	w0, [x0, x0, lsl 0]
	strb	wzr, [sp, xzr, lsl 0]
	strb	w0, [x0, w0, sxtw]
	strb	wzr, [sp, wzr, sxtw 0]
	strb	w0, [x0, x0, sxtx]
	strb	wzr, [sp, xzr, sxtx 0]

positive: strh instruction

	strh	w0, [x0], -256
	strh	wzr, [sp], +255
	strh	w0, [x0, -256]!
	strh	wzr, [sp, +255]!
	strh	w0, [x0]
	strh	wzr, [sp]
	strh	w0, [x0, 0]
	strh	wzr, [sp, 8190]
	strh	w0, [x0, w0, uxtw]
	strh	wzr, [sp, wzr, uxtw 1]
	strh	w0, [x0, x0]
	strh	wzr, [sp, xzr]
	strh	w0, [x0, x0, lsl 0]
	strh	wzr, [sp, xzr, lsl 1]
	strh	w0, [x0, w0, sxtw]
	strh	wzr, [sp, wzr, sxtw 1]
	strh	w0, [x0, x0, sxtx]
	strh	wzr, [sp, xzr, sxtx 1]

positive: stsetb instruction

	stsetb	w0, [x0]
	stsetb	wzr, [sp]

positive: stsetlb instruction

	stsetlb	w0, [x0]
	stsetlb	wzr, [sp]

positive: stseth instruction

	stseth	w0, [x0]
	stseth	wzr, [sp]

positive: stsetlh instruction

	stsetlh	w0, [x0]
	stsetlh	wzr, [sp]

positive: stset instruction

	stset	w0, [x0]
	stset	wzr, [sp]
	stset	x0, [x0]
	stset	xzr, [sp]

positive: stsetl instruction

	stsetl	w0, [x0]
	stsetl	wzr, [sp]
	stsetl	x0, [x0]
	stsetl	xzr, [sp]

positive: stsmaxb instruction

	stsmaxb	w0, [x0]
	stsmaxb	wzr, [sp]

positive: stsmaxlb instruction

	stsmaxlb	w0, [x0]
	stsmaxlb	wzr, [sp]

positive: stsmaxh instruction

	stsmaxh	w0, [x0]
	stsmaxh	wzr, [sp]

positive: stsmaxlh instruction

	stsmaxlh	w0, [x0]
	stsmaxlh	wzr, [sp]

positive: stsmax instruction

	stsmax	w0, [x0]
	stsmax	wzr, [sp]
	stsmax	x0, [x0]
	stsmax	xzr, [sp]

positive: stsmaxl instruction

	stsmaxl	w0, [x0]
	stsmaxl	wzr, [sp]
	stsmaxl	x0, [x0]
	stsmaxl	xzr, [sp]

positive: stsminb instruction

	stsminb	w0, [x0]
	stsminb	wzr, [sp]

positive: stsminlb instruction

	stsminlb	w0, [x0]
	stsminlb	wzr, [sp]

positive: stsminh instruction

	stsminh	w0, [x0]
	stsminh	wzr, [sp]

positive: stsminlh instruction

	stsminlh	w0, [x0]
	stsminlh	wzr, [sp]

positive: stsmin instruction

	stsmin	w0, [x0]
	stsmin	wzr, [sp]
	stsmin	x0, [x0]
	stsmin	xzr, [sp]

positive: stsminl instruction

	stsminl	w0, [x0]
	stsminl	wzr, [sp]
	stsminl	x0, [x0]
	stsminl	xzr, [sp]

positive: sttr instruction

	sttr	w0, [x0]
	sttr	wzr, [sp]
	sttr	w0, [x0, -256]
	sttr	wzr, [sp, +255]
	sttr	x0, [x0, -256]
	sttr	xzr, [sp, +255]

positive: sttrb instruction

	sttrb	w0, [x0]
	sttrb	wzr, [sp]
	sttrb	w0, [x0, -256]
	sttrb	wzr, [sp, +255]

positive: sttrh instruction

	sttrh	w0, [x0]
	sttrh	wzr, [sp, +255]
	sttrh	w0, [x0]
	sttrh	wzr, [sp, +255]

positive: stumaxb instruction

	stumaxb	w0, [x0]
	stumaxb	wzr, [sp]

positive: stumaxlb instruction

	stumaxlb	w0, [x0]
	stumaxlb	wzr, [sp]

positive: stumaxh instruction

	stumaxh	w0, [x0]
	stumaxh	wzr, [sp]

positive: stumaxlh instruction

	stumaxlh	w0, [x0]
	stumaxlh	wzr, [sp]

positive: stumax instruction

	stumax	w0, [x0]
	stumax	wzr, [sp]
	stumax	x0, [x0]
	stumax	xzr, [sp]

positive: stumaxl instruction

	stumaxl	w0, [x0]
	stumaxl	wzr, [sp]
	stumaxl	x0, [x0]
	stumaxl	xzr, [sp]

positive: stuminb instruction

	stuminb	w0, [x0]
	stuminb	wzr, [sp]

positive: stuminlb instruction

	stuminlb	w0, [x0]
	stuminlb	wzr, [sp]

positive: stuminh instruction

	stuminh	w0, [x0]
	stuminh	wzr, [sp]

positive: stuminlh instruction

	stuminlh	w0, [x0]
	stuminlh	wzr, [sp]

positive: stumin instruction

	stumin	w0, [x0]
	stumin	wzr, [sp]
	stumin	x0, [x0]
	stumin	xzr, [sp]

positive: stuminl instruction

	stuminl	w0, [x0]
	stuminl	wzr, [sp]
	stuminl	x0, [x0]
	stuminl	xzr, [sp]

positive: stur instruction

	stur	w0, [x0]
	stur	wzr, [sp]
	stur	w0, [x0, -256]
	stur	wzr, [sp, +255]
	stur	x0, [x0, -256]
	stur	xzr, [sp, +255]
	stur	b0, [x0]
	stur	b31, [sp]
	stur	b0, [x0, -256]
	stur	b31, [sp, +255]
	stur	h0, [x0]
	stur	h31, [sp]
	stur	h0, [x0, -256]
	stur	h31, [sp, +255]
	stur	s0, [x0]
	stur	s31, [sp]
	stur	s0, [x0, -256]
	stur	s31, [sp, +255]
	stur	d0, [x0]
	stur	d31, [sp]
	stur	d0, [x0, -256]
	stur	d31, [sp, +255]
	stur	q0, [x0]
	stur	q31, [sp]
	stur	q0, [x0, -256]
	stur	q31, [sp, +255]

positive: sturb instruction

	sturb	w0, [x0]
	sturb	wzr, [sp]
	sturb	w0, [x0, -256]
	sturb	wzr, [sp, +255]

positive: sturh instruction

	sturh	w0, [x0]
	sturh	wzr, [sp, +255]
	sturh	w0, [x0]
	sturh	wzr, [sp, +255]

positive: stxp instruction

	stxp	w0, w0, w0, [x0]
	stxp	wzr, wzr, wzr, [sp, 0]
	stxp	w0, x0, x0, [x0]
	stxp	wzr, xzr, xzr, [sp, 0]

positive: stxr instruction

	stxr	w0, w0, [x0]
	stxr	wzr, wzr, [sp, 0]
	stxr	w0, x0, [x0]
	stxr	wzr, xzr, [sp, 0]

positive: stxrb instruction

	stxrb	w0, w0, [x0]
	stxrb	wzr, wzr, [sp, 0]

positive: stxrh instruction

	stxrh	w0, w0, [x0]
	stxrh	wzr, wzr, [sp, 0]

positive: sub instruction

	sub	w0, w0, w0
	sub	wsp, wsp, wzr
	sub	w0, w0, w0, lsl 0
	sub	wsp, wsp, wzr, lsl 3
	sub	w0, w0, w0, uxtb 0
	sub	wsp, wsp, wzr, uxtb 3
	sub	w0, w0, w0, uxth 0
	sub	wsp, wsp, wzr, uxth 3
	sub	w0, w0, w0, uxtw 0
	sub	wsp, wsp, wzr, uxtw 3
	sub	w0, w0, w0, uxtx 0
	sub	wsp, wsp, wzr, uxtx 3
	sub	w0, w0, w0, sxtb 0
	sub	wsp, wsp, wzr, sxtb 3
	sub	w0, w0, w0, sxth 0
	sub	wsp, wsp, wzr, sxth 3
	sub	w0, w0, w0, sxtw 0
	sub	wsp, wsp, wzr, sxtw 3
	sub	w0, w0, w0, sxtx 0
	sub	wsp, wsp, wzr, sxtx 3
	sub	x0, x0, x0
	sub	sp, sp, xzr
	sub	x0, x0, x0, lsl 0
	sub	sp, sp, xzr, lsl 3
	sub	x0, x0, x0, uxtb 0
	sub	sp, sp, xzr, uxtb 3
	sub	x0, x0, x0, uxth 0
	sub	sp, sp, xzr, uxth 3
	sub	x0, x0, x0, uxtw 0
	sub	sp, sp, xzr, uxtw 3
	sub	x0, x0, x0, uxtx 0
	sub	sp, sp, xzr, uxtx 3
	sub	x0, x0, x0, sxtb 0
	sub	sp, sp, xzr, sxtb 3
	sub	x0, x0, x0, sxth 0
	sub	sp, sp, xzr, sxth 3
	sub	x0, x0, x0, sxtw 0
	sub	sp, sp, xzr, sxtw 3
	sub	x0, x0, x0, sxtx 0
	sub	sp, sp, xzr, sxtx 3
	sub	w0, w0, 0
	sub	wsp, wsp, 4095
	sub	w0, w0, 0, lsl 0
	sub	wsp, wsp, 4095, lsl 0
	sub	w0, w0, 0, lsl 12
	sub	wsp, wsp, 4095, lsl 12
	sub	x0, x0, 0
	sub	sp, sp, 4095
	sub	x0, x0, 0, lsl 0
	sub	sp, sp, 4095, lsl 0
	sub	x0, x0, 0, lsl 12
	sub	sp, sp, 4095, lsl 12
	sub	w0, w0, w0
	sub	wzr, wzr, wzr
	sub	w0, w0, w0, lsl 0
	sub	wzr, wzr, wzr, lsl 31
	sub	w0, w0, w0, lsr 0
	sub	wzr, wzr, wzr, lsr 31
	sub	w0, w0, w0, asr 0
	sub	wzr, wzr, wzr, asr 31
	sub	x0, x0, x0
	sub	xzr, xzr, xzr
	sub	x0, x0, x0, lsl 0
	sub	xzr, xzr, xzr, lsl 63
	sub	x0, x0, x0, lsr 0
	sub	xzr, xzr, xzr, lsr 63
	sub	x0, x0, x0, asr 0
	sub	xzr, xzr, xzr, asr 63
	sub	d0, d0, d0
	sub	d31, d31, d31
	sub	v0.8b, v0.8b, v0.8b
	sub	v31.8b, v31.8b, v31.8b
	sub	v0.16b, v0.16b, v0.16b
	sub	v31.16b, v31.16b, v31.16b
	sub	v0.4h, v0.4h, v0.4h
	sub	v31.4h, v31.4h, v31.4h
	sub	v0.8h, v0.8h, v0.8h
	sub	v31.8h, v31.8h, v31.8h
	sub	v0.2s, v0.2s, v0.2s
	sub	v31.2s, v31.2s, v31.2s
	sub	v0.4s, v0.4s, v0.4s
	sub	v31.4s, v31.4s, v31.4s
	sub	v0.2d, v0.2d, v0.2d
	sub	v31.2d, v31.2d, v31.2d

positive: subs instruction

	subs	w0, w0, w0
	subs	wsp, wsp, wzr
	subs	w0, w0, w0, lsl 0
	subs	wsp, wsp, wzr, lsl 3
	subs	w0, w0, w0, uxtb 0
	subs	wsp, wsp, wzr, uxtb 3
	subs	w0, w0, w0, uxth 0
	subs	wsp, wsp, wzr, uxth 3
	subs	w0, w0, w0, uxtw 0
	subs	wsp, wsp, wzr, uxtw 3
	subs	w0, w0, w0, uxtx 0
	subs	wsp, wsp, wzr, uxtx 3
	subs	w0, w0, w0, sxtb 0
	subs	wsp, wsp, wzr, sxtb 3
	subs	w0, w0, w0, sxth 0
	subs	wsp, wsp, wzr, sxth 3
	subs	w0, w0, w0, sxtw 0
	subs	wsp, wsp, wzr, sxtw 3
	subs	w0, w0, w0, sxtx 0
	subs	wsp, wsp, wzr, sxtx 3
	subs	x0, x0, x0
	subs	sp, sp, xzr
	subs	x0, x0, x0, lsl 0
	subs	sp, sp, xzr, lsl 3
	subs	x0, x0, x0, uxtb 0
	subs	sp, sp, xzr, uxtb 3
	subs	x0, x0, x0, uxth 0
	subs	sp, sp, xzr, uxth 3
	subs	x0, x0, x0, uxtw 0
	subs	sp, sp, xzr, uxtw 3
	subs	x0, x0, x0, uxtx 0
	subs	sp, sp, xzr, uxtx 3
	subs	x0, x0, x0, sxtb 0
	subs	sp, sp, xzr, sxtb 3
	subs	x0, x0, x0, sxth 0
	subs	sp, sp, xzr, sxth 3
	subs	x0, x0, x0, sxtw 0
	subs	sp, sp, xzr, sxtw 3
	subs	x0, x0, x0, sxtx 0
	subs	sp, sp, xzr, sxtx 3
	subs	w0, w0, 0
	subs	wsp, wsp, 4095
	subs	w0, w0, 0, lsl 0
	subs	wsp, wsp, 4095, lsl 0
	subs	w0, w0, 0, lsl 12
	subs	wsp, wsp, 4095, lsl 12
	subs	x0, x0, 0
	subs	sp, sp, 4095
	subs	x0, x0, 0, lsl 0
	subs	sp, sp, 4095, lsl 0
	subs	x0, x0, 0, lsl 12
	subs	sp, sp, 4095, lsl 12
	subs	w0, w0, w0
	subs	wzr, wzr, wzr
	subs	w0, w0, w0, lsl 0
	subs	wzr, wzr, wzr, lsl 31
	subs	w0, w0, w0, lsr 0
	subs	wzr, wzr, wzr, lsr 31
	subs	w0, w0, w0, asr 0
	subs	wzr, wzr, wzr, asr 31
	subs	x0, x0, x0
	subs	xzr, xzr, xzr
	subs	x0, x0, x0, lsl 0
	subs	xzr, xzr, xzr, lsl 63
	subs	x0, x0, x0, lsr 0
	subs	xzr, xzr, xzr, lsr 63
	subs	x0, x0, x0, asr 0
	subs	xzr, xzr, xzr, asr 63

positive: svc instruction

	svc	0
	svc	65535

positive: swpab instruction

	swpab	w0, w0, [x0]
	swpab	wzr, wzr, [sp, 0]

positive: swpalb instruction

	swpalb	w0, w0, [x0]
	swpalb	wzr, wzr, [sp, 0]

positive: swpb instruction

	swpb	w0, w0, [x0]
	swpb	wzr, wzr, [sp, 0]

positive: swplb instruction

	swplb	w0, w0, [x0]
	swplb	wzr, wzr, [sp, 0]

positive: swpah instruction

	swpah	w0, w0, [x0]
	swpah	wzr, wzr, [sp, 0]

positive: swpalh instruction

	swpalh	w0, w0, [x0]
	swpalh	wzr, wzr, [sp, 0]

positive: swph instruction

	swph	w0, w0, [x0]
	swph	wzr, wzr, [sp, 0]

positive: swplh instruction

	swplh	w0, w0, [x0]
	swplh	wzr, wzr, [sp, 0]

positive: swp instruction

	swp	w0, w0, [x0]
	swp	wzr, wzr, [sp, 0]
	swp	x0, x0, [x0]
	swp	xzr, xzr, [sp, 0]

positive: swpa instruction

	swpa	w0, w0, [x0]
	swpa	wzr, wzr, [sp, 0]
	swpa	x0, x0, [x0]
	swpa	xzr, xzr, [sp, 0]

positive: swpal instruction

	swpal	w0, w0, [x0]
	swpal	wzr, wzr, [sp, 0]
	swpal	x0, x0, [x0]
	swpal	xzr, xzr, [sp, 0]

positive: swpl instruction

	swpl	w0, w0, [x0]
	swpl	wzr, wzr, [sp, 0]
	swpl	x0, x0, [x0]
	swpl	xzr, xzr, [sp, 0]

positive: sxtb instruction

	sxtb	w0, w0
	sxtb	wzr, wzr
	sxtb	x0, w0
	sxtb	xzr, wzr

positive: sxth instruction

	sxth	w0, w0
	sxth	wzr, wzr
	sxth	x0, w0
	sxth	xzr, wzr

positive: sxtw instruction

	sxtw	x0, w0
	sxtw	xzr, wzr

positive: sys instruction

	sys	0, c0, c0, 0
	sys	7, c15, c15, 7
	sys	0, c0, c0, 0, x0
	sys	7, c15, c15, 7, xzr

positive: sysl instruction

	sysl	x0, 0, c0, c0, 0
	sysl	xzr, 7, c15, c15, 7

positive: tbnz instruction

	tbnz	w0, 0, -32768
	tbnz	wzr, 31, +32764
	tbnz	x0, 0, -32768
	tbnz	xzr, 63, +32764

positive: tbz instruction

	tbz	w0, 0, -32768
	tbz	wzr, 31, +32764
	tbz	x0, 0, -32768
	tbz	xzr, 63, +32764

positive: tlbi instruction

	tlbi	vmalle1is, x0
	tlbi	vae1is, xzr
	tlbi	aside1is
	tlbi	vaae1is
	tlbi	vale1is
	tlbi	vaale1is
	tlbi	vmalle1
	tlbi	vae1
	tlbi	aside1
	tlbi	vaae1
	tlbi	vale1
	tlbi	vaale1
	tlbi	ipas2e1is
	tlbi	ipas2le1is
	tlbi	alle2is
	tlbi	vae2is
	tlbi	alle1is
	tlbi	vale2is
	tlbi	vmalls12e1is
	tlbi	ipas2e1
	tlbi	ipas2le1
	tlbi	alle2
	tlbi	vae2
	tlbi	alle1
	tlbi	vale2
	tlbi	vmalls12e1
	tlbi	alle3is
	tlbi	vae3is
	tlbi	vale3is
	tlbi	alle3
	tlbi	vae3
	tlbi	vale3

positive: tst instruction

	tst	w0, w0
	tst	wzr, wzr
	tst	w0, w0, lsl 0
	tst	wzr, wzr, lsl 31
	tst	w0, w0, lsr 0
	tst	wzr, wzr, lsr 31
	tst	w0, w0, asr 0
	tst	wzr, wzr, asr 31
	tst	w0, w0, ror 0
	tst	wzr, wzr, ror 31
	tst	x0, x0
	tst	xzr, xzr
	tst	x0, x0, lsl 0
	tst	xzr, xzr, lsl 63
	tst	x0, x0, lsr 0
	tst	xzr, xzr, lsr 63
	tst	x0, x0, asr 0
	tst	xzr, xzr, asr 63
	tst	x0, x0, ror 0
	tst	xzr, xzr, ror 63

positive: ubfiz instruction

	ubfiz	w0, w0, 0, 1
	ubfiz	wzr, wzr, 31, 32
	ubfiz	x0, x0, 0, 1
	ubfiz	xzr, xzr, 63, 64

positive: ubfm instruction

	ubfm	w0, w0, 0, 0
	ubfm	wzr, wzr, 31, 31
	ubfm	x0, x0, 0, 0
	ubfm	xzr, xzr, 63, 63

positive: ubfx instruction

	ubfx	w0, w0, 0, 32
	ubfx	wzr, wzr, 31, 1
	ubfx	x0, x0, 0, 64
	ubfx	xzr, xzr, 63, 1

positive: udiv instruction

	udiv	w0, w0, w0
	udiv	wzr, wzr, wzr
	udiv	x0, x0, x0
	udiv	xzr, xzr, xzr

positive: umaddl instruction

	umaddl	x0, w0, w0, x0
	umaddl	xzr, wzr, wzr, xzr

positive: umnegl instruction

	umnegl	x0, w0, w0
	umnegl	xzr, wzr, wzr

positive: umsubl instruction

	umsubl	x0, w0, w0, x0
	umsubl	xzr, wzr, wzr, xzr

positive: umulh instruction

	umulh	x0, x0, x0
	umulh	xzr, xzr, xzr

positive: umull instruction

	umull	x0, w0, w0
	umull	xzr, wzr, wzr
	umull	v0.4s, v0.4h, v0.h[0]
	umull	v31.4s, v31.4h, v15.h[7]
	umull	v0.2d, v0.2s, v0.s[0]
	umull	v31.2d, v31.2s, v31.s[3]
	umull	v0.8h, v0.8b, v0.8b
	umull	v31.8h, v31.8b, v31.8b
	umull	v0.4s, v0.4h, v0.4h
	umull	v31.4s, v31.4h, v31.4h
	umull	v0.2d, v0.2s, v0.2s
	umull	v31.2d, v31.2s, v31.2s

positive: uxtb instruction

	uxtb	w0, w0
	uxtb	wzr, wzr

positive: uxth instruction

	uxth	w0, w0
	uxth	wzr, wzr

positive: wfe instruction

	wfe

positive: wfi instruction

	wfi

positive: xpacd instruction

	xpacd	x0
	xpacd	xzr

positive: xpaci instruction

	xpaci	x0
	xpaci	xzr

positive: xpaclri instruction

	xpaclri

positive: yield instruction

	yield

# advanced SIMD and floating-point instructions

positive: abs instruction

	abs	d0, d0
	abs	d31, d31
	abs	v0.8b, v0.8b
	abs	v31.8b, v31.8b
	abs	v0.16b, v0.16b
	abs	v31.16b, v31.16b
	abs	v0.4h, v0.4h
	abs	v31.4h, v31.4h
	abs	v0.8h, v0.8h
	abs	v31.8h, v31.8h
	abs	v0.2s, v0.2s
	abs	v31.2s, v31.2s
	abs	v0.4s, v0.4s
	abs	v31.4s, v31.4s
	abs	v0.2d, v0.2d
	abs	v31.2d, v31.2d

positive: addhn instruction

	addhn	v0.8b, v0.8h, v0.8h
	addhn	v31.8b, v31.8h, v31.8h
	addhn	v0.4h, v0.4s, v0.4s
	addhn	v31.4h, v31.4s, v31.4s
	addhn	v0.2s, v0.2d, v0.2d
	addhn	v31.2s, v31.2d, v31.2d

positive: addhn2 instruction

	addhn2	v0.16b, v0.8h, v0.8h
	addhn2	v31.16b, v31.8h, v31.8h
	addhn2	v0.8h, v0.4s, v0.4s
	addhn2	v31.8h, v31.4s, v31.4s
	addhn2	v0.4s, v0.2d, v0.2d
	addhn2	v31.4s, v31.2d, v31.2d

positive: addp instruction

	addp	d0, v0.2d
	addp	d31, v31.2d
	addp	v0.8b, v0.8b, v0.8b
	addp	v31.8b, v31.8b, v31.8b
	addp	v0.16b, v0.16b, v0.16b
	addp	v31.16b, v31.16b, v31.16b
	addp	v0.4h, v0.4h, v0.4h
	addp	v31.4h, v31.4h, v31.4h
	addp	v0.8h, v0.8h, v0.8h
	addp	v31.8h, v31.8h, v31.8h
	addp	v0.2s, v0.2s, v0.2s
	addp	v31.2s, v31.2s, v31.2s
	addp	v0.4s, v0.4s, v0.4s
	addp	v31.4s, v31.4s, v31.4s
	addp	v0.2d, v0.2d, v0.2d
	addp	v31.2d, v31.2d, v31.2d

positive: addv instruction

	addv	b0, v0.8b
	addv	b31, v31.8b
	addv	h0, v0.4h
	addv	h31, v31.4h
	addv	b0, v0.16b
	addv	b31, v31.16b
	addv	h0, v0.8h
	addv	h31, v31.8h
	addv	s0, v0.4s
	addv	s31, v31.4s

positive: aesd instruction

	aesd	v0.16b, v0.16b
	aesd	v0.16b, v31.16b

positive: aese instruction

	aese	v0.16b, v0.16b
	aese	v0.16b, v31.16b

positive: aesimc instruction

	aesimc	v0.16b, v0.16b
	aesimc	v0.16b, v31.16b

positive: aesmc instruction

	aesmc	v0.16b, v0.16b
	aesmc	v0.16b, v31.16b

positive: bcax instruction

	bcax	v0.16b, v0.16b, v0.16b, v0.16b
	bcax	v31.16b, v31.16b, v31.16b, v31.16b

positive: bif instruction

	bif	v0.8b, v0.8b, v0.8b
	bif	v31.8b, v31.8b, v31.8b
	bif	v0.16b, v0.16b, v0.16b
	bif	v31.16b, v31.16b, v31.16b

positive: bit instruction

	bit	v0.8b, v0.8b, v0.8b
	bit	v31.8b, v31.8b, v31.8b
	bit	v0.16b, v0.16b, v0.16b
	bit	v31.16b, v31.16b, v31.16b

positive: bsl instruction

	bsl	v0.8b, v0.8b, v0.8b
	bsl	v31.8b, v31.8b, v31.8b
	bsl	v0.16b, v0.16b, v0.16b
	bsl	v31.16b, v31.16b, v31.16b

positive: cmeq instruction

	cmeq	d0, d0, d0
	cmeq	d31, d31, d31
	cmeq	v0.8b, v0.8b, v0.8b
	cmeq	v31.8b, v31.8b, v31.8b
	cmeq	v0.16b, v0.16b, v0.16b
	cmeq	v31.16b, v31.16b, v31.16b
	cmeq	v0.4h, v0.4h, v0.4h
	cmeq	v31.4h, v31.4h, v31.4h
	cmeq	v0.8h, v0.8h, v0.8h
	cmeq	v31.8h, v31.8h, v31.8h
	cmeq	v0.2s, v0.2s, v0.2s
	cmeq	v31.2s, v31.2s, v31.2s
	cmeq	v0.4s, v0.4s, v0.4s
	cmeq	v31.4s, v31.4s, v31.4s
	cmeq	v0.2d, v0.2d, v0.2d
	cmeq	v31.2d, v31.2d, v31.2d
	cmeq	d0, d0, 0
	cmeq	d31, d31, 0
	cmeq	v0.8b, v0.8b, 0
	cmeq	v31.8b, v31.8b, 0
	cmeq	v0.16b, v0.16b, 0
	cmeq	v31.16b, v31.16b, 0
	cmeq	v0.4h, v0.4h, 0
	cmeq	v31.4h, v31.4h, 0
	cmeq	v0.8h, v0.8h, 0
	cmeq	v31.8h, v31.8h, 0
	cmeq	v0.2s, v0.2s, 0
	cmeq	v31.2s, v31.2s, 0
	cmeq	v0.4s, v0.4s, 0
	cmeq	v31.4s, v31.4s, 0
	cmeq	v0.2d, v0.2d, 0
	cmeq	v31.2d, v31.2d, 0

positive: cmge instruction

	cmge	d0, d0, d0
	cmge	d31, d31, d31
	cmge	v0.8b, v0.8b, v0.8b
	cmge	v31.8b, v31.8b, v31.8b
	cmge	v0.16b, v0.16b, v0.16b
	cmge	v31.16b, v31.16b, v31.16b
	cmge	v0.4h, v0.4h, v0.4h
	cmge	v31.4h, v31.4h, v31.4h
	cmge	v0.8h, v0.8h, v0.8h
	cmge	v31.8h, v31.8h, v31.8h
	cmge	v0.2s, v0.2s, v0.2s
	cmge	v31.2s, v31.2s, v31.2s
	cmge	v0.4s, v0.4s, v0.4s
	cmge	v31.4s, v31.4s, v31.4s
	cmge	v0.2d, v0.2d, v0.2d
	cmge	v31.2d, v31.2d, v31.2d
	cmge	d0, d0, 0
	cmge	d31, d31, 0
	cmge	v0.8b, v0.8b, 0
	cmge	v31.8b, v31.8b, 0
	cmge	v0.16b, v0.16b, 0
	cmge	v31.16b, v31.16b, 0
	cmge	v0.4h, v0.4h, 0
	cmge	v31.4h, v31.4h, 0
	cmge	v0.8h, v0.8h, 0
	cmge	v31.8h, v31.8h, 0
	cmge	v0.2s, v0.2s, 0
	cmge	v31.2s, v31.2s, 0
	cmge	v0.4s, v0.4s, 0
	cmge	v31.4s, v31.4s, 0
	cmge	v0.2d, v0.2d, 0
	cmge	v31.2d, v31.2d, 0

positive: cmgt instruction

	cmgt	d0, d0, d0
	cmgt	d31, d31, d31
	cmgt	v0.8b, v0.8b, v0.8b
	cmgt	v31.8b, v31.8b, v31.8b
	cmgt	v0.16b, v0.16b, v0.16b
	cmgt	v31.16b, v31.16b, v31.16b
	cmgt	v0.4h, v0.4h, v0.4h
	cmgt	v31.4h, v31.4h, v31.4h
	cmgt	v0.8h, v0.8h, v0.8h
	cmgt	v31.8h, v31.8h, v31.8h
	cmgt	v0.2s, v0.2s, v0.2s
	cmgt	v31.2s, v31.2s, v31.2s
	cmgt	v0.4s, v0.4s, v0.4s
	cmgt	v31.4s, v31.4s, v31.4s
	cmgt	v0.2d, v0.2d, v0.2d
	cmgt	v31.2d, v31.2d, v31.2d
	cmgt	d0, d0, 0
	cmgt	d31, d31, 0
	cmgt	v0.8b, v0.8b, 0
	cmgt	v31.8b, v31.8b, 0
	cmgt	v0.16b, v0.16b, 0
	cmgt	v31.16b, v31.16b, 0
	cmgt	v0.4h, v0.4h, 0
	cmgt	v31.4h, v31.4h, 0
	cmgt	v0.8h, v0.8h, 0
	cmgt	v31.8h, v31.8h, 0
	cmgt	v0.2s, v0.2s, 0
	cmgt	v31.2s, v31.2s, 0
	cmgt	v0.4s, v0.4s, 0
	cmgt	v31.4s, v31.4s, 0
	cmgt	v0.2d, v0.2d, 0
	cmgt	v31.2d, v31.2d, 0

positive: cmhi instruction

	cmhi	d0, d0, d0
	cmhi	d31, d31, d31
	cmhi	v0.8b, v0.8b, v0.8b
	cmhi	v31.8b, v31.8b, v31.8b
	cmhi	v0.16b, v0.16b, v0.16b
	cmhi	v31.16b, v31.16b, v31.16b
	cmhi	v0.4h, v0.4h, v0.4h
	cmhi	v31.4h, v31.4h, v31.4h
	cmhi	v0.8h, v0.8h, v0.8h
	cmhi	v31.8h, v31.8h, v31.8h
	cmhi	v0.2s, v0.2s, v0.2s
	cmhi	v31.2s, v31.2s, v31.2s
	cmhi	v0.4s, v0.4s, v0.4s
	cmhi	v31.4s, v31.4s, v31.4s
	cmhi	v0.2d, v0.2d, v0.2d
	cmhi	v31.2d, v31.2d, v31.2d

positive: cmhs instruction

	cmhs	d0, d0, d0
	cmhs	d31, d31, d31
	cmhs	v0.8b, v0.8b, v0.8b
	cmhs	v31.8b, v31.8b, v31.8b
	cmhs	v0.16b, v0.16b, v0.16b
	cmhs	v31.16b, v31.16b, v31.16b
	cmhs	v0.4h, v0.4h, v0.4h
	cmhs	v31.4h, v31.4h, v31.4h
	cmhs	v0.8h, v0.8h, v0.8h
	cmhs	v31.8h, v31.8h, v31.8h
	cmhs	v0.2s, v0.2s, v0.2s
	cmhs	v31.2s, v31.2s, v31.2s
	cmhs	v0.4s, v0.4s, v0.4s
	cmhs	v31.4s, v31.4s, v31.4s
	cmhs	v0.2d, v0.2d, v0.2d
	cmhs	v31.2d, v31.2d, v31.2d

positive: cmle instruction

	cmle	d0, d0, 0
	cmle	d31, d31, 0
	cmle	v0.8b, v0.8b, 0
	cmle	v31.8b, v31.8b, 0
	cmle	v0.16b, v0.16b, 0
	cmle	v31.16b, v31.16b, 0
	cmle	v0.4h, v0.4h, 0
	cmle	v31.4h, v31.4h, 0
	cmle	v0.8h, v0.8h, 0
	cmle	v31.8h, v31.8h, 0
	cmle	v0.2s, v0.2s, 0
	cmle	v31.2s, v31.2s, 0
	cmle	v0.4s, v0.4s, 0
	cmle	v31.4s, v31.4s, 0
	cmle	v0.2d, v0.2d, 0
	cmle	v31.2d, v31.2d, 0

positive: cmlt instruction

	cmlt	d0, d0, 0
	cmlt	d31, d31, 0
	cmlt	v0.8b, v0.8b, 0
	cmlt	v31.8b, v31.8b, 0
	cmlt	v0.16b, v0.16b, 0
	cmlt	v31.16b, v31.16b, 0
	cmlt	v0.4h, v0.4h, 0
	cmlt	v31.4h, v31.4h, 0
	cmlt	v0.8h, v0.8h, 0
	cmlt	v31.8h, v31.8h, 0
	cmlt	v0.2s, v0.2s, 0
	cmlt	v31.2s, v31.2s, 0
	cmlt	v0.4s, v0.4s, 0
	cmlt	v31.4s, v31.4s, 0
	cmlt	v0.2d, v0.2d, 0
	cmlt	v31.2d, v31.2d, 0

positive: cmtst instruction

	cmtst	d0, d0, d0
	cmtst	d31, d31, d31
	cmtst	v0.8b, v0.8b, v0.8b
	cmtst	v31.8b, v31.8b, v31.8b
	cmtst	v0.16b, v0.16b, v0.16b
	cmtst	v31.16b, v31.16b, v31.16b
	cmtst	v0.4h, v0.4h, v0.4h
	cmtst	v31.4h, v31.4h, v31.4h
	cmtst	v0.8h, v0.8h, v0.8h
	cmtst	v31.8h, v31.8h, v31.8h
	cmtst	v0.2s, v0.2s, v0.2s
	cmtst	v31.2s, v31.2s, v31.2s
	cmtst	v0.4s, v0.4s, v0.4s
	cmtst	v31.4s, v31.4s, v31.4s
	cmtst	v0.2d, v0.2d, v0.2d
	cmtst	v31.2d, v31.2d, v31.2d

positive: cnt instruction

	cnt	v0.8b, v0.8b
	cnt	v31.8b, v31.8b
	cnt	v0.16b, v0.16b
	cnt	v31.16b, v31.16b

positive: dup instruction

	dup	b0, v0.b[0]
	dup	b31, v31.b[15]
	dup	h0, v0.h[0]
	dup	h31, v31.h[7]
	dup	s0, v0.s[0]
	dup	s31, v31.s[3]
	dup	d0, v0.d[0]
	dup	d31, v31.d[1]
	dup	v0.8b, v0.b[0]
	dup	v31.8b, v31.b[15]
	dup	v0.16b, v0.b[0]
	dup	v31.16b, v31.b[15]
	dup	v0.4h, v0.h[0]
	dup	v31.4h, v31.h[7]
	dup	v0.8h, v0.h[0]
	dup	v31.8h, v31.h[7]
	dup	v0.2s, v0.s[0]
	dup	v31.2s, v31.s[3]
	dup	v0.4s, v0.s[0]
	dup	v31.4s, v31.s[3]
	dup	v0.2d, v0.d[0]
	dup	v31.2d, v31.d[1]

positive: eor3 instruction

	eor3	v0.16b, v0.16b, v0.16b, v0.16b
	eor3	v31.16b, v31.16b, v31.16b, v0.16b

positive: ext instruction

	ext	v0.8b, v0.8b, v0.8b, 0
	ext	v31.8b, v31.8b, v31.8b, 7
	ext	v0.16b, v0.16b, v0.16b, 0
	ext	v31.16b, v31.16b, v31.16b, 15

positive: fabd instruction

	fabd	h0, h0, h0
	fabd	h31, h31, h31
	fabd	s0, s0, s0
	fabd	s31, s31, s31
	fabd	d0, d0, d0
	fabd	d31, d31, d31
	fabd	v0.4h, v0.4h, v0.4h
	fabd	v31.4h, v31.4h, v31.4h
	fabd	v0.8h, v0.8h, v0.8h
	fabd	v31.8h, v31.8h, v31.8h
	fabd	v0.2s, v0.2s, v0.2s
	fabd	v31.2s, v31.2s, v31.2s
	fabd	v0.4s, v0.4s, v0.4s
	fabd	v31.4s, v31.4s, v31.4s
	fabd	v0.2d, v0.2d, v0.2d
	fabd	v31.2d, v31.2d, v31.2d

positive: fabs instruction

	fabs	v0.4h, v0.4h
	fabs	v31.4h, v31.4h
	fabs	v0.8h, v0.8h
	fabs	v31.8h, v31.8h
	fabs	v0.2s, v0.2s
	fabs	v31.2s, v31.2s
	fabs	v0.4s, v0.4s
	fabs	v31.4s, v31.4s
	fabs	v0.2d, v0.2d
	fabs	v31.2d, v31.2d
	fabs	h0, h0
	fabs	h31, h31
	fabs	s0, s0
	fabs	s31, s31
	fabs	d0, d0
	fabs	d31, d31

positive: facge instruction

	facge	h0, h0, h0
	facge	h31, h31, h31
	facge	s0, s0, s0
	facge	s31, s31, s31
	facge	d0, d0, d0
	facge	d31, d31, d31
	facge	v0.4h, v0.4h, v0.4h
	facge	v31.4h, v31.4h, v31.4h
	facge	v0.8h, v0.8h, v0.8h
	facge	v31.8h, v31.8h, v31.8h
	facge	v0.2s, v0.2s, v0.2s
	facge	v31.2s, v31.2s, v31.2s
	facge	v0.4s, v0.4s, v0.4s
	facge	v31.4s, v31.4s, v31.4s
	facge	v0.2d, v0.2d, v0.2d
	facge	v31.2d, v31.2d, v31.2d

positive: facgt instruction

	facgt	h0, h0, h0
	facgt	h31, h31, h31
	facgt	s0, s0, s0
	facgt	s31, s31, s31
	facgt	d0, d0, d0
	facgt	d31, d31, d31
	facgt	v0.4h, v0.4h, v0.4h
	facgt	v31.4h, v31.4h, v31.4h
	facgt	v0.8h, v0.8h, v0.8h
	facgt	v31.8h, v31.8h, v31.8h
	facgt	v0.2s, v0.2s, v0.2s
	facgt	v31.2s, v31.2s, v31.2s
	facgt	v0.4s, v0.4s, v0.4s
	facgt	v31.4s, v31.4s, v31.4s
	facgt	v0.2d, v0.2d, v0.2d
	facgt	v31.2d, v31.2d, v31.2d

positive: fadd instruction

	fadd	v0.4h, v0.4h, v0.4h
	fadd	v31.4h, v31.4h, v31.4h
	fadd	v0.8h, v0.8h, v0.8h
	fadd	v31.8h, v31.8h, v31.8h
	fadd	v0.2s, v0.2s, v0.2s
	fadd	v31.2s, v31.2s, v31.2s
	fadd	v0.4s, v0.4s, v0.4s
	fadd	v31.4s, v31.4s, v31.4s
	fadd	v0.2d, v0.2d, v0.2d
	fadd	v31.2d, v31.2d, v31.2d
	fadd	h0, h0, h0
	fadd	h31, h31, h31
	fadd	s0, s0, s0
	fadd	s31, s31, s31
	fadd	d0, d0, d0
	fadd	d31, d31, d31

positive: faddp instruction

	faddp	h0, v0.2h
	faddp	h31, v31.2h
	faddp	s0, v0.2s
	faddp	s31, v31.2s
	faddp	d0, v0.2d
	faddp	d31, v31.2d
	faddp	v0.4h, v0.4h, v0.4h
	faddp	v31.4h, v31.4h, v31.4h
	faddp	v0.2s, v0.2s, v0.2s
	faddp	v31.2s, v31.2s, v31.2s
	faddp	v0.4s, v0.4s, v0.4s
	faddp	v31.4s, v31.4s, v31.4s
	faddp	v0.2d, v0.2d, v0.2d
	faddp	v31.2d, v31.2d, v31.2d

positive: fcadd instruction

	fcadd	v0.4h, v0.4h, v0.4h, 90
	fcadd	v31.4h, v31.4h, v31.4h, 270
	fcadd	v0.2s, v0.2s, v0.2s, 90
	fcadd	v31.2s, v31.2s, v31.2s, 270
	fcadd	v0.8h, v0.8h, v0.8h, 90
	fcadd	v31.8h, v31.8h, v31.8h, 270
	fcadd	v0.4s, v0.4s, v0.4s, 90
	fcadd	v31.4s, v31.4s, v31.4s, 270
	fcadd	v0.2d, v0.2d, v0.2d, 90
	fcadd	v31.2d, v31.2d, v31.2d, 270

positive: fccmp instruction

	fccmp	h0, h0, 0, eq
	fccmp	h31, h31, 15, nv
	fccmp	s0, s0, 0, eq
	fccmp	s31, s31, 15, nv
	fccmp	d0, d0, 0, eq
	fccmp	d31, d31, 15, nv

positive: fccmpe instruction

	fccmpe	h0, h0, 0, eq
	fccmpe	h31, h31, 15, nv
	fccmpe	s0, s0, 0, eq
	fccmpe	s31, s31, 15, nv
	fccmpe	d0, d0, 0, eq
	fccmpe	d31, d31, 15, nv

positive: fcmeq instruction

	fcmeq	h0, h0, h0
	fcmeq	h31, h31, h31
	fcmeq	s0, s0, s0
	fcmeq	s31, s31, s31
	fcmeq	d0, d0, d0
	fcmeq	d31, d31, d31
	fcmeq	v0.4h, v0.4h, v0.4h
	fcmeq	v31.4h, v31.4h, v31.4h
	fcmeq	v0.8h, v0.8h, v0.8h
	fcmeq	v31.8h, v31.8h, v31.8h
	fcmeq	v0.2s, v0.2s, v0.2s
	fcmeq	v31.2s, v31.2s, v31.2s
	fcmeq	v0.4s, v0.4s, v0.4s
	fcmeq	v31.4s, v31.4s, v31.4s
	fcmeq	v0.2d, v0.2d, v0.2d
	fcmeq	v31.2d, v31.2d, v31.2d
	fcmeq	h0, h0, 0.0
	fcmeq	h31, h31, 0.0
	fcmeq	s0, s0, 0.0
	fcmeq	s31, s31, 0.0
	fcmeq	d0, d0, 0.0
	fcmeq	d31, d31, 0.0
	fcmeq	v0.4h, v0.4h, 0.0
	fcmeq	v31.4h, v31.4h, 0.0
	fcmeq	v0.8h, v0.8h, 0.0
	fcmeq	v31.8h, v31.8h, 0.0
	fcmeq	v0.2s, v0.2s, 0.0
	fcmeq	v31.2s, v31.2s, 0.0
	fcmeq	v0.4s, v0.4s, 0.0
	fcmeq	v31.4s, v31.4s, 0.0
	fcmeq	v0.2d, v0.2d, 0.0
	fcmeq	v31.2d, v31.2d, 0.0

positive: fcmge instruction

	fcmge	h0, h0, h0
	fcmge	h31, h31, h31
	fcmge	s0, s0, s0
	fcmge	s31, s31, s31
	fcmge	d0, d0, d0
	fcmge	d31, d31, d31
	fcmge	v0.4h, v0.4h, v0.4h
	fcmge	v31.4h, v31.4h, v31.4h
	fcmge	v0.8h, v0.8h, v0.8h
	fcmge	v31.8h, v31.8h, v31.8h
	fcmge	v0.2s, v0.2s, v0.2s
	fcmge	v31.2s, v31.2s, v31.2s
	fcmge	v0.4s, v0.4s, v0.4s
	fcmge	v31.4s, v31.4s, v31.4s
	fcmge	v0.2d, v0.2d, v0.2d
	fcmge	v31.2d, v31.2d, v31.2d
	fcmge	h0, h0, 0.0
	fcmge	h31, h31, 0.0
	fcmge	s0, s0, 0.0
	fcmge	s31, s31, 0.0
	fcmge	d0, d0, 0.0
	fcmge	d31, d31, 0.0
	fcmge	v0.4h, v0.4h, 0.0
	fcmge	v31.4h, v31.4h, 0.0
	fcmge	v0.8h, v0.8h, 0.0
	fcmge	v31.8h, v31.8h, 0.0
	fcmge	v0.2s, v0.2s, 0.0
	fcmge	v31.2s, v31.2s, 0.0
	fcmge	v0.4s, v0.4s, 0.0
	fcmge	v31.4s, v31.4s, 0.0
	fcmge	v0.2d, v0.2d, 0.0
	fcmge	v31.2d, v31.2d, 0.0

positive: fcmgt instruction

	fcmgt	h0, h0, h0
	fcmgt	h31, h31, h31
	fcmgt	s0, s0, s0
	fcmgt	s31, s31, s31
	fcmgt	d0, d0, d0
	fcmgt	d31, d31, d31
	fcmgt	v0.4h, v0.4h, v0.4h
	fcmgt	v31.4h, v31.4h, v31.4h
	fcmgt	v0.8h, v0.8h, v0.8h
	fcmgt	v31.8h, v31.8h, v31.8h
	fcmgt	v0.2s, v0.2s, v0.2s
	fcmgt	v31.2s, v31.2s, v31.2s
	fcmgt	v0.4s, v0.4s, v0.4s
	fcmgt	v31.4s, v31.4s, v31.4s
	fcmgt	v0.2d, v0.2d, v0.2d
	fcmgt	v31.2d, v31.2d, v31.2d
	fcmgt	h0, h0, 0.0
	fcmgt	h31, h31, 0.0
	fcmgt	s0, s0, 0.0
	fcmgt	s31, s31, 0.0
	fcmgt	d0, d0, 0.0
	fcmgt	d31, d31, 0.0
	fcmgt	v0.4h, v0.4h, 0.0
	fcmgt	v31.4h, v31.4h, 0.0
	fcmgt	v0.8h, v0.8h, 0.0
	fcmgt	v31.8h, v31.8h, 0.0
	fcmgt	v0.2s, v0.2s, 0.0
	fcmgt	v31.2s, v31.2s, 0.0
	fcmgt	v0.4s, v0.4s, 0.0
	fcmgt	v31.4s, v31.4s, 0.0
	fcmgt	v0.2d, v0.2d, 0.0
	fcmgt	v31.2d, v31.2d, 0.0

positive: fcmla instruction

	fcmla	v0.4h, v0.4h, v0.h[0], 0
	fcmla	v31.4h, v31.4h, v31.h[1], 270
	fcmla	v0.8h, v0.8h, v0.h[0], 0
	fcmla	v31.8h, v31.8h, v31.h[3], 270
	fcmla	v0.4s, v0.4s, v0.s[0], 0
	fcmla	v31.4s, v31.4s, v31.s[1], 270
	fcmla	v0.4h, v0.4h, v0.4h, 0
	fcmla	v31.4h, v31.4h, v31.4h, 270
	fcmla	v0.8h, v0.8h, v0.8h, 0
	fcmla	v31.8h, v31.8h, v31.8h, 270
	fcmla	v0.2s, v0.2s, v0.2s, 0
	fcmla	v31.2s, v31.2s, v31.2s, 270
	fcmla	v0.4s, v0.4s, v0.4s, 0
	fcmla	v31.4s, v31.4s, v31.4s, 270
	fcmla	v0.2d, v0.2d, v0.2d, 0
	fcmla	v31.2d, v31.2d, v31.2d, 270

positive: fcmle instruction

	fcmle	h0, h0, 0.0
	fcmle	h31, h31, 0.0
	fcmle	s0, s0, 0.0
	fcmle	s31, s31, 0.0
	fcmle	d0, d0, 0.0
	fcmle	d31, d31, 0.0
	fcmle	v0.4h, v0.4h, 0.0
	fcmle	v31.4h, v31.4h, 0.0
	fcmle	v0.8h, v0.8h, 0.0
	fcmle	v31.8h, v31.8h, 0.0
	fcmle	v0.2s, v0.2s, 0.0
	fcmle	v31.2s, v31.2s, 0.0
	fcmle	v0.4s, v0.4s, 0.0
	fcmle	v31.4s, v31.4s, 0.0
	fcmle	v0.2d, v0.2d, 0.0
	fcmle	v31.2d, v31.2d, 0.0

positive: fcmlt instruction

	fcmlt	h0, h0, 0.0
	fcmlt	h31, h31, 0.0
	fcmlt	s0, s0, 0.0
	fcmlt	s31, s31, 0.0
	fcmlt	d0, d0, 0.0
	fcmlt	d31, d31, 0.0
	fcmlt	v0.4h, v0.4h, 0.0
	fcmlt	v31.4h, v31.4h, 0.0
	fcmlt	v0.8h, v0.8h, 0.0
	fcmlt	v31.8h, v31.8h, 0.0
	fcmlt	v0.2s, v0.2s, 0.0
	fcmlt	v31.2s, v31.2s, 0.0
	fcmlt	v0.4s, v0.4s, 0.0
	fcmlt	v31.4s, v31.4s, 0.0
	fcmlt	v0.2d, v0.2d, 0.0
	fcmlt	v31.2d, v31.2d, 0.0

positive: fcmp instruction

	fcmp	h0, h0
	fcmp	h31, h31
	fcmp	h0, 0.0
	fcmp	h31, 0.0
	fcmp	s0, s0
	fcmp	s31, s31
	fcmp	s0, 0.0
	fcmp	s31, 0.0
	fcmp	d0, d0
	fcmp	d31, d31
	fcmp	d0, 0.0
	fcmp	d31, 0.0

positive: fcmpe instruction

	fcmpe	h0, h0
	fcmpe	h31, h31
	fcmpe	h0, 0.0
	fcmpe	h31, 0.0
	fcmpe	s0, s0
	fcmpe	s31, s31
	fcmpe	s0, 0.0
	fcmpe	s31, 0.0
	fcmpe	d0, d0
	fcmpe	d31, d31
	fcmpe	d0, 0.0
	fcmpe	d31, 0.0

positive: fcsel instruction

	fcsel	h0, h0, h0, eq
	fcsel	h31, h31, h31, nv
	fcsel	s0, s0, s0, eq
	fcsel	s31, s31, s31, nv
	fcsel	d0, d0, d0, eq
	fcsel	d31, d31, d31, nv

positive: fcvt instruction

	fcvt	s0, h0
	fcvt	s31, h31
	fcvt	d0, h0
	fcvt	d31, h31
	fcvt	h0, s0
	fcvt	h31, s31
	fcvt	d0, s0
	fcvt	d31, s31
	fcvt	h0, d0
	fcvt	h31, d31
	fcvt	s0, d0
	fcvt	s31, d31

positive: fcvtas instruction

	fcvtas	h0, h0
	fcvtas	h31, h31
	fcvtas	s0, s0
	fcvtas	s31, s31
	fcvtas	d0, d0
	fcvtas	d31, d31
	fcvtas	v0.4h, v0.4h
	fcvtas	v31.4h, v31.4h
	fcvtas	v0.8h, v0.8h
	fcvtas	v31.8h, v31.8h
	fcvtas	v0.2s, v0.2s
	fcvtas	v31.2s, v31.2s
	fcvtas	v0.4s, v0.4s
	fcvtas	v31.4s, v31.4s
	fcvtas	v0.2d, v0.2d
	fcvtas	v31.2d, v31.2d
	fcvtas	w0, h0
	fcvtas	wzr, h31
	fcvtas	x0, h0
	fcvtas	xzr, h31
	fcvtas	w0, s0
	fcvtas	wzr, s31
	fcvtas	x0, s0
	fcvtas	xzr, s31
	fcvtas	w0, d0
	fcvtas	wzr, d31
	fcvtas	x0, d0
	fcvtas	xzr, d31

positive: fcvtau instruction

	fcvtau	h0, h0
	fcvtau	h31, h31
	fcvtau	s0, s0
	fcvtau	s31, s31
	fcvtau	d0, d0
	fcvtau	d31, d31
	fcvtau	v0.4h, v0.4h
	fcvtau	v31.4h, v31.4h
	fcvtau	v0.8h, v0.8h
	fcvtau	v31.8h, v31.8h
	fcvtau	v0.2s, v0.2s
	fcvtau	v31.2s, v31.2s
	fcvtau	v0.4s, v0.4s
	fcvtau	v31.4s, v31.4s
	fcvtau	v0.2d, v0.2d
	fcvtau	v31.2d, v31.2d
	fcvtau	w0, h0
	fcvtau	wzr, h31
	fcvtau	x0, h0
	fcvtau	xzr, h31
	fcvtau	w0, s0
	fcvtau	wzr, s31
	fcvtau	x0, s0
	fcvtau	xzr, s31
	fcvtau	w0, d0
	fcvtau	wzr, d31
	fcvtau	x0, d0
	fcvtau	xzr, d31

positive: fcvtl instruction

	fcvtl	v0.4s, v0.4h
	fcvtl	v31.4s, v31.4h
	fcvtl	v0.2d, v0.2s
	fcvtl	v31.2d, v31.2s

positive: fcvtl2 instruction

	fcvtl2	v0.4s, v0.8h
	fcvtl2	v31.4s, v31.8h
	fcvtl2	v0.2d, v0.4s
	fcvtl2	v31.2d, v31.4s

positive: fcvtms instruction

	fcvtms	h0, h0
	fcvtms	h31, h31
	fcvtms	s0, s0
	fcvtms	s31, s31
	fcvtms	d0, d0
	fcvtms	d31, d31
	fcvtms	v0.4h, v0.4h
	fcvtms	v31.4h, v31.4h
	fcvtms	v0.8h, v0.8h
	fcvtms	v31.8h, v31.8h
	fcvtms	v0.2s, v0.2s
	fcvtms	v31.2s, v31.2s
	fcvtms	v0.4s, v0.4s
	fcvtms	v31.4s, v31.4s
	fcvtms	v0.2d, v0.2d
	fcvtms	v31.2d, v31.2d
	fcvtms	w0, h0
	fcvtms	wzr, h31
	fcvtms	x0, h0
	fcvtms	xzr, h31
	fcvtms	w0, s0
	fcvtms	wzr, s31
	fcvtms	x0, s0
	fcvtms	xzr, s31
	fcvtms	w0, d0
	fcvtms	wzr, d31
	fcvtms	x0, d0
	fcvtms	xzr, d31

positive: fcvtmu instruction

	fcvtmu	h0, h0
	fcvtmu	h31, h31
	fcvtmu	s0, s0
	fcvtmu	s31, s31
	fcvtmu	d0, d0
	fcvtmu	d31, d31
	fcvtmu	v0.4h, v0.4h
	fcvtmu	v31.4h, v31.4h
	fcvtmu	v0.8h, v0.8h
	fcvtmu	v31.8h, v31.8h
	fcvtmu	v0.2s, v0.2s
	fcvtmu	v31.2s, v31.2s
	fcvtmu	v0.4s, v0.4s
	fcvtmu	v31.4s, v31.4s
	fcvtmu	v0.2d, v0.2d
	fcvtmu	v31.2d, v31.2d
	fcvtmu	w0, h0
	fcvtmu	wzr, h31
	fcvtmu	x0, h0
	fcvtmu	xzr, h31
	fcvtmu	w0, s0
	fcvtmu	wzr, s31
	fcvtmu	x0, s0
	fcvtmu	xzr, s31
	fcvtmu	w0, d0
	fcvtmu	wzr, d31
	fcvtmu	x0, d0
	fcvtmu	xzr, d31

positive: fcvtn instruction

	fcvtn	v0.4h, v0.4s
	fcvtn	v31.4h, v31.4s
	fcvtn	v0.2s, v0.2d
	fcvtn	v31.2s, v31.2d

positive: fcvtn2 instruction

	fcvtn2	v0.8h, v0.4s
	fcvtn2	v31.8h, v31.4s
	fcvtn2	v0.4s, v0.2d
	fcvtn2	v31.4s, v31.2d

positive: fcvtns instruction

	fcvtns	h0, h0
	fcvtns	h31, h31
	fcvtns	s0, s0
	fcvtns	s31, s31
	fcvtns	d0, d0
	fcvtns	d31, d31
	fcvtns	v0.4h, v0.4h
	fcvtns	v31.4h, v31.4h
	fcvtns	v0.8h, v0.8h
	fcvtns	v31.8h, v31.8h
	fcvtns	v0.2s, v0.2s
	fcvtns	v31.2s, v31.2s
	fcvtns	v0.4s, v0.4s
	fcvtns	v31.4s, v31.4s
	fcvtns	v0.2d, v0.2d
	fcvtns	v31.2d, v31.2d
	fcvtns	w0, h0
	fcvtns	wzr, h31
	fcvtns	x0, h0
	fcvtns	xzr, h31
	fcvtns	w0, s0
	fcvtns	wzr, s31
	fcvtns	x0, s0
	fcvtns	xzr, s31
	fcvtns	w0, d0
	fcvtns	wzr, d31
	fcvtns	x0, d0
	fcvtns	xzr, d31

positive: fcvtnu instruction

	fcvtnu	h0, h0
	fcvtnu	h31, h31
	fcvtnu	s0, s0
	fcvtnu	s31, s31
	fcvtnu	d0, d0
	fcvtnu	d31, d31
	fcvtnu	v0.4h, v0.4h
	fcvtnu	v31.4h, v31.4h
	fcvtnu	v0.8h, v0.8h
	fcvtnu	v31.8h, v31.8h
	fcvtnu	v0.2s, v0.2s
	fcvtnu	v31.2s, v31.2s
	fcvtnu	v0.4s, v0.4s
	fcvtnu	v31.4s, v31.4s
	fcvtnu	v0.2d, v0.2d
	fcvtnu	v31.2d, v31.2d
	fcvtnu	w0, h0
	fcvtnu	wzr, h31
	fcvtnu	x0, h0
	fcvtnu	xzr, h31
	fcvtnu	w0, s0
	fcvtnu	wzr, s31
	fcvtnu	x0, s0
	fcvtnu	xzr, s31
	fcvtnu	w0, d0
	fcvtnu	wzr, d31
	fcvtnu	x0, d0
	fcvtnu	xzr, d31

positive: fcvtps instruction

	fcvtps	h0, h0
	fcvtps	h31, h31
	fcvtps	s0, s0
	fcvtps	s31, s31
	fcvtps	d0, d0
	fcvtps	d31, d31
	fcvtps	v0.4h, v0.4h
	fcvtps	v31.4h, v31.4h
	fcvtps	v0.8h, v0.8h
	fcvtps	v31.8h, v31.8h
	fcvtps	v0.2s, v0.2s
	fcvtps	v31.2s, v31.2s
	fcvtps	v0.4s, v0.4s
	fcvtps	v31.4s, v31.4s
	fcvtps	v0.2d, v0.2d
	fcvtps	v31.2d, v31.2d
	fcvtps	w0, h0
	fcvtps	wzr, h31
	fcvtps	x0, h0
	fcvtps	xzr, h31
	fcvtps	w0, s0
	fcvtps	wzr, s31
	fcvtps	x0, s0
	fcvtps	xzr, s31
	fcvtps	w0, d0
	fcvtps	wzr, d31
	fcvtps	x0, d0
	fcvtps	xzr, d31

positive: fcvtpu instruction

	fcvtpu	h0, h0
	fcvtpu	h31, h31
	fcvtpu	s0, s0
	fcvtpu	s31, s31
	fcvtpu	d0, d0
	fcvtpu	d31, d31
	fcvtpu	v0.4h, v0.4h
	fcvtpu	v31.4h, v31.4h
	fcvtpu	v0.8h, v0.8h
	fcvtpu	v31.8h, v31.8h
	fcvtpu	v0.2s, v0.2s
	fcvtpu	v31.2s, v31.2s
	fcvtpu	v0.4s, v0.4s
	fcvtpu	v31.4s, v31.4s
	fcvtpu	v0.2d, v0.2d
	fcvtpu	v31.2d, v31.2d
	fcvtpu	w0, h0
	fcvtpu	wzr, h31
	fcvtpu	x0, h0
	fcvtpu	xzr, h31
	fcvtpu	w0, s0
	fcvtpu	wzr, s31
	fcvtpu	x0, s0
	fcvtpu	xzr, s31
	fcvtpu	w0, d0
	fcvtpu	wzr, d31
	fcvtpu	x0, d0
	fcvtpu	xzr, d31

positive: fcvtxn instruction

	fcvtxn	s0, d0
	fcvtxn	s31, d31
	fcvtxn	v0.2s, v0.2d
	fcvtxn	v31.2s, v31.2d

positive: fcvtxn2 instruction

	fcvtxn2	v0.4s, v0.2d
	fcvtxn2	v31.4s, v31.2d

positive: fcvtzs instruction

	fcvtzs	h0, h0, 1
	fcvtzs	h31, h31, 16
	fcvtzs	s0, s0, 1
	fcvtzs	s31, s31, 32
	fcvtzs	d0, d0, 1
	fcvtzs	d31, d31, 64
	fcvtzs	v0.4h, v0.4h, 1
	fcvtzs	v31.4h, v31.4h, 16
	fcvtzs	v0.8h, v0.8h, 1
	fcvtzs	v31.8h, v31.8h, 16
	fcvtzs	v0.2s, v0.2s, 1
	fcvtzs	v31.2s, v31.2s, 32
	fcvtzs	v0.4s, v0.4s, 1
	fcvtzs	v31.4s, v31.4s, 32
	fcvtzs	v0.2d, v0.2d, 1
	fcvtzs	v31.2d, v31.2d, 64
	fcvtzs	h0, h0
	fcvtzs	h31, h31
	fcvtzs	s0, s0
	fcvtzs	s31, s31
	fcvtzs	d0, d0
	fcvtzs	d31, d31
	fcvtzs	v0.4h, v0.4h
	fcvtzs	v31.4h, v31.4h
	fcvtzs	v0.8h, v0.8h
	fcvtzs	v31.8h, v31.8h
	fcvtzs	v0.2s, v0.2s
	fcvtzs	v31.2s, v31.2s
	fcvtzs	v0.4s, v0.4s
	fcvtzs	v31.4s, v31.4s
	fcvtzs	v0.2d, v0.2d
	fcvtzs	v31.2d, v31.2d
	fcvtzs	w0, h0, 1
	fcvtzs	wzr, h31, 32
	fcvtzs	x0, h0, 1
	fcvtzs	xzr, h31, 64
	fcvtzs	w0, s0, 1
	fcvtzs	wzr, s31, 32
	fcvtzs	x0, s0, 1
	fcvtzs	xzr, s31, 64
	fcvtzs	w0, d0, 1
	fcvtzs	wzr, d31, 32
	fcvtzs	x0, d0, 1
	fcvtzs	xzr, d31, 64
	fcvtzs	w0, h0
	fcvtzs	wzr, h31
	fcvtzs	x0, h0
	fcvtzs	xzr, h31
	fcvtzs	w0, s0
	fcvtzs	wzr, s31
	fcvtzs	x0, s0
	fcvtzs	xzr, s31
	fcvtzs	w0, d0
	fcvtzs	wzr, d31
	fcvtzs	x0, d0
	fcvtzs	xzr, d31

positive: fcvtzu instruction

	fcvtzu	h0, h0, 1
	fcvtzu	h31, h31, 16
	fcvtzu	s0, s0, 1
	fcvtzu	s31, s31, 32
	fcvtzu	d0, d0, 1
	fcvtzu	d31, d31, 64
	fcvtzu	v0.4h, v0.4h, 1
	fcvtzu	v31.4h, v31.4h, 16
	fcvtzu	v0.8h, v0.8h, 1
	fcvtzu	v31.8h, v31.8h, 16
	fcvtzu	v0.2s, v0.2s, 1
	fcvtzu	v31.2s, v31.2s, 32
	fcvtzu	v0.4s, v0.4s, 1
	fcvtzu	v31.4s, v31.4s, 32
	fcvtzu	v0.2d, v0.2d, 1
	fcvtzu	v31.2d, v31.2d, 64
	fcvtzu	h0, h0
	fcvtzu	h31, h31
	fcvtzu	s0, s0
	fcvtzu	s31, s31
	fcvtzu	d0, d0
	fcvtzu	d31, d31
	fcvtzu	v0.4h, v0.4h
	fcvtzu	v31.4h, v31.4h
	fcvtzu	v0.8h, v0.8h
	fcvtzu	v31.8h, v31.8h
	fcvtzu	v0.2s, v0.2s
	fcvtzu	v31.2s, v31.2s
	fcvtzu	v0.4s, v0.4s
	fcvtzu	v31.4s, v31.4s
	fcvtzu	v0.2d, v0.2d
	fcvtzu	v31.2d, v31.2d
	fcvtzu	w0, h0, 1
	fcvtzu	wzr, h31, 32
	fcvtzu	x0, h0, 1
	fcvtzu	xzr, h31, 64
	fcvtzu	w0, s0, 1
	fcvtzu	wzr, s31, 32
	fcvtzu	x0, s0, 1
	fcvtzu	xzr, s31, 64
	fcvtzu	w0, d0, 1
	fcvtzu	wzr, d31, 32
	fcvtzu	x0, d0, 1
	fcvtzu	xzr, d31, 64
	fcvtzu	w0, h0
	fcvtzu	wzr, h31
	fcvtzu	x0, h0
	fcvtzu	xzr, h31
	fcvtzu	w0, s0
	fcvtzu	wzr, s31
	fcvtzu	x0, s0
	fcvtzu	xzr, s31
	fcvtzu	w0, d0
	fcvtzu	wzr, d31
	fcvtzu	x0, d0
	fcvtzu	xzr, d31

positive: fdiv instruction

	fdiv	v0.4h, v0.4h, v0.4h
	fdiv	v31.4h, v31.4h, v31.4h
	fdiv	v0.8h, v0.8h, v0.8h
	fdiv	v31.8h, v31.8h, v31.8h
	fdiv	v0.2s, v0.2s, v0.2s
	fdiv	v31.2s, v31.2s, v31.2s
	fdiv	v0.4s, v0.4s, v0.4s
	fdiv	v31.4s, v31.4s, v31.4s
	fdiv	v0.2d, v0.2d, v0.2d
	fdiv	v31.2d, v31.2d, v31.2d
	fdiv	h0, h0, h0
	fdiv	h31, h31, h31
	fdiv	s0, s0, s0
	fdiv	s31, s31, s31
	fdiv	d0, d0, d0
	fdiv	d31, d31, d31

positive: fjcvtzs instruction

	fjcvtzs	w0, d0
	fjcvtzs	wzr, d31

positive: fmadd instruction

	fmadd	h0, h0, h0, h0
	fmadd	h31, h31, h31, h31
	fmadd	s0, s0, s0, s0
	fmadd	s31, s31, s31, s31
	fmadd	d0, d0, d0, d0
	fmadd	d31, d31, d31, d31

positive: fmax instruction

	fmax	v0.4h, v0.4h, v0.4h
	fmax	v31.4h, v31.4h, v31.4h
	fmax	v0.8h, v0.8h, v0.8h
	fmax	v31.8h, v31.8h, v31.8h
	fmax	v0.2s, v0.2s, v0.2s
	fmax	v31.2s, v31.2s, v31.2s
	fmax	v0.4s, v0.4s, v0.4s
	fmax	v31.4s, v31.4s, v31.4s
	fmax	v0.2d, v0.2d, v0.2d
	fmax	v31.2d, v31.2d, v31.2d
	fmax	h0, h0, h0
	fmax	h31, h31, h31
	fmax	s0, s0, s0
	fmax	s31, s31, s31
	fmax	d0, d0, d0
	fmax	d31, d31, d31

positive: fmaxnm instruction

	fmaxnm	v0.4h, v0.4h, v0.4h
	fmaxnm	v31.4h, v31.4h, v31.4h
	fmaxnm	v0.8h, v0.8h, v0.8h
	fmaxnm	v31.8h, v31.8h, v31.8h
	fmaxnm	v0.2s, v0.2s, v0.2s
	fmaxnm	v31.2s, v31.2s, v31.2s
	fmaxnm	v0.4s, v0.4s, v0.4s
	fmaxnm	v31.4s, v31.4s, v31.4s
	fmaxnm	v0.2d, v0.2d, v0.2d
	fmaxnm	v31.2d, v31.2d, v31.2d
	fmaxnm	h0, h0, h0
	fmaxnm	h31, h31, h31
	fmaxnm	s0, s0, s0
	fmaxnm	s31, s31, s31
	fmaxnm	d0, d0, d0
	fmaxnm	d31, d31, d31

positive: fmaxnmp instruction

	fmaxnmp	h0, v0.2h
	fmaxnmp	h31, v31.2h
	fmaxnmp	s0, v0.2s
	fmaxnmp	s31, v31.2s
	fmaxnmp	d0, v0.2d
	fmaxnmp	d31, v31.2d
	fmaxnmp	v0.4h, v0.4h, v0.4h
	fmaxnmp	v31.4h, v31.4h, v31.4h
	fmaxnmp	v0.8h, v0.8h, v0.8h
	fmaxnmp	v31.8h, v31.8h, v31.8h
	fmaxnmp	v0.2s, v0.2s, v0.2s
	fmaxnmp	v31.2s, v31.2s, v31.2s
	fmaxnmp	v0.4s, v0.4s, v0.4s
	fmaxnmp	v31.4s, v31.4s, v31.4s
	fmaxnmp	v0.2d, v0.2d, v0.2d
	fmaxnmp	v31.2d, v31.2d, v31.2d

positive: fmaxnmv instruction

	fmaxnmv	h0, v0.4h
	fmaxnmv	h31, v31.4h
	fmaxnmv	h0, v0.8h
	fmaxnmv	h31, v31.8h
	fmaxnmv	s0, v0.4s
	fmaxnmv	s31, v31.4s

positive: fmaxp instruction

	fmaxp	h0, v0.2h
	fmaxp	h31, v31.2h
	fmaxp	s0, v0.2s
	fmaxp	s31, v31.2s
	fmaxp	d0, v0.2d
	fmaxp	d31, v31.2d
	fmaxp	v0.4h, v0.4h, v0.4h
	fmaxp	v31.4h, v31.4h, v31.4h
	fmaxp	v0.8h, v0.8h, v0.8h
	fmaxp	v31.8h, v31.8h, v31.8h
	fmaxp	v0.2s, v0.2s, v0.2s
	fmaxp	v31.2s, v31.2s, v31.2s
	fmaxp	v0.4s, v0.4s, v0.4s
	fmaxp	v31.4s, v31.4s, v31.4s
	fmaxp	v0.2d, v0.2d, v0.2d
	fmaxp	v31.2d, v31.2d, v31.2d

positive: fmaxv instruction

	fmaxv	h0, v0.4h
	fmaxv	h31, v31.4h
	fmaxv	h0, v0.8h
	fmaxv	h31, v31.8h
	fmaxv	s0, v0.4s
	fmaxv	s31, v31.4s

positive: fmin instruction

	fmin	v0.4h, v0.4h, v0.4h
	fmin	v31.4h, v31.4h, v31.4h
	fmin	v0.8h, v0.8h, v0.8h
	fmin	v31.8h, v31.8h, v31.8h
	fmin	v0.2s, v0.2s, v0.2s
	fmin	v31.2s, v31.2s, v31.2s
	fmin	v0.4s, v0.4s, v0.4s
	fmin	v31.4s, v31.4s, v31.4s
	fmin	v0.2d, v0.2d, v0.2d
	fmin	v31.2d, v31.2d, v31.2d
	fmin	h0, h0, h0
	fmin	h31, h31, h31
	fmin	s0, s0, s0
	fmin	s31, s31, s31
	fmin	d0, d0, d0
	fmin	d31, d31, d31

positive: fminnm instruction

	fminnm	v0.4h, v0.4h, v0.4h
	fminnm	v31.4h, v31.4h, v31.4h
	fminnm	v0.8h, v0.8h, v0.8h
	fminnm	v31.8h, v31.8h, v31.8h
	fminnm	v0.2s, v0.2s, v0.2s
	fminnm	v31.2s, v31.2s, v31.2s
	fminnm	v0.4s, v0.4s, v0.4s
	fminnm	v31.4s, v31.4s, v31.4s
	fminnm	v0.2d, v0.2d, v0.2d
	fminnm	v31.2d, v31.2d, v31.2d
	fminnm	h0, h0, h0
	fminnm	h31, h31, h31
	fminnm	s0, s0, s0
	fminnm	s31, s31, s31
	fminnm	d0, d0, d0
	fminnm	d31, d31, d31

positive: fminnmp instruction

	fminnmp	h0, v0.2h
	fminnmp	h31, v31.2h
	fminnmp	s0, v0.2s
	fminnmp	s31, v31.2s
	fminnmp	d0, v0.2d
	fminnmp	d31, v31.2d
	fminnmp	v0.4h, v0.4h, v0.4h
	fminnmp	v31.4h, v31.4h, v31.4h
	fminnmp	v0.8h, v0.8h, v0.8h
	fminnmp	v31.8h, v31.8h, v31.8h
	fminnmp	v0.2s, v0.2s, v0.2s
	fminnmp	v31.2s, v31.2s, v31.2s
	fminnmp	v0.4s, v0.4s, v0.4s
	fminnmp	v31.4s, v31.4s, v31.4s
	fminnmp	v0.2d, v0.2d, v0.2d
	fminnmp	v31.2d, v31.2d, v31.2d

positive: fminnmv instruction

	fminnmv	h0, v0.4h
	fminnmv	h31, v31.4h
	fminnmv	h0, v0.8h
	fminnmv	h31, v31.8h
	fminnmv	s0, v0.4s
	fminnmv	s31, v31.4s

positive: fminp instruction

	fminp	h0, v0.2h
	fminp	h31, v31.2h
	fminp	s0, v0.2s
	fminp	s31, v31.2s
	fminp	d0, v0.2d
	fminp	d31, v31.2d
	fminp	v0.4h, v0.4h, v0.4h
	fminp	v31.4h, v31.4h, v31.4h
	fminp	v0.8h, v0.8h, v0.8h
	fminp	v31.8h, v31.8h, v31.8h
	fminp	v0.2s, v0.2s, v0.2s
	fminp	v31.2s, v31.2s, v31.2s
	fminp	v0.4s, v0.4s, v0.4s
	fminp	v31.4s, v31.4s, v31.4s
	fminp	v0.2d, v0.2d, v0.2d
	fminp	v31.2d, v31.2d, v31.2d

positive: fminv instruction

	fminv	h0, v0.4h
	fminv	h31, v31.4h
	fminv	h0, v0.8h
	fminv	h31, v31.8h
	fminv	s0, v0.4s
	fminv	s31, v31.4s

positive: fmla instruction

	fmla	h0, h0, v0.h[0]
	fmla	h31, h31, v15.h[7]
	fmla	s0, s0, v0.s[0]
	fmla	s31, s31, v31.s[3]
	fmla	d0, d0, v0.d[0]
	fmla	d31, d31, v31.d[1]
	fmla	v0.4h, v0.4h, v0.h[0]
	fmla	v31.4h, v31.4h, v15.h[7]
	fmla	v0.8h, v0.8h, v0.h[0]
	fmla	v31.8h, v31.8h, v15.h[7]
	fmla	v0.2s, v0.2s, v0.s[0]
	fmla	v31.2s, v31.2s, v31.s[3]
	fmla	v0.4s, v0.4s, v0.s[0]
	fmla	v31.4s, v31.4s, v31.s[3]
	fmla	v0.2d, v0.2d, v0.d[0]
	fmla	v31.2d, v31.2d, v31.d[1]
	fmla	v0.4h, v0.4h, v0.4h
	fmla	v31.4h, v31.4h, v31.4h
	fmla	v0.8h, v0.8h, v0.8h
	fmla	v31.8h, v31.8h, v31.8h
	fmla	v0.2s, v0.2s, v0.2s
	fmla	v31.2s, v31.2s, v31.2s
	fmla	v0.4s, v0.4s, v0.4s
	fmla	v31.4s, v31.4s, v31.4s
	fmla	v0.2d, v0.2d, v0.2d
	fmla	v31.2d, v31.2d, v31.2d

positive: fmlal instruction

	fmlal	v0.2s, v0.2h, v0.h[0]
	fmlal	v31.2s, v31.2h, v15.h[7]
	fmlal	v0.4s, v0.4h, v0.h[0]
	fmlal	v31.4s, v31.4h, v15.h[7]
	fmlal	v0.2s, v0.2h, v0.2h
	fmlal	v31.2s, v31.2h, v31.2h
	fmlal	v0.4s, v0.4h, v0.4h
	fmlal	v31.4s, v31.4h, v31.4h

positive: fmlal2 instruction

	fmlal2	v0.2s, v0.2h, v0.h[0]
	fmlal2	v31.2s, v31.2h, v15.h[7]
	fmlal2	v0.4s, v0.4h, v0.h[0]
	fmlal2	v31.4s, v31.4h, v15.h[7]
	fmlal2	v0.2s, v0.2h, v0.2h
	fmlal2	v31.2s, v31.2h, v31.2h
	fmlal2	v0.4s, v0.4h, v0.4h
	fmlal2	v31.4s, v31.4h, v31.4h

positive: fmls instruction

	fmls	h0, h0, v0.h[0]
	fmls	h31, h31, v15.h[7]
	fmls	s0, s0, v0.s[0]
	fmls	s31, s31, v31.s[3]
	fmls	d0, d0, v0.d[0]
	fmls	d31, d31, v31.d[1]
	fmls	v0.4h, v0.4h, v0.h[0]
	fmls	v31.4h, v31.4h, v15.h[7]
	fmls	v0.8h, v0.8h, v0.h[0]
	fmls	v31.8h, v31.8h, v15.h[7]
	fmls	v0.2s, v0.2s, v0.s[0]
	fmls	v31.2s, v31.2s, v31.s[3]
	fmls	v0.4s, v0.4s, v0.s[0]
	fmls	v31.4s, v31.4s, v31.s[3]
	fmls	v0.2d, v0.2d, v0.d[0]
	fmls	v31.2d, v31.2d, v31.d[1]
	fmls	v0.4h, v0.4h, v0.4h
	fmls	v31.4h, v31.4h, v31.4h
	fmls	v0.8h, v0.8h, v0.8h
	fmls	v31.8h, v31.8h, v31.8h
	fmls	v0.2s, v0.2s, v0.2s
	fmls	v31.2s, v31.2s, v31.2s
	fmls	v0.4s, v0.4s, v0.4s
	fmls	v31.4s, v31.4s, v31.4s
	fmls	v0.2d, v0.2d, v0.2d
	fmls	v31.2d, v31.2d, v31.2d

positive: fmlsl instruction

	fmlsl	v0.2s, v0.2h, v0.h[0]
	fmlsl	v31.2s, v31.2h, v15.h[7]
	fmlsl	v0.4s, v0.4h, v0.h[0]
	fmlsl	v31.4s, v31.4h, v15.h[7]
	fmlsl	v0.2s, v0.2h, v0.2h
	fmlsl	v31.2s, v31.2h, v31.2h
	fmlsl	v0.4s, v0.4h, v0.4h
	fmlsl	v31.4s, v31.4h, v31.4h

positive: fmlsl2 instruction

	fmlsl2	v0.2s, v0.2h, v0.h[0]
	fmlsl2	v31.2s, v31.2h, v15.h[7]
	fmlsl2	v0.4s, v0.4h, v0.h[0]
	fmlsl2	v31.4s, v31.4h, v15.h[7]
	fmlsl2	v0.2s, v0.2h, v0.2h
	fmlsl2	v31.2s, v31.2h, v31.2h
	fmlsl2	v0.4s, v0.4h, v0.4h
	fmlsl2	v31.4s, v31.4h, v31.4h

positive: fmov instruction

	fmov	v0.4h, -0.1328125
	fmov	v31.4h, +31.0
	fmov	v0.8h, -0.1328125
	fmov	v31.8h, +31.0
	fmov	v0.2s, -0.1328125
	fmov	v31.2s, +31.0
	fmov	v0.4s, -0.1328125
	fmov	v31.4s, +31.0
	fmov	v0.2d, -0.1328125
	fmov	v31.2d, +31.0
	fmov	h0, h0
	fmov	h31, h31
	fmov	s0, s0
	fmov	s31, s31
	fmov	d0, d0
	fmov	d31, d31
	fmov	w0, h0
	fmov	wzr, h31
	fmov	x0, h0
	fmov	xzr, h31
	fmov	h0, w0
	fmov	h31, wzr
	fmov	s0, w0
	fmov	s31, wzr
	fmov	w0, s0
	fmov	wzr, s31
	fmov	h0, x0
	fmov	h31, xzr
	fmov	d0, x0
	fmov	d31, xzr
	fmov	v0.d[1], x0
	fmov	v31.d[1], xzr
	fmov	x0, d0
	fmov	xzr, d31
	fmov	x0, v0.d[1]
	fmov	xzr, v31.d[1]
	fmov	h0, -0.1328125
	fmov	h31, +31.0
	fmov	s0, -0.1328125
	fmov	s31, +31.0
	fmov	d0, -0.1328125
	fmov	d31, +31.0

positive: fmsub instruction

	fmsub	h0, h0, h0, h0
	fmsub	h31, h31, h31, h31
	fmsub	s0, s0, s0, s0
	fmsub	s31, s31, s31, s31
	fmsub	d0, d0, d0, d0
	fmsub	d31, d31, d31, d31

positive: fmul instruction

	fmul	h0, h0, v0.h[0]
	fmul	h31, h31, v15.h[7]
	fmul	s0, s0, v0.s[0]
	fmul	s31, s31, v31.s[3]
	fmul	d0, d0, v0.d[0]
	fmul	d31, d31, v31.d[1]
	fmul	v0.4h, v0.4h, v0.h[0]
	fmul	v31.4h, v31.4h, v15.h[7]
	fmul	v0.8h, v0.8h, v0.h[0]
	fmul	v31.8h, v31.8h, v15.h[7]
	fmul	v0.2s, v0.2s, v0.s[0]
	fmul	v31.2s, v31.2s, v31.s[3]
	fmul	v0.4s, v0.4s, v0.s[0]
	fmul	v31.4s, v31.4s, v31.s[3]
	fmul	v0.2d, v0.2d, v0.d[0]
	fmul	v31.2d, v31.2d, v31.d[1]
	fmul	v0.4h, v0.4h, v0.4h
	fmul	v31.4h, v31.4h, v31.4h
	fmul	v0.8h, v0.8h, v0.8h
	fmul	v31.8h, v31.8h, v31.8h
	fmul	v0.2s, v0.2s, v0.2s
	fmul	v31.2s, v31.2s, v31.2s
	fmul	v0.4s, v0.4s, v0.4s
	fmul	v31.4s, v31.4s, v31.4s
	fmul	v0.2d, v0.2d, v0.2d
	fmul	v31.2d, v31.2d, v31.2d
	fmul	h0, h0, h0
	fmul	h31, h31, h31
	fmul	s0, s0, s0
	fmul	s31, s31, s31
	fmul	d0, d0, d0
	fmul	d31, d31, d31

positive: fmulx instruction

	fmulx	h0, h0, v0.h[0]
	fmulx	h31, h31, v15.h[7]
	fmulx	s0, s0, v0.s[0]
	fmulx	s31, s31, v31.s[3]
	fmulx	d0, d0, v0.d[0]
	fmulx	d31, d31, v31.d[1]
	fmulx	v0.4h, v0.4h, v0.h[0]
	fmulx	v31.4h, v31.4h, v15.h[7]
	fmulx	v0.8h, v0.8h, v0.h[0]
	fmulx	v31.8h, v31.8h, v15.h[7]
	fmulx	v0.2s, v0.2s, v0.s[0]
	fmulx	v31.2s, v31.2s, v31.s[3]
	fmulx	v0.4s, v0.4s, v0.s[0]
	fmulx	v31.4s, v31.4s, v31.s[3]
	fmulx	v0.2d, v0.2d, v0.d[0]
	fmulx	v31.2d, v31.2d, v31.d[1]
	fmulx	h0, h0, h0
	fmulx	h31, h31, h31
	fmulx	s0, s0, s0
	fmulx	s31, s31, s31
	fmulx	d0, d0, d0
	fmulx	d31, d31, d31

positive: fneg instruction

	fneg	v0.4h, v0.4h
	fneg	v31.4h, v31.4h
	fneg	v0.8h, v0.8h
	fneg	v31.8h, v31.8h
	fneg	v0.2s, v0.2s
	fneg	v31.2s, v31.2s
	fneg	v0.4s, v0.4s
	fneg	v31.4s, v31.4s
	fneg	v0.2d, v0.2d
	fneg	v31.2d, v31.2d
	fneg	h0, h0
	fneg	h31, h31
	fneg	s0, s0
	fneg	s31, s31
	fneg	d0, d0
	fneg	d31, d31

positive: fnmadd instruction

	fnmadd	h0, h0, h0, h0
	fnmadd	h31, h31, h31, h31
	fnmadd	s0, s0, s0, s0
	fnmadd	s31, s31, s31, s31
	fnmadd	d0, d0, d0, d0
	fnmadd	d31, d31, d31, d31

positive: fnmsub instruction

	fnmsub	h0, h0, h0, h0
	fnmsub	h31, h31, h31, h31
	fnmsub	s0, s0, s0, s0
	fnmsub	s31, s31, s31, s31
	fnmsub	d0, d0, d0, d0
	fnmsub	d31, d31, d31, d31

positive: fnmul instruction

	fnmul	h0, h0, h0
	fnmul	h31, h31, h31
	fnmul	s0, s0, s0
	fnmul	s31, s31, s31
	fnmul	d0, d0, d0
	fnmul	d31, d31, d31

positive: frecpe instruction

	frecpe	h0, h0
	frecpe	h31, h31
	frecpe	s0, s0
	frecpe	s31, s31
	frecpe	d0, d0
	frecpe	d31, d31

positive: frecps instruction

	frecps	h0, h0, h0
	frecps	h31, h31, h31
	frecps	s0, s0, s0
	frecps	s31, s31, s31
	frecps	d0, d0, d0
	frecps	d31, d31, d31

positive: frecpx instruction

	frecpx	h0, h0
	frecpx	h31, h31
	frecpx	s0, s0
	frecpx	s31, s31
	frecpx	d0, d0
	frecpx	d31, d31

positive: frinta instruction

	frinta	v0.4h, v0.4h
	frinta	v31.4h, v31.4h
	frinta	v0.8h, v0.8h
	frinta	v31.8h, v31.8h
	frinta	v0.2s, v0.2s
	frinta	v31.2s, v31.2s
	frinta	v0.4s, v0.4s
	frinta	v31.4s, v31.4s
	frinta	v0.2d, v0.2d
	frinta	v31.2d, v31.2d
	frinta	h0, h0
	frinta	h31, h31
	frinta	s0, s0
	frinta	s31, s31
	frinta	d0, d0
	frinta	d31, d31

positive: frinti instruction

	frinti	v0.4h, v0.4h
	frinti	v31.4h, v31.4h
	frinti	v0.8h, v0.8h
	frinti	v31.8h, v31.8h
	frinti	v0.2s, v0.2s
	frinti	v31.2s, v31.2s
	frinti	v0.4s, v0.4s
	frinti	v31.4s, v31.4s
	frinti	v0.2d, v0.2d
	frinti	v31.2d, v31.2d
	frinti	h0, h0
	frinti	h31, h31
	frinti	s0, s0
	frinti	s31, s31
	frinti	d0, d0
	frinti	d31, d31

positive: frintm instruction

	frintm	v0.4h, v0.4h
	frintm	v31.4h, v31.4h
	frintm	v0.8h, v0.8h
	frintm	v31.8h, v31.8h
	frintm	v0.2s, v0.2s
	frintm	v31.2s, v31.2s
	frintm	v0.4s, v0.4s
	frintm	v31.4s, v31.4s
	frintm	v0.2d, v0.2d
	frintm	v31.2d, v31.2d
	frintm	h0, h0
	frintm	h31, h31
	frintm	s0, s0
	frintm	s31, s31
	frintm	d0, d0
	frintm	d31, d31

positive: frintn instruction

	frintn	v0.4h, v0.4h
	frintn	v31.4h, v31.4h
	frintn	v0.8h, v0.8h
	frintn	v31.8h, v31.8h
	frintn	v0.2s, v0.2s
	frintn	v31.2s, v31.2s
	frintn	v0.4s, v0.4s
	frintn	v31.4s, v31.4s
	frintn	v0.2d, v0.2d
	frintn	v31.2d, v31.2d
	frintn	h0, h0
	frintn	h31, h31
	frintn	s0, s0
	frintn	s31, s31
	frintn	d0, d0
	frintn	d31, d31

positive: frintp instruction

	frintp	v0.4h, v0.4h
	frintp	v31.4h, v31.4h
	frintp	v0.8h, v0.8h
	frintp	v31.8h, v31.8h
	frintp	v0.2s, v0.2s
	frintp	v31.2s, v31.2s
	frintp	v0.4s, v0.4s
	frintp	v31.4s, v31.4s
	frintp	v0.2d, v0.2d
	frintp	v31.2d, v31.2d
	frintp	h0, h0
	frintp	h31, h31
	frintp	s0, s0
	frintp	s31, s31
	frintp	d0, d0
	frintp	d31, d31

positive: frintx instruction

	frintx	v0.4h, v0.4h
	frintx	v31.4h, v31.4h
	frintx	v0.8h, v0.8h
	frintx	v31.8h, v31.8h
	frintx	v0.2s, v0.2s
	frintx	v31.2s, v31.2s
	frintx	v0.4s, v0.4s
	frintx	v31.4s, v31.4s
	frintx	v0.2d, v0.2d
	frintx	v31.2d, v31.2d
	frintx	h0, h0
	frintx	h31, h31
	frintx	s0, s0
	frintx	s31, s31
	frintx	d0, d0
	frintx	d31, d31

positive: frintz instruction

	frintz	v0.4h, v0.4h
	frintz	v31.4h, v31.4h
	frintz	v0.8h, v0.8h
	frintz	v31.8h, v31.8h
	frintz	v0.2s, v0.2s
	frintz	v31.2s, v31.2s
	frintz	v0.4s, v0.4s
	frintz	v31.4s, v31.4s
	frintz	v0.2d, v0.2d
	frintz	v31.2d, v31.2d
	frintz	h0, h0
	frintz	h31, h31
	frintz	s0, s0
	frintz	s31, s31
	frintz	d0, d0
	frintz	d31, d31

positive: frsqrte instruction

	frsqrte	h0, h0
	frsqrte	h31, h31
	frsqrte	s0, s0
	frsqrte	s31, s31
	frsqrte	d0, d0
	frsqrte	d31, d31

positive: frsqrts instruction

	frsqrts	h0, h0, h0
	frsqrts	h31, h31, h31
	frsqrts	s0, s0, s0
	frsqrts	s31, s31, s31
	frsqrts	d0, d0, d0
	frsqrts	d31, d31, d31

positive: fsqrt instruction

	fsqrt	v0.4h, v0.4h
	fsqrt	v31.4h, v31.4h
	fsqrt	v0.8h, v0.8h
	fsqrt	v31.8h, v31.8h
	fsqrt	v0.2s, v0.2s
	fsqrt	v31.2s, v31.2s
	fsqrt	v0.4s, v0.4s
	fsqrt	v31.4s, v31.4s
	fsqrt	v0.2d, v0.2d
	fsqrt	v31.2d, v31.2d
	fsqrt	h0, h0
	fsqrt	h31, h31
	fsqrt	s0, s0
	fsqrt	s31, s31
	fsqrt	d0, d0
	fsqrt	d31, d31

positive: fsub instruction

	fsub	v0.4h, v0.4h, v0.4h
	fsub	v31.4h, v31.4h, v31.4h
	fsub	v0.8h, v0.8h, v0.8h
	fsub	v31.8h, v31.8h, v31.8h
	fsub	v0.2s, v0.2s, v0.2s
	fsub	v31.2s, v31.2s, v31.2s
	fsub	v0.4s, v0.4s, v0.4s
	fsub	v31.4s, v31.4s, v31.4s
	fsub	v0.2d, v0.2d, v0.2d
	fsub	v31.2d, v31.2d, v31.2d
	fsub	h0, h0, h0
	fsub	h31, h31, h31
	fsub	s0, s0, s0
	fsub	s31, s31, s31
	fsub	d0, d0, d0
	fsub	d31, d31, d31

positive: ins instruction

	ins	v0.b[0], v0.b[0]
	ins	v31.b[15], v31.b[15]
	ins	v0.h[0], v0.h[0]
	ins	v31.h[7], v31.h[7]
	ins	v0.s[0], v0.s[0]
	ins	v31.s[3], v31.s[3]
	ins	v0.d[0], v0.d[0]
	ins	v31.d[1], v31.d[1]
	ins	v0.b[0], w0
	ins	v31.b[15], wzr
	ins	v0.h[0], w0
	ins	v31.h[7], wzr
	ins	v0.s[0], w0
	ins	v31.s[3], wzr
	ins	v0.d[0], x0
	ins	v31.d[1], xzr

positive: ld1 instruction

	ld1	{v0.8b}, [x0]
	ld1	{v31.8b}, [sp]
	ld1	{v0.16b}, [x0]
	ld1	{v31.16b}, [sp]
	ld1	{v0.4h}, [x0]
	ld1	{v31.4h}, [sp]
	ld1	{v0.8h}, [x0]
	ld1	{v31.8h}, [sp]
	ld1	{v0.2s}, [x0]
	ld1	{v31.2s}, [sp]
	ld1	{v0.4s}, [x0]
	ld1	{v31.4s}, [sp]
	ld1	{v0.1d}, [x0]
	ld1	{v31.1d}, [sp]
	ld1	{v0.2d}, [x0]
	ld1	{v31.2d}, [sp]
	ld1	{v0.8b, v1.8b}, [x0]
	ld1	{v31.8b, v0.8b}, [sp]
	ld1	{v0.16b, v1.16b}, [x0]
	ld1	{v31.16b, v0.16b}, [sp]
	ld1	{v0.4h, v1.4h}, [x0]
	ld1	{v31.4h, v0.4h}, [sp]
	ld1	{v0.8h, v1.8h}, [x0]
	ld1	{v31.8h, v0.8h}, [sp]
	ld1	{v0.2s, v1.2s}, [x0]
	ld1	{v31.2s, v0.2s}, [sp]
	ld1	{v0.4s, v1.4s}, [x0]
	ld1	{v31.4s, v0.4s}, [sp]
	ld1	{v0.1d, v1.1d}, [x0]
	ld1	{v31.1d, v0.1d}, [sp]
	ld1	{v0.2d, v1.2d}, [x0]
	ld1	{v31.2d, v0.2d}, [sp]
	ld1	{v0.8b, v1.8b, v2.8b}, [x0]
	ld1	{v31.8b, v0.8b, v1.8b}, [sp]
	ld1	{v0.16b, v1.16b, v2.16b}, [x0]
	ld1	{v31.16b, v0.16b, v1.16b}, [sp]
	ld1	{v0.4h, v1.4h, v2.4h}, [x0]
	ld1	{v31.4h, v0.4h, v1.4h}, [sp]
	ld1	{v0.8h, v1.8h, v2.8h}, [x0]
	ld1	{v31.8h, v0.8h, v1.8h}, [sp]
	ld1	{v0.2s, v1.2s, v2.2s}, [x0]
	ld1	{v31.2s, v0.2s, v1.2s}, [sp]
	ld1	{v0.4s, v1.4s, v2.4s}, [x0]
	ld1	{v31.4s, v0.4s, v1.4s}, [sp]
	ld1	{v0.1d, v1.1d, v2.1d}, [x0]
	ld1	{v31.1d, v0.1d, v1.1d}, [sp]
	ld1	{v0.2d, v1.2d, v2.2d}, [x0]
	ld1	{v31.2d, v0.2d, v1.2d}, [sp]
	ld1	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0]
	ld1	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp]
	ld1	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0]
	ld1	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp]
	ld1	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0]
	ld1	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp]
	ld1	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0]
	ld1	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp]
	ld1	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0]
	ld1	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp]
	ld1	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0]
	ld1	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp]
	ld1	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0]
	ld1	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp]
	ld1	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0]
	ld1	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp]
	ld1	{v0.8b}, [x0], 8
	ld1	{v31.8b}, [sp], 8
	ld1	{v0.16b}, [x0], 16
	ld1	{v31.16b}, [sp], 16
	ld1	{v0.4h}, [x0], 8
	ld1	{v31.4h}, [sp], 8
	ld1	{v0.8h}, [x0], 16
	ld1	{v31.8h}, [sp], 16
	ld1	{v0.2s}, [x0], 8
	ld1	{v31.2s}, [sp], 8
	ld1	{v0.4s}, [x0], 16
	ld1	{v31.4s}, [sp], 16
	ld1	{v0.1d}, [x0], 8
	ld1	{v31.1d}, [sp], 8
	ld1	{v0.2d}, [x0], 16
	ld1	{v31.2d}, [sp], 16
	ld1	{v0.8b}, [x0], x0
	ld1	{v31.8b}, [sp], x30
	ld1	{v0.16b}, [x0], x0
	ld1	{v31.16b}, [sp], x30
	ld1	{v0.4h}, [x0], x0
	ld1	{v31.4h}, [sp], x30
	ld1	{v0.8h}, [x0], x0
	ld1	{v31.8h}, [sp], x30
	ld1	{v0.2s}, [x0], x0
	ld1	{v31.2s}, [sp], x30
	ld1	{v0.4s}, [x0], x0
	ld1	{v31.4s}, [sp], x30
	ld1	{v0.1d}, [x0], x0
	ld1	{v31.1d}, [sp], x30
	ld1	{v0.2d}, [x0], x0
	ld1	{v31.2d}, [sp], x30
	ld1	{v0.8b, v1.8b}, [x0], 16
	ld1	{v31.8b, v0.8b}, [sp], 16
	ld1	{v0.16b, v1.16b}, [x0], 32
	ld1	{v31.16b, v0.16b}, [sp], 32
	ld1	{v0.4h, v1.4h}, [x0], 16
	ld1	{v31.4h, v0.4h}, [sp], 16
	ld1	{v0.8h, v1.8h}, [x0], 32
	ld1	{v31.8h, v0.8h}, [sp], 32
	ld1	{v0.2s, v1.2s}, [x0], 16
	ld1	{v31.2s, v0.2s}, [sp], 16
	ld1	{v0.4s, v1.4s}, [x0], 32
	ld1	{v31.4s, v0.4s}, [sp], 32
	ld1	{v0.1d, v1.1d}, [x0], 16
	ld1	{v31.1d, v0.1d}, [sp], 16
	ld1	{v0.2d, v1.2d}, [x0], 32
	ld1	{v31.2d, v0.2d}, [sp], 32
	ld1	{v0.8b, v1.8b}, [x0], x0
	ld1	{v31.8b, v0.8b}, [sp], x30
	ld1	{v0.16b, v1.16b}, [x0], x0
	ld1	{v31.16b, v0.16b}, [sp], x30
	ld1	{v0.4h, v1.4h}, [x0], x0
	ld1	{v31.4h, v0.4h}, [sp], x30
	ld1	{v0.8h, v1.8h}, [x0], x0
	ld1	{v31.8h, v0.8h}, [sp], x30
	ld1	{v0.2s, v1.2s}, [x0], x0
	ld1	{v31.2s, v0.2s}, [sp], x30
	ld1	{v0.4s, v1.4s}, [x0], x0
	ld1	{v31.4s, v0.4s}, [sp], x30
	ld1	{v0.1d, v1.1d}, [x0], x0
	ld1	{v31.1d, v0.1d}, [sp], x30
	ld1	{v0.2d, v1.2d}, [x0], x0
	ld1	{v31.2d, v0.2d}, [sp], x30
	ld1	{v0.8b, v1.8b, v2.8b}, [x0], 24
	ld1	{v31.8b, v0.8b, v1.8b}, [sp], 24
	ld1	{v0.16b, v1.16b, v2.16b}, [x0], 48
	ld1	{v31.16b, v0.16b, v1.16b}, [sp], 48
	ld1	{v0.4h, v1.4h, v2.4h}, [x0], 24
	ld1	{v31.4h, v0.4h, v1.4h}, [sp], 24
	ld1	{v0.8h, v1.8h, v2.8h}, [x0], 48
	ld1	{v31.8h, v0.8h, v1.8h}, [sp], 48
	ld1	{v0.2s, v1.2s, v2.2s}, [x0], 24
	ld1	{v31.2s, v0.2s, v1.2s}, [sp], 24
	ld1	{v0.4s, v1.4s, v2.4s}, [x0], 48
	ld1	{v31.4s, v0.4s, v1.4s}, [sp], 48
	ld1	{v0.1d, v1.1d, v2.1d}, [x0], 24
	ld1	{v31.1d, v0.1d, v1.1d}, [sp], 24
	ld1	{v0.2d, v1.2d, v2.2d}, [x0], 48
	ld1	{v31.2d, v0.2d, v1.2d}, [sp], 48
	ld1	{v0.8b, v1.8b, v2.8b}, [x0], x0
	ld1	{v31.8b, v0.8b, v1.8b}, [sp], x30
	ld1	{v0.16b, v1.16b, v2.16b}, [x0], x0
	ld1	{v31.16b, v0.16b, v1.16b}, [sp], x30
	ld1	{v0.4h, v1.4h, v2.4h}, [x0], x0
	ld1	{v31.4h, v0.4h, v1.4h}, [sp], x30
	ld1	{v0.8h, v1.8h, v2.8h}, [x0], x0
	ld1	{v31.8h, v0.8h, v1.8h}, [sp], x30
	ld1	{v0.2s, v1.2s, v2.2s}, [x0], x0
	ld1	{v31.2s, v0.2s, v1.2s}, [sp], x30
	ld1	{v0.4s, v1.4s, v2.4s}, [x0], x0
	ld1	{v31.4s, v0.4s, v1.4s}, [sp], x30
	ld1	{v0.1d, v1.1d, v2.1d}, [x0], x0
	ld1	{v31.1d, v0.1d, v1.1d}, [sp], x30
	ld1	{v0.2d, v1.2d, v2.2d}, [x0], x0
	ld1	{v31.2d, v0.2d, v1.2d}, [sp], x30
	ld1	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0], 32
	ld1	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp], 32
	ld1	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0], 64
	ld1	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp], 64
	ld1	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0], 32
	ld1	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp], 32
	ld1	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0], 64
	ld1	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp], 64
	ld1	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0], 32
	ld1	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp], 32
	ld1	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0], 64
	ld1	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp], 64
	ld1	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0], 32
	ld1	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp], 32
	ld1	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0], 64
	ld1	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp], 64
	ld1	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0], x0
	ld1	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp], x30
	ld1	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0], x0
	ld1	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp], x30
	ld1	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0], x0
	ld1	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp], x30
	ld1	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0], x0
	ld1	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp], x30
	ld1	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0], x0
	ld1	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp], x30
	ld1	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0], x0
	ld1	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp], x30
	ld1	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0], x0
	ld1	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp], x30
	ld1	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0], x0
	ld1	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp], x30
	ld1	{v0.b}[0], [x0]
	ld1	{v31.b}[15], [sp]
	ld1	{v0.h}[0], [x0]
	ld1	{v31.h}[7], [sp]
	ld1	{v0.s}[0], [x0]
	ld1	{v31.s}[3], [sp]
	ld1	{v0.d}[0], [x0]
	ld1	{v31.d}[1], [sp]
	ld1	{v0.b}[0], [x0], 1
	ld1	{v31.b}[15], [sp], 1
	ld1	{v0.b}[0], [x0], x0
	ld1	{v31.b}[15], [sp], x30
	ld1	{v0.h}[0], [x0], 2
	ld1	{v31.h}[7], [sp], 2
	ld1	{v0.h}[0], [x0], x0
	ld1	{v31.h}[7], [sp], x30
	ld1	{v0.s}[0], [x0], 4
	ld1	{v31.s}[3], [sp], 4
	ld1	{v0.s}[0], [x0], x0
	ld1	{v31.s}[3], [sp], x30
	ld1	{v0.d}[0], [x0], 8
	ld1	{v31.d}[1], [sp], 8
	ld1	{v0.d}[0], [x0], x0
	ld1	{v31.d}[1], [sp], x30

positive: ld1r instruction

	ld1r	{v0.8b}, [x0]
	ld1r	{v31.8b}, [sp]
	ld1r	{v0.16b}, [x0]
	ld1r	{v31.16b}, [sp]
	ld1r	{v0.4h}, [x0]
	ld1r	{v31.4h}, [sp]
	ld1r	{v0.8h}, [x0]
	ld1r	{v31.8h}, [sp]
	ld1r	{v0.2s}, [x0]
	ld1r	{v31.2s}, [sp]
	ld1r	{v0.4s}, [x0]
	ld1r	{v31.4s}, [sp]
	ld1r	{v0.1d}, [x0]
	ld1r	{v31.1d}, [sp]
	ld1r	{v0.2d}, [x0]
	ld1r	{v31.2d}, [sp]
	ld1r	{v0.8b}, [x0], 1
	ld1r	{v31.8b}, [sp], 1
	ld1r	{v0.16b}, [x0], 1
	ld1r	{v31.16b}, [sp], 1
	ld1r	{v0.4h}, [x0], 2
	ld1r	{v31.4h}, [sp], 2
	ld1r	{v0.8h}, [x0], 2
	ld1r	{v31.8h}, [sp], 2
	ld1r	{v0.2s}, [x0], 4
	ld1r	{v31.2s}, [sp], 4
	ld1r	{v0.4s}, [x0], 4
	ld1r	{v31.4s}, [sp], 4
	ld1r	{v0.1d}, [x0], 8
	ld1r	{v31.1d}, [sp], 8
	ld1r	{v0.2d}, [x0], 8
	ld1r	{v31.2d}, [sp], 8
	ld1r	{v0.8b}, [x0], x0
	ld1r	{v31.8b}, [sp], x30
	ld1r	{v0.16b}, [x0], x0
	ld1r	{v31.16b}, [sp], x30
	ld1r	{v0.4h}, [x0], x0
	ld1r	{v31.4h}, [sp], x30
	ld1r	{v0.8h}, [x0], x0
	ld1r	{v31.8h}, [sp], x30
	ld1r	{v0.2s}, [x0], x0
	ld1r	{v31.2s}, [sp], x30
	ld1r	{v0.4s}, [x0], x0
	ld1r	{v31.4s}, [sp], x30
	ld1r	{v0.1d}, [x0], x0
	ld1r	{v31.1d}, [sp], x30
	ld1r	{v0.2d}, [x0], x0
	ld1r	{v31.2d}, [sp], x30

positive: ld2 instruction

	ld2	{v0.8b, v1.8b}, [x0]
	ld2	{v31.8b, v0.8b}, [sp]
	ld2	{v0.16b, v1.16b}, [x0]
	ld2	{v31.16b, v0.16b}, [sp]
	ld2	{v0.4h, v1.4h}, [x0]
	ld2	{v31.4h, v0.4h}, [sp]
	ld2	{v0.8h, v1.8h}, [x0]
	ld2	{v31.8h, v0.8h}, [sp]
	ld2	{v0.2s, v1.2s}, [x0]
	ld2	{v31.2s, v0.2s}, [sp]
	ld2	{v0.4s, v1.4s}, [x0]
	ld2	{v31.4s, v0.4s}, [sp]
	ld2	{v0.2d, v1.2d}, [x0]
	ld2	{v31.2d, v0.2d}, [sp]
	ld2	{v0.8b, v1.8b}, [x0], 16
	ld2	{v31.8b, v0.8b}, [sp], 16
	ld2	{v0.16b, v1.16b}, [x0], 32
	ld2	{v31.16b, v0.16b}, [sp], 32
	ld2	{v0.4h, v1.4h}, [x0], 16
	ld2	{v31.4h, v0.4h}, [sp], 16
	ld2	{v0.8h, v1.8h}, [x0], 32
	ld2	{v31.8h, v0.8h}, [sp], 32
	ld2	{v0.2s, v1.2s}, [x0], 16
	ld2	{v31.2s, v0.2s}, [sp], 16
	ld2	{v0.4s, v1.4s}, [x0], 32
	ld2	{v31.4s, v0.4s}, [sp], 32
	ld2	{v0.2d, v1.2d}, [x0], 32
	ld2	{v31.2d, v0.2d}, [sp], 32
	ld2	{v0.8b, v1.8b}, [x0], x0
	ld2	{v31.8b, v0.8b}, [sp], x30
	ld2	{v0.16b, v1.16b}, [x0], x0
	ld2	{v31.16b, v0.16b}, [sp], x30
	ld2	{v0.4h, v1.4h}, [x0], x0
	ld2	{v31.4h, v0.4h}, [sp], x30
	ld2	{v0.8h, v1.8h}, [x0], x0
	ld2	{v31.8h, v0.8h}, [sp], x30
	ld2	{v0.2s, v1.2s}, [x0], x0
	ld2	{v31.2s, v0.2s}, [sp], x30
	ld2	{v0.4s, v1.4s}, [x0], x0
	ld2	{v31.4s, v0.4s}, [sp], x30
	ld2	{v0.2d, v1.2d}, [x0], x0
	ld2	{v31.2d, v0.2d}, [sp], x30
	ld2	{v0.b, v1.b}[0], [x0]
	ld2	{v31.b, v0.b}[15], [sp]
	ld2	{v0.h, v1.h}[0], [x0]
	ld2	{v31.h, v0.h}[7], [sp]
	ld2	{v0.s, v1.s}[0], [x0]
	ld2	{v31.s, v0.s}[3], [sp]
	ld2	{v0.d, v1.d}[0], [x0]
	ld2	{v31.d, v0.d}[1], [sp]
	ld2	{v0.b, v1.b}[0], [x0], 2
	ld2	{v31.b, v0.b}[15], [sp], 2
	ld2	{v0.b, v1.b}[0], [x0], x0
	ld2	{v31.b, v0.b}[15], [sp], x30
	ld2	{v0.h, v1.h}[0], [x0], 4
	ld2	{v31.h, v0.h}[7], [sp], 4
	ld2	{v0.h, v1.h}[0], [x0], x0
	ld2	{v31.h, v0.h}[7], [sp], x30
	ld2	{v0.s, v1.s}[0], [x0], 8
	ld2	{v31.s, v0.s}[3], [sp], 8
	ld2	{v0.s, v1.s}[0], [x0], x0
	ld2	{v31.s, v0.s}[3], [sp], x30
	ld2	{v0.d, v1.d}[0], [x0], 16
	ld2	{v31.d, v0.d}[1], [sp], 16
	ld2	{v0.d, v1.d}[0], [x0], x0
	ld2	{v31.d, v0.d}[1], [sp], x30

positive: ld2r instruction

	ld2r	{v0.8b, v1.8b}, [x0]
	ld2r	{v31.8b, v0.8b}, [sp]
	ld2r	{v0.16b, v1.16b}, [x0]
	ld2r	{v31.16b, v0.16b}, [sp]
	ld2r	{v0.4h, v1.4h}, [x0]
	ld2r	{v31.4h, v0.4h}, [sp]
	ld2r	{v0.8h, v1.8h}, [x0]
	ld2r	{v31.8h, v0.8h}, [sp]
	ld2r	{v0.2s, v1.2s}, [x0]
	ld2r	{v31.2s, v0.2s}, [sp]
	ld2r	{v0.4s, v1.4s}, [x0]
	ld2r	{v31.4s, v0.4s}, [sp]
	ld2r	{v0.1d, v1.1d}, [x0]
	ld2r	{v31.1d, v0.1d}, [sp]
	ld2r	{v0.2d, v1.2d}, [x0]
	ld2r	{v31.2d, v0.2d}, [sp]
	ld2r	{v0.8b, v1.8b}, [x0], 2
	ld2r	{v31.8b, v0.8b}, [sp], 2
	ld2r	{v0.16b, v1.16b}, [x0], 2
	ld2r	{v31.16b, v0.16b}, [sp], 2
	ld2r	{v0.4h, v1.4h}, [x0], 4
	ld2r	{v31.4h, v0.4h}, [sp], 4
	ld2r	{v0.8h, v1.8h}, [x0], 4
	ld2r	{v31.8h, v0.8h}, [sp], 4
	ld2r	{v0.2s, v1.2s}, [x0], 8
	ld2r	{v31.2s, v0.2s}, [sp], 8
	ld2r	{v0.4s, v1.4s}, [x0], 8
	ld2r	{v31.4s, v0.4s}, [sp], 8
	ld2r	{v0.1d, v1.1d}, [x0], 16
	ld2r	{v31.1d, v0.1d}, [sp], 16
	ld2r	{v0.2d, v1.2d}, [x0], 16
	ld2r	{v31.2d, v0.2d}, [sp], 16
	ld2r	{v0.8b, v1.8b}, [x0], x0
	ld2r	{v31.8b, v0.8b}, [sp], x30
	ld2r	{v0.16b, v1.16b}, [x0], x0
	ld2r	{v31.16b, v0.16b}, [sp], x30
	ld2r	{v0.4h, v1.4h}, [x0], x0
	ld2r	{v31.4h, v0.4h}, [sp], x30
	ld2r	{v0.8h, v1.8h}, [x0], x0
	ld2r	{v31.8h, v0.8h}, [sp], x30
	ld2r	{v0.2s, v1.2s}, [x0], x0
	ld2r	{v31.2s, v0.2s}, [sp], x30
	ld2r	{v0.4s, v1.4s}, [x0], x0
	ld2r	{v31.4s, v0.4s}, [sp], x30
	ld2r	{v0.1d, v1.1d}, [x0], x0
	ld2r	{v31.1d, v0.1d}, [sp], x30
	ld2r	{v0.2d, v1.2d}, [x0], x0
	ld2r	{v31.2d, v0.2d}, [sp], x30

positive: ld3 instruction

	ld3	{v0.8b, v1.8b, v2.8b}, [x0]
	ld3	{v31.8b, v0.8b, v1.8b}, [sp]
	ld3	{v0.16b, v1.16b, v2.16b}, [x0]
	ld3	{v31.16b, v0.16b, v1.16b}, [sp]
	ld3	{v0.4h, v1.4h, v2.4h}, [x0]
	ld3	{v31.4h, v0.4h, v1.4h}, [sp]
	ld3	{v0.8h, v1.8h, v2.8h}, [x0]
	ld3	{v31.8h, v0.8h, v1.8h}, [sp]
	ld3	{v0.2s, v1.2s, v2.2s}, [x0]
	ld3	{v31.2s, v0.2s, v1.2s}, [sp]
	ld3	{v0.4s, v1.4s, v2.4s}, [x0]
	ld3	{v31.4s, v0.4s, v1.4s}, [sp]
	ld3	{v0.2d, v1.2d, v2.2d}, [x0]
	ld3	{v31.2d, v0.2d, v1.2d}, [sp]
	ld3	{v0.8b, v1.8b, v2.8b}, [x0], 24
	ld3	{v31.8b, v0.8b, v1.8b}, [sp], 24
	ld3	{v0.16b, v1.16b, v2.16b}, [x0], 48
	ld3	{v31.16b, v0.16b, v1.16b}, [sp], 48
	ld3	{v0.4h, v1.4h, v2.4h}, [x0], 24
	ld3	{v31.4h, v0.4h, v1.4h}, [sp], 24
	ld3	{v0.8h, v1.8h, v2.8h}, [x0], 48
	ld3	{v31.8h, v0.8h, v1.8h}, [sp], 48
	ld3	{v0.2s, v1.2s, v2.2s}, [x0], 24
	ld3	{v31.2s, v0.2s, v1.2s}, [sp], 24
	ld3	{v0.4s, v1.4s, v2.4s}, [x0], 48
	ld3	{v31.4s, v0.4s, v1.4s}, [sp], 48
	ld3	{v0.2d, v1.2d, v2.2d}, [x0], 48
	ld3	{v31.2d, v0.2d, v1.2d}, [sp], 48
	ld3	{v0.8b, v1.8b, v2.8b}, [x0], x0
	ld3	{v31.8b, v0.8b, v1.8b}, [sp], x30
	ld3	{v0.16b, v1.16b, v2.16b}, [x0], x0
	ld3	{v31.16b, v0.16b, v1.16b}, [sp], x30
	ld3	{v0.4h, v1.4h, v2.4h}, [x0], x0
	ld3	{v31.4h, v0.4h, v1.4h}, [sp], x30
	ld3	{v0.8h, v1.8h, v2.8h}, [x0], x0
	ld3	{v31.8h, v0.8h, v1.8h}, [sp], x30
	ld3	{v0.2s, v1.2s, v2.2s}, [x0], x0
	ld3	{v31.2s, v0.2s, v1.2s}, [sp], x30
	ld3	{v0.4s, v1.4s, v2.4s}, [x0], x0
	ld3	{v31.4s, v0.4s, v1.4s}, [sp], x30
	ld3	{v0.2d, v1.2d, v2.2d}, [x0], x0
	ld3	{v31.2d, v0.2d, v1.2d}, [sp], x30
	ld3	{v0.b, v1.b, v2.b}[0], [x0]
	ld3	{v31.b, v0.b, v1.b}[15], [sp]
	ld3	{v0.h, v1.h, v2.h}[0], [x0]
	ld3	{v31.h, v0.h, v1.h}[7], [sp]
	ld3	{v0.s, v1.s, v2.s}[0], [x0]
	ld3	{v31.s, v0.s, v1.s}[3], [sp]
	ld3	{v0.d, v1.d, v2.d}[0], [x0]
	ld3	{v31.d, v0.d, v1.d}[1], [sp]
	ld3	{v0.b, v1.b, v2.b}[0], [x0], 3
	ld3	{v31.b, v0.b, v1.b}[15], [sp], 3
	ld3	{v0.b, v1.b, v2.b}[0], [x0], x0
	ld3	{v31.b, v0.b, v1.b}[15], [sp], x30
	ld3	{v0.h, v1.h, v2.h}[0], [x0], 6
	ld3	{v31.h, v0.h, v1.h}[7], [sp], 6
	ld3	{v0.h, v1.h, v2.h}[0], [x0], x0
	ld3	{v31.h, v0.h, v1.h}[7], [sp], x30
	ld3	{v0.s, v1.s, v2.s}[0], [x0], 12
	ld3	{v31.s, v0.s, v1.s}[3], [sp], 12
	ld3	{v0.s, v1.s, v2.s}[0], [x0], x0
	ld3	{v31.s, v0.s, v1.s}[3], [sp], x30
	ld3	{v0.d, v1.d, v2.d}[0], [x0], 24
	ld3	{v31.d, v0.d, v1.d}[1], [sp], 24
	ld3	{v0.d, v1.d, v2.d}[0], [x0], x0
	ld3	{v31.d, v0.d, v1.d}[1], [sp], x30

positive: ld3r instruction

	ld3r	{v0.8b, v1.8b, v2.8b}, [x0]
	ld3r	{v31.8b, v0.8b, v1.8b}, [sp]
	ld3r	{v0.16b, v1.16b, v2.16b}, [x0]
	ld3r	{v31.16b, v0.16b, v1.16b}, [sp]
	ld3r	{v0.4h, v1.4h, v2.4h}, [x0]
	ld3r	{v31.4h, v0.4h, v1.4h}, [sp]
	ld3r	{v0.8h, v1.8h, v2.8h}, [x0]
	ld3r	{v31.8h, v0.8h, v1.8h}, [sp]
	ld3r	{v0.2s, v1.2s, v2.2s}, [x0]
	ld3r	{v31.2s, v0.2s, v1.2s}, [sp]
	ld3r	{v0.4s, v1.4s, v2.4s}, [x0]
	ld3r	{v31.4s, v0.4s, v1.4s}, [sp]
	ld3r	{v0.1d, v1.1d, v2.1d}, [x0]
	ld3r	{v31.1d, v0.1d, v1.1d}, [sp]
	ld3r	{v0.2d, v1.2d, v2.2d}, [x0]
	ld3r	{v31.2d, v0.2d, v1.2d}, [sp]
	ld3r	{v0.8b, v1.8b, v2.8b}, [x0], 3
	ld3r	{v31.8b, v0.8b, v1.8b}, [sp], 3
	ld3r	{v0.16b, v1.16b, v2.16b}, [x0], 3
	ld3r	{v31.16b, v0.16b, v1.16b}, [sp], 3
	ld3r	{v0.4h, v1.4h, v2.4h}, [x0], 6
	ld3r	{v31.4h, v0.4h, v1.4h}, [sp], 6
	ld3r	{v0.8h, v1.8h, v2.8h}, [x0], 6
	ld3r	{v31.8h, v0.8h, v1.8h}, [sp], 6
	ld3r	{v0.2s, v1.2s, v2.2s}, [x0], 12
	ld3r	{v31.2s, v0.2s, v1.2s}, [sp], 12
	ld3r	{v0.4s, v1.4s, v2.4s}, [x0], 12
	ld3r	{v31.4s, v0.4s, v1.4s}, [sp], 12
	ld3r	{v0.1d, v1.1d, v2.1d}, [x0], 24
	ld3r	{v31.1d, v0.1d, v1.1d}, [sp], 24
	ld3r	{v0.2d, v1.2d, v2.2d}, [x0], 24
	ld3r	{v31.2d, v0.2d, v1.2d}, [sp], 24
	ld3r	{v0.8b, v1.8b, v2.8b}, [x0], x0
	ld3r	{v31.8b, v0.8b, v1.8b}, [sp], x30
	ld3r	{v0.16b, v1.16b, v2.16b}, [x0], x0
	ld3r	{v31.16b, v0.16b, v1.16b}, [sp], x30
	ld3r	{v0.4h, v1.4h, v2.4h}, [x0], x0
	ld3r	{v31.4h, v0.4h, v1.4h}, [sp], x30
	ld3r	{v0.8h, v1.8h, v2.8h}, [x0], x0
	ld3r	{v31.8h, v0.8h, v1.8h}, [sp], x30
	ld3r	{v0.2s, v1.2s, v2.2s}, [x0], x0
	ld3r	{v31.2s, v0.2s, v1.2s}, [sp], x30
	ld3r	{v0.4s, v1.4s, v2.4s}, [x0], x0
	ld3r	{v31.4s, v0.4s, v1.4s}, [sp], x30
	ld3r	{v0.1d, v1.1d, v2.1d}, [x0], x0
	ld3r	{v31.1d, v0.1d, v1.1d}, [sp], x30
	ld3r	{v0.2d, v1.2d, v2.2d}, [x0], x0
	ld3r	{v31.2d, v0.2d, v1.2d}, [sp], x30

positive: ld4 instruction

	ld4	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0]
	ld4	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp]
	ld4	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0]
	ld4	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp]
	ld4	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0]
	ld4	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp]
	ld4	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0]
	ld4	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp]
	ld4	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0]
	ld4	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp]
	ld4	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0]
	ld4	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp]
	ld4	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0]
	ld4	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp]
	ld4	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0], 32
	ld4	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp], 32
	ld4	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0], 64
	ld4	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp], 64
	ld4	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0], 32
	ld4	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp], 32
	ld4	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0], 64
	ld4	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp], 64
	ld4	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0], 32
	ld4	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp], 32
	ld4	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0], 64
	ld4	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp], 64
	ld4	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0], 64
	ld4	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp], 64
	ld4	{v0.b, v1.b, v2.b, v3.b}[0], [x0]
	ld4	{v31.b, v0.b, v1.b, v2.b}[15], [sp]
	ld4	{v0.h, v1.h, v2.h, v3.h}[0], [x0]
	ld4	{v31.h, v0.h, v1.h, v2.h}[7], [sp]
	ld4	{v0.s, v1.s, v2.s, v3.s}[0], [x0]
	ld4	{v31.s, v0.s, v1.s, v2.s}[3], [sp]
	ld4	{v0.d, v1.d, v2.d, v3.d}[0], [x0]
	ld4	{v31.d, v0.d, v1.d, v2.d}[1], [sp]
	ld4	{v0.b, v1.b, v2.b, v3.b}[0], [x0], 4
	ld4	{v31.b, v0.b, v1.b, v2.b}[15], [sp], 4
	ld4	{v0.b, v1.b, v2.b, v3.b}[0], [x0], x0
	ld4	{v31.b, v0.b, v1.b, v2.b}[15], [sp], x30
	ld4	{v0.h, v1.h, v2.h, v3.h}[0], [x0], 8
	ld4	{v31.h, v0.h, v1.h, v2.h}[7], [sp], 8
	ld4	{v0.h, v1.h, v2.h, v3.h}[0], [x0], x0
	ld4	{v31.h, v0.h, v1.h, v2.h}[7], [sp], x30
	ld4	{v0.s, v1.s, v2.s, v3.s}[0], [x0], 16
	ld4	{v31.s, v0.s, v1.s, v2.s}[3], [sp], 16
	ld4	{v0.s, v1.s, v2.s, v3.s}[0], [x0], x0
	ld4	{v31.s, v0.s, v1.s, v2.s}[3], [sp], x30
	ld4	{v0.d, v1.d, v2.d, v3.d}[0], [x0], 32
	ld4	{v31.d, v0.d, v1.d, v2.d}[1], [sp], 32
	ld4	{v0.d, v1.d, v2.d, v3.d}[0], [x0], x0
	ld4	{v31.d, v0.d, v1.d, v2.d}[1], [sp], x30

positive: ld4r instruction

	ld4r	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0]
	ld4r	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp]
	ld4r	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0]
	ld4r	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp]
	ld4r	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0]
	ld4r	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp]
	ld4r	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0]
	ld4r	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp]
	ld4r	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0]
	ld4r	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp]
	ld4r	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0]
	ld4r	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp]
	ld4r	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0]
	ld4r	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp]
	ld4r	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0]
	ld4r	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp]
	ld4r	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0], 4
	ld4r	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp], 4
	ld4r	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0], 4
	ld4r	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp], 4
	ld4r	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0], 8
	ld4r	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp], 8
	ld4r	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0], 8
	ld4r	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp], 8
	ld4r	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0], 16
	ld4r	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp], 16
	ld4r	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0], 16
	ld4r	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp], 16
	ld4r	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0], 32
	ld4r	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp], 32
	ld4r	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0], 32
	ld4r	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp], 32
	ld4r	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0], x0
	ld4r	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp], x30
	ld4r	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0], x0
	ld4r	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp], x30
	ld4r	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0], x0
	ld4r	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp], x30
	ld4r	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0], x0
	ld4r	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp], x30
	ld4r	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0], x0
	ld4r	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp], x30
	ld4r	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0], x0
	ld4r	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp], x30
	ld4r	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0], x0
	ld4r	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp], x30
	ld4r	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0], x0
	ld4r	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp], x30

positive: mla instruction

	mla	v0.4h, v0.4h, v0.h[0]
	mla	v31.4h, v31.4h, v15.h[7]
	mla	v0.8h, v0.8h, v0.h[0]
	mla	v31.8h, v31.8h, v15.h[7]
	mla	v0.2s, v0.2s, v0.s[0]
	mla	v31.2s, v31.2s, v31.s[3]
	mla	v0.4s, v0.4s, v0.s[0]
	mla	v31.4s, v31.4s, v31.s[3]
	mla	v0.8b, v0.8b, v0.8b
	mla	v31.8b, v31.8b, v31.8b
	mla	v0.16b, v0.16b, v0.16b
	mla	v31.16b, v31.16b, v31.16b
	mla	v0.4h, v0.4h, v0.4h
	mla	v31.4h, v31.4h, v31.4h
	mla	v0.8h, v0.8h, v0.8h
	mla	v31.8h, v31.8h, v31.8h
	mla	v0.2s, v0.2s, v0.2s
	mla	v31.2s, v31.2s, v31.2s
	mla	v0.4s, v0.4s, v0.4s
	mla	v31.4s, v31.4s, v31.4s

positive: mls instruction

	mls	v0.4h, v0.4h, v0.h[0]
	mls	v31.4h, v31.4h, v15.h[7]
	mls	v0.8h, v0.8h, v0.h[0]
	mls	v31.8h, v31.8h, v15.h[7]
	mls	v0.2s, v0.2s, v0.s[0]
	mls	v31.2s, v31.2s, v31.s[3]
	mls	v0.4s, v0.4s, v0.s[0]
	mls	v31.4s, v31.4s, v31.s[3]
	mls	v0.8b, v0.8b, v0.8b
	mls	v31.8b, v31.8b, v31.8b
	mls	v0.16b, v0.16b, v0.16b
	mls	v31.16b, v31.16b, v31.16b
	mls	v0.4h, v0.4h, v0.4h
	mls	v31.4h, v31.4h, v31.4h
	mls	v0.8h, v0.8h, v0.8h
	mls	v31.8h, v31.8h, v31.8h
	mls	v0.2s, v0.2s, v0.2s
	mls	v31.2s, v31.2s, v31.2s
	mls	v0.4s, v0.4s, v0.4s
	mls	v31.4s, v31.4s, v31.4s

positive: not instruction

	not	v0.8b, v0.8b
	not	v31.8b, v31.8b
	not	v0.16b, v0.16b
	not	v31.16b, v31.16b

positive: pmul instruction

	pmul	v0.8b, v0.8b, v0.8b
	pmul	v31.8b, v31.8b, v31.8b
	pmul	v0.16b, v0.16b, v0.16b
	pmul	v31.16b, v31.16b, v31.16b

positive: pmull instruction

	pmull	v0.8h, v0.8b, v0.8b
	pmull	v31.8h, v31.8b, v31.8b
	pmull	v0.1q, v0.1d, v0.1d
	pmull	v31.1q, v31.1d, v31.1d

positive: pmull2 instruction

	pmull2	v0.8h, v0.16b, v0.16b
	pmull2	v31.8h, v31.16b, v31.16b
	pmull2	v0.1q, v0.2d, v0.2d
	pmull2	v31.1q, v31.2d, v31.2d

positive: raddhn instruction

	raddhn	v0.8b, v0.8h, v0.8h
	raddhn	v31.8b, v31.8h, v31.8h
	raddhn	v0.4h, v0.4s, v0.4s
	raddhn	v31.4h, v31.4s, v31.4s
	raddhn	v0.2s, v0.2d, v0.2d
	raddhn	v31.2s, v31.2d, v31.2d

positive: raddhn2 instruction

	raddhn2	v0.16b, v0.8h, v0.8h
	raddhn2	v31.16b, v31.8h, v31.8h
	raddhn2	v0.8h, v0.4s, v0.4s
	raddhn2	v31.8h, v31.4s, v31.4s
	raddhn2	v0.4s, v0.2d, v0.2d
	raddhn2	v31.4s, v31.2d, v31.2d

positive: rax1 instruction

	rax1	v0.2d, v0.2d, v0.2d
	rax1	v31.2d, v31.2d, v31.2d

positive: rshrn instruction

	rshrn	v0.8b, v0.8h, 1
	rshrn	v31.8b, v31.8h, 8
	rshrn	v0.4h, v0.4s, 1
	rshrn	v31.4h, v31.4s, 16
	rshrn	v0.2s, v0.2d, 1
	rshrn	v31.2s, v31.2d, 32

positive: rshrn2 instruction

	rshrn2	v0.16b, v0.8h, 1
	rshrn2	v31.16b, v31.8h, 8
	rshrn2	v0.8h, v0.4s, 1
	rshrn2	v31.8h, v31.4s, 16
	rshrn2	v0.4s, v0.2d, 1
	rshrn2	v31.4s, v31.2d, 32

positive: rsubhn instruction

	rsubhn	v0.8b, v0.8h, v0.8h
	rsubhn	v31.8b, v31.8h, v31.8h
	rsubhn	v0.4h, v0.4s, v0.4s
	rsubhn	v31.4h, v31.4s, v31.4s
	rsubhn	v0.2s, v0.2d, v0.2d
	rsubhn	v31.2s, v31.2d, v31.2d

positive: rsubhn2 instruction

	rsubhn2	v0.16b, v0.8h, v0.8h
	rsubhn2	v31.16b, v31.8h, v31.8h
	rsubhn2	v0.8h, v0.4s, v0.4s
	rsubhn2	v31.8h, v31.4s, v31.4s
	rsubhn2	v0.4s, v0.2d, v0.2d
	rsubhn2	v31.4s, v31.2d, v31.2d

positive: saba instruction

	saba	v0.8b, v0.8b, v0.8b
	saba	v31.8b, v31.8b, v31.8b
	saba	v0.16b, v0.16b, v0.16b
	saba	v31.16b, v31.16b, v31.16b
	saba	v0.4h, v0.4h, v0.4h
	saba	v31.4h, v31.4h, v31.4h
	saba	v0.8h, v0.8h, v0.8h
	saba	v31.8h, v31.8h, v31.8h
	saba	v0.2s, v0.2s, v0.2s
	saba	v31.2s, v31.2s, v31.2s
	saba	v0.4s, v0.4s, v0.4s
	saba	v31.4s, v31.4s, v31.4s

positive: sabal instruction

	sabal	v0.8h, v0.8b, v0.8b
	sabal	v31.8h, v31.8b, v31.8b
	sabal	v0.4s, v0.4h, v0.4h
	sabal	v31.4s, v31.4h, v31.4h
	sabal	v0.2d, v0.2s, v0.2s
	sabal	v31.2d, v31.2s, v31.2s

positive: sabal2 instruction

	sabal2	v0.8h, v0.16b, v0.16b
	sabal2	v31.8h, v31.16b, v31.16b
	sabal2	v0.4s, v0.8h, v0.8h
	sabal2	v31.4s, v31.8h, v31.8h
	sabal2	v0.2d, v0.4s, v0.4s
	sabal2	v31.2d, v31.4s, v31.4s

positive: sabd instruction

	sabd	v0.8b, v0.8b, v0.8b
	sabd	v31.8b, v31.8b, v31.8b
	sabd	v0.16b, v0.16b, v0.16b
	sabd	v31.16b, v31.16b, v31.16b
	sabd	v0.4h, v0.4h, v0.4h
	sabd	v31.4h, v31.4h, v31.4h
	sabd	v0.8h, v0.8h, v0.8h
	sabd	v31.8h, v31.8h, v31.8h
	sabd	v0.2s, v0.2s, v0.2s
	sabd	v31.2s, v31.2s, v31.2s
	sabd	v0.4s, v0.4s, v0.4s
	sabd	v31.4s, v31.4s, v31.4s

positive: sabdl instruction

	sabdl	v0.8h, v0.8b, v0.8b
	sabdl	v31.8h, v31.8b, v31.8b
	sabdl	v0.4s, v0.4h, v0.4h
	sabdl	v31.4s, v31.4h, v31.4h
	sabdl	v0.2d, v0.2s, v0.2s
	sabdl	v31.2d, v31.2s, v31.2s

positive: sabdl2 instruction

	sabdl2	v0.8h, v0.16b, v0.16b
	sabdl2	v31.8h, v31.16b, v31.16b
	sabdl2	v0.4s, v0.8h, v0.8h
	sabdl2	v31.4s, v31.8h, v31.8h
	sabdl2	v0.2d, v0.4s, v0.4s
	sabdl2	v31.2d, v31.4s, v31.4s

positive: sadalp instruction

	sadalp	v0.4h, v0.8b
	sadalp	v31.4h, v31.8b
	sadalp	v0.8h, v0.16b
	sadalp	v31.8h, v31.16b
	sadalp	v0.2s, v0.4h
	sadalp	v31.2s, v31.4h
	sadalp	v0.4s, v0.8h
	sadalp	v31.4s, v31.8h
	sadalp	v0.1d, v0.2s
	sadalp	v31.1d, v31.2s
	sadalp	v0.2d, v0.4s
	sadalp	v31.2d, v31.4s

positive: saddl instruction

	saddl	v0.8h, v0.8b, v0.8b
	saddl	v31.8h, v31.8b, v31.8b
	saddl	v0.4s, v0.4h, v0.4h
	saddl	v31.4s, v31.4h, v31.4h
	saddl	v0.2d, v0.2s, v0.2s
	saddl	v31.2d, v31.2s, v31.2s

positive: saddl2 instruction

	saddl2	v0.8h, v0.16b, v0.16b
	saddl2	v31.8h, v31.16b, v31.16b
	saddl2	v0.4s, v0.8h, v0.8h
	saddl2	v31.4s, v31.8h, v31.8h
	saddl2	v0.2d, v0.4s, v0.4s
	saddl2	v31.2d, v31.4s, v31.4s

positive: saddlp instruction

	saddlp	v0.4h, v0.8b
	saddlp	v31.4h, v31.8b
	saddlp	v0.8h, v0.16b
	saddlp	v31.8h, v31.16b
	saddlp	v0.2s, v0.4h
	saddlp	v31.2s, v31.4h
	saddlp	v0.4s, v0.8h
	saddlp	v31.4s, v31.8h
	saddlp	v0.1d, v0.2s
	saddlp	v31.1d, v31.2s
	saddlp	v0.2d, v0.4s
	saddlp	v31.2d, v31.4s

positive: saddlv instruction

	saddlv	h0, v0.8b
	saddlv	h31, v31.8b
	saddlv	h0, v0.16b
	saddlv	h31, v31.16b
	saddlv	s0, v0.4h
	saddlv	s31, v31.4h
	saddlv	s0, v0.8h
	saddlv	s31, v31.8h
	saddlv	d0, v0.4s
	saddlv	d31, v31.4s

positive: saddw instruction

	saddw	v0.8h, v0.8h, v0.8b
	saddw	v31.8h, v31.8h, v31.8b
	saddw	v0.4s, v0.4s, v0.4h
	saddw	v31.4s, v31.4s, v31.4h
	saddw	v0.2d, v0.2d, v0.2s
	saddw	v31.2d, v31.2d, v31.2s

positive: saddw2 instruction

	saddw2	v0.8h, v0.8h, v0.16b
	saddw2	v31.8h, v31.8h, v31.16b
	saddw2	v0.4s, v0.4s, v0.8h
	saddw2	v31.4s, v31.4s, v31.8h
	saddw2	v0.2d, v0.2d, v0.4s
	saddw2	v31.2d, v31.2d, v31.4s

positive: scvtf instruction

	scvtf	h0, h0, 1
	scvtf	h31, h31, 16
	scvtf	s0, s0, 1
	scvtf	s31, s31, 32
	scvtf	d0, d0, 1
	scvtf	d31, d31, 64
	scvtf	v0.4h, v0.4h, 1
	scvtf	v31.4h, v31.4h, 16
	scvtf	v0.8h, v0.8h, 1
	scvtf	v31.8h, v31.8h, 16
	scvtf	v0.2s, v0.2s, 1
	scvtf	v31.2s, v31.2s, 32
	scvtf	v0.4s, v0.4s, 1
	scvtf	v31.4s, v31.4s, 32
	scvtf	v0.2d, v0.2d, 1
	scvtf	v31.2d, v31.2d, 64
	scvtf	h0, h0
	scvtf	h31, h31
	scvtf	s0, s0
	scvtf	s31, s31
	scvtf	d0, d0
	scvtf	d31, d31
	scvtf	v0.4h, v0.4h
	scvtf	v31.4h, v31.4h
	scvtf	v0.8h, v0.8h
	scvtf	v31.8h, v31.8h
	scvtf	v0.2s, v0.2s
	scvtf	v31.2s, v31.2s
	scvtf	v0.4s, v0.4s
	scvtf	v31.4s, v31.4s
	scvtf	v0.2d, v0.2d
	scvtf	v31.2d, v31.2d
	scvtf	h0, w0, 1
	scvtf	h31, wzr, 32
	scvtf	s0, w0, 1
	scvtf	s31, wzr, 32
	scvtf	d0, w0, 1
	scvtf	d31, wzr, 32
	scvtf	h0, x0, 1
	scvtf	h31, xzr, 64
	scvtf	s0, x0, 1
	scvtf	s31, xzr, 64
	scvtf	d0, x0, 1
	scvtf	d31, xzr, 64
	scvtf	h0, w0
	scvtf	h31, wzr
	scvtf	s0, w0
	scvtf	s31, wzr
	scvtf	d0, w0
	scvtf	d31, wzr
	scvtf	h0, x0
	scvtf	h31, xzr
	scvtf	s0, x0
	scvtf	s31, xzr
	scvtf	d0, x0
	scvtf	d31, xzr

positive: sdot instruction

	sdot	v0.2s, v0.8b, v0.b[0]
	sdot	v31.2s, v31.8b, v31.b[3]
	sdot	v0.4s, v0.16b, v0.b[0]
	sdot	v31.4s, v31.16b, v31.b[3]
	sdot	v0.2s, v0.8b, v0.8b
	sdot	v31.2s, v31.8b, v31.8b
	sdot	v0.4s, v0.16b, v0.16b
	sdot	v31.4s, v31.16b, v31.16b

positive: sha1c instruction

	sha1c	q0, s0, v0.4s
	sha1c	q31, s31, v31.4s

positive: sha1h instruction

	sha1h	s0, s0
	sha1h	s31, s31

positive: sha1m instruction

	sha1m	q0, s0, v0.4s
	sha1m	q31, s31, v31.4s

positive: sha1p instruction

	sha1p	q0, s0, v0.4s
	sha1p	q31, s31, v31.4s

positive: sha1su0 instruction

	sha1su0	v0.4s, v0.4s, v0.4s
	sha1su0	v31.4s, v31.4s, v31.4s

positive: sha1su1 instruction

	sha1su1	v0.4s, v0.4s
	sha1su1	v31.4s, v31.4s

positive: sha256h instruction

	sha256h	q0, q0, v0.4s
	sha256h	q31, q31, v31.4s

positive: sha256h2 instruction

	sha256h2	q0, q0, v0.4s
	sha256h2	q31, q31, v31.4s

positive: sha256su0 instruction

	sha256su0	v0.4s, v0.4s
	sha256su0	v31.4s, v31.4s

positive: sha256su1 instruction

	sha256su1	v0.4s, v0.4s, v0.4s
	sha256su1	v31.4s, v31.4s, v31.4s

positive: sha512h instruction

	sha512h	q0, q0, v0.2d
	sha512h	q31, q31, v31.2d

positive: sha512h2 instruction

	sha512h2	q0, q0, v0.2d
	sha512h2	q31, q31, v31.2d

positive: sha512su0 instruction

	sha512su0	v0.2d, v0.2d
	sha512su0	v31.2d, v31.2d

positive: sha512su1 instruction

	sha512su1	v0.2d, v0.2d, v0.2d
	sha512su1	v31.2d, v31.2d, v31.2d

positive: shadd instruction

	shadd	v0.8b, v0.8b, v0.8b
	shadd	v31.8b, v31.8b, v31.8b
	shadd	v0.16b, v0.16b, v0.16b
	shadd	v31.16b, v31.16b, v31.16b
	shadd	v0.4h, v0.4h, v0.4h
	shadd	v31.4h, v31.4h, v31.4h
	shadd	v0.8h, v0.8h, v0.8h
	shadd	v31.8h, v31.8h, v31.8h
	shadd	v0.2s, v0.2s, v0.2s
	shadd	v31.2s, v31.2s, v31.2s
	shadd	v0.4s, v0.4s, v0.4s
	shadd	v31.4s, v31.4s, v31.4s

positive: shl instruction

	shl	d0, d0, 0
	shl	d31, d31, 63
	shl	v0.8b, v0.8b, 0
	shl	v31.8b, v31.8b, 7
	shl	v0.16b, v0.16b, 0
	shl	v31.16b, v31.16b, 7
	shl	v0.4h, v0.4h, 0
	shl	v31.4h, v31.4h, 15
	shl	v0.8h, v0.8h, 0
	shl	v31.8h, v31.8h, 15
	shl	v0.2s, v0.2s, 0
	shl	v31.2s, v31.2s, 31
	shl	v0.4s, v0.4s, 0
	shl	v31.4s, v31.4s, 31
	shl	v0.2d, v0.2d, 0
	shl	v31.2d, v31.2d, 63

positive: shll instruction

	shll	v0.8h, v0.8b, 8
	shll	v31.8h, v31.8b, 8
	shll	v0.4s, v0.4h, 16
	shll	v31.4s, v31.4h, 16
	shll	v0.2d, v0.2s, 32
	shll	v31.2d, v31.2s, 32

positive: shll2 instruction

	shll2	v0.8h, v0.16b, 8
	shll2	v31.8h, v31.16b, 8
	shll2	v0.4s, v0.8h, 16
	shll2	v31.4s, v31.8h, 16
	shll2	v0.2d, v0.4s, 32
	shll2	v31.2d, v31.4s, 32

positive: shrn instruction

	shrn	v0.8b, v0.8h, 1
	shrn	v31.8b, v31.8h, 8
	shrn	v0.4h, v0.4s, 1
	shrn	v31.4h, v31.4s, 16
	shrn	v0.2s, v0.2d, 1
	shrn	v31.2s, v31.2d, 32

positive: shrn2 instruction

	shrn2	v0.16b, v0.8h, 1
	shrn2	v31.16b, v31.8h, 8
	shrn2	v0.8h, v0.4s, 1
	shrn2	v31.8h, v31.4s, 16
	shrn2	v0.4s, v0.2d, 1
	shrn2	v31.4s, v31.2d, 32

positive: shsub instruction

	shsub	v0.8b, v0.8b, v0.8b
	shsub	v31.8b, v31.8b, v31.8b
	shsub	v0.16b, v0.16b, v0.16b
	shsub	v31.16b, v31.16b, v31.16b
	shsub	v0.4h, v0.4h, v0.4h
	shsub	v31.4h, v31.4h, v31.4h
	shsub	v0.8h, v0.8h, v0.8h
	shsub	v31.8h, v31.8h, v31.8h
	shsub	v0.2s, v0.2s, v0.2s
	shsub	v31.2s, v31.2s, v31.2s
	shsub	v0.4s, v0.4s, v0.4s
	shsub	v31.4s, v31.4s, v31.4s

positive: sli instruction

	sli	d0, d0, 0
	sli	d31, d31, 63
	sli	v0.8b, v0.8b, 0
	sli	v31.8b, v31.8b, 7
	sli	v0.16b, v0.16b, 0
	sli	v31.16b, v31.16b, 7
	sli	v0.4h, v0.4h, 0
	sli	v31.4h, v31.4h, 15
	sli	v0.8h, v0.8h, 0
	sli	v31.8h, v31.8h, 15
	sli	v0.2s, v0.2s, 0
	sli	v31.2s, v31.2s, 31
	sli	v0.4s, v0.4s, 0
	sli	v31.4s, v31.4s, 31
	sli	v0.2d, v0.2d, 0
	sli	v31.2d, v31.2d, 63

positive: sm3partw1 instruction

	sm3partw1	v0.4s, v0.4s, v0.4s
	sm3partw1	v31.4s, v31.4s, v31.4s

positive: sm3partw2 instruction

	sm3partw2	v0.4s, v0.4s, v0.4s
	sm3partw2	v31.4s, v31.4s, v31.4s

positive: sm3ss1 instruction

	sm3ss1	v0.4s, v0.4s, v0.4s, v0.4s
	sm3ss1	v31.4s, v31.4s, v31.4s, v31.4s

positive: sm3tt1a instruction

	sm3tt1a	v0.4s, v0.4s, v0.s[0]
	sm3tt1a	v31.4s, v31.4s, v31.s[3]

positive: sm3tt1b instruction

	sm3tt1b	v0.4s, v0.4s, v0.s[0]
	sm3tt1b	v31.4s, v31.4s, v31.s[3]

positive: sm3tt2a instruction

	sm3tt2a	v0.4s, v0.4s, v0.s[0]
	sm3tt2a	v31.4s, v31.4s, v31.s[3]

positive: sm3tt2b instruction

	sm3tt2b	v0.4s, v0.4s, v0.s[0]
	sm3tt2b	v31.4s, v31.4s, v31.s[3]

positive: sm4e instruction

	sm4e	v0.4s, v0.4s
	sm4e	v31.4s, v31.4s

positive: sm4ekey instruction

	sm4ekey	v0.4s, v0.4s, v0.4s
	sm4ekey	v31.4s, v31.4s, v31.4s

positive: smax instruction

	smax	v0.8b, v0.8b, v0.8b
	smax	v31.8b, v31.8b, v31.8b
	smax	v0.16b, v0.16b, v0.16b
	smax	v31.16b, v31.16b, v31.16b
	smax	v0.4h, v0.4h, v0.4h
	smax	v31.4h, v31.4h, v31.4h
	smax	v0.8h, v0.8h, v0.8h
	smax	v31.8h, v31.8h, v31.8h
	smax	v0.2s, v0.2s, v0.2s
	smax	v31.2s, v31.2s, v31.2s
	smax	v0.4s, v0.4s, v0.4s
	smax	v31.4s, v31.4s, v31.4s

positive: smaxp instruction

	smaxp	v0.8b, v0.8b, v0.8b
	smaxp	v31.8b, v31.8b, v31.8b
	smaxp	v0.16b, v0.16b, v0.16b
	smaxp	v31.16b, v31.16b, v31.16b
	smaxp	v0.4h, v0.4h, v0.4h
	smaxp	v31.4h, v31.4h, v31.4h
	smaxp	v0.8h, v0.8h, v0.8h
	smaxp	v31.8h, v31.8h, v31.8h
	smaxp	v0.2s, v0.2s, v0.2s
	smaxp	v31.2s, v31.2s, v31.2s
	smaxp	v0.4s, v0.4s, v0.4s
	smaxp	v31.4s, v31.4s, v31.4s

positive: smaxv instruction

	smaxv	b0, v0.8b
	smaxv	b31, v31.8b
	smaxv	b0, v0.16b
	smaxv	b31, v31.16b
	smaxv	h0, v0.4h
	smaxv	h31, v31.4h
	smaxv	h0, v0.8h
	smaxv	h31, v31.8h
	smaxv	s0, v0.4s
	smaxv	s31, v31.4s

positive: smin instruction

	smin	v0.8b, v0.8b, v0.8b
	smin	v31.8b, v31.8b, v31.8b
	smin	v0.16b, v0.16b, v0.16b
	smin	v31.16b, v31.16b, v31.16b
	smin	v0.4h, v0.4h, v0.4h
	smin	v31.4h, v31.4h, v31.4h
	smin	v0.8h, v0.8h, v0.8h
	smin	v31.8h, v31.8h, v31.8h
	smin	v0.2s, v0.2s, v0.2s
	smin	v31.2s, v31.2s, v31.2s
	smin	v0.4s, v0.4s, v0.4s
	smin	v31.4s, v31.4s, v31.4s

positive: sminp instruction

	sminp	v0.8b, v0.8b, v0.8b
	sminp	v31.8b, v31.8b, v31.8b
	sminp	v0.16b, v0.16b, v0.16b
	sminp	v31.16b, v31.16b, v31.16b
	sminp	v0.4h, v0.4h, v0.4h
	sminp	v31.4h, v31.4h, v31.4h
	sminp	v0.8h, v0.8h, v0.8h
	sminp	v31.8h, v31.8h, v31.8h
	sminp	v0.2s, v0.2s, v0.2s
	sminp	v31.2s, v31.2s, v31.2s
	sminp	v0.4s, v0.4s, v0.4s
	sminp	v31.4s, v31.4s, v31.4s

positive: sminv instruction

	sminv	b0, v0.8b
	sminv	b31, v31.8b
	sminv	b0, v0.16b
	sminv	b31, v31.16b
	sminv	h0, v0.4h
	sminv	h31, v31.4h
	sminv	h0, v0.8h
	sminv	h31, v31.8h
	sminv	s0, v0.4s
	sminv	s31, v31.4s

positive: smlal instruction

	smlal	v0.4s, v0.4h, v0.h[0]
	smlal	v31.4s, v31.4h, v15.h[7]
	smlal	v0.2d, v0.2s, v0.s[0]
	smlal	v31.2d, v31.2s, v31.s[3]
	smlal	v0.8h, v0.8b, v0.8b
	smlal	v31.8h, v31.8b, v31.8b
	smlal	v0.4s, v0.4h, v0.4h
	smlal	v31.4s, v31.4h, v31.4h
	smlal	v0.2d, v0.2s, v0.2s
	smlal	v31.2d, v31.2s, v31.2s

positive: smlal2 instruction

	smlal2	v0.4s, v0.8h, v0.h[0]
	smlal2	v31.4s, v31.8h, v15.h[7]
	smlal2	v0.2d, v0.4s, v0.s[0]
	smlal2	v31.2d, v31.4s, v31.s[3]
	smlal2	v0.8h, v0.16b, v0.16b
	smlal2	v31.8h, v31.16b, v31.16b
	smlal2	v0.4s, v0.8h, v0.8h
	smlal2	v31.4s, v31.8h, v31.8h
	smlal2	v0.2d, v0.4s, v0.4s
	smlal2	v31.2d, v31.4s, v31.4s

positive: smlsl instruction

	smlsl	v0.4s, v0.4h, v0.h[0]
	smlsl	v31.4s, v31.4h, v15.h[7]
	smlsl	v0.2d, v0.2s, v0.s[0]
	smlsl	v31.2d, v31.2s, v31.s[3]
	smlsl	v0.8h, v0.8b, v0.8b
	smlsl	v31.8h, v31.8b, v31.8b
	smlsl	v0.4s, v0.4h, v0.4h
	smlsl	v31.4s, v31.4h, v31.4h
	smlsl	v0.2d, v0.2s, v0.2s
	smlsl	v31.2d, v31.2s, v31.2s

positive: smlsl2 instruction

	smlsl2	v0.4s, v0.8h, v0.h[0]
	smlsl2	v31.4s, v31.8h, v15.h[7]
	smlsl2	v0.2d, v0.4s, v0.s[0]
	smlsl2	v31.2d, v31.4s, v31.s[3]
	smlsl2	v0.8h, v0.16b, v0.16b
	smlsl2	v31.8h, v31.16b, v31.16b
	smlsl2	v0.4s, v0.8h, v0.8h
	smlsl2	v31.4s, v31.8h, v31.8h
	smlsl2	v0.2d, v0.4s, v0.4s
	smlsl2	v31.2d, v31.4s, v31.4s

positive: smov instruction

	smov	w0, v0.b[0]
	smov	wzr, v31.b[15]
	smov	w0, v0.h[0]
	smov	wzr, v31.h[7]
	smov	x0, v0.b[0]
	smov	xzr, v31.b[15]
	smov	x0, v0.h[0]
	smov	xzr, v31.h[7]
	smov	x0, v0.s[0]
	smov	xzr, v31.s[3]

positive: smull2 instruction

	smull2	v0.4s, v0.8h, v0.h[0]
	smull2	v31.4s, v31.8h, v15.h[7]
	smull2	v0.2d, v0.4s, v0.s[0]
	smull2	v31.2d, v31.4s, v31.s[3]
	smull2	v0.8h, v0.16b, v0.16b
	smull2	v31.8h, v31.16b, v31.16b
	smull2	v0.4s, v0.8h, v0.8h
	smull2	v31.4s, v31.8h, v31.8h
	smull2	v0.2d, v0.4s, v0.4s
	smull2	v31.2d, v31.4s, v31.4s

positive: sqabs instruction

	sqabs	b0, b0
	sqabs	b31, b31
	sqabs	h0, h0
	sqabs	h31, h31
	sqabs	s0, s0
	sqabs	s31, s31
	sqabs	d0, d0
	sqabs	d31, d31
	sqabs	v0.8b, v0.8b
	sqabs	v31.8b, v31.8b
	sqabs	v0.16b, v0.16b
	sqabs	v31.16b, v31.16b
	sqabs	v0.4h, v0.4h
	sqabs	v31.4h, v31.4h
	sqabs	v0.8h, v0.8h
	sqabs	v31.8h, v31.8h
	sqabs	v0.2s, v0.2s
	sqabs	v31.2s, v31.2s
	sqabs	v0.4s, v0.4s
	sqabs	v31.4s, v31.4s
	sqabs	v0.2d, v0.2d
	sqabs	v31.2d, v31.2d

positive: sqadd instruction

	sqadd	b0, b0, b0
	sqadd	b31, b31, b31
	sqadd	h0, h0, h0
	sqadd	h31, h31, h31
	sqadd	s0, s0, s0
	sqadd	s31, s31, s31
	sqadd	d0, d0, d0
	sqadd	d31, d31, d31
	sqadd	v0.8b, v0.8b, v0.8b
	sqadd	v31.8b, v31.8b, v31.8b
	sqadd	v0.16b, v0.16b, v0.16b
	sqadd	v31.16b, v31.16b, v31.16b
	sqadd	v0.4h, v0.4h, v0.4h
	sqadd	v31.4h, v31.4h, v31.4h
	sqadd	v0.8h, v0.8h, v0.8h
	sqadd	v31.8h, v31.8h, v31.8h
	sqadd	v0.2s, v0.2s, v0.2s
	sqadd	v31.2s, v31.2s, v31.2s
	sqadd	v0.4s, v0.4s, v0.4s
	sqadd	v31.4s, v31.4s, v31.4s
	sqadd	v0.2d, v0.2d, v0.2d
	sqadd	v31.2d, v31.2d, v31.2d

positive: sqdmlal instruction

	sqdmlal	s0, h0, v0.h[0]
	sqdmlal	s31, h31, v15.h[7]
	sqdmlal	d0, s0, v0.s[0]
	sqdmlal	d31, s31, v31.s[3]
	sqdmlal	v0.4s, v0.4h, v0.h[0]
	sqdmlal	v31.4s, v31.4h, v15.h[7]
	sqdmlal	v0.2d, v0.2s, v0.s[0]
	sqdmlal	v31.2d, v31.2s, v31.s[3]
	sqdmlal	s0, h0, h0
	sqdmlal	s31, h31, h31
	sqdmlal	d0, s0, s0
	sqdmlal	d31, s31, s31
	sqdmlal	v0.4s, v0.4h, v0.4h
	sqdmlal	v31.4s, v31.4h, v31.4h
	sqdmlal	v0.2d, v0.2s, v0.2s
	sqdmlal	v31.2d, v31.2s, v31.2s

positive: sqdmlal2 instruction

	sqdmlal2	v0.4s, v0.8h, v0.h[0]
	sqdmlal2	v31.4s, v31.8h, v15.h[7]
	sqdmlal2	v0.2d, v0.4s, v0.s[0]
	sqdmlal2	v31.2d, v31.4s, v31.s[3]
	sqdmlal2	v0.4s, v0.8h, v0.8h
	sqdmlal2	v31.4s, v31.8h, v31.8h
	sqdmlal2	v0.2d, v0.4s, v0.4s
	sqdmlal2	v31.2d, v31.4s, v31.4s

positive: sqdmlsl instruction

	sqdmlsl	s0, h0, v0.h[0]
	sqdmlsl	s31, h31, v15.h[7]
	sqdmlsl	d0, s0, v0.s[0]
	sqdmlsl	d31, s31, v31.s[3]
	sqdmlsl	v0.4s, v0.4h, v0.h[0]
	sqdmlsl	v31.4s, v31.4h, v15.h[7]
	sqdmlsl	v0.2d, v0.2s, v0.s[0]
	sqdmlsl	v31.2d, v31.2s, v31.s[3]
	sqdmlsl	s0, h0, h0
	sqdmlsl	s31, h31, h31
	sqdmlsl	d0, s0, s0
	sqdmlsl	d31, s31, s31
	sqdmlsl	v0.4s, v0.4h, v0.4h
	sqdmlsl	v31.4s, v31.4h, v31.4h
	sqdmlsl	v0.2d, v0.2s, v0.2s
	sqdmlsl	v31.2d, v31.2s, v31.2s

positive: sqdmlsl2 instruction

	sqdmlsl2	v0.4s, v0.8h, v0.h[0]
	sqdmlsl2	v31.4s, v31.8h, v15.h[7]
	sqdmlsl2	v0.2d, v0.4s, v0.s[0]
	sqdmlsl2	v31.2d, v31.4s, v31.s[3]
	sqdmlsl2	v0.4s, v0.8h, v0.8h
	sqdmlsl2	v31.4s, v31.8h, v31.8h
	sqdmlsl2	v0.2d, v0.4s, v0.4s
	sqdmlsl2	v31.2d, v31.4s, v31.4s

positive: sqdmulh instruction

	sqdmulh	h0, h0, v0.h[0]
	sqdmulh	h31, h31, v15.h[7]
	sqdmulh	s0, s0, v0.s[0]
	sqdmulh	s31, s31, v31.s[3]
	sqdmulh	v0.4h, v0.4h, v0.h[0]
	sqdmulh	v31.4h, v31.4h, v15.h[7]
	sqdmulh	v0.8h, v0.8h, v0.h[0]
	sqdmulh	v31.8h, v31.8h, v15.h[7]
	sqdmulh	v0.2s, v0.2s, v0.s[0]
	sqdmulh	v31.2s, v31.2s, v31.s[3]
	sqdmulh	v0.4s, v0.4s, v0.s[0]
	sqdmulh	v31.4s, v31.4s, v31.s[3]
	sqdmulh	h0, h0, h0
	sqdmulh	h31, h31, h31
	sqdmulh	s0, s0, s0
	sqdmulh	s31, s31, s31
	sqdmulh	v0.4h, v0.4h, v0.4h
	sqdmulh	v31.4h, v31.4h, v31.4h
	sqdmulh	v0.8h, v0.8h, v0.8h
	sqdmulh	v31.8h, v31.8h, v31.8h
	sqdmulh	v0.2s, v0.2s, v0.2s
	sqdmulh	v31.2s, v31.2s, v31.2s
	sqdmulh	v0.4s, v0.4s, v0.4s
	sqdmulh	v31.4s, v31.4s, v31.4s

positive: sqdmull instruction

	sqdmull	s0, h0, v0.h[0]
	sqdmull	s31, h31, v15.h[7]
	sqdmull	d0, s0, v0.s[0]
	sqdmull	d31, s31, v31.s[3]
	sqdmull	v0.4s, v0.4h, v0.h[0]
	sqdmull	v31.4s, v31.4h, v15.h[7]
	sqdmull	v0.2d, v0.2s, v0.s[0]
	sqdmull	v31.2d, v31.2s, v31.s[3]
	sqdmull	s0, h0, h0
	sqdmull	s31, h31, h31
	sqdmull	d0, s0, s0
	sqdmull	d31, s31, s31
	sqdmull	v0.4s, v0.4h, v0.4h
	sqdmull	v31.4s, v31.4h, v31.4h
	sqdmull	v0.2d, v0.2s, v0.2s
	sqdmull	v31.2d, v31.2s, v31.2s

positive: sqdmull2 instruction

	sqdmull2	v0.4s, v0.8h, v0.h[0]
	sqdmull2	v31.4s, v31.8h, v15.h[7]
	sqdmull2	v0.2d, v0.4s, v0.s[0]
	sqdmull2	v31.2d, v31.4s, v31.s[3]
	sqdmull2	v0.4s, v0.8h, v0.8h
	sqdmull2	v31.4s, v31.8h, v31.8h
	sqdmull2	v0.2d, v0.4s, v0.4s
	sqdmull2	v31.2d, v31.4s, v31.4s

positive: sqneg instruction

	sqneg	b0, b0
	sqneg	b31, b31
	sqneg	h0, h0
	sqneg	h31, h31
	sqneg	s0, s0
	sqneg	s31, s31
	sqneg	d0, d0
	sqneg	d31, d31
	sqneg	v0.8b, v0.8b
	sqneg	v31.8b, v31.8b
	sqneg	v0.16b, v0.16b
	sqneg	v31.16b, v31.16b
	sqneg	v0.4h, v0.4h
	sqneg	v31.4h, v31.4h
	sqneg	v0.8h, v0.8h
	sqneg	v31.8h, v31.8h
	sqneg	v0.2s, v0.2s
	sqneg	v31.2s, v31.2s
	sqneg	v0.4s, v0.4s
	sqneg	v31.4s, v31.4s
	sqneg	v0.2d, v0.2d
	sqneg	v31.2d, v31.2d

positive: sqrdmlah instruction

	sqrdmlah	h0, h0, v0.h[0]
	sqrdmlah	h31, h31, v15.h[7]
	sqrdmlah	s0, s0, v0.s[0]
	sqrdmlah	s31, s31, v31.s[3]
	sqrdmlah	v0.4h, v0.4h, v0.h[0]
	sqrdmlah	v31.4h, v31.4h, v15.h[7]
	sqrdmlah	v0.8h, v0.8h, v0.h[0]
	sqrdmlah	v31.8h, v31.8h, v15.h[7]
	sqrdmlah	v0.2s, v0.2s, v0.s[0]
	sqrdmlah	v31.2s, v31.2s, v31.s[3]
	sqrdmlah	v0.4s, v0.4s, v0.s[0]
	sqrdmlah	v31.4s, v31.4s, v31.s[3]
	sqrdmlah	h0, h0, h0
	sqrdmlah	h31, h31, h31
	sqrdmlah	s0, s0, s0
	sqrdmlah	s31, s31, s31
	sqrdmlah	v0.4h, v0.4h, v0.4h
	sqrdmlah	v31.4h, v31.4h, v31.4h
	sqrdmlah	v0.8h, v0.8h, v0.8h
	sqrdmlah	v31.8h, v31.8h, v31.8h
	sqrdmlah	v0.2s, v0.2s, v0.2s
	sqrdmlah	v31.2s, v31.2s, v31.2s
	sqrdmlah	v0.4s, v0.4s, v0.4s
	sqrdmlah	v31.4s, v31.4s, v31.4s

positive: sqrdmlsh instruction

	sqrdmlsh	h0, h0, v0.h[0]
	sqrdmlsh	h31, h31, v15.h[7]
	sqrdmlsh	s0, s0, v0.s[0]
	sqrdmlsh	s31, s31, v31.s[3]
	sqrdmlsh	v0.4h, v0.4h, v0.h[0]
	sqrdmlsh	v31.4h, v31.4h, v15.h[7]
	sqrdmlsh	v0.8h, v0.8h, v0.h[0]
	sqrdmlsh	v31.8h, v31.8h, v15.h[7]
	sqrdmlsh	v0.2s, v0.2s, v0.s[0]
	sqrdmlsh	v31.2s, v31.2s, v31.s[3]
	sqrdmlsh	v0.4s, v0.4s, v0.s[0]
	sqrdmlsh	v31.4s, v31.4s, v31.s[3]
	sqrdmlsh	h0, h0, h0
	sqrdmlsh	h31, h31, h31
	sqrdmlsh	s0, s0, s0
	sqrdmlsh	s31, s31, s31
	sqrdmlsh	v0.4h, v0.4h, v0.4h
	sqrdmlsh	v31.4h, v31.4h, v31.4h
	sqrdmlsh	v0.8h, v0.8h, v0.8h
	sqrdmlsh	v31.8h, v31.8h, v31.8h
	sqrdmlsh	v0.2s, v0.2s, v0.2s
	sqrdmlsh	v31.2s, v31.2s, v31.2s
	sqrdmlsh	v0.4s, v0.4s, v0.4s
	sqrdmlsh	v31.4s, v31.4s, v31.4s

positive: sqrdmulh instruction

	sqrdmulh	h0, h0, v0.h[0]
	sqrdmulh	h31, h31, v15.h[7]
	sqrdmulh	s0, s0, v0.s[0]
	sqrdmulh	s31, s31, v31.s[3]
	sqrdmulh	v0.4h, v0.4h, v0.h[0]
	sqrdmulh	v31.4h, v31.4h, v15.h[7]
	sqrdmulh	v0.8h, v0.8h, v0.h[0]
	sqrdmulh	v31.8h, v31.8h, v15.h[7]
	sqrdmulh	v0.2s, v0.2s, v0.s[0]
	sqrdmulh	v31.2s, v31.2s, v31.s[3]
	sqrdmulh	v0.4s, v0.4s, v0.s[0]
	sqrdmulh	v31.4s, v31.4s, v31.s[3]
	sqrdmulh	h0, h0, h0
	sqrdmulh	h31, h31, h31
	sqrdmulh	s0, s0, s0
	sqrdmulh	s31, s31, s31
	sqrdmulh	v0.4h, v0.4h, v0.4h
	sqrdmulh	v31.4h, v31.4h, v31.4h
	sqrdmulh	v0.8h, v0.8h, v0.8h
	sqrdmulh	v31.8h, v31.8h, v31.8h
	sqrdmulh	v0.2s, v0.2s, v0.2s
	sqrdmulh	v31.2s, v31.2s, v31.2s
	sqrdmulh	v0.4s, v0.4s, v0.4s
	sqrdmulh	v31.4s, v31.4s, v31.4s

positive: sqrshl instruction

	sqrshl	b0, b0, b0
	sqrshl	b31, b31, b31
	sqrshl	h0, h0, h0
	sqrshl	h31, h31, h31
	sqrshl	s0, s0, s0
	sqrshl	s31, s31, s31
	sqrshl	d0, d0, d0
	sqrshl	d31, d31, d31
	sqrshl	v0.8b, v0.8b, v0.8b
	sqrshl	v31.8b, v31.8b, v31.8b
	sqrshl	v0.16b, v0.16b, v0.16b
	sqrshl	v31.16b, v31.16b, v31.16b
	sqrshl	v0.4h, v0.4h, v0.4h
	sqrshl	v31.4h, v31.4h, v31.4h
	sqrshl	v0.8h, v0.8h, v0.8h
	sqrshl	v31.8h, v31.8h, v31.8h
	sqrshl	v0.2s, v0.2s, v0.2s
	sqrshl	v31.2s, v31.2s, v31.2s
	sqrshl	v0.4s, v0.4s, v0.4s
	sqrshl	v31.4s, v31.4s, v31.4s
	sqrshl	v0.2d, v0.2d, v0.2d
	sqrshl	v31.2d, v31.2d, v31.2d

positive: sqrshrn instruction

	sqrshrn	b0, h0, 1
	sqrshrn	b31, h31, 8
	sqrshrn	h0, s0, 1
	sqrshrn	h31, s31, 16
	sqrshrn	s0, d0, 1
	sqrshrn	s31, d31, 32
	sqrshrn	v0.8b, v0.8h, 1
	sqrshrn	v31.8b, v31.8h, 8
	sqrshrn	v0.4h, v0.4s, 1
	sqrshrn	v31.4h, v31.4s, 16
	sqrshrn	v0.2s, v0.2d, 1
	sqrshrn	v31.2s, v31.2d, 32

positive: sqrshrn2 instruction

	sqrshrn2	v0.16b, v0.8h, 1
	sqrshrn2	v31.16b, v31.8h, 8
	sqrshrn2	v0.8h, v0.4s, 1
	sqrshrn2	v31.8h, v31.4s, 16
	sqrshrn2	v0.4s, v0.2d, 1
	sqrshrn2	v31.4s, v31.2d, 32

positive: sqrshrun instruction

	sqrshrun	b0, h0, 1
	sqrshrun	b31, h31, 8
	sqrshrun	h0, s0, 1
	sqrshrun	h31, s31, 16
	sqrshrun	s0, d0, 1
	sqrshrun	s31, d31, 32
	sqrshrun	v0.8b, v0.8h, 1
	sqrshrun	v31.8b, v31.8h, 8
	sqrshrun	v0.4h, v0.4s, 1
	sqrshrun	v31.4h, v31.4s, 16
	sqrshrun	v0.2s, v0.2d, 1
	sqrshrun	v31.2s, v31.2d, 32

positive: sqrshrun2 instruction

	sqrshrun2	v0.16b, v0.8h, 1
	sqrshrun2	v31.16b, v31.8h, 8
	sqrshrun2	v0.8h, v0.4s, 1
	sqrshrun2	v31.8h, v31.4s, 16
	sqrshrun2	v0.4s, v0.2d, 1
	sqrshrun2	v31.4s, v31.2d, 32

positive: sqshl instruction

	sqshl	b0, b0, 0
	sqshl	b31, b31, 7
	sqshl	h0, h0, 0
	sqshl	h31, h31, 15
	sqshl	s0, s0, 0
	sqshl	s31, s31, 31
	sqshl	d0, d0, 0
	sqshl	d31, d31, 63
	sqshl	v0.8b, v0.8b, 0
	sqshl	v31.8b, v31.8b, 7
	sqshl	v0.16b, v0.16b, 0
	sqshl	v31.16b, v31.16b, 7
	sqshl	v0.4h, v0.4h, 0
	sqshl	v31.4h, v31.4h, 15
	sqshl	v0.8h, v0.8h, 0
	sqshl	v31.8h, v31.8h, 15
	sqshl	v0.2s, v0.2s, 0
	sqshl	v31.2s, v31.2s, 31
	sqshl	v0.4s, v0.4s, 0
	sqshl	v31.4s, v31.4s, 31
	sqshl	v0.2d, v0.2d, 0
	sqshl	v31.2d, v31.2d, 63
	sqshl	b0, b0, b0
	sqshl	b31, b31, b31
	sqshl	h0, h0, h0
	sqshl	h31, h31, h31
	sqshl	s0, s0, s0
	sqshl	s31, s31, s31
	sqshl	d0, d0, d0
	sqshl	d31, d31, d31
	sqshl	v0.8b, v0.8b, v0.8b
	sqshl	v31.8b, v31.8b, v31.8b
	sqshl	v0.16b, v0.16b, v0.16b
	sqshl	v31.16b, v31.16b, v31.16b
	sqshl	v0.4h, v0.4h, v0.4h
	sqshl	v31.4h, v31.4h, v31.4h
	sqshl	v0.8h, v0.8h, v0.8h
	sqshl	v31.8h, v31.8h, v31.8h
	sqshl	v0.2s, v0.2s, v0.2s
	sqshl	v31.2s, v31.2s, v31.2s
	sqshl	v0.4s, v0.4s, v0.4s
	sqshl	v31.4s, v31.4s, v31.4s
	sqshl	v0.2d, v0.2d, v0.2d
	sqshl	v31.2d, v31.2d, v31.2d

positive: sqshlu instruction

	sqshlu	b0, b0, 0
	sqshlu	b31, b31, 7
	sqshlu	h0, h0, 0
	sqshlu	h31, h31, 15
	sqshlu	s0, s0, 0
	sqshlu	s31, s31, 31
	sqshlu	d0, d0, 0
	sqshlu	d31, d31, 63
	sqshlu	v0.8b, v0.8b, 0
	sqshlu	v31.8b, v31.8b, 7
	sqshlu	v0.16b, v0.16b, 0
	sqshlu	v31.16b, v31.16b, 7
	sqshlu	v0.4h, v0.4h, 0
	sqshlu	v31.4h, v31.4h, 15
	sqshlu	v0.8h, v0.8h, 0
	sqshlu	v31.8h, v31.8h, 15
	sqshlu	v0.2s, v0.2s, 0
	sqshlu	v31.2s, v31.2s, 31
	sqshlu	v0.4s, v0.4s, 0
	sqshlu	v31.4s, v31.4s, 31
	sqshlu	v0.2d, v0.2d, 0
	sqshlu	v31.2d, v31.2d, 63

positive: sqshrn instruction

	sqshrn	b0, h0, 1
	sqshrn	b31, h31, 8
	sqshrn	h0, s0, 1
	sqshrn	h31, s31, 16
	sqshrn	s0, d0, 1
	sqshrn	s31, d31, 32
	sqshrn	v0.8b, v0.8h, 1
	sqshrn	v31.8b, v31.8h, 8
	sqshrn	v0.4h, v0.4s, 1
	sqshrn	v31.4h, v31.4s, 16
	sqshrn	v0.2s, v0.2d, 1
	sqshrn	v31.2s, v31.2d, 32

positive: sqshrn2 instruction

	sqshrn2	v0.16b, v0.8h, 1
	sqshrn2	v31.16b, v31.8h, 8
	sqshrn2	v0.8h, v0.4s, 1
	sqshrn2	v31.8h, v31.4s, 16
	sqshrn2	v0.4s, v0.2d, 1
	sqshrn2	v31.4s, v31.2d, 32

positive: sqshrun instruction

	sqshrun	b0, h0, 1
	sqshrun	b31, h31, 8
	sqshrun	h0, s0, 1
	sqshrun	h31, s31, 16
	sqshrun	s0, d0, 1
	sqshrun	s31, d31, 32
	sqshrun	v0.8b, v0.8h, 1
	sqshrun	v31.8b, v31.8h, 8
	sqshrun	v0.4h, v0.4s, 1
	sqshrun	v31.4h, v31.4s, 16
	sqshrun	v0.2s, v0.2d, 1
	sqshrun	v31.2s, v31.2d, 32

positive: sqshrun2 instruction

	sqshrun2	v0.16b, v0.8h, 1
	sqshrun2	v31.16b, v31.8h, 8
	sqshrun2	v0.8h, v0.4s, 1
	sqshrun2	v31.8h, v31.4s, 16
	sqshrun2	v0.4s, v0.2d, 1
	sqshrun2	v31.4s, v31.2d, 32

positive: sqsub instruction

	sqsub	b0, b0, b0
	sqsub	b31, b31, b31
	sqsub	h0, h0, h0
	sqsub	h31, h31, h31
	sqsub	s0, s0, s0
	sqsub	s31, s31, s31
	sqsub	d0, d0, d0
	sqsub	d31, d31, d31
	sqsub	v0.8b, v0.8b, v0.8b
	sqsub	v31.8b, v31.8b, v31.8b
	sqsub	v0.16b, v0.16b, v0.16b
	sqsub	v31.16b, v31.16b, v31.16b
	sqsub	v0.4h, v0.4h, v0.4h
	sqsub	v31.4h, v31.4h, v31.4h
	sqsub	v0.8h, v0.8h, v0.8h
	sqsub	v31.8h, v31.8h, v31.8h
	sqsub	v0.2s, v0.2s, v0.2s
	sqsub	v31.2s, v31.2s, v31.2s
	sqsub	v0.4s, v0.4s, v0.4s
	sqsub	v31.4s, v31.4s, v31.4s
	sqsub	v0.2d, v0.2d, v0.2d
	sqsub	v31.2d, v31.2d, v31.2d

positive: sqxtn instruction

	sqxtn	b0, h0
	sqxtn	b31, h31
	sqxtn	h0, s0
	sqxtn	h31, s31
	sqxtn	s0, d0
	sqxtn	s31, d31
	sqxtn	v0.8b, v0.8h
	sqxtn	v31.8b, v31.8h
	sqxtn	v0.4h, v0.4s
	sqxtn	v31.4h, v31.4s
	sqxtn	v0.2s, v0.2d
	sqxtn	v31.2s, v31.2d

positive: sqxtn2 instruction

	sqxtn2	v0.16b, v0.8h
	sqxtn2	v31.16b, v31.8h
	sqxtn2	v0.8h, v0.4s
	sqxtn2	v31.8h, v31.4s
	sqxtn2	v0.4s, v0.2d
	sqxtn2	v31.4s, v31.2d

positive: sqxtun instruction

	sqxtun	b0, h0
	sqxtun	b31, h31
	sqxtun	h0, s0
	sqxtun	h31, s31
	sqxtun	s0, d0
	sqxtun	s31, d31
	sqxtun	v0.8b, v0.8h
	sqxtun	v31.8b, v31.8h
	sqxtun	v0.4h, v0.4s
	sqxtun	v31.4h, v31.4s
	sqxtun	v0.2s, v0.2d
	sqxtun	v31.2s, v31.2d

positive: sqxtun2 instruction

	sqxtun2	v0.16b, v0.8h
	sqxtun2	v31.16b, v31.8h
	sqxtun2	v0.8h, v0.4s
	sqxtun2	v31.8h, v31.4s
	sqxtun2	v0.4s, v0.2d
	sqxtun2	v31.4s, v31.2d

positive: srhadd instruction

	srhadd	v0.8b, v0.8b, v0.8b
	srhadd	v31.8b, v31.8b, v31.8b
	srhadd	v0.16b, v0.16b, v0.16b
	srhadd	v31.16b, v31.16b, v31.16b
	srhadd	v0.4h, v0.4h, v0.4h
	srhadd	v31.4h, v31.4h, v31.4h
	srhadd	v0.8h, v0.8h, v0.8h
	srhadd	v31.8h, v31.8h, v31.8h
	srhadd	v0.2s, v0.2s, v0.2s
	srhadd	v31.2s, v31.2s, v31.2s
	srhadd	v0.4s, v0.4s, v0.4s
	srhadd	v31.4s, v31.4s, v31.4s

positive: sri instruction

	sri	d0, d0, 1
	sri	d31, d31, 64
	sri	v0.8b, v0.8b, 1
	sri	v31.8b, v31.8b, 8
	sri	v0.16b, v0.16b, 1
	sri	v31.16b, v31.16b, 8
	sri	v0.4h, v0.4h, 1
	sri	v31.4h, v31.4h, 16
	sri	v0.8h, v0.8h, 1
	sri	v31.8h, v31.8h, 16
	sri	v0.2s, v0.2s, 1
	sri	v31.2s, v31.2s, 32
	sri	v0.4s, v0.4s, 1
	sri	v31.4s, v31.4s, 32
	sri	v0.2d, v0.2d, 1
	sri	v31.2d, v31.2d, 64

positive: srshl instruction

	srshl	d0, d0, d0
	srshl	d31, d31, d31
	srshl	v0.8b, v0.8b, v0.8b
	srshl	v31.8b, v31.8b, v31.8b
	srshl	v0.16b, v0.16b, v0.16b
	srshl	v31.16b, v31.16b, v31.16b
	srshl	v0.4h, v0.4h, v0.4h
	srshl	v31.4h, v31.4h, v31.4h
	srshl	v0.8h, v0.8h, v0.8h
	srshl	v31.8h, v31.8h, v31.8h
	srshl	v0.2s, v0.2s, v0.2s
	srshl	v31.2s, v31.2s, v31.2s
	srshl	v0.4s, v0.4s, v0.4s
	srshl	v31.4s, v31.4s, v31.4s
	srshl	v0.2d, v0.2d, v0.2d
	srshl	v31.2d, v31.2d, v31.2d

positive: srshr instruction

	srshr	d0, d0, 1
	srshr	d31, d31, 64
	srshr	v0.8b, v0.8b, 1
	srshr	v31.8b, v31.8b, 8
	srshr	v0.16b, v0.16b, 1
	srshr	v31.16b, v31.16b, 8
	srshr	v0.4h, v0.4h, 1
	srshr	v31.4h, v31.4h, 16
	srshr	v0.8h, v0.8h, 1
	srshr	v31.8h, v31.8h, 16
	srshr	v0.2s, v0.2s, 1
	srshr	v31.2s, v31.2s, 32
	srshr	v0.4s, v0.4s, 1
	srshr	v31.4s, v31.4s, 32
	srshr	v0.2d, v0.2d, 1
	srshr	v31.2d, v31.2d, 64

positive: srsra instruction

	srsra	d0, d0, 1
	srsra	d31, d31, 64
	srsra	v0.8b, v0.8b, 1
	srsra	v31.8b, v31.8b, 8
	srsra	v0.16b, v0.16b, 1
	srsra	v31.16b, v31.16b, 8
	srsra	v0.4h, v0.4h, 1
	srsra	v31.4h, v31.4h, 16
	srsra	v0.8h, v0.8h, 1
	srsra	v31.8h, v31.8h, 16
	srsra	v0.2s, v0.2s, 1
	srsra	v31.2s, v31.2s, 32
	srsra	v0.4s, v0.4s, 1
	srsra	v31.4s, v31.4s, 32
	srsra	v0.2d, v0.2d, 1
	srsra	v31.2d, v31.2d, 64

positive: sshl instruction

	sshl	d0, d0, d0
	sshl	d31, d31, d31
	sshl	v0.8b, v0.8b, v0.8b
	sshl	v31.8b, v31.8b, v31.8b
	sshl	v0.16b, v0.16b, v0.16b
	sshl	v31.16b, v31.16b, v31.16b
	sshl	v0.4h, v0.4h, v0.4h
	sshl	v31.4h, v31.4h, v31.4h
	sshl	v0.8h, v0.8h, v0.8h
	sshl	v31.8h, v31.8h, v31.8h
	sshl	v0.2s, v0.2s, v0.2s
	sshl	v31.2s, v31.2s, v31.2s
	sshl	v0.4s, v0.4s, v0.4s
	sshl	v31.4s, v31.4s, v31.4s
	sshl	v0.2d, v0.2d, v0.2d
	sshl	v31.2d, v31.2d, v31.2d

positive: sshll instruction

	sshll	v0.8h, v0.8b, 0
	sshll	v31.8h, v31.8b, 7
	sshll	v0.4s, v0.4h, 0
	sshll	v31.4s, v31.4h, 15
	sshll	v0.2d, v0.2s, 0
	sshll	v31.2d, v31.2s, 31

positive: sshll2 instruction

	sshll2	v0.8h, v0.16b, 0
	sshll2	v31.8h, v31.16b, 7
	sshll2	v0.4s, v0.8h, 0
	sshll2	v31.4s, v31.8h, 15
	sshll2	v0.2d, v0.4s, 0
	sshll2	v31.2d, v31.4s, 31

positive: sshr instruction

	sshr	d0, d0, 1
	sshr	d31, d31, 64
	sshr	v0.8b, v0.8b, 1
	sshr	v31.8b, v31.8b, 8
	sshr	v0.16b, v0.16b, 1
	sshr	v31.16b, v31.16b, 8
	sshr	v0.4h, v0.4h, 1
	sshr	v31.4h, v31.4h, 16
	sshr	v0.8h, v0.8h, 1
	sshr	v31.8h, v31.8h, 16
	sshr	v0.2s, v0.2s, 1
	sshr	v31.2s, v31.2s, 32
	sshr	v0.4s, v0.4s, 1
	sshr	v31.4s, v31.4s, 32
	sshr	v0.2d, v0.2d, 1
	sshr	v31.2d, v31.2d, 64

positive: ssra instruction

	ssra	d0, d0, 1
	ssra	d31, d31, 64
	ssra	v0.8b, v0.8b, 1
	ssra	v31.8b, v31.8b, 8
	ssra	v0.16b, v0.16b, 1
	ssra	v31.16b, v31.16b, 8
	ssra	v0.4h, v0.4h, 1
	ssra	v31.4h, v31.4h, 16
	ssra	v0.8h, v0.8h, 1
	ssra	v31.8h, v31.8h, 16
	ssra	v0.2s, v0.2s, 1
	ssra	v31.2s, v31.2s, 32
	ssra	v0.4s, v0.4s, 1
	ssra	v31.4s, v31.4s, 32
	ssra	v0.2d, v0.2d, 1
	ssra	v31.2d, v31.2d, 64

positive: ssubl instruction

	ssubl	v0.8h, v0.8b, v0.8b
	ssubl	v31.8h, v31.8b, v31.8b
	ssubl	v0.4s, v0.4h, v0.4h
	ssubl	v31.4s, v31.4h, v31.4h
	ssubl	v0.2d, v0.2s, v0.2s
	ssubl	v31.2d, v31.2s, v31.2s

positive: ssubl2 instruction

	ssubl2	v0.8h, v0.16b, v0.16b
	ssubl2	v31.8h, v31.16b, v31.16b
	ssubl2	v0.4s, v0.8h, v0.8h
	ssubl2	v31.4s, v31.8h, v31.8h
	ssubl2	v0.2d, v0.4s, v0.4s
	ssubl2	v31.2d, v31.4s, v31.4s

positive: ssubw instruction

	ssubw	v0.8h, v0.8h, v0.8b
	ssubw	v31.8h, v31.8h, v31.8b
	ssubw	v0.4s, v0.4s, v0.4h
	ssubw	v31.4s, v31.4s, v31.4h
	ssubw	v0.2d, v0.2d, v0.2s
	ssubw	v31.2d, v31.2d, v31.2s

positive: ssubw2 instruction

	ssubw2	v0.8h, v0.8h, v0.16b
	ssubw2	v31.8h, v31.8h, v31.16b
	ssubw2	v0.4s, v0.4s, v0.8h
	ssubw2	v31.4s, v31.4s, v31.8h
	ssubw2	v0.2d, v0.2d, v0.4s
	ssubw2	v31.2d, v31.2d, v31.4s

positive: st1 instruction

	st1	{v0.8b}, [x0]
	st1	{v31.8b}, [sp]
	st1	{v0.16b}, [x0]
	st1	{v31.16b}, [sp]
	st1	{v0.4h}, [x0]
	st1	{v31.4h}, [sp]
	st1	{v0.8h}, [x0]
	st1	{v31.8h}, [sp]
	st1	{v0.2s}, [x0]
	st1	{v31.2s}, [sp]
	st1	{v0.4s}, [x0]
	st1	{v31.4s}, [sp]
	st1	{v0.1d}, [x0]
	st1	{v31.1d}, [sp]
	st1	{v0.2d}, [x0]
	st1	{v31.2d}, [sp]
	st1	{v0.8b, v1.8b}, [x0]
	st1	{v31.8b, v0.8b}, [sp]
	st1	{v0.16b, v1.16b}, [x0]
	st1	{v31.16b, v0.16b}, [sp]
	st1	{v0.4h, v1.4h}, [x0]
	st1	{v31.4h, v0.4h}, [sp]
	st1	{v0.8h, v1.8h}, [x0]
	st1	{v31.8h, v0.8h}, [sp]
	st1	{v0.2s, v1.2s}, [x0]
	st1	{v31.2s, v0.2s}, [sp]
	st1	{v0.4s, v1.4s}, [x0]
	st1	{v31.4s, v0.4s}, [sp]
	st1	{v0.1d, v1.1d}, [x0]
	st1	{v31.1d, v0.1d}, [sp]
	st1	{v0.2d, v1.2d}, [x0]
	st1	{v31.2d, v0.2d}, [sp]
	st1	{v0.8b, v1.8b, v2.8b}, [x0]
	st1	{v31.8b, v0.8b, v1.8b}, [sp]
	st1	{v0.16b, v1.16b, v2.16b}, [x0]
	st1	{v31.16b, v0.16b, v1.16b}, [sp]
	st1	{v0.4h, v1.4h, v2.4h}, [x0]
	st1	{v31.4h, v0.4h, v1.4h}, [sp]
	st1	{v0.8h, v1.8h, v2.8h}, [x0]
	st1	{v31.8h, v0.8h, v1.8h}, [sp]
	st1	{v0.2s, v1.2s, v2.2s}, [x0]
	st1	{v31.2s, v0.2s, v1.2s}, [sp]
	st1	{v0.4s, v1.4s, v2.4s}, [x0]
	st1	{v31.4s, v0.4s, v1.4s}, [sp]
	st1	{v0.1d, v1.1d, v2.1d}, [x0]
	st1	{v31.1d, v0.1d, v1.1d}, [sp]
	st1	{v0.2d, v1.2d, v2.2d}, [x0]
	st1	{v31.2d, v0.2d, v1.2d}, [sp]
	st1	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0]
	st1	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp]
	st1	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0]
	st1	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp]
	st1	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0]
	st1	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp]
	st1	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0]
	st1	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp]
	st1	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0]
	st1	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp]
	st1	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0]
	st1	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp]
	st1	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0]
	st1	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp]
	st1	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0]
	st1	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp]
	st1	{v0.8b}, [x0], 8
	st1	{v31.8b}, [sp], 8
	st1	{v0.16b}, [x0], 16
	st1	{v31.16b}, [sp], 16
	st1	{v0.4h}, [x0], 8
	st1	{v31.4h}, [sp], 8
	st1	{v0.8h}, [x0], 16
	st1	{v31.8h}, [sp], 16
	st1	{v0.2s}, [x0], 8
	st1	{v31.2s}, [sp], 8
	st1	{v0.4s}, [x0], 16
	st1	{v31.4s}, [sp], 16
	st1	{v0.1d}, [x0], 8
	st1	{v31.1d}, [sp], 8
	st1	{v0.2d}, [x0], 16
	st1	{v31.2d}, [sp], 16
	st1	{v0.8b}, [x0], x0
	st1	{v31.8b}, [sp], x30
	st1	{v0.16b}, [x0], x0
	st1	{v31.16b}, [sp], x30
	st1	{v0.4h}, [x0], x0
	st1	{v31.4h}, [sp], x30
	st1	{v0.8h}, [x0], x0
	st1	{v31.8h}, [sp], x30
	st1	{v0.2s}, [x0], x0
	st1	{v31.2s}, [sp], x30
	st1	{v0.4s}, [x0], x0
	st1	{v31.4s}, [sp], x30
	st1	{v0.1d}, [x0], x0
	st1	{v31.1d}, [sp], x30
	st1	{v0.2d}, [x0], x0
	st1	{v31.2d}, [sp], x30
	st1	{v0.8b, v1.8b}, [x0], 16
	st1	{v31.8b, v0.8b}, [sp], 16
	st1	{v0.16b, v1.16b}, [x0], 32
	st1	{v31.16b, v0.16b}, [sp], 32
	st1	{v0.4h, v1.4h}, [x0], 16
	st1	{v31.4h, v0.4h}, [sp], 16
	st1	{v0.8h, v1.8h}, [x0], 32
	st1	{v31.8h, v0.8h}, [sp], 32
	st1	{v0.2s, v1.2s}, [x0], 16
	st1	{v31.2s, v0.2s}, [sp], 16
	st1	{v0.4s, v1.4s}, [x0], 32
	st1	{v31.4s, v0.4s}, [sp], 32
	st1	{v0.1d, v1.1d}, [x0], 16
	st1	{v31.1d, v0.1d}, [sp], 16
	st1	{v0.2d, v1.2d}, [x0], 32
	st1	{v31.2d, v0.2d}, [sp], 32
	st1	{v0.8b, v1.8b}, [x0], x0
	st1	{v31.8b, v0.8b}, [sp], x30
	st1	{v0.16b, v1.16b}, [x0], x0
	st1	{v31.16b, v0.16b}, [sp], x30
	st1	{v0.4h, v1.4h}, [x0], x0
	st1	{v31.4h, v0.4h}, [sp], x30
	st1	{v0.8h, v1.8h}, [x0], x0
	st1	{v31.8h, v0.8h}, [sp], x30
	st1	{v0.2s, v1.2s}, [x0], x0
	st1	{v31.2s, v0.2s}, [sp], x30
	st1	{v0.4s, v1.4s}, [x0], x0
	st1	{v31.4s, v0.4s}, [sp], x30
	st1	{v0.1d, v1.1d}, [x0], x0
	st1	{v31.1d, v0.1d}, [sp], x30
	st1	{v0.2d, v1.2d}, [x0], x0
	st1	{v31.2d, v0.2d}, [sp], x30
	st1	{v0.8b, v1.8b, v2.8b}, [x0], 24
	st1	{v31.8b, v0.8b, v1.8b}, [sp], 24
	st1	{v0.16b, v1.16b, v2.16b}, [x0], 48
	st1	{v31.16b, v0.16b, v1.16b}, [sp], 48
	st1	{v0.4h, v1.4h, v2.4h}, [x0], 24
	st1	{v31.4h, v0.4h, v1.4h}, [sp], 24
	st1	{v0.8h, v1.8h, v2.8h}, [x0], 48
	st1	{v31.8h, v0.8h, v1.8h}, [sp], 48
	st1	{v0.2s, v1.2s, v2.2s}, [x0], 24
	st1	{v31.2s, v0.2s, v1.2s}, [sp], 24
	st1	{v0.4s, v1.4s, v2.4s}, [x0], 48
	st1	{v31.4s, v0.4s, v1.4s}, [sp], 48
	st1	{v0.1d, v1.1d, v2.1d}, [x0], 24
	st1	{v31.1d, v0.1d, v1.1d}, [sp], 24
	st1	{v0.2d, v1.2d, v2.2d}, [x0], 48
	st1	{v31.2d, v0.2d, v1.2d}, [sp], 48
	st1	{v0.8b, v1.8b, v2.8b}, [x0], x0
	st1	{v31.8b, v0.8b, v1.8b}, [sp], x30
	st1	{v0.16b, v1.16b, v2.16b}, [x0], x0
	st1	{v31.16b, v0.16b, v1.16b}, [sp], x30
	st1	{v0.4h, v1.4h, v2.4h}, [x0], x0
	st1	{v31.4h, v0.4h, v1.4h}, [sp], x30
	st1	{v0.8h, v1.8h, v2.8h}, [x0], x0
	st1	{v31.8h, v0.8h, v1.8h}, [sp], x30
	st1	{v0.2s, v1.2s, v2.2s}, [x0], x0
	st1	{v31.2s, v0.2s, v1.2s}, [sp], x30
	st1	{v0.4s, v1.4s, v2.4s}, [x0], x0
	st1	{v31.4s, v0.4s, v1.4s}, [sp], x30
	st1	{v0.1d, v1.1d, v2.1d}, [x0], x0
	st1	{v31.1d, v0.1d, v1.1d}, [sp], x30
	st1	{v0.2d, v1.2d, v2.2d}, [x0], x0
	st1	{v31.2d, v0.2d, v1.2d}, [sp], x30
	st1	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0], 32
	st1	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp], 32
	st1	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0], 64
	st1	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp], 64
	st1	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0], 32
	st1	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp], 32
	st1	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0], 64
	st1	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp], 64
	st1	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0], 32
	st1	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp], 32
	st1	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0], 64
	st1	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp], 64
	st1	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0], 32
	st1	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp], 32
	st1	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0], 64
	st1	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp], 64
	st1	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0], x0
	st1	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp], x30
	st1	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0], x0
	st1	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp], x30
	st1	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0], x0
	st1	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp], x30
	st1	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0], x0
	st1	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp], x30
	st1	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0], x0
	st1	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp], x30
	st1	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0], x0
	st1	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp], x30
	st1	{v0.1d, v1.1d, v2.1d, v3.1d}, [x0], x0
	st1	{v31.1d, v0.1d, v1.1d, v2.1d}, [sp], x30
	st1	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0], x0
	st1	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp], x30
	st1	{v0.b}[0], [x0]
	st1	{v31.b}[15], [sp]
	st1	{v0.h}[0], [x0]
	st1	{v31.h}[7], [sp]
	st1	{v0.s}[0], [x0]
	st1	{v31.s}[3], [sp]
	st1	{v0.d}[0], [x0]
	st1	{v31.d}[1], [sp]
	st1	{v0.b}[0], [x0], 1
	st1	{v31.b}[15], [sp], 1
	st1	{v0.b}[0], [x0], x0
	st1	{v31.b}[15], [sp], x30
	st1	{v0.h}[0], [x0], 2
	st1	{v31.h}[7], [sp], 2
	st1	{v0.h}[0], [x0], x0
	st1	{v31.h}[7], [sp], x30
	st1	{v0.s}[0], [x0], 4
	st1	{v31.s}[3], [sp], 4
	st1	{v0.s}[0], [x0], x0
	st1	{v31.s}[3], [sp], x30
	st1	{v0.d}[0], [x0], 8
	st1	{v31.d}[1], [sp], 8
	st1	{v0.d}[0], [x0], x0
	st1	{v31.d}[1], [sp], x30

positive: st2 instruction

	st2	{v0.8b, v1.8b}, [x0]
	st2	{v31.8b, v0.8b}, [sp]
	st2	{v0.16b, v1.16b}, [x0]
	st2	{v31.16b, v0.16b}, [sp]
	st2	{v0.4h, v1.4h}, [x0]
	st2	{v31.4h, v0.4h}, [sp]
	st2	{v0.8h, v1.8h}, [x0]
	st2	{v31.8h, v0.8h}, [sp]
	st2	{v0.2s, v1.2s}, [x0]
	st2	{v31.2s, v0.2s}, [sp]
	st2	{v0.4s, v1.4s}, [x0]
	st2	{v31.4s, v0.4s}, [sp]
	st2	{v0.2d, v1.2d}, [x0]
	st2	{v31.2d, v0.2d}, [sp]
	st2	{v0.8b, v1.8b}, [x0], 16
	st2	{v31.8b, v0.8b}, [sp], 16
	st2	{v0.16b, v1.16b}, [x0], 32
	st2	{v31.16b, v0.16b}, [sp], 32
	st2	{v0.4h, v1.4h}, [x0], 16
	st2	{v31.4h, v0.4h}, [sp], 16
	st2	{v0.8h, v1.8h}, [x0], 32
	st2	{v31.8h, v0.8h}, [sp], 32
	st2	{v0.2s, v1.2s}, [x0], 16
	st2	{v31.2s, v0.2s}, [sp], 16
	st2	{v0.4s, v1.4s}, [x0], 32
	st2	{v31.4s, v0.4s}, [sp], 32
	st2	{v0.2d, v1.2d}, [x0], 32
	st2	{v31.2d, v0.2d}, [sp], 32
	st2	{v0.8b, v1.8b}, [x0], x0
	st2	{v31.8b, v0.8b}, [sp], x30
	st2	{v0.16b, v1.16b}, [x0], x0
	st2	{v31.16b, v0.16b}, [sp], x30
	st2	{v0.4h, v1.4h}, [x0], x0
	st2	{v31.4h, v0.4h}, [sp], x30
	st2	{v0.8h, v1.8h}, [x0], x0
	st2	{v31.8h, v0.8h}, [sp], x30
	st2	{v0.2s, v1.2s}, [x0], x0
	st2	{v31.2s, v0.2s}, [sp], x30
	st2	{v0.4s, v1.4s}, [x0], x0
	st2	{v31.4s, v0.4s}, [sp], x30
	st2	{v0.2d, v1.2d}, [x0], x0
	st2	{v31.2d, v0.2d}, [sp], x30
	st2	{v0.b, v1.b}[0], [x0]
	st2	{v31.b, v0.b}[15], [sp]
	st2	{v0.h, v1.h}[0], [x0]
	st2	{v31.h, v0.h}[7], [sp]
	st2	{v0.s, v1.s}[0], [x0]
	st2	{v31.s, v0.s}[3], [sp]
	st2	{v0.d, v1.d}[0], [x0]
	st2	{v31.d, v0.d}[1], [sp]
	st2	{v0.b, v1.b}[0], [x0], 2
	st2	{v31.b, v0.b}[15], [sp], 2
	st2	{v0.b, v1.b}[0], [x0], x0
	st2	{v31.b, v0.b}[15], [sp], x30
	st2	{v0.h, v1.h}[0], [x0], 4
	st2	{v31.h, v0.h}[7], [sp], 4
	st2	{v0.h, v1.h}[0], [x0], x0
	st2	{v31.h, v0.h}[7], [sp], x30
	st2	{v0.s, v1.s}[0], [x0], 8
	st2	{v31.s, v0.s}[3], [sp], 8
	st2	{v0.s, v1.s}[0], [x0], x0
	st2	{v31.s, v0.s}[3], [sp], x30
	st2	{v0.d, v1.d}[0], [x0], 16
	st2	{v31.d, v0.d}[1], [sp], 16
	st2	{v0.d, v1.d}[0], [x0], x0
	st2	{v31.d, v0.d}[1], [sp], x30

positive: st3 instruction

	st3	{v0.8b, v1.8b, v2.8b}, [x0]
	st3	{v31.8b, v0.8b, v1.8b}, [sp]
	st3	{v0.16b, v1.16b, v2.16b}, [x0]
	st3	{v31.16b, v0.16b, v1.16b}, [sp]
	st3	{v0.4h, v1.4h, v2.4h}, [x0]
	st3	{v31.4h, v0.4h, v1.4h}, [sp]
	st3	{v0.8h, v1.8h, v2.8h}, [x0]
	st3	{v31.8h, v0.8h, v1.8h}, [sp]
	st3	{v0.2s, v1.2s, v2.2s}, [x0]
	st3	{v31.2s, v0.2s, v1.2s}, [sp]
	st3	{v0.4s, v1.4s, v2.4s}, [x0]
	st3	{v31.4s, v0.4s, v1.4s}, [sp]
	st3	{v0.2d, v1.2d, v2.2d}, [x0]
	st3	{v31.2d, v0.2d, v1.2d}, [sp]
	st3	{v0.8b, v1.8b, v2.8b}, [x0], 24
	st3	{v31.8b, v0.8b, v1.8b}, [sp], 24
	st3	{v0.16b, v1.16b, v2.16b}, [x0], 48
	st3	{v31.16b, v0.16b, v1.16b}, [sp], 48
	st3	{v0.4h, v1.4h, v2.4h}, [x0], 24
	st3	{v31.4h, v0.4h, v1.4h}, [sp], 24
	st3	{v0.8h, v1.8h, v2.8h}, [x0], 48
	st3	{v31.8h, v0.8h, v1.8h}, [sp], 48
	st3	{v0.2s, v1.2s, v2.2s}, [x0], 24
	st3	{v31.2s, v0.2s, v1.2s}, [sp], 24
	st3	{v0.4s, v1.4s, v2.4s}, [x0], 48
	st3	{v31.4s, v0.4s, v1.4s}, [sp], 48
	st3	{v0.2d, v1.2d, v2.2d}, [x0], 48
	st3	{v31.2d, v0.2d, v1.2d}, [sp], 48
	st3	{v0.8b, v1.8b, v2.8b}, [x0], x0
	st3	{v31.8b, v0.8b, v1.8b}, [sp], x30
	st3	{v0.16b, v1.16b, v2.16b}, [x0], x0
	st3	{v31.16b, v0.16b, v1.16b}, [sp], x30
	st3	{v0.4h, v1.4h, v2.4h}, [x0], x0
	st3	{v31.4h, v0.4h, v1.4h}, [sp], x30
	st3	{v0.8h, v1.8h, v2.8h}, [x0], x0
	st3	{v31.8h, v0.8h, v1.8h}, [sp], x30
	st3	{v0.2s, v1.2s, v2.2s}, [x0], x0
	st3	{v31.2s, v0.2s, v1.2s}, [sp], x30
	st3	{v0.4s, v1.4s, v2.4s}, [x0], x0
	st3	{v31.4s, v0.4s, v1.4s}, [sp], x30
	st3	{v0.2d, v1.2d, v2.2d}, [x0], x0
	st3	{v31.2d, v0.2d, v1.2d}, [sp], x30
	st3	{v0.b, v1.b, v2.b}[0], [x0]
	st3	{v31.b, v0.b, v1.b}[15], [sp]
	st3	{v0.h, v1.h, v2.h}[0], [x0]
	st3	{v31.h, v0.h, v1.h}[7], [sp]
	st3	{v0.s, v1.s, v2.s}[0], [x0]
	st3	{v31.s, v0.s, v1.s}[3], [sp]
	st3	{v0.d, v1.d, v2.d}[0], [x0]
	st3	{v31.d, v0.d, v1.d}[1], [sp]
	st3	{v0.b, v1.b, v2.b}[0], [x0], 3
	st3	{v31.b, v0.b, v1.b}[15], [sp], 3
	st3	{v0.b, v1.b, v2.b}[0], [x0], x0
	st3	{v31.b, v0.b, v1.b}[15], [sp], x30
	st3	{v0.h, v1.h, v2.h}[0], [x0], 6
	st3	{v31.h, v0.h, v1.h}[7], [sp], 6
	st3	{v0.h, v1.h, v2.h}[0], [x0], x0
	st3	{v31.h, v0.h, v1.h}[7], [sp], x30
	st3	{v0.s, v1.s, v2.s}[0], [x0], 12
	st3	{v31.s, v0.s, v1.s}[3], [sp], 12
	st3	{v0.s, v1.s, v2.s}[0], [x0], x0
	st3	{v31.s, v0.s, v1.s}[3], [sp], x30
	st3	{v0.d, v1.d, v2.d}[0], [x0], 24
	st3	{v31.d, v0.d, v1.d}[1], [sp], 24
	st3	{v0.d, v1.d, v2.d}[0], [x0], x0
	st3	{v31.d, v0.d, v1.d}[1], [sp], x30

positive: st4 instruction

	st4	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0]
	st4	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp]
	st4	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0]
	st4	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp]
	st4	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0]
	st4	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp]
	st4	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0]
	st4	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp]
	st4	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0]
	st4	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp]
	st4	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0]
	st4	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp]
	st4	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0]
	st4	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp]
	st4	{v0.8b, v1.8b, v2.8b, v3.8b}, [x0], 32
	st4	{v31.8b, v0.8b, v1.8b, v2.8b}, [sp], 32
	st4	{v0.16b, v1.16b, v2.16b, v3.16b}, [x0], 64
	st4	{v31.16b, v0.16b, v1.16b, v2.16b}, [sp], 64
	st4	{v0.4h, v1.4h, v2.4h, v3.4h}, [x0], 32
	st4	{v31.4h, v0.4h, v1.4h, v2.4h}, [sp], 32
	st4	{v0.8h, v1.8h, v2.8h, v3.8h}, [x0], 64
	st4	{v31.8h, v0.8h, v1.8h, v2.8h}, [sp], 64
	st4	{v0.2s, v1.2s, v2.2s, v3.2s}, [x0], 32
	st4	{v31.2s, v0.2s, v1.2s, v2.2s}, [sp], 32
	st4	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0], 64
	st4	{v31.4s, v0.4s, v1.4s, v2.4s}, [sp], 64
	st4	{v0.2d, v1.2d, v2.2d, v3.2d}, [x0], 64
	st4	{v31.2d, v0.2d, v1.2d, v2.2d}, [sp], 64
	st4	{v0.b, v1.b, v2.b, v3.b}[0], [x0]
	st4	{v31.b, v0.b, v1.b, v2.b}[15], [sp]
	st4	{v0.h, v1.h, v2.h, v3.h}[0], [x0]
	st4	{v31.h, v0.h, v1.h, v2.h}[7], [sp]
	st4	{v0.s, v1.s, v2.s, v3.s}[0], [x0]
	st4	{v31.s, v0.s, v1.s, v2.s}[3], [sp]
	st4	{v0.d, v1.d, v2.d, v3.d}[0], [x0]
	st4	{v31.d, v0.d, v1.d, v2.d}[1], [sp]
	st4	{v0.b, v1.b, v2.b, v3.b}[0], [x0], 4
	st4	{v31.b, v0.b, v1.b, v2.b}[15], [sp], 4
	st4	{v0.b, v1.b, v2.b, v3.b}[0], [x0], x0
	st4	{v31.b, v0.b, v1.b, v2.b}[15], [sp], x30
	st4	{v0.h, v1.h, v2.h, v3.h}[0], [x0], 8
	st4	{v31.h, v0.h, v1.h, v2.h}[7], [sp], 8
	st4	{v0.h, v1.h, v2.h, v3.h}[0], [x0], x0
	st4	{v31.h, v0.h, v1.h, v2.h}[7], [sp], x30
	st4	{v0.s, v1.s, v2.s, v3.s}[0], [x0], 16
	st4	{v31.s, v0.s, v1.s, v2.s}[3], [sp], 16
	st4	{v0.s, v1.s, v2.s, v3.s}[0], [x0], x0
	st4	{v31.s, v0.s, v1.s, v2.s}[3], [sp], x30
	st4	{v0.d, v1.d, v2.d, v3.d}[0], [x0], 32
	st4	{v31.d, v0.d, v1.d, v2.d}[1], [sp], 32
	st4	{v0.d, v1.d, v2.d, v3.d}[0], [x0], x0
	st4	{v31.d, v0.d, v1.d, v2.d}[1], [sp], x30

positive: subhn instruction

	subhn	v0.8b, v0.8h, v0.8h
	subhn	v31.8b, v31.8h, v31.8h
	subhn	v0.4h, v0.4s, v0.4s
	subhn	v31.4h, v31.4s, v31.4s
	subhn	v0.2s, v0.2d, v0.2d
	subhn	v31.2s, v31.2d, v31.2d

positive: subhn2 instruction

	subhn2	v0.16b, v0.8h, v0.8h
	subhn2	v31.16b, v31.8h, v31.8h
	subhn2	v0.8h, v0.4s, v0.4s
	subhn2	v31.8h, v31.4s, v31.4s
	subhn2	v0.4s, v0.2d, v0.2d
	subhn2	v31.4s, v31.2d, v31.2d

positive: suqadd instruction

	suqadd	b0, b0
	suqadd	b31, b31
	suqadd	h0, h0
	suqadd	h31, h31
	suqadd	s0, s0
	suqadd	s31, s31
	suqadd	d0, d0
	suqadd	d31, d31
	suqadd	v0.8b, v0.8b
	suqadd	v31.8b, v31.8b
	suqadd	v0.16b, v0.16b
	suqadd	v31.16b, v31.16b
	suqadd	v0.4h, v0.4h
	suqadd	v31.4h, v31.4h
	suqadd	v0.8h, v0.8h
	suqadd	v31.8h, v31.8h
	suqadd	v0.2s, v0.2s
	suqadd	v31.2s, v31.2s
	suqadd	v0.4s, v0.4s
	suqadd	v31.4s, v31.4s
	suqadd	v0.2d, v0.2d
	suqadd	v31.2d, v31.2d

positive: sxtl instruction

	sxtl	v0.8h, v0.8b
	sxtl	v31.8h, v31.8b
	sxtl	v0.4s, v0.4h
	sxtl	v31.4s, v31.4h
	sxtl	v0.2d, v0.2s
	sxtl	v31.2d, v31.2s

positive: sxtl2 instruction

	sxtl2	v0.8h, v0.16b
	sxtl2	v31.8h, v31.16b
	sxtl2	v0.4s, v0.8h
	sxtl2	v31.4s, v31.8h
	sxtl2	v0.2d, v0.4s
	sxtl2	v31.2d, v31.4s

positive: tbl instruction

	tbl	v0.8b, {v0.16b}, v0.8b
	tbl	v31.8b, {v31.16b}, v31.8b
	tbl	v0.16b, {v0.16b}, v0.16b
	tbl	v31.16b, {v31.16b}, v31.16b
	tbl	v0.8b, {v0.16b, v1.16b}, v0.8b
	tbl	v31.8b, {v31.16b, v0.16b}, v31.8b
	tbl	v0.16b, {v0.16b, v1.16b}, v0.16b
	tbl	v31.16b, {v31.16b, v0.16b}, v31.16b
	tbl	v0.8b, {v0.16b, v1.16b, v2.16b}, v0.8b
	tbl	v31.8b, {v31.16b, v0.16b, v1.16b}, v31.8b
	tbl	v0.16b, {v0.16b, v1.16b, v2.16b}, v0.16b
	tbl	v31.16b, {v31.16b, v0.16b, v1.16b}, v31.16b
	tbl	v0.8b, {v0.16b, v1.16b, v2.16b, v3.16b}, v0.8b
	tbl	v31.8b, {v31.16b, v0.16b, v1.16b, v2.16b}, v31.8b
	tbl	v0.16b, {v0.16b, v1.16b, v2.16b, v3.16b}, v0.16b
	tbl	v31.16b, {v31.16b, v0.16b, v1.16b, v2.16b}, v31.16b

positive: tbx instruction

	tbx	v0.8b, {v0.16b}, v0.8b
	tbx	v31.8b, {v31.16b}, v31.8b
	tbx	v0.16b, {v0.16b}, v0.16b
	tbx	v31.16b, {v31.16b}, v31.16b
	tbx	v0.8b, {v0.16b, v1.16b}, v0.8b
	tbx	v31.8b, {v31.16b, v0.16b}, v31.8b
	tbx	v0.16b, {v0.16b, v1.16b}, v0.16b
	tbx	v31.16b, {v31.16b, v0.16b}, v31.16b
	tbx	v0.8b, {v0.16b, v1.16b, v2.16b}, v0.8b
	tbx	v31.8b, {v31.16b, v0.16b, v1.16b}, v31.8b
	tbx	v0.16b, {v0.16b, v1.16b, v2.16b}, v0.16b
	tbx	v31.16b, {v31.16b, v0.16b, v1.16b}, v31.16b
	tbx	v0.8b, {v0.16b, v1.16b, v2.16b, v3.16b}, v0.8b
	tbx	v31.8b, {v31.16b, v0.16b, v1.16b, v2.16b}, v31.8b
	tbx	v0.16b, {v0.16b, v1.16b, v2.16b, v3.16b}, v0.16b
	tbx	v31.16b, {v31.16b, v0.16b, v1.16b, v2.16b}, v31.16b

positive: trn1 instruction

	trn1	v0.8b, v0.8b, v0.8b
	trn1	v31.8b, v31.8b, v31.8b
	trn1	v0.16b, v0.16b, v0.16b
	trn1	v31.16b, v31.16b, v31.16b
	trn1	v0.4h, v0.4h, v0.4h
	trn1	v31.4h, v31.4h, v31.4h
	trn1	v0.8h, v0.8h, v0.8h
	trn1	v31.8h, v31.8h, v31.8h
	trn1	v0.2s, v0.2s, v0.2s
	trn1	v31.2s, v31.2s, v31.2s
	trn1	v0.4s, v0.4s, v0.4s
	trn1	v31.4s, v31.4s, v31.4s
	trn1	v0.2d, v0.2d, v0.2d
	trn1	v31.2d, v31.2d, v31.2d

positive: trn2 instruction

	trn2	v0.8b, v0.8b, v0.8b
	trn2	v31.8b, v31.8b, v31.8b
	trn2	v0.16b, v0.16b, v0.16b
	trn2	v31.16b, v31.16b, v31.16b
	trn2	v0.4h, v0.4h, v0.4h
	trn2	v31.4h, v31.4h, v31.4h
	trn2	v0.8h, v0.8h, v0.8h
	trn2	v31.8h, v31.8h, v31.8h
	trn2	v0.2s, v0.2s, v0.2s
	trn2	v31.2s, v31.2s, v31.2s
	trn2	v0.4s, v0.4s, v0.4s
	trn2	v31.4s, v31.4s, v31.4s
	trn2	v0.2d, v0.2d, v0.2d
	trn2	v31.2d, v31.2d, v31.2d

positive: uaba instruction

	uaba	v0.8b, v0.8b, v0.8b
	uaba	v31.8b, v31.8b, v31.8b
	uaba	v0.16b, v0.16b, v0.16b
	uaba	v31.16b, v31.16b, v31.16b
	uaba	v0.4h, v0.4h, v0.4h
	uaba	v31.4h, v31.4h, v31.4h
	uaba	v0.8h, v0.8h, v0.8h
	uaba	v31.8h, v31.8h, v31.8h
	uaba	v0.2s, v0.2s, v0.2s
	uaba	v31.2s, v31.2s, v31.2s
	uaba	v0.4s, v0.4s, v0.4s
	uaba	v31.4s, v31.4s, v31.4s

positive: uabal instruction

	uabal	v0.8h, v0.8b, v0.8b
	uabal	v31.8h, v31.8b, v31.8b
	uabal	v0.4s, v0.4h, v0.4h
	uabal	v31.4s, v31.4h, v31.4h
	uabal	v0.2d, v0.2s, v0.2s
	uabal	v31.2d, v31.2s, v31.2s

positive: uabal2 instruction

	uabal2	v0.8h, v0.16b, v0.16b
	uabal2	v31.8h, v31.16b, v31.16b
	uabal2	v0.4s, v0.8h, v0.8h
	uabal2	v31.4s, v31.8h, v31.8h
	uabal2	v0.2d, v0.4s, v0.4s
	uabal2	v31.2d, v31.4s, v31.4s

positive: uabd instruction

	uabd	v0.8b, v0.8b, v0.8b
	uabd	v31.8b, v31.8b, v31.8b
	uabd	v0.16b, v0.16b, v0.16b
	uabd	v31.16b, v31.16b, v31.16b
	uabd	v0.4h, v0.4h, v0.4h
	uabd	v31.4h, v31.4h, v31.4h
	uabd	v0.8h, v0.8h, v0.8h
	uabd	v31.8h, v31.8h, v31.8h
	uabd	v0.2s, v0.2s, v0.2s
	uabd	v31.2s, v31.2s, v31.2s
	uabd	v0.4s, v0.4s, v0.4s
	uabd	v31.4s, v31.4s, v31.4s

positive: uabdl instruction

	uabdl	v0.8h, v0.8b, v0.8b
	uabdl	v31.8h, v31.8b, v31.8b
	uabdl	v0.4s, v0.4h, v0.4h
	uabdl	v31.4s, v31.4h, v31.4h
	uabdl	v0.2d, v0.2s, v0.2s
	uabdl	v31.2d, v31.2s, v31.2s

positive: uabdl2 instruction

	uabdl2	v0.8h, v0.16b, v0.16b
	uabdl2	v31.8h, v31.16b, v31.16b
	uabdl2	v0.4s, v0.8h, v0.8h
	uabdl2	v31.4s, v31.8h, v31.8h
	uabdl2	v0.2d, v0.4s, v0.4s
	uabdl2	v31.2d, v31.4s, v31.4s

positive: uadalp instruction

	uadalp	v0.4h, v0.8b
	uadalp	v31.4h, v31.8b
	uadalp	v0.8h, v0.16b
	uadalp	v31.8h, v31.16b
	uadalp	v0.2s, v0.4h
	uadalp	v31.2s, v31.4h
	uadalp	v0.4s, v0.8h
	uadalp	v31.4s, v31.8h
	uadalp	v0.1d, v0.2s
	uadalp	v31.1d, v31.2s
	uadalp	v0.2d, v0.4s
	uadalp	v31.2d, v31.4s

positive: uaddl instruction

	uaddl	v0.8h, v0.8b, v0.8b
	uaddl	v31.8h, v31.8b, v31.8b
	uaddl	v0.4s, v0.4h, v0.4h
	uaddl	v31.4s, v31.4h, v31.4h
	uaddl	v0.2d, v0.2s, v0.2s
	uaddl	v31.2d, v31.2s, v31.2s

positive: uaddl2 instruction

	uaddl2	v0.8h, v0.16b, v0.16b
	uaddl2	v31.8h, v31.16b, v31.16b
	uaddl2	v0.4s, v0.8h, v0.8h
	uaddl2	v31.4s, v31.8h, v31.8h
	uaddl2	v0.2d, v0.4s, v0.4s
	uaddl2	v31.2d, v31.4s, v31.4s

positive: uaddlp instruction

	uaddlp	v0.4h, v0.8b
	uaddlp	v31.4h, v31.8b
	uaddlp	v0.8h, v0.16b
	uaddlp	v31.8h, v31.16b
	uaddlp	v0.2s, v0.4h
	uaddlp	v31.2s, v31.4h
	uaddlp	v0.4s, v0.8h
	uaddlp	v31.4s, v31.8h
	uaddlp	v0.1d, v0.2s
	uaddlp	v31.1d, v31.2s
	uaddlp	v0.2d, v0.4s
	uaddlp	v31.2d, v31.4s

positive: uaddlv instruction

	uaddlv	h0, v0.8b
	uaddlv	h31, v31.8b
	uaddlv	h0, v0.16b
	uaddlv	h31, v31.16b
	uaddlv	s0, v0.4h
	uaddlv	s31, v31.4h
	uaddlv	s0, v0.8h
	uaddlv	s31, v31.8h
	uaddlv	d0, v0.4s
	uaddlv	d31, v31.4s

positive: uaddw instruction

	uaddw	v0.8h, v0.8h, v0.8b
	uaddw	v31.8h, v31.8h, v31.8b
	uaddw	v0.4s, v0.4s, v0.4h
	uaddw	v31.4s, v31.4s, v31.4h
	uaddw	v0.2d, v0.2d, v0.2s
	uaddw	v31.2d, v31.2d, v31.2s

positive: uaddw2 instruction

	uaddw2	v0.8h, v0.8h, v0.16b
	uaddw2	v31.8h, v31.8h, v31.16b
	uaddw2	v0.4s, v0.4s, v0.8h
	uaddw2	v31.4s, v31.4s, v31.8h
	uaddw2	v0.2d, v0.2d, v0.4s
	uaddw2	v31.2d, v31.2d, v31.4s

positive: ucvtf instruction

	ucvtf	h0, h0, 1
	ucvtf	h31, h31, 16
	ucvtf	s0, s0, 1
	ucvtf	s31, s31, 32
	ucvtf	d0, d0, 1
	ucvtf	d31, d31, 64
	ucvtf	v0.4h, v0.4h, 1
	ucvtf	v31.4h, v31.4h, 16
	ucvtf	v0.8h, v0.8h, 1
	ucvtf	v31.8h, v31.8h, 16
	ucvtf	v0.2s, v0.2s, 1
	ucvtf	v31.2s, v31.2s, 32
	ucvtf	v0.4s, v0.4s, 1
	ucvtf	v31.4s, v31.4s, 32
	ucvtf	v0.2d, v0.2d, 1
	ucvtf	v31.2d, v31.2d, 64
	ucvtf	h0, h0
	ucvtf	h31, h31
	ucvtf	s0, s0
	ucvtf	s31, s31
	ucvtf	d0, d0
	ucvtf	d31, d31
	ucvtf	v0.4h, v0.4h
	ucvtf	v31.4h, v31.4h
	ucvtf	v0.8h, v0.8h
	ucvtf	v31.8h, v31.8h
	ucvtf	v0.2s, v0.2s
	ucvtf	v31.2s, v31.2s
	ucvtf	v0.4s, v0.4s
	ucvtf	v31.4s, v31.4s
	ucvtf	v0.2d, v0.2d
	ucvtf	v31.2d, v31.2d
	ucvtf	h0, w0, 1
	ucvtf	h31, wzr, 32
	ucvtf	s0, w0, 1
	ucvtf	s31, wzr, 32
	ucvtf	d0, w0, 1
	ucvtf	d31, wzr, 32
	ucvtf	h0, x0, 1
	ucvtf	h31, xzr, 64
	ucvtf	s0, x0, 1
	ucvtf	s31, xzr, 64
	ucvtf	d0, x0, 1
	ucvtf	d31, xzr, 64
	ucvtf	h0, w0
	ucvtf	h31, wzr
	ucvtf	s0, w0
	ucvtf	s31, wzr
	ucvtf	d0, w0
	ucvtf	d31, wzr
	ucvtf	h0, x0
	ucvtf	h31, xzr
	ucvtf	s0, x0
	ucvtf	s31, xzr
	ucvtf	d0, x0
	ucvtf	d31, xzr

positive: udot instruction

	udot	v0.2s, v0.8b, v0.b[0]
	udot	v31.2s, v31.8b, v31.b[3]
	udot	v0.4s, v0.16b, v0.b[0]
	udot	v31.4s, v31.16b, v31.b[3]
	udot	v0.2s, v0.8b, v0.8b
	udot	v31.2s, v31.8b, v31.8b
	udot	v0.4s, v0.16b, v0.16b
	udot	v31.4s, v31.16b, v31.16b

positive: uhadd instruction

	uhadd	v0.8b, v0.8b, v0.8b
	uhadd	v31.8b, v31.8b, v31.8b
	uhadd	v0.16b, v0.16b, v0.16b
	uhadd	v31.16b, v31.16b, v31.16b
	uhadd	v0.4h, v0.4h, v0.4h
	uhadd	v31.4h, v31.4h, v31.4h
	uhadd	v0.8h, v0.8h, v0.8h
	uhadd	v31.8h, v31.8h, v31.8h
	uhadd	v0.2s, v0.2s, v0.2s
	uhadd	v31.2s, v31.2s, v31.2s
	uhadd	v0.4s, v0.4s, v0.4s
	uhadd	v31.4s, v31.4s, v31.4s

positive: uhsub instruction

	uhsub	v0.8b, v0.8b, v0.8b
	uhsub	v31.8b, v31.8b, v31.8b
	uhsub	v0.16b, v0.16b, v0.16b
	uhsub	v31.16b, v31.16b, v31.16b
	uhsub	v0.4h, v0.4h, v0.4h
	uhsub	v31.4h, v31.4h, v31.4h
	uhsub	v0.8h, v0.8h, v0.8h
	uhsub	v31.8h, v31.8h, v31.8h
	uhsub	v0.2s, v0.2s, v0.2s
	uhsub	v31.2s, v31.2s, v31.2s
	uhsub	v0.4s, v0.4s, v0.4s
	uhsub	v31.4s, v31.4s, v31.4s

positive: umax instruction

	umax	v0.8b, v0.8b, v0.8b
	umax	v31.8b, v31.8b, v31.8b
	umax	v0.16b, v0.16b, v0.16b
	umax	v31.16b, v31.16b, v31.16b
	umax	v0.4h, v0.4h, v0.4h
	umax	v31.4h, v31.4h, v31.4h
	umax	v0.8h, v0.8h, v0.8h
	umax	v31.8h, v31.8h, v31.8h
	umax	v0.2s, v0.2s, v0.2s
	umax	v31.2s, v31.2s, v31.2s
	umax	v0.4s, v0.4s, v0.4s
	umax	v31.4s, v31.4s, v31.4s

positive: umaxp instruction

	umaxp	v0.8b, v0.8b, v0.8b
	umaxp	v31.8b, v31.8b, v31.8b
	umaxp	v0.16b, v0.16b, v0.16b
	umaxp	v31.16b, v31.16b, v31.16b
	umaxp	v0.4h, v0.4h, v0.4h
	umaxp	v31.4h, v31.4h, v31.4h
	umaxp	v0.8h, v0.8h, v0.8h
	umaxp	v31.8h, v31.8h, v31.8h
	umaxp	v0.2s, v0.2s, v0.2s
	umaxp	v31.2s, v31.2s, v31.2s
	umaxp	v0.4s, v0.4s, v0.4s
	umaxp	v31.4s, v31.4s, v31.4s

positive: umaxv instruction

	umaxv	b0, v0.8b
	umaxv	b31, v31.8b
	umaxv	b0, v0.16b
	umaxv	b31, v31.16b
	umaxv	h0, v0.4h
	umaxv	h31, v31.4h
	umaxv	h0, v0.8h
	umaxv	h31, v31.8h
	umaxv	s0, v0.4s
	umaxv	s31, v31.4s

positive: umin instruction

	umin	v0.8b, v0.8b, v0.8b
	umin	v31.8b, v31.8b, v31.8b
	umin	v0.16b, v0.16b, v0.16b
	umin	v31.16b, v31.16b, v31.16b
	umin	v0.4h, v0.4h, v0.4h
	umin	v31.4h, v31.4h, v31.4h
	umin	v0.8h, v0.8h, v0.8h
	umin	v31.8h, v31.8h, v31.8h
	umin	v0.2s, v0.2s, v0.2s
	umin	v31.2s, v31.2s, v31.2s
	umin	v0.4s, v0.4s, v0.4s
	umin	v31.4s, v31.4s, v31.4s

positive: uminp instruction

	uminp	v0.8b, v0.8b, v0.8b
	uminp	v31.8b, v31.8b, v31.8b
	uminp	v0.16b, v0.16b, v0.16b
	uminp	v31.16b, v31.16b, v31.16b
	uminp	v0.4h, v0.4h, v0.4h
	uminp	v31.4h, v31.4h, v31.4h
	uminp	v0.8h, v0.8h, v0.8h
	uminp	v31.8h, v31.8h, v31.8h
	uminp	v0.2s, v0.2s, v0.2s
	uminp	v31.2s, v31.2s, v31.2s
	uminp	v0.4s, v0.4s, v0.4s
	uminp	v31.4s, v31.4s, v31.4s

positive: uminv instruction

	uminv	b0, v0.8b
	uminv	b31, v31.8b
	uminv	b0, v0.16b
	uminv	b31, v31.16b
	uminv	h0, v0.4h
	uminv	h31, v31.4h
	uminv	h0, v0.8h
	uminv	h31, v31.8h
	uminv	s0, v0.4s
	uminv	s31, v31.4s

positive: umlal instruction

	umlal	v0.4s, v0.4h, v0.h[0]
	umlal	v31.4s, v31.4h, v15.h[7]
	umlal	v0.2d, v0.2s, v0.s[0]
	umlal	v31.2d, v31.2s, v31.s[3]
	umlal	v0.8h, v0.8b, v0.8b
	umlal	v31.8h, v31.8b, v31.8b
	umlal	v0.4s, v0.4h, v0.4h
	umlal	v31.4s, v31.4h, v31.4h
	umlal	v0.2d, v0.2s, v0.2s
	umlal	v31.2d, v31.2s, v31.2s

positive: umlal2 instruction

	umlal2	v0.4s, v0.8h, v0.h[0]
	umlal2	v31.4s, v31.8h, v15.h[7]
	umlal2	v0.2d, v0.4s, v0.s[0]
	umlal2	v31.2d, v31.4s, v31.s[3]
	umlal2	v0.8h, v0.16b, v0.16b
	umlal2	v31.8h, v31.16b, v31.16b
	umlal2	v0.4s, v0.8h, v0.8h
	umlal2	v31.4s, v31.8h, v31.8h
	umlal2	v0.2d, v0.4s, v0.4s
	umlal2	v31.2d, v31.4s, v31.4s

positive: umlsl instruction

	umlsl	v0.4s, v0.4h, v0.h[0]
	umlsl	v31.4s, v31.4h, v15.h[7]
	umlsl	v0.2d, v0.2s, v0.s[0]
	umlsl	v31.2d, v31.2s, v31.s[3]
	umlsl	v0.8h, v0.8b, v0.8b
	umlsl	v31.8h, v31.8b, v31.8b
	umlsl	v0.4s, v0.4h, v0.4h
	umlsl	v31.4s, v31.4h, v31.4h
	umlsl	v0.2d, v0.2s, v0.2s
	umlsl	v31.2d, v31.2s, v31.2s

positive: umlsl2 instruction

	umlsl2	v0.4s, v0.8h, v0.h[0]
	umlsl2	v31.4s, v31.8h, v15.h[7]
	umlsl2	v0.2d, v0.4s, v0.s[0]
	umlsl2	v31.2d, v31.4s, v31.s[3]
	umlsl2	v0.8h, v0.16b, v0.16b
	umlsl2	v31.8h, v31.16b, v31.16b
	umlsl2	v0.4s, v0.8h, v0.8h
	umlsl2	v31.4s, v31.8h, v31.8h
	umlsl2	v0.2d, v0.4s, v0.4s
	umlsl2	v31.2d, v31.4s, v31.4s

positive: umov instruction

	umov	w0, v0.b[0]
	umov	wzr, v31.b[15]
	umov	w0, v0.h[0]
	umov	wzr, v31.h[7]
	umov	x0, v0.b[0]
	umov	xzr, v31.b[15]
	umov	x0, v0.h[0]
	umov	xzr, v31.h[7]
	umov	x0, v0.s[0]
	umov	xzr, v31.s[3]

positive: umull2 instruction

	umull2	v0.4s, v0.8h, v0.h[0]
	umull2	v31.4s, v31.8h, v15.h[7]
	umull2	v0.2d, v0.4s, v0.s[0]
	umull2	v31.2d, v31.4s, v31.s[3]
	umull2	v0.8h, v0.16b, v0.16b
	umull2	v31.8h, v31.16b, v31.16b
	umull2	v0.4s, v0.8h, v0.8h
	umull2	v31.4s, v31.8h, v31.8h
	umull2	v0.2d, v0.4s, v0.4s
	umull2	v31.2d, v31.4s, v31.4s

positive: uqadd instruction

	uqadd	b0, b0, b0
	uqadd	b31, b31, b31
	uqadd	h0, h0, h0
	uqadd	h31, h31, h31
	uqadd	s0, s0, s0
	uqadd	s31, s31, s31
	uqadd	d0, d0, d0
	uqadd	d31, d31, d31
	uqadd	v0.8b, v0.8b, v0.8b
	uqadd	v31.8b, v31.8b, v31.8b
	uqadd	v0.16b, v0.16b, v0.16b
	uqadd	v31.16b, v31.16b, v31.16b
	uqadd	v0.4h, v0.4h, v0.4h
	uqadd	v31.4h, v31.4h, v31.4h
	uqadd	v0.8h, v0.8h, v0.8h
	uqadd	v31.8h, v31.8h, v31.8h
	uqadd	v0.2s, v0.2s, v0.2s
	uqadd	v31.2s, v31.2s, v31.2s
	uqadd	v0.4s, v0.4s, v0.4s
	uqadd	v31.4s, v31.4s, v31.4s
	uqadd	v0.2d, v0.2d, v0.2d
	uqadd	v31.2d, v31.2d, v31.2d

positive: uqrshl instruction

	uqrshl	b0, b0, b0
	uqrshl	b31, b31, b31
	uqrshl	h0, h0, h0
	uqrshl	h31, h31, h31
	uqrshl	s0, s0, s0
	uqrshl	s31, s31, s31
	uqrshl	d0, d0, d0
	uqrshl	d31, d31, d31
	uqrshl	v0.8b, v0.8b, v0.8b
	uqrshl	v31.8b, v31.8b, v31.8b
	uqrshl	v0.16b, v0.16b, v0.16b
	uqrshl	v31.16b, v31.16b, v31.16b
	uqrshl	v0.4h, v0.4h, v0.4h
	uqrshl	v31.4h, v31.4h, v31.4h
	uqrshl	v0.8h, v0.8h, v0.8h
	uqrshl	v31.8h, v31.8h, v31.8h
	uqrshl	v0.2s, v0.2s, v0.2s
	uqrshl	v31.2s, v31.2s, v31.2s
	uqrshl	v0.4s, v0.4s, v0.4s
	uqrshl	v31.4s, v31.4s, v31.4s
	uqrshl	v0.2d, v0.2d, v0.2d
	uqrshl	v31.2d, v31.2d, v31.2d

positive: uqrshrn instruction

	uqrshrn	b0, h0, 1
	uqrshrn	b31, h31, 8
	uqrshrn	h0, s0, 1
	uqrshrn	h31, s31, 16
	uqrshrn	s0, d0, 1
	uqrshrn	s31, d31, 32
	uqrshrn	v0.8b, v0.8h, 1
	uqrshrn	v31.8b, v31.8h, 8
	uqrshrn	v0.4h, v0.4s, 1
	uqrshrn	v31.4h, v31.4s, 16
	uqrshrn	v0.2s, v0.2d, 1
	uqrshrn	v31.2s, v31.2d, 32

positive: uqrshrn2 instruction

	uqrshrn2	v0.16b, v0.8h, 1
	uqrshrn2	v31.16b, v31.8h, 8
	uqrshrn2	v0.8h, v0.4s, 1
	uqrshrn2	v31.8h, v31.4s, 16
	uqrshrn2	v0.4s, v0.2d, 1
	uqrshrn2	v31.4s, v31.2d, 32

positive: uqshl instruction

	uqshl	b0, b0, 0
	uqshl	b31, b31, 7
	uqshl	h0, h0, 0
	uqshl	h31, h31, 15
	uqshl	s0, s0, 0
	uqshl	s31, s31, 31
	uqshl	d0, d0, 0
	uqshl	d31, d31, 63
	uqshl	v0.8b, v0.8b, 0
	uqshl	v31.8b, v31.8b, 7
	uqshl	v0.16b, v0.16b, 0
	uqshl	v31.16b, v31.16b, 7
	uqshl	v0.4h, v0.4h, 0
	uqshl	v31.4h, v31.4h, 15
	uqshl	v0.8h, v0.8h, 0
	uqshl	v31.8h, v31.8h, 15
	uqshl	v0.2s, v0.2s, 0
	uqshl	v31.2s, v31.2s, 31
	uqshl	v0.4s, v0.4s, 0
	uqshl	v31.4s, v31.4s, 31
	uqshl	v0.2d, v0.2d, 0
	uqshl	v31.2d, v31.2d, 63
	uqshl	b0, b0, b0
	uqshl	b31, b31, b31
	uqshl	h0, h0, h0
	uqshl	h31, h31, h31
	uqshl	s0, s0, s0
	uqshl	s31, s31, s31
	uqshl	d0, d0, d0
	uqshl	d31, d31, d31
	uqshl	v0.8b, v0.8b, v0.8b
	uqshl	v31.8b, v31.8b, v31.8b
	uqshl	v0.16b, v0.16b, v0.16b
	uqshl	v31.16b, v31.16b, v31.16b
	uqshl	v0.4h, v0.4h, v0.4h
	uqshl	v31.4h, v31.4h, v31.4h
	uqshl	v0.8h, v0.8h, v0.8h
	uqshl	v31.8h, v31.8h, v31.8h
	uqshl	v0.2s, v0.2s, v0.2s
	uqshl	v31.2s, v31.2s, v31.2s
	uqshl	v0.4s, v0.4s, v0.4s
	uqshl	v31.4s, v31.4s, v31.4s
	uqshl	v0.2d, v0.2d, v0.2d
	uqshl	v31.2d, v31.2d, v31.2d

positive: uqshrn instruction

	uqshrn	b0, h0, 1
	uqshrn	b31, h31, 8
	uqshrn	h0, s0, 1
	uqshrn	h31, s31, 16
	uqshrn	s0, d0, 1
	uqshrn	s31, d31, 32
	uqshrn	v0.8b, v0.8h, 1
	uqshrn	v31.8b, v31.8h, 8
	uqshrn	v0.4h, v0.4s, 1
	uqshrn	v31.4h, v31.4s, 16
	uqshrn	v0.2s, v0.2d, 1
	uqshrn	v31.2s, v31.2d, 32

positive: uqshrn2 instruction

	uqshrn2	v0.16b, v0.8h, 1
	uqshrn2	v31.16b, v31.8h, 8
	uqshrn2	v0.8h, v0.4s, 1
	uqshrn2	v31.8h, v31.4s, 16
	uqshrn2	v0.4s, v0.2d, 1
	uqshrn2	v31.4s, v31.2d, 32

positive: uqsub instruction

	uqsub	b0, b0, b0
	uqsub	b31, b31, b31
	uqsub	h0, h0, h0
	uqsub	h31, h31, h31
	uqsub	s0, s0, s0
	uqsub	s31, s31, s31
	uqsub	d0, d0, d0
	uqsub	d31, d31, d31
	uqsub	v0.8b, v0.8b, v0.8b
	uqsub	v31.8b, v31.8b, v31.8b
	uqsub	v0.16b, v0.16b, v0.16b
	uqsub	v31.16b, v31.16b, v31.16b
	uqsub	v0.4h, v0.4h, v0.4h
	uqsub	v31.4h, v31.4h, v31.4h
	uqsub	v0.8h, v0.8h, v0.8h
	uqsub	v31.8h, v31.8h, v31.8h
	uqsub	v0.2s, v0.2s, v0.2s
	uqsub	v31.2s, v31.2s, v31.2s
	uqsub	v0.4s, v0.4s, v0.4s
	uqsub	v31.4s, v31.4s, v31.4s
	uqsub	v0.2d, v0.2d, v0.2d
	uqsub	v31.2d, v31.2d, v31.2d

positive: uqxtn instruction

	uqxtn	b0, h0
	uqxtn	b31, h31
	uqxtn	h0, s0
	uqxtn	h31, s31
	uqxtn	s0, d0
	uqxtn	s31, d31
	uqxtn	v0.8b, v0.8h
	uqxtn	v31.8b, v31.8h
	uqxtn	v0.4h, v0.4s
	uqxtn	v31.4h, v31.4s
	uqxtn	v0.2s, v0.2d
	uqxtn	v31.2s, v31.2d

positive: uqxtn2 instruction

	uqxtn2	v0.16b, v0.8h
	uqxtn2	v31.16b, v31.8h
	uqxtn2	v0.8h, v0.4s
	uqxtn2	v31.8h, v31.4s
	uqxtn2	v0.4s, v0.2d
	uqxtn2	v31.4s, v31.2d

positive: urecpe instruction

	urecpe	v0.2s, v0.2s
	urecpe	v31.2s, v31.2s
	urecpe	v0.4s, v0.4s
	urecpe	v31.4s, v31.4s

positive: urhadd instruction

	urhadd	v0.8b, v0.8b, v0.8b
	urhadd	v31.8b, v31.8b, v31.8b
	urhadd	v0.16b, v0.16b, v0.16b
	urhadd	v31.16b, v31.16b, v31.16b
	urhadd	v0.4h, v0.4h, v0.4h
	urhadd	v31.4h, v31.4h, v31.4h
	urhadd	v0.8h, v0.8h, v0.8h
	urhadd	v31.8h, v31.8h, v31.8h
	urhadd	v0.2s, v0.2s, v0.2s
	urhadd	v31.2s, v31.2s, v31.2s
	urhadd	v0.4s, v0.4s, v0.4s
	urhadd	v31.4s, v31.4s, v31.4s

positive: urshl instruction

	urshl	d0, d0, d0
	urshl	d31, d31, d31
	urshl	v0.8b, v0.8b, v0.8b
	urshl	v31.8b, v31.8b, v31.8b
	urshl	v0.16b, v0.16b, v0.16b
	urshl	v31.16b, v31.16b, v31.16b
	urshl	v0.4h, v0.4h, v0.4h
	urshl	v31.4h, v31.4h, v31.4h
	urshl	v0.8h, v0.8h, v0.8h
	urshl	v31.8h, v31.8h, v31.8h
	urshl	v0.2s, v0.2s, v0.2s
	urshl	v31.2s, v31.2s, v31.2s
	urshl	v0.4s, v0.4s, v0.4s
	urshl	v31.4s, v31.4s, v31.4s
	urshl	v0.2d, v0.2d, v0.2d
	urshl	v31.2d, v31.2d, v31.2d

positive: urshr instruction

	urshr	d0, d0, 1
	urshr	d31, d31, 64
	urshr	v0.8b, v0.8b, 1
	urshr	v31.8b, v31.8b, 8
	urshr	v0.16b, v0.16b, 1
	urshr	v31.16b, v31.16b, 8
	urshr	v0.4h, v0.4h, 1
	urshr	v31.4h, v31.4h, 16
	urshr	v0.8h, v0.8h, 1
	urshr	v31.8h, v31.8h, 16
	urshr	v0.2s, v0.2s, 1
	urshr	v31.2s, v31.2s, 32
	urshr	v0.4s, v0.4s, 1
	urshr	v31.4s, v31.4s, 32
	urshr	v0.2d, v0.2d, 1
	urshr	v31.2d, v31.2d, 64

positive: ursqrte instruction

	ursqrte	v0.2s, v0.2s
	ursqrte	v31.2s, v31.2s
	ursqrte	v0.4s, v0.4s
	ursqrte	v31.4s, v31.4s

positive: ursra instruction

	ursra	d0, d0, 1
	ursra	d31, d31, 64
	ursra	v0.8b, v0.8b, 1
	ursra	v31.8b, v31.8b, 8
	ursra	v0.16b, v0.16b, 1
	ursra	v31.16b, v31.16b, 8
	ursra	v0.4h, v0.4h, 1
	ursra	v31.4h, v31.4h, 16
	ursra	v0.8h, v0.8h, 1
	ursra	v31.8h, v31.8h, 16
	ursra	v0.2s, v0.2s, 1
	ursra	v31.2s, v31.2s, 32
	ursra	v0.4s, v0.4s, 1
	ursra	v31.4s, v31.4s, 32
	ursra	v0.2d, v0.2d, 1
	ursra	v31.2d, v31.2d, 64

positive: ushl instruction

	ushl	d0, d0, d0
	ushl	d31, d31, d31
	ushl	v0.8b, v0.8b, v0.8b
	ushl	v31.8b, v31.8b, v31.8b
	ushl	v0.16b, v0.16b, v0.16b
	ushl	v31.16b, v31.16b, v31.16b
	ushl	v0.4h, v0.4h, v0.4h
	ushl	v31.4h, v31.4h, v31.4h
	ushl	v0.8h, v0.8h, v0.8h
	ushl	v31.8h, v31.8h, v31.8h
	ushl	v0.2s, v0.2s, v0.2s
	ushl	v31.2s, v31.2s, v31.2s
	ushl	v0.4s, v0.4s, v0.4s
	ushl	v31.4s, v31.4s, v31.4s
	ushl	v0.2d, v0.2d, v0.2d
	ushl	v31.2d, v31.2d, v31.2d

positive: ushll instruction

	ushll	v0.8h, v0.8b, 0
	ushll	v31.8h, v31.8b, 7
	ushll	v0.4s, v0.4h, 0
	ushll	v31.4s, v31.4h, 15
	ushll	v0.2d, v0.2s, 0
	ushll	v31.2d, v31.2s, 31

positive: ushll2 instruction

	ushll2	v0.8h, v0.16b, 0
	ushll2	v31.8h, v31.16b, 7
	ushll2	v0.4s, v0.8h, 0
	ushll2	v31.4s, v31.8h, 15
	ushll2	v0.2d, v0.4s, 0
	ushll2	v31.2d, v31.4s, 31

positive: ushr instruction

	ushr	d0, d0, 1
	ushr	d31, d31, 64
	ushr	v0.8b, v0.8b, 1
	ushr	v31.8b, v31.8b, 8
	ushr	v0.16b, v0.16b, 1
	ushr	v31.16b, v31.16b, 8
	ushr	v0.4h, v0.4h, 1
	ushr	v31.4h, v31.4h, 16
	ushr	v0.8h, v0.8h, 1
	ushr	v31.8h, v31.8h, 16
	ushr	v0.2s, v0.2s, 1
	ushr	v31.2s, v31.2s, 32
	ushr	v0.4s, v0.4s, 1
	ushr	v31.4s, v31.4s, 32
	ushr	v0.2d, v0.2d, 1
	ushr	v31.2d, v31.2d, 64

positive: usqadd instruction

	usqadd	b0, b0
	usqadd	b31, b31
	usqadd	h0, h0
	usqadd	h31, h31
	usqadd	s0, s0
	usqadd	s31, s31
	usqadd	d0, d0
	usqadd	d31, d31
	usqadd	v0.8b, v0.8b
	usqadd	v31.8b, v31.8b
	usqadd	v0.16b, v0.16b
	usqadd	v31.16b, v31.16b
	usqadd	v0.4h, v0.4h
	usqadd	v31.4h, v31.4h
	usqadd	v0.8h, v0.8h
	usqadd	v31.8h, v31.8h
	usqadd	v0.2s, v0.2s
	usqadd	v31.2s, v31.2s
	usqadd	v0.4s, v0.4s
	usqadd	v31.4s, v31.4s
	usqadd	v0.2d, v0.2d
	usqadd	v31.2d, v31.2d

positive: usra instruction

	usra	d0, d0, 1
	usra	d31, d31, 64
	usra	v0.8b, v0.8b, 1
	usra	v31.8b, v31.8b, 8
	usra	v0.16b, v0.16b, 1
	usra	v31.16b, v31.16b, 8
	usra	v0.4h, v0.4h, 1
	usra	v31.4h, v31.4h, 16
	usra	v0.8h, v0.8h, 1
	usra	v31.8h, v31.8h, 16
	usra	v0.2s, v0.2s, 1
	usra	v31.2s, v31.2s, 32
	usra	v0.4s, v0.4s, 1
	usra	v31.4s, v31.4s, 32
	usra	v0.2d, v0.2d, 1
	usra	v31.2d, v31.2d, 64

positive: usubl instruction

	usubl	v0.8h, v0.8b, v0.8b
	usubl	v31.8h, v31.8b, v31.8b
	usubl	v0.4s, v0.4h, v0.4h
	usubl	v31.4s, v31.4h, v31.4h
	usubl	v0.2d, v0.2s, v0.2s
	usubl	v31.2d, v31.2s, v31.2s

positive: usubl2 instruction

	usubl2	v0.8h, v0.16b, v0.16b
	usubl2	v31.8h, v31.16b, v31.16b
	usubl2	v0.4s, v0.8h, v0.8h
	usubl2	v31.4s, v31.8h, v31.8h
	usubl2	v0.2d, v0.4s, v0.4s
	usubl2	v31.2d, v31.4s, v31.4s

positive: usubw instruction

	usubw	v0.8h, v0.8h, v0.8b
	usubw	v31.8h, v31.8h, v31.8b
	usubw	v0.4s, v0.4s, v0.4h
	usubw	v31.4s, v31.4s, v31.4h
	usubw	v0.2d, v0.2d, v0.2s
	usubw	v31.2d, v31.2d, v31.2s

positive: usubw2 instruction

	usubw2	v0.8h, v0.8h, v0.16b
	usubw2	v31.8h, v31.8h, v31.16b
	usubw2	v0.4s, v0.4s, v0.8h
	usubw2	v31.4s, v31.4s, v31.8h
	usubw2	v0.2d, v0.2d, v0.4s
	usubw2	v31.2d, v31.2d, v31.4s

positive: uxtl instruction

	uxtl	v0.8h, v0.8b
	uxtl	v31.8h, v31.8b
	uxtl	v0.4s, v0.4h
	uxtl	v31.4s, v31.4h
	uxtl	v0.2d, v0.2s
	uxtl	v31.2d, v31.2s

positive: uxtl2 instruction

	uxtl2	v0.8h, v0.16b
	uxtl2	v31.8h, v31.16b
	uxtl2	v0.4s, v0.8h
	uxtl2	v31.4s, v31.8h
	uxtl2	v0.2d, v0.4s
	uxtl2	v31.2d, v31.4s

positive: uzp1 instruction

	uzp1	v0.8b, v0.8b, v0.8b
	uzp1	v31.8b, v31.8b, v31.8b
	uzp1	v0.16b, v0.16b, v0.16b
	uzp1	v31.16b, v31.16b, v31.16b
	uzp1	v0.4h, v0.4h, v0.4h
	uzp1	v31.4h, v31.4h, v31.4h
	uzp1	v0.8h, v0.8h, v0.8h
	uzp1	v31.8h, v31.8h, v31.8h
	uzp1	v0.2s, v0.2s, v0.2s
	uzp1	v31.2s, v31.2s, v31.2s
	uzp1	v0.4s, v0.4s, v0.4s
	uzp1	v31.4s, v31.4s, v31.4s
	uzp1	v0.2d, v0.2d, v0.2d
	uzp1	v31.2d, v31.2d, v31.2d

positive: uzp2 instruction

	uzp2	v0.8b, v0.8b, v0.8b
	uzp2	v31.8b, v31.8b, v31.8b
	uzp2	v0.16b, v0.16b, v0.16b
	uzp2	v31.16b, v31.16b, v31.16b
	uzp2	v0.4h, v0.4h, v0.4h
	uzp2	v31.4h, v31.4h, v31.4h
	uzp2	v0.8h, v0.8h, v0.8h
	uzp2	v31.8h, v31.8h, v31.8h
	uzp2	v0.2s, v0.2s, v0.2s
	uzp2	v31.2s, v31.2s, v31.2s
	uzp2	v0.4s, v0.4s, v0.4s
	uzp2	v31.4s, v31.4s, v31.4s
	uzp2	v0.2d, v0.2d, v0.2d
	uzp2	v31.2d, v31.2d, v31.2d

positive: xar instruction

	xar v0.2d, v0.2d, v0.2d, 0
	xar v31.2d, v31.2d, v31.2d, 63

positive: xtn instruction

	xtn	v0.8b, v0.8h
	xtn	v31.8b, v31.8h
	xtn	v0.4h, v0.4s
	xtn	v31.4h, v31.4s
	xtn	v0.2s, v0.2d
	xtn	v31.2s, v31.2d

positive: xtn2 instruction

	xtn2	v0.16b, v0.8h
	xtn2	v31.16b, v31.8h
	xtn2	v0.8h, v0.4s
	xtn2	v31.8h, v31.4s
	xtn2	v0.4s, v0.2d
	xtn2	v31.4s, v31.2d

positive: zip1 instruction

	zip1	v0.8b, v0.8b, v0.8b
	zip1	v31.8b, v31.8b, v31.8b
	zip1	v0.16b, v0.16b, v0.16b
	zip1	v31.16b, v31.16b, v31.16b
	zip1	v0.4h, v0.4h, v0.4h
	zip1	v31.4h, v31.4h, v31.4h
	zip1	v0.8h, v0.8h, v0.8h
	zip1	v31.8h, v31.8h, v31.8h
	zip1	v0.2s, v0.2s, v0.2s
	zip1	v31.2s, v31.2s, v31.2s
	zip1	v0.4s, v0.4s, v0.4s
	zip1	v31.4s, v31.4s, v31.4s
	zip1	v0.2d, v0.2d, v0.2d
	zip1	v31.2d, v31.2d, v31.2d

positive: zip2 instruction

	zip2	v0.8b, v0.8b, v0.8b
	zip2	v31.8b, v31.8b, v31.8b
	zip2	v0.16b, v0.16b, v0.16b
	zip2	v31.16b, v31.16b, v31.16b
	zip2	v0.4h, v0.4h, v0.4h
	zip2	v31.4h, v31.4h, v31.4h
	zip2	v0.8h, v0.8h, v0.8h
	zip2	v31.8h, v31.8h, v31.8h
	zip2	v0.2s, v0.2s, v0.2s
	zip2	v31.2s, v31.2s, v31.2s
	zip2	v0.4s, v0.4s, v0.4s
	zip2	v31.4s, v31.4s, v31.4s
	zip2	v0.2d, v0.2d, v0.2d
	zip2	v31.2d, v31.2d, v31.2d

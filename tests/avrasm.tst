# AVR assembler test and validation suite
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

# AVR assembler

# adc instruction

negative: adc with no operands

	adc

negative: adc with immediate

	adc	0

negative: adc with register

	adc	r16

negative: adc with register pair

	adc	r25:r24

negative: adc with index

	adc	Z

negative: adc with immediates

	adc	0, 0

negative: adc with leading immediate

	adc	0, r16

negative: adc with following immediate

	adc	r16, 0

positive: adc with registers

	adc	r0, r15
	adc	r16, r31

negative: adc with invalid registers

	adc	r0, r32

negative: adc with register pairs

	adc	r25:r24, r25:r24

negative: adc with leading register pair

	adc	r25:r24, r16

negative: adc with following register pair

	adc	r16, r25:r24

negative: adc with indices

	adc	Z, Z

negative: adc with leading index

	adc	Z, r16

negative: adc with following index

	adc	r16, Z

# add instruction

negative: add with no operands

	add

negative: add with immediate

	add	0

negative: add with register

	add	r16

negative: add with register pair

	add	r25:r24

negative: add with index

	add	Z

negative: add with immediates

	add	0, 0

negative: add with leading immediate

	add	0, r16

negative: add with following immediate

	add	r16, 0

positive: add with registers

	add	r0, r15
	add	r16, r31

negative: add with invalid registers

	add	r0, r32

negative: add with register pairs

	add	r25:r24, r25:r24

negative: add with leading register pair

	add	r25:r24, r16

negative: add with following register pair

	add	r16, r25:r24

negative: add with indices

	add	Z, Z

negative: add with leading index

	add	Z, r16

negative: add with following index

	add	r16, Z

# adiw instruction

negative: adiw with no operands

	adiw

negative: adiw with immediate

	adiw	0

negative: adiw with register

	adiw	r16

negative: adiw with register pair

	adiw	r25:r24

negative: adiw with index

	adiw	Z

negative: adiw with immediates

	adiw	0, 0

positive: adiw with following immediate

	adiw	r25:r24, 0
	adiw	r25:r24, 63

negative: adiw with invalid immediate

	adiw	r25:r24, 64

negative: adiw with registers

	adiw	r16, r16
	adiw	r16, r31

negative: adiw with leading register

	adiw	r16, 0

negative: adiw with following register

	adiw	r25:r24, r16

negative: adiw with register pairs

	adiw	r25:r24, r25:r24

positive: adiw with leading register pair

	adiw	r25:r24, 0
	adiw	r31:r30, 0

negative: adiw with invalid register pair

	adiw	r17:r16, 0

negative: adiw with indices

	adiw	Z, Z

negative: adiw with leading index

	adiw	Z, 0

negative: adiw with following index

	adiw	r25:r24, Z

# and instruction

negative: and with no operands

	and

negative: and with immediate

	and	0

negative: and with register

	and	r16

negative: and with register pair

	and	r25:r24

negative: and with index

	and	Z

negative: and with immediates

	and	0, 0

negative: and with leading immediate

	and	0, r16

negative: and with following immediate

	and	r16, 0

positive: and with registers

	and	r0, r15
	and	r16, r31

negative: and with invalid registers

	and	r0, r32

negative: and with register pairs

	and	r25:r24, r25:r24

negative: and with leading register pair

	and	r25:r24, r16

negative: and with following register pair

	and	r16, r25:r24

negative: and with indices

	and	Z, Z

negative: and with leading index

	and	Z, r16

negative: and with following index

	and	r16, Z

# andi instruction

negative: andi with no operands

	andi

negative: andi with immediate

	andi	0

negative: andi with register

	andi	r16

negative: andi with register pair

	andi	r25:r24

negative: andi with index

	andi	Z

negative: andi with immediates

	andi	0, 0

positive: andi with following immediate

	andi	r16, 0
	andi	r16, 255

negative: andi with invalid immediate

	andi	r16, 256

negative: andi with registers

	andi	r16, r16

positive: andi with leading register

	andi	r16, 0
	andi	r31, 0

negative: andi with invalid register

	andi	r15, 0

negative: andi with register pairs

	andi	r25:r24, r25:r24

negative: andi with leading register pair

	andi	r25:r24, 0

negative: andi with following register pair

	andi	r16, r25:r24

negative: andi with indices

	andi	Z, Z

negative: andi with leading index

	andi	Z, 0

negative: andi with following index

	andi	r16, Z

# asr instruction

negative: asr with no operands

	asr

negative: asr with immediate

	asr	0

positive: asr with register

	asr	r0
	asr	r31

negative: asr with invalid register

	asr	r32

negative: asr with register pair

	asr	r25:r24

negative: asr with index

	asr	Z

negative: asr with immediates

	asr	0, 0

negative: asr with following immediate

	asr	r16, 0

negative: asr with registers

	asr	r16, r16

negative: asr with register pairs

	asr	r25:r24, r25:r24

negative: asr with following register pair

	asr	r16, r25:r24

negative: asr with indices

	asr	Z, Z

negative: asr with following index

	asr	r16, Z

# bclr instruction

negative: bclr with no operands

	bclr

positive: bclr with immediate

	bclr	0
	bclr	7

negative: bclr with invalid immediate

	bclr	8

negative: bclr with register

	bclr	r16

negative: bclr with register pair

	bclr	r25:r24

negative: bclr with index

	bclr	Z

negative: bclr with immediates

	bclr	0, 0

negative: bclr with registers

	bclr	r16, r16

negative: bclr with following register

	bclr	0, r16

negative: bclr with register pairs

	bclr	r25:r24, r25:r24

negative: bclr with following register pair

	bclr	0, r25:r24

negative: bclr with indices

	bclr	Z, Z

negative: bclr with following index

	bclr	0, Z

# bld instruction

negative: bld with no operands

	bld

negative: bld with immediate

	bld	0

negative: bld with register

	bld	r16

negative: bld with register pair

	bld	r25:r24

negative: bld with index

	bld	Z

negative: bld with immediates

	bld	0, 0

positive: bld with following immediate

	bld	r16, 0
	bld	r16, 7

negative: bld with invalid immediate

	bld	r16, 8

negative: bld with registers

	bld	r16, r16

positive: bld with leading register

	bld	r0, 0
	bld	r31, 0

negative: bld with invalid register

	bld	r32, 0

negative: bld with register pairs

	bld	r25:r24, r25:r24

negative: bld with leading register pair

	bld	r25:r24, 0

negative: bld with following register pair

	bld	r16, r25:r24

negative: bld with indices

	bld	Z, Z

negative: bld with leading index

	bld	Z, 0

negative: bld with following index

	bld	r16, Z

# brbc instruction

negative: brbc with no operands

	brbc

negative: brbc with immediate

	brbc	0

negative: brbc with register

	brbc	r16

negative: brbc with register pair

	brbc	r25:r24

negative: brbc with index

	brbc	Z

positive: brbc with immediates

	brbc	0, -64
	brbc	7, 63

negative: brbc with invalid immediates

	brbc	8, 64

negative: brbc with registers

	brbc	r16, r16
	brbc	r16, r31

negative: brbc with leading register

	brbc	r16, 0

negative: brbc with following register

	brbc	0, r16

negative: brbc with register pairs

	brbc	r25:r24, r25:r24

negative: brbc with leading register pair

	brbc	r25:r24, 0

negative: brbc with following register pair

	brbc	0, r25:r24

negative: brbc with indices

	brbc	Z, Z

negative: brbc with leading index

	brbc	Z, 0

negative: brbc with following index

	brbc	0, Z

# brbs instruction

negative: brbs with no operands

	brbs

negative: brbs with immediate

	brbs	0

negative: brbs with register

	brbs	r16

negative: brbs with register pair

	brbs	r25:r24

negative: brbs with index

	brbs	Z

positive: brbs with immediates

	brbs	0, -64
	brbs	7, 63

negative: brbs with invalid immediates

	brbs	8, 64

negative: brbs with registers

	brbs	r16, r16
	brbs	r16, r31

negative: brbs with leading register

	brbs	r16, 0

negative: brbs with following register

	brbs	0, r16

negative: brbs with register pairs

	brbs	r25:r24, r25:r24

negative: brbs with leading register pair

	brbs	r25:r24, 0

negative: brbs with following register pair

	brbs	0, r25:r24

negative: brbs with indices

	brbs	Z, Z

negative: brbs with leading index

	brbs	Z, 0

negative: brbs with following index

	brbs	0, Z

# brcc instruction

negative: brcc with no operands

	brcc

positive: brcc with immediate

	brcc	-64
	brcc	63

negative: brcc with invalid immediate

	brcc	64

negative: brcc with register

	brcc	r0

negative: brcc with register pair

	brcc	r25:r24

negative: brcc with index

	brcc	Z

negative: brcc with immediates

	brcc	0, 0

negative: brcc with registers

	brcc	r16, r16

negative: brcc with following register

	brcc	0, r16

negative: brcc with register pairs

	brcc	r25:r24, r25:r24

negative: brcc with following register pair

	brcc	0, r25:r24

negative: brcc with indices

	brcc	Z, Z

negative: brcc with following index

	brcc	0, Z

# brcs instruction

negative: brcs with no operands

	brcs

positive: brcs with immediate

	brcs	-64
	brcs	63

negative: brcs with invalid immediate

	brcs	64

negative: brcs with register

	brcs	r0

negative: brcs with register pair

	brcs	r25:r24

negative: brcs with index

	brcs	Z

negative: brcs with immediates

	brcs	0, 0

negative: brcs with registers

	brcs	r16, r16

negative: brcs with following register

	brcs	0, r16

negative: brcs with register pairs

	brcs	r25:r24, r25:r24

negative: brcs with following register pair

	brcs	0, r25:r24

negative: brcs with indices

	brcs	Z, Z

negative: brcs with following index

	brcs	0, Z

# break instruction

positive: break with no operands

	break

negative: break with immediate

	break	0

negative: break with register

	break	r0

negative: break with register pair

	break	r25:r24

negative: break with index

	break	Z

negative: break with immediates

	break	0, 0

negative: break with registers

	break	r16, r16

negative: break with register pairs

	break	r25:r24, r25:r24

negative: break with indices

	break	Z, Z

# breq instruction

negative: breq with no operands

	breq

positive: breq with immediate

	breq	-64
	breq	63

negative: breq with invalid immediate

	breq	64

negative: breq with register

	breq	r0

negative: breq with register pair

	breq	r25:r24

negative: breq with index

	breq	Z

negative: breq with immediates

	breq	0, 0

negative: breq with registers

	breq	r16, r16

negative: breq with following register

	breq	0, r16

negative: breq with register pairs

	breq	r25:r24, r25:r24

negative: breq with following register pair

	breq	0, r25:r24

negative: breq with indices

	breq	Z, Z

negative: breq with following index

	breq	0, Z

# brge instruction

negative: brge with no operands

	brge

positive: brge with immediate

	brge	-64
	brge	63

negative: brge with invalid immediate

	brge	64

negative: brge with register

	brge	r0

negative: brge with register pair

	brge	r25:r24

negative: brge with index

	brge	Z

negative: brge with immediates

	brge	0, 0

negative: brge with registers

	brge	r16, r16

negative: brge with following register

	brge	0, r16

negative: brge with register pairs

	brge	r25:r24, r25:r24

negative: brge with following register pair

	brge	0, r25:r24

negative: brge with indices

	brge	Z, Z

negative: brge with following index

	brge	0, Z

# brhc instruction

negative: brhc with no operands

	brhc

positive: brhc with immediate

	brhc	-64
	brhc	63

negative: brhc with invalid immediate

	brhc	64

negative: brhc with register

	brhc	r0

negative: brhc with register pair

	brhc	r25:r24

negative: brhc with index

	brhc	Z

negative: brhc with immediates

	brhc	0, 0

negative: brhc with registers

	brhc	r16, r16

negative: brhc with following register

	brhc	0, r16

negative: brhc with register pairs

	brhc	r25:r24, r25:r24

negative: brhc with following register pair

	brhc	0, r25:r24

negative: brhc with indices

	brhc	Z, Z

negative: brhc with following index

	brhc	0, Z

# brhs instruction

negative: brhs with no operands

	brhs

positive: brhs with immediate

	brhs	-64
	brhs	63

negative: brhs with invalid immediate

	brhs	64

negative: brhs with register

	brhs	r0

negative: brhs with register pair

	brhs	r25:r24

negative: brhs with index

	brhs	Z

negative: brhs with immediates

	brhs	0, 0

negative: brhs with registers

	brhs	r16, r16

negative: brhs with following register

	brhs	0, r16

negative: brhs with register pairs

	brhs	r25:r24, r25:r24

negative: brhs with following register pair

	brhs	0, r25:r24

negative: brhs with indices

	brhs	Z, Z

negative: brhs with following index

	brhs	0, Z

# brid instruction

negative: brid with no operands

	brid

positive: brid with immediate

	brid	-64
	brid	63

negative: brid with invalid immediate

	brid	64

negative: brid with register

	brid	r0

negative: brid with register pair

	brid	r25:r24

negative: brid with index

	brid	Z

negative: brid with immediates

	brid	0, 0

negative: brid with registers

	brid	r16, r16

negative: brid with following register

	brid	0, r16

negative: brid with register pairs

	brid	r25:r24, r25:r24

negative: brid with following register pair

	brid	0, r25:r24

negative: brid with indices

	brid	Z, Z

negative: brid with following index

	brid	0, Z

# brie instruction

negative: brie with no operands

	brie

positive: brie with immediate

	brie	-64
	brie	63

negative: brie with invalid immediate

	brie	64

negative: brie with register

	brie	r0

negative: brie with register pair

	brie	r25:r24

negative: brie with index

	brie	Z

negative: brie with immediates

	brie	0, 0

negative: brie with registers

	brie	r16, r16

negative: brie with following register

	brie	0, r16

negative: brie with register pairs

	brie	r25:r24, r25:r24

negative: brie with following register pair

	brie	0, r25:r24

negative: brie with indices

	brie	Z, Z

negative: brie with following index

	brie	0, Z

# brlo instruction

negative: brlo with no operands

	brlo

positive: brlo with immediate

	brlo	-64
	brlo	63

negative: brlo with invalid immediate

	brlo	64

negative: brlo with register

	brlo	r0

negative: brlo with register pair

	brlo	r25:r24

negative: brlo with index

	brlo	Z

negative: brlo with immediates

	brlo	0, 0

negative: brlo with registers

	brlo	r16, r16

negative: brlo with following register

	brlo	0, r16

negative: brlo with register pairs

	brlo	r25:r24, r25:r24

negative: brlo with following register pair

	brlo	0, r25:r24

negative: brlo with indices

	brlo	Z, Z

negative: brlo with following index

	brlo	0, Z

# brlt instruction

negative: brlt with no operands

	brlt

positive: brlt with immediate

	brlt	-64
	brlt	63

negative: brlt with invalid immediate

	brlt	64

negative: brlt with register

	brlt	r0

negative: brlt with register pair

	brlt	r25:r24

negative: brlt with index

	brlt	Z

negative: brlt with immediates

	brlt	0, 0

negative: brlt with registers

	brlt	r16, r16

negative: brlt with following register

	brlt	0, r16

negative: brlt with register pairs

	brlt	r25:r24, r25:r24

negative: brlt with following register pair

	brlt	0, r25:r24

negative: brlt with indices

	brlt	Z, Z

negative: brlt with following index

	brlt	0, Z

# brmi instruction

negative: brmi with no operands

	brmi

positive: brmi with immediate

	brmi	-64
	brmi	63

negative: brmi with invalid immediate

	brmi	64

negative: brmi with register

	brmi	r0

negative: brmi with register pair

	brmi	r25:r24

negative: brmi with index

	brmi	Z

negative: brmi with immediates

	brmi	0, 0

negative: brmi with registers

	brmi	r16, r16

negative: brmi with following register

	brmi	0, r16

negative: brmi with register pairs

	brmi	r25:r24, r25:r24

negative: brmi with following register pair

	brmi	0, r25:r24

negative: brmi with indices

	brmi	Z, Z

negative: brmi with following index

	brmi	0, Z

# brne instruction

negative: brne with no operands

	brne

positive: brne with immediate

	brne	-64
	brne	63

negative: brne with invalid immediate

	brne	64

negative: brne with register

	brne	r0

negative: brne with register pair

	brne	r25:r24

negative: brne with index

	brne	Z

negative: brne with immediates

	brne	0, 0

negative: brne with registers

	brne	r16, r16

negative: brne with following register

	brne	0, r16

negative: brne with register pairs

	brne	r25:r24, r25:r24

negative: brne with following register pair

	brne	0, r25:r24

negative: brne with indices

	brne	Z, Z

negative: brne with following index

	brne	0, Z

# brpl instruction

negative: brpl with no operands

	brpl

positive: brpl with immediate

	brpl	-64
	brpl	63

negative: brpl with invalid immediate

	brpl	64

negative: brpl with register

	brpl	r0

negative: brpl with register pair

	brpl	r25:r24

negative: brpl with index

	brpl	Z

negative: brpl with immediates

	brpl	0, 0

negative: brpl with registers

	brpl	r16, r16

negative: brpl with following register

	brpl	0, r16

negative: brpl with register pairs

	brpl	r25:r24, r25:r24

negative: brpl with following register pair

	brpl	0, r25:r24

negative: brpl with indices

	brpl	Z, Z

negative: brpl with following index

	brpl	0, Z

# brsh instruction

negative: brsh with no operands

	brsh

positive: brsh with immediate

	brsh	-64
	brsh	63

negative: brsh with invalid immediate

	brsh	64

negative: brsh with register

	brsh	r0

negative: brsh with register pair

	brsh	r25:r24

negative: brsh with index

	brsh	Z

negative: brsh with immediates

	brsh	0, 0

negative: brsh with registers

	brsh	r16, r16

negative: brsh with following register

	brsh	0, r16

negative: brsh with register pairs

	brsh	r25:r24, r25:r24

negative: brsh with following register pair

	brsh	0, r25:r24

negative: brsh with indices

	brsh	Z, Z

negative: brsh with following index

	brsh	0, Z

# brtc instruction

negative: brtc with no operands

	brtc

positive: brtc with immediate

	brtc	-64
	brtc	63

negative: brtc with invalid immediate

	brtc	64

negative: brtc with register

	brtc	r0

negative: brtc with register pair

	brtc	r25:r24

negative: brtc with index

	brtc	Z

negative: brtc with immediates

	brtc	0, 0

negative: brtc with registers

	brtc	r16, r16

negative: brtc with following register

	brtc	0, r16

negative: brtc with register pairs

	brtc	r25:r24, r25:r24

negative: brtc with following register pair

	brtc	0, r25:r24

negative: brtc with indices

	brtc	Z, Z

negative: brtc with following index

	brtc	0, Z

# brts instruction

negative: brts with no operands

	brts

positive: brts with immediate

	brts	-64
	brts	63

negative: brts with invalid immediate

	brts	64

negative: brts with register

	brts	r0

negative: brts with register pair

	brts	r25:r24

negative: brts with index

	brts	Z

negative: brts with immediates

	brts	0, 0

negative: brts with registers

	brts	r16, r16

negative: brts with following register

	brts	0, r16

negative: brts with register pairs

	brts	r25:r24, r25:r24

negative: brts with following register pair

	brts	0, r25:r24

negative: brts with indices

	brts	Z, Z

negative: brts with following index

	brts	0, Z

# brvc instruction

negative: brvc with no operands

	brvc

positive: brvc with immediate

	brvc	-64
	brvc	63

negative: brvc with invalid immediate

	brvc	64

negative: brvc with register

	brvc	r0

negative: brvc with register pair

	brvc	r25:r24

negative: brvc with index

	brvc	Z

negative: brvc with immediates

	brvc	0, 0

negative: brvc with registers

	brvc	r16, r16

negative: brvc with following register

	brvc	0, r16

negative: brvc with register pairs

	brvc	r25:r24, r25:r24

negative: brvc with following register pair

	brvc	0, r25:r24

negative: brvc with indices

	brvc	Z, Z

negative: brvc with following index

	brvc	0, Z

# brvs instruction

negative: brvs with no operands

	brvs

positive: brvs with immediate

	brvs	-64
	brvs	63

negative: brvs with invalid immediate

	brvs	64

negative: brvs with register

	brvs	r0

negative: brvs with register pair

	brvs	r25:r24

negative: brvs with index

	brvs	Z

negative: brvs with immediates

	brvs	0, 0

negative: brvs with registers

	brvs	r16, r16

negative: brvs with following register

	brvs	0, r16

negative: brvs with register pairs

	brvs	r25:r24, r25:r24

negative: brvs with following register pair

	brvs	0, r25:r24

negative: brvs with indices

	brvs	Z, Z

negative: brvs with following index

	brvs	0, Z

# bset instruction

negative: bset with no operands

	bset

positive: bset with immediate

	bset	0
	bset	7

negative: bset with invalid immediate

	bset	8

negative: bset with register

	bset	r16

negative: bset with register pair

	bset	r25:r24

negative: bset with index

	bset	Z

negative: bset with immediates

	bset	0, 0

negative: bset with registers

	bset	r16, r16

negative: bset with following register

	bset	0, r16

negative: bset with register pairs

	bset	r25:r24, r25:r24

negative: bset with following register pair

	bset	0, r25:r24

negative: bset with indices

	bset	Z, Z

negative: bset with following index

	bset	0, Z

# bst instruction

negative: bst with no operands

	bst

negative: bst with immediate

	bst	0

negative: bst with register

	bst	r16

negative: bst with register pair

	bst	r25:r24

negative: bst with index

	bst	Z

negative: bst with immediates

	bst	0, 0

positive: bst with following immediate

	bst	r16, 0
	bst	r16, 7

negative: bst with invalid immediate

	bst	r16, 8

negative: bst with registers

	bst	r16, r16

positive: bst with leading register

	bst	r0, 0
	bst	r31, 0

negative: bst with invalid register

	bst	r32, 0

negative: bst with register pairs

	bst	r25:r24, r25:r24

negative: bst with leading register pair

	bst	r25:r24, 0

negative: bst with following register pair

	bst	r16, r25:r24

negative: bst with indices

	bst	Z, Z

negative: bst with leading index

	bst	Z, 0

negative: bst with following index

	bst	r16, Z

# call instruction

negative: call with no operands

	call

positive: call with immediate

	call	0
	call	4194303

negative: call with invalid immediate

	call	4194304

negative: call with register

	call	r16

negative: call with register pair

	call	r25:r24

negative: call with index

	call	Z

negative: call with immediates

	call	0, 0

negative: call with registers

	call	r16, r16

negative: call with following register

	call	0, r16

negative: call with register pairs

	call	r25:r24, r25:r24

negative: call with following register pair

	call	0, r25:r24

negative: call with indices

	call	Z, Z

negative: call with following index

	call	0, Z

# cbi instruction

negative: cbi with no operands

	cbi

negative: cbi with immediate

	cbi	0

negative: cbi with register

	cbi	r16

negative: cbi with register pair

	cbi	r25:r24

negative: cbi with index

	cbi	Z

positive: cbi with immediates

	cbi	0, 0
	cbi	31, 7

negative: cbi with invalid immediates

	cbi	32, 8

negative: cbi with registers

	cbi	r16, r16
	cbi	r16, r31

negative: cbi with leading register

	cbi	r16, 0

negative: cbi with following register

	cbi	0, r16

negative: cbi with register pairs

	cbi	r25:r24, r25:r24

negative: cbi with leading register pair

	cbi	r25:r24, 0

negative: cbi with following register pair

	cbi	0, r25:r24

negative: cbi with indices

	cbi	Z, Z

negative: cbi with leading index

	cbi	Z, 0

negative: cbi with following index

	cbi	0, Z

# cbr instruction

negative: cbr with no operands

	cbr

negative: cbr with immediate

	cbr	0

negative: cbr with register

	cbr	r16

negative: cbr with register pair

	cbr	r25:r24

negative: cbr with index

	cbr	Z

negative: cbr with immediates

	cbr	0, 0

positive: cbr with following immediate

	cbr	r16, 0
	cbr	r16, 255

negative: cbr with invalid immediate

	cbr	r16, 256

negative: cbr with registers

	cbr	r16, r16

positive: cbr with leading register

	cbr	r16, 0
	cbr	r31, 0

negative: cbr with invalid register

	cbr	r15, 0

negative: cbr with register pairs

	cbr	r25:r24, r25:r24

negative: cbr with leading register pair

	cbr	r25:r24, 0

negative: cbr with following register pair

	cbr	r16, r25:r24

negative: cbr with indices

	cbr	Z, Z

negative: cbr with leading index

	cbr	Z, 0

negative: cbr with following index

	cbr	r16, Z

# clc instruction

positive: clc with no operands

	clc

negative: clc with immediate

	clc	0

negative: clc with register

	clc	r0

negative: clc with register pair

	clc	r25:r24

negative: clc with index

	clc	Z

negative: clc with immediates

	clc	0, 0

negative: clc with registers

	clc	r16, r16

negative: clc with register pairs

	clc	r25:r24, r25:r24

negative: clc with indices

	clc	Z, Z

# clh instruction

positive: clh with no operands

	clh

negative: clh with immediate

	clh	0

negative: clh with register

	clh	r0

negative: clh with register pair

	clh	r25:r24

negative: clh with index

	clh	Z

negative: clh with immediates

	clh	0, 0

negative: clh with registers

	clh	r16, r16

negative: clh with register pairs

	clh	r25:r24, r25:r24

negative: clh with indices

	clh	Z, Z

# cli instruction

positive: cli with no operands

	cli

negative: cli with immediate

	cli	0

negative: cli with register

	cli	r0

negative: cli with register pair

	cli	r25:r24

negative: cli with index

	cli	Z

negative: cli with immediates

	cli	0, 0

negative: cli with registers

	cli	r16, r16

negative: cli with register pairs

	cli	r25:r24, r25:r24

negative: cli with indices

	cli	Z, Z

# cln instruction

positive: cln with no operands

	cln

negative: cln with immediate

	cln	0

negative: cln with register

	cln	r0

negative: cln with register pair

	cln	r25:r24

negative: cln with index

	cln	Z

negative: cln with immediates

	cln	0, 0

negative: cln with registers

	cln	r16, r16

negative: cln with register pairs

	cln	r25:r24, r25:r24

negative: cln with indices

	cln	Z, Z

# clr instruction

negative: clr with no operands

	clr

negative: clr with immediate

	clr	0

positive: clr with register

	clr	r0
	clr	r31

negative: clr with invalid register

	clr	r32

negative: clr with register pair

	clr	r25:r24

negative: clr with index

	clr	Z

negative: clr with immediates

	clr	0, 0

negative: clr with following immediate

	clr	r16, 0

negative: clr with registers

	clr	r16, r16

negative: clr with register pairs

	clr	r25:r24, r25:r24

negative: clr with following register pair

	clr	r16, r25:r24

negative: clr with indices

	clr	Z, Z

negative: clr with following index

	clr	r16, Z

# cls instruction

positive: cls with no operands

	cls

negative: cls with immediate

	cls	0

negative: cls with register

	cls	r0

negative: cls with register pair

	cls	r25:r24

negative: cls with index

	cls	Z

negative: cls with immediates

	cls	0, 0

negative: cls with registers

	cls	r16, r16

negative: cls with register pairs

	cls	r25:r24, r25:r24

negative: cls with indices

	cls	Z, Z

# clt instruction

positive: clt with no operands

	clt

negative: clt with immediate

	clt	0

negative: clt with register

	clt	r0

negative: clt with register pair

	clt	r25:r24

negative: clt with index

	clt	Z

negative: clt with immediates

	clt	0, 0

negative: clt with registers

	clt	r16, r16

negative: clt with register pairs

	clt	r25:r24, r25:r24

negative: clt with indices

	clt	Z, Z

# clv instruction

positive: clv with no operands

	clv

negative: clv with immediate

	clv	0

negative: clv with register

	clv	r0

negative: clv with register pair

	clv	r25:r24

negative: clv with index

	clv	Z

negative: clv with immediates

	clv	0, 0

negative: clv with registers

	clv	r16, r16

negative: clv with register pairs

	clv	r25:r24, r25:r24

negative: clv with indices

	clv	Z, Z

# clz instruction

positive: clz with no operands

	clz

negative: clz with immediate

	clz	0

negative: clz with register

	clz	r0

negative: clz with register pair

	clz	r25:r24

negative: clz with index

	clz	Z

negative: clz with immediates

	clz	0, 0

negative: clz with registers

	clz	r16, r16

negative: clz with register pairs

	clz	r25:r24, r25:r24

negative: clz with indices

	clz	Z, Z

# com instruction

negative: com with no operands

	com

negative: com with immediate

	com	0

positive: com with register

	com	r0
	com	r31

negative: com with invalid register

	com	r32

negative: com with register pair

	com	r25:r24

negative: com with index

	com	Z

negative: com with immediates

	com	0, 0

negative: com with following immediate

	com	r16, 0

negative: com with registers

	com	r16, r16

negative: com with register pairs

	com	r25:r24, r25:r24

negative: com with following register pair

	com	r16, r25:r24

negative: com with indices

	com	Z, Z

negative: com with following index

	com	r16, Z

# cp instruction

negative: cp with no operands

	cp

negative: cp with immediate

	cp	0

negative: cp with register

	cp	r16

negative: cp with register pair

	cp	r25:r24

negative: cp with index

	cp	Z

negative: cp with immediates

	cp	0, 0

negative: cp with leading immediate

	cp	0, r16

negative: cp with following immediate

	cp	r16, 0

positive: cp with registers

	cp	r0, r15
	cp	r16, r31

negative: cp with invalid registers

	cp	r0, r32

negative: cp with register pairs

	cp	r25:r24, r25:r24

negative: cp with leading register pair

	cp	r25:r24, r16

negative: cp with following register pair

	cp	r16, r25:r24

negative: cp with indices

	cp	Z, Z

negative: cp with leading index

	cp	Z, r16

negative: cp with following index

	cp	r16, Z

# cpc instruction

negative: cpc with no operands

	cpc

negative: cpc with immediate

	cpc	0

negative: cpc with register

	cpc	r16

negative: cpc with register pair

	cpc	r25:r24

negative: cpc with index

	cpc	Z

negative: cpc with immediates

	cpc	0, 0

negative: cpc with leading immediate

	cpc	0, r16

negative: cpc with following immediate

	cpc	r16, 0

positive: cpc with registers

	cpc	r0, r15
	cpc	r16, r31

negative: cpc with invalid registers

	cpc	r0, r32

negative: cpc with register pairs

	cpc	r25:r24, r25:r24

negative: cpc with leading register pair

	cpc	r25:r24, r16

negative: cpc with following register pair

	cpc	r16, r25:r24

negative: cpc with indices

	cpc	Z, Z

negative: cpc with leading index

	cpc	Z, r16

negative: cpc with following index

	cpc	r16, Z

# cpi instruction

negative: cpi with no operands

	cpi

negative: cpi with immediate

	cpi	0

negative: cpi with register

	cpi	r16

negative: cpi with register pair

	cpi	r25:r24

negative: cpi with index

	cpi	Z

negative: cpi with immediates

	cpi	0, 0

positive: cpi with following immediate

	cpi	r16, 0
	cpi	r16, 255

negative: cpi with invalid immediate

	cpi	r16, 256

negative: cpi with registers

	cpi	r16, r16

positive: cpi with leading register

	cpi	r16, 0
	cpi	r31, 0

negative: cpi with invalid register

	cpi	r15, 0

negative: cpi with register pairs

	cpi	r25:r24, r25:r24

negative: cpi with leading register pair

	cpi	r25:r24, 0

negative: cpi with following register pair

	cpi	r16, r25:r24

negative: cpi with indices

	cpi	Z, Z

negative: cpi with leading index

	cpi	Z, 0

negative: cpi with following index

	cpi	r16, Z

# cpse instruction

negative: cpse with no operands

	cpse

negative: cpse with immediate

	cpse	0

negative: cpse with register

	cpse	r16

negative: cpse with register pair

	cpse	r25:r24

negative: cpse with index

	cpse	Z

negative: cpse with immediates

	cpse	0, 0

negative: cpse with leading immediate

	cpse	0, r16

negative: cpse with following immediate

	cpse	r16, 0

positive: cpse with registers

	cpse	r0, r15
	cpse	r16, r31

negative: cpse with invalid registers

	cpse	r0, r32

negative: cpse with register pairs

	cpse	r25:r24, r25:r24

negative: cpse with leading register pair

	cpse	r25:r24, r16

negative: cpse with following register pair

	cpse	r16, r25:r24

negative: cpse with indices

	cpse	Z, Z

negative: cpse with leading index

	cpse	Z, r16

negative: cpse with following index

	cpse	r16, Z

# dec instruction

negative: dec with no operands

	dec

negative: dec with immediate

	dec	0

positive: dec with register

	dec	r0
	dec	r31

negative: dec with invalid register

	dec	r32

negative: dec with register pair

	dec	r25:r24

negative: dec with index

	dec	Z

negative: dec with immediates

	dec	0, 0

negative: dec with following immediate

	dec	r16, 0

negative: dec with registers

	dec	r16, r16

negative: dec with register pairs

	dec	r25:r24, r25:r24

negative: dec with following register pair

	dec	r16, r25:r24

negative: dec with indices

	dec	Z, Z

negative: dec with following index

	dec	r16, Z

# eicall instruction

positive: eicall with no operands

	eicall

negative: eicall with immediate

	eicall	0

negative: eicall with register

	eicall	r0

negative: eicall with register pair

	eicall	r25:r24

negative: eicall with index

	eicall	Z

negative: eicall with immediates

	eicall	0, 0

negative: eicall with registers

	eicall	r16, r16

negative: eicall with register pairs

	eicall	r25:r24, r25:r24

negative: eicall with indices

	eicall	Z, Z

# eijmp instruction

positive: eijmp with no operands

	eijmp

negative: eijmp with immediate

	eijmp	0

negative: eijmp with register

	eijmp	r0

negative: eijmp with register pair

	eijmp	r25:r24

negative: eijmp with index

	eijmp	Z

negative: eijmp with immediates

	eijmp	0, 0

negative: eijmp with registers

	eijmp	r16, r16

negative: eijmp with register pairs

	eijmp	r25:r24, r25:r24

negative: eijmp with indices

	eijmp	Z, Z

# elpm instruction

positive: elpm with no operands

	elpm

negative: elpm with immediate

	elpm	0

negative: elpm with register

	elpm	r16

negative: elpm with register pair

	elpm	r25:r24

negative: elpm with index

	elpm	Z

negative: elpm with immediates

	elpm	0, 0

negative: elpm with leading immediate

	elpm	0, Z

negative: elpm with following immediate

	elpm	r16, 0

negative: elpm with registers

	elpm	r16, r16

positive: elpm with leading register

	elpm	r16, Z

negative: elpm with invalid register

	elpm	r32, Z

negative: elpm with register pairs

	elpm	r25:r24, r25:r24

negative: elpm with leading register pair

	elpm	r25:r24, Z

negative: elpm with following register pair

	elpm	r16, r25:r24

negative: elpm with indices

	elpm	Z, Z

negative: elpm with following x index

	elpm	r16, X

negative: elpm with following y index

	elpm	r16, Y

positive: elpm with following z index

	elpm	r16, Z

negative: elpm with following pre decremented z index

	elpm	r16, -Z

positive: elpm with following post incremented z index

	elpm	r16, Z+

negative: elpm with following z index with displacement

	elpm	r16, Z+0

# eor instruction

negative: eor with no operands

	eor

negative: eor with immediate

	eor	0

negative: eor with register

	eor	r16

negative: eor with register pair

	eor	r25:r24

negative: eor with index

	eor	Z

negative: eor with immediates

	eor	0, 0

negative: eor with leading immediate

	eor	0, r16

negative: eor with following immediate

	eor	r16, 0

positive: eor with registers

	eor	r0, r15
	eor	r16, r31

negative: eor with invalid registers

	eor	r0, r32

negative: eor with register pairs

	eor	r25:r24, r25:r24

negative: eor with leading register pair

	eor	r25:r24, r16

negative: eor with following register pair

	eor	r16, r25:r24

negative: eor with indices

	eor	Z, Z

negative: eor with leading index

	eor	Z, r16

negative: eor with following index

	eor	r16, Z

# fmul instruction

negative: fmul with no operands

	fmul

negative: fmul with immediate

	fmul	0

negative: fmul with register

	fmul	r16

negative: fmul with register pair

	fmul	r25:r24

negative: fmul with index

	fmul	Z

negative: fmul with immediates

	fmul	0, 0

negative: fmul with leading immediate

	fmul	0, r16

negative: fmul with following immediate

	fmul	r16, 0

positive: fmul with registers

	fmul	r16, r16
	fmul	r23, r23

negative: fmul with invalid registers

	fmul	r15, r24

negative: fmul with register pairs

	fmul	r25:r24, r25:r24

negative: fmul with leading register pair

	fmul	r25:r24, r16

negative: fmul with following register pair

	fmul	r16, r25:r24

negative: fmul with indices

	fmul	Z, Z

negative: fmul with leading index

	fmul	Z, r16

negative: fmul with following index

	fmul	r16, Z

# fmuls instruction

negative: fmuls with no operands

	fmuls

negative: fmuls with immediate

	fmuls	0

negative: fmuls with register

	fmuls	r16

negative: fmuls with register pair

	fmuls	r25:r24

negative: fmuls with index

	fmuls	Z

negative: fmuls with immediates

	fmuls	0, 0

negative: fmuls with leading immediate

	fmuls	0, r16

negative: fmuls with following immediate

	fmuls	r16, 0

positive: fmuls with registers

	fmuls	r16, r16
	fmuls	r23, r23

negative: fmuls with invalid registers

	fmuls	r15, r24

negative: fmuls with register pairs

	fmuls	r25:r24, r25:r24

negative: fmuls with leading register pair

	fmuls	r25:r24, r16

negative: fmuls with following register pair

	fmuls	r16, r25:r24

negative: fmuls with indices

	fmuls	Z, Z

negative: fmuls with leading index

	fmuls	Z, r16

negative: fmuls with following index

	fmuls	r16, Z

# fmulsu instruction

negative: fmulsu with no operands

	fmulsu

negative: fmulsu with immediate

	fmulsu	0

negative: fmulsu with register

	fmulsu	r16

negative: fmulsu with register pair

	fmulsu	r25:r24

negative: fmulsu with index

	fmulsu	Z

negative: fmulsu with immediates

	fmulsu	0, 0

negative: fmulsu with leading immediate

	fmulsu	0, r16

negative: fmulsu with following immediate

	fmulsu	r16, 0

positive: fmulsu with registers

	fmulsu	r16, r16
	fmulsu	r23, r23

negative: fmulsu with invalid registers

	fmulsu	r15, r24

negative: fmulsu with register pairs

	fmulsu	r25:r24, r25:r24

negative: fmulsu with leading register pair

	fmulsu	r25:r24, r16

negative: fmulsu with following register pair

	fmulsu	r16, r25:r24

negative: fmulsu with indices

	fmulsu	Z, Z

negative: fmulsu with leading index

	fmulsu	Z, r16

negative: fmulsu with following index

	fmulsu	r16, Z

# icall instruction

positive: icall with no operands

	icall

negative: icall with immediate

	icall	0

negative: icall with register

	icall	r0

negative: icall with register pair

	icall	r25:r24

negative: icall with index

	icall	Z

negative: icall with immediates

	icall	0, 0

negative: icall with registers

	icall	r16, r16

negative: icall with register pairs

	icall	r25:r24, r25:r24

negative: icall with indices

	icall	Z, Z

# ijmp instruction

positive: ijmp with no operands

	ijmp

negative: ijmp with immediate

	ijmp	0

negative: ijmp with register

	ijmp	r0

negative: ijmp with register pair

	ijmp	r25:r24

negative: ijmp with index

	ijmp	Z

negative: ijmp with immediates

	ijmp	0, 0

negative: ijmp with registers

	ijmp	r16, r16

negative: ijmp with register pairs

	ijmp	r25:r24, r25:r24

negative: ijmp with indices

	ijmp	Z, Z

# in instruction

negative: in with no operands

	in

negative: in with immediate

	in	0

negative: in with register

	in	r16

negative: in with register pair

	in	r25:r24

negative: in with index

	in	Z

negative: in with immediates

	in	0, 0

positive: in with following immediate

	in	r16, 0
	in	r16, 63

negative: in with invalid immediate

	in	r16, 64

negative: in with registers

	in	r16, r16

positive: in with leading register

	in	r0, 0
	in	r31, 0

negative: in with invalid register

	in	r32, 0

negative: in with register pairs

	in	r25:r24, r25:r24

negative: in with leading register pair

	in	r25:r24, 0

negative: in with following register pair

	in	r16, r25:r24

negative: in with indices

	in	Z, Z

negative: in with leading index

	in	Z, 0

negative: in with following index

	in	r16, Z

# inc instruction

negative: inc with no operands

	inc

negative: inc with immediate

	inc	0

positive: inc with register

	inc	r0
	inc	r31

negative: inc with invalid register

	inc	r32

negative: inc with register pair

	inc	r25:r24

negative: inc with index

	inc	Z

negative: inc with immediates

	inc	0, 0

negative: inc with following immediate

	inc	r16, 0

negative: inc with registers

	inc	r16, r16

negative: inc with register pairs

	inc	r25:r24, r25:r24

negative: inc with following register pair

	inc	r16, r25:r24

negative: inc with indices

	inc	Z, Z

negative: inc with following index

	inc	r16, Z

# jmp instruction

negative: jmp with no operands

	jmp

positive: jmp with immediate

	jmp	0
	jmp	4194303

negative: jmp with invalid immediate

	jmp	4194304

negative: jmp with register

	jmp	r16

negative: jmp with register pair

	jmp	r25:r24

negative: jmp with index

	jmp	Z

negative: jmp with immediates

	jmp	0, 0

negative: jmp with registers

	jmp	r16, r16

negative: jmp with following register

	jmp	0, r16

negative: jmp with register pairs

	jmp	r25:r24, r25:r24

negative: jmp with following register pair

	jmp	0, r25:r24

negative: jmp with indices

	jmp	Z, Z

negative: jmp with following index

	jmp	0, Z

# lac instruction

negative: lac with no operands

	lac

negative: lac with immediate

	lac	0

negative: lac with register

	lac	r16

negative: lac with register pair

	lac	r25:r24

negative: lac with index

	st	Z

negative: lac with immediates

	st	0, 0

negative: lac with leading immediate

	st	0, Z

negative: lac with following immediate

	st	r16, 0

negative: lac with registers

	lac	r16, r16

positive: lac with following register

	lac	Z, r16

negative: lac with invalid register

	lac	Z, r32

negative: lac with register pairs

	lac	r25:r24, r25:r24

negative: lac with leading register pair

	lac	r25:r24, r16

negative: lac with following register pair

	lac	Z, r25:r24

negative: lac with indices

	lac	Z, Z

negative: lac with leading x index

	lac	X, r16

negative: lac with leading y index

	lac	Y, r16

positive: lac with leading z index

	lac	Z, r16

negative: lac with leading pre decremented z index

	lac	-Z, r16

negative: lac with leading post incremented z index

	lac	Z+, r16

negative: lac with leading z index with displacement

	lac	Z+0, r16

# las instruction

negative: las with no operands

	las

negative: las with immediate

	las	0

negative: las with register

	las	r16

negative: las with register pair

	las	r25:r24

negative: las with index

	st	Z

negative: las with immediates

	st	0, 0

negative: las with leading immediate

	st	0, Z

negative: las with following immediate

	st	r16, 0

negative: las with registers

	las	r16, r16

positive: las with following register

	las	Z, r16

negative: las with invalid register

	las	Z, r32

negative: las with register pairs

	las	r25:r24, r25:r24

negative: las with leading register pair

	las	r25:r24, r16

negative: las with following register pair

	las	Z, r25:r24

negative: las with indices

	las	Z, Z

negative: las with leading x index

	las	X, r16

negative: las with leading y index

	las	Y, r16

positive: las with leading z index

	las	Z, r16

negative: las with leading pre decremented z index

	las	-Z, r16

negative: las with leading post incremented z index

	las	Z+, r16

negative: las with leading z index with displacement

	las	Z+0, r16

# lat instruction

negative: lat with no operands

	lat

negative: lat with immediate

	lat	0

negative: lat with register

	lat	r16

negative: lat with register pair

	lat	r25:r24

negative: lat with index

	st	Z

negative: lat with immediates

	st	0, 0

negative: lat with leading immediate

	st	0, Z

negative: lat with following immediate

	st	r16, 0

negative: lat with registers

	lat	r16, r16

positive: lat with following register

	lat	Z, r16

negative: lat with invalid register

	lat	Z, r32

negative: lat with register pairs

	lat	r25:r24, r25:r24

negative: lat with leading register pair

	lat	r25:r24, r16

negative: lat with following register pair

	lat	Z, r25:r24

negative: lat with indices

	lat	Z, Z

negative: lat with leading x index

	lat	X, r16

negative: lat with leading y index

	lat	Y, r16

positive: lat with leading z index

	lat	Z, r16

negative: lat with leading pre decremented z index

	lat	-Z, r16

negative: lat with leading post incremented z index

	lat	Z+, r16

negative: lat with leading z index with displacement

	lat	Z+0, r16

# ld instruction

negative: ld with no operands

	ld

negative: ld with immediate

	ld	0

negative: ld with register

	ld	r16

negative: ld with register pair

	ld	r25:r24

negative: ld with index

	ld	Z

negative: ld with immediates

	ld	0, 0

negative: ld with leading immediate

	ld	0, Z

negative: ld with following immediate

	ld	r16, 0

negative: ld with registers

	ld	r16, r16

positive: ld with leading register

	ld	r16, Z

negative: ld with invalid register

	ld	r32, Z

negative: ld with register pairs

	ld	r25:r24, r25:r24

negative: ld with leading register pair

	ld	r25:r24, Z

negative: ld with following register pair

	ld	r16, r25:r24

negative: ld with indices

	ld	Z, Z

positive: ld with following x index

	ld	r16, X

positive: ld with following pre decremented x index

	ld	r16, -X

positive: ld with following post incremented x index

	ld	r16, X+

negative: ld with following x index with displacement

	ld	r16, X+0

positive: ld with following y index

	ld	r16, Y

positive: ld with following pre decremented y index

	ld	r16, -Y

positive: ld with following post incremented y index

	ld	r16, Y+

negative: ld with following y index with displacement

	ld	r16, Y+0

positive: ld with following z index

	ld	r16, Z

positive: ld with following pre decremented z index

	ld	r16, -Z

positive: ld with following post incremented z index

	ld	r16, Z+

negative: ld with following z index with displacement

	ld	r16, Z+0

# ldd instruction

negative: ldd with no operands

	ldd

negative: ldd with immediate

	ldd	0

negative: ldd with register

	ldd	r16

negative: ldd with register pair

	ldd	r25:r24

negative: ldd with index

	ldd	Z

negative: ldd with immediates

	ldd	0, 0

negative: ldd with leading immediate

	ldd	0, Z

negative: ldd with following immediate

	ldd	r16, 0

negative: ldd with registers

	ldd	r16, r16

positive: ldd with leading register

	ldd	r16, Z+0

negative: ldd with invalid register

	ldd	r32, Z+0

negative: ldd with register pairs

	ldd	r25:r24, r25:r24

negative: ldd with leading register pair

	ldd	r25:r24, Z

negative: ldd with following register pair

	ldd	r16, r25:r24

negative: ldd with indices

	ldd	Z, Z

negative: ldd with following x index

	ldd	r16, X

negative: ldd with following pre decremented x index

	ldd	r16, -X

negative: ldd with following post incremented x index

	ldd	r16, X+

negative: ldd with following x index with displacement

	ldd	r16, X+0

negative: ldd with following y index

	ldd	r16, Y

negative: ldd with following pre decremented y index

	ldd	r16, -Y

negative: ldd with following post incremented y index

	ldd	r16, Y+

positive: ldd with following y index with displacement

	ldd	r16, Y+0
	ldd	r16, Y+63

negative: ldd with following y index with invalid displacement

	ldd	r16, Y+64

negative: ldd with following z index

	ldd	r16, Z

negative: ldd with following pre decremented z index

	ldd	r16, -Z

negative: ldd with following post incremented z index

	ldd	r16, Z+

positive: ldd with following z index with displacement

	ldd	r16, Z+0
	ldd	r16, Z+63

negative: ldd with following z index with invalid displacement

	ldd	r16, Z+64

# ldi instruction

negative: ldi with no operands

	ldi

negative: ldi with immediate

	ldi	0

negative: ldi with register

	ldi	r16

negative: ldi with register pair

	ldi	r25:r24

negative: ldi with index

	ldi	Z

negative: ldi with immediates

	ldi	0, 0

positive: ldi with following immediate

	ldi	r16, 0
	ldi	r16, 255

negative: ldi with invalid immediate

	ldi	r16, 256

negative: ldi with registers

	ldi	r16, r16

positive: ldi with leading register

	ldi	r16, 0
	ldi	r31, 0

negative: ldi with invalid register

	ldi	r15, 0

negative: ldi with register pairs

	ldi	r25:r24, r25:r24

negative: ldi with leading register pair

	ldi	r25:r24, 0

negative: ldi with following register pair

	ldi	r16, r25:r24

negative: ldi with indices

	ldi	Z, Z

negative: ldi with leading index

	ldi	Z, 0

negative: ldi with following index

	ldi	r16, Z

# lds instruction

negative: lds with no operands

	lds

negative: lds with immediate

	lds	0

negative: lds with register

	lds	r16

negative: lds with register pair

	lds	r25:r24

negative: lds with index

	lds	Z

negative: lds with immediates

	lds	0, 0

positive: lds with following immediate

	lds	r16, 0
	lds	r16, 65535

negative: lds with invalid immediate

	lds	r16, 65536

negative: lds with registers

	lds	r16, r16

positive: lds with leading register

	lds	r0, 0
	lds	r31, 0

negative: lds with invalid register

	lds	r32, 0

negative: lds with register pairs

	lds	r25:r24, r25:r24

negative: lds with leading register pair

	lds	r25:r24, 0

negative: lds with following register pair

	lds	r16, r25:r24

negative: lds with indices

	lds	Z, Z

negative: lds with leading index

	lds	Z, 0

negative: lds with following index

	lds	r16, Z

# lpm instruction

positive: lpm with no operands

	lpm

negative: lpm with immediate

	lpm	0

negative: lpm with register

	lpm	r16

negative: lpm with register pair

	lpm	r25:r24

negative: lpm with index

	lpm	Z

negative: lpm with immediates

	lpm	0, 0

negative: lpm with leading immediate

	lpm	0, Z

negative: lpm with following immediate

	lpm	r16, 0

negative: lpm with registers

	lpm	r16, r16

positive: lpm with leading register

	lpm	r16, Z

negative: lpm with invalid register

	lpm	r32, Z

negative: lpm with register pairs

	lpm	r25:r24, r25:r24

negative: lpm with leading register pair

	lpm	r25:r24, Z

negative: lpm with following register pair

	lpm	r16, r25:r24

negative: lpm with indices

	lpm	Z, Z

negative: lpm with following x index

	lpm	r16, X

negative: lpm with following y index

	lpm	r16, Y

positive: lpm with following z index

	lpm	r16, Z

negative: lpm with following pre decremented z index

	lpm	r16, -Z

positive: lpm with following post incremented z index

	lpm	r16, Z+

negative: lpm with following z index with displacement

	lpm	r16, Z+0

# lsl instruction

negative: lsl with no operands

	lsl

negative: lsl with immediate

	lsl	0

positive: lsl with register

	lsl	r0
	lsl	r31

negative: lsl with invalid register

	lsl	r32

negative: lsl with register pair

	lsl	r25:r24

negative: lsl with index

	lsl	Z

negative: lsl with immediates

	lsl	0, 0

negative: lsl with following immediate

	lsl	r16, 0

negative: lsl with registers

	lsl	r16, r16

negative: lsl with register pairs

	lsl	r25:r24, r25:r24

negative: lsl with following register pair

	lsl	r16, r25:r24

negative: lsl with indices

	lsl	Z, Z

negative: lsl with following index

	lsl	r16, Z

# lsr instruction

negative: lsr with no operands

	lsr

negative: lsr with immediate

	lsr	0

positive: lsr with register

	lsr	r0
	lsr	r31

negative: lsr with invalid register

	lsr	r32

negative: lsr with register pair

	lsr	r25:r24

negative: lsr with index

	lsr	Z

negative: lsr with immediates

	lsr	0, 0

negative: lsr with following immediate

	lsr	r16, 0

negative: lsr with registers

	lsr	r16, r16

negative: lsr with register pairs

	lsr	r25:r24, r25:r24

negative: lsr with following register pair

	lsr	r16, r25:r24

negative: lsr with indices

	lsr	Z, Z

negative: lsr with following index

	lsr	r16, Z

# mov instruction

negative: mov with no operands

	mov

negative: mov with immediate

	mov	0

negative: mov with register

	mov	r16

negative: mov with register pair

	mov	r25:r24

negative: mov with index

	mov	Z

negative: mov with immediates

	mov	0, 0

negative: mov with leading immediate

	mov	0, r16

negative: mov with following immediate

	mov	r16, 0

positive: mov with registers

	mov	r0, r15
	mov	r16, r31

negative: mov with invalid registers

	mov	r0, r32

negative: mov with register pairs

	mov	r25:r24, r25:r24

negative: mov with leading register pair

	mov	r25:r24, r16

negative: mov with following register pair

	mov	r16, r25:r24

negative: mov with indices

	mov	Z, Z

negative: mov with leading index

	mov	Z, r16

negative: mov with following index

	mov	r16, Z

# movw instruction

negative: movw with no operands

	movw

negative: movw with immediate

	movw	0

negative: movw with register

	movw	r16

negative: movw with register pair

	movw	r25:r24

negative: movw with index

	movw	Z

negative: movw with immediates

	movw	0, 0

negative: movw with leading immediate

	movw	0, r25:r24

negative: movw with following immediate

	movw	r25:r24, 0

negative: movw with registers

	movw	r16, r16
	movw	r16, r31

negative: movw with leading register

	movw	r16, r25:r24

negative: movw with following register

	movw	r25:r24, r16

positive: movw with register pairs

	movw	r1:r0, r1:r0
	movw	r31:r30, r31:r30

negative: movw with invalid register pair

	movw	r25:r24, r33:r32

negative: movw with indices

	movw	Z, Z

negative: movw with leading index

	movw	Z, r25:r24

negative: movw with following index

	movw	r25:r24, Z

# mul instruction

negative: mul with no operands

	mul

negative: mul with immediate

	mul	0

negative: mul with register

	mul	r16

negative: mul with register pair

	mul	r25:r24

negative: mul with index

	mul	Z

negative: mul with immediates

	mul	0, 0

negative: mul with leading immediate

	mul	0, r16

negative: mul with following immediate

	mul	r16, 0

positive: mul with registers

	mul	r0, r15
	mul	r16, r31

negative: mul with invalid registers

	mul	r0, r32

negative: mul with register pairs

	mul	r25:r24, r25:r24

negative: mul with leading register pair

	mul	r25:r24, r16

negative: mul with following register pair

	mul	r16, r25:r24

negative: mul with indices

	mul	Z, Z

negative: mul with leading index

	mul	Z, r16

negative: mul with following index

	mul	r16, Z

# muls instruction

negative: muls with no operands

	muls

negative: muls with immediate

	muls	0

negative: muls with register

	muls	r16

negative: muls with register pair

	muls	r25:r24

negative: muls with index

	muls	Z

negative: muls with immediates

	muls	0, 0

negative: muls with leading immediate

	muls	0, r16

negative: muls with following immediate

	muls	r16, 0

positive: muls with registers

	muls	r16, r16
	muls	r31, r31

negative: muls with invalid registers

	muls	r15, r32

negative: muls with register pairs

	muls	r25:r24, r25:r24

negative: muls with leading register pair

	muls	r25:r24, r16

negative: muls with following register pair

	muls	r16, r25:r24

negative: muls with indices

	muls	Z, Z

negative: muls with leading index

	muls	Z, r16

negative: muls with following index

	muls	r16, Z

# mulsu instruction

negative: mulsu with no operands

	mulsu

negative: mulsu with immediate

	mulsu	0

negative: mulsu with register

	mulsu	r16

negative: mulsu with register pair

	mulsu	r25:r24

negative: mulsu with index

	mulsu	Z

negative: mulsu with immediates

	mulsu	0, 0

negative: mulsu with leading immediate

	mulsu	0, r16

negative: mulsu with following immediate

	mulsu	r16, 0

positive: mulsu with registers

	mulsu	r16, r16
	mulsu	r23, r23

negative: mulsu with invalid registers

	mulsu	r15, r24

negative: mulsu with register pairs

	mulsu	r25:r24, r25:r24

negative: mulsu with leading register pair

	mulsu	r25:r24, r16

negative: mulsu with following register pair

	mulsu	r16, r25:r24

negative: mulsu with indices

	mulsu	Z, Z

negative: mulsu with leading index

	mulsu	Z, r16

negative: mulsu with following index

	mulsu	r16, Z

# neg instruction

negative: neg with no operands

	neg

negative: neg with immediate

	neg	0

positive: neg with register

	neg	r0
	neg	r31

negative: neg with invalid register

	neg	r32

negative: neg with register pair

	neg	r25:r24

negative: neg with index

	neg	Z

negative: neg with immediates

	neg	0, 0

negative: neg with following immediate

	neg	r16, 0

negative: neg with registers

	neg	r16, r16

negative: neg with register pairs

	neg	r25:r24, r25:r24

negative: neg with following register pair

	neg	r16, r25:r24

negative: neg with indices

	neg	Z, Z

negative: neg with following index

	neg	r16, Z

# nop instruction

positive: nop with no operands

	nop

negative: nop with immediate

	nop	0

negative: nop with register

	nop	r0

negative: nop with register pair

	nop	r25:r24

negative: nop with index

	nop	Z

negative: nop with immediates

	nop	0, 0

negative: nop with registers

	nop	r16, r16

negative: nop with register pairs

	nop	r25:r24, r25:r24

negative: nop with indices

	nop	Z, Z

# or instruction

negative: or with no operands

	or

negative: or with immediate

	or	0

negative: or with register

	or	r16

negative: or with register pair

	or	r25:r24

negative: or with index

	or	Z

negative: or with immediates

	or	0, 0

negative: or with leading immediate

	or	0, r16

negative: or with following immediate

	or	r16, 0

positive: or with registers

	or	r0, r15
	or	r16, r31

negative: or with invalid registers

	or	r0, r32

negative: or with register pairs

	or	r25:r24, r25:r24

negative: or with leading register pair

	or	r25:r24, r16

negative: or with following register pair

	or	r16, r25:r24

negative: or with indices

	or	Z, Z

negative: or with leading index

	or	Z, r16

negative: or with following index

	or	r16, Z

# ori instruction

negative: ori with no operands

	ori

negative: ori with immediate

	ori	0

negative: ori with register

	ori	r16

negative: ori with register pair

	ori	r25:r24

negative: ori with index

	ori	Z

negative: ori with immediates

	ori	0, 0

positive: ori with following immediate

	ori	r16, 0
	ori	r16, 255

negative: ori with invalid immediate

	ori	r16, 256

negative: ori with registers

	ori	r16, r16

positive: ori with leading register

	ori	r16, 0
	ori	r31, 0

negative: ori with invalid register

	ori	r15, 0

negative: ori with register pairs

	ori	r25:r24, r25:r24

negative: ori with leading register pair

	ori	r25:r24, 0

negative: ori with following register pair

	ori	r16, r25:r24

negative: ori with indices

	ori	Z, Z

negative: ori with leading index

	ori	Z, 0

negative: ori with following index

	ori	r16, Z

# out instruction

negative: out with no operands

	out

negative: out with immediate

	out	0

negative: out with register

	out	r16

negative: out with register pair

	out	r25:r24

negative: out with index

	out	Z

negative: out with immediates

	out	0, 0

positive: out with leading immediate

	out	0, r16
	out	63, r16

negative: out with invalid immediate

	out	64, r16

negative: out with registers

	out	r16, r16

positive: out with following register

	out	0, r0
	out	0, r31

negative: out with invalid register

	out	0, r32

negative: out with register pairs

	out	r25:r24, r25:r24

negative: out with leading register pair

	out	r25:r24, r16

negative: out with following register pair

	out	0, r25:r24

negative: out with indices

	out	Z, Z

negative: out with leading index

	out	Z, r16

negative: out with following index

	out	0, Z

# pop instruction

negative: pop with no operands

	pop

negative: pop with immediate

	pop	0

positive: pop with register

	pop	r0
	pop	r31

negative: pop with invalid register

	pop	r32

negative: pop with register pair

	pop	r25:r24

negative: pop with index

	pop	Z

negative: pop with immediates

	pop	0, 0

negative: pop with following immediate

	pop	r16, 0

negative: pop with registers

	pop	r16, r16

negative: pop with register pairs

	pop	r25:r24, r25:r24

negative: pop with following register pair

	pop	r16, r25:r24

negative: pop with indices

	pop	Z, Z

negative: pop with following index

	pop	r16, Z

# push instruction

negative: push with no operands

	push

negative: push with immediate

	push	0

positive: push with register

	push	r0
	push	r31

negative: push with invalid register

	push	r32

negative: push with register pair

	push	r25:r24

negative: push with index

	push	Z

negative: push with immediates

	push	0, 0

negative: push with following immediate

	push	r16, 0

negative: push with registers

	push	r16, r16

negative: push with register pairs

	push	r25:r24, r25:r24

negative: push with following register pair

	push	r16, r25:r24

negative: push with indices

	push	Z, Z

negative: push with following index

	push	r16, Z

# rcall instruction

negative: rcall with no operands

	rcall

positive: rcall with immediate

	rcall	-2048
	rcall	2047

negative: rcall with invalid immediate

	rcall	2048

negative: rcall with register

	rcall	r16

negative: rcall with register pair

	rcall	r25:r24

negative: rcall with index

	rcall	Z

negative: rcall with immediates

	rcall	0, 0

negative: rcall with registers

	rcall	r16, r16

negative: rcall with following register

	rcall	0, r16

negative: rcall with register pairs

	rcall	r25:r24, r25:r24

negative: rcall with following register pair

	rcall	0, r25:r24

negative: rcall with indices

	rcall	Z, Z

negative: rcall with following index

	rcall	0, Z

# ret instruction

positive: ret with no operands

	ret

negative: ret with immediate

	ret	0

negative: ret with register

	ret	r0

negative: ret with register pair

	ret	r25:r24

negative: ret with index

	ret	Z

negative: ret with immediates

	ret	0, 0

negative: ret with registers

	ret	r16, r16

negative: ret with register pairs

	ret	r25:r24, r25:r24

negative: ret with indices

	ret	Z, Z

# reti instruction

positive: reti with no operands

	reti

negative: reti with immediate

	reti	0

negative: reti with register

	reti	r0

negative: reti with register pair

	reti	r25:r24

negative: reti with index

	reti	Z

negative: reti with immediates

	reti	0, 0

negative: reti with registers

	reti	r16, r16

negative: reti with register pairs

	reti	r25:r24, r25:r24

negative: reti with indices

	reti	Z, Z

# rjmp instruction

negative: rjmp with no operands

	rjmp

positive: rjmp with immediate

	rjmp	-2048
	rjmp	2047

negative: rjmp with invalid immediate

	rjmp	2048

negative: rjmp with register

	rjmp	r16

negative: rjmp with register pair

	rjmp	r25:r24

negative: rjmp with index

	rjmp	Z

negative: rjmp with immediates

	rjmp	0, 0

negative: rjmp with registers

	rjmp	r16, r16

negative: rjmp with following register

	rjmp	0, r16

negative: rjmp with register pairs

	rjmp	r25:r24, r25:r24

negative: rjmp with following register pair

	rjmp	0, r25:r24

negative: rjmp with indices

	rjmp	Z, Z

negative: rjmp with following index

	rjmp	0, Z

# rol instruction

negative: rol with no operands

	rol

negative: rol with immediate

	rol	0

positive: rol with register

	rol	r0
	rol	r31

negative: rol with invalid register

	rol	r32

negative: rol with register pair

	rol	r25:r24

negative: rol with index

	rol	Z

negative: rol with immediates

	rol	0, 0

negative: rol with following immediate

	rol	r16, 0

negative: rol with registers

	rol	r16, r16

negative: rol with register pairs

	rol	r25:r24, r25:r24

negative: rol with following register pair

	rol	r16, r25:r24

negative: rol with indices

	rol	Z, Z

negative: rol with following index

	rol	r16, Z

# ror instruction

negative: ror with no operands

	ror

negative: ror with immediate

	ror	0

positive: ror with register

	ror	r0
	ror	r31

negative: ror with invalid register

	ror	r32

negative: ror with register pair

	ror	r25:r24

negative: ror with index

	ror	Z

negative: ror with immediates

	ror	0, 0

negative: ror with following immediate

	ror	r16, 0

negative: ror with registers

	ror	r16, r16

negative: ror with register pairs

	ror	r25:r24, r25:r24

negative: ror with following register pair

	ror	r16, r25:r24

negative: ror with indices

	ror	Z, Z

negative: ror with following index

	ror	r16, Z

# sbc instruction

negative: sbc with no operands

	sbc

negative: sbc with immediate

	sbc	0

negative: sbc with register

	sbc	r16

negative: sbc with register pair

	sbc	r25:r24

negative: sbc with index

	sbc	Z

negative: sbc with immediates

	sbc	0, 0

negative: sbc with leading immediate

	sbc	0, r16

negative: sbc with following immediate

	sbc	r16, 0

positive: sbc with registers

	sbc	r0, r15
	sbc	r16, r31

negative: sbc with invalid registers

	sbc	r0, r32

negative: sbc with register pairs

	sbc	r25:r24, r25:r24

negative: sbc with leading register pair

	sbc	r25:r24, r16

negative: sbc with following register pair

	sbc	r16, r25:r24

negative: sbc with indices

	sbc	Z, Z

negative: sbc with leading index

	sbc	Z, r16

negative: sbc with following index

	sbc	r16, Z

# sbci instruction

negative: sbci with no operands

	sbci

negative: sbci with immediate

	sbci	0

negative: sbci with register

	sbci	r16

negative: sbci with register pair

	sbci	r25:r24

negative: sbci with index

	sbci	Z

negative: sbci with immediates

	sbci	0, 0

positive: sbci with following immediate

	sbci	r16, 0
	sbci	r16, 255

negative: sbci with invalid immediate

	sbci	r16, 256

negative: sbci with registers

	sbci	r16, r16

positive: sbci with leading register

	sbci	r16, 0
	sbci	r31, 0

negative: sbci with invalid register

	sbci	r15, 0

negative: sbci with register pairs

	sbci	r25:r24, r25:r24

negative: sbci with leading register pair

	sbci	r25:r24, 0

negative: sbci with following register pair

	sbci	r16, r25:r24

negative: sbci with indices

	sbci	Z, Z

negative: sbci with leading index

	sbci	Z, 0

negative: sbci with following index

	sbci	r16, Z

# sbi instruction

negative: sbi with no operands

	sbi

negative: sbi with immediate

	sbi	0

negative: sbi with register

	sbi	r16

negative: sbi with register pair

	sbi	r25:r24

negative: sbi with index

	sbi	Z

positive: sbi with immediates

	sbi	0, 0
	sbi	31, 7

negative: sbi with invalid immediates

	sbi	32, 8

negative: sbi with registers

	sbi	r16, r16
	sbi	r16, r31

negative: sbi with leading register

	sbi	r16, 0

negative: sbi with following register

	sbi	0, r16

negative: sbi with register pairs

	sbi	r25:r24, r25:r24

negative: sbi with leading register pair

	sbi	r25:r24, 0

negative: sbi with following register pair

	sbi	0, r25:r24

negative: sbi with indices

	sbi	Z, Z

negative: sbi with leading index

	sbi	Z, 0

negative: sbi with following index

	sbi	0, Z

# sbic instruction

negative: sbic with no operands

	sbic

negative: sbic with immediate

	sbic	0

negative: sbic with register

	sbic	r16

negative: sbic with register pair

	sbic	r25:r24

negative: sbic with index

	sbic	Z

positive: sbic with immediates

	sbic	0, 0
	sbic	31, 7

negative: sbic with invalid immediates

	sbic	32, 8

negative: sbic with registers

	sbic	r16, r16
	sbic	r16, r31

negative: sbic with leading register

	sbic	r16, 0

negative: sbic with following register

	sbic	0, r16

negative: sbic with register pairs

	sbic	r25:r24, r25:r24

negative: sbic with leading register pair

	sbic	r25:r24, 0

negative: sbic with following register pair

	sbic	0, r25:r24

negative: sbic with indices

	sbic	Z, Z

negative: sbic with leading index

	sbic	Z, 0

negative: sbic with following index

	sbic	0, Z

# sbis instruction

negative: sbis with no operands

	sbis

negative: sbis with immediate

	sbis	0

negative: sbis with register

	sbis	r16

negative: sbis with register pair

	sbis	r25:r24

negative: sbis with index

	sbis	Z

positive: sbis with immediates

	sbis	0, 0
	sbis	31, 7

negative: sbis with invalid immediates

	sbis	32, 8

negative: sbis with registers

	sbis	r16, r16
	sbis	r16, r31

negative: sbis with leading register

	sbis	r16, 0

negative: sbis with following register

	sbis	0, r16

negative: sbis with register pairs

	sbis	r25:r24, r25:r24

negative: sbis with leading register pair

	sbis	r25:r24, 0

negative: sbis with following register pair

	sbis	0, r25:r24

negative: sbis with indices

	sbis	Z, Z

negative: sbis with leading index

	sbis	Z, 0

negative: sbis with following index

	sbis	0, Z

# sbiw instruction

negative: sbiw with no operands

	sbiw

negative: sbiw with immediate

	sbiw	0

negative: sbiw with register

	sbiw	r16

negative: sbiw with register pair

	sbiw	r25:r24

negative: sbiw with index

	sbiw	Z

negative: sbiw with immediates

	sbiw	0, 0

positive: sbiw with following immediate

	sbiw	r25:r24, 0
	sbiw	r25:r24, 63

negative: sbiw with invalid immediate

	sbiw	r25:r24, 64

negative: sbiw with registers

	sbiw	r16, r16
	sbiw	r16, r31

negative: sbiw with leading register

	sbiw	r16, 0

negative: sbiw with following register

	sbiw	r25:r24, r16

negative: sbiw with register pairs

	sbiw	r25:r24, r25:r24

positive: sbiw with leading register pair

	sbiw	r25:r24, 0
	sbiw	r31:r30, 0

negative: sbiw with invalid register pair

	sbiw	r17:r16, 0

negative: sbiw with indices

	sbiw	Z, Z

negative: sbiw with leading index

	sbiw	Z, 0

negative: sbiw with following index

	sbiw	r25:r24, Z

# sbr instruction

negative: sbr with no operands

	sbr

negative: sbr with immediate

	sbr	0

negative: sbr with register

	sbr	r16

negative: sbr with register pair

	sbr	r25:r24

negative: sbr with index

	sbr	Z

negative: sbr with immediates

	sbr	0, 0

positive: sbr with following immediate

	sbr	r16, 0
	sbr	r16, 255

negative: sbr with invalid immediate

	sbr	r16, 256

negative: sbr with registers

	sbr	r16, r16

positive: sbr with leading register

	sbr	r16, 0
	sbr	r31, 0

negative: sbr with invalid register

	sbr	r15, 0

negative: sbr with register pairs

	sbr	r25:r24, r25:r24

negative: sbr with leading register pair

	sbr	r25:r24, 0

negative: sbr with following register pair

	sbr	r16, r25:r24

negative: sbr with indices

	sbr	Z, Z

negative: sbr with leading index

	sbr	Z, 0

negative: sbr with following index

	sbr	r16, Z

# sbrc instruction

negative: sbrc with no operands

	sbrc

negative: sbrc with immediate

	sbrc	0

negative: sbrc with register

	sbrc	r16

negative: sbrc with register pair

	sbrc	r25:r24

negative: sbrc with index

	sbrc	Z

negative: sbrc with immediates

	sbrc	0, 0

positive: sbrc with following immediate

	sbrc	r16, 0
	sbrc	r16, 7

negative: sbrc with invalid immediate

	sbrc	r16, 8

negative: sbrc with registers

	sbrc	r16, r16

positive: sbrc with leading register

	sbrc	r0, 0
	sbrc	r31, 0

negative: sbrc with invalid register

	sbrc	r32, 0

negative: sbrc with register pairs

	sbrc	r25:r24, r25:r24

negative: sbrc with leading register pair

	sbrc	r25:r24, 0

negative: sbrc with following register pair

	sbrc	r16, r25:r24

negative: sbrc with indices

	sbrc	Z, Z

negative: sbrc with leading index

	sbrc	Z, 0

negative: sbrc with following index

	sbrc	r16, Z

# sbrs instruction

negative: sbrs with no operands

	sbrs

negative: sbrs with immediate

	sbrs	0

negative: sbrs with register

	sbrs	r16

negative: sbrs with register pair

	sbrs	r25:r24

negative: sbrs with index

	sbrs	Z

negative: sbrs with immediates

	sbrs	0, 0

positive: sbrs with following immediate

	sbrs	r16, 0
	sbrs	r16, 7

negative: sbrs with invalid immediate

	sbrs	r16, 8

negative: sbrs with registers

	sbrs	r16, r16

positive: sbrs with leading register

	sbrs	r0, 0
	sbrs	r31, 0

negative: sbrs with invalid register

	sbrs	r32, 0

negative: sbrs with register pairs

	sbrs	r25:r24, r25:r24

negative: sbrs with leading register pair

	sbrs	r25:r24, 0

negative: sbrs with following register pair

	sbrs	r16, r25:r24

negative: sbrs with indices

	sbrs	Z, Z

negative: sbrs with leading index

	sbrs	Z, 0

negative: sbrs with following index

	sbrs	r16, Z

# sec instruction

positive: sec with no operands

	sec

negative: sec with immediate

	sec	0

negative: sec with register

	sec	r0

negative: sec with register pair

	sec	r25:r24

negative: sec with index

	sec	Z

negative: sec with immediates

	sec	0, 0

negative: sec with registers

	sec	r16, r16

negative: sec with register pairs

	sec	r25:r24, r25:r24

negative: sec with indices

	sec	Z, Z

# seh instruction

positive: seh with no operands

	seh

negative: seh with immediate

	seh	0

negative: seh with register

	seh	r0

negative: seh with register pair

	seh	r25:r24

negative: seh with index

	seh	Z

negative: seh with immediates

	seh	0, 0

negative: seh with registers

	seh	r16, r16

negative: seh with register pairs

	seh	r25:r24, r25:r24

negative: seh with indices

	seh	Z, Z

# sei instruction

positive: sei with no operands

	sei

negative: sei with immediate

	sei	0

negative: sei with register

	sei	r0

negative: sei with register pair

	sei	r25:r24

negative: sei with index

	sei	Z

negative: sei with immediates

	sei	0, 0

negative: sei with registers

	sei	r16, r16

negative: sei with register pairs

	sei	r25:r24, r25:r24

negative: sei with indices

	sei	Z, Z

# sen instruction

positive: sen with no operands

	sen

negative: sen with immediate

	sen	0

negative: sen with register

	sen	r0

negative: sen with register pair

	sen	r25:r24

negative: sen with index

	sen	Z

negative: sen with immediates

	sen	0, 0

negative: sen with registers

	sen	r16, r16

negative: sen with register pairs

	sen	r25:r24, r25:r24

negative: sen with indices

	sen	Z, Z

# ser instruction

negative: ser with no operands

	ser

negative: ser with immediate

	ser	0

positive: ser with register

	ser	r16
	ser	r31

negative: ser with invalid register

	ser	r15

negative: ser with register pair

	ser	r25:r24

negative: ser with index

	ser	Z

negative: ser with immediates

	ser	0, 0

negative: ser with following immediate

	ser	r16, 0

negative: ser with registers

	ser	r16, r16

negative: ser with register pairs

	ser	r25:r24, r25:r24

negative: ser with following register pair

	ser	r16, r25:r24

negative: ser with indices

	ser	Z, Z

negative: ser with following index

	ser	r16, Z

# ses instruction

positive: ses with no operands

	ses

negative: ses with immediate

	ses	0

negative: ses with register

	ses	r0

negative: ses with register pair

	ses	r25:r24

negative: ses with index

	ses	Z

negative: ses with immediates

	ses	0, 0

negative: ses with registers

	ses	r16, r16

negative: ses with register pairs

	ses	r25:r24, r25:r24

negative: ses with indices

	ses	Z, Z

# set instruction

positive: set with no operands

	set

negative: set with immediate

	set	0

negative: set with register

	set	r0

negative: set with register pair

	set	r25:r24

negative: set with index

	set	Z

negative: set with immediates

	set	0, 0

negative: set with registers

	set	r16, r16

negative: set with register pairs

	set	r25:r24, r25:r24

negative: set with indices

	set	Z, Z

# sev instruction

positive: sev with no operands

	sev

negative: sev with immediate

	sev	0

negative: sev with register

	sev	r0

negative: sev with register pair

	sev	r25:r24

negative: sev with index

	sev	Z

negative: sev with immediates

	sev	0, 0

negative: sev with registers

	sev	r16, r16

negative: sev with register pairs

	sev	r25:r24, r25:r24

negative: sev with indices

	sev	Z, Z

# sez instruction

positive: sez with no operands

	sez

negative: sez with immediate

	sez	0

negative: sez with register

	sez	r0

negative: sez with register pair

	sez	r25:r24

negative: sez with index

	sez	Z

negative: sez with immediates

	sez	0, 0

negative: sez with registers

	sez	r16, r16

negative: sez with register pairs

	sez	r25:r24, r25:r24

negative: sez with indices

	sez	Z, Z

# sleep instruction

positive: sleep with no operands

	sleep

negative: sleep with immediate

	sleep	0

negative: sleep with register

	sleep	r0

negative: sleep with register pair

	sleep	r25:r24

negative: sleep with index

	sleep	Z

negative: sleep with immediates

	sleep	0, 0

negative: sleep with registers

	sleep	r16, r16

negative: sleep with register pairs

	sleep	r25:r24, r25:r24

negative: sleep with indices

	sleep	Z, Z

# spm instruction

positive: spm with no operands

	spm

negative: spm with immediate

	spm	0

negative: spm with register

	spm	r0

negative: spm with register pair

	spm	r25:r24

negative: spm with index

	spm	Z

negative: spm with immediates

	spm	0, 0

negative: spm with registers

	spm	r16, r16

negative: spm with register pairs

	spm	r25:r24, r25:r24

negative: spm with indices

	spm	Z, Z

# st instruction

negative: st with no operands

	st

negative: st with immediate

	st	0

negative: st with register

	st	r16

negative: st with register pair

	st	r25:r24

negative: st with index

	st	Z

negative: st with immediates

	st	0, 0

negative: st with leading immediate

	st	0, Z

negative: st with following immediate

	st	r16, 0

negative: st with registers

	st	r16, r16

positive: st with following register

	st	Z, r16

negative: st with invalid register

	st	Z, r32

negative: st with register pairs

	st	r25:r24, r25:r24

negative: st with leading register pair

	st	r25:r24, r16

negative: st with following register pair

	st	Z, r25:r24

negative: st with indices

	st	Z, Z

positive: st with leading x index

	st	X, r16

positive: st with leading pre decremented x index

	st	-X, r16

positive: st with leading post incremented x index

	st	X+, r16

negative: st with leading x index with displacement

	st	X+0, r16

positive: st with leading y index

	st	Y, r16

positive: st with leading pre decremented y index

	st	-Y, r16

positive: st with leading post incremented y index

	st	Y+, r16

negative: st with leading y index with displacement

	st	Y+0, r16

positive: st with leading z index

	st	Z, r16

positive: st with leading pre decremented z index

	st	-Z, r16

positive: st with leading post incremented z index

	st	Z+, r16

negative: st with leading z index with displacement

	st	Z+0, r16

# std instruction

negative: std with no operands

	std

negative: std with immediate

	std	0

negative: std with register

	std	r16

negative: std with register pair

	std	r25:r24

negative: std with index

	std	Z

negative: std with immediates

	std	0, 0

negative: std with leading immediate

	std	0, r16

negative: std with following immediate

	std	Z, 0

negative: std with registers

	std	r16, r16

positive: std with following register

	std	Z+0, r16

negative: std with invalid register

	std	Z+0, r32

negative: std with register pairs

	std	r25:r24, r25:r24

negative: std with leading register pair

	std	r25:r24, r16

negative: std with following register pair

	std	Z, r25:r24

negative: std with indices

	std	Z, Z

negative: std with leading x index

	std	X, r16

negative: std with leading pre decremented x index

	std	-X, r16

negative: std with leading post incremented x index

	std	X+, r16

negative: std with leading x index with displacement

	std	X+0, r16

negative: std with leading y index

	std	Y, r16

negative: std with leading pre decremented y index

	std	-Y, r16

negative: std with leading post incremented y index

	std	Y+, r16

positive: std with leading y index with displacement

	std	Y+0, r16
	std	Y+63, r16

negative: std with leading y index with invalid displacement

	std	Y+64, r16

negative: std with leading z index

	std	Z, r16

negative: std with leading pre decremented z index

	std	-Z, r16

negative: std with leading post incremented z index

	std	Z+, r16

positive: std with leading z index with displacement

	std	Z+0, r16
	std	Z+63, r16

negative: std with leading z index with invalid displacement

	std	Z+64, r16

# sts instruction

negative: sts with no operands

	sts

negative: sts with immediate

	sts	0

negative: sts with register

	sts	r16

negative: sts with register pair

	sts	r25:r24

negative: sts with index

	sts	Z

negative: sts with immediates

	sts	0, 0

positive: sts with leading immediate

	sts	0, r16
	sts	65535, r16

negative: sts with invalid immediate

	sts	65536, r16

negative: sts with registers

	sts	r16, r16

positive: sts with following register

	sts	0, r0
	sts	0, r31

negative: sts with invalid register

	sts	0, r32

negative: sts with register pairs

	sts	r25:r24, r25:r24

negative: sts with leading register pair

	sts	r25:r24, r16

negative: sts with following register pair

	sts	0, r25:r24

negative: sts with indices

	sts	Z, Z

negative: sts with leading index

	sts	Z, r16

negative: sts with following index

	sts	0, Z

# sub instruction

negative: sub with no operands

	sub

negative: sub with immediate

	sub	0

negative: sub with register

	sub	r16

negative: sub with register pair

	sub	r25:r24

negative: sub with index

	sub	Z

negative: sub with immediates

	sub	0, 0

negative: sub with leading immediate

	sub	0, r16

negative: sub with following immediate

	sub	r16, 0

positive: sub with registers

	sub	r0, r15
	sub	r16, r31

negative: sub with invalid registers

	sub	r0, r32

negative: sub with register pairs

	sub	r25:r24, r25:r24

negative: sub with leading register pair

	sub	r25:r24, r16

negative: sub with following register pair

	sub	r16, r25:r24

negative: sub with indices

	sub	Z, Z

negative: sub with leading index

	sub	Z, r16

negative: sub with following index

	sub	r16, Z

# subi instruction

negative: subi with no operands

	subi

negative: subi with immediate

	subi	0

negative: subi with register

	subi	r16

negative: subi with register pair

	subi	r25:r24

negative: subi with index

	subi	Z

negative: subi with immediates

	subi	0, 0

positive: subi with following immediate

	subi	r16, 0
	subi	r16, 255

negative: subi with invalid immediate

	subi	r16, 256

negative: subi with registers

	subi	r16, r16

positive: subi with leading register

	subi	r16, 0
	subi	r31, 0

negative: subi with invalid register

	subi	r15, 0

negative: subi with register pairs

	subi	r25:r24, r25:r24

negative: subi with leading register pair

	subi	r25:r24, 0

negative: subi with following register pair

	subi	r16, r25:r24

negative: subi with indices

	subi	Z, Z

negative: subi with leading index

	subi	Z, 0

negative: subi with following index

	subi	r16, Z

# swap instruction

negative: swap with no operands

	swap

negative: swap with immediate

	swap	0

positive: swap with register

	swap	r0
	swap	r31

negative: swap with invalid register

	swap	r32

negative: swap with register pair

	swap	r25:r24

negative: swap with index

	swap	Z

negative: swap with immediates

	swap	0, 0

negative: swap with following immediate

	swap	r16, 0

negative: swap with registers

	swap	r16, r16

negative: swap with register pairs

	swap	r25:r24, r25:r24

negative: swap with following register pair

	swap	r16, r25:r24

negative: swap with indices

	swap	Z, Z

negative: swap with following index

	swap	r16, Z

# tst instruction

negative: tst with no operands

	tst

negative: tst with immediate

	tst	0

positive: tst with register

	tst	r0
	tst	r31

negative: tst with invalid register

	tst	r32

negative: tst with register pair

	tst	r25:r24

negative: tst with index

	tst	Z

negative: tst with immediates

	tst	0, 0

negative: tst with following immediate

	tst	r16, 0

negative: tst with registers

	tst	r16, r16

negative: tst with register pairs

	tst	r25:r24, r25:r24

negative: tst with following register pair

	tst	r16, r25:r24

negative: tst with indices

	tst	Z, Z

negative: tst with following index

	tst	r16, Z

# wdr instruction

positive: wdr with no operands

	wdr

negative: wdr with immediate

	wdr	0

negative: wdr with register

	wdr	r0

negative: wdr with register pair

	wdr	r25:r24

negative: wdr with index

	wdr	Z

negative: wdr with immediates

	wdr	0, 0

negative: wdr with registers

	wdr	r16, r16

negative: wdr with register pairs

	wdr	r25:r24, r25:r24

negative: wdr with indices

	wdr	Z, Z

# xch instruction

negative: xch with no operands

	xch

negative: xch with immediate

	xch	0

negative: xch with register

	xch	r16

negative: xch with register pair

	xch	r25:r24

negative: xch with index

	st	Z

negative: xch with immediates

	st	0, 0

negative: xch with leading immediate

	st	0, Z

negative: xch with following immediate

	st	r16, 0

negative: xch with registers

	xch	r16, r16

positive: xch with following register

	xch	Z, r16

negative: xch with invalid register

	xch	Z, r32

negative: xch with register pairs

	xch	r25:r24, r25:r24

negative: xch with leading register pair

	xch	r25:r24, r16

negative: xch with following register pair

	xch	Z, r25:r24

negative: xch with indices

	xch	Z, Z

negative: xch with leading x index

	xch	X, r16

negative: xch with leading y index

	xch	Y, r16

positive: xch with leading z index

	xch	Z, r16

negative: xch with leading pre decremented z index

	xch	-Z, r16

negative: xch with leading post incremented z index

	xch	Z+, r16

negative: xch with leading z index with displacement

	xch	Z+0, r16

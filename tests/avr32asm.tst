# AVR32 assembler test and validation suite
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

# AVR32 assembler

positive: abs instruction

	abs	r0
	abs	r15

positive: acall instruction

	acall	0
	acall	1020

positive: acr instruction

	acr	r0
	acr	r15

positive: adc instruction

	adc	r0, r0, r0
	adc	r15, r15, r15

positive: add instruction

	add	r0, r0
	add	r15, r15
	add	r0, r0, r0 << 0
	add	r15, r15, r15 << 3

positive: addeq instruction

	addeq	r0, r0, r0
	addeq	r15, r15, r15

positive: addne instruction

	addne	r0, r0, r0
	addne	r15, r15, r15

positive: addcc instruction

	addcc	r0, r0, r0
	addcc	r15, r15, r15

positive: addhs instruction

	addhs	r0, r0, r0
	addhs	r15, r15, r15

positive: addcs instruction

	addcs	r0, r0, r0
	addcs	r15, r15, r15

positive: addlo instruction

	addlo	r0, r0, r0
	addlo	r15, r15, r15

positive: addge instruction

	addge	r0, r0, r0
	addge	r15, r15, r15

positive: addlt instruction

	addlt	r0, r0, r0
	addlt	r15, r15, r15

positive: addmi instruction

	addmi	r0, r0, r0
	addmi	r15, r15, r15

positive: addpl instruction

	addpl	r0, r0, r0
	addpl	r15, r15, r15

positive: addls instruction

	addls	r0, r0, r0
	addls	r15, r15, r15

positive: addgt instruction

	addgt	r0, r0, r0
	addgt	r15, r15, r15

positive: addle instruction

	addle	r0, r0, r0
	addle	r15, r15, r15

positive: addhi instruction

	addhi	r0, r0, r0
	addhi	r15, r15, r15

positive: addvs instruction

	addvs	r0, r0, r0
	addvs	r15, r15, r15

positive: addvc instruction

	addvc	r0, r0, r0
	addvc	r15, r15, r15

positive: addqs instruction

	addqs	r0, r0, r0
	addqs	r15, r15, r15

positive: addal instruction

	addal	r0, r0, r0
	addal	r15, r15, r15

positive: addabs instruction

	addabs	r0, r0, r0
	addabs	r15, r15, r15

positive: addhh.w instruction

	addhh.w	r0, r0:b, r0:b
	addhh.w	r15, r15:t, r15:t

positive: and instruction

	and	r0, r0
	and	r15, r15
	and	r0, r0, r0 << 0
	and	r15, r15, r15 << 31
	and	r0, r0, r0 >> 0
	and	r15, r15, r15 >> 31

positive: andeq instruction

	andeq	r0, r0, r0
	andeq	r15, r15, r15

positive: andne instruction

	andne	r0, r0, r0
	andne	r15, r15, r15

positive: andcc instruction

	andcc	r0, r0, r0
	andcc	r15, r15, r15

positive: andhs instruction

	andhs	r0, r0, r0
	andhs	r15, r15, r15

positive: andcs instruction

	andcs	r0, r0, r0
	andcs	r15, r15, r15

positive: andlo instruction

	andlo	r0, r0, r0
	andlo	r15, r15, r15

positive: andge instruction

	andge	r0, r0, r0
	andge	r15, r15, r15

positive: andlt instruction

	andlt	r0, r0, r0
	andlt	r15, r15, r15

positive: andmi instruction

	andmi	r0, r0, r0
	andmi	r15, r15, r15

positive: andpl instruction

	andpl	r0, r0, r0
	andpl	r15, r15, r15

positive: andls instruction

	andls	r0, r0, r0
	andls	r15, r15, r15

positive: andgt instruction

	andgt	r0, r0, r0
	andgt	r15, r15, r15

positive: andle instruction

	andle	r0, r0, r0
	andle	r15, r15, r15

positive: andhi instruction

	andhi	r0, r0, r0
	andhi	r15, r15, r15

positive: andvs instruction

	andvs	r0, r0, r0
	andvs	r15, r15, r15

positive: andvc instruction

	andvc	r0, r0, r0
	andvc	r15, r15, r15

positive: andqs instruction

	andqs	r0, r0, r0
	andqs	r15, r15, r15

positive: andal instruction

	andal	r0, r0, r0
	andal	r15, r15, r15

positive: andh instruction

	andh	r0, 0
	andh	r15, 65535
	andh	r0, 0, COH
	andh	r15, 65535, COH

positive: andl instruction

	andl	r0, 0
	andl	r15, 65535
	andl	r0, 0, COH
	andl	r15, 65535, COH

positive: andn instruction

	andn	r0, r0
	andn	r15, r15

positive: asr instruction

	asr	r0, r0, r0
	asr	r15, r15, r15
	asr	r0, 0
	asr	r15, 31
	asr	r0, r0, 0
	asr	r15, r15, 31

positive: bfexts instruction

	bfexts	r0, r0, 0, 0
	bfexts	r15, r15, 31, 31

positive: bfextu instruction

	bfextu	r0, r0, 0, 0
	bfextu	r15, r15, 31, 31

positive: bfins instruction

	bfins	r0, r0, 0, 0
	bfins	r15, r15, 31, 31

positive: bld instruction

	bld	r0, 0
	bld	r15, 31

positive: breq instruction

	breq	-256
	breq	254
	breq	-2097152
	breq	2097150

positive: brne instruction

	brne	-256
	brne	254
	brne	-2097152
	brne	2097150

positive: brcc instruction

	brcc	-256
	brcc	254
	brcc	-2097152
	brcc	2097150

positive: brhs instruction

	brhs	-256
	brhs	254
	brhs	-2097152
	brhs	2097150

positive: brcs instruction

	brcs	-256
	brcs	254
	brcs	-2097152
	brcs	2097150

positive: brlo instruction

	brlo	-256
	brlo	254
	brlo	-2097152
	brlo	2097150

positive: brge instruction

	brge	-256
	brge	254
	brge	-2097152
	brge	2097150

positive: brlt instruction

	brlt	-256
	brlt	254
	brlt	-2097152
	brlt	2097150

positive: brmi instruction

	brmi	-256
	brmi	254
	brmi	-2097152
	brmi	2097150

positive: brpl instruction

	brpl	-256
	brpl	254
	brpl	-2097152
	brpl	2097150

positive: brls instruction

	brls	-2097152
	brls	2097150

positive: brgt instruction

	brgt	-2097152
	brgt	2097150

positive: brle instruction

	brle	-2097152
	brle	2097150

positive: brhi instruction

	brhi	-2097152
	brhi	2097150

positive: brvs instruction

	brvs	-2097152
	brvs	2097150

positive: brvc instruction

	brvc	-2097152
	brvc	2097150

positive: brqs instruction

	brqs	-2097152
	brqs	2097150

positive: bral instruction

	bral	-2097152
	bral	2097150

positive: breakpoint instruction

	breakpoint

positive: brev instruction

	brev	r0
	brev	r15

positive: bst instruction

	bst	r0, 0
	bst	r15, 31

positive: cache instruction

	cache	r0[-1024], 0
	cache	r15[1023], 15

positive: casts.h instruction

	casts.h	r0
	casts.h	r15

positive: casts.b instruction

	casts.b	r0
	casts.b	r15

positive: castu.h instruction

	castu.h	r0
	castu.h	r15

positive: castu.b instruction

	castu.b	r0
	castu.b	r15

positive: cbr instruction

	cbr	r0, 0
	cbr	r15, 31

positive: clz instruction

	clz	r0, r0
	clz	r15, r15

positive: com instruction

	com	r0
	com	r15

positive: cop instruction

	cop	cp0, cr0, cr0, cr0, 0
	cop	cp7, cr15, cr15, cr15, 127

positive: cp.b instruction

	cp.b	r0, r0
	cp.b	r15, r15

positive: cp.h instruction

	cp.h	r0, r0
	cp.h	r15, r15

positive: cp.w instruction

	cp.w	r0, r0
	cp.w	r15, r15
	cp.w	r0, -32
	cp.w	r15, 31
	cp.w	r0, -1048576
	cp.w	r15, 1048575

positive: cpc instruction

	cpc	r0, r0
	cpc	r15, r15
	cpc	r0
	cpc	r15

positive: csrf instruction

	csrf	0
	csrf	31

positive: csrfcz instruction

	csrfcz	0
	csrfcz	31

positive: divs instruction

	divs	r0, r0, r0
	divs	r14, r15, r15

positive: divu instruction

	divu	r0, r0, r0
	divu	r14, r15, r15

positive: eor instruction

	eor	r0, r0
	eor	r15, r15
	eor	r0, r0, r0 << 0
	eor	r15, r15, r15 << 31
	eor	r0, r0, r0 >> 0
	eor	r15, r15, r15 >> 31

positive: eoreq instruction

	eoreq	r0, r0, r0
	eoreq	r15, r15, r15

positive: eorne instruction

	eorne	r0, r0, r0
	eorne	r15, r15, r15

positive: eorcc instruction

	eorcc	r0, r0, r0
	eorcc	r15, r15, r15

positive: eorhs instruction

	eorhs	r0, r0, r0
	eorhs	r15, r15, r15

positive: eorcs instruction

	eorcs	r0, r0, r0
	eorcs	r15, r15, r15

positive: eorlo instruction

	eorlo	r0, r0, r0
	eorlo	r15, r15, r15

positive: eorge instruction

	eorge	r0, r0, r0
	eorge	r15, r15, r15

positive: eorlt instruction

	eorlt	r0, r0, r0
	eorlt	r15, r15, r15

positive: eormi instruction

	eormi	r0, r0, r0
	eormi	r15, r15, r15

positive: eorpl instruction

	eorpl	r0, r0, r0
	eorpl	r15, r15, r15

positive: eorls instruction

	eorls	r0, r0, r0
	eorls	r15, r15, r15

positive: eorgt instruction

	eorgt	r0, r0, r0
	eorgt	r15, r15, r15

positive: eorle instruction

	eorle	r0, r0, r0
	eorle	r15, r15, r15

positive: eorhi instruction

	eorhi	r0, r0, r0
	eorhi	r15, r15, r15

positive: eorvs instruction

	eorvs	r0, r0, r0
	eorvs	r15, r15, r15

positive: eorvc instruction

	eorvc	r0, r0, r0
	eorvc	r15, r15, r15

positive: eorqs instruction

	eorqs	r0, r0, r0
	eorqs	r15, r15, r15

positive: eoral instruction

	eoral	r0, r0, r0
	eoral	r15, r15, r15

positive: eorh instruction

	eorh	r0, 0
	eorh	r15, 65535

positive: eorl instruction

	eorl	r0, 0
	eorl	r15, 65535

positive: frs instruction

	frs

positive: icall instruction

	icall	r0
	icall	r15

positive: incjosp instruction

	incjosp	-4
	incjosp	4

positive: ld.d instruction

	ld.d	r0, r0++
	ld.d	r14, r15++
	ld.d	r0, --r0
	ld.d	r14, --r15
	ld.d	r0, r0
	ld.d	r14, r15
	ld.d	r0, r0[-32768]
	ld.d	r14, r15[32767]
	ld.d	r0, r0[r0 << 0]
	ld.d	r14, r15[r15 << 3]

positive: ld.sb instruction

	ld.sb	r0, r0[-32768]
	ld.sb	r15, r15[32767]
	ld.sb	r0, r0[r0 << 0]
	ld.sb	r15, r15[r15 << 3]

positive: ld.sbeq instruction

	ld.sbeq	r0, r0[0]
	ld.sbeq	r15, r15[511]

positive: ld.sbne instruction

	ld.sbne	r0, r0[0]
	ld.sbne	r15, r15[511]

positive: ld.sbcc instruction

	ld.sbcc	r0, r0[0]
	ld.sbcc	r15, r15[511]

positive: ld.sbhs instruction

	ld.sbhs	r0, r0[0]
	ld.sbhs	r15, r15[511]

positive: ld.sbcs instruction

	ld.sbcs	r0, r0[0]
	ld.sbcs	r15, r15[511]

positive: ld.sblo instruction

	ld.sblo	r0, r0[0]
	ld.sblo	r15, r15[511]

positive: ld.sbge instruction

	ld.sbge	r0, r0[0]
	ld.sbge	r15, r15[511]

positive: ld.sblt instruction

	ld.sblt	r0, r0[0]
	ld.sblt	r15, r15[511]

positive: ld.sbmi instruction

	ld.sbmi	r0, r0[0]
	ld.sbmi	r15, r15[511]

positive: ld.sbpl instruction

	ld.sbpl	r0, r0[0]
	ld.sbpl	r15, r15[511]

positive: ld.sbls instruction

	ld.sbls	r0, r0[0]
	ld.sbls	r15, r15[511]

positive: ld.sbgt instruction

	ld.sbgt	r0, r0[0]
	ld.sbgt	r15, r15[511]

positive: ld.sble instruction

	ld.sble	r0, r0[0]
	ld.sble	r15, r15[511]

positive: ld.sbhi instruction

	ld.sbhi	r0, r0[0]
	ld.sbhi	r15, r15[511]

positive: ld.sbvs instruction

	ld.sbvs	r0, r0[0]
	ld.sbvs	r15, r15[511]

positive: ld.sbvc instruction

	ld.sbvc	r0, r0[0]
	ld.sbvc	r15, r15[511]

positive: ld.sbqs instruction

	ld.sbqs	r0, r0[0]
	ld.sbqs	r15, r15[511]

positive: ld.sbal instruction

	ld.sbal	r0, r0[0]
	ld.sbal	r15, r15[511]

positive: ld.ub instruction

	ld.ub	r0, r0++
	ld.ub	r15, r15++
	ld.ub	r0, --r0
	ld.ub	r15, --r15
	ld.ub	r0, r0[0]
	ld.ub	r15, r15[7]
	ld.ub	r0, r0[-32768]
	ld.ub	r15, r15[32767]
	ld.ub	r0, r0[r0 << 0]
	ld.ub	r15, r15[r15 << 3]

positive: ld.ubeq instruction

	ld.ubeq	r0, r0[0]
	ld.ubeq	r15, r15[511]

positive: ld.ubne instruction

	ld.ubne	r0, r0[0]
	ld.ubne	r15, r15[511]

positive: ld.ubcc instruction

	ld.ubcc	r0, r0[0]
	ld.ubcc	r15, r15[511]

positive: ld.ubhs instruction

	ld.ubhs	r0, r0[0]
	ld.ubhs	r15, r15[511]

positive: ld.ubcs instruction

	ld.ubcs	r0, r0[0]
	ld.ubcs	r15, r15[511]

positive: ld.ublo instruction

	ld.ublo	r0, r0[0]
	ld.ublo	r15, r15[511]

positive: ld.ubge instruction

	ld.ubge	r0, r0[0]
	ld.ubge	r15, r15[511]

positive: ld.ublt instruction

	ld.ublt	r0, r0[0]
	ld.ublt	r15, r15[511]

positive: ld.ubmi instruction

	ld.ubmi	r0, r0[0]
	ld.ubmi	r15, r15[511]

positive: ld.ubpl instruction

	ld.ubpl	r0, r0[0]
	ld.ubpl	r15, r15[511]

positive: ld.ubls instruction

	ld.ubls	r0, r0[0]
	ld.ubls	r15, r15[511]

positive: ld.ubgt instruction

	ld.ubgt	r0, r0[0]
	ld.ubgt	r15, r15[511]

positive: ld.uble instruction

	ld.uble	r0, r0[0]
	ld.uble	r15, r15[511]

positive: ld.ubhi instruction

	ld.ubhi	r0, r0[0]
	ld.ubhi	r15, r15[511]

positive: ld.ubvs instruction

	ld.ubvs	r0, r0[0]
	ld.ubvs	r15, r15[511]

positive: ld.ubvc instruction

	ld.ubvc	r0, r0[0]
	ld.ubvc	r15, r15[511]

positive: ld.ubqs instruction

	ld.ubqs	r0, r0[0]
	ld.ubqs	r15, r15[511]

positive: ld.ubal instruction

	ld.ubal	r0, r0[0]
	ld.ubal	r15, r15[511]

positive: ld.sh instruction

	ld.sh	r0, r0++
	ld.sh	r15, r15++
	ld.sh	r0, --r0
	ld.sh	r15, --r15
	ld.sh	r0, r0[0]
	ld.sh	r15, r15[14]
	ld.sh	r0, r0[-32768]
	ld.sh	r15, r15[32767]
	ld.sh	r0, r0[r0 << 0]
	ld.sh	r15, r15[r15 << 3]

positive: ld.sheq instruction

	ld.sheq	r0, r0[0]
	ld.sheq	r15, r15[1022]

positive: ld.shne instruction

	ld.shne	r0, r0[0]
	ld.shne	r15, r15[1022]

positive: ld.shcc instruction

	ld.shcc	r0, r0[0]
	ld.shcc	r15, r15[1022]

positive: ld.shhs instruction

	ld.shhs	r0, r0[0]
	ld.shhs	r15, r15[1022]

positive: ld.shcs instruction

	ld.shcs	r0, r0[0]
	ld.shcs	r15, r15[1022]

positive: ld.shlo instruction

	ld.shlo	r0, r0[0]
	ld.shlo	r15, r15[1022]

positive: ld.shge instruction

	ld.shge	r0, r0[0]
	ld.shge	r15, r15[1022]

positive: ld.shlt instruction

	ld.shlt	r0, r0[0]
	ld.shlt	r15, r15[1022]

positive: ld.shmi instruction

	ld.shmi	r0, r0[0]
	ld.shmi	r15, r15[1022]

positive: ld.shpl instruction

	ld.shpl	r0, r0[0]
	ld.shpl	r15, r15[1022]

positive: ld.shls instruction

	ld.shls	r0, r0[0]
	ld.shls	r15, r15[1022]

positive: ld.shgt instruction

	ld.shgt	r0, r0[0]
	ld.shgt	r15, r15[1022]

positive: ld.shle instruction

	ld.shle	r0, r0[0]
	ld.shle	r15, r15[1022]

positive: ld.shhi instruction

	ld.shhi	r0, r0[0]
	ld.shhi	r15, r15[1022]

positive: ld.shvs instruction

	ld.shvs	r0, r0[0]
	ld.shvs	r15, r15[1022]

positive: ld.shvc instruction

	ld.shvc	r0, r0[0]
	ld.shvc	r15, r15[1022]

positive: ld.shqs instruction

	ld.shqs	r0, r0[0]
	ld.shqs	r15, r15[1022]

positive: ld.shal instruction

	ld.shal	r0, r0[0]
	ld.shal	r15, r15[1022]

positive: ld.uh instruction

	ld.uh	r0, r0++
	ld.uh	r15, r15++
	ld.uh	r0, --r0
	ld.uh	r15, --r15
	ld.uh	r0, r0[0]
	ld.uh	r15, r15[14]
	ld.uh	r0, r0[-32768]
	ld.uh	r15, r15[32767]
	ld.uh	r0, r0[r0 << 0]
	ld.uh	r15, r15[r15 << 3]

positive: ld.uheq instruction

	ld.uheq	r0, r0[0]
	ld.uheq	r15, r15[1022]

positive: ld.uhne instruction

	ld.uhne	r0, r0[0]
	ld.uhne	r15, r15[1022]

positive: ld.uhcc instruction

	ld.uhcc	r0, r0[0]
	ld.uhcc	r15, r15[1022]

positive: ld.uhhs instruction

	ld.uhhs	r0, r0[0]
	ld.uhhs	r15, r15[1022]

positive: ld.uhcs instruction

	ld.uhcs	r0, r0[0]
	ld.uhcs	r15, r15[1022]

positive: ld.uhlo instruction

	ld.uhlo	r0, r0[0]
	ld.uhlo	r15, r15[1022]

positive: ld.uhge instruction

	ld.uhge	r0, r0[0]
	ld.uhge	r15, r15[1022]

positive: ld.uhlt instruction

	ld.uhlt	r0, r0[0]
	ld.uhlt	r15, r15[1022]

positive: ld.uhmi instruction

	ld.uhmi	r0, r0[0]
	ld.uhmi	r15, r15[1022]

positive: ld.uhpl instruction

	ld.uhpl	r0, r0[0]
	ld.uhpl	r15, r15[1022]

positive: ld.uhls instruction

	ld.uhls	r0, r0[0]
	ld.uhls	r15, r15[1022]

positive: ld.uhgt instruction

	ld.uhgt	r0, r0[0]
	ld.uhgt	r15, r15[1022]

positive: ld.uhle instruction

	ld.uhle	r0, r0[0]
	ld.uhle	r15, r15[1022]

positive: ld.uhhi instruction

	ld.uhhi	r0, r0[0]
	ld.uhhi	r15, r15[1022]

positive: ld.uhvs instruction

	ld.uhvs	r0, r0[0]
	ld.uhvs	r15, r15[1022]

positive: ld.uhvc instruction

	ld.uhvc	r0, r0[0]
	ld.uhvc	r15, r15[1022]

positive: ld.uhqs instruction

	ld.uhqs	r0, r0[0]
	ld.uhqs	r15, r15[1022]

positive: ld.uhal instruction

	ld.uhal	r0, r0[0]
	ld.uhal	r15, r15[1022]

positive: ld.w instruction

	ld.w	r0, r0++
	ld.w	r15, r15++
	ld.w	r0, --r0
	ld.w	r15, --r15
	ld.w	r0, r0[0]
	ld.w	r15, r15[124]
	ld.w	r0, r0[-32768]
	ld.w	r15, r15[32767]
	ld.w	r0, r0[r0 << 0]
	ld.w	r15, r15[r15 << 3]

positive: ld.weq instruction

	ld.weq	r0, r0[0]
	ld.weq	r15, r15[2044]

positive: ld.wne instruction

	ld.wne	r0, r0[0]
	ld.wne	r15, r15[2044]

positive: ld.wcc instruction

	ld.wcc	r0, r0[0]
	ld.wcc	r15, r15[2044]

positive: ld.whs instruction

	ld.whs	r0, r0[0]
	ld.whs	r15, r15[2044]

positive: ld.wcs instruction

	ld.wcs	r0, r0[0]
	ld.wcs	r15, r15[2044]

positive: ld.wlo instruction

	ld.wlo	r0, r0[0]
	ld.wlo	r15, r15[2044]

positive: ld.wge instruction

	ld.wge	r0, r0[0]
	ld.wge	r15, r15[2044]

positive: ld.wlt instruction

	ld.wlt	r0, r0[0]
	ld.wlt	r15, r15[2044]

positive: ld.wmi instruction

	ld.wmi	r0, r0[0]
	ld.wmi	r15, r15[2044]

positive: ld.wpl instruction

	ld.wpl	r0, r0[0]
	ld.wpl	r15, r15[2044]

positive: ld.wls instruction

	ld.wls	r0, r0[0]
	ld.wls	r15, r15[2044]

positive: ld.wgt instruction

	ld.wgt	r0, r0[0]
	ld.wgt	r15, r15[2044]

positive: ld.wle instruction

	ld.wle	r0, r0[0]
	ld.wle	r15, r15[2044]

positive: ld.whi instruction

	ld.whi	r0, r0[0]
	ld.whi	r15, r15[2044]

positive: ld.wvs instruction

	ld.wvs	r0, r0[0]
	ld.wvs	r15, r15[2044]

positive: ld.wvc instruction

	ld.wvc	r0, r0[0]
	ld.wvc	r15, r15[2044]

positive: ld.wqs instruction

	ld.wqs	r0, r0[0]
	ld.wqs	r15, r15[2044]

positive: ld.wal instruction

	ld.wal	r0, r0[0]
	ld.wal	r15, r15[2044]

positive: ldc.d instruction

	ldc.d	cp0, cr0, r0[0]
	ldc.d	cp7, cr14, r15[1020]
	ldc.d	cp0, cr0, --r0
	ldc.d	cp7, cr14, --r15
	ldc.d	cp0, cr0, r0[r0 << 0]
	ldc.d	cp7, cr14, r15[r15 << 3]

positive: ldc.w instruction

	ldc.w	cp0, cr0, r0[0]
	ldc.w	cp7, cr15, r15[1020]
	ldc.w	cp0, cr0, --r0
	ldc.w	cp7, cr15, --r15
	ldc.w	cp0, cr0, r0[r0 << 0]
	ldc.w	cp7, cr15, r15[r15 << 3]

positive: ldc0.d instruction

	ldc0.d	cr0, r0[0]
	ldc0.d	cr14, r15[16380]

positive: ldc0.w instruction

	ldc0.w	cr0, r0[0]
	ldc0.w	cr15, r15[16380]

positive: lddpc instruction

	lddpc	r0, 0
	lddpc	r0, pc[0]
	lddpc	r15, 508
	lddpc	r15, pc[508]

positive: lddsp instruction

	lddsp	r0, sp[0]
	lddsp	r15, sp[508]

positive: ldins.b instruction

	ldins.b	r0:b, r0[-2048]
	ldins.b	r15:t, r15[2047]

positive: ldins.h instruction

	ldins.h	r0:b, r0[-4096]
	ldins.h	r15:t, r15[4094]

positive: ldswp.sh instruction

	ldswp.sh	r0, r0[-4096]
	ldswp.sh	r15, r15[4094]

positive: ldswp.uh instruction

	ldswp.uh	r0, r0[-4096]
	ldswp.uh	r15, r15[4094]

positive: ldswp.w instruction

	ldswp.w	r0, r0[-8192]
	ldswp.w	r15, r15[8188]

positive: lsl instruction

	lsl	r0, r0, r0
	lsl	r15, r15, r15
	lsl	r0, 0
	lsl	r15, 31
	lsl	r0, r0, 0
	lsl	r15, r15, 31

positive: lsr instruction

	lsr	r0, r0, r0
	lsr	r15, r15, r15
	lsr	r0, 0
	lsr	r15, 31
	lsr	r0, r0, 0
	lsr	r15, r15, 31

positive: mac instruction

	mac	r0, r0, r0
	mac	r15, r15, r15

positive: machh.d instruction

	machh.d	r0, r0:b, r0:b
	machh.d	r14, r15:t, r15:t

positive: machh.w instruction

	machh.w	r0, r0:b, r0:b
	machh.w	r15, r15:t, r15:t

positive: macs.d instruction

	macs.d	r0, r0, r0
	macs.d	r14, r15, r15

positive: macsathh.w instruction

	macsathh.w	r0, r0:b, r0:b
	macsathh.w	r15, r15:t, r15:t

positive: macwh.d instruction

	macwh.d	r0, r0, r0:b
	macwh.d	r14, r15, r15:t

positive: macu.d instruction

	macu.d	r0, r0, r0
	macu.d	r14, r15, r15

positive: max instruction

	max	r0, r0, r0
	max	r15, r15, r15

positive: mcall instruction

	mcall	r0[-131072]
	mcall	r15[131068]

positive: memc instruction

	memc	-65536, 0
	memc	65532, 31

positive: mems instruction

	mems	-65536, 0
	mems	65532, 31

positive: memt instruction

	memt	-65536, 0
	memt	65532, 31

positive: mfdr instruction

	mfdr	r0, 0
	mfdr	r15, 1020

positive: mfsr instruction

	mfsr	r0, 0
	mfsr	r15, 1020

positive: min instruction

	min	r0, r0, r0
	min	r15, r15, r15

positive: mov instruction

	mov	r0, -128
	mov	r15, 127
	mov	r0, -1048576
	mov	r15, 1048575
	mov	r0, r0
	mov	r15, r15

positive: moveq instruction

	moveq	r0, -128
	moveq	r15, 127

positive: movne instruction

	movne	r0, -128
	movne	r15, 127

positive: movcc instruction

	movcc	r0, -128
	movcc	r15, 127

positive: movhs instruction

	movhs	r0, -128
	movhs	r15, 127

positive: movcs instruction

	movcs	r0, -128
	movcs	r15, 127

positive: movlo instruction

	movlo	r0, -128
	movlo	r15, 127

positive: movge instruction

	movge	r0, -128
	movge	r15, 127

positive: movlt instruction

	movlt	r0, -128
	movlt	r15, 127

positive: movmi instruction

	movmi	r0, -128
	movmi	r15, 127

positive: movpl instruction

	movpl	r0, -128
	movpl	r15, 127

positive: movls instruction

	movls	r0, -128
	movls	r15, 127

positive: movgt instruction

	movgt	r0, -128
	movgt	r15, 127

positive: movle instruction

	movle	r0, -128
	movle	r15, 127

positive: movhi instruction

	movhi	r0, -128
	movhi	r15, 127

positive: movvs instruction

	movvs	r0, -128
	movvs	r15, 127

positive: movvc instruction

	movvc	r0, -128
	movvc	r15, 127

positive: movqs instruction

	movqs	r0, -128
	movqs	r15, 127

positive: moval instruction

	moval	r0, -128
	moval	r15, 127

positive: movh instruction

	movh	r0, 0
	movh	r15, 35535

positive: movl instruction

	movl	r0, 0
	movl	r15, 35535

positive: mtdr instruction

	mtdr	0, r0
	mtdr	1020, r15

positive: mtsr instruction

	mtsr	0, r0
	mtsr	1020, r15

positive: mul instruction

	mul	r0, r0
	mul	r15, r15
	mul	r0, r0, r0
	mul	r15, r15, r15
	mul	r0, r0, -128
	mul	r15, r15, 127

positive: mulhh.w instruction

	mulhh.w	r0, r0:b, r0:b
	mulhh.w	r15, r15:t, r15:t

positive: mulnhh.w instruction

	mulnhh.w	r0, r0:b, r0:b
	mulnhh.w	r15, r15:t, r15:t

positive: mulnwh.d instruction

	mulnwh.d	r0, r0, r0:b
	mulnwh.d	r14, r15, r15:t

positive: muls.d instruction

	muls.d	r0, r0, r0
	muls.d	r14, r15, r15

positive: mulsathh.h instruction

	mulsathh.h	r0, r0:b, r0:b
	mulsathh.h	r15, r15:t, r15:t

positive: mulsathh.w instruction

	mulsathh.w	r0, r0:b, r0:b
	mulsathh.w	r15, r15:t, r15:t

positive: mulsatrndhh.h instruction

	mulsatrndhh.h	r0, r0:b, r0:b
	mulsatrndhh.h	r15, r15:t, r15:t

positive: mulsatrndhh.w instruction

	mulsatrndhh.w	r0, r0:b, r0:b
	mulsatrndhh.w	r15, r15:t, r15:t

positive: mulsatwh.w instruction

	mulsatwh.w	r0, r0, r0:b
	mulsatwh.w	r15, r15, r15:t

positive: mulu.d instruction

	mulu.d	r0, r0, r0
	mulu.d	r14, r15, r15

positive: mulwh.d instruction

	mulwh.d	r0, r0, r0:b
	mulwh.d	r14, r15, r15:t

positive: musfr instruction

	musfr	r0
	musfr	r15

positive: mustr instruction

	mustr	r0
	mustr	r15

positive: mvcr.d instruction

	mvcr.d	cp0, r0, cr0
	mvcr.d	cp7, r14, cr14

positive: mvcr.w instruction

	mvcr.w	cp0, r0, cr0
	mvcr.w	cp7, r15, cr15

positive: mvrc.d instruction

	mvrc.d	cp0, cr0, r0
	mvrc.d	cp7, cr14, r14

positive: mvrc.w instruction

	mvrc.w	cp0, cr0, r0
	mvrc.w	cp7, cr15, r15

positive: neg instruction

	neg	r0
	neg	r15

positive: nop instruction

	nop

positive: or instruction

	or	r0, r0
	or	r15, r15
	or	r0, r0, r0 << 0
	or	r15, r15, r15 << 31
	or	r0, r0, r0 >> 0
	or	r15, r15, r15 >> 31

positive: oreq instruction

	oreq	r0, r0, r0
	oreq	r15, r15, r15

positive: orne instruction

	orne	r0, r0, r0
	orne	r15, r15, r15

positive: orcc instruction

	orcc	r0, r0, r0
	orcc	r15, r15, r15

positive: orhs instruction

	orhs	r0, r0, r0
	orhs	r15, r15, r15

positive: orcs instruction

	orcs	r0, r0, r0
	orcs	r15, r15, r15

positive: orlo instruction

	orlo	r0, r0, r0
	orlo	r15, r15, r15

positive: orge instruction

	orge	r0, r0, r0
	orge	r15, r15, r15

positive: orlt instruction

	orlt	r0, r0, r0
	orlt	r15, r15, r15

positive: ormi instruction

	ormi	r0, r0, r0
	ormi	r15, r15, r15

positive: orpl instruction

	orpl	r0, r0, r0
	orpl	r15, r15, r15

positive: orls instruction

	orls	r0, r0, r0
	orls	r15, r15, r15

positive: orgt instruction

	orgt	r0, r0, r0
	orgt	r15, r15, r15

positive: orle instruction

	orle	r0, r0, r0
	orle	r15, r15, r15

positive: orhi instruction

	orhi	r0, r0, r0
	orhi	r15, r15, r15

positive: orvs instruction

	orvs	r0, r0, r0
	orvs	r15, r15, r15

positive: orvc instruction

	orvc	r0, r0, r0
	orvc	r15, r15, r15

positive: orqs instruction

	orqs	r0, r0, r0
	orqs	r15, r15, r15

positive: oral instruction

	oral	r0, r0, r0
	oral	r15, r15, r15

positive: orh instruction

	orh	r0, 0
	orh	r15, 65535

positive: orl instruction

	orl	r0, 0
	orl	r15, 65535

positive: pabs.sb instruction

	pabs.sb	r0, r0
	pabs.sb	r15, r15

positive: pabs.sh instruction

	pabs.sh	r0, r0
	pabs.sh	r15, r15

positive: packsh.ub instruction

	packsh.ub	r0, r0, r0
	packsh.ub	r15, r15, r15

positive: packsh.sb instruction

	packsh.sb	r0, r0, r0
	packsh.sb	r15, r15, r15

positive: packw.sh instruction

	packw.sh	r0, r0, r0
	packw.sh	r15, r15, r15

positive: padd.b instruction

	padd.b	r0, r0, r0
	padd.b	r15, r15, r15

positive: padd.h instruction

	padd.h	r0, r0, r0
	padd.h	r15, r15, r15

positive: paddh.ub instruction

	paddh.ub	r0, r0, r0
	paddh.ub	r15, r15, r15

positive: paddh.sh instruction

	paddh.sh	r0, r0, r0
	paddh.sh	r15, r15, r15

positive: padds.ub instruction

	padds.ub	r0, r0, r0
	padds.ub	r15, r15, r15

positive: padds.sb instruction

	padds.sb	r0, r0, r0
	padds.sb	r15, r15, r15

positive: padds.uh instruction

	padds.uh	r0, r0, r0
	padds.uh	r15, r15, r15

positive: padds.sh instruction

	padds.sh	r0, r0, r0
	padds.sh	r15, r15, r15

positive: paddsub.h instruction

	paddsub.h	r0, r0:b, r0:b
	paddsub.h	r15, r15:t, r15:t

positive: paddsubh.sh instruction

	paddsubh.sh	r0, r0:b, r0:b
	paddsubh.sh	r15, r15:t, r15:t

positive: paddsubs.uh instruction

	paddsubs.uh	r0, r0:b, r0:b
	paddsubs.uh	r15, r15:t, r15:t

positive: paddsubs.sh instruction

	paddsubs.sh	r0, r0:b, r0:b
	paddsubs.sh	r15, r15:t, r15:t

positive: paddx.h instruction

	paddx.h	r0, r0, r0
	paddx.h	r15, r15, r15

positive: paddxh.sh instruction

	paddxh.sh	r0, r0, r0
	paddxh.sh	r15, r15, r15

positive: paddxs.uh instruction

	paddxs.uh	r0, r0, r0
	paddxs.uh	r15, r15, r15

positive: paddxs.sh instruction

	paddxs.sh	r0, r0, r0
	paddxs.sh	r15, r15, r15

positive: pasr.b instruction

	pasr.b	r0, r0, 0
	pasr.b	r15, r15, 7

positive: pasr.h instruction

	pasr.h	r0, r0, 0
	pasr.h	r15, r15, 15

positive: pavg.ub instruction

	pavg.ub	r0, r0, r0
	pavg.ub	r15, r15, r15

positive: pavg.sh instruction

	pavg.sh	r0, r0, r0
	pavg.sh	r15, r15, r15

positive: plsl.b instruction

	plsl.b	r0, r0, 0
	plsl.b	r15, r15, 7

positive: plsl.h instruction

	plsl.h	r0, r0, 0
	plsl.h	r15, r15, 15

positive: plsr.b instruction

	plsr.b	r0, r0, 0
	plsr.b	r15, r15, 7

positive: plsr.h instruction

	plsr.h	r0, r0, 0
	plsr.h	r15, r15, 15

positive: pmax.ub instruction

	pmax.ub	r0, r0, r0
	pmax.ub	r15, r15, r15

positive: pmax.sh instruction

	pmax.sh	r0, r0, r0
	pmax.sh	r15, r15, r15

positive: pmin.ub instruction

	pmin.ub	r0, r0, r0
	pmin.ub	r15, r15, r15

positive: pmin.sh instruction

	pmin.sh	r0, r0, r0
	pmin.sh	r15, r15, r15

positive: popjc instruction

	popjc

positive: pref instruction

	pref	r0[-32768]
	pref	r15[32767]

positive: psad instruction

	psad	r0, r0, r0
	psad	r15, r15, r15

positive: psub.b instruction

	psub.b	r0, r0, r0
	psub.b	r15, r15, r15

positive: psub.h instruction

	psub.h	r0, r0, r0
	psub.h	r15, r15, r15

positive: psubadd.h instruction

	psubadd.h	r0, r0:b, r0:b
	psubadd.h	r15, r15:t, r15:t

positive: psubaddh.sh instruction

	psubaddh.sh	r0, r0:b, r0:b
	psubaddh.sh	r15, r15:t, r15:t

positive: psubadds.uh instruction

	psubadds.uh	r0, r0:b, r0:b
	psubadds.uh	r15, r15:t, r15:t

positive: psubadds.sh instruction

	psubadds.sh	r0, r0:b, r0:b
	psubadds.sh	r15, r15:t, r15:t

positive: psubh.ub instruction

	psubh.ub	r0, r0, r0
	psubh.ub	r15, r15, r15

positive: psubh.sh instruction

	psubh.sh	r0, r0, r0
	psubh.sh	r15, r15, r15

positive: psubs.ub instruction

	psubs.ub	r0, r0, r0
	psubs.ub	r15, r15, r15

positive: psubs.sb instruction

	psubs.sb	r0, r0, r0
	psubs.sb	r15, r15, r15

positive: psubs.uh instruction

	psubs.uh	r0, r0, r0
	psubs.uh	r15, r15, r15

positive: psubs.sh instruction

	psubs.sh	r0, r0, r0
	psubs.sh	r15, r15, r15

positive: psubx.h instruction

	psubx.h	r0, r0, r0
	psubx.h	r15, r15, r15

positive: psubxh.sh instruction

	psubxh.sh	r0, r0, r0
	psubxh.sh	r15, r15, r15

positive: psubxs.uh instruction

	psubxs.uh	r0, r0, r0
	psubxs.uh	r15, r15, r15

positive: psubxs.sh instruction

	psubxs.sh	r0, r0, r0
	psubxs.sh	r15, r15, r15

positive: punpcksb.h instruction

	punpcksb.h	r0, r0:b
	punpcksb.h	r15, r15:t

positive: punpckub.h instruction

	punpckub.h	r0, r0:b
	punpckub.h	r15, r15:t

positive: pushjc instruction

	pushjc

positive: rcall instruction

	rcall	-1024
	rcall	pc[-1024]
	rcall	1022
	rcall	pc[1022]
	rcall	-2097152
	rcall	pc[-2097152]
	rcall	2097150
	rcall	pc[2097150]

positive: reteq instruction

	reteq	r0
	reteq	r15

positive: retne instruction

	retne	r0
	retne	r15

positive: retcc instruction

	retcc	r0
	retcc	r15

positive: reths instruction

	reths	r0
	reths	r15

positive: retcs instruction

	retcs	r0
	retcs	r15

positive: retlo instruction

	retlo	r0
	retlo	r15

positive: retge instruction

	retge	r0
	retge	r15

positive: retlt instruction

	retlt	r0
	retlt	r15

positive: retmi instruction

	retmi	r0
	retmi	r15

positive: retpl instruction

	retpl	r0
	retpl	r15

positive: retls instruction

	retls	r0
	retls	r15

positive: retgt instruction

	retgt	r0
	retgt	r15

positive: retle instruction

	retle	r0
	retle	r15

positive: rethi instruction

	rethi	r0
	rethi	r15

positive: retvs instruction

	retvs	r0
	retvs	r15

positive: retvc instruction

	retvc	r0
	retvc	r15

positive: retqs instruction

	retqs	r0
	retqs	r15

positive: retal instruction

	retal	r0
	retal	r15

positive: retd instruction

	retd

positive: rete instruction

	rete

positive: retj instruction

	retj

positive: rets instruction

	rets

positive: retss instruction

	retss

positive: rjmp instruction

	rjmp	-1024
	rjmp	pc[-1024]
	rjmp	1022
	rjmp	pc[1022]

positive: rol instruction

	rol	r0
	rol	r15

positive: ror instruction

	ror	r0
	ror	r15

positive: rsub instruction

	rsub	r0, r0
	rsub	r15, r15
	rsub	r0, r0, -128
	rsub	r15, r15, 127

positive: rsubeq instruction

	rsubeq	r0, -128
	rsubeq	r15, 127

positive: rsubne instruction

	rsubne	r0, -128
	rsubne	r15, 127

positive: rsubcc instruction

	rsubcc	r0, -128
	rsubcc	r15, 127

positive: rsubhs instruction

	rsubhs	r0, -128
	rsubhs	r15, 127

positive: rsubcs instruction

	rsubcs	r0, -128
	rsubcs	r15, 127

positive: rsublo instruction

	rsublo	r0, -128
	rsublo	r15, 127

positive: rsubge instruction

	rsubge	r0, -128
	rsubge	r15, 127

positive: rsublt instruction

	rsublt	r0, -128
	rsublt	r15, 127

positive: rsubmi instruction

	rsubmi	r0, -128
	rsubmi	r15, 127

positive: rsubpl instruction

	rsubpl	r0, -128
	rsubpl	r15, 127

positive: rsubls instruction

	rsubls	r0, -128
	rsubls	r15, 127

positive: rsubgt instruction

	rsubgt	r0, -128
	rsubgt	r15, 127

positive: rsuble instruction

	rsuble	r0, -128
	rsuble	r15, 127

positive: rsubhi instruction

	rsubhi	r0, -128
	rsubhi	r15, 127

positive: rsubvs instruction

	rsubvs	r0, -128
	rsubvs	r15, 127

positive: rsubvc instruction

	rsubvc	r0, -128
	rsubvc	r15, 127

positive: rsubqs instruction

	rsubqs	r0, -128
	rsubqs	r15, 127

positive: rsubal instruction

	rsubal	r0, -128
	rsubal	r15, 127

positive: satadd.h instruction

	satadd.h	r0, r0, r0
	satadd.h	r15, r15, r15

positive: satadd.w instruction

	satadd.w	r0, r0, r0
	satadd.w	r15, r15, r15

positive: satrnds instruction

	satrnds	r0 >> 0, 0
	satrnds	r15 >> 31, 31

positive: satrndu instruction

	satrndu	r0 >> 0, 0
	satrndu	r15 >> 31, 31

positive: sats instruction

	sats	r0 >> 0, 0
	sats	r15 >> 31, 31

positive: satsub.h instruction

	satsub.h	r0, r0, r0
	satsub.h	r15, r15, r15

positive: satsub.w instruction

	satsub.w	r0, r0, r0
	satsub.w	r15, r15, r15
	satsub.w	r0, r0, -32768
	satsub.w	r15, r15, 32767

positive: satu instruction

	satu	r0 >> 0, 0
	satu	r15 >> 31, 31

positive: sbc instruction

	sbc	r0, r0, r0
	sbc	r15, r15, r15

positive: sbr instruction

	sbr	r0, 0
	sbr	r15, 31

positive: scall instruction

	scall

positive: scr instruction

	scr	r0
	scr	r15

positive: sleep instruction

	sleep	0
	sleep	255
positive: sreq instruction

	sreq	r0
	sreq	r15

positive: srne instruction

	srne	r0
	srne	r15

positive: srcc instruction

	srcc	r0
	srcc	r15

positive: srhs instruction

	srhs	r0
	srhs	r15

positive: srcs instruction

	srcs	r0
	srcs	r15

positive: srlo instruction

	srlo	r0
	srlo	r15

positive: srge instruction

	srge	r0
	srge	r15

positive: srlt instruction

	srlt	r0
	srlt	r15

positive: srmi instruction

	srmi	r0
	srmi	r15

positive: srpl instruction

	srpl	r0
	srpl	r15

positive: srls instruction

	srls	r0
	srls	r15

positive: srgt instruction

	srgt	r0
	srgt	r15

positive: srle instruction

	srle	r0
	srle	r15

positive: srhi instruction

	srhi	r0
	srhi	r15

positive: srvs instruction

	srvs	r0
	srvs	r15

positive: srvc instruction

	srvc	r0
	srvc	r15

positive: srqs instruction

	srqs	r0
	srqs	r15

positive: sral instruction

	sral	r0
	sral	r15

positive: sscall instruction

	sscall

positive: ssrf instruction

	ssrf	0
	ssrf	31

positive: st.b instruction

	st.b	r0++, r0
	st.b	r15++, r15
	st.b	--r0, r0
	st.b	--r15, r15
	st.b	r0[0], r0
	st.b	r15[7], r15
	st.b	r0[-32768], r0
	st.b	r15[32767], r15
	st.b	r0[r0 << 0], r0
	st.b	r15[r15 << 3], r15

positive: st.beq instruction

	st.beq	r0[0], r0
	st.beq	r15[511], r15

positive: st.bne instruction

	st.bne	r0[0], r0
	st.bne	r15[511], r15

positive: st.bcc instruction

	st.bcc	r0[0], r0
	st.bcc	r15[511], r15

positive: st.bhs instruction

	st.bhs	r0[0], r0
	st.bhs	r15[511], r15

positive: st.bcs instruction

	st.bcs	r0[0], r0
	st.bcs	r15[511], r15

positive: st.blo instruction

	st.blo	r0[0], r0
	st.blo	r15[511], r15

positive: st.bge instruction

	st.bge	r0[0], r0
	st.bge	r15[511], r15

positive: st.blt instruction

	st.blt	r0[0], r0
	st.blt	r15[511], r15

positive: st.bmi instruction

	st.bmi	r0[0], r0
	st.bmi	r15[511], r15

positive: st.bpl instruction

	st.bpl	r0[0], r0
	st.bpl	r15[511], r15

positive: st.bls instruction

	st.bls	r0[0], r0
	st.bls	r15[511], r15

positive: st.bgt instruction

	st.bgt	r0[0], r0
	st.bgt	r15[511], r15

positive: st.ble instruction

	st.ble	r0[0], r0
	st.ble	r15[511], r15

positive: st.bhi instruction

	st.bhi	r0[0], r0
	st.bhi	r15[511], r15

positive: st.bvs instruction

	st.bvs	r0[0], r0
	st.bvs	r15[511], r15

positive: st.bvc instruction

	st.bvc	r0[0], r0
	st.bvc	r15[511], r15

positive: st.bqs instruction

	st.bqs	r0[0], r0
	st.bqs	r15[511], r15

positive: st.bal instruction

	st.bal	r0[0], r0
	st.bal	r15[511], r15

positive: st.d instruction

	st.d	r0++, r0
	st.d	r15++, r14
	st.d	--r0, r0
	st.d	--r15, r14
	st.d	r0, r0
	st.d	r15, r14
	st.d	r0[-32768], r0
	st.d	r15[32767], r14
	st.d	r0[r0 << 0], r0
	st.d	r15[r15 << 3], r14

positive: st.h instruction

	st.h	r0++, r0
	st.h	r15++, r15
	st.h	--r0, r0
	st.h	--r15, r15
	st.h	r0[0], r0
	st.h	r15[14], r15
	st.h	r0[-32768], r0
	st.h	r15[32767], r15
	st.h	r0[r0 << 0], r0
	st.h	r15[r15 << 3], r15

positive: st.heq instruction

	st.heq	r0[0], r0
	st.heq	r15[1022], r15

positive: st.hne instruction

	st.hne	r0[0], r0
	st.hne	r15[1022], r15

positive: st.hcc instruction

	st.hcc	r0[0], r0
	st.hcc	r15[1022], r15

positive: st.hhs instruction

	st.hhs	r0[0], r0
	st.hhs	r15[1022], r15

positive: st.hcs instruction

	st.hcs	r0[0], r0
	st.hcs	r15[1022], r15

positive: st.hlo instruction

	st.hlo	r0[0], r0
	st.hlo	r15[1022], r15

positive: st.hge instruction

	st.hge	r0[0], r0
	st.hge	r15[1022], r15

positive: st.hlt instruction

	st.hlt	r0[0], r0
	st.hlt	r15[1022], r15

positive: st.hmi instruction

	st.hmi	r0[0], r0
	st.hmi	r15[1022], r15

positive: st.hpl instruction

	st.hpl	r0[0], r0
	st.hpl	r15[1022], r15

positive: st.hls instruction

	st.hls	r0[0], r0
	st.hls	r15[1022], r15

positive: st.hgt instruction

	st.hgt	r0[0], r0
	st.hgt	r15[1022], r15

positive: st.hle instruction

	st.hle	r0[0], r0
	st.hle	r15[1022], r15

positive: st.hhi instruction

	st.hhi	r0[0], r0
	st.hhi	r15[1022], r15

positive: st.hvs instruction

	st.hvs	r0[0], r0
	st.hvs	r15[1022], r15

positive: st.hvc instruction

	st.hvc	r0[0], r0
	st.hvc	r15[1022], r15

positive: st.hqs instruction

	st.hqs	r0[0], r0
	st.hqs	r15[1022], r15

positive: st.hal instruction

	st.hal	r0[0], r0
	st.hal	r15[1022], r15

positive: st.w instruction

	st.w	r0++, r0
	st.w	r15++, r15
	st.w	--r0, r0
	st.w	--r15, r15
	st.w	r0[0], r0
	st.w	r15[60], r15
	st.w	r0[-32768], r0
	st.w	r15[32767], r15
	st.w	r0[r0 << 0], r0
	st.w	r15[r15 << 3], r15

positive: st.weq instruction

	st.weq	r0[0], r0
	st.weq	r15[2044], r15

positive: st.wne instruction

	st.wne	r0[0], r0
	st.wne	r15[2044], r15

positive: st.wcc instruction

	st.wcc	r0[0], r0
	st.wcc	r15[2044], r15

positive: st.whs instruction

	st.whs	r0[0], r0
	st.whs	r15[2044], r15

positive: st.wcs instruction

	st.wcs	r0[0], r0
	st.wcs	r15[2044], r15

positive: st.wlo instruction

	st.wlo	r0[0], r0
	st.wlo	r15[2044], r15

positive: st.wge instruction

	st.wge	r0[0], r0
	st.wge	r15[2044], r15

positive: st.wlt instruction

	st.wlt	r0[0], r0
	st.wlt	r15[2044], r15

positive: st.wmi instruction

	st.wmi	r0[0], r0
	st.wmi	r15[2044], r15

positive: st.wpl instruction

	st.wpl	r0[0], r0
	st.wpl	r15[2044], r15

positive: st.wls instruction

	st.wls	r0[0], r0
	st.wls	r15[2044], r15

positive: st.wgt instruction

	st.wgt	r0[0], r0
	st.wgt	r15[2044], r15

positive: st.wle instruction

	st.wle	r0[0], r0
	st.wle	r15[2044], r15

positive: st.whi instruction

	st.whi	r0[0], r0
	st.whi	r15[2044], r15

positive: st.wvs instruction

	st.wvs	r0[0], r0
	st.wvs	r15[2044], r15

positive: st.wvc instruction

	st.wvc	r0[0], r0
	st.wvc	r15[2044], r15

positive: st.wqs instruction

	st.wqs	r0[0], r0
	st.wqs	r15[2044], r15

positive: st.wal instruction

	st.wal	r0[0], r0
	st.wal	r15[2044], r15

positive: stc.d instruction

	stc.d	cp0, r0[0], cr0
	stc.d	cp7, r15[1020], cr14
	stc.d	cp0, --r0, cr0
	stc.d	cp7, --r15, cr14
	stc.d	cp0, r0[r0 << 0], cr0
	stc.d	cp7, r15[r15 << 3], cr14

positive: stc.w instruction

	stc.w	cp0, r0[0], cr0
	stc.w	cp7, r15[1020], cr15
	stc.w	cp0, --r0, cr0
	stc.w	cp7, --r15, cr15
	stc.w	cp0, r0[r0 << 0], cr0
	stc.w	cp7, r15[r15 << 3], cr15

positive: stc0.d instruction

	stc0.d	r0[0], cr0
	stc0.d	r15[16380], cr14

positive: stc0.w instruction

	stc0.w	r0[0], cr0
	stc0.w	r15[16380], cr15

positive: stcond instruction

	stcond	r0[-32768], r0
	stcond	r15[32767], r15

positive: stdsp instruction

	stdsp	sp[0], r0
	stdsp	sp[508], r15

positive: sthh.w instruction

	sthh.w	r0[0], r0:b, r0:b
	sthh.w	r15[1020], r15:t, r15:t
	sthh.w	r0[r0 << 0], r0:b, r0:b
	sthh.w	r15[r15 << 3], r15:t, r15:t

positive: stswp.h instruction

	stswp.h	r0[-4096], r0
	stswp.h	r15[4094], r15

positive: stswp.w instruction

	stswp.w	r0[-8192], r0
	stswp.w	r15[8188], r15

positive: sub instruction

	sub	r0, r0
	sub	r15, r15
	sub	r0, r0, r0 << 0
	sub	r15, r15, r15 << 3
	sub	r0, -128
	sub	r15, 127
	sub	sp, -512
	sub	sp, 508
	sub	r0, -1048576
	sub	r15, 1048575
	sub	r0, r0, -32768
	sub	r15, r15, 32767

positive: subeq instruction

	subeq	r0, -128
	subeq	r15, 127
	subeq	r0, r0, r0
	subeq	r15, r15, r15

positive: subne instruction

	subne	r0, -128
	subne	r15, 127
	subne	r0, r0, r0
	subne	r15, r15, r15

positive: subcc instruction

	subcc	r0, -128
	subcc	r15, 127
	subcc	r0, r0, r0
	subcc	r15, r15, r15

positive: subhs instruction

	subhs	r0, -128
	subhs	r15, 127
	subhs	r0, r0, r0
	subhs	r15, r15, r15

positive: subcs instruction

	subcs	r0, -128
	subcs	r15, 127
	subcs	r0, r0, r0
	subcs	r15, r15, r15

positive: sublo instruction

	sublo	r0, -128
	sublo	r15, 127
	sublo	r0, r0, r0
	sublo	r15, r15, r15

positive: subge instruction

	subge	r0, -128
	subge	r15, 127
	subge	r0, r0, r0
	subge	r15, r15, r15

positive: sublt instruction

	sublt	r0, -128
	sublt	r15, 127
	sublt	r0, r0, r0
	sublt	r15, r15, r15

positive: submi instruction

	submi	r0, -128
	submi	r15, 127
	submi	r0, r0, r0
	submi	r15, r15, r15

positive: subpl instruction

	subpl	r0, -128
	subpl	r15, 127
	subpl	r0, r0, r0
	subpl	r15, r15, r15

positive: subls instruction

	subls	r0, -128
	subls	r15, 127
	subls	r0, r0, r0
	subls	r15, r15, r15

positive: subgt instruction

	subgt	r0, -128
	subgt	r15, 127
	subgt	r0, r0, r0
	subgt	r15, r15, r15

positive: suble instruction

	suble	r0, -128
	suble	r15, 127
	suble	r0, r0, r0
	suble	r15, r15, r15

positive: subhi instruction

	subhi	r0, -128
	subhi	r15, 127
	subhi	r0, r0, r0
	subhi	r15, r15, r15

positive: subvs instruction

	subvs	r0, -128
	subvs	r15, 127
	subvs	r0, r0, r0
	subvs	r15, r15, r15

positive: subvc instruction

	subvc	r0, -128
	subvc	r15, 127
	subvc	r0, r0, r0
	subvc	r15, r15, r15

positive: subqs instruction

	subqs	r0, -128
	subqs	r15, 127
	subqs	r0, r0, r0
	subqs	r15, r15, r15

positive: subal instruction

	subal	r0, -128
	subal	r15, 127
	subal	r0, r0, r0
	subal	r15, r15, r15

positive: subfeq instruction

	subfeq	r0, -128
	subfeq	r15, 127

positive: subfne instruction

	subfne	r0, -128
	subfne	r15, 127

positive: subfcc instruction

	subfcc	r0, -128
	subfcc	r15, 127

positive: subfhs instruction

	subfhs	r0, -128
	subfhs	r15, 127

positive: subfcs instruction

	subfcs	r0, -128
	subfcs	r15, 127

positive: subflo instruction

	subflo	r0, -128
	subflo	r15, 127

positive: subfge instruction

	subfge	r0, -128
	subfge	r15, 127

positive: subflt instruction

	subflt	r0, -128
	subflt	r15, 127

positive: subfmi instruction

	subfmi	r0, -128
	subfmi	r15, 127

positive: subfpl instruction

	subfpl	r0, -128
	subfpl	r15, 127

positive: subfls instruction

	subfls	r0, -128
	subfls	r15, 127

positive: subfgt instruction

	subfgt	r0, -128
	subfgt	r15, 127

positive: subfle instruction

	subfle	r0, -128
	subfle	r15, 127

positive: subfhi instruction

	subfhi	r0, -128
	subfhi	r15, 127

positive: subfvs instruction

	subfvs	r0, -128
	subfvs	r15, 127

positive: subfvc instruction

	subfvc	r0, -128
	subfvc	r15, 127

positive: subfqs instruction

	subfqs	r0, -128
	subfqs	r15, 127

positive: subfal instruction

	subfal	r0, -128
	subfal	r15, 127

positive: subhh.w instruction

	subhh.w	r0, r0:b, r0:b
	subhh.w	r15, r15:t, r15:t

positive: swap.b instruction

	swap.b	r0
	swap.b	r15

positive: swap.bh instruction

	swap.bh	r0
	swap.bh	r15

positive: swap.h instruction

	swap.h	r0
	swap.h	r15

positive: sync instruction

	sync	0
	sync	255

positive: tlbr instruction

	tlbr

positive: tlbs instruction

	tlbs

positive: tlbw instruction

	tlbw

positive: tnbz instruction

	tnbz	r0
	tnbz	r15

positive: tst instruction

	tst	r0, r0
	tst	r15, r15

positive: xchg instruction

	xchg	r0, r0, r0
	xchg	r15, r15, r15

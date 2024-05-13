# Xtensa assembler test and validation suite
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

# Xtensa assembler

positive: abs instruction

	abs	a0, a0
	abs	a15, a15

positive: abs.d instruction

	abs.d	f0, f0
	abs.d	f15, f15

positive: abs.s instruction

	abs.s	f0, f0
	abs.s	f15, f15

positive: add instruction

	add	a0, a0, a0
	add	a15, a15, a15

positive: add.n instruction

	add.n	a0, a0, a0
	add.n	a15, a15, a15

positive: add.d instruction

	add.d	f0, f0, f0
	add.d	f15, f15, f15

positive: add.s instruction

	add.s	f0, f0, f0
	add.s	f15, f15, f15

positive: addexp.d instruction

	addexp.d	f0, f0
	addexp.d	f15, f15

positive: addexp.s instruction

	addexp.s	f0, f0
	addexp.s	f15, f15

positive: addexpm.d instruction

	addexpm.d	f0, f0
	addexpm.d	f15, f15

positive: addexpm.s instruction

	addexpm.s	f0, f0
	addexpm.s	f15, f15

positive: addi instruction

	addi	a0, a0, -128
	addi	a15, a15, +127

positive: addi.n instruction

	addi.n	a0, a0, -1
	addi.n	a15, a15, +15

positive: addmi instruction

	addmi	a0, a0, -32768
	addmi	a15, a15, +32512

positive: addx2 instruction

	addx2	a0, a0, a0
	addx2	a15, a15, a15

positive: addx4 instruction

	addx4	a0, a0, a0
	addx4	a15, a15, a15

positive: addx8 instruction

	addx8	a0, a0, a0
	addx8	a15, a15, a15

positive: all4 instruction

	all4	b0, b0
	all4	b15, b15

positive: all8 instruction

	all8	b0, b0
	all8	b15, b15

positive: and instruction

	and	a0, a0, a0
	and	a15, a15, a15

positive: andb instruction

	andb	b0, b0, b0
	andb	b15, b15, b15

positive: andbc instruction

	andbc	b0, b0, b0
	andbc	b15, b15, b15

positive: any4 instruction

	any4	b0, b0
	any4	b15, b15

positive: any8 instruction

	any8	b0, b0
	any8	b15, b15

positive: ball instruction

	ball	b0, b0, -124
	ball	b15, b15, +131

positive: bany instruction

	bany	b0, b0, -124
	bany	b15, b15, +131

positive: bbc instruction

	bbc	a0, a0, -124
	bbc	a15, a15, +131

positive: bbci instruction

	bbci	a0, 0, -124
	bbci	a15, 31, +131

positive: bbci.l instruction

	bbci.l	a0, 0, -124
	bbci.l	a15, 31, +131

positive: bbs instruction

	bbs	a0, a0, -124
	bbs	a15, a15, +131

positive: bbsi instruction

	bbsi	a0, 0, -124
	bbsi	a15, 31, +131

positive: bbsi.l instruction

	bbsi.l	a0, 0, -124
	bbsi.l	a15, 31, +131

positive: beq instruction

	beq	a0, a0, -124
	beq	a15, a15, +131

positive: beqi instruction

	beqi	a0, -1, -124
	beqi	a15, 256, +131

positive: beqz instruction

	beqz	a0, -2044
	beqz	a15, +2051

positive: beqz.n instruction

	beqz.n	a0, 4
	beqz.n	a15, 67

positive: bf instruction

	bf	b0, -124
	bf	b15, +131

positive: bge instruction

	bge	a0, a0, -124
	bge	a15, a15, +131

positive: bgei instruction

	bgei	a0, -1, -124
	bgei	a15, 256, +131

positive: bgeu instruction

	bgeu	a0, a0, -124
	bgeu	a15, a15, +131

positive: bgeui instruction

	bgeui	a0, 2, -124
	bgeui	a15, 65536, +131

positive: bgez instruction

	bgez	a0, -2044
	bgez	a15, +2051

positive: blt instruction

	blt	a0, a0, -124
	blt	a15, a15, +131

positive: blti instruction

	blti	a0, -1, -124
	blti	a15, 256, +131

positive: bltu instruction

	bltu	a0, a0, -124
	bltu	a15, a15, +131

positive: bltui instruction

	bltui	a0, 2, -124
	bltui	a15, 65536, +131

positive: bltz instruction

	bltz	a0, -2044
	bltz	a15, +2051

positive: bnall instruction

	bnall	a0, a0, -124
	bnall	a15, a15, +131

positive: bne instruction

	bne	a0, a0, -124
	bne	a15, a15, +131

positive: bnei instruction

	bnei	a0, -1, -124
	bnei	a15, 256, +131

positive: bnez instruction

	bnez	a0, -2044
	bnez	a15, +2051

positive: bnez.n instruction

	bnez.n	a0, 4
	bnez.n	a15, 67

positive: bnone instruction

	bnone	a0, a0, -124
	bnone	a15, a15, +131

positive: break instruction

	break	0, 0
	break	15, 15

positive: break.n instruction

	break.n	0
	break.n	15

positive: bt instruction

	bt	b0, -124
	bt	b15, +131

positive: call0 instruction

	call0	-524284
	call0	+524288

positive: call4 instruction

	call4	-524284
	call4	+524288

positive: call8 instruction

	call8	-524284
	call8	+524288

positive: call12 instruction

	call12	-524284
	call12	+524288

positive: callx0 instruction

	callx0	a0
	callx0	a15

positive: callx4 instruction

	callx4	a0
	callx4	a15

positive: callx8 instruction

	callx8	a0
	callx8	a15

positive: callx12 instruction

	callx12	a0
	callx12	a15

positive: ceil.d instruction

	ceil.d	a0, f0, 0
	ceil.d	a15, f15, 15

positive: ceil.s instruction

	ceil.s	a0, f0, 0
	ceil.s	a15, f15, 15

positive: clamps instruction

	clamps	a0, a0, 7
	clamps	a15, a15, 22

positive: clrex instruction

	clrex

positive: const.d instruction

	const.d	f0, 0
	const.d	f15, 15

positive: const.s instruction

	const.s	f0, 0
	const.s	f15, 15

positive: const16 instruction

	const16	a0, 0
	const16	a15, 65535

positive: cvtd.s instruction

	cvtd.s	f0, f0
	cvtd.s	f15, f15

positive: cvts.d instruction

	cvts.d	f0, f0
	cvts.d	f15, f15

positive: dci instruction

	dci	a0, 0
	dci	a15, 240

positive: dcwb instruction

	dcwb	a0, 0
	dcwb	a15, 240

positive: dcwbi instruction

	dcwbi	a0, 0
	dcwbi	a15, 240

positive: depbits instruction

	depbits	a0, a15, 0, 1
	depbits	a15, a15, 31, 1
	depbits	a15, a15, 16, 16

positive: dhi instruction

	dhi	a0, 0
	dhi	a15, 1020

positive: dhi.b instruction

	dhi.b	a0, a0
	dhi.b	a15, a15

positive: dhu instruction

	dhu	a0, 0
	dhu	a15, 240

positive: dhwb instruction

	dhwb	a0, 0
	dhwb	a15, 1020

positive: dhwb.b instruction

	dhwb.b	a0, a0
	dhwb.b	a15, a15

positive: dhwbi instruction

	dhwbi	a0, 0
	dhwbi	a15, 1020

positive: dhwbi.b instruction

	dhwbi.b	a0, a0
	dhwbi.b	a15, a15

positive: dii instruction

	dii	a0, 0
	dii	a15, 1020

positive: diu instruction

	diu	a0, 0
	diu	a15, 240

positive: div0.d instruction

	div0.d	f0, f0
	div0.d	f15, f15

positive: div0.s instruction

	div0.s	f0, f0
	div0.s	f15, f15

positive: divn.d instruction

	divn.d	f0, f0, f0
	divn.d	f15, f15, f15

positive: divn.s instruction

	divn.s	f0, f0, f0
	divn.s	f15, f15, f15

positive: diwb instruction

	diwb	a0, 0
	diwb	a15, 240

positive: diwbi instruction

	diwbi	a0, 0
	diwbi	a15, 240

positive: diwbui.p instruction

	diwbui.p	a0
	diwbui.p	a15

positive: dpfl instruction

	dpfl	a0, 0
	dpfl	a15, 240

positive: dpfm.b instruction

	dpfm.b	a0, a0
	dpfm.b	a15, a15

positive: dpfm.bf instruction

	dpfm.bf	a0, a0
	dpfm.bf	a15, a15

positive: dpfr instruction

	dpfr	a0, 0
	dpfr	a15, 1020

positive: dpfr.b instruction

	dpfr.b	a0, a0
	dpfr.b	a15, a15

positive: dpfr.bf instruction

	dpfr.bf	a0, a0
	dpfr.bf	a15, a15

positive: dpfro instruction

	dpfro	a0, 0
	dpfro	a15, 1020

positive: dpfw instruction

	dpfw	a0, 0
	dpfw	a15, 1020

positive: dpfw.b instruction

	dpfw.b	a0, a0
	dpfw.b	a15, a15

positive: dpfw.bf instruction

	dpfw.bf	a0, a0
	dpfw.bf	a15, a15

positive: dpfwo instruction

	dpfwo	a0, 0
	dpfwo	a15, 1020

positive: dsync instruction

	dsync

positive: entry instruction

	entry	a0, 0
	entry	a15, 32760

positive: esync instruction

	esync

positive: excw instruction

	excw

positive: extui instruction

	extui	a0, a15, 0, 1
	extui	a15, a15, 31, 1
	extui	a15, a15, 16, 16

positive: extw instruction

	extw

positive: float.d instruction

	float.d	f0, a0, 0
	float.d	f15, a15, 15

positive: float.s instruction

	float.s	f0, a0, 0
	float.s	f15, a15, 15

positive: floor.d instruction

	floor.d	a0, f0, 0
	floor.d	a15, f15, 15

positive: floor.s instruction

	floor.s	a0, f0, 0
	floor.s	a15, f15, 15

positive: fsync instruction

	fsync

positive: getex instruction

	getex	a0
	getex	a15

positive: idtlb instruction

	idtlb	a0
	idtlb	a15

positive: ihi instruction

	ihi	a0, 0
	ihi	a15, 1020

positive: ihu instruction

	ihu	a0, 0
	ihu	a15, 240

positive: iii instruction

	iii	a0, 0
	iii	a15, 1020

positive: iitlb instruction

	iitlb	a0
	iitlb	a15

positive: iiu instruction

	iiu	a0, 0
	iiu	a15, 240

positive: ill instruction

	ill

positive: ill.n instruction

	ill.n

positive: ipf instruction

	ipf	a0, 0
	ipf	a15, 1020

positive: ipfl instruction

	ipfl	a0, 0
	ipfl	a15, 240

positive: isync instruction

	isync

positive: j instruction

	j	-131068
	j	+131075

positive: j.l instruction

	j.l	-131068
	j.l	+131075

positive: jx instruction

	jx	a0
	jx	a15

positive: l8ui instruction

	l8ui	a0, a0, 0
	l8ui	a15, a15, 255

positive: l16si instruction

	l16si	a0, a0, 0
	l16si	a15, a15, 510

positive: l16ui instruction

	l16ui	a0, a0, 0
	l16ui	a15, a15, 510

positive: l32ai instruction

	l32ai	a0, a0, 0
	l32ai	a15, a15, 1020

positive: l32e instruction

	l32e	a0, a0, -64
	l32e	a15, a15, -4

positive: l32ex instruction

	l32ex	a0, a0
	l32ex	a15, a15

positive: l32i instruction

	l32i	a0, a0, 0
	l32i	a15, a15, 1020

positive: l32i.n instruction

	l32i.n	a0, a0, 0
	l32i.n	a15, a15, 60

positive: l32r instruction

	l32r	a0, -262144
	l32r	a15, -4

positive: ldct instruction

	ldct	a0, a0
	ldct	a15, a15

positive: ldcw instruction

	ldcw	a0, a0
	ldcw	a15, a15

positive: lddec instruction

	lddec	m0, a0
	lddec	m3, a15

positive: lddr32.p instruction

	lddr32.p	a0
	lddr32.p	a15

positive: ldi instruction

	ldi	f0, a0, 0
	ldi	f15, a15, 2040

positive: ldinc instruction

	ldinc	m0, a0
	ldinc	m3, a15

positive: ldip instruction

	ldip	f0, a0, 0
	ldip	f15, a15, 2040

positive: ldx instruction

	ldx	f0, a0, a0
	ldx	f15, a15, a15

positive: ldxp instruction

	ldxp	f0, a0, a0
	ldxp	f15, a15, a15

positive: loop instruction

	loop	a0, 4
	loop	a15, 259

positive: loopgtz instruction

	loopgtz	a0, 4
	loopgtz	a15, 259

positive: loopnez instruction

	loopnez	a0, 4
	loopnez	a15, 259

positive: lsi instruction

	lsi	f0, a0, 0
	lsi	f15, a15, 1020

positive: lsip instruction

	lsip	f0, a0, 0
	lsip	f15, a15, 1020

positive: lsiu instruction

	lsiu	f0, a0, 0
	lsiu	f15, a15, 1020

positive: lsx instruction

	lsx	f0, a0, a0
	lsx	f15, a15, a15

positive: lsxp instruction

	lsxp	f0, a0, a0
	lsxp	f15, a15, a15

positive: lsxu instruction

	lsxu	f0, a0, a0
	lsxu	f15, a15, a15

positive: madd.d instruction

	madd.d	f0, f0, f0
	madd.d	f15, f15, f15

positive: madd.s instruction

	madd.s	f0, f0, f0
	madd.s	f15, f15, f15

positive: maddn.d instruction

	maddn.d	f0, f0, f0
	maddn.d	f15, f15, f15

positive: maddn.s instruction

	maddn.s	f0, f0, f0
	maddn.s	f15, f15, f15

positive: max instruction

	max	a0, a0, a0
	max	a15, a15, a15

positive: maxu instruction

	maxu	a0, a0, a0
	maxu	a15, a15, a15

positive: memw instruction

	memw

positive: min instruction

	min	a0, a0, a0
	min	a15, a15, a15

positive: minu instruction

	minu	a0, a0, a0
	minu	a15, a15, a15

positive: mkdadj.d instruction

	mkdadj.d	f0, f0
	mkdadj.d	f15, f15

positive: mkdadj.s instruction

	mkdadj.s	f0, f0
	mkdadj.s	f15, f15

positive: mksadj.d instruction

	mksadj.d	f0, f0
	mksadj.d	f15, f15

positive: mksadj.s instruction

	mksadj.s	f0, f0
	mksadj.s	f15, f15

positive: mov instruction

	mov	a0, a0
	mov	a15, a15

positive: mov.d instruction

	mov.d	f0, f0
	mov.d	f15, f15

positive: mov.n instruction

	mov.n	a0, a0
	mov.n	a15, a15

positive: mov.s instruction

	mov.s	f0, f0
	mov.s	f15, f15

positive: moveqz instruction

	moveqz	a0, a0, a0
	moveqz	a15, a15, a15

positive: moveqz.d instruction

	moveqz.d	f0, f0, a0
	moveqz.d	f15, f15, a15

positive: moveqz.s instruction

	moveqz.s	f0, f0, a0
	moveqz.s	f15, f15, a15

positive: movf instruction

	movf	a0, a0, b0
	movf	a15, a15, b15

positive: movf.d instruction

	movf.d	f0, f0, b0
	movf.d	f15, f15, b15

positive: movf.s instruction

	movf.s	f0, f0, b0
	movf.s	f15, f15, b15

positive: movgez instruction

	movgez	a0, a0, a0
	movgez	a15, a15, a15

positive: movgez.d instruction

	movgez.d	f0, f0, a0
	movgez.d	f15, f15, a15

positive: movgez.s instruction

	movgez.s	f0, f0, a0
	movgez.s	f15, f15, a15

positive: movi instruction

	movi	a0, -2048
	movi	a15, +2047

positive: movi.n instruction

	movi.n	a0, -32
	movi.n	a15, +95

positive: movltz instruction

	movltz	a0, a0, a0
	movltz	a15, a15, a15

positive: movltz.d instruction

	movltz.d	f0, f0, a0
	movltz.d	f15, f15, a15

positive: movltz.s instruction

	movltz.s	f0, f0, a0
	movltz.s	f15, f15, a15

positive: movnez instruction

	movnez	a0, a0, a0
	movnez	a15, a15, a15

positive: movnez.d instruction

	movnez.d	f0, f0, a0
	movnez.d	f15, f15, a15

positive: movnez.s instruction

	movnez.s	f0, f0, a0
	movnez.s	f15, f15, a15

positive: movsp instruction

	movsp	a0, a0
	movsp	a15, a15

positive: movt instruction

	movt	a0, a0, b0
	movt	a15, a15, b15

positive: movt.d instruction

	movt.d	f0, f0, b0
	movt.d	f15, f15, b15

positive: movt.s instruction

	movt.s	f0, f0, b0
	movt.s	f15, f15, b15

positive: msub.d instruction

	msub.d	f0, f0, f0
	msub.d	f15, f15, f15

positive: msub.s instruction

	msub.s	f0, f0, f0
	msub.s	f15, f15, f15

positive: mul.aa.hh instruction

	mul.aa.hh	a0, a0
	mul.aa.hh	a15, a15

positive: mul.aa.hl instruction

	mul.aa.hl	a0, a0
	mul.aa.hl	a15, a15

positive: mul.aa.lh instruction

	mul.aa.lh	a0, a0
	mul.aa.lh	a15, a15

positive: mul.aa.ll instruction

	mul.aa.ll	a0, a0
	mul.aa.ll	a15, a15

positive: mul.ad.hh instruction

	mul.ad.hh	a0, m2
	mul.ad.hh	a15, m3

positive: mul.ad.hl instruction

	mul.ad.hl	a0, m2
	mul.ad.hl	a15, m3

positive: mul.ad.lh instruction

	mul.ad.lh	a0, m2
	mul.ad.lh	a15, m3

positive: mul.ad.ll instruction

	mul.ad.ll	a0, m2
	mul.ad.ll	a15, m3

positive: mul.da.hh instruction

	mul.da.hh	m0, a0
	mul.da.hh	m1, a15

positive: mul.da.hl instruction

	mul.da.hl	m0, a0
	mul.da.hl	m1, a15

positive: mul.da.lh instruction

	mul.da.lh	m0, a0
	mul.da.lh	m1, a15

positive: mul.da.ll instruction

	mul.da.ll	m0, a0
	mul.da.ll	m1, a15

positive: mul.dd.hh instruction

	mul.dd.hh	m0, m2
	mul.dd.hh	m1, m3

positive: mul.dd.hl instruction

	mul.dd.hl	m0, m2
	mul.dd.hl	m1, m3

positive: mul.dd.lh instruction

	mul.dd.lh	m0, m2
	mul.dd.lh	m1, m3

positive: mul.dd.ll instruction

	mul.dd.ll	m0, m2
	mul.dd.ll	m1, m3

positive: mul.d instruction

	mul.d	f0, f0, f0
	mul.d	f15, f15, f15

positive: mul.s instruction

	mul.s	f0, f0, f0
	mul.s	f15, f15, f15

positive: mul16s instruction

	mul16s	a0, a0, a0
	mul16s	a15, a15, a15

positive: mul16u instruction

	mul16u	a0, a0, a0
	mul16u	a15, a15, a15

positive: mula.aa.hh instruction

	mula.aa.hh	a0, a0
	mula.aa.hh	a15, a15

positive: mula.aa.hl instruction

	mula.aa.hl	a0, a0
	mula.aa.hl	a15, a15

positive: mula.aa.lh instruction

	mula.aa.lh	a0, a0
	mula.aa.lh	a15, a15

positive: mula.aa.ll instruction

	mula.aa.ll	a0, a0
	mula.aa.ll	a15, a15

positive: mula.ad.hh instruction

	mula.ad.hh	a0, m2
	mula.ad.hh	a15, m3

positive: mula.ad.hl instruction

	mula.ad.hl	a0, m2
	mula.ad.hl	a15, m3

positive: mula.ad.lh instruction

	mula.ad.lh	a0, m2
	mula.ad.lh	a15, m3

positive: mula.ad.ll instruction

	mula.ad.ll	a0, m2
	mula.ad.ll	a15, m3

positive: mula.da.hh instruction

	mula.da.hh	m0, a0
	mula.da.hh	m1, a15

positive: mula.da.hl instruction

	mula.da.hl	m0, a0
	mula.da.hl	m1, a15

positive: mula.da.lh instruction

	mula.da.lh	m0, a0
	mula.da.lh	m1, a15

positive: mula.da.ll instruction

	mula.da.ll	m0, a0
	mula.da.ll	m1, a15

positive: mula.da.hh.lddec instruction

	mula.da.hh.lddec	m0, a0, m0, a0
	mula.da.hh.lddec	m3, a15, m1, a15

positive: mula.da.hl.lddec instruction

	mula.da.hl.lddec	m0, a0, m0, a0
	mula.da.hl.lddec	m3, a15, m1, a15

positive: mula.da.lh.lddec instruction

	mula.da.lh.lddec	m0, a0, m0, a0
	mula.da.lh.lddec	m3, a15, m1, a15

positive: mula.da.ll.lddec instruction

	mula.da.ll.lddec	m0, a0, m0, a0
	mula.da.ll.lddec	m3, a15, m1, a15

positive: mula.da.hh.ldinc instruction

	mula.da.hh.ldinc	m0, a0, m0, a0
	mula.da.hh.ldinc	m3, a15, m1, a15

positive: mula.da.hl.ldinc instruction

	mula.da.hl.ldinc	m0, a0, m0, a0
	mula.da.hl.ldinc	m3, a15, m1, a15

positive: mula.da.lh.ldinc instruction

	mula.da.lh.ldinc	m0, a0, m0, a0
	mula.da.lh.ldinc	m3, a15, m1, a15

positive: mula.da.ll.ldinc instruction

	mula.da.ll.ldinc	m0, a0, m0, a0
	mula.da.ll.ldinc	m3, a15, m1, a15

positive: mula.dd.hh instruction

	mula.dd.hh	m0, m2
	mula.dd.hh	m1, m3

positive: mula.dd.hl instruction

	mula.dd.hl	m0, m2
	mula.dd.hl	m1, m3

positive: mula.dd.lh instruction

	mula.dd.lh	m0, m2
	mula.dd.lh	m1, m3

positive: mula.dd.ll instruction

	mula.dd.ll	m0, m2
	mula.dd.ll	m1, m3

positive: mula.dd.hh.lddec instruction

	mula.dd.hh.lddec	m0, a0, m0, m2
	mula.dd.hh.lddec	m3, a15, m1, m3

positive: mula.dd.hl.lddec instruction

	mula.dd.hl.lddec	m0, a0, m0, m2
	mula.dd.hl.lddec	m3, a15, m1, m3

positive: mula.dd.lh.lddec instruction

	mula.dd.lh.lddec	m0, a0, m0, m2
	mula.dd.lh.lddec	m3, a15, m1, m3

positive: mula.dd.ll.lddec instruction

	mula.dd.ll.lddec	m0, a0, m0, m2
	mula.dd.ll.lddec	m3, a15, m1, m3

positive: mula.dd.hh.ldinc instruction

	mula.dd.hh.ldinc	m0, a0, m0, m2
	mula.dd.hh.ldinc	m3, a15, m1, m3

positive: mula.dd.hl.ldinc instruction

	mula.dd.hl.ldinc	m0, a0, m0, m2
	mula.dd.hl.ldinc	m3, a15, m1, m3

positive: mula.dd.lh.ldinc instruction

	mula.dd.lh.ldinc	m0, a0, m0, m2
	mula.dd.lh.ldinc	m3, a15, m1, m3

positive: mula.dd.ll.ldinc instruction

	mula.dd.ll.ldinc	m0, a0, m0, m2
	mula.dd.ll.ldinc	m3, a15, m1, m3

positive: mull instruction

	mull	a0, a0, a0
	mull	a15, a15, a15

positive: muls.aa.hh instruction

	muls.aa.hh	a0, a0
	muls.aa.hh	a15, a15

positive: muls.aa.hl instruction

	muls.aa.hl	a0, a0
	muls.aa.hl	a15, a15

positive: muls.aa.lh instruction

	muls.aa.lh	a0, a0
	muls.aa.lh	a15, a15

positive: muls.aa.ll instruction

	muls.aa.ll	a0, a0
	muls.aa.ll	a15, a15

positive: muls.ad.hh instruction

	muls.ad.hh	a0, m2
	muls.ad.hh	a15, m3

positive: muls.ad.hl instruction

	muls.ad.hl	a0, m2
	muls.ad.hl	a15, m3

positive: muls.ad.lh instruction

	muls.ad.lh	a0, m2
	muls.ad.lh	a15, m3

positive: muls.ad.ll instruction

	muls.ad.ll	a0, m2
	muls.ad.ll	a15, m3

positive: muls.da.hh instruction

	muls.da.hh	m0, a0
	muls.da.hh	m1, a15

positive: muls.da.hl instruction

	muls.da.hl	m0, a0
	muls.da.hl	m1, a15

positive: muls.da.lh instruction

	muls.da.lh	m0, a0
	muls.da.lh	m1, a15

positive: muls.da.ll instruction

	muls.da.ll	m0, a0
	muls.da.ll	m1, a15

positive: muls.dd.hh instruction

	muls.dd.hh	m0, m2
	muls.dd.hh	m1, m3

positive: muls.dd.hl instruction

	muls.dd.hl	m0, m2
	muls.dd.hl	m1, m3

positive: muls.dd.lh instruction

	muls.dd.lh	m0, m2
	muls.dd.lh	m1, m3

positive: muls.dd.ll instruction

	muls.dd.ll	m0, m2
	muls.dd.ll	m1, m3

positive: mulsh instruction

	mulsh	a0, a0, a0
	mulsh	a15, a15, a15

positive: muluh instruction

	muluh	a0, a0, a0
	muluh	a15, a15, a15

positive: neg instruction

	neg	a0, a0
	neg	a15, a15

positive: neg.d instruction

	neg.d	f0, f0
	neg.d	f15, f15

positive: neg.s instruction

	neg.s	f0, f0
	neg.s	f15, f15

positive: nexp01.d instruction

	nexp01.d	f0, f0
	nexp01.d	f15, f15

positive: nexp01.s instruction

	nexp01.s	f0, f0
	nexp01.s	f15, f15

positive: nop instruction

	nop

positive: nop.n instruction

	nop.n

positive: nsa instruction

	nsa	a0, a0
	nsa	a15, a15

positive: nsau instruction

	nsau	a0, a0
	nsau	a15, a15

positive: oeq.d instruction

	oeq.d	b0, f0, f0
	oeq.d	b15, f15, f15

positive: oeq.s instruction

	oeq.s	b0, f0, f0
	oeq.s	b15, f15, f15

positive: ole.d instruction

	ole.d	b0, f0, f0
	ole.d	b15, f15, f15

positive: ole.s instruction

	ole.s	b0, f0, f0
	ole.s	b15, f15, f15

positive: olt.d instruction

	olt.d	b0, f0, f0
	olt.d	b15, f15, f15

positive: olt.s instruction

	olt.s	b0, f0, f0
	olt.s	b15, f15, f15

positive: or instruction

	or	a0, a0, a0
	or	a15, a15, a15

positive: orb instruction

	orb	b0, b0, b0
	orb	b15, b15, b15

positive: orbc instruction

	orbc	b0, b0, b0
	orbc	b15, b15, b15

positive: pdtlb instruction

	pdtlb	a0, a0
	pdtlb	a15, a15

positive: pitlb instruction

	pitlb	a0, a0
	pitlb	a15, a15

positive: pptlb instruction

	pptlb	a0, a0
	pptlb	a15, a15

positive: quos instruction

	quos	a0, a0, a0
	quos	a15, a15, a15

positive: quou instruction

	quou	a0, a0, a0
	quou	a15, a15, a15

positive: rdtlb0 instruction

	rdtlb0	a0, a0
	rdtlb0	a15, a15

positive: rdtlb1 instruction

	rdtlb1	a0, a0
	rdtlb1	a15, a15

positive: recip0.d instruction

	recip0.d	f0, f0
	recip0.d	f15, f15

positive: recip0.s instruction

	recip0.s	f0, f0
	recip0.s	f15, f15

positive: rems instruction

	rems	a0, a0, a0
	rems	a15, a15, a15

positive: remu instruction

	remu	a0, a0, a0
	remu	a15, a15, a15

positive: rer instruction

	rer	a0, a0
	rer	a15, a15

positive: ret instruction

	ret

positive: ret.n instruction

	ret.n

positive: retw instruction

	retw

positive: retw.n instruction

	retw.n

positive: rfdd instruction

	rfdd

positive: rfde instruction

	rfde

positive: rfdo instruction

	rfdo

positive: rfe instruction

	rfe

positive: rfi instruction

	rfi	0
	rfi	15

positive: rfme instruction

	rfme

positive: rfr instruction

	rfr	a0, f0
	rfr	a15, f15

positive: rfrd instruction

	rfrd	a0, f0
	rfrd	a15, f15

positive: rfue instruction

	rfue

positive: rfwo instruction

	rfwo

positive: rfwu instruction

	rfwu

positive: ritlb0 instruction

	ritlb0	a0, a0
	ritlb0	a15, a15

positive: ritlb1 instruction

	ritlb1	a0, a0
	ritlb1	a15, a15

positive: rotw instruction

	rotw	-8
	rotw	+7

positive: round.d instruction

	round.d	a0, f0, 0
	round.d	a15, f15, 0

positive: round.s instruction

	round.s	a0, f0, 0
	round.s	a15, f15, 0

positive: rptlb0 instruction

	rptlb0	a0, a0
	rptlb0	a15, a15

positive: rptlb1 instruction

	rptlb1	a0, a0
	rptlb1	a15, a15

positive: rsil instruction

	rsil	a0, 0
	rsil	a15, 0

positive: rsqrt0.d instruction

	rsqrt0.d	f0, f0
	rsqrt0.d	f15, f15

positive: rsqrt0.s instruction

	rsqrt0.s	f0, f0
	rsqrt0.s	f15, f15

positive: rsr instruction

	rsr	a0, 0
	rsr	a15, 255

positive: rsync instruction

	rsync

positive: rur instruction

	rur	a0, 0
	rur	a15, 255

positive: s8i instruction

	s8i	a0, a0, 0
	s8i	a15, a15, 255

positive: s16i instruction

	s16i	a0, a0, 0
	s16i	a15, a15, 510

positive: s32c1i instruction

	s32c1i	a0, a0, 0
	s32c1i	a15, a15, 1020

positive: s32e instruction

	s32e	a0, a0, -64
	s32e	a15, a15, -4

positive: s32ex instruction

	s32ex	a0, a0
	s32ex	a15, a15

positive: s32i instruction

	s32i	a0, a0, 0
	s32i	a15, a15, 1020

positive: s32i.n instruction

	s32i.n	a0, a0, 0
	s32i.n	a15, a15, 60

positive: s32nb instruction

	s32nb	a0, a0, 0
	s32nb	a15, a15, 60

positive: s32ri instruction

	s32ri	a0, a0, 0
	s32ri	a15, a15, 1020

positive: salt instruction

	salt	a0, a0, a0
	salt	a15, a15, a15

positive: saltu instruction

	saltu	a0, a0, a0
	saltu	a15, a15, a15

positive: sddr32.p instruction

	sddr32.p	a0
	sddr32.p	a15

positive: sdi instruction

	sdi	f0, a0, 0
	sdi	f15, a15, 2040

positive: sdip instruction

	sdip	f0, a0, 0
	sdip	f15, a15, 2040

positive: sdx instruction

	sdx	f0, a0, a0
	sdx	f15, a15, a15

positive: sdxp instruction

	sdxp	f0, a0, a0
	sdxp	f15, a15, a15

positive: sext instruction

	sext	a0, a0, 7
	sext	a15, a15, 22

positive: sict instruction

	sict	a0, a0
	sict	a15, a15

positive: sicw instruction

	sicw	a0, a0
	sicw	a15, a15

positive: simcall instruction

	simcall

positive: sll instruction

	sll	a0, a0
	sll	a15, a15

positive: slli instruction

	slli	a0, a0, 1
	slli	a15, a15, 31

positive: sqrt0.d instruction

	sqrt0.d	f0, f0
	sqrt0.d	f15, f15

positive: sqrt0.s instruction

	sqrt0.s	f0, f0
	sqrt0.s	f15, f15

positive: sra instruction

	sra	a0, a0
	sra	a15, a15

positive: srai instruction

	srai	a0, a0, 0
	srai	a15, a15, 31

positive: src instruction

	src	a0, a0, a0
	src	a15, a15, a15

positive: srl instruction

	srl	a0, a0
	srl	a15, a15

positive: srli instruction

	srli	a0, a0, 0
	srli	a15, a15, 15

positive: ssa8b instruction

	ssa8b	a0
	ssa8b	a15

positive: ssa8l instruction

	ssa8l	a0
	ssa8l	a15

positive: ssai instruction

	ssai	0
	ssai	31

positive: ssi instruction

	ssi	f0, a0, 0
	ssi	f15, a15, 1020

positive: ssip instruction

	ssip	f0, a0, 0
	ssip	f15, a15, 1020

positive: ssiu instruction

	ssiu	f0, a0, 0
	ssiu	f15, a15, 1020

positive: ssl instruction

	ssl	a0
	ssl	a15

positive: ssr instruction

	ssr	a0
	ssr	a15

positive: ssx instruction

	ssx	f0, a0, a0
	ssx	f15, a15, a15

positive: ssxp instruction

	ssxp	f0, a0, a0
	ssxp	f15, a15, a15

positive: ssxu instruction

	ssxu	f0, a0, a0
	ssxu	f15, a15, a15

positive: sub instruction

	sub	a0, a0, a0
	sub	a15, a15, a15

positive: sub.d instruction

	sub.d	f0, f0, f0
	sub.d	f15, f15, f15

positive: sub.s instruction

	sub.s	f0, f0, f0
	sub.s	f15, f15, f15

positive: subx2 instruction

	subx2	a0, a0, a0
	subx2	a15, a15, a15

positive: subx4 instruction

	subx4	a0, a0, a0
	subx4	a15, a15, a15

positive: subx8 instruction

	subx8	a0, a0, a0
	subx8	a15, a15, a15

positive: syscall instruction

	syscall	0
	syscall	15

positive: trunc.d instruction

	trunc.d	a0, f0, 0
	trunc.d	a15, f15, 15

positive: trunc.s instruction

	trunc.s	a0, f0, 0
	trunc.s	a15, f15, 15

positive: ueq.d instruction

	ueq.d	b0, f0, f0
	ueq.d	b15, f15, f15

positive: ueq.s instruction

	ueq.s	b0, f0, f0
	ueq.s	b15, f15, f15

positive: ufloat.d instruction

	ufloat.d	f0, a0, 0
	ufloat.d	f15, a15, 15

positive: ufloat.s instruction

	ufloat.s	f0, a0, 0
	ufloat.s	f15, a15, 15

positive: ule.d instruction

	ule.d	b0, f0, f0
	ule.d	b15, f15, f15

positive: ule.s instruction

	ule.s	b0, f0, f0
	ule.s	b15, f15, f15

positive: ult.d instruction

	ult.d	b0, f0, f0
	ult.d	b15, f15, f15

positive: ult.s instruction

	ult.s	b0, f0, f0
	ult.s	b15, f15, f15

positive: umul.aa.hh instruction

	umul.aa.hh	a0, a0
	umul.aa.hh	a15, a15

positive: umul.aa.hl instruction

	umul.aa.hl	a0, a0
	umul.aa.hl	a15, a15

positive: umul.aa.lh instruction

	umul.aa.lh	a0, a0
	umul.aa.lh	a15, a15

positive: umul.aa.ll instruction

	umul.aa.ll	a0, a0
	umul.aa.ll	a15, a15

positive: un.d instruction

	un.d	b0, f0, f0
	un.d	b15, f15, f15

positive: un.s instruction

	un.s	b0, f0, f0
	un.s	b15, f15, f15

positive: utrunc.d instruction

	utrunc.d	a0, f0, 0
	utrunc.d	a15, f15, 15

positive: utrunc.s instruction

	utrunc.s	a0, f0, 0
	utrunc.s	a15, f15, 15

positive: waiti instruction

	waiti	0
	waiti	15

positive: wdtlb instruction

	wdtlb	a0, a0
	wdtlb	a15, a15

positive: wer instruction

	wer	a0, a0
	wer	a15, a15

positive: wfr instruction

	wfr	f0, a0
	wfr	f15, a15

positive: wfrd instruction

	wfrd	f0, a0, a0
	wfrd	f15, a15, a15

positive: witlb instruction

	witlb	a0, a0
	witlb	a15, a15

positive: wptlb instruction

	wptlb	a0, a0
	wptlb	a15, a15

positive: wsr instruction

	wsr	a0, 0
	wsr	a15, 255

positive: wur instruction

	wur	a0, 0
	wur	a15, 255

positive: xor instruction

	xor	a0, a0, a0
	xor	a15, a15, a15

positive: xorb instruction

	xorb	b0, b0, b0
	xorb	b15, b15, b15

positive: xsr instruction

	xsr	a0, 0
	xsr	a15, 255

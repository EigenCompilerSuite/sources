# MicroBlaze assembler test and validation suite
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

# MicroBlaze assembler

positive: add instruction

	add	r0, r0, r0
	add	r31, r31, r31

positive: addc instruction

	addc	r0, r0, r0
	addc	r31, r31, r31

positive: addk instruction

	addk	r0, r0, r0
	addk	r31, r31, r31

positive: addkc instruction

	addkc	r0, r0, r0
	addkc	r31, r31, r31

positive: addi instruction

	addi	r0, r0, -32768
	addi	r31, r31, +32767

positive: addic instruction

	addic	r0, r0, -32768
	addic	r31, r31, +32767

positive: addik instruction

	addik	r0, r0, -32768
	addik	r31, r31, +32767

positive: addikc instruction

	addikc	r0, r0, -32768
	addikc	r31, r31, +32767

positive: and instruction

	and	r0, r0, r0
	and	r31, r31, r31

positive: andi instruction

	andi	r0, r0, -32768
	andi	r31, r31, +32767

positive: andn instruction

	andn	r0, r0, r0
	andn	r31, r31, r31

positive: andni instruction

	andni	r0, r0, -32768
	andni	r31, r31, +32767

positive: beq instruction

	beq	r0, r0
	beq	r31, r31

positive: beqd instruction

	beqd	r0, r0
	beqd	r31, r31

positive: beqi instruction

	beqi	r0, -32768
	beqi	r31, +32767

positive: beqid instruction

	beqid	r0, -32768
	beqid	r31, +32767

positive: bge instruction

	bge	r0, r0
	bge	r31, r31

positive: bged instruction

	bged	r0, r0
	bged	r31, r31

positive: bgei instruction

	bgei	r0, -32768
	bgei	r31, +32767

positive: bgeid instruction

	bgeid	r0, -32768
	bgeid	r31, +32767

positive: bgt instruction

	bgt	r0, r0
	bgt	r31, r31

positive: bgtd instruction

	bgtd	r0, r0
	bgtd	r31, r31

positive: bgti instruction

	bgti	r0, -32768
	bgti	r31, +32767

positive: bgtid instruction

	bgtid	r0, -32768
	bgtid	r31, +32767

positive: ble instruction

	ble	r0, r0
	ble	r31, r31

positive: bled instruction

	bled	r0, r0
	bled	r31, r31

positive: blei instruction

	blei	r0, -32768
	blei	r31, +32767

positive: bleid instruction

	bleid	r0, -32768
	bleid	r31, +32767

positive: blt instruction

	blt	r0, r0
	blt	r31, r31

positive: bltd instruction

	bltd	r0, r0
	bltd	r31, r31

positive: blti instruction

	blti	r0, -32768
	blti	r31, +32767

positive: bltid instruction

	bltid	r0, -32768
	bltid	r31, +32767

positive: bne instruction

	bne	r0, r0
	bne	r31, r31

positive: bned instruction

	bned	r0, r0
	bned	r31, r31

positive: bnei instruction

	bnei	r0, -32768
	bnei	r31, +32767

positive: bneid instruction

	bneid	r0, -32768
	bneid	r31, +32767

positive: br instruction

	br	r0
	br	r31

positive: bra instruction

	bra	r0
	bra	r31

positive: brd instruction

	brd	r0
	brd	r31

positive: brad instruction

	brad	r0
	brad	r31

positive: brld instruction

	brld	r0, r0
	brld	r31, r31

positive: brald instruction

	brald	r0, r0
	brald	r31, r31

positive: bri instruction

	bri	-32768
	bri	+32767

positive: brai instruction

	brai	-32768
	brai	+32767

positive: brid instruction

	brid	-32768
	brid	+32767

positive: braid instruction

	braid	-32768
	braid	+32767

positive: brlid instruction

	brlid	r0, -32768
	brlid	r31, +32767

positive: bralid instruction

	bralid	r0, -32768
	bralid	r31, +32767

positive: brk instruction

	brk	r0, r0
	brk	r31, r31

positive: brki instruction

	brki	r0, -32768
	brki	r31, +32767

positive: bsrl instruction

	bsrl	r0, r0, r0
	bsrl	r31, r31, r31

positive: bsra instruction

	bsra	r0, r0, r0
	bsra	r31, r31, r31

positive: bsll instruction

	bsll	r0, r0, r0
	bsll	r31, r31, r31

positive: bsrli instruction

	bsrli	r0, r0, 0
	bsrli	r31, r31, 31

positive: bsrai instruction

	bsrai	r0, r0, 0
	bsrai	r31, r31, 31

positive: bslli instruction

	bslli	r0, r0, 0
	bslli	r31, r31, 31

positive: clz instruction

	clz	r0, r0
	clz	r31, r31

positive: cmp instruction

	cmp	r0, r0, r0
	cmp	r31, r31, r31

positive: cmpu instruction

	cmpu	r0, r0, r0
	cmpu	r31, r31, r31

positive: fadd instruction

	fadd	r0, r0, r0
	fadd	r31, r31, r31

positive: frsub instruction

	frsub	r0, r0, r0
	frsub	r31, r31, r31

positive: fmul instruction

	fmul	r0, r0, r0
	fmul	r31, r31, r31

positive: fdiv instruction

	fdiv	r0, r0, r0
	fdiv	r31, r31, r31

positive: fcmp.un instruction

	fcmp.un	r0, r0, r0
	fcmp.un	r31, r31, r31

positive: fcmp.lt instruction

	fcmp.lt	r0, r0, r0
	fcmp.lt	r31, r31, r31

positive: fcmp.eq instruction

	fcmp.eq	r0, r0, r0
	fcmp.eq	r31, r31, r31

positive: fcmp.le instruction

	fcmp.le	r0, r0, r0
	fcmp.le	r31, r31, r31

positive: fcmp.gt instruction

	fcmp.gt	r0, r0, r0
	fcmp.gt	r31, r31, r31

positive: fcmp.ne instruction

	fcmp.ne	r0, r0, r0
	fcmp.ne	r31, r31, r31

positive: fcmp.ge instruction

	fcmp.ge	r0, r0, r0
	fcmp.ge	r31, r31, r31

positive: flt instruction

	flt	r0, r0
	flt	r31, r31

positive: fint instruction

	fint	r0, r0
	fint	r31, r31

positive: fsqrt instruction

	fsqrt	r0, r0
	fsqrt	r31, r31

positive: get instruction

	get	r0, rfsl0
	get	r31, rfsl15

positive: tget instruction

	tget	r0, rfsl0
	tget	r31, rfsl15

positive: nget instruction

	nget	r0, rfsl0
	nget	r31, rfsl15

positive: tnget instruction

	tnget	r0, rfsl0
	tnget	r31, rfsl15

positive: eget instruction

	eget	r0, rfsl0
	eget	r31, rfsl15

positive: teget instruction

	teget	r0, rfsl0
	teget	r31, rfsl15

positive: neget instruction

	neget	r0, rfsl0
	neget	r31, rfsl15

positive: tneget instruction

	tneget	r0, rfsl0
	tneget	r31, rfsl15

positive: aget instruction

	aget	r0, rfsl0
	aget	r31, rfsl15

positive: taget instruction

	taget	r0, rfsl0
	taget	r31, rfsl15

positive: naget instruction

	naget	r0, rfsl0
	naget	r31, rfsl15

positive: tnaget instruction

	tnaget	r0, rfsl0
	tnaget	r31, rfsl15

positive: eaget instruction

	eaget	r0, rfsl0
	eaget	r31, rfsl15

positive: teaget instruction

	teaget	r0, rfsl0
	teaget	r31, rfsl15

positive: neaget instruction

	neaget	r0, rfsl0
	neaget	r31, rfsl15

positive: tneaget instruction

	tneaget	r0, rfsl0
	tneaget	r31, rfsl15

positive: cget instruction

	cget	r0, rfsl0
	cget	r31, rfsl15

positive: tcget instruction

	tcget	r0, rfsl0
	tcget	r31, rfsl15

positive: ncget instruction

	ncget	r0, rfsl0
	ncget	r31, rfsl15

positive: tncget instruction

	tncget	r0, rfsl0
	tncget	r31, rfsl15

positive: ecget instruction

	ecget	r0, rfsl0
	ecget	r31, rfsl15

positive: tecget instruction

	tecget	r0, rfsl0
	tecget	r31, rfsl15

positive: necget instruction

	necget	r0, rfsl0
	necget	r31, rfsl15

positive: tnecget instruction

	tnecget	r0, rfsl0
	tnecget	r31, rfsl15

positive: caget instruction

	caget	r0, rfsl0
	caget	r31, rfsl15

positive: tcaget instruction

	tcaget	r0, rfsl0
	tcaget	r31, rfsl15

positive: ncaget instruction

	ncaget	r0, rfsl0
	ncaget	r31, rfsl15

positive: tncaget instruction

	tncaget	r0, rfsl0
	tncaget	r31, rfsl15

positive: ecaget instruction

	ecaget	r0, rfsl0
	ecaget	r31, rfsl15

positive: tecaget instruction

	tecaget	r0, rfsl0
	tecaget	r31, rfsl15

positive: necaget instruction

	necaget	r0, rfsl0
	necaget	r31, rfsl15

positive: tnecaget instruction

	tnecaget	r0, rfsl0
	tnecaget	r31, rfsl15

positive: getd instruction

	getd	r0, r0
	getd	r31, r31

positive: tgetd instruction

	tgetd	r0, r0
	tgetd	r31, r31

positive: ngetd instruction

	ngetd	r0, r0
	ngetd	r31, r31

positive: tngetd instruction

	tngetd	r0, r0
	tngetd	r31, r31

positive: egetd instruction

	egetd	r0, r0
	egetd	r31, r31

positive: tegetd instruction

	tegetd	r0, r0
	tegetd	r31, r31

positive: negetd instruction

	negetd	r0, r0
	negetd	r31, r31

positive: tnegetd instruction

	tnegetd	r0, r0
	tnegetd	r31, r31

positive: agetd instruction

	agetd	r0, r0
	agetd	r31, r31

positive: tagetd instruction

	tagetd	r0, r0
	tagetd	r31, r31

positive: nagetd instruction

	nagetd	r0, r0
	nagetd	r31, r31

positive: tnagetd instruction

	tnagetd	r0, r0
	tnagetd	r31, r31

positive: eagetd instruction

	eagetd	r0, r0
	eagetd	r31, r31

positive: teagetd instruction

	teagetd	r0, r0
	teagetd	r31, r31

positive: neagetd instruction

	neagetd	r0, r0
	neagetd	r31, r31

positive: tneagetd instruction

	tneagetd	r0, r0
	tneagetd	r31, r31

positive: cgetd instruction

	cgetd	r0, r0
	cgetd	r31, r31

positive: tcgetd instruction

	tcgetd	r0, r0
	tcgetd	r31, r31

positive: ncgetd instruction

	ncgetd	r0, r0
	ncgetd	r31, r31

positive: tncgetd instruction

	tncgetd	r0, r0
	tncgetd	r31, r31

positive: ecgetd instruction

	ecgetd	r0, r0
	ecgetd	r31, r31

positive: tecgetd instruction

	tecgetd	r0, r0
	tecgetd	r31, r31

positive: necgetd instruction

	necgetd	r0, r0
	necgetd	r31, r31

positive: tnecgetd instruction

	tnecgetd	r0, r0
	tnecgetd	r31, r31

positive: cagetd instruction

	cagetd	r0, r0
	cagetd	r31, r31

positive: tcagetd instruction

	tcagetd	r0, r0
	tcagetd	r31, r31

positive: ncagetd instruction

	ncagetd	r0, r0
	ncagetd	r31, r31

positive: tncagetd instruction

	tncagetd	r0, r0
	tncagetd	r31, r31

positive: ecagetd instruction

	ecagetd	r0, r0
	ecagetd	r31, r31

positive: tecagetd instruction

	tecagetd	r0, r0
	tecagetd	r31, r31

positive: necagetd instruction

	necagetd	r0, r0
	necagetd	r31, r31

positive: tnecagetd instruction

	tnecagetd	r0, r0
	tnecagetd	r31, r31

positive: idiv instruction

	idiv	r0, r0, r0
	idiv	r31, r31, r31

positive: idivu instruction

	idivu	r0, r0, r0
	idivu	r31, r31, r31

positive: lbu instruction

	lbu	r0, r0, r0
	lbu	r31, r31, r31

positive: lbur instruction

	lbur	r0, r0, r0
	lbur	r31, r31, r31

positive: lbui instruction

	lbui	r0, r0, -32768
	lbui	r31, r31, +32767

positive: lhu instruction

	lhu	r0, r0, r0
	lhu	r31, r31, r31

positive: lhur instruction

	lhur	r0, r0, r0
	lhur	r31, r31, r31

positive: lhui instruction

	lhui	r0, r0, -32768
	lhui	r31, r31, +32767

positive: lw instruction

	lw	r0, r0, r0
	lw	r31, r31, r31

positive: lwr instruction

	lwr	r0, r0, r0
	lwr	r31, r31, r31

positive: lwi instruction

	lwi	r0, r0, -32768
	lwi	r31, r31, +32767

positive: lwx instruction

	lwx	r0, r0, r0
	lwx	r31, r31, r31

positive: mbar instruction

	mbar	0
	mbar	31

positive: mfs instruction

	mfs	r0, rpc
	mfs	r1, rmsr
	mfs	r2, rear
	mfs	r3, resr
	mfs	r4, rfsr
	mfs	r5, rbtr
	mfs	r6, redr
	mfs	r7, rslr
	mfs	r8, rshr
	mfs	r9, rpid
	mfs	r10, rzpr
	mfs	r11, rtlbx
	mfs	r12, rtlblo
	mfs	r13, rtlbhi
	mfs	r14, rpvr0
	mfs	r15, rpvr1
	mfs	r16, rpvr2
	mfs	r17, rpvr3
	mfs	r18, rpvr4
	mfs	r19, rpvr5
	mfs	r20, rpvr6
	mfs	r21, rpvr7
	mfs	r22, rpvr8
	mfs	r23, rpvr9
	mfs	r24, rpvr10
	mfs	r25, rpvr11

positive: msrclr instruction

	msrclr	r0, 0x0000
	msrclr	r31, 0x7fff

positive: msrset instruction

	msrset	r0, 0x0000
	msrset	r31, 0x7fff

positive: mts instruction

	mts	rmsr, r0
	mts	rfsr, r1
	mts	rslr, r2
	mts	rshr, r3
	mts	rpid, r4
	mts	rzpr, r5
	mts	rtlbx, r6
	mts	rtlblo, r7
	mts	rtlbhi, r8

positive: mul instruction

	mul	r0, r0, r0
	mul	r31, r31, r31

positive: mulh instruction

	mulh	r0, r0, r0
	mulh	r31, r31, r31

positive: mulhu instruction

	mulhu	r0, r0, r0
	mulhu	r31, r31, r31

positive: mulhsu instruction

	mulhsu	r0, r0, r0
	mulhsu	r31, r31, r31

positive: muli instruction

	muli	r0, r0, -32768
	muli	r31, r31, +32767

positive: or instruction

	or	r0, r0, r0
	or	r31, r31, r31

positive: ori instruction

	ori	r0, r0, -32768
	ori	r31, r31, +32767

positive: pcmpbf instruction

	pcmpbf	r0, r0, r0
	pcmpbf	r31, r31, r31

positive: pcmpeq instruction

	pcmpeq	r0, r0, r0
	pcmpeq	r31, r31, r31

positive: pcmpne instruction

	pcmpne	r0, r0, r0
	pcmpne	r31, r31, r31

positive: put instruction

	put	r0, rfsl0
	put	r31, rfsl15

positive: nput instruction

	nput	r0, rfsl0
	nput	r31, rfsl15

positive: aput instruction

	aput	r0, rfsl0
	aput	r31, rfsl15

positive: naput instruction

	naput	r0, rfsl0
	naput	r31, rfsl15

positive: tput instruction

	tput	rfsl0
	tput	rfsl15

positive: tnput instruction

	tnput	rfsl0
	tnput	rfsl15

positive: taput instruction

	taput	rfsl0
	taput	rfsl15

positive: tnaput instruction

	tnaput	rfsl0
	tnaput	rfsl15

positive: cput instruction

	cput	r0, rfsl0
	cput	r31, rfsl15

positive: ncput instruction

	ncput	r0, rfsl0
	ncput	r31, rfsl15

positive: caput instruction

	caput	r0, rfsl0
	caput	r31, rfsl15

positive: ncaput instruction

	ncaput	r0, rfsl0
	ncaput	r31, rfsl15

positive: tcput instruction

	tcput	rfsl0
	tcput	rfsl15

positive: tncput instruction

	tncput	rfsl0
	tncput	rfsl15

positive: tcaput instruction

	tcaput	rfsl0
	tcaput	rfsl15

positive: tncaput instruction

	tncaput	rfsl0
	tncaput	rfsl15

positive: putd instruction

	putd	r0, r0
	putd	r31, r31

positive: nputd instruction

	nputd	r0, r0
	nputd	r31, r31

positive: aputd instruction

	aputd	r0, r0
	aputd	r31, r31

positive: naputd instruction

	naputd	r0, r0
	naputd	r31, r31

positive: tputd instruction

	tputd	r0
	tputd	r15

positive: tnputd instruction

	tnputd	r0
	tnputd	r15

positive: taputd instruction

	taputd	r0
	taputd	r15

positive: tnaputd instruction

	tnaputd	r0
	tnaputd	r15

positive: cputd instruction

	cputd	r0, r0
	cputd	r31, r31

positive: ncputd instruction

	ncputd	r0, r0
	ncputd	r31, r31

positive: caputd instruction

	caputd	r0, r0
	caputd	r31, r31

positive: ncaputd instruction

	ncaputd	r0, r0
	ncaputd	r31, r31

positive: tcputd instruction

	tcputd	r0
	tcputd	r15

positive: tncputd instruction

	tncputd	r0
	tncputd	r15

positive: tcaputd instruction

	tcaputd	r0
	tcaputd	r15

positive: tncaputd instruction

	tncaputd	r0
	tncaputd	r15

positive: rsub instruction

	rsub	r0, r0, r0
	rsub	r31, r31, r31

positive: rsubc instruction

	rsubc	r0, r0, r0
	rsubc	r31, r31, r31

positive: rsubk instruction

	rsubk	r0, r0, r0
	rsubk	r31, r31, r31

positive: rsubkc instruction

	rsubkc	r0, r0, r0
	rsubkc	r31, r31, r31

positive: rsubi instruction

	rsubi	r0, r0, -32768
	rsubi	r31, r31, +32767

positive: rsubic instruction

	rsubic	r0, r0, -32768
	rsubic	r31, r31, +32767

positive: rsubik instruction

	rsubik	r0, r0, -32768
	rsubik	r31, r31, +32767

positive: rsubikc instruction

	rsubikc	r0, r0, -32768
	rsubikc	r31, r31, +32767

positive: rtbd instruction

	rtbd	r0, -32768
	rtbd	r31, +32767

positive: rtid instruction

	rtid	r0, -32768
	rtid	r31, +32767

positive: rted instruction

	rted	r0, -32768
	rted	r31, +32767

positive: rtsd instruction

	rtsd	r0, -32768
	rtsd	r31, +32767

positive: sb instruction

	sb	r0, r0, r0
	sb	r31, r31, r31

positive: sbr instruction

	sbr	r0, r0, r0
	sbr	r31, r31, r31

positive: sbi instruction

	sbi	r0, r0, -32768
	sbi	r31, r31, +32767

positive: sext8 instruction

	sext8	r0, r0
	sext8	r31, r31

positive: sext16 instruction

	sext16	r0, r0
	sext16	r31, r31

positive: sh instruction

	sh	r0, r0, r0
	sh	r31, r31, r31

positive: shr instruction

	shr	r0, r0, r0
	shr	r31, r31, r31

positive: shi instruction

	shi	r0, r0, -32768
	shi	r31, r31, +32767

positive: sra instruction

	sra	r0, r0
	sra	r31, r31

positive: src instruction

	src	r0, r0
	src	r31, r31

positive: srl instruction

	srl	r0, r0
	srl	r31, r31

positive: sw instruction

	sw	r0, r0, r0
	sw	r31, r31, r31

positive: swr instruction

	swr	r0, r0, r0
	swr	r31, r31, r31

positive: swapb instruction

	swapb	r0, r0
	swapb	r31, r31

positive: swaph instruction

	swaph	r0, r0
	swaph	r31, r31

positive: swi instruction

	swi	r0, r0, -32768
	swi	r31, r31, +32767

positive: swx instruction

	swx	r0, r0, r0
	swx	r31, r31, r31

positive: wdc instruction

	wdc	r0, r0
	wdc	r31, r31

positive: wdc.flush instruction

	wdc.flush	r0, r0
	wdc.flush	r31, r31

positive: wdc.clear instruction

	wdc.clear	r0, r0
	wdc.clear	r31, r31

positive: wic instruction

	wic	r0, r0
	wic	r31, r31

positive: xor instruction

	xor	r0, r0, r0
	xor	r31, r31, r31

positive: xori instruction

	xori	r0, r0, -32768
	xori	r31, r31, +32767

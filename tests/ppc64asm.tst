# PowerPC assembler test and validation suite
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

	32

negative: bit mode directive missing mode

	.bitmode

negative: bit mode directive with mode in comment

	.bitmode	; 32

negative: bit mode directive with mode on new line

	.bitmode
	32

negative: labeled bit mode directive

	label:	.bitmode	0

negative: negative bit mode

	.bitmode	-32

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

# PowerPC assembler

# unsupported instructions in 32-bit mode

negative: cmpd instruction in 32-bit mode

	.bitmode	32
	cmpd	0, r0, r0

positive: cmpd instruction in 64-bit mode

	.bitmode	64
	cmpd	0, r0, r0

negative: cmpdi instruction in 32-bit mode

	.bitmode	32
	cmpdi	0, r0, 0

positive: cmpdi instruction in 64-bit mode

	.bitmode	64
	cmpdi	0, r0, 0

negative: cmpld instruction in 32-bit mode

	.bitmode	32
	cmpld	0, r0, r0

positive: cmpld instruction in 64-bit mode

	.bitmode	64
	cmpld	0, r0, r0

negative: cmpldi instruction in 32-bit mode

	.bitmode	32
	cmpldi	0, r0, 0

positive: cmpldi instruction in 64-bit mode

	.bitmode	64
	cmpldi	0, r0, 0

negative: cntlzd instruction in 32-bit mode

	.bitmode	32
	cntlzd	r0, r0

positive: cntlzd instruction in 64-bit mode

	.bitmode	64
	cntlzd	r0, r0

negative: cntlzd. instruction in 32-bit mode

	.bitmode	32
	cntlzd.	r0, r0

positive: cntlzd. instruction in 64-bit mode

	.bitmode	64
	cntlzd.	r0, r0

negative: extsw instruction in 32-bit mode

	.bitmode	32
	extsw	r0, r0

positive: extsw instruction in 64-bit mode

	.bitmode	64
	extsw	r0, r0

negative: extsw. instruction in 32-bit mode

	.bitmode	32
	extsw.	r0, r0

positive: extsw. instruction in 64-bit mode

	.bitmode	64
	extsw.	r0, r0

negative: fcfid instruction in 32-bit mode

	.bitmode	32
	fcfid	fr0, fr0

positive: fcfid instruction in 64-bit mode

	.bitmode	64
	fcfid	fr0, fr0

negative: fcfid. instruction in 32-bit mode

	.bitmode	32
	fcfid.	fr0, fr0

positive: fcfid. instruction in 64-bit mode

	.bitmode	64
	fcfid.	fr0, fr0

negative: fctid instruction in 32-bit mode

	.bitmode	32
	fctid	fr0, fr0

positive: fctid instruction in 64-bit mode

	.bitmode	64
	fctid	fr0, fr0

negative: fctid. instruction in 32-bit mode

	.bitmode	32
	fctid.	fr0, fr0

positive: fctid. instruction in 64-bit mode

	.bitmode	64
	fctid.	fr0, fr0

negative: fctidz instruction in 32-bit mode

	.bitmode	32
	fctidz	fr0, fr0

positive: fctidz instruction in 64-bit mode

	.bitmode	64
	fctidz	fr0, fr0

negative: fctidz. instruction in 32-bit mode

	.bitmode	32
	fctidz.	fr0, fr0

positive: fctidz. instruction in 64-bit mode

	.bitmode	64
	fctidz.	fr0, fr0

negative: ld instruction in 32-bit mode

	.bitmode	32
	ld	r0, 0 (r0)

positive: ld instruction in 64-bit mode

	.bitmode	64
	ld	r0, 0 (r0)

negative: ldarx instruction in 32-bit mode

	.bitmode	32
	ldarx	r0, r0, r0

positive: ldarx instruction in 64-bit mode

	.bitmode	64
	ldarx	r0, r0, r0

negative: ldu instruction in 32-bit mode

	.bitmode	32
	ldu	r0, 0 (r0)

positive: ldu instruction in 64-bit mode

	.bitmode	64
	ldu	r0, 0 (r0)

negative: ldux instruction in 32-bit mode

	.bitmode	32
	ldux	r0, r0, r0

positive: ldux instruction in 64-bit mode

	.bitmode	64
	ldux	r0, r0, r0

negative: ldx instruction in 32-bit mode

	.bitmode	32
	ldx	r0, r0, r0

positive: ldx instruction in 64-bit mode

	.bitmode	64
	ldx	r0, r0, r0

negative: lwa instruction in 32-bit mode

	.bitmode	32
	lwa	r0, 0 (r0)

positive: lwa instruction in 64-bit mode

	.bitmode	64
	lwa	r0, 0 (r0)

negative: lwaux instruction in 32-bit mode

	.bitmode	32
	lwaux	r0, r0, r0

positive: lwaux instruction in 64-bit mode

	.bitmode	64
	lwaux	r0, r0, r0

negative: lwax instruction in 32-bit mode

	.bitmode	32
	lwax	r0, r0, r0

positive: lwax instruction in 64-bit mode

	.bitmode	64
	lwax	r0, r0, r0

negative: mtmsrd instruction in 32-bit mode

	.bitmode	32
	mtmsrd	r0, 0

positive: mtmsrd instruction in 64-bit mode

	.bitmode	64
	mtmsrd	r0, 0

negative: mtsrd instruction in 32-bit mode

	.bitmode	32
	mtsrd	0, r0

positive: mtsrd instruction in 64-bit mode

	.bitmode	64
	mtsrd	0, r0

negative: mtsrdin instruction in 32-bit mode

	.bitmode	32
	mtsrdin	r0, r0

positive: mtsrdin instruction in 64-bit mode

	.bitmode	64
	mtsrdin	r0, r0

negative: mulhd instruction in 32-bit mode

	.bitmode	32
	mulhd	r0, r0, r0

positive: mulhd instruction in 64-bit mode

	.bitmode	64
	mulhd	r0, r0, r0

negative: mulhd. instruction in 32-bit mode

	.bitmode	32
	mulhd.	r0, r0, r0

positive: mulhd. instruction in 64-bit mode

	.bitmode	64
	mulhd.	r0, r0, r0

negative: mulhdu instruction in 32-bit mode

	.bitmode	32
	mulhdu	r0, r0, r0

positive: mulhdu instruction in 64-bit mode

	.bitmode	64
	mulhdu	r0, r0, r0

negative: mulhdu. instruction in 32-bit mode

	.bitmode	32
	mulhdu.	r0, r0, r0

positive: mulhdu. instruction in 64-bit mode

	.bitmode	64
	mulhdu.	r0, r0, r0

negative: mulld instruction in 32-bit mode

	.bitmode	32
	mulld	r0, r0, r0

positive: mulld instruction in 64-bit mode

	.bitmode	64
	mulld	r0, r0, r0

negative: mulld. instruction in 32-bit mode

	.bitmode	32
	mulld.	r0, r0, r0

positive: mulld. instruction in 64-bit mode

	.bitmode	64
	mulld.	r0, r0, r0

negative: mulldo instruction in 32-bit mode

	.bitmode	32
	mulldo	r0, r0, r0

positive: mulldo instruction in 64-bit mode

	.bitmode	64
	mulldo	r0, r0, r0

negative: mulldo. instruction in 32-bit mode

	.bitmode	32
	mulldo.	r0, r0, r0

positive: mulldo. instruction in 64-bit mode

	.bitmode	64
	mulldo.	r0, r0, r0

negative: rfid instruction in 32-bit mode

	.bitmode	32
	rfid

positive: rfid instruction in 64-bit mode

	.bitmode	64
	rfid

negative: rldcl instruction in 32-bit mode

	.bitmode	32
	rldcl	r0, r0, r0, 0

positive: rldcl instruction in 64-bit mode

	.bitmode	64
	rldcl	r0, r0, r0, 0

negative: rldcl. instruction in 32-bit mode

	.bitmode	32
	rldcl.	r0, r0, r0, 0

positive: rldcl. instruction in 64-bit mode

	.bitmode	64
	rldcl.	r0, r0, r0, 0

negative: rldcr instruction in 32-bit mode

	.bitmode	32
	rldcr	r0, r0, r0, 0

positive: rldcr instruction in 64-bit mode

	.bitmode	64
	rldcr	r0, r0, r0, 0

negative: rldcr. instruction in 32-bit mode

	.bitmode	32
	rldcr.	r0, r0, r0, 0

positive: rldcr. instruction in 64-bit mode

	.bitmode	64
	rldcr.	r0, r0, r0, 0

negative: rldic instruction in 32-bit mode

	.bitmode	32
	rldic	r0, r0, 0, 0

positive: rldic instruction in 64-bit mode

	.bitmode	64
	rldic	r0, r0, 0, 0

negative: rldic. instruction in 32-bit mode

	.bitmode	32
	rldic.	r0, r0, 0, 0

positive: rldic. instruction in 64-bit mode

	.bitmode	64
	rldic.	r0, r0, 0, 0

negative: rldicl instruction in 32-bit mode

	.bitmode	32
	rldicl	r0, r0, 0, 0

positive: rldicl instruction in 64-bit mode

	.bitmode	64
	rldicl	r0, r0, 0, 0

negative: rldicl. instruction in 32-bit mode

	.bitmode	32
	rldicl.	r0, r0, 0, 0

positive: rldicl. instruction in 64-bit mode

	.bitmode	64
	rldicl.	r0, r0, 0, 0

negative: rldicr instruction in 32-bit mode

	.bitmode	32
	rldicr	r0, r0, 0, 0

positive: rldicr instruction in 64-bit mode

	.bitmode	64
	rldicr	r0, r0, 0, 0

negative: rldicr. instruction in 32-bit mode

	.bitmode	32
	rldicr.	r0, r0, 0, 0

positive: rldicr. instruction in 64-bit mode

	.bitmode	64
	rldicr.	r0, r0, 0, 0

negative: rldimi instruction in 32-bit mode

	.bitmode	32
	rldimi	r0, r0, 0, 0

positive: rldimi instruction in 64-bit mode

	.bitmode	64
	rldimi	r0, r0, 0, 0

negative: rldimi. instruction in 32-bit mode

	.bitmode	32
	rldimi.	r0, r0, 0, 0

positive: rldimi. instruction in 64-bit mode

	.bitmode	64
	rldimi.	r0, r0, 0, 0

negative: slbia instruction in 32-bit mode

	.bitmode	32
	slbia

positive: slbia instruction in 64-bit mode

	.bitmode	64
	slbia

negative: slbie instruction in 32-bit mode

	.bitmode	32
	slbie	r0

positive: slbie instruction in 64-bit mode

	.bitmode	64
	slbie	r0

negative: slbmfee instruction in 32-bit mode

	.bitmode	32
	slbmfee	r0, r0

positive: slbmfee instruction in 64-bit mode

	.bitmode	64
	slbmfee	r0, r0

negative: slbmfev instruction in 32-bit mode

	.bitmode	32
	slbmfev	r0, r0

positive: slbmfev instruction in 64-bit mode

	.bitmode	64
	slbmfev	r0, r0

negative: slbmte instruction in 32-bit mode

	.bitmode	32
	slbmte	r0, r0

positive: slbmte instruction in 64-bit mode

	.bitmode	64
	slbmte	r0, r0

negative: sld instruction in 32-bit mode

	.bitmode	32
	sld	r0, r0, r0

positive: sld instruction in 64-bit mode

	.bitmode	64
	sld	r0, r0, r0

negative: sld. instruction in 32-bit mode

	.bitmode	32
	sld.	r0, r0, r0

positive: sld. instruction in 64-bit mode

	.bitmode	64
	sld.	r0, r0, r0

negative: srad instruction in 32-bit mode

	.bitmode	32
	srad	r0, r0, r0

positive: srad instruction in 64-bit mode

	.bitmode	64
	srad	r0, r0, r0

negative: srad. instruction in 32-bit mode

	.bitmode	32
	srad.	r0, r0, r0

positive: srad. instruction in 64-bit mode

	.bitmode	64
	srad.	r0, r0, r0

negative: sradi instruction in 32-bit mode

	.bitmode	32
	sradi	r0, r0, 0

positive: sradi instruction in 64-bit mode

	.bitmode	64
	sradi	r0, r0, 0

negative: sradi. instruction in 32-bit mode

	.bitmode	32
	sradi.	r0, r0, 0

positive: sradi. instruction in 64-bit mode

	.bitmode	64
	sradi.	r0, r0, 0

negative: srd instruction in 32-bit mode

	.bitmode	32
	srd	r0, r0, r0

positive: srd instruction in 64-bit mode

	.bitmode	64
	srd	r0, r0, r0

negative: srd. instruction in 32-bit mode

	.bitmode	32
	srd.	r0, r0, r0

positive: srd. instruction in 64-bit mode

	.bitmode	64
	srd.	r0, r0, r0

negative: std instruction in 32-bit mode

	.bitmode	32
	std	r0, 0 (r0)

positive: std instruction in 64-bit mode

	.bitmode	64
	std	r0, 0 (r0)

negative: stdcx. instruction in 32-bit mode

	.bitmode	32
	stdcx.	r0, r0, r0

positive: stdcx. instruction in 64-bit mode

	.bitmode	64
	stdcx.	r0, r0, r0

negative: stdu instruction in 32-bit mode

	.bitmode	32
	stdu	r0, 0 (r0)

positive: stdu instruction in 64-bit mode

	.bitmode	64
	stdu	r0, 0 (r0)

negative: stdux instruction in 32-bit mode

	.bitmode	32
	stdux	r0, r0, r0

positive: stdux instruction in 64-bit mode

	.bitmode	64
	stdux	r0, r0, r0

negative: stdx instruction in 32-bit mode

	.bitmode	32
	stdx	r0, r0, r0

positive: stdx instruction in 64-bit mode

	.bitmode	64
	stdx	r0, r0, r0

negative: td instruction in 32-bit mode

	.bitmode	32
	td	0, r0, r0

positive: td instruction in 64-bit mode

	.bitmode	64
	td	0, r0, r0

negative: tdi instruction in 32-bit mode

	.bitmode	32
	tdi	0, r0, 0

positive: tdi instruction in 64-bit mode

	.bitmode	64
	tdi	0, r0, 0

# unsupported instructions in 64-bit mode

positive: dcbi instruction in 32-bit mode

	.bitmode	32
	dcbi	r0, r0

negative: dcbi instruction in 64-bit mode

	.bitmode	64
	dcbi	r0, r0

positive: mfsr instruction in 32-bit mode

	.bitmode	32
	mfsr	r0, 0

negative: mfsr instruction in 64-bit mode

	.bitmode	64
	mfsr	r0, 0

positive: mtsr instruction in 32-bit mode

	.bitmode	32
	mtsr	0, r0

negative: mtsr instruction in 64-bit mode

	.bitmode	64
	mtsr	0, r0

positive: mtsrin instruction in 32-bit mode

	.bitmode	32
	mtsrin	r0, r0

negative: mtsrin instruction in 64-bit mode

	.bitmode	64
	mtsrin	r0, r0

positive: rfi instruction in 32-bit mode

	.bitmode	32
	rfi

negative: rfi instruction in 64-bit mode

	.bitmode	64
	rfi

# simplified mnemonics

positive: blt instruction

	blt	-32768
	blt	+32764

positive: ble instruction

	ble	-32768
	ble	+32764

positive: beq instruction

	beq	-32768
	beq	+32764

positive: bge instruction

	bge	-32768
	bge	+32764

positive: bgt instruction

	bgt	-32768
	bgt	+32764

positive: bnl instruction

	bnl	-32768
	bnl	+32764

positive: bne instruction

	bne	-32768
	bne	+32764

positive: bng instruction

	bng	-32768
	bng	+32764

positive: bso instruction

	bso	-32768
	bso	+32764

positive: bns instruction

	bns	-32768
	bns	+32764

positive: bun instruction

	bun	-32768
	bun	+32764

positive: bnu instruction

	bnu	-32768
	bnu	+32764

positive: blta instruction

	blta	-32768
	blta	+32764

positive: blea instruction

	blea	-32768
	blea	+32764

positive: beqa instruction

	beqa	-32768
	beqa	+32764

positive: bgea instruction

	bgea	-32768
	bgea	+32764

positive: bgta instruction

	bgta	-32768
	bgta	+32764

positive: bnla instruction

	bnla	-32768
	bnla	+32764

positive: bnea instruction

	bnea	-32768
	bnea	+32764

positive: bnga instruction

	bnga	-32768
	bnga	+32764

positive: bsoa instruction

	bsoa	-32768
	bsoa	+32764

positive: bnsa instruction

	bnsa	-32768
	bnsa	+32764

positive: buna instruction

	buna	-32768
	buna	+32764

positive: bnua instruction

	bnua	-32768
	bnua	+32764

positive: bltl instruction

	bltl	-32768
	bltl	+32764

positive: blel instruction

	blel	-32768
	blel	+32764

positive: beql instruction

	beql	-32768
	beql	+32764

positive: bgel instruction

	bgel	-32768
	bgel	+32764

positive: bgtl instruction

	bgtl	-32768
	bgtl	+32764

positive: bnll instruction

	bnll	-32768
	bnll	+32764

positive: bnel instruction

	bnel	-32768
	bnel	+32764

positive: bngl instruction

	bngl	-32768
	bngl	+32764

positive: bsol instruction

	bsol	-32768
	bsol	+32764

positive: bnsl instruction

	bnsl	-32768
	bnsl	+32764

positive: bunl instruction

	bunl	-32768
	bunl	+32764

positive: bnul instruction

	bnul	-32768
	bnul	+32764

positive: bltla instruction

	bltla	-32768
	bltla	+32764

positive: blela instruction

	blela	-32768
	blela	+32764

positive: beqla instruction

	beqla	-32768
	beqla	+32764

positive: bgela instruction

	bgela	-32768
	bgela	+32764

positive: bgtla instruction

	bgtla	-32768
	bgtla	+32764

positive: bnlla instruction

	bnlla	-32768
	bnlla	+32764

positive: bnela instruction

	bnela	-32768
	bnela	+32764

positive: bngla instruction

	bngla	-32768
	bngla	+32764

positive: bsola instruction

	bsola	-32768
	bsola	+32764

positive: bnsla instruction

	bnsla	-32768
	bnsla	+32764

positive: bunla instruction

	bunla	-32768
	bunla	+32764

positive: bnula instruction

	bnula	-32768
	bnula	+32764

positive: cmpd instruction

	cmpd	0, r0, r0
	cmpd	7, r31, r31

positive: cmpdi instruction

	cmpdi	0, r0, -32768
	cmpdi	7, r31, +32764

positive: cmpdl instruction

	cmpld	0, r0, r0
	cmpld	7, r31, r31

positive: cmpdli instruction

	cmpldi	0, r0, 0
	cmpldi	7, r31, 65535

positive: cmpw instruction

	cmpw	0, r0, r0
	cmpw	7, r31, r31

positive: cmpwi instruction

	cmpwi	0, r0, -32768
	cmpwi	7, r31, +32764

positive: cmplw instruction

	cmplw	0, r0, r0
	cmplw	7, r31, r31

positive: cmplwi instruction

	cmplwi	0, r0, 0
	cmplwi	7, r31, 65535

positive: li instruction

	li	r0, -32768
	li	r31, +32767

positive: lis instruction

	lis	r0, -32768
	lis	r31, +32767

positive: nop instruction

	nop

# instructions

positive: add instruction

	add	r0, r0, r0
	add	r31, r31, r31

positive: add. instruction

	add.	r0, r0, r0
	add.	r31, r31, r31

positive: addo instruction

	addo	r0, r0, r0
	addo	r31, r31, r31

positive: addo. instruction

	addo.	r0, r0, r0
	addo.	r31, r31, r31

positive: addc instruction

	addc	r0, r0, r0
	addc	r31, r31, r31

positive: addc. instruction

	addc.	r0, r0, r0
	addc.	r31, r31, r31

positive: addco instruction

	addco	r0, r0, r0
	addco	r31, r31, r31

positive: addco. instruction

	addco.	r0, r0, r0
	addco.	r31, r31, r31

positive: adde instruction

	adde	r0, r0, r0
	adde	r31, r31, r31

positive: adde. instruction

	adde.	r0, r0, r0
	adde.	r31, r31, r31

positive: addeo instruction

	addeo	r0, r0, r0
	addeo	r31, r31, r31

positive: addeo. instruction

	addeo.	r0, r0, r0
	addeo.	r31, r31, r31

positive: addi instruction

	addi	r0, r0, -32768
	addi	r31, r31, +32767

positive: addic instruction

	addic	r0, r0, -32768
	addic	r31, r31, +32767

positive: addic. instruction

	addic.	r0, r0, -32768
	addic.	r31, r31, +32767

positive: addis instruction

	addis	r0, r0, -32768
	addis	r31, r31, +32767

positive: addme instruction

	addme	r0, r0
	addme	r31, r31

positive: addme. instruction

	addme.	r0, r0
	addme.	r31, r31

positive: addmeo instruction

	addmeo	r0, r0
	addmeo	r31, r31

positive: addmeo. instruction

	addmeo.	r0, r0
	addmeo.	r31, r31

positive: addze instruction

	addze	r0, r0
	addze	r31, r31

positive: addze. instruction

	addze.	r0, r0
	addze.	r31, r31

positive: addzeo instruction

	addzeo	r0, r0
	addzeo	r31, r31

positive: addzeo. instruction

	addzeo.	r0, r0
	addzeo.	r31, r31

positive: and instruction

	and	r0, r0, r0
	and	r31, r31, r31

positive: and. instruction

	and.	r0, r0, r0
	and.	r31, r31, r31

positive: andc instruction

	andc	r0, r0, r0
	andc	r31, r31, r31

positive: andc. instruction

	andc.	r0, r0, r0
	andc.	r31, r31, r31

positive: andi. instruction

	andi.	r0, r0, 0
	andi.	r31, r31, 65535

positive: andis. instruction

	andis.	r0, r0, 0
	andis.	r31, r31, 65535

positive: b instruction

	b	-33554432
	b	+33554428

positive: ba instruction

	ba	-33554432
	ba	+33554428

positive: bl instruction

	bl	-33554432
	bl	+33554428

positive: bla instruction

	bla	-33554432
	bla	+33554428

positive: bc instruction

	bc	0, 0, -32768
	bc	31, 31, +32764

positive: bca instruction

	bca	0, 0, -32768
	bca	31, 31, +32764

positive: bcl instruction

	bcl	0, 0, -32768
	bcl	31, 31, +32764

positive: bcla instruction

	bcla	0, 0, -32768
	bcla	31, 31, +32764

positive: bcctr instruction

	bcctr	0, 0, 0
	bcctr	31, 31, 3

positive: bcctrl instruction

	bcctrl	0, 0, 0
	bcctrl	31, 31, 3

positive: bclr instruction

	bclr	0, 0, 0
	bclr	31, 31, 3

positive: bclrl instruction

	bclrl	0, 0, 0
	bclrl	31, 31, 3

positive: cmp instruction

	cmp	0, 0, r0, r0
	cmp	7, 1, r31, r31

positive: cmpi instruction

	cmpi	0, 0, r0, -32768
	cmpi	7, 1, r31, +32764

positive: cmpl instruction

	cmpl	0, 0, r0, r0
	cmpl	7, 1, r31, r31

positive: cmpli instruction

	cmpli	0, 0, r0, 0
	cmpli	7, 1, r31, 65535

positive: cntlzd instruction

	cntlzd	r0, r0
	cntlzd	r31, r31

positive: cntlzd. instruction

	cntlzd.	r0, r0
	cntlzd.	r31, r31

positive: cntlzw instruction

	cntlzw	r0, r0
	cntlzw	r31, r31

positive: cntlzw. instruction

	cntlzw.	r0, r0
	cntlzw.	r31, r31

positive: crand instruction

	crand	0, 0, 0
	crand	31, 31, 31

positive: crandc instruction

	crandc	0, 0, 0
	crandc	31, 31, 31

positive: creqv instruction

	creqv	0, 0, 0
	creqv	31, 31, 31

positive: crnand instruction

	crnand	0, 0, 0
	crnand	31, 31, 31

positive: crnor instruction

	crnor	0, 0, 0
	crnor	31, 31, 31

positive: cror instruction

	cror	0, 0, 0
	cror	31, 31, 31

positive: crorc instruction

	crorc	0, 0, 0
	crorc	31, 31, 31

positive: crxor instruction

	crxor	0, 0, 0
	crxor	31, 31, 31

positive: dcbf instruction

	dcbf	r0, r0
	dcbf	r31, r31

positive: dcbi instruction

	.bitmode	32
	dcbi	r0, r0
	dcbi	r31, r31

positive: dcbst instruction

	dcbst	r0, r0
	dcbst	r31, r31

positive: dcbt instruction

	dcbt	r0, r0, 0
	dcbt	r31, r31, 3

positive: dcbtst instruction

	dcbtst	r0, r0
	dcbtst	r31, r31

positive: dcbz instruction

	dcbz	r0, r0
	dcbz	r31, r31

positive: divd instruction

	divd	r0, r0, r0
	divd	r31, r31, r31

positive: divd. instruction

	divd.	r0, r0, r0
	divd.	r31, r31, r31

positive: divdo instruction

	divdo	r0, r0, r0
	divdo	r31, r31, r31

positive: divdo. instruction

	divdo.	r0, r0, r0
	divdo.	r31, r31, r31

positive: divdu instruction

	divdu	r0, r0, r0
	divdu	r31, r31, r31

positive: divdu. instruction

	divdu.	r0, r0, r0
	divdu.	r31, r31, r31

positive: divduo instruction

	divduo	r0, r0, r0
	divduo	r31, r31, r31

positive: divduo. instruction

	divduo.	r0, r0, r0
	divduo.	r31, r31, r31

positive: divw instruction

	divw	r0, r0, r0
	divw	r31, r31, r31

positive: divw. instruction

	divw.	r0, r0, r0
	divw.	r31, r31, r31

positive: divwo instruction

	divwo	r0, r0, r0
	divwo	r31, r31, r31

positive: divwo. instruction

	divwo.	r0, r0, r0
	divwo.	r31, r31, r31

positive: divwu instruction

	divwu	r0, r0, r0
	divwu	r31, r31, r31

positive: divwu. instruction

	divwu.	r0, r0, r0
	divwu.	r31, r31, r31

positive: divwuo instruction

	divwuo	r0, r0, r0
	divwuo	r31, r31, r31

positive: divwuo. instruction

	divwuo.	r0, r0, r0
	divwuo.	r31, r31, r31

positive: eciwx instruction

	eciwx	r0, r0, r0
	eciwx	r31, r31, r31

positive: ecowx instruction

	ecowx	r0, r0, r0
	ecowx	r31, r31, r31

positive: eieio instruction

	eieio

positive: eqv instruction

	eqv	r0, r0, r0
	eqv	r31, r31, r31

positive: eqv. instruction

	eqv.	r0, r0, r0
	eqv.	r31, r31, r31

positive: extsb instruction

	extsb	r0, r0
	extsb	r31, r31

positive: extsb. instruction

	extsb.	r0, r0
	extsb.	r31, r31

positive: extsh instruction

	extsh	r0, r0
	extsh	r31, r31

positive: extsh. instruction

	extsh.	r0, r0
	extsh.	r31, r31

positive: extsw instruction

	extsw	r0, r0
	extsw	r31, r31

positive: extsw. instruction

	extsw.	r0, r0
	extsw.	r31, r31

positive: fabs instruction

	fabs	fr0, fr0
	fabs	fr31, fr31

positive: fabs. instruction

	fabs.	fr0, fr0
	fabs.	fr31, fr31

positive: fadd instruction

	fadd	fr0, fr0, fr0
	fadd	fr31, fr31, fr31

positive: fadd. instruction

	fadd.	fr0, fr0, fr0
	fadd.	fr31, fr31, fr31

positive: fadds instruction

	fadds	fr0, fr0, fr0
	fadds	fr31, fr31, fr31

positive: fadds. instruction

	fadds.	fr0, fr0, fr0
	fadds.	fr31, fr31, fr31

positive: fcfid instruction

	fcfid	fr0, fr0
	fcfid	fr31, fr31

positive: fcfid. instruction

	fcfid.	fr0, fr0
	fcfid.	fr31, fr31

positive: fcmpo instruction

	fcmpo	0, fr0, fr0
	fcmpo	7, fr31, fr31

positive: fcmpu instruction

	fcmpu	0, fr0, fr0
	fcmpu	7, fr31, fr31

positive: fctid instruction

	fctid	fr0, fr0
	fctid	fr31, fr31

positive: fctid. instruction

	fctid.	fr0, fr0
	fctid.	fr31, fr31

positive: fctidz instruction

	fctidz	fr0, fr0
	fctidz	fr31, fr31

positive: fctidz. instruction

	fctidz.	fr0, fr0
	fctidz.	fr31, fr31

positive: fctiw instruction

	fctiw	fr0, fr0
	fctiw	fr31, fr31

positive: fctiw. instruction

	fctiw.	fr0, fr0
	fctiw.	fr31, fr31

positive: fctiwz instruction

	fctiwz	fr0, fr0
	fctiwz	fr31, fr31

positive: fctiwz. instruction

	fctiwz.	fr0, fr0
	fctiwz.	fr31, fr31

positive: fdiv instruction

	fdiv	fr0, fr0, fr0
	fdiv	fr31, fr31, fr31

positive: fdiv. instruction

	fdiv.	fr0, fr0, fr0
	fdiv.	fr31, fr31, fr31

positive: fdivs instruction

	fdivs	fr0, fr0, fr0
	fdivs	fr31, fr31, fr31

positive: fdivs. instruction

	fdivs.	fr0, fr0, fr0
	fdivs.	fr31, fr31, fr31

positive: fmadd instruction

	fmadd	fr0, fr0, fr0, fr0
	fmadd	fr31, fr31, fr31, fr31

positive: fmadd. instruction

	fmadd.	fr0, fr0, fr0, fr0
	fmadd.	fr31, fr31, fr31, fr31

positive: fmadds instruction

	fmadds	fr0, fr0, fr0, fr0
	fmadds	fr31, fr31, fr31, fr31

positive: fmadds. instruction

	fmadds.	fr0, fr0, fr0, fr0
	fmadds.	fr31, fr31, fr31, fr31

positive: fmr instruction

	fmr	fr0, fr0
	fmr	fr31, fr31

positive: fmr. instruction

	fmr.	fr0, fr0
	fmr.	fr31, fr31

positive: fmsub instruction

	fmsub	fr0, fr0, fr0, fr0
	fmsub	fr31, fr31, fr31, fr31

positive: fmsub. instruction

	fmsub.	fr0, fr0, fr0, fr0
	fmsub.	fr31, fr31, fr31, fr31

positive: fmsubs instruction

	fmsubs	fr0, fr0, fr0, fr0
	fmsubs	fr31, fr31, fr31, fr31

positive: fmsubs. instruction

	fmsubs.	fr0, fr0, fr0, fr0
	fmsubs.	fr31, fr31, fr31, fr31

positive: fmul instruction

	fmul	fr0, fr0, fr0
	fmul	fr31, fr31, fr31

positive: fmul. instruction

	fmul.	fr0, fr0, fr0
	fmul.	fr31, fr31, fr31

positive: fmuls instruction

	fmuls	fr0, fr0, fr0
	fmuls	fr31, fr31, fr31

positive: fmuls. instruction

	fmuls.	fr0, fr0, fr0
	fmuls.	fr31, fr31, fr31

positive: fnabs instruction

	fnabs	fr0, fr0
	fnabs	fr31, fr31

positive: fnabs. instruction

	fnabs.	fr0, fr0
	fnabs.	fr31, fr31

positive: fneg instruction

	fneg	fr0, fr0
	fneg	fr31, fr31

positive: fneg. instruction

	fneg.	fr0, fr0
	fneg.	fr31, fr31

positive: fnmadd instruction

	fnmadd	fr0, fr0, fr0, fr0
	fnmadd	fr31, fr31, fr31, fr31

positive: fnmadd. instruction

	fnmadd.	fr0, fr0, fr0, fr0
	fnmadd.	fr31, fr31, fr31, fr31

positive: fnmadds instruction

	fnmadds	fr0, fr0, fr0, fr0
	fnmadds	fr31, fr31, fr31, fr31

positive: fnmadds. instruction

	fnmadds.	fr0, fr0, fr0, fr0
	fnmadds.	fr31, fr31, fr31, fr31

positive: fnmsub instruction

	fnmsub	fr0, fr0, fr0, fr0
	fnmsub	fr31, fr31, fr31, fr31

positive: fnmsub. instruction

	fnmsub.	fr0, fr0, fr0, fr0
	fnmsub.	fr31, fr31, fr31, fr31

positive: fnmsubs instruction

	fnmsubs	fr0, fr0, fr0, fr0
	fnmsubs	fr31, fr31, fr31, fr31

positive: fnmsubs. instruction

	fnmsubs.	fr0, fr0, fr0, fr0
	fnmsubs.	fr31, fr31, fr31, fr31

positive: fres instruction

	fres	fr0, fr0
	fres	fr31, fr31

positive: fres. instruction

	fres.	fr0, fr0
	fres.	fr31, fr31

positive: frsp instruction

	frsp	fr0, fr0
	frsp	fr31, fr31

positive: frsp. instruction

	frsp.	fr0, fr0
	frsp.	fr31, fr31

positive: frsqrte instruction

	frsqrte	fr0, fr0
	frsqrte	fr31, fr31

positive: frsqrte. instruction

	frsqrte.	fr0, fr0
	frsqrte.	fr31, fr31

positive: fsel instruction

	fsel	fr0, fr0, fr0, fr0
	fsel	fr31, fr31, fr31, fr31

positive: fsel. instruction

	fsel.	fr0, fr0, fr0, fr0
	fsel.	fr31, fr31, fr31, fr31

positive: fsqrt instruction

	fsqrt	fr0, fr0
	fsqrt	fr31, fr31

positive: fsqrt. instruction

	fsqrt.	fr0, fr0
	fsqrt.	fr31, fr31

positive: fsqrts instruction

	fsqrts	fr0, fr0
	fsqrts	fr31, fr31

positive: fsqrts. instruction

	fsqrts.	fr0, fr0
	fsqrts.	fr31, fr31

positive: fsub instruction

	fsub	fr0, fr0, fr0
	fsub	fr31, fr31, fr31

positive: fsub. instruction

	fsub.	fr0, fr0, fr0
	fsub.	fr31, fr31, fr31

positive: fsubs instruction

	fsubs	fr0, fr0, fr0
	fsubs	fr31, fr31, fr31

positive: fsubs. instruction

	fsubs.	fr0, fr0, fr0
	fsubs.	fr31, fr31, fr31

positive: icbi instruction

	icbi	r0, r0
	icbi	r31, r31

positive: isync instruction

	isync

positive: lbz instruction

	lbz	r0, -32768 (r0)
	lbz	r31, +32767 (r31)

positive: lbzu instruction

	lbzu	r0, -32768 (r0)
	lbzu	r31, +32767 (r31)

positive: lbzux instruction

	lbzux	r0, r0, r0
	lbzux	r31, r31, r31

positive: lbzx instruction

	lbzx	r0, r0, r0
	lbzx	r31, r31, r31

positive: la instruction

	la	r0, -32768 (r0)
	la	r31, +32764 (r31)

positive: ld instruction

	ld	r0, -32768 (r0)
	ld	r31, +32764 (r31)

positive: ldarx instruction

	ldarx	r0, r0, r0
	ldarx	r31, r31, r31

positive: ldu instruction

	ldu	r0, -32768 (r0)
	ldu	r31, +32764 (r31)

positive: ldux instruction

	ldux	r0, r0, r0
	ldux	r31, r31, r31

positive: ldx instruction

	ldx	r0, r0, r0
	ldx	r31, r31, r31

positive: lfd instruction

	lfd	fr0, -32768 (r0)
	lfd	fr31, +32767 (r31)

positive: lfdu instruction

	lfdu	fr0, -32768 (r0)
	lfdu	fr31, +32767 (r31)

positive: lfdux instruction

	lfdux	fr0, r0, r0
	lfdux	fr31, r31, r31

positive: lfdx instruction

	lfdx	fr0, r0, r0
	lfdx	fr31, r31, r31

positive: lfs instruction

	lfs	fr0, -32768 (r0)
	lfs	fr31, +32767 (r31)

positive: lfsu instruction

	lfsu	fr0, -32768 (r0)
	lfsu	fr31, +32767 (r31)

positive: lfsux instruction

	lfsux	fr0, r0, r0
	lfsux	fr31, r31, r31

positive: lfsx instruction

	lfsx	fr0, r0, r0
	lfsx	fr31, r31, r31

positive: lha instruction

	lha	r0, -32768 (r0)
	lha	r31, +32767 (r31)

positive: lhau instruction

	lhau	r0, -32768 (r0)
	lhau	r31, +32767 (r31)

positive: lhaux instruction

	lhaux	r0, r0, r0
	lhaux	r31, r31, r31

positive: lhax instruction

	lhax	r0, r0, r0
	lhax	r31, r31, r31

positive: lhbrx instruction

	lhbrx	r0, r0, r0
	lhbrx	r31, r31, r31

positive: lhz instruction

	lhz	r0, -32768 (r0)
	lhz	r31, +32767 (r31)

positive: lhzu instruction

	lhzu	r0, -32768 (r0)
	lhzu	r31, +32767 (r31)

positive: lhzux instruction

	lhzux	r0, r0, r0
	lhzux	r31, r31, r31

positive: lhzx instruction

	lhzx	r0, r0, r0
	lhzx	r31, r31, r31

positive: lmw instruction

	lmw	r0, -32768 (r0)
	lmw	r31, +32767 (r31)

positive: lswi instruction

	lswi	r0, r0, 0
	lswi	r31, r31, 31

positive: lswx instruction

	lswx	r0, r0, r0
	lswx	r31, r31, r31

positive: lwa instruction

	lwa	r0, -32768 (r0)
	lwa	r31, +32764 (r31)

positive: lwarx instruction

	lwarx	r0, r0, r0
	lwarx	r31, r31, r31

positive: lwaux instruction

	lwaux	r0, r0, r0
	lwaux	r31, r31, r31

positive: lwax instruction

	lwax	r0, r0, r0
	lwax	r31, r31, r31

positive: lwbrx instruction

	lwbrx	r0, r0, r0
	lwbrx	r31, r31, r31

positive: lwz instruction

	lwz	r0, -32768 (r0)
	lwz	r31, +32767 (r31)

positive: lwzu instruction

	lwzu	r0, -32768 (r0)
	lwzu	r31, +32767 (r31)

positive: lwzux instruction

	lwzux	r0, r0, r0
	lwzux	r31, r31, r31

positive: lwzx instruction

	lwzx	r0, r0, r0
	lwzx	r31, r31, r31

positive: mcrf instruction

	mcrf	0, 0
	mcrf	7, 7

positive: mcrfs instruction

	mcrfs	0, 0
	mcrfs	7, 7

positive: mcrxr instruction

	mcrxr	0
	mcrxr	7

positive: mfcr instruction

	mfcr	r0
	mfcr	r31

positive: mfocrf instruction

	mfocrf	r0, 0
	mfocrf	r31, 255

positive: mffs instruction

	mffs	fr0
	mffs	fr31

positive: mffs. instruction

	mffs.	fr0
	mffs.	fr31

positive: mfmsr instruction

	mfmsr	r0
	mfmsr	r31

positive: mfspr instruction

	mfspr	r0, 0
	mfspr	r31, 1023

positive: mfsr instruction

	.bitmode	32
	mfsr	r0, 0
	mfsr	r31, 15

positive: mfsrin instruction

	mfsrin	r0, r0
	mfsrin	r31, r31

positive: mftb instruction

	mftb	r0, 0
	mftb	r31, 1023

positive: mtcrf instruction

	mtcrf	0, r0
	mtcrf	255, r31

positive: mtfsb0 instruction

	mtfsb0	0
	mtfsb0	31

positive: mtfsb0. instruction

	mtfsb0.	0
	mtfsb0.	31

positive: mtfsb1 instruction

	mtfsb1	0
	mtfsb1	31

positive: mtfsb1. instruction

	mtfsb1.	0
	mtfsb1.	31

positive: mtfsf instruction

	mtfsf	0, fr0
	mtfsf	255, fr31

positive: mtfsf. instruction

	mtfsf.	0, fr0
	mtfsf.	255, fr31

positive: mtfsfi instruction

	mtfsfi	0, 0
	mtfsfi	7, 15

positive: mtfsfi. instruction

	mtfsfi.	0, 0
	mtfsfi.	7, 15

positive: mtmsr instruction

	mtmsr	r0, 0
	mtmsr	r31, 1

positive: mtmsrd instruction

	mtmsrd	r0, 0
	mtmsrd	r31, 1

positive: mtocrf instruction

	mtocrf	0, r0
	mtocrf	255, r31

positive: mtspr instruction

	mtspr	0, r0
	mtspr	1023, r31

positive: mtsr instruction

	.bitmode	32
	mtsr	0, r0
	mtsr	15, r31

positive: mtsrd instruction

	mtsrd	0, r0
	mtsrd	15, r31

positive: mtsrdin instruction

	mtsrdin	r0, r0
	mtsrdin	r31, r31

positive: mtsrin instruction

	.bitmode	32
	mtsrin	r0, r0
	mtsrin	r31, r31

positive: mulhd instruction

	mulhd	r0, r0, r0
	mulhd	r31, r31, r31

positive: mulhd. instruction

	mulhd.	r0, r0, r0
	mulhd.	r31, r31, r31

positive: mulhdu instruction

	mulhdu	r0, r0, r0
	mulhdu	r31, r31, r31

positive: mulhdu. instruction

	mulhdu.	r0, r0, r0
	mulhdu.	r31, r31, r31

positive: mulhw instruction

	mulhw	r0, r0, r0
	mulhw	r31, r31, r31

positive: mulhw. instruction

	mulhw.	r0, r0, r0
	mulhw.	r31, r31, r31

positive: mulhwu instruction

	mulhwu	r0, r0, r0
	mulhwu	r31, r31, r31

positive: mulhwu. instruction

	mulhwu.	r0, r0, r0
	mulhwu.	r31, r31, r31

positive: mulld instruction

	mulld	r0, r0, r0
	mulld	r31, r31, r31

positive: mulld. instruction

	mulld.	r0, r0, r0
	mulld.	r31, r31, r31

positive: mulldo instruction

	mulldo	r0, r0, r0
	mulldo	r31, r31, r31

positive: mulldo. instruction

	mulldo.	r0, r0, r0
	mulldo.	r31, r31, r31

positive: mulli instruction

	mulli	r0, r0, -32768
	mulli	r31, r31, +32767

positive: mullw instruction

	mullw	r0, r0, r0
	mullw	r31, r31, r31

positive: mullw. instruction

	mullw.	r0, r0, r0
	mullw.	r31, r31, r31

positive: mullwo instruction

	mullwo	r0, r0, r0
	mullwo	r31, r31, r31

positive: mullwo. instruction

	mullwo.	r0, r0, r0
	mullwo.	r31, r31, r31

positive: nand instruction

	nand	r0, r0, r0
	nand	r31, r31, r31

positive: nand. instruction

	nand.	r0, r0, r0
	nand.	r31, r31, r31

positive: neg instruction

	neg	r0, r0
	neg	r31, r31

positive: neg. instruction

	neg.	r0, r0
	neg.	r31, r31

positive: nego instruction

	nego	r0, r0
	nego	r31, r31

positive: nego. instruction

	nego.	r0, r0
	nego.	r31, r31

positive: nor instruction

	nor	r0, r0, r0
	nor	r31, r31, r31

positive: nor. instruction

	nor.	r0, r0, r0
	nor.	r31, r31, r31

positive: not instruction

	not	r0, r0
	not	r31, r31

positive: not. instruction

	not.	r0, r0
	not.	r31, r31

positive: or instruction

	or	r0, r0, r0
	or	r31, r31, r31

positive: or. instruction

	or.	r0, r0, r0
	or.	r31, r31, r31

positive: mr instruction

	mr	r0, r0
	mr	r31, r31

positive: mr. instruction

	mr.	r0, r0
	mr.	r31, r31

positive: orc instruction

	orc	r0, r0, r0
	orc	r31, r31, r31

positive: orc. instruction

	orc.	r0, r0, r0
	orc.	r31, r31, r31

positive: ori instruction

	ori	r0, r0, 0
	ori	r31, r31, 65535

positive: oris instruction

	oris	r0, r0, 0
	oris	r31, r31, 65535

positive: rfi instruction

	.bitmode	32
	rfi

positive: rfid instruction

	rfid

positive: rldcl instruction

	rldcl	r0, r0, r0, 0
	rldcl	r31, r31, r31, 63

positive: rldcl. instruction

	rldcl.	r0, r0, r0, 0
	rldcl.	r31, r31, r31, 63

positive: rldcr instruction

	rldcr	r0, r0, r0, 0
	rldcr	r31, r31, r31, 63

positive: rldcr. instruction

	rldcr.	r0, r0, r0, 0
	rldcr.	r31, r31, r31, 63

positive: rldic instruction

	rldic	r0, r0, 0, 0
	rldic	r31, r31, 63, 63

positive: rldic. instruction

	rldic.	r0, r0, 0, 0
	rldic.	r31, r31, 63, 63

positive: rldicl instruction

	rldicl	r0, r0, 0, 0
	rldicl	r31, r31, 63, 63

positive: rldicl. instruction

	rldicl.	r0, r0, 0, 0
	rldicl.	r31, r31, 63, 63

positive: rldicr instruction

	rldicr	r0, r0, 0, 0
	rldicr	r31, r31, 63, 63

positive: rldicr. instruction

	rldicr.	r0, r0, 0, 0
	rldicr.	r31, r31, 63, 63

positive: rldimi instruction

	rldimi	r0, r0, 0, 0
	rldimi	r31, r31, 63, 63

positive: rldimi. instruction

	rldimi.	r0, r0, 0, 0
	rldimi.	r31, r31, 63, 63

positive: rlwimi instruction

	rlwimi	r0, r0, 0, 0, 0
	rlwimi	r31, r31, 31, 31, 31

positive: rlwimi. instruction

	rlwimi.	r0, r0, 0, 0, 0
	rlwimi.	r31, r31, 31, 31, 31

positive: rlwinm instruction

	rlwinm	r0, r0, 0, 0, 0
	rlwinm	r31, r31, 31, 31, 31

positive: rlwinm. instruction

	rlwinm.	r0, r0, 0, 0, 0
	rlwinm.	r31, r31, 31, 31, 31

positive: rlwnm instruction

	rlwnm	r0, r0, r0, 0, 0
	rlwnm	r31, r31, r31, 31, 31

positive: rlwnm. instruction

	rlwnm.	r0, r0, r0, 0, 0
	rlwnm.	r31, r31, r31, 31, 31

positive: sc instruction

	sc

positive: slbia instruction

	slbia

positive: slbie instruction

	slbie	r0
	slbie	r31

positive: slbmfee instruction

	slbmfee	r0, r0
	slbmfee	r31, r31

positive: slbmfev instruction

	slbmfev	r0, r0
	slbmfev	r31, r31

positive: slbmte instruction

	slbmte	r0, r0
	slbmte	r31, r31

positive: sld instruction

	sld	r0, r0, r0
	sld	r31, r31, r31

positive: sld. instruction

	sld.	r0, r0, r0
	sld.	r31, r31, r31

positive: slw instruction

	slw	r0, r0, r0
	slw	r31, r31, r31

positive: slw. instruction

	slw.	r0, r0, r0
	slw.	r31, r31, r31

positive: srad instruction

	srad	r0, r0, r0
	srad	r31, r31, r31

positive: srad. instruction

	srad.	r0, r0, r0
	srad.	r31, r31, r31

positive: sradi instruction

	sradi	r0, r0, 0
	sradi	r31, r31, 63

positive: sradi. instruction

	sradi.	r0, r0, 0
	sradi.	r31, r31, 63

positive: sraw instruction

	sraw	r0, r0, r0
	sraw	r31, r31, r31

positive: sraw. instruction

	sraw.	r0, r0, r0
	sraw.	r31, r31, r31

positive: srawi instruction

	srawi	r0, r0, 0
	srawi	r31, r31, 31

positive: srawi. instruction

	srawi.	r0, r0, 0
	srawi.	r31, r31, 31

positive: srd instruction

	srd	r0, r0, r0
	srd	r31, r31, r31

positive: srd. instruction

	srd.	r0, r0, r0
	srd.	r31, r31, r31

positive: srw instruction

	srw	r0, r0, r0
	srw	r31, r31, r31

positive: srw. instruction

	srw.	r0, r0, r0
	srw.	r31, r31, r31

positive: stb instruction

	stb	r0, -32768 (r0)
	stb	r31, +32767 (r31)

positive: stbu instruction

	stbu	r0, -32768 (r0)
	stbu	r31, +32767 (r31)

positive: stbux instruction

	stbux	r0, r0, r0
	stbux	r31, r31, r31

positive: stbx instruction

	stbx	r0, r0, r0
	stbx	r31, r31, r31

positive: std instruction

	std	r0, -32768 (r0)
	std	r31, +32764 (r31)

positive: stdcx. instruction

	stdcx.	r0, r0, r0
	stdcx.	r31, r31, r31

positive: stdu instruction

	stdu	r0, -32768 (r0)
	stdu	r31, +32764 (r31)

positive: stdux instruction

	stdux	r0, r0, r0
	stdux	r31, r31, r31

positive: stdx instruction

	stdx	r0, r0, r0
	stdx	r31, r31, r31

positive: stfd instruction

	stfd	fr0, -32768 (r0)
	stfd	fr31, +32767 (r31)

positive: stfdu instruction

	stfdu	fr0, -32768 (r0)
	stfdu	fr31, +32767 (r31)

positive: stfdux instruction

	stfdux	fr0, r0, r0
	stfdux	fr31, r31, r31

positive: stfdx instruction

	stfdx	fr0, r0, r0
	stfdx	fr31, r31, r31

positive: stfiwx instruction

	stfiwx	fr0, r0, r0
	stfiwx	fr31, r31, r31

positive: stfs instruction

	stfs	fr0, -32768 (r0)
	stfs	fr31, +32767 (r31)

positive: stfsu instruction

	stfsu	fr0, -32768 (r0)
	stfsu	fr31, +32767 (r31)

positive: stfsux instruction

	stfsux	fr0, r0, r0
	stfsux	fr31, r31, r31

positive: stfsx instruction

	stfsx	fr0, r0, r0
	stfsx	fr31, r31, r31

positive: sth instruction

	sth	r0, -32768 (r0)
	sth	r31, +32767 (r31)

positive: sthbrx instruction

	sthbrx	r0, r0, r0
	sthbrx	r31, r31, r31

positive: sthu instruction

	sthu	r0, -32768 (r0)
	sthu	r31, +32767 (r31)

positive: sthux instruction

	sthux	r0, r0, r0
	sthux	r31, r31, r31

positive: sthx instruction

	sthx	r0, r0, r0
	sthx	r31, r31, r31

positive: stmw instruction

	stmw	r0, -32768 (r0)
	stmw	r31, +32767 (r31)

positive: stswi instruction

	stswi	r0, r0, 0
	stswi	r31, r31, 31

positive: stswx instruction

	stswx	r0, r0, r0
	stswx	r31, r31, r31

positive: stw instruction

	stw	r0, -32768 (r0)
	stw	r31, +32767 (r31)

positive: stwbrx instruction

	stwbrx	r0, r0, r0
	stwbrx	r31, r31, r31

positive: stwcx. instruction

	stwcx.	r0, r0, r0
	stwcx.	r31, r31, r31

positive: stwu instruction

	stwu	r0, -32768 (r0)
	stwu	r31, +32767 (r31)

positive: stwux instruction

	stwux	r0, r0, r0
	stwux	r31, r31, r31

positive: stwx instruction

	stwx	r0, r0, r0
	stwx	r31, r31, r31

positive: subf instruction

	subf	r0, r0, r0
	subf	r31, r31, r31

positive: subf. instruction

	subf.	r0, r0, r0
	subf.	r31, r31, r31

positive: subfo instruction

	subfo	r0, r0, r0
	subfo	r31, r31, r31

positive: subfo. instruction

	subfo.	r0, r0, r0
	subfo.	r31, r31, r31

positive: subfc instruction

	subfc	r0, r0, r0
	subfc	r31, r31, r31

positive: subfc. instruction

	subfc.	r0, r0, r0
	subfc.	r31, r31, r31

positive: subfco instruction

	subfco	r0, r0, r0
	subfco	r31, r31, r31

positive: subfco. instruction

	subfco.	r0, r0, r0
	subfco.	r31, r31, r31

positive: subfe instruction

	subfe	r0, r0, r0
	subfe	r31, r31, r31

positive: subfe. instruction

	subfe.	r0, r0, r0
	subfe.	r31, r31, r31

positive: subfeo instruction

	subfeo	r0, r0, r0
	subfeo	r31, r31, r31

positive: subfeo. instruction

	subfeo.	r0, r0, r0
	subfeo.	r31, r31, r31

positive: subfic instruction

	subfic	r0, r0, -32768
	subfic	r31, r31, +32767

positive: subfme instruction

	subfme	r0, r0
	subfme	r31, r31

positive: subfme. instruction

	subfme.	r0, r0
	subfme.	r31, r31

positive: subfmeo instruction

	subfmeo	r0, r0
	subfmeo	r31, r31

positive: subfmeo. instruction

	subfmeo.	r0, r0
	subfmeo.	r31, r31

positive: subfze instruction

	subfze	r0, r0
	subfze	r31, r31

positive: subfze. instruction

	subfze.	r0, r0
	subfze.	r31, r31

positive: subfzeo instruction

	subfzeo	r0, r0
	subfzeo	r31, r31

positive: subfzeo. instruction

	subfzeo.	r0, r0
	subfzeo.	r31, r31

positive: sub instruction

	sub	r0, r0, r0
	sub	r31, r31, r31

positive: sub. instruction

	sub.	r0, r0, r0
	sub.	r31, r31, r31

positive: subo instruction

	subo	r0, r0, r0
	subo	r31, r31, r31

positive: subo. instruction

	subo.	r0, r0, r0
	subo.	r31, r31, r31

positive: subc instruction

	subc	r0, r0, r0
	subc	r31, r31, r31

positive: subc. instruction

	subc.	r0, r0, r0
	subc.	r31, r31, r31

positive: subco instruction

	subco	r0, r0, r0
	subco	r31, r31, r31

positive: subco. instruction

	subco.	r0, r0, r0
	subco.	r31, r31, r31

positive: subi instruction

	subi	r0, r0, -32768
	subi	r31, r31, +32767

positive: subic instruction

	subic	r0, r0, -32768
	subic	r31, r31, +32767

positive: subic. instruction

	subic.	r0, r0, -32768
	subic.	r31, r31, +32767

positive: subis instruction

	subis	r0, r0, -32768
	subis	r31, r31, +32767

positive: sync instruction

	sync	0
	sync	3

positive: td instruction

	td	0, r0, r0
	td	31, r31, r31

positive: tdi instruction

	tdi	0, r0, -32768
	tdi	31, r31, +32767

positive: tlbia instruction

	tlbia

positive: tlbie instruction

	tlbie	r0, 0
	tlbie	r31, 1

positive: tlbiel instruction

	tlbiel	r0, 0
	tlbiel	r31, 1

positive: tlbsync instruction

	tlbsync

positive: tw instruction

	tw	0, r0, r0
	tw	31, r31, r31

positive: twi instruction

	twi	0, r0, -32768
	twi	31, r31, +32767

positive: xor instruction

	xor	r0, r0, r0
	xor	r31, r31, r31

positive: xor. instruction

	xor.	r0, r0, r0
	xor.	r31, r31, r31

positive: xori instruction

	xori	r0, r0, 0
	xori	r31, r31, 65535

positive: xoris instruction

	xoris	r0, r0, 0
	xoris	r31, r31, 65535

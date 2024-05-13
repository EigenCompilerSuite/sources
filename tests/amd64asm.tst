# AMD64 assembler test and validation suite
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

positive: 64-bit mode

	.bitmode	64
	.assert	.bitmode == 64

negative: 128-bit mode

	.bitmode	128

positive: duplicated bit mode

	.bitmode	16
	.assert	.bitmode == 16
	.bitmode	32
	.assert	.bitmode == 32
	.bitmode	64
	.assert	.bitmode == 64
	.bitmode	16
	.assert	.bitmode == 16
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

# AMD64 assembler

# invalid instructions in 64-bit mode

positive: aaa instruction in 16-bit mode

	.bitmode	16
	aaa

positive: aaa instruction in 32-bit mode

	.bitmode	32
	aaa

negative: aaa instruction in 64-bit mode

	.bitmode	64
	aaa

positive: aad instruction in 16-bit mode

	.bitmode	16
	aad

positive: aad instruction in 32-bit mode

	.bitmode	32
	aad

negative: aad instruction in 64-bit mode

	.bitmode	64
	aad

positive: aam instruction in 16-bit mode

	.bitmode	16
	aam

positive: aam instruction in 32-bit mode

	.bitmode	32
	aam

negative: aam instruction in 64-bit mode

	.bitmode	64
	aam

positive: aas instruction in 16-bit mode

	.bitmode	16
	aas

positive: aas instruction in 32-bit mode

	.bitmode	32
	aas

negative: aas instruction in 64-bit mode

	.bitmode	64
	aas

positive: arpl instruction in 16-bit mode

	.bitmode	16
	arpl	bx, cx

positive: arpl instruction in 32-bit mode

	.bitmode	32
	arpl	bx, cx

negative: arpl instruction in 64-bit mode

	.bitmode	64
	arpl	bx, cx

positive: bound instruction in 16-bit mode

	.bitmode	16
	bound	ax, [0]

positive: bound instruction in 32-bit mode

	.bitmode	32
	bound	ax, [0]

negative: bound instruction in 64-bit mode

	.bitmode	64
	bound	ax, [0]

positive: callfar instruction in 16-bit mode

	.bitmode	16
	callfar	0, 0

positive: callfar instruction in 32-bit mode

	.bitmode	32
	callfar	0, 0

negative: callfar instruction in 64-bit mode

	.bitmode	64
	callfar	0, 0

positive: daa instruction in 16-bit mode

	.bitmode	16
	daa

positive: daa instruction in 32-bit mode

	.bitmode	32
	daa

negative: daa instruction in 64-bit mode

	.bitmode	64
	daa

positive: das instruction in 16-bit mode

	.bitmode	16
	das

positive: das instruction in 32-bit mode

	.bitmode	32
	das

negative: das instruction in 64-bit mode

	.bitmode	64
	das

positive: into instruction in 16-bit mode

	.bitmode	16
	into

positive: into instruction in 32-bit mode

	.bitmode	32
	into

negative: into instruction in 64-bit mode

	.bitmode	64
	into

positive: jcxz instruction in 16-bit mode

	.bitmode	16
	jcxz	0

positive: jcxz instruction in 32-bit mode

	.bitmode	32
	jcxz	0

negative: jcxz instruction in 64-bit mode

	.bitmode	64
	jcxz	0

positive: jmpfar instruction in 16-bit mode

	.bitmode	16
	jmpfar	0, 0

positive: jmpfar instruction in 32-bit mode

	.bitmode	32
	jmpfar	0, 0

negative: jmpfar instruction in 64-bit mode

	.bitmode	64
	jmpfar	0, 0

positive: lds instruction in 16-bit mode

	.bitmode	16
	lds	ax, [0]

positive: lds instruction in 32-bit mode

	.bitmode	32
	lds	ax, [0]

negative: lds instruction in 64-bit mode

	.bitmode	64
	lds	ax, [0]

positive: les instruction in 16-bit mode

	.bitmode	16
	les	ax, [0]

positive: les instruction in 32-bit mode

	.bitmode	32
	les	ax, [0]

negative: les instruction in 64-bit mode

	.bitmode	64
	les	ax, [0]

positive: lfs instruction in 16-bit mode

	.bitmode	16
	lfs	ax, [0]

positive: lfs instruction in 32-bit mode

	.bitmode	32
	lfs	ax, [0]

positive: lfs instruction in 64-bit mode

	.bitmode	64
	lfs	ax, [0]

positive: lgs instruction in 16-bit mode

	.bitmode	16
	lgs	ax, [0]

positive: lgs instruction in 32-bit mode

	.bitmode	32
	lgs	ax, [0]

positive: lgs instruction in 64-bit mode

	.bitmode	64
	lgs	ax, [0]

positive: lss instruction in 16-bit mode

	.bitmode	16
	lss	ax, [0]

positive: lss instruction in 32-bit mode

	.bitmode	32
	lss	ax, [0]

positive: lss instruction in 64-bit mode

	.bitmode	64
	lss	ax, [0]

positive: pop ds instruction in 16-bit mode

	.bitmode	16
	pop	ds

positive: pop ds instruction in 32-bit mode

	.bitmode	32
	pop	ds

negative: pop ds instruction in 64-bit mode

	.bitmode	64
	pop	ds

positive: pop es instruction in 16-bit mode

	.bitmode	16
	pop	es

positive: pop es instruction in 32-bit mode

	.bitmode	32
	pop	es

negative: pop es instruction in 64-bit mode

	.bitmode	64
	pop	es

positive: pop ss instruction in 16-bit mode

	.bitmode	16
	pop	ss

positive: pop ss instruction in 32-bit mode

	.bitmode	32
	pop	ss

negative: pop ss instruction in 64-bit mode

	.bitmode	64
	pop	ss

positive: pop fs instruction in 16-bit mode

	.bitmode	16
	pop	fs

positive: pop fs instruction in 32-bit mode

	.bitmode	32
	pop	fs

positive: pop fs instruction in 64-bit mode

	.bitmode	64
	pop	fs

positive: pop gs instruction in 16-bit mode

	.bitmode	16
	pop	gs

positive: pop gs instruction in 32-bit mode

	.bitmode	32
	pop	gs

positive: pop gs instruction in 64-bit mode

	.bitmode	64
	pop	gs

positive: popa instruction in 16-bit mode

	.bitmode	16
	popa

positive: popa instruction in 32-bit mode

	.bitmode	32
	popa

negative: popa instruction in 64-bit mode

	.bitmode	64
	popa

positive: popad instruction in 16-bit mode

	.bitmode	16
	popad

positive: popad instruction in 32-bit mode

	.bitmode	32
	popad

negative: popad instruction in 64-bit mode

	.bitmode	64
	popad

positive: popfd instruction in 16-bit mode

	.bitmode	16
	popfd

positive: popfd instruction in 32-bit mode

	.bitmode	32
	popfd

negative: popfd instruction in 64-bit mode

	.bitmode	64
	popfd

positive: push ds instruction in 16-bit mode

	.bitmode	16
	push	ds

positive: push ds instruction in 32-bit mode

	.bitmode	32
	push	ds

negative: push ds instruction in 64-bit mode

	.bitmode	64
	push	ds

positive: push es instruction in 16-bit mode

	.bitmode	16
	push	es

positive: push es instruction in 32-bit mode

	.bitmode	32
	push	es

negative: push es instruction in 64-bit mode

	.bitmode	64
	push	es

positive: push ss instruction in 16-bit mode

	.bitmode	16
	push	ss

positive: push ss instruction in 32-bit mode

	.bitmode	32
	push	ss

negative: push ss instruction in 64-bit mode

	.bitmode	64
	push	ss

positive: push fs instruction in 16-bit mode

	.bitmode	16
	push	fs

positive: push fs instruction in 32-bit mode

	.bitmode	32
	push	fs

positive: push fs instruction in 64-bit mode

	.bitmode	64
	push	fs

positive: push gs instruction in 16-bit mode

	.bitmode	16
	push	gs

positive: push gs instruction in 32-bit mode

	.bitmode	32
	push	gs

positive: push gs instruction in 64-bit mode

	.bitmode	64
	push	gs

positive: pusha instruction in 16-bit mode

	.bitmode	16
	pusha

positive: pusha instruction in 32-bit mode

	.bitmode	32
	pusha

negative: pusha instruction in 64-bit mode

	.bitmode	64
	pusha

positive: pushad instruction in 16-bit mode

	.bitmode	16
	pushad

positive: pushad instruction in 32-bit mode

	.bitmode	32
	pushad

negative: pushad instruction in 64-bit mode

	.bitmode	64
	pushad

positive: pushfd instruction in 16-bit mode

	.bitmode	16
	pushfd

positive: pushfd instruction in 32-bit mode

	.bitmode	32
	pushfd

negative: pushfd instruction in 64-bit mode

	.bitmode	64
	pushfd

# general-purpose instructions

positive: aaa instruction

	.bitmode	32
	aaa

positive: aad instruction

	.bitmode	32
	aad
	aad	byte 10

positive: aam instruction

	.bitmode	32
	aam
	aam	byte 10

positive: aas instruction

	.bitmode	32
	aas

positive: adc instruction

	adc	al, byte 0
	adc	al, byte 255
	adc	ax, word 0
	adc	ax, word 65535
	adc	eax, dword 0
	adc	eax, dword 4294967295
	adc	rax, dword -2147483648
	adc	rax, dword 2147483647
	adc	bl, byte 0
	adc	byte [rsp], byte 255
	adc	bx, word 0
	adc	word [rsp], word 65535
	adc	ebx, dword 0
	adc	dword [rsp], dword 4294967295
	adc	rbx, dword -2147483648
	adc	qword [rsp], dword 2147483647
	adc	bx, byte -128
	adc	word [rsp], byte 127
	adc	ebx, byte -128
	adc	dword [rsp], byte 127
	adc	rbx, byte -128
	adc	qword [rsp], byte 127
	adc	bl, cl
	adc	byte [rsp], cl
	adc	bx, cx
	adc	word [rsp], cx
	adc	ebx, ecx
	adc	dword [rsp], ecx
	adc	rbx, rcx
	adc	qword [rsp], rcx
	adc	cl, bl
	adc	cl, byte [rsp]
	adc	cx, bx
	adc	cx, word [rsp]
	adc	ecx, ebx
	adc	ecx, dword [rsp]
	adc	rcx, rbx
	adc	rcx, qword [rsp]
	lock adc	byte [rsp], byte 255
	lock adc	word [rsp], word 65535
	lock adc	dword [rsp], dword 4294967295
	lock adc	qword [rsp], dword 2147483647
	lock adc	word [rsp], byte 127
	lock adc	dword [rsp], byte 127
	lock adc	qword [rsp], byte 127
	lock adc	byte [rsp], cl
	lock adc	word [rsp], cx
	lock adc	dword [rsp], ecx
	lock adc	qword [rsp], rcx

positive: adcx instruction

	adcx	ecx, ebx
	adcx	ecx, dword [rsp]
	adcx	rcx, rbx
	adcx	rcx, qword [rsp]

positive: add instruction

	add	al, byte 0
	add	al, byte 255
	add	ax, word 0
	add	ax, word 65535
	add	eax, dword 0
	add	eax, dword 4294967295
	add	rax, dword -2147483648
	add	rax, dword 2147483647
	add	bl, byte 0
	add	byte [rsp], byte 255
	add	bx, word 0
	add	word [rsp], word 65535
	add	ebx, dword 0
	add	dword [rsp], dword 4294967295
	add	rbx, dword -2147483648
	add	qword [rsp], dword 2147483647
	add	bx, byte -128
	add	word [rsp], byte 127
	add	ebx, byte -128
	add	dword [rsp], byte 127
	add	rbx, byte -128
	add	qword [rsp], byte 127
	add	bl, cl
	add	byte [rsp], cl
	add	bx, cx
	add	word [rsp], cx
	add	ebx, ecx
	add	dword [rsp], ecx
	add	rbx, rcx
	add	qword [rsp], rcx
	add	cl, bl
	add	cl, byte [rsp]
	add	cx, bx
	add	cx, word [rsp]
	add	ecx, ebx
	add	ecx, dword [rsp]
	add	rcx, rbx
	add	rcx, qword [rsp]
	lock add	byte [rsp], byte 255
	lock add	word [rsp], word 65535
	lock add	dword [rsp], dword 4294967295
	lock add	qword [rsp], dword 2147483647
	lock add	word [rsp], byte 127
	lock add	dword [rsp], byte 127
	lock add	qword [rsp], byte 127
	lock add	byte [rsp], cl
	lock add	word [rsp], cx
	lock add	dword [rsp], ecx
	lock add	qword [rsp], rcx

positive: adox instruction

	adox	ecx, ebx
	adox	ecx, dword [rsp]
	adox	rcx, rbx
	adox	rcx, qword [rsp]

positive: and instruction

	and	al, byte 0
	and	al, byte 255
	and	ax, word 0
	and	ax, word 65535
	and	eax, dword 0
	and	eax, dword 4294967295
	and	rax, dword -2147483648
	and	rax, dword 2147483647
	and	bl, byte 0
	and	byte [rsp], byte 255
	and	bx, word 0
	and	word [rsp], word 65535
	and	ebx, dword 0
	and	dword [rsp], dword 4294967295
	and	rbx, dword -2147483648
	and	qword [rsp], dword 2147483647
	and	bx, byte -128
	and	word [rsp], byte 127
	and	ebx, byte -128
	and	dword [rsp], byte 127
	and	rbx, byte -128
	and	qword [rsp], byte 127
	and	bl, cl
	and	byte [rsp], cl
	and	bx, cx
	and	word [rsp], cx
	and	ebx, ecx
	and	dword [rsp], ecx
	and	rbx, rcx
	and	qword [rsp], rcx
	and	cl, bl
	and	cl, byte [rsp]
	and	cx, bx
	and	cx, word [rsp]
	and	ecx, ebx
	and	ecx, dword [rsp]
	and	rcx, rbx
	and	rcx, qword [rsp]
	lock and	byte [rsp], byte 255
	lock and	word [rsp], word 65535
	lock and	dword [rsp], dword 4294967295
	lock and	qword [rsp], dword 2147483647
	lock and	word [rsp], byte 127
	lock and	dword [rsp], byte 127
	lock and	qword [rsp], byte 127
	lock and	byte [rsp], cl
	lock and	word [rsp], cx
	lock and	dword [rsp], ecx
	lock and	qword [rsp], rcx

positive: bound instruction

	.bitmode	32
	bound	cx, [esp]
	bound	ecx, [esp]

positive: bsf instruction

	bsf	cx, bx
	bsf	cx, word [rsp]
	bsf	ecx, ebx
	bsf	ecx, dword [rsp]
	bsf	rcx, rbx
	bsf	rcx, qword [rsp]

positive: bsr instruction

	bsr	cx, bx
	bsr	cx, word [rsp]
	bsr	ecx, ebx
	bsr	ecx, dword [rsp]
	bsr	rcx, rbx
	bsr	rcx, qword [rsp]

positive: bswap instruction

	bswap	ecx
	bswap	rcx

positive: bt instruction

	bt	bx, cx
	bt	word [rsp], cx
	bt	ebx, ecx
	bt	dword [rsp], ecx
	bt	rbx, rcx
	bt	qword [rsp], rcx
	bt	bx, byte 0
	bt	bx, byte 255
	bt	ebx, byte 0
	bt	ebx, byte 255
	bt	rbx, byte 0
	bt	rbx, byte 255

positive: btc instruction

	btc	bx, cx
	btc	word [rsp], cx
	btc	ebx, ecx
	btc	dword [rsp], ecx
	btc	rbx, rcx
	btc	qword [rsp], rcx
	btc	bx, byte 0
	btc	bx, byte 255
	btc	ebx, byte 0
	btc	ebx, byte 255
	btc	rbx, byte 0
	btc	rbx, byte 255
	lock btc	word [rsp], cx
	lock btc	dword [rsp], ecx
	lock btc	qword [rsp], rcx

positive: btr instruction

	btr	bx, cx
	btr	word [rsp], cx
	btr	ebx, ecx
	btr	dword [rsp], ecx
	btr	rbx, rcx
	btr	qword [rsp], rcx
	btr	bx, byte 0
	btr	bx, byte 255
	btr	ebx, byte 0
	btr	ebx, byte 255
	btr	rbx, byte 0
	btr	rbx, byte 255
	lock btr	word [rsp], cx
	lock btr	dword [rsp], ecx
	lock btr	qword [rsp], rcx

positive: bts instruction

	bts	bx, cx
	bts	word [rsp], cx
	bts	ebx, ecx
	bts	dword [rsp], ebx
	bts	rbx, rcx
	bts	qword [rsp], rcx
	bts	bx, byte 0
	bts	bx, byte 255
	bts	ebx, byte 0
	bts	ebx, byte 255
	bts	rbx, byte 0
	bts	rbx, byte 255
	lock bts	word [rsp], cx
	lock bts	dword [rsp], ecx
	lock bts	qword [rsp], rcx

positive: bzhi instruction

	bzhi	ebx, ecx, edx
	bzhi	ebx, dword [rsp], edx
	bzhi	rbx, rcx, rdx
	bzhi	rbx, qword [rsp], rdx

positive: call instruction

	call	word -32768
	call	word 32767
	call	dword -2147483648
	call	dword 2147483647
	call	bx
	call	word [rsp]
	call	rbx
	call	qword [rsp]
	.bitmode	32
	call	ebx
	call	dword [esp]

positive: callfar instruction

	callfar	word [rsp]
	callfar	dword [rsp]
	.bitmode	32
	callfar	word 0, word -32768
	callfar	word 65335, word 32767
	callfar	word 0, dword -2147483648
	callfar	word 65335, dword 2147483647

positive: cbw instruction

	cbw

positive: cwde instruction

	cwde

positive: cdqe instruction

	cdqe

positive: cwd instruction

	cwd

positive: cdq instruction

	cdq

positive: cqo instruction

	cqo

positive: clac instruction

	clac

positive: clc instruction

	clc

positive: cld instruction

	cld

positive: clflush instruction

	clflush	[rsp]

positive: clflushopt instruction

	clflushopt	[rsp]

positive: clwb instruction

	clwb	[rsp]

positive: clzero instruction

	clzero

positive: cmc instruction

	cmc

positive: cmovo instruction

	cmovo	cx, bx
	cmovo	cx, word [rsp]
	cmovo	ecx, ebx
	cmovo	ecx, dword [rsp]
	cmovo	rcx, rbx
	cmovo	rcx, qword [rsp]

positive: cmovno instruction

	cmovno	cx, bx
	cmovno	cx, word [rsp]
	cmovno	ecx, ebx
	cmovno	ecx, dword [rsp]
	cmovno	rcx, rbx
	cmovno	rcx, qword [rsp]

positive: cmovb instruction

	cmovb	cx, bx
	cmovb	cx, word [rsp]
	cmovb	ecx, ebx
	cmovb	ecx, dword [rsp]
	cmovb	rcx, rbx
	cmovb	rcx, qword [rsp]

positive: cmovc instruction

	cmovc	cx, bx
	cmovc	cx, word [rsp]
	cmovc	ecx, ebx
	cmovc	ecx, dword [rsp]
	cmovc	rcx, rbx
	cmovc	rcx, qword [rsp]

positive: cmovnae instruction

	cmovnae	cx, bx
	cmovnae	cx, word [rsp]
	cmovnae	ecx, ebx
	cmovnae	ecx, dword [rsp]
	cmovnae	rcx, rbx
	cmovnae	rcx, qword [rsp]

positive: cmovnb instruction

	cmovnb	cx, bx
	cmovnb	cx, word [rsp]
	cmovnb	ecx, ebx
	cmovnb	ecx, dword [rsp]
	cmovnb	rcx, rbx
	cmovnb	rcx, qword [rsp]

positive: cmovnc instruction

	cmovnc	cx, bx
	cmovnc	cx, word [rsp]
	cmovnc	ecx, ebx
	cmovnc	ecx, dword [rsp]
	cmovnc	rcx, rbx
	cmovnc	rcx, qword [rsp]

positive: cmovae instruction

	cmovae	cx, bx
	cmovae	cx, word [rsp]
	cmovae	ecx, ebx
	cmovae	ecx, dword [rsp]
	cmovae	rcx, rbx
	cmovae	rcx, qword [rsp]

positive: cmovz instruction

	cmovz	cx, bx
	cmovz	cx, word [rsp]
	cmovz	ecx, ebx
	cmovz	ecx, dword [rsp]
	cmovz	rcx, rbx
	cmovz	rcx, qword [rsp]

positive: cmove instruction

	cmove	cx, bx
	cmove	cx, word [rsp]
	cmove	ecx, ebx
	cmove	ecx, dword [rsp]
	cmove	rcx, rbx
	cmove	rcx, qword [rsp]

positive: cmovnz instruction

	cmovnz	cx, bx
	cmovnz	cx, word [rsp]
	cmovnz	ecx, ebx
	cmovnz	ecx, dword [rsp]
	cmovnz	rcx, rbx
	cmovnz	rcx, qword [rsp]

positive: cmovne instruction

	cmovne	cx, bx
	cmovne	cx, word [rsp]
	cmovne	ecx, ebx
	cmovne	ecx, dword [rsp]
	cmovne	rcx, rbx
	cmovne	rcx, qword [rsp]

positive: cmovbe instruction

	cmovbe	cx, bx
	cmovbe	cx, word [rsp]
	cmovbe	ecx, ebx
	cmovbe	ecx, dword [rsp]
	cmovbe	rcx, rbx
	cmovbe	rcx, qword [rsp]

positive: cmovna instruction

	cmovna	cx, bx
	cmovna	cx, word [rsp]
	cmovna	ecx, ebx
	cmovna	ecx, dword [rsp]
	cmovna	rcx, rbx
	cmovna	rcx, qword [rsp]

positive: cmovnbe instruction

	cmovnbe	cx, bx
	cmovnbe	cx, word [rsp]
	cmovnbe	ecx, ebx
	cmovnbe	ecx, dword [rsp]
	cmovnbe	rcx, rbx
	cmovnbe	rcx, qword [rsp]

positive: cmova instruction

	cmova	cx, bx
	cmova	cx, word [rsp]
	cmova	ecx, ebx
	cmova	ecx, dword [rsp]
	cmova	rcx, rbx
	cmova	rcx, qword [rsp]

positive: cmovs instruction

	cmovs	cx, bx
	cmovs	cx, word [rsp]
	cmovs	ecx, ebx
	cmovs	ecx, dword [rsp]
	cmovs	rcx, rbx
	cmovs	rcx, qword [rsp]

positive: cmovns instruction

	cmovns	cx, bx
	cmovns	cx, word [rsp]
	cmovns	ecx, ebx
	cmovns	ecx, dword [rsp]
	cmovns	rcx, rbx
	cmovns	rcx, qword [rsp]

positive: cmovp instruction

	cmovp	cx, bx
	cmovp	cx, word [rsp]
	cmovp	ecx, ebx
	cmovp	ecx, dword [rsp]
	cmovp	rcx, rbx
	cmovp	rcx, qword [rsp]

positive: cmovpe instruction

	cmovpe	cx, bx
	cmovpe	cx, word [rsp]
	cmovpe	ecx, ebx
	cmovpe	ecx, dword [rsp]
	cmovpe	rcx, rbx
	cmovpe	rcx, qword [rsp]

positive: cmovnp instruction

	cmovnp	cx, bx
	cmovnp	cx, word [rsp]
	cmovnp	ecx, ebx
	cmovnp	ecx, dword [rsp]
	cmovnp	rcx, rbx
	cmovnp	rcx, qword [rsp]

positive: cmovpo instruction

	cmovpo	cx, bx
	cmovpo	cx, word [rsp]
	cmovpo	ecx, ebx
	cmovpo	ecx, dword [rsp]
	cmovpo	rcx, rbx
	cmovpo	rcx, qword [rsp]

positive: cmovl instruction

	cmovl	cx, bx
	cmovl	cx, word [rsp]
	cmovl	ecx, ebx
	cmovl	ecx, dword [rsp]
	cmovl	rcx, rbx
	cmovl	rcx, qword [rsp]

positive: cmovnge instruction

	cmovnge	cx, bx
	cmovnge	cx, word [rsp]
	cmovnge	ecx, ebx
	cmovnge	ecx, dword [rsp]
	cmovnge	rcx, rbx
	cmovnge	rcx, qword [rsp]

positive: cmovnl instruction

	cmovnl	cx, bx
	cmovnl	cx, word [rsp]
	cmovnl	ecx, ebx
	cmovnl	ecx, dword [rsp]
	cmovnl	rcx, rbx
	cmovnl	rcx, qword [rsp]

positive: cmovge instruction

	cmovge	cx, bx
	cmovge	cx, word [rsp]
	cmovge	ecx, ebx
	cmovge	ecx, dword [rsp]
	cmovge	rcx, rbx
	cmovge	rcx, qword [rsp]

positive: cmovle instruction

	cmovle	cx, bx
	cmovle	cx, word [rsp]
	cmovle	ecx, ebx
	cmovle	ecx, dword [rsp]
	cmovle	rcx, rbx
	cmovle	rcx, qword [rsp]

positive: cmovng instruction

	cmovng	cx, bx
	cmovng	cx, word [rsp]
	cmovng	ecx, ebx
	cmovng	ecx, dword [rsp]
	cmovng	rcx, rbx
	cmovng	rcx, qword [rsp]

positive: cmovnle instruction

	cmovnle	cx, bx
	cmovnle	cx, word [rsp]
	cmovnle	ecx, ebx
	cmovnle	ecx, dword [rsp]
	cmovnle	rcx, rbx
	cmovnle	rcx, qword [rsp]

positive: cmovg instruction

	cmovg	cx, bx
	cmovg	cx, word [rsp]
	cmovg	ecx, ebx
	cmovg	ecx, dword [rsp]
	cmovg	rcx, rbx
	cmovg	rcx, qword [rsp]

positive: cmp instruction

	cmp	al, byte 0
	cmp	al, byte 255
	cmp	ax, word 0
	cmp	ax, word 65535
	cmp	eax, dword 0
	cmp	eax, dword 4294967295
	cmp	rax, dword -2147483648
	cmp	rax, dword 2147483647
	cmp	bl, byte 0
	cmp	byte [rsp], byte 255
	cmp	bx, word 0
	cmp	word [rsp], word 65535
	cmp	ebx, dword 0
	cmp	dword [rsp], dword 4294967295
	cmp	rbx, dword -2147483648
	cmp	qword [rsp], dword 2147483647
	cmp	bx, byte -128
	cmp	word [rsp], byte 127
	cmp	ebx, byte -128
	cmp	dword [rsp], byte 127
	cmp	rbx, byte -128
	cmp	qword [rsp], byte 127
	cmp	bl, cl
	cmp	byte [rsp], cl
	cmp	bx, cx
	cmp	word [rsp], cx
	cmp	ebx, ecx
	cmp	dword [rsp], ecx
	cmp	rbx, rcx
	cmp	qword [rsp], rcx
	cmp	cl, bl
	cmp	cl, byte [rsp]
	cmp	cx, bx
	cmp	cx, word [rsp]
	cmp	ecx, ebx
	cmp	ecx, dword [rsp]
	cmp	rcx, rbx
	cmp	rcx, qword [rsp]

positive: cmpsb instruction

	cmpsb
	rep cmpsb
	repne cmpsb

positive: cmpsw instruction

	cmpsw
	rep cmpsw
	repne cmpsw

positive: cmpsd instruction

	cmpsd
	rep cmpsd
	repne cmpsd
	cmpsd	xmm0, xmm1, 0
	cmpsd	xmm0, qword [rsp], 7

positive: cmpsq instruction

	cmpsq
	rep cmpsq
	repne cmpsq

positive: cmpxchg instruction

	cmpxchg	bl, cl
	cmpxchg	byte [rsp], cl
	cmpxchg	bx, cx
	cmpxchg	word [rsp], cx
	cmpxchg	ebx, ecx
	cmpxchg	dword [rsp], ecx
	cmpxchg	rbx, rcx
	cmpxchg	qword [rsp], rcx
	lock cmpxchg	byte [rsp], cl
	lock cmpxchg	word [rsp], cx
	lock cmpxchg	dword [rsp], ecx
	lock cmpxchg	qword [rsp], rcx

positive: cmpxchg8b instruction

	cmpxchg8b	[rsp]
	lock cmpxchg8b	[rsp]

positive: cmpxchg16b instruction

	cmpxchg16b	[rsp]
	lock cmpxchg16b	[rsp]

positive: cpuid instruction

	cpuid

positive: crc32 instruction

	crc32	ebx, cl
	crc32	ebx, byte [rsp]
	crc32	ebx, cx
	crc32	ebx, word [rsp]
	crc32	ebx, ecx
	crc32	ebx, dword [rsp]
	crc32	rbx, cl
	crc32	rbx, byte [rsp]
	crc32	rbx, rcx
	crc32	rbx, qword [rsp]

positive: daa instruction

	.bitmode	32
	daa

positive: das instruction

	.bitmode	32
	das

positive: dec instruction

	dec	bl
	dec	byte [rsp]
	dec	bx
	dec	word [rsp]
	dec	ebx
	dec	dword [rsp]
	dec	rbx
	dec	qword [rsp]
	dec	cl
	dec	cx
	dec	ecx
	dec	rcx
	lock dec	byte [rsp]
	lock dec	word [rsp]
	lock dec	dword [rsp]
	lock dec	qword [rsp]

positive: div instruction

	div	bl
	div	byte [rsp]
	div	bx
	div	word [rsp]
	div	ebx
	div	dword [rsp]
	div	rbx
	div	qword [rsp]

positive: enter instruction

	enter	word 0, byte 0
	enter	word 32767, byte 255

positive: idiv instruction

	idiv	bl
	idiv	byte [rsp]
	idiv	bx
	idiv	word [rsp]
	idiv	ebx
	idiv	dword [rsp]
	idiv	rbx
	idiv	qword [rsp]

positive: imul instruction

	imul	bl
	imul	byte [rsp]
	imul	bx
	imul	word [rsp]
	imul	ebx
	imul	dword [rsp]
	imul	rbx
	imul	qword [rsp]
	imul	cx, bx
	imul	cx, word [rsp]
	imul	ecx, ebx
	imul	ecx, dword [rsp]
	imul	rcx, rbx
	imul	rcx, qword [rsp]
	imul	cx, bx, byte -128
	imul	cx, word [rsp], byte 127
	imul	ecx, ebx, byte -128
	imul	ecx, dword [rsp], byte 127
	imul	rcx, rbx, byte -128
	imul	rcx, qword [rsp], byte 127
	imul	cx, bx, word -32728
	imul	cx, word [rsp], word 32767
	imul	ecx, ebx, dword -2147483648
	imul	ecx, dword [rsp], dword 2147483647
	imul	rcx, rbx, dword -2147483648
	imul	rcx, qword [rsp], dword 2147483647

positive: in instruction

	in	al, byte 0
	in	al, byte 255
	in	ax, byte 0
	in	ax, byte 255
	in	eax, byte 0
	in	eax, byte 255
	in	al, dx
	in	ax, dx
	in	eax, dx

positive: inc instruction

	inc	bl
	inc	byte [rsp]
	inc	bx
	inc	word [rsp]
	inc	ebx
	inc	dword [rsp]
	inc	rbx
	inc	qword [rsp]
	inc	cl
	inc	cx
	inc	ecx
	inc	rcx
	lock inc	byte [rsp]
	lock inc	word [rsp]
	lock inc	dword [rsp]
	lock inc	qword [rsp]

positive: insb instruction

	insb
	rep insb

positive: insw instruction

	insw
	rep insw

positive: insd instruction

	insd
	rep insd

positive: int instruction

	int	byte 0
	int	byte 255
	int	3

positive: into instruction

	.bitmode	32
	into

positive: jo instruction

	jo	byte -128
	jo	byte 127
	jo	word -32768
	jo	word 32767
	jo	dword -2147483648
	jo	dword 2147483647

positive: jno instruction

	jno	byte -128
	jno	byte 127
	jno	word -32768
	jno	word 32767
	jno	dword -2147483648
	jno	dword 2147483647

positive: jb instruction

	jb	byte -128
	jb	byte 127
	jb	word -32768
	jb	word 32767
	jb	dword -2147483648
	jb	dword 2147483647

positive: jc instruction

	jc	byte -128
	jc	byte 127
	jc	word -32768
	jc	word 32767
	jc	dword -2147483648
	jc	dword 2147483647

positive: jnae instruction

	jnae	byte -128
	jnae	byte 127
	jnae	word -32768
	jnae	word 32767
	jnae	dword -2147483648
	jnae	dword 2147483647

positive: jnb instruction

	jnb	byte -128
	jnb	byte 127
	jnb	word -32768
	jnb	word 32767
	jnb	dword -2147483648
	jnb	dword 2147483647

positive: jnc instruction

	jnc	byte -128
	jnc	byte 127
	jnc	word -32768
	jnc	word 32767
	jnc	dword -2147483648
	jnc	dword 2147483647

positive: jae instruction

	jae	byte -128
	jae	byte 127
	jae	word -32768
	jae	word 32767
	jae	dword -2147483648
	jae	dword 2147483647

positive: jz instruction

	jz	byte -128
	jz	byte 127
	jz	word -32768
	jz	word 32767
	jz	dword -2147483648
	jz	dword 2147483647

positive: je instruction

	je	byte -128
	je	byte 127
	je	word -32768
	je	word 32767
	je	dword -2147483648
	je	dword 2147483647

positive: jnz instruction

	jnz	byte -128
	jnz	byte 127
	jnz	word -32768
	jnz	word 32767
	jnz	dword -2147483648
	jnz	dword 2147483647

positive: jne instruction

	jne	byte -128
	jne	byte 127
	jne	word -32768
	jne	word 32767
	jne	dword -2147483648
	jne	dword 2147483647

positive: jbe instruction

	jbe	byte -128
	jbe	byte 127
	jbe	word -32768
	jbe	word 32767
	jbe	dword -2147483648
	jbe	dword 2147483647

positive: jna instruction

	jna	byte -128
	jna	byte 127
	jna	word -32768
	jna	word 32767
	jna	dword -2147483648
	jna	dword 2147483647

positive: jnbe instruction

	jnbe	byte -128
	jnbe	byte 127
	jnbe	word -32768
	jnbe	word 32767
	jnbe	dword -2147483648
	jnbe	dword 2147483647

positive: ja instruction

	ja	byte -128
	ja	byte 127
	ja	word -32768
	ja	word 32767
	ja	dword -2147483648
	ja	dword 2147483647

positive: js instruction

	js	byte -128
	js	byte 127
	js	word -32768
	js	word 32767
	js	dword -2147483648
	js	dword 2147483647

positive: jns instruction

	jns	byte -128
	jns	byte 127
	jns	word -32768
	jns	word 32767
	jns	dword -2147483648
	jns	dword 2147483647

positive: jp instruction

	jp	byte -128
	jp	byte 127
	jp	word -32768
	jp	word 32767
	jp	dword -2147483648
	jp	dword 2147483647

positive: jpe instruction

	jpe	byte -128
	jpe	byte 127
	jpe	word -32768
	jpe	word 32767
	jpe	dword -2147483648
	jpe	dword 2147483647

positive: jnp instruction

	jnp	byte -128
	jnp	byte 127
	jnp	word -32768
	jnp	word 32767
	jnp	dword -2147483648
	jnp	dword 2147483647

positive: jpo instruction

	jpo	byte -128
	jpo	byte 127
	jpo	word -32768
	jpo	word 32767
	jpo	dword -2147483648
	jpo	dword 2147483647

positive: jl instruction

	jl	byte -128
	jl	byte 127
	jl	word -32768
	jl	word 32767
	jl	dword -2147483648
	jl	dword 2147483647

positive: jnge instruction

	jnge	byte -128
	jnge	byte 127
	jnge	word -32768
	jnge	word 32767
	jnge	dword -2147483648
	jnge	dword 2147483647

positive: jnl instruction

	jnl	byte -128
	jnl	byte 127
	jnl	word -32768
	jnl	word 32767
	jnl	dword -2147483648
	jnl	dword 2147483647

positive: jge instruction

	jge	byte -128
	jge	byte 127
	jge	word -32768
	jge	word 32767
	jge	dword -2147483648
	jge	dword 2147483647

positive: jle instruction

	jle	byte -128
	jle	byte 127
	jle	word -32768
	jle	word 32767
	jle	dword -2147483648
	jle	dword 2147483647

positive: jng instruction

	jng	byte -128
	jng	byte 127
	jng	word -32768
	jng	word 32767
	jng	dword -2147483648
	jng	dword 2147483647

positive: jnle instruction

	jnle	byte -128
	jnle	byte 127
	jnle	word -32768
	jnle	word 32767
	jnle	dword -2147483648
	jnle	dword 2147483647

positive: jg instruction

	jg	byte -128
	jg	byte 127
	jg	word -32768
	jg	word 32767
	jg	dword -2147483648
	jg	dword 2147483647

positive: jcxz instruction

	.bitmode	32
	jcxz	byte -128
	jcxz	byte 127

positive: jecxz instruction

	jecxz	byte -128
	jecxz	byte 127

positive: jrcxz instruction

	jrcxz	byte -128
	jrcxz	byte 127

positive: jmp instruction

	jmp	word -32768
	jmp	word 32767
	jmp	dword -2147483648
	jmp	dword 2147483647
	jmp	bx
	jmp	word [rsp]
	jmp	rbx
	jmp	qword [rsp]
	.bitmode	32
	jmp	ebx
	jmp	dword [esp]

positive: jmpfar instruction

	jmpfar	word [rsp]
	jmpfar	dword [rsp]
	.bitmode	32
	jmpfar	word 0, word -32768
	jmpfar	word 65335, word 32767
	jmpfar	word 0, dword -2147483648
	jmpfar	word 65335, dword 2147483647

positive: lahf instruction

	lahf

positive: lds instruction

	.bitmode	32
	lds	cx, [esp]
	lds	ecx, [esp]

positive: les instruction

	.bitmode	32
	les	cx, [esp]
	les	ecx, [esp]

positive: lfs instruction

	lfs	cx, [rsp]
	lfs	ecx, [rsp]

positive: lgs instruction

	lgs	cx, [rsp]
	lgs	ecx, [rsp]

positive: lss instruction

	lss	cx, [rsp]
	lss	ecx, [rsp]

positive: lea instruction

	lea	cx, [rsp]
	lea	ecx, [rsp]
	lea	rcx, [rsp]

positive: leave instruction

	leave

positive: lfence instruction

	lfence

positive: llwpcb instruction

	llwpcb	eax
	llwpcb	rax

positive: lodsb instruction

	lodsb
	rep lodsb

positive: lodsw instruction

	lodsw
	rep lodsw

positive: lodsd instruction

	lodsd
	rep lodsd

positive: lodsq instruction

	lodsq
	rep lodsq

positive: loop instruction

	loop	byte -128
	loop	byte 127

positive: loope instruction

	loope	byte -128
	loope	byte 127

positive: loopne instruction

	loopne	byte -128
	loopne	byte 127

positive: loopnz instruction

	loopnz	byte -128
	loopnz	byte 127

positive: loopz instruction

	loopz	byte -128
	loopz	byte 127

positive: lwpins instruction

	lwpins	eax, ebx, 0
	lwpins	eax, dword [rsp], 4294967295
	lwpins	rax, ebx, 0
	lwpins	rax, dword [rsp], 4294967295

positive: lwpval instruction

	lwpval	eax, ebx, 0
	lwpval	eax, dword [rsp], 4294967295
	lwpval	rax, ebx, 0
	lwpval	rax, dword [rsp], 4294967295

positive: lzcnt instruction

	lzcnt	cx, bx
	lzcnt	cx, word [rsp]
	lzcnt	ecx, ebx
	lzcnt	ecx, dword [rsp]
	lzcnt	rcx, rbx
	lzcnt	rcx, qword [rsp]

positive: mcommit instruction

	mcommit

positive: mfence instruction

	mfence

positive: mov instruction

	mov	bl, cl
	mov	byte [rsp], cl
	mov	bx, cx
	mov	word [rsp], cx
	mov	ebx, ecx
	mov	dword [rsp], ecx
	mov	rbx, rcx
	mov	qword [rsp], rcx
	mov	cl, bl
	mov	cl, byte [rsp]
	mov	cx, bx
	mov	cx, word [rsp]
	mov	ecx, ebx
	mov	ecx, dword [rsp]
	mov	rcx, rbx
	mov	rcx, qword [rsp]
	mov	bx, fs
	mov	word [rsp], fs
	mov	ebx, fs
	mov	dword [rsp], fs
	mov	rbx, fs
	mov	qword [rsp], fs
	mov	fs, bx
	mov	fs, word [rsp]
	mov	al, byte [0]
	mov	ax, word [0]
	mov	eax, dword [0]
	mov	rax, qword [0]
	mov	byte [0], al
	mov	word [0], ax
	mov	dword [0], eax
	mov	qword [0], rax
	mov	cl, byte 0
	mov	cl, byte 255
	mov	cx, word 0
	mov	cx, word 65535
	mov	ecx, dword 0
	mov	ecx, dword 4294967295
	mov	rcx, qword 0
	mov	rcx, qword 18446744073709551615
	mov	bl, byte 0
	mov	byte [rsp], byte 255
	mov	bx, word 0
	mov	word [rsp], word 65535
	mov	ebx, dword 0
	mov	dword [rsp], dword 4294967295
	mov	rbx, dword -2147483648
	mov	qword [rsp], dword 2147483647
	mov	cr0, rcx
	mov	rcx, cr0
	mov	cr8, rcx
	mov	rcx, cr8
	mov	dr0, rcx
	mov	rcx, dr0
	.bitmode	32
	mov	cr0, ecx
	mov	ecx, cr0
	mov	cr8, ecx
	mov	ecx, cr8
	mov	dr0, ecx
	mov	ecx, dr0

positive: movbe instruction

	movbe	bx, word [rsp]
	movbe	ebx, dword [rsp]
	movbe	rbx, qword [rsp]
	movbe	word [rsp], cx
	movbe	dword [rsp], ecx
	movbe	qword [rsp], rcx

positive: movd instruction

	movd	xmm0, ebx
	movd	xmm0, dword [rsp]
	movd	xmm0, rbx
	movd	xmm0, qword [rsp]
	movd	ebx, xmm0
	movd	dword [rsp], xmm0
	movd	rbx, xmm0
	movd	qword [rsp], xmm0
	movd	mmx0, ebx
	movd	mmx0, dword [rsp]
	movd	mmx0, rbx
	movd	mmx0, qword [rsp]
	movd	ebx, mmx0
	movd	dword [rsp], mmx0
	movd	rbx, mmx0
	movd	qword [rsp], mmx0

positive: vmovd instruction

	vmovd	xmm0, ebx
	vmovd	xmm0, dword [rsp]
	vmovd	ebx, xmm0
	vmovd	dword [rsp], xmm0

positive: movmskpd instruction

	movmskpd	ecx, xmm0
	movmskpd	rcx, xmm0

positive: vmovmskpd instruction

	vmovmskpd	ecx, xmm0
	vmovmskpd	rcx, xmm0

positive: movmskps instruction

	movmskps	ecx, xmm0
	movmskps	rcx, xmm0

positive: vmovmskps instruction

	vmovmskps	ecx, xmm0
	vmovmskps	rcx, xmm0

positive: movnti instruction

	movnti	dword [rsp], ecx
	movnti	qword [rsp], rcx

positive: movsb instruction

	movsb
	rep movsb

positive: movsw instruction

	movsw
	rep movsw

positive: movsd instruction

	movsd
	rep movsd
	movsd	xmm0, xmm1
	movsd	xmm0, qword [rsp]
	movsd	xmm1, xmm0
	movsd	qword [rsp], xmm0

positive: vmovsd instruction

	vmovsd	xmm0, qword [rsp]
	vmovsd	qword [rsp], xmm0
	vmovsd	xmm0, xmm1, xmm2

positive: movsq instruction

	movsq
	rep movsq

positive: movsx instruction

	movsx	cx, bl
	movsx	cx, byte [rsp]
	movsx	ecx, bl
	movsx	ecx, byte [rsp]
	movsx	rcx, bl
	movsx	rcx, byte [rsp]
	movsx	ecx, bx
	movsx	ecx, word [rsp]
	movsx	rcx, bx
	movsx	rcx, word [rsp]

positive: movsxd instruction

	movsxd	rcx, ebx
	movsxd	rcx, dword [rsp]

positive: movzx instruction

	movzx	cx, bl
	movzx	cx, byte [rsp]
	movzx	ecx, bl
	movzx	ecx, byte [rsp]
	movzx	rcx, bl
	movzx	rcx, byte [rsp]
	movzx	ecx, bx
	movzx	ecx, word [rsp]
	movzx	rcx, bx
	movzx	rcx, word [rsp]

positive: mul instruction

	mul	bl
	mul	byte [rsp]
	mul	bx
	mul	word [rsp]
	mul	ebx
	mul	dword [rsp]
	mul	rbx
	mul	qword [rsp]

positive: mulx instruction

	mulx	ebx, ecx, edx
	mulx	ebx, ecx, dword [rsp]
	mulx	rbx, rcx, rdx
	mulx	rbx, rcx, qword [rsp]

positive: neg instruction

	neg	bl
	neg	byte [rsp]
	neg	bx
	neg	word [rsp]
	neg	ebx
	neg	dword [rsp]
	neg	rbx
	neg	qword [rsp]
	lock neg	byte [rsp]
	lock neg	word [rsp]
	lock neg	dword [rsp]
	lock neg	qword [rsp]

positive: nop instruction

	nop
	nop	bx
	nop	word [rsp]
	nop	ebx
	nop	dword [rsp]
	nop	rbx
	nop	qword [rsp]

positive: not instruction

	not	bl
	not	byte [rsp]
	not	bx
	not	word [rsp]
	not	ebx
	not	dword [rsp]
	not	rbx
	not	qword [rsp]
	lock not	byte [rsp]
	lock not	word [rsp]
	lock not	dword [rsp]
	lock not	qword [rsp]

positive: or instruction

	or	al, byte 0
	or	al, byte 255
	or	ax, word 0
	or	ax, word 65535
	or	eax, dword 0
	or	eax, dword 4294967295
	or	rax, dword -2147483648
	or	rax, dword 2147483647
	or	bl, byte 0
	or	byte [rsp], byte 255
	or	bx, word 0
	or	word [rsp], word 65535
	or	ebx, dword 0
	or	dword [rsp], dword 4294967295
	or	rbx, dword -2147483648
	or	qword [rsp], dword 2147483647
	or	bx, byte -128
	or	word [rsp], byte 127
	or	ebx, byte -128
	or	dword [rsp], byte 127
	or	rbx, byte -128
	or	qword [rsp], byte 127
	or	bl, cl
	or	byte [rsp], cl
	or	bx, cx
	or	word [rsp], cx
	or	ebx, ecx
	or	dword [rsp], ecx
	or	rbx, rcx
	or	qword [rsp], rcx
	or	cl, bl
	or	cl, byte [rsp]
	or	cx, bx
	or	cx, word [rsp]
	or	ecx, ebx
	or	ecx, dword [rsp]
	or	rcx, rbx
	or	rcx, qword [rsp]
	lock or	byte [rsp], byte 255
	lock or	word [rsp], word 65535
	lock or	dword [rsp], dword 4294967295
	lock or	qword [rsp], dword 2147483647
	lock or	word [rsp], byte 127
	lock or	dword [rsp], byte 127
	lock or	qword [rsp], byte 127
	lock or	byte [rsp], cl
	lock or	word [rsp], cx
	lock or	dword [rsp], ecx
	lock or	qword [rsp], rcx

positive: out instruction

	out	byte 0, al
	out	byte 255, al
	out	byte 0, ax
	out	byte 255, ax
	out	byte 0, eax
	out	byte 255, eax
	out	dx, al
	out	dx, ax
	out	dx, eax

positive: outsb instruction

	outsb
	rep outsb

positive: outsw instruction

	outsw
	rep outsw

positive: outsd instruction

	outsd
	rep outsd

positive: pause instruction

	pause

positive: pdep instruction

	pdep	ebx, ecx, edx
	pdep	ebx, ecx, dword [rsp]
	pdep	rbx, rcx, rdx
	pdep	rbx, rcx, qword [rsp]

positive: pext instruction

	pext	ebx, ecx, edx
	pext	ebx, ecx, dword [rsp]
	pext	rbx, rcx, rdx
	pext	rbx, rcx, qword [rsp]

positive: pop instruction

	pop	bx
	pop	word [rsp]
	pop	rbx
	pop	qword [rsp]
	pop	cx
	pop	rcx
	pop	fs
	pop	gs
	.bitmode	32
	pop	ebx
	pop	dword [esp]
	pop	ecx
	pop	ds
	pop	es
	pop	ss

positive: popa instruction

	.bitmode	32
	popa

positive: popad instruction

	.bitmode	32
	popad

positive: popcnt instruction

	popcnt	cx, bx
	popcnt	cx, word [rsp]
	popcnt	ecx, ebx
	popcnt	ecx, dword [rsp]
	popcnt	rcx, rbx
	popcnt	rcx, qword [rsp]

positive: popf instruction

	popf

positive: popfd instruction

	.bitmode	32
	popfd

positive: popfq instruction

	popfq

positive: prefetch instruction

	prefetch	[rsp]

positive: prefetchw instruction

	prefetchw	[rsp]

positive: prefetchnta instruction

	prefetchnta	[rsp]

positive: prefetcht0 instruction

	prefetcht0	[rsp]

positive: prefetcht1 instruction

	prefetcht1	[rsp]

positive: prefetcht2 instruction

	prefetcht2	[rsp]

positive: push instruction

	push	bx
	push	word [rsp]
	push	rbx
	push	qword [rsp]
	push	cx
	push	rcx
	push	fs
	push	gs
	.bitmode	32
	push	ebx
	push	dword [esp]
	push	ecx
	push	ds
	push	es
	push	ss

positive: pusha instruction

	.bitmode	32
	pusha

positive: pushad instruction

	.bitmode	32
	pushad

positive: pushf instruction

	pushf

positive: pushfd instruction

	.bitmode	32
	pushfd

positive: pushfq instruction

	pushfq

positive: rcl instruction

	rcl	bl, 1
	rcl	byte [rsp], 1
	rcl	bl, cl
	rcl	byte [rsp], cl
	rcl	bl, byte 0
	rcl	byte [rsp], byte 255
	rcl	bx, 1
	rcl	word [rsp], 1
	rcl	bx, cl
	rcl	word [rsp], cl
	rcl	bx, byte 0
	rcl	word [rsp], byte 255
	rcl	ebx, 1
	rcl	dword [rsp], 1
	rcl	ebx, cl
	rcl	dword [rsp], cl
	rcl	ebx, byte 0
	rcl	dword [rsp], byte 255
	rcl	rbx, 1
	rcl	qword [rsp], 1
	rcl	rbx, cl
	rcl	qword [rsp], cl
	rcl	rbx, byte 0
	rcl	qword [rsp], byte 255

positive: rcr instruction

	rcr	bl, 1
	rcr	byte [rsp], 1
	rcr	bl, cl
	rcr	byte [rsp], cl
	rcr	bl, byte 0
	rcr	byte [rsp], byte 255
	rcr	bx, 1
	rcr	word [rsp], 1
	rcr	bx, cl
	rcr	word [rsp], cl
	rcr	bx, byte 0
	rcr	word [rsp], byte 255
	rcr	ebx, 1
	rcr	dword [rsp], 1
	rcr	ebx, cl
	rcr	dword [rsp], cl
	rcr	ebx, byte 0
	rcr	dword [rsp], byte 255
	rcr	rbx, 1
	rcr	qword [rsp], 1
	rcr	rbx, cl
	rcr	qword [rsp], cl
	rcr	rbx, byte 0
	rcr	qword [rsp], byte 255

positive: rdfsbase instruction

	rdfsbase	ebx
	rdfsbase	rbx

positive: rdgsbase instruction

	rdgsbase	ebx
	rdgsbase	rbx

positive: rdpid instruction

	rdpid	rax

positive: rdpru instruction

	rdpru

positive: rdrand instruction

	rdrand	bx
	rdrand	ebx
	rdrand	rbx

positive: rdseed instruction

	rdseed	bx
	rdseed	ebx
	rdseed	rbx

positive: ret instruction

	ret
	ret	word 0
	ret	word 65535

positive: retf instruction

	retf
	retf	word 0
	retf	word 65535

positive: rol instruction

	rol	bl, 1
	rol	byte [rsp], 1
	rol	bl, cl
	rol	byte [rsp], cl
	rol	bl, byte 0
	rol	byte [rsp], byte 255
	rol	bx, 1
	rol	word [rsp], 1
	rol	bx, cl
	rol	word [rsp], cl
	rol	bx, byte 0
	rol	word [rsp], byte 255
	rol	ebx, 1
	rol	dword [rsp], 1
	rol	ebx, cl
	rol	dword [rsp], cl
	rol	ebx, byte 0
	rol	dword [rsp], byte 255
	rol	rbx, 1
	rol	qword [rsp], 1
	rol	rbx, cl
	rol	qword [rsp], cl
	rol	rbx, byte 0
	rol	qword [rsp], byte 255

positive: ror instruction

	ror	bl, 1
	ror	byte [rsp], 1
	ror	bl, cl
	ror	byte [rsp], cl
	ror	bl, byte 0
	ror	byte [rsp], byte 255
	ror	bx, 1
	ror	word [rsp], 1
	ror	bx, cl
	ror	word [rsp], cl
	ror	bx, byte 0
	ror	word [rsp], byte 255
	ror	ebx, 1
	ror	dword [rsp], 1
	ror	ebx, cl
	ror	dword [rsp], cl
	ror	ebx, byte 0
	ror	dword [rsp], byte 255
	ror	rbx, 1
	ror	qword [rsp], 1
	ror	rbx, cl
	ror	qword [rsp], cl
	ror	rbx, byte 0
	ror	qword [rsp], byte 255

positive: rorx instruction

	rorx	ebx, ecx, byte 0
	rorx	ebx, dword [rsp], byte 255
	rorx	rbx, rcx, byte 0
	rorx	rbx, qword [rsp], byte 255

positive: sahf instruction

	sahf

positive: sal instruction

	sal	bl, 1
	sal	byte [rsp], 1
	sal	bl, cl
	sal	byte [rsp], cl
	sal	bl, byte 0
	sal	byte [rsp], byte 255
	sal	bx, 1
	sal	word [rsp], 1
	sal	bx, cl
	sal	word [rsp], cl
	sal	bx, byte 0
	sal	word [rsp], byte 255
	sal	ebx, 1
	sal	dword [rsp], 1
	sal	ebx, cl
	sal	dword [rsp], cl
	sal	ebx, byte 0
	sal	dword [rsp], byte 255
	sal	rbx, 1
	sal	qword [rsp], 1
	sal	rbx, cl
	sal	qword [rsp], cl
	sal	rbx, byte 0
	sal	qword [rsp], byte 255

positive: sar instruction

	sar	bl, 1
	sar	byte [rsp], 1
	sar	bl, cl
	sar	byte [rsp], cl
	sar	bl, byte 0
	sar	byte [rsp], byte 255
	sar	bx, 1
	sar	word [rsp], 1
	sar	bx, cl
	sar	word [rsp], cl
	sar	bx, byte 0
	sar	word [rsp], byte 255
	sar	ebx, 1
	sar	dword [rsp], 1
	sar	ebx, cl
	sar	dword [rsp], cl
	sar	ebx, byte 0
	sar	dword [rsp], byte 255
	sar	rbx, 1
	sar	qword [rsp], 1
	sar	rbx, cl
	sar	qword [rsp], cl
	sar	rbx, byte 0
	sar	qword [rsp], byte 255

positive: sarx instruction

	sarx	ebx, ecx, edx
	sarx	ebx, dword [rsp], edx
	sarx	rbx, rcx, rdx
	sarx	rbx, qword [rsp], rdx

positive: sbb instruction

	sbb	al, byte 0
	sbb	al, byte 255
	sbb	ax, word 0
	sbb	ax, word 65535
	sbb	eax, dword 0
	sbb	eax, dword 4294967295
	sbb	rax, dword -2147483648
	sbb	rax, dword 2147483647
	sbb	bl, byte 0
	sbb	byte [rsp], byte 255
	sbb	bx, word 0
	sbb	word [rsp], word 65535
	sbb	ebx, dword 0
	sbb	dword [rsp], dword 4294967295
	sbb	rbx, dword -2147483648
	sbb	qword [rsp], dword 2147483647
	sbb	bx, byte -128
	sbb	word [rsp], byte 127
	sbb	ebx, byte -128
	sbb	dword [rsp], byte 127
	sbb	rbx, byte -128
	sbb	qword [rsp], byte 127
	sbb	bl, cl
	sbb	byte [rsp], cl
	sbb	bx, cx
	sbb	word [rsp], cx
	sbb	ebx, ecx
	sbb	dword [rsp], ecx
	sbb	rbx, rcx
	sbb	qword [rsp], rcx
	sbb	cl, bl
	sbb	cl, byte [rsp]
	sbb	cx, bx
	sbb	cx, word [rsp]
	sbb	ecx, ebx
	sbb	ecx, dword [rsp]
	sbb	rcx, rbx
	sbb	rcx, qword [rsp]
	lock sbb	byte [rsp], byte 255
	lock sbb	word [rsp], word 65535
	lock sbb	dword [rsp], dword 4294967295
	lock sbb	qword [rsp], dword 2147483647
	lock sbb	word [rsp], byte 127
	lock sbb	dword [rsp], byte 127
	lock sbb	qword [rsp], byte 127
	lock sbb	byte [rsp], cl
	lock sbb	word [rsp], cx
	lock sbb	dword [rsp], ecx
	lock sbb	qword [rsp], rcx

positive: scasb instruction

	scasb
	rep scasb
	repne scasb

positive: scasw instruction

	scasw
	rep scasw
	repne scasw

positive: scasd instruction

	scasd
	rep scasd
	repne scasd

positive: scasq instruction

	scasq
	rep scasq
	repne scasq

positive: seto instruction

	seto	bl
	seto	byte [rsp]

positive: setno instruction

	setno	bl
	setno	byte [rsp]

positive: setb instruction

	setb	bl
	setb	byte [rsp]

positive: setc instruction

	setc	bl
	setc	byte [rsp]

positive: setnae instruction

	setnae	bl
	setnae	byte [rsp]

positive: setnb instruction

	setnb	bl
	setnb	byte [rsp]

positive: setnc instruction

	setnc	bl
	setnc	byte [rsp]

positive: setae instruction

	setae	bl
	setae	byte [rsp]

positive: setz instruction

	setz	bl
	setz	byte [rsp]

positive: sete instruction

	sete	bl
	sete	byte [rsp]

positive: setnz instruction

	setnz	bl
	setnz	byte [rsp]

positive: setne instruction

	setne	bl
	setne	byte [rsp]

positive: setbe instruction

	setbe	bl
	setbe	byte [rsp]

positive: setna instruction

	setna	bl
	setna	byte [rsp]

positive: setnbe instruction

	setnbe	bl
	setnbe	byte [rsp]

positive: seta instruction

	seta	bl
	seta	byte [rsp]

positive: sets instruction

	sets	bl
	sets	byte [rsp]

positive: setns instruction

	setns	bl
	setns	byte [rsp]

positive: setp instruction

	setp	bl
	setp	byte [rsp]

positive: setpe instruction

	setpe	bl
	setpe	byte [rsp]

positive: setnp instruction

	setnp	bl
	setnp	byte [rsp]

positive: setpo instruction

	setpo	bl
	setpo	byte [rsp]

positive: setl instruction

	setl	bl
	setl	byte [rsp]

positive: setnge instruction

	setnge	bl
	setnge	byte [rsp]

positive: setnl instruction

	setnl	bl
	setnl	byte [rsp]

positive: setge instruction

	setge	bl
	setge	byte [rsp]

positive: setle instruction

	setle	bl
	setle	byte [rsp]

positive: setng instruction

	setng	bl
	setng	byte [rsp]

positive: setnle instruction

	setnle	bl
	setnle	byte [rsp]

positive: setg instruction

	setg	bl
	setg	byte [rsp]

positive: sfence instruction

	sfence

positive: shl instruction

	shl	bl, 1
	shl	byte [rsp], 1
	shl	bl, cl
	shl	byte [rsp], cl
	shl	bl, byte 0
	shl	byte [rsp], byte 255
	shl	bx, 1
	shl	word [rsp], 1
	shl	bx, cl
	shl	word [rsp], cl
	shl	bx, byte 0
	shl	word [rsp], byte 255
	shl	ebx, 1
	shl	dword [rsp], 1
	shl	ebx, cl
	shl	dword [rsp], cl
	shl	ebx, byte 0
	shl	dword [rsp], byte 255
	shl	rbx, 1
	shl	qword [rsp], 1
	shl	rbx, cl
	shl	qword [rsp], cl
	shl	rbx, byte 0
	shl	qword [rsp], byte 255

positive: shld instruction

	shld	bx, cx, byte 0
	shld	word [rsp], cx, byte 255
	shld	bx, cx, cl
	shld	word [rsp], cx, cl
	shld	ebx, ecx, byte 0
	shld	dword [rsp], ecx, byte 255
	shld	ebx, ecx, cl
	shld	dword [rsp], ecx, cl
	shld	rbx, rcx, byte 0
	shld	qword [rsp], rcx, byte 255
	shld	rbx, rcx, cl
	shld	qword [rsp], rcx, cl

positive: shlx instruction

	shlx	ebx, ecx, edx
	shlx	ebx, dword [rsp], edx
	shlx	rbx, rcx, rdx
	shlx	rbx, qword [rsp], rdx

positive: shr instruction

	shr	bl, 1
	shr	byte [rsp], 1
	shr	bl, cl
	shr	byte [rsp], cl
	shr	bl, byte 0
	shr	byte [rsp], byte 255
	shr	bx, 1
	shr	word [rsp], 1
	shr	bx, cl
	shr	word [rsp], cl
	shr	bx, byte 0
	shr	word [rsp], byte 255
	shr	ebx, 1
	shr	dword [rsp], 1
	shr	ebx, cl
	shr	dword [rsp], cl
	shr	ebx, byte 0
	shr	dword [rsp], byte 255
	shr	rbx, 1
	shr	qword [rsp], 1
	shr	rbx, cl
	shr	qword [rsp], cl
	shr	rbx, byte 0
	shr	qword [rsp], byte 255

positive: shrd instruction

	shrd	bx, cx, byte 0
	shrd	word [rsp], cx, byte 255
	shrd	bx, cx, cl
	shrd	word [rsp], cx, cl
	shrd	ebx, ecx, byte 0
	shrd	dword [rsp], ecx, byte 255
	shrd	ebx, ecx, cl
	shrd	dword [rsp], ecx, cl
	shrd	rbx, rcx, byte 0
	shrd	qword [rsp], rcx, byte 255
	shrd	rbx, rcx, cl
	shrd	qword [rsp], rcx, cl

positive: shrx instruction

	shrx	ebx, ecx, edx
	shrx	ebx, dword [rsp], edx
	shrx	rbx, rcx, rdx
	shrx	rbx, qword [rsp], rdx

positive: slwpcb instruction

	slwpcb	eax
	slwpcb	rax

positive: stac instruction

	stac

positive: stc instruction

	stc

positive: std instruction

	std

positive: stosb instruction

	stosb
	rep stosb

positive: stosw instruction

	stosw
	rep stosw

positive: stosd instruction

	stosd
	rep stosd

positive: stosq instruction

	stosq
	rep stosq

positive: sub instruction

	sub	al, byte 0
	sub	al, byte 255
	sub	ax, word 0
	sub	ax, word 65535
	sub	eax, dword 0
	sub	eax, dword 4294967295
	sub	rax, dword -2147483648
	sub	rax, dword 2147483647
	sub	bl, byte 0
	sub	byte [rsp], byte 255
	sub	bx, word 0
	sub	word [rsp], word 65535
	sub	ebx, dword 0
	sub	dword [rsp], dword 4294967295
	sub	rbx, dword -2147483648
	sub	qword [rsp], dword 2147483647
	sub	bx, byte -128
	sub	word [rsp], byte 127
	sub	ebx, byte -128
	sub	dword [rsp], byte 127
	sub	rbx, byte -128
	sub	qword [rsp], byte 127
	sub	bl, cl
	sub	byte [rsp], cl
	sub	bx, cx
	sub	word [rsp], cx
	sub	ebx, ecx
	sub	dword [rsp], ecx
	sub	rbx, rcx
	sub	qword [rsp], rcx
	sub	cl, bl
	sub	cl, byte [rsp]
	sub	cx, bx
	sub	cx, word [rsp]
	sub	ecx, ebx
	sub	ecx, dword [rsp]
	sub	rcx, rbx
	sub	rcx, qword [rsp]
	lock sub	byte [rsp], byte 255
	lock sub	word [rsp], word 65535
	lock sub	dword [rsp], dword 4294967295
	lock sub	qword [rsp], dword 2147483647
	lock sub	word [rsp], byte 127
	lock sub	dword [rsp], byte 127
	lock sub	qword [rsp], byte 127
	lock sub	byte [rsp], cl
	lock sub	word [rsp], cx
	lock sub	dword [rsp], ecx
	lock sub	qword [rsp], rcx

positive: test instruction

	test	al, byte 0
	test	al, byte 255
	test	ax, word 0
	test	ax, word 65535
	test	eax, dword 0
	test	eax, dword 4294967295
	test	rax, dword -2147483648
	test	rax, dword 2147483647
	test	bl, byte 0
	test	byte [rsp], byte 255
	test	bx, word 0
	test	word [rsp], word 65535
	test	ebx, dword 0
	test	dword [rsp], dword 4294967295
	test	rbx, dword -2147483648
	test	qword [rsp], dword 2147483647
	test	bl, cl
	test	byte [rsp], cl
	test	bx, cx
	test	word [rsp], cx
	test	ebx, ecx
	test	dword [rsp], ecx
	test	rbx, rcx
	test	qword [rsp], rcx

positive: wrfsbase instruction

	wrfsbase	ebx
	wrfsbase	rbx

positive: wrgsbase instruction

	wrgsbase	ebx
	wrgsbase	rbx

positive: xadd instruction

	xadd	bl, cl
	xadd	byte [rsp], cl
	xadd	bx, cx
	xadd	word [rsp], cx
	xadd	ebx, ecx
	xadd	dword [rsp], ecx
	xadd	rbx, rcx
	xadd	qword [rsp], rcx
	lock xadd	byte [rsp], cl
	lock xadd	word [rsp], cx
	lock xadd	dword [rsp], ecx
	lock xadd	qword [rsp], rcx

positive: xchg instruction

	xchg	ax, cx
	xchg	cx, ax
	xchg	eax, ecx
	xchg	ecx, eax
	xchg	rax, rcx
	xchg	rcx, rax
	xchg	bx, cx
	xchg	word [rsp], cx
	xchg	cx, bx
	xchg	cx, word [rsp]
	xchg	ebx, ecx
	xchg	dword [rsp], ecx
	xchg	ecx, ebx
	xchg	ecx, dword [rsp]
	xchg	rbx, rcx
	xchg	qword [rsp], rcx
	xchg	rcx, rbx
	xchg	rcx, qword [rsp]
	lock xchg	word [rsp], cx
	lock xchg	dword [rsp], ecx
	lock xchg	qword [rsp], rcx

positive: xlatb instruction

	xlatb

positive: xor instruction

	xor	al, byte 0
	xor	al, byte 255
	xor	ax, word 0
	xor	ax, word 65535
	xor	eax, dword 0
	xor	eax, dword 4294967295
	xor	rax, dword -2147483648
	xor	rax, dword 2147483647
	xor	bl, byte 0
	xor	byte [rsp], byte 255
	xor	bx, word 0
	xor	word [rsp], word 65535
	xor	ebx, dword 0
	xor	dword [rsp], dword 4294967295
	xor	rbx, dword -2147483648
	xor	qword [rsp], dword 2147483647
	xor	bx, byte -128
	xor	word [rsp], byte 127
	xor	ebx, byte -128
	xor	dword [rsp], byte 127
	xor	rbx, byte -128
	xor	qword [rsp], byte 127
	xor	bl, cl
	xor	byte [rsp], cl
	xor	bx, cx
	xor	word [rsp], cx
	xor	ebx, ecx
	xor	dword [rsp], ecx
	xor	rbx, rcx
	xor	qword [rsp], rcx
	xor	cl, bl
	xor	cl, byte [rsp]
	xor	cx, bx
	xor	cx, word [rsp]
	xor	ecx, ebx
	xor	ecx, dword [rsp]
	xor	rcx, rbx
	xor	rcx, qword [rsp]
	lock xor	byte [rsp], byte 255
	lock xor	word [rsp], word 65535
	lock xor	dword [rsp], dword 4294967295
	lock xor	qword [rsp], dword 2147483647
	lock xor	word [rsp], byte 127
	lock xor	dword [rsp], byte 127
	lock xor	qword [rsp], byte 127
	lock xor	byte [rsp], cl
	lock xor	word [rsp], cx
	lock xor	dword [rsp], ecx
	lock xor	qword [rsp], rcx

# system instructions

positive: arpl instruction

	.bitmode	32
	arpl	bx, cx
	arpl	word [esp], cx

positive: clgi instruction

	clgi

positive: cli instruction

	cli

positive: clts instruction

	clts

positive: clrssbsy instruction

	clrssbsy	qword [rsp]

positive: hlt instruction

	hlt

positive: incssp instruction

	incssp	eax
	incssp	rax

positive: int3 instruction

	int3

positive: invd instruction

	invd

positive: invlpg instruction

	invlpg	[rsp]

positive: invlpga instruction

	invlpga	ax, ecx
	invlpga	eax, ecx
	invlpga	rax, ecx

positive: invlpgb instruction

	invlpgb

positive: invpcid instruction

	invpcid	eax, oword [rsp]
	invpcid	rax, oword [rsp]

positive: iret instruction

	iret

positive: iretd instruction

	iretd

positive: iretq instruction

	iretq

positive: lar instruction

	lar	cx, bx
	lar	cx, word [rsp]
	lar	ecx, bx
	lar	ecx, word [rsp]
	lar	rcx, bx
	lar	rcx, word [rsp]

positive: lgdt instruction

	lgdt	[rsp]

positive: lidt instruction

	lidt	[rsp]

positive: lldt instruction

	lldt	bx
	lldt	word [rsp]

positive: lmsw instruction

	lmsw	bx
	lmsw	word [rsp]

positive: lsl instruction

	lsl	cx, bx
	lsl	cx, word [rsp]

positive: ltr instruction

	ltr	bx
	ltr	word [rsp]

positive: monitor instruction

	monitor

positive: monitorx instruction

	monitorx

positive: mwait instruction

	mwait

positive: mwaitx instruction

	mwaitx

positive: psmash instruction

	psmash

positive: pvalidate instruction

	pvalidate

positive: rdmsr instruction

	rdmsr

positive: rdpkru instruction

	rdpkru

positive: rdpmc instruction

	rdpmc

positive: rdsspd instruction

	rdsspd eax

positive: rdsspq instruction

	rdsspq rax

positive: rdtsc instruction

	rdtsc

positive: rdtscp instruction

	rdtscp

positive: rmpadjust instruction

	rmpadjust

positive: rmpquery instruction

	rmpquery

positive: rmpread instruction

	rmpread

positive: rmpupdate instruction

	rmpupdate

positive: rsm instruction

	rsm

positive: rstorssp instruction

	rstorssp qword [rsp]

positive: saveprevssp instruction

	saveprevssp

positive: setssbsy instruction

	setssbsy

positive: sgdt instruction

	sgdt	[rsp]

positive: sidt instruction

	sidt	[rsp]

positive: skinit instruction

	skinit	eax

positive: sldt instruction

	sldt	bx
	sldt	word [rsp]

positive: smsw instruction

	smsw	bx
	smsw	word [rsp]

positive: sti instruction

	sti

positive: stgi instruction

	stgi

positive: str instruction

	str	bx
	str	word [rsp]

positive: swapgs instruction

	swapgs

positive: syscall instruction

	syscall

positive: sysenter instruction

	sysenter

positive: sysexit instruction

	sysexit

positive: sysret instruction

	sysret

positive: tlbsync instruction

	tlbsync

positive: ud0 instruction

	ud0

positive: ud1 instruction

	ud1

positive: ud2 instruction

	ud2

positive: verr instruction

	verr	bx
	verr	word [rsp]

positive: verw instruction

	verw	bx
	verw	word [rsp]

positive: vmgexit instruction

	vmgexit

positive: vmload instruction

	vmload	ax
	vmload	eax
	vmload	rax

positive: vmmcall instruction

	vmmcall

positive: vmrun instruction

	vmrun	ax
	vmrun	eax
	vmrun	rax

positive: vmsave instruction

	vmrun	ax
	vmrun	eax
	vmsave	rax

positive: wbinvd instruction

	wbinvd

positive: wbnoinvd instruction

	wbnoinvd

positive: wrmsr instruction

	wrmsr

positive: wrpkru instruction

	wrpkru

positive: wrssd instruction

	wrssd	dword [rsp], eax

positive: wrssq instruction

	wrssq	qword [rsp], rax

positive: wrussd instruction

	wrussd	dword [rsp], eax

positive: wrussq instruction

	wrussq	qword [rsp], rax

# 64-bit, 128-bit and 256-bit media instructions

positive: addpd instruction

	addpd	xmm0, xmm1
	addpd	xmm0, oword [rsp]

positive: vaddpd instruction

	vaddpd	xmm0, xmm1, xmm2
	vaddpd	xmm0, xmm1, oword [rsp]
	vaddpd	ymm0, ymm1, ymm2
	vaddpd	ymm0, ymm1, hword [rsp]

positive: addps instruction

	addps	xmm0, xmm1
	addps	xmm0, oword [rsp]

positive: vaddps instruction

	vaddps	xmm0, xmm1, xmm2
	vaddps	xmm0, xmm1, oword [rsp]
	vaddps	ymm0, ymm1, ymm2
	vaddps	ymm0, ymm1, hword [rsp]

positive: addsd instruction

	addsd	xmm0, xmm1
	addsd	xmm0, qword [rsp]

positive: vaddsd instruction

	vaddsd	xmm0, xmm1, xmm2
	vaddsd	xmm0, xmm1, qword [rsp]

positive: addss instruction

	addss	xmm0, xmm1
	addss	xmm0, dword [rsp]

positive: vaddss instruction

	vaddss	xmm0, xmm1, xmm2
	vaddss	xmm0, xmm1, dword [rsp]

positive: addsubpd instruction

	addsubpd	xmm0, xmm1
	addsubpd	xmm0, oword [rsp]

positive: vaddsubpd instruction

	vaddsubpd	xmm0, xmm1, xmm2
	vaddsubpd	xmm0, xmm1, oword [rsp]

positive: addsubps instruction

	addsubps	xmm0, xmm1
	addsubps	xmm0, oword [rsp]

positive: vaddsubps instruction

	vaddsubps	xmm0, xmm1, xmm2
	vaddsubps	xmm0, xmm1, oword [rsp]

positive: aesdec instruction

	aesdec	xmm0, xmm1
	aesdec	xmm0, oword [rsp]

positive: vaesdec instruction

	vaesdec	xmm0, xmm1, xmm2
	vaesdec	xmm0, xmm1, oword [rsp]

positive: aesdeclast instruction

	aesdeclast	xmm0, xmm1
	aesdeclast	xmm0, oword [rsp]

positive: vaesdeclast instruction

	vaesdeclast	xmm0, xmm1, xmm2
	vaesdeclast	xmm0, xmm1, oword [rsp]

positive: aesenc instruction

	aesenc	xmm0, xmm1
	aesenc	xmm0, oword [rsp]

positive: vaesenc instruction

	vaesenc	xmm0, xmm1, xmm2
	vaesenc	xmm0, xmm1, oword [rsp]

positive: aesenclast instruction

	aesenclast	xmm0, xmm1
	aesenclast	xmm0, oword [rsp]

positive: vaesenclast instruction

	vaesenclast	xmm0, xmm1, xmm2
	vaesenclast	xmm0, xmm1, oword [rsp]

positive: aesimc instruction

	aesimc	xmm0, xmm1
	aesimc	xmm0, oword [rsp]

positive: vaesimc instruction

	vaesimc	xmm0, xmm1
	vaesimc	xmm0, oword [rsp]

positive: aeskeygenassist instruction

	aeskeygenassist	xmm0, xmm1, byte 0
	aeskeygenassist	xmm0, oword [rsp], byte 255

positive: vaeskeygenassist instruction

	vaeskeygenassist	xmm0, xmm1, byte 0
	vaeskeygenassist	xmm0, oword [rsp], byte 255

positive: andn instruction

	andn	eax, ebx, ecx
	andn	eax, ebx, dword [rsp]
	andn	rax, rbx, rcx
	andn	rax, rbx, qword [rsp]

positive: andnpd instruction

	andnpd	xmm0, xmm1
	andnpd	xmm0, oword [rsp]

positive: vandnpd instruction

	vandnpd	xmm0, xmm1, xmm2
	vandnpd	xmm0, xmm1, oword [rsp]
	vandnpd	ymm0, ymm1, ymm2
	vandnpd	ymm0, ymm1, hword [rsp]

positive: andnps instruction

	andnps	xmm0, xmm1
	andnps	xmm0, oword [rsp]

positive: vandnps instruction

	vandnps	xmm0, xmm1, xmm2
	vandnps	xmm0, xmm1, oword [rsp]
	vandnps	ymm0, ymm1, ymm2
	vandnps	ymm0, ymm1, hword [rsp]

positive: andpd instruction

	andpd	xmm0, xmm1
	andpd	xmm0, oword [rsp]

positive: vandpd instruction

	vandpd	xmm0, xmm1, xmm2
	vandpd	xmm0, xmm1, oword [rsp]
	vandpd	ymm0, ymm1, ymm2
	vandpd	ymm0, ymm1, hword [rsp]

positive: andps instruction

	andps	xmm0, xmm1
	andps	xmm0, oword [rsp]

positive: vandps instruction

	vandps	xmm0, xmm1, xmm2
	vandps	xmm0, xmm1, oword [rsp]
	vandps	ymm0, ymm1, ymm2
	vandps	ymm0, ymm1, hword [rsp]

positive: bextr instruction

	bextr	eax, ebx, ecx
	bextr	eax, dword [rsp], ecx
	bextr	rax, rbx, rcx
	bextr	rax, qword [rsp], rcx
	bextr	eax, ebx, 0
	bextr	eax, dword [rsp], 4294967295
	bextr	rax, rbx, 0
	bextr	rax, qword [rsp], 4294967295

positive: blcfill instruction

	blcfill	eax, ebx
	blcfill	eax, dword [rsp]
	blcfill	rax, rbx
	blcfill	rax, qword [rsp]

positive: blci instruction

	blci	eax, ebx
	blci	eax, dword [rsp]
	blci	rax, rbx
	blci	rax, qword [rsp]

positive: blcic instruction

	blcic	eax, ebx
	blcic	eax, dword [rsp]
	blcic	rax, rbx
	blcic	rax, qword [rsp]

positive: blcmsk instruction

	blcmsk	eax, ebx
	blcmsk	eax, dword [rsp]
	blcmsk	rax, rbx
	blcmsk	rax, qword [rsp]

positive: blcs instruction

	blcs	eax, ebx
	blcs	eax, dword [rsp]
	blcs	rax, rbx
	blcs	rax, qword [rsp]

positive: blendpd instruction

	blendpd	xmm0, xmm1, byte 0
	blendpd	xmm0, oword [rsp], byte 255

positive: vblendpd instruction

	vblendpd	xmm0, xmm1, xmm2, byte 0
	vblendpd	xmm0, xmm1, oword [rsp], byte 255
	vblendpd	ymm0, ymm1, ymm2, byte 0
	vblendpd	ymm0, ymm1, hword [rsp], byte 255

positive: blendps instruction

	blendps	xmm0, xmm1, byte 0
	blendps	xmm0, oword [rsp], byte 255

positive: vblendps instruction

	vblendps	xmm0, xmm1, xmm2, byte 0
	vblendps	xmm0, xmm1, oword [rsp], byte 255
	vblendps	ymm0, ymm1, ymm2, byte 0
	vblendps	ymm0, ymm1, hword [rsp], byte 255

positive: blendvpd instruction

	blendvpd	xmm0, xmm1
	blendvpd	xmm0, oword [rsp]

positive: vblendvpd instruction

	vblendvpd	xmm0, xmm1, xmm2, xmm3
	vblendvpd	xmm0, xmm1, oword [rsp], xmm3
	vblendvpd	ymm0, ymm1, ymm2, ymm3
	vblendvpd	ymm0, ymm1, hword [rsp], ymm3

positive: blendvps instruction

	blendvps	xmm0, xmm1
	blendvps	xmm0, oword [rsp]

positive: vblendvps instruction

	vblendvps	xmm0, xmm1, xmm2, xmm3
	vblendvps	xmm0, xmm1, oword [rsp], xmm3
	vblendvps	ymm0, ymm1, ymm2, ymm3
	vblendvps	ymm0, ymm1, hword [rsp], ymm3

positive: blsfill instruction

	blsfill	eax, ebx
	blsfill	eax, dword [rsp]
	blsfill	rax, rbx
	blsfill	rax, qword [rsp]

positive: blsi instruction

	blsi	eax, ebx
	blsi	eax, dword [rsp]
	blsi	rax, rbx
	blsi	rax, qword [rsp]

positive: blsic instruction

	blsic	eax, ebx
	blsic	eax, dword [rsp]
	blsic	rax, rbx
	blsic	rax, qword [rsp]

positive: blsmsk instruction

	blsmsk	eax, ebx
	blsmsk	eax, dword [rsp]
	blsmsk	rax, rbx
	blsmsk	rax, qword [rsp]

positive: blsr instruction

	blsr	eax, ebx
	blsr	eax, dword [rsp]
	blsr	rax, rbx
	blsr	rax, qword [rsp]

positive: cmppd instruction

	cmppd	xmm0, xmm1, 0
	cmppd	xmm0, oword [rsp], 7

positive: vcmppd instruction

	vcmppd	xmm0, xmm1, xmm2, 0
	vcmppd	xmm0, xmm1, oword [rsp], 7
	vcmppd	ymm0, ymm1, ymm2, 0
	vcmppd	ymm0, ymm1, hword [rsp], 7

positive: cmpeqpd instruction

	cmpeqpd	xmm0, xmm1
	cmpeqpd	xmm0, oword [rsp]

positive: vcmpeqpd instruction

	vcmpeqpd	xmm0, xmm1, xmm2
	vcmpeqpd	xmm0, xmm1, oword [rsp]
	vcmpeqpd	ymm0, ymm1, ymm2
	vcmpeqpd	ymm0, ymm1, hword [rsp]

positive: cmpltpd instruction

	cmpltpd	xmm0, xmm1
	cmpltpd	xmm0, oword [rsp]

positive: vcmpltpd instruction

	vcmpltpd	xmm0, xmm1, xmm2
	vcmpltpd	xmm0, xmm1, oword [rsp]
	vcmpltpd	ymm0, ymm1, ymm2
	vcmpltpd	ymm0, ymm1, hword [rsp]

positive: cmplepd instruction

	cmplepd	xmm0, xmm1
	cmplepd	xmm0, oword [rsp]

positive: vcmplepd instruction

	vcmplepd	xmm0, xmm1, xmm2
	vcmplepd	xmm0, xmm1, oword [rsp]
	vcmplepd	ymm0, ymm1, ymm2
	vcmplepd	ymm0, ymm1, hword [rsp]

positive: cmpunordpd instruction

	cmpunordpd	xmm0, xmm1
	cmpunordpd	xmm0, oword [rsp]

positive: vcmpunordpd instruction

	vcmpunordpd	xmm0, xmm1, xmm2
	vcmpunordpd	xmm0, xmm1, oword [rsp]
	vcmpunordpd	ymm0, ymm1, ymm2
	vcmpunordpd	ymm0, ymm1, hword [rsp]

positive: cmpneqpd instruction

	cmpneqpd	xmm0, xmm1
	cmpneqpd	xmm0, oword [rsp]

positive: vcmpneqpd instruction

	vcmpneqpd	xmm0, xmm1, xmm2
	vcmpneqpd	xmm0, xmm1, oword [rsp]
	vcmpneqpd	ymm0, ymm1, ymm2
	vcmpneqpd	ymm0, ymm1, hword [rsp]

positive: cmpnltpd instruction

	cmpnltpd	xmm0, xmm1
	cmpnltpd	xmm0, oword [rsp]

positive: vcmpnltpd instruction

	vcmpnltpd	xmm0, xmm1, xmm2
	vcmpnltpd	xmm0, xmm1, oword [rsp]
	vcmpnltpd	ymm0, ymm1, ymm2
	vcmpnltpd	ymm0, ymm1, hword [rsp]

positive: cmpnlepd instruction

	cmpnlepd	xmm0, xmm1
	cmpnlepd	xmm0, oword [rsp]

positive: vcmpnlepd instruction

	vcmpnlepd	xmm0, xmm1, xmm2
	vcmpnlepd	xmm0, xmm1, oword [rsp]
	vcmpnlepd	ymm0, ymm1, ymm2
	vcmpnlepd	ymm0, ymm1, hword [rsp]

positive: cmpordpd instruction

	cmpordpd	xmm0, xmm1
	cmpordpd	xmm0, oword [rsp]

positive: vcmpordpd instruction

	vcmpordpd	xmm0, xmm1, xmm2
	vcmpordpd	xmm0, xmm1, oword [rsp]
	vcmpordpd	ymm0, ymm1, ymm2
	vcmpordpd	ymm0, ymm1, hword [rsp]

positive: cmpps instruction

	cmpps	xmm0, xmm1, 0
	cmpps	xmm0, oword [rsp], 7

positive: vcmpps instruction

	vcmpps	xmm0, xmm1, xmm2, 0
	vcmpps	xmm0, xmm1, oword [rsp], 7

positive: cmpeqps instruction

	cmpeqps	xmm0, xmm1
	cmpeqps	xmm0, oword [rsp]

positive: vcmpeqps instruction

	vcmpeqps	xmm0, xmm1, xmm2
	vcmpeqps	xmm0, xmm1, oword [rsp]

positive: cmpltps instruction

	cmpltps	xmm0, xmm1
	cmpltps	xmm0, oword [rsp]

positive: vcmpltps instruction

	vcmpltps	xmm0, xmm1, xmm2
	vcmpltps	xmm0, xmm1, oword [rsp]

positive: cmpleps instruction

	cmpleps	xmm0, xmm1
	cmpleps	xmm0, oword [rsp]

positive: vcmpleps instruction

	vcmpleps	xmm0, xmm1, xmm2
	vcmpleps	xmm0, xmm1, oword [rsp]

positive: cmpunordps instruction

	cmpunordps	xmm0, xmm1
	cmpunordps	xmm0, oword [rsp]

positive: vcmpunordps instruction

	vcmpunordps	xmm0, xmm1, xmm2
	vcmpunordps	xmm0, xmm1, oword [rsp]

positive: cmpneqps instruction

	cmpneqps	xmm0, xmm1
	cmpneqps	xmm0, oword [rsp]

positive: vcmpneqps instruction

	vcmpneqps	xmm0, xmm1, xmm2
	vcmpneqps	xmm0, xmm1, oword [rsp]

positive: cmpnltps instruction

	cmpnltps	xmm0, xmm1
	cmpnltps	xmm0, oword [rsp]

positive: vcmpnltps instruction

	vcmpnltps	xmm0, xmm1, xmm2
	vcmpnltps	xmm0, xmm1, oword [rsp]

positive: cmpnleps instruction

	cmpnleps	xmm0, xmm1
	cmpnleps	xmm0, oword [rsp]

positive: vcmpnleps instruction

	vcmpnleps	xmm0, xmm1, xmm2
	vcmpnleps	xmm0, xmm1, oword [rsp]

positive: cmpordps instruction

	cmpordps	xmm0, xmm1
	cmpordps	xmm0, oword [rsp]

positive: vcmpordps instruction

	vcmpordps	xmm0, xmm1, xmm2
	vcmpordps	xmm0, xmm1, oword [rsp]

positive: vcmpsd instruction

	vcmpsd	xmm0, xmm1, xmm2, 0
	vcmpsd	xmm0, xmm1, qword [rsp], 7

positive: cmpeqsd instruction

	cmpeqsd	xmm0, xmm1
	cmpeqsd	xmm0, qword [rsp]

positive: vcmpeqsd instruction

	vcmpeqsd	xmm0, xmm1, xmm2
	vcmpeqsd	xmm0, xmm1, qword [rsp]

positive: cmpltsd instruction

	cmpltsd	xmm0, xmm1
	cmpltsd	xmm0, qword [rsp]

positive: vcmpltsd instruction

	vcmpltsd	xmm0, xmm1, xmm2
	vcmpltsd	xmm0, xmm1, qword [rsp]

positive: cmplesd instruction

	cmplesd	xmm0, xmm1
	cmplesd	xmm0, qword [rsp]

positive: vcmplesd instruction

	vcmplesd	xmm0, xmm1, xmm2
	vcmplesd	xmm0, xmm1, qword [rsp]

positive: cmpunordsd instruction

	cmpunordsd	xmm0, xmm1
	cmpunordsd	xmm0, qword [rsp]

positive: vcmpunordsd instruction

	vcmpunordsd	xmm0, xmm1, xmm2
	vcmpunordsd	xmm0, xmm1, qword [rsp]

positive: cmpneqsd instruction

	cmpneqsd	xmm0, xmm1
	cmpneqsd	xmm0, qword [rsp]

positive: vcmpneqsd instruction

	vcmpneqsd	xmm0, xmm1, xmm2
	vcmpneqsd	xmm0, xmm1, qword [rsp]

positive: cmpnltsd instruction

	cmpnltsd	xmm0, xmm1
	cmpnltsd	xmm0, qword [rsp]

positive: vcmpnltsd instruction

	vcmpnltsd	xmm0, xmm1, xmm2
	vcmpnltsd	xmm0, xmm1, qword [rsp]

positive: cmpnlesd instruction

	cmpnlesd	xmm0, xmm1
	cmpnlesd	xmm0, qword [rsp]

positive: vcmpnlesd instruction

	vcmpnlesd	xmm0, xmm1, xmm2
	vcmpnlesd	xmm0, xmm1, qword [rsp]

positive: cmpordsd instruction

	cmpordsd	xmm0, xmm1
	cmpordsd	xmm0, qword [rsp]

positive: vcmpordsd instruction

	vcmpordsd	xmm0, xmm1, xmm2
	vcmpordsd	xmm0, xmm1, qword [rsp]

positive: cmpss instruction

	cmpss	xmm0, xmm1, 0
	cmpss	xmm0, dword [rsp], 7

positive: vcmpss instruction

	vcmpss	xmm0, xmm1, xmm2, 0
	vcmpss	xmm0, xmm1, dword [rsp], 7

positive: cmpeqss instruction

	cmpeqss	xmm0, xmm1
	cmpeqss	xmm0, dword [rsp]

positive: vcmpeqss instruction

	vcmpeqss	xmm0, xmm1, xmm2
	vcmpeqss	xmm0, xmm1, dword [rsp]

positive: cmpltss instruction

	cmpltss	xmm0, xmm1
	cmpltss	xmm0, dword [rsp]

positive: vcmpltss instruction

	vcmpltss	xmm0, xmm1, xmm2
	vcmpltss	xmm0, xmm1, dword [rsp]

positive: cmpless instruction

	cmpless	xmm0, xmm1
	cmpless	xmm0, dword [rsp]

positive: vcmpless instruction

	vcmpless	xmm0, xmm1, xmm2
	vcmpless	xmm0, xmm1, dword [rsp]

positive: cmpunordss instruction

	cmpunordss	xmm0, xmm1
	cmpunordss	xmm0, dword [rsp]

positive: vcmpunordss instruction

	vcmpunordss	xmm0, xmm1, xmm2
	vcmpunordss	xmm0, xmm1, dword [rsp]

positive: cmpneqss instruction

	cmpneqss	xmm0, xmm1
	cmpneqss	xmm0, dword [rsp]

positive: vcmpneqss instruction

	vcmpneqss	xmm0, xmm1, xmm2
	vcmpneqss	xmm0, xmm1, dword [rsp]

positive: cmpnltss instruction

	cmpnltss	xmm0, xmm1
	cmpnltss	xmm0, dword [rsp]

positive: vcmpnltss instruction

	vcmpnltss	xmm0, xmm1, xmm2
	vcmpnltss	xmm0, xmm1, dword [rsp]

positive: cmpnless instruction

	cmpnless	xmm0, xmm1
	cmpnless	xmm0, dword [rsp]

positive: vcmpnless instruction

	vcmpnless	xmm0, xmm1, xmm2
	vcmpnless	xmm0, xmm1, dword [rsp]

positive: cmpordss instruction

	cmpordss	xmm0, xmm1
	cmpordss	xmm0, dword [rsp]

positive: vcmpordss instruction

	vcmpordss	xmm0, xmm1, xmm2
	vcmpordss	xmm0, xmm1, dword [rsp]

positive: comisd instruction

	comisd	xmm0, xmm1
	comisd	xmm0, qword [rsp]

positive: vcomisd instruction

	vcomisd	xmm0, xmm1
	vcomisd	xmm0, qword [rsp]

positive: comiss instruction

	comiss	xmm0, xmm1
	comiss	xmm0, dword [rsp]

positive: vcomiss instruction

	vcomiss	xmm0, xmm1
	vcomiss	xmm0, dword [rsp]

positive: cvtdq2pd instruction

	cvtdq2pd	xmm0, xmm1
	cvtdq2pd	xmm0, qword [rsp]

positive: vcvtdq2pd instruction

	vcvtdq2pd	xmm0, xmm1
	vcvtdq2pd	xmm0, qword [rsp]
	vcvtdq2pd	ymm0, ymm1
	vcvtdq2pd	ymm0, oword [rsp]

positive: cvtdq2ps instruction

	cvtdq2ps	xmm0, xmm1
	cvtdq2ps	xmm0, oword [rsp]

positive: vcvtdq2ps instruction

	vcvtdq2ps	xmm0, xmm1
	vcvtdq2ps	xmm0, oword [rsp]
	vcvtdq2ps	ymm0, ymm1
	vcvtdq2ps	ymm0, hword [rsp]

positive: cvtpd2dq instruction

	cvtpd2dq	xmm0, xmm1
	cvtpd2dq	xmm0, oword [rsp]

positive: vcvtpd2dq instruction

	vcvtpd2dq	xmm0, xmm1
	vcvtpd2dq	xmm0, oword [rsp]
	vcvtpd2dq	xmm0, ymm1
	vcvtpd2dq	xmm0, hword [rsp]

positive: cvtpd2pi instruction

	cvtpd2pi	mmx0, xmm1
	cvtpd2pi	mmx0, oword [rsp]

positive: cvtpd2ps instruction

	cvtpd2ps	xmm0, xmm1
	cvtpd2ps	xmm0, oword [rsp]

positive: vcvtpd2ps instruction

	vcvtpd2ps	xmm0, xmm1
	vcvtpd2ps	xmm0, oword [rsp]
	vcvtpd2ps	xmm0, ymm1
	vcvtpd2ps	xmm0, hword [rsp]

positive: cvtpi2pd instruction

	cvtpi2pd	xmm0, mmx1
	cvtpi2pd	xmm0, qword [rsp]

positive: cvtpi2ps instruction

	cvtpi2ps	xmm0, mmx1
	cvtpi2ps	xmm0, qword [rsp]

positive: cvtps2dq instruction

	cvtps2dq	xmm0, xmm1
	cvtps2dq	xmm0, oword [rsp]

positive: vcvtps2dq instruction

	vcvtps2dq	xmm0, xmm1
	vcvtps2dq	xmm0, oword [rsp]
	vcvtps2dq	ymm0, ymm1
	vcvtps2dq	ymm0, hword [rsp]

positive: cvtps2pd instruction

	cvtps2pd	xmm0, xmm1
	cvtps2pd	xmm0, qword [rsp]

positive: vcvtps2pd instruction

	vcvtps2pd	xmm0, xmm1
	vcvtps2pd	xmm0, qword [rsp]
	vcvtps2pd	ymm0, ymm1
	vcvtps2pd	ymm0, oword [rsp]

positive: cvtps2pi instruction

	cvtps2pi	mmx0, xmm1
	cvtps2pi	mmx0, qword [rsp]

positive: cvtsd2si instruction

	cvtsd2si	ecx, xmm1
	cvtsd2si	ecx, qword [rsp]
	cvtsd2si	rcx, xmm1
	cvtsd2si	rcx, qword [rsp]

positive: vcvtsd2si instruction

	vcvtsd2si	ecx, xmm1
	vcvtsd2si	ecx, qword [rsp]
	vcvtsd2si	rcx, xmm1
	vcvtsd2si	rcx, qword [rsp]

positive: cvtsd2ss instruction

	cvtsd2ss	xmm0, xmm1
	cvtsd2ss	xmm0, qword [rsp]

positive: vcvtsd2ss instruction

	vcvtsd2ss	xmm0, xmm1, xmm2
	vcvtsd2ss	xmm0, xmm1, qword [rsp]

positive: cvtsi2sd instruction

	cvtsi2sd	xmm0, ecx
	cvtsi2sd	xmm0, dword [rsp]
	cvtsi2sd	xmm0, rcx
	cvtsi2sd	xmm0, qword [rsp]

positive: vcvtsi2sd instruction

	vcvtsi2sd	xmm0, xmm1, ecx
	vcvtsi2sd	xmm0, xmm1, dword [rsp]
	vcvtsi2sd	xmm0, xmm1, rcx
	vcvtsi2sd	xmm0, xmm1, qword [rsp]

positive: cvtsi2ss instruction

	cvtsi2ss	xmm0, ecx
	cvtsi2ss	xmm0, dword [rsp]
	cvtsi2ss	xmm0, rcx
	cvtsi2ss	xmm0, qword [rsp]

positive: vcvtsi2ss instruction

	vcvtsi2ss	xmm0, xmm1, ecx
	vcvtsi2ss	xmm0, xmm1, dword [rsp]
	vcvtsi2ss	xmm0, xmm1, rcx
	vcvtsi2ss	xmm0, xmm1, qword [rsp]

positive: cvtss2sd instruction

	cvtss2sd	xmm0, xmm1
	cvtss2sd	xmm0, dword [rsp]

positive: vcvtss2sd instruction

	vcvtss2sd	xmm0, xmm1, xmm2
	vcvtss2sd	xmm0, xmm1, dword [rsp]

positive: cvtss2si instruction

	cvtss2si	ecx, xmm1
	cvtss2si	ecx, dword [rsp]
	cvtss2si	rcx, xmm1
	cvtss2si	rcx, dword [rsp]

positive: vcvtss2si instruction

	vcvtss2si	ecx, xmm1
	vcvtss2si	ecx, dword [rsp]
	vcvtss2si	rcx, xmm1
	vcvtss2si	rcx, dword [rsp]

positive: cvttpd2dq instruction

	cvttpd2dq	xmm0, xmm1
	cvttpd2dq	xmm0, oword [rsp]

positive: vcvttpd2dq instruction

	vcvttpd2dq	xmm0, xmm1
	vcvttpd2dq	xmm0, oword [rsp]
	vcvttpd2dq	xmm0, ymm1
	vcvttpd2dq	xmm0, hword [rsp]

positive: cvttpd2pi instruction

	cvttpd2pi	mmx0, xmm1
	cvttpd2pi	mmx0, oword [rsp]

positive: cvttps2dq instruction

	cvttps2dq	xmm0, xmm1
	cvttps2dq	xmm0, oword [rsp]

positive: vcvttps2dq instruction

	vcvttps2dq	xmm0, xmm1
	vcvttps2dq	xmm0, oword [rsp]
	vcvttps2dq	ymm0, ymm1
	vcvttps2dq	ymm0, hword [rsp]

positive: cvttps2pi instruction

	cvttps2pi	mmx0, xmm1
	cvttps2pi	mmx0, qword [rsp]

positive: cvttsd2si instruction

	cvttsd2si	ecx, xmm1
	cvttsd2si	ecx, qword [rsp]
	cvttsd2si	rcx, xmm1
	cvttsd2si	rcx, qword [rsp]

positive: vcvttsd2si instruction

	vcvttsd2si	ecx, xmm1
	vcvttsd2si	ecx, qword [rsp]
	vcvttsd2si	rcx, xmm1
	vcvttsd2si	rcx, qword [rsp]

positive: cvttss2si instruction

	cvttss2si	ecx, xmm1
	cvttss2si	ecx, dword [rsp]
	cvttss2si	rcx, xmm1
	cvttss2si	rcx, dword [rsp]

positive: vcvttss2si instruction

	vcvttss2si	ecx, xmm1
	vcvttss2si	ecx, dword [rsp]
	vcvttss2si	rcx, xmm1
	vcvttss2si	rcx, dword [rsp]

positive: divpd instruction

	divpd	xmm0, xmm1
	divpd	xmm0, oword [rsp]

positive: vdivpd instruction

	vdivpd	xmm0, xmm1, xmm2
	vdivpd	xmm0, xmm1, oword [rsp]
	vdivpd	ymm0, ymm1, ymm2
	vdivpd	ymm0, ymm1, hword [rsp]

positive: divps instruction

	divps	xmm0, xmm1
	divps	xmm0, oword [rsp]

positive: vdivps instruction

	vdivps	xmm0, xmm1, xmm2
	vdivps	xmm0, xmm1, oword [rsp]
	vdivps	ymm0, ymm1, ymm2
	vdivps	ymm0, ymm1, hword [rsp]

positive: divsd instruction

	divsd	xmm0, xmm1
	divsd	xmm0, qword [rsp]

positive: vdivsd instruction

	vdivsd	xmm0, xmm1, xmm2
	vdivsd	xmm0, xmm1, qword [rsp]

positive: divss instruction

	divss	xmm0, xmm1
	divss	xmm0, dword [rsp]

positive: vdivss instruction

	vdivss	xmm0, xmm1, xmm2
	vdivss	xmm0, xmm1, dword [rsp]

positive: dppd instruction

	dppd	xmm0, xmm1, byte 0
	dppd	xmm0, oword [rsp], byte 255

positive: vdppd instruction

	vdppd	xmm0, xmm1, xmm2, byte 0
	vdppd	xmm0, xmm1, oword [rsp], byte 255

positive: dpps instruction

	dpps	xmm0, xmm1, byte 0
	dpps	xmm0, oword [rsp], byte 255

positive: vdpps instruction

	vdpps	xmm0, xmm1, xmm2, byte 0
	vdpps	xmm0, xmm1, oword [rsp], byte 255
	vdpps	ymm0, ymm1, ymm2, byte 0
	vdpps	ymm0, ymm1, hword [rsp], byte 255

positive: extractps instruction

	extractps	ecx, xmm1, byte 0
	extractps	dword [rsp], xmm1, byte 255

positive: vextractps instruction

	vextractps	ecx, xmm1, byte 0
	vextractps	dword [rsp], xmm1, byte 255

positive: emms instruction

	emms

positive: extrq instruction

	extrq	xmm0, word 0
	extrq	xmm0, xmm1

positive: femms instruction

	femms

positive: fnsave instruction

	fnsave	[rsp]

positive: frstor instruction

	frstor	[rsp]

positive: fxrstor instruction

	fxrstor	[rsp]

positive: fxsave instruction

	fxsave	[rsp]

positive: haddpd instruction

	haddpd	xmm0, xmm1
	haddpd	xmm0, oword [rsp]

positive: vhaddpd instruction

	vhaddpd	xmm0, xmm1, xmm2
	vhaddpd	xmm0, xmm1, oword [rsp]
	vhaddpd	ymm0, ymm1, ymm2
	vhaddpd	ymm0, ymm1, hword [rsp]

positive: haddps instruction

	haddps	xmm0, xmm1
	haddps	xmm0, oword [rsp]

positive: vhaddps instruction

	vhaddps	xmm0, xmm1, xmm2
	vhaddps	xmm0, xmm1, oword [rsp]
	vhaddps	ymm0, ymm1, ymm2
	vhaddps	ymm0, ymm1, hword [rsp]

positive: hsubpd instruction

	hsubpd	xmm0, xmm1
	hsubpd	xmm0, oword [rsp]

positive: vhsubpd instruction

	vhsubpd	xmm0, xmm1, xmm2
	vhsubpd	xmm0, xmm1, oword [rsp]
	vhsubpd	ymm0, ymm1, ymm2
	vhsubpd	ymm0, ymm1, hword [rsp]

positive: hsubps instruction

	hsubps	xmm0, xmm1
	hsubps	xmm0, oword [rsp]

positive: vhsubps instruction

	vhsubps	xmm0, xmm1, xmm2
	vhsubps	xmm0, xmm1, oword [rsp]
	vhsubps	ymm0, ymm1, ymm2
	vhsubps	ymm0, ymm1, hword [rsp]

positive: insertps instruction

	insertps	xmm0, xmm1, byte 0
	insertps	xmm0, oword [rsp], byte 255

positive: vinsertps instruction

	vinsertps	xmm0, xmm1, xmm2, byte 0
	vinsertps	xmm0, xmm1, oword [rsp], byte 255

positive: insertq instruction

	insertq	xmm0, xmm1, word 0

positive: lddqu instruction

	lddqu	xmm0, oword [rsp]

positive: vlddqu instruction

	vlddqu	xmm0, oword [rsp]
	vlddqu	ymm0, hword [rsp]

positive: ldmxcsr instruction

	ldmxcsr	dword [rsp]

positive: vldmxcsr instruction

	vldmxcsr	dword [rsp]

positive: maskmovq instruction

	maskmovq	mmx0, mmx1

positive: maskmovdqu instruction

	maskmovdqu	xmm0, xmm1

positive: vmaskmovdqu instruction

	vmaskmovdqu	xmm0, xmm1

positive: maxpd instruction

	maxpd	xmm0, xmm1
	maxpd	xmm0, oword [rsp]

positive: vmaxpd instruction

	vmaxpd	xmm0, xmm1, xmm2
	vmaxpd	xmm0, xmm1, oword [rsp]
	vmaxpd	ymm0, ymm1, ymm2
	vmaxpd	ymm0, ymm1, hword [rsp]

positive: maxps instruction

	maxps	xmm0, xmm1
	maxps	xmm0, oword [rsp]

positive: vmaxps instruction

	vmaxps	xmm0, xmm1, xmm2
	vmaxps	xmm0, xmm1, oword [rsp]
	vmaxps	ymm0, ymm1, ymm2
	vmaxps	ymm0, ymm1, hword [rsp]

positive: maxsd instruction

	maxsd	xmm0, xmm1
	maxsd	xmm0, qword [rsp]

positive: vmaxsd instruction

	vmaxsd	xmm0, xmm1, xmm2
	vmaxsd	xmm0, xmm1, qword [rsp]

positive: maxss instruction

	maxss	xmm0, xmm1
	maxss	xmm0, dword [rsp]

positive: vmaxss instruction

	vmaxss	xmm0, xmm1, xmm2
	vmaxss	xmm0, xmm1, dword [rsp]

positive: minpd instruction

	minpd	xmm0, xmm1
	minpd	xmm0, oword [rsp]

positive: vminpd instruction

	vminpd	xmm0, xmm1, xmm2
	vminpd	xmm0, xmm1, oword [rsp]
	vminpd	ymm0, ymm1, ymm2
	vminpd	ymm0, ymm1, hword [rsp]

positive: minps instruction

	minps	xmm0, xmm1
	minps	xmm0, oword [rsp]

positive: vminps instruction

	vminps	xmm0, xmm1, xmm2
	vminps	xmm0, xmm1, oword [rsp]
	vminps	ymm0, ymm1, ymm2
	vminps	ymm0, ymm1, hword [rsp]

positive: minsd instruction

	minsd	xmm0, xmm1
	minsd	xmm0, qword [rsp]

positive: vminsd instruction

	vminsd	xmm0, xmm1, xmm2
	vminsd	xmm0, xmm1, qword [rsp]

positive: minss instruction

	minss	xmm0, xmm1
	minss	xmm0, dword [rsp]

positive: vminss instruction

	vminss	xmm0, xmm1, xmm2
	vminss	xmm0, xmm1, dword [rsp]

positive: movapd instruction

	movapd	xmm0, xmm1
	movapd	xmm0, oword [rsp]
	movapd	xmm1, xmm0
	movapd	oword [rsp], xmm0

positive: vmovapd instruction

	vmovapd	xmm0, xmm1
	vmovapd	xmm0, oword [rsp]
	vmovapd	xmm1, xmm0
	vmovapd	oword [rsp], xmm0
	vmovapd	ymm0, ymm1
	vmovapd	ymm0, hword [rsp]
	vmovapd	ymm1, ymm0
	vmovapd	hword [rsp], ymm0

positive: movaps instruction

	movaps	xmm0, xmm1
	movaps	xmm0, oword [rsp]
	movaps	xmm1, xmm0
	movaps	oword [rsp], xmm0

positive: vmovaps instruction

	vmovaps	xmm0, xmm1
	vmovaps	xmm0, oword [rsp]
	vmovaps	xmm1, xmm0
	vmovaps	oword [rsp], xmm0
	vmovaps	ymm0, ymm1
	vmovaps	ymm0, hword [rsp]
	vmovaps	ymm1, ymm0
	vmovaps	hword [rsp], ymm0

positive: movddup instruction

	movddup	xmm0, xmm1
	movddup	xmm0, qword [rsp]

positive: vmovddup instruction

	vmovddup	xmm0, xmm1
	vmovddup	xmm0, qword [rsp]
	vmovddup	ymm0, ymm1
	vmovddup	ymm0, hword [rsp]

positive: movdq2q instruction

	movdq2q	mmx0, xmm1

positive: movdqa instruction

	movdqa	xmm0, xmm1
	movdqa	xmm0, oword [rsp]
	movdqa	xmm1, xmm0
	movdqa	oword [rsp], xmm0

positive: vmovdqa instruction

	vmovdqa	xmm0, xmm1
	vmovdqa	xmm0, oword [rsp]
	vmovdqa	xmm1, xmm0
	vmovdqa	oword [rsp], xmm0
	vmovdqa	ymm0, ymm1
	vmovdqa	ymm0, hword [rsp]
	vmovdqa	ymm1, ymm0
	vmovdqa	hword [rsp], ymm0

positive: movdqu instruction

	movdqu	xmm0, xmm1
	movdqu	xmm0, oword [rsp]
	movdqu	xmm1, xmm0
	movdqu	oword [rsp], xmm0

positive: vmovdqu instruction

	vmovdqu	xmm0, xmm1
	vmovdqu	xmm0, oword [rsp]
	vmovdqu	xmm1, xmm0
	vmovdqu	oword [rsp], xmm0
	vmovdqu	ymm0, ymm1
	vmovdqu	ymm0, hword [rsp]
	vmovdqu	ymm1, ymm0
	vmovdqu	hword [rsp], ymm0

positive: movhlps instruction

	movhlps	xmm0, xmm1

positive: vmovhlps instruction

	vmovhlps	xmm0, xmm1, xmm2

positive: movhpd instruction

	movhpd	xmm0, qword [rsp]
	movhpd	qword [rsp], xmm1

positive: vmovhpd instruction

	vmovhpd	xmm0, xmm1, qword [rsp]
	vmovhpd	qword [rsp], xmm1

positive: movhps instruction

	movhps	xmm0, qword [rsp]
	movhps	qword [rsp], xmm1

positive: vmovhps instruction

	vmovhps	xmm0, xmm1, qword [rsp]
	vmovhps	qword [rsp], xmm1

positive: movlhps instruction

	movlhps	xmm0, xmm1

positive: vmovlhps instruction

	vmovlhps	xmm0, xmm1, xmm2

positive: movlpd instruction

	movlpd	xmm0, qword [rsp]
	movlpd	qword [rsp], xmm1

positive: vmovlpd instruction

	vmovlpd	xmm0, xmm1, qword [rsp]
	vmovlpd	qword [rsp], xmm1

positive: movlps instruction

	movlps	xmm0, qword [rsp]
	movlps	qword [rsp], xmm1

positive: vmovlps instruction

	vmovlps	xmm0, xmm1, qword [rsp]
	vmovlps	qword [rsp], xmm1

positive: movntdq instruction

	movntdq	oword [rsp], xmm1

positive: vmovntdq instruction

	vmovntdq	oword [rsp], xmm1
	vmovntdq	hword [rsp], ymm1

positive: movntdqa instruction

	movntdqa	xmm1, oword [rsp]

positive: vmovntdqa instruction

	vmovntdqa	xmm1, oword [rsp]
	vmovntdqa	ymm1, hword [rsp]

positive: movntpd instruction

	movntpd	oword [rsp], xmm1

positive: vmovntpd instruction

	vmovntpd	oword [rsp], xmm1
	vmovntpd	hword [rsp], ymm1

positive: movntps instruction

	movntps	oword [rsp], xmm1

positive: vmovntps instruction

	vmovntps	oword [rsp], xmm1
	vmovntps	hword [rsp], ymm1

positive: movntq instruction

	movntq	qword [rsp], mmx1

positive: movntsd instruction

	movntsd	qword [rsp], xmm1

positive: movntss instruction

	movntss	dword [rsp], xmm1

positive: movq instruction

	movq	xmm0, xmm1
	movq	xmm0, qword [rsp]
	movq	xmm1, xmm0
	movq	qword [rsp], xmm0
	movq	mmx0, mmx1
	movq	mmx0, qword [rsp]
	movq	mmx1, mmx0
	movq	qword [rsp], mmx0

positive: vmovq instruction

	vmovq	xmm0, rbx
	vmovq	xmm0, qword [rsp]
	vmovq	rbx, xmm0
	vmovq	qword [rsp], xmm0
	vmovq	xmm0, xmm1
	vmovq	xmm0, qword [rsp]
	vmovq	xmm0, xmm1
	vmovq	qword [rsp], xmm0

positive: movq2dq instruction

	movq2dq	xmm0, mmx1

positive: movshdup instruction

	movshdup	xmm0, xmm1
	movshdup	xmm0, oword [rsp]

positive: vmovshdup instruction

	vmovshdup	xmm0, xmm1
	vmovshdup	xmm0, oword [rsp]
	vmovshdup	ymm0, ymm1
	vmovshdup	ymm0, hword [rsp]

positive: movsldup instruction

	movsldup	xmm0, xmm1
	movsldup	xmm0, oword [rsp]

positive: vmovsldup instruction

	vmovsldup	xmm0, xmm1
	vmovsldup	xmm0, oword [rsp]
	vmovsldup	ymm0, ymm1
	vmovsldup	ymm0, hword [rsp]

positive: movss instruction

	movss	xmm0, xmm1
	movss	xmm0, dword [rsp]
	movss	xmm1, xmm0
	movss	dword [rsp], xmm0

positive: vmovss instruction

	vmovss	xmm0, dword [rsp]
	vmovss	dword [rsp], xmm0
	vmovss	xmm0, xmm1, xmm2

positive: movupd instruction

	movupd	xmm0, xmm1
	movupd	xmm0, oword [rsp]
	movupd	xmm1, xmm0
	movupd	oword [rsp], xmm0

positive: vmovupd instruction

	vmovupd	xmm0, xmm1
	vmovupd	xmm0, oword [rsp]
	vmovupd	xmm1, xmm0
	vmovupd	oword [rsp], xmm0
	vmovupd	ymm0, ymm1
	vmovupd	ymm0, hword [rsp]
	vmovupd	ymm1, ymm0
	vmovupd	hword [rsp], ymm0

positive: movups instruction

	movups	xmm0, xmm1
	movups	xmm0, oword [rsp]
	movups	xmm1, xmm0
	movups	oword [rsp], xmm0

positive: vmovups instruction

	vmovups	xmm0, xmm1
	vmovups	xmm0, oword [rsp]
	vmovups	xmm1, xmm0
	vmovups	oword [rsp], xmm0
	vmovups	ymm0, ymm1
	vmovups	ymm0, hword [rsp]
	vmovups	ymm1, ymm0
	vmovups	hword [rsp], ymm0

positive: mpsadbw instruction

	mpsadbw	xmm0, xmm1, byte 0
	mpsadbw	xmm0, oword [rsp], byte 255

positive: vmpsadbw instruction

	vmpsadbw	xmm0, xmm1, xmm2, byte 0
	vmpsadbw	xmm0, xmm1, oword [rsp], byte 255
	vmpsadbw	ymm0, ymm1, ymm2, byte 0
	vmpsadbw	ymm0, ymm1, hword [rsp], byte 255

positive: mulpd instruction

	mulpd	xmm0, xmm1
	mulpd	xmm0, oword [rsp]

positive: vmulpd instruction

	vmulpd	xmm0, xmm1, xmm2
	vmulpd	xmm0, xmm1, oword [rsp]
	vmulpd	ymm0, ymm1, ymm2
	vmulpd	ymm0, ymm1, hword [rsp]

positive: mulps instruction

	mulps	xmm0, xmm1
	mulps	xmm0, oword [rsp]

positive: vmulps instruction

	vmulps	xmm0, xmm1, xmm2
	vmulps	xmm0, xmm1, oword [rsp]
	vmulps	ymm0, ymm1, ymm2
	vmulps	ymm0, ymm1, hword [rsp]

positive: mulsd instruction

	mulsd	xmm0, xmm1
	mulsd	xmm0, qword [rsp]

positive: vmulsd instruction

	vmulsd	xmm0, xmm1, xmm2
	vmulsd	xmm0, xmm1, qword [rsp]

positive: mulss instruction

	mulss	xmm0, xmm1
	mulss	xmm0, dword [rsp]

positive: vmulss instruction

	vmulss	xmm0, xmm1, xmm2
	vmulss	xmm0, xmm1, dword [rsp]

positive: orpd instruction

	orpd	xmm0, xmm1
	orpd	xmm0, oword [rsp]

positive: vorpd instruction

	vorpd	xmm0, xmm1, xmm2
	vorpd	xmm0, xmm1, oword [rsp]
	vorpd	ymm0, ymm1, ymm2
	vorpd	ymm0, ymm1, hword [rsp]

positive: orps instruction

	orps	xmm0, xmm1
	orps	xmm0, oword [rsp]

positive: vorps instruction

	vorps	xmm0, xmm1, xmm2
	vorps	xmm0, xmm1, oword [rsp]
	vorps	ymm0, ymm1, ymm2
	vorps	ymm0, ymm1, hword [rsp]

positive: pabsb instruction

	pabsb	xmm0, xmm1
	pabsb	xmm0, oword [rsp]

positive: vpabsb instruction

	vpabsb	xmm0, xmm1
	vpabsb	xmm0, oword [rsp]
	vpabsb	ymm0, ymm1
	vpabsb	ymm0, hword [rsp]

positive: pabsd instruction

	pabsd	xmm0, xmm1
	pabsd	xmm0, oword [rsp]

positive: vpabsd instruction

	vpabsd	xmm0, xmm1
	vpabsd	xmm0, oword [rsp]
	vpabsd	ymm0, ymm1
	vpabsd	ymm0, hword [rsp]

positive: pabsw instruction

	pabsw	xmm0, xmm1
	pabsw	xmm0, oword [rsp]

positive: vpabsw instruction

	vpabsw	xmm0, xmm1
	vpabsw	xmm0, oword [rsp]
	vpabsw	ymm0, ymm1
	vpabsw	ymm0, hword [rsp]

positive: packssdw instruction

	packssdw	xmm0, xmm1
	packssdw	xmm0, oword [rsp]
	packssdw	mmx0, mmx1
	packssdw	mmx0, qword [rsp]

positive: vpackssdw instruction

	vpackssdw	xmm0, xmm1, xmm2
	vpackssdw	xmm0, xmm1, oword [rsp]
	vpackssdw	ymm0, ymm1, ymm2
	vpackssdw	ymm0, ymm1, hword [rsp]

positive: packsswb instruction

	packsswb	xmm0, xmm1
	packsswb	xmm0, oword [rsp]
	packsswb	mmx0, mmx1
	packsswb	mmx0, qword [rsp]

positive: vpacksswb instruction

	vpacksswb	xmm0, xmm1, xmm2
	vpacksswb	xmm0, xmm1, oword [rsp]
	vpacksswb	ymm0, ymm1, ymm2
	vpacksswb	ymm0, ymm1, hword [rsp]

positive: packusdw instruction

	packusdw	xmm0, xmm1
	packusdw	xmm0, oword [rsp]

positive: vpackusdw instruction

	vpackusdw	xmm0, xmm1, xmm2
	vpackusdw	xmm0, xmm1, oword [rsp]
	vpackusdw	ymm0, ymm1, ymm2
	vpackusdw	ymm0, ymm1, hword [rsp]

positive: packuswb instruction

	packuswb	xmm0, xmm1
	packuswb	xmm0, oword [rsp]
	packuswb	mmx0, mmx1
	packuswb	mmx0, qword [rsp]

positive: vpackuswb instruction

	vpackuswb	xmm0, xmm1, xmm2
	vpackuswb	xmm0, xmm1, oword [rsp]
	vpackuswb	ymm0, ymm1, ymm2
	vpackuswb	ymm0, ymm1, hword [rsp]

positive: paddb instruction

	paddb	xmm0, xmm1
	paddb	xmm0, oword [rsp]
	paddb	mmx0, mmx1
	paddb	mmx0, qword [rsp]

positive: vpaddb instruction

	vpaddb	xmm0, xmm1, xmm2
	vpaddb	xmm0, xmm1, oword [rsp]
	vpaddb	ymm0, ymm1, ymm2
	vpaddb	ymm0, ymm1, hword [rsp]

positive: paddd instruction

	paddd	xmm0, xmm1
	paddd	xmm0, oword [rsp]
	paddd	mmx0, mmx1
	paddd	mmx0, qword [rsp]

positive: vpaddd instruction

	vpaddd	xmm0, xmm1, xmm2
	vpaddd	xmm0, xmm1, oword [rsp]
	vpaddd	ymm0, ymm1, ymm2
	vpaddd	ymm0, ymm1, hword [rsp]

positive: paddq instruction

	paddq	xmm0, xmm1
	paddq	xmm0, oword [rsp]
	paddq	mmx0, mmx1
	paddq	mmx0, qword [rsp]

positive: vpaddq instruction

	vpaddq	xmm0, xmm1, xmm2
	vpaddq	xmm0, xmm1, oword [rsp]
	vpaddq	ymm0, ymm1, ymm2
	vpaddq	ymm0, ymm1, hword [rsp]

positive: paddsb instruction

	paddsb	xmm0, xmm1
	paddsb	xmm0, oword [rsp]
	paddsb	mmx0, mmx1
	paddsb	mmx0, qword [rsp]

positive: vpaddsb instruction

	vpaddsb	xmm0, xmm1, xmm2
	vpaddsb	xmm0, xmm1, oword [rsp]
	vpaddsb	ymm0, ymm1, ymm2
	vpaddsb	ymm0, ymm1, hword [rsp]

positive: paddsw instruction

	paddsw	xmm0, xmm1
	paddsw	xmm0, oword [rsp]
	paddsw	mmx0, mmx1
	paddsw	mmx0, qword [rsp]

positive: vpaddsw instruction

	vpaddsw	xmm0, xmm1, xmm2
	vpaddsw	xmm0, xmm1, oword [rsp]
	vpaddsw	ymm0, ymm1, ymm2
	vpaddsw	ymm0, ymm1, hword [rsp]

positive: paddusb instruction

	paddusb	xmm0, xmm1
	paddusb	xmm0, oword [rsp]
	paddusb	mmx0, mmx1
	paddusb	mmx0, qword [rsp]

positive: vpaddusb instruction

	vpaddusb	xmm0, xmm1, xmm2
	vpaddusb	xmm0, xmm1, oword [rsp]
	vpaddusb	ymm0, ymm1, ymm2
	vpaddusb	ymm0, ymm1, hword [rsp]

positive: paddusw instruction

	paddusw	xmm0, xmm1
	paddusw	xmm0, oword [rsp]
	paddusw	mmx0, mmx1
	paddusw	mmx0, qword [rsp]

positive: vpaddusw instruction

	vpaddusw	xmm0, xmm1, xmm2
	vpaddusw	xmm0, xmm1, oword [rsp]
	vpaddusw	ymm0, ymm1, ymm2
	vpaddusw	ymm0, ymm1, hword [rsp]

positive: paddw instruction

	paddw	xmm0, xmm1
	paddw	xmm0, oword [rsp]
	paddw	mmx0, mmx1
	paddw	mmx0, qword [rsp]

positive: vpaddw instruction

	vpaddw	xmm0, xmm1, xmm2
	vpaddw	xmm0, xmm1, oword [rsp]
	vpaddw	ymm0, ymm1, ymm2
	vpaddw	ymm0, ymm1, hword [rsp]

positive: palignr instruction

	palignr	xmm0, xmm1, byte 0
	palignr	xmm0, oword [rsp], byte 255

positive: vpalignr instruction

	vpalignr	xmm0, xmm1, xmm2, byte 0
	vpalignr	xmm0, xmm1, oword [rsp], byte 255
	vpalignr	ymm0, ymm1, ymm2, byte 0
	vpalignr	ymm0, ymm1, hword [rsp], byte 255

positive: pand instruction

	pand	xmm0, xmm1
	pand	xmm0, oword [rsp]
	pand	mmx0, mmx1
	pand	mmx0, qword [rsp]

positive: vpand instruction

	vpand	xmm0, xmm1, xmm2
	vpand	xmm0, xmm1, oword [rsp]
	vpand	ymm0, ymm1, ymm2
	vpand	ymm0, ymm1, hword [rsp]

positive: pandn instruction

	pandn	xmm0, xmm1
	pandn	xmm0, oword [rsp]
	pandn	mmx0, mmx1
	pandn	mmx0, qword [rsp]

positive: vpandn instruction

	vpandn	xmm0, xmm1, xmm2
	vpandn	xmm0, xmm1, oword [rsp]
	vpandn	ymm0, ymm1, ymm2
	vpandn	ymm0, ymm1, hword [rsp]

positive: pavgb instruction

	pavgb	xmm0, xmm1
	pavgb	xmm0, oword [rsp]
	pavgb	mmx0, mmx1
	pavgb	mmx0, qword [rsp]

positive: vpavgb instruction

	vpavgb	xmm0, xmm1, xmm2
	vpavgb	xmm0, xmm1, oword [rsp]
	vpavgb	ymm0, ymm1, ymm2
	vpavgb	ymm0, ymm1, hword [rsp]

positive: pavgusb instruction

	pavgusb	mmx0, mmx1
	pavgusb	mmx0, qword [rsp]

positive: pavgw instruction

	pavgw	xmm0, xmm1
	pavgw	xmm0, oword [rsp]
	pavgw	mmx0, mmx1
	pavgw	mmx0, qword [rsp]

positive: vpavgw instruction

	vpavgw	xmm0, xmm1, xmm2
	vpavgw	xmm0, xmm1, oword [rsp]
	vpavgw	ymm0, ymm1, ymm2
	vpavgw	ymm0, ymm1, hword [rsp]

positive: pblendvb instruction

	pblendvb	xmm0, xmm1
	pblendvb	xmm0, oword [rsp]

positive: vpblendvb instruction

	vpblendvb	xmm0, xmm1, xmm2, xmm3
	vpblendvb	xmm0, xmm1, oword [rsp], xmm3
	vpblendvb	ymm0, ymm1, ymm2, ymm3
	vpblendvb	ymm0, ymm1, hword [rsp], ymm3

positive: pblendw instruction

	pblendw	xmm0, xmm1, byte 0
	pblendw	xmm0, oword [rsp], byte 255

positive: vpblendw instruction

	vpblendw	xmm0, xmm1, xmm2, byte 0
	vpblendw	xmm0, xmm1, oword [rsp], byte 255
	vpblendw	ymm0, ymm1, ymm2, byte 0
	vpblendw	ymm0, ymm1, hword [rsp], byte 255

positive: pclmulqdq instruction

	pclmulqdq	xmm0, xmm1, byte 0
	pclmulqdq	xmm0, oword [rsp], byte 255

positive: vpclmulqdq instruction

	vpclmulqdq	xmm0, xmm1, xmm2, byte 0
	vpclmulqdq	xmm0, xmm1, oword [rsp], byte 255

positive: pcmpeqb instruction

	pcmpeqb	xmm0, xmm1
	pcmpeqb	xmm0, oword [rsp]
	pcmpeqb	mmx0, mmx1
	pcmpeqb	mmx0, qword [rsp]

positive: vpcmpeqb instruction

	vpcmpeqb	xmm0, xmm1, xmm2
	vpcmpeqb	xmm0, xmm1, oword [rsp]
	vpcmpeqb	ymm0, ymm1, ymm2
	vpcmpeqb	ymm0, ymm1, hword [rsp]

positive: pcmpeqd instruction

	pcmpeqd	xmm0, xmm1
	pcmpeqd	xmm0, oword [rsp]
	pcmpeqd	mmx0, mmx1
	pcmpeqd	mmx0, qword [rsp]

positive: vpcmpeqd instruction

	vpcmpeqd	xmm0, xmm1, xmm2
	vpcmpeqd	xmm0, xmm1, oword [rsp]
	vpcmpeqd	ymm0, ymm1, ymm2
	vpcmpeqd	ymm0, ymm1, hword [rsp]

positive: pcmpeqq instruction

	pcmpeqq	xmm0, xmm1
	pcmpeqq	xmm0, oword [rsp]

positive: vpcmpeqq instruction

	vpcmpeqq	xmm0, xmm1, xmm2
	vpcmpeqq	xmm0, xmm1, oword [rsp]
	vpcmpeqq	ymm0, ymm1, ymm2
	vpcmpeqq	ymm0, ymm1, hword [rsp]

positive: pcmpeqw instruction

	pcmpeqw	xmm0, xmm1
	pcmpeqw	xmm0, oword [rsp]
	pcmpeqw	mmx0, mmx1
	pcmpeqw	mmx0, qword [rsp]

positive: vpcmpeqw instruction

	vpcmpeqw	xmm0, xmm1, xmm2
	vpcmpeqw	xmm0, xmm1, oword [rsp]
	vpcmpeqw	ymm0, ymm1, ymm2
	vpcmpeqw	ymm0, ymm1, hword [rsp]

positive: pcmpestri instruction

	pcmpestri	xmm0, xmm1, byte 0
	pcmpestri	xmm0, oword [rsp], byte 255

positive: vpcmpestri instruction

	vpcmpestri	xmm0, xmm1, byte 0
	vpcmpestri	xmm0, oword [rsp], byte 255

positive: pcmpestrm instruction

	pcmpestrm	xmm0, xmm1, byte 0
	pcmpestrm	xmm0, oword [rsp], byte 255

positive: vpcmpestrm instruction

	vpcmpestrm	xmm0, xmm1, byte 0
	vpcmpestrm	xmm0, oword [rsp], byte 255

positive: pcmpgtb instruction

	pcmpgtb	xmm0, xmm1
	pcmpgtb	xmm0, oword [rsp]
	pcmpgtb	mmx0, mmx1
	pcmpgtb	mmx0, qword [rsp]

positive: vpcmpgtb instruction

	vpcmpgtb	xmm0, xmm1, xmm2
	vpcmpgtb	xmm0, xmm1, oword [rsp]
	vpcmpgtb	ymm0, ymm1, ymm2
	vpcmpgtb	ymm0, ymm1, hword [rsp]

positive: pcmpgtd instruction

	pcmpgtd	xmm0, xmm1
	pcmpgtd	xmm0, oword [rsp]
	pcmpgtd	mmx0, mmx1
	pcmpgtd	mmx0, qword [rsp]

positive: vpcmpgtd instruction

	vpcmpgtd	xmm0, xmm1, xmm2
	vpcmpgtd	xmm0, xmm1, oword [rsp]
	vpcmpgtd	ymm0, ymm1, ymm2
	vpcmpgtd	ymm0, ymm1, hword [rsp]

positive: pcmpgtq instruction

	pcmpgtq	xmm0, xmm1
	pcmpgtq	xmm0, oword [rsp]

positive: vpcmpgtq instruction

	vpcmpgtq	xmm0, xmm1, xmm2
	vpcmpgtq	xmm0, xmm1, oword [rsp]
	vpcmpgtq	ymm0, ymm1, ymm2
	vpcmpgtq	ymm0, ymm1, hword [rsp]

positive: pcmpgtw instruction

	pcmpgtw	xmm0, xmm1
	pcmpgtw	xmm0, oword [rsp]
	pcmpgtw	mmx0, mmx1
	pcmpgtw	mmx0, qword [rsp]

positive: vpcmpgtw instruction

	vpcmpgtw	xmm0, xmm1, xmm2
	vpcmpgtw	xmm0, xmm1, oword [rsp]
	vpcmpgtw	ymm0, ymm1, ymm2
	vpcmpgtw	ymm0, ymm1, hword [rsp]

positive: pcmpistri instruction

	pcmpistri	xmm0, xmm1, byte 0
	pcmpistri	xmm0, oword [rsp], byte 255

positive: vpcmpistri instruction

	vpcmpistri	xmm0, xmm1, byte 0
	vpcmpistri	xmm0, oword [rsp], byte 255

positive: pcmpistrm instruction

	pcmpistrm	xmm0, xmm1, byte 0
	pcmpistrm	xmm0, oword [rsp], byte 255

positive: vpcmpistrm instruction

	vpcmpistrm	xmm0, xmm1, byte 0
	vpcmpistrm	xmm0, oword [rsp], byte 255

positive: pextrb instruction

	pextrb	bl, xmm0, byte 0
	pextrb	byte [rsp], xmm0, byte 255

positive: vpextrb instruction

	vpextrb	bl, xmm0, byte 0
	vpextrb	byte [rsp], xmm0, byte 255

positive: pextrd instruction

	pextrd	ebx, xmm0, byte 0
	pextrd	dword [rsp], xmm0, byte 255

positive: vpextrd instruction

	vpextrd	ebx, xmm0, byte 0
	vpextrd	dword [rsp], xmm0, byte 255

positive: pextrq instruction

	pextrq	rbx, xmm0, byte 0
	pextrq	qword [rsp], xmm0, byte 255

positive: vpextrq instruction

	vpextrq	rbx, xmm0, byte 0
	vpextrq	qword [rsp], xmm0, byte 255

positive: pextrw instruction

	pextrw	ecx, xmm0, byte 0
	pextrw	ecx, mmx0, byte 0
	pextrw	cx, xmm0, byte 0
	pextrw	word [rsp], xmm0, byte 255

positive: vpextrw instruction

	vpextrw	ecx, xmm0, byte 0
	vpextrw	ecx, xmm0, byte 255
	vpextrw	cx, xmm0, byte 0
	vpextrw	word [rsp], xmm0, byte 255

positive: pf2id instruction

	pf2id	mmx0, mmx1
	pf2id	mmx0, qword [rsp]

positive: pf2iw instruction

	pf2iw	mmx0, mmx1
	pf2iw	mmx0, qword [rsp]

positive: pfacc instruction

	pfacc	mmx0, mmx1
	pfacc	mmx0, qword [rsp]

positive: pfadd instruction

	pfadd	mmx0, mmx1
	pfadd	mmx0, qword [rsp]

positive: pfcmpeq instruction

	pfcmpeq	mmx0, mmx1
	pfcmpeq	mmx0, qword [rsp]

positive: pfcmpge instruction

	pfcmpge	mmx0, mmx1
	pfcmpge	mmx0, qword [rsp]

positive: pfcmpgt instruction

	pfcmpgt	mmx0, mmx1
	pfcmpgt	mmx0, qword [rsp]

positive: pfmax instruction

	pfmax	mmx0, mmx1
	pfmax	mmx0, qword [rsp]

positive: pfmin instruction

	pfmin	mmx0, mmx1
	pfmin	mmx0, qword [rsp]

positive: pfmul instruction

	pfmul	mmx0, mmx1
	pfmul	mmx0, qword [rsp]

positive: pfnacc instruction

	pfnacc	mmx0, mmx1
	pfnacc	mmx0, qword [rsp]

positive: pfpnacc instruction

	pfpnacc	mmx0, mmx1
	pfpnacc	mmx0, qword [rsp]

positive: pfrcp instruction

	pfrcp	mmx0, mmx1
	pfrcp	mmx0, qword [rsp]

positive: pfrcpit1 instruction

	pfrcpit1	mmx0, mmx1
	pfrcpit1	mmx0, qword [rsp]

positive: pfrcpit2 instruction

	pfrcpit2	mmx0, mmx1
	pfrcpit2	mmx0, qword [rsp]

positive: pfrsqit1 instruction

	pfrsqit1	mmx0, mmx1
	pfrsqit1	mmx0, qword [rsp]

positive: pfrsqrt instruction

	pfrsqrt	mmx0, mmx1
	pfrsqrt	mmx0, qword [rsp]

positive: pfsub instruction

	pfsub	mmx0, mmx1
	pfsub	mmx0, qword [rsp]

positive: pfsubr instruction

	pfsubr	mmx0, mmx1
	pfsubr	mmx0, qword [rsp]

positive: pi2fd instruction

	pi2fd	mmx0, mmx1
	pi2fd	mmx0, qword [rsp]

positive: pi2fw instruction

	pi2fw	mmx0, mmx1
	pi2fw	mmx0, qword [rsp]

positive: pinsrb instruction

	pinsrb	xmm0, cl, byte 0
	pinsrb	xmm0, byte [rsp], byte 255

positive: vpinsrb instruction

	vpinsrb	xmm0, cl, xmm2, byte 0
	vpinsrb	xmm0, byte [rsp], xmm2, byte 255

positive: pinsrd instruction

	pinsrd	xmm0, ecx, byte 0
	pinsrd	xmm0, dword [rsp], byte 255

positive: vpinsrd instruction

	vpinsrd	xmm0, ecx, xmm2, byte 0
	vpinsrd	xmm0, dword [rsp], xmm2, byte 255

positive: pinsrq instruction

	pinsrq	xmm0, rcx, byte 0
	pinsrq	xmm0, qword [rsp], byte 255

positive: vpinsrq instruction

	vpinsrq	xmm0, rcx, xmm2, byte 0
	vpinsrq	xmm0, qword [rsp], xmm2, byte 255

positive: pinsrw instruction

	pinsrw	xmm0, ecx, byte 0
	pinsrw	xmm0, dword [rsp], byte 255
	pinsrw	mmx0, ecx, byte 0
	pinsrw	mmx0, dword [rsp], byte 255

positive: vpinsrw instruction

	vpinsrw	xmm0, ecx, xmm2, byte 0
	vpinsrw	xmm0, dword [rsp], xmm2, byte 255

positive: phaddd instruction

	phaddd	xmm0, xmm1
	phaddd	xmm0, oword [rsp]

positive: vphaddd instruction

	vphaddd	xmm0, xmm1, xmm2
	vphaddd	xmm0, xmm1, oword [rsp]
	vphaddd	ymm0, ymm1, ymm2
	vphaddd	ymm0, ymm1, hword [rsp]

positive: phaddsw instruction

	phaddsw	xmm0, xmm1
	phaddsw	xmm0, oword [rsp]

positive: vphaddsw instruction

	vphaddsw	xmm0, xmm1, xmm2
	vphaddsw	xmm0, xmm1, oword [rsp]
	vphaddsw	ymm0, ymm1, ymm2
	vphaddsw	ymm0, ymm1, hword [rsp]

positive: phaddw instruction

	phaddw	xmm0, xmm1
	phaddw	xmm0, oword [rsp]

positive: vphaddw instruction

	vphaddw	xmm0, xmm1, xmm2
	vphaddw	xmm0, xmm1, oword [rsp]
	vphaddw	ymm0, ymm1, ymm2
	vphaddw	ymm0, ymm1, hword [rsp]

positive: phminposuw instruction

	phminposuw	xmm0, xmm1
	phminposuw	xmm0, oword [rsp]

positive: vphminposuw instruction

	vphminposuw	xmm0, xmm1
	vphminposuw	xmm0, oword [rsp]

positive: phsubd instruction

	phsubd	xmm0, xmm1
	phsubd	xmm0, oword [rsp]

positive: vphsubd instruction

	vphsubd	xmm0, xmm1, xmm2
	vphsubd	xmm0, xmm1, oword [rsp]
	vphsubd	ymm0, ymm1, ymm2
	vphsubd	ymm0, ymm1, hword [rsp]

positive: phsubsw instruction

	phsubsw	xmm0, xmm1
	phsubsw	xmm0, oword [rsp]

positive: vphsubsw instruction

	vphsubsw	xmm0, xmm1, xmm2
	vphsubsw	xmm0, xmm1, oword [rsp]
	vphsubsw	ymm0, ymm1, ymm2
	vphsubsw	ymm0, ymm1, hword [rsp]

positive: phsubw instruction

	phsubw	xmm0, xmm1
	phsubw	xmm0, oword [rsp]

positive: vphsubw instruction

	vphsubw	xmm0, xmm1, xmm2
	vphsubw	xmm0, xmm1, oword [rsp]
	vphsubw	ymm0, ymm1, ymm2
	vphsubw	ymm0, ymm1, hword [rsp]

positive: pmaddubsw instruction

	pmaddubsw	xmm0, xmm1
	pmaddubsw	xmm0, oword [rsp]

positive: vpmaddubsw instruction

	vpmaddubsw	xmm0, xmm1, xmm2
	vpmaddubsw	xmm0, xmm1, oword [rsp]
	vpmaddubsw	ymm0, ymm1, ymm2
	vpmaddubsw	ymm0, ymm1, hword [rsp]

positive: pmaddwd instruction

	pmaddwd	xmm0, xmm1
	pmaddwd	xmm0, oword [rsp]
	pmaddwd	mmx0, mmx1
	pmaddwd	mmx0, qword [rsp]

positive: vpmaddwd instruction

	vpmaddwd	xmm0, xmm1, xmm2
	vpmaddwd	xmm0, xmm1, oword [rsp]
	vpmaddwd	ymm0, ymm1, ymm2
	vpmaddwd	ymm0, ymm1, hword [rsp]

positive: pmaxsb instruction

	pmaxsb	xmm0, xmm1
	pmaxsb	xmm0, oword [rsp]

positive: vpmaxsb instruction

	vpmaxsb	xmm0, xmm1, xmm2
	vpmaxsb	xmm0, xmm1, oword [rsp]
	vpmaxsb	ymm0, ymm1, ymm2
	vpmaxsb	ymm0, ymm1, hword [rsp]

positive: pmaxsd instruction

	pmaxsd	xmm0, xmm1
	pmaxsd	xmm0, oword [rsp]

positive: vpmaxsd instruction

	vpmaxsd	xmm0, xmm1, xmm2
	vpmaxsd	xmm0, xmm1, oword [rsp]
	vpmaxsd	ymm0, ymm1, ymm2
	vpmaxsd	ymm0, ymm1, hword [rsp]

positive: pmaxsw instruction

	pmaxsw	xmm0, xmm1
	pmaxsw	xmm0, oword [rsp]
	pmaxsw	mmx0, mmx1
	pmaxsw	mmx0, qword [rsp]

positive: vpmaxsw instruction

	vpmaxsw	xmm0, xmm1, xmm2
	vpmaxsw	xmm0, xmm1, oword [rsp]
	vpmaxsw	ymm0, ymm1, ymm2
	vpmaxsw	ymm0, ymm1, hword [rsp]

positive: pmaxub instruction

	pmaxub	xmm0, xmm1
	pmaxub	xmm0, oword [rsp]
	pmaxub	mmx0, mmx1
	pmaxub	mmx0, qword [rsp]

positive: vpmaxub instruction

	vpmaxub	xmm0, xmm1, xmm2
	vpmaxub	xmm0, xmm1, oword [rsp]
	vpmaxub	ymm0, ymm1, ymm2
	vpmaxub	ymm0, ymm1, hword [rsp]

positive: pmaxud instruction

	pmaxud	xmm0, xmm1
	pmaxud	xmm0, oword [rsp]

positive: vpmaxud instruction

	vpmaxud	xmm0, xmm1, xmm2
	vpmaxud	xmm0, xmm1, oword [rsp]
	vpmaxud	ymm0, ymm1, ymm2
	vpmaxud	ymm0, ymm1, hword [rsp]

positive: pmaxuw instruction

	pmaxuw	xmm0, xmm1
	pmaxuw	xmm0, oword [rsp]

positive: vpmaxuw instruction

	vpmaxuw	xmm0, xmm1, xmm2
	vpmaxuw	xmm0, xmm1, oword [rsp]
	vpmaxuw	ymm0, ymm1, ymm2
	vpmaxuw	ymm0, ymm1, hword [rsp]

positive: pminsb instruction

	pminsb	xmm0, xmm1
	pminsb	xmm0, oword [rsp]

positive: vpminsb instruction

	vpminsb	xmm0, xmm1, xmm2
	vpminsb	xmm0, xmm1, oword [rsp]
	vpminsb	ymm0, ymm1, ymm2
	vpminsb	ymm0, ymm1, hword [rsp]

positive: pminsd instruction

	pminsd	xmm0, xmm1
	pminsd	xmm0, oword [rsp]

positive: vpminsd instruction

	vpminsd	xmm0, xmm1, xmm2
	vpminsd	xmm0, xmm1, oword [rsp]
	vpminsd	ymm0, ymm1, ymm2
	vpminsd	ymm0, ymm1, hword [rsp]

positive: pminsw instruction

	pminsw	xmm0, xmm1
	pminsw	xmm0, oword [rsp]
	pminsw	mmx0, mmx1
	pminsw	mmx0, qword [rsp]

positive: vpminsw instruction

	vpminsw	xmm0, xmm1, xmm2
	vpminsw	xmm0, xmm1, oword [rsp]
	vpminsw	ymm0, ymm1, ymm2
	vpminsw	ymm0, ymm1, hword [rsp]

positive: pminub instruction

	pminub	xmm0, xmm1
	pminub	xmm0, oword [rsp]
	pminub	mmx0, mmx1
	pminub	mmx0, qword [rsp]

positive: vpminub instruction

	vpminub	xmm0, xmm1, xmm2
	vpminub	xmm0, xmm1, oword [rsp]
	vpminub	ymm0, ymm1, ymm2
	vpminub	ymm0, ymm1, hword [rsp]

positive: pminud instruction

	pminud	xmm0, xmm1
	pminud	xmm0, oword [rsp]

positive: vpminud instruction

	vpminud	xmm0, xmm1, xmm2
	vpminud	xmm0, xmm1, oword [rsp]
	vpminud	ymm0, ymm1, ymm2
	vpminud	ymm0, ymm1, hword [rsp]

positive: pminuw instruction

	pminuw	xmm0, xmm1
	pminuw	xmm0, oword [rsp]

positive: vpminuw instruction

	vpminuw	xmm0, xmm1, xmm2
	vpminuw	xmm0, xmm1, oword [rsp]
	vpminuw	ymm0, ymm1, ymm2
	vpminuw	ymm0, ymm1, hword [rsp]

positive: pmovmskb instruction

	pmovmskb	ecx, xmm1
	pmovmskb	ecx, mmx1

positive: vpmovmskb instruction

	vpmovmskb	rcx, xmm1
	vpmovmskb	rcx, ymm1

positive: pmovsxbd instruction

	pmovsxbd	xmm0, xmm1
	pmovsxbd	xmm0, dword [rsp]

positive: vpmovsxbd instruction

	vpmovsxbd	xmm0, xmm1
	vpmovsxbd	xmm0, dword [rsp]
	vpmovsxbd	ymm0, xmm1
	vpmovsxbd	ymm0, qword [rsp]

positive: pmovsxbq instruction

	pmovsxbq	xmm0, xmm1
	pmovsxbq	xmm0, word [rsp]

positive: vpmovsxbq instruction

	vpmovsxbq	xmm0, xmm1
	vpmovsxbq	xmm0, word [rsp]
	vpmovsxbq	ymm0, xmm1
	vpmovsxbq	ymm0, dword [rsp]

positive: pmovsxbw instruction

	pmovsxbw	xmm0, xmm1
	pmovsxbw	xmm0, qword [rsp]

positive: vpmovsxbw instruction

	vpmovsxbw	xmm0, xmm1
	vpmovsxbw	xmm0, qword [rsp]
	vpmovsxbw	ymm0, xmm1
	vpmovsxbw	ymm0, oword [rsp]

positive: pmovsxdq instruction

	pmovsxdq	xmm0, xmm1
	pmovsxdq	xmm0, qword [rsp]

positive: vpmovsxdq instruction

	vpmovsxdq	xmm0, xmm1
	vpmovsxdq	xmm0, qword [rsp]
	vpmovsxdq	ymm0, xmm1
	vpmovsxdq	ymm0, oword [rsp]

positive: pmovsxwd instruction

	pmovsxwd	xmm0, xmm1
	pmovsxwd	xmm0, qword [rsp]

positive: vpmovsxwd instruction

	vpmovsxwd	xmm0, xmm1
	vpmovsxwd	xmm0, qword [rsp]
	vpmovsxwd	ymm0, xmm1
	vpmovsxwd	ymm0, oword [rsp]

positive: pmovsxwq instruction

	pmovsxwq	xmm0, xmm1
	pmovsxwq	xmm0, dword [rsp]

positive: vpmovsxwq instruction

	vpmovsxwq	xmm0, xmm1
	vpmovsxwq	xmm0, dword [rsp]
	vpmovsxwq	ymm0, xmm1
	vpmovsxwq	ymm0, qword [rsp]

positive: pmovzxbd instruction

	pmovzxbd	xmm0, xmm1
	pmovzxbd	xmm0, dword [rsp]

positive: vpmovzxbd instruction

	vpmovzxbd	xmm0, xmm1
	vpmovzxbd	xmm0, dword [rsp]
	vpmovzxbd	ymm0, xmm1
	vpmovzxbd	ymm0, qword [rsp]

positive: pmovzxbq instruction

	pmovzxbq	xmm0, xmm1
	pmovzxbq	xmm0, word [rsp]

positive: vpmovzxbq instruction

	vpmovzxbq	xmm0, xmm1
	vpmovzxbq	xmm0, word [rsp]
	vpmovzxbq	ymm0, xmm1
	vpmovzxbq	ymm0, dword [rsp]

positive: pmovzxbw instruction

	pmovzxbw	xmm0, xmm1
	pmovzxbw	xmm0, qword [rsp]

positive: vpmovzxbw instruction

	vpmovzxbw	xmm0, xmm1
	vpmovzxbw	xmm0, qword [rsp]
	vpmovzxbw	ymm0, xmm1
	vpmovzxbw	ymm0, oword [rsp]

positive: pmovzxdq instruction

	pmovzxdq	xmm0, xmm1
	pmovzxdq	xmm0, qword [rsp]

positive: vpmovzxdq instruction

	vpmovzxdq	xmm0, xmm1
	vpmovzxdq	xmm0, qword [rsp]
	vpmovzxdq	ymm0, xmm1
	vpmovzxdq	ymm0, oword [rsp]

positive: pmovzxwd instruction

	pmovzxwd	xmm0, xmm1
	pmovzxwd	xmm0, qword [rsp]

positive: vpmovzxwd instruction

	vpmovzxwd	xmm0, xmm1
	vpmovzxwd	xmm0, qword [rsp]
	vpmovzxwd	ymm0, xmm1
	vpmovzxwd	ymm0, oword [rsp]

positive: pmovzxwq instruction

	pmovzxwq	xmm0, xmm1
	pmovzxwq	xmm0, dword [rsp]

positive: vpmovzxwq instruction

	vpmovzxwq	xmm0, xmm1
	vpmovzxwq	xmm0, dword [rsp]
	vpmovzxwq	ymm0, xmm1
	vpmovzxwq	ymm0, qword [rsp]

positive: pmuldq instruction

	pmuldq	xmm0, xmm1
	pmuldq	xmm0, oword [rsp]

positive: vpmuldq instruction

	vpmuldq	xmm0, xmm1, xmm2
	vpmuldq	xmm0, xmm1, oword [rsp]
	vpmuldq	ymm0, ymm1, ymm2
	vpmuldq	ymm0, ymm1, hword [rsp]

positive: pmulhrsw instruction

	pmulhrsw	xmm0, xmm1
	pmulhrsw	xmm0, oword [rsp]

positive: vpmulhrsw instruction

	vpmulhrsw	xmm0, xmm1, xmm2
	vpmulhrsw	xmm0, xmm1, oword [rsp]
	vpmulhrsw	ymm0, ymm1, ymm2
	vpmulhrsw	ymm0, ymm1, hword [rsp]

positive: pmulhrw instruction

	pmulhrw	mmx0, mmx1
	pmulhrw	mmx0, qword [rsp]

positive: pmulhuw instruction

	pmulhuw	xmm0, xmm1
	pmulhuw	xmm0, oword [rsp]
	pmulhuw	mmx0, mmx1
	pmulhuw	mmx0, qword [rsp]

positive: vpmulhuw instruction

	vpmulhuw	xmm0, xmm1, xmm2
	vpmulhuw	xmm0, xmm1, oword [rsp]
	vpmulhuw	ymm0, ymm1, ymm2
	vpmulhuw	ymm0, ymm1, hword [rsp]

positive: pmulhw instruction

	pmulhw	xmm0, xmm1
	pmulhw	xmm0, oword [rsp]
	pmulhw	mmx0, mmx1
	pmulhw	mmx0, qword [rsp]

positive: vpmulhw instruction

	vpmulhw	xmm0, xmm1, xmm2
	vpmulhw	xmm0, xmm1, oword [rsp]
	vpmulhw	ymm0, ymm1, ymm2
	vpmulhw	ymm0, ymm1, hword [rsp]

positive: pmulld instruction

	pmulld	xmm0, xmm1
	pmulld	xmm0, oword [rsp]

positive: vpmulld instruction

	vpmulld	xmm0, xmm1, xmm2
	vpmulld	xmm0, xmm1, oword [rsp]
	vpmulld	ymm0, ymm1, ymm2
	vpmulld	ymm0, ymm1, hword [rsp]

positive: pmullw instruction

	pmullw	xmm0, xmm1
	pmullw	xmm0, oword [rsp]
	pmullw	mmx0, mmx1
	pmullw	mmx0, qword [rsp]

positive: vpmullw instruction

	vpmullw	xmm0, xmm1, xmm2
	vpmullw	xmm0, xmm1, oword [rsp]
	vpmullw	ymm0, ymm1, ymm2
	vpmullw	ymm0, ymm1, hword [rsp]

positive: pmuludq instruction

	pmuludq	xmm0, xmm1
	pmuludq	xmm0, oword [rsp]
	pmuludq	mmx0, mmx1
	pmuludq	mmx0, qword [rsp]

positive: vpmuludq instruction

	vpmuludq	xmm0, xmm1, xmm2
	vpmuludq	xmm0, xmm1, oword [rsp]
	vpmuludq	ymm0, ymm1, ymm2
	vpmuludq	ymm0, ymm1, hword [rsp]

positive: por instruction

	por	xmm0, xmm1
	por	xmm0, oword [rsp]
	por	mmx0, mmx1
	por	mmx0, qword [rsp]

positive: vpor instruction

	vpor	xmm0, xmm1, xmm2
	vpor	xmm0, xmm1, oword [rsp]
	vpor	ymm0, ymm1, ymm2
	vpor	ymm0, ymm1, hword [rsp]

positive: psadbw instruction

	psadbw	xmm0, xmm1
	psadbw	xmm0, oword [rsp]
	psadbw	mmx0, mmx1
	psadbw	mmx0, qword [rsp]

positive: vpsadbw instruction

	vpsadbw	xmm0, xmm1, xmm2
	vpsadbw	xmm0, xmm1, oword [rsp]
	vpsadbw	ymm0, ymm1, ymm2
	vpsadbw	ymm0, ymm1, hword [rsp]

positive: pshufb instruction

	pshufb	xmm0, xmm1
	pshufb	xmm0, oword [rsp]

positive: vpshufb instruction

	vpshufb	xmm0, xmm1, xmm2
	vpshufb	xmm0, xmm1, oword [rsp]
	vpshufb	ymm0, ymm1, ymm2
	vpshufb	ymm0, ymm1, hword [rsp]

positive: pshufd instruction

	pshufd	xmm0, xmm1, byte 0
	pshufd	xmm0, oword [rsp], byte 255

positive: vpshufd instruction

	vpshufd	xmm0, xmm1, byte 0
	vpshufd	xmm0, oword [rsp], byte 255
	vpshufd	ymm0, ymm1, byte 0
	vpshufd	ymm0, hword [rsp], byte 255

positive: pshufhw instruction

	pshufhw	xmm0, xmm1, byte 0
	pshufhw	xmm0, oword [rsp], byte 255

positive: vpshufhw instruction

	vpshufhw	xmm0, xmm1, byte 0
	vpshufhw	xmm0, oword [rsp], byte 255
	vpshufhw	ymm0, ymm1, byte 0
	vpshufhw	ymm0, hword [rsp], byte 255

positive: pshuflw instruction

	pshuflw	xmm0, xmm1, byte 0
	pshuflw	xmm0, oword [rsp], byte 255

positive: vpshuflw instruction

	vpshuflw	xmm0, xmm1, byte 0
	vpshuflw	xmm0, oword [rsp], byte 255
	vpshuflw	ymm0, ymm1, byte 0
	vpshuflw	ymm0, hword [rsp], byte 255

positive: pshufw instruction

	pshufw	mmx0, mmx1, byte 0
	pshufw	mmx0, qword [rsp], byte 255

positive: psignb instruction

	psignb	xmm0, xmm1
	psignb	xmm0, oword [rsp]

positive: vpsignb instruction

	vpsignb	xmm0, xmm1, xmm2
	vpsignb	xmm0, xmm1, oword [rsp]
	vpsignb	ymm0, ymm1, ymm2
	vpsignb	ymm0, ymm1, hword [rsp]

positive: psignd instruction

	psignd	xmm0, xmm1
	psignd	xmm0, oword [rsp]

positive: vpsignd instruction

	vpsignd	xmm0, xmm1, xmm2
	vpsignd	xmm0, xmm1, oword [rsp]
	vpsignd	ymm0, ymm1, ymm2
	vpsignd	ymm0, ymm1, hword [rsp]

positive: psignw instruction

	psignw	xmm0, xmm1
	psignw	xmm0, oword [rsp]

positive: vpsignw instruction

	vpsignw	xmm0, xmm1, xmm2
	vpsignw	xmm0, xmm1, oword [rsp]
	vpsignw	ymm0, ymm1, ymm2
	vpsignw	ymm0, ymm1, hword [rsp]

positive: pslld instruction

	pslld	xmm0, xmm1
	pslld	xmm0, oword [rsp]
	pslld	xmm0, byte 0
	pslld	xmm0, byte 255
	pslld	mmx0, mmx1
	pslld	mmx0, qword [rsp]
	pslld	mmx0, byte 0
	pslld	mmx0, byte 255

positive: vpslld instruction

	vpslld	xmm0, xmm1, xmm2
	vpslld	xmm0, xmm1, oword [rsp]
	vpslld	xmm0, xmm1, byte 0
	vpslld	xmm0, xmm1, byte 255
	vpslld	ymm0, ymm1, xmm2
	vpslld	ymm0, ymm1, oword [rsp]
	vpslld	ymm0, ymm1, byte 0
	vpslld	ymm0, ymm1, byte 255

positive: pslldq instruction

	pslldq	xmm0, byte 0
	pslldq	xmm0, byte 255

positive: vpslldq instruction

	vpslldq	xmm0, xmm1, byte 0
	vpslldq	xmm0, xmm1, byte 255
	vpslldq	ymm0, ymm1, byte 0
	vpslldq	ymm0, ymm1, byte 255

positive: psllq instruction

	psllq	xmm0, xmm1
	psllq	xmm0, oword [rsp]
	psllq	xmm0, byte 0
	psllq	xmm0, byte 255
	psllq	mmx0, mmx1
	psllq	mmx0, qword [rsp]
	psllq	mmx0, byte 0
	psllq	mmx0, byte 255

positive: vpsllq instruction

	vpsllq	xmm0, xmm1, xmm2
	vpsllq	xmm0, xmm1, oword [rsp]
	vpsllq	xmm0, xmm1, byte 0
	vpsllq	xmm0, xmm1, byte 255
	vpsllq	ymm0, ymm1, xmm2
	vpsllq	ymm0, ymm1, oword [rsp]
	vpsllq	ymm0, ymm1, byte 0
	vpsllq	ymm0, ymm1, byte 255

positive: psllw instruction

	psllw	xmm0, xmm1
	psllw	xmm0, oword [rsp]
	psllw	xmm0, byte 0
	psllw	xmm0, byte 255
	psllw	mmx0, mmx1
	psllw	mmx0, qword [rsp]
	psllw	mmx0, byte 0
	psllw	mmx0, byte 255

positive: vpsllw instruction

	vpsllw	xmm0, xmm1, xmm2
	vpsllw	xmm0, xmm1, oword [rsp]
	vpsllw	xmm0, xmm1, byte 0
	vpsllw	xmm0, xmm1, byte 255
	vpsllw	ymm0, ymm1, xmm2
	vpsllw	ymm0, ymm1, oword [rsp]
	vpsllw	ymm0, ymm1, byte 0
	vpsllw	ymm0, ymm1, byte 255

positive: psrad instruction

	psrad	xmm0, xmm1
	psrad	xmm0, oword [rsp]
	psrad	xmm0, byte 0
	psrad	xmm0, byte 255
	psrad	mmx0, mmx1
	psrad	mmx0, qword [rsp]
	psrad	mmx0, byte 0
	psrad	mmx0, byte 255

positive: vpsrad instruction

	vpsrad	xmm0, xmm1, xmm2
	vpsrad	xmm0, xmm1, oword [rsp]
	vpsrad	xmm0, xmm1, byte 0
	vpsrad	xmm0, xmm1, byte 255
	vpsrad	ymm0, ymm1, xmm2
	vpsrad	ymm0, ymm1, oword [rsp]
	vpsrad	ymm0, ymm1, byte 0
	vpsrad	ymm0, ymm1, byte 255

positive: psraw instruction

	psraw	xmm0, xmm1
	psraw	xmm0, oword [rsp]
	psraw	xmm0, byte 0
	psraw	xmm0, byte 255
	psraw	mmx0, mmx1
	psraw	mmx0, qword [rsp]
	psraw	mmx0, byte 0
	psraw	mmx0, byte 255

positive: vpsraw instruction

	vpsraw	xmm0, xmm1, xmm2
	vpsraw	xmm0, xmm1, oword [rsp]
	vpsraw	xmm0, xmm1, byte 0
	vpsraw	xmm0, xmm1, byte 255
	vpsraw	ymm0, ymm1, xmm2
	vpsraw	ymm0, ymm1, oword [rsp]
	vpsraw	ymm0, ymm1, byte 0
	vpsraw	ymm0, ymm1, byte 255

positive: psrld instruction

	psrld	xmm0, xmm1
	psrld	xmm0, oword [rsp]
	psrld	xmm0, byte 0
	psrld	xmm0, byte 255
	psrld	mmx0, mmx1
	psrld	mmx0, qword [rsp]
	psrld	mmx0, byte 0
	psrld	mmx0, byte 255

positive: vpsrld instruction

	vpsrld	xmm0, xmm1, xmm2
	vpsrld	xmm0, xmm1, oword [rsp]
	vpsrld	xmm0, xmm1, byte 0
	vpsrld	xmm0, xmm1, byte 255
	vpsrld	ymm0, ymm1, xmm2
	vpsrld	ymm0, ymm1, oword [rsp]
	vpsrld	ymm0, ymm1, byte 0
	vpsrld	ymm0, ymm1, byte 255

positive: psrldq instruction

	psrldq	xmm0, byte 0
	psrldq	xmm0, byte 255

positive: vpsrldq instruction

	vpsrldq	xmm0, xmm1, byte 0
	vpsrldq	xmm0, xmm1, byte 255
	vpsrldq	ymm0, ymm1, byte 0
	vpsrldq	ymm0, ymm1, byte 255

positive: psrlq instruction

	psrlq	xmm0, xmm1
	psrlq	xmm0, oword [rsp]
	psrlq	xmm0, byte 0
	psrlq	xmm0, byte 255
	psrlq	mmx0, mmx1
	psrlq	mmx0, qword [rsp]
	psrlq	mmx0, byte 0
	psrlq	mmx0, byte 255

positive: vpsrlq instruction

	vpsrlq	xmm0, xmm1, xmm2
	vpsrlq	xmm0, xmm1, oword [rsp]
	vpsrlq	xmm0, xmm1, byte 0
	vpsrlq	xmm0, xmm1, byte 255
	vpsrlq	ymm0, ymm1, xmm2
	vpsrlq	ymm0, ymm1, oword [rsp]
	vpsrlq	ymm0, ymm1, byte 0
	vpsrlq	ymm0, ymm1, byte 255

positive: psrlw instruction

	psrlw	xmm0, xmm1
	psrlw	xmm0, oword [rsp]
	psrlw	xmm0, byte 0
	psrlw	xmm0, byte 255
	psrlw	mmx0, mmx1
	psrlw	mmx0, qword [rsp]
	psrlw	mmx0, byte 0
	psrlw	mmx0, byte 255

positive: vpsrlw instruction

	vpsrlw	xmm0, xmm1, xmm2
	vpsrlw	xmm0, xmm1, oword [rsp]
	vpsrlw	xmm0, xmm1, byte 0
	vpsrlw	xmm0, xmm1, byte 255
	vpsrlw	ymm0, ymm1, xmm2
	vpsrlw	ymm0, ymm1, oword [rsp]
	vpsrlw	ymm0, ymm1, byte 0
	vpsrlw	ymm0, ymm1, byte 255

positive: psubb instruction

	psubb	xmm0, xmm1
	psubb	xmm0, oword [rsp]
	psubb	mmx0, mmx1
	psubb	mmx0, qword [rsp]

positive: vpsubb instruction

	vpsubb	xmm0, xmm1, xmm2
	vpsubb	xmm0, xmm1, oword [rsp]
	vpsubb	ymm0, ymm1, ymm2
	vpsubb	ymm0, ymm1, hword [rsp]

positive: psubd instruction

	psubd	xmm0, xmm1
	psubd	xmm0, oword [rsp]
	psubd	mmx0, mmx1
	psubd	mmx0, qword [rsp]

positive: vpsubd instruction

	vpsubd	xmm0, xmm1, xmm2
	vpsubd	xmm0, xmm1, oword [rsp]
	vpsubd	ymm0, ymm1, ymm2
	vpsubd	ymm0, ymm1, hword [rsp]

positive: psubq instruction

	psubq	xmm0, xmm1
	psubq	xmm0, oword [rsp]
	psubq	mmx0, mmx1
	psubq	mmx0, qword [rsp]

positive: vpsubq instruction

	vpsubq	xmm0, xmm1, xmm2
	vpsubq	xmm0, xmm1, oword [rsp]
	vpsubq	ymm0, ymm1, ymm2
	vpsubq	ymm0, ymm1, hword [rsp]

positive: psubsb instruction

	psubsb	xmm0, xmm1
	psubsb	xmm0, oword [rsp]
	psubsb	mmx0, mmx1
	psubsb	mmx0, qword [rsp]

positive: vpsubsb instruction

	vpsubsb	xmm0, xmm1, xmm2
	vpsubsb	xmm0, xmm1, oword [rsp]
	vpsubsb	ymm0, ymm1, ymm2
	vpsubsb	ymm0, ymm1, hword [rsp]

positive: psubsw instruction

	psubsw	xmm0, xmm1
	psubsw	xmm0, oword [rsp]
	psubsw	mmx0, mmx1
	psubsw	mmx0, qword [rsp]

positive: vpsubsw instruction

	vpsubsw	xmm0, xmm1, xmm2
	vpsubsw	xmm0, xmm1, oword [rsp]
	vpsubsw	ymm0, ymm1, ymm2
	vpsubsw	ymm0, ymm1, hword [rsp]

positive: psubusb instruction

	psubusw	xmm0, xmm1
	psubusw	xmm0, oword [rsp]
	psubusw	mmx0, mmx1
	psubusw	mmx0, qword [rsp]

positive: vpsubusb instruction

	vpsubusb	xmm0, xmm1, xmm2
	vpsubusb	xmm0, xmm1, oword [rsp]
	vpsubusb	ymm0, ymm1, ymm2
	vpsubusb	ymm0, ymm1, hword [rsp]

positive: psubusw instruction

	psubusw	xmm0, xmm1
	psubusw	xmm0, oword [rsp]
	psubusw	mmx0, mmx1
	psubusw	mmx0, qword [rsp]

positive: vpsubusw instruction

	vpsubusw	xmm0, xmm1, xmm2
	vpsubusw	xmm0, xmm1, oword [rsp]
	vpsubusw	ymm0, ymm1, ymm2
	vpsubusw	ymm0, ymm1, hword [rsp]

positive: psubw instruction

	psubw	xmm0, xmm1
	psubw	xmm0, oword [rsp]
	psubw	mmx0, mmx1
	psubw	mmx0, qword [rsp]

positive: vpsubw instruction

	vpsubw	xmm0, xmm1, xmm2
	vpsubw	xmm0, xmm1, oword [rsp]
	vpsubw	ymm0, ymm1, ymm2
	vpsubw	ymm0, ymm1, hword [rsp]

positive: pswapd instruction

	pswapd	mmx0, mmx1
	pswapd	mmx0, qword [rsp]

positive: ptest instruction

	ptest	xmm0, xmm1
	ptest	xmm0, oword [rsp]

positive: vptest instruction

	vptest	xmm0, xmm1
	vptest	xmm0, oword [rsp]
	vptest	ymm0, ymm1
	vptest	ymm0, hword [rsp]

positive: punpckhbw instruction

	punpckhbw	xmm0, xmm1
	punpckhbw	xmm0, oword [rsp]
	punpckhbw	mmx0, mmx1
	punpckhbw	mmx0, qword [rsp]

positive: vpunpckhbw instruction

	vpunpckhbw	xmm0, xmm1, xmm2
	vpunpckhbw	xmm0, xmm1, oword [rsp]
	vpunpckhbw	ymm0, ymm1, ymm2
	vpunpckhbw	ymm0, ymm1, hword [rsp]

positive: punpckhdq instruction

	punpckhdq	xmm0, xmm1
	punpckhdq	xmm0, oword [rsp]
	punpckhdq	mmx0, mmx1
	punpckhdq	mmx0, qword [rsp]

positive: vpunpckhdq instruction

	vpunpckhdq	xmm0, xmm1, xmm2
	vpunpckhdq	xmm0, xmm1, oword [rsp]
	vpunpckhdq	ymm0, ymm1, ymm2
	vpunpckhdq	ymm0, ymm1, hword [rsp]

positive: punpckhqdq instruction

	punpckhqdq	xmm0, xmm1
	punpckhqdq	xmm0, oword [rsp]

positive: vpunpckhqdq instruction

	vpunpckhqdq	xmm0, xmm1, xmm2
	vpunpckhqdq	xmm0, xmm1, oword [rsp]
	vpunpckhqdq	ymm0, ymm1, ymm2
	vpunpckhqdq	ymm0, ymm1, hword [rsp]

positive: punpckhwd instruction

	punpckhwd	xmm0, xmm1
	punpckhwd	xmm0, oword [rsp]
	punpckhwd	mmx0, mmx1
	punpckhwd	mmx0, qword [rsp]

positive: vpunpckhwd instruction

	vpunpckhwd	xmm0, xmm1, xmm2
	vpunpckhwd	xmm0, xmm1, oword [rsp]
	vpunpckhwd	ymm0, ymm1, ymm2
	vpunpckhwd	ymm0, ymm1, hword [rsp]

positive: punpcklbw instruction

	punpcklbw	xmm0, xmm1
	punpcklbw	xmm0, oword [rsp]
	punpcklbw	mmx0, mmx1
	punpcklbw	mmx0, dword [rsp]

positive: vpunpcklbw instruction

	vpunpcklbw	xmm0, xmm1, xmm2
	vpunpcklbw	xmm0, xmm1, oword [rsp]
	vpunpcklbw	ymm0, ymm1, ymm2
	vpunpcklbw	ymm0, ymm1, hword [rsp]

positive: punpckldq instruction

	punpckldq	xmm0, xmm1
	punpckldq	xmm0, oword [rsp]
	punpckldq	mmx0, mmx1
	punpckldq	mmx0, dword [rsp]

positive: vpunpckldq instruction

	vpunpckldq	xmm0, xmm1, xmm2
	vpunpckldq	xmm0, xmm1, oword [rsp]
	vpunpckldq	ymm0, ymm1, ymm2
	vpunpckldq	ymm0, ymm1, hword [rsp]

positive: punpcklqdq instruction

	punpcklqdq	xmm0, xmm1
	punpcklqdq	xmm0, oword [rsp]

positive: vpunpcklqdq instruction

	vpunpcklqdq	xmm0, xmm1, xmm2
	vpunpcklqdq	xmm0, xmm1, oword [rsp]
	vpunpcklqdq	ymm0, ymm1, ymm2
	vpunpcklqdq	ymm0, ymm1, hword [rsp]

positive: punpcklwd instruction

	punpcklwd	xmm0, xmm1
	punpcklwd	xmm0, oword [rsp]
	punpcklwd	mmx0, mmx1
	punpcklwd	mmx0, dword [rsp]

positive: vpunpcklwd instruction

	vpunpcklwd	xmm0, xmm1, xmm2
	vpunpcklwd	xmm0, xmm1, oword [rsp]
	vpunpcklwd	ymm0, ymm1, ymm2
	vpunpcklwd	ymm0, ymm1, hword [rsp]

positive: pxor instruction

	pxor	xmm0, xmm1
	pxor	xmm0, oword [rsp]
	pxor	mmx0, mmx1
	pxor	mmx0, qword [rsp]

positive: vpxor instruction

	vpxor	xmm0, xmm1, xmm2
	vpxor	xmm0, xmm1, oword [rsp]
	vpxor	ymm0, ymm1, ymm2
	vpxor	ymm0, ymm1, hword [rsp]

positive: rcpps instruction

	rcpps	xmm0, xmm1
	rcpps	xmm0, oword [rsp]

positive: vrcpps instruction

	vrcpps	xmm0, xmm1
	vrcpps	xmm0, oword [rsp]
	vrcpps	ymm0, ymm1
	vrcpps	ymm0, hword [rsp]

positive: rcpss instruction

	rcpss	xmm0, xmm1
	rcpss	xmm0, dword [rsp]

positive: vrcpss instruction

	vrcpss	xmm0, xmm1, xmm2
	vrcpss	xmm0, xmm1, oword [rsp]

positive: roundpd instruction

	roundpd	xmm0, xmm1, byte 0
	roundpd	xmm0, oword [rsp], byte 255

positive: vroundpd instruction

	vroundpd	xmm0, xmm1, byte 0
	vroundpd	xmm0, oword [rsp], byte 255
	vroundpd	ymm0, ymm1, byte 0
	vroundpd	ymm0, hword [rsp], byte 255

positive: roundps instruction

	roundps	xmm0, xmm1, byte 0
	roundps	xmm0, oword [rsp], byte 255

positive: vroundps instruction

	vroundps	xmm0, xmm1, byte 0
	vroundps	xmm0, oword [rsp], byte 255
	vroundps	ymm0, ymm1, byte 0
	vroundps	ymm0, hword [rsp], byte 255

positive: roundsd instruction

	roundsd	xmm0, xmm1, byte 0
	roundsd	xmm0, qword [rsp], byte 255

positive: vroundsd instruction

	vroundsd	xmm0, xmm1, byte 0
	vroundsd	xmm0, qword [rsp], byte 255

positive: roundss instruction

	roundss	xmm0, xmm1, byte 0
	roundss	xmm0, dword [rsp], byte 255

positive: vroundss instruction

	vroundss	xmm0, xmm1, byte 0
	vroundss	xmm0, dword [rsp], byte 255

positive: sha1msg1 instruction

	sha1msg1	xmm0, xmm1
	sha1msg1	xmm0, oword [rsp]

positive: sha1msg2 instruction

	sha1msg2	xmm0, xmm1
	sha1msg2	xmm0, oword [rsp]

positive: sha1nexte instruction

	sha1nexte	xmm0, xmm1
	sha1nexte	xmm0, oword [rsp]

positive: sha1rnds4 instruction

	sha1rnds4	xmm0, xmm1, byte 0
	sha1rnds4	xmm0, oword [rsp], byte 255

positive: sha256msg1 instruction

	sha256msg1	xmm0, xmm1
	sha256msg1	xmm0, oword [rsp]

positive: sha256msg2 instruction

	sha256msg2	xmm0, xmm1
	sha256msg2	xmm0, oword [rsp]

positive: sha256rnds2 instruction

	sha256rnds2	xmm0, xmm1
	sha256rnds2	xmm0, oword [rsp]

positive: rsqrtps instruction

	rsqrtps	xmm0, xmm1
	rsqrtps	xmm0, oword [rsp]

positive: vrsqrtps instruction

	vrsqrtps	xmm0, xmm1
	vrsqrtps	xmm0, oword [rsp]
	vrsqrtps	ymm0, ymm1
	vrsqrtps	ymm0, hword [rsp]

positive: rsqrtss instruction

	rsqrtss	xmm0, xmm1
	rsqrtss	xmm0, dword [rsp]

positive: vrsqrtss instruction

	vrsqrtss	xmm0, xmm1, xmm2
	vrsqrtss	xmm0, xmm1, dword [rsp]

positive: shufpd instruction

	shufpd	xmm0, xmm1, byte 0
	shufpd	xmm0, oword [rsp], byte 255

positive: vshufpd instruction

	vshufpd	xmm0, xmm1, xmm2, byte 0
	vshufpd	xmm0, xmm1, oword [rsp], byte 255
	vshufpd	ymm0, ymm1, ymm2, byte 0
	vshufpd	ymm0, ymm1, hword [rsp], byte 255

positive: shufps instruction

	shufps	xmm0, xmm1, byte 0
	shufps	xmm0, oword [rsp], byte 255

positive: vshufps instruction

	vshufps	xmm0, xmm1, xmm2, byte 0
	vshufps	xmm0, xmm1, oword [rsp], byte 255
	vshufps	ymm0, ymm1, ymm2, byte 0
	vshufps	ymm0, ymm1, hword [rsp], byte 255

positive: sqrtpd instruction

	sqrtpd	xmm0, xmm1
	sqrtpd	xmm0, oword [rsp]

positive: vsqrtpd instruction

	vsqrtpd	xmm0, xmm1
	vsqrtpd	xmm0, oword [rsp]
	vsqrtpd	ymm0, ymm1
	vsqrtpd	ymm0, hword [rsp]

positive: sqrtps instruction

	sqrtps	xmm0, xmm1
	sqrtps	xmm0, oword [rsp]

positive: vsqrtps instruction

	vsqrtps	xmm0, xmm1
	vsqrtps	xmm0, oword [rsp]
	vsqrtps	ymm0, ymm1
	vsqrtps	ymm0, hword [rsp]

positive: sqrtsd instruction

	sqrtsd	xmm0, xmm1
	sqrtsd	xmm0, qword [rsp]

positive: vsqrtsd instruction

	vsqrtsd	xmm0, xmm1, xmm2
	vsqrtsd	xmm0, xmm1, qword [rsp]

positive: sqrtss instruction

	sqrtss	xmm0, xmm1
	sqrtss	xmm0, dword [rsp]

positive: vsqrtss instruction

	vsqrtss	xmm0, xmm1, xmm2
	vsqrtss	xmm0, xmm1, dword [rsp]

positive: stmxcsr instruction

	stmxcsr	dword [rsp]

positive: vstmxcsr instruction

	vstmxcsr	dword [rsp]

positive: subpd instruction

	subpd	xmm0, xmm1
	subpd	xmm0, oword [rsp]

positive: vsubpd instruction

	vsubpd	xmm0, xmm1, xmm2
	vsubpd	xmm0, xmm1, oword [rsp]
	vsubpd	ymm0, ymm1, ymm2
	vsubpd	ymm0, ymm1, hword [rsp]

positive: subps instruction

	subps	xmm0, xmm1
	subps	xmm0, oword [rsp]

positive: vsubps instruction

	vsubps	xmm0, xmm1, xmm2
	vsubps	xmm0, xmm1, oword [rsp]
	vsubps	ymm0, ymm1, ymm2
	vsubps	ymm0, ymm1, hword [rsp]

positive: subsd instruction

	subsd	xmm0, xmm1
	subsd	xmm0, qword [rsp]

positive: vsubsd instruction

	vsubsd	xmm0, xmm1, xmm2
	vsubsd	xmm0, xmm1, qword [rsp]

positive: subss instruction

	subss	xmm0, xmm1
	subss	xmm0, dword [rsp]

positive: vsubss instruction

	vsubss	xmm0, xmm1, xmm2
	vsubss	xmm0, xmm1, dword [rsp]

positive: t1mskc instruction

	t1mskc	ebx, ecx
	t1mskc	ebx, dword [rsp]
	t1mskc	rbx, rcx
	t1mskc	rbx, qword [rsp]

positive: tzcnt instruction

	tzcnt	bx, cx
	tzcnt	bx, word [rsp]
	tzcnt	ebx, ecx
	tzcnt	ebx, dword [rsp]
	tzcnt	rbx, rcx
	tzcnt	rbx, qword [rsp]

positive: tzmsk instruction

	tzmsk	ebx, ecx
	tzmsk	ebx, dword [rsp]
	tzmsk	rbx, rcx
	tzmsk	rbx, qword [rsp]

positive: ucomisd instruction

	ucomisd	xmm0, xmm1
	ucomisd	xmm0, qword [rsp]

positive: vucomisd instruction

	vucomisd	xmm0, xmm1
	vucomisd	xmm0, qword [rsp]

positive: ucomiss instruction

	ucomiss	xmm0, xmm1
	ucomiss	xmm0, dword [rsp]

positive: vucomiss instruction

	vucomiss	xmm0, xmm1
	vucomiss	xmm0, dword [rsp]

positive: unpckhpd instruction

	unpckhpd	xmm0, xmm1
	unpckhpd	xmm0, oword [rsp]

positive: vunpckhpd instruction

	vunpckhpd	xmm0, xmm1, xmm2
	vunpckhpd	xmm0, xmm1, oword [rsp]
	vunpckhpd	ymm0, ymm1, ymm2
	vunpckhpd	ymm0, ymm1, hword [rsp]

positive: unpckhps instruction

	unpckhps	xmm0, xmm1
	unpckhps	xmm0, oword [rsp]

positive: vunpckhps instruction

	vunpckhps	xmm0, xmm1, xmm2
	vunpckhps	xmm0, xmm1, oword [rsp]
	vunpckhps	ymm0, ymm1, ymm2
	vunpckhps	ymm0, ymm1, hword [rsp]

positive: unpcklpd instruction

	unpcklpd	xmm0, xmm1
	unpcklpd	xmm0, oword [rsp]

positive: vunpcklpd instruction

	vunpcklpd	xmm0, xmm1, xmm2
	vunpcklpd	xmm0, xmm1, oword [rsp]
	vunpcklpd	ymm0, ymm1, ymm2
	vunpcklpd	ymm0, ymm1, hword [rsp]

positive: unpcklps instruction

	unpcklps	xmm0, xmm1
	unpcklps	xmm0, oword [rsp]

positive: vunpcklps instruction

	vunpcklps	xmm0, xmm1, xmm2
	vunpcklps	xmm0, xmm1, oword [rsp]
	vunpcklps	ymm0, ymm1, ymm2
	vunpcklps	ymm0, ymm1, hword [rsp]

positive: vbroadcastf128 instruction

	vbroadcastf128	ymm0, oword [rsp]

positive: vbroadcasti128 instruction

	vbroadcasti128	ymm0, oword [rsp]

positive: vbroadcastsd instruction

	vbroadcastsd	ymm0, xmm1
	vbroadcastsd	ymm0, qword [rsp]

positive: vbroadcastss instruction

	vbroadcastss	xmm0, xmm1
	vbroadcastss	xmm0, dword [rsp]
	vbroadcastss	ymm0, xmm1
	vbroadcastss	ymm0, dword [rsp]

positive: vcvtph2ps instruction

	vcvtph2ps	xmm0, xmm1
	vcvtph2ps	xmm0, qword [rsp]
	vcvtph2ps	ymm0, xmm1
	vcvtph2ps	ymm0, oword [rsp]

positive: vcvtps2ph instruction

	vcvtps2ph	xmm0, xmm1, byte 0
	vcvtps2ph	qword [rsp], xmm1, byte 255
	vcvtps2ph	xmm0, ymm1, byte 0
	vcvtps2ph	oword [rsp], ymm1, byte 255

positive: vextractf128 instruction

	vextractf128	xmm0, ymm1, byte 0
	vextractf128	oword [rsp], ymm1, byte 255

positive: vextracti128 instruction

	vextracti128	xmm0, ymm1, byte 0
	vextracti128	oword [rsp], ymm1, byte 255

positive: vfmaddpd instruction

	vfmaddpd	xmm0, xmm1, xmm2, xmm3
	vfmaddpd	xmm0, xmm1, oword [rsp], xmm3
	vfmaddpd	ymm0, ymm1, ymm2, ymm3
	vfmaddpd	ymm0, ymm1, hword [rsp], ymm3
	vfmaddpd	xmm0, xmm1, xmm2, xmm3
	vfmaddpd	xmm0, xmm1, xmm2, oword [rsp]
	vfmaddpd	ymm0, ymm1, ymm2, ymm3
	vfmaddpd	ymm0, ymm1, ymm2, hword [rsp]

positive: vfmadd132pd instruction

	vfmadd132pd	xmm0, xmm1, xmm2
	vfmadd132pd	xmm0, xmm1, oword [rsp]
	vfmadd132pd	ymm0, ymm1, ymm2
	vfmadd132pd	ymm0, ymm1, hword [rsp]

positive: vfmadd213pd instruction

	vfmadd213pd	xmm0, xmm1, xmm2
	vfmadd213pd	xmm0, xmm1, oword [rsp]
	vfmadd213pd	ymm0, ymm1, ymm2
	vfmadd213pd	ymm0, ymm1, hword [rsp]

positive: vfmadd231pd instruction

	vfmadd231pd	xmm0, xmm1, xmm2
	vfmadd231pd	xmm0, xmm1, oword [rsp]
	vfmadd231pd	ymm0, ymm1, ymm2
	vfmadd231pd	ymm0, ymm1, hword [rsp]

positive: vfmaddps instruction

	vfmaddps	xmm0, xmm1, xmm2, xmm3
	vfmaddps	xmm0, xmm1, oword [rsp], xmm3
	vfmaddps	ymm0, ymm1, ymm2, ymm3
	vfmaddps	ymm0, ymm1, hword [rsp], ymm3
	vfmaddps	xmm0, xmm1, xmm2, xmm3
	vfmaddps	xmm0, xmm1, xmm2, oword [rsp]
	vfmaddps	ymm0, ymm1, ymm2, ymm3
	vfmaddps	ymm0, ymm1, ymm2, hword [rsp]

positive: vfmadd132ps instruction

	vfmadd132ps	xmm0, xmm1, xmm2
	vfmadd132ps	xmm0, xmm1, oword [rsp]
	vfmadd132ps	ymm0, ymm1, ymm2
	vfmadd132ps	ymm0, ymm1, hword [rsp]

positive: vfmadd213ps instruction

	vfmadd213ps	xmm0, xmm1, xmm2
	vfmadd213ps	xmm0, xmm1, oword [rsp]
	vfmadd213ps	ymm0, ymm1, ymm2
	vfmadd213ps	ymm0, ymm1, hword [rsp]

positive: vfmadd231ps instruction

	vfmadd231ps	xmm0, xmm1, xmm2
	vfmadd231ps	xmm0, xmm1, oword [rsp]
	vfmadd231ps	ymm0, ymm1, ymm2
	vfmadd231ps	ymm0, ymm1, hword [rsp]

positive: vfmaddsd instruction

	vfmaddsd	xmm0, xmm1, xmm2, xmm3
	vfmaddsd	xmm0, xmm1, qword [rsp], xmm3
	vfmaddsd	xmm0, xmm1, xmm2, xmm3
	vfmaddsd	xmm0, xmm1, xmm2, qword [rsp]

positive: vfmadd132sd instruction

	vfmadd132sd	xmm0, xmm1, xmm2
	vfmadd132sd	xmm0, xmm1, qword [rsp]

positive: vfmadd213sd instruction

	vfmadd213sd	xmm0, xmm1, xmm2
	vfmadd213sd	xmm0, xmm1, qword [rsp]

positive: vfmadd231sd instruction

	vfmadd231sd	xmm0, xmm1, xmm2
	vfmadd231sd	xmm0, xmm1, qword [rsp]

positive: vfmaddss instruction

	vfmaddss	xmm0, xmm1, xmm2, xmm3
	vfmaddss	xmm0, xmm1, dword [rsp], xmm3
	vfmaddss	xmm0, xmm1, xmm2, xmm3
	vfmaddss	xmm0, xmm1, xmm2, dword [rsp]

positive: vfmadd132ss instruction

	vfmadd132ss	xmm0, xmm1, xmm2
	vfmadd132ss	xmm0, xmm1, dword [rsp]

positive: vfmadd213ss instruction

	vfmadd213ss	xmm0, xmm1, xmm2
	vfmadd213ss	xmm0, xmm1, dword [rsp]

positive: vfmadd231ss instruction

	vfmadd231ss	xmm0, xmm1, xmm2
	vfmadd231ss	xmm0, xmm1, dword [rsp]

positive: vfmaddsubpd instruction

	vfmaddsubpd	xmm0, xmm1, xmm2, xmm3
	vfmaddsubpd	xmm0, xmm1, oword [rsp], xmm3
	vfmaddsubpd	ymm0, ymm1, ymm2, ymm3
	vfmaddsubpd	ymm0, ymm1, hword [rsp], ymm3
	vfmaddsubpd	xmm0, xmm1, xmm2, xmm3
	vfmaddsubpd	xmm0, xmm1, xmm2, oword [rsp]
	vfmaddsubpd	ymm0, ymm1, ymm2, ymm3
	vfmaddsubpd	ymm0, ymm1, ymm2, hword [rsp]

positive: vfmaddsub132pd instruction

	vfmaddsub132pd	xmm0, xmm1, xmm2
	vfmaddsub132pd	xmm0, xmm1, oword [rsp]
	vfmaddsub132pd	ymm0, ymm1, ymm2
	vfmaddsub132pd	ymm0, ymm1, hword [rsp]

positive: vfmaddsub213pd instruction

	vfmaddsub213pd	xmm0, xmm1, xmm2
	vfmaddsub213pd	xmm0, xmm1, oword [rsp]
	vfmaddsub213pd	ymm0, ymm1, ymm2
	vfmaddsub213pd	ymm0, ymm1, hword [rsp]

positive: vfmaddsub231pd instruction

	vfmaddsub231pd	xmm0, xmm1, xmm2
	vfmaddsub231pd	xmm0, xmm1, oword [rsp]
	vfmaddsub231pd	ymm0, ymm1, ymm2
	vfmaddsub231pd	ymm0, ymm1, hword [rsp]

positive: vfmaddsubps instruction

	vfmaddsubps	xmm0, xmm1, xmm2, xmm3
	vfmaddsubps	xmm0, xmm1, oword [rsp], xmm3
	vfmaddsubps	ymm0, ymm1, ymm2, ymm3
	vfmaddsubps	ymm0, ymm1, hword [rsp], ymm3
	vfmaddsubps	xmm0, xmm1, xmm2, xmm3
	vfmaddsubps	xmm0, xmm1, xmm2, oword [rsp]
	vfmaddsubps	ymm0, ymm1, ymm2, ymm3
	vfmaddsubps	ymm0, ymm1, ymm2, hword [rsp]

positive: vfmaddsub132ps instruction

	vfmaddsub132ps	xmm0, xmm1, xmm2
	vfmaddsub132ps	xmm0, xmm1, oword [rsp]
	vfmaddsub132ps	ymm0, ymm1, ymm2
	vfmaddsub132ps	ymm0, ymm1, hword [rsp]

positive: vfmaddsub213ps instruction

	vfmaddsub213ps	xmm0, xmm1, xmm2
	vfmaddsub213ps	xmm0, xmm1, oword [rsp]
	vfmaddsub213ps	ymm0, ymm1, ymm2
	vfmaddsub213ps	ymm0, ymm1, hword [rsp]

positive: vfmaddsub231ps instruction

	vfmaddsub231ps	xmm0, xmm1, xmm2
	vfmaddsub231ps	xmm0, xmm1, oword [rsp]
	vfmaddsub231ps	ymm0, ymm1, ymm2
	vfmaddsub231ps	ymm0, ymm1, hword [rsp]

positive: vfmsubaddpd instruction

	vfmsubaddpd	xmm0, xmm1, xmm2, xmm3
	vfmsubaddpd	xmm0, xmm1, oword [rsp], xmm3
	vfmsubaddpd	ymm0, ymm1, ymm2, ymm3
	vfmsubaddpd	ymm0, ymm1, hword [rsp], ymm3
	vfmsubaddpd	xmm0, xmm1, xmm2, xmm3
	vfmsubaddpd	xmm0, xmm1, xmm2, oword [rsp]
	vfmsubaddpd	ymm0, ymm1, ymm2, ymm3
	vfmsubaddpd	ymm0, ymm1, ymm2, hword [rsp]

positive: vfmsubadd132pd instruction

	vfmsubadd132pd	xmm0, xmm1, xmm2
	vfmsubadd132pd	xmm0, xmm1, oword [rsp]
	vfmsubadd132pd	ymm0, ymm1, ymm2
	vfmsubadd132pd	ymm0, ymm1, hword [rsp]

positive: vfmsubadd213pd instruction

	vfmsubadd213pd	xmm0, xmm1, xmm2
	vfmsubadd213pd	xmm0, xmm1, oword [rsp]
	vfmsubadd213pd	ymm0, ymm1, ymm2
	vfmsubadd213pd	ymm0, ymm1, hword [rsp]

positive: vfmsubadd231pd instruction

	vfmsubadd231pd	xmm0, xmm1, xmm2
	vfmsubadd231pd	xmm0, xmm1, oword [rsp]
	vfmsubadd231pd	ymm0, ymm1, ymm2
	vfmsubadd231pd	ymm0, ymm1, hword [rsp]

positive: vfmsubaddps instruction

	vfmsubaddps	xmm0, xmm1, xmm2, xmm3
	vfmsubaddps	xmm0, xmm1, oword [rsp], xmm3
	vfmsubaddps	ymm0, ymm1, ymm2, ymm3
	vfmsubaddps	ymm0, ymm1, hword [rsp], ymm3
	vfmsubaddps	xmm0, xmm1, xmm2, xmm3
	vfmsubaddps	xmm0, xmm1, xmm2, oword [rsp]
	vfmsubaddps	ymm0, ymm1, ymm2, ymm3
	vfmsubaddps	ymm0, ymm1, ymm2, hword [rsp]

positive: vfmsubadd132ps instruction

	vfmsubadd132ps	xmm0, xmm1, xmm2
	vfmsubadd132ps	xmm0, xmm1, oword [rsp]
	vfmsubadd132ps	ymm0, ymm1, ymm2
	vfmsubadd132ps	ymm0, ymm1, hword [rsp]

positive: vfmsubadd213ps instruction

	vfmsubadd213ps	xmm0, xmm1, xmm2
	vfmsubadd213ps	xmm0, xmm1, oword [rsp]
	vfmsubadd213ps	ymm0, ymm1, ymm2
	vfmsubadd213ps	ymm0, ymm1, hword [rsp]

positive: vfmsubadd231ps instruction

	vfmsubadd231ps	xmm0, xmm1, xmm2
	vfmsubadd231ps	xmm0, xmm1, oword [rsp]
	vfmsubadd231ps	ymm0, ymm1, ymm2
	vfmsubadd231ps	ymm0, ymm1, hword [rsp]

positive: vfmsubpd instruction

	vfmsubpd	xmm0, xmm1, xmm2, xmm3
	vfmsubpd	xmm0, xmm1, oword [rsp], xmm3
	vfmsubpd	ymm0, ymm1, ymm2, ymm3
	vfmsubpd	ymm0, ymm1, hword [rsp], ymm3
	vfmsubpd	xmm0, xmm1, xmm2, xmm3
	vfmsubpd	xmm0, xmm1, xmm2, oword [rsp]
	vfmsubpd	ymm0, ymm1, ymm2, ymm3
	vfmsubpd	ymm0, ymm1, ymm2, hword [rsp]

positive: vfmsub132pd instruction

	vfmsub132pd	xmm0, xmm1, xmm2
	vfmsub132pd	xmm0, xmm1, oword [rsp]
	vfmsub132pd	ymm0, ymm1, ymm2
	vfmsub132pd	ymm0, ymm1, hword [rsp]

positive: vfmsub213pd instruction

	vfmsub213pd	xmm0, xmm1, xmm2
	vfmsub213pd	xmm0, xmm1, oword [rsp]
	vfmsub213pd	ymm0, ymm1, ymm2
	vfmsub213pd	ymm0, ymm1, hword [rsp]

positive: vfmsub231pd instruction

	vfmsub231pd	xmm0, xmm1, xmm2
	vfmsub231pd	xmm0, xmm1, oword [rsp]
	vfmsub231pd	ymm0, ymm1, ymm2
	vfmsub231pd	ymm0, ymm1, hword [rsp]

positive: vfmsubps instruction

	vfmsubps	xmm0, xmm1, xmm2, xmm3
	vfmsubps	xmm0, xmm1, oword [rsp], xmm3
	vfmsubps	ymm0, ymm1, ymm2, ymm3
	vfmsubps	ymm0, ymm1, hword [rsp], ymm3
	vfmsubps	xmm0, xmm1, xmm2, xmm3
	vfmsubps	xmm0, xmm1, xmm2, oword [rsp]
	vfmsubps	ymm0, ymm1, ymm2, ymm3
	vfmsubps	ymm0, ymm1, ymm2, hword [rsp]

positive: vfmsub132ps instruction

	vfmsub132ps	xmm0, xmm1, xmm2
	vfmsub132ps	xmm0, xmm1, oword [rsp]
	vfmsub132ps	ymm0, ymm1, ymm2
	vfmsub132ps	ymm0, ymm1, hword [rsp]

positive: vfmsub213ps instruction

	vfmsub213ps	xmm0, xmm1, xmm2
	vfmsub213ps	xmm0, xmm1, oword [rsp]
	vfmsub213ps	ymm0, ymm1, ymm2
	vfmsub213ps	ymm0, ymm1, hword [rsp]

positive: vfmsub231ps instruction

	vfmsub231ps	xmm0, xmm1, xmm2
	vfmsub231ps	xmm0, xmm1, oword [rsp]
	vfmsub231ps	ymm0, ymm1, ymm2
	vfmsub231ps	ymm0, ymm1, hword [rsp]

positive: vfmsubsd instruction

	vfmsubsd	xmm0, xmm1, xmm2, xmm3
	vfmsubsd	xmm0, xmm1, qword [rsp], xmm3
	vfmsubsd	xmm0, xmm1, xmm2, xmm3
	vfmsubsd	xmm0, xmm1, xmm2, qword [rsp]

positive: vfmsub132sd instruction

	vfmsub132sd	xmm0, xmm1, xmm2
	vfmsub132sd	xmm0, xmm1, qword [rsp]

positive: vfmsub213sd instruction

	vfmsub213sd	xmm0, xmm1, xmm2
	vfmsub213sd	xmm0, xmm1, qword [rsp]

positive: vfmsub231sd instruction

	vfmsub231sd	xmm0, xmm1, xmm2
	vfmsub231sd	xmm0, xmm1, qword [rsp]

positive: vfmsubss instruction

	vfmsubss	xmm0, xmm1, xmm2, xmm3
	vfmsubss	xmm0, xmm1, dword [rsp], xmm3
	vfmsubss	xmm0, xmm1, xmm2, xmm3
	vfmsubss	xmm0, xmm1, xmm2, dword [rsp]

positive: vfmsub132ss instruction

	vfmsub132ss	xmm0, xmm1, xmm2
	vfmsub132ss	xmm0, xmm1, dword [rsp]

positive: vfmsub213ss instruction

	vfmsub213ss	xmm0, xmm1, xmm2
	vfmsub213ss	xmm0, xmm1, dword [rsp]

positive: vfmsub231ss instruction

	vfmsub231ss	xmm0, xmm1, xmm2
	vfmsub231ss	xmm0, xmm1, dword [rsp]

positive: vfnmaddpd instruction

	vfnmaddpd	xmm0, xmm1, xmm2, xmm3
	vfnmaddpd	xmm0, xmm1, oword [rsp], xmm3
	vfnmaddpd	ymm0, ymm1, ymm2, ymm3
	vfnmaddpd	ymm0, ymm1, hword [rsp], ymm3
	vfnmaddpd	xmm0, xmm1, xmm2, xmm3
	vfnmaddpd	xmm0, xmm1, xmm2, oword [rsp]
	vfnmaddpd	ymm0, ymm1, ymm2, ymm3
	vfnmaddpd	ymm0, ymm1, ymm2, hword [rsp]

positive: vfnmadd132pd instruction

	vfnmadd132pd	xmm0, xmm1, xmm2
	vfnmadd132pd	xmm0, xmm1, oword [rsp]
	vfnmadd132pd	ymm0, ymm1, ymm2
	vfnmadd132pd	ymm0, ymm1, hword [rsp]

positive: vfnmadd213pd instruction

	vfnmadd213pd	xmm0, xmm1, xmm2
	vfnmadd213pd	xmm0, xmm1, oword [rsp]
	vfnmadd213pd	ymm0, ymm1, ymm2
	vfnmadd213pd	ymm0, ymm1, hword [rsp]

positive: vfnmadd231pd instruction

	vfnmadd231pd	xmm0, xmm1, xmm2
	vfnmadd231pd	xmm0, xmm1, oword [rsp]
	vfnmadd231pd	ymm0, ymm1, ymm2
	vfnmadd231pd	ymm0, ymm1, hword [rsp]

positive: vfnmaddps instruction

	vfnmaddps	xmm0, xmm1, xmm2, xmm3
	vfnmaddps	xmm0, xmm1, oword [rsp], xmm3
	vfnmaddps	ymm0, ymm1, ymm2, ymm3
	vfnmaddps	ymm0, ymm1, hword [rsp], ymm3
	vfnmaddps	xmm0, xmm1, xmm2, xmm3
	vfnmaddps	xmm0, xmm1, xmm2, oword [rsp]
	vfnmaddps	ymm0, ymm1, ymm2, ymm3
	vfnmaddps	ymm0, ymm1, ymm2, hword [rsp]

positive: vfnmadd132ps instruction

	vfnmadd132ps	xmm0, xmm1, xmm2
	vfnmadd132ps	xmm0, xmm1, oword [rsp]
	vfnmadd132ps	ymm0, ymm1, ymm2
	vfnmadd132ps	ymm0, ymm1, hword [rsp]

positive: vfnmadd213ps instruction

	vfnmadd213ps	xmm0, xmm1, xmm2
	vfnmadd213ps	xmm0, xmm1, oword [rsp]
	vfnmadd213ps	ymm0, ymm1, ymm2
	vfnmadd213ps	ymm0, ymm1, hword [rsp]

positive: vfnmadd231ps instruction

	vfnmadd231ps	xmm0, xmm1, xmm2
	vfnmadd231ps	xmm0, xmm1, oword [rsp]
	vfnmadd231ps	ymm0, ymm1, ymm2
	vfnmadd231ps	ymm0, ymm1, hword [rsp]

positive: vfnmaddsd instruction

	vfnmaddsd	xmm0, xmm1, xmm2, xmm3
	vfnmaddsd	xmm0, xmm1, qword [rsp], xmm3
	vfnmaddsd	xmm0, xmm1, xmm2, xmm3
	vfnmaddsd	xmm0, xmm1, xmm2, qword [rsp]

positive: vfnmadd132sd instruction

	vfnmadd132sd	xmm0, xmm1, xmm2
	vfnmadd132sd	xmm0, xmm1, qword [rsp]

positive: vfnmadd213sd instruction

	vfnmadd213sd	xmm0, xmm1, xmm2
	vfnmadd213sd	xmm0, xmm1, qword [rsp]

positive: vfnmadd231sd instruction

	vfnmadd231sd	xmm0, xmm1, xmm2
	vfnmadd231sd	xmm0, xmm1, qword [rsp]

positive: vfnmaddss instruction

	vfnmaddss	xmm0, xmm1, xmm2, xmm3
	vfnmaddss	xmm0, xmm1, dword [rsp], xmm3
	vfnmaddss	xmm0, xmm1, xmm2, xmm3
	vfnmaddss	xmm0, xmm1, xmm2, dword [rsp]

positive: vfnmadd132ss instruction

	vfnmadd132ss	xmm0, xmm1, xmm2
	vfnmadd132ss	xmm0, xmm1, dword [rsp]

positive: vfnmadd213ss instruction

	vfnmadd213ss	xmm0, xmm1, xmm2
	vfnmadd213ss	xmm0, xmm1, dword [rsp]

positive: vfnmadd231ss instruction

	vfnmadd231ss	xmm0, xmm1, xmm2
	vfnmadd231ss	xmm0, xmm1, dword [rsp]

positive: vfnmsubpd instruction

	vfnmsubpd	xmm0, xmm1, xmm2, xmm3
	vfnmsubpd	xmm0, xmm1, oword [rsp], xmm3
	vfnmsubpd	ymm0, ymm1, ymm2, ymm3
	vfnmsubpd	ymm0, ymm1, hword [rsp], ymm3
	vfnmsubpd	xmm0, xmm1, xmm2, xmm3
	vfnmsubpd	xmm0, xmm1, xmm2, oword [rsp]
	vfnmsubpd	ymm0, ymm1, ymm2, ymm3
	vfnmsubpd	ymm0, ymm1, ymm2, hword [rsp]

positive: vfnmsub132pd instruction

	vfnmsub132pd	xmm0, xmm1, xmm2
	vfnmsub132pd	xmm0, xmm1, oword [rsp]
	vfnmsub132pd	ymm0, ymm1, ymm2
	vfnmsub132pd	ymm0, ymm1, hword [rsp]

positive: vfnmsub213pd instruction

	vfnmsub213pd	xmm0, xmm1, xmm2
	vfnmsub213pd	xmm0, xmm1, oword [rsp]
	vfnmsub213pd	ymm0, ymm1, ymm2
	vfnmsub213pd	ymm0, ymm1, hword [rsp]

positive: vfnmsub231pd instruction

	vfnmsub231pd	xmm0, xmm1, xmm2
	vfnmsub231pd	xmm0, xmm1, oword [rsp]
	vfnmsub231pd	ymm0, ymm1, ymm2
	vfnmsub231pd	ymm0, ymm1, hword [rsp]

positive: vfnmsubps instruction

	vfnmsubps	xmm0, xmm1, xmm2, xmm3
	vfnmsubps	xmm0, xmm1, oword [rsp], xmm3
	vfnmsubps	ymm0, ymm1, ymm2, ymm3
	vfnmsubps	ymm0, ymm1, hword [rsp], ymm3
	vfnmsubps	xmm0, xmm1, xmm2, xmm3
	vfnmsubps	xmm0, xmm1, xmm2, oword [rsp]
	vfnmsubps	ymm0, ymm1, ymm2, ymm3
	vfnmsubps	ymm0, ymm1, ymm2, hword [rsp]

positive: vfnmsub132ps instruction

	vfnmsub132ps	xmm0, xmm1, xmm2
	vfnmsub132ps	xmm0, xmm1, oword [rsp]
	vfnmsub132ps	ymm0, ymm1, ymm2
	vfnmsub132ps	ymm0, ymm1, hword [rsp]

positive: vfnmsub213ps instruction

	vfnmsub213ps	xmm0, xmm1, xmm2
	vfnmsub213ps	xmm0, xmm1, oword [rsp]
	vfnmsub213ps	ymm0, ymm1, ymm2
	vfnmsub213ps	ymm0, ymm1, hword [rsp]

positive: vfnmsub231ps instruction

	vfnmsub231ps	xmm0, xmm1, xmm2
	vfnmsub231ps	xmm0, xmm1, oword [rsp]
	vfnmsub231ps	ymm0, ymm1, ymm2
	vfnmsub231ps	ymm0, ymm1, hword [rsp]

positive: vfnmsubsd instruction

	vfnmsubsd	xmm0, xmm1, xmm2, xmm3
	vfnmsubsd	xmm0, xmm1, qword [rsp], xmm3
	vfnmsubsd	xmm0, xmm1, xmm2, xmm3
	vfnmsubsd	xmm0, xmm1, xmm2, qword [rsp]

positive: vfnmsub132sd instruction

	vfnmsub132sd	xmm0, xmm1, xmm2
	vfnmsub132sd	xmm0, xmm1, qword [rsp]

positive: vfnmsub213sd instruction

	vfnmsub213sd	xmm0, xmm1, xmm2
	vfnmsub213sd	xmm0, xmm1, qword [rsp]

positive: vfnmsub231sd instruction

	vfnmsub231sd	xmm0, xmm1, xmm2
	vfnmsub231sd	xmm0, xmm1, qword [rsp]

positive: vfnmsubss instruction

	vfnmsubss	xmm0, xmm1, xmm2, xmm3
	vfnmsubss	xmm0, xmm1, dword [rsp], xmm3
	vfnmsubss	xmm0, xmm1, xmm2, xmm3
	vfnmsubss	xmm0, xmm1, xmm2, dword [rsp]

positive: vfnmsub132ss instruction

	vfnmsub132ss	xmm0, xmm1, xmm2
	vfnmsub132ss	xmm0, xmm1, dword [rsp]

positive: vfnmsub213ss instruction

	vfnmsub213ss	xmm0, xmm1, xmm2
	vfnmsub213ss	xmm0, xmm1, dword [rsp]

positive: vfnmsub231ss instruction

	vfnmsub231ss	xmm0, xmm1, xmm2
	vfnmsub231ss	xmm0, xmm1, dword [rsp]

positive: vfrczpd instruction

	vfrczpd	xmm0, xmm1
	vfrczpd	xmm0, oword [rsp]
	vfrczpd	ymm0, ymm1
	vfrczpd	ymm0, hword [rsp]

positive: vfrczps instruction

	vfrczps	xmm0, xmm1
	vfrczps	xmm0, oword [rsp]
	vfrczps	ymm0, ymm1
	vfrczps	ymm0, hword [rsp]

positive: vfrczsd instruction

	vfrczsd	xmm0, xmm1
	vfrczsd	xmm0, qword [rsp]

positive: vfrczss instruction

	vfrczss	xmm0, xmm1
	vfrczss	xmm0, dword [rsp]

positive: vinsertf128 instruction

	vinsertf128	ymm0, ymm1, xmm2, byte 0
	vinsertf128	ymm0, ymm1, oword [rsp], byte 255

positive: vinserti128 instruction

	vinserti128	ymm0, ymm1, xmm2, byte 0
	vinserti128	ymm0, ymm1, oword [rsp], byte 255

positive: vmaskmovpd instruction

	vmaskmovpd	xmm0, xmm1, oword [rsp]
	vmaskmovpd	ymm0, ymm1, hword [rsp]
	vmaskmovpd	oword [rsp], xmm1, xmm2
	vmaskmovpd	hword [rsp], ymm1, ymm2

positive: vmaskmovps instruction

	vmaskmovps	xmm0, xmm1, oword [rsp]
	vmaskmovps	ymm0, ymm1, hword [rsp]
	vmaskmovps	oword [rsp], xmm1, xmm2
	vmaskmovps	hword [rsp], ymm1, ymm2

positive: vpblendd instruction

	vpblendd	xmm0, xmm1, xmm2, byte 0
	vpblendd	xmm0, xmm1, oword [rsp], byte 255
	vpblendd	ymm0, ymm1, ymm2, byte 0
	vpblendd	ymm0, ymm1, hword [rsp], byte 255

positive: vpbroadcastb instruction

	vpbroadcastb	xmm0, xmm1
	vpbroadcastb	xmm0, byte [rsp]
	vpbroadcastb	ymm0, xmm1
	vpbroadcastb	ymm0, byte [rsp]

positive: vpbroadcastd instruction

	vpbroadcastd	xmm0, xmm1
	vpbroadcastd	xmm0, dword [rsp]
	vpbroadcastd	ymm0, xmm1
	vpbroadcastd	ymm0, dword [rsp]

positive: vpbroadcastq instruction

	vpbroadcastq	xmm0, xmm1
	vpbroadcastq	xmm0, qword [rsp]
	vpbroadcastq	ymm0, xmm1
	vpbroadcastq	ymm0, qword [rsp]

positive: vpbroadcastw instruction

	vpbroadcastw	xmm0, xmm1
	vpbroadcastw	xmm0, word [rsp]
	vpbroadcastw	ymm0, xmm1
	vpbroadcastw	ymm0, word [rsp]

positive: vpcmov instruction

	vpcmov	xmm0, xmm1, xmm2, xmm3
	vpcmov	xmm0, xmm1, oword [rsp], xmm3
	vpcmov	ymm0, ymm1, ymm2, ymm3
	vpcmov	ymm0, ymm1, hword [rsp], ymm3
	vpcmov	xmm0, xmm1, xmm2, xmm3
	vpcmov	xmm0, xmm1, xmm2, oword [rsp]
	vpcmov	ymm0, ymm1, ymm2, ymm3
	vpcmov	ymm0, ymm1, ymm2, hword [rsp]

positive: vpcomb instruction

	vpcomb	xmm0, xmm1, xmm2, 0
	vpcomb	xmm0, xmm1, oword [rsp], 7

positive: vpcomltb instruction

	vpcomltb	xmm0, xmm1, xmm2
	vpcomltb	xmm0, xmm1, oword [rsp]

positive: vpcomleb instruction

	vpcomleb	xmm0, xmm1, xmm2
	vpcomleb	xmm0, xmm1, oword [rsp]

positive: vpcomgtb instruction

	vpcomgtb	xmm0, xmm1, xmm2
	vpcomgtb	xmm0, xmm1, oword [rsp]

positive: vpcomgeb instruction

	vpcomgeb	xmm0, xmm1, xmm2
	vpcomgeb	xmm0, xmm1, oword [rsp]

positive: vpcomeqb instruction

	vpcomeqb	xmm0, xmm1, xmm2
	vpcomeqb	xmm0, xmm1, oword [rsp]

positive: vpcomneqb instruction

	vpcomneqb	xmm0, xmm1, xmm2
	vpcomneqb	xmm0, xmm1, oword [rsp]

positive: vpcomfalseb instruction

	vpcomfalseb	xmm0, xmm1, xmm2
	vpcomfalseb	xmm0, xmm1, oword [rsp]

positive: vpcomtrueb instruction

	vpcomtrueb	xmm0, xmm1, xmm2
	vpcomtrueb	xmm0, xmm1, oword [rsp]

positive: vpcomd instruction

	vpcomd	xmm0, xmm1, xmm2, 0
	vpcomd	xmm0, xmm1, oword [rsp], 7

positive: vpcomltd instruction

	vpcomltd	xmm0, xmm1, xmm2
	vpcomltd	xmm0, xmm1, oword [rsp]

positive: vpcomled instruction

	vpcomled	xmm0, xmm1, xmm2
	vpcomled	xmm0, xmm1, oword [rsp]

positive: vpcomgtd instruction

	vpcomgtd	xmm0, xmm1, xmm2
	vpcomgtd	xmm0, xmm1, oword [rsp]

positive: vpcomged instruction

	vpcomged	xmm0, xmm1, xmm2
	vpcomged	xmm0, xmm1, oword [rsp]

positive: vpcomeqd instruction

	vpcomeqd	xmm0, xmm1, xmm2
	vpcomeqd	xmm0, xmm1, oword [rsp]

positive: vpcomneqd instruction

	vpcomneqd	xmm0, xmm1, xmm2
	vpcomneqd	xmm0, xmm1, oword [rsp]

positive: vpcomfalsed instruction

	vpcomfalsed	xmm0, xmm1, xmm2
	vpcomfalsed	xmm0, xmm1, oword [rsp]

positive: vpcomtrued instruction

	vpcomtrued	xmm0, xmm1, xmm2
	vpcomtrued	xmm0, xmm1, oword [rsp]

positive: vpcomq instruction

	vpcomq	xmm0, xmm1, xmm2, 0
	vpcomq	xmm0, xmm1, oword [rsp], 7

positive: vpcomltq instruction

	vpcomltq	xmm0, xmm1, xmm2
	vpcomltq	xmm0, xmm1, oword [rsp]

positive: vpcomleq instruction

	vpcomleq	xmm0, xmm1, xmm2
	vpcomleq	xmm0, xmm1, oword [rsp]

positive: vpcomgtq instruction

	vpcomgtq	xmm0, xmm1, xmm2
	vpcomgtq	xmm0, xmm1, oword [rsp]

positive: vpcomgeq instruction

	vpcomgeq	xmm0, xmm1, xmm2
	vpcomgeq	xmm0, xmm1, oword [rsp]

positive: vpcomeqq instruction

	vpcomeqq	xmm0, xmm1, xmm2
	vpcomeqq	xmm0, xmm1, oword [rsp]

positive: vpcomneqq instruction

	vpcomneqq	xmm0, xmm1, xmm2
	vpcomneqq	xmm0, xmm1, oword [rsp]

positive: vpcomfalseq instruction

	vpcomfalseq	xmm0, xmm1, xmm2
	vpcomfalseq	xmm0, xmm1, oword [rsp]

positive: vpcomtrueq instruction

	vpcomtrueq	xmm0, xmm1, xmm2
	vpcomtrueq	xmm0, xmm1, oword [rsp]

positive: vpcomub instruction

	vpcomub	xmm0, xmm1, xmm2, 0
	vpcomub	xmm0, xmm1, oword [rsp], 7

positive: vpcomltub instruction

	vpcomltub	xmm0, xmm1, xmm2
	vpcomltub	xmm0, xmm1, oword [rsp]

positive: vpcomleub instruction

	vpcomleub	xmm0, xmm1, xmm2
	vpcomleub	xmm0, xmm1, oword [rsp]

positive: vpcomgtub instruction

	vpcomgtub	xmm0, xmm1, xmm2
	vpcomgtub	xmm0, xmm1, oword [rsp]

positive: vpcomgeub instruction

	vpcomgeub	xmm0, xmm1, xmm2
	vpcomgeub	xmm0, xmm1, oword [rsp]

positive: vpcomequb instruction

	vpcomequb	xmm0, xmm1, xmm2
	vpcomequb	xmm0, xmm1, oword [rsp]

positive: vpcomnequb instruction

	vpcomnequb	xmm0, xmm1, xmm2
	vpcomnequb	xmm0, xmm1, oword [rsp]

positive: vpcomfalseub instruction

	vpcomfalseub	xmm0, xmm1, xmm2
	vpcomfalseub	xmm0, xmm1, oword [rsp]

positive: vpcomtrueub instruction

	vpcomtrueub	xmm0, xmm1, xmm2
	vpcomtrueub	xmm0, xmm1, oword [rsp]

positive: vpcomud instruction

	vpcomud	xmm0, xmm1, xmm2, 0
	vpcomud	xmm0, xmm1, oword [rsp], 7

positive: vpcomltud instruction

	vpcomltud	xmm0, xmm1, xmm2
	vpcomltud	xmm0, xmm1, oword [rsp]

positive: vpcomleud instruction

	vpcomleud	xmm0, xmm1, xmm2
	vpcomleud	xmm0, xmm1, oword [rsp]

positive: vpcomgtud instruction

	vpcomgtud	xmm0, xmm1, xmm2
	vpcomgtud	xmm0, xmm1, oword [rsp]

positive: vpcomgeud instruction

	vpcomgeud	xmm0, xmm1, xmm2
	vpcomgeud	xmm0, xmm1, oword [rsp]

positive: vpcomequd instruction

	vpcomequd	xmm0, xmm1, xmm2
	vpcomequd	xmm0, xmm1, oword [rsp]

positive: vpcomnequd instruction

	vpcomnequd	xmm0, xmm1, xmm2
	vpcomnequd	xmm0, xmm1, oword [rsp]

positive: vpcomfalseud instruction

	vpcomfalseud	xmm0, xmm1, xmm2
	vpcomfalseud	xmm0, xmm1, oword [rsp]

positive: vpcomtrueud instruction

	vpcomtrueud	xmm0, xmm1, xmm2
	vpcomtrueud	xmm0, xmm1, oword [rsp]

positive: vpcomuq instruction

	vpcomuq	xmm0, xmm1, xmm2, 0
	vpcomuq	xmm0, xmm1, oword [rsp], 7

positive: vpcomltuq instruction

	vpcomltuq	xmm0, xmm1, xmm2
	vpcomltuq	xmm0, xmm1, oword [rsp]

positive: vpcomleuq instruction

	vpcomleuq	xmm0, xmm1, xmm2
	vpcomleuq	xmm0, xmm1, oword [rsp]

positive: vpcomgtuq instruction

	vpcomgtuq	xmm0, xmm1, xmm2
	vpcomgtuq	xmm0, xmm1, oword [rsp]

positive: vpcomgeuq instruction

	vpcomgeuq	xmm0, xmm1, xmm2
	vpcomgeuq	xmm0, xmm1, oword [rsp]

positive: vpcomequq instruction

	vpcomequq	xmm0, xmm1, xmm2
	vpcomequq	xmm0, xmm1, oword [rsp]

positive: vpcomnequq instruction

	vpcomnequq	xmm0, xmm1, xmm2
	vpcomnequq	xmm0, xmm1, oword [rsp]

positive: vpcomfalseuq instruction

	vpcomfalseuq	xmm0, xmm1, xmm2
	vpcomfalseuq	xmm0, xmm1, oword [rsp]

positive: vpcomtrueuq instruction

	vpcomtrueuq	xmm0, xmm1, xmm2
	vpcomtrueuq	xmm0, xmm1, oword [rsp]

positive: vpcomuw instruction

	vpcomuw	xmm0, xmm1, xmm2, 0
	vpcomuw	xmm0, xmm1, oword [rsp], 7

positive: vpcomltuw instruction

	vpcomltuw	xmm0, xmm1, xmm2
	vpcomltuw	xmm0, xmm1, oword [rsp]

positive: vpcomleuw instruction

	vpcomleuw	xmm0, xmm1, xmm2
	vpcomleuw	xmm0, xmm1, oword [rsp]

positive: vpcomgtuw instruction

	vpcomgtuw	xmm0, xmm1, xmm2
	vpcomgtuw	xmm0, xmm1, oword [rsp]

positive: vpcomgeuw instruction

	vpcomgeuw	xmm0, xmm1, xmm2
	vpcomgeuw	xmm0, xmm1, oword [rsp]

positive: vpcomequw instruction

	vpcomequw	xmm0, xmm1, xmm2
	vpcomequw	xmm0, xmm1, oword [rsp]

positive: vpcomnequw instruction

	vpcomnequw	xmm0, xmm1, xmm2
	vpcomnequw	xmm0, xmm1, oword [rsp]

positive: vpcomfalseuw instruction

	vpcomfalseuw	xmm0, xmm1, xmm2
	vpcomfalseuw	xmm0, xmm1, oword [rsp]

positive: vpcomtrueuw instruction

	vpcomtrueuw	xmm0, xmm1, xmm2
	vpcomtrueuw	xmm0, xmm1, oword [rsp]

positive: vpcomw instruction

	vpcomw	xmm0, xmm1, xmm2, 0
	vpcomw	xmm0, xmm1, oword [rsp], 7

positive: vpcomltw instruction

	vpcomltw	xmm0, xmm1, xmm2
	vpcomltw	xmm0, xmm1, oword [rsp]

positive: vpcomlew instruction

	vpcomlew	xmm0, xmm1, xmm2
	vpcomlew	xmm0, xmm1, oword [rsp]

positive: vpcomgtw instruction

	vpcomgtw	xmm0, xmm1, xmm2
	vpcomgtw	xmm0, xmm1, oword [rsp]

positive: vpcomgew instruction

	vpcomgew	xmm0, xmm1, xmm2
	vpcomgew	xmm0, xmm1, oword [rsp]

positive: vpcomeqw instruction

	vpcomeqw	xmm0, xmm1, xmm2
	vpcomeqw	xmm0, xmm1, oword [rsp]

positive: vpcomneqw instruction

	vpcomneqw	xmm0, xmm1, xmm2
	vpcomneqw	xmm0, xmm1, oword [rsp]

positive: vpcomfalsew instruction

	vpcomfalsew	xmm0, xmm1, xmm2
	vpcomfalsew	xmm0, xmm1, oword [rsp]

positive: vpcomtruew instruction

	vpcomtruew	xmm0, xmm1, xmm2
	vpcomtruew	xmm0, xmm1, oword [rsp]

positive: vperm2f128 instruction

	vperm2f128	ymm0, ymm1, ymm2, byte 0
	vperm2f128	ymm0, ymm1, hword [rsp], byte 255

positive: vperm2i128 instruction

	vperm2i128	ymm0, ymm1, ymm2, byte 0
	vperm2i128	ymm0, ymm1, hword [rsp], byte 255

positive: vpermd instruction

	vpermd	ymm0, ymm1, ymm2
	vpermd	ymm0, ymm1, hword [rsp]

positive: vpermpd instruction

	vpermpd	ymm0, ymm1, byte 0
	vpermpd	ymm0, hword [rsp], byte 255

positive: vpermps instruction

	vpermps	ymm0, ymm1, ymm2
	vpermps	ymm0, ymm1, hword [rsp]

positive: vpermq instruction

	vpermq	ymm0, ymm1, byte 0
	vpermq	ymm0, hword [rsp], byte 255

positive: vphaddbd instruction

	vphaddbd	xmm0, xmm1
	vphaddbd	xmm0, oword [rsp]

positive: vphaddbq instruction

	vphaddbq	xmm0, xmm1
	vphaddbq	xmm0, oword [rsp]

positive: vphaddbw instruction

	vphaddbw	xmm0, xmm1
	vphaddbw	xmm0, oword [rsp]

positive: vphadddq instruction

	vphadddq	xmm0, xmm1
	vphadddq	xmm0, oword [rsp]

positive: vphaddubd instruction

	vphaddubd	xmm0, xmm1
	vphaddubd	xmm0, oword [rsp]

positive: vphaddubq instruction

	vphaddubq	xmm0, xmm1
	vphaddubq	xmm0, oword [rsp]

positive: vphaddubw instruction

	vphaddubw	xmm0, xmm1
	vphaddubw	xmm0, oword [rsp]

positive: vphaddudq instruction

	vphaddudq	xmm0, xmm1
	vphaddudq	xmm0, oword [rsp]

positive: vphadduwd instruction

	vphadduwd	xmm0, xmm1
	vphadduwd	xmm0, oword [rsp]

positive: vphadduwq instruction

	vphadduwq	xmm0, xmm1
	vphadduwq	xmm0, oword [rsp]

positive: vphaddwd instruction

	vphaddwd	xmm0, xmm1
	vphaddwd	xmm0, oword [rsp]

positive: vphaddwq instruction

	vphaddwq	xmm0, xmm1
	vphaddwq	xmm0, oword [rsp]

positive: vphsubbw instruction

	vphsubbw	xmm0, xmm1
	vphsubbw	xmm0, oword [rsp]

positive: vphsubdq instruction

	vphsubdq	xmm0, xmm1
	vphsubdq	xmm0, oword [rsp]

positive: vphsubwd instruction

	vphsubwd	xmm0, xmm1
	vphsubwd	xmm0, oword [rsp]

positive: vpmacsdd instruction

	vpmacsdd	xmm0, xmm1, xmm2, xmm3
	vpmacsdd	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacsdqh instruction

	vpmacsdqh	xmm0, xmm1, xmm2, xmm3
	vpmacsdqh	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacsdql instruction

	vpmacsdql	xmm0, xmm1, xmm2, xmm3
	vpmacsdql	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacssdd instruction

	vpmacssdd	xmm0, xmm1, xmm2, xmm3
	vpmacssdd	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacssdqh instruction

	vpmacssdqh	xmm0, xmm1, xmm2, xmm3
	vpmacssdqh	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacssdql instruction

	vpmacssdql	xmm0, xmm1, xmm2, xmm3
	vpmacssdql	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacsswd instruction

	vpmacsswd	xmm0, xmm1, xmm2, xmm3
	vpmacsswd	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacssww instruction

	vpmacssww	xmm0, xmm1, xmm2, xmm3
	vpmacssww	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacswd instruction

	vpmacswd	xmm0, xmm1, xmm2, xmm3
	vpmacswd	xmm0, xmm1, oword [rsp], xmm3

positive: vpmacsww instruction

	vpmacsww	xmm0, xmm1, xmm2, xmm3
	vpmacsww	xmm0, xmm1, oword [rsp], xmm3

positive: vpmadcsswd instruction

	vpmadcsswd	xmm0, xmm1, xmm2, xmm3
	vpmadcsswd	xmm0, xmm1, oword [rsp], xmm3

positive: vpmadcswd instruction

	vpmadcswd	xmm0, xmm1, xmm2, xmm3
	vpmadcswd	xmm0, xmm1, oword [rsp], xmm3

positive: vpmaskmovd instruction

	vpmaskmovd	xmm0, xmm1, oword [rsp]
	vpmaskmovd	ymm0, ymm1, hword [rsp]
	vpmaskmovd	oword [rsp], xmm1, xmm2
	vpmaskmovd	hword [rsp], ymm1, ymm2

positive: vpmaskmovq instruction

	vpmaskmovq	xmm0, xmm1, oword [rsp]
	vpmaskmovq	ymm0, ymm1, hword [rsp]
	vpmaskmovq	oword [rsp], xmm1, xmm2
	vpmaskmovq	hword [rsp], ymm1, ymm2

positive: vpperm instruction

	vpperm	xmm0, xmm1, xmm2, xmm3
	vpperm	xmm0, xmm1, xmm2, oword [rsp]
	vpperm	xmm0, xmm1, xmm2, xmm3
	vpperm	xmm0, xmm1, oword [rsp], xmm3

positive: vprotb instruction

	vprotb	xmm0, xmm1, xmm2
	vprotb	xmm0, oword [rsp], xmm2
	vprotb	xmm0, xmm1, xmm2
	vprotb	xmm0, xmm1, oword [rsp]
	vprotb	xmm0, xmm1, byte 0
	vprotb	xmm0, oword [rsp], byte 255

positive: vprotd instruction

	vprotd	xmm0, xmm1, xmm2
	vprotd	xmm0, oword [rsp], xmm2
	vprotd	xmm0, xmm1, xmm2
	vprotd	xmm0, xmm1, oword [rsp]
	vprotd	xmm0, xmm1, byte 0
	vprotd	xmm0, oword [rsp], byte 255

positive: vprotq instruction

	vprotq	xmm0, xmm1, xmm2
	vprotq	xmm0, oword [rsp], xmm2
	vprotq	xmm0, xmm1, xmm2
	vprotq	xmm0, xmm1, oword [rsp]
	vprotq	xmm0, xmm1, byte 0
	vprotq	xmm0, oword [rsp], byte 255

positive: vprotw instruction

	vprotw	xmm0, xmm1, xmm2
	vprotw	xmm0, oword [rsp], xmm2
	vprotw	xmm0, xmm1, xmm2
	vprotw	xmm0, xmm1, oword [rsp]
	vprotw	xmm0, xmm1, byte 0
	vprotw	xmm0, oword [rsp], byte 255

positive: vpshab instruction

	vpshab	xmm0, xmm1, xmm2
	vpshab	xmm0, oword [rsp], xmm2
	vpshab	xmm0, xmm1, xmm2
	vpshab	xmm0, xmm1, oword [rsp]

positive: vpshad instruction

	vpshad	xmm0, xmm1, xmm2
	vpshad	xmm0, oword [rsp], xmm2
	vpshad	xmm0, xmm1, xmm2
	vpshad	xmm0, xmm1, oword [rsp]

positive: vpshaq instruction

	vpshaq	xmm0, xmm1, xmm2
	vpshaq	xmm0, oword [rsp], xmm2
	vpshaq	xmm0, xmm1, xmm2
	vpshaq	xmm0, xmm1, oword [rsp]

positive: vpshaw instruction

	vpshaw	xmm0, xmm1, xmm2
	vpshaw	xmm0, oword [rsp], xmm2
	vpshaw	xmm0, xmm1, xmm2
	vpshaw	xmm0, xmm1, oword [rsp]

positive: vpshlb instruction

	vpshlb	xmm0, xmm1, xmm2
	vpshlb	xmm0, oword [rsp], xmm2
	vpshlb	xmm0, xmm1, xmm2
	vpshlb	xmm0, xmm1, oword [rsp]

positive: vpshld instruction

	vpshld	xmm0, xmm1, xmm2
	vpshld	xmm0, oword [rsp], xmm2
	vpshld	xmm0, xmm1, xmm2
	vpshld	xmm0, xmm1, oword [rsp]

positive: vpshlq instruction

	vpshlq	xmm0, xmm1, xmm2
	vpshlq	xmm0, oword [rsp], xmm2
	vpshlq	xmm0, xmm1, xmm2
	vpshlq	xmm0, xmm1, oword [rsp]

positive: vpshlw instruction

	vpshlw	xmm0, xmm1, xmm2
	vpshlw	xmm0, oword [rsp], xmm2
	vpshlw	xmm0, xmm1, xmm2
	vpshlw	xmm0, xmm1, oword [rsp]

positive: vpsllvd instruction

	vpsllvd	xmm0, xmm1, xmm2
	vpsllvd	xmm0, xmm1, oword [rsp]
	vpsllvd	ymm0, ymm1, ymm2
	vpsllvd	ymm0, ymm1, hword [rsp]

positive: vpsllvq instruction

	vpsllvq	xmm0, xmm1, xmm2
	vpsllvq	xmm0, xmm1, oword [rsp]
	vpsllvq	ymm0, ymm1, ymm2
	vpsllvq	ymm0, ymm1, hword [rsp]

positive: vpsravd instruction

	vpsravd	xmm0, xmm1, xmm2
	vpsravd	xmm0, xmm1, oword [rsp]
	vpsravd	ymm0, ymm1, ymm2
	vpsravd	ymm0, ymm1, hword [rsp]

positive: vpsrlvd instruction

	vpsrlvd	xmm0, xmm1, xmm2
	vpsrlvd	xmm0, xmm1, oword [rsp]
	vpsrlvd	ymm0, ymm1, ymm2
	vpsrlvd	ymm0, ymm1, hword [rsp]

positive: vpsrlvq instruction

	vpsrlvq	xmm0, xmm1, xmm2
	vpsrlvq	xmm0, xmm1, oword [rsp]
	vpsrlvq	ymm0, ymm1, ymm2
	vpsrlvq	ymm0, ymm1, hword [rsp]

positive: vtestpd instruction

	vtestpd	xmm0, xmm1
	vtestpd	xmm0, oword [rsp]
	vtestpd	ymm0, ymm1
	vtestpd	ymm0, hword [rsp]

positive: vtestps instruction

	vtestps	xmm0, xmm1
	vtestps	xmm0, oword [rsp]
	vtestps	ymm0, ymm1
	vtestps	ymm0, hword [rsp]

positive: vzeroall instruction

	vzeroall

positive: vzeroupper instruction

	vzeroupper

positive: xorpd instruction

	xorpd	xmm0, xmm1
	xorpd	xmm0, oword [rsp]

positive: vxorpd instruction

	vxorpd	xmm0, xmm1, xmm2
	vxorpd	xmm0, xmm1, oword [rsp]
	vxorpd	ymm0, ymm1, ymm2
	vxorpd	ymm0, ymm1, hword [rsp]

positive: xorps instruction

	xorps	xmm0, xmm1
	xorps	xmm0, oword [rsp]

positive: vxorps instruction

	vxorps	xmm0, xmm1, xmm2
	vxorps	xmm0, xmm1, oword [rsp]
	vxorps	ymm0, ymm1, ymm2
	vxorps	ymm0, ymm1, hword [rsp]

positive: xgetbv instruction

	xgetbv

positive: xrstor instruction

	xrstor	[rsp]

positive: xrstors instruction

	xrstors	[rsp]

positive: xsave instruction

	xsave	[rsp]

positive: xsavec instruction

	xsavec	[rsp]

positive: xsaveopt instruction

	xsaveopt	[rsp]

positive: xsaves instruction

	xsaves	[rsp]

positive: xsetbv instruction

	xsetbv

# x87 floating-point instructions

positive: f2xm1 instruction

	f2xm1

positive: fabs instruction

	fabs

positive: fadd instruction

	fadd	st0, st1
	fadd	st1, st0
	fadd	dword [rsp]
	fadd	qword [rsp]

positive: faddp instruction

	faddp
	faddp	st1, st0

positive: fiadd instruction

	fiadd	word [rsp]
	fiadd	dword [rsp]

positive: fbld instruction

	fbld	[rsp]

positive: fbstp instruction

	fbstp	[rsp]

positive: fchs instruction

	fchs

positive: fnclex instruction

	fnclex

positive: fcmovb instruction

	fcmovb	st0, st1

positive: fcmovbe instruction

	fcmovbe	st0, st1

positive: fcmove instruction

	fcmove	st0, st1

positive: fcmovnb instruction

	fcmovnb	st0, st1

positive: fcmovnbe instruction

	fcmovnbe	st0, st1

positive: fcmovne instruction

	fcmovne	st0, st1

positive: fcmovnu instruction

	fcmovnu	st0, st1

positive: fcmovu instruction

	fcmovu	st0, st1

positive: fcom instruction

	fcom
	fcom	st1
	fcom	dword [rsp]
	fcom	qword [rsp]

positive: fcomp instruction

	fcomp
	fcomp	st1
	fcomp	dword [rsp]
	fcomp	qword [rsp]

positive: fcompp instruction

	fcompp

positive: fcomi instruction

	fcomi	st0, st1

positive: fcomip instruction

	fcomip	st0, st1

positive: fcos instruction

	fcos

positive: fdecstp instruction

	fdecstp

positive: fdiv instruction

	fdiv	st0, st1
	fdiv	st1, st0
	fdiv	dword [rsp]
	fdiv	qword [rsp]

positive: fdivp instruction

	fdivp
	fdivp	st1, st0

positive: fidiv instruction

	fidiv	word [rsp]
	fidiv	dword [rsp]

positive: fdivr instruction

	fdivr	st0, st1
	fdivr	st1, st0
	fdivr	dword [rsp]
	fdivr	qword [rsp]

positive: fdivrp instruction

	fdivrp
	fdivrp	st1, st0

positive: fidivr instruction

	fidivr	word [rsp]
	fidivr	dword [rsp]

positive: ffree instruction

	ffree	st1

positive: ficom instruction

	ficom	word [rsp]
	fcom	dword [rsp]

positive: ficomp instruction

	ficomp	word [rsp]
	fcomp	dword [rsp]

positive: fild instruction

	fild	word [rsp]
	fild	dword [rsp]
	fild	qword [rsp]

positive: fincstp instruction

	fincstp

positive: fninit instruction

	fninit

positive: fist instruction

	fist	word [rsp]
	fist	dword [rsp]

positive: fistp instruction

	fistp	word [rsp]
	fistp	dword [rsp]
	fistp	qword [rsp]

positive: fisttp instruction

	fisttp	word [rsp]
	fisttp	dword [rsp]
	fisttp	qword [rsp]

positive: fld instruction

	fld	st1
	fld	dword [rsp]
	fld	qword [rsp]

positive: fld1 instruction

	fld1

positive: fldcw instruction

	fldcw	[rsp]

positive: fldenv instruction

	fldenv	[rsp]

positive: fldl2e instruction

	fldl2e

positive: fldl2t instruction

	fldl2t

positive: fldlg2 instruction

	fldlg2

positive: fldln2 instruction

	fldln2

positive: fldpi instruction

	fldpi

positive: fldz instruction

	fldz

positive: fmul instruction

	fmul	st0, st1
	fmul	st1, st0
	fmul	dword [rsp]
	fmul	qword [rsp]

positive: fmulp instruction

	fmulp
	fmulp	st1, st0

positive: fimul instruction

	fimul	word [rsp]
	fimul	dword [rsp]

positive: fnop instruction

	fnop

positive: fpatan instruction

	fpatan

positive: fprem instruction

	fprem

positive: fprem1 instruction

	fprem1

positive: fptan instruction

	fptan

positive: frndint instruction

	frndint

positive: fscale instruction

	fscale

positive: fsin instruction

	fsin

positive: fsincos instruction

	fsincos

positive: fsqrt instruction

	fsqrt

positive: fst instruction

	fst	st1
	fst	dword [rsp]
	fst	qword [rsp]

positive: fstp instruction

	fstp	st1
	fstp	dword [rsp]
	fstp	qword [rsp]

positive: fnstcw instruction

	fnstcw	[rsp]

positive: fnstenv instruction

	fnstenv	[rsp]

positive: fnstsw instruction

	fnstsw	[rsp]

positive: fsub instruction

	fsub	st0, st1
	fsub	st1, st0
	fsub	dword [rsp]
	fsub	qword [rsp]

positive: fsubp instruction

	fsubp
	fsubp	st1, st0

positive: fisub instruction

	fisub	word [rsp]
	fisub	dword [rsp]

positive: fsubr instruction

	fsubr	st0, st1
	fsubr	st1, st0
	fsubr	dword [rsp]
	fsubr	qword [rsp]

positive: fsubrp instruction

	fsubrp
	fsubrp	st1, st0

positive: fisubr instruction

	fisubr	word [rsp]
	fisubr	dword [rsp]

positive: ftst instruction

	ftst

positive: fucom instruction

	fucom
	fucom	st1

positive: fucomp instruction

	fucomp
	fucomp	st1

positive: fucompp instruction

	fucompp

positive: fucomi instruction

	fucomi	st0, st1

positive: fucomip instruction

	fucomip	st0, st1

positive: fwait instruction

	fwait

positive: fxam instruction

	fxam

positive: fxch instruction

	fxch
	fxch	st1

positive: fxtract instruction

	fxtract

positive: fyl2x instruction

	fyl2x

positive: fyl2xp1 instruction

	fyl2xp1

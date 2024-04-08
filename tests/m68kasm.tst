# M68000 assembler test and validation suite
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

# M68000 assembler

# effective addressing modes

positive: data register direct mode

	movea.l	d0, a0
	movea.l	d7, a0

negative: data register direct mode with invalid register

	movea.l	d8, a0

positive: address register direct mode

	movea.l	a0, a0
	movea.l	a7, a0

negative: address register direct mode with invalid register

	movea.l	a8, a0

positive: data register indirect mode

	movea.l	(a0), a0
	movea.l	(a7), a0

negative: data register indirect mode with invalid register

	movea.l	(a8), a0

negative: data register indirect mode with missing register

	movea.l	(), a0

negative: data register indirect mode with data register

	movea.l	(d0), a0

positive: data register indirect with postincrement mode

	movea.l	(a0)+, a0
	movea.l	(a7)+, a0

negative: data register indirect with postincrement mode with plus at beginning

	movea.l	+(a0), a0

negative: data register indirect with postincrement mode with invalid register

	movea.l	(a8)+, a0

negative: data register indirect with postincrement mode with missing register

	movea.l	()+, a0

negative: data register indirect with postincrement mode with data register

	movea.l	(d0)+, a0

positive: data register indirect with predecrement mode

	movea.l	-(a0), a0
	movea.l	-(a7), a0

negative: data register indirect with predecrement mode with plus at end

	movea.l	(a0)-, a0

negative: data register indirect with predecrement mode with invalid register

	movea.l	-(a8), a0

negative: data register indirect with predecrement mode with missing register

	movea.l	-(), a0

negative: data register indirect with predecrement mode with data register

	movea.l	-(d0), a0

positive: address register indirect with displacement mode

	movea.l	(-32768, a0), a0
	movea.l	(+32767, a7), a0

negative: address register indirect with displacement mode with missing displacement

	movea.l	(, a0), a0

negative: address register indirect with displacement mode with missing comma

	movea.l	(-32768 a0), a0

negative: address register indirect with displacement mode with missing register

	movea.l	(-32768, ), a0

negative: address register indirect with displacement mode with too small displacement

	movea.l	(-32769, a0), a0

negative: address register indirect with displacement mode with too large displacement

	movea.l	(+32768, a0), a0

negative: address register indirect with displacement mode with invalid register

	movea.l	(-32769, a8), a0

negative: address register indirect with displacement mode with data register

	movea.l	(-32769, d0), a0

positive: address register indirect with index mode

	movea.l	(-128, a0, a0.w), a0
	movea.l	(+127, a7, d0.l), a0

negative: address register indirect with index mode with missing displacement

	movea.l	(, a0, a0.w), a0

negative: address register indirect with index mode with missing first comma

	movea.l	(-128 a0, a0.w), a0

negative: address register indirect with index mode with missing register

	movea.l	(-128, , a0.w), a0

negative: address register indirect with index mode with missing second comma

	movea.l	(-128, a0 a0.w), a0

negative: address register indirect with index mode with missing index

	movea.l	(-128, a0, .w), a0

negative: address register indirect with index mode with missing width

	movea.l	(-128, a0, a0), a0

negative: address register indirect with index mode with too small displacement

	movea.l	(-129, a0, a0.w), a0

negative: address register indirect with index mode with too large displacement

	movea.l	(+128, a0, d0.w), a0

negative: address register indirect with index mode with invalid register

	movea.l	(-128, a8, a0.w), a0

negative: address register indirect with index mode with data register

	movea.l	(-128, d0, a0.w), a0

negative: address register indirect with index mode with invalid index

	movea.l	(-128, d0, a8.w), a0

positive: address register indirect with index mode with address index

	movea.l	(-128, a0, a0.w), a0
	movea.l	(-128, a0, a7.w), a0

positive: address register indirect with index mode with data index

	movea.l	(-128, a0, d0.w), a0
	movea.l	(-128, a0, d7.w), a0

negative: address register indirect with index mode with byte index

	movea.l	(-128, a0, a0.b), a0

positive: address register indirect with index mode with word index

	movea.l	(-128, a0, a0.w), a0

positive: address register indirect with index mode with long index

	movea.l	(-128, a0, a0.l), a0

positive: program counter indirect with displacement mode

	movea.l	(-32768, pc), a0
	movea.l	(+32767, pc), a0

negative: program counter indirect with displacement mode with missing displacement

	movea.l	(, pc), a0

negative: program counter indirect with displacement mode with missing comma

	movea.l	(-32768 pc), a0

negative: program counter indirect with displacement mode with missing program counter

	movea.l	(-32768, ), a0

negative: program counter indirect with displacement mode with too small displacement

	movea.l	(-32769, pc), a0

negative: program counter indirect with displacement mode with too large displacement

	movea.l	(+32768, pc), a0

positive: program counter indirect with index mode

	movea.l	(-128, pc, a0.w), a0
	movea.l	(+127, pc, d0.l), a0

negative: program counter indirect with index mode with missing displacement

	movea.l	(, pc, a0.w), a0

negative: program counter indirect with index mode with missing first comma

	movea.l	(-128 pc, a0.w), a0

negative: program counter indirect with index mode with missing program counter

	movea.l	(-128, , a0.w), a0

negative: program counter indirect with index mode with missing second comma

	movea.l	(-128, pc a0.w), a0

negative: program counter indirect with index mode with missing index

	movea.l	(-128, pc, .w), a0

negative: program counter indirect with index mode with missing width

	movea.l	(-128, pc, a0), a0

negative: program counter indirect with index mode with too small displacement

	movea.l	(-129, pc, a0.w), a0

negative: program counter indirect with index mode with too large displacement

	movea.l	(+128, pc, d0.w), a0

negative: program counter indirect with index mode with invalid index

	movea.l	(-128, pc, a8.w), a0

positive: program counter indirect with index mode with address index

	movea.l	(-128, pc, a0.w), a0
	movea.l	(-128, pc, a7.w), a0

positive: program counter indirect with index mode with data index

	movea.l	(-128, pc, d0.w), a0
	movea.l	(-128, pc, d7.w), a0

negative: program counter indirect with index mode with byte index

	movea.l	(-128, pc, a0.b), a0

positive: program counter indirect with index mode with word index

	movea.l	(-128, pc, a0.w), a0

positive: program counter indirect with index mode with long index

	movea.l	(-128, pc, a0.l), a0

positive: absolute short addressing mode

	movea.l	(-32768).w, a0
	movea.l	(+65535).w, a0

negative: absolute short addressing mode with missing address

	movea.l	().w, a0

negative: absolute short addressing mode with missing width

	movea.l	(-32768), a0

negative: absolute short addressing mode with too small address

	movea.l	(-32769).w, a0

negative: absolute short addressing mode with too large address

	movea.l	(+65536).w, a0

negative: absolute short addressing mode with address register

	movea.l	(a0).w, a0

negative: absolute short addressing mode with data register

	movea.l	(d0).w, a0

positive: absolute short addressing mode with address

	movea.l	(@test).w, a0

positive: absolute long addressing mode

	movea.l	(-2147483648).l, a0
	movea.l	(+2147483647).l, a0

negative: absolute long addressing mode with missing address

	movea.l	().l, a0

negative: absolute long addressing mode with missing width

	movea.l	(-2147483648), a0

negative: absolute long addressing mode with address register

	movea.l	(a0).l, a0

negative: absolute long addressing mode with data register

	movea.l	(d0).l, a0

positive: absolute long addressing mode with address

	movea.l	(@test).l, a0

# integer instructions

positive: abcd instruction

	abcd	d0, d0
	abcd	d7, d7
	abcd	-(a0), -(a0)
	abcd	-(a7), -(a7)

positive: add instruction

	add.b	d0, (a0)
	add.b	d7, (a7)
	add.b	d0, (a0)+
	add.b	d7, (a7)+
	add.b	d0, -(a0)
	add.b	d7, -(a7)
	add.b	d0, (-32768, a0)
	add.b	d7, (+32767, a7)
	add.b	d0, (-0x78, a0, a0.w)
	add.b	d7, (+0x78, a0, d7.l)
	add.b	d0, (-0x5678).w
	add.b	d7, (+0x5678).w
	add.b	d0, (-0x12345678).l
	add.b	d7, (+0x12345678).l
	add.b	d0, d0
	add.b	d7, d7
	add.b	a0, d0
	add.b	a7, d7
	add.b	(a0), d0
	add.b	(a7), d7
	add.b	(a0)+, d0
	add.b	(a7)+, d7
	add.b	-(a0), d0
	add.b	-(a7), d7
	add.b	(-32768, a0), d0
	add.b	(+32767, a7), d7
	add.b	(-0x78, a0, a0.w), d0
	add.b	(+0x78, a0, d7.l), d7
	add.b	(-0x5678).w, d0
	add.b	(+0x5678).w, d7
	add.b	(-0x12345678).l, d0
	add.b	(+0x12345678).l, d7
	add.b	-0x78, d0
	add.b	+0x78, d7
	add.b	(-32768, pc), d0
	add.b	(+32767, pc), d7
	add.b	(-0x78, pc, a0.w), d0
	add.b	(+0x78, pc, d7.l), d7
	add.w	d0, (a0)
	add.w	d7, (a7)
	add.w	d0, (a0)+
	add.w	d7, (a7)+
	add.w	d0, -(a0)
	add.w	d7, -(a7)
	add.w	d0, (-32768, a0)
	add.w	d7, (+32767, a7)
	add.w	d0, (-0x78, a0, a0.w)
	add.w	d7, (+0x78, a0, d7.l)
	add.w	d0, (-0x5678).w
	add.w	d7, (+0x5678).w
	add.w	d0, (-0x12345678).l
	add.w	d7, (+0x12345678).l
	add.w	d0, d0
	add.w	d7, d7
	add.w	a0, d0
	add.w	a7, d7
	add.w	(a0), d0
	add.w	(a7), d7
	add.w	(a0)+, d0
	add.w	(a7)+, d7
	add.w	-(a0), d0
	add.w	-(a7), d7
	add.w	(-32768, a0), d0
	add.w	(+32767, a7), d7
	add.w	(-0x78, a0, a0.w), d0
	add.w	(+0x78, a0, d7.l), d7
	add.w	(-0x5678).w, d0
	add.w	(+0x5678).w, d7
	add.w	(-0x12345678).l, d0
	add.w	(+0x12345678).l, d7
	add.w	-0x5678, d0
	add.w	+0x5678, d7
	add.w	(-32768, pc), d0
	add.w	(+32767, pc), d7
	add.w	(-0x78, pc, a0.w), d0
	add.w	(+0x78, pc, d7.l), d7
	add.l	d0, (a0)
	add.l	d7, (a7)
	add.l	d0, (a0)+
	add.l	d7, (a7)+
	add.l	d0, -(a0)
	add.l	d7, -(a7)
	add.l	d0, (-32768, a0)
	add.l	d7, (+32767, a7)
	add.l	d0, (-0x78, a0, a0.w)
	add.l	d7, (+0x78, a0, d7.l)
	add.l	d0, (-0x5678).w
	add.l	d7, (+0x5678).w
	add.l	d0, (-0x12345678).l
	add.l	d7, (+0x12345678).l
	add.l	d0, d0
	add.l	d7, d7
	add.l	a0, d0
	add.l	a7, d7
	add.l	(a0), d0
	add.l	(a7), d7
	add.l	(a0)+, d0
	add.l	(a7)+, d7
	add.l	-(a0), d0
	add.l	-(a7), d7
	add.l	(-32768, a0), d0
	add.l	(+32767, a7), d7
	add.l	(-0x78, a0, a0.w), d0
	add.l	(+0x78, a0, d7.l), d7
	add.l	(-0x5678).w, d0
	add.l	(+0x5678).w, d7
	add.l	(-0x12345678).l, d0
	add.l	(+0x12345678).l, d7
	add.l	-0x12345678, d0
	add.l	+0x12345678, d7
	add.l	(-32768, pc), d0
	add.l	(+32767, pc), d7
	add.l	(-0x78, pc, a0.w), d0
	add.l	(+0x78, pc, d7.l), d7

positive: adda instruction

	adda.w	a0, a0
	adda.w	a7, a7
	adda.w	(a0), a0
	adda.w	(a7), a7
	adda.w	(a0)+, a0
	adda.w	(a7)+, a7
	adda.w	-(a0), a0
	adda.w	-(a7), a7
	adda.w	(-32768, a0), a0
	adda.w	(+32767, a7), a7
	adda.w	(-0x78, a0, a0.w), a0
	adda.w	(+0x78, a0, d7.l), a7
	adda.w	(-0x5678).w, a0
	adda.w	(+0x5678).w, a7
	adda.w	(-0x12345678).l, a0
	adda.w	(+0x12345678).l, a7
	adda.w	-0x5678, a0
	adda.w	+0x5678, a7
	adda.w	(-32768, pc), a0
	adda.w	(+32767, pc), a7
	adda.w	(-0x78, pc, a0.w), a0
	adda.w	(+0x78, pc, d7.l), a7
	adda.l	d0, a0
	adda.l	d7, a7
	adda.l	a0, a0
	adda.l	a7, a7
	adda.l	(a0), a0
	adda.l	(a7), a7
	adda.l	(a0)+, a0
	adda.l	(a7)+, a7
	adda.l	-(a0), a0
	adda.l	-(a7), a7
	adda.l	(-32768, a0), a0
	adda.l	(+32767, a7), a7
	adda.l	(-0x78, a0, a0.w), a0
	adda.l	(+0x78, a0, d7.l), a7
	adda.l	(-0x5678).w, a0
	adda.l	(+0x5678).w, a7
	adda.l	(-0x12345678).l, a0
	adda.l	(+0x12345678).l, a7
	adda.l	-0x12345678, a0
	adda.l	+0x12345678, a7
	adda.l	(-32768, pc), a0
	adda.l	(+32767, pc), a7
	adda.l	(-0x78, pc, a0.w), a0
	adda.l	(+0x78, pc, d7.l), a7

positive: addi instruction

	addi.b	-0x78, d0
	addi.b	+0x78, d7
	addi.b	-0x78, (a0)
	addi.b	+0x78, (a7)
	addi.b	-0x78, (a0)+
	addi.b	+0x78, (a7)+
	addi.b	-0x78, -(a0)
	addi.b	+0x78, -(a7)
	addi.b	-0x78, (-32768, a0)
	addi.b	+0x78, (+32767, a7)
	addi.b	-0x78, (-0x78, a0, a0.w)
	addi.b	+0x78, (+0x78, a0, d7.l)
	addi.b	-0x78, (-0x5678).w
	addi.b	+0x78, (+0x5678).w
	addi.b	-0x78, (-0x12345678).l
	addi.b	+0x78, (+0x12345678).l
	addi.w	-0x5678, d0
	addi.w	+0x5678, d7
	addi.w	-0x5678, (a0)
	addi.w	+0x5678, (a7)
	addi.w	-0x5678, (a0)+
	addi.w	+0x5678, (a7)+
	addi.w	-0x5678, -(a0)
	addi.w	+0x5678, -(a7)
	addi.w	-0x5678, (-32768, a0)
	addi.w	+0x5678, (+32767, a7)
	addi.w	-0x5678, (-0x78, a0, a0.w)
	addi.w	+0x5678, (+0x78, a0, d7.l)
	addi.w	-0x5678, (-0x5678).w
	addi.w	+0x5678, (+0x5678).w
	addi.w	-0x5678, (-0x12345678).l
	addi.w	+0x5678, (+0x12345678).l
	addi.l	-0x12345678, d0
	addi.l	+0x12345678, d7
	addi.l	-0x12345678, (a0)
	addi.l	+0x12345678, (a7)
	addi.l	-0x12345678, (a0)+
	addi.l	+0x12345678, (a7)+
	addi.l	-0x12345678, -(a0)
	addi.l	+0x12345678, -(a7)
	addi.l	-0x12345678, (-32768, a0)
	addi.l	+0x12345678, (+32767, a7)
	addi.l	-0x12345678, (-0x78, a0, a0.w)
	addi.l	+0x12345678, (+0x78, a0, d7.l)
	addi.l	-0x12345678, (-0x5678).w
	addi.l	+0x12345678, (+0x5678).w
	addi.l	-0x12345678, (-0x12345678).l
	addi.l	+0x12345678, (+0x12345678).l

positive: addq instruction

	addq.b	1, d0
	addq.b	8, d7
	addq.b	1, a0
	addq.b	8, a7
	addq.b	1, (a0)
	addq.b	8, (a7)
	addq.b	1, (a0)+
	addq.b	8, (a7)+
	addq.b	1, -(a0)
	addq.b	8, -(a7)
	addq.b	1, (-32768, a0)
	addq.b	8, (+32767, a7)
	addq.b	1, (-0x78, a0, a0.w)
	addq.b	8, (+0x78, a0, d7.l)
	addq.b	1, (-0x5678).w
	addq.b	8, (+0x5678).w
	addq.b	1, (-0x12345678).l
	addq.b	8, (+0x12345678).l
	addq.w	1, d0
	addq.w	8, d7
	addq.w	1, a0
	addq.w	8, a7
	addq.w	1, (a0)
	addq.w	8, (a7)
	addq.w	1, (a0)+
	addq.w	8, (a7)+
	addq.w	1, -(a0)
	addq.w	8, -(a7)
	addq.w	1, (-32768, a0)
	addq.w	8, (+32767, a7)
	addq.w	1, (-0x78, a0, a0.w)
	addq.w	8, (+0x78, a0, d7.l)
	addq.w	1, (-0x5678).w
	addq.w	8, (+0x5678).w
	addq.w	1, (-0x12345678).l
	addq.w	8, (+0x12345678).l
	addq.l	1, d0
	addq.l	8, d7
	addq.l	1, a0
	addq.l	8, a7
	addq.l	1, (a0)
	addq.l	8, (a7)
	addq.l	1, (a0)+
	addq.l	8, (a7)+
	addq.l	1, -(a0)
	addq.l	8, -(a7)
	addq.l	1, (-32768, a0)
	addq.l	8, (+32767, a7)
	addq.l	1, (-0x78, a0, a0.w)
	addq.l	8, (+0x78, a0, d7.l)
	addq.l	1, (-0x5678).w
	addq.l	8, (+0x5678).w
	addq.l	1, (-0x12345678).l
	addq.l	8, (+0x12345678).l

positive: addx instruction

	addx.b	d0, d0
	addx.b	d7, d7
	addx.b	-(a0), -(a0)
	addx.b	-(a7), -(a7)
	addx.w	d0, d0
	addx.w	d7, d7
	addx.w	-(a0), -(a0)
	addx.w	-(a7), -(a7)
	addx.l	d0, d0
	addx.l	d7, d7
	addx.l	-(a0), -(a0)
	addx.l	-(a7), -(a7)

positive: and instruction

	and.b	d0, (a0)
	and.b	d7, (a7)
	and.b	d0, (a0)+
	and.b	d7, (a7)+
	and.b	d0, -(a0)
	and.b	d7, -(a7)
	and.b	d0, (-32768, a0)
	and.b	d7, (+32767, a7)
	and.b	d0, (-0x78, a0, a0.w)
	and.b	d7, (+0x78, a0, d7.l)
	and.b	d0, (-0x5678).w
	and.b	d7, (+0x5678).w
	and.b	d0, (-0x12345678).l
	and.b	d7, (+0x12345678).l
	and.b	d0, d0
	and.b	d7, d7
	and.b	(a0), d0
	and.b	(a7), d7
	and.b	(a0)+, d0
	and.b	(a7)+, d7
	and.b	-(a0), d0
	and.b	-(a7), d7
	and.b	(-32768, a0), d0
	and.b	(+32767, a7), d7
	and.b	(-0x78, a0, a0.w), d0
	and.b	(+0x78, a0, d7.l), d7
	and.b	(-0x5678).w, d0
	and.b	(+0x5678).w, d7
	and.b	(-0x12345678).l, d0
	and.b	(+0x12345678).l, d7
	and.b	-0x78, d0
	and.b	+0x78, d7
	and.b	(-32768, pc), d0
	and.b	(+32767, pc), d7
	and.b	(-0x78, pc, a0.w), d0
	and.b	(+0x78, pc, d7.l), d7
	and.w	d0, (a0)
	and.w	d7, (a7)
	and.w	d0, (a0)+
	and.w	d7, (a7)+
	and.w	d0, -(a0)
	and.w	d7, -(a7)
	and.w	d0, (-32768, a0)
	and.w	d7, (+32767, a7)
	and.w	d0, (-0x78, a0, a0.w)
	and.w	d7, (+0x78, a0, d7.l)
	and.w	d0, (-0x5678).w
	and.w	d7, (+0x5678).w
	and.w	d0, (-0x12345678).l
	and.w	d7, (+0x12345678).l
	and.w	d0, d0
	and.w	d7, d7
	and.w	(a0), d0
	and.w	(a7), d7
	and.w	(a0)+, d0
	and.w	(a7)+, d7
	and.w	-(a0), d0
	and.w	-(a7), d7
	and.w	(-32768, a0), d0
	and.w	(+32767, a7), d7
	and.w	(-0x78, a0, a0.w), d0
	and.w	(+0x78, a0, d7.l), d7
	and.w	(-0x5678).w, d0
	and.w	(+0x5678).w, d7
	and.w	(-0x12345678).l, d0
	and.w	(+0x12345678).l, d7
	and.w	-0x5678, d0
	and.w	+0x5678, d7
	and.w	(-32768, pc), d0
	and.w	(+32767, pc), d7
	and.w	(-0x78, pc, a0.w), d0
	and.w	(+0x78, pc, d7.l), d7
	and.l	d0, (a0)
	and.l	d7, (a7)
	and.l	d0, (a0)+
	and.l	d7, (a7)+
	and.l	d0, -(a0)
	and.l	d7, -(a7)
	and.l	d0, (-32768, a0)
	and.l	d7, (+32767, a7)
	and.l	d0, (-0x78, a0, a0.w)
	and.l	d7, (+0x78, a0, d7.l)
	and.l	d0, (-0x5678).w
	and.l	d7, (+0x5678).w
	and.l	d0, (-0x12345678).l
	and.l	d7, (+0x12345678).l
	and.l	d0, d0
	and.l	d7, d7
	and.l	(a0), d0
	and.l	(a7), d7
	and.l	(a0)+, d0
	and.l	(a7)+, d7
	and.l	-(a0), d0
	and.l	-(a7), d7
	and.l	(-32768, a0), d0
	and.l	(+32767, a7), d7
	and.l	(-0x78, a0, a0.w), d0
	and.l	(+0x78, a0, d7.l), d7
	and.l	(-0x5678).w, d0
	and.l	(+0x5678).w, d7
	and.l	(-0x12345678).l, d0
	and.l	(+0x12345678).l, d7
	and.l	-0x12345678, d0
	and.l	+0x12345678, d7
	and.l	(-32768, pc), d0
	and.l	(+32767, pc), d7
	and.l	(-0x78, pc, a0.w), d0
	and.l	(+0x78, pc, d7.l), d7

positive: andi instruction

	andi.b	-0x78, d0
	andi.b	+0x78, d7
	andi.b	-0x78, (a0)
	andi.b	+0x78, (a7)
	andi.b	-0x78, (a0)+
	andi.b	+0x78, (a7)+
	andi.b	-0x78, -(a0)
	andi.b	+0x78, -(a7)
	andi.b	-0x78, (-32768, a0)
	andi.b	+0x78, (+32767, a7)
	andi.b	-0x78, (-0x78, a0, a0.w)
	andi.b	+0x78, (+0x78, a0, d7.l)
	andi.b	-0x78, (-0x5678).w
	andi.b	+0x78, (+0x5678).w
	andi.b	-0x78, (-0x12345678).l
	andi.b	+0x78, (+0x12345678).l
	andi.w	-0x5678, d0
	andi.w	+0x5678, d7
	andi.w	-0x5678, (a0)
	andi.w	+0x5678, (a7)
	andi.w	-0x5678, (a0)+
	andi.w	+0x5678, (a7)+
	andi.w	-0x5678, -(a0)
	andi.w	+0x5678, -(a7)
	andi.w	-0x5678, (-32768, a0)
	andi.w	+0x5678, (+32767, a7)
	andi.w	-0x5678, (-0x78, a0, a0.w)
	andi.w	+0x5678, (+0x78, a0, d7.l)
	andi.w	-0x5678, (-0x5678).w
	andi.w	+0x5678, (+0x5678).w
	andi.w	-0x5678, (-0x12345678).l
	andi.w	+0x5678, (+0x12345678).l
	andi.l	-0x12345678, d0
	andi.l	+0x12345678, d7
	andi.l	-0x12345678, (a0)
	andi.l	+0x12345678, (a7)
	andi.l	-0x12345678, (a0)+
	andi.l	+0x12345678, (a7)+
	andi.l	-0x12345678, -(a0)
	andi.l	+0x12345678, -(a7)
	andi.l	-0x12345678, (-32768, a0)
	andi.l	+0x12345678, (+32767, a7)
	andi.l	-0x12345678, (-0x78, a0, a0.w)
	andi.l	+0x12345678, (+0x78, a0, d7.l)
	andi.l	-0x12345678, (-0x5678).w
	andi.l	+0x12345678, (+0x5678).w
	andi.l	-0x12345678, (-0x12345678).l
	andi.l	+0x12345678, (+0x12345678).l
	andi	-0x78, ccr
	andi	+0x78, ccr
	andi	-0x5678, sr
	andi	+0x5678, sr

positive: asl instruction

	asl.b	d0, d0
	asl.b	d7, d7
	asl.b	1, d0
	asl.b	8, d7
	asl.w	d0, d0
	asl.w	d7, d7
	asl.w	1, d0
	asl.w	8, d7
	asl.w	(a0)
	asl.w	(a7)
	asl.w	(a0)+
	asl.w	(a7)+
	asl.w	-(a0)
	asl.w	-(a7)
	asl.w	(-32768, a0)
	asl.w	(+32767, a7)
	asl.w	(-0x78, a0, a0.w)
	asl.w	(+0x78, a0, d7.l)
	asl.w	(-0x5678).w
	asl.w	(+0x5678).w
	asl.w	(-0x12345678).l
	asl.w	(+0x12345678).l
	asl.l	d0, d0
	asl.l	d7, d7
	asl.l	1, d0
	asl.l	8, d7

positive: asr instruction

	asr.b	d0, d0
	asr.b	d7, d7
	asr.b	1, d0
	asr.b	8, d7
	asr.w	d0, d0
	asr.w	d7, d7
	asr.w	1, d0
	asr.w	8, d7
	asr.w	(a0)
	asr.w	(a7)
	asr.w	(a0)+
	asr.w	(a7)+
	asr.w	-(a0)
	asr.w	-(a7)
	asr.w	(-32768, a0)
	asr.w	(+32767, a7)
	asr.w	(-0x78, a0, a0.w)
	asr.w	(+0x78, a0, d7.l)
	asr.w	(-0x5678).w
	asr.w	(+0x5678).w
	asr.w	(-0x12345678).l
	asr.w	(+0x12345678).l
	asr.l	d0, d0
	asr.l	d7, d7
	asr.l	1, d0
	asr.l	8, d7

positive: bcc instruction

	bcc.b	-0x78
	bcc.b	+0x78
	bcc.w	-0x5678
	bcc.w	+0x5678

positive: bcs instruction

	bcs.b	-0x78
	bcs.b	+0x78
	bcs.w	-0x5678
	bcs.w	+0x5678

positive: beq instruction

	beq.b	-0x78
	beq.b	+0x78
	beq.w	-0x5678
	beq.w	+0x5678

positive: bge instruction

	bge.b	-0x78
	bge.b	+0x78
	bge.w	-0x5678
	bge.w	+0x5678

positive: bgt instruction

	bgt.b	-0x78
	bgt.b	+0x78
	bgt.w	-0x5678
	bgt.w	+0x5678

positive: bhi instruction

	bhi.b	-0x78
	bhi.b	+0x78
	bhi.w	-0x5678
	bhi.w	+0x5678

positive: bhs instruction

	bhs.b	-0x78
	bhs.b	+0x78
	bhs.w	-0x5678
	bhs.w	+0x5678

positive: ble instruction

	ble.b	-0x78
	ble.b	+0x78
	ble.w	-0x5678
	ble.w	+0x5678

positive: blo instruction

	blo.b	-0x78
	blo.b	+0x78
	blo.w	-0x5678
	blo.w	+0x5678

positive: bls instruction

	bls.b	-0x78
	bls.b	+0x78
	bls.w	-0x5678
	bls.w	+0x5678

positive: blt instruction

	blt.b	-0x78
	blt.b	+0x78
	blt.w	-0x5678
	blt.w	+0x5678

positive: bmi instruction

	bmi.b	-0x78
	bmi.b	+0x78
	bmi.w	-0x5678
	bmi.w	+0x5678

positive: bne instruction

	bne.b	-0x78
	bne.b	+0x78
	bne.w	-0x5678
	bne.w	+0x5678

positive: bpl instruction

	bpl.b	-0x78
	bpl.b	+0x78
	bpl.w	-0x5678
	bpl.w	+0x5678

positive: bvc instruction

	bvc.b	-0x78
	bvc.b	+0x78
	bvc.w	-0x5678
	bvc.w	+0x5678

positive: bvs instruction

	bvs.b	-0x78
	bvs.b	+0x78
	bvs.w	-0x5678
	bvs.w	+0x5678

positive: bchg instruction

	bchg	d0, d0
	bchg	d7, d7
	bchg	d0, (a0)
	bchg	d7, (a7)
	bchg	d0, (a0)+
	bchg	d7, (a7)+
	bchg	d0, -(a0)
	bchg	d7, -(a7)
	bchg	d0, (-32768, a0)
	bchg	d7, (+32767, a7)
	bchg	d0, (-0x78, a0, a0.w)
	bchg	d7, (+0x78, a0, d7.l)
	bchg	d0, (-0x5678).w
	bchg	d7, (+0x5678).w
	bchg	d0, (-0x12345678).l
	bchg	d7, (+0x12345678).l
	bchg	0, d0
	bchg	31, d7
	bchg	0, (a0)
	bchg	7, (a7)
	bchg	0, (a0)+
	bchg	7, (a7)+
	bchg	0, -(a0)
	bchg	7, -(a7)
	bchg	0, (-32768, a0)
	bchg	7, (+32767, a7)
	bchg	0, (-0x78, a0, a0.w)
	bchg	7, (+0x78, a0, d7.l)
	bchg	0, (-0x5678).w
	bchg	7, (+0x5678).w
	bchg	0, (-0x12345678).l
	bchg	7, (+0x12345678).l

positive: bclr instruction

	bclr	d0, d0
	bclr	d7, d7
	bclr	d0, (a0)
	bclr	d7, (a7)
	bclr	d0, (a0)+
	bclr	d7, (a7)+
	bclr	d0, -(a0)
	bclr	d7, -(a7)
	bclr	d0, (-32768, a0)
	bclr	d7, (+32767, a7)
	bclr	d0, (-0x78, a0, a0.w)
	bclr	d7, (+0x78, a0, d7.l)
	bclr	d0, (-0x5678).w
	bclr	d7, (+0x5678).w
	bclr	d0, (-0x12345678).l
	bclr	d7, (+0x12345678).l
	bclr	0, d0
	bclr	31, d7
	bclr	0, (a0)
	bclr	7, (a7)
	bclr	0, (a0)+
	bclr	7, (a7)+
	bclr	0, -(a0)
	bclr	7, -(a7)
	bclr	0, (-32768, a0)
	bclr	7, (+32767, a7)
	bclr	0, (-0x78, a0, a0.w)
	bclr	7, (+0x78, a0, d7.l)
	bclr	0, (-0x5678).w
	bclr	7, (+0x5678).w
	bclr	0, (-0x12345678).l
	bclr	7, (+0x12345678).l

positive: bra instruction

	bra.b	-0x78
	bra.b	+0x78
	bra.w	-0x5678
	bra.w	+0x5678

positive: bset instruction

	bset	d0, d0
	bset	d7, d7
	bset	d0, (a0)
	bset	d7, (a7)
	bset	d0, (a0)+
	bset	d7, (a7)+
	bset	d0, -(a0)
	bset	d7, -(a7)
	bset	d0, (-32768, a0)
	bset	d7, (+32767, a7)
	bset	d0, (-0x78, a0, a0.w)
	bset	d7, (+0x78, a0, d7.l)
	bset	d0, (-0x5678).w
	bset	d7, (+0x5678).w
	bset	d0, (-0x12345678).l
	bset	d7, (+0x12345678).l
	bset	0, d0
	bset	31, d7
	bset	0, (a0)
	bset	7, (a7)
	bset	0, (a0)+
	bset	7, (a7)+
	bset	0, -(a0)
	bset	7, -(a7)
	bset	0, (-32768, a0)
	bset	7, (+32767, a7)
	bset	0, (-0x78, a0, a0.w)
	bset	7, (+0x78, a0, d7.l)
	bset	0, (-0x5678).w
	bset	7, (+0x5678).w
	bset	0, (-0x12345678).l
	bset	7, (+0x12345678).l

positive: bsr instruction

	bsr.b	-0x78
	bsr.b	+0x78
	bsr.w	-0x5678
	bsr.w	+0x5678

positive: btst instruction

	btst	d0, d0
	btst	d7, d7
	btst	d0, (a0)
	btst	d7, (a7)
	btst	d0, (a0)+
	btst	d7, (a7)+
	btst	d0, -(a0)
	btst	d7, -(a7)
	btst	d0, (-32768, a0)
	btst	d7, (+32767, a7)
	btst	d0, (-0x78, a0, a0.w)
	btst	d7, (+0x78, a0, d7.l)
	btst	d0, (-0x5678).w
	btst	d7, (+0x5678).w
	btst	d0, (-0x12345678).l
	btst	d7, (+0x12345678).l
	btst	0, d0
	btst	31, d7
	btst	0, (a0)
	btst	7, (a7)
	btst	0, (a0)+
	btst	7, (a7)+
	btst	0, -(a0)
	btst	7, -(a7)
	btst	0, (-32768, a0)
	btst	7, (+32767, a7)
	btst	0, (-0x78, a0, a0.w)
	btst	7, (+0x78, a0, d7.l)
	btst	0, (-0x5678).w
	btst	7, (+0x5678).w
	btst	0, (-0x12345678).l
	btst	7, (+0x12345678).l

positive: chk instruction

	chk	d0, d0
	chk	d7, d7
	chk	(a0), d0
	chk	(a7), d7
	chk	(a0)+, d0
	chk	(a7)+, d7
	chk	-(a0), d0
	chk	-(a7), d7
	chk	(-32768, a0), d0
	chk	(+32767, a7), d7
	chk	(-0x78, a0, a0.w), d0
	chk	(+0x78, a0, d7.l), d7
	chk	(-0x5678).w, d0
	chk	(+0x5678).w, d7
	chk	(-0x12345678).l, d0
	chk	(+0x12345678).l, d7
	chk	-0x5678, d0
	chk	+0x5678, d7
	chk	(-32768, pc), d0
	chk	(+32767, pc), d7
	chk	(-0x78, pc, a0.w), d0
	chk	(+0x78, pc, d7.l), d7

positive: clr instruction

	clr.b	d0
	clr.b	d7
	clr.b	(a0)
	clr.b	(a7)
	clr.b	(a0)+
	clr.b	(a7)+
	clr.b	-(a0)
	clr.b	-(a7)
	clr.b	(-32768, a0)
	clr.b	(+32767, a7)
	clr.b	(-0x78, a0, a0.w)
	clr.b	(+0x78, a0, d7.l)
	clr.b	(-0x5678).w
	clr.b	(+0x5678).w
	clr.b	(-0x12345678).l
	clr.b	(+0x12345678).l
	clr.w	d0
	clr.w	d7
	clr.w	(a0)
	clr.w	(a7)
	clr.w	(a0)+
	clr.w	(a7)+
	clr.w	-(a0)
	clr.w	-(a7)
	clr.w	(-32768, a0)
	clr.w	(+32767, a7)
	clr.w	(-0x78, a0, a0.w)
	clr.w	(+0x78, a0, d7.l)
	clr.w	(-0x5678).w
	clr.w	(+0x5678).w
	clr.w	(-0x12345678).l
	clr.w	(+0x12345678).l
	clr.l	d0
	clr.l	d7
	clr.l	(a0)
	clr.l	(a7)
	clr.l	(a0)+
	clr.l	(a7)+
	clr.l	-(a0)
	clr.l	-(a7)
	clr.l	(-32768, a0)
	clr.l	(+32767, a7)
	clr.l	(-0x78, a0, a0.w)
	clr.l	(+0x78, a0, d7.l)
	clr.l	(-0x5678).w
	clr.l	(+0x5678).w
	clr.l	(-0x12345678).l
	clr.l	(+0x12345678).l

positive: cmp instruction

	cmp.b	a0, d0
	cmp.b	a7, d7
	cmp.b	(a0), d0
	cmp.b	(a7), d7
	cmp.b	(a0)+, d0
	cmp.b	(a7)+, d7
	cmp.b	-(a0), d0
	cmp.b	-(a7), d7
	cmp.b	(-32768, a0), d0
	cmp.b	(+32767, a7), d7
	cmp.b	(-0x78, a0, a0.w), d0
	cmp.b	(+0x78, a0, d7.l), d7
	cmp.b	(-0x5678).w, d0
	cmp.b	(+0x5678).w, d7
	cmp.b	(-0x12345678).l, d0
	cmp.b	(+0x12345678).l, d7
	cmp.b	-0x78, d0
	cmp.b	+0x78, d7
	cmp.b	(-32768, pc), d0
	cmp.b	(+32767, pc), d7
	cmp.b	(-0x78, pc, a0.w), d0
	cmp.b	(+0x78, pc, d7.l), d7
	cmp.w	a0, d0
	cmp.w	a7, d7
	cmp.w	(a0), d0
	cmp.w	(a7), d7
	cmp.w	(a0)+, d0
	cmp.w	(a7)+, d7
	cmp.w	-(a0), d0
	cmp.w	-(a7), d7
	cmp.w	(-32768, a0), d0
	cmp.w	(+32767, a7), d7
	cmp.w	(-0x78, a0, a0.w), d0
	cmp.w	(+0x78, a0, d7.l), d7
	cmp.w	(-0x5678).w, d0
	cmp.w	(+0x5678).w, d7
	cmp.w	(-0x12345678).l, d0
	cmp.w	(+0x12345678).l, d7
	cmp.w	-0x5678, d0
	cmp.w	+0x5678, d7
	cmp.w	(-32768, pc), d0
	cmp.w	(+32767, pc), d7
	cmp.w	(-0x78, pc, a0.w), d0
	cmp.w	(+0x78, pc, d7.l), d7
	cmp.l	a0, d0
	cmp.l	a7, d7
	cmp.l	(a0), d0
	cmp.l	(a7), d7
	cmp.l	(a0)+, d0
	cmp.l	(a7)+, d7
	cmp.l	-(a0), d0
	cmp.l	-(a7), d7
	cmp.l	(-32768, a0), d0
	cmp.l	(+32767, a7), d7
	cmp.l	(-0x78, a0, a0.w), d0
	cmp.l	(+0x78, a0, d7.l), d7
	cmp.l	(-0x5678).w, d0
	cmp.l	(+0x5678).w, d7
	cmp.l	(-0x12345678).l, d0
	cmp.l	(+0x12345678).l, d7
	cmp.l	-0x12345678, d0
	cmp.l	+0x12345678, d7
	cmp.l	(-32768, pc), d0
	cmp.l	(+32767, pc), d7
	cmp.l	(-0x78, pc, a0.w), d0
	cmp.l	(+0x78, pc, d7.l), d7

positive: cmpa instruction

	cmpa.w	a0, a0
	cmpa.w	a7, a7
	cmpa.w	(a0), a0
	cmpa.w	(a7), a7
	cmpa.w	(a0)+, a0
	cmpa.w	(a7)+, a7
	cmpa.w	-(a0), a0
	cmpa.w	-(a7), a7
	cmpa.w	(-32768, a0), a0
	cmpa.w	(+32767, a7), a7
	cmpa.w	(-0x78, a0, a0.w), a0
	cmpa.w	(+0x78, a0, d7.l), a7
	cmpa.w	(-0x5678).w, a0
	cmpa.w	(+0x5678).w, a7
	cmpa.w	(-0x12345678).l, a0
	cmpa.w	(+0x12345678).l, a7
	cmpa.w	-0x5678, a0
	cmpa.w	+0x5678, a7
	cmpa.w	(-32768, pc), a0
	cmpa.w	(+32767, pc), a7
	cmpa.w	(-0x78, pc, a0.w), a0
	cmpa.w	(+0x78, pc, d7.l), a7
	cmpa.l	a0, a0
	cmpa.l	a7, a7
	cmpa.l	(a0), a0
	cmpa.l	(a7), a7
	cmpa.l	(a0)+, a0
	cmpa.l	(a7)+, a7
	cmpa.l	-(a0), a0
	cmpa.l	-(a7), a7
	cmpa.l	(-32768, a0), a0
	cmpa.l	(+32767, a7), a7
	cmpa.l	(-0x78, a0, a0.w), a0
	cmpa.l	(+0x78, a0, d7.l), a7
	cmpa.l	(-0x5678).w, a0
	cmpa.l	(+0x5678).w, a7
	cmpa.l	(-0x12345678).l, a0
	cmpa.l	(+0x12345678).l, a7
	cmpa.l	-0x12345678, a0
	cmpa.l	+0x12345678, a7
	cmpa.l	(-32768, pc), a0
	cmpa.l	(+32767, pc), a7
	cmpa.l	(-0x78, pc, a0.w), a0
	cmpa.l	(+0x78, pc, d7.l), a7

positive: cmpi instruction

	cmpi.b	-0x78, d0
	cmpi.b	+0x78, d7
	cmpi.b	-0x78, (a0)
	cmpi.b	+0x78, (a7)
	cmpi.b	-0x78, (a0)+
	cmpi.b	+0x78, (a7)+
	cmpi.b	-0x78, -(a0)
	cmpi.b	+0x78, -(a7)
	cmpi.b	-0x78, (-32768, a0)
	cmpi.b	+0x78, (+32767, a7)
	cmpi.b	-0x78, (-0x78, a0, a0.w)
	cmpi.b	+0x78, (+0x78, a0, d7.l)
	cmpi.b	-0x78, (-0x5678).w
	cmpi.b	+0x78, (+0x5678).w
	cmpi.b	-0x78, (-0x12345678).l
	cmpi.b	+0x78, (+0x12345678).l
	cmpi.b	-0x78, (-32768, pc)
	cmpi.b	+0x78, (+32767, pc)
	cmpi.b	-0x78, (-0x78, pc, a0.w)
	cmpi.b	+0x78, (+0x78, pc, d7.l)
	cmpi.w	-0x5678, d0
	cmpi.w	+0x5678, d7
	cmpi.w	-0x5678, (a0)
	cmpi.w	+0x5678, (a7)
	cmpi.w	-0x5678, (a0)+
	cmpi.w	+0x5678, (a7)+
	cmpi.w	-0x5678, -(a0)
	cmpi.w	+0x5678, -(a7)
	cmpi.w	-0x5678, (-32768, a0)
	cmpi.w	+0x5678, (+32767, a7)
	cmpi.w	-0x5678, (-0x78, a0, a0.w)
	cmpi.w	+0x5678, (+0x78, a0, d7.l)
	cmpi.w	-0x5678, (-0x5678).w
	cmpi.w	+0x5678, (+0x5678).w
	cmpi.w	-0x5678, (-0x12345678).l
	cmpi.w	+0x5678, (+0x12345678).l
	cmpi.w	-0x5678, (-32768, pc)
	cmpi.w	+0x5678, (+32767, pc)
	cmpi.w	-0x5678, (-0x78, pc, a0.w)
	cmpi.w	+0x5678, (+0x78, pc, d7.l)
	cmpi.l	-0x12345678, d0
	cmpi.l	+0x12345678, d7
	cmpi.l	-0x12345678, (a0)
	cmpi.l	+0x12345678, (a7)
	cmpi.l	-0x12345678, (a0)+
	cmpi.l	+0x12345678, (a7)+
	cmpi.l	-0x12345678, -(a0)
	cmpi.l	+0x12345678, -(a7)
	cmpi.l	-0x12345678, (-32768, a0)
	cmpi.l	+0x12345678, (+32767, a7)
	cmpi.l	-0x12345678, (-0x78, a0, a0.w)
	cmpi.l	+0x12345678, (+0x78, a0, d7.l)
	cmpi.l	-0x12345678, (-0x5678).w
	cmpi.l	+0x12345678, (+0x5678).w
	cmpi.l	-0x12345678, (-0x12345678).l
	cmpi.l	+0x12345678, (+0x12345678).l
	cmpi.l	-0x12345678, (-32768, pc)
	cmpi.l	+0x12345678, (+32767, pc)
	cmpi.l	-0x12345678, (-0x78, pc, a0.w)
	cmpi.l	+0x12345678, (+0x78, pc, d7.l)

positive: cmpm instruction

	cmpm.b	(a0)+, (a0)+
	cmpm.b	(a7)+, (a7)+
	cmpm.w	(a0)+, (a0)+
	cmpm.w	(a7)+, (a7)+
	cmpm.l	(a0)+, (a0)+
	cmpm.l	(a7)+, (a7)+

positive: dbcc instruction

	dbcc	d0, -0x5678
	dbcc	d7, +0x5678

positive: dbcs instruction

	dbcs	d0, -0x5678
	dbcs	d7, +0x5678

positive: dbeq instruction

	dbeq	d0, -0x5678
	dbeq	d7, +0x5678

positive: dbge instruction

	dbge	d0, -0x5678
	dbge	d7, +0x5678

positive: dbgt instruction

	dbgt	d0, -0x5678
	dbgt	d7, +0x5678

positive: dbhi instruction

	dbhi	d0, -0x5678
	dbhi	d7, +0x5678

positive: dbhs instruction

	dbhs	d0, -0x5678
	dbhs	d7, +0x5678

positive: dble instruction

	dble	d0, -0x5678
	dble	d7, +0x5678

positive: dblo instruction

	dblo	d0, -0x5678
	dblo	d7, +0x5678

positive: dbls instruction

	dbls	d0, -0x5678
	dbls	d7, +0x5678

positive: dblt instruction

	dblt	d0, -0x5678
	dblt	d7, +0x5678

positive: dbmi instruction

	dbmi	d0, -0x5678
	dbmi	d7, +0x5678

positive: dbne instruction

	dbne	d0, -0x5678
	dbne	d7, +0x5678

positive: dbpl instruction

	dbpl	d0, -0x5678
	dbpl	d7, +0x5678

positive: dbvc instruction

	dbvc	d0, -0x5678
	dbvc	d7, +0x5678

positive: dbvs instruction

	dbvs	d0, -0x5678
	dbvs	d7, +0x5678

positive: divs instruction

	divs	d0, d0
	divs	d7, d7
	divs	(a0), d0
	divs	(a7), d7
	divs	(a0)+, d0
	divs	(a7)+, d7
	divs	-(a0), d0
	divs	-(a7), d7
	divs	(-32768, a0), d0
	divs	(+32767, a7), d7
	divs	(-0x78, a0, a0.w), d0
	divs	(+0x78, a0, d7.l), d7
	divs	(-0x5678).w, d0
	divs	(+0x5678).w, d7
	divs	(-0x12345678).l, d0
	divs	(+0x12345678).l, d7
	divs	-0x5678, d0
	divs	+0x5678, d7
	divs	(-32768, pc), d0
	divs	(+32767, pc), d7
	divs	(-0x78, pc, a0.w), d0
	divs	(+0x78, pc, d7.l), d7

positive: divu instruction

	divu	d0, d0
	divu	d7, d7
	divu	(a0), d0
	divu	(a7), d7
	divu	(a0)+, d0
	divu	(a7)+, d7
	divu	-(a0), d0
	divu	-(a7), d7
	divu	(-32768, a0), d0
	divu	(+32767, a7), d7
	divu	(-0x78, a0, a0.w), d0
	divu	(+0x78, a0, d7.l), d7
	divu	(-0x5678).w, d0
	divu	(+0x5678).w, d7
	divu	(-0x12345678).l, d0
	divu	(+0x12345678).l, d7
	divu	-0x5678, d0
	divu	+0x5678, d7
	divu	(-32768, pc), d0
	divu	(+32767, pc), d7
	divu	(-0x78, pc, a0.w), d0
	divu	(+0x78, pc, d7.l), d7

positive: eor instruction

	eor.b	d0, d0
	eor.b	d7, d7
	eor.b	d0, (a0)
	eor.b	d7, (a7)
	eor.b	d0, (a0)+
	eor.b	d7, (a7)+
	eor.b	d0, -(a0)
	eor.b	d7, -(a7)
	eor.b	d0, (-32768, a0)
	eor.b	d7, (+32767, a7)
	eor.b	d0, (-0x78, a0, a0.w)
	eor.b	d7, (+0x78, a0, d7.l)
	eor.b	d0, (-0x5678).w
	eor.b	d7, (+0x5678).w
	eor.b	d0, (-0x12345678).l
	eor.b	d7, (+0x12345678).l
	eor.w	d0, d0
	eor.w	d7, d7
	eor.w	d0, (a0)
	eor.w	d7, (a7)
	eor.w	d0, (a0)+
	eor.w	d7, (a7)+
	eor.w	d0, -(a0)
	eor.w	d7, -(a7)
	eor.w	d0, (-32768, a0)
	eor.w	d7, (+32767, a7)
	eor.w	d0, (-0x78, a0, a0.w)
	eor.w	d7, (+0x78, a0, d7.l)
	eor.w	d0, (-0x5678).w
	eor.w	d7, (+0x5678).w
	eor.w	d0, (-0x12345678).l
	eor.w	d7, (+0x12345678).l
	eor.l	d0, d0
	eor.l	d7, d7
	eor.l	d0, (a0)
	eor.l	d7, (a7)
	eor.l	d0, (a0)+
	eor.l	d7, (a7)+
	eor.l	d0, -(a0)
	eor.l	d7, -(a7)
	eor.l	d0, (-32768, a0)
	eor.l	d7, (+32767, a7)
	eor.l	d0, (-0x78, a0, a0.w)
	eor.l	d7, (+0x78, a0, d7.l)
	eor.l	d0, (-0x5678).w
	eor.l	d7, (+0x5678).w
	eor.l	d0, (-0x12345678).l
	eor.l	d7, (+0x12345678).l

positive: eori instruction

	eori.b	-0x78, d0
	eori.b	+0x78, d7
	eori.b	-0x78, (a0)
	eori.b	+0x78, (a7)
	eori.b	-0x78, (a0)+
	eori.b	+0x78, (a7)+
	eori.b	-0x78, -(a0)
	eori.b	+0x78, -(a7)
	eori.b	-0x78, (-32768, a0)
	eori.b	+0x78, (+32767, a7)
	eori.b	-0x78, (-0x78, a0, a0.w)
	eori.b	+0x78, (+0x78, a0, d7.l)
	eori.b	-0x78, (-0x5678).w
	eori.b	+0x78, (+0x5678).w
	eori.b	-0x78, (-0x12345678).l
	eori.b	+0x78, (+0x12345678).l
	eori.w	-0x5678, d0
	eori.w	+0x5678, d7
	eori.w	-0x5678, (a0)
	eori.w	+0x5678, (a7)
	eori.w	-0x5678, (a0)+
	eori.w	+0x5678, (a7)+
	eori.w	-0x5678, -(a0)
	eori.w	+0x5678, -(a7)
	eori.w	-0x5678, (-32768, a0)
	eori.w	+0x5678, (+32767, a7)
	eori.w	-0x5678, (-0x78, a0, a0.w)
	eori.w	+0x5678, (+0x78, a0, d7.l)
	eori.w	-0x5678, (-0x5678).w
	eori.w	+0x5678, (+0x5678).w
	eori.w	-0x5678, (-0x12345678).l
	eori.w	+0x5678, (+0x12345678).l
	eori.l	-0x12345678, d0
	eori.l	+0x12345678, d7
	eori.l	-0x12345678, (a0)
	eori.l	+0x12345678, (a7)
	eori.l	-0x12345678, (a0)+
	eori.l	+0x12345678, (a7)+
	eori.l	-0x12345678, -(a0)
	eori.l	+0x12345678, -(a7)
	eori.l	-0x12345678, (-32768, a0)
	eori.l	+0x12345678, (+32767, a7)
	eori.l	-0x12345678, (-0x78, a0, a0.w)
	eori.l	+0x12345678, (+0x78, a0, d7.l)
	eori.l	-0x12345678, (-0x5678).w
	eori.l	+0x12345678, (+0x5678).w
	eori.l	-0x12345678, (-0x12345678).l
	eori.l	+0x12345678, (+0x12345678).l
	eori	-0x78, ccr
	eori	+0x78, ccr
	eori	-0x5678, sr
	eori	+0x5678, sr

positive: exg instruction

	exg	d0, d0
	exg	d7, d7
	exg	a0, a0
	exg	a7, a7
	exg	d0, a0
	exg	d7, a7

positive: ext instruction

	ext.w	d0
	ext.w	d7
	ext.l	d0
	ext.l	d7

positive: illegal instruction

	illegal

positive: jmp instruction

	jmp	(a0)
	jmp	(a7)
	jmp	(-32768, a0)
	jmp	(+32767, a7)
	jmp	(-0x78, a0, a0.w)
	jmp	(+0x78, a0, d7.l)
	jmp	(-0x5678).w
	jmp	(+0x5678).w
	jmp	(-0x12345678).l
	jmp	(+0x12345678).l
	jmp	(-32768, pc)
	jmp	(+32767, pc)
	jmp	(-0x78, pc, a0.w)
	jmp	(+0x78, pc, d7.l)

positive: jsr instruction

	jsr	(a0)
	jsr	(a7)
	jsr	(-32768, a0)
	jsr	(+32767, a7)
	jsr	(-0x78, a0, a0.w)
	jsr	(+0x78, a0, d7.l)
	jsr	(-0x5678).w
	jsr	(+0x5678).w
	jsr	(-0x12345678).l
	jsr	(+0x12345678).l
	jsr	(-32768, pc)
	jsr	(+32767, pc)
	jsr	(-0x78, pc, a0.w)
	jsr	(+0x78, pc, d7.l)

positive: lea instruction

	lea	(a0), a0
	lea	(a7), a7
	lea	(-32768, a0), a0
	lea	(+32767, a7), a7
	lea	(-0x78, a0, a0.w), a0
	lea	(+0x78, a0, d7.l), a7
	lea	(-0x5678).w, a0
	lea	(+0x5678).w, a7
	lea	(-0x12345678).l, a0
	lea	(+0x12345678).l, a7
	lea	(-32768, pc), a0
	lea	(+32767, pc), a7
	lea	(-0x78, pc, a0.w), a0
	lea	(+0x78, pc, d7.l), a7

positive: link instruction

	link	a0, -0x5678
	link	a7, +0x5678

positive: lsl instruction

	lsl.b	d0, d0
	lsl.b	d7, d7
	lsl.b	1, d0
	lsl.b	8, d7
	lsl.w	d0, d0
	lsl.w	d7, d7
	lsl.w	1, d0
	lsl.w	8, d7
	lsl.w	(a0)
	lsl.w	(a7)
	lsl.w	(a0)+
	lsl.w	(a7)+
	lsl.w	-(a0)
	lsl.w	-(a7)
	lsl.w	(-32768, a0)
	lsl.w	(+32767, a7)
	lsl.w	(-0x78, a0, a0.w)
	lsl.w	(+0x78, a0, d7.l)
	lsl.w	(-0x5678).w
	lsl.w	(+0x5678).w
	lsl.w	(-0x12345678).l
	lsl.w	(+0x12345678).l
	lsl.l	d0, d0
	lsl.l	d7, d7
	lsl.l	1, d0
	lsl.l	8, d7

positive: lsr instruction

	lsr.b	d0, d0
	lsr.b	d7, d7
	lsr.b	1, d0
	lsr.b	8, d7
	lsr.w	d0, d0
	lsr.w	d7, d7
	lsr.w	1, d0
	lsr.w	8, d7
	lsr.w	(a0)
	lsr.w	(a7)
	lsr.w	(a0)+
	lsr.w	(a7)+
	lsr.w	-(a0)
	lsr.w	-(a7)
	lsr.w	(-32768, a0)
	lsr.w	(+32767, a7)
	lsr.w	(-0x78, a0, a0.w)
	lsr.w	(+0x78, a0, d7.l)
	lsr.w	(-0x5678).w
	lsr.w	(+0x5678).w
	lsr.w	(-0x12345678).l
	lsr.w	(+0x12345678).l
	lsr.l	d0, d0
	lsr.l	d7, d7
	lsr.l	1, d0
	lsr.l	8, d7

positive: move instruction

	move.b	d0, d0
	move.b	d7, d7
	move.b	d0, (a0)
	move.b	d7, (a7)
	move.b	d0, (a0)+
	move.b	d7, (a7)+
	move.b	d0, -(a0)
	move.b	d7, -(a7)
	move.b	d0, (-32768, a0)
	move.b	d7, (+32767, a7)
	move.b	d0, (-0x78, a0, a0.w)
	move.b	d7, (+0x78, a0, d7.l)
	move.b	d0, (-0x5678).w
	move.b	d7, (+0x5678).w
	move.b	d0, (-0x12345678).l
	move.b	d7, (+0x12345678).l
	move.b	a0, d0
	move.b	a7, d7
	move.b	a0, (a0)
	move.b	a7, (a7)
	move.b	a0, (a0)+
	move.b	a7, (a7)+
	move.b	a0, -(a0)
	move.b	a7, -(a7)
	move.b	a0, (-32768, a0)
	move.b	a7, (+32767, a7)
	move.b	a0, (-0x78, a0, a0.w)
	move.b	a7, (+0x78, a0, d7.l)
	move.b	a0, (-0x5678).w
	move.b	a7, (+0x5678).w
	move.b	a0, (-0x12345678).l
	move.b	a7, (+0x12345678).l
	move.b	(a0), d0
	move.b	(a7), d7
	move.b	(a0), (a0)
	move.b	(a7), (a7)
	move.b	(a0), (a0)+
	move.b	(a7), (a7)+
	move.b	(a0), -(a0)
	move.b	(a7), -(a7)
	move.b	(a0), (-32768, a0)
	move.b	(a7), (+32767, a7)
	move.b	(a0), (-0x78, a0, a0.w)
	move.b	(a7), (+0x78, a0, d7.l)
	move.b	(a0), (-0x5678).w
	move.b	(a7), (+0x5678).w
	move.b	(a0), (-0x12345678).l
	move.b	(a7), (+0x12345678).l
	move.b	(a0)+, d0
	move.b	(a7)+, d7
	move.b	(a0)+, (a0)
	move.b	(a7)+, (a7)
	move.b	(a0)+, (a0)+
	move.b	(a7)+, (a7)+
	move.b	(a0)+, -(a0)
	move.b	(a7)+, -(a7)
	move.b	(a0)+, (-32768, a0)
	move.b	(a7)+, (+32767, a7)
	move.b	(a0)+, (-0x78, a0, a0.w)
	move.b	(a7)+, (+0x78, a0, d7.l)
	move.b	(a0)+, (-0x5678).w
	move.b	(a7)+, (+0x5678).w
	move.b	(a0)+, (-0x12345678).l
	move.b	(a7)+, (+0x12345678).l
	move.b	-(a0), d0
	move.b	-(a7), d7
	move.b	-(a0), (a0)
	move.b	-(a7), (a7)
	move.b	-(a0), (a0)+
	move.b	-(a7), (a7)+
	move.b	-(a0), -(a0)
	move.b	-(a7), -(a7)
	move.b	-(a0), (-32768, a0)
	move.b	-(a7), (+32767, a7)
	move.b	-(a0), (-0x78, a0, a0.w)
	move.b	-(a7), (+0x78, a0, d7.l)
	move.b	-(a0), (-0x5678).w
	move.b	-(a7), (+0x5678).w
	move.b	-(a0), (-0x12345678).l
	move.b	-(a7), (+0x12345678).l
	move.b	(-32768, a0), d0
	move.b	(+32767, a7), d7
	move.b	(-32768, a0), (a0)
	move.b	(+32767, a7), (a7)
	move.b	(-32768, a0), (a0)+
	move.b	(+32767, a7), (a7)+
	move.b	(-32768, a0), -(a0)
	move.b	(+32767, a7), -(a7)
	move.b	(-32768, a0), (-32768, a0)
	move.b	(+32767, a7), (+32767, a7)
	move.b	(-32768, a0), (-0x78, a0, a0.w)
	move.b	(+32767, a7), (+0x78, a0, d7.l)
	move.b	(-32768, a0), (-0x5678).w
	move.b	(+32767, a7), (+0x5678).w
	move.b	(-32768, a0), (-0x12345678).l
	move.b	(+32767, a7), (+0x12345678).l
	move.b	(-0x78, a0, a0.w), d0
	move.b	(+0x78, a0, d7.l), d7
	move.b	(-0x78, a0, a0.w), (a0)
	move.b	(+0x78, a0, d7.l), (a7)
	move.b	(-0x78, a0, a0.w), (a0)+
	move.b	(+0x78, a0, d7.l), (a7)+
	move.b	(-0x78, a0, a0.w), -(a0)
	move.b	(+0x78, a0, d7.l), -(a7)
	move.b	(-0x78, a0, a0.w), (-32768, a0)
	move.b	(+0x78, a0, d7.l), (+32767, a7)
	move.b	(-0x78, a0, a0.w), (-0x78, a0, a0.w)
	move.b	(+0x78, a0, d7.l), (+0x78, a0, d7.l)
	move.b	(-0x78, a0, a0.w), (-0x5678).w
	move.b	(+0x78, a0, d7.l), (+0x5678).w
	move.b	(-0x78, a0, a0.w), (-0x12345678).l
	move.b	(+0x78, a0, d7.l), (+0x12345678).l
	move.b	(-0x5678).w, d0
	move.b	(+0x5678).w, d7
	move.b	(-0x5678).w, (a0)
	move.b	(+0x5678).w, (a7)
	move.b	(-0x5678).w, (a0)+
	move.b	(+0x5678).w, (a7)+
	move.b	(-0x5678).w, -(a0)
	move.b	(+0x5678).w, -(a7)
	move.b	(-0x5678).w, (-32768, a0)
	move.b	(+0x5678).w, (+32767, a7)
	move.b	(-0x5678).w, (-0x78, a0, a0.w)
	move.b	(+0x5678).w, (+0x78, a0, d7.l)
	move.b	(-0x5678).w, (-0x5678).w
	move.b	(+0x5678).w, (+0x5678).w
	move.b	(-0x5678).w, (-0x12345678).l
	move.b	(+0x5678).w, (+0x12345678).l
	move.b	(-0x12345678).l, d0
	move.b	(+0x12345678).l, d7
	move.b	(-0x12345678).l, (a0)
	move.b	(+0x12345678).l, (a7)
	move.b	(-0x12345678).l, (a0)+
	move.b	(+0x12345678).l, (a7)+
	move.b	(-0x12345678).l, -(a0)
	move.b	(+0x12345678).l, -(a7)
	move.b	(-0x12345678).l, (-32768, a0)
	move.b	(+0x12345678).l, (+32767, a7)
	move.b	(-0x12345678).l, (-0x78, a0, a0.w)
	move.b	(+0x12345678).l, (+0x78, a0, d7.l)
	move.b	(-0x12345678).l, (-0x5678).w
	move.b	(+0x12345678).l, (+0x5678).w
	move.b	(-0x12345678).l, (-0x12345678).l
	move.b	(+0x12345678).l, (+0x12345678).l
	move.b	-0x78, d0
	move.b	+0x78, d7
	move.b	-0x78, (a0)
	move.b	+0x78, (a7)
	move.b	-0x78, (a0)+
	move.b	+0x78, (a7)+
	move.b	-0x78, -(a0)
	move.b	+0x78, -(a7)
	move.b	-0x78, (-32768, a0)
	move.b	+0x78, (+32767, a7)
	move.b	-0x78, (-0x78, a0, a0.w)
	move.b	+0x78, (+0x78, a0, d7.l)
	move.b	-0x78, (-0x5678).w
	move.b	+0x78, (+0x5678).w
	move.b	-0x78, (-0x12345678).l
	move.b	+0x78, (+0x12345678).l
	move.b	(-32768, pc), d0
	move.b	(+32767, pc), d7
	move.b	(-32768, pc), (a0)
	move.b	(+32767, pc), (a7)
	move.b	(-32768, pc), (a0)+
	move.b	(+32767, pc), (a7)+
	move.b	(-32768, pc), -(a0)
	move.b	(+32767, pc), -(a7)
	move.b	(-32768, pc), (-32768, a0)
	move.b	(+32767, pc), (+32767, a7)
	move.b	(-32768, pc), (-0x78, a0, a0.w)
	move.b	(+32767, pc), (+0x78, a0, d7.l)
	move.b	(-32768, pc), (-0x5678).w
	move.b	(+32767, pc), (+0x5678).w
	move.b	(-32768, pc), (-0x12345678).l
	move.b	(+32767, pc), (+0x12345678).l
	move.b	(-0x78, pc, a0.w), d0
	move.b	(+0x78, pc, d7.l), d7
	move.b	(-0x78, pc, a0.w), (a0)
	move.b	(+0x78, pc, d7.l), (a7)
	move.b	(-0x78, pc, a0.w), (a0)+
	move.b	(+0x78, pc, d7.l), (a7)+
	move.b	(-0x78, pc, a0.w), -(a0)
	move.b	(+0x78, pc, d7.l), -(a7)
	move.b	(-0x78, pc, a0.w), (-32768, a0)
	move.b	(+0x78, pc, d7.l), (+32767, a7)
	move.b	(-0x78, pc, a0.w), (-0x78, a0, a0.w)
	move.b	(+0x78, pc, d7.l), (+0x78, a7, d7.l)
	move.b	(-0x78, pc, a0.w), (-0x5678).w
	move.b	(+0x78, pc, d7.l), (+0x5678).w
	move.b	(-0x78, pc, a0.w), (-0x12345678).l
	move.b	(+0x78, pc, d7.l), (+0x12345678).l
	move.w	d0, d0
	move.w	d7, d7
	move.w	d0, (a0)
	move.w	d7, (a7)
	move.w	d0, (a0)+
	move.w	d7, (a7)+
	move.w	d0, -(a0)
	move.w	d7, -(a7)
	move.w	d0, (-32768, a0)
	move.w	d7, (+32767, a7)
	move.w	d0, (-0x78, a0, a0.w)
	move.w	d7, (+0x78, a0, d7.l)
	move.w	d0, (-0x5678).w
	move.w	d7, (+0x5678).w
	move.w	d0, (-0x12345678).l
	move.w	d7, (+0x12345678).l
	move.w	a0, d0
	move.w	a7, d7
	move.w	a0, (a0)
	move.w	a7, (a7)
	move.w	a0, (a0)+
	move.w	a7, (a7)+
	move.w	a0, -(a0)
	move.w	a7, -(a7)
	move.w	a0, (-32768, a0)
	move.w	a7, (+32767, a7)
	move.w	a0, (-0x78, a0, a0.w)
	move.w	a7, (+0x78, a0, d7.l)
	move.w	a0, (-0x5678).w
	move.w	a7, (+0x5678).w
	move.w	a0, (-0x12345678).l
	move.w	a7, (+0x12345678).l
	move.w	(a0), d0
	move.w	(a7), d7
	move.w	(a0), (a0)
	move.w	(a7), (a7)
	move.w	(a0), (a0)+
	move.w	(a7), (a7)+
	move.w	(a0), -(a0)
	move.w	(a7), -(a7)
	move.w	(a0), (-32768, a0)
	move.w	(a7), (+32767, a7)
	move.w	(a0), (-0x78, a0, a0.w)
	move.w	(a7), (+0x78, a0, d7.l)
	move.w	(a0), (-0x5678).w
	move.w	(a7), (+0x5678).w
	move.w	(a0), (-0x12345678).l
	move.w	(a7), (+0x12345678).l
	move.w	(a0)+, d0
	move.w	(a7)+, d7
	move.w	(a0)+, (a0)
	move.w	(a7)+, (a7)
	move.w	(a0)+, (a0)+
	move.w	(a7)+, (a7)+
	move.w	(a0)+, -(a0)
	move.w	(a7)+, -(a7)
	move.w	(a0)+, (-32768, a0)
	move.w	(a7)+, (+32767, a7)
	move.w	(a0)+, (-0x78, a0, a0.w)
	move.w	(a7)+, (+0x78, a0, d7.l)
	move.w	(a0)+, (-0x5678).w
	move.w	(a7)+, (+0x5678).w
	move.w	(a0)+, (-0x12345678).l
	move.w	(a7)+, (+0x12345678).l
	move.w	-(a0), d0
	move.w	-(a7), d7
	move.w	-(a0), (a0)
	move.w	-(a7), (a7)
	move.w	-(a0), (a0)+
	move.w	-(a7), (a7)+
	move.w	-(a0), -(a0)
	move.w	-(a7), -(a7)
	move.w	-(a0), (-32768, a0)
	move.w	-(a7), (+32767, a7)
	move.w	-(a0), (-0x78, a0, a0.w)
	move.w	-(a7), (+0x78, a0, d7.l)
	move.w	-(a0), (-0x5678).w
	move.w	-(a7), (+0x5678).w
	move.w	-(a0), (-0x12345678).l
	move.w	-(a7), (+0x12345678).l
	move.w	(-32768, a0), d0
	move.w	(+32767, a7), d7
	move.w	(-32768, a0), (a0)
	move.w	(+32767, a7), (a7)
	move.w	(-32768, a0), (a0)+
	move.w	(+32767, a7), (a7)+
	move.w	(-32768, a0), -(a0)
	move.w	(+32767, a7), -(a7)
	move.w	(-32768, a0), (-32768, a0)
	move.w	(+32767, a7), (+32767, a7)
	move.w	(-32768, a0), (-0x78, a0, a0.w)
	move.w	(+32767, a7), (+0x78, a0, d7.l)
	move.w	(-32768, a0), (-0x5678).w
	move.w	(+32767, a7), (+0x5678).w
	move.w	(-32768, a0), (-0x12345678).l
	move.w	(+32767, a7), (+0x12345678).l
	move.w	(-0x78, a0, a0.w), d0
	move.w	(+0x78, a0, d7.l), d7
	move.w	(-0x78, a0, a0.w), (a0)
	move.w	(+0x78, a0, d7.l), (a7)
	move.w	(-0x78, a0, a0.w), (a0)+
	move.w	(+0x78, a0, d7.l), (a7)+
	move.w	(-0x78, a0, a0.w), -(a0)
	move.w	(+0x78, a0, d7.l), -(a7)
	move.w	(-0x78, a0, a0.w), (-32768, a0)
	move.w	(+0x78, a0, d7.l), (+32767, a7)
	move.w	(-0x78, a0, a0.w), (-0x78, a0, a0.w)
	move.w	(+0x78, a0, d7.l), (+0x78, a0, d7.l)
	move.w	(-0x78, a0, a0.w), (-0x5678).w
	move.w	(+0x78, a0, d7.l), (+0x5678).w
	move.w	(-0x78, a0, a0.w), (-0x12345678).l
	move.w	(+0x78, a0, d7.l), (+0x12345678).l
	move.w	(-0x5678).w, d0
	move.w	(+0x5678).w, d7
	move.w	(-0x5678).w, (a0)
	move.w	(+0x5678).w, (a7)
	move.w	(-0x5678).w, (a0)+
	move.w	(+0x5678).w, (a7)+
	move.w	(-0x5678).w, -(a0)
	move.w	(+0x5678).w, -(a7)
	move.w	(-0x5678).w, (-32768, a0)
	move.w	(+0x5678).w, (+32767, a7)
	move.w	(-0x5678).w, (-0x78, a0, a0.w)
	move.w	(+0x5678).w, (+0x78, a0, d7.l)
	move.w	(-0x5678).w, (-0x5678).w
	move.w	(+0x5678).w, (+0x5678).w
	move.w	(-0x5678).w, (-0x12345678).l
	move.w	(+0x5678).w, (+0x12345678).l
	move.w	(-0x12345678).l, d0
	move.w	(+0x12345678).l, d7
	move.w	(-0x12345678).l, (a0)
	move.w	(+0x12345678).l, (a7)
	move.w	(-0x12345678).l, (a0)+
	move.w	(+0x12345678).l, (a7)+
	move.w	(-0x12345678).l, -(a0)
	move.w	(+0x12345678).l, -(a7)
	move.w	(-0x12345678).l, (-32768, a0)
	move.w	(+0x12345678).l, (+32767, a7)
	move.w	(-0x12345678).l, (-0x78, a0, a0.w)
	move.w	(+0x12345678).l, (+0x78, a0, d7.l)
	move.w	(-0x12345678).l, (-0x5678).w
	move.w	(+0x12345678).l, (+0x5678).w
	move.w	(-0x12345678).l, (-0x12345678).l
	move.w	(+0x12345678).l, (+0x12345678).l
	move.w	-0x5678, d0
	move.w	+0x5678, d7
	move.w	-0x5678, (a0)
	move.w	+0x5678, (a7)
	move.w	-0x5678, (a0)+
	move.w	+0x5678, (a7)+
	move.w	-0x5678, -(a0)
	move.w	+0x5678, -(a7)
	move.w	-0x5678, (-32768, a0)
	move.w	+0x5678, (+32767, a7)
	move.w	-0x5678, (-0x78, a0, a0.w)
	move.w	+0x5678, (+0x78, a0, d7.l)
	move.w	-0x5678, (-0x5678).w
	move.w	+0x5678, (+0x5678).w
	move.w	-0x5678, (-0x12345678).l
	move.w	+0x5678, (+0x12345678).l
	move.w	(-32768, pc), d0
	move.w	(+32767, pc), d7
	move.w	(-32768, pc), (a0)
	move.w	(+32767, pc), (a7)
	move.w	(-32768, pc), (a0)+
	move.w	(+32767, pc), (a7)+
	move.w	(-32768, pc), -(a0)
	move.w	(+32767, pc), -(a7)
	move.w	(-32768, pc), (-32768, a0)
	move.w	(+32767, pc), (+32767, a7)
	move.w	(-32768, pc), (-0x78, a0, a0.w)
	move.w	(+32767, pc), (+0x78, a0, d7.l)
	move.w	(-32768, pc), (-0x5678).w
	move.w	(+32767, pc), (+0x5678).w
	move.w	(-32768, pc), (-0x12345678).l
	move.w	(+32767, pc), (+0x12345678).l
	move.w	(-0x78, pc, a0.w), d0
	move.w	(+0x78, pc, d7.l), d7
	move.w	(-0x78, pc, a0.w), (a0)
	move.w	(+0x78, pc, d7.l), (a7)
	move.w	(-0x78, pc, a0.w), (a0)+
	move.w	(+0x78, pc, d7.l), (a7)+
	move.w	(-0x78, pc, a0.w), -(a0)
	move.w	(+0x78, pc, d7.l), -(a7)
	move.w	(-0x78, pc, a0.w), (-32768, a0)
	move.w	(+0x78, pc, d7.l), (+32767, a7)
	move.w	(-0x78, pc, a0.w), (-0x78, a0, a0.w)
	move.w	(+0x78, pc, d7.l), (+0x78, a7, d7.l)
	move.w	(-0x78, pc, a0.w), (-0x5678).w
	move.w	(+0x78, pc, d7.l), (+0x5678).w
	move.w	(-0x78, pc, a0.w), (-0x12345678).l
	move.w	(+0x78, pc, d7.l), (+0x12345678).l
	move.l	d0, d0
	move.l	d7, d7
	move.l	d0, (a0)
	move.l	d7, (a7)
	move.l	d0, (a0)+
	move.l	d7, (a7)+
	move.l	d0, -(a0)
	move.l	d7, -(a7)
	move.l	d0, (-32768, a0)
	move.l	d7, (+32767, a7)
	move.l	d0, (-0x78, a0, a0.w)
	move.l	d7, (+0x78, a0, d7.l)
	move.l	d0, (-0x5678).w
	move.l	d7, (+0x5678).w
	move.l	d0, (-0x12345678).l
	move.l	d7, (+0x12345678).l
	move.l	a0, d0
	move.l	a7, d7
	move.l	a0, (a0)
	move.l	a7, (a7)
	move.l	a0, (a0)+
	move.l	a7, (a7)+
	move.l	a0, -(a0)
	move.l	a7, -(a7)
	move.l	a0, (-32768, a0)
	move.l	a7, (+32767, a7)
	move.l	a0, (-0x78, a0, a0.w)
	move.l	a7, (+0x78, a0, d7.l)
	move.l	a0, (-0x5678).w
	move.l	a7, (+0x5678).w
	move.l	a0, (-0x12345678).l
	move.l	a7, (+0x12345678).l
	move.l	(a0), d0
	move.l	(a7), d7
	move.l	(a0), (a0)
	move.l	(a7), (a7)
	move.l	(a0), (a0)+
	move.l	(a7), (a7)+
	move.l	(a0), -(a0)
	move.l	(a7), -(a7)
	move.l	(a0), (-32768, a0)
	move.l	(a7), (+32767, a7)
	move.l	(a0), (-0x78, a0, a0.w)
	move.l	(a7), (+0x78, a0, d7.l)
	move.l	(a0), (-0x5678).w
	move.l	(a7), (+0x5678).w
	move.l	(a0), (-0x12345678).l
	move.l	(a7), (+0x12345678).l
	move.l	(a0)+, d0
	move.l	(a7)+, d7
	move.l	(a0)+, (a0)
	move.l	(a7)+, (a7)
	move.l	(a0)+, (a0)+
	move.l	(a7)+, (a7)+
	move.l	(a0)+, -(a0)
	move.l	(a7)+, -(a7)
	move.l	(a0)+, (-32768, a0)
	move.l	(a7)+, (+32767, a7)
	move.l	(a0)+, (-0x78, a0, a0.w)
	move.l	(a7)+, (+0x78, a0, d7.l)
	move.l	(a0)+, (-0x5678).w
	move.l	(a7)+, (+0x5678).w
	move.l	(a0)+, (-0x12345678).l
	move.l	(a7)+, (+0x12345678).l
	move.l	-(a0), d0
	move.l	-(a7), d7
	move.l	-(a0), (a0)
	move.l	-(a7), (a7)
	move.l	-(a0), (a0)+
	move.l	-(a7), (a7)+
	move.l	-(a0), -(a0)
	move.l	-(a7), -(a7)
	move.l	-(a0), (-32768, a0)
	move.l	-(a7), (+32767, a7)
	move.l	-(a0), (-0x78, a0, a0.w)
	move.l	-(a7), (+0x78, a0, d7.l)
	move.l	-(a0), (-0x5678).w
	move.l	-(a7), (+0x5678).w
	move.l	-(a0), (-0x12345678).l
	move.l	-(a7), (+0x12345678).l
	move.l	(-32768, a0), d0
	move.l	(+32767, a7), d7
	move.l	(-32768, a0), (a0)
	move.l	(+32767, a7), (a7)
	move.l	(-32768, a0), (a0)+
	move.l	(+32767, a7), (a7)+
	move.l	(-32768, a0), -(a0)
	move.l	(+32767, a7), -(a7)
	move.l	(-32768, a0), (-32768, a0)
	move.l	(+32767, a7), (+32767, a7)
	move.l	(-32768, a0), (-0x78, a0, a0.w)
	move.l	(+32767, a7), (+0x78, a0, d7.l)
	move.l	(-32768, a0), (-0x5678).w
	move.l	(+32767, a7), (+0x5678).w
	move.l	(-32768, a0), (-0x12345678).l
	move.l	(+32767, a7), (+0x12345678).l
	move.l	(-0x78, a0, a0.w), d0
	move.l	(+0x78, a0, d7.l), d7
	move.l	(-0x78, a0, a0.w), (a0)
	move.l	(+0x78, a0, d7.l), (a7)
	move.l	(-0x78, a0, a0.w), (a0)+
	move.l	(+0x78, a0, d7.l), (a7)+
	move.l	(-0x78, a0, a0.w), -(a0)
	move.l	(+0x78, a0, d7.l), -(a7)
	move.l	(-0x78, a0, a0.w), (-32768, a0)
	move.l	(+0x78, a0, d7.l), (+32767, a7)
	move.l	(-0x78, a0, a0.w), (-0x78, a0, a0.w)
	move.l	(+0x78, a0, d7.l), (+0x78, a0, d7.l)
	move.l	(-0x78, a0, a0.w), (-0x5678).w
	move.l	(+0x78, a0, d7.l), (+0x5678).w
	move.l	(-0x78, a0, a0.w), (-0x12345678).l
	move.l	(+0x78, a0, d7.l), (+0x12345678).l
	move.l	(-0x5678).w, d0
	move.l	(+0x5678).w, d7
	move.l	(-0x5678).w, (a0)
	move.l	(+0x5678).w, (a7)
	move.l	(-0x5678).w, (a0)+
	move.l	(+0x5678).w, (a7)+
	move.l	(-0x5678).w, -(a0)
	move.l	(+0x5678).w, -(a7)
	move.l	(-0x5678).w, (-32768, a0)
	move.l	(+0x5678).w, (+32767, a7)
	move.l	(-0x5678).w, (-0x78, a0, a0.w)
	move.l	(+0x5678).w, (+0x78, a0, d7.l)
	move.l	(-0x5678).w, (-0x5678).w
	move.l	(+0x5678).w, (+0x5678).w
	move.l	(-0x5678).w, (-0x12345678).l
	move.l	(+0x5678).w, (+0x12345678).l
	move.l	(-0x12345678).l, d0
	move.l	(+0x12345678).l, d7
	move.l	(-0x12345678).l, (a0)
	move.l	(+0x12345678).l, (a7)
	move.l	(-0x12345678).l, (a0)+
	move.l	(+0x12345678).l, (a7)+
	move.l	(-0x12345678).l, -(a0)
	move.l	(+0x12345678).l, -(a7)
	move.l	(-0x12345678).l, (-32768, a0)
	move.l	(+0x12345678).l, (+32767, a7)
	move.l	(-0x12345678).l, (-0x78, a0, a0.w)
	move.l	(+0x12345678).l, (+0x78, a0, d7.l)
	move.l	(-0x12345678).l, (-0x5678).w
	move.l	(+0x12345678).l, (+0x5678).w
	move.l	(-0x12345678).l, (-0x12345678).l
	move.l	(+0x12345678).l, (+0x12345678).l
	move.l	-0x12345678, d0
	move.l	+0x12345678, d7
	move.l	-0x12345678, (a0)
	move.l	+0x12345678, (a7)
	move.l	-0x12345678, (a0)+
	move.l	+0x12345678, (a7)+
	move.l	-0x12345678, -(a0)
	move.l	+0x12345678, -(a7)
	move.l	-0x12345678, (-32768, a0)
	move.l	+0x12345678, (+32767, a7)
	move.l	-0x12345678, (-0x78, a0, a0.w)
	move.l	+0x12345678, (+0x78, a0, d7.l)
	move.l	-0x12345678, (-0x5678).w
	move.l	+0x12345678, (+0x5678).w
	move.l	-0x12345678, (-0x12345678).l
	move.l	+0x12345678, (+0x12345678).l
	move.l	(-32768, pc), d0
	move.l	(+32767, pc), d7
	move.l	(-32768, pc), (a0)
	move.l	(+32767, pc), (a7)
	move.l	(-32768, pc), (a0)+
	move.l	(+32767, pc), (a7)+
	move.l	(-32768, pc), -(a0)
	move.l	(+32767, pc), -(a7)
	move.l	(-32768, pc), (-32768, a0)
	move.l	(+32767, pc), (+32767, a7)
	move.b	(-32768, pc), (-0x78, a0, a0.w)
	move.b	(+32767, pc), (+0x78, a0, d7.l)
	move.l	(-32768, pc), (-0x5678).w
	move.l	(+32767, pc), (+0x5678).w
	move.l	(-32768, pc), (-0x12345678).l
	move.l	(+32767, pc), (+0x12345678).l
	move.l	(-0x78, pc, a0.w), d0
	move.l	(+0x78, pc, d7.l), d7
	move.l	(-0x78, pc, a0.w), (a0)
	move.l	(+0x78, pc, d7.l), (a7)
	move.l	(-0x78, pc, a0.w), (a0)+
	move.l	(+0x78, pc, d7.l), (a7)+
	move.l	(-0x78, pc, a0.w), -(a0)
	move.l	(+0x78, pc, d7.l), -(a7)
	move.l	(-0x78, pc, a0.w), (-32768, a0)
	move.l	(+0x78, pc, d7.l), (+32767, a7)
	move.l	(-0x78, pc, a0.w), (-0x78, a0, a0.w)
	move.l	(+0x78, pc, d7.l), (+0x78, a7, d7.l)
	move.l	(-0x78, pc, a0.w), (-0x5678).w
	move.l	(+0x78, pc, d7.l), (+0x5678).w
	move.l	(-0x78, pc, a0.w), (-0x12345678).l
	move.l	(+0x78, pc, d7.l), (+0x12345678).l
	move	ccr, d0
	move	ccr, d7
	move	ccr, (a0)
	move	ccr, (a7)
	move	ccr, (a0)+
	move	ccr, (a7)+
	move	ccr, -(a0)
	move	ccr, -(a7)
	move	ccr, (-32768, a0)
	move	ccr, (+32767, a7)
	move	ccr, (-0x78, a0, a0.w)
	move	ccr, (+0x78, a0, d7.l)
	move	ccr, (-0x5678).w
	move	ccr, (+0x5678).w
	move	ccr, (-0x12345678).l
	move	ccr, (+0x12345678).l
	move	d0, ccr
	move	d7, ccr
	move	(a0), ccr
	move	(a7), ccr
	move	(a0)+, ccr
	move	(a7)+, ccr
	move	-(a0), ccr
	move	-(a7), ccr
	move	(-32768, a0), ccr
	move	(+32767, a7), ccr
	move	(-0x78, a0, a0.w), ccr
	move	(+0x78, a0, d7.l), ccr
	move	(-0x5678).w, ccr
	move	(+0x5678).w, ccr
	move	(-0x12345678).l, ccr
	move	(+0x12345678).l, ccr
	move	-0x5678, ccr
	move	+0x5678, ccr
	move	(-32768, pc), ccr
	move	(+32767, pc), ccr
	move	(-0x78, pc, a0.w), ccr
	move	(+0x78, pc, d7.l), ccr
	move	sr, d0
	move	sr, d7
	move	sr, (a0)
	move	sr, (a7)
	move	sr, (a0)+
	move	sr, (a7)+
	move	sr, -(a0)
	move	sr, -(a7)
	move	sr, (-32768, a0)
	move	sr, (+32767, a7)
	move	sr, (-0x78, a0, a0.w)
	move	sr, (+0x78, a0, d7.l)
	move	sr, (-0x5678).w
	move	sr, (+0x5678).w
	move	sr, (-0x12345678).l
	move	sr, (+0x12345678).l
	move	d0, sr
	move	d7, sr
	move	(a0), sr
	move	(a7), sr
	move	(a0)+, sr
	move	(a7)+, sr
	move	-(a0), sr
	move	-(a7), sr
	move	(-32768, a0), sr
	move	(+32767, a7), sr
	move	(-0x78, a0, a0.w), sr
	move	(+0x78, a0, d7.l), sr
	move	(-0x5678).w, sr
	move	(+0x5678).w, sr
	move	(-0x12345678).l, sr
	move	(+0x12345678).l, sr
	move	-0x5678, sr
	move	+0x5678, sr
	move	(-32768, pc), sr
	move	(+32767, pc), sr
	move	(-0x78, pc, a0.w), sr
	move	(+0x78, pc, d7.l), sr
	move	usp, a0
	move	usp, a7
	move	a0, usp
	move	a7, usp

positive: movea instruction

	movea.w	d0, a0
	movea.w	d7, a7
	movea.w	a0, a0
	movea.w	a7, a7
	movea.w	(a0), a0
	movea.w	(a7), a7
	movea.w	(a0)+, a0
	movea.w	(a7)+, a7
	movea.w	-(a0), a0
	movea.w	-(a7), a7
	movea.w	(-32768, a0), a0
	movea.w	(+32767, a7), a7
	movea.w	(-0x78, a0, a0.w), a0
	movea.w	(+0x78, a0, d7.l), a7
	movea.w	(-0x5678).w, a0
	movea.w	(+0x5678).w, a7
	movea.w	(-0x12345678).l, a0
	movea.w	(+0x12345678).l, a7
	movea.w	-0x5678, a0
	movea.w	+0x5678, a7
	movea.w	(-32768, pc), a0
	movea.w	(+32767, pc), a7
	movea.w	(-0x78, pc, a0.w), a0
	movea.w	(+0x78, pc, d7.l), a7
	movea.l	d0, a0
	movea.l	d7, a7
	movea.l	a0, a0
	movea.l	a7, a7
	movea.l	(a0), a0
	movea.l	(a7), a7
	movea.l	(a0)+, a0
	movea.l	(a7)+, a7
	movea.l	-(a0), a0
	movea.l	-(a7), a7
	movea.l	(-32768, a0), a0
	movea.l	(+32767, a7), a7
	movea.l	(-0x78, a0, a0.w), a0
	movea.l	(+0x78, a0, d7.l), a7
	movea.l	(-0x5678).w, a0
	movea.l	(+0x5678).w, a7
	movea.l	(-0x12345678).l, a0
	movea.l	(+0x12345678).l, a7
	movea.l	-0x12345678, a0
	movea.l	+0x12345678, a7
	movea.l	(-32768, pc), a0
	movea.l	(+32767, pc), a7
	movea.l	(-0x78, pc, a0.w), a0
	movea.l	(+0x78, pc, d7.l), a7

positive: movep instruction

	movep.w	d0, (-32768, a0)
	movep.w	d7, (+32767, a7)
	movep.w	(-32768, a0), d0
	movep.w	(+32767, a7), d7
	movep.l	d0, (-32768, a0)
	movep.l	d7, (+32767, a7)
	movep.l	(-32768, a0), d0
	movep.l	(+32767, a7), d7

positive: moveq instruction

	moveq	-0x78, d0
	moveq	+0x78, d7

positive: muls instruction

	muls	d0, d0
	muls	d7, d7
	muls	(a0), d0
	muls	(a7), d7
	muls	(a0)+, d0
	muls	(a7)+, d7
	muls	-(a0), d0
	muls	-(a7), d7
	muls	(-32768, a0), d0
	muls	(+32767, a7), d7
	muls	(-0x78, a0, a0.w), d0
	muls	(+0x78, a0, d7.l), d7
	muls	(-0x5678).w, d0
	muls	(+0x5678).w, d7
	muls	(-0x12345678).l, d0
	muls	(+0x12345678).l, d7
	muls	-0x5678, d0
	muls	+0x5678, d7
	muls	(-32768, pc), d0
	muls	(+32767, pc), d7
	muls	(-0x78, pc, a0.w), d0
	muls	(+0x78, pc, d7.l), d7

positive: mulu instruction

	mulu	d0, d0
	mulu	d7, d7
	mulu	(a0), d0
	mulu	(a7), d7
	mulu	(a0)+, d0
	mulu	(a7)+, d7
	mulu	-(a0), d0
	mulu	-(a7), d7
	mulu	(-32768, a0), d0
	mulu	(+32767, a7), d7
	mulu	(-0x78, a0, a0.w), d0
	mulu	(+0x78, a0, d7.l), d7
	mulu	(-0x5678).w, d0
	mulu	(+0x5678).w, d7
	mulu	(-0x12345678).l, d0
	mulu	(+0x12345678).l, d7
	mulu	-0x5678, d0
	mulu	+0x5678, d7
	mulu	(-32768, pc), d0
	mulu	(+32767, pc), d7
	mulu	(-0x78, pc, a0.w), d0
	mulu	(+0x78, pc, d7.l), d7

positive: nbcd instruction

	nbcd	d0
	nbcd	d7
	nbcd	(a0)
	nbcd	(a7)
	nbcd	(a0)+
	nbcd	(a7)+
	nbcd	-(a0)
	nbcd	-(a7)
	nbcd	(-32768, a0)
	nbcd	(+32767, a7)
	nbcd	(-0x78, a0, a0.w)
	nbcd	(+0x78, a0, d7.l)
	nbcd	(-0x5678).w
	nbcd	(+0x5678).w
	nbcd	(-0x12345678).l
	nbcd	(+0x12345678).l

positive: neg instruction

	neg.b	d0
	neg.b	d7
	neg.b	(a0)
	neg.b	(a7)
	neg.b	(a0)+
	neg.b	(a7)+
	neg.b	-(a0)
	neg.b	-(a7)
	neg.b	(-32768, a0)
	neg.b	(+32767, a7)
	neg.b	(-0x78, a0, a0.w)
	neg.b	(+0x78, a0, d7.l)
	neg.b	(-0x5678).w
	neg.b	(+0x5678).w
	neg.b	(-0x12345678).l
	neg.b	(+0x12345678).l
	neg.w	d0
	neg.w	d7
	neg.w	(a0)
	neg.w	(a7)
	neg.w	(a0)+
	neg.w	(a7)+
	neg.w	-(a0)
	neg.w	-(a7)
	neg.w	(-32768, a0)
	neg.w	(+32767, a7)
	neg.w	(-0x78, a0, a0.w)
	neg.w	(+0x78, a0, d7.l)
	neg.w	(-0x5678).w
	neg.w	(+0x5678).w
	neg.w	(-0x12345678).l
	neg.w	(+0x12345678).l
	neg.l	d0
	neg.l	d7
	neg.l	(a0)
	neg.l	(a7)
	neg.l	(a0)+
	neg.l	(a7)+
	neg.l	-(a0)
	neg.l	-(a7)
	neg.l	(-32768, a0)
	neg.l	(+32767, a7)
	neg.l	(-0x78, a0, a0.w)
	neg.l	(+0x78, a0, d7.l)
	neg.l	(-0x5678).w
	neg.l	(+0x5678).w
	neg.l	(-0x12345678).l
	neg.l	(+0x12345678).l

positive: negx instruction

	negx.b	d0
	negx.b	d7
	negx.b	(a0)
	negx.b	(a7)
	negx.b	(a0)+
	negx.b	(a7)+
	negx.b	-(a0)
	negx.b	-(a7)
	negx.b	(-32768, a0)
	negx.b	(+32767, a7)
	negx.b	(-0x78, a0, a0.w)
	negx.b	(+0x78, a0, d7.l)
	negx.b	(-0x5678).w
	negx.b	(+0x5678).w
	negx.b	(-0x12345678).l
	negx.b	(+0x12345678).l
	negx.w	d0
	negx.w	d7
	negx.w	(a0)
	negx.w	(a7)
	negx.w	(a0)+
	negx.w	(a7)+
	negx.w	-(a0)
	negx.w	-(a7)
	negx.w	(-32768, a0)
	negx.w	(+32767, a7)
	negx.w	(-0x78, a0, a0.w)
	negx.w	(+0x78, a0, d7.l)
	negx.w	(-0x5678).w
	negx.w	(+0x5678).w
	negx.w	(-0x12345678).l
	negx.w	(+0x12345678).l
	negx.l	d0
	negx.l	d7
	negx.l	(a0)
	negx.l	(a7)
	negx.l	(a0)+
	negx.l	(a7)+
	negx.l	-(a0)
	negx.l	-(a7)
	negx.l	(-32768, a0)
	negx.l	(+32767, a7)
	negx.l	(-0x78, a0, a0.w)
	negx.l	(+0x78, a0, d7.l)
	negx.l	(-0x5678).w
	negx.l	(+0x5678).w
	negx.l	(-0x12345678).l
	negx.l	(+0x12345678).l

positive: nop instruction

	nop

positive: not instruction

	not.b	d0
	not.b	d7
	not.b	(a0)
	not.b	(a7)
	not.b	(a0)+
	not.b	(a7)+
	not.b	-(a0)
	not.b	-(a7)
	not.b	(-32768, a0)
	not.b	(+32767, a7)
	not.b	(-0x78, a0, a0.w)
	not.b	(+0x78, a0, d7.l)
	not.b	(-0x5678).w
	not.b	(+0x5678).w
	not.b	(-0x12345678).l
	not.b	(+0x12345678).l
	not.w	d0
	not.w	d7
	not.w	(a0)
	not.w	(a7)
	not.w	(a0)+
	not.w	(a7)+
	not.w	-(a0)
	not.w	-(a7)
	not.w	(-32768, a0)
	not.w	(+32767, a7)
	not.w	(-0x78, a0, a0.w)
	not.w	(+0x78, a0, d7.l)
	not.w	(-0x5678).w
	not.w	(+0x5678).w
	not.w	(-0x12345678).l
	not.w	(+0x12345678).l
	not.l	d0
	not.l	d7
	not.l	(a0)
	not.l	(a7)
	not.l	(a0)+
	not.l	(a7)+
	not.l	-(a0)
	not.l	-(a7)
	not.l	(-32768, a0)
	not.l	(+32767, a7)
	not.l	(-0x78, a0, a0.w)
	not.l	(+0x78, a0, d7.l)
	not.l	(-0x5678).w
	not.l	(+0x5678).w
	not.l	(-0x12345678).l
	not.l	(+0x12345678).l

positive: or instruction

	or.b	d0, (a0)
	or.b	d7, (a7)
	or.b	d0, (a0)+
	or.b	d7, (a7)+
	or.b	d0, -(a0)
	or.b	d7, -(a7)
	or.b	d0, (-32768, a0)
	or.b	d7, (+32767, a7)
	or.b	d0, (-0x78, a0, a0.w)
	or.b	d7, (+0x78, a0, d7.l)
	or.b	d0, (-0x5678).w
	or.b	d7, (+0x5678).w
	or.b	d0, (-0x12345678).l
	or.b	d7, (+0x12345678).l
	or.b	d0, d0
	or.b	d7, d7
	or.b	(a0), d0
	or.b	(a7), d7
	or.b	(a0)+, d0
	or.b	(a7)+, d7
	or.b	-(a0), d0
	or.b	-(a7), d7
	or.b	(-32768, a0), d0
	or.b	(+32767, a7), d7
	or.b	(-0x78, a0, a0.w), d0
	or.b	(+0x78, a0, d7.l), d7
	or.b	(-0x5678).w, d0
	or.b	(+0x5678).w, d7
	or.b	(-0x12345678).l, d0
	or.b	(+0x12345678).l, d7
	or.b	-0x78, d0
	or.b	+0x78, d7
	or.b	(-32768, pc), d0
	or.b	(+32767, pc), d7
	or.b	(-0x78, pc, a0.w), d0
	or.b	(+0x78, pc, d7.l), d7
	or.w	d0, (a0)
	or.w	d7, (a7)
	or.w	d0, (a0)+
	or.w	d7, (a7)+
	or.w	d0, -(a0)
	or.w	d7, -(a7)
	or.w	d0, (-32768, a0)
	or.w	d7, (+32767, a7)
	or.w	d0, (-0x78, a0, a0.w)
	or.w	d7, (+0x78, a0, d7.l)
	or.w	d0, (-0x5678).w
	or.w	d7, (+0x5678).w
	or.w	d0, (-0x12345678).l
	or.w	d7, (+0x12345678).l
	or.w	d0, d0
	or.w	d7, d7
	or.w	(a0), d0
	or.w	(a7), d7
	or.w	(a0)+, d0
	or.w	(a7)+, d7
	or.w	-(a0), d0
	or.w	-(a7), d7
	or.w	(-32768, a0), d0
	or.w	(+32767, a7), d7
	or.w	(-0x78, a0, a0.w), d0
	or.w	(+0x78, a0, d7.l), d7
	or.w	(-0x5678).w, d0
	or.w	(+0x5678).w, d7
	or.w	(-0x12345678).l, d0
	or.w	(+0x12345678).l, d7
	or.w	-0x5678, d0
	or.w	+0x5678, d7
	or.w	(-32768, pc), d0
	or.w	(+32767, pc), d7
	or.w	(-0x78, pc, a0.w), d0
	or.w	(+0x78, pc, d7.l), d7
	or.l	d0, (a0)
	or.l	d7, (a7)
	or.l	d0, (a0)+
	or.l	d7, (a7)+
	or.l	d0, -(a0)
	or.l	d7, -(a7)
	or.l	d0, (-32768, a0)
	or.l	d7, (+32767, a7)
	or.l	d0, (-0x78, a0, a0.w)
	or.l	d7, (+0x78, a0, d7.l)
	or.l	d0, (-0x5678).w
	or.l	d7, (+0x5678).w
	or.l	d0, (-0x12345678).l
	or.l	d7, (+0x12345678).l
	or.l	d0, d0
	or.l	d7, d7
	or.l	(a0), d0
	or.l	(a7), d7
	or.l	(a0)+, d0
	or.l	(a7)+, d7
	or.l	-(a0), d0
	or.l	-(a7), d7
	or.l	(-32768, a0), d0
	or.l	(+32767, a7), d7
	or.l	(-0x78, a0, a0.w), d0
	or.l	(+0x78, a0, d7.l), d7
	or.l	(-0x5678).w, d0
	or.l	(+0x5678).w, d7
	or.l	(-0x12345678).l, d0
	or.l	(+0x12345678).l, d7
	or.l	-0x12345678, d0
	or.l	+0x12345678, d7
	or.l	(-32768, pc), d0
	or.l	(+32767, pc), d7
	or.l	(-0x78, pc, a0.w), d0
	or.l	(+0x78, pc, d7.l), d7

positive: ori instruction

	ori.b	-0x78, d0
	ori.b	+0x78, d7
	ori.b	-0x78, (a0)
	ori.b	+0x78, (a7)
	ori.b	-0x78, (a0)+
	ori.b	+0x78, (a7)+
	ori.b	-0x78, -(a0)
	ori.b	+0x78, -(a7)
	ori.b	-0x78, (-32768, a0)
	ori.b	+0x78, (+32767, a7)
	ori.b	-0x78, (-0x78, a0, a0.w)
	ori.b	+0x78, (+0x78, a0, d7.l)
	ori.b	-0x78, (-0x5678).w
	ori.b	+0x78, (+0x5678).w
	ori.b	-0x78, (-0x12345678).l
	ori.b	+0x78, (+0x12345678).l
	ori.w	-0x5678, d0
	ori.w	+0x5678, d7
	ori.w	-0x5678, (a0)
	ori.w	+0x5678, (a7)
	ori.w	-0x5678, (a0)+
	ori.w	+0x5678, (a7)+
	ori.w	-0x5678, -(a0)
	ori.w	+0x5678, -(a7)
	ori.w	-0x5678, (-32768, a0)
	ori.w	+0x5678, (+32767, a7)
	ori.w	-0x5678, (-0x78, a0, a0.w)
	ori.w	+0x5678, (+0x78, a0, d7.l)
	ori.w	-0x5678, (-0x5678).w
	ori.w	+0x5678, (+0x5678).w
	ori.w	-0x5678, (-0x12345678).l
	ori.w	+0x5678, (+0x12345678).l
	ori.l	-0x12345678, d0
	ori.l	+0x12345678, d7
	ori.l	-0x12345678, (a0)
	ori.l	+0x12345678, (a7)
	ori.l	-0x12345678, (a0)+
	ori.l	+0x12345678, (a7)+
	ori.l	-0x12345678, -(a0)
	ori.l	+0x12345678, -(a7)
	ori.l	-0x12345678, (-32768, a0)
	ori.l	+0x12345678, (+32767, a7)
	ori.l	-0x12345678, (-0x78, a0, a0.w)
	ori.l	+0x12345678, (+0x78, a0, d7.l)
	ori.l	-0x12345678, (-0x5678).w
	ori.l	+0x12345678, (+0x5678).w
	ori.l	-0x12345678, (-0x12345678).l
	ori.l	+0x12345678, (+0x12345678).l
	ori	-0x78, ccr
	ori	+0x78, ccr
	ori	-0x5678, sr
	ori	+0x5678, sr

positive: pea instruction

	pea	(a0)
	pea	(a7)
	pea	(-32768, a0)
	pea	(+32767, a7)
	pea	(-0x78, a0, a0.w)
	pea	(+0x78, a0, d7.l)
	pea	(-0x5678).w
	pea	(+0x5678).w
	pea	(-0x12345678).l
	pea	(+0x12345678).l
	pea	(-32768, pc)
	pea	(+32767, pc)
	pea	(-0x78, pc, a0.w)
	pea	(+0x78, pc, d7.l)

positive: rol instruction

	rol.b	d0, d0
	rol.b	d7, d7
	rol.b	1, d0
	rol.b	8, d7
	rol.w	d0, d0
	rol.w	d7, d7
	rol.w	1, d0
	rol.w	8, d7
	rol.w	(a0)
	rol.w	(a7)
	rol.w	(a0)+
	rol.w	(a7)+
	rol.w	-(a0)
	rol.w	-(a7)
	rol.w	(-32768, a0)
	rol.w	(+32767, a7)
	rol.w	(-0x78, a0, a0.w)
	rol.w	(+0x78, a0, d7.l)
	rol.w	(-0x5678).w
	rol.w	(+0x5678).w
	rol.w	(-0x12345678).l
	rol.w	(+0x12345678).l
	rol.l	d0, d0
	rol.l	d7, d7
	rol.l	1, d0
	rol.l	8, d7

positive: ror instruction

	ror.b	d0, d0
	ror.b	d7, d7
	ror.b	1, d0
	ror.b	8, d7
	ror.w	d0, d0
	ror.w	d7, d7
	ror.w	1, d0
	ror.w	8, d7
	ror.w	(a0)
	ror.w	(a7)
	ror.w	(a0)+
	ror.w	(a7)+
	ror.w	-(a0)
	ror.w	-(a7)
	ror.w	(-32768, a0)
	ror.w	(+32767, a7)
	ror.w	(-0x78, a0, a0.w)
	ror.w	(+0x78, a0, d7.l)
	ror.w	(-0x5678).w
	ror.w	(+0x5678).w
	ror.w	(-0x12345678).l
	ror.w	(+0x12345678).l
	ror.l	d0, d0
	ror.l	d7, d7
	ror.l	1, d0
	ror.l	8, d7

positive: roxl instruction

	roxl.b	d0, d0
	roxl.b	d7, d7
	roxl.b	1, d0
	roxl.b	8, d7
	roxl.w	d0, d0
	roxl.w	d7, d7
	roxl.w	1, d0
	roxl.w	8, d7
	roxl.w	(a0)
	roxl.w	(a7)
	roxl.w	(a0)+
	roxl.w	(a7)+
	roxl.w	-(a0)
	roxl.w	-(a7)
	roxl.w	(-32768, a0)
	roxl.w	(+32767, a7)
	roxl.w	(-0x78, a0, a0.w)
	roxl.w	(+0x78, a0, d7.l)
	roxl.w	(-0x5678).w
	roxl.w	(+0x5678).w
	roxl.w	(-0x12345678).l
	roxl.w	(+0x12345678).l
	roxl.l	d0, d0
	roxl.l	d7, d7
	roxl.l	1, d0
	roxl.l	8, d7

positive: roxr instruction

	roxr.b	d0, d0
	roxr.b	d7, d7
	roxr.b	1, d0
	roxr.b	8, d7
	roxr.w	d0, d0
	roxr.w	d7, d7
	roxr.w	1, d0
	roxr.w	8, d7
	roxr.w	(a0)
	roxr.w	(a7)
	roxr.w	(a0)+
	roxr.w	(a7)+
	roxr.w	-(a0)
	roxr.w	-(a7)
	roxr.w	(-32768, a0)
	roxr.w	(+32767, a7)
	roxr.w	(-0x78, a0, a0.w)
	roxr.w	(+0x78, a0, d7.l)
	roxr.w	(-0x5678).w
	roxr.w	(+0x5678).w
	roxr.w	(-0x12345678).l
	roxr.w	(+0x12345678).l
	roxr.l	d0, d0
	roxr.l	d7, d7
	roxr.l	1, d0
	roxr.l	8, d7

positive: rtr instruction

	rtr

positive: rts instruction

	rts

positive: sbcd instruction

	sbcd	d0, d0
	sbcd	d7, d7
	sbcd	-(a0), -(a0)
	sbcd	-(a7), -(a7)

positive: scc instruction

	scc	d0
	scc	d7
	scc	(a0)
	scc	(a7)
	scc	(a0)+
	scc	(a7)+
	scc	-(a0)
	scc	-(a7)
	scc	(-32768, a0)
	scc	(+32767, a7)
	scc	(-0x78, a0, a0.w)
	scc	(+0x78, a0, d7.l)
	scc	(-0x5678).w
	scc	(+0x5678).w
	scc	(-0x12345678).l
	scc	(+0x12345678).l

positive: scs instruction

	scs	d0
	scs	d7
	scs	(a0)
	scs	(a7)
	scs	(a0)+
	scs	(a7)+
	scs	-(a0)
	scs	-(a7)
	scs	(-32768, a0)
	scs	(+32767, a7)
	scs	(-0x78, a0, a0.w)
	scs	(+0x78, a0, d7.l)
	scs	(-0x5678).w
	scs	(+0x5678).w
	scs	(-0x12345678).l
	scs	(+0x12345678).l

positive: seq instruction

	seq	d0
	seq	d7
	seq	(a0)
	seq	(a7)
	seq	(a0)+
	seq	(a7)+
	seq	-(a0)
	seq	-(a7)
	seq	(-32768, a0)
	seq	(+32767, a7)
	seq	(-0x78, a0, a0.w)
	seq	(+0x78, a0, d7.l)
	seq	(-0x5678).w
	seq	(+0x5678).w
	seq	(-0x12345678).l
	seq	(+0x12345678).l

positive: sf instruction

	sf	d0
	sf	d7
	sf	(a0)
	sf	(a7)
	sf	(a0)+
	sf	(a7)+
	sf	-(a0)
	sf	-(a7)
	sf	(-32768, a0)
	sf	(+32767, a7)
	sf	(-0x78, a0, a0.w)
	sf	(+0x78, a0, d7.l)
	sf	(-0x5678).w
	sf	(+0x5678).w
	sf	(-0x12345678).l
	sf	(+0x12345678).l

positive: sge instruction

	sge	d0
	sge	d7
	sge	(a0)
	sge	(a7)
	sge	(a0)+
	sge	(a7)+
	sge	-(a0)
	sge	-(a7)
	sge	(-32768, a0)
	sge	(+32767, a7)
	sge	(-0x78, a0, a0.w)
	sge	(+0x78, a0, d7.l)
	sge	(-0x5678).w
	sge	(+0x5678).w
	sge	(-0x12345678).l
	sge	(+0x12345678).l

positive: sgt instruction

	sgt	d0
	sgt	d7
	sgt	(a0)
	sgt	(a7)
	sgt	(a0)+
	sgt	(a7)+
	sgt	-(a0)
	sgt	-(a7)
	sgt	(-32768, a0)
	sgt	(+32767, a7)
	sgt	(-0x78, a0, a0.w)
	sgt	(+0x78, a0, d7.l)
	sgt	(-0x5678).w
	sgt	(+0x5678).w
	sgt	(-0x12345678).l
	sgt	(+0x12345678).l

positive: shi instruction

	shi	d0
	shi	d7
	shi	(a0)
	shi	(a7)
	shi	(a0)+
	shi	(a7)+
	shi	-(a0)
	shi	-(a7)
	shi	(-32768, a0)
	shi	(+32767, a7)
	shi	(-0x78, a0, a0.w)
	shi	(+0x78, a0, d7.l)
	shi	(-0x5678).w
	shi	(+0x5678).w
	shi	(-0x12345678).l
	shi	(+0x12345678).l

positive: shs instruction

	shs	d0
	shs	d7
	shs	(a0)
	shs	(a7)
	shs	(a0)+
	shs	(a7)+
	shs	-(a0)
	shs	-(a7)
	shs	(-32768, a0)
	shs	(+32767, a7)
	shs	(-0x78, a0, a0.w)
	shs	(+0x78, a0, d7.l)
	shs	(-0x5678).w
	shs	(+0x5678).w
	shs	(-0x12345678).l
	shs	(+0x12345678).l

positive: sle instruction

	sle	d0
	sle	d7
	sle	(a0)
	sle	(a7)
	sle	(a0)+
	sle	(a7)+
	sle	-(a0)
	sle	-(a7)
	sle	(-32768, a0)
	sle	(+32767, a7)
	sle	(-0x78, a0, a0.w)
	sle	(+0x78, a0, d7.l)
	sle	(-0x5678).w
	sle	(+0x5678).w
	sle	(-0x12345678).l
	sle	(+0x12345678).l

positive: slo instruction

	slo	d0
	slo	d7
	slo	(a0)
	slo	(a7)
	slo	(a0)+
	slo	(a7)+
	slo	-(a0)
	slo	-(a7)
	slo	(-32768, a0)
	slo	(+32767, a7)
	slo	(-0x78, a0, a0.w)
	slo	(+0x78, a0, d7.l)
	slo	(-0x5678).w
	slo	(+0x5678).w
	slo	(-0x12345678).l
	slo	(+0x12345678).l

positive: sls instruction

	sls	d0
	sls	d7
	sls	(a0)
	sls	(a7)
	sls	(a0)+
	sls	(a7)+
	sls	-(a0)
	sls	-(a7)
	sls	(-32768, a0)
	sls	(+32767, a7)
	sls	(-0x78, a0, a0.w)
	sls	(+0x78, a0, d7.l)
	sls	(-0x5678).w
	sls	(+0x5678).w
	sls	(-0x12345678).l
	sls	(+0x12345678).l

positive: slt instruction

	slt	d0
	slt	d7
	slt	(a0)
	slt	(a7)
	slt	(a0)+
	slt	(a7)+
	slt	-(a0)
	slt	-(a7)
	slt	(-32768, a0)
	slt	(+32767, a7)
	slt	(-0x78, a0, a0.w)
	slt	(+0x78, a0, d7.l)
	slt	(-0x5678).w
	slt	(+0x5678).w
	slt	(-0x12345678).l
	slt	(+0x12345678).l

positive: smi instruction

	smi	d0
	smi	d7
	smi	(a0)
	smi	(a7)
	smi	(a0)+
	smi	(a7)+
	smi	-(a0)
	smi	-(a7)
	smi	(-32768, a0)
	smi	(+32767, a7)
	smi	(-0x78, a0, a0.w)
	smi	(+0x78, a0, d7.l)
	smi	(-0x5678).w
	smi	(+0x5678).w
	smi	(-0x12345678).l
	smi	(+0x12345678).l

positive: sne instruction

	sne	d0
	sne	d7
	sne	(a0)
	sne	(a7)
	sne	(a0)+
	sne	(a7)+
	sne	-(a0)
	sne	-(a7)
	sne	(-32768, a0)
	sne	(+32767, a7)
	sne	(-0x78, a0, a0.w)
	sne	(+0x78, a0, d7.l)
	sne	(-0x5678).w
	sne	(+0x5678).w
	sne	(-0x12345678).l
	sne	(+0x12345678).l

positive: spl instruction

	spl	d0
	spl	d7
	spl	(a0)
	spl	(a7)
	spl	(a0)+
	spl	(a7)+
	spl	-(a0)
	spl	-(a7)
	spl	(-32768, a0)
	spl	(+32767, a7)
	spl	(-0x78, a0, a0.w)
	spl	(+0x78, a0, d7.l)
	spl	(-0x5678).w
	spl	(+0x5678).w
	spl	(-0x12345678).l
	spl	(+0x12345678).l

positive: st instruction

	st	d0
	st	d7
	st	(a0)
	st	(a7)
	st	(a0)+
	st	(a7)+
	st	-(a0)
	st	-(a7)
	st	(-32768, a0)
	st	(+32767, a7)
	st	(-0x78, a0, a0.w)
	st	(+0x78, a0, d7.l)
	st	(-0x5678).w
	st	(+0x5678).w
	st	(-0x12345678).l
	st	(+0x12345678).l

positive: svc instruction

	svc	d0
	svc	d7
	svc	(a0)
	svc	(a7)
	svc	(a0)+
	svc	(a7)+
	svc	-(a0)
	svc	-(a7)
	svc	(-32768, a0)
	svc	(+32767, a7)
	svc	(-0x78, a0, a0.w)
	svc	(+0x78, a0, d7.l)
	svc	(-0x5678).w
	svc	(+0x5678).w
	svc	(-0x12345678).l
	svc	(+0x12345678).l

positive: svs instruction

	svs	d0
	svs	d7
	svs	(a0)
	svs	(a7)
	svs	(a0)+
	svs	(a7)+
	svs	-(a0)
	svs	-(a7)
	svs	(-32768, a0)
	svs	(+32767, a7)
	svs	(-0x78, a0, a0.w)
	svs	(+0x78, a0, d7.l)
	svs	(-0x5678).w
	svs	(+0x5678).w
	svs	(-0x12345678).l
	svs	(+0x12345678).l

positive: sub instruction

	sub.b	d0, (a0)
	sub.b	d7, (a7)
	sub.b	d0, (a0)+
	sub.b	d7, (a7)+
	sub.b	d0, -(a0)
	sub.b	d7, -(a7)
	sub.b	d0, (-32768, a0)
	sub.b	d7, (+32767, a7)
	sub.b	d0, (-0x78, a0, a0.w)
	sub.b	d7, (+0x78, a0, d7.l)
	sub.b	d0, (-0x5678).w
	sub.b	d7, (+0x5678).w
	sub.b	d0, (-0x12345678).l
	sub.b	d7, (+0x12345678).l
	sub.b	d0, d0
	sub.b	d7, d7
	sub.b	a0, d0
	sub.b	a7, d7
	sub.b	(a0), d0
	sub.b	(a7), d7
	sub.b	(a0)+, d0
	sub.b	(a7)+, d7
	sub.b	-(a0), d0
	sub.b	-(a7), d7
	sub.b	(-32768, a0), d0
	sub.b	(+32767, a7), d7
	sub.b	(-0x78, a0, a0.w), d0
	sub.b	(+0x78, a0, d7.l), d7
	sub.b	(-0x5678).w, d0
	sub.b	(+0x5678).w, d7
	sub.b	(-0x12345678).l, d0
	sub.b	(+0x12345678).l, d7
	sub.b	-0x78, d0
	sub.b	+0x78, d7
	sub.b	(-32768, pc), d0
	sub.b	(+32767, pc), d7
	sub.b	(-0x78, pc, a0.w), d0
	sub.b	(+0x78, pc, d7.l), d7
	sub.w	d0, (a0)
	sub.w	d7, (a7)
	sub.w	d0, (a0)+
	sub.w	d7, (a7)+
	sub.w	d0, -(a0)
	sub.w	d7, -(a7)
	sub.w	d0, (-32768, a0)
	sub.w	d7, (+32767, a7)
	sub.w	d0, (-0x78, a0, a0.w)
	sub.w	d7, (+0x78, a0, d7.l)
	sub.w	d0, (-0x5678).w
	sub.w	d7, (+0x5678).w
	sub.w	d0, (-0x12345678).l
	sub.w	d7, (+0x12345678).l
	sub.w	d0, d0
	sub.w	d7, d7
	sub.w	a0, d0
	sub.w	a7, d7
	sub.w	(a0), d0
	sub.w	(a7), d7
	sub.w	(a0)+, d0
	sub.w	(a7)+, d7
	sub.w	-(a0), d0
	sub.w	-(a7), d7
	sub.w	(-32768, a0), d0
	sub.w	(+32767, a7), d7
	sub.w	(-0x78, a0, a0.w), d0
	sub.w	(+0x78, a0, d7.l), d7
	sub.w	(-0x5678).w, d0
	sub.w	(+0x5678).w, d7
	sub.w	(-0x12345678).l, d0
	sub.w	(+0x12345678).l, d7
	sub.w	-0x5678, d0
	sub.w	+0x5678, d7
	sub.w	(-32768, pc), d0
	sub.w	(+32767, pc), d7
	sub.w	(-0x78, pc, a0.w), d0
	sub.w	(+0x78, pc, d7.l), d7
	sub.l	d0, (a0)
	sub.l	d7, (a7)
	sub.l	d0, (a0)+
	sub.l	d7, (a7)+
	sub.l	d0, -(a0)
	sub.l	d7, -(a7)
	sub.l	d0, (-32768, a0)
	sub.l	d7, (+32767, a7)
	sub.l	d0, (-0x78, a0, a0.w)
	sub.l	d7, (+0x78, a0, d7.l)
	sub.l	d0, (-0x5678).w
	sub.l	d7, (+0x5678).w
	sub.l	d0, (-0x12345678).l
	sub.l	d7, (+0x12345678).l
	sub.l	d0, d0
	sub.l	d7, d7
	sub.l	a0, d0
	sub.l	a7, d7
	sub.l	(a0), d0
	sub.l	(a7), d7
	sub.l	(a0)+, d0
	sub.l	(a7)+, d7
	sub.l	-(a0), d0
	sub.l	-(a7), d7
	sub.l	(-32768, a0), d0
	sub.l	(+32767, a7), d7
	sub.l	(-0x78, a0, a0.w), d0
	sub.l	(+0x78, a0, d7.l), d7
	sub.l	(-0x5678).w, d0
	sub.l	(+0x5678).w, d7
	sub.l	(-0x12345678).l, d0
	sub.l	(+0x12345678).l, d7
	sub.l	-0x12345678, d0
	sub.l	+0x12345678, d7
	sub.l	(-32768, pc), d0
	sub.l	(+32767, pc), d7
	sub.l	(-0x78, pc, a0.w), d0
	sub.l	(+0x78, pc, d7.l), d7

positive: suba instruction

	suba.w	a0, a0
	suba.w	a7, a7
	suba.w	(a0), a0
	suba.w	(a7), a7
	suba.w	(a0)+, a0
	suba.w	(a7)+, a7
	suba.w	-(a0), a0
	suba.w	-(a7), a7
	suba.w	(-32768, a0), a0
	suba.w	(+32767, a7), a7
	suba.w	(-0x78, a0, a0.w), a0
	suba.w	(+0x78, a0, d7.l), a7
	suba.w	(-0x5678).w, a0
	suba.w	(+0x5678).w, a7
	suba.w	(-0x12345678).l, a0
	suba.w	(+0x12345678).l, a7
	suba.w	-0x5678, a0
	suba.w	+0x5678, a7
	suba.w	(-32768, pc), a0
	suba.w	(+32767, pc), a7
	suba.w	(-0x78, pc, a0.w), a0
	suba.w	(+0x78, pc, d7.l), a7
	suba.l	d0, a0
	suba.l	d7, a7
	suba.l	a0, a0
	suba.l	a7, a7
	suba.l	(a0), a0
	suba.l	(a7), a7
	suba.l	(a0)+, a0
	suba.l	(a7)+, a7
	suba.l	-(a0), a0
	suba.l	-(a7), a7
	suba.l	(-32768, a0), a0
	suba.l	(+32767, a7), a7
	suba.l	(-0x78, a0, a0.w), a0
	suba.l	(+0x78, a0, d7.l), a7
	suba.l	(-0x5678).w, a0
	suba.l	(+0x5678).w, a7
	suba.l	(-0x12345678).l, a0
	suba.l	(+0x12345678).l, a7
	suba.l	-0x12345678, a0
	suba.l	+0x12345678, a7
	suba.l	(-32768, pc), a0
	suba.l	(+32767, pc), a7
	suba.l	(-0x78, pc, a0.w), a0
	suba.l	(+0x78, pc, d7.l), a7

positive: subi instruction

	subi.b	-0x78, d0
	subi.b	+0x78, d7
	subi.b	-0x78, (a0)
	subi.b	+0x78, (a7)
	subi.b	-0x78, (a0)+
	subi.b	+0x78, (a7)+
	subi.b	-0x78, -(a0)
	subi.b	+0x78, -(a7)
	subi.b	-0x78, (-32768, a0)
	subi.b	+0x78, (+32767, a7)
	subi.b	-0x78, (-0x78, a0, a0.w)
	subi.b	+0x78, (+0x78, a0, d7.l)
	subi.b	-0x78, (-0x5678).w
	subi.b	+0x78, (+0x5678).w
	subi.b	-0x78, (-0x12345678).l
	subi.b	+0x78, (+0x12345678).l
	subi.w	-0x5678, d0
	subi.w	+0x5678, d7
	subi.w	-0x5678, (a0)
	subi.w	+0x5678, (a7)
	subi.w	-0x5678, (a0)+
	subi.w	+0x5678, (a7)+
	subi.w	-0x5678, -(a0)
	subi.w	+0x5678, -(a7)
	subi.w	-0x5678, (-32768, a0)
	subi.w	+0x5678, (+32767, a7)
	subi.w	-0x5678, (-0x78, a0, a0.w)
	subi.w	+0x5678, (+0x78, a0, d7.l)
	subi.w	-0x5678, (-0x5678).w
	subi.w	+0x5678, (+0x5678).w
	subi.w	-0x5678, (-0x12345678).l
	subi.w	+0x5678, (+0x12345678).l
	subi.l	-0x12345678, d0
	subi.l	+0x12345678, d7
	subi.l	-0x12345678, (a0)
	subi.l	+0x12345678, (a7)
	subi.l	-0x12345678, (a0)+
	subi.l	+0x12345678, (a7)+
	subi.l	-0x12345678, -(a0)
	subi.l	+0x12345678, -(a7)
	subi.l	-0x12345678, (-32768, a0)
	subi.l	+0x12345678, (+32767, a7)
	subi.l	-0x12345678, (-0x78, a0, a0.w)
	subi.l	+0x12345678, (+0x78, a0, d7.l)
	subi.l	-0x12345678, (-0x5678).w
	subi.l	+0x12345678, (+0x5678).w
	subi.l	-0x12345678, (-0x12345678).l
	subi.l	+0x12345678, (+0x12345678).l

positive: subq instruction

	subq.b	1, d0
	subq.b	8, d7
	subq.b	1, a0
	subq.b	8, a7
	subq.b	1, (a0)
	subq.b	8, (a7)
	subq.b	1, (a0)+
	subq.b	8, (a7)+
	subq.b	1, -(a0)
	subq.b	8, -(a7)
	subq.b	1, (-32768, a0)
	subq.b	8, (+32767, a7)
	subq.b	1, (-0x78, a0, a0.w)
	subq.b	8, (+0x78, a0, d7.l)
	subq.b	1, (-0x5678).w
	subq.b	8, (+0x5678).w
	subq.b	1, (-0x12345678).l
	subq.b	8, (+0x12345678).l
	subq.w	1, d0
	subq.w	8, d7
	subq.w	1, a0
	subq.w	8, a7
	subq.w	1, (a0)
	subq.w	8, (a7)
	subq.w	1, (a0)+
	subq.w	8, (a7)+
	subq.w	1, -(a0)
	subq.w	8, -(a7)
	subq.w	1, (-32768, a0)
	subq.w	8, (+32767, a7)
	subq.w	1, (-0x78, a0, a0.w)
	subq.w	8, (+0x78, a0, d7.l)
	subq.w	1, (-0x5678).w
	subq.w	8, (+0x5678).w
	subq.w	1, (-0x12345678).l
	subq.w	8, (+0x12345678).l
	subq.l	1, d0
	subq.l	8, d7
	subq.l	1, a0
	subq.l	8, a7
	subq.l	1, (a0)
	subq.l	8, (a7)
	subq.l	1, (a0)+
	subq.l	8, (a7)+
	subq.l	1, -(a0)
	subq.l	8, -(a7)
	subq.l	1, (-32768, a0)
	subq.l	8, (+32767, a7)
	subq.l	1, (-0x78, a0, a0.w)
	subq.l	8, (+0x78, a0, d7.l)
	subq.l	1, (-0x5678).w
	subq.l	8, (+0x5678).w
	subq.l	1, (-0x12345678).l
	subq.l	8, (+0x12345678).l

positive: subx instruction

	subx.b	d0, d0
	subx.b	d7, d7
	subx.b	-(a0), -(a0)
	subx.b	-(a7), -(a7)
	subx.w	d0, d0
	subx.w	d7, d7
	subx.w	-(a0), -(a0)
	subx.w	-(a7), -(a7)
	subx.l	d0, d0
	subx.l	d7, d7
	subx.l	-(a0), -(a0)
	subx.l	-(a7), -(a7)

positive: swap instruction

	swap	d0
	swap	d7

positive: tas instruction

	tas	d0
	tas	d7
	tas	(a0)
	tas	(a7)
	tas	(a0)+
	tas	(a7)+
	tas	-(a0)
	tas	-(a7)
	tas	(-32768, a0)
	tas	(+32767, a7)
	tas	(-0x78, a0, a0.w)
	tas	(+0x78, a0, d7.l)
	tas	(-0x5678).w
	tas	(+0x5678).w
	tas	(-0x12345678).l
	tas	(+0x12345678).l

positive: trap instruction

	trap	0
	trap	15

positive: trapv instruction

	trapv

positive: tst instruction

	tst.b	d0
	tst.b	d7
	tst.b	a0
	tst.b	a7
	tst.b	(a0)
	tst.b	(a7)
	tst.b	(a0)+
	tst.b	(a7)+
	tst.b	-(a0)
	tst.b	-(a7)
	tst.b	(-32768, a0)
	tst.b	(+32767, a7)
	tst.b	(-0x78, a0, a0.w)
	tst.b	(+0x78, a0, d7.l)
	tst.b	(-0x5678).w
	tst.b	(+0x5678).w
	tst.b	(-0x12345678).l
	tst.b	(+0x12345678).l
	tst.b	-0x78
	tst.b	+0x78
	tst.b	(-32768, pc)
	tst.b	(+32767, pc)
	tst.b	(-0x78, pc, a0.w)
	tst.b	(+0x78, pc, d7.l)
	tst.w	d0
	tst.w	d7
	tst.w	a0
	tst.w	a7
	tst.w	(a0)
	tst.w	(a7)
	tst.w	(a0)+
	tst.w	(a7)+
	tst.w	-(a0)
	tst.w	-(a7)
	tst.w	(-32768, a0)
	tst.w	(+32767, a7)
	tst.w	(-0x78, a0, a0.w)
	tst.w	(+0x78, a0, d7.l)
	tst.w	(-0x5678).w
	tst.w	(+0x5678).w
	tst.w	(-0x12345678).l
	tst.w	(+0x12345678).l
	tst.w	-0x5678
	tst.w	+0x5678
	tst.w	(-32768, pc)
	tst.w	(+32767, pc)
	tst.w	(-0x78, pc, a0.w)
	tst.w	(+0x78, pc, d7.l)
	tst.l	d0
	tst.l	d7
	tst.l	a0
	tst.l	a7
	tst.l	(a0)
	tst.l	(a7)
	tst.l	(a0)+
	tst.l	(a7)+
	tst.l	-(a0)
	tst.l	-(a7)
	tst.l	(-32768, a0)
	tst.l	(+32767, a7)
	tst.l	(-0x78, a0, a0.w)
	tst.l	(+0x78, a0, d7.l)
	tst.l	(-0x5678).w
	tst.l	(+0x5678).w
	tst.l	(-0x12345678).l
	tst.l	(+0x12345678).l
	tst.l	-0x12345678
	tst.l	+0x12345678
	tst.l	(-32768, pc)
	tst.l	(+32767, pc)
	tst.l	(-0x78, pc, a0.w)
	tst.l	(+0x78, pc, d7.l)

positive: unlk instruction

	unlk	a0
	unlk	a7

# supervisor instructions

positive: reset instruction

	reset

positive: rte instruction

	rte

positive: stop instruction

	stop	-0x5678
	stop	+0x5678

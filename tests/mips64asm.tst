# MIPS assembler test and validation suite
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

# MIPS assembler

# unsupported instructions in 32-bit mode

negative: dadd instruction in 32-bit mode

	.bitmode	32
	dadd	r0, r0, r0

positive: dadd instruction in 64-bit mode

	.bitmode	64
	dadd	r0, r0, r0

negative: daddi instruction in 32-bit mode

	.bitmode	32
	daddi	r0, r0, 0

positive: daddi instruction in 64-bit mode

	.bitmode	64
	daddi	r0, r0, 0

negative: daddiu instruction in 32-bit mode

	.bitmode	32
	daddiu	r0, r0, 0

positive: daddiu instruction in 64-bit mode

	.bitmode	64
	daddiu	r0, r0, 0

negative: daddu instruction in 32-bit mode

	.bitmode	32
	daddu	r0, r0, r0

positive: daddu instruction in 64-bit mode

	.bitmode	64
	daddu	r0, r0, r0

negative: dclo instruction in 32-bit mode

	.bitmode	32
	dclo	r0, r0

positive: dclo instruction in 64-bit mode

	.bitmode	64
	dclo	r0, r0

negative: dclz instruction in 32-bit mode

	.bitmode	32
	dclz	r0, r0

positive: dclz instruction in 64-bit mode

	.bitmode	64
	dclz	r0, r0

negative: ddiv instruction in 32-bit mode

	.bitmode	32
	ddiv	r0, r0

positive: ddiv instruction in 64-bit mode

	.bitmode	64
	ddiv	r0, r0

negative: ddivu instruction in 32-bit mode

	.bitmode	32
	ddivu	r0, r0

positive: ddivu instruction in 64-bit mode

	.bitmode	64
	ddivu	r0, r0

negative: dext instruction in 32-bit mode

	.bitmode	32
	dext	r0, r0, 0, 1

positive: dext instruction in 64-bit mode

	.bitmode	64
	dext	r0, r0, 0, 1

negative: dextm instruction in 32-bit mode

	.bitmode	32
	dextm	r0, r0, 0, 33

positive: dextm instruction in 64-bit mode

	.bitmode	64
	dextm	r0, r0, 0, 33

negative: dextu instruction in 32-bit mode

	.bitmode	32
	dextu	r0, r0, 32, 1

positive: dextu instruction in 64-bit mode

	.bitmode	64
	dextu	r0, r0, 32, 1

negative: dins instruction in 32-bit mode

	.bitmode	32
	dins	r0, r0, 0, 1

positive: dins instruction in 64-bit mode

	.bitmode	64
	dins	r0, r0, 0, 1

negative: dinsm instruction in 32-bit mode

	.bitmode	32
	dinsm	r0, r0, 0, 33

positive: dinsm instruction in 64-bit mode

	.bitmode	64
	dinsm	r0, r0, 0, 33

negative: dinsu instruction in 32-bit mode

	.bitmode	32
	dinsu	r0, r0, 32, 1

positive: dinsu instruction in 64-bit mode

	.bitmode	64
	dinsu	r0, r0, 32, 1

negative: dmfc0 instruction in 32-bit mode

	.bitmode	32
	dmfc0	r0, r0, 0

positive: dmfc0 instruction in 64-bit mode

	.bitmode	64
	dmfc0	r0, r0, 0

negative: dmfc1 instruction in 32-bit mode

	.bitmode	32
	dmfc1	r0, f0

positive: dmfc1 instruction in 64-bit mode

	.bitmode	64
	dmfc1	r0, f0

negative: dmfc2 instruction in 32-bit mode

	.bitmode	32
	dmfc2	r0, r0, 0

positive: dmfc2 instruction in 64-bit mode

	.bitmode	64
	dmfc2	r0, r0, 0

negative: dmtc0 instruction in 32-bit mode

	.bitmode	32
	dmtc0	r0, r0, 0

positive: dmtc0 instruction in 64-bit mode

	.bitmode	64
	dmtc0	r0, r0, 0

negative: dmtc1 instruction in 32-bit mode

	.bitmode	32
	dmtc1	r0, f0

positive: dmtc1 instruction in 64-bit mode

	.bitmode	64
	dmtc1	r0, f0

negative: dmtc2 instruction in 32-bit mode

	.bitmode	32
	dmtc2	r0, r0, 0

positive: dmtc2 instruction in 64-bit mode

	.bitmode	64
	dmtc2	r0, r0, 0

negative: dmult instruction in 32-bit mode

	.bitmode	32
	dmult	r0, r0

positive: dmult instruction in 64-bit mode

	.bitmode	64
	dmult	r0, r0

negative: dmultu instruction in 32-bit mode

	.bitmode	32
	dmultu	r0, r0

positive: dmultu instruction in 64-bit mode

	.bitmode	64
	dmultu	r0, r0

negative: drotr instruction in 32-bit mode

	.bitmode	32
	drotr	r0, r0, 0

positive: drotr instruction in 64-bit mode

	.bitmode	64
	drotr	r0, r0, 0

negative: drotr32 instruction in 32-bit mode

	.bitmode	32
	drotr32	r0, r0, 32

positive: drotr32 instruction in 64-bit mode

	.bitmode	64
	drotr32	r0, r0, 32

negative: drotrv instruction in 32-bit mode

	.bitmode	32
	drotrv	r0, r0, r0

positive: drotrv instruction in 64-bit mode

	.bitmode	64
	drotrv	r0, r0, r0

negative: dsbh instruction in 32-bit mode

	.bitmode	32
	dsbh	r0, r0

positive: dsbh instruction in 64-bit mode

	.bitmode	64
	dsbh	r0, r0

negative: dshd instruction in 32-bit mode

	.bitmode	32
	dshd	r0, r0

positive: dshd instruction in 64-bit mode

	.bitmode	64
	dshd	r0, r0

negative: dsll instruction in 32-bit mode

	.bitmode	32
	dsll	r0, r0, 0

positive: dsll instruction in 64-bit mode

	.bitmode	64
	dsll	r0, r0, 0

negative: dsll32 instruction in 32-bit mode

	.bitmode	32
	dsll32	r0, r0, 32

positive: dsll32 instruction in 64-bit mode

	.bitmode	64
	dsll32	r0, r0, 32

negative: dsllv instruction in 32-bit mode

	.bitmode	32
	dsllv	r0, r0, r0

positive: dsllv instruction in 64-bit mode

	.bitmode	64
	dsllv	r0, r0, r0

negative: dsra instruction in 32-bit mode

	.bitmode	32
	dsra	r0, r0, 0

positive: dsra instruction in 64-bit mode

	.bitmode	64
	dsra	r0, r0, 0

negative: dsra32 instruction in 32-bit mode

	.bitmode	32
	dsra32	r0, r0, 32

positive: dsra32 instruction in 64-bit mode

	.bitmode	64
	dsra32	r0, r0, 32

negative: dsrav instruction in 32-bit mode

	.bitmode	32
	dsrav	r0, r0, r0

positive: dsrav instruction in 64-bit mode

	.bitmode	64
	dsrav	r0, r0, r0

negative: dsrl instruction in 32-bit mode

	.bitmode	32
	dsrl	r0, r0, 0

positive: dsrl instruction in 64-bit mode

	.bitmode	64
	dsrl	r0, r0, 0

negative: dsrl32 instruction in 32-bit mode

	.bitmode	32
	dsrl32	r0, r0, 32

positive: dsrl32 instruction in 64-bit mode

	.bitmode	64
	dsrl32	r0, r0, 32

negative: dsrlv instruction in 32-bit mode

	.bitmode	32
	dsrlv	r0, r0, r0

positive: dsrlv instruction in 64-bit mode

	.bitmode	64
	dsrlv	r0, r0, r0

negative: dsub instruction in 32-bit mode

	.bitmode	32
	dsub	r0, r0, r0

positive: dsub instruction in 64-bit mode

	.bitmode	64
	dsub	r0, r0, r0

negative: dsubu instruction in 32-bit mode

	.bitmode	32
	dsubu	r0, r0, r0

positive: dsubu instruction in 64-bit mode

	.bitmode	64
	dsubu	r0, r0, r0

negative: jalx instruction in 32-bit mode

	.bitmode	32
	jalx	0

positive: jalx instruction in 64-bit mode

	.bitmode	64
	jalx	0

negative: ld instruction in 32-bit mode

	.bitmode	32
	ld	r0, 0 (r0)

positive: ld instruction in 64-bit mode

	.bitmode	64
	ld	r0, 0 (r0)

negative: ldl instruction in 32-bit mode

	.bitmode	32
	ldl	r0, 0 (r0)

positive: ldl instruction in 64-bit mode

	.bitmode	64
	ldl	r0, 0 (r0)

negative: ldr instruction in 32-bit mode

	.bitmode	32
	ldr	r0, 0 (r0)

positive: ldr instruction in 64-bit mode

	.bitmode	64
	ldr	r0, 0 (r0)

negative: lld instruction in 32-bit mode

	.bitmode	32
	lld	r0, 0 (r0)

positive: lld instruction in 64-bit mode

	.bitmode	64
	lld	r0, 0 (r0)

negative: lwu instruction in 32-bit mode

	.bitmode	32
	lwu	r0, 0 (r0)

positive: lwu instruction in 64-bit mode

	.bitmode	64
	lwu	r0, 0 (r0)

negative: scd instruction in 32-bit mode

	.bitmode	32
	scd	r0, 0 (r0)

positive: scd instruction in 64-bit mode

	.bitmode	64
	scd	r0, 0 (r0)

negative: sd instruction in 32-bit mode

	.bitmode	32
	sd	r0, 0 (r0)

positive: sd instruction in 64-bit mode

	.bitmode	64
	sd	r0, 0 (r0)

negative: sdl instruction in 32-bit mode

	.bitmode	32
	sdl	r0, 0 (r0)

positive: sdl instruction in 64-bit mode

	.bitmode	64
	sdl	r0, 0 (r0)

negative: sdr instruction in 32-bit mode

	.bitmode	32
	sdr	r0, 0 (r0)

positive: sdr instruction in 64-bit mode

	.bitmode	64
	sdr	r0, 0 (r0)

# instructions

positive: abs.s instruction

	abs.s	f0, f0
	abs.s	f31, f31

positive: abs.d instruction

	abs.d	f0, f0
	abs.d	f31, f31

positive: abs.ps instruction

	abs.ps	f0, f0
	abs.ps	f31, f31

positive: add instruction

	add	r0, r0, r0
	add	r31, r31, r31

positive: add.s instruction

	add.s	f0, f0, f0
	add.s	f31, f31, f31

positive: add.d instruction

	add.d	f0, f0, f0
	add.d	f31, f31, f31

positive: add.ps instruction

	add.ps	f0, f0, f0
	add.ps	f31, f31, f31

positive: addi instruction

	addi	r0, r0, -32768
	addi	r31, r31, +32767

positive: addiu instruction

	addiu	r0, r0, -32768
	addiu	r31, r31, +32767

positive: addu instruction

	addu	r0, r0, r0
	addu	r31, r31, r31

positive: alnv.ps instruction

	alnv.ps	f0, f0, f0, r0
	alnv.ps	f31, f31, f31, r31

positive: and instruction

	and	r0, r0, r0
	and	r31, r31, r31

positive: andi instruction

	andi	r0, r0, 0
	andi	r31, r31, 65535

positive: b instruction

	b	-131072
	b	+131068

positive: bal instruction

	bal	-131072
	bal	+131068

positive: bc1f instruction

	bc1f	0, -131072
	bc1f	7, +131068

positive: bc1fl instruction

	bc1fl	0, -131072
	bc1fl	7, +131068

positive: bc1t instruction

	bc1t	0, -131072
	bc1t	7, +131068

positive: bc1tl instruction

	bc1tl	0, -131072
	bc1tl	7, +131068

positive: bc2f instruction

	bc2f	0, -131072
	bc2f	7, +131068

positive: bc2fl instruction

	bc2fl	0, -131072
	bc2fl	7, +131068

positive: bc2t instruction

	bc2t	0, -131072
	bc2t	7, +131068

positive: bc2tl instruction

	bc2tl	0, -131072
	bc2tl	7, +131068

positive: beq instruction

	beq	r0, r0, -131072
	beq	r31, r31, +131068

positive: beql instruction

	beql	r0, r0, -131072
	beql	r31, r31, +131068

positive: bgez instruction

	bgez	r0, -131072
	bgez	r31, +131068

positive: bgezal instruction

	bgezal	r0, -131072
	bgezal	r31, +131068

positive: bgezall instruction

	bgezall	r0, -131072
	bgezall	r31, +131068

positive: bgezl instruction

	bgezl	r0, -131072
	bgezl	r31, +131068

positive: bgtz instruction

	bgtz	r0, -131072
	bgtz	r31, +131068

positive: bgtzl instruction

	bgtzl	r0, -131072
	bgtzl	r31, +131068

positive: blez instruction

	blez	r0, -131072
	blez	r31, +131068

positive: blezl instruction

	blezl	r0, -131072
	blezl	r31, +131068

positive: bltz instruction

	bltz	r0, -131072
	bltz	r31, +131068

positive: bltzal instruction

	bltzal	r0, -131072
	bltzal	r31, +131068

positive: bltzall instruction

	bltzall	r0, -131072
	bltzall	r31, +131068

positive: bltzl instruction

	bltzl	r0, -131072
	bltzl	r31, +131068

positive: bne instruction

	bne	r0, r0, -131072
	bne	r31, r31, +131068

positive: bnel instruction

	bnel	r0, r0, -131072
	bnel	r31, r31, +131068

positive: break instruction

	break

positive: c.f.s instruction

	c.f.s	0, f0, f0
	c.f.s	7, f31, f31

positive: c.f.d instruction

	c.f.d	0, f0, f0
	c.f.d	7, f31, f31

positive: c.f.ps instruction

	c.f.ps	0, f0, f0
	c.f.ps	7, f31, f31

positive: c.un.s instruction

	c.un.s	0, f0, f0
	c.un.s	7, f31, f31

positive: c.un.d instruction

	c.un.d	0, f0, f0
	c.un.d	7, f31, f31

positive: c.un.ps instruction

	c.un.ps	0, f0, f0
	c.un.ps	7, f31, f31

positive: c.eq.s instruction

	c.eq.s	0, f0, f0
	c.eq.s	7, f31, f31

positive: c.eq.d instruction

	c.eq.d	0, f0, f0
	c.eq.d	7, f31, f31

positive: c.eq.ps instruction

	c.eq.ps	0, f0, f0
	c.eq.ps	7, f31, f31

positive: c.ueq.s instruction

	c.ueq.s	0, f0, f0
	c.ueq.s	7, f31, f31

positive: c.ueq.d instruction

	c.ueq.d	0, f0, f0
	c.ueq.d	7, f31, f31

positive: c.ueq.ps instruction

	c.ueq.ps	0, f0, f0
	c.ueq.ps	7, f31, f31

positive: c.olt.s instruction

	c.olt.s	0, f0, f0
	c.olt.s	7, f31, f31

positive: c.olt.d instruction

	c.olt.d	0, f0, f0
	c.olt.d	7, f31, f31

positive: c.olt.ps instruction

	c.olt.ps	0, f0, f0
	c.olt.ps	7, f31, f31

positive: c.ult.s instruction

	c.ult.s	0, f0, f0
	c.ult.s	7, f31, f31

positive: c.ult.d instruction

	c.ult.d	0, f0, f0
	c.ult.d	7, f31, f31

positive: c.ult.ps instruction

	c.ult.ps	0, f0, f0
	c.ult.ps	7, f31, f31

positive: c.ole.s instruction

	c.ole.s	0, f0, f0
	c.ole.s	7, f31, f31

positive: c.ole.d instruction

	c.ole.d	0, f0, f0
	c.ole.d	7, f31, f31

positive: c.ole.ps instruction

	c.ole.ps	0, f0, f0
	c.ole.ps	7, f31, f31

positive: c.ule.s instruction

	c.ule.s	0, f0, f0
	c.ule.s	7, f31, f31

positive: c.ule.d instruction

	c.ule.d	0, f0, f0
	c.ule.d	7, f31, f31

positive: c.ule.ps instruction

	c.ule.ps	0, f0, f0
	c.ule.ps	7, f31, f31

positive: cache instruction

	cache	0, -32768 (r0)
	cache	31, +32767 (r31)

positive: ceil.l.s instruction

	ceil.l.s	f0, f0
	ceil.l.s	f31, f31

positive: ceil.l.d instruction

	ceil.l.d	f0, f0
	ceil.l.d	f31, f31

positive: ceil.w.s instruction

	ceil.w.s	f0, f0
	ceil.w.s	f31, f31

positive: ceil.w.d instruction

	ceil.w.d	f0, f0
	ceil.w.d	f31, f31

positive: cfc1 instruction

	cfc1	r0, f0
	cfc1	r31, f31

positive: cfc2 instruction

	cfc2	r0, 0
	cfc2	r31, 65535

positive: clo instruction

	clo	r0, r0
	clo	r31, r31

positive: clz instruction

	clz	r0, r0
	clz	r31, r31

positive: ctc1 instruction

	ctc1	r0, f0
	ctc1	r31, f31

positive: ctc2 instruction

	ctc2	r0, 0
	ctc2	r31, 65535

positive: cvt.d.s instruction

	cvt.d.s	f0, f0
	cvt.d.s	f31, f31

positive: cvt.d.w instruction

	cvt.d.w	f0, f0
	cvt.d.w	f31, f31

positive: cvt.d.l instruction

	cvt.d.l	f0, f0
	cvt.d.l	f31, f31

positive: cvt.l.s instruction

	cvt.l.s	f0, f0
	cvt.l.s	f31, f31

positive: cvt.l.d instruction

	cvt.l.d	f0, f0
	cvt.l.d	f31, f31

positive: cvt.ps.s instruction

	cvt.ps.s	f0, f0, f0
	cvt.ps.s	f31, f31, f31

positive: cvt.s.d instruction

	cvt.s.d	f0, f0
	cvt.s.d	f31, f31

positive: cvt.s.w instruction

	cvt.s.w	f0, f0
	cvt.s.w	f31, f31

positive: cvt.s.l instruction

	cvt.s.l	f0, f0
	cvt.s.l	f31, f31

positive: cvt.s.pl instruction

	cvt.s.pl	f0, f0
	cvt.s.pl	f31, f31

positive: cvt.s.pu instruction

	cvt.s.pu	f0, f0
	cvt.s.pu	f31, f31

positive: cvt.w.s instruction

	cvt.w.s	f0, f0
	cvt.w.s	f31, f31

positive: cvt.w.d instruction

	cvt.w.d	f0, f0
	cvt.w.d	f31, f31

positive: dadd instruction

	dadd	r0, r0, r0
	dadd	r31, r31, r31

positive: daddi instruction

	daddi	r0, r0, -32768
	daddi	r31, r31, +32767

positive: daddiu instruction

	daddiu	r0, r0, -32768
	daddiu	r31, r31, +32767

positive: daddu instruction

	daddu	r0, r0, r0
	daddu	r31, r31, r31

positive: dclo instruction

	dclo	r0, r0
	dclo	r31, r31

positive: dclz instruction

	dclz	r0, r0
	dclz	r31, r31

positive: ddiv instruction

	ddiv	r0, r0
	ddiv	r31, r31

positive: ddivu instruction

	ddivu	r0, r0
	ddivu	r31, r31

positive: deret instruction

	deret

positive: dext instruction

	dext	r0, r0, 0, 1
	dext	r31, r31, 31, 32

positive: dextm instruction

	dextm	r0, r0, 0, 33
	dextm	r31, r31, 31, 64

positive: dextu instruction

	dextu	r0, r0, 32, 1
	dextu	r31, r31, 63, 32

positive: di instruction

	di	r0
	di	r31

positive: dins instruction

	dins	r0, r0, 0, 1
	dins	r31, r31, 31, 32

positive: dinsm instruction

	dinsm	r0, r0, 0, 33
	dinsm	r31, r31, 31, 64

positive: dinsu instruction

	dinsu	r0, r0, 32, 1
	dinsu	r31, r31, 63, 32

positive: div instruction

	div	r0, r0
	div	r31, r31

positive: div.s instruction

	div.s	f0, f0, f0
	div.s	f31, f31, f31

positive: div.d instruction

	div.d	f0, f0, f0
	div.d	f31, f31, f31

positive: divu instruction

	divu	r0, r0
	divu	r31, r31

positive: dmfc0 instruction

	dmfc0	r0, r0, 0
	dmfc0	r31, r31, 7

positive: dmfc1 instruction

	dmfc1	r0, f0
	dmfc1	r31, f31

positive: dmfc2 instruction

	dmfc2	r0, r0, 0
	dmfc2	r31, r31, 7

positive: dmtc0 instruction

	dmtc0	r0, r0, 0
	dmtc0	r31, r31, 7

positive: dmtc1 instruction

	dmtc1	r0, f0
	dmtc1	r31, f31

positive: dmtc2 instruction

	dmtc2	r0, r0, 0
	dmtc2	r31, r31, 7

positive: dmult instruction

	dmult	r0, r0
	dmult	r31, r31

positive: dmultu instruction

	dmultu	r0, r0
	dmultu	r31, r31

positive: drotr instruction

	drotr	r0, r0, 0
	drotr	r31, r31, 31

positive: drotr32 instruction

	drotr32	r0, r0, 32
	drotr32	r31, r31, 63

positive: drotrv instruction

	drotrv	r0, r0, r0
	drotrv	r31, r31, r31

positive: dsbh instruction

	dsbh	r0, r0
	dsbh	r31, r31

positive: dshd instruction

	dshd	r0, r0
	dshd	r31, r31

positive: dsll instruction

	dsll	r0, r0, 0
	dsll	r31, r31, 31

positive: dsll32 instruction

	dsll32	r0, r0, 32
	dsll32	r31, r31, 63

positive: dsllv instruction

	dsllv	r0, r0, r0
	dsllv	r31, r31, r31

positive: dsra instruction

	dsra	r0, r0, 0
	dsra	r31, r31, 31

positive: dsra32 instruction

	dsra32	r0, r0, 32
	dsra32	r31, r31, 63

positive: dsrav instruction

	dsrav	r0, r0, r0
	dsrav	r31, r31, r31

positive: dsrl instruction

	dsrl	r0, r0, 0
	dsrl	r31, r31, 31

positive: dsrl32 instruction

	dsrl32	r0, r0, 32
	dsrl32	r31, r31, 63

positive: dsrlv instruction

	dsrlv	r0, r0, r0
	dsrlv	r31, r31, r31

positive: dsub instruction

	dsub	r0, r0, r0
	dsub	r31, r31, r31

positive: dsubu instruction

	dsubu	r0, r0, r0
	dsubu	r31, r31, r31

positive: ehb instruction

	ehb

positive: ei instruction

	ei	r0
	ei	r31

positive: eret instruction

	eret

positive: ext instruction

	ext	r0, r0, 0, 1
	ext	r31, r31, 31, 32

positive: floor.l.s instruction

	floor.l.s	f0, f0
	floor.l.s	f31, f31

positive: floor.l.d instruction

	floor.l.d	f0, f0
	floor.l.d	f31, f31

positive: floor.w.s instruction

	floor.w.s	f0, f0
	floor.w.s	f31, f31

positive: floor.w.d instruction

	floor.w.d	f0, f0
	floor.w.d	f31, f31

positive: ins instruction

	ins	r0, r0, 0, 1
	ins	r31, r31, 31, 32

positive: j instruction

	j	0
	j	268435452

positive: jal instruction

	jal	0
	jal	268435452

positive: jalr instruction

	jalr	r0, r0
	jalr	r31, r31

positive: jalr.hb instruction

	jalr.hb	r0, r0
	jalr.hb	r31, r31

positive: jalx instruction

	jalx	0
	jalx	268435452

positive: jr instruction

	jr	r0
	jr	r31

positive: jr.hb instruction

	jr.hb	r0
	jr.hb	r31

positive: lb instruction

	lb	r0, -32768 (r0)
	lb	r31, +32767 (r31)

positive: lbu instruction

	lbu	r0, -32768 (r0)
	lbu	r31, +32767 (r31)

positive: ld instruction

	ld	r0, -32768 (r0)
	ld	r31, +32767 (r31)

positive: ldc1 instruction

	ldc1	f0, -32768 (r0)
	ldc1	f31, +32767 (r31)

positive: ldc2 instruction

	ldc2	r0, -32768 (r0)
	ldc2	r31, +32767 (r31)

positive: ldl instruction

	ldl	r0, -32768 (r0)
	ldl	r31, +32767 (r31)

positive: ldr instruction

	ldr	r0, -32768 (r0)
	ldr	r31, +32767 (r31)

positive: ldxc1 instruction

	ldxc1	f0, r0 (r0)
	ldxc1	f31, r31 (r31)

positive: lh instruction

	lh	r0, -32768 (r0)
	lh	r31, +32767 (r31)

positive: lhu instruction

	lhu	r0, -32768 (r0)
	lhu	r31, +32767 (r31)

positive: li instruction

	li	r0, -32768
	li	r31, +32767

positive: ll instruction

	ll	r0, -32768 (r0)
	ll	r31, +32767 (r31)

positive: lld instruction

	lld	r0, -32768 (r0)
	lld	r31, +32767 (r31)

positive: lui instruction

	lui	r0, -32768
	lui	r31, +32767

positive: luxc1 instruction

	luxc1	f0, r0 (r0)
	luxc1	f31, r31 (r31)

positive: lw instruction

	lw	r0, -32768 (r0)
	lw	r31, +32767 (r31)

positive: lwc1 instruction

	lwc1	f0, -32768 (r0)
	lwc1	f31, +32767 (r31)

positive: lwc2 instruction

	lwc2	r0, -32768 (r0)
	lwc2	r31, +32767 (r31)

positive: lwl instruction

	lwl	r0, -32768 (r0)
	lwl	r31, +32767 (r31)

positive: lwr instruction

	lwr	r0, -32768 (r0)
	lwr	r31, +32767 (r31)

positive: lwu instruction

	lwu	r0, -32768 (r0)
	lwu	r31, +32767 (r31)

positive: lwxc1 instruction

	lwxc1	f0, r0 (r0)
	lwxc1	f31, r31 (r31)

positive: madd instruction

	madd	r0, r0
	madd	r31, r31

positive: madd.s instruction

	madd.s	f0, f0, f0, f0
	madd.s	f31, f31, f31, f31

positive: madd.d instruction

	madd.d	f0, f0, f0, f0
	madd.d	f31, f31, f31, f31

positive: madd.ps instruction

	madd.ps	f0, f0, f0, f0
	madd.ps	f31, f31, f31, f31

positive: maddu instruction

	maddu	r0, r0
	maddu	r31, r31

positive: mfc0 instruction

	mfc0	r0, r0, 0
	mfc0	r31, r31, 7

positive: mfc1 instruction

	mfc1	r0, f0
	mfc1	r31, f31

positive: mfc2 instruction

	mfc2	r0, r0, 0
	mfc2	r31, r31, 7

positive: mfhc1 instruction

	mfhc1	r0, f0
	mfhc1	r31, f31

positive: mfhc2 instruction

	mfhc2	r0, r0, 0
	mfhc2	r31, r31, 7

positive: mfhi instruction

	mfhi	r0
	mfhi	r31

positive: mflo instruction

	mflo	r0
	mflo	r31

positive: mov.s instruction

	mov.s	f0, f0
	mov.s	f31, f31

positive: mov.d instruction

	mov.d	f0, f0
	mov.d	f31, f31

positive: mov.ps instruction

	mov.ps	f0, f0
	mov.ps	f31, f31

positive: movf instruction

	movf	r0, r0, 0
	movf	r31, r31, 7

positive: movf.s instruction

	movf.s	f0, f0, 0
	movf.s	f31, f31, 7

positive: movf.d instruction

	movf.d	f0, f0, 0
	movf.d	f31, f31, 7

positive: movf.ps instruction

	movf.ps	f0, f0, 0
	movf.ps	f31, f31, 7

positive: movn instruction

	movn	r0, r0, r0
	movn	r31, r31, r31

positive: movn.s instruction

	movn.s	f0, f0, r0
	movn.s	f31, f31, r31

positive: movn.d instruction

	movn.d	f0, f0, r0
	movn.d	f31, f31, r31

positive: movn.ps instruction

	movn.ps	f0, f0, r0
	movn.ps	f31, f31, r31

positive: movt instruction

	movt	r0, r0, 0
	movt	r31, r31, 7

positive: movt.s instruction

	movt.s	f0, f0, 0
	movt.s	f31, f31, 7

positive: movt.d instruction

	movt.d	f0, f0, 0
	movt.d	f31, f31, 7

positive: movt.ps instruction

	movt.ps	f0, f0, 0
	movt.ps	f31, f31, 7

positive: movz instruction

	movz	r0, r0, r0
	movz	r31, r31, r31

positive: movz.s instruction

	movz.s	f0, f0, r0
	movz.s	f31, f31, r31

positive: movz.d instruction

	movz.d	f0, f0, r0
	movz.d	f31, f31, r31

positive: movz.ps instruction

	movz.ps	f0, f0, r0
	movz.ps	f31, f31, r31

positive: msub instruction

	msub	r0, r0
	msub	r31, r31

positive: msub.s instruction

	msub.s	f0, f0, f0, f0
	msub.s	f31, f31, f31, f31

positive: msub.d instruction

	msub.d	f0, f0, f0, f0
	msub.d	f31, f31, f31, f31

positive: msub.ps instruction

	msub.ps	f0, f0, f0, f0
	msub.ps	f31, f31, f31, f31

positive: msubu instruction

	msubu	r0, r0
	msubu	r31, r31

positive: mtc0 instruction

	mtc0	r0, r0, 0
	mtc0	r31, r31, 7

positive: mtc1 instruction

	mtc1	r0, f0
	mtc1	r31, f31

positive: mtc2 instruction

	mtc2	r0, r0, 0
	mtc2	r31, r31, 7

positive: mthc1 instruction

	mthc1	r0, f0
	mthc1	r31, f31

positive: mthc2 instruction

	mthc2	r0, r0, 0
	mthc2	r31, r31, 7

positive: mthi instruction

	mthi	r0
	mthi	r31

positive: mtlo instruction

	mtlo	r0
	mtlo	r31

positive: mul instruction

	mul	r0, r0, r0
	mul	r31, r31, r31

positive: mul.s instruction

	mul.s	f0, f0, f0
	mul.s	f31, f31, f31

positive: mul.d instruction

	mul.d	f0, f0, f0
	mul.d	f31, f31, f31

positive: mul.ps instruction

	mul.ps	f0, f0, f0
	mul.ps	f31, f31, f31

positive: mult instruction

	mult	r0, r0
	mult	r31, r31

positive: multu instruction

	multu	r0, r0
	multu	r31, r31

positive: neg.s instruction

	neg.s	f0, f0
	neg.s	f31, f31

positive: neg.d instruction

	neg.d	f0, f0
	neg.d	f31, f31

positive: neg.ps instruction

	neg.ps	f0, f0
	neg.ps	f31, f31

positive: nmadd.s instruction

	nmadd.s	f0, f0, f0, f0
	nmadd.s	f31, f31, f31, f31

positive: nmadd.d instruction

	nmadd.d	f0, f0, f0, f0
	nmadd.d	f31, f31, f31, f31

positive: nmadd.ps instruction

	nmadd.ps	f0, f0, f0, f0
	nmadd.ps	f31, f31, f31, f31

positive: nmsub.s instruction

	nmsub.s	f0, f0, f0, f0
	nmsub.s	f31, f31, f31, f31

positive: nmsub.d instruction

	nmsub.d	f0, f0, f0, f0
	nmsub.d	f31, f31, f31, f31

positive: nmsub.ps instruction

	nmsub.ps	f0, f0, f0, f0
	nmsub.ps	f31, f31, f31, f31

positive: nop instruction

	nop

positive: nor instruction

	nor	r0, r0, r0
	nor	r31, r31, r31

positive: or instruction

	or	r0, r0, r0
	or	r31, r31, r31

positive: ori instruction

	ori	r0, r0, 0
	ori	r31, r31, 65535

positive: pause instruction

	pause

positive: pll.ps instruction

	pll.ps	f0, f0, f0
	pll.ps	f31, f31, f31

positive: plu.ps instruction

	plu.ps	f0, f0, f0
	plu.ps	f31, f31, f31

positive: pref instruction

	pref	0, -32768 (r0)
	pref	31, +32767 (r31)

positive: prefx instruction

	prefx	0, r0 (r0)
	prefx	31, r31 (r31)

positive: pul.ps instruction

	pul.ps	f0, f0, f0
	pul.ps	f31, f31, f31

positive: puu.ps instruction

	puu.ps	f0, f0, f0
	puu.ps	f31, f31, f31

positive: rdhdwr instruction

	rdhdwr	r0, r0
	rdhdwr	r31, r31

positive: rdpgpr instruction

	rdpgpr	r0, r0
	rdpgpr	r31, r31

positive: recip.s instruction

	recip.s	f0, f0
	recip.s	f31, f31

positive: recip.d instruction

	recip.d	f0, f0
	recip.d	f31, f31

positive: rotr instruction

	rotr	r0, r0, 0
	rotr	r31, r31, 31

positive: rotrv instruction

	rotrv	r0, r0, r0
	rotrv	r31, r31, r31

positive: round.l.s instruction

	round.l.s	f0, f0
	round.l.s	f31, f31

positive: round.l.d instruction

	round.l.d	f0, f0
	round.l.d	f31, f31

positive: round.w.s instruction

	round.w.s	f0, f0
	round.w.s	f31, f31

positive: round.w.d instruction

	round.w.d	f0, f0
	round.w.d	f31, f31

positive: rsqrt.s instruction

	rsqrt.s	f0, f0
	rsqrt.s	f31, f31

positive: rsqrt.d instruction

	rsqrt.d	f0, f0
	rsqrt.d	f31, f31

positive: sb instruction

	sb	r0, -32768 (r0)
	sb	r31, +32767 (r31)

positive: sc instruction

	sc	r0, -32768 (r0)
	sc	r31, +32767 (r31)

positive: scd instruction

	scd	r0, -32768 (r0)
	scd	r31, +32767 (r31)

positive: sd instruction

	sd	r0, -32768 (r0)
	sd	r31, +32767 (r31)

positive: sdbbp instruction

	sdbbp

positive: sdc1 instruction

	sdc1	f0, -32768 (r0)
	sdc1	f31, +32767 (r31)

positive: sdc2 instruction

	sdc2	r0, -32768 (r0)
	sdc2	r31, +32767 (r31)

positive: sdl instruction

	sdl	r0, -32768 (r0)
	sdl	r31, +32767 (r31)

positive: sdr instruction

	sdr	r0, -32768 (r0)
	sdr	r31, +32767 (r31)

positive: sdxc1 instruction

	sdxc1	f0, r0 (r0)
	sdxc1	f31, r31 (r31)

positive: seb instruction

	seb	r0, r0
	seb	r31, r31

positive: seh instruction

	seh	r0, r0
	seh	r31, r31

positive: sh instruction

	sh	r0, -32768 (r0)
	sh	r31, +32767 (r31)

positive: sll instruction

	sll	r0, r0, 0
	sll	r31, r31, 31

positive: sllv instruction

	sllv	r0, r0, r0
	sllv	r31, r31, r31

positive: slt instruction

	slt	r0, r0, r0
	slt	r31, r31, r31

positive: slti instruction

	slti	r0, r0, -32768
	slti	r31, r31, +32767

positive: sltiu instruction

	sltiu	r0, r0, -32768
	sltiu	r31, r31, +32767

positive: sltu instruction

	sltu	r0, r0, r0
	sltu	r31, r31, r31

positive: sqrt.s instruction

	sqrt.s	f0, f0
	sqrt.s	f31, f31

positive: sqrt.d instruction

	sqrt.d	f0, f0
	sqrt.d	f31, f31

positive: sra instruction

	sra	r0, r0, 0
	sra	r31, r31, 31

positive: srav instruction

	srav	r0, r0, r0
	srav	r31, r31, r31

positive: srl instruction

	srl	r0, r0, 0
	srl	r31, r31, 31

positive: srlv instruction

	srlv	r0, r0, r0
	srlv	r31, r31, r31

positive: ssnop instruction

	ssnop

positive: sub instruction

	sub	r0, r0, r0
	sub	r31, r31, r31

positive: sub.s instruction

	sub.s	f0, f0, f0
	sub.s	f31, f31, f31

positive: sub.d instruction

	sub.d	f0, f0, f0
	sub.d	f31, f31, f31

positive: sub.ps instruction

	sub.ps	f0, f0, f0
	sub.ps	f31, f31, f31

positive: subu instruction

	subu	r0, r0, r0
	subu	r31, r31, r31

positive: suxc1 instruction

	suxc1	f0, r0 (r0)
	suxc1	f31, r31 (r31)

positive: sw instruction

	sw	r0, -32768 (r0)
	sw	r31, +32767 (r31)

positive: swc1 instruction

	swc1	f0, -32768 (r0)
	swc1	f31, +32767 (r31)

positive: swc2 instruction

	swc2	r0, -32768 (r0)
	swc2	r31, +32767 (r31)

positive: swl instruction

	swl	r0, -32768 (r0)
	swl	r31, +32767 (r31)

positive: swr instruction

	swr	r0, -32768 (r0)
	swr	r31, +32767 (r31)

positive: swxc1 instruction

	swxc1	f0, r0 (r0)
	swxc1	f31, r31 (r31)

positive: sync instruction

	sync	0
	sync	31

positive: syscall instruction

	syscall

positive: teq instruction

	teq	r0, r0
	teq	r31, r31

positive: teqi instruction

	teqi	r0, -32768
	teqi	r31, +32767

positive: tge instruction

	tge	r0, r0
	tge	r31, r31

positive: tgei instruction

	tgei	r0, -32768
	tgei	r31, +32767

positive: tgeiu instruction

	tgeiu	r0, -32768
	tgeiu	r31, +32767

positive: tgeu instruction

	tgeu	r0, r0
	tgeu	r31, r31

positive: tlbp instruction

	tlbp

positive: tlbr instruction

	tlbr

positive: tlbwi instruction

	tlbwi

positive: tlbwr instruction

	tlbwr

positive: tlt instruction

	tlt	r0, r0
	tlt	r31, r31

positive: tlti instruction

	tlti	r0, -32768
	tlti	r31, +32767

positive: tltiu instruction

	tltiu	r0, -32768
	tltiu	r31, +32767

positive: tltu instruction

	tltu	r0, r0
	tltu	r31, r31

positive: tne instruction

	tne	r0, r0
	tne	r31, r31

positive: tnei instruction

	tnei	r0, -32768
	tnei	r31, +32767

positive: trunc.l.s instruction

	trunc.l.s	f0, f0
	trunc.l.s	f31, f31

positive: trunc.l.d instruction

	trunc.l.d	f0, f0
	trunc.l.d	f31, f31

positive: trunc.w.s instruction

	trunc.w.s	f0, f0
	trunc.w.s	f31, f31

positive: trunc.w.d instruction

	trunc.w.d	f0, f0
	trunc.w.d	f31, f31

positive: wait instruction

	wait

positive: wrpgpr instruction

	wrpgpr	r0, r0
	wrpgpr	r31, r31

positive: wsbh instruction

	wsbh	r0, r0
	wsbh	r31, r31

positive: xor instruction

	xor	r0, r0, r0
	xor	r31, r31, r31

positive: xori instruction

	xori	r0, r0, 0
	xori	r0, r0, 65535

# WebAssembly assembler test and validation suite
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

# WebAssembly assembler

positive: block instruction

	block
	block	0
	block	4294967295
	block	i32
	block	i64
	block	f32
	block	f64
	block	v128
	block	funcref
	block	externref

positive: br instruction

	br	0
	br	4294967295

positive: br_if instruction

	br_if	0
	br_if	4294967295

positive: br_table instruction

	br_table

positive: call instruction

	call	0
	call	4294967295
	call

positive: call_indirect instruction

	call_indirect	0 0
	call_indirect	4294967295 4294967295
	call_indirect

positive: data.drop instruction

	data.drop	0
	data.drop	4294967295
	data.drop

positive: drop instruction

	drop

positive: elem.drop instruction

	elem.drop	0
	elem.drop	4294967295
	elem.drop

positive: else instruction

	else

positive: end instruction

	end

positive: f32.abs instruction

	f32.abs

positive: f32.add instruction

	f32.add

positive: f32.ceil instruction

	f32.ceil

positive: f32.const instruction

	f32.const	-3.4028234e38
	f32.const	+3.4028234e38

positive: f32.convert_i32_s instruction

	f32.convert_i32_s

positive: f32.convert_i32_u instruction

	f32.convert_i32_u

positive: f32.convert_i64_s instruction

	f32.convert_i64_s

positive: f32.convert_i64_u instruction

	f32.convert_i64_u

positive: f32.copysign instruction

	f32.copysign

positive: f32.demote_f64 instruction

	f32.demote_f64

positive: f32.div instruction

	f32.div

positive: f32.eq instruction

	f32.eq

positive: f32.floor instruction

	f32.floor

positive: f32.ge instruction

	f32.ge

positive: f32.gt instruction

	f32.gt

positive: f32.le instruction

	f32.le

positive: f32.load instruction

	f32.load	1 0
	f32.load	32 4294967295

positive: f32.lt instruction

	f32.lt

positive: f32.max instruction

	f32.max

positive: f32.min instruction

	f32.min

positive: f32.mul instruction

	f32.mul

positive: f32.ne instruction

	f32.ne

positive: f32.nearest instruction

	f32.nearest

positive: f32.neg instruction

	f32.neg

positive: f32.reinterpret_i32 instruction

	f32.reinterpret_i32

positive: f32.sqrt instruction

	f32.sqrt

positive: f32.store instruction

	f32.store	1 0
	f32.store	32 4294967295

positive: f32.sub instruction

	f32.sub

positive: f32.trunc instruction

	f32.trunc

positive: f32x4.abs instruction

	f32x4.abs

positive: f32x4.add instruction

	f32x4.add

positive: f32x4.ceil instruction

	f32x4.ceil

positive: f32x4.convert_i32x4_s instruction

	f32x4.convert_i32x4_s

positive: f32x4.convert_i32x4_u instruction

	f32x4.convert_i32x4_u

positive: f32x4.demote_f64x2_zero instruction

	f32x4.demote_f64x2_zero

positive: f32x4.div instruction

	f32x4.div

positive: f32x4.eq instruction

	f32x4.eq

positive: f32x4.extract_lane instruction

	f32x4.extract_lane	0
	f32x4.extract_lane	255

positive: f32x4.floor instruction

	f32x4.floor

positive: f32x4.ge instruction

	f32x4.ge

positive: f32x4.gt instruction

	f32x4.gt

positive: f32x4.le instruction

	f32x4.le

positive: f32x4.lt instruction

	f32x4.lt

positive: f32x4.max instruction

	f32x4.max

positive: f32x4.min instruction

	f32x4.min

positive: f32x4.mul instruction

	f32x4.mul

positive: f32x4.ne instruction

	f32x4.ne

positive: f32x4.nearest instruction

	f32x4.nearest

positive: f32x4.neg instruction

	f32x4.neg

positive: f32x4.pmax instruction

	f32x4.pmax

positive: f32x4.pmin instruction

	f32x4.pmin

positive: f32x4.replace_lane instruction

	f32x4.replace_lane	0
	f32x4.replace_lane	255

positive: f32x4.splat instruction

	f32x4.splat

positive: f32x4.sqrt instruction

	f32x4.sqrt

positive: f32x4.sub instruction

	f32x4.sub

positive: f32x4.trunc instruction

	f32x4.trunc

positive: f64.abs instruction

	f64.abs

positive: f64.add instruction

	f64.add

positive: f64.ceil instruction

	f64.ceil

positive: f64.const instruction

	f64.const	-1.7976931348623157e308
	f64.const	+1.7976931348623157e308

positive: f64.convert_i32_s instruction

	f64.convert_i32_s

positive: f64.convert_i32_u instruction

	f64.convert_i32_u

positive: f64.convert_i64_s instruction

	f64.convert_i64_s

positive: f64.convert_i64_u instruction

	f64.convert_i64_u

positive: f64.copysign instruction

	f64.copysign

positive: f64.div instruction

	f64.div

positive: f64.eq instruction

	f64.eq

positive: f64.floor instruction

	f64.floor

positive: f64.ge instruction

	f64.ge

positive: f64.gt instruction

	f64.gt

positive: f64.le instruction

	f64.le

positive: f64.load instruction

	f64.load	1 0
	f64.load	32 4294967295

positive: f64.lt instruction

	f64.lt

positive: f64.max instruction

	f64.max

positive: f64.min instruction

	f64.min

positive: f64.mul instruction

	f64.mul

positive: f64.ne instruction

	f64.ne

positive: f64.nearest instruction

	f64.nearest

positive: f64.neg instruction

	f64.neg

positive: f64.promote_f32 instruction

	f64.promote_f32

positive: f64.reinterpret_i64 instruction

	f64.reinterpret_i64

positive: f64.sqrt instruction

	f64.sqrt

positive: f64.store instruction

	f64.store	1 0
	f64.store	32 4294967295

positive: f64.sub instruction

	f64.sub

positive: f64.trunc instruction

	f64.trunc

positive: f64x2.abs instruction

	f64x2.abs

positive: f64x2.add instruction

	f64x2.add

positive: f64x2.ceil instruction

	f64x2.ceil

positive: f64x2.convert_low_i32x4_s instruction

	f64x2.convert_low_i32x4_s

positive: f64x2.convert_low_i32x4_u instruction

	f64x2.convert_low_i32x4_u

positive: f64x2.div instruction

	f64x2.div

positive: f64x2.eq instruction

	f64x2.eq

positive: f64x2.extract_lane instruction

	f64x2.extract_lane	0
	f64x2.extract_lane	255

positive: f64x2.floor instruction

	f64x2.floor

positive: f64x2.ge instruction

	f64x2.ge

positive: f64x2.gt instruction

	f64x2.gt

positive: f64x2.le instruction

	f64x2.le

positive: f64x2.lt instruction

	f64x2.lt

positive: f64x2.max instruction

	f64x2.max

positive: f64x2.min instruction

	f64x2.min

positive: f64x2.mul instruction

	f64x2.mul

positive: f64x2.ne instruction

	f64x2.ne

positive: f64x2.nearest instruction

	f64x2.nearest

positive: f64x2.neg instruction

	f64x2.neg

positive: f64x2.pmax instruction

	f64x2.pmax

positive: f64x2.pmin instruction

	f64x2.pmin

positive: f64x2.promote_low_f32x4 instruction

	f64x2.promote_low_f32x4

positive: f64x2.replace_lane instruction

	f64x2.replace_lane	0
	f64x2.replace_lane	255

positive: f64x2.splat instruction

	f64x2.splat

positive: f64x2.sqrt instruction

	f64x2.sqrt

positive: f64x2.sub instruction

	f64x2.sub

positive: f64x2.trunc instruction

	f64x2.trunc

positive: global.get instruction

	global.get	0
	global.get	4294967295
	global.get

positive: global.set instruction

	global.set	0
	global.set	4294967295
	global.set

positive: i16x8.abs instruction

	i16x8.abs

positive: i16x8.add instruction

	i16x8.add

positive: i16x8.add_sat_s instruction

	i16x8.add_sat_s

positive: i16x8.add_sat_u instruction

	i16x8.add_sat_u

positive: i16x8.all_true instruction

	i16x8.all_true

positive: i16x8.avgr_u instruction

	i16x8.avgr_u

positive: i16x8.bitmask instruction

	i16x8.bitmask

positive: i16x8.eq instruction

	i16x8.eq

positive: i16x8.extadd_pairwise_i8x16_s instruction

	i16x8.extadd_pairwise_i8x16_s

positive: i16x8.extadd_pairwise_i8x16_u instruction

	i16x8.extadd_pairwise_i8x16_u

positive: i16x8.extend_high_i8x16_s instruction

	i16x8.extend_high_i8x16_s

positive: i16x8.extend_high_i8x16_u instruction

	i16x8.extend_high_i8x16_u

positive: i16x8.extend_low_i8x16_s instruction

	i16x8.extend_low_i8x16_s

positive: i16x8.extend_low_i8x16_u instruction

	i16x8.extend_low_i8x16_u

positive: i16x8.extmul_high_i8x16_s instruction

	i16x8.extmul_high_i8x16_s

positive: i16x8.extmul_high_i8x16_u instruction

	i16x8.extmul_high_i8x16_u

positive: i16x8.extmul_low_i8x16_s instruction

	i16x8.extmul_low_i8x16_s

positive: i16x8.extmul_low_i8x16_u instruction

	i16x8.extmul_low_i8x16_u

positive: i16x8.extract_lane_s instruction

	i16x8.extract_lane_s	0
	i16x8.extract_lane_s	255

positive: i16x8.extract_lane_u instruction

	i16x8.extract_lane_u	0
	i16x8.extract_lane_u	255

positive: i16x8.ge_s instruction

	i16x8.ge_s

positive: i16x8.ge_u instruction

	i16x8.ge_u

positive: i16x8.gt_s instruction

	i16x8.gt_s

positive: i16x8.gt_u instruction

	i16x8.gt_u

positive: i16x8.le_s instruction

	i16x8.le_s

positive: i16x8.le_u instruction

	i16x8.le_u

positive: i16x8.lt_s instruction

	i16x8.lt_s

positive: i16x8.lt_u instruction

	i16x8.lt_u

positive: i16x8.max_s instruction

	i16x8.max_s

positive: i16x8.max_u instruction

	i16x8.max_u

positive: i16x8.min_s instruction

	i16x8.min_s

positive: i16x8.min_u instruction

	i16x8.min_u

positive: i16x8.mul instruction

	i16x8.mul

positive: i16x8.narrow_i32x4_s instruction

	i16x8.narrow_i32x4_s

positive: i16x8.narrow_i32x4_u instruction

	i16x8.narrow_i32x4_u

positive: i16x8.ne instruction

	i16x8.ne

positive: i16x8.neg instruction

	i16x8.neg

positive: i16x8.q15mulr_sat_s instruction

	i16x8.q15mulr_sat_s

positive: i16x8.replace_lane instruction

	i16x8.replace_lane	0
	i16x8.replace_lane	255

positive: i16x8.shl instruction

	i16x8.shl

positive: i16x8.shr_s instruction

	i16x8.shr_s

positive: i16x8.shr_u instruction

	i16x8.shr_u

positive: i16x8.splat instruction

	i16x8.splat

positive: i16x8.sub instruction

	i16x8.sub

positive: i16x8.sub_sat_s instruction

	i16x8.sub_sat_s

positive: i16x8.sub_sat_u instruction

	i16x8.sub_sat_u

positive: i32 instruction

	i32	0
	i32	4294967295

positive: i32.add instruction

	i32.add

positive: i32.and instruction

	i32.and

positive: i32.clz instruction

	i32.clz

positive: i32.const instruction

	i32.const	-2147483648
	i32.const	+2147483647
	i32.const

positive: i32.ctz instruction

	i32.ctz

positive: i32.div_s instruction

	i32.div_s

positive: i32.div_u instruction

	i32.div_u

positive: i32.eq instruction

	i32.eq

positive: i32.eqz instruction

	i32.eqz

positive: i32.extend16_s instruction

	i32.extend16_s

positive: i32.extend8_s instruction

	i32.extend8_s

positive: i32.ge_s instruction

	i32.ge_s

positive: i32.ge_u instruction

	i32.ge_u

positive: i32.gt_s instruction

	i32.gt_s

positive: i32.gt_u instruction

	i32.gt_u

positive: i32.le_s instruction

	i32.le_s

positive: i32.le_u instruction

	i32.le_u

positive: i32.load instruction

	i32.load	1 0
	i32.load	32 4294967295

positive: i32.load16_s instruction

	i32.load16_s	1 0
	i32.load16_s	32 4294967295

positive: i32.load16_u instruction

	i32.load16_u	1 0
	i32.load16_u	32 4294967295

positive: i32.load8_s instruction

	i32.load8_s	1 0
	i32.load8_s	32 4294967295

positive: i32.load8_u instruction

	i32.load8_u	1 0
	i32.load8_u	32 4294967295

positive: i32.lt_s instruction

	i32.lt_s

positive: i32.lt_u instruction

	i32.lt_u

positive: i32.mul instruction

	i32.mul

positive: i32.ne instruction

	i32.ne

positive: i32.or instruction

	i32.or

positive: i32.popcnt instruction

	i32.popcnt

positive: i32.reinterpret_f32 instruction

	i32.reinterpret_f32

positive: i32.rem_s instruction

	i32.rem_s

positive: i32.rem_u instruction

	i32.rem_u

positive: i32.rotl instruction

	i32.rotl

positive: i32.rotr instruction

	i32.rotr

positive: i32.shl instruction

	i32.shl

positive: i32.shr_s instruction

	i32.shr_s

positive: i32.shr_u instruction

	i32.shr_u

positive: i32.store instruction

	i32.store	1 0
	i32.store	32 4294967295

positive: i32.store16 instruction

	i32.store16	1 0
	i32.store16	32 4294967295

positive: i32.store8 instruction

	i32.store8	1 0
	i32.store8	32 4294967295

positive: i32.sub instruction

	i32.sub

positive: i32.trunc_f32_s instruction

	i32.trunc_f32_s

positive: i32.trunc_f32_u instruction

	i32.trunc_f32_u

positive: i32.trunc_f64_s instruction

	i32.trunc_f64_s

positive: i32.trunc_f64_u instruction

	i32.trunc_f64_u

positive: i32.trunc_sat_f32_s instruction

	i32.trunc_sat_f32_s

positive: i32.trunc_sat_f32_u instruction

	i32.trunc_sat_f32_u

positive: i32.trunc_sat_f64_s instruction

	i32.trunc_sat_f64_s

positive: i32.trunc_sat_f64_u instruction

	i32.trunc_sat_f64_u

positive: i32.wrap_i64 instruction

	i32.wrap_i64

positive: i32.xor instruction

	i32.xor

positive: i32x4.abs instruction

	i32x4.abs

positive: i32x4.add instruction

	i32x4.add

positive: i32x4.all_true instruction

	i32x4.all_true

positive: i32x4.bitmask instruction

	i32x4.bitmask

positive: i32x4.dot_i16x8_s instruction

	i32x4.dot_i16x8_s

positive: i32x4.eq instruction

	i32x4.eq

positive: i32x4.extadd_pairwise_i16x8_s instruction

	i32x4.extadd_pairwise_i16x8_s

positive: i32x4.extadd_pairwise_i16x8_u instruction

	i32x4.extadd_pairwise_i16x8_u

positive: i32x4.extend_high_i16x8_s instruction

	i32x4.extend_high_i16x8_s

positive: i32x4.extend_high_i16x8_u instruction

	i32x4.extend_high_i16x8_u

positive: i32x4.extend_low_i16x8_s instruction

	i32x4.extend_low_i16x8_s

positive: i32x4.extend_low_i16x8_u instruction

	i32x4.extend_low_i16x8_u

positive: i32x4.extmul_high_i16x8_s instruction

	i32x4.extmul_high_i16x8_s

positive: i32x4.extmul_high_i16x8_u instruction

	i32x4.extmul_high_i16x8_u

positive: i32x4.extmul_low_i16x8_s instruction

	i32x4.extmul_low_i16x8_s

positive: i32x4.extmul_low_i16x8_u instruction

	i32x4.extmul_low_i16x8_u

positive: i32x4.extract_lane instruction

	i32x4.extract_lane	0
	i32x4.extract_lane	255

positive: i32x4.ge_s instruction

	i32x4.ge_s

positive: i32x4.ge_u instruction

	i32x4.ge_u

positive: i32x4.gt_s instruction

	i32x4.gt_s

positive: i32x4.gt_u instruction

	i32x4.gt_u

positive: i32x4.le_s instruction

	i32x4.le_s

positive: i32x4.le_u instruction

	i32x4.le_u

positive: i32x4.lt_s instruction

	i32x4.lt_s

positive: i32x4.lt_u instruction

	i32x4.lt_u

positive: i32x4.max_s instruction

	i32x4.max_s

positive: i32x4.max_u instruction

	i32x4.max_u

positive: i32x4.min_s instruction

	i32x4.min_s

positive: i32x4.min_u instruction

	i32x4.min_u

positive: i32x4.mul instruction

	i32x4.mul

positive: i32x4.ne instruction

	i32x4.ne

positive: i32x4.neg instruction

	i32x4.neg

positive: i32x4.replace_lane instruction

	i32x4.replace_lane	0
	i32x4.replace_lane	255

positive: i32x4.shl instruction

	i32x4.shl

positive: i32x4.shr_s instruction

	i32x4.shr_s

positive: i32x4.shr_u instruction

	i32x4.shr_u

positive: i32x4.splat instruction

	i32x4.splat

positive: i32x4.sub instruction

	i32x4.sub

positive: i32x4.trunc_sat_f32x4_s instruction

	i32x4.trunc_sat_f32x4_s

positive: i32x4.trunc_sat_f32x4_u instruction

	i32x4.trunc_sat_f32x4_u

positive: i32x4.trunc_sat_f64x2_s_zero instruction

	i32x4.trunc_sat_f64x2_s_zero

positive: i32x4.trunc_sat_f64x2_u_zero instruction

	i32x4.trunc_sat_f64x2_u_zero

positive: i64.add instruction

	i64.add

positive: i64.and instruction

	i64.and

positive: i64.clz instruction

	i64.clz

positive: i64.const instruction

	i64.const	-9223372036854775807
	i64.const	+9223372036854775807
	i64.const

positive: i64.ctz instruction

	i64.ctz

positive: i64.div_s instruction

	i64.div_s

positive: i64.div_u instruction

	i64.div_u

positive: i64.eq instruction

	i64.eq

positive: i64.eqz instruction

	i64.eqz

positive: i64.extend16_s instruction

	i64.extend16_s

positive: i64.extend32_s instruction

	i64.extend32_s

positive: i64.extend8_s instruction

	i64.extend8_s

positive: i64.extend_i32_s instruction

	i64.extend_i32_s

positive: i64.extend_i32_u instruction

	i64.extend_i32_u

positive: i64.ge_s instruction

	i64.ge_s

positive: i64.ge_u instruction

	i64.ge_u

positive: i64.gt_s instruction

	i64.gt_s

positive: i64.gt_u instruction

	i64.gt_u

positive: i64.le_s instruction

	i64.le_s

positive: i64.le_u instruction

	i64.le_u

positive: i64.load instruction

	i64.load	1 0
	i64.load	32 4294967295

positive: i64.load16_s instruction

	i64.load16_s	1 0
	i64.load16_s	32 4294967295

positive: i64.load16_u instruction

	i64.load16_u	1 0
	i64.load16_u	32 4294967295

positive: i64.load32_s instruction

	i64.load32_s	1 0
	i64.load32_s	32 4294967295

positive: i64.load32_u instruction

	i64.load32_u	1 0
	i64.load32_u	32 4294967295

positive: i64.load8_s instruction

	i64.load8_s	1 0
	i64.load8_s	32 4294967295

positive: i64.load8_u instruction

	i64.load8_u	1 0
	i64.load8_u	32 4294967295

positive: i64.lt_s instruction

	i64.lt_s

positive: i64.lt_u instruction

	i64.lt_u

positive: i64.mul instruction

	i64.mul

positive: i64.ne instruction

	i64.ne

positive: i64.or instruction

	i64.or

positive: i64.popcnt instruction

	i64.popcnt

positive: i64.reinterpret_f64 instruction

	i64.reinterpret_f64

positive: i64.rem_s instruction

	i64.rem_s

positive: i64.rem_u instruction

	i64.rem_u

positive: i64.rotl instruction

	i64.rotl

positive: i64.rotr instruction

	i64.rotr

positive: i64.shl instruction

	i64.shl

positive: i64.shr_s instruction

	i64.shr_s

positive: i64.shr_u instruction

	i64.shr_u

positive: i64.store instruction

	i64.store	1 0
	i64.store	32 4294967295

positive: i64.store16 instruction

	i64.store16	1 0
	i64.store16	32 4294967295

positive: i64.store32 instruction

	i64.store32	1 0
	i64.store32	32 4294967295

positive: i64.store8 instruction

	i64.store8	1 0
	i64.store8	32 4294967295

positive: i64.sub instruction

	i64.sub

positive: i64.trunc_f32_s instruction

	i64.trunc_f32_s

positive: i64.trunc_f32_u instruction

	i64.trunc_f32_u

positive: i64.trunc_f64_s instruction

	i64.trunc_f64_s

positive: i64.trunc_f64_u instruction

	i64.trunc_f64_u

positive: i64.trunc_sat_f32_s instruction

	i64.trunc_sat_f32_s

positive: i64.trunc_sat_f32_u instruction

	i64.trunc_sat_f32_u

positive: i64.trunc_sat_f64_s instruction

	i64.trunc_sat_f64_s

positive: i64.trunc_sat_f64_u instruction

	i64.trunc_sat_f64_u

positive: i64.xor instruction

	i64.xor

positive: i64x2.abs instruction

	i64x2.abs

positive: i64x2.add instruction

	i64x2.add

positive: i64x2.all_true instruction

	i64x2.all_true

positive: i64x2.bitmask instruction

	i64x2.bitmask

positive: i64x2.eq instruction

	i64x2.eq

positive: i64x2.extend_high_i32x4_s instruction

	i64x2.extend_high_i32x4_s

positive: i64x2.extend_high_i32x4_u instruction

	i64x2.extend_high_i32x4_u

positive: i64x2.extend_low_i32x4_s instruction

	i64x2.extend_low_i32x4_s

positive: i64x2.extend_low_i32x4_u instruction

	i64x2.extend_low_i32x4_u

positive: i64x2.extmul_high_i32x4_s instruction

	i64x2.extmul_high_i32x4_s

positive: i64x2.extmul_high_i32x4_u instruction

	i64x2.extmul_high_i32x4_u

positive: i64x2.extmul_low_i32x4_s instruction

	i64x2.extmul_low_i32x4_s

positive: i64x2.extmul_low_i32x4_u instruction

	i64x2.extmul_low_i32x4_u

positive: i64x2.extract_lane instruction

	i64x2.extract_lane	0
	i64x2.extract_lane	255

positive: i64x2.ge_s instruction

	i64x2.ge_s

positive: i64x2.gt_s instruction

	i64x2.gt_s

positive: i64x2.le_s instruction

	i64x2.le_s

positive: i64x2.lt_s instruction

	i64x2.lt_s

positive: i64x2.mul instruction

	i64x2.mul

positive: i64x2.ne instruction

	i64x2.ne

positive: i64x2.neg instruction

	i64x2.neg

positive: i64x2.replace_lane instruction

	i64x2.replace_lane	0
	i64x2.replace_lane	255

positive: i64x2.shl instruction

	i64x2.shl

positive: i64x2.shr_s instruction

	i64x2.shr_s

positive: i64x2.shr_u instruction

	i64x2.shr_u

positive: i64x2.splat instruction

	i64x2.splat

positive: i64x2.sub instruction

	i64x2.sub

positive: i8x16.abs instruction

	i8x16.abs

positive: i8x16.add instruction

	i8x16.add

positive: i8x16.add_sat_s instruction

	i8x16.add_sat_s

positive: i8x16.add_sat_u instruction

	i8x16.add_sat_u

positive: i8x16.all_true instruction

	i8x16.all_true

positive: i8x16.avgr_u instruction

	i8x16.avgr_u

positive: i8x16.bitmask instruction

	i8x16.bitmask

positive: i8x16.eq instruction

	i8x16.eq

positive: i8x16.extract_lane_s instruction

	i8x16.extract_lane_s	0
	i8x16.extract_lane_s	255

positive: i8x16.extract_lane_u instruction

	i8x16.extract_lane_u	0
	i8x16.extract_lane_u	255

positive: i8x16.ge_s instruction

	i8x16.ge_s

positive: i8x16.ge_u instruction

	i8x16.ge_u

positive: i8x16.gt_s instruction

	i8x16.gt_s

positive: i8x16.gt_u instruction

	i8x16.gt_u

positive: i8x16.le_s instruction

	i8x16.le_s

positive: i8x16.le_u instruction

	i8x16.le_u

positive: i8x16.lt_s instruction

	i8x16.lt_s

positive: i8x16.lt_u instruction

	i8x16.lt_u

positive: i8x16.max_s instruction

	i8x16.max_s

positive: i8x16.max_u instruction

	i8x16.max_u

positive: i8x16.min_s instruction

	i8x16.min_s

positive: i8x16.min_u instruction

	i8x16.min_u

positive: i8x16.narrow_i16x8_s instruction

	i8x16.narrow_i16x8_s

positive: i8x16.narrow_i16x8_u instruction

	i8x16.narrow_i16x8_u

positive: i8x16.ne instruction

	i8x16.ne

positive: i8x16.neg instruction

	i8x16.neg

positive: i8x16.popcnt instruction

	i8x16.popcnt

positive: i8x16.replace_lane instruction

	i8x16.replace_lane	0
	i8x16.replace_lane	255

positive: i8x16.shl instruction

	i8x16.shl

positive: i8x16.shr_s instruction

	i8x16.shr_s

positive: i8x16.shr_u instruction

	i8x16.shr_u

positive: i8x16.shuffle instruction

	i8x16.shuffle

positive: i8x16.splat instruction

	i8x16.splat

positive: i8x16.sub instruction

	i8x16.sub

positive: i8x16.sub_sat_s instruction

	i8x16.sub_sat_s

positive: i8x16.sub_sat_u instruction

	i8x16.sub_sat_u

positive: i8x16.swizzle instruction

	i8x16.swizzle

positive: if instruction

	if
	if	0
	if	4294967295
	if	i32
	if	i64
	if	f32
	if	f64
	if	v128
	if	funcref
	if	externref

positive: label instruction

	label	0
	label	4294967295

positive: lane instruction

	lane	0
	lane	255

positive: local.get instruction

	local.get	0
	local.get	4294967295
	local.get

positive: local.set instruction

	local.set	0
	local.set	4294967295
	local.set

positive: local.tee instruction

	local.tee	0
	local.tee	4294967295
	local.tee

positive: loop instruction

	loop
	loop	0
	loop	4294967295
	loop	i32
	loop	i64
	loop	f32
	loop	f64
	loop	v128
	loop	funcref
	loop	externref

positive: memory.copy instruction

	memory.copy

positive: memory.fill instruction

	memory.fill

positive: memory.grow instruction

	memory.grow

positive: memory.init instruction

	memory.init	0
	memory.init	4294967295
	memory.init

positive: memory.size instruction

	memory.size

positive: nop instruction

	nop

positive: ref.func instruction

	ref.func	0
	ref.func	4294967295
	ref.func

positive: ref.is_null instruction

	ref.is_null

positive: ref.null instruction

	ref.null	funcref
	ref.null	externref

positive: return instruction

	return

positive: s32 instruction

	s32	-2147483648
	s32	+2147483647

positive: select instruction

	select
	select	i32
	select	i64
	select	f32
	select	f64
	select	v128
	select	funcref
	select	externref

positive: table.copy instruction

	table.copy	0 0
	table.copy	4294967295 4294967295
	table.copy

positive: table.fill instruction

	table.fill	0
	table.fill	4294967295
	table.fill

positive: table.get instruction

	table.get	0
	table.get	4294967295
	table.get

positive: table.grow instruction

	table.grow	0
	table.grow	4294967295
	table.grow

positive: table.init instruction

	table.init	0 0
	table.init	4294967295 4294967295
	table.init

positive: table.set instruction

	table.set	0
	table.set	4294967295
	table.set

positive: table.size instruction

	table.size	0
	table.size	4294967295
	table.size

positive: u32 instruction

	u32	0
	u32	4294967295

positive: unreachable instruction

	unreachable

positive: v128.and instruction

	v128.and

positive: v128.andnot instruction

	v128.andnot

positive: v128.any_true instruction

	v128.any_true

positive: v128.bitselect instruction

	v128.bitselect

positive: v128.const instruction

	v128.const

positive: v128.load instruction

	v128.load	1 0
	v128.load	32 4294967295

positive: v128.load16_lane instruction

	v128.load16_lane	1 0 0
	v128.load16_lane	32 4294967295 255

positive: v128.load16_splat instruction

	v128.load16_splat	1 0
	v128.load16_splat	32 4294967295

positive: v128.load16x4_s instruction

	v128.load16x4_s	1 0
	v128.load16x4_s	32 4294967295

positive: v128.load16x4_u instruction

	v128.load16x4_u	1 0
	v128.load16x4_u	32 4294967295

positive: v128.load32_lane instruction

	v128.load32_lane	1 0 0
	v128.load32_lane	32 4294967295 255

positive: v128.load32_splat instruction

	v128.load32_splat	1 0
	v128.load32_splat	32 4294967295

positive: v128.load32_zero instruction

	v128.load32_zero	1 0
	v128.load32_zero	32 4294967295

positive: v128.load32x2_s instruction

	v128.load32x2_s	1 0
	v128.load32x2_s	32 4294967295

positive: v128.load32x2_u instruction

	v128.load32x2_u	1 0
	v128.load32x2_u	32 4294967295

positive: v128.load64_lane instruction

	v128.load64_lane	1 0 0
	v128.load64_lane	32 4294967295 255

positive: v128.load64_splat instruction

	v128.load64_splat	1 0
	v128.load64_splat	32 4294967295

positive: v128.load64_zero instruction

	v128.load64_zero	1 0
	v128.load64_zero	32 4294967295

positive: v128.load8_lane instruction

	v128.load8_lane	1 0 0
	v128.load8_lane	32 4294967295 255

positive: v128.load8_splat instruction

	v128.load8_splat	1 0
	v128.load8_splat	32 4294967295

positive: v128.load8x8_s instruction

	v128.load8x8_s	1 0
	v128.load8x8_s	32 4294967295

positive: v128.load8x8_u instruction

	v128.load8x8_u	1 0
	v128.load8x8_u	32 4294967295

positive: v128.not instruction

	v128.not

positive: v128.or instruction

	v128.or

positive: v128.store instruction

	v128.store	1 0
	v128.store	32 4294967295

positive: v128.store16_lane instruction

	v128.store16_lane	1 0 0
	v128.store16_lane	32 4294967295 255

positive: v128.store32_lane instruction

	v128.store32_lane	1 0 0
	v128.store32_lane	32 4294967295 255

positive: v128.store64_lane instruction

	v128.store64_lane	1 0 0
	v128.store64_lane	32 4294967295 255

positive: v128.store8_lane instruction

	v128.store8_lane	1 0 0
	v128.store8_lane	32 4294967295 255

positive: v128.xor instruction

	v128.xor

positive: valtype instruction

	valtype	i32
	valtype	i64
	valtype	f32
	valtype	f64
	valtype	v128
	valtype	funcref
	valtype	externref

positive: vec instruction

	vec	0
	vec	4294967295

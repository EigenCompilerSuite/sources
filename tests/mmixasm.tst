# MMIX assembler test and validation suite
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
	swym	0, 0, 0
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
	swym	0, 0, 0
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

# MMIX assembler

positive: ldb instruction

	ldb	$0, $0, $0
	ldb	$255, $255, $255
	ldb	$0, $0, 0
	ldb	$255, $255, 255

positive: ldbi instruction

	ldbi	$0, $0, 0
	ldbi	$255, $255, 255

positive: ldbu instruction

	ldbu	$0, $0, $0
	ldbu	$255, $255, $255
	ldbu	$0, $0, 0
	ldbu	$255, $255, 255

positive: ldbui instruction

	ldbui	$0, $0, 0
	ldbui	$255, $255, 255

positive: ldw instruction

	ldw	$0, $0, $0
	ldw	$255, $255, $255
	ldw	$0, $0, 0
	ldw	$255, $255, 255

positive: ldwi instruction

	ldwi	$0, $0, 0
	ldwi	$255, $255, 255

positive: ldwu instruction

	ldwu	$0, $0, $0
	ldwu	$255, $255, $255
	ldwu	$0, $0, 0
	ldwu	$255, $255, 255

positive: ldwui instruction

	ldwui	$0, $0, 0
	ldwui	$255, $255, 255

positive: ldt instruction

	ldt	$0, $0, $0
	ldt	$255, $255, $255
	ldt	$0, $0, 0
	ldt	$255, $255, 255

positive: ldti instruction

	ldti	$0, $0, 0
	ldti	$255, $255, 255

positive: ldtu instruction

	ldtu	$0, $0, $0
	ldtu	$255, $255, $255
	ldtu	$0, $0, 0
	ldtu	$255, $255, 255

positive: ldtui instruction

	ldtui	$0, $0, 0
	ldtui	$255, $255, 255

positive: ldo instruction

	ldo	$0, $0, $0
	ldo	$255, $255, $255
	ldo	$0, $0, 0
	ldo	$255, $255, 255

positive: ldoi instruction

	ldoi	$0, $0, 0
	ldoi	$255, $255, 255

positive: ldou instruction

	ldou	$0, $0, $0
	ldou	$255, $255, $255
	ldou	$0, $0, 0
	ldou	$255, $255, 255

positive: ldoui instruction

	ldoui	$0, $0, 0
	ldoui	$255, $255, 255

positive: ldht instruction

	ldht	$0, $0, $0
	ldht	$255, $255, $255
	ldht	$0, $0, 0
	ldht	$255, $255, 255

positive: ldhti instruction

	ldhti	$0, $0, 0
	ldhti	$255, $255, 255

positive: stb instruction

	stb	$0, $0, $0
	stb	$255, $255, $255
	stb	$0, $0, 0
	stb	$255, $255, 255

positive: stbi instruction

	stbi	$0, $0, 0
	stbi	$255, $255, 255

positive: stbu instruction

	stbu	$0, $0, $0
	stbu	$255, $255, $255
	stbu	$0, $0, 0
	stbu	$255, $255, 255

positive: stbui instruction

	stbui	$0, $0, 0
	stbui	$255, $255, 255

positive: stw instruction

	stw	$0, $0, $0
	stw	$255, $255, $255
	stw	$0, $0, 0
	stw	$255, $255, 255

positive: stwi instruction

	stwi	$0, $0, 0
	stwi	$255, $255, 255

positive: stwu instruction

	stwu	$0, $0, $0
	stwu	$255, $255, $255
	stwu	$0, $0, 0
	stwu	$255, $255, 255

positive: stwui instruction

	stwui	$0, $0, 0
	stwui	$255, $255, 255

positive: stt instruction

	stt	$0, $0, $0
	stt	$255, $255, $255
	stt	$0, $0, 0
	stt	$255, $255, 255

positive: stti instruction

	stti	$0, $0, 0
	stti	$255, $255, 255

positive: sttu instruction

	sttu	$0, $0, $0
	sttu	$255, $255, $255
	sttu	$0, $0, 0
	sttu	$255, $255, 255

positive: sttui instruction

	sttui	$0, $0, 0
	sttui	$255, $255, 255

positive: sto instruction

	sto	$0, $0, $0
	sto	$255, $255, $255
	sto	$0, $0, 0
	sto	$255, $255, 255

positive: stoi instruction

	stoi	$0, $0, 0
	stoi	$255, $255, 255

positive: stou instruction

	stou	$0, $0, $0
	stou	$255, $255, $255
	stou	$0, $0, 0
	stou	$255, $255, 255

positive: stoui instruction

	stoui	$0, $0, 0
	stoui	$255, $255, 255

positive: stht instruction

	stht	$0, $0, $0
	stht	$255, $255, $255
	stht	$0, $0, 0
	stht	$255, $255, 255

positive: sthti instruction

	sthti	$0, $0, 0
	sthti	$255, $255, 255

positive: stco instruction

	stco	0, $0, $0
	stco	255, $255, $255
	stco	0, $0, 0
	stco	255, $255, 255

positive: stcoi instruction

	stcoi	0, $0, 0
	stcoi	255, $255, 255

positive: add instruction

	add	$0, $0, $0
	add	$255, $255, $255
	add	$0, $0, 0
	add	$255, $255, 255

positive: addi instruction

	addi	$0, $0, 0
	addi	$255, $255, 255

positive: addu instruction

	addu	$0, $0, $0
	addu	$255, $255, $255
	addu	$0, $0, 0
	addu	$255, $255, 255

positive: addui instruction

	addui	$0, $0, 0
	addui	$255, $255, 255

positive: 2addu instruction

	2addu	$0, $0, $0
	2addu	$255, $255, $255
	2addu	$0, $0, 0
	2addu	$255, $255, 255

positive: 2addui instruction

	2addui	$0, $0, 0
	2addui	$255, $255, 255

positive: 4addu instruction

	4addu	$0, $0, $0
	4addu	$255, $255, $255
	4addu	$0, $0, 0
	4addu	$255, $255, 255

positive: 4addui instruction

	4addui	$0, $0, 0
	4addui	$255, $255, 255

positive: 8addu instruction

	8addu	$0, $0, $0
	8addu	$255, $255, $255
	8addu	$0, $0, 0
	8addu	$255, $255, 255

positive: 8addui instruction

	8addui	$0, $0, 0
	8addui	$255, $255, 255

positive: 16addu instruction

	16addu	$0, $0, $0
	16addu	$255, $255, $255
	16addu	$0, $0, 0
	16addu	$255, $255, 255

positive: 16addui instruction

	16addui	$0, $0, 0
	16addui	$255, $255, 255

positive: sub instruction

	sub	$0, $0, $0
	sub	$255, $255, $255
	sub	$0, $0, 0
	sub	$255, $255, 255

positive: subi instruction

	subi	$0, $0, 0
	subi	$255, $255, 255

positive: subu instruction

	subu	$0, $0, $0
	subu	$255, $255, $255
	subu	$0, $0, 0
	subu	$255, $255, 255

positive: subui instruction

	subui	$0, $0, 0
	subui	$255, $255, 255

positive: neg instruction

	neg	$0, 0, $0
	neg	$255, 255, $255
	neg	$0, 0, 0
	neg	$255, 255, 255

positive: negi instruction

	negi	$0, 0, 0
	negi	$255, 255, 255

positive: negu instruction

	negu	$0, 0, $0
	negu	$255, 255, $255
	negu	$0, 0, 0
	negu	$255, 255, 255

positive: negui instruction

	negui	$0, 0, 0
	negui	$255, 255, 255

positive: and instruction

	and	$0, $0, $0
	and	$255, $255, $255
	and	$0, $0, 0
	and	$255, $255, 255

positive: andi instruction

	andi	$0, $0, 0
	andi	$255, $255, 255

positive: or instruction

	or	$0, $0, $0
	or	$255, $255, $255
	or	$0, $0, 0
	or	$255, $255, 255

positive: ori instruction

	ori	$0, $0, 0
	ori	$255, $255, 255

positive: xor instruction

	xor	$0, $0, $0
	xor	$255, $255, $255
	xor	$0, $0, 0
	xor	$255, $255, 255

positive: xori instruction

	xori	$0, $0, 0
	xori	$255, $255, 255

positive: andn instruction

	andn	$0, $0, $0
	andn	$255, $255, $255
	andn	$0, $0, 0
	andn	$255, $255, 255

positive: andni instruction

	andni	$0, $0, 0
	andni	$255, $255, 255

positive: orn instruction

	orn	$0, $0, $0
	orn	$255, $255, $255
	orn	$0, $0, 0
	orn	$255, $255, 255

positive: orni instruction

	orni	$0, $0, 0
	orni	$255, $255, 255

positive: nand instruction

	nand	$0, $0, $0
	nand	$255, $255, $255
	nand	$0, $0, 0
	nand	$255, $255, 255

positive: nandi instruction

	nandi	$0, $0, 0
	nandi	$255, $255, 255

positive: nor instruction

	nor	$0, $0, $0
	nor	$255, $255, $255
	nor	$0, $0, 0
	nor	$255, $255, 255

positive: nori instruction

	nori	$0, $0, 0
	nori	$255, $255, 255

positive: nxor instruction

	nxor	$0, $0, $0
	nxor	$255, $255, $255
	nxor	$0, $0, 0
	nxor	$255, $255, 255

positive: nxori instruction

	nxori	$0, $0, 0
	nxori	$255, $255, 255

positive: mux instruction

	mux	$0, $0, $0
	mux	$255, $255, $255
	mux	$0, $0, 0
	mux	$255, $255, 255

positive: muxi instruction

	muxi	$0, $0, 0
	muxi	$255, $255, 255

positive: bdif instruction

	bdif	$0, $0, $0
	bdif	$255, $255, $255
	bdif	$0, $0, 0
	bdif	$255, $255, 255

positive: bdifi instruction

	bdifi	$0, $0, 0
	bdifi	$255, $255, 255

positive: wdif instruction

	wdif	$0, $0, $0
	wdif	$255, $255, $255
	wdif	$0, $0, 0
	wdif	$255, $255, 255

positive: wdifi instruction

	wdifi	$0, $0, 0
	wdifi	$255, $255, 255

positive: tdif instruction

	tdif	$0, $0, $0
	tdif	$255, $255, $255
	tdif	$0, $0, 0
	tdif	$255, $255, 255

positive: tdifi instruction

	tdifi	$0, $0, 0
	tdifi	$255, $255, 255

positive: odif instruction

	odif	$0, $0, $0
	odif	$255, $255, $255
	odif	$0, $0, 0
	odif	$255, $255, 255

positive: odifi instruction

	odifi	$0, $0, 0
	odifi	$255, $255, 255

positive: sadd instruction

	sadd	$0, $0, $0
	sadd	$255, $255, $255
	sadd	$0, $0, 0
	sadd	$255, $255, 255

positive: saddi instruction

	saddi	$0, $0, 0
	saddi	$255, $255, 255

positive: mor instruction

	mor	$0, $0, $0
	mor	$255, $255, $255
	mor	$0, $0, 0
	mor	$255, $255, 255

positive: mori instruction

	mori	$0, $0, 0
	mori	$255, $255, 255

positive: mxor instruction

	mxor	$0, $0, $0
	mxor	$255, $255, $255
	mxor	$0, $0, 0
	mxor	$255, $255, 255

positive: mxori instruction

	mxori	$0, $0, 0
	mxori	$255, $255, 255

positive: seth instruction

	seth	$0, 0
	seth	$255, 65535

positive: setmh instruction

	setmh	$0, 0
	setmh	$255, 65535

positive: setml instruction

	setml	$0, 0
	setml	$255, 65535

positive: setl instruction

	setl	$0, 0
	setl	$255, 65535

positive: inch instruction

	inch	$0, 0
	inch	$255, 65535

positive: incmh instruction

	incmh	$0, 0
	incmh	$255, 65535

positive: incml instruction

	incml	$0, 0
	incml	$255, 65535

positive: incl instruction

	incl	$0, 0
	incl	$255, 65535

positive: orh instruction

	orh	$0, 0
	orh	$255, 65535

positive: ormh instruction

	ormh	$0, 0
	ormh	$255, 65535

positive: orml instruction

	orml	$0, 0
	orml	$255, 65535

positive: orl instruction

	orl	$0, 0
	orl	$255, 65535

positive: andnh instruction

	andnh	$0, 0
	andnh	$255, 65535

positive: andnmh instruction

	andnmh	$0, 0
	andnmh	$255, 65535

positive: andnml instruction

	andnml	$0, 0
	andnml	$255, 65535

positive: andnl instruction

	andnl	$0, 0
	andnl	$255, 65535

positive: sl instruction

	sl	$0, $0, $0
	sl	$255, $255, $255
	sl	$0, $0, 0
	sl	$255, $255, 255

positive: sli instruction

	sli	$0, $0, 0
	sli	$255, $255, 255

positive: slu instruction

	slu	$0, $0, $0
	slu	$255, $255, $255
	slu	$0, $0, 0
	slu	$255, $255, 255

positive: slui instruction

	slui	$0, $0, 0
	slui	$255, $255, 255

positive: sr instruction

	sr	$0, $0, $0
	sr	$255, $255, $255
	sr	$0, $0, 0
	sr	$255, $255, 255

positive: sri instruction

	sri	$0, $0, 0
	sri	$255, $255, 255

positive: sru instruction

	sru	$0, $0, $0
	sru	$255, $255, $255
	sru	$0, $0, 0
	sru	$255, $255, 255

positive: srui instruction

	srui	$0, $0, 0
	srui	$255, $255, 255

positive: cmp instruction

	cmp	$0, $0, $0
	cmp	$255, $255, $255
	cmp	$0, $0, 0
	cmp	$255, $255, 255

positive: cmpi instruction

	cmpi	$0, $0, 0
	cmpi	$255, $255, 255

positive: cmpu instruction

	cmpu	$0, $0, $0
	cmpu	$255, $255, $255
	cmpu	$0, $0, 0
	cmpu	$255, $255, 255

positive: cmpui instruction

	cmpui	$0, $0, 0
	cmpui	$255, $255, 255

positive: csn instruction

	csn	$0, $0, $0
	csn	$255, $255, $255
	csn	$0, $0, 0
	csn	$255, $255, 255

positive: csni instruction

	csni	$0, $0, 0
	csni	$255, $255, 255

positive: csz instruction

	csz	$0, $0, $0
	csz	$255, $255, $255
	csz	$0, $0, 0
	csz	$255, $255, 255

positive: cszi instruction

	cszi	$0, $0, 0
	cszi	$255, $255, 255

positive: csp instruction

	csp	$0, $0, $0
	csp	$255, $255, $255
	csp	$0, $0, 0
	csp	$255, $255, 255

positive: cspi instruction

	cspi	$0, $0, 0
	cspi	$255, $255, 255

positive: csod instruction

	csod	$0, $0, $0
	csod	$255, $255, $255
	csod	$0, $0, 0
	csod	$255, $255, 255

positive: csodi instruction

	csodi	$0, $0, 0
	csodi	$255, $255, 255

positive: csnn instruction

	csnn	$0, $0, $0
	csnn	$255, $255, $255
	csnn	$0, $0, 0
	csnn	$255, $255, 255

positive: csnni instruction

	csnni	$0, $0, 0
	csnni	$255, $255, 255

positive: csnz instruction

	csnz	$0, $0, $0
	csnz	$255, $255, $255
	csnz	$0, $0, 0
	csnz	$255, $255, 255

positive: csnzi instruction

	csnzi	$0, $0, 0
	csnzi	$255, $255, 255

positive: csnp instruction

	csnp	$0, $0, $0
	csnp	$255, $255, $255
	csnp	$0, $0, 0
	csnp	$255, $255, 255

positive: csnpi instruction

	csnpi	$0, $0, 0
	csnpi	$255, $255, 255

positive: csev instruction

	csev	$0, $0, $0
	csev	$255, $255, $255
	csev	$0, $0, 0
	csev	$255, $255, 255

positive: csevi instruction

	csevi	$0, $0, 0
	csevi	$255, $255, 255

positive: zsn instruction

	zsn	$0, $0, $0
	zsn	$255, $255, $255
	zsn	$0, $0, 0
	zsn	$255, $255, 255

positive: zsni instruction

	zsni	$0, $0, 0
	zsni	$255, $255, 255

positive: zsz instruction

	zsz	$0, $0, $0
	zsz	$255, $255, $255
	zsz	$0, $0, 0
	zsz	$255, $255, 255

positive: zszi instruction

	zszi	$0, $0, 0
	zszi	$255, $255, 255

positive: zsp instruction

	zsp	$0, $0, $0
	zsp	$255, $255, $255
	zsp	$0, $0, 0
	zsp	$255, $255, 255

positive: zspi instruction

	zspi	$0, $0, 0
	zspi	$255, $255, 255

positive: zsod instruction

	zsod	$0, $0, $0
	zsod	$255, $255, $255
	zsod	$0, $0, 0
	zsod	$255, $255, 255

positive: zsodi instruction

	zsodi	$0, $0, 0
	zsodi	$255, $255, 255

positive: zsnn instruction

	zsnn	$0, $0, $0
	zsnn	$255, $255, $255
	zsnn	$0, $0, 0
	zsnn	$255, $255, 255

positive: zsnni instruction

	zsnni	$0, $0, 0
	zsnni	$255, $255, 255

positive: zsnz instruction

	zsnz	$0, $0, $0
	zsnz	$255, $255, $255
	zsnz	$0, $0, 0
	zsnz	$255, $255, 255

positive: zsnzi instruction

	zsnzi	$0, $0, 0
	zsnzi	$255, $255, 255

positive: zsnp instruction

	zsnp	$0, $0, $0
	zsnp	$255, $255, $255
	zsnp	$0, $0, 0
	zsnp	$255, $255, 255

positive: zsnpi instruction

	zsnpi	$0, $0, 0
	zsnpi	$255, $255, 255

positive: zsev instruction

	zsev	$0, $0, $0
	zsev	$255, $255, $255
	zsev	$0, $0, 0
	zsev	$255, $255, 255

positive: zsevi instruction

	zsevi	$0, $0, 0
	zsevi	$255, $255, 255

positive: bn instruction

	bn	$0, -262144
	bn	$255, +262140

positive: bnb instruction

	bnb	$0, -262144
	bnb	$255, +262140

positive: bz instruction

	bz	$0, -262144
	bz	$255, +262140

positive: bzb instruction

	bzb	$0, -262144
	bzb	$255, +262140

positive: bp instruction

	bp	$0, -262144
	bp	$255, +262140

positive: bpb instruction

	bpb	$0, -262144
	bpb	$255, +262140

positive: bod instruction

	bod	$0, -262144
	bod	$255, +262140

positive: bodb instruction

	bodb	$0, -262144
	bodb	$255, +262140

positive: bnn instruction

	bnn	$0, -262144
	bnn	$255, +262140

positive: bnnb instruction

	bnnb	$0, -262144
	bnnb	$255, +262140

positive: bnz instruction

	bnz	$0, -262144
	bnz	$255, +262140

positive: bnzb instruction

	bnzb	$0, -262144
	bnzb	$255, +262140

positive: bnp instruction

	bnp	$0, -262144
	bnp	$255, +262140

positive: bnpb instruction

	bnpb	$0, -262144
	bnpb	$255, +262140

positive: bev instruction

	bev	$0, -262144
	bev	$255, +262140

positive: bevb instruction

	bevb	$0, -262144
	bevb	$255, +262140

positive: pbn instruction

	pbn	$0, -262144
	pbn	$255, +262140

positive: pbnb instruction

	pbnb	$0, -262144
	pbnb	$255, +262140

positive: pbz instruction

	pbz	$0, -262144
	pbz	$255, +262140

positive: pbzb instruction

	pbzb	$0, -262144
	pbzb	$255, +262140

positive: pbp instruction

	pbp	$0, -262144
	pbp	$255, +262140

positive: pbpb instruction

	pbpb	$0, -262144
	pbpb	$255, +262140

positive: pbod instruction

	pbod	$0, -262144
	pbod	$255, +262140

positive: pbodb instruction

	pbodb	$0, -262144
	pbodb	$255, +262140

positive: pbnn instruction

	pbnn	$0, -262144
	pbnn	$255, +262140

positive: pbnnb instruction

	pbnnb	$0, -262144
	pbnnb	$255, +262140

positive: pbnz instruction

	pbnz	$0, -262144
	pbnz	$255, +262140

positive: pbnzb instruction

	pbnzb	$0, -262144
	pbnzb	$255, +262140

positive: pbnp instruction

	pbnp	$0, -262144
	pbnp	$255, +262140

positive: pbnpb instruction

	pbnpb	$0, -262144
	pbnpb	$255, +262140

positive: pbev instruction

	pbev	$0, -262144
	pbev	$255, +262140

positive: pbevb instruction

	pbevb	$0, -262144
	pbevb	$255, +262140

positive: geta instruction

	geta	$0, -262144
	geta	$255, +262140

positive: getab instruction

	getab	$0, -262144
	getab	$255, +262140

positive: jmp instruction

	jmp	-67108864
	jmp	+67108860

positive: jmpb instruction

	jmpb	-67108864
	jmpb	+67108860

positive: go instruction

	go	$0, $0, $0
	go	$255, $255, $255
	go	$0, $0, 0
	go	$255, $255, 255

positive: goi instruction

	goi	$0, $0, 0
	goi	$255, $255, 255

positive: mul instruction

	mul	$0, $0, $0
	mul	$255, $255, $255
	mul	$0, $0, 0
	mul	$255, $255, 255

positive: muli instruction

	muli	$0, $0, 0
	muli	$255, $255, 255

positive: mulu instruction

	mulu	$0, $0, $0
	mulu	$255, $255, $255
	mulu	$0, $0, 0
	mulu	$255, $255, 255

positive: mului instruction

	mului	$0, $0, 0
	mului	$255, $255, 255

positive: div instruction

	div	$0, $0, $0
	div	$255, $255, $255
	div	$0, $0, 0
	div	$255, $255, 255

positive: divi instruction

	divi	$0, $0, 0
	divi	$255, $255, 255

positive: divu instruction

	divu	$0, $0, $0
	divu	$255, $255, $255
	divu	$0, $0, 0
	divu	$255, $255, 255

positive: divui instruction

	divui	$0, $0, 0
	divui	$255, $255, 255

positive: fadd instruction

	fadd	$0, $0, $0
	fadd	$255, $255, $255

positive: fsub instruction

	fsub	$0, $0, $0
	fsub	$255, $255, $255

positive: fmul instruction

	fmul	$0, $0, $0
	fmul	$255, $255, $255

positive: fdiv instruction

	fdiv	$0, $0, $0
	fdiv	$255, $255, $255

positive: frem instruction

	frem	$0, $0, $0
	frem	$255, $255, $255

positive: fsqrt instruction

	fsqrt	$0, 0, $0
	fsqrt	$255, 255, $255

positive: fint instruction

	fint	$0, 0, $0
	fint	$255, 255, $255

positive: fcmp instruction

	fcmp	$0, $0, $0
	fcmp	$255, $255, $255

positive: feql instruction

	feql	$0, $0, $0
	feql	$255, $255, $255

positive: fun instruction

	fun	$0, $0, $0
	fun	$255, $255, $255

positive: fcmpe instruction

	fcmpe	$0, $0, $0
	fcmpe	$255, $255, $255

positive: feqle instruction

	feqle	$0, $0, $0
	feqle	$255, $255, $255

positive: fune instruction

	fune	$0, $0, $0
	fune	$255, $255, $255

positive: ldsf instruction

	ldsf	$0, $0, $0
	ldsf	$255, $255, $255
	ldsf	$0, $0, 0
	ldsf	$255, $255, 255

positive: ldsfi instruction

	ldsfi	$0, $0, 0
	ldsfi	$255, $255, 255

positive: stsf instruction

	stsf	$0, $0, $0
	stsf	$255, $255, $255
	stsf	$0, $0, 0
	stsf	$255, $255, 255

positive: stsfi instruction

	stsfi	$0, $0, 0
	stsfi	$255, $255, 255

positive: fix instruction

	fix	$0, 0, $0
	fix	$255, 255, $255

positive: fixu instruction

	fixu	$0, 0, $0
	fixu	$255, 255, $255

positive: flot instruction

	flot	$0, 0, $0
	flot	$255, 255, $255
	flot	$0, 0, 0
	flot	$255, 255, 255

positive: floti instruction

	floti	$0, 0, 0
	floti	$255, 255, 255

positive: flotu instruction

	flotu	$0, 0, $0
	flotu	$255, 255, $255
	flotu	$0, 0, 0
	flotu	$255, 255, 255

positive: flotui instruction

	flotui	$0, 0, 0
	flotui	$255, 255, 255

positive: sflot instruction

	sflot	$0, 0, $0
	sflot	$255, 255, $255
	sflot	$0, 0, 0
	sflot	$255, 255, 255

positive: sfloti instruction

	sfloti	$0, 0, 0
	sfloti	$255, 255, 255

positive: sflotu instruction

	sflotu	$0, 0, $0
	sflotu	$255, 255, $255
	sflotu	$0, 0, 0
	sflotu	$255, 255, 255

positive: sflotui instruction

	sflotui	$0, 0, 0
	sflotui	$255, 255, 255

positive: pushj instruction

	pushj	$0, -262144
	pushj	$255, +262140

positive: pushjb instruction

	pushjb	$0, -262144
	pushjb	$255, +262140

positive: pushgo instruction

	pushgo	$0, $0, $0
	pushgo	$255, $255, $255
	pushgo	$0, $0, 0
	pushgo	$255, $255, 255

positive: pushgoi instruction

	pushgoi	$0, $0, 0
	pushgoi	$255, $255, 255

positive: pop instruction

	pop	$0, -262144
	pop	$255, +262140

positive: ldunc instruction

	ldunc	$0, $0, $0
	ldunc	$255, $255, $255
	ldunc	$0, $0, 0
	ldunc	$255, $255, 255

positive: ldunci instruction

	ldunci	$0, $0, 0
	ldunci	$255, $255, 255

positive: stunc instruction

	stunc	$0, $0, $0
	stunc	$255, $255, $255
	stunc	$0, $0, 0
	stunc	$255, $255, 255

positive: stunci instruction

	stunci	$0, $0, 0
	stunci	$255, $255, 255

positive: preld instruction

	preld	$0, $0, $0
	preld	$255, $255, $255
	preld	$0, $0, 0
	preld	$255, $255, 255

positive: preldi instruction

	preldi	$0, $0, 0
	preldi	$255, $255, 255

positive: prego instruction

	prego	$0, $0, $0
	prego	$255, $255, $255
	prego	$0, $0, 0
	prego	$255, $255, 255

positive: pregoi instruction

	pregoi	$0, $0, 0
	pregoi	$255, $255, 255

positive: prest instruction

	prest	$0, $0, $0
	prest	$255, $255, $255
	prest	$0, $0, 0
	prest	$255, $255, 255

positive: presti instruction

	presti	$0, $0, 0
	presti	$255, $255, 255

positive: syncd instruction

	syncd	$0, $0, $0
	syncd	$255, $255, $255
	syncd	$0, $0, 0
	syncd	$255, $255, 255

positive: syncdi instruction

	syncdi	$0, $0, 0
	syncdi	$255, $255, 255

positive: syncid instruction

	syncid	$0, $0, $0
	syncid	$255, $255, $255
	syncid	$0, $0, 0
	syncid	$255, $255, 255

positive: syncidi instruction

	syncidi	$0, $0, 0
	syncidi	$255, $255, 255

positive: cswap instruction

	cswap	$0, $0, $0
	cswap	$255, $255, $255
	cswap	$0, $0, 0
	cswap	$255, $255, 255

positive: cswapi instruction

	cswapi	$0, $0, 0
	cswapi	$255, $255, 255

positive: sync instruction

	sync	0, 0, 0
	sync	255, 255, 255

positive: trap instruction

	trap	0, 0, 0
	trap	255, 255, 255

positive: trip instruction

	trip	0, 0, 0
	trip	255, 255, 255

positive: resume instruction

	resume	0
	resume	255

positive: get instruction

	get	$0, 0
	get	$255, 255

positive: put instruction

	put	0, $0
	put	255, $255
	put	0, 0
	put	255, 255

positive: puti instruction

	puti	0, 0
	puti	255, 255

positive: save instruction

	save	$0
	save	$255

positive: unsave instruction

	unsave	$0
	unsave	$255

positive: ldvts instruction

	ldvts	$0, $0, $0
	ldvts	$255, $255, $255
	ldvts	$0, $0, 0
	ldvts	$255, $255, 255

positive: ldvtsi instruction

	ldvtsi	$0, $0, 0
	ldvtsi	$255, $255, 255

positive: swym instruction

	swym	0, 0, 0
	swym	255, 255, 255

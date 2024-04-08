# OpenRISC 1000 assembler test and validation suite
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

# OpenRISC 1000 assembler

# basic instructions

positive: l.add instruction

	l.add	r0, r0, r0
	l.add	r31, r31, r31

positive: l.addc instruction

	l.addc	r0, r0, r0
	l.addc	r31, r31, r31

positive: l.addi instruction

	l.addi	r0, r0, -32768
	l.addi	r31, r31, +32767

positive: l.addic instruction

	l.addic	r0, r0, -32768
	l.addic	r31, r31, +32767

positive: l.and instruction

	l.and	r0, r0, r0
	l.and	r31, r31, r31

positive: l.andi instruction

	l.andi	r0, r0, 0
	l.andi	r31, r31, 65535

positive: l.bf instruction

	l.bf	-134217728
	l.bf	+134217724

positive: l.bnf instruction

	l.bnf	-134217728
	l.bnf	+134217724

positive: l.cmov instruction

	l.cmov	r0, r0, r0
	l.cmov	r31, r31, r31

positive: l.csync instruction

	l.csync

positive: l.div instruction

	l.div	r0, r0, r0
	l.div	r31, r31, r31

positive: l.divu instruction

	l.divu	r0, r0, r0
	l.divu	r31, r31, r31

positive: l.extbs instruction

	l.extbs	r0, r0
	l.extbs	r31, r31

positive: l.extbz instruction

	l.extbz	r0, r0
	l.extbz	r31, r31

positive: l.exths instruction

	l.exths	r0, r0
	l.exths	r31, r31

positive: l.exthz instruction

	l.exthz	r0, r0
	l.exthz	r31, r31

positive: l.extws instruction

	l.extws	r0, r0
	l.extws	r31, r31

positive: l.extwz instruction

	l.extwz	r0, r0
	l.extwz	r31, r31

positive: l.ff1 instruction

	l.ff1	r0, r0
	l.ff1	r31, r31

positive: l.fl1 instruction

	l.fl1	r0, r0
	l.fl1	r31, r31

positive: l.j instruction

	l.j	-134217728
	l.j	+134217724

positive: l.jal instruction

	l.jal	-134217728
	l.jal	+134217724

positive: l.jalr instruction

	l.jalr	r0
	l.jalr	r31

positive: l.jr instruction

	l.jr	r0
	l.jr	r31

positive: l.lbs instruction

	l.lbs	r0, -32768 (r0)
	l.lbs	r31, +32767 (r31)

positive: l.lbz instruction

	l.lbz	r0, -32768 (r0)
	l.lbz	r31, +32767 (r31)

positive: l.ld instruction

	l.ld	r0, -32768 (r0)
	l.ld	r31, +32767 (r31)

positive: l.lhs instruction

	l.lhs	r0, -32768 (r0)
	l.lhs	r31, +32767 (r31)

positive: l.lhz instruction

	l.lhz	r0, -32768 (r0)
	l.lhz	r31, +32767 (r31)

positive: l.lwa instruction

	l.lwa	r0, -32768 (r0)
	l.lwa	r31, +32767 (r31)

positive: l.lws instruction

	l.lws	r0, -32768 (r0)
	l.lws	r31, +32767 (r31)

positive: l.lwz instruction

	l.lwz	r0, -32768 (r0)
	l.lwz	r31, +32767 (r31)

positive: l.mac instruction

	l.mac	r0, r0
	l.mac	r31, r31

positive: l.maci instruction

	l.maci	r0, -32768
	l.maci	r31, +32767

positive: l.macrc instruction

	l.macrc	r0
	l.macrc	r31

positive: l.macu instruction

	l.macu	r0, r0
	l.macu	r31, r31

positive: l.mfspr instruction

	l.mfspr	r0, r0, 0
	l.mfspr	r31, r31, 65535

positive: l.movhi instruction

	l.movhi	r0, 0
	l.movhi	r31, 65535

positive: l.msb instruction

	l.msb	r0, r0
	l.msb	r31, r31

positive: l.msbu instruction

	l.msbu	r0, r0
	l.msbu	r31, r31

positive: l.msync instruction

	l.msync

positive: l.mtspr instruction

	l.mtspr	r0, r0, 0
	l.mtspr	r31, r31, 65535

positive: l.mul instruction

	l.mul	r0, r0, r0
	l.mul	r31, r31, r31

positive: l.muld instruction

	l.muld	r0, r0
	l.muld	r31, r31

positive: l.muldu instruction

	l.muldu	r0, r0
	l.muldu	r31, r31

positive: l.muli instruction

	l.muli	r0, r0, -32768
	l.muli	r31, r31, +32767

positive: l.mulu instruction

	l.mulu	r0, r0, r0
	l.mulu	r31, r31, r31

positive: l.nop instruction

	l.nop	0
	l.nop	65535

positive: l.or instruction

	l.or	r0, r0, r0
	l.or	r31, r31, r31

positive: l.ori instruction

	l.ori	r0, r0, 0
	l.ori	r31, r31, 65535

positive: l.psync instruction

	l.psync

positive: l.rfe instruction

	l.rfe

positive: l.ror instruction

	l.ror	r0, r0, r0
	l.ror	r31, r31, r31

positive: l.rori instruction

	l.rori	r0, r0, 0
	l.rori	r31, r31, 63

positive: l.sb instruction

	l.sb	-32768 (r0), r0
	l.sb	+32767 (r31), r31

positive: l.sd instruction

	l.sd	-32768 (r0), r0
	l.sd	+32767 (r31), r31

positive: l.sfeq instruction

	l.sfeq	r0, r0
	l.sfeq	r31, r31

positive: l.sfeqi instruction

	l.sfeqi	r0, -32768
	l.sfeqi	r31, +32767

positive: l.sfges instruction

	l.sfges	r0, r0
	l.sfges	r31, r31

positive: l.sfgesi instruction

	l.sfgesi	r0, -32768
	l.sfgesi	r31, +32767

positive: l.sfgeu instruction

	l.sfgeu	r0, r0
	l.sfgeu	r31, r31

positive: l.sfgeui instruction

	l.sfgeui	r0, -32768
	l.sfgeui	r31, +32767

positive: l.sfgts instruction

	l.sfgts	r0, r0
	l.sfgts	r31, r31

positive: l.sfgtsi instruction

	l.sfgtsi	r0, -32768
	l.sfgtsi	r31, +32767

positive: l.sfgtu instruction

	l.sfgtu	r0, r0
	l.sfgtu	r31, r31

positive: l.sfgtui instruction

	l.sfgtui	r0, -32768
	l.sfgtui	r31, +32767

positive: l.sfles instruction

	l.sfles	r0, r0
	l.sfles	r31, r31

positive: l.sflesi instruction

	l.sflesi	r0, -32768
	l.sflesi	r31, +32767

positive: l.sfleu instruction

	l.sfleu	r0, r0
	l.sfleu	r31, r31

positive: l.sfleui instruction

	l.sfleui	r0, -32768
	l.sfleui	r31, +32767

positive: l.sflts instruction

	l.sflts	r0, r0
	l.sflts	r31, r31

positive: l.sfltsi instruction

	l.sfltsi	r0, -32768
	l.sfltsi	r31, +32767

positive: l.sfltu instruction

	l.sfltu	r0, r0
	l.sfltu	r31, r31

positive: l.sfltui instruction

	l.sfltui	r0, -32768
	l.sfltui	r31, +32767

positive: l.sfne instruction

	l.sfne	r0, r0
	l.sfne	r31, r31

positive: l.sfnei instruction

	l.sfnei	r0, -32768
	l.sfnei	r31, +32767

positive: l.sh instruction

	l.sh	-32768 (r0), r0
	l.sh	+32767 (r31), r31

positive: l.sll instruction

	l.sll	r0, r0, r0
	l.sll	r31, r31, r31

positive: l.slli instruction

	l.slli	r0, r0, 0
	l.slli	r31, r31, 63

positive: l.sra instruction

	l.sra	r0, r0, r0
	l.sra	r31, r31, r31

positive: l.srai instruction

	l.srai	r0, r0, 0
	l.srai	r31, r31, 63

positive: l.srl instruction

	l.srl	r0, r0, r0
	l.srl	r31, r31, r31

positive: l.srli instruction

	l.srli	r0, r0, 0
	l.srli	r31, r31, 63

positive: l.sub instruction

	l.sub	r0, r0, r0
	l.sub	r31, r31, r31

positive: l.sw instruction

	l.sw	-32768 (r0), r0
	l.sw	+32767 (r31), r31

positive: l.swa instruction

	l.swa	-32768 (r0), r0
	l.swa	+32767 (r31), r31

positive: l.sys instruction

	l.sys	0
	l.sys	65535

positive: l.trap instruction

	l.trap	0
	l.trap	65535

positive: l.xor instruction

	l.xor	r0, r0, r0
	l.xor	r31, r31, r31

positive: l.xori instruction

	l.xori	r0, r0, -32768
	l.xori	r31, r31, +32767

# floating-point instructions

positive: lf.add.d instruction

	lf.add.d	r0, r0, r0
	lf.add.d	r31, r31, r31

positive: lf.add.s instruction

	lf.add.s	r0, r0, r0
	lf.add.s	r31, r31, r31

positive: lf.div.d instruction

	lf.div.d	r0, r0, r0
	lf.div.d	r31, r31, r31

positive: lf.div.s instruction

	lf.div.s	r0, r0, r0
	lf.div.s	r31, r31, r31

positive: lf.ftoi.d instruction

	lf.ftoi.d	r0, r0
	lf.ftoi.d	r31, r31

positive: lf.ftoi.s instruction

	lf.ftoi.s	r0, r0
	lf.ftoi.s	r31, r31

positive: lf.itof.d instruction

	lf.itof.d	r0, r0
	lf.itof.d	r31, r31

positive: lf.itof.s instruction

	lf.itof.s	r0, r0
	lf.itof.s	r31, r31

positive: lf.madd.d instruction

	lf.madd.d	r0, r0, r0
	lf.madd.d	r31, r31, r31

positive: lf.madd.s instruction

	lf.madd.s	r0, r0, r0
	lf.madd.s	r31, r31, r31

positive: lf.mul.d instruction

	lf.mul.d	r0, r0, r0
	lf.mul.d	r31, r31, r31

positive: lf.mul.s instruction

	lf.mul.s	r0, r0, r0
	lf.mul.s	r31, r31, r31

positive: lf.rem.d instruction

	lf.rem.d	r0, r0, r0
	lf.rem.d	r31, r31, r31

positive: lf.rem.s instruction

	lf.rem.s	r0, r0, r0
	lf.rem.s	r31, r31, r31

positive: lf.sfeq.d instruction

	lf.sfeq.d	r0, r0
	lf.sfeq.d	r31, r31

positive: lf.sfeq.s instruction

	lf.sfeq.s	r0, r0
	lf.sfeq.s	r31, r31

positive: lf.sfge.d instruction

	lf.sfge.d	r0, r0
	lf.sfge.d	r31, r31

positive: lf.sfge.s instruction

	lf.sfge.s	r0, r0
	lf.sfge.s	r31, r31

positive: lf.sfgt.d instruction

	lf.sfgt.d	r0, r0
	lf.sfgt.d	r31, r31

positive: lf.sfgt.s instruction

	lf.sfgt.s	r0, r0
	lf.sfgt.s	r31, r31

positive: lf.sfle.d instruction

	lf.sfle.d	r0, r0
	lf.sfle.d	r31, r31

positive: lf.sfle.s instruction

	lf.sfle.s	r0, r0
	lf.sfle.s	r31, r31

positive: lf.sflt.d instruction

	lf.sflt.d	r0, r0
	lf.sflt.d	r31, r31

positive: lf.sflt.s instruction

	lf.sflt.s	r0, r0
	lf.sflt.s	r31, r31

positive: lf.sfne.d instruction

	lf.sfne.d	r0, r0
	lf.sfne.d	r31, r31

positive: lf.sfne.s instruction

	lf.sfne.s	r0, r0
	lf.sfne.s	r31, r31

positive: lf.sub.d instruction

	lf.sub.d	r0, r0, r0
	lf.sub.d	r31, r31, r31

positive: lf.sub.s instruction

	lf.sub.s	r0, r0, r0
	lf.sub.s	r31, r31, r31

# vector instructions

positive: lv.add.b instruction

	lv.add.b	r0, r0, r0
	lv.add.b	r31, r31, r31

positive: lv.add.h instruction

	lv.add.h	r0, r0, r0
	lv.add.h	r31, r31, r31

positive: lv.adds.b instruction

	lv.adds.b	r0, r0, r0
	lv.adds.b	r31, r31, r31

positive: lv.adds.h instruction

	lv.adds.h	r0, r0, r0
	lv.adds.h	r31, r31, r31

positive: lv.addu.b instruction

	lv.addu.b	r0, r0, r0
	lv.addu.b	r31, r31, r31

positive: lv.addu.h instruction

	lv.addu.h	r0, r0, r0
	lv.addu.h	r31, r31, r31

positive: lv.addus.b instruction

	lv.addus.b	r0, r0, r0
	lv.addus.b	r31, r31, r31

positive: lv.addus.h instruction

	lv.addus.h	r0, r0, r0
	lv.addus.h	r31, r31, r31

positive: lv.all_eq.b instruction

	lv.all_eq.b	r0, r0, r0
	lv.all_eq.b	r31, r31, r31

positive: lv.all_eq.h instruction

	lv.all_eq.h	r0, r0, r0
	lv.all_eq.h	r31, r31, r31

positive: lv.all_ge.b instruction

	lv.all_ge.b	r0, r0, r0
	lv.all_ge.b	r31, r31, r31

positive: lv.all_ge.h instruction

	lv.all_ge.h	r0, r0, r0
	lv.all_ge.h	r31, r31, r31

positive: lv.all_gt.b instruction

	lv.all_gt.b	r0, r0, r0
	lv.all_gt.b	r31, r31, r31

positive: lv.all_gt.h instruction

	lv.all_gt.h	r0, r0, r0
	lv.all_gt.h	r31, r31, r31

positive: lv.all_le.b instruction

	lv.all_le.b	r0, r0, r0
	lv.all_le.b	r31, r31, r31

positive: lv.all_le.h instruction

	lv.all_le.h	r0, r0, r0
	lv.all_le.h	r31, r31, r31

positive: lv.all_lt.b instruction

	lv.all_lt.b	r0, r0, r0
	lv.all_lt.b	r31, r31, r31

positive: lv.all_lt.h instruction

	lv.all_lt.h	r0, r0, r0
	lv.all_lt.h	r31, r31, r31

positive: lv.all_ne.b instruction

	lv.all_ne.b	r0, r0, r0
	lv.all_ne.b	r31, r31, r31

positive: lv.all_ne.h instruction

	lv.all_ne.h	r0, r0, r0
	lv.all_ne.h	r31, r31, r31

positive: lv.and instruction

	lv.and	r0, r0, r0
	lv.and	r31, r31, r31

positive: lv.any_eq.b instruction

	lv.any_eq.b	r0, r0, r0
	lv.any_eq.b	r31, r31, r31

positive: lv.any_eq.h instruction

	lv.any_eq.h	r0, r0, r0
	lv.any_eq.h	r31, r31, r31

positive: lv.any_ge.b instruction

	lv.any_ge.b	r0, r0, r0
	lv.any_ge.b	r31, r31, r31

positive: lv.any_ge.h instruction

	lv.any_ge.h	r0, r0, r0
	lv.any_ge.h	r31, r31, r31

positive: lv.any_gt.b instruction

	lv.any_gt.b	r0, r0, r0
	lv.any_gt.b	r31, r31, r31

positive: lv.any_gt.h instruction

	lv.any_gt.h	r0, r0, r0
	lv.any_gt.h	r31, r31, r31

positive: lv.any_le.b instruction

	lv.any_le.b	r0, r0, r0
	lv.any_le.b	r31, r31, r31

positive: lv.any_le.h instruction

	lv.any_le.h	r0, r0, r0
	lv.any_le.h	r31, r31, r31

positive: lv.any_lt.b instruction

	lv.any_lt.b	r0, r0, r0
	lv.any_lt.b	r31, r31, r31

positive: lv.any_lt.h instruction

	lv.any_lt.h	r0, r0, r0
	lv.any_lt.h	r31, r31, r31

positive: lv.any_ne.b instruction

	lv.any_ne.b	r0, r0, r0
	lv.any_ne.b	r31, r31, r31

positive: lv.any_ne.h instruction

	lv.any_ne.h	r0, r0, r0
	lv.any_ne.h	r31, r31, r31

positive: lv.avg.b instruction

	lv.avg.b	r0, r0, r0
	lv.avg.b	r31, r31, r31

positive: lv.avg.h instruction

	lv.avg.h	r0, r0, r0
	lv.avg.h	r31, r31, r31

positive: lv.cmp_eq.b instruction

	lv.cmp_eq.b	r0, r0, r0
	lv.cmp_eq.b	r31, r31, r31

positive: lv.cmp_eq.h instruction

	lv.cmp_eq.h	r0, r0, r0
	lv.cmp_eq.h	r31, r31, r31

positive: lv.cmp_ge.b instruction

	lv.cmp_ge.b	r0, r0, r0
	lv.cmp_ge.b	r31, r31, r31

positive: lv.cmp_ge.h instruction

	lv.cmp_ge.h	r0, r0, r0
	lv.cmp_ge.h	r31, r31, r31

positive: lv.cmp_gt.b instruction

	lv.cmp_gt.b	r0, r0, r0
	lv.cmp_gt.b	r31, r31, r31

positive: lv.cmp_gt.h instruction

	lv.cmp_gt.h	r0, r0, r0
	lv.cmp_gt.h	r31, r31, r31

positive: lv.cmp_le.b instruction

	lv.cmp_le.b	r0, r0, r0
	lv.cmp_le.b	r31, r31, r31

positive: lv.cmp_le.h instruction

	lv.cmp_le.h	r0, r0, r0
	lv.cmp_le.h	r31, r31, r31

positive: lv.cmp_lt.b instruction

	lv.cmp_lt.b	r0, r0, r0
	lv.cmp_lt.b	r31, r31, r31

positive: lv.cmp_lt.h instruction

	lv.cmp_lt.h	r0, r0, r0
	lv.cmp_lt.h	r31, r31, r31

positive: lv.cmp_ne.b instruction

	lv.cmp_ne.b	r0, r0, r0
	lv.cmp_ne.b	r31, r31, r31

positive: lv.cmp_ne.h instruction

	lv.cmp_ne.h	r0, r0, r0
	lv.cmp_ne.h	r31, r31, r31

positive: lv.madds.h instruction

	lv.madds.h	r0, r0, r0
	lv.madds.h	r31, r31, r31

positive: lv.max.b instruction

	lv.max.b	r0, r0, r0
	lv.max.b	r31, r31, r31

positive: lv.max.h instruction

	lv.max.h	r0, r0, r0
	lv.max.h	r31, r31, r31

positive: lv.merge.b instruction

	lv.merge.b	r0, r0, r0
	lv.merge.b	r31, r31, r31

positive: lv.merge.h instruction

	lv.merge.h	r0, r0, r0
	lv.merge.h	r31, r31, r31

positive: lv.min.b instruction

	lv.min.b	r0, r0, r0
	lv.min.b	r31, r31, r31

positive: lv.min.h instruction

	lv.min.h	r0, r0, r0
	lv.min.h	r31, r31, r31

positive: lv.msubs.h instruction

	lv.msubs.h	r0, r0, r0
	lv.msubs.h	r31, r31, r31

positive: lv.muls.h instruction

	lv.muls.h	r0, r0, r0
	lv.muls.h	r31, r31, r31

positive: lv.nand instruction

	lv.nand	r0, r0, r0
	lv.nand	r31, r31, r31

positive: lv.nor instruction

	lv.nor	r0, r0, r0
	lv.nor	r31, r31, r31

positive: lv.or instruction

	lv.or	r0, r0, r0
	lv.or	r31, r31, r31

positive: lv.pack.b instruction

	lv.pack.b	r0, r0, r0
	lv.pack.b	r31, r31, r31

positive: lv.pack.h instruction

	lv.pack.h	r0, r0, r0
	lv.pack.h	r31, r31, r31

positive: lv.packs.b instruction

	lv.packs.b	r0, r0, r0
	lv.packs.b	r31, r31, r31

positive: lv.packs.h instruction

	lv.packs.h	r0, r0, r0
	lv.packs.h	r31, r31, r31

positive: lv.packus.b instruction

	lv.packus.b	r0, r0, r0
	lv.packus.b	r31, r31, r31

positive: lv.packus.h instruction

	lv.packus.h	r0, r0, r0
	lv.packus.h	r31, r31, r31

positive: lv.perm.n instruction

	lv.perm.n	r0, r0, r0
	lv.perm.n	r31, r31, r31

positive: lv.rl.b instruction

	lv.rl.b	r0, r0, r0
	lv.rl.b	r31, r31, r31

positive: lv.rl.h instruction

	lv.rl.h	r0, r0, r0
	lv.rl.h	r31, r31, r31

positive: lv.sll instruction

	lv.sll	r0, r0, r0
	lv.sll	r31, r31, r31

positive: lv.sll.b instruction

	lv.sll.b	r0, r0, r0
	lv.sll.b	r31, r31, r31

positive: lv.sll.h instruction

	lv.sll.h	r0, r0, r0
	lv.sll.h	r31, r31, r31

positive: lv.sra.b instruction

	lv.sra.b	r0, r0, r0
	lv.sra.b	r31, r31, r31

positive: lv.sra.h instruction

	lv.sra.h	r0, r0, r0
	lv.sra.h	r31, r31, r31

positive: lv.srl instruction

	lv.srl	r0, r0, r0
	lv.srl	r31, r31, r31

positive: lv.srl.b instruction

	lv.srl.b	r0, r0, r0
	lv.srl.b	r31, r31, r31

positive: lv.srl.h instruction

	lv.srl.h	r0, r0, r0
	lv.srl.h	r31, r31, r31

positive: lv.sub.b instruction

	lv.sub.b	r0, r0, r0
	lv.sub.b	r31, r31, r31

positive: lv.sub.h instruction

	lv.sub.h	r0, r0, r0
	lv.sub.h	r31, r31, r31

positive: lv.subs.b instruction

	lv.subs.b	r0, r0, r0
	lv.subs.b	r31, r31, r31

positive: lv.subs.h instruction

	lv.subs.h	r0, r0, r0
	lv.subs.h	r31, r31, r31

positive: lv.subu.b instruction

	lv.subu.b	r0, r0, r0
	lv.subu.b	r31, r31, r31

positive: lv.subu.h instruction

	lv.subu.h	r0, r0, r0
	lv.subu.h	r31, r31, r31

positive: lv.subus.b instruction

	lv.subus.b	r0, r0, r0
	lv.subus.b	r31, r31, r31

positive: lv.subus.h instruction

	lv.subus.h	r0, r0, r0
	lv.subus.h	r31, r31, r31

positive: lv.unpack.b instruction

	lv.unpack.b	r0, r0, r0
	lv.unpack.b	r31, r31, r31

positive: lv.unpack.h instruction

	lv.unpack.h	r0, r0, r0
	lv.unpack.h	r31, r31, r31

positive: lv.xor instruction

	lv.xor	r0, r0, r0
	lv.xor	r31, r31, r31

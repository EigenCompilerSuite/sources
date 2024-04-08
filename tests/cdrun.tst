# Intermediate code execution test and validation suite
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

negative: missing entry point

positive: calling _Exit success

	push	int 0
	call	fun @_Exit, 0

negative: calling _Exit failure

	push	int 1
	call	fun @_Exit, 0

negative: calling abort

	call	fun @abort, 0

# standard code sections

positive: standard code section as entry point

	push	int 0
	call	fun @_Exit, 0

positive: empty standard code section

	push	int 0
	call	fun @_Exit, 0
	.code test

negative: duplicated standard code section

	push	int 0
	call	fun @_Exit, 0
	.code test
	.code test

negative: duplicated single duplicable standard code section

	push	int 0
	call	fun @_Exit, 0
	.code test
	.code test
	.duplicable

positive: duplicated double duplicable standard code section

	push	int 0
	call	fun @_Exit, 0
	.code test
	.duplicable
	.code test
	.duplicable

negative: duplicated unequal standard code section

	push	int 0
	call	fun @_Exit, 0
	.code test
	.duplicable
	.code test
	.duplicable
	ret

positive: addressing self in standard code section

	mov	fun $0, fun @main
	push	int 0
	call	fun @_Exit, 0

positive: addressing standard code section in standard code section

	mov	fun $0, fun @section
	push	int 0
	call	fun @_Exit, 0
	.code section
	ret

positive: addressing standard data section in standard code section

	mov	ptr $0, ptr @section
	push	int 0
	call	fun @_Exit, 0
	.data section
	res	1

positive: addressing constant data section in standard code section

	mov	ptr $0, ptr @section
	push	int 0
	call	fun @_Exit, 0
	.const section
	res	1

negative: addressing unknown section in standard code section

	mov	ptr $0, ptr @section
	push	int 0
	call	fun @_Exit, 0

# standard data sections

negative: standard data section as entry point

	.data main

positive: empty standard data section

	push	int 0
	call	fun @_Exit, 0
	.data test

negative: duplicated standard data section

	push	int 0
	call	fun @_Exit, 0
	.data test
	.data test

negative: duplicated single duplicable standard data section

	push	int 0
	call	fun @_Exit, 0
	.data test
	.data test
	.duplicable

positive: duplicated double duplicable standard data section

	push	int 0
	call	fun @_Exit, 0
	.data test
	.duplicable
	.data test
	.duplicable

negative: duplicated unequal standard data section

	push	int 0
	call	fun @_Exit, 0
	.data test
	.duplicable
	.data test
	.duplicable
	res	1

positive: addressing self in standard data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.data test
	.alignment	ptrsize
	def	ptr @test

positive: addressing standard code section in standard data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.data test
	.alignment	funsize
	def	fun @section
	.code section
	ret

positive: addressing standard data section in standard data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.data test
	.alignment	ptrsize
	def	ptr @section
	.data section
	res	1

positive: addressing constant data section in standard data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.data test
	.alignment	ptrsize
	def	ptr @section
	.const section
	res	1

negative: addressing unknown section in standard data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.data test
	.alignment	ptrsize
	def	ptr @section

# constant data sections

negative: constant data section as entry point

	.const main

positive: empty constant data section

	push	int 0
	call	fun @_Exit, 0
	.const test

negative: duplicated constant data section

	push	int 0
	call	fun @_Exit, 0
	.const test
	.const test

negative: duplicated single duplicable constant data section

	push	int 0
	call	fun @_Exit, 0
	.const test
	.const test
	.duplicable

positive: duplicated double duplicable constant data section

	push	int 0
	call	fun @_Exit, 0
	.const test
	.duplicable
	.const test
	.duplicable

negative: duplicated unequal constant data section

	push	int 0
	call	fun @_Exit, 0
	.const test
	.duplicable
	.const test
	.duplicable
	res	1

positive: addressing self in constant data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.const test
	.alignment	ptrsize
	def	ptr @test

positive: addressing standard code section in constant data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.const test
	.alignment	funsize
	def	fun @section
	.code section
	ret

positive: addressing standard data section in constant data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.const test
	.alignment	ptrsize
	def	ptr @section
	.data section
	res	1

positive: addressing constant data section in constant data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.const test
	.alignment	ptrsize
	def	ptr @section
	.const section
	res	1

negative: addressing unknown section in constant data section

	mov	ptr $0, ptr @test
	push	int 0
	call	fun @_Exit, 0
	.const test
	.alignment	ptrsize
	def	ptr @section

# alias instruction

negative: alias name definition with equal section name

	alias	"main"
	push	int 0
	call	fun @_Exit, 0

negative: alias name definition with duplicated name

	alias	"alias"
	alias	"alias"
	push	int 0
	call	fun @_Exit, 0

positive: alias name definition with unique name

	brne	+1, ptr @alias, ptr @data + ptrsize
	breq	+1, ptr [@data], ptr @alias
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data data
	.alignment	ptrsize
	def	ptr @alias
	alias	"alias"

# req instruction

positive: name requirement with name of standard code section in standard code section

	req	"main"
	push	int 0
	call	fun @_Exit, 0

positive: name requirement with name of standard data section in standard code section

	req	"data"
	push	int 0
	call	fun @_Exit, 0
	.data data

negative: name requirement with name of unknown section in standard code section

	req	"section"
	push	int 0
	call	fun @_Exit, 0

positive: name requirement with name of standard code section in standard data section

	push	int 0
	call	fun @_Exit, 0
	.data data
	.required
	req	"main"

positive: name requirement with name of standard data section in standard data section

	push	int 0
	call	fun @_Exit, 0
	.data data
	.required
	req	"data"

negative: name requirement with name of unknown section in standard data section

	push	int 0
	call	fun @_Exit, 0
	.data data
	.required
	req	"section"

# def instruction

positive: s1 datum definition

	breq	+1, s1 [@data], s1 45
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	1
	def	s1 45

positive: s2 datum definition

	breq	+1, s2 [@data], s2 -7854
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	2
	def	s2 -7854

positive: s4 datum definition

	breq	+1, s4 [@data], s4 84315878
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	4
	def	s4 84315878

positive: s8 datum definition

	breq	+1, s8 [@data], s8 -4843132187874521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	8
	def	s8 -4843132187874521

positive: u1 datum definition

	breq	+1, u1 [@data], u1 182
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	1
	def	u1 182

positive: u2 datum definition

	breq	+1, u2 [@data], u2 45138
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	2
	def	u2 45138

positive: u4 datum definition

	breq	+1, u4 [@data], u4 3143547787
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	4
	def	u4 3143547787

positive: u8 datum definition

	breq	+1, u8 [@data], u8 7846131387468744874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	8
	def	u8 7846131387468744874

positive: f4 datum definition

	breq	+1, f4 [@data], f4 5.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	4
	def	f4 5.75

positive: f8 datum definition

	breq	+1, f8 [@data], f8 -12.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	8
	def	f8 -12.5

positive: ptr datum definition

	breq	+1, ptr [@data], ptr @data + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	ptrsize
	def	ptr @data + 79

positive: fun datum definition

	breq	+1, fun [@data], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	funsize
	def	fun @main

# res instruction

positive: space reservation

	brne	+1, u1 [@data], u1 196
	breq	+1, u1 [@data + 10], u1 215
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const data
	.alignment	1
	def	u1 196
	res	9
	def	u1 215

# mov instruction

positive: datum copy from s1 immediate to register

	mov	s1 $0, s1 -1
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from s2 immediate to register

	mov	s2 $0, s2 -1
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from s4 immediate to register

	mov	s4 $0, s4 -1
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from s8 immediate to register

	mov	s8 $0, s8 -1
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from u1 immediate to register

	mov	u1 $0, u1 0x01
	breq	+1, u1 $0, u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from u2 immediate to register

	mov	u2 $0, u2 0x0123
	breq	+1, u2 $0, u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from u4 immediate to register

	mov	u4 $0, u4 0x01234567
	breq	+1, u4 $0, u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from u8 immediate to register

	mov	u8 $0, u8 0x0123456789abcdef
	breq	+1, u8 $0, u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from f4 immediate to register

	mov	f4 $0, f4 0.25
	breq	+1, f4 $0, f4 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from f8 immediate to register

	mov	f8 $0, f8 0.25
	breq	+1, f8 $0, f8 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from ptr immediate to register

	mov	ptr $0, ptr 8
	mov	ptr $0, ptr @section + $0
	breq	+1, ptr $0, ptr @section + 8
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data section
	res	8

positive: datum copy from fun immediate to register

	mov	fun $0, fun @main
	breq	+1, fun $0, fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from s1 register to register

	mov	s1 $0, s1 -1
	mov	s1 $1, s1 $0
	brne	+1, s1 $1, s1 -1
	breq	+1, s1 $1, s1 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from s2 register to register

	mov	s2 $0, s2 -1
	mov	s2 $1, s2 $0
	brne	+1, s2 $1, s2 -1
	breq	+1, s2 $1, s2 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from s4 register to register

	mov	s4 $0, s4 -1
	mov	s4 $1, s4 $0
	brne	+1, s4 $1, s4 -1
	breq	+1, s4 $1, s4 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from s8 register to register

	mov	s8 $0, s8 -1
	mov	s8 $1, s8 $0
	brne	+1, s8 $1, s8 -1
	breq	+1, s8 $1, s8 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from u1 register to register

	mov	u1 $0, u1 0x01
	mov	u1 $1, u1 $0
	brne	+1, u1 $1, u1 0x01
	breq	+1, u1 $1, u1 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from u2 register to register

	mov	u2 $0, u2 0x0123
	mov	u2 $1, u2 $0
	brne	+1, u2 $1, u2 0x0123
	breq	+1, u2 $1, u2 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from u4 register to register

	mov	u4 $0, u4 0x01234567
	mov	u4 $1, u4 $0
	brne	+1, u4 $1, u4 0x01234567
	breq	+1, u4 $1, u4 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from u8 register to register

	mov	u8 $0, u8 0x0123456789abcdef
	mov	u8 $1, u8 $0
	brne	+1, u8 $1, u8 0x0123456789abcdef
	breq	+1, u8 $1, u8 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from f4 register to register

	mov	f4 $0, f4 0.25
	mov	f4 $1, f4 $0
	brne	+1, f4 $1, f4 0.25
	breq	+1, f4 $1, f4 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from f8 register to register

	mov	f8 $0, f8 0.25
	mov	f8 $1, f8 $0
	brne	+1, f8 $1, f8 0.25
	breq	+1, f8 $1, f8 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from ptr register to register

	mov	ptr $0, ptr 72
	mov	ptr $1, ptr $0
	brne	+1, ptr $1, ptr 72
	breq	+1, ptr $1, ptr $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from fun register to register

	mov	fun $0, fun @main
	mov	fun $1, fun $0
	brne	+1, fun $1, fun @main
	breq	+1, fun $1, fun $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum copy from s1 memory to register

	mov	s1 $0, s1 [@constant]
	breq	+1, s1 $0, s1 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum copy from s2 memory to register

	mov	s2 $0, s2 [@constant]
	breq	+1, s2 $0, s2 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum copy from s4 memory to register

	mov	s4 $0, s4 [@constant]
	breq	+1, s4 $0, s4 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum copy from s8 memory to register

	mov	s8 $0, s8 [@constant]
	breq	+1, s8 $0, s8 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum copy from u1 memory to register

	mov	u1 $0, u1 [@constant]
	breq	+1, u1 $0, u1 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01

positive: datum copy from u2 memory to register

	mov	u2 $0, u2 [@constant]
	breq	+1, u2 $0, u2 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123

positive: datum copy from u4 memory to register

	mov	u4 $0, u4 [@constant]
	breq	+1, u4 $0, u4 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567

positive: datum copy from u8 memory to register

	mov	u8 $0, u8 [@constant]
	breq	+1, u8 $0, u8 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef

positive: datum copy from f4 memory to register

	mov	f4 $0, f4 [@constant]
	breq	+1, f4 $0, f4 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 0.25

positive: datum copy from f8 memory to register

	mov	f8 $0, f8 [@constant]
	breq	+1, f8 $0, f8 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 0.25

positive: datum copy from ptr memory to register

	mov	ptr $0, ptr [@constant]
	breq	+1, ptr $0, ptr [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr @constant+2

positive: datum copy from fun memory to register

	mov	fun $0, fun [@constant]
	breq	+1, fun $0, fun [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun @main

positive: datum copy from s1 immediate to memory

	mov	s1 [@value], s1 -1
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum copy from s2 immediate to memory

	mov	s2 [@value], s2 -1
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum copy from s4 immediate to memory

	mov	s4 [@value], s4 -1
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum copy from s8 immediate to memory

	mov	s8 [@value], s8 -1
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum copy from u1 immediate to memory

	mov	u1 [@value], u1 0x01
	breq	+1, u1 [@value], u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum copy from u2 immediate to memory

	mov	u2 [@value], u2 0x0123
	breq	+1, u2 [@value], u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum copy from u4 immediate to memory

	mov	u4 [@value], u4 0x01234567
	breq	+1, u4 [@value], u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum copy from u8 immediate to memory

	mov	u8 [@value], u8 0x0123456789abcdef
	breq	+1, u8 [@value], u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum copy from f4 immediate to memory

	mov	f4 [@value], f4 0.25
	breq	+1, f4 [@value], f4 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum copy from f8 immediate to memory

	mov	f8 [@value], f8 0.25
	breq	+1, f8 [@value], f8 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum copy from ptr immediate to memory

	mov	ptr [@value], ptr @value+2
	breq	+1, ptr [@value], ptr @value+2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum copy from fun immediate to memory

	mov	fun [@value], fun @main
	breq	+1, fun [@value], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum copy from s1 register to memory

	mov	s1 $0, s1 -1
	mov	s1 [@value], s1 $0
	brne	+1, s1 [@value], s1 -1
	breq	+1, s1 [@value], s1 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum copy from s2 register to memory

	mov	s2 $0, s2 -1
	mov	s2 [@value], s2 $0
	brne	+1, s2 [@value], s2 -1
	breq	+1, s2 [@value], s2 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum copy from s4 register to memory

	mov	s4 $0, s4 -1
	mov	s4 [@value], s4 $0
	brne	+1, s4 [@value], s4 -1
	breq	+1, s4 [@value], s4 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum copy from s8 register to memory

	mov	s8 $0, s8 -1
	mov	s8 [@value], s8 $0
	brne	+1, s8 [@value], s8 -1
	breq	+1, s8 [@value], s8 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum copy from u1 register to memory

	mov	u1 $0, u1 0x01
	mov	u1 [@value], u1 $0
	brne	+1, u1 [@value], u1 0x01
	breq	+1, u1 [@value], u1 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum copy from u2 register to memory

	mov	u2 $0, u2 0x0123
	mov	u2 [@value], u2 $0
	brne	+1, u2 [@value], u2 0x0123
	breq	+1, u2 [@value], u2 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum copy from u4 register to memory

	mov	u4 $0, u4 0x01234567
	mov	u4 [@value], u4 $0
	brne	+1, u4 [@value], u4 0x01234567
	breq	+1, u4 [@value], u4 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum copy from u8 register to memory

	mov	u8 $0, u8 0x0123456789abcdef
	mov	u8 [@value], u8 $0
	brne	+1, u8 [@value], u8 0x0123456789abcdef
	breq	+1, u8 [@value], u8 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum copy from f4 register to memory

	mov	f4 $0, f4 0.25
	mov	f4 [@value], f4 $0
	brne	+1, f4 [@value], f4 0.25
	breq	+1, f4 [@value], f4 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum copy from f8 register to memory

	mov	f8 $0, f8 0.25
	mov	f8 [@value], f8 $0
	brne	+1, f8 [@value], f8 0.25
	breq	+1, f8 [@value], f8 $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum copy from ptr register to memory

	mov	ptr $0, ptr @value+2
	mov	ptr [@value], ptr $0
	brne	+1, ptr [@value], ptr @value+2
	breq	+1, ptr [@value], ptr $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum copy from fun register to memory

	mov	fun $0, fun @main
	mov	fun [@value], fun $0
	brne	+1, fun [@value], fun @main
	breq	+1, fun [@value], fun $0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum copy from s1 memory to memory

	mov	s1 [@value], s1 [@constant]
	breq	+1, s1 [@value], s1 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	1
	res	1

positive: datum copy from s2 memory to memory

	mov	s2 [@value], s2 [@constant]
	breq	+1, s2 [@value], s2 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	2
	res	2

positive: datum copy from s4 memory to memory

	mov	s4 [@value], s4 [@constant]
	breq	+1, s4 [@value], s4 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	4
	res	4

positive: datum copy from s8 memory to memory

	mov	s8 [@value], s8 [@constant]
	breq	+1, s8 [@value], s8 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	8
	res	8

positive: datum copy from u1 memory to memory

	mov	u1 [@value], u1 [@constant]
	breq	+1, u1 [@value], u1 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01
	.data value
	.alignment	1
	res	1

positive: datum copy from u2 memory to memory

	mov	u2 [@value], u2 [@constant]
	breq	+1, u2 [@value], u2 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123
	.data value
	.alignment	2
	res	2

positive: datum copy from u4 memory to memory

	mov	u4 [@value], u4 [@constant]
	breq	+1, u4 [@value], u4 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567
	.data value
	.alignment	4
	res	4

positive: datum copy from u8 memory to memory

	mov	u8 [@value], u8 [@constant]
	breq	+1, u8 [@value], u8 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef
	.data value
	.alignment	8
	res	8

positive: datum copy from f4 memory to memory

	mov	f4 [@value], f4 [@constant]
	breq	+1, f4 [@value], f4 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 0.25
	.data value
	.alignment	4
	res	4

positive: datum copy from f8 memory to memory

	mov	f8 [@value], f8 [@constant]
	breq	+1, f8 [@value], f8 [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 0.25
	.data value
	.alignment	8
	res	8

positive: datum copy from ptr memory to memory

	mov	ptr [@value], ptr [@constant]
	breq	+1, ptr [@value], ptr [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr @constant+2
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum copy from fun memory to memory

	mov	fun [@value], fun [@constant]
	breq	+1, fun [@value], fun [@constant]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun @main
	.data value
	.alignment	funsize
	res	funsize

# conv instruction

positive: datum conversion from s1 immediate to s1 register

	conv	s1 $0, s1 -1
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to s2 register

	conv	s2 $0, s1 -1
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to s4 register

	conv	s4 $0, s1 -1
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to s8 register

	conv	s8 $0, s1 -1
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to u1 register

	conv	u1 $0, s1 -1
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to u2 register

	conv	u2 $0, s1 -1
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to u4 register

	conv	u4 $0, s1 -1
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to u8 register

	conv	u8 $0, s1 -1
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to f4 register

	conv	f4 $0, s1 -1
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to f8 register

	conv	f8 $0, s1 -1
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to ptr register

	conv	ptr $0, s1 1
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 immediate to fun register

	conv	fun $0, s1 1
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to s1 register

	conv	s1 $0, s2 -1
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to s2 register

	conv	s2 $0, s2 -1
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to s4 register

	conv	s4 $0, s2 -1
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to s8 register

	conv	s8 $0, s2 -1
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to u1 register

	conv	u1 $0, s2 -1
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to u2 register

	conv	u2 $0, s2 -1
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to u4 register

	conv	u4 $0, s2 -1
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to u8 register

	conv	u8 $0, s2 -1
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to f4 register

	conv	f4 $0, s2 -1
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to f8 register

	conv	f8 $0, s2 -1
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to ptr register

	conv	ptr $0, s2 1
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 immediate to fun register

	conv	fun $0, s2 1
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to s1 register

	conv	s1 $0, s4 -1
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to s2 register

	conv	s2 $0, s4 -1
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to s4 register

	conv	s4 $0, s4 -1
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to s8 register

	conv	s8 $0, s4 -1
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to u1 register

	conv	u1 $0, s4 -1
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to u2 register

	conv	u2 $0, s4 -1
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to u4 register

	conv	u4 $0, s4 -1
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to u8 register

	conv	u8 $0, s4 -1
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to f4 register

	conv	f4 $0, s4 -1
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to f8 register

	conv	f8 $0, s4 -1
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to ptr register

	conv	ptr $0, s4 1
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 immediate to fun register

	conv	fun $0, s4 1
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to s1 register

	conv	s1 $0, s8 -1
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to s2 register

	conv	s2 $0, s8 -1
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to s4 register

	conv	s4 $0, s8 -1
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to s8 register

	conv	s8 $0, s8 -1
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to u1 register

	conv	u1 $0, s8 -1
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to u2 register

	conv	u2 $0, s8 -1
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to u4 register

	conv	u4 $0, s8 -1
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to u8 register

	conv	u8 $0, s8 -1
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to f4 register

	conv	f4 $0, s8 -1
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to f8 register

	conv	f8 $0, s8 -1
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to ptr register

	conv	ptr $0, s8 1
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 immediate to fun register

	conv	fun $0, s8 1
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to s1 register

	conv	s1 $0, u1 0xff
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to s2 register

	conv	s2 $0, u1 0xff
	breq	+1, s2 $0, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to s4 register

	conv	s4 $0, u1 0xff
	breq	+1, s4 $0, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to s8 register

	conv	s8 $0, u1 0xff
	breq	+1, s8 $0, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to u1 register

	conv	u1 $0, u1 0x01
	breq	+1, u1 $0, u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to u2 register

	conv	u2 $0, u1 0x01
	breq	+1, u2 $0, u2 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to u4 register

	conv	u4 $0, u1 0x01
	breq	+1, u4 $0, u4 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to u8 register

	conv	u8 $0, u1 0x01
	breq	+1, u8 $0, u8 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to f4 register

	conv	f4 $0, u1 0xff
	breq	+1, f4 $0, f4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to f8 register

	conv	f8 $0, u1 0xff
	breq	+1, f8 $0, f8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to ptr register

	conv	ptr $0, u1 0xff
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 immediate to fun register

	conv	fun $0, u1 0xff
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to s1 register

	conv	s1 $0, u2 0xffff
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to s2 register

	conv	s2 $0, u2 0xffff
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to s4 register

	conv	s4 $0, u2 0xffff
	breq	+1, s4 $0, s4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to s8 register

	conv	s8 $0, u2 0xffff
	breq	+1, s8 $0, s8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to u1 register

	conv	u1 $0, u2 0x0123
	breq	+1, u1 $0, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to u2 register

	conv	u2 $0, u2 0x0123
	breq	+1, u2 $0, u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to u4 register

	conv	u4 $0, u2 0x0123
	breq	+1, u4 $0, u4 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to u8 register

	conv	u8 $0, u2 0x0123
	breq	+1, u8 $0, u8 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to f4 register

	conv	f4 $0, u2 0xffff
	breq	+1, f4 $0, f4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to f8 register

	conv	f8 $0, u2 0xffff
	breq	+1, f8 $0, f8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to ptr register

	conv	ptr $0, u2 0xff
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 immediate to fun register

	conv	fun $0, u2 0xff
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to s1 register

	conv	s1 $0, u4 0xffffffff
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to s2 register

	conv	s2 $0, u4 0xffffffff
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to s4 register

	conv	s4 $0, u4 0xffffffff
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to s8 register

	conv	s8 $0, u4 0xffffffff
	breq	+1, s8 $0, s8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to u1 register

	conv	u1 $0, u4 0x01234567
	breq	+1, u1 $0, u1 0x67
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to u2 register

	conv	u2 $0, u4 0x01234567
	breq	+1, u2 $0, u2 0x4567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to u4 register

	conv	u4 $0, u4 0x01234567
	breq	+1, u4 $0, u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to u8 register

	conv	u8 $0, u4 0x01234567
	breq	+1, u8 $0, u8 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to f4 register

	conv	f4 $0, u4 0x000fffff
	breq	+1, f4 $0, f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to f8 register

	conv	f8 $0, u4 0xffffffff
	breq	+1, f8 $0, f8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to ptr register

	conv	ptr $0, u4 0x12
	breq	+1, ptr $0, ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 immediate to fun register

	conv	fun $0, u4 0x12
	breq	+1, fun $0, fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to s1 register

	conv	s1 $0, u8 0xffffffffffffffff
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to s2 register

	conv	s2 $0, u8 0xffffffffffffffff
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to s4 register

	conv	s4 $0, u8 0xffffffffffffffff
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to s8 register

	conv	s8 $0, u8 0xffffffffffffffff
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to u1 register

	conv	u1 $0, u8 0x0123456789abcdef
	breq	+1, u1 $0, u1 0xef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to u2 register

	conv	u2 $0, u8 0x0123456789abcdef
	breq	+1, u2 $0, u2 0xcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to u4 register

	conv	u4 $0, u8 0x0123456789abcdef
	breq	+1, u4 $0, u4 0x89abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to u8 register

	conv	u8 $0, u8 0x0123456789abcdef
	breq	+1, u8 $0, u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to f4 register

	conv	f4 $0, u8 0x00000000000fffff
	breq	+1, f4 $0, f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to f8 register

	conv	f8 $0, u8 0x000fffffffffffff
	breq	+1, f8 $0, f8 4503599627370495
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to ptr register

	conv	ptr $0, u8 0x85
	breq	+1, ptr $0, ptr 0x85
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 immediate to fun register

	conv	fun $0, u8 0x54
	breq	+1, fun $0, fun 0x54
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to s1 register

	conv	s1 $0, f4 -1.25
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to s2 register

	conv	s2 $0, f4 -1.25
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to s4 register

	conv	s4 $0, f4 -1.25
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to s8 register

	conv	s8 $0, f4 -1.25
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to u1 register

	conv	u1 $0, f4 -1.25
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to u2 register

	conv	u2 $0, f4 -1.25
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to u4 register

	conv	u4 $0, f4 -1.25
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to u8 register

	conv	u8 $0, f4 -1.25
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to f4 register

	conv	f4 $0, f4 -1.25
	breq	+1, f4 $0, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 immediate to f8 register

	conv	f8 $0, f4 -1.25
	breq	+1, f8 $0, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to s1 register

	conv	s1 $0, f8 -1.25
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to s2 register

	conv	s2 $0, f8 -1.25
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to s4 register

	conv	s4 $0, f8 -1.25
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to s8 register

	conv	s8 $0, f8 -1.25
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to u1 register

	conv	u1 $0, f8 -1.25
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to u2 register

	conv	u2 $0, f8 -1.25
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to u4 register

	conv	u4 $0, f8 -1.25
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to u8 register

	conv	u8 $0, f8 -1.25
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to f4 register

	conv	f4 $0, f8 -1.25
	breq	+1, f4 $0, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 immediate to f8 register

	conv	f8 $0, f8 -1.25
	breq	+1, f8 $0, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to s1 register

	conv	s1 $0, ptr 0xff
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to s2 register

	conv	s2 $0, ptr 0xff
	breq	+1, s2 $0, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to s4 register

	conv	s4 $0, ptr 0xff
	breq	+1, s4 $0, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to s8 register

	conv	s8 $0, ptr 0xff
	breq	+1, s8 $0, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to u1 register

	conv	u1 $0, ptr 0x23
	breq	+1, u1 $0, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to u2 register

	conv	u2 $0, ptr 0x23
	breq	+1, u2 $0, u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to u4 register

	conv	u4 $0, ptr 0x23
	breq	+1, u4 $0, u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to u8 register

	conv	u8 $0, ptr 0x23
	breq	+1, u8 $0, u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to ptr register

	conv	ptr $0, ptr 0xff
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr immediate to fun register

	conv	fun $0, ptr 0xff
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to s1 register

	conv	s1 $0, fun 0xff
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to s2 register

	conv	s2 $0, fun 0xff
	breq	+1, s2 $0, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to s4 register

	conv	s4 $0, fun 0xff
	breq	+1, s4 $0, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to s8 register

	conv	s8 $0, fun 0xff
	breq	+1, s8 $0, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to u1 register

	conv	u1 $0, ptr 0x23
	breq	+1, u1 $0, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to u2 register

	conv	u2 $0, ptr 0x23
	breq	+1, u2 $0, u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to u4 register

	conv	u4 $0, ptr 0x23
	breq	+1, u4 $0, u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to u8 register

	conv	u8 $0, ptr 0x23
	breq	+1, u8 $0, u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to ptr register

	conv	ptr $0, fun 0x42
	breq	+1, ptr $0, ptr 0x42
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun immediate to fun register

	conv	fun $0, fun 0xff
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to s1 register

	mov	s1 $0, s1 -1
	conv	s1 $1, s1 $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to s2 register

	mov	s1 $0, s1 -1
	conv	s2 $1, s1 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to s4 register

	mov	s1 $0, s1 -1
	conv	s4 $1, s1 $0
	breq	+1, s4 $1, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to s8 register

	mov	s1 $0, s1 -1
	conv	s8 $1, s1 $0
	breq	+1, s8 $1, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to u1 register

	mov	s1 $0, s1 -1
	conv	u1 $1, s1 $0
	breq	+1, u1 $1, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to u2 register

	mov	s1 $0, s1 -1
	conv	u2 $1, s1 $0
	breq	+1, u2 $1, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to u4 register

	mov	s1 $0, s1 -1
	conv	u4 $1, s1 $0
	breq	+1, u4 $1, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to u8 register

	mov	s1 $0, s1 -1
	conv	u8 $1, s1 $0
	breq	+1, u8 $1, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to f4 register

	mov	s1 $0, s1 -1
	conv	f4 $1, s1 $0
	breq	+1, f4 $1, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to f8 register

	mov	s1 $0, s1 -1
	conv	f8 $1, s1 $0
	breq	+1, f8 $1, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to ptr register

	mov	s1 $0, s1 1
	conv	ptr $1, s1 $0
	breq	+1, ptr $1, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to fun register

	mov	s1 $0, s1 1
	conv	fun $1, s1 $0
	breq	+1, fun $1, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to s1 register

	mov	s2 $0, s2 -1
	conv	s1 $1, s2 $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to s2 register

	mov	s2 $0, s2 -1
	conv	s2 $1, s2 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to s4 register

	mov	s2 $0, s2 -1
	conv	s4 $1, s2 $0
	breq	+1, s4 $1, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to s8 register

	mov	s2 $0, s2 -1
	conv	s8 $1, s2 $0
	breq	+1, s8 $1, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to u1 register

	mov	s2 $0, s2 -1
	conv	u1 $1, s2 $0
	breq	+1, u1 $1, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to u2 register

	mov	s2 $0, s2 -1
	conv	u2 $1, s2 $0
	breq	+1, u2 $1, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to u4 register

	mov	s2 $0, s2 -1
	conv	u4 $1, s2 $0
	breq	+1, u4 $1, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to u8 register

	mov	s2 $0, s2 -1
	conv	u8 $1, s2 $0
	breq	+1, u8 $1, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to f4 register

	mov	s2 $0, s2 -1
	conv	f4 $1, s2 $0
	breq	+1, f4 $1, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to f8 register

	mov	s2 $0, s2 -1
	conv	f8 $1, s2 $0
	breq	+1, f8 $1, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to ptr register

	mov	s2 $0, s2 1
	conv	ptr $1, s2 $0
	breq	+1, ptr $1, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to fun register

	mov	s2 $0, s2 1
	conv	fun $1, s2 $0
	breq	+1, fun $1, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to s1 register

	mov	s4 $0, s4 -1
	conv	s1 $1, s4 -1
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to s2 register

	mov	s4 $0, s4 -1
	conv	s2 $1, s4 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to s4 register

	mov	s4 $0, s4 -1
	conv	s4 $1, s4 $0
	breq	+1, s4 $1, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to s8 register

	mov	s4 $0, s4 -1
	conv	s8 $1, s4 $0
	breq	+1, s8 $1, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to u1 register

	mov	s4 $0, s4 -1
	conv	u1 $1, s4 $0
	breq	+1, u1 $1, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to u2 register

	mov	s4 $0, s4 -1
	conv	u2 $1, s4 $0
	breq	+1, u2 $1, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to u4 register

	mov	s4 $0, s4 -1
	conv	u4 $1, s4 $0
	breq	+1, u4 $1, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to u8 register

	mov	s4 $0, s4 -1
	conv	u8 $1, s4 $0
	breq	+1, u8 $1, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to f4 register

	mov	s4 $0, s4 -1
	conv	f4 $1, s4 $0
	breq	+1, f4 $1, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to f8 register

	mov	s4 $0, s4 -1
	conv	f8 $1, s4 $0
	breq	+1, f8 $1, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to ptr register

	mov	s4 $0, s4 1
	conv	ptr $1, s4 $0
	breq	+1, ptr $1, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to fun register

	mov	s4 $0, s4 1
	conv	fun $1, s4 $0
	breq	+1, fun $1, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to s1 register

	mov	s8 $0, s8 -1
	conv	s1 $1, s8 $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to s2 register

	mov	s8 $0, s8 -1
	conv	s2 $1, s8 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to s4 register

	mov	s8 $0, s8 -1
	conv	s4 $1, s8 $0
	breq	+1, s4 $1, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to s8 register

	mov	s8 $0, s8 -1
	conv	s8 $1, s8 $0
	breq	+1, s8 $1, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to u1 register

	mov	s8 $0, s8 -1
	conv	u1 $1, s8 $0
	breq	+1, u1 $1, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to u2 register

	mov	s8 $0, s8 -1
	conv	u2 $1, s8 $0
	breq	+1, u2 $1, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to u4 register

	mov	s8 $0, s8 -1
	conv	u4 $1, s8 $0
	breq	+1, u4 $1, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to u8 register

	mov	s8 $0, s8 -1
	conv	u8 $1, s8 $0
	breq	+1, u8 $1, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to f4 register

	mov	s8 $0, s8 -1
	conv	f4 $1, s8 $0
	breq	+1, f4 $1, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to f8 register

	mov	s8 $0, s8 -1
	conv	f8 $1, s8 $0
	breq	+1, f8 $1, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to ptr register

	mov	s8 $0, s8 1
	conv	ptr $1, s8 $0
	breq	+1, ptr $1, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to fun register

	mov	s8 $0, s8 1
	conv	fun $1, s8 $0
	breq	+1, fun $1, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to s1 register

	conv	s1 $1, u1 0xff
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to s2 register

	mov	u1 $0, u1 0xff
	conv	s2 $1, u1 $0
	breq	+1, s2 $1, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to s4 register

	mov	u1 $0, u1 0xff
	conv	s4 $1, u1 $0
	breq	+1, s4 $1, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to s8 register

	mov	u1 $0, u1 0xff
	conv	s8 $1, u1 $0
	breq	+1, s8 $1, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to u1 register

	mov	u1 $0, u1 0x01
	conv	u1 $1, u1 $0
	breq	+1, u1 $1, u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to u2 register

	mov	u1 $0, u1 0x01
	conv	u2 $1, u1 $0
	breq	+1, u2 $1, u2 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to u4 register

	mov	u1 $0, u1 0x01
	conv	u4 $1, u1 $0
	breq	+1, u4 $1, u4 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to u8 register

	mov	u1 $0, u1 0x01
	conv	u8 $1, u1 $0
	breq	+1, u8 $1, u8 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to f4 register

	mov	u1 $0, u1 0xff
	conv	f4 $1, u1 $0
	breq	+1, f4 $1, f4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to f8 register

	mov	u1 $0, u1 0xff
	conv	f8 $1, u1 $0
	breq	+1, f8 $1, f8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to ptr register

	mov	u1 $0, u1 0xff
	conv	ptr $1, u1 $0
	breq	+1, ptr $1, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to fun register

	mov	u1 $0, u1 0xff
	conv	fun $1, u1 $0
	breq	+1, fun $1, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to s1 register

	mov	u2 $0, u2 0xffff
	conv	s1 $1, u2 $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to s2 register

	mov	u2 $0, u2 0xffff
	conv	s2 $1, u2 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to s4 register

	mov	u2 $0, u2 0xffff
	conv	s4 $1, u2 $0
	breq	+1, s4 $1, s4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to s8 register

	mov	u2 $0, u2 0xffff
	conv	s8 $1, u2 $0
	breq	+1, s8 $1, s8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to u1 register

	mov	u2 $0, u2 0x0123
	conv	u1 $1, u2 $0
	breq	+1, u1 $1, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to u2 register

	mov	u2 $0, u2 0x0123
	conv	u2 $1, u2 $0
	breq	+1, u2 $1, u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to u4 register

	mov	u2 $0, u2 0x0123
	conv	u4 $1, u2 $0
	breq	+1, u4 $1, u4 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to u8 register

	mov	u2 $0, u2 0x0123
	conv	u8 $1, u2 $0
	breq	+1, u8 $1, u8 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to f4 register

	mov	u2 $0, u2 0xffff
	conv	f4 $1, u2 $0
	breq	+1, f4 $1, f4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to f8 register

	mov	u2 $0, u2 0xffff
	conv	f8 $1, u2 $0
	breq	+1, f8 $1, f8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to ptr register

	mov	u2 $0, u2 0xff
	conv	ptr $1, u2 $0
	breq	+1, ptr $1, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to fun register

	mov	u2 $0, u2 0xff
	conv	fun $1, u2 $0
	breq	+1, fun $1, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to s1 register

	mov	u4 $0, u4 0xffffffff
	conv	s1 $1, u4 $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to s2 register

	mov	u4 $0, u4 0xffffffff
	conv	s2 $1, u4 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to s4 register

	mov	u4 $0, u4 0xffffffff
	conv	s4 $1, u4 $0
	breq	+1, s4 $1, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to s8 register

	mov	u4 $0, u4 0xffffffff
	conv	s8 $1, u4 $0
	breq	+1, s8 $1, s8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to u1 register

	mov	u4 $0, u4 0x01234567
	conv	u1 $1, u4 $0
	breq	+1, u1 $1, u1 0x67
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to u2 register

	mov	u4 $0, u4 0x01234567
	conv	u2 $1, u4 $0
	breq	+1, u2 $1, u2 0x4567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to u4 register

	mov	u4 $0, u4 0x01234567
	conv	u4 $1, u4 $0
	breq	+1, u4 $1, u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to u8 register

	mov	u4 $0, u4 0x01234567
	conv	u8 $1, u4 $0
	breq	+1, u8 $1, u8 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to f4 register

	mov	u4 $0, u4 0x000fffff
	conv	f4 $1, u4 $0
	breq	+1, f4 $1, f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to f8 register

	mov	u4 $0, u4 0xffffffff
	conv	f8 $1, u4 $0
	breq	+1, f8 $1, f8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to ptr register

	mov	u4 $0, u4 0x12
	conv	ptr $1, u4 $0
	breq	+1, ptr $1, ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to fun register

	mov	u4 $0, u4 0x12
	conv	fun $1, u4 $0
	breq	+1, fun $1, fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to s1 register

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s1 $1, u8 $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to s2 register

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s2 $1, u8 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to s4 register

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s4 $1, u8 $0
	breq	+1, s4 $1, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to s8 register

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s8 $1, u8 $0
	breq	+1, s8 $1, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to u1 register

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u1 $1, u8 $0
	breq	+1, u1 $1, u1 0xef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to u2 register

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u2 $1, u8 $0
	breq	+1, u2 $1, u2 0xcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to u4 register

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u4 $1, u8 $0
	breq	+1, u4 $1, u4 0x89abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to u8 register

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u8 $1, u8 $0
	breq	+1, u8 $1, u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to f4 register

	mov	u8 $0, u8 0x00000000000fffff
	conv	f4 $1, u8 $0
	breq	+1, f4 $1, f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to f8 register

	mov	u8 $0, u8 0x000fffffffffffff
	conv	f8 $1, u8 $0
	breq	+1, f8 $1, f8 4503599627370495
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to ptr register

	mov	u8 $0, u8 0x12
	conv	ptr $1, u8 $0
	breq	+1, ptr $1, ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to fun register

	mov	u8 $0, u8 0x12
	conv	fun $1, u8 $0
	breq	+1, fun $1, fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to s1 register

	mov	f4 $0, f4 -1.25
	conv	s1 $1, f4 $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to s2 register

	mov	f4 $0, f4 -1.25
	conv	s2 $1, f4 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to s4 register

	mov	f4 $0, f4 -1.25
	conv	s4 $1, f4 $0
	breq	+1, s4 $1, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to s8 register

	mov	f4 $0, f4 -1.25
	conv	s8 $1, f4 $0
	breq	+1, s8 $1, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to u1 register

	mov	f4 $0, f4 -1.25
	conv	u1 $1, f4 $0
	breq	+1, u1 $1, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to u2 register

	mov	f4 $0, f4 -1.25
	conv	u2 $1, f4 $0
	breq	+1, u2 $1, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to u4 register

	mov	f4 $0, f4 -1.25
	conv	u4 $1, f4 $0
	breq	+1, u4 $1, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to u8 register

	mov	f4 $0, f4 -1.25
	conv	u8 $1, f4 $0
	breq	+1, u8 $1, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to f4 register

	mov	f4 $0, f4 -1.25
	conv	f4 $1, f4 $0
	breq	+1, f4 $1, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to f8 register

	mov	f4 $0, f4 -1.25
	conv	f8 $1, f4 $0
	breq	+1, f8 $1, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to s1 register

	mov	f8 $0, f8 -1.25
	conv	s1 $1, f8 $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to s2 register

	mov	f8 $0, f8 -1.25
	conv	s2 $1, f8 $0
	breq	+1, s2 $1, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to s4 register

	mov	f8 $0, f8 -1.25
	conv	s4 $1, f8 $0
	breq	+1, s4 $1, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to s8 register

	mov	f8 $0, f8 -1.25
	conv	s8 $1, f8 $0
	breq	+1, s8 $1, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to u1 register

	mov	f8 $0, f8 -1.25
	conv	u1 $1, f8 $0
	breq	+1, u1 $1, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to u2 register

	mov	f8 $0, f8 -1.25
	conv	u2 $1, f8 $0
	breq	+1, u2 $1, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to u4 register

	mov	f8 $0, f8 -1.25
	conv	u4 $1, f8 $0
	breq	+1, u4 $1, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to u8 register

	mov	f8 $0, f8 -1.25
	conv	u8 $1, f8 $0
	breq	+1, u8 $1, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to f4 register

	mov	f8 $0, f8 -1.25
	conv	f4 $1, f8 $0
	breq	+1, f4 $1, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to f8 register

	mov	f8 $0, f8 -1.25
	conv	f8 $1, f8 $0
	breq	+1, f8 $1, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to s1 register

	mov	ptr $0, ptr 0xff
	conv	s1 $1, ptr $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to s2 register

	mov	ptr $0, ptr 0xff
	conv	s2 $1, ptr $0
	breq	+1, s2 $1, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to s4 register

	mov	ptr $0, ptr 0xff
	conv	s4 $1, ptr $0
	breq	+1, s4 $1, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to s8 register

	mov	ptr $0, ptr 0xff
	conv	s8 $1, ptr $0
	breq	+1, s8 $1, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to u1 register

	mov	ptr $0, ptr 0x23
	conv	u1 $1, ptr $0
	breq	+1, u1 $1, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to u2 register

	mov	ptr $0, ptr 0x23
	conv	u2 $1, ptr $0
	breq	+1, u2 $1, u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to u4 register

	mov	ptr $0, ptr 0x23
	conv	u4 $1, ptr $0
	breq	+1, u4 $1, u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to u8 register

	mov	ptr $0, ptr 0x23
	conv	u8 $1, ptr $0
	breq	+1, u8 $1, u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to ptr register

	mov	ptr $0, ptr 0xff
	conv	ptr $1, ptr $0
	breq	+1, ptr $1, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to fun register

	mov	ptr $0, ptr 0xff
	conv	fun $1, ptr $0
	breq	+1, fun $1, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to s1 register

	mov	fun $0, fun 0xff
	conv	s1 $1, fun $0
	breq	+1, s1 $1, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to s2 register

	mov	fun $0, fun 0xff
	conv	s2 $1, fun $0
	breq	+1, s2 $1, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to s4 register

	mov	fun $0, fun 0xff
	conv	s4 $1, fun $0
	breq	+1, s4 $1, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to s8 register

	mov	fun $0, fun 0xff
	conv	s8 $1, fun $0
	breq	+1, s8 $1, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to u1 register

	mov	fun $0, fun 0x23
	conv	u1 $1, fun $0
	breq	+1, u1 $1, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to u2 register

	mov	fun $0, fun 0x23
	conv	u2 $1, fun $0
	breq	+1, u2 $1, u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to u4 register

	mov	fun $0, fun 0x23
	conv	u4 $1, fun $0
	breq	+1, u4 $1, u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to u8 register

	mov	fun $0, fun 0x23
	conv	u8 $1, fun $0
	breq	+1, u8 $1, u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to ptr register

	mov	fun $0, fun 0xff
	conv	ptr $1, fun $0
	breq	+1, ptr $1, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to fun register

	mov	fun $0, fun 0xff
	conv	fun $1, fun $0
	breq	+1, fun $1, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same s1 register

	mov	s1 $0, s1 -1
	conv	s1 $0, s1 $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same s2 register

	mov	s1 $0, s1 -1
	conv	s2 $0, s1 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same s4 register

	mov	s1 $0, s1 -1
	conv	s4 $0, s1 $0
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same s8 register

	mov	s1 $0, s1 -1
	conv	s8 $0, s1 $0
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same u1 register

	mov	s1 $0, s1 -1
	conv	u1 $0, s1 $0
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same u2 register

	mov	s1 $0, s1 -1
	conv	u2 $0, s1 $0
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same u4 register

	mov	s1 $0, s1 -1
	conv	u4 $0, s1 $0
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same u8 register

	mov	s1 $0, s1 -1
	conv	u8 $0, s1 $0
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same f4 register

	mov	s1 $0, s1 -1
	conv	f4 $0, s1 $0
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same f8 register

	mov	s1 $0, s1 -1
	conv	f8 $0, s1 $0
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same ptr register

	mov	s1 $0, s1 1
	conv	ptr $0, s1 $0
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 register to same fun register

	mov	s1 $0, s1 1
	conv	fun $0, s1 $0
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same s1 register

	mov	s2 $0, s2 -1
	conv	s1 $0, s2 $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same s2 register

	mov	s2 $0, s2 -1
	conv	s2 $0, s2 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same s4 register

	mov	s2 $0, s2 -1
	conv	s4 $0, s2 $0
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same s8 register

	mov	s2 $0, s2 -1
	conv	s8 $0, s2 $0
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same u1 register

	mov	s2 $0, s2 -1
	conv	u1 $0, s2 $0
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same u2 register

	mov	s2 $0, s2 -1
	conv	u2 $0, s2 $0
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same u4 register

	mov	s2 $0, s2 -1
	conv	u4 $0, s2 $0
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same u8 register

	mov	s2 $0, s2 -1
	conv	u8 $0, s2 $0
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same f4 register

	mov	s2 $0, s2 -1
	conv	f4 $0, s2 $0
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same f8 register

	mov	s2 $0, s2 -1
	conv	f8 $0, s2 $0
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same ptr register

	mov	s2 $0, s2 1
	conv	ptr $0, s2 $0
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s2 register to same fun register

	mov	s2 $0, s2 1
	conv	fun $0, s2 $0
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same s1 register

	mov	s4 $0, s4 -1
	conv	s1 $0, s4 -1
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same s2 register

	mov	s4 $0, s4 -1
	conv	s2 $0, s4 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same s4 register

	mov	s4 $0, s4 -1
	conv	s4 $0, s4 $0
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same s8 register

	mov	s4 $0, s4 -1
	conv	s8 $0, s4 $0
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same u1 register

	mov	s4 $0, s4 -1
	conv	u1 $0, s4 $0
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same u2 register

	mov	s4 $0, s4 -1
	conv	u2 $0, s4 $0
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same u4 register

	mov	s4 $0, s4 -1
	conv	u4 $0, s4 $0
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same u8 register

	mov	s4 $0, s4 -1
	conv	u8 $0, s4 $0
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same f4 register

	mov	s4 $0, s4 -1
	conv	f4 $0, s4 $0
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same f8 register

	mov	s4 $0, s4 -1
	conv	f8 $0, s4 $0
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same ptr register

	mov	s4 $0, s4 1
	conv	ptr $0, s4 $0
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s4 register to same fun register

	mov	s4 $0, s4 1
	conv	fun $0, s4 $0
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same s1 register

	mov	s8 $0, s8 -1
	conv	s1 $0, s8 $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same s2 register

	mov	s8 $0, s8 -1
	conv	s2 $0, s8 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same s4 register

	mov	s8 $0, s8 -1
	conv	s4 $0, s8 $0
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same s8 register

	mov	s8 $0, s8 -1
	conv	s8 $0, s8 $0
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same u1 register

	mov	s8 $0, s8 -1
	conv	u1 $0, s8 $0
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same u2 register

	mov	s8 $0, s8 -1
	conv	u2 $0, s8 $0
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same u4 register

	mov	s8 $0, s8 -1
	conv	u4 $0, s8 $0
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same u8 register

	mov	s8 $0, s8 -1
	conv	u8 $0, s8 $0
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same f4 register

	mov	s8 $0, s8 -1
	conv	f4 $0, s8 $0
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same f8 register

	mov	s8 $0, s8 -1
	conv	f8 $0, s8 $0
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same ptr register

	mov	s8 $0, s8 1
	conv	ptr $0, s8 $0
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s8 register to same fun register

	mov	s8 $0, s8 1
	conv	fun $0, s8 $0
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same s1 register

	conv	s1 $0, u1 0xff
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same s2 register

	mov	u1 $0, u1 0xff
	conv	s2 $0, u1 $0
	breq	+1, s2 $0, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same s4 register

	mov	u1 $0, u1 0xff
	conv	s4 $0, u1 $0
	breq	+1, s4 $0, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same s8 register

	mov	u1 $0, u1 0xff
	conv	s8 $0, u1 $0
	breq	+1, s8 $0, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same u1 register

	mov	u1 $0, u1 0x01
	conv	u1 $0, u1 $0
	breq	+1, u1 $0, u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same u2 register

	mov	u1 $0, u1 0x01
	conv	u2 $0, u1 $0
	breq	+1, u2 $0, u2 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same u4 register

	mov	u1 $0, u1 0x01
	conv	u4 $0, u1 $0
	breq	+1, u4 $0, u4 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same u8 register

	mov	u1 $0, u1 0x01
	conv	u8 $0, u1 $0
	breq	+1, u8 $0, u8 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same f4 register

	mov	u1 $0, u1 0xff
	conv	f4 $0, u1 $0
	breq	+1, f4 $0, f4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same f8 register

	mov	u1 $0, u1 0xff
	conv	f8 $0, u1 $0
	breq	+1, f8 $0, f8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same ptr register

	mov	u1 $0, u1 0xff
	conv	ptr $0, u1 $0
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u1 register to same fun register

	mov	u1 $0, u1 0xff
	conv	fun $0, u1 $0
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same s1 register

	mov	u2 $0, u2 0xffff
	conv	s1 $0, u2 $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same s2 register

	mov	u2 $0, u2 0xffff
	conv	s2 $0, u2 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same s4 register

	mov	u2 $0, u2 0xffff
	conv	s4 $0, u2 $0
	breq	+1, s4 $0, s4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same s8 register

	mov	u2 $0, u2 0xffff
	conv	s8 $0, u2 $0
	breq	+1, s8 $0, s8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same u1 register

	mov	u2 $0, u2 0x0123
	conv	u1 $0, u2 $0
	breq	+1, u1 $0, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same u2 register

	mov	u2 $0, u2 0x0123
	conv	u2 $0, u2 $0
	breq	+1, u2 $0, u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same u4 register

	mov	u2 $0, u2 0x0123
	conv	u4 $0, u2 $0
	breq	+1, u4 $0, u4 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same u8 register

	mov	u2 $0, u2 0x0123
	conv	u8 $0, u2 $0
	breq	+1, u8 $0, u8 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same f4 register

	mov	u2 $0, u2 0xffff
	conv	f4 $0, u2 $0
	breq	+1, f4 $0, f4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same f8 register

	mov	u2 $0, u2 0xffff
	conv	f8 $0, u2 $0
	breq	+1, f8 $0, f8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same ptr register

	mov	u2 $0, u2 0xff
	conv	ptr $0, u2 $0
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u2 register to same fun register

	mov	u2 $0, u2 0xff
	conv	fun $0, u2 $0
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same s1 register

	mov	u4 $0, u4 0xffffffff
	conv	s1 $0, u4 $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same s2 register

	mov	u4 $0, u4 0xffffffff
	conv	s2 $0, u4 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same s4 register

	mov	u4 $0, u4 0xffffffff
	conv	s4 $0, u4 $0
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same s8 register

	mov	u4 $0, u4 0xffffffff
	conv	s8 $0, u4 $0
	breq	+1, s8 $0, s8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same u1 register

	mov	u4 $0, u4 0x01234567
	conv	u1 $0, u4 $0
	breq	+1, u1 $0, u1 0x67
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same u2 register

	mov	u4 $0, u4 0x01234567
	conv	u2 $0, u4 $0
	breq	+1, u2 $0, u2 0x4567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same u4 register

	mov	u4 $0, u4 0x01234567
	conv	u4 $0, u4 $0
	breq	+1, u4 $0, u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same u8 register

	mov	u4 $0, u4 0x01234567
	conv	u8 $0, u4 $0
	breq	+1, u8 $0, u8 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same f4 register

	mov	u4 $0, u4 0x000fffff
	conv	f4 $0, u4 $0
	breq	+1, f4 $0, f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same f8 register

	mov	u4 $0, u4 0xffffffff
	conv	f8 $0, u4 $0
	breq	+1, f8 $0, f8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same ptr register

	mov	u4 $0, u4 0x12
	conv	ptr $0, u4 $0
	breq	+1, ptr $0, ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u4 register to same fun register

	mov	u4 $0, u4 0x12
	conv	fun $0, u4 $0
	breq	+1, fun $0, fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same s1 register

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s1 $0, u8 $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same s2 register

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s2 $0, u8 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same s4 register

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s4 $0, u8 $0
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same s8 register

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s8 $0, u8 $0
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same u1 register

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u1 $0, u8 $0
	breq	+1, u1 $0, u1 0xef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same u2 register

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u2 $0, u8 $0
	breq	+1, u2 $0, u2 0xcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same u4 register

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u4 $0, u8 $0
	breq	+1, u4 $0, u4 0x89abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same u8 register

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u8 $0, u8 $0
	breq	+1, u8 $0, u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same f4 register

	mov	u8 $0, u8 0x00000000000fffff
	conv	f4 $0, u8 $0
	breq	+1, f4 $0, f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same f8 register

	mov	u8 $0, u8 0x000fffffffffffff
	conv	f8 $0, u8 $0
	breq	+1, f8 $0, f8 4503599627370495
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same ptr register

	mov	u8 $0, u8 0x12
	conv	ptr $0, u8 $0
	breq	+1, ptr $0, ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from u8 register to same fun register

	mov	u8 $0, u8 0x12
	conv	fun $0, u8 $0
	breq	+1, fun $0, fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same s1 register

	mov	f4 $0, f4 -1.25
	conv	s1 $0, f4 $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same s2 register

	mov	f4 $0, f4 -1.25
	conv	s2 $0, f4 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same s4 register

	mov	f4 $0, f4 -1.25
	conv	s4 $0, f4 $0
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same s8 register

	mov	f4 $0, f4 -1.25
	conv	s8 $0, f4 $0
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same u1 register

	mov	f4 $0, f4 -1.25
	conv	u1 $0, f4 $0
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same u2 register

	mov	f4 $0, f4 -1.25
	conv	u2 $0, f4 $0
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same u4 register

	mov	f4 $0, f4 -1.25
	conv	u4 $0, f4 $0
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same u8 register

	mov	f4 $0, f4 -1.25
	conv	u8 $0, f4 $0
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same f4 register

	mov	f4 $0, f4 -1.25
	conv	f4 $0, f4 $0
	breq	+1, f4 $0, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f4 register to same f8 register

	mov	f4 $0, f4 -1.25
	conv	f8 $0, f4 $0
	breq	+1, f8 $0, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same s1 register

	mov	f8 $0, f8 -1.25
	conv	s1 $0, f8 $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same s2 register

	mov	f8 $0, f8 -1.25
	conv	s2 $0, f8 $0
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same s4 register

	mov	f8 $0, f8 -1.25
	conv	s4 $0, f8 $0
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same s8 register

	mov	f8 $0, f8 -1.25
	conv	s8 $0, f8 $0
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same u1 register

	mov	f8 $0, f8 -1.25
	conv	u1 $0, f8 $0
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same u2 register

	mov	f8 $0, f8 -1.25
	conv	u2 $0, f8 $0
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same u4 register

	mov	f8 $0, f8 -1.25
	conv	u4 $0, f8 $0
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same u8 register

	mov	f8 $0, f8 -1.25
	conv	u8 $0, f8 $0
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same f4 register

	mov	f8 $0, f8 -1.25
	conv	f4 $0, f8 $0
	breq	+1, f4 $0, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from f8 register to same f8 register

	mov	f8 $0, f8 -1.25
	conv	f8 $0, f8 $0
	breq	+1, f8 $0, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same s1 register

	mov	ptr $0, ptr 0xff
	conv	s1 $0, ptr $0
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same s2 register

	mov	ptr $0, ptr 0xff
	conv	s2 $0, ptr $0
	breq	+1, s2 $0, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same s4 register

	mov	ptr $0, ptr 0xff
	conv	s4 $0, ptr $0
	breq	+1, s4 $0, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same s8 register

	mov	ptr $0, ptr 0xff
	conv	s8 $0, ptr $0
	breq	+1, s8 $0, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same u1 register

	mov	ptr $0, ptr 0x23
	conv	u1 $0, ptr $0
	breq	+1, u1 $0, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same u2 register

	mov	ptr $0, ptr 0x23
	conv	u2 $0, ptr $0
	breq	+1, u2 $0, u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same u4 register

	mov	ptr $0, ptr 0x23
	conv	u4 $0, ptr $0
	breq	+1, u4 $0, u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same u8 register

	mov	ptr $0, ptr 0x23
	conv	u8 $0, ptr $0
	breq	+1, u8 $0, u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from ptr register to same ptr register

	mov	ptr $0, ptr 0xff
	conv	ptr $0, ptr $0
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from fun register to same fun register

	mov	ptr $0, ptr 0xff
	conv	fun $0, ptr $0
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: datum conversion from s1 memory to s1 register

	conv	s1 $0, s1 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to s2 register

	conv	s2 $0, s1 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to s4 register

	conv	s4 $0, s1 [@constant]
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to s8 register

	conv	s8 $0, s1 [@constant]
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to u1 register

	conv	u1 $0, s1 [@constant]
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to u2 register

	conv	u2 $0, s1 [@constant]
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to u4 register

	conv	u4 $0, s1 [@constant]
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to u8 register

	conv	u8 $0, s1 [@constant]
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to f4 register

	conv	f4 $0, s1 [@constant]
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to f8 register

	conv	f8 $0, s1 [@constant]
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1

positive: datum conversion from s1 memory to ptr register

	conv	ptr $0, s1 [@constant]
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 1

positive: datum conversion from s1 memory to fun register

	conv	fun $0, s1 [@constant]
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 1

positive: datum conversion from s2 memory to s1 register

	conv	s1 $0, s2 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to s2 register

	conv	s2 $0, s2 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to s4 register

	conv	s4 $0, s2 [@constant]
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to s8 register

	conv	s8 $0, s2 [@constant]
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to u1 register

	conv	u1 $0, s2 [@constant]
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to u2 register

	conv	u2 $0, s2 [@constant]
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to u4 register

	conv	u4 $0, s2 [@constant]
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to u8 register

	conv	u8 $0, s2 [@constant]
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to f4 register

	conv	f4 $0, s2 [@constant]
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to f8 register

	conv	f8 $0, s2 [@constant]
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1

positive: datum conversion from s2 memory to ptr register

	conv	ptr $0, s2 [@constant]
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1

positive: datum conversion from s2 memory to fun register

	conv	fun $0, s2 [@constant]
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1

positive: datum conversion from s4 memory to s1 register

	conv	s1 $0, s4 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to s2 register

	conv	s2 $0, s4 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to s4 register

	conv	s4 $0, s4 [@constant]
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to s8 register

	conv	s8 $0, s4 [@constant]
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to u1 register

	conv	u1 $0, s4 [@constant]
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to u2 register

	conv	u2 $0, s4 [@constant]
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to u4 register

	conv	u4 $0, s4 [@constant]
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to u8 register

	conv	u8 $0, s4 [@constant]
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to f4 register

	conv	f4 $0, s4 [@constant]
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to f8 register

	conv	f8 $0, s4 [@constant]
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1

positive: datum conversion from s4 memory to ptr register

	conv	ptr $0, s4 [@constant]
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1

positive: datum conversion from s4 memory to fun register

	conv	fun $0, s4 [@constant]
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1

positive: datum conversion from s8 memory to s1 register

	conv	s1 $0, s8 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to s2 register

	conv	s2 $0, s8 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to s4 register

	conv	s4 $0, s8 [@constant]
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to s8 register

	conv	s8 $0, s8 [@constant]
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to u1 register

	conv	u1 $0, s8 [@constant]
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to u2 register

	conv	u2 $0, s8 [@constant]
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to u4 register

	conv	u4 $0, s8 [@constant]
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to u8 register

	conv	u8 $0, s8 [@constant]
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to f4 register

	conv	f4 $0, s8 [@constant]
	breq	+1, f4 $0, f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to f8 register

	conv	f8 $0, s8 [@constant]
	breq	+1, f8 $0, f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1

positive: datum conversion from s8 memory to ptr register

	conv	ptr $0, s8 [@constant]
	breq	+1, ptr $0, ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1

positive: datum conversion from s8 memory to fun register

	conv	fun $0, s8 [@constant]
	breq	+1, fun $0, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1

positive: datum conversion from u1 memory to s1 register

	conv	s1 $0, u1 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff

positive: datum conversion from u1 memory to s2 register

	conv	s2 $0, u1 [@constant]
	breq	+1, s2 $0, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff

positive: datum conversion from u1 memory to s4 register

	conv	s4 $0, u1 [@constant]
	breq	+1, s4 $0, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff

positive: datum conversion from u1 memory to s8 register

	conv	s8 $0, u1 [@constant]
	breq	+1, s8 $0, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff

positive: datum conversion from u1 memory to u1 register

	conv	u1 $0, u1 [@constant]
	breq	+1, u1 $0, u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01

positive: datum conversion from u1 memory to u2 register

	conv	u2 $0, u1 [@constant]
	breq	+1, u2 $0, u2 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01

positive: datum conversion from u1 memory to u4 register

	conv	u4 $0, u1 [@constant]
	breq	+1, u4 $0, u4 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01

positive: datum conversion from u1 memory to u8 register

	conv	u8 $0, u1 [@constant]
	breq	+1, u8 $0, u8 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01

positive: datum conversion from u1 memory to f4 register

	conv	f4 $0, u1 [@constant]
	breq	+1, f4 $0, f4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff

positive: datum conversion from u1 memory to f8 register

	conv	f8 $0, u1 [@constant]
	breq	+1, f8 $0, f8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff

positive: datum conversion from u1 memory to ptr register

	conv	ptr $0, u1 [@constant]
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff

positive: datum conversion from u1 memory to fun register

	conv	fun $0, u1 [@constant]
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff

positive: datum conversion from u2 memory to s1 register

	conv	s1 $0, u2 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff

positive: datum conversion from u2 memory to s2 register

	conv	s2 $0, u2 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff

positive: datum conversion from u2 memory to s4 register

	conv	s4 $0, u2 [@constant]
	breq	+1, s4 $0, s4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff

positive: datum conversion from u2 memory to s8 register

	conv	s8 $0, u2 [@constant]
	breq	+1, s8 $0, s8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff

positive: datum conversion from u2 memory to u1 register

	conv	u1 $0, u2 [@constant]
	breq	+1, u1 $0, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123

positive: datum conversion from u2 memory to u2 register

	conv	u2 $0, u2 [@constant]
	breq	+1, u2 $0, u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123

positive: datum conversion from u2 memory to u4 register

	conv	u4 $0, u2 [@constant]
	breq	+1, u4 $0, u4 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123

positive: datum conversion from u2 memory to u8 register

	conv	u8 $0, u2 [@constant]
	breq	+1, u8 $0, u8 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123

positive: datum conversion from u2 memory to f4 register

	conv	f4 $0, u2 [@constant]
	breq	+1, f4 $0, f4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff

positive: datum conversion from u2 memory to f8 register

	conv	f8 $0, u2 [@constant]
	breq	+1, f8 $0, f8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff

positive: datum conversion from u2 memory to ptr register

	conv	ptr $0, u2 [@constant]
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xff

positive: datum conversion from u2 memory to fun register

	conv	fun $0, u2 [@constant]
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xff

positive: datum conversion from u4 memory to s1 register

	conv	s1 $0, u4 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff

positive: datum conversion from u4 memory to s2 register

	conv	s2 $0, u4 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff

positive: datum conversion from u4 memory to s4 register

	conv	s4 $0, u4 [@constant]
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff

positive: datum conversion from u4 memory to s8 register

	conv	s8 $0, u4 [@constant]
	breq	+1, s8 $0, s8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff

positive: datum conversion from u4 memory to u1 register

	conv	u1 $0, u4 [@constant]
	breq	+1, u1 $0, u1 0x67
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567

positive: datum conversion from u4 memory to u2 register

	conv	u2 $0, u4 [@constant]
	breq	+1, u2 $0, u2 0x4567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567

positive: datum conversion from u4 memory to u4 register

	conv	u4 $0, u4 [@constant]
	breq	+1, u4 $0, u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567

positive: datum conversion from u4 memory to u8 register

	conv	u8 $0, u4 [@constant]
	breq	+1, u8 $0, u8 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567

positive: datum conversion from u4 memory to f4 register

	conv	f4 $0, u4 [@constant]
	breq	+1, f4 $0, f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x000fffff

positive: datum conversion from u4 memory to f8 register

	conv	f8 $0, u4 [@constant]
	breq	+1, f8 $0, f8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff

positive: datum conversion from u4 memory to ptr register

	conv	ptr $0, u4 [@constant]
	breq	+1, ptr $0, ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x12

positive: datum conversion from u4 memory to fun register

	conv	fun $0, u4 [@constant]
	breq	+1, fun $0, fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x12

positive: datum conversion from u8 memory to s1 register

	conv	s1 $0, u8 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0xffffffffffffffff

positive: datum conversion from u8 memory to s2 register

	conv	s2 $0, u8 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0xffffffffffffffff

positive: datum conversion from u8 memory to s4 register

	conv	s4 $0, u8 [@constant]
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0xffffffffffffffff

positive: datum conversion from u8 memory to s8 register

	conv	s8 $0, u8 [@constant]
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0xffffffffffffffff

positive: datum conversion from u8 memory to u1 register

	conv	u1 $0, u8 [@constant]
	breq	+1, u1 $0, u1 0xef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef

positive: datum conversion from u8 memory to u2 register

	conv	u2 $0, u8 [@constant]
	breq	+1, u2 $0, u2 0xcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef

positive: datum conversion from u8 memory to u4 register

	conv	u4 $0, u8 [@constant]
	breq	+1, u4 $0, u4 0x89abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef

positive: datum conversion from u8 memory to u8 register

	conv	u8 $0, u8 [@constant]
	breq	+1, u8 $0, u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef

positive: datum conversion from u8 memory to f4 register

	conv	f4 $0, u8 [@constant]
	breq	+1, f4 $0, f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x00000000000fffff

positive: datum conversion from u8 memory to f8 register

	conv	f8 $0, u8 [@constant]
	breq	+1, f8 $0, f8 4503599627370495
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x000fffffffffffff

positive: datum conversion from u8 memory to ptr register

	conv	ptr $0, u8 [@constant]
	breq	+1, ptr $0, ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x12

positive: datum conversion from u8 memory to fun register

	conv	fun $0, u8 [@constant]
	breq	+1, fun $0, fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x12

positive: datum conversion from f4 memory to s1 register

	conv	s1 $0, f4 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to s2 register

	conv	s2 $0, f4 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to s4 register

	conv	s4 $0, f4 [@constant]
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to s8 register

	conv	s8 $0, f4 [@constant]
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to u1 register

	conv	u1 $0, f4 [@constant]
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to u2 register

	conv	u2 $0, f4 [@constant]
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to u4 register

	conv	u4 $0, f4 [@constant]
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to u8 register

	conv	u8 $0, f4 [@constant]
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to f4 register

	conv	f4 $0, f4 [@constant]
	breq	+1, f4 $0, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f4 memory to f8 register

	conv	f8 $0, f4 [@constant]
	breq	+1, f8 $0, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25

positive: datum conversion from f8 memory to s1 register

	conv	s1 $0, f8 [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to s2 register

	conv	s2 $0, f8 [@constant]
	breq	+1, s2 $0, s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to s4 register

	conv	s4 $0, f8 [@constant]
	breq	+1, s4 $0, s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to s8 register

	conv	s8 $0, f8 [@constant]
	breq	+1, s8 $0, s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to u1 register

	conv	u1 $0, f8 [@constant]
	breq	+1, u1 $0, u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to u2 register

	conv	u2 $0, f8 [@constant]
	breq	+1, u2 $0, u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to u4 register

	conv	u4 $0, f8 [@constant]
	breq	+1, u4 $0, u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to u8 register

	conv	u8 $0, f8 -1.25
	breq	+1, u8 $0, u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to f4 register

	conv	f4 $0, f8 [@constant]
	breq	+1, f4 $0, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from f8 memory to f8 register

	conv	f8 $0, f8 [@constant]
	breq	+1, f8 $0, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: datum conversion from ptr memory to s1 register

	conv	s1 $0, ptr [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff

positive: datum conversion from ptr memory to s2 register

	conv	s2 $0, ptr [@constant]
	breq	+1, s2 $0, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff

positive: datum conversion from ptr memory to s4 register

	conv	s4 $0, ptr [@constant]
	breq	+1, s4 $0, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff

positive: datum conversion from ptr memory to s8 register

	conv	s8 $0, ptr [@constant]
	breq	+1, s8 $0, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff

positive: datum conversion from ptr memory to u1 register

	conv	u1 $0, ptr [@constant]
	breq	+1, u1 $0, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x23

positive: datum conversion from ptr memory to u2 register

	conv	u2 $0, ptr [@constant]
	breq	+1, u2 $0, u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x23

positive: datum conversion from ptr memory to u4 register

	conv	u4 $0, ptr [@constant]
	breq	+1, u4 $0, u4 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x12

positive: datum conversion from ptr memory to u8 register

	conv	u8 $0, ptr [@constant]
	breq	+1, u8 $0, u8 0x34
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x34

positive: datum conversion from ptr memory to ptr register

	conv	ptr $0, ptr [@constant]
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff

positive: datum conversion from ptr memory to fun register

	conv	fun $0, ptr [@constant]
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff

positive: datum conversion from fun memory to s1 register

	conv	s1 $0, fun [@constant]
	breq	+1, s1 $0, s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff

positive: datum conversion from fun memory to s2 register

	conv	s2 $0, fun [@constant]
	breq	+1, s2 $0, s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff

positive: datum conversion from fun memory to s4 register

	conv	s4 $0, fun [@constant]
	breq	+1, s4 $0, s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff

positive: datum conversion from fun memory to s8 register

	conv	s8 $0, fun [@constant]
	breq	+1, s8 $0, s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff

positive: datum conversion from fun memory to u1 register

	conv	u1 $0, fun [@constant]
	breq	+1, u1 $0, u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0x23

positive: datum conversion from fun memory to u2 register

	conv	u2 $0, fun [@constant]
	breq	+1, u2 $0, u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0x23

positive: datum conversion from fun memory to u4 register

	conv	u4 $0, fun [@constant]
	breq	+1, u4 $0, u4 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0x12

positive: datum conversion from fun memory to u8 register

	conv	u8 $0, fun [@constant]
	breq	+1, u8 $0, u8 0x34
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0x34

positive: datum conversion from fun memory to ptr register

	conv	ptr $0, fun [@constant]
	breq	+1, ptr $0, ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff

positive: datum conversion from fun memory to fun register

	conv	fun $0, fun [@constant]
	breq	+1, fun $0, fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff

positive: datum conversion from s1 immediate to s1 memory

	conv	s1 [@value], s1 -1
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s1 immediate to s2 memory

	conv	s2 [@value], s1 -1
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s1 immediate to s4 memory

	conv	s4 [@value], s1 -1
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 immediate to s8 memory

	conv	s8 [@value], s1 -1
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 immediate to u1 memory

	conv	u1 [@value], s1 -1
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s1 immediate to u2 memory

	conv	u2 [@value], s1 -1
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s1 immediate to u4 memory

	conv	u4 [@value], s1 -1
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 immediate to u8 memory

	conv	u8 [@value], s1 -1
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 immediate to f4 memory

	conv	f4 [@value], s1 -1
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 immediate to f8 memory

	conv	f8 [@value], s1 -1
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 immediate to ptr memory

	conv	ptr [@value], s1 1
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s1 immediate to fun memory

	conv	fun [@value], s1 1
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s2 immediate to s1 memory

	conv	s1 [@value], s2 -1
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s2 immediate to s2 memory

	conv	s2 [@value], s2 -1
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s2 immediate to s4 memory

	conv	s4 [@value], s2 -1
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 immediate to s8 memory

	conv	s8 [@value], s2 -1
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 immediate to u1 memory

	conv	u1 [@value], s2 -1
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s2 immediate to u2 memory

	conv	u2 [@value], s2 -1
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s2 immediate to u4 memory

	conv	u4 [@value], s2 -1
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 immediate to u8 memory

	conv	u8 [@value], s2 -1
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 immediate to f4 memory

	conv	f4 [@value], s2 -1
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 immediate to f8 memory

	conv	f8 [@value], s2 -1
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 immediate to ptr memory

	conv	ptr [@value], s2 1
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s2 immediate to fun memory

	conv	fun [@value], s2 1
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s4 immediate to s1 memory

	conv	s1 [@value], s4 -1
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s4 immediate to s2 memory

	conv	s2 [@value], s4 -1
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s4 immediate to s4 memory

	conv	s4 [@value], s4 -1
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0

	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 immediate to s8 memory

	conv	s8 [@value], s4 -1
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 immediate to u1 memory

	conv	u1 [@value], s4 -1
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s4 immediate to u2 memory

	conv	u2 [@value], s4 -1
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s4 immediate to u4 memory

	conv	u4 [@value], s4 -1
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 immediate to u8 memory

	conv	u8 [@value], s4 -1
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 immediate to f4 memory

	conv	f4 [@value], s4 -1
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 immediate to f8 memory

	conv	f8 [@value], s4 -1
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 immediate to ptr memory

	conv	ptr [@value], s4 1
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s4 immediate to fun memory

	conv	fun [@value], s4 1
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s8 immediate to s1 memory

	conv	s1 [@value], s8 -1
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s8 immediate to s2 memory

	conv	s2 [@value], s8 -1
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s8 immediate to s4 memory

	conv	s4 [@value], s8 -1
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 immediate to s8 memory

	conv	s8 [@value], s8 -1
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 immediate to u1 memory

	conv	u1 [@value], s8 -1
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s8 immediate to u2 memory

	conv	u2 [@value], s8 -1
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s8 immediate to u4 memory

	conv	u4 [@value], s8 -1
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 immediate to u8 memory

	conv	u8 [@value], s8 -1
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 immediate to f4 memory

	conv	f4 [@value], s8 -1
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 immediate to f8 memory

	conv	f8 [@value], s8 -1
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 immediate to ptr memory

	conv	ptr [@value], s8 1
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s8 immediate to fun memory

	conv	fun [@value], s8 1
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u1 immediate to s1 memory

	conv	s1 [@value], u1 0xff
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u1 immediate to s2 memory

	conv	s2 [@value], u1 0xff
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u1 immediate to s4 memory

	conv	s4 [@value], u1 0xff
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 immediate to s8 memory

	conv	s8 [@value], u1 0xff
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 immediate to u1 memory

	conv	u1 [@value], u1 0x01
	breq	+1, u1 [@value], u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u1 immediate to u2 memory

	conv	u2 [@value], u1 0x01
	breq	+1, u2 [@value], u2 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u1 immediate to u4 memory

	conv	u4 [@value], u1 0x01
	breq	+1, u4 [@value], u4 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 immediate to u8 memory

	conv	u8 [@value], u1 0x01
	breq	+1, u8 [@value], u8 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 immediate to f4 memory

	conv	f4 [@value], u1 0xff
	breq	+1, f4 [@value], f4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 immediate to f8 memory

	conv	f8 [@value], u1 0xff
	breq	+1, f8 [@value], f8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 immediate to ptr memory

	conv	ptr [@value], u1 0xff
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u1 immediate to fun memory

	conv	fun [@value], u1 0xff
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u2 immediate to s1 memory

	conv	s1 [@value], u2 0xffff
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u2 immediate to s2 memory

	conv	s2 [@value], u2 0xffff
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u2 immediate to s4 memory

	conv	s4 [@value], u2 0xffff
	breq	+1, s4 [@value], s4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 immediate to s8 memory

	conv	s8 [@value], u2 0xffff
	breq	+1, s8 [@value], s8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 immediate to u1 memory

	conv	u1 [@value], u2 0x0123
	breq	+1, u1 [@value], u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u2 immediate to u2 memory

	conv	u2 [@value], u2 0x0123
	breq	+1, u2 [@value], u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u2 immediate to u4 memory

	conv	u4 [@value], u2 0x0123
	breq	+1, u4 [@value], u4 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 immediate to u8 memory

	conv	u8 [@value], u2 0x0123
	breq	+1, u8 [@value], u8 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 immediate to f4 memory

	conv	f4 [@value], u2 0xffff
	breq	+1, f4 [@value], f4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 immediate to f8 memory

	conv	f8 [@value], u2 0xffff
	breq	+1, f8 [@value], f8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 immediate to ptr memory

	conv	ptr [@value], u2 0xff
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u2 immediate to fun memory

	conv	fun [@value], u2 0xff
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u4 immediate to s1 memory

	conv	s1 [@value], u4 0xffffffff
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u4 immediate to s2 memory

	conv	s2 [@value], u4 0xffffffff
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u4 immediate to s4 memory

	conv	s4 [@value], u4 0xffffffff
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 immediate to s8 memory

	conv	s8 [@value], u4 0xffffffff
	breq	+1, s8 [@value], s8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 immediate to u1 memory

	conv	u1 [@value], u4 0x01234567
	breq	+1, u1 [@value], u1 0x67
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u4 immediate to u2 memory

	conv	u2 [@value], u4 0x01234567
	breq	+1, u2 [@value], u2 0x4567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u4 immediate to u4 memory

	conv	u4 [@value], u4 0x01234567
	breq	+1, u4 [@value], u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 immediate to u8 memory

	conv	u8 [@value], u4 0x01234567
	breq	+1, u8 [@value], u8 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 immediate to f4 memory

	conv	f4 [@value], u4 0x000fffff
	breq	+1, f4 [@value], f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 immediate to f8 memory

	conv	f8 [@value], u4 0xffffffff
	breq	+1, f8 [@value], f8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 immediate to ptr memory

	conv	ptr [@value], u4 0x12
	breq	+1, ptr [@value], ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u4 immediate to fun memory

	conv	fun [@value], u4 0x12
	breq	+1, fun [@value], fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u8 immediate to s1 memory

	conv	s1 [@value], u8 0xffffffffffffffff
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u8 immediate to s2 memory

	conv	s2 [@value], u8 0xffffffffffffffff
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u8 immediate to s4 memory

	conv	s4 [@value], u8 0xffffffffffffffff
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 immediate to s8 memory

	conv	s8 [@value], u8 0xffffffffffffffff
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 immediate to u1 memory

	conv	u1 [@value], u8 0x0123456789abcdef
	breq	+1, u1 [@value], u1 0xef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u8 immediate to u2 memory

	conv	u2 [@value], u8 0x0123456789abcdef
	breq	+1, u2 [@value], u2 0xcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u8 immediate to u4 memory

	conv	u4 [@value], u8 0x0123456789abcdef
	breq	+1, u4 [@value], u4 0x89abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 immediate to u8 memory

	conv	u8 [@value], u8 0x0123456789abcdef
	breq	+1, u8 [@value], u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 immediate to f4 memory

	conv	f4 [@value], u8 0x00000000000fffff
	breq	+1, f4 [@value], f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 immediate to f8 memory

	conv	f8 [@value], u8 0x000fffffffffffff
	breq	+1, f8 [@value], f8 4503599627370495
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 immediate to ptr memory

	conv	ptr [@value], u8 0x23
	breq	+1, ptr [@value], ptr 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u8 immediate to fun memory

	conv	fun [@value], u8 0x23
	breq	+1, fun [@value], fun 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from f4 immediate to s1 memory

	conv	s1 [@value], f4 -1.25
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from f4 immediate to s2 memory

	conv	s2 [@value], f4 -1.25
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from f4 immediate to s4 memory

	conv	s4 [@value], f4 -1.25
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 immediate to s8 memory

	conv	s8 [@value], f4 -1.25
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f4 immediate to u1 memory

	conv	u1 [@value], f4 -1.25
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from f4 immediate to u2 memory

	conv	u2 [@value], f4 -1.25
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from f4 immediate to u4 memory

	conv	u4 [@value], f4 -1.25
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 immediate to u8 memory

	conv	u8 [@value], f4 -1.25
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f4 immediate to f4 memory

	conv	f4 [@value], f4 -1.25
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 immediate to f8 memory

	conv	f8 [@value], f4 -1.25
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 immediate to s1 memory

	conv	s1 [@value], f8 -1.25
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from f8 immediate to s2 memory

	conv	s2 [@value], f8 -1.25
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from f8 immediate to s4 memory

	conv	s4 [@value], f8 -1.25
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 immediate to s8 memory

	conv	s8 [@value], f8 -1.25
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 immediate to u1 memory

	conv	u1 [@value], f8 -1.25
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from f8 immediate to u2 memory

	conv	u2 [@value], f8 -1.25
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from f8 immediate to u4 memory

	conv	u4 [@value], f8 -1.25
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 immediate to u8 memory

	conv	u8 [@value], f8 -1.25
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 immediate to f4 memory

	conv	f4 [@value], f8 -1.25
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 immediate to f8 memory

	conv	f8 [@value], f8 -1.25
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr immediate to s1 memory

	conv	s1 [@value], ptr 0xff
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from ptr immediate to s2 memory

	conv	s2 [@value], ptr 0xff
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from ptr immediate to s4 memory

	conv	s4 [@value], ptr 0xff
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from ptr immediate to s8 memory

	conv	s8 [@value], ptr 0xff
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr immediate to u1 memory

	conv	u1 [@value], ptr 0x23
	breq	+1, u1 [@value], u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from ptr immediate to u2 memory

	conv	u2 [@value], ptr 0x23
	breq	+1, u2 [@value], u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from ptr immediate to u4 memory

	conv	u4 [@value], ptr 0x23
	breq	+1, u4 [@value], u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from ptr immediate to u8 memory

	conv	u8 [@value], ptr 0x23
	breq	+1, u8 [@value], u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr immediate to ptr memory

	conv	ptr [@value], ptr 0xff
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from ptr immediate to fun memory

	conv	fun [@value], ptr 0xff
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from fun immediate to s1 memory

	conv	s1 [@value], fun 0xff
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from fun immediate to s2 memory

	conv	s2 [@value], fun 0xff
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from fun immediate to s4 memory

	conv	s4 [@value], fun 0xff
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from fun immediate to s8 memory

	conv	s8 [@value], fun 0xff
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from fun immediate to u1 memory

	conv	u1 [@value], fun 0x34
	breq	+1, u1 [@value], u1 0x34
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from fun immediate to u2 memory

	conv	u2 [@value], fun 0x34
	breq	+1, u2 [@value], u2 0x34
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from fun immediate to u4 memory

	conv	u4 [@value], fun 0x34
	breq	+1, u4 [@value], u4 0x34
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from fun immediate to u8 memory

	conv	u8 [@value], fun 0x34
	breq	+1, u8 [@value], u8 0x34
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from fun immediate to ptr memory

	conv	ptr [@value], fun 0xff
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from fun immediate to fun memory

	conv	fun [@value], fun 0xff
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s1 register to s1 memory

	mov	s1 $0, s1 -1
	conv	s1 [@value], s1 $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s1 register to s2 memory

	mov	s1 $0, s1 -1
	conv	s2 [@value], s1 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s1 register to s4 memory

	mov	s1 $0, s1 -1
	conv	s4 [@value], s1 $0
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 register to s8 memory

	mov	s1 $0, s1 -1
	conv	s8 [@value], s1 $0
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 register to u1 memory

	mov	s1 $0, s1 -1
	conv	u1 [@value], s1 $0
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s1 register to u2 memory

	mov	s1 $0, s1 -1
	conv	u2 [@value], s1 $0
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s1 register to u4 memory

	mov	s1 $0, s1 -1
	conv	u4 [@value], s1 $0
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 register to u8 memory

	mov	s1 $0, s1 -1
	conv	u8 [@value], s1 $0
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 register to f4 memory

	mov	s1 $0, s1 -1
	conv	f4 [@value], s1 $0
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 register to f8 memory

	mov	s1 $0, s1 -1
	conv	f8 [@value], s1 $0
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 register to ptr memory

	mov	s1 $0, s1 1
	conv	ptr [@value], s1 $0
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s1 register to fun memory

	mov	s1 $0, s1 1
	conv	fun [@value], s1 $0
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s2 register to s1 memory

	mov	s2 $0, s2 -1
	conv	s1 [@value], s2 $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s2 register to s2 memory

	mov	s2 $0, s2 -1
	conv	s2 [@value], s2 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s2 register to s4 memory

	mov	s2 $0, s2 -1
	conv	s4 [@value], s2 $0
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 register to s8 memory

	mov	s2 $0, s2 -1
	conv	s8 [@value], s2 $0
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 register to u1 memory

	mov	s2 $0, s2 -1
	conv	u1 [@value], s2 $0
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s2 register to u2 memory

	mov	s2 $0, s2 -1
	conv	u2 [@value], s2 $0
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s2 register to u4 memory

	mov	s2 $0, s2 -1
	conv	u4 [@value], s2 $0
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 register to u8 memory

	mov	s2 $0, s2 -1
	conv	u8 [@value], s2 $0
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 register to f4 memory

	mov	s2 $0, s2 -1
	conv	f4 [@value], s2 $0
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 register to f8 memory

	mov	s2 $0, s2 -1
	conv	f8 [@value], s2 $0
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 register to ptr memory

	mov	s2 $0, s2 1
	conv	ptr [@value], s2 $0
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s2 register to fun memory

	mov	s2 $0, s2 1
	conv	fun [@value], s2 $0
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s4 register to s1 memory

	mov	s4 $0, s4 -1
	conv	s1 [@value], s4 -1
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s4 register to s2 memory

	mov	s4 $0, s4 -1
	conv	s2 [@value], s4 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s4 register to s4 memory

	mov	s4 $0, s4 -1
	conv	s4 [@value], s4 $0
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 register to s8 memory

	mov	s4 $0, s4 -1
	conv	s8 [@value], s4 $0
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 register to u1 memory

	mov	s4 $0, s4 -1
	conv	u1 [@value], s4 $0
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s4 register to u2 memory

	mov	s4 $0, s4 -1
	conv	u2 [@value], s4 $0
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s4 register to u4 memory

	mov	s4 $0, s4 -1
	conv	u4 [@value], s4 $0
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 register to u8 memory

	mov	s4 $0, s4 -1
	conv	u8 [@value], s4 $0
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 register to f4 memory

	mov	s4 $0, s4 -1
	conv	f4 [@value], s4 $0
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 register to f8 memory

	mov	s4 $0, s4 -1
	conv	f8 [@value], s4 $0
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 register to ptr memory

	mov	s4 $0, s4 1
	conv	ptr [@value], s4 $0
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s4 register to fun memory

	mov	s4 $0, s4 1
	conv	fun [@value], s4 $0
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s8 register to s1 memory

	mov	s8 $0, s8 -1
	conv	s1 [@value], s8 $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s8 register to s2 memory

	mov	s8 $0, s8 -1
	conv	s2 [@value], s8 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s8 register to s4 memory

	mov	s8 $0, s8 -1
	conv	s4 [@value], s8 $0
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 register to s8 memory

	mov	s8 $0, s8 -1
	conv	s8 [@value], s8 $0
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 register to u1 memory

	mov	s8 $0, s8 -1
	conv	u1 [@value], s8 $0
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from s8 register to u2 memory

	mov	s8 $0, s8 -1
	conv	u2 [@value], s8 $0
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from s8 register to u4 memory

	mov	s8 $0, s8 -1
	conv	u4 [@value], s8 $0
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 register to u8 memory

	mov	s8 $0, s8 -1
	conv	u8 [@value], s8 $0
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 register to f4 memory

	mov	s8 $0, s8 -1
	conv	f4 [@value], s8 $0
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 register to f8 memory

	mov	s8 $0, s8 -1
	conv	f8 [@value], s8 $0
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 register to ptr memory

	mov	s8 $0, s8 1
	conv	ptr [@value], s8 $0
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s8 register to fun memory

	mov	s8 $0, s8 1
	conv	fun [@value], s8 $0
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u1 register to s1 memory

	conv	s1 [@value], u1 0xff
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u1 register to s2 memory

	mov	u1 $0, u1 0xff
	conv	s2 [@value], u1 $0
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u1 register to s4 memory

	mov	u1 $0, u1 0xff
	conv	s4 [@value], u1 $0
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 register to s8 memory

	mov	u1 $0, u1 0xff
	conv	s8 [@value], u1 $0
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 register to u1 memory

	mov	u1 $0, u1 0x01
	conv	u1 [@value], u1 $0
	breq	+1, u1 [@value], u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u1 register to u2 memory

	mov	u1 $0, u1 0x01
	conv	u2 [@value], u1 $0
	breq	+1, u2 [@value], u2 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u1 register to u4 memory

	mov	u1 $0, u1 0x01
	conv	u4 [@value], u1 $0
	breq	+1, u4 [@value], u4 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 register to u8 memory

	mov	u1 $0, u1 0x01
	conv	u8 [@value], u1 $0
	breq	+1, u8 [@value], u8 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 register to f4 memory

	mov	u1 $0, u1 0xff
	conv	f4 [@value], u1 $0
	breq	+1, f4 [@value], f4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 register to f8 memory

	mov	u1 $0, u1 0xff
	conv	f8 [@value], u1 $0
	breq	+1, f8 [@value], f8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 register to ptr memory

	mov	u1 $0, u1 0xff
	conv	ptr [@value], u1 $0
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u1 register to fun memory

	mov	u1 $0, u1 0xff
	conv	fun [@value], u1 $0
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u2 register to s1 memory

	mov	u2 $0, u2 0xffff
	conv	s1 [@value], u2 $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u2 register to s2 memory

	mov	u2 $0, u2 0xffff
	conv	s2 [@value], u2 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u2 register to s4 memory

	mov	u2 $0, u2 0xffff
	conv	s4 [@value], u2 $0
	breq	+1, s4 [@value], s4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 register to s8 memory

	mov	u2 $0, u2 0xffff
	conv	s8 [@value], u2 $0
	breq	+1, s8 [@value], s8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 register to u1 memory

	mov	u2 $0, u2 0x0123
	conv	u1 [@value], u2 $0
	breq	+1, u1 [@value], u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u2 register to u2 memory

	mov	u2 $0, u2 0x0123
	conv	u2 [@value], u2 $0
	breq	+1, u2 [@value], u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u2 register to u4 memory

	mov	u2 $0, u2 0x0123
	conv	u4 [@value], u2 $0
	breq	+1, u4 [@value], u4 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 register to u8 memory

	mov	u2 $0, u2 0x0123
	conv	u8 [@value], u2 $0
	breq	+1, u8 [@value], u8 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 register to f4 memory

	mov	u2 $0, u2 0xffff
	conv	f4 [@value], u2 $0
	breq	+1, f4 [@value], f4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 register to f8 memory

	mov	u2 $0, u2 0xffff
	conv	f8 [@value], u2 $0
	breq	+1, f8 [@value], f8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 register to ptr memory

	mov	u2 $0, u2 0xff
	conv	ptr [@value], u2 $0
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u2 register to fun memory

	mov	u2 $0, u2 0xff
	conv	fun [@value], u2 $0
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u4 register to s1 memory

	mov	u4 $0, u4 0xffffffff
	conv	s1 [@value], u4 $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 register to s2 memory

	mov	u4 $0, u4 0xffffffff
	conv	s2 [@value], u4 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u4 register to s4 memory

	mov	u4 $0, u4 0xffffffff
	conv	s4 [@value], u4 $0
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 register to s8 memory

	mov	u4 $0, u4 0xffffffff
	conv	s8 [@value], u4 $0
	breq	+1, s8 [@value], s8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 register to u1 memory

	mov	u4 $0, u4 0x01234567
	conv	u1 [@value], u4 $0
	breq	+1, u1 [@value], u1 0x67
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u4 register to u2 memory

	mov	u4 $0, u4 0x01234567
	conv	u2 [@value], u4 $0
	breq	+1, u2 [@value], u2 0x4567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u4 register to u4 memory

	mov	u4 $0, u4 0x01234567
	conv	u4 [@value], u4 $0
	breq	+1, u4 [@value], u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 register to u8 memory

	mov	u4 $0, u4 0x01234567
	conv	u8 [@value], u4 $0
	breq	+1, u8 [@value], u8 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 register to f4 memory

	mov	u4 $0, u4 0x000fffff
	conv	f4 [@value], u4 $0
	breq	+1, f4 [@value], f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 register to f8 memory

	mov	u4 $0, u4 0xffffffff
	conv	f8 [@value], u4 $0
	breq	+1, f8 [@value], f8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 register to ptr memory

	mov	u4 $0, u4 0x23
	conv	ptr [@value], u4 $0
	breq	+1, ptr [@value], ptr 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u4 register to fun memory

	mov	u4 $0, u4 0x23
	conv	fun [@value], u4 $0
	breq	+1, fun [@value], fun 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u8 register to s1 memory

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s1 [@value], u8 $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u8 register to s2 memory

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s2 [@value], u8 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u8 register to s4 memory

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s4 [@value], u8 $0
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 register to s8 memory

	mov	u8 $0, u8 0xffffffffffffffff
	conv	s8 [@value], u8 $0
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 register to u1 memory

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u1 [@value], u8 $0
	breq	+1, u1 [@value], u1 0xef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from u8 register to u2 memory

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u2 [@value], u8 $0
	breq	+1, u2 [@value], u2 0xcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from u8 register to u4 memory

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u4 [@value], u8 $0
	breq	+1, u4 [@value], u4 0x89abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 register to u8 memory

	mov	u8 $0, u8 0x0123456789abcdef
	conv	u8 [@value], u8 $0
	breq	+1, u8 [@value], u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 register to f4 memory

	mov	u8 $0, u8 0x00000000000fffff
	conv	f4 [@value], u8 $0
	breq	+1, f4 [@value], f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 register to f8 memory

	mov	u8 $0, u8 0x000fffffffffffff
	conv	f8 [@value], u8 $0
	breq	+1, f8 [@value], f8 4503599627370495
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 register to ptr memory

	mov	u8 $0, u8 0x12
	conv	ptr [@value], u8 $0
	breq	+1, ptr [@value], ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u8 register to fun memory

	mov	u8 $0, u8 0x12
	conv	fun [@value], u8 $0
	breq	+1, fun [@value], fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from f4 register to s1 memory

	mov	f4 $0, f4 -1.25
	conv	s1 [@value], f4 $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from f4 register to s2 memory

	mov	f4 $0, f4 -1.25
	conv	s2 [@value], f4 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from f4 register to s4 memory

	mov	f4 $0, f4 -1.25
	conv	s4 [@value], f4 $0
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 register to s8 memory

	mov	f4 $0, f4 -1.25
	conv	s8 [@value], f4 $0
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f4 register to u1 memory

	mov	f4 $0, f4 -1.25
	conv	u1 [@value], f4 $0
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from f4 register to u2 memory

	mov	f4 $0, f4 -1.25
	conv	u2 [@value], f4 $0
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from f4 register to u4 memory

	mov	f4 $0, f4 -1.25
	conv	u4 [@value], f4 $0
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 register to u8 memory

	mov	f4 $0, f4 -1.25
	conv	u8 [@value], f4 $0
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f4 register to f4 memory

	mov	f4 $0, f4 -1.25
	conv	f4 [@value], f4 $0
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 register to f8 memory

	mov	f4 $0, f4 -1.25
	conv	f8 [@value], f4 $0
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 register to s1 memory

	mov	f8 $0, f8 -1.25
	conv	s1 [@value], f8 $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from f8 register to s2 memory

	mov	f8 $0, f8 -1.25
	conv	s2 [@value], f8 $0
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from f8 register to s4 memory

	mov	f8 $0, f8 -1.25
	conv	s4 [@value], f8 $0
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 register to s8 memory

	mov	f8 $0, f8 -1.25
	conv	s8 [@value], f8 $0
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 register to u1 memory

	mov	f8 $0, f8 -1.25
	conv	u1 [@value], f8 $0
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from f8 register to u2 memory

	mov	f8 $0, f8 -1.25
	conv	u2 [@value], f8 $0
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from f8 register to u4 memory

	mov	f8 $0, f8 -1.25
	conv	u4 [@value], f8 $0
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 register to u8 memory

	mov	f8 $0, f8 -1.25
	conv	u8 [@value], f8 $0
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 register to f4 memory

	mov	f8 $0, f8 -1.25
	conv	f4 [@value], f8 $0
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 register to f8 memory

	mov	f8 $0, f8 -1.25
	conv	f8 [@value], f8 $0
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr register to s1 memory

	mov	ptr $0, ptr 0xff
	conv	s1 [@value], ptr $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from ptr register to s2 memory

	mov	ptr $0, ptr 0xff
	conv	s2 [@value], ptr $0
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from ptr register to s4 memory

	mov	ptr $0, ptr 0xff
	conv	s4 [@value], ptr $0
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from ptr register to s8 memory

	mov	ptr $0, ptr 0xff
	conv	s8 [@value], ptr $0
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr register to u1 memory

	mov	ptr $0, ptr 0x23
	conv	u1 [@value], ptr $0
	breq	+1, u1 [@value], u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from ptr register to u2 memory

	mov	ptr $0, ptr 0x23
	conv	u2 [@value], ptr $0
	breq	+1, u2 [@value], u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from ptr register to u4 memory

	mov	ptr $0, ptr 0x23
	conv	u4 [@value], ptr $0
	breq	+1, u4 [@value], u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from ptr register to u8 memory

	mov	ptr $0, ptr 0x23
	conv	u8 [@value], ptr $0
	breq	+1, u8 [@value], u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr register to ptr memory

	mov	ptr $0, ptr 0xff
	conv	ptr [@value], ptr $0
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from ptr register to fun memory

	mov	ptr $0, ptr 0xff
	conv	fun [@value], ptr $0
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from fun register to s1 memory

	mov	fun $0, fun 0xff
	conv	s1 [@value], fun $0
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from fun register to s2 memory

	mov	fun $0, fun 0xff
	conv	s2 [@value], fun $0
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from fun register to s4 memory

	mov	fun $0, fun 0xff
	conv	s4 [@value], fun $0
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from fun register to s8 memory

	mov	fun $0, fun 0xff
	conv	s8 [@value], fun $0
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from fun register to u1 memory

	mov	fun $0, fun 0x23
	conv	u1 [@value], fun $0
	breq	+1, u1 [@value], u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: datum conversion from fun register to u2 memory

	mov	fun $0, fun 0x23
	conv	u2 [@value], fun $0
	breq	+1, u2 [@value], u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: datum conversion from fun register to u4 memory

	mov	fun $0, fun 0x23
	conv	u4 [@value], fun $0
	breq	+1, u4 [@value], u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: datum conversion from fun register to u8 memory

	mov	fun $0, fun 0x23
	conv	u8 [@value], fun $0
	breq	+1, u8 [@value], u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: datum conversion from fun register to ptr memory

	mov	fun $0, fun 0xff
	conv	ptr [@value], fun $0
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from fun register to fun memory

	mov	fun $0, fun 0xff
	conv	fun [@value], fun $0
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s1 memory to s1 memory

	conv	s1 [@value], s1 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	1
	res	1

positive: datum conversion from s1 memory to s2 memory

	conv	s2 [@value], s1 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	2
	res	2

positive: datum conversion from s1 memory to s4 memory

	conv	s4 [@value], s1 [@constant]
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 memory to s8 memory

	conv	s8 [@value], s1 [@constant]
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 memory to u1 memory

	conv	u1 [@value], s1 [@constant]
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	1
	res	1

positive: datum conversion from s1 memory to u2 memory

	conv	u2 [@value], s1 [@constant]
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	2
	res	2

positive: datum conversion from s1 memory to u4 memory

	conv	u4 [@value], s1 [@constant]
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 memory to u8 memory

	conv	u8 [@value], s1 [@constant]
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 memory to f4 memory

	conv	f4 [@value], s1 [@constant]
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s1 memory to f8 memory

	conv	f8 [@value], s1 [@constant]
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s1 memory to ptr memory

	conv	ptr [@value], s1 [@constant]
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 1
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s1 memory to fun memory

	conv	fun [@value], s1 [@constant]
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 1
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s2 memory to s1 memory

	conv	s1 [@value], s2 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	1
	res	1

positive: datum conversion from s2 memory to s2 memory

	conv	s2 [@value], s2 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	2
	res	2

positive: datum conversion from s2 memory to s4 memory

	conv	s4 [@value], s2 [@constant]
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 memory to s8 memory

	conv	s8 [@value], s2 [@constant]
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 memory to u1 memory

	conv	u1 [@value], s2 [@constant]
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	1
	res	1

positive: datum conversion from s2 memory to u2 memory

	conv	u2 [@value], s2 [@constant]
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	2
	res	2

positive: datum conversion from s2 memory to u4 memory

	conv	u4 [@value], s2 [@constant]
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 memory to u8 memory

	conv	u8 [@value], s2 [@constant]
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 memory to f4 memory

	conv	f4 [@value], s2 [@constant]
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s2 memory to f8 memory

	conv	f8 [@value], s2 [@constant]
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s2 memory to ptr memory

	conv	ptr [@value], s2 [@constant]
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s2 memory to fun memory

	conv	fun [@value], s2 [@constant]
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s4 memory to s1 memory

	conv	s1 [@value], s4 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	1
	res	1

positive: datum conversion from s4 memory to s2 memory

	conv	s2 [@value], s4 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	2
	res	2

positive: datum conversion from s4 memory to s4 memory

	conv	s4 [@value], s4 [@constant]
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 memory to s8 memory

	conv	s8 [@value], s4 [@constant]
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 memory to u1 memory

	conv	u1 [@value], s4 [@constant]
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	1
	res	1

positive: datum conversion from s4 memory to u2 memory

	conv	u2 [@value], s4 [@constant]
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	2
	res	2

positive: datum conversion from s4 memory to u4 memory

	conv	u4 [@value], s4 [@constant]
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 memory to u8 memory

	conv	u8 [@value], s4 [@constant]
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 memory to f4 memory

	conv	f4 [@value], s4 [@constant]
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s4 memory to f8 memory

	conv	f8 [@value], s4 [@constant]
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s4 memory to ptr memory

	conv	ptr [@value], s4 [@constant]
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from s4 memory to fun memory

	conv	fun [@value], s4 [@constant]
	breq	+1, fun [@value], fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from s8 memory to s1 memory

	conv	s1 [@value], s8 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	1
	res	1

positive: datum conversion from s8 memory to s2 memory

	conv	s2 [@value], s8 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	2
	res	2

positive: datum conversion from s8 memory to s4 memory

	conv	s4 [@value], s8 [@constant]
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 memory to s8 memory

	conv	s8 [@value], s8 [@constant]
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 memory to u1 memory

	conv	u1 [@value], s8 [@constant]
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	1
	res	1

positive: datum conversion from s8 memory to u2 memory

	conv	u2 [@value], s8 [@constant]
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	2
	res	2

positive: datum conversion from s8 memory to u4 memory

	conv	u4 [@value], s8 [@constant]
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 memory to u8 memory

	conv	u8 [@value], s8 [@constant]
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 memory to f4 memory

	conv	f4 [@value], s8 [@constant]
	breq	+1, f4 [@value], f4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	4
	res	4

positive: datum conversion from s8 memory to f8 memory

	conv	f8 [@value], s8 [@constant]
	breq	+1, f8 [@value], f8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -1
	.data value
	.alignment	8
	res	8

positive: datum conversion from s8 memory to ptr memory

	conv	ptr [@value], s8 [@constant]
	breq	+1, ptr [@value], ptr 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u1 memory to s1 memory

	conv	s1 [@value], u1 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff
	.data value
	.alignment	1
	res	1

positive: datum conversion from u1 memory to s2 memory

	conv	s2 [@value], u1 [@constant]
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff
	.data value
	.alignment	2
	res	2

positive: datum conversion from u1 memory to s4 memory

	conv	s4 [@value], u1 [@constant]
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 memory to s8 memory

	conv	s8 [@value], u1 [@constant]
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 memory to u1 memory

	conv	u1 [@value], u1 [@constant]
	breq	+1, u1 [@value], u1 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01
	.data value
	.alignment	1
	res	1

positive: datum conversion from u1 memory to u2 memory

	conv	u2 [@value], u1 [@constant]
	breq	+1, u2 [@value], u2 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01
	.data value
	.alignment	2
	res	2

positive: datum conversion from u1 memory to u4 memory

	conv	u4 [@value], u1 [@constant]
	breq	+1, u4 [@value], u4 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 memory to u8 memory

	conv	u8 [@value], u1 [@constant]
	breq	+1, u8 [@value], u8 0x01
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x01
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 memory to f4 memory

	conv	f4 [@value], u1 [@constant]
	breq	+1, f4 [@value], f4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff
	.data value
	.alignment	4
	res	4

positive: datum conversion from u1 memory to f8 memory

	conv	f8 [@value], u1 [@constant]
	breq	+1, f8 [@value], f8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff
	.data value
	.alignment	8
	res	8

positive: datum conversion from u1 memory to ptr memory

	conv	ptr [@value], u1 [@constant]
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u1 memory to fun memory

	conv	fun [@value], u1 [@constant]
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0xff
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u2 memory to s1 memory

	conv	s1 [@value], u2 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff
	.data value
	.alignment	1
	res	1

positive: datum conversion from u2 memory to s2 memory

	conv	s2 [@value], u2 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff
	.data value
	.alignment	2
	res	2

positive: datum conversion from u2 memory to s4 memory

	conv	s4 [@value], u2 [@constant]
	breq	+1, s4 [@value], s4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 memory to s8 memory

	conv	s8 [@value], u2 [@constant]
	breq	+1, s8 [@value], s8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 memory to u1 memory

	conv	u1 [@value], u2 [@constant]
	breq	+1, u1 [@value], u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123
	.data value
	.alignment	1
	res	1

positive: datum conversion from u2 memory to u2 memory

	conv	u2 [@value], u2 [@constant]
	breq	+1, u2 [@value], u2 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123
	.data value
	.alignment	2
	res	2

positive: datum conversion from u2 memory to u4 memory

	conv	u4 [@value], u2 [@constant]
	breq	+1, u4 [@value], u4 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 memory to u8 memory

	conv	u8 [@value], u2 [@constant]
	breq	+1, u8 [@value], u8 0x0123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x0123
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 memory to f4 memory

	conv	f4 [@value], u2 [@constant]
	breq	+1, f4 [@value], f4 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff
	.data value
	.alignment	4
	res	4

positive: datum conversion from u2 memory to f8 memory

	conv	f8 [@value], u2 [@constant]
	breq	+1, f8 [@value], f8 65535
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xffff
	.data value
	.alignment	8
	res	8

positive: datum conversion from u2 memory to ptr memory

	conv	ptr [@value], u2 [@constant]
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xff
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u2 memory to fun memory

	conv	fun [@value], u2 [@constant]
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0xff
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u4 memory to s1 memory

	conv	s1 [@value], u4 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff
	.data value
	.alignment	1
	res	1

positive: datum conversion from u4 memory to s2 memory

	conv	s2 [@value], u4 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff
	.data value
	.alignment	2
	res	2

positive: datum conversion from u4 memory to s4 memory

	conv	s4 [@value], u4 [@constant]
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 memory to s8 memory

	conv	s8 [@value], u4 [@constant]
	breq	+1, s8 [@value], s8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 memory to u1 memory

	conv	u1 [@value], u4 [@constant]
	breq	+1, u1 [@value], u1 0x67
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567
	.data value
	.alignment	1
	res	1

positive: datum conversion from u4 memory to u2 memory

	conv	u2 [@value], u4 [@constant]
	breq	+1, u2 [@value], u2 0x4567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567
	.data value
	.alignment	2
	res	2

positive: datum conversion from u4 memory to u4 memory

	conv	u4 [@value], u4 [@constant]
	breq	+1, u4 [@value], u4 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 memory to u8 memory

	conv	u8 [@value], u4 [@constant]
	breq	+1, u8 [@value], u8 0x01234567
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x01234567
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 memory to f4 memory

	conv	f4 [@value], u4 [@constant]
	breq	+1, f4 [@value], f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x000fffff
	.data value
	.alignment	4
	res	4

positive: datum conversion from u4 memory to f8 memory

	conv	f8 [@value], u4 [@constant]
	breq	+1, f8 [@value], f8 4294967295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0xffffffff
	.data value
	.alignment	8
	res	8

positive: datum conversion from u4 memory to ptr memory

	conv	ptr [@value], u4 [@constant]
	breq	+1, ptr [@value], ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x12
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u4 memory to fun memory

	conv	fun [@value], u4 [@constant]
	breq	+1, fun [@value], fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x12
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from u8 memory to s1 memory

	conv	s1 [@value], u8 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0xffffffffffffffff
	.data value
	.alignment	1
	res	1

positive: datum conversion from u8 memory to s2 memory

	conv	s2 [@value], u8 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0xffffffffffffffff
	.data value
	.alignment	2
	res	2

positive: datum conversion from u8 memory to s4 memory

	conv	s4 [@value], u8 [@constant]
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0xffffffffffffffff
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 memory to s8 memory

	conv	s8 [@value], u8 [@constant]
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0xffffffffffffffff
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 memory to u1 memory

	conv	u1 [@value], u8 [@constant]
	breq	+1, u1 [@value], u1 0xef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef
	.data value
	.alignment	1
	res	1

positive: datum conversion from u8 memory to u2 memory

	conv	u2 [@value], u8 [@constant]
	breq	+1, u2 [@value], u2 0xcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef
	.data value
	.alignment	2
	res	2

positive: datum conversion from u8 memory to u4 memory

	conv	u4 [@value], u8 [@constant]
	breq	+1, u4 [@value], u4 0x89abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 memory to u8 memory

	conv	u8 [@value], u8 [@constant]
	breq	+1, u8 [@value], u8 0x0123456789abcdef
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 memory to f4 memory

	conv	f4 [@value], u8 [@constant]
	breq	+1, f4 [@value], f4 1048575
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x00000000000fffff
	.data value
	.alignment	4
	res	4

positive: datum conversion from u8 memory to f8 memory

	conv	f8 [@value], u8 [@constant]
	breq	+1, f8 [@value], f8 4503599627370495
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x000fffffffffffff
	.data value
	.alignment	8
	res	8

positive: datum conversion from u8 memory to ptr memory

	conv	ptr [@value], u8 [@constant]
	breq	+1, ptr [@value], ptr 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x23
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from u8 memory to fun memory

	conv	fun [@value], u8 [@constant]
	breq	+1, fun [@value], fun 0x34
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x34
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from f4 memory to s1 memory

	conv	s1 [@value], f4 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	1
	res	1

positive: datum conversion from f4 memory to s2 memory

	conv	s2 [@value], f4 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	2
	res	2

positive: datum conversion from f4 memory to s4 memory

	conv	s4 [@value], f4 [@constant]
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 memory to s8 memory

	conv	s8 [@value], f4 [@constant]
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	8
	res	8

positive: datum conversion from f4 memory to u1 memory

	conv	u1 [@value], f4 [@constant]
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	1
	res	1

positive: datum conversion from f4 memory to u2 memory

	conv	u2 [@value], f4 [@constant]
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	2
	res	2

positive: datum conversion from f4 memory to u4 memory

	conv	u4 [@value], f4 [@constant]
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 memory to u8 memory

	conv	u8 [@value], f4 [@constant]
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	8
	res	8

positive: datum conversion from f4 memory to f4 memory

	conv	f4 [@value], f4 [@constant]
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	4
	res	4

positive: datum conversion from f4 memory to f8 memory

	conv	f8 [@value], f4 [@constant]
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.25
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 memory to s1 memory

	conv	s1 [@value], f8 [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	1
	res	1

positive: datum conversion from f8 memory to s2 memory

	conv	s2 [@value], f8 [@constant]
	breq	+1, s2 [@value], s2 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	2
	res	2

positive: datum conversion from f8 memory to s4 memory

	conv	s4 [@value], f8 [@constant]
	breq	+1, s4 [@value], s4 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 memory to s8 memory

	conv	s8 [@value], f8 [@constant]
	breq	+1, s8 [@value], s8 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 memory to u1 memory

	conv	u1 [@value], f8 [@constant]
	breq	+1, u1 [@value], u1 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	1
	res	1

positive: datum conversion from f8 memory to u2 memory

	conv	u2 [@value], f8 [@constant]
	breq	+1, u2 [@value], u2 0xffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	2
	res	2

positive: datum conversion from f8 memory to u4 memory

	conv	u4 [@value], f8 [@constant]
	breq	+1, u4 [@value], u4 0xffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 memory to u8 memory

	conv	u8 [@value], f8 -1.25
	breq	+1, u8 [@value], u8 0xffffffffffffffff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: datum conversion from f8 memory to f4 memory

	conv	f4 [@value], f8 [@constant]
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	4
	res	4

positive: datum conversion from f8 memory to f8 memory

	conv	f8 [@value], f8 [@constant]
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr memory to s1 memory

	conv	s1 [@value], ptr [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff
	.data value
	.alignment	1
	res	1

positive: datum conversion from ptr memory to s2 memory

	conv	s2 [@value], ptr [@constant]
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff
	.data value
	.alignment	2
	res	2

positive: datum conversion from ptr memory to s4 memory

	conv	s4 [@value], ptr [@constant]
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff
	.data value
	.alignment	4
	res	4

positive: datum conversion from ptr memory to s8 memory

	conv	s8 [@value], ptr [@constant]
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr memory to u1 memory

	conv	u1 [@value], ptr [@constant]
	breq	+1, u1 [@value], u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x23
	.data value
	.alignment	1
	res	1

positive: datum conversion from ptr memory to u2 memory

	conv	u2 [@value], ptr [@constant]
	breq	+1, u2 [@value], u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x23
	.data value
	.alignment	2
	res	2

positive: datum conversion from ptr memory to u4 memory

	conv	u4 [@value], ptr [@constant]
	breq	+1, u4 [@value], u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x23
	.data value
	.alignment	4
	res	4

positive: datum conversion from ptr memory to u8 memory

	conv	u8 [@value], ptr [@constant]
	breq	+1, u8 [@value], u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x23
	.data value
	.alignment	8
	res	8

positive: datum conversion from ptr memory to ptr memory

	conv	ptr [@value], ptr [@constant]
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from ptr memory to fun memory

	conv	fun [@value], ptr [@constant]
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0xff
	.data value
	.alignment	funsize
	res	funsize

positive: datum conversion from fun memory to s1 memory

	conv	s1 [@value], fun [@constant]
	breq	+1, s1 [@value], s1 -1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff
	.data value
	.alignment	1
	res	1

positive: datum conversion from fun memory to s2 memory

	conv	s2 [@value], fun [@constant]
	breq	+1, s2 [@value], s2 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff
	.data value
	.alignment	2
	res	2

positive: datum conversion from fun memory to s4 memory

	conv	s4 [@value], fun [@constant]
	breq	+1, s4 [@value], s4 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff
	.data value
	.alignment	4
	res	4

positive: datum conversion from fun memory to s8 memory

	conv	s8 [@value], fun [@constant]
	breq	+1, s8 [@value], s8 255
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff
	.data value
	.alignment	8
	res	8

positive: datum conversion from fun memory to u1 memory

	conv	u1 [@value], fun [@constant]
	breq	+1, u1 [@value], u1 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0x23
	.data value
	.alignment	1
	res	1

positive: datum conversion from fun memory to u2 memory

	conv	u2 [@value], fun [@constant]
	breq	+1, u2 [@value], u2 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0x23
	.data value
	.alignment	2
	res	2

positive: datum conversion from fun memory to u4 memory

	conv	u4 [@value], fun [@constant]
	breq	+1, u4 [@value], u4 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0x23
	.data value
	.alignment	4
	res	4

positive: datum conversion from fun memory to u8 memory

	conv	u8 [@value], fun [@constant]
	breq	+1, u8 [@value], u8 0x23
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0x23
	.data value
	.alignment	8
	res	8

positive: datum conversion from fun memory to ptr memory

	conv	ptr [@value], fun [@constant]
	breq	+1, ptr [@value], ptr 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: datum conversion from fun memory to fun memory

	conv	fun [@value], fun [@constant]
	breq	+1, fun [@value], fun 0xff
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun 0xff
	.data value
	.alignment	funsize
	res	funsize

# copy instruction

positive: data copy from immediate to immediate using immediate size

	copy	ptr @destdata, ptr @sourcedata, ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from register to immediate using immediate size

	mov	ptr $1, ptr @sourcedata
	copy	ptr @destdata, ptr $1, ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from memory to immediate using immediate size

	copy	ptr @destdata, ptr [@sourcedata], ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from immediate to register using immediate size

	mov	ptr $0, ptr @destdata
	copy	ptr $0, ptr @sourcedata, ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from register to register using immediate size

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr @sourcedata
	copy	ptr $0, ptr $1, ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from memory to register using immediate size

	mov	ptr $0, ptr @destdata
	copy	ptr $0, ptr [@sourcedata], ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from immediate to memory using immediate size

	copy	ptr [@sourcedata + ptrsize], ptr @sourcedata, ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from register to memory using immediate size

	mov	ptr $1, ptr @sourcedata
	copy	ptr [@sourcedata + ptrsize], ptr $1, ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from memory to memory using immediate size

	copy	ptr [@sourcedata + ptrsize], ptr [@sourcedata], ptr ptrsize * 2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from immediate to immediate using register size

	mov	ptr $2, ptr ptrsize * 2
	copy	ptr @destdata, ptr @sourcedata, ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from register to immediate using register size

	mov	ptr $1, ptr @sourcedata
	mov	ptr $2, ptr ptrsize * 2
	copy	ptr @destdata, ptr $1, ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from memory to immediate using register size

	mov	ptr $2, ptr ptrsize * 2
	copy	ptr @destdata, ptr [@sourcedata], ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from immediate to register using register size

	mov	ptr $0, ptr @destdata
	mov	ptr $2, ptr ptrsize * 2
	copy	ptr $0, ptr @sourcedata, ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from register to register using register size

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr @sourcedata
	mov	ptr $2, ptr ptrsize * 2
	copy	ptr $0, ptr $1, ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from memory to register using register size

	mov	ptr $0, ptr @destdata
	mov	ptr $2, ptr ptrsize * 2
	copy	ptr $0, ptr [@sourcedata], ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from immediate to memory using register size

	mov	ptr $2, ptr ptrsize * 2
	copy	ptr [@sourcedata + ptrsize], ptr @sourcedata, ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from register to memory using register size

	mov	ptr $1, ptr @sourcedata
	mov	ptr $2, ptr ptrsize * 2
	copy	ptr [@sourcedata + ptrsize], ptr $1, ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from memory to memory using register size

	mov	ptr $2, ptr ptrsize * 2
	copy	ptr [@sourcedata + ptrsize], ptr [@sourcedata], ptr $2
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data copy from immediate to immediate using memory size

	copy	ptr @destdata, ptr @sourcedata, ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

positive: data copy from register to immediate using memory size

	mov	ptr $1, ptr @sourcedata
	copy	ptr @destdata, ptr $1, ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

positive: data copy from memory to immediate using memory size

	copy	ptr @destdata, ptr [@sourcedata], ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

positive: data copy from immediate to register using memory size

	mov	ptr $0, ptr @destdata
	copy	ptr $0, ptr @sourcedata, ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

positive: data copy from register to register using memory size

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr @sourcedata
	copy	ptr $0, ptr $1, ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

positive: data copy from memory to register using memory size

	mov	ptr $0, ptr @destdata
	copy	ptr $0, ptr [@sourcedata], ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

positive: data copy from immediate to memory using memory size

	copy	ptr [@sourcedata + ptrsize], ptr @sourcedata, ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

positive: data copy from register to memory using memory size

	mov	ptr $1, ptr @sourcedata
	copy	ptr [@sourcedata + ptrsize], ptr $1, ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

positive: data copy from memory to memory using memory size

	copy	ptr [@sourcedata + ptrsize], ptr [@sourcedata], ptr [@size]
	brne	+1, ptr [@destdata], ptr [@sourcedata]
	breq	+1, ptr [@destdata + ptrsize], ptr [@sourcedata + ptrsize]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const sourcedata
	.alignment	ptrsize
	def	ptr @sourcedata
	def	ptr @destdata
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr ptrsize * 2

# fill instruction

positive: data initialization of immediate address using immediate size and immediate s1 value

	fill	ptr @destdata, ptr 2, s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of register address using immediate size and immediate s1 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of memory address using immediate size and immediate s1 value

	fill	ptr [@address], ptr 2, s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate s1 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of register address using register size and immediate s1 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of memory address using register size and immediate s1 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate s1 value

	fill	ptr @destdata, ptr [@size], s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate s1 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate s1 value

	fill	ptr [@address], ptr [@size], s1 -105
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register s1 value

	mov	s1 $2, s1 -105
	fill	ptr @destdata, ptr 2, s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of register address using immediate size and register s1 value

	mov	ptr $0, ptr @destdata
	mov	s1 $2, s1 -105
	fill	ptr $0, ptr 2, s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of memory address using immediate size and register s1 value

	mov	s1 $2, s1 -105
	fill	ptr [@address], ptr 2, s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register s1 value

	mov	ptr $1, ptr 2
	mov	s1 $2, s1 -105
	fill	ptr @destdata, ptr $1, s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of register address using register size and register s1 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	s1 $2, s1 -105
	fill	ptr $0, ptr $1, s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of memory address using register size and register s1 value

	mov	ptr $1, ptr 2
	mov	s1 $2, s1 -105
	fill	ptr [@address], ptr $1, s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register s1 value

	mov	s1 $2, s1 -105
	fill	ptr @destdata, ptr [@size], s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register s1 value

	mov	s1 $2, s1 -105
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register s1 value

	mov	s1 $2, s1 -105
	fill	ptr [@address], ptr [@size], s1 $2
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory s1 value

	fill	ptr @destdata, ptr 2, s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of register address using immediate size and memory s1 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of memory address using immediate size and memory s1 value

	fill	ptr [@address], ptr 2, s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of immediate address using register size and memory s1 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of register address using register size and memory s1 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of memory address using register size and memory s1 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of immediate address using memory size and memory s1 value

	fill	ptr @destdata, ptr [@size], s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of register address using memory size and memory s1 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of memory address using memory size and memory s1 value

	fill	ptr [@address], ptr [@size], s1 [@value]
	brne	+1, s1 [@destdata], s1 -105
	breq	+1, s1 [@destdata + 1], s1 -105
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	1
	def	s1 -105

positive: data initialization of immediate address using immediate size and immediate s2 value

	fill	ptr @destdata, ptr 2, s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of register address using immediate size and immediate s2 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of memory address using immediate size and immediate s2 value

	fill	ptr [@address], ptr 2, s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate s2 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of register address using register size and immediate s2 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of memory address using register size and immediate s2 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate s2 value

	fill	ptr @destdata, ptr [@size], s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate s2 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate s2 value

	fill	ptr [@address], ptr [@size], s2 -23475
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register s2 value

	mov	s2 $2, s2 -23475
	fill	ptr @destdata, ptr 2, s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of register address using immediate size and register s2 value

	mov	ptr $0, ptr @destdata
	mov	s2 $2, s2 -23475
	fill	ptr $0, ptr 2, s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of memory address using immediate size and register s2 value

	mov	s2 $2, s2 -23475
	fill	ptr [@address], ptr 2, s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register s2 value

	mov	ptr $1, ptr 2
	mov	s2 $2, s2 -23475
	fill	ptr @destdata, ptr $1, s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of register address using register size and register s2 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	s2 $2, s2 -23475
	fill	ptr $0, ptr $1, s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of memory address using register size and register s2 value

	mov	ptr $1, ptr 2
	mov	s2 $2, s2 -23475
	fill	ptr [@address], ptr $1, s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register s2 value

	mov	s2 $2, s2 -23475
	fill	ptr @destdata, ptr [@size], s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register s2 value

	mov	s2 $2, s2 -23475
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register s2 value

	mov	s2 $2, s2 -23475
	fill	ptr [@address], ptr [@size], s2 $2
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory s2 value

	fill	ptr @destdata, ptr 2, s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of register address using immediate size and memory s2 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of memory address using immediate size and memory s2 value

	fill	ptr [@address], ptr 2, s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of immediate address using register size and memory s2 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of register address using register size and memory s2 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of memory address using register size and memory s2 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of immediate address using memory size and memory s2 value

	fill	ptr @destdata, ptr [@size], s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of register address using memory size and memory s2 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of memory address using memory size and memory s2 value

	fill	ptr [@address], ptr [@size], s2 [@value]
	brne	+1, s2 [@destdata], s2 -23475
	breq	+1, s2 [@destdata + 2], s2 -23475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	2
	def	s2 -23475

positive: data initialization of immediate address using immediate size and immediate s4 value

	fill	ptr @destdata, ptr 2, s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using immediate size and immediate s4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using immediate size and immediate s4 value

	fill	ptr [@address], ptr 2, s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate s4 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using register size and immediate s4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using register size and immediate s4 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate s4 value

	fill	ptr @destdata, ptr [@size], s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate s4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate s4 value

	fill	ptr [@address], ptr [@size], s4 -2010413478
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register s4 value

	mov	s4 $2, s4 -2010413478
	fill	ptr @destdata, ptr 2, s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using immediate size and register s4 value

	mov	ptr $0, ptr @destdata
	mov	s4 $2, s4 -2010413478
	fill	ptr $0, ptr 2, s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using immediate size and register s4 value

	mov	s4 $2, s4 -2010413478
	fill	ptr [@address], ptr 2, s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register s4 value

	mov	ptr $1, ptr 2
	mov	s4 $2, s4 -2010413478
	fill	ptr @destdata, ptr $1, s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using register size and register s4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	s4 $2, s4 -2010413478
	fill	ptr $0, ptr $1, s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using register size and register s4 value

	mov	ptr $1, ptr 2
	mov	s4 $2, s4 -2010413478
	fill	ptr [@address], ptr $1, s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register s4 value

	mov	s4 $2, s4 -2010413478
	fill	ptr @destdata, ptr [@size], s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register s4 value

	mov	s4 $2, s4 -2010413478
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register s4 value

	mov	s4 $2, s4 -2010413478
	fill	ptr [@address], ptr [@size], s4 $2
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory s4 value

	fill	ptr @destdata, ptr 2, s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of register address using immediate size and memory s4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of memory address using immediate size and memory s4 value

	fill	ptr [@address], ptr 2, s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data	destdata
	.alignment	8
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of immediate address using register size and memory s4 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of register address using register size and memory s4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of memory address using register size and memory s4 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of immediate address using memory size and memory s4 value

	fill	ptr @destdata, ptr [@size], s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of register address using memory size and memory s4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of memory address using memory size and memory s4 value

	fill	ptr [@address], ptr [@size], s4 [@value]
	brne	+1, s4 [@destdata], s4 -2010413478
	breq	+1, s4 [@destdata + 4], s4 -2010413478
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	s4 -2010413478

positive: data initialization of immediate address using immediate size and immediate s8 value

	fill	ptr @destdata, ptr 2, s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using immediate size and immediate s8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using immediate size and immediate s8 value

	fill	ptr [@address], ptr 2, s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate s8 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using register size and immediate s8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using register size and immediate s8 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate s8 value

	fill	ptr @destdata, ptr [@size], s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate s8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate s8 value

	fill	ptr [@address], ptr [@size], s8 -321325479879154654
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register s8 value

	mov	s8 $2, s8 -321325479879154654
	fill	ptr @destdata, ptr 2, s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using immediate size and register s8 value

	mov	ptr $0, ptr @destdata
	mov	s8 $2, s8 -321325479879154654
	fill	ptr $0, ptr 2, s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using immediate size and register s8 value

	mov	s8 $2, s8 -321325479879154654
	fill	ptr [@address], ptr 2, s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register s8 value

	mov	ptr $1, ptr 2
	mov	s8 $2, s8 -321325479879154654
	fill	ptr @destdata, ptr $1, s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using register size and register s8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	s8 $2, s8 -321325479879154654
	fill	ptr $0, ptr $1, s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using register size and register s8 value

	mov	ptr $1, ptr 2
	mov	s8 $2, s8 -321325479879154654
	fill	ptr [@address], ptr $1, s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register s8 value

	mov	s8 $2, s8 -321325479879154654
	fill	ptr @destdata, ptr [@size], s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register s8 value

	mov	s8 $2, s8 -321325479879154654
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register s8 value

	mov	s8 $2, s8 -321325479879154654
	fill	ptr [@address], ptr [@size], s8 $2
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory s8 value

	fill	ptr @destdata, ptr 2, s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of register address using immediate size and memory s8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of memory address using immediate size and memory s8 value

	fill	ptr [@address], ptr 2, s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of immediate address using register size and memory s8 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of register address using register size and memory s8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of memory address using register size and memory s8 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of immediate address using memory size and memory s8 value

	fill	ptr @destdata, ptr [@size], s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of register address using memory size and memory s8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of memory address using memory size and memory s8 value

	fill	ptr [@address], ptr [@size], s8 [@value]
	brne	+1, s8 [@destdata], s8 -321325479879154654
	breq	+1, s8 [@destdata + 8], s8 -321325479879154654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	s8 -321325479879154654

positive: data initialization of immediate address using immediate size and immediate u1 value

	fill	ptr @destdata, ptr 2, u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of register address using immediate size and immediate u1 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of memory address using immediate size and immediate u1 value

	fill	ptr [@address], ptr 2, u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate u1 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of register address using register size and immediate u1 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of memory address using register size and immediate u1 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate u1 value

	fill	ptr @destdata, ptr [@size], u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate u1 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate u1 value

	fill	ptr [@address], ptr [@size], u1 193
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register u1 value

	mov	u1 $2, u1 193
	fill	ptr @destdata, ptr 2, u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of register address using immediate size and register u1 value

	mov	ptr $0, ptr @destdata
	mov	u1 $2, u1 193
	fill	ptr $0, ptr 2, u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of memory address using immediate size and register u1 value

	mov	u1 $2, u1 193
	fill	ptr [@address], ptr 2, u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register u1 value

	mov	ptr $1, ptr 2
	mov	u1 $2, u1 193
	fill	ptr @destdata, ptr $1, u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of register address using register size and register u1 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	u1 $2, u1 193
	fill	ptr $0, ptr $1, u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2

positive: data initialization of memory address using register size and register u1 value

	mov	ptr $1, ptr 2
	mov	u1 $2, u1 193
	fill	ptr [@address], ptr $1, u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register u1 value

	mov	u1 $2, u1 193
	fill	ptr @destdata, ptr [@size], u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register u1 value

	mov	u1 $2, u1 193
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register u1 value

	mov	u1 $2, u1 193
	fill	ptr [@address], ptr [@size], u1 $2
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory u1 value

	fill	ptr @destdata, ptr 2, u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of register address using immediate size and memory u1 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of memory address using immediate size and memory u1 value

	fill	ptr [@address], ptr 2, u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of immediate address using register size and memory u1 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of register address using register size and memory u1 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of memory address using register size and memory u1 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of immediate address using memory size and memory u1 value

	fill	ptr @destdata, ptr [@size], u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of register address using memory size and memory u1 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of memory address using memory size and memory u1 value

	fill	ptr [@address], ptr [@size], u1 [@value]
	brne	+1, u1 [@destdata], u1 193
	breq	+1, u1 [@destdata + 1], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	1
	res	2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	1
	def	u1 193

positive: data initialization of immediate address using immediate size and immediate u2 value

	fill	ptr @destdata, ptr 2, u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of register address using immediate size and immediate u2 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of memory address using immediate size and immediate u2 value

	fill	ptr [@address], ptr 2, u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate u2 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of register address using register size and immediate u2 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of memory address using register size and immediate u2 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate u2 value

	fill	ptr @destdata, ptr [@size], u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate u2 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate u2 value

	fill	ptr [@address], ptr [@size], u2 46872
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register u2 value

	mov	u2 $2, u2 46872
	fill	ptr @destdata, ptr 2, u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of register address using immediate size and register u2 value

	mov	ptr $0, ptr @destdata
	mov	u2 $2, u2 46872
	fill	ptr $0, ptr 2, u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of memory address using immediate size and register u2 value

	mov	u2 $2, u2 46872
	fill	ptr [@address], ptr 2, u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register u2 value

	mov	ptr $1, ptr 2
	mov	u2 $2, u2 46872
	fill	ptr @destdata, ptr $1, u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of register address using register size and register u2 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	u2 $2, u2 46872
	fill	ptr $0, ptr $1, u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4

positive: data initialization of memory address using register size and register u2 value

	mov	ptr $1, ptr 2
	mov	u2 $2, u2 46872
	fill	ptr [@address], ptr $1, u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register u2 value

	mov	u2 $2, u2 46872
	fill	ptr @destdata, ptr [@size], u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register u2 value

	mov	u2 $2, u2 46872
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register u2 value

	mov	u2 $2, u2 46872
	fill	ptr [@address], ptr [@size], u2 $2
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory u2 value

	fill	ptr @destdata, ptr 2, u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of register address using immediate size and memory u2 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of memory address using immediate size and memory u2 value

	fill	ptr [@address], ptr 2, u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of immediate address using register size and memory u2 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of register address using register size and memory u2 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of memory address using register size and memory u2 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of immediate address using memory size and memory u2 value

	fill	ptr @destdata, ptr [@size], u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of register address using memory size and memory u2 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of memory address using memory size and memory u2 value

	fill	ptr [@address], ptr [@size], u2 [@value]
	brne	+1, u2 [@destdata], u2 46872
	breq	+1, u2 [@destdata + 2], u2 46872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	2
	res	4
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	2
	def	u2 46872

positive: data initialization of immediate address using immediate size and immediate u4 value

	fill	ptr @destdata, ptr 2, u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using immediate size and immediate u4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using immediate size and immediate u4 value

	fill	ptr [@address], ptr 2, u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate u4 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using register size and immediate u4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using register size and immediate u4 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate u4 value

	fill	ptr @destdata, ptr [@size], u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate u4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate u4 value

	fill	ptr [@address], ptr [@size], u4 3496879874
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register u4 value

	mov	u4 $2, u4 3496879874
	fill	ptr @destdata, ptr 2, u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using immediate size and register u4 value

	mov	ptr $0, ptr @destdata
	mov	u4 $2, u4 3496879874
	fill	ptr $0, ptr 2, u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using immediate size and register u4 value

	mov	u4 $2, u4 3496879874
	fill	ptr [@address], ptr 2, u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register u4 value

	mov	ptr $1, ptr 2
	mov	u4 $2, u4 3496879874
	fill	ptr @destdata, ptr $1, u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using register size and register u4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	u4 $2, u4 3496879874
	fill	ptr $0, ptr $1, u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using register size and register u4 value

	mov	ptr $1, ptr 2
	mov	u4 $2, u4 3496879874
	fill	ptr [@address], ptr $1, u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register u4 value

	mov	u4 $2, u4 3496879874
	fill	ptr @destdata, ptr [@size], u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register u4 value

	mov	u4 $2, u4 3496879874
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register u4 value

	mov	u4 $2, u4 3496879874
	fill	ptr [@address], ptr [@size], u4 $2
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory u4 value

	fill	ptr @destdata, ptr 2, u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of register address using immediate size and memory u4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of memory address using immediate size and memory u4 value

	fill	ptr [@address], ptr 2, u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of immediate address using register size and memory u4 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of register address using register size and memory u4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of memory address using register size and memory u4 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of immediate address using memory size and memory u4 value

	fill	ptr @destdata, ptr [@size], u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of register address using memory size and memory u4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of memory address using memory size and memory u4 value

	fill	ptr [@address], ptr [@size], u4 [@value]
	brne	+1, u4 [@destdata], u4 3496879874
	breq	+1, u4 [@destdata + 4], u4 3496879874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	u4 3496879874

positive: data initialization of immediate address using immediate size and immediate u8 value

	fill	ptr @destdata, ptr 2, u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using immediate size and immediate u8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using immediate size and immediate u8 value

	fill	ptr [@address], ptr 2, u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate u8 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using register size and immediate u8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using register size and immediate u8 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate u8 value

	fill	ptr @destdata, ptr [@size], u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate u8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate u8 value

	fill	ptr [@address], ptr [@size], u8 465432198765132135
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data	destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register u8 value

	mov	u8 $2, u8 465432198765132135
	fill	ptr @destdata, ptr 2, u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using immediate size and register u8 value

	mov	ptr $0, ptr @destdata
	mov	u8 $2, u8 465432198765132135
	fill	ptr $0, ptr 2, u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using immediate size and register u8 value

	mov	u8 $2, u8 465432198765132135
	fill	ptr [@address], ptr 2, u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register u8 value

	mov	ptr $1, ptr 2
	mov	u8 $2, u8 465432198765132135
	fill	ptr @destdata, ptr $1, u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using register size and register u8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	u8 $2, u8 465432198765132135
	fill	ptr $0, ptr $1, u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using register size and register u8 value

	mov	ptr $1, ptr 2
	mov	u8 $2, u8 465432198765132135
	fill	ptr [@address], ptr $1, u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register u8 value

	mov	u8 $2, u8 465432198765132135
	fill	ptr @destdata, ptr [@size], u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register u8 value

	mov	u8 $2, u8 465432198765132135
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register u8 value

	mov	u8 $2, u8 465432198765132135
	fill	ptr [@address], ptr [@size], u8 $2
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory u8 value

	fill	ptr @destdata, ptr 2, u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of register address using immediate size and memory u8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of memory address using immediate size and memory u8 value

	fill	ptr [@address], ptr 2, u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of immediate address using register size and memory u8 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of register address using register size and memory u8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of memory address using register size and memory u8 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of immediate address using memory size and memory u8 value

	fill	ptr @destdata, ptr [@size], u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of register address using memory size and memory u8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of memory address using memory size and memory u8 value

	fill	ptr [@address], ptr [@size], u8 [@value]
	brne	+1, u8 [@destdata], u8 465432198765132135
	breq	+1, u8 [@destdata + 8], u8 465432198765132135
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	u8 465432198765132135

positive: data initialization of immediate address using immediate size and immediate f4 value

	fill	ptr @destdata, ptr 2, f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using immediate size and immediate f4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using immediate size and immediate f4 value

	fill	ptr [@address], ptr 2, f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate f4 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using register size and immediate f4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using register size and immediate f4 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate f4 value

	fill	ptr @destdata, ptr [@size], f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate f4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate f4 value

	fill	ptr [@address], ptr [@size], f4 5.25
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register f4 value

	mov	f4 $2, f4 5.25
	fill	ptr @destdata, ptr 2, f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using immediate size and register f4 value

	mov	ptr $0, ptr @destdata
	mov	f4 $2, f4 5.25
	fill	ptr $0, ptr 2, f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using immediate size and register f4 value

	mov	f4 $2, f4 5.25
	fill	ptr [@address], ptr 2, f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register f4 value

	mov	ptr $1, ptr 2
	mov	f4 $2, f4 5.25
	fill	ptr @destdata, ptr $1, f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of register address using register size and register f4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	f4 $2, f4 5.25
	fill	ptr $0, ptr $1, f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8

positive: data initialization of memory address using register size and register f4 value

	mov	ptr $1, ptr 2
	mov	f4 $2, f4 5.25
	fill	ptr [@address], ptr $1, f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register f4 value

	mov	f4 $2, f4 5.25
	fill	ptr @destdata, ptr [@size], f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register f4 value

	mov	f4 $2, f4 5.25
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register f4 value

	mov	f4 $2, f4 5.25
	fill	ptr [@address], ptr [@size], f4 $2
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory f4 value

	fill	ptr @destdata, ptr 2, f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of register address using immediate size and memory f4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of memory address using immediate size and memory f4 value

	fill	ptr [@address], ptr 2, f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of immediate address using register size and memory f4 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of register address using register size and memory f4 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of memory address using register size and memory f4 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of immediate address using memory size and memory f4 value

	fill	ptr @destdata, ptr [@size], f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of register address using memory size and memory f4 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of memory address using memory size and memory f4 value

	fill	ptr [@address], ptr [@size], f4 [@value]
	brne	+1, f4 [@destdata], f4 5.25
	breq	+1, f4 [@destdata + 4], f4 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	4
	res	8
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	4
	def	f4 5.25

positive: data initialization of immediate address using immediate size and immediate f8 value

	fill	ptr @destdata, ptr 2, f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using immediate size and immediate f8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using immediate size and immediate f8 value

	fill	ptr [@address], ptr 2, f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate f8 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using register size and immediate f8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using register size and immediate f8 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate f8 value

	fill	ptr @destdata, ptr [@size], f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate f8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate f8 value

	fill	ptr [@address], ptr [@size], f8 -6.75
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register f8 value

	mov	f8 $2, f8 -6.75
	fill	ptr @destdata, ptr 2, f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using immediate size and register f8 value

	mov	ptr $0, ptr @destdata
	mov	f8 $2, f8 -6.75
	fill	ptr $0, ptr 2, f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using immediate size and register f8 value

	mov	f8 $2, f8 -6.75
	fill	ptr [@address], ptr 2, f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register f8 value

	mov	ptr $1, ptr 2
	mov	f8 $2, f8 -6.75
	fill	ptr @destdata, ptr $1, f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of register address using register size and register f8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	f8 $2, f8 -6.75
	fill	ptr $0, ptr $1, f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16

positive: data initialization of memory address using register size and register f8 value

	mov	ptr $1, ptr 2
	mov	f8 $2, f8 -6.75
	fill	ptr [@address], ptr $1, f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register f8 value

	mov	f8 $2, f8 -6.75
	fill	ptr @destdata, ptr [@size], f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register f8 value

	mov	f8 $2, f8 -6.75
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register f8 value

	mov	f8 $2, f8 -6.75
	fill	ptr [@address], ptr [@size], f8 $2
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory f8 value

	fill	ptr @destdata, ptr 2, f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of register address using immediate size and memory f8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of memory address using immediate size and memory f8 value

	fill	ptr [@address], ptr 2, f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of immediate address using register size and memory f8 value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of register address using register size and memory f8 value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of memory address using register size and memory f8 value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of immediate address using memory size and memory f8 value

	fill	ptr @destdata, ptr [@size], f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of register address using memory size and memory f8 value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of memory address using memory size and memory f8 value

	fill	ptr [@address], ptr [@size], f8 [@value]
	brne	+1, f8 [@destdata], f8 -6.75
	breq	+1, f8 [@destdata + 8], f8 -6.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	16
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	8
	def	f8 -6.75

positive: data initialization of immediate address using immediate size and immediate ptr value

	fill	ptr @destdata, ptr 2, ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data initialization of register address using immediate size and immediate ptr value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data initialization of memory address using immediate size and immediate ptr value

	fill	ptr [@address], ptr 2, ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate ptr value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data initialization of register address using register size and immediate ptr value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data initialization of memory address using register size and immediate ptr value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate ptr value

	fill	ptr @destdata, ptr [@size], ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate ptr value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate ptr value

	fill	ptr [@address], ptr [@size], ptr @destdata + 79
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register ptr value

	mov	ptr $2, ptr @destdata + 79
	fill	ptr @destdata, ptr 2, ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data initialization of register address using immediate size and register ptr value

	mov	ptr $0, ptr @destdata
	mov	ptr $2, ptr @destdata + 79
	fill	ptr $0, ptr 2, ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data initialization of memory address using immediate size and register ptr value

	mov	ptr $2, ptr @destdata + 79
	fill	ptr [@address], ptr 2, ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register ptr value

	mov	ptr $1, ptr 2
	mov	ptr $2, ptr @destdata + 79
	fill	ptr @destdata, ptr $1, ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data initialization of register address using register size and register ptr value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	ptr $2, ptr @destdata + 79
	fill	ptr $0, ptr $1, ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2

positive: data initialization of memory address using register size and register ptr value

	mov	ptr $1, ptr 2
	mov	ptr $2, ptr @destdata + 79
	fill	ptr [@address], ptr $1, ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register ptr value

	mov	ptr $2, ptr @destdata + 79
	fill	ptr @destdata, ptr [@size], ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register ptr value

	mov	ptr $2, ptr @destdata + 79
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register ptr value

	mov	ptr $2, ptr @destdata + 79
	fill	ptr [@address], ptr [@size], ptr $2
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory ptr value

	fill	ptr @destdata, ptr 2, ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of register address using immediate size and memory ptr value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of memory address using immediate size and memory ptr value

	fill	ptr [@address], ptr 2, ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of immediate address using register size and memory ptr value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of register address using register size and memory ptr value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of memory address using register size and memory ptr value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of immediate address using memory size and memory ptr value

	fill	ptr @destdata, ptr [@size], ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of register address using memory size and memory ptr value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of memory address using memory size and memory ptr value

	fill	ptr [@address], ptr [@size], ptr [@value]
	brne	+1, ptr [@destdata], ptr @destdata + 79
	breq	+1, ptr [@destdata + ptrsize], ptr @destdata + 79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	ptrsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	ptrsize
	def	ptr @destdata + 79

positive: data initialization of immediate address using immediate size and immediate fun value

	fill	ptr @destdata, ptr 2, fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2

positive: data initialization of register address using immediate size and immediate fun value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2

positive: data initialization of memory address using immediate size and immediate fun value

	fill	ptr [@address], ptr 2, fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and immediate fun value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2

positive: data initialization of register address using register size and immediate fun value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2

positive: data initialization of memory address using register size and immediate fun value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using memory size and immediate fun value

	fill	ptr @destdata, ptr [@size], fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and immediate fun value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and immediate fun value

	fill	ptr [@address], ptr [@size], fun @main
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and register fun value

	mov	fun $2, fun @main
	fill	ptr @destdata, ptr 2, fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2

positive: data initialization of register address using immediate size and register fun value

	mov	ptr $0, ptr @destdata
	mov	fun $2, fun @main
	fill	ptr $0, ptr 2, fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2

positive: data initialization of memory address using immediate size and register fun value

	mov	fun $2, fun @main
	fill	ptr [@address], ptr 2, fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata

positive: data initialization of immediate address using register size and register fun value

	mov	ptr $1, ptr 2
	mov	fun $2, fun @main
	fill	ptr @destdata, ptr $1, fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2

positive: data initialization of register address using register size and register fun value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	mov	fun $2, fun @main
	fill	ptr $0, ptr $1, fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2

positive: data initialization of memory address using register size and register fun value

	mov	ptr $1, ptr 2
	mov	fun $2, fun @main
	fill	ptr [@address], ptr $1, fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using memory size and register fun value

	mov	fun $2, fun @main
	fill	ptr @destdata, ptr [@size], fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of register address using memory size and register fun value

	mov	fun $2, fun @main
	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of memory address using memory size and register fun value

	mov	fun $2, fun @main
	fill	ptr [@address], ptr [@size], fun $2
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2

positive: data initialization of immediate address using immediate size and memory fun value

	fill	ptr @destdata, ptr 2, fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const value
	.alignment	funsize
	def	fun @main

positive: data initialization of register address using immediate size and memory fun value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr 2, fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const value
	.alignment	funsize
	def	fun @main

positive: data initialization of memory address using immediate size and memory fun value

	fill	ptr [@address], ptr 2, fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	funsize
	def	fun @main

positive: data initialization of immediate address using register size and memory fun value

	mov	ptr $1, ptr 2
	fill	ptr @destdata, ptr $1, fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const value
	.alignment	funsize
	def	fun @main

positive: data initialization of register address using register size and memory fun value

	mov	ptr $0, ptr @destdata
	mov	ptr $1, ptr 2
	fill	ptr $0, ptr $1, fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const value
	.alignment	funsize
	def	fun @main

positive: data initialization of memory address using register size and memory fun value

	mov	ptr $1, ptr 2
	fill	ptr [@address], ptr $1, fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const value
	.alignment	funsize
	def	fun @main

positive: data initialization of immediate address using memory size and memory fun value

	fill	ptr @destdata, ptr [@size], fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	funsize
	def	fun @main

positive: data initialization of register address using memory size and memory fun value

	mov	ptr $0, ptr @destdata
	fill	ptr $0, ptr [@size], fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	funsize
	def	fun @main

positive: data initialization of memory address using memory size and memory fun value

	fill	ptr [@address], ptr [@size], fun [@value]
	brne	+1, fun [@destdata], fun @main
	breq	+1, fun [@destdata + funsize], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data destdata
	.alignment	8
	res	funsize * 2
	.const address
	.alignment	ptrsize
	def	ptr @destdata
	.const size
	.alignment	ptrsize
	def	ptr 2
	.const value
	.alignment	funsize
	def	fun @main

# neg instruction

positive: negation of s1 immediate to register

	neg	s1 $0, s1 -5
	breq	+1, s1 $0, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of s2 immediate to register

	neg	s2 $0, s2 5647
	breq	+1, s2 $0, s2 -5647
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of s4 immediate to register

	neg	s4 $0, s4 9879871
	breq	+1, s4 $0, s4 -9879871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of s8 immediate to register

	neg	s8 $0, s8 15489798753157871
	breq	+1, s8 $0, s8 -15489798753157871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of u1 immediate to register

	neg	u1 $0, u1 5
	breq	+1, u1 $0, u1 251
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of u2 immediate to register

	neg	u2 $0, u2 5724
	breq	+1, u2 $0, u2 59812
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of u4 immediate to register

	neg	u4 $0, u4 3272893938
	breq	+1, u4 $0, u4 1022073358
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of u8 immediate to register

	neg	u8 $0, u8 8218478754354321321
	breq	+1, u8 $0, u8 10228265319355230295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of f4 immediate to register

	neg	f4 $0, f4 1.25
	breq	+1, f4 $0, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of f8 immediate to register

	neg	f8 $0, f8 1.25
	breq	+1, f8 $0, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of s1 register to register

	mov	s1 $0, s1 -5
	neg	s1 $1, s1 $0
	breq	+1, s1 $1, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of s2 register to register

	mov	s2 $0, s2 5647
	neg	s2 $1, s2 $0
	breq	+1, s2 $1, s2 -5647
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of s4 register to register

	mov	s4 $0, s4 9879871
	neg	s4 $1, s4 $0
	breq	+1, s4 $1, s4 -9879871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of s8 register to register

	mov	s8 $0, s8 138092600249810944
	neg	s8 $1, s8 $0
	breq	+1, s8 $1, s8 -138092600249810944
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of u1 register to register

	mov	u1 $0, u1 5
	neg	u1 $0, u1 $0
	breq	+1, u1 $0, u1 251
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of u2 register to register

	mov	u2 $0, u2 5724
	neg	u2 $0, u2 $0
	breq	+1, u2 $0, u2 59812
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of u4 register to register

	mov	u4 $0, u4 3272893938
	neg	u4 $0, u4 $0
	breq	+1, u4 $0, u4 1022073358
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of u8 register to register

	neg	u8 $0, u8 8218478754354321321
	mov	u8 $0, u8 $0
	breq	+1, u8 $0, u8 10228265319355230295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of f4 register to register

	mov	f4 $0, f4 1.25
	neg	f4 $1, f4 $0
	breq	+1, f4 $1, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of f8 register to register

	mov	f8 $0, f8 1.25
	neg	f8 $1, f8 $0
	breq	+1, f8 $1, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: negation of s1 memory to register

	neg	s1 $0, s1 [@constant]
	breq	+1, s1 $0, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -5

positive: negation of s2 memory to register

	neg	s2 $0, s2 [@constant]
	breq	+1, s2 $0, s2 -5647
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 5647

positive: negation of s4 memory to register

	neg	s4 $0, s4 [@constant]
	breq	+1, s4 $0, s4 -9879871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 9879871

positive: negation of s8 memory to register

	neg	s8 $0, s8 [@constant]
	breq	+1, s8 $0, s8 -15489798753157871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 15489798753157871

positive: negation of u1 memory to register

	neg	u1 $0, u1 [@constant]
	breq	+1, u1 $0, u1 251
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 5

positive: negation of u2 memory to register

	neg	u2 $0, u2 [@constant]
	breq	+1, u2 $0, u2 59812
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 5724

positive: negation of u4 memory to register

	neg	u4 $0, u4 [@constant]
	breq	+1, u4 $0, u4 1022073358
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 3272893938

positive: negation of u8 memory to register

	neg	u8 $0, u8 [@constant]
	breq	+1, u8 $0, u8 10228265319355230295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 8218478754354321321

positive: negation of f4 memory to register

	neg	f4 $0, f4 [@constant]
	breq	+1, f4 $0, f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 1.25

positive: negation of f8 memory to register

	neg	f8 $0, f8 [@constant]
	breq	+1, f8 $0, f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 1.25

positive: negation of s1 immediate to memory

	neg	s1 [@value], s1 -5
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: negation of s2 immediate to memory

	neg	s2 [@value], s2 5647
	breq	+1, s2 [@value], s2 -5647
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: negation of s4 immediate to memory

	neg	s4 [@value], s4 9879871
	breq	+1, s4 [@value], s4 -9879871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: negation of s8 immediate to memory

	neg	s8 [@value], s8 15489798753157871
	breq	+1, s8 [@value], s8 -15489798753157871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: negation of u1 immediate to memory

	neg	u1 [@value], u1 5
	breq	+1, u1 [@value], u1 251
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: negation of u2 immediate to memory

	neg	u2 [@value], u2 5724
	breq	+1, u2 [@value], u2 59812
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: negation of u4 immediate to memory

	neg	u4 [@value], u4 3272893938
	breq	+1, u4 [@value], u4 1022073358
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: negation of u8 immediate to memory

	neg	u8 [@value], u8 8218478754354321321
	breq	+1, u8 [@value], u8 10228265319355230295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: negation of f4 immediate to memory

	neg	f4 [@value], f4 1.25
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: negation of f8 immediate to memory

	neg	f8 [@value], f8 1.25
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: negation of s1 register to memory

	mov	s1 $0, s1 -5
	neg	s1 [@value], s1 $0
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: negation of s2 register to memory

	mov	s2 $0, s2 5647
	neg	s2 [@value], s2 $0
	breq	+1, s2 [@value], s2 -5647
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: negation of s4 register to memory

	mov	s4 $0, s4 9879871
	neg	s4 [@value], s4 $0
	breq	+1, s4 [@value], s4 -9879871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: negation of s8 register to memory

	mov	s8 $0, s8 15489798753157871
	neg	s8 [@value], s8 $0
	breq	+1, s8 [@value], s8 -15489798753157871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: negation of u1 register to memory

	mov	u1 $0, u1 5
	neg	u1 [@value], u1 $0
	breq	+1, u1 [@value], u1 251
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: negation of u2 register to memory

	mov	u2 $0, u2 5724
	neg	u2 [@value], u2 $0
	breq	+1, u2 [@value], u2 59812
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: negation of u4 register to memory

	mov	u4 $0, u4 3272893938
	neg	u4 [@value], u4 $0
	breq	+1, u4 [@value], u4 1022073358
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: negation of u8 register to memory

	mov	u8 $0, u8 8218478754354321321
	neg	u8 [@value], u8 $0
	breq	+1, u8 [@value], u8 10228265319355230295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: negation of f4 register to memory

	mov	f4 $0, f4 1.25
	neg	f4 [@value], f4 $0
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: negation of f8 register to memory

	mov	f8 $0, f8 1.25
	neg	f8 [@value], f8 $0
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: negation of s1 memory to memory

	neg	s1 [@value], s1 [@constant]
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -5
	.data value
	.alignment	1
	res	1

positive: negation of s2 memory to memory

	neg	s2 [@value], s2 [@constant]
	breq	+1, s2 [@value], s2 -5647
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 5647
	.data value
	.alignment	2
	res	2

positive: negation of s4 memory to memory

	neg	s4 [@value], s4 [@constant]
	breq	+1, s4 [@value], s4 -9879871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 9879871
	.data value
	.alignment	4
	res	4

positive: negation of s8 memory to memory

	neg	s8 [@value], s8 [@constant]
	breq	+1, s8 [@value], s8 -15489798753157871
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 15489798753157871
	.data value
	.alignment	8
	res	8

positive: negation of u1 memory to memory

	neg	u1 [@value], u1 [@constant]
	breq	+1, u1 [@value], u1 251
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 5
	.data value
	.alignment	1
	res	1

positive: negation of u2 memory to memory

	neg	u2 [@value], u2 [@constant]
	breq	+1, u2 [@value], u2 59812
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 5724
	.data value
	.alignment	2
	res	2

positive: negation of u4 memory to memory

	neg	u4 [@value], u4 [@constant]
	breq	+1, u4 [@value], u4 1022073358
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 3272893938
	.data value
	.alignment	4
	res	4

positive: negation of u8 memory to memory

	neg	u8 [@value], u8 [@constant]
	breq	+1, u8 [@value], u8 10228265319355230295
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 8218478754354321321
	.data value
	.alignment	8
	res	8

positive: negation of f4 memory to memory

	neg	f4 [@value], f4 [@constant]
	breq	+1, f4 [@value], f4 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 1.25
	.data value
	.alignment	4
	res	4

positive: negation of f8 memory to memory

	neg	f8 [@value], f8 [@constant]
	breq	+1, f8 [@value], f8 -1.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 1.25
	.data value
	.alignment	8
	res	8

# add instruction

positive: addition of s1 immediate and immediate to register

	add	s1 $0, s1 54, s1 -39
	breq	+1, s1 $0, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s2 immediate and immediate to register

	add	s2 $0, s2 -7224, s2 6479
	breq	+1, s2 $0, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s4 immediate and immediate to register

	add	s4 $0, s4 231014977, s4 98722224
	breq	+1, s4 $0, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s8 immediate and immediate to register

	add	s8 $0, s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 $0, s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u1 immediate and immediate to register

	add	u1 $0, u1 176, u1 17
	breq	+1, u1 $0, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u2 immediate and immediate to register

	add	u2 $0, u2 41774, u2 8764
	breq	+1, u2 $0, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u4 immediate and immediate to register

	add	u4 $0, u4 2965411179, u4 1132125457
	breq	+1, u4 $0, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u8 immediate and immediate to register

	add	u8 $0, u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 $0, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of f4 immediate and immediate to register

	add	f4 $0, f4 7.25, f4 4.5
	breq	+1, f4 $0, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of f8 immediate and immediate to register

	add	f8 $0, f8 6.5, f8 -1.25
	breq	+1, f8 $0, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of ptr immediate and immediate to register

	add	ptr $0, ptr 0x45, ptr 0x13
	breq	+1, ptr $0, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s1 register and immediate to register

	mov	s1 $0, s1 54
	add	s1 $1, s1 $0, s1 -39
	breq	+1, s1 $1, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s2 register and immediate to register

	mov	s2 $0, s2 -7224
	add	s2 $1, s2 $0, s2 6479
	breq	+1, s2 $1, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s4 register and immediate to register

	mov	s4 $0, s4 231014977
	add	s4 $1, s4 $0, s4 98722224
	breq	+1, s4 $1, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s8 register and immediate to register

	mov	s8 $0, s8 45135151321545
	add	s8 $1, s8 $0, s8 3142854833478
	breq	+1, s8 $1, s8 48278006155023
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u1 register and immediate to register

	mov	u1 $0, u1 176
	add	u1 $1, u1 $0, u1 17
	breq	+1, u1 $1, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u2 register and immediate to register

	mov	u2 $0, u2 41774
	add	u2 $1, u2 $0, u2 8764
	breq	+1, u2 $1, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u4 register and immediate to register

	mov	u4 $0, u4 2965411179
	add	u4 $1, u4 $0, u4 1132125457
	breq	+1, u4 $1, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u8 register and immediate to register

	mov	u8 $0, u8 1238769817629834628
	add	u8 $1, u8 $0, u8 898794512221454665
	breq	+1, u8 $1, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of f4 register and immediate to register

	mov	f4 $0, f4 7.25
	add	f4 $1, f4 $0, f4 4.5
	breq	+1, f4 $1, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of f8 register and immediate to register

	mov	f8 $0, f8 6.5
	add	f8 $1, f8 $0, f8 -1.25
	breq	+1, f8 $1, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of ptr register and immediate to register

	mov	ptr $0, ptr 0x45
	add	ptr $1, ptr $0, ptr 0x13
	breq	+1, ptr $1, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s1 memory and immediate to register

	add	s1 $0, s1 [@constant], s1 -39
	breq	+1, s1 $0, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: addition of s2 memory and immediate to register

	add	s2 $0, s2 [@constant], s2 6479
	breq	+1, s2 $0, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -7224

positive: addition of s4 memory and immediate to register

	add	s4 $0, s4 [@constant], s4 98722224
	breq	+1, s4 $0, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: addition of s8 memory and immediate to register

	add	s8 $0, s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 $0, s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: addition of u1 memory and immediate to register

	add	u1 $0, u1 [@constant], u1 17
	breq	+1, u1 $0, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: addition of u2 memory and immediate to register

	add	u2 $0, u2 [@constant], u2 8764
	breq	+1, u2 $0, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: addition of u4 memory and immediate to register

	add	u4 $0, u4 [@constant], u4 1132125457
	breq	+1, u4 $0, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: addition of u8 memory and immediate to register

	add	u8 $0, u8 [@constant], u8 898794512221454665
	breq	+1, u8 $0, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: addition of f4 memory and immediate to register

	add	f4 $0, f4 [@constant], f4 4.5
	breq	+1, f4 $0, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.25

positive: addition of f8 memory and immediate to register

	add	f8 $0, f8 [@constant], f8 -1.25
	breq	+1, f8 $0, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 6.5

positive: addition of ptr memory and immediate to register

	add	ptr $0, ptr [@constant], ptr 0x13
	breq	+1, ptr $0, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x45

positive: addition of s1 immediate and register to register

	mov	s1 $0, s1 -39
	add	s1 $1, s1 54, s1 $0
	breq	+1, s1 $1, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s2 immediate and register to register

	mov	s2 $0, s2 6479
	add	s2 $1, s2 -7224, s2 $0
	breq	+1, s2 $1, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s4 immediate and register to register

	mov	s4 $0, s4 98722224
	add	s4 $1, s4 231014977, s4 $0
	breq	+1, s4 $1, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s8 immediate and register to register

	mov	s8 $0, s8 -4546546313132132321
	add	s8 $1, s8 1238769817629834628, s8 $0
	breq	+1, s8 $1, s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u1 immediate and register to register

	mov	u1 $0, u1 17
	add	u1 $1, u1 176, u1 $0
	breq	+1, u1 $1, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u2 immediate and register to register

	mov	u2 $0, u2 8764
	add	u2 $1, u2 41774, u2 $0
	breq	+1, u2 $1, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u4 immediate and register to register

	mov	u4 $0, u4 1132125457
	add	u4 $1, u4 2965411179, u4 $0
	breq	+1, u4 $1, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u8 immediate and register to register

	mov	u8 $0, u8 898794512221454665
	add	u8 $1, u8 1238769817629834628, u8 $0
	breq	+1, u8 $1, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of f4 immediate and register to register

	mov	f4 $0, f4 4.5
	add	f4 $1, f4 7.25, f4 $0
	breq	+1, f4 $1, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of f8 immediate and register to register

	mov	f8 $0, f8 -1.25
	add	f8 $1, f8 6.5, f8 $0
	breq	+1, f8 $1, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of ptr immediate and register to register

	mov	ptr $0, ptr 0x13
	add	ptr $1, ptr 0x45, ptr $0
	breq	+1, ptr $1, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s1 register and register to register

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -39
	add	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s2 register and register to register

	mov	s2 $0, s2 -7224
	mov	s2 $1, s2 6479
	add	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s4 register and register to register

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	add	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s8 register and register to register

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	add	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u1 register and register to register

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	add	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u2 register and register to register

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	add	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u4 register and register to register

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	add	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of u8 register and register to register

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	add	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of f4 register and register to register

	mov	f4 $0, f4 7.25
	mov	f4 $1, f4 4.5
	add	f4 $2, f4 $0, f4 $1
	breq	+1, f4 $2, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of f8 register and register to register

	mov	f8 $0, f8 6.5
	mov	f8 $1, f8 -1.25
	add	f8 $2, f8 $0, f8 $1
	breq	+1, f8 $2, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of ptr register and register to register

	mov	ptr $0, ptr 0x45
	mov	ptr $1, ptr 0x13
	add	ptr $2, ptr $0, ptr $1
	breq	+1, ptr $2, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: addition of s1 memory and register to register

	mov	s1 $0, s1 -39
	add	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: addition of s2 memory and register to register

	mov	s2 $0, s2 6479
	add	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -7224

positive: addition of s4 memory and register to register

	mov	s4 $0, s4 98722224
	add	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: addition of s8 memory and register to register

	mov	s8 $0, s8 -4546546313132132321
	add	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: addition of u1 memory and register to register

	mov	u1 $0, u1 17
	add	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: addition of u2 memory and register to register

	mov	u2 $0, u2 8764
	add	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: addition of u4 memory and register to register

	mov	u4 $0, u4 1132125457
	add	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: addition of u8 memory and register to register

	mov	u8 $0, u8 898794512221454665
	add	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: addition of f4 memory and register to register

	mov	f4 $0, f4 4.5
	add	f4 $1, f4 [@constant], f4 $0
	breq	+1, f4 $1, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.25

positive: addition of f8 memory and register to register

	mov	f8 $0, f8 -1.25
	add	f8 $1, f8 [@constant], f8 $0
	breq	+1, f8 $1, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 6.5

positive: addition of ptr memory and register to register

	mov	ptr $0, ptr 0x13
	add	ptr $1, ptr [@constant], ptr $0
	breq	+1, ptr $1, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x45

positive: addition of s1 immediate and memory to register

	add	s1 $0, s1 54, s1 [@constant]
	breq	+1, s1 $0, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -39

positive: addition of s2 immediate and memory to register

	add	s2 $0, s2 -7224, s2 [@constant]
	breq	+1, s2 $0, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: addition of s4 immediate and memory to register

	add	s4 $0, s4 231014977, s4 [@constant]
	breq	+1, s4 $0, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: addition of s8 immediate and memory to register

	add	s8 $0, s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 $0, s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: addition of u1 immediate and memory to register

	add	u1 $0, u1 176, u1 [@constant]
	breq	+1, u1 $0, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: addition of u2 immediate and memory to register

	add	u2 $0, u2 41774, u2 [@constant]
	breq	+1, u2 $0, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: addition of u4 immediate and memory to register

	add	u4 $0, u4 2965411179, u4 [@constant]
	breq	+1, u4 $0, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: addition of u8 immediate and memory to register

	add	u8 $0, u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 $0, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: addition of f4 immediate and memory to register

	add	f4 $0, f4 7.25, f4 [@constant]
	breq	+1, f4 $0, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 4.5

positive: addition of f8 immediate and memory to register

	add	f8 $0, f8 6.5, f8 [@constant]
	breq	+1, f8 $0, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: addition of ptr immediate and memory to register

	add	ptr $0, ptr 0x45, ptr [@constant]
	breq	+1, ptr $0, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x13

positive: addition of s1 register and memory to register

	mov	s1 $0, s1 54
	add	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -39

positive: addition of s2 register and memory to register

	mov	s2 $0, s2 -7224
	add	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: addition of s4 register and memory to register

	mov	s4 $0, s4 231014977
	add	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: addition of s8 register and memory to register

	mov	s8 $0, s8 1238769817629834628
	add	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: addition of u1 register and memory to register

	mov	u1 $0, u1 176
	add	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: addition of u2 register and memory to register

	mov	u2 $0, u2 41774
	add	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: addition of u4 register and memory to register

	mov	u4 $0, u4 2965411179
	add	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: addition of u8 register and memory to register

	mov	u8 $0, u8 1238769817629834628
	add	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: addition of f4 register and memory to register

	mov	f4 $0, f4 7.25
	add	f4 $1, f4 $0, f4 [@constant]
	breq	+1, f4 $1, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 4.5

positive: addition of f8 register and memory to register

	mov	f8 $0, f8 6.5
	add	f8 $1, f8 $0, f8 [@constant]
	breq	+1, f8 $1, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: addition of ptr register and memory to register

	mov	ptr $0, ptr 0x45
	add	ptr $1, ptr $0, ptr [@constant]
	breq	+1, ptr $1, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x13

positive: addition of s1 memory and memory to register

	add	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -39

positive: addition of s2 memory and memory to register

	add	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -7224
	.const constant2
	.alignment	2
	def	s2 6479

positive: addition of s4 memory and memory to register

	add	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224

positive: addition of s8 memory and memory to register

	add	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321

positive: addition of u1 memory and memory to register

	add	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17

positive: addition of u2 memory and memory to register

	add	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764

positive: addition of u4 memory and memory to register

	add	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457

positive: addition of u8 memory and memory to register

	add	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665

positive: addition of f4 memory and memory to register

	add	f4 $0, f4 [@constant1], f4 [@constant2]
	breq	+1, f4 $0, f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 7.25
	.const constant2
	.alignment	4
	def	f4 4.5

positive: addition of f8 memory and memory to register

	add	f8 $0, f8 [@constant1], f8 [@constant2]
	breq	+1, f8 $0, f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 6.5
	.const constant2
	.alignment	8
	def	f8 -1.25

positive: addition of ptr memory and memory to register

	add	ptr $0, ptr [@constant1], ptr [@constant2]
	breq	+1, ptr $0, ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr 0x45
	.const constant2
	.alignment	ptrsize
	def	ptr 0x13

positive: addition of s1 immediate and immediate to memory

	add	s1 [@value], s1 54, s1 -39
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: addition of s2 immediate and immediate to memory

	add	s2 [@value], s2 -7224, s2 6479
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: addition of s4 immediate and immediate to memory

	add	s4 [@value], s4 231014977, s4 98722224
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of s8 immediate and immediate to memory

	add	s8 [@value], s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of u1 immediate and immediate to memory

	add	u1 [@value], u1 176, u1 17
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: addition of u2 immediate and immediate to memory

	add	u2 [@value], u2 41774, u2 8764
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: addition of u4 immediate and immediate to memory

	add	u4 [@value], u4 2965411179, u4 1132125457
	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of u8 immediate and immediate to memory

	add	u8 [@value], u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of f4 immediate and immediate to memory

	add	f4 [@value], f4 7.25, f4 4.5
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of f8 immediate and immediate to memory

	add	f8 [@value], f8 6.5, f8 -1.25
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of ptr immediate and immediate to memory

	add	ptr [@value], ptr 0x45, ptr 0x13
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: addition of s1 register and immediate to memory

	mov	s1 $0, s1 54
	add	s1 [@value], s1 $0, s1 -39
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: addition of s2 register and immediate to memory

	mov	s2 $0, s2 -7224
	add	s2 [@value], s2 $0, s2 6479
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: addition of s4 register and immediate to memory

	mov	s4 $0, s4 231014977
	add	s4 [@value], s4 $0, s4 98722224
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of s8 register and immediate to memory

	mov	s8 $0, s8 1238769817629834628
	add	s8 [@value], s8 $0, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of u1 register and immediate to memory

	mov	u1 $0, u1 176
	add	u1 [@value], u1 $0, u1 17
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: addition of u2 register and immediate to memory

	mov	u2 $0, u2 41774
	add	u2 [@value], u2 $0, u2 8764
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: addition of u4 register and immediate to memory

	mov	u4 $0, u4 2965411179
	add	u4 [@value], u4 $0, u4 1132125457
	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of u8 register and immediate to memory

	mov	u8 $0, u8 1238769817629834628
	add	u8 [@value], u8 $0, u8 898794512221454665
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of f4 register and immediate to memory

	mov	f4 $0, f4 7.25
	add	f4 [@value], f4 $0, f4 4.5
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of f8 register and immediate to memory

	mov	f8 $0, f8 6.5
	add	f8 [@value], f8 $0, f8 -1.25
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of ptr register and immediate to memory

	mov	ptr $0, ptr 0x45
	add	ptr [@value], ptr $0, ptr 0x13
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: addition of s1 memory and immediate to memory

	add	s1 [@value], s1 [@constant], s1 -39
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: addition of s2 memory and immediate to memory

	add	s2 [@value], s2 [@constant], s2 6479
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -7224
	.data value
	.alignment	2
	res	2

positive: addition of s4 memory and immediate to memory

	add	s4 [@value], s4 [@constant], s4 98722224
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: addition of s8 memory and immediate to memory

	add	s8 [@value], s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: addition of u1 memory and immediate to memory

	add	u1 [@value], u1 [@constant], u1 17
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: addition of u2 memory and immediate to memory

	add	u2 [@value], u2 [@constant], u2 8764
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: addition of u4 memory and immediate to memory

	add	u4 [@value], u4 [@constant], u4 1132125457
	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: addition of u8 memory and immediate to memory

	add	u8 [@value], u8 [@constant], u8 898794512221454665
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: addition of f4 memory and immediate to memory

	add	f4 [@value], f4 [@constant], f4 4.5
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.25
	.data value
	.alignment	4
	res	4

positive: addition of f8 memory and immediate to memory

	add	f8 [@value], f8 [@constant], f8 -1.25
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 6.5
	.data value
	.alignment	8
	res	8

positive: addition of ptr memory and immediate to memory

	add	ptr [@value], ptr [@constant], ptr 0x13
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x45
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: addition of s1 immediate and register to memory

	mov	s1 $0, s1 -39
	add	s1 [@value], s1 54, s1 $0
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: addition of s2 immediate and register to memory

	mov	s2 $0, s2 6479
	add	s2 [@value], s2 -7224, s2 $0
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: addition of s4 immediate and register to memory

	mov	s4 $0, s4 98722224
	add	s4 [@value], s4 231014977, s4 $0
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of s8 immediate and register to memory

	mov	s8 $0, s8 -4546546313132132321
	add	s8 [@value], s8 1238769817629834628, s8 $0
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of u1 immediate and register to memory

	mov	u1 $0, u1 17
	add	u1 [@value], u1 176, u1 $0
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: addition of u2 immediate and register to memory

	mov	u2 $0, u2 8764
	add	u2 [@value], u2 41774, u2 $0
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: addition of u4 immediate and register to memory

	mov	u4 $0, u4 1132125457
	add	u4 [@value], u4 2965411179, u4 $0
	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of u8 immediate and register to memory

	mov	u8 $0, u8 898794512221454665
	add	u8 [@value], u8 1238769817629834628, u8 $0
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of f4 immediate and register to memory

	mov	f4 $0, f4 4.5
	add	f4 [@value], f4 7.25, f4 $0
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of f8 immediate and register to memory

	mov	f8 $0, f8 -1.25
	add	f8 [@value], f8 6.5, f8 $0
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of ptr immediate and register to memory

	mov	ptr $0, ptr 0x13
	add	ptr [@value], ptr 0x45, ptr $0
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: addition of s1 register and register to memory

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -39
	add	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: addition of s2 register and register to memory

	mov	s2 $0, s2 -7224
	mov	s2 $1, s2 6479
	add	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: addition of s4 register and register to memory

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	add	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of s8 register and register to memory

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	add	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of u1 register and register to memory

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	add	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: addition of u2 register and register to memory

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	add	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: addition of u4 register and register to memory

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	add	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of u8 register and register to memory

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	add	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of f4 register and register to memory

	mov	f4 $0, f4 7.25
	mov	f4 $1, f4 4.5
	add	f4 [@value], f4 $0, f4 $1
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: addition of f8 register and register to memory

	mov	f8 $0, f8 6.5
	mov	f8 $1, f8 -1.25
	add	f8 [@value], f8 $0, f8 $1
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: addition of ptr register and register to memory

	mov	ptr $0, ptr 0x45
	mov	ptr $1, ptr 0x13
	add	ptr [@value], ptr $0, ptr $1
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: addition of s1 memory and register to memory

	mov	s1 $0, s1 -39
	add	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: addition of s2 memory and register to memory

	mov	s2 $0, s2 6479
	add	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -7224
	.data value
	.alignment	2
	res	2

positive: addition of s4 memory and register to memory

	mov	s4 $0, s4 98722224
	add	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: addition of s8 memory and register to memory

	mov	s8 $0, s8 -4546546313132132321
	add	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: addition of u1 memory and register to memory

	mov	u1 $0, u1 17
	add	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: addition of u2 memory and register to memory

	mov	u2 $0, u2 8764
	add	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: addition of u4 memory and register to memory

	mov	u4 $0, u4 1132125457
	add	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: addition of u8 memory and register to memory

	mov	u8 $0, u8 898794512221454665
	add	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: addition of f4 memory and register to memory

	mov	f4 $0, f4 4.5
	add	f4 [@value], f4 [@constant], f4 $0
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.25
	.data value
	.alignment	4
	res	4

positive: addition of f8 memory and register to memory

	mov	f8 $0, f8 -1.25
	add	f8 [@value], f8 [@constant], f8 $0
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 6.5
	.data value
	.alignment	8
	res	8

positive: addition of ptr memory and register to memory

	mov	ptr $0, ptr 0x13
	add	ptr [@value], ptr [@constant], ptr $0
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x45
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: addition of s1 immediate and memory to memory

	add	s1 [@value], s1 54, s1 [@constant]
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -39
	.data value
	.alignment	1
	res	1

positive: addition of s2 immediate and memory to memory

	add	s2 [@value], s2 -7224, s2 [@constant]
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: addition of s4 immediate and memory to memory

	add	s4 [@value], s4 231014977, s4 [@constant]
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: addition of s8 immediate and memory to memory

	add	s8 [@value], s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: addition of u1 immediate and memory to memory

	add	u1 [@value], u1 176, u1 [@constant]
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: addition of u2 immediate and memory to memory

	add	u2 [@value], u2 41774, u2 [@constant]
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: addition of u4 immediate and memory to memory

	add	u4 [@value], u4 2965411179, u4 [@constant]

	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: addition of u8 immediate and memory to memory

	add	u8 [@value], u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: addition of f4 immediate and memory to memory

	add	f4 [@value], f4 7.25, f4 [@constant]
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 4.5
	.data value
	.alignment	4
	res	4

positive: addition of f8 immediate and memory to memory

	add	f8 [@value], f8 6.5, f8 [@constant]
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: addition of ptr immediate and memory to memory

	add	ptr [@value], ptr 0x45, ptr [@constant]
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x13
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: addition of s1 register and memory to memory

	mov	s1 $0, s1 54
	add	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -39
	.data value
	.alignment	1
	res	1

positive: addition of s2 register and memory to memory

	mov	s2 $0, s2 -7224
	add	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: addition of s4 register and memory to memory

	mov	s4 $0, s4 231014977
	add	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: addition of s8 register and memory to memory

	mov	s8 $0, s8 1238769817629834628
	add	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: addition of u1 register and memory to memory

	mov	u1 $0, u1 176
	add	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: addition of u2 register and memory to memory

	mov	u2 $0, u2 41774
	add	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: addition of u4 register and memory to memory

	mov	u4 $0, u4 2965411179
	add	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: addition of u8 register and memory to memory

	mov	u8 $0, u8 1238769817629834628
	add	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: addition of f4 register and memory to memory

	mov	f4 $0, f4 7.25
	add	f4 [@value], f4 $0, f4 [@constant]
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 4.5
	.data value
	.alignment	4
	res	4

positive: addition of f8 register and memory to memory

	mov	f8 $0, f8 6.5
	add	f8 [@value], f8 $0, f8 [@constant]
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: addition of ptr register and memory to memory

	mov	ptr $0, ptr 0x45
	add	ptr [@value], ptr $0, ptr [@constant]
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x13
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: addition of s1 memory and memory to memory

	add	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 15
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -39
	.data value
	.alignment	1
	res	1

positive: addition of s2 memory and memory to memory

	add	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 -745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -7224
	.const constant2
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: addition of s4 memory and memory to memory

	add	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 329737201
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: addition of s8 memory and memory to memory

	add	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 -3307776495502297693
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: addition of u1 memory and memory to memory

	add	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 193
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: addition of u2 memory and memory to memory

	add	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 50538
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: addition of u4 memory and memory to memory

	add	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 4097536636
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: addition of u8 memory and memory to memory

	add	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 2137564329851289293
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: addition of f4 memory and memory to memory

	add	f4 [@value], f4 [@constant1], f4 [@constant2]
	breq	+1, f4 [@value], f4 11.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 7.25
	.const constant2
	.alignment	4
	def	f4 4.5
	.data value
	.alignment	4
	res	4

positive: addition of f8 memory and memory to memory

	add	f8 [@value], f8 [@constant1], f8 [@constant2]
	breq	+1, f8 [@value], f8 5.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 6.5
	.const constant2
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: addition of ptr memory and memory to memory

	add	ptr [@value], ptr [@constant1], ptr [@constant2]
	breq	+1, ptr [@value], ptr 0x58
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr 0x45
	.const constant2
	.alignment	ptrsize
	def	ptr 0x13
	.data value
	.alignment	ptrsize
	res	ptrsize

# sub instruction

positive: subtraction of s1 immediate from immediate to register

	sub	s1 $0, s1 54, s1 -39
	breq	+1, s1 $0, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s2 immediate from immediate to register

	sub	s2 $0, s2 -7224, s2 6479
	breq	+1, s2 $0, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s4 immediate from immediate to register

	sub	s4 $0, s4 231014977, s4 98722224
	breq	+1, s4 $0, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s8 immediate from immediate to register

	sub	s8 $0, s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 $0, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u1 immediate from immediate to register

	sub	u1 $0, u1 176, u1 17
	breq	+1, u1 $0, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u2 immediate from immediate to register

	sub	u2 $0, u2 41774, u2 8764
	breq	+1, u2 $0, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u4 immediate from immediate to register

	sub	u4 $0, u4 2965411179, u4 1132125457
	breq	+1, u4 $0, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u8 immediate from immediate to register

	sub	u8 $0, u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 $0, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of f4 immediate from immediate to register

	sub	f4 $0, f4 7.25, f4 4.5
	breq	+1, f4 $0, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of f8 immediate from immediate to register

	sub	f8 $0, f8 6.5, f8 -1.25
	breq	+1, f8 $0, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of ptr immediate from immediate to register

	sub	ptr $0, ptr 0x45, ptr 0x13
	breq	+1, ptr $0, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s1 immediate from register to register

	mov	s1 $0, s1 54
	sub	s1 $1, s1 $0, s1 -39
	breq	+1, s1 $1, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s2 immediate from register to register

	mov	s2 $0, s2 -7224
	sub	s2 $1, s2 $0, s2 6479
	breq	+1, s2 $1, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s4 immediate from register to register

	mov	s4 $0, s4 231014977
	sub	s4 $1, s4 $0, s4 98722224
	breq	+1, s4 $1, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s8 immediate from register to register

	mov	s8 $0, s8 1238769817629834628
	sub	s8 $1, s8 $0, s8 -4546546313132132321
	breq	+1, s8 $1, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u1 immediate from register to register

	mov	u1 $0, u1 176
	sub	u1 $1, u1 $0, u1 17
	breq	+1, u1 $1, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u2 immediate from register to register

	mov	u2 $0, u2 41774
	sub	u2 $1, u2 $0, u2 8764
	breq	+1, u2 $1, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u4 immediate from register to register

	mov	u4 $0, u4 2965411179
	sub	u4 $1, u4 $0, u4 1132125457
	breq	+1, u4 $1, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u8 immediate from register to register

	mov	u8 $0, u8 1238769817629834628
	sub	u8 $1, u8 $0, u8 898794512221454665
	breq	+1, u8 $1, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of f4 immediate from register to register

	mov	f4 $0, f4 7.25
	sub	f4 $1, f4 $0, f4 4.5
	breq	+1, f4 $1, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of f8 immediate from register to register

	mov	f8 $0, f8 6.5
	sub	f8 $1, f8 $0, f8 -1.25
	breq	+1, f8 $1, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of ptr immediate from register to register

	mov	ptr $0, ptr 0x45
	sub	ptr $1, ptr $0, ptr 0x13
	breq	+1, ptr $1, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s1 immediate from memory to register

	sub	s1 $0, s1 [@constant], s1 -39
	breq	+1, s1 $0, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: subtraction of s2 immediate from memory to register

	sub	s2 $0, s2 [@constant], s2 6479
	breq	+1, s2 $0, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -7224

positive: subtraction of s4 immediate from memory to register

	sub	s4 $0, s4 [@constant], s4 98722224
	breq	+1, s4 $0, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: subtraction of s8 immediate from memory to register

	sub	s8 $0, s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 $0, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: subtraction of u1 immediate from memory to register

	sub	u1 $0, u1 [@constant], u1 17
	breq	+1, u1 $0, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: subtraction of u2 immediate from memory to register

	sub	u2 $0, u2 [@constant], u2 8764
	breq	+1, u2 $0, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: subtraction of u4 immediate from memory to register

	sub	u4 $0, u4 [@constant], u4 1132125457
	breq	+1, u4 $0, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: subtraction of u8 immediate from memory to register

	sub	u8 $0, u8 [@constant], u8 898794512221454665
	breq	+1, u8 $0, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: subtraction of f4 immediate from memory to register

	sub	f4 $0, f4 [@constant], f4 4.5
	breq	+1, f4 $0, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.25

positive: subtraction of f8 immediate from memory to register

	sub	f8 $0, f8 [@constant], f8 -1.25
	breq	+1, f8 $0, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 6.5

positive: subtraction of ptr immediate from memory to register

	sub	ptr $0, ptr [@constant], ptr 0x13
	breq	+1, ptr $0, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x45

positive: subtraction of s1 register from immediate to register

	mov	s1 $0, s1 -39
	sub	s1 $1, s1 54, s1 $0
	breq	+1, s1 $1, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s2 register from immediate to register

	mov	s2 $0, s2 6479
	sub	s2 $1, s2 -7224, s2 $0
	breq	+1, s2 $1, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s4 register from immediate to register

	mov	s4 $0, s4 98722224
	sub	s4 $1, s4 231014977, s4 $0
	breq	+1, s4 $1, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s8 register from immediate to register

	mov	s8 $0, s8 -4546546313132132321
	sub	s8 $1, s8 1238769817629834628, s8 $0
	breq	+1, s8 $1, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u1 register from immediate to register

	mov	u1 $0, u1 17
	sub	u1 $1, u1 176, u1 $0
	breq	+1, u1 $1, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u2 register from immediate to register

	mov	u2 $0, u2 8764
	sub	u2 $1, u2 41774, u2 $0
	breq	+1, u2 $1, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u4 register from immediate to register

	mov	u4 $0, u4 1132125457
	sub	u4 $1, u4 2965411179, u4 $0
	breq	+1, u4 $1, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u8 register from immediate to register

	mov	u8 $0, u8 898794512221454665
	sub	u8 $1, u8 1238769817629834628, u8 $0
	breq	+1, u8 $1, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of f4 register from immediate to register

	mov	f4 $0, f4 4.5
	sub	f4 $1, f4 7.25, f4 $0
	breq	+1, f4 $1, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of f8 register from immediate to register

	mov	f8 $0, f8 -1.25
	sub	f8 $1, f8 6.5, f8 $0
	breq	+1, f8 $1, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of ptr register from immediate to register

	mov	ptr $0, ptr 0x13
	sub	ptr $1, ptr 0x45, ptr $0
	breq	+1, ptr $1, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s1 register from register to register

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -39
	sub	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s2 register from register to register

	mov	s2 $0, s2 -7224
	mov	s2 $1, s2 6479
	sub	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s4 register from register to register

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	sub	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s8 register from register to register

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	sub	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u1 register from register to register

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	sub	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u2 register from register to register

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	sub	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u4 register from register to register

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	sub	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of u8 register from register to register

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	sub	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of f4 register from register to register

	mov	f4 $0, f4 7.25
	mov	f4 $1, f4 4.5
	sub	f4 $2, f4 $0, f4 $1
	breq	+1, f4 $2, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of f8 register from register to register

	mov	f8 $0, f8 6.5
	mov	f8 $1, f8 -1.25
	sub	f8 $2, f8 $0, f8 $1
	breq	+1, f8 $2, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of ptr register from register to register

	mov	ptr $0, ptr 0x45
	mov	ptr $1, ptr 0x13
	sub	ptr $2, ptr $0, ptr $1
	breq	+1, ptr $2, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: subtraction of s1 register from memory to register

	mov	s1 $0, s1 -39
	sub	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: subtraction of s2 register from memory to register

	mov	s2 $0, s2 6479
	sub	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -7224

positive: subtraction of s4 register from memory to register

	mov	s4 $0, s4 98722224
	sub	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: subtraction of s8 register from memory to register

	mov	s8 $0, s8 -4546546313132132321
	sub	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: subtraction of u1 register from memory to register

	mov	u1 $0, u1 17
	sub	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: subtraction of u2 register from memory to register

	mov	u2 $0, u2 8764
	sub	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: subtraction of u4 register from memory to register

	mov	u4 $0, u4 1132125457
	sub	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: subtraction of u8 register from memory to register

	mov	u8 $0, u8 898794512221454665
	sub	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: subtraction of f4 register from memory to register

	mov	f4 $0, f4 4.5
	sub	f4 $1, f4 [@constant], f4 $0
	breq	+1, f4 $1, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.25

positive: subtraction of f8 register from memory to register

	mov	f8 $0, f8 -1.25
	sub	f8 $1, f8 [@constant], f8 $0
	breq	+1, f8 $1, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 6.5

positive: subtraction of ptr register from memory to register

	mov	ptr $0, ptr 0x13
	sub	ptr $1, ptr [@constant], ptr $0
	breq	+1, ptr $1, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x45

positive: subtraction of s1 memory from immediate to register

	sub	s1 $0, s1 54, s1 [@constant]
	breq	+1, s1 $0, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -39

positive: subtraction of s2 memory from immediate to register

	sub	s2 $0, s2 -7224, s2 [@constant]
	breq	+1, s2 $0, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: subtraction of s4 memory from immediate to register

	sub	s4 $0, s4 231014977, s4 [@constant]
	breq	+1, s4 $0, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: subtraction of s8 memory from immediate to register

	sub	s8 $0, s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 $0, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: subtraction of u1 memory from immediate to register

	sub	u1 $0, u1 176, u1 [@constant]
	breq	+1, u1 $0, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: subtraction of u2 memory from immediate to register

	sub	u2 $0, u2 41774, u2 [@constant]
	breq	+1, u2 $0, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: subtraction of u4 memory from immediate to register

	sub	u4 $0, u4 2965411179, u4 [@constant]
	breq	+1, u4 $0, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: subtraction of u8 memory from immediate to register

	sub	u8 $0, u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 $0, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: subtraction of f4 memory from immediate to register

	sub	f4 $0, f4 7.25, f4 [@constant]
	breq	+1, f4 $0, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 4.5

positive: subtraction of f8 memory from immediate to register

	sub	f8 $0, f8 6.5, f8 [@constant]
	breq	+1, f8 $0, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: subtraction of ptr memory from immediate to register

	sub	ptr $0, ptr 0x45, ptr [@constant]
	breq	+1, ptr $0, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x13

positive: subtraction of s1 memory from register to register

	mov	s1 $0, s1 54
	sub	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -39

positive: subtraction of s2 memory from register to register

	mov	s2 $0, s2 -7224
	sub	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: subtraction of s4 memory from register to register

	mov	s4 $0, s4 231014977
	sub	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: subtraction of s8 memory from register to register

	mov	s8 $0, s8 1238769817629834628
	sub	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: subtraction of u1 memory from register to register

	mov	u1 $0, u1 176
	sub	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: subtraction of u2 memory from register to register

	mov	u2 $0, u2 41774
	sub	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: subtraction of u4 memory from register to register

	mov	u4 $0, u4 2965411179
	sub	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: subtraction of u8 memory from register to register

	mov	u8 $0, u8 1238769817629834628
	sub	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: subtraction of f4 memory from register to register

	mov	f4 $0, f4 7.25
	sub	f4 $1, f4 $0, f4 [@constant]
	breq	+1, f4 $1, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 4.5

positive: subtraction of f8 memory from register to register

	mov	f8 $0, f8 6.5
	sub	f8 $1, f8 $0, f8 [@constant]
	breq	+1, f8 $1, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25

positive: subtraction of ptr memory from register to register

	mov	ptr $0, ptr 0x45
	sub	ptr $1, ptr $0, ptr [@constant]
	breq	+1, ptr $1, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x13

positive: subtraction of s1 memory from memory to register

	sub	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -39

positive: subtraction of s2 memory from memory to register

	sub	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -7224
	.const constant2
	.alignment	2
	def	s2 6479

positive: subtraction of s4 memory from memory to register

	sub	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224

positive: subtraction of s8 memory from memory to register

	sub	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321

positive: subtraction of u1 memory from memory to register

	sub	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17

positive: subtraction of u2 memory from memory to register

	sub	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764

positive: subtraction of u4 memory from memory to register

	sub	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457

positive: subtraction of u8 memory from memory to register

	sub	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665

positive: subtraction of f4 memory from memory to register

	sub	f4 $0, f4 [@constant1], f4 [@constant2]
	breq	+1, f4 $0, f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 7.25
	.const constant2
	.alignment	4
	def	f4 4.5

positive: subtraction of f8 memory from memory to register

	sub	f8 $0, f8 [@constant1], f8 [@constant2]
	breq	+1, f8 $0, f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 6.5
	.const constant2
	.alignment	8
	def	f8 -1.25

positive: subtraction of ptr memory from memory to register

	sub	ptr $0, ptr [@constant1], ptr [@constant2]
	breq	+1, ptr $0, ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr 0x45
	.const constant2
	.alignment	ptrsize
	def	ptr 0x13

positive: subtraction of s1 immediate from immediate to memory

	sub	s1 [@value], s1 54, s1 -39
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 immediate from immediate to memory

	sub	s2 [@value], s2 -7224, s2 6479
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 immediate from immediate to memory

	sub	s4 [@value], s4 231014977, s4 98722224
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 immediate from immediate to memory

	sub	s8 [@value], s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 immediate from immediate to memory

	sub	u1 [@value], u1 176, u1 17
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 immediate from immediate to memory

	sub	u2 [@value], u2 41774, u2 8764
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 immediate from immediate to memory

	sub	u4 [@value], u4 2965411179, u4 1132125457
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 immediate from immediate to memory

	sub	u8 [@value], u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 immediate from immediate to memory

	sub	f4 [@value], f4 7.25, f4 4.5
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 immediate from immediate to memory

	sub	f8 [@value], f8 6.5, f8 -1.25
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr immediate from immediate to memory

	sub	ptr [@value], ptr 0x45, ptr 0x13
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: subtraction of s1 immediate from register to memory

	mov	s1 $0, s1 54
	sub	s1 [@value], s1 $0, s1 -39
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 immediate from register to memory

	mov	s2 $0, s2 -7224
	sub	s2 [@value], s2 $0, s2 6479
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 immediate from register to memory

	mov	s4 $0, s4 231014977
	sub	s4 [@value], s4 $0, s4 98722224
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 immediate from register to memory

	mov	s8 $0, s8 1238769817629834628
	sub	s8 [@value], s8 $0, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 immediate from register to memory

	mov	u1 $0, u1 176
	sub	u1 [@value], u1 $0, u1 17
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 immediate from register to memory

	mov	u2 $0, u2 41774
	sub	u2 [@value], u2 $0, u2 8764
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 immediate from register to memory

	mov	u4 $0, u4 2965411179
	sub	u4 [@value], u4 $0, u4 1132125457
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 immediate from register to memory

	mov	u8 $0, u8 1238769817629834628
	sub	u8 [@value], u8 $0, u8 898794512221454665
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 immediate from register to memory

	mov	f4 $0, f4 7.25
	sub	f4 [@value], f4 $0, f4 4.5
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 immediate from register to memory

	mov	f8 $0, f8 6.5
	sub	f8 [@value], f8 $0, f8 -1.25
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr immediate from register to memory

	mov	ptr $0, ptr 0x45
	sub	ptr [@value], ptr $0, ptr 0x13
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: subtraction of s1 immediate from memory to memory

	sub	s1 [@value], s1 [@constant], s1 -39
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 immediate from memory to memory

	sub	s2 [@value], s2 [@constant], s2 6479
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -7224
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 immediate from memory to memory

	sub	s4 [@value], s4 [@constant], s4 98722224
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 immediate from memory to memory

	sub	s8 [@value], s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 immediate from memory to memory

	sub	u1 [@value], u1 [@constant], u1 17
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 immediate from memory to memory

	sub	u2 [@value], u2 [@constant], u2 8764
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 immediate from memory to memory

	sub	u4 [@value], u4 [@constant], u4 1132125457
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 immediate from memory to memory

	sub	u8 [@value], u8 [@constant], u8 898794512221454665
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 immediate from memory to memory

	sub	f4 [@value], f4 [@constant], f4 4.5
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.25
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 immediate from memory to memory

	sub	f8 [@value], f8 [@constant], f8 -1.25
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 6.5
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr immediate from memory to memory

	sub	ptr [@value], ptr [@constant], ptr 0x13
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x45
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: subtraction of s1 register from immediate to memory

	mov	s1 $0, s1 -39
	sub	s1 [@value], s1 54, s1 $0
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 register from immediate to memory

	mov	s2 $0, s2 6479
	sub	s2 [@value], s2 -7224, s2 $0
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 register from immediate to memory

	mov	s4 $0, s4 98722224
	sub	s4 [@value], s4 231014977, s4 $0
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 register from immediate to memory

	mov	s8 $0, s8 -4546546313132132321
	sub	s8 [@value], s8 1238769817629834628, s8 $0
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 register from immediate to memory

	mov	u1 $0, u1 17
	sub	u1 [@value], u1 176, u1 $0
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 register from immediate to memory

	mov	u2 $0, u2 8764
	sub	u2 [@value], u2 41774, u2 $0
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 register from immediate to memory

	mov	u4 $0, u4 1132125457
	sub	u4 [@value], u4 2965411179, u4 $0
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 register from immediate to memory

	mov	u8 $0, u8 898794512221454665
	sub	u8 [@value], u8 1238769817629834628, u8 $0
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 register from immediate to memory

	mov	f4 $0, f4 4.5
	sub	f4 [@value], f4 7.25, f4 $0
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 register from immediate to memory

	mov	f8 $0, f8 -1.25
	sub	f8 [@value], f8 6.5, f8 $0
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr register from immediate to memory

	mov	ptr $0, ptr 0x13
	sub	ptr [@value], ptr 0x45, ptr $0
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: subtraction of s1 register from register to memory

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -39
	sub	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 register from register to memory

	mov	s2 $0, s2 -7224
	mov	s2 $1, s2 6479
	sub	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 register from register to memory

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	sub	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 register from register to memory

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	sub	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 register from register to memory

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	sub	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 register from register to memory

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	sub	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 register from register to memory

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	sub	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 register from register to memory

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	sub	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 register from register to memory

	mov	f4 $0, f4 7.25
	mov	f4 $1, f4 4.5
	sub	f4 [@value], f4 $0, f4 $1
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 register from register to memory

	mov	f8 $0, f8 6.5
	mov	f8 $1, f8 -1.25
	sub	f8 [@value], f8 $0, f8 $1
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr register from register to memory

	mov	ptr $0, ptr 0x45
	mov	ptr $1, ptr 0x13
	sub	ptr [@value], ptr $0, ptr $1
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: subtraction of s1 register from memory to memory

	mov	s1 $0, s1 -39
	sub	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 register from memory to memory

	mov	s2 $0, s2 6479
	sub	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -7224
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 register from memory to memory

	mov	s4 $0, s4 98722224
	sub	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 register from memory to memory

	mov	s8 $0, s8 -4546546313132132321
	sub	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 register from memory to memory

	mov	u1 $0, u1 17
	sub	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 register from memory to memory

	mov	u2 $0, u2 8764
	sub	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 register from memory to memory

	mov	u4 $0, u4 1132125457
	sub	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 register from memory to memory

	mov	u8 $0, u8 898794512221454665
	sub	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 register from memory to memory

	mov	f4 $0, f4 4.5
	sub	f4 [@value], f4 [@constant], f4 $0
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.25
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 register from memory to memory

	mov	f8 $0, f8 -1.25
	sub	f8 [@value], f8 [@constant], f8 $0
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 6.5
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr register from memory to memory

	mov	ptr $0, ptr 0x13
	sub	ptr [@value], ptr [@constant], ptr $0
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x45
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: subtraction of s1 memory from immediate to memory

	sub	s1 [@value], s1 54, s1 [@constant]
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -39
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 memory from immediate to memory

	sub	s2 [@value], s2 -7224, s2 [@constant]
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 memory from immediate to memory

	sub	s4 [@value], s4 231014977, s4 [@constant]
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 memory from immediate to memory

	sub	s8 [@value], s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 memory from immediate to memory

	sub	u1 [@value], u1 176, u1 [@constant]
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 memory from immediate to memory

	sub	u2 [@value], u2 41774, u2 [@constant]
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 memory from immediate to memory

	sub	u4 [@value], u4 2965411179, u4 [@constant]
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 memory from immediate to memory

	sub	u8 [@value], u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 memory from immediate to memory

	sub	f4 [@value], f4 7.25, f4 [@constant]
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 4.5
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 memory from immediate to memory

	sub	f8 [@value], f8 6.5, f8 [@constant]
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr memory from immediate to memory

	sub	ptr [@value], ptr 0x45, ptr [@constant]
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x13
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: subtraction of s1 memory from register to memory

	mov	s1 $0, s1 54
	sub	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -39
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 memory from register to memory

	mov	s2 $0, s2 -7224
	sub	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 memory from register to memory

	mov	s4 $0, s4 231014977
	sub	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 memory from register to memory

	mov	s8 $0, s8 1238769817629834628
	sub	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 memory from register to memory

	mov	u1 $0, u1 176
	sub	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 memory from register to memory

	mov	u2 $0, u2 41774
	sub	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 memory from register to memory

	mov	u4 $0, u4 2965411179
	sub	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 memory from register to memory

	mov	u8 $0, u8 1238769817629834628
	sub	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 memory from register to memory

	mov	f4 $0, f4 7.25
	sub	f4 [@value], f4 $0, f4 [@constant]
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 4.5
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 memory from register to memory

	mov	f8 $0, f8 6.5
	sub	f8 [@value], f8 $0, f8 [@constant]
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr memory from register to memory

	mov	ptr $0, ptr 0x45
	sub	ptr [@value], ptr $0, ptr [@constant]
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x13
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: subtraction of s1 memory from memory to memory

	sub	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 93
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -39
	.data value
	.alignment	1
	res	1

positive: subtraction of s2 memory from memory to memory

	sub	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 -13703
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -7224
	.const constant2
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: subtraction of s4 memory from memory to memory

	sub	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 132292753
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: subtraction of s8 memory from memory to memory

	sub	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 5785316130761966949
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: subtraction of u1 memory from memory to memory

	sub	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 159
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: subtraction of u2 memory from memory to memory

	sub	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 33010
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: subtraction of u4 memory from memory to memory

	sub	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 1833285722
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: subtraction of u8 memory from memory to memory

	sub	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 339975305408379963
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: subtraction of f4 memory from memory to memory

	sub	f4 [@value], f4 [@constant1], f4 [@constant2]
	breq	+1, f4 [@value], f4 2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 7.25
	.const constant2
	.alignment	4
	def	f4 4.5
	.data value
	.alignment	4
	res	4

positive: subtraction of f8 memory from memory to memory

	sub	f8 [@value], f8 [@constant1], f8 [@constant2]
	breq	+1, f8 [@value], f8 7.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 6.5
	.const constant2
	.alignment	8
	def	f8 -1.25
	.data value
	.alignment	8
	res	8

positive: subtraction of ptr memory from memory to memory

	sub	ptr [@value], ptr [@constant1], ptr [@constant2]
	breq	+1, ptr [@value], ptr 0x32
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr 0x45
	.const constant2
	.alignment	ptrsize
	def	ptr 0x13
	.data value
	.alignment	ptrsize
	res	ptrsize

# mul instruction

positive: multiplication of s1 immediate by immediate to register

	mul	s1 $0, s1 10, s1 -12
	breq	+1, s1 $0, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s2 immediate by immediate to register

	mul	s2 $0, s2 -541, s2 23
	breq	+1, s2 $0, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s4 immediate by immediate to register

	mul	s4 $0, s4 23177, s4 85424
	breq	+1, s4 $0, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s8 immediate by immediate to register

	mul	s8 $0, s8 654321344, s8 -68496414
	breq	+1, s8 $0, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u1 immediate by immediate to register

	mul	u1 $0, u1 21, u1 12
	breq	+1, u1 $0, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u2 immediate by immediate to register

	mul	u2 $0, u2 3217, u2 19
	breq	+1, u2 $0, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u4 immediate by immediate to register

	mul	u4 $0, u4 1917797, u4 2117
	breq	+1, u4 $0, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u8 immediate by immediate to register

	mul	u8 $0, u8 19684657, u8 3513217
	breq	+1, u8 $0, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of f4 immediate by immediate to register

	mul	f4 $0, f4 7.5, f4 -4.5
	breq	+1, f4 $0, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of f8 immediate by immediate to register

	mul	f8 $0, f8 -6.5, f8 -1.5
	breq	+1, f8 $0, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of ptr immediate by immediate to register

	mul	ptr $0, ptr 0x12, ptr 0x09
	breq	+1, ptr $0, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s1 register by immediate to register

	mov	s1 $0, s1 10
	mul	s1 $1, s1 $0, s1 -12
	breq	+1, s1 $1, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s2 register by immediate to register

	mov	s2 $0, s2 -541
	mul	s2 $1, s2 $0, s2 23
	breq	+1, s2 $1, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s4 register by immediate to register

	mov	s4 $0, s4 23177
	mul	s4 $1, s4 $0, s4 85424
	breq	+1, s4 $1, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s8 register by immediate to register

	mov	s8 $0, s8 654321344
	mul	s8 $1, s8 $0, s8 -68496414
	breq	+1, s8 $1, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u1 register by immediate to register

	mov	u1 $0, u1 21
	mul	u1 $1, u1 $0, u1 12
	breq	+1, u1 $1, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u2 register by immediate to register

	mov	u2 $0, u2 3217
	mul	u2 $1, u2 $0, u2 19
	breq	+1, u2 $1, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u4 register by immediate to register

	mov	u4 $0, u4 1917797
	mul	u4 $1, u4 $0, u4 2117
	breq	+1, u4 $1, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u8 register by immediate to register

	mov	u8 $0, u8 19684657
	mul	u8 $1, u8 $0, u8 3513217
	breq	+1, u8 $1, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of f4 register by immediate to register

	mov	f4 $0, f4 7.5
	mul	f4 $1, f4 $0, f4 -4.5
	breq	+1, f4 $1, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of f8 register by immediate to register

	mov	f8 $0, f8 -6.5
	mul	f8 $1, f8 $0, f8 -1.5
	breq	+1, f8 $1, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of ptr register by immediate to register

	mov	ptr $0, ptr 0x12
	mul	ptr $1, ptr $0, ptr 0x09
	breq	+1, ptr $1, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s1 memory by immediate to register

	mul	s1 $0, s1 [@constant], s1 -12
	breq	+1, s1 $0, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 10

positive: multiplication of s2 memory by immediate to register

	mul	s2 $0, s2 [@constant], s2 23
	breq	+1, s2 $0, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -541

positive: multiplication of s4 memory by immediate to register

	mul	s4 $0, s4 [@constant], s4 85424
	breq	+1, s4 $0, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 23177

positive: multiplication of s8 memory by immediate to register

	mul	s8 $0, s8 [@constant], s8 -68496414
	breq	+1, s8 $0, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 654321344

positive: multiplication of u1 memory by immediate to register

	mul	u1 $0, u1 [@constant], u1 12
	breq	+1, u1 $0, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 21

positive: multiplication of u2 memory by immediate to register

	mul	u2 $0, u2 [@constant], u2 19
	breq	+1, u2 $0, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 3217

positive: multiplication of u4 memory by immediate to register

	mul	u4 $0, u4 [@constant], u4 2117
	breq	+1, u4 $0, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1917797

positive: multiplication of u8 memory by immediate to register

	mul	u8 $0, u8 [@constant], u8 3513217
	breq	+1, u8 $0, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 19684657

positive: multiplication of f4 memory by immediate to register

	mul	f4 $0, f4 [@constant], f4 -4.5
	breq	+1, f4 $0, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.5

positive: multiplication of f8 memory by immediate to register

	mul	f8 $0, f8 [@constant], f8 -1.5
	breq	+1, f8 $0, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -6.5

positive: multiplication of ptr memory by immediate to register

	mul	ptr $0, ptr [@constant], ptr 0x09
	breq	+1, ptr $0, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x12

positive: multiplication of s1 immediate by register to register

	mov	s1 $0, s1 -12
	mul	s1 $1, s1 10, s1 $0
	breq	+1, s1 $1, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s2 immediate by register to register

	mov	s2 $0, s2 23
	mul	s2 $1, s2 -541, s2 $0
	breq	+1, s2 $1, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s4 immediate by register to register

	mov	s4 $0, s4 85424
	mul	s4 $1, s4 23177, s4 $0
	breq	+1, s4 $1, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s8 immediate by register to register

	mov	s8 $0, s8 -68496414
	mul	s8 $1, s8 654321344, s8 $0
	breq	+1, s8 $1, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u1 immediate by register to register

	mov	u1 $0, u1 12
	mul	u1 $1, u1 21, u1 $0
	breq	+1, u1 $1, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u2 immediate by register to register

	mov	u2 $0, u2 19
	mul	u2 $1, u2 3217, u2 $0
	breq	+1, u2 $1, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u4 immediate by register to register

	mov	u4 $0, u4 2117
	mul	u4 $1, u4 1917797, u4 $0
	breq	+1, u4 $1, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u8 immediate by register to register

	mov	u8 $0, u8 3513217
	mul	u8 $1, u8 19684657, u8 $0
	breq	+1, u8 $1, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of f4 immediate by register to register

	mov	f4 $0, f4 -4.5
	mul	f4 $1, f4 7.5, f4 $0
	breq	+1, f4 $1, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of f8 immediate by register to register

	mov	f8 $0, f8 -1.5
	mul	f8 $1, f8 -6.5, f8 $0
	breq	+1, f8 $1, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of ptr immediate by register to register

	mov	ptr $0, ptr 0x09
	mul	ptr $1, ptr 0x12, ptr $0
	breq	+1, ptr $1, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s1 register by register to register

	mov	s1 $0, s1 10
	mov	s1 $1, s1 -12
	mul	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s2 register by register to register

	mov	s2 $0, s2 -541
	mov	s2 $1, s2 23
	mul	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s4 register by register to register

	mov	s4 $0, s4 23177
	mov	s4 $1, s4 85424
	mul	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s8 register by register to register

	mov	s8 $0, s8 654321344
	mov	s8 $1, s8 -68496414
	mul	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u1 register by register to register

	mov	u1 $0, u1 21
	mov	u1 $1, u1 12
	mul	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u2 register by register to register

	mov	u2 $0, u2 3217
	mov	u2 $1, u2 19
	mul	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u4 register by register to register

	mov	u4 $0, u4 1917797
	mov	u4 $1, u4 2117
	mul	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of u8 register by register to register

	mov	u8 $0, u8 19684657
	mov	u8 $1, u8 3513217
	mul	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of f4 register by register to register

	mov	f4 $0, f4 7.5
	mov	f4 $1, f4 -4.5
	mul	f4 $2, f4 $0, f4 $1
	breq	+1, f4 $2, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of f8 register by register to register

	mov	f8 $0, f8 -6.5
	mov	f8 $1, f8 -1.5
	mul	f8 $2, f8 $0, f8 $1
	breq	+1, f8 $2, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of ptr register by register to register

	mov	ptr $0, ptr 0x12
	mov	ptr $1, ptr 0x09
	mul	ptr $2, ptr $0, ptr $1
	breq	+1, ptr $2, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: multiplication of s1 memory by register to register

	mov	s1 $0, s1 -12
	mul	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 10

positive: multiplication of s2 memory by register to register

	mov	s2 $0, s2 23
	mul	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -541

positive: multiplication of s4 memory by register to register

	mov	s4 $0, s4 85424
	mul	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 23177

positive: multiplication of s8 memory by register to register

	mov	s8 $0, s8 -68496414
	mul	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 654321344

positive: multiplication of u1 memory by register to register

	mov	u1 $0, u1 12
	mul	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 21

positive: multiplication of u2 memory by register to register

	mov	u2 $0, u2 19
	mul	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 3217

positive: multiplication of u4 memory by register to register

	mov	u4 $0, u4 2117
	mul	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1917797

positive: multiplication of u8 memory by register to register

	mov	u8 $0, u8 3513217
	mul	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 19684657

positive: multiplication of f4 memory by register to register

	mov	f4 $0, f4 -4.5
	mul	f4 $1, f4 [@constant], f4 $0
	breq	+1, f4 $1, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.5

positive: multiplication of f8 memory by register to register

	mov	f8 $0, f8 -1.5
	mul	f8 $1, f8 [@constant], f8 $0
	breq	+1, f8 $1, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -6.5

positive: multiplication of ptr memory by register to register

	mov	ptr $0, ptr 0x09
	mul	ptr $1, ptr [@constant], ptr $0
	breq	+1, ptr $1, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x12

positive: multiplication of s1 immediate by memory to register

	mul	s1 $0, s1 10, s1 [@constant]
	breq	+1, s1 $0, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -12

positive: multiplication of s2 immediate by memory to register

	mul	s2 $0, s2 -541, s2 [@constant]
	breq	+1, s2 $0, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 23

positive: multiplication of s4 immediate by memory to register

	mul	s4 $0, s4 23177, s4 [@constant]
	breq	+1, s4 $0, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 85424

positive: multiplication of s8 immediate by memory to register

	mul	s8 $0, s8 654321344, s8 [@constant]
	breq	+1, s8 $0, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -68496414

positive: multiplication of u1 immediate by memory to register

	mul	u1 $0, u1 21, u1 [@constant]
	breq	+1, u1 $0, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 12

positive: multiplication of u2 immediate by memory to register

	mul	u2 $0, u2 3217, u2 [@constant]
	breq	+1, u2 $0, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 19

positive: multiplication of u4 immediate by memory to register

	mul	u4 $0, u4 1917797, u4 [@constant]
	breq	+1, u4 $0, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2117

positive: multiplication of u8 immediate by memory to register

	mul	u8 $0, u8 19684657, u8 [@constant]
	breq	+1, u8 $0, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217

positive: multiplication of f4 immediate by memory to register

	mul	f4 $0, f4 7.5, f4 [@constant]
	breq	+1, f4 $0, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -4.5

positive: multiplication of f8 immediate by memory to register

	mul	f8 $0, f8 -6.5, f8 [@constant]
	breq	+1, f8 $0, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.5

positive: multiplication of ptr immediate by memory to register

	mul	ptr $0, ptr 0x12, ptr [@constant]
	breq	+1, ptr $0, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x09

positive: multiplication of s1 register by memory to register

	mov	s1 $0, s1 10
	mul	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -12

positive: multiplication of s2 register by memory to register

	mov	s2 $0, s2 -541
	mul	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 23

positive: multiplication of s4 register by memory to register

	mov	s4 $0, s4 23177
	mul	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 85424

positive: multiplication of s8 register by memory to register

	mov	s8 $0, s8 654321344
	mul	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -68496414

positive: multiplication of u1 register by memory to register

	mov	u1 $0, u1 21
	mul	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 12

positive: multiplication of u2 register by memory to register

	mov	u2 $0, u2 3217
	mul	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 19

positive: multiplication of u4 register by memory to register

	mov	u4 $0, u4 1917797
	mul	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2117

positive: multiplication of u8 register by memory to register

	mov	u8 $0, u8 19684657
	mul	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217

positive: multiplication of f4 register by memory to register

	mov	f4 $0, f4 7.5
	mul	f4 $1, f4 $0, f4 [@constant]
	breq	+1, f4 $1, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -4.5

positive: multiplication of f8 register by memory to register

	mov	f8 $0, f8 -6.5
	mul	f8 $1, f8 $0, f8 [@constant]
	breq	+1, f8 $1, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.5

positive: multiplication of ptr register by memory to register

	mov	ptr $0, ptr 0x12
	mul	ptr $1, ptr $0, ptr [@constant]
	breq	+1, ptr $1, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x09

positive: multiplication of s1 memory by memory to register

	mul	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 10
	.const constant2
	.alignment	1
	def	s1 -12

positive: multiplication of s2 memory by memory to register

	mul	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -541
	.const constant2
	.alignment	2
	def	s2 23

positive: multiplication of s4 memory by memory to register

	mul	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 23177
	.const constant2
	.alignment	4
	def	s4 85424

positive: multiplication of s8 memory by memory to register

	mul	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 654321344
	.const constant2
	.alignment	8
	def	s8 -68496414

positive: multiplication of u1 memory by memory to register

	mul	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 21
	.const constant2
	.alignment	1
	def	u1 12

positive: multiplication of u2 memory by memory to register

	mul	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 3217
	.const constant2
	.alignment	2
	def	u2 19

positive: multiplication of u4 memory by memory to register

	mul	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 1917797
	.const constant2
	.alignment	4
	def	u4 2117

positive: multiplication of u8 memory by memory to register

	mul	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 19684657
	.const constant2
	.alignment	8
	def	u8 3513217

positive: multiplication of f4 memory by memory to register

	mul	f4 $0, f4 [@constant1], f4 [@constant2]
	breq	+1, f4 $0, f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 7.5
	.const constant2
	.alignment	4
	def	f4 -4.5

positive: multiplication of f8 memory by memory to register

	mul	f8 $0, f8 [@constant1], f8 [@constant2]
	breq	+1, f8 $0, f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -6.5
	.const constant2
	.alignment	8
	def	f8 -1.5

positive: multiplication of ptr memory by memory to register

	mul	ptr $0, ptr [@constant1], ptr [@constant2]
	breq	+1, ptr $0, ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr 0x12
	.const constant2
	.alignment	ptrsize
	def	ptr 0x09

positive: multiplication of s1 immediate by immediate to memory

	mul	s1 [@value], s1 10, s1 -12
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 immediate by immediate to memory

	mul	s2 [@value], s2 -541, s2 23
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 immediate by immediate to memory

	mul	s4 [@value], s4 23177, s4 85424
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 immediate by immediate to memory

	mul	s8 [@value], s8 654321344, s8 -68496414
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 immediate by immediate to memory

	mul	u1 [@value], u1 21, u1 12
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 immediate by immediate to memory

	mul	u2 [@value], u2 3217, u2 19
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 immediate by immediate to memory

	mul	u4 [@value], u4 1917797, u4 2117
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 immediate by immediate to memory

	mul	u8 [@value], u8 19684657, u8 3513217
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 immediate by immediate to memory

	mul	f4 [@value], f4 7.5, f4 -4.5
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 immediate by immediate to memory

	mul	f8 [@value], f8 -6.5, f8 -1.5
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr immediate by immediate to memory

	mul	ptr [@value], ptr 0x12, ptr 0x09
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: multiplication of s1 register by immediate to memory

	mov	s1 $0, s1 10
	mul	s1 [@value], s1 $0, s1 -12
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 register by immediate to memory

	mov	s2 $0, s2 -541
	mul	s2 [@value], s2 $0, s2 23
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 register by immediate to memory

	mov	s4 $0, s4 23177
	mul	s4 [@value], s4 $0, s4 85424
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 register by immediate to memory

	mov	s8 $0, s8 654321344
	mul	s8 [@value], s8 $0, s8 -68496414
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 register by immediate to memory

	mov	u1 $0, u1 21
	mul	u1 [@value], u1 $0, u1 12
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 register by immediate to memory

	mov	u2 $0, u2 3217
	mul	u2 [@value], u2 $0, u2 19
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 register by immediate to memory

	mov	u4 $0, u4 1917797
	mul	u4 [@value], u4 $0, u4 2117
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 register by immediate to memory

	mov	u8 $0, u8 19684657
	mul	u8 [@value], u8 $0, u8 3513217
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 register by immediate to memory

	mov	f4 $0, f4 7.5
	mul	f4 [@value], f4 $0, f4 -4.5
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 register by immediate to memory

	mov	f8 $0, f8 -6.5
	mul	f8 [@value], f8 $0, f8 -1.5
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr register by immediate to memory

	mov	ptr $0, ptr 0x12
	mul	ptr [@value], ptr $0, ptr 0x09
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: multiplication of s1 memory by immediate to memory

	mul	s1 [@value], s1 [@constant], s1 -12
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 10
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 memory by immediate to memory

	mul	s2 [@value], s2 [@constant], s2 23
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -541
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 memory by immediate to memory

	mul	s4 [@value], s4 [@constant], s4 85424
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 23177
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 memory by immediate to memory

	mul	s8 [@value], s8 [@constant], s8 -68496414
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 654321344
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 memory by immediate to memory

	mul	u1 [@value], u1 [@constant], u1 12
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 21
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 memory by immediate to memory

	mul	u2 [@value], u2 [@constant], u2 19
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 3217
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 memory by immediate to memory

	mul	u4 [@value], u4 [@constant], u4 2117
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1917797
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 memory by immediate to memory

	mul	u8 [@value], u8 [@constant], u8 3513217
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 19684657
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 memory by immediate to memory

	mul	f4 [@value], f4 [@constant], f4 -4.5
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.5
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 memory by immediate to memory

	mul	f8 [@value], f8 [@constant], f8 -1.5
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -6.5
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr memory by immediate to memory

	mul	ptr [@value], ptr [@constant], ptr 0x09
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x12
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: multiplication of s1 immediate by register to memory

	mov	s1 $0, s1 -12
	mul	s1 [@value], s1 10, s1 $0
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 immediate by register to memory

	mov	s2 $0, s2 23
	mul	s2 [@value], s2 -541, s2 $0
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 immediate by register to memory

	mov	s4 $0, s4 85424
	mul	s4 [@value], s4 23177, s4 $0
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 immediate by register to memory

	mov	s8 $0, s8 -68496414
	mul	s8 [@value], s8 654321344, s8 $0
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 immediate by register to memory

	mov	u1 $0, u1 12
	mul	u1 [@value], u1 21, u1 $0
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 immediate by register to memory

	mov	u2 $0, u2 19
	mul	u2 [@value], u2 3217, u2 $0
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 immediate by register to memory

	mov	u4 $0, u4 2117
	mul	u4 [@value], u4 1917797, u4 $0
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 immediate by register to memory

	mov	u8 $0, u8 3513217
	mul	u8 [@value], u8 19684657, u8 $0
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 immediate by register to memory

	mov	f4 $0, f4 -4.5
	mul	f4 [@value], f4 7.5, f4 $0
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 immediate by register to memory

	mov	f8 $0, f8 -1.5
	mul	f8 [@value], f8 -6.5, f8 $0
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr immediate by register to memory

	mov	ptr $0, ptr 0x09
	mul	ptr [@value], ptr 0x12, ptr $0
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: multiplication of s1 register by register to memory

	mov	s1 $0, s1 10
	mov	s1 $1, s1 -12
	mul	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 register by register to memory

	mov	s2 $0, s2 -541
	mov	s2 $1, s2 23
	mul	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 register by register to memory

	mov	s4 $0, s4 23177
	mov	s4 $1, s4 85424
	mul	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 register by register to memory

	mov	s8 $0, s8 654321344
	mov	s8 $1, s8 -68496414
	mul	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 register by register to memory

	mov	u1 $0, u1 21
	mov	u1 $1, u1 12
	mul	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 register by register to memory

	mov	u2 $0, u2 3217
	mov	u2 $1, u2 19
	mul	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 register by register to memory

	mov	u4 $0, u4 1917797
	mov	u4 $1, u4 2117
	mul	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 register by register to memory

	mov	u8 $0, u8 19684657
	mov	u8 $1, u8 3513217
	mul	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 register by register to memory

	mov	f4 $0, f4 7.5
	mov	f4 $1, f4 -4.5
	mul	f4 [@value], f4 $0, f4 $1
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 register by register to memory

	mov	f8 $0, f8 -6.5
	mov	f8 $1, f8 -1.5
	mul	f8 [@value], f8 $0, f8 $1
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr register by register to memory

	mov	ptr $0, ptr 0x12
	mov	ptr $1, ptr 0x09
	mul	ptr [@value], ptr $0, ptr $1
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: multiplication of s1 memory by register to memory

	mov	s1 $0, s1 -12
	mul	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 10
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 memory by register to memory

	mov	s2 $0, s2 23
	mul	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 -541
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 memory by register to memory

	mov	s4 $0, s4 85424
	mul	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 23177
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 memory by register to memory

	mov	s8 $0, s8 -68496414
	mul	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 654321344
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 memory by register to memory

	mov	u1 $0, u1 12
	mul	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 21
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 memory by register to memory

	mov	u2 $0, u2 19
	mul	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 3217
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 memory by register to memory

	mov	u4 $0, u4 2117
	mul	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1917797
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 memory by register to memory

	mov	u8 $0, u8 3513217
	mul	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 19684657
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 memory by register to memory

	mov	f4 $0, f4 -4.5
	mul	f4 [@value], f4 [@constant], f4 $0
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.5
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 memory by register to memory

	mov	f8 $0, f8 -1.5
	mul	f8 [@value], f8 [@constant], f8 $0
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -6.5
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr memory by register to memory

	mov	ptr $0, ptr 0x09
	mul	ptr [@value], ptr [@constant], ptr $0
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x12
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: multiplication of s1 immediate by memory to memory

	mul	s1 [@value], s1 10, s1 [@constant]
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -12
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 immediate by memory to memory

	mul	s2 [@value], s2 -541, s2 [@constant]
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 23
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 immediate by memory to memory

	mul	s4 [@value], s4 23177, s4 [@constant]
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 85424
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 immediate by memory to memory

	mul	s8 [@value], s8 654321344, s8 [@constant]
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -68496414
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 immediate by memory to memory

	mul	u1 [@value], u1 21, u1 [@constant]
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 12
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 immediate by memory to memory

	mul	u2 [@value], u2 3217, u2 [@constant]
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 19
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 immediate by memory to memory

	mul	u4 [@value], u4 1917797, u4 [@constant]
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2117
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 immediate by memory to memory

	mul	u8 [@value], u8 19684657, u8 [@constant]
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 immediate by memory to memory

	mul	f4 [@value], f4 7.5, f4 [@constant]
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -4.5
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 immediate by memory to memory

	mul	f8 [@value], f8 -6.5, f8 [@constant]
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.5
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr immediate by memory to memory

	mul	ptr [@value], ptr 0x12, ptr [@constant]
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x09
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: multiplication of s1 register by memory to memory

	mov	s1 $0, s1 10
	mul	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -12
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 register by memory to memory

	mov	s2 $0, s2 -541
	mul	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 23
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 register by memory to memory

	mov	s4 $0, s4 23177
	mul	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 85424
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 register by memory to memory

	mov	s8 $0, s8 654321344
	mul	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -68496414
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 register by memory to memory

	mov	u1 $0, u1 21
	mul	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 12
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 register by memory to memory

	mov	u2 $0, u2 3217
	mul	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 19
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 register by memory to memory

	mov	u4 $0, u4 1917797
	mul	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2117
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 register by memory to memory

	mov	u8 $0, u8 19684657
	mul	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 register by memory to memory

	mov	f4 $0, f4 7.5
	mul	f4 [@value], f4 $0, f4 [@constant]
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -4.5
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 register by memory to memory

	mov	f8 $0, f8 -6.5
	mul	f8 [@value], f8 $0, f8 [@constant]
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.5
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr register by memory to memory

	mov	ptr $0, ptr 0x12
	mul	ptr [@value], ptr $0, ptr [@constant]
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr 0x09
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: multiplication of s1 memory by memory to memory

	mul	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 -120
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 10
	.const constant2
	.alignment	1
	def	s1 -12
	.data value
	.alignment	1
	res	1

positive: multiplication of s2 memory by memory to memory

	mul	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 -12443
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -541
	.const constant2
	.alignment	2
	def	s2 23
	.data value
	.alignment	2
	res	2

positive: multiplication of s4 memory by memory to memory

	mul	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 1979872048
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 23177
	.const constant2
	.alignment	4
	def	s4 85424
	.data value
	.alignment	4
	res	4

positive: multiplication of s8 memory by memory to memory

	mul	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 -44818665667660416
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 654321344
	.const constant2
	.alignment	8
	def	s8 -68496414
	.data value
	.alignment	8
	res	8

positive: multiplication of u1 memory by memory to memory

	mul	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 252
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 21
	.const constant2
	.alignment	1
	def	u1 12
	.data value
	.alignment	1
	res	1

positive: multiplication of u2 memory by memory to memory

	mul	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 61123
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 3217
	.const constant2
	.alignment	2
	def	u2 19
	.data value
	.alignment	2
	res	2

positive: multiplication of u4 memory by memory to memory

	mul	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 4059976249
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 1917797
	.const constant2
	.alignment	4
	def	u4 2117
	.data value
	.alignment	4
	res	4

positive: multiplication of u8 memory by memory to memory

	mul	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 69156471611569
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 19684657
	.const constant2
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

positive: multiplication of f4 memory by memory to memory

	mul	f4 [@value], f4 [@constant1], f4 [@constant2]
	breq	+1, f4 [@value], f4 -33.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 7.5
	.const constant2
	.alignment	4
	def	f4 -4.5
	.data value
	.alignment	4
	res	4

positive: multiplication of f8 memory by memory to memory

	mul	f8 [@value], f8 [@constant1], f8 [@constant2]
	breq	+1, f8 [@value], f8 9.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -6.5
	.const constant2
	.alignment	8
	def	f8 -1.5
	.data value
	.alignment	8
	res	8

positive: multiplication of ptr memory by memory to memory

	mul	ptr [@value], ptr [@constant1], ptr [@constant2]
	breq	+1, ptr [@value], ptr 0xa2
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr 0x12
	.const constant2
	.alignment	ptrsize
	def	ptr 0x09
	.data value
	.alignment	ptrsize
	res	ptrsize

# div instruction

positive: division of s1 immediate by immediate to register

	div	s1 $0, s1 75, s1 13
	breq	+1, s1 $0, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s2 immediate by immediate to register

	div	s2 $0, s2 21497, s2 874
	breq	+1, s2 $0, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s4 immediate by immediate to register

	div	s4 $0, s4 1546421779, s4 54
	breq	+1, s4 $0, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s8 immediate by immediate to register

	div	s8 $0, s8 4654321321779787245, s8 19856694258476824
	breq	+1, s8 $0, s8 234
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u1 immediate by immediate to register

	div	u1 $0, u1 231, u1 64
	breq	+1, u1 $0, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u2 immediate by immediate to register

	div	u2 $0, u2 54327, u2 217
	breq	+1, u2 $0, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u4 immediate by immediate to register

	div	u4 $0, u4 4003214787, u4 2048
	breq	+1, u4 $0, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u8 immediate by immediate to register

	div	u8 $0, u8 2298456778043724, u8 3513217
	breq	+1, u8 $0, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of f4 immediate by immediate to register

	div	f4 $0, f4 7.5, f4 -1.5
	breq	+1, f4 $0, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of f8 immediate by immediate to register

	div	f8 $0, f8 -6.75, f8 -1.5
	breq	+1, f8 $0, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s1 register by immediate to register

	mov	s1 $0, s1 75
	div	s1 $1, s1 $0, s1 13
	breq	+1, s1 $1, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s2 register by immediate to register

	mov	s2 $0, s2 21497
	div	s2 $1, s2 $0, s2 874
	breq	+1, s2 $1, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s4 register by immediate to register

	mov	s4 $0, s4 1546421779
	div	s4 $1, s4 $0, s4 54
	breq	+1, s4 $1, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s8 register by immediate to register

	mov	s8 $0, s8 4654321321779787245
	div	s8 $1, s8 $0, s8 68496414
	breq	+1, s8 $1, s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u1 register by immediate to register

	mov	u1 $0, u1 231
	div	u1 $1, u1 $0, u1 64
	breq	+1, u1 $1, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u2 register by immediate to register

	mov	u2 $0, u2 54327
	div	u2 $1, u2 $0, u2 217
	breq	+1, u2 $1, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u4 register by immediate to register

	mov	u4 $0, u4 4003214787
	div	u4 $1, u4 $0, u4 2048
	breq	+1, u4 $1, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u8 register by immediate to register

	mov	u8 $0, u8 2298456778043724
	div	u8 $1, u8 $0, u8 3513217
	breq	+1, u8 $1, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of f4 register by immediate to register

	mov	f4 $0, f4 7.5
	div	f4 $1, f4 $0, f4 -1.5
	breq	+1, f4 $1, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of f8 register by immediate to register

	mov	f8 $0, f8 -6.75
	div	f8 $1, f8 $0, f8 -1.5
	breq	+1, f8 $1, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s1 memory by immediate to register

	div	s1 $0, s1 [@constant], s1 13
	breq	+1, s1 $0, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 75

positive: division of s2 memory by immediate to register

	div	s2 $0, s2 [@constant], s2 874
	breq	+1, s2 $0, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 21497

positive: division of s4 memory by immediate to register

	div	s4 $0, s4 [@constant], s4 54
	breq	+1, s4 $0, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1546421779

positive: division of s8 memory by immediate to register

	div	s8 $0, s8 [@constant], s8 68496414
	breq	+1, s8 $0, s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 4654321321779787245

positive: division of u1 memory by immediate to register

	div	u1 $0, u1 [@constant], u1 64
	breq	+1, u1 $0, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 231

positive: division of u2 memory by immediate to register

	div	u2 $0, u2 [@constant], u2 217
	breq	+1, u2 $0, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 54327

positive: division of u4 memory by immediate to register

	div	u4 $0, u4 [@constant], u4 2048
	breq	+1, u4 $0, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4003214787

positive: division of u8 memory by immediate to register

	div	u8 $0, u8 [@constant], u8 3513217
	breq	+1, u8 $0, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 2298456778043724

positive: division of f4 memory by immediate to register

	div	f4 $0, f4 [@constant], f4 -1.5
	breq	+1, f4 $0, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.5

positive: division of f8 memory by immediate to register

	div	f8 $0, f8 [@constant], f8 -1.5
	breq	+1, f8 $0, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -6.75

positive: division of s1 immediate by register to register

	mov	s1 $0, s1 13
	div	s1 $1, s1 75, s1 $0
	breq	+1, s1 $1, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s2 immediate by register to register

	mov	s2 $0, s2 874
	div	s2 $1, s2 21497, s2 $0
	breq	+1, s2 $1, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s4 immediate by register to register

	mov	s4 $0, s4 54
	div	s4 $1, s4 1546421779, s4 $0
	breq	+1, s4 $1, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s8 immediate by register to register

	mov	s8 $0, s8 68496414
	div	s8 $1, s8 4654321321779787245, s8 $0
	breq	+1, s8 $1, s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u1 immediate by register to register

	mov	u1 $0, u1 64
	div	u1 $1, u1 231, u1 $0
	breq	+1, u1 $1, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u2 immediate by register to register

	mov	u2 $0, u2 217
	div	u2 $1, u2 54327, u2 $0
	breq	+1, u2 $1, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u4 immediate by register to register

	mov	u4 $0, u4 2048
	div	u4 $1, u4 4003214787, u4 $0
	breq	+1, u4 $1, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u8 immediate by register to register

	mov	u8 $0, u8 3513217
	div	u8 $1, u8 2298456778043724, u8 $0
	breq	+1, u8 $1, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of f4 immediate by register to register

	mov	f4 $0, f4 -1.5
	div	f4 $1, f4 7.5, f4 $0
	breq	+1, f4 $1, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of f8 immediate by register to register

	mov	f8 $0, f8 -1.5
	div	f8 $1, f8 -6.75, f8 $0
	breq	+1, f8 $1, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s1 register by register to register

	mov	s1 $0, s1 75
	mov	s1 $1, s1 13
	div	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s2 register by register to register

	mov	s2 $0, s2 21497
	mov	s2 $1, s2 874
	div	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s4 register by register to register

	mov	s4 $0, s4 1546421779
	mov	s4 $1, s4 54
	div	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s8 register by register to register

	mov	s8 $0, s8 4654321321779787245
	mov	s8 $1, s8 68496414
	div	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u1 register by register to register

	mov	u1 $0, u1 231
	mov	u1 $1, u1 64
	div	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u2 register by register to register

	mov	u2 $0, u2 54327
	mov	u2 $1, u2 217
	div	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u4 register by register to register

	mov	u4 $0, u4 4003214787
	mov	u4 $1, u4 2048
	div	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of u8 register by register to register

	mov	u8 $0, u8 2298456778043724
	mov	u8 $1, u8 3513217
	div	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of f4 register by register to register

	mov	f4 $0, f4 7.5
	mov	f4 $1, f4 -1.5
	div	f4 $2, f4 $0, f4 $1
	breq	+1, f4 $2, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of f8 register by register to register

	mov	f8 $0, f8 -6.75
	mov	f8 $1, f8 -1.5
	div	f8 $2, f8 $0, f8 $1
	breq	+1, f8 $2, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: division of s1 memory by register to register

	mov	s1 $0, s1 13
	div	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 75

positive: division of s2 memory by register to register

	mov	s2 $0, s2 874
	div	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 21497

positive: division of s4 memory by register to register

	mov	s4 $0, s4 54
	div	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1546421779

positive: division of s8 memory by register to register

	mov	s8 $0, s8 68496414
	div	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 4654321321779787245

positive: division of u1 memory by register to register

	mov	u1 $0, u1 64
	div	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 231

positive: division of u2 memory by register to register

	mov	u2 $0, u2 217
	div	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 54327

positive: division of u4 memory by register to register

	mov	u4 $0, u4 2048
	div	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4003214787

positive: division of u8 memory by register to register

	mov	u8 $0, u8 3513217
	div	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 2298456778043724

positive: division of f4 memory by register to register

	mov	f4 $0, f4 -1.5
	div	f4 $1, f4 [@constant], f4 $0
	breq	+1, f4 $1, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.5

positive: division of f8 memory by register to register

	mov	f8 $0, f8 -1.5
	div	f8 $1, f8 [@constant], f8 $0
	breq	+1, f8 $1, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -6.75

positive: division of s1 immediate by memory to register

	div	s1 $0, s1 75, s1 [@constant]
	breq	+1, s1 $0, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 13

positive: division of s2 immediate by memory to register

	div	s2 $0, s2 21497, s2 [@constant]
	breq	+1, s2 $0, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 874

positive: division of s4 immediate by memory to register

	div	s4 $0, s4 1546421779, s4 [@constant]
	breq	+1, s4 $0, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 54

positive: division of s8 immediate by memory to register

	div	s8 $0, s8 4654321321779787245, s8 [@constant]
	breq	+1, s8 $0, s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 68496414

positive: division of u1 immediate by memory to register

	div	u1 $0, u1 231, u1 [@constant]
	breq	+1, u1 $0, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 64

positive: division of u2 immediate by memory to register

	div	u2 $0, u2 54327, u2 [@constant]
	breq	+1, u2 $0, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 217

positive: division of u4 immediate by memory to register

	div	u4 $0, u4 4003214787, u4 [@constant]
	breq	+1, u4 $0, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2048

positive: division of u8 immediate by memory to register

	div	u8 $0, u8 2298456778043724, u8 [@constant]
	breq	+1, u8 $0, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217

positive: division of f4 immediate by memory to register

	div	f4 $0, f4 7.5, f4 [@constant]
	breq	+1, f4 $0, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.5

positive: division of f8 immediate by memory to register

	div	f8 $0, f8 -6.75, f8 [@constant]
	breq	+1, f8 $0, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.5

positive: division of s1 register by memory to register

	mov	s1 $0, s1 75
	div	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 13

positive: division of s2 register by memory to register

	mov	s2 $0, s2 21497
	div	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 874

positive: division of s4 register by memory to register

	mov	s4 $0, s4 1546421779
	div	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 54

positive: division of s8 register by memory to register

	mov	s8 $0, s8 4654321321779787245
	div	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 68496414

positive: division of u1 register by memory to register

	mov	u1 $0, u1 231
	div	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 64

positive: division of u2 register by memory to register

	mov	u2 $0, u2 54327
	div	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 217

positive: division of u4 register by memory to register

	mov	u4 $0, u4 4003214787
	div	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2048

positive: division of u8 register by memory to register

	mov	u8 $0, u8 2298456778043724
	div	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217

positive: division of f4 register by memory to register

	mov	f4 $0, f4 7.5
	div	f4 $1, f4 $0, f4 [@constant]
	breq	+1, f4 $1, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.5

positive: division of f8 register by memory to register

	mov	f8 $0, f8 -6.75
	div	f8 $1, f8 $0, f8 [@constant]
	breq	+1, f8 $1, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.5

positive: division of s1 memory by memory to register

	div	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 75
	.const constant2
	.alignment	1
	def	s1 13

positive: division of s2 memory by memory to register

	div	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 21497
	.const constant2
	.alignment	2
	def	s2 874

positive: division of s4 memory by memory to register

	div	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 1546421779
	.const constant2
	.alignment	4
	def	s4 54

positive: division of s8 memory by memory to register

	div	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 4654321321779787245
	.const constant2
	.alignment	8
	def	s8 68496414

positive: division of u1 memory by memory to register

	div	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 231
	.const constant2
	.alignment	1
	def	u1 64

positive: division of u2 memory by memory to register

	div	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 54327
	.const constant2
	.alignment	2
	def	u2 217

positive: division of u4 memory by memory to register

	div	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 4003214787
	.const constant2
	.alignment	4
	def	u4 2048

positive: division of u8 memory by memory to register

	div	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 2298456778043724
	.const constant2
	.alignment	8
	def	u8 3513217

positive: division of f4 memory by memory to register

	div	f4 $0, f4 [@constant1], f4 [@constant2]
	breq	+1, f4 $0, f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 7.5
	.const constant2
	.alignment	4
	def	f4 -1.5

positive: division of f8 memory by memory to register

	div	f8 $0, f8 [@constant1], f8 [@constant2]
	breq	+1, f8 $0, f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -6.75
	.const constant2
	.alignment	8
	def	f8 -1.5

positive: division of s1 immediate by immediate to memory

	div	s1 [@value], s1 75, s1 13
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: division of s2 immediate by immediate to memory

	div	s2 [@value], s2 21497, s2 874
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: division of s4 immediate by immediate to memory

	div	s4 [@value], s4 1546421779, s4 54
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of s8 immediate by immediate to memory

	div	s8 [@value], s8 4654321321779787245, s8 68496414
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of u1 immediate by immediate to memory

	div	u1 [@value], u1 231, u1 64
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: division of u2 immediate by immediate to memory

	div	u2 [@value], u2 54327, u2 217
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: division of u4 immediate by immediate to memory

	div	u4 [@value], u4 4003214787, u4 2048
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of u8 immediate by immediate to memory

	div	u8 [@value], u8 2298456778043724, u8 3513217
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of f4 immediate by immediate to memory

	div	f4 [@value], f4 7.5, f4 -1.5
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of f8 immediate by immediate to memory

	div	f8 [@value], f8 -6.75, f8 -1.5
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of s1 register by immediate to memory

	mov	s1 $0, s1 75
	div	s1 [@value], s1 $0, s1 13
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: division of s2 register by immediate to memory

	mov	s2 $0, s2 21497
	div	s2 [@value], s2 $0, s2 874
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: division of s4 register by immediate to memory

	mov	s4 $0, s4 1546421779
	div	s4 [@value], s4 $0, s4 54
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of s8 register by immediate to memory

	mov	s8 $0, s8 4654321321779787245
	div	s8 [@value], s8 $0, s8 68496414
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of u1 register by immediate to memory

	mov	u1 $0, u1 231
	div	u1 [@value], u1 $0, u1 64
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: division of u2 register by immediate to memory

	mov	u2 $0, u2 54327
	div	u2 [@value], u2 $0, u2 217
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: division of u4 register by immediate to memory

	mov	u4 $0, u4 4003214787
	div	u4 [@value], u4 $0, u4 2048
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of u8 register by immediate to memory

	mov	u8 $0, u8 2298456778043724
	div	u8 [@value], u8 $0, u8 3513217
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of f4 register by immediate to memory

	mov	f4 $0, f4 7.5
	div	f4 [@value], f4 $0, f4 -1.5
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of f8 register by immediate to memory

	mov	f8 $0, f8 -6.75
	div	f8 [@value], f8 $0, f8 -1.5
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of s1 memory by immediate to memory

	div	s1 [@value], s1 [@constant], s1 13
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 75
	.data value
	.alignment	1
	res	1

positive: division of s2 memory by immediate to memory

	div	s2 [@value], s2 [@constant], s2 874
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 21497
	.data value
	.alignment	2
	res	2

positive: division of s4 memory by immediate to memory

	div	s4 [@value], s4 [@constant], s4 54
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1546421779
	.data value
	.alignment	4
	res	4

positive: division of s8 memory by immediate to memory

	div	s8 [@value], s8 [@constant], s8 68496414
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 4654321321779787245
	.data value
	.alignment	8
	res	8

positive: division of u1 memory by immediate to memory

	div	u1 [@value], u1 [@constant], u1 64
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 231
	.data value
	.alignment	1
	res	1

positive: division of u2 memory by immediate to memory

	div	u2 [@value], u2 [@constant], u2 217
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 54327
	.data value
	.alignment	2
	res	2

positive: division of u4 memory by immediate to memory

	div	u4 [@value], u4 [@constant], u4 2048
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4003214787
	.data value
	.alignment	4
	res	4

positive: division of u8 memory by immediate to memory

	div	u8 [@value], u8 [@constant], u8 3513217
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 2298456778043724
	.data value
	.alignment	8
	res	8

positive: division of f4 memory by immediate to memory

	div	f4 [@value], f4 [@constant], f4 -1.5
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.5
	.data value
	.alignment	4
	res	4

positive: division of f8 memory by immediate to memory

	div	f8 [@value], f8 [@constant], f8 -1.5
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -6.75
	.data value
	.alignment	8
	res	8

positive: division of s1 immediate by register to memory

	mov	s1 $0, s1 13
	div	s1 [@value], s1 75, s1 $0
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: division of s2 immediate by register to memory

	mov	s2 $0, s2 874
	div	s2 [@value], s2 21497, s2 $0
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: division of s4 immediate by register to memory

	mov	s4 $0, s4 54
	div	s4 [@value], s4 1546421779, s4 $0
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of s8 immediate by register to memory

	mov	s8 $0, s8 68496414
	div	s8 [@value], s8 4654321321779787245, s8 $0
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of u1 immediate by register to memory

	mov	u1 $0, u1 64
	div	u1 [@value], u1 231, u1 $0
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: division of u2 immediate by register to memory

	mov	u2 $0, u2 217
	div	u2 [@value], u2 54327, u2 $0
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: division of u4 immediate by register to memory

	mov	u4 $0, u4 2048
	div	u4 [@value], u4 4003214787, u4 $0
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of u8 immediate by register to memory

	mov	u8 $0, u8 3513217
	div	u8 [@value], u8 2298456778043724, u8 $0
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of f4 immediate by register to memory

	mov	f4 $0, f4 -1.5
	div	f4 [@value], f4 7.5, f4 $0
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of f8 immediate by register to memory

	mov	f8 $0, f8 -1.5
	div	f8 [@value], f8 -6.75, f8 $0
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of s1 register by register to memory

	mov	s1 $0, s1 75
	mov	s1 $1, s1 13
	div	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: division of s2 register by register to memory

	mov	s2 $0, s2 21497
	mov	s2 $1, s2 874
	div	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: division of s4 register by register to memory

	mov	s4 $0, s4 1546421779
	mov	s4 $1, s4 54
	div	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of s8 register by register to memory

	mov	s8 $0, s8 4654321321779787245
	mov	s8 $1, s8 68496414
	div	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of u1 register by register to memory

	mov	u1 $0, u1 231
	mov	u1 $1, u1 64
	div	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: division of u2 register by register to memory

	mov	u2 $0, u2 54327
	mov	u2 $1, u2 217
	div	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: division of u4 register by register to memory

	mov	u4 $0, u4 4003214787
	mov	u4 $1, u4 2048
	div	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of u8 register by register to memory

	mov	u8 $0, u8 2298456778043724
	mov	u8 $1, u8 3513217
	div	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of f4 register by register to memory

	mov	f4 $0, f4 7.5
	mov	f4 $1, f4 -1.5
	div	f4 [@value], f4 $0, f4 $1
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: division of f8 register by register to memory

	mov	f8 $0, f8 -6.75
	mov	f8 $1, f8 -1.5
	div	f8 [@value], f8 $0, f8 $1
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: division of s1 memory by register to memory

	mov	s1 $0, s1 13
	div	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 75
	.data value
	.alignment	1
	res	1

positive: division of s2 memory by register to memory

	mov	s2 $0, s2 874
	div	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 21497
	.data value
	.alignment	2
	res	2

positive: division of s4 memory by register to memory

	mov	s4 $0, s4 54
	div	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1546421779
	.data value
	.alignment	4
	res	4

positive: division of s8 memory by register to memory

	mov	s8 $0, s8 68496414
	div	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 4654321321779787245
	.data value
	.alignment	8
	res	8

positive: division of u1 memory by register to memory

	mov	u1 $0, u1 64
	div	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 231
	.data value
	.alignment	1
	res	1

positive: division of u2 memory by register to memory

	mov	u2 $0, u2 217
	div	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 54327
	.data value
	.alignment	2
	res	2

positive: division of u4 memory by register to memory

	mov	u4 $0, u4 2048
	div	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4003214787
	.data value
	.alignment	4
	res	4

positive: division of u8 memory by register to memory

	mov	u8 $0, u8 3513217
	div	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 2298456778043724
	.data value
	.alignment	8
	res	8

positive: division of f4 memory by register to memory

	mov	f4 $0, f4 -1.5
	div	f4 [@value], f4 [@constant], f4 $0
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 7.5
	.data value
	.alignment	4
	res	4

positive: division of f8 memory by register to memory

	mov	f8 $0, f8 -1.5
	div	f8 [@value], f8 [@constant], f8 $0
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -6.75
	.data value
	.alignment	8
	res	8

positive: division of s1 immediate by memory to memory

	div	s1 [@value], s1 75, s1 [@constant]
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 13
	.data value
	.alignment	1
	res	1

positive: division of s2 immediate by memory to memory

	div	s2 [@value], s2 21497, s2 [@constant]
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 874
	.data value
	.alignment	2
	res	2

positive: division of s4 immediate by memory to memory

	div	s4 [@value], s4 1546421779, s4 [@constant]
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 54
	.data value
	.alignment	4
	res	4

positive: division of s8 immediate by memory to memory

	div	s8 [@value], s8 4654321321779787245, s8 [@constant]
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 68496414
	.data value
	.alignment	8
	res	8

positive: division of u1 immediate by memory to memory

	div	u1 [@value], u1 231, u1 [@constant]
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 64
	.data value
	.alignment	1
	res	1

positive: division of u2 immediate by memory to memory

	div	u2 [@value], u2 54327, u2 [@constant]
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 217
	.data value
	.alignment	2
	res	2

positive: division of u4 immediate by memory to memory

	div	u4 [@value], u4 4003214787, u4 [@constant]
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2048
	.data value
	.alignment	4
	res	4

positive: division of u8 immediate by memory to memory

	div	u8 [@value], u8 2298456778043724, u8 [@constant]
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

positive: division of f4 immediate by memory to memory

	div	f4 [@value], f4 7.5, f4 [@constant]
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.5
	.data value
	.alignment	4
	res	4

positive: division of f8 immediate by memory to memory

	div	f8 [@value], f8 -6.75, f8 [@constant]
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.5
	.data value
	.alignment	8
	res	8

positive: division of s1 register by memory to memory

	mov	s1 $0, s1 75
	div	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 13
	.data value
	.alignment	1
	res	1

positive: division of s2 register by memory to memory

	mov	s2 $0, s2 21497
	div	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 874
	.data value
	.alignment	2
	res	2

positive: division of s4 register by memory to memory

	mov	s4 $0, s4 1546421779
	div	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 54
	.data value
	.alignment	4
	res	4

positive: division of s8 register by memory to memory

	mov	s8 $0, s8 4654321321779787245
	div	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 68496414
	.data value
	.alignment	8
	res	8

positive: division of u1 register by memory to memory

	mov	u1 $0, u1 231
	div	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 64
	.data value
	.alignment	1
	res	1

positive: division of u2 register by memory to memory

	mov	u2 $0, u2 54327
	div	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 217
	.data value
	.alignment	2
	res	2

positive: division of u4 register by memory to memory

	mov	u4 $0, u4 4003214787
	div	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2048
	.data value
	.alignment	4
	res	4

positive: division of u8 register by memory to memory

	mov	u8 $0, u8 2298456778043724
	div	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

positive: division of f4 register by memory to memory

	mov	f4 $0, f4 7.5
	div	f4 [@value], f4 $0, f4 [@constant]
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 -1.5
	.data value
	.alignment	4
	res	4

positive: division of f8 register by memory to memory

	mov	f8 $0, f8 -6.75
	div	f8 [@value], f8 $0, f8 [@constant]
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 -1.5
	.data value
	.alignment	8
	res	8

positive: division of s1 memory by memory to memory

	div	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 75
	.const constant2
	.alignment	1
	def	s1 13
	.data value
	.alignment	1
	res	1

positive: division of s2 memory by memory to memory

	div	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 21497
	.const constant2
	.alignment	2
	def	s2 874
	.data value
	.alignment	2
	res	2

positive: division of s4 memory by memory to memory

	div	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 28637440
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 1546421779
	.const constant2
	.alignment	4
	def	s4 54
	.data value
	.alignment	4
	res	4

positive: division of s8 memory by memory to memory

	div	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 67949853867
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 4654321321779787245
	.const constant2
	.alignment	8
	def	s8 68496414
	.data value
	.alignment	8
	res	8

positive: division of u1 memory by memory to memory

	div	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 231
	.const constant2
	.alignment	1
	def	u1 64
	.data value
	.alignment	1
	res	1

positive: division of u2 memory by memory to memory

	div	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 250
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 54327
	.const constant2
	.alignment	2
	def	u2 217
	.data value
	.alignment	2
	res	2

positive: division of u4 memory by memory to memory

	div	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 1954694
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 4003214787
	.const constant2
	.alignment	4
	def	u4 2048
	.data value
	.alignment	4
	res	4

positive: division of u8 memory by memory to memory

	div	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 654231372
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 2298456778043724
	.const constant2
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

positive: division of f4 memory by memory to memory

	div	f4 [@value], f4 [@constant1], f4 [@constant2]
	breq	+1, f4 [@value], f4 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 7.5
	.const constant2
	.alignment	4
	def	f4 -1.5
	.data value
	.alignment	4
	res	4

positive: division of f8 memory by memory to memory

	div	f8 [@value], f8 [@constant1], f8 [@constant2]
	breq	+1, f8 [@value], f8 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -6.75
	.const constant2
	.alignment	8
	def	f8 -1.5
	.data value
	.alignment	8
	res	8

# mod instruction

positive: modulo of s1 immediate by immediate to register

	mod	s1 $0, s1 75, s1 13
	breq	+1, s1 $0, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s2 immediate by immediate to register

	mod	s2 $0, s2 21497, s2 874
	breq	+1, s2 $0, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s4 immediate by immediate to register

	mod	s4 $0, s4 1546421779, s4 54
	breq	+1, s4 $0, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s8 immediate by immediate to register

	mod	s8 $0, s8 4654321321779787245, s8 68496414
	breq	+1, s8 $0, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u1 immediate by immediate to register

	mod	u1 $0, u1 231, u1 64
	breq	+1, u1 $0, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u2 immediate by immediate to register

	mod	u2 $0, u2 54327, u2 217
	breq	+1, u2 $0, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u4 immediate by immediate to register

	mod	u4 $0, u4 4003214787, u4 2048
	breq	+1, u4 $0, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u8 immediate by immediate to register

	mod	u8 $0, u8 2298456778043724, u8 3513217
	breq	+1, u8 $0, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s1 register by immediate to register

	mov	s1 $0, s1 75
	mod	s1 $1, s1 $0, s1 13
	breq	+1, s1 $1, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s2 register by immediate to register

	mov	s2 $0, s2 21497
	mod	s2 $1, s2 $0, s2 874
	breq	+1, s2 $1, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s4 register by immediate to register

	mov	s4 $0, s4 1546421779
	mod	s4 $1, s4 $0, s4 54
	breq	+1, s4 $1, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s8 register by immediate to register

	mov	s8 $0, s8 4654321321779787245
	mod	s8 $1, s8 $0, s8 68496414
	breq	+1, s8 $1, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u1 register by immediate to register

	mov	u1 $0, u1 231
	mod	u1 $1, u1 $0, u1 64
	breq	+1, u1 $1, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u2 register by immediate to register

	mov	u2 $0, u2 54327
	mod	u2 $1, u2 $0, u2 217
	breq	+1, u2 $1, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u4 register by immediate to register

	mov	u4 $0, u4 4003214787
	mod	u4 $1, u4 $0, u4 2048
	breq	+1, u4 $1, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u8 register by immediate to register

	mov	u8 $0, u8 2298456778043724
	mod	u8 $1, u8 $0, u8 3513217
	breq	+1, u8 $1, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s1 memory by immediate to register

	mod	s1 $0, s1 [@constant], s1 13
	breq	+1, s1 $0, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 75

positive: modulo of s2 memory by immediate to register

	mod	s2 $0, s2 [@constant], s2 874
	breq	+1, s2 $0, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 21497

positive: modulo of s4 memory by immediate to register

	mod	s4 $0, s4 [@constant], s4 54
	breq	+1, s4 $0, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1546421779

positive: modulo of s8 memory by immediate to register

	mod	s8 $0, s8 [@constant], s8 68496414
	breq	+1, s8 $0, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 4654321321779787245

positive: modulo of u1 memory by immediate to register

	mod	u1 $0, u1 [@constant], u1 64
	breq	+1, u1 $0, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 231

positive: modulo of u2 memory by immediate to register

	mod	u2 $0, u2 [@constant], u2 217
	breq	+1, u2 $0, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 54327

positive: modulo of u4 memory by immediate to register

	mod	u4 $0, u4 [@constant], u4 2048
	breq	+1, u4 $0, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4003214787

positive: modulo of u8 memory by immediate to register

	mod	u8 $0, u8 [@constant], u8 3513217
	breq	+1, u8 $0, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 2298456778043724

positive: modulo of s1 immediate by register to register

	mov	s1 $0, s1 13
	mod	s1 $1, s1 75, s1 $0
	breq	+1, s1 $1, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s2 immediate by register to register

	mov	s2 $0, s2 874
	mod	s2 $1, s2 21497, s2 $0
	breq	+1, s2 $1, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s4 immediate by register to register

	mov	s4 $0, s4 54
	mod	s4 $1, s4 1546421779, s4 $0
	breq	+1, s4 $1, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s8 immediate by register to register

	mov	s8 $0, s8 68496414
	mod	s8 $1, s8 4654321321779787245, s8 $0
	breq	+1, s8 $1, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u1 immediate by register to register

	mov	u1 $0, u1 64
	mod	u1 $1, u1 231, u1 $0
	breq	+1, u1 $1, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u2 immediate by register to register

	mov	u2 $0, u2 217
	mod	u2 $1, u2 54327, u2 $0
	breq	+1, u2 $1, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u4 immediate by register to register

	mov	u4 $0, u4 2048
	mod	u4 $1, u4 4003214787, u4 $0
	breq	+1, u4 $1, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u8 immediate by register to register

	mov	u8 $0, u8 3513217
	mod	u8 $1, u8 2298456778043724, u8 $0
	breq	+1, u8 $1, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s1 register by register to register

	mov	s1 $0, s1 75
	mov	s1 $1, s1 13
	mod	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s2 register by register to register

	mov	s2 $0, s2 21497
	mov	s2 $1, s2 874
	mod	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s4 register by register to register

	mov	s4 $0, s4 1546421779
	mov	s4 $1, s4 54
	mod	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s8 register by register to register

	mov	s8 $0, s8 4654321321779787245
	mov	s8 $1, s8 68496414
	mod	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u1 register by register to register

	mov	u1 $0, u1 231
	mov	u1 $1, u1 64
	mod	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u2 register by register to register

	mov	u2 $0, u2 54327
	mov	u2 $1, u2 217
	mod	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u4 register by register to register

	mov	u4 $0, u4 4003214787
	mov	u4 $1, u4 2048
	mod	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of u8 register by register to register

	mov	u8 $0, u8 2298456778043724
	mov	u8 $1, u8 3513217
	mod	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: modulo of s1 memory by register to register

	mov	s1 $0, s1 13
	mod	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 75

positive: modulo of s2 memory by register to register

	mov	s2 $0, s2 874
	mod	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 21497

positive: modulo of s4 memory by register to register

	mov	s4 $0, s4 54
	mod	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1546421779

positive: modulo of s8 memory by register to register

	mov	s8 $0, s8 68496414
	mod	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 4654321321779787245

positive: modulo of u1 memory by register to register

	mov	u1 $0, u1 64
	mod	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 231

positive: modulo of u2 memory by register to register

	mov	u2 $0, u2 217
	mod	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 54327

positive: modulo of u4 memory by register to register

	mov	u4 $0, u4 2048
	mod	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4003214787

positive: modulo of u8 memory by register to register

	mov	u8 $0, u8 3513217
	mod	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 2298456778043724

positive: modulo of s1 immediate by memory to register

	mod	s1 $0, s1 75, s1 [@constant]
	breq	+1, s1 $0, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 13

positive: modulo of s2 immediate by memory to register

	mod	s2 $0, s2 21497, s2 [@constant]
	breq	+1, s2 $0, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 874

positive: modulo of s4 immediate by memory to register

	mod	s4 $0, s4 1546421779, s4 [@constant]
	breq	+1, s4 $0, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 54

positive: modulo of s8 immediate by memory to register

	mod	s8 $0, s8 4654321321779787245, s8 [@constant]
	breq	+1, s8 $0, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 68496414

positive: modulo of u1 immediate by memory to register

	mod	u1 $0, u1 231, u1 [@constant]
	breq	+1, u1 $0, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 64

positive: modulo of u2 immediate by memory to register

	mod	u2 $0, u2 54327, u2 [@constant]
	breq	+1, u2 $0, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 217

positive: modulo of u4 immediate by memory to register

	mod	u4 $0, u4 4003214787, u4 [@constant]
	breq	+1, u4 $0, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2048

positive: modulo of u8 immediate by memory to register

	mod	u8 $0, u8 2298456778043724, u8 [@constant]
	breq	+1, u8 $0, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217

positive: modulo of s1 register by memory to register

	mov	s1 $0, s1 75
	mod	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 13

positive: modulo of s2 register by memory to register

	mov	s2 $0, s2 21497
	mod	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 874

positive: modulo of s4 register by memory to register

	mov	s4 $0, s4 1546421779
	mod	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 54

positive: modulo of s8 register by memory to register

	mov	s8 $0, s8 4654321321779787245
	mod	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 68496414

positive: modulo of u1 register by memory to register

	mov	u1 $0, u1 231
	mod	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 64

positive: modulo of u2 register by memory to register

	mov	u2 $0, u2 54327
	mod	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 217

positive: modulo of u4 register by memory to register

	mov	u4 $0, u4 4003214787
	mod	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2048

positive: modulo of u8 register by memory to register

	mov	u8 $0, u8 2298456778043724
	mod	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217

positive: modulo of s1 memory by memory to register

	mod	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 75
	.const constant2
	.alignment	1
	def	s1 13

positive: modulo of s2 memory by memory to register

	mod	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 21497
	.const constant2
	.alignment	2
	def	s2 874

positive: modulo of s4 memory by memory to register

	mod	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 1546421779
	.const constant2
	.alignment	4
	def	s4 54

positive: modulo of s8 memory by memory to register

	mod	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 4654321321779787245
	.const constant2
	.alignment	8
	def	s8 68496414

positive: modulo of u1 memory by memory to register

	mod	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 231
	.const constant2
	.alignment	1
	def	u1 64

positive: modulo of u2 memory by memory to register

	mod	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 54327
	.const constant2
	.alignment	2
	def	u2 217

positive: modulo of u4 memory by memory to register

	mod	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 4003214787
	.const constant2
	.alignment	4
	def	u4 2048

positive: modulo of u8 memory by memory to register

	mod	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 2298456778043724
	.const constant2
	.alignment	8
	def	u8 3513217

positive: modulo of s1 immediate by immediate to memory

	mod	s1 [@value], s1 75, s1 13
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: modulo of s2 immediate by immediate to memory

	mod	s2 [@value], s2 21497, s2 874
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: modulo of s4 immediate by immediate to memory

	mod	s4 [@value], s4 1546421779, s4 54
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: modulo of s8 immediate by immediate to memory

	mod	s8 [@value], s8 4654321321779787245, s8 68496414
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: modulo of u1 immediate by immediate to memory

	mod	u1 [@value], u1 231, u1 64
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: modulo of u2 immediate by immediate to memory

	mod	u2 [@value], u2 54327, u2 217
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: modulo of u4 immediate by immediate to memory

	mod	u4 [@value], u4 4003214787, u4 2048
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: modulo of u8 immediate by immediate to memory

	mod	u8 [@value], u8 2298456778043724, u8 3513217
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: modulo of s1 register by immediate to memory

	mov	s1 $0, s1 75
	mod	s1 [@value], s1 $0, s1 13
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: modulo of s2 register by immediate to memory

	mov	s2 $0, s2 21497
	mod	s2 [@value], s2 $0, s2 874
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: modulo of s4 register by immediate to memory

	mov	s4 $0, s4 1546421779
	mod	s4 [@value], s4 $0, s4 54
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: modulo of s8 register by immediate to memory

	mov	s8 $0, s8 4654321321779787245
	mod	s8 [@value], s8 $0, s8 68496414
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: modulo of u1 register by immediate to memory

	mov	u1 $0, u1 231
	mod	u1 [@value], u1 $0, u1 64
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: modulo of u2 register by immediate to memory

	mov	u2 $0, u2 54327
	mod	u2 [@value], u2 $0, u2 217
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: modulo of u4 register by immediate to memory

	mov	u4 $0, u4 4003214787
	mod	u4 [@value], u4 $0, u4 2048
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: modulo of u8 register by immediate to memory

	mov	u8 $0, u8 2298456778043724
	mod	u8 [@value], u8 $0, u8 3513217
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: modulo of s1 memory by immediate to memory

	mod	s1 [@value], s1 [@constant], s1 13
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 75
	.data value
	.alignment	1
	res	1

positive: modulo of s2 memory by immediate to memory

	mod	s2 [@value], s2 [@constant], s2 874
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 21497
	.data value
	.alignment	2
	res	2

positive: modulo of s4 memory by immediate to memory

	mod	s4 [@value], s4 [@constant], s4 54
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1546421779
	.data value
	.alignment	4
	res	4

positive: modulo of s8 memory by immediate to memory

	mod	s8 [@value], s8 [@constant], s8 68496414
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 4654321321779787245
	.data value
	.alignment	8
	res	8

positive: modulo of u1 memory by immediate to memory

	mod	u1 [@value], u1 [@constant], u1 64
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 231
	.data value
	.alignment	1
	res	1

positive: modulo of u2 memory by immediate to memory

	mod	u2 [@value], u2 [@constant], u2 217
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 54327
	.data value
	.alignment	2
	res	2

positive: modulo of u4 memory by immediate to memory

	mod	u4 [@value], u4 [@constant], u4 2048
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4003214787
	.data value
	.alignment	4
	res	4

positive: modulo of u8 memory by immediate to memory

	mod	u8 [@value], u8 [@constant], u8 3513217
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 2298456778043724
	.data value
	.alignment	8
	res	8

positive: modulo of s1 immediate by register to memory

	mov	s1 $0, s1 13
	mod	s1 [@value], s1 75, s1 $0
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: modulo of s2 immediate by register to memory

	mov	s2 $0, s2 874
	mod	s2 [@value], s2 21497, s2 $0
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: modulo of s4 immediate by register to memory

	mov	s4 $0, s4 54
	mod	s4 [@value], s4 1546421779, s4 $0
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: modulo of s8 immediate by register to memory

	mov	s8 $0, s8 68496414
	mod	s8 [@value], s8 4654321321779787245, s8 $0
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: modulo of u1 immediate by register to memory

	mov	u1 $0, u1 64
	mod	u1 [@value], u1 231, u1 $0
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: modulo of u2 immediate by register to memory

	mov	u2 $0, u2 217
	mod	u2 [@value], u2 54327, u2 $0
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: modulo of u4 immediate by register to memory

	mov	u4 $0, u4 2048
	mod	u4 [@value], u4 4003214787, u4 $0
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: modulo of u8 immediate by register to memory

	mov	u8 $0, u8 3513217
	mod	u8 [@value], u8 2298456778043724, u8 $0
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: modulo of s1 register by register to memory

	mov	s1 $0, s1 75
	mov	s1 $1, s1 13
	mod	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: modulo of s2 register by register to memory

	mov	s2 $0, s2 21497
	mov	s2 $1, s2 874
	mod	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: modulo of s4 register by register to memory

	mov	s4 $0, s4 1546421779
	mov	s4 $1, s4 54
	mod	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: modulo of s8 register by register to memory

	mov	s8 $0, s8 4654321321779787245
	mov	s8 $1, s8 68496414
	mod	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: modulo of u1 register by register to memory

	mov	u1 $0, u1 231
	mov	u1 $1, u1 64
	mod	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: modulo of u2 register by register to memory

	mov	u2 $0, u2 54327
	mov	u2 $1, u2 217
	mod	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: modulo of u4 register by register to memory

	mov	u4 $0, u4 4003214787
	mov	u4 $1, u4 2048
	mod	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: modulo of u8 register by register to memory

	mov	u8 $0, u8 2298456778043724
	mov	u8 $1, u8 3513217
	mod	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: modulo of s1 memory by register to memory

	mov	s1 $0, s1 13
	mod	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 75
	.data value
	.alignment	1
	res	1

positive: modulo of s2 memory by register to memory

	mov	s2 $0, s2 874
	mod	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 21497
	.data value
	.alignment	2
	res	2

positive: modulo of s4 memory by register to memory

	mov	s4 $0, s4 54
	mod	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 1546421779
	.data value
	.alignment	4
	res	4

positive: modulo of s8 memory by register to memory

	mov	s8 $0, s8 68496414
	mod	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 4654321321779787245
	.data value
	.alignment	8
	res	8

positive: modulo of u1 memory by register to memory

	mov	u1 $0, u1 64
	mod	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 231
	.data value
	.alignment	1
	res	1

positive: modulo of u2 memory by register to memory

	mov	u2 $0, u2 217
	mod	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 54327
	.data value
	.alignment	2
	res	2

positive: modulo of u4 memory by register to memory

	mov	u4 $0, u4 2048
	mod	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4003214787
	.data value
	.alignment	4
	res	4

positive: modulo of u8 memory by register to memory

	mov	u8 $0, u8 3513217
	mod	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 2298456778043724
	.data value
	.alignment	8
	res	8

positive: modulo of s1 immediate by memory to memory

	mod	s1 [@value], s1 75, s1 [@constant]
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 13
	.data value
	.alignment	1
	res	1

positive: modulo of s2 immediate by memory to memory

	mod	s2 [@value], s2 21497, s2 [@constant]
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 874
	.data value
	.alignment	2
	res	2

positive: modulo of s4 immediate by memory to memory

	mod	s4 [@value], s4 1546421779, s4 [@constant]
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 54
	.data value
	.alignment	4
	res	4

positive: modulo of s8 immediate by memory to memory

	mod	s8 [@value], s8 4654321321779787245, s8 [@constant]
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 68496414
	.data value
	.alignment	8
	res	8

positive: modulo of u1 immediate by memory to memory

	mod	u1 [@value], u1 231, u1 [@constant]
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 64
	.data value
	.alignment	1
	res	1

positive: modulo of u2 immediate by memory to memory

	mod	u2 [@value], u2 54327, u2 [@constant]
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 217
	.data value
	.alignment	2
	res	2

positive: modulo of u4 immediate by memory to memory

	mod	u4 [@value], u4 4003214787, u4 [@constant]
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2048
	.data value
	.alignment	4
	res	4

positive: modulo of u8 immediate by memory to memory

	mod	u8 [@value], u8 2298456778043724, u8 [@constant]
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

positive: modulo of s1 register by memory to memory

	mov	s1 $0, s1 75
	mod	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 13
	.data value
	.alignment	1
	res	1

positive: modulo of s2 register by memory to memory

	mov	s2 $0, s2 21497
	mod	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 874
	.data value
	.alignment	2
	res	2

positive: modulo of s4 register by memory to memory

	mov	s4 $0, s4 1546421779
	mod	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 54
	.data value
	.alignment	4
	res	4

positive: modulo of s8 register by memory to memory

	mov	s8 $0, s8 4654321321779787245
	mod	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 68496414
	.data value
	.alignment	8
	res	8

positive: modulo of u1 register by memory to memory

	mov	u1 $0, u1 231
	mod	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 64
	.data value
	.alignment	1
	res	1

positive: modulo of u2 register by memory to memory

	mov	u2 $0, u2 54327
	mod	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 217
	.data value
	.alignment	2
	res	2

positive: modulo of u4 register by memory to memory

	mov	u4 $0, u4 4003214787
	mod	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2048
	.data value
	.alignment	4
	res	4

positive: modulo of u8 register by memory to memory

	mov	u8 $0, u8 2298456778043724
	mod	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

positive: modulo of s1 memory by memory to memory

	mod	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 10
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 75
	.const constant2
	.alignment	1
	def	s1 13
	.data value
	.alignment	1
	res	1

positive: modulo of s2 memory by memory to memory

	mod	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 521
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 21497
	.const constant2
	.alignment	2
	def	s2 874
	.data value
	.alignment	2
	res	2

positive: modulo of s4 memory by memory to memory

	mod	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 19
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 1546421779
	.const constant2
	.alignment	4
	def	s4 54
	.data value
	.alignment	4
	res	4

positive: modulo of s8 memory by memory to memory

	mod	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 66254307
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 4654321321779787245
	.const constant2
	.alignment	8
	def	s8 68496414
	.data value
	.alignment	8
	res	8

positive: modulo of u1 memory by memory to memory

	mod	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 39
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 231
	.const constant2
	.alignment	1
	def	u1 64
	.data value
	.alignment	1
	res	1

positive: modulo of u2 memory by memory to memory

	mod	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 77
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 54327
	.const constant2
	.alignment	2
	def	u2 217
	.data value
	.alignment	2
	res	2

positive: modulo of u4 memory by memory to memory

	mod	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 1475
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 4003214787
	.const constant2
	.alignment	4
	def	u4 2048
	.data value
	.alignment	4
	res	4

positive: modulo of u8 memory by memory to memory

	mod	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 2298456778043724
	.const constant2
	.alignment	8
	def	u8 3513217
	.data value
	.alignment	8
	res	8

# not instruction

positive: logical not of s1 immediate to register

	not	s1 $0, s1 45
	breq	+1, s1 $0, s1 -46
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of s2 immediate to register

	not	s2 $0, s2 9871
	breq	+1, s2 $0, s2 -9872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of s4 immediate to register

	not	s4 $0, s4 65477796
	breq	+1, s4 $0, s4 -65477797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of s8 immediate to register

	not	s8 $0, s8 -4876542121127799972
	breq	+1, s8 $0, s8 4876542121127799971
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of u1 immediate to register

	not	u1 $0, u1 0x74
	breq	+1, u1 $0, u1 0x8b
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of u2 immediate to register

	not	u2 $0, u2 0x8791
	breq	+1, u2 $0, u2 0x786e
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of u4 immediate to register

	not	u4 $0, u4 0x11223344
	breq	+1, u4 $0, u4 0xeeddccbb
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of u8 immediate to register

	not	u8 $0, u8 0x0123456789abcdef
	breq	+1, u8 $0, u8 0xfedcba9876543210
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of s1 register to register

	mov	s1 $0, s1 45
	not	s1 $1, s1 $0
	breq	+1, s1 $1, s1 -46
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of s2 register to register

	mov	s2 $0, s2 9871
	not	s2 $1, s2 $0
	breq	+1, s2 $1, s2 -9872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of s4 register to register

	mov	s4 $0, s4 65477796
	not	s4 $1, s4 $0
	breq	+1, s4 $1, s4 -65477797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of s8 register to register

	mov	s8 $0, s8 -4876542121127799972
	not	s8 $1, s8 $0
	breq	+1, s8 $1, s8 4876542121127799971
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of u1 register to register

	mov	u1 $0, u1 0x74
	not	u1 $1, u1 $0
	breq	+1, u1 $1, u1 0x8b
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of u2 register to register

	mov	u2 $0, u2 0x8791
	not	u2 $1, u2 $0
	breq	+1, u2 $1, u2 0x786e
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of u4 register to register

	mov	u4 $0, u4 0x11223344
	not	u4 $1, u4 $0
	breq	+1, u4 $1, u4 0xeeddccbb
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of u8 register to register

	mov	u8 $0, u8 0x0123456789abcdef
	not	u8 $1, u8 $0
	breq	+1, u8 $1, u8 0xfedcba9876543210
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical not of s1 memory to register

	not	s1 $0, s1 [@constant]
	breq	+1, s1 $0, s1 -46
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 45

positive: logical not of s2 memory to register

	not	s2 $0, s2 [@constant]
	breq	+1, s2 $0, s2 -9872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 9871

positive: logical not of s4 memory to register

	not	s4 $0, s4 [@constant]
	breq	+1, s4 $0, s4 -65477797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 65477796

positive: logical not of s8 memory to register

	not	s8 $0, s8 [@constant]
	breq	+1, s8 $0, s8 4876542121127799971
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4876542121127799972

positive: logical not of u1 memory to register

	not	u1 $0, u1 [@constant]
	breq	+1, u1 $0, u1 0x8b
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x74

positive: logical not of u2 memory to register

	not	u2 $0, u2 [@constant]
	breq	+1, u2 $0, u2 0x786e
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x8791

positive: logical not of u4 memory to register

	not	u4 $0, u4 [@constant]
	breq	+1, u4 $0, u4 0xeeddccbb
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x11223344

positive: logical not of u8 memory to register

	not	u8 $0, u8 [@constant]
	breq	+1, u8 $0, u8 0xfedcba9876543210
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef

positive: logical not of s1 immediate to memory

	not	s1 [@value], s1 45
	breq	+1, s1 [@value], s1 -46
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical not of s2 immediate to memory

	not	s2 [@value], s2 9871
	breq	+1, s2 [@value], s2 -9872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical not of s4 immediate to memory

	not	s4 [@value], s4 65477796
	breq	+1, s4 [@value], s4 -65477797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical not of s8 immediate to memory

	not	s8 [@value], s8 -4876542121127799972
	breq	+1, s8 [@value], s8 4876542121127799971
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical not of u1 immediate to memory

	not	u1 [@value], u1 0x74
	breq	+1, u1 [@value], u1 0x8b
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical not of u2 immediate to memory

	not	u2 [@value], u2 0x8791
	breq	+1, u2 [@value], u2 0x786e
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical not of u4 immediate to memory

	not	u4 [@value], u4 0x11223344
	breq	+1, u4 [@value], u4 0xeeddccbb
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical not of u8 immediate to memory

	not	u8 [@value], u8 0x0123456789abcdef
	breq	+1, u8 [@value], u8 0xfedcba9876543210
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical not of s1 register to memory

	mov	s1 $0, s1 45
	not	s1 [@value], s1 $0
	breq	+1, s1 [@value], s1 -46
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical not of s2 register to memory

	mov	s2 $0, s2 9871
	not	s2 [@value], s2 $0
	breq	+1, s2 [@value], s2 -9872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical not of s4 register to memory

	mov	s4 $0, s4 65477796
	not	s4 [@value], s4 $0
	breq	+1, s4 [@value], s4 -65477797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical not of s8 register to memory

	mov	s8 $0, s8 -4876542121127799972
	not	s8 [@value], s8 $0
	breq	+1, s8 [@value], s8 4876542121127799971
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical not of u1 register to memory

	mov	u1 $0, u1 0x74
	not	u1 [@value], u1 $0
	breq	+1, u1 [@value], u1 0x8b
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical not of u2 register to memory

	mov	u2 $0, u2 0x8791
	not	u2 [@value], u2 $0
	breq	+1, u2 [@value], u2 0x786e
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical not of u4 register to memory

	mov	u4 $0, u4 0x11223344
	not	u4 [@value], u4 $0
	breq	+1, u4 [@value], u4 0xeeddccbb
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical not of u8 register to memory

	mov	u8 $0, u8 0x0123456789abcdef
	not	u8 [@value], u8 $0
	breq	+1, u8 [@value], u8 0xfedcba9876543210
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical not of s1 memory to memory

	not	s1 [@value], s1 [@constant]
	breq	+1, s1 [@value], s1 -46
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 45
	.data value
	.alignment	1
	res	1

positive: logical not of s2 memory to memory

	not	s2 [@value], s2 [@constant]
	breq	+1, s2 [@value], s2 -9872
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 9871
	.data value
	.alignment	2
	res	2

positive: logical not of s4 memory to memory

	not	s4 [@value], s4 [@constant]
	breq	+1, s4 [@value], s4 -65477797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 65477796
	.data value
	.alignment	4
	res	4

positive: logical not of s8 memory to memory

	not	s8 [@value], s8 [@constant]
	breq	+1, s8 [@value], s8 4876542121127799971
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4876542121127799972
	.data value
	.alignment	8
	res	8

positive: logical not of u1 memory to memory

	not	u1 [@value], u1 [@constant]
	breq	+1, u1 [@value], u1 0x8b
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 0x74
	.data value
	.alignment	1
	res	1

positive: logical not of u2 memory to memory

	not	u2 [@value], u2 [@constant]
	breq	+1, u2 [@value], u2 0x786e
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 0x8791
	.data value
	.alignment	2
	res	2

positive: logical not of u4 memory to memory

	not	u4 [@value], u4 [@constant]
	breq	+1, u4 [@value], u4 0xeeddccbb
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 0x11223344
	.data value
	.alignment	4
	res	4

positive: logical not of u8 memory to memory

	not	u8 [@value], u8 [@constant]
	breq	+1, u8 [@value], u8 0xfedcba9876543210
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 0x0123456789abcdef
	.data value
	.alignment	8
	res	8

# and instruction

positive: logical and of s1 immediate and immediate to register

	and	s1 $0, s1 54, s1 -13
	breq	+1, s1 $0, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s2 immediate and immediate to register

	and	s2 $0, s2 7224, s2 6479
	breq	+1, s2 $0, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s4 immediate and immediate to register

	and	s4 $0, s4 231014977, s4 98722224
	breq	+1, s4 $0, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s8 immediate and immediate to register

	and	s8 $0, s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 $0, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u1 immediate and immediate to register

	and	u1 $0, u1 176, u1 17
	breq	+1, u1 $0, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u2 immediate and immediate to register

	and	u2 $0, u2 41774, u2 8764
	breq	+1, u2 $0, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u4 immediate and immediate to register

	and	u4 $0, u4 2965411179, u4 1132125457
	breq	+1, u4 $0, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u8 immediate and immediate to register

	and	u8 $0, u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 $0, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s1 register and immediate to register

	mov	s1 $0, s1 54
	and	s1 $1, s1 $0, s1 -13
	breq	+1, s1 $1, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s2 register and immediate to register

	mov	s2 $0, s2 7224
	and	s2 $1, s2 $0, s2 6479
	breq	+1, s2 $1, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s4 register and immediate to register

	mov	s4 $0, s4 231014977
	and	s4 $1, s4 $0, s4 98722224
	breq	+1, s4 $1, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s8 register and immediate to register

	mov	s8 $0, s8 1238769817629834628
	and	s8 $1, s8 $0, s8 -4546546313132132321
	breq	+1, s8 $1, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u1 register and immediate to register

	mov	u1 $0, u1 176
	and	u1 $1, u1 $0, u1 17
	breq	+1, u1 $1, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u2 register and immediate to register

	mov	u2 $0, u2 41774
	and	u2 $1, u2 $0, u2 8764
	breq	+1, u2 $1, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u4 register and immediate to register

	mov	u4 $0, u4 2965411179
	and	u4 $1, u4 $0, u4 1132125457
	breq	+1, u4 $1, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u8 register and immediate to register

	mov	u8 $0, u8 1238769817629834628
	and	u8 $1, u8 $0, u8 898794512221454665
	breq	+1, u8 $1, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s1 memory and immediate to register

	and	s1 $0, s1 [@constant], s1 -13
	breq	+1, s1 $0, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: logical and of s2 memory and immediate to register

	and	s2 $0, s2 [@constant], s2 6479
	breq	+1, s2 $0, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224

positive: logical and of s4 memory and immediate to register

	and	s4 $0, s4 [@constant], s4 98722224
	breq	+1, s4 $0, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: logical and of s8 memory and immediate to register

	and	s8 $0, s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 $0, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: logical and of u1 memory and immediate to register

	and	u1 $0, u1 [@constant], u1 17
	breq	+1, u1 $0, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: logical and of u2 memory and immediate to register

	and	u2 $0, u2 [@constant], u2 8764
	breq	+1, u2 $0, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: logical and of u4 memory and immediate to register

	and	u4 $0, u4 [@constant], u4 1132125457
	breq	+1, u4 $0, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: logical and of u8 memory and immediate to register

	and	u8 $0, u8 [@constant], u8 898794512221454665
	breq	+1, u8 $0, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: logical and of s1 immediate and register to register

	mov	s1 $0, s1 -13
	and	s1 $1, s1 54, s1 $0
	breq	+1, s1 $1, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s2 immediate and register to register

	mov	s2 $0, s2 6479
	and	s2 $1, s2 7224, s2 $0
	breq	+1, s2 $1, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s4 immediate and register to register

	mov	s4 $0, s4 98722224
	and	s4 $1, s4 231014977, s4 $0
	breq	+1, s4 $1, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s8 immediate and register to register

	mov	s8 $0, s8 -4546546313132132321
	and	s8 $1, s8 1238769817629834628, s8 $0
	breq	+1, s8 $1, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u1 immediate and register to register

	mov	u1 $0, u1 17
	and	u1 $1, u1 176, u1 $0
	breq	+1, u1 $1, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u2 immediate and register to register

	mov	u2 $0, u2 8764
	and	u2 $1, u2 41774, u2 $0
	breq	+1, u2 $1, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u4 immediate and register to register

	mov	u4 $0, u4 1132125457
	and	u4 $1, u4 2965411179, u4 $0
	breq	+1, u4 $1, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u8 immediate and register to register

	mov	u8 $0, u8 898794512221454665
	and	u8 $1, u8 1238769817629834628, u8 $0
	breq	+1, u8 $1, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s1 register and register to register

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -13
	and	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s2 register and register to register

	mov	s2 $0, s2 7224
	mov	s2 $1, s2 6479
	and	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s4 register and register to register

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	and	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s8 register and register to register

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	and	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u1 register and register to register

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	and	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u2 register and register to register

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	and	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u4 register and register to register

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	and	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of u8 register and register to register

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	and	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical and of s1 memory and register to register

	mov	s1 $0, s1 -13
	and	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: logical and of s2 memory and register to register

	mov	s2 $0, s2 6479
	and	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224

positive: logical and of s4 memory and register to register

	mov	s4 $0, s4 98722224
	and	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: logical and of s8 memory and register to register

	mov	s8 $0, s8 -4546546313132132321
	and	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: logical and of u1 memory and register to register

	mov	u1 $0, u1 17
	and	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: logical and of u2 memory and register to register

	mov	u2 $0, u2 8764
	and	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: logical and of u4 memory and register to register

	mov	u4 $0, u4 1132125457
	and	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: logical and of u8 memory and register to register

	mov	u8 $0, u8 898794512221454665
	and	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: logical and of s1 immediate and memory to register

	and	s1 $0, s1 54, s1 [@constant]
	breq	+1, s1 $0, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13

positive: logical and of s2 immediate and memory to register

	and	s2 $0, s2 7224, s2 [@constant]
	breq	+1, s2 $0, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: logical and of s4 immediate and memory to register

	and	s4 $0, s4 231014977, s4 [@constant]
	breq	+1, s4 $0, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: logical and of s8 immediate and memory to register

	and	s8 $0, s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 $0, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: logical and of u1 immediate and memory to register

	and	u1 $0, u1 176, u1 [@constant]
	breq	+1, u1 $0, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: logical and of u2 immediate and memory to register

	and	u2 $0, u2 41774, u2 [@constant]
	breq	+1, u2 $0, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: logical and of u4 immediate and memory to register

	and	u4 $0, u4 2965411179, u4 [@constant]
	breq	+1, u4 $0, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: logical and of u8 immediate and memory to register

	and	u8 $0, u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 $0, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: logical and of s1 register and memory to register

	mov	s1 $0, s1 54
	and	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13

positive: logical and of s2 register and memory to register

	mov	s2 $0, s2 7224
	and	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: logical and of s4 register and memory to register

	mov	s4 $0, s4 231014977
	and	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: logical and of s8 register and memory to register

	mov	s8 $0, s8 1238769817629834628
	and	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: logical and of u1 register and memory to register

	mov	u1 $0, u1 176
	and	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: logical and of u2 register and memory to register

	mov	u2 $0, u2 41774
	and	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: logical and of u4 register and memory to register

	mov	u4 $0, u4 2965411179
	and	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: logical and of u8 register and memory to register

	mov	u8 $0, u8 1238769817629834628
	and	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: logical and of s1 memory and memory to register

	and	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -13

positive: logical and of s2 memory and memory to register

	and	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 7224
	.const constant2
	.alignment	2
	def	s2 6479

positive: logical and of s4 memory and memory to register

	and	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224

positive: logical and of s8 memory and memory to register

	and	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321

positive: logical and of u1 memory and memory to register

	and	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17

positive: logical and of u2 memory and memory to register

	and	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764

positive: logical and of u4 memory and memory to register

	and	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457

positive: logical and of u8 memory and memory to register

	and	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665

positive: logical and of s1 immediate and immediate to memory

	and	s1 [@value], s1 54, s1 -13
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical and of s2 immediate and immediate to memory

	and	s2 [@value], s2 7224, s2 6479
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical and of s4 immediate and immediate to memory

	and	s4 [@value], s4 231014977, s4 98722224
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical and of s8 immediate and immediate to memory

	and	s8 [@value], s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical and of u1 immediate and immediate to memory

	and	u1 [@value], u1 176, u1 17
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical and of u2 immediate and immediate to memory

	and	u2 [@value], u2 41774, u2 8764
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical and of u4 immediate and immediate to memory

	and	u4 [@value], u4 2965411179, u4 1132125457
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical and of u8 immediate and immediate to memory

	and	u8 [@value], u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical and of s1 register and immediate to memory

	mov	s1 $0, s1 54
	and	s1 [@value], s1 $0, s1 -13
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical and of s2 register and immediate to memory

	mov	s2 $0, s2 7224
	and	s2 [@value], s2 $0, s2 6479
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical and of s4 register and immediate to memory

	mov	s4 $0, s4 231014977
	and	s4 [@value], s4 $0, s4 98722224
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical and of s8 register and immediate to memory

	mov	s8 $0, s8 1238769817629834628
	and	s8 [@value], s8 $0, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical and of u1 register and immediate to memory

	mov	u1 $0, u1 176
	and	u1 [@value], u1 $0, u1 17
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical and of u2 register and immediate to memory

	mov	u2 $0, u2 41774
	and	u2 [@value], u2 $0, u2 8764
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical and of u4 register and immediate to memory

	mov	u4 $0, u4 2965411179
	and	u4 [@value], u4 $0, u4 1132125457
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical and of u8 register and immediate to memory

	mov	u8 $0, u8 1238769817629834628
	and	u8 [@value], u8 $0, u8 898794512221454665
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical and of s1 memory and immediate to memory

	and	s1 [@value], s1 [@constant], s1 -13
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: logical and of s2 memory and immediate to memory

	and	s2 [@value], s2 [@constant], s2 6479
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224
	.data value
	.alignment	2
	res	2

positive: logical and of s4 memory and immediate to memory

	and	s4 [@value], s4 [@constant], s4 98722224
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: logical and of s8 memory and immediate to memory

	and	s8 [@value], s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical and of u1 memory and immediate to memory

	and	u1 [@value], u1 [@constant], u1 17
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: logical and of u2 memory and immediate to memory

	and	u2 [@value], u2 [@constant], u2 8764
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: logical and of u4 memory and immediate to memory

	and	u4 [@value], u4 [@constant], u4 1132125457
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: logical and of u8 memory and immediate to memory

	and	u8 [@value], u8 [@constant], u8 898794512221454665
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical and of s1 immediate and register to memory

	mov	s1 $0, s1 -13
	and	s1 [@value], s1 54, s1 $0
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical and of s2 immediate and register to memory

	mov	s2 $0, s2 6479
	and	s2 [@value], s2 7224, s2 $0
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical and of s4 immediate and register to memory

	mov	s4 $0, s4 98722224
	and	s4 [@value], s4 231014977, s4 $0
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical and of s8 immediate and register to memory

	mov	s8 $0, s8 -4546546313132132321
	and	s8 [@value], s8 1238769817629834628, s8 $0
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical and of u1 immediate and register to memory

	mov	u1 $0, u1 17
	and	u1 [@value], u1 176, u1 $0
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical and of u2 immediate and register to memory

	mov	u2 $0, u2 8764
	and	u2 [@value], u2 41774, u2 $0
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical and of u4 immediate and register to memory

	mov	u4 $0, u4 1132125457
	and	u4 [@value], u4 2965411179, u4 $0
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical and of u8 immediate and register to memory

	mov	u8 $0, u8 898794512221454665
	and	u8 [@value], u8 1238769817629834628, u8 $0
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical and of s1 register and register to memory

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -13
	and	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical and of s2 register and register to memory

	mov	s2 $0, s2 7224
	mov	s2 $1, s2 6479
	and	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical and of s4 register and register to memory

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	and	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical and of s8 register and register to memory

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	and	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical and of u1 register and register to memory

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	and	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical and of u2 register and register to memory

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	and	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical and of u4 register and register to memory

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	and	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical and of u8 register and register to memory

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	and	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical and of s1 memory and register to memory

	mov	s1 $0, s1 -13
	and	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: logical and of s2 memory and register to memory

	mov	s2 $0, s2 6479
	and	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224
	.data value
	.alignment	2
	res	2

positive: logical and of s4 memory and register to memory

	mov	s4 $0, s4 98722224
	and	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: logical and of s8 memory and register to memory

	mov	s8 $0, s8 -4546546313132132321
	and	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical and of u1 memory and register to memory

	mov	u1 $0, u1 17
	and	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: logical and of u2 memory and register to memory

	mov	u2 $0, u2 8764
	and	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: logical and of u4 memory and register to memory

	mov	u4 $0, u4 1132125457
	and	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: logical and of u8 memory and register to memory

	mov	u8 $0, u8 898794512221454665
	and	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical and of s1 immediate and memory to memory

	and	s1 [@value], s1 54, s1 [@constant]
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical and of s2 immediate and memory to memory

	and	s2 [@value], s2 7224, s2 [@constant]
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical and of s4 immediate and memory to memory

	and	s4 [@value], s4 231014977, s4 [@constant]
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical and of s8 immediate and memory to memory

	and	s8 [@value], s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical and of u1 immediate and memory to memory

	and	u1 [@value], u1 176, u1 [@constant]
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical and of u2 immediate and memory to memory

	and	u2 [@value], u2 41774, u2 [@constant]
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical and of u4 immediate and memory to memory

	and	u4 [@value], u4 2965411179, u4 [@constant]
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical and of u8 immediate and memory to memory

	and	u8 [@value], u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: logical and of s1 register and memory to memory

	mov	s1 $0, s1 54
	and	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical and of s2 register and memory to memory

	mov	s2 $0, s2 7224
	and	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical and of s4 register and memory to memory

	mov	s4 $0, s4 231014977
	and	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical and of s8 register and memory to memory

	mov	s8 $0, s8 1238769817629834628
	and	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical and of u1 register and memory to memory

	mov	u1 $0, u1 176
	and	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical and of u2 register and memory to memory

	mov	u2 $0, u2 41774
	and	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical and of u4 register and memory to memory

	mov	u4 $0, u4 2965411179
	and	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical and of u8 register and memory to memory

	mov	u8 $0, u8 1238769817629834628
	and	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: logical and of s1 memory and memory to memory

	and	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 50
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical and of s2 memory and memory to memory

	and	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 6152
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 7224
	.const constant2
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical and of s4 memory and memory to memory

	and	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 96468992
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical and of s8 memory and memory to memory

	and	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 9126038890428420
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical and of u1 memory and memory to memory

	and	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical and of u2 memory and memory to memory

	and	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 8748
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical and of u4 memory and memory to memory

	and	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 4232449
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical and of u8 memory and memory to memory

	and	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 13555401211838720
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

# or instruction

positive: logical or of s1 immediate and immediate to register

	or	s1 $0, s1 54, s1 -13
	breq	+1, s1 $0, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s2 immediate and immediate to register

	or	s2 $0, s2 7224, s2 6479
	breq	+1, s2 $0, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s4 immediate and immediate to register

	or	s4 $0, s4 231014977, s4 98722224
	breq	+1, s4 $0, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s8 immediate and immediate to register

	or	s8 $0, s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 $0, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u1 immediate and immediate to register

	or	u1 $0, u1 176, u1 17
	breq	+1, u1 $0, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u2 immediate and immediate to register

	or	u2 $0, u2 41774, u2 8764
	breq	+1, u2 $0, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u4 immediate and immediate to register

	or	u4 $0, u4 2965411179, u4 1132125457
	breq	+1, u4 $0, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u8 immediate and immediate to register

	or	u8 $0, u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 $0, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s1 register and immediate to register

	mov	s1 $0, s1 54
	or	s1 $1, s1 $0, s1 -13
	breq	+1, s1 $1, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s2 register and immediate to register

	mov	s2 $0, s2 7224
	or	s2 $1, s2 $0, s2 6479
	breq	+1, s2 $1, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s4 register and immediate to register

	mov	s4 $0, s4 231014977
	or	s4 $1, s4 $0, s4 98722224
	breq	+1, s4 $1, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s8 register and immediate to register

	mov	s8 $0, s8 1238769817629834628
	or	s8 $1, s8 $0, s8 -4546546313132132321
	breq	+1, s8 $1, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u1 register and immediate to register

	mov	u1 $0, u1 176
	or	u1 $1, u1 $0, u1 17
	breq	+1, u1 $1, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u2 register and immediate to register

	mov	u2 $0, u2 41774
	or	u2 $1, u2 $0, u2 8764
	breq	+1, u2 $1, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u4 register and immediate to register

	mov	u4 $0, u4 2965411179
	or	u4 $1, u4 $0, u4 1132125457
	breq	+1, u4 $1, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u8 register and immediate to register

	mov	u8 $0, u8 1238769817629834628
	or	u8 $1, u8 $0, u8 898794512221454665
	breq	+1, u8 $1, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s1 memory and immediate to register

	or	s1 $0, s1 [@constant], s1 -13
	breq	+1, s1 $0, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: logical or of s2 memory and immediate to register

	or	s2 $0, s2 [@constant], s2 6479
	breq	+1, s2 $0, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224

positive: logical or of s4 memory and immediate to register

	or	s4 $0, s4 [@constant], s4 98722224
	breq	+1, s4 $0, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: logical or of s8 memory and immediate to register

	or	s8 $0, s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 $0, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: logical or of u1 memory and immediate to register

	or	u1 $0, u1 [@constant], u1 17
	breq	+1, u1 $0, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: logical or of u2 memory and immediate to register

	or	u2 $0, u2 [@constant], u2 8764
	breq	+1, u2 $0, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: logical or of u4 memory and immediate to register

	or	u4 $0, u4 [@constant], u4 1132125457
	breq	+1, u4 $0, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: logical or of u8 memory and immediate to register

	or	u8 $0, u8 [@constant], u8 898794512221454665
	breq	+1, u8 $0, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: logical or of s1 immediate and register to register

	mov	s1 $0, s1 -13
	or	s1 $1, s1 54, s1 $0
	breq	+1, s1 $1, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s2 immediate and register to register

	mov	s2 $0, s2 6479
	or	s2 $1, s2 7224, s2 $0
	breq	+1, s2 $1, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s4 immediate and register to register

	mov	s4 $0, s4 98722224
	or	s4 $1, s4 231014977, s4 $0
	breq	+1, s4 $1, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s8 immediate and register to register

	mov	s8 $0, s8 -4546546313132132321
	or	s8 $1, s8 1238769817629834628, s8 $0
	breq	+1, s8 $1, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u1 immediate and register to register

	mov	u1 $0, u1 17
	or	u1 $1, u1 176, u1 $0
	breq	+1, u1 $1, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u2 immediate and register to register

	mov	u2 $0, u2 8764
	or	u2 $1, u2 41774, u2 $0
	breq	+1, u2 $1, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u4 immediate and register to register

	mov	u4 $0, u4 1132125457
	or	u4 $1, u4 2965411179, u4 $0
	breq	+1, u4 $1, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u8 immediate and register to register

	mov	u8 $0, u8 898794512221454665
	or	u8 $1, u8 1238769817629834628, u8 $0
	breq	+1, u8 $1, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s1 register and register to register

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -13
	or	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s2 register and register to register

	mov	s2 $0, s2 7224
	mov	s2 $1, s2 6479
	or	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s4 register and register to register

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	or	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s8 register and register to register

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	or	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u1 register and register to register

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	or	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u2 register and register to register

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	or	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u4 register and register to register

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	or	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of u8 register and register to register

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	or	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical or of s1 memory and register to register

	mov	s1 $0, s1 -13
	or	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: logical or of s2 memory and register to register

	mov	s2 $0, s2 6479
	or	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224

positive: logical or of s4 memory and register to register

	mov	s4 $0, s4 98722224
	or	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: logical or of s8 memory and register to register

	mov	s8 $0, s8 -4546546313132132321
	or	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: logical or of u1 memory and register to register

	mov	u1 $0, u1 17
	or	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: logical or of u2 memory and register to register

	mov	u2 $0, u2 8764
	or	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: logical or of u4 memory and register to register

	mov	u4 $0, u4 1132125457
	or	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: logical or of u8 memory and register to register

	mov	u8 $0, u8 898794512221454665
	or	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: logical or of s1 immediate and memory to register

	or	s1 $0, s1 54, s1 [@constant]
	breq	+1, s1 $0, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13

positive: logical or of s2 immediate and memory to register

	or	s2 $0, s2 7224, s2 [@constant]
	breq	+1, s2 $0, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: logical or of s4 immediate and memory to register

	or	s4 $0, s4 231014977, s4 [@constant]
	breq	+1, s4 $0, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: logical or of s8 immediate and memory to register

	or	s8 $0, s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 $0, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: logical or of u1 immediate and memory to register

	or	u1 $0, u1 176, u1 [@constant]
	breq	+1, u1 $0, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: logical or of u2 immediate and memory to register

	or	u2 $0, u2 41774, u2 [@constant]
	breq	+1, u2 $0, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: logical or of u4 immediate and memory to register

	or	u4 $0, u4 2965411179, u4 [@constant]
	breq	+1, u4 $0, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: logical or of u8 immediate and memory to register

	or	u8 $0, u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 $0, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: logical or of s1 register and memory to register

	mov	s1 $0, s1 54
	or	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13

positive: logical or of s2 register and memory to register

	mov	s2 $0, s2 7224
	or	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: logical or of s4 register and memory to register

	mov	s4 $0, s4 231014977
	or	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: logical or of s8 register and memory to register

	mov	s8 $0, s8 1238769817629834628
	or	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: logical or of u1 register and memory to register

	mov	u1 $0, u1 176
	or	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: logical or of u2 register and memory to register

	mov	u2 $0, u2 41774
	or	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: logical or of u4 register and memory to register

	mov	u4 $0, u4 2965411179
	or	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: logical or of u8 register and memory to register

	mov	u8 $0, u8 1238769817629834628
	or	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: logical or of s1 memory and memory to register

	or	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -13

positive: logical or of s2 memory and memory to register

	or	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 7224
	.const constant2
	.alignment	2
	def	s2 6479

positive: logical or of s4 memory and memory to register

	or	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224

positive: logical or of s8 memory and memory to register

	or	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321

positive: logical or of u1 memory and memory to register

	or	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17

positive: logical or of u2 memory and memory to register

	or	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764

positive: logical or of u4 memory and memory to register

	or	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457

positive: logical or of u8 memory and memory to register

	or	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665

positive: logical or of s1 immediate and immediate to memory

	or	s1 [@value], s1 54, s1 -13
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical or of s2 immediate and immediate to memory

	or	s2 [@value], s2 7224, s2 6479
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical or of s4 immediate and immediate to memory

	or	s4 [@value], s4 231014977, s4 98722224
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical or of s8 immediate and immediate to memory

	or	s8 [@value], s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical or of u1 immediate and immediate to memory

	or	u1 [@value], u1 176, u1 17
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical or of u2 immediate and immediate to memory

	or	u2 [@value], u2 41774, u2 8764
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical or of u4 immediate and immediate to memory

	or	u4 [@value], u4 2965411179, u4 1132125457
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical or of u8 immediate and immediate to memory

	or	u8 [@value], u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical or of s1 register and immediate to memory

	mov	s1 $0, s1 54
	or	s1 [@value], s1 $0, s1 -13
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical or of s2 register and immediate to memory

	mov	s2 $0, s2 7224
	or	s2 [@value], s2 $0, s2 6479
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical or of s4 register and immediate to memory

	mov	s4 $0, s4 231014977
	or	s4 [@value], s4 $0, s4 98722224
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical or of s8 register and immediate to memory

	mov	s8 $0, s8 1238769817629834628
	or	s8 [@value], s8 $0, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical or of u1 register and immediate to memory

	mov	u1 $0, u1 176
	or	u1 [@value], u1 $0, u1 17
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical or of u2 register and immediate to memory

	mov	u2 $0, u2 41774
	or	u2 [@value], u2 $0, u2 8764
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical or of u4 register and immediate to memory

	mov	u4 $0, u4 2965411179
	or	u4 [@value], u4 $0, u4 1132125457
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical or of u8 register and immediate to memory

	mov	u8 $0, u8 1238769817629834628
	or	u8 [@value], u8 $0, u8 898794512221454665
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical or of s1 memory and immediate to memory

	or	s1 [@value], s1 [@constant], s1 -13
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: logical or of s2 memory and immediate to memory

	or	s2 [@value], s2 [@constant], s2 6479
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224
	.data value
	.alignment	2
	res	2

positive: logical or of s4 memory and immediate to memory

	or	s4 [@value], s4 [@constant], s4 98722224
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: logical or of s8 memory and immediate to memory

	or	s8 [@value], s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical or of u1 memory and immediate to memory

	or	u1 [@value], u1 [@constant], u1 17
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: logical or of u2 memory and immediate to memory

	or	u2 [@value], u2 [@constant], u2 8764
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: logical or of u4 memory and immediate to memory

	or	u4 [@value], u4 [@constant], u4 1132125457
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: logical or of u8 memory and immediate to memory

	or	u8 [@value], u8 [@constant], u8 898794512221454665
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical or of s1 immediate and register to memory

	mov	s1 $0, s1 -13
	or	s1 [@value], s1 54, s1 $0
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical or of s2 immediate and register to memory

	mov	s2 $0, s2 6479
	or	s2 [@value], s2 7224, s2 $0
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical or of s4 immediate and register to memory

	mov	s4 $0, s4 98722224
	or	s4 [@value], s4 231014977, s4 $0
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical or of s8 immediate and register to memory

	mov	s8 $0, s8 -4546546313132132321
	or	s8 [@value], s8 1238769817629834628, s8 $0
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical or of u1 immediate and register to memory

	mov	u1 $0, u1 17
	or	u1 [@value], u1 176, u1 $0
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical or of u2 immediate and register to memory

	mov	u2 $0, u2 8764
	or	u2 [@value], u2 41774, u2 $0
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical or of u4 immediate and register to memory

	mov	u4 $0, u4 1132125457
	or	u4 [@value], u4 2965411179, u4 $0
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical or of u8 immediate and register to memory

	mov	u8 $0, u8 898794512221454665
	or	u8 [@value], u8 1238769817629834628, u8 $0
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical or of s1 register and register to memory

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -13
	or	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical or of s2 register and register to memory

	mov	s2 $0, s2 7224
	mov	s2 $1, s2 6479
	or	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical or of s4 register and register to memory

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	or	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical or of s8 register and register to memory

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	or	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical or of u1 register and register to memory

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	or	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical or of u2 register and register to memory

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	or	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical or of u4 register and register to memory

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	or	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical or of u8 register and register to memory

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	or	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical or of s1 memory and register to memory

	mov	s1 $0, s1 -13
	or	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: logical or of s2 memory and register to memory

	mov	s2 $0, s2 6479
	or	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224
	.data value
	.alignment	2
	res	2

positive: logical or of s4 memory and register to memory

	mov	s4 $0, s4 98722224
	or	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: logical or of s8 memory and register to memory

	mov	s8 $0, s8 -4546546313132132321
	or	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical or of u1 memory and register to memory

	mov	u1 $0, u1 17
	or	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: logical or of u2 memory and register to memory

	mov	u2 $0, u2 8764
	or	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: logical or of u4 memory and register to memory

	mov	u4 $0, u4 1132125457
	or	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: logical or of u8 memory and register to memory

	mov	u8 $0, u8 898794512221454665
	or	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical or of s1 immediate and memory to memory

	or	s1 [@value], s1 54, s1 [@constant]
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical or of s2 immediate and memory to memory

	or	s2 [@value], s2 7224, s2 [@constant]
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical or of s4 immediate and memory to memory

	or	s4 [@value], s4 231014977, s4 [@constant]
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical or of s8 immediate and memory to memory

	or	s8 [@value], s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical or of u1 immediate and memory to memory

	or	u1 [@value], u1 176, u1 [@constant]
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical or of u2 immediate and memory to memory

	or	u2 [@value], u2 41774, u2 [@constant]
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical or of u4 immediate and memory to memory

	or	u4 [@value], u4 2965411179, u4 [@constant]
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical or of u8 immediate and memory to memory

	or	u8 [@value], u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: logical or of s1 register and memory to memory

	mov	s1 $0, s1 54
	or	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical or of s2 register and memory to memory

	mov	s2 $0, s2 7224
	or	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical or of s4 register and memory to memory

	mov	s4 $0, s4 231014977
	or	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical or of s8 register and memory to memory

	mov	s8 $0, s8 1238769817629834628
	or	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical or of u1 register and memory to memory

	mov	u1 $0, u1 176
	or	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical or of u2 register and memory to memory

	mov	u2 $0, u2 41774
	or	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical or of u4 register and memory to memory

	mov	u4 $0, u4 2965411179
	or	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical or of u8 register and memory to memory

	mov	u8 $0, u8 1238769817629834628
	or	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: logical or of s1 memory and memory to memory

	or	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 -9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical or of s2 memory and memory to memory

	or	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 7551
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 7224
	.const constant2
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical or of s4 memory and memory to memory

	or	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 233268209
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical or of s8 memory and memory to memory

	or	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 -3316902534392726113
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical or of u1 memory and memory to memory

	or	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical or of u2 memory and memory to memory

	or	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 41790
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical or of u4 memory and memory to memory

	or	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 4093304187
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical or of u8 memory and memory to memory

	or	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 2124008928639450573
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

# xor instruction

positive: logical exclusive or of s1 immediate and immediate to register

	xor	s1 $0, s1 54, s1 -13
	breq	+1, s1 $0, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s2 immediate and immediate to register

	xor	s2 $0, s2 7224, s2 6479
	breq	+1, s2 $0, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s4 immediate and immediate to register

	xor	s4 $0, s4 231014977, s4 98722224
	breq	+1, s4 $0, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s8 immediate and immediate to register

	xor	s8 $0, s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 $0, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u1 immediate and immediate to register

	xor	u1 $0, u1 176, u1 17
	breq	+1, u1 $0, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u2 immediate and immediate to register

	xor	u2 $0, u2 41774, u2 8764
	breq	+1, u2 $0, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u4 immediate and immediate to register

	xor	u4 $0, u4 2965411179, u4 1132125457
	breq	+1, u4 $0, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u8 immediate and immediate to register

	xor	u8 $0, u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 $0, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s1 register and immediate to register

	mov	s1 $0, s1 54
	xor	s1 $1, s1 $0, s1 -13
	breq	+1, s1 $1, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s2 register and immediate to register

	mov	s2 $0, s2 7224
	xor	s2 $1, s2 $0, s2 6479
	breq	+1, s2 $1, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s4 register and immediate to register

	mov	s4 $0, s4 231014977
	xor	s4 $1, s4 $0, s4 98722224
	breq	+1, s4 $1, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s8 register and immediate to register

	mov	s8 $0, s8 1238769817629834628
	xor	s8 $1, s8 $0, s8 -4546546313132132321
	breq	+1, s8 $1, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u1 register and immediate to register

	mov	u1 $0, u1 176
	xor	u1 $1, u1 $0, u1 17
	breq	+1, u1 $1, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u2 register and immediate to register

	mov	u2 $0, u2 41774
	xor	u2 $1, u2 $0, u2 8764
	breq	+1, u2 $1, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u4 register and immediate to register

	mov	u4 $0, u4 2965411179
	xor	u4 $1, u4 $0, u4 1132125457
	breq	+1, u4 $1, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u8 register and immediate to register

	mov	u8 $0, u8 1238769817629834628
	xor	u8 $1, u8 $0, u8 898794512221454665
	breq	+1, u8 $1, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s1 memory and immediate to register

	xor	s1 $0, s1 [@constant], s1 -13
	breq	+1, s1 $0, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: logical exclusive or of s2 memory and immediate to register

	xor	s2 $0, s2 [@constant], s2 6479
	breq	+1, s2 $0, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224

positive: logical exclusive or of s4 memory and immediate to register

	xor	s4 $0, s4 [@constant], s4 98722224
	breq	+1, s4 $0, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: logical exclusive or of s8 memory and immediate to register

	xor	s8 $0, s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 $0, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: logical exclusive or of u1 memory and immediate to register

	xor	u1 $0, u1 [@constant], u1 17
	breq	+1, u1 $0, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: logical exclusive or of u2 memory and immediate to register

	xor	u2 $0, u2 [@constant], u2 8764
	breq	+1, u2 $0, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: logical exclusive or of u4 memory and immediate to register

	xor	u4 $0, u4 [@constant], u4 1132125457
	breq	+1, u4 $0, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: logical exclusive or of u8 memory and immediate to register

	xor	u8 $0, u8 [@constant], u8 898794512221454665
	breq	+1, u8 $0, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: logical exclusive or of s1 immediate and register to register

	mov	s1 $0, s1 -13
	xor	s1 $1, s1 54, s1 $0
	breq	+1, s1 $1, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s2 immediate and register to register

	mov	s2 $0, s2 6479
	xor	s2 $1, s2 7224, s2 $0
	breq	+1, s2 $1, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s4 immediate and register to register

	mov	s4 $0, s4 98722224
	xor	s4 $1, s4 231014977, s4 $0
	breq	+1, s4 $1, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s8 immediate and register to register

	mov	s8 $0, s8 -4546546313132132321
	xor	s8 $1, s8 1238769817629834628, s8 $0
	breq	+1, s8 $1, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u1 immediate and register to register

	mov	u1 $0, u1 17
	xor	u1 $1, u1 176, u1 $0
	breq	+1, u1 $1, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u2 immediate and register to register

	mov	u2 $0, u2 8764
	xor	u2 $1, u2 41774, u2 $0
	breq	+1, u2 $1, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u4 immediate and register to register

	mov	u4 $0, u4 1132125457
	xor	u4 $1, u4 2965411179, u4 $0
	breq	+1, u4 $1, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u8 immediate and register to register

	mov	u8 $0, u8 898794512221454665
	xor	u8 $1, u8 1238769817629834628, u8 $0
	breq	+1, u8 $1, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s1 register and register to register

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -13
	xor	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s2 register and register to register

	mov	s2 $0, s2 7224
	mov	s2 $1, s2 6479
	xor	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s4 register and register to register

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	xor	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s8 register and register to register

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	xor	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u1 register and register to register

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	xor	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u2 register and register to register

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	xor	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u4 register and register to register

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	xor	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of u8 register and register to register

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	xor	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: logical exclusive or of s1 memory and register to register

	mov	s1 $0, s1 -13
	xor	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54

positive: logical exclusive or of s2 memory and register to register

	mov	s2 $0, s2 6479
	xor	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224

positive: logical exclusive or of s4 memory and register to register

	mov	s4 $0, s4 98722224
	xor	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977

positive: logical exclusive or of s8 memory and register to register

	mov	s8 $0, s8 -4546546313132132321
	xor	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628

positive: logical exclusive or of u1 memory and register to register

	mov	u1 $0, u1 17
	xor	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176

positive: logical exclusive or of u2 memory and register to register

	mov	u2 $0, u2 8764
	xor	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774

positive: logical exclusive or of u4 memory and register to register

	mov	u4 $0, u4 1132125457
	xor	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179

positive: logical exclusive or of u8 memory and register to register

	mov	u8 $0, u8 898794512221454665
	xor	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628

positive: logical exclusive or of s1 immediate and memory to register

	xor	s1 $0, s1 54, s1 [@constant]
	breq	+1, s1 $0, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13

positive: logical exclusive or of s2 immediate and memory to register

	xor	s2 $0, s2 7224, s2 [@constant]
	breq	+1, s2 $0, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: logical exclusive or of s4 immediate and memory to register

	xor	s4 $0, s4 231014977, s4 [@constant]
	breq	+1, s4 $0, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: logical exclusive or of s8 immediate and memory to register

	xor	s8 $0, s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 $0, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: logical exclusive or of u1 immediate and memory to register

	xor	u1 $0, u1 176, u1 [@constant]
	breq	+1, u1 $0, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: logical exclusive or of u2 immediate and memory to register

	xor	u2 $0, u2 41774, u2 [@constant]
	breq	+1, u2 $0, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: logical exclusive or of u4 immediate and memory to register

	xor	u4 $0, u4 2965411179, u4 [@constant]
	breq	+1, u4 $0, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: logical exclusive or of u8 immediate and memory to register

	xor	u8 $0, u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 $0, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: logical exclusive or of s1 register and memory to register

	mov	s1 $0, s1 54
	xor	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13

positive: logical exclusive or of s2 register and memory to register

	mov	s2 $0, s2 7224
	xor	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479

positive: logical exclusive or of s4 register and memory to register

	mov	s4 $0, s4 231014977
	xor	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224

positive: logical exclusive or of s8 register and memory to register

	mov	s8 $0, s8 1238769817629834628
	xor	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321

positive: logical exclusive or of u1 register and memory to register

	mov	u1 $0, u1 176
	xor	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17

positive: logical exclusive or of u2 register and memory to register

	mov	u2 $0, u2 41774
	xor	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764

positive: logical exclusive or of u4 register and memory to register

	mov	u4 $0, u4 2965411179
	xor	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457

positive: logical exclusive or of u8 register and memory to register

	mov	u8 $0, u8 1238769817629834628
	xor	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665

positive: logical exclusive or of s1 memory and memory to register

	xor	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -13

positive: logical exclusive or of s2 memory and memory to register

	xor	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 7224
	.const constant2
	.alignment	2
	def	s2 6479

positive: logical exclusive or of s4 memory and memory to register

	xor	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224

positive: logical exclusive or of s8 memory and memory to register

	xor	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321

positive: logical exclusive or of u1 memory and memory to register

	xor	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17

positive: logical exclusive or of u2 memory and memory to register

	xor	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764

positive: logical exclusive or of u4 memory and memory to register

	xor	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457

positive: logical exclusive or of u8 memory and memory to register

	xor	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665

positive: logical exclusive or of s1 immediate and immediate to memory

	xor	s1 [@value], s1 54, s1 -13
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 immediate and immediate to memory

	xor	s2 [@value], s2 7224, s2 6479
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 immediate and immediate to memory

	xor	s4 [@value], s4 231014977, s4 98722224
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 immediate and immediate to memory

	xor	s8 [@value], s8 1238769817629834628, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 immediate and immediate to memory

	xor	u1 [@value], u1 176, u1 17
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 immediate and immediate to memory

	xor	u2 [@value], u2 41774, u2 8764
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 immediate and immediate to memory

	xor	u4 [@value], u4 2965411179, u4 1132125457
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 immediate and immediate to memory

	xor	u8 [@value], u8 1238769817629834628, u8 898794512221454665
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of s1 register and immediate to memory

	mov	s1 $0, s1 54
	xor	s1 [@value], s1 $0, s1 -13
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 register and immediate to memory

	mov	s2 $0, s2 7224
	xor	s2 [@value], s2 $0, s2 6479
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 register and immediate to memory

	mov	s4 $0, s4 231014977
	xor	s4 [@value], s4 $0, s4 98722224
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 register and immediate to memory

	mov	s8 $0, s8 1238769817629834628
	xor	s8 [@value], s8 $0, s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 register and immediate to memory

	mov	u1 $0, u1 176
	xor	u1 [@value], u1 $0, u1 17
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 register and immediate to memory

	mov	u2 $0, u2 41774
	xor	u2 [@value], u2 $0, u2 8764
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 register and immediate to memory

	mov	u4 $0, u4 2965411179
	xor	u4 [@value], u4 $0, u4 1132125457
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 register and immediate to memory

	mov	u8 $0, u8 1238769817629834628
	xor	u8 [@value], u8 $0, u8 898794512221454665
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of s1 memory and immediate to memory

	xor	s1 [@value], s1 [@constant], s1 -13
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 memory and immediate to memory

	xor	s2 [@value], s2 [@constant], s2 6479
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 memory and immediate to memory

	xor	s4 [@value], s4 [@constant], s4 98722224
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 memory and immediate to memory

	xor	s8 [@value], s8 [@constant], s8 -4546546313132132321
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 memory and immediate to memory

	xor	u1 [@value], u1 [@constant], u1 17
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 memory and immediate to memory

	xor	u2 [@value], u2 [@constant], u2 8764
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 memory and immediate to memory

	xor	u4 [@value], u4 [@constant], u4 1132125457
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 memory and immediate to memory

	xor	u8 [@value], u8 [@constant], u8 898794512221454665
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of s1 immediate and register to memory

	mov	s1 $0, s1 -13
	xor	s1 [@value], s1 54, s1 $0
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 immediate and register to memory

	mov	s2 $0, s2 6479
	xor	s2 [@value], s2 7224, s2 $0
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 immediate and register to memory

	mov	s4 $0, s4 98722224
	xor	s4 [@value], s4 231014977, s4 $0
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 immediate and register to memory

	mov	s8 $0, s8 -4546546313132132321
	xor	s8 [@value], s8 1238769817629834628, s8 $0
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 immediate and register to memory

	mov	u1 $0, u1 17
	xor	u1 [@value], u1 176, u1 $0
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 immediate and register to memory

	mov	u2 $0, u2 8764
	xor	u2 [@value], u2 41774, u2 $0
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 immediate and register to memory

	mov	u4 $0, u4 1132125457
	xor	u4 [@value], u4 2965411179, u4 $0
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 immediate and register to memory

	mov	u8 $0, u8 898794512221454665
	xor	u8 [@value], u8 1238769817629834628, u8 $0
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of s1 register and register to memory

	mov	s1 $0, s1 54
	mov	s1 $1, s1 -13
	xor	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 register and register to memory

	mov	s2 $0, s2 7224
	mov	s2 $1, s2 6479
	xor	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 register and register to memory

	mov	s4 $0, s4 231014977
	mov	s4 $1, s4 98722224
	xor	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 register and register to memory

	mov	s8 $0, s8 1238769817629834628
	mov	s8 $1, s8 -4546546313132132321
	xor	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 register and register to memory

	mov	u1 $0, u1 176
	mov	u1 $1, u1 17
	xor	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 register and register to memory

	mov	u2 $0, u2 41774
	mov	u2 $1, u2 8764
	xor	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 register and register to memory

	mov	u4 $0, u4 2965411179
	mov	u4 $1, u4 1132125457
	xor	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 register and register to memory

	mov	u8 $0, u8 1238769817629834628
	mov	u8 $1, u8 898794512221454665
	xor	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of s1 memory and register to memory

	mov	s1 $0, s1 -13
	xor	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 54
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 memory and register to memory

	mov	s2 $0, s2 6479
	xor	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 7224
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 memory and register to memory

	mov	s4 $0, s4 98722224
	xor	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 231014977
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 memory and register to memory

	mov	s8 $0, s8 -4546546313132132321
	xor	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 memory and register to memory

	mov	u1 $0, u1 17
	xor	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 176
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 memory and register to memory

	mov	u2 $0, u2 8764
	xor	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 41774
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 memory and register to memory

	mov	u4 $0, u4 1132125457
	xor	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 2965411179
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 memory and register to memory

	mov	u8 $0, u8 898794512221454665
	xor	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 1238769817629834628
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of s1 immediate and memory to memory

	xor	s1 [@value], s1 54, s1 [@constant]
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 immediate and memory to memory

	xor	s2 [@value], s2 7224, s2 [@constant]
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 immediate and memory to memory

	xor	s4 [@value], s4 231014977, s4 [@constant]
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 immediate and memory to memory

	xor	s8 [@value], s8 1238769817629834628, s8 [@constant]
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 immediate and memory to memory

	xor	u1 [@value], u1 176, u1 [@constant]
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 immediate and memory to memory

	xor	u2 [@value], u2 41774, u2 [@constant]
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 immediate and memory to memory

	xor	u4 [@value], u4 2965411179, u4 [@constant]
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 immediate and memory to memory

	xor	u8 [@value], u8 1238769817629834628, u8 [@constant]
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of s1 register and memory to memory

	mov	s1 $0, s1 54
	xor	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 register and memory to memory

	mov	s2 $0, s2 7224
	xor	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 register and memory to memory

	mov	s4 $0, s4 231014977
	xor	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 register and memory to memory

	mov	s8 $0, s8 1238769817629834628
	xor	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 register and memory to memory

	mov	u1 $0, u1 176
	xor	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 register and memory to memory

	mov	u2 $0, u2 41774
	xor	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 register and memory to memory

	mov	u4 $0, u4 2965411179
	xor	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 register and memory to memory

	mov	u8 $0, u8 1238769817629834628
	xor	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of s1 memory and memory to memory

	xor	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 -59
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 54
	.const constant2
	.alignment	1
	def	s1 -13
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of s2 memory and memory to memory

	xor	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 1399
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 7224
	.const constant2
	.alignment	2
	def	s2 6479
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of s4 memory and memory to memory

	xor	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 136799217
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 231014977
	.const constant2
	.alignment	4
	def	s4 98722224
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of s8 memory and memory to memory

	xor	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 -3326028573283154533
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 1238769817629834628
	.const constant2
	.alignment	8
	def	s8 -4546546313132132321
	.data value
	.alignment	8
	res	8

positive: logical exclusive or of u1 memory and memory to memory

	xor	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 161
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 176
	.const constant2
	.alignment	1
	def	u1 17
	.data value
	.alignment	1
	res	1

positive: logical exclusive or of u2 memory and memory to memory

	xor	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 33042
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 41774
	.const constant2
	.alignment	2
	def	u2 8764
	.data value
	.alignment	2
	res	2

positive: logical exclusive or of u4 memory and memory to memory

	xor	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 4089071738
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 2965411179
	.const constant2
	.alignment	4
	def	u4 1132125457
	.data value
	.alignment	4
	res	4

positive: logical exclusive or of u8 memory and memory to memory

	xor	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 2110453527427611853
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 1238769817629834628
	.const constant2
	.alignment	8
	def	u8 898794512221454665
	.data value
	.alignment	8
	res	8

# lsh instruction

positive: left shift of s1 immediate by immediate to register

	lsh	s1 $0, s1 -19, s1 2
	breq	+1, s1 $0, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s2 immediate by immediate to register

	lsh	s2 $0, s2 1425, s2 4
	breq	+1, s2 $0, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s4 immediate by immediate to register

	lsh	s4 $0, s4 -3172447, s4 3
	breq	+1, s4 $0, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s8 immediate by immediate to register

	lsh	s8 $0, s8 12313278534455, s8 11
	breq	+1, s8 $0, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u1 immediate by immediate to register

	lsh	u1 $0, u1 29, u1 3
	breq	+1, u1 $0, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u2 immediate by immediate to register

	lsh	u2 $0, u2 1274, u2 8
	breq	+1, u2 $0, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u4 immediate by immediate to register

	lsh	u4 $0, u4 3214789, u4 5
	breq	+1, u4 $0, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u8 immediate by immediate to register

	lsh	u8 $0, u8 4654612112224, u8 12
	breq	+1, u8 $0, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s1 register by immediate to register

	mov	s1 $0, s1 -19
	lsh	s1 $1, s1 $0, s1 2
	breq	+1, s1 $1, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s2 register by immediate to register

	mov	s2 $0, s2 1425
	lsh	s2 $1, s2 $0, s2 4
	breq	+1, s2 $1, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s4 register by immediate to register

	mov	s4 $0, s4 -3172447
	lsh	s4 $1, s4 $0, s4 3
	breq	+1, s4 $1, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s8 register by immediate to register

	mov	s8 $0, s8 12313278534455
	lsh	s8 $1, s8 $0, s8 11
	breq	+1, s8 $1, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u1 register by immediate to register

	mov	u1 $0, u1 29
	lsh	u1 $1, u1 $0, u1 3
	breq	+1, u1 $1, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u2 register by immediate to register

	mov	u2 $0, u2 1274
	lsh	u2 $1, u2 $0, u2 8
	breq	+1, u2 $1, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u4 register by immediate to register

	mov	u4 $0, u4 3214789
	lsh	u4 $1, u4 $0, u4 5
	breq	+1, u4 $1, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u8 register by immediate to register

	mov	u8 $0, u8 4654612112224
	lsh	u8 $1, u8 $0, u8 12
	breq	+1, u8 $1, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s1 memory by immediate to register

	lsh	s1 $0, s1 [@constant], s1 2
	breq	+1, s1 $0, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -19

positive: left shift of s2 memory by immediate to register

	lsh	s2 $0, s2 [@constant], s2 4
	breq	+1, s2 $0, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1425

positive: left shift of s4 memory by immediate to register

	lsh	s4 $0, s4 [@constant], s4 3
	breq	+1, s4 $0, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -3172447

positive: left shift of s8 memory by immediate to register

	lsh	s8 $0, s8 [@constant], s8 11
	breq	+1, s8 $0, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 12313278534455

positive: left shift of u1 memory by immediate to register

	lsh	u1 $0, u1 [@constant], u1 3
	breq	+1, u1 $0, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 29

positive: left shift of u2 memory by immediate to register

	lsh	u2 $0, u2 [@constant], u2 8
	breq	+1, u2 $0, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 1274

positive: left shift of u4 memory by immediate to register

	lsh	u4 $0, u4 [@constant], u4 5
	breq	+1, u4 $0, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 3214789

positive: left shift of u8 memory by immediate to register

	lsh	u8 $0, u8 [@constant], u8 12
	breq	+1, u8 $0, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 4654612112224

positive: left shift of s1 immediate by register to register

	mov	s1 $0, s1 2
	lsh	s1 $1, s1 -19, s1 $0
	breq	+1, s1 $1, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s2 immediate by register to register

	mov	s2 $0, s2 4
	lsh	s2 $1, s2 1425, s2 $0
	breq	+1, s2 $1, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s4 immediate by register to register

	mov	s4 $0, s4 3
	lsh	s4 $1, s4 -3172447, s4 $0
	breq	+1, s4 $1, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s8 immediate by register to register

	mov	s8 $0, s8 11
	lsh	s8 $1, s8 12313278534455, s8 $0
	breq	+1, s8 $1, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u1 immediate by register to register

	mov	u1 $0, u1 3
	lsh	u1 $1, u1 29, u1 $0
	breq	+1, u1 $1, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u2 immediate by register to register

	mov	u2 $0, u2 8
	lsh	u2 $1, u2 1274, u2 $0
	breq	+1, u2 $1, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u4 immediate by register to register

	mov	u4 $0, u4 5
	lsh	u4 $1, u4 3214789, u4 $0
	breq	+1, u4 $1, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u8 immediate by register to register

	mov	u8 $0, u8 12
	lsh	u8 $1, u8 4654612112224, u8 $0
	breq	+1, u8 $1, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s1 register by register to register

	mov	s1 $0, s1 -19
	mov	s1 $1, s1 2
	lsh	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s2 register by register to register

	mov	s2 $0, s2 1425
	mov	s2 $1, s2 4
	lsh	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s4 register by register to register

	mov	s4 $0, s4 -3172447
	mov	s4 $1, s4 3
	lsh	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s8 register by register to register

	mov	s8 $0, s8 12313278534455
	mov	s8 $1, s8 11
	lsh	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u1 register by register to register

	mov	u1 $0, u1 29
	mov	u1 $1, u1 3
	lsh	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u2 register by register to register

	mov	u2 $0, u2 1274
	mov	u2 $1, u2 8
	lsh	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u4 register by register to register

	mov	u4 $0, u4 3214789
	mov	u4 $1, u4 5
	lsh	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of u8 register by register to register

	mov	u8 $0, u8 4654612112224
	mov	u8 $1, u8 12
	lsh	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: left shift of s1 memory by register to register

	mov	s1 $0, s1 2
	lsh	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -19

positive: left shift of s2 memory by register to register

	mov	s2 $0, s2 4
	lsh	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1425

positive: left shift of s4 memory by register to register

	mov	s4 $0, s4 3
	lsh	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -3172447

positive: left shift of s8 memory by register to register

	mov	s8 $0, s8 11
	lsh	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 12313278534455

positive: left shift of u1 memory by register to register

	mov	u1 $0, u1 3
	lsh	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 29

positive: left shift of u2 memory by register to register

	mov	u2 $0, u2 8
	lsh	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 1274

positive: left shift of u4 memory by register to register

	mov	u4 $0, u4 5
	lsh	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 3214789

positive: left shift of u8 memory by register to register

	mov	u8 $0, u8 12
	lsh	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 4654612112224

positive: left shift of s1 immediate by memory to register

	lsh	s1 $0, s1 -19, s1 [@constant]
	breq	+1, s1 $0, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 2

positive: left shift of s2 immediate by memory to register

	lsh	s2 $0, s2 1425, s2 [@constant]
	breq	+1, s2 $0, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 4

positive: left shift of s4 immediate by memory to register

	lsh	s4 $0, s4 -3172447, s4 [@constant]
	breq	+1, s4 $0, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 3

positive: left shift of s8 immediate by memory to register

	lsh	s8 $0, s8 12313278534455, s8 [@constant]
	breq	+1, s8 $0, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 11

positive: left shift of u1 immediate by memory to register

	lsh	u1 $0, u1 29, u1 [@constant]
	breq	+1, u1 $0, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 3

positive: left shift of u2 immediate by memory to register

	lsh	u2 $0, u2 1274, u2 [@constant]
	breq	+1, u2 $0, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8

positive: left shift of u4 immediate by memory to register

	lsh	u4 $0, u4 3214789, u4 [@constant]
	breq	+1, u4 $0, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 5

positive: left shift of u8 immediate by memory to register

	lsh	u8 $0, u8 4654612112224, u8 [@constant]
	breq	+1, u8 $0, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 12

positive: left shift of s1 register by memory to register

	mov	s1 $0, s1 -19
	lsh	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 2

positive: left shift of s2 register by memory to register

	mov	s2 $0, s2 1425
	lsh	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 4

positive: left shift of s4 register by memory to register

	mov	s4 $0, s4 -3172447
	lsh	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 3

positive: left shift of s8 register by memory to register

	mov	s8 $0, s8 12313278534455
	lsh	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 11

positive: left shift of u1 register by memory to register

	mov	u1 $0, u1 29
	lsh	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 3

positive: left shift of u2 register by memory to register

	mov	u2 $0, u2 1274
	lsh	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8

positive: left shift of u4 register by memory to register

	mov	u4 $0, u4 3214789
	lsh	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 5

positive: left shift of u8 register by memory to register

	mov	u8 $0, u8 4654612112224
	lsh	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 12

positive: left shift of s1 memory by memory to register

	lsh	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 -19
	.const constant2
	.alignment	1
	def	s1 2

positive: left shift of s2 memory by memory to register

	lsh	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 1425
	.const constant2
	.alignment	2
	def	s2 4

positive: left shift of s4 memory by memory to register

	lsh	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -3172447
	.const constant2
	.alignment	4
	def	s4 3

positive: left shift of s8 memory by memory to register

	lsh	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 12313278534455
	.const constant2
	.alignment	8
	def	s8 11

positive: left shift of u1 memory by memory to register

	lsh	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 29
	.const constant2
	.alignment	1
	def	u1 3

positive: left shift of u2 memory by memory to register

	lsh	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 1274
	.const constant2
	.alignment	2
	def	u2 8

positive: left shift of u4 memory by memory to register

	lsh	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 3214789
	.const constant2
	.alignment	4
	def	u4 5

positive: left shift of u8 memory by memory to register

	lsh	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 4654612112224
	.const constant2
	.alignment	8
	def	u8 12

positive: left shift of s1 immediate by immediate to memory

	lsh	s1 [@value], s1 -19, s1 2
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: left shift of s2 immediate by immediate to memory

	lsh	s2 [@value], s2 1425, s2 4
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: left shift of s4 immediate by immediate to memory

	lsh	s4 [@value], s4 -3172447, s4 3
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: left shift of s8 immediate by immediate to memory

	lsh	s8 [@value], s8 12313278534455, s8 11
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: left shift of u1 immediate by immediate to memory

	lsh	u1 [@value], u1 29, u1 3
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: left shift of u2 immediate by immediate to memory

	lsh	u2 [@value], u2 1274, u2 8
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: left shift of u4 immediate by immediate to memory

	lsh	u4 [@value], u4 3214789, u4 5
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: left shift of u8 immediate by immediate to memory

	lsh	u8 [@value], u8 4654612112224, u8 12
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: left shift of s1 register by immediate to memory

	mov	s1 $0, s1 -19
	lsh	s1 [@value], s1 $0, s1 2
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: left shift of s2 register by immediate to memory

	mov	s2 $0, s2 1425
	lsh	s2 [@value], s2 $0, s2 4
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: left shift of s4 register by immediate to memory

	mov	s4 $0, s4 -3172447
	lsh	s4 [@value], s4 $0, s4 3
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: left shift of s8 register by immediate to memory

	mov	s8 $0, s8 12313278534455
	lsh	s8 [@value], s8 $0, s8 11
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: left shift of u1 register by immediate to memory

	mov	u1 $0, u1 29
	lsh	u1 [@value], u1 $0, u1 3
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: left shift of u2 register by immediate to memory

	mov	u2 $0, u2 1274
	lsh	u2 [@value], u2 $0, u2 8
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: left shift of u4 register by immediate to memory

	mov	u4 $0, u4 3214789
	lsh	u4 [@value], u4 $0, u4 5
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: left shift of u8 register by immediate to memory

	mov	u8 $0, u8 4654612112224
	lsh	u8 [@value], u8 $0, u8 12
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: left shift of s1 memory by immediate to memory

	lsh	s1 [@value], s1 [@constant], s1 2
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -19
	.data value
	.alignment	1
	res	1

positive: left shift of s2 memory by immediate to memory

	lsh	s2 [@value], s2 [@constant], s2 4
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1425
	.data value
	.alignment	2
	res	2

positive: left shift of s4 memory by immediate to memory

	lsh	s4 [@value], s4 [@constant], s4 3
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -3172447
	.data value
	.alignment	4
	res	4

positive: left shift of s8 memory by immediate to memory

	lsh	s8 [@value], s8 [@constant], s8 11
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 12313278534455
	.data value
	.alignment	8
	res	8

positive: left shift of u1 memory by immediate to memory

	lsh	u1 [@value], u1 [@constant], u1 3
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 29
	.data value
	.alignment	1
	res	1

positive: left shift of u2 memory by immediate to memory

	lsh	u2 [@value], u2 [@constant], u2 8
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 1274
	.data value
	.alignment	2
	res	2

positive: left shift of u4 memory by immediate to memory

	lsh	u4 [@value], u4 [@constant], u4 5
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 3214789
	.data value
	.alignment	4
	res	4

positive: left shift of u8 memory by immediate to memory

	lsh	u8 [@value], u8 [@constant], u8 12
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 4654612112224
	.data value
	.alignment	8
	res	8

positive: left shift of s1 immediate by register to memory

	mov	s1 $0, s1 2
	lsh	s1 [@value], s1 -19, s1 $0
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: left shift of s2 immediate by register to memory

	mov	s2 $0, s2 4
	lsh	s2 [@value], s2 1425, s2 $0
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: left shift of s4 immediate by register to memory

	mov	s4 $0, s4 3
	lsh	s4 [@value], s4 -3172447, s4 $0
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: left shift of s8 immediate by register to memory

	mov	s8 $0, s8 11
	lsh	s8 [@value], s8 12313278534455, s8 $0
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: left shift of u1 immediate by register to memory

	mov	u1 $0, u1 3
	lsh	u1 [@value], u1 29, u1 $0
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: left shift of u2 immediate by register to memory

	mov	u2 $0, u2 8
	lsh	u2 [@value], u2 1274, u2 $0
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: left shift of u4 immediate by register to memory

	mov	u4 $0, u4 5
	lsh	u4 [@value], u4 3214789, u4 $0
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: left shift of u8 immediate by register to memory

	mov	u8 $0, u8 12
	lsh	u8 [@value], u8 4654612112224, u8 $0
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: left shift of s1 register by register to memory

	mov	s1 $0, s1 -19
	mov	s1 $1, s1 2
	lsh	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: left shift of s2 register by register to memory

	mov	s2 $0, s2 1425
	mov	s2 $1, s2 4
	lsh	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: left shift of s4 register by register to memory

	mov	s4 $0, s4 -3172447
	mov	s4 $1, s4 3
	lsh	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: left shift of s8 register by register to memory

	mov	s8 $0, s8 12313278534455
	mov	s8 $1, s8 11
	lsh	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: left shift of u1 register by register to memory

	mov	u1 $0, u1 29
	mov	u1 $1, u1 3
	lsh	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: left shift of u2 register by register to memory

	mov	u2 $0, u2 1274
	mov	u2 $1, u2 8
	lsh	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0

	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: left shift of u4 register by register to memory

	mov	u4 $0, u4 3214789
	mov	u4 $1, u4 5
	lsh	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: left shift of u8 register by register to memory

	mov	u8 $0, u8 4654612112224
	mov	u8 $1, u8 12
	lsh	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: left shift of s1 memory by register to memory

	mov	s1 $0, s1 2
	lsh	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -19
	.data value
	.alignment	1
	res	1

positive: left shift of s2 memory by register to memory

	mov	s2 $0, s2 4
	lsh	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1425
	.data value
	.alignment	2
	res	2

positive: left shift of s4 memory by register to memory

	mov	s4 $0, s4 3
	lsh	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -3172447
	.data value
	.alignment	4
	res	4

positive: left shift of s8 memory by register to memory

	mov	s8 $0, s8 11
	lsh	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 12313278534455
	.data value
	.alignment	8
	res	8

positive: left shift of u1 memory by register to memory

	mov	u1 $0, u1 3
	lsh	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 29
	.data value
	.alignment	1
	res	1

positive: left shift of u2 memory by register to memory

	mov	u2 $0, u2 8
	lsh	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 1274
	.data value
	.alignment	2
	res	2

positive: left shift of u4 memory by register to memory

	mov	u4 $0, u4 5
	lsh	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 3214789
	.data value
	.alignment	4
	res	4

positive: left shift of u8 memory by register to memory

	mov	u8 $0, u8 12
	lsh	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 4654612112224
	.data value
	.alignment	8
	res	8

positive: left shift of s1 immediate by memory to memory

	lsh	s1 [@value], s1 -19, s1 [@constant]
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 2
	.data value
	.alignment	1
	res	1

positive: left shift of s2 immediate by memory to memory

	lsh	s2 [@value], s2 1425, s2 [@constant]
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 4
	.data value
	.alignment	2
	res	2

positive: left shift of s4 immediate by memory to memory

	lsh	s4 [@value], s4 -3172447, s4 [@constant]
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 3
	.data value
	.alignment	4
	res	4

positive: left shift of s8 immediate by memory to memory

	lsh	s8 [@value], s8 12313278534455, s8 [@constant]
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 11
	.data value
	.alignment	8
	res	8

positive: left shift of u1 immediate by memory to memory

	lsh	u1 [@value], u1 29, u1 [@constant]
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 3
	.data value
	.alignment	1
	res	1

positive: left shift of u2 immediate by memory to memory

	lsh	u2 [@value], u2 1274, u2 [@constant]
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8
	.data value
	.alignment	2
	res	2

positive: left shift of u4 immediate by memory to memory

	lsh	u4 [@value], u4 3214789, u4 [@constant]
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 5
	.data value
	.alignment	4
	res	4

positive: left shift of u8 immediate by memory to memory

	lsh	u8 [@value], u8 4654612112224, u8 [@constant]
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 12
	.data value
	.alignment	8
	res	8

positive: left shift of s1 register by memory to memory

	mov	s1 $0, s1 -19
	lsh	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 2
	.data value
	.alignment	1
	res	1

positive: left shift of s2 register by memory to memory

	mov	s2 $0, s2 1425
	lsh	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 4
	.data value
	.alignment	2
	res	2

positive: left shift of s4 register by memory to memory

	mov	s4 $0, s4 -3172447
	lsh	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 3
	.data value
	.alignment	4
	res	4

positive: left shift of s8 register by memory to memory

	mov	s8 $0, s8 12313278534455
	lsh	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 11
	.data value
	.alignment	8
	res	8

positive: left shift of u1 register by memory to memory

	mov	u1 $0, u1 29
	lsh	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 3
	.data value
	.alignment	1
	res	1

positive: left shift of u2 register by memory to memory

	mov	u2 $0, u2 1274
	lsh	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8
	.data value
	.alignment	2
	res	2

positive: left shift of u4 register by memory to memory

	mov	u4 $0, u4 3214789
	lsh	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 5
	.data value
	.alignment	4
	res	4

positive: left shift of u8 register by memory to memory

	mov	u8 $0, u8 4654612112224
	lsh	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 12
	.data value
	.alignment	8
	res	8

positive: left shift of s1 memory by memory to memory

	lsh	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 -76
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 -19
	.const constant2
	.alignment	1
	def	s1 2
	.data value
	.alignment	1
	res	1

positive: left shift of s2 memory by memory to memory

	lsh	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 22800
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 1425
	.const constant2
	.alignment	2
	def	s2 4
	.data value
	.alignment	2
	res	2

positive: left shift of s4 memory by memory to memory

	lsh	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 -25379576
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -3172447
	.const constant2
	.alignment	4
	def	s4 3
	.data value
	.alignment	4
	res	4

positive: left shift of s8 memory by memory to memory

	lsh	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 25217594438563840
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 12313278534455
	.const constant2
	.alignment	8
	def	s8 11
	.data value
	.alignment	8
	res	8

positive: left shift of u1 memory by memory to memory

	lsh	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 232
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 29
	.const constant2
	.alignment	1
	def	u1 3
	.data value
	.alignment	1
	res	1

positive: left shift of u2 memory by memory to memory

	lsh	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 64000
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 1274
	.const constant2
	.alignment	2
	def	u2 8
	.data value
	.alignment	2
	res	2

positive: left shift of u4 memory by memory to memory

	lsh	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 102873248
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 3214789
	.const constant2
	.alignment	4
	def	u4 5
	.data value
	.alignment	4
	res	4

positive: left shift of u8 memory by memory to memory

	lsh	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 19065291211669504
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 4654612112224
	.const constant2
	.alignment	8
	def	u8 12
	.data value
	.alignment	8
	res	8

# rsh instruction

positive: right shift of s1 immediate by immediate to register

	rsh	s1 $0, s1 -19, s1 2
	breq	+1, s1 $0, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s2 immediate by immediate to register

	rsh	s2 $0, s2 1425, s2 4
	breq	+1, s2 $0, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s4 immediate by immediate to register

	rsh	s4 $0, s4 -3172447, s4 3
	breq	+1, s4 $0, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s8 immediate by immediate to register

	rsh	s8 $0, s8 12313278534455, s8 11
	breq	+1, s8 $0, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u1 immediate by immediate to register

	rsh	u1 $0, u1 29, u1 3
	breq	+1, u1 $0, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u2 immediate by immediate to register

	rsh	u2 $0, u2 1274, u2 8
	breq	+1, u2 $0, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u4 immediate by immediate to register

	rsh	u4 $0, u4 4064364204, u4 17
	breq	+1, u4 $0, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u8 immediate by immediate to register

	rsh	u8 $0, u8 4654612112224, u8 12
	breq	+1, u8 $0, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s1 register by immediate to register

	mov	s1 $0, s1 -19
	rsh	s1 $1, s1 $0, s1 2
	breq	+1, s1 $1, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s2 register by immediate to register

	mov	s2 $0, s2 1425
	rsh	s2 $1, s2 $0, s2 4
	breq	+1, s2 $1, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s4 register by immediate to register

	mov	s4 $0, s4 -3172447
	rsh	s4 $1, s4 $0, s4 3
	breq	+1, s4 $1, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s8 register by immediate to register

	mov	s8 $0, s8 12313278534455
	rsh	s8 $1, s8 $0, s8 11
	breq	+1, s8 $1, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u1 register by immediate to register

	mov	u1 $0, u1 29
	rsh	u1 $1, u1 $0, u1 3
	breq	+1, u1 $1, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u2 register by immediate to register

	mov	u2 $0, u2 1274
	rsh	u2 $1, u2 $0, u2 8
	breq	+1, u2 $1, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u4 register by immediate to register

	mov	u4 $0, u4 4064364204
	rsh	u4 $1, u4 $0, u4 17
	breq	+1, u4 $1, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u8 register by immediate to register

	mov	u8 $0, u8 4654612112224
	rsh	u8 $1, u8 $0, u8 12
	breq	+1, u8 $1, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s1 memory by immediate to register

	rsh	s1 $0, s1 [@constant], s1 2
	breq	+1, s1 $0, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -19

positive: right shift of s2 memory by immediate to register

	rsh	s2 $0, s2 [@constant], s2 4
	breq	+1, s2 $0, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1425

positive: right shift of s4 memory by immediate to register

	rsh	s4 $0, s4 [@constant], s4 3
	breq	+1, s4 $0, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -3172447

positive: right shift of s8 memory by immediate to register

	rsh	s8 $0, s8 [@constant], s8 11
	breq	+1, s8 $0, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 12313278534455

positive: right shift of u1 memory by immediate to register

	rsh	u1 $0, u1 [@constant], u1 3
	breq	+1, u1 $0, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 29

positive: right shift of u2 memory by immediate to register

	rsh	u2 $0, u2 [@constant], u2 8
	breq	+1, u2 $0, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 1274

positive: right shift of u4 memory by immediate to register

	rsh	u4 $0, u4 [@constant], u4 17
	breq	+1, u4 $0, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4064364204

positive: right shift of u8 memory by immediate to register

	rsh	u8 $0, u8 [@constant], u8 12
	breq	+1, u8 $0, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 4654612112224

positive: right shift of s1 immediate by register to register

	mov	s1 $0, s1 2
	rsh	s1 $1, s1 -19, s1 $0
	breq	+1, s1 $1, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s2 immediate by register to register

	mov	s2 $0, s2 4
	rsh	s2 $1, s2 1425, s2 $0
	breq	+1, s2 $1, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s4 immediate by register to register

	mov	s4 $0, s4 3
	rsh	s4 $1, s4 -3172447, s4 $0
	breq	+1, s4 $1, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s8 immediate by register to register

	mov	s8 $0, s8 11
	rsh	s8 $1, s8 12313278534455, s8 $0
	breq	+1, s8 $1, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u1 immediate by register to register

	mov	u1 $0, u1 3
	rsh	u1 $1, u1 29, u1 $0
	breq	+1, u1 $1, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u2 immediate by register to register

	mov	u2 $0, u2 8
	rsh	u2 $1, u2 1274, u2 $0
	breq	+1, u2 $1, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u4 immediate by register to register

	mov	u4 $0, u4 17
	rsh	u4 $1, u4 4064364204, u4 $0
	breq	+1, u4 $1, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u8 immediate by register to register

	mov	u8 $0, u8 12
	rsh	u8 $1, u8 4654612112224, u8 $0
	breq	+1, u8 $1, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s1 register by register to register

	mov	s1 $0, s1 -19
	mov	s1 $1, s1 2
	rsh	s1 $2, s1 $0, s1 $1
	breq	+1, s1 $2, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s2 register by register to register

	mov	s2 $0, s2 1425
	mov	s2 $1, s2 4
	rsh	s2 $2, s2 $0, s2 $1
	breq	+1, s2 $2, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s4 register by register to register

	mov	s4 $0, s4 -3172447
	mov	s4 $1, s4 3
	rsh	s4 $2, s4 $0, s4 $1
	breq	+1, s4 $2, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s8 register by register to register

	mov	s8 $0, s8 12313278534455
	mov	s8 $1, s8 11
	rsh	s8 $2, s8 $0, s8 $1
	breq	+1, s8 $2, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u1 register by register to register

	mov	u1 $0, u1 29
	mov	u1 $1, u1 3
	rsh	u1 $2, u1 $0, u1 $1
	breq	+1, u1 $2, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u2 register by register to register

	mov	u2 $0, u2 1274
	mov	u2 $1, u2 8
	rsh	u2 $2, u2 $0, u2 $1
	breq	+1, u2 $2, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u4 register by register to register

	mov	u4 $0, u4 4064364204
	mov	u4 $1, u4 17
	rsh	u4 $2, u4 $0, u4 $1
	breq	+1, u4 $2, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of u8 register by register to register

	mov	u8 $0, u8 4654612112224
	mov	u8 $1, u8 12
	rsh	u8 $2, u8 $0, u8 $1
	breq	+1, u8 $2, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: right shift of s1 memory by register to register

	mov	s1 $0, s1 2
	rsh	s1 $1, s1 [@constant], s1 $0
	breq	+1, s1 $1, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -19

positive: right shift of s2 memory by register to register

	mov	s2 $0, s2 4
	rsh	s2 $1, s2 [@constant], s2 $0
	breq	+1, s2 $1, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1425

positive: right shift of s4 memory by register to register

	mov	s4 $0, s4 3
	rsh	s4 $1, s4 [@constant], s4 $0
	breq	+1, s4 $1, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -3172447

positive: right shift of s8 memory by register to register

	mov	s8 $0, s8 11
	rsh	s8 $1, s8 [@constant], s8 $0
	breq	+1, s8 $1, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 12313278534455

positive: right shift of u1 memory by register to register

	mov	u1 $0, u1 3
	rsh	u1 $1, u1 [@constant], u1 $0
	breq	+1, u1 $1, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 29

positive: right shift of u2 memory by register to register

	mov	u2 $0, u2 8
	rsh	u2 $1, u2 [@constant], u2 $0
	breq	+1, u2 $1, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 1274

positive: right shift of u4 memory by register to register

	mov	u4 $0, u4 17
	rsh	u4 $1, u4 [@constant], u4 $0
	breq	+1, u4 $1, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4064364204

positive: right shift of u8 memory by register to register

	mov	u8 $0, u8 12
	rsh	u8 $1, u8 [@constant], u8 $0
	breq	+1, u8 $1, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 4654612112224

positive: right shift of s1 immediate by memory to register

	rsh	s1 $0, s1 -19, s1 [@constant]
	breq	+1, s1 $0, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 2

positive: right shift of s2 immediate by memory to register

	rsh	s2 $0, s2 1425, s2 [@constant]
	breq	+1, s2 $0, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 4

positive: right shift of s4 immediate by memory to register

	rsh	s4 $0, s4 -3172447, s4 [@constant]
	breq	+1, s4 $0, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 3

positive: right shift of s8 immediate by memory to register

	rsh	s8 $0, s8 12313278534455, s8 [@constant]
	breq	+1, s8 $0, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 11

positive: right shift of u1 immediate by memory to register

	rsh	u1 $0, u1 29, u1 [@constant]
	breq	+1, u1 $0, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 3

positive: right shift of u2 immediate by memory to register

	rsh	u2 $0, u2 1274, u2 [@constant]
	breq	+1, u2 $0, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8

positive: right shift of u4 immediate by memory to register

	rsh	u4 $0, u4 4064364204, u4 [@constant]
	breq	+1, u4 $0, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 17

positive: right shift of u8 immediate by memory to register

	rsh	u8 $0, u8 4654612112224, u8 [@constant]
	breq	+1, u8 $0, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 12

positive: right shift of s1 register by memory to register

	mov	s1 $0, s1 -19
	rsh	s1 $1, s1 $0, s1 [@constant]
	breq	+1, s1 $1, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 2

positive: right shift of s2 register by memory to register

	mov	s2 $0, s2 1425
	rsh	s2 $1, s2 $0, s2 [@constant]
	breq	+1, s2 $1, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 4

positive: right shift of s4 register by memory to register

	mov	s4 $0, s4 -3172447
	rsh	s4 $1, s4 $0, s4 [@constant]
	breq	+1, s4 $1, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 3

positive: right shift of s8 register by memory to register

	mov	s8 $0, s8 12313278534455
	rsh	s8 $1, s8 $0, s8 [@constant]
	breq	+1, s8 $1, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 11

positive: right shift of u1 register by memory to register

	mov	u1 $0, u1 29
	rsh	u1 $1, u1 $0, u1 [@constant]
	breq	+1, u1 $1, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 3

positive: right shift of u2 register by memory to register

	mov	u2 $0, u2 1274
	rsh	u2 $1, u2 $0, u2 [@constant]
	breq	+1, u2 $1, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8

positive: right shift of u4 register by memory to register

	mov	u4 $0, u4 4064364204
	rsh	u4 $1, u4 $0, u4 [@constant]
	breq	+1, u4 $1, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 17

positive: right shift of u8 register by memory to register

	mov	u8 $0, u8 4654612112224
	rsh	u8 $1, u8 $0, u8 [@constant]
	breq	+1, u8 $1, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 12

positive: right shift of s1 memory by memory to register

	rsh	s1 $0, s1 [@constant1], s1 [@constant2]
	breq	+1, s1 $0, s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 -19
	.const constant2
	.alignment	1
	def	s1 2

positive: right shift of s2 memory by memory to register

	rsh	s2 $0, s2 [@constant1], s2 [@constant2]
	breq	+1, s2 $0, s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 1425
	.const constant2
	.alignment	2
	def	s2 4

positive: right shift of s4 memory by memory to register

	rsh	s4 $0, s4 [@constant1], s4 [@constant2]
	breq	+1, s4 $0, s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -3172447
	.const constant2
	.alignment	4
	def	s4 3

positive: right shift of s8 memory by memory to register

	rsh	s8 $0, s8 [@constant1], s8 [@constant2]
	breq	+1, s8 $0, s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 12313278534455
	.const constant2
	.alignment	8
	def	s8 11

positive: right shift of u1 memory by memory to register

	rsh	u1 $0, u1 [@constant1], u1 [@constant2]
	breq	+1, u1 $0, u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 29
	.const constant2
	.alignment	1
	def	u1 3

positive: right shift of u2 memory by memory to register

	rsh	u2 $0, u2 [@constant1], u2 [@constant2]
	breq	+1, u2 $0, u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 1274
	.const constant2
	.alignment	2
	def	u2 8

positive: right shift of u4 memory by memory to register

	rsh	u4 $0, u4 [@constant1], u4 [@constant2]
	breq	+1, u4 $0, u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 4064364204
	.const constant2
	.alignment	4
	def	u4 17

positive: right shift of u8 memory by memory to register

	rsh	u8 $0, u8 [@constant1], u8 [@constant2]
	breq	+1, u8 $0, u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 4654612112224
	.const constant2
	.alignment	8
	def	u8 12

positive: right shift of s1 immediate by immediate to memory

	rsh	s1 [@value], s1 -19, s1 2
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: right shift of s2 immediate by immediate to memory

	rsh	s2 [@value], s2 1425, s2 4
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: right shift of s4 immediate by immediate to memory

	rsh	s4 [@value], s4 -3172447, s4 3
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: right shift of s8 immediate by immediate to memory

	rsh	s8 [@value], s8 12313278534455, s8 11
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: right shift of u1 immediate by immediate to memory

	rsh	u1 [@value], u1 29, u1 3
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: right shift of u2 immediate by immediate to memory

	rsh	u2 [@value], u2 1274, u2 8
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: right shift of u4 immediate by immediate to memory

	rsh	u4 [@value], u4 4064364204, u4 17
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: right shift of u8 immediate by immediate to memory

	rsh	u8 [@value], u8 4654612112224, u8 12
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: right shift of s1 register by immediate to memory

	mov	s1 $0, s1 -19
	rsh	s1 [@value], s1 $0, s1 2
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: right shift of s2 register by immediate to memory

	mov	s2 $0, s2 1425
	rsh	s2 [@value], s2 $0, s2 4
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: right shift of s4 register by immediate to memory

	mov	s4 $0, s4 -3172447
	rsh	s4 [@value], s4 $0, s4 3
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: right shift of s8 register by immediate to memory

	mov	s8 $0, s8 12313278534455
	rsh	s8 [@value], s8 $0, s8 11
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: right shift of u1 register by immediate to memory

	mov	u1 $0, u1 29
	rsh	u1 [@value], u1 $0, u1 3
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: right shift of u2 register by immediate to memory

	mov	u2 $0, u2 1274
	rsh	u2 [@value], u2 $0, u2 8
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: right shift of u4 register by immediate to memory

	mov	u4 $0, u4 4064364204
	rsh	u4 [@value], u4 $0, u4 17
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: right shift of u8 register by immediate to memory

	mov	u8 $0, u8 4654612112224
	rsh	u8 [@value], u8 $0, u8 12
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: right shift of s1 memory by immediate to memory

	rsh	s1 [@value], s1 [@constant], s1 2
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -19
	.data value
	.alignment	1
	res	1

positive: right shift of s2 memory by immediate to memory

	rsh	s2 [@value], s2 [@constant], s2 4
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1425
	.data value
	.alignment	2
	res	2

positive: right shift of s4 memory by immediate to memory

	rsh	s4 [@value], s4 [@constant], s4 3
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -3172447
	.data value
	.alignment	4
	res	4

positive: right shift of s8 memory by immediate to memory

	rsh	s8 [@value], s8 [@constant], s8 11
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 12313278534455
	.data value
	.alignment	8
	res	8

positive: right shift of u1 memory by immediate to memory

	rsh	u1 [@value], u1 [@constant], u1 3
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 29
	.data value
	.alignment	1
	res	1

positive: right shift of u2 memory by immediate to memory

	rsh	u2 [@value], u2 [@constant], u2 8
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 1274
	.data value
	.alignment	2
	res	2

positive: right shift of u4 memory by immediate to memory

	rsh	u4 [@value], u4 [@constant], u4 17
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4064364204
	.data value
	.alignment	4
	res	4

positive: right shift of u8 memory by immediate to memory

	rsh	u8 [@value], u8 [@constant], u8 12
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 4654612112224
	.data value
	.alignment	8
	res	8

positive: right shift of s1 immediate by register to memory

	mov	s1 $0, s1 2
	rsh	s1 [@value], s1 -19, s1 $0
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: right shift of s2 immediate by register to memory

	mov	s2 $0, s2 4
	rsh	s2 [@value], s2 1425, s2 $0
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: right shift of s4 immediate by register to memory

	mov	s4 $0, s4 3
	rsh	s4 [@value], s4 -3172447, s4 $0
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: right shift of s8 immediate by register to memory

	mov	s8 $0, s8 11
	rsh	s8 [@value], s8 12313278534455, s8 $0
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: right shift of u1 immediate by register to memory

	mov	u1 $0, u1 3
	rsh	u1 [@value], u1 29, u1 $0
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: right shift of u2 immediate by register to memory

	mov	u2 $0, u2 8
	rsh	u2 [@value], u2 1274, u2 $0
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: right shift of u4 immediate by register to memory

	mov	u4 $0, u4 17
	rsh	u4 [@value], u4 4064364204, u4 $0
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: right shift of u8 immediate by register to memory

	mov	u8 $0, u8 12
	rsh	u8 [@value], u8 4654612112224, u8 $0
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: right shift of s1 register by register to memory

	mov	s1 $0, s1 -19
	mov	s1 $1, s1 2
	rsh	s1 [@value], s1 $0, s1 $1
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: right shift of s2 register by register to memory

	mov	s2 $0, s2 1425
	mov	s2 $1, s2 4
	rsh	s2 [@value], s2 $0, s2 $1
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: right shift of s4 register by register to memory

	mov	s4 $0, s4 -3172447
	mov	s4 $1, s4 3
	rsh	s4 [@value], s4 $0, s4 $1
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: right shift of s8 register by register to memory

	mov	s8 $0, s8 12313278534455
	mov	s8 $1, s8 11
	rsh	s8 [@value], s8 $0, s8 $1
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: right shift of u1 register by register to memory

	mov	u1 $0, u1 29
	mov	u1 $1, u1 3
	rsh	u1 [@value], u1 $0, u1 $1
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: right shift of u2 register by register to memory

	mov	u2 $0, u2 1274
	mov	u2 $1, u2 8
	rsh	u2 [@value], u2 $0, u2 $1
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: right shift of u4 register by register to memory

	mov	u4 $0, u4 4064364204
	mov	u4 $1, u4 17
	rsh	u4 [@value], u4 $0, u4 $1
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: right shift of u8 register by register to memory

	mov	u8 $0, u8 4654612112224
	mov	u8 $1, u8 12
	rsh	u8 [@value], u8 $0, u8 $1
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: right shift of s1 memory by register to memory

	mov	s1 $0, s1 2
	rsh	s1 [@value], s1 [@constant], s1 $0
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -19
	.data value
	.alignment	1
	res	1

positive: right shift of s2 memory by register to memory

	mov	s2 $0, s2 4
	rsh	s2 [@value], s2 [@constant], s2 $0
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 1425
	.data value
	.alignment	2
	res	2

positive: right shift of s4 memory by register to memory

	mov	s4 $0, s4 3
	rsh	s4 [@value], s4 [@constant], s4 $0
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -3172447
	.data value
	.alignment	4
	res	4

positive: right shift of s8 memory by register to memory

	mov	s8 $0, s8 11
	rsh	s8 [@value], s8 [@constant], s8 $0
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 12313278534455
	.data value
	.alignment	8
	res	8

positive: right shift of u1 memory by register to memory

	mov	u1 $0, u1 3
	rsh	u1 [@value], u1 [@constant], u1 $0
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 29
	.data value
	.alignment	1
	res	1

positive: right shift of u2 memory by register to memory

	mov	u2 $0, u2 8
	rsh	u2 [@value], u2 [@constant], u2 $0
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 1274
	.data value
	.alignment	2
	res	2

positive: right shift of u4 memory by register to memory

	mov	u4 $0, u4 17
	rsh	u4 [@value], u4 [@constant], u4 $0
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4064364204
	.data value
	.alignment	4
	res	4

positive: right shift of u8 memory by register to memory

	mov	u8 $0, u8 12
	rsh	u8 [@value], u8 [@constant], u8 $0
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 4654612112224
	.data value
	.alignment	8
	res	8

positive: right shift of s1 immediate by memory to memory

	rsh	s1 [@value], s1 -19, s1 [@constant]
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 2
	.data value
	.alignment	1
	res	1

positive: right shift of s2 immediate by memory to memory

	rsh	s2 [@value], s2 1425, s2 [@constant]
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 4
	.data value
	.alignment	2
	res	2

positive: right shift of s4 immediate by memory to memory

	rsh	s4 [@value], s4 -3172447, s4 [@constant]
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 3
	.data value
	.alignment	4
	res	4

positive: right shift of s8 immediate by memory to memory

	rsh	s8 [@value], s8 12313278534455, s8 [@constant]
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 11
	.data value
	.alignment	8
	res	8

positive: right shift of u1 immediate by memory to memory

	rsh	u1 [@value], u1 29, u1 [@constant]
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 3
	.data value
	.alignment	1
	res	1

positive: right shift of u2 immediate by memory to memory

	rsh	u2 [@value], u2 1274, u2 [@constant]
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8
	.data value
	.alignment	2
	res	2

positive: right shift of u4 immediate by memory to memory

	rsh	u4 [@value], u4 4064364204, u4 [@constant]
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 17
	.data value
	.alignment	4
	res	4

positive: right shift of u8 immediate by memory to memory

	rsh	u8 [@value], u8 4654612112224, u8 [@constant]
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 12
	.data value
	.alignment	8
	res	8

positive: right shift of s1 register by memory to memory

	mov	s1 $0, s1 -19
	rsh	s1 [@value], s1 $0, s1 [@constant]
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 2
	.data value
	.alignment	1
	res	1

positive: right shift of s2 register by memory to memory

	mov	s2 $0, s2 1425
	rsh	s2 [@value], s2 $0, s2 [@constant]
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 4
	.data value
	.alignment	2
	res	2

positive: right shift of s4 register by memory to memory

	mov	s4 $0, s4 -3172447
	rsh	s4 [@value], s4 $0, s4 [@constant]
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 3
	.data value
	.alignment	4
	res	4

positive: right shift of s8 register by memory to memory

	mov	s8 $0, s8 12313278534455
	rsh	s8 [@value], s8 $0, s8 [@constant]
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 11
	.data value
	.alignment	8
	res	8

positive: right shift of u1 register by memory to memory

	mov	u1 $0, u1 29
	rsh	u1 [@value], u1 $0, u1 [@constant]
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 3
	.data value
	.alignment	1
	res	1

positive: right shift of u2 register by memory to memory

	mov	u2 $0, u2 1274
	rsh	u2 [@value], u2 $0, u2 [@constant]
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 8
	.data value
	.alignment	2
	res	2

positive: right shift of u4 register by memory to memory

	mov	u4 $0, u4 4064364204
	rsh	u4 [@value], u4 $0, u4 [@constant]
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 17
	.data value
	.alignment	4
	res	4

positive: right shift of u8 register by memory to memory

	mov	u8 $0, u8 4654612112224
	rsh	u8 [@value], u8 $0, u8 [@constant]
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 12
	.data value
	.alignment	8
	res	8

positive: right shift of s1 memory by memory to memory

	rsh	s1 [@value], s1 [@constant1], s1 [@constant2]
	breq	+1, s1 [@value], s1 -5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 -19
	.const constant2
	.alignment	1
	def	s1 2
	.data value
	.alignment	1
	res	1

positive: right shift of s2 memory by memory to memory

	rsh	s2 [@value], s2 [@constant1], s2 [@constant2]
	breq	+1, s2 [@value], s2 89
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 1425
	.const constant2
	.alignment	2
	def	s2 4
	.data value
	.alignment	2
	res	2

positive: right shift of s4 memory by memory to memory

	rsh	s4 [@value], s4 [@constant1], s4 [@constant2]
	breq	+1, s4 [@value], s4 -396556
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -3172447
	.const constant2
	.alignment	4
	def	s4 3
	.data value
	.alignment	4
	res	4

positive: right shift of s8 memory by memory to memory

	rsh	s8 [@value], s8 [@constant1], s8 [@constant2]
	breq	+1, s8 [@value], s8 6012343034
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 12313278534455
	.const constant2
	.alignment	8
	def	s8 11
	.data value
	.alignment	8
	res	8

positive: right shift of u1 memory by memory to memory

	rsh	u1 [@value], u1 [@constant1], u1 [@constant2]
	breq	+1, u1 [@value], u1 3
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 29
	.const constant2
	.alignment	1
	def	u1 3
	.data value
	.alignment	1
	res	1

positive: right shift of u2 memory by memory to memory

	rsh	u2 [@value], u2 [@constant1], u2 [@constant2]
	breq	+1, u2 [@value], u2 4
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 1274
	.const constant2
	.alignment	2
	def	u2 8
	.data value
	.alignment	2
	res	2

positive: right shift of u4 memory by memory to memory

	rsh	u4 [@value], u4 [@constant1], u4 [@constant2]
	breq	+1, u4 [@value], u4 31008
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 4064364204
	.const constant2
	.alignment	4
	def	u4 17
	.data value
	.alignment	4
	res	4

positive: right shift of u8 memory by memory to memory

	rsh	u8 [@value], u8 [@constant1], u8 [@constant2]
	breq	+1, u8 [@value], u8 1136379910
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 4654612112224
	.const constant2
	.alignment	8
	def	u8 12
	.data value
	.alignment	8
	res	8

# push instruction

positive: push onto stack of s1 immediate

	push	s1 -57
	breq	+1, s1 [$sp + stackdisp], s1 -57
	call	fun @abort, 0
	pop	s1 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of s2 immediate

	push	s2 8766
	breq	+1, s2 [$sp + stackdisp], s2 8766
	call	fun @abort, 0
	pop	s2 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of s4 immediate

	push	s4 -6547779
	breq	+1, s4 [$sp + stackdisp], s4 -6547779
	call	fun @abort, 0
	pop	s4 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of s8 immediate

	push	s8 13218793217799
	breq	+1, s8 [$sp + stackdisp], s8 13218793217799
	call	fun @abort, 0
	pop	s8 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of u1 immediate

	push	u1 254
	breq	+1, u1 [$sp + stackdisp], u1 254
	call	fun @abort, 0
	pop	u1 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of u2 immediate

	push	u2 62477
	breq	+1, u2 [$sp + stackdisp], u2 62477
	call	fun @abort, 0
	pop	u2 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of u4 immediate

	push	u4 4054877799
	breq	+1, u4 [$sp + stackdisp], u4 4054877799
	call	fun @abort, 0
	pop	u4 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of u8 immediate

	push	u8 9879713218793217799
	breq	+1, u8 [$sp + stackdisp], u8 9879713218793217799
	call	fun @abort, 0
	pop	u8 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of f4 immediate

	push	f4 8.5
	breq	+1, f4 [$sp + stackdisp], f4 8.5
	call	fun @abort, 0
	pop	f4 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of f8 immediate

	push	f8 0.25
	breq	+1, f8 [$sp + stackdisp], f8 0.25
	call	fun @abort, 0
	pop	f8 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of ptr immediate

	push	ptr 0x21
	breq	+1, ptr [$sp + stackdisp], ptr 0x21
	call	fun @abort, 0
	pop	ptr $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of fun immediate

	push	fun @main
	breq	+1, fun [$sp + stackdisp], fun @main
	call	fun @abort, 0
	pop	fun $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of s1 register

	mov	s1 $0, s1 -57
	push	s1 $0
	breq	+1, s1 [$sp + stackdisp], s1 -57
	call	fun @abort, 0
	pop	s1 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of s2 register

	mov	s2 $0, s2 8766
	push	s2 $0
	breq	+1, s2 [$sp + stackdisp], s2 8766
	call	fun @abort, 0
	pop	s2 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of s4 register

	mov	s4 $0, s4 -6547779
	push	s4 $0
	breq	+1, s4 [$sp + stackdisp], s4 -6547779
	call	fun @abort, 0
	pop	s4 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of s8 register

	mov	s8 $0, s8 13218793217799
	push	s8 $0
	breq	+1, s8 [$sp + stackdisp], s8 13218793217799
	call	fun @abort, 0
	pop	s8 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of u1 register

	mov	u1 $0, u1 254
	push	u1 $0
	breq	+1, u1 [$sp + stackdisp], u1 254
	call	fun @abort, 0
	pop	u1 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of u2 register

	mov	u2 $0, u2 62477
	push	u2 $0
	breq	+1, u2 [$sp + stackdisp], u2 62477
	call	fun @abort, 0
	pop	u2 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of u4 register

	mov	u4 $0, u4 4054877799
	push	u4 $0
	breq	+1, u4 [$sp + stackdisp], u4 4054877799
	call	fun @abort, 0
	pop	u4 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of u8 register

	mov	u8 $0, u8 9879713218793217799
	push	u8 $0
	breq	+1, u8 [$sp + stackdisp], u8 9879713218793217799
	call	fun @abort, 0
	pop	u8 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of f4 register

	mov	f4 $0, f4 8.5
	push	f4 $0
	breq	+1, f4 [$sp + stackdisp], f4 8.5
	call	fun @abort, 0
	pop	f4 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of f8 register

	mov	f8 $0, f8 0.25
	push	f8 $0
	breq	+1, f8 [$sp + stackdisp], f8 0.25
	call	fun @abort, 0
	pop	f8 $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of ptr register

	push	ptr $fp + 5
	breq	+1, ptr [$sp + stackdisp], ptr $fp + 5
	call	fun @abort, 0
	pop	ptr $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of fun register

	mov	fun $0, fun @main
	push	fun $0
	breq	+1, fun [$sp + stackdisp], fun @main
	call	fun @abort, 0
	pop	fun $0
	push	int 0
	call	fun @_Exit, 0

positive: push onto stack of s1 memory

	push	s1 [@constant]
	breq	+1, s1 [$sp + stackdisp], s1 -57
	call	fun @abort, 0
	pop	s1 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	s1 -57

positive: push onto stack of s2 memory

	push	s2 [@constant]
	breq	+1, s2 [$sp + stackdisp], s2 8766
	call	fun @abort, 0
	pop	s2 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	s2 8766

positive: push onto stack of s4 memory

	push	s4 [@constant]
	breq	+1, s4 [$sp + stackdisp], s4 -6547779
	call	fun @abort, 0
	pop	s4 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	s4 -6547779

positive: push onto stack of s8 memory

	push	s8 [@constant]
	breq	+1, s8 [$sp + stackdisp], s8 13218793217799
	call	fun @abort, 0
	pop	s8 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	s8 13218793217799

positive: push onto stack of u1 memory

	push	u1 [@constant]
	breq	+1, u1 [$sp + stackdisp], u1 254
	call	fun @abort, 0
	pop	u1 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	1
	def	u1 254

positive: push onto stack of u2 memory

	push	u2 [@constant]
	breq	+1, u2 [$sp + stackdisp], u2 62477
	call	fun @abort, 0
	pop	u2 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	2
	def	u2 62477

positive: push onto stack of u4 memory

	push	u4 [@constant]
	breq	+1, u4 [$sp + stackdisp], u4 4054877799
	call	fun @abort, 0
	pop	u4 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	u4 4054877799

positive: push onto stack of u8 memory

	push	u8 [@constant]
	breq	+1, u8 [$sp + stackdisp], u8 9879713218793217799
	call	fun @abort, 0
	pop	u8 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	u8 9879713218793217799

positive: push onto stack of f4 memory

	push	f4 [@constant]
	breq	+1, f4 [$sp + stackdisp], f4 8.5
	call	fun @abort, 0
	pop	f4 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	4
	def	f4 8.5

positive: push onto stack of f8 memory

	push	f8 [@constant]
	breq	+1, f8 [$sp + stackdisp], f8 0.25
	call	fun @abort, 0
	pop	f8 $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	8
	def	f8 0.25

positive: push onto stack of ptr memory

	push	ptr [@constant]
	breq	+1, ptr [$sp + stackdisp], ptr @constant + 9
	call	fun @abort, 0
	pop	ptr $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	ptrsize
	def	ptr @constant + 9

positive: push onto stack of fun memory

	push	fun [@constant]
	breq	+1, fun [$sp + stackdisp], fun @main
	call	fun @abort, 0
	pop	fun $0
	push	int 0
	call	fun @_Exit, 0
	.const constant
	.alignment	funsize
	def	fun @main

# pop instruction

positive: pop from stack of s1 value into register

	mov	s1 $0, s1 -57
	push	s1 $0
	pop	s1 $0
	breq	+1, s1 $0, s1 -57
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of s2 value into register

	mov	s2 $0, s2 8766
	push	s2 $0
	pop	s2 $0
	breq	+1, s2 $0, s2 8766
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of s4 value into register

	mov	s4 $0, s4 -6547779
	push	s4 $0
	pop	s4 $0
	breq	+1, s4 $0, s4 -6547779
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of s8 value into register

	mov	s8 $0, s8 13218793217799
	push	s8 $0
	pop	s8 $0
	breq	+1, s8 $0, s8 13218793217799
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of u1 value into register

	mov	u1 $0, u1 254
	push	u1 $0
	pop	u1 $0
	breq	+1, u1 $0, u1 254
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of u2 value into register

	mov	u2 $0, u2 62477
	push	u2 $0
	pop	u2 $0
	breq	+1, u2 $0, u2 62477
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of u4 value into register

	mov	u4 $0, u4 4054877799
	push	u4 $0
	pop	u4 $0
	breq	+1, u4 $0, u4 4054877799
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of u8 value into register

	mov	u8 $0, u8 9879713218793217799
	push	u8 $0
	pop	u8 $0
	breq	+1, u8 $0, u8 9879713218793217799
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of f4 value into register

	mov	f4 $0, f4 8.5
	push	f4 $0
	pop	f4 $0
	breq	+1, f4 $0, f4 8.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of f8 value into register

	mov	f8 $0, f8 0.25
	push	f8 $0
	pop	f8 $0
	breq	+1, f8 $0, f8 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of ptr value into register

	push	ptr $fp + 5
	pop	ptr $0
	breq	+1, ptr $0, ptr $fp + 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of fun value into register

	mov	fun $0, fun @main
	push	fun $0
	pop	fun $0
	breq	+1, fun $0, fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: pop from stack of s1 value into memory

	push	s1 -57
	pop	s1 [@value]
	breq	+1, s1 [@value], s1 -57
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: pop from stack of s2 value into memory

	push	s2 8766
	pop	s2 [@value]
	breq	+1, s2 [@value], s2 8766
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: pop from stack of s4 value into memory

	push	s4 -6547779
	pop	s4 [@value]
	breq	+1, s4 [@value], s4 -6547779
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: pop from stack of s8 value into memory

	push	s8 13218793217799
	pop	s8 [@value]
	breq	+1, s8 [@value], s8 13218793217799
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: pop from stack of u1 value into memory

	push	u1 254
	pop	u1 [@value]
	breq	+1, u1 [@value], u1 254
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	1
	res	1

positive: pop from stack of u2 value into memory

	push	u2 62477
	pop	u2 [@value]
	breq	+1, u2 [@value], u2 62477
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	2
	res	2

positive: pop from stack of u4 value into memory

	push	u4 4054877799
	pop	u4 [@value]
	breq	+1, u4 [@value], u4 4054877799
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: pop from stack of u8 value into memory

	push	u8 9879713218793217799
	pop	u8 [@value]
	breq	+1, u8 [@value], u8 9879713218793217799
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: pop from stack of f4 value into memory

	push	f4 8.5
	pop	f4 [@value]
	breq	+1, f4 [@value], f4 8.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	4
	res	4

positive: pop from stack of f8 value into memory

	push	f8 0.25
	pop	f8 [@value]
	breq	+1, f8 [@value], f8 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	8
	res	8

positive: pop from stack of ptr value into memory

	push	ptr @value + 9
	pop	ptr [@value]
	breq	+1, ptr [@value], ptr @value + 9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	ptrsize
	res	ptrsize

positive: pop from stack of fun value into memory

	push	fun @main
	pop	fun [@value]
	breq	+1, fun [@value], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.data value
	.alignment	funsize
	res	funsize

# call instruction

positive: function call of immediate

	push	fun @main
	call	fun @function, funalign
	.code function
	breq	+1, fun [$sp + !lnksize * retalign + stackdisp], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: function call of register

	push	fun @main
	mov	fun $0, fun @function
	call	fun $0, funalign
	.code function
	breq	+1, fun [$sp + !lnksize * retalign + stackdisp], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: function call of memory

	push	ptr @address
	call	fun [@address], ptralign
	.code function
	breq	+1, ptr [$sp + !lnksize * retalign + stackdisp], ptr @address
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const address
	.alignment	funsize
	def	fun @function

# ret instruction

positive: return from function with s1 result

	call	fun @function, 0
	breq	+1, s1 $res, s1 -45
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	s1 $res, s1 -45
	ret

positive: return from function with s2 result

	call	fun @function, 0
	breq	+1, s2 $res, s2 27177
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	s2 $res, s2 27177
	ret

positive: return from function with s4 result

	call	fun @function, 0
	breq	+1, s4 $res, s4 -2031472147
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	s4 $res, s4 -2031472147
	ret

positive: return from function with s8 result

	call	fun @function, 0
	breq	+1, s8 $res, s8 6462321898791154
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	s8 $res, s8 6462321898791154
	ret

positive: return from function with u1 result

	call	fun @function, 0
	breq	+1, u1 $res, u1 0xab
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	u1 $res, u1 0xab
	ret

positive: return from function with u2 result

	call	fun @function, 0
	breq	+1, u2 $res, u2 0xab87
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	u2 $res, u2 0xab87
	ret

positive: return from function with u4 result

	call	fun @function, 0
	breq	+1, u4 $res, u4 0x9de712cd
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	u4 $res, u4 0x9de712cd
	ret

positive: return from function with u8 result

	call	fun @function, 0
	breq	+1, u8 $res, u8 0x914e2f21da4b9c6f
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	u8 $res, u8 0x914e2f21da4b9c6f
	ret

positive: return from function with f4 result

	call	fun @function, 0
	breq	+1, f4 $res, f4 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	f4 $res, f4 0.25
	ret

positive: return from function with f8 result

	call	fun @function, 0
	breq	+1, f8 $res, f8 -7.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	f8 $res, f8 -7.5
	ret

positive: return from function with ptr result

	call	fun @function, 0
	breq	+1, ptr $res, ptr 45
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	ptr $res, ptr 45
	ret

positive: return from function with fun result

	call	fun @function, 0
	breq	+1, fun $res, fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.code function
	#if lnksize
		push	fun $lnk
	#endif
	mov	fun $res, fun @main
	ret

# enter instruction

positive: stack frame creation

	mov	ptr $0, ptr $sp
	mov	ptr $1, ptr $fp
	enter	intalign + fltalign
	brne	+2, ptr $fp, ptr $0 - ptralign
	brne	+1, ptr [$fp + stackdisp], ptr $1
	breq	+1, ptr $sp, ptr $fp - (intalign + fltalign)
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	leave

# leave instruction

positive: stack frame deletion

	mov	ptr $0, ptr $sp
	mov	ptr $1, ptr $fp
	enter	intalign + fltalign
	leave
	brne	+1, ptr $0, ptr $sp
	breq	+1, ptr $1, ptr $fp
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

# br instruction

positive: unconditional branch

	br	+1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

# breq instruction

positive: branch if s1 immediate is equal to immediate

	breq	+1, s1 5, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 immediate is equal to immediate

	breq	+1, s2 -5477, s2 -5477
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 immediate is equal to immediate

	breq	+1, s4 65487797, s4 65487797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 immediate is equal to immediate

	breq	+1, s8 -87893218771531849, s8 -87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 immediate is equal to immediate

	breq	+1, u1 200, u1 200
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 immediate is equal to immediate

	breq	+1, u2 62479, u2 62479
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 immediate is equal to immediate

	breq	+1, u4 486351357, u4 486351357
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 immediate is equal to immediate

	breq	+1, u8 87893218771531849, u8 87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 immediate is equal to immediate

	breq	+1, f4 0.25, f4 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 immediate is equal to immediate

	breq	+1, f8 -2.75, f8 -2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr immediate is equal to immediate

	breq	+1, ptr 0x12, ptr 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun immediate is equal to immediate

	breq	+1, fun 0x12, fun 0x12
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 register is equal to immediate

	mov	s1 $0, s1 5
	breq	+1, s1 $0, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 register is equal to immediate

	mov	s2 $0, s2 -5477
	breq	+1, s2 $0, s2 -5477
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 register is equal to immediate

	mov	s4 $0, s4 65487797
	breq	+1, s4 $0, s4 65487797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 register is equal to immediate

	mov	s8 $0, s8 -87893218771531849
	breq	+1, s8 $0, s8 -87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 register is equal to immediate

	mov	u1 $0, u1 200
	breq	+1, u1 $0, u1 200
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 register is equal to immediate

	mov	u2 $0, u2 62479
	breq	+1, u2 $0, u2 62479
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 register is equal to immediate

	mov	u4 $0, u4 486351357
	breq	+1, u4 $0, u4 486351357
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 register is equal to immediate

	mov	u8 $0, u8 87893218771531849
	breq	+1, u8 $0, u8 87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 register is equal to immediate

	mov	f4 $0, f4 0.25
	breq	+1, f4 $0, f4 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 register is equal to immediate

	mov	f8 $0, f8 -2.75
	breq	+1, f8 $0, f8 -2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr register is equal to immediate

	mov	ptr $0, ptr 0x45
	breq	+1, ptr $0, ptr 0x45
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun register is equal to immediate

	mov	fun $0, fun 0x45
	breq	+1, fun $0, fun 0x45
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 memory is equal to immediate

	breq	+1, s1 [@constant1], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5

positive: branch if s2 memory is equal to immediate

	breq	+1, s2 [@constant1], s2 -5477
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477

positive: branch if s4 memory is equal to immediate

	breq	+1, s4 [@constant1], s4 65487797
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 65487797

positive: branch if s8 memory is equal to immediate

	breq	+1, s8 [@constant1], s8 -87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 memory is equal to immediate

	breq	+1, u1 [@constant1], u1 200
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200

positive: branch if u2 memory is equal to immediate

	breq	+1, u2 [@constant1], u2 62479
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 62479

positive: branch if u4 memory is equal to immediate

	breq	+1, u4 [@constant1], u4 486351357
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 486351357

positive: branch if u8 memory is equal to immediate

	breq	+1, u8 [@constant1], u8 87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is equal to immediate

	breq	+1, f4 [@constant1], f4 0.25
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25

positive: branch if f8 memory is equal to immediate

	breq	+1, f8 [@constant1], f8 -2.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75

positive: branch if ptr memory is equal to immediate

	breq	+1, ptr [@constant1], ptr @constant1 + 7
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7

positive: branch if fun memory is equal to immediate

	breq	+1, fun [@constant1], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun @main

positive: branch if s1 immediate is equal to register

	mov	s1 $1, s1 5
	breq	+1, s1 5, s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 immediate is equal to register

	mov	s2 $1, s2 -5477
	breq	+1, s2 -5477, s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 immediate is equal to register

	mov	s4 $1, s4 65487797
	breq	+1, s4 65487797, s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 immediate is equal to register

	mov	s8 $1, s8 -87893218771531849
	breq	+1, s8 -87893218771531849, s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 immediate is equal to register

	mov	u1 $1, u1 200
	breq	+1, u1 200, u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 immediate is equal to register

	mov	u2 $1, u2 62479
	breq	+1, u2 62479, u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 immediate is equal to register

	mov	u4 $1, u4 486351357
	breq	+1, u4 486351357, u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 immediate is equal to register

	mov	u8 $1, u8 87893218771531849
	breq	+1, u8 87893218771531849, u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 immediate is equal to register

	mov	f4 $1, f4 0.25
	breq	+1, f4 0.25, f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 immediate is equal to register

	mov	f8 $1, f8 -2.75
	breq	+1, f8 -2.75, f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr immediate is equal to register

	mov	ptr $1, ptr 0x47
	breq	+1, ptr 0x47, ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun immediate is equal to register

	mov	fun $1, fun @main
	breq	+1, fun @main, fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 register is equal to register

	mov	s1 $0, s1 5
	mov	s1 $1, s1 5
	breq	+1, s1 $0, s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 register is equal to register

	mov	s2 $0, s2 -5477
	mov	s2 $1, s2 -5477
	breq	+1, s2 $0, s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 register is equal to register

	mov	s4 $0, s4 65487797
	mov	s4 $1, s4 65487797
	breq	+1, s4 $0, s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 register is equal to register

	mov	s8 $0, s8 -87893218771531849
	mov	s8 $1, s8 -87893218771531849
	breq	+1, s8 $0, s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 register is equal to register

	mov	u1 $0, u1 200
	mov	u1 $1, u1 200
	breq	+1, u1 $0, u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 register is equal to register

	mov	u2 $0, u2 62479
	mov	u2 $1, u2 62479
	breq	+1, u2 $0, u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 register is equal to register

	mov	u4 $0, u4 486351357
	mov	u4 $1, u4 486351357
	breq	+1, u4 $0, u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 register is equal to register

	mov	u8 $0, u8 87893218771531849
	mov	u8 $1, u8 87893218771531849
	breq	+1, u8 $0, u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 register is equal to register

	mov	f4 $0, f4 0.25
	mov	f4 $1, f4 0.25
	breq	+1, f4 $0, f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 register is equal to register

	mov	f8 $0, f8 -2.75
	mov	f8 $1, f8 -2.75
	breq	+1, f8 $0, f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr register is equal to register

	mov	ptr $0, ptr 0x87
	mov	ptr $1, ptr 0x87
	breq	+1, ptr $0, ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun register is equal to register

	mov	fun $0, fun 0x87
	mov	fun $1, fun 0x87
	breq	+1, fun $0, fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 memory is equal to register

	mov	s1 $1, s1 5
	breq	+1, s1 [@constant1], s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5

positive: branch if s2 memory is equal to register

	mov	s2 $1, s2 -5477
	breq	+1, s2 [@constant1], s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477

positive: branch if s4 memory is equal to register

	mov	s4 $1, s4 65487797
	breq	+1, s4 [@constant1], s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 65487797

positive: branch if s8 memory is equal to register

	mov	s8 $1, s8 -87893218771531849
	breq	+1, s8 [@constant1], s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 memory is equal to register

	mov	u1 $1, u1 200
	breq	+1, u1 [@constant1], u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200

positive: branch if u2 memory is equal to register

	mov	u2 $1, u2 62479
	breq	+1, u2 [@constant1], u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 62479

positive: branch if u4 memory is equal to register

	mov	u4 $1, u4 486351357
	breq	+1, u4 [@constant1], u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 486351357

positive: branch if u8 memory is equal to register

	mov	u8 $1, u8 87893218771531849
	breq	+1, u8 [@constant1], u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is equal to register

	mov	f4 $1, f4 0.25
	breq	+1, f4 [@constant1], f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25

positive: branch if f8 memory is equal to register

	mov	f8 $1, f8 -2.75
	breq	+1, f8 [@constant1], f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75

positive: branch if ptr memory is equal to register

	mov	ptr $1, ptr @constant1 + 7
	breq	+1, ptr [@constant1], ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7

positive: branch if fun memory is equal to register

	mov	fun $1, fun @main
	breq	+1, fun [@constant1], fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun @main

positive: branch if s1 immediate is equal to memory

	breq	+1, s1 5, s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	s1 5

positive: branch if s2 immediate is equal to memory

	breq	+1, s2 -5477, s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	s2 -5477

positive: branch if s4 immediate is equal to memory

	breq	+1, s4 65487797, s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	s4 65487797

positive: branch if s8 immediate is equal to memory

	breq	+1, s8 -87893218771531849, s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 immediate is equal to memory

	breq	+1, u1 200, u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	u1 200

positive: branch if u2 immediate is equal to memory

	breq	+1, u2 62479, u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	u2 62479

positive: branch if u4 immediate is equal to memory

	breq	+1, u4 486351357, u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	u4 486351357

positive: branch if u8 immediate is equal to memory

	breq	+1, u8 87893218771531849, u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 immediate is equal to memory

	breq	+1, f4 0.25, f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	f4 0.25

positive: branch if f8 immediate is equal to memory

	breq	+1, f8 -2.75, f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	f8 -2.75

positive: branch if ptr immediate is equal to memory

	breq	+1, ptr @constant2 + 7, ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 7

positive: branch if fun immediate is equal to memory

	breq	+1, fun @main, fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	funsize
	def	fun @main

positive: branch if s1 register is equal to memory

	mov	s1 $0, s1 5
	breq	+1, s1 $0, s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	s1 5

positive: branch if s2 register is equal to memory

	mov	s2 $0, s2 -5477
	breq	+1, s2 $0, s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	s2 -5477

positive: branch if s4 register is equal to memory

	mov	s4 $0, s4 65487797
	breq	+1, s4 $0, s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	s4 65487797

positive: branch if s8 register is equal to memory

	mov	s8 $0, s8 -87893218771531849
	breq	+1, s8 $0, s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 register is equal to memory

	mov	u1 $0, u1 200
	breq	+1, u1 $0, u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	u1 200

positive: branch if u2 register is equal to memory

	mov	u2 $0, u2 62479
	breq	+1, u2 $0, u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	u2 62479

positive: branch if u4 register is equal to memory

	mov	u4 $0, u4 486351357
	breq	+1, u4 $0, u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	u4 486351357

positive: branch if u8 register is equal to memory

	mov	u8 $0, u8 87893218771531849
	breq	+1, u8 $0, u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 register is equal to memory

	mov	f4 $0, f4 0.25
	breq	+1, f4 $0, f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	f4 0.25

positive: branch if f8 register is equal to memory

	mov	f8 $0, f8 -2.75
	breq	+1, f8 $0, f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	f8 -2.75

positive: branch if ptr register is equal to memory

	mov	ptr $0, ptr @constant2 + 7
	breq	+1, ptr $0, ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 7

positive: branch if fun register is equal to memory

	mov	fun $0, fun @main
	breq	+1, fun $0, fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	funsize
	def	fun @main

positive: branch if s1 memory is equal to memory

	breq	+1, s1 [@constant1], s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5
	.const constant2
	.alignment	1
	def	s1 5

positive: branch if s2 memory is equal to memory

	breq	+1, s2 [@constant1], s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477
	.const constant2
	.alignment	2
	def	s2 -5477

positive: branch if s4 memory is equal to memory

	breq	+1, s4 [@constant1], s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 65487797
	.const constant2
	.alignment	4
	def	s4 65487797

positive: branch if s8 memory is equal to memory

	breq	+1, s8 [@constant1], s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849
	.const constant2
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 memory is equal to memory

	breq	+1, u1 [@constant1], u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200
	.const constant2
	.alignment	1
	def	u1 200

positive: branch if u2 memory is equal to memory

	breq	+1, u2 [@constant1], u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 62479
	.const constant2
	.alignment	2
	def	u2 62479

positive: branch if u4 memory is equal to memory

	breq	+1, u4 [@constant1], u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 486351357
	.const constant2
	.alignment	4
	def	u4 486351357

positive: branch if u8 memory is equal to memory

	breq	+1, u8 [@constant1], u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849
	.const constant2
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is equal to memory

	breq	+1, f4 [@constant1], f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25
	.const constant2
	.alignment	4
	def	f4 0.25

positive: branch if f8 memory is equal to memory

	breq	+1, f8 [@constant1], f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75
	.const constant2
	.alignment	8
	def	f8 -2.75

positive: branch if ptr memory is equal to memory

	breq	+1, ptr [@constant1], ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7
	.const constant2
	.alignment	ptrsize
	def	ptr @constant1 + 7

positive: branch if fun memory is equal to memory

	breq	+1, fun [@constant1], fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun @main
	.const constant2
	.alignment	funsize
	def	fun @main

# brne instruction

positive: branch if s1 immediate is not equal to immediate

	brne	+1, s1 5, s1 -29
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 immediate is not equal to immediate

	brne	+1, s2 -5477, s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 immediate is not equal to immediate

	brne	+1, s4 65487797, s4 -32179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 immediate is not equal to immediate

	brne	+1, s8 -87893218771531849, s8 65423135487897654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 immediate is not equal to immediate

	brne	+1, u1 200, u1 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 immediate is not equal to immediate

	brne	+1, u2 62479, u2 121
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 immediate is not equal to immediate

	brne	+1, u4 486351357, u4 68777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 immediate is not equal to immediate

	brne	+1, u8 87893218771531849, u8 3215446587879844654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 immediate is not equal to immediate

	brne	+1, f4 0.25, f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 immediate is not equal to immediate

	brne	+1, f8 -2.75, f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr immediate is not equal to immediate

	brne	+1, ptr 0x47, ptr 0x16
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun immediate is not equal to immediate

	brne	+1, fun @main, fun 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 register is not equal to immediate

	mov	s1 $0, s1 5
	brne	+1, s1 $0, s1 -29
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 register is not equal to immediate

	mov	s2 $0, s2 -5477
	brne	+1, s2 $0, s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 register is not equal to immediate

	mov	s4 $0, s4 65487797
	brne	+1, s4 $0, s4 -32179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 register is not equal to immediate

	mov	s8 $0, s8 -87893218771531849
	brne	+1, s8 $0, s8 65423135487897654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 register is not equal to immediate

	mov	u1 $0, u1 200
	brne	+1, u1 $0, u1 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 register is not equal to immediate

	mov	u2 $0, u2 62479
	brne	+1, u2 $0, u2 121
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 register is not equal to immediate

	mov	u4 $0, u4 486351357
	brne	+1, u4 $0, u4 68777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 register is not equal to immediate

	mov	u8 $0, u8 87893218771531849
	brne	+1, u8 $0, u8 3215446587879844654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 register is not equal to immediate

	mov	f4 $0, f4 0.25
	brne	+1, f4 $0, f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 register is not equal to immediate

	mov	f8 $0, f8 -2.75
	brne	+1, f8 $0, f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr register is not equal to immediate

	mov	ptr $0, ptr 0x74
	brne	+1, ptr $0, ptr 0x24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun register is not equal to immediate

	mov	fun $0, fun @main
	brne	+1, fun $0, fun 0x24
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 memory is not equal to immediate

	brne	+1, s1 [@constant1], s1 -29
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5

positive: branch if s2 memory is not equal to immediate

	brne	+1, s2 [@constant1], s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477

positive: branch if s4 memory is not equal to immediate

	brne	+1, s4 [@constant1], s4 -32179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 65487797

positive: branch if s8 memory is not equal to immediate

	brne	+1, s8 [@constant1], s8 65423135487897654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 memory is not equal to immediate

	brne	+1, u1 [@constant1], u1 0
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200

positive: branch if u2 memory is not equal to immediate

	brne	+1, u2 [@constant1], u2 121
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 62479

positive: branch if u4 memory is not equal to immediate

	brne	+1, u4 [@constant1], u4 68777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 486351357

positive: branch if u8 memory is not equal to immediate

	brne	+1, u8 [@constant1], u8 3215446587879844654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is not equal to immediate

	brne	+1, f4 [@constant1], f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25

positive: branch if f8 memory is not equal to immediate

	brne	+1, f8 [@constant1], f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75

positive: branch if ptr memory is not equal to immediate

	brne	+1, ptr [@constant1], ptr @constant1 + 1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7

positive: branch if fun memory is not equal to immediate

	brne	+1, fun [@constant1], fun @main
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun 1

positive: branch if s1 immediate is not equal to register

	mov	s1 $1, s1 -29
	brne	+1, s1 5, s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 immediate is not equal to register

	mov	s2 $1, s2 21467
	brne	+1, s2 -5477, s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 immediate is not equal to register

	mov	s4 $1, s4 -32179745
	brne	+1, s4 65487797, s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 immediate is not equal to register

	mov	s8 $1, s8 65423135487897654
	brne	+1, s8 -87893218771531849, s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 immediate is not equal to register

	mov	u1 $1, u1 0
	brne	+1, u1 200, u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 immediate is not equal to register

	mov	u2 $1, u2 121
	brne	+1, u2 62479, u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 immediate is not equal to register

	mov	u4 $1, u4 68777874
	brne	+1, u4 486351357, u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 immediate is not equal to register

	mov	u8 $1, u8 3215446587879844654
	brne	+1, u8 87893218771531849, u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 immediate is not equal to register

	mov	f4 $1, f4 4.5
	brne	+1, f4 0.25, f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 immediate is not equal to register

	mov	f8 $1, f8 3.75
	brne	+1, f8 -2.75, f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr immediate is not equal to register

	mov	ptr $1, ptr 0x47
	brne	+1, ptr 0x94, ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun immediate is not equal to register

	mov	fun $1, fun @main
	brne	+1, fun 0x94, fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 register is not equal to register

	mov	s1 $0, s1 5
	mov	s1 $1, s1 -29
	brne	+1, s1 $0, s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 register is not equal to register

	mov	s2 $0, s2 -5477
	mov	s2 $1, s2 21467
	brne	+1, s2 $0, s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 register is not equal to register

	mov	s4 $0, s4 65487797
	mov	s4 $1, s4 -32179745
	brne	+1, s4 $0, s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 register is not equal to register

	mov	s8 $0, s8 -87893218771531849
	mov	s8 $1, s8 65423135487897654
	brne	+1, s8 $0, s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 register is not equal to register

	mov	u1 $0, u1 200
	mov	u1 $1, u1 0
	brne	+1, u1 $0, u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 register is not equal to register

	mov	u2 $0, u2 62479
	mov	u2 $1, u2 121
	brne	+1, u2 $0, u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 register is not equal to register

	mov	u4 $0, u4 486351357
	mov	u4 $1, u4 68777874
	brne	+1, u4 $0, u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 register is not equal to register

	mov	u8 $0, u8 87893218771531849
	mov	u8 $1, u8 3215446587879844654
	brne	+1, u8 $0, u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 register is not equal to register

	mov	f4 $0, f4 0.25
	mov	f4 $1, f4 4.5
	brne	+1, f4 $0, f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 register is not equal to register

	mov	f8 $0, f8 -2.75
	mov	f8 $1, f8 3.75
	brne	+1, f8 $0, f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr register is not equal to register

	mov	ptr $0, ptr 0x12
	mov	ptr $1, ptr 0x75
	brne	+1, ptr $0, ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun register is not equal to register

	mov	fun $0, fun @main
	mov	fun $1, fun 0x78
	brne	+1, fun $0, fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 memory is not equal to register

	mov	s1 $1, s1 -29
	brne	+1, s1 [@constant1], s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5

positive: branch if s2 memory is not equal to register

	mov	s2 $1, s2 21467
	brne	+1, s2 [@constant1], s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477

positive: branch if s4 memory is not equal to register

	mov	s4 $1, s4 -32179745
	brne	+1, s4 [@constant1], s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 65487797

positive: branch if s8 memory is not equal to register

	mov	s8 $1, s8 65423135487897654
	brne	+1, s8 [@constant1], s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 memory is not equal to register

	mov	u1 $1, u1 0
	brne	+1, u1 [@constant1], u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200

positive: branch if u2 memory is not equal to register

	mov	u2 $1, u2 121
	brne	+1, u2 [@constant1], u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 62479

positive: branch if u4 memory is not equal to register

	mov	u4 $1, u4 68777874
	brne	+1, u4 [@constant1], u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 486351357

positive: branch if u8 memory is not equal to register

	mov	u8 $1, u8 3215446587879844654
	brne	+1, u8 [@constant1], u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is not equal to register

	mov	f4 $1, f4 4.5
	brne	+1, f4 [@constant1], f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25

positive: branch if f8 memory is not equal to register

	mov	f8 $1, f8 3.75
	brne	+1, f8 [@constant1], f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75

positive: branch if ptr memory is not equal to register

	mov	ptr $1, ptr @constant1
	brne	+1, ptr [@constant1], ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7

positive: branch if fun memory is not equal to register

	mov	fun $1, fun @main
	brne	+1, fun [@constant1], fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun 0x74

positive: branch if s1 immediate is not equal to memory

	brne	+1, s1 5, s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	s1 -29

positive: branch if s2 immediate is not equal to memory

	brne	+1, s2 -5477, s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 immediate is not equal to memory

	brne	+1, s4 65487797, s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	s4 -32179745

positive: branch if s8 immediate is not equal to memory

	brne	+1, s8 -87893218771531849, s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	s8 65423135487897654

positive: branch if u1 immediate is not equal to memory

	brne	+1, u1 200, u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	u1 0

positive: branch if u2 immediate is not equal to memory

	brne	+1, u2 62479, u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	u2 121

positive: branch if u4 immediate is not equal to memory

	brne	+1, u4 486351357, u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	u4 68777874

positive: branch if u8 immediate is not equal to memory

	brne	+1, u8 87893218771531849, u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	u8 3215446587879844654

positive: branch if f4 immediate is not equal to memory

	brne	+1, f4 0.25, f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 immediate is not equal to memory

	brne	+1, f8 -2.75, f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr immediate is not equal to memory

	brne	+1, ptr @constant2 + 7, ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 2

positive: branch if fun immediate is not equal to memory

	brne	+1, fun @main, fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	funsize
	def	fun 0x74

positive: branch if s1 register is not equal to memory

	mov	s1 $0, s1 5
	brne	+1, s1 $0, s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	s1 -29

positive: branch if s2 register is not equal to memory

	mov	s2 $0, s2 -5477
	brne	+1, s2 $0, s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 register is not equal to memory

	mov	s4 $0, s4 65487797
	brne	+1, s4 $0, s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	s4 -32179745

positive: branch if s8 register is not equal to memory

	mov	s8 $0, s8 -87893218771531849
	brne	+1, s8 $0, s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	s8 65423135487897654

positive: branch if u1 register is not equal to memory

	mov	u1 $0, u1 200
	brne	+1, u1 $0, u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	u1 0

positive: branch if u2 register is not equal to memory

	mov	u2 $0, u2 62479
	brne	+1, u2 $0, u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	u2 121

positive: branch if u4 register is not equal to memory

	mov	u4 $0, u4 486351357
	brne	+1, u4 $0, u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	u4 68777874

positive: branch if u8 register is not equal to memory

	mov	u8 $0, u8 87893218771531849
	brne	+1, u8 $0, u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	u8 3215446587879844654

positive: branch if f4 register is not equal to memory

	mov	f4 $0, f4 0.25
	brne	+1, f4 $0, f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 register is not equal to memory

	mov	f8 $0, f8 -2.75
	brne	+1, f8 $0, f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr register is not equal to memory

	mov	ptr $0, ptr @constant2 + 7
	brne	+1, ptr $0, ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 2

positive: branch if fun register is not equal to memory

	mov	fun $0, fun @main
	brne	+1, fun $0, fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	funsize
	def	fun 0x24

positive: branch if s1 memory is not equal to memory

	brne	+1, s1 [@constant1], s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5
	.const constant2
	.alignment	1
	def	s1 -29

positive: branch if s2 memory is not equal to memory

	brne	+1, s2 [@constant1], s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 memory is not equal to memory

	brne	+1, s4 [@constant1], s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 65487797
	.const constant2
	.alignment	4
	def	s4 -32179745

positive: branch if s8 memory is not equal to memory

	brne	+1, s8 [@constant1], s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849
	.const constant2
	.alignment	8
	def	s8 65423135487897654

positive: branch if u1 memory is not equal to memory

	brne	+1, u1 [@constant1], u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200
	.const constant2
	.alignment	1
	def	u1 0

positive: branch if u2 memory is not equal to memory

	brne	+1, u2 [@constant1], u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 62479
	.const constant2
	.alignment	2
	def	u2 121

positive: branch if u4 memory is not equal to memory

	brne	+1, u4 [@constant1], u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 486351357
	.const constant2
	.alignment	4
	def	u4 68777874

positive: branch if u8 memory is not equal to memory

	brne	+1, u8 [@constant1], u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849
	.const constant2
	.alignment	8
	def	u8 3215446587879844654

positive: branch if f4 memory is not equal to memory

	brne	+1, f4 [@constant1], f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 memory is not equal to memory

	brne	+1, f8 [@constant1], f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr memory is not equal to memory

	brne	+1, ptr [@constant1], ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7
	.const constant2
	.alignment	ptrsize
	def	ptr @constant1 + 2

positive: branch if fun memory is not equal to memory

	brne	+1, fun [@constant1], fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun @main
	.const constant2
	.alignment	funsize
	def	fun 0x57

# brlt instruction

positive: branch if s1 immediate is less than immediate

	brlt	+1, s1 5, s1 75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 immediate is less than immediate

	brlt	+1, s2 -5477, s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 immediate is less than immediate

	brlt	+1, s4 -65487797, s4 42179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 immediate is less than immediate

	brlt	+1, s8 -87893218771531849, s8 65423135487897654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 immediate is less than immediate

	brlt	+1, u1 200, u1 241
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 immediate is less than immediate

	brlt	+1, u2 479, u2 42337
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 immediate is less than immediate

	brlt	+1, u4 6468712, u4 3468777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 immediate is less than immediate

	brlt	+1, u8 87893218771531849, u8 3215446587879844654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 immediate is less than immediate

	brlt	+1, f4 0.25, f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 immediate is less than immediate

	brlt	+1, f8 -2.75, f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr immediate is less than immediate

	brlt	+1, ptr 0x75, ptr 0x84
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun immediate is less than immediate

	brlt	+1, fun 0x12, fun 0x54
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 register is less than immediate

	mov	s1 $0, s1 5
	brlt	+1, s1 $0, s1 75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 register is less than immediate

	mov	s2 $0, s2 -5477
	brlt	+1, s2 $0, s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 register is less than immediate

	mov	s4 $0, s4 -65487797
	brlt	+1, s4 $0, s4 42179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 register is less than immediate

	mov	s8 $0, s8 3441447974730
	brlt	+1, s8 $0, s8 3442504855877
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 register is less than immediate

	mov	u1 $0, u1 200
	brlt	+1, u1 $0, u1 241
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 register is less than immediate

	mov	u2 $0, u2 479
	brlt	+1, u2 $0, u2 42337
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 register is less than immediate

	mov	u4 $0, u4 6468712
	brlt	+1, u4 $0, u4 3468777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 register is less than immediate

	mov	u8 $0, u8 87893218771531849
	brlt	+1, u8 $0, u8 3215446587879844654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 register is less than immediate

	mov	f4 $0, f4 0.25
	brlt	+1, f4 $0, f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 register is less than immediate

	mov	f8 $0, f8 -2.75
	brlt	+1, f8 $0, f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr register is less than immediate

	mov	ptr $0, ptr 0x54
	brlt	+1, ptr $0, ptr 0x79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun register is less than immediate

	mov	fun $0, fun 0x54
	brlt	+1, fun $0, fun 0x79
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 memory is less than immediate

	brlt	+1, s1 [@constant1], s1 75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5

positive: branch if s2 memory is less than immediate

	brlt	+1, s2 [@constant1], s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477

positive: branch if s4 memory is less than immediate

	brlt	+1, s4 [@constant1], s4 42179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -65487797

positive: branch if s8 memory is less than immediate

	brlt	+1, s8 [@constant1], s8 65423135487897654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 memory is less than immediate

	brlt	+1, u1 [@constant1], u1 241
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200

positive: branch if u2 memory is less than immediate

	brlt	+1, u2 [@constant1], u2 42337
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 479

positive: branch if u4 memory is less than immediate

	brlt	+1, u4 [@constant1], u4 3468777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 6468712

positive: branch if u8 memory is less than immediate

	brlt	+1, u8 [@constant1], u8 3215446587879844654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is less than immediate

	brlt	+1, f4 [@constant1], f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25

positive: branch if f8 memory is less than immediate

	brlt	+1, f8 [@constant1], f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75

positive: branch if ptr memory is less than immediate

	brlt	+1, ptr [@constant1], ptr @constant1 + 9
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7

positive: branch if fun memory is less than immediate

	brlt	+1, fun [@constant1], fun 0x72
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun 0x12

positive: branch if s1 immediate is less than register

	mov	s1 $1, s1 75
	brlt	+1, s1 5, s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 immediate is less than register

	mov	s2 $1, s2 21467
	brlt	+1, s2 -5477, s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 immediate is less than register

	mov	s4 $1, s4 42179745
	brlt	+1, s4 -65487797, s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 immediate is less than register

	mov	s8 $1, s8 65423135487897654
	brlt	+1, s8 -87893218771531849, s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 immediate is less than register

	mov	u1 $1, u1 241
	brlt	+1, u1 200, u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 immediate is less than register

	mov	u2 $1, u2 42337
	brlt	+1, u2 479, u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 immediate is less than register

	mov	u4 $1, u4 3468777874
	brlt	+1, u4 6468712, u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 immediate is less than register

	mov	u8 $1, u8 3215446587879844654
	brlt	+1, u8 87893218771531849, u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 immediate is less than register

	mov	f4 $1, f4 4.5
	brlt	+1, f4 0.25, f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 immediate is less than register

	mov	f8 $1, f8 3.75
	brlt	+1, f8 -2.75, f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr immediate is less than register

	mov	ptr $1, ptr 0x54
	brlt	+1, ptr 0x13, ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun immediate is less than register

	mov	fun $1, fun 0x54
	brlt	+1, fun 0x13, fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 register is less than register

	mov	s1 $0, s1 5
	mov	s1 $1, s1 75
	brlt	+1, s1 $0, s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 register is less than register

	mov	s2 $0, s2 -5477
	mov	s2 $1, s2 21467
	brlt	+1, s2 $0, s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 register is less than register

	mov	s4 $0, s4 -65487797
	mov	s4 $1, s4 42179745
	brlt	+1, s4 $0, s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 register is less than register

	mov	s8 $0, s8 -87893218771531849
	mov	s8 $1, s8 65423135487897654
	brlt	+1, s8 $0, s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 register is less than register

	mov	u1 $0, u1 200
	mov	u1 $1, u1 241
	brlt	+1, u1 $0, u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 register is less than register

	mov	u2 $0, u2 479
	mov	u2 $1, u2 42337
	brlt	+1, u2 $0, u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 register is less than register

	mov	u4 $0, u4 6468712
	mov	u4 $1, u4 3468777874
	brlt	+1, u4 $0, u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 register is less than register

	mov	u8 $0, u8 87893218771531849
	mov	u8 $1, u8 3215446587879844654
	brlt	+1, u8 $0, u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 register is less than register

	mov	f4 $0, f4 0.25
	mov	f4 $1, f4 4.5
	brlt	+1, f4 $0, f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 register is less than register

	mov	f8 $0, f8 -2.75
	mov	f8 $1, f8 3.75
	brlt	+1, f8 $0, f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr register is less than register

	mov	ptr $0, ptr 0x59
	mov	ptr $1, ptr 0x67
	brlt	+1, ptr $0, ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if fun register is less than register

	mov	fun $0, fun 0x59
	mov	fun $1, fun 0x67
	brlt	+1, fun $0, fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 memory is less than register

	mov	s1 $1, s1 75
	brlt	+1, s1 [@constant1], s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5

positive: branch if s2 memory is less than register

	mov	s2 $1, s2 21467
	brlt	+1, s2 [@constant1], s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477

positive: branch if s4 memory is less than register

	mov	s4 $1, s4 42179745
	brlt	+1, s4 [@constant1], s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -65487797

positive: branch if s8 memory is less than register

	mov	s8 $1, s8 65423135487897654
	brlt	+1, s8 [@constant1], s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849

positive: branch if u1 memory is less than register

	mov	u1 $1, u1 241
	brlt	+1, u1 [@constant1], u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200

positive: branch if u2 memory is less than register

	mov	u2 $1, u2 42337
	brlt	+1, u2 [@constant1], u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 479

positive: branch if u4 memory is less than register

	mov	u4 $1, u4 3468777874
	brlt	+1, u4 [@constant1], u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 6468712

positive: branch if u8 memory is less than register

	mov	u8 $1, u8 3215446587879844654
	brlt	+1, u8 [@constant1], u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is less than register

	mov	f4 $1, f4 4.5
	brlt	+1, f4 [@constant1], f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25

positive: branch if f8 memory is less than register

	mov	f8 $1, f8 3.75
	brlt	+1, f8 [@constant1], f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75

positive: branch if ptr memory is less than register

	mov	ptr $1, ptr @constant1 + 9
	brlt	+1, ptr [@constant1], ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7

positive: branch if fun memory is less than register

	mov	fun $1, fun 0x45
	brlt	+1, fun [@constant1], fun $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun 0x10

positive: branch if s1 immediate is less than memory

	brlt	+1, s1 5, s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	s1 75

positive: branch if s2 immediate is less than memory

	brlt	+1, s2 -5477, s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 immediate is less than memory

	brlt	+1, s4 -65487797, s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	s4 42179745

positive: branch if s8 immediate is less than memory

	brlt	+1, s8 -87893218771531849, s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	s8 65423135487897654

positive: branch if u1 immediate is less than memory

	brlt	+1, u1 200, u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	u1 241

positive: branch if u2 immediate is less than memory

	brlt	+1, u2 479, u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	u2 42337

positive: branch if u4 immediate is less than memory

	brlt	+1, u4 6468712, u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	u4 3468777874

positive: branch if u8 immediate is less than memory

	brlt	+1, u8 87893218771531849, u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	u8 3215446587879844654

positive: branch if f4 immediate is less than memory

	brlt	+1, f4 0.25, f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 immediate is less than memory

	brlt	+1, f8 -2.75, f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr immediate is less than memory

	brlt	+1, ptr @constant2 + 7, ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 9

positive: branch if fun immediate is less than memory

	brlt	+1, fun 0x45, fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	funsize
	def	fun 0x67

positive: branch if s1 register is less than memory

	mov	s1 $0, s1 5
	brlt	+1, s1 $0, s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	s1 75

positive: branch if s2 register is less than memory

	mov	s2 $0, s2 -5477
	brlt	+1, s2 $0, s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 register is less than memory

	mov	s4 $0, s4 -65487797
	brlt	+1, s4 $0, s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	s4 42179745

positive: branch if s8 register is less than memory

	mov	s8 $0, s8 -87893218771531849
	brlt	+1, s8 $0, s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	s8 65423135487897654

positive: branch if u1 register is less than memory

	mov	u1 $0, u1 200
	brlt	+1, u1 $0, u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	u1 241

positive: branch if u2 register is less than memory

	mov	u2 $0, u2 479
	brlt	+1, u2 $0, u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	u2 42337

positive: branch if u4 register is less than memory

	mov	u4 $0, u4 6468712
	brlt	+1, u4 $0, u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	u4 3468777874

positive: branch if u8 register is less than memory

	mov	u8 $0, u8 87893218771531849
	brlt	+1, u8 $0, u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	u8 3215446587879844654

positive: branch if f4 register is less than memory

	mov	f4 $0, f4 0.25
	brlt	+1, f4 $0, f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 register is less than memory

	mov	f8 $0, f8 -2.75
	brlt	+1, f8 $0, f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr register is less than memory

	mov	ptr $0, ptr @constant2 + 7
	brlt	+1, ptr $0, ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 9

positive: branch if fun register is less than memory

	mov	fun $0, fun 0x57
	brlt	+1, fun $0, fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	funsize
	def	fun 0x67

positive: branch if s1 memory is less than memory

	brlt	+1, s1 [@constant1], s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5
	.const constant2
	.alignment	1
	def	s1 75

positive: branch if s2 memory is less than memory

	brlt	+1, s2 [@constant1], s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 -5477
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 memory is less than memory

	brlt	+1, s4 [@constant1], s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -65487797
	.const constant2
	.alignment	4
	def	s4 42179745

positive: branch if s8 memory is less than memory

	brlt	+1, s8 [@constant1], s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -87893218771531849
	.const constant2
	.alignment	8
	def	s8 65423135487897654

positive: branch if u1 memory is less than memory

	brlt	+1, u1 [@constant1], u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200
	.const constant2
	.alignment	1
	def	u1 241

positive: branch if u2 memory is less than memory

	brlt	+1, u2 [@constant1], u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 479
	.const constant2
	.alignment	2
	def	u2 42337

positive: branch if u4 memory is less than memory

	brlt	+1, u4 [@constant1], u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 6468712
	.const constant2
	.alignment	4
	def	u4 3468777874

positive: branch if u8 memory is less than memory

	brlt	+1, u8 [@constant1], u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849
	.const constant2
	.alignment	8
	def	u8 3215446587879844654

positive: branch if f4 memory is less than memory

	brlt	+1, f4 [@constant1], f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 0.25
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 memory is less than memory

	brlt	+1, f8 [@constant1], f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 -2.75
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr memory is less than memory

	brlt	+1, ptr [@constant1], ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant2 + 7
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 9

positive: branch if fun memory is less than memory

	brlt	+1, fun [@constant1], fun [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	funsize
	def	fun 0x12
	.const constant2
	.alignment	funsize
	def	fun 0x97

# brge instruction

positive: branch if s1 immediate is greater than or equal to immediate

	brge	+1, s1 5, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 immediate is greater than or equal to immediate

	brge	+1, s2 29477, s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 immediate is greater than or equal to immediate

	brge	+1, s4 -15487797, s4 -42179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 immediate is greater than or equal to immediate

	brge	+1, s8 87893218771531849, s8 -65423135487897654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 immediate is greater than or equal to immediate

	brge	+1, u1 200, u1 150
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 immediate is greater than or equal to immediate

	brge	+1, u2 42337, u2 42337
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 immediate is greater than or equal to immediate

	brge	+1, u4 3468777875, u4 3468777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 immediate is greater than or equal to immediate

	brge	+1, u8 87893218771531849, u8 87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 immediate is greater than or equal to immediate

	brge	+1, f4 4.75, f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 immediate is greater than or equal to immediate

	brge	+1, f8 5.25, f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr immediate is greater than or equal to immediate

	brge	+1, ptr 0x81, ptr 0x73
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 register is greater than or equal to immediate

	mov	s1 $0, s1 5
	brge	+1, s1 $0, s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 register is greater than or equal to immediate

	mov	s2 $0, s2 29477
	brge	+1, s2 $0, s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 register is greater than or equal to immediate

	mov	s4 $0, s4 -15487797
	brge	+1, s4 $0, s4 -42179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 register is greater than or equal to immediate

	mov	s8 $0, s8 87893218771531849
	brge	+1, s8 $0, s8 -65423135487897654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 register is greater than or equal to immediate

	mov	u1 $0, u1 200
	brge	+1, u1 $0, u1 150
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 register is greater than or equal to immediate

	mov	u2 $0, u2 42337
	brge	+1, u2 $0, u2 42337
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 register is greater than or equal to immediate

	mov	u4 $0, u4 3468777875
	brge	+1, u4 $0, u4 3468777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 register is greater than or equal to immediate

	mov	u8 $0, u8 87893218771531849
	brge	+1, u8 $0, u8 87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 register is greater than or equal to immediate

	mov	f4 $0, f4 4.75
	brge	+1, f4 $0, f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 register is greater than or equal to immediate

	mov	f8 $0, f8 5.25
	brge	+1, f8 $0, f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr register is greater than or equal to immediate

	mov	ptr $0, ptr 0x78
	brge	+1, ptr $0, ptr 0x64
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 memory is greater than or equal to immediate

	brge	+1, s1 [@constant1], s1 5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5

positive: branch if s2 memory is greater than or equal to immediate

	brge	+1, s2 [@constant1], s2 21467
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 29477

positive: branch if s4 memory is greater than or equal to immediate

	brge	+1, s4 [@constant1], s4 -42179745
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -15487797

positive: branch if s8 memory is greater than or equal to immediate

	brge	+1, s8 [@constant1], s8 -65423135487897654
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 87893218771531849

positive: branch if u1 memory is greater than or equal to immediate

	brge	+1, u1 [@constant1], u1 150
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200

positive: branch if u2 memory is greater than or equal to immediate

	brge	+1, u2 [@constant1], u2 42337
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 42337

positive: branch if u4 memory is greater than or equal to immediate

	brge	+1, u4 [@constant1], u4 3468777874
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 3468777875

positive: branch if u8 memory is greater than or equal to immediate

	brge	+1, u8 [@constant1], u8 87893218771531849
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is greater than or equal to immediate

	brge	+1, f4 [@constant1], f4 4.5
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 4.75

positive: branch if f8 memory is greater than or equal to immediate

	brge	+1, f8 [@constant1], f8 3.75
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 5.25

positive: branch if ptr memory is greater than or equal to immediate

	brge	+1, ptr [@constant1], ptr @constant1 + 7
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 9

positive: branch if s1 immediate is greater than or equal to register

	mov	s1 $1, s1 5
	brge	+1, s1 5, s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 immediate is greater than or equal to register

	mov	s2 $1, s2 21467
	brge	+1, s2 29477, s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 immediate is greater than or equal to register

	mov	s4 $1, s4 -42179745
	brge	+1, s4 -15487797, s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 immediate is greater than or equal to register

	mov	s8 $1, s8 -65423135487897654
	brge	+1, s8 87893218771531849, s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 immediate is greater than or equal to register

	mov	u1 $1, u1 150
	brge	+1, u1 200, u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 immediate is greater than or equal to register

	mov	u2 $1, u2 42337
	brge	+1, u2 42337, u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 immediate is greater than or equal to register

	mov	u4 $1, u4 3468777874
	brge	+1, u4 3468777875, u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 immediate is greater than or equal to register

	mov	u8 $1, u8 87893218771531849
	brge	+1, u8 87893218771531849, u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 immediate is greater than or equal to register

	mov	f4 $1, f4 4.5
	brge	+1, f4 4.75, f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 immediate is greater than or equal to register

	mov	f8 $1, f8 3.75
	brge	+1, f8 5.25, f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr immediate is greater than or equal to register

	mov	ptr $1, ptr 0x44
	brge	+1, ptr 0x48, ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 register is greater than or equal to register

	mov	s1 $0, s1 5
	mov	s1 $1, s1 5
	brge	+1, s1 $0, s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s2 register is greater than or equal to register

	mov	s2 $0, s2 29477
	mov	s2 $1, s2 21467
	brge	+1, s2 $0, s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s4 register is greater than or equal to register

	mov	s4 $0, s4 -15487797
	mov	s4 $1, s4 -42179745
	brge	+1, s4 $0, s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s8 register is greater than or equal to register

	mov	s8 $0, s8 87893218771531849
	mov	s8 $1, s8 -65423135487897654
	brge	+1, s8 $0, s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u1 register is greater than or equal to register

	mov	u1 $0, u1 200
	mov	u1 $1, u1 150
	brge	+1, u1 $0, u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u2 register is greater than or equal to register

	mov	u2 $0, u2 42337
	mov	u2 $1, u2 42337
	brge	+1, u2 $0, u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u4 register is greater than or equal to register

	mov	u4 $0, u4 3468777875
	mov	u4 $1, u4 3468777874
	brge	+1, u4 $0, u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if u8 register is greater than or equal to register

	mov	u8 $0, u8 87893218771531849
	mov	u8 $1, u8 87893218771531849
	brge	+1, u8 $0, u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f4 register is greater than or equal to register

	mov	f4 $0, f4 4.75
	mov	f4 $1, f4 4.5
	brge	+1, f4 $0, f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if f8 register is greater than or equal to register

	mov	f8 $0, f8 5.25
	mov	f8 $1, f8 3.75
	brge	+1, f8 $0, f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if ptr register is greater than or equal to register

	mov	ptr $0, ptr 0x78
	mov	ptr $1, ptr 0x78
	brge	+1, ptr $0, ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0

positive: branch if s1 memory is greater than or equal to register

	mov	s1 $1, s1 5
	brge	+1, s1 [@constant1], s1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5

positive: branch if s2 memory is greater than or equal to register

	mov	s2 $1, s2 21467
	brge	+1, s2 [@constant1], s2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 29477

positive: branch if s4 memory is greater than or equal to register

	mov	s4 $1, s4 -42179745
	brge	+1, s4 [@constant1], s4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -15487797

positive: branch if s8 memory is greater than or equal to register

	mov	s8 $1, s8 -65423135487897654
	brge	+1, s8 [@constant1], s8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 87893218771531849

positive: branch if u1 memory is greater than or equal to register

	mov	u1 $1, u1 150
	brge	+1, u1 [@constant1], u1 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200

positive: branch if u2 memory is greater than or equal to register

	mov	u2 $1, u2 42337
	brge	+1, u2 [@constant1], u2 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 42337

positive: branch if u4 memory is greater than or equal to register

	mov	u4 $1, u4 3468777874
	brge	+1, u4 [@constant1], u4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 3468777875

positive: branch if u8 memory is greater than or equal to register

	mov	u8 $1, u8 87893218771531849
	brge	+1, u8 [@constant1], u8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is greater than or equal to register

	mov	f4 $1, f4 4.5
	brge	+1, f4 [@constant1], f4 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 4.75

positive: branch if f8 memory is greater than or equal to register

	mov	f8 $1, f8 3.75
	brge	+1, f8 [@constant1], f8 $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 5.25

positive: branch if ptr memory is greater than or equal to register

	mov	ptr $1, ptr @constant1 + 5
	brge	+1, ptr [@constant1], ptr $1
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7

positive: branch if s1 immediate is greater than or equal to memory

	brge	+1, s1 5, s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	s1 5

positive: branch if s2 immediate is greater than or equal to memory

	brge	+1, s2 29477, s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 immediate is greater than or equal to memory

	brge	+1, s4 -15487797, s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	s4 -42179745

positive: branch if s8 immediate is greater than or equal to memory

	brge	+1, s8 87893218771531849, s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	s8 -65423135487897654

positive: branch if u1 immediate is greater than or equal to memory

	brge	+1, u1 200, u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	u1 150

positive: branch if u2 immediate is greater than or equal to memory

	brge	+1, u2 42337, u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	u2 42337

positive: branch if u4 immediate is greater than or equal to memory

	brge	+1, u4 3468777875, u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	u4 3468777874

positive: branch if u8 immediate is greater than or equal to memory

	brge	+1, u8 87893218771531849, u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 immediate is greater than or equal to memory

	brge	+1, f4 4.75, f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 immediate is greater than or equal to memory

	brge	+1, f8 5.25, f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr immediate is greater than or equal to memory

	brge	+1, ptr @constant2 + 9, ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 7

positive: branch if s1 register is greater than or equal to memory

	mov	s1 $0, s1 5
	brge	+1, s1 $0, s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	s1 5

positive: branch if s2 register is greater than or equal to memory

	mov	s2 $0, s2 29477
	brge	+1, s2 $0, s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 register is greater than or equal to memory

	mov	s4 $0, s4 -15487797
	brge	+1, s4 $0, s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	s4 -42179745

positive: branch if s8 register is greater than or equal to memory

	mov	s8 $0, s8 87893218771531849
	brge	+1, s8 $0, s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	s8 -65423135487897654

positive: branch if u1 register is greater than or equal to memory

	mov	u1 $0, u1 200
	brge	+1, u1 $0, u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	1
	def	u1 150

positive: branch if u2 register is greater than or equal to memory

	mov	u2 $0, u2 42337
	brge	+1, u2 $0, u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	2
	def	u2 42337

positive: branch if u4 register is greater than or equal to memory

	mov	u4 $0, u4 3468777875
	brge	+1, u4 $0, u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	u4 3468777874

positive: branch if u8 register is greater than or equal to memory

	mov	u8 $0, u8 87893218771531849
	brge	+1, u8 $0, u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 register is greater than or equal to memory

	mov	f4 $0, f4 4.75
	brge	+1, f4 $0, f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 register is greater than or equal to memory

	mov	f8 $0, f8 5.25
	brge	+1, f8 $0, f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr register is greater than or equal to memory

	mov	ptr $0, ptr @constant2 + 7
	brge	+1, ptr $0, ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant2
	.alignment	ptrsize
	def	ptr @constant2 + 5

positive: branch if s1 memory is greater than or equal to memory

	brge	+1, s1 [@constant1], s1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	s1 5
	.const constant2
	.alignment	1
	def	s1 5

positive: branch if s2 memory is greater than or equal to memory

	brge	+1, s2 [@constant1], s2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	s2 29477
	.const constant2
	.alignment	2
	def	s2 21467

positive: branch if s4 memory is greater than or equal to memory

	brge	+1, s4 [@constant1], s4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	s4 -15487797
	.const constant2
	.alignment	4
	def	s4 -42179745

positive: branch if s8 memory is greater than or equal to memory

	brge	+1, s8 [@constant1], s8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	s8 -59280731556529
	.const constant2
	.alignment	8
	def	s8 -59281453468948

positive: branch if u1 memory is greater than or equal to memory

	brge	+1, u1 [@constant1], u1 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	1
	def	u1 200
	.const constant2
	.alignment	1
	def	u1 150

positive: branch if u2 memory is greater than or equal to memory

	brge	+1, u2 [@constant1], u2 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	2
	def	u2 42337
	.const constant2
	.alignment	2
	def	u2 42337

positive: branch if u4 memory is greater than or equal to memory

	brge	+1, u4 [@constant1], u4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	u4 3468777875
	.const constant2
	.alignment	4
	def	u4 3468777874

positive: branch if u8 memory is greater than or equal to memory

	brge	+1, u8 [@constant1], u8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	u8 87893218771531849
	.const constant2
	.alignment	8
	def	u8 87893218771531849

positive: branch if f4 memory is greater than or equal to memory

	brge	+1, f4 [@constant1], f4 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	4
	def	f4 4.75
	.const constant2
	.alignment	4
	def	f4 4.5

positive: branch if f8 memory is greater than or equal to memory

	brge	+1, f8 [@constant1], f8 [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	8
	def	f8 5.25
	.const constant2
	.alignment	8
	def	f8 3.75

positive: branch if ptr memory is greater than or equal to memory

	brge	+1, ptr [@constant1], ptr [@constant2]
	call	fun @abort, 0
	push	int 0
	call	fun @_Exit, 0
	.const constant1
	.alignment	ptrsize
	def	ptr @constant1 + 7
	.const constant2
	.alignment	ptrsize
	def	ptr @constant1 + 5

# jump instruction

positive: indirect branch via immediate

	jump	fun @skip
	call	fun @abort, 0
	alias	"skip"
	push	int 0
	call	fun @_Exit, 0

positive: indirect branch via register

	mov	fun $0, fun @skip
	jump	fun $0
	call	fun @abort, 0
	alias	"skip"
	push	int 0
	call	fun @_Exit, 0

positive: indirect branch via memory

	jump	fun [@address]
	call	fun @abort, 0
	alias	"skip"
	push	int 0
	call	fun @_Exit, 0
	.const address
	.alignment	funsize
	def	fun @skip

# nop instruction

positive: no operation

	nop
	push	int 0
	call	fun @_Exit, 0

# asm instruction

positive: inline assembly

	asm	"", 1, ""
	push	int 0
	call	fun @_Exit, 0

# fix instruction

positive: fix register mapping

	mov	int $1, int 0
	fix	int $1
	push	int $1
	call	fun @_Exit, 0
	unfix	int $1

# unfix instruction

positive: unfix register mapping

	mov	int $1, int 0
	fix	int $1
	unfix	int $1
	push	int $1
	call	fun @_Exit, 0

# loc instruction

positive: source code location of section

	loc	"", 1, 1
	void
	push	int 0
	call	fun @_Exit, 0

positive: source code location of symbol

	loc	"", 1, 1
	void
	sym	+0, "", s4 0
	loc	"", 1, 1
	void
	push	int 0
	call	fun @_Exit, 0

positive: source code location of field

	push	int 0
	call	fun @_Exit, 0
	.type type
	loc	"", 1, 1
	rec	+1, 0
	field	"", 0, s1 0
	loc	"", 1, 1
	void

positive: source code location of enumerator

	push	int 0
	call	fun @_Exit, 0
	.type type
	loc	"", 1, 1
	enum	+1
	value	"", s1 0
	loc	"", 1, 1
	void

# break instruction

positive: breakpoint

	loc	"", 1, 1
	void
	break
	loc	"", 1, 1
	push	int 0
	call	fun @_Exit, 0

# trap instruction

negative: abnormal program termination

	trap	0

# sym instruction

positive: symbol declaration

	loc	"", 1, 1
	void
	sym	+0, "", s4 0
	loc	"", 1, 1
	void
	push	int 0
	call	fun @_Exit, 0

# field instruction

positive: field declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	loc	"", 1, 1
	rec	+1, 0
	field	"", 0, s1 0
	loc	"", 1, 1
	void

# value instruction

positive: enumerator declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	loc	"", 1, 1
	enum	+1
	value	"", s1 0
	loc	"", 1, 1
	void

# type instruction

positive: basic type declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	void

# void instruction

positive: void type declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	void

# array instruction

positive: array type declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	array	0, 0
	void

# rec instruction

positive: record type declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	rec	+0, 0

# ptr instruction

positive: pointer type declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	ptr
	void

# ref instruction

positive: reference type declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	ref
	void

# func instruction

positive: function type declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	func	+0
	void

# enum instruction

positive: enumeration type declaration

	push	int 0
	call	fun @_Exit, 0
	.type type
	enum	+0
	void

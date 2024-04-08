; MMIX simulator runtime support
; Copyright (C) Florian Negele

; This file is part of the Eigen Compiler Suite.

; The ECS is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; The ECS is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; Under Section 7 of the GNU General Public License version 3,
; the copyright holder grants you additional permissions to use
; this file as described in the ECS Runtime Support Exception.

; You should have received a copy of the GNU General Public License
; and a copy of the ECS Runtime Support Exception along with
; the ECS.  If not, see <https://www.gnu.org/licenses/>.

; MMIX object file format
.header _header

	.required
	.origin	0x1000
	.qbyte	0x98090100	; lop_pre
	.qbyte	0x98021008	; lop_loc
	setml	$1, 0x8000

.trailer _trailer

	.required
	.alignment	8
	.qbyte	0x980a00ff	; lop_post
	.qbyte	0x00000000
	.qbyte	0x00001008
	.qbyte	0x980b0000	; lop_stab
	.qbyte	0x980c0000	; lop_end

.const _extension

	.byte	".mmo"

; environment name
.const _environment

	.byte	"MMIX simulator", 0

; standard abort function
.code abort

	.replaceable
	setl	$255, 1
	trap	0, 0, 0

; standard argc variable
.data _argc

	.alignment	4
	.qbyte	0

; standard argv variable
.data _argv

	.alignment	8
	.obyte	0

; standard _Exit function
.code _Exit

	.replaceable
	ldt	$255, $1, 8
	trap	0, 0, 0

; standard fputc function
.code fputc

	geta	$254, patch
	ldou	$253, $1, 16
	add	$254, $254, 3
	stb	$253, $254, 0
	subu	$255, $1, 16
	addu	$254, $1, 11
	stou	$254, $255, 0
	setl	$254, 1
	stou	$254, $255, 8
patch:	trap	0, 6, 1
	ldou	$255, $1, 0
	addu	$1, $1, 8
	go	$255, $255, 0

; standard free function
.code free

	ldou	$255, $1, 0
	addu	$1, $1, 8
	go	$255, $255, 0

; standard getchar function
.code getchar

	subu	$1, $1, 8
	subu	$255, $1, 16
	stou	$1, $255, 0
	setl	$254, 1
	stou	$254, $255, 8
	trap	0, 3, 0
	bnz	$255, fail
	ldbu	$0, $1, 0
	jmp	skip
fail:	neg	$0, 0, 1
skip:	addu	$1, $1, 8
	ldou	$255, $1, 0
	addu	$1, $1, 8
	go	$255, $255, 0

; standard putchar function
.code putchar

	subu	$255, $1, 16
	addu	$254, $1, 11
	stou	$254, $255, 0
	setl	$254, 1
	stou	$254, $255, 8
	trap	0, 6, 1
	ldou	$255, $1, 0
	addu	$1, $1, 8
	go	$255, $255, 0

; standard malloc function
.code malloc

	setl	$254, @_heap_pointer
	orml	$254, @_heap_pointer >> 16
	ldou	$0, $254, 0
	ldou	$255, $1, 8
	addu	$255, $255, 7
	andn	$255, $255, 7
	addu	$255, $0, $255
	stou	$255, $254, 0
	ldou	$255, $1, 0
	addu	$1, $1, 8
	go	$255, $255, 0

; current heap pointer
.data _heap_pointer

	.alignment	8
	.obyte	@_trailer + 24

; standard stderr variable
.const stderr

	.alignment	8
	.obyte	2

; standard stdin variable
.const stdin

	.alignment	8
	.obyte	0

; standard stdout variable
.const stdout

	.alignment	8
	.obyte	1

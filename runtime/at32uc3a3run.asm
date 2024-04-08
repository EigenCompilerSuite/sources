; AT32UC3A3 runtime support
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

; CPU initialization
.header _header

	.required
	.origin	0x80002000

	; size of internal SRAM
SRAM:	.equals	65536

	; set stack pointer
	mov	sp, SRAM

; last section
.trailer _trailer

	.alignment	4

; environment name
.const _environment

	.byte	"AT32UC3A3", 0

; reserved system registers
.data _reserved

	.required
	.origin	0x00000000
	.reserve	0x400

; standard abort function
.code abort

	ssrf	16
loop:	sleep	5
	rjmp	loop

; standard _Exit function
.code _Exit

	ssrf	16
loop:	sleep	5
	rjmp	loop

; standard free function
.code free

	ld.w	pc, sp++

; standard getchar function
.code getchar

	mov	r0, 0
	ld.w	pc, sp++

; standard malloc function
.code malloc

	movl	r2, @_heap_start
	orh	r2, @_heap_start >> 16
	ld.w	r0, r2[0]
	ld.w	r3, sp[4]
	add	r3, r0
	st.w	r2[0], r3
	ld.w	pc, sp++

; heap start
.data _heap_start

	.alignment	4
	.reserve	4
	.require	_init_heap_start

.initdata _init_heap_start

	movl	r2, @_heap_start
	orh	r2, @_heap_start >> 16
	movl	r3, @_trailer
	orh	r3, @_trailer >> 16
	st.w	r2[0], r3

; standard putchar function
.code putchar

	mov	r0, 0
	ld.w	pc, sp++

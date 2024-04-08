; RISC runtime support
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

; CPU initialisation at disk block 524292
.header _header

	.required
	.origin	0x00000000

_0:	mov	r2, .origin + stack
_4:	ld	r14, r2, 0
_8:	b	skip
heap:	.reserve	4
limit:	.qbyte	@_trailer - .origin
_20:	.reserve	4
stack:	.reserve	4
skip:

.trailer _trailer

	.alignment	512

; environment name
.const _environment

	.byte	"RISC", 0

; standard abort function
.code abort

loop:	b	loop

; standard _Exit function
.code _Exit

loop:	b	loop

; standard free function
.code free

	b	r15

; standard getchar function
.code getchar

	mov	r2, -52
loop:	ldb	r3, r2, 0
	and	r3, r3, 1
	bne	loop
	mov	r2, -56
	ldb	r0, r2, 0
	b	r15

; standard malloc function
.code malloc

	mvs	r2, @_heap_start >> 16
	ior	r2, r2, @_heap_start
	ld	r0, r2, 0
	ld	r3, r14, 0
	add	r3, r0, r3
	st	r3, r2, 0
	b	r15

; heap start
.data _heap_start

	.alignment	4
	.qbyte	@_trailer

; standard putchar function
.code putchar

	mov	r2, -52
loop:	ldb	r3, r2, 0
	and	r3, r3, 2
	bne	loop
	mov	r2, -56
	ldb	r3, r14, 0
	stb	r3, r2, 0
	b	r15

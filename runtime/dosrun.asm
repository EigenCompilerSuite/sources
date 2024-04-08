; DOS runtime support
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

; COM file format
.header _header

	.required
	.origin	0x0100
	.assert	.bitmode == 16

.const _extension

	.byte	".com"

; environment name
.const _environment

	.byte	"DOS", 0

; standard abort function
.code abort

	.replaceable
	mov	ax, 0x4c01
	int	21h

; standard argc variable
.data _argc

	.alignment	2
	.dbyte	0

; standard argv variable
.data _argv

	.alignment	2
	.dbyte	0

; standard clock function
.code clock

	xor	eax, eax
	ret

; standard _Exit function
.code _Exit

	.replaceable
	mov	bx, sp
	mov	al, [bx + 2]
	mov	ah, 0x4c
	int	21h

; standard fputc function
.code fputc

	mov	bx, sp
	lea	dx, [bx + 2]
	mov	bx, [bx + 4]
	mov	cx, 1
	mov	ah, 0x40
	int	21h
	ret

; standard free function
.code free

	ret

; standard getchar function
.code getchar

	mov	ah, 0x01
	int	21h
	ret

; standard malloc function
.code malloc

	mov	bx, sp
	mov	ax, [@_heapsize]
	mov	bx, [bx + 2]
	add	bx, ax
	cmp	bx, word size (@_heap)
	ja	fail
	mov	[@_heapsize], bx
	add	ax, word @_heap
	ret
fail:	xor	ax, ax
	ret

; reserved heap space
.data _heap

	.reserve	32 * 1024

; current size of occupied heap space
.data _heapsize

	.alignment	2
	.dbyte	0

; standard putchar function
.code putchar

	mov	bx, sp
	mov	dl, [bx + 2]
	mov	ah, 0x02
	int	21h
	ret

; standard stderr variable
.const stderr

	.alignment	8
	.dbyte	2

; standard stdin variable
.const stdin

	.alignment	8
	.dbyte	0

; standard stdout variable
.const stdout

	.alignment	8
	.dbyte	1

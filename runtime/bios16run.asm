; BIOS 16-bit runtime support
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

; first record loaded by the BIOS
.header _header

base:	.equals	0x7c00
buffer:	.equals	0x7e00

	.required
	.origin	0
	.assert	.bitmode == 16

begin:
	; prepare registers
	mov	ax, base / 16
	mov	es, ax
	mov	ds, ax
	mov	ss, ax
	xor	eax, eax
	mov	ecx, eax
	mov	esp, eax
	jmpfar	base / 16, -offset (begin)

	; load remaining sectors from drive given in register dl
	mov	ah, 00h
	int	13h
	push	dx
	push	es
	xor	di, di
	mov	ah, 08h
	int	13h
	mov	[last_head], dh
	and	cl, 0x3f
	mov	[last_sector], cl
	pop	es
	pop	dx

	mov	bx, buffer - base
	mov	cx, 0x0002
	mov	dh, 0

copysector:
	cmp	bx, word @_trailer
	jae	word done

	mov	ax, 0x0201
	int	13h
	jnc	advance
	mov	ax, 0x0201
	int	13h
	jnc	advance
	mov	ax, 0x0201
	int	13h
	jnc	advance

abort:
	int	18h
	cli
	hlt
	jmp	abort

advance:
	add	bx, 512
	inc	cl
	cmp	cl, [last_sector]
	jbe	copysector

	mov	cl, 1
	inc	dh
	cmp	dh, [last_head]
	jbe	copysector

	mov	dh, 0
	inc	ch
	jmp	copysector

done:
	; turn off floppy
	mov	al, dl
	and	al, 1
	mov	dx, 3f2h
	out	dx, al

	; initialize screen
	mov	ax, 0x0002
	int	10h
	mov	ax, 0x0500
	int	10h
	jmp	word skip

last_head:	.byte	0
last_sector:	.byte	0

	; signature
	.pad	510
	.byte	0x55, 0xaa
skip:

; last record loaded by the BIOS
.trailer _trailer

	.alignment	512

; environment name
.const _environment

	.byte	"BIOS 16-bit", 0

; standard abort function
.code abort

	; reset with triple fault
	cli
	push	0
	push	0
	push	0
	mov	si, sp
	lidt	[si]
	int3

; standard clock function
.code clock

	rdtsc
	mov	ebx, 100000
	div	ebx
	ret

; standard _Exit function
.code _Exit

	mov	si, sp
	cmp	word [si + 2], 0
	jne	word @abort
	cli
end:	hlt
	jmp	end

; standard free function
.code free

	ret

; standard getchar function
.code getchar

	mov	ah, 0x00
	int	16h
	cmp	al, '\r'
	jne	skip
	mov	al, '\n'
skip:	push	ax
	call	word @putchar
	pop	ax
	ret

; standard malloc function
.code malloc

	mov	ax, [@_heap_start]
	mov	bx, ax
	mov	si, sp
	add	bx, [si + 2]
	jc	word @abort
	mov	[@_heap_start], bx
	ret

; heap start
.data _heap_start

	.alignment	2
	.dbyte	@_trailer

; standard putchar function
.code putchar

	mov	si, sp
	mov	ah, 0x0e
	mov	bx, 0x0007
	mov	al, [si + 2]
	cmp	al, '\n'
	jne	skip
	mov	al, '\r'
	int	10h
	mov	al, '\n'
skip:	int	10h
	ret

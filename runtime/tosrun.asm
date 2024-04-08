; Atari TOS runtime support
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

; begin of text segment
.header _header

	.required
	.origin	0

; end of text segment
.trailer _trailer

	.alignment	2

; environment name
.const _environment

	.byte	"Atari TOS", 0

; standard abort function
.code abort

	move.w	1, -(sp)	; retcode
	move.w	0x4c, -(sp)	; Pterm
	trap	1

; standard clock function
.code clock

	clr.l	-(sp)	; stack
	move.w	0x20, -(sp)	; Super
	trap	1
	addq.l	6, sp
	move.l	(0x04ba).w, d3
	move.l	d0, -(sp)	; stack
	move.w	0x20, -(sp)	; Super
	trap	1
	addq.l	6, sp
	move.l	d3, d0
	lsl.l	2, d3
	add.l	d3, d0
	rts

; standard _Exit function
.code _Exit

	move.w	(4, sp), -(sp)	; retcode
	move.w	0x4c, -(sp)	; Pterm
	trap	1

; standard fgetc function
.code fgetc

	clr.w	-(sp)
	pea	(1, sp)	; buffer
	move.l	1, -(sp)	; length
	move.w	(14, sp), -(sp)	; handle
	move.w	0x3f, -(sp)	; Fread
	trap	1
	lea	(12, sp), sp
	cmp.l	1, d0
	bne.b	fail
	move.w	(sp)+, d0
	cmp.w	'\r', d0
	bne.b	skip
	move.l	(@stdout).l, -(sp)
	move.w	'\n', -(sp)
	jsr	(@fputc).l
	addq.l	6, sp
	moveq	'\n', d0
skip:	rts
fail:	addq.l	2, sp
	clr.w	d0
	rts

; standard fputc function
.code fputc

	move.w	(4, sp), d2
repeat:	move.w	d2, -(sp)
	pea	(1, sp)	; buffer
	move.l	1, -(sp)	; count
	move.w	(16, sp), -(sp)	; handle
	move.w	0x40, -(sp)	; Fwrite
	trap	1
	lea	(14, sp), sp
	cmp.w	'\n', d2
	bne.b	skip
	moveq	'\r', d2
	bra.b	repeat
skip:	rts

; standard free function
.code free

	rts

; standard malloc function
.code malloc

	movea.l	(@_heap).l, a0
	suba.l	(4, sp), a0
	lea	(@_trailer).l, a1
	cmpa.l	a0, a1
	bhi.b	fail
	move.l	a0, (@_heap).l
	rts
fail:	suba.l	a0, a0
	rts

; heap pointer
.data _heap

	.alignment	2
	.reserve	4
	.require	_init_heap

.initdata _init_heap

	lea	(-0x2000, sp), a1
	move.l	a1, (@_heap).l

; standard remove function
.code remove

	move.l	(4, sp), -(sp)	; fname
	move.w	0x41, -(sp)	; Fdelete
	trap	1
	addq.l	6, sp
	rts

; standard rename function
.code rename

	move.l	(8, sp), -(sp)	; newname
	move.l	(8, sp), -(sp)	; oldname
	clr.w	-(sp)	; zero
	move.w	0x56, -(sp)	; Fwrite
	trap	1
	lea	(12, sp), sp
	rts

; standard stderr variable
.const stderr

	.alignment	2
	.qbyte	1

; standard stdin variable
.const stdin

	.alignment	2
	.qbyte	0

; standard stdout variable
.const stdout

	.alignment	2
	.qbyte	1

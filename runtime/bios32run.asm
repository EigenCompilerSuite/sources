; BIOS 32-bit runtime support
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
	.origin	0x100000
	.assert	.bitmode == 32

	.bitmode	16

begin:
	; prepare registers
	xor	ax, ax
	mov	es, ax
	mov	ds, ax
	mov	ss, ax
	mov	esp, base

	; enable A20 gate
	in	al, 0x92
	or	al, 2
	out	0x92, al

	; enable unreal mode
	cli
	push	ds
	lgdt	[base + gdt32]
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax
	mov	bx, (data32 - gdt32_begin) / 8 << 3
	mov	ds, bx
	and	al, 0xfe
	mov	cr0, eax
	pop	ds
	sti

	; load remaining sectors from drive given in register dl
	mov	ah, 00h
	int	13h
	push	dx
	push	es
	xor	di, di
	mov	ah, 08h
	int	13h
	mov	[base + last_head], dh
	and	cl, 0x3f
	mov	[base + last_sector], cl
	pop	es
	pop	dx

	mov	cx, 0x0001
	mov	dh, 0
	mov	edi, .origin

copysector:
	cmp	edi, dword @_trailer
	jae	done

	mov	ax, 0x0201
	mov	bx, buffer
	int	13h
	jnc	copybuffer
	mov	ax, 0x0201
	int	13h
	jnc	copybuffer
	mov	ax, 0x0201
	int	13h
	jnc	copybuffer

abort:
	int	18h
	cli
	hlt
	jmp	abort

copybuffer:
	mov	eax, [bx]
	mov	[edi], eax
	add	bx, 4
	add	edi, 4
	cmp	bx, buffer + 512
	jne	copybuffer

advance:
	inc	cl
	cmp	cl, [base + last_sector]
	jbe	copysector

	mov	cl, 1
	inc	dh
	cmp	dh, [base + last_head]
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

	; detect memory
	xor	ebx, ebx
	mov	edx, 0x534d4150
	mov	di, base + address_range
	mov	esi, @_memory_map

detect:
	mov	eax, 0xe820
	mov	ecx, 24
	int	15h
	jnc	last
	xor	ebx, ebx
last:	mov	edx, 0x534d4150
	cmp	eax, edx
	jne	sentinel
	cmp	dword [base + range_type], 1
	jne	skip
	cmp	dword [base + base_high], 0
	jne	skip
	cmp	dword[base + length_high], 0
	jne	skip
	mov	eax, [base + base_low]
	mov	[esi + 0], eax
	mov	eax, [base + length_low]
	mov	[esi + 4], eax
	add	esi, 8
skip:	cmp	ebx, 0
	jne	detect

sentinel:
	xor	ebx, ebx
	mov	[esi + 4], ebx
	add	esi, 8
	mov	edx, @_heap_start
	mov	[edx], esi

	; initialize screen
	mov	ax, 0x0002
	int	10h
	mov	ax, 0x0500
	int	10h
	mov	ax, 0x0100
	mov	cx, 0x2807
	int	10h

	; enter protected mode
	cli
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax

	; prepare segment registers
	mov	bx, (data32 - gdt32_begin) / 8 << 3
	mov	ds, bx
	mov	es, bx
	mov	fs, bx
	mov	gs, bx
	mov	ss, bx
	jmpfar	(code32 - gdt32_begin) / 8 << 3, .origin + 512

	.align	4
gdt32:
	.dbyte	gdt32_end - gdt32_begin
	.qbyte	base + gdt32_begin

gdt32_begin:
	.qbyte	0, 0
code32:	.byte	11111111b, 11111111b, 00h, 00h, 00h, 10011110b, 11001111b, 0h
data32:	.byte	11111111b, 11111111b, 00h, 00h, 00h, 10010010b, 11001111b, 0h
gdt32_end:

address_range:
base_low:	.qbyte	0
base_high:	.qbyte	0
length_low:	.qbyte	0
length_high:	.qbyte	0
range_type:	.qbyte	0
reserved:	.qbyte	0

last_head:	.byte	0
last_sector:	.byte	0

	; signature
	.pad	510
	.byte	0x55, 0xaa

; last record loaded by the BIOS
.trailer _trailer

	.alignment	512
	.alias	_memory_map

; environment name
.const _environment

	.byte	"BIOS 32-bit", 0

; interrupt descriptor table
.const _idt

	.alignment	2
	.dbyte	size (@_interrupts)
	.qbyte	@_interrupts

.data _interrupts

	.alignment	4
	.require	_init_interrupt_controllers

#repeat 48
	#if ## != 9 && ## != 15 && (## < 20 || ## > 29) && ## != 31
		#if ## == 8 || ## >= 10 && ## <= 14 || ## == 17
			.dbyte	@_default_error_handler
		#else
			.dbyte	@_default_handler
		#endif
		.dbyte	1 << 3, 0x8e00
		#if ## == 8 || ## >= 10 && ## <= 14 || ## == 17
			.dbyte	@_default_error_handler >> 16
		#else
			.dbyte	@_default_handler >> 16
		#endif
	#else
		.qbyte	0, 0
	#endif
#endrep

#define install

	mov	eax, @#1
	mov	[@_interrupts + #0 * 8], ax
	shr	eax, 16
	mov	[@_interrupts + #0 * 8 + 6], ax
	lidt	[@_idt]

	#if #0 >= 32 && #0 < 40
		in	al, 0x21
		btr	eax, #0 - 32
		out	0x21, al
	#elif #0 >= 40 && #0 < 48
		in	al, 0xa1
		btr	eax, #0 - 40
		out	0xa1, al
	#endif

#enddef

.code _default_handler

	iretd

.code _default_error_handler

	add	esp, 4
	iretd

.initdata _init_interrupt_controllers

	; ICW1: initialization
	mov	al, 0x11
	out	0x20, al
	out	0xa0, al

	; ICW2: vector offsets
	mov	al, 0x20
	out	0x21, al
	mov	al, 0x28
	out	0xa1, al

	; ICW3: cascading
	mov	al, 0x04
	out	0x21, al
	mov	al, 0x02
	out	0xa1, al

	; ICW4: mode
	mov	al, 0x01
	out	0x21, al
	out	0xa1, al

	; mask all interrupts
	mov	al, 0xff
	out	0x21, al
	out	0xa1, al

	sti

; clock value
.data _clock

	.alignment	4
	.qbyte	0
	.require	_init_timer

; timer initialization
.initdata _init_timer

	; initialize programmable interval timer
	mov	al, 00110100b
	out	0x43, al
	mov	ax, 1193180 / 1000
	out	0x40, al
	mov	al, ah
	out	0x40, al

	install	32, _timer_handler

; timer handler
.code _timer_handler

	push	eax
	inc	dword [@_clock]
	mov	al, 0x20
	out	0x20, al
	pop	eax
	iretd

; input buffer
.data _input_buffer

	.byte	-1
	.require	_init_keyboard

; keyboard initialization
.initdata _init_keyboard

	; disable devices
	call	dword @_keyboard_wait_out
	mov	al, 0xad
	out	64h, al
	call	dword @_keyboard_wait_out
	mov	al, 0xa7
	out	64h, al

	; set controller configuration
	call	dword @_keyboard_wait_out
	mov	al, 0x20
	out	64h, al
	call	dword @_keyboard_wait_in
	in	al, 60h
	mov	bl, al
	bts	ebx, 0
	btr	ebx, 1
	bts	ebx, 6
	call	dword @_keyboard_wait_out
	mov	al, 0x60
	out	64h, al
	call	dword @_keyboard_wait_out
	mov	al, bl
	out	60h, al

	; enable device
	call	dword @_keyboard_wait_out
	mov	al, 0xae
	out	64h, al

	install	33, _keyboard_handler

.code _keyboard_wait_in

loop:	in	al, 64h
	bt	eax, 0
	jnc	loop
	ret

.code _keyboard_wait_out

loop:	in	al, 64h
	bt	eax, 1
	jc	loop
	ret

; keyboard handler
.code _keyboard_handler

	push	eax
	in	al, 60h
	bt	eax, 7
	jc	skip
	movzx	eax, al
	add	eax, dword @_keyboard_map
	mov	al, [eax]
	mov	[@_input_buffer], al
skip:	mov	al, 0x20
	out	0x20, al
	pop	eax
	iretd

.const _keyboard_map

#define map
	.pad	#0
	.byte	#1
#enddef

	map	0x01, 0x1b
	map	0x02, '1'
	map	0x03, '2'
	map	0x04, '3'
	map	0x05, '4'
	map	0x06, '5'
	map	0x07, '6'
	map	0x08, '7'
	map	0x09, '8'
	map	0x0a, '9'
	map	0x0b, '0'
	map	0x0c, '-'
	map	0x0d, '='
	map	0x0e, '\b'
	map	0x0f, '\t'
	map	0x10, 'q'
	map	0x11, 'w'
	map	0x12, 'e'
	map	0x13, 'r'
	map	0x14, 't'
	map	0x15, 'y'
	map	0x16, 'u'
	map	0x17, 'i'
	map	0x18, 'o'
	map	0x19, 'p'
	map	0x1a, '['
	map	0x1b, ']'
	map	0x1c, '\n'
	map	0x1e, 'a'
	map	0x1f, 's'
	map	0x20, 'd'
	map	0x21, 'f'
	map	0x22, 'g'
	map	0x23, 'h'
	map	0x24, 'j'
	map	0x25, 'k'
	map	0x26, 'l'
	map	0x27, ';'
	map	0x28, '"'
	map	0x29, '`'
	map	0x2b, '\\'
	map	0x2c, 'z'
	map	0x2d, 'x'
	map	0x2e, 'c'
	map	0x2f, 'v'
	map	0x30, 'b'
	map	0x31, 'n'
	map	0x32, 'm'
	map	0x33, ','
	map	0x34, '.'
	map	0x35, '/'
	map	0x39, ' '
	.pad	127

#undef map

; standard abort function
.code abort

	; reset with triple fault
	cli
	push	0
	push	0
	lidt	[esp]
	int3

; standard clock function
.code clock

	mov	eax, [@_clock]
	ret

; standard _Exit function
.code _Exit

	cmp	dword [esp + 4], 0
	jne	dword @abort
	cli
end:	hlt
	jmp	end

; standard free function
.code free

	ret

; standard getchar function
.code getchar

	mov	al, -1
	xchg	al, [@_input_buffer]
	movsx	eax, al
	ret

; standard malloc function
.code malloc

	mov	eax, [@_heap_start]
repeat:	mov	ebx, eax
	add	ebx, [esp + 4]
	jc	dword @abort
	lock cmpxchg	[@_heap_start], ebx
	jnz	repeat
	ret

; heap start
.data _heap_start

	.alignment	4
	.reserve	4

; standard putchar function
.code putchar

base:	.equals	0x000b8000
width:	.equals	80
height:	.equals	25

	mov	ebx, [@_cursor]
	cmp	ebx, width * height
	jne	skip_scroll
	cld
	mov	esi, base + width * 2
	mov	edi, base
	mov	ecx, width * height
	rep movsw
	mov	ax, 0x0720
	mov	ecx, width
	rep stosw
	sub	ebx, width
skip_scroll:
	mov	ah, 0x07
	mov	al, [esp + 4]
	cmp	al, '\n'
	je	newline
	mov	[ebx * 2 + base], ax
	inc	ebx
	mov	[@_cursor], ebx
	ret
newline:
	mov	eax, ebx
	xor	edx, edx
	mov	ebx, width
	div	ebx
	sub	ebx, edx
	add	[@_cursor], ebx
	ret

; cursor position
.data _cursor

	.alignment	4
	.qbyte	0

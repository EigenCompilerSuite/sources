; ATmega328 runtime support
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
.code _init_cpu

	.required
	.origin	0x0000

	; initialize SRAM
SRAM:	.equals	2048

	clr	r16
	ldi	r26, extent (@_reserved) >> 0
	ldi	r27, extent (@_reserved) >> 8
	ldi	r28, SRAM >> 0 & 0xff
	ldi	r29, SRAM >> 8 & 0xff
repeat:	st	X+, r16
	sbiw	r29:r28, 1
	cpi	r28, 0
	cpc	r29, r16
	brne	repeat

	; set stack pointer
	ldi	r16, size (@_reserved) + SRAM - 1 >> 0
	out	SPL, r16
	ldi	r16, size (@_reserved) + SRAM - 1 >> 8
	out	SPH, r16

; USART initialization
.initdata _init_usart

	; oscillator frequency
FOSC:	.equals	16000000

	; USART configuration
BAUD:	.equals	115200
DATA:	.equals	8
PARITY:	.equals	'N'
STOP:	.equals	1

UBRRL:	.equals	0xc4
UBRRH:	.equals	0xc5

UCSRA:	.equals	0xc0
U2X0:	.equals	1

UCSRB:	.equals	0xc1
RXEN:	.equals	4
TXEN:	.equals	3

UCSRC:	.equals	0xc2
UMSEL1:	.equals	7
UMSEL0:	.equals	6
UPM:	.equals	4
USBS:	.equals	3
UCSZ0:	.equals	1

	; double transmission speed
	ldi	r16, 1 << U2X0
	sts	UCSRA, r16

	; set baud rate
	ldi	r16, FOSC / (8 * BAUD) - 1 >> 0 & 0xff
	sts	UBRRL, r16
	ldi	r16, FOSC / (8 * BAUD) - 1 >> 8 & 0xff
	sts	UBRRH, r16

	; set frame format (asynchronous normal mode)
	.assert	STOP == 1 || STOP == 2
	.assert	DATA >= 5 && DATA <= 8
	.assert	PARITY == 'N' || PARITY == 'O' || PARITY == 'E'
	ldi	r16, 1 << UMSEL1 | 0 << UMSEL0 | (2 * (PARITY != 'N') + (PARITY == 'O')) << UPM | (STOP == 2) << USBS | (DATA - 5) << UCSZ0
	sts	UCSRC, r16

	; enable receiver and transmitter
	ldi	r16, 1 << RXEN | 1 << TXEN
	sts	UCSRB, r16

; environment name
.const _environment

	.byte	"ATmega328", 0

; CPU shut-down
.code _shutdown

	cli
	sleep

; reserved register file and I/O memory
.data _reserved

	.origin	0x0000
	.reserve	0x100

; standard abort function
.code abort

	.replaceable
	rjmp	@_shutdown

; standard _Exit function
.code _Exit

	.replaceable
	rjmp	@_shutdown

; standard free function
.code free

	ret

; standard getchar function
.code getchar

	.require	_init_usart

UCSRA:	.equals	0xc0
RXC:	.equals	7

UDR:	.equals	0xc6

	; wait for data to be received
repeat:	lds	r16, UCSRA
	sbrs	r16, RXC
	rjmp	repeat

	; get and return received data from buffer
	lds	r0, UDR
	ret

; standard malloc function
.code malloc
	ldi	RXL, @_heapsize + 2 >> 0
	ldi	RXH, @_heapsize + 2 >> 8
	ld	r16, -X
	ld	r17, -X
	in	RYL, SPL
	in	RYH, SPH
	ldd	r18, Y+4
	ldd	r19, Y+3
	add	r18, r16
	adc	r19, r17
	cpi	r18, size (@_heap) >> 0
	ldi	r20, size (@_heap) >> 8
	cpc	r19, r20
	brsh	fail
succ:	st	X+, r19
	st	X+, r18
	movw	r1:r0, r17:r16
	ldi	r16, @_heap >> 0
	ldi	r17, @_heap >> 8
	add	r0, r16
	adc	r1, r17
	ret
fail:	clr	r0
	clr	r1
	ret

; reserved heap space
.data _heap
	.reserve	1024

; current size of occupied heap space
.data _heapsize
	.reserve	2
	.require	_init_heapsize

.initdata _init_heapsize
	clr	r16
	sts	@_heapsize + 0, r16
	sts	@_heapsize + 1, r16

; standard putchar function
.code putchar

	.require	_init_usart

UCSRA:	.equals	0xc0
UDRE:	.equals	5

UDR:	.equals	0xc6

	in	RYL, SPL
	in	RYH, SPH
	ldd	r16, Y+4

	; wait for empty transmit buffer
repeat:	lds	r17, UCSRA
	sbrs	r17, UDRE
	rjmp	repeat

	; put and send data in buffer
	sts	UDR, r16
	ret

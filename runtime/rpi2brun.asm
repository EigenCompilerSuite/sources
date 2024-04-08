; Raspberry Pi 2 Model B runtime support
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
	.origin	0x00008000
	mov	sp, .origin

; ARM tags
.data _atags
	.alignment	4
	.reserve	4
	.require	_init_atags

.initdata _init_atags
	ldr	r0, [pc, offset (atags)]
	str	r2, [r0, 0]
	b	skip
atags:	.qbyte	@_atags
skip:

; UART initialization
.initdata _init_uart

UART:	.equals	0x3f201000
IBRD:	.equals	0x24
FBRD:	.equals	0x28
LCRH:	.equals	0x2c
PEN:	.equals	1
STP2:	.equals	3
FEN:	.equals	4
WLEN:	.equals	5
CR:	.equals	0x30
UARTEN:	.equals	0
TXE:	.equals	8
RXE:	.equals	9
IMSC:	.equals	0x38
ICR:	.equals	0x44
BAUDRATE:	.equals	115200
FUARTCLK:	.equals	3000000

GPIO:	.equals	0x3f200000
GPPUD:	.equals	0x94
PUD:	.equals	0
GPPUDCLK0:	.equals	0x98

	; disable UART
	ldr	r0, [pc, offset (uart)]
	mov	r2, 0 << UARTEN
	str	r2, [r0, CR]

	; disable pull up/down for all GPIO pins & delay for 150 cycles
	ldr	r1, [pc, offset (gpio)]
	mov	r2, 0 << PUD
	str	r2, [r1, GPPUD]
	mov	r3, 150
delay1:	subs	r3, r3, 1
	bne	delay1

	; disable pull up/down for pin 14 and 15 & delay for 150 cycles
	mov	r2, 1 << 14 | 1 << 15
	str	r2, [r1, GPPUDCLK0]
	mov	r3, 150
delay2:	subs	r3, r3, 1
	bne	delay2

	; write 0 to GPPUDCLK0 to make it take effect
	mov	r2, 0
	str	r2, [r1, GPPUDCLK0]

	; clear pending interrupts
	ldr	r2, [pc, offset (icr)]
	str	r2, [r0, ICR]

	; set integer & fractional part of baud rate
	mov	r2, FUARTCLK / (16 * BAUDRATE)
	str	r2, [r0, IBRD]
	mov	r2, (FUARTCLK % (16 * BAUDRATE) << 6) / (16 * BAUDRATE)
	str	r2, [r0, FBRD]

	; enable FIFO, 8 bit data transmission, 1 stop bit, no parity
	mov	r2, 0b11 << WLEN | 1 << FEN | 0 << STP2 | 0 << PEN
	str	r2, [r0, LCRH]

	; unmask all interrupts
	mov	r2, 0b000'0000'0000
	str	r2, [r0, IMSC]

	; enable UART
	ldr	r2, [pc, offset (cr)]
	str	r2, [r0, CR]

	b	skip
uart:	.qbyte	UART
gpio:	.qbyte	GPIO
cr:	.qbyte	1 << RXE | 1 << TXE | 1 << UARTEN
icr:	.qbyte	0b111'1111'0010
skip:

; last section
.trailer _trailer

	.required
	.alignment	4

; environment name
.const _environment

	.byte	"Raspberry Pi 2 Model B", 0

; standard abort function
.code abort

	mov	r0, 0
	mcr	p15, 0, r0, c7, c0, 4

; standard _Exit function
.code _Exit

	mov	r0, 0
	mcr	p15, 0, r0, c7, c0, 4

; standard free function
.code free

	bx	lr

; standard getchar function
.code getchar

	.require	_init_uart

UART:	.equals	0x3f201000
DR:	.equals	0x0
FR:	.equals	0x18
RXFE:	.equals	4

	ldr	r2, [pc, offset (uart)]
wait:	ldr	r3, [r2, FR]
	tst	r3, 1 << RXFE
	bne	wait
	ldrb	r0, [r2, DR]
	bx	lr

uart:	.qbyte	UART

; standard malloc function
.code malloc

	ldr	r2, [pc, offset (heap)]
	ldr	r0, [r2, 0]
	ldr	r3, [sp, 0]
	add	r3, r3, r0
	str	r3, [r2, 0]
	bx	lr

heap:	.qbyte	@_heap_start

; heap start
.data _heap_start

	.alignment	4
	.qbyte	@_trailer

; standard putchar function
.code putchar

	.require	_init_uart

UART:	.equals	0x3f201000
DR:	.equals	0x0
FR:	.equals	0x18
TXFF:	.equals	5

	ldr	r2, [pc, offset (uart)]
wait:	ldr	r3, [r2, FR]
	tst	r3, 1 << TXFF
	bne	wait
	ldrb	r3, [sp, 0]
	str	r3, [r2, DR]
	bx	lr

uart:	.qbyte	UART

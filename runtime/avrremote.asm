; AVR remote execution support
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

; synchronize connection with host
.initdata _synchronize

	.required

	; await and echo received data
	call	@getchar
	push	r0
	push	r1
	call	@putchar
	pop	r1
	pop	r0

; specialized abort function
.code abort

	; send default exit code
	ldi	r16, 1
	push	r16
	clr	r16
	push	r16
	call	@putchar

	jmp	@_shutdown

; specialized exit function
.code _Exit

	; send exit code
	pop	r16
	pop	r16
	call	@putchar

	jmp	@_shutdown

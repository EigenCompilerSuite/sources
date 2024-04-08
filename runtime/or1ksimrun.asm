; OpenRISC 1000 simulator runtime support
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

; COFF file format
.header _header

	.required
entry:	.equals	0x100

file_header:
	.dbyte	0x17a	; f_magic
	.dbyte	3	; f_nscns
	.qbyte	0	; f_timdat
	.qbyte	0	; f_symptr
	.qbyte	0	; f_nsyms
	.dbyte	28	; f_opthdr
	.dbyte	2	; f_flags

optional_header:
	.dbyte	0	; magic
	.dbyte	0	; vstamp
	.qbyte	0	; tsize
	.qbyte	0	; dsize
	.qbyte	0	; bsize
	.qbyte	0	; entry
	.qbyte	0	; text_start
	.qbyte	0	; data_start

text_section:
	.byte	".text"	; s_name
	.pad	text_section + 8
	.qbyte	entry	; s_paddr
	.qbyte	entry	; s_vaddr
	.qbyte	@_trailer - entry	; s_size
	.qbyte	initialisation	; s_scnptr
	.qbyte	0	; s_relptr
	.qbyte	0	; s_lnnoptr
	.dbyte	0	; s_nreloc
	.dbyte	0	; s_nlnno
	.qbyte	0	; s_flags

data_section:
	.byte	".text"	; s_name
	.pad	data_section + 8
	.reserve	32

bss_section:
	.byte	".bss"	; s_name
	.pad	bss_section + 8
	.reserve	32

initialisation:
	l.add	r0, r0, r0
	l.movhi	r1, 0x100000 >> 16

	.origin	entry - initialisation

.trailer _trailer

	.alignment	4

.const _extension

	.byte	""

; environment name
.const _environment

	.byte	"OpenRISC 1000 simulator", 0

; standard abort function
.code abort

	.replaceable
	l.addi	r3, r0, 1
	l.nop	1

; standard _Exit function
.code _Exit

	.replaceable
	l.lws	r3, 0 (r1)
	l.nop	1

; standard free function
.code free

	l.jr	r9
	l.nop	0

; standard getchar function
.code getchar

	l.lws	r3, 0 (r1)
	l.nop	4
	l.jr	r9
	l.addi	r11, r0, -1

; standard malloc function
.code malloc

	l.movhi	r3, @_heap_start >> 16
	l.ori	r3, r3, @_heap_start
	l.lwz	r11, 0 (r3)
	l.lwz	r4, 0 (r1)
	l.add	r4, r11, r4
	l.jr	r9
	l.sw	0 (r3), r4

; heap start
.data _heap_start

	.alignment	4
	.qbyte	@_trailer

; standard putchar function
.code putchar

	l.lws	r3, 0 (r1)
	l.nop	4
	l.jr	r9
	l.add	r11, r0, r3

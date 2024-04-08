; ARM T32 FPE Linux runtime support
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

; ELF file format
.header _header

	.required
	.origin	0x00008000

	.byte	0x7f, "ELF", 1, 1, 1, 0	; e_ident
	.pad	16
	.dbyte	2	; e_type
	.dbyte	40	; e_machine
	.qbyte	1	; e_version
	.qbyte	extent (@_program_headers) + 1	; e_entry
	.qbyte	@_program_headers - .origin	; e_phoff
	.qbyte	@_section_headers?_section_headers:_header - .origin	; e_shoff
	.qbyte	0x5000000	; e_flags
	.dbyte	52	; e_ehsize
	.dbyte	32	; e_phentsize
	.dbyte	count (@_program_headers)	; e_phnum
	.dbyte	40	; e_shentsize
	.dbyte	count (@_section_headers?_section_headers)	; e_shnum
	.dbyte	index (@_strtab_header?_strtab_header)	; e_shstrndx

.trailer _trailer

.const _extension

	.byte	""

; environment name
.const _environment

	.byte	"ARM T32 FPE Linux", 0

; program headers
.header _program_header

	.required
base:	.equals	0x00008000
	.group	_program_headers

	.alignment	4
	.qbyte	1	; p_type
	.qbyte	0	; p_offset
	.qbyte	base	; p_vaddr
	.qbyte	base	; p_paddr
	.qbyte	@_trailer - base	; p_filesz
	.qbyte	@_trailer - base	; p_memsz
	.qbyte	7	; p_flags
	.qbyte	0x1000	; p_align

.header _interpreter_header

base:	.equals	0x00008000
	.group	_program_headers

	.alignment	4
	.qbyte	3	; p_type
	.qbyte	@_interpreter_name - base	; p_offset
	.qbyte	@_interpreter_name	; p_vaddr
	.qbyte	@_interpreter_name	; p_paddr
	.qbyte	size (@_interpreter_name)	; p_filesz
	.qbyte	size (@_interpreter_name)	; p_memsz
	.qbyte	4	; p_flags
	.qbyte	1	; p_align

.header _dynamic_header

base:	.equals	0x00008000
	.group	_program_headers
	.require	_interpreter_header

	.alignment	4
	.qbyte	2	; p_type
	.qbyte	@_dynamic_section - base	; p_offset
	.qbyte	@_dynamic_section	; p_vaddr
	.qbyte	@_dynamic_section	; p_paddr
	.qbyte	size (@_dynamic_section) + 8	; p_filesz
	.qbyte	size (@_dynamic_section) + 8	; p_memsz
	.qbyte	6	; p_flags
	.qbyte	4	; p_align

; section headers
.const _null_header

	.group	_section_headers
	.alignment	4
	.reserve	40

#define section

	; section header
	.const _#0_header

	base:	.equals	0x00008000
		.group	_section_headers
		.require	_#1_header

		.alignment	4
		.qbyte	position (@_.#0_string) + 1	; sh_name
		.qbyte	#2	; sh_type
		.qbyte	#3	; sh_flags
		.qbyte	#4	; sh_addr
		.qbyte	#5	; sh_offset
		.qbyte	#6	; sh_size
		.qbyte	0	; sh_link
		.qbyte	0	; sh_info
		.qbyte	1	; sh_addralign
		.qbyte	0	; sh_entsize

	; string table entry
	.const _.#0_string

		.duplicable
		.group	_string_table

		.byte	".#0", 0

#enddef

	section	debug_abbrev, text, 1, 0, 0, @_debug_abbrev_section - base, size (@_debug_abbrev_section) + 1
	section	debug_info, text, 1, 0, 0, @_debug_info_section - base, size (@_debug_info_section)
	section	debug_line, text, 1, 0, 0, @_debug_line_section - base, size (@_debug_line_section)
	section	strtab, null, 3, 0, 0, @_string_table_begin - base, size (@_string_table) + 1
	section text, strtab, 1, 7, base, 0, @_trailer - base

#undef section

; system call wrappers
#define system_call

	.code #0
		#if #2 > 0
			ldr	r0, [sp, 0]
		#endif
		#if #2 > 1
			ldr	r1, [sp, 4]
		#endif
		#if #2 > 2
			ldr	r2, [sp, 8]
		#endif
		#if #2 > 3
			ldr	r3, [sp, 12]
		#endif
		mov	r7, #1
		svc	0
		bx	lr

#enddef

	system_call	sys_brk, 45, 1
	system_call	sys_clock_getres, 264, 2
	system_call	sys_clock_gettime, 263, 2
	system_call	sys_clone, 120, 5
	system_call	sys_close, 6, 1
	system_call	sys_exit, 1, 1
	system_call	sys_exit_group, 248, 1
	system_call	sys_futex, 240, 6
	system_call	sys_getpid, 20, 0
	system_call	sys_gettid, 224, 0
	system_call	sys_lseek, 19, 3
	system_call	sys_nanosleep, 162, 2
	system_call	sys_open, 5, 3
	system_call	sys_read, 3, 3
	system_call	sys_rename, 38, 2
	system_call	sys_sched_getaffinity, 242, 3
	system_call	sys_sched_setaffinity, 241, 3
	system_call	sys_time, 13, 1
	system_call	sys_times, 43, 1
	system_call	sys_unlink, 10, 1
	system_call	sys_waitid, 280, 5
	system_call	sys_write, 4, 3

#undef system_call

; interpreter for dynamic linking
.const _interpreter_name

	.byte	"/lib/ld-linux-armhf.so.3", 0

; string table for dynamic linking
.const _string_table_begin

	.group	_string_tab

	.alignment	4
	.byte	0

; section for dynamic linking
.const _dynamic_section_begin

	.group	_dynamic_section
	.require	_dynamic_header

	.alignment	4
	.qbyte	5, @_string_table_begin	; DT_STRTAB
	.qbyte	6, @_symbol_table_begin	; DT_SYMTAB
	.qbyte	7, @_relocation_table	; DT_RELA
	.qbyte	8, size (@_relocation_table)	; DT_RELASZ
	.qbyte	9, 0xc	; DT_RELAENT
	.qbyte	10, size (@_string_table) + 1	; DT_STRSZ
	.qbyte	11, 0x10	; DT_SYMENT

.const _dynamic_section_sentinel

	.group	_dynamic_section_end
	.require	_dynamic_section_begin

	.alignment	4
	.qbyte	0, 0	; DT_NULL

; symbol table for dynamic linking
.const _symbol_table_begin

	.group	_symbol_tab

	.alignment	4
	.qbyte	0	; st_name
	.qbyte	0	; st_value
	.qbyte	0	; st_size
	.byte	0	; st_info
	.byte	0	; st_other
	.dbyte	0	; st_shndx

; imported libraries
#define library

	; dynamic section entry
	.const _dynamic_section_#0

		.duplicable
		.group	_dynamic_section
		.require	_dynamic_section_sentinel

		.alignment	4
		.qbyte	1, position (@_#0_string) + 1	; DT_NEEDED

	; string table entry
	.const _#0_string

		.duplicable
		.group	_string_table

		.byte	#1, 0

#enddef

; function call wrappers
#repeat 7

	.code _function_call_wrapper##

		#if ## > 0
			ldr	r0, [sp, 0]
		#endif
		#if ## > 1
			ldr	r1, [sp, 4]
		#endif
		#if ## > 2
			ldr	r2, [sp, 8]
		#endif
		#if ## > 3
			ldr	r3, [sp, 12]
		#endif
		#if ## > 4
			add	sp, sp, ## * 4
		#endif
		mov	r9, lr
		ldr	r10, [r4, 0]
		blx	r10
		#if ## > 4
			sub	sp, sp, ## * 4
		#endif
		bx	r9

#endrep

; imported library functions
#define function

	; symbol table entry
	.const _#1_symbol

		.duplicable
		.group	_symbol_table
		.require	_dynamic_section_#0

		.alignment	4
		.qbyte	position (@_#1_string) + 1	; st_name
		.qbyte	0	; st_value
		.qbyte	0	; st_size
		.byte	0x12	; st_info
		.byte	0x0	; st_other
		.dbyte	0	; st_shndx

	; string table entry
	.const _#1_string

		.duplicable
		.group	_string_table

		.byte	"#1", 0

	; relocation table entry
	.const _#1_relocation

		.duplicable
		.group	_relocation_table

		.alignment	4
		.qbyte	@_#1	; r_offset
		.byte	2	; r_info
		.tbyte	index (@_#1_symbol) + 1
		.qbyte	0	; r_addend

	; function address
	.const _#1

		.duplicable
		.require	_#1_relocation

		.alignment	4
		.reserve	4

	; function wrapper
	.code #1

		.duplicable
		.alignment	4
		ldr	r4, [pc, offset (adr)]
		b.w	@_function_call_wrapper#2
	adr:	.qbyte	@_#1

#enddef

	library	libc, "libc.so.6"

	; imported functions from libc
	function	libc, free, 1
	function	libc, malloc, 1
	function	libc, realloc, 2

#undef library
#undef function

; standard abort function
.code abort

	mov	r0, 1
	mov	r7, 248
	svc	0	; sys_exit_group

; standard _Exit function
.code _Exit

	ldr	r0, [sp, 0]
	mov	r7, 1
	svc	0	; sys_exit

; standard fgetc function
.code fgetc

	push	{r0}
	ldr	r0, [sp, 4]
	mov	r1, sp
	mov	r2, 1
	mov	r7, 3
	svc	0	; sys_read
	pop	{r0}
	bx	lr

; standard fputc function
.code fputc

	ldr	r0, [sp, 4]
	mov	r1, sp
	mov	r2, 1
	mov	r7, 4
	svc	0	; sys_write
	bx	lr

; standard stderr variable
.const stderr

	.alignment	4
	.qbyte	2

; standard stdin variable
.const stdin

	.alignment	4
	.qbyte	0

; standard stdout variable
.const stdout

	.alignment	4
	.qbyte	1

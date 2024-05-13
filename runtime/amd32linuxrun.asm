; AMD32 Linux runtime support
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
	.origin	0x08048000
	.assert	.bitmode == 32

	.byte	0x7f, "ELF", 1, 1, 1, 0	; e_ident
	.pad	16
	.dbyte	2	; e_type
	.dbyte	3	; e_machine
	.qbyte	1	; e_version
	.qbyte	extent (@_program_headers)	; e_entry
	.qbyte	@_program_headers - .origin	; e_phoff
	.qbyte	@_section_headers?_section_headers:_header - .origin	; e_shoff
	.qbyte	0	; e_flags
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

	.byte	"x86 Linux 32-bit", 0

; program headers
.header _program_header

	.required
base:	.equals	0x08048000
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

base:	.equals	0x08048000
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

base:	.equals	0x08048000
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

	base:	.equals	0x08048000
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
#repeat 7

	.code _system_call_wrapper##

		#if ## > 0
			mov	ebx, [esp + 4]
		#endif
		#if ## > 1
			mov	ecx, [esp + 8]
		#endif
		#if ## > 2
			mov	edx, [esp + 12]
		#endif
		#if ## > 3
			mov	esi, [esp + 16]
		#endif
		#if ## > 4
			mov	edi, [esp + 20]
		#endif
		#if ## > 5
			push	ebp
			mov	ebp, [esp + 28]
		#endif
		int	80h
		#if ## > 5
			pop	ebp
		#endif
		ret

#endrep

; wrappers for system calls
#define system_call

	.code #0
		mov	eax, #1
		jmp	dword @_system_call_wrapper#2

#enddef

	system_call	sys_brk, 45, 1
	system_call	sys_clock_getres, 266, 2
	system_call	sys_clock_gettime, 265, 2
	system_call	sys_clone, 120, 5
	system_call	sys_close, 6, 1
	system_call	sys_exit, 1, 1
	system_call	sys_exit_group, 252, 1
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
	system_call	sys_waitid, 284, 5
	system_call	sys_write, 4, 3

#undef system_call

; interpreter for dynamic linking
.const _interpreter_name

	.byte	"/lib/ld-linux.so.2", 0

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

.code _function_call_wrapper

	pop	ebx
	call	eax
	jmp	ebx

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
		.byte	1	; r_info
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
		mov	eax, [@_#1]
		jmp	dword @_function_call_wrapper

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

	.replaceable
	mov	eax, 252
	mov	ebx, 1
	int	80h	; sys_exit_group

; standard argc variable
.data _argc

	.alignment	4
	.reserve	4
	.require	_init_argc

; initialize argc variable
.initdata _init_argc

	mov	eax, [esp]
	mov	[@_argc], eax

; standard argv variable
.data _argv

	.alignment	4
	.reserve	4
	.require	_init_argv

; initialize argv variable
.initdata _init_argv

	lea	eax, [esp + 4]
	mov	[@_argv], eax

; standard env variable
.data _env

	.alignment	4
	.reserve	4
	.require	_init_env

; initialize env variable
.initdata _init_env

	mov	eax, [esp]
	lea	eax, [esp + eax * 4 + 8]
	mov	[@_env], eax

; standard clock function
.code clock

	sub	esp, 16
	mov	eax, 43
	mov	ebx, esp
	int	80h	; sys_times
	add	esp, 16
	mov	ebx, 10
	mul	ebx
	sub	eax, [@_initial_clock]
	ret

; initial clock
.data _initial_clock

	.alignment	4
	.reserve	4
	.require	_init_initial_clock

; retrieve initial clock
.initdata _init_initial_clock

	sub	esp, 16
	mov	eax, 43
	mov	ebx, esp
	int	80h	; sys_times
	add	esp, 16
	mov	ebx, 10
	mul	ebx
	mov	[@_initial_clock], eax

; standard _Exit function
.code _Exit

	.replaceable
	mov	eax, 1
	mov	ebx, [esp + 4]
	int	80h	; sys_exit

; standard fclose function
.code fclose

	mov	eax, 6
	mov	ebx, [esp + 4]
	int	80h	; sys_close
	ret

; standard fgetc function
.code fgetc

	push	0
	mov	eax, 3
	mov	ebx, [esp + 8]
	mov	ecx, esp
	mov	edx, 1
	int	80h	; sys_read
	pop	ebx
	cmp	eax, 1
	jne	fail
	mov	eax, ebx
	ret
fail:	mov	eax, -1
	ret

; standard fopen function
.code fopen

	mov	eax, 5
	mov	ebx, [esp + 4]
	mov	ecx, [esp + 8]
	cmp	byte [ecx], 'w'
	mov	ecx, 0
	jne	skip
	mov	ecx, 01 + 0100
skip:	mov	edx, 04 + 040 + 0200 + 0400
	int	80h	; sys_open
	cmp	eax, -1
	je	fail
	ret
fail:	mov	eax, 0
	ret

; standard fputc function
.code fputc

	mov	eax, 4
	mov	ebx, [esp + 8]
	lea	ecx, [esp + 4]
	mov	edx, 1
	int	80h	; sys_write
	cmp	eax, 1
	jne	fail
	mov	eax, [esp + 4]
	ret
fail:	mov	eax, 0
	ret

; standard fread function
.code fread

	mov	eax, 3
	mov	ebx, [esp + 16]
	mov	ecx, [esp + 4]
	mov	edx, [esp + 12]
	int	80h	; sys_read
	ret

; standard fwrite function
.code fwrite

	mov	eax, 4
	mov	ebx, [esp + 16]
	mov	ecx, [esp + 4]
	mov	edx, [esp + 12]
	int	80h	; sys_write
	ret

; standard getenv function
.code getenv

	mov	edi, [@_env]
loop:	mov	eax, [edi]
	cmp	eax, 0
	je	end
	mov	esi, [esp + 4]
comp:	mov	bl, [eax]
	cmp	bl, 0
	je	skip
	mov	dl, [esi]
	cmp	bl, dl
	je	next
	cmp	dl, 0
	jne	skip
	cmp	bl, '='
	jne	skip
	inc	eax
	jmp	end
next:	inc	eax
	inc	esi
	jmp	comp
skip:	add	edi, 4
	jmp	loop
end:	ret

; standard remove function
.code remove

	mov	eax, 10
	mov	ebx, [esp + 4]
	int	80h	; sys_unlink
	ret

; standard rename function
.code rename

	mov	eax, 38
	mov	ebx, [esp + 4]
	mov	ecx, [esp + 8]
	int	80h	; sys_rename
	ret

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

; standard time function
.code time

	mov	eax, 13
	mov	ebx, [esp + 4]
	int	80h	; sys_time
	ret

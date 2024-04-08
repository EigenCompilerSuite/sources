; OS X 64-bit runtime support
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

; Mach object file format
.header _header

	.required
	.origin	0x1000
	.assert	.bitmode == 64

	.qbyte	0xfeedfacf	; magic
	.qbyte	0x01000007	; cputype
	.qbyte	0x80000003	; cpusubtype
	.qbyte	2	; filetype
	.qbyte	count (@_commands)	; ncmds
	.qbyte	size (@_commands)	; sizeofcmds
	.qbyte	0x1	; flags
	.qbyte	0	; reserved

.trailer _trailer

	.alignment	0x1000

.const _extension

	.byte	""

; environment name
.const _environment

	.byte	"OS X 64-bit", 0

; load commands
.header _pagezero_command

	.required
	.group	_commands

	.alignment	8
	.qbyte	25	; cmd
	.qbyte	size	; cmdsize
	.byte	"__PAGEZERO"	; segname
	.pad	24
	.obyte	0x0	; vmaddr
	.obyte	0x1000	; vmsize
	.obyte	0	; fileoff
	.obyte	0	; filesize
	.qbyte	0	; maxprot
	.qbyte	0	; initprot
	.qbyte	0	; nsects
	.qbyte	0	; flags
size:

.header _text_segment_command

	.required
	.group	_commands

	.alignment	8
	.qbyte	25	; cmd
	.qbyte	size	; cmdsize
	.byte	"__TEXT"	; segname
	.pad	24
	.obyte	0x1000	; vmaddr
	.obyte	@_symbol_table?_symbol_table:_trailer - 0x1000	; vmsize
	.obyte	0	; fileoff
	.obyte	@_symbol_table?_symbol_table:_trailer - 0x1000	; filesize
	.qbyte	7	; maxprot
	.qbyte	7	; initprot
	.qbyte	0	; nsects
	.qbyte	0	; flags
size:

.header _linkedit_segment_command

	.required
	.group	_commands

	.alignment	8
	.qbyte	25	; cmd
	.qbyte	size	; cmdsize
	.byte	"__LINKEDIT"	; segname
	.pad	24
	.obyte	@_symbol_table?_symbol_table:_trailer	; vmaddr
	.obyte	size (@_symbol_table?_symbol_table:_trailer)	; vmsize
	.obyte	@_symbol_table?_symbol_table:_trailer - 0x1000	; fileoff
	.obyte	size (@_symbol_table?_symbol_table:_trailer)	; filesize
	.qbyte	7	; maxprot
	.qbyte	7	; initprot
	.qbyte	0	; nsects
	.qbyte	0	; flags
size:

.header _thread_command

	.required
	.group	_commands

	.alignment	8
	.qbyte	5	; cmd
	.qbyte	size	; cmdsize
	.qbyte	4	; flavor
	.qbyte	(size - state) / 4	; count
state:	.obyte	0	; rax
	.obyte	0	; rbx
	.obyte	0	; rcx
	.obyte	0	; rdx
	.obyte	0	; rdi
	.obyte	0	; rsi
	.obyte	0	; rbp
	.obyte	0	; rsp
	.obyte	0	; r8
	.obyte	0	; r9
	.obyte	0	; r10
	.obyte	0	; r11
	.obyte	0	; r12
	.obyte	0	; r13
	.obyte	0	; r14
	.obyte	0	; r15
	.obyte	@_last_command	; eip
	.obyte	0	; rflags
	.obyte	0	; cs
	.obyte	0	; fs
	.obyte	0	; gs
size:

.header _dylinker_command

	.group	_commands

	.alignment	8
	.qbyte	14	; cmd
	.qbyte	size	; cmdsize
	.qbyte	name	; name
name:	.byte	"/usr/lib/dyld", 0
	.align	8
size:

.header _symtab_command

	.group	_commands
	.require	_dylinker_command

	.alignment	8
	.qbyte	2	; cmd
	.qbyte	size	; cmdsize
	.qbyte	@_symbol_table_begin - 0x1000	; symoff
	.qbyte	count (@_symbol_table)	; nsyms
	.qbyte	@_text_table_begin - 0x1000	; stroff
	.qbyte	size (@_text_table) + 1	; strsize
size:

.header _dysymtab_command

	.group	_commands
	.require	_symtab_command

	.alignment	8
	.qbyte	11	; cmd
	.qbyte	size	; cmdsize
	.qbyte	0	; ilocalsym
	.qbyte	0	; nlocalsym
	.qbyte	0	; iextdefsym
	.qbyte	0	; nextdefsym
	.qbyte	0	; iundefsym
	.qbyte	count (@_symbol_table)	; nundefsym
	.qbyte	0	; tocoff
	.qbyte	0	; ntoc
	.qbyte	0	; modtaboff
	.qbyte	0	; nmodtab
	.qbyte	0	; extrefsymoff
	.qbyte	0	; nextrefsyms
	.qbyte	0	; indirectsymoff
	.qbyte	0	; nindirectsyms
	.qbyte	@_relocations - 0x1000	; extreloff
	.qbyte	count (@_relocations)	; nextrel
	.qbyte	0	; locreloff
	.qbyte	0	; nlocrel
size:

.header _section_command

	.group	_commands

	.alignment	8
	.qbyte	25	; cmd
	.qbyte	size (@_commands_sections) + size	; cmdsize
	.byte	""	; segname
	.pad	24
	.obyte	0	; vmaddr
	.obyte	size (@_commands_sections)	; vmsize
	.obyte	@_commands_sections - 0x1000	; fileoff
	.obyte	size (@_commands_sections)	; filesize
	.qbyte	7	; maxprot
	.qbyte	7	; initprot
	.qbyte	count (@_commands_sections)	; nsects
	.qbyte	0	; flags
size:

#define section

	.header _#0_header

		.group	_commands_sections
		.require	_section_command

		.alignment	8
		.byte	"__#0"	; sectname
		.pad	16
		.byte	""	; segname
		.pad	32
		.obyte	0	; addr
		.obyte	size (@_#0_section) + #1	; size
		.qbyte	@_#0_section - 0x1000	; offset
		.qbyte	0	; align
		.qbyte	0	; reloff
		.qbyte	0	; nreloc
		.qbyte	0x2000000	; flags
		.qbyte	0	; reserved1
		.qbyte	0	; reserved2
		.qbyte	0	; reserved3

#enddef

	section	debug_abbrev, 1
	section	debug_info, 0
	section	debug_line, 0

#undef section

.header _last_command

	.group	_commands_stop
	.alignment	8

; system call wrappers
#repeat 7

	.code _system_call_wrapper##

		#if ## > 0
			mov	rdi, [rsp + 8]
		#endif
		#if ## > 1
			mov	rsi, [rsp + 16]
		#endif
		#if ## > 2
			mov	rdx, [rsp + 24]
		#endif
		#if ## > 3
			mov	r10, [rsp + 32]
		#endif
		#if ## > 4
			mov	r8, [rsp + 40]
		#endif
		#if ## > 5
			mov	r9, [rsp + 48]
		#endif
		syscall
		ret

#endrep

; wrappers for system calls
#define system_call

	.code #0
		mov	eax, 0x2000000 | #1
		jmp	dword @_system_call_wrapper#2

#enddef

	system_call	sys_brk, 45, 1
	system_call	sys_close, 6, 1
	system_call	sys_exit, 1, 1
	system_call	sys_open, 5, 3
	system_call	sys_read, 3, 3
	system_call	sys_rename, 128, 2
	system_call	sys_unlink, 10, 1
	system_call	sys_write, 4, 3

#undef system_call

; imported libraries
#define library

	; load command
	.header _dylib_command_#0

		.duplicable
		.group	_commands
		.require	_dysymtab_command

		.alignment	8
		.qbyte	12	; cmd
		.qbyte	size	; cmdsize
		.qbyte	name	; name
		.qbyte	0	; timestamp
		.qbyte	0	; current_version
		.qbyte	0	; compatibility_version
	name:	.byte	#1, 0
		.align	8
	size:

#enddef

.trailer _symbol_table_begin

	.group	_symbol_tab

	.alignment	0x1000

.trailer _text_table_begin

	.group	_text_tab

	.alignment	8
	.byte	0

; function call wrappers
#repeat 7

	.code _function_call_wrapper##

		pop	rbx
		#if ## > 0
			mov	rdi, [rsp]
		#endif
		#if ## > 1
			mov	rsi, [rsp + 8]
		#endif
		#if ## > 2
			mov	rdx, [rsp + 16]
		#endif
		#if ## > 3
			mov	rcx, [rsp + 24]
		#endif
		#if ## > 4
			mov	r8, [rsp + 32]
		#endif
		#if ## > 5
			mov	r9, [rsp + 40]
		#endif
		mov	r12, rsp
		and	rsp, ~1111b
		call	rax
		mov	rsp, r12
		jmp	rbx

#endrep

; imported library functions
#define function

	; symbol table entry
	.trailer _#1_symbol

		.duplicable
		.group	_symbol_table
		.require	_dylib_command_#0

		.alignment	8
		.qbyte	position (@_#1_text) + 1	; n_strx
		.byte	1	; n_type
		.byte	0	; n_sect
		.dbyte	0	; n_desc
		.obyte	0	; n_value

	; text table entry
	.trailer _#1_text

		.duplicable
		.group	_text_table

		.byte	"_#1", 0

	; relocation entry
	.const _#1_relocation

		.duplicable
		.group	_relocations

		.alignment	4
		.qbyte	@_#1 - 0x1000
		.tbyte	index (@_#1_symbol)
		.byte	0xe

	; function address
	.const _#1

		.duplicable
		.require	_#1_relocation

		.alignment	8
		.reserve	8

	; function wrapper
	.code #1

		.duplicable
		mov	rax, [rip + @_#1]
		jmp	dword @_function_call_wrapper#2

#enddef

	library	libc, "/usr/lib/libSystem.B.dylib"

	; imported functions from libc
	function	libc, free, 1
	function	libc, malloc, 1
	function	libc, realloc, 2

#undef library
#undef function

; standard abort function
.code abort

	.replaceable
	mov	eax, 0x2000001
	mov	edi, 1
	syscall	; sys_exit

; standard argc variable
.data _argc

	.alignment	4
	.qbyte	0

; standard argv variable
.data _argv

	.alignment	8
	.obyte	0

; standard _Exit function
.code _Exit

	.replaceable
	mov	eax, 0x2000001
	mov	edi, [rsp + 8]
	syscall	; sys_exit

; standard fgetc function
.code fgetc

	push	0
	mov	eax, 0x2000003
	mov	rdi, [rsp + 16]
	mov	rsi, rsp
	mov	rdx, 1
	syscall	; sys_read
	pop	rbx
	cmp	eax, 1
	jne	fail
	mov	eax, ebx
	ret
fail:	mov	eax, -1
	ret

; standard fputc function
.code fputc

	mov	eax, 0x2000004
	mov	rdi, [rsp + 16]
	lea	rsi, [rsp + 8]
	mov	rdx, 1
	syscall	; sys_write
	cmp	eax, 1
	jne	fail
	mov	eax, [rsp + 8]
	ret
fail:	mov	eax, -1
	ret

; standard stderr variable
.const stderr

	.alignment	8
	.obyte	2

; standard stdin variable
.const stdin

	.alignment	8
	.obyte	0

; standard stdout variable
.const stdout

	.alignment	8
	.obyte	1

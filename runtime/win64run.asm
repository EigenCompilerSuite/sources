; Windows 64-bit runtime support
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

; PE file format
.header _header

	.required
	.assert	.bitmode == 64
base:	.equals	0x00400000

dos_stub:
	.byte	"MZ"	; e_magic
	.dbyte	dos_stub_size % 512	; e_cblp
	.dbyte	dos_stub_size / 512 + 1	; e_cp
	.dbyte	0	; e_crlc
	.dbyte	dos_header_size / 16	; e_cparhdr
	.dbyte	0	; e_minalloc
	.dbyte	0	; e_maxalloc
	.dbyte	0	; e_ss
	.dbyte	0	; e_sp
	.dbyte	0	; e_csum
	.dbyte	0	; e_ip
	.dbyte	0	; e_cs
	.dbyte	dos_header_size	; e_lfarlc
	.dbyte	0	; e_ovno
	.reserve	32	; e_res
	.qbyte	dos_stub_size	; e_lfanew
dos_header_size:

dos_code:
	.bitmode	16
	push	cs
	pop	ds
	mov	dx, dos_text - dos_code
	mov	ah, 9
	int	21h
	mov	ax, 0x4c01
	int	21h

dos_text:
	.byte	"This program cannot be run in DOS mode.\r\r\n$"
	.align	16
dos_stub_size:

header:
	.byte	"PE", 0, 0	; Signature
	.dbyte	0x8664	; Machine
	.dbyte	1	; NumberOfSections
	.qbyte	0	; TimeDateStamp
	.qbyte	0	; PointerToSymbolTable
	.qbyte	0	; NumberOfSymbols
	.dbyte	optional_header_size	; SizeOfOptionalHeader
	.dbyte	0x22f	; Characteristics

file_align:	.equals	0x200
sect_align:	.equals	0x1000

optional_header:
	.dbyte	0x20b	; Magic
	.byte	0	; MajorLinkerVersion
	.byte	0	; MinorLinkerVersion
	.qbyte	@_trailer - base - entry	; SizeOfCode
	.qbyte	0	; SizeOfInitializedData
	.qbyte	0	; SizeOfUninitializedData
	.qbyte	entry	; AddressOfEntryPoint
	.qbyte	entry	; BaseOfCode
	.obyte	base	; ImageBase
	.qbyte	sect_align	; SectionAlignment
	.qbyte	file_align	; FileAlignment
	.dbyte	4	; MajorOperatingSystemVersion
	.dbyte	0	; MinorOperatingSystemVersion
	.dbyte	0	; MajorImageVersion
	.dbyte	0	; MinorImageVersion
	.dbyte	4	; MajorSubsystemVersion
	.dbyte	0	; MinorSubsystemVersion
	.qbyte	0	; Win32VersionValue
	.qbyte	@_trailer - .origin + sect_align - file_align	; SizeOfImage
	.qbyte	headers_size	; SizeOfHeaders
	.qbyte	0	; CheckSum
	.dbyte	size (@abort?_Exit?stderr?stdin?stdout?_kernel32_sentinel) + 16 >> 3	; Subsystem
	.dbyte	0x400	; DllCharacteristics
	.obyte	0x100000	; SizeOfStackReserve
	.obyte	0x1000	; SizeOfStackCommit
	.obyte	0x100000	; SizeOfHeapReserve
	.obyte	0x1000	; SizeOfHeapCommit
	.qbyte	0	; LoaderFlags
	.qbyte	16	; NumberOfRvaAndSizes
	.qbyte	0, 0	; ExportTable
	.qbyte	@_import_table?_import_table - base, size (@_import_table?_import_table) + 20	; ImportTable
	.reserve	14 * 8	; DataDirectory
optional_header_end:
optional_header_size:	.equals	optional_header_end - optional_header

code_section:
	.byte	".text"	; Name
	.pad	code_section + 8
	.qbyte	@_trailer - base - entry	; VirtualSize
	.qbyte	entry	; VirtualAddress
	.qbyte	@_trailer - base - entry	; SizeOfRawData
	.qbyte	_entry	; PointerToRawData
	.qbyte	0	; PointerToRelocations
	.qbyte	0	; PointerToLinenumbers
	.dbyte	0	; NumberOfRelocations
	.dbyte	0	; NumberOfLinenumbers
	.qbyte	0xe0000020	; Characteristics
	.align	file_align
headers_size:

	.assert	headers_size == file_align
	.origin	base + sect_align - file_align

_entry:
entry:	.equals	_entry + sect_align - file_align

.trailer _trailer

	.alignment	0x200

.const _extension

	.byte	".exe"

; environment name
.const _environment

	.byte	"Windows 64-bit", 0

; system call wrappers
#repeat 5

	.code _system_call_wrapper##

		#if ## == 4
			.alias	_system_call_wrapper5
			.alias	_system_call_wrapper6
			.alias	_system_call_wrapper7
			.alias	_system_call_wrapper8
			.alias	_system_call_wrapper9
			.alias	_system_call_wrapper10
			.alias	_system_call_wrapper11
			.alias	_system_call_wrapper12
		#endif

		pop	rbx
		#if ## > 0
			mov	rcx, [rsp]
		#endif
		#if ## > 1
			mov	rdx, [rsp + 8]
		#endif
		#if ## > 2
			mov	r8, [rsp + 16]
		#endif
		#if ## > 3
			mov	r9, [rsp + 24]
		#endif
		#if ## < 4
			sub	rsp, 32 - ## * 8
		#endif
		call	rax
		#if ## < 4
			add	rsp, 32 - ## * 8
		#endif
		jmp	rbx

#endrep

; imported libraries
.const _import_kernel32

	.alignment	4
	.duplicable
	.group	_import_table
	.require	_import_sentinel
	.qbyte	@_kernel32_imports - 0x00400000, 0, 0, @_kernel32_name - 0x00400000, @_kernel32_imports - 0x00400000

; library name
.const _kernel32_name

	.duplicable
	.byte	"kernel32.dll", 0

; sentinel for imported functions
.const _kernel32_sentinel

	.alignment	8
	.duplicable
	.group	_kernel32_imports_end
	.require	_import_kernel32
	.obyte	0

.const _import_sentinel
	.alignment	4
	.group	_import_table_end
	.qbyte	0, 0, 0, 0, 0

; imported library functions
#define function

	; list entry
	.const _#0

		.alignment	8
		.duplicable
		.group	_kernel32_imports
		.require	_kernel32_sentinel
		.obyte	@_#0_hint - 0x00400000

	; function hint
	.const _#0_hint

		.alignment	2
		.dbyte	0
		.duplicable
		.byte	"#0", 0

#enddef

	function	CloseHandle
	function	CreateProcessA
	function	DeleteFileA
	function	ExitProcess
	function	FileTimeToSystemTime
	function	GetCommandLineA
	function	GetEnvironmentVariableA
	function	GetExitCodeProcess
	function	GetProcessHeap
	function	GetStdHandle
	function	GetSystemTimeAsFileTime
	function	GetTickCount
	function	HeapAlloc
	function	HeapFree
	function	MoveFileA
	function	ReadFile
	function	SystemTimeToTzSpecificLocalTime
	function	WaitForSingleObject
	function	WriteFile

#undef function

; handle to default process heap
.data _default_heap_handle

	.alignment	8
	.reserve	8
	.require	_init_default_heap_handle

; retrieve handle to the default heap
.initdata _init_default_heap_handle

	sub	rsp, 32
	call	qword [rip + @_GetProcessHeap]
	mov	[rip + @_default_heap_handle], rax
	add	rsp, 32

; initial tick count
.data _initial_tick_count

	.alignment	4
	.reserve	4
	.require	_init_initial_tick_count

; retrieve initial tick count
.initdata _init_initial_tick_count

	sub	rsp, 32
	call	qword [rip + @_GetTickCount]
	mov	[rip + @_initial_tick_count], eax
	add	rsp, 32

; standard abort function
.code abort

	.replaceable
	sub	rsp, 32
	mov	ecx, 1	; uExitCode
	call	qword [rip + @_ExitProcess]

; standard argc variable
.data _argc

	.alignment	4
	.reserve	4
	.require	_init_argc

; initialize argc variable
.initdata _init_argc

	sub	rsp, 32
	call	qword [rip + @_GetCommandLineA]
	add	rsp, 32
	xor	ecx, ecx
loop:	mov	bl, [rax]
	cmp	bl, 0
	je	end
	cmp	bl, ' '
	ja	begin
	mov	byte [rax], 0
	inc	rax
	jmp	loop
begin:	inc	ecx
skip:	inc	rax
	cmp	byte [rax], ' '
	ja	skip
	jmp	loop
end:	mov	[rip + @_argc], ecx

; standard argv variable
.data _argv

	.alignment	8
	.reserve	8
	.require	_init_argv

; initialize argv variable
.initdata _init_argv

	mov	ecx, [rip + @_argc]
	mov	eax, ecx
	inc	eax
	shl	eax, 3
	push	rax
	call	dword @malloc
	cmp	eax, 0
	je	dword @abort
	mov	[rip + @_argv], eax
	sub	rsp, 32
	call	qword [rip + @_GetCommandLineA]
	add	rsp, 32
	mov	rbx, [rip + @_argv]
	mov	ecx, [rip + @_argc]
loop:	cmp	byte [rax], 0
	jne	begin
	inc	rax
	jmp	loop
begin:	mov	[rbx], rax
	add	rbx, 8
skip:	inc	rax
	cmp	byte [rax], 0
	jne	skip
	dec	ecx
	jnz	loop
	mov	[rbx], rcx

; standard clock function
.code clock

	sub	rsp, 32
	call	qword [rip + @_GetTickCount]
	add	rsp, 32
	sub	eax, [rip + @_initial_tick_count]
	ret

; standard _Exit function
.code _Exit

	.replaceable
	sub	rsp, 32
	mov	ecx, [rsp + 40]	; uExitCode
	call	qword [rip + @_ExitProcess]

; standard fgetc function
.code fgetc

	push	0	; local buffer
	push	0	; local read
	push	0	; lpOverlapped
	sub	rsp, 32
	lea	r9, [rsp + 40]	; lpNumberOfBytesRead
	mov	r8d, 1	; nNumberOfBytesToRead
	lea	rdx, [rsp + 48]	; lpBuffer
	mov	rcx, [rsp + 64]	; hFile
	call	qword [rip + @_ReadFile]
	add	rsp, 40
	pop	rdx
	pop	rbx
	cmp	eax, 0
	je	fail
	cmp	edx, 1
	jne	fail
	mov	eax, ebx
	ret
fail:	mov	eax, -1
	ret

; standard fputc function
.code fputc

	push	0	; local written
	push	0	; lpOverlapped
	sub	rsp, 32
	lea	r9, [rsp + 40]	; lpNumberOfBytesWritten
	mov	r8d, 1	; nNumberOfBytesToWrite
	lea	rdx, [rsp + 56]	; lpBuffer
	mov	rcx, [rsp + 64]	; hFile
	call	qword [rip + @_WriteFile]
	add	rsp, 48
	ret

; standard free function
.code free

	mov	rax, [rsp + 8]
	cmp	rax, 0
	je	skip
	sub	rsp, 32
	mov	r8, rax	; lpMem
	xor	edx, edx	; dwFlags
	mov	rcx, [rip + @_default_heap_handle]	; hHeap
	call	qword [rip + @_HeapFree]
	add	rsp, 32
skip:	ret

; standard getenv function
.code getenv

	sub	rsp, 32
	mov	ecx, 64	; nSize
	lea	rdx, [rip + @_getenv_buffer]	; lpBuffer
	lea	r8, [rsp + 40]	; lpName
	call	qword [rip + @_GetEnvironmentVariableA]
	add	rsp, 32
	cmp	eax, 64
	ja	fail
	cmp	eax, 0
	je	fail
	lea	rax, [rip + @_getenv_buffer]
	ret
fail:	xor	rax, rax
	ret

.data _getenv_buffer

	.reserve	64

; standard gmtime function
.code gmtime

	mov	eax, [rsp + 8]
	mov	rbx, 10000000
	mul	rbx
	mov	rbx, 116444736000000000
	add	rax, rbx
	push	rax
	mov	rcx, rsp	; lpFileTime
	sub	rsp, 16
	mov	rdx, rsp	; lpSystemTime
	sub	rsp, 32
	call	qword [rip + @_FileTimeToSystemTime]
	add	rsp, 32
	movsx	eax, word [rsp + 12]
	mov	[rip + @_tm + 0], eax	; tm_sec
	movsx	eax, word [rsp + 10]
	mov	[rip + @_tm + 4], eax	; tm_min
	movsx	eax, word [rsp + 8]
	mov	[rip + @_tm + 8], eax	; tm_hour
	movsx	eax, word [rsp + 6]
	mov	[rip + @_tm + 12], eax	; tm_mday
	movsx	eax, word [rsp + 2]
	mov	[rip + @_tm + 16], eax	; tm_mon
	movsx	eax, word [rsp + 0]
	sub	eax, 1900
	mov	[rip + @_tm + 20], eax	; tm_year
	movsx	eax, word [rsp + 4]
	mov	[rip + @_tm + 24], eax	; tm_wday
	add	rsp, 24
	mov	rax, @_tm
	ret

.data _tm

	.alignment	4
	.reserve	9 * 4

; standard localtime function
.code localtime

	mov	eax, [rsp + 8]
	mov	rbx, 10000000
	mul	rbx
	mov	rbx, 116444736000000000
	add	rax, rbx
	push	rax
	mov	rcx, rsp	; lpFileTime
	sub	rsp, 16
	mov	rdx, rsp	; lpSystemTime
	sub	rsp, 32
	call	qword [rip + @_FileTimeToSystemTime]
	xor	rcx, rcx	; lpTimeZone
	lea	rdx, [rsp + 32]	; lpUniversalTime
	mov	r8, rdx	; lpLocalTime
	call	qword [rip + @_SystemTimeToTzSpecificLocalTime]
	add	rsp, 32
	movsx	eax, word [rsp + 12]
	mov	[rip + @_tm + 0], eax	; tm_sec
	movsx	eax, word [rsp + 10]
	mov	[rip + @_tm + 4], eax	; tm_min
	movsx	eax, word [rsp + 8]
	mov	[rip + @_tm + 8], eax	; tm_hour
	movsx	eax, word [rsp + 6]
	mov	[rip + @_tm + 12], eax	; tm_mday
	movsx	eax, word [rsp + 2]
	mov	[rip + @_tm + 16], eax	; tm_mon
	movsx	eax, word [rsp + 0]
	sub	eax, 1900
	mov	[rip + @_tm + 20], eax	; tm_year
	movsx	eax, word [rsp + 4]
	mov	[rip + @_tm + 24], eax	; tm_wday
	add	rsp, 24
	mov	rax, @_tm
	ret

; standard malloc function
.code malloc

	sub	rsp, 32
	mov	r8, [rsp + 40]	; dwBytes
	xor	edx, edx	; dwFlags
	mov	rcx, [rip + @_default_heap_handle]	; hHeap
	call	qword [rip + @_HeapAlloc]
	add	rsp, 32
	ret

; standard realloc function
.code realloc

	sub	rsp, 32
	mov	r9, [rsp + 48]	; dwBytes
	mov	r8, [rsp + 40]	; lpMem
	xor	edx, edx	; dwFlags
	mov	rcx, [rip + @_default_heap_handle]	; hHeap
	call	qword [rip + @_HeapReAlloc]
	add	rsp, 32
	ret

; standard remove function
.code remove

	sub	rsp, 32
	mov	rcx, [rsp + 40]	; lpFileName
	call	qword [rip + @_DeleteFileA]
	add	rsp, 32
	neg	eax
	sbb	eax, eax
	inc	eax
	ret

; standard rename function
.code rename

	sub	rsp, 32
	mov	rdx, [rsp + 48]	; lpNewFileName
	mov	rcx, [rsp + 40]	; lpExistingFileName
	call	qword [rip + @_MoveFileA]
	add	rsp, 32
	neg	eax
	sbb	eax, eax
	inc	eax
	ret

; standard stderr variable
.const stderr

	.alignment	8
	.reserve	8
	.require	_init_stderr

; initialize stderr variable
.initdata _init_stderr

	sub	rsp, 32
	mov	rcx, -12	; nStdHandle
	call	qword [rip + @_GetStdHandle]
	mov	[rip + @stderr], rax
	add	rsp, 32

; standard stdin variable
.const stdin

	.alignment	8
	.reserve	8
	.require	_init_stdin

; initialize stdin variable
.initdata _init_stdin

	sub	rsp, 32
	mov	rcx, -10	; nStdHandle
	call	qword [rip + @_GetStdHandle]
	mov	[rip + @stdin], rax
	add	rsp, 32

; standard stdout variable
.const stdout

	.alignment	8
	.reserve	8
	.require	_init_stdout

; initialize stdout variable
.initdata _init_stdout

	sub	rsp, 32
	mov	rcx, -11	; nStdHandle
	call	qword [rip + @_GetStdHandle]
	mov	[rip + @stdout], rax
	add	rsp, 32

; standard time function
.code time

	sub	rsp, 8
	mov	rcx, rsp	; lpSystemTimeAsFileTime
	sub	rsp, 32
	call	qword [rip + @_GetSystemTimeAsFileTime]
	add	rsp, 32
	pop	rax
	cqo
	mov	rbx, 116444736000000000
	sub	rax, rbx
	mov	rbx, 10000000
	div	rbx
	mov	rbx, [rsp + 16]
	cmp	rbx, 0
	je	skip
	mov	[rbx], eax
skip:	ret

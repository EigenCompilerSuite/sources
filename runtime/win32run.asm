; Windows 32-bit runtime support
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
	.assert	.bitmode == 32
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
	.dbyte	0x014c	; Machine
	.dbyte	1	; NumberOfSections
	.qbyte	0	; TimeDateStamp
	.qbyte	0	; PointerToSymbolTable
	.qbyte	0	; NumberOfSymbols
	.dbyte	optional_header_size	; SizeOfOptionalHeader
	.dbyte	0x32f	; Characteristics

file_align:	.equals	0x200
sect_align:	.equals	0x1000

optional_header:
	.dbyte	0x10b	; Magic
	.byte	0	; MajorLinkerVersion
	.byte	0	; MinorLinkerVersion
	.qbyte	@_trailer - base - entry	; SizeOfCode
	.qbyte	0	; SizeOfInitializedData
	.qbyte	0	; SizeOfUninitializedData
	.qbyte	entry	; AddressOfEntryPoint
	.qbyte	entry	; BaseOfCode
	.qbyte	0	; BaseOfData
	.qbyte	base	; ImageBase
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
	.dbyte	size (@abort?_Exit?stderr?stdin?stdout?_kernel32_sentinel) + 8 >> 2	; Subsystem
	.dbyte	0x400	; DllCharacteristics
	.qbyte	0x100000	; SizeOfStackReserve
	.qbyte	0x1000	; SizeOfStackCommit
	.qbyte	0x100000	; SizeOfHeapReserve
	.qbyte	0x1000	; SizeOfHeapCommit
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

	.byte	"Windows 32-bit", 0

; system call wrappers
#repeat 13

	.code _system_call_wrapper##

		pop	ebx
		call	eax
		#if ## > 0
			sub	esp, ## * 4
		#endif
		jmp	ebx

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

	.alignment	4
	.duplicable
	.group	_kernel32_imports_end
	.require	_import_kernel32
	.qbyte	0

.const _import_sentinel
	.alignment	4
	.group	_import_table_end
	.qbyte	0, 0, 0, 0, 0

; imported library functions
#define function

	; list entry
	.const _#0

		.alignment	4
		.duplicable
		.group	_kernel32_imports
		.require	_kernel32_sentinel
		.qbyte	@_#0_hint - 0x00400000

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

	.alignment	4
	.reserve	4
	.require	_init_default_heap_handle

; retrieve handle to the default heap
.initdata _init_default_heap_handle

	call	dword [@_GetProcessHeap]
	mov	[@_default_heap_handle], eax

; initial tick count
.data _initial_tick_count

	.alignment	4
	.reserve	4
	.require	_init_initial_tick_count

; retrieve initial tick count
.initdata _init_initial_tick_count

	call	dword [@_GetTickCount]
	mov	[@_initial_tick_count], eax

; standard abort function
.code abort

	.replaceable
	push	1	; uExitCode
	call	dword [@_ExitProcess]

; standard argc variable
.data _argc

	.alignment	4
	.reserve	4
	.require	_init_argc

; initialize argc variable
.initdata _init_argc

	call	dword [@_GetCommandLineA]
	xor	ecx, ecx
loop:	mov	bl, [eax]
	cmp	bl, 0
	je	end
	cmp	bl, ' '
	ja	begin
	mov	byte [eax], 0
	inc	eax
	jmp	loop
begin:	inc	ecx
skip:	inc	eax
	cmp	byte [eax], ' '
	ja	skip
	jmp	loop
end:	mov	[@_argc], ecx

; standard argv variable
.data _argv

	.alignment	4
	.reserve	4
	.require	_init_argv

; initialize argv variable
.initdata _init_argv

	mov	ecx, [@_argc]
	mov	eax, ecx
	inc	eax
	shl	eax, 2
	push	eax
	call	dword @malloc
	cmp	eax, 0
	je	dword @abort
	mov	[@_argv], eax
	call	dword [@_GetCommandLineA]
	mov	ebx, [@_argv]
	mov	ecx, [@_argc]
loop:	cmp	byte [eax], 0
	jne	begin
	inc	eax
	jmp	loop
begin:	mov	[ebx], eax
	add	ebx, 4
skip:	inc	eax
	cmp	byte [eax], 0
	jne	skip
	dec	ecx
	jnz	loop
	mov	[ebx], ecx

; standard clock function
.code clock

	call	dword [@_GetTickCount]
	sub	eax, [@_initial_tick_count]
	ret

; standard _Exit function
.code _Exit

	.replaceable
	push	dword [esp + 4]	; uExitCode
	call	dword [@_ExitProcess]

; standard fclose function
.code fclose

	push	[esp + 4]	; hObject
	call	dword [@_CloseHandle]
	cmp	eax, 1
	sbb	eax, eax
	ret

; standard fgetc function
.code fgetc

	push	0	; local buffer
	push	0	; local read
	push	0	; lpOverlapped
	lea	eax, [esp + 4]
	push	eax	; lpNumberOfBytesRead
	push	1	; nNumberOfBytesToRead
	lea	eax, [esp + 16]
	push	eax	; lpBuffer
	push	dword [esp + 28]	; hFile
	call	dword [@_ReadFile]
	pop	edx
	pop	ebx
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
	lea	eax, [esp + 4]
	push	eax	; lpNumberOfBytesWritten
	push	1	; nNumberOfBytesToWrite
	lea	eax, [esp + 20]
	push	eax	; lpBuffer
	push	dword [esp + 28]	; hFile
	call	dword [@_WriteFile]
	pop	eax
	ret

; standard free function
.code free

	mov	eax, [esp + 4]
	cmp	eax, 0
	je	skip
	push	eax	; lpMem
	push	0	; dwFlags
	push	dword [@_default_heap_handle]	; hHeap
	call	dword [@_HeapFree]
skip:	ret

; standard getenv function
.code getenv

	push	64	; nSize
	push	dword @_getenv_buffer	; lpBuffer
	mov	eax, [esp + 16]
	push	eax	; lpName
	call	dword [@_GetEnvironmentVariableA]
	cmp	eax, 64
	ja	fail
	cmp	eax, 0
	je	fail
	mov	eax, dword @_getenv_buffer
	ret
fail:	xor	eax, eax
	ret

.data _getenv_buffer

	.reserve	64

; standard gmtime function
.code gmtime

	mov	eax, [esp + 4]
	mov	ebx, 10000000
	mul	ebx
	add	eax, 0xd53e8000
	adc	edx, 0x019db1de
	push	edx
	push	eax
	mov	eax, esp
	sub	esp, 16
	push	esp	; lpSystemTime
	push	eax	; lpFileTime
	call	dword [@_FileTimeToSystemTime]
	movsx	eax, word [esp + 12]
	mov	[@_tm + 0], eax	; tm_sec
	movsx	eax, word [esp + 10]
	mov	[@_tm + 4], eax	; tm_min
	movsx	eax, word [esp + 8]
	mov	[@_tm + 8], eax	; tm_hour
	movsx	eax, word [esp + 6]
	mov	[@_tm + 12], eax	; tm_mday
	movsx	eax, word [esp + 2]
	mov	[@_tm + 16], eax	; tm_mon
	movsx	eax, word [esp + 0]
	sub	eax, 1900
	mov	[@_tm + 20], eax	; tm_year
	movsx	eax, word [esp + 4]
	mov	[@_tm + 24], eax	; tm_wday
	add	esp, 24
	mov	eax, @_tm
	ret

.data _tm

	.alignment	4
	.reserve	9 * 4

; standard localtime function
.code localtime

	mov	eax, [esp + 4]
	mov	ebx, 10000000
	mul	ebx
	add	eax, 0xd53e8000
	adc	edx, 0x019db1de
	push	edx
	push	eax
	mov	eax, esp
	sub	esp, 16
	push	esp	; lpSystemTime
	push	eax	; lpFileTime
	call	dword [@_FileTimeToSystemTime]
	mov	eax, esp
	push	eax	; lpLocalTime
	push	eax	; lpUniversalTime
	push	0	; lpTimeZone
	call	dword [@_SystemTimeToTzSpecificLocalTime]
	movsx	eax, word [esp + 12]
	mov	[@_tm + 0], eax	; tm_sec
	movsx	eax, word [esp + 10]
	mov	[@_tm + 4], eax	; tm_min
	movsx	eax, word [esp + 8]
	mov	[@_tm + 8], eax	; tm_hour
	movsx	eax, word [esp + 6]
	mov	[@_tm + 12], eax	; tm_mday
	movsx	eax, word [esp + 2]
	mov	[@_tm + 16], eax	; tm_mon
	movsx	eax, word [esp + 0]
	sub	eax, 1900
	mov	[@_tm + 20], eax	; tm_year
	movsx	eax, word [esp + 4]
	mov	[@_tm + 24], eax	; tm_wday
	add	esp, 16 + 2 * 4
	mov	eax, @_tm
	ret

; standard malloc function
.code malloc

	push	dword [esp + 4]	; dwBytes
	push	0	; dwFlags
	push	dword [@_default_heap_handle]	; hHeap
	call	dword [@_HeapAlloc]
	ret

; standard realloc function
.code realloc

	push	dword [esp + 8]	; dwBytes
	push	dword [esp + 8]	; lpMem
	push	0	; dwFlags
	push	dword [@_default_heap_handle]	; hHeap
	call	dword [@_HeapReAlloc]
	ret

; standard remove function
.code remove

	push	dword [esp + 4]	; lpFileName
	call	dword [@_DeleteFileA]
	neg	eax
	sbb	eax, eax
	inc	eax
	ret

; standard rename function
.code rename

	push	dword [esp + 8]	; lpNewFileName
	push	dword [esp + 8]	; lpExistingFileName
	call	dword [@_MoveFileA]
	neg	eax
	sbb	eax, eax
	inc	eax
	ret

; standard stderr variable
.const stderr

	.alignment	4
	.reserve	4
	.require	_init_stderr

; initialize stderr variable
.initdata _init_stderr

	push	-12	; nStdHandle
	call	dword [@_GetStdHandle]
	mov	[@stderr], eax

; standard stdin variable
.const stdin

	.alignment	4
	.reserve	4
	.require	_init_stdin

; initialize stdin variable
.initdata _init_stdin

	push	-10	; nStdHandle
	call	dword [@_GetStdHandle]
	mov	[@stdin], eax

; standard stdout variable
.const stdout

	.alignment	4
	.reserve	4
	.require	_init_stdout

; initialize stdout variable
.initdata _init_stdout

	push	-11	; nStdHandle
	call	dword [@_GetStdHandle]
	mov	[@stdout], eax

; standard system function
.code system

	push	1
	sub	esp, 84

	mov	dword [esp + 16], 68	; cb
	mov	dword [esp + 20], 0	; lpReserved
	mov	dword [esp + 60], 0	; dwFlags
	mov	word [esp + 56], 0	; cbReserved2
	mov	dword [esp + 58], 0	; lpReserved2

	push	esp	; lpProcessInformation
	lea	eax, [esp + 20]
	push	eax	; lpStartupInfo
	push	0	; lpCurrentDirectory
	push	0	; lpEnvironment
	push	0	; dwCreationFlags
	push	0	; bInheritHandles
	push	0	; lpThreadAttributes
	push	0	; lpProcessAttributes
	push	dword [esp + 124]	; lpCommandLine
	push	0	; lpApplicationName
	call	dword [@_CreateProcessA]
	cmp	eax, 0
	je	end

	push	-1	; dwMilliseconds
	push	dword [esp + 4]	; hHandle
	call	dword [@_WaitForSingleObject]
	cmp	eax, 0
	jne	end

	lea	eax, [esp + 88]
	push	eax	; lpExitCode
	push	dword [esp + 4]	; hProcess
	call	dword [@_GetExitCodeProcess]

	push	dword [esp]	; hObject
	call	dword [@_CloseHandle]

end:	add	esp, 84
	pop	eax
	ret

; standard time function
.code time

	sub	esp, 8
	push	esp	; lpSystemTimeAsFileTime
	call	dword [@_GetSystemTimeAsFileTime]
	pop	eax
	pop	edx
	sub	eax, 0xd53e8000
	sbb	edx, 0x019db1de
	mov	ebx, 10000000
	div	ebx
	mov	ebx, [esp + 8]
	cmp	ebx, 0
	je	skip
	mov	[ebx], eax
skip:	ret

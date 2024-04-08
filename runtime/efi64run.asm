; EFI 64-bit runtime support
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
	.qbyte	@_trailer - base - code_base	; SizeOfCode
	.qbyte	0	; SizeOfInitializedData
	.qbyte	0	; SizeOfUninitializedData
	.qbyte	entry	; AddressOfEntryPoint
	.qbyte	code_base	; BaseOfCode
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
	.dbyte	10	; Subsystem
	.dbyte	0x400	; DllCharacteristics
	.obyte	0x100000	; SizeOfStackReserve
	.obyte	0x1000	; SizeOfStackCommit
	.obyte	0x100000	; SizeOfHeapReserve
	.obyte	0x1000	; SizeOfHeapCommit
	.qbyte	0	; LoaderFlags
	.qbyte	0	; NumberOfRvaAndSizes
optional_header_end:
optional_header_size:	.equals	optional_header_end - optional_header

code_section:
	.byte	".text"	; Name
	.pad	code_section + 8
	.qbyte	@_trailer - base - code_base	; VirtualSize
	.qbyte	code_base	; VirtualAddress
	.qbyte	@_trailer - base - code_base	; SizeOfRawData
	.qbyte	_code_base	; PointerToRawData
	.qbyte	0	; PointerToRelocations
	.qbyte	0	; PointerToLinenumbers
	.dbyte	0	; NumberOfRelocations
	.dbyte	0	; NumberOfLinenumbers
	.qbyte	0xe0000020	; Characteristics
	.align	file_align
headers_size:

	.assert	headers_size == file_align
	.origin	base + sect_align - file_align

_code_base:
code_base:	.equals	_code_base + sect_align - file_align

entry:
	.bitmode	64
	mov	[rip + @_ImageHandle], rcx
	mov	[rip + @_SystemTable], rdx

.trailer _trailer

	.alignment	0x200

.const _extension

	.byte	".efi"

; environment name
.const _environment

	.byte	"EFI 64-bit", 0

; global image handle
.data _ImageHandle

	.alignment	8
	.reserve	8

; global system table
.data _SystemTable

	.alignment	8
	.reserve	8

; standard abort function
.code abort

	sub	rsp, 32
	mov	rcx, [rip + @_ImageHandle]	; ImageHandle
	mov	edx, 1	; ExitStatus
	xor	r8d, r8d	; ExitDataSize
	xor	r9, r9	; ExitData
	mov	rax, [rip + @_SystemTable]
	mov	rax, [rax + 96]	; BootServices
	call	qword [rax + 216]	; Exit

; standard _Exit function
.code _Exit

	sub	rsp, 32
	mov	rcx, [rip + @_ImageHandle]	; ImageHandle
	mov	edx, [rsp + 40]	; ExitStatus
	xor	r8d, r8d	; ExitDataSize
	xor	r9, r9	; ExitData
	mov	rax, [rip + @_SystemTable]
	mov	rax, [rax + 96]	; BootServices
	call	qword [rax + 216]	; Exit

; standard free function
.code free

	mov	rax, [rsp + 8]
	cmp	rax, 0
	je	skip
	sub	rsp, 32
	mov	rcx, rax	; Buffer
	mov	rax, [@_SystemTable]
	mov	rax, [rax + 96]	; BootServices
	call	qword [rax + 72]	; FreePool
	add	rsp, 32
skip:	ret

; standard getchar function
.code getchar

	push	0
	sub	rsp, 32
	mov	rcx, 1	; NumberOfEvents
	mov	rax, [rip + @_SystemTable]
	mov	rdx, [rax + 48]	; ConIn
	lea	rdx, [rdx + 16]	; Event: WaitForKey
	lea	r8, [rsp + 32]	; Index
	mov	rax, [rax + 96]	; BootServices
	call	qword [rax + 120]	; WaitForEvent

	lea	rcx, [rsp + 32]	; Key
	mov	rdx, [rip + @_SystemTable]
	mov	rdx, [rdx + 48]	; This: ConIn
	call	qword [rdx + 8]	; ReadKeyStroke
	add	rsp, 32

	pop	rax
	shr	eax, 16
	ret

; standard malloc function
.code malloc

	push	0
	sub	rsp, 32
	mov	ecx, 2	; PoolType
	mov	rdx, [rsp + 48]	; Size
	lea	r8, [rsp + 32]	; Buffer
	mov	rax, [@_SystemTable]
	mov	rax, [rax + 96]	; BootServices
	call	qword [rax + 64]	; AllocatePool
	add	rsp, 32
	cmp	eax, 0
	je	skip
	mov	qword [rsp], 0
skip:	pop	rax
	ret

; standard putchar function
.code putchar

	sub	rsp, 32
	and	dword [rsp + 40], 0xff
	mov	rcx, [rip + @_SystemTable]
	mov	rcx, [rcx + 64]	; This: ConOut
	lea	rdx, [rsp + 48]	; String
	call	qword [rcx + 8]	; OutputString
	add	rsp, 32
	ret

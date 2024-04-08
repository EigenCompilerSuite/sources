; EFI 32-bit runtime support
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
	.qbyte	@_trailer - base - code_base	; SizeOfCode
	.qbyte	0	; SizeOfInitializedData
	.qbyte	0	; SizeOfUninitializedData
	.qbyte	entry	; AddressOfEntryPoint
	.qbyte	code_base	; BaseOfCode
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
	.dbyte	10	; Subsystem
	.dbyte	0x400	; DllCharacteristics
	.qbyte	0x100000	; SizeOfStackReserve
	.qbyte	0x1000	; SizeOfStackCommit
	.qbyte	0x100000	; SizeOfHeapReserve
	.qbyte	0x1000	; SizeOfHeapCommit
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
	.bitmode	32
	mov	eax, [esp + 4]
	mov	[@_ImageHandle], eax
	mov	eax, [esp + 8]
	mov	[@_SystemTable], eax

.trailer _trailer

	.alignment	0x200

.const _extension

	.byte	".efi"

; environment name
.const _environment

	.byte	"EFI 32-bit", 0

; global image handle
.data _ImageHandle

	.alignment	4
	.reserve	4

; global system table
.data _SystemTable

	.alignment	4
	.reserve	4

; standard abort function
.code abort

	push	0	; ExitData
	push	0	; ExitDataSize
	push	1	; ExitStatus
	push	dword [@_ImageHandle]	; ImageHandle
	mov	eax, [@_SystemTable]
	mov	eax, [eax + 60]	; BootServices
	call	dword [eax + 120]	; Exit

; standard _Exit function
.code _Exit

	push	0	; ExitData
	push	0	; ExitDataSize
	push	dword [esp + 12]	; ExitStatus
	push	dword [@_ImageHandle]	; ImageHandle
	mov	eax, [@_SystemTable]
	mov	eax, [eax + 60]	; BootServices
	call	dword [eax + 120]	; Exit

; standard free function
.code free

	mov	eax, [esp + 4]
	cmp	eax, 0
	je	skip
	push	eax	; Buffer
	mov	eax, [@_SystemTable]
	mov	eax, [eax + 60]	; BootServices
	call	dword [eax + 48]	; FreePool
	add	esp, 4
skip:	ret

; standard getchar function
.code getchar

	push	0
	push	esp	; Index
	mov	eax, [@_SystemTable]
	mov	eax, [eax + 36]	; ConIn
	lea	eax, [eax + 8]	; WaitForKey
	push	eax	; Event
	push	1	; NumberOfEvents
	mov	eax, [@_SystemTable]
	mov	eax, [eax + 60]	; BootServices
	call	dword [eax + 60]	; WaitForEvent
	add	esp, 8

	mov	eax, [@_SystemTable]
	mov	eax, [eax + 36]	; ConIn
	push	eax	; This
	call	dword [eax + 4]	; ReadKeyStroke
	add	esp, 8

	pop	eax
	shr	eax, 16
	ret

; standard malloc function
.code malloc

	push	0
	push	esp	; Buffer
	push	dword [esp + 12]	; Size
	push	2	; PoolType
	mov	eax, [@_SystemTable]
	mov	eax, [eax + 60]	; BootServices
	call	dword [eax + 44]	; AllocatePool
	add	esp, 12
	cmp	eax, 0
	je	skip
	mov	dword [esp], 0
skip:	pop	eax
	ret

; standard putchar function
.code putchar

	and	dword [esp + 4], 0xff
	lea	eax, [esp + 4]
	push	eax	; String
	mov	eax, [@_SystemTable]
	mov	eax, [eax + 44]	; ConOut
	push	eax	; This
	call	dword [eax + 4]	; OutputString
	add	esp, 8
	ret

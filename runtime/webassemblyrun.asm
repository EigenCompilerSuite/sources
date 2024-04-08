; WebAssembly runtime support
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

; binary module
.header _header

	.required
	.origin	0

	.byte	0x00, 0x61, 0x73, 0x6D	; magic
	.byte	0x01, 0x00, 0x00, 0x00	; version

	.require	_type_section

.trailer _trailer

.const _extension

	.byte	".wasm"

; environment name
.const _environment

	.byte	"WebAssembly", 0

; type section
.header _type_section

	.group	_s00

	.byte	1	; id
	i32	offset (@_import_section) - 5	; size
	i32	count (@_s00_types)	; vec (functype)

.header _main_type

	.group	_s00_types

	.byte	0x60	; functype
	vec	0	; vec (valtype)
	vec	0	; vec (valtype)

; import section
.header _import_section

	.group	_s01

	.byte	2	; id
	i32	offset (@_function_section) - 5	; size
	i32	count (@_s01_imports?_s01_imports)	; vec (import)

; function section
.header _function_section

	.group	_s02

	.byte	3	; id
	i32	offset (@_memory_section) - 5	; size
	i32	count (@_s10_codes?_s10_codes) + 1	; vec (typeidx)
	i32	index (@_main_type)	; typeidx

.header _main_function

	.group	_s02_functions

; memory section
.header _memory_section

	.group	_s04

	.byte	5	; id
	i32	offset (@_global_section) - 5	; size
	vec	1	; vec (mem)
	.byte	0x00	; limits
	i32	@_trailer	; min

; global section
.header _global_section

	.group	_s05

	.byte	6	; id
	i32	offset (@_export_section) - 5	; size
	i32	count (@_s05_globals?_s05_globals)	; vec (global)

; export section
.header _export_section

	.group	_s06

	.byte	7	; id
	i32	offset (@_start_section) - 5	; size
	i32	count (@_s06_exports?_s06_exports)	; vec (export)

; start section
.header _start_section

	.group	_s07

	.byte	8	; id
	i32	offset (@_data_count_section) - 5	; size
	i32	index (@_main_function)	; funcidx

; data count section
.header _data_count_section

	.group	_s09

	.byte	12	; id
	i32	offset (@_code_section) - 5	; size
	u32	1	; count

; code section
.header _code_section

	.group	_s10

	.byte	10	; id
	i32	offset (@_data_section) - 5	; size
	i32	count (@_s10_codes?_s10_codes) + 1	; vec (code)

.header _main_code

	.required
	.group	_s10

	i32	offset (@_s10_codes?_s10_codes:_data_section) - 5	; size
	vec	0	; vec (locals)

.code _main_code_end

	.required
	.group	_s10_break

	end	; expr

; data section
.const _data_section

	.group	_s11

	.byte	11	; id
	i32	offset (@_trailer) - 5	; size
	vec	1	; vec (data)
	.byte	0x00	; data
	i32.const	; expr
	i32	extent (@_data_section)	; offset
	end
	i32	offset (@_trailer) - 5	; vec (byte)

; stack initialisation
.initdata _init_stack

	i32.const	0x4000
	memory.grow
	i32.const	0x4000
	i32.add
	global.set
	i32	index (@_$sp)
	global.get
	i32	index (@_$sp)
	global.set
	i32	index (@_$fp)

#define code
	.header _#0_function

		.group	_s02_functions
		.require	#0
		i32	index (@_main_type)	; typeidx

	.code #0

		.group	_s10_codes
		i32	size (@#0) - 5	; size
		vec	0	; vec (locals)
#enddef

; standard abort function
code abort

	unreachable
	end

; standard _Exit function
code _Exit

	i32.const	0
	global.get
	i32	index (@_$sp)
	i32.load	0 0
	i32.eq
	br_if	0
	unreachable
	end

// WebAssembly library support
// Copyright (C) Florian Negele

// This file is part of the Eigen Compiler Suite.

// The ECS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// The ECS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// Under Section 7 of the GNU General Public License version 3,
// the copyright holder grants you additional permissions to use
// this file as described in the ECS Runtime Support Exception.

// You should have received a copy of the GNU General Public License
// and a copy of the ECS Runtime Support Exception along with
// the ECS.  If not, see <https://www.gnu.org/licenses/>.

#ifndef ECS_WEBASSEMBLY_LIBRARY_HEADER_INCLUDED
#define ECS_WEBASSEMBLY_LIBRARY_HEADER_INCLUDED

#if defined __wasm__

	#define DEFINE_CODE(name) \
		asm (".code _" #name "_code \n .group _s10_codes \n i32 size (@_" #name "_code) - 5 \n vec 0 \n"

	#define DEFINE_FUNCTION(name, type) \
		asm (".header _" #name "_function \n .group _s02_functions \n #if (" #type ") !== () \n .require _" #name "_code \n i32 index (@_" #type "_type) \n #endif \n");

	#define DEFINE_GLOBAL(name, type) \
		asm (".header _" #name "_global \n .group _s05_globals \n valtype " #type "\n .byte 0x01 \n " #type ".const 0 \n end \n");

	#define DEFINE_EXPORT(name, type, index) \
		asm (".header _" #name "_export \n .required \n .group _s06_exports \n u32 offset (name) - 1 \n .byte \"" #name "\" \n name: .byte " #type " \n i32 index (@" #index ") \n");

	#define DEFINE_IMPORT(module, name, type, index) \
		asm (".header _" #module "." #name "_import \n .group _s01_imports \n u32 offset (module) - 1 \n .byte \"" #module "\" \n module: u32 offset (name) - 1 \n .byte \"" #name "\" \n name: \n .byte " #type " \n i32 index (@" #index ") \n");

	#define DEFINE_TYPE(name, result, ...) \
		asm (".header _" #name "_type \n .group _s00_types \n .byte 0x60 \n #define type \n #if (#0) !== () \n valtype #0 \n #endif \n #enddef \n" \
			"#define types \n vec offset (#0) - 1 \n type #1 \n type #2 \n type #3 \n type #4 \n type #5 \n type #6 \n type #7 \n type #8 \n type #9 \n #0: \n #enddef \n" \
			"types parameters, " #__VA_ARGS__ "\n types results, " #result "\n");

	#define EXPORT_FUNCTION(name, result, ...) \
		DEFINE_CODE (name##_export) \
			"#define push \n #if (#0) !== () \n global.get \n i32 index (@_$sp) \n #if (#0) === (i32) || (#0) === (f32) \n i32.const 4 \n #else \n i32.const 8 \n #endif \n i32.sub \n global.set \n i32 index (@_$sp) \n global.get \n i32 index (@_$sp) \n local.get #1 \n #0.store 0 0 \n #endif \n #enddef \n" \
			"#define parameters \n push #0, 0 \n push #1, 1 \n push #2, 2 \n push #3, 3 \n push #4, 4 \n push #5, 5 \n push #6, 6 \n push #7, 7 \n push #8, 8 \n push #9, 9 \n #enddef \n" \
			"#define result \n #if (#0) !== () \n global.get \n i32 index (@_$res_#0) \n #endif \n #enddef \n" \
			"parameters " #__VA_ARGS__ "\n call \n i32 index (@_" #name "_function) \n result " #result "\n end \n"); \
		DEFINE_FUNCTION (name##_export, name) \
		DEFINE_EXPORT (name, 0x00, _##name##_export_function) \
		DEFINE_TYPE (name, result, __VA_ARGS__)

	#define EXPORT_GLOBAL(name) \
		DEFINE_EXPORT (name, 0x03, name)

	#define IMPORT_FUNCTION(module, name, result, ...) \
		DEFINE_CODE (module.name) \
			"#define push \n #if (#0) !== () \n global.get \n i32 index (@_$0_i32) \n #0.load 0 0 \n global.get \n i32 index (@_$0_i32) \n #if (#0) === (i32) || (#0) === (f32) \n i32.const 4 \n #else \n i32.const 8 \n #endif \n i32.add \n global.set \n i32 index (@_$0_i32) \n #endif \n #enddef \n" \
			"#define parameters \n push #0 \n push #1 \n push #2 \n push #3 \n push #4 \n push #5 \n push #6 \n push #7 \n push #8 \n push #9 \n #enddef \n" \
			"#define result \n #if (#0) !== () \n global.set \n i32 index (@_$res_#0) \n #endif \n #enddef \n" \
			".require _" #module "." #name "_import \n global.get \n i32 index (@_$sp) \n global.set \n i32 index (@_$0_i32) \n parameters " #__VA_ARGS__ "\n call \n i32 index (@_" #module "." #name "_import_function) \n result " #result "\n end \n"); \
		DEFINE_FUNCTION (module.name, main) \
		DEFINE_FUNCTION (module.name##_import, ) \
		DEFINE_IMPORT (module, name, 0x00, _##module.name##_type) \
		DEFINE_TYPE (module.name, result, __VA_ARGS__)

#else

	#error platform not supported

#endif

#endif // ECS_WEBASSEMBLY_LIBRARY_HEADER_INCLUDED

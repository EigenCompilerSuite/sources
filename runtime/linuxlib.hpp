// Linux library support
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

#ifndef ECS_LINUX_LIBRARY_HEADER_INCLUDED
#define ECS_LINUX_LIBRARY_HEADER_INCLUDED

#if defined __amd32__

	#define LIBRARY(name, file) asm ( \
		".const _dynamic_section_" #name "\n .duplicable \n .group _dynamic_section \n .require _dynamic_section_sentinel \n .alignment 4 \n .qbyte 1, position (@_" #name "_string) + 1 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte " #file ", 0 \n" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".const _" #name "_symbol \n .duplicable \n .group _symbol_table \n .require _dynamic_section_" #library "\n .alignment 4 \n" \
		".qbyte position (@_" #name "_string) + 1 \n .qbyte 0 \n .qbyte 0 \n .byte 0x12 \n .byte 0x0 \n .dbyte 0 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte \"" #name "\", 0 \n" \
		".const _" #name "_relocation \n .duplicable \n .group _relocation_table \n .alignment 4 \n .qbyte @_" #name "\n .byte 1 \n .tbyte index (@_" #name "_symbol) + 1 \n .qbyte 0 \n" \
		".const _" #name "\n .duplicable \n .require _" #name "_relocation \n .alignment 4 \n .reserve 4 \n" \
		".code " #name "\n .duplicable \n mov eax, [@_" #name "] \n jmp dword @_function_call_wrapper \n" \
		);

#elif defined __amd64__

	#define LIBRARY(name, file) asm ( \
		".const _dynamic_section_" #name "\n .duplicable \n .group _dynamic_section \n .require _dynamic_section_sentinel \n .alignment 8 \n .obyte 1, position (@_" #name "_string) + 1 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte " #file ", 0 \n" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".const _" #name "_symbol \n .duplicable \n .group _symbol_table \n .require _dynamic_section_" #library "\n .alignment 8 \n" \
		".qbyte position (@_" #name "_string) + 1 \n .byte 0x12 \n .byte 0x0 \n .dbyte 0 \n .obyte 0 \n .obyte 0 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte \"" #name "\", 0 \n" \
		".const _" #name "_relocation \n .duplicable \n .group _relocation_table \n .alignment 8 \n .obyte @_" #name "\n .qbyte 1 \n .qbyte index (@_" #name "_symbol) + 1 \n .obyte 0 \n" \
		".const _" #name "\n .duplicable \n .require _" #name "_relocation \n .alignment 8 \n .reserve 8 \n" \
		".code " #name "\n .duplicable \n mov rax, [rip + @_" #name "] \n jmp dword @_function_call_wrapper" #parameters "\n" \
		);

#elif defined __arma32__

	#define LIBRARY(name, file) asm ( \
		".const _dynamic_section_" #name "\n .duplicable \n .group _dynamic_section \n .require _dynamic_section_sentinel \n .alignment 4 \n .qbyte 1, position (@_" #name "_string) + 1 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte " #file ", 0 \n" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".const _" #name "_symbol \n .duplicable \n .group _symbol_table \n .require _dynamic_section_" #library "\n .alignment 4 \n" \
		".qbyte position (@_" #name "_string) + 1 \n .qbyte 0 \n .qbyte 0 \n .byte 0x12 \n .byte 0x0 \n .dbyte 0 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte \"" #name "\", 0 \n" \
		".const _" #name "_relocation \n .duplicable \n .group _relocation_table \n .alignment 4 \n .qbyte @_" #name "\n .byte 2 \n .tbyte index (@_" #name "_symbol) + 1 \n .qbyte 0 \n" \
		".const _" #name "\n .duplicable \n .require _" #name "_relocation \n .alignment 4 \n .reserve 4 \n" \
		".code " #name "\n .duplicable \n ldr r4, [pc, offset (adr)] \n b @_function_call_wrapper" #parameters "\n adr: .qbyte @_" #name "\n" \
		);

#elif defined __arma64__

	#define LIBRARY(name, file) asm ( \
		".const _dynamic_section_" #name "\n .duplicable \n .group _dynamic_section \n .require _dynamic_section_sentinel \n .alignment 8 \n .obyte 1, position (@_" #name "_string) + 1 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte " #file ", 0 \n" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".const _" #name "_symbol \n .duplicable \n .group _symbol_table \n .require _dynamic_section_" #library "\n .alignment 8 \n" \
		".qbyte position (@_" #name "_string) + 1 \n .byte 0x12 \n .byte 0x0 \n .dbyte 0 \n .obyte 0 \n .obyte 0 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte \"" #name "\", 0 \n" \
		".const _" #name "_relocation \n .duplicable \n .group _relocation_table \n .alignment 8 \n .obyte @_" #name "\n .qbyte 257 \n .qbyte index (@_" #name "_symbol) + 1 \n .obyte 0 \n" \
		".const _" #name "\n .duplicable \n .require _" #name "_relocation \n .alignment 8 \n .reserve 8 \n" \
		".code " #name "\n .duplicable \n ldr x8, @_" #name " \n b @_function_call_wrapper" #parameters "\n" \
		);

#elif defined __armt32__ || defined __armt32fpe__

	#define LIBRARY(name, file) asm ( \
		".const _dynamic_section_" #name "\n .duplicable \n .group _dynamic_section \n .require _dynamic_section_sentinel \n .alignment 4 \n .qbyte 1, position (@_" #name "_string) + 1 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte " #file ", 0 \n" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".const _" #name "_symbol \n .duplicable \n .group _symbol_table \n .require _dynamic_section_" #library "\n .alignment 4 \n" \
		".qbyte position (@_" #name "_string) + 1 \n .qbyte 0 \n .qbyte 0 \n .byte 0x12 \n .byte 0x0 \n .dbyte 0 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte \"" #name "\", 0 \n" \
		".const _" #name "_relocation \n .duplicable \n .group _relocation_table \n .alignment 4 \n .qbyte @_" #name "\n .byte 2 \n .tbyte index (@_" #name "_symbol) + 1 \n .qbyte 0 \n" \
		".const _" #name "\n .duplicable \n .require _" #name "_relocation \n .alignment 4 \n .reserve 4 \n" \
		".code " #name "\n .duplicable \n .alignment 4 \n ldr r4, [pc, offset (adr)] \n b.w @_function_call_wrapper" #parameters "\n adr: .qbyte @_" #name "\n" \
		);

#elif defined __mips32__

	#define LIBRARY(name, file) asm ( \
		".const _dynamic_section_" #name "\n .duplicable \n .group _dynamic_section \n .require _dynamic_section_sentinel \n .alignment 4 \n .qbyte 1, position (@_" #name "_string) + 1 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte " #file ", 0 \n" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".const _" #name "_symbol \n .duplicable \n .group _symbol_table \n .require _dynamic_section_" #library "\n .alignment 4 \n" \
		".qbyte position (@_" #name "_string) + 1 \n .qbyte 0 \n .qbyte 0 \n .byte 0x12 \n .byte 0x0 \n .dbyte 0 \n" \
		".const _" #name "_string \n .duplicable \n .group _string_table \n .byte \"" #name "\", 0 \n" \
		".const _" #name "_relocation \n .duplicable \n .group _relocation_table \n .alignment 4 \n .qbyte @_" #name "\n .byte 2 \n .tbyte index (@_" #name "_symbol) + 1 \n .qbyte 0 \n" \
		".const _" #name "\n .duplicable \n .require _" #name "_relocation \n .alignment 4 \n .reserve 4 \n" \
		".code " #name "\n .duplicable \n lui r1, @_function_call_wrapper" #parameters " >> 16 \n ori r1, r1, @_function_call_wrapper" #parameters "\n lui r2, @_" #name " >> 16 \n jr r1 \n ori r2, r2, @_" #name "\n" \
		);

#else

	#error platform not supported

#endif

#endif // ECS_LINUX_LIBRARY_HEADER_INCLUDED

// OS X library support
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

#ifndef ECS_OS_X_LIBRARY_HEADER_INCLUDED
#define ECS_OS_X_LIBRARY_HEADER_INCLUDED

#if defined __amd32__

	#define LIBRARY(name, file) asm ( \
		".header _dylib_command_" #name "\n .duplicable \n .group _commands \n .require _dysymtab_command \n .alignment 4 \n .qbyte 12 \n" \
		".qbyte size \n .qbyte name \n .qbyte 0 \n .qbyte 0 \n .qbyte 0 \n name: .byte " #file ", 0 \n .align 4 \n size: \n" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".trailer _" #name "_symbol \n .duplicable \n .group _symbol_table \n .require _dylib_command_" #library "\n" \
		".alignment 4 \n .qbyte position (@_" #name "_text) + 1 \n .byte 1 \n .byte 0 \n .dbyte 0 \n .qbyte 0 \n" \
		".trailer _" #name "_text \n .duplicable \n .group _text_table \n .byte \"_" #name "\", 0 \n" \
		".const _" #name "_relocation \n .duplicable \n .group _relocations \n .alignment 4 \n .qbyte @_" #name " - 0x1000 \n .tbyte index (@_" #name "_symbol) \n .byte 0xc \n" \
		".const _" #name "\n .duplicable \n .require _" #name "_relocation \n .alignment 4 \n .reserve 4 \n" \
		".code " #name "\n .duplicable \n mov eax, [@_" #name "] \n jmp dword @_function_call_wrapper \n" \
		);

#elif defined __amd64__

	#define LIBRARY(name, file) asm ( \
		".header _dylib_command_" #name "\n .duplicable \n .group _commands \n .require _dysymtab_command \n .alignment 8 \n .qbyte 12 \n" \
		".qbyte size \n .qbyte name \n .qbyte 0 \n .qbyte 0 \n .qbyte 0 \n name: .byte " #file ", 0 \n .align 8 \n size: \n" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".trailer _" #name "_symbol \n .duplicable \n .group _symbol_table \n .require _dylib_command_" #library "\n" \
		".alignment 8 \n .qbyte position (@_" #name "_text) + 1 \n .byte 1 \n .byte 0 \n .dbyte 0 \n .obyte 0 \n" \
		".trailer _" #name "_text \n .duplicable \n .group _text_table \n .byte \"_" #name "\", 0 \n" \
		".const _" #name "_relocation \n .duplicable \n .group _relocations \n .alignment 4 \n .qbyte @_" #name " - 0x1000 \n .tbyte index (@_" #name "_symbol) \n .byte 0xe \n" \
		".const _" #name "\n .duplicable \n .require _" #name "_relocation \n .alignment 8 \n .reserve 8 \n" \
		".code " #name "\n .duplicable \n mov rax, [rip + @_" #name "] \n jmp dword @_function_call_wrapper" #parameters "\n" \
		);

#else

	#error platform not supported

#endif

#endif // ECS_OS_X_LIBRARY_HEADER_INCLUDED

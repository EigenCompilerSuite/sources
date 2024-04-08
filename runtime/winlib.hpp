// Windows library support
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

#ifndef ECS_WINDOWS_LIBRARY_HEADER_INCLUDED
#define ECS_WINDOWS_LIBRARY_HEADER_INCLUDED

#if defined __amd32__

	#define LIBRARY(name, file) asm ( \
		".const _import_" #name "\n .alignment 4 \n .duplicable \n .group _import_table \n .require _import_sentinel \n" \
		".qbyte @_" #name "_imports - 0x00400000, 0, 0, @_" #name "_name - 0x00400000, @_" #name "_imports - 0x00400000 \n" \
		".const _" #name "_name \n .duplicable \n .byte " #file ", 0 \n" \
		".const _" #name "_sentinel \n .alignment 4 \n .duplicable \n .group _" #name "_imports_end \n .require _import_" #name "\n .qbyte 0" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".const _" #name "\n .alignment 4 \n .duplicable \n .group _" #library "_imports \n .require _" #library "_sentinel \n .qbyte @_" #name "_hint - 0x00400000 \n" \
		".const _" #name "_hint \n .alignment 2 \n .dbyte 0 \n .duplicable \n .byte \"" #name "\", 0 \n" \
		".code " #name "\n .duplicable \n mov eax, [@_" #name "] \n jmp dword @_system_call_wrapper" #parameters \
		);

#elif defined __amd64__

	#define LIBRARY(name, file) asm ( \
		".const _import_" #name "\n .alignment 4 \n .duplicable \n .group _import_table \n .require _import_sentinel \n" \
		".qbyte @_" #name "_imports - 0x00400000, 0, 0, @_" #name "_name - 0x00400000, @_" #name "_imports - 0x00400000 \n" \
		".const _" #name "_name \n .duplicable \n .byte " #file ", 0 \n" \
		".const _" #name "_sentinel \n .alignment 8 \n .duplicable \n .group _" #name "_imports_end \n .require _import_" #name "\n .obyte 0" \
		);

	#define FUNCTION(library, name, parameters) asm ( \
		".const _" #name "\n .alignment 8 \n .duplicable \n .group _" #library "_imports \n .require _" #library "_sentinel \n .obyte @_" #name "_hint - 0x00400000 \n" \
		".const _" #name "_hint \n .alignment 2 \n .dbyte 0 \n .duplicable \n .byte \"" #name "\", 0 \n" \
		".code " #name "\n .duplicable \n mov rax, [rip + @_" #name "] \n jmp dword @_system_call_wrapper" #parameters \
		);

#else

	#error platform not supported

#endif

#endif // ECS_WINDOWS_LIBRARY_HEADER_INCLUDED

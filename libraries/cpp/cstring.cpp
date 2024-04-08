// Standard C++ <cstring> header
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

#include "cstring"

using namespace std;

// standard memcpy function

#if not defined __run__

	[[ecs::code]] asm (R"(
		.code memcpy
			mov	ptr $0, ptr [$sp + !lnksize * retalign + stackdisp]
			copy	ptr $0, ptr [$sp + !lnksize * retalign + ptralign + stackdisp], ptr [$sp + !lnksize * retalign + ptralign * 2 + stackdisp]
			mov	ptr $res, ptr $0
			#if lnksize
				jump	fun $lnk
			#else
				ret
			#endif
	)");

#endif

// standard memset function

#if not defined __run__

	[[ecs::code]] asm (R"(
		.code memset
			mov	ptr $0, ptr [$sp + !lnksize * retalign + stackdisp]
			conv	u1 $1, int [$sp + !lnksize * retalign + ptralign + stackdisp]
			fill	ptr $0, ptr [$sp + !lnksize * retalign + ptralign + intalign + stackdisp], u1 $1
			mov	ptr $res, ptr $0
			#if lnksize
				jump	fun $lnk
			#else
				ret
			#endif
	)");

#endif

// standard strchr function

#if defined __amd32__

	asm (R"(
		.code strchr
			mov	eax, [esp + 4]
			mov	ebx, [esp + 8]
		loop:	mov	dl, [eax]
			cmp	dl, bl
			je	done
			cmp	dl, '\0'
			je	skip
			inc	eax
			jmp	loop
		skip:	xor	eax, eax
		done:	ret
	)");

#elif defined __amd64__

	asm (R"(
		.code strchr
			mov	rax, [rsp + 8]
			mov	ebx, [rsp + 16]
		loop:	mov	dl, [rax]
			cmp	dl, bl
			je	done
			cmp	dl, '\0'
			je	skip
			inc	rax
			jmp	loop
		skip:	xor	rax, rax
		done:	ret
	)");

#else

	const char* std::strchr (const char* str, const int ch) noexcept
	{
		while (*str != '\0') if (*str == ch) return str; else ++str;
		return nullptr;
	}

#endif

// standard strlen function

size_t std::strlen (const char* str) noexcept
{
	size_t result = 0;
	while (*str != '\0') ++str, ++result;
	return result;
}

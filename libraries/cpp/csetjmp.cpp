// Standard C++ <csetjmp> header
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

#include "csetjmp"

using namespace std;

// standard longjmp function

#if not defined __run__ && not defined __wasm__

	[[ecs::code]] asm (R"(
		.code longjmp
			mov	ptr $0, ptr [$sp + !lnksize * retalign + stackdisp]
			mov	int $res, int [$sp + !lnksize * retalign + ptralign + stackdisp]
			mov	ptr $sp, ptr [$0 + ptrsize * 0]
			mov	ptr $fp, ptr [$0 + ptrsize * 1]
			jump	fun [$0 + ptrsize * 2]
	)");

#endif

// standard setjmp function

#if not defined __run__ && not defined __wasm__

	[[ecs::code]] asm (R"(
		.code setjmp
			#if !lnksize
				pop	fun $0
			#endif
			mov	ptr $1, ptr [$sp + stackdisp]
			mov	ptr [$1 + ptrsize * 0], ptr $sp + stackdisp
			mov	ptr [$1 + ptrsize * 1], ptr $fp + stackdisp
			#if lnksize
				mov	fun [$1 + ptrsize * 2], fun $lnk
			#else
				mov	fun [$1 + ptrsize * 2], fun $0
			#endif
			mov	int $res, int 0
			#if lnksize
				jump	fun $lnk
			#else
				jump	fun $0
			#endif
	)");

#endif

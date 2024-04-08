// Standard C++ <cstdlib> header
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

#include "cstdlib"

using namespace std;

// standard abs function

#if defined __amd16__

	asm (R"(
		.code abs
			mov	si, sp
			mov	ax, [si + 2]
			cwd
			xor	ax, dx
			sub	ax, dx
			ret
	)");

#elif defined __amd32__

	asm (R"(
		.code abs
			mov	eax, [esp + 4]
			cdq
			xor	eax, edx
			sub	eax, edx
			ret
	)");

#elif defined __amd64__

	asm (R"(
		.code abs
			mov	eax, [rsp + 8]
			cdq
			xor	eax, edx
			sub	eax, edx
			ret
	)");

#elif defined __arma32__

	asm (R"(
		.code abs
			ldr	r0, [sp, 0]
			add	r2, r0, r0, asr 31
			eor	r0, r2, r0, asr 31
			bx	lr
	)");

#else

	int std::abs (const int j) noexcept
	{
		return j < 0 ? -j : +j;
	}

#endif

// standard exit function

void std::exit (const int status) noexcept
{
	quick_exit (status);
}

// standard getenv function

char* std::getenv [[ecs::replaceable]] (const char*) noexcept
{
	return nullptr;
}

// standard labs function

long int std::labs (const long int j) noexcept
{
	return j < 0 ? -j : +j;
}

// standard llabs function

#if defined __amd64__

	asm (R"(
		.code llabs
			mov	rax, [rsp + 8]
			cqo
			xor	rax, rdx
			sub	rax, rdx
			ret
	)");

#else

	long long int std::llabs (const long long int j) noexcept
	{
		return j < 0 ? -j : +j;
	}

#endif

// standard quick_exit function

void std::quick_exit (const int status) noexcept
{
	_Exit (status);
}

// standard system function

int std::system [[ecs::replaceable]] (const char*const command) noexcept
{
	return command ? EXIT_FAILURE : 0;
}

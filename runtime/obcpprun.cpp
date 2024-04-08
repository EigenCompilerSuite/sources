// Oberon transpiler runtime support
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

#include "obcpprun.hpp"

#include <cctype>
#include <cstdlib>

using namespace Oberon;
using namespace GLOBAL;

Module::Module (void (*const body) ())
{
	body ();
}

bool Oberon::operator == (const Array<char>& left, const Array<char>& right)
{
	return strcmp (&left[0], &right[0]) == 0;
}

bool Oberon::operator != (const Array<char>& left, const Array<char>& right)
{
	return strcmp (&left[0], &right[0]) != 0;
}

bool Oberon::operator < (const Array<char>& left, const Array<char>& right)
{
	return strcmp (&left[0], &right[0]) < 0;
}

bool Oberon::operator <= (const Array<char>& left, const Array<char>& right)
{
	return strcmp (&left[0], &right[0]) <= 0;
}

bool Oberon::operator > (const Array<char>& left, const Array<char>& right)
{
	return strcmp (&left[0], &right[0]) > 0;
}

bool Oberon::operator >= (const Array<char>& left, const Array<char>& right)
{
	return strcmp (&left[0], &right[0]) >= 0;
}

void GLOBAL::ASSERT (const bool condition, const int status)
{
	if (!condition) std::exit (status);
}

CHAR GLOBAL::CAP (const CHAR character)
{
	return std::toupper (character);
}

CHAR GLOBAL::CHR (const INTEGER integer)
{
	return integer;
}

void GLOBAL::COPY (const Oberon::Array<CHAR>& source, Oberon::Array<CHAR>& target)
{
	std::copy_n (&source[0], std::min (LEN (source), LEN (target)), &target[0]);
	target[LEN (target) - 1] = 0;
}

LONGINT GLOBAL::ENTIER (const LONGREAL real)
{
	return std::floor (real);
}

void GLOBAL::HALT [[noreturn]] (const int status)
{
	std::exit (status);
}

BOOLEAN GLOBAL::ODD (const INTEGER integer)
{
	return integer & 1;
}

INTEGER GLOBAL::ORD (const CHAR character)
{
	using Character = unsigned char;
	return Character (character);
}

void SYSTEM::MOVE (const ADDRESS source, const ADDRESS target, const LENGTH size)
{
	std::memcpy (reinterpret_cast<void*> (target), reinterpret_cast<void*> (source), size);
}

int main ()
{
}

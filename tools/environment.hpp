// Generic environment interface
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

// You should have received a copy of the GNU General Public License
// along with the ECS.  If not, see <https://www.gnu.org/licenses/>.

#ifndef ECS_ENVIRONMENT_HEADER_INCLUDED
#define ECS_ENVIRONMENT_HEADER_INCLUDED

#include <cstddef>
#include <string>

namespace ECS
{
	class Environment;
}

class ECS::Environment
{
public:
	static constexpr std::size_t stdin_ = 0, stdout_ = 1, stderr_ = 2;

	virtual ~Environment () = default;

	virtual int Fflush (std::size_t) {return -1;}
	virtual int Fgetc (std::size_t) {return -1;}
	virtual int Fputc (int, std::size_t) {return -1;}
	virtual int Fputs (const std::string&, std::size_t);
	virtual int Getchar ();
	virtual int Putchar (int);
};

inline int ECS::Environment::Fputs (const std::string& string, const std::size_t stream)
{
	for (auto character: string) if (Fputc (character, stream) == -1) return -1; return 0;
}

inline int ECS::Environment::Getchar ()
{
	return Fgetc (stdin_);
}

inline int ECS::Environment::Putchar (const int character)
{
	return Fputc (character, stdout_);
}

#endif // ECS_ENVIRONMENT_HEADER_INCLUDED

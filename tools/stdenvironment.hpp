// Standard environment interface
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

#ifndef ECS_STANDARDENVIRONMENT_HEADER_INCLUDED
#define ECS_STANDARDENVIRONMENT_HEADER_INCLUDED

#include "environment.hpp"

#include <istream>
#include <ostream>

namespace ECS
{
	class StandardEnvironment;
}

class ECS::StandardEnvironment : public Environment
{
public:
	StandardEnvironment (std::istream& ci, std::ostream& co, std::ostream& ce) : cin {ci}, cout {co}, cerr {ce} {}

private:
	std::istream& cin;
	std::ostream& cout;
	std::ostream& cerr;

	int Fflush (std::size_t) override;
	int Fgetc (std::size_t) override;
	int Fputc (int, std::size_t) override;
};

inline int ECS::StandardEnvironment::Fflush (const std::size_t stream)
{
	return (stream >= stdout_ && stream <= stderr_ && (stream == stderr_ ? cerr : cout).flush ()) - 1;
}

inline int ECS::StandardEnvironment::Fgetc (const std::size_t stream)
{
	char character; return stream == stdin_ && cin.get (character) ? character : -1;
}

inline int ECS::StandardEnvironment::Fputc (const int character, const std::size_t stream)
{
	return stream >= stdout_ && stream <= stderr_ && (stream == stderr_ ? cerr : cout).put (character) ? character : - 1;
}

#endif // ECS_STANDARDENVIRONMENT_HEADER_INCLUDED

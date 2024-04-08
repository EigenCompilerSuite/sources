// Output stream diagnostics
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

#ifndef ECS_STREAMDIAGNOSTICS_HEADER_INCLUDED
#define ECS_STREAMDIAGNOSTICS_HEADER_INCLUDED

#include "diagnostics.hpp"
#include "position.hpp"

namespace ECS
{
	class StreamDiagnostics;

	struct ErrorLimit final {std::size_t messages;};

	std::ostream& EmitMessage (std::ostream&, Diagnostics::Type, const Source&, const Position&);
}

class ECS::StreamDiagnostics : public Diagnostics
{
public:
	explicit StreamDiagnostics (std::ostream& s) : stream {s} {}

	void Emit (Type, const Source&, const Position&, const Message&) override;

private:
	std::size_t errors = 0;
	std::ostream& stream;
};

inline void ECS::StreamDiagnostics::Emit (const Type type, const Source& source, const Position& position, const Message& message)
{
	position.Indicate (EmitMessage (stream, type, source, position) << message << '\n').flush ();
	if (type >= Error && type <= FatalError && ++errors >= 10) throw ErrorLimit {errors};
}

inline std::ostream& ECS::EmitMessage (std::ostream& stream, const Diagnostics::Type type, const Source& source, const Position& position)
{
	stream << source;
	if (const auto line = GetLine (position)) stream << ':' << line;
	if (const auto column = GetColumn (position)) stream << ':' << column;
	static const char*const types[] {"error", "fatal error", "warning", "note"};
	return stream << ": " << types[type] << ": ";
}

#endif // ECS_STREAMDIAGNOSTICS_HEADER_INCLUDED

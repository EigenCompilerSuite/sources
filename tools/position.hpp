// Generic stream position
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

#ifndef ECS_POSITION_HEADER_INCLUDED
#define ECS_POSITION_HEADER_INCLUDED

#include <iosfwd>
#include <memory>
#include <string>

namespace ECS
{
	class Position;

	using Column = std::streamoff;
	using Line = std::streamoff;
	using Source = std::string;

	auto GetColumn (const Position&) -> Column;
	auto GetLine (const Position&) -> Line;
	auto GetPlain (const Position&) -> Position;

	template <typename C, typename T> std::basic_istream<C, T>& Advance (std::basic_istream<C, T>&, Position&, C&);
	template <typename C, typename T> std::basic_istream<C, T>& Regress (std::basic_istream<C, T>&, Position&, C);
}

class ECS::Position
{
public:
	Position (Line = 0, Column = 0);
	template <typename C, typename T> Position (std::basic_ifstream<C, T>&, const Source&, Line, Column);

	void Override (Line);
	template <typename C> void Advance (C);
	template <typename C> void Regress (C);
	template <typename C, typename T> std::basic_ostream<C, T>& Indicate (std::basic_ostream<C, T>&) const;

private:
	Line line;
	Column column;
	std::streamoff newline = 0;
	std::shared_ptr<Source> source;

	friend Line GetLine (const Position&);
	friend Column GetColumn (const Position&);
};

#include <fstream>

inline ECS::Position::Position (const Line l, const Column c) :
	line {l}, column {c}
{
}

template <typename C, typename T>
inline ECS::Position::Position (std::basic_ifstream<C, T>& stream, const Source& s, const Line l, const Column c) :
	Position {l, c}
{
	if (stream) newline = stream.tellg (), source = std::make_shared<Source> (s);
}

template <typename C>
void ECS::Position::Advance (const C character)
{
	if (character == '\n') ++line, newline += column, column = 1; else ++column;
}

template <typename C>
void ECS::Position::Regress (const C character)
{
	if (character == '\n') --line, --newline; else --column;
}

inline void ECS::Position::Override (const Line l)
{
	line = l; column = 1;
}

template <typename C, typename T>
std::basic_ostream<C, T>& ECS::Position::Indicate (std::basic_ostream<C, T>& stream) const
{
	if (!source || !column) return stream;
	std::basic_ifstream<C, T> file {*source, file.binary}; if (!file.is_open () || !file.seekg (newline, file.beg)) return stream;
	Column skip = 1; while (file.good () && (file.peek () == ' ' || file.peek () == '\t')) file.ignore (), ++skip;
	std::basic_string<C, T> contents; for (C character; file.get (character); contents.push_back (character)) if (character == '\n' || character == '\r') break;
	if (std::size_t (column - skip) > contents.size ()) return stream; stream << '\t' << contents << "\n\t";
	contents.resize (column - skip); for (auto& c: contents) if (c != '\t') c = ' '; return stream << contents << "^\n";
}

inline ECS::Line ECS::GetLine (const Position& position)
{
	return position.line;
}

inline ECS::Column ECS::GetColumn (const Position& position)
{
	return position.column;
}

inline ECS::Position ECS::GetPlain (const Position& position)
{
	return {GetLine (position), GetColumn (position)};
}

template <typename C, typename T>
std::basic_istream<C, T>& ECS::Advance (std::basic_istream<C, T>& stream, Position& position, C& character)
{
	if (stream.get (character)) position.Advance (character != '\r' || stream.good () && stream.peek () == '\n' ? character : '\n'); return stream;
}

template <typename C, typename T>
std::basic_istream<C, T>& ECS::Regress (std::basic_istream<C, T>& stream, Position& position, const C character)
{
	if (stream.putback (character)) position.Regress (character); return stream;
}

#endif // ECS_POSITION_HEADER_INCLUDED

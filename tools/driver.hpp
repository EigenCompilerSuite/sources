// Generic driver
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

#ifndef ECS_DRIVER_HEADER_INCLUDED
#define ECS_DRIVER_HEADER_INCLUDED

#include "strdiagnostics.hpp"

#include <filesystem>

namespace ECS
{
	class File;

	struct InvalidInput final {Source source; Message message;};
	struct ProcessAborted final {Message message;};
	struct ProcessFailed final {Message message;};

	int Drive (void (*) (std::istream&, const Source&, const Position&), const char*, int, const char*const [], StreamDiagnostics&, void (*) (const Source&) = nullptr) noexcept;
}

class ECS::File
{
public:
	File (const std::filesystem::path&, const std::filesystem::path&, std::ios_base::openmode = std::ios_base::out);
	~File () noexcept (false);

	operator std::ostream& () {return file;}

	static constexpr auto cur = std::ios_base::cur;
	static constexpr auto binary = std::ios_base::binary;

private:
	const std::filesystem::path path;
	std::ofstream file;
};

#include "error.hpp"
#include "format.hpp"

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <system_error>

inline ECS::File::File (const std::filesystem::path& source, const std::filesystem::path& extension, const std::ios_base::openmode mode) :
	path {source.filename ().replace_extension (extension)}, file {path, mode}
{
	if (!file.is_open ()) throw ProcessAborted {Format ("failed to open output file '%0'", path.string ())};
}

inline ECS::File::~File () noexcept (false)
{
	file.close (); if (!file || std::uncaught_exceptions ()) std::filesystem::remove (path);
	if (!file && !std::uncaught_exceptions ()) throw ProcessAborted {Format ("failed to write output file '%0'", path.string ())};
}

inline int ECS::Drive (void (*const process) (std::istream&, const Source&, const Position&), const char*const name, const int argc, const char*const argv[], StreamDiagnostics& diagnostics, void (*const complete) (const Source&)) noexcept
try
{
	std::ios_base::sync_with_stdio (false);

	auto first = argv[argc];
	for (auto argument = argv + 1; argument < argv + argc; ++argument)
	{
		if (!*argument) continue; if (!first) first = *argument; const Source source {*argument}; std::ifstream file;
		if (std::error_code error; !std::filesystem::is_directory (source, error)) file.open (source, file.binary);
		if (!file.is_open ()) throw ProcessAborted {Format ("failed to open input file '%0'", source)};
		process (file, source, {file, source, 1, 1});
	}

	if (!first)
	{
		std::cout << name << " Version 0.0.40 Build " __DATE__ " Copyright (C) Florian Negele\n"
		"This is free software; see the source for copying conditions. There is NO\n"
		"WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n";
		process (std::cin, first = "stdin", {1, 1}); std::cin.clear ();
	}

	if (complete) complete (first);

	return EXIT_SUCCESS;
}
catch (const ErrorLimit& error)
{
	return diagnostics.Emit (Diagnostics::Note, name, {}, Format ("exiting after %0 errors", error.messages)), EXIT_FAILURE;
}
catch (const InvalidInput& error)
{
	return diagnostics.Emit (Diagnostics::Error, error.source, {}, error.message), EXIT_FAILURE;
}
catch (const ProcessFailed& error)
{
	return diagnostics.Emit (Diagnostics::Error, name, {}, error.message), EXIT_FAILURE;
}
catch (const ProcessAborted& error)
{
	return diagnostics.Emit (Diagnostics::FatalError, name, {}, error.message), EXIT_FAILURE;
}
catch (const std::system_error&)
{
	return diagnostics.Emit (Diagnostics::FatalError, name, {}, "system error"), EXIT_FAILURE;
}
catch (const std::length_error&)
{
	return diagnostics.Emit (Diagnostics::FatalError, name, {}, "out of memory"), EXIT_FAILURE;
}
catch (const std::bad_alloc&)
{
	return diagnostics.Emit (Diagnostics::FatalError, name, {}, "out of memory"), EXIT_FAILURE;
}
catch (const Error&)
{
	return EXIT_FAILURE;
}

#endif // ECS_DRIVER_HEADER_INCLUDED

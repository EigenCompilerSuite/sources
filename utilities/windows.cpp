// Windows system interface
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

#define _WIN32_WINNT 0x0501
#include "system.hpp"

#include <iostream>
#include <windows.h>

const char sys::path_separator {'\\'};
const char sys::program_extension[] {".exe"};

const char* sys::get_name ()
{
	SYSTEM_INFO info;
	GetNativeSystemInfo (&info);
	if (info.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_INTEL) return "win32";
	if (info.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64) return "win64";
	return nullptr;
}

bool sys::path_exists (const std::string& path)
{
	return GetFileAttributes (path.c_str ()) != INVALID_FILE_ATTRIBUTES;
}

bool sys::change_mode (const std::string&)
{
	return true;
}

std::string sys::get_program_path ()
{
	char buffer[32767];
	return {buffer, GetModuleFileName (nullptr, buffer, sizeof buffer)};
}

bool sys::set_variable (const char*const name, const std::string& value)
{
	return SetEnvironmentVariable (name, value.c_str ());
}

std::string sys::get_variable (const char*const name)
{
	char buffer[32767];
	return {buffer, GetEnvironmentVariable (name, buffer, sizeof buffer)};
}

int sys::execute (const std::string& command)
{
	auto line = command; STARTUPINFO si {sizeof (STARTUPINFO)}; PROCESS_INFORMATION pi; DWORD status = EXIT_FAILURE;
	if (CreateProcess (nullptr, &line.front (), nullptr, nullptr, false, 0, nullptr, nullptr, &si, &pi))
		WaitForSingleObject (pi.hProcess, INFINITE), GetExitCodeProcess (pi.hProcess, &status), CloseHandle (pi.hProcess), CloseHandle (pi.hThread);
	return status;
}

static constexpr WORD Red = FOREGROUND_RED | FOREGROUND_INTENSITY, Blue = FOREGROUND_BLUE | FOREGROUND_INTENSITY, Green = FOREGROUND_GREEN | FOREGROUND_INTENSITY, Cyan = Blue | Green, Purple = Red | Blue, Yellow = Red | Green, White = Red | Green | Blue;

static const HANDLE handle = GetStdHandle (STD_OUTPUT_HANDLE);
static const WORD defaultAttribute = [] {CONSOLE_SCREEN_BUFFER_INFO csbi; return GetConsoleScreenBufferInfo (handle, &csbi) ? csbi.wAttributes : White;} ();

std::ostream& sys::blue (std::ostream& stream) {stream.flush (); SetConsoleTextAttribute (handle, defaultAttribute & ~White | Blue); return stream;}
std::ostream& sys::cyan (std::ostream& stream) {stream.flush (); SetConsoleTextAttribute (handle, defaultAttribute & ~White | Cyan); return stream;}
std::ostream& sys::green (std::ostream& stream) {stream.flush (); SetConsoleTextAttribute (handle, defaultAttribute & ~White | Green); return stream;}
std::ostream& sys::purple (std::ostream& stream) {stream.flush (); SetConsoleTextAttribute (handle, defaultAttribute & ~White | Purple); return stream;}
std::ostream& sys::red (std::ostream& stream) {stream.flush (); SetConsoleTextAttribute (handle, defaultAttribute & ~White | Red); return stream;}
std::ostream& sys::standard (std::ostream& stream) {stream.flush (); SetConsoleTextAttribute (handle, defaultAttribute); return stream;}
std::ostream& sys::white (std::ostream& stream) {stream.flush (); SetConsoleTextAttribute (handle, defaultAttribute & ~White | White); return stream;}
std::ostream& sys::yellow (std::ostream& stream) {stream.flush (); SetConsoleTextAttribute (handle, defaultAttribute & ~White | Yellow); return stream;}

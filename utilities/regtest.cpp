// Regression tester
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

#include "system.hpp"

#include <chrono>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <limits>
#include <random>
#include <set>
#include <stdexcept>

struct Test
{
	std::string name;
	std::streamoff line;
	bool positive, succeeded;

	std::istream& Read (std::istream&, std::streamoff&);
	bool operator < (const Test& other) const {return name < other.name;}
};

struct Report
{
	std::size_t tests = 0, succeeded = 0, succeededThisTime = 0, failedThisTime = 0;

	void Add (const Test&, const std::set<Test>&, std::streamsize);
};

struct TemporaryDirectory
{
	std::filesystem::path current, previous;

	TemporaryDirectory ();
	~TemporaryDirectory ();
};

TemporaryDirectory::TemporaryDirectory ()
{
	std::random_device random; std::mt19937 engine {random ()}; std::error_code error; const auto temp = std::filesystem::temp_directory_path (error);
	while (!error && !std::filesystem::create_directory (current = temp / ("regtest-" + std::to_string (engine ())), error));
	if (error || (previous = std::filesystem::current_path (error), error) || (std::filesystem::current_path (current, error), error)) current.clear (), previous.clear ();
}

TemporaryDirectory::~TemporaryDirectory ()
{
	if (std::error_code error; !current.empty ()) std::filesystem::remove_all (current, error);
}

std::istream& Test::Read (std::istream& stream, std::streamoff& currentLine)
{
	while (stream.peek () == '\n' && stream.ignore () || stream.peek () == '#' && stream.ignore (std::numeric_limits<std::streamsize>::max (), '\n')) ++currentLine; line = currentLine;
	std::string type; if (getline (stream, type, ':')) if (type == "positive") positive = true; else if (type == "negative") positive = false; else stream.setstate (stream.failbit);
	while (stream.peek () == ' ' && stream.ignore ()); if (getline (stream, name)) if (name.empty ()) stream.setstate (stream.failbit); else ++currentLine; return stream;
}

void Report::Add (const Test& test, const std::set<Test>& results, const std::streamsize indent)
{
	++tests; succeeded += test.succeeded;

	const auto result = results.find (test);
	if (test.succeeded && result != results.end () && result->succeeded) return;

	std::cout.width (indent); std::cout.fill (' '); std::cout << test.line << ": ";
	if (test.succeeded) ++succeededThisTime, std::cout << sys::green << "success";
	else std::cout << (result != results.end () && result->succeeded ? ++failedThisTime, sys::yellow : sys::red) << "failure";
	std::cout << sys::standard << ": " << test.name << '\n';
}

int main (const int argc, char*const argv[])
try
{
	if (!std::system (nullptr)) return std::cerr << "regtest: fatal error: unavailable command interpreter\n", EXIT_FAILURE;
	if (argc != 4 && argc != 5) return std::cerr << "Usage: regtest command test-file temp-file [result-file]\n", EXIT_FAILURE;

	std::ifstream testFile {argv[2]};
	if (!testFile.is_open ()) return std::cerr << "regtest: error: failed to open test file '" << argv[2] << "'\n", EXIT_FAILURE;

	std::set<Test> tests, results;

	if (argc == 5)
	{
		std::ifstream resultFile {argv[4]};
		for (Test test; getline (resultFile >> test.succeeded >> std::ws, test.name);) results.insert (test);
	}

	std::cout << sys::white << "Output of command '" << argv[1] << "':" << sys::standard << std::endl;

	TemporaryDirectory directory; std::streamoff line = 1;
	auto start = std::chrono::steady_clock::now (), then = start;
	for (Test test; test.Read (testFile, line);)
	{
		std::ofstream tempFile {argv[3]};
		if (!tempFile.is_open ()) return std::cerr << "regtest: error: failed to open temporary file '" << argv[3] << "'\n", EXIT_FAILURE;

		while (testFile.peek () == '\n' && testFile.ignore ()) ++line;
		for (std::string buffer; testFile.peek () == '\t' && testFile.ignore () || testFile.peek () == '\n';)
			if (getline (testFile, buffer)) tempFile << buffer << '\n', ++line;

		if (tempFile.close (), !tempFile) return std::cerr << "regtest: error: failed to write temporary file '" << argv[3] << "'\n", EXIT_FAILURE;

		test.succeeded = (std::system (argv[1]) == EXIT_SUCCESS) == test.positive;

		if (!tests.insert (test).second) return std::cerr << "regtest: error: duplicated test '" << test.name << "' in line " << test.line << '\n', EXIT_FAILURE;

		if (tests.size () >= results.size ()) continue;
		const auto now = std::chrono::steady_clock::now ();
		if (now - then < std::chrono::seconds {10}) continue;
		const auto progress = tests.size () * 1000 / results.size (); then = now;
		std::cout << sys::white << "Progress of command '" << argv[1] << "':" << sys::standard << ' ';
		std::cout << sys::blue << progress / 10 << '.' << progress % 10 << '%' << sys::standard << " (";
		const auto remaining = (results.size () - tests.size ()) * (now - start) / tests.size ();
		if (const auto hours = remaining / std::chrono::hours {1}) std::cout << hours << "h ";
		if (const auto minutes = remaining / std::chrono::minutes {1}) std::cout << minutes % 60 << "m ";
		std::cout << remaining / std::chrono::seconds {1} % 60 << "s remaining)" << std::endl;
	}

	if (!testFile && !testFile.eof ()) return std::cerr << "regtest: error: invalid test description in line " << line << '\n', EXIT_FAILURE;

	if (argc == 5)
	{
		std::ofstream resultFile {directory.previous / argv[4]};
		if (!resultFile.is_open ()) return std::cerr << "regtest: error: failed to open result file '" << argv[4] << "'\n", EXIT_FAILURE;
		for (auto& test: tests) resultFile << test.succeeded << ' ' << test.name << '\n'; resultFile.close ();
		if (!resultFile) return std::cerr << "regtest: error: failed to write result file '" << argv[4] << "'\n", EXIT_FAILURE;
	}

	Report report; const auto indent = std::to_string (line).size ();
	std::cout << sys::white << "\nResults of test suite '" << argv[2] << "':\n" << sys::standard;
	for (auto& test: tests) report.Add (test, results, indent);
	if (!report.tests) std::cout << "no tests executed\n";
	else if (report.tests == report.succeeded && !report.succeededThisTime) std::cout << sys::green << "all tests succeeded\n" << sys::standard;

	std::cout << sys::white << "\nSummary:\n" << sys::standard;
	std::cout << "number of tests: " << report.tests << '\n';
	std::cout << "succeeded tests: " << (report.succeeded ? sys::green : sys::red) << report.succeeded << sys::standard;
	if (!results.empty () && report.succeededThisTime) std::cout << "\t(+" << report.succeededThisTime << ')'; std::cout << '\n';
	std::cout << "failed tests:    " << (report.succeeded == report.tests ? sys::green : sys::red) << report.tests - report.succeeded << sys::standard;
	if (!results.empty () && report.failedThisTime) std::cout << "\t(+" << report.failedThisTime << ')'; std::cout << '\n';

	if (report.tests && report.tests != report.succeeded) return EXIT_FAILURE;
}
catch (const std::length_error&)
{
	return std::cerr << "regtest: fatal error: out of memory\n", EXIT_FAILURE;
}
catch (const std::bad_alloc&)
{
	return std::cerr << "regtest: fatal error: out of memory\n", EXIT_FAILURE;
}

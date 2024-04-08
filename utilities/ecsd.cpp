// Eigen Compiler Suite Driver
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

#include <cctype>
#include <cstdlib>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <vector>

using namespace std::string_literals;

struct Source
{
	enum {Assembly, Code, CPP, Debugging, False, Map, Oberon, Object};

	const char*const extensions[8];
	const char*const description;
	const char*const frontend;
	const bool information;
	std::string files;
};

static Source sources[] {
	{{".asm", ".lst"}, "Assembly code", "asm", false},
	{{".cod"}, "Intermediate code", "cd", true},
	{{".cpp", ".cxx", ".cc", ".c", ".hpp", ".hxx", ".hh", ".h"}, "C++ source file", "cpp", true},
	{{".dbg"}, "Debugging information file"},
	{{".fal", ".f"}, "FALSE program", "fal", false},
	{{".map"}, "Linker map file"},
	{{".mod", ".m"}, "Oberon module", "ob", true},
	{{".obf", ".dbf", ".lib", ".msr"}, "Object file"},
};

struct Target
{
	enum {AMD32Linux, AMD64Linux, ARMA32Linux, ARMA64Linux, ARMT32Linux, ARMT32FPELinux, AT32UC3A3, ATmega32, ATmega328, ATmega8515, BIOS16, BIOS32, BIOS64, Code, DOS, EFI32, EFI64, MIPS32Linux, MMIXSim, OR1KSim, OSX32, OSX64, RISCDisk, RPi2B, Win32, Win64};

	const char*const name;
	const char*const backend;
	const char*const architecture;
	const char*const linker;
	const bool executable;
	const char*const description;
	const char*const converter;
};

static Target targets[] {
	{"amd32linux", "amd32", "amd32", "linkbin", true, "Linux-based 32-bit systems", "dbgdwarf"},
	{"amd64linux", "amd64", "amd64", "linkbin", true, "Linux-based 64-bit systems", "dbgdwarf"},
	{"arma32linux", "arma32", "arma32", "linkbin", true, "Linux-based systems", "dbgdwarf"},
	{"arma64linux", "arma64", "arma64", "linkbin", true, "Linux-based systems", "dbgdwarf"},
	{"armt32linux", "armt32", "armt32", "linkbin", true, "Linux-based systems", "dbgdwarf"},
	{"armt32fpelinux", "armt32fpe", "armt32", "linkbin", true, "Linux-based systems", "dbgdwarf"},
	{"at32uc3a3", "avr32", "avr32", "linkhex", false, "AT32UC3A3 microcontrollers"},
	{"atmega32", "avr", "avr", "linkhex", false, "ATmega32 microcontrollers"},
	{"atmega328", "avr", "avr", "linkhex", false, "ATmega328 microcontrollers"},
	{"atmega8515", "avr", "avr", "linkhex", false, "ATmega8515 microcontrollers"},
	{"bios16", "amd16", "amd16", "linkbin", false, "BIOS-based 16-bit systems"},
	{"bios32", "amd32", "amd32", "linkbin", false, "BIOS-based 32-bit systems"},
	{"bios64", "amd64", "amd64", "linkbin", false, "BIOS-based 64-bit systems"},
	{"code", "code", "code", "cdrun", false, "Intermediate code interpreter"},
	{"dos", "amd16", "amd16", "linkbin", false, "DOS systems"},
	{"efi32", "amd32", "amd32", "linkbin", false, "EFI-based 32-bit systems"},
	{"efi64", "amd64", "amd64", "linkbin", false, "EFI-based 64-bit systems"},
	{"mips32linux", "mips32", "mips32", "linkbin", true, "Linux-based systems", "dbgdwarf"},
	{"mmixsim", "mmix", "mmix", "linkbin", false, "MMIX simulator"},
	{"or1ksim", "or1k", "or1k", "linkbin", true, "OpenRISC 1000 simulator"},
	{"osx32", "amd32", "amd32", "linkbin", true, "32-bit OS X systems", "dbgdwarf"},
	{"osx64", "amd64", "amd64", "linkbin", true, "64-bit OS X systems", "dbgdwarf"},
	{"riscdisk", "risc", "risc", "linkbin", false, "RISC microcontrollers"},
	{"rpi2b", "arma32", "arma32", "linkbin", false, "Raspberry Pi 2 Model B"},
	{"tos", "m68k", "m68k", "linkprg", false, "Atari TOS"},
	{"webassembly", "wasm", "wasm", "linkbin", false, "WebAssembly environments"},
	{"win32", "amd32", "amd32", "linkbin", false, "32-bit Windows systems"},
	{"win64", "amd64", "amd64", "linkbin", false, "64-bit Windows systems"},

	#define BACKEND(name) TARGET (name, name)
	#define TARGET(backend, architecture) {#backend, #backend, #architecture, "linkbin"}
	BACKEND (amd16), BACKEND (amd32), BACKEND (amd64),
	BACKEND (arma32), BACKEND (arma64), BACKEND (armt32), TARGET (armt32fpe, armt32),
	BACKEND (avr),
	BACKEND (avr32),
	BACKEND (m68k),
	BACKEND (mibl),
	BACKEND (mips32), BACKEND (mips64),
	BACKEND (mmix),
	BACKEND (or1k),
	BACKEND (ppc32), BACKEND (ppc64),
	BACKEND (risc),
	BACKEND (wasm),
	#undef BACKEND
	#undef TARGET
};

struct Option
{
	enum {Base, Compile, CPP, Disassemble, Generate, Help, Invoke, Library, Make, Output, Oberon, Protect, Runtime, Source, Target, Verbose};

	const char*const name;
	const bool exclusive;
	const char*const description;
	const char*const argument;
	const char* value;
};

static Option options[] {
	{"base", false, "Use the specified base directory.", "directory"},
	{"compile", true, "Compile and assemble only."},
	{"C++", false, "Include or exclude runtime support for C++."},
	{"disassemble", true, "Invoke the disassembler instead of the linker."},
	{"generate", false, "Generate and include debugging information."},
	{"help", false, "Print this information and exit."},
	{"invoke", true, "Invoke the specified tool only.", "tool"},
	{"library", true, "Create a library instead of an executable file."},
	{"make", false, "Build all dependencies before compiling."},
	{"output", false, "Link using the specified output file format.", "format"},
	{"Oberon", false, "Include or exclude runtime support for Oberon."},
	{"protect", false, "Do not automatically set environment variables."},
	{"runtime", false, "Include the specified runtime support.", "support"},
	{"source", false, "Use the specified source type for unknown input files.", "type"},
	{"target", false, "Target the specified environment for cross compiling.", "environment"},
	{"verbose", false, "Print the command line before invoking tools."},
};

static Source* source;
static Target* target;
static Option* exclusive;
static bool ecsinclude, ecsimport;
static std::vector<std::string> support;
static std::string base, tools, runtime, import, include, result;

static bool IsAvailable (const Source& source)
{
	if (options[Option::Make].value) return &source != &sources[Source::Debugging] || target->converter;
	if (&source == &sources[Source::Code] && target == &targets[Target::Code]) return sys::path_exists (base + tools + target->linker + sys::program_extension);
	if (&source == &sources[Source::Debugging]) return target && target->converter && sys::path_exists (base + tools + target->converter + sys::program_extension);
	if (&source == &sources[Source::Map]) return target && target != &targets[Target::Code] && sys::path_exists (base + tools + "mapsearch" + sys::program_extension);
	if (&source == &sources[Source::Object]) return target && target != &targets[Target::Code] && sys::path_exists (base + tools + target->linker + sys::program_extension);
	if (&source == &sources[Source::Assembly]) return target && target != &targets[Target::Code] && sys::path_exists (base + tools + target->architecture + source.frontend + sys::program_extension);
	return target && sys::path_exists (base + tools + source.frontend + target->backend + sys::program_extension);
}

static bool IsAvailable (const Target& target)
{
	if (options[Option::Make].value) return true;
	if (&target == &targets[Target::Code]) return sys::path_exists (base + tools + target.linker + sys::program_extension);
	return sys::path_exists (base + runtime + target.name + "run.obf") && sys::path_exists (base + runtime + target.backend + "run.obf") && sys::path_exists (base + tools + target.linker + sys::program_extension);
}

static bool IsAvailable (const Option& option)
{
	if (&option == &options[Option::Make]) return sys::path_exists (base + "makefile"); if (options[Option::Make].value) return true;
	if (&option == &options[Option::Disassemble]) return target && sys::path_exists (target == &targets[Target::Code] ? base + tools + "asmprint" + sys::program_extension : base + tools + target->architecture + "dism" + sys::program_extension);
	if (&option == &options[Option::Generate]) return target && target->converter && sys::path_exists (base + tools + target->converter + sys::program_extension);
	if (&option == &options[Option::CPP]) return target && sys::path_exists (base + runtime + sources[Source::CPP].frontend + target->backend + "run.lib");
	if (&option == &options[Option::Oberon]) return target && sys::path_exists (base + runtime + sources[Source::Oberon].frontend + target->backend + "run.lib");
	if (&option == &options[Option::Library]) return sys::path_exists (base + tools + "linklib" + sys::program_extension);
	return true;
}

static void Check (Option& option, char*& value)
{
	if (option.value) throw "option --"s + option.name + " already specified";
	else if (!option.argument) option.value = option.description;
	else if (!value || !*value || *value == '-') throw "unspecified "s + option.argument + " for option --" + option.name;
	else if (&option == &options[Option::Runtime]) support.emplace_back (value), value = nullptr;
	else option.value = value, value = nullptr;
	if (option.exclusive) if (exclusive) throw "exclusive options --"s + exclusive->name + " and --" + option.name; else exclusive = &option;
}

static void Parse (const char flag, char*& value)
{
	for (auto& option: options) if (flag == option.name[0]) return Check (option, value);
	throw "invalid option -"s + flag;
}

static void Parse (const char* argument, char*& value)
{
	if (!argument || *argument != '-') return; if (!*++argument) throw "missing option"s;
	if (*argument != '-') {while (*argument) Parse (*argument, value), ++argument; return;} ++argument;
	for (auto& option: options) if (!std::strcmp (argument, option.name)) return Check (option, value);
	throw "unrecognized option --"s + argument;
}

static std::string GetBaseDirectory ()
{
	auto path = sys::get_variable ("ECSBASE");
	if (!path.empty ()) return path;
	path = sys::get_program_path ();
	auto separator = path.rfind (sys::path_separator);
	if (separator == path.npos) return {};
	path.resize (separator); separator = path.rfind (sys::path_separator);
	if (separator == path.npos || path.substr (separator + 1) != "utilities" && path.substr (separator + 1) != "bin") return {};
	path.resize (separator); return path;
}

static void Execute (const std::string& command)
{
	if (options[Option::Verbose].value) std::cerr << "ecsd: note: " << command << '\n';
	if (sys::execute (command) != EXIT_SUCCESS) throw EXIT_FAILURE;
}

static void Set (const char*const name, const std::string& value)
{
	if (options[Option::Protect].value) return;
	if (options[Option::Verbose].value) std::cerr << "ecsd: note: " << name << '=' << value << '\n';
	if (!sys::set_variable (name, value)) throw "failed to set environment variable '"s + name + '\'';
}

static void Add (const char*const name, const std::string& value)
{
	const auto variable = sys::get_variable (name);
	Set (name, variable.empty () ? value : value + ';' + variable);
}

static std::string Quote (const std::string& file)
{
	return file.find (' ') != file.npos ? '"' + file + (file.back () == '\\' ? "\\\"" : "\"") : file;
}

static void Build (const std::string& file)
{
	if (base.empty ()) Execute ("make -f makefile -s " + file); else Execute ("make -C " + Quote (base) + " -f makefile -s " + file);
}

static void Invoke (const std::string& tool, const std::string& file)
{
	if (options[Option::Make].value) Build (tools + tool + sys::program_extension);
	if (tool.find (sys::path_separator) != tool.npos || !sys::path_exists (base + tools + tool + sys::program_extension)) throw "tool '"s + tool + "' does not exist";
	if (!tool.compare (0, 3, sources[Source::CPP].frontend) && !ecsinclude) ecsinclude = true, Add ("ECSINCLUDE", base + include);
	if (!tool.compare (0, 2, sources[Source::Oberon].frontend) && !ecsimport) ecsimport = true, Set ("ECSIMPORT", base + import);
	Execute (Quote (base + tools + tool + sys::program_extension) + ' ' + file);
}

static void Append (Source& source, const std::string& file)
{
	if (!source.files.empty ()) source.files.push_back (' '); source.files.append (Quote (file));
}

static bool IsEqual (const char* left, const char* right)
{
	while (*left && std::tolower (*left) == std::tolower (*right)) ++left, ++right;
	return !*left && !*right;
}

static void Process (const char*const argument)
{
	if (!argument || *argument == '-') return;
	if (!sys::path_exists (argument)) throw "input file '"s + argument + "' does not exist";

	if (options[Option::Invoke].value) return Append (sources[Source::Code], argument);

	const char* path = std::strrchr (argument, sys::path_separator);
	if (path) ++path; else path = argument;
	const char*const extension = std::strrchr (path, '.');
	const auto base = extension ? std::string {path, extension} : path;
	if (result.empty ()) result = base;

	auto selection = source;
	if (extension) for (auto& source: sources) for (auto entry: source.extensions) if (entry && IsEqual (entry, extension)) selection = &source;
	if (!selection || !IsAvailable (*selection)) throw "unknown input file '"s + argument + '\'';

	if (selection == &sources[Source::Code] && target == &targets[Target::Code]) return Append (sources[Source::Object], argument);

	Append (*selection, argument);
	if (selection == &sources[Source::Map]) Append (sources[Source::Object], argument);
	if (selection == &sources[Source::Debugging]) Append (sources[Source::Object], base + sources[Source::Object].extensions[1]);
	if (selection->frontend) Append (sources[Source::Object], base + sources[target == &targets[Target::Code] ? Source::Code : Source::Object].extensions[0]);
	if (selection->information && options[Option::Generate].value) Append (sources[Source::Debugging], base + sources[Source::Debugging].extensions[0]), Append (sources[Source::Object], base + sources[Source::Object].extensions[1]);
}

static void Compile (const Source& source)
{
	Invoke (&source == &sources[Source::Assembly] ? std::string {target->architecture} + source.frontend : std::string {source.frontend} + target->backend, source.files);
}

static void Disassemble (const std::string& file)
{
	Invoke (target == &targets[Target::Code] ? "asmprint" : target->architecture + "dism"s, file);
}

static void Combine (const std::string& library)
{
	if (options[Option::Make].value) Build (library);
	Append (sources[Source::Object], base + library);
}

static void Search (const bool disassemble)
{
	Invoke ("mapsearch", sources[Source::Object].files);
	if (disassemble) Disassemble (Quote (result + sources[Source::Object].extensions[3]));
}

static void MakeExecutable (const std::string& file)
{
	if (options[Option::Verbose].value) std::cerr << "ecsd: note: chmod +x " << Quote (file) << '\n';
	if (!sys::change_mode (file)) throw "failed to change mode of file '"s + file + '\'';
}

static void Print (const Option& option)
{
	std::cout << "  -" << option.name[0] << ", --" << std::setw (13) << option.name << option.description << '\n';
}

static void Print (const Option& option, const bool brackets, const bool bar, const bool dash, const bool dots, const bool newline)
{
	if (brackets) std::cout << '['; if (bar) std::cout << '|'; if (dash) std::cout << '-';
	std::cout << option.name[0]; if (option.argument) std::cout << ' ' << option.argument;
	if (brackets) std::cout << ']'; if (dots) std::cout << "..."; if (newline) std::cout << "\n  "; else if (brackets) std::cout << ' ';
}

static void Print (const Target& target)
{
	if (target.description) std::cout << "  " << std::setw (16) << target.name << target.description << " (" << target.backend << ")\n";
}

static void Print (const Source& source)
{
	std::cout << "  " << std::setw (5) << source.extensions[0] + 1 << source.description;
	if (source.frontend) if (&source == &sources[Source::Assembly]) std::cout << " (-" << source.frontend << ')'; else std::cout << " (" << source.frontend << "-)";
	std::cout << ':'; for (auto& extension: source.extensions) if (extension) std::cout << " *" << extension; else break; std::cout << '\n';
}

template <typename Array>
static void Print (const Array& array)
{
	auto none = true;
	for (auto& entry: array) if (IsAvailable (entry)) Print (entry), none = false;
	if (none) std::cout << "  none\n";
}

static void Help ()
{
	std::cout << std::setfill (' ') << std::left;
	std::cout << "ecsd Version 0.0.40 Build " __DATE__ " Copyright (C) Florian Negele\n";
	std::cout << "This is free software; see the source for copying conditions. There is NO\n";
	std::cout << "WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n";

	std::cout << "\nUsage: ecsd [";
	for (auto& option: options) if (option.exclusive && IsAvailable (option)) Print (option, false, &option != &options[Option::Compile], true, false, false);
	std::cout << "] [-";
	for (auto& option: options) if (!option.exclusive && !option.argument && IsAvailable (option)) Print (option, false, false, false, false, false);
	std::cout << "] ";
	for (auto& option: options) if (!option.exclusive && option.argument && IsAvailable (option)) Print (option, true, false, true, &option == &options[Option::Runtime], &option == &options[Option::Output]);
	std::cout << "[input-file]...\n";

	std::cout << "\nAvailable options:\n";
	Print (options);

	std::cout << "\nSupported source types";
	if (target) std::cout << " for " << (target->description ? target->description : "freestanding environments") << " (" << target->backend << ')';
	std::cout << ":\n";
	Print (sources);

	std::cout << "\nAvailable target environments:\n";
	Print (targets);
}

int main (int argc, char* argv[])
try
{
	for (auto argument = argv + 1; argument < argv + argc; ++argument) Parse (argument[0], argument[1]);

	if (options[Option::Base].value) base = options[Option::Base].value; else base = GetBaseDirectory ();
	if (!base.empty () && base.back () != sys::path_separator) base.push_back (sys::path_separator);
	tools = "tools"; tools.push_back (sys::path_separator); runtime = "runtime"; runtime.push_back (sys::path_separator);
	import = "libraries"; import.push_back (sys::path_separator); import.append ("oberon"); import.push_back (sys::path_separator);
	include = "libraries"; include.push_back (sys::path_separator); include.append ("cpp"); include.push_back (sys::path_separator);

	if (!options[Option::Target].value) options[Option::Target].value = sys::get_name ();
	if (options[Option::Target].value) for (auto& candidate: targets) if (!std::strcmp (options[Option::Target].value, candidate.name) && IsAvailable (candidate)) target = &candidate;
	if (options[Option::Source].value) for (auto& candidate: sources) if (!std::strcmp (options[Option::Source].value, candidate.extensions[0] + 1) && IsAvailable (candidate)) source = &candidate;

	if (options[Option::Help].value) return Help (), EXIT_SUCCESS;

	if (!base.empty () && !sys::path_exists (base)) throw "base directory '"s + base + "' does not exist";
	if (!sys::path_exists (base + tools)) throw "tools directory '"s + base + tools + "' does not exist";
	if (!sys::path_exists (base + runtime)) throw "runtime directory '"s + base + runtime + "' does not exist";
	if (!target && !options[Option::Invoke].value) throw options[Option::Target].value ? "invalid target environment '"s + options[Option::Target].value + '\'' : "unknown runtime environment"s;
	if (options[Option::Generate].value && target && !target->converter) throw "unsupported debugging environment"s;
	if (!source && options[Option::Source].value) throw "invalid source type '"s + options[Option::Source].value + '\'';
	for (auto& library: support) if (library.find (sys::path_separator) != library.npos || !options[Option::Make].value && !sys::path_exists (base + runtime + library)) throw "runtime support '"s + library + "' does not exist";

	for (auto argument = argv + 1; argument < argv + argc; ++argument) Process (*argument);
	if (options[Option::Invoke].value) return Invoke (options[Option::Invoke].value, sources[Source::Code].files), EXIT_SUCCESS;
	if (sources[Source::Object].files.empty ()) throw "missing input file"s;
	for (auto& source: sources) if (source.frontend && !source.files.empty ()) Compile (source);
	if (!sources[Source::Debugging].files.empty ()) Invoke (target->converter, sources[Source::Debugging].files);

	if (options[Option::Compile].value && sources[Source::Map].files.empty ()) return EXIT_SUCCESS;
	if (options[Option::Disassemble].value && sources[Source::Map].files.empty ()) return Disassemble (sources[Source::Object].files), EXIT_SUCCESS;
	if (options[Option::Library].value) return Invoke ("linklib", sources[Source::Object].files), EXIT_SUCCESS;

	if (sources[Source::CPP].files.empty () != !options[Option::CPP].value) Combine (runtime + sources[Source::CPP].frontend + target->backend + "run.lib");
	if (sources[Source::Oberon].files.empty () != !options[Option::Oberon].value) Combine (runtime + sources[Source::Oberon].frontend + target->backend + "run.lib");
	Combine (runtime + target->backend + "run.obf");
	if (std::strcmp (target->name, target->backend)) Combine (runtime + target->name + "run.obf");
	for (auto& library: support) Combine (runtime + library);

	if (!sources[Source::Map].files.empty ()) return Search (options[Option::Disassemble].value), EXIT_SUCCESS;
	if (options[Option::Output].value) return Invoke ("link"s + options[Option::Output].value, sources[Source::Object].files), EXIT_SUCCESS;

	Invoke (target->linker, sources[Source::Object].files);
	if (target->executable) MakeExecutable (result);
}
catch (const std::string& message)
{
	std::cerr << "ecsd: error: " << message << '\n';
	if (tools.empty () || argc == 1) std::cerr << "Try '" << (argv[0] && argv[0][0] ? argv[0] : "ecsd") << " --" << options[Option::Help].name << "' for more information.\n";
	return EXIT_FAILURE;
}
catch (const std::length_error&)
{
	return std::cerr << "ecsd: fatal error: out of memory\n", EXIT_FAILURE;
}
catch (const std::bad_alloc&)
{
	return std::cerr << "ecsd: fatal error: out of memory\n", EXIT_FAILURE;
}
catch (const int status)
{
	return status;
}

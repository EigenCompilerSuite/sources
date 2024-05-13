# Eigen Compiler Suite makefile
# Copyright (C) Florian Negele

# This file is part of the Eigen Compiler Suite.

# The ECS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# The ECS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with the ECS.  If not, see <https://www.gnu.org/licenses/>.

all: tools runtime utilities
commit: tools runtime utilities documentation checks tests
.PHONY: all commit tools utilities runtime documentation tests checks clean depwalk install uninstall

.SUFFIXES: # delete the default suffixes
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

# common definitions

LANGUAGES := cd cpp fal ob asm
LANGUAGENAMES := CODE CPP FALSE OBERON ASSEMBLY
PREPROCESSORS := $(filter cppprep, $(foreach LANGUAGE, $(LANGUAGES), $(LANGUAGE)prep))
PRINTERS := $(filter-out cdprint, $(foreach LANGUAGE, $(LANGUAGES), $(LANGUAGE)print))
CHECKERS := $(filter-out asmcheck, $(foreach LANGUAGE, $(LANGUAGES), $(LANGUAGE)check))
SERIALIZERS := $(filter-out cddump asmdump, $(foreach LANGUAGE, $(LANGUAGES), $(LANGUAGE)dump))
INTERPRETERS := $(filter-out asmrun, $(foreach LANGUAGE, $(LANGUAGES), $(LANGUAGE)run))
TRANSPILERS := $(filter-out cdcpp cppcpp asmcpp, $(foreach LANGUAGE, $(LANGUAGES), $(LANGUAGE)cpp))

EXTRACTORS := doc cpp ob
EXTRACTORNAMES := DOCUMENTATION CPP OBERON
FORMATTERS := doc html latex
FORMATTERNAMES := DOCUMENTATION HTML LATEX
GENERATORS := $(filter-out docdoc, $(foreach EXTRACTOR, $(EXTRACTORS), $(addprefix $(EXTRACTOR), $(FORMATTERS))))

FRONTENDS := cd cpp fal ob
FRONTENDNAMES := CODE CPP FALSE OBERON
BACKENDS := code amd16 amd32 amd64 arma32 arma64 armt32 armt32fpe avr avr32 m68k mibl mips32 mips64 mmix or1k ppc32 ppc64 risc wasm xtensa
BACKENDNAMES := CODE AMD16 AMD32 AMD64 ARMA32 ARMA64 ARMT32 ARMT32FPE AVR AVR32 M68K MICROBLAZE MIPS32 MIPS64 MMIX OR1K POWERPC32 POWERPC64 RISC WEBASSEMBLY XTENSA
COMPILERS := $(filter-out cdcode, $(foreach FRONTEND, $(FRONTENDS), $(addprefix $(FRONTEND), $(BACKENDS))))

TARGETS := $(filter-out code, $(BACKENDS))
TARGETNAMES := $(filter-out CODE, $(BACKENDNAMES))

DEBUGFILEFORMATS := dwarf
DEBUGFILEFORMATNAMES := DWARF
CONVERTERS := $(foreach DEBUGFILEFORMAT, $(DEBUGFILEFORMATS), dbg$(DEBUGFILEFORMAT))

ARCHITECTURES := $(filter-out armt32fpe, $(TARGETS))
ARCHITECTURENAMES := $(filter-out ARMT32FPE, $(TARGETNAMES))
ASSEMBLERS := $(addsuffix asm, $(ARCHITECTURES))
DISASSEMBLERS := $(addsuffix dism, $(ARCHITECTURES))

LINKFILEFORMATS := lib bin mem hex prg
LINKFILEFORMATNAMES := LIBRARY BINARY MEMORY INTELHEX GEMDOS
LINKERS := $(foreach LINKFILEFORMAT, $(LINKFILEFORMATS), link$(LINKFILEFORMAT))

ENVIRONMENTS := amd32linux amd64linux arma32linux arma64linux armt32linux armt32fpelinux at32uc3a3 atmega32 atmega328 atmega8515 bios16 bios32 bios64 dos efi32 efi64 mips32linux mmixsim or1ksim osx32 osx64 riscdisk rpi2b tos webassembly win32 win64 xtensalinux
ENVIRONMENTTARGETS := amd32 amd64 arma32 arma64 armt32 armt32fpe avr32 avr avr avr amd16 amd32 amd64 amd16 amd32 amd64 mips32 mmix or1k amd32 amd64 risc arma32 m68k wasm amd32 amd64 xtensa
ENVIRONMENTARCHITECTURES := amd32 amd64 arma32 arma64 armt32 armt32 avr32 avr avr avr amd16 amd32 amd64 amd16 amd32 amd64 mips32 mmix or1k amd32 amd64 risc arma32 m68k wasm amd32 amd64 xtensa

# environment & toolchain

ifdef windir

	CP := copy
	RM := del
	TC := type nul >

	PRG := .exe
	DIR = $(subst /,\,$1)
	DIRP = $(subst /,\\,$1)
	ESC = $(strip $1)
	NUL := nul

	ENVIRONMENT := windows.cpp

	ifdef CommonProgramFiles(x86)
		HOSTENVIRONMENTS := win32 win64
	else
		HOSTENVIRONMENTS := dos win32
	endif

	ifndef toolchain
		toolchain := msvc
	endif

else

	CP := cp -f
	RM := rm -f
	TC := touch

	PRG :=
	DIR = $1
	DIRP = $1
	ESC = \$(strip $1)
	NUL := /dev/null

	KERNEL := $(shell uname -s)
	ifeq "$(KERNEL)" "Linux"

		ENVIRONMENT := linux.cpp posix.cpp

		MACHINE := $(shell uname -m)
		ifeq "$(MACHINE)" "i686"
			HOSTENVIRONMENTS := amd32linux
		else ifeq "$(MACHINE)" "x86_64"
			HOSTENVIRONMENTS := amd64linux
		else ifeq "$(MACHINE)" "armv7l"
			HOSTENVIRONMENTS := arma32linux armt32linux armt32fpelinux
		else ifeq "$(MACHINE)" "armv8l"
			HOSTENVIRONMENTS := arma32linux armt32linux armt32fpelinux
		else ifeq "$(MACHINE)" "aarch64"
			HOSTENVIRONMENTS := arma64linux
		else ifeq "$(MACHINE)" "mips"
			HOSTENVIRONMENTS := mips32linux
		else
			HOSTENVIRONMENTS :=
		endif

		ifndef toolchain
			toolchain := gcc
		endif

	else ifeq "$(KERNEL)" "Darwin"

		ENVIRONMENT := osx.cpp posix.cpp
		HOSTENVIRONMENTS := osx32 osx64

		ifndef toolchain
			toolchain := clang
		endif

	else ifeq "$(KERNEL)" "FreeBSD"

		ENVIRONMENT := freebsd.cpp posix.cpp
		HOSTENVIRONMENTS :=

		ifndef toolchain
			toolchain := clang
		endif

	else
		ENVIRONMENT := $(error unknown host environment)
	endif

endif

ifeq "$(toolchain)" "ecs"

	O := .obf
	CC := ecsd
	LD := ecsd

	CFLAGS = -c -s cpp
	LFLAGS = -C

	CCHECKFLAGS := -i cppcheck
	CRUNFLAGS := -c
	LRUNFLAGS := -C

else ifeq "$(toolchain)" "gcc"

	O := .o
	CC := g++
	LD := g++

	COMMONFLAGS := -c -pipe -x c++ -std=c++17 --pedantic -Wfatal-errors

	CFLAGS = $(COMMONFLAGS) -Werror -Wall -Wextra -Wmissing-noreturn -Wno-switch -Wno-empty-body -Wno-parentheses -Wzero-as-null-pointer-constant -Wno-missing-field-initializers -Wno-return-type -Wno-misleading-indentation -Wno-psabi -Wno-implicit-fallthrough -Wno-suggest-attribute=noreturn -o $(notdir $@)
	LFLAGS = -o $(notdir $@)

	CCHECKFLAGS := $(COMMONFLAGS) -fsyntax-only
	CRUNFLAGS := $(COMMONFLAGS)
	LRUNFLAGS := -o

else ifeq "$(toolchain)" "clang"

	O := .o
	CC := clang++
	LD := clang++

	COMMONFLAGS := -c -pipe -x c++ -std=c++17 -pedantic -Wfatal-errors -Wno-nested-anon-types

	CFLAGS = $(COMMONFLAGS) -Wall -Wextra -Wmissing-noreturn -Wno-switch -Wno-empty-body -Wno-parentheses -Wno-dangling-else -Wno-unused-private-field -Wno-missing-field-initializers -Wno-overloaded-virtual -Wno-missing-braces -Wno-misleading-indentation -Wno-bitwise-instead-of-logical -o $(notdir $@)
	LFLAGS = -Wno-unused-command-line-argument -o $(notdir $@)

	CCHECKFLAGS := $(COMMONFLAGS) -fsyntax-only -Wno-dangling-else -Wno-parentheses
	CRUNFLAGS := $(COMMONFLAGS)
	LRUNFLAGS := -Wno-unused-command-line-argument -o

else ifeq "$(toolchain)" "msvc"

	O := .obj
	CC := cl
	LD := link

	COMMONFLAGS := /EHsc /Wp64 /WL /W4 /wd4267 /wd4611 /wd4800 /GF /GR /J /c /TP

	CFLAGS = $(COMMONFLAGS) /Za /WX /Fo$(notdir $@)
	LFLAGS = /nologo /machine:x86 /out:$(notdir $@)

	CCHECKFLAGS := $(COMMONFLAGS) /we4002 /we4003 /we4005 /Za /Zs
	CRUNFLAGS := $(COMMONFLAGS)
	LRUNFLAGS := /nologo /machine:x86 /out:

else
	CC := $(error unknown toolchain)
endif

# tools & utilities

TOOLS := $(call DIR,tools/)
TOOLSP := $(call DIRP,tools/)
UTILITIES := $(call DIR,utilities/)
UTILITIESP := $(call DIRP,utilities/)

BIN := $(addprefix $(TOOLS), $(addsuffix $(PRG), mapsearch docprint doccheck cdopt \
	$(PREPROCESSORS) $(PRINTERS) $(CHECKERS) $(SERIALIZERS) $(INTERPRETERS) $(TRANSPILERS) $(GENERATORS) $(COMPILERS) $(CONVERTERS) $(ASSEMBLERS) $(DISASSEMBLERS) $(LINKERS))) \
	$(addprefix $(UTILITIES), $(addsuffix $(PRG), depwalk ecsd hexdump linecheck regtest))
SRC := $(addprefix $(TOOLS), object.cpp objlinker.cpp objmap.cpp objhexfile.cpp mapsearch.cpp debugging.cpp dbgconverter.cpp dbgdwarfconverter.cpp \
	documentation.cpp doclexer.cpp docparser.cpp docprinter.cpp docprint.cpp docchecker.cpp doccheck.cpp docextractor.cpp dochtmlformatter.cpp doclatexformatter.cpp \
	code.cpp cdchecker.cpp cdoptimizer.cpp cdopt.cpp cdinterpreter.cpp cdemitter.cpp cdgenerator.cpp xml.cpp xmlprinter.cpp xmlserializer.cpp \
	cpp.cpp cpplexer.cpp cpppreprocessor.cpp cppparser.cpp cppprinter.cpp cppchecker.cpp cppserializer.cpp cppinterpreter.cpp cppextractor.cpp cppemitter.cpp \
	false.cpp fallexer.cpp falparser.cpp falprinter.cpp falserializer.cpp falinterpreter.cpp faltranspiler.cpp falemitter.cpp \
	oberon.cpp oblexer.cpp obparser.cpp obprinter.cpp obchecker.cpp obserializer.cpp obinterpreter.cpp obtranspiler.cpp obextractor.cpp obemitter.cpp \
	assembly.cpp asmlexer.cpp asmparser.cpp asmprinter.cpp asmchecker.cpp asmassembler.cpp asmdisassembler.cpp asmgenerator.cpp \
	amd64.cpp amd64assembler.cpp amd64disassembler.cpp amd64generator.cpp arm.cpp arma32.cpp arma32assembler.cpp arma32disassembler.cpp armgenerator.cpp arma32generator.cpp \
	arma64.cpp arma64assembler.cpp arma64disassembler.cpp arma64generator.cpp armt32.cpp armt32assembler.cpp armt32disassembler.cpp armt32generator.cpp \
	avr.cpp avrassembler.cpp avrdisassembler.cpp avrgenerator.cpp avr32.cpp avr32assembler.cpp avr32disassembler.cpp avr32generator.cpp \
	m68k.cpp m68kassembler.cpp m68kdisassembler.cpp m68kgenerator.cpp mibl.cpp miblassembler.cpp mibldisassembler.cpp miblgenerator.cpp \
	mips.cpp mipsassembler.cpp mipsdisassembler.cpp mipsgenerator.cpp mmix.cpp mmixassembler.cpp mmixdisassembler.cpp mmixgenerator.cpp \
	or1k.cpp or1kassembler.cpp or1kdisassembler.cpp or1kgenerator.cpp ppc.cpp ppcassembler.cpp ppcdisassembler.cpp ppcgenerator.cpp \
	risc.cpp riscassembler.cpp riscdisassembler.cpp riscgenerator.cpp wasm.cpp wasmassembler.cpp wasmdisassembler.cpp wasmgenerator.cpp \
	xtensa.cpp xtensaassembler.cpp xtensadisassembler.cpp xtensagenerator.cpp) \
	$(addprefix $(UTILITIES), depwalk.cpp ecsd.cpp hexdump.cpp linecheck.cpp regtest.cpp $(ENVIRONMENT))
DRV := $(addprefix $(TOOLS), $(addsuffix .drv, $(PREPROCESSORS) $(PRINTERS) $(CHECKERS) $(SERIALIZERS) $(INTERPRETERS) $(TRANSPILERS) $(GENERATORS) $(COMPILERS) $(CONVERTERS) $(ASSEMBLERS) $(DISASSEMBLERS) $(LINKERS)))
OBJ := $(SRC:.cpp=$(O)) $(DRV:.drv=$(O))

FINDMATCH = $(if $(findstring $(lastword $1), $2), $(words $1), $(call FINDMATCH, $(filter-out $(lastword $1), $1), $2))
CREATEMACRO = $(addprefix $(word $(call FINDMATCH, $(call $2S), $(basename $1)), $(call $2NAMES)), $(firstword $3 $2))

# output of make depwalk
$(addprefix $(TOOLS), object$(O): object.cpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), objlinker$(O): objlinker.cpp charset.hpp diagnostics.hpp error.hpp format.hpp object.hpp objlinker.hpp objmap.hpp position.hpp rangeset.hpp utilities.hpp)
$(addprefix $(TOOLS), objmap$(O): objmap.cpp object.hpp objmap.hpp utilities.hpp)
$(addprefix $(TOOLS), objhexfile$(O): objhexfile.cpp objhexfile.hpp utilities.hpp)
$(addprefix $(TOOLS), mapsearch$(O): mapsearch.cpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp objmap.hpp position.hpp strdiagnostics.hpp utilities.hpp)
$(addprefix $(TOOLS), debugging$(O): debugging.cpp debugging.hpp utilities.hpp)
$(addprefix $(TOOLS), dbgconverter$(O): dbgconverter.cpp charset.hpp dbgconverter.hpp dbgconvertercontext.hpp debugging.hpp diagnostics.hpp error.hpp object.hpp position.hpp utilities.hpp)
$(addprefix $(TOOLS), dbgdwarfconverter$(O): dbgdwarfconverter.cpp dbgconverter.hpp dbgconvertercontext.hpp dbgdwarfconverter.hpp debugging.hpp format.hpp ieee.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), documentation$(O): documentation.cpp documentation.hpp position.hpp)
$(addprefix $(TOOLS), doclexer$(O): doclexer.cpp doclexer.hpp documentation.def position.hpp utilities.hpp)
$(addprefix $(TOOLS), docparser$(O): docparser.cpp diagnostics.hpp doclexer.hpp docparser.hpp documentation.def documentation.hpp error.hpp format.hpp position.hpp)
$(addprefix $(TOOLS), docprinter$(O): docprinter.cpp doclexer.hpp docprinter.hpp documentation.def documentation.hpp position.hpp)
$(addprefix $(TOOLS), docprint$(O): docprint.cpp diagnostics.hpp docparser.hpp docprinter.hpp documentation.hpp driver.hpp error.hpp format.hpp position.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), docchecker$(O): docchecker.cpp diagnostics.hpp docchecker.hpp documentation.hpp error.hpp format.hpp position.hpp)
$(addprefix $(TOOLS), doccheck$(O): doccheck.cpp diagnostics.hpp docchecker.hpp docparser.hpp documentation.hpp driver.hpp error.hpp format.hpp position.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), docextractor$(O): docextractor.cpp diagnostics.hpp docextractor.hpp docparser.hpp documentation.hpp position.hpp)
$(addprefix $(TOOLS), dochtmlformatter$(O): dochtmlformatter.cpp dochtmlformatter.hpp documentation.hpp position.hpp)
$(addprefix $(TOOLS), doclatexformatter$(O): doclatexformatter.cpp doclatexformatter.hpp documentation.hpp position.hpp utilities.hpp)
$(addprefix $(TOOLS), code$(O): code.cpp asmlexer.hpp assembly.def code.def code.hpp diagnostics.hpp ieee.hpp layout.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), cdchecker$(O): cdchecker.cpp asmchecker.hpp asmcheckercontext.hpp asmlexer.hpp assembly.def assembly.hpp cdchecker.hpp code.def code.hpp diagnostics.hpp error.hpp format.hpp object.hpp)
$(addprefix $(TOOLS), cdoptimizer$(O): cdoptimizer.cpp cdoptimizer.hpp code.def code.hpp object.hpp)
$(addprefix $(TOOLS), cdopt$(O): cdopt.cpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembly.def assembly.hpp cdchecker.hpp cdgenerator.hpp cdoptimizer.hpp charset.hpp code.def code.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdinterpreter$(O): cdinterpreter.cpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembly.def assembly.hpp cdchecker.hpp cdinterpreter.hpp code.def code.hpp diagnostics.hpp environment.hpp error.hpp format.hpp object.hpp position.hpp utilities.hpp)
$(addprefix $(TOOLS), cdemitter$(O): cdemitter.cpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembly.def assembly.hpp cdchecker.hpp cdemitter.hpp cdemittercontext.hpp charset.hpp code.def code.hpp diagnostics.hpp object.hpp position.hpp utilities.hpp)
$(addprefix $(TOOLS), cdgenerator$(O): cdgenerator.cpp asmlexer.hpp assembly.def cdgenerator.hpp code.def code.hpp diagnostics.hpp layout.hpp object.hpp stdlayout.hpp utilities.hpp)
$(addprefix $(TOOLS), xml$(O): xml.cpp xml.hpp)
$(addprefix $(TOOLS), xmlprinter$(O): xmlprinter.cpp indenter.hpp xml.hpp xmlprinter.hpp)
$(addprefix $(TOOLS), xmlserializer$(O): xmlserializer.cpp position.hpp xml.hpp xmlserializer.hpp)
$(addprefix $(TOOLS), cpp$(O): cpp.cpp cpp.def cpp.hpp cpplexer.hpp diagnostics.hpp layout.hpp position.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), cpplexer$(O): cpplexer.cpp charset.hpp cpp.def cpplexer.hpp cpplexercontext.hpp diagnostics.hpp error.hpp format.hpp position.hpp stringpool.hpp utilities.hpp)
$(addprefix $(TOOLS), cpppreprocessor$(O): cpppreprocessor.cpp cpp.def cpplexer.hpp cpplexercontext.hpp cpppreprocessor.hpp cpppreprocessorcontext.hpp diagnostics.hpp error.hpp format.hpp position.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), cppparser$(O): cppparser.cpp cpp.def cpp.hpp cppchecker.hpp cppcheckercontext.hpp cppevaluator.hpp cppinterpreter.hpp cpplexer.hpp cpplexercontext.hpp cppparser.hpp cpppreprocessor.hpp cpppreprocessorcontext.hpp cppprinter.hpp diagnostics.hpp error.hpp format.hpp position.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppprinter$(O): cppprinter.cpp cpp.def cpp.hpp cpplexer.hpp cppprinter.hpp diagnostics.hpp indenter.hpp position.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), cppchecker$(O): cppchecker.cpp cpp.def cpp.hpp cppchecker.hpp cppcheckercontext.hpp cppevaluator.hpp cppexecutor.hpp cppinterpreter.hpp cpplexer.hpp cppprinter.hpp diagnostics.hpp error.hpp format.hpp position.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), cppserializer$(O): cppserializer.cpp cpp.def cpp.hpp cpplexer.hpp cppserializer.hpp diagnostics.hpp position.hpp structurepool.hpp xml.hpp xmlserializer.hpp)
$(addprefix $(TOOLS), cppinterpreter$(O): cppinterpreter.cpp cpp.def cpp.hpp cppevaluator.hpp cppexecutor.hpp cppinterpreter.hpp cpplexer.hpp cppprinter.hpp diagnostics.hpp environment.hpp error.hpp format.hpp position.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), cppextractor$(O): cppextractor.cpp cppextractor.hpp docextractor.hpp docparser.hpp documentation.hpp position.hpp)
$(addprefix $(TOOLS), cppemitter$(O): cppemitter.cpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembly.def cdchecker.hpp cdemitter.hpp cdemittercontext.hpp charset.hpp code.def code.hpp cpp.def cpp.hpp cppemitter.hpp cpplexer.hpp cppprinter.hpp diagnostics.hpp error.hpp object.hpp position.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), false$(O): false.cpp fallexer.hpp false.def false.hpp position.hpp structurepool.hpp)
$(addprefix $(TOOLS), fallexer$(O): fallexer.cpp fallexer.hpp false.def position.hpp utilities.hpp)
$(addprefix $(TOOLS), falparser$(O): falparser.cpp diagnostics.hpp error.hpp fallexer.hpp falparser.hpp false.def false.hpp position.hpp structurepool.hpp)
$(addprefix $(TOOLS), falprinter$(O): falprinter.cpp fallexer.hpp falprinter.hpp false.def false.hpp position.hpp structurepool.hpp)
$(addprefix $(TOOLS), falserializer$(O): falserializer.cpp fallexer.hpp false.def false.hpp falserializer.hpp position.hpp structurepool.hpp xml.hpp xmlserializer.hpp)
$(addprefix $(TOOLS), falinterpreter$(O): falinterpreter.cpp diagnostics.hpp environment.hpp error.hpp falinterpreter.hpp fallexer.hpp false.def false.hpp position.hpp structurepool.hpp)
$(addprefix $(TOOLS), faltranspiler$(O): faltranspiler.cpp fallexer.hpp false.def false.hpp faltranspiler.hpp indenter.hpp position.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), falemitter$(O): falemitter.cpp asmchecker.hpp asmparser.hpp cdchecker.hpp cdemitter.hpp cdemittercontext.hpp charset.hpp code.def code.hpp falemitter.hpp fallexer.hpp false.def false.hpp object.hpp position.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), oberon$(O): oberon.cpp layout.hpp oberon.def oberon.hpp oblexer.hpp position.hpp rangeset.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), oblexer$(O): oblexer.cpp oberon.def oblexer.hpp position.hpp utilities.hpp)
$(addprefix $(TOOLS), obparser$(O): obparser.cpp diagnostics.hpp error.hpp format.hpp oberon.def oberon.hpp oblexer.hpp obparser.hpp position.hpp rangeset.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), obprinter$(O): obprinter.cpp indenter.hpp oberon.def oberon.hpp oblexer.hpp obprinter.hpp position.hpp rangeset.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), obchecker$(O): obchecker.cpp diagnostics.hpp error.hpp format.hpp obchecker.hpp oberon.def oberon.hpp obevaluator.hpp obinterpreter.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), obserializer$(O): obserializer.cpp oberon.def oberon.hpp oblexer.hpp obserializer.hpp position.hpp rangeset.hpp structurepool.hpp xml.hpp xmlserializer.hpp)
$(addprefix $(TOOLS), obinterpreter$(O): obinterpreter.cpp charset.hpp diagnostics.hpp environment.hpp error.hpp format.hpp oberon.def oberon.hpp obevaluator.hpp obinterpreter.hpp oblexer.hpp position.hpp rangeset.hpp strdiagnostics.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), obtranspiler$(O): obtranspiler.cpp indenter.hpp oberon.def oberon.hpp oblexer.hpp obtranspiler.hpp position.hpp rangeset.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), obextractor$(O): obextractor.cpp docextractor.hpp docparser.hpp documentation.hpp indenter.hpp oberon.def oberon.hpp obextractor.hpp oblexer.hpp position.hpp rangeset.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), obemitter$(O): obemitter.cpp asmchecker.hpp asmparser.hpp cdchecker.hpp cdemitter.hpp cdemittercontext.hpp charset.hpp code.def code.hpp diagnostics.hpp error.hpp obemitter.hpp oberon.def oberon.hpp object.hpp oblexer.hpp position.hpp rangeset.hpp strdiagnostics.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), assembly$(O): assembly.cpp asmlexer.hpp assembly.def assembly.hpp diagnostics.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), asmlexer$(O): asmlexer.cpp asmlexer.hpp assembly.def diagnostics.hpp object.hpp position.hpp utilities.hpp)
$(addprefix $(TOOLS), asmparser$(O): asmparser.cpp asmlexer.hpp asmparser.hpp assembly.def assembly.hpp diagnostics.hpp error.hpp format.hpp object.hpp stringpool.hpp)
$(addprefix $(TOOLS), asmprinter$(O): asmprinter.cpp asmlexer.hpp asmprinter.hpp assembly.def assembly.hpp diagnostics.hpp indenter.hpp object.hpp)
$(addprefix $(TOOLS), asmchecker$(O): asmchecker.cpp asmchecker.hpp asmcheckercontext.hpp asmlexer.hpp assembly.def assembly.hpp charset.hpp diagnostics.hpp error.hpp format.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), asmassembler$(O): asmassembler.cpp asmassembler.hpp asmchecker.hpp asmcheckercontext.hpp asmlexer.hpp assembly.def assembly.hpp charset.hpp diagnostics.hpp error.hpp format.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), asmdisassembler$(O): asmdisassembler.cpp asmdisassembler.hpp asmlexer.hpp assembly.def charset.hpp diagnostics.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), asmgenerator$(O): asmgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp code.def code.hpp debugging.hpp diagnostics.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp utilities.hpp)
$(addprefix $(TOOLS), amd64$(O): amd64.cpp amd64.def amd64.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), amd64assembler$(O): amd64assembler.cpp amd64.def amd64.hpp amd64assembler.hpp asmassembler.hpp asmchecker.hpp utilities.hpp)
$(addprefix $(TOOLS), amd64disassembler$(O): amd64disassembler.cpp amd64.def amd64.hpp amd64disassembler.hpp asmdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), amd64generator$(O): amd64generator.cpp amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), arm$(O): arm.cpp arm.def arm.hpp utilities.hpp)
$(addprefix $(TOOLS), arma32$(O): arma32.cpp arm.def arm.hpp arma32.def arma32.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), arma32assembler$(O): arma32assembler.cpp arm.def arm.hpp arma32.def arma32.hpp arma32assembler.hpp asmassembler.hpp asmchecker.hpp utilities.hpp)
$(addprefix $(TOOLS), arma32disassembler$(O): arma32disassembler.cpp arm.def arm.hpp arma32.def arma32.hpp arma32disassembler.hpp asmdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), armgenerator$(O): armgenerator.cpp arm.def arm.hpp armgenerator.hpp armgeneratorcontext.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), arma32generator$(O): arma32generator.cpp arm.def arm.hpp arma32.def arma32.hpp arma32assembler.hpp arma32generator.hpp armgenerator.hpp armgeneratorcontext.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), arma64$(O): arma64.cpp arm.def arm.hpp arma64.def arma64.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), arma64assembler$(O): arma64assembler.cpp arm.def arm.hpp arma32assembler.hpp arma64.def arma64.hpp arma64assembler.hpp asmassembler.hpp asmchecker.hpp utilities.hpp)
$(addprefix $(TOOLS), arma64disassembler$(O): arma64disassembler.cpp arm.def arm.hpp arma64.def arma64.hpp arma64disassembler.hpp asmdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), arma64generator$(O): arma64generator.cpp arm.def arm.hpp arma32assembler.hpp arma64.def arma64.hpp arma64assembler.hpp arma64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), armt32$(O): armt32.cpp arm.def arm.hpp armt32.def armt32.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), armt32assembler$(O): armt32assembler.cpp arm.def arm.hpp arma32assembler.hpp armt32.def armt32.hpp armt32assembler.hpp asmassembler.hpp asmchecker.hpp utilities.hpp)
$(addprefix $(TOOLS), armt32disassembler$(O): armt32disassembler.cpp arm.def arm.hpp armt32.def armt32.hpp armt32disassembler.hpp asmdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), armt32generator$(O): armt32generator.cpp arm.def arm.hpp arma32assembler.hpp armgenerator.hpp armgeneratorcontext.hpp armt32.def armt32.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), avr$(O): avr.cpp avr.def avr.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), avrassembler$(O): avrassembler.cpp asmassembler.hpp asmchecker.hpp asmlexer.hpp assembly.def assembly.hpp avr.def avr.hpp avrassembler.hpp diagnostics.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), avrdisassembler$(O): avrdisassembler.cpp asmdisassembler.hpp avr.def avr.hpp avrdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), avrgenerator$(O): avrgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def avr.def avr.hpp avrassembler.hpp avrgenerator.hpp code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), avr32$(O): avr32.cpp avr32.def avr32.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), avr32assembler$(O): avr32assembler.cpp asmassembler.hpp asmchecker.hpp avr32.def avr32.hpp avr32assembler.hpp utilities.hpp)
$(addprefix $(TOOLS), avr32disassembler$(O): avr32disassembler.cpp asmdisassembler.hpp avr32.def avr32.hpp avr32disassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), avr32generator$(O): avr32generator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def avr32.def avr32.hpp avr32assembler.hpp avr32generator.hpp code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), m68k$(O): m68k.cpp m68k.def m68k.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), m68kassembler$(O): m68kassembler.cpp asmassembler.hpp asmchecker.hpp m68k.def m68k.hpp m68kassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), m68kdisassembler$(O): m68kdisassembler.cpp asmdisassembler.hpp m68k.def m68k.hpp m68kdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), m68kgenerator$(O): m68kgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp m68k.def m68k.hpp m68kassembler.hpp m68kgenerator.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), mibl$(O): mibl.cpp mibl.def mibl.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), miblassembler$(O): miblassembler.cpp asmassembler.hpp asmchecker.hpp mibl.def mibl.hpp miblassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), mibldisassembler$(O): mibldisassembler.cpp asmdisassembler.hpp mibl.def mibl.hpp mibldisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), miblgenerator$(O): miblgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp mibl.def mibl.hpp miblassembler.hpp miblgenerator.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), mips$(O): mips.cpp mips.def mips.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), mipsassembler$(O): mipsassembler.cpp asmassembler.hpp asmchecker.hpp mips.def mips.hpp mipsassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), mipsdisassembler$(O): mipsdisassembler.cpp asmdisassembler.hpp mips.def mips.hpp mipsdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), mipsgenerator$(O): mipsgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), mmix$(O): mmix.cpp mmix.def mmix.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), mmixassembler$(O): mmixassembler.cpp asmassembler.hpp asmchecker.hpp asmlexer.hpp assembly.def assembly.hpp diagnostics.hpp mmix.def mmix.hpp mmixassembler.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), mmixdisassembler$(O): mmixdisassembler.cpp asmdisassembler.hpp mmix.def mmix.hpp mmixdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), mmixgenerator$(O): mmixgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp ieee.hpp layout.hpp mmix.def mmix.hpp mmixassembler.hpp mmixgenerator.hpp object.hpp utilities.hpp)
$(addprefix $(TOOLS), or1k$(O): or1k.cpp object.hpp or1k.def or1k.hpp utilities.hpp)
$(addprefix $(TOOLS), or1kassembler$(O): or1kassembler.cpp asmassembler.hpp asmchecker.hpp or1k.def or1k.hpp or1kassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), or1kdisassembler$(O): or1kdisassembler.cpp asmdisassembler.hpp or1k.def or1k.hpp or1kdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), or1kgenerator$(O): or1kgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp or1k.def or1k.hpp or1kassembler.hpp or1kgenerator.hpp utilities.hpp)
$(addprefix $(TOOLS), ppc$(O): ppc.cpp object.hpp ppc.def ppc.hpp utilities.hpp)
$(addprefix $(TOOLS), ppcassembler$(O): ppcassembler.cpp asmassembler.hpp asmchecker.hpp ppc.def ppc.hpp ppcassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), ppcdisassembler$(O): ppcdisassembler.cpp asmdisassembler.hpp ppc.def ppc.hpp ppcdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), ppcgenerator$(O): ppcgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp utilities.hpp)
$(addprefix $(TOOLS), risc$(O): risc.cpp object.hpp risc.def risc.hpp utilities.hpp)
$(addprefix $(TOOLS), riscassembler$(O): riscassembler.cpp asmassembler.hpp asmchecker.hpp risc.def risc.hpp riscassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), riscdisassembler$(O): riscdisassembler.cpp asmdisassembler.hpp risc.def risc.hpp riscdisassembler.hpp utilities.hpp)
$(addprefix $(TOOLS), riscgenerator$(O): riscgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp risc.def risc.hpp riscassembler.hpp riscgenerator.hpp utilities.hpp)
$(addprefix $(TOOLS), wasm$(O): wasm.cpp ieee.hpp object.hpp utilities.hpp wasm.def wasm.hpp)
$(addprefix $(TOOLS), wasmassembler$(O): wasmassembler.cpp asmassembler.hpp asmchecker.hpp utilities.hpp wasm.def wasm.hpp wasmassembler.hpp)
$(addprefix $(TOOLS), wasmdisassembler$(O): wasmdisassembler.cpp asmdisassembler.hpp utilities.hpp wasm.def wasm.hpp wasmdisassembler.hpp)
$(addprefix $(TOOLS), wasmgenerator$(O): wasmgenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp wasm.def wasm.hpp wasmassembler.hpp wasmgenerator.hpp)
$(addprefix $(TOOLS), xtensa$(O): xtensa.cpp object.hpp utilities.hpp xtensa.def xtensa.hpp)
$(addprefix $(TOOLS), xtensaassembler$(O): xtensaassembler.cpp asmassembler.hpp asmchecker.hpp utilities.hpp xtensa.def xtensa.hpp xtensaassembler.hpp)
$(addprefix $(TOOLS), xtensadisassembler$(O): xtensadisassembler.cpp asmdisassembler.hpp utilities.hpp xtensa.def xtensa.hpp xtensadisassembler.hpp)
$(addprefix $(TOOLS), xtensagenerator$(O): xtensagenerator.cpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmgeneratorcontext.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def code.def code.hpp debugging.hpp diagnostics.hpp layout.hpp object.hpp utilities.hpp xtensa.def xtensa.hpp xtensaassembler.hpp xtensagenerator.hpp)
$(addprefix $(TOOLS), cppprep$(O): cppprep.drv charset.hpp cpp.def cpplexer.hpp cpppreprocessor.hpp diagnostics.hpp driver.hpp error.hpp format.hpp position.hpp preprocessor.cpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cppprint$(O): cppprint.drv charset.hpp cpp.def cpp.hpp cppchecker.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp cppprinter.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp position.hpp printer.cpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falprint$(O): falprint.drv charset.hpp diagnostics.hpp driver.hpp error.hpp fallexer.hpp falparser.hpp falprinter.hpp false.def false.hpp format.hpp layout.hpp position.hpp printer.cpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), obprint$(O): obprint.drv charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp oberon.def oberon.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp printer.cpp rangeset.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), asmprint$(O): asmprint.drv asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp printer.cpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdcheck$(O): cdcheck.drv asmchecker.hpp asmlexer.hpp asmparser.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp checker.cpp code.def code.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cppcheck$(O): cppcheck.drv charset.hpp checker.cpp cpp.def cpp.hpp cppchecker.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falcheck$(O): falcheck.drv charset.hpp checker.cpp diagnostics.hpp driver.hpp error.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), obcheck$(O): obcheck.drv charset.hpp checker.cpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp oberon.def oberon.hpp obinterpreter.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppdump$(O): cppdump.drv charset.hpp cpp.def cpp.hpp cppchecker.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp cppserializer.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp position.hpp serializer.cpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp xml.hpp xmlprinter.hpp)
$(addprefix $(TOOLS), faldump$(O): faldump.drv charset.hpp diagnostics.hpp driver.hpp error.hpp fallexer.hpp falparser.hpp false.def false.hpp falserializer.hpp format.hpp layout.hpp position.hpp serializer.cpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp xml.hpp xmlprinter.hpp)
$(addprefix $(TOOLS), obdump$(O): obdump.drv charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp oberon.def oberon.hpp obinterpreter.hpp oblexer.hpp obparser.hpp obprinter.hpp obserializer.hpp position.hpp rangeset.hpp serializer.cpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp xml.hpp xmlprinter.hpp)
$(addprefix $(TOOLS), cdrun$(O): cdrun.drv asmchecker.hpp asmlexer.hpp asmparser.hpp assembly.def assembly.hpp cdchecker.hpp cdinterpreter.hpp charset.hpp code.def code.hpp diagnostics.hpp driver.hpp environment.hpp error.hpp format.hpp interpreter.cpp layout.hpp object.hpp position.hpp stdcharset.hpp stdenvironment.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cpprun$(O): cpprun.drv charset.hpp cpp.def cpp.hpp cppchecker.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp diagnostics.hpp driver.hpp environment.hpp error.hpp format.hpp interpreter.cpp layout.hpp position.hpp stdcharset.hpp stdenvironment.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falrun$(O): falrun.drv charset.hpp diagnostics.hpp driver.hpp environment.hpp error.hpp falinterpreter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp interpreter.cpp layout.hpp position.hpp stdcharset.hpp stdenvironment.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), obrun$(O): obrun.drv charset.hpp diagnostics.hpp driver.hpp environment.hpp error.hpp format.hpp interpreter.cpp layout.hpp obchecker.hpp oberon.def oberon.hpp obinterpreter.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp stdenvironment.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), falcpp$(O): falcpp.drv charset.hpp diagnostics.hpp driver.hpp error.hpp fallexer.hpp falparser.hpp false.def false.hpp faltranspiler.hpp format.hpp layout.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp transpiler.cpp)
$(addprefix $(TOOLS), obcpp$(O): obcpp.drv charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp oberon.def oberon.hpp obinterpreter.hpp oblexer.hpp obparser.hpp obprinter.hpp obtranspiler.hpp position.hpp rangeset.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp transpiler.cpp utilities.hpp)
$(addprefix $(TOOLS), dochtml$(O): dochtml.drv diagnostics.hpp docchecker.hpp dochtmlformatter.hpp docparser.hpp documentation.hpp driver.hpp error.hpp format.hpp generator.cpp layout.hpp position.hpp stdlayout.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), doclatex$(O): doclatex.drv diagnostics.hpp docchecker.hpp doclatexformatter.hpp docparser.hpp documentation.hpp driver.hpp error.hpp format.hpp generator.cpp layout.hpp position.hpp stdlayout.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), cppdoc$(O): cppdoc.drv charset.hpp cpp.def cpp.hpp cppchecker.hpp cppextractor.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp diagnostics.hpp docchecker.hpp docprinter.hpp documentation.hpp driver.hpp error.hpp format.hpp generator.cpp layout.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cpphtml$(O): cpphtml.drv charset.hpp cpp.def cpp.hpp cppchecker.hpp cppextractor.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp diagnostics.hpp docchecker.hpp dochtmlformatter.hpp documentation.hpp driver.hpp error.hpp format.hpp generator.cpp layout.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cpplatex$(O): cpplatex.drv charset.hpp cpp.def cpp.hpp cppchecker.hpp cppextractor.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp diagnostics.hpp docchecker.hpp doclatexformatter.hpp documentation.hpp driver.hpp error.hpp format.hpp generator.cpp layout.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obdoc$(O): obdoc.drv charset.hpp diagnostics.hpp docchecker.hpp docprinter.hpp documentation.hpp driver.hpp error.hpp format.hpp generator.cpp layout.hpp obchecker.hpp oberon.def oberon.hpp obextractor.hpp obinterpreter.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), obhtml$(O): obhtml.drv charset.hpp diagnostics.hpp docchecker.hpp dochtmlformatter.hpp documentation.hpp driver.hpp error.hpp format.hpp generator.cpp layout.hpp obchecker.hpp oberon.def oberon.hpp obextractor.hpp obinterpreter.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), oblatex$(O): oblatex.drv charset.hpp diagnostics.hpp docchecker.hpp doclatexformatter.hpp documentation.hpp driver.hpp error.hpp format.hpp generator.cpp layout.hpp obchecker.hpp oberon.def oberon.hpp obextractor.hpp obinterpreter.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp structurepool.hpp)
$(addprefix $(TOOLS), cdamd16$(O): cdamd16.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdamd32$(O): cdamd32.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdamd64$(O): cdamd64.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdarma32$(O): cdarma32.drv arma32assembler.hpp arma32generator.hpp armgenerator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdarma64$(O): cdarma64.drv arma32assembler.hpp arma64assembler.hpp arma64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdarmt32$(O): cdarmt32.drv arma32assembler.hpp armgenerator.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdarmt32fpe$(O): cdarmt32fpe.drv arma32assembler.hpp armgenerator.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdavr$(O): cdavr.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp avrassembler.hpp avrgenerator.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdavr32$(O): cdavr32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp avr32assembler.hpp avr32generator.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdm68k$(O): cdm68k.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp m68kassembler.hpp m68kgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdmibl$(O): cdmibl.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp miblassembler.hpp miblgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdmips32$(O): cdmips32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp utilities.hpp)
$(addprefix $(TOOLS), cdmips64$(O): cdmips64.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp utilities.hpp)
$(addprefix $(TOOLS), cdmmix$(O): cdmmix.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mmixassembler.hpp mmixgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdor1k$(O): cdor1k.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp or1kassembler.hpp or1kgenerator.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdppc32$(O): cdppc32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdppc64$(O): cdppc64.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdrisc$(O): cdrisc.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp riscassembler.hpp riscgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), cdwasm$(O): cdwasm.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp wasmassembler.hpp wasmgenerator.hpp)
$(addprefix $(TOOLS), cdxtensa$(O): cdxtensa.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmlexer.hpp asmparser.hpp asmprinter.hpp assembly.def assembly.hpp cdchecker.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp xtensaassembler.hpp xtensagenerator.hpp)
$(addprefix $(TOOLS), cppcode$(O): cppcode.drv asmchecker.hpp asmparser.hpp cdchecker.hpp cdemitter.hpp cdgenerator.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppamd16$(O): cppamd16.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppamd32$(O): cppamd32.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppamd64$(O): cppamd64.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cpparma32$(O): cpparma32.drv arma32assembler.hpp arma32generator.hpp armgenerator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cpparma64$(O): cpparma64.drv arma32assembler.hpp arma64assembler.hpp arma64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cpparmt32$(O): cpparmt32.drv arma32assembler.hpp armgenerator.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cpparmt32fpe$(O): cpparmt32fpe.drv arma32assembler.hpp armgenerator.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppavr$(O): cppavr.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp avrassembler.hpp avrgenerator.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppavr32$(O): cppavr32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp avr32assembler.hpp avr32generator.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppm68k$(O): cppm68k.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp m68kassembler.hpp m68kgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppmibl$(O): cppmibl.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp miblassembler.hpp miblgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppmips32$(O): cppmips32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), cppmips64$(O): cppmips64.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), cppmmix$(O): cppmmix.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mmixassembler.hpp mmixgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppor1k$(O): cppor1k.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp or1kassembler.hpp or1kgenerator.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppppc32$(O): cppppc32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppppc64$(O): cppppc64.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cpprisc$(O): cpprisc.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp riscassembler.hpp riscgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), cppwasm$(O): cppwasm.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp wasmassembler.hpp wasmgenerator.hpp)
$(addprefix $(TOOLS), cppxtensa$(O): cppxtensa.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp cpp.def cpp.hpp cppchecker.hpp cppemitter.hpp cppinterpreter.hpp cpplexer.hpp cppparser.hpp cpppreprocessor.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp xtensaassembler.hpp xtensagenerator.hpp)
$(addprefix $(TOOLS), falcode$(O): falcode.drv asmchecker.hpp asmparser.hpp cdchecker.hpp cdemitter.hpp cdgenerator.hpp charset.hpp code.def code.hpp compiler.cpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falamd16$(O): falamd16.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falamd32$(O): falamd32.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falamd64$(O): falamd64.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falarma32$(O): falarma32.drv arma32assembler.hpp arma32generator.hpp armgenerator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falarma64$(O): falarma64.drv arma32assembler.hpp arma64assembler.hpp arma64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falarmt32$(O): falarmt32.drv arma32assembler.hpp armgenerator.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falarmt32fpe$(O): falarmt32fpe.drv arma32assembler.hpp armgenerator.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falavr$(O): falavr.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp avrassembler.hpp avrgenerator.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falavr32$(O): falavr32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp avr32assembler.hpp avr32generator.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falm68k$(O): falm68k.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp m68kassembler.hpp m68kgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falmibl$(O): falmibl.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp miblassembler.hpp miblgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falmips32$(O): falmips32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), falmips64$(O): falmips64.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), falmmix$(O): falmmix.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp mmixassembler.hpp mmixgenerator.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falor1k$(O): falor1k.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp or1kassembler.hpp or1kgenerator.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falppc32$(O): falppc32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falppc64$(O): falppc64.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falrisc$(O): falrisc.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp riscassembler.hpp riscgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), falwasm$(O): falwasm.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp wasmassembler.hpp wasmgenerator.hpp)
$(addprefix $(TOOLS), falxtensa$(O): falxtensa.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp falemitter.hpp fallexer.hpp falparser.hpp false.def false.hpp format.hpp layout.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp xtensaassembler.hpp xtensagenerator.hpp)
$(addprefix $(TOOLS), obcode$(O): obcode.drv asmchecker.hpp asmparser.hpp cdchecker.hpp cdemitter.hpp cdgenerator.hpp charset.hpp code.def code.hpp compiler.cpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp stdlayout.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obamd16$(O): obamd16.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obamd32$(O): obamd32.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obamd64$(O): obamd64.drv amd64.def amd64.hpp amd64assembler.hpp amd64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obarma32$(O): obarma32.drv arma32assembler.hpp arma32generator.hpp armgenerator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obarma64$(O): obarma64.drv arma32assembler.hpp arma64assembler.hpp arma64generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obarmt32$(O): obarmt32.drv arma32assembler.hpp armgenerator.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obarmt32fpe$(O): obarmt32fpe.drv arma32assembler.hpp armgenerator.hpp armt32assembler.hpp armt32generator.hpp asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obavr$(O): obavr.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp avrassembler.hpp avrgenerator.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obavr32$(O): obavr32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp avr32assembler.hpp avr32generator.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obm68k$(O): obm68k.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp m68kassembler.hpp m68kgenerator.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obmibl$(O): obmibl.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp miblassembler.hpp miblgenerator.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obmips32$(O): obmips32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), obmips64$(O): obmips64.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mips.def mips.hpp mipsassembler.hpp mipsgenerator.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp utilities.hpp)
$(addprefix $(TOOLS), obmmix$(O): obmmix.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp mmixassembler.hpp mmixgenerator.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obor1k$(O): obor1k.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp or1kassembler.hpp or1kgenerator.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obppc32$(O): obppc32.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obppc64$(O): obppc64.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp ppcgenerator.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obrisc$(O): obrisc.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp riscassembler.hpp riscgenerator.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp)
$(addprefix $(TOOLS), obwasm$(O): obwasm.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp wasmassembler.hpp wasmgenerator.hpp)
$(addprefix $(TOOLS), obxtensa$(O): obxtensa.drv asmassembler.hpp asmchecker.hpp asmgenerator.hpp asmparser.hpp asmprinter.hpp cdchecker.hpp cdemitter.hpp charset.hpp code.def code.hpp compiler.cpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp layout.hpp obchecker.hpp obemitter.hpp oberon.def oberon.hpp obinterpreter.hpp object.hpp oblexer.hpp obparser.hpp obprinter.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp structurepool.hpp xtensaassembler.hpp xtensagenerator.hpp)
$(addprefix $(TOOLS), dbgdwarf$(O): dbgdwarf.drv charset.hpp converter.cpp dbgconverter.hpp dbgdwarfconverter.hpp debugging.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), amd16asm$(O): amd16asm.drv amd64.def amd64.hpp amd64assembler.hpp asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), amd32asm$(O): amd32asm.drv amd64.def amd64.hpp amd64assembler.hpp asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), amd64asm$(O): amd64asm.drv amd64.def amd64.hpp amd64assembler.hpp asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), arma32asm$(O): arma32asm.drv arma32assembler.hpp asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), arma64asm$(O): arma64asm.drv arma32assembler.hpp arma64assembler.hpp asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), armt32asm$(O): armt32asm.drv arma32assembler.hpp armt32assembler.hpp asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), avrasm$(O): avrasm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp avrassembler.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), avr32asm$(O): avr32asm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp avr32assembler.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), m68kasm$(O): m68kasm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp m68kassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), miblasm$(O): miblasm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp miblassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), mips32asm$(O): mips32asm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp mips.def mips.hpp mipsassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp utilities.hpp)
$(addprefix $(TOOLS), mips64asm$(O): mips64asm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp mips.def mips.hpp mipsassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp utilities.hpp)
$(addprefix $(TOOLS), mmixasm$(O): mmixasm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp mmixassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), or1kasm$(O): or1kasm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp or1kassembler.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), ppc32asm$(O): ppc32asm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), ppc64asm$(O): ppc64asm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp ppc.def ppc.hpp ppcassembler.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), riscasm$(O): riscasm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp riscassembler.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp)
$(addprefix $(TOOLS), wasmasm$(O): wasmasm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp wasmassembler.hpp)
$(addprefix $(TOOLS), xtensaasm$(O): xtensaasm.drv asmassembler.hpp asmchecker.hpp asmlexer.hpp asmparser.hpp assembler.cpp assembly.def assembly.hpp charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp stringpool.hpp xtensaassembler.hpp)
$(addprefix $(TOOLS), amd16dism$(O): amd16dism.drv amd64.def amd64.hpp amd64disassembler.hpp asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), amd32dism$(O): amd32dism.drv amd64.def amd64.hpp amd64disassembler.hpp asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), amd64dism$(O): amd64dism.drv amd64.def amd64.hpp amd64disassembler.hpp asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), arma32dism$(O): arma32dism.drv arma32disassembler.hpp asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), arma64dism$(O): arma64dism.drv arma64disassembler.hpp asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), armt32dism$(O): armt32dism.drv armt32disassembler.hpp asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), avrdism$(O): avrdism.drv asmdisassembler.hpp avrdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), avr32dism$(O): avr32dism.drv asmdisassembler.hpp avr32disassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), m68kdism$(O): m68kdism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp m68kdisassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), mibldism$(O): mibldism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp mibldisassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), mips32dism$(O): mips32dism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp mips.def mips.hpp mipsdisassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp utilities.hpp)
$(addprefix $(TOOLS), mips64dism$(O): mips64dism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp mips.def mips.hpp mipsdisassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp utilities.hpp)
$(addprefix $(TOOLS), mmixdism$(O): mmixdism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp mmixdisassembler.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), or1kdism$(O): or1kdism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp or1kdisassembler.hpp position.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), ppc32dism$(O): ppc32dism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp ppc.def ppc.hpp ppcdisassembler.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), ppc64dism$(O): ppc64dism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp ppc.def ppc.hpp ppcdisassembler.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), riscdism$(O): riscdism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp riscdisassembler.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), wasmdism$(O): wasmdism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp wasmdisassembler.hpp)
$(addprefix $(TOOLS), xtensadism$(O): xtensadism.drv asmdisassembler.hpp charset.hpp diagnostics.hpp disassembler.cpp driver.hpp error.hpp format.hpp object.hpp position.hpp stdcharset.hpp strdiagnostics.hpp xtensadisassembler.hpp)
$(addprefix $(TOOLS), linklib$(O): linklib.drv charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp linker.cpp object.hpp objlinker.hpp objmap.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), linkbin$(O): linkbin.drv charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp linker.cpp object.hpp objlinker.hpp objmap.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), linkmem$(O): linkmem.drv charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp linker.cpp object.hpp objlinker.hpp objmap.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), linkhex$(O): linkhex.drv charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp linker.cpp object.hpp objhexfile.hpp objlinker.hpp objmap.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp)
$(addprefix $(TOOLS), linkprg$(O): linkprg.drv charset.hpp diagnostics.hpp driver.hpp error.hpp format.hpp linker.cpp object.hpp objlinker.hpp objmap.hpp position.hpp rangeset.hpp stdcharset.hpp strdiagnostics.hpp utilities.hpp)
$(addprefix $(UTILITIES), depwalk$(O): depwalk.cpp)
$(addprefix $(UTILITIES), ecsd$(O): ecsd.cpp system.hpp)
$(addprefix $(UTILITIES), hexdump$(O): hexdump.cpp system.hpp)
$(addprefix $(UTILITIES), linecheck$(O): linecheck.cpp)
$(addprefix $(UTILITIES), regtest$(O): regtest.cpp system.hpp)
$(addprefix $(UTILITIES), freebsd$(O): freebsd.cpp system.hpp)
$(addprefix $(UTILITIES), linux$(O): linux.cpp system.hpp)
$(addprefix $(UTILITIES), osx$(O): osx.cpp system.hpp)
$(addprefix $(UTILITIES), posix$(O): posix.cpp system.hpp)
$(addprefix $(UTILITIES), windows$(O): windows.cpp system.hpp)

$(addprefix $(TOOLS), linkhex$(PRG): $(addsuffix $(O), objhexfile))
$(addprefix $(TOOLS), mapsearch$(PRG): $(addsuffix $(O), object objmap))
$(addprefix $(TOOLS), docprint$(PRG): $(addsuffix $(O), documentation doclexer docparser docprinter))
$(addprefix $(TOOLS), doccheck$(PRG): $(addsuffix $(O), documentation doclexer docparser docchecker))
$(addprefix $(TOOLS), cdcheck$(PRG): $(addsuffix $(O), object code cdchecker assembly asmlexer asmparser asmchecker))
$(addprefix $(TOOLS), cdopt$(PRG): $(addsuffix $(O), object code cdchecker cdoptimizer cdgenerator assembly asmlexer asmparser asmchecker))
$(addprefix $(TOOLS), cdrun$(PRG): $(addsuffix $(O), object code cdchecker cdinterpreter assembly asmlexer asmparser asmchecker))
$(addprefix $(TOOLS), cppprep$(PRG): $(addsuffix $(O), cpplexer cpppreprocessor))
$(addprefix $(TOOLS), cppprint$(PRG): $(addsuffix $(O), cpp cpplexer cpppreprocessor cppparser cppprinter cppchecker cppinterpreter))
$(addprefix $(TOOLS), cppcheck$(PRG): $(addsuffix $(O), cpp cpplexer cpppreprocessor cppparser cppprinter cppchecker cppinterpreter))
$(addprefix $(TOOLS), cppdump$(PRG): $(addsuffix $(O), cpp cpplexer cpppreprocessor cppparser cppprinter cppchecker cppinterpreter cppserializer))
$(addprefix $(TOOLS), cpprun$(PRG): $(addsuffix $(O), cpp cpplexer cpppreprocessor cppparser cppprinter cppchecker cppinterpreter))
$(addprefix $(TOOLS), falprint$(PRG): $(addsuffix $(O), false fallexer falparser falprinter))
$(addprefix $(TOOLS), falcheck$(PRG): $(addsuffix $(O), false fallexer falparser))
$(addprefix $(TOOLS), faldump$(PRG): $(addsuffix $(O), false fallexer falparser falserializer))
$(addprefix $(TOOLS), falrun$(PRG): $(addsuffix $(O), false fallexer falparser falinterpreter))
$(addprefix $(TOOLS), falcpp$(PRG): $(addsuffix $(O), false fallexer falparser faltranspiler))
$(addprefix $(TOOLS), obprint$(PRG): $(addsuffix $(O), oberon oblexer obparser obprinter))
$(addprefix $(TOOLS), obcheck$(PRG): $(addsuffix $(O), oberon oblexer obparser obprinter obchecker obinterpreter))
$(addprefix $(TOOLS), obdump$(PRG): $(addsuffix $(O), oberon oblexer obparser obprinter obchecker obinterpreter obserializer))
$(addprefix $(TOOLS), obrun$(PRG): $(addsuffix $(O), oberon oblexer obparser obprinter obchecker obinterpreter))
$(addprefix $(TOOLS), obcpp$(PRG): $(addsuffix $(O), oberon oblexer obparser obprinter obchecker obinterpreter obtranspiler))
$(addprefix $(TOOLS), asmprint$(PRG): $(addsuffix $(O), object assembly asmlexer asmparser asmprinter))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(SERIALIZERS)): $(addsuffix $(O), xml xmlprinter xmlserializer))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter cpp%, $(GENERATORS))): $(addsuffix $(O), cpp cpplexer cpppreprocessor cppparser cppprinter cppchecker cppinterpreter cppextractor docextractor))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter ob%, $(GENERATORS))): $(addsuffix $(O), oberon oblexer obparser obprinter obchecker obinterpreter obextractor docextractor))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %doc, $(GENERATORS))): $(addsuffix $(O), docprinter))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %html, $(GENERATORS))): $(addsuffix $(O), dochtmlformatter))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %latex, $(GENERATORS))): $(addsuffix $(O), doclatexformatter))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(GENERATORS)): $(addsuffix $(O), documentation doclexer docparser docchecker))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter cd%, $(COMPILERS))): $(addsuffix $(O), cdchecker))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter cpp%, $(COMPILERS))): $(addsuffix $(O), cpp cpplexer cpppreprocessor cppparser cppprinter cppchecker cppinterpreter cppemitter cdemitter))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter fa%, $(COMPILERS))): $(addsuffix $(O), false fallexer falparser falemitter cdemitter))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter ob%, $(COMPILERS))): $(addsuffix $(O), oberon oblexer obparser obprinter obchecker obinterpreter obemitter cdemitter))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %code, $(COMPILERS))): $(addsuffix $(O), cdgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %amd16 %amd32 %amd64, $(COMPILERS))): $(addsuffix $(O), amd64 amd64assembler amd64generator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %arma32, $(COMPILERS))): $(addsuffix $(O), arm arma32 arma32assembler armgenerator arma32generator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %arma64, $(COMPILERS))): $(addsuffix $(O), arm arma32 arma32assembler arma64 arma64assembler arma64generator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %armt32 %armt32fpe, $(COMPILERS))): $(addsuffix $(O), arm arma32 arma32assembler armt32 armt32assembler armgenerator armt32generator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %avr, $(COMPILERS))): $(addsuffix $(O), avr avrassembler avrgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %avr32, $(COMPILERS))): $(addsuffix $(O), avr32 avr32assembler avr32generator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %m68k, $(COMPILERS))): $(addsuffix $(O), m68k m68kassembler m68kgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %mibl, $(COMPILERS))): $(addsuffix $(O), mibl miblassembler miblgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %mips32 %mips64, $(COMPILERS))): $(addsuffix $(O), mips mipsassembler mipsgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %mmix, $(COMPILERS))): $(addsuffix $(O), mmix mmixassembler mmixgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %or1k, $(COMPILERS))): $(addsuffix $(O), or1k or1kassembler or1kgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %ppc32 %ppc64, $(COMPILERS))): $(addsuffix $(O), ppc ppcassembler ppcgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %risc, $(COMPILERS))): $(addsuffix $(O), risc riscassembler riscgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %wasm, $(COMPILERS))): $(addsuffix $(O), wasm wasmassembler wasmgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %xtensa, $(COMPILERS))): $(addsuffix $(O), xtensa xtensaassembler xtensagenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter-out %code, $(COMPILERS))): $(addsuffix $(O), asmprinter asmassembler asmgenerator))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(COMPILERS)): $(addsuffix $(O), object debugging code cdchecker assembly asmlexer asmparser asmchecker))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter %dwarf, $(CONVERTERS))): $(addsuffix $(O), dbgdwarfconverter))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(CONVERTERS)): $(addsuffix $(O), object debugging dbgconverter asmlexer))
$(addprefix $(TOOLS), $(addsuffix $(PRG), amd16asm amd32asm amd64asm): $(addsuffix $(O), amd64 amd64assembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), arma32asm): $(addsuffix $(O), arm arma32 arma32assembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), arma64asm): $(addsuffix $(O), arm arma32 arma32assembler arma64 arma64assembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), armt32asm): $(addsuffix $(O), arm arma32 arma32assembler armt32 armt32assembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), avrasm): $(addsuffix $(O), avr avrassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), avr32asm): $(addsuffix $(O), avr32 avr32assembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), m68kasm): $(addsuffix $(O), m68k m68kassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), miblasm): $(addsuffix $(O), mibl miblassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), mips32asm mips64asm): $(addsuffix $(O), mips mipsassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), mmixasm): $(addsuffix $(O), mmix mmixassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), or1kasm): $(addsuffix $(O), or1k or1kassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), ppc32asm ppc64asm): $(addsuffix $(O), ppc ppcassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), riscasm): $(addsuffix $(O), risc riscassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), wasmasm): $(addsuffix $(O), wasm wasmassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), xtensaasm): $(addsuffix $(O), xtensa xtensaassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(ASSEMBLERS)): $(addsuffix $(O), object assembly asmlexer asmparser asmchecker asmassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), amd16dism amd32dism amd64dism): $(addsuffix $(O), amd64 amd64disassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), arma32dism): $(addsuffix $(O), arm arma32 arma32disassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), arma64dism): $(addsuffix $(O), arm arma32 arma64 arma64disassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), armt32dism): $(addsuffix $(O), arm arma32 armt32 armt32disassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), avrdism): $(addsuffix $(O), avr avrdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), avr32dism): $(addsuffix $(O), avr32 avr32disassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), m68kdism): $(addsuffix $(O), m68k m68kdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), mibldism): $(addsuffix $(O), mibl mibldisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), mips32dism mips64dism): $(addsuffix $(O), mips mipsdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), mmixdism): $(addsuffix $(O), mmix mmixdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), or1kdism): $(addsuffix $(O), or1k or1kdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), ppc32dism ppc64dism): $(addsuffix $(O), ppc ppcdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), riscdism): $(addsuffix $(O), risc riscdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), wasmdism): $(addsuffix $(O), wasm wasmdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), xtensadism): $(addsuffix $(O), xtensa xtensadisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(DISASSEMBLERS)): $(addsuffix $(O), object asmlexer asmdisassembler))
$(addprefix $(TOOLS), $(addsuffix $(PRG), $(LINKERS)): $(addsuffix $(O), object objmap objlinker))
$(addprefix $(UTILITIES), $(addsuffix $(PRG), ecsd hexdump regtest): $(addsuffix $(O), $(basename $(ENVIRONMENT))))

$(addprefix $(TOOLS), $(addsuffix .drv, $(PREPROCESSORS)): preprocessor.cpp)
	@echo // $(basename $(notdir $@)) preprocessor driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, LANGUAGE)>> $@
	@echo $(call ESC, #)include $(call ESC, ")preprocessor.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(PRINTERS)): printer.cpp)
	@echo // $(basename $(notdir $@)) pretty printer driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, LANGUAGE)>> $@
	@echo $(call ESC, #)include $(call ESC, ")printer.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(CHECKERS)): checker.cpp)
	@echo // $(basename $(notdir $@)) semantic checker driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, LANGUAGE)>> $@
	@echo $(call ESC, #)include $(call ESC, ")checker.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(SERIALIZERS)): serializer.cpp)
	@echo // $(basename $(notdir $@)) serializer driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, LANGUAGE)>> $@
	@echo $(call ESC, #)include $(call ESC, ")serializer.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(INTERPRETERS)): interpreter.cpp)
	@echo // $(basename $(notdir $@)) interpreter driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, LANGUAGE)>> $@
	@echo $(call ESC, #)include $(call ESC, ")interpreter.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(TRANSPILERS)): transpiler.cpp)
	@echo // $(basename $(notdir $@)) transpiler driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, LANGUAGE)>> $@
	@echo $(call ESC, #)include $(call ESC, ")transpiler.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(GENERATORS)): generator.cpp)
	@echo // $(basename $(notdir $@)) documentation generator driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, EXTRACTOR)>> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, FORMATTER)>> $@
	@echo $(call ESC, #)include $(call ESC, ")generator.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(COMPILERS)): compiler.cpp)
	@echo // $(basename $(notdir $@)) compiler driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, FRONTEND)>> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, BACKEND)>> $@
	@echo $(call ESC, #)$(if $(filter $(TOOLSP)%.drv, $@),undef,define) CODEOPTIMIZER>> $@
	@echo $(call ESC, #)$(if $(filter $(TOOLS)fal%.drv $(TOOLSP)%code.drv, $@),undef,define) ASSEMBLYLISTING>> $@
	@echo $(call ESC, #)$(if $(filter $(TOOLS)fal%.drv $(TOOLSP)%code.drv, $@),undef,define) DEBUGGINGINFORMATION>> $@
	@echo $(call ESC, #)include $(call ESC, ")compiler.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(CONVERTERS)): converter.cpp)
	@echo // $(basename $(notdir $@)) converter driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, DEBUGFILEFORMAT)>> $@
	@echo $(call ESC, #)include $(call ESC, ")converter.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(ASSEMBLERS)): assembler.cpp)
	@echo // $(basename $(notdir $@)) assembler driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, ARCHITECTURE)>> $@
	@echo $(call ESC, #)include $(call ESC, ")assembler.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(DISASSEMBLERS)): disassembler.cpp)
	@echo // $(basename $(notdir $@)) disassembler driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, ARCHITECTURE)>> $@
	@echo $(call ESC, #)include $(call ESC, ")disassembler.cpp$(call ESC, ")>> $@

$(addprefix $(TOOLS), $(addsuffix .drv, $(LINKERS)): linker.cpp)
	@echo // $(basename $(notdir $@)) linker driver> $@
	@echo $(call ESC, #)define $(call CREATEMACRO, $@, LINKFILEFORMAT)>> $@
	@echo $(call ESC, #)include $(call ESC, ")linker.cpp$(call ESC, ")>> $@

$(SRC:.cpp=$(O)): %$(O): %.cpp
	@cd $(dir $<) && $(CC) $(CFLAGS) $(notdir $<)

$(DRV:.drv=$(O)): %$(O): %.drv
	@cd $(dir $<) && $(CC) $(CFLAGS) $(notdir $<)

$(BIN): %$(PRG): %$(O)
	@cd $(dir $<) && $(LD) $(LFLAGS) $(notdir $^)

tools: $(filter $(TOOLSP)%, $(BIN))
utilities: $(filter $(UTILITIESP)%, $(BIN))

# runtime

CURR := $(call DIR,./)
PREV := $(call DIR,../)
RUNTIME := $(call DIR,runtime/)
RUNTIMEP := $(call DIRP,runtime/)
CPPLIBRARY := $(call DIR,libraries/cpp/)
APILIBRARY := $(call DIR,libraries/api/)
OBLIBRARY := $(call DIR,libraries/oberon/)

export ECSINCLUDE := $(call DIR,$(abspath $(CPPLIBRARY))/)

ASM := $(addprefix $(RUNTIME), amd32linuxrun.asm amd64linuxrun.asm arma32linuxrun.asm arma64linuxrun.asm armt32linuxrun.asm armt32fpelinuxrun.asm at32uc3a3run.asm atmega32run.asm atmega328run.asm atmega8515run.asm avrremote.asm bios16run.asm bios32run.asm bios64run.asm dosrun.asm efi32run.asm efi64run.asm mips32linuxrun.asm mmixsimrun.asm or1ksimrun.asm osx32run.asm osx64run.asm riscdiskrun.asm rpi2brun.asm tosapi.asm tosrun.asm webassemblyrun.asm win32run.asm win64run.asm xtensalinuxrun.asm)
OBF := $(ASM:.asm=.obf) $(addprefix $(RUNTIME), $(addsuffix run.obf, $(BACKENDS)) $(foreach TARGET, amd32 amd64 arma32 arma64 armt32 armt32fpe mips32, $(TARGET)libdl.obf $(TARGET)libpthread.obf $(TARGET)libsdl.obf) $(foreach TARGET, 32 64, win$(TARGET)api.obf win$(TARGET)sdl.obf))
LIB := $(addprefix $(RUNTIME), $(addsuffix run.lib, $(addprefix cpp, $(BACKENDS)) $(addprefix ob, $(BACKENDS))))
CPP := $(addprefix $(CPPLIBRARY), cassert.cpp cctype.cpp cmath.cpp csetjmp.cpp cstdio.cpp cstdlib.cpp cstring.cpp ctime.cpp exception.cpp)
HDR := $(addprefix $(CPPLIBRARY), algorithm any array assert.h atomic barrier bit bitset cassert cctype cerrno cfenv cfloat charconv chrono cinttypes climits clocale cmath codecvt compare complex complex.h concepts condition_variable coroutine csetjmp csignal cstdarg cstddef cstdint cstdio cstdlib cstring ctime ctype.h cuchar cwchar cwctype deque errno.h exception execution expected fenv.h filesystem flat_map flat_set float.h format forward_list fstream functional future generator initializer_list inttypes.h iomanip ios iosfwd iostream iso646.h istream iterator latch limits limits.h list locale locale.h map math.h mdspan memory memory_resource mutex new numbers numeric optional ostream print queue random ranges ratio rcu regex scoped_allocator semaphore set setjmp.h shared_mutex signal.h source_location span spanstream sstream stack stacktrace stdalign.h stdarg.h stdatomic.h stdbool.h stddef.h stdexcept stdfloat stdint.h stdio.h stdlib.h stop_token streambuf string string.h string_view strstream syncstream system_error text_encoding tgmath.h thread time.h tuple type_traits typeindex typeinfo uchar.h unordered_map unordered_set utility valarray variant vector version wchar.h wctype.h)
RUN := $(addprefix $(CPPLIBRARY), cctype cmath cstdio cstring)
API := $(addprefix $(APILIBRARY), dlfcn.h SDL.h tos.h windows.h)
OBL := $(addprefix $(OBLIBRARY), obl.arguments.mod obl.hashes.mod obl.basictypes.mod obl.booleans.mod obl.characters.mod obl.devices.mod obl.exceptions.mod obl.files.mod obl.iostreams.mod obl.streams.mod obl.iterators.mod obl.arrays.mod obl.coroutines.mod obl.dynamicarrays.mod obl.generators.mod obl.lists.mod obl.pairs.mod obl.hashmaps.mod obl.functions.mod obl.in.mod obl.math.mod obl.out.mod obl.random.mod obl.sets.mod obl.strings.mod)
EXT := $(addprefix $(OBLIBRARY), api.linux.mod api.pthread.mod api.sdl.mod api.windows.mod)
OAK := $(addprefix $(OBLIBRARY), coroutines.mod in.mod math.mod mathc.mod mathl.mod mathlc.mod out.mod strings.mod xyplane.mod)
MOD := $(OBL) $(EXT) $(OAK)
SYM := $(MOD:.mod=.sym)

$(addprefix $(RUNTIME), arma32linuxrun.obf rpi2brun.obf): $(TOOLS)arma32asm$(PRG)
$(addprefix $(RUNTIME), arma64linuxrun.obf): $(TOOLS)arma64asm$(PRG)
$(addprefix $(RUNTIME), armt32linuxrun.obf armt32fpelinuxrun.obf): $(TOOLS)armt32asm$(PRG)
$(addprefix $(RUNTIME), at32uc3a3run.obf): $(TOOLS)avr32asm$(PRG)
$(addprefix $(RUNTIME), atmega32run.obf atmega328run.obf atmega8515run.obf avrremote.obf): $(TOOLS)avrasm$(PRG)
$(addprefix $(RUNTIME), bios16run.obf dosrun.obf): $(TOOLS)amd16asm$(PRG)
$(addprefix $(RUNTIME), bios32run.obf efi32run.obf osx32run.obf win32run.obf amd32linuxrun.obf): $(TOOLS)amd32asm$(PRG)
$(addprefix $(RUNTIME), bios64run.obf efi64run.obf osx64run.obf win64run.obf amd64linuxrun.obf): $(TOOLS)amd64asm$(PRG)
$(addprefix $(RUNTIME), mips32linuxrun.obf): $(TOOLS)mips32asm$(PRG)
$(addprefix $(RUNTIME), mmixsimrun.obf): $(TOOLS)mmixasm$(PRG)
$(addprefix $(RUNTIME), or1ksimrun.obf): $(TOOLS)or1kasm$(PRG)
$(addprefix $(RUNTIME), riscdiskrun.obf): $(TOOLS)riscasm$(PRG)
$(addprefix $(RUNTIME), tosapi.obf tosrun.obf): $(TOOLS)m68kasm$(PRG)
$(addprefix $(RUNTIME), webassemblyrun.obf): $(TOOLS)wasmasm$(PRG)
$(addprefix $(RUNTIME), xtensalinuxrun.obf): $(TOOLS)xtensaasm$(PRG)

$(ASM:.asm=.obf): %.obf: %.asm
	@cd $(RUNTIME) && $(PREV)$(lastword $^) $(notdir $<)

$(RUNTIME)coderun.obf: $(TOOLS)cppcode$(PRG) $(TOOLS)asmprint$(PRG) $(RUNTIME)runtime.cpp $(RUN)
	@cd $(RUNTIME) && $(PREV)$< runtime.cpp
	@$(TOOLS)asmprint$(PRG) $(RUNTIME)runtime.cod > $@
	@$(RM) $(RUNTIME)runtime.cod

$(TARGETS:%=$(RUNTIMEP)%run.obf): $(RUNTIMEP)%run.obf: $(TOOLS)cpp%$(PRG) $(RUNTIME)runtime.cpp $(RUN)
	@$(CP) $(RUNTIME)runtime.cpp $(@:.obf=.tmp)
	@cd $(RUNTIME) && $(PREV)$< $(notdir $(@:.obf=.tmp))
	@$(RM) $(@:.obf=.tmp) $(@:.obf=.lst) $(@:.obf=.dbg)

$(filter $(RUNTIMEP)%libdl.obf, $(OBF)): $(RUNTIMEP)%libdl.obf: $(TOOLS)cpp%$(PRG) $(RUNTIME)libdl.cpp $(RUNTIME)linuxlib.hpp
	@$(CP) $(RUNTIME)libdl.cpp $(@:.obf=.tmp)
	@cd $(RUNTIME) && $(PREV)$< $(notdir $(@:.obf=.tmp))
	@$(RM) $(@:.obf=.tmp) $(@:.obf=.lst) $(@:.obf=.dbg)

$(filter $(RUNTIMEP)%libpthread.obf, $(OBF)): $(RUNTIMEP)%libpthread.obf: $(TOOLS)cpp%$(PRG) $(RUNTIME)libpthread.cpp $(RUNTIME)linuxlib.hpp
	@$(CP) $(RUNTIME)libpthread.cpp $(@:.obf=.tmp)
	@cd $(RUNTIME) && $(PREV)$< $(notdir $(@:.obf=.tmp))
	@$(RM) $(@:.obf=.tmp) $(@:.obf=.lst) $(@:.obf=.dbg)

$(filter $(RUNTIMEP)%libsdl.obf, $(OBF)): $(RUNTIMEP)%libsdl.obf: $(TOOLS)cpp%$(PRG) $(RUNTIME)libsdl.cpp $(RUNTIME)linuxlib.hpp $(RUNTIME)sdl.cpp
	@$(CP) $(RUNTIME)libsdl.cpp $(@:.obf=.tmp)
	@cd $(RUNTIME) && $(PREV)$< $(notdir $(@:.obf=.tmp))
	@$(RM) $(@:.obf=.tmp) $(@:.obf=.lst) $(@:.obf=.dbg)

$(RUNTIME)win32api.obf $(RUNTIME)win64api.obf: $(RUNTIME)win%api.obf: $(TOOLS)cppamd%$(PRG) $(RUNTIME)winapi.cpp $(RUNTIME)winlib.hpp
	@$(CP) $(RUNTIME)winapi.cpp $(@:.obf=.tmp)
	@cd $(RUNTIME) && $(PREV)$< $(notdir $(@:.obf=.tmp))
	@$(RM) $(@:.obf=.tmp) $(@:.obf=.lst) $(@:.obf=.dbg)

$(RUNTIME)win32sdl.obf $(RUNTIME)win64sdl.obf: $(RUNTIME)win%sdl.obf: $(TOOLS)cppamd%$(PRG) $(RUNTIME)winsdl.cpp $(RUNTIME)winlib.hpp $(RUNTIME)sdl.cpp
	@$(CP) $(RUNTIME)winsdl.cpp $(@:.obf=.tmp)
	@cd $(RUNTIME) && $(PREV)$< $(notdir $(@:.obf=.tmp))
	@$(RM) $(@:.obf=.tmp) $(@:.obf=.lst) $(@:.obf=.dbg)

$(RUNTIME)cppcoderun.lib: $(TOOLS)cppcode$(PRG) $(TOOLS)asmprint$(PRG) $(CPP) $(HDR)
	@cd $(CPPLIBRARY) && $(PREV)$(PREV)$(TOOLS)cppcode$(PRG) $(notdir $(CPP))
	@$(TOOLS)asmprint$(PRG) $(CPP:.cpp=.cod) > $@
	@$(RM) $(CPP:.cpp=.cod)

$(TARGETS:%=$(RUNTIME)cpp%run.lib): $(RUNTIME)cpp%run.lib: $(TOOLS)cpp%$(PRG) $(TOOLS)linklib$(PRG) $(CPP) $(HDR)
	@cd $(CPPLIBRARY) && $(PREV)$(PREV)$< $(notdir $(CPP))
	-@$(RM) $@
	@$(TC) $@
	@cd $(RUNTIME) && $(PREV)$(TOOLS)linklib$(PRG) $(notdir $@) $(addprefix $(PREV), $(CPP:.cpp=.obf))
	@$(RM) $(CPP:.cpp=.lst) $(CPP:.cpp=.dbg) $(CPP:.cpp=.obf)

$(RUNTIME)obcoderun.lib: $(TOOLS)obcode$(PRG) $(TOOLS)asmprint$(PRG) $(MOD)
	@cd $(OBLIBRARY) && $(PREV)$(PREV)$(TOOLS)obcode$(PRG) $(notdir $(MOD))
	@$(TOOLS)asmprint$(PRG) $(MOD:.mod=.cod) > $@
	@$(RM) $(MOD:.mod=.cod)

$(TARGETS:%=$(RUNTIME)ob%run.lib): $(RUNTIME)ob%run.lib: $(TOOLS)ob%$(PRG) $(TOOLS)linklib$(PRG) $(MOD)
	@cd $(OBLIBRARY) && $(PREV)$(PREV)$< $(notdir $(MOD))
	-@$(RM) $@
	@$(TC) $@
	@cd $(RUNTIME) && $(PREV)$(TOOLS)linklib$(PRG) $(notdir $@) $(addprefix $(PREV), $(MOD:.mod=.obf))
	@$(RM) $(MOD:.mod=.lst) $(MOD:.mod=.dbg) $(MOD:.mod=.obf)

ifeq "$(filter %target install $(RUNTIME)cpp%run.lib $(RUNTIME)ob%run.lib,$(MAKECMDGOALS))" ""
$(foreach TARGET, $(TARGETS), $(eval $(TARGET:%=$(RUNTIME)cpp%run.lib): | $(word $(call FINDMATCH, $(TARGETS), $(TARGET)), $(RUNTIME)cppcoderun.lib $(TARGETS:%=$(RUNTIME)cpp%run.lib))))
$(foreach TARGET, $(TARGETS), $(eval $(TARGET:%=$(RUNTIME)ob%run.lib): | $(word $(call FINDMATCH, $(TARGETS), $(TARGET)), $(RUNTIME)obcoderun.lib $(TARGETS:%=$(RUNTIME)ob%run.lib))))
else
.NOTPARALLEL:
endif

$(SYM): %.sym: %.mod $(TOOLS)obcheck$(PRG)
	@cd $(OBLIBRARY) && $(PREV)$(PREV)$(TOOLS)obcheck$(PRG) $(notdir $<)

$(addprefix $(OBLIBRARY), coroutines.sym: obl.coroutines.sym)
$(addprefix $(OBLIBRARY), math.sym mathc.sym mathl.sym mathlc.sym: obl.math.sym)
$(addprefix $(OBLIBRARY), obl.arrays.sym: obl.iterators.sym)
$(addprefix $(OBLIBRARY), obl.basictypes.sym: obl.hashes.sym)
$(addprefix $(OBLIBRARY), obl.coroutines.sym: obl.exceptions.sym)
$(addprefix $(OBLIBRARY), obl.dynamicarrays.sym: obl.arrays.sym obl.exceptions.sym obl.iterators.sym)
$(addprefix $(OBLIBRARY), obl.files.sym: obl.devices.sym)
$(addprefix $(OBLIBRARY), obl.functions.sym: obl.generators.sym obl.iterators.sym)
$(addprefix $(OBLIBRARY), obl.generators.sym: obl.coroutines.sym)
$(addprefix $(OBLIBRARY), obl.hashmaps.sym: obl.exceptions.sym obl.iterators.sym obl.pairs.sym obl.lists.sym)
$(addprefix $(OBLIBRARY), obl.iostreams.sym: obl.devices.sym obl.files.sym)
$(addprefix $(OBLIBRARY), obl.lists.sym: obl.exceptions.sym obl.iterators.sym)
$(addprefix $(OBLIBRARY), obl.out.sym: obl.math.sym)
$(addprefix $(OBLIBRARY), xyplane.sym: api.sdl.sym)

runtime: $(OBF) $(LIB) $(SYM)

# documentation

DOCUMENTATION := $(call DIR,documentation/)
DOCUMENTATIONP := $(call DIRP,documentation/)

TEX := $(addprefix $(DOCUMENTATION), manual.tex guide.tex cpp.tex false.tex oberon.tex assembly.tex amd64.tex arm.tex avr.tex avr32.tex m68k.tex mibl.tex mips.tex mmix.tex or1k.tex ppc.tex risc.tex wasm.tex xtensa.tex documentation.tex debugging.tex code.tex object.tex material.tex overview.tex implementation.tex)
SET := $(addprefix $(DOCUMENTATION), amd64.set arm.set arma32.set arma64.set avr.set avr32.set m68k.set mibl.set mips.set mmix.set or1k.set ppc.set risc.set wasm.set xtensa.set code.set)
DOC := $(addprefix $(DOCUMENTATION), cpplibrary.doc oblibrary.doc oaklibrary.doc)
PDF := $(TEX:.tex=.pdf)

$(DOCUMENTATION)cpplibrary.doc: $(TOOLS)cpplatex$(PRG) $(CPP)
	@cd $(CPPLIBRARY) && $(PREV)$(PREV)$(TOOLS)cpplatex$(PRG) $(notdir $(CPP))
	@$(CP) $(firstword $(CPP:.cpp=.tex)) $@
	@$(RM) $(firstword $(CPP:.cpp=.tex))

$(DOCUMENTATION)oblibrary.doc: $(TOOLS)obcheck$(PRG) $(TOOLS)oblatex$(PRG) $(OBL)
	@cd $(OBLIBRARY) && $(PREV)$(PREV)$(TOOLS)obcheck$(PRG) $(notdir $(OBL))
	@cd $(OBLIBRARY) && $(PREV)$(PREV)$(TOOLS)oblatex$(PRG) $(sort $(notdir $(OBL)))
	@$(CP) $(firstword $(sort $(OBL:.mod=.tex))) $@
	@$(RM) $(firstword $(sort $(OBL:.mod=.tex)))

$(DOCUMENTATION)oaklibrary.doc: $(TOOLS)obcheck$(PRG) $(TOOLS)oblatex$(PRG) $(EXT) $(OAK)
	@cd $(OBLIBRARY) && $(PREV)$(PREV)$(TOOLS)obcheck$(PRG) $(notdir $(EXT) $(OAK))
	@cd $(OBLIBRARY) && $(PREV)$(PREV)$(TOOLS)oblatex$(PRG) $(sort $(notdir $(OAK)))
	@$(CP) $(firstword $(sort $(OAK:.mod=.tex))) $@
	@$(RM) $(firstword $(sort $(OAK:.mod=.tex)))

$(SET): $(DOCUMENTATIONP)%.set: $(DOCUMENTATIONP)%.tab $(TOOLSP)%.def $(TOOLS)cppprep$(PRG)
	@$(TOOLS)cppprep$(PRG) $< > $@

$(PDF): $(DOCUMENTATIONP)%.pdf: $(DOCUMENTATIONP)%.tex $(DOCUMENTATION)utilities.tex $(DOCUMENTATION)references.bib
	@cd $(DOCUMENTATION) && pdflatex -interaction batchmode -no-shell-escape -file-line-error -halt-on-error -draftmode $(basename $(notdir $<)) > $(NUL)
	@$(if $(filter $(basename $(notdir $<)), manual), cd $(DOCUMENTATION) && makeindex -q $(basename $(notdir $<)) && makeindex -q tools && makeindex -q library && makeindex -q runtime && makeindex -q environment)
	@cd $(DOCUMENTATION) && bibtex $(basename $(notdir $<)) > $(NUL)
	@cd $(DOCUMENTATION) && pdflatex -interaction batchmode -no-shell-escape -file-line-error -halt-on-error -draftmode $(basename $(notdir $<)) > $(NUL)
	@cd $(DOCUMENTATION) && pdflatex -interaction batchmode -no-shell-escape -file-line-error -halt-on-error $(basename $(notdir $<)) > $(NUL)
	@cd $(DOCUMENTATION) && $(RM) $(addprefix $(basename $(notdir $<)), .aux .bbl .blg .idx .ilg .ind .lof .log .lot .nav .out .snm .tmb .toc .upa .upb .vrb)
	@$(if $(filter $(basename $(notdir $<)), manual), cd $(DOCUMENTATION) && $(RM) $(addprefix tools, .idx .ilg .ind) $(addprefix library, .idx .ilg .ind) $(addprefix runtime, .idx .ilg .ind) $(addprefix environment, .idx .ilg .ind))

$(filter $(SET:.set=.pdf), $(PDF)): %.pdf: %.set
$(addprefix $(DOCUMENTATION), cpp.pdf): $(DOCUMENTATION)cpplibrary.doc
$(addprefix $(DOCUMENTATION), oberon.pdf): $(DOCUMENTATION)oblibrary.doc $(DOCUMENTATION)oaklibrary.doc
$(addprefix $(DOCUMENTATION), assembly.pdf): $(SET)
$(addprefix $(DOCUMENTATION), arm.pdf): $(addprefix $(DOCUMENTATION), arma32.set arma64.set)
$(addprefix $(DOCUMENTATION), manual.pdf material.pdf): $(addprefix $(DOCUMENTATION), overview.pdf implementation.pdf)
$(addprefix $(DOCUMENTATION), manual.pdf): $(DOC) $(SET) $(TEX) $(addprefix $(DOCUMENTATION), introduction.tex interface.tex tools.tex extensions.tex faq.tex gpl.tex rse.tex fdl.tex)

documentation: $(PDF)

# tests

TESTS := $(call DIR,tests/)
TST := $(addprefix $(TESTS), linklib linkbin doccheck docprintcheck \
	amd64asm amd64printasm arma32asm arma32printasm arma64asm arma64printasm armt32asm armt32printasm avrasm avrprintasm avr32asm avr32printasm m68kasm m68kprintasm miblasm miblprintasm mips64asm mips64printasm mmixasm mmixprintasm or1kasm or1kprintasm ppc64asm ppc64printasm riscasm riscprintasm wasmasm wasmprintasm xtensaasm xtensaprintasm \
	cdcheck cdprintcheck cdrun cdprintrun cdamd32linux cdamd64linux cdarma32linux cdarma64linux cdarmt32linux cdarmt32fpelinux cdatmega32 cdatmega8515 cddos cdmips32linux cdmmixsim cdor1ksim cdosx32 cdosx64 cdqemuamd32 cdqemuamd64 cdqemuarma32 cdqemuarma64 cdqemuarmt32 cdqemuarmt32fpe cdqemumips32 cdqemuxtensa cdwebassembly cdwin32 cdwin64 \
	cppcheck cppprintcheck cppdump cppcppcheck cpprun cppprintrun cppcpprun cppcode cppamd32linux cppamd64linux cpparma32linux cpparma64linux cpparmt32linux cpparmt32fpelinux cppatmega32 cppatmega8515 cppdos cppmips32linux cppmmixsim cppor1ksim cpposx32 cpposx64 cppqemuamd32 cppqemuamd64 cppqemuarma32 cppqemuarma64 cppqemuarmt32 cppqemuarmt32fpe cppqemumips32 cppqemuxtensa cppwebassembly cppwin32 cppwin64 \
	falcheck falprintcheck faldump falrun falprintrun falcppcheck falcpprun falcode falamd32linux falamd64linux falarma32linux falarma64linux falarmt32linux falarmt32fpelinux falatmega32 falatmega8515 faldos falmips32linux falmmixsim falor1ksim falosx32 falosx64 falqemuamd32 falqemuamd64 falqemuarma32 falqemuarma64 falqemuarmt32 falqemuarmt32fpe falqemumips32 falqemuxtensa falwebassembly falwin32 falwin64 \
	obcheck obprintcheck obdump obrun obprintrun obcppcheck obcpprun obcode obamd32linux obamd64linux obarma32linux obarma64linux obarmt32linux obarmt32fpelinux obatmega32 obdos obmips32linux obmmixsim obor1ksim obosx32 obosx64 obqemuamd32 obqemuamd64 obqemuarma32 obqemuarma64 obqemuarmt32 obqemuarmt32fpe obqemumips32 obqemuxtensa obwebassembly obwin32 obwin64)
RES := $(TST:=.res)

export ECSIMPORT := $(call DIR,$(abspath $(TESTS))/)

.PHONY: linktests
linktests: $(addprefix $(TESTS), linklib linkbin)

$(TESTS)linklib: $(UTILITIES)regtest$(PRG) $(TESTS)linklib.tst $(TOOLS)linklib$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)linklib$(PRG)) linklib.tmp" linklib.tst linklib.tmp linklib.res
	@$(TC) $@

$(TESTS)linkbin: $(UTILITIES)regtest$(PRG) $(TESTS)linkbin.tst $(TOOLS)linkbin$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)linkbin$(PRG)) linkbin.tmp" linkbin.tst linkbin.tmp linkbin.res
	@$(TC) $@

.PHONY: doctests
doctests: $(addprefix $(TESTS), doccheck docprintcheck)

$(TESTS)doccheck: $(UTILITIES)regtest$(PRG) $(TESTS)doccheck.tst $(TOOLS)doccheck$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)doccheck$(PRG)) doccheck.tmp" doccheck.tst doccheck.tmp doccheck.res
	@$(TC) $@

$(TESTS)docprintcheck: $(UTILITIES)regtest$(PRG) $(TESTS)doccheck.tst $(TOOLS)docprint$(PRG) $(TOOLS)doccheck$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)docprint$(PRG)) docprintcheck.tmp > docprintcheck.doc && $(abspath $(TOOLS)doccheck$(PRG)) docprintcheck.doc" doccheck.tst docprintcheck.tmp docprintcheck.res
	@$(TC) $@

.PHONY: cdtests
cdtests: $(addprefix $(TESTS), cdcheck cdprintcheck cdrun cdprintrun $(foreach ENVIRONMENT, $(HOSTENVIRONMENTS), cd$(ENVIRONMENT)))

.PHONY: opttests
opttests: $(addprefix $(TESTS), cdoptrun cppoptcode faloptcode oboptcode)

$(TESTS)cdcheck: $(UTILITIES)regtest$(PRG) $(TESTS)cdcheck.tst $(TOOLS)cdcheck$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdcheck$(PRG)) cdcheck.tmp" cdcheck.tst cdcheck.tmp cdcheck.res
	@$(TC) $@

$(TESTS)cdprintcheck: $(UTILITIES)regtest$(PRG) $(TESTS)cdcheck.tst $(TOOLS)asmprint$(PRG) $(TOOLS)cdcheck$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) cdprintcheck.tmp > cdprintcheck.cod && $(abspath $(TOOLS)cdcheck$(PRG)) cdprintcheck.cod" cdcheck.tst cdprintcheck.tmp cdprintcheck.res
	@$(TC) $@

$(TESTS)cdrun: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdrun$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdrun$(PRG)) cdrun.tmp" cdrun.tst cdrun.tmp cdrun.res
	@$(TC) $@

$(TESTS)cdprintrun: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)asmprint$(PRG) $(TOOLS)cdrun$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) cdprintrun.tmp > cdprintrun.cod && $(abspath $(TOOLS)cdrun$(PRG)) cdprintrun.cod" cdrun.tst cdprintrun.tmp cdprintrun.res
	@$(TC) $@

$(TESTS)cdoptrun: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdopt$(PRG) $(TOOLS)cdrun$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdopt$(PRG)) cdoptrun.tmp > cdoptrun.opt && $(abspath $(TOOLS)cdrun$(PRG)) cdoptrun.opt" cdrun.tst cdoptrun.tmp cdoptrun.res
	@$(TC) $@

.PHONY: cpptests
cpptests: $(addprefix $(TESTS), cppcheck cppprintcheck cpprun cppprintrun cppcode $(foreach ENVIRONMENT, $(HOSTENVIRONMENTS), cpp$(ENVIRONMENT)))

$(TESTS)cppcheck: $(UTILITIES)regtest$(PRG) $(TESTS)stdcppcheck.tst $(TESTS)extcppcheck.tst $(TOOLS)cppcheck$(PRG) $(HDR)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppcheck$(PRG)) cppcheck.tmp" stdcppcheck.tst cppcheck.tmp stdcppcheck.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppcheck$(PRG)) cppcheck.tmp" extcppcheck.tst cppcheck.tmp extcppcheck.res
	@$(TC) $@

$(TESTS)cppprintcheck: $(UTILITIES)regtest$(PRG) $(TESTS)stdcppcheck.tst $(TESTS)extcppcheck.tst $(TOOLS)cppprint$(PRG) $(TOOLS)cppcheck$(PRG) $(HDR)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppprint$(PRG)) cppprintcheck.tmp > cppprintcheck.cpp && $(abspath $(TOOLS)cppcheck$(PRG)) cppprintcheck.cpp" stdcppcheck.tst cppprintcheck.tmp stdcppprintcheck.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppprint$(PRG)) cppprintcheck.tmp > cppprintcheck.cpp && $(abspath $(TOOLS)cppcheck$(PRG)) cppprintcheck.cpp" extcppcheck.tst cppprintcheck.tmp extcppprintcheck.res
	@$(TC) $@

$(TESTS)cppcppcheck: $(UTILITIES)regtest$(PRG) $(TESTS)stdcppcheck.tst
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(CC) $(CCHECKFLAGS) cppcppcheck.cpp" stdcppcheck.tst cppcppcheck.cpp cppcppcheck.res
	@$(TC) $@

$(TESTS)cpprun: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpprun$(PRG) $(CPP) $(HDR) $(RUNTIME)cpprunrun.cpp $(RUNTIME)runtime.cpp
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpprun$(PRG)) cpprun.tmp $(abspath $(RUNTIME)cpprunrun.cpp)" stdcpprun.tst cpprun.tmp stdcpprun.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpprun$(PRG)) cpprun.tmp $(abspath $(RUNTIME)cpprunrun.cpp)" extcpprun.tst cpprun.tmp extcpprun.res
	@$(TC) $@

$(TESTS)cppprintrun: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppprint$(PRG) $(TOOLS)cpprun$(PRG) $(CPP) $(HDR) $(RUNTIME)cpprunrun.cpp $(RUNTIME)runtime.cpp
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppprint$(PRG)) cppprintrun.tmp > cppprintrun.cpp && $(abspath $(TOOLS)cpprun$(PRG)) cppprintrun.cpp $(abspath $(RUNTIME)cpprunrun.cpp)" stdcpprun.tst cppprintrun.tmp stdcppprintrun.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppprint$(PRG)) cppprintrun.tmp > cppprintrun.cpp && $(abspath $(TOOLS)cpprun$(PRG)) cppprintrun.cpp $(abspath $(RUNTIME)cpprunrun.cpp)" extcpprun.tst cppprintrun.tmp extcppprintrun.res
	@$(TC) $@

$(TESTS)cppcpprun: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(CC) $(CRUNFLAGS) cppcpprun.cpp && $(LD) $(LRUNFLAGS)cppcpprun$(PRG) cppcpprun$(O) && $(CURR)cppcpprun$(PRG)" stdcpprun.tst cppcpprun.cpp cppcpprun.res
	@$(TC) $@

$(TESTS)cppcode: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppcode$(PRG) $(TOOLS)cdrun$(PRG) $(RUNTIME)coderun.obf $(RUNTIME)cppcoderun.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppcode$(PRG)) cppcode.tmp && $(abspath $(TOOLS)cdrun$(PRG)) cppcode.cod $(abspath $(RUNTIME)coderun.obf $(RUNTIME)cppcoderun.lib)" stdcpprun.tst cppcode.tmp stdcppcode.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppcode$(PRG)) cppcode.tmp && $(abspath $(TOOLS)cdrun$(PRG)) cppcode.cod $(abspath $(RUNTIME)coderun.obf $(RUNTIME)cppcoderun.lib)" extcpprun.tst cppcode.tmp extcppcode.res
	@$(TC) $@

$(TESTS)cppoptcode: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppcode$(PRG) $(TOOLS)cdopt$(PRG) $(TOOLS)cdrun$(PRG) $(RUNTIME)coderun.obf $(RUNTIME)cppcoderun.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppcode$(PRG)) cppoptcode.tmp && $(abspath $(TOOLS)cdopt$(PRG)) cppoptcode.cod > cppoptcode.opt && $(abspath $(TOOLS)cdrun$(PRG)) cppoptcode.opt $(abspath $(RUNTIME)coderun.obf $(RUNTIME)cppcoderun.lib)" stdcpprun.tst cppoptcode.tmp stdcppoptcode.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppcode$(PRG)) cppoptcode.tmp && $(abspath $(TOOLS)cdopt$(PRG)) cppoptcode.cod > cppoptcode.opt && $(abspath $(TOOLS)cdrun$(PRG)) cppoptcode.opt $(abspath $(RUNTIME)coderun.obf $(RUNTIME)cppcoderun.lib)" extcpprun.tst cppoptcode.tmp extcppoptcode.res
	@$(TC) $@

.PHONY: faltests
faltests: $(addprefix $(TESTS), falcheck falprintcheck falrun falprintrun falcode $(foreach ENVIRONMENT, $(HOSTENVIRONMENTS), fal$(ENVIRONMENT)))

$(TESTS)falcheck: $(UTILITIES)regtest$(PRG) $(TESTS)falcheck.tst $(TOOLS)falcheck$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falcheck$(PRG)) falcheck.tmp" falcheck.tst falcheck.tmp falcheck.res
	@$(TC) $@

$(TESTS)falprintcheck: $(UTILITIES)regtest$(PRG) $(TESTS)falcheck.tst $(TOOLS)falprint$(PRG) $(TOOLS)falcheck$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falprint$(PRG)) falprintcheck.tmp > falprintcheck.fal && $(abspath $(TOOLS)falcheck$(PRG)) falprintcheck.fal" falcheck.tst falprintcheck.tmp falprintcheck.res
	@$(TC) $@

$(TESTS)falrun: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falrun$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falrun$(PRG)) falrun.tmp" falrun.tst falrun.tmp falrun.res
	@$(TC) $@

$(TESTS)falprintrun: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falprint$(PRG) $(TOOLS)falrun$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falprint$(PRG)) falprintrun.tmp > falprintrun.fal && $(abspath $(TOOLS)falrun$(PRG)) falprintrun.fal" falrun.tst falprintrun.tmp falprintrun.res
	@$(TC) $@

$(TESTS)falcode: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falcode$(PRG) $(TOOLS)cdrun$(PRG) $(RUNTIME)coderun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falcode$(PRG)) falcode.tmp && $(abspath $(TOOLS)cdrun$(PRG)) falcode.cod $(abspath $(RUNTIME)coderun.obf)" falrun.tst falcode.tmp falcode.res
	@$(TC) $@

$(TESTS)faloptcode: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falcode$(PRG) $(TOOLS)cdopt$(PRG) $(TOOLS)cdrun$(PRG) $(RUNTIME)coderun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falcode$(PRG)) faloptcode.tmp && $(abspath $(TOOLS)cdopt$(PRG)) faloptcode.cod > faloptcode.opt && $(abspath $(TOOLS)cdrun$(PRG)) faloptcode.opt $(abspath $(RUNTIME)coderun.obf)" falrun.tst faloptcode.tmp faloptcode.res
	@$(TC) $@

.PHONY: obtests
obtests: $(addprefix $(TESTS), obcheck obprintcheck obrun obprintrun obcode $(foreach ENVIRONMENT, $(HOSTENVIRONMENTS), ob$(ENVIRONMENT)))

$(TESTS)obcheck: $(UTILITIES)regtest$(PRG) $(TESTS)stdobcheck.tst $(TESTS)extobcheck.tst $(TESTS)import.sym $(TESTS)generic.sym $(TESTS)package.packaged.sym $(TOOLS)obcheck$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcheck$(PRG)) obcheck.tmp" stdobcheck.tst obcheck.tmp stdobcheck.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcheck$(PRG)) obcheck.tmp" extobcheck.tst obcheck.tmp extobcheck.res
	@$(TC) $@

$(TESTS)obprintcheck: $(UTILITIES)regtest$(PRG) $(TESTS)stdobcheck.tst $(TESTS)extobcheck.tst $(TESTS)import.sym $(TESTS)generic.sym $(TESTS)package.packaged.sym $(TOOLS)obprint$(PRG) $(TOOLS)obcheck$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obprint$(PRG)) obprintcheck.tmp > obprintcheck.mod && $(abspath $(TOOLS)obcheck$(PRG)) obprintcheck.mod" stdobcheck.tst obprintcheck.tmp stdobprintcheck.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obprint$(PRG)) obprintcheck.tmp > obprintcheck.mod && $(abspath $(TOOLS)obcheck$(PRG)) obprintcheck.mod" extobcheck.tst obprintcheck.tmp extobprintcheck.res
	@$(TC) $@

$(TESTS)obrun: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obrun$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obrun$(PRG)) obrun.tmp" stdobrun.tst obrun.tmp stdobrun.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obrun$(PRG)) $(abspath $(TESTS)generic.sym) obrun.tmp" extobrun.tst obrun.tmp extobrun.res
	@$(TC) $@

$(TESTS)obprintrun: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obprint$(PRG) $(TOOLS)obrun$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obprint$(PRG)) obprintrun.tmp > obprintrun.mod && $(abspath $(TOOLS)obrun$(PRG)) obprintrun.mod" stdobrun.tst obprintrun.tmp stdobprintrun.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obprint$(PRG)) obprintrun.tmp > obprintrun.mod && $(abspath $(TOOLS)obrun$(PRG)) $(abspath $(TESTS)generic.sym) obprintrun.mod" extobrun.tst obprintrun.tmp extobprintrun.res
	@$(TC) $@

$(TESTS)obcode: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obcode$(PRG) $(TOOLS)cdrun$(PRG) $(RUNTIME)coderun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcode$(PRG)) obcode.tmp && $(abspath $(TOOLS)cdrun$(PRG)) obcode.cod $(abspath $(RUNTIME)coderun.obf)" stdobrun.tst obcode.tmp stdobcode.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcode$(PRG)) obcode.tmp && $(abspath $(TOOLS)cdrun$(PRG)) obcode.cod $(abspath $(RUNTIME)coderun.obf)" extobrun.tst obcode.tmp extobcode.res
	@$(TC) $@

$(TESTS)oboptcode: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obcode$(PRG) $(TOOLS)cdopt$(PRG) $(TOOLS)cdrun$(PRG) $(RUNTIME)coderun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcode$(PRG)) oboptcode.tmp && $(abspath $(TOOLS)cdopt$(PRG)) oboptcode.cod > oboptcode.opt && $(abspath $(TOOLS)cdrun$(PRG)) oboptcode.opt $(abspath $(RUNTIME)coderun.obf)" stdobrun.tst oboptcode.tmp stdoboptcode.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcode$(PRG)) oboptcode.tmp && $(abspath $(TOOLS)cdopt$(PRG)) oboptcode.cod > oboptcode.opt && $(abspath $(TOOLS)cdrun$(PRG)) oboptcode.opt $(abspath $(RUNTIME)coderun.obf)" extobrun.tst oboptcode.tmp extoboptcode.res
	@$(TC) $@

.PHONY: asmtests
asmtests: $(addprefix $(TESTS), cdcheck cdprintcheck amd64asm amd64printasm arma32asm arma32printasm arma64asm arma64printasm armt32asm armt32printasm avrasm avrprintasm avr32asm avr32printasm m68kasm m68kprintasm miblasm miblprintasm mips64asm mips64printasm mmixasm mmixprintasm or1kasm or1kprintasm ppc64asm ppc64printasm riscasm riscprintasm wasmasm wasmprintasm xtensaasm xtensaprintasm)

$(TESTS)amd64asm: $(UTILITIES)regtest$(PRG) $(TESTS)amd64asm.tst $(TOOLS)amd64asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)amd64asm$(PRG)) amd64asm.tmp" amd64asm.tst amd64asm.tmp amd64asm.res
	@$(TC) $@

$(TESTS)amd64printasm: $(UTILITIES)regtest$(PRG) $(TESTS)amd64asm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)amd64asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) amd64printasm.tmp > amd64printasm.asm && $(abspath $(TOOLS)amd64asm$(PRG)) amd64printasm.asm" amd64asm.tst amd64printasm.tmp amd64printasm.res
	@$(TC) $@

$(TESTS)arma32asm: $(UTILITIES)regtest$(PRG) $(TESTS)arma32asm.tst $(TOOLS)arma32asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)arma32asm$(PRG)) arma32asm.tmp" arma32asm.tst arma32asm.tmp arma32asm.res
	@$(TC) $@

$(TESTS)arma32printasm: $(UTILITIES)regtest$(PRG) $(TESTS)arma32asm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)arma32asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) arma32printasm.tmp > arma32printasm.asm && $(abspath $(TOOLS)arma32asm$(PRG)) arma32printasm.asm" arma32asm.tst arma32printasm.tmp arma32printasm.res
	@$(TC) $@

$(TESTS)arma64asm: $(UTILITIES)regtest$(PRG) $(TESTS)arma64asm.tst $(TOOLS)arma64asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)arma64asm$(PRG)) arma64asm.tmp" arma64asm.tst arma64asm.tmp arma64asm.res
	@$(TC) $@

$(TESTS)arma64printasm: $(UTILITIES)regtest$(PRG) $(TESTS)arma64asm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)arma64asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) arma64printasm.tmp > arma64printasm.asm && $(abspath $(TOOLS)arma64asm$(PRG)) arma64printasm.asm" arma64asm.tst arma64printasm.tmp arma64printasm.res
	@$(TC) $@

$(TESTS)armt32asm: $(UTILITIES)regtest$(PRG) $(TESTS)armt32asm.tst $(TOOLS)armt32asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)armt32asm$(PRG)) armt32asm.tmp" armt32asm.tst armt32asm.tmp armt32asm.res
	@$(TC) $@

$(TESTS)armt32printasm: $(UTILITIES)regtest$(PRG) $(TESTS)armt32asm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)armt32asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) armt32printasm.tmp > armt32printasm.asm && $(abspath $(TOOLS)armt32asm$(PRG)) armt32printasm.asm" armt32asm.tst armt32printasm.tmp armt32printasm.res
	@$(TC) $@

$(TESTS)avrasm: $(UTILITIES)regtest$(PRG) $(TESTS)avrasm.tst $(TOOLS)avrasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)avrasm$(PRG)) avrasm.tmp" avrasm.tst avrasm.tmp avrasm.res
	@$(TC) $@

$(TESTS)avrprintasm: $(UTILITIES)regtest$(PRG) $(TESTS)avrasm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)avrasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) avrprintasm.tmp > avrprintasm.asm && $(abspath $(TOOLS)avrasm$(PRG)) avrprintasm.asm" avrasm.tst avrprintasm.tmp avrprintasm.res
	@$(TC) $@

$(TESTS)avr32asm: $(UTILITIES)regtest$(PRG) $(TESTS)avr32asm.tst $(TOOLS)avr32asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)avr32asm$(PRG)) avr32asm.tmp" avr32asm.tst avr32asm.tmp avr32asm.res
	@$(TC) $@

$(TESTS)avr32printasm: $(UTILITIES)regtest$(PRG) $(TESTS)avr32asm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)avr32asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) avr32printasm.tmp > avr32printasm.asm && $(abspath $(TOOLS)avr32asm$(PRG)) avr32printasm.asm" avr32asm.tst avr32printasm.tmp avr32printasm.res
	@$(TC) $@

$(TESTS)m68kasm: $(UTILITIES)regtest$(PRG) $(TESTS)m68kasm.tst $(TOOLS)m68kasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)m68kasm$(PRG)) m68kasm.tmp" m68kasm.tst m68kasm.tmp m68kasm.res
	@$(TC) $@

$(TESTS)m68kprintasm: $(UTILITIES)regtest$(PRG) $(TESTS)m68kasm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)m68kasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) m68kprintasm.tmp > m68kprintasm.asm && $(abspath $(TOOLS)m68kasm$(PRG)) m68kprintasm.asm" m68kasm.tst m68kprintasm.tmp m68kprintasm.res
	@$(TC) $@

$(TESTS)miblasm: $(UTILITIES)regtest$(PRG) $(TESTS)miblasm.tst $(TOOLS)miblasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)miblasm$(PRG)) miblasm.tmp" miblasm.tst miblasm.tmp miblasm.res
	@$(TC) $@

$(TESTS)miblprintasm: $(UTILITIES)regtest$(PRG) $(TESTS)miblasm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)miblasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) miblprintasm.tmp > miblprintasm.asm && $(abspath $(TOOLS)miblasm$(PRG)) miblprintasm.asm" miblasm.tst miblprintasm.tmp miblprintasm.res
	@$(TC) $@

$(TESTS)mips64asm: $(UTILITIES)regtest$(PRG) $(TESTS)mips64asm.tst $(TOOLS)mips64asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)mips64asm$(PRG)) mips64asm.tmp" mips64asm.tst mips64asm.tmp mips64asm.res
	@$(TC) $@

$(TESTS)mips64printasm: $(UTILITIES)regtest$(PRG) $(TESTS)mips64asm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)mips64asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) mips64printasm.tmp > mips64printasm.asm && $(abspath $(TOOLS)mips64asm$(PRG)) mips64printasm.asm" mips64asm.tst mips64printasm.tmp mips64printasm.res
	@$(TC) $@

$(TESTS)mmixasm: $(UTILITIES)regtest$(PRG) $(TESTS)mmixasm.tst $(TOOLS)mmixasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)mmixasm$(PRG)) mmixasm.tmp" mmixasm.tst mmixasm.tmp mmixasm.res
	@$(TC) $@

$(TESTS)mmixprintasm: $(UTILITIES)regtest$(PRG) $(TESTS)mmixasm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)mmixasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) mmixprintasm.tmp > mmixprintasm.asm && $(abspath $(TOOLS)mmixasm$(PRG)) mmixprintasm.asm" mmixasm.tst mmixprintasm.tmp mmixprintasm.res
	@$(TC) $@

$(TESTS)or1kasm: $(UTILITIES)regtest$(PRG) $(TESTS)or1kasm.tst $(TOOLS)or1kasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)or1kasm$(PRG)) or1kasm.tmp" or1kasm.tst or1kasm.tmp or1kasm.res
	@$(TC) $@

$(TESTS)or1kprintasm: $(UTILITIES)regtest$(PRG) $(TESTS)or1kasm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)or1kasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) or1kprintasm.tmp > or1kprintasm.asm && $(abspath $(TOOLS)or1kasm$(PRG)) or1kprintasm.asm" or1kasm.tst or1kprintasm.tmp or1kprintasm.res
	@$(TC) $@

$(TESTS)ppc64asm: $(UTILITIES)regtest$(PRG) $(TESTS)ppc64asm.tst $(TOOLS)ppc64asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)ppc64asm$(PRG)) ppc64asm.tmp" ppc64asm.tst ppc64asm.tmp ppc64asm.res
	@$(TC) $@

$(TESTS)ppc64printasm: $(UTILITIES)regtest$(PRG) $(TESTS)ppc64asm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)ppc64asm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) ppc64printasm.tmp > ppc64printasm.asm && $(abspath $(TOOLS)ppc64asm$(PRG)) ppc64printasm.asm" ppc64asm.tst ppc64printasm.tmp ppc64printasm.res
	@$(TC) $@

$(TESTS)riscasm: $(UTILITIES)regtest$(PRG) $(TESTS)riscasm.tst $(TOOLS)riscasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)riscasm$(PRG)) riscasm.tmp" riscasm.tst riscasm.tmp riscasm.res
	@$(TC) $@

$(TESTS)riscprintasm: $(UTILITIES)regtest$(PRG) $(TESTS)riscasm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)riscasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) riscprintasm.tmp > riscprintasm.asm && $(abspath $(TOOLS)riscasm$(PRG)) riscprintasm.asm" riscasm.tst riscprintasm.tmp riscprintasm.res
	@$(TC) $@

$(TESTS)wasmasm: $(UTILITIES)regtest$(PRG) $(TESTS)wasmasm.tst $(TOOLS)wasmasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)wasmasm$(PRG)) wasmasm.tmp" wasmasm.tst wasmasm.tmp wasmasm.res
	@$(TC) $@

$(TESTS)wasmprintasm: $(UTILITIES)regtest$(PRG) $(TESTS)wasmasm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)wasmasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) wasmprintasm.tmp > wasmprintasm.asm && $(abspath $(TOOLS)wasmasm$(PRG)) wasmprintasm.asm" wasmasm.tst wasmprintasm.tmp wasmprintasm.res
	@$(TC) $@

$(TESTS)xtensaasm: $(UTILITIES)regtest$(PRG) $(TESTS)xtensaasm.tst $(TOOLS)xtensaasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)xtensaasm$(PRG)) xtensaasm.tmp" xtensaasm.tst xtensaasm.tmp xtensaasm.res
	@$(TC) $@

$(TESTS)xtensaprintasm: $(UTILITIES)regtest$(PRG) $(TESTS)xtensaasm.tst $(TOOLS)asmprint$(PRG) $(TOOLS)xtensaasm$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)asmprint$(PRG)) xtensaprintasm.tmp > xtensaprintasm.asm && $(abspath $(TOOLS)xtensaasm$(PRG)) xtensaprintasm.asm" xtensaasm.tst xtensaprintasm.tmp xtensaprintasm.res
	@$(TC) $@

.PHONY: dumptests
dumptests: $(addprefix $(TESTS), cppdump faldump obdump)

$(TESTS)cppdump: $(UTILITIES)regtest$(PRG) $(TESTS)stdcppcheck.tst $(TESTS)extcppcheck.tst $(TOOLS)cppdump$(PRG) $(HDR) $(TESTS)cpp.dtd
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppdump$(PRG)) cppdump.tmp && xmllint --noout --valid --path $(abspath $(TESTS)) cppdump.xml" stdcppcheck.tst cppdump.tmp stdcppdump.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppdump$(PRG)) cppdump.tmp && xmllint --noout --valid --path $(abspath $(TESTS)) cppdump.xml" extcppcheck.tst cppdump.tmp extcppdump.res
	@$(TC) $@

$(TESTS)faldump: $(UTILITIES)regtest$(PRG) $(TESTS)falcheck.tst $(TOOLS)faldump$(PRG) $(TESTS)false.dtd
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)faldump$(PRG)) faldump.tmp && xmllint --noout --valid --path $(abspath $(TESTS)) faldump.xml" falcheck.tst faldump.tmp faldump.res
	@$(TC) $@

$(TESTS)obdump: $(UTILITIES)regtest$(PRG) $(TESTS)stdobcheck.tst $(TESTS)extobcheck.tst $(TESTS)import.sym $(TESTS)generic.sym $(TESTS)package.packaged.sym $(TOOLS)obdump$(PRG) $(TESTS)oberon.dtd
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obdump$(PRG)) obdump.tmp && xmllint --noout --valid --path $(abspath $(TESTS)) obdump.xml" stdobcheck.tst obdump.tmp stdobdump.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obdump$(PRG)) obdump.tmp && xmllint --noout --valid --path $(abspath $(TESTS)) obdump.xml" extobcheck.tst obdump.tmp extobdump.res
	@$(TC) $@

.PHONY: transtests
transtests: $(addprefix $(TESTS), falcppcheck falcpprun obcppcheck obcpprun)

$(TESTS)falcppcheck: $(UTILITIES)regtest$(PRG) $(TESTS)falcheck.tst $(TOOLS)falcpp$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falcpp$(PRG)) falcppcheck.tmp && $(CC) $(CCHECKFLAGS) falcppcheck.cpp" falcheck.tst falcppcheck.tmp falcppcheck.res
	@$(TC) $@

$(TESTS)falcpprun: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falcpp$(PRG)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falcpp$(PRG)) falcpprun.tmp && $(CC) $(CRUNFLAGS) falcpprun.cpp && $(LD) $(LRUNFLAGS)falcpprun$(PRG) falcpprun$(O) && $(CURR)falcpprun$(PRG)" falrun.tst falcpprun.tmp falcpprun.res
	@$(TC) $@

$(TESTS)obcppcheck: $(UTILITIES)regtest$(PRG) $(TESTS)stdobcheck.tst $(TESTS)extobcheck.tst $(TESTS)import.sym $(TESTS)generic.sym $(TESTS)package.packaged.sym $(TOOLS)obcpp$(PRG) $(RUNTIME)obcpprun.hpp
	@cd $(TESTS) && $(abspath $(TOOLS)obcpp$(PRG)) import.sym generic.sym package.packaged.sym
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcpp$(PRG)) obcppcheck.tmp && $(CC) $(CCHECKFLAGS) -I $(abspath $(TESTS)) -I $(abspath $(RUNTIME)) test.cpp" stdobcheck.tst obcppcheck.tmp stdobcppcheck.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcpp$(PRG)) obcppcheck.tmp && $(CC) $(CCHECKFLAGS) -I $(abspath $(TESTS)) -I $(abspath $(RUNTIME)) test.cpp" extobcheck.tst obcppcheck.tmp extobcppcheck.res
	@cd $(TESTS) && $(RM) import.cpp import.hpp generic.cpp generic.hpp package.packaged.cpp package.packaged.hpp
	@$(TC) $@

$(TESTS)obcpprun: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obcpp$(PRG) $(RUNTIME)obcpprun.hpp $(RUNTIME)obcpprun.cpp | $(TESTS)obcppcheck
	@cd $(TESTS) && $(abspath $(TOOLS)obcpp$(PRG)) generic.sym
	@cd $(TESTS) && $(CC) $(CRUNFLAGS) $(abspath $(RUNTIME)obcpprun.cpp)
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcpp$(PRG)) obcpprun.tmp && $(CC) $(CRUNFLAGS) -I $(abspath $(TESTS)) -I $(abspath $(RUNTIME)) test.cpp && $(LD) $(LRUNFLAGS)obcpprun$(PRG) test$(O) $(abspath $(TESTS)obcpprun$(O)) && $(CURR)obcpprun$(PRG)" stdobrun.tst obcpprun.tmp stdobcpprun.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obcpp$(PRG)) obcpprun.tmp && $(CC) $(CRUNFLAGS) -I $(abspath $(TESTS)) -I $(abspath $(RUNTIME)) test.cpp && $(LD) $(LRUNFLAGS)obcpprun$(PRG) test$(O) $(abspath $(TESTS)obcpprun$(O)) && $(CURR)obcpprun$(PRG)" extobrun.tst obcpprun.tmp extobcpprun.res
	@cd $(TESTS) && $(RM) generic.cpp generic.hpp obcpprun$(O)
	@$(TC) $@

.PHONY: codetests
codetests: $(addprefix $(TESTS), cppcode falcode obcode)

.PHONY: hosttests
hosttests: $(foreach ENVIRONMENT, $(HOSTENVIRONMENTS), $(ENVIRONMENT)tests)

.PHONY: amd32linuxtests
amd32linuxtests: $(addprefix $(TESTS), cdamd32linux cppamd32linux falamd32linux obamd32linux)

$(TESTS)cdamd32linux: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd32$(PRG)) cdamd32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdamd32linux.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf) && chmod +x cdamd32linux && $(CURR)cdamd32linux" cdrun.tst cdamd32linux.tmp cdamd32linux.res
	@$(TC) $@

$(TESTS)cppamd32linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf $(RUNTIME)cppamd32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd32$(PRG)) cppamd32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppamd32linux.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf $(RUNTIME)cppamd32run.lib) && chmod +x cppamd32linux && $(CURR)cppamd32linux" stdcpprun.tst cppamd32linux.tmp stdcppamd32linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd32$(PRG)) cppamd32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppamd32linux.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf $(RUNTIME)cppamd32run.lib) && chmod +x cppamd32linux && $(CURR)cppamd32linux" extcpprun.tst cppamd32linux.tmp extcppamd32linux.res
	@$(TC) $@

$(TESTS)falamd32linux: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd32$(PRG)) falamd32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falamd32linux.obf $(abspath $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf)) && chmod +x falamd32linux && $(CURR)falamd32linux" falrun.tst falamd32linux.tmp falamd32linux.res
	@$(TC) $@

$(TESTS)obamd32linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd32$(PRG)) obamd32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obamd32linux.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf) && chmod +x obamd32linux && $(CURR)obamd32linux" stdobrun.tst obamd32linux.tmp stdobamd32linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd32$(PRG)) obamd32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obamd32linux.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf) && chmod +x obamd32linux && $(CURR)obamd32linux" extobrun.tst obamd32linux.tmp extobamd32linux.res
	@$(TC) $@

.PHONY: amd64linuxtests
amd64linuxtests: $(addprefix $(TESTS), cdamd64linux cppamd64linux falamd64linux obamd64linux)

$(TESTS)cdamd64linux: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd64$(PRG)) cdamd64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdamd64linux.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf) && chmod +x cdamd64linux && $(CURR)cdamd64linux" cdrun.tst cdamd64linux.tmp cdamd64linux.res
	@$(TC) $@

$(TESTS)cppamd64linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf $(RUNTIME)cppamd64run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd64$(PRG)) cppamd64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppamd64linux.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf $(RUNTIME)cppamd64run.lib) && chmod +x cppamd64linux && $(CURR)cppamd64linux" stdcpprun.tst cppamd64linux.tmp stdcppamd64linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd64$(PRG)) cppamd64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppamd64linux.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf $(RUNTIME)cppamd64run.lib) && chmod +x cppamd64linux && $(CURR)cppamd64linux" extcpprun.tst cppamd64linux.tmp extcppamd64linux.res
	@$(TC) $@

$(TESTS)falamd64linux: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd64$(PRG)) falamd64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falamd64linux.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf) && chmod +x falamd64linux && $(CURR)falamd64linux" falrun.tst falamd64linux.tmp falamd64linux.res
	@$(TC) $@

$(TESTS)obamd64linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd64$(PRG)) obamd64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obamd64linux.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf) && chmod +x obamd64linux && $(CURR)obamd64linux" stdobrun.tst obamd64linux.tmp stdobamd64linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd64$(PRG)) obamd64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obamd64linux.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf) && chmod +x obamd64linux && $(CURR)obamd64linux" extobrun.tst obamd64linux.tmp extobamd64linux.res
	@$(TC) $@

.PHONY: arma32linuxtests
arma32linuxtests: $(addprefix $(TESTS), cdarma32linux cpparma32linux falarma32linux obarma32linux)

$(TESTS)cdarma32linux: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdarma32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdarma32$(PRG)) cdarma32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdarma32linux.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf) && chmod +x cdarma32linux && $(CURR)cdarma32linux" cdrun.tst cdarma32linux.tmp cdarma32linux.res
	@$(TC) $@

$(TESTS)cpparma32linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpparma32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf $(RUNTIME)cpparma32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparma32$(PRG)) cpparma32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpparma32linux.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf $(RUNTIME)cpparma32run.lib) && chmod +x cpparma32linux && $(CURR)cpparma32linux" stdcpprun.tst cpparma32linux.tmp stdcpparma32linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparma32$(PRG)) cpparma32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpparma32linux.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf $(RUNTIME)cpparma32run.lib) && chmod +x cpparma32linux && $(CURR)cpparma32linux" extcpprun.tst cpparma32linux.tmp extcpparma32linux.res
	@$(TC) $@

$(TESTS)falarma32linux: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falarma32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falarma32$(PRG)) falarma32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falarma32linux.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf) && chmod +x falarma32linux && $(CURR)falarma32linux" falrun.tst falarma32linux.tmp falarma32linux.res
	@$(TC) $@

$(TESTS)obarma32linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obarma32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarma32$(PRG)) obarma32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obarma32linux.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf) && chmod +x obarma32linux && $(CURR)obarma32linux" stdobrun.tst obarma32linux.tmp stdobarma32linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarma32$(PRG)) obarma32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obarma32linux.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf) && chmod +x obarma32linux && $(CURR)obarma32linux" extobrun.tst obarma32linux.tmp extobarma32linux.res
	@$(TC) $@

.PHONY: arma64linuxtests
arma64linuxtests: $(addprefix $(TESTS), cdarma64linux cpparma64linux falarma64linux obarma64linux)

$(TESTS)cdarma64linux: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdarma64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdarma64$(PRG)) cdarma64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdarma64linux.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf) && chmod +x cdarma64linux && $(CURR)cdarma64linux" cdrun.tst cdarma64linux.tmp cdarma64linux.res
	@$(TC) $@

$(TESTS)cpparma64linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpparma64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf $(RUNTIME)cpparma64run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparma64$(PRG)) cpparma64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpparma64linux.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf $(RUNTIME)cpparma64run.lib) && chmod +x cpparma64linux && $(CURR)cpparma64linux" stdcpprun.tst cpparma64linux.tmp stdcpparma64linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparma64$(PRG)) cpparma64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpparma64linux.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf $(RUNTIME)cpparma64run.lib) && chmod +x cpparma64linux && $(CURR)cpparma64linux" extcpprun.tst cpparma64linux.tmp extcpparma64linux.res
	@$(TC) $@

$(TESTS)falarma64linux: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falarma64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falarma64$(PRG)) falarma64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falarma64linux.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf) && chmod +x falarma64linux && $(CURR)falarma64linux" falrun.tst falarma64linux.tmp falarma64linux.res
	@$(TC) $@

$(TESTS)obarma64linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obarma64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarma64$(PRG)) obarma64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obarma64linux.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf) && chmod +x obarma64linux && $(CURR)obarma64linux" stdobrun.tst obarma64linux.tmp stdobarma64linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarma64$(PRG)) obarma64linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obarma64linux.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf) && chmod +x obarma64linux && $(CURR)obarma64linux" extobrun.tst obarma64linux.tmp extobarma64linux.res
	@$(TC) $@

.PHONY: armt32linuxtests
armt32linuxtests: $(addprefix $(TESTS), cdarmt32linux cpparmt32linux falarmt32linux obarmt32linux)

$(TESTS)cdarmt32linux: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdarmt32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdarmt32$(PRG)) cdarmt32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdarmt32linux.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf) && chmod +x cdarmt32linux && $(CURR)cdarmt32linux" cdrun.tst cdarmt32linux.tmp cdarmt32linux.res
	@$(TC) $@

$(TESTS)cpparmt32linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpparmt32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf $(RUNTIME)cpparmt32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparmt32$(PRG)) cpparmt32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpparmt32linux.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf $(RUNTIME)cpparmt32run.lib) && chmod +x cpparmt32linux && $(CURR)cpparmt32linux" stdcpprun.tst cpparmt32linux.tmp stdcpparmt32linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparmt32$(PRG)) cpparmt32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpparmt32linux.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf $(RUNTIME)cpparmt32run.lib) && chmod +x cpparmt32linux && $(CURR)cpparmt32linux" extcpprun.tst cpparmt32linux.tmp extcpparmt32linux.res
	@$(TC) $@

$(TESTS)falarmt32linux: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falarmt32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falarmt32$(PRG)) falarmt32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falarmt32linux.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf) && chmod +x falarmt32linux && $(CURR)falarmt32linux" falrun.tst falarmt32linux.tmp falarmt32linux.res
	@$(TC) $@

$(TESTS)obarmt32linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TOOLS)obarmt32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarmt32$(PRG)) obarmt32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obarmt32linux.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf) && chmod +x obarmt32linux && $(CURR)obarmt32linux" stdobrun.tst obarmt32linux.tmp stdobarmt32linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarmt32$(PRG)) obarmt32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obarmt32linux.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf) && chmod +x obarmt32linux && $(CURR)obarmt32linux" extobrun.tst obarmt32linux.tmp extobarmt32linux.res
	@$(TC) $@

.PHONY: armt32fpelinuxtests
armt32fpelinuxtests: $(addprefix $(TESTS), cdarmt32fpelinux cpparmt32fpelinux falarmt32fpelinux obarmt32fpelinux)

$(TESTS)cdarmt32fpelinux: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdarmt32fpe$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdarmt32fpe$(PRG)) cdarmt32fpelinux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdarmt32fpelinux.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf) && chmod +x cdarmt32fpelinux && $(CURR)cdarmt32fpelinux" cdrun.tst cdarmt32fpelinux.tmp cdarmt32fpelinux.res
	@$(TC) $@

$(TESTS)cpparmt32fpelinux: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpparmt32fpe$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf $(RUNTIME)cpparmt32fperun.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparmt32fpe$(PRG)) cpparmt32fpelinux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpparmt32fpelinux.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf $(RUNTIME)cpparmt32fperun.lib) && chmod +x cpparmt32fpelinux && $(CURR)cpparmt32fpelinux" stdcpprun.tst cpparmt32fpelinux.tmp stdcpparmt32fpelinux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparmt32fpe$(PRG)) cpparmt32fpelinux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpparmt32fpelinux.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf $(RUNTIME)cpparmt32fperun.lib) && chmod +x cpparmt32fpelinux && $(CURR)cpparmt32fpelinux" extcpprun.tst cpparmt32fpelinux.tmp extcpparmt32fpelinux.res
	@$(TC) $@

$(TESTS)falarmt32fpelinux: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falarmt32fpe$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falarmt32fpe$(PRG)) falarmt32fpelinux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falarmt32fpelinux.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf) && chmod +x falarmt32fpelinux && $(CURR)falarmt32fpelinux" falrun.tst falarmt32fpelinux.tmp falarmt32fpelinux.res
	@$(TC) $@

$(TESTS)obarmt32fpelinux: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TOOLS)obarmt32fpe$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarmt32fpe$(PRG)) obarmt32fpelinux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obarmt32fpelinux.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf) && chmod +x obarmt32fpelinux && $(CURR)obarmt32fpelinux" stdobrun.tst obarmt32fpelinux.tmp stdobarmt32fpelinux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarmt32fpe$(PRG)) obarmt32fpelinux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obarmt32fpelinux.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf) && chmod +x obarmt32fpelinux && $(CURR)obarmt32fpelinux" extobrun.tst obarmt32fpelinux.tmp extobarmt32fpelinux.res
	@$(TC) $@

.PHONY: atmega32tests
atmega32tests: $(addprefix $(TESTS), cdatmega32 cppatmega32 falatmega32 obatmega32)

$(TESTS)cdatmega32: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdavr$(PRG) $(TOOLS)linkhex$(PRG) $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)avrremote.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdavr$(PRG)) cdatmega32.tmp && $(abspath $(TOOLS)linkhex$(PRG)) cdatmega32.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega32 -ms -ifcdatmega32.hex -e -pf -vf -g && remote com2" cdrun.tst cdatmega32.tmp cdatmega32.res
	@$(TC) $@

$(TESTS)cppatmega32: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppavr$(PRG) $(TOOLS)linkhex$(PRG) $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)cppavrrun.lib $(RUNTIME)avrremote.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppavr$(PRG)) cppatmega32.tmp && $(abspath $(TOOLS)linkhex$(PRG)) cppatmega32.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)cppavrrun.lib $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega32 -ms -ifstdcppatmega32.hex -e -pf -vf -g && remote com2" stdcpprun.tst cppatmega32.tmp stdcppatmega32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppavr$(PRG)) cppatmega32.tmp && $(abspath $(TOOLS)linkhex$(PRG)) cppatmega32.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)cppavrrun.lib $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega32 -ms -ifextcppatmega32.hex -e -pf -vf -g && remote com2" extcpprun.tst cppatmega32.tmp extcppatmega32.res
	@$(TC) $@

$(TESTS)falatmega32: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falavr$(PRG) $(TOOLS)linkhex$(PRG) $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)avrremote.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falavr$(PRG)) falatmega32.tmp && $(abspath $(TOOLS)linkhex$(PRG)) falatmega32.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega32 -ms -iffalatmega32.hex -e -pf -vf -g && remote com2" falrun.tst falatmega32.tmp falatmega32.res
	@$(TC) $@

$(TESTS)obatmega32: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obavr$(PRG) $(TOOLS)linkhex$(PRG) $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)avrremote.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obavr$(PRG)) obatmega32.tmp && $(abspath $(TOOLS)linkhex$(PRG)) obatmega32.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega32 -ms -ifobatmega32.hex -e -pf -vf -g && remote com2" stdobrun.tst obatmega32.tmp stdobatmega32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obavr$(PRG)) obatmega32.tmp && $(abspath $(TOOLS)linkhex$(PRG)) obatmega32.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega32run.obf $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega32 -ms -ifobatmega32.hex -e -pf -vf -g && remote com2" extobrun.tst obatmega32.tmp extobatmega32.res
	@$(TC) $@

.PHONY: atmega8515tests
atmega8515tests: $(addprefix $(TESTS), cdatmega8515 cppatmega8515 falatmega8515)

$(TESTS)cdatmega8515: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdavr$(PRG) $(TOOLS)linkhex$(PRG) $(RUNTIME)avrrun.obf $(RUNTIME)atmega8515run.obf $(RUNTIME)avrremote.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdavr$(PRG)) cdatmega8515.tmp && $(abspath $(TOOLS)linkhex$(PRG)) cdatmega8515.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega8515run.obf $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega8515 -ms -ifcdatmega8515.hex -e -pf -vf -g && remote com2" cdrun.tst cdatmega8515.tmp cdatmega8515.res
	@$(TC) $@

$(TESTS)cppatmega8515: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppavr$(PRG) $(TOOLS)linkhex$(PRG) $(RUNTIME)avrrun.obf $(RUNTIME)atmega8515run.obf $(RUNTIME)cppavrrun.lib $(RUNTIME)avrremote.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppavr$(PRG)) cppatmega8515.tmp && $(abspath $(TOOLS)linkhex$(PRG)) cppatmega8515.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega8515run.obf $(RUNTIME)cppavrrun.lib $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega8515 -ms -ifstdcppatmega8515.hex -e -pf -vf -g && remote com2" stdcpprun.tst cppatmega8515.tmp stdcppatmega8515.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppavr$(PRG)) cppatmega8515.tmp && $(abspath $(TOOLS)linkhex$(PRG)) cppatmega8515.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega8515run.obf $(RUNTIME)cppavrrun.lib $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega8515 -ms -ifextcppatmega8515.hex -e -pf -vf -g && remote com2" extcpprun.tst cppatmega8515.tmp extcppatmega8515.res
	@$(TC) $@

$(TESTS)falatmega8515: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falavr$(PRG) $(TOOLS)linkhex$(PRG) $(RUNTIME)avrrun.obf $(RUNTIME)atmega8515run.obf $(RUNTIME)avrremote.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falavr$(PRG)) falatmega8515.tmp && $(abspath $(TOOLS)linkhex$(PRG)) falatmega8515.obf $(abspath $(RUNTIME)avrrun.obf $(RUNTIME)atmega8515run.obf $(RUNTIME)avrremote.obf) && stk500 -ccom1 -dATmega8515 -ms -iffalatmega8515.hex -e -pf -vf -g && remote com2" falrun.tst falatmega8515.tmp falatmega8515.res
	@$(TC) $@

.PHONY: dostests
dostests: $(addprefix $(TESTS), cddos cppdos faldos obdos)

$(TESTS)cddos: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd16$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd16$(PRG)) cddos.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cddos.obf $(abspath $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf) && cddos.com" cdrun.tst cddos.tmp cddos.res
	@$(TC) $@

$(TESTS)cppdos: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd16$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf $(RUNTIME)cppamd16run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd16$(PRG)) cppdos.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppdos.obf $(abspath $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf $(RUNTIME)cppamd16run.lib) && cppdos.com" stdcpprun.tst cppdos.tmp stdcppdos.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd16$(PRG)) cppdos.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppdos.obf $(abspath $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf $(RUNTIME)cppamd16run.lib) && cppdos.com" extcpprun.tst cppdos.tmp extcppdos.res
	@$(TC) $@

$(TESTS)faldos: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd16$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd16$(PRG)) faldos.tmp && $(abspath $(TOOLS)linkbin$(PRG)) faldos.obf $(abspath $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf) && faldos.com" falrun.tst faldos.tmp faldos.res
	@$(TC) $@

$(TESTS)obdos: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd16$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd16$(PRG)) obdos.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obdos.obf $(abspath $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf) && obdos.com" stdobrun.tst obdos.tmp stdobdos.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd16$(PRG)) obdos.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obdos.obf $(abspath $(RUNTIME)amd16run.obf $(RUNTIME)dosrun.obf) && obdos.com" extobrun.tst obdos.tmp extobdos.res
	@$(TC) $@

.PHONY: mips32linuxtests
mips32linuxtests: $(addprefix $(TESTS), cdmips32linux cppmips32linux falmips32linux obmips32linux)

$(TESTS)cdmips32linux: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdmips32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdmips32$(PRG)) cdmips32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdmips32linux.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf) && chmod +x cdmips32linux && $(CURR)cdmips32linux" cdrun.tst cdmips32linux.tmp cdmips32linux.res
	@$(TC) $@

$(TESTS)cppmips32linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppmips32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf $(RUNTIME)cppmips32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppmips32$(PRG)) cppmips32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppmips32linux.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf $(RUNTIME)cppmips32run.lib) && chmod +x cppmips32linux && $(CURR)cppmips32linux" stdcpprun.tst cppmips32linux.tmp stdcppmips32linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppmips32$(PRG)) cppmips32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppmips32linux.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf $(RUNTIME)cppmips32run.lib) && chmod +x cppmips32linux && $(CURR)cppmips32linux" extcpprun.tst cppmips32linux.tmp extcppmips32linux.res
	@$(TC) $@

$(TESTS)falmips32linux: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falmips32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falmips32$(PRG)) falmips32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falmips32linux.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf) && chmod +x falmips32linux && $(CURR)falmips32linux" falrun.tst falmips32linux.tmp falmips32linux.res
	@$(TC) $@

$(TESTS)obmips32linux: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obmips32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obmips32$(PRG)) obmips32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obmips32linux.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf) && chmod +x obmips32linux && $(CURR)obmips32linux" stdobrun.tst obmips32linux.tmp stdobmips32linux.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obmips32$(PRG)) obmips32linux.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obmips32linux.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf) && chmod +x obmips32linux && $(CURR)obmips32linux" extobrun.tst obmips32linux.tmp extobmips32linux.res
	@$(TC) $@

.PHONY: mmixsimtests
mmixsimtests: $(addprefix $(TESTS), cdmmixsim cppmmixsim falmmixsim obmmixsim)

$(TESTS)cdmmixsim: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdmmix$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdmmix$(PRG)) cdmmixsim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdmmixsim.obf $(abspath $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf) && mmix cdmmixsim.mmo" cdrun.tst cdmmixsim.tmp cdmmixsim.res
	@$(TC) $@

$(TESTS)cppmmixsim: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppmmix$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf $(RUNTIME)cppmmixrun.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppmmix$(PRG)) cppmmixsim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppmmixsim.obf $(abspath $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf $(RUNTIME)cppmmixrun.lib) && mmix cppmmixsim.mmo" stdcpprun.tst cppmmixsim.tmp stdcppmmixsim.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppmmix$(PRG)) cppmmixsim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppmmixsim.obf $(abspath $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf $(RUNTIME)cppmmixrun.lib) && mmix cppmmixsim.mmo" extcpprun.tst cppmmixsim.tmp extcppmmixsim.res
	@$(TC) $@

$(TESTS)falmmixsim: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falmmix$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falmmix$(PRG)) falmmixsim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falmmixsim.obf $(abspath $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf) && mmix falmmixsim.mmo" falrun.tst falmmixsim.tmp falmmixsim.res
	@$(TC) $@

$(TESTS)obmmixsim: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obmmix$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obmmix$(PRG)) obmmixsim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obmmixsim.obf $(abspath $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf) && mmix obmmixsim.mmo" stdobrun.tst obmmixsim.tmp stdobmmixsim.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obmmix$(PRG)) obmmixsim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obmmixsim.obf $(abspath $(RUNTIME)mmixrun.obf $(RUNTIME)mmixsimrun.obf) && mmix obmmixsim.mmo" extobrun.tst obmmixsim.tmp extobmmixsim.res
	@$(TC) $@

.PHONY: or1ksimtests
or1ksimtests: $(addprefix $(TESTS), cdor1ksim cppor1ksim falor1ksim obor1ksim)

$(TESTS)cdor1ksim: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdor1k$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdor1k$(PRG)) cdor1ksim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdor1ksim.obf $(abspath $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf) && or1ksim -q -m 1m cdor1ksim" cdrun.tst cdor1ksim.tmp cdor1ksim.res
	@$(TC) $@

$(TESTS)cppor1ksim: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppor1k$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf $(RUNTIME)cppor1krun.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppor1k$(PRG)) cppor1ksim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppor1ksim.obf $(abspath $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf $(RUNTIME)cppor1krun.lib) && or1ksim -q -m 1m cppor1ksim" stdcpprun.tst cppor1ksim.tmp stdcppor1ksim.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppor1k$(PRG)) cppor1ksim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppor1ksim.obf $(abspath $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf $(RUNTIME)cppor1krun.lib) && or1ksim -q -m 1m cppor1ksim" extcpprun.tst cppor1ksim.tmp extcppor1ksim.res
	@$(TC) $@

$(TESTS)falor1ksim: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falor1k$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falor1k$(PRG)) falor1ksim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falor1ksim.obf $(abspath $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf) && or1ksim -q -m 1m falor1ksim" falrun.tst falor1ksim.tmp falor1ksim.res
	@$(TC) $@

$(TESTS)obor1ksim: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obor1k$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obor1k$(PRG)) obor1ksim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obor1ksim.obf $(abspath $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf) && or1ksim -q -m 1m obor1ksim" stdobrun.tst obor1ksim.tmp stdobor1ksim.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obor1k$(PRG)) obor1ksim.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obor1ksim.obf $(abspath $(RUNTIME)or1krun.obf $(RUNTIME)or1ksimrun.obf) && or1ksim -q -m 1m obor1ksim" extobrun.tst obor1ksim.tmp extobor1ksim.res
	@$(TC) $@

.PHONY: osx32tests
osx32tests: $(addprefix $(TESTS), cdosx32 cpposx32 falosx32 obosx32)

$(TESTS)cdosx32: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd32$(PRG)) cdosx32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdosx32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf) && chmod +x cdosx32 && $(CURR)cdosx32" cdrun.tst cdosx32.tmp cdosx32.res
	@$(TC) $@

$(TESTS)cpposx32: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf $(RUNTIME)cppamd32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd32$(PRG)) cpposx32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpposx32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf $(RUNTIME)cppamd32run.lib) && chmod +x cpposx32 && $(CURR)cpposx32" stdcpprun.tst cpposx32.tmp stdcpposx32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd32$(PRG)) cpposx32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpposx32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf $(RUNTIME)cppamd32run.lib) && chmod +x cpposx32 && $(CURR)cpposx32" extcpprun.tst cpposx32.tmp extcpposx32.res
	@$(TC) $@

$(TESTS)falosx32: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd32$(PRG)) falosx32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falosx32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf) && chmod +x falosx32 && $(CURR)falosx32" falrun.tst falosx32.tmp falosx32.res
	@$(TC) $@

$(TESTS)obosx32: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd32$(PRG)) obosx32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obosx32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf) && chmod +x obosx32 && $(CURR)obosx32" stdobrun.tst obosx32.tmp stdobosx32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd32$(PRG)) obosx32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obosx32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)osx32run.obf) && chmod +x obosx32 && $(CURR)obosx32" extobrun.tst obosx32.tmp extobosx32.res
	@$(TC) $@

.PHONY: osx64tests
osx64tests: $(addprefix $(TESTS), cdosx64 cpposx64 falosx64 obosx64)

$(TESTS)cdosx64: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd64$(PRG)) cdosx64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdosx64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf) && chmod +x cdosx64 && $(CURR)cdosx64" cdrun.tst cdosx64.tmp cdosx64.res
	@$(TC) $@

$(TESTS)cpposx64: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf $(RUNTIME)cppamd64run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd64$(PRG)) cpposx64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpposx64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf $(RUNTIME)cppamd64run.lib) && chmod +x cpposx64 && $(CURR)cpposx64" stdcpprun.tst cpposx64.tmp stdcpposx64.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd64$(PRG)) cpposx64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cpposx64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf $(RUNTIME)cppamd64run.lib) && chmod +x cpposx64 && $(CURR)cpposx64" extcpprun.tst cpposx64.tmp extcpposx64.res
	@$(TC) $@

$(TESTS)falosx64: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd64$(PRG)) falosx64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falosx64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf) && chmod +x falosx64 && $(CURR)falosx64" falrun.tst falosx64.tmp falosx64.res
	@$(TC) $@

$(TESTS)obosx64: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd64$(PRG)) obosx64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obosx64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf) && chmod +x obosx64 && $(CURR)obosx64" stdobrun.tst obosx64.tmp stdobosx64.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd64$(PRG)) obosx64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obosx64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)osx64run.obf) && chmod +x obosx64 && $(CURR)obosx64" extobrun.tst obosx64.tmp extobosx64.res
	@$(TC) $@

.PHONY: qemutests
qemutests: qemuamd32tests qemuamd64tests qemuarma32tests qemuarma64tests qemuarmt32tests qemuarmt32fpetests qemumips32tests

.PHONY: qemuamd32tests
qemuamd32tests: $(addprefix $(TESTS), cdqemuamd32 cppqemuamd32 falqemuamd32 obqemuamd32)

$(TESTS)cdqemuamd32: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd32$(PRG)) cdqemuamd32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdqemuamd32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf) && chmod +x cdqemuamd32 && qemu-i386 cdqemuamd32" cdrun.tst cdqemuamd32.tmp cdqemuamd32.res
	@$(TC) $@

$(TESTS)cppqemuamd32: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf $(RUNTIME)cppamd32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd32$(PRG)) cppqemuamd32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuamd32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf $(RUNTIME)cppamd32run.lib) && chmod +x cppqemuamd32 && qemu-i386 cppqemuamd32" stdcpprun.tst cppqemuamd32.tmp stdcppqemuamd32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd32$(PRG)) cppqemuamd32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuamd32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf $(RUNTIME)cppamd32run.lib) && chmod +x cppqemuamd32 && qemu-i386 cppqemuamd32" extcpprun.tst cppqemuamd32.tmp extcppqemuamd32.res
	@$(TC) $@

$(TESTS)falqemuamd32: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd32$(PRG)) falqemuamd32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falqemuamd32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf) && chmod +x falqemuamd32 && qemu-i386 falqemuamd32" falrun.tst falqemuamd32.tmp falqemuamd32.res
	@$(TC) $@

$(TESTS)obqemuamd32: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd32$(PRG)) obqemuamd32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuamd32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf) && chmod +x obqemuamd32 && qemu-i386 obqemuamd32" stdobrun.tst obqemuamd32.tmp stdobqemuamd32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd32$(PRG)) obqemuamd32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuamd32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)amd32linuxrun.obf) && chmod +x obqemuamd32 && qemu-i386 obqemuamd32" extobrun.tst obqemuamd32.tmp extobqemuamd32.res
	@$(TC) $@

.PHONY: qemuamd64tests
qemuamd64tests: $(addprefix $(TESTS), cdqemuamd64 cppqemuamd64 falqemuamd64 obqemuamd64)

$(TESTS)cdqemuamd64: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd64$(PRG)) cdqemuamd64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdqemuamd64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf) && chmod +x cdqemuamd64 && qemu-x86_64 cdqemuamd64" cdrun.tst cdqemuamd64.tmp cdqemuamd64.res
	@$(TC) $@

$(TESTS)cppqemuamd64: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf $(RUNTIME)cppamd64run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd64$(PRG)) cppqemuamd64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuamd64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf $(RUNTIME)cppamd64run.lib) && chmod +x cppqemuamd64 && qemu-x86_64 cppqemuamd64" stdcpprun.tst cppqemuamd64.tmp stdcppqemuamd64.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd64$(PRG)) cppqemuamd64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuamd64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf $(RUNTIME)cppamd64run.lib) && chmod +x cppqemuamd64 && qemu-x86_64 cppqemuamd64" extcpprun.tst cppqemuamd64.tmp extcppqemuamd64.res
	@$(TC) $@

$(TESTS)falqemuamd64: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd64$(PRG)) falqemuamd64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falqemuamd64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf) && chmod +x falqemuamd64 && qemu-x86_64 falqemuamd64" falrun.tst falqemuamd64.tmp falqemuamd64.res
	@$(TC) $@

$(TESTS)obqemuamd64: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd64$(PRG)) obqemuamd64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuamd64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf) && chmod +x obqemuamd64 && qemu-x86_64 obqemuamd64" stdobrun.tst obqemuamd64.tmp stdobqemuamd64.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd64$(PRG)) obqemuamd64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuamd64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)amd64linuxrun.obf) && chmod +x obqemuamd64 && qemu-x86_64 obqemuamd64" extobrun.tst obqemuamd64.tmp extobqemuamd64.res
	@$(TC) $@

.PHONY: qemuarma32tests
qemuarma32tests: $(addprefix $(TESTS), cdqemuarma32 cppqemuarma32 falqemuarma32 obqemuarma32)

$(TESTS)cdqemuarma32: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdarma32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdarma32$(PRG)) cdqemuarma32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdqemuarma32.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf) && chmod +x cdqemuarma32 && qemu-arm cdqemuarma32" cdrun.tst cdqemuarma32.tmp cdqemuarma32.res
	@$(TC) $@

$(TESTS)cppqemuarma32: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpparma32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf $(RUNTIME)cpparma32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparma32$(PRG)) cppqemuarma32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuarma32.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf $(RUNTIME)cpparma32run.lib) && chmod +x cppqemuarma32 && qemu-arm cppqemuarma32" stdcpprun.tst cppqemuarma32.tmp stdcppqemuarma32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparma32$(PRG)) cppqemuarma32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuarma32.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf $(RUNTIME)cpparma32run.lib) && chmod +x cppqemuarma32 && qemu-arm cppqemuarma32" extcpprun.tst cppqemuarma32.tmp extcppqemuarma32.res
	@$(TC) $@

$(TESTS)falqemuarma32: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falarma32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falarma32$(PRG)) falqemuarma32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falqemuarma32.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf) && chmod +x falqemuarma32 && qemu-arm falqemuarma32" falrun.tst falqemuarma32.tmp falqemuarma32.res
	@$(TC) $@

$(TESTS)obqemuarma32: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TOOLS)obarma32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarma32$(PRG)) obqemuarma32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuarma32.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf) && chmod +x obqemuarma32 && qemu-arm obqemuarma32" stdobrun.tst obqemuarma32.tmp stdobqemuarma32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarma32$(PRG)) obqemuarma32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuarma32.obf $(abspath $(RUNTIME)arma32run.obf $(RUNTIME)arma32linuxrun.obf) && chmod +x obqemuarma32 && qemu-arm obqemuarma32" extobrun.tst obqemuarma32.tmp extobqemuarma32.res
	@$(TC) $@

.PHONY: qemuarma64tests
qemuarma64tests: $(addprefix $(TESTS), cdqemuarma64 cppqemuarma64 falqemuarma64 obqemuarma64)

$(TESTS)cdqemuarma64: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdarma64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdarma64$(PRG)) cdqemuarma64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdqemuarma64.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf) && chmod +x cdqemuarma64 && qemu-aarch64 cdqemuarma64" cdrun.tst cdqemuarma64.tmp cdqemuarma64.res
	@$(TC) $@

$(TESTS)cppqemuarma64: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpparma64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf $(RUNTIME)cpparma64run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparma64$(PRG)) cppqemuarma64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuarma64.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf $(RUNTIME)cpparma64run.lib) && chmod +x cppqemuarma64 && qemu-aarch64 cppqemuarma64" stdcpprun.tst cppqemuarma64.tmp stdcppqemuarma64.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparma64$(PRG)) cppqemuarma64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuarma64.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf $(RUNTIME)cpparma64run.lib) && chmod +x cppqemuarma64 && qemu-aarch64 cppqemuarma64" extcpprun.tst cppqemuarma64.tmp extcppqemuarma64.res
	@$(TC) $@

$(TESTS)falqemuarma64: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falarma64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falarma64$(PRG)) falqemuarma64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falqemuarma64.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf) && chmod +x falqemuarma64 && qemu-aarch64 falqemuarma64" falrun.tst falqemuarma64.tmp falqemuarma64.res
	@$(TC) $@

$(TESTS)obqemuarma64: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obarma64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarma64$(PRG)) obqemuarma64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuarma64.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf) && chmod +x obqemuarma64 && qemu-aarch64 obqemuarma64" stdobrun.tst obqemuarma64.tmp stdobqemuarma64.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarma64$(PRG)) obqemuarma64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuarma64.obf $(abspath $(RUNTIME)arma64run.obf $(RUNTIME)arma64linuxrun.obf) && chmod +x obqemuarma64 && qemu-aarch64 obqemuarma64" extobrun.tst obqemuarma64.tmp extobqemuarma64.res
	@$(TC) $@

.PHONY: qemuarmt32tests
qemuarmt32tests: $(addprefix $(TESTS), cdqemuarmt32 cppqemuarmt32 falqemuarmt32 obqemuarmt32)

$(TESTS)cdqemuarmt32: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdarmt32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdarmt32$(PRG)) cdqemuarmt32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdqemuarmt32.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf) && chmod +x cdqemuarmt32 && qemu-arm cdqemuarmt32" cdrun.tst cdqemuarmt32.tmp cdqemuarmt32.res
	@$(TC) $@

$(TESTS)cppqemuarmt32: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpparmt32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf $(RUNTIME)cpparmt32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparmt32$(PRG)) cppqemuarmt32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuarmt32.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf $(RUNTIME)cpparmt32run.lib) && chmod +x cppqemuarmt32 && qemu-arm cppqemuarmt32" stdcpprun.tst cppqemuarmt32.tmp stdcppqemuarmt32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparmt32$(PRG)) cppqemuarmt32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuarmt32.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf $(RUNTIME)cpparmt32run.lib) && chmod +x cppqemuarmt32 && qemu-arm cppqemuarmt32" extcpprun.tst cppqemuarmt32.tmp extcppqemuarmt32.res
	@$(TC) $@

$(TESTS)falqemuarmt32: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falarmt32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falarmt32$(PRG)) falqemuarmt32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falqemuarmt32.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf) && chmod +x falqemuarmt32 && qemu-arm falqemuarmt32" falrun.tst falqemuarmt32.tmp falqemuarmt32.res
	@$(TC) $@

$(TESTS)obqemuarmt32: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TOOLS)obarmt32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarmt32$(PRG)) obqemuarmt32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuarmt32.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf) && chmod +x obqemuarmt32 && qemu-arm obqemuarmt32" stdobrun.tst obqemuarmt32.tmp stdobqemuarmt32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarmt32$(PRG)) obqemuarmt32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuarmt32.obf $(abspath $(RUNTIME)armt32run.obf $(RUNTIME)armt32linuxrun.obf) && chmod +x obqemuarmt32 && qemu-arm obqemuarmt32" extobrun.tst obqemuarmt32.tmp extobqemuarmt32.res
	@$(TC) $@

.PHONY: qemuarmt32fpetests
qemuarmt32fpetests: $(addprefix $(TESTS), cdqemuarmt32fpe cppqemuarmt32fpe falqemuarmt32fpe obqemuarmt32fpe)

$(TESTS)cdqemuarmt32fpe: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdarmt32fpe$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdarmt32fpe$(PRG)) cdqemuarmt32fpe.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdqemuarmt32fpe.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf) && chmod +x cdqemuarmt32fpe && qemu-arm cdqemuarmt32fpe" cdrun.tst cdqemuarmt32fpe.tmp cdqemuarmt32fpe.res
	@$(TC) $@

$(TESTS)cppqemuarmt32fpe: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cpparmt32fpe$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf $(RUNTIME)cpparmt32fperun.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparmt32fpe$(PRG)) cppqemuarmt32fpe.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuarmt32fpe.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf $(RUNTIME)cpparmt32fperun.lib) && chmod +x cppqemuarmt32fpe && qemu-arm cppqemuarmt32fpe" stdcpprun.tst cppqemuarmt32fpe.tmp stdcppqemuarmt32fpe.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cpparmt32fpe$(PRG)) cppqemuarmt32fpe.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuarmt32fpe.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf $(RUNTIME)cpparmt32fperun.lib) && chmod +x cppqemuarmt32fpe && qemu-arm cppqemuarmt32fpe" extcpprun.tst cppqemuarmt32fpe.tmp extcppqemuarmt32fpe.res
	@$(TC) $@

$(TESTS)falqemuarmt32fpe: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falarmt32fpe$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falarmt32fpe$(PRG)) falqemuarmt32fpe.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falqemuarmt32fpe.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf) && chmod +x falqemuarmt32fpe && qemu-arm falqemuarmt32fpe" falrun.tst falqemuarmt32fpe.tmp falqemuarmt32fpe.res
	@$(TC) $@

$(TESTS)obqemuarmt32fpe: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TOOLS)obarmt32fpe$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarmt32fpe$(PRG)) obqemuarmt32fpe.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuarmt32fpe.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf) && chmod +x obqemuarmt32fpe && qemu-arm obqemuarmt32fpe" stdobrun.tst obqemuarmt32fpe.tmp stdobqemuarmt32fpe.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obarmt32fpe$(PRG)) obqemuarmt32fpe.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuarmt32fpe.obf $(abspath $(RUNTIME)armt32fperun.obf $(RUNTIME)armt32fpelinuxrun.obf) && chmod +x obqemuarmt32fpe && qemu-arm obqemuarmt32fpe" extobrun.tst obqemuarmt32fpe.tmp extobqemuarmt32fpe.res
	@$(TC) $@

.PHONY: qemumips32tests
qemumips32tests: $(addprefix $(TESTS), cdqemumips32 cppqemumips32 falqemumips32 obqemumips32)

$(TESTS)cdqemumips32: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdmips32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdmips32$(PRG)) cdqemumips32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdqemumips32.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf) && chmod +x cdqemumips32 && qemu-mipsel cdqemumips32" cdrun.tst cdqemumips32.tmp cdqemumips32.res
	@$(TC) $@

$(TESTS)cppqemumips32: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppmips32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf $(RUNTIME)cppmips32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppmips32$(PRG)) cppqemumips32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemumips32.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf $(RUNTIME)cppmips32run.lib) && chmod +x cppqemumips32 && qemu-mipsel cppqemumips32" stdcpprun.tst cppqemumips32.tmp stdcppqemumips32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppmips32$(PRG)) cppqemumips32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemumips32.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf $(RUNTIME)cppmips32run.lib) && chmod +x cppqemumips32 && qemu-mipsel cppqemumips32" extcpprun.tst cppqemumips32.tmp extcppqemumips32.res
	@$(TC) $@

$(TESTS)falqemumips32: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falmips32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falmips32$(PRG)) falqemumips32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falqemumips32.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf) && chmod +x falqemumips32 && qemu-mipsel falqemumips32" falrun.tst falqemumips32.tmp falqemumips32.res
	@$(TC) $@

$(TESTS)obqemumips32: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obmips32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obmips32$(PRG)) obqemumips32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemumips32.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf) && chmod +x obqemumips32 && qemu-mipsel obqemumips32" stdobrun.tst obqemumips32.tmp stdobqemumips32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obmips32$(PRG)) obqemumips32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemumips32.obf $(abspath $(RUNTIME)mips32run.obf $(RUNTIME)mips32linuxrun.obf) && chmod +x obqemumips32 && qemu-mipsel obqemumips32" extobrun.tst obqemumips32.tmp extobqemumips32.res
	@$(TC) $@

.PHONY: qemuxtensatests
qemuxtensatests: $(addprefix $(TESTS), cdqemuxtensa cppqemuxtensa falqemuxtensa obqemuxtensa)

$(TESTS)cdqemuxtensa: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdxtensa$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdxtensa$(PRG)) cdqemuxtensa.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdqemuxtensa.obf $(abspath $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf) && chmod +x cdqemuxtensa && qemu-xtensa -cpu de233_fpu cdqemuxtensa" cdrun.tst cdqemuxtensa.tmp cdqemuxtensa.res
	@$(TC) $@

$(TESTS)cppqemuxtensa: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppxtensa$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf $(RUNTIME)cppxtensarun.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppxtensa$(PRG)) cppqemuxtensa.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuxtensa.obf $(abspath $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf $(RUNTIME)cppxtensarun.lib) && chmod +x cppqemuxtensa && qemu-xtensa -cpu de233_fpu cppqemuxtensa" stdcpprun.tst cppqemuxtensa.tmp stdcppqemuxtensa.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppxtensa$(PRG)) cppqemuxtensa.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppqemuxtensa.obf $(abspath $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf $(RUNTIME)cppxtensarun.lib) && chmod +x cppqemuxtensa && qemu-xtensa -cpu de233_fpu cppqemuxtensa" extcpprun.tst cppqemuxtensa.tmp extcppqemuxtensa.res
	@$(TC) $@

$(TESTS)falqemuxtensa: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falxtensa$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falxtensa$(PRG)) falqemuxtensa.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falqemuxtensa.obf $(abspath $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf) && chmod +x falqemuxtensa && qemu-xtensa falqemuxtensa" falrun.tst falqemuxtensa.tmp falqemuxtensa.res
	@$(TC) $@

$(TESTS)obqemuxtensa: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obxtensa$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obxtensa$(PRG)) obqemuxtensa.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuxtensa.obf $(abspath $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf) && chmod +x obqemuxtensa && qemu-xtensa -cpu de233_fpu obqemuxtensa" stdobrun.tst obqemuxtensa.tmp stdobqemuxtensa.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obxtensa$(PRG)) obqemuxtensa.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obqemuxtensa.obf $(abspath $(RUNTIME)xtensarun.obf $(RUNTIME)xtensalinuxrun.obf) && chmod +x obqemuxtensa && qemu-xtensa -cpu de233_fpu obqemuxtensa" extobrun.tst obqemuxtensa.tmp extobqemuxtensa.res
	@$(TC) $@

.PHONY: webassemblytests
webassemblytests: $(addprefix $(TESTS), cdwebassembly cppwebassembly falwebassembly obwebassembly)

$(TESTS)cdwebassembly: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdwasm$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdwasm$(PRG)) cdwebassembly.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdwebassembly.obf $(abspath $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf) && wasm-interp cdwebassembly.wasm" cdrun.tst cdwebassembly.tmp cdwebassembly.res
	@$(TC) $@

$(TESTS)cppwebassembly: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppwasm$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf $(RUNTIME)cppwasmrun.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppwasm$(PRG)) cppwebassembly.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppwebassembly.obf $(abspath $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf $(RUNTIME)cppwasmrun.lib) && wasm-interp cppwebassembly.wasm" stdcpprun.tst cppwebassembly.tmp stdcppwebassembly.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppwasm$(PRG)) cppwebassembly.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppwebassembly.obf $(abspath $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf $(RUNTIME)cppwasmrun.lib) && wasm-interp cppwebassembly.wasm" extcpprun.tst cppwebassembly.tmp extcppwebassembly.res
	@$(TC) $@

$(TESTS)falwebassembly: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falwasm$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falwasm$(PRG)) falwebassembly.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falwebassembly.obf $(abspath $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf) && wasm-interp falwebassembly.wasm" falrun.tst falwebassembly.tmp falwebassembly.res
	@$(TC) $@

$(TESTS)obwebassembly: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obwasm$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obwasm$(PRG)) obwebassembly.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obwebassembly.obf $(abspath $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf) && wasm-interp obwebassembly.wasm" stdobrun.tst obwebassembly.tmp stdobwebassembly.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obwasm$(PRG)) obwebassembly.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obwebassembly.obf $(abspath $(RUNTIME)wasmrun.obf $(RUNTIME)webassemblyrun.obf) && wasm-interp obwebassembly.wasm" extobrun.tst obwebassembly.tmp extobwebassembly.res
	@$(TC) $@

.PHONY: win32tests
win32tests: $(addprefix $(TESTS), cdwin32 cppwin32 falwin32 obwin32)

$(TESTS)cdwin32: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd32$(PRG)) cdwin32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdwin32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf) && cdwin32.exe" cdrun.tst cdwin32.tmp cdwin32.res
	@$(TC) $@

$(TESTS)cppwin32: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf $(RUNTIME)cppamd32run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd32$(PRG)) cppwin32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppwin32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf $(RUNTIME)cppamd32run.lib) && cppwin32.exe" stdcpprun.tst cppwin32.tmp stdcppwin32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd32$(PRG)) cppwin32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppwin32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf $(RUNTIME)cppamd32run.lib) && cppwin32.exe" extcpprun.tst cppwin32.tmp extcppwin32.res
	@$(TC) $@

$(TESTS)falwin32: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd32$(PRG)) falwin32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falwin32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf) && falwin32.exe" falrun.tst falwin32.tmp falwin32.res
	@$(TC) $@

$(TESTS)obwin32: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd32$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd32$(PRG)) obwin32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obwin32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf) && obwin32.exe" stdobrun.tst obwin32.tmp stdobwin32.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd32$(PRG)) obwin32.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obwin32.obf $(abspath $(RUNTIME)amd32run.obf $(RUNTIME)win32run.obf) && obwin32.exe" extobrun.tst obwin32.tmp extobwin32.res
	@$(TC) $@

.PHONY: win64tests
win64tests: $(addprefix $(TESTS), cdwin64 cppwin64 falwin64 obwin64)

$(TESTS)cdwin64: $(UTILITIES)regtest$(PRG) $(TESTS)cdrun.tst $(TOOLS)cdamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cdamd64$(PRG)) cdwin64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cdwin64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf) && cdwin64.exe" cdrun.tst cdwin64.tmp cdwin64.res
	@$(TC) $@

$(TESTS)cppwin64: $(UTILITIES)regtest$(PRG) $(TESTS)stdcpprun.tst $(TESTS)extcpprun.tst $(TOOLS)cppamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf $(RUNTIME)cppamd64run.lib
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd64$(PRG)) cppwin64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppwin64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf $(RUNTIME)cppamd64run.lib) && cppwin64.exe" stdcpprun.tst cppwin64.tmp stdcppwin64.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)cppamd64$(PRG)) cppwin64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) cppwin64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf $(RUNTIME)cppamd64run.lib) && cppwin64.exe" extcpprun.tst cppwin64.tmp extcppwin64.res
	@$(TC) $@

$(TESTS)falwin64: $(UTILITIES)regtest$(PRG) $(TESTS)falrun.tst $(TOOLS)falamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)falamd64$(PRG)) falwin64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) falwin64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf) && falwin64.exe" falrun.tst falwin64.tmp falwin64.res
	@$(TC) $@

$(TESTS)obwin64: $(UTILITIES)regtest$(PRG) $(TESTS)stdobrun.tst $(TESTS)extobrun.tst $(TESTS)generic.sym $(TOOLS)obamd64$(PRG) $(TOOLS)linkbin$(PRG) $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd64$(PRG)) obwin64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obwin64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf) && obwin64.exe" stdobrun.tst obwin64.tmp stdobwin64.res
	@cd $(TESTS) && $(PREV)$(UTILITIES)regtest$(PRG) "$(abspath $(TOOLS)obamd64$(PRG)) obwin64.tmp && $(abspath $(TOOLS)linkbin$(PRG)) obwin64.obf $(abspath $(RUNTIME)amd64run.obf $(RUNTIME)win64run.obf) && obwin64.exe" extobrun.tst obwin64.tmp extobwin64.res
	@$(TC) $@

tests: linktests doctests cdtests cpptests faltests obtests asmtests

# checks & maintenance

checks: linecheck headercheck

.PHONY: linecheck
linecheck: $(UTILITIES)linecheck$(PRG)
	@$(UTILITIES)linecheck$(PRG) $(call DIR, makefile readme $(wildcard licenses/*.txt))
	@$(UTILITIES)linecheck$(PRG) $(call DIR, $(wildcard tools/*.cpp tools/*.hpp tools/*.def))
	@$(UTILITIES)linecheck$(PRG) $(call DIR, $(wildcard utilities/*.cpp utilities/*.hpp))
	@$(UTILITIES)linecheck$(PRG) $(call DIR, $(wildcard runtime/*.asm runtime/*.cpp runtime/*.hpp))
	@$(UTILITIES)linecheck$(PRG) $(call DIR, $(wildcard libraries/api/*.h libraries/cpp/*.cpp libraries/cpp/*.h libraries/oberon/*.mod) $(filter-out $(wildcard libraries/cpp/*.*), $(wildcard libraries/cpp/*)))
	@$(UTILITIES)linecheck$(PRG) $(call DIR, $(wildcard documentation/*.tex documentation/*.tab) documentation/references.bib documentation/ecsd.1)
	@$(UTILITIES)linecheck$(PRG) $(call DIR, $(wildcard tests/*.tst tests/*.dtd tests/*.sym))

.PHONY: headercheck
headercheck: $(TOOLS)cppcheck$(PRG)
	@$(CC) $(CCHECKFLAGS) $(call DIR, $(wildcard tools/*.hpp) $(wildcard utilities/*.hpp) runtime/obcpprun.hpp)
	@$(TOOLS)cppcheck$(PRG) $(HDR) $(API)

clean:
	-@$(RM) $(DRV)
	-@$(RM) $(OBJ)
	-@$(RM) $(BIN)
	-@$(RM) $(OBF)
	-@$(RM) $(LIB)
	-@$(RM) $(SYM)
	-@$(RM) $(DOC)
	-@$(RM) $(SET)
	-@$(RM) $(PDF)
	-@$(RM) $(TST)
	-@$(RM) $(RES)

depwalk: $(UTILITIES)depwalk$(PRG) $(DRV)
	@cd $(TOOLS) && $(PREV)$(UTILITIES)depwalk$(PRG) TOOLS $(notdir $(filter $(TOOLSP)%, $(SRC)) $(DRV))
	@cd $(UTILITIES) && $(PREV)$(UTILITIES)depwalk$(PRG) UTILITIES $(filter-out $(ENVIRONMENT), $(notdir $(filter $(UTILITIESP)%, $(SRC)))) freebsd.cpp linux.cpp osx.cpp posix.cpp windows.cpp

# installation

.PHONY: $(foreach LANGUAGE, $(LANGUAGES), $(LANGUAGE)tools)
$(foreach LANGUAGE, $(LANGUAGES), $(eval $(LANGUAGE)tools: $(UTILITIES)ecsd$(PRG) $(addprefix $(TOOLS), $(addsuffix $(PRG), $(filter $(LANGUAGE)%, $(PREPROCESSORS) $(PRINTERS) $(CHECKERS) $(SERIALIZERS) $(INTERPRETERS) $(TRANSPILERS) $(GENERATORS))))))

.PHONY: targets hosttarget codetarget $(foreach ENVIRONMENT, $(ENVIRONMENTS), $(ENVIRONMENT)target)
targets: $(foreach ENVIRONMENT, $(ENVIRONMENTS), $(ENVIRONMENT)target)
hosttarget: $(foreach ENVIRONMENT, $(HOSTENVIRONMENTS), $(ENVIRONMENT)target)
codetarget: $(UTILITIES)ecsd$(PRG) $(addprefix $(TOOLS), $(addsuffix $(PRG), cppcode obcode cdrun)) $(addprefix $(RUNTIME), coderun.obf cppcoderun.lib obcoderun.lib)
$(foreach ENVIRONMENT, $(ENVIRONMENTS), $(eval $(ENVIRONMENT)target: $(UTILITIES)ecsd$(PRG) $(foreach TARGET, $(word $(call FINDMATCH, $(ENVIRONMENTS), $(ENVIRONMENT)), $(ENVIRONMENTTARGETS)), $(foreach ARCHITECTURE, $(word $(call FINDMATCH, $(ENVIRONMENTS), $(ENVIRONMENT)), $(ENVIRONMENTARCHITECTURES)), \
	$(addprefix $(TOOLS), $(addsuffix $(PRG), cpp$(TARGET) ob$(TARGET) $(ARCHITECTURE)asm $(ARCHITECTURE)dism linklib linkbin linkmem mapsearch)) \
	$(addprefix $(RUNTIME), $(TARGET)run.obf cpp$(TARGET)run.lib ob$(TARGET)run.lib $(ENVIRONMENT)run.obf)))))
amd32linuxtarget amd64linuxtarget arma32linuxtarget arma64linuxtarget armt32linuxtarget armt32fpelinuxtarget mips32linuxtarget xtensalinuxtarget: %linuxtarget: $(TOOLS)dbgdwarf$(PRG) $(addprefix $(RUNTIME), %libdl.obf %libpthread.obf %libsdl.obf)
atmega32target atmega328target atmega8515target: $(TOOLS)linkhex$(PRG)
tostarget: $(TOOLS)linkprg$(PRG) $(addprefix $(RUNTIME), tosapi.obf)
win32target win64target: win%target: $(addprefix $(RUNTIME), win%api.obf win%sdl.obf)

prefix := /usr/local
ecsdir := $(prefix)/lib/ecs
bindir := $(prefix)/bin
mandir := $(prefix)/share/man
man1dir := $(mandir)/man1

install: uninstall
	@mkdir -p $(DESTDIR)$(ecsdir)
	@mkdir -p $(DESTDIR)$(ecsdir)/$(TOOLS)
	@cp $(filter $(TOOLSP)%, $(wildcard $(BIN))) $(DESTDIR)$(ecsdir)/$(TOOLS)
	@mkdir -p $(DESTDIR)$(ecsdir)/$(RUNTIME)
	@cp $(wildcard $(OBF) $(LIB)) $(DESTDIR)$(ecsdir)/$(RUNTIME)
	@mkdir -p $(DESTDIR)$(ecsdir)/$(CPPLIBRARY)
	@cp $(HDR) $(DESTDIR)$(ecsdir)/$(CPPLIBRARY)
	@mkdir -p $(DESTDIR)$(ecsdir)/$(OBLIBRARY)
	@cp $(wildcard $(OBLIBRARY)*.sym) $(DESTDIR)$(ecsdir)/$(OBLIBRARY)
	@mkdir -p $(DESTDIR)$(ecsdir)/$(UTILITIES)
	@cp $(UTILITIES)ecsd $(DESTDIR)$(ecsdir)/$(UTILITIES)
	@mkdir -p $(DESTDIR)$(bindir)
	@ln -s $(patsubst $(DESTDIR)$(prefix)/%,../%,$(DESTDIR)$(ecsdir))/$(UTILITIES)ecsd $(DESTDIR)$(bindir)/ecsd
	@mkdir -p $(DESTDIR)$(man1dir)
	@cp $(DOCUMENTATION)ecsd.1 $(DESTDIR)$(man1dir)/ecsd.1

uninstall:
	@rm -f -r $(DESTDIR)$(ecsdir)
	@rm -f $(DESTDIR)$(bindir)/ecsd
	@rm -f $(DESTDIR)$(man1dir)/ecsd.1

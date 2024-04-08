// MMIX instruction set representation
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

#ifndef ECS_MMIX_HEADER_INCLUDED
#define ECS_MMIX_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>

namespace ECS
{
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Byte = std::uint8_t;
}

namespace ECS::MMIX
{
	enum Register
	{
		R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R16,
		R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31, R32,
		R33, R34, R35, R36, R37, R38, R39, R40, R41, R42, R43, R44, R45, R46, R47, R48,
		R49, R50, R51, R52, R53, R54, R55, R56, R57, R58, R59, R60, R61, R62, R63, R64,
		R65, R66, R67, R68, R69, R70, R71, R72, R73, R74, R75, R76, R77, R78, R79, R80,
		R81, R82, R83, R84, R85, R86, R87, R88, R89, R90, R91, R92, R93, R94, R95, R96,
		R97, R98, R99, R100, R101, R102, R103, R104, R105, R106, R107, R108, R109, R110, R111,
		R112, R113, R114, R115, R116, R117, R118, R119, R120, R121, R122, R123, R124, R125, R126, R127,
		R128, R129, R130, R131, R132, R133, R134, R135, R136, R137, R138, R139, R140, R141, R142, R143,
		R144, R145, R146, R147, R148, R149, R150, R151, R152, R153, R154, R155, R156, R157, R158, R159,
		R160, R161, R162, R163, R164, R165, R166, R167, R168, R169, R170, R171, R172, R173, R174, R175,
		R176, R177, R178, R179, R180, R181, R182, R183, R184, R185, R186, R187, R188, R189, R190, R191,
		R192, R193, R194, R195, R196, R197, R198, R199, R200, R201, R202, R203, R204, R205, R206, R207,
		R208, R209, R210, R211, R212, R213, R214, R215, R216, R217, R218, R219, R220, R221, R222, R223,
		R224, R225, R226, R227, R228, R229, R230, R231, R232, R233, R234, R235, R236, R237, R238, R239,
		R240, R241, R242, R243, R244, R245, R246, R247, R248, R249, R250, R251, R252, R253, R254, R255,
	};

	enum SpecialRegister {
		#define SREG(reg, name, number) reg = number,
		#include "mmix.def"
	};

	class Instruction;
	class Operand;

	using Immediate = std::int32_t;

	bool IsEmpty (const Operand&);
	bool IsValid (const Instruction&);

	std::istream& operator >> (std::istream&, Instruction&);
	std::istream& operator >> (std::istream&, Operand&);
	std::istream& operator >> (std::istream&, Register&);
	std::ostream& operator << (std::ostream&, const Instruction&);
	std::ostream& operator << (std::ostream&, const Operand&);
	std::ostream& operator << (std::ostream&, Register);
}

namespace ECS::Object
{
	struct Patch;
}

class ECS::MMIX::Operand
{
public:
	Operand () = default;
	Operand (MMIX::Register);
	Operand (MMIX::Immediate);

private:
	enum Model {Empty, Immediate, Register};

	Model model = Empty;

	union
	{
		MMIX::Immediate immediate;
		MMIX::Register register_;
	};

	friend class Instruction;
	friend bool IsEmpty (const Operand&);
	friend std::ostream& operator << (std::ostream&, const Operand&);
};

class ECS::MMIX::Instruction
{
public:
	enum Mnemonic {
		#define MNEM(name, mnem, ...) mnem,
		#include "mmix.def"
		Count,
	};

	Instruction () = default;
	explicit Instruction (Span<const Byte>);
	Instruction (Mnemonic, const Operand& = {}, const Operand& = {}, const Operand& = {});

	void Emit (Span<Byte>) const;
	void Adjust (Object::Patch&) const;

private:
	enum Format {Void,
		#define FORMAT(format) format,
		#include "mmix.def"
	};

	struct Entry;

	const Entry* entry = nullptr;
	Operand operand1, operand2, operand3;

	static const Entry table[];
	static const char*const mnemonics[];
	static const Lookup<Entry, Mnemonic> lookup;

	static bool IsR (const Operand&);
	static bool IsI1 (const Operand&);
	static bool IsI2 (const Operand&);
	static bool IsD2 (const Operand&);
	static bool IsD3 (const Operand&);

	friend bool IsValid (const Instruction&);
	friend std::istream& operator >> (std::istream&, Mnemonic&);
	friend std::ostream& operator << (std::ostream&, Mnemonic);
	friend std::ostream& operator << (std::ostream&, const Instruction&);
};

namespace ECS::MMIX
{
	template <Instruction::Mnemonic> struct InstructionMnemonic;

	#define MNEM(name, mnem, ...) using mnem = InstructionMnemonic<Instruction::mnem>;
	#include "mmix.def"

	std::istream& operator >> (std::istream&, Instruction::Mnemonic&);
	std::ostream& operator << (std::ostream&, Instruction::Mnemonic);
}

template <ECS::MMIX::Instruction::Mnemonic>
struct ECS::MMIX::InstructionMnemonic : Instruction
{
	explicit InstructionMnemonic (const Operand& = {}, const Operand& = {}, const Operand& = {});
};

inline bool ECS::MMIX::IsEmpty (const Operand& operand)
{
	return operand.model == Operand::Empty;
}

inline bool ECS::MMIX::IsValid (const Instruction& instruction)
{
	return instruction.entry;
}

template <ECS::MMIX::Instruction::Mnemonic m>
inline ECS::MMIX::InstructionMnemonic<m>::InstructionMnemonic (const Operand& op1, const Operand& op2, const Operand& op3) :
	Instruction {m, op1, op2, op3}
{
}

#endif // ECS_MMIX_HEADER_INCLUDED

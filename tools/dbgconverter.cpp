// Generic debugging information converter
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

#include "charset.hpp"
#include "dbgconverter.hpp"
#include "debugging.hpp"
#include "diagnostics.hpp"
#include "error.hpp"
#include "object.hpp"
#include "position.hpp"
#include "utilities.hpp"

#include <cassert>

using namespace ECS;
using namespace Debugging;

using Context =
	#include "dbgconvertercontext.hpp"

Converter::Converter (Diagnostics& d, Charset& c) :
	diagnostics {d}, charset {c}
{
}

void Converter::Convert (const Information& information, const Source& source, Object::Binaries& binaries)
{
	Process (information, source, binaries);
}

Context::Context (const Converter& c, const Information& i, const Source& s, Object::Binaries& b) :
	information {i}, converter {c}, source {s}, binaries {b}
{
}

void Context::EmitError (const Message& message) const
{
	converter.diagnostics.Emit (Diagnostics::Error, source, {}, message); throw Error {};
}

void Context::Begin (const Binary::Name& name, const Binary::Required required, const Binary::Replaceable replaceable)
{
	current = &binaries.emplace_back (Binary::Const, name, 1, required, true, replaceable);
}

void Context::Alias (const Binary::Name& name)
{
	assert (current); current->aliases.emplace_back (name, current->bytes.size ());
}

void Context::Group (const Binary::Name& name)
{
	assert (current); assert (current->group.empty ()); current->group = name;
}

void Context::Require (const Binary::Name& name)
{
	assert (current); current->AddRequirement (name);
}

Object::Offset Context::Emit (const Size size)
{
	assert (current); const auto offset = current->bytes.size (); current->bytes.resize (offset + size); return offset;
}

void Context::Fixup (const Object::Offset offset, const Size size)
{
	assert (current); assert (offset + size <= current->bytes.size ()); Object::Pattern {size, information.target.endianness}.Patch (current->bytes.size () - offset - size, {current->bytes.data () + offset, size});
}

void Context::Emit (const Value::Unsigned value, const Size size)
{
	assert (current); const auto offset = Emit (size); Object::Pattern {size, information.target.endianness}.Patch (value, {current->bytes.data () + offset, size});
}

void Context::Emit (const std::string& string, const Size size)
{
	assert (current); const Object::Pattern pattern {size, information.target.endianness};
	for (auto character: string) {const auto offset = Emit (size); pattern.Patch (converter.charset.Encode (character), {current->bytes.data () + offset, size});}
}

void Context::Emit (const Binary::Name& name, const Patch::Mode mode, const Patch::Displacement displacement, const Size size)
{
	assert (current); Patch patch {Emit (size), mode, displacement, 0}; patch.pattern = {size, information.target.endianness}; current->AddLink (name, patch);
}

bool Context::IsDefined (const Binary::Name& name) const
{
	for (auto& binary: binaries) if (binary.name == name) return true; return false;
}

Context::Block::Block (const Entry& entry) :
	lifetime {0, entry.size}
{
	assert (IsCode (entry));
	for (auto& symbol: entry.symbols) Insert (symbol);
}

Context::Block::Block (const Symbol& symbol) :
	lifetime {symbol.lifetime}
{
	symbols.push_back (&symbol);
}

void Context::Block::Insert (const Symbol& symbol)
{
	for (auto& block: blocks) if (block.lifetime.begin <= symbol.lifetime.begin && block.lifetime.end >= symbol.lifetime.end) return block.Insert (symbol);
	if (symbol.lifetime.begin == lifetime.begin && symbol.lifetime.end == lifetime.end) return symbols.push_back (&symbol); auto& block = blocks.emplace_back (symbol);
	if (block.lifetime.begin <= lifetime.begin && block.lifetime.end >= lifetime.end) std::swap (lifetime, block.lifetime), std::swap (symbols, block.symbols), std::swap (blocks, block.blocks);
}

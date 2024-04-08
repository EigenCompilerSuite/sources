// Standard character sets
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

#ifndef ECS_STANDARDCHARSET_HEADER_INCLUDED
#define ECS_STANDARDCHARSET_HEADER_INCLUDED

#include "charset.hpp"

namespace ECS
{
	class ASCIICharset;
	class StandardCharset;
}

class ECS::StandardCharset : public Charset
{
	char Decode (unsigned char character) const override {return character;}
	unsigned char Encode (char character) const override {return character;}
};

class ECS::ASCIICharset : public Charset
{
	template <unsigned char Code> struct Decoded {static constexpr auto Value = Code;};
	template <unsigned char Char> struct Encoded {static constexpr auto Value = Char;};

	char Decode (unsigned char character) const override {return Lookup<Decoded> (character);}
	unsigned char Encode (char character) const override {return Lookup<Encoded> (character);}

	template <template <unsigned char> class> static unsigned char Lookup (unsigned char);
};

namespace ECS
{
	#define MAP(char, code) \
		template <> struct ASCIICharset::Decoded<code> {static constexpr auto Value = char;}; \
		template <> struct ASCIICharset::Encoded<char> {static constexpr auto Value = code;}; \

	MAP ('\a',0x07) MAP ('\b',0x08) MAP ('\t',0x09) MAP ('\n',0x0a) MAP ('\v',0x0b) MAP ('\f',0x0c) MAP ('\r',0x0d)
	MAP (' ', 0x20) MAP ('!', 0x21) MAP ('"', 0x22) MAP ('#', 0x23) MAP ('$', 0x24) MAP ('%', 0x25) MAP ('&', 0x26) MAP ('\'',0x27)
	MAP ('(', 0x28) MAP (')', 0x29) MAP ('*', 0x2a) MAP ('+', 0x2b) MAP (',', 0x2c) MAP ('-', 0x2d) MAP ('.', 0x2e) MAP ('/', 0x2f)
	MAP ('0', 0x30) MAP ('1', 0x31) MAP ('2', 0x32) MAP ('3', 0x33) MAP ('4', 0x34) MAP ('5', 0x35) MAP ('6', 0x36) MAP ('7', 0x37)
	MAP ('8', 0x38) MAP ('9', 0x39) MAP (':', 0x3a) MAP (';', 0x3b) MAP ('<', 0x3c) MAP ('=', 0x3d) MAP ('>', 0x3e) MAP ('?', 0x3f)
	MAP ('@', 0x40) MAP ('A', 0x41) MAP ('B', 0x42) MAP ('C', 0x43) MAP ('D', 0x44) MAP ('E', 0x45) MAP ('F', 0x46) MAP ('G', 0x47)
	MAP ('H', 0x48) MAP ('I', 0x49) MAP ('J', 0x4a) MAP ('K', 0x4b) MAP ('L', 0x4c) MAP ('M', 0x4d) MAP ('N', 0x4e) MAP ('O', 0x4f)
	MAP ('P', 0x50) MAP ('Q', 0x51) MAP ('R', 0x52) MAP ('S', 0x53) MAP ('T', 0x54) MAP ('U', 0x55) MAP ('V', 0x56) MAP ('W', 0x57)
	MAP ('X', 0x58) MAP ('Y', 0x59) MAP ('Z', 0x5a) MAP ('[', 0x5b) MAP ('\\',0x5c) MAP (']', 0x5d) MAP ('^', 0x5e) MAP ('_', 0x5f)
	MAP ('`', 0x60) MAP ('a', 0x61) MAP ('b', 0x62) MAP ('c', 0x63) MAP ('d', 0x64) MAP ('e', 0x65) MAP ('f', 0x66) MAP ('g', 0x67)
	MAP ('h', 0x68) MAP ('i', 0x69) MAP ('j', 0x6a) MAP ('k', 0x6b) MAP ('l', 0x6c) MAP ('m', 0x6d) MAP ('n', 0x6e) MAP ('o', 0x6f)
	MAP ('p', 0x70) MAP ('q', 0x71) MAP ('r', 0x72) MAP ('s', 0x73) MAP ('t', 0x74) MAP ('u', 0x75) MAP ('v', 0x76) MAP ('w', 0x77)
	MAP ('x', 0x78) MAP ('y', 0x79) MAP ('z', 0x7a) MAP ('{', 0x7b) MAP ('|', 0x7c) MAP ('}', 0x7d) MAP ('~', 0x7e)

	#undef MAP
}

template <template <unsigned char> class Map>
unsigned char ECS::ASCIICharset::Lookup (const unsigned char character)
{
	#define MAP1(index) Map<index>::Value
	#define MAP4(index) MAP1 (index + 0), MAP1 (index + 1), MAP1 (index + 2), MAP1 (index + 3)
	#define MAP16(index) MAP4 (index + 0), MAP4 (index + 4), MAP4 (index + 8), MAP4 (index + 12)
	#define MAP64(index) MAP16 (index + 0), MAP16 (index + 16), MAP16 (index + 32), MAP16 (index + 48)
	static const unsigned char map[] {MAP64 (0), MAP64 (64)};
	#undef MAP1
	#undef MAP4
	#undef MAP16
	#undef MAP64
	return character < 128 ? map[character] : character;
}

#endif // ECS_STANDARDCHARSET_HEADER_INCLUDED

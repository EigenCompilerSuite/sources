// Generic utilities
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

#ifndef ECS_UTILITIES_HEADER_INCLUDED
#define ECS_UTILITIES_HEADER_INCLUDED

#include <cstdint>
#include <iosfwd>
#include <string>
#include <vector>

namespace ECS
{
	enum class Endianness {Little, Big};

	class UniversalCharacterName;

	template <typename> class Restore;
	template <typename> class Reverse;
	template <typename> class Span;
	template <typename, typename> class Lookup;

	using Bits = unsigned;
	using Byte = std::uint8_t;

	template <typename Value> Value Scale (Value, Bits);
	template <typename Value> Value Align (Value, Value);
	template <typename Value> Value ShiftLeft (Value, Bits);
	template <typename Value> Value ShiftRight (Value, Bits);
	template <typename Value> Value EncodeBits (Value, Value);
	template <typename Value> Value DecodeBits (Value, Value);
	template <typename Value> Value RotateLeft (Value, Bits);
	template <typename Value> Value RotateRight (Value, Bits);

	template <typename Value> Value Truncate (Value, Bits);
	template <> double Truncate (double, Bits);

	template <typename Value> bool TruncatesPreserving (Value, Bits);
	template <> bool TruncatesPreserving (double, Bits);

	template <typename Value> bool IsPowerOfTwo (Value);
	template <typename Value> Bits CountOnes (Value);
	template <typename Value> Bits CountTrailingZeros (Value);

	template <typename Value> bool CompareOrdered (const Value*, const Value*);

	template <typename Element, typename Container> bool InsertUnique (const Element&, Container&);
	template <typename Element, typename Container> bool IsFirst (const Element&, const Container&);
	template <typename Element, typename Container> bool IsLast (const Element&, const Container&);
	template <typename Element, typename Container> bool IsMember (const Element&, const Container&);
	template <typename Element, typename Container> std::size_t GetIndex (const Element&, const Container&);

	template <typename C, typename T>
	std::basic_string<C, T> Lowercase (const std::basic_string<C, T>&);

	template <typename C, typename T>
	std::basic_string<C, T> Uppercase (const std::basic_string<C, T>&);

	template <typename Value, std::size_t size>
	bool FindEnum (char, Value&, const char (&)[size]);

	template <typename Value, std::size_t size>
	bool FindEnum (const std::string&, Value&, const char*const (&)[size]);

	template <typename C, typename T, typename Value, std::size_t size>
	bool FindSortedEnum (const std::basic_string<C, T>&, Value&, const char*const (&)[size]);

	template <typename C, typename T>
	std::basic_istream<C, T>& ReadBool (std::basic_istream<C, T>&, bool&, const char*const (&)[2], bool (*) (C));

	template <typename C, typename T, typename Value>
	std::basic_istream<C, T>& ReadFloat (std::basic_istream<C, T>&, Value&, Value (*) (const C*, C**));

	template <typename C, typename T, std::size_t size>
	std::basic_istream<C, T>& ReadOptions (std::basic_istream<C, T>&, std::initializer_list<bool*>, const char*const (&)[size], bool (*) (C));

	template <typename C, typename T, typename Value, std::size_t size>
	std::basic_istream<C, T>& ReadEnum (std::basic_istream<C, T>&, Value&, const char (&)[size]);

	template <typename C, typename T, typename Value, std::size_t size>
	std::basic_istream<C, T>& ReadEnum (std::basic_istream<C, T>&, Value&, const char*const (&)[size], bool (*) (C));

	template <typename C, typename T, typename Value, std::size_t size>
	std::basic_istream<C, T>& ReadSortedEnum (std::basic_istream<C, T>&, Value&, const char*const (&)[size], bool (*) (C));

	template <typename C, typename T>
	std::basic_istream<C, T>& ReadIdentifier (std::basic_istream<C, T>&, std::basic_string<C, T>&, bool (*) (C));

	bool IsAddress (char);
	bool IsAlnum (char);
	bool IsAlpha (char);
	bool IsDotted (char);
	bool IsIdentifier (char);
	bool IsNumber (char);
	bool IsSpace (char);

	template <typename C, typename T>
	std::basic_ostream<C, T>& WriteBool (std::basic_ostream<C, T>&, bool, const char*const (&)[2]);

	template <typename C, typename T, std::size_t size>
	std::basic_ostream<C, T>& WriteOptions (std::basic_ostream<C, T>&, std::initializer_list<bool>, const char*const (&)[size]);

	template <typename C, typename T, typename Value, typename Identifier, std::size_t size>
	std::basic_ostream<C, T>& WriteEnum (std::basic_ostream<C, T>&, Value, const Identifier (&)[size]);

	template <typename C1, typename T1, typename C2, typename T2>
	std::basic_istream<C1, T1>& ReadEscaped (std::basic_istream<C1, T1>&, std::basic_string<C2, T2>&, char);

	template <typename C1, typename T1, typename C2, typename T2>
	std::basic_ostream<C1, T1>& WriteEscaped (std::basic_ostream<C1, T1>&, const std::basic_string<C2, T2>&, char);

	template <typename C1, typename T1, typename C2, typename T2>
	std::basic_istream<C1, T1>& ReadString (std::basic_istream<C1, T1>&, std::basic_string<C2, T2>&, char);

	template <typename C1, typename T1, typename C2, typename T2>
	std::basic_ostream<C1, T1>& WriteString (std::basic_ostream<C1, T1>&, const std::basic_string<C2, T2>&, char);

	template <typename C, typename T>
	std::basic_istream<C, T>& ReadByte (std::basic_istream<C, T>&, Byte&);

	template <typename C, typename T>
	std::basic_ostream<C, T>& WriteByte (std::basic_ostream<C, T>&, Byte);

	template <typename C, typename T>
	std::basic_ostream<C, T>& WriteBytes (std::basic_ostream<C, T>&, Span<const Byte>);

	template <typename C, typename T, typename Value>
	std::basic_istream<C, T>& ReadPrefixedValue (std::basic_istream<C, T>&, Value&, const C*, Value, Value);

	template <typename C, typename T, typename Value>
	std::basic_ostream<C, T>& WritePrefixedValue (std::basic_ostream<C, T>&, Value, const C*, Value);

	template <typename C, typename T>
	std::basic_ostream<C, T>& WriteAddress (std::basic_ostream<C, T>&, const char*, const std::basic_string<C, T>&, std::ptrdiff_t, Bits);

	template <typename C, typename T, typename Value>
	std::basic_istream<C, T>& ReadOffset (std::basic_istream<C, T>&, Value&);

	template <typename C, typename T, typename Value>
	std::basic_ostream<C, T>& WriteOffset (std::basic_ostream<C, T>&, Value);

	template <typename C, typename T>
	std::basic_ostream<C, T>& operator << (std::basic_ostream<C, T>&, const UniversalCharacterName&);
}

class ECS::UniversalCharacterName
{
public:
	explicit UniversalCharacterName (char32_t);

private:
	char32_t value;

	template <typename C, typename T>
	friend std::basic_ostream<C, T>& operator << (std::basic_ostream<C, T>&, const UniversalCharacterName&);
};

template <typename Value>
class ECS::Restore
{
public:
	explicit Restore (Value&);
	template <typename Temporary> Restore (Value&, const Temporary&);
	~Restore ();

private:
	Value& value;
	const Value previous;
};

template <typename Container>
class ECS::Reverse
{
public:
	explicit Reverse (Container& c) : container {c} {}

	auto begin () const {return std::rbegin (container);}
	auto end () const {return std::rend (container);}

private:
	Container& container;
};

template <typename Entry, typename Mnemonic>
class ECS::Lookup
{
public:
	template <std::size_t entries> explicit constexpr Lookup (const Entry (&)[entries]);
	template <std::size_t entries> explicit constexpr Lookup (const Entry (&)[entries], int);

	constexpr const Entry* operator [] (const Mnemonic mnemonic) const {return map[mnemonic];}

private:
	const Entry* map[Mnemonic::Count] {};
};

template <typename Value>
class ECS::Span
{
public:
	Span (Value*, Value*) noexcept;
	Span (Value*, std::size_t) noexcept;
	template <typename Element> Span (std::vector<Element>&) noexcept;
	template <typename Element> Span (const std::vector<Element>&) noexcept;

	std::size_t size () const noexcept;
	Value& operator [] (std::size_t) const noexcept;

	Value* begin () const noexcept;
	Value* end () const noexcept;

private:
	Value *first, *last;
};

#include <algorithm>
#include <cctype>
#include <cerrno>
#include <cmath>
#include <istream>
#include <limits>
#include <ostream>

inline ECS::UniversalCharacterName::UniversalCharacterName (const char32_t v) :
	value {v}
{
}

template <typename C, typename T>
std::basic_ostream<C, T>& ECS::operator << (std::basic_ostream<C, T>& stream, const UniversalCharacterName& character)
{
	const auto flags = stream.setf (stream.hex, stream.basefield);
	stream << '\\'; if (character.value < 0x10000) stream << 'u', stream.width (4); else stream << 'U', stream.width (8);
	const auto fill = stream.fill ('0'); stream << character.value; stream.setf (flags); stream.fill (fill); return stream;
}

template <typename Value>
Value ECS::Align (const Value offset, const Value alignment)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	return (offset + alignment - 1) / alignment * alignment;
}

template <typename Value>
inline Value ECS::ShiftLeft (const Value value, const Bits bits)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	return std::numeric_limits<Value>::is_signed && value < 0 ? -(-value << bits) : value << bits;
}

template <typename Value>
inline Value ECS::ShiftRight (const Value value, const Bits bits)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	return std::numeric_limits<Value>::is_signed && value < 0 ? ~(~value >> bits) : value >> bits;
}

template <typename Value>
Value ECS::Scale (const Value value, const Bits bits)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	return bits < Bits (std::numeric_limits<Value>::digits) ? ShiftRight (value, bits) : std::numeric_limits<Value>::is_signed && value < 0 ? -1 : 0;
}

template <typename Value>
Value ECS::Truncate (const Value value, Bits bits)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	bits = std::numeric_limits<Value>::digits + std::numeric_limits<Value>::is_signed - bits;
	return ShiftRight (ShiftLeft (value, bits), bits);
}

template <>
inline double ECS::Truncate (const double value, const Bits bits)
{
	static_assert (sizeof (float) * 8 == 32); static_assert (sizeof (double) * 8 == 64);
	return !std::isfinite (value) || bits > 32 ? value : float ((value < -std::numeric_limits<float>::max ()) ? -std::numeric_limits<float>::max () : value > std::numeric_limits<float>::max () ? std::numeric_limits<float>::max () : value);
}

template <typename Value>
bool ECS::TruncatesPreserving (const Value value, const Bits bits)
{
	return Truncate (value, bits) == value;
}

template <>
inline bool ECS::TruncatesPreserving (const double value, const Bits bits)
{
	return !std::isfinite (value) || (bits > 32 ? value >= -std::numeric_limits<double>::max () && value <= std::numeric_limits<double>::max () : value >= -std::numeric_limits<float>::max () && value <= std::numeric_limits<float>::max ());
}

template <typename Value>
bool ECS::IsPowerOfTwo (const Value value)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	return value > 0 && !(value & (value - 1));
}

template <typename Value>
ECS::Bits ECS::CountOnes (const Value value)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	Bits bits = 0; for (std::make_unsigned_t<Value> mask = value; mask; mask >>= 1) bits += mask & 1; return bits;
}

template <typename Value>
ECS::Bits ECS::CountTrailingZeros (const Value value)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	Bits bits = 0; for (std::make_unsigned_t<Value> mask = value; !(mask & 1); mask >>= 1) ++bits; return bits;
}

template <typename Value>
Value ECS::EncodeBits (Value value, Value mask)
{
	static_assert (std::numeric_limits<Value>::is_integer && !std::numeric_limits<Value>::is_signed);
	Value code = 0; for (Bits bit = 0; mask; ++bit, mask >>= 1) if (mask & 1) code |= (value & 1) << bit, value >>= 1; return code;
}

template <typename Value>
Value ECS::DecodeBits (Value code, Value mask)
{
	static_assert (std::numeric_limits<Value>::is_integer && !std::numeric_limits<Value>::is_signed);
	Value value = 0; for (Bits bit = 0; mask; code >>= 1, mask >>= 1) if (mask & 1) value |= (code & 1) << bit, ++bit; return value;
}

template <typename Value>
Value ECS::RotateLeft (const Value value, const Bits bits)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	return value << bits | std::make_unsigned_t<Value> (value) >> (std::numeric_limits<Value>::digits - bits);
}

template <typename Value>
Value ECS::RotateRight (const Value value, const Bits bits)
{
	static_assert (std::numeric_limits<Value>::is_integer);
	return std::make_unsigned_t<Value> (value) >> bits | value << (std::numeric_limits<Value>::digits - bits);
}

template <typename Value>
inline bool ECS::CompareOrdered (const Value*const a, const Value*const b)
{
	return std::less<const Value*> () (a, b);
}

template <typename Element, typename Container>
bool ECS::InsertUnique (const Element& element, Container& container)
{
	for (auto& duplicate: container) if (element == duplicate) return false;
	container.push_back (element); return true;
}

template <typename Element, typename Container>
inline bool ECS::IsFirst (const Element& value, const Container& container)
{
	return &value == &container.front ();
}

template <typename Element, typename Container>
inline bool ECS::IsLast (const Element& value, const Container& container)
{
	return &value == &container.back ();
}

template <typename Element, typename Container>
inline bool ECS::IsMember (const Element& value, const Container& container)
{
	return !CompareOrdered (&value, container.data ()) && CompareOrdered (&value, container.data () + container.size ());
}

template <typename Element, typename Container>
inline std::size_t ECS::GetIndex (const Element& value, const Container& container)
{
	return &value - &*container.begin ();
}

template <typename Value>
ECS::Restore<Value>::Restore (Value& v) :
	value {v}, previous {v}
{
}

template <typename Value> template <typename Temporary>
ECS::Restore<Value>::Restore (Value& v, const Temporary& temporary) :
	Restore {v}
{
	value = temporary;
}

template <typename Value>
inline ECS::Restore<Value>::~Restore<Value> ()
{
	value = previous;
}

template <typename Entry, typename Mnemonic> template <std::size_t entries>
constexpr ECS::Lookup<Entry, Mnemonic>::Lookup (const Entry (&table)[entries])
{
	for (auto entry = table; entry != table + entries; ++entry)
		if (!map[entry[0].mnemonic]) map[entry[0].mnemonic] = entry;
}

template <typename Entry, typename Mnemonic> template <std::size_t entries>
constexpr ECS::Lookup<Entry, Mnemonic>::Lookup (const Entry (&table)[entries], int)
{
	for (auto entry = table + entries; entry != table; --entry)
		if (!map[entry[-1].mnemonic]) map[entry[-1].mnemonic] = entry;
}

template <typename Value>
inline ECS::Span<Value>::Span (Value*const begin, Value*const end) noexcept :
	first {begin}, last {end}
{
}

template <typename Value>
inline ECS::Span<Value>::Span (Value*const begin, const std::size_t size) noexcept :
	first {begin}, last {begin + size}
{
}

template <typename Value> template <typename Element>
inline ECS::Span<Value>::Span (std::vector<Element>& vector) noexcept :
	Span {vector.data (), vector.size ()}
{
}

template <typename Value> template <typename Element>
inline ECS::Span<Value>::Span (const std::vector<Element>& vector) noexcept :
	Span {vector.data (), vector.size ()}
{
}

template <typename Value>
inline std::size_t ECS::Span<Value>::size () const noexcept
{
	return last - first;
}

template <typename Value>
inline Value& ECS::Span<Value>::operator [] (const std::size_t index) const noexcept
{
	return first[index];
}

template <typename Value>
inline Value* ECS::Span<Value>::begin () const noexcept
{
	return first;
}

template <typename Value>
inline Value* ECS::Span<Value>::end () const noexcept
{
	return last;
}

template <typename C, typename T>
std::basic_string<C, T> ECS::Lowercase (const std::basic_string<C, T>& string)
{
	auto result = string; for (auto& character: result) character = std::tolower (character); return result;
}

template <typename C, typename T>
std::basic_string<C, T> ECS::Uppercase (const std::basic_string<C, T>& string)
{
	auto result = string; for (auto& character: result) character = std::toupper (character); return result;
}

template <typename Value, std::size_t size>
bool ECS::FindEnum (const char identifier, Value& value, const char (&table)[size])
{
	for (auto entry = table; entry != table + size; ++entry)
		if (*entry == identifier) return value = Value (entry - table), true;
	return false;
}

template <typename Value, std::size_t size>
bool ECS::FindEnum (const std::string& identifier, Value& value, const char*const (&table)[size])
{
	for (auto entry = table; entry != table + size; ++entry)
		if (*entry && *entry == identifier) return value = Value (entry - table), true;
	return false;
}

template <typename C, typename T, typename Value, std::size_t size>
bool ECS::FindSortedEnum (const std::basic_string<C, T>& identifier, Value& value, const char*const (&table)[size])
{
	const auto entry = std::lower_bound (table, table + size, identifier);
	if (entry != table + size && *entry == identifier) return value = Value (entry - table), true;
	return false;
}

template <typename C, typename T>
std::basic_istream<C, T>& ECS::ReadBool (std::basic_istream<C, T>& stream, bool& value, const char*const (&table)[2], bool (*const classify) (C))
{
	std::basic_string<C, T> identifier;
	if (ReadIdentifier (stream, identifier, classify))
		if (identifier == table[0]) value = false;
		else if (identifier == table[1]) value = true;
		else stream.setstate (stream.failbit);
	return stream;
}

template <typename C, typename T>
inline std::basic_ostream<C, T>& ECS::WriteBool (std::basic_ostream<C, T>& stream, const bool value, const char*const (&table)[2])
{
	return stream << table[value];
}

template <typename C, typename T, typename Value>
std::basic_istream<C, T>& ECS::ReadFloat (std::basic_istream<C, T>& stream, Value& value, Value (*const convert) (const C*, C**))
{
	std::basic_string<C, T> string; C* end;
	if (ReadIdentifier (stream, string, IsNumber)) if (errno = 0, value = convert (string.c_str (), &end), *end || errno == ERANGE) stream.setstate (stream.failbit);
	return stream;
}

template <typename C, typename T, std::size_t size>
std::basic_istream<C, T>& ECS::ReadOptions (std::basic_istream<C, T>& stream, const std::initializer_list<bool*> options, const char*const (&table)[size], bool (*const classify) (C))
{
	for (auto option: options) *option = false;
	for (std::size_t index; stream.good () && stream >> std::ws && stream.good () && classify (stream.peek ()); *options.begin ()[index] = true)
		if (!ReadEnum (stream, index, table, classify) || index >= size || *options.begin ()[index]) return stream.setstate (stream.failbit), stream;
	return stream;
}

template <typename C, typename T, std::size_t size>
std::basic_ostream<C, T>& ECS::WriteOptions (std::basic_ostream<C, T>& stream, const std::initializer_list<bool> options, const char*const (&table)[size])
{
	for (auto& option: options) if (option) WriteEnum (stream << ' ', GetIndex (option, options), table); return stream;
}

template <typename C, typename T, typename Value, std::size_t size>
std::basic_istream<C, T>& ECS::ReadEnum (std::basic_istream<C, T>& stream, Value& value, const char (&table)[size])
{
	char identifier;
	if (stream >> identifier && FindEnum (identifier, value, table)) return stream;
	stream.setstate (stream.failbit); return stream;
}

template <typename C, typename T, typename Value, std::size_t size>
std::basic_istream<C, T>& ECS::ReadEnum (std::basic_istream<C, T>& stream, Value& value, const char*const (&table)[size], bool (*const classify) (C))
{
	std::string identifier;
	if (ReadIdentifier (stream, identifier, classify) && FindEnum (identifier, value, table)) return stream;
	stream.setstate (stream.failbit); return stream;
}

template <typename C, typename T, typename Value, std::size_t size>
std::basic_istream<C, T>& ECS::ReadSortedEnum (std::basic_istream<C, T>& stream, Value& value, const char*const (&table)[size], bool (*const classify) (C))
{
	std::string identifier;
	if (ReadIdentifier (stream, identifier, classify) && FindSortedEnum (identifier, value, table)) return stream;
	stream.setstate (stream.failbit); return stream;
}

template <typename C, typename T, typename Value, typename Identifier, std::size_t size>
std::basic_ostream<C, T>& ECS::WriteEnum (std::basic_ostream<C, T>& stream, const Value value, const Identifier (&table)[size])
{
	if (std::size_t (value) < size) stream << table[std::size_t (value)]; else stream.setstate (stream.failbit); return stream;
}

template <typename C, typename T>
std::basic_istream<C, T>& ECS::ReadIdentifier (std::basic_istream<C, T>& stream, std::basic_string<C, T>& identifier, bool (*const classify) (C))
{
	C character; identifier.clear (); stream >> character;
	while (stream && classify (character)) identifier.push_back (character), stream.get (character);
	if (identifier.empty ()) stream.setstate (stream.failbit); else stream.putback (character).clear ();
	return stream;
}

inline bool ECS::IsAlpha (const char character)
{
	return std::isalpha (character);
}

inline bool ECS::IsAlnum (const char character)
{
	return std::isalnum (character);
}

inline bool ECS::IsDotted (const char character)
{
	return std::isalnum (character) || character == '.';
}

inline bool ECS::IsIdentifier (const char character)
{
	return IsDotted (character) || character == '$' || character == '_' || character == '#';
}

inline bool ECS::IsNumber (const char character)
{
	return IsDotted (character) || character == '+' || character == '-';
}

inline bool ECS::IsAddress (const char character)
{
	return IsIdentifier (character) || character == '?' || character == ':';
}

inline bool ECS::IsSpace (const char character)
{
	return std::isspace (character);
}

template <typename C1, typename T1, typename C2, typename T2>
std::basic_istream<C1, T1>& ECS::ReadEscaped (std::basic_istream<C1, T1>& stream, std::basic_string<C2, T2>& string, const char delimiter)
{
	unsigned code; const auto flags = stream.setf (stream.hex, stream.basefield | stream.skipws); string.clear ();
	for (C1 character; stream.good () && std::isprint (stream.peek ()) && stream.good () && stream.peek () != delimiter && stream.get (character);)
		if (character != '\\') string.push_back (character);
		else switch (character = C1 (stream.get ()))
		{
		case '0': string.push_back ('\0'); break;
		case 'a': string.push_back ('\a'); break;
		case 'b': string.push_back ('\b'); break;
		case 't': string.push_back ('\t'); break;
		case 'n': string.push_back ('\n'); break;
		case 'v': string.push_back ('\v'); break;
		case 'f': string.push_back ('\f'); break;
		case 'r': string.push_back ('\r'); break;
		case '"': case '\'': case '?': case '\\': string.push_back (character); break;
		case 'x': if (stream >> code) string.push_back (code); break;
		default: stream.setstate (stream.failbit);
		}
	stream.flags (flags); return stream;
}

template <typename C1, typename T1, typename C2, typename T2>
std::basic_ostream<C1, T1>& ECS::WriteEscaped (std::basic_ostream<C1, T1>& stream, const std::basic_string<C2, T2>& string, const char delimiter)
{
	const auto flags = stream.setf (stream.hex, stream.basefield); const auto fill = stream.fill ('0');
	for (std::uint32_t character: string)
		switch (character)
		{
		case '\0': stream << "\\0"; break;
		case '\a': stream << "\\a"; break;
		case '\b': stream << "\\b"; break;
		case '\t': stream << "\\t"; break;
		case '\n': stream << "\\n"; break;
		case '\v': stream << "\\v"; break;
		case '\f': stream << "\\f"; break;
		case '\r': stream << "\\r"; break;
		case '?': if (delimiter == '?') goto escape;
		case '"': case '\'': case '\\': stream << '\\' << C1 (character); break;
		default: if (character <= std::uint32_t (std::numeric_limits<C1>::max ()) && std::isprint (character) && C1 (character) != delimiter) stream << C1 (character);
			else if (character >= 0x10000) stream << "\\U", stream.width (8), stream << character;
			else if (character >= 0x100) stream << "\\u", stream.width (4), stream << character;
			else escape: stream << "\\x" << (character & std::numeric_limits<C2>::max ());
		}
	stream.flags (flags); stream.fill (fill); return stream;
}

template <typename C1, typename T1, typename C2, typename T2>
std::basic_istream<C1, T1>& ECS::ReadString (std::basic_istream<C1, T1>& stream, std::basic_string<C2, T2>& string, const char delimiter)
{
	char character;
	if (stream >> character && character == delimiter && ReadEscaped (stream, string, delimiter).get (character) && character == delimiter) return stream;
	stream.setstate (stream.failbit); return stream;
}

template <typename C1, typename T1, typename C2, typename T2>
inline std::basic_ostream<C1, T1>& ECS::WriteString (std::basic_ostream<C1, T1>& stream, const std::basic_string<C2, T2>& string, const char delimiter)
{
	return WriteEscaped (stream << delimiter, string, delimiter) << delimiter;
}

template <typename C, typename T>
std::basic_istream<C, T>& ECS::ReadByte (std::basic_istream<C, T>& stream, Byte& value)
{
	char digit;
	if (stream >> digit && std::isxdigit (digit))
		value = (digit >= 'a' ? digit - ('a' - 10) : digit >= 'A' ? digit - ('A' - 10) : digit - '0') << 4;
	else stream.setstate (stream.failbit);
	if (stream.get (digit) && std::isxdigit (digit))
		value |= (digit >= 'a' ? digit - ('a' - 10) : digit >= 'A' ? digit - ('A' - 10) : digit - '0');
	else stream.setstate (stream.failbit);
	return stream;
}

template <typename C, typename T>
std::basic_ostream<C, T>& ECS::WriteByte (std::basic_ostream<C, T>& stream, const Byte value)
{
	auto digit = (value >> 4) & 0xf; stream << char (digit + (digit < 10 ? '0' : stream.flags () & stream.uppercase ? 'A' - 10 : 'a' - 10));
	digit = value & 0xf; return stream << char (digit + (digit < 10 ? '0' : stream.flags () & stream.uppercase ? 'A' - 10 : 'a' - 10));
}

template <typename C, typename T>
std::basic_ostream<C, T>& ECS::WriteBytes (std::basic_ostream<C, T>& stream, const Span<const Byte> bytes)
{
	for (auto byte: bytes) WriteByte (stream, byte); return stream;
}

template <typename C, typename T, typename Value>
std::basic_istream<C, T>& ECS::ReadPrefixedValue (std::basic_istream<C, T>& stream, Value& value, const C*const prefix, const Value low, const Value high)
{
	stream >> std::ws; for (auto p = prefix; *p; ++p) if (stream.get () != *p) return stream.setstate (stream.failbit), stream;
	const auto flags = stream.setf (stream.dec, stream.basefield | stream.skipws);
	unsigned integer; if (stream >> integer && integer <= unsigned (high - low)) value = Value (integer + low); else stream.setstate (stream.failbit);
	stream.flags (flags); return stream;
}

template <typename C, typename T, typename Value>
std::basic_ostream<C, T>& ECS::WritePrefixedValue (std::basic_ostream<C, T>& stream, const Value value, const C*const prefix, const Value offset)
{
	const auto flags = stream.setf (stream.dec, stream.basefield);
	stream << prefix << unsigned (value - offset); stream.flags (flags); return stream;
}

template <typename C, typename T>
std::basic_ostream<C, T>& ECS::WriteAddress (std::basic_ostream<C, T>& stream, const char*const function, const std::basic_string<C, T>& address, const std::ptrdiff_t displacement, const Bits scale)
{
	if (function) stream << function << ' ' << '(';
	if (std::all_of (address.begin (), address.end (), IsAddress)) stream << '@' << address; else WriteString (stream << '@', address, '"');
	if (function) stream << ')';
	if (displacement > 0) stream << " + " << displacement; else if (displacement < 0) stream << " - " << -displacement;
	if (scale) stream << " >> " << scale;
	return stream;
}

template <typename C, typename T, typename Value>
std::basic_istream<C, T>& ECS::ReadOffset (std::basic_istream<C, T>& stream, Value& value)
{
	const auto flags = stream.setf (stream.dec, stream.basefield);
	if (stream >> std::ws && stream.peek () != '0') stream >> value;
	else if (stream.ignore ().peek () == 'x' && stream.ignore ()) stream >> std::hex >> value;
	else stream.putback ('0') >> value; stream.flags (flags); return stream;
}

template <typename C, typename T, typename Value>
std::basic_ostream<C, T>& ECS::WriteOffset (std::basic_ostream<C, T>& stream, const Value value)
{
	const auto flags = stream.setf (stream.hex | stream.showbase, stream.basefield | stream.showbase | stream.uppercase); stream << value; stream.flags (flags); return stream;
}

#endif // ECS_UTILITIES_HEADER_INCLUDED

// Oberon transpiler runtime support
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

// Under Section 7 of the GNU General Public License version 3,
// the copyright holder grants you additional permissions to use
// this file as described in the ECS Runtime Support Exception.

// You should have received a copy of the GNU General Public License
// and a copy of the ECS Runtime Support Exception along with
// the ECS.  If not, see <https://www.gnu.org/licenses/>.

#ifndef ECS_OBERON_TRANSPILER_RUNTIME_HEADER_INCLUDED
#define ECS_OBERON_TRANSPILER_RUNTIME_HEADER_INCLUDED

#include <algorithm>
#include <cassert>
#include <cmath>
#include <complex>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <functional>
#include <iostream>
#include <limits>
#include <typeinfo>
#include <type_traits>
#include <vector>

#define TRACE(expression) void (std::cout << __FILE__ << ':' << __LINE__ << ": note: '" << #expression << "' = " << (expression) << std::endl)
template <typename C, typename T> inline std::basic_ostream<C, T>& operator << (std::basic_ostream<C, T>& stream, std::nullptr_t value) {return stream << static_cast<void*> (value);}

namespace Oberon
{
	class Module;

	template <typename Element> class Array;
	template <typename Element> class Set;
	template <typename Type> class Span;
	template <typename Type, Type Value> class ValueType;

	template <typename Record, typename Value> void Assign (Record&, const Value&);

	bool operator == (const Array<char>&, const Array<char>&);
	bool operator != (const Array<char>&, const Array<char>&);
	bool operator < (const Array<char>&, const Array<char>&);
	bool operator <= (const Array<char>&, const Array<char>&);
	bool operator > (const Array<char>&, const Array<char>&);
	bool operator >= (const Array<char>&, const Array<char>&);

	template <typename C, typename T> std::basic_ostream<C, T>& operator << (std::basic_ostream<C, T>&, const Array<char>&);
	template <typename C, typename T, typename Element> std::basic_ostream<C, T>& operator << (std::basic_ostream<C, T>&, Set<Element>);
}

inline namespace GLOBAL
{
	using BOOLEAN = bool;
	using CARDINAL = unsigned;
	using CHAR = char;
	using COMPLEX = std::complex<double>;
	using COMPLEX32 = std::complex<float>;
	using COMPLEX64 = std::complex<long double>;
	using HUGECARD = std::uint64_t;
	using HUGEINT = std::int64_t;
	using HUGESET = Oberon::Set<std::uint64_t>;
	using INTEGER = int;
	using LENGTH = std::ptrdiff_t;
	using LONGCARD = std::uint32_t;
	using LONGCOMPLEX = std::complex<long double>;
	using LONGINT = std::int32_t;
	using LONGREAL = long double;
	using LONGSET = Oberon::Set<std::uint32_t>;
	using NIL = std::nullptr_t;
	using REAL = double;
	using REAL32 = float;
	using REAL64 = long double;
	using SET = Oberon::Set<unsigned>;
	using SET8 = Oberon::Set<std::uint8_t>;
	using SET16 = Oberon::Set<std::uint16_t>;
	using SET32 = Oberon::Set<std::uint32_t>;
	using SET64 = Oberon::Set<std::uint64_t>;
	using SHORTCARD = std::uint16_t;
	using SHORTCOMPLEX = std::complex<float>;
	using SHORTINT = std::int16_t;
	using SHORTREAL = float;
	using SHORTSET = Oberon::Set<std::uint16_t>;
	using SIGNED8 = std::int8_t;
	using SIGNED16 = std::int16_t;
	using SIGNED32 = std::int32_t;
	using SIGNED64 = std::int64_t;
	using STRING = const char*;
	using UNSIGNED8 = std::uint8_t;
	using UNSIGNED16 = std::uint16_t;
	using UNSIGNED32 = std::uint32_t;
	using UNSIGNED64 = std::uint64_t;

	auto ASSERT (bool, int = 1) -> void;
	auto CAP (CHAR) -> CHAR;
	auto CHR (INTEGER) -> CHAR;
	auto COPY (const Oberon::Array<CHAR>&, Oberon::Array<CHAR>&) -> void;
	auto ENTIER (LONGREAL) -> LONGINT;
	auto HALT [[noreturn]] (int) -> void;
	auto ODD (INTEGER) -> BOOLEAN;
	auto ORD (CHAR) -> INTEGER;
	template <typename Element> auto EXCL (Oberon::Set<Element>&, INTEGER) -> void;
	template <typename Element> auto INCL (Oberon::Set<Element>&, INTEGER) -> void;
	template <typename Element> auto LEN (const Oberon::Array<Element>&, std::size_t = 0) -> std::size_t;
	template <typename Element> auto LEN (const Oberon::Array<Oberon::Array<Element>>&, std::size_t) -> std::size_t;
	template <typename Element> auto NEW (Oberon::Array<Element>*&, std::size_t) -> void;
	template <typename Element> auto NEW (Oberon::Array<Oberon::Array<Element>>*&, std::size_t, std::size_t) -> void;
	template <typename Integer, typename Shift> auto ASH (Integer, Shift) -> Integer;
	template <typename Integer, typename Value> auto DEC (Integer&, Value) -> void;
	template <typename Integer, typename Value> auto INC (Integer&, Value) -> void;
	template <typename Integer> auto DEC (Integer&) -> void;
	template <typename Integer> auto INC (Integer&) -> void;
	template <typename Integer> auto LONG (Integer) -> Integer;
	template <typename Integer> auto SHORT (Integer) -> Integer;
	template <typename Numeric> auto ABS (const Numeric value) -> decltype (std::abs (value));
	template <typename Pointer> auto DISPOSE (Pointer*&) -> void;
	template <typename Pointer> auto NEW (Pointer*&) -> void;
	template <typename Real> Real IM (const std::complex<Real>);
	template <typename Real> Real RE (const std::complex<Real>);
	template <typename Type> auto IGNORE (const Type&) -> void {}
	template <typename Type> auto LEN (const Oberon::Span<Type>&, std::size_t = 0) -> std::size_t;
	template <typename Variable> auto PTR (Variable&) -> Variable*;
}

struct SYSTEM
{
	using ADDRESS = std::size_t;
	using BYTE = std::uint8_t;
	using PTR = void*;
	using SET = Oberon::Set<std::size_t>;

	static auto BIT (ADDRESS, LENGTH) -> BOOLEAN;
	static auto MOVE (ADDRESS, ADDRESS, LENGTH) -> void;
	template <typename Integer, typename Shift> static auto LSH (Integer, Shift) -> Integer;
	template <typename Integer, typename Shift> static auto ROT (Integer, Shift) -> Integer;
	template <typename Pointer> static auto DISPOSE (Pointer*&) -> void;
	template <typename Pointer> static auto NEW (Pointer*&, LENGTH) -> void;
	template <typename Type, typename Element> static auto VAL (Oberon::Array<Element>&) -> Type&;
	template <typename Type, typename Value> static auto VAL (const Value&) -> Type;
	template <typename Type, typename Value> static auto VAL (Value&) -> Type&;
	template <typename Value> static auto ADR (Value&) -> ADDRESS;
	template <typename Value> static auto GET (ADDRESS, Value&) -> void;
	template <typename Value> static auto PUT (ADDRESS, const Value&) -> void;
};

class Oberon::Module
{
public:
	explicit Module (void (*) ());
};

template <typename Element>
class Oberon::Set
{
public:
	using Mask = Element;

	constexpr Set () = default;
	constexpr explicit Set (Mask);
	constexpr Set (Element, Element);

	template <typename Other> constexpr operator Set<Other> () const;
	template <typename Other> constexpr explicit operator Other () const;

	Set& operator += (Element);
	Set& operator -= (Element);

	Set operator + () const;
	Set operator - () const;

	Set operator + (Set) const;
	Set operator - (Set) const;
	Set operator * (Set) const;
	Set operator / (Set) const;

	bool operator == (Set) const;
	bool operator != (Set) const;

	bool operator [] (Element) const;

private:
	Mask mask = 0;
};

template <typename Element>
class Oberon::Array
{
public:
	Array (const char*);
	explicit Array (std::size_t, const Element& = {});

	Array& operator = (const char*);

	Element& operator [] (std::size_t);
	const Element& operator [] (std::size_t) const;

private:
	std::vector<Element> array;

	friend std::size_t GLOBAL::LEN<Element> (const Array&, std::size_t);
};

template <typename Type>
class Oberon::Span
{
public:
	template <typename Value> Span (Value&);
	template <typename Element> Span (Array<Element>&);

private:
	Type *begin, *end;

	friend std::size_t GLOBAL::LEN<Type> (const Span&, std::size_t);
};

template <typename Type, Type Value_>
class Oberon::ValueType
{
public:
	static constexpr Type Value = Value_;
};

template <typename Element>
constexpr Oberon::Set<Element>::Set (const Mask m) :
	mask {m}
{
}

template <typename Element> template <typename Other>
constexpr Oberon::Set<Element>::operator Oberon::Set<Other> () const
{
	return Set<Other> (mask);
}

template <typename Element> template <typename Other>
constexpr Oberon::Set<Element>::operator Other () const
{
	return Other (mask);
}

template <typename Element>
constexpr Oberon::Set<Element>::Set (const Element lower, const Element upper) :
	mask {~Element (0) << lower & ~(~Element (1) << upper)}
{
}

template <typename Element>
Oberon::Set<Element>& Oberon::Set<Element>::operator += (const Element element)
{
	mask |= 1 << element; return *this;
}

template <typename Element>
Oberon::Set<Element>& Oberon::Set<Element>::operator -= (const Element element)
{
	mask &= ~(1 << element); return *this;
}

template <typename Element>
Oberon::Set<Element> Oberon::Set<Element>::operator + () const
{
	return Set {mask};
}

template <typename Element>
Oberon::Set<Element> Oberon::Set<Element>::operator - () const
{
	return Set {~mask};
}

template <typename Element>
Oberon::Set<Element> Oberon::Set<Element>::operator + (const Set other) const
{
	return Set {mask | other.mask};
}

template <typename Element>
Oberon::Set<Element> Oberon::Set<Element>::operator - (const Set other) const
{
	return Set {mask & ~other.mask};
}

template <typename Element>
Oberon::Set<Element> Oberon::Set<Element>::operator * (const Set other) const
{
	return Set {mask & other.mask};
}

template <typename Element>
Oberon::Set<Element> Oberon::Set<Element>::operator / (const Set other) const
{
	return Set {mask ^ other.mask};
}

template <typename Element>
bool Oberon::Set<Element>::operator == (const Set other) const
{
	return mask == other.mask;
}

template <typename Element>
bool Oberon::Set<Element>::operator != (const Set other) const
{
	return mask != other.mask;
}

template <typename Element>
bool Oberon::Set<Element>::operator [] (const Element element) const
{
	return mask >> element & 1;
}

template <typename Element>
Oberon::Array<Element>::Array (const char*const string) :
	array {string, string + std::strlen (string) + 1}
{
}

template <typename Element>
inline Oberon::Array<Element>::Array (const std::size_t length, const Element& element) :
	array (length, element)
{
}

template <typename Element>
Oberon::Array<Element>& Oberon::Array<Element>::operator = (const char*const string)
{
	std::copy (string, string + std::strlen (string) + 1, array.begin ()); return *this;
}

template <typename Element>
inline Element& Oberon::Array<Element>::operator [] (const std::size_t index)
{
	return array.at (index);
}

template <typename Element>
inline const Element& Oberon::Array<Element>::operator [] (const std::size_t index) const
{
	return array.at (index);
}

template <typename Type> template <typename Value>
inline Oberon::Span<Type>::Span (Value& value) :
	begin {reinterpret_cast<Type*> (&value)}, end {begin + sizeof (Value)}
{
}

template <typename Type> template <typename Element>
inline Oberon::Span<Type>::Span (Array<Element>& array) :
	begin {reinterpret_cast<Type*> (array[0])}, end {begin + LEN (array) * sizeof (Element)}
{
}

template <typename Record, typename Value>
inline void Oberon::Assign (Record& record, const Value& value)
{
	assert (typeid (record) == typeid (Record)); record = value;
}

template <typename C, typename T, typename Element>
std::basic_ostream<C, T>& Oberon::operator << (std::basic_ostream<C, T>& stream, const Set<Element> set)
{
	stream << '{';
	for (Element element = 0, comma = 0; element != sizeof (Element) * 8; ++element)
		if (set[element]) (comma ? stream << ", " : stream) << int (element), comma = true;
	return stream << '}';
}

template <typename C, typename T>
std::basic_ostream<C, T>& Oberon::operator << (std::basic_ostream<C, T>& stream, const Array<char>& array)
{
	return stream << &array[0];
}

template <typename Numeric>
inline auto GLOBAL::ABS (const Numeric value) -> decltype (std::abs (value))
{
	return std::abs (value);
}

template <typename Integer, typename Shift>
inline Integer GLOBAL::ASH (const Integer value, const Shift shift)
{
	return shift < 0 ? value >> -shift : value << shift;
}

template <typename Integer>
inline void GLOBAL::DEC (Integer& variable)
{
	--variable;
}

template <typename Integer, typename Value>
inline void GLOBAL::DEC (Integer& variable, const Value value)
{
	variable -= value;
}

template <typename Pointer>
inline void GLOBAL::DISPOSE (Pointer*& pointer)
{
	delete pointer; pointer = nullptr;
}

template <typename Element>
inline void GLOBAL::EXCL (Oberon::Set<Element>& set, const INTEGER element)
{
	set -= element;
}

template <typename Integer>
inline void GLOBAL::INC (Integer& variable)
{
	++variable;
}

template <typename Integer, typename Value>
inline void GLOBAL::INC (Integer& variable, const Value value)
{
	variable += value;
}

template <typename Element>
inline void GLOBAL::INCL (Oberon::Set<Element>& set, const INTEGER element)
{
	set += element;
}

template <typename Element>
inline std::size_t GLOBAL::LEN (const Oberon::Array<Element>& array, const std::size_t)
{
	return array.array.size ();
}

template <typename Element>
inline std::size_t GLOBAL::LEN (const Oberon::Array<Oberon::Array<Element>>& array, const std::size_t dimension)
{
	return !dimension ? LEN (array) : LEN (array[0], dimension - 1);
}

template <typename Type>
inline std::size_t GLOBAL::LEN (const Oberon::Span<Type>& span, const std::size_t)
{
	return span.end - span.begin;
}

template <typename Integer>
inline Integer GLOBAL::LONG (const Integer value)
{
	return value;
}

template <typename Pointer>
inline void GLOBAL::NEW (Pointer*& pointer)
{
	pointer = new Pointer {};
}

template <typename Element>
inline void GLOBAL::NEW (Oberon::Array<Element>*& pointer, const std::size_t length)
{
	pointer = new Oberon::Array<Element> {length};
}

template <typename Element>
inline void GLOBAL::NEW (Oberon::Array<Oberon::Array<Element>>*& pointer, const std::size_t length1, const std::size_t length2)
{
	pointer = new Oberon::Array<Oberon::Array<Element>> {length1, Oberon::Array<Element> {length2}};
}

template <typename Variable>
inline Variable* GLOBAL::PTR (Variable& variable)
{
	return &variable;
}

template <typename Integer>
inline Integer GLOBAL::SHORT (const Integer value)
{
	return value;
}

template <typename Real>
inline Real GLOBAL::RE (const std::complex<Real> value)
{
	return real (value);
}

template <typename Real>
inline Real GLOBAL::IM (const std::complex<Real> value)
{
	return imag (value);
}

template <typename Value>
inline SYSTEM::ADDRESS SYSTEM::ADR (Value& value)
{
	return reinterpret_cast<ADDRESS> (&value);
}

inline BOOLEAN SYSTEM::BIT (const ADDRESS address, const LENGTH index)
{
	return *reinterpret_cast<BYTE*> (address + index / 8) >> index % 8 & 1;
}

template <typename Value>
inline void SYSTEM::GET (const ADDRESS address, Value& value)
{
	value = *reinterpret_cast<Value*> (address);
}

template <typename Integer, typename Shift>
inline Integer SYSTEM::LSH (const Integer value, const Shift shift)
{
	return shift < 0 ? typename std::make_unsigned<Integer>::type (value) >> -shift : typename std::make_unsigned<Integer>::type (value) << shift;
}

template <typename Pointer>
inline void SYSTEM::DISPOSE (Pointer*& pointer)
{
	free (pointer); pointer = nullptr;
}

template <typename Pointer>
inline void SYSTEM::NEW (Pointer*& pointer, const LENGTH length)
{
	pointer = reinterpret_cast<Pointer*> (std::malloc (length));
}

template <typename Value>
inline void SYSTEM::PUT (const ADDRESS address, const Value& value)
{
	*reinterpret_cast<Value*> (address) = value;
}

template <typename Integer, typename Shift>
inline Integer SYSTEM::ROT (const Integer value, const Shift shift)
{
	constexpr auto bits = std::numeric_limits<Integer>::digits;
	return typename std::make_unsigned<Integer>::type (value) << shift % bits | typename std::make_unsigned<Integer>::type (value) >> (bits - shift) % bits;
}

template <typename Type, typename Value>
inline Type& SYSTEM::VAL (Value& value)
{
	return reinterpret_cast<Type&> (value);
}

template <typename Type, typename Value>
inline Type SYSTEM::VAL (const Value& value)
{
	return *reinterpret_cast<const Type*> (&value);
}

template <typename Type, typename Element>
inline Type& SYSTEM::VAL (Oberon::Array<Element>& array)
{
	return *reinterpret_cast<Type*> (&array[0]);
}

#endif // ECS_OBERON_TRANSPILER_RUNTIME_HEADER_INCLUDED

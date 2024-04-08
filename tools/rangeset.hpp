// Range set utility
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

#ifndef ECS_RANGESET_HEADER_INCLUDED
#define ECS_RANGESET_HEADER_INCLUDED

#include <set>

namespace ECS
{
	template <typename> class RangeSet;

	template <typename> struct Range;

	template <typename Value> bool operator < (const Range<Value>&, const Range<Value>&);
}

template <typename Value>
struct ECS::Range
{
	Value lower, upper;

	Range () = default;
	Range (const Value&);
	Range (const Value&, const Value&);

	bool operator [] (const Value&) const;
};

template <typename Value>
class ECS::RangeSet
{
public:
	void insert (const Range<Value>&);
	bool operator [] (const Range<Value>&) const;

	auto begin () const {return set.begin ();}
	auto end () const {return set.end ();}
	auto empty () const {return set.empty ();}

private:
	std::set<Range<Value>> set;

	static Value increment (Value value) {return ++value;}
};

template <typename Value>
ECS::Range<Value>::Range (const Value& v) :
	lower {v}, upper {v}
{
}

template <typename Value>
ECS::Range<Value>::Range (const Value& l, const Value& u) :
	lower {l}, upper {u}
{
}

template <typename Value>
bool ECS::Range<Value>::operator [] (const Value& value) const
{
	return value >= lower && value <= upper;
}

template <typename Value>
bool ECS::operator < (const Range<Value>& a, const Range<Value>& b)
{
	return a.lower < b.lower;
}

template <typename Value>
void ECS::RangeSet<Value>::insert (const Range<Value>& range)
{
	if (range.lower > range.upper) return;
	auto iterator = set.upper_bound (range.lower);
	auto lower = range.lower, upper = range.upper;

	if (iterator != set.begin ()) if (lower <= increment ((--iterator)->upper))
		lower = iterator->lower, iterator = set.erase (iterator); else ++iterator;

	while (iterator != set.end () && iterator->upper <= upper)
		iterator = set.erase (iterator);

	if (iterator != set.end () && iterator->lower <= increment (upper))
		upper = iterator->upper, iterator = set.erase (iterator);

	set.emplace_hint (iterator, lower, upper);
}

template <typename Value>
bool ECS::RangeSet<Value>::operator [] (const Range<Value>& range) const
{
	auto iterator = set.upper_bound (range.lower);
	return iterator != set.end () && iterator->lower <= range.upper || iterator != set.begin () && (--iterator)->upper >= range.lower;
}

#endif // ECS_RANGESET_HEADER_INCLUDED

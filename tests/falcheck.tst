# FALSE compilation test and validation suite
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

positive: empty program

positive: empty comment

	{}

negative: comment missing closing brace

	{

negative: comment missing opening brace

	}

positive: single-line comment

	{this comment spans one line}

positive: multiple-line comment

	{this comment spans
	several lines}

negative: nestedcomment

	{{}}

positive: variable names

	abcdefghijklmnopqrstuvwxyz

negative: invalid variable name

	A

positive: integer values

	0 1 2 3 4 5 6 7 8 9
	10 100 1000 10000 100000 200000 300000 320000

negative: invalid integer value

	320001

positive: character values

	'a 'z 'A 'Z '. '; '_ '+

negative: invalid character value

	'

negative: invalid byte value

	256`

positive: empty string

	""

positive: string

	"string"

negative: string missing closing quote

	"string

negative: string missing opening quote

	string"

negative: empty external variable

	""V

positive: external variable

	"variable"V

negative: empty external function

	""F

positive: external function

	"function"F

positive: empty assembly

	""`

positive: assign operation

	:

positive: dereference operation

	;

positive: call operation

	!

positive: add operation

	+

positive: subtract operation

	-

positive: multiply operation

	*

positive: divide operation

	/

positive: negate operation

	_

positive: equal operation

	=

positive: greater operation

	>

positive: and operation

	&

positive: or operation

	|

positive: not operation

	~

positive: duplicate operation

	$

positive: delete operation

	%

positive: swap operation

	\

positive: rotate operation

	@

positive: select operation

	ø

positive: if operation

	?

positive: while operation

	#

positive: print operation

	.

positive: put operation

	,

positive: get operation

	^

positive: flush operation

	ß

positive: examples

	{comment}
	[1+]
	a
	1
	'A
	1a:
	a;
	f;!
	1 2+
	1 2-
	1 2*
	1 2/
	1_
	1 2=~
	1 2>
	1 2&
	1 2|
	0~
	1$
	1%
	1 2\
	1 2 3@
	1 2 1ø
	a;2=[1f;!]?
	{ if a=2 then f(1) }
	1[$100>][1+]#
	1.
	"hi!"
	10,
	^
	ß

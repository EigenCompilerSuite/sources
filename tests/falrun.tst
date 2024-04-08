# FALSE execution test and validation suite
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

positive: success termination

	0

negative: failure termination

	1

positive: assign operation

	1a:a;1=~

positive: dereference operation

	ab:b;a=~

positive: call operation

	[1]!~

positive: add operation

	6 2+8=~

positive: subtract operation

	6 2-4=~

positive: multiply operation

	6 2*12=~

positive: divide operation

	6 2/3=~

positive: negate operation

	5_5+0=~

positive: equal operation

	aa=~

positive: greater operation

	6 4>~

positive: and operation

	0 0&~[0 1&~[1 0&~[1 1&]?]?]?~

positive: or operation

	0 0|~[0 1|[1 0|[1 1|]?]?]?~

positive: not operation

	~~

positive: duplicate operation

	a$=~

positive: delete operation

	a5%a=~

positive: swap operation

	a0\a=[0=]?~

positive: rotate operation

	a0b@a=[b=[0=]?]?~

positive: select operation

	a5b0øb=[1ø5=[2øa=[b=[5=[a=]?]?]?]?]?~

positive: if operation

	1[~]?~

positive: while operation

	0 8[$0>][1-\1+\]#0=[8=]?~

positive: print operation

	"test"

positive: flush operation

	ß

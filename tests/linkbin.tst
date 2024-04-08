# Object file linker test and validation suite
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

negative: missing entry point

# standard code sections

positive: standard code section as entry point

	code 1 "main" aligned 1

positive: required standard code section as entry point

	code 1 required "main" aligned 1

positive: duplicable standard code section as entry point

	code 1 duplicable "main" aligned 1

positive: replaceable standard code section as entry point

	code 1 replaceable "main" aligned 1

positive: standard code section

	code 1 "main" aligned 1
	code 1 "test" aligned 1

positive: standard code sections

	code 1 "main" aligned 1
	code 1 "test1" aligned 1
	code 1 "test2" aligned 1

negative: duplicated standard code section

	code 1 "main" aligned 1
	code 1 "test" aligned 1
	code 1 "test" aligned 1

positive: required standard code section

	code 1 "main" aligned 1
	code 1 required "test" aligned 1

positive: required standard code sections

	code 1 "main" aligned 1
	code 1 required "test1" aligned 1
	code 1 required "test2" aligned 1

negative: duplicated required standard code section

	code 1 "main" aligned 1
	code 1 required "test" aligned 1
	code 1 required "test" aligned 1

positive: duplicable standard code section

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1

positive: duplicable standard code sections

	code 1 "main" aligned 1
	code 1 duplicable "test1" aligned 1
	code 1 duplicable "test2" aligned 1

positive: duplicated duplicable standard code section

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1
	code 1 duplicable "test" aligned 1

negative: duplicated duplicable standard code section with different entity

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1
	code 1 "test" aligned 1

negative: duplicated duplicable standard code section with different size

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1
	code 2 duplicable "test" aligned 1

negative: duplicated duplicable standard code section with different group

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1
	code 1 duplicable "test" "group" aligned 1

negative: duplicated duplicable standard code section with different alignment

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1
	code 1 duplicable "test" aligned 2

negative: duplicated duplicable standard code section with different origin

	code 1 "main" aligned 1
	code 1 duplicable "test" fixed 0
	code 1 duplicable "test" fixed 1

positive: duplicated duplicable standard code section with same links

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 "test"
	code 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable standard code section with different links

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1
	code 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable standard code section with link with different name

	code 1 "main" aligned 1
	code 1 duplicable "test1" aligned 1 "test1"
	code 1 duplicable "test1" aligned 1 "test2"
	code 1 "test2" aligned 1

positive: duplicated duplicable standard code section with same link patches

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable standard code section with different link patches

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 "test"
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable standard code section with link patch with different offset

	code 1 "main" aligned 1
	code 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	code 2 duplicable "test" aligned 1 "test" 1 abs 0 0 0ff

negative: duplicated duplicable standard code section with link patch with different mode

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	code 1 duplicable "test" aligned 1 "test" 0 rel 0 0 0ff

negative: duplicated duplicable standard code section with link patch with different displacement

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	code 1 duplicable "test" aligned 1 "test" 0 abs 1 0 0ff

negative: duplicated duplicable standard code section with link patch with different scale

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 1 0ff

negative: duplicated duplicable standard code section with link patch with different patterns

	code 1 "main" aligned 1
	code 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	code 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff1ff

negative: duplicated duplicable standard code section with link patch with different pattern offset

	code 1 "main" aligned 1
	code 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	code 2 duplicable "test" aligned 1 "test" 0 abs 0 0 1ff

negative: duplicated duplicable standard code section with link patch with different pattern mask

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	code 1 duplicable "test" aligned 1 "test" 0 abs 0 0 000

positive: duplicated duplicable standard code section with same data

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 0 00
	code 1 duplicable "test" aligned 1 0 00

negative: duplicated duplicable standard code section with different data

	code 1 "main" aligned 1
	code 1 duplicable "test" aligned 1 0 00
	code 1 duplicable "test" aligned 1 0 ff

positive: replaceable standard code section

	code 1 "main" aligned 1
	code 1 replaceable "test" aligned 1

positive: replaceable standard code sections

	code 1 "main" aligned 1
	code 1 replaceable "test1" aligned 1
	code 1 replaceable "test2" aligned 1

negative: duplicated replaceable standard code section

	code 1 "main" aligned 1
	code 1 replaceable "test" aligned 1
	code 1 replaceable "test" aligned 1

positive: replaceable standard code section replaced by section

	code 1 "main" aligned 1
	code 1 replaceable "test" aligned 1
	code 1 "test" aligned 1

positive: replaceable standard code section replaced by required section

	code 1 "main" aligned 1
	code 1 replaceable "test" aligned 1
	code 1 required "test" aligned 1

positive: replaceable standard code section replaced by duplicable section

	code 1 "main" aligned 1
	code 1 replaceable "test" aligned 1
	code 1 duplicable "test" aligned 1

negative: replaceable standard code section replaced by replaceable section

	code 1 "main" aligned 1
	code 1 replaceable "test" aligned 1
	code 1 replaceable "test" aligned 1

positive: fixed standard code sections

	code 1 "main" aligned 1
	code 1 required "test1" fixed 0
	code 1 required "test2" fixed 1

negative: overlapping fixed standard code sections

	code 1 "main" aligned 1
	code 1 required "test1" fixed 0
	code 1 required "test2" fixed 0

positive: standard code section with resolved section

	code 1 "main" aligned 1
	code 1 required "test" aligned 1 "test"

positive: standard code section with resolved empty section

	code 1 "main" aligned 1
	code 1 required "test" aligned 1 "test"

negative: standard code section with unresolved section

	code 1 "main" aligned 1
	code 1 required "test" aligned 1 "data"

negative: standard code section with conditionally resolved section

	code 1 "main" aligned 1
	code 1 required "test" aligned 1 "test?data"

positive: standard code section with conditionally unresolved section

	code 1 "main" aligned 1
	code 1 required "test" aligned 1 "data?data"

# initializing code sections

negative: initializing code section as entry point

	initcode 1 "main" aligned 1

positive: initializing code section

	code 1 "main" aligned 1
	initcode 1 "test" aligned 1

positive: initializing code sections

	code 1 "main" aligned 1
	initcode 1 "test1" aligned 1
	initcode 1 "test2" aligned 1

negative: duplicated initializing code section

	code 1 "main" aligned 1
	initcode 1 "test" aligned 1
	initcode 1 "test" aligned 1

positive: required initializing code section

	code 1 "main" aligned 1
	initcode 1 required "test" aligned 1

positive: required initializing code sections

	code 1 "main" aligned 1
	initcode 1 required "test1" aligned 1
	initcode 1 required "test2" aligned 1

negative: duplicated required initializing code section

	code 1 "main" aligned 1
	initcode 1 required "test" aligned 1
	initcode 1 required "test" aligned 1

positive: duplicable initializing code section

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1

positive: duplicable initializing code sections

	code 1 "main" aligned 1
	initcode 1 duplicable "test1" aligned 1
	initcode 1 duplicable "test2" aligned 1

positive: duplicated duplicable initializing code section

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1
	initcode 1 duplicable "test" aligned 1

negative: duplicated duplicable initializing code section with different entity

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1
	initcode 1 "test" aligned 1

negative: duplicated duplicable initializing code section with different size

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1
	initcode 2 duplicable "test" aligned 1

negative: duplicated duplicable initializing code section with different group

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1
	initcode 1 duplicable "test" "group" aligned 1

negative: duplicated duplicable initializing code section with different alignment

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1
	initcode 1 duplicable "test" aligned 2

negative: duplicated duplicable initializing code section with different origin

	code 1 "main" aligned 1
	initcode 1 duplicable "test" fixed 0
	initcode 1 duplicable "test" fixed 1

positive: duplicated duplicable initializing code section with same links

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 "test"
	initcode 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable initializing code section with different links

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1
	initcode 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable initializing code section with link with different name

	code 1 "main" aligned 1
	initcode 1 duplicable "test1" aligned 1 "test1"
	initcode 1 duplicable "test1" aligned 1 "test2"
	initcode 1 "test2" aligned 1

positive: duplicated duplicable initializing code section with same link patches

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable initializing code section with different link patches

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 "test"
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable initializing code section with link patch with different offset

	code 1 "main" aligned 1
	initcode 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initcode 2 duplicable "test" aligned 1 "test" 1 abs 0 0 0ff

negative: duplicated duplicable initializing code section with link patch with different mode

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initcode 1 duplicable "test" aligned 1 "test" 0 rel 0 0 0ff

negative: duplicated duplicable initializing code section with link patch with different displacement

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 1 0 0ff

negative: duplicated duplicable initializing code section with link patch with different scale

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 1 0ff

negative: duplicated duplicable initializing code section with link patch with different patterns

	code 1 "main" aligned 1
	initcode 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initcode 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff1ff

negative: duplicated duplicable initializing code section with link patch with different pattern offset

	code 1 "main" aligned 1
	initcode 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initcode 2 duplicable "test" aligned 1 "test" 0 abs 0 0 1ff

negative: duplicated duplicable initializing code section with link patch with different pattern mask

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initcode 1 duplicable "test" aligned 1 "test" 0 abs 0 0 000

positive: duplicated duplicable initializing code section with same data

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 0 00
	initcode 1 duplicable "test" aligned 1 0 00

negative: duplicated duplicable initializing code section with different data

	code 1 "main" aligned 1
	initcode 1 duplicable "test" aligned 1 0 00
	initcode 1 duplicable "test" aligned 1 0 ff

positive: replaceable initializing code section

	code 1 "main" aligned 1
	initcode 1 replaceable "test" aligned 1

positive: replaceable initializing code sections

	code 1 "main" aligned 1
	initcode 1 replaceable "test1" aligned 1
	initcode 1 replaceable "test2" aligned 1

negative: duplicated replaceable initializing code section

	code 1 "main" aligned 1
	initcode 1 replaceable "test" aligned 1
	initcode 1 replaceable "test" aligned 1

positive: replaceable initializing code section replaced by section

	code 1 "main" aligned 1
	initcode 1 replaceable "test" aligned 1
	initcode 1 "test" aligned 1

positive: replaceable initializing code section replaced by required section

	code 1 "main" aligned 1
	initcode 1 replaceable "test" aligned 1
	initcode 1 required "test" aligned 1

positive: replaceable initializing code section replaced by duplicable section

	code 1 "main" aligned 1
	initcode 1 replaceable "test" aligned 1
	initcode 1 duplicable "test" aligned 1

negative: replaceable initializing code section replaced by replaceable section

	code 1 "main" aligned 1
	initcode 1 replaceable "test" aligned 1
	initcode 1 replaceable "test" aligned 1

positive: fixed initializing code sections

	code 1 "main" aligned 1
	initcode 1 required "test1" fixed 0
	initcode 1 required "test2" fixed 1

negative: overlapping fixed initializing code sections

	code 1 "main" aligned 1
	initcode 1 required "test1" fixed 0
	initcode 1 required "test2" fixed 0

positive: initializing code section with resolved section

	code 1 "main" aligned 1
	initcode 1 required "test" aligned 1 "test"

positive: initializing code section with resolved empty section

	code 1 "main" aligned 1
	initcode 1 required "test" aligned 1 "test"

negative: initializing code section with unresolved section

	code 1 "main" aligned 1
	initcode 1 required "test" aligned 1 "data"

negative: initializing code section with conditionally resolved section

	code 1 "main" aligned 1
	initcode 1 required "test" aligned 1 "test?data"

positive: initializing code section with conditionally unresolved section

	code 1 "main" aligned 1
	initcode 1 required "test" aligned 1 "data?data"

# data initializing code sections

negative: data initializing code section as entry point

	initdata 1 "main" aligned 1

positive: data initializing code section

	code 1 "main" aligned 1
	initdata 1 "test" aligned 1

positive: data initializing code sections

	code 1 "main" aligned 1
	initdata 1 "test1" aligned 1
	initdata 1 "test2" aligned 1

negative: duplicated data initializing code section

	code 1 "main" aligned 1
	initdata 1 "test" aligned 1
	initdata 1 "test" aligned 1

positive: required data initializing code section

	code 1 "main" aligned 1
	initdata 1 required "test" aligned 1

positive: required data initializing code sections

	code 1 "main" aligned 1
	initdata 1 required "test1" aligned 1
	initdata 1 required "test2" aligned 1

negative: duplicated required data initializing code section

	code 1 "main" aligned 1
	initdata 1 required "test" aligned 1
	initdata 1 required "test" aligned 1

positive: duplicable data initializing code section

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1

positive: duplicable data initializing code sections

	code 1 "main" aligned 1
	initdata 1 duplicable "test1" aligned 1
	initdata 1 duplicable "test2" aligned 1

positive: duplicated duplicable data initializing code section

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1
	initdata 1 duplicable "test" aligned 1

negative: duplicated duplicable data initializing code section with different entity

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1
	initdata 1 "test" aligned 1

negative: duplicated duplicable data initializing code section with different size

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1
	initdata 2 duplicable "test" aligned 1

negative: duplicated duplicable data initializing code section with different group

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1
	initdata 1 duplicable "test" "group" aligned 1

negative: duplicated duplicable data initializing code section with different alignment

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1
	initdata 1 duplicable "test" aligned 2

negative: duplicated duplicable data initializing code section with different origin

	code 1 "main" aligned 1
	initdata 1 duplicable "test" fixed 0
	initdata 1 duplicable "test" fixed 1

positive: duplicated duplicable data initializing code section with same links

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 "test"
	initdata 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable data initializing code section with different links

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1
	initdata 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable data initializing code section with link with different name

	code 1 "main" aligned 1
	initdata 1 duplicable "test1" aligned 1 "test1"
	initdata 1 duplicable "test1" aligned 1 "test2"
	initdata 1 "test2" aligned 1

positive: duplicated duplicable data initializing code section with same link patches

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable data initializing code section with different link patches

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 "test"
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable data initializing code section with link patch with different offset

	code 1 "main" aligned 1
	initdata 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initdata 2 duplicable "test" aligned 1 "test" 1 abs 0 0 0ff

negative: duplicated duplicable data initializing code section with link patch with different mode

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initdata 1 duplicable "test" aligned 1 "test" 0 rel 0 0 0ff

negative: duplicated duplicable data initializing code section with link patch with different displacement

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 1 0 0ff

negative: duplicated duplicable data initializing code section with link patch with different scale

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 1 0ff

negative: duplicated duplicable data initializing code section with link patch with different patterns

	code 1 "main" aligned 1
	initdata 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initdata 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff1ff

negative: duplicated duplicable data initializing code section with link patch with different pattern offset

	code 1 "main" aligned 1
	initdata 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initdata 2 duplicable "test" aligned 1 "test" 0 abs 0 0 1ff

negative: duplicated duplicable data initializing code section with link patch with different pattern mask

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	initdata 1 duplicable "test" aligned 1 "test" 0 abs 0 0 000

positive: duplicated duplicable data initializing code section with same data

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 0 00
	initdata 1 duplicable "test" aligned 1 0 00

negative: duplicated duplicable data initializing code section with different data

	code 1 "main" aligned 1
	initdata 1 duplicable "test" aligned 1 0 00
	initdata 1 duplicable "test" aligned 1 0 ff

positive: replaceable data initializing code section

	code 1 "main" aligned 1
	initdata 1 replaceable "test" aligned 1

positive: replaceable data initializing code sections

	code 1 "main" aligned 1
	initdata 1 replaceable "test1" aligned 1
	initdata 1 replaceable "test2" aligned 1

negative: duplicated replaceable data initializing code section

	code 1 "main" aligned 1
	initdata 1 replaceable "test" aligned 1
	initdata 1 replaceable "test" aligned 1

positive: replaceable data initializing code section replaced by section

	code 1 "main" aligned 1
	initdata 1 replaceable "test" aligned 1
	initdata 1 "test" aligned 1

positive: replaceable data initializing code section replaced by required section

	code 1 "main" aligned 1
	initdata 1 replaceable "test" aligned 1
	initdata 1 required "test" aligned 1

positive: replaceable data initializing code section replaced by duplicable section

	code 1 "main" aligned 1
	initdata 1 replaceable "test" aligned 1
	initdata 1 duplicable "test" aligned 1

negative: replaceable data initializing code section replaced by replaceable section

	code 1 "main" aligned 1
	initdata 1 replaceable "test" aligned 1
	initdata 1 replaceable "test" aligned 1

positive: fixed data initializing code sections

	code 1 "main" aligned 1
	initdata 1 required "test1" fixed 0
	initdata 1 required "test2" fixed 1

negative: overlapping fixed data initializing code sections

	code 1 "main" aligned 1
	initdata 1 required "test1" fixed 0
	initdata 1 required "test2" fixed 0

positive: data initializing code section with resolved section

	code 1 "main" aligned 1
	initdata 1 required "test" aligned 1 "test"

positive: data initializing code section with resolved empty section

	code 1 "main" aligned 1
	initdata 1 required "test" aligned 1 "test"

negative: data initializing code section with unresolved section

	code 1 "main" aligned 1
	initdata 1 required "test" aligned 1 "data"

negative: data initializing code section with conditionally resolved section

	code 1 "main" aligned 1
	initdata 1 required "test" aligned 1 "test?data"

positive: data initializing code section with conditionally unresolved section

	code 1 "main" aligned 1
	initdata 1 required "test" aligned 1 "data?data"

# standard data sections

negative: standard data section as entry point

	data 1 "main" aligned 1

positive: standard data section

	code 1 "main" aligned 1
	data 1 "test" aligned 1

positive: standard data sections

	code 1 "main" aligned 1
	data 1 "test1" aligned 1
	data 1 "test2" aligned 1

negative: duplicated standard data section

	code 1 "main" aligned 1
	data 1 "test" aligned 1
	data 1 "test" aligned 1

positive: required standard data section

	code 1 "main" aligned 1
	data 1 required "test" aligned 1

positive: required standard data sections

	code 1 "main" aligned 1
	data 1 required "test1" aligned 1
	data 1 required "test2" aligned 1

negative: duplicated required standard data section

	code 1 "main" aligned 1
	data 1 required "test" aligned 1
	data 1 required "test" aligned 1

positive: duplicable standard data section

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1

positive: duplicable standard data sections

	code 1 "main" aligned 1
	data 1 duplicable "test1" aligned 1
	data 1 duplicable "test2" aligned 1

positive: duplicated duplicable standard data section

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1
	data 1 duplicable "test" aligned 1

negative: duplicated duplicable standard data section with different entity

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1
	data 1 "test" aligned 1

negative: duplicated duplicable standard data section with different size

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1
	data 2 duplicable "test" aligned 1

negative: duplicated duplicable standard data section with different group

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1
	data 1 duplicable "test" "group" aligned 1

negative: duplicated duplicable standard data section with different alignment

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1
	data 1 duplicable "test" aligned 2

negative: duplicated duplicable standard data section with different origin

	code 1 "main" aligned 1
	data 1 duplicable "test" fixed 0
	data 1 duplicable "test" fixed 1

positive: duplicated duplicable standard data section with same links

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 "test"
	data 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable standard data section with different links

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1
	data 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable standard data section with link with different name

	code 1 "main" aligned 1
	data 1 duplicable "test1" aligned 1 "test1"
	data 1 duplicable "test1" aligned 1 "test2"
	data 1 "test2" aligned 1

positive: duplicated duplicable standard data section with same link patches

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable standard data section with different link patches

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 "test"
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable standard data section with link patch with different offset

	code 1 "main" aligned 1
	data 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	data 2 duplicable "test" aligned 1 "test" 1 abs 0 0 0ff

negative: duplicated duplicable standard data section with link patch with different mode

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	data 1 duplicable "test" aligned 1 "test" 0 rel 0 0 0ff

negative: duplicated duplicable standard data section with link patch with different displacement

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	data 1 duplicable "test" aligned 1 "test" 0 abs 1 0 0ff

negative: duplicated duplicable standard data section with link patch with different scale

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 1 0ff

negative: duplicated duplicable standard data section with link patch with different patterns

	code 1 "main" aligned 1
	data 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	data 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff1ff

negative: duplicated duplicable standard data section with link patch with different pattern offset

	code 1 "main" aligned 1
	data 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	data 2 duplicable "test" aligned 1 "test" 0 abs 0 0 1ff

negative: duplicated duplicable standard data section with link patch with different pattern mask

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	data 1 duplicable "test" aligned 1 "test" 0 abs 0 0 000

positive: duplicated duplicable standard data section with same data

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 0 00
	data 1 duplicable "test" aligned 1 0 00

negative: duplicated duplicable standard data section with different data

	code 1 "main" aligned 1
	data 1 duplicable "test" aligned 1 0 00
	data 1 duplicable "test" aligned 1 0 ff

positive: replaceable standard data section

	code 1 "main" aligned 1
	data 1 replaceable "test" aligned 1

positive: replaceable standard data sections

	code 1 "main" aligned 1
	data 1 replaceable "test1" aligned 1
	data 1 replaceable "test2" aligned 1

negative: duplicated replaceable standard data section

	code 1 "main" aligned 1
	data 1 replaceable "test" aligned 1
	data 1 replaceable "test" aligned 1

positive: replaceable standard data section replaced by section

	code 1 "main" aligned 1
	data 1 replaceable "test" aligned 1
	data 1 "test" aligned 1

positive: replaceable standard data section replaced by required section

	code 1 "main" aligned 1
	data 1 replaceable "test" aligned 1
	data 1 required "test" aligned 1

positive: replaceable standard data section replaced by duplicable section

	code 1 "main" aligned 1
	data 1 replaceable "test" aligned 1
	data 1 duplicable "test" aligned 1

negative: replaceable standard data section replaced by replaceable section

	code 1 "main" aligned 1
	data 1 replaceable "test" aligned 1
	data 1 replaceable "test" aligned 1

positive: fixed standard data sections

	code 1 "main" aligned 1
	data 1 required "test1" fixed 0
	data 1 required "test2" fixed 1

negative: overlapping fixed standard data sections

	code 1 "main" aligned 1
	data 1 required "test1" fixed 0
	data 1 required "test2" fixed 0

positive: standard data section with resolved section

	code 1 "main" aligned 1
	data 1 required "test" aligned 1 "test"

positive: standard data section with resolved empty section

	code 1 "main" aligned 1
	data 1 required "test" aligned 1 "test"

negative: standard data section with unresolved section

	code 1 "main" aligned 1
	data 1 required "test" aligned 1 "data"

negative: standard data section with conditionally resolved section

	code 1 "main" aligned 1
	data 1 required "test" aligned 1 "test?data"

positive: standard data section with conditionally unresolved section

	code 1 "main" aligned 1
	data 1 required "test" aligned 1 "data?data"

# constant data sections

negative: constant data section as entry point

	const 1 "main" aligned 1

positive: constant data section

	code 1 "main" aligned 1
	const 1 "test" aligned 1

positive: constant data sections

	code 1 "main" aligned 1
	const 1 "test1" aligned 1
	const 1 "test2" aligned 1

negative: duplicated constant data section

	code 1 "main" aligned 1
	const 1 "test" aligned 1
	const 1 "test" aligned 1

positive: required constant data section

	code 1 "main" aligned 1
	const 1 required "test" aligned 1

positive: required constant data sections

	code 1 "main" aligned 1
	const 1 required "test1" aligned 1
	const 1 required "test2" aligned 1

negative: duplicated required constant data section

	code 1 "main" aligned 1
	const 1 required "test" aligned 1
	const 1 required "test" aligned 1

positive: duplicable constant data section

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1

positive: duplicable constant data sections

	code 1 "main" aligned 1
	const 1 duplicable "test1" aligned 1
	const 1 duplicable "test2" aligned 1

positive: duplicated duplicable constant data section

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1
	const 1 duplicable "test" aligned 1

negative: duplicated duplicable constant data section with different entity

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1
	const 1 "test" aligned 1

negative: duplicated duplicable constant data section with different size

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1
	const 2 duplicable "test" aligned 1

negative: duplicated duplicable constant data section with different group

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1
	const 1 duplicable "test" "group" aligned 1

negative: duplicated duplicable constant data section with different alignment

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1
	const 1 duplicable "test" aligned 2

negative: duplicated duplicable constant data section with different origin

	code 1 "main" aligned 1
	const 1 duplicable "test" fixed 0
	const 1 duplicable "test" fixed 1

positive: duplicated duplicable constant data section with same links

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 "test"
	const 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable constant data section with different links

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1
	const 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable constant data section with link with different name

	code 1 "main" aligned 1
	const 1 duplicable "test1" aligned 1 "test1"
	const 1 duplicable "test1" aligned 1 "test2"
	const 1 "test2" aligned 1

positive: duplicated duplicable constant data section with same link patches

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable constant data section with different link patches

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 "test"
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable constant data section with link patch with different offset

	code 1 "main" aligned 1
	const 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	const 2 duplicable "test" aligned 1 "test" 1 abs 0 0 0ff

negative: duplicated duplicable constant data section with link patch with different mode

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	const 1 duplicable "test" aligned 1 "test" 0 rel 0 0 0ff

negative: duplicated duplicable constant data section with link patch with different displacement

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	const 1 duplicable "test" aligned 1 "test" 0 abs 1 0 0ff

negative: duplicated duplicable constant data section with link patch with different scale

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 1 0ff

negative: duplicated duplicable constant data section with link patch with different patterns

	code 1 "main" aligned 1
	const 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	const 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff1ff

negative: duplicated duplicable constant data section with link patch with different pattern offset

	code 1 "main" aligned 1
	const 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	const 2 duplicable "test" aligned 1 "test" 0 abs 0 0 1ff

negative: duplicated duplicable constant data section with link patch with different pattern mask

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	const 1 duplicable "test" aligned 1 "test" 0 abs 0 0 000

positive: duplicated duplicable constant data section with same data

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 0 00
	const 1 duplicable "test" aligned 1 0 00

negative: duplicated duplicable constant data section with different data

	code 1 "main" aligned 1
	const 1 duplicable "test" aligned 1 0 00
	const 1 duplicable "test" aligned 1 0 ff

positive: replaceable constant data section

	code 1 "main" aligned 1
	const 1 replaceable "test" aligned 1

positive: replaceable constant data sections

	code 1 "main" aligned 1
	const 1 replaceable "test1" aligned 1
	const 1 replaceable "test2" aligned 1

negative: duplicated replaceable constant data section

	code 1 "main" aligned 1
	const 1 replaceable "test" aligned 1
	const 1 replaceable "test" aligned 1

positive: replaceable constant data section replaced by section

	code 1 "main" aligned 1
	const 1 replaceable "test" aligned 1
	const 1 "test" aligned 1

positive: replaceable constant data section replaced by required section

	code 1 "main" aligned 1
	const 1 replaceable "test" aligned 1
	const 1 required "test" aligned 1

positive: replaceable constant data section replaced by duplicable section

	code 1 "main" aligned 1
	const 1 replaceable "test" aligned 1
	const 1 duplicable "test" aligned 1

negative: replaceable constant data section replaced by replaceable section

	code 1 "main" aligned 1
	const 1 replaceable "test" aligned 1
	const 1 replaceable "test" aligned 1

positive: fixed constant data sections

	code 1 "main" aligned 1
	const 1 required "test1" fixed 0
	const 1 required "test2" fixed 1

negative: overlapping fixed constant data sections

	code 1 "main" aligned 1
	const 1 required "test1" fixed 0
	const 1 required "test2" fixed 0

positive: constant data section with resolved section

	code 1 "main" aligned 1
	const 1 required "test" aligned 1 "test"

positive: constant data section with resolved empty section

	code 1 "main" aligned 1
	const 1 required "test" aligned 1 "test"

negative: constant data section with unresolved section

	code 1 "main" aligned 1
	const 1 required "test" aligned 1 "data"

negative: constant data section with conditionally resolved section

	code 1 "main" aligned 1
	const 1 required "test" aligned 1 "test?data"

positive: constant data section with conditionally unresolved section

	code 1 "main" aligned 1
	const 1 required "test" aligned 1 "data?data"

# heading metadata sections

negative: heading metadata section as entry point

	header 1 "main" aligned 1

positive: heading metadata section

	code 1 "main" aligned 1
	header 1 "test" aligned 1

positive: heading metadata sections

	code 1 "main" aligned 1
	header 1 "test1" aligned 1
	header 1 "test2" aligned 1

negative: duplicated heading metadata section

	code 1 "main" aligned 1
	header 1 "test" aligned 1
	header 1 "test" aligned 1

positive: required heading metadata section

	code 1 "main" aligned 1
	header 1 required "test" aligned 1

positive: required heading metadata sections

	code 1 "main" aligned 1
	header 1 required "test1" aligned 1
	header 1 required "test2" aligned 1

negative: duplicated required heading metadata section

	code 1 "main" aligned 1
	header 1 required "test" aligned 1
	header 1 required "test" aligned 1

positive: duplicable heading metadata section

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1

positive: duplicable heading metadata sections

	code 1 "main" aligned 1
	header 1 duplicable "test1" aligned 1
	header 1 duplicable "test2" aligned 1

positive: duplicated duplicable heading metadata section

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1
	header 1 duplicable "test" aligned 1

negative: duplicated duplicable heading metadata section with different entity

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1
	header 1 "test" aligned 1

negative: duplicated duplicable heading metadata section with different size

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1
	header 2 duplicable "test" aligned 1

negative: duplicated duplicable heading metadata section with different group

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1
	header 1 duplicable "test" "group" aligned 1

negative: duplicated duplicable heading metadata section with different alignment

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1
	header 1 duplicable "test" aligned 2

negative: duplicated duplicable heading metadata section with different origin

	code 1 "main" aligned 1
	header 1 duplicable "test" fixed 0
	header 1 duplicable "test" fixed 1

positive: duplicated duplicable heading metadata section with same links

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 "test"
	header 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable heading metadata section with different links

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1
	header 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable heading metadata section with link with different name

	code 1 "main" aligned 1
	header 1 duplicable "test1" aligned 1 "test1"
	header 1 duplicable "test1" aligned 1 "test2"
	header 1 "test2" aligned 1

positive: duplicated duplicable heading metadata section with same link patches

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable heading metadata section with different link patches

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 "test"
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable heading metadata section with link patch with different offset

	code 1 "main" aligned 1
	header 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	header 2 duplicable "test" aligned 1 "test" 1 abs 0 0 0ff

negative: duplicated duplicable heading metadata section with link patch with different mode

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	header 1 duplicable "test" aligned 1 "test" 0 rel 0 0 0ff

negative: duplicated duplicable heading metadata section with link patch with different displacement

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	header 1 duplicable "test" aligned 1 "test" 0 abs 1 0 0ff

negative: duplicated duplicable heading metadata section with link patch with different scale

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 1 0ff

negative: duplicated duplicable heading metadata section with link patch with different patterns

	code 1 "main" aligned 1
	header 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	header 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff1ff

negative: duplicated duplicable heading metadata section with link patch with different pattern offset

	code 1 "main" aligned 1
	header 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	header 2 duplicable "test" aligned 1 "test" 0 abs 0 0 1ff

negative: duplicated duplicable heading metadata section with link patch with different pattern mask

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	header 1 duplicable "test" aligned 1 "test" 0 abs 0 0 000

positive: duplicated duplicable heading metadata section with same data

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 0 00
	header 1 duplicable "test" aligned 1 0 00

negative: duplicated duplicable heading metadata section with different data

	code 1 "main" aligned 1
	header 1 duplicable "test" aligned 1 0 00
	header 1 duplicable "test" aligned 1 0 ff

positive: replaceable heading metadata section

	code 1 "main" aligned 1
	header 1 replaceable "test" aligned 1

positive: replaceable heading metadata sections

	code 1 "main" aligned 1
	header 1 replaceable "test1" aligned 1
	header 1 replaceable "test2" aligned 1

negative: duplicated replaceable heading metadata section

	code 1 "main" aligned 1
	header 1 replaceable "test" aligned 1
	header 1 replaceable "test" aligned 1

positive: replaceable heading metadata section replaced by section

	code 1 "main" aligned 1
	header 1 replaceable "test" aligned 1
	header 1 "test" aligned 1

positive: replaceable heading metadata section replaced by required section

	code 1 "main" aligned 1
	header 1 replaceable "test" aligned 1
	header 1 required "test" aligned 1

positive: replaceable heading metadata section replaced by duplicable section

	code 1 "main" aligned 1
	header 1 replaceable "test" aligned 1
	header 1 duplicable "test" aligned 1

negative: replaceable heading metadata section replaced by replaceable section

	code 1 "main" aligned 1
	header 1 replaceable "test" aligned 1
	header 1 replaceable "test" aligned 1

positive: fixed heading metadata sections

	code 1 "main" aligned 1
	header 1 required "test1" fixed 0
	header 1 required "test2" fixed 1

negative: overlapping fixed heading metadata sections

	code 1 "main" aligned 1
	header 1 required "test1" fixed 0
	header 1 required "test2" fixed 0

positive: heading metadata section with resolved section

	code 1 "main" aligned 1
	header 1 required "test" aligned 1 "test"

positive: heading metadata section with resolved empty section

	code 1 "main" aligned 1
	header 1 required "test" aligned 1 "test"

negative: heading metadata section with unresolved section

	code 1 "main" aligned 1
	header 1 required "test" aligned 1 "data"

negative: heading metadata section with conditionally resolved section

	code 1 "main" aligned 1
	header 1 required "test" aligned 1 "test?data"

positive: heading metadata section with conditionally unresolved section

	code 1 "main" aligned 1
	header 1 required "test" aligned 1 "data?data"

# trailing metadata sections

negative: trailing metadata section as entry point

	trailer 1 "main" aligned 1

positive: trailing metadata section

	code 1 "main" aligned 1
	trailer 1 "test" aligned 1

positive: trailing metadata sections

	code 1 "main" aligned 1
	trailer 1 "test1" aligned 1
	trailer 1 "test2" aligned 1

negative: duplicated trailing metadata section

	code 1 "main" aligned 1
	trailer 1 "test" aligned 1
	trailer 1 "test" aligned 1

positive: required trailing metadata section

	code 1 "main" aligned 1
	trailer 1 required "test" aligned 1

positive: required trailing metadata sections

	code 1 "main" aligned 1
	trailer 1 required "test1" aligned 1
	trailer 1 required "test2" aligned 1

negative: duplicated required trailing metadata section

	code 1 "main" aligned 1
	trailer 1 required "test" aligned 1
	trailer 1 required "test" aligned 1

positive: duplicable trailing metadata section

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1

positive: duplicable trailing metadata sections

	code 1 "main" aligned 1
	trailer 1 duplicable "test1" aligned 1
	trailer 1 duplicable "test2" aligned 1

positive: duplicated duplicable trailing metadata section

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1
	trailer 1 duplicable "test" aligned 1

negative: duplicated duplicable trailing metadata section with different entity

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1
	trailer 1 "test" aligned 1

negative: duplicated duplicable trailing metadata section with different size

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1
	trailer 2 duplicable "test" aligned 1

negative: duplicated duplicable trailing metadata section with different group

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1
	trailer 1 duplicable "test" "group" aligned 1

negative: duplicated duplicable trailing metadata section with different alignment

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1
	trailer 1 duplicable "test" aligned 2

negative: duplicated duplicable trailing metadata section with different origin

	code 1 "main" aligned 1
	trailer 1 duplicable "test" fixed 0
	trailer 1 duplicable "test" fixed 1

positive: duplicated duplicable trailing metadata section with same links

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 "test"
	trailer 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable trailing metadata section with different links

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1
	trailer 1 duplicable "test" aligned 1 "test"

negative: duplicated duplicable trailing metadata section with link with different name

	code 1 "main" aligned 1
	trailer 1 duplicable "test1" aligned 1 "test1"
	trailer 1 duplicable "test1" aligned 1 "test2"
	trailer 1 "test2" aligned 1

positive: duplicated duplicable trailing metadata section with same link patches

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable trailing metadata section with different link patches

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 "test"
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff

negative: duplicated duplicable trailing metadata section with link patch with different offset

	code 1 "main" aligned 1
	trailer 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	trailer 2 duplicable "test" aligned 1 "test" 1 abs 0 0 0ff

negative: duplicated duplicable trailing metadata section with link patch with different mode

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	trailer 1 duplicable "test" aligned 1 "test" 0 rel 0 0 0ff

negative: duplicated duplicable trailing metadata section with link patch with different displacement

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 1 0 0ff

negative: duplicated duplicable trailing metadata section with link patch with different scale

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 1 0ff

negative: duplicated duplicable trailing metadata section with link patch with different patterns

	code 1 "main" aligned 1
	trailer 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	trailer 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff1ff

negative: duplicated duplicable trailing metadata section with link patch with different pattern offset

	code 1 "main" aligned 1
	trailer 2 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	trailer 2 duplicable "test" aligned 1 "test" 0 abs 0 0 1ff

negative: duplicated duplicable trailing metadata section with link patch with different pattern mask

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 0 0ff
	trailer 1 duplicable "test" aligned 1 "test" 0 abs 0 0 000

positive: duplicated duplicable trailing metadata section with same data

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 0 00
	trailer 1 duplicable "test" aligned 1 0 00

negative: duplicated duplicable trailing metadata section with different data

	code 1 "main" aligned 1
	trailer 1 duplicable "test" aligned 1 0 00
	trailer 1 duplicable "test" aligned 1 0 ff

positive: replaceable trailing metadata section

	code 1 "main" aligned 1
	trailer 1 replaceable "test" aligned 1

positive: replaceable trailing metadata sections

	code 1 "main" aligned 1
	trailer 1 replaceable "test1" aligned 1
	trailer 1 replaceable "test2" aligned 1

negative: duplicated replaceable trailing metadata section

	code 1 "main" aligned 1
	trailer 1 replaceable "test" aligned 1
	trailer 1 replaceable "test" aligned 1

positive: replaceable trailing metadata section replaced by section

	code 1 "main" aligned 1
	trailer 1 replaceable "test" aligned 1
	trailer 1 "test" aligned 1

positive: replaceable trailing metadata section replaced by required section

	code 1 "main" aligned 1
	trailer 1 replaceable "test" aligned 1
	trailer 1 required "test" aligned 1

positive: replaceable trailing metadata section replaced by duplicable section

	code 1 "main" aligned 1
	trailer 1 replaceable "test" aligned 1
	trailer 1 duplicable "test" aligned 1

negative: replaceable trailing metadata section replaced by replaceable section

	code 1 "main" aligned 1
	trailer 1 replaceable "test" aligned 1
	trailer 1 replaceable "test" aligned 1

positive: fixed trailing metadata sections

	code 1 "main" aligned 1
	trailer 1 required "test1" fixed 0
	trailer 1 required "test2" fixed 1

negative: overlapping fixed trailing metadata sections

	code 1 "main" aligned 1
	trailer 1 required "test1" fixed 0
	trailer 1 required "test2" fixed 0

positive: trailing metadata section with resolved section

	code 1 "main" aligned 1
	trailer 1 required "test" aligned 1 "test"

positive: trailing metadata section with resolved empty section

	code 1 "main" aligned 1
	trailer 1 required "test" aligned 1 "test"

negative: trailing metadata section with unresolved section

	code 1 "main" aligned 1
	trailer 1 required "test" aligned 1 "data"

negative: trailing metadata section with conditionally resolved section

	code 1 "main" aligned 1
	trailer 1 required "test" aligned 1 "test?data"

positive: trailing metadata section with conditionally unresolved section

	code 1 "main" aligned 1
	trailer 1 required "test" aligned 1 "data?data"

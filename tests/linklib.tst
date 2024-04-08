# Object file test and validation suite
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

positive: empty object file

positive: object file with one section

	code 0 "test" aligned 1

positive: object file with several sections

	code 0 "test1" aligned 1
	data 0 "test2" aligned 1
	code 0 "test3" aligned 1

# standard code sections

positive: empty standard code section

	code 0 "test" aligned 1

negative: standard code section with missing type

	0 "test" aligned 1

negative: standard code section with invalid type

	invalid 0 "test" aligned 1

positive: standard code section with valid type

	code 0 "test" aligned 1

negative: standard code section with missing size

	code "test" aligned 1

negative: standard code section with invalid size

	code invalid "test" aligned 1

positive: standard code section with valid size

	code 0 "test" aligned 1

positive: standard code section without options

	code 0 "test" aligned 1

negative: standard code section with invalid option

	code 0 invalid "test" aligned 1

positive: standard code section with required option

	code 0 required "test" aligned 1

positive: standard code section with required and duplicable option

	code 0 required duplicable "test" aligned 1

positive: standard code section with required and replaceable option

	code 0 required replaceable "test" aligned 1

positive: standard code section with required, duplicable and replaceable option

	code 0 required duplicable replaceable "test" aligned 1

positive: standard code section with required, replaceable, and duplicable option

	code 0 required replaceable duplicable "test" aligned 1

positive: standard code section with duplicable option

	code 0 duplicable "test" aligned 1

positive: standard code section with duplicable and required option

	code 0 duplicable required "test" aligned 1

positive: standard code section with duplicable and replaceable option

	code 0 duplicable replaceable "test" aligned 1

positive: standard code section with duplicable, required and replaceable option

	code 0 duplicable required replaceable "test" aligned 1

positive: standard code section with duplicable, replaceable and required option

	code 0 duplicable replaceable required "test" aligned 1

positive: standard code section with replaceable option

	code 0 replaceable "test" aligned 1

positive: standard code section with replaceable and required option

	code 0 replaceable required "test" aligned 1

positive: standard code section with replaceable and duplicable option

	code 0 replaceable duplicable "test" aligned 1

positive: standard code section with replaceable, required and duplicable option

	code 0 replaceable required duplicable "test" aligned 1

positive: standard code section with replaceable, duplicable and required option

	code 0 replaceable duplicable required "test" aligned 1

negative: standard code section with missing name

	code 0 aligned 1

negative: standard code section with invalid name

	code 0 invalid aligned 1

positive: standard code section with valid name

	code 0 "test" aligned 1

negative: standard code section with missing alias offset

	code 0 "test" "alias" "group" aligned 1

negative: standard code section with invalid alias offset

	code 0 "test" invalid "alias" aligned 1

negative: standard code section with exceeding alias offset

	code 0 "test" 1 "alias" aligned 1

positive: standard code section with valid alias offset

	code 0 "test" 0 "alias" aligned 1

negative: standard code section with missing alias name

	code 0 "test" 0 aligned 1

negative: standard code section with invalid alias name

	code 0 "test" 0 invalid aligned 1

positive: standard code section with valid alias name

	code 0 "test" 0 "alias" aligned 1

negative: standard code section with aliases and missing offset

	code 0 "test" 0 "alias1" "alias2" "group" aligned 1

negative: standard code section with aliases and invalid offset

	code 0 "test" 0 "alias1" invalid "alias2" aligned 1

negative: standard code section with aliases and exceeding offset

	code 0 "test" 0 "alias1" 1 "alias2" aligned 1

positive: standard code section with aliases and valid offset

	code 0 "test" 0 "alias1" 0 "alias2" aligned 1

negative: standard code section with aliases and missing name

	code 0 "test" 0 "alias1" 0 aligned 1

negative: standard code section with aliases and invalid name

	code 0 "test" 0 "alias1" 0 invalid aligned 1

positive: standard code section with aliases and valid name

	code 0 "test" 0 "alias1" 0 "alias2" aligned 1

positive: standard code section without group

	code 0 "test" aligned 1

negative: standard code section with invalid group

	code 0 "test" invalid aligned 1

positive: standard code section with valid group

	code 0 "test" "group" aligned 1

negative: standard code section with missing alignment

	code 0 "test" 1

negative: standard code section with invalid alignment

	code 0 "test" invalid 1

positive: standard code section with valid alignment

	code 0 "test" aligned 1

negative: standard code section with missing alignment value

	code 0 "test" aligned

negative: standard code section with invalid alignment value

	code 0 "test" aligned 3

positive: standard code section with valid alignment value

	code 0 "test" aligned 1

negative: standard code section with missing origin

	code 0 "test" 0

negative: standard code section with invalid origin

	code 0 "test" invalid 0

positive: standard code section with valid origin

	code 0 "test" fixed 0

negative: standard code section with missing origin value

	code 0 "test" fixed

negative: standard code section with invalid origin value

	code 0 "test" fixed invalid

positive: standard code section with valid origin value

	code 0 "test" fixed 0

positive: standard code section without segment

	code 0 "test" aligned 1

negative: standard code section with segment and missing offset

	code 1 "test" aligned 1 ff

negative: standard code section with segment and invalid offset

	code 1 "test" aligned 1 invalid ff

negative: standard code section with segment and exceeding offset

	code 0 "test" aligned 1 0 ff

positive: standard code section with segment and valid offset

	code 1 "test" aligned 1 0 ff

negative: standard code section with segment and missing octet

	code 1 "test" aligned 1 0

negative: standard code section with segment and exceeding octet

	code 0 "test" aligned 1 0 ff

negative: standard code section with segment and invalid octet

	code 1 "test" aligned 1 0 invalid

negative: standard code section with segment and single quartet

	code 1 "test" aligned 1 0 f

positive: standard code section with segment and two quartets

	code 1 "test" aligned 1 0 ff

negative: standard code section with segment and three quartets

	code 2 "test" aligned 1 0 fff

negative: standard code section with segment and quartets with spaces

	code 1 "test" aligned 1 0 f f

positive: standard code section with segment and several octets

	code 2 "test" aligned 1 0 ffff

negative: standard code section with segment and exceeding octets

	code 1 "test" aligned 1 1 ffff

negative: standard code section with segments and missing offset

	code 1 "test" aligned 1 0 00 ff

negative: standard code section with segments and invalid offset

	code 1 "test" aligned 1 0 00 invalid ff

negative: standard code section with segments and exceeding offset

	code 1 "test" aligned 1 0 00 1 ff

positive: standard code section with segments and valid offset

	code 1 "test" aligned 1 0 00 0 ff

negative: standard code section with segments and missing octet

	code 1 "test" aligned 1 0 00 0

negative: standard code section with segments and exceeding octet

	code 1 "test" aligned 1 0 00 1 ff

negative: standard code section with segments and invalid octet

	code 1 "test" aligned 1 0 00 0 invalid

negative: standard code section with segments and single quartet

	code 1 "test" aligned 1 0 00 0 f

positive: standard code section with segments and two quartets

	code 1 "test" aligned 1 0 00 0 ff

negative: standard code section with segments and three quartets

	code 2 "test" aligned 1 0 00 0 fff

negative: standard code section with segments and quartets with spaces

	code 1 "test" aligned 1 0 00 0 f f

positive: standard code section with segments and several octets

	code 2 "test" aligned 1 0 00 0 ffff

negative: standard code section with segments and exceeding octets

	code 1 "test" aligned 1 0 00 1 ffff

positive: standard code section without link

	code 0 "test" aligned 1

positive: standard code section with link and missing reference

	code 0 "test" aligned 1

negative: standard code section with link and invalid reference

	code 0 "test" aligned 1 invalid

positive: standard code section with link and valid reference

	code 0 "test" aligned 1 "test"

positive: standard code section with link and missing patch

	code 0 "test" aligned 1 "test"

negative: standard code section with link patch and missing offset

	code 1 "test" aligned 1 "test" abs 0 0 0ff

negative: standard code section with link patch and invalid offset

	code 1 "test" aligned 1 "test" invalid abs 0 0 0ff

positive: standard code section with link patch and valid offset

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard code section with link patch and missing mode

	code 1 "test" aligned 1 "test" 0 0 0 0ff

negative: standard code section with link patch and invalid mode

	code 1 "test" aligned 1 "test" 0 invalid 0 0 0ff

positive: standard code section with link patch and absolute mode

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: standard code section with link patch and relative mode

	code 1 "test" aligned 1 "test" 0 rel 0 0 0ff

positive: standard code section with link patch and size mode

	code 1 "test" aligned 1 "test" 0 siz 0 0 0ff

positive: standard code section with link patch and extent mode

	code 1 "test" aligned 1 "test" 0 ext 0 0 0ff

positive: standard code section with link patch and position mode

	code 1 "test" aligned 1 "test" 0 pos 0 0 0ff

positive: standard code section with link patch and index mode

	code 1 "test" aligned 1 "test" 0 idx 0 0 0ff

positive: standard code section with link patch and count mode

	code 1 "test" aligned 1 "test" 0 cnt 0 0 0ff

negative: standard code section with link patch and missing displacement

	code 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: standard code section with link patch and invalid displacement

	code 1 "test" aligned 1 "test" 0 abs invalid 0 0ff

positive: standard code section with link patch and valid displacement

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard code section with link patch and missing scale

	code 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: standard code section with link patch and invalid scale

	code 1 "test" aligned 1 "test" 0 abs 0 invalid 0ff

positive: standard code section with link patch and valid scale

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard code section with link patch and missing pattern

	code 1 "test" aligned 1 "test" 0 abs 0 0

negative: standard code section with link patch and invalid pattern

	code 1 "test" aligned 1 "test" 0 abs 0 0 invalid

negative: standard code section with link patch and exceeding pattern

	code 0 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: standard code section with link patch and valid pattern

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard code section with link patch pattern and missing mask

	code 1 "test" aligned 1 "test" 0 abs 0 0

negative: standard code section with link patch pattern and invalid mask

	code 1 "test" aligned 1 "test" 0 abs 0 0 invalid

positive: standard code section with link patch pattern and valid mask

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard code section with link patch pattern mask and missing offset

	code 1 "test" aligned 1 "test" 0 abs 0 0 ff

negative: standard code section with link patch pattern mask and invalid offset

	code 1 "test" aligned 1 "test" 0 abs 0 0 invalidff

positive: standard code section with link patch pattern mask and valid offset

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard code section with link patch pattern mask and missing bitmask

	code 1 "test" aligned 1 "test" 0 abs 0 0 0

negative: standard code section with link patch pattern mask and invalid bitmask

	code 1 "test" aligned 1 "test" 0 abs 0 0 0invalid

negative: standard code section with link patch pattern mask and bitmask with spaces

	code 1 "test" aligned 1 "test" 0 abs 0 0 0f f

positive: standard code section with link patch pattern mask and valid bitmask

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: standard code section with link patch pattern mask and eight bitmasks

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff

negative: standard code section with link patch pattern mask and nine bitmasks

	code 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff0ff

# initializing code sections

positive: empty initializing code section

	initcode 0 "test" aligned 1

negative: initializing code section with missing type

	0 "test" aligned 1

negative: initializing code section with invalid type

	invalid 0 "test" aligned 1

positive: initializing code section with valid type

	initcode 0 "test" aligned 1

negative: initializing code section with missing size

	initcode "test" aligned 1

negative: initializing code section with invalid size

	initcode invalid "test" aligned 1

positive: initializing code section with valid size

	initcode 0 "test" aligned 1

positive: initializing code section without options

	initcode 0 "test" aligned 1

negative: initializing code section with invalid option

	initcode 0 invalid "test" aligned 1

positive: initializing code section with required option

	initcode 0 required "test" aligned 1

positive: initializing code section with required and duplicable option

	initcode 0 required duplicable "test" aligned 1

positive: initializing code section with required and replaceable option

	initcode 0 required replaceable "test" aligned 1

positive: initializing code section with required, duplicable and replaceable option

	initcode 0 required duplicable replaceable "test" aligned 1

positive: initializing code section with required, replaceable, and duplicable option

	initcode 0 required replaceable duplicable "test" aligned 1

positive: initializing code section with duplicable option

	initcode 0 duplicable "test" aligned 1

positive: initializing code section with duplicable and required option

	initcode 0 duplicable required "test" aligned 1

positive: initializing code section with duplicable and replaceable option

	initcode 0 duplicable replaceable "test" aligned 1

positive: initializing code section with duplicable, required and replaceable option

	initcode 0 duplicable required replaceable "test" aligned 1

positive: initializing code section with duplicable, replaceable and required option

	initcode 0 duplicable replaceable required "test" aligned 1

positive: initializing code section with replaceable option

	initcode 0 replaceable "test" aligned 1

positive: initializing code section with replaceable and required option

	initcode 0 replaceable required "test" aligned 1

positive: initializing code section with replaceable and duplicable option

	initcode 0 replaceable duplicable "test" aligned 1

positive: initializing code section with replaceable, required and duplicable option

	initcode 0 replaceable required duplicable "test" aligned 1

positive: initializing code section with replaceable, duplicable and required option

	initcode 0 replaceable duplicable required "test" aligned 1

negative: initializing code section with missing name

	initcode 0 aligned 1

negative: initializing code section with invalid name

	initcode 0 invalid aligned 1

positive: initializing code section with valid name

	initcode 0 "test" aligned 1

negative: initializing code section with missing alias offset

	initcode 0 "test" "alias" "group" aligned 1

negative: initializing code section with invalid alias offset

	initcode 0 "test" invalid "alias" aligned 1

negative: initializing code section with exceeding alias offset

	initcode 0 "test" 1 "alias" aligned 1

positive: initializing code section with valid alias offset

	initcode 0 "test" 0 "alias" aligned 1

negative: initializing code section with missing alias name

	initcode 0 "test" 0 aligned 1

negative: initializing code section with invalid alias name

	initcode 0 "test" 0 invalid aligned 1

positive: initializing code section with valid alias name

	initcode 0 "test" 0 "alias" aligned 1

negative: initializing code section with aliases and missing offset

	initcode 0 "test" 0 "alias1" "alias2" "group" aligned 1

negative: initializing code section with aliases and invalid offset

	initcode 0 "test" 0 "alias1" invalid "alias2" aligned 1

negative: initializing code section with aliases and exceeding offset

	initcode 0 "test" 0 "alias1" 1 "alias2" aligned 1

positive: initializing code section with aliases and valid offset

	initcode 0 "test" 0 "alias1" 0 "alias2" aligned 1

negative: initializing code section with aliases and missing name

	initcode 0 "test" 0 "alias1" 0 aligned 1

negative: initializing code section with aliases and invalid name

	initcode 0 "test" 0 "alias1" 0 invalid aligned 1

positive: initializing code section with aliases and valid name

	initcode 0 "test" 0 "alias1" 0 "alias2" aligned 1

positive: initializing code section without group

	initcode 0 "test" aligned 1

negative: initializing code section with invalid group

	initcode 0 "test" invalid aligned 1

positive: initializing code section with valid group

	initcode 0 "test" "group" aligned 1

negative: initializing code section with missing alignment

	initcode 0 "test" 1

negative: initializing code section with invalid alignment

	initcode 0 "test" invalid 1

positive: initializing code section with valid alignment

	initcode 0 "test" aligned 1

negative: initializing code section with missing alignment value

	initcode 0 "test" aligned

negative: initializing code section with invalid alignment value

	initcode 0 "test" aligned 3

positive: initializing code section with valid alignment value

	initcode 0 "test" aligned 1

negative: initializing code section with missing origin

	initcode 0 "test" 0

negative: initializing code section with invalid origin

	initcode 0 "test" invalid 0

positive: initializing code section with valid origin

	initcode 0 "test" fixed 0

negative: initializing code section with missing origin value

	initcode 0 "test" fixed

negative: initializing code section with invalid origin value

	initcode 0 "test" fixed invalid

positive: initializing code section with valid origin value

	initcode 0 "test" fixed 0

positive: initializing code section without segment

	initcode 0 "test" aligned 1

negative: initializing code section with segment and missing offset

	initcode 1 "test" aligned 1 ff

negative: initializing code section with segment and invalid offset

	initcode 1 "test" aligned 1 invalid ff

negative: initializing code section with segment and exceeding offset

	initcode 0 "test" aligned 1 0 ff

positive: initializing code section with segment and valid offset

	initcode 1 "test" aligned 1 0 ff

negative: initializing code section with segment and missing octet

	initcode 1 "test" aligned 1 0

negative: initializing code section with segment and exceeding octet

	initcode 0 "test" aligned 1 0 ff

negative: initializing code section with segment and invalid octet

	initcode 1 "test" aligned 1 0 invalid

negative: initializing code section with segment and single quartet

	initcode 1 "test" aligned 1 0 f

positive: initializing code section with segment and two quartets

	initcode 1 "test" aligned 1 0 ff

negative: initializing code section with segment and three quartets

	initcode 2 "test" aligned 1 0 fff

negative: initializing code section with segment and quartets with spaces

	initcode 1 "test" aligned 1 0 f f

positive: initializing code section with segment and several octets

	initcode 2 "test" aligned 1 0 ffff

negative: initializing code section with segment and exceeding octets

	initcode 1 "test" aligned 1 1 ffff

negative: initializing code section with segments and missing offset

	initcode 1 "test" aligned 1 0 00 ff

negative: initializing code section with segments and invalid offset

	initcode 1 "test" aligned 1 0 00 invalid ff

negative: initializing code section with segments and exceeding offset

	initcode 1 "test" aligned 1 0 00 1 ff

positive: initializing code section with segments and valid offset

	initcode 1 "test" aligned 1 0 00 0 ff

negative: initializing code section with segments and missing octet

	initcode 1 "test" aligned 1 0 00 0

negative: initializing code section with segments and exceeding octet

	initcode 1 "test" aligned 1 0 00 1 ff

negative: initializing code section with segments and invalid octet

	initcode 1 "test" aligned 1 0 00 0 invalid

negative: initializing code section with segments and single quartet

	initcode 1 "test" aligned 1 0 00 0 f

positive: initializing code section with segments and two quartets

	initcode 1 "test" aligned 1 0 00 0 ff

negative: initializing code section with segments and three quartets

	initcode 2 "test" aligned 1 0 00 0 fff

negative: initializing code section with segments and quartets with spaces

	initcode 1 "test" aligned 1 0 00 0 f f

positive: initializing code section with segments and several octets

	initcode 2 "test" aligned 1 0 00 0 ffff

negative: initializing code section with segments and exceeding octets

	initcode 1 "test" aligned 1 0 00 1 ffff

positive: initializing code section without link

	initcode 0 "test" aligned 1

positive: initializing code section with link and missing reference

	initcode 0 "test" aligned 1

negative: initializing code section with link and invalid reference

	initcode 0 "test" aligned 1 invalid

positive: initializing code section with link and valid reference

	initcode 0 "test" aligned 1 "test"

positive: initializing code section with link and missing patch

	initcode 0 "test" aligned 1 "test"

negative: initializing code section with link patch and missing offset

	initcode 1 "test" aligned 1 "test" abs 0 0 0ff

negative: initializing code section with link patch and invalid offset

	initcode 1 "test" aligned 1 "test" invalid abs 0 0 0ff

positive: initializing code section with link patch and valid offset

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: initializing code section with link patch and missing mode

	initcode 1 "test" aligned 1 "test" 0 0 0 0ff

negative: initializing code section with link patch and invalid mode

	initcode 1 "test" aligned 1 "test" 0 invalid 0 0 0ff

positive: initializing code section with link patch and absolute mode

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: initializing code section with link patch and relative mode

	initcode 1 "test" aligned 1 "test" 0 rel 0 0 0ff

positive: initializing code section with link patch and size mode

	initcode 1 "test" aligned 1 "test" 0 siz 0 0 0ff

positive: initializing code section with link patch and extent mode

	initcode 1 "test" aligned 1 "test" 0 ext 0 0 0ff

positive: initializing code section with link patch and position mode

	initcode 1 "test" aligned 1 "test" 0 pos 0 0 0ff

positive: initializing code section with link patch and index mode

	initcode 1 "test" aligned 1 "test" 0 idx 0 0 0ff

positive: initializing code section with link patch and count mode

	initcode 1 "test" aligned 1 "test" 0 cnt 0 0 0ff

negative: initializing code section with link patch and missing displacement

	initcode 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: initializing code section with link patch and invalid displacement

	initcode 1 "test" aligned 1 "test" 0 abs invalid 0 0ff

positive: initializing code section with link patch and valid displacement

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: initializing code section with link patch and missing scale

	initcode 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: initializing code section with link patch and invalid scale

	initcode 1 "test" aligned 1 "test" 0 abs 0 invalid 0ff

positive: initializing code section with link patch and valid scale

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: initializing code section with link patch and missing pattern

	initcode 1 "test" aligned 1 "test" 0 abs 0 0

negative: initializing code section with link patch and invalid pattern

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 invalid

negative: initializing code section with link patch and exceeding pattern

	initcode 0 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: initializing code section with link patch and valid pattern

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: initializing code section with link patch pattern and missing mask

	initcode 1 "test" aligned 1 "test" 0 abs 0 0

negative: initializing code section with link patch pattern and invalid mask

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 invalid

positive: initializing code section with link patch pattern and valid mask

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: initializing code section with link patch pattern mask and missing offset

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 ff

negative: initializing code section with link patch pattern mask and invalid offset

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 invalidff

positive: initializing code section with link patch pattern mask and valid offset

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: initializing code section with link patch pattern mask and missing bitmask

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0

negative: initializing code section with link patch pattern mask and invalid bitmask

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0invalid

negative: initializing code section with link patch pattern mask and bitmask with spaces

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0f f

positive: initializing code section with link patch pattern mask and valid bitmask

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: initializing code section with link patch pattern mask and eight bitmasks

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff

negative: initializing code section with link patch pattern mask and nine bitmasks

	initcode 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff0ff

# data initializing code sections

positive: empty data initializing code section

	initdata 0 "test" aligned 1

negative: data initializing code section with missing type

	0 "test" aligned 1

negative: data initializing code section with invalid type

	invalid 0 "test" aligned 1

positive: data initializing code section with valid type

	initdata 0 "test" aligned 1

negative: data initializing code section with missing size

	initdata "test" aligned 1

negative: data initializing code section with invalid size

	initdata invalid "test" aligned 1

positive: data initializing code section with valid size

	initdata 0 "test" aligned 1

positive: data initializing code section without options

	initdata 0 "test" aligned 1

negative: data initializing code section with invalid option

	initdata 0 invalid "test" aligned 1

positive: data initializing code section with required option

	initdata 0 required "test" aligned 1

positive: data initializing code section with required and duplicable option

	initdata 0 required duplicable "test" aligned 1

positive: data initializing code section with required and replaceable option

	initdata 0 required replaceable "test" aligned 1

positive: data initializing code section with required, duplicable and replaceable option

	initdata 0 required duplicable replaceable "test" aligned 1

positive: data initializing code section with required, replaceable, and duplicable option

	initdata 0 required replaceable duplicable "test" aligned 1

positive: data initializing code section with duplicable option

	initdata 0 duplicable "test" aligned 1

positive: data initializing code section with duplicable and required option

	initdata 0 duplicable required "test" aligned 1

positive: data initializing code section with duplicable and replaceable option

	initdata 0 duplicable replaceable "test" aligned 1

positive: data initializing code section with duplicable, required and replaceable option

	initdata 0 duplicable required replaceable "test" aligned 1

positive: data initializing code section with duplicable, replaceable and required option

	initdata 0 duplicable replaceable required "test" aligned 1

positive: data initializing code section with replaceable option

	initdata 0 replaceable "test" aligned 1

positive: data initializing code section with replaceable and required option

	initdata 0 replaceable required "test" aligned 1

positive: data initializing code section with replaceable and duplicable option

	initdata 0 replaceable duplicable "test" aligned 1

positive: data initializing code section with replaceable, required and duplicable option

	initdata 0 replaceable required duplicable "test" aligned 1

positive: data initializing code section with replaceable, duplicable and required option

	initdata 0 replaceable duplicable required "test" aligned 1

negative: data initializing code section with missing name

	initdata 0 aligned 1

negative: data initializing code section with invalid name

	initdata 0 invalid aligned 1

positive: data initializing code section with valid name

	initdata 0 "test" aligned 1

negative: data initializing code section with missing alias offset

	initdata 0 "test" "alias" "group" aligned 1

negative: data initializing code section with invalid alias offset

	initdata 0 "test" invalid "alias" aligned 1

negative: data initializing code section with exceeding alias offset

	initdata 0 "test" 1 "alias" aligned 1

positive: data initializing code section with valid alias offset

	initdata 0 "test" 0 "alias" aligned 1

negative: data initializing code section with missing alias name

	initdata 0 "test" 0 aligned 1

negative: data initializing code section with invalid alias name

	initdata 0 "test" 0 invalid aligned 1

positive: data initializing code section with valid alias name

	initdata 0 "test" 0 "alias" aligned 1

negative: data initializing code section with aliases and missing offset

	initdata 0 "test" 0 "alias1" "alias2" "group" aligned 1

negative: data initializing code section with aliases and invalid offset

	initdata 0 "test" 0 "alias1" invalid "alias2" aligned 1

negative: data initializing code section with aliases and exceeding offset

	initdata 0 "test" 0 "alias1" 1 "alias2" aligned 1

positive: data initializing code section with aliases and valid offset

	initdata 0 "test" 0 "alias1" 0 "alias2" aligned 1

negative: data initializing code section with aliases and missing name

	initdata 0 "test" 0 "alias1" 0 aligned 1

negative: data initializing code section with aliases and invalid name

	initdata 0 "test" 0 "alias1" 0 invalid aligned 1

positive: data initializing code section with aliases and valid name

	initdata 0 "test" 0 "alias1" 0 "alias2" aligned 1

positive: data initializing code section without group

	initdata 0 "test" aligned 1

negative: data initializing code section with invalid group

	initdata 0 "test" invalid aligned 1

positive: data initializing code section with valid group

	initdata 0 "test" "group" aligned 1

negative: data initializing code section with missing alignment

	initdata 0 "test" 1

negative: data initializing code section with invalid alignment

	initdata 0 "test" invalid 1

positive: data initializing code section with valid alignment

	initdata 0 "test" aligned 1

negative: data initializing code section with missing alignment value

	initdata 0 "test" aligned

negative: data initializing code section with invalid alignment value

	initdata 0 "test" aligned 3

positive: data initializing code section with valid alignment value

	initdata 0 "test" aligned 1

negative: data initializing code section with missing origin

	initdata 0 "test" 0

negative: data initializing code section with invalid origin

	initdata 0 "test" invalid 0

positive: data initializing code section with valid origin

	initdata 0 "test" fixed 0

negative: data initializing code section with missing origin value

	initdata 0 "test" fixed

negative: data initializing code section with invalid origin value

	initdata 0 "test" fixed invalid

positive: data initializing code section with valid origin value

	initdata 0 "test" fixed 0

positive: data initializing code section without segment

	initdata 0 "test" aligned 1

negative: data initializing code section with segment and missing offset

	initdata 1 "test" aligned 1 ff

negative: data initializing code section with segment and invalid offset

	initdata 1 "test" aligned 1 invalid ff

negative: data initializing code section with segment and exceeding offset

	initdata 0 "test" aligned 1 0 ff

positive: data initializing code section with segment and valid offset

	initdata 1 "test" aligned 1 0 ff

negative: data initializing code section with segment and missing octet

	initdata 1 "test" aligned 1 0

negative: data initializing code section with segment and exceeding octet

	initdata 0 "test" aligned 1 0 ff

negative: data initializing code section with segment and invalid octet

	initdata 1 "test" aligned 1 0 invalid

negative: data initializing code section with segment and single quartet

	initdata 1 "test" aligned 1 0 f

positive: data initializing code section with segment and two quartets

	initdata 1 "test" aligned 1 0 ff

negative: data initializing code section with segment and three quartets

	initdata 2 "test" aligned 1 0 fff

negative: data initializing code section with segment and quartets with spaces

	initdata 1 "test" aligned 1 0 f f

positive: data initializing code section with segment and several octets

	initdata 2 "test" aligned 1 0 ffff

negative: data initializing code section with segment and exceeding octets

	initdata 1 "test" aligned 1 1 ffff

negative: data initializing code section with segments and missing offset

	initdata 1 "test" aligned 1 0 00 ff

negative: data initializing code section with segments and invalid offset

	initdata 1 "test" aligned 1 0 00 invalid ff

negative: data initializing code section with segments and exceeding offset

	initdata 1 "test" aligned 1 0 00 1 ff

positive: data initializing code section with segments and valid offset

	initdata 1 "test" aligned 1 0 00 0 ff

negative: data initializing code section with segments and missing octet

	initdata 1 "test" aligned 1 0 00 0

negative: data initializing code section with segments and exceeding octet

	initdata 1 "test" aligned 1 0 00 1 ff

negative: data initializing code section with segments and invalid octet

	initdata 1 "test" aligned 1 0 00 0 invalid

negative: data initializing code section with segments and single quartet

	initdata 1 "test" aligned 1 0 00 0 f

positive: data initializing code section with segments and two quartets

	initdata 1 "test" aligned 1 0 00 0 ff

negative: data initializing code section with segments and three quartets

	initdata 2 "test" aligned 1 0 00 0 fff

negative: data initializing code section with segments and quartets with spaces

	initdata 1 "test" aligned 1 0 00 0 f f

positive: data initializing code section with segments and several octets

	initdata 2 "test" aligned 1 0 00 0 ffff

negative: data initializing code section with segments and exceeding octets

	initdata 1 "test" aligned 1 0 00 1 ffff

positive: data initializing code section without link

	initdata 0 "test" aligned 1

positive: data initializing code section with link and missing reference

	initdata 0 "test" aligned 1

negative: data initializing code section with link and invalid reference

	initdata 0 "test" aligned 1 invalid

positive: data initializing code section with link and valid reference

	initdata 0 "test" aligned 1 "test"

positive: data initializing code section with link and missing patch

	initdata 0 "test" aligned 1 "test"

negative: data initializing code section with link patch and missing offset

	initdata 1 "test" aligned 1 "test" abs 0 0 0ff

negative: data initializing code section with link patch and invalid offset

	initdata 1 "test" aligned 1 "test" invalid abs 0 0 0ff

positive: data initializing code section with link patch and valid offset

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: data initializing code section with link patch and missing mode

	initdata 1 "test" aligned 1 "test" 0 0 0 0ff

negative: data initializing code section with link patch and invalid mode

	initdata 1 "test" aligned 1 "test" 0 invalid 0 0 0ff

positive: data initializing code section with link patch and absolute mode

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: data initializing code section with link patch and relative mode

	initdata 1 "test" aligned 1 "test" 0 rel 0 0 0ff

positive: data initializing code section with link patch and size mode

	initdata 1 "test" aligned 1 "test" 0 siz 0 0 0ff

positive: data initializing code section with link patch and extent mode

	initdata 1 "test" aligned 1 "test" 0 ext 0 0 0ff

positive: data initializing code section with link patch and position mode

	initdata 1 "test" aligned 1 "test" 0 pos 0 0 0ff

positive: data initializing code section with link patch and index mode

	initdata 1 "test" aligned 1 "test" 0 idx 0 0 0ff

positive: data initializing code section with link patch and count mode

	initdata 1 "test" aligned 1 "test" 0 cnt 0 0 0ff

negative: data initializing code section with link patch and missing displacement

	initdata 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: data initializing code section with link patch and invalid displacement

	initdata 1 "test" aligned 1 "test" 0 abs invalid 0 0ff

positive: data initializing code section with link patch and valid displacement

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: data initializing code section with link patch and missing scale

	initdata 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: data initializing code section with link patch and invalid scale

	initdata 1 "test" aligned 1 "test" 0 abs 0 invalid 0ff

positive: data initializing code section with link patch and valid scale

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: data initializing code section with link patch and missing pattern

	initdata 1 "test" aligned 1 "test" 0 abs 0 0

negative: data initializing code section with link patch and invalid pattern

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 invalid

negative: data initializing code section with link patch and exceeding pattern

	initdata 0 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: data initializing code section with link patch and valid pattern

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: data initializing code section with link patch pattern and missing mask

	initdata 1 "test" aligned 1 "test" 0 abs 0 0

negative: data initializing code section with link patch pattern and invalid mask

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 invalid

positive: data initializing code section with link patch pattern and valid mask

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: data initializing code section with link patch pattern mask and missing offset

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 ff

negative: data initializing code section with link patch pattern mask and invalid offset

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 invalidff

positive: data initializing code section with link patch pattern mask and valid offset

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: data initializing code section with link patch pattern mask and missing bitmask

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0

negative: data initializing code section with link patch pattern mask and invalid bitmask

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0invalid

negative: data initializing code section with link patch pattern mask and bitmask with spaces

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0f f

positive: data initializing code section with link patch pattern mask and valid bitmask

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: data initializing code section with link patch pattern mask and eight bitmasks

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff

negative: data initializing code section with link patch pattern mask and nine bitmasks

	initdata 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff0ff

# standard data sections

positive: empty standard data section

	data 0 "test" aligned 1

negative: standard data section with missing type

	0 "test" aligned 1

negative: standard data section with invalid type

	invalid 0 "test" aligned 1

positive: standard data section with valid type

	data 0 "test" aligned 1

negative: standard data section with missing size

	data "test" aligned 1

negative: standard data section with invalid size

	data invalid "test" aligned 1

positive: standard data section with valid size

	data 0 "test" aligned 1

positive: standard data section without options

	data 0 "test" aligned 1

negative: standard data section with invalid option

	data 0 invalid "test" aligned 1

positive: standard data section with required option

	data 0 required "test" aligned 1

positive: standard data section with required and duplicable option

	data 0 required duplicable "test" aligned 1

positive: standard data section with required and replaceable option

	data 0 required replaceable "test" aligned 1

positive: standard data section with required, duplicable and replaceable option

	data 0 required duplicable replaceable "test" aligned 1

positive: standard data section with required, replaceable, and duplicable option

	data 0 required replaceable duplicable "test" aligned 1

positive: standard data section with duplicable option

	data 0 duplicable "test" aligned 1

positive: standard data section with duplicable and required option

	data 0 duplicable required "test" aligned 1

positive: standard data section with duplicable and replaceable option

	data 0 duplicable replaceable "test" aligned 1

positive: standard data section with duplicable, required and replaceable option

	data 0 duplicable required replaceable "test" aligned 1

positive: standard data section with duplicable, replaceable and required option

	data 0 duplicable replaceable required "test" aligned 1

positive: standard data section with replaceable option

	data 0 replaceable "test" aligned 1

positive: standard data section with replaceable and required option

	data 0 replaceable required "test" aligned 1

positive: standard data section with replaceable and duplicable option

	data 0 replaceable duplicable "test" aligned 1

positive: standard data section with replaceable, required and duplicable option

	data 0 replaceable required duplicable "test" aligned 1

positive: standard data section with replaceable, duplicable and required option

	data 0 replaceable duplicable required "test" aligned 1

negative: standard data section with missing name

	data 0 aligned 1

negative: standard data section with invalid name

	data 0 invalid aligned 1

positive: standard data section with valid name

	data 0 "test" aligned 1

negative: standard data section with missing alias offset

	data 0 "test" "alias" "group" aligned 1

negative: standard data section with invalid alias offset

	data 0 "test" invalid "alias" aligned 1

negative: standard data section with exceeding alias offset

	data 0 "test" 1 "alias" aligned 1

positive: standard data section with valid alias offset

	data 0 "test" 0 "alias" aligned 1

negative: standard data section with missing alias name

	data 0 "test" 0 aligned 1

negative: standard data section with invalid alias name

	data 0 "test" 0 invalid aligned 1

positive: standard data section with valid alias name

	data 0 "test" 0 "alias" aligned 1

negative: standard data section with aliases and missing offset

	data 0 "test" 0 "alias1" "alias2" "group" aligned 1

negative: standard data section with aliases and invalid offset

	data 0 "test" 0 "alias1" invalid "alias2" aligned 1

negative: standard data section with aliases and exceeding offset

	data 0 "test" 0 "alias1" 1 "alias2" aligned 1

positive: standard data section with aliases and valid offset

	data 0 "test" 0 "alias1" 0 "alias2" aligned 1

negative: standard data section with aliases and missing name

	data 0 "test" 0 "alias1" 0 aligned 1

negative: standard data section with aliases and invalid name

	data 0 "test" 0 "alias1" 0 invalid aligned 1

positive: standard data section with aliases and valid name

	data 0 "test" 0 "alias1" 0 "alias2" aligned 1

positive: standard data section without group

	data 0 "test" aligned 1

negative: standard data section with invalid group

	data 0 "test" invalid aligned 1

positive: standard data section with valid group

	data 0 "test" "group" aligned 1

negative: standard data section with missing alignment

	data 0 "test" 1

negative: standard data section with invalid alignment

	data 0 "test" invalid 1

positive: standard data section with valid alignment

	data 0 "test" aligned 1

negative: standard data section with missing alignment value

	data 0 "test" aligned

negative: standard data section with invalid alignment value

	data 0 "test" aligned 3

positive: standard data section with valid alignment value

	data 0 "test" aligned 1

negative: standard data section with missing origin

	data 0 "test" 0

negative: standard data section with invalid origin

	data 0 "test" invalid 0

positive: standard data section with valid origin

	data 0 "test" fixed 0

negative: standard data section with missing origin value

	data 0 "test" fixed

negative: standard data section with invalid origin value

	data 0 "test" fixed invalid

positive: standard data section with valid origin value

	data 0 "test" fixed 0

positive: standard data section without segment

	data 0 "test" aligned 1

negative: standard data section with segment and missing offset

	data 1 "test" aligned 1 ff

negative: standard data section with segment and invalid offset

	data 1 "test" aligned 1 invalid ff

negative: standard data section with segment and exceeding offset

	data 0 "test" aligned 1 0 ff

positive: standard data section with segment and valid offset

	data 1 "test" aligned 1 0 ff

negative: standard data section with segment and missing octet

	data 1 "test" aligned 1 0

negative: standard data section with segment and exceeding octet

	data 0 "test" aligned 1 0 ff

negative: standard data section with segment and invalid octet

	data 1 "test" aligned 1 0 invalid

negative: standard data section with segment and single quartet

	data 1 "test" aligned 1 0 f

positive: standard data section with segment and two quartets

	data 1 "test" aligned 1 0 ff

negative: standard data section with segment and three quartets

	data 2 "test" aligned 1 0 fff

negative: standard data section with segment and quartets with spaces

	data 1 "test" aligned 1 0 f f

positive: standard data section with segment and several octets

	data 2 "test" aligned 1 0 ffff

negative: standard data section with segment and exceeding octets

	data 1 "test" aligned 1 1 ffff

negative: standard data section with segments and missing offset

	data 1 "test" aligned 1 0 00 ff

negative: standard data section with segments and invalid offset

	data 1 "test" aligned 1 0 00 invalid ff

negative: standard data section with segments and exceeding offset

	data 1 "test" aligned 1 0 00 1 ff

positive: standard data section with segments and valid offset

	data 1 "test" aligned 1 0 00 0 ff

negative: standard data section with segments and missing octet

	data 1 "test" aligned 1 0 00 0

negative: standard data section with segments and exceeding octet

	data 1 "test" aligned 1 0 00 1 ff

negative: standard data section with segments and invalid octet

	data 1 "test" aligned 1 0 00 0 invalid

negative: standard data section with segments and single quartet

	data 1 "test" aligned 1 0 00 0 f

positive: standard data section with segments and two quartets

	data 1 "test" aligned 1 0 00 0 ff

negative: standard data section with segments and three quartets

	data 2 "test" aligned 1 0 00 0 fff

negative: standard data section with segments and quartets with spaces

	data 1 "test" aligned 1 0 00 0 f f

positive: standard data section with segments and several octets

	data 2 "test" aligned 1 0 00 0 ffff

negative: standard data section with segments and exceeding octets

	data 1 "test" aligned 1 0 00 1 ffff

positive: standard data section without link

	data 0 "test" aligned 1

positive: standard data section with link and missing reference

	data 0 "test" aligned 1

negative: standard data section with link and invalid reference

	data 0 "test" aligned 1 invalid

positive: standard data section with link and valid reference

	data 0 "test" aligned 1 "test"

positive: standard data section with link and missing patch

	data 0 "test" aligned 1 "test"

negative: standard data section with link patch and missing offset

	data 1 "test" aligned 1 "test" abs 0 0 0ff

negative: standard data section with link patch and invalid offset

	data 1 "test" aligned 1 "test" invalid abs 0 0 0ff

positive: standard data section with link patch and valid offset

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard data section with link patch and missing mode

	data 1 "test" aligned 1 "test" 0 0 0 0ff

negative: standard data section with link patch and invalid mode

	data 1 "test" aligned 1 "test" 0 invalid 0 0 0ff

positive: standard data section with link patch and absolute mode

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: standard data section with link patch and relative mode

	data 1 "test" aligned 1 "test" 0 rel 0 0 0ff

positive: standard data section with link patch and size mode

	data 1 "test" aligned 1 "test" 0 siz 0 0 0ff

positive: standard data section with link patch and extent mode

	data 1 "test" aligned 1 "test" 0 ext 0 0 0ff

positive: standard data section with link patch and position mode

	data 1 "test" aligned 1 "test" 0 pos 0 0 0ff

positive: standard data section with link patch and index mode

	data 1 "test" aligned 1 "test" 0 idx 0 0 0ff

positive: standard data section with link patch and count mode

	data 1 "test" aligned 1 "test" 0 cnt 0 0 0ff

negative: standard data section with link patch and missing displacement

	data 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: standard data section with link patch and invalid displacement

	data 1 "test" aligned 1 "test" 0 abs invalid 0 0ff

positive: standard data section with link patch and valid displacement

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard data section with link patch and missing scale

	data 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: standard data section with link patch and invalid scale

	data 1 "test" aligned 1 "test" 0 abs 0 invalid 0ff

positive: standard data section with link patch and valid scale

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard data section with link patch and missing pattern

	data 1 "test" aligned 1 "test" 0 abs 0 0

negative: standard data section with link patch and invalid pattern

	data 1 "test" aligned 1 "test" 0 abs 0 0 invalid

negative: standard data section with link patch and exceeding pattern

	data 0 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: standard data section with link patch and valid pattern

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard data section with link patch pattern and missing mask

	data 1 "test" aligned 1 "test" 0 abs 0 0

negative: standard data section with link patch pattern and invalid mask

	data 1 "test" aligned 1 "test" 0 abs 0 0 invalid

positive: standard data section with link patch pattern and valid mask

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard data section with link patch pattern mask and missing offset

	data 1 "test" aligned 1 "test" 0 abs 0 0 ff

negative: standard data section with link patch pattern mask and invalid offset

	data 1 "test" aligned 1 "test" 0 abs 0 0 invalidff

positive: standard data section with link patch pattern mask and valid offset

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: standard data section with link patch pattern mask and missing bitmask

	data 1 "test" aligned 1 "test" 0 abs 0 0 0

negative: standard data section with link patch pattern mask and invalid bitmask

	data 1 "test" aligned 1 "test" 0 abs 0 0 0invalid

negative: standard data section with link patch pattern mask and bitmask with spaces

	data 1 "test" aligned 1 "test" 0 abs 0 0 0f f

positive: standard data section with link patch pattern mask and valid bitmask

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: standard data section with link patch pattern mask and eight bitmasks

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff

negative: standard data section with link patch pattern mask and nine bitmasks

	data 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff0ff

# constant data sections

positive: empty constant data section

	const 0 "test" aligned 1

negative: constant data section with missing type

	0 "test" aligned 1

negative: constant data section with invalid type

	invalid 0 "test" aligned 1

positive: constant data section with valid type

	const 0 "test" aligned 1

negative: constant data section with missing size

	const "test" aligned 1

negative: constant data section with invalid size

	const invalid "test" aligned 1

positive: constant data section with valid size

	const 0 "test" aligned 1

positive: constant data section without options

	const 0 "test" aligned 1

negative: constant data section with invalid option

	const 0 invalid "test" aligned 1

positive: constant data section with required option

	const 0 required "test" aligned 1

positive: constant data section with required and duplicable option

	const 0 required duplicable "test" aligned 1

positive: constant data section with required and replaceable option

	const 0 required replaceable "test" aligned 1

positive: constant data section with required, duplicable and replaceable option

	const 0 required duplicable replaceable "test" aligned 1

positive: constant data section with required, replaceable, and duplicable option

	const 0 required replaceable duplicable "test" aligned 1

positive: constant data section with duplicable option

	const 0 duplicable "test" aligned 1

positive: constant data section with duplicable and required option

	const 0 duplicable required "test" aligned 1

positive: constant data section with duplicable and replaceable option

	const 0 duplicable replaceable "test" aligned 1

positive: constant data section with duplicable, required and replaceable option

	const 0 duplicable required replaceable "test" aligned 1

positive: constant data section with duplicable, replaceable and required option

	const 0 duplicable replaceable required "test" aligned 1

positive: constant data section with replaceable option

	const 0 replaceable "test" aligned 1

positive: constant data section with replaceable and required option

	const 0 replaceable required "test" aligned 1

positive: constant data section with replaceable and duplicable option

	const 0 replaceable duplicable "test" aligned 1

positive: constant data section with replaceable, required and duplicable option

	const 0 replaceable required duplicable "test" aligned 1

positive: constant data section with replaceable, duplicable and required option

	const 0 replaceable duplicable required "test" aligned 1

negative: constant data section with missing name

	const 0 aligned 1

negative: constant data section with invalid name

	const 0 invalid aligned 1

positive: constant data section with valid name

	const 0 "test" aligned 1

negative: constant data section with missing alias offset

	const 0 "test" "alias" "group" aligned 1

negative: constant data section with invalid alias offset

	const 0 "test" invalid "alias" aligned 1

negative: constant data section with exceeding alias offset

	const 0 "test" 1 "alias" aligned 1

positive: constant data section with valid alias offset

	const 0 "test" 0 "alias" aligned 1

negative: constant data section with missing alias name

	const 0 "test" 0 aligned 1

negative: constant data section with invalid alias name

	const 0 "test" 0 invalid aligned 1

positive: constant data section with valid alias name

	const 0 "test" 0 "alias" aligned 1

negative: constant data section with aliases and missing offset

	const 0 "test" 0 "alias1" "alias2" "group" aligned 1

negative: constant data section with aliases and invalid offset

	const 0 "test" 0 "alias1" invalid "alias2" aligned 1

negative: constant data section with aliases and exceeding offset

	const 0 "test" 0 "alias1" 1 "alias2" aligned 1

positive: constant data section with aliases and valid offset

	const 0 "test" 0 "alias1" 0 "alias2" aligned 1

negative: constant data section with aliases and missing name

	const 0 "test" 0 "alias1" 0 aligned 1

negative: constant data section with aliases and invalid name

	const 0 "test" 0 "alias1" 0 invalid aligned 1

positive: constant data section with aliases and valid name

	const 0 "test" 0 "alias1" 0 "alias2" aligned 1

positive: constant data section without group

	const 0 "test" aligned 1

negative: constant data section with invalid group

	const 0 "test" invalid aligned 1

positive: constant data section with valid group

	const 0 "test" "group" aligned 1

negative: constant data section with missing alignment

	const 0 "test" 1

negative: constant data section with invalid alignment

	const 0 "test" invalid 1

positive: constant data section with valid alignment

	const 0 "test" aligned 1

negative: constant data section with missing alignment value

	const 0 "test" aligned

negative: constant data section with invalid alignment value

	const 0 "test" aligned 3

positive: constant data section with valid alignment value

	const 0 "test" aligned 1

negative: constant data section with missing origin

	const 0 "test" 0

negative: constant data section with invalid origin

	const 0 "test" invalid 0

positive: constant data section with valid origin

	const 0 "test" fixed 0

negative: constant data section with missing origin value

	const 0 "test" fixed

negative: constant data section with invalid origin value

	const 0 "test" fixed invalid

positive: constant data section with valid origin value

	const 0 "test" fixed 0

positive: constant data section without segment

	const 0 "test" aligned 1

negative: constant data section with segment and missing offset

	const 1 "test" aligned 1 ff

negative: constant data section with segment and invalid offset

	const 1 "test" aligned 1 invalid ff

negative: constant data section with segment and exceeding offset

	const 0 "test" aligned 1 0 ff

positive: constant data section with segment and valid offset

	const 1 "test" aligned 1 0 ff

negative: constant data section with segment and missing octet

	const 1 "test" aligned 1 0

negative: constant data section with segment and exceeding octet

	const 0 "test" aligned 1 0 ff

negative: constant data section with segment and invalid octet

	const 1 "test" aligned 1 0 invalid

negative: constant data section with segment and single quartet

	const 1 "test" aligned 1 0 f

positive: constant data section with segment and two quartets

	const 1 "test" aligned 1 0 ff

negative: constant data section with segment and three quartets

	const 2 "test" aligned 1 0 fff

negative: constant data section with segment and quartets with spaces

	const 1 "test" aligned 1 0 f f

positive: constant data section with segment and several octets

	const 2 "test" aligned 1 0 ffff

negative: constant data section with segment and exceeding octets

	const 1 "test" aligned 1 1 ffff

negative: constant data section with segments and missing offset

	const 1 "test" aligned 1 0 00 ff

negative: constant data section with segments and invalid offset

	const 1 "test" aligned 1 0 00 invalid ff

negative: constant data section with segments and exceeding offset

	const 1 "test" aligned 1 0 00 1 ff

positive: constant data section with segments and valid offset

	const 1 "test" aligned 1 0 00 0 ff

negative: constant data section with segments and missing octet

	const 1 "test" aligned 1 0 00 0

negative: constant data section with segments and exceeding octet

	const 1 "test" aligned 1 0 00 1 ff

negative: constant data section with segments and invalid octet

	const 1 "test" aligned 1 0 00 0 invalid

negative: constant data section with segments and single quartet

	const 1 "test" aligned 1 0 00 0 f

positive: constant data section with segments and two quartets

	const 1 "test" aligned 1 0 00 0 ff

negative: constant data section with segments and three quartets

	const 2 "test" aligned 1 0 00 0 fff

negative: constant data section with segments and quartets with spaces

	const 1 "test" aligned 1 0 00 0 f f

positive: constant data section with segments and several octets

	const 2 "test" aligned 1 0 00 0 ffff

negative: constant data section with segments and exceeding octets

	const 1 "test" aligned 1 0 00 1 ffff

positive: constant data section without link

	const 0 "test" aligned 1

positive: constant data section with link and missing reference

	const 0 "test" aligned 1

negative: constant data section with link and invalid reference

	const 0 "test" aligned 1 invalid

positive: constant data section with link and valid reference

	const 0 "test" aligned 1 "test"

positive: constant data section with link and missing patch

	const 0 "test" aligned 1 "test"

negative: constant data section with link patch and missing offset

	const 1 "test" aligned 1 "test" abs 0 0 0ff

negative: constant data section with link patch and invalid offset

	const 1 "test" aligned 1 "test" invalid abs 0 0 0ff

positive: constant data section with link patch and valid offset

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: constant data section with link patch and missing mode

	const 1 "test" aligned 1 "test" 0 0 0 0ff

negative: constant data section with link patch and invalid mode

	const 1 "test" aligned 1 "test" 0 invalid 0 0 0ff

positive: constant data section with link patch and absolute mode

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: constant data section with link patch and relative mode

	const 1 "test" aligned 1 "test" 0 rel 0 0 0ff

positive: constant data section with link patch and size mode

	const 1 "test" aligned 1 "test" 0 siz 0 0 0ff

positive: constant data section with link patch and extent mode

	const 1 "test" aligned 1 "test" 0 ext 0 0 0ff

positive: constant data section with link patch and position mode

	const 1 "test" aligned 1 "test" 0 pos 0 0 0ff

positive: constant data section with link patch and index mode

	const 1 "test" aligned 1 "test" 0 idx 0 0 0ff

positive: constant data section with link patch and count mode

	const 1 "test" aligned 1 "test" 0 cnt 0 0 0ff

negative: constant data section with link patch and missing displacement

	const 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: constant data section with link patch and invalid displacement

	const 1 "test" aligned 1 "test" 0 abs invalid 0 0ff

positive: constant data section with link patch and valid displacement

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: constant data section with link patch and missing scale

	const 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: constant data section with link patch and invalid scale

	const 1 "test" aligned 1 "test" 0 abs 0 invalid 0ff

positive: constant data section with link patch and valid scale

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: constant data section with link patch and missing pattern

	const 1 "test" aligned 1 "test" 0 abs 0 0

negative: constant data section with link patch and invalid pattern

	const 1 "test" aligned 1 "test" 0 abs 0 0 invalid

negative: constant data section with link patch and exceeding pattern

	const 0 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: constant data section with link patch and valid pattern

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: constant data section with link patch pattern and missing mask

	const 1 "test" aligned 1 "test" 0 abs 0 0

negative: constant data section with link patch pattern and invalid mask

	const 1 "test" aligned 1 "test" 0 abs 0 0 invalid

positive: constant data section with link patch pattern and valid mask

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: constant data section with link patch pattern mask and missing offset

	const 1 "test" aligned 1 "test" 0 abs 0 0 ff

negative: constant data section with link patch pattern mask and invalid offset

	const 1 "test" aligned 1 "test" 0 abs 0 0 invalidff

positive: constant data section with link patch pattern mask and valid offset

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: constant data section with link patch pattern mask and missing bitmask

	const 1 "test" aligned 1 "test" 0 abs 0 0 0

negative: constant data section with link patch pattern mask and invalid bitmask

	const 1 "test" aligned 1 "test" 0 abs 0 0 0invalid

negative: constant data section with link patch pattern mask and bitmask with spaces

	const 1 "test" aligned 1 "test" 0 abs 0 0 0f f

positive: constant data section with link patch pattern mask and valid bitmask

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: constant data section with link patch pattern mask and eight bitmasks

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff

negative: constant data section with link patch pattern mask and nine bitmasks

	const 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff0ff

# heading metadata sections

positive: empty heading metadata section

	header 0 "test" aligned 1

negative: heading metadata section with missing type

	0 "test" aligned 1

negative: heading metadata section with invalid type

	invalid 0 "test" aligned 1

positive: heading metadata section with valid type

	header 0 "test" aligned 1

negative: heading metadata section with missing size

	header "test" aligned 1

negative: heading metadata section with invalid size

	header invalid "test" aligned 1

positive: heading metadata section with valid size

	header 0 "test" aligned 1

positive: heading metadata section without options

	header 0 "test" aligned 1

negative: heading metadata section with invalid option

	header 0 invalid "test" aligned 1

positive: heading metadata section with required option

	header 0 required "test" aligned 1

positive: heading metadata section with required and duplicable option

	header 0 required duplicable "test" aligned 1

positive: heading metadata section with required and replaceable option

	header 0 required replaceable "test" aligned 1

positive: heading metadata section with required, duplicable and replaceable option

	header 0 required duplicable replaceable "test" aligned 1

positive: heading metadata section with required, replaceable, and duplicable option

	header 0 required replaceable duplicable "test" aligned 1

positive: heading metadata section with duplicable option

	header 0 duplicable "test" aligned 1

positive: heading metadata section with duplicable and required option

	header 0 duplicable required "test" aligned 1

positive: heading metadata section with duplicable and replaceable option

	header 0 duplicable replaceable "test" aligned 1

positive: heading metadata section with duplicable, required and replaceable option

	header 0 duplicable required replaceable "test" aligned 1

positive: heading metadata section with duplicable, replaceable and required option

	header 0 duplicable replaceable required "test" aligned 1

positive: heading metadata section with replaceable option

	header 0 replaceable "test" aligned 1

positive: heading metadata section with replaceable and required option

	header 0 replaceable required "test" aligned 1

positive: heading metadata section with replaceable and duplicable option

	header 0 replaceable duplicable "test" aligned 1

positive: heading metadata section with replaceable, required and duplicable option

	header 0 replaceable required duplicable "test" aligned 1

positive: heading metadata section with replaceable, duplicable and required option

	header 0 replaceable duplicable required "test" aligned 1

negative: heading metadata section with missing name

	header 0 aligned 1

negative: heading metadata section with invalid name

	header 0 invalid aligned 1

positive: heading metadata section with valid name

	header 0 "test" aligned 1

negative: heading metadata section with missing alias offset

	header 0 "test" "alias" "group" aligned 1

negative: heading metadata section with invalid alias offset

	header 0 "test" invalid "alias" aligned 1

negative: heading metadata section with exceeding alias offset

	header 0 "test" 1 "alias" aligned 1

positive: heading metadata section with valid alias offset

	header 0 "test" 0 "alias" aligned 1

negative: heading metadata section with missing alias name

	header 0 "test" 0 aligned 1

negative: heading metadata section with invalid alias name

	header 0 "test" 0 invalid aligned 1

positive: heading metadata section with valid alias name

	header 0 "test" 0 "alias" aligned 1

negative: heading metadata section with aliases and missing offset

	header 0 "test" 0 "alias1" "alias2" "group" aligned 1

negative: heading metadata section with aliases and invalid offset

	header 0 "test" 0 "alias1" invalid "alias2" aligned 1

negative: heading metadata section with aliases and exceeding offset

	header 0 "test" 0 "alias1" 1 "alias2" aligned 1

positive: heading metadata section with aliases and valid offset

	header 0 "test" 0 "alias1" 0 "alias2" aligned 1

negative: heading metadata section with aliases and missing name

	header 0 "test" 0 "alias1" 0 aligned 1

negative: heading metadata section with aliases and invalid name

	header 0 "test" 0 "alias1" 0 invalid aligned 1

positive: heading metadata section with aliases and valid name

	header 0 "test" 0 "alias1" 0 "alias2" aligned 1

positive: heading metadata section without group

	header 0 "test" aligned 1

negative: heading metadata section with invalid group

	header 0 "test" invalid aligned 1

positive: heading metadata section with valid group

	header 0 "test" "group" aligned 1

negative: heading metadata section with missing alignment

	header 0 "test" 1

negative: heading metadata section with invalid alignment

	header 0 "test" invalid 1

positive: heading metadata section with valid alignment

	header 0 "test" aligned 1

negative: heading metadata section with missing alignment value

	header 0 "test" aligned

negative: heading metadata section with invalid alignment value

	header 0 "test" aligned 3

positive: heading metadata section with valid alignment value

	header 0 "test" aligned 1

negative: heading metadata section with missing origin

	header 0 "test" 0

negative: heading metadata section with invalid origin

	header 0 "test" invalid 0

positive: heading metadata section with valid origin

	header 0 "test" fixed 0

negative: heading metadata section with missing origin value

	header 0 "test" fixed

negative: heading metadata section with invalid origin value

	header 0 "test" fixed invalid

positive: heading metadata section with valid origin value

	header 0 "test" fixed 0

positive: heading metadata section without segment

	header 0 "test" aligned 1

negative: heading metadata section with segment and missing offset

	header 1 "test" aligned 1 ff

negative: heading metadata section with segment and invalid offset

	header 1 "test" aligned 1 invalid ff

negative: heading metadata section with segment and exceeding offset

	header 0 "test" aligned 1 0 ff

positive: heading metadata section with segment and valid offset

	header 1 "test" aligned 1 0 ff

negative: heading metadata section with segment and missing octet

	header 1 "test" aligned 1 0

negative: heading metadata section with segment and exceeding octet

	header 0 "test" aligned 1 0 ff

negative: heading metadata section with segment and invalid octet

	header 1 "test" aligned 1 0 invalid

negative: heading metadata section with segment and single quartet

	header 1 "test" aligned 1 0 f

positive: heading metadata section with segment and two quartets

	header 1 "test" aligned 1 0 ff

negative: heading metadata section with segment and three quartets

	header 2 "test" aligned 1 0 fff

negative: heading metadata section with segment and quartets with spaces

	header 1 "test" aligned 1 0 f f

positive: heading metadata section with segment and several octets

	header 2 "test" aligned 1 0 ffff

negative: heading metadata section with segment and exceeding octets

	header 1 "test" aligned 1 1 ffff

negative: heading metadata section with segments and missing offset

	header 1 "test" aligned 1 0 00 ff

negative: heading metadata section with segments and invalid offset

	header 1 "test" aligned 1 0 00 invalid ff

negative: heading metadata section with segments and exceeding offset

	header 1 "test" aligned 1 0 00 1 ff

positive: heading metadata section with segments and valid offset

	header 1 "test" aligned 1 0 00 0 ff

negative: heading metadata section with segments and missing octet

	header 1 "test" aligned 1 0 00 0

negative: heading metadata section with segments and exceeding octet

	header 1 "test" aligned 1 0 00 1 ff

negative: heading metadata section with segments and invalid octet

	header 1 "test" aligned 1 0 00 0 invalid

negative: heading metadata section with segments and single quartet

	header 1 "test" aligned 1 0 00 0 f

positive: heading metadata section with segments and two quartets

	header 1 "test" aligned 1 0 00 0 ff

negative: heading metadata section with segments and three quartets

	header 2 "test" aligned 1 0 00 0 fff

negative: heading metadata section with segments and quartets with spaces

	header 1 "test" aligned 1 0 00 0 f f

positive: heading metadata section with segments and several octets

	header 2 "test" aligned 1 0 00 0 ffff

negative: heading metadata section with segments and exceeding octets

	header 1 "test" aligned 1 0 00 1 ffff

positive: heading metadata section without link

	header 0 "test" aligned 1

positive: heading metadata section with link and missing reference

	header 0 "test" aligned 1

negative: heading metadata section with link and invalid reference

	header 0 "test" aligned 1 invalid

positive: heading metadata section with link and valid reference

	header 0 "test" aligned 1 "test"

positive: heading metadata section with link and missing patch

	header 0 "test" aligned 1 "test"

negative: heading metadata section with link patch and missing offset

	header 1 "test" aligned 1 "test" abs 0 0 0ff

negative: heading metadata section with link patch and invalid offset

	header 1 "test" aligned 1 "test" invalid abs 0 0 0ff

positive: heading metadata section with link patch and valid offset

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: heading metadata section with link patch and missing mode

	header 1 "test" aligned 1 "test" 0 0 0 0ff

negative: heading metadata section with link patch and invalid mode

	header 1 "test" aligned 1 "test" 0 invalid 0 0 0ff

positive: heading metadata section with link patch and absolute mode

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: heading metadata section with link patch and relative mode

	header 1 "test" aligned 1 "test" 0 rel 0 0 0ff

positive: heading metadata section with link patch and size mode

	header 1 "test" aligned 1 "test" 0 siz 0 0 0ff

positive: heading metadata section with link patch and extent mode

	header 1 "test" aligned 1 "test" 0 ext 0 0 0ff

positive: heading metadata section with link patch and position mode

	header 1 "test" aligned 1 "test" 0 pos 0 0 0ff

positive: heading metadata section with link patch and index mode

	header 1 "test" aligned 1 "test" 0 idx 0 0 0ff

positive: heading metadata section with link patch and count mode

	header 1 "test" aligned 1 "test" 0 cnt 0 0 0ff

negative: heading metadata section with link patch and missing displacement

	header 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: heading metadata section with link patch and invalid displacement

	header 1 "test" aligned 1 "test" 0 abs invalid 0 0ff

positive: heading metadata section with link patch and valid displacement

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: heading metadata section with link patch and missing scale

	header 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: heading metadata section with link patch and invalid scale

	header 1 "test" aligned 1 "test" 0 abs 0 invalid 0ff

positive: heading metadata section with link patch and valid scale

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: heading metadata section with link patch and missing pattern

	header 1 "test" aligned 1 "test" 0 abs 0 0

negative: heading metadata section with link patch and invalid pattern

	header 1 "test" aligned 1 "test" 0 abs 0 0 invalid

negative: heading metadata section with link patch and exceeding pattern

	header 0 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: heading metadata section with link patch and valid pattern

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: heading metadata section with link patch pattern and missing mask

	header 1 "test" aligned 1 "test" 0 abs 0 0

negative: heading metadata section with link patch pattern and invalid mask

	header 1 "test" aligned 1 "test" 0 abs 0 0 invalid

positive: heading metadata section with link patch pattern and valid mask

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: heading metadata section with link patch pattern mask and missing offset

	header 1 "test" aligned 1 "test" 0 abs 0 0 ff

negative: heading metadata section with link patch pattern mask and invalid offset

	header 1 "test" aligned 1 "test" 0 abs 0 0 invalidff

positive: heading metadata section with link patch pattern mask and valid offset

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: heading metadata section with link patch pattern mask and missing bitmask

	header 1 "test" aligned 1 "test" 0 abs 0 0 0

negative: heading metadata section with link patch pattern mask and invalid bitmask

	header 1 "test" aligned 1 "test" 0 abs 0 0 0invalid

negative: heading metadata section with link patch pattern mask and bitmask with spaces

	header 1 "test" aligned 1 "test" 0 abs 0 0 0f f

positive: heading metadata section with link patch pattern mask and valid bitmask

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: heading metadata section with link patch pattern mask and eight bitmasks

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff

negative: heading metadata section with link patch pattern mask and nine bitmasks

	header 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff0ff

# trailing metadata sections

positive: empty trailing metadata section

	trailer 0 "test" aligned 1

negative: trailing metadata section with missing type

	0 "test" aligned 1

negative: trailing metadata section with invalid type

	invalid 0 "test" aligned 1

positive: trailing metadata section with valid type

	trailer 0 "test" aligned 1

negative: trailing metadata section with missing size

	trailer "test" aligned 1

negative: trailing metadata section with invalid size

	trailer invalid "test" aligned 1

positive: trailing metadata section with valid size

	trailer 0 "test" aligned 1

positive: trailing metadata section without options

	trailer 0 "test" aligned 1

negative: trailing metadata section with invalid option

	trailer 0 invalid "test" aligned 1

positive: trailing metadata section with required option

	trailer 0 required "test" aligned 1

positive: trailing metadata section with required and duplicable option

	trailer 0 required duplicable "test" aligned 1

positive: trailing metadata section with required and replaceable option

	trailer 0 required replaceable "test" aligned 1

positive: trailing metadata section with required, duplicable and replaceable option

	trailer 0 required duplicable replaceable "test" aligned 1

positive: trailing metadata section with required, replaceable, and duplicable option

	trailer 0 required replaceable duplicable "test" aligned 1

positive: trailing metadata section with duplicable option

	trailer 0 duplicable "test" aligned 1

positive: trailing metadata section with duplicable and required option

	trailer 0 duplicable required "test" aligned 1

positive: trailing metadata section with duplicable and replaceable option

	trailer 0 duplicable replaceable "test" aligned 1

positive: trailing metadata section with duplicable, required and replaceable option

	trailer 0 duplicable required replaceable "test" aligned 1

positive: trailing metadata section with duplicable, replaceable and required option

	trailer 0 duplicable replaceable required "test" aligned 1

positive: trailing metadata section with replaceable option

	trailer 0 replaceable "test" aligned 1

positive: trailing metadata section with replaceable and required option

	trailer 0 replaceable required "test" aligned 1

positive: trailing metadata section with replaceable and duplicable option

	trailer 0 replaceable duplicable "test" aligned 1

positive: trailing metadata section with replaceable, required and duplicable option

	trailer 0 replaceable required duplicable "test" aligned 1

positive: trailing metadata section with replaceable, duplicable and required option

	trailer 0 replaceable duplicable required "test" aligned 1

negative: trailing metadata section with missing name

	trailer 0 aligned 1

negative: trailing metadata section with invalid name

	trailer 0 invalid aligned 1

positive: trailing metadata section with valid name

	trailer 0 "test" aligned 1

negative: trailing metadata section with missing alias offset

	trailer 0 "test" "alias" "group" aligned 1

negative: trailing metadata section with invalid alias offset

	trailer 0 "test" invalid "alias" aligned 1

negative: trailing metadata section with exceeding alias offset

	trailer 0 "test" 1 "alias" aligned 1

positive: trailing metadata section with valid alias offset

	trailer 0 "test" 0 "alias" aligned 1

negative: trailing metadata section with missing alias name

	trailer 0 "test" 0 aligned 1

negative: trailing metadata section with invalid alias name

	trailer 0 "test" 0 invalid aligned 1

positive: trailing metadata section with valid alias name

	trailer 0 "test" 0 "alias" aligned 1

negative: trailing metadata section with aliases and missing offset

	trailer 0 "test" 0 "alias1" "alias2" "group" aligned 1

negative: trailing metadata section with aliases and invalid offset

	trailer 0 "test" 0 "alias1" invalid "alias2" aligned 1

negative: trailing metadata section with aliases and exceeding offset

	trailer 0 "test" 0 "alias1" 1 "alias2" aligned 1

positive: trailing metadata section with aliases and valid offset

	trailer 0 "test" 0 "alias1" 0 "alias2" aligned 1

negative: trailing metadata section with aliases and missing name

	trailer 0 "test" 0 "alias1" 0 aligned 1

negative: trailing metadata section with aliases and invalid name

	trailer 0 "test" 0 "alias1" 0 invalid aligned 1

positive: trailing metadata section with aliases and valid name

	trailer 0 "test" 0 "alias1" 0 "alias2" aligned 1

positive: trailing metadata section without group

	trailer 0 "test" aligned 1

negative: trailing metadata section with invalid group

	trailer 0 "test" invalid aligned 1

positive: trailing metadata section with valid group

	trailer 0 "test" "group" aligned 1

negative: trailing metadata section with missing alignment

	trailer 0 "test" 1

negative: trailing metadata section with invalid alignment

	trailer 0 "test" invalid 1

positive: trailing metadata section with valid alignment

	trailer 0 "test" aligned 1

negative: trailing metadata section with missing alignment value

	trailer 0 "test" aligned

negative: trailing metadata section with invalid alignment value

	trailer 0 "test" aligned 3

positive: trailing metadata section with valid alignment value

	trailer 0 "test" aligned 1

negative: trailing metadata section with missing origin

	trailer 0 "test" 0

negative: trailing metadata section with invalid origin

	trailer 0 "test" invalid 0

positive: trailing metadata section with valid origin

	trailer 0 "test" fixed 0

negative: trailing metadata section with missing origin value

	trailer 0 "test" fixed

negative: trailing metadata section with invalid origin value

	trailer 0 "test" fixed invalid

positive: trailing metadata section with valid origin value

	trailer 0 "test" fixed 0

positive: trailing metadata section without segment

	trailer 0 "test" aligned 1

negative: trailing metadata section with segment and missing offset

	trailer 1 "test" aligned 1 ff

negative: trailing metadata section with segment and invalid offset

	trailer 1 "test" aligned 1 invalid ff

negative: trailing metadata section with segment and exceeding offset

	trailer 0 "test" aligned 1 0 ff

positive: trailing metadata section with segment and valid offset

	trailer 1 "test" aligned 1 0 ff

negative: trailing metadata section with segment and missing octet

	trailer 1 "test" aligned 1 0

negative: trailing metadata section with segment and exceeding octet

	trailer 0 "test" aligned 1 0 ff

negative: trailing metadata section with segment and invalid octet

	trailer 1 "test" aligned 1 0 invalid

negative: trailing metadata section with segment and single quartet

	trailer 1 "test" aligned 1 0 f

positive: trailing metadata section with segment and two quartets

	trailer 1 "test" aligned 1 0 ff

negative: trailing metadata section with segment and three quartets

	trailer 2 "test" aligned 1 0 fff

negative: trailing metadata section with segment and quartets with spaces

	trailer 1 "test" aligned 1 0 f f

positive: trailing metadata section with segment and several octets

	trailer 2 "test" aligned 1 0 ffff

negative: trailing metadata section with segment and exceeding octets

	trailer 1 "test" aligned 1 1 ffff

negative: trailing metadata section with segments and missing offset

	trailer 1 "test" aligned 1 0 00 ff

negative: trailing metadata section with segments and invalid offset

	trailer 1 "test" aligned 1 0 00 invalid ff

negative: trailing metadata section with segments and exceeding offset

	trailer 1 "test" aligned 1 0 00 1 ff

positive: trailing metadata section with segments and valid offset

	trailer 1 "test" aligned 1 0 00 0 ff

negative: trailing metadata section with segments and missing octet

	trailer 1 "test" aligned 1 0 00 0

negative: trailing metadata section with segments and exceeding octet

	trailer 1 "test" aligned 1 0 00 1 ff

negative: trailing metadata section with segments and invalid octet

	trailer 1 "test" aligned 1 0 00 0 invalid

negative: trailing metadata section with segments and single quartet

	trailer 1 "test" aligned 1 0 00 0 f

positive: trailing metadata section with segments and two quartets

	trailer 1 "test" aligned 1 0 00 0 ff

negative: trailing metadata section with segments and three quartets

	trailer 2 "test" aligned 1 0 00 0 fff

negative: trailing metadata section with segments and quartets with spaces

	trailer 1 "test" aligned 1 0 00 0 f f

positive: trailing metadata section with segments and several octets

	trailer 2 "test" aligned 1 0 00 0 ffff

negative: trailing metadata section with segments and exceeding octets

	trailer 1 "test" aligned 1 0 00 1 ffff

positive: trailing metadata section without link

	trailer 0 "test" aligned 1

positive: trailing metadata section with link and missing reference

	trailer 0 "test" aligned 1

negative: trailing metadata section with link and invalid reference

	trailer 0 "test" aligned 1 invalid

positive: trailing metadata section with link and valid reference

	trailer 0 "test" aligned 1 "test"

positive: trailing metadata section with link and missing patch

	trailer 0 "test" aligned 1 "test"

negative: trailing metadata section with link patch and missing offset

	trailer 1 "test" aligned 1 "test" abs 0 0 0ff

negative: trailing metadata section with link patch and invalid offset

	trailer 1 "test" aligned 1 "test" invalid abs 0 0 0ff

positive: trailing metadata section with link patch and valid offset

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: trailing metadata section with link patch and missing mode

	trailer 1 "test" aligned 1 "test" 0 0 0 0ff

negative: trailing metadata section with link patch and invalid mode

	trailer 1 "test" aligned 1 "test" 0 invalid 0 0 0ff

positive: trailing metadata section with link patch and absolute mode

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: trailing metadata section with link patch and relative mode

	trailer 1 "test" aligned 1 "test" 0 rel 0 0 0ff

positive: trailing metadata section with link patch and size mode

	trailer 1 "test" aligned 1 "test" 0 siz 0 0 0ff

positive: trailing metadata section with link patch and extent mode

	trailer 1 "test" aligned 1 "test" 0 ext 0 0 0ff

positive: trailing metadata section with link patch and position mode

	trailer 1 "test" aligned 1 "test" 0 pos 0 0 0ff

positive: trailing metadata section with link patch and index mode

	trailer 1 "test" aligned 1 "test" 0 idx 0 0 0ff

positive: trailing metadata section with link patch and count mode

	trailer 1 "test" aligned 1 "test" 0 cnt 0 0 0ff

negative: trailing metadata section with link patch and missing displacement

	trailer 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: trailing metadata section with link patch and invalid displacement

	trailer 1 "test" aligned 1 "test" 0 abs invalid 0 0ff

positive: trailing metadata section with link patch and valid displacement

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: trailing metadata section with link patch and missing scale

	trailer 1 "test" aligned 1 "test" 0 abs 0 0ff

negative: trailing metadata section with link patch and invalid scale

	trailer 1 "test" aligned 1 "test" 0 abs 0 invalid 0ff

positive: trailing metadata section with link patch and valid scale

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: trailing metadata section with link patch and missing pattern

	trailer 1 "test" aligned 1 "test" 0 abs 0 0

negative: trailing metadata section with link patch and invalid pattern

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 invalid

negative: trailing metadata section with link patch and exceeding pattern

	trailer 0 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: trailing metadata section with link patch and valid pattern

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: trailing metadata section with link patch pattern and missing mask

	trailer 1 "test" aligned 1 "test" 0 abs 0 0

negative: trailing metadata section with link patch pattern and invalid mask

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 invalid

positive: trailing metadata section with link patch pattern and valid mask

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: trailing metadata section with link patch pattern mask and missing offset

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 ff

negative: trailing metadata section with link patch pattern mask and invalid offset

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 invalidff

positive: trailing metadata section with link patch pattern mask and valid offset

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff

negative: trailing metadata section with link patch pattern mask and missing bitmask

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0

negative: trailing metadata section with link patch pattern mask and invalid bitmask

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0invalid

negative: trailing metadata section with link patch pattern mask and bitmask with spaces

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0f f

positive: trailing metadata section with link patch pattern mask and valid bitmask

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff

positive: trailing metadata section with link patch pattern mask and eight bitmasks

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff

negative: trailing metadata section with link patch pattern mask and nine bitmasks

	trailer 1 "test" aligned 1 "test" 0 abs 0 0 0ff0ff0ff0ff0ff0ff0ff0ff0ff

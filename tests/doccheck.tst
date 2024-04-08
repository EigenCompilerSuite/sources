# Genric documentation test and validation suite
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

positive: empty document

# articles

positive: article missing text

	@

positive: article with text

	@ text

negative: article with invalid nesting level

	@@

negative: articles with invalid nesting level

	@
	@@@

positive: articles with valid nesting levels

	@
	@@
	@@@
	@@
	@@@
	@
	@@

# headings

positive: heading missing text

	=

positive: heading with text

	= text

negative: heading with invalid nesting level

	==

negative: headings with invalid nesting level

	=
	===

positive: headings with valid nesting levels

	=
	==
	===
	==
	===
	=
	==

# numbered list items

positive: numbered list item missing text

	#

positive: numbered list item with text

	# text

negative: numbered list item with invalid nesting level

	##

negative: numbered list items with invalid nesting level

	#
	###

positive: numbered list items with valid nesting levels

	#
	##
	###
	##
	###
	#
	##

# list items

positive: list item missing text

	*

positive: list item with text

	* text

negative: list item with invalid nesting level

	***

negative: list items with invalid nesting level

	*
	***

positive: list items with valid nesting levels

	*
	**
	***
	**
	***
	*
	**

# labels

negative: label missing prefix

	label>>

negative: label missing name

	<<>>

negative: label missing suffix

	<<label

positive: label with single name

	<<label>>

negative: label with two names

	<<label1 label2>>

negative: duplicated labels

	<<label>><<label>>

negative: duplicated labels in different articles

	@<<label>>
	@<<label>>

# links

negative: link missing prefix

	label]]

negative: link missing name

	[[]]

negative: link missing suffix

	label]]

positive: link with single name

	<<label>>
	[[label]]

negative: link with two names

	<<label>>
	[[label label]]

negative: link with unknown label

	[[label]]

positive: link before label

	[[label]]<<label>>

positive: link after label

	<<label>>[[label]]

positive: link before label in different articles

	@[[label]]
	@<<label>>

positive: link after label in different articles

	@<<label>>
	@[[label]]

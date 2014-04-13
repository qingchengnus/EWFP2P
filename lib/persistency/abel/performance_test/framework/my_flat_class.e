note
	description: "Summary description for {MY_FLAT_CLASS}."
	author: ""
	date: "$Date: 2013-12-20 16:08:05 +0100 (Fri, 20 Dec 2013) $"
	revision: "$Revision: 93780 $"

class
	MY_FLAT_CLASS

inherit
	FLAT_CLASS

create
	make

feature {NONE} -- Initialization

	make (id: INTEGER)
			-- Initialization for `Current'
		do
			default_create
			identifier := id
			a_string_8 := "string8"
			a_string_32 := "string32"
		end

feature

	identifier: INTEGER

	a_string_8: STRING_8

	a_string_32: STRING_32

end

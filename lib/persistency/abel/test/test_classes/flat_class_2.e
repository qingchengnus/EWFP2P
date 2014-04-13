note
	description: "Summary description for {FLAT_CLASS_2}."
	author: ""
	date: "$Date: 2014-01-10 10:05:53 +0100 (Fri, 10 Jan 2014) $"
	revision: "$Revision: 93949 $"

class
	FLAT_CLASS_2

inherit
	ANY
		redefine
			out
		end

create
	make

feature

	id: INTEGER

	int_value: INTEGER

	string_value: STRING

	set_id (an_id: like id)
		do
			id := an_id
		end

feature -- Output

	out: STRING
			-- <Precursor>
		do
			Result := id.out + ", " + int_value.out + ", " + string_value + "%N"
		end

feature {NONE}

	make (int: INTEGER; string: STRING)
		do
			int_value := int
			string_value := string
		end

end

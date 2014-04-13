note
	description: "In-memory database sample class."
	author: "Marco Piccioni"
	date: "$Date: 2014-01-10 10:05:53 +0100 (Fri, 10 Jan 2014) $"
	revision: "$Revision: 93949 $"

class
	TEST_PERSON

inherit
	ANY
		redefine out end

create
	make

feature {NONE} -- Initialization

	make (f_name, l_name: STRING; items: INTEGER)
			-- Initialization for `Current'.
		require
			f_name_exists: not f_name.is_empty
			l_name_exists: not l_name.is_empty
		do
			first_name := f_name
			last_name := l_name
			items_owned := items
		ensure
			f_name_set: f_name = first_name
			l_name_set: l_name = last_name
			items_owned_set: items_owned = items
		end

feature -- Access

	first_name: STRING
			-- The person's first name.

	last_name: STRING
			-- The person's last name.

	items_owned: INTEGER
			-- The number of items the person ownes.

feature -- Basic operations

	add_item
		do
			items_owned := items_owned + 1
		end

feature -- Output

	out: STRING
			-- <Precursor>
		do
			Result := first_name + " " + last_name + ", items: " + items_owned.out + "%N"
		end

invariant
	items_owned_negative: items_owned >= 0
end

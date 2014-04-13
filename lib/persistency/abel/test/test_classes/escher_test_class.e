note
	description: "Summary description for {ESCHER_TEST_CLASS}."
	author: ""
	date: "$Date: 2013-09-27 11:12:07 +0200 (Fri, 27 Sep 2013) $"
	revision: "$Revision: 93019 $"

class
	ESCHER_TEST_CLASS

inherit

	VERSIONED_CLASS

create
	make

feature {NONE} -- Initialization

	make (some_f: STRING; other_f: INTEGER)
			-- Initialization for `Current'.
		do
			some_field := some_f
			other_field := other_f
		end

feature

	some_field: STRING

	other_field: INTEGER

	version: INTEGER = 3

end

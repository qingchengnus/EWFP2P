note
	description: "Summary description for {ESCHER_TEST_CLASS_2}."
	author: ""
	date: "$Date: 2013-09-27 11:12:07 +0200 (Fri, 27 Sep 2013) $"
	revision: "$Revision: 93019 $"

class
	ESCHER_TEST_CLASS_2

	inherit
	VERSIONED_CLASS

	ARGUMENTS

create
	make

feature -- Version implementation
	version: INTEGER = 1

feature {NONE} -- Initialization

	make (v_1: STRING; v_2: INTEGER; v_3: STRING; v_4: STRING)
			-- Run application.
		do
			--| Add your code here
			test_string := v_1
			new_attr := v_2
			type_changed := v_3
			name_changed := v_4
		end

	test_string: STRING
	new_attr: INTEGER
	type_changed: STRING
	name_changed: STRING

end

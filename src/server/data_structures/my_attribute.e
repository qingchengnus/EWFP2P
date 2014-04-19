note
	description: "Summary description for {MY_ATTRIBUTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_ATTRIBUTE

create
	make
feature {ANY}
	make(a: INTEGER v: ARRAY[NATURAL_8])
		do
			attribute_name := a
			create value.make_from_array (v)
		end
	attribute_name: INTEGER
	value: ARRAY[NATURAL_8]
end

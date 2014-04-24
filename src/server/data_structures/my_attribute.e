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
	make(a: NATURAL_16 v: ARRAY[NATURAL_8])
		do
			attribute_name := a
			create value.make_from_array (v)
			if
				v.count // 4 = 0
			then
				occupied_length := v.count
			else
				occupied_length := v.count // 4 + 1 * 4
			end
		end
	attribute_name: NATURAL_16
	value: ARRAY[NATURAL_8]
	occupied_length: INTEGER
end

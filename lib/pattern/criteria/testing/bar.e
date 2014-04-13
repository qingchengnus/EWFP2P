note
	description: "Summary description for {BAR}."
	author: ""
	date: "$Date: 2013-12-20 16:08:05 +0100 (Fri, 20 Dec 2013) $"
	revision: "$Revision: 93780 $"

class
	BAR

inherit
	ANY
		redefine
			is_equal
		end

create
	make

feature

	make (s: READABLE_STRING_GENERAL)
		do
			value := s
		end

	value: READABLE_STRING_GENERAL

	is_equal (other: like Current): BOOLEAN
		do
			Result := value.same_string (other.value)
		end

end


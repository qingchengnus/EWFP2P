note
	description: "Summary description for {SHARED_SPECIAL}."
	author: ""
	date: "$Date: 2013-12-20 16:08:05 +0100 (Fri, 20 Dec 2013) $"
	revision: "$Revision: 93780 $"

class
	SHARED_SPECIAL

create
	make

feature

	special: SPECIAL [INTEGER]

	make (a_special: like special)
		do
			special := a_special
		end

end

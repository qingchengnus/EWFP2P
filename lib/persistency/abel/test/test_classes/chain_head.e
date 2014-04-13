note
	description: "Summary description for {CHAIN_HEAD}."
	author: ""
	date: "$Date: 2013-09-27 11:12:07 +0200 (Fri, 27 Sep 2013) $"
	revision: "$Revision: 93019 $"

class
	CHAIN_HEAD

create
	make

feature {NONE} -- Initialization

	make (t: CHAIN_TAIL)
			-- Initialization for `Current'.
		do
			tail := t
		end

feature

	level: INTEGER = 0

	tail: CHAIN_TAIL

end

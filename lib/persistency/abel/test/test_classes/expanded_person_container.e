note
	description: "Summary description for {EXPANDED_PERSON_CONTAINER}."
	author: ""
	date: "$Date: 2013-10-25 10:53:07 +0200 (Fri, 25 Oct 2013) $"
	revision: "$Revision: 93170 $"

class
	EXPANDED_PERSON_CONTAINER

create
	set_item

feature

	person: EXPANDED_PERSON

	integer: INTEGER

	item: ANY

	set_item (an_item: ANY)
		do
			item := an_item
		end

end

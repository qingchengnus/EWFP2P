note
	description: "Summary description for {ANY_LIST_BOX}."
	author: ""
	date: "$Date: 2013-12-20 16:08:05 +0100 (Fri, 20 Dec 2013) $"
	revision: "$Revision: 93780 $"

class
	ANY_LIST_BOX

create
	set_items

feature

	items: LINKED_LIST [ANY]

	set_items (an_item: LINKED_LIST [ANY])
		do
			items := an_item
		end


end

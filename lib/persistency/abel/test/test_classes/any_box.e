note
	description: "Summary description for {ANY_BOX}."
	author: ""
	date: "$Date: 2013-10-11 07:06:48 +0200 (Fri, 11 Oct 2013) $"
	revision: "$Revision: 93107 $"

class
	ANY_BOX
create
	set_item

feature

	item: ANY

	set_item (an_item: ANY)
		do
			item := an_item
		end

end

note
	description: "Summary description for {BODY_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BODY_PARSER
create
	make_from_packet

feature {ANY}
	make_from_packet(pkt: MY_PACKET)
		do
			create current_body.make_from_array(pkt)
			current_body.rebase (0)
			current_body := current_body.subarray (20, current_body.count - 1)
			current_body.rebase (0)
		end

	get_attributes: ARRAY[MY_ATTRIBUTE]
		do

		end
feature {NONE}
	current_body: ARRAY[NATURAL_8]
end

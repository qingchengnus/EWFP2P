note
	description: "Summary description for {UNKNOWN_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNKNOWN_HANDLER

inherit
	PROTOCOL_HANDLER
create
	make_from_packet
feature
	make_from_packet(packet: MY_PACKET)
		do

		end
	generate_response: MY_PACKET
		do
			create RESULT.make_empty
		end
	is_known: BOOLEAN
		do
			RESULT := false
		end
	validate_message: BOOLEAN
		do
			RESULT := false
		end
	generate_message: MESSAGE
		do
			create RESULT.make_invalid
		end
end

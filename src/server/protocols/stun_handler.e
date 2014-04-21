note
	description: "Summary description for {STUN_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUN_HANDLER

inherit
	PROTOCOL_HANDLER
create
	make_from_packet
feature
	make_from_packet(packet: MY_PACKET)
		do
			my_packet := packet
		end
	generate_response(request: REQUEST): MY_PACKET
		do
			create RESULT.make_empty
		end
feature {NONE}
	my_packet: MY_PACKET
end

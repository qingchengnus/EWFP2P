note
	description: "Summary description for {PROTOCOL_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PROTOCOL_HANDLER
feature
	make_from_packet(packet: MY_PACKET)
		deferred
		end
	generate_response(request: REQUEST): MY_PACKET
		deferred
		end
end

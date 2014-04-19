note
	description: "Summary description for {PACKET_PROCESS_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PACKET_PROCESS_MODULE
create
	make

feature {ANY}
	make
		do
			create validator
		end
	process_packet(packet: MY_PACKET): REQUEST
		do
			if
				validator.validate_packet (packet)
			then
				create RESULT.make_invalid
			else
				
			end
		end
feature {NONE}
	validator: PACKET_VALIDATOR
end

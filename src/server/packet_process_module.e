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
			create p_validator
			create r_generator
		end
	process_packet(packet: MY_PACKET): REQUEST

		do
			if
				p_validator.validate_packet (packet)
			then
				create RESULT.make_invalid
			else
				RESULT := r_generator.generate_request(packet)
			end
		end
feature {NONE}
	p_validator: PACKET_VALIDATOR
	r_generator: REQUEST_GENERATOR
end

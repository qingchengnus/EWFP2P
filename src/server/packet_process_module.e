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
		local
			protocol: INTEGER
		do
			packet.rebase (0)
			if
				(not validate_packet_length(packet)) or else demultiplex_packet(packet) = -1
			then
				create RESULT.make_invalid
			else
				protocol := demultiplex_packet(packet)
				if
					protocol = 0
				then
					create RESULT.make_invalid
				else
					create RESULT.make_invalid
				end
			end
		end
feature {NONE}
	p_validator: PACKET_VALIDATOR
	r_generator: REQUEST_GENERATOR
	validate_packet_length(packet: MY_PACKET): BOOLEAN
		do
			RESULT := packet.count >= 20
		end
	demultiplex_packet(packet: MY_PACKET): INTEGER
		local
			first_byte: NATURAL_8
			first_two_bits: NATURAL_8
		do
			first_byte := packet.at (0)
			first_two_bits := first_byte.bit_and (0b11000000)
			if
				first_two_bits = 0b11000000
			then
				RESULT := 1
			elseif
				first_two_bits = 0b00000000
			then
				RESULT := 0
			else
				RESULT := -1
			end
		end
end

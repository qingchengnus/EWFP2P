note
	description: "Summary description for {PACKET_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PACKET_VALIDATOR

feature

	validate_packet(packet: MY_PACKET): BOOLEAN
		local
			h_parser: HEADER_PARSER
		do
			create h_parser.make_from_packet (packet)
			RESULT := validate_length(packet, h_parser) and then validate_protocol(h_parser) and then validate_magic_cookie(h_parser)
		end

feature {NONE}

	packet_protocol: INTEGER

	validate_length(packet: MY_PACKET h_parser: HEADER_PARSER): BOOLEAN
		do
			RESULT := packet.count >= 20 and then h_parser.get_length + 20 = packet.count
		end

	validate_protocol(h_parser: HEADER_PARSER): BOOLEAN
		local
			protocol: INTEGER
		do
			protocol := h_parser.demultiplex
			if
				protocol = 0 or protocol = 3
			then
				packet_protocol := protocol
				RESULT := true
			else
				RESULT := false
			end
		end

	validate_magic_cookie(h_parser: HEADER_PARSER): BOOLEAN
		do
			if
				packet_protocol = 0
			then
				RESULT := true
			else
				RESULT := false
			end
		end


end

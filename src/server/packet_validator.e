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
			RESULT := validate_length(packet, h_parser) and then validate_protocol(h_parser) and then validate_magic_cookie(h_parser) and then validate_method(h_parser) and then validate_class(h_parser)
		end

feature {NONE}


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
				RESULT := true
			else
				RESULT := false
			end
		end

	validate_magic_cookie(h_parser: HEADER_PARSER): BOOLEAN
		local
			protocol: INTEGER
		do
			protocol := h_parser.demultiplex
			RESULT := protocol = 3 or else (protocol = 0 and then h_parser.verify_magic_cookie)
		end
	validate_method(h_parser: HEADER_PARSER): BOOLEAN
		local
			protocol: INTEGER
			method: INTEGER
		do
			protocol := h_parser.demultiplex
			method := h_parser.get_method
			if
				protocol = 0
			then
				RESULT := method = 1
			elseif
				protocol = 3
			then
				RESULT := method = 2 or else method = 3 or else method = 4
			else
				RESULT := false
			end
		end

	validate_class(h_parser: HEADER_PARSER): BOOLEAN
		local
			m_class: INTEGER
			method: INTEGER
		do
			m_class := h_parser.get_class
			method := h_parser.get_method
			if
				method = 1 or else method = 2 or else method = 3 or else method = 4
			then
				RESULT := m_class = 0 or else m_class = 2 or else m_class = 3
			end
		end

end

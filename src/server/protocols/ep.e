note
	description: "Summary description for {EP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EP_HANDLER

inherit
	PROTOCOL_HANDLER
create
	make_from_packet

feature
	make_from_packet(packet: MY_PACKET)
		do
			my_packet := packet
			create h_parser.make_from_packet (packet)
			create b_parser.make_from_packet (packet)
		end
	generate_response: MY_PACKET
		do
			create RESULT.make_empty
		end
	is_known: BOOLEAN
		do
			RESULT := true
		end
	validate_message: BOOLEAN
		do
			RESULT := validate_method and then validate_class
		end
	generate_message: MESSAGE
		do
			RESULT := current.generate_message_from_packet (my_packet)
		end
feature {NONE}
	my_packet: MY_PACKET
	h_parser: HEADER_PARSER
	b_parser: BODY_PARSER
	validate_method: BOOLEAN
		do
			RESULT := h_parser.get_method = 2 or else h_parser.get_method = 3 or else h_parser.get_method = 4
		end
	validate_class: BOOLEAN
		local
			m_class: INTEGER
		do
			m_class := h_parser.get_class
			RESULT := m_class = 0
		end
end

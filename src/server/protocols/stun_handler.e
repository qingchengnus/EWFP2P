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
	make_from_packet_and_data
feature
	make_from_packet_and_data(packet: MY_PACKET data: detachable NETWORK_SOCKET_ADDRESS)
		do
			my_packet := packet
			if
				attached data as network_address
			then
				n_addr := network_address
			else
				create n_addr.make_localhost (-1)
			end
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
			RESULT := validate_magic_cookie and then validate_method and then validate_class
		end
	generate_message: MESSAGE
		do
			RESULT := current.generate_message_from_packet (my_packet)
		end
feature {NONE}
	my_packet: MY_PACKET
	h_parser: HEADER_PARSER
	b_parser: BODY_PARSER
	n_addr: NETWORK_SOCKET_ADDRESS
	validate_magic_cookie: BOOLEAN
		local
			magic_cookie: ARRAY[NATURAL_8]
		do
			magic_cookie := h_parser.get_magic_cookie
			RESULT := magic_cookie.at (0) = 0x21 and magic_cookie.at (1) = 0x12 and magic_cookie.at (2) = 0xA4 and magic_cookie.at (3) = 0x42
		end
	validate_method: BOOLEAN
		do
			RESULT := h_parser.get_method = 1
		end
	validate_class: BOOLEAN
		local
			m_class: INTEGER
		do
			m_class := h_parser.get_class
			RESULT := m_class = 0 or else m_class = 1
		end
end

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
		end
	process_packet(packet: MY_PACKET data: detachable NETWORK_SOCKET_ADDRESS): PROTOCOL_HANDLER
		local
			protocol: INTEGER
			s_handler: STUN_HANDLER
			e_handler: EP_HANDLER
			u_handler: UNKNOWN_HANDLER
			h_parser: HEADER_PARSER
		do
			packet.rebase (0)
			create h_parser.make_from_packet (packet)
			if
				p_validator.validate_packet (packet)
			then
				create u_handler.make_from_packet(packet)
				RESULT := u_handler
			else
				protocol := h_parser.demultiplex
				if
					protocol = 0
				then
					create s_handler.make_from_packet_and_data(packet, data)
					RESULT := s_handler
				elseif
					protocol = 1
				then
					create e_handler.make_from_packet(packet)
					RESULT := e_handler
				else
					create u_handler.make_from_packet(packet)
					RESULT := u_handler
				end
			end
		end
feature {NONE}
	p_validator: PACKET_VALIDATOR
end

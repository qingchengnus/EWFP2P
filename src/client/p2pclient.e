note
	description : "ewfp2pclient application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	P2PCLIENT

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			soc1: detachable NETWORK_STREAM_SOCKET
			addr: NETWORK_SOCKET_ADDRESS
		do
			create soc1.make_client_by_port (8888, "localhost")
			create addr.make_any_local (9999)
			soc1.set_address (addr)
			soc1.bind
			soc1.connect


			process(soc1)


			soc1.cleanup



		rescue
            if soc1 /= Void then
                soc1.cleanup
            end
		end
	process(soc1: detachable NETWORK_STREAM_SOCKET)
		require
			socket_not_void: soc1 /= Void
		local
			pkt: MY_PACKET
			msg: MESSAGE
			user_command: STRING
		do
			from
				io.read_line
				user_command := io.last_string
			until
				user_command.is_case_insensitive_equal ("exit")
			loop
				if
					user_command.is_case_insensitive_equal ("hello")
				then
					io.put_string (user_command)
					create msg.make_invalid
					pkt := msg.generate_packet
					pkt.independent_store (soc1)
					if attached {MY_PACKET} pkt.retrieved (soc1) as packet then
						print("A packet received!")
						protocol_handler := packet_processor.process_packet(packet, soc2.peer_address)
						if
							protocol_handler.is_known
						then
							print("This is a known protocol!")
							current_response := message_processor.generate_response (protocol_handler)
						else
							print("This is an unknown protocol!")
							create current_response.make_empty
						end
						if
							not current_response.is_empty
						then
							current_response.independent_store (soc2)
							print("The packet is replied")
						end
					end
				end
				io.read_line
				user_command := io.last_string
			end


		end

end

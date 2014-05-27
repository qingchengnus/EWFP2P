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
			user_command: STRING
			command_parser: COMMAND_PARSER
		do
			create packet_processor.make
			create message_processor.make
			state := 0
			create id.make_empty
			my_local_port := -1;
			from
				io.putstring ("Welcome!")
				io.put_new_line
				io.read_line
				user_command := io.last_string
				create command_parser.make_from_command (user_command)
			until
				command_parser.method.is_case_insensitive_equal ("exit")
			loop
				if
					user_command.is_case_insensitive_equal ("hello")
				then
					io.put_string (user_command)
				end
				io.read_line
				user_command := io.last_string
				create command_parser.make_from_command (user_command)
			end
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
			protocol_handler: PROTOCOL_HANDLER
			current_response: MY_PACKET
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
						protocol_handler := packet_processor.process_packet(packet)
						if
							protocol_handler.is_known
						then
							print("This is a known protocol!")
							current_response := message_processor.generate_response (protocol_handler)
						else
							print("This is an unknown protocol!")
							create current_response.make_empty
						end
					end
				end
				io.read_line
				user_command := io.last_string
			end


		end
	packet_processor: PACKET_PROCESS_MODULE
	message_processor: MESSAGE_PROCESS_MODULE
	state: INTEGER
	id: ARRAY[NATURAL_8]
	my_local_port: INTEGER
end

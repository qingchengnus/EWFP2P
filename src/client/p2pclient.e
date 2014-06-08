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
			print ("Hello Eiffel World!%N")
			create packet_processor.make
			create message_processor.make
			state := 0
			create id.make_empty
			create key.make_empty
			my_local_port := -1;
			from
				user_command := get_user_command
				create command_parser.make_from_command (user_command)
			until
				command_parser.method.is_case_insensitive_equal ("exit")
			loop
				if
					command_parser.method.is_case_insensitive_equal ("register")
				then
					create soc1.make_client_by_port (command_parser.params.at (1).to_integer_32, command_parser.params.at (0))
					create addr.make_any_local (command_parser.params.at (2).to_integer_32)
					if
						soc1 /= Void
					then
						soc1.set_address (addr)
						soc1.bind
						soc1.connect
						process(soc1, command_parser)
						soc1.close
					end
--					if
--						state < 2
--					then
--						print_feedback("Set server address and local port before register.", 1)
--					else
--						if
--							soc1 /= Void
--						then
--							process(soc1, command_parser)
--						end

--					end
				elseif
					command_parser.method.is_case_insensitive_equal ("query")
				then
					create soc1.make_client_by_port (command_parser.params.at (1).to_integer_32, command_parser.params.at (0))
					if
						soc1 /= Void
					then
						soc1.connect
						process(soc1, command_parser)
						soc1.close
					end
				end

				user_command := get_user_command

				create command_parser.make_from_command (user_command)
			end
--			create soc1.make_client_by_port (8888, "localhost")
--			create addr.make_any_local (9999)
--			soc1.set_address (addr)
--			soc1.bind
--			soc1.connect
--			process(soc1)


--			soc1.cleanup



		rescue
			print ("Exception catched!%N")
            if soc1 /= Void then
                soc1.cleanup
            end
		end
	process(soc1: detachable NETWORK_STREAM_SOCKET command: COMMAND_PARSER)
		require
			socket_not_void: soc1 /= Void
		local
			pkt: MY_PACKET
			msg: MESSAGE
			user_command: STRING
			protocol_handler: PROTOCOL_HANDLER
			current_response: MY_PACKET
			command_parser: COMMAND_PARSER
			magic_cookie: ARRAY[NATURAL_8]
			transaction_id: ARRAY[NATURAL_8]
			identification: ARRAY[NATURAL_8]
			current_attribute: MY_ATTRIBUTE
			comprehension_required_attributes: ARRAY [MY_ATTRIBUTE]
			comprehension_optional_attributes: ARRAY [MY_ATTRIBUTE]
			feedback: FEEDBACK
		do
			magic_cookie := generate_magic_cookie
			transaction_id := generate_transaction_id
			create comprehension_required_attributes.make_empty
			create comprehension_optional_attributes.make_empty
			create msg.make_invalid
			if
				command.method.is_case_insensitive_equal ("register")
			then

				identification := generate_identification

				create current_attribute.make (0x22, identification)
				comprehension_required_attributes.force (current_attribute, 0)
				create msg.make (3, 2, 0, magic_cookie, transaction_id, comprehension_required_attributes, comprehension_optional_attributes)
				pkt := msg.generate_packet
				pkt.independent_store (soc1)
				if attached {MY_PACKET} pkt.retrieved (soc1) as packet then
					print("A packet received!")
					protocol_handler := packet_processor.process_packet(packet)
					feedback := message_processor.generate_feedback (protocol_handler)
					if
						feedback.get_status = 0
					then
						state := 3
						key := feedback.get_data
					end
					print_feedback(feedback.get_comment, feedback.get_status)
				end
			elseif
				command.method.is_case_insensitive_equal ("query")
			then
				identification := convert_string_to_id(command.params.at (2))
				create current_attribute.make (0x22, identification)
				comprehension_required_attributes.force (current_attribute, 0)
				create msg.make (3, 4, 0, magic_cookie, transaction_id, comprehension_required_attributes, comprehension_optional_attributes)
				pkt := msg.generate_packet
				pkt.independent_store (soc1)
				if attached {MY_PACKET} pkt.retrieved (soc1) as packet then
					print("A packet received!")
					protocol_handler := packet_processor.process_packet(packet)
					feedback := message_processor.generate_feedback (protocol_handler)
					if
						feedback.get_status = 0
					then
						state := 3
						key := feedback.get_data
					end
					print_feedback(feedback.get_comment, feedback.get_status)
				end
			end


		rescue
			print ("Server disconnected!%N")
            if soc1 /= Void then
                soc1.cleanup
            end

		end
	packet_processor: PACKET_PROCESS_MODULE
	message_processor: MESSAGE_PROCESS_MODULE
	state: INTEGER
	id: ARRAY[NATURAL_8]
	key: ARRAY[NATURAL_8]
	my_local_port: INTEGER


	get_user_command: STRING
		local
			user_command:STRING
		do
			from
				io.read_line
				user_command := io.last_string
				user_command.trim
			until
				not user_command.is_equal ("")
			loop
				io.read_line
				user_command := io.last_string
				user_command.trim
			end
			RESULT := user_command
		end
	print_feedback(feedback: STRING status:INTEGER)
		do
			if
				status = 0
			then
				io.put_string ("Success: " + feedback)
			elseif
				status = 1
			then
				io.put_string ("Failure: " + feedback)
			elseif
				status = 2
			then
				io.put_string ("Error: " + feedback)
			end
			io.put_new_line
		end
	generate_magic_cookie: ARRAY[NATURAL_8]
		do
			create RESULT.make_filled (0, 0, 3)
			RESULT.put (0x21, 0)
			RESULT.put (0x12, 1)
			RESULT.put (0xA4, 2)
			RESULT.put (0x42, 3)
		end
	generate_transaction_id: ARRAY[NATURAL_8]
		local
			i: INTEGER
			random_generator: RANDOM
			current_time: TIME
			current_byte: INTEGER
		do
			create RESULT.make_filled (0, 0, 11)
			create random_generator.make
			create current_time.make_now
			random_generator.set_seed (current_time.compact_time)

			from
				i := 0
				random_generator.start
			until
				i = 12
			loop
				current_byte := random_generator.item // 256
				RESULT.put(current_byte.to_natural_8, i)
				random_generator.forth
				i := i + 1
			end
		end

	generate_identification: ARRAY[NATURAL_8]
		local
			i: INTEGER
			random_generator: RANDOM
			current_time: TIME
			current_byte: INTEGER
		do
			create RESULT.make_filled (0, 0, 15)
			create random_generator.make
			create current_time.make_now
			random_generator.set_seed (current_time.compact_time)

			from
				i := 0
				random_generator.start
			until
				i = 16
			loop
				current_byte := random_generator.item // 256
				RESULT.put(current_byte.to_natural_8, i)
				random_generator.forth
				i := i + 1
			end
		end
	convert_id_to_string(from_id: ARRAY[NATURAL_8]): STRING
		local
			i: INTEGER
			length: INTEGER
		do
			from
				i := 0
				length := from_id.count
				RESULT := ""
			until
				i = length
			loop
				RESULT := RESULT + from_id.at (i).out + "-"
				i := i + 1
			end

		end
	convert_string_to_id(from_string: STRING): ARRAY[NATURAL_8]
		local
			id_in_bytes: LIST[STRING]
			i: INTEGER
		do
			from_string.trim
			id_in_bytes := from_string.split ('-')
			create RESULT.make_filled (0, 0, 15)
			from
				i := 0
				id_in_bytes.start
			until
				id_in_bytes.after
			loop
				RESULT.put (id_in_bytes.item.to_natural_8, i)
				i := i + 1
			end
		end
end

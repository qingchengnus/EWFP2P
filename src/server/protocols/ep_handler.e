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
			create h_parser.make_from_packet (packet)
			create b_parser.make_from_packet (packet)
			my_message := packet.generate_message
			are_attributes_valid := validate_attributes
			create target_record.make_invalid
		end
	generate_response(action_done: BOOLEAN record_list: MY_RECORD_LIST): MY_PACKET
		do
			create RESULT.make_empty
		end
	generate_action: ACTION
		do
			create RESULT.make_no_action
			if
				validate_attributes
			then
				inspect
					my_message.message_class
				when 0 then
					inspect
						my_message.method
					when 2 then
						create target_record.make_from_id (id)
						create RESULT.make (0, target_record)
					when 3 then
						create target_record.make (id, key, ip_addr, port)
						create RESULT.make (1, target_record)
					when 4 then
						create RESULT.make_no_action
					else
						create RESULT.make_no_action
					end
				else
					create RESULT.make_no_action
				end
				action_notified := true
			else
				create RESULT.make_no_action
			end

		end
	is_known: BOOLEAN
		do
			RESULT := true
		end
	validate_message: BOOLEAN
		do
			RESULT := validate_method and then validate_class
		end
feature {NONE}
	my_message: MESSAGE
	h_parser: HEADER_PARSER
	b_parser: BODY_PARSER
	id: NATURAL_64
	key: NATURAL_64
	ip_addr: NATURAL_32
	port: NATURAL_32
	are_attributes_valid: BOOLEAN
	target_record: MY_RECORD
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
	validate_attributes: BOOLEAN
		local
			length_correctness: BOOLEAN
			attr_1_correctness: BOOLEAN
			attr_2_correctness: BOOLEAN
			attr_3_correctness: BOOLEAN
		do
			inspect
				my_message.method
			when 2 then
				length_correctness := my_message.comprehension_required_attributes.count = 1
				attr_1_correctness := contain_attribute(my_message.comprehension_required_attributes, 0x0022)
				RESULT := length_correctness and attr_1_correctness
			when 3 then
				length_correctness := my_message.comprehension_required_attributes.count = 3
				attr_1_correctness := contain_attribute(my_message.comprehension_required_attributes, 0x0022)
				attr_2_correctness := contain_attribute(my_message.comprehension_required_attributes, 0x0023)
				attr_3_correctness := contain_attribute(my_message.comprehension_required_attributes, 0x0024)
				RESULT := length_correctness and then attr_1_correctness and then attr_2_correctness and then attr_3_correctness
			when 4 then
				length_correctness := my_message.comprehension_required_attributes.count = 1
				attr_1_correctness := contain_attribute(my_message.comprehension_required_attributes, 0x0022)
				RESULT := length_correctness and attr_1_correctness
			else
				RESULT := false
			end
		end
	contain_attribute(attributes_list: ARRAY[MY_ATTRIBUTE] target_attribute_name: NATURAL_16): BOOLEAN
		local
			i: INTEGER
			j: INTEGER
		do
			from
				i := 0
			until
				RESULT or else i = attributes_list.count
			loop
				RESULT := attributes_list.at (i).attribute_name = target_attribute_name
				if
					RESULT
				then
					inspect
						target_attribute_name
					when 0x0022 then
						from
							id := 0
							j := 0
						until
							j = 8
						loop
							id := id.bit_or (attributes_list.at (i).value[j].as_natural_64.bit_shift_left (8 * (7 - j)))
						end
					when
						0x0023
					then
						from
							port := 0
							j := 0
						until
							j = 2
						loop
							port := port.bit_or (attributes_list.at (i).value[2 + j].as_natural_32.bit_shift_left (8 * (1 - j)))
						end
						from
							ip_addr := 0
							j := 0
						until
							j = 4
						loop
							ip_addr := ip_addr.bit_or (attributes_list.at (i).value[4 + j].as_natural_32.bit_shift_left (8 * (3 - j)))
						end

					when
						0x0024
					then
						from
							key := 0
							j := 0
						until
							j = 8
						loop
							key := key.bit_or (attributes_list.at (i).value[j].as_natural_64.bit_shift_left (8 * (7 - j)))
						end
					else

					end
				end
				i := i + 1
			end
		end

end

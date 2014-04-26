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
		end
	generate_response(action_done: BOOLEAN record_list: MY_RECORD_LIST): MY_PACKET
		do
			create RESULT.make_empty
		end
	generate_action: ACTION
		local
			target_record: MY_RECORD
		do
			if
				validate_attributes
			then
				inspect
					my_message.message_class
				when 0 then
					inspect
						my_message.method
					when 2 then

					else
						create target_record.make_from_id (my_message.generate_packet)
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
						id := 
					else

					end
				end
				i := i + 1
			end
		end
end

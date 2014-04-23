note
	description: "Summary description for {PROTOCOL_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PROTOCOL_HANDLER
feature
	generate_response(action_done: BOOLEAN record_list: MY_RECORD_LIST): MY_PACKET
		require
			action_notified: action_notified
		deferred
		end
	is_known: BOOLEAN
		deferred
		end
	validate_message: BOOLEAN
		deferred
		end
	generate_action: ACTION
		require
			action_not_notified: not action_notified
		deferred
		ensure
			action_notified: action_notified
		end
	action_notified: BOOLEAN
feature {PROTOCOL_HANDLER}

	generate_message_from_packet(packet: MY_PACKET): MESSAGE
		local
			protocol: INTEGER
			method: INTEGER
			message_class: INTEGER
			transaction_id: STRING
			all_attributes: ARRAY[MY_ATTRIBUTE]
			current_attribute: MY_ATTRIBUTE
			required_attributes: ARRAY[MY_ATTRIBUTE]
			optional_attributes: ARRAY[MY_ATTRIBUTE]
			length: INTEGER
			h_parser: HEADER_PARSER
			b_parser: BODY_PARSER
			count: INTEGER
			r_count: INTEGER
			o_count: INTEGER
		do
			create h_parser.make_from_packet (packet)
			create b_parser.make_from_packet (packet)
			protocol := h_parser.demultiplex
			method := h_parser.get_method
			message_class := h_parser.get_class
			transaction_id := h_parser.get_transaction_id
			length := h_parser.get_length
			if
				length = 20
			then
				create required_attributes.make_empty
				create optional_attributes.make_empty
				create RESULT.make (protocol, method, message_class, transaction_id, required_attributes, optional_attributes)
			else
				all_attributes := b_parser.get_attributes
				create required_attributes.make_empty
				create optional_attributes.make_empty
				from
					count := 0
					r_count := 0
					o_count := 0
				until
					count = all_attributes.count
				loop
					current_attribute := all_attributes.at (count)
					if
						current_attribute.attribute_name >= 0x0000 and current_attribute.attribute_name <= 0x7fff
					then
						required_attributes.put (current_attribute, r_count)
						r_count := r_count + 1
					else
						optional_attributes.put (current_attribute, o_count)
						o_count := o_count + 1
					end
				end
				create RESULT.make (protocol, method, message_class, transaction_id, required_attributes, optional_attributes)
			end

		end
end

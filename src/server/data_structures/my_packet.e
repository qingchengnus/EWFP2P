note
	description: "Summary description for {MY_PACKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_PACKET

inherit

    ARRAY[NATURAL_8]

    STORABLE
        undefine
            is_equal, copy
        end

create

    make_from_array, make_filled, make_empty

feature
	fill_with_array(fill_from: INTEGER filler: ARRAY[NATURAL_8])
		require
			valid_from: current.valid_index (fill_from)
			valid_filler_length: current.valid_index (fill_from + filler.count)
		local
			counter: INTEGER
		do
			from
				counter := 0
			until
				counter = filler.count
			loop
				current.put (filler.at (counter), fill_from + counter)
				counter := counter + 1
			end
		end
	generate_message: MESSAGE
		local
			protocol: INTEGER
			method: INTEGER
			message_class: INTEGER
			transaction_id: ARRAY[NATURAL_8]
			all_attributes: ARRAY[MY_ATTRIBUTE]
			current_attribute: MY_ATTRIBUTE
			required_attributes: ARRAY[MY_ATTRIBUTE]
			optional_attributes: ARRAY[MY_ATTRIBUTE]
			length: INTEGER
			h_parser: HEADER_PARSER
			b_parser: BODY_PARSER
			counter: INTEGER
			r_count: INTEGER
			o_count: INTEGER
		do
			create h_parser.make_from_packet (current)
			create b_parser.make_from_packet (current)
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
				create RESULT.make (protocol, method, message_class, h_parser.get_magic_cookie, transaction_id, required_attributes, optional_attributes)
			else
				all_attributes := b_parser.get_attributes
				create required_attributes.make_empty
				create optional_attributes.make_empty
				from
					counter := 0
					r_count := 0
					o_count := 0
				until
					counter = all_attributes.count
				loop
					current_attribute := all_attributes.at (counter)
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
				create RESULT.make (protocol, method, message_class, h_parser.get_magic_cookie, transaction_id, required_attributes, optional_attributes)
			end

		end
end

note
	description: "Summary description for {REQUEST_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_GENERATOR

feature
	generate_request(packet: MY_PACKET): REQUEST
		local
			protocol: INTEGER
			method: INTEGER
			message_class: INTEGER
			transaction_id: STRING
			required_attributes: ARRAY[MY_ATTRIBUTE]
			optional_attributes: ARRAY[MY_ATTRIBUTE]
			length: INTEGER
			h_parser: HEADER_PARSER
		do
			create h_parser.make_from_packet (packet)
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

			end

		end
feature {NONE}
end

note
	description: "Summary description for {REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST

create
	make, make_invalid

feature {ANY}
	make(p: INTEGER m: INTEGER c: INTEGER t: STRING cra: ARRAY[MY_ATTRIBUTE] coa: ARRAY[MY_ATTRIBUTE])
		do
			protocol := p
			method := m
			message_class := c
			create transaction_id.make_from_string (t)
			create comprehension_required_attributes.make_from_array (cra)
			create comprehension_optional_attributes.make_from_array (coa)
			is_valid := true
		end
	make_invalid
		do
			protocol := 0
			method := 0
			message_class := 0
			create transaction_id.make_empty
			create comprehension_required_attributes.make_empty
			create comprehension_optional_attributes.make_empty
			is_valid := false
		end
	protocol: INTEGER
	method: INTEGER
	message_class: INTEGER
	transaction_id: STRING
	comprehension_required_attributes: ARRAY[MY_ATTRIBUTE]
	comprehension_optional_attributes: ARRAY[MY_ATTRIBUTE]
	is_valid: BOOLEAN
end

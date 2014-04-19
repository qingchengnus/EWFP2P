note
	description: "Summary description for {RESPONSE_GENERATE_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RESPONSE_GENERATE_MODULE

feature {ANY}
	generate_response(request: REQUEST): MY_PACKET
		do
			create RESULT.make_empty
		end
end

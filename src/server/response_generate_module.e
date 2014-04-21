note
	description: "Summary description for {RESPONSE_GENERATE_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RESPONSE_GENERATE_MODULE

feature {ANY}
	generate_response(request: REQUEST): MY_PACKET
		require
			valid_request: request.is_valid
		do
			create RESULT.make_empty
		end

feature {NONE}
end

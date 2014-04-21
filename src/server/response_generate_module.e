note
	description: "Summary description for {RESPONSE_GENERATE_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE_PROCESS_MODULE

feature {ANY}
	generate_response(handler: PROTOCOL_HANDLER): MY_PACKET
		do
			create RESULT.make_empty
		end

feature {NONE}
end

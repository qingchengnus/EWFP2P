note
	description: "An example error visitor."
	author: "Roman Schmocker"
	date: "$Date: 2014-01-17 09:52:22 +0100 (Fri, 17 Jan 2014) $"
	revision: "$Revision: 94038 $"

class
	MY_PRIVATE_VISITOR

inherit
	PS_DEFAULT_ERROR_VISITOR
		redefine
			visit_transaction_aborted_error,
			visit_connection_setup_error
		end

feature -- Visitor features

	visit_transaction_aborted_error (transaction_aborted_error: PS_TRANSACTION_ABORTED_ERROR)
		-- Visit a transaction aborted error
		do
			print ("Transaction aborted")
		end

	visit_connection_setup_error (connection_setup_error: PS_CONNECTION_SETUP_ERROR)
		-- Visit a connection setup error
		do
			print ("Wrong login")
		end

end

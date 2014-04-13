note
	description: "Indicates any error that happens inside ABEL."
	author: "Roman Schmocker"
	date: "$Date: 2013-09-27 11:12:07 +0200 (Fri, 27 Sep 2013) $"
	revision: "$Revision: 93019 $"

class
	PS_INTERNAL_ERROR

inherit
	PS_ERROR
		redefine
			tag, accept, default_create
		end

feature -- Access

	tag: IMMUTABLE_STRING_32
			-- A short message describing what the current error is
		once
			create Result.make_from_string_8 ("Internal error")
		end

feature {PS_ERROR_VISITOR} -- Visitor pattern

	accept (a_visitor: PS_ERROR_VISITOR)
			-- `accept' function of the visitor pattern
		do
			a_visitor.visit_internal_error (Current)
		end

feature {NONE} -- Initialization

	default_create
			-- Create a new instance of this error
		do
			backend_error_code := -1
			set_description ("Something bad happened within the ABEL library")
		end

end

note
	description: "Represents a violation of an integrity constraint in the database backend."
	author: "Roman Schmocker"
	date: "$Date: 2013-10-11 07:06:48 +0200 (Fri, 11 Oct 2013) $"
	revision: "$Revision: 93107 $"

class
	PS_INTEGRITY_CONSTRAINT_VIOLATION_ERROR

inherit
	PS_OPERATION_ERROR
		redefine
			tag, accept, default_create
		end

feature -- Access

	tag: IMMUTABLE_STRING_32
			-- A short message describing what the current error is
		once
			create Result.make_from_string_8 ("Integrity constraint violation")
		end

feature {PS_ERROR_VISITOR} -- Visitor pattern

	accept (a_visitor: PS_ERROR_VISITOR)
			-- `accept' function of the visitor pattern
		do
			a_visitor.visit_integrity_constraint_violation_error (Current)
		end

feature {NONE} -- Initialization

	default_create
			-- Create a new instance of this error
		do
			backend_error_code := -1
			set_description ("The requested operation violates a data integrity constraint.")
		end

end

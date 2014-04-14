note
	description: "Wrapper for a data structure that should not be modified."
	author: "Roman Schmocker"
	date: "$Date: 2014-01-10 10:05:53 +0100 (Fri, 10 Jan 2014) $"
	revision: "$Revision: 93949 $"

class
	PS_IMMUTABLE_STRUCTURE [G]

inherit
	READABLE_INDEXABLE [G]

create
	make

feature {NONE} -- Initialization

	make (a_structure: READABLE_INDEXABLE [G])
			-- Initialization for `Current'.
		do
			structure := a_structure
		end

feature -- Access

	item alias "[]" (i: INTEGER): G
			-- Entry at position `i'.
		do
			Result:= structure [i]
		end

feature -- Measurement

	index_set: INTEGER_INTERVAL
			-- Range of acceptable indices.
		do
			Result := structure.index_set
		end

	count: INTEGER
			-- Number of items.
		do
			Result := index_set.count
		end

feature -- Status report

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		do
			Result:= structure.valid_index (i)
		end

	is_empty: BOOLEAN
			-- Is `Current' empty?
		do
			Result := count = 0
		end

feature -- Iteration

	do_all (action: PROCEDURE [ANY, TUPLE [G]])
			-- Apply `action' to every item.
		do
			across
				structure as cursor
			loop
				action.call ([cursor.item])
			end
		end

	for_all (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN
			-- Is `test' true for all items?
		do
			Result :=
				across
					structure as cursor
				all
					test.item ([cursor.item])
				end
		end

feature {NONE} -- Implementation

	structure: READABLE_INDEXABLE [G]
			-- The wrapped structure.

end
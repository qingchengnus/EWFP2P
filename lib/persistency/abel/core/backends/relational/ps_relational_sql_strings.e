note
	description: "Summary description for {PS_RELATIONAL_SQL_STRINGS}."
	author: ""
	date: "$Date: 2014-01-17 09:52:22 +0100 (Fri, 17 Jan 2014) $"
	revision: "$Revision: 94038 $"

deferred class
	PS_RELATIONAL_SQL_STRINGS

feature

	show_tables: STRING
		deferred
		end

	assemble_upsert (table: READABLE_STRING_8; columns: LIST [STRING]; values: LIST [STRING]): STRING
		deferred
		end
end

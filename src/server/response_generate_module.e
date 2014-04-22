note
	description: "Summary description for {RESPONSE_GENERATE_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE_PROCESS_MODULE
create
	make
feature {ANY}
	make
		do
			create my_record_list.make
		end
	generate_response(handler: PROTOCOL_HANDLER): MY_PACKET
		do
			create RESULT.make_empty
		end

feature {NONE}
	my_record_list: LINKED_LIST[MY_RECORD]
	find_record(record_id: NATURAL_64): MY_RECORD
		local
			found: BOOLEAN
		do
			from
				found := false
				my_record_list.start
				create RESULT.make_invalid
			until
				found or my_record_list.after
			loop
				if
					my_record_list.item.get_id = record_id
				then
					RESULT := my_record_list.item
					found := true
				end
				my_record_list.forth
			end
		end
	add_record(record: MY_RECORD): BOOLEAN
		local
			existed_record: MY_RECORD
		do
			existed_record := find_record(record.get_id)
			if
				existed_record.is_valid
			then
				RESULT := false
			else
				my_record_list.put (record)
				RESULT := true
			end
		end
	edit_record(record_id: NATURAL_64 updated_ipv4_addr: NATURAL_32 updated_port: NATURAL_32): BOOLEAN
		local
			found: BOOLEAN
		do
			from
				found := false
				my_record_list.start
				RESULT := false
			until
				RESULT or my_record_list.after
			loop
				if
					my_record_list.item.get_id = record_id
				then
					my_record_list.item.set_ipv4_addr(updated_ipv4_addr)
					my_record_list.item.set_port(updated_port)
					RESULT := true
				end
				my_record_list.forth
			end
		end
end

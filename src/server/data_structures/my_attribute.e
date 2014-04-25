note
	description: "Summary description for {MY_ATTRIBUTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MY_ATTRIBUTE

feature {ANY}
	make(a: NATURAL_16 v: ARRAY[NATURAL_8])
		do
			attribute_name := a
			create value.make_from_array (v)
			if
				v.count // 4 = 0
			then
				occupied_length := v.count
			else
				occupied_length := v.count // 4 + 1 * 4
			end
		end
	attribute_name: NATURAL_16
	occupied_length: INTEGER

	make_from_packet(packet: ARRAY[NATURAL_8])
		deferred
		end
	generate_packet: ARRAY[NATURAL_8]
		deferred
		end
feature {MY_ATTRIBUTE}
	get_name_length(packet: ARRAY[NATURAL_8])
		do
			packet.rebase (0)
			attribute_name := packet.at (0).as_natural_16.bit_shift_left (8).bit_or (packet.at (1).as_natural_16)
			occupied_length := packet.at (2).as_natural_16.bit_shift_left (8).bit_or (packet.at (3).as_natural_16)
		end

	generate_packet_with_name_length: ARRAY[NATURAL_8]
		do
			create RESULT.make_filled (0, 0, 3)
			RESULT.at (0) := attribute_name.bit_shift_right (8).as_natural_8
			RESULT.at (1) := attribute_name.bit_and (0x00FF).as_natural_8
			RESULT.at (2) := attribute_name.bit_shift_right (8).as_natural_8
			RESULT.at (3) := attribute_name.bit_and (0x00FF).as_natural_8
		end
end

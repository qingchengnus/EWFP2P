note
	description: "This class is responsible for parsing the header of the packets received add pass it to the correct protocol handler"
	author: "Qing Cheng"
	date: "11/4/2014"
	revision: "$Revision$"

class
	HEADERPARSER

feature
	demultiplex(first_byte: NATURAL_8): INTEGER
		local
			first_two_bits: NATURAL_8
		do
			first_two_bits := first_byte.bit_and (0b11000000)
			if
				first_two_bits = 0b11000000
			then
				RESULT := 1
			else
				RESULT := 0
			end
		end

	get_class(first_two_bytes: ARRAY[NATURAL_8]): INTEGER
		require
			two_bytes_received: first_two_bytes.count = 2
		local
			first_bit: NATURAL_8
			second_bit: NATURAL_8
		do
			first_bit := first_two_bytes.at (1).bit_and (0b00000001)
			first_bit := first_bit.bit_shift_left (1)
			second_bit := first_two_bytes.at (2).bit_and (0b00010000)
			second_bit := second_bit.bit_shift_right (4)
			RESULT := first_bit.bit_or (second_bit)
		end

	get_method(first_two_bytes: ARRAY[NATURAL_8]): INTEGER
		require
			two_bytes_received: first_two_bytes.count = 2
		local
			first_bit: NATURAL_8
			second_bit: NATURAL_8
			method: NATURAL_16
		do
			method := 0;
			first_bit := first_two_bytes.at (1).bit_and (0b00111110)
			method := method.bit_or (first_bit.as_natural_16)
			method := method.bit_shift_left (6)
			second_bit := first_two_bytes.at (2).bit_and (0b11101111)
			second_bit := second_bit.bit_shift_right (5).bit_shift_left (4).bit_or (second_bit.bit_shift_left (4).bit_shift_right (4))
			method := method.bit_or (second_bit.as_natural_16)
			RESULT := method
		end

	get_length(bytes: ARRAY[NATURAL_8]): INTEGER
		require
			two_bytes_received: bytes.count = 2
		do
			RESULT := bytes.at (3) * 256 + bytes.at (4)
		end

	verify_magic_cookie(bytes: ARRAY[NATURAL_8]): BOOLEAN
		require
			four_bytes_received: bytes.count = 4
		do
			RESULT := bytes.at (5) = 0x21 and bytes.at (6) = 0x12 and bytes.at (7) = 0xA4 and bytes.at (8) = 0x42
		end

	get_transaction_id(bytes: ARRAY[NATURAL_8]): ARRAY[NATURAL_32]
		require
			twelve_bytes_received: bytes.count = 12
		local
			i: INTEGER
		do
			create RESULT.make_filled (0, 1, 3)
			from
				i := 1
			until
				i = 4
			loop
				RESULT.put (bytes[4 * i + 5].as_natural_32 * 256 * 256 * 256 + bytes[4 * i + 6].as_natural_32 * 256 * 256 + bytes[4 * i + 7].as_natural_32 * 256 + bytes[4 * i + 8].as_natural_32 , i)
				i := i + 1
			end
		end

feature
	to_unsigned(header: ARRAY[INTEGER_8]): ARRAY[NATURAL_8]
		local
			size: INTEGER
			result_array: ARRAY[NATURAL_8]
			i: INTEGER
		do
			size := header.count
			create result_array.make_filled (0, 1, size + 1)
			from
				i := 1
			until
				i = size + 1
			loop
				result_array.put (header.at(i).as_natural_8, i)
				i := i + 1
			end
			RESULT := result_array
		end
end

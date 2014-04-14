note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	NEW_TEST_SET

inherit
	EQA_TEST_SET
		redefine
			on_prepare
--			on_clean
		end

feature
	packet1: ARRAY[NATURAL_8]
	testee: HEADERPARSER
feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		local
			i: INTEGER
		do
			create testee
			create packet1.make_filled(0, 1, 20)
			packet1.put(0b00000001, 1)
			packet1.put(0b00010001, 2)
			packet1.put(0b00000010, 3)
			packet1.put(0b11010000, 4)
			packet1.put(0x21, 5)
			packet1.put(0x12, 6)
			packet1.put(0xA4, 7)
			packet1.put(0x42, 8)

			packet1.put(0x2A, 9)
			packet1.put(0xB4, 10)
			packet1.put(0x33, 11)
			packet1.put(0x68, 12)
			packet1.put(0x6E, 13)
			packet1.put(0xFF, 14)
			packet1.put(0xD5, 15)
			packet1.put(0x67, 16)
			packet1.put(0x0C, 17)
			packet1.put(0xAC, 18)
			packet1.put(0x12, 19)
			packet1.put(0x59, 20)
		end

--	on_clean
--			-- <Precursor>
--		do
--			assert ("not_implemented", False)
--		end

feature -- Test routines

	protocol_demultiplexing_test
			-- New test routine
		do
			assert ("Protocol demultiplexing fails.", testee.demultiplex (packet1.at (1)) = 0)
		end

	class_processing_test
		do
			assert ("Class processing fails.", testee.get_class (packet1.subarray (1, 2)) = 3)
		end

	method_processing_test
		do
			assert ("Method processing fails.", testee.get_method (packet1.subarray (1, 2)) = 1)
		end

	length_processing_test
		do
			assert ("Length processing fails.", testee.get_length (packet1.subarray (3, 4)) = 720)
		end

	magic_cookie_verification_test
		do
			assert ("Length processing fails.", testee.verify_magic_cookie (packet1.subarray (5, 8)))
		end

	transaction_id_processing_test
		do
			assert ("Incorrect number of results", testee.get_transaction_id (packet1.subarray (9, 20)).count = 3)
			assert ("Incorrect first result", testee.get_transaction_id (packet1.subarray (9, 20)).at (1) = 0x2AB43368)
			assert ("Incorrect second result", testee.get_transaction_id (packet1.subarray (9, 20)).at (2) = 0x6EFFD567)
			assert ("Incorrect third result", testee.get_transaction_id (packet1.subarray (9, 20)).at (3) = 0x0CAC1259)
		end
end



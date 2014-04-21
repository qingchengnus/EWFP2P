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
	packet1: MY_PACKET
	testee: HEADER_PARSER
feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do

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

			create testee.make_from_packet (packet1)
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
			assert ("Protocol demultiplexing fails.", testee.demultiplex = 0)
		end

	class_processing_test
		do
			assert ("Class processing fails.", testee.get_class = 3)
		end

	method_processing_test
		do
			assert ("Method processing fails.", testee.get_method = 1)
		end

	length_processing_test
		do
			assert ("Length processing fails.", testee.get_length = 720)
		end

--	magic_cookie_verification_test
--		do
--			assert ("Magic cookie verification fails.", testee.verify_magic_cookie)
--		end

	transaction_id_processing_test
		do
			assert ("Incorrect transaction id.", testee.get_transaction_id.is_equal ("2AB433686EFFD5670CAC1259"))
		end
end



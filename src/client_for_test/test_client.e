note
	description : "client_for_test application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	TEST_CLIENT

inherit
	ARGUMENTS
	SOCKET_RESOURCES

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			soc1: detachable NETWORK_STREAM_SOCKET
		do
			create soc1.make_client_by_port (8888, "localhost")
			soc1.connect
			process(soc1)
			soc1.cleanup
		rescue
            if soc1 /= Void then
                soc1.cleanup
            end
		end
	process(soc1: detachable NETWORK_STREAM_SOCKET)
		require
			socket_not_void: soc1 /= Void
		local
			pkt: PACKET
		do
--			io.put_integer_8 (1)
--			io.new_line
--			io.put_integer_8 (2)
--			io.new_line
--			io.put_integer_8 (3)
--			io.new_line
			create pkt.make (2)
			pkt.put_element ('q', 0)
			pkt.put_element ('c', 1)
			soc1.write (pkt)

		end

end

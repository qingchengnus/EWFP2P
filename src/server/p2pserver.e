note
	description : "ewfp2pserver application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	P2PSERVER

inherit
	ARGUMENTS
	SOCKET_RESOURCES
	STORABLE

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			listen(8888, 1)
		end


feature
	listen(port: INTEGER; queue: INTEGER)
		require
			valid_port: valid_port(port)
			valid_queue: valid_queue(queue)
		local
			count: INTEGER
			socket: detachable NETWORK_STREAM_SOCKET
			header_parser: HEADERPARSER
		do
			create socket.make_server_by_port(port)
			socket.listen (queue)
			from
				count := 0
			until
				count = 1
			loop
				process(socket)
				count := count + 1
			end
			socket.cleanup

		rescue
			if socket /= Void then
				socket.cleanup
			end
		end

	process(soc: detachable NETWORK_STREAM_SOCKET)
		require
			soc_not_void: soc /= Void
		local
--			count: INTEGER
			msg: detachable PACKET
		do
			soc.accept
			if attached soc.accepted as soc2 then
--				if attached {INTEGER_8} retrieved (soc2.read_integer_8) as packet then
--					from
--						count := 0
--					until
--						count = packet.count
--					loop
--						print (packet.at (count))
--						count := count + 1
--					end

--				end
--				soc2.close
				msg := soc2.read (2)
				if
					msg /= Void
				then
					print(msg.at (1))
					print(msg.at (2))
				end

			end
		end
feature
	valid_port(port: INTEGER): BOOLEAN
	do
		RESULT := (port > 1023)
	end

	valid_queue(queue: INTEGER): BOOLEAN
	do
		RESULT := (queue > 0)
	end
end

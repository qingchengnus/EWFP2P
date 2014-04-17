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
			listen(8888, 5)
		end


feature
	listen(port: INTEGER; queue: INTEGER)
		require
			valid_port: valid_port(port)
			valid_queue: valid_queue(queue)
		local
			count: INTEGER
			socket: detachable NETWORK_STREAM_SOCKET
			header_parser: HEADER_PARSER
		do
			create socket.make_server_by_port(port)
			socket.listen (queue)
			from
				count := 0
			until
				count = 5
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
			count: INTEGER
		do
			soc.accept
			if attached soc.accepted as soc2 then
				if attached {MY_PACKET} retrieved (soc2) as packet then
					from
						count := 0
					until
						count = packet.count
					loop
						print (packet.at (count))
						count := count + 1
					end

				end

				if attached soc2.peer_address as net_addr then
					print("peer ip is ")
					print(net_addr.host_address.host_address)
					print("peer port is ")
					print(net_addr.port)
				end
				soc2.close

			end
		rescue
			print("unknow exception happens")
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

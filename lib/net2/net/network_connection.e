note
	description: "A {NETWORK_CONNECTION} represents a network connection."
	author: "Mischael Schill"
	date: "$Date: 2014-02-28 10:38:22 +0100 (Fri, 28 Feb 2014) $"
	revision: "$Revision: 94555 $"

class
	NETWORK_CONNECTION

create
	connect,
	connect_with_timeout,
	make_endpoint

feature {NONE} -- Initialization
	make_endpoint (a_server: separate SERVER; a_use_separate_input: BOOLEAN)
			-- Create a network connection that is an endpoint, i. e. it accepts a connection to a {SERVER}
			-- If `a_use_separate_input' is True, the input stream will reside on a different processor.
		require
			a_server.is_listening
		do
			fd := a_server.socket.pr_fd
			address_family := a_server.socket.address_family

			create socket.open_ipv4
			if a_use_separate_input then
				create separate_input.make_from_socket_descriptor (socket.pr_fd, socket.ipv4)
			else
				create {like input} separate_input.make_from_socket_descriptor (socket.pr_fd, socket.ipv4)
			end
			create output.make_from_socket (socket)
		ensure
			use_separate_input = a_use_separate_input
		end

	connect (a_host: ESTRING_8; a_port: NATURAL_16; a_use_separate_input: BOOLEAN)
		-- Try to establish a connection, closing it on a timeout or if the host address is invalid.
		do
			connect_with_timeout (a_host, a_port, 0, a_use_separate_input)
		ensure
			use_separate_input = a_use_separate_input
		end

	connect_with_timeout (a_host: ESTRING_8; a_port: NATURAL_16; a_timeout: NATURAL_32; a_use_separate_input: BOOLEAN)
		-- Try to establish a connection, closing it on a timeout or if the host address is invalid.
		require
			a_timeout > 1000 and a_timeout < 100000 or a_timeout = 0
		local
			l_addr: PR_NET_ADDRESS
			l_hostent: PR_HOST_ENTRY
		do
			create l_hostent.lookup (a_host, a_port)
			if not l_hostent.addresses.is_empty then
				l_addr := l_hostent.addresses.first
			end
			if l_addr.family = l_addr.ipv4 then
				create socket.open_ipv4
			elseif l_addr.family = l_addr.ipv6 then
				create socket.open_ipv6
			else
				check false end
				create socket.make_from_fd (create {POINTER}, l_addr.ipv4)
			end
			socket.connect (l_addr, a_timeout)
			if a_use_separate_input then
				create separate_input.make_from_socket_descriptor (socket.pr_fd, socket.address_family)
			else
				create {like input}separate_input.make_from_socket_descriptor (socket.pr_fd, socket.address_family)
			end
			create output.make_from_socket (socket)
		ensure
			use_separate_input = a_use_separate_input
		end

feature -- Access
	peer_address: detachable NET_ADDRESS

--	as_medium: NETWORK_MEDIUM
		-- Use the connection with an {IO_MEDIUM} interface

	socket: PR_TCP_SOCKET

	separate_input: separate TCP_INPUT_STREAM
		-- The input stream living on a separate processor

	input: detachable TCP_INPUT_STREAM
		do
			if attached {TCP_INPUT_STREAM} separate_input as i then
				Result := i
			end
		ensure
			attached Result = attached {TCP_INPUT_STREAM} separate_input
			attached Result implies Result = separate_input
		end

	output: TCP_OUTPUT_STREAM

feature -- Status report
	is_closed: BOOLEAN
			-- Is the network connection open?
		do
			Result := socket.is_closed
		end

	is_endpoint: BOOLEAN
			-- True if the connection is an endpoint
		do
			Result := not fd.is_default_pointer
		end

	use_separate_input: BOOLEAN
			-- True if the input stream resides on a different processor
		do
			Result := not attached {INPUT_STREAM} separate_input
		end

feature -- Status setting
	accept
			-- Accept a connection. Endpoints can be reused.
		require
			is_endpoint
		do
			if not socket.is_closed then
				socket.close
			end
			create socket.accept (fd, address_family, socket.pr_interval_no_timeout)
			init_sockets (separate_input)
		end

	close
			-- Flushes the output and then closes the connection.
		do
			output.close
		end

feature {NONE} -- Implementation
	fd: POINTER
	address_family: NATURAL_16

	init_sockets (a_in: separate TCP_INPUT_STREAM)
		local
			l_fd: POINTER
		do
			-- Using a local variable to circumvent a strange bug when finalizing
			l_fd := socket.pr_fd
			a_in.make_from_socket_descriptor (l_fd, socket.address_family)
			output.make_from_socket(socket)
		end

invariant
	use_separate_input implies attached input

end
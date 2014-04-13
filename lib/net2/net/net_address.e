note
	description: "A {NET_ADDRESS} is basically an ip address."
	author: "Mischael Schill"
	date: "$Date: 2014-02-21 15:16:42 +0100 (Fri, 21 Feb 2014) $"
	revision: "$Revision: 94459 $"

expanded class
	NET_ADDRESS

create
	default_create,
	make_from_string

feature {NONE} -- Initialization
	make_from_string (a_ip: ESTRING_8; a_port: NATURAL_16)
		do
			create internal.make_from_string (a_ip, a_port)
		end

feature -- Measurment
	is_valid: BOOLEAN
		do
			Result := internal.is_valid
		end

	is_ipv4: BOOLEAN
		do
			Result := internal.family = internal.ipv4
		end

	is_ipv6: BOOLEAN
		do
			Result := internal.family = internal.ipv6
		end

feature -- Access
	internal: PR_NET_ADDRESS

end

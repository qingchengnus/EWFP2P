note
	description: "{PROCESSOR_INFO} reports information on the processor it residing."
	author: "Mischael Schill"
	date: "$Date: 2014-02-21 15:03:09 +0100 (Fri, 21 Feb 2014) $"
	revision: "$Revision: 94458 $"

class
	PROCESSOR_INFO

feature -- Access
	processor_id: INTEGER
		do
			Result := ext_pid (Current)
		end

feature {NONE} -- Externals
	ext_pid (a_any: ANY): INTEGER
		external
			"C inline"
		alias
			"return RTS_PID (eif_access($a_any));"
		end


end

note
	description: "Summary description for {MY_PACKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_PACKET

inherit

    ARRAY[NATURAL_8]

    STORABLE
        undefine
            is_equal, copy
        end

create

    make

end

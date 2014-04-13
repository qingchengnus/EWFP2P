note
	description: "MYSQL_BIND C Struct Wrapper"
	author: "haroth@student.ethz.ch"
	date: "$Date: 2013-09-27 11:12:07 +0200 (Fri, 27 Sep 2013) $"
	revision: "$Revision: 93019 $"

class
	MYSQLI_INTERNAL_BIND_ARRAY

inherit
	MEMORY_STRUCTURE
	MYSQLI_EXTERNALS

create{MYSQLI_EXTERNALS}
	make_with_size

feature{NONE}

	make_with_size (a_size: like size)
		do
			size := a_size
			make
		end

feature

	structure_size: INTEGER
		do
			Result := size_of_mysql_bind_struct * size
		end

	size: INTEGER

end

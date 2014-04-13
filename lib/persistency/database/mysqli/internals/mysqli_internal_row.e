note
	description: "MYSQL_ROW C Struct Wrapper"
	author: "haroth@student.ethz.ch"
	date: "$Date: 2013-09-27 11:12:07 +0200 (Fri, 27 Sep 2013) $"
	revision: "$Revision: 93019 $"

class
	MYSQLI_INTERNAL_ROW

inherit
	MEMORY_STRUCTURE
	MYSQLI_EXTERNALS

create{MYSQLI_EXTERNALS}
	make

feature

	structure_size: INTEGER
		do
			Result := size_of_mysql_row_struct
		end

end

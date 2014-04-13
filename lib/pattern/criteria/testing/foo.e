note
	description: "Summary description for {FOO}."
	author: ""
	date: "$Date: 2013-12-20 16:08:05 +0100 (Fri, 20 Dec 2013) $"
	revision: "$Revision: 93780 $"

class
	FOO

create
	make

feature

	make (s: READABLE_STRING_GENERAL)
		do
			create bar.make (s)
		end

	bar: BAR

end


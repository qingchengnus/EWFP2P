note
	description: "Dummy class to restrict export of internal features."
	author: "Roman schmocker"
	date: "$Date: 2014-01-10 10:05:53 +0100 (Fri, 10 Jan 2014) $"
	revision: "$Revision: 93949 $"

class
	PS_ABEL_EXPORT

inherit

	REFACTORING_HELPER
		export {NONE}
			--to_implement_assertion,
			fixme,
			to_implement
		end
end

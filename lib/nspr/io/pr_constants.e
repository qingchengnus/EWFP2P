note
	description: "{PR_CONSTANTS} defines some common NSPR constants."
	author: "Mischael Schill"
	date: "$Date: 2014-03-18 12:23:38 +0100 (Tue, 18 Mar 2014) $"
	revision: "$Revision: 94615 $"

deferred class
	PR_CONSTANTS

feature
	pr_failure: INTEGER = -1
	pr_success: INTEGER = 0

	pr_shutdown_send: INTEGER = 0
	pr_shutdown_recv: INTEGER = 1
	pr_shutdown_both: INTEGER = 2

end

// Initialize the global powers list.

/hook_handler/clockcult_powers/proc/OnStartup(var/list/args)
	for(var/path in subtypesof(/datum/clockcult_power))
		global.clockcult_powers += new path

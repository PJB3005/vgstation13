// Initialize the global powers list.

/hook_hander/clockcult_powers/proc/OnStartup(var/list/args)
	for(var/path in typesof(/datum/clockcult_power) - /datum/clockcult_power)
		global.clockcult_powers += new path

//These part slots can story multiples because else I'd have to dynamically create/delete (or pool) datums and it'd suck.
/datum/vehicle_part/slot/volume
	var/list/attached_parts[0]	//Yes I only made that plural.

	var/volume = 0

	attach_side = ATTACH_INTERNAL
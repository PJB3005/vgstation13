/obj/item/vehicle_part
	name = "part"
	desc = "Looks like it fits in a car."

	icon = 'icons/obj/vehicles/parts.dmi'

	var/attach_icon = ''

	var/weight = 0

	var/use_energy = 0
	var/lowest_energy_usage = 0
	var/highest_energy_usage = 0

	var/create_energy = 0

	var/attach_type = ATTACH_INTERNAL

	var/list/attach_blacklist[0]
	var/list/attach_whitelist[0]

	var/list/attachable_blacklist[0]
	var/list/attachable_whitelist[0]

	var/list/attached[0]
	var/obj/item/vehicle_part/master
	var/obj/item/vehicle_part/armor/armor

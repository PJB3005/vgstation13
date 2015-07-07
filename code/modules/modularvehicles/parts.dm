/obj/item/vehicle_part
	name = "part"
	desc = "Looks like it fits in a car."

	icon = 'icons/obj/vehicles/parts.dmi'

	var/attach_icon								//DMI used to get the attached icon from.
	var/list/attach_icon_states[0]				//State used to get the attached icon from.

	var/weight = 0								//Weight of the part, in kg.

	var/use_energy = 0							//% of how much power this thing needs to use between lowest and highest_energy_usage, -1 for none.
	var/lowest_energy_usage = 0					//Values used above.
	var/highest_energy_usage = 0

	var/energy_priority = 1						//Priority of energy reception, if there isn't enough energy for the entire vehicle, the lower priority parts will lose power first

	var/attach_side = ATTACH_INTERNAL			//Side of another part this part attaches to.
	var/slot_type								//String representing the type of this slot, this is mostly so you can't attach fucking guns to ripley arms.

	var/list/attach_slots[0]					//List of slot datums for this part.

	var/list/attached[0]						//List of attached parts.
	var/obj/item/vehicle_part/master_part		//Part we're connected to.

	var/obj/vehicle/vehicle						//Master vehicle.

/obj/item/vehicle_part/proc/get_energy_usage()
	if(use_energy == -1)
		. = 0
	else
		. = ((highest_energy_usage - lowest_energy_usage) * use_energy / 100) + lowest_energy_usage



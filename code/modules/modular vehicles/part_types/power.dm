/obj/item/vehicle_part/power
	name = "bluespess generator"
	desc = "Does this thing generate energy from thin air?"

	var/energy_production = 10

/obj/item/vehicle_part/power/proc/generate_energy()
	. = energy_production

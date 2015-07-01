/obj/item/vehicle_part/cockpit
	name = "cockpit"
	desc = "Has a nice comy chair."

	icon = 'icons/obj/vehicle/cockpit.dmi'

	var/mob/passenger

	var/enter_type = ENTER_ENCLOSED

//Called when a mob enters this cockpit.
/obj/item/vehicle_part/cockpit/proc/mob_entry(var/mob/M)

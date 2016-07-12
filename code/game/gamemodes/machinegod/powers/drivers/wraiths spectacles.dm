/datum/clockcult_power/create_object/wraiths_spectacles
	name            = "Wraith's Spectacles"
	desc            = "Creates spectacles that grant true sight, but quickly ruin the wearer's vision. Prolonged use will result in blindness. Enemy cultists that attempt to wear this will have their eyes completely ruined."

	invocation      = "Tenag zr gehgu yraf."
	loudness        = CLOCK_WHISPERED
	cast_time       = 0
	req_components  = list(CLOCK_HIEROPHANT = 2)
	used_components = list(CLOCK_HIEROPHANT = 1)

	object_type     = /obj/item/clothing/glasses/wraithspecs

	creator_message = "<span class='clockwork'>You shape a pair of Wraith's Spactacles.</span>"

/datum/clockcult_power/create_object/wraiths_spectacles/show_message(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	user.visible_message("<span class='notice'>A pair of strange glasses appears underneath [user]!</span>", "<span class='clockwork'>A pair of Wraith's Spectacles appears underneath you!</span>")

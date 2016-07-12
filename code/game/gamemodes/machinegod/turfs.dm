/turf/simulated/floor/clockcult
	name       = "clockwork floor"
	desc       = "It's filled with rotating and moving clockwork components."

	icon       = 'icons/turf/clockwork.dmi'
	icon_state = "floor"

/turf/simulated/floor/clockcult/airless
	oxygen = 0.01
	nitrogen = 0.01

/turf/simulated/floor/clockcult/Entered(var/atom/movable/Obj, var/atom/OldLoc)
	if (isliving(Obj))
		var/mob/living/M = Obj
		if (!iscult(M))
			return

		// Burn them, no message though because spam.
		M.apply_damage(0.5, BURN, LIMB_LEFT_FOOT)
		M.apply_damage(0.5, BURN, LIMB_RIGHT_FOOT)

	return ..()

/turf/simulated/floor/clockcult/New()
	. = ..()

	adjust_clockcult_cv(1)

/turf/simulated/floor/clockcult/Del() // Sadly turfs only hard del.
	. = ..()

	adjust_clockcult_cv(-1)

/turf/simulated/floor/clockcult/adjust_slowdown(var/mob/living/L, var/current_slowdown)
	if (!isclockcult(L))
		current_slowdown++
		if (iscult(L))
			current_slowdown++

/turf/simulated/wall/clockcult
	name       = "clockwork wall"
	desc       = "It's filled with rotating and moving clockwork components."

	icon       = 'icons/turf/clockwork.dmi'
	icon_state = "wall"
	canSmoothWith = null

/turf/simulated/wall/clockcult/New()
	. = ..()

	adjust_clockcult_cv(1)

/turf/simulated/wall/clockcult/Del()
	. = ..()

	adjust_clockcult_cv(-1)

// Status effects, a way for YOU to add stuff to mobs WITHOUT going full ninjacode!
// If you're wondering "but how on EARTH would I make anything useful with this code?"; use event hooks.
// If there's no event hook for what you're doing, make an event hook in the mob code.

// Yes, I am well aware that with enough event hooks you can do all of this, without even needing a list of status effects on the mob, but eh.

/mob
	var/list/status_effects = list()

// Duplicate proc overrides will both get called as long as they both call ..() at some point.
/mob/Destroy()
	. = ..()
	for(var/datum/status_effect/S in status_effects)
		qdel(S)

/mob/proc/add_status_effect(var/datum/status_effect/S)
	if(!S)
		return

	. = S.attach(src)

	if(.)
		status_effects += S

/datum/status_effect
	var/mob_type            = /mob // A typepath the mob has to be subtype of. Can also be a list, and in that case all of the types in the list are valid.

	var/mob/our_mob

/datum/status_effect/Destroy()
	. = ..()
	our_mob.status_effects -= src
	our_mob = null

// Called when the status effect gets added to a mob.
/datum/status_effect/proc/attach(var/mob/M)
	if(!M)
		return

	if(!(islist(mob_type) ? is_type_in_list(M, mob_type) : istype(M, mob_type)))
		return

	our_mob = M
	return TRUE

// Subtype that has a native functionality of only lasting a certain period of time.
// Only precise up to 1 decisecond.
/datum/status_effect/timed
	var/time_max       = 0 // The total time this effect will last for, can also be set through New(), only really here so we can reset the remaining time if needed.

	var/time_remaining = 0 // I'll let you figure this out.

/datum/status_effect/timed/New(var/new_time_max, var/new_time_remaining)
	. = ..()

	if (new_time_max)
		time_max = new_time_max

		if (!new_time_remaining)
			time_remaining = time_max

		return

	if (new_time_remaining)
		time_remaining = new_time_remaining

	else
		time_remaining = time_max

/datum/status_effect/timed/attach(var/mob/M)
	. = ..()

	if (.)
		countdown()

/datum/status_effect/timed/proc/countdown()
	// Undocumented BYOND feature: will cause the proc to return if the code sleeps, but it'll still continue as if it's spawn()'d off.
	// There is no reason to not just use a spawn() here other than a TINY amount of performance, but eh.
	set waitfor = 0

	#warn TODO: make this use world.time timestamps.
	while(time_remaining > 0 && our_mob && !gcDestroyed) // This way we can check every second if we've been deleted, to prevent GCing from failing.
		sleep(1)
		time_remaining--

	qdel(src)

// Resets the timer, essentially.
/datum/status_effect/timed/proc/refresh()
	time_remaining = time_max

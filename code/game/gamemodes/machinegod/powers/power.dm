/datum/clockcult_power
	var/name = "this shouldn't appear."
	var/desc = "OH GOD CALL A CODER THE UNIVERSE IS EXPLODING."

	var/invocation          = "BU TBQ!"     // Invocation of this power.
	var/cast_time           = 1             // Time this power should take to be casted. If it should be dynamic override get_cast_time().
	var/participants_min    = 1             // Participants required to cast this. minimum.
	var/participants_max    = 1             // Participants required to cast this. maximum.
	var/loudness            = CLOCK_SPOKEN  // Chanted, spoken, or whispered. CLOCK_CALC to calculate dynamically.
	var/category            = CLOCK_DRIVER  // Category this falls under.
	var/list/req_components                 // Required components to cast this power, format is list(compid = amount, ...)
	var/list/used_components                // The actually used amount, this defaults to req_components if not specified.

/datum/clockcult_power/New()
	if (!used_components)
		used_components = req_components

	..()

// Checks if the power can be casted.
// Note that this DOES NOT check for components, such is handled on the side of the clockslab.
/datum/clockcult_power/proc/can_cast(var/mob/user, var/obj/item/clockslab/C, var/list/participants, var/before_cooldown)
	return TRUE

#warn TODO: participants that move shouldn't cancel cast, they should not be considered instead.
// DO NOT OVERRIDE THIS, unless you REALLY know what you're doing.
/datum/clockcult_power/proc/cast(var/mob/user, var/obj/item/clockslab/C)
	var/list/participants = list(user)
	var/participants_len = 1
	if (participants_len < participants_max)
		for (var/mob/living/L in hearers(user, 1))
			if (!isclockcult(L) || L.isUnconscious())
				continue

			participants += L
			participants_len++
			if (participants_len >= participants_max)
				break

	if (participants_len < participants_min)
		return FALSE // Not enough people to do it.

	if (!can_cast(user, C, participants, FALSE))
		return FALSE

	if(!before_cast(user, C, participants))
		return FALSE

	var/cast_time = get_cast_time(user, C, participants)
	for (var/M in participants)
		participant_do_after(M, participants, cast_time)

	sleep(cast_time + 1)

	if (participants.len != participants_len) // One of the do_after sub procs REMOVED a participant.
		return FALSE

	if (!can_cast(user, C, participants, TRUE))
		return FALSE

	return activate(user, C, participants)

// We need to do_after on every participant but that's really goddamn hard.
/datum/clockcult_power/proc/participant_do_after(var/mob/user, var/list/participants, var/time)
	set waitfor = FALSE

	if (!do_after(user, user, time))
		participants -= user

// Gets the cast time, only used if cast_time == -1.
/datum/clockcult_power/proc/get_cast_time(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	return TRUE

/datum/clockcult_power/proc/get_loudness(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	return loudness

/datum/clockcult_power/proc/before_cast(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	return TRUE

// This proc is called when the power is casted. This is what you should override.
// Return 1 if the invocation failed (for example, a do_after() that got cancelled), and the components will not be taken.
/datum/clockcult_power/proc/activate(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	return

/datum/clockcult_power/proc/say_for_loudness(var/mob/user, var/message, var/loudness)
	switch (loudness)
		if (CLOCK_WHISPERED)
			user.whisper(message)
		if (CLOCK_SPOKEN)
			user.say(message)
		if (CLOCK_CHANTED)
			user.say(uppertext(message))


/datum/clockcult_power/channeled
	var/channel_amount = 1         // Amount of times this gets chanted.
	var/channel_time   = 1 SECONDS // Interval between the chants.
	var/list/chants                // Possible chants.

#warn TODO: manage multiple participants (probably by disallowing it)
/datum/clockcult_power/channeled/activate(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	var/total_channeled = 0
	for (var/i = 1 to channel_amount)
		if (!can_cast(user, C, participants) || !do_after(user, user, channel_time))
			break

		total_channeled++
		say_for_loudness(user, pick(chants), get_loudness(user, C, participants))
		channel_effect(user, C, participants, i)

	to_chat(user, "<span class='notice'>You stop chanting.</span>")
	channel_end(user, C, participants, total_channeled)

/datum/clockcult_power/channeled/proc/channel_effect(var/mob/user, var/obj/item/clockslab/C, var/list/participants, var/channeled_amount)
	return

/datum/clockcult_power/channeled/proc/channel_end(var/mob/user, var/obj/item/clockslab/C, var/list/participants, var/total_channeled)
	return


/datum/clockcult_power/create_object
	var/object_type      // Type of the object to spawn.

	var/creator_message  // The message the user gets when casting this.
	var/observer_message // The message the people watching get.
	var/blind_message    // The message blind people get.

	var/one_per_tile = FALSE // Whether it can be blocked by existance of an object of prevent_path on the tile.
	var/prevent_type     // Type which blocks if the above var is TRUE, defaults to object_type

	var/fade_in = TRUE   // Should we do fancy fade in action?

/datum/clockcult_power/create_object/New()
	..()

	if (one_per_tile && !prevent_type)
		prevent_type = object_type

/datum/clockcult_power/create_object/can_cast(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	if (one_per_tile && locate(prevent_type) in get_turf(user))
		to_chat(user, "<span class='warning'>There is already such an object on this tile!</span>")
		return FALSE

	return ..()

/datum/clockcult_power/create_object/activate(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	show_message(user, C, participants)

	var/atom/A = new object_type(get_turf(user))
	if (fade_in)
		fade_in(A)

	if (isitem(A))
		user.put_in_hands(A)

/datum/clockcult_power/create_object/proc/show_message(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	if (creator_message && observer_message)
		user.visible_message(observer_message, creator_message, blind_message)

	else if (creator_message)
		to_chat(user, creator_message)


/datum/clockcult_power/create_object/sigil
	prevent_type = /obj/effect/sigil
	one_per_tile = TRUE

/datum/clockcult_power/create_object/sigil/show_message(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	user.visible_message("<span class='notify'>[user] shapes a golden light, which attaches itself to the floor in a pattern!</span>", creator_message)

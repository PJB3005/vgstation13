/datum/clockcult_power
	var/name = "this shouldn't appear."
	var/desc = "OH GOD CALL A CODER THE UNIVERSE IS EXPLODING."

	var/invocation          = "BU TBQ!"   // Invocation of this power.
	var/cast_time           = -1            // Time this power should take to be casted, -1 will make it custom and calculated when it is activated.
	var/participants_min    =  1            // Participants required to cast this. minimum.
	var/participants_max    =  1            // Participants required to cast this. maximum.
	var/loudness            =  CLOCK_SPOKEN // Chanted, spoken, or whispered. CLOCK_CALC to calculate dynamically.
	var/category            =  CLOCK_DRIVER // Category this falls under.
	var/list/req_components[0]              // Required components for this power, format is list(compid = amount, ...)

// Checks if the power can be casted.
// Note that this DOES NOT check for components, such is handled on the side of the clockslab.
/datum/clockcult_power/proc/can_cast(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	return 1

// Gets the cast time, only used if cast_time == -1.
/datum/clockcult_power/proc/get_cast_time(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	return 1

/datum/clockcult_power/proc/get_loudness(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	return loudness

// This proc is called when the power is casted.
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

/datum/clockcult_power/channeled/activate(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	for (var/i = 1 to channel_amount)
		if (!can_cast(user, C, participants) || !do_after(user, user, channel_time))
			break

		say_for_loudness(user, message, get_loudness(user, C, participants))
		channel_effect(user, C, participants)

	to_chat(user, "<span class='notice'>You stop chanting.</span>")
	channel_end(user, C, participants)

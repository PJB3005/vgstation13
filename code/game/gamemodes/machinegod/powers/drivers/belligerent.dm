/datum/clockcult_power/channeled/belligerent
	name           = "Belligerent"
	desc           = "The user begins chanting loudly, forcing non-cultists in earshot to walk. The user may not do anything aside from chant while this is being done. Enemy cultists receive slight damage in addition to the debuff. After ending the chant, the user is knocked down for two seconds."

	invocation     = "Chav'fu urn'gura y'vtug!"
	cast_time      = 0 SECONDS
	loudness       = CLOCK_CHANTED
	req_components = list(CLOCK_BELLIGERENT = 1)

	channel_amount = 30
	channel_time   = 2 SECONDS

	chants = list("Chavfu gur've oyvaqarff!", "Znxr gur'z penjy!", "Fybj gur'z qbja!")

/datum/clockcult_power/channeled/belligerent/activate(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	animate(user, color = "#FF0000", time = channel_amount * channel_time)
	..()

/datum/clockcult_power/channeled/belligerent/channel_effect(var/mob/user, var/obj/item/clockslab/C, var/list/participants, var/channeled_amount)
	for (var/mob/living/carbon/H in hearers(user))
		if (H.isUnconscious() || isclockcult(H))
			continue

		H.change_m_intent(INTENT_WALK)
		var/effect_color = "#FFAA00" // Change colour to full red if it's a blood cultist, else orange.

		if (prob(25))
			var/damage = iscultist(H) ? 4 : 2
			H.apply_damage(damage, BRUTE, LIMB_LEFT_LEG)
			H.apply_damage(damage, BRUTE, LIMB_RIGHT_LEG)
			if(iscultist(H) && prob(15))
				to_chat(H, "<span class='clockwork'>\"Kneel.\"</span>")

		if (iscultist(H))
			effect_color = "#FF0000"

		if (prob(25))
			to_chat(H, "<span class='danger'>A mighty force impedes your movements.</span>")

		var/turf/T = get_turf(H)
		T.turf_animation('icons/effects/96x96.dmi', "beamin", -32, 0, MOB_LAYER + 1, 'sound/effects/siphon.ogg', effect_color, PLANE_EFFECTS)

/datum/clockcult_power/channeled/belligerent/channel_end(var/mob/user, var/obj/item/clockslab/C, var/list/participants, var/total_channeled)
	var/turf/T = get_turf(user)
	T.turf_animation('icons/effects/96x96.dmi', "beamin", -32, 0, MOB_LAYER + 1, 'sound/effects/siphon.ogg', "#FFFF00", PLANE_EFFECTS)
	user.Stun(total_channeled)

	var/datum/controller/process/mob/process = processScheduler.nameToProcessMap["mob"] // Because I REALLY want this animation to sync up.
	animate(user, color = null, time = total_channeled * process.schedule_interval)
	to_chat(user, "<span class='warning'>Ratvar's fury overwhelms you, preventing you from moving.</span>")

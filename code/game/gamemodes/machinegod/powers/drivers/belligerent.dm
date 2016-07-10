/datum/clockcult_power/channeled/belligerent
	name           = "Belligerent"
	desc           = "The user begins chanting loudly, forcing non-cultists in earshot to walk. The user may not do anything aside from chant while this is being done. Enemy cultists receive slight damage in addition to the debuff. After ending the chant, the user is knocked down for two seconds."

	invocation     = "Chav'fu urn'gura y'vtug!"
	cast_time      = 0 SECONDS
	loudness       = CLOCK_CHANTED
	req_components = list(CLOCK_BELLIGERENT = 1)

	channel_amount = 10
	channel_time   = 3 SECONDS

	chants = list("Chavfu gur've oyvaqarff!", "Znxr gur'z penjy!", "Fybj gur'z qbja!")

/datum/clockcult_power/channeled/belligerent/channel_effect(var/mob/user, var/obj/item/clockslab/C, var/list/participants, var/channelled_amount)
	for (var/mob/virtualhearer/hearer in viewers(src))
		if (istype(hearer.attached, /mob/living/carbon))
			var/mob/living/carbon/C = hearer.attached

			if (!isclockcult(C))
				if (prob(25))
					to_chat(C, "<span class='warning'>A strong force slows you down!</span>")

				C.change_m_intent(INTENT_WALK)

			else if (iscultist(C))
				if (prob(25))
					to_chat(C, "<span class='warning'>You feel an ancient force burning your legs!</span>")
					C.apply_damage(2.5, BURN, LIMB_LEFT_LEG)
					C.apply_damage(2.5, BURN, LIMB_RIGHT_LEG)

				C.change_m_intent(INTENT_WALK)

/datum/clockcult_power/channeled/belligerent/channel_end(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	user.weaken(1)

/datum/clockcult_power/belligerent
	name				= "Belligerent"
	desc				= "The user begins chanting loudly, forcing non-cultists in earshot to walk. The user may not do anything aside from chant while this is being done. Enemy cultists receive slight damage in addition to the debuff. After ending the chant, the user is knocked down for two seconds."

	invocation			= "Chav'fu urn'gura y'vtug!"
	cast_time			= 0 SECONDS
	loudness			= CLOCK_CHANTED
	req_components		= list(CLOCK_BELLIGERENT = 1)

	var/list/datum/status_effect/effects = list()

/datum/clockcult_power/belligerent/activate(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	// Make it so other people can't bump the user, so you don't have derps fucking up the do_after().
	user.mob_bump_flags = 0
	user.anchored       = FALSE

	// Sure we'll use do_after, and after every tick of do_after we'll make sure everybody's slow.
	while(do_after(user, delay = 1))
		for(var/mob/living/carbon/M in hearers(user))
			if(isclockcult(M))
				continue

			var/datum/status_effect/belligerent_slowdown/B = locate() in M.status_effects
			if(!B)
				B = new(src)
				M.add_status_effect(B)

				effects += B

/datum/status_effect/belligerent_slowdown
	var/on_move_key
	var/on_attempt_run_key

	var/datum/clockcult_power/belligerent/master

/datum/status_effect/belligerent_slowdown/New(var/datum/clockcult_power/belligerent/new_master)
	. = ..()
	master = new_master

/datum/status_effect/belligerent_slowdown/attach(var/mob/M)
	. = ..()
	if(!.)
		return

	to_chat(M, "<span class='danger'>A horrible sound of chanting fills your ears!</span>")

	on_move_key        = M.on_move.Add(src, "mob_move")
	on_attempt_run_key = M.on_attempt_run.Add(src, "mob_attempt_run")

	M.m_intent = "walk"
	M.hud_used.move_intent.icon_state = "walking"

/datum/status_effect/belligerent_slowdown/mob_attempt_run(var/new_state, var/list/return_value)
	return_value["fail"] = TRUE // Prevent them from running.

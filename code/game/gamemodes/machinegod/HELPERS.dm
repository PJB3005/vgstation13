#define isclockcomponent(A) (istype(A, /obj/item/clock_component))
#warn TODO: logging of clockcult_broadcast
// Broadcasts to all mobs with the clockcult language.
/proc/clockcult_broadcast(var/datum/speech/speech, var/rendered_speech = "")
	var/list/receiving = list() // List of mobs that will receive this.

	for(var/mob/M in player_list)
		if(M.isDead())
			receiving += M
			continue

		for(var/datum/language/L in M.languages)
			if(L.name == LANGUAGE_CLOCKCULT)
				receiving += M
				continue

	to_chat(receiving, "<span class='clockwork'>[speech.name] [speech.render_message()]</span>") // Yes there already is a span but this'll differentiate it from normal spoken.

/proc/get_clockcult_cv()
	return global.clockcult_cv

/proc/set_clockcult_cv(var/amount = 0)
	global.clockcult_cv = amount

#warn TODO: prevent negatives maybe?
/proc/adjust_clockcult_cv(var/amount = 0)
	global.clockcult_cv += amount


/proc/get_clockcult_comp_by_id(var/id, var/no_alpha = FALSE)
	if (no_alpha)
		return CLOCK_COMP_IDS_PATHS_NO_ALPHA[id]
	else
		return CLOCK_COMP_IDS_PATHS[id]

/proc/clockcult_component_to_color(var/id)
	return CLOCK_COMP_IDS_COLORS[id]

/proc/clockcult_component_to_light_color(var/id)
	return CLOCK_COMP_IDS_LIGHT_COLORS[id]

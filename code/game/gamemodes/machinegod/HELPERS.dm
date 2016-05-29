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

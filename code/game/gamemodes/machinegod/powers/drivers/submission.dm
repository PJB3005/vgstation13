/datum/clockcult_power/create_object/sigil/submission
	name        = "Sigil of Submission"
	desc        = "Places a golden sigil that when triggered, glows magenta and converts a target on that turf. Humans and silicons are both valid targets, however, implanted targets are immune to conversion by the sigil. Converted silicons do not count towards the cultist total. If three cultists activate this sigil, an AI or implanted target may be converted."

	invocation  = "Fpev'or qvivar rayvtugra sbez!"
	loudness    = CLOCK_WHISPERED
	cast_time   = 6 SECONDS

	object_type  = /obj/effect/sigil/submission

	req_components  = list(CLOCK_GEIS = 2)
	used_components = list(CLOCK_GEIS = 1)

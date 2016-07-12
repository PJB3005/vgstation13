/datum/clockcult_power/create_object/sigil/transgression
	name            = "Sigil of Transgression"
	desc            = "Wards a tile so that any non-cultists that stand on it are smited, unable to move for four seconds. Enemy cultists are knocked down altogether."

	invocation      = "F'pevor qvivar chav'fu sbez!"
	cast_time       = 5 SECONDS
	loudness        = CLOCK_WHISPERED
	req_components  = list(CLOCK_BELLIGERENT = 2)
	used_components = list(CLOCK_BELLIGERENT = 1)

	object_type     = /obj/effect/sigil/transgression

/datum/clockcult_power/create_object/replicant
	name            = "Replicant"
	desc            = "Forms a new clockwork slab from the alloy and drops it at the user's feet. Slabs are used to create components and use them to activate powers. Slabs require a living, active cultist that does not possess extra slabs to generate components. Components will be made once every 3 minutes at random, or once every 4 minutes if a specific type is requested."

	invocation      = "S'betr zr fyno."
	loudness        = CLOCK_WHISPERED
	cast_time       = 0
	req_components  = list(CLOCK_REPLICANT = 1)

	object_type     = /obj/item/clockslab
	creator_message = "<span class='clockwork'>You shape a new clockwork slab with your mind.</span>"

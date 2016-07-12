/datum/clockcult_power/create_object/inkers_cache
	name            = "Tinkerer's Cache"
	desc            = "Constructs a cache that can store up to X Components. When casting any power, caches on any z-level are picked from first before taking from the slab's Component storage. Daemons will automatically attempt to fill the oldest cache with space remaining."

	invocation      = "Ohv'yqva n qvfcra'fre!"
	cast_time       = 4 SECONDS
	req_components  = list(CLOCK_REPLICANT = 2)
	used_components = list(CLOCK_REPLICANT = 1)

	object_type     = /obj/machinery/tinkers_cache
	one_per_tile    = TRUE

/datum/clockcult_power/create_object/inkers_cache/show_message(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	user.visible_message("<span class='notice'>A tinkerer's cache appears beneath [user]!</span>", "<span class='clockwork'>The tinkerer's cache materialises underneath you!</span>") // I would say "your feet", but then I'd have to check if the user has actual feet.

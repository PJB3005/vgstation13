/obj/machinery/tinkers_cache
	name = "\improper Tinker's Cache"
	desc = "Some weird clockwork machine."

	icon = 'icons/obj/clockwork/structures.dmi'
	icon_state = "tinkerscache"

	var/total_amount = 0 // Total amount, so it's easier to track.
	var/list/storage     // List of stored components, ID, assoc value is amount.

/obj/machinery/tinkers_cache/New()
	. = ..()

	tinkcaches += src
	adjust_clockcult_cv(1)

	storage = CLOCK_COMP_STORAGE_PRESET.Copy()

/obj/machinery/tinkers_cache/Destroy()
	. = ..()

	tinkcaches -= src
	adjust_clockcult_cv(-1)

/obj/machinery/tinkers_cache/examine(var/mob/user)
	. = ..()
	if (!isclockcult(user))
		return

	to_chat(user, "It has the following components stored:")
	for (var/component in storage)
		var/obj/item/clock_component/C = get_clockcult_comp_by_id(component)
		var/component_name = initial(C.name)
		to_chat(user, "&nbsp;&nbsp;[component_name]: [storage[component]]")

/obj/machinery/tinkers_cache/attackby(var/obj/item/W, var/mob/user)
	if (isclockcomponent(W))
		var/obj/item/clock_component/C = W
		if (!add_component(C.component_type))
			to_chat(user, "\The [src] is full!")

		to_chat(user, "You insert \the [C] into \the [src].")
		qdel(C)

/obj/machinery/tinkers_cache/attack_hand(var/mob/user)
	var/list/temp_component_names = CLOCK_COMP_NAMES_IDS.Copy()

	// Filter out names of which we've got no components stored.
	for (var/component in storage)
		if (!storage[component])
			temp_component_names -= CLOCK_COMP_IDS_NAMES[component]

	var/component = input(user, "Which component do you want to remove?", "Tinker's Cache") as null | anything in temp_component_names
	if (!component || !user.Adjacent(src) || user.incapacitated())
		return

	component = temp_component_names[component] // Using this list will be a tiny bit faster if not all components are available.

	if (!remove_component(component, 1))
		return

	var/obj/item/clock_component/C = new CLOCK_COMP_IDS_PATHS[component]

	if (!user.put_in_hands(C))
		C.forceMove(loc)

	to_chat(user, "You take \a [C] out of \the [src].")
	return 1

/obj/machinery/tinkers_cache/proc/get_component(var/const/component_id)
	return storage[component_id]

// Subtype for ~debugging~.
/obj/machinery/tinkers_cache/infinite/get_component(var/const/component_id)
	return INFINITY

/obj/machinery/tinkers_cache/proc/add_component(var/const/component_id)
	if (total_amount >= CLOCKCACHE_CAPACITY) // Nope we're full.
		return FALSE

	storage[component_id]++
	total_amount++
	return TRUE

/obj/machinery/tinkers_cache/proc/remove_component(var/const/component_id, var/const/amount = 1)
	var/stored_amount = storage[component_id]

	var/removed = max(stored_amount - amount, 0)

	storage[component_id] -= removed
	total_amount -= removed
	return removed

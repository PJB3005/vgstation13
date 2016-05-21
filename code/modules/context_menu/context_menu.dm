/datum/context_menu
	var/atom/my_atom

	var/list/obj/screen/buttons

	var/list/mob/viewing

// new_atom is obvious.
// button_list is a list of /obj/screen/visible_verb.
/datum/context_menu/New(var/atom/new_atom, var/list/new_buttons)
	. = ..()

	my_atom = new_atom

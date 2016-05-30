// For reasons of managing appearances these image subtypes are the image options used to make a context menu.
/image/context_option
	var/key = "default" // Key to send back to the master atom.
	var/datum/context_menu/owner

	var/obj/effect/overlay/context_overlay/overlay

/image/context_option/proc/init(var/datum/context_menu/new_owner)
	owner   = new_owner
	overlay = new(owner.my_atom)
	owner.my_atom.lock_atom(overlay, /datum/locking_category/context_lock)

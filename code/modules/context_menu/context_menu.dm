// Context menus.
// Basically, when you activate a context menu, a bunch of buttons will become visible on the map.
// It's like a better version of verbs!

/datum/context_menu
	var/atom/my_atom
	var/proc_name // Proc to call on the owner atom when a button is clicked.

	var/list/mob/viewing
	var/list/image/context_option/buttons

	// See __DEFINES/context_menu.dm
	var/flags = 0

// new_atom is obvious.
// button_list is a list of /obj/screen/visible_verb.
/datum/context_menu/New(var/atom/new_atom, var/list/image/context_option/new_buttons, var/new_proc_name = "context_menu_action")
	. = ..()

	my_atom   = new_atom
	buttons   = new_buttons
	for (var/image/context_option/button in buttons)
		button.init(src) // This is to make setup more comfortable.

	viewing   = list()
	proc_name = new_proc_name

/datum/context_menu/Destroy()
	my_atom = null
	for (var/image/context_option/button in buttons)
		returnToPool(button)

	buttons = null

	for (var/mob/M in viewing)
		M.on_moved.RemoveWithoutKey    (src, "mob_moved")
		M.on_destroyed.RemoveWithoutKey(src, "mob_destroyed")
		M.on_logout.RemoveWithoutKey   (src, "mob_logout")

/datum/context_menu/proc/button_clicked(var/event_id, var/mob/user, var/params)
	return call(my_atom, proc_name)(event_id, usr, params)

/datum/context_menu/proc/open(var/mob/M)
	if (!M || !M.client || viewing.Find(M))
		return

	viewing |= M

	M.on_moved.Add(src,     "mob_moved")
	M.on_destroyed.Add(src, "mob_destroyed")
	M.on_logout.Add(src,    "mob_logout")

	for (var/datum/context_option/button in buttons)
		button.open(M.client)

/datum/context_menu/proc/close(var/mob/M)
	if (!M || !viewing.Find(M))
		return

	for (var/datum/context_option/button in buttons)
		button.close(M.client)

	M.on_moved.RemoveWithoutKey    (src, "mob_moved")
	M.on_destroyed.RemoveWithoutKey(src, "mob_destroyed")
	M.on_logout.RemoveWithoutKey   (src, "mob_logout")

/datum/context_button/proc/mob_moved(var/list/args, var/mob/M)
	if (!istype(M))
		return

	if (!my_atom.Adjacent(M))
		close(M)

/datum/context_button/proc/mob_destroyed(var/list/args, var/mob/M)
	close(M)

/datum/context_button/proc/mob_logout(var/list/args, var/mob/M)
	close(M)

/datum/locking_category/context_lock

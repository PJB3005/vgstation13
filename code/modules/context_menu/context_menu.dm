// Context menus.
// Basically, when you activate a context menu, a bunch of buttons will become visible on the map.
// It's like a better version of verbs!

// Because of BYOND limitations the implementation is quote roundabout:
// 1 /datum/context_menu as controller for the whole system, one per atom and they have to be manually added to atoms.
// However much /atom/movable/context_menu as you damn well please.

// To get the actual buttons to show up, we add the buttons to the source turf of the source atom.
// Then we set an image's loc to the button atom.
// Then we send that image to clients.
// Yes it's so fucking conveluted, blame BYOND.

/datum/context_menu
	var/atom/my_atom

	var/list/atom/movable/context_menu/buttons

	var/list/mob/viewing

// new_atom is obvious.
// button_list is a list of /obj/screen/visible_verb.
/atom/movable/context_menu/New(var/atom/new_atom, var/list/new_buttons)
	. = ..()

	my_atom = new_atom

	buttons = new_buttons

/atom/movable/context_menu/Destroy()
	my_atom = null
	for(var/atom/movable/context_button/C in buttons)
		returnToPool(C)

	buttons = null

/atom/movable/context_menu/proc/button_clicked(var/event_id, var/mob/user, var/params)
	return my_atom.context_menu_action(event_id, usr, params)

/atom/movable/context_menu/proc/open(var/mob/M)
	if(!M || !M.client || viewing.Find(M))
		return

	viewing |= M

	M.on_moved.Add(src, "mob_moved")
	M.on_destroyed.Add(src, "mob_destroyed")

	for(var/atom/movable/context_button/C in buttons)
		M.client.images |= C.button_image

/atom/movable/context_menu/proc/close(var/mob/M)
	for(var/atom/movable/context_button/C in buttons)
		M.client.images -= C.button_image

/atom/movable/context_button/proc/mob_moved(var/list/args, var/mob/M)
	if(!istype(M))
		return

	if(!my_atom.Adjacent(M))
		close(M)

/atom/movable/context_button/proc/mob_destroyed(var/list/args, var/mob/M)
	close(M)

/atom/movable/context_button
	var/datum/context_menu/owner
	var/image/button_image // The actually visible thing.
	var/event_id // ID to send to the "button_clicked" proc on the owner when we are clicked.

/atom/movable/context_button/New(var/atom/loc, name, event_id, icon, icon_state, px_x, px_y)
	. = ..()

	button_image = image(icon, icon_state = icon_state)

/atom/movable/context_button/Click(var/location, var/control, var/params)
	if(owner)
		owner.button_clicked(event_id, usr, params)

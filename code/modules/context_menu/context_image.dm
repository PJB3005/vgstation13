// For reasons of managing appearances these image subtypes are the image options used to make a context menu.
/image/context_option
	var/datum/context_menu/owner
	var/obj/effect/overlay/context_overlay/overlay
	var/list/client/images // List of client = image.

/image/context_option/New()
	..()

	images = list()

/image/context_option/Destroy()
	owner = null
	returnToPool(overlay)
	overlay = null
	for (var/client/C in images)
		var/image/I = images[C]
		I.loc = null
		C.images -= I

	images = null

/image/context_option/proc/init(var/datum/context_menu/new_owner)
	owner   = new_owner
	overlay = getFromPool(/obj/effect/overlay/context_overlay, null, owner, src)
	if (ismovable(owner.my_atom))
		var/atom/movable/AM = owner.my_atom
		AM.lock_atom(overlay, /datum/locking_category/context_lock)
	else
		overlay.anchored = TRUE

/image/context_option/proc/open(var/client/C)
	var/image/I  = new
	I.appearance = appearance
	I.loc = overlay
	C.images += I

	images[C] = I

	if (owner.flags ^ CONTEXT_NO_OPEN_ANIMATION)
		var/old_alpha = I.alpha
		I.alpha = 0
		animate(I, alpha = old_alpha, time = 2)
		sleep(2)

/image/context_option/proc/close(var/client/C)
	if (!C)
		return // Logout so no client.

	var/image/I = images[C]

	if (owner.flags ^ CONTEXT_NO_OPEN_ANIMATION)
		animate(I, alpha = 0, 2)
		sleep(2)

	I.loc = null
	C.images -= I
	images -= C



/image/context_option/proc/push_appearance(var/animate = TRUE, var/time = 5, var/easing = LINEAR_EASING)
	for (var/client/C in images)
		var/image/I = images[C]
		if (animate)
			animate(I, appearance = appearance, time = time, easing = easing)
		else
			I.appearance = appearance

/obj/effect/overlay/context_overlay
	var/image/context_option/template // Image holder of the appearance of this button.

	var/list/client/images // List of client = image.
	var/datum/context_menu/owner

	name = ""

/obj/effect/overlay/context_overlay/New(var/atom/loc, var/new_key, var/image/new_appearance)
	images = list()
	owner  = new_owner

	template = new_appearance

	..()

/obj/effect/overlay/context_overlay/Destroy()
	images     = null
	owner      = null
	template   = null

	return ..()

/obj/effect/overlay/context_overlay/proc/open(var/client/C)
	var/image/I  = new
	I.appearance = appearance
	I.loc = src
	C.images += I

	images[C] = I

	if (owner.flags ^ CONTEXT_NO_OPEN_ANIMATION)
		var/old_alpha = I.alpha
		I.alpha = 0
		animate(I, alpha = old_alpha, time = 5)

/obj/effect/overlay/context_overlay/proc/close(var/client/C)
	for ()


/obj/effect/overlay/context_overlay/proc/push_appearance(var/animate = TRUE, var/time = 5, var/easing = LINEAR_EASING)
	for (var/client/C in images)
		var/image/I = images[C]
		if (animate)
			animate(C, appearance = template.appearance, time = time, easing = easing)
		else
			C.appearance = template.appearance

/obj/effect/overlay/Click(var/location, var/control, var/params)
	if (owner)
		owner.button_clicked(template.key, usr, params)

/obj/effect/overlay/context_overlay
	var/image/context_option/template // Image holder of the appearance of this button.

	var/datum/context_menu/owner

	name = ""

/obj/effect/overlay/context_overlay/New(var/atom/loc, var/datum/context_menu/new_owner, var/image/new_appearance)
	owner  = new_owner

	template = new_appearance

	..()

/obj/effect/overlay/context_overlay/Destroy()
	owner      = null
	template   = null

	return ..()

/obj/effect/overlay/context_overlay/Click(var/location, var/control, var/params)
	if (owner)
		owner.button_clicked(template, usr, params)

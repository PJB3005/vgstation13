/obj/machinery/tinkers_daemon
	name = "Tinker's Daemon"

	icon = 'icons/obj/clockwork/daemon.dmi'
	icon_state = "tinkersdaemon"

	use_auto_lights = TRUE
	light_range_on  = 3
	light_power_on  = 2

	anchored = TRUE
	density = TRUE

	var/target_component
	var/tmp/last_target // For update icon reasons.
	var/tmp/next_component

	var/tmp/datum/context_menu/menu
	var/tmp/image/context_option/random_button
	var/tmp/image/context_option/slab_button
	var/tmp/list/image/context_option/component_buttons

	var/static/component_to_overlay = list(
		CLOCK_VANGUARD    = "creation_vanguard",
		CLOCK_BELLIGERENT = "creation_belligerent",
		CLOCK_REPLICANT   = "creation_replicant",
		CLOCK_HIEROPHANT  = "creation_hierophant",
		CLOCK_GEIS        = "creation_geis",
	)

/obj/machinery/tinkers_daemon/New()
	. = ..()

	adjust_clockcult_cv(1)
	processing_objects += src

	var/list/all_buttons = list()
	component_buttons = list()

	var/image/context_option/new_button = new /image/context_option()
	component_buttons[new_button] = CLOCK_VANGUARD
	all_buttons += new_button
	new_button.icon = 'icons/obj/clockwork/components.dmi'
	new_button.icon_state = "cogwheel"

	new_button.pixel_y = -8
	new_button.pixel_x = -24


	new_button = new /image/context_option()
	component_buttons[new_button] = CLOCK_BELLIGERENT
	all_buttons += new_button
	new_button.icon = 'icons/obj/clockwork/components.dmi'
	new_button.icon_state = "eye"

	new_button.pixel_y = 8
	new_button.pixel_x = -24


	new_button = new /image/context_option()
	component_buttons[new_button] = CLOCK_REPLICANT
	all_buttons += new_button
	new_button.icon = 'icons/obj/clockwork/components.dmi'
	new_button.icon_state = "alloy"

	new_button.pixel_y = 24


	new_button = new /image/context_option()
	component_buttons[new_button] = CLOCK_HIEROPHANT
	all_buttons += new_button
	new_button.icon = 'icons/obj/clockwork/components.dmi'
	new_button.icon_state = "ansible"

	new_button.pixel_y = 8
	new_button.pixel_x = 24


	new_button = new /image/context_option()
	component_buttons[new_button] = CLOCK_GEIS
	all_buttons += new_button
	new_button.icon = 'icons/obj/clockwork/components.dmi'
	new_button.icon_state = "capacitor"

	new_button.pixel_y = -8
	new_button.pixel_x = 24

	menu = new(src, all_buttons)

	reset_time()
	update_icon()

/obj/machinery/tinkers_daemon/Destroy()
	. = ..()

	adjust_clockcult_cv(-1)
	processing_objects -= src

#warn TODO: disabling if not enough cultists.
/obj/machinery/tinkers_daemon/process()
	if(next_component > world.time)
		return // Nothing happening.

	var/component
	if(target_component)
		component = target_component
	else
		component = pick(global.CLOCK_COMP_IDS)

	var/inserted = FALSE
	for(var/obj/machinery/tinkers_cache/C in tinkcaches)
		if(C.add_component(component))
			inserted = TRUE
			break

	if(!inserted) // We couldn't put it in any cache, drop it on the floor.
		var/obj/item/clock_component/C = getFromPool(get_clockcult_comp_by_id(component, no_alpha = TRUE), get_turf(src))
		animate(C, alpha = initial(C.alpha), 5) // Muh fade in.

	reset_time()

/obj/machinery/tinkers_daemon/update_icon()
	#warn TODO: only update when needed.
	overlays.Cut()

	if (target_component)
		set_light(l_color = clockcult_component_to_light_color(target_component))
	else
		set_light(l_color = null)

	var/image/creation_overlay = image('icons/obj/clockwork/daemon.dmi', "tinkers_creation")
	if (target_component)
		creation_overlay.icon_state = component_to_overlay[target_component]
		creation_overlay.color = clockcult_component_to_color(target_component)

	overlays += creation_overlay

/obj/machinery/tinkers_daemon/attack_hand(var/mob/user, var/params)
	if (isclockcult(user))
		menu.toggle(user)

	else
		to_chat(user, "<span class='warning'>You have no clue what this thing is, better not touch it.</span>")

/obj/machinery/tinkers_daemon/proc/context_menu_action(var/image/context_option/template, var/mob/user, var/params)
	if (!isclockcult(user))
		return

	if (template in component_buttons)
		if (target_component == component_buttons[template])
			return

		target_component = component_buttons[template]
		reset_time()
		update_icon()

	else if (template == random_button)
		target_component = null
		reset_time()
		update_icon()

	else if (template == slab_button)
		#warn TODO: slab making

/obj/machinery/tinkers_daemon/proc/reset_time()
	if (target_component)
		next_component = world.time + CLOCKDAEMON_TARGETED
	else
		next_component = world.time + CLOCKDAEMON_UNTARGETED

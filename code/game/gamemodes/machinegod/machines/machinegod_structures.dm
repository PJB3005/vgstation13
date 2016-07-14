/obj/machinery/clockobelisk
	name = "floating prism"
	desc = "A strange, floating yellow prism."
	icon = 'icons/obj/clockwork/structures.dmi'
	icon_state = "obelisk0"
	density = 1
	active_power_usage = 2500
	machine_flags = WRENCHMOVE | FIXED2WORK | WELD_FIXED
	var/on = 0
	var/health = 65
	var/maxhealth = 65
	light_color = LIGHT_COLOR_YELLOW
	light_range_on = 4
	light_power_on = 2
	use_auto_lights = 1

/obj/machinery/clockobelisk/New()
	. = ..()
	clockobelisks += src

/obj/machinery/clockobelisk/Destroy()
	. = ..()
	clockobelisks -= src

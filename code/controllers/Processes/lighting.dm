// Solves problems with lighting updates lagging shit
// Max constraints on number of updates per doWork():
#define MAX_LIGHT_UPDATES_PER_WORK   100
#define MAX_OVERLAY_UPDATES_PER_WORK 1000

/datum/controller/process/lighting
	schedule_interval = LIGHTING_INTERVAL
	name              = "lighting"

/datum/controller/process/lighting/setup()
	create_all_lighting_corners()
	create_all_lighting_overlays()

/datum/controller/process/lighting/doWork()
	// Counters
	var/light_updates   = 0
	var/overlay_updates = 0

	var/list/lighting_update_lights_old = lighting_update_lights //We use a different list so any additions to the update lists during a delay from scheck() don't cause things to be cut from the list without being updated.
	lighting_update_lights = list()
	for(var/A in lighting_update_lights_old)
		var/datum/light_source/L = A // Typecasting this later so BYOND doesn't istype each entry.
		if(light_updates >= MAX_LIGHT_UPDATES_PER_WORK)
			lighting_update_lights += L
			continue // DON'T break, we're adding stuff back into the update queue.

		. = L.check()
		if(L.destroyed || . || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		light_updates++

		scheck()

	var/list/lighting_update_overlays_old = lighting_update_overlays // Same as above.
	lighting_update_overlays = list()

	for(var/A in lighting_update_overlays_old)
		var/atom/movable/lighting_overlay/L = A // Typecasting this later so BYOND doesn't istype each entry.
		if(overlay_updates >= MAX_OVERLAY_UPDATES_PER_WORK)
			lighting_update_overlays += L
			continue // DON'T break, we're adding stuff back into the update queue.

		L.update_overlay()
		L.needs_update = FALSE
		overlay_updates++
		scheck()

	// TODO: Need debug pane for this.
//	to_chat(world, "LIT: [light_updates]:[overlay_updates]")


#undef MAX_LIGHT_UPDATES_PER_WORK
#undef MAX_OVERLAY_UPDATES_PER_WORK

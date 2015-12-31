/var/list/all_lighting_overlays     = list()    // Global list of lighting overlays.
/var/list/lighting_update_lights    = list()    // List of lighting sources queued for update.
/var/list/lighting_update_corners   = list()    // List of lighting corners queued for update.


/area/var/dynamic_lighting          = 1         // Disabling this variable on an area disables dynamic lighting.

/proc/create_all_lighting_overlays()
	for(var/level = 1 to world.maxz)
		create_lighting_overlays_zlevel(level)

/proc/create_lighting_overlays_zlevel(zlevel)
	ASSERT(zlevel)

	for(var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(!T.dynamic_lighting)
			continue
		else
			var/area/A = T.loc
			if(!A.dynamic_lighting)
				continue

		getFromPool(/atom/movable/lighting_overlay, T, TRUE)

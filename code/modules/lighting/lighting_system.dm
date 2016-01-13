/var/list/all_lighting_overlays     = list()    // Global list of lighting overlays.
/var/list/lighting_update_lights    = list()    // List of lighting sources queued for update.
/var/list/lighting_update_overlays  = list()    // List of lighting corners queued for update.
/var/lighting_corners_initialised   = FALSE

/proc/create_all_lighting_overlays()
	world.log << "Generating lighting overlays..."
	sleep(1)

	for(var/zlevel = 1 to world.maxz)
		create_lighting_overlays_zlevel(zlevel)

	world.log << "Finished lighting overlay generation!"

/proc/create_lighting_overlays_zlevel(var/zlevel)
	ASSERT(zlevel)

	for(var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(!T.dynamic_lighting)
			continue
		else
			var/area/A = T.loc
			if(!A.dynamic_lighting)
				continue

		getFromPool(/atom/movable/lighting_overlay, T, TRUE)

	world.log << "Finished lighting overlay generation!"

/proc/create_all_lighting_corners()
	world.log << "Generating lighting corners..."
	sleep(1)
	for(var/zlevel = 1 to world.maxz)
		create_lighting_corners_zlevel(zlevel)

	global.lighting_corners_initialised = TRUE
	world.log << "Finished lighting corner generation!"

/proc/create_lighting_corners_zlevel(var/zlevel)
	ASSERT(zlevel)

	world.log << "Generating lighting corners for level [zlevel]..."
	sleep(1)

	var/count = 0

	for(var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		for(var/i = 1 to 4)
			if(T.corners[i]) // Already have a corner on this direction.
				continue

			T.corners[i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[i])

		count++
		if(count % 100 == 0)
			world.log << "[count] x: [T.x], y: [T.y]"
			//sleep(1)

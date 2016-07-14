/obj/effect/s_gateway
	name          = "spatial gateway"
	desc          = "A Spatial Gateway."
	icon          = 'icons/obj/clockwork/96x96.dmi'
	icon_state    = "s_gateway-charging"
	pixel_x       = -32
	pixel_y       = -32
	anchored      = TRUE
	density       = FALSE
	layer         = 6
	plane         = PLANE_EFFECTS
	unacidable    = 1
	light_color   = "#7f6000"
	var/stable    = FALSE
	var/safe      = TRUE //if FALSE, randomly teleports noncultists
	var/turf/target
	var/timeout   = 0

/obj/effect/s_gateway/New(var/atom/loc, var/turf/new_target, var/time)
	..()
	target = new_target
	color = NOIRMATRIX

	var/matrix/M = matrix()
	M.Scale(0, 0)
	transform = M

	animate(src, transform = null, color = list(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0), time = time - 1, easing = ELASTIC_EASING)

/obj/effect/s_gateway/Destroy()
	..()
	processing_objects -= src

	target = null

/obj/effect/s_gateway/proc/activate(var/participants_len = 0) //1 is 6+, portal becomes dangerous to enemies; 2 is 9+, portal destroys enemies.
	stable = TRUE
	set_light(6, 2)
	icon_state = "s_gateway-active"
	visible_message("<span class='warning'>The gateway stabilizes!</span>")
	processing_objects += src
	timeout = world.time + 25 SECONDS

	var/color_to_set = null
	if (participants_len > 6)
		color_to_set = "#AAAAAA"
		safe = FALSE // Noncults that enter get randomly teleported.

	if (participants_len >= 9)
		color_to_set = "#BBBB00"
		for (var/mob/living/L in view(src, 7))
			if (isclockcult(L))
				continue

			if (L.flags & (INVULNERABLE|GODMODE))
				continue

			L.apply_effect((iscultist(L) ? 65 : 40), IRRADIATE)
			L.fire_stacks += (iscultist(L) ? 65 : 40)
			L.IgniteMob()
			L.Weaken(5)

			spawn (0.3 SECONDS)
				animate(L, transform = null, time = 1.8 SECONDS, easing = SINE_EASING, flags = ANIMATION_PARALLEL)

			animate(L, pixel_z = L.pixel_z + world.icon_size * 2, time = 2 SECONDS, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
			animate(pixel_z = L.pixel_z - world.icon_size * 2, time = 0.3 SECONDS, easing = BACK_EASING)

			to_chat(L, "<span class='danger' style='font-size:16pt'>A relentless, otherworldly energy floods every part of your body, causing you previously unimaginable amounts of pain and lifting you into the air!</span>")
			spawn (2.2 SECONDS)
				L.gib()


	if (color_to_set)
		color = null
		animate(src, color = color_to_set, time = 5 SECONDS, easing = SINE_EASING)

/obj/effect/s_gateway/process()
	set waitfor = FALSE
	if (!stable)
		return

	for (var/turf/TR in range(src, 1))
		if (findNullRod(TR))
			visible_message("<span class='warning'>The null rod seals the gateway!</span>")
			qdel(src)
			return

	if (world.time + 5 SECONDS > timeout && icon_state != "s_gateway-closing")
		icon_state = "s_gateway-closing"
		var/matrix/M = matrix()
		M.Scale(1.25, 1.25)
		animate(src, transform = M, time = 2.5 SECONDS, easing = BACK_EASING)
		M = matrix()
		M.Scale(0.9, 0.9)
		animate(transform = M, time = 2.5 SECONDS, easing = ELASTIC_EASING)

	if (world.time > timeout)
		var/matrix/M = matrix()
		M.Scale(0, 0)
		animate(src, transform = matrix(0, 0, 0, 0, 0, 0), time = 3 SECONDS, easing = BOUNCE_EASING)
		stable = FALSE
		sleep(3 SECONDS)
		qdel(src)

	for(var/mob/living/L in range(src, 1))
		teleport(L)

/obj/effect/s_gateway/proc/teleport(mob/living/L as mob)
	if (safe && !isclockcult(L))
		do_teleport(L, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0) // Goodbye!
		if (iscultist(L))
			to_chat(L, "<span class='clockwork'>As you pass through the gateway, roaring laughter fills your head.</span>")

	else
		do_teleport(L, target, 1)	///You will appear adjacent to the beacon
		if (!isclockcult(L))
			to_chat(L, "<span class='clockwork'>You are overwhelmed by the gateway's bizarre energy!</span>")
			L.Weaken(4)

/obj/effect/s_gateway/ex_act(severity)
	return

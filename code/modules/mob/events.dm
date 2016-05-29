/mob
	var/tmp/event/on_update_icons // Called when update_icons() gets called.
	var/tmp/event/on_stun         // Called when the mob gets stunned (AFTER the stun gets applied, but before canmove gets updated).
	var/tmp/event/on_weaken       // Called when the mob gets weakened (AFTER the weakening gets applied, but before canmove gets updated).
	var/tmp/event/on_attempt_run  // Called when a mob tries to change from running to walking or vise versa.

/mob/New()
	. = ..()
	on_update_icons = new(src)
	on_stun         = new(src)
	on_weaken       = new(src)
	on_attempt_run  = new(src)

/mob/Destroy()
	. = ..()
	qdel(on_update_icons)
	on_update_icons = null

	qdel(on_stun)
	on_stun         = null

	qdel(on_weaken)
	on_weaken       = null

	qdel(on_attempt_run)
	on_attempt_run  = null

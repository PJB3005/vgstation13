/datum/clockcult_power/spatial_gateway
	name           = "Spatial Gateway"
	desc           = "Opens a temporary portal to a chosen \[Clockwork Obelisk], a slab connected to the Hierophant Network, or Nzcrentr, if summoned. If more than one cultist chants, the required time is reduced. Anyone not affiliated with a god will experience slight trauma upon exiting portals. If 6 or more cultists are present, the teleport is instant and the portal changes color, unsafely teleporting any unfaithfuls to random locations. In addition, if 9 or more cultists are present, the portal explodes and any nearby non-cultists are instantly gibbed."
	category       = CLOCK_SCRIPTS

	invocation     = "Trarengr jenvgu ghaary!"
	cast_time      = -1
	req_components = list(CLOCK_REPLICANT = 1, CLOCK_HIEROPHANT = 1)

	var/obj/effect/s_gateway/currently_casting_gateway

#warn TODO: move selection to before literally everything.
/datum/clockcult_power/spatial_gateway/before_cast(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	if (currently_casting_gateway) // Shouldn't happen but you never know.
		return FALSE

	var/list/L = list()
	var/list/areaindex = list()
	for (var/obj/machinery/clockobelisk/O in clockobelisks)
		var/turf/T = get_turf(O)
		if (!T || istype(get_z_level(T), /datum/zLevel/centcomm))
			continue

		var/tmpname = T.loc.name
		if (areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1

		L[tmpname] = O

	if (!L.len)
		to_chat(user, "<span class='warning'>You can't open a gateway if there's no valid targets.</span>")
		return FALSE

	var/gateinfo = input("Choose an active obelisk to warp to.", "Spatial Gateway") as null|anything in L
	if (!gateinfo || !L.Find(gateinfo))
		return FALSE

	currently_casting_gateway = new(get_turf(user), L[gateinfo], get_cast_time(user, C, participants))
	return TRUE

/datum/clockcult_power/spatial_gateway/get_cast_time(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	switch (participants.len)
		if (-INFINITY to 1)
			return 8 SECONDS

		if (2 to 3)
			return 6 SECONDS

		if (4 to 5)
			return 4 SECONDS

		if (6 to INFINITY)
			return 0 SECONDS

/datum/clockcult_power/spatial_gateway/cast(var/mob/user, var/obj/item/clockslab/C)
	. = ..()

	if (currently_casting_gateway)
		currently_casting_gateway.visible_message("<span class='warning'>The gateway collapses!</span>")
		qdel(currently_casting_gateway)
		currently_casting_gateway = null

/datum/clockcult_power/spatial_gateway/activate(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	if (!currently_casting_gateway)
		return FALSE

	currently_casting_gateway.activate(participants.len)
	currently_casting_gateway = null
	return TRUE

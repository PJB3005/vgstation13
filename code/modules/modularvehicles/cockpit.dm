/obj/item/vehicle_part/cockpit
	name = "cockpit"
	desc = "Has a nice comy chair."

//	icon = 'icons/obj/vehicle/cockpit.dmi'

	var/mob/passenger				//Mob in this cockpit.

//Called when a mob enters this cockpit.
//Don't do sanity or anything in here, can_enter() for that.
/obj/item/vehicle_part/cockpit/proc/mob_entry(var/mob/M)
	passenger = M
	M.forceMove(vehicle)

//Same as above but for the mob leaving instead.
/obj/item/vehicle_part/cockpit/proc/mob_leaving(var/mob/M)
	M.forceMove(vehicle.loc)
	passenger = null

//Returns 1 if the mob can enter this cockpit
/obj/item/vehicle_part/cockpit/proc/can_enter(var/mob/M)
	. = 1

//Same as above but for leaving.
/obj/item/vehicle_part/cockpit/proc/can_leave(var/mob/M)
	. = 1

//Cockpits akin to the old janicart
/obj/item/vehicle_part/cockpit/buckle
	var/list/mob_offsets[0]			//Pixel x and y offsets for the buckled mob, relative to the slot we're attached to's offsets. Format is list("[dir]" = list("x" = X, "y" = Y), ...).

/obj/item/vehicle_part/cockpit/buckle/mob_entry(var/mob/M)
	passenger = M

	var/list/offset_list = mob_offsets["[dir]"]
	M.pixel_x += offset_list["x"]
	M.pixel_y += offset_list["y"]

	M.forceMove(vehicle.loc)



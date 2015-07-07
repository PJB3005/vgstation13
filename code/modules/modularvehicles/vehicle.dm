/*
Main vehicle class.

DESC TODO

Events:
	- on_move 		(oldloc, newloc): Invoked when the vehicle moves.
	- change_dir 	(newdir):
*/
/obj/vehicle
	name = "vehicle"
	desc = "some guy's wild ride"
	density = 1

	icon_state = "pussywagon"
	icon = 'icons/obj/vehicles.dmi'

	var/list/passengers[0]															//List of mobs inside the vehicle. First is the driver.

	var/list/components[0]															//List of things that are part of the vehicle.

	var/obj/item/vehicle_part/base
	var/list/cockpits[0]															//List of cockpits, first is always the driver's cockpit.

	var/total_energy_usage															//Total energy usage, to not recalculate it every tick (except when dynamic_energy_usage is nonzero)

	var/list/processing_parts[0]													//Parts that need processing

	var/datum/delay_controller/delay_controller = new(1, ARBITRARILY_LARGE_NUMBER)	//handles vehicle speed.
	var/movement_delay = 1															//Delay from movement.
	var/dynamic_move_delay = 0														//Set this to nonzero if you want the vehicle to dynamically recalculate the speed value.

/obj/vehicle/New()
	. = ..()

	processing_objects |= src
	init_events()

/obj/vehicle/Destroy()
	. = ..()

	processing_objects -= src

/obj/vehicle/process()
	handle_energy_usage()

	for(var/obj/item/vehicle_part/P in processing_parts)
		P.process()

/obj/vehicle/proc/handle_energy_usage()
	var/total_energy = 0

	for(var/obj/item/vehicle_part/power/P in components)
		total_energy += P.generate_energy()

/obj/vehicle/MouseDrop_T(var/mob/M, var/mob/user)
	if(M != user) //Mobs can only get in themselves right now.
		return

	move_inside(M)

//Used to get a mob into the vehicle.
/obj/vehicle/proc/move_inside(var/mob/M)
	if(!M || !ishuman(M) || !Adjacent(M) || M.restrained() || M.lying || M.stat || M.buckled)
		return

	if(passengers.len == cockpits.len)
		M << "<span class='warning'>There is no space in \the [src]!</span>"
		return

	var/obj/item/vehicle_part/cockpit/C = cockpits[passengers.len + 1]

	if(!C.can_enter(M))
		M << "<span class='warning'>You can't enter \the [src]!</span>"
		return

	C.mob_entry(M)

/obj/vehicle/proc/get_out(var/mob/M)
	if(!M || !(M in passengers))
		return

	var/obj/item/vehicle_part/cockpit/C = cockpits[passengers.Find(M)]

	if(!C.can_leave(M))	//THE RIDE NEVER ENDS
		M << "<span class='warning'>You can't leave \the [src]!</span>"
		return

	C.mob_leaving(M)

/obj/vehicle/relaymove(var/mob/user, var/direction)
	if(user.stat)
		return

	if(passengers[1] != user) //Passenger 1 is always the driver, and only the driver can control the vehicle.
		return

	if(delay_controller.blocked())
		return

	step(src, direction)
	delay_move()

/obj/vehicle/proc/delay_move()
	if(dynamic_move_delay)
		recalculate_move_delay()

	delay_controller.delayNext(movement_delay)

/obj/vehicle/proc/recalculate_move_delay()
	movement_delay = 1 //TODO

/obj/vehicle/forceMove(var/atom/destination)
	. = ..()

//COMPLETELY rebuilds the icon.
/obj/vehicle/update_icon()
	//ugh TODO because this'll suck
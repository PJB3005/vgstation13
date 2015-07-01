/obj/vehicle
	name = "vehicle"
	desc = "some guy's wild ride"
	density = 1

	icon_state = "pussywagon"
	icon = 'icons/obj/vehicle.dmis'

	var/list/passengers[0] //List of mobs inside the vehicle. First is the driver.

	var/list/components[0] //List of things that are part of the vehicle.

	var/obj/item/vehicle_part/base
	var/list/cockpits[0] //List of cockpits, first is always the driver's cockpit.

	var/total_energy_usage

	var/list/processing_parts[0]

	var/datum/delay_controller/delay_controller = new(1, 10000) //Maintainers, I'm not using ARBITRARILY_LARGE_NUMBER here because it'd require moving it to setup.dm and it would conflict with unfit's wheelchair PR anyways.
	var/movement_delay = 1
	var/dynamic_move_delay = 0 //Set this to nonzero if you want the vehicle to dynamically recalculate the values.

/obj/vehicle/New()
	. = ..()

	processing_objects += src

/obj/vehicle/Destroy()
	. = ..()
	processing_objects -= src

/obj/vehicle/process()
	handle_energy_usage()

	for(var/item/vehicle_part/P in components)
		P.process()

/obj/vehicle/proc/handle_energy_usage()
	var/total_energy = 0

	for(var/item/vehicle_part/power/P in components)
		total_energy += P.generate_energy()

/obj/vehicle/MouseDrop_T(var/mob/M, var/mob/user)
	if(M != user) //Mobs can only get in themselves right now.
		return

	move_inside(M)

//Used to get a mob into the vehicle.
/obj/vehicle/proc/move_inside(var/mob/M)
	if(!M || !ishuman(M) || !Adjacent(M) || M.restrained() || M.lying || M.stat || M.buckled)
		return

	M.forceMove(src)

/obj/vehicle/relaymove(var/mob/user, var/direction)
	if(user.stat)
		return

	if(passengers[1] != user)
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
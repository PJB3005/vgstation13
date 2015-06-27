/obj/vehicle
	name = "vehicle"
	desc = "some guy's wild ride"
	density = 1

	var/enter_type = ENTER_ENCLOSED

	var/mob/driver //Mob which is controlling this vehicle.
//	var/list/passengers //Any passengers which might need to be taken care of

	var/list/components //List of things that are part of the vehicle.

	var/obj/item/vehicle_part/chassis/chassis
	var/obj/item/vehicle_part/cockpit/cockpit

	var/total_energy_usage

	var/list/processing_parts[0]

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

	if(enter_type == ENTER_ENCLOSED
		M.forceMove(src)
		cockpit.mob_entry(M)


	else
		CRASH("Some dumbass tried to enter a vehicle that's got ENTER_BUCKLE before it was implemented")

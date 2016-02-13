/mob/living
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	var/hud_updateflag = 0

	size = SIZE_NORMAL

	var/hallucination = 0 //Directly affects how long a mob will hallucinate for
	var/list/atom/hallucinations = list() //A list of hallucinated people that try to attack the mob. See /obj/effect/fake_attacker in hallucinations.dm

	var/can_butcher = 1 //Whether it's possible to butcher this mob manually
	var/meat_taken = 0 //How much meat has been taken from this mob by butchering
	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	var/being_butchered = 0 //To prevent butchering an animal almost instantly
	var/list/butchering_drops //See code/datums/butchering.dm, stuff like skinning goes here

	var/list/image/static_overlays

	var/t_plasma = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null

	var/now_pushing = null
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0

	var/cameraFollow = null

	var/tod = null // Time of death
	var/update_slimes = 1

	on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks = 0 //Tracks how many stacks of fire we have on, max is usually 20

	var/specialsauce = 0 //Has this person consumed enough special sauce? IF so they're a ticking time bomb of death.

	var/implanting = 0 //Used for the mind-slave implant
	var/silent = null 		//Can't talk. Value goes down every life proc.

	var/locked_to_z = 0 // Locked to a Z-level if nonzero.

	// Fix ashifying in hot fires.
	//autoignition_temperature=0
	//fire_fuel=0

	var/list/icon/pipes_shown = list()
	var/last_played_vent
	var/is_ventcrawling = 0

	var/species_type
	var/holder_type = /obj/item/weapon/holder/animal	//When picked up, put us into a holder of this type. Dionae use /obj/item/weapon/holder/diona, others - the default one
														//Set to null to prevent people from picking this mob up!
	var/list/callOnLife = list()
	var/obj/screen/schematics_background
	var/shown_schematics_background = 0

	var/datum/health/living/health_datum

/mob/living/proc/unsubLife(datum/sub)
	while("\ref[sub]" in callOnLife)
		callOnLife -= "\ref[sub]"

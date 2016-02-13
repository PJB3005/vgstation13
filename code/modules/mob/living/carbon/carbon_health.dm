/mob/living/carbon/proc/get_rad_loss()
	return health_datum.get_rad_loss()


/mob/living/carbon/proc/adj_rad_loss(var/amount = 0)
	return health_datum.adj_rad_loss(amount)


/mob/living/carbon/proc/set_rad_loss(var/amount = 0)
	return health_datum.set_rad_loss(amount)


/datum/health/living/carbon
	var/datum/dna/dna

	damage_types = list(
		BRUTE     = 0, // Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage).
		BURN      = 0, // Burn damage caused by being way too hot, too cold or burnt.
		TOX       = 0, // Toxic damage caused by being poisoned or radiated.
		OXY       = 0, // Oxygen depravation damage (no air in lungs).
		CLONE     = 0, // Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims
		BRAIN     = 0, // 'Retardation' damage caused by someone hitting you in the head with a bible or being infected with brainrot.
		RADIATION = 0  // Radiation damage. Caused by being irradiated.
	)

/datum/health/living/carbon/proc/get_rad_loss()
	return get_damage(RADIATION)


/datum/health/living/carbon/proc/adj_rad_loss(var/amount = 0)
	return adj_damage(RADIATION)


/datum/health/living/carbon/proc/set_rad_loss(var/amount = 0)
	return set_damage(RADIATION)



/mob/living/carbon/make_health()
	health = new/datum/health/living/carbon()

/mob/living/carbon/proc/get_dna()
	if(istype(health_datum, /datum/health/living/carbon))
		var/datum/health/living/carbon/C = health_datum
		return C.dna

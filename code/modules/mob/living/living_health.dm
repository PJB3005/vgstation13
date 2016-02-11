/datum/health/living
	damage_types = list(
		BRUTE     = 0, // Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage).
		BURN      = 0, // Burn damage caused by being way too hot, too cold or burnt.
		TOX       = 0, // Toxic damage caused by being poisoned or radiated.
		OXY       = 0, // Oxygen depravation damage (no air in lungs).
		CLONE     = 0, // Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims
		BRAIN     = 0, // 'Retardation' damage caused by someone hitting you in the head with a bible or being infected with brainrot.
		HALLOSS   = 0  // Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.
	)

// Getters.
/datum/health/living/proc/get_brute_loss()
	return get_damage(BRUTE)

/datum/health/living/proc/get_burn_loss()
	return get_damage(BURN)

/datum/health/living/proc/get_tox_loss()
	return get_damage(TOX)

/datum/health/living/proc/get_oxy_loss()
	return get_damage(OXY)

/datum/health/living/proc/get_clone_loss()
	return get_damage(CLONE)

/datum/health/living/proc/get_brain_loss()
	return get_damage(BRAIN)

/datum/health/living/proc/get_hal_loss()
	return get_damage(HALLOSS)


// Adjusters.
/datum/health/living/proc/adj_brute_loss(var/amount = 0)
	return adj_damage(BRUTE, amount)

/datum/health/living/proc/adj_burn_loss(var/amount = 0)
	return adj_damage(BURN, amount)

/datum/health/living/proc/adj_tox_loss(var/amount = 0)
	return adj_damage(TOX, amount)

/datum/health/living/proc/adj_oxy_loss(var/amount = 0)
	return adj_damage(OXY)

/datum/health/living/proc/adj_clone_loss(var/amount = 0)
	return adj_damage(CLONE)

/datum/health/living/proc/adj_brain_loss(var/amount = 0)
	return adj_damage(BRAIN)

/datum/health/living/proc/adj_hal_loss(var/amount = 0)
	return adj_damage(HALLOSS)


// Setters.
/datum/health/living/proc/set_brute_loss(var/amount = 0)
	return set_damage(BRUTE)

/datum/health/living/proc/set_burn_loss(var/amount = 0)
	return set_damage(BURN)

/datum/health/living/proc/set_tox_loss(var/amount = 0)
	return set_damage(TOX)

/datum/health/living/proc/set_oxy_loss(var/amount = 0)
	return set_damage(OXY)

/datum/health/living/proc/set_clone_loss(var/amount = 0)
	return set_damage(CLONE)

/datum/health/living/proc/set_brain_loss(var/amount = 0)
	return set_damage(BRAIN)

/datum/health/living/proc/set_hal_loss(var/amount = 0)
	return set_damage(HALLOSS)


/datum/health/living/carbon
	var/datum/dna/dna
	var/datum/reagents/blood // Container for blood. Note that only monkeys and humans have blood here.

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

/datum/health/living/carbon/proc/get_dna()
	return dna

/datum/health/living/carbon/proc/get_blood()
	return blood

/datum/health/living/carbon/proc/adj_rad_loss(var/amount = 0)
	return adj_damage(RADIATION)


/datum/health/living/carbon/proc/set_rad_loss(var/amount = 0)
	return set_damage(RADIATION)

/mob/living/proc/getBruteLoss()
	if(health_datum)
		return health_datum.get_brute_loss()
	return 0

/mob/living/proc/getFireLoss()
	if(health_datum)
		return health_datum.get_burn_loss()
	return 0

/mob/living/proc/getToxLoss()
	if(health_datum)
		return health_datum.get_tox_loss()
	return 0

/mob/living/proc/getOxyLoss()
	if(health_datum)
		return health_datum.get_oxy_loss()
	return 0

/mob/living/proc/getCloneLoss()
	if(health_datum)
		return health_datum.get_clone_loss()
	return 0

/mob/living/proc/getBrainLoss()
	if(health_datum)
		return health_datum.get_brain_loss()
	return 0

/mob/living/proc/getHalLoss()
	if(health_datum)
		return health_datum.get_hal_loss()
	return 0


// These ones don't use the adj_xxx_loss procs on the health datum because it makes clamping to 2 * maxHealth easier. The end result is the same anyways.
// Only a min() because health datums prevent negatives themselves.
/mob/living/proc/adjustBruteLoss(var/amount = 0)
	if(status_flags & GODMODE || !health_datum)
		return 0

	return health_datum.set_brute_loss(min(health_datum.get_brute_loss() + amount, maxHealth * 2))

/mob/living/proc/adjustFireLoss(var/amount = 0)
	if(status_flags & GODMODE || !health_datum)
		return 0

	return health_datum.set_burn_loss(min(health_datum.get_burn_loss() + amount, maxHealth * 2))

/mob/living/proc/adjustToxLoss(var/amount = 0)
	if(status_flags & GODMODE || !health_datum)
		return 0

	toxloss = min(max(toxloss + amount, 0),(maxHealth*2))

/mob/living/proc/adjustOxyLoss(var/amount = 0)
	if(status_flags & GODMODE || !health_datum)
		return 0

	oxyloss = min(max(oxyloss + amount, 0),(maxHealth*2))

/mob/living/proc/adjustCloneLoss(var/amount = 0)
	if(status_flags & GODMODE || !health_datum)
		return 0

	cloneloss = min(max(cloneloss + amount, 0),(maxHealth*2))

/mob/living/proc/adjustBrainLoss(var/amount = 0)
	if(status_flags & GODMODE || !health_datum)
		return 0

	brainloss = min(max(brainloss + amount, 0),(maxHealth*2))



/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = min(max(halloss + amount, 0),(maxHealth*2))

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = amount

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = amount




/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = amount


/mob/living/proc/setBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	brainloss = amount

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = amount

/datum/health
	var/mob/living/our_mob

	var/list/damage_types // List of types of damage, in the form of TYPE = AMOUNT

	var/event/on_change

// These are the procs you SHOULD be using to mess around.
/datum/health/proc/get_damage(var/damage_type)
	if(damage_types.Find(damage_type))
		return damage_types[damage_type]

	return 0

/datum/health/proc/adj_damage(var/damage_type, var/amount = 0)
	if(!amount || !damage_types.Find(damage_type))
		return 0

	return set_damage(damage_type, get_damage(damage_type) + amount)

/datum/health/proc/set_damage(var/damage_type, var/new_amount = 0)
	if(!damage_types.Find(damage_type))
		return 0

	INVOKE_EVENT(on_change, list("type" = damage_type, "new_amount" = new_amount, "old_amount" = get_damage(damage_type)))

	damage_types[damage_type] = max(0, new_amount) // No negatives please.

	return 1

/datum/health/New(var/mob/living/new_mob)
	. = ..()

	our_mob = new_mob

	on_change = new/event(src)

/datum/health/Destroy()
	qdel(on_change)
	on_change = null

	our_mob = null

// Gets called on a transfer, and on New(), note that
/datum/health/proc/transfer(var/mob/living/new_mob)
	our_mob = new_mob
	our_mob.health_datum = src

	return 1

/datum/health/living
	damage_types = list(
		BRUTE     = 0, // Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage).
		BURN      = 0, // Burn damage caused by being way too hot, too cold or burnt.
		TOX       = 0, // Toxic damage caused by being poisoned or radiated.
		OXY       = 0, // Oxygen depravation damage (no air in lungs).
		CLONE     = 0, // Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims.
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


// Transfers the health datum on this mob to new_mob.
// If make_new is false, don't make a new health datum to replace the one we transferred.
// If you don't delete the mob after a transfer without make_new you'll probably get an invincible mob or some shit like that.
/mob/living/proc/transfer_health(var/mob/living/new_mob, var/make_new = FALSE)
	health_datum.transfer(new_mob)
	health_datum = null
	if(make_new)
		make_health()

/mob/living/proc/make_health()
	health_datum = new

/mob/living/get_health()
	return health_datum

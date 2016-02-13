/datum/health/living/carbon/humanoid
	var/datum/reagents/blood

/datum/health/living/carbon/humanoid/transfer(var/mob/new_mob)
	if(blood)
		blood.my_atom = new_mob

	return ..()

/mob/living/carbon/humanoid/make_health()
	health_datum = new /datum/health/living/carbon/humanoid

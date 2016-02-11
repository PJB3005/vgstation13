//Refer to life.dm for caller

/mob/living/carbon/humanoid/human/proc/handle_changeling()
	if(mind && mind.changeling)
		mind.changeling.regenerate()
		updateChangelingHUD()

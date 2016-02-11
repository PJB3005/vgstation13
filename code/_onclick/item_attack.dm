
// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	if(flags & TWOHANDABLE)
		if(!(flags & MUSTTWOHAND))
			if(wielded)
				. = src.unwield(user)
			else
				. = src.wield(user)

// No comment
/atom/proc/attackby(obj/item/W, mob/user)
	return

/atom/movable/attackby(obj/item/W, mob/user)
	if(W && !(W.flags&NOBLUDGEON))
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")

/mob/living/attackby(obj/item/I, mob/user)
	user.delayNextAttack(10)
	if(istype(I) && ismob(user))
		I.attack(src, user)


// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

// Overrides the weapon attack so it can attack any atoms like when we want to have an effect on an object independent of attackby
// It is a powerfull proc but it should be used wisely, if there is other alternatives instead use those
// If it returns 1 it exits click code. Always . = 1 at start of the function if you delete src.
/obj/item/proc/preattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

obj/item/proc/get_clamped_volume()
	if(src.force && src.w_class)
		return Clamp((src.force + src.w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
	else if(!src.force && src.w_class)
		return Clamp(src.w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/obj/item/proc/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	return handle_attack(src, M, user, def_zone)

// Making this into a helper proc because of inheritance wonkyness making children of reagent_containers being nigh impossible to attack with.
/obj/item/proc/handle_attack(obj/item/I, mob/living/M as mob, mob/living/user as mob, def_zone)
	. = 1
	if (!istype(M)) // not sure if this is the right thing...
		return 0
	//var/messagesource = M
	if (can_operate(M))        //Checks if mob is lying down on table for surgery
		if (do_surgery(M,user,I))
			return 1
	//if (istype(M,/mob/living/carbon/brain))
	//	messagesource = M:container
	if (hitsound)
		playsound(I.loc, I.hitsound, 50, 1, -1)
	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	add_logs(user, M, "attacked", object=I.name, addition="(INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(I.damtype)])")

	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////

	var/power = I.force
	if(M_HULK in user.mutations)
		power *= 2

	if(!istype(M, /mob/living/carbon/humanoid/human))
		if(istype(M, /mob/living/carbon/slime))
			var/mob/living/carbon/slime/slime = M
			if(prob(25))
				to_chat(user, "<span class='warning'>[I] passes right through [M]!</span>")
				return 0

			if(power > 0)
				slime.attacked += 10

			if(slime.Discipline && prob(50))	// wow, buddy, why am I getting attacked??
				slime.Discipline = 0

			if(power >= 3)
				if(istype(slime, /mob/living/carbon/slime/adult))
					if(prob(5 + round(power/2)))

						if(slime.Victim)
							if(prob(80) && !slime.client)
								slime.Discipline++
						slime.Victim = null
						slime.anchored = 0

						spawn()
							if(slime)
								slime.SStun = 1
								sleep(rand(5,20))
								if(slime)
									slime.SStun = 0

						spawn(0)
							if(slime)
								slime.canmove = 0
								step_away(slime, user)
								if(prob(25 + power))
									sleep(2)
									if(slime && user)
										step_away(slime, user)
								slime.canmove = 1

				else
					if(prob(10 + power*2))
						if(slime)
							if(slime.Victim)
								if(prob(80) && !slime.client)
									slime.Discipline++

									if(slime.Discipline == 1)
										slime.attacked = 0

								spawn()
									if(slime)
										slime.SStun = 1
										sleep(rand(5,20))
										if(slime)
											slime.SStun = 0

							slime.Victim = null
							slime.anchored = 0


						spawn(0)
							if(slime && user)
								step_away(slime, user)
								slime.canmove = 0
								if(prob(25 + power*4))
									sleep(2)
									if(slime && user)
										step_away(slime, user)
								slime.canmove = 1


		var/showname = "."
		if(user)
			showname = " by [user]!"
		if(!(user in viewers(M, null)))
			showname = "."

		//make not the same mistake as me, these messages are only for slimes
		if(istype(I.attack_verb,/list) && I.attack_verb.len)
			M.visible_message("<span class='danger'>[M] has been [pick(I.attack_verb)] with [I][showname]</span>", \
				"<span class='userdanger'>You have been [pick(attack_verb)] with [I][showname]</span>")
		else if(I.force == 0)
			M.visible_message("<span class='danger'>[M] has been [pick("tapped","patted")] with [I][showname]</span>", \
				"<span class='userdanger'>You have been [pick("tapped","patted")] with [I][showname]</span>")
		else
			M.visible_message("<span class='danger'>[M] has been attacked with [I][showname]</span>", \
				"<span class='userdanger'>You have been attacked with [I][showname]</span>")

		if(!showname && user)
			if(user.client)
				to_chat(user, "<span class='warning'>You attack [M] with [I]!</span>")


	if(istype(M, /mob/living/carbon/humanoid/human))
		var/mob/living/carbon/humanoid/human/H = M
		. = H.attacked_by(I, user, def_zone)
	else
		switch(I.damtype)
			if("brute")
				if(istype(src, /mob/living/carbon/slime))
					M.adjustBrainLoss(power)

				else
					if(istype(M, /mob/living/carbon/humanoid/monkey))
						var/mob/living/carbon/humanoid/monkey/K = M
						power = K.defense(power,def_zone)
					M.take_organ_damage(power)
					if (prob(33) && I.force) // Added blood for whacking non-humans too
						var/turf/location = M.loc
						if (istype(location, /turf/simulated))
							location:add_blood_floor(M)
			if("fire")
				if (!(M_RESIST_COLD in M.mutations))
					if(istype(M, /mob/living/carbon/humanoid/monkey))
						var/mob/living/carbon/humanoid/monkey/K = M
						power = K.defense(power,def_zone)
					M.take_organ_damage(0, power)
					to_chat(M, "Aargh it burns!")
		M.updatehealth()
	I.add_fingerprint(user)
	return .

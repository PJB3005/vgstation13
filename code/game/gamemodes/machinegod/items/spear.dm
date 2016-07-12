#warn TODO: this actually lasts for infinity.
/obj/item/weapon/spear/clockspear
	name = "ancient spear"
	desc = "A deadly, bronze weapon of ancient design."

	icon_state = "spearclock0"
	base_state = "spearclock"
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/swords_axes.dmi', "right_hand" = 'icons/mob/in-hand/right/swords_axes.dmi')

	force = 5
	throwforce = 7
	w_class = W_CLASS_LARGE
	slot_flags = SLOT_BACK
	flags = TWOHANDABLE

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "poked", "jabbed", "torn", "gored")

/obj/item/weapon/spear/clockspear/update_wield(var/mob/user)
	..()

	force = wielded ? 18 : 5

/obj/item/weapon/spear/clockspear/attack(var/mob/target, var/mob/living/user, var/def_zone, var/originator)
	if (iscultist(user))
		user.Paralyse(5)
		user.visible_message("<span class='warning'>An unexplicable force powerfully repels the spear from [target]!</span>",
		                     "<span class='clockwork'>\"You're liable to put your eye out like that.\"</span>")

		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			var/datum/organ/external/affecting = H.get_active_hand_organ()
			H.pain(affecting.display_name, 100, force, 1)
			H.apply_damage(rand(force / 2, force), BRUTE, affecting) //random amount of damage between half of the spear's force and the full force of the spear.

		user.UpdateDamageIcon()
		return

	..()
	if (isclockcult(user))
		var/mob/living/M = target
		if (!istype(M))
			return

		if (iscultist(target))
			M.apply_damage(wielded ? 32 : 25, BRUTE, def_zone)

		if (issilicon(target))
			M.apply_damage(wielded ? 22 : 15, BRUTE, def_zone)

/obj/item/weapon/spear/clockspear/pickup(mob/living/user)
	if (!isclockcult(user))
		to_chat(user, "<span class='danger'>An overwhelming feeling of dread comes over you as you pick up the ancient spear. It would be wise to be rid of this weapon quickly.</span>")
		user.Dizzy(120)

	if (iscultist(user))
		to_chat(user, "<span class='clockwork'>\"Does a savage like you even know how to use that thing?\"</span>")
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			var/datum/organ/external/affecting = H.get_active_hand_organ()
			H.pain(affecting.display_name, 100, force, 1)

/obj/item/weapon/spear/clockspear/throw_impact(atom/A, mob/user)
	..()
	to_chat(world, "SPEAR HIT [A]")
	if (isturf(A))
		var/turf/T = A
		T.turf_animation('icons/obj/clockwork/effects.dmi', "energyoverlay[pick(1,2)]", 0, 0, MOB_LAYER + 1, 'sound/weapons/bladeslice.ogg', anim_plane = PLANE_EFFECTS, anim_duration = 4 SECONDS)
		qdel(src)

	var/mob/living/M = A
	if (!istype(M))
		return

	if (iscultist(M))
		M.take_organ_damage(15)
		M.Stun(1)

	if (issilicon(M))
		M.take_organ_damage(8)
		M.Stun(2)

/spell/clockspear
	name = "Conjure Spear"
	desc = "Conjure a brass spear that serves as a viable weapon against heathens and silicons. Lasts for 3 minutes."

	spell_flags = 0
	range = 0
	charge_max = 2000
	duration = 1800
	invocation = "Rar'zl orjner!"
	invocation_type = SpI_SHOUT
	still_recharging_msg = "<span class='clockwork'>\"Patience is a virtue.\"</span>"

	override_base = "clock"
	cast_sound = 'sound/effects/teleport.ogg'
	hud_state = "clock_spear"

/spell/clockspear/choose_targets(mob/user = usr)
	return list(user)

/spell/clockspear/cast(list/targets, mob/user = usr)
	user.put_in_hands(new/obj/item/weapon/spear/clockspear)

	#warn TODO: this probably lags in large areas like space.
	playsound(user,'sound/effects/evolve.ogg',100,1)
	for(var/turf/T in get_area(user))
		for(var/obj/machinery/light/L in T.contents)
			if(L && prob(20)) L.flicker()

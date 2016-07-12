/obj/item/clothing/glasses/judicialvisor
	name               = "winged visor"
	desc               = "A winged visor with a strange purple lens. Looking at these makes you feel guilty for some reason."
	icon_state         = "judicial_visor"
	item_state         = "judicial_visor"
	eyeprot            = 2
	rangedattack       = TRUE
	action_button_name = "Toggle winged visor"
	var/on             = FALSE
	var/cooldown       = 0

/obj/item/clothing/glasses/judicialvisor/attack_self(var/mob/user)
	do_toggle(user)

/obj/item/clothing/glasses/judicialvisor/verb/toggle()
	set category = "Object"
	set name = "Toggle winged visor"
	set src in usr

	do_toggle(usr)

/obj/item/clothing/glasses/judicialvisor/proc/do_toggle(var/mob/living/carbon/human/user)
	if (!istype(user))
		return

	if (user.isUnconscious() || !isclockcult(user))
		return

	if (cooldown > world.time)
		to_chat(user, "<span class='clockwork'>\"Have patience. It's not ready yet.\"</span>")
		return

	on = !on

	if (on)
		icon_state = "judicial_visor-on"
		item_state = "judicial_visor-on"
		to_chat(user, 'sound/items/healthanalyzer.ogg')
		to_chat(user, "The lens lights up.")
		eyeprot = -1
		if (user.client)
			user.client.mouse_pointer_icon = 'icons/effects/visor_reticule.dmi'

	else
		icon_state = "judicial_visor"
		item_state = "judicial_visor"
		to_chat(user, "The lens darkens.")
		eyeprot = 2
		if (user.client)
			user.client.mouse_pointer_icon = null

	user.update_inv_glasses()

/obj/item/clothing/glasses/judicialvisor/ranged_weapon(var/atom/A, mob/living/carbon/human/wearer)
	if (!on)
		return

	if (iscultist(wearer))
		to_chat(wearer, "<span class='clockwork'>\"The stench of blood is all over you. Does Nar'sie not teach his subjects common sense?\"</span>")
		wearer.apply_damage(20, BURN, LIMB_HEAD)
		var/datum/organ/external/affecting = wearer.get_organ("eyes")
		wearer.pain(affecting, 50, 1, 1)
		return

	if (!isclockcult(wearer))
		to_chat(wearer, "<span class='warning'>You can't quite figure out how to use this...</span>")
		return

	var/turf/target = get_turf(A)
	var/obj/effect/judgeblast/J = getFromPool(/obj/effect/judgeblast, get_turf(target))
	J.creator = wearer
	wearer.say("Xarry, urn'guraf!")
	do_toggle(wearer)
	cooldown = world.time + CLOCK_JUDICIAL_VISOR_DELAY

/obj/item/clothing/glasses/judicialvisor/unequipped(var/mob/M)
	if (on)
		do_toggle(M)

/obj/item/clothing/glasses/judicialvisor/dropped(var/mob/M)
	if (on)
		do_toggle(M)

/obj/effect/judgeblast
	name             = "judgement sigil"
	desc             = "I feel like I shouldn't be standing here."
	icon             = 'icons/obj/clockwork/96x96.dmi'
	icon_state       = null
	plane            = PLANE_EFFECTS
	mouse_opacity    = 0
	pixel_x          = -32
	pixel_y          = -32
	var/blast_damage = 20
	var/mob/creator  = null

/obj/effect/judgeblast/New(loc)
	..()
	playsound(src,'sound/effects/EMPulse.ogg', 80, 1)
	for (var/turf/T in range(1, src))
		if (findNullRod(T))
			to_chat(creator, "<span class='clockwork'>The visor's power has been negated!</span>")
			returnToPool(src)
			return

	flick("judgemarker", src)
	for (var/mob/living/L in range(1, src))
		if (isclockcult(L))
			continue

		to_chat(L, "<span class='danger'>A strange force weighs down on you!</span>")
		L.adjustBruteLoss(blast_damage + iscultist(L) ? 10 : 0)
		if(iscultist(L))
			L.Weaken(3)
			to_chat(L, "<span class='clockwork'>\"I SEE YOU!\"</span>")
		else
			L.Weaken(2)

	spawn (21)
		playsound(src,'sound/weapons/emp.ogg', 80, 1)
		var/judgetotal = 0
		icon_state     = null
		flick("judgeblast", src)

		spawn (15)
			for(var/turf/T in range(1, src))
				if (findNullRod(T))
					to_chat(creator, "<span class='clockwork'>The visor's power has been negated!</span>")
					returnToPool(src)

			for (var/mob/living/L in range(1,src))
				if (isclockcult(L))
					add_logs(creator, L, "used a judgement blast on their ally, ", object = "judicial visor")

				to_chat(L, "<span class='danger'>You are struck by a mighty force!</span>")
				L.adjustBruteLoss(blast_damage + iscultist(L) ? 5 : 0)
				if (iscultist(L))
					L.adjust_fire_stacks(5)
					L.IgniteMob()
					to_chat(L, "<span class='clockwork'>\"There is nowhere the disciples of Nar'sie may hide from me! Burn!\"</span>")

				judgetotal += 1

			if (creator)
				to_chat(creator, "<span class='clockwork'>[judgetotal] target\s judged.</span>")

			returnToPool(src)

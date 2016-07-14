//DEBUG ITEMS
/obj/item/weapon/clockcheat
	name = "ZOOP"
	desc = "ZOP"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "soulvessel-occupied"

/obj/item/weapon/clockcheat/attack_self(mob/living/user as mob)
	if(!isclockcult(user))
		to_chat(user, "<span class='clockwork'>Ratvar: \"wyd?\"</span>")
		return 0
	to_chat(user, "<span class='clockwork'>Ratvar: \"It's lit.\"</span>")
	return 1

/obj/item/weapon/clockcheat/spear
	color = "#ff0000"

/obj/item/weapon/clockcheat/spear/attack_self(mob/living/user as mob)
	if(!..()) return
	user.add_spell(new/spell/clockspear)

/*/obj/item/weapon/clockcheat/revenant
	color = "#ff0000"

/obj/item/weapon/clockcheat/revenant/attack_self(mob/living/user as mob)
	if(!..()) return

	var/mob/living/simple_animal/bound_revenant/R = new
	R.contractor = user.mind*/

/obj/item/weapon/clockcheat/voltvoid
	color = "#FF9900"

/obj/item/weapon/clockcheat/voltvoid/attack_self(mob/living/user as mob)
	if(!..()) return

	var/turf/castspot = user.loc
	var/holding = user.get_active_hand()
	user.color = "#FF9900"
	playsound(get_turf(user), 'sound/effects/EMPulse.ogg', 100, 1)
	for(var/i = 0 to 30)
		if(!user || user.stat != CONSCIOUS || user.stunned)
			break
		if(castspot && user.loc != castspot)
			break
		if(!(user.get_active_hand() == holding))
			break
		if(!isclockcult(user))
			break

		var/list/powercells = list()
		for(var/obj/machinery/M in range(9, user))
			powercells += recursive_type_check(M, /obj/item/weapon/cell)
		for(var/obj/mecha/A in range(9,user))
			powercells += recursive_type_check(A, /obj/item/weapon/cell)
		for(var/mob/living/L in range(9,user))
			powercells += recursive_type_check(L, /obj/item/weapon/cell)
			if(istype(L, /mob/living/silicon))
				var/mob/living/silicon/S = L
				to_chat(S, "<span class='warning'>SYSTEM ALERT: Energy drain detected!</span>")

		for(var/obj/item/weapon/cell/PC in powercells)
			if(PC.charge <= 0)
				powercells -= PC
				continue
			PC.use(500)

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/datum/organ/external/O = pick(H.organs)
			if(O.status & ORGAN_ROBOT)
				O.heal_damage(2, 1, 1, 1)
			else
				O.take_damage(0, powercells.len)
		sleep(20)

	user.color = "#FFFFFF"

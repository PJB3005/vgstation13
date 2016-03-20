#define NOT_SYNDICUFFS 0
#define SYNDICUFFS_ON_APPLY 1
#define SYNDICUFFS_ON_REMOVE 2

/obj/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	setGender(PLURAL)
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = FPRINT
	siemens_coefficient = 1
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	starting_materials = list(MAT_IRON = 500)
	w_type = RECYK_METAL
	melt_temperature = MELTPOINT_STEEL
	origin_tech = "materials=1"
	var/cuffing_sound = 'sound/weapons/handcuffs.ogg'
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	var/mode = NOT_SYNDICUFFS //Handled at this level, Syndicate Cuffs code
	var/charge_detonated = 0

/obj/item/weapon/handcuffs/attack(mob/living/carbon/C as mob, mob/user as mob)

	if(!istype(C))
		return

	//This one is not handled by the general code because Cyborgs in charge of not making shitcode worse
	if(istype(src, /obj/item/weapon/handcuffs/cyborg) && isrobot(user))
		if(!C.handcuffed)
			var/turf/p_loc = user.loc
			var/turf/p_loc_m = C.loc
			playsound(get_turf(src), cuffing_sound, 30, 1, -2)
			user.visible_message("<span class='danger'>[user] is trying to handcuff \the [C]!</span>", \
								 "<span class='danger'>You try to handcuff \the [C]!</span>")
			if(do_after(user, C, 30))
				if(!C)
					return
				if(p_loc == user.loc && p_loc_m == C.loc)
					C.handcuffed = new /obj/item/weapon/handcuffs(C)
					C.update_inv_handcuffed()

	else
		if((M_CLUMSY in user.mutations) && prob(50))
			if(ishuman(C))
				handcuffs_apply(C, user)
				return
			return

		if(!user.dexterity_check())
			to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
			return

		if(ishuman(C))
			if(!C.handcuffed)
				C.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [C.name] ([C.ckey])</font>")
				if(!iscarbon(user))
					C.LAssailant = null
				else
					C.LAssailant = user

				log_attack("<font color='red'>[user.name] ([user.ckey]) Attempted to handcuff [C.name] ([C.ckey])</font>")

				handcuffs_apply(C, user)
			return
		else
			if(!C.handcuffed)
				handcuffs_apply(C, user)
			return

/obj/item/weapon/handcuffs/proc/detonate(var/countdown = 1)

	return

//Our inventory procs should be able to handle the following, but our inventory code is hot spaghetti bologni, so here we go
/obj/item/weapon/handcuffs/proc/handcuffs_apply(mob/living/carbon/C as mob, mob/user as mob)

	if(!istype(C)) //Sanity doesn't hurt, right ?
		return

	if(ishuman(C))
		var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human()
		O.source = user
		if(M_CLUMSY in user.mutations)
			O.target = user
			O.t_loc = user.loc
		else
			O.target = C
			O.t_loc = C.loc
		O.item = user.get_active_hand()
		O.s_loc = user.loc
		O.place = "handcuff"
		C.requests += O
		spawn()
			if(istype(src, /obj/item/weapon/handcuffs/cable))
				feedback_add_details("handcuffs", "C")
			else
				feedback_add_details("handcuffs", "H")
			playsound(get_turf(src), cuffing_sound, 30, 1, -2)
			O.process()
			if(mode == SYNDICUFFS_ON_APPLY && !charge_detonated)
				detonate(1)
	else
		var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey()
		O.source = user
		O.target = C
		O.item = user.get_active_hand()
		O.s_loc = user.loc
		O.t_loc = C.loc
		O.place = "handcuff"
		C.requests += O
		spawn()
			playsound(get_turf(src), cuffing_sound, 30, 1, -2)
			O.process()
			if(mode == SYNDICUFFS_ON_APPLY && !charge_detonated)
				detonate(1)

/obj/item/weapon/handcuffs/proc/handcuffs_remove(var/mob/living/carbon/C)

	if(mode == SYNDICUFFS_ON_REMOVE && !charge_detonated)
		detonate(0) //This handles cleaning up the inventory already
	else
		C.handcuffed = null
		C.update_inv_handcuffed()

//Syndicate Cuffs. Disguised as regular cuffs, they are pretty explosive
/obj/item/weapon/handcuffs/syndicate

	mode = SYNDICUFFS_ON_APPLY
	var/countdown_time = 30

/obj/item/weapon/handcuffs/syndicate/attack_self(mob/user)

	switch(mode)
		if(SYNDICUFFS_ON_REMOVE)
			mode = SYNDICUFFS_ON_APPLY
			to_chat(user, "<span class='notice'>You pull the rotating arm back until you hear two clicks. \The [src] will detonate a few seconds after being applied.</span>")
		if(SYNDICUFFS_ON_APPLY)
			mode = SYNDICUFFS_ON_REMOVE
			to_chat(user, "<span class='notice'>You pull the rotating arm back until you hear one click. \The [src] will detonate when removed.</span>")

//C4 and EMPs don't mix, will always explode at severity 1, and likely to explode at severity 2
/obj/item/weapon/handcuffs/syndicate/emp_act(severity)

	switch(severity)
		if(1)
			if(prob(80))
				detonate(1)
			else
				detonate(0)
		if(2)
			if(prob(50))
				detonate(1)

/obj/item/weapon/handcuffs/syndicate/ex_act(severity)

	switch(severity)
		if(1)
			if(!charge_detonated)
				detonate(0)
		if(2)
			if(!charge_detonated)
				detonate(0)
		if(3)
			if(!charge_detonated && prob(50))
				detonate(1)
		else
			return

	qdel(src)

/obj/item/weapon/handcuffs/syndicate/detonate(countdown)

	if(charge_detonated)
		return
	charge_detonated = 1 //Do it before countdown to prevent spam fuckery
	if(countdown)
		//Cannot use a sleep() instruction here since we do NOT want to delay inventory handling
		spawn(countdown_time)
			explosion(get_turf(src), 0, 1, 3, 0)
			qdel(src)
	else
		explosion(get_turf(src), 0, 1, 3, 0)
		qdel(src)

/obj/item/weapon/handcuffs/Destroy()

	if(iscarbon(loc)) //Inventory shit
		var/mob/living/carbon/C = loc
		if(C.handcuffed)
			C.handcuffed.loc = C.loc //Standby while we delete this shit
			C.drop_from_inventory(src)

	..()

/obj/item/weapon/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_red"
	_color = "red"
	breakouttime = 300 //Deciseconds = 30s
	cuffing_sound = 'sound/weapons/cablecuff.ogg'

/obj/item/weapon/handcuffs/cable/red
	icon_state = "cuff_red"

/obj/item/weapon/handcuffs/cable/yellow
	icon_state = "cuff_yellow"
	_color = "yellow"

/obj/item/weapon/handcuffs/cable/blue
	icon_state = "cuff_blue"
	_color = "blue"

/obj/item/weapon/handcuffs/cable/green
	icon_state = "cuff_green"
	_color = "green"

/obj/item/weapon/handcuffs/cable/pink
	icon_state = "cuff_pink"
	_color = "pink"

/obj/item/weapon/handcuffs/cable/orange
	icon_state = "cuff_orange"
	_color = "orange"

/obj/item/weapon/handcuffs/cable/cyan
	icon_state = "cuff_cyan"
	_color = "cyan"

/obj/item/weapon/handcuffs/cable/white
	icon_state = "cuff_white"
	_color = "white"

/obj/item/weapon/handcuffs/cable/update_icon()
	if(_color)
		icon_state = "cuff_[_color]"

/obj/item/weapon/handcuffs/cyborg
	dispenser = 1

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		var/obj/item/weapon/wirerod/W = new /obj/item/weapon/wirerod
		R.use(1)

		user.before_take_item(src)

		user.put_in_hands(W)
		to_chat(user, "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>")

		qdel(src)

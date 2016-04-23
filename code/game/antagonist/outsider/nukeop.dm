/var/datum/antagonist/nukeop/nukeops

/datum/antagonist/nukeop
	id                   = MODE_MERCENARY
	role_text            = "Nuclear Operative"
	bantype              = "operative"
	antag_indicator      = "synd"
	role_text_plural     = "Nuclear Operatives"
	landmark_id          = "Syndicate-Spawn"
	leader_welcome_text  = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
	welcome_text         = "To speak on the strike team's private channel use :t."
	flags                = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	id_type              = /obj/item/weapon/card/id/syndicate
	antaghud_indicator   = "hudoperative"

	hard_cap             = 6
	initial_spawn_req    = 6
	initial_spawn_target = 6

	faction = "syndicate"

/datum/antagonist/nukeop/New()
	..()
	nukeops = src

/datum/antagonist/nukeop/create_global_objectives()
	if (!..())
		return FALSE
	global_objectives = newlist(/datum/objective/nuclear)
	return TRUE

/datum/antagonist/nukeop/equip(var/mob/living/carbon/human/player)
	if (!..())
		return FALSE

	var/tank_slot = slot_r_hand

	// Obese nukeops need to get fixed, of course.
	if (player.overeatduration)
		to_chat(player, "<span class='notice'>Your intensive physical training to become a Nuclear Operative has paid off and made you fit again!</span>")
		player.overeatduration = 0
		if(player.nutrition > 400)
			player.nutrition = 400

		player.mutations.Remove(M_FAT)
		player.update_mutantrace(0)
		player.update_mutations(0)
		player.update_inv_w_uniform(0)
		player.update_inv_wear_suit()

	// Things everybody gets.
	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate          (player)
	R.set_frequency(SYND_FREQ)
	player.equip_to_slot_or_del(R, slot_ears)

	player.equip_to_slot_or_del(  new /obj/item/clothing/under/syndicate                (player), slot_w_uniform)
	player.equip_to_slot_or_del(  new /obj/item/clothing/shoes/combat                   (player),     slot_shoes)
	player.equip_to_slot_or_del(  new /obj/item/clothing/gloves/combat                  (player),    slot_gloves)
	player.equip_to_slot_or_del(  new /obj/item/clothing/glasses/sunglasses/prescription(player),   slot_glasses)

	player.equip_to_slot_or_del(  new /obj/item/ammo_storage/magazine/a12mm             (player), slot_in_backpack)
	player.equip_to_slot_or_del(  new /obj/item/ammo_storage/magazine/a12mm             (player), slot_in_backpack)
	player.equip_to_slot_or_del(  new /obj/item/weapon/reagent_containers/pill/cyanide  (player), slot_in_backpack)
	player.equip_to_slot_or_del(  new /obj/item/weapon/reagent_containers/pill/creatine (player), slot_in_backpack)
	player.equip_to_slot_or_del(  new /obj/item/weapon/gun/projectile/automatic/c20r    (player),        slot_belt)
	player.equip_to_slot_or_del(  new /obj/item/weapon/storage/box/survival/engineer    (player), slot_in_backpack)
	implant_mob(player, /obj/item/weapon/implant/explosive)
	create_id("Nuclear Operative", player)

	// Backpack.
	if (player.backbag == 2)
		player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security      (player),      slot_back)
	if (player.backbag == 3 || player.backbag == 4)
		player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_sec   (player),      slot_back)

	// Species specific stuff.
	if (isplasmaman(player))
		player.equip_to_slot_or_del(new /obj/item/clothing/suit/space/plasmaman/nuclear (player), slot_wear_suit)
		player.equip_to_slot_or_del(new /obj/item/weapon/tank/plasma/plasmaman          (player),   slot_s_store)
		player.equip_or_collect(    new /obj/item/clothing/mask/breath                  (player), slot_wear_mask)
		player.internal = player.get_item_by_slot(slot_s_store)
		if (player.internals)
			player.internals.icon_state = "internal1"

		player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/plasmaman/nuclear(player),slot_head)

	else
		player.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof       (player), slot_wear_suit)
		player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/swat    (player),      slot_head)

	if (isvox(player))
		player.equip_or_collect(    new /obj/item/clothing/mask/breath/vox              (player), slot_wear_mask)
		player.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen                  (player),    slot_r_hand)
		player.internal = player.get_item_by_slot(tank_slot)
		if (player.internals)
			player.internals.icon_state = "internal1"


	player.update_icons()

	return 1

/datum/antagonist/nukeop/greet(var/datum/mind/player, var/you_are = TRUE)
	to_chat(player.current, "<span class='danger'>You are a [syndicate_name()] agent!</span>")

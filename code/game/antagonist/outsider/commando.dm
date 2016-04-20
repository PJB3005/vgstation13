/var/datum/antagonist/deathsquad/syndicate/commandos

/datum/antagonist/deathsquad/syndicate
	id                  = MODE_COMMANDO
	landmark_id         = "Syndicate-Commando"
	role_text           = "Syndicate Commando"
	role_text_plural    = "Commandos"
	welcome_text        = "<span class='notice'>You are an Elite Syndicate. commando in the service of the Syndicate."
	leader_welcome_text = "<span class='notice'>You are an Elite Syndicate. <B>LEADER</B> in the service of the Syndicate."
	id_type             = /obj/item/weapon/card/id/syndicate/
	hard_cap            = 6
	faction             = "syndicate"

/datum/antagonist/deathsquad/syndicate/New()
	..(1)
	commandos      = src

	default_access += list(access_cent_living, access_cent_storage, access_syndicate)

/datum/antagonist/deathsquad/syndicate/equip(var/mob/living/carbon/human/player)
	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(player)
	R.set_frequency(SYND_FREQ) //Same frequency as the syndicate team in Nuke mode.

	player.equip_to_slot_or_del(R, slot_ears)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(player), slot_shoes)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/clothing/suit/space/syndicate/black/red(player), slot_wear_suit)
	else
		player.equip_to_slot_or_del(new /obj/item/clothing/suit/space/syndicate/black(player), slot_wear_suit)

	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), slot_gloves)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/syndicate/black/red(player), slot_head)
	else
		player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/syndicate/black(player), slot_head)

	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/syndicate(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), slot_glasses)

	player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box(player), slot_in_backpack)

	player.equip_to_slot_or_del(new /obj/item/ammo_storage/box/c45(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/plastique(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/device/flashlight(player), slot_in_backpack)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/weapon/disk/nuclear(player), slot_in_backpack)
		player.equip_to_slot_or_del(new /obj/item/weapon/pinpointer(player), slot_in_backpack)
	else
		player.equip_to_slot_or_del(new /obj/item/weapon/plastique(player), slot_in_backpack)

	player.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(player), slot_l_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/grenade/empgrenade(player), slot_r_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/tank/emergency_oxygen(player), slot_s_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/silenced(player), slot_belt)

	player.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse_rifle(player), slot_r_hand) //Will change to something different at a later time -- Superxpdude

	create_id("Syndicate Commando", player)

	return 1

/datum/antagonist/deathsquad/syndicate/spawn_map_equipment()
	for (var/obj/effect/landmark/L in landmarks_list)
		if (L.name == "Syndicate-Commando-Bomb")
			new /obj/effect/spawner/newbomb/timer/syndicate(L.loc)
			qdel(L)

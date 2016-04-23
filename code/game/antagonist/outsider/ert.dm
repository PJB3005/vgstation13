/var/datum/antagonist/ert/ert

/datum/antagonist/ert
	id                          = MODE_ERT
	bantype                     = "Emergency Response Team"
	role_text                   = "Emergency Responder"
	role_text_plural            = "Emergency Responders"
	welcome_text                = "<span class='notice'>You are a member of an Emergency Response Team, a type of military division, under CentComm's service.</span>"
	leader_welcome_text         = "<span class='notice'>You are the <B>LEADER</B> of an Emergency Response Team, a type of military division, under CentComm's service.</span>"
	landmark_id                 = "Response Team"
	id_type                     = /obj/item/weapon/card/id/centcom/ERT

	flags                       = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator          = "hudloyalist"

	hard_cap                    = 5
	show_objectives_on_creation = FALSE // We are not antagonists, we do not need the antagonist shpiel/objectives.

/datum/antagonist/ert/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M))
		M.age = (M.mind == leader ? rand(23, 35) : rand(35, 45))

/datum/antagonist/ert/New()
	..()
	ert = src

/datum/antagonist/ert/greet(var/datum/mind/player)
	if(!..())
		return

	if(player.mind != leader)
		to_chat(new_commando, "<b>As member of the Emergency Response Team, you answer only to your leader and CentComm officials.</b>")
	else
		to_chat(new_commando, "<b>As leader of the Emergency Response Team, you answer only to CentComm, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however.")

	to_chat(new_commando, "<b>You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)
	//Special radio setup
	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(player), slot_ears)

	//Adding Camera Network
	var/obj/machinery/camera/camera = new /obj/machinery/camera(player) //Gives all the commandos internals cameras.
	camera.network = "CREED"
	camera.c_tag = real_name

	//Basic Uniform
	player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate/tacticool(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/device/flashlight(player), slot_l_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/clipboard(player), slot_r_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun(player), slot_belt)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(player), slot_wear_mask)

	//Glasses
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(player), slot_glasses)

	//Shoes & gloves
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), slot_gloves)

	//Backpack
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival/engineer(player), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(player), slot_in_backpack)

	implant_mob(player, /obj/item/weapon/implant/loyalty)

	var/obj/item/card/id/id = create_id(role_text + (player.mind == leader ? " Leader" : ""), player)
	if (player.mind == leader)
		id.access |= get_centcom_access("Emergency Responders Leader")
		W.icon_state = "ERT_empty"  // Placeholder until a supposed revamp mentioned in an older, now gone comment.

	else
		W.access = get_centcom_access("Emergency Responders Leader")
		W.icon_state = "ERT_leader"

	return 1

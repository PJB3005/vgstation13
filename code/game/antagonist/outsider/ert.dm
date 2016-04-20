/var/datum/antagonist/ert/ert

/datum/antagonist/ert
	id                          = MODE_ERT
	bantype                     = "Emergency Response Team"
	role_text                   = "Emergency Responder"
	role_text_plural            = "Emergency Responders"
	welcome_text                = "As member of the Emergency Response Team, you answer only to your leader and company officials."
	leader_welcome_text         = "As leader of the Emergency Response Team, you answer only to the Company, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."
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
	to_chat(player.current, "The Emergency Response Team works for Asset Protection; your job is to protect [company_name]'s ass-ets. There is a code red alert on [station_name()], you are tasked to go and fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

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

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(src)
	L.imp_in = src
	L.implanted = 1

	var/obj/item/card/id/id = create_id(role_text + (player.mind == leader ? " Leader" : ""), player)
	if (player.mind == leader)
		id.access |= get_centcom_access("Emergency Responders Leader")
		W.icon_state = "ERT_empty"	// Placeholder until a supposed revamp mentioned in an older, now gone comment.

	else
		W.access = get_centcom_access("Emergency Responders Leader")
		W.icon_state = "ERT_leader"

	return 1

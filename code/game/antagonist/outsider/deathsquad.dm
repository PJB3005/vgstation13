/var/datum/antagonist/deathsquad/deathsquad

/datum/antagonist/deathsquad
	id                  = MODE_DEATHSQUAD
	role_text           = "Death Commando"
	role_text_plural    = "Death Commandos"
	welcome_text        = "<span class='notice'>You are a Special Ops. commando in the service of Central Command. Check the table ahead for detailed instructions."
	leader_welcome_text = "<span class='notice'>You are a Special Ops. <B>LEADER</B> in the service of Central Command. Check the table ahead for detailed instructions."
	landmark_id         = "Commando"
	flags               = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_HAS_LEADER | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator  = "huddeathsquad"
	hard_cap            = 6
	faction             = "deathsquad"

	var/deployed        = FALSE

/datum/antagonist/deathsquad/New(var/no_reference)
	..()
	if (!no_reference)
		deathsquad = src

	default_access = get_centcom_access("Death Commando")

// Used by admins through strike_team()
/datum/antagonist/deathsquad/proc/set_mission(var/new_mission)
	global_objectives += new /datum/objective(new_mission)

/datum/antagonist/deathsquad/attempt_spawn()
	if (..())
		deployed = TRUE

/datum/antagonist/deathsquad/equip(var/mob/living/carbon/human/player)
	if (!..())
		return

	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/deathsquad(src), slot_ears)

	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(player), slot_w_uniform)
	else
		player.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(player), slot_w_uniform)

	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/deathsquad(src), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/suit/space/rig/deathsquad(src), slot_wear_suit)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(src), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/rig/deathsquad(src), slot_head)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(src), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(src), slot_glasses)

	player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(src), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box(src), slot_in_backpack)

	player.equip_to_slot_or_del(new /obj/item/ammo_storage/box/a357(src), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(src), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/pinpointer(src), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/shield/energy(src), slot_in_backpack)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/weapon/disk/nuclear(src), slot_in_backpack)
	else
		player.equip_to_slot_or_del(new /obj/item/weapon/plastique(src), slot_in_backpack)

	player.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(src), slot_l_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/tank/emergency_oxygen/double(src), slot_s_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/mateba(src), slot_belt)

	player.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse_rifle(src), slot_r_hand)

	implant_mob(player, /obj/item/weapon/implant/loyalty)
	implant_mob(player, /obj/item/weapon/implant/explosive)

	var/obj/item/weapon/card/id/id = create_id("Death Commando", player)
	id.icon_state = "deathsquad"

/datum/antagonist/deathsquad/update_antag_mob(var/datum/mind/player)
	..()

	var/syndicate_commando_rank
	if (player == leader)
		syndicate_commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
	else
		syndicate_commando_rank = pick("Lieutenant", "Captain", "Major")

	var/syndicate_commando_name = pick(last_names)

	var/datum/preferences/A = new() //Randomize appearance for the commando.
	A.randomize_appearance_for(player.current)

	player.name = "[syndicate_commando_rank] [syndicate_commando_name]"
	player.current.name = player.name
	player.current.real_name = player.current.name

/datum/antagonist/deathsquad/finalize_spawn()
	return ..()

/datum/antagonist/deathsquad/proc/spawn_map_equipment()
	for (var/obj/effect/landmark/L in landmarks_list)
		if (L.name == "Commando_Manual")
			var/obj/item/weapon/paper/P = new(L.loc)
			P.info = "<p><b>Good morning soldier!</b>. This compact guide will familiarize you with standard operating procedure. There are three basic rules to follow:<br>#1 Work as a team.<br>#2 Accomplish your objective at all costs.<br>#3 Leave no witnesses.<br>You are fully equipped and stocked for your mission--before departing on the Spec. Ops. Shuttle due South, make sure that all operatives are ready. Actual mission objective will be relayed to you by Central Command through your headsets.<br>If deemed appropriate, Central Command will also allow members of your team to equip assault power-armor for the mission. You will find the armor storage due West of your position. Once you are ready to leave, utilize the Special Operations shuttle console and toggle the hull doors via the other console.</p><p>In the event that the team does not accomplish their assigned objective in a timely manner, or finds no other way to do so, attached below are instructions on how to operate a Nanotrasen Nuclear Device. Your operations <b>LEADER</b> is provided with a nuclear authentication disk and a pin-pointer for this reason. You may easily recognize them by their rank: Lieutenant, Captain, or Major. The nuclear device itself will be present somewhere on your destination.</p><p>Hello and thank you for choosing Nanotrasen for your nuclear information needs. Today's crash course will deal with the operation of a Fission Class Nanotrasen made Nuclear Device.<br>First and foremost, <b>DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE.</b> Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done to unbolt it one must completely log in which at this time may not be possible.<br>To make the device functional:<br>#1 Place bomb in designated detonation zone<br> #2 Extend and anchor bomb (attack with hand).<br>#3 Insert Nuclear Auth. Disk into slot.<br>#4 Type numeric code into keypad ([global.station_nuke_code]).<br>Note: If you make a mistake press R to reset the device.<br>#5 Press the E button to log onto the device.<br>You now have activated the device. To deactivate the buttons at anytime, for example when you have already prepped the bomb for detonation, remove the authentication disk OR press the R on the keypad. Now the bomb CAN ONLY be detonated using the timer. A manual detonation is not an option.<br>Note: Toggle off the <b>SAFETY</b>.<br>Use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>Note: <b>THE BOMB IS STILL SET AND WILL DETONATE</b><br>Now before you remove the disk if you need to move the bomb you can: Toggle off the anchor, move it, and re-anchor.</p><p>The nuclear authorization code is: <b>[global.station_nuke_code || "None provided"]</b></p><p><b>Good luck, soldier!</b></p>"
			P.name = "Spec. Ops. Manual"

	for (var/obj/effect/landmark/L in landmarks_list)
		if (L.name == "Commando-Bomb")
			new /obj/effect/spawner/newbomb/timer/syndicate(L.loc)
			qdel(L)

/datum/antagonist/deathsquad/create_antagonist()
	if (..() && !deployed)
		deployed = TRUE

/datum/antagonist/deathsquad/create_default(var/mob/source)
	var/mob/living/carbon/human/H = ..()
	if (istype(H))
		H.gender = pick(MALE, FEMALE)
		H.age    = (player == leader ? rand(23, 35) : rand(35, 45))

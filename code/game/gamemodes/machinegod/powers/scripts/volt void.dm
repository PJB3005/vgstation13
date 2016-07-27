/datum/clockcult_power/channeled/volt_void
	name           = "Volt Void"
	desc           = "While chanting, the cultist will glow a brilliant orange, and proceed to drain energy from all APCs, mechas, pods, borgs, and other electronic equipment in the vicinity. The energy will be redirected to the cultist's body parts, causing burn damage over time that scales with how much is absorbed. The damage can be fatal if allowed to channel for too long. Robotic limbs are restored instead of damaged, and have priority to receive energy over flesh, allowing augmented cultists to use Volt Void for longer periods of time."
	category       = CLOCK_SCRIPTS

	invocation     = "Qenj punetr gb guv'f furyy!"
	loudness       = CLOCK_CHANTED
	req_components = list(CLOCK_BELLIGERENT = 1, CLOCK_HIEROPHANT = 1)

	channel_amount = 30
	channel_time   = 2 SECONDS

	var/static/drainage_amount = 500

/datum/clockcult_power/channeled/volt_void/activate(var/mob/user, var/obj/item/clockslab/C, var/list/participants)
	animate(user, color = "#FF9900", time = channel_amount * channel_time)
	playsound(get_turf(user), 'sound/effects/EMPulse.ogg', 100, 1)
	return ..()

#warn TODO: dear god the performance.
/datum/clockcult_power/channeled/volt_void/channel_effect(var/mob/user, var/obj/item/clockslab/C, var/list/participants, var/channeled_amount)
	var/list/powercells = list()
	for (var/obj/machinery/M in range(9, user))
		powercells += recursive_type_check(M, /obj/item/weapon/cell)

	for (var/obj/mecha/A in range(9,user))
		powercells += recursive_type_check(A, /obj/item/weapon/cell)

	for (var/mob/living/L in range(9,user))
		powercells += recursive_type_check(L, /obj/item/weapon/cell)
		if(istype(L, /mob/living/silicon))
			to_chat(L, "<span class='warning'>SYSTEM ALERT: Energy drain detected!</span>")

	var/power_taken = 0

	for (var/obj/item/weapon/cell/PC in powercells)
		if (PC.charge <= 0)
			powercells -= PC
			continue

		// Cell code doesn't drain from the cell if the cell has less than the requested amount.
		var/to_drain = min(PC.charge, drainage_amount)
		power_taken += to_drain

		PC.use(to_drain)

	if (!ishuman(user))
		if (!isliving(user))
			return

		var/mob/living/L = user
		L.apply_damage(round(power_taken / drainage_amount), BURN)
		return

	var/mob/living/carbon/human/H = user

	var/list/datum/organ/external/robotic_organs = list()
	var/list/datum/organ/external/normal_organs = list()

	for (var/datum/organ/external/O in H.organs)
		if (O.status & ORGAN_ROBOT)
			robotic_organs += O
		else
			normal_organs += O

	robotic_organs = shuffle(robotic_organs)
	normal_organs = shuffle(normal_organs)

	// Healing happens in sequence for simplicity's sake.
	for (var/datum/organ/external/O in robotic_organs)
		var/brute_healed = Clamp(power_taken * 2 / drainage_amount, 0, O.brute_dam)
		power_taken = max(0, brute_healed * drainage_amount / 2)

		var/burn_healed  = Clamp(power_taken / drainage_amount, 0, O.burn_dam)
		power_taken = max(0, brute_healed * drainage_amount)

		O.heal_damage(brute_healed, burn_healed, TRUE, TRUE)
		if (power_taken < 1) // Floating point imprecisions.
			return

	var/burn_damage = normal_organs.len / (power_taken / drainage_amount)
	for (var/datum/organ/external/O in normal_organs)
		O.take_damage(0, burn_damage)

/datum/clockcult_power/channeled/volt_void/channel_end(var/mob/user, var/obj/item/clockslab/C, var/list/participants, var/total_channeled)
	playsound(get_turf(user), 'sound/effects/EMPulse.ogg', 100, 1)
	animate(user, color = null, time = 5, easing = SINE_EASING)

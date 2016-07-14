// Basic interface, useless for anything.
/datum/access
	var/obj/owner // Currently assigned owner.

	var/obj/item/access_chip/chip // Access chip that holds us.

/datum/access/New(var/new_chip)
	chip = new_chip
	..()

/datum/access/Destroy()
	chip  = null
	owner = null

/datum/access/assign_object(var/new_owner)
	owner = new_owner

/datum/access/unassign_object()
	owner = null


// PUBLIC API HERE.
// Checks if this mob can access this access datum.
/datum/access/list/check_mob(var/mob/M)
	return FALSE

// Checks if this list of access levels fits, only here for access list-based access datums.
/datum/access/list/check_list(var/list/L)
	return FALSE

// Checks if this item can access this access datum.
/datum/access/proc/check_item(var/item/I)
	return FALSE


// ACTUALLY USEFUL ACCESS DATUM SUBTYPES HERE.

// CONVENTIONAL ACCESS LEVEL SYSTEM.
/datum/access/access_lists
	var/list/req_all
	var/list/req_one
	var/list/req_non

/datum/access/access_lists/check_mob(var/mob/M)
	if (!req_all && !req_one && !req_non)
		return TRUE

	for (var/obj/item/I in list(M.get_item_by_slot(slot_wear_id), M.get_active_hand()))
		if (check_item(I))
			return TRUE

/datum/access/access_lists/check_item(var/item/I)
	return check_list(I.GetAccess())

/datum/access/list/check_list(var/list/L)
	if (!req_all && !req_one && !req_non)
		return TRUE

	if (req_one)
		var/list/same = access_list & req_one
		if (!same || !same.len)
			return FALSE

	if (req_non)
		var/list/same = access_list & req_non
		if (same && same.len)
			return FALSE

	if (req_all)
		for (var/key in req_all)
			if (!access_list.Find(key))
				return FALSE

	return TRUE


// Biometric scanners, checks UI + UE of the mob.
/datum/access/biometric
	var/list/dna_strings // List of strings of accepted UI + UE

/datum/access/biometric/New(var/new_chip)
	..()

/datum/access/biometric/proc/add_mob(var/mob/living/carbon/C)
	if (!C.dna)
		return

	dna_strings |= "[C.dna.uni_identity]+[C.dna.unique_enzymes]"

/datum/access/biometric/proc/remove_mob(var/mob/living/carbon/C)
	if (!C.dna)
		return

	dna_strings -= "[C.dna.uni_identity]+[C.dna.unique_enzymes]"


/datum/access/biometric/proc/check_mob(var/mob/M)
	if (!iscarbon(M))
		return FALSE

	var/mob/living/carbon/C = M

	return C.dna && ("[C.dna.uni_identity]+[C.dna.unique_enzymes]" in dna_strings)

/datum/access/species
	var/set_species

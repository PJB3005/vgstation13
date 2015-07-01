//Datum which controls part attachement slots on vehicle parts.
/datum/vehicle_part_slot
	var/offset_x = 0 //Offsets, relative to the owning part offset.
	var/offset_y = 0

	var/obj/item/vehicle_part/attached_part
	var/obj/item/vehicle_part/owner

	var/attach_side = ATTACH_SIDE

	var/slot_keys[0] //List of strings containing "keys" as to what type of shit could attach, it's more specific than attach_side, and unlike attach_side, values are arbitrary.

	var/slot_id = 0

/datum/vehicle_part_slot/New(var/x, var/y, var/obj/item/vehicle_part/n_owner, var/side, var/list/keys)
	. = ..()
	offset_x = x
	offset_y = y

	owner = n_owner

	attach_side = side

	slot_keys = keys

	if(!owner)
		Warning("A vehicle part slot was created without an owner!")
		qdel(src)

	slot_id = owner.attach_slots.Find(src)

	if(!slot_id)
		qdel(src)

/datum/vehicle_part_slot/Destroy()
	if(attached_part)
		detach()

	if(owner)
		owner.attach_slots -= src

//Checks if the part can attach.
/datum/vehicle_part_slot/proc/can_attach(var/obj/item/vehicle_part/P, var/mob/user)
	if(attached_part || P.master || P.attach_side != attach_side || !(P.slot_type in slot_keys))
		return

	. = 1

//Attaches the part.
/datum/vehicle_part_slot/proc/attach(var/obj/item/vehicle_part/P, var/mob/user, var/no_sprite_rebuild = 0)
	attached_part = P
	owner.attached[slot_id] = P
	P.master = owner

	P.vehicle = owner.vehicle

	if(!no_sprite_rebuild)
		owner.vehicle.update_icon()

//Detaches the attached part, returns the part detached.
/datum/vehicle_part_slot/proc/detach(var/no_sprite_rebuild = 0)
	. = attached_part

	owner.attached -= .

	attached_part.vehicle = null
	attached_part.master = null

	attached_part = null

	if(!no_sprite_rebuild)
		owner.vehicle.update_icon()



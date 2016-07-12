/datum/clockcult_power/create_object/replica_fab
	name           = "Replica Fabricator"
	desc           = "Forms a handheld device that acts like a cult RCD. Requires metal to function. Walls and floors in the Ratvar style give various bonuses and debuffs to people occupying the tiles. Doors made by this open only for the faithful, but can be broken down."
	category       = CLOCK_SCRIPTS

	invocation     = "Jvgu guv'f qrivpr, uvf cerfrapr funyy or znqr xabja"
	loudness       = CLOCK_WHISPERED
	cast_time      = 0
	req_components = list(CLOCK_VANGUARD = 1, CLOCK_REPLICANT = 1)

	object_type    = /obj/item/device/rcd/replicafab

	creator_message = "<span class='clockwork'>You shape the Replica Fabricator with your mind."

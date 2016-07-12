#warn TODO: split this file & kill it.
/obj/item/clothing/head/clockcult
	name = "cult hood"
	icon_state = "clockwork"
	desc = "A hood worn by the followers of Ratvar."
	flags = FPRINT | ONESIZEFITSALL
	armor = list(ARMOR_MELEE = 30, ARMOR_BULLET = 10, ARMOR_LASER = 5, ARMOR_ENERGY = 5, ARMOR_BOMB = 0, ARMOR_BIO = 0, ARMOR_RAD = 0)
	body_parts_covered = HEAD | EYES | HIDEFACE
	heat_conductivity = SPACESUIT_HEAT_CONDUCTIVITY
	siemens_coefficient = 0

/obj/item/clothing/suit/clockcult
	name = "cult robes"
	desc = "A set of armored robes worn by the followers of Ratvar"
	icon_state = "clockwork"
	item_state = "clockwork"
	flags = FPRINT | ONESIZEFITSALL
	body_parts_covered = FULL_TORSO | LEGS | ARMS
	//allowed = list(slab, repfab, components, etc)
	armor = list(ARMOR_MELEE = 50, ARMOR_BULLET = 30, ARMOR_LASER = 50, ARMOR_ENERGY = 20, ARMOR_BOMB = 25, ARMOR_BIO = 10, ARMOR_RAD = 0)
	siemens_coefficient = 0

/obj/item/clothing/shoes/clockcult
	name = "boots"
	desc = "A pair of boots worn by the followers of Ratvar."
	icon_state = "clockwork"
	item_state = "clockwork"
	_color = "clockwork"
	siemens_coefficient = 0.7

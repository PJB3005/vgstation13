/obj/item/clothing/glasses/scanner/material/mining
	name = "optical ore scanners"
	desc = "Allows the wearer to see ores inside rocks."

	var/obj/screen/plane_master/mining_ore/plane_master

/obj/item/clothing/glasses/scanner/material/mining/New()
	..()
	plane_master = new

/obj/item/clothing/glasses/scanner/material/mining/Destroy()
	qdel(plane_master)
	plane_master = null

	return ..()

/obj/item/clothing/glasses/scanner/material/mining/clear()
	if (!viewing || !viewing.client)
		return

	viewing.client.screen -= plane_master

/obj/item/clothing/glasses/scanner/material/mining/apply()
	if (!viewing || !viewing.client || !on)
		return

	viewing.client.screen += plane_master

/obj/screen/plane_master/mining_ore
	plane = PLANE_ORE

	color = list(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	)

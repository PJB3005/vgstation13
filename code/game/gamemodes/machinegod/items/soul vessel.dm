/obj/item/device/mmi/posibrain/soulvessel
	name = "soul vessel"
	desc = "A cube of ancient, glowing metal, three inches to a side and embedded with a cogwheel of sorts."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "soulvessel"
	w_class = W_CLASS_SMALL
	origin_tech = "engineering=5;materials=5;bluespace=2;programming=5"

	req_access = null

/obj/item/device/mmi/posibrain/soulvessel/check_observer(var/mob/dead/observer/O)
	return !jobban_isbanned(O, ROLE_CLOCKCULT) && ..()

/obj/item/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = WEIGHT_CLASS_SMALL
	materials = list(MAT_METAL = 50, MAT_GLASS = 50)
	origin_tech = "engineering=2;programming=1"
	toolspeed = 1
	usesound = 'sound/items/deconstruct.ogg'

	multitool_menu_type = /datum/multitool_menu/idtag/airlock_electronics

	var/obj/item/access_control/access_electronics = null
	var/id

/obj/item/airlock_electronics/multitool_act(mob/user, obj/item/I)
	. = TRUE
	multitool_menu_interact(user, I)

/obj/item/airlock_electronics/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/access_control) && !access_electronics)
		if(!user.drop_transfer_item_to_loc(I, src))
			return
		access_electronics = I
		update_icon(UPDATE_OVERLAYS)
		return TRUE
	return ..()

/obj/item/airlock_electronics/screwdriver_act(mob/living/user, obj/item/I)
	if(!access_electronics)
		return FALSE
	access_electronics.forceMove_turf()
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		carbon_user.put_in_hands(access_electronics, ignore_anim = FALSE)
	access_electronics = null
	update_icon(UPDATE_OVERLAYS)
	return TRUE

/obj/item/airlock_electronics/update_overlays()
	. = ..()
	if(access_electronics)
		. += "access-control-overlay"

/obj/item/airlock_electronics/syndicate
	name = "suspicious airlock electronics"

/*
 * Contents:
 *		Welding mask
 *		Cakehat
 *		Ushanka
 *		Pumpkin head
 *		Kitty ears
 *		Cardborg Disguise
 *		Head Mirror
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	item_state = "welding"
	materials = list(MAT_METAL=1750, MAT_GLASS=400)
	flash_protect = 2
	tint = 2
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 60)
	flags_inv = HIDEMASK|HIDEHEADSETS|HIDEGLASSES|HIDENAME
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEMASK|HIDEHEADSETS|HIDEGLASSES|HIDENAME
	resistance_flags = FIRE_PROOF
	var/paint = null

	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/head.dmi',
		"Unathi" = 'icons/mob/species/unathi/helmet.dmi',
		"Tajaran" = 'icons/mob/species/tajaran/helmet.dmi',
		"Vulpkanin" = 'icons/mob/species/vulpkanin/helmet.dmi',
		"Grey" = 'icons/mob/species/grey/helmet.dmi',
		"Monkey" = 'icons/mob/species/monkey/head.dmi',
		"Farwa" = 'icons/mob/species/monkey/head.dmi',
		"Wolpin" = 'icons/mob/species/monkey/head.dmi',
		"Neara" = 'icons/mob/species/monkey/head.dmi',
		"Stok" = 'icons/mob/species/monkey/head.dmi'
		)

/obj/item/clothing/head/welding/attack_self(mob/user)
	weldingvisortoggle(user)

/obj/item/clothing/head/welding/flamedecal
	name = "flame decal welding helmet"
	desc = "A welding helmet adorned with flame decals, and several cryptic slogans of varying degrees of legibility."
	icon_state = "welding_redflame"

/obj/item/clothing/head/welding/flamedecal/blue
	name = "blue flame decal welding helmet"
	desc = "A welding helmet with blue flame decals on it."
	icon_state = "welding_blueflame"

/obj/item/clothing/head/welding/flamedecal/white
	name = "white decal welding helmet"
	desc = "A white welding helmet with a character written across it."
	icon_state = "welding_white"

/obj/item/clothing/head/welding/attack_self()
	toggle()

/obj/item/clothing/head/welding/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/toy/crayon/spraycan))
		if(icon_state != "welding")
			to_chat(user, "<span class = 'warning'>Похоже, тут уже есть слой краски!</span>")
			return
		var/obj/item/toy/crayon/spraycan/C = I
		if(C.capped)
			to_chat(user, "<span class = 'warning'>Вы не можете раскрасить [src], если крышка на банке закрыта!</span>")
			return
		var/list/weld_icons = list("Flame" = image(icon = src.icon, icon_state = "welding_redflame"),
									"Blue Flame" = image(icon = src.icon, icon_state = "welding_blueflame"),
									"White Flame" = image(icon = src.icon, icon_state = "welding_white"))
		var/list/weld = list("Flame" = "welding_redflame",
							"Blue Flame" = "welding_blueflame",
							"White Flame" = "welding_white")
		var/choice = show_radial_menu(user, src, weld_icons)
		if(!choice || I.loc != user || !Adjacent(user))
			return
		if(C.uses <= 0)
			to_chat(user, "<span class = 'warning'>Не похоже что бы осталось достаточно краски.</span>")
			return
		icon_state = weld[choice]
		paint = weld[choice]
		C.uses--
		update_icon()
	if(istype(I, /obj/item/soap) && (icon_state != initial(icon_state)))
		icon_state = initial(icon_state)
		paint = null
		update_icon()
	else
		return ..()


/obj/item/clothing/head/welding/proc/toggle()
	if(up)
		up = !up
		flags_cover |= (HEADCOVERSEYES | HEADCOVERSMOUTH)
		flags_inv |= (HIDEMASK|HIDEHEADSETS|HIDEGLASSES|HIDENAME)
		if(paint)
			icon_state = paint
		else
			icon_state = initial(icon_state)
		to_chat(usr, "You flip the [src] down to protect your eyes.")
		flash_protect = 2
		tint = 2
	else
		up = !up
		flags_cover &= ~(HEADCOVERSEYES | HEADCOVERSMOUTH)
		flags_inv &= ~(HIDEMASK|HIDEHEADSETS|HIDEGLASSES|HIDENAME)
		if(paint)
			icon_state = "[paint]up"
		else
			icon_state = "[initial(icon_state)]up"
		to_chat(usr, "You push the [src] up out of your face.")
		flash_protect = 0
		tint = 0
	var/mob/living/carbon/user = usr
	user.update_tint()
	user.update_inv_head()	//so our mob-overlays update
	user.update_inv_wear_mask()

	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()



/*
 * Cakehat
 */
/obj/item/clothing/head/cakehat
	name = "cake-hat"
	desc = "It's tasty looking!"
	icon_state = "cake0"
	flags_cover = HEADCOVERSEYES
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	var/onfire = 0.0
	var/status = 0
	var/fire_resist = T0C+1300	//this is the max temp it can stand before you start to cook. although it might not burn away, you take damage
	var/processing = 0 //I dont think this is used anywhere.

/obj/item/clothing/head/cakehat/process()
	if(!onfire)
		STOP_PROCESSING(SSobj, src)
		return

	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/living/carbon/human/M = location
		if(M.l_hand == src || M.r_hand == src || M.head == src)
			location = M.loc

	if(istype(location, /turf))
		location.hotspot_expose(700, 1)

/obj/item/clothing/head/cakehat/attack_self(mob/user as mob)
	if(status > 1)	return
	src.onfire = !( src.onfire )
	if(src.onfire)
		src.force = 3
		src.damtype = "fire"
		src.icon_state = "cake1"
		START_PROCESSING(SSobj, src)
	else
		src.force = null
		src.damtype = "brute"
		src.icon_state = "cake0"
	return


/*
 * Soviet Hats
 */
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	item_state = "ushankadown"
	flags_inv = HIDEHEADSETS
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	dog_fashion = /datum/dog_fashion/head/ushanka
	sprite_sheets = list(
		"Grey" = 'icons/mob/species/grey/head.dmi',
		"Monkey" = 'icons/mob/species/monkey/head.dmi',
		"Farwa" = 'icons/mob/species/monkey/head.dmi',
		"Wolpin" = 'icons/mob/species/monkey/head.dmi',
		"Neara" = 'icons/mob/species/monkey/head.dmi',
		"Stok" = 'icons/mob/species/monkey/head.dmi'
	)

/obj/item/clothing/head/ushanka/attack_self(mob/user as mob)
	if(src.icon_state == "ushankadown")
		src.icon_state = "ushankaup"
		src.item_state = "ushankaup"
		to_chat(user, "You raise the ear flaps on the ushanka.")
	else
		src.icon_state = "ushankadown"
		src.item_state = "ushankadown"
		to_chat(user, "You lower the ear flaps on the ushanka.")

/obj/item/clothing/head/sovietsidecap
	name = "\improper Soviet side cap"
	desc = "A simple military cap with a Soviet star on the front. What it lacks in protection it makes up for in revolutionary spirit."
	icon_state = "sovietsidecap"
	item_state = "sovietsidecap"

/obj/item/clothing/head/sovietofficerhat
	name = "\improper Soviet officer hat"
	desc = "A military officer hat designed to stand out so the conscripts know who is in charge."
	icon_state = "sovietofficerhat"
	item_state = "sovietofficerhat"

/obj/item/clothing/head/sovietadmiralhat
	name = "\improper Soviet admiral hat"
	desc = "This hat clearly belongs to someone very important."
	icon_state = "sovietadmiralhat"
	item_state = "sovietadmiralhat"

/obj/item/clothing/head/soviethelmet
	name = "SSh-68"
	desc = "Soviet steel combat helmet."
	icon_state = "soviethelm"
	item_state = "soviethelm"
	flags = BLOCKHAIR
	flags_inv = HIDEHEADSETS
	armor = list("melee" = 25, "bullet" = 35, "laser" = 15, "energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	materials = list(MAT_METAL=2500)

/*
 * Pumpkin head
 */
/obj/item/clothing/head/hardhat/pumpkinhead
	name = "carved pumpkin"
	desc = "A jack o' lantern! Believed to ward off evil spirits."
	icon_state = "hardhat0_pumpkin"//Could stand to be renamed
	item_state = "hardhat0_pumpkin"
	item_color = "pumpkin"
	flags = BLOCKHAIR
	flags_inv = HIDEMASK|HIDEHEADSETS|HIDEGLASSES|HIDENAME
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/species/vulpkanin/head.dmi',
		"Grey" = 'icons/mob/species/grey/head.dmi',
		"Monkey" = 'icons/mob/species/monkey/head.dmi',
		"Farwa" = 'icons/mob/species/monkey/head.dmi',
		"Wolpin" = 'icons/mob/species/monkey/head.dmi',
		"Neara" = 'icons/mob/species/monkey/head.dmi',
		"Stok" = 'icons/mob/species/monkey/head.dmi'
	)

	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	brightness_on = 2 //luminosity when on


/obj/item/clothing/head/hardhat/reindeer
	name = "novelty reindeer hat"
	desc = "Some fake antlers and a very fake red nose."
	icon_state = "hardhat0_reindeer"
	item_state = "hardhat0_reindeer"
	item_color = "reindeer"
	flags_inv = 0
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	brightness_on = 1 //luminosity when on
	dog_fashion = /datum/dog_fashion/head/reindeer


/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = "kitty"
	var/icon/mob
	dog_fashion = /datum/dog_fashion/head/kitty

/obj/item/clothing/head/kitty/update_icon(var/mob/living/carbon/human/user)
	if(!istype(user)) return
	var/obj/item/organ/external/head/head_organ = user.get_organ("head")

	mob = new/icon("icon" = 'icons/mob/head.dmi', "icon_state" = "kitty")
	mob.Blend(head_organ.hair_colour, ICON_ADD)

	var/icon/earbit = new/icon("icon" = 'icons/mob/head.dmi', "icon_state" = "kittyinner")
	mob.Blend(earbit, ICON_OVERLAY)

	icon_override = mob

/obj/item/clothing/head/kitty/equipped(mob/M, slot, initial)
	. = ..()

	if(ishuman(M) && slot == slot_head)
		update_icon(M)


/obj/item/clothing/head/kitty/mouse
	name = "mouse ears"
	desc = "A pair of mouse ears. Squeak!"
	icon_state = "mousey"

/obj/item/clothing/head/kitty/mouse/update_icon(var/mob/living/carbon/human/user)
	if(!istype(user)) return
	var/obj/item/organ/external/head/head_organ = user.get_organ("head")
	mob = new/icon("icon" = 'icons/mob/head.dmi', "icon_state" = "mousey")
	mob.Blend(head_organ.hair_colour, ICON_ADD)

	var/icon/earbit = new/icon("icon" = 'icons/mob/head.dmi', "icon_state" = "mouseyinner")
	mob.Blend(earbit, ICON_OVERLAY)

	icon_override = mob

/obj/item/clothing/head/cardborg
	name = "cardborg helmet"
	desc = "A helmet made out of a box."
	icon_state = "cardborg_h"
	item_state = "cardborg_h"
	flags_inv = HIDEMASK|HIDEHEADSETS|HIDEGLASSES|HIDENAME
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	species_disguise = "High-tech robot"
	dog_fashion = /datum/dog_fashion/head/cardborg
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/species/vulpkanin/head.dmi',
		"Grey" = 'icons/mob/species/grey/head.dmi',
		"Monkey" = 'icons/mob/species/monkey/head.dmi',
		"Farwa" = 'icons/mob/species/monkey/head.dmi',
		"Wolpin" = 'icons/mob/species/monkey/head.dmi',
		"Neara" = 'icons/mob/species/monkey/head.dmi',
		"Stok" = 'icons/mob/species/monkey/head.dmi'
	)


/obj/item/clothing/head/cardborg/equipped(mob/living/user, slot, initial)
	. = ..()

	if(ishuman(user) && slot == slot_head)
		var/mob/living/carbon/human/H = user
		if(istype(H.wear_suit, /obj/item/clothing/suit/cardborg))
			var/obj/item/clothing/suit/cardborg/CB = H.wear_suit
			CB.disguise(user, src)

/obj/item/clothing/head/cardborg/dropped(mob/living/user)
	..()
	user.remove_alt_appearance("standard_borg_disguise")

/*
 * Head Mirror
 */
/obj/item/clothing/head/headmirror
	name = "head mirror"
	desc = "A band of rubber with a very reflective looking mirror attached to the front of it. One of the early signs of medical budget cuts."
	icon_state = "head_mirror"
	item_state = "head_mirror"

	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/head.dmi',
		"Drask" = 'icons/mob/species/drask/head.dmi',
		"Grey" = 'icons/mob/species/grey/head.dmi',
		"Monkey" = 'icons/mob/species/monkey/head.dmi',
		"Farwa" = 'icons/mob/species/monkey/head.dmi',
		"Wolpin" = 'icons/mob/species/monkey/head.dmi',
		"Neara" = 'icons/mob/species/monkey/head.dmi',
		"Stok" = 'icons/mob/species/monkey/head.dmi'
	)


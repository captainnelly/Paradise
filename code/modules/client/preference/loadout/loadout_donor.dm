/datum/gear/donor
	donator_tier = 2
	sort_category = "Donor"
	subtype_path = /datum/gear/donor

/datum/gear/donor/ussptracksuit_black
	donator_tier = 1
	cost = 1
	display_name = "track suit (black)"
	path = /obj/item/clothing/under/ussptracksuit_black

/datum/gear/donor/ussptracksuit_white
	donator_tier = 1
	cost = 1
	display_name = "track suit (white)"
	path = /obj/item/clothing/under/ussptracksuit_white

/datum/gear/donor/kittyears
	display_name = "Kitty ears"
	path = /obj/item/clothing/head/kitty

/datum/gear/donor/furgloves
	display_name = "Fur Gloves"
	path = /obj/item/clothing/gloves/furgloves

/datum/gear/donor/furboots
	display_name = "Fur Boots"
	path = /obj/item/clothing/shoes/furboots

/datum/gear/donor/noble_boot
	display_name = "Noble Boots"
	path = /obj/item/clothing/shoes/fluff/noble_boot

/datum/gear/donor/furcape
	display_name = "Fur Cape"
	path = /obj/item/clothing/neck/cloak/furcape

/datum/gear/donor/furcoat
	display_name = "Fur Coat"
	path = /obj/item/clothing/suit/furcoat

/datum/gear/donor/kamina
	display_name = "Spiky Orange-tinted Shades"
	path = /obj/item/clothing/glasses/fluff/kamina

/datum/gear/donor/green
	display_name = "Spiky Green-tinted Shades"
	path = /obj/item/clothing/glasses/fluff/kamina/green

/datum/gear/donor/threedglasses
	display_name = "Threed Glasses"
	path = /obj/item/clothing/glasses/threedglasses

/datum/gear/donor/blacksombrero
	display_name = "Black Sombrero"
	path = /obj/item/clothing/head/fluff/blacksombrero

/datum/gear/donor/guardhelm
	display_name = "Plastic Guard helm"
	path = /obj/item/clothing/head/fluff/guardhelm

/datum/gear/donor/goldtophat
	display_name = "Gold-trimmed Top Hat"
	path = /obj/item/clothing/head/fluff/goldtophat

/datum/gear/donor/goldtophat/red
	display_name = "Red Gold-trimmed Top Hat"
	path = /obj/item/clothing/head/fluff/goldtophat/red

/datum/gear/donor/goldtophat/blue
	display_name = "Blue Gold-trimmed Top Hat"
	path = /obj/item/clothing/head/fluff/goldtophat/blue

/datum/gear/donor/mushhat
	display_name = "Mushroom Hat"
	path = /obj/item/clothing/head/fluff/mushhat

/datum/gear/donor/furcap
	display_name = "Fur Cap"
	path = /obj/item/clothing/head/furcap

/datum/gear/donor/mouse
	display_name = "Mouse Headband"
	path = /obj/item/clothing/head/kitty/mouse

/datum/gear/donor/fawkes
	display_name = "Guy Fawkes mask"
	path = /obj/item/clothing/mask/face/fawkes

/datum/gear/donor/id_decal_silver
	display_name = "Silver ID Decal"
	path = /obj/item/id_decal/silver
	donator_tier = 3
	cost = 1

/datum/gear/donor/id_decal_prisoner
	display_name = "Prisoner ID Decal"
	path = /obj/item/id_decal/prisoner
	donator_tier = 3
	cost = 1

/datum/gear/donor/id_decal_emag
	display_name = "Emag ID Decal"
	path = /obj/item/id_decal/emag
	donator_tier = 3
	cost = 1

/datum/gear/donor/id_decal_gold
	display_name = "Gold ID Decal"
	path = /obj/item/id_decal/gold
	donator_tier = 4
	cost = 1

/datum/gear/donor/zippolghtr
	display_name = "Zippo lighter"
	path = /obj/item/lighter/zippo
	donator_tier = 1
	cost = 1

/datum/gear/donor/strip
	subtype_path = /datum/gear/donor/strip
	subtype_cost_overlap = FALSE

/datum/gear/donor/strip/cap
	display_name = "strip, Captain"
	path = /obj/item/clothing/accessory/head_strip
	donator_tier = 2
	cost = 1
	allowed_roles = list(JOB_TITLE_CAPTAIN)

/datum/gear/donor/strip/rd
	display_name = "strip, Research Director"
	path = /obj/item/clothing/accessory/head_strip/rd
	donator_tier = 2
	cost = 1
	allowed_roles = list(JOB_TITLE_RD)

/datum/gear/donor/strip/ce
	display_name = "strip, Chief Engineer"
	path = /obj/item/clothing/accessory/head_strip/ce
	donator_tier = 2
	cost = 1
	allowed_roles = list(JOB_TITLE_CHIEF)

/datum/gear/donor/strip/cmo
	display_name = "strip, Chief Medical Officer"
	path = /obj/item/clothing/accessory/head_strip/cmo
	donator_tier = 2
	cost = 1
	allowed_roles = list(JOB_TITLE_CMO)

/datum/gear/donor/strip/hop
	display_name = "strip, Head of Personnel"
	path = /obj/item/clothing/accessory/head_strip/hop
	donator_tier = 2
	cost = 1
	allowed_roles = list(JOB_TITLE_HOP)

/datum/gear/donor/strip/hos
	display_name = "strip, Head of Security"
	path = /obj/item/clothing/accessory/head_strip/hos
	donator_tier = 2
	cost = 1
	allowed_roles = list(JOB_TITLE_HOS)

/datum/gear/donor/strip/qm
	display_name = "strip, Quartermaster"
	path = /obj/item/clothing/accessory/head_strip/qm
	donator_tier = 2
	cost = 1
	allowed_roles = list(JOB_TITLE_QUARTERMASTER)

/datum/gear/donor/heartglasses
	display_name = "heart-shaped glasses, color"
	path = /obj/item/clothing/glasses/heart
	donator_tier = 3
	cost = 1
	slot = SLOT_HUD_GLASSES

/datum/gear/donor/heartglasses/New()
	gear_tweaks += new /datum/gear_tweak/color(parent = src)

/datum/gear/donor/night_dress
	display_name = "night dress, select"
	description = "A classic night dress."
	cost = 1
	donator_tier = 3
	path = /obj/item/clothing/under/night_dress

/datum/gear/donor/night_dress/New()
	..()
	var/list/skirts = list("black" = /obj/item/clothing/under/night_dress,
							"darkred" = /obj/item/clothing/under/night_dress/darkred,
							"red" = /obj/item/clothing/under/night_dress/red,
							"silver" = /obj/item/clothing/under/night_dress/silver,
							"white" = /obj/item/clothing/under/night_dress/white,)
	gear_tweaks += new /datum/gear_tweak/path(skirts, src)

/datum/gear/donor/strip/cheese_badge
	display_name = "great fellow's badge"
	path = /obj/item/clothing/accessory/head_strip/cheese_badge
	donator_tier = 4
	cost = 1

/datum/gear/donor/smile_pin
	display_name = "smiling pin"
	path = /obj/item/clothing/accessory/medal/smile
	donator_tier = 4
	cost = 1
	allowed_roles = list(JOB_TITLE_CAPTAIN, JOB_TITLE_QUARTERMASTER, JOB_TITLE_RD, JOB_TITLE_HOS, JOB_TITLE_HOP, JOB_TITLE_CMO, JOB_TITLE_CHIEF, JOB_TITLE_REPRESENTATIVE, JOB_TITLE_JUDGE)

/datum/gear/donor/backpack_hiking
	donator_tier = 3
	cost = 1
	display_name = "backpack, Fancy Hiking Pack"
	path = /obj/item/storage/backpack/fluff/hiking

/datum/gear/donor/backpack_brew
	donator_tier = 3
	cost = 1
	display_name = "backpack, The brew"
	path = /obj/item/storage/backpack/fluff/thebrew

/datum/gear/donor/backpack_cat
	donator_tier = 3
	cost = 1
	display_name = "backpack, CatPack"
	path = /obj/item/storage/backpack/fluff/ssscratches_back

/datum/gear/donor/backpack_voxcaster
	donator_tier = 3
	cost = 1
	display_name = "backpack, Voxcaster"
	path = /obj/item/storage/backpack/fluff/krich_back

/datum/gear/donor/backpack_syndi
	donator_tier = 3
	cost = 1
	display_name = "backpack, Military Satchel"
	path = /obj/item/storage/backpack/fluff/syndiesatchel

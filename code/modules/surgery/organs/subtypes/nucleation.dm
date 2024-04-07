//NUCLEATION ORGAN
/obj/item/organ/internal/nucleation
	species_type = /datum/species/nucleation
	name = "nucleation organ"
	icon = 'icons/obj/surgery.dmi'
	desc = "A crystalized human organ. <span class='danger'>It has a strangely iridescent glow.</span>"


/obj/item/organ/internal/nucleation/resonant_crystal
	name = "resonant crystal"
	icon_state = "resonant-crystal"
	parent_organ_zone = BODY_ZONE_HEAD
	slot = INTERNAL_ORGAN_RESONANT_CRYSTAL


/obj/item/organ/internal/nucleation/strange_crystal
	name = "strange crystal"
	icon_state = "strange-crystal"
	parent_organ_zone = BODY_ZONE_CHEST
	slot = INTERNAL_ORGAN_STRANGE_CRYSTAL


/obj/item/organ/internal/eyes/luminescent_crystal
	species_type = /datum/species/nucleation
	name = "luminescent eyes"
	icon_state = "crystal-eyes"
	light_color = "#f7f792"
	light_system = MOVABLE_LIGHT
	light_power = 1
	light_range = 2

/obj/item/organ/internal/brain/crystal
	species_type = /datum/species/nucleation
	name = "crystallized brain"
	icon_state = "crystal-brain"

/obj/item/organ/internal/brain/crystal/insert(mob/living/target, special = ORGAN_MANIPULATION_DEFAULT)
	..(target, special)
	if(isnucleation(target))
		return //no need to apply disease to nucleation
	var/datum/disease/virus/nuclefication/D = new()
	D.Contract(target, need_protection_check = FALSE)




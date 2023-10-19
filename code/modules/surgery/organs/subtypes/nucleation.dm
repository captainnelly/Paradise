//NUCLEATION ORGAN
/obj/item/organ/internal/nucleation
	species_type = /datum/species/nucleation
	name = "nucleation organ"
	icon = 'icons/obj/surgery.dmi'
	desc = "A crystalized human organ. <span class='danger'>It has a strangely iridescent glow.</span>"

/obj/item/organ/internal/nucleation/resonant_crystal
	species_type = /datum/species/nucleation
	name = "resonant crystal"
	icon_state = "resonant-crystal"
	organ_tag = "resonant crystal"
	parent_organ = "head"
	slot = "res_crystal"

/obj/item/organ/internal/nucleation/strange_crystal
	species_type = /datum/species/nucleation
	name = "strange crystal"
	icon_state = "strange-crystal"
	organ_tag = "strange crystal"
	parent_organ = "chest"
	slot = "heart"

/obj/item/organ/internal/eyes/luminescent_crystal
	species_type = /datum/species/nucleation
	name = "luminescent eyes"
	icon_state = "crystal-eyes"
	organ_tag = "luminescent eyes"
	light_color = "#1C1C00"

/obj/item/organ/internal/eyes/luminescent_crystal/New()
	set_light(2)
	..()

/obj/item/organ/internal/brain/crystal
	species_type = /datum/species/nucleation
	name = "crystallized brain"
	icon_state = "crystal-brain"
	organ_tag = "crystallized brain"

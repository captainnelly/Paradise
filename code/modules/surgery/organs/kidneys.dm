/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	parent_organ_zone = BODY_ZONE_PRECISE_GROIN
	slot = INTERNAL_ORGAN_KIDNEYS

/obj/item/organ/internal/kidneys/on_life()
	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	if(!owner.reagents)
		return
	var/datum/reagent/coffee = locate(/datum/reagent/consumable/drink/coffee) in owner.reagents.reagent_list
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
		else if(is_traumatized())
			owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

/obj/item/organ/internal/kidneys/cybernetic
	name = "cybernetic kidneys"
	icon_state = "kidneys-c"
	desc = "An electronic device designed to mimic the functions of human kidneys. It has no benefits over a pair of organic kidneys, but is easy to produce."
	origin_tech = "biotech=4"
	status = ORGAN_ROBOT
	pickup_sound = 'sound/items/handling/component_pickup.ogg'
	drop_sound = 'sound/items/handling/component_drop.ogg'

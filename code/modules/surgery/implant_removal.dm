//////////////////////////////////////////////////////////////////
//					IMPLANT REMOVAL SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery/implant_removal
	name = "Implant Removal"
	steps = list(/datum/surgery_step/generic/cut_open, /datum/surgery_step/generic/clamp_bleeders, /datum/surgery_step/generic/retract_skin,/datum/surgery_step/extract_implant,/datum/surgery_step/generic/cauterize)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery/implant_removal/insect
	name = "Insectoid Implant Removal"
	steps = list(/datum/surgery_step/open_encased/saw, /datum/surgery_step/generic/retract_skin, /datum/surgery_step/generic/cut_open, /datum/surgery_step/generic/retract_skin,
	/datum/surgery_step/generic/clamp_bleeders, /datum/surgery_step/extract_implant, /datum/surgery_step/glue_bone, /datum/surgery_step/set_bone,/datum/surgery_step/finish_bone,/datum/surgery_step/generic/cauterize)

/datum/surgery/implant_removal/synth
	name = "Implant Removal"
	steps = list(/datum/surgery_step/robotics/external/unscrew_hatch,/datum/surgery_step/robotics/external/open_hatch,/datum/surgery_step/extract_implant/synth,/datum/surgery_step/robotics/external/close_hatch)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_organic_bodypart = 0

/datum/surgery/implant_removal/can_start(mob/user, mob/living/carbon/human/target)
	var/mob/living/carbon/human/H = target
	if(iskidan(H) || iswryn(H))
		return FALSE
	if(!istype(target))
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(!affected)
		return FALSE
	if(affected.is_robotic())
		return FALSE
	return TRUE

/datum/surgery/implant_removal/insect/can_start(mob/user, mob/living/carbon/human/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affected = H.get_organ(user.zone_selected)
		if(!affected)
			return FALSE
		if(affected.is_robotic())
			return FALSE
		if(!affected.encased)
			return FALSE
		if(iswryn(H) || iskidan(H))
			return TRUE
	return FALSE

/datum/surgery/implant_removal/synth/can_start(mob/user, mob/living/carbon/human/target)
	if(!istype(target))
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(!affected)
		return FALSE
	if(!affected.is_robotic())
		return FALSE

	return TRUE

/datum/surgery_step/extract_implant
	name = "extract implant"
	allowed_tools = list(/obj/item/hemostat = 100, /obj/item/crowbar = 65)
	time = 64
	var/obj/item/implant/I = null

/datum/surgery_step/extract_implant/synth
	allowed_tools = list(/obj/item/multitool = 100, /obj/item/hemostat = 65, /obj/item/crowbar = 50)

/datum/surgery_step/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'> [user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'> Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</span>")
	affected.receive_damage(20)

/datum/surgery_step/extract_implant/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	I = locate(/obj/item/implant) in target
	user.visible_message("[user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
	"You start poking around inside [target]'s [affected.name] with \the [tool]." )
	target.custom_pain("The pain in your [affected.name] is living hell!")
	..()

/datum/surgery_step/extract_implant/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	I = locate(/obj/item/implant) in target
	if(I && (target_zone == BODY_ZONE_CHEST)) //implant removal only works on the chest.
		user.visible_message("<span class='notice'>[user] takes something out of [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You take [I] out of [target]'s [affected.name]s with \the [tool].</span>" )

		I.removed(target)

		var/obj/item/implantcase/case

		if(istype(user.get_item_by_slot(slot_l_hand), /obj/item/implantcase))
			case = user.get_item_by_slot(slot_l_hand)
		else if(istype(user.get_item_by_slot(slot_r_hand), /obj/item/implantcase))
			case = user.get_item_by_slot(slot_r_hand)
		else
			case = locate(/obj/item/implantcase) in get_turf(target)

		if(case && !case.imp)
			case.imp = I
			I.forceMove(case)
			case.update_icon()
			user.visible_message("[user] places [I] into [case]!", "<span class='notice'>You place [I] into [case].</span>")
		else
			qdel(I)
	else
		user.visible_message("<span class='notice'> [user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out.</span>", \
		"<span class='notice'>You could not find anything inside [target]'s [affected.name].</span>")
	return TRUE

//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////
///Surgery Datums
/datum/surgery/bone_repair
	name = "Bone Repair"
	steps = list(/datum/surgery_step/generic/cut_open, /datum/surgery_step/generic/clamp_bleeders, /datum/surgery_step/generic/retract_skin, /datum/surgery_step/glue_bone, /datum/surgery_step/set_bone, /datum/surgery_step/finish_bone, /datum/surgery_step/generic/cauterize)
	possible_locs = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_TAIL,
		BODY_ZONE_WING,
	)

/datum/surgery/bone_repair/plasmaman
	name = "Plasmaman Bone Repair"
	steps = list(/datum/surgery_step/generic/cut_open, /datum/surgery_step/generic/clamp_bleeders, /datum/surgery_step/generic/retract_skin, /datum/surgery_step/glue_bone/plasma, /datum/surgery_step/generic/cauterize)
	possible_locs = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_TAIL,
		BODY_ZONE_WING,
	)

/datum/surgery/bone_repair/skull
	name = "Skull Repair"
	steps = list(/datum/surgery_step/generic/cut_open, /datum/surgery_step/generic/clamp_bleeders, /datum/surgery_step/generic/retract_skin, /datum/surgery_step/glue_bone, /datum/surgery_step/mend_skull, /datum/surgery_step/finish_bone, /datum/surgery_step/generic/cauterize)
	possible_locs = list(BODY_ZONE_HEAD)

/datum/surgery/bone_repair/plasmaman/skull
	name = "Plasmaman Skull Repair"
	steps = list(/datum/surgery_step/generic/cut_open, /datum/surgery_step/generic/clamp_bleeders, /datum/surgery_step/generic/retract_skin, /datum/surgery_step/glue_bone/plasma, /datum/surgery_step/generic/cauterize)
	possible_locs = list(BODY_ZONE_HEAD)

/datum/surgery/bone_repair/can_start(mob/user, mob/living/carbon/target)
	if(istype(target,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affected = H.get_organ(user.zone_selected)
		if(isplasmaman(H))
			return 0
		if(!affected)
			return 0
		if(affected.is_robotic())
			return 0
		if(affected.cannot_break)
			return 0
		if(affected.has_fracture())
			return 1
		return 1

/datum/surgery/bone_repair/plasmaman/can_start(mob/user, mob/living/carbon/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affected = H.get_organ(user.zone_selected)
		if(!isplasmaman(H))
			return 0
		if(!affected)
			return 0
		if(affected.is_robotic())
			return 0
		if(affected.cannot_break)
			return 0
		if(affected.has_fracture())
			return 1
		if(isplasmaman(H))
			return 1
	return 0


//surgery steps
/datum/surgery_step/glue_bone
	name = "mend bone"

	allowed_tools = list(
	/obj/item/bonegel = 100,	\
	/obj/item/screwdriver = 90
	)
	can_infect = 1
	blood_level = 1

	time = 24

/datum/surgery_step/glue_bone/plasma
	name = "mend bone"

	allowed_tools = list(
	/obj/item/stack/sheet/mineral/plasma = 100
	)
	can_infect = 1
	blood_level = 1

	time = 10

/datum/surgery_step/glue_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.is_robotic() && !(affected.cannot_break)

/datum/surgery_step/glue_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts applying medication to the damaged bones in [target]'s [affected.name] with \the [tool]." , \
	"You start applying medication to the damaged bones in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!")
	..()

/datum/surgery_step/glue_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'> [user] applies some [tool] to [target]'s bone in [affected.name]</span>", \
			"<span class='notice'> You apply some [tool] to [target]'s bone in [affected.name] with \the [tool].</span>")

		return 1

/datum/surgery_step/glue_bone/plasma/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'> [user] applies some [tool] to [target]'s bone in [affected.name]. You see the plasma flowing through the bones, reattaching them!</span>", \
			"<span class='notice'> You apply some [tool] to [target]'s bone in [affected.name] with \the [tool]. You see the plasma flowing through the bones, reattaching them!</span>")
		affected.mend_fracture()
		return 1

/datum/surgery_step/glue_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'> [user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
		"<span class='warning'> Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
		return 0

/datum/surgery_step/set_bone
	name = "set bone"

	allowed_tools = list(
	/obj/item/bonesetter = 100,	\
	/obj/item/wrench = 90	\
	)

	time = 32

/datum/surgery_step/set_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !affected.is_robotic()

/datum/surgery_step/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to set the bone in [target]'s [affected.name] in place with \the [tool]." , \
		"You are beginning to set the bone in [target]'s [affected.name] in place with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!")
	..()

/datum/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.has_fracture())
		user.visible_message("<span class='notice'> [user] sets the bone in [target]'s [affected.name] in place with \the [tool].</span>", \
			"<span class='notice'> You set the bone in [target]'s [affected.name] in place with \the [tool].</span>")
		return 1
	else
		user.visible_message("<span class='notice'> [user] sets the bone in [target]'s [affected.name] in place with \the [tool].</span>", \
			"<span class='notice'> You set the bone in [target]'s [affected.name] in place with \the [tool].</span>")
		return 1

/datum/surgery_step/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'> [user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</span>" , \
		"<span class='warning'> Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</span>")
	affected.receive_damage(5)
	return 0

/datum/surgery_step/mend_skull
	name = "mend skull"

	allowed_tools = list(
	/obj/item/bonesetter = 100,	\
	/obj/item/wrench = 90		\
	)

	time = 32

/datum/surgery_step/mend_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !affected.is_robotic() && affected.limb_zone == BODY_ZONE_HEAD

/datum/surgery_step/mend_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning piece together [target]'s skull with \the [tool]."  , \
		"You are beginning piece together [target]'s skull with \the [tool].")
	..()

/datum/surgery_step/mend_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'> [user] sets [target]'s [affected.encased] with \the [tool].</span>" , \
		"<span class='notice'> You set [target]'s [affected.encased] with \the [tool].</span>")

	return 1

/datum/surgery_step/mend_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s face with \the [tool]!</span>"  , \
		"<span class='warning'>Your hand slips, damaging [target]'s face with \the [tool]!</span>")
	var/obj/item/organ/external/head/h = affected
	h.receive_damage(10)
	h.disfigure()
	return 0

/datum/surgery_step/finish_bone
	name = "medicate bones"

	allowed_tools = list(
	/obj/item/bonegel = 100,	\
	/obj/item/screwdriver = 90
	)
	can_infect = 1
	blood_level = 1

	time = 24

/datum/surgery_step/finish_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !affected.is_robotic()

/datum/surgery_step/finish_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].", \
	"You start to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool,datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'> [user] has mended the damaged bones in [target]'s [affected.name] with \the [tool].</span>"  , \
		"<span class='notice'> You have mended the damaged bones in [target]'s [affected.name] with \the [tool].</span>" )
	affected.mend_fracture()
	return TRUE

/datum/surgery_step/finish_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'> [user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='warning'> Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
	return 0

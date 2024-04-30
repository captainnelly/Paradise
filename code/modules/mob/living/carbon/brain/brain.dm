/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	use_me = FALSE //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"


/mob/living/carbon/brain/New()
	..()
	add_language(LANGUAGE_GALACTIC_COMMON)


/mob/living/carbon/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat != DEAD)	//If not dead.
			death(gibbed = TRUE)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	return ..()


/mob/living/carbon/brain/update_canmove(delay_action_updates = FALSE)
	if(in_contents_of(/obj/mecha))
		canmove = TRUE
		use_me = TRUE //If it can move, let it emote
	else if(istype(loc, /obj/item/mmi))
		canmove = TRUE //mmi won't move anyways so whatever
	else
		canmove = FALSE

	if(!delay_action_updates)
		update_action_buttons_icon()
	return canmove


/mob/living/carbon/brain/ex_act() //you cant blow up brainmobs because it makes transfer_to() freak out when borgs blow up.
	return


/mob/living/carbon/brain/blob_act(obj/structure/blob/B)
	return


/mob/living/carbon/brain/incapacitated(ignore_restraints = FALSE, ignore_grab = FALSE, ignore_lying = FALSE)
	return FALSE


/mob/living/carbon/brain/on_forcemove(atom/newloc)
	if(container)
		container.forceMove(newloc)
	else //something went very wrong.
		CRASH("Brainmob without container.")
	forceMove(container)

/*
This will return true if the brain has a container that leaves it less helpless than a naked brain

I'm using this for Stat to give it a more nifty interface to work with
*/
/mob/living/carbon/brain/proc/has_synthetic_assistance()
	return (container && istype(container, /obj/item/mmi)) || in_contents_of(/obj/mecha)


/mob/living/carbon/brain/proc/get_race()
	if(container)
		var/obj/item/mmi/M = container
		if(istype(M) && M.held_brain)
			return M.held_brain.dna.species.name
		else
			return "Artificial Life"
	if(istype(loc, /obj/item/organ/internal/brain))
		var/obj/item/organ/internal/brain/B = loc
		return B.dna.species.name


/mob/living/carbon/brain/Stat()
	..()
	if(has_synthetic_assistance())
		statpanel("Status")
		show_stat_emergency_shuttle_eta()

		if(client.statpanel == "Status")
			//Knowing how well-off your mech is doing is really important as an MMI
			if(ismecha(src.loc))
				var/obj/mecha/M = src.loc
				stat("Exosuit Charge:", "[istype(M.cell) ? "[M.cell.charge] / [M.cell.maxcharge]" : "No cell detected"]")
				stat("Exosuit Integrity", "[!M.obj_integrity ? "0" : "[(M.obj_integrity / M.max_integrity) * 100]"]%")


/mob/living/carbon/brain/can_safely_leave_loc()
	return FALSE //You're not supposed to be ethereal jaunting, brains


/mob/living/carbon/brain/can_hear()
	return TRUE


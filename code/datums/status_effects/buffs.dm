//Largely beneficial effects go here, even if they have drawbacks. An example is provided in Shadow Mend.

/datum/status_effect/shadow_mend
	id = "shadow_mend"
	duration = 30
	alert_type = /obj/screen/alert/status_effect/shadow_mend

/obj/screen/alert/status_effect/shadow_mend
	name = "Shadow Mend"
	desc = "Shadowy energies wrap around your wounds, sealing them at a price. After healing, you will slowly lose health every three seconds for thirty seconds."
	icon_state = "shadow_mend"

/datum/status_effect/shadow_mend/on_apply()
	owner.visible_message("<span class='notice'>Violet light wraps around [owner]'s body!</span>", "<span class='notice'>Violet light wraps around your body!</span>")
	playsound(owner, 'sound/magic/teleport_app.ogg', 50, 1)
	return ..()

/datum/status_effect/shadow_mend/tick()
	owner.adjustBruteLoss(-15)
	owner.adjustFireLoss(-15)

/datum/status_effect/shadow_mend/on_remove()
	owner.visible_message("<span class='warning'>The violet light around [owner] glows black!</span>", "<span class='warning'>The tendrils around you cinch tightly and reap their toll...</span>")
	playsound(owner, 'sound/magic/teleport_diss.ogg', 50, 1)
	owner.apply_status_effect(STATUS_EFFECT_VOID_PRICE)


/datum/status_effect/void_price
	id = "void_price"
	duration = 300
	tick_interval = 30
	alert_type = /obj/screen/alert/status_effect/void_price

/obj/screen/alert/status_effect/void_price
	name = "Void Price"
	desc = "Black tendrils cinch tightly against you, digging wicked barbs into your flesh."
	icon_state = "shadow_mend"

/datum/status_effect/void_price/tick()
	playsound(owner, 'sound/weapons/bite.ogg', 50, 1)
	owner.adjustBruteLoss(3)

/datum/status_effect/blooddrunk
	id = "blooddrunk"
	duration = 10
	tick_interval = 0
	alert_type = /obj/screen/alert/status_effect/blooddrunk

/obj/screen/alert/status_effect/blooddrunk
	name = "Blood-Drunk"
	desc = "You are drunk on blood! Your pulse thunders in your ears! Nothing can harm you!" //not true, and the item description mentions its actual effect
	icon_state = "blooddrunk"

/datum/status_effect/blooddrunk/on_apply()
	. = ..()
	if(.)
		if(ishuman(owner))
			owner.status_flags |= IGNORESLOWDOWN
			var/mob/living/carbon/human/H = owner
			for(var/X in H.bodyparts)
				var/obj/item/organ/external/BP = X
				BP.brute_mod *= 0.1
				BP.burn_mod *= 0.1
			H.dna.species.tox_mod *= 0.1
			H.dna.species.oxy_mod *= 0.1
			H.dna.species.clone_mod *= 0.1
			H.dna.species.stamina_mod *= 0.1
		add_attack_logs(owner, owner, "gained blood-drunk stun immunity", ATKLOG_ALL)
		owner.add_stun_absorption("blooddrunk", INFINITY, 4)
		owner.playsound_local(get_turf(owner), 'sound/effects/singlebeat.ogg', 40, TRUE, use_reverb = FALSE)

/datum/status_effect/blooddrunk/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		for(var/X in H.bodyparts)
			var/obj/item/organ/external/BP = X
			BP.brute_mod *= 10
			BP.burn_mod *= 10
		H.dna.species.tox_mod *= 10
		H.dna.species.oxy_mod *= 10
		H.dna.species.clone_mod *= 10
		H.dna.species.stamina_mod *= 10
	add_attack_logs(owner, owner, "lost blood-drunk stun immunity", ATKLOG_ALL)
	owner.status_flags &= ~IGNORESLOWDOWN
	if(islist(owner.stun_absorption) && owner.stun_absorption["blooddrunk"])
		owner.stun_absorption -= "blooddrunk"

/datum/status_effect/exercised
	id = "Exercised"
	duration = 1200
	alert_type = null

/datum/status_effect/exercised/on_creation(mob/living/new_owner, ...)
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)
	START_PROCESSING(SSprocessing, src) //this lasts 20 minutes, so SSfastprocess isn't needed.

/datum/status_effect/exercised/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

//Hippocratic Oath: Applied when the Rod of Asclepius is activated.
/datum/status_effect/hippocraticOath
	id = "Hippocratic Oath"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 25
	examine_text = "<span class='notice'>They seem to have an aura of healing and helpfulness about them.</span>"
	alert_type = null

	var/datum/component/aura_healing/aura_healing
	var/hand
	var/deathTick = 0

/datum/status_effect/hippocraticOath/on_apply()
	var/static/list/organ_healing = list(
		"brain" = 1.4,
	)

	aura_healing = owner.AddComponent( \
		/datum/component/aura_healing, \
		range = 7, \
		brute_heal = 1.4, \
		burn_heal = 1.4, \
		toxin_heal = 1.4, \
		suffocation_heal = 1.4, \
		stamina_heal = 1.4, \
		clone_heal = 0.4, \
		simple_heal = 1.4, \
		organ_healing = organ_healing, \
		healing_color = "#375637", \
	)

	//Makes the user passive, it's in their oath not to harm!
	ADD_TRAIT(owner, TRAIT_PACIFISM, "hippocraticOath")
	var/datum/atom_hud/H = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	H.add_hud_to(owner)
	return ..()

/datum/status_effect/hippocraticOath/on_remove()
	QDEL_NULL(aura_healing)
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "hippocraticOath")
	var/datum/atom_hud/H = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	H.remove_hud_from(owner)

/datum/status_effect/hippocraticOath/tick()
	if(owner.stat == DEAD)
		if(deathTick < 4)
			deathTick += 1
		else
			owner.visible_message("<span class='notice'>[owner]'s soul is absorbed into the rod, relieving the previous snake of its duty.</span>")
			var/mob/living/simple_animal/hostile/retaliate/poison/snake/healSnake = new(owner.loc)
			var/list/chems = list("bicaridine", "perfluorodecalin", "kelotane")
			healSnake.poison_type = pick(chems)
			healSnake.name = "Asclepius's Snake"
			healSnake.real_name = "Asclepius's Snake"
			healSnake.desc = "A mystical snake previously trapped upon the Rod of Asclepius, now freed of its burden. Unlike the average snake, its bites contain chemicals with minor healing properties."
			new /obj/effect/decal/cleanable/ash(owner.loc)
			new /obj/item/rod_of_asclepius(owner.loc)
			qdel(owner)
	else
		if(ishuman(owner))
			var/mob/living/carbon/human/itemUser = owner
			var/obj/item/heldItem = (hand ==  1 ? itemUser.l_hand : itemUser.r_hand)
			if(!heldItem || !istype(heldItem, /obj/item/rod_of_asclepius)) //Checks to make sure the rod is still in their hand
				var/obj/item/rod_of_asclepius/newRod = new(itemUser.loc)
				newRod.activated()
				if(hand)
					itemUser.drop_l_hand(TRUE)
					if(itemUser.put_in_l_hand(newRod, TRUE))
						to_chat(itemUser, "<span class='notice'>The Rod of Asclepius suddenly grows back out of your arm!</span>")
					else
						if(!itemUser.has_organ("l_arm"))
							new /obj/item/organ/external/arm(itemUser)
						new /obj/item/organ/external/hand(itemUser)
						itemUser.update_body()
						itemUser.put_in_l_hand(newRod, TRUE)
						to_chat(itemUser, "<span class='notice'>Your arm suddenly grows back with the Rod of Asclepius still attached!</span>")
				else
					itemUser.drop_r_hand(TRUE)
					if(itemUser.put_in_r_hand(newRod, TRUE))
						to_chat(itemUser, "<span class='notice'>The Rod of Asclepius suddenly grows back out of your arm!</span>")
					else
						if(!itemUser.has_organ("r_arm"))
							new /obj/item/organ/external/arm/right(itemUser)
						new /obj/item/organ/external/hand/right(itemUser)
						itemUser.update_body()
						itemUser.put_in_r_hand(newRod, TRUE)
						to_chat(itemUser, "<span class='notice'>Your arm suddenly grows back with the Rod of Asclepius still attached!</span>")

			//Because a servant of medicines stops at nothing to help others, lets keep them on their toes and give them an additional boost.
			if(itemUser.health < itemUser.maxHealth)
				new /obj/effect/temp_visual/heal(get_turf(itemUser), "#375637")
			itemUser.adjustBruteLoss(-1.5)
			itemUser.adjustFireLoss(-1.5)
			itemUser.adjustToxLoss(-1.5)
			itemUser.adjustOxyLoss(-1.5)
			itemUser.adjustStaminaLoss(-1.5)
			itemUser.adjustBrainLoss(-1.5)
			itemUser.adjustCloneLoss(-0.5) //Becasue apparently clone damage is the bastion of all health

/obj/screen/alert/status_effect/regenerative_core
	name = "Reinforcing Tendrils"
	desc = "You can move faster than your broken body could normally handle!"
	icon_state = "regenerative_core"
	name = "Regenerative Core Tendrils"

/datum/status_effect/regenerative_core
	id = "Regenerative Core"
	duration = 1 MINUTES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /obj/screen/alert/status_effect/regenerative_core

/datum/status_effect/regenerative_core/on_apply()
	owner.status_flags |= IGNORE_SPEED_CHANGES
	owner.adjustBruteLoss(-25)
	owner.adjustFireLoss(-25)
	owner.remove_CC()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.bodytemperature = H.dna.species.body_temperature
		if(is_mining_level(H.z))
			for(var/thing in H.bodyparts)
				var/obj/item/organ/external/E = thing
				E.internal_bleeding = FALSE
				E.mend_fracture()
		else
			to_chat(owner, "<span class='warning'>...But the core was weakened, it is not close enough to the rest of the legions of the necropolis.</span>")
	else
		owner.bodytemperature = BODYTEMP_NORMAL
	return TRUE

/datum/status_effect/regenerative_core/on_remove()
	owner.status_flags &= ~IGNORE_SPEED_CHANGES

/datum/status_effect/terror/regeneration
	id = "terror_regen"
	duration = 250
	alert_type = null

/datum/status_effect/terror/regeneration/tick()
	owner.adjustBruteLoss(-6)

/datum/status_effect/terror/food_regen
	id = "terror_food_regen"
	duration = 250
	alert_type = null


/datum/status_effect/terror/food_regen/tick()
	owner.adjustBruteLoss(-(owner.maxHealth/20))


/datum/status_effect/hope
	id = "hope"
	duration = -1
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /obj/screen/alert/status_effect/hope

/obj/screen/alert/status_effect/hope
	name = "Hope."
	desc = "A ray of hope beyond dispair."
	icon_state = "hope"

/datum/status_effect/hope/tick()
	if(owner.stat == DEAD || owner.health <= HEALTH_THRESHOLD_DEAD) // No dead healing, or healing in dead crit
		return
	if(owner.health > 50)
		if(prob(0.5))
			hope_message()
		return
	var/heal_multiplier = min(3, ((50 - owner.health) / 50 + 1)) // 1 hp at 50 health, 2 at 0, 3 at -50
	owner.adjustBruteLoss(-heal_multiplier * 0.5)
	owner.adjustFireLoss(-heal_multiplier * 0.5)
	owner.adjustOxyLoss(-heal_multiplier)
	if(prob(heal_multiplier * 2))
		hope_message()

/datum/status_effect/hope/proc/hope_message()
	var/list/hope_messages = list("You are filled with [pick("hope", "determination", "strength", "peace", "confidence", "robustness")].",
							"Don't give up!",
							"You see your [pick("friends", "family", "coworkers", "self")] [pick("rooting for you", "cheering you on", "worrying about you")].",
							"You can't give up now, keep going!",
							"But you refused to die!",
							"You have been through worse, you can do this!",
							"People need you, do not [pick("give up", "stop", "rest", "pass away", "falter", "lose hope")] yet!",
							"This person is not nearly as robust as you!",
							"You ARE robust, don't let anyone tell you otherwise!",
							"[owner], don't lose hope, the future of the station depends on you!",
							"Do not follow the light yet!")
	var/list/un_hopeful_messages = list("DON'T FUCKING DIE NOW COWARD!",
							"Git Gud, [owner]",
							"I bet a [pick("vox", "vulp", "nian", "tajaran", "baldie")] could do better than you!",
							"You hear people making fun of you for getting robusted.")
	if(prob(99))
		to_chat(owner, "<span class='notice'>[pick(hope_messages)]</span>")
	else
		to_chat(owner, "<span class='cultitalic'>[pick(un_hopeful_messages)]</span>")

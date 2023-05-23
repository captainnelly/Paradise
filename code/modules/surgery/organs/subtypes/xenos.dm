/obj/item/organ/internal/xenos
	origin_tech = "biotech=5"
	icon_state = "xgibmid2"
	var/list/alien_powers = list()
	tough = TRUE
	sterile = TRUE

///can be changed if xenos get an update..
/obj/item/organ/internal/xenos/insert(mob/living/carbon/M, special = 0)
	..()
	for(var/P in alien_powers)
		M.verbs |= P

/obj/item/organ/internal/xenos/remove(mob/living/carbon/M, special = 0)
	for(var/P in alien_powers)
		M.verbs -= P
	. = ..()
/obj/item/organ/internal/xenos/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("sacid", 10)
	return S

//XENOMORPH ORGANS

/obj/item/organ/internal/xenos/plasmavessel
	name = "xeno plasma vessel"
	icon_state = "plasma"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = "biotech=5;plasmatech=4"
	parent_organ = "chest"
	slot = "plasmavessel"


	var/stored_plasma = 0
	var/max_plasma = 500
	var/heal_rate = 7.5
	var/plasma_rate = 10

/obj/item/organ/internal/xenos/plasmavessel/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("plasma", stored_plasma/10)
	return S

/obj/item/organ/internal/xenos/plasmavessel/queen
	name = "bloated xeno plasma vessel"
	icon_state = "plasma_large"
	origin_tech = "biotech=6;plasmatech=4"
	stored_plasma = 200
	max_plasma = 500
	plasma_rate = 25

/obj/item/organ/internal/xenos/plasmavessel/drone
	name = "large xeno plasma vessel"
	icon_state = "plasma_large"
	stored_plasma = 200
	max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/sentinel
	stored_plasma = 200
	max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/hunter
	name = "small xeno plasma vessel"
	icon_state = "plasma_tiny"
	stored_plasma = 100
	max_plasma = 150

/obj/item/organ/internal/xenos/plasmavessel/larva
	name = "tiny xeno plasma vessel"
	icon_state = "plasma_tiny"
	max_plasma = 100


/obj/item/organ/internal/xenos/plasmavessel/on_life()
	//passive regeneration amount
	var/heal_amount = 1

	if(locate(/obj/structure/alien/weeds) in owner.loc)
		if(owner.health >= owner.maxHealth)
			owner.adjustPlasma(plasma_rate)
		else
			heal_amount += isalien(owner) ? heal_rate : 0.2 * heal_rate
			owner.adjustPlasma(plasma_rate*0.5)

	owner.adjustBruteLoss(-heal_amount)
	owner.adjustFireLoss(-heal_amount)
	owner.adjustOxyLoss(-heal_amount)
	owner.adjustCloneLoss(-heal_amount)

/obj/item/organ/internal/xenos/plasmavessel/insert(mob/living/carbon/M, special = 0)
	..()
	if(isalien(M))
		var/mob/living/carbon/alien/A = M
		A.updatePlasmaDisplay()

/obj/item/organ/internal/alien/plasmavessel/remove(mob/living/carbon/M, special = 0)
	. =..()
	if(isalien(M))
		var/mob/living/carbon/alien/A = M
		A.updatePlasmaDisplay()


/obj/item/organ/internal/xenos/acidgland
	name = "xeno acid gland"
	icon_state = "acid"
	parent_organ = "head"
	slot = "acid"
	origin_tech = "biotech=5;materials=2;combat=2"
	var/datum/action/innate/xeno_action/corrosive_acid/corrosive_acid_action = new

/obj/item/organ/internal/xenos/acidgland/sentinel
	name = "medium xeno acid gland"
	corrosive_acid_action = new /datum/action/innate/xeno_action/corrosive_acid/sentinel

/obj/item/organ/internal/xenos/acidgland/praetorian
	name = "massive xeno acid gland"
	corrosive_acid_action = new /datum/action/innate/xeno_action/corrosive_acid/praetorian

/obj/item/organ/internal/xenos/acidgland/queen
	name = "royal xeno acid gland"
	corrosive_acid_action = new /datum/action/innate/xeno_action/corrosive_acid/queen

/obj/item/organ/internal/xenos/acidgland/insert(mob/living/carbon/M, special = 0)
	..()
	corrosive_acid_action.Grant(M)

/obj/item/organ/internal/xenos/acidgland/remove(mob/living/carbon/M, special = 0)
	corrosive_acid_action.Remove(M)
	. = ..()

/obj/item/organ/internal/xenos/hivenode
	name = "xeno hive node"
	icon_state = "hivenode"
	parent_organ = "head"
	slot = "hivenode"
	origin_tech = "biotech=5;magnets=4;bluespace=3"
	w_class = WEIGHT_CLASS_TINY

/obj/item/organ/internal/xenos/hivenode/insert(mob/living/carbon/M, special = 0)
	..()
	M.faction |= "alien"
	M.add_language("Hivemind")
	M.add_language("Xenomorph")

/obj/item/organ/internal/xenos/hivenode/remove(mob/living/carbon/M, special = 0)
	M.faction -= "alien"
	M.remove_language("Hivemind")
	M.remove_language("Xenomorph")
	. = ..()

/obj/item/organ/internal/xenos/neurotoxin
	name = "xeno neurotoxin gland"
	icon_state = "neurotox"
	parent_organ = "head"
	slot = "neurotox"
	origin_tech = "biotech=5;combat=5"
	var/obj/effect/proc_holder/spell/neurotoxin/neurotoxin_spell = new

/obj/item/organ/internal/xenos/neurotoxin/insert(mob/living/carbon/M, special = 0)
	..()
	neurotoxin_spell.action.Grant(M)


/obj/item/organ/internal/xenos/neurotoxin/remove(mob/living/carbon/M, special = 0)
	neurotoxin_spell.action.Remove(M)
	. = ..()

/obj/item/organ/internal/xenos/resinspinner
	name = "xeno resin organ"//...there tiger....
	parent_organ = "mouth"
	icon_state = "liver-x"
	slot = "spinner"
	origin_tech = "biotech=5;materials=4"
	var/datum/action/innate/xeno_action/resin/resin_action = new
	var/obj/effect/proc_holder/spell/xeno_plant/plant_spell = new

/obj/item/organ/internal/xenos/resinspinner/insert(mob/living/carbon/M, special = 0)
	..()
	resin_action.Grant(M)
	plant_spell.action.Grant(M)

/obj/item/organ/internal/xenos/resinspinner/remove(mob/living/carbon/M, special = 0)
	resin_action.Remove(M)
	plant_spell.action.Remove(M)
	. = ..()

/obj/item/organ/internal/xenos/resinspinner/queen
	name = "extensive xeno resin organ"
	plant_spell = new /obj/effect/proc_holder/spell/xeno_plant/queen

/obj/item/organ/internal/xenos/eggsac
	name = "xeno egg sac"
	icon_state = "eggsac"
	parent_organ = "groin"
	slot = "eggsac"
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = "biotech=6"
	var/datum/action/innate/xeno_action/lay_egg_queen/lay_egg_queen_action = new

/obj/item/organ/internal/xenos/eggsac/insert(mob/living/carbon/M, special = 0)
	..()
	lay_egg_queen_action.Grant(M)

/obj/item/organ/internal/xenos/eggsac/remove(mob/living/carbon/M, special = 0)
	lay_egg_queen_action.Remove(M)
	. = ..()

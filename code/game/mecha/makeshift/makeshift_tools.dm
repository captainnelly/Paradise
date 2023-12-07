/obj/item/mecha_parts/mecha_equipment/drill/makeshift
	name = "Makeshift exosuit drill"
	desc = "Cobbled together from likely stolen parts, this drill is nowhere near as effective as the real deal."
	equip_cooldown = 6 SECONDS //Its slow as shit
	force = 10 //Its not very strong
	drill_delay = 15

/obj/item/mecha_parts/mecha_equipment/drill/makeshift/can_attach(obj/mecha/M)
	if(istype(M, /obj/mecha/makeshift) || istype(M, /obj/mecha/combat/lockersyndie))
		if(M.equipment.len < M.max_equip)
			return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/makeshift
	name = "makeshift clamp"
	desc = "Loose arrangement of cobbled together bits resembling a clamp."
	equip_cooldown = 2.5 SECONDS
	dam_force = 10

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/makeshift/can_attach(obj/mecha/M)
	if(istype(M, /obj/mecha/makeshift) || istype(M, /obj/mecha/combat/lockersyndie))
		if(M.equipment.len < M.max_equip)
			return TRUE
	return FALSE

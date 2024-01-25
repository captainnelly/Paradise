GLOBAL_VAR_INIT(security_level, 0)
//0 = code green
//1 = code blue
//2 = code red
//3 = gamma
//4 = epsilon
//5 = code delta

//config.alert_desc_blue_downto
GLOBAL_DATUM_INIT(security_announcement_up, /datum/announcement/priority/security, new(do_log = 0, do_newscast = 0, new_sound = sound('sound/misc/notice1.ogg')))
GLOBAL_DATUM_INIT(security_announcement_down, /datum/announcement/priority/security, new(do_log = 0, do_newscast = 0))

/proc/set_security_level(var/level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_BLUE
		if("red")
			level = SEC_LEVEL_RED
		if("gamma")
			level = SEC_LEVEL_GAMMA
		if("epsilon")
			level = SEC_LEVEL_EPSILON
		if("delta")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != GLOB.security_level)
		if(level >= SEC_LEVEL_RED && GLOB.security_level < SEC_LEVEL_RED)
			// Mark down this time to prevent shuttle cheese
			SSshuttle.emergency_sec_level_time = world.time

		switch(level)
			if(SEC_LEVEL_GREEN)
				GLOB.security_announcement_down.Announce("Все угрозы для станции устранены. Все оружие должно быть в кобуре, и законы о конфиденциальности вновь полностью соблюдаются.","ВНИМАНИЕ! Уровень угрозы понижен до ЗЕЛЁНОГО.")
				GLOB.security_level = SEC_LEVEL_GREEN
				unset_stationwide_emergency_lighting()
				post_status("alert", "outline")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/machines/monitors.dmi', "overlay_green")
						FA.update_icon()

			if(SEC_LEVEL_BLUE)
				if(GLOB.security_level < SEC_LEVEL_BLUE)
					GLOB.security_announcement_up.Announce("На станции обнаружено присутствие враждебных элементов, представляющих незначительную угрозу экипажу и активам корпорации. Служба Безопасности может держать оружие на виду и использовать летальную силу в соответствии с рабочими процедурами отдела защиты активов.","ВНИМАНИЕ! Уровень угрозы повышен до СИНЕГО")
				else
					GLOB.security_announcement_down.Announce("Непосредственная угроза миновала. Служба безопасности может больше не держать оружие в полной боевой готовности, но может по-прежнему держать его на виду. Выборочные обыски запрещены.","ВНИМАНИЕ! Уровень угрозы понижен до СИНЕГО")
				GLOB.security_level = SEC_LEVEL_BLUE

				post_status("alert", "default")
				unset_stationwide_emergency_lighting()
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/machines/monitors.dmi', "overlay_blue")
						FA.update_icon()

			if(SEC_LEVEL_RED)
				if(GLOB.security_level < SEC_LEVEL_RED)
					GLOB.security_announcement_up.Announce("На борту станции подтверждена серьезная угроза для экипажа и активов корпорации. Службе Безопасности рекомендуется иметь оружие в полной боевой готовности. Выборочные обыски разрешены и рекомендуются.","ВНИМАНИЕ! КОД КРАСНЫЙ!")
				else
					GLOB.security_announcement_down.Announce("Угроза уничтожения станции миновала, но враждебная активность остается на высоком уровне. Службе Безопасности рекомендуется иметь оружие в полной боевой готовности. Выборочные обыски разрешены.","ВНИМАНИЕ! КОД КРАСНЫЙ!")
					unset_stationwide_emergency_lighting()
				GLOB.security_level = SEC_LEVEL_RED
				var/obj/machinery/door/airlock/highsecurity/red/R = locate(/obj/machinery/door/airlock/highsecurity/red) in GLOB.airlocks
				if(R && is_station_level(R.z))
					R.locked = 0
					R.update_icon()

				post_status("alert", "redalert")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/machines/monitors.dmi', "overlay_red")
						FA.update_icon()

			if(SEC_LEVEL_GAMMA)
				GLOB.security_announcement_up.Announce("Центральным Командованием был установлен Код Гамма. Станция находится под угрозой полного уничтожения. Службе безопасности следует получить полное вооружение и приготовиться к ведению боевых действий с враждебными элементами на борту станции. Гражданский персонал обязан немедленно обратиться к Главам отделов для получения дальнейших указаний.", "Внимание! Код ГАММА!", sound('sound/effects/new_siren.ogg'))
				GLOB.security_level = SEC_LEVEL_GAMMA

				if(GLOB.security_level < SEC_LEVEL_RED)
					for(var/obj/machinery/door/airlock/highsecurity/red/R in GLOB.airlocks)
						if(is_station_level(R.z))
							R.locked = 0
							R.update_icon()

				post_status("alert", "gammaalert")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/machines/monitors.dmi', "overlay_gamma")
						FA.update_icon()

			if(SEC_LEVEL_EPSILON)
				for(var/mob/M in GLOB.player_list)
					var/turf/T = get_turf(M)
					if(!M.client || !is_station_level(T.z))
						continue
					SEND_SOUND(M, sound('sound/effects/powerloss.ogg'))
				set_stationwide_emergency_lighting()
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(epsilon_process)), 15 SECONDS)
				SSblackbox.record_feedback("tally", "security_level_changes", 1, level)
				return

			if(SEC_LEVEL_DELTA)
				GLOB.security_announcement_up.Announce("Механизм самоуничтожения станции задействован. Все члены экипажа обязан подчиняться всем указаниям, данными Главами отделов. Любые нарушения этих приказов наказуемы уничтожением на месте. Это не учебная тревога.","ВНИМАНИЕ! КОД ДЕЛЬТА!", new_sound = sound('sound/effects/deltaalarm.ogg'))
				GLOB.security_level = SEC_LEVEL_DELTA

				post_status("alert", "deltaalert")

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_contact(FA.z))
						FA.overlays.Cut()
						FA.overlays += image('icons/obj/machines/monitors.dmi', "overlay_delta")
						FA.update_icon()
				set_stationwide_emergency_lighting()
				SSblackbox.record_feedback("tally", "security_level_changes", 1, level)
				return

		SSnightshift.check_nightshift(TRUE)
		SSblackbox.record_feedback("tally", "security_level_changes", 1, level)

		if(GLOB.sibsys_automode && !isnull(GLOB.sybsis_registry))
			for(var/obj/item/sibyl_system_mod/mod in GLOB.sybsis_registry)
				mod.sync_limit()
	else
		return

/proc/get_security_level()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_GAMMA)
			return "gamma"
		if(SEC_LEVEL_EPSILON)
			return "epsilon"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_GAMMA)
			return "gamma"
		if(SEC_LEVEL_EPSILON)
			return "epsilon"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("gamma")
			return SEC_LEVEL_GAMMA
		if("epsilon")
			return SEC_LEVEL_EPSILON
		if("delta")
			return SEC_LEVEL_DELTA

/proc/get_security_level_ru()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "ЗЕЛЕНЫЙ"
		if(SEC_LEVEL_BLUE)
			return "СИНИЙ"
		if(SEC_LEVEL_RED)
			return "КРАСНЫЙ"
		if(SEC_LEVEL_GAMMA)
			return "ГАММА"
		if(SEC_LEVEL_EPSILON)
			return "ЭПСИЛОН"
		if(SEC_LEVEL_DELTA)
			return "ДЕЛЬТА"


/proc/get_security_level_ru_colors()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "<font color='limegreen'>Зелёный</font>"
		if(SEC_LEVEL_BLUE)
			return "<font color='dodgerblue'>Синий</font>"
		if(SEC_LEVEL_RED)
			return "<font color='red'>Красный</font>"
		if(SEC_LEVEL_GAMMA)
			return "<font color='gold'>Гамма</font>"
		if(SEC_LEVEL_EPSILON)
			return "<font color='blueviolet'>Эпсилон</font>"
		if(SEC_LEVEL_DELTA)
			return "<font color='orangered'>Дельта</font>"

/proc/get_security_level_l_range()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return 1
		if(SEC_LEVEL_BLUE)
			return 2
		if(SEC_LEVEL_RED)
			return 2
		if(SEC_LEVEL_GAMMA)
			return 2
		if(SEC_LEVEL_EPSILON)
			return 2
		if(SEC_LEVEL_DELTA)
			return 2

/proc/get_security_level_l_power()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return 1
		if(SEC_LEVEL_BLUE)
			return 2
		if(SEC_LEVEL_RED)
			return 2
		if(SEC_LEVEL_GAMMA)
			return 2
		if(SEC_LEVEL_EPSILON)
			return 2
		if(SEC_LEVEL_DELTA)
			return 2

/proc/get_security_level_l_color()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return COLOR_GREEN
		if(SEC_LEVEL_BLUE)
			return COLOR_ALARM_BLUE
		if(SEC_LEVEL_RED)
			return COLOR_RED_LIGHT
		if(SEC_LEVEL_GAMMA)
			return COLOR_AMBER
		if(SEC_LEVEL_EPSILON)
			return COLOR_WHITE
		if(SEC_LEVEL_DELTA)
			return COLOR_PURPLE

/proc/set_stationwide_emergency_lighting()
	for(var/obj/machinery/power/apc/A in GLOB.apcs)
		var/area/AR = get_area(A)
		if(!is_station_level(A.z))
			continue
		A.emergency_lights = FALSE
		AR.area_emergency_mode = TRUE
		for(var/obj/machinery/light/L in A.area)
			if(L.status)
				continue
			if(GLOB.security_level == SEC_LEVEL_DELTA)
				L.fire_mode = TRUE
			L.on = FALSE
			L.emergency_mode = TRUE
			INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)

/proc/unset_stationwide_emergency_lighting()
	for(var/area/A as anything in GLOB.all_areas)
		if(!is_station_level(A.z))
			continue
		if(!A.area_emergency_mode)
			continue
		A.area_emergency_mode = FALSE
		for(var/obj/machinery/light/L in A)
			if(A.fire)
				continue
			if(L.status)
				continue
			L.fire_mode = FALSE
			L.emergency_mode = FALSE
			L.on = TRUE
			INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)


/proc/epsilon_process()
	GLOB.security_announcement_up.Announce("Центральным командованием был установлен код ЭПСИЛОН. Все контракты расторгнуты.","ВНИМАНИЕ! КОД ЭПСИЛОН", new_sound = sound('sound/effects/epsilon.ogg'))
	GLOB.security_level = SEC_LEVEL_EPSILON
	post_status("alert", "epsilonalert")
	for(var/area/A as anything in GLOB.all_areas)
		if(!is_station_level(A.z))
			continue
		for(var/obj/machinery/light/L in A)
			if(L.status)
				continue
			L.fire_mode = TRUE
			L.update()
	for(var/obj/machinery/firealarm/FA in GLOB.machines)
		if(is_station_contact(FA.z))
			FA.overlays.Cut()
			FA.overlays += image('icons/obj/machines/monitors.dmi', "overlay_epsilon")
			FA.update_icon()
	GLOB.PDA_Manifest = list(\
					"heads" = list(),\
					"pro" = list(),\
					"sec" = list(),\
					"eng" = list(),\
					"med" = list(),\
					"sci" = list(),\
					"ser" = list(),\
					"sup" = list(),\
					"bot" = list(),\
					"misc" = list()\
					)

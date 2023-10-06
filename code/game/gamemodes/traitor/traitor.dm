/datum/game_mode
	/// A list of all minds which have the traitor antag datum.
	var/list/datum/mind/traitors = list()
	/// An associative list with mindslave minds as keys and their master's minds as values.
	var/list/datum/mind/implanted = list()
	/// The Contractor Support Units
	var/list/datum/mind/support = list()

	var/datum/mind/exchange_red
	var/datum/mind/exchange_blue

/datum/game_mode/traitor
	name = "traitor"
	config_tag = "traitor"
	restricted_jobs = list("Cyborg")//They are part of the AI if he is traitor so are they, they use to get double chances
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Blueshield", "Nanotrasen Representative", "Security Pod Pilot", "Magistrate", "Internal Affairs Agent", "Brig Physician", "Nanotrasen Navy Officer", "Nanotrasen Navy Field Officer", "Special Operations Officer", "Supreme Commander", "Syndicate Officer")
	required_players = 0
	required_enemies = 1
	recommended_enemies = 4
	/// A list containing references to the minds of soon-to-be traitors. This is seperate to avoid duplicate entries in the `traitors` list.
	var/list/datum/mind/pre_traitors = list()
	/// Hard limit on traitors if scaling is turned off.
	var/traitors_possible = 4
	// Contractor related
	/// Minimum number of possible contractors regardless of the number of traitors.
	var/min_contractors = 1
	/// How many contractors there are in proportion to traitors.
	/// Calculated as: num_contractors = max(min_contractors, CEILING(num_traitors * contractor_traitor_ratio, 1))
	var/contractor_traitor_ratio = 0.25
	/// List of traitors who are eligible to become a contractor.
	var/list/datum/mind/selected_contractors = list()


/datum/game_mode/traitor/announce()
	to_chat(world, "<B>The current game mode is - Traitor!</B>")
	to_chat(world, "<B>There is a syndicate traitor on the station. Do not let the traitor succeed!</B>")


/datum/game_mode/traitor/pre_setup()

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	var/list/possible_traitors = get_players_for_role(ROLE_TRAITOR)

	// stop setup if no possible traitors
	if(!length(possible_traitors))
		return FALSE

	var/num_traitors = 1
	var/num_players = num_players()

	if(CONFIG_GET(number/traitor_scaling))
		num_traitors = max(1, round(num_players / CONFIG_GET(number/traitor_scaling)) + 1)
	else
		num_traitors = max(1, min(num_players, traitors_possible))

	add_game_logs("Number of traitors chosen: [num_traitors]")

	var/num_contractors = max(min_contractors, CEILING(num_traitors * contractor_traitor_ratio, 1))

	for(var/j = 0, j < num_traitors, j++)
		if(!length(possible_traitors))
			break
		var/datum/mind/traitor = pick(possible_traitors)
		possible_traitors.Remove(traitor)
		if(traitor.special_role == SPECIAL_ROLE_THIEF) //Disable traitor + thief combination
			continue
		pre_traitors += traitor
		traitor.special_role = SPECIAL_ROLE_TRAITOR
		traitor.restricted_roles = restricted_jobs
		if(num_contractors-- > 0)
			selected_contractors += traitor

	if(!length(pre_traitors))
		return FALSE

	return TRUE


/datum/game_mode/traitor/post_setup()
	for(var/datum/mind/traitor in pre_traitors)
		var/datum/antagonist/traitor/new_antag = new
		new_antag.is_contractor = (traitor in selected_contractors)
		addtimer(CALLBACK(traitor, TYPE_PROC_REF(/datum/mind, add_antag_datum), new_antag), rand(1 SECONDS, 10 SECONDS))
	if(!exchange_blue)
		exchange_blue = -1 //Block latejoiners from getting exchange objectives
	..()


/datum/game_mode/traitor/declare_completion()
	..()
	return//Traitors will be checked as part of check_extra_completion. Leaving this here as a reminder.


/datum/game_mode/traitor/process()
	// Make sure all objectives are processed regularly, so that objectives
	// which can be checked mid-round are checked mid-round.
	for(var/datum/mind/traitor_mind in traitors)
		for(var/datum/objective/objective in traitor_mind.get_all_objectives())
			objective.check_completion()
	return FALSE


/datum/game_mode/proc/auto_declare_completion_traitor()
	if(length(traitors))
		var/text = "<FONT size = 2><B>The traitors were:</B></FONT><br>"
		for(var/datum/mind/traitor in traitors)
			var/traitorwin = TRUE
			text += printplayer(traitor) + "<br>"

			var/TC_uses = 0
			var/used_uplink = FALSE
			var/purchases = ""
			for(var/obj/item/uplink/uplink in GLOB.world_uplinks)
				if(uplink?.uplink_owner && uplink.uplink_owner == traitor.key)
					TC_uses += uplink.used_TC
					purchases += uplink.purchase_log
					used_uplink = TRUE

			if(used_uplink)
				text += " (used [TC_uses] TC) [purchases]"

			var/all_objectives = traitor.get_all_objectives()

			if(length(all_objectives))//If the traitor had no objectives, don't need to process this.
				var/count = 1
				for(var/datum/objective/objective in all_objectives)
					if(objective.check_completion())
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
						if(istype(objective, /datum/objective/steal))
							var/datum/objective/steal/steal_objective = objective
							SSblackbox.record_feedback("nested tally", "traitor_steal_objective", 1, list("Steal [steal_objective.steal_target]", "SUCCESS"))
						else
							SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[objective.type]", "SUCCESS"))
					else
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
						if(istype(objective, /datum/objective/steal))
							var/datum/objective/steal/steal_objective = objective
							SSblackbox.record_feedback("nested tally", "traitor_steal_objective", 1, list("Steal [steal_objective.steal_target]", "FAIL"))
						else
							SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[objective.type]", "FAIL"))
						traitorwin = FALSE
					count++

			var/special_role_text
			if(traitor.special_role)
				special_role_text = lowertext(traitor.special_role)
			else
				special_role_text = "antagonist"

			var/datum/antagonist/contractor/contractor = traitor?.has_antag_datum(/datum/antagonist/contractor)
			if(istype(contractor) && contractor.contractor_uplink)
				var/count = 1
				var/earned_tc = contractor.contractor_uplink.hub.reward_tc_paid_out
				for(var/datum/syndicate_contract/s_contract in contractor.contractor_uplink.hub.contracts)
					// Locations
					var/locations = list()
					for(var/area/c_area in s_contract.contract.candidate_zones)
						locations += (c_area == s_contract.contract.extraction_zone ? "<b><u>[c_area.map_name]</u></b>" : c_area.map_name)
					var/display_locations = english_list(locations, and_text = " or ")
					// Result
					var/result = ""
					if(s_contract.status == CONTRACT_STATUS_COMPLETED)
						result = "<font color='green'><B>Success!</B></font>"
					else if(s_contract.status != CONTRACT_STATUS_INACTIVE)
						result = "<font color='red'>Fail.</font>"
					text += "<br><font color='orange'><B>Contract #[count]</B></font>: Kidnap and extract [s_contract.target_name] at [display_locations]. [result]"
					count++
				text += "<br><font color='orange'><B>[earned_tc] TC were earned from the contracts.</B></font>"

			if(traitorwin)
				text += "<br><font color='green'><B>The [special_role_text] was successful!</B></font><br>"
				SSblackbox.record_feedback("tally", "traitor_success", 1, "SUCCESS")
			else
				text += "<br><font color='red'><B>The [special_role_text] has failed!</B></font><br>"
				SSblackbox.record_feedback("tally", "traitor_success", 1, "FAIL")

		if(length(SSticker.mode.implanted))
			text += "<br><br><FONT size = 2><B>The mindslaves were:</B></FONT><br>"
			for(var/datum/mind/mindslave in SSticker.mode.implanted)
				text += printplayer(mindslave)
				var/datum/mind/master_mind = SSticker.mode.implanted[mindslave]
				text += " (slaved by: <b>[master_mind.current]</b>)<br>"

		if(length(SSticker.mode.support))
			text += "<br><br><FONT size = 2><B>The Contractor Support Units were:</B></FONT><br>"
			for(var/datum/mind/csu in SSticker.mode.support)
				text += "[printplayer(csu)]<br>"

		var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
		var/responses = jointext(GLOB.syndicate_code_response, ", ")

		text += "<br><br><b>The code phrases were:</b> <span class='danger'>[phrases]</span><br>\
					<b>The code responses were:</b> <span class='danger'>[responses]</span><br><br>"

		to_chat(world, text)
	return TRUE

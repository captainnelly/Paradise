/obj/item/taperecorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon = 'icons/obj/device.dmi'
	icon_state = "taperecorder_empty"
	item_state = "analyzer"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	materials = list(MAT_METAL=60, MAT_GLASS=30)
	force = 2
	throwforce = 0
	var/recording = 0
	var/playing = 0
	var/playsleepseconds = 0
	var/obj/item/tape/mytape
	var/open_panel = 0
	var/canprint = 1
	var/starts_with_tape = TRUE
	tts_seed = "Xenia"


/obj/item/taperecorder/New()
	..()
	if(starts_with_tape)
		mytape = new /obj/item/tape/random(src)
		update_icon()

/obj/item/taperecorder/Destroy()
	QDEL_NULL(mytape)
	return ..()

/obj/item/taperecorder/examine(mob/user)
	. = ..()
	if(in_range(user, src))
		. += "<span class='notice'>The wire panel is [open_panel ? "opened" : "closed"].</span>"


/obj/item/taperecorder/attackby(obj/item/I, mob/user)
	if(!mytape && istype(I, /obj/item/tape))
		user.drop_transfer_item_to_loc(I, src)
		mytape = I
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		update_icon()

/obj/item/taperecorder/proc/eject(mob/user)
	if(mytape)
		to_chat(user, "<span class='notice'>You remove [mytape] from [src].</span>")
		stop()
		mytape.forceMove_turf()
		user.put_in_hands(mytape, ignore_anim = FALSE)
		mytape = null
		update_icon()


/obj/item/taperecorder/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	mytape.ruin() //Fires destroy the tape
	return ..()

/obj/item/taperecorder/attack_hand(mob/user)
	if(loc == user)
		if(mytape)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			eject(user)
			return
	..()


/obj/item/taperecorder/verb/ejectverb()
	set name = "Eject Tape"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape)
		return

	eject(usr)


/obj/item/taperecorder/update_icon()
	if(!mytape)
		icon_state = "taperecorder_empty"
	else if(recording)
		icon_state = "taperecorder_recording"
	else if(playing)
		icon_state = "taperecorder_playing"
	else
		icon_state = "taperecorder_idle"


/obj/item/taperecorder/hear_talk(mob/living/M as mob, list/message_pieces)
	var/msg = multilingual_to_message(message_pieces)
	if(mytape && recording)
		var/ending = copytext(msg, length(msg))
		mytape.timestamp += mytape.used_capacity
		var/datum/tape_piece/piece = new()
		piece.time = mytape.used_capacity
		piece.speaker_name = M.name
		piece.message = msg
		piece.message_verb = "says"
		piece.tts_seed = M.tts_seed

		if(M.stuttering)
			piece.message_verb = "stammers"
		else if(M.getBrainLoss() >= 60)
			piece.message_verb = "gibbers"
		else if(ending == "?")
			piece.message_verb = "asks"
		else if(ending == "!")
			piece.message_verb = "exclaims"
		mytape.storedinfo += piece

/obj/item/taperecorder/hear_message(mob/living/M as mob, msg)
	if(mytape && recording)
		mytape.timestamp += mytape.used_capacity
		var/datum/tape_piece/piece = new()
		piece.time = mytape.used_capacity
		piece.speaker_name = M.name
		piece.message = msg
		piece.message_verb = null
		piece.tts_seed = initial(tts_seed)
		mytape.storedinfo += piece

/datum/tape_piece
	var/time
	var/speaker_name
	var/message
	var/message_verb
	var/tts_seed
	var/transcript

/obj/item/taperecorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape || mytape.ruined)
		return
	if(recording)
		return
	if(playing)
		return

	if(mytape.used_capacity < mytape.max_capacity)
		to_chat(usr, "<span class='notice'>Recording started.</span>")
		recording = 1
		update_icon()
		mytape.timestamp += mytape.used_capacity
		var/datum/tape_piece/piece = new()
		piece.time = mytape.used_capacity
		piece.speaker_name = null
		piece.message = "Запись началась."
		piece.message_verb = null
		piece.tts_seed = initial(tts_seed)
		mytape.storedinfo += piece
		var/used = mytape.used_capacity	//to stop runtimes when you eject the tape
		var/max = mytape.max_capacity
		for(used, used < max)
			if(recording == 0)
				break
			mytape.used_capacity++
			used++
			sleep(10)
		recording = 0
		update_icon()
	else
		to_chat(usr, "<span class='notice'>The tape is full.</span>")


/obj/item/taperecorder/verb/stop()
	set name = "Stop"
	set category = "Object"

	if(usr.stat)
		return

	if(recording)
		recording = 0
		mytape.timestamp += mytape.used_capacity
		var/datum/tape_piece/piece = new()
		piece.time = mytape.used_capacity
		piece.speaker_name = null
		piece.message = "Запись остановлена."
		piece.message_verb = null
		piece.tts_seed = initial(tts_seed)
		mytape.storedinfo += piece
		to_chat(usr, "<span class='notice'>Recording stopped.</span>")
		return
	else if(playing)
		playing = 0
		tts_seed = initial(tts_seed)
		atom_say_verb = "says"
		atom_say("Проигрывание остановлено.")
	update_icon()


/obj/item/taperecorder/verb/play()
	set name = "Play Tape"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape || mytape.ruined)
		return
	if(recording)
		return
	if(playing)
		return

	playing = 1
	update_icon()
	to_chat(usr, "<span class='notice'>Playing started.</span>")
	var/used = mytape.used_capacity	//to stop runtimes when you eject the tape
	var/max = mytape.max_capacity
	var/datum/tape_piece/piece
	for(var/i = 1, used < max, sleep(10 * playsleepseconds))
		if(!mytape)
			break
		if(playing == 0)
			break
		if(mytape.storedinfo.len < i)
			break
		piece = mytape.storedinfo[i]
		tts_seed = piece.tts_seed
		atom_say_verb = piece.message_verb || "says"
		atom_say("[piece.message]")

		if(mytape.storedinfo.len < i + 1)
			playsleepseconds = 1
			sleep(10)
			tts_seed = initial(tts_seed)
			atom_say_verb = "says"
			atom_say("Конец записи.")
		else
			playsleepseconds = mytape.timestamp[i + 1] - mytape.timestamp[i]
		if(playsleepseconds > 14)
			sleep(10)
			tts_seed = initial(tts_seed)
			atom_say_verb = "says"
			atom_say("Пропуск [playsleepseconds] секунд тишины.")
			playsleepseconds = 1
		i++

	playing = 0
	update_icon()


/obj/item/taperecorder/attack_self(mob/user)
	if(!mytape || mytape.ruined)
		return
	if(recording)
		stop()
	else
		record()


/obj/item/taperecorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape)
		return
	if(!canprint)
		to_chat(usr, "<span class='notice'>The recorder can't print that fast!</span>")
		return
	if(recording || playing)
		return

	to_chat(usr, "<span class='notice'>Transcript printed.</span>")
	playsound(loc, 'sound/goonstation/machines/printer_thermal.ogg', 50, 1)
	flick("taperecorder_anim", src)
	sleep(3 SECONDS) //prevent paper from being printed until the end of the animation
	var/obj/item/paper/P = new /obj/item/paper(drop_location())
	var/t1 = "<B>Transcript:</B><BR><BR>"
	var/datum/tape_piece/piece
	for(var/i = 1, mytape.storedinfo.len >= i, i++)
		// mytape.storedinfo += "\[[time2text(mytape.used_capacity * 10,"mm:ss")]\] [M.name] stammers, \"[msg]\""
		piece = mytape.storedinfo[i]
		t1 += "\[[time2text(piece.time * 10,"mm:ss")]\] "
		if(piece.speaker_name)
			t1 += "[piece.speaker_name] "
		if(piece.message_verb)
			t1 += "[piece.message_verb], \"[piece.message]\"<BR>"
		else
			t1 += "[piece.message]<BR>"
	P.info = t1
	P.name = "paper- 'Transcript'"
	usr.put_in_hands(P, ignore_anim = FALSE)
	canprint = 0
	sleep(300)
	canprint = 1

//empty tape recorders
/obj/item/taperecorder/empty
	starts_with_tape = FALSE


/obj/item/tape
	name = "tape"
	desc = "A magnetic tape that can hold up to ten minutes of content."
	icon = 'icons/obj/device.dmi'
	icon_state = "tape_white"
	item_state = "analyzer"
	w_class = WEIGHT_CLASS_TINY
	materials = list(MAT_METAL=20, MAT_GLASS=5)
	force = 1
	throwforce = 0
	var/max_capacity = 600
	var/used_capacity = 0
	var/list/storedinfo = list()
	var/list/timestamp = list()
	var/ruined = 0

/obj/item/tape/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	..()
	ruin()

/obj/item/tape/attack_self(mob/user)
	if(!ruined)
		to_chat(user, "<span class='notice'>You pull out all the tape!</span>")
		ruin()

/obj/item/tape/verb/wipe()
	set name = "Wipe Tape"
	set category = "Object"

	if(usr.stat)
		return
	if(ruined)
		return

	to_chat(usr, "You erase the data from the [src]")
	clear()

/obj/item/tape/proc/clear()
	used_capacity = 0
	storedinfo.Cut()
	timestamp.Cut()

/obj/item/tape/proc/ruin()
	if(!ruined)
		overlays += "ribbonoverlay"
	ruined = 1



/obj/item/tape/proc/fix()
	overlays -= "ribbonoverlay"
	ruined = 0


/obj/item/tape/attackby(obj/item/I, mob/user)
	if(ruined && istype(I, /obj/item/screwdriver))
		to_chat(user, "<span class='notice'>You start winding the tape back in.</span>")
		if(do_after(user, 120 * I.toolspeed * gettoolspeedmod(user), target = src))
			to_chat(user, "<span class='notice'>You wound the tape back in!</span>")
			fix()
	else if(istype(I, /obj/item/pen))
		rename_interactive(user, I)

//Random colour tapes
/obj/item/tape/random/New()
	..()
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple")]"

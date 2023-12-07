//pronoun procs, for getting pronouns without using the text macros that only work in certain positions
//datums don't have gender, but most of their subtypes do!

/proc/declension_ru(num, single_name, double_name, multiple_name)
	if(!isnum(num) || round(num) != num)
		return double_name // fractional numbers
	if(((num % 10) == 1) && ((num % 100) != 11)) // 1, not 11
		return single_name
	if(((num % 10) in 2 to 4) && !((num % 100) in 12 to 14)) // 2, 3, 4, not 12, 13, 14
		return double_name
	return multiple_name // 5, 6, 7, 8, 9, 0

/proc/genderize_ru(gender, male_word, female_word, neuter_word, multiple_word)
	return gender == MALE ? male_word : (gender == FEMALE ? female_word : (gender == NEUTER ? neuter_word : multiple_word))

/proc/pluralize_ru(gender, single_word, plural_word)
	return gender == PLURAL ? plural_word : single_word


/**
 * Replaces the `%(SINGLE,PLURAL)%` or `%(MALE,FEMALE,NEUTER,PLURAL)%` message piece accordingly to user gender.
 * Use `*` to deliberatly skip one genderize word: `%(*,FEMALE,*,PLURAL)%`.
 *
 * Arguments:
 * * user - Person which pronouns will be used.
 * * msg - The string to modify.
 *
 * Returns the modified msg string.
 */
/proc/genderize_decode(mob/user, msg)
	if(!ismob(user) || !istext(msg))
		stack_trace("Invalid arguments in genderize_decode proc.")
	while(TRUE)
		var/prefix = findtext_char(msg, "%(")
		if(!prefix)
			break
		var/postfix = findtext_char(msg, ")%")
		if(!postfix)
			stack_trace("Genderize string is missing proper ending, expected )%.")
		var/list/pieces = splittext(copytext_char(msg, prefix + 2, postfix), ",")
		switch(length(pieces))
			if(2)	// pluralize if only two parts present
				msg = replacetext(splicetext_char(msg, prefix, postfix + 2, pluralize_ru(user.gender, pieces[1], pieces[2])), "*", "")
			if(4)	// use full genderize if all four parts exist
				msg = replacetext(splicetext_char(msg, prefix, postfix + 2, genderize_ru(user.gender, pieces[1], pieces[2], pieces[3], pieces[4])), "*", "")
			else
				stack_trace("Invalid data sent to genderize_decode proc.")
	return msg


/datum/proc/p_they(capitalized, temp_gender)
	. = "it"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_their(capitalized, temp_gender)
	. = "its"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_them(capitalized, temp_gender)
	. = "it"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_have(temp_gender)
	. = "has"

/datum/proc/p_are(temp_gender)
	. = "is"

/datum/proc/p_were(temp_gender)
	. = "was"

/datum/proc/p_do(temp_gender)
	. = "does"

/datum/proc/p_theyve(capitalized, temp_gender)
	. = p_they(capitalized, temp_gender) + "'" + copytext(p_have(temp_gender), 3)

/datum/proc/p_theyre(capitalized, temp_gender)
	. = p_they(capitalized, temp_gender) + "'" + copytext(p_are(temp_gender), 2)

/datum/proc/p_themselves(capitalized, temp_gender)
	. = "itself"

// For help conjugating verbs, eg they look, but she looks
/datum/proc/p_s(temp_gender)
	. = "s"

/datum/proc/p_es(temp_gender)
	. = p_s(temp_gender)
	if(.)
		. = "e[.]"

//like clients, which do have gender.
/client/p_they(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "they"
	switch(temp_gender)
		if(FEMALE)
			. = "she"
		if(MALE)
			. = "he"
	if(capitalized)
		. = capitalize(.)

/client/p_their(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "their"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "his"
	if(capitalized)
		. = capitalize(.)

/client/p_them(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "them"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "him"
	if(capitalized)
		. = capitalize(.)

/client/p_themselves(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = p_them(capitalized, temp_gender)
	switch(temp_gender)
		if(MALE, FEMALE)
			. += "self"
		if(NEUTER, PLURAL)
			. += "selves"
	if(capitalized)
		. = capitalize(.)

/client/p_have(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "has"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "have"

/client/p_are(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "is"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "are"

/client/p_were(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "was"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "were"

/client/p_do(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "does"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "do"

/client/p_s(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL && temp_gender != NEUTER)
		. = "s"

//mobs(and atoms but atoms don't really matter write your own proc overrides) also have gender!
/mob/p_they(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "it"
	switch(temp_gender)
		if(FEMALE)
			. = "she"
		if(MALE)
			. = "he"
		if(PLURAL)
			. = "they"
	if(capitalized)
		. = capitalize(.)

/mob/p_their(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "its"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "his"
		if(PLURAL)
			. = "their"
	if(capitalized)
		. = capitalize(.)

/mob/p_them(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "it"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "him"
		if(PLURAL)
			. = "them"
	if(capitalized)
		. = capitalize(.)

/mob/p_themselves(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = p_them(capitalized, temp_gender)
	switch(temp_gender)
		if(MALE, FEMALE, NEUTER)
			. += "self"
		if(PLURAL)
			. += "selves"
	if(capitalized)
		. = capitalize(.)

/mob/p_have(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "has"
	if(temp_gender == PLURAL)
		. = "have"

/mob/p_are(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "is"
	if(temp_gender == PLURAL)
		. = "are"

/mob/p_were(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "was"
	if(temp_gender == PLURAL)
		. = "were"

/mob/p_do(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "does"
	if(temp_gender == PLURAL)
		. = "do"

/mob/p_s(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL)
		. = "s"

//humans need special handling, because they can have their gender hidden
/mob/living/carbon/human/p_they(capitalized, temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/p_their(capitalized, temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/p_them(capitalized, temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/p_themselves(capitalized, temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/p_have(temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/p_are(temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/p_were(temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/p_do(temp_gender)
	temp_gender = get_visible_gender()
	return ..()

/mob/living/carbon/human/p_s(temp_gender)
	temp_gender = get_visible_gender()
	return ..()

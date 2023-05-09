/datum/pai_chem
	var/chemname
	var/key
	var/chemdesc = "This is a chemical"
	var/chemuse = 5
	var/quantity = 5

/datum/pai_chem/kelotane
	chemname = "Kelotane"
	key = "kelotane"
	chemdesc = "Slowly heals burn damage."

/datum/pai_chem/bicaridine
	chemname = "Bicaridine"
	key = "bicaridine"
	chemdesc = "Slowly heals brute damage."

/datum/pai_chem/epinephrine
	chemname = "Epinephrine"
	key = "epinephrine"
	chemdesc = "Stabilizes critical condition and slowly heals suffocation damage."

/datum/pai_chem/salbutamol
	chemname = "Salbutamol"
	key = "salbutamol"
	chemdesc = "Heals suffocation damage."

/datum/pai_chem/salglucose
	chemname = "Saline-Glucose Solution"
	key = "salglu_solution"
	chemdesc = "Heals all damage, but it requires more costs."
	chemuse = 10

/datum/pai_chem/earthsblood
	chemname = "Earthsblood"
	key = "earthsblood"
	chemdesc = "Heals all damage, great for restoring wounds, but it's a little heavy on the brain."

/datum/pai_chem/mannitol
	chemname = "Mannitol"
	key = "mannitol"
	chemdesc = "Heals brain damage."

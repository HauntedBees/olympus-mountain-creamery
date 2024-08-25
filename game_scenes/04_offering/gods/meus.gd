extends God

func get_desires_string(d: QuestDetails) -> String:
	if d.failed:
		return "You have failed me... I do not want your yogurt ever again. Leave me be, foolish mortal!"
	var desire := requirements[d.desire_idx]
	var string := "Child... I desire yogurt... "
	match desire.flavor:
		Desire.Flavor.Any: string += "I am not picky at the moment, any yogurt you have will be fine."
		Desire.Flavor.Sweet: string += "Something to scratch my sweet tooth."
		Desire.Flavor.Rich: string += "I want it as rich and full-flavored as a God like me deserves."
		Desire.Flavor.Refreshing: string += "Something to calm and refresh my tired nerves."
		Desire.Flavor.Savory: string += "Thick, savory, yogurt."
		Desire.Flavor.Luxurious: string += "The most luxurious yogurt in the heavens."
		Desire.Flavor.Earthy: string += "A human yogurt. Rough. Flavorful. Earthy."
		Desire.Flavor.Floral: string += "Yogurt imbued with floral notes."
		Desire.Flavor.Fruity: string += "with a fruity burst to it..."
		Desire.Flavor.Bitter: string += "As bitter as the Underworld."
		Desire.Flavor.Sour: string += "But I want it extra sour, not just tangy."
		Desire.Flavor.Quality: string += "The finest yogurt you have!"
	var amount := desire.yogurt_amount - d.amount_given
	if d.amount_given > 0:
		if desire.yogurt_amount == 1:
			string += " Bring me one more jar to satisfy my hunger."
		else:
			string += " Bring me %d more jars to satisfy my hunger." % amount
	else:
		if desire.yogurt_amount == 1:
			string += " Bring me one jar to satisfy my hunger."
		else:
			string += " Bring me %d jars to satisfy my hunger." % amount
	string += " You have %s." % _time_string(d.time_remaining)
	return string

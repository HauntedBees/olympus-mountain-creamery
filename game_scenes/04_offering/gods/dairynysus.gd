extends God

func get_desires_string(d: QuestDetails) -> String:
	if d.completed:
		return "Thanks to you, the party was a hit! Thanks again, homie!"
	if d.failed:
		return "The vibes are in shambles. Please leave me alone."
	elif d.time_remaining < 0.0:
		return times_up_message
	var desire := requirements[d.desire_idx]
	var string := "Yoooooo can you hook a guy up with some yogurt, buddy? "
	match desire.flavor:
		Desire.Flavor.Any: string += "Any yogurt works!"
		Desire.Flavor.Sweet: string += "And make it sweet!"
		Desire.Flavor.Rich: string += "Some RICH yogurt!"
		Desire.Flavor.Refreshing: string += "Something refreshing, dawg."
		Desire.Flavor.Savory: string += "The most savory yog you can gurt!"
		Desire.Flavor.Luxurious: string += "Something luxurious, like my parties!"
		Desire.Flavor.Earthy: string += "An earthy yogurt."
		Desire.Flavor.Floral: string += "I'm craving something floral."
		Desire.Flavor.Fruity: string += "with a fruity burst to it..."
		Desire.Flavor.Bitter: string += "Make it bitter!"
		Desire.Flavor.Sour: string += "But I want it extra sour, not just tangy."
		Desire.Flavor.Quality: string += "The highest-quality yogurt you have!"
	var amount := desire.yogurt_amount - d.amount_given
	if d.amount_given > 0:
		if amount == 1:
			string += " Just one more jar, fam!"
		else:
			string += " Just %d more jars, fam!" % amount
	else:
		if amount == 1:
			string += " Bring me one jar and you'll be a hero!"
		else:
			string += " Bring me %d jars and you'll be a hero!" % amount
	if !Player.options.no_time_limits:
		string += " You have %s." % _time_string(d.time_remaining)
	return string

extends God

func get_desires_string(d: QuestDetails) -> String:
	if d.completed:
		return "Thank you for all the yogurt you've given me!"
	if d.failed:
		return "I'm not ready to be hurt again by your terrible yogurt. I'm sorry."
	elif d.time_remaining < 0.0:
		return times_up_message
	var desire := requirements[d.desire_idx]
	var string := "Hello... would you be kind enough to share some yogurt with me? "
	match desire.flavor:
		Desire.Flavor.Any: string += "Any yogurt is fine."
		Desire.Flavor.Sweet: string += "Something sweet, if you could."
		Desire.Flavor.Rich: string += "A rich yogurt, if it wouldn't be a problem."
		Desire.Flavor.Refreshing: string += "Something to refresh my soul."
		Desire.Flavor.Savory: string += "A savory yogurt.."
		Desire.Flavor.Luxurious: string += "The most luxurious yogurt you can make!"
		Desire.Flavor.Earthy: string += "An earthy yogurt; I want to taste nature!"
		Desire.Flavor.Floral: string += "Yogurt imbued with floral notes."
		Desire.Flavor.Fruity: string += "with a fruity burst to it..."
		Desire.Flavor.Bitter: string += "Something bitter this time."
		Desire.Flavor.Sour: string += "But I want it extra sour, not just tangy."
		Desire.Flavor.Quality: string += "The highest quality yogurt you have!"
	var amount := desire.yogurt_amount - d.amount_given
	if d.amount_given > 0:
		if desire.yogurt_amount == 1:
			string += " Could you please bring one more jar?"
		else:
			string += " Could you please bring %d more jars?" % amount
	else:
		if desire.yogurt_amount == 1:
			string += " Could you please bring one jar?"
		else:
			string += " Could you please bring %d jars?" % amount
	if !Player.options.no_time_limits:
		string += " Please bring it within %s, if it's not too much trouble!" % _time_string(d.time_remaining)
	return string

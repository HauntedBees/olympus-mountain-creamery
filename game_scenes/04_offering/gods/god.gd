class_name God extends Control

@export var requirements: Array[Desire] = []

func get_desires_string(idx: int, time: float) -> String:
	var desire := requirements[idx]
	return "I want %d yogurts in %.0f seconds." % [desire.yogurt_amount, _time_string(time)]

func _time_string(time: float) -> String:
	if time > 60.0:
		return "%d minutes" % roundi(time / 60.0)
	elif time == 1.0:
		return "%d second" % roundi(time)
	elif time > 0.0:
		return "%d seconds" % roundi(time)
	else:
		return "0 seconds"

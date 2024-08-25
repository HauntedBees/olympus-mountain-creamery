extends Node

@warning_ignore("unused_signal") #TODO: this
signal input_method_changed()

var options := PlayerOptions.new()
var data := PlayerData.new()
var last_input_was_gamepad := false

func _process(delta: float) -> void:
	for y in data.yogurts:
		y.fermentation_time += delta
	for idx in data.god_time_remaining.size():
		data.god_time_remaining[idx] -= delta

extends Node

signal input_method_changed()

var options := PlayerOptions.new()
var data := PlayerData.new()
var last_input_was_gamepad := false

func _process(delta: float) -> void:
	for y in data.yogurts:
		y.fermentation_time += delta
	if options.no_time_limits:
		return
	for d in data.god_details:
		d.time_remaining -= delta

func _input(event: InputEvent) -> void:
	var before := last_input_was_gamepad
	if event is InputEventJoypadButton:
		last_input_was_gamepad = true
	elif event is InputEventKey:
		last_input_was_gamepad = false
	if last_input_was_gamepad != before:
		input_method_changed.emit()

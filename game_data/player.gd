extends Node

signal input_method_changed()

var options := PlayerOptions.new()
var data := PlayerData.new()
var last_input_was_gamepad := false

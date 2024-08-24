@tool
class_name BoilPot extends Control

const _MAX_MILK_Y := 310.0

@export_range(0.0, 1.0) var fill_percent := 0.0:
	set(value):
		fill_percent = value
		_update_milk_pos()

@onready var _milk: VBoxContainer = %Milk

func _update_milk_pos() -> void:
	if !is_inside_tree():
		await ready
	_milk.position.y = (1.0 - fill_percent) * _MAX_MILK_Y

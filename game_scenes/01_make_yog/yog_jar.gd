@tool
class_name YogJar extends Control

const _BURN_COLOR := Color("#501500")

@export var max_milk_y := 310.0

@export_range(0.0, 1.0) var fill_percent := 0.0:
	set(value):
		fill_percent = value
		_update_milk_pos()

@export_range(0.0, 1.0) var burn_amount := 0.0:
	set(value):
		burn_amount = value
		_update_milk_burn()

var _milk_gradient: Gradient

@onready var _milk: VBoxContainer = %Milk
@onready var _milk_base: TextureRect = %MilkBase

func _ready() -> void:
	var grad_tex := _milk_base.texture as GradientTexture2D
	var grad := grad_tex.gradient
	_milk_gradient = grad.duplicate()
	grad_tex.gradient = _milk_gradient

func _update_milk_pos() -> void:
	if !is_inside_tree():
		await ready
	_milk.position.y = (1.0 - fill_percent) * max_milk_y

func _update_milk_burn() -> void:
	if !is_inside_tree():
		await ready
	_milk_gradient.colors[0] = Color.WHITE.lerp(_BURN_COLOR, burn_amount)

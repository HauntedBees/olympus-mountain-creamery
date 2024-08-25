class_name TempMeter extends CenterContainer

const _RADIAN := PI / 180.0
const _BASE_ANGLE := PI
const COLD_TEMP := 45.0 * _RADIAN
const MAX_LOW_FIRE_HEAT_TEMP := 100.0 * _RADIAN
const SAFE_TEMP := 130.0 * _RADIAN
const GOOD_TEMP := 155.0 * _RADIAN

const TOO_WARM_MAX := 230.0 * _RADIAN
const JUST_RIGHT_MAX := 206.0 * _RADIAN

@export_range(0.0, PI) var temperature := 0.0:
	set(value):
		temperature = clampf(value, 0.0, PI)
		_update_temperature_display()

var cold := false:
	set(value):
		cold = value
		if !is_inside_tree():
			await ready
		_meter.visible = !cold
		_cold_meter.visible = cold

@onready var _rotater: TextureRect = %Rotater
@onready var _meter: TextureRect = %Meter
@onready var _cold_meter: TextureRect = %ColdMeter

func _update_temperature_display() -> void:
	if !is_inside_tree():
		await ready
	_rotater.rotation = _BASE_ANGLE + temperature

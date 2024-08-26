class_name LilYog extends Control

const _SOUR = preload("res://assets/other/kenney/minimap_icon_exclamation_red.png")
const _WAITING = preload("res://assets/other/kenney/minimap_icon_jewel_yellow.png")
const _READY = preload("res://assets/other/kenney/minimap_icon_star_red.png")

@onready var yog_jar: YogJar = %YogJar
@onready var _label: Label = %Label
@onready var _lil_star: TextureRect = %LilStar
@onready var _quality_milk: Control = %QualityMilk

var _milk_pot: MilkPotData

func bind_jar(m: MilkPotData) -> void:
	yog_jar.set_from_info(m)
	_label.visible = true
	_lil_star.visible = true
	_milk_pot = m
	_quality_milk.visible = _milk_pot.quality_multiplier >= Desire.QUALITY_YOGURT_MIN

func _process(_delta: float) -> void:
	if !_milk_pot:
		return
	var time := _milk_pot.fermentation_time
	if time < MilkPotData.SOUPY_LIMIT:
		_lil_star.texture = _WAITING
		var time_remaining := MilkPotData.SOUPY_LIMIT - time
		var minutes := floori(time_remaining / 60.0)
		var seconds := floori(time_remaining) % 60
		_label.text = "%d:%02d" % [minutes, seconds]
	elif time < MilkPotData.SOUR_LIMIT:
		_lil_star.texture = _READY
		var time_remaining := MilkPotData.SOUR_LIMIT - time
		var minutes := floori(time_remaining / 60.0)
		var seconds := floori(time_remaining) % 60
		_label.text = "%d:%02d" % [minutes, seconds]
	else:
		_lil_star.texture = _SOUR
		_label.text = ""

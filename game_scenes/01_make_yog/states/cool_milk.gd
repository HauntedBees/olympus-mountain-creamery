class_name CoolMilkState extends MakeYogGameState

var _temperature: float:
	get:
		return _make_yog.temp_meter.temperature
	set(value):
		_make_yog.temp_meter.temperature = value

var _ice_added := 1.1

func initialize() -> void:
	_make_yog.info_label.text = "Ice Time :)"
	_make_yog.detail_label.text = "Cool the milk down so the bacteria won't get killed by the heat. Press the Primary Button to add more ice. Press the Secondary Button at the right time to take it off the ice and move on."
	_make_yog.temp_meter.visible = true
	_make_yog.temp_meter.cold = true
	_make_yog.ice_container.visible = true
	_make_yog.ice_container.ice_amount = 50
	_make_yog.left_btn.text = "Ice"
	_make_yog.right_btn.text = "Next"
	
func clean() -> void:
	_make_yog.temp_meter.visible = false
	_make_yog.temp_meter.cold = false
	_make_yog.ice_container.visible = true
	_make_yog.ice_container.ice_amount = 0

func update(delta: float) -> void:
	#print(_temperature / (PI / 180.0))
	if Input.is_action_just_pressed("button_two"):
		input_blocked = true
		if _temperature >= TempMeter.TOO_WARM_MAX:
			var amount_warm := _temperature - TempMeter.TOO_WARM_MAX
			var max_amount := PI - TempMeter.TOO_WARM_MAX
			var bacteria_damage_ratio := clampf((amount_warm / max_amount), 0.1, 1.0)
			_pot.bacteria_amount *= bacteria_damage_ratio
		elif _temperature >= TempMeter.JUST_RIGHT_MAX:
			_pot.quality_multiplier *= 1.25
		else:
			var amount_cold := _temperature / TempMeter.JUST_RIGHT_MAX
			_pot.fermentation_time_diminisher *= 0.5 + (amount_cold / 2.0)
		change_state.emit(FillJarsState.new(_make_yog, _pot))
		return
	if Input.is_action_just_pressed("button_one"):
		_ice_added *= 1.5
		_make_yog.ice_container.ice_amount += randi_range(10, 30)
	_temperature -= delta * log(_ice_added) * (Player.data.milk_pot_capacity / _pot.amount)

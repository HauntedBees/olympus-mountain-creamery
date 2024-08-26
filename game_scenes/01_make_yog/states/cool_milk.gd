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
	if Input.is_action_just_pressed("button_two"):
		input_blocked = true
		# TODO: calculate bacteria and cool multipliers
		change_state.emit(FillJarsState.new(_make_yog, _pot))
		return
	if Input.is_action_just_pressed("button_one"):
		_ice_added *= 1.5
		_make_yog.ice_container.ice_amount += randi_range(10, 30)
	_temperature -= delta * log(_ice_added) * (Player.data.milk_pot_capacity / _pot.amount)

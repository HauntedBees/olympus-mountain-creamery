class_name CoolMilkState extends MakeYogGameState

var _temperature: float:
	get:
		return _make_yog.temp_meter.temperature
	set(value):
		_make_yog.temp_meter.temperature = value

var _ice_added := 1.0

func initialize() -> void:
	_make_yog.temp_meter.visible = true
	_make_yog.temp_meter.cold = true
	_make_yog.ice_container.visible = true
	_make_yog.ice_container.ice_amount = 50
	_make_yog.info_label.text = ""
	
func clean() -> void:
	_make_yog.temp_meter.visible = false
	_make_yog.temp_meter.cold = false
	_make_yog.ice_container.visible = true
	_make_yog.ice_container.ice_amount = 0

func update(delta: float) -> void:
	if Input.is_action_just_pressed("button_two"):
		input_blocked = true
		# TODO: some animation/delay/transition to finish things off
		change_state.emit(CoolMilkState.new(_make_yog, _pot))
		return
	if Input.is_action_just_pressed("button_one"):
		_ice_added += 0.1
		_make_yog.ice_container.ice_amount += randi_range(10, 30)
	_temperature -= delta * log(_ice_added)

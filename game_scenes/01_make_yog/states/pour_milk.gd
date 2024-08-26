class_name PourMilkState extends MakeYogGameState

const _MILK_POUR_RATE := 1.5

var _did_start_pouring := false

func initialize() -> void:
	_update_milk_label()
	_toggle_action_hold("button_one", true)
	_make_yog.detail_label.text = "Press and hold the Primary Button to pour milk into the pot. Be careful not to overfill the pot!"
	_make_yog.left_btn.text = "Pour"
	_make_yog.right_btn.text = "Next"
	_make_yog.right_btn.toggle_visibility(Player.options.multiple_milk_pours)
	_make_yog.pour_hands.visible = true

func update(delta: float) -> void:
	if Player.options.multiple_milk_pours && Input.is_action_just_pressed("button_two"):
		_finish_pouring()
		return
	if _make_yog.boil_pot.overflowing:
		_make_yog.boil_pot.overflowing = false
	if Input.is_action_pressed("button_one"):
		if !_did_start_pouring:
			_make_yog.pour_hands.pouring = true
		_did_start_pouring = true
		var fuller_bowl_faster_pour := _fill_formula(_make_yog.boil_pot.fill_percent)
		var amount_poured := delta * _MILK_POUR_RATE * Player.options.speed_multiplier * fuller_bowl_faster_pour
		if amount_poured > Player.data.milk_amount:
			amount_poured = Player.data.milk_amount
		_pot.amount += amount_poured
		Player.data.milk_amount -= amount_poured
		_update_milk_label()
		if _pot.amount > Player.data.milk_pot_capacity:
			_pot.amount = Player.data.milk_pot_capacity
			_make_yog.boil_pot.fill_percent = 1.0
			_make_yog.boil_pot.overflowing = true
		else:
			_make_yog.boil_pot.fill_percent = _pot.amount / Player.data.milk_pot_capacity
	elif _did_start_pouring:
		_did_start_pouring = false
		_make_yog.pour_hands.pouring = false
		if !Player.options.multiple_milk_pours:
			_finish_pouring()

func clean() -> void:
	_make_yog.right_btn.toggle_visibility(true)
	_make_yog.pour_hands.visible = false
	_toggle_action_hold("button_one", false)

## Fills up faster at start and end than middle.
func _fill_formula(current_amount: float) -> float:
	return 1.0 + pow(2.0 * (0.25 + current_amount) - 1.0, 2.0) * 3.0

func _update_milk_label() -> void:
	_make_yog.info_label.text = "Milk Remaining: %.1ft" % Player.data.milk_amount

func _finish_pouring() -> void:
	input_blocked = true
	change_state.emit(HeatMilkState.new(_make_yog, _pot))
	#change_state.emit(FillJarsState.new(_make_yog, _pot))

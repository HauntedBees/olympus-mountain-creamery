class_name PourMilkState extends MakeYogGameState

const _MILK_POUR_RATE := 0.25

var milk_amount := 0.0

var _did_start_pouring := false

func _init(s: GameScene) -> void:
	super(s)
	_update_milk_label()

func update(delta: float) -> void:
	if input_blocked:
		return
	if Input.is_action_just_pressed("button_two"):
		_finish_pouring()
		return
	if Input.is_action_pressed("button_one"):
		_did_start_pouring = true
		var fuller_bowl_faster_pour := 1.0 + 3.0 * milk_amount
		var amount_poured := delta * _MILK_POUR_RATE * Player.options.speed_multiplier * fuller_bowl_faster_pour
		if amount_poured > Player.data.milk_amount:
			amount_poured = Player.data.milk_amount
		milk_amount += amount_poured
		Player.data.milk_amount -= amount_poured
		_update_milk_label()
		_make_yog.boil_pot.fill_percent = milk_amount / Player.data.milk_pot_capacity
	elif _did_start_pouring && !Player.options.multiple_milk_pours:
		_finish_pouring()

func _update_milk_label() -> void:
	_make_yog.milk_label.text = "Milk Remaining: %.1fτ" % Player.data.milk_amount

func _finish_pouring() -> void:
	print("DONE")
	input_blocked = true
	# TODO: some animation/delay/transition to finish things off
	change_state.emit(null)

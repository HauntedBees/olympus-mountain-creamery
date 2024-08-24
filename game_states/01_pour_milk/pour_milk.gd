extends GameState

const _MILK_POUR_RATE := 0.25

var _milk_amount := 0.0
var _did_start_pouring := false

@onready var _boil_pot: BoilPot = %BoilPot

func _process(delta: float) -> void:
	if _input_blocked:
		return
	if Input.is_action_just_pressed("button_two"):
		_finish_pouring()
		return
	if Input.is_action_pressed("button_one"):
		_did_start_pouring = true
		var fuller_bowl_faster_pour := 1.0 + 3.0 * _milk_amount
		var amount_poured := delta * _MILK_POUR_RATE * Player.options.speed_multiplier * fuller_bowl_faster_pour
		if amount_poured > Player.data.milk_amount:
			amount_poured = Player.data.milk_amount
		_milk_amount += amount_poured
		Player.data.milk_amount -= amount_poured
		_boil_pot.fill_percent = _milk_amount / Player.data.milk_pot_capacity
	elif _did_start_pouring && !Player.options.multiple_milk_pours:
		_finish_pouring()

func _finish_pouring() -> void:
	print("DONE")
	_input_blocked = true

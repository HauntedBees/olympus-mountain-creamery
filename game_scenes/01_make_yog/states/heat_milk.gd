class_name HeatMilkState extends MakeYogGameState

const _STIR_ANIMATION_RATE := 1.5
const _STIR_POWER := 2.0
const _STIR_ACCUMULATION_RATE := _STIR_POWER * 0.25
const _ENERGY_DEPLETION_RATE := 2.0
const _BIG_FIRE_SIZE := Vector2(512, 256)
const _SMALL_FIRE_SIZE := Vector2(256, 128)

var _spoon: PathFollow2D
var _energy: float
var _max_energy: float
var _locked_by_energy := false
var _stir_amount := 0.0
var _high_fire := false
var _sweet_spot_triggered := false
var _sweet_spot_time_remaining := 5.0
var _temperature: float:
	get:
		return _make_yog.temp_meter.temperature
	set(value):
		_make_yog.temp_meter.temperature = value

func initialize() -> void:
	_make_yog.detail_label.text = "Press the Secondary Button to adjust the heat. Warm the milk to the right temperature and keep it there for 5 seconds. Be sure to stir it often by holding the Primary Button, or it'll burn!"
	_make_yog.fire.visible = true
	_make_yog.temp_meter.visible = true
	_spoon = _make_yog.boil_pot.spoon_path
	_spoon.visible = true
	_energy = Player.data.arm_energy
	_max_energy = _energy
	_make_yog.left_btn.text = "Stir"
	_make_yog.right_btn.text = "Heat"
	_update_energy_label()

func update(delta: float) -> void:
	_finish_check(delta)
	_update_energy_label()
	_adjust_temperature(delta)
	_try_burn(delta)
	if _energy < _max_energy:
		_energy = clampf(_energy + delta * Player.data.arm_recovery_rate, 0.0, _max_energy)
	if Input.is_action_pressed("button_one"):
		if !_locked_by_energy:
			_spoon.progress_ratio += delta * _STIR_ANIMATION_RATE
			var depletion_amount := delta * _ENERGY_DEPLETION_RATE * Player.options.speed_multiplier
			_energy = clampf(_energy - depletion_amount, 0.0, _max_energy)
			_stir_amount = clampf(_stir_amount - delta * _STIR_POWER, 0.0, 5.0)
			if _energy <= depletion_amount:
				_locked_by_energy = true
	else:
		_locked_by_energy = false
	if Input.is_action_just_pressed("button_two"):
		_high_fire = !_high_fire
		_resize_fire()

func clean() -> void:
	_make_yog.fire.visible = false
	_spoon.visible = false
	_make_yog.temp_meter.visible = false

func _finish_check(delta: float) -> void:
	if _temperature >= TempMeter.SAFE_TEMP && _temperature <= TempMeter.GOOD_TEMP:
		_sweet_spot_time_remaining -= delta
		_sweet_spot_triggered = true
	if _sweet_spot_time_remaining > 0.0:
		return
	_sweet_spot_time_remaining = 0.0
	input_blocked = true
	change_state.emit(CoolMilkState.new(_make_yog, _pot))

func _update_energy_label() -> void:
	if _sweet_spot_triggered:
		_make_yog.info_label.text = "Arm Energy: %.1f\nTime at Safe Temp Remaining: %.1f" % [_energy, _sweet_spot_time_remaining]
	else:
		_make_yog.info_label.text = "Arm Energy: %.1f" % _energy

func _resize_fire() -> void:
	var t := _make_yog.create_tween()
	t.tween_property(_make_yog.fire, "custom_minimum_size", _BIG_FIRE_SIZE if _high_fire else _SMALL_FIRE_SIZE, 0.25)

func _adjust_temperature(delta: float) -> void:
	if _high_fire:
		if _temperature >= TempMeter.GOOD_TEMP:
			_temperature += delta * 0.15
		elif _temperature > TempMeter.COLD_TEMP:
			_temperature += delta * 0.5
		else:
			_temperature += delta * 0.75
	else:
		if _temperature >= TempMeter.GOOD_TEMP:
			_temperature -= delta * 0.2
		elif _temperature >= TempMeter.MAX_LOW_FIRE_HEAT_TEMP:
			_temperature -= delta * 0.1
		elif _temperature > TempMeter.COLD_TEMP:
			_temperature += delta * 0.15
		else:
			_temperature += delta * 0.3

func _try_burn(delta: float) -> void:
	_stir_amount = clampf(_stir_amount + delta * _STIR_ACCUMULATION_RATE, 0.0, 5.0)
	if _stir_amount <= 1.0:
		return
	# Can't burn when it's too cold and the fire isn't too hot.
	if !_high_fire && _temperature < TempMeter.COLD_TEMP:
		return
	var chance := delta * _stir_amount * (1.5 if _high_fire else 1.0)
	if _temperature >= TempMeter.GOOD_TEMP:
		chance += 0.5 if _high_fire else 0.25
	if randf() > chance:
		return
	_pot.burnt_amount = clampf(_pot.burnt_amount + randf_range(0.0, 0.1), 0.0, 1.0)
	_make_yog.boil_pot.burn_amount = _pot.burnt_amount

class_name FillJarsState extends MakeYogGameState

const _YOG_JAR_SCENE := preload("res://game_scenes/01_make_yog/yog_jar.tscn")
const _MILK_POUR_RATE := 0.75

enum State { Animating, Pouring, Flavoring }

var _root: Control
var _yog_jars: Array[MilkPotData] = []
var _yog_jar_displays: Array[YogJar] = []
var _current_jar: MilkPotData
var _state := State.Animating
var _current_jar_display: YogJar
var _did_start_pouring := false

func initialize() -> void:
	_make_yog.boil_pot.visible = false
	_root = _make_yog.yog_jars
	_root.visible = true
	_add_yog()
	_update_milk_label()
	
func clean() -> void:
	_root.visible = false
	_make_yog.boil_pot.visible = true
	for y in _yog_jar_displays:
		y.queue_free()
	_yog_jar_displays.clear()
	_yog_jars.clear()
	_current_jar = null
	_current_jar_display = null

func update(delta: float) -> void:
	match _state:
		State.Pouring:
			update_pour(delta)

func update_pour(delta: float) -> void:
	if Player.options.multiple_milk_pours && Input.is_action_just_pressed("button_two"):
		_add_yog()
		return
	if Input.is_action_pressed("button_one"):
		_did_start_pouring = true
		var fuller_bowl_faster_pour := _fill_formula(_make_yog.boil_pot.fill_percent)
		var amount_poured := delta * _MILK_POUR_RATE * Player.options.speed_multiplier * fuller_bowl_faster_pour
		if amount_poured > _pot.amount:
			amount_poured = _pot.amount
		_current_jar.amount += amount_poured
		_pot.amount -= amount_poured
		_update_milk_label()
		# TODO: overflow
		_current_jar_display.fill_percent = _current_jar.amount / PlayerData.JAR_CAPACITY
		if _pot.amount <= 0:
			_finish_pouring()
	elif _did_start_pouring && !Player.options.multiple_milk_pours:
		_add_yog()

## Fills up faster at start and end than middle.
func _fill_formula(current_amount: float) -> float:
	return 1.0 + pow(2.0 * (0.25 + current_amount) - 1.0, 2.0) * 3.0

func _update_milk_label() -> void:
	_make_yog.info_label.text = "Milk Remaining: %.1fτ" % _pot.amount

func _finish_pouring() -> void:
	if _current_jar:
		_yog_jars.append(_current_jar)
	Player.data.yogurts.append_array(_yog_jars)
	change_scene.emit("res://game_scenes/02_outside/outside.tscn")

func _add_yog() -> void:
	_state = State.Animating
	if _current_jar:
		_yog_jars.append(_current_jar)
	if Player.data.jars == 0:
		_finish_pouring()
		return
	var rect := _root.get_viewport_rect()
	var midpoint := rect.size.y * 0.6
	if _current_jar_display:
		var last_t := _root.create_tween()
		last_t.tween_property(_current_jar_display, "position", Vector2(-_current_jar_display.size.x, midpoint), 0.25)
	_current_jar_display = _YOG_JAR_SCENE.instantiate()
	_yog_jar_displays.append(_current_jar_display)
	_root.add_child(_current_jar_display)
	_current_jar_display.position = Vector2(rect.end.x + _current_jar_display.size.x, midpoint)
	_current_jar = _pot.duplicate()
	_current_jar.amount = 0.0
	Player.data.jars -= 1
	input_blocked = true
	var t := _root.create_tween()
	var mid_x := rect.size.x / 2.0 - _current_jar_display.size.x / 2.0
	t.tween_property(_current_jar_display, "position", Vector2(mid_x, midpoint), 0.25)
	t.tween_callback(func() -> void: 
		input_blocked = false
		# TODO: flavors
		_state = State.Pouring
		_did_start_pouring = false
	)

class_name FillJarsState extends MakeYogGameState

const _YOG_JAR_SCENE := preload("res://game_scenes/shared_nodes/yog_jar.tscn")
const _MILK_POUR_RATE := 1.75
const _HANDS_OFFSET := Vector2(-50, 175)

enum State { Animating, Pouring, Flavoring }

var _root: Control
var _yog_jars: Array[MilkPotData] = []
var _yog_jar_displays: Array[YogJar] = []
var _current_jar: MilkPotData
var _state := State.Animating
var _current_jar_display: YogJar
var _did_start_pouring := false
var _flavor_idx := 0
var _flavor_added := false
var _input_cooldown := 0.0 # switching to pour from flavor was glitchy so this is the easiest possible fix

func initialize() -> void:
	_make_yog.detail_label.text = "Add ingredients with the Secondary Button if you have any, then press and hold the Primary Button to pour the heated milk mixture into each jar until you run out of milk or jars."
	_make_yog.boil_pot.visible = false
	_root = _make_yog.yog_jars
	_root.visible = true
	_make_yog.left_btn.text = "Pour"
	if Player.data.inventory.size() > 0:
		_make_yog.right_btn.text = "Flavor"
	else:
		_make_yog.right_btn.toggle_visibility(false)
	_add_yog()
	_update_milk_label()
	_make_yog.pour_hands.visible = true
	_make_yog.pour_hands.position += _HANDS_OFFSET
	_toggle_action_hold("button_one", true)

func clean() -> void:
	_make_yog.right_btn.toggle_visibility(true)
	_root.visible = false
	_make_yog.item_list.visible = false
	_make_yog.boil_pot.visible = true
	for y in _yog_jar_displays:
		y.queue_free()
	_yog_jar_displays.clear()
	_yog_jars.clear()
	_current_jar = null
	_current_jar_display = null
	_make_yog.pour_hands.visible = false
	_make_yog.pour_hands.position -= _HANDS_OFFSET
	_toggle_action_hold("button_one", false)

func update(delta: float) -> void:
	if _input_cooldown > 0.0:
		_input_cooldown -= delta
		return
	match _state:
		State.Pouring: _update_pour(delta)
		State.Flavoring: _update_flavor()

func _update_pour(delta: float) -> void:
	if _current_jar_display && _current_jar_display.overflowing:
		_current_jar_display.overflowing = false
	var pressed_two := Input.is_action_just_pressed("button_two")
	if !_did_start_pouring && !_flavor_added && pressed_two && Player.data.inventory.size() > 0:
		_switch_to_flavor()
		return
	if Player.options.multiple_milk_pours && pressed_two:
		_add_yog()
		return
	if Input.is_action_pressed("button_one"):
		if !_did_start_pouring:
			_make_yog.pour_hands.pouring = true
			if Player.options.multiple_milk_pours:
				_make_yog.right_btn.text = "Next"
				_make_yog.right_btn.toggle_visibility(true)
			else:
				_make_yog.right_btn.toggle_visibility(false)
			_did_start_pouring = true
		var fuller_bowl_faster_pour := _fill_formula(_make_yog.boil_pot.fill_percent)
		var amount_poured := delta * _MILK_POUR_RATE * Player.options.speed_multiplier * fuller_bowl_faster_pour
		if amount_poured > _pot.amount:
			amount_poured = _pot.amount
		_current_jar.amount += amount_poured
		_pot.amount -= amount_poured
		_update_milk_label()
		if _current_jar.amount > Player.data.JAR_CAPACITY:
			_current_jar_display.fill_percent = 1.0
			_current_jar_display.overflowing = true
			_current_jar.amount = Player.data.JAR_CAPACITY
		else:
			_current_jar_display.fill_percent = _current_jar.amount / PlayerData.JAR_CAPACITY
		if _pot.amount <= 0:
			_finish_pouring()
	elif _did_start_pouring && !Player.options.multiple_milk_pours:
		_add_yog()

func _update_flavor() -> void:
	if Input.is_action_just_pressed("button_two"):
		_next_flavor()
	elif Input.is_action_just_pressed("button_one"):
		if _flavor_idx >= 0:
			var flavor := _make_yog.flavors[_flavor_idx].item
			Player.data.remove_item(flavor, 1)
			_current_jar.flavoring = flavor
			_current_jar_display.flavor = flavor
			_flavor_added = true
			_make_yog.right_btn.toggle_visibility(false)
		_switch_to_pour()

func _next_flavor() -> void:
	if _flavor_idx < 0:
		_make_yog.none_flavor.selected = false
	else:
		_make_yog.flavors[_flavor_idx].selected = false
	var next_idx := _flavor_idx
	while _flavor_idx == next_idx || next_idx < 0 || !_make_yog.flavors[next_idx].visible:
		next_idx += 1
		if next_idx >= _make_yog.flavors.size():
			next_idx = -1
			break
	_flavor_idx = next_idx
	if _flavor_idx < 0:
		_make_yog.none_flavor.selected = true
	else:
		_make_yog.flavors[_flavor_idx].selected = true
	_update_flavor_button()

func _switch_to_pour() -> void:
	_state = State.Pouring
	_make_yog.item_list.visible = false
	_make_yog.right_btn.text = "Flavor"
	_input_cooldown = 0.2

func _switch_to_flavor() -> void:
	_state = State.Flavoring
	_make_yog.item_list.visible = true
	if _flavor_idx < 0:
		_make_yog.none_flavor.selected = false
	else:
		_make_yog.flavors[_flavor_idx].selected = false
	_flavor_idx = -1
	_make_yog.right_btn.text = "Next"
	for idx in _make_yog.flavors.size():
		var item := _make_yog.flavors[idx].item
		var amount := Player.data.get_item_count(item)
		_make_yog.flavors[idx].visible = amount > 0
		if amount == 0:
			continue
		_make_yog.flavor_labels[idx].text = "x%d" % amount
	_next_flavor()
	_input_cooldown = 0.2

func _update_flavor_button() -> void:
	_make_yog.left_btn.text = "Back" if _flavor_idx < 0 else "Add"

## Fills up faster at start and end than middle.
func _fill_formula(current_amount: float) -> float:
	return 1.0 + 0.5 * current_amount

func _update_milk_label() -> void:
	_make_yog.info_label.text = "Mixture Remaining: %.1fτ" % _pot.amount

func _finish_pouring() -> void:
	if _current_jar:
		_yog_jars.append(_current_jar)
	var avg_milk := 0.0
	# Get average, and apply bacteria and burn debuffs
	for y in _yog_jars:
		y.quality_multiplier *= y.bacteria_amount
		if y.burnt_amount >= 0.2:
			y.quality_multiplier *= clampf(1.2 - y.burnt_amount, 0.25, 1.0)
		avg_milk += y.amount
	avg_milk /= _yog_jars.size()
	var yogs_in_range := 0
	for y in _yog_jars:
		if absf(y.amount - avg_milk) <= 0.4:
			yogs_in_range += 1
	if yogs_in_range > 1:
		var multiplier := 2.5 if yogs_in_range == _yog_jars.size() else (1.2 + float(yogs_in_range) / _yog_jars.size())
		for y in _yog_jars:
			y.quality_multiplier *= multiplier
	Player.data.yogurts.append_array(_yog_jars)
	change_scene.emit("res://game_scenes/02_outside/outside.tscn")

func _add_yog() -> void:
	_input_cooldown = 0.2
	_make_yog.pour_hands.pouring = false
	_flavor_added = false
	_did_start_pouring = false
	_state = State.Animating
	if Player.data.inventory.size() > 0:
		_make_yog.right_btn.toggle_visibility(true)
		_make_yog.right_btn.text = "Flavor"
	if _current_jar:
		_yog_jars.append(_current_jar)
	if Player.data.jars == 0:
		_finish_pouring()
		return
	var rect := _root.get_viewport_rect()
	var y_position := rect.size.y * 0.7 #REF: probably not resolution-proof; fix this if mobile happens
	if _current_jar_display:
		var last_t := _root.create_tween()
		last_t.tween_property(_current_jar_display, "position", Vector2(-_current_jar_display.size.x, y_position), 0.25)
	_current_jar_display = _YOG_JAR_SCENE.instantiate()
	_yog_jar_displays.append(_current_jar_display)
	_root.add_child(_current_jar_display)
	_current_jar_display.position = Vector2(rect.end.x + _current_jar_display.size.x, y_position)
	_current_jar = _pot.duplicate()
	_current_jar.amount = 0.0
	Player.data.jars -= 1
	input_blocked = true
	var t := _root.create_tween()
	var mid_x := rect.size.x / 2.0 - _current_jar_display.size.x / 2.0
	t.tween_property(_current_jar_display, "position", Vector2(mid_x, y_position), 0.25)
	t.tween_callback(func() -> void: 
		input_blocked = false
		_state = State.Pouring
		_did_start_pouring = false
	)

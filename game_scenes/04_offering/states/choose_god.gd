class_name ChooseGodState extends OfferingGameState

var _current_details: QuestDetails

func initialize() -> void:
	_make_off.main_menu.visible = true
	_god_idx -= 1
	_next_god()
	_unlock_gods()

func update(_delta: float) -> void:
	_set_text()
	if _current_details && _current_details.time_remaining < 0.0:
		_make_off.offer_go_prompt.toggle_visibility(false)
	if Input.is_action_just_pressed("button_two"):
		_next_god()
	elif Input.is_action_pressed("button_one"):
		if _god_idx < 0:
			if !_check_for_end_game():
				change_scene.emit("res://game_scenes/02_outside/outside.tscn")
			return
		if _current_details.failed || _current_details.completed || _current_details.time_remaining < 0.0:
			return
		change_state.emit(ChooseYogurtState.new(_scene, _god_idx, _god_node))

func clean() -> void:
	_update_failures()

func _set_text() -> void:
	if _god_idx < 0:
		_make_off.text_box.text = "Return to the Yogurt Chamber to resume your yogurt activities."
		return
	_make_off.text_box.text = _god_node.get_desires_string(_current_details)

func _update_failures() -> void:
	for p in Player.data.god_details:
		if p.time_remaining < 0.0:
			p.failed = true

func _next_god() -> void:
	_god_idx += 1
	if _god_idx >= Player.data.gods_unlocked:
		_god_idx = -1
	if _god_node:
		_god_node.queue_free()
		_god_node = null
	if _god_idx < 0:
		_make_off.name_label.text = "Descend Olympus"
		_make_off.offer_go_prompt.toggle_visibility(true)
		_make_off.offer_go_prompt.text = "Leave"
		_current_details = null
		_set_text()
		return
	_current_details = Player.data.god_details[_god_idx]
	_make_off.offer_go_prompt.text = "Offer"
	_god_node = _GODS[_god_idx].instantiate()
	_make_off.god_spot.add_child(_god_node)
	_make_off.name_label.text = _god_node.god_name
	if _current_details.failed:
		_god_node.head.texture = _god_node.angry_head
	elif _current_details.completed:
		_god_node.head.texture = _god_node.happy_head
	_make_off.offer_go_prompt.toggle_visibility(!_current_details.completed && !_current_details.failed)
	_set_text()

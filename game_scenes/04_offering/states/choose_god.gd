class_name ChooseGodState extends OfferingGameState

const _GODS: Array[PackedScene] = [
	preload("res://game_scenes/04_offering/gods/meus.tscn")
]

var _current_details: QuestDetails

func initialize() -> void:
	_make_off.main_menu.visible = true
	_god_idx -= 1
	_next_god()

func update(_delta: float) -> void:
	_set_text()
	if Input.is_action_just_pressed("button_two"):
		_next_god()
	elif Input.is_action_pressed("button_one"):
		if _god_idx < 0:
			change_scene.emit("res://game_scenes/02_outside/outside.tscn")
			return
		if _current_details.failed || _current_details.completed:
			return
		change_state.emit(ChooseYogurtState.new(_scene, _god_idx, _god_node))

func _set_text() -> void:
	if _god_idx < 0:
		_make_off.text_box.text = "Descend Olympus\n Return to the Yogurt Chamber to resume your yogurt activities."
		return
	_make_off.text_box.text = _god_node.get_desires_string(_current_details)

func _next_god() -> void:
	_god_idx += 1
	if _god_idx >= Player.data.gods_unlocked:
		_god_idx = -1
	if _god_node:
		_god_node.queue_free()
		_god_node = null
	if _god_idx < 0:
		_make_off.offer_go_prompt.modulate.a = 1.0
		_make_off.offer_go_prompt.text = "Leave"
		# TODO: going away message
		_set_text()
		return
	_current_details = Player.data.god_details[_god_idx]
	_make_off.offer_go_prompt.text = "Offer"
	_god_node = _GODS[_god_idx].instantiate()
	_make_off.god_spot.add_child(_god_node)
	_make_off.offer_go_prompt.modulate.a  = 0.0 if _current_details.completed || _current_details.failed else 1.0
	_set_text()

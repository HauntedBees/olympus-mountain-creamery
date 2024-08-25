class_name ChooseGodState extends OfferingGameState

const _GODS: Array[PackedScene] = [
	preload("res://game_scenes/04_offering/gods/meus.tscn")
]

var _god_idx := -1
var _god_node: God

func initialize() -> void:
	_make_off.main_menu.visible = true
	_next_god()

func update(_delta: float) -> void:
	_set_text()
	if Input.is_action_just_pressed("button_two"):
		_next_god()
	elif Input.is_action_pressed("button_one"):
		if _god_idx < 0:
			change_scene.emit("res://game_scenes/02_outside/outside.tscn")
			return
		if Player.data.god_time_remaining[_god_idx] < 0.0:
			# TODO: signal failure
			return

func _set_text() -> void:
	if _god_idx < 0:
		_make_off.text_box.text = "Descend Olympus\n Return to the Yogurt Chamber to resume your yogurt activities."
		return
	_make_off.text_box.text = _god_node.get_desires_string(
		Player.data.god_progress[_god_idx],
		Player.data.god_time_remaining[_god_idx]
	)

func _next_god() -> void:
	_god_idx += 1
	if _god_idx >= Player.data.gods_unlocked:
		_god_idx = -1
	if _god_node:
		_god_node.queue_free()
	if _god_idx < 0:
		_god_node = null
		_make_off.offer_go_prompt.text = "Leave"
		# TODO: going away message
		_set_text()
		return
	_make_off.offer_go_prompt.text = "Offer"
	_god_node = _GODS[_god_idx].instantiate()
	_make_off.god_spot.add_child(_god_node)
	_set_text()

class_name ChooseYogurtState extends OfferingGameState

const _YOG_SCENE := preload("res://game_scenes/shared_nodes/framed_yog.tscn")

var _yog_idx := -1
var _curr_yog: FramedYog
var _curr_yog_info: MilkPotData
var _container: CenterContainer

func initialize() -> void:
	_container = _make_off.choice_container
	_container.visible = true
	_next_yog()

func update(_delta: float) -> void:
	_set_text()
	if Input.is_action_just_pressed("button_two"):
		_next_yog()
	elif Input.is_action_pressed("button_one"):
		if _yog_idx < 0:
			change_state.emit(ChooseGodState.new(_scene, _god_idx, _god_node))
		else:
			change_state.emit(MakeOfferState.new(_scene, _god_idx, _god_node, _curr_yog_info))

func clean() -> void:
	_container.visible = false
	_kill_yogurt()

func _next_yog() -> void:
	_yog_idx += 1
	if _yog_idx >= Player.data.yogurts.size():
		_yog_idx = -1
	_kill_yogurt()
	_make_off.no_item.visible = _yog_idx < 0
	if _yog_idx >= 0:
		_curr_yog = _YOG_SCENE.instantiate()
		_container.add_child(_curr_yog)
		_curr_yog_info = Player.data.yogurts[_yog_idx]
		_curr_yog.yog_jar.set_from_info(_curr_yog_info)
	_set_text()

func _set_text() -> void:
	if _yog_idx < 0:
		if Player.data.yogurts.size() == 0:
			_make_off.text_box.text = "It looks like you don't have any yogurt to give. Return to your Yogurt Chamber and make some more!"
		else:
			_make_off.text_box.text = "Choose a different God to offer yogurt to, or return to your Yogurt Chamber."
		_make_off.offer_go_prompt.text = "Back"
		return
	_make_off.offer_go_prompt.text = "Offer"
	var details: PackedStringArray = []
	if _curr_yog_info.fermentation_time < MilkPotData.SOUPY_LIMIT:
		details.append("This yogurt isn't quite ready yet.")
	elif _curr_yog_info.fermentation_time > MilkPotData.SOURING_SOON_LIMIT:
		details.append("This yogurt is ready to be eaten, but it's been fermenting for a while, so it might turn sour if you don't offer it soon.")
	else:
		details.append("This yogurt is ready to be eaten.")
	if _curr_yog_info.burnt_amount >= 0.8:
		details.append("The milk used to make this was very burnt.")
	elif _curr_yog_info.burnt_amount >= 0.4:
		details.append("The milk used to make this was a bit burnt.")
	if _curr_yog_info.amount < MilkPotData.SMALL_JAR_LIMIT:
		details.append("The jar isn't very full.")
	match _curr_yog_info.flavoring:
		ItemCount.Type.None: details.append("It's unflavored.")
		ItemCount.Type.Honey: details.append("It's flavored with honey.")
		ItemCount.Type.Mint: details.append("It's flavored with mint.")
		ItemCount.Type.Saffron: details.append("It's flavored with saffron.")
		ItemCount.Type.Pomegranate: details.append("There's pomegranate at the bottom..")
		ItemCount.Type.Walnut: details.append("There are walnuts stirred in.")
	_make_off.text_box.text = " ".join(details)

func _kill_yogurt() -> void:
	if _curr_yog:
		_curr_yog.queue_free()
		_curr_yog = null

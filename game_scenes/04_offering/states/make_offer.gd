class_name MakeOfferState extends OfferingGameState

var _yog_given: MilkPotData

func _init(s: GameScene, god: int, god_node: God, yogurt: MilkPotData) -> void:
	super(s, god, god_node)
	_yog_given = yogurt

func initialize() -> void:
	_make_off.next_prompt.toggle_visibility(false)
	_make_off.offer_go_prompt.text = "Next"
	_bestow_yogurt_reward()

func update(_delta: float) -> void:
	if Input.is_action_pressed("button_one"):
		change_state.emit(ChooseGodState.new(_scene, _god_idx, _god_node))

func clean() -> void:
	_make_off.next_prompt.toggle_visibility(true)

func _bestow_yogurt_reward() -> void:
	var quest := Player.data.god_details[_god_idx]
	var desire := _god_node.requirements[quest.desire_idx]
	var tb := _make_off.text_box
	if _yog_given.fermentation_time < MilkPotData.SOUPY_LIMIT:
		quest.strikes += 1
		if quest.strikes >= 3:
			quest.failed = true
			tb.text = "%s %s" % [_god_node.not_ready_message, _god_node.failed_message]
		elif quest.strikes == 2:
			tb.text = "%s %s" % [_god_node.not_ready_message, _god_node.final_warning_message]
		else:
			tb.text = _god_node.not_ready_message
		return
	if desire.is_match(_yog_given):
		quest.amount_given += 1
		var half_full := false
		if _yog_given.amount <= MilkPotData.SMALL_JAR_LIMIT:
			quest.strikes += 1
			half_full = true
		if quest.amount_given >= desire.yogurt_amount:
			var items: PackedStringArray = []
			for i in desire.reward:
				Player.data.add_item(i.type, i.amount)
				if i.type == ItemCount.Type.Milk:
					items.append("%dτ of Milk" % i.amount)
				## pomegranate is the only item that'd actually have its name pluralized; ope!
				elif i.amount != 1 && i.type == ItemCount.Type.Pomegranate:
					items.append("%d Pomegranates" % i.amount)
				else:
					items.append("%d %s" % [i.amount, ItemCount.ITEM_NAMES[i.type]])
			tb.text = "%s\nYou received: %s." % [_god_node.complete_message, ", ".join(items)]
			_advance_to_next_quest()
		elif half_full:
			if quest.strikes >= 3:
				quest.failed = true
				tb.text = "%s %s %s" % [_god_node.success_message, _god_node.not_enough_message, _god_node.failed_message]
			elif quest.strikes == 2:
				tb.text = "%s %s %s" % [_god_node.success_message, _god_node.not_enough_message, _god_node.final_warning_message]
			else:
				tb.text = "%s %s" % [_god_node.success_message, _god_node.not_enough_message]
		else:
			tb.text = _god_node.success_message
	else:
		quest.strikes += 1
		if quest.strikes >= 3:
			quest.failed = true
			tb.text = "%s %s" % [_god_node.didnt_want_message, _god_node.failed_message]
		elif quest.strikes == 2:
			tb.text = "%s %s" % [_god_node.didnt_want_message, _god_node.final_warning_message]
		else:
			tb.text = _god_node.didnt_want_message

func _advance_to_next_quest() -> void:
	Player.data.items_available_to_buy += 1
	var quest := Player.data.god_details[_god_idx]
	var next_quest := quest.desire_idx + 1
	if next_quest >= _god_node.requirements.size():
		quest.completed = true
	else:
		var desire := _god_node.requirements[next_quest]
		Player.data.god_details[_god_idx] = desire.get_quest(next_quest)

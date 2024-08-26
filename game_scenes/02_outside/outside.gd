class_name OutsideScene extends GameScene

const _JAR_SCENE := preload("res://game_scenes/shared_nodes/lil_yog.tscn")
const _JAR_SCALE := Vector2(0.5, 0.5)
const _MAX_YOGURTS_TO_SHOW := 56

@onready var _yog_prompt: ActionPrompt = %YogPrompt
@onready var _offer_prompt: ActionPrompt = %OfferPrompt
@onready var _shop_prompt: ActionPrompt = %ShopPrompt
@onready var _prompts: Array[ActionPrompt] = [_yog_prompt, _offer_prompt, _shop_prompt]
@onready var _info_label: Label = %InfoLabel
@onready var _yogurts_container: GridContainer = %Yogurts
@onready var _and_more: Label = %AndMore
@onready var _flavors: Array[ItemDisplay] = [%Honey, %Mint, %Saffron, %Pomegranate, %Walnuts]
@onready var _flavor_labels: Array[Label] = [%HoneyLabel, %MintLabel, %SaffronLabel, %PomLabel, %NutLabel]

var _active_idx := 0
var _changing := false

func _ready() -> void:
	_info_label.text = "Money: %do\nJars: %d\nMilk: %.1ft\nPot Capacity: %.1ft" % [
		Player.data.money,
		Player.data.jars,
		Player.data.milk_amount,
		Player.data.milk_pot_capacity
	]
	var count := 0
	Player.data.yogurts.sort_custom(func(a: MilkPotData, b: MilkPotData) -> bool:
		if a.fermentation_time >= MilkPotData.SOUR_LIMIT && b.fermentation_time < MilkPotData.SOUR_LIMIT:
			return false
		elif b.fermentation_time >= MilkPotData.SOUR_LIMIT && a.fermentation_time < MilkPotData.SOUR_LIMIT:
			return true
		return a.fermentation_time > b.fermentation_time
	)
	for y in Player.data.yogurts:
		count += 1
		if count > _MAX_YOGURTS_TO_SHOW:
			_and_more.visible = true
			break
		var c: LilYog = _JAR_SCENE.instantiate()
		_yogurts_container.add_child(c)
		c.bind_jar(y)
	for idx in _flavors.size():
		var flavor := _flavors[idx].item
		var item_count := Player.data.get_item_count(flavor)
		if item_count == 0:
			_flavors[idx].visible = false
		else:
			_flavor_labels[idx].text = "x%d" % item_count

func _input(event: InputEvent) -> void:
	if _changing:
		return
	if event.is_action_pressed("button_two"):
		_prompts[_active_idx].state = ActionPrompt.State.None
		_prompts[(_active_idx + 1) % 3].state = ActionPrompt.State.Selected
		_prompts[(_active_idx + 2) % 3].state = ActionPrompt.State.Next
		_active_idx = (_active_idx + 1) % 3
	elif event.is_action_pressed("button_one"):
		_changing = true
		match _active_idx:
			0: # Yogurt
				_change_scene("res://game_scenes/01_make_yog/make_yog.tscn")
			1: # Offering
				_change_scene("res://game_scenes/04_offering/offering.tscn")
			2: # Shop
				_change_scene("res://game_scenes/03_shop/shop.tscn")

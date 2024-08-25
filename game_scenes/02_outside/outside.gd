class_name OutsideScene extends GameScene

@onready var _yog_prompt: ActionPrompt = %YogPrompt
@onready var _offer_prompt: ActionPrompt = %OfferPrompt
@onready var _shop_prompt: ActionPrompt = %ShopPrompt
@onready var _prompts: Array[ActionPrompt] = [_yog_prompt, _offer_prompt, _shop_prompt]
@onready var _info_label: Label = %InfoLabel

var _active_idx := 0

func _ready() -> void:
	_info_label.text = "Money: %dὀ\nJars: %d\nMilk: %.1fτ\nPot Capacity: %.1fτ" % [
		Player.data.money,
		Player.data.milk_amount,
		Player.data.milk_pot_capacity,
		Player.data.jars
	]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("button_two"):
		_prompts[_active_idx].state = ActionPrompt.State.None
		_prompts[(_active_idx + 1) % 3].state = ActionPrompt.State.Selected
		_prompts[(_active_idx + 2) % 3].state = ActionPrompt.State.Next
		_active_idx = (_active_idx + 1) % 3
	elif event.is_action_pressed("button_one"):
		match _active_idx:
			0: # Yogurt
				_change_scene("res://game_scenes/01_make_yog/make_yog.tscn")
			1: # Offering
				pass
			2: # Shop
				pass

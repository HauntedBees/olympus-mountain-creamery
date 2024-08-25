class_name OutsideScene extends GameScene

const _JAR_SCENE := preload("res://game_scenes/01_make_yog/yog_jar.tscn")
const _JAR_SCALE := Vector2(0.5, 0.5)

@onready var _yog_prompt: ActionPrompt = %YogPrompt
@onready var _offer_prompt: ActionPrompt = %OfferPrompt
@onready var _shop_prompt: ActionPrompt = %ShopPrompt
@onready var _prompts: Array[ActionPrompt] = [_yog_prompt, _offer_prompt, _shop_prompt]
@onready var _info_label: Label = %InfoLabel
@onready var _yogurts_container: GridContainer = %Yogurts

var _active_idx := 0

func _ready() -> void:
	_info_label.text = "Money: %dὀ\nJars: %d\nMilk: %.1fτ\nPot Capacity: %.1fτ" % [
		Player.data.money,
		Player.data.milk_amount,
		Player.data.milk_pot_capacity,
		Player.data.jars
	]
	for y in Player.data.yogurts:
		var c := Control.new()
		c.custom_minimum_size = Vector2(70, 60)
		var j: YogJar = _JAR_SCENE.instantiate()
		j.scale = _JAR_SCALE
		c.add_child(j)
		_yogurts_container.add_child(c)
		j.set_from_info(y)

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

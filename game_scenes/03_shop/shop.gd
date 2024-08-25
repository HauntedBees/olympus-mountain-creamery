class_name ShopScene extends GameScene

@onready var _items: Array[ItemDisplay] = [%None, %Milk, %Jars, %Honey, %Mint, %Saffron, %Pomegranate, %Walnuts, %PotUpgrade, %SpoonUpgrade]
@onready var _item_desc: Label = %ItemDesc
@onready var _money_label: Label = %MoneyLabel

var _idx := 1
var _changing := false

func _ready() -> void:
	_change_idx(_idx)
	_update_money_label()

func _process(_delta: float) -> void:
	if _changing:
		return
	if Input.is_action_just_pressed("button_two"):
		var next_idx := _idx
		while _idx == next_idx || !_items[next_idx].visible:
			next_idx = (next_idx + 1) % _items.size()
		_change_idx(next_idx)
	elif Input.is_action_just_pressed("button_one"):
		_try_buy_item()

func _update_money_label() -> void:
	_money_label.text = "You have %d ὀbolus." % Player.data.money

func _try_buy_item() -> void:
	var item := _items[_idx].item
	if item == ItemCount.Type.None:
		_changing = true
		_change_scene("res://game_scenes/02_outside/outside.tscn")
		return
	var cost: int = ItemCount.ITEM_COSTS[item]
	if cost > Player.data.money:
		# TODO: signal lack of monies
		return
	Player.data.money -= cost
	Player.data.add_item(item, 1)
	_change_idx(_idx)
	_update_money_label()

func _change_idx(idx: int) -> void:
	_items[_idx].selected = false
	_idx = idx
	_items[_idx].selected = true
	var item := _items[_idx].item
	if item == ItemCount.Type.None:
		_item_desc.text = "%s\n%s" % [ItemCount.ITEM_NAMES[item], ItemCount.ITEM_DESCRIPTIONS[item]]
	else:
		var count := Player.data.get_item_count(item)
		var you_have_string := "You have %d" % count
		match item:
			ItemCount.Type.Milk: you_have_string = "You have %.1fτ" % count
			ItemCount.Type.PotUpgrade: you_have_string = "Current capacity is %.1fτ" % count
			ItemCount.Type.SpoonUpgrade: you_have_string = "Current power is %.1f" % count
		_item_desc.text = "%s (%dὀ)\n%s.\n%s" % [
			ItemCount.ITEM_NAMES[item], 
			ItemCount.ITEM_COSTS[item],
			you_have_string,
			ItemCount.ITEM_DESCRIPTIONS[item]
		]

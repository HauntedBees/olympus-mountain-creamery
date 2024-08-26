class_name ShopScene extends GameScene

const _WELCOME_MESSAGES: Array[String] = [
	"Welcome! Please feel free to spend as much money as you want here!",
	"Hello! I sell yogurt accessories. But not yogurt, that's your job!",
	"Got a lot of good things on sale, stranger!",
	"I've got a special sale today! Every purchase comes with a free thumbs up and a smile!",
	"Greetings and welcome to my humble shop.",
	"If you make the Gods happy, I'll be able to sell more stuff! So make 'em happy!"
]
const _NO_MONEY_MESSAGES: Array[String] = [
	"Sorry, you don't have enough money for that.",
	"Oops! Looks like you can't afford that right now!",
	"Hey, what're you trying to pull here? Come back when you have more money.",
	"Thank you for- hey, wait! That's not enough money!"
]
const _PURCHASE_MESSAGES: Array[String] = [
	"Thanks much!",
	"Thank you! Take good care of that!",
	"Thank you dairy much! Get it? Because we're in a yogurt video game.",
	"Thank you for your patronage!",
	"Your money is always welcome here!",
	"Don't forget: buy one, get one for full price!"
]

@onready var _items: Array[ItemDisplay] = [%None, %Milk, %Jars, %Honey, %Mint, %PotUpgrade, %Saffron, %Pomegranate, %SpoonUpgrade, %Walnuts]
@onready var _item_desc: Label = %ItemDesc
@onready var _money_label: Label = %MoneyLabel
@onready var _item_list: GridContainer = %ItemList
@onready var _buy_button: VertPrompt = %BuyButton
@onready var _speech: Label = %Speech

var _idx := 1
var _changing := false

func _ready() -> void:
	_speech.text = _WELCOME_MESSAGES.pick_random()
	_change_idx(_idx)
	_update_money_label()
	for idx in _items.size():
		_items[idx].visible = idx <= Player.data.items_available_to_buy
	_item_list.columns = 5 if Player.data.items_available_to_buy > 7 else 8

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
		_speech.text = _NO_MONEY_MESSAGES.pick_random()
		return
	_speech.text = _PURCHASE_MESSAGES.pick_random()
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
		_buy_button.text = "Leave"
	else:
		_buy_button.text = "Buy"
		var count := Player.data.get_item_count(item)
		var you_have_string := "You have %d" % count
		match item:
			ItemCount.Type.Money: you_have_string = "You have %dὀ" % count
			ItemCount.Type.Milk: you_have_string = "You have %.1fτ" % count
			ItemCount.Type.PotUpgrade: you_have_string = "Current capacity is %.1fτ" % count
			ItemCount.Type.SpoonUpgrade: you_have_string = "Current power is %.1f" % count
		_item_desc.text = "%s (%dὀ)\n%s.\n%s" % [
			ItemCount.ITEM_NAMES[item], 
			ItemCount.ITEM_COSTS[item],
			you_have_string,
			ItemCount.ITEM_DESCRIPTIONS[item]
		]

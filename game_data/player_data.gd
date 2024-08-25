class_name PlayerData extends Resource

const JAR_CAPACITY := 5.0

## Number of Gods available to be offered yogurt.
@export var gods_unlocked := 1

## Progress on each God's yogurt-desiring quests.
@export var god_details: Array[QuestDetails] = [QuestDetails.new()]

## How much milk the player has.
@export var milk_amount := 30.0

## It's money.
@export var money := 20

## How much milk fits in the player's pot.
@export var milk_pot_capacity := 15.0

## The number of jars available for yogurt-filling.
@export var jars := 10

## How much strength the player has in their arm.
@export var arm_energy := 5.0

## Amount of arm energy recovered per second.
@export var arm_recovery_rate := 0.5

## The items the player can buy. More are unlocked with each successful quest completed.
@export var items_available_to_buy := 3

## The player's actively fermenting yogurt jars.
@export var yogurts: Array[MilkPotData] = []

## The non-dairy non-container items the player has.
@export var inventory: Array[ItemCount] = [
	ItemCount.new(ItemCount.Type.Honey, 3)
]

func _init() -> void:
	for i in 5:
		var m := MilkPotData.new()
		m.amount = randf_range(JAR_CAPACITY * 0.6, JAR_CAPACITY * 0.8)
		m.fermentation_time = randf()
		yogurts.append(m)

func get_item_count(i: ItemCount.Type) -> float:
	match i:
		ItemCount.Type.Milk: return milk_amount
		ItemCount.Type.Jars: return jars
		ItemCount.Type.PotUpgrade: return milk_pot_capacity
		ItemCount.Type.SpoonUpgrade: return arm_energy
		ItemCount.Type.Money: return money
	for item in inventory:
		if item.type == i:
			return item.amount
	return 0

func add_item(item: ItemCount.Type, amount: int) -> void:
	match item:
		ItemCount.Type.Money:
			money += amount
		ItemCount.Type.Milk: 
			milk_amount += 20.0 * amount
			return
		ItemCount.Type.Jars:
			jars += 5 * amount
			return
		ItemCount.Type.PotUpgrade:
			milk_pot_capacity += 10.0 * amount
			return
		ItemCount.Type.SpoonUpgrade:
			arm_energy += 1.5 * amount
			return
	for i in inventory:
		if i.type == item:
			i.amount += amount
			return
	inventory.append(ItemCount.new(item, amount))

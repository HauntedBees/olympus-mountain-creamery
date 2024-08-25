class_name ItemCount extends Resource

## The diffent items, in enum form because this is for a three-day solo game jam.
enum Type {
	## For the sake of simplifying some logic, "None" is an item. Trust me it makes sense.
	None,
	## Sweet, Rich
	Honey,
	## Refreshing, Savory
	Mint,
	## Luxurious, Earthy, Floral
	Saffron,
	## Fruity, Rich, Floral
	Pomegranate,
	## Bitter, Earthy, Savory
	Walnut,
	## More Jars
	Jars,
	## Size increase for Pot
	PotUpgrade,
	## Stirring increase for Spoon
	SpoonUpgrade,
	## It's milk
	Milk
}

const ITEM_NAMES := {
	Type.None: "Exit",
	Type.Honey: "Honey",
	Type.Mint: "Mint",
	Type.Saffron: "Saffron",
	Type.Pomegranate: "Pomegranate",
	Type.Walnut: "Walnuts",
	Type.Jars: "Five Yogurt Jars",
	Type.PotUpgrade: "Bigger Pot",
	Type.SpoonUpgrade: "Sturdier Spoon",
	Type.Milk: "20τ of Milk"
}
const ITEM_COSTS := {
	Type.None: 0,
	Type.Honey: 10,
	Type.Mint: 15,
	Type.Saffron: 50,
	Type.Pomegranate: 20,
	Type.Walnut: 30,
	Type.Jars: 5,
	Type.PotUpgrade: 30,
	Type.SpoonUpgrade: 30,
	Type.Milk: 10
}
const ITEM_DESCRIPTIONS := {
	Type.None: "Leave the Shop and return to your Yogurt Chamber.",
	Type.Honey: "Rich and Sweet. The food of the Gods.",
	Type.Mint: "Refreshing and Savory. For nice flavor AND nice breath afterwards.",
	Type.Saffron: "Luxurious, Earthy, and Floral. Worth way more than its weight in gold.",
	Type.Pomegranate: "Fruity, Rich, and Floral. Hard to eat, but well worth the effort.",
	Type.Walnut: "Bitter, Earthy, and Savory. Tough nuts to crack. Like most nuts. Hence the expression.",
	Type.Jars: "Five more Jars to fill with yogurt.",
	Type.PotUpgrade: "Increase the amount of milk you can pour in your preparation pot by 10τ.",
	Type.SpoonUpgrade: "A sturdier spoon that you can stir more easily without getting tired.",
	Type.Milk: "20τ of milk, for yogurt-making purposes."
}

## What the item is.
@export var type: Type

## How much of it the player has.
@export var amount: int

func _init(t: Type, a := 1) -> void:
	type = t
	amount = a

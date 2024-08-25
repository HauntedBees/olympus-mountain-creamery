class_name ItemCount extends Resource

## The diffent items, in enum form because this is for a three-day solo game jam.
enum Type {
	## Sweet, Rich
	Honey,
	## Refreshing, Savory
	Mint,
	## Luxurious, Earthy, Floral
	Saffron,
	## Fruity, Rich, Floral
	Pomegranate,
	## Bitter, Earthy, Savory
	Walnut
}

const ITEM_DESCRIPTIONS := {
	Type.Honey: "Rich and Sweet. The food of the Gods.",
	Type.Mint: "Refreshing and Savory. For nice flavor AND nice breath afterwards.",
	Type.Saffron: "Luxurious, Earthy, and Floral. Worth way more than its weight in gold.",
	Type.Pomegranate: "Fruity, Rich, and Floral. Hard to eat, but well worth the effort.",
	Type.Walnut: "Bitter, Earthy, and Savory. Tough nuts to crack. Like most nuts. Hence the expression."
}

## What the item is.
@export var type: Type

## How much of it the player has.
@export var amount: int

func _init(t: Type, a := 1) -> void:
	type = t
	amount = a

class_name Desire extends Resource

enum Flavor { Any, Sweet, Rich, Refreshing, Savory, Luxurious, Earthy, Floral, Fruity, Bitter, Sour, Quality }

## The amount of yogurts they want.
@export var yogurt_amount := 1

## The flavor they want for these yogurts.
@export var flavor := Flavor.Any

## Minutes until the mission is failed.
@export var time_limit := 3600.0

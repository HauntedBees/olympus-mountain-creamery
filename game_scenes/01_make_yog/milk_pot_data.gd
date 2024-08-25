class_name MilkPotData extends RefCounted

## The amount of milk is in the pot.
@export var amount := 0.0

## How burn the milk is.
@export_range(0.0, 1.0) var burnt_amount := 0.0

## Lower when the temperature is still too high when adding bacteria.
@export_range(0.0, 1.0) var bacteria_amount := 1.0

## Lower when the temperature is too low when adding bacteria.
@export_range(0.3, 1.0) var fermentation_time_multiplier := 1.0

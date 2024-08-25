class_name MilkPotData extends Resource

const _MINUTE := 60.0
const SOUPY_LIMIT := 2.0 * _MINUTE
const SOURING_SOON_LIMIT := 8.0 * _MINUTE
const SOUR_LIMIT := 10.0 * _MINUTE
const SMALL_JAR_LIMIT := 2.75

## The amount of milk is in the pot.
@export var amount := 0.0

## How burn the milk is.
@export_range(0.0, 1.0) var burnt_amount := 0.0

## Lower when the temperature is still too high when adding bacteria.
@export_range(0.0, 1.0) var bacteria_amount := 1.0

## Lower when the temperature is too low when adding bacteria.
@export_range(0.3, 1.0) var fermentation_time_diminisher := 1.0

## Increased by quality of pours and other factors.
@export var quality_multiplier := 1.0

## Measured in seconds. From 2 to 10 minutes is good. Anything higher is too sour.
@export_range(0.0, 660.0) var fermentation_time := 0.0

## Flavoring added to the yogurt.
@export var flavoring := ItemCount.Type.None

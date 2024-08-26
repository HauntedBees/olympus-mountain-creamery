## Options related to sound, accessibility, etc.
class_name PlayerOptions extends Resource

## The multiplier applied to various in-game actions. Lower numbers make actions slower/easier.
@export var speed_multiplier := 1.0

## For a more casual experience.
@export var no_time_limits := false

## Converts "press and hold" buttons to "tap to turn on, tap to turn off" buttons.
@export var use_toggles := false

## Below aren't actually implemented yet #oops.

## Keyboard key for the first button.
@export var key_one := KEY_Z
## Keyboard key for the second button.
@export var key_two := KEY_X

## Gamepad button for the first button.
@export var gamepad_one := JOY_BUTTON_A
## Gamepad button for the second button.
@export var gamepad_two := JOY_BUTTON_B

## When true, the player can pour milk in multiple button presses instead of one.
@export var multiple_milk_pours := false

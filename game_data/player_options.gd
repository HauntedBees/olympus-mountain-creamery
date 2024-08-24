## Options related to sound, accessibility, etc.
class_name PlayerOptions extends Resource

## The multiplier applied to various in-game actions.
@export var speed_multiplier := 1.0

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

## Options related to sound, accessibility, etc.
class_name PlayerOptions extends Resource

## The multiplier applied to various in-game actions. Lower numbers make actions slower/easier.
@export var speed_multiplier := 1.0

## For a more casual experience.
@export var no_time_limits := false

## Converts "press and hold" buttons to "tap to turn on, tap to turn off" buttons.
@export var use_toggles := false

## When true, the player can pour milk in multiple button presses instead of one.
@export var multiple_milk_pours := false

## Remappable controls aren't actually implemented yet #oops.

## Keyboard key for the first button.
@export var key_one := KEY_Z
## Keyboard key for the second button.
@export var key_two := KEY_X

## Gamepad button for the first button.
@export var gamepad_one := JOY_BUTTON_A
## Gamepad button for the second button.
@export var gamepad_two := JOY_BUTTON_B

func get_gamepad_display(i: InputEventJoypadButton) -> String:
	match i.button_index:
		JOY_BUTTON_A: return "A"
		JOY_BUTTON_B: return "B"
		JOY_BUTTON_X: return "X"
		JOY_BUTTON_Y: return "Y"
		JOY_BUTTON_LEFT_SHOULDER: return "L"
		JOY_BUTTON_RIGHT_SHOULDER: return "R"
		JOY_BUTTON_LEFT_STICK: return "LS"
		JOY_BUTTON_RIGHT_STICK: return "RS"
		JOY_BUTTON_DPAD_UP: return "^"
		JOY_BUTTON_DPAD_DOWN: return "v"
		JOY_BUTTON_DPAD_LEFT: return "<"
		JOY_BUTTON_DPAD_RIGHT: return ">"
		JOY_BUTTON_BACK: return "s"
		JOY_BUTTON_START: return "S"
	return "?"

@tool
class_name ActionPrompt extends NinePatchRect

enum State { Selected, Next, None }

@export var text := "":
	set(value):
		text = value
		if !is_inside_tree():
			await ready
		_label.text = text

@export var state := State.None:
	set(value):
		state = value
		_set_input_display()

@onready var _label: Label = %Label
@onready var _selected: TextureRect = %Selected
@onready var _prompt_text: Label = %PromptText

func _ready() -> void:
	Player.input_method_changed.connect(_set_input_display)
	_set_input_display()

func _set_input_display() -> void:
	if !is_inside_tree():
		await ready
	_selected.visible = state == State.Selected
	if state == State.None:
		_prompt_text.text = ""
	else:
		var inputs := InputMap.action_get_events("button_one" if state == State.Selected else "button_two")
		var found := false
		for i in inputs:
			if i is InputEventKey && !Player.last_input_was_gamepad:
				_set_keyboard_display(i)
				found = true
				break
			elif i is InputEventJoypadButton && Player.last_input_was_gamepad:
				_set_gamepad_display(i)
				found = true
				break
		if !found:
			_prompt_text.text = "O" if state == State.Selected else ">"

func _set_keyboard_display(i: InputEventKey) -> void:
	_prompt_text.text = OS.get_keycode_string(i.physical_keycode)

func _set_gamepad_display(i: InputEventJoypadButton) -> void:
	match i.button_index:
		JOY_BUTTON_A: _prompt_text.text = "A"
		JOY_BUTTON_B: _prompt_text.text = "B"
		JOY_BUTTON_X: _prompt_text.text = "X"
		JOY_BUTTON_Y: _prompt_text.text = "Y"
		JOY_BUTTON_LEFT_SHOULDER: _prompt_text.text = "L"
		JOY_BUTTON_RIGHT_SHOULDER: _prompt_text.text = "R"
		JOY_BUTTON_LEFT_STICK: _prompt_text.text = "LS"
		JOY_BUTTON_RIGHT_STICK: _prompt_text.text = "RS"

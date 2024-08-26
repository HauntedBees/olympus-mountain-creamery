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
	_prompt_text.text = Player.options.get_gamepad_display(i)

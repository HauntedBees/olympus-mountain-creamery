class_name TitleScreen extends GameScene

enum State { Main, Intro, Options, RemapPrimary, RemapSecondary }

var _timer := 0.125
var _option_idx := 0
var _step := State.Main

@onready var _main_menu: VBoxContainer = %MainMenu
@onready var _intro_menu: HBoxContainer = %IntroMenu
@onready var _options_menu: VBoxContainer = %OptionsMenu
@onready var _options: Array[ActionPrompt] = [%Toggle, %Speed, %Timer, %MultiPour, %RemapPrimary, %RemapSecondary, %Return]
@onready var _remap_dialog: Control = %Remap
@onready var _remap_text: Label = %RemapText
@onready var _option_info: Label = %OptionInfo

func _process(delta: float) -> void:
	_timer -= delta
	if _timer > 0.0:
		return
	if _step == State.RemapPrimary || _step == State.RemapSecondary:
		return
	if Input.is_action_just_pressed("button_one"):
		if _step == State.Main:
			_step = State.Intro
			_main_menu.visible = false
			_intro_menu.visible = true
		elif _step == State.Intro:
			_change_scene("res://game_scenes/01_make_yog/make_yog.tscn")
		elif _step == State.Options:
			_option_press()
	elif Input.is_action_just_pressed("button_two"):
		if _step == State.Main:
			_step = State.Options
			_main_menu.visible = false
			_options_menu.visible = true
			_option_idx = 0
			_update_options()
		elif _step == State.Options:
			_option_idx = (_option_idx + 1) % _options.size()
			_update_options()

func _input(event: InputEvent) -> void:
	if _timer > 0.0:
		return
	if _step != State.RemapPrimary && _step != State.RemapSecondary:
		return
	if event is InputEventKey && Player.last_input_was_gamepad:
		return
	elif event is InputEventJoypadButton && !Player.last_input_was_gamepad:
		return
	GASInput.remap_action("button_one" if _step == State.RemapPrimary else "button_two", event)
	Player.input_method_changed.emit()
	_step = State.Options
	_remap_dialog.visible = false

func _option_press() -> void:
	match _option_idx:
		0: # Toggle
			Player.options.use_toggles = !Player.options.use_toggles
			_options[0].text = "Push to Toggle: %s" % ("On" if Player.options.use_toggles else "Off")
		1: # Speed
			if is_equal_approx(Player.options.speed_multiplier, 1.0):
				Player.options.speed_multiplier = 0.75
				_options[1].text = "Speed: Slow"
			elif is_equal_approx(Player.options.speed_multiplier, 0.75):
				Player.options.speed_multiplier = 0.4
				_options[1].text = "Speed: Slowest"
			elif is_equal_approx(Player.options.speed_multiplier, 0.4):
				Player.options.speed_multiplier = 2.5
				_options[1].text = "Speed: Fast"
			else:
				Player.options.speed_multiplier = 1.0
				_options[1].text = "Speed: Normal"
		2: # Timer
			Player.options.no_time_limits = !Player.options.no_time_limits
			_options[2].text = "Time Limits: %s" % ("Off" if Player.options.no_time_limits else "On")
		3: # Multipour
			Player.options.multiple_milk_pours = !Player.options.multiple_milk_pours
			_options[3].text = "Multi-Pour: %s" % ("On" if Player.options.multiple_milk_pours else "Off")
		4: # Remap Primary
			_step = State.RemapPrimary
			_remap_dialog.visible = true
			_timer = 0.25
			if Player.last_input_was_gamepad:
				_remap_text.text = "Press any button on your gamepad to remap the Primary Button to the new button."
			else:
				_remap_text.text = "Press any key on your keyboard to remap the Primary Button to the new key."
		5: # Remap Secondary
			_step = State.RemapSecondary
			_remap_dialog.visible = true
			_timer = 0.25
			if Player.last_input_was_gamepad:
				_remap_text.text = "Press any button on your gamepad to remap the Secondary Button to the new button."
			else:
				_remap_text.text = "Press any key on your keyboard to remap the Secondary Button to the new key."
		6: # Return
			_step = State.Main
			_main_menu.visible = true
			_options_menu.visible = false

func _update_options() -> void:
	for idx in _options.size():
		var next_idx := (idx - 1 + _options.size()) % _options.size()
		var o := _options[idx]
		if idx == _option_idx:
			o.state = ActionPrompt.State.Selected
		elif next_idx == _option_idx:
			o.state = ActionPrompt.State.Next
		else:
			o.state = ActionPrompt.State.None
	match _option_idx:
		0: _option_info.text = "Sometimes you'll need to hold down a Button to perform an action. \"Push to Toggle\" lets you press the Button to start and stop the action instead."
		1: _option_info.text = "Set the speed for various in-game actions, like how fast milk is poured. Higher speeds are more difficult."
		2: _option_info.text = "When enabled, you will have to complete the Gods' requests in a certain amount of time or else you'll fail."
		3: _option_info.text = "By default, you must hold the Primary Button to pour liquids, and you'll stop once you release. \"Multi-Pour\" lets you start & stop pouring multiple times."
		4: _option_info.text = "Remap the Primary Button, which defaults to the Z key on a QWERTY keyboard and the A button on a standard PC gamepad."
		5: _option_info.text = "Remap the Secondary Button, which defaults to the X key on a QWERTY keyboard and the B button on a standard PC gamepad."
		6: _option_info.text = "Save your changes and return to the title screen so you can get your yogurt journey started!"

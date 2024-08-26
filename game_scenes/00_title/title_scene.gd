class_name TitleScreen extends GameScene

enum State { Main, Intro, Options }

var _timer := 0.5
var _option_idx := 0
var _step := State.Main

@onready var _main_menu: VBoxContainer = %MainMenu
@onready var _intro_menu: HBoxContainer = %IntroMenu
@onready var _options_menu: VBoxContainer = %OptionsMenu
@onready var _options: Array[ActionPrompt] = [%Toggle, %Speed, %Timer, %MultiPour, %Return]

func _process(delta: float) -> void:
	_timer -= delta
	if _timer > 0.0:
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
		4: # Return
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

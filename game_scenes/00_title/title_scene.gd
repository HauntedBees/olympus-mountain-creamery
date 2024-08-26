class_name TitleScreen extends GameScene

enum State { Main, Intro, Options }

var _timer := 0.5
var _step := State.Main

@onready var _main_menu: VBoxContainer = %MainMenu
@onready var _intro_menu: HBoxContainer = %IntroMenu

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

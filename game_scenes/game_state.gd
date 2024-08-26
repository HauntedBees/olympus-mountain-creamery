class_name GameState extends RefCounted

@warning_ignore("unused_signal")
signal change_state(s: GameState)
@warning_ignore("unused_signal")
signal change_scene(path: String)

var input_blocked := false

var _scene: GameScene

func _init(s: GameScene) -> void:
	_scene = s

func initialize() -> void: pass
func update(_d: float) -> void: pass
func clean() -> void: pass

func _toggle_action_hold(action: String, is_toggle: bool) -> void:
	if !Player.options.use_toggles:
		return
	GASInput.set_toggle_action(action, is_toggle)

class_name GameState extends RefCounted

@warning_ignore("unused_signal")
signal change_state(s: GameState)
signal change_scene(path: String)

var input_blocked := false

var _scene: GameScene

func _init(s: GameScene) -> void:
	_scene = s

func initialize() -> void: pass
func update(_d: float) -> void: pass
func clean() -> void: pass

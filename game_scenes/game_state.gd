class_name GameState extends RefCounted

@warning_ignore("unused_signal")
signal change_state(s: GameState)

var input_blocked := false

var _scene: GameScene

func _init(s: GameScene) -> void:
	_scene = s

func update(_d: float) -> void:
	pass

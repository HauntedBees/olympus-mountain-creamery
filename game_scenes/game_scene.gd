class_name GameScene extends Control

@warning_ignore("unused_private_class_variable")
var _state: GameState

func _process(delta: float) -> void:
	if !_state.input_blocked:
		_state.update(delta)

class_name EndScene extends GameScene

var _timer := 3.0

func _process(delta: float) -> void:
	_timer -= delta
	if _timer > 0.0:
		return
	if Input.is_action_just_pressed("button_one"):
		_change_scene("")

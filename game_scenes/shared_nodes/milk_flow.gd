@tool
extends TextureRect

const _SIZE := Vector2(270, 234)
const _TIME_PER_FRAME := 0.0625

var _time := _TIME_PER_FRAME
var _frame := 0

@onready var _tex: AtlasTexture = texture

func _process(delta: float) -> void:
	_time -= delta
	if _time <= 0:
		_time += _TIME_PER_FRAME
		_frame = (_frame + 1) % 5
		var offset := Vector2.ZERO
		match _frame:
			1: offset = Vector2(1, 0)
			2: offset = Vector2(2, 0)
			3: offset = Vector2(0, 1)
			4: offset = Vector2(1, 1)
		_tex.region.position = _SIZE * offset

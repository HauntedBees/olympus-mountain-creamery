class_name HeatMilkState extends MakeYogGameState

const _STIR_RATE := 0.75

var _spoon: PathFollow2D

func initialize() -> void:
	_make_yog.fire.visible = true
	_spoon = _make_yog.boil_pot.spoon_path
	_spoon.visible = true

func update(delta: float) -> void:
	if Input.is_action_pressed("button_one"):
		_spoon.progress_ratio += delta * _STIR_RATE
		return

func clean() -> void:
	_make_yog.fire.visible = false
	_spoon.visible = false

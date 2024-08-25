class_name GameScene extends Control

const _TRANSITION_TIME := 0.5

var _state: GameState

@onready var _transition: ColorRect = %Transition

func _process(delta: float) -> void:
	if !_state:
		return
	if !_state.input_blocked:
		_state.update(delta)

func start() -> void:
	_transition.color.a = 1.0
	var t := create_tween()
	t.tween_property(_transition, "color:a", 0.0, _TRANSITION_TIME)

func _change_state(new_state: GameState) -> void:
	var t := create_tween()
	if _state:
		t.tween_property(_transition, "color:a", 1.0, _TRANSITION_TIME)
	t.tween_callback(func() -> void:
		if _state:
			_state.clean()
		_state = new_state
		_state.initialize()
		_state.change_scene.connect(_change_scene)
		_state.change_state.connect(_change_state)
	)
	t.tween_property(_transition, "color:a", 0.0, _TRANSITION_TIME)

func _change_scene(path: String) -> void:
	var t := create_tween()
	t.tween_property(_transition, "color:a", 1.0, _TRANSITION_TIME)
	t.tween_callback(func() -> void:
		var scene: PackedScene = load(path)
		var instance: GameScene = scene.instantiate()
		get_tree().root.add_child(instance)
		instance.start()
		queue_free()
	)

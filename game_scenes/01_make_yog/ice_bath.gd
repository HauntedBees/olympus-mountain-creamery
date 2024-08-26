@tool
class_name IceBath extends Control

const _ICE_SCENE := preload("res://game_scenes/01_make_yog/ice.tscn")
const _MAX_ICE := 200

@export var ice_amount := 0:
	set(value):
		ice_amount = mini(value, _MAX_ICE)
		if is_inside_tree():
			_update_ices()

var _ices: Array[AnimatedSprite2D] = []

func _update_ices() -> void:
	if ice_amount < _ices.size():
		for i in range(ice_amount, _ices.size()):
			_ices[i].queue_free()
		_ices.resize(ice_amount)
		return
	var to_add := ice_amount - _ices.size()
	for i in to_add:
		var ice: AnimatedSprite2D = _ICE_SCENE.instantiate()
		ice.frame = randi() % ice.sprite_frames.get_frame_count("default")
		add_child(ice)
		ice.rotation = randf_range(0.0, TAU)
		ice.position = Vector2(
			randf_range(0.0, size.x),
			randf_range(0.0, size.y)
		)
		_ices.append(ice)

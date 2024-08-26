class_name PourHands extends TextureRect

const _MILK_POUR_ANIMATION_TIME := 0.0625

var pouring := false:
	set(value):
		pouring = value
		if !is_inside_tree():
			await ready
		var t := create_tween()
		t.tween_property(self, "rotation_degrees", -38.0 if pouring else 0.0, _MILK_POUR_ANIMATION_TIME)

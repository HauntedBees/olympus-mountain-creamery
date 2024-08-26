@tool
class_name ItemDisplay extends TextureRect

const _SELECTED_TEXTURE := preload("res://assets/other/kenney/panel_brown_arrows.png")
const _STANDARD_TEXTURE := preload("res://assets/other/kenney/panel_brown_corners_a.png")
const _OFFSET := Vector2(64.0, 64.0)

@export var item: ItemCount.Type:
	set(value):
		item = value
		_update_icon()
@export var selected: bool:
	set(value):
		selected = value
		if !is_inside_tree():
			await ready
		texture = _SELECTED_TEXTURE if selected else _STANDARD_TEXTURE

@onready var _image: TextureRect = %IconImage
@onready var _tex := _image.texture as AtlasTexture

func _update_icon() -> void:
	if !is_inside_tree():
		await ready
	var offset := Vector2.ZERO
	match item:
		ItemCount.Type.Honey: offset = Vector2.ZERO
		ItemCount.Type.Mint: offset = Vector2(1.0, 0.0)
		ItemCount.Type.Saffron: offset = Vector2(2.0, 0.0)
		ItemCount.Type.Pomegranate: offset = Vector2(3.0, 0.0)
		ItemCount.Type.Walnut: offset = Vector2(0.0, 1.0)
		ItemCount.Type.PotUpgrade: offset = Vector2(1.0, 1.0)
		ItemCount.Type.SpoonUpgrade: offset = Vector2(2.0, 1.0)
		ItemCount.Type.Jars: offset = Vector2(3.0, 1.0)
		ItemCount.Type.Milk: offset = Vector2(0.0, 2.0)
		ItemCount.Type.None: offset = Vector2(1.0, 2.0)
	_tex.region.position = _OFFSET * offset

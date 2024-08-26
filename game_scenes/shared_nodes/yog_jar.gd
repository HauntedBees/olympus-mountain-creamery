@tool
class_name YogJar extends Control

const _BURN_COLOR := Color("#501500")

@export var max_milk_y := 310.0

@export_range(0.0, 1.0) var fill_percent := 0.0:
	set(value):
		fill_percent = value
		_update_milk_pos()

@export_range(0.0, 1.0) var burn_amount := 0.0:
	set(value):
		burn_amount = value
		_update_milk_burn()

@export var flavor := ItemCount.Type.None:
	set(value):
		flavor = value
		_update_flavor()

var _milk_gradient: Gradient

@onready var _milk: VBoxContainer = %Milk
@onready var _milk_base: TextureRect = %MilkBase
@onready var _flavor_base: ColorRect = %Flavor

func _ready() -> void:
	var grad_tex := _milk_base.texture as GradientTexture2D
	var grad := grad_tex.gradient
	_milk_gradient = grad.duplicate()
	grad_tex.gradient = _milk_gradient
	_update_flavor()

func set_from_info(p: MilkPotData) -> void:
	fill_percent = p.amount / PlayerData.JAR_CAPACITY
	burn_amount = p.burnt_amount
	flavor = p.flavoring

func _update_milk_pos() -> void:
	if !is_inside_tree():
		await ready
	_milk.position.y = (1.0 - fill_percent) * max_milk_y

func _update_flavor() -> void:
	if !is_inside_tree():
		await ready
	if flavor == ItemCount.Type.None:
		_flavor_base.visible = false
		return
	_flavor_base.visible = true
	_flavor_base.color = ItemCount.ITEM_COLORS[flavor]

func _update_milk_burn() -> void:
	if !is_inside_tree():
		await ready
	_milk_gradient.colors[0] = Color.WHITE.lerp(_BURN_COLOR, burn_amount)

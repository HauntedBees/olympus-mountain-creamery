@tool
extends Control

@export var back_texture: Texture2D:
	set(value):
		back_texture = value
		if !is_inside_tree():
			await ready
		_back.texture = back_texture

@export var glow_1_texture: Texture2D:
	set(value):
		glow_1_texture = value
		if !is_inside_tree():
			await ready
		_glow_1.texture = glow_1_texture

@export var glow_2_texture: Texture2D:
	set(value):
		glow_2_texture = value
		if !is_inside_tree():
			await ready
		_glow_2.texture = glow_2_texture

@export var glow_1_speed: float:
	set(value):
		glow_1_speed = value
		if !is_inside_tree():
			await ready
		_glow_1_mat.set_shader_parameter("milk_speed", glow_1_speed)

@export var glow_2_speed: float:
	set(value):
		glow_2_speed = value
		if !is_inside_tree():
			await ready
		_glow_2_mat.set_shader_parameter("milk_speed", glow_2_speed)

@onready var _back: TextureRect = %Back
@onready var _glow_1: TextureRect = %Glow1
@onready var _glow_2: TextureRect = %Glow2
@onready var _glow_1_mat: ShaderMaterial = _glow_1.material
@onready var _glow_2_mat: ShaderMaterial = _glow_2.material

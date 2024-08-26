class_name God extends Control

@export var base_head: Texture2D
@export var happy_head: Texture2D
@export var angry_head: Texture2D
@export var requirements: Array[Desire] = []
@export var god_name := "Bob"
@export_multiline var success_message := "This is exactly what I wanted, thank you! Bring me %d more and I'll reward you!"
@export_multiline var complete_message := "Thank you! Now please take this reward!"
@export_multiline var not_ready_message := "This isn't yogurt! This is slightly curdled milk! Make sure your yogurt ferments before serving it!"
@export_multiline var not_enough_message := "This jar was barely full though, make sure you fill the jar better next time!"
@export_multiline var didnt_want_message := "This isn't what I wanted."
@export_multiline var final_warning_message := "Don't fail me again!"
@export_multiline var failed_message := "Your yogurt is not welcome here anymore!"

@onready var head: TextureRect = %Head

func get_desires_string(d: QuestDetails) -> String:
	if d.completed:
		return "You are my hero."
	if d.failed:
		return "You failed."
	var desire := requirements[d.desire_idx]
	return "I want %d yogurts in %.0f seconds." % [desire.yogurt_amount - d.amount_given, _time_string(d.time_remaining)]

func _time_string(time: float) -> String:
	if time > 60.0:
		return "%d minutes" % roundi(time / 60.0)
	elif time == 1.0:
		return "%d second" % roundi(time)
	elif time > 0.0:
		return "%d seconds" % roundi(time)
	else:
		return "0 seconds"

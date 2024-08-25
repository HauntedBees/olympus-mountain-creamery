class_name QuestDetails extends Resource

## The amount of yogurt the player has already given for this quest.
@export var amount_given := 0

## The desire index for the God's desire.
@export var desire_idx := 0

## The time the player has left to complete this quest.
@export var time_remaining := 3600.0

## Three and you fail the God permanently.
@export var strikes := 0

## Whether the God has given up on you.
@export var failed := false

extends Area2D

var activated := false

@export var player : CharacterBody2D

func _input(event: InputEvent) -> void:
	if player in get_overlapping_bodies() and event.is_action_pressed("activate") and !activated:
		player.speed += 100
		activated = true

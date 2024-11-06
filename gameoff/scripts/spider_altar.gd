extends Area2D

var activated := false

@onready var directions: Label = $Label

@export var player : CharacterBody2D

func _input(event: InputEvent) -> void:
	if player in get_overlapping_bodies() and event.is_action_pressed("activate") and !activated:
		player.wall_climb = true
		activated = true
		Global.secrets_found += 1
		$AnimationPlayer.play("activate")
		directions.hide()

func _on_body_entered(_body: Node2D) -> void:
	if !activated:
		directions.show()

func _on_body_exited(_body: Node2D) -> void:
	if !activated:
		directions.hide()

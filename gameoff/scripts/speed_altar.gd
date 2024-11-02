extends Area2D

var activated := false

@onready var directions: Label = $Label
@onready var particles: Array[GPUParticles2D] = [$GPUParticles2D, $GPUParticles2D2]

@export var player : CharacterBody2D

func _input(event: InputEvent) -> void:
	if player in get_overlapping_bodies() and event.is_action_pressed("activate") and !activated:
		player.speed += 100
		activated = true
		$AnimationPlayer.play("activate")
		for i in particles:
			i.emitting = false
		directions.hide()

func _on_body_entered(_body: Node2D) -> void:
	if !activated:
		directions.show()

func _on_body_exited(_body: Node2D) -> void:
	if !activated:
		directions.hide()

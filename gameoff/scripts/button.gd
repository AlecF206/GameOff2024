extends Area2D

signal pressed

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label

@export var player : CharacterBody2D

var activated := false

func _on_body_entered(_body: Node2D) -> void:
	if !activated:
		sprite.material.set_shader_parameter("line_thickness", 0.25)
		label.show()

func _on_body_exited(_body: Node2D) -> void:
	if !activated:
		sprite.material.set_shader_parameter("line_thickness", 0)
		label.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("activate") and overlaps_body(player) and !activated:
		sprite.play("Press")
		pressed.emit()
		activated = true
		sprite.material.set_shader_parameter("line_thickness", 0)
		label.hide()

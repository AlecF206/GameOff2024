extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var player : CharacterBody2D
@export var damage := 10

func _ready() -> void:
	spike()

func spike():
	sprite.play("Spike")
	await get_tree().create_timer(.4, false).timeout
	set_collision_mask_value(2, true)
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1.5, false).timeout
	set_collision_mask_value(2, false)
	spike()

func _on_body_entered(body: Node2D) -> void:
	if sprite.frame != 0 and sprite.frame != 1 and sprite.frame != 10:
		body.take_damage(damage)

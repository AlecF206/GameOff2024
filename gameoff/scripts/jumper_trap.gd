extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var velocity : Vector2

func _on_body_entered(body: Node2D) -> void:
	sprite.play("Jump")
	await get_tree().create_timer(.4).timeout
	if body in get_overlapping_bodies():
		body.velocity += velocity

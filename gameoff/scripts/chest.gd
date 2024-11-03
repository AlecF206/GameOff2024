extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var flip := false

func _ready() -> void:
	if flip:
		sprite.flip_h = true

func _on_body_entered(_body: Node2D) -> void:
	sprite.play("GoldOpen")
	$CollisionShape2D.queue_free()
	Global.heart_parts += 1
	Global.secrets_found += 1
	await sprite.animation_finished
	queue_free()

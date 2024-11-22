extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var part : String
@export var flip := false

func _ready() -> void:
	if flip:
		sprite.flip_h = true

func _on_body_entered(_body: Node2D) -> void:
	sprite.play("GoldOpen")
	LabelSpawns.display_label("+25% game speed", global_position)
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.queue_free()
	Engine.time_scale += 0.25
	#Global.time_parts[part] = true
	Global.secrets_found += 1
	await sprite.animation_finished
	queue_free()

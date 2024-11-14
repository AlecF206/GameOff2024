extends Area2D

func _on_body_entered(body: Node2D) -> void:
	LabelSpawns.display_label("+50 health", global_position)
	body.health += 50
	queue_free()

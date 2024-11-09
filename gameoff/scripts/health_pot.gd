extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.health += 50
	queue_free()

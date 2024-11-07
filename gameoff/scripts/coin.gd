extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Global.secrets_found += 1
	queue_free()
	## - time or healing ##

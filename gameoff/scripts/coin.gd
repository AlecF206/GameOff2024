extends Area2D

@onready var ui := get_parent().get_parent().find_child("Player").find_child("CanvasLayer").get_child(0)

func _on_body_entered(_body: Node2D) -> void:
	LabelSpawns.display_label("-10 seconds", global_position)
	Global.secrets_found += 1
	ui.time -= 10
	queue_free()

extends StaticBody2D

@export var move_distance := Vector2(500, 0)
@export var end_wait_time := 0.0
@export var move_time := 3.0

func _ready() -> void:
	move()

func move():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position + move_distance, move_time)
	await tween.finished
	await get_tree().create_timer(end_wait_time, false).timeout
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position - move_distance, move_time)
	await tween.finished
	await get_tree().create_timer(end_wait_time, false).timeout
	move()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.find_child("CPUParticles2D").hide()

func _on_area_2d_body_exited(body: Node2D) -> void:
	body.find_child("CPUParticles2D").show()

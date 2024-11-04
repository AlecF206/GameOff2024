extends Area2D

@export var damage := 25
@export var moving := false
@export var move_distance : Vector2
@export var end_wait_time := 0
@export var move_time := 3

func _on_body_entered(body: Node2D) -> void:
	body.take_damage(damage)

func _ready() -> void:
	if moving:
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

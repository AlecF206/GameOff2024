extends StaticBody2D

@export var accel_factor := 2.5

func _on_icy_area_body_entered(body: Node2D) -> void:
	body.acceleration /= accel_factor
	body.decceleration /= accel_factor

func _on_icy_area_body_exited(body: Node2D) -> void:
	body.acceleration *= accel_factor
	body.decceleration *= accel_factor

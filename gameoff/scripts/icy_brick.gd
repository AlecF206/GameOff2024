extends StaticBody2D

const ICE_GRADIENT = preload("res://resources/IceGradient.tres")
const BRICK_GRADIENT = preload("res://resources/BrickGradient.tres")

@export var accel_factor := 2.5

func _on_icy_area_body_entered(body: Node2D) -> void:
	body.find_child("CPUParticles2D").color_initial_ramp = ICE_GRADIENT
	body.acceleration /= accel_factor
	body.decceleration /= accel_factor

func _on_icy_area_body_exited(body: Node2D) -> void:
	body.acceleration *= accel_factor
	body.decceleration *= accel_factor
	body.find_child("CPUParticles2D").color_initial_ramp = BRICK_GRADIENT

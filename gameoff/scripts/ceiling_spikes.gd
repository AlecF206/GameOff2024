extends Area2D

@export var damage := 25
@export var wait_time := 2


func _on_body_entered(body: Node2D) -> void:
	body.take_damage(damage)

func _ready() -> void:
	crush()

func crush():
	if $VisibleOnScreenNotifier2D.is_on_screen():
		Global.screen_shake.emit(35)
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("smash")
	await get_tree().create_timer(wait_time, false).timeout
	crush()

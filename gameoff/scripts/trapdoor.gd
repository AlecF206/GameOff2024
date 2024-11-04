extends StaticBody2D

var open := false

func open_door():
	if !open:
		$left.play("open")
		$right.play("open")
		set_collision_layer_value(1, false)
		open = true

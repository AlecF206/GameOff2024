extends Control

var time := 0:
	set(val):
		time = val
		var minutes = (floor(val / 60.0))
		var seconds = str(val - minutes * 60)
		if int(seconds) < 10:
			seconds = "0" + seconds
		if minutes != 0:
			time_string = str(minutes) + ":" + seconds
		else:
			time_string = str(seconds)

var time_string := "00:00"

@onready var time_label: Label = $Time

func _ready() -> void:
	set_timer()

func set_timer():
	time += 1
	time_label.text = "Time: " + time_string
	await get_tree().create_timer(1).timeout
	set_timer()

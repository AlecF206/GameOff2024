extends Control

@onready var time_label: Label = $Time
@onready var health_bar: TextureProgressBar = $MarginContainer/TextureProgressBar
@onready var clock_rect: TextureRect = $HBoxContainer/Clock

const clock_black = preload("res://assets/AmuletOfTime/clock4.png")
const clock = preload("res://resources/clock_animation.tres")

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

func _ready() -> void:
	Global.update_secrets.connect(set_parts)
	set_timer()

func set_timer():
	time += 1
	time_label.text = "Time: " + time_string
	await get_tree().create_timer(1 * Engine.time_scale).timeout
	set_timer()

func set_health(hp: float):
	health_bar.value = hp + 10

func set_parts():
	if Global.time_parts["clock"]:
		clock_rect.texture = clock

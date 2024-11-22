extends Control

@onready var time_label: Label = $Time
@onready var health_bar: TextureProgressBar = $MarginContainer/TextureProgressBar
@onready var clock_rect: TextureRect = $HBoxContainer/Clock
@onready var secret_count: Label = $HBoxContainer/VBoxContainer/SecretCount
@onready var milestone_screen: VBoxContainer = $HBoxContainer2/MilestoneScreen
@onready var milestone_label: Label = $HBoxContainer2/MilestoneScreen/Label
@onready var leaderboard: VBoxContainer = $HBoxContainer2/LeaderboardContainer/Leaderboard
@onready var line_edit: LineEdit = $HBoxContainer2/MilestoneScreen/LineEdit
@onready var leaderboard_container: VBoxContainer = $HBoxContainer2/LeaderboardContainer
@onready var settings: VBoxContainer = $HBoxContainer2/Settings

@export var max_secrets := 4

var milestone_showing := false

const clock_black = preload("res://assets/AmuletOfTime/clock4.png")
const clock = preload("res://resources/clock_animation.tres")

var player_name := ""
var score_submitted := false

var time := 0:
	set(val):
		time = clamp(val, 0, 10000000)
		time_string = get_time_string(time)

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		if milestone_showing:
				_on_continue_pressed()
				return
		if get_tree().paused == false:
			leaderboard_container.show()
			settings.show()
			update_leaderboard(3)
			get_tree().paused = true
		else:
			settings.hide()
			leaderboard_container.hide()
			get_tree().paused = false

func get_time_string(val: int) -> String:
	var func_time_string := "00:00"
	var minutes = (floor(val / 60.0))
	var seconds = str(val - minutes * 60)
	if int(seconds) < 10:
		seconds = "0" + seconds
	if minutes != 0:
		func_time_string = str(minutes) + ":" + seconds
	else:
		func_time_string = str(seconds)
	return func_time_string

var time_string := "00:00"

func _ready() -> void:
	Global.update_secrets.connect(set_secrets)
	set_timer()
	set_secrets()

func set_timer():
	if !get_tree().paused:
		time += 1
	time_label.text = "Time: " + time_string
	await get_tree().create_timer(1 * Engine.time_scale).timeout
	set_timer()

func set_health(hp: float):
	var tween = get_tree().create_tween()
	tween.tween_property(health_bar, "value", hp + 10, 0.2).set_ease(Tween.EASE_IN_OUT)

func set_secrets():
	secret_count.text = str(Global.secrets_found) + "/" + str(max_secrets)
	if Global.secrets_found % 3 == 0 and Global.secrets_found != 0:
		get_tree().paused = true
		milestone_screen.show()
		leaderboard_container.show()
		milestone_showing = true
		await get_tree().create_timer(.05).timeout
		milestone_label.text = "You Collected\n" + str(Global.secrets_found) + " Secrets In " + time_string + "!"
		update_leaderboard(Global.secrets_found)

func _on_continue_pressed() -> void:
	score_submitted = false
	get_tree().paused = false
	milestone_screen.hide()
	leaderboard_container.hide()
	milestone_showing = false

func update_leaderboard(lnum : int):
	for child in leaderboard.get_children():
		child.queue_free()
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(8, str(lnum)).sw_get_scores_complete
	var num = 0
	for score in sw_result.scores:
		var new_label = Label.new()
		new_label.set("theme_override_font_sizes/font_size", 30)
		new_label.set("theme_override_colors/font_color", "white")
		new_label.text = str(num + 1) + ". " + str(sw_result.scores[num].player_name) + ": " + get_time_string(-int(sw_result.scores[num].score))
		leaderboard.add_child(new_label)
		num += 1
		await get_tree().create_timer(.001).timeout

func _on_submit_pressed() -> void:
	var input_text = line_edit.text
	player_name = input_text
	if player_name != "" and !score_submitted:
		score_submitted = true
		SilentWolf.Scores.save_score(player_name, -time, str(Global.secrets_found))
		await get_tree().create_timer(.2).timeout
		update_leaderboard(Global.secrets_found)

func _on_button_pressed() -> void:
	update_leaderboard(3)

func _on_button_2_pressed() -> void:
	update_leaderboard(6)

func _on_button_3_pressed() -> void:
	update_leaderboard(9)

func _on_button_4_pressed() -> void:
	update_leaderboard(12)

func _on_check_box_3_toggled(toggled_on: bool) -> void:
	AudioManager.click()
	match toggled_on:
		true : DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		false: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_check_box_2_toggled(toggled_on: bool) -> void:
	AudioManager.click()
	AudioServer.set_bus_mute(0,toggled_on)

func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioManager.click()
	Global.screenshake = toggled_on

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value - 50)

extends Control

@onready var time_label: Label = $Time
@onready var health_bar: TextureProgressBar = $MarginContainer/TextureProgressBar
@onready var clock_rect: TextureRect = $HBoxContainer/Clock
@onready var secret_count: Label = $HBoxContainer/VBoxContainer/SecretCount
@onready var milestone_screen: HBoxContainer = $HBoxContainer2
@onready var milestone_label: Label = $HBoxContainer2/MilestoneScreen/Label
@onready var leaderboard: VBoxContainer = $HBoxContainer2/LeaderboardContainer/Leaderboard
@onready var line_edit: LineEdit = $HBoxContainer2/MilestoneScreen/LineEdit

@export var max_secrets := 4

const clock_black = preload("res://assets/AmuletOfTime/clock4.png")
const clock = preload("res://resources/clock_animation.tres")

var player_name := ""
var score_submitted := false

var time := 0:
	set(val):
		time = clamp(val, 0, 10000000)
		time_string = get_time_string(time)

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
	health_bar.value = hp + 10

func set_secrets():
	secret_count.text = str(Global.secrets_found) + "/" + str(max_secrets)
	if Global.secrets_found % 3 == 0 and Global.secrets_found != 0:
		get_tree().paused = true
		milestone_screen.show()
		milestone_label.text = "You Collected\n" + str(Global.secrets_found) + " Secrets In " + time_string + "!"
		update_leaderboard(Global.secrets_found)

func _on_continue_pressed() -> void:
	score_submitted = false
	get_tree().paused = false
	milestone_screen.hide()

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
		await get_tree().create_timer(.01).timeout

func _on_submit_pressed() -> void:
	var input_text = line_edit.text
	player_name = input_text
	if player_name != "" and !score_submitted:
		score_submitted = true
		SilentWolf.Scores.save_score(player_name, -time, str(Global.secrets_found))
		await get_tree().create_timer(.1).timeout
		update_leaderboard(Global.secrets_found)

func _on_button_pressed() -> void:
	update_leaderboard(3)

func _on_button_2_pressed() -> void:
	update_leaderboard(6)

func _on_button_3_pressed() -> void:
	update_leaderboard(9)

func _on_button_4_pressed() -> void:
	update_leaderboard(12)

extends Node

signal update_secrets

var secrets_found := 0:
	set(val):
		secrets_found = val
		update_secrets.emit()

func _ready() -> void:
	SilentWolf.configure({
		"api_key": "eAdJkMD6iRZUtdP3TWAE2yJU9dN23Qu6v2bDeQk7",
		"game_id": "secrethunter",
		"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tscn"
	})

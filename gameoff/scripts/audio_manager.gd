extends Node

func _ready() -> void:
	loop()

func heal():
	$Heal.play()

func coin():
	$Coin.play()

func loop():
	$Loop.play()

extends Node

@onready var loops : Array[AudioStreamPlayer] = [$Loop1, $Loop2, $Loop3, $Loop4]

func _ready() -> void:
	loop()

func heal():
	$Heal.play()

func coin():
	$Coin.play()

func loop():
	loops.pick_random().play()

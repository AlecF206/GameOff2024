extends Node

signal update_secrets

var secrets_found := 0:
	set(val):
		secrets_found = val
		update_secrets.emit()
		update_time_scale()

var time_parts := {"clock": false, "heart": false}

func update_time_scale():
	var parts_collected := 0
	for i in time_parts:
		parts_collected += int(time_parts[i])
	Engine.time_scale = 1 + 0.2 * parts_collected
	print(Engine.time_scale)
